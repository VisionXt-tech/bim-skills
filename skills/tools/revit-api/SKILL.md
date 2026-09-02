# Revit API (C#)

Assistente per lo sviluppo di add-in Revit in C#.

## Scope

- Sviluppo IExternalCommand, IExternalApplication, IExternalDBApplication
- Transazioni, filtri, famiglie parametriche, viste, export
- Ribbon UI (tab, panel, button, split button)
- Event handler e updater
- Integrazione con API esterne (REST, database)

## NON fa

- Non genera codice per versioni Revit precedenti alla 2022 senza conferma esplicita
- Non modifica il modello Revit direttamente (genera codice che lo fa)
- Non gestisce licenze o deployment di add-in

## Pattern fondamentali

### IExternalCommand

```csharp
[Transaction(TransactionMode.Manual)]
public class MyCommand : IExternalCommand
{
    public Result Execute(ExternalCommandData commandData, ref string message, ElementSet elements)
    {
        UIApplication uiApp = commandData.Application;
        UIDocument uiDoc = uiApp.ActiveUIDocument;
        Document doc = uiDoc.Document;

        try
        {
            using (Transaction tx = new Transaction(doc, "Operazione"))
            {
                tx.Start();
                // lavoro qui
                tx.Commit();
            }
            return Result.Succeeded;
        }
        catch (Exception ex)
        {
            message = ex.Message;
            return Result.Failed;
        }
    }
}
```

### FilteredElementCollector

```csharp
// istanze di muri
var walls = new FilteredElementCollector(doc)
    .OfCategory(BuiltInCategory.OST_Walls)
    .WhereElementIsNotElementType()
    .Cast<Wall>()
    .ToList();

// filtro con parametro
var filter = new ElementParameterFilter(
    new FilterStringRule(
        new ParameterValueProvider(new ElementId(BuiltInParameter.ALL_MODEL_MARK)),
        new FilterStringEquals(),
        "ABC"
    )
);
var filtered = new FilteredElementCollector(doc)
    .WherePasses(filter)
    .ToElements();
```

### Parametri

```csharp
// BuiltInParameter
Parameter p = element.get_Parameter(BuiltInParameter.WALL_USER_HEIGHT_PARAM);
double height = p.AsDouble(); // feet — convertire

// unita: Revit 2022+ usa ForgeTypeId (namespace Autodesk.Revit.DB)
double meters = UnitUtils.ConvertFromInternalUnits(height, UnitTypeId.Meters);

// da unita esterne a interne (es. valore letto da UI in millimetri)
double mmInput = 3000;
double internalValue = UnitUtils.ConvertToInternalUnits(mmInput, UnitTypeId.Millimeters);
p.Set(internalValue);

// parametro condiviso
Parameter shared = element.LookupParameter("NomeParametro");
if (shared != null && shared.HasValue)
{
    string val = shared.AsString();
}
```

**Nota versione — `DisplayUnitType` deprecato**: fino a Revit 2021 le unita si gestivano con l'enum `DisplayUnitType` (es. `DisplayUnitType.DUT_MILLIMETERS`). Da Revit 2022 questo enum e stato reso inaccessibile (deprecato) e sostituito dal sistema `ForgeTypeId` — una classe che rappresenta identificatori di unita/spec come stringhe tipizzate, non piu un enum chiuso. Le costanti pronte all'uso sono in `UnitTypeId` (unita, es. `UnitTypeId.Millimeters`) e `SpecTypeId` (categorie di grandezza, es. `SpecTypeId.Length`). Se un progetto genera codice per Revit 2021 o precedente, usare ancora `DisplayUnitType` ma segnalarlo esplicitamente come ramo legacy.

## Esempi aggiuntivi

### Creazione istanza di famiglia

```csharp
// il FamilySymbol deve essere caricato e attivo prima dell'uso
FamilySymbol symbol = new FilteredElementCollector(doc)
    .OfClass(typeof(FamilySymbol))
    .OfCategory(BuiltInCategory.OST_Furniture)
    .Cast<FamilySymbol>()
    .FirstOrDefault(s => s.Name == "Scrivania_800x1600");

if (symbol == null) throw new InvalidOperationException("Famiglia non trovata / non caricata");

using (Transaction tx = new Transaction(doc, "Inserisci famiglia"))
{
    tx.Start();
    if (!symbol.IsActive) symbol.Activate(); // OBBLIGATORIO prima di NewFamilyInstance

    Level level = new FilteredElementCollector(doc)
        .OfClass(typeof(Level))
        .Cast<Level>()
        .First(l => l.Name == "Piano Terra");

    XYZ location = new XYZ(0, 0, 0);
    doc.Create.NewFamilyInstance(location, symbol, level, StructuralType.NonStructural);

    tx.Commit();
}
```

