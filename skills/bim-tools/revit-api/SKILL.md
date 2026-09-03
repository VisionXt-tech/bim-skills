---
name: revit-api
description: >-
  Sviluppo avanzato di add-in, comandi e plugin BIM per Autodesk Revit in C# (.NET 8 e .NET Framework 4.8). Usare per
  IExternalCommand, IExternalApplication, Ribbon UI, transazioni e TransactionGroup, FilteredElementCollector ottimizzati,
  IExternalEventHandler/ExternalEvent asincroni, IUpdater, FailureHandling e migrazione ForgeTypeId/ElementId a 64 bit.
---

# BIM Revit API Architecture & C# Add-In Engineering

Guida specialistica di riferimento per lo sviluppo professionale di add-in, estensioni e plugin per **Autodesk Revit** in linguaggio **C# (.NET)**. Copre le migliori pratiche architetturali, la gestione delle transazioni, la manipolazione ad alte prestazioni dei modelli tramite `FilteredElementCollector`, le interfacce utente Ribbon, la gestione asincrona multithreading con `ExternalEvent` e i cambiamenti architetturali cruciali introdotti nelle versioni più recenti (**migrazione a .NET 8 in Revit 2025/2026, ElementId a 64 bit e sistema ForgeTypeId**).

---

## Scope

Questa skill fornisce pattern architetturali, frammenti di codice riutilizzabili e best practice per:
- **Architettura di Add-In**: implementazione di `IExternalCommand` (esecuzione sincrona), `IExternalApplication` (registrazione Ribbon e lifecycle di avvio/chiusura) e manifest `.addin`.
- **Evoluzione del Runtime (.NET Framework 4.8 vs .NET 8)**: supporto alla compilazione moderna con SDK-style `.csproj` per Revit 2024, 2025 e 2026.
- **Gestione Transazionale Avanzata**: `Transaction`, `SubTransaction` e `TransactionGroup` con assimilazione delle modifiche (`Assimilate()`) in un singolo punto di Undo.
- **Querying ad Alte Prestazioni (`FilteredElementCollector`)**: filtri rapidi nativi C++ a livello database, filtri lenti, e inversione della dipendenza LINQ per evitare memory leak.
- **Manipolazione dei Parametri e Sistema di Misura**: gestione dei parametri Built-In, parametri di progetto e parametri condivisi (*Shared Parameters*); conversione di unità tramite **`UnitUtils`** e **`ForgeTypeId`** (superamento definitivo di `DisplayUnitType`).
- **Supporto al Nuovo Sistema ElementId (Int64 / Long)**: adozione di `ElementId.Value` e costruttori a 64 bit introdotti da Revit 2024.
- **Programmazione Asincrona e UI Non Modale**: implementazione di `IExternalEventHandler` ed `ExternalEvent` per interfacciare finestre WPF o chiamate HTTP/REST esterne senza bloccare l'interfaccia di Revit.
- **Gestione Automatica degli Errori e Warning (*Failure Handling*)**: implementazione di `IFailuresPreprocessor` per sopprimere messaggi bloccanti e warning durante elaborazioni batch non presidiate.
- **Reattività del Modello (*Dynamic Model Update - DMU*)**: implementazione di `IUpdater` e registrazione dei trigger di modifica elementi con `UpdaterRegistry`.

---

## NON fa

- Non genera codice legacy incompatibile per versioni obsolete di Revit (es. 2018-2021) salvo esplicita richiesta dell'utente.
- Non esegue chiamate dirette all'API di Revit da thread secondari non sincronizzati (violazione del modello single-thread di Revit).
- Non modifica il modello geometrico in assenza di una transazione aperta e attiva.

---

## Matrice Compatibilità e Breaking Changes (Revit 2022 - 2026)

