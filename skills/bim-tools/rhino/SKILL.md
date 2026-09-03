---
name: rhino
description: >-
  Scripting e automazione avanzata in Rhinoceros per il BIM tramite API RhinoCommon (CPython 3 in Rhino 8 e C#). Usare per
  modellazione geometrica algoritmica NURBS, SubD, Mesh ShrinkWrap/QuadRemesh, Brep boolean, gestione headless
  documenti 3DM (Rhino.FileIO), UserString BIM e analisi computazionale della curvatura.
---

# BIM Rhinoceros Scripting & RhinoCommon Automation

Guida specialistica di riferimento per lo sviluppo di script, comandi personalizzati e automazioni geometriche avanzate all'interno di **Rhinoceros** (Rhino 7 e Rhino 8) utilizzando l'API di basso livello **RhinoCommon** in **Python 3 (CPython nativo)** e **C#**. Copre la modellazione matematica NURBS, le superfici di suddivisione (SubD), gli algoritmi di riparazione mesh, la manipolazione *headless* di file `.3dm` e l'associazione di metadati informativi per il BIM.

---

## Scope

Questa skill fornisce architetture geometriche e codice riutilizzabile per:
- **Nuovo Script Editor di Rhino 8 (CPython 3 nativo)**: supporto completo alle librerie scientifiche standard via pip (`# r: numpy, scipy, shapely, pandas`).
- **Modellazione Geometrica Esatta (NURBS & Brep)**: creazione e manipolazione di `NurbsCurve`, superfici complesse per loft/sweep, operazioni booleane esatte (`Brep.CreateBooleanUnion`, `Difference`, `Intersection`) e gestione delle tolleranze del modello (`ModelAbsoluteTolerance`).
- **Geometrie SubD e Mesh Avanzate (Rhino 8)**: utilizzo delle API di subdivision modeling (`Rhino.Geometry.SubD`), generazione di mesh stagne con **`ShrinkWrap`** e quadrangolazione per analisi strutturali/FEM con **`QuadRemesh`**.
- **Manipolazione Headless di File 3DM (`Rhino.FileIO`)**: apertura, modifica, estrazione e salvataggio di modelli Rhino da processi batch o server esterni senza istanziare la GUI grafica.
- **Associazione Metadati Informativi BIM (`UserStrings` & `UserDictionary`)**: scrittura e lettura di attributi IFC, codici WBS e proprietà di fabbricazione all'interno degli oggetti geometrici (`ObjectAttributes.SetUserString`).
- **Analisi Geometrica Computazionale**: calcolo di aree, volumi, baricentri (`AreaMassProperties`, `VolumeMassProperties`), curvatura gaussiana/media e scostamento tra superfici.

---

## NON fa

- Non genera definizioni visuali per Grasshopper (per i componenti e i cluster GH fare riferimento alla skill `grasshopper`).
- Non si occupa del setup di motori di rendering fotorealistico (V-Ray, Enscape, Octane).
- Non sostituisce la modellazione manuale da parte del progettista (automatizza operazioni algoritmiche, batch e calcoli complessi).

---

## Architettura dei Namespace di RhinoCommon

| Namespace RhinoCommon | Funzione Architetturale | Classi Fondamentali |
| :--- | :--- | :--- |
| **`Rhino.Geometry`** | Kernel geometrico matematico puro (in-memory) | `Point3d`, `Vector3d`, `Plane`, `NurbsCurve`, `Brep`, `SubD`, `Mesh`, `Transform` |
| **`Rhino.DocObjects`**| Oggetti visuali e gerarchia del documento | `RhinoObject`, `ObjectAttributes`, `Layer`, `Material`, `ObjectType` |
| **`Rhino.FileIO`** | I/O e manipolazione headless di file | `File3dm`, `File3dmObject`, `FileWriteOptions`, `FileReadOptions` |
| **`Rhino.Input.Custom`**| Interazione avanzata a riga di comando | `GetObject`, `GetPoint`, `GetOption`, `CommandLineOption` |
| **`Rhino.RhinoDoc`** | Contesto del modello attivo | `ActiveDoc`, `Objects`, `Layers`, `ModelAbsoluteTolerance`, `ModelUnitSystem` |

---

## Scripting in Rhino 8: CPython 3 con Pip Packages

In Rhino 8 è possibile installare pacchetti scientifici direttamente nello script tramite la direttiva commentata `# r: <package>`:

```python
#! python3
# r: numpy, scipy

import Rhino
import Rhino.Geometry as rg
import numpy as np

# Verifica del documento attivo
doc = Rhino.RhinoDoc.ActiveDoc
tol = doc.ModelAbsoluteTolerance

# Generazione di una nuvola di punti sinusoidale con NumPy
x = np.linspace(0, 50, 100)
y = np.linspace(0, 50, 100)
X, Y = np.meshgrid(x, y)
Z = np.sin(X / 5.0) * np.cos(Y / 5.0) * 5.0

# Creazione punti in RhinoCommon
point_list = []
for i in range(X.shape[0]):
    for j in range(X.shape[1]):
        point_list.append(rg.Point3d(float(X[i, j]), float(Y[i, j]), float(Z[i, j])))

# Generazione superficie di interpolazione NURBS
interp_surf = rg.NurbsSurface.CreateFromPoints(point_list, 100, 100, 3, 3)
if interp_surf:
    doc.Objects.AddSurface(interp_surf)
    doc.Views.Redraw()
    print("Superficie computazionale creata con successo.")
```

---

## Pattern di Modellazione Avanzata con RhinoCommon

### 1. Operazioni Booleane Solide su Brep con Gestione Tolleranze

```python
import Rhino
import Rhino.Geometry as rg

doc = Rhino.RhinoDoc.ActiveDoc
tol = doc.ModelAbsoluteTolerance

# 1. Creazione solido base (parallelepipedo)
box = rg.Box(rg.Plane.WorldXY, rg.Interval(0, 10), rg.Interval(0, 10), rg.Interval(0, 5))
base_brep = box.ToBrep()

# 2. Creazione cilindro di foratura
cylinder = rg.Cylinder(
    rg.Circle(rg.Plane(rg.Point3d(5, 5, -1), rg.Vector3d.ZAxis), 2.5),
    7.0
)
cutting_brep = cylinder.ToBrep(True, True)

# 3. Booleana di Sottrazione (Difference)
# Restituisce un array di Brep (gestire sempre il fallimento dell'operazione)
diff_breps = rg.Brep.CreateBooleanDifference(base_brep, cutting_brep, tol)

if diff_breps and len(diff_breps) > 0:
    for b in diff_breps:
        # Verifica che il solido risultante sia chiuso (Solid / Manifold)
        if b.IsSolid:
            # Assegna metadati informativi BIM (UserString)
            attribs = Rhino.DocObjects.ObjectAttributes()
            attribs.SetUserString("Codice_WBS", "WBS.STR.01.PL")
            attribs.SetUserString("Descrizione", "Blocco forato in cls alleggerito")
            
            doc.Objects.AddBrep(b, attribs)
    doc.Views.Redraw()
else:
    print("Errore: Operazione booleana fallita. Verificare intersezione o tolleranze.")
```

---

### 2. Mesh ShrinkWrap e QuadRemesh (Novità Rhino 8)

Ideale per sanare geometrie difettose o convertire scansioni laser scanner / mesh complesse in solidi puliti per il BIM o simulazioni FEM:

```python
import Rhino
import Rhino.Geometry as rg

doc = Rhino.RhinoDoc.ActiveDoc

# Recupero di tutti gli oggetti mesh selezionati
selected_objects = doc.Objects.GetSelectedObjects(False, False)
meshes = [obj.Geometry for obj in selected_objects if isinstance(obj.Geometry, rg.Mesh)]

if meshes:
    # 1. ShrinkWrap: unifica e chiude qualsiasi mesh eliminando buchi e auto-intersezioni
    shrink_params = rg.ShrinkWrapParameters()
    shrink_params.TargetEdgeLength = 0.25      # Lunghezza desiderata degli spigoli in metri
    shrink_params.Offset = 0.0                # Nessun offset dimensionale
    shrink_params.SmoothSteps = 2             # Livello di lisciatura

    wrapped_mesh = rg.Mesh.CreateShrinkWrap(meshes, shrink_params)

    if wrapped_mesh and wrapped_mesh.IsClosed:
        # 2. QuadRemesh: converte la mesh triangolare in quadrilateri regolari
        quad_params = rg.QuadRemeshParameters()
        quad_params.TargetQuadCount = 2000    # Target numero poligoni
        quad_params.AdaptiveSize = 50         # Adattamento ai bordi di curvatura (0-100)

        remeshed = wrapped_mesh.QuadRemesh(quad_params)
        if remeshed:
            doc.Objects.AddMesh(remeshed)
            doc.Views.Redraw()
            print("ShrinkWrap e QuadRemesh completati con successo.")
```

---

### 3. Manipolazione Headless di File 3DM (`Rhino.FileIO`)

Consente di elaborare file `.3dm` su disco in modalità non presidiata (utile per script batch o backend server):

```python
import Rhino
import Rhino.FileIO as rf

file_path = "C:/Progetti/Modello_Architettonico.3dm"

# Lettura file 3DM senza avviare la finestra grafica
file3dm = rf.File3dm.Read(file_path)

print(f"Versione file 3DM: {file3dm.ArchiveVersion}")
print(f"Unità di misura: {file3dm.Settings.ModelUnitSystem}")

brep_count = 0
total_volume = 0.0

for obj in file3dm.Objects:
    geom = obj.Geometry
    if isinstance(geom, Rhino.Geometry.Brep) and geom.IsSolid:
        brep_count += 1
        vol_props = Rhino.Geometry.VolumeMassProperties.Compute(geom)
        if vol_props:
            total_volume += vol_props.Volume
            # Scrittura metadato informativo nel file
            obj.Attributes.SetUserString("Calcolo_Volume", f"{vol_props.Volume:.3f}")

# Salvataggio delle modifiche nel file su disco
write_options = rf.FileWriteOptions()
write_options.FileVersion = 8
file3dm.Write(file_path, write_options)

print(f"Elaborati {brep_count} solidi Brep. Volume totale: {total_volume:.2f} m³.")
```

---

## Anti-pattern nello Scripting Rhino

| Errore Tipico | Conseguenza | Correzione Obbligatoria |
| :--- | :--- | :--- |
| **`doc.Views.Redraw()` all'interno di un ciclo for** | Rallentamento drastico: Rhino ricalcola il rendering a ogni iterazione | Eseguire un unico `doc.Views.Redraw()` al termine del ciclo. |
| **Usare `from Rhino.Geometry import *`** | Collisione di namespace tra classi Rhino e moduli standard Python | Usare sempre `import Rhino.Geometry as rg`. |
| **Ignorare `doc.ModelAbsoluteTolerance` nelle booleane** | Geometrie aperte non solide (*non-manifold*) o fallimento silenzioso | Passare sempre la tolleranza del documento alle funzioni geometriche. |
| **Manipolare curve senza trasformazione coerente** | Punti calcolati nel piano sbagliato rispetto al sistema di coordinate | Utilizzare `rg.Transform.PlaneToPlane` per proiettare tra sistemi di riferimento. |
| **Dimenticare di liberare la memoria o gestire solidi nulli** | Crash dell'applicazione su file con migliaia di elementi | Verificare sempre `if brep is not None and brep.IsValid:` prima dell'aggiunta al doc. |

---

## Output Strutturato

Quando invocata, la skill fornisce:
1. **Script Python 3 Completi per Rhino 8** con direttive pip e gestione tolleranze.
2. **Algoritmi di Trasformazione e Booleane Solide Brep/NURBS**.
3. **Script Batch Headless (`Rhino.FileIO.File3dm`)** per elaborazione non presidiata.
4. **Procedure di Associazione Attributi Informativi e UserString BIM**.
