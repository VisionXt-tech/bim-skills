# Rhino.Inside.Revit

Assistente per workflow Rhino.Inside.Revit: geometria complessa generata in Rhino/Grasshopper e convertita in elementi BIM Revit.

## Scope

- Workflow di interoperabilita Rhino-Revit
- Componenti Grasshopper specifici per Rhino.Inside.Revit
- Conversione geometria NURBS in elementi Revit nativi
- Accesso bidirezionale a parametri e famiglie
- Automazione di forme complesse non realizzabili nativamente in Revit

## NON fa

- Non gestisce l'installazione o configurazione di Rhino.Inside.Revit
- Non genera codice RhinoCommon puro (vedi skill `rhino`)
- Non sostituisce la modellazione manuale per elementi standard

## Concetti chiave

Rhino.Inside.Revit funziona come bridge:
- **Rhino** gira dentro il processo Revit
- **Grasshopper** ha componenti nativi per leggere/scrivere elementi Revit
- La geometria Rhino viene convertita in elementi Revit (muri, pavimenti, tetti, masse, famiglie)
- I parametri Revit sono accessibili come input/output Grasshopper

## Componenti Grasshopper principali

Nomi verificati sulla reference ufficiale dei componenti (`rhino3d.com/inside/revit/.../reference/gh-components`) — se una versione locale mostra nomi diversi, verificare la versione di Rhino.Inside.Revit installata prima di fidarsi ciecamente di questo elenco.

### Lettura da Revit (pannello Element / Architecture)
- `Query Elements` / `Query Element` — filtro elementi (singolo o batch) per categoria, tipo, livello; supporta `Limit`/`Count` per modelli grandi
- `Query Graphical Elements` — variante per elementi con geometria grafica
- `Query Walls`, `Query Levels`, `Query Grids` — query specifiche per categoria
- `Element Geometry` — estrai geometria come Brep/Mesh/Curve Rhino (nessun punto nel nome: **non** `Element.Geometry`)
- `Element Parameter` — lettura/scrittura di un singolo parametro (ha una modalita Get e una Set, commutabile dal menu contestuale)
- `Query Element Parameters` — lettura in batch di piu parametri di un elemento (in versioni precedenti chiamato "Element Parameters" — nome deprecato)
- Filtri componibili: `Type Filter`, `Parameter Filter`, `Level Filter`, `Bounding Box Filter`, `Design Option Filter`, `Logical And/Or Filter`

### Scrittura su Revit (pannello Architecture / Component / DirectShape)
- `Add Wall (Curve)` — muro da curva di base (linea/asse)
- `Add Wall (Profile)` — muro da profilo chiuso, planare, verticale
- `Add Floor` — pavimento da curve di perimetro (nessun suffisso "(Outline)" nella versione corrente)
- `Add Roof` — tetto da curve di perimetro
- `Add Ceiling`, `Add Column`, `Add Railing` — altri elementi architettonici nativi
- `Add Component (Location)` — inserisce un'istanza di famiglia in un punto (equivalente a "family instance" per famiglie basate su punto)
- `Add Component (Curve)` / `Add Component (Work Plane)` / `Add Component (Adaptive)` — varianti per famiglie curve-based, work-plane-based e adattive
- `Add DirectShape (Brep)` / `(Mesh)` / `(Curve)` / `(Point)` / `(Geometry)` — geometria generica (ultima risorsa, nessun parametro nativo)
- `Element Parameter` in modalita Set (o `Set Element Parameter` in alcune build) — scrivi parametri su elementi creati

### Utilita
- `Add Level`, `Query Levels` — creazione/lettura livelli Revit
- `Query Categories`, `Built-In Categories` — categorie Revit
- `Type Filter`, `Element Type Picker` — selezione dei tipi/famiglia disponibili per una categoria (non esiste un componente chiamato letteralmente "Family Types": verificare il nome esatto nella build in uso)

## Workflow tipico

1. **Input**: query elementi/geometria esistenti da Revit
2. **Elaborazione**: manipolazione geometrica in Grasshopper (pannellizzazione, pattern, ottimizzazione)
3. **Output**: creazione elementi BIM nativi in Revit con parametri

## Workflow end-to-end: da curve Grasshopper a muri Revit con parametri

Esempio completo — da una lista di curve planari in Rhino a muri Revit nativi, con tipo, livello e un parametro di istanza impostato:

