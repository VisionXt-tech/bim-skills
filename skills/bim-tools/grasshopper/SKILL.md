---
name: grasshopper
description: >-
  Sviluppo avanzato di definizioni parametriche, script Python (Rhino 8 CPython 3 / GhPython) e componenti C# per Grasshopper e il BIM.
  Usare per modellazione computazionale, gestione avanzata di Data Tree (Grasshopper.DataTree / GH_Path), ottimizzazione
  geometrica (Kangaroo2, Karamba3D, Ladybug), metadati BIM (Elefront) e comandi Grasshopper Player.
---

# BIM Grasshopper Computational Design & Algorithmic Modeling

Guida specialistica di riferimento per la progettazione parametrica, lo sviluppo di componenti custom in **C# (GH_Component)** e **Python (CPython 3 nativo in Rhino 8 e GhPython)**, la manipolazione avanzata di strutture dati ad albero (**Data Tree**) e l'integrazione di motori computazionali di simulazione (Kangaroo2, Karamba3D, Ladybug Tools, Elefront) all'interno dell'ecosistema **Grasshopper for Rhinoceros**.

---

## Scope

Questa skill fornisce architetture algoritmiche, pattern di programmazione e best practice per:
- **Componenti Python 3 in Rhino 8 (CPython Nativo)**: sviluppo di logiche complesse con type hints espliciti, accesso all'API RhinoCommon e gestione delle librerie esterne (`numpy`, `scipy`, `networkx`).
- **Sviluppo di Componenti Compilati in C# (`GH_Component`)**: implementazione del ciclo di vita `RegisterInputParams`, `RegisterOutputParams`, `SolveInstance` e gestione di parametri custom `GH_Param<T>`.
- **Manipolazione Avanzata dei Data Tree**: lettura, trasformazione e costruzione programmatica di alberi gerarchici (`Grasshopper.DataTree` in Python e `GH_Structure<T>` / `GH_Path` in C#).
- **Integrazione con i Package Industriali**:
  - *Kangaroo2*: rilassamento dinamico di reti di cavi, membrane tessili e ottimizzazione geometrica vincolata;
  - *Karamba3D*: analisi e pre-dimensionamento strutturale parametrico;
  - *Ladybug Tools*: simulazioni di irraggiamento solare, ore di sole e comfort bioclimatico;
  - *Elefront*: associazione di attributi informativi, UserStrings e bake parametrico continuo verso Rhino.
- **Workflow Grasshopper Player**: trasformazione di definizioni parametriche in veri e propri comandi Rhino nativi eseguibili a riga di comando senza aprire il canvas visivo.

---

## NON fa

- Non genera file binari proprietari `.gh` o `.ghx` (definisce l'architettura logica, i componenti, i collegamenti e il codice dei nodi script).
- Non esegue simulazioni FEM certificate per il deposito al Genio Civile (i risultati di Karamba3D sono indicativi e devono essere verificati dal progettista strutturista).
- Non sostituisce la validazione geometrica in Rhino (rispetta la tolleranza del documento attivo).

---

## Data Tree Architecture in Python (Rhino 8)

Uno degli errori più frequenti in Grasshopper è la perdita della struttura ad albero quando si passa attraverso un nodo Python. In Rhino 8 CPython 3, la classe `Grasshopper.DataTree` consente il controllo totale su rami e percorsi (`GH_Path`):

```python
#! python3
import Rhino.Geometry as rg
from Grasshopper import DataTree
from Grasshopper.Kernel.Data import GH_Path

# Input configurato su Type Hint 'Curve' e Access 'Tree'
# pts_tree è un Grasshopper.DataTree[rg.Point3d]

output_tree = DataTree[object]()

# Iterazione su tutti i rami dell'albero di input
for path in pts_tree.Paths:
    branch_points = pts_tree.Branch(path)
    
    # Elaborazione geometrica sul ramo corrente
    if len(branch_points) >= 2:
        # Creazione curva interpolata per ciascun ramo
        curve = rg.Curve.CreateInterpolatedCurve(branch_points, 3)
        if curve:
            # Aggiunge la curva al ramo corrispondente dell'albero di output
            output_tree.Add(curve, path)
            
            # Creazione di un sotto-ramo per i punti di divisione
            sub_path = path.AppendElement(0)
            division_params = curve.DivideByCount(5, True)
            if division_params:
                for t in division_params:
                    output_tree.Add(curve.PointAt(t), sub_path)

# Assegna l'albero all'output del componente
a = output_tree
```

---

## Componente C# Compilato (`GH_Component`)

Per creare plugin distribuiti ad alte prestazioni, si eredita da `GH_Component`:

```csharp
using System;
using System.Collections.Generic;
using Grasshopper.Kernel;
using Grasshopper.Kernel.Data;
using Grasshopper.Kernel.Types;
using Rhino.Geometry;

namespace BimSkills.GrasshopperDev
{
    public class PanelGeneratorComponent : GH_Component
    {
        public PanelGeneratorComponent()
            : base("Panel Generator", "PGen", 
                   "Genera pannelli parametrici con verifica di planarità", 
                   "BIM Skills", "Facciate")
        {
        }

        protected override void RegisterInputParams(GH_InputParamManager pManager)
        {
            pManager.AddBrepParameter("Surface", "S", "Superficie o facciata guida", GH_ParamAccess.item);
            pManager.AddIntegerParameter("U Count", "U", "Numero suddivisioni U", GH_ParamAccess.item, 10);
            pManager.AddIntegerParameter("V Count", "V", "Numero suddivisioni V", GH_ParamAccess.item, 10);
        }

        protected override void RegisterOutputParams(GH_OutputParamManager pManager)
        {
            pManager.AddBrepParameter("Panels", "P", "Albero dei pannelli generati", GH_ParamAccess.tree);
            pManager.AddNumberParameter("Planarity Dev", "D", "Deviazione massima dalla planarità (mm)", GH_ParamAccess.list);
        }

        protected override void SolveInstance(IGH_DataAccess DA)
        {
            Brep surface = null;
            int uCount = 10;
            int vCount = 10;

            if (!DA.GetData(0, ref surface)) return;
            if (!DA.GetData(1, ref uCount)) return;
            if (!DA.GetData(2, ref vCount)) return;

            var panelTree = new GH_Structure<GH_Brep>();
            var deviations = new List<double>();

            // Algoritmo di tassellazione e verifica planarità
            // Popolamento rami albero con GH_Path(i, j)
            for (int i = 0; i < uCount; i++)
            {
                GH_Path path = new GH_Path(i);
                // Logica geometrica ...
            }

            DA.SetDataTree(0, panelTree);
            DA.SetDataList(1, deviations);
        }

        public override Guid ComponentGuid => new Guid("98A4521F-3B22-4015-8147-987E6F54D312");

        protected override System.Drawing.Bitmap Icon => null; // Inserire bitmap 24x24
    }
}
```

---

## Pattern di Ottimizzazione con Kangaroo2 e Karamba3D

### 1. Form-Finding e Rilassamento con Kangaroo2 (Nativo in Rhino 8)
Nelle tensostrutture o coperture a guscio:
- **Punti di Ancoraggio**: definire i vincoli fissi tramite il goal `Anchor`;
- **Molle / Aste**: applicare `Length(Line, TargetLength)` per simulare il comportamento elastico o pre-sollecitato;
- **Carichi di Pressione**: applicare `Pressure(Mesh, Force)` per simulare il carico del vento o gonfiaggio pneumatico;
- **Solver**: alimentare il `BouncySolver` o `SubSolver` per raggiungere l'equilibrio statico e congelare la geometria asseverata.

### 2. Attributi BIM e Gestione Dati con Elefront
Per trasformare le geometrie computazionali in entità conformi al Capitolato Informativo (CI):
- Assegnare `UserText` con la chiave e il valore standard (es. `Codice_WBS`, `Tipo_Pannello`, `Fase_Cantiere`);
- Definire il layer di destinazione (es. `ARC_FACCIATA_PANNELLI`);
- Eseguire il comando `Bake Objects` preservando l'ID univoco dell'oggetto per evitare duplicazioni nelle iterazioni successive.

---

## Anti-pattern nello Sviluppo Grasshopper

| Errore Tipico | Conseguenza | Soluzione Corretta |
| :--- | :--- | :--- |
| **Appiattire tutti i dati con `Flatten` indiscriminato** | Perdita delle relazioni topologiche (non si distinguono più le righe dalle colonne) | Usare `Graft`, `Shift Paths` o mantenere i Data Tree gerarchici. |
| **Type Hint non impostato nel nodo Python** | I dati arrivano come tipi generici non castati, causando errori di metodo | Impostare sempre il Type Hint esplicito (es. `Curve`, `Point3d`, `Brep`). |
| **Eseguire loop di calcolo intensivo su canvas senza lock** | Blocco dell'interfaccia di Rhino per diversi minuti a ogni spostamento di slider | Disattivare il solver (`F5` lock) durante modifiche a parametri pesanti. |
| **Generare componenti C# con GUID duplicato** | Crash all'avvio di Grasshopper o sostituzione silente del componente | Generare sempre un nuovo GUID univoco (`Guid.NewGuid()`). |
| **Bake manuale continuo senza gestione revisioni** | Sovrapposizione di centinaia di geometrie duplicate nel documento Rhino | Utilizzare componenti Elefront o script di pulizia layer prima del bake. |

---

## Output Strutturato

Quando invocata, la skill fornisce:
1. **Script Python 3 Strutturati per Grasshopper** con gestione esplicita dei Data Tree.
2. **Componenti C# (`GH_Component`)** pronti per la compilazione in file `.gha`.
3. **Mappe di Flusso Logico dei Nodi Canvas** (input, filtri, solver e output).
4. **Strategie di Assegnazione Metadati BIM (Elefront / UserStrings)**.
