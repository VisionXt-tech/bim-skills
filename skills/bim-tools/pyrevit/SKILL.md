---
name: pyrevit
description: >-
  Sviluppo rapido ed enterprise di estensioni BIM, comandi Ribbon e script Python (CPython 3 / PythonNet) per Autodesk Revit
  tramite pyRevit. Usare per pushbutton, smartbutton, menu pulldown, interfacce dinamiche pyrevit.forms/XAML,
  hook di evento (pre-sync, pre-save), report interattivi linkify e integrazione librerie Python (pandas, openpyxl, requests).
---

# BIM pyRevit Extension Development & CPython 3 Automation

Guida specialistica per lo sviluppo rapido ed enterprise di estensioni, pulsanti Ribbon e script di automazione per **Autodesk Revit** tramite il framework open-source **pyRevit**, utilizzando l'engine moderno **CPython 3 (PythonNet 3)**. Copre l'architettura dei bundle, la gestione delle transazioni, la creazione di interfacce utente native con `pyrevit.forms` e XAML, gli hook di validazione pre-salvataggio e la generazione di report interattivi collegati direttamente agli elementi del modello.

---

## Scope

Questa skill fornisce pattern architetturali e codice production-ready per:
- **Architettura dei Bundle pyRevit**: strutturazione gerarchica di `.extension`, `.tab`, `.panel`, `.pushbutton`, `.smartbutton`, `.pulldown`, `.splitbutton` e `.urlbutton`.
- **Engine CPython 3**: supporto alla sintassi moderna Python 3.10+, type hints, `pathlib`, f-string e importazione di moduli esterni da virtualenv (`pandas`, `openpyxl`, `requests`).
- **Gestione Transazionale e Modifiche al DB**: utilizzo del context manager `revit.Transaction` e `revit.TransactionGroup` con assimilazione delle modifiche.
- **Interfacce Utente Dinamiche (`pyrevit.forms`)**: finestre di dialogo standard (`SelectFromList`, `CommandSwitchWindow`, `alert`, `pick_file`, `ProgressBar`) e GUI custom XAML (`forms.WPFWindow`).
- **Reporting Avanzato e Navigazione Modello (`pyrevit.script`)**: finestre di output formattate in Markdown/HTML, tabelle interattive e collegamenti ipertestuali dinamici agli elementi del modello (`output.linkify(element_id)`).
- **Automazione degli Eventi (*Event Hooks*)**: intercettazione di eventi Revit (`doc-opened`, `doc-saving`, `doc-synced`) per controlli di qualità bloccanti pre-sincronizzazione.
- **Configurazione e Metadati**: gestione di `bundle.yaml` (contesti di attivazione, icone, tooltip, autorizzazioni) e `extension.json`.

---

## NON fa

- Non genera codice legacy per IronPython 2.7 (linguaggio e runtime deprecati, privi di supporto alle moderne librerie Python).
- Non esegue modifiche dirette al database Revit al di fuori di un blocco `with revit.Transaction`.
- Non compila assembly DLL binarie (esegue script interpretati al volo da pyRevit).

---

## Struttura Gerarchica dell'Estensione pyRevit

```
NomeEstensione.extension/
├── extension.json                    # Metadati globali dell'estensione
├── lib/                              # Moduli e librerie Python condivise
│   ├── __init__.py
│   ├── db_queries.py                 # Query e filtri riutilizzabili
│   └── excel_exporter.py
├── hooks/                            # Script eseguiti su eventi globali di Revit
│   ├── doc-opened.py                 # Eseguito all'apertura del modello
│   └── doc-saving.py                 # Eseguito prima del salvataggio (controllo QA/QC)
└── NomeEstensione.tab/                # Scheda Ribbon personalizzata
    └── QualitaDati.panel/            # Pannello Ribbon
        ├── ValidaParametri.pushbutton/
        │   ├── bundle.yaml           # Configurazione comando e contesto
        │   ├── icon.png              # Icona 32x32 o 16x16 PNG
        │   └── script.py             # Codice Python del comando
        ├── StrumentiAvanzati.pulldown/
        │   ├── SottoComandoA.pushbutton/
        │   │   └── script.py
        │   └── SottoComandoB.pushbutton/
        │       └── script.py
        └── ToggleControllo.smartbutton/
            ├── icon.png
            └── script.py             # Bottone bistabile con stato on/off
```