1. **Preparazione geometria in Rhino**: disegnare le curve di asse muro (planari, sul piano dove poi si assegnera il livello). Validare che siano semplici, non self-intersecting, con lunghezza minima superiore alla tolleranza documento.
2. **Livello target**: `Query Levels` per ottenere il `Level` Revit desiderato (es. filtrando per nome o elevazione), oppure `Add Level` se il livello non esiste ancora.
3. **Tipo muro**: componente di selezione tipo (`Type Filter` + `Query Elements` sulla categoria Walls, oppure un parametro `Value List` popolato a runtime) per ottenere il `WallType` da assegnare.
4. **Creazione**: `Add Wall (Curve)` con input Curve = asse muro, Type = WallType, Level = Level, Height = altezza (numero o riferimento a Level superiore).
5. **Parametri di istanza**: `Element Parameter` in modalita Set (Element = output di Add Wall, Parameter Key = es. "Comments" o parametro condiviso, Value = testo/numero) per scrivere metadata (es. codice WBS, fase di cantiere).
6. **Verifica**: `Element Geometry` sull'elemento appena creato per un controllo visivo di ritorno in Rhino, o `Query Element Parameters` per rileggere i valori scritti e validarli.
7. **Batch**: se le curve sono molte, mantenere l'intera pipeline a liste (Grasshopper gestisce il loop internamente) — evitare loop Python espliciti elemento per elemento (vedi anti-pattern "troppi elementi in un loop").

### Accesso via GhPython all'API Revit (per logica non coperta da componenti nativi)

Quando un componente nativo non basta, si puo scrivere un componente GhPython con accesso diretto all'API Revit tramite `RhinoInside.Revit`:

```python
import clr
clr.AddReference('RhinoInside.Revit')
clr.AddReference('RevitAPI')
clr.AddReference('RevitAPIUI')

from RhinoInside.Revit import Revit, Convert
clr.ImportExtensions(Convert.Geometry)
from Autodesk.Revit import DB

doc = Revit.ActiveDBDocument  # documento Revit attivo, non il documento Rhino

# ogni scrittura nel modello Revit richiede una Transaction esplicita
with DB.Transaction(doc, 'Imposta parametro da GhPython') as t:
    t.Start()
    # es. element e' un Autodesk.Revit.DB.Element ottenuto da un input GH convertito
    param = element.LookupParameter("Comments")
    if param and not param.IsReadOnly:
        param.Set("Valore da Grasshopper")
    t.Commit()
```

Nota: `doc` qui e' il documento **Revit** (`Autodesk.Revit.DB.Document`), da non confondere con `Rhino.RhinoDoc.ActiveDoc` usato nella skill `rhino`.

## Anti-pattern

| Errore | Correzione |
|--------|------------|
| Usare `DirectShape` per tutto | Preferire elementi nativi (`Add Wall`, `Add Floor`, `Add Roof`, `Add Component`) quando possibile |
| Non specificare il livello | SEMPRE assegnare un Level agli elementi creati |
| Geometria non valida (self-intersecting) | Validare la geometria Rhino PRIMA della conversione |
| Ignorare le unita | Rhino e Revit devono usare le stesse unita (verificare) |
| Creare troppi elementi in un loop | Usare componenti batch — Revit e lento con transazioni singole |
| Chiamare un componente inesistente "Add FamilyInstance" o "Element.Geometry" | Verificare il nome esatto sulla reference ufficiale — usare `Add Component (Location/Curve/Work Plane/Adaptive)` ed `Element Geometry` |
| Scrivere su Revit da GhPython senza `Transaction` | Ogni modifica al documento Revit richiede una `DB.Transaction` esplicita con `Start()`/`Commit()` |
| Confondere `Rhino.RhinoDoc.ActiveDoc` con il documento Revit | In GhPython dentro Rhino.Inside.Revit, il documento Revit e' `RhinoInside.Revit.Revit.ActiveDBDocument` |
| Ricalcolare `Query Elements` su tutto il modello ad ogni iterazione | Filtrare per categoria/livello il piu presto possibile e usare `Limit`/`Count` sui modelli grandi |

## Regole

1. **Elementi nativi** — preferire Wall/Floor/Roof/Component a DirectShape
2. **Livelli** — SEMPRE assegnare un Level
3. **Unita** — verificare corrispondenza unita Rhino-Revit
4. **Validazione** — controllare geometria prima di convertire
5. **Performance** — operazioni batch, non elemento per elemento
6. **Nomi componenti** — verificare sempre sulla reference ufficiale (`rhino3d.com/inside/revit`) prima di assumere che un nome esista, i componenti sono stati rinominati piu volte tra le versioni
7. **Transazioni** — ogni scrittura sul documento Revit (anche da GhPython) richiede una `Transaction` esplicita
