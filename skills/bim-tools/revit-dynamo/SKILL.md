---
name: revit-dynamo
description: >-
  Sviluppo avanzato di grafi visuali, nodi Python (CPython 3 / PythonNet3 su .NET 8) e DesignScript per automazioni BIM in Dynamo for Revit.
  Usare per automazione di task ripetitivi, manipolazione data tree e livelli di lista (@L2/@L3), conversione geometrica
  RevitNodes (ToRevitType/ToProtoType), TransactionManager e predisposizione per Dynamo Player / Generative Design.
---

# BIM Dynamo for Revit & Computational Scripting

Guida specialistica di riferimento per lo sviluppo di grafi visuali, logiche algoritmiche **DesignScript** e nodi script **Python (CPython 3 e PythonNet3 su .NET 8)** all'interno dell'ambiente **Dynamo for Revit** (Dynamo 2.13+ e Dynamo 3.x per Revit 2024, 2025 e 2026).

---

## Scope

Questa skill guida la progettazione e il debug di algoritmi computazionali per il BIM:
- **Nodi Python Avanzati (CPython 3 / PythonNet3)**: gestione corretta delle reference .NET, interazione con `DocumentManager`, `TransactionManager` e gestione delle eccezioni.
- **Transizione a PythonNet3 (.NET 8 in Revit 2025+)**: supporto alle differenze di casting, ereditarietà `super().__init__()`, collezioni .NET non implicite e passaggio parametri `ref/out`.
- **Conversione Geometrica Bidirezionale (`RevitNodes`)**: conversione fluida tra geometria astratta Dynamo (`Autodesk.DesignScript.Geometry`) ed entità native Revit (`Autodesk.Revit.DB`) tramite i metodi di estensione **`ToRevitType()`** e **`ToProtoType()`**.
- **Gestione dei Wrapper e Unwrapping**: corretta manipolazione di `UnwrapElement()` ed estrazione delle istanze native Revit dai nodi grafici.
- **DesignScript e Gestione Avanzata dei Data Tree**: sintassi imperativa (`[Imperative]`), Replication Guides (`<1>`, `<2>`), List Lacing e livelli di lista (`@L1`, `@L2`, `@L3`).
- **Predisposizione per Dynamo Player e Generative Design**: marcatura corretta dei nodi come input (`IsInput = True`) e output prestazionali (`IsOutput = True`).

---

## NON fa

- Non genera file grafici binari `.dyn` compilati (fornisce il codice Python dei nodi, le espressioni DesignScript e le istruzioni di cablaggio dei nodi).
- Non installa pacchetti terzi automaticamente all'interno dell'installazione locale di Revit (elenca i package indispensabili: archi-lab, Rhythm, Clockwork, Genius Loci).
- Non esegue modifiche sul modello senza l'uso del `TransactionManager` di Dynamo.

---

## Matrice Engine Python in Dynamo (Revit 2022 - 2026)

| Versione Revit | Versione Dynamo | Engine Python Predefinito | Runtime .NET Sottostante | Note Architetturali |
| :---: | :---: | :---: | :---: | :--- |
| **Revit 2022-2023** | Dynamo 2.12 - 2.16 | **CPython 3** / IronPython 2.7 | .NET Framework 4.8 | Passaggio da IronPython a CPython 3 nativo. |
| **Revit 2024** | Dynamo 2.18 - 2.19 | **CPython 3** | .NET Framework 4.8 | `ElementId.Value` a 64 bit introdotto nelle API. |
| **Revit 2025** | **Dynamo 3.0 - 3.2** | **PythonNet3** (CPython 3.11) | **.NET 8.0 (CoreCLR)** | **Nuovo engine PythonNet3**: collezioni .NET esplicite, no GAC. |
| **Revit 2026** | **Dynamo 3.3+** | **PythonNet3** | **.NET 8.0 (CoreCLR)** | Totale adozione PythonNet3; IronPython non più supportato. |

> [!IMPORTANT]
> **Differenze Critiche in PythonNet3 (Dynamo 3.x / Revit 2025+)**:
> 1. Le collezioni .NET (es. `IList<ElementId>`) restituite dall'API Revit non sono più liste Python native: per eseguire slice o `.append()`, convertirle esplicitamente con `list(collezione)`.
> 2. I metodi con parametri `out` o `ref` restituiscono una tupla contenente il valore di ritorno e i valori modificati.
> 3. Se una classe custom eredita da un tipo .NET, è obbligatorio richiamare esplicitamente `super().__init__()`.

---

## Template Robusto per Nodo Python (CPython 3 / PythonNet3)

Questo template gestisce automaticamente input singoli o a lista, transazioni protette e restituzione di log di errore:

