---
name: rhino-inside-revit
description: >-
  Integrazione avanzata e sviluppo con Rhino.Inside.Revit per convertire geometrie computazionali complesse Rhino/Grasshopper
  in elementi BIM nativi e famiglie Revit. Usare per interoperabilita bidirezionale in-memory, creazione facciate a doppia curvatura,
  famiglie adattive, DirectShape categorizzati, scripting Python ibrido e conversione con RhinoInside.Revit.Convert.
---

# BIM Rhino.Inside.Revit & Computational Workflows

Guida specialistica di riferimento per la modellazione algoritmica, l'interoperabilità in-memory ad alte prestazioni e l'ingegnerizzazione di geometrie complesse tramite la tecnologia **Rhino.Inside.Revit** (Rhino 8 e Rhino 7 in esecuzione nel processo nativo di Autodesk Revit 2022-2026).

---

## Scope

Questa skill fornisce strategie di modellazione computazionale e pattern per:
- **Architettura In-Memory (Zero-Export)**: esecuzione di Rhino e Grasshopper all'interno dello spazio di indirizzamento di Revit (`Revit.exe`), azzerando i tempi di interscambio file (DWG, SAT, IFC) e garantendo accesso bidirezionale diretto al database BIM.
- **Gerarchia di Trasferimento verso Revit (Strategia delle 4 Classi)**:
  1. *Elementi Nativi di Sistema*: `Add Wall (Curve/Profile)`, `Add Floor`, `Add Roof`, `Add Ceiling`, `Add Column`;
  2. *Famiglie Caricabili e Componenti Adattivi*: `Add Component (Location)`, `Add Component (Adaptive)`, `Add Component (Curve/WorkPlane)`;
  3. *DirectShape Categorizzati*: generazione di solidi Brep/Mesh complessi assegnati a categorie ufficiali (es. `OST_GenericModel`, `OST_StructuralFraming`) con parametri;
  4. *SubD e Forme Libere*: conversione di superfici organiche SubD in solidi stagni per Revit.
- **Conversione Geometrica ad Alte Prestazioni (`RhinoInside.Revit.Convert`)**: utilizzo delle funzioni di estensione C#/Python per convertire geometrie RhinoCommon (`Point3d`, `Curve`, `Brep`, `Mesh`) in equivalenti Revit API (`XYZ`, `Curve`, `Solid`, `Mesh`) e viceversa.
- **Scripting Python Ibrido in-canvas**: codice Python che accede simultaneamente a `Rhino.RhinoDoc.ActiveDoc` e `RhinoInside.Revit.Revit.ActiveDBDocument` con gestione delle transazioni.
- **Generazione e Ottimizzazione di Facciate e Involucri Complessi**: tassellazione di superfici a doppia curvatura, controllo di planarità dei pannelli e generazione automatizzata di facciate continue o pannelli a cellule in Revit.

---

## NON fa

- Non gestisce l'installazione o il setup dei driver di sistema di Rhino.Inside.Revit (richiede che Rhino e Revit siano già configurati sulla macchina).
- Non sostituisce la modellazione manuale ordinaria quando l'elemento può essere tracciato facilmente con gli strumenti standard di Revit.
- Non converte mesh non stagne (*non-manifold*) in solidi nativi (la geometria Rhino deve essere chiusa e pulita prima del passaggio a Revit).

---

## La Gerarchia della Conversione: Come Trasferire la Geometria in Revit

Per garantire la massima qualità informativa e non degradare il modello BIM con blocchi opachi, la scelta del metodo di generazione deve seguire la gerarchia:

```
                      QUALITÀ E INTELLIGENZA BIM
                               ▲
                               │
[CLASSE 1: ELEMENTI NATIVI]     │  Add Wall, Add Floor, Add Roof, Add Column
(Piena compatibilità, computi) │  (Geometria planare/lineare guidata da assi/profili)
                               │
[CLASSE 2: FAMIGLIE ADATTIVE]  │  Add Component (Adaptive / By Points)
(Pannelli e nodi parametrici)  │  (Geometrie variabili basate su nodi adattivi 1..N)
                               │
[CLASSE 3: DIRECTSHAPE SOLIDI] │  Add DirectShape (Brep) + Categoria Revit
(Geometrie complesse uniche)   │  (Solidi B-Rep chiusi con parametri di istanza)
                               │
[CLASSE 4: DIRECTSHAPE MESH]   │  Add DirectShape (Mesh)
(Scansioni, forme organiche)   │  (Geometria poligonale leggera per visualizzazione)
                               ▼
```

---

## Workflow End-to-End: Generazione Muri Nativi da Assi Curvi

Esempio pratico di pipeline parametrica da curve computazionali in Grasshopper a elementi nativi Revit con metadati:

1. **Definizione e Validazione Assi in Grasshopper**:
   - Tracciamento delle curve guida nel piano di riferimento;
   - Verifica di tangenza, assenza di auto-intersezioni e lunghezza minima $\ge 10$ mm (sotto la quale Revit rifiuta di generare il muro).
2. **Selezione Livello e Tipo Muro**:
   - `Query Levels` filtrato per nome (es. `"Piano Terra"`);
   - `Type Filter` (categoria `BuiltInCategory.OST_Walls`) per estrarre la famiglia desiderata (es. `Muro di base: Cemento Armato 300mm`).
