# pyRevit Development

Assistente per lo sviluppo di estensioni pyRevit con engine CPython 3.

## Scope

Questa skill supporta lo sviluppo di:
- Script pyRevit (pushbutton, pulldown, toggle, smartbutton)
- UI con `pyrevit.forms` (SelectFromList, CommandSwitchWindow, alert, pick)
- Interazione con Revit API via wrapper pyRevit
- Hook e event handler
- Estensioni complete con struttura corretta

## NON fa

- Non genera codice IronPython 2.7 (engine deprecato)
- Non usa Windows Forms o WPF direttamente (usa `pyrevit.forms`)
- Non modifica il codice sorgente di pyRevit stesso

## Engine e compatibilita

**Engine: CPython 3** (default per pyRevit 4.8+)

Verifiche obbligatorie prima di scrivere codice:
- Conferma engine nel file `script.py` o nella config dell'estensione
- CPython 3: syntax moderna, f-string, type hints, pathlib OK
- Se il progetto usa IronPython 2.7: STOP e segnala all'utente

## Struttura estensione

```
NomeEstensione.extension/
├── NomeEstensione.tab/
│   ├── NomePanel.panel/
│   │   ├── NomeComando.pushbutton/
│   │   │   ├── script.py
│   │   │   ├── icon.png          # 32x32 o 16x16
│   │   │   └── bundle.yaml       # opzionale: tooltip, author
│   │   ├── AltroComando.pushbutton/
│   │   │   └── script.py
│   │   └── Gruppo.pulldown/
│   │       ├── Sotto1.pushbutton/
│   │       │   └── script.py
│   │       └── Sotto2.pushbutton/
│   │           └── script.py
│   └── AltroPanel.panel/
│       └── ...
├── lib/                          # moduli condivisi
│   └── utils.py
├── hooks/                        # event hooks
│   └── doc-opened.py
└── extension.json
```

## Pattern fondamentali

### Transaction (OBBLIGATORIO per modifiche al modello)

```python
from pyrevit import revit, DB

with revit.Transaction("Descrizione operazione"):
    # modifiche al modello qui
    wall.get_Parameter(DB.BuiltInParameter.WALL_USER_HEIGHT_PARAM).Set(3.0)
```

SEMPRE con context manager. MAI transaction manuale senza try/except.

### Selezione elementi

```python
from pyrevit import revit

# selezione corrente
selection = revit.get_selection()
elements = selection.elements

# filtro per categoria
from pyrevit import DB
doc = revit.doc
walls = DB.FilteredElementCollector(doc)\
    .OfCategory(DB.BuiltInCategory.OST_Walls)\
    .WhereElementIsNotElementType()\
    .ToElements()
```

### Parametri

```python
from pyrevit import DB

# BuiltInParameter: SEMPRE con DB.BuiltInParameter.NOME_ENUM
param = element.get_Parameter(DB.BuiltInParameter.ALL_MODEL_INSTANCE_COMMENTS)
if param and param.HasValue:
    value = param.AsString()

# parametro condiviso per nome
param = element.LookupParameter("Nome_Parametro")
if param:
    if param.StorageType == DB.StorageType.String:
        value = param.AsString()
    elif param.StorageType == DB.StorageType.Double:
        value = param.AsDouble()  # unita interne (feet)
    elif param.StorageType == DB.StorageType.Integer:
        value = param.AsInteger()
    elif param.StorageType == DB.StorageType.ElementId:
        value = param.AsElementId()
```

### UI con pyrevit.forms

```python
from pyrevit import forms

# selezione da lista
selected = forms.SelectFromList.show(
    ["Opzione A", "Opzione B", "Opzione C"],
    title="Seleziona",
    multiselect=True
)

# switch rapido (restituisce l'opzione scelta, o None se annullato)
choice = forms.CommandSwitchWindow.show(
    ["Muri", "Porte", "Finestre"],
    message="Categoria:"
)

# alert (title opzionale, ok=True mostra bottone OK, yes/no per conferme)
forms.alert("Operazione completata!", title="Info")
conferma = forms.alert("Procedere con l'eliminazione?", title="Conferma", yes=True, no=True)

# pick file / pick folder
filepath = forms.pick_file(file_ext="csv", title="Seleziona CSV")
filepaths = forms.pick_file(file_ext="csv", multi_file=True)  # selezione multipla
folder = forms.pick_folder()

# input testuale semplice
nome = forms.ask_for_string(default="", prompt="Inserisci il nome:", title="Input")

# progress bar (context manager, cancellable e indeterminate opzionali)
with forms.ProgressBar(title="Elaborazione... ({value} di {max_value})", cancellable=True) as pb:
    for i, elem in enumerate(elements):
        if pb.cancelled:
            break
        # lavoro
        pb.update_progress(i, len(elements))
```

