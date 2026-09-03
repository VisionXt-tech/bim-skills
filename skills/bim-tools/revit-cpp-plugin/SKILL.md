---
name: revit-cpp-plugin
description: >-
  Sviluppo avanzato di librerie C++ native ad alte prestazioni per BIM e Autodesk Revit tramite bridge C++/CLI o P/Invoke
  con add-in C# (.NET 8 e .NET 4.8). Usare per calcolo geometrico intensivo, algoritmi SIMD/OpenMP, KD-Tree, mesh boolean,
  parsing point cloud/IFC e interoperabilita con kernel C++ (CGAL, OpenCASCADE, Eigen).
---

# BIM High-Performance C++ Native Plugins & Revit Bridges

Guida specialistica di riferimento per l'integrazione di librerie e motori di calcolo in **C++ nativo (C++20/C++23)** ad altissime prestazioni con **Autodesk Revit**, tramite bridge **P/Invoke (C-ABI)** o wrapper **C++/CLI**, garantendo massima efficienza nell'elaborazione geometrica intensiva, gestione di nuvole di punti (*point clouds*), algoritmi di collisione vettoriale e parsing di modelli massivi.

---

## Scope

Questa skill fornisce architetture ibride, pattern di marshalling e ottimizzazioni per:
- **Architettura Ibrida Managed/Nativa**: separazione rigorosa tra layer applicativo Revit (.NET C#) e motore computazionale numerico (C++ nativo compilato a 64 bit).
- **Integrazione P/Invoke ad Alte Prestazioni**: esportazione di interfacce C-Style (`extern "C" __declspec(dllexport)`) con marshalling a costo zero tramite tipi blittabili e puntatori bloccati in memoria (`fixed` / `GCHandle.Pinned`).
- **Compatibilità Totale con .NET 8 (Revit 2025/2026)**: strategie P/Invoke per evitare le complessità di migrazione C++/CLI in CoreCLR.
- **Calcolo Geometrico Parallelo Multithreading (OpenMP / C++20 `std::jthread`)**: esecuzione di calcoli multithread su milioni di vertici senza violare il vincolo single-thread di Revit API.
- **Algoritmi di Spazializzazione e Mesh Processing**: implementazione di KD-Tree, AABB Tree, calcolo di scavi/riporti volumetrici, triangolazione di Delaunay e mesh boolean.
- **Interoperabilità con Kernel Geometrici Esterni**: integrazione con librerie C++ industriali come **CGAL**, **OpenCASCADE**, **Eigen** e **Intel Embree** (ray tracing).

---

## NON fa

- Non crea add-in Revit puramente in C++ nativo (Revit API è distribuita **esclusivamente come assembly .NET managed**; non esiste un SDK C++ nativo come ObjectARX per AutoCAD).
- Non esegue chiamate a classi `Autodesk.Revit.DB` da thread nativi C++ in background (Revit API genera eccezioni immediate se invocata fuori dal thread principale).
- Non trascura la deallocazione della memoria (memory leak nel layer C++ degradano la sessione di Revit fino al crash).

---

## Quando Usare C++ Nativo vs C# Puro

| Scenario Tecnico | Scelta Consigliata | Rationale Tecnico |
| :--- | :---: | :--- |
| **Comandi standard, Ribbon UI, manipolazione parametri** | **C# Puro** | Accesso diretto alle API managed, facilità di manutenzione e debug. |
| **Calcolo interferenze geometriche su mesh complesse** | **C++ Nativo** | Vettorizzazione SIMD (AVX2/AVX-512), multithreading OpenMP fino a 20x più veloce. |
| **Filtro e decimazione di nuvole di punti (Point Clouds)** | **C++ Nativo** | Accesso diretto alla memoria contigua, algoritmi KD-Tree e Octree senza GC overhead. |
| **Scomposizione volumetrica scavi e riporti da mesh topografiche** | **C++ Nativo** | Integrazione con librerie di calcolo geometrico esatto (CGAL / OpenCASCADE). |
| **Parsing massivo di file IFC / file SPF proprietari** | **C++ Nativo** | Lettura I/O memory-mapped (`std::pmr`) ad altissima velocità. |

---

## Pattern Raccomandato: P/Invoke con Marshalling a Costo Zero (Zero-Copy)

L'approccio P/Invoke è il più robusto, pulito e moderno, garantendo compatibilità immediata sia su **Revit 2022-2024 (.NET Framework 4.8)** sia su **Revit 2025-2026 (.NET 8 CoreCLR)**:

### 1. Codice C++ Nativo: Engine Computazionale (`NativeEngine.h` e `.cpp`)

Compilato in una DLL nativa x64 (`GeometryEngineNative.dll`):

```cpp
// NativeEngine.h
#pragma once

#ifdef GEOMETRYENGINE_EXPORTS
#define NATIVE_API extern "C" __declspec(dllexport)
#else
#define NATIVE_API extern "C" __declspec(dllimport)
#endif

// Struttura blittabile allineata identica tra C++ e C#
#pragma pack(push, 8)
struct Vector3D {
    double x;
    double y;
    double z;
};
#pragma pack(pop)

// API C-Style pura esportata per P/Invoke
NATIVE_API int ProcessVerticesOpenMP(
    const Vector3D* inputVertices, 
    int count, 
    double scaleFactor, 
    Vector3D* outputVertices
);
```

```cpp
// NativeEngine.cpp
#include "NativeEngine.h"
#include <omp.h>
#include <cmath>

NATIVE_API int ProcessVerticesOpenMP(
    const Vector3D* inputVertices, 
    int count, 
    double scaleFactor, 
    Vector3D* outputVertices) 
{
    if (!inputVertices || !outputVertices || count <= 0) {
        return -1; // Errore parametri non validi
    }

    // Calcolo multithread parallelo nativo tramite OpenMP
    #pragma omp parallel for schedule(static)
    for (int i = 0; i < count; ++i) {
        // Esempio elaborazione geometrica intensiva
        outputVertices[i].x = inputVertices[i].x * scaleFactor;
        outputVertices[i].y = inputVertices[i].y * scaleFactor;
        outputVertices[i].z = std::sqrt(std::abs(inputVertices[i].z)) * scaleFactor;
    }

    return 0; // Successo
}
```

---

### 2. Codice C# (.NET Managed): Chiamata Add-In e Conversione Revit (`NativeBridge.cs`)

L'add-in Revit estrae le coordinate dagli elementi del modello, le blocca in memoria e le passa al motore C++ senza allocazioni intermedie (*zero-copy pinning*):

```csharp
using System;
using System.Runtime.InteropServices;
using Autodesk.Revit.DB;

namespace BimSkills.RevitDev.Interop
{
    [StructLayout(LayoutKind.Sequential, Pack = 8)]
    public struct Vector3D
    {
        public double X;
        public double Y;
        public double Z;

        public Vector3D(double x, double y, double z)
        {
            X = x;
            Y = y;
            Z = z;
        }

        public XYZ ToRevitXYZ() => new XYZ(X, Y, Z);
    }

    internal static class NativeMethods
    {
        private const string NativeDllPath = "GeometryEngineNative.dll";

        [DllImport(NativeDllPath, CallingConvention = CallingConvention.Cdecl)]
        public static extern unsafe int ProcessVerticesOpenMP(
            Vector3D* inputVertices,
            int count,
            double scaleFactor,
            Vector3D* outputVertices
        );
    }

    public static class GeometryService
    {
        public static unsafe XYZ[] OptimizeMesh(XYZ[] revitPoints, double factor)
        {
            int count = revitPoints.Length;
            var inputBuffer = new Vector3D[count];
            var outputBuffer = new Vector3D[count];

            // 1. Conversione da coordinate interne Revit (feet) al buffer
            for (int i = 0; i < count; i++)
            {
                inputBuffer[i] = new Vector3D(revitPoints[i].X, revitPoints[i].Y, revitPoints[i].Z);
            }

            // 2. Chiamata diretta alla DLL C++ nativa bloccando i buffer in RAM
            fixed (Vector3D* pInput = inputBuffer)
            fixed (Vector3D* pOutput = outputBuffer)
            {
                int resultCode = NativeMethods.ProcessVerticesOpenMP(pInput, count, factor, pOutput);
                if (resultCode != 0)
                {
                    throw new InvalidOperationException("Errore computazionale nel motore C++ nativo.");
                }
            }

            // 3. Ricostruzione coordinate Revit dal risultato
            var results = new XYZ[count];
            for (int i = 0; i < count; i++)
            {
                results[i] = outputBuffer[i].ToRevitXYZ();
            }

            return results;
        }
    }
}
```

---

## Pattern Alternativo: Wrapper C++/CLI (`/clr`)

Utile quando il layer C++ deve consumare direttamente tipi gestiti di Revit API (`Autodesk::Revit::DB::XYZ^`):

```cpp
// ManagedWrapper.h
#pragma once
#using <RevitAPI.dll>

using namespace Autodesk::Revit::DB;

namespace BimSkills::RevitDev::Interop {
    public ref class MeshOptimizerCLI {
    public:
        static array<XYZ^>^ ComputeKDTree(array<XYZ^>^ points, double searchRadius) {
            // Conversione array managed -> std::vector<NativePoint>
            // Esecuzione algoritmo C++ nativo
            // Riconversione in array<XYZ^>^ managed
            return points;
        }
    };
}
```

---

## Regole di Sicurezza e Prestazioni

1. **Gestione della Memoria RAII nel Layer C++**: non usare mai `malloc` o `new` grezzi; utilizzare `std::vector`, `std::unique_ptr` o allocatori di memoria contigua (*arena allocators*).
2. **Allineamento e Conversione Unità di Misura**: Revit opera internamente in **piedi decimali (feet)**. Il layer di interfaccia C# deve convertire le quote in metri/millimetri prima di passarle alla libreria C++ se quest'ultima si aspetta grandezze metriche.
3. **Puntatori Bloccati (*Memory Pinning*)**: quando si passano array managed al C++ tramite P/Invoke, usare la keyword `fixed` per impedire al Garbage Collector di spostare i byte in memoria durante l'elaborazione.
4. **Target di Compilazione Rigoroso**: compilare sempre e solo per architettura **x64**. I puntatori a 32 bit non sono compatibili con Revit.

---

## Output Strutturato

Quando invocata, la skill fornisce:
1. **Header C++ (`.h`) e Sorgente (`.cpp`) Ottimizzati** per compilazione in libreria dinamica (.dll) nativa.
2. **Definizione Struct Blittabili e Firme `[DllImport]` in C#**.
3. **Pattern di Chiamata `unsafe fixed` Zero-Copy** per l'elaborazione di mesh e geometrie.
4. **Istruzioni di Configurazione di Visual Studio (OpenMP, AVX2, Target x64)**.