| Versione Revit | Target Framework .NET | Gestione Unità di Misura | Tipo ElementId | SDK Style Project File |
| :---: | :---: | :---: | :---: | :---: |
| **Revit 2022** | .NET Framework 4.8 | `ForgeTypeId` / `UnitTypeId` | `int` (32 bit) | Opzionale |
| **Revit 2023** | .NET Framework 4.8 | `ForgeTypeId` / `UnitTypeId` | `int` (32 bit) | Opzionale |
| **Revit 2024** | .NET Framework 4.8 | `ForgeTypeId` / `UnitTypeId` | **`long` (64 bit - `ElementId.Value`)** | Consigliato |
| **Revit 2025** | **.NET 8.0 (CoreCLR)** | `ForgeTypeId` / `UnitTypeId` | **`long` (64 bit - `ElementId.Value`)** | **Obbligatorio** |
| **Revit 2026** | **.NET 8.0 (CoreCLR)** | `ForgeTypeId` / `UnitTypeId` | **`long` (64 bit - `ElementId.Value`)** | **Obbligatorio** |

> [!IMPORTANT]
> **Migrazione a .NET 8 (Revit 2025+)**:
> Da Revit 2025 non è più possibile utilizzare .NET Framework. Il progetto `.csproj` deve essere configurato con:
> `<TargetFramework>net8.0-windows</TargetFramework>` e `<EnableDynamicLoading>true</EnableDynamicLoading>`.
> Per le API ElementId, la proprietà `IntegerValue` è deprecata e sostituita da `Value` (tipo `long` a 64 bit).

---

## Configurazione del Progetto Moderno (`.csproj` SDK-Style per Revit 2025)

```xml
<Project Sdk="Microsoft.NET.Sdk">
  <PropertyGroup>
    <TargetFramework>net8.0-windows</TargetFramework>
    <UseWPF>true</UseWPF>
    <UseWindowsForms>true</UseWindowsForms>
    <Platforms>x64</Platforms>
    <Nullable>enable</Nullable>
    <LangVersion>latest</LangVersion>
    <!-- Necessario per isolare le dipendenze in CoreCLR -->
    <EnableDynamicLoading>true</EnableDynamicLoading>
    <CopyLocalLockFileAssemblies>true</CopyLocalLockFileAssemblies>
  </PropertyGroup>

  <ItemGroup>
    <!-- Riferimenti Revit API (Private=false per non copiare le DLL di sistema) -->
    <Reference Include="RevitAPI">
      <HintPath>C:\Program Files\Autodesk\Revit 2025\RevitAPI.dll</HintPath>
      <Private>False</Private>
    </Reference>
    <Reference Include="RevitAPIUI">
      <HintPath>C:\Program Files\Autodesk\Revit 2025\RevitAPIUI.dll</HintPath>
      <Private>False</Private>
    </Reference>
  </ItemGroup>
</Project>
```

---

## Pattern Architetturali Fondamentali

### 1. IExternalApplication e Ribbon UI Personalizzata

```csharp
using System;
using System.Reflection;
using Autodesk.Revit.UI;
using System.Windows.Media.Imaging;

namespace BimSkills.RevitDev
{
    public class AppMain : IExternalApplication
    {
        public Result OnStartup(UIControlledApplication application)
        {
            string tabName = "BIM Skills Italia";
            application.CreateRibbonTab(tabName);

            RibbonPanel panel = application.CreateRibbonPanel(tabName, "Strumenti QA/QC");
            string thisAssemblyPath = Assembly.GetExecutingAssembly().Location;

            // Creazione PushButton
            PushButtonData buttonData = new PushButtonData(
                "cmdValidateLoin",
                "Valida\nLOIN",
                thisAssemblyPath,
                "BimSkills.RevitDev.Commands.ValidateLoinCommand"
            )
            {
                ToolTip = "Esegue l'audit dei parametri informativi e pset rispetto al CI di commessa.",
                LargeImage = new BitmapImage(new Uri("pack://application:,,,/BimSkills;component/Resources/Loin32.png"))
            };

            panel.AddItem(buttonData);
            return Result.Succeeded;
        }

        public Result OnShutdown(UIControlledApplication application)
        {
            return Result.Succeeded;
        }
    }
}
```

---

### 2. IExternalCommand con TransactionGroup e Failure Handling