Nota: `forms.SelectFromList.show`, `forms.CommandSwitchWindow.show`, `forms.alert`, `forms.pick_file`/`pick_folder`, `forms.ask_for_string` e `forms.ProgressBar` sono le API stabili documentate in `pyrevitlib/pyrevit/forms/__init__.py` del repo ufficiale [pyrevitlabs/pyRevit](https://github.com/pyrevitlabs/pyRevit). Se un nome funzione non e certo, verificare nel modulo installato (`forms.__init__.py`) prima di usarlo — non inventare parametri.

### Output

```python
from pyrevit import script

output = script.get_output()
output.print_md("# Report")
output.print_md("**Elementi trovati:** {}".format(len(elements)))
output.print_table(
    table_data=rows,
    columns=["ID", "Nome", "Livello", "Valore"],
    title="Risultati"
)
```

### bundle.yaml (metadata del singolo comando)

Facoltativo dentro ogni cartella `.pushbutton`/`.pulldown`/`.panel`, controlla titolo, tooltip, autore, disponibilita contestuale:

```yaml
# bundle.yaml
title: 'Trasferisci Parametri'
tooltip: >
  Copia i valori di un parametro da elementi sorgente a elementi target
  in base a un criterio di corrispondenza.
author: 'Nome Cognome'
min_revit_version: '2022'
context: 'selection'          # attivo solo con elementi selezionati
highlight: 'new'               # pallino "new" nell'UI (rimuovere dopo release)
```

`context` supporta anche `'zerodoc'` (comando disponibile senza documento aperto) o liste di categorie/classi per limitare la disponibilita del bottone. La disponibilita contestuale via `__context__` puo anche essere definita direttamente in `script.py` come variabile modulo, in alternativa al bundle.yaml.

### extension.json (metadata a livello di estensione, opzionale)

Va nella radice di `NomeEstensione.extension/`, usato per pubblicare l'estensione nel registro pyRevit o per Rocket Mode:

```json
{
    "name": "VisionXtools",
    "description": "Tool BIM per il workflow VisionXt",
    "author": "VisionXt",
    "url": "https://github.com/org/VisionXtools.extension.git",
    "rocket_mode_compatible": true
}
```

## Anti-pattern

| Errore | Correzione |
|--------|------------|
| `BuiltInParameter("WALL_HEIGHT")` string lookup | `DB.BuiltInParameter.WALL_USER_HEIGHT_PARAM` enum |
| Transaction senza context manager | `with revit.Transaction("desc"):` |
| `import clr` per UI | Usare `pyrevit.forms` |
| Unita in metri nei Set() | Convertire in feet: `meters * 3.28084` o `UnitUtils.ConvertToInternalUnits()` |
| `doc.ActiveView` per filtri | Passare vista solo se necessario, default e tutto il documento |
| `print()` per output | `script.get_output()` per report formattati |
| Filtro senza `.WhereElementIsNotElementType()` | Aggiungere sempre per ottenere istanze, non tipi |
| Selezione multipla gestita come singolo elemento | `forms.SelectFromList.show(..., multiselect=True)` restituisce SEMPRE una lista (o `None` se annullato) |
| Path assoluti hardcoded nello script | Usare `forms.pick_file()`/`pick_folder()` o config dell'estensione |
| Ignorare `pb.cancelled` in un `ProgressBar(cancellable=True)` | Controllare il flag ad ogni iterazione per interrompere in modo pulito |

## Regole tassative

1. **Engine CPython 3** — verifica SEMPRE prima di scrivere codice
2. **BuiltInParameter** — SEMPRE enum, MAI string lookup
3. **Transaction** — SEMPRE con `with revit.Transaction()`
4. **Unita** — Revit usa piedi internamente, convertire sempre
5. **UI** — SEMPRE `pyrevit.forms`, mai WPF/WinForms diretto
6. **Selezione** — controllare SEMPRE se la selezione e vuota prima di procedere
7. **Parametro nullo** — controllare SEMPRE `if param and param.HasValue`

## MCP Server consigliati (opzionali)

| Server | Cosa aggiunge | Installazione |
|--------|--------------|---------------|
| **Autodesk Revit MCP Server** (ufficiale, consigliato dove disponibile) | Query/report live, editing bulk parametri, snapshot viste — via Autodesk Assistant | Solo Revit 2027, Tech Preview — [guida ufficiale](https://help.autodesk.com/view/ADSKMCP/ENU/?guid=ADSKMCP_RevitMcp_setting_up_revit_mcp_server_html) |
| **RevitCortex** | Query live su elementi, parametri, viste (alternativa community, Revit 2023-2027) | [GitHub](https://github.com/LuDattilo/RevitCortex) |
| **Demolinator Revit MCP** | 48 tool via pyRevit (alternativa leggera, Revit 2024-2027) | [GitHub](https://github.com/Demolinator/revit-mcp-server) |

Senza MCP server, l'agente genera codice pyRevit che l'utente esegue manualmente in Revit. Con un MCP server attivo, puo anche interrogare il modello per contesto.

Vedi `docs/mcp-setup.md` per la configurazione.

## Limiti

- pyRevit non supporta async/await (Revit API e single-threaded)
- Alcune API Revit richiedono contesto di vista attiva
- Performance: `FilteredElementCollector` e sempre preferibile a loop manuale
- Hook: limitati agli eventi supportati da pyRevit (doc-opened, doc-closing, etc.)