---

## Pattern di Programmazione Fondamentali

### 1. Script PushButton Standard con Transazione e Filtro Nativo

```python
# -*- coding: utf-8 -*-
"""
Nome: Popola Parametri WBS
Descrizione: Assegna il codice WBS a tutti i muri del livello selezionato.
Autore: BIM Skills Italia
"""

from pyrevit import revit, DB, forms, script

# Inizializzazione contesto
doc = revit.doc
output = script.get_output()

# 1. Selezione del Livello tramite interfaccia grafica
levels = DB.FilteredElementCollector(doc)\
    .OfClass(DB.Level)\
    .WhereElementIsNotElementType()\
    .ToElements()

level_dict = {lvl.Name: lvl for lvl in levels}
selected_level_name = forms.SelectFromList.show(
    sorted(level_dict.keys()),
    title="Seleziona Livello di Progetto",
    multiselect=False
)

if not selected_level_name:
    script.exit()

target_level = level_dict[selected_level_name]

# 2. Input del Codice WBS
wbs_code = forms.ask_for_string(
    default="WBS.STR.01",
    prompt=f"Inserisci il codice WBS per il livello {selected_level_name}:",
    title="Input WBS"
)

if not wbs_code:
    script.exit()

# 3. Raccolta Muri del Livello con Filtro Nativo Rapido
level_filter = DB.ElementLevelFilter(target_level.Id)
walls = DB.FilteredElementCollector(doc)\
    .OfCategory(DB.BuiltInCategory.OST_Walls)\
    .WhereElementIsNotElementType()\
    .WherePasses(level_filter)\
    .ToElements()

if not walls:
    forms.alert(f"Nessun muro trovato al livello {selected_level_name}.", title="Attenzione")
    script.exit()

# 4. Modifica Transazionale con Barra di Avanzamento
updated_count = 0
with revit.Transaction(f"Assegna WBS al livello {selected_level_name}"):
    with forms.ProgressBar(title="Aggiornamento elementi... ({value} di {max_value})", cancellable=True) as pb:
        for i, wall in enumerate(walls):
            if pb.cancelled:
                break

            param = wall.LookupParameter("Codice_WBS")
            if param and not param.IsReadOnly:
                param.Set(wbs_code)
                updated_count += 1

            pb.update_progress(i + 1, len(walls))

# 5. Output Report Formattato con Link Interattivo agli Elementi
output.print_md(f"# Risultato Operazione: {selected_level_name}")
output.print_md(f"**Elementi aggiornati con successo:** {updated_count} / {len(walls)}")

report_rows = []
for wall in walls[:10]:  # Mostra i primi 10
    report_rows.append([
        output.linkify(wall.Id),  # Cliccando sul link l'elemento viene selezionato in Revit
        wall.Name,
        wbs_code
    ])

output.print_table(
    table_data=report_rows,
    columns=["Element ID", "Nome Famiglia/Tipo", "Codice WBS Assegnato"],
    title="Anteprima Elementi Modificati"
)
```

---

### 2. Creazione di Finestre di Dialogo Custom in XAML/WPF (`forms.WPFWindow`)

Quando i form preconfezionati non bastano, pyRevit consente di collegare un file XAML nativo a una classe Python:

#### File XAML (`UIWindow.xaml`):
```xml
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Configuratore Parametri CAM" Height="220" Width="360"
        WindowStartupLocation="CenterScreen" ResizeMode="NoResize">
    <Grid Margin="15">
        <StackPanel>
            <TextBlock Text="Percentuale Contenuto Riciclato Minimo (%):" FontWeight="Bold" Margin="0,0,0,5"/>
            <TextBox x:Name="txtRecycled" Text="15.0" Margin="0,0,0,15"/>
            
            <CheckBox x:Name="chkDisassembly" Content="Imponi disassemblabilità >= 70%" IsChecked="True" Margin="0,0,0,20"/>
            
            <Button x:Name="btnApply" Content="Applica Modifiche" Height="30" Click="on_apply_clicked"/>
        </StackPanel>
    </Grid>
</Window>
```