```csharp
using System;
using Autodesk.Revit.Attributes;
using Autodesk.Revit.DB;
using Autodesk.Revit.UI;

namespace BimSkills.RevitDev.Commands
{
    [Transaction(TransactionMode.Manual)]
    [Regeneration(RegenerationOption.Manual)]
    public class BatchUpdateParamsCommand : IExternalCommand
    {
        public Result Execute(ExternalCommandData commandData, ref string message, ElementSet elements)
        {
            UIApplication uiApp = commandData.Application;
            UIDocument uiDoc = uiApp.ActiveUIDocument;
            Document doc = uiDoc.Document;

            // TransactionGroup per raggruppare modifiche multiple in un unico "Undo"
            using (TransactionGroup tg = new TransactionGroup(doc, "Aggiornamento Parametri WBS e CAM"))
            {
                tg.Start();

                using (Transaction tx = new Transaction(doc, "Popolamento Dati"))
                {
                    // Soppressione warning non bloccanti
                    FailureHandlingOptions failureOptions = tx.GetFailureHandlingOptions();
                    failureOptions.SetFailuresPreprocessor(new WarningSwallower());
                    tx.SetFailureHandlingOptions(failureOptions);

                    tx.Start();

                    try
                    {
                        // Esecuzione modifiche massive
                        var walls = new FilteredElementCollector(doc)
                            .OfCategory(BuiltInCategory.OST_Walls)
                            .WhereElementIsNotElementType()
                            .ToElements();

                        foreach (Element wall in walls)
                        {
                            Parameter p = wall.LookupParameter("Codice_WBS");
                            if (p != null && !p.IsReadOnly)
                            {
                                p.Set("WBS.STR.01.P00");
                            }
                        }

                        tx.Commit();
                    }
                    catch (Exception ex)
                    {
                        if (tx.HasStarted()) tx.RollBack();
                        tg.RollBack();
                        message = $"Errore durante l'aggiornamento: {ex.Message}";
                        return Result.Failed;
                    }
                }

                // Unifica le transazioni interne nella cronologia Undo
                tg.Assimilate();
            }

            TaskDialog.Show("Completato", "Parametri di commessa aggiornati con successo.");
            return Result.Succeeded;
        }
    }

    /// <summary>
    /// Disattiva i popup di warning non critici durante i comandi batch
    /// </summary>
    public class WarningSwallower : IFailuresPreprocessor
    {
        public FailureProcessingResult PreprocessFailures(FailuresAccessor failuresAccessor)
        {
            var failures = failuresAccessor.GetFailureMessages();
            foreach (FailureMessageAccessor failure in failures)
            {
                if (failure.GetSeverity() == FailureSeverity.Warning)
                {
                    failuresAccessor.DeleteWarning(failure);
                }
            }
            return FailureProcessingResult.Continue;
        }
    }
}
```

---

### 3. FilteredElementCollector: Prestazioni Ottimizzate

I filtri Revit API operano in memoria nativa C++ prima di marshallare gli oggetti verso il runtime .NET. L'ordine dei filtri è determinante per le prestazioni:

```csharp
// Esempio: Recupero muri portanti esterni al Piano Terra (Velocissimo)
Level targetLevel = new FilteredElementCollector(doc)
    .OfClass(typeof(Level))
    .Cast<Level>()
    .FirstOrDefault(l => l.Name == "Piano Terra");

if (targetLevel != null)
{
    // 1. Filtro rapido per categoria e istanza
    FilteredElementCollector collector = new FilteredElementCollector(doc)
        .OfCategory(BuiltInCategory.OST_Walls)
        .WhereElementIsNotElementType();

    // 2. Filtro rapido per livello di appartenenza
    ElementLevelFilter levelFilter = new ElementLevelFilter(targetLevel.Id);

    // 3. Filtro parametrico nativo per LoadBearing = True
    ParameterValueProvider pvpLoadBearing = new ParameterValueProvider(
        new ElementId(BuiltInParameter.WALL_STRUCTURAL_SIGNIFICANT)
    );
    FilterIntegerRule ruleLoadBearing = new FilterIntegerRule(
        pvpLoadBearing, new FilterNumericEquals(), 1
    );
    ElementParameterFilter structuralFilter = new ElementParameterFilter(ruleLoadBearing);

    // Applicazione combinata a livello C++ nativo
    var structuralWalls = collector
        .WherePasses(levelFilter)
        .WherePasses(structuralFilter)
        .Cast<Wall>()
        .ToList();
}
```