### Export IFC

```csharp
// Document.Export(...) richiede una Transaction attiva (anche se poi si fa Rollback)
using (Transaction tx = new Transaction(doc, "Export IFC"))
{
    tx.Start();

    IFCExportOptions options = new IFCExportOptions
    {
        FileVersion = IFCVersion.IFC4
    };
    // opzioni aggiuntive non esposte come proprieta dirette
    options.AddOption("ExportBaseQuantities", "true");

    doc.Export(exportFolderPath, "modello_export", options);

    tx.RollBack(); // l'export non modifica il modello, non serve mantenere la transazione
}
```

### Creazione vista pianta

```csharp
ViewFamilyType planType = new FilteredElementCollector(doc)
    .OfClass(typeof(ViewFamilyType))
    .Cast<ViewFamilyType>()
    .First(vft => vft.ViewFamily == ViewFamily.FloorPlan);

Level level = new FilteredElementCollector(doc)
    .OfClass(typeof(Level))
    .Cast<Level>()
    .First(l => l.Name == "Piano Primo");

using (Transaction tx = new Transaction(doc, "Crea vista pianta"))
{
    tx.Start();
    ViewPlan newView = ViewPlan.Create(doc, planType.Id, level.Id);
    newView.Name = "Pianta Impianti - Piano Primo";
    tx.Commit();
}
```

## Anti-pattern

| Errore | Correzione |
|--------|------------|
| Transaction senza using/try-catch | SEMPRE `using (Transaction tx = ...)` con try-catch |
| `ToElements()` su collector grande senza filtro | Aggiungere filtri PRIMA di materializzare |
| Unita in metri nei Set() | Convertire con `UnitUtils.ConvertToInternalUnits(valore, ForgeTypeId)` |
| LINQ su collector senza `WherePassesFilter` | Preferire filtri Revit API (piu veloci di LINQ) |
| Accesso a `doc.ActiveView` in contesto DB | Usare solo in contesto UI (IExternalCommand) |
| `DisplayUnitType` in codice per Revit 2022+ | Enum deprecato/inaccessibile — usare `ForgeTypeId` / `UnitTypeId` |
| `NewFamilyInstance` con `FamilySymbol` non attivo | Chiamare `symbol.Activate()` prima dell'inserimento |
| Modificare il modello fuori da una Transaction aperta | Ogni `doc.Create.*` o `Set()` richiede una Transaction attiva, anche l'export IFC |
| Riferire un `Element` dopo `Regenerate()`/rollback | L'`ElementId` puo restare valido ma l'oggetto va ri-recuperato con `doc.GetElement(id)` |

## Differenze tra versioni Revit

| Versione | Cambiamento rilevante |
|----------|------------------------|
| 2021 e precedenti | `DisplayUnitType` per le unita, nessun `ForgeTypeId` |
| 2022+ | `ForgeTypeId`/`UnitTypeId`/`SpecTypeId` sostituiscono `DisplayUnitType` (deprecato/inaccessibile) |
| 2024+ | Target .NET aggiornato (Revit 2025 passa a .NET 8), verificare la versione .NET del progetto Visual Studio prima della build |

## Regole

1. **Transaction** — ogni modifica al modello DEVE essere in una Transaction
2. **Unita** — Revit usa piedi internamente, convertire SEMPRE
3. **Filtri** — FilteredElementCollector con filtri API, non LINQ su ToElements()
4. **Null check** — controllare SEMPRE parametri e riferimenti prima dell'uso
5. **BuiltInParameter** — usare enum, non string
6. **.addin manifest** — includere SEMPRE nel progetto
7. **FamilySymbol** — verificare/attivare (`IsActive`/`Activate()`) prima di `NewFamilyInstance`

## MCP Server consigliati (opzionali)

| Server | Cosa aggiunge | Installazione |
|--------|--------------|---------------|
| **Autodesk Revit MCP Server** (ufficiale, consigliato dove disponibile) | Query/report modello, editing bulk parametri, snapshot viste, via Autodesk Assistant | Solo Revit 2027, Tech Preview — [guida ufficiale](https://help.autodesk.com/view/ADSKMCP/ENU/?guid=ADSKMCP_RevitMcp_setting_up_revit_mcp_server_html) |
| **RevitCortex** | 173 tool per interazione live (alternativa community, Revit 2023-2027) | [GitHub](https://github.com/LuDattilo/RevitCortex) |

Vedi `docs/mcp-setup.md` per la configurazione completa.
