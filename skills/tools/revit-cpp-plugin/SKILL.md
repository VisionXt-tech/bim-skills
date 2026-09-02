# Revit C++ Plugin Development

Assistente per lo sviluppo di plugin nativi C++ per Revit tramite l'API C++.

## Scope

- Plugin performance-critical per Revit (geometria, calcolo, export custom)
- Wrapper C++/CLI per bridge tra C++ nativo e Revit .NET API
- Librerie native chiamate da add-in C#
- Ottimizzazione di operazioni batch su grandi modelli

## NON fa

- Non genera add-in C# puri (vedi skill `revit-api`)
- Non gestisce il deployment o l'installer del plugin
- Non supporta versioni Revit precedenti alla 2022 senza conferma

## Precisazione importante: la Revit API e SOLO .NET managed

La Revit API (`RevitAPI.dll`, `RevitAPIUI.dll`) e distribuita **esclusivamente come libreria .NET managed**. Autodesk non offre e non supporta un'API C++ nativa per Revit: l'add-in stesso (la classe che implementa `IExternalCommand`/`IExternalApplication`, il file `.addin`, la UI) deve sempre essere scritto in un linguaggio .NET compliant — C#, VB.NET o **C++/CLI** (la variante managed di C++ che compila verso il CLR).

Questo significa che:
- **Non esiste** un percorso per scrivere un add-in Revit interamente in C++ nativo (Win32/ISO C++) che chiami direttamente `RevitAPI.dll`
- Il C++ nativo entra in gioco solo come **libreria esterna** (calcolo, geometria, parsing di formati pesanti) richiamata dall'add-in .NET tramite:
  1. **C++/CLI come bridge**: un progetto C++/CLI (`.vcxproj` con `/clr`) referenzia sia `RevitAPI.dll` (`#using`) sia la libreria C++ nativa, e espone classi `public ref class` consumabili da C#
  2. **P/Invoke**: se la libreria nativa espone una API C-style (`extern "C"`), un add-in C# puo chiamarla direttamente con `[DllImport(...)]`, senza bisogno di C++/CLI — piu semplice quando non serve passare oggetti Revit API alla libreria nativa
- Per compatibilita mista: l'add-in compilato con una versione del VC++ Runtime deve corrispondere al redistributable supportato dalla versione di Revit target (Autodesk documenta il runtime richiesto per release)

In sintesi: questa skill non genera "un add-in Revit in C++", genera **codice C++ nativo per il calcolo** piu il **bridge C++/CLI o P/Invoke** che lo collega a un add-in C# (skill `revit-api`).

## Quando usare C++ vs C#

| Scenario | Linguaggio |
|----------|-----------|
| UI, ribbon, comandi standard, chiamate dirette alla Revit API | C# (vedi `revit-api`) |
| Calcolo geometrico pesante | C++ nativo + bridge (C++/CLI o P/Invoke) |
| Parsing di file grandi (IFC, point cloud) | C++ nativo |
| Interop con librerie C/C++ esistenti (CGAL, OpenCASCADE) | C++ nativo |
| Operazioni su 100k+ elementi con calcolo puro (non chiamate Revit API) | C++ puo essere piu veloce |
| Qualsiasi chiamata a `Autodesk.Revit.DB`/`Autodesk.Revit.UI` | SEMPRE .NET (C#, VB.NET o C++/CLI) — mai C++ nativo diretto |
| Tutto il resto | C# e sufficiente |

## Pattern: C++/CLI Bridge

```cpp
// NativeLib.h — libreria C++ pura
#pragma once

namespace NativeLib {
    struct MeshData {
        std::vector<double> vertices;
        std::vector<int> indices;
    };
    
    MeshData ProcessGeometry(const double* points, int count);
}
```

```cpp
// ManagedBridge.h — wrapper C++/CLI
#pragma once
#using <RevitAPI.dll>

using namespace Autodesk::Revit::DB;

namespace ManagedBridge {
    public ref class GeometryProcessor {
    public:
        static array<XYZ^>^ Process(array<XYZ^>^ points);
    };
}
```

## Pattern alternativo: P/Invoke (quando non serve passare oggetti Revit API alla libreria nativa)

Se la libreria C++ nativa lavora solo su dati primitivi (array di double, struct semplici) e non deve mai vedere tipi `Autodesk.Revit.DB.*`, P/Invoke evita del tutto il progetto C++/CLI intermedio.

```cpp
// NativeCalc.h — libreria nativa con interfaccia C-style esportata
extern "C" {
    __declspec(dllexport) void ProcessPoints(const double* xyz, int count, double* resultOut);
}
```

```csharp
// add-in C# — chiama direttamente la DLL nativa
using System.Runtime.InteropServices;

internal static class NativeCalc
{
    [DllImport("NativeCalc.dll", CallingConvention = CallingConvention.Cdecl)]
    internal static extern void ProcessPoints(double[] xyz, int count, double[] resultOut);
}

// nel comando: convertire XYZ Revit -> double[] PRIMA di passare al nativo,
// poi ricostruire XYZ dal risultato — la conversione resta responsabilita del layer C#
```

## Regole

1. **Separare** codice nativo (calcolo puro) da codice managed (bridge C++/CLI o add-in C#)
2. **Nessuna chiamata diretta** da C++ nativo a `RevitAPI.dll`/`RevitAPIUI.dll` — non e supportato, serve sempre un layer .NET
3. **Scegliere il bridge**: C++/CLI se la libreria nativa deve ricevere/restituire tipi Revit API (es. `XYZ`, `ElementId`); P/Invoke se lavora solo su dati primitivi
4. **Memory management** — RAII nel layer nativo, GC nel layer managed, attenzione a marshalling di array/struct al confine P/Invoke
5. **Thread safety** — Revit API e single-threaded, sincronizzare SEMPRE le chiamate che rientrano nel contesto Revit
6. **Build** — target x64, stessa versione del VC++ Runtime richiesta dalla versione di Revit target (non mischiare redistributable)
7. **Unita** — piedi internamente in Revit API; la libreria nativa spesso lavora in unita "neutre" (metri/mm) — convertire ESPLICITAMENTE al confine, mai assumere che le unita coincidano
