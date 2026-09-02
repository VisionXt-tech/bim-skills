# Grasshopper Development

Assistente per definizioni Grasshopper, componenti Python/C#, e plugin custom.

## Scope

- Logica e struttura di definizioni Grasshopper
- Componenti Python (GhPython / CPython)
- Componenti C# (scripting inline e plugin compilati)
- Data tree e gestione livelli di lista
- Pattern parametrici e ottimizzazione geometrica
- Integrazione con package (LunchBox, Kangaroo2, Karamba3D, Ladybug Tools)

## NON fa

- Non genera file .gh binari
- Non disegna il canvas — descrive la logica e i nodi da collegare
- Non sostituisce simulazione strutturale o energetica

## Componente Python (GhPython)

Rhino 8 sostituisce il vecchio componente "GhPython" con due componenti nativi nello stesso menu: **Python 3 Script** (CPython, consigliato per nuovo codice) e **IronPython 2 Script** (compatibilita legacy, plugin .NET). In entrambi gli input configurati nel pannello diventano variabili dirette con lo stesso nome — non esiste piu (e in pratica non e mai esistita nei componenti con input nominati) la sintassi `IN[0]`, `IN[1]`; quella e propria del vecchio componente "Python Script (Deprecated)" / `RunPythonScript` in modalita legacy, da evitare in codice nuovo.

```python
# input configurati sul componente: x (item, number), pts (list, point), count (int)
# output configurato: a
import Rhino.Geometry as rg

results = []
for pt in pts:
    circle = rg.Circle(pt, x)
    results.append(circle.ToNurbsCurve())

a = results
```

Per richiamare componenti Grasshopper nativi direttamente da Python (evitando di reimplementare logica gia disponibile), usare `ghpythonlib.components`:

```python
import ghpythonlib.components as ghcomp

# i componenti nativi sono esposti come funzioni; output multipli si spacchettano in tuple
points, tangents, params = ghcomp.DivideCurve(curve, count)
area_props = ghcomp.Area(curve)
```

Impostare sempre il **Type Hint** corretto sugli input (click destro sul parametro > Type Hint, es. `Point3d`, `Curve`, `int`) e il livello di accesso (Item / List / Tree) coerente con la logica dello script: un input in modalita List che riceve dati Tree senza gestione esplicita causa errori silenziosi o dati troncati.

## Componente C# (GH_Component)

Per plugin compilati o componenti custom C#, la classe base e `Grasshopper.Kernel.GH_Component`. Namespace principali: `Grasshopper.Kernel` (componenti, parametri), `Grasshopper.Kernel.Data` (data tree), `Grasshopper.Kernel.Types` (wrapper Goo).

```csharp
using Grasshopper.Kernel;
using Rhino.Geometry;

public class MyComponent : GH_Component
{
    public MyComponent() : base("MyComponent", "MC", "Descrizione", "Category", "Subcategory") { }

    protected override void RegisterInputParams(GH_InputParamManager pManager)
    {
        pManager.AddPointParameter("Points", "P", "Punti di input", GH_ParamAccess.list);
        pManager.AddNumberParameter("Radius", "R", "Raggio", GH_ParamAccess.item, 1.0);
    }

    protected override void RegisterOutputParams(GH_OutputParamManager pManager)
    {
        pManager.AddCurveParameter("Circles", "C", "Cerchi risultanti", GH_ParamAccess.list);
    }

    protected override void SolveInstance(IGH_DataAccess DA)
    {
        var points = new List<Point3d>();
        double radius = 0;
        if (!DA.GetDataList(0, points)) return;
        if (!DA.GetData(1, ref radius)) return;

        var circles = points.Select(p => new Circle(p, radius).ToNurbsCurve()).ToList();
        DA.SetDataList(0, circles);
    }

    public override Guid ComponentGuid => new Guid("00000000-0000-0000-0000-000000000000");
}
```