#### File Python (`script.py`):
```python
from pyrevit import forms, revit, DB

class CamConfigWindow(forms.WPFWindow):
    def __init__(self, xaml_file_name):
        forms.WPFWindow.__init__(self, xaml_file_name)
        self.recycled_value = None

    def on_apply_clicked(self, sender, args):
        try:
            self.recycled_value = float(self.txtRecycled.Text)
            self.disassembly_required = self.chkDisassembly.IsChecked
            self.Close()
        except ValueError:
            forms.alert("Inserire un valore numerico valido.", title="Errore")

win = CamConfigWindow("UIWindow.xaml")
win.ShowDialog()

if win.recycled_value is not None:
    forms.alert(f"Valore impostato: {win.recycled_value}%", title="Successo")
```

---

### 3. Event Hook Pre-Salvataggio: Controllo QA/QC Bloccante (`doc-saving.py`)

Gli hook consentono di imporre la conformità aziendale o di commessa. Se posizionato in `hooks/doc-saving.py`, questo script intercetta ogni comando di salvataggio:

```python
from pyrevit import EXEC_PARAMS, DB, forms

doc = EXEC_PARAMS.event_args.Document

# Controlla se esistono muri senza parametro "Codice_WBS"
unassigned_walls = []
walls = DB.FilteredElementCollector(doc)\
    .OfCategory(DB.BuiltInCategory.OST_Walls)\
    .WhereElementIsNotElementType()\
    .ToElements()

for w in walls:
    p = w.LookupParameter("Codice_WBS")
    if not p or not p.HasValue or not p.AsString().strip():
        unassigned_walls.append(w.Id)

if unassigned_walls:
    # Mostra allerta all'utente
    res = forms.alert(
        f"Attenzione! Rilevati {len(unassigned_walls)} muri privi di parametro 'Codice_WBS'.\n"
        "Procedere comunque con il salvataggio?",
        title="Controllo Qualità Informativa",
        yes=True, no=True
    )
    if not res:
        # Cancella l'operazione di salvataggio in Revit
        EXEC_PARAMS.event_args.Cancel()
```

---

### 4. bundle.yaml: Configurazione Avanzata del Comando

```yaml
title: "Verifica\nCAM Edilizia"
tooltip: >
  Esegue la scansione dei materiali del modello attivo e verifica
  la rispondenza alle percentuali di riciclato previste dal D.M. 24/11/2025.
author: "BIM Skills Italia"
min_revit_version: "2022"
max_revit_version: "2026"
context: "zerodoc"             # Disponibile anche senza documenti aperti
help_url: "https://github.com/VisionXt-tech/bim-skills"
highlight: "new"               # Mostra pallino di evidenziazione UI
```

---

## Anti-pattern nello Sviluppo pyRevit

| Errore Comune | Conseguenza | Soluzione Corretta |
| :--- | :--- | :--- |
| **`import clr` con interfacce WinForms/WPF manuali** | Disallineamento grafico, crash di threading e finestre fantasma | Usare sempre `pyrevit.forms` o `forms.WPFWindow`. |
| **Usare `print()` standard per l'output** | Output non formattato, testo perso o finestra anonima | Usare `script.get_output()` con Markdown, tabelle e linkify. |
| **Scrivere parametri di lunghezza in metri direttamente** | Dimensioni errate nel database Revit (1 metro salvato come 3.28 piedi) | Convertire sempre tramite `DB.UnitUtils.ConvertToInternalUnits(val, DB.UnitTypeId.Meters)`. |
| **Omessa gestione di `pb.cancelled` in ProgressBar** | L'utente preme "Annulla" ma lo script continua a girare all'infinito | Inserire `if pb.cancelled: break` all'interno di ogni iterazione del loop. |
| **Modificare il modello fuori da `with revit.Transaction`** | Eccezione immediata `InvalidOperationException` sollevata da Revit | Avvolgere sempre le modifiche nel context manager della transazione. |

---

## Output Strutturato

Quando invocata, la skill fornisce:
1. **Script Python Completi (`script.py`)** con gestione eccezioni, barra di progresso e transazioni.
2. **File di Configurazione `bundle.yaml`** con icone, contesti e tooltip formattati.
3. **Template XAML per Finestre WPF Custom**.
4. **Script di Hook per Eventi Globali (`hooks/`)** per il controllo automatico dei gate informativi.