3. **Generazione e Assegnazione Parametri**:
   - Componente `Add Wall (Curve)` collegando: `Curve`, `Type`, `Level`, `Height`;
   - Componente `Element Parameter` in modalità `Set` per iniettare i codici informativi:
     - `Key`: `"Codice_WBS"` $\rightarrow$ `Value`: `"WBS.STR.01.P00"`
     - `Key`: `"Commenti"` $\rightarrow$ `Value`: `"Generato da algoritmo Grasshopper"`

---

## Scripting Python Ibrido con RhinoInside.Revit

Quando i componenti del canvas non coprono un'operazione specialistica, si scrive un nodo Python ibrido:

```python
#! python3
import clr
clr.AddReference('System.Core')
clr.AddReference('RhinoInside.Revit')
clr.AddReference('RevitAPI')
clr.AddReference('RevitAPIUI')

# Import namespace ibridi
from RhinoInside.Revit import Revit, Convert
clr.ImportExtensions(Convert.Geometry)
import Autodesk.Revit.DB as DB
import Rhino.Geometry as rg

# Documenti attivi nei rispettivi mondi
revit_doc = Revit.ActiveDBDocument   # Database Revit (.NET)
rhino_doc = Rhino.RhinoDoc.ActiveDoc  # Documento Rhino attivo

# Input dal canvas: rhino_brep (rg.Brep), category_name (string), mark_value (string)

# 1. Validazione geometria Rhino
if not rhino_brep.IsSolid:
    raise ValueError("Il Brep deve essere un solido chiuso per la conversione in Revit.")

# 2. Conversione Geometrica in-memory ad alte prestazioni
# Il metodo di estensione ToSolid() converte direttamente rg.Brep -> DB.Solid
revit_solid = rhino_brep.ToSolid()

# 3. Creazione DirectShape all'interno di una Transazione Revit
created_id = None
with DB.Transaction(revit_doc, "Crea DirectShape Strutturale") as tx:
    tx.Start()
    
    # Categoria di destinazione: Modelli Generici o Telai Strutturali
    cat_id = DB.ElementId(DB.BuiltInCategory.OST_GenericModel)
    
    # Creazione DirectShape
    ds = DB.DirectShape.CreateElement(revit_doc, cat_id)
    ds.SetShape([revit_solid])
    ds.Name = "Elemento_Computazionale_Complesso"
    
    # Assegnazione parametro di istanza
    param_mark = ds.get_Parameter(DB.BuiltInParameter.ALL_MODEL_MARK)
    if param_mark and not param_mark.IsReadOnly:
        param_mark.Set(mark_value)
        
    param_wbs = ds.LookupParameter("Codice_WBS")
    if param_wbs and not param_wbs.IsReadOnly:
        param_wbs.Set("WBS.DES.04.COMP")
        
    tx.Commit()
    created_id = ds.Id

# Output: restituisce l'ID dell'elemento Revit creato
a = created_id
```

---

## Pattern per Facciate Parametriche e Adaptive Components

Nelle facciate complesse a cellule triangolari o quadrangolari:
1. **Suddivisione Superficie Guide (Rhino/GH)**: decomposizione della facciata in quad o triangoli tramite `Isotrim` o `SubD`;
2. **Estrazione Punti Nativi**: per ogni cella, estrarre i vertici ordinati (P1, P2, P3, P4) come `Point3d`;
3. **Conversione Punti**: trasformare i punti in coordinate Revit con `Convert.Geometry.ToXYZ()`;
4. **Inserimento Componente Adattivo**: usare il componente `Add Component (Adaptive)` passando la lista di punti ordinati e il tipo di famiglia adattiva (`AdaptiveFamilySymbol`).
5. **Verifica Tolleranza**: calcolare la deviazione planare massima del quadrilatero in Grasshopper e salvarla nel parametro `Deviazione_Planare` dell'istanza Revit.

---

## Anti-pattern in Rhino.Inside.Revit

| Errore Tipico | Conseguenza | Correzione Obbligatoria |
| :--- | :--- | :--- |
| **Abusare di `DirectShape` per muri e solai standard** | Modello cieco: niente stratigrafie, niente unioni native, computi limitati | Usare `Add Wall` e `Add Floor` per elementi convenzionali; riservare `DirectShape` solo a sculture/forme libere. |
| **Passare curve con lunghezza $< 1$ mm** | Crash del componente o eccezione `Curve is too short` sollevata da Revit | Filtrare preventivamente le curve in Grasshopper con `Length > tol`. |
| **Disallineamento unità di misura tra Rhino e Revit** | Geometrie scalate di 12 volte (metri vs piedi) o microscopiche | Verificare che le unità del documento Rhino coincidano con quelle di progetto in Revit prima del trasferimento. |
| **Modificare il documento Revit senza `DB.Transaction`** | Eccezione `InvalidOperationException` immediata | Avvolgere sempre il codice modificativo in `with DB.Transaction(...)`. |
| **Rigenerare l'intero modello ad ogni cambio di slider** | Congelamento di Revit per minuti su modelli con migliaia di elementi | Disattivare l'auto-aggiornamento del componente di creazione o usare un pulsante boolean `Toggle` come abilitatore. |

---

## Output Strutturato

Quando invocata, la skill fornisce:
1. **Definizioni della Pipeline Grasshopper per Rhino.Inside.Revit** con sequenza esatta dei componenti.
2. **Script Python Ibridi In-Memory** per la creazione transazionale di elementi e famiglie.
3. **Strategie di Conversione Geometrica e Tolleranza** per facciate complesse e coperture organiche.
4. **Procedure di Mappatura Parametrica Bidirezionale (Revit $\leftrightarrow$ Grasshopper)**.