Ogni parametro (`IGH_Param`, implementato tipicamente derivando da `GH_Param<T>`) porta i dati come `GH_Structure<T>` — la struttura ad albero che sostituisce le semplici liste quando i dati hanno piu rami (`GH_Path`).

## Data Tree — regole chiave

- **Flatten** (icona): appiattisce a lista singola
- **Graft** (icona): ogni item diventa un branch
- **Path Mapper**: trasforma struttura ad albero
- **Simplify**: rimuove livelli di annidamento superflui (path ridondanti)
- **Livelli (@L)**: in componenti Python con accesso Tree, `tree.Branch(path)` per accedere a un ramo; in C#, `GH_Structure<T>.get_Branch(GH_Path)`

Pattern comune: se due input hanno strutture diverse, Grasshopper fa cross-reference automatico per default.
Usare `Longest List`, `Shortest List`, o `Cross Reference` esplicitamente quando il comportamento di default non e quello voluto — non affidarsi al default implicito in definizioni complesse.

## Package comuni (verificati attivi al 2026)

- **LunchBox** — utility di paneling, tessellazione, interoperabilita e data management; il plugin piu scaricato dell'ecosistema Grasshopper, con aggiornamenti attivi anche per Grasshopper 2 (LunchBox G2 in sviluppo). Ancora la scelta di default per paneling/tessellazione.
- **Kangaroo2** — motore fisico live per form-finding, solving di vincoli, simulazioni dinamiche (cloth, rigid body, collisioni). Dalla versione Rhino 8 e **incluso nell'installazione core di Rhino**, non serve piu installarlo come plugin separato — verificare comunque la versione bundled se il progetto richiede feature specifiche.
- **Karamba3D** — analisi e ottimizzazione strutturale (FEM) parametrica, sviluppato da Bollinger+Grohmann. Plugin commerciale, ancora attivamente mantenuto; restare generici sulla versione e verificare la licenza del progetto.
- **Ladybug Tools** (Ladybug + Honeybee) — analisi ambientale ed energetica (irraggiamento, comfort, simulazioni energetiche via EnergyPlus/Radiance). Tra i plugin piu scaricati, sviluppo attivo con release stabili anche recenti per Rhino 6-8.

Prima di generare codice o istruzioni specifiche per un package, verificare la versione installata dall'utente: le API di questi plugin cambiano tra major version e non vanno assunte da conoscenza generica.

## Anti-pattern

| Errore | Correzione |
|--------|------------|
| Ignorare struttura data tree | Documentare SEMPRE input/output come item/list/tree |
| Loop in Python quando un componente nativo esiste | Usare componenti nativi GH (piu veloci) |
| Geometria non referenziata al piano corretto | Specificare SEMPRE il piano di costruzione |
| Bake senza layer target | Specificare layer e attributi al bake |
| Usare `IN[0]`/`IN[1]` in un componente Python 3 / IronPython 2 con input nominati | Usare direttamente il nome configurato sul parametro (es. `pts`, `count`) |
| Type Hint mancante o errato sugli input Python | Impostarlo esplicitamente (click destro > Type Hint) per accesso diretto ai tipi RhinoCommon |
| Assumere che un package (Kangaroo, LunchBox...) abbia la stessa API tra major version | Verificare la versione installata prima di generare codice specifico per il package |
| Component GUID duplicato o assente in un plugin C# custom | Ogni `GH_Component` deve avere un `ComponentGuid` univoco e stabile (non rigenerarlo dopo il rilascio) |

## Regole

1. **Data tree** — documentare struttura input/output
2. **Componenti nativi** — preferire a script Python quando possibile
3. **Performance** — evitare loop Python su grandi dataset, usare componenti batch
4. **Piani** — geometria sempre riferita a un piano esplicito
5. **Tolleranze** — rispettare tolleranza documento Rhino
6. **Motore Python** — specificare se il codice e per Python 3 (CPython) o IronPython 2 (Rhino 8): sintassi e librerie disponibili differiscono
7. **Versioni package** — non assumere API stabili tra major version di plugin di terze parti