```python
# -*- coding: utf-8 -*-
import sys
import clr

# 1. Riferimenti Assembly Revit e Dynamo
clr.AddReference('RevitAPI')
clr.AddReference('RevitAPIUI')
clr.AddReference('RevitServices')
clr.AddReference('RevitNodes')

# 2. Import Namespace
import Autodesk.Revit.DB as DB
from RevitServices.Persistence import DocumentManager
from RevitServices.Transactions import TransactionManager

# Metodi di estensione per geometria (ToRevitType / ToProtoType)
clr.ImportExtensions(Revit.GeometryConversion)
clr.ImportExtensions(Revit.Elements)

# 3. Contesto Documento
doc = DocumentManager.Instance.CurrentDBDocument
uiapp = DocumentManager.Instance.CurrentUIApplication
app = uiapp.Application

# 4. Helper per Normalizzazione Input (Singolo vs Lista)
def to_list(data):
    if data is None:
        return []
    if isinstance(data, list):
        return data
    return [data]

# Input da Dynamo
raw_elements = IN[0]
param_name = str(IN[1]) if IN[1] else "Codice_WBS"
param_value = str(IN[2]) if IN[2] else ""

# Unwrap degli elementi Dynamo in entità native Revit
elements = [UnwrapElement(e) for e in to_list(raw_elements) if e is not None]

success_elements = []
errors = []

# 5. Esecuzione Transazionale Sicura tramite TransactionManager
TransactionManager.Instance.EnsureInTransaction(doc)

try:
    for elem in elements:
        try:
            # Verifica parametro
            param = elem.LookupParameter(param_name)
            if param and not param.IsReadOnly:
                param.Set(param_value)
                # Conversione in elemento wrapper Dynamo per l'output
                success_elements.append(elem.ToDSType(True))
            else:
                errors.append(f"Elemento {elem.Id}: Parametro '{param_name}' mancante o sola lettura")
        except Exception as ex:
            errors.append(f"Elemento {elem.Id}: {str(ex)}")

    # Convalida della transazione
    TransactionManager.Instance.TransactionTaskDone()

except Exception as global_ex:
    # Annulla in caso di errore critico
    TransactionManager.Instance.ForceCloseTransaction()
    errors.append(f"Errore Globale Transazione: {str(global_ex)}")

# 6. Output Strutturato (Dati + Log)
OUT = [success_elements, errors]
```

---

## Conversione Geometrica con `RevitNodes`

Quando si scambiano punti, curve o solidi tra Dynamo e Revit API, è obbligatorio usare i metodi di conversione di estensione:

```python
import clr
clr.AddReference('RevitNodes')
import Revit
clr.ImportExtensions(Revit.GeometryConversion)

# 1. Da Geometria Dynamo a Geometria Revit Nativa
# dynamo_curve è una Autodesk.DesignScript.Geometry.Curve
revit_curve = dynamo_curve.ToRevitType()       # Diventa Autodesk.Revit.DB.Curve
revit_xyz = dynamo_point.ToXyz()              # Diventa Autodesk.Revit.DB.XYZ

# 2. Da Geometria Revit Nativa a Geometria Dynamo
# revit_solid è un Autodesk.Revit.DB.Solid
dynamo_solid = revit_solid.ToProtoType()      # Diventa Autodesk.DesignScript.Geometry.Solid
dynamo_point = revit_xyz.ToPoint()            # Diventa Autodesk.DesignScript.Geometry.Point
```

---

## Pattern DesignScript e Code Blocks

DesignScript consente di sostituire decine di nodi visuali con formule compatte e performanti:

### 1. Manipolazione Liste, Livelli e Replication Guides:
```designscript
// Selezione elementi annidati con List Levels (@L2)
flattened = List.Flatten(data@L2, 1);

// Replication Guide per combinazione vettoriale incrociata (<1>, <2>)
// Genera una griglia di punti moltiplicando tutte le X per tutte le Y
gridPoints = Point.ByCoordinates(xValues<1>, yValues<2>, 0);

// Filtraggio con BoolMask compatto
filteredResults = List.FilterByBoolMask(elements, mask)["in"];
```

### 2. Blocco di Codice Imperativo (`[Imperative]`):
Consente la sintassi algoritmica standard (cicli `for`, `while`, istruzioni condizionali `if-else` complesse):
```designscript
result = [Imperative]
{
    count = List.Count(elements);
    outputList = [];
    
    for (i in 0..(count - 1))
    {
        val = values[i];
        if (val > 10.0)
        {
            outputList[i] = "Conforme";
        }
        else
        {
            outputList[i] = "Non Conforme";
        }
    }
    return outputList;
};
```

---

## Anti-pattern nello Sviluppo Dynamo

| Errore Tipico | Conseguenza | Correzione |
| :--- | :--- | :--- |
| **Dimenticare `UnwrapElement()`** | Metodi Revit API non trovati sul wrapper Dynamo | Usare sempre `UnwrapElement(IN[0])` prima di chiamare metodi DB. |
| **Creare una `Transaction` manuale C# nel nodo Python** | Conflitto o crash con il motore transazionale di Dynamo | Usare esclusivamente `TransactionManager.Instance.EnsureInTransaction(doc)`. |
| **Assumere che l'input sia sempre una lista** | Crash immediato con `TypeError` se l'utente connette un elemento singolo | Implementare la funzione helper `to_list(input_data)`. |
| **Non gestire i livelli di lista (@L2, @L3)** | Dati raggruppati in modo errato o output appiattito | Impostare il livello corretto (@L2) dal menu a freccia del nodo. |
| **Usare `List.FilterByBoolMask` senza gestire il ramo "out"** | Perdita degli elementi non conformi necessari per il report | Estrarre entrambi i rami: `res["in"]` e `res["out"]`. |

---

## Output Strutturato

Quando invocata, la skill fornisce:
1. **Codice Python Ottimizzato per Nodi Dynamo** (CPython 3 o PythonNet3) con gestione errori.
2. **Espressioni DesignScript Compatte** per Code Blocks.
3. **Indicazione dei Livelli di Lista (@L1, @L2) e Lacing** (Shortest, Longest, Cross Product).
4. **Elenco dei Package di Comunità Indispensabili** per la soluzione proposta.