---

### 4. Comunicazione Asincrona UI Non Modale (`ExternalEvent`)

Per comunicare tra finestre WPF esterne / socket di rete e il thread principale di Revit senza generare eccezioni `InvalidOperationException: Cannot modify document outside transaction`:

```csharp
using Autodesk.Revit.UI;
using Autodesk.Revit.DB;

public class AsyncUpdateHandler : IExternalEventHandler
{
    public string NewParamValue { get; set; } = "DEFAULT_VAL";

    public void Execute(UIApplication app)
    {
        UIDocument uidoc = app.ActiveUIDocument;
        Document doc = uidoc.Document;

        using (Transaction tx = new Transaction(doc, "Async Update from UI"))
        {
            tx.Start();
            // Modifica elementi in sicurezza nel thread UI autorizzato da Revit
            var selection = uidoc.Selection.GetElementIds();
            foreach (ElementId id in selection)
            {
                Element el = doc.GetElement(id);
                Parameter p = el?.LookupParameter("Stato_Verifica");
                p?.Set(NewParamValue);
            }
            tx.Commit();
        }
    }

    public string GetName() => "AsyncUpdateHandler";
}

// Nel ViewModel o finestra WPF:
// ExternalEvent exEvent = ExternalEvent.Create(new AsyncUpdateHandler());
// exEvent.Raise(); // Accoda l'esecuzione nel loop di Revit
```

---

### 5. Manifest `.addin` Standard

Il file `.addin` deve essere posizionato in `%APPDATA%\Autodesk\Revit\Addins\[Anno]\`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<RevitAddIns>
  <AddIn Type="Application">
    <Name>BIM Skills Italia AddIn</Name>
    <Assembly>C:\ProgramData\BimSkills\BimSkills.RevitDev.dll</Assembly>
    <AddInId>87E4544D-4518-4908-9FE7-99E78F59C721</AddInId>
    <FullClassName>BimSkills.RevitDev.AppMain</FullClassName>
    <VendorId>VISIONXT</VendorId>
    <VendorDescription>VisionXt Tech - BIM Automation</VendorDescription>
  </AddIn>
</RevitAddIns>
```

---

## Anti-pattern nello Sviluppo Revit API

| Errore Tipico C# | Conseguenza | Soluzione Corretta |
| :--- | :--- | :--- |
| **Usare `.ToElements().Where(...)` con LINQ** | Carica in memoria migliaia di oggetti C# rallentando l'add-in di 10x | Applicare sempre `WherePasses(ElementFilter)` prima di estrarre la lista. |
| **Accedere a `doc.ActiveView` in IExternalDBApplication** | `NullReferenceException` bloccante | `ActiveView` e `ActiveUIDocument` esistono solo in contesto UI (`IExternalCommand`). |
| **Usare `IntegerValue` per gli ElementId in Revit 2024+** | Warning di deprecazione e troncamento a 64 bit su modelli enormi | Usare `elementId.Value` (tipo `long`). |
| **Passare valori metrici direttamente a `Parameter.Set(val)`** | Valori scalati in modo errato (es. 3 metri diventano 9.84 piedi) | Convertire sempre con `UnitUtils.ConvertToInternalUnits(val, UnitTypeId.Meters)`. |
| **Non richiamare `symbol.Activate()` prima di `NewFamilyInstance`** | Crash del comando con `ArgumentException` su tipi non attivi | Verificare `if (!symbol.IsActive) symbol.Activate();` prima della posa. |

---

## Output Strutturato

Quando invocata, la skill fornisce:
1. **Soluzioni Complete C# (.NET 8 o .NET 4.8)** pronte per la compilazione in Visual Studio / JetBrains Rider.
2. **File `.csproj` SDK-Style Ottimizzato** con configurazione dynamic loading per Revit 2024-2026.
3. **File Manifest `.addin`** con GUID univoci e percorsi assembly.
4. **Pattern di Gestione Eccezioni e Soppressione Warning**.
