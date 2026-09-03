---
name: naming-spatial-structure
description: >-
  Verifica approfondita della nomenclatura BIM di file e oggetti IFC e audit della struttura spaziale (IfcSite,
  IfcBuilding, IfcBuildingStorey, IfcSpace) e georeferenziazione secondo UNI 11337-5, ISO 19650-2 e ISO 16739-1.
  Usare per intercettare elementi orfani, quote incoerenti, nomi generici/default e violazioni della codifica di commessa.
---

# BIM Naming Convention & Spatial Structure Validation

Assistente specialistico per il **BIM Coordinator**, il **BIM Manager** e il **Quality Manager** nell'audit analitico della convenzione di nomenclatura dei file e degli oggetti digitali (secondo la norma **UNI 11337-5** e lo standard **ISO 19650-2**) e nella verifica della corretta gerarchia spaziale e georeferenziazione dei modelli in formato aperto **IFC (IFC4 / ISO 16739-1 e IFC2x3)**.

---

## Scope

Questa skill guida i controlli geometrico-spaziali e tassonomici preliminari prima dell'avvio della clash detection e dei computi metrici:
- **Validazione Formale del Nome File (UNI 11337-5)**: verifica sintattica e semantica di ogni token del nome file tramite espressioni regolari (regex) con decodifica dei campi obbligatori.
- **Audit della Nomenclatura di Oggetti, Tipi e Materiali IFC**: intercettazione ed eliminazione di nomi di default dei software di authoring (es. `Muro di base:Generico - 200mm`, `Element 12345`, `Default Family`) imponendo nomenclature descrittive e codici WBS.
- **Verifica della Gerarchia Spaziale Obbligatoria (ISO 16739-1)**:
  `IfcProject` $\rightarrow$ `IfcSite` $\rightarrow$ `IfcBuilding` $\rightarrow$ `IfcBuildingStorey` $\rightarrow$ `IfcSpace`
- **Rilevamento di Elementi Orfani (*Zero Orphan Policy*)**: individuazione di elementi fisici privi di assegnazione al piano tramite `IfcRelContainedInSpatialStructure`.
- **Audit delle Quote Altimetriche e dei Piani di Edificio**: verifica delle elevazioni assolute e relative di ciascun piano (`Elevation`), identificazione di quote duplicate o invertite (es. piano primo a quota inferiore al piano terra).
- **Controllo della Georeferenziazione e Coordinate Condivise**: verifica dell'orientamento al Nord Reale, del True North offset e della corretta impostazione di `IfcMapConversion` e `IfcProjectedCRS` (standard geodetico georeferenziato IFC4) per prevenire lo slittamento dei modelli federati.

---

## NON fa

- Non rinomina fisicamente i file o le entità all'interno del file IFC (fornisce la diagnosi esatta e lo script per correggere nel software di authoring).
- Non modifica le coordinate globali nel modello nativo.
- Non esegue verifiche dimensionali o strutturali sui componenti (muri, travi, solai).

---

## Normativa e Standard di Riferimento

1. **UNI 11337-5:2017**:
   - Convenzione di denominazione dei contenitori informativi (file) e regole di codifica per progetti digitali italiani;
   - Campi codificati per identificazione univoca.
2. **UNI EN ISO 19650-2:2019**:
   - Convenzione standard per la denominazione dei contenitori informativi e tracciamento delle revisioni di commessa.
3. **ISO 16739-1:2018 (IFC4)**:
   - Relazioni spaziali: `IfcRelAggregates` (scomposizione da progetto a sito, edificio, piano e vano) e `IfcRelContainedInSpatialStructure` (contenimento fisico degli elementi costruttivi nel piano);
   - Entità di georeferenziazione: `IfcMapConversion` e `IfcProjectedCRS` (coordinate cartografiche proiettate es. UTM WGS84).
4. **D.Lgs. 36/2023 & D.Lgs. 209/2024 (Allegato I.9)**:
   - Uniformità e coerenza informativa nei formati aperti non proprietari.

---

## Convenzione di Nomenclatura File (UNI 11337-5)

Il nome di ogni contenitore deve rispettare tassativamente la formula:

$$\text{[PROGETTO]}-\text{[EMITTENTE]}-\text{[ZONA]}-\text{[LIVELLO]}-\text{[DISCIPLINA]}-\text{[TIPO]}-\text{[PROGRESSIVO]}-\text{[REVISIONE]}.\text{[ESTENZIONE]}$$

### 1. Tabella dei Campi Ammessi:

| Campo | Caratteri | Descrizione | Valori Ammessi (Esempi) |
| :--- | :---: | :--- | :--- |
| **PROGETTO** | 3-6 | Codice univoco della commessa/opera | `OSP01`, `SCU02`, `PONTE3` |
| **EMITTENTE** | 3-5 | Codice identificativo della società/team | `ARCHS`, `INGST`, `MEPTE`, `GENCO` |
| **ZONA** | 2-4 | Suddivisione spaziale o corpo di fabbrica | `BL01` (Blocco 1), `BL02`, `GENE` (Tutti i blocchi) |
| **LIVELLO** | 3 | Quota di piano verticale | `INT` (Interrato), `P00` (Terra), `P01`, `P02`, `COV` (Copertura), `ZZZ` (Multilivello/Globale) |
| **DISCIPLINA**| 3 | Settore tecnico disciplinare | `ARC` (Architettura), `STR` (Strutture), `MEC` (Meccanico/HVAC), `ELE` (Elettrico), `IDR` (Idraulico), `SIC` (Sicurezza), `ECO` (Computi), `GEN` (Generale/Coordinamento) |
| **TIPO DOC** | 3 | Tipologia del contenitore informativo | `MOD` (Modello 3D), `TAV` (Tavola 2D), `REL` (Relazione), `COM` (Computo), `REP` (Report/Clash), `BCF` (File di issue), `SCH` (Scheda tecnica) |
| **PROGRESSIVO**| 4 | Cifre numeriche progressive | `0001` - `9999` |
| **REVISIONE** | 3 | Indice di stato/versione | `P01`, `P02` (in lavorazione Shared), `R01`, `R02` (contrattuale Published) |

### 2. Espressione Regolare di Validazione (Regex Ufficiale):
```regex
^[A-Z0-9]{3,6}-[A-Z0-9]{3,5}-[A-Z0-9]{2,4}-[A-Z0-9]{3}-[A-Z]{3}-[A-Z]{3}-[0-9]{4}-[A-Z0-9]{3}\.(ifc|IFC|pdf|PDF|dwg|DWG|bcfzip|BCFZIP|xlsx|XLSX)$
```

---

## Audit della Struttura Spaziale e Georeferenziazione IFC

```
IfcProject (Definizione Progetto, Unità di Misura e CRS)
  └── IfcRelAggregates
        └── IfcSite (Terreno / Compendio — RefLatitude, RefLongitude, Coordinate Geodetiche)
              └── IfcRelAggregates
                    └── IfcBuilding (Edificio / Corpo di Fabbrica — Quota Zero Edificio)
                          └── IfcRelAggregates
                                ├── IfcBuildingStorey [P00] (Piano Terra — Elevation = 0.00 m)
                                │     ├── IfcRelContainedInSpatialStructure ──→ [IfcWall, IfcColumn, IfcSlab...]
                                │     └── IfcRelAggregates ──→ IfcSpace [Vano 01] (Destinazione d'Uso)
                                └── IfcBuildingStorey [P01] (Piano Primo — Elevation = 3.50 m)
                                      └── IfcRelContainedInSpatialStructure ──→ [IfcWall, IfcDoor, IfcWindow...]
```

### Regole Spaziali Bloccanti:
1. **Un solo `IfcProject`** radice per file;
2. Almeno un **`IfcSite`** presente con coordinate espresse in latitudine/longitudine o mappatura cartografica `IfcMapConversion`;
3. Almeno un **`IfcBuilding`** formalmente denominato (vietati nomi vuoti o placeholder);
4. Tutti gli **`IfcBuildingStorey`** devono avere:
   - `Name` univoco e coerente con la codifica (es. `P00 - Piano Terra`, `P01 - Piano Primo`);
   - `Elevation` popolata con valore in metri coerente (ordinamento crescente rigoroso);
5. **Zero Elementi Orfani**: nessun elemento costruttivo (`IfcWall`, `IfcBeam`, `IfcDoor`, `IfcPipeSegment`, ecc.) può essere privo della relazione `IfcRelContainedInSpatialStructure`.

---

## Nomenclatura Oggetti IFC (*Object Naming Strategy*)

La qualità di un modello IFC dipende dalla leggibilità dei suoi componenti interni. La skill controlla:

### 1. Attributi Obbligatori degli Elementi (`IfcRoot`):
- `Name`: DEVE contenere una dicitura parlante strutturata, es. `[CATEGORIA]_[TIPO]_[SPESSORE/DIMENSIONE]_[MATERIALE]`;
  - *Non conforme:* `Muro di base:Generico 200mm:23451`
  - *Conforme:* `MUR_TRAMEZZA_SP10_LATERIZIO_INT`
- `Description`: DEVE descrivere la funzione specifica del componente (es. *Tramezzatura interna a doppio corso forato con intonaco civile*);
- `ObjectType`: DEVE riportare il codice di catalogo o il riferimento alla tipologia di sistema;
- `Tag`: codice identificativo di cantiere o codice WBS di progetto.

### 2. Controllo dei Nomi di Default e Placeholder:
La scansione blocca tutti gli oggetti contenenti stringhe di default:
- `Default*`, `Generico*`, `Generic*`, `Family*`, `Box*`, `Nuovo*`, `Element*`, `Type*`.

---

## Script Python di Validazione (`audit_naming_spatial.py`)

Script specialistico basato su `ifcopenshell` per la verifica completa di nomenclatura e gerarchia:

```python
import re
import sys
import ifcopenshell
import ifcopenshell.util.element

# Regex ufficiale UNI 11337-5
FILENAME_REGEX = re.compile(
    r"^[A-Z0-9]{3,6}-[A-Z0-9]{3,5}-[A-Z0-9]{2,4}-[A-Z0-9]{3}-[A-Z]{3}-[A-Z]{3}-[0-9]{4}-[A-Z0-9]{3}\.[a-zA-Z0-9]+$"
)

BANNED_OBJECT_PATTERNS = [
    re.compile(r"^muro di base", re.I),
    re.compile(r"^generic", re.I),
    re.compile(r"^default", re.I),
    re.compile(r"^family\d+", re.I),
    re.compile(r"^element\d+", re.I)
]


def audit_naming_and_spatial(ifc_file_path):
    import os
    filename = os.path.basename(ifc_file_path)
    issues = []

    print(f"\nVerifica Nomenclatura e Struttura: {filename}")

    # 1. Verifica Nomenclatura Nome File
    if not FILENAME_REGEX.match(filename):
        issues.append({
            "severita": "ALTA",
            "ambito": "Nome File",
            "oggetto": filename,
            "dettaglio": "Il nome del file viola il pattern standard UNI 11337-5"
        })
    else:
        print("✓ Nome file conforme allo standard UNI 11337-5")

    model = ifcopenshell.open(ifc_file_path)

    # 2. Controllo Struttura Spaziale e Piani
    sites = model.by_type("IfcSite")
    buildings = model.by_type("IfcBuilding")
    storeys = model.by_type("IfcBuildingStorey")

    if not sites:
        issues.append({"severita": "CRITICA", "ambito": "Struttura Spaziale", "oggetto": "IfcSite", "dettaglio": "IfcSite assente"})
    if not buildings:
        issues.append({"severita": "CRITICA", "ambito": "Struttura Spaziale", "oggetto": "IfcBuilding", "dettaglio": "IfcBuilding assente"})
    if not storeys:
        issues.append({"severita": "CRITICA", "ambito": "Struttura Spaziale", "oggetto": "IfcBuildingStorey", "dettaglio": "Nessun piano definito nel modello"})

    # Verifica quote dei piani
    elevations = []
    for s in storeys:
        if not s.Name or len(s.Name.strip()) == 0:
            issues.append({"severita": "ALTA", "ambito": "Piani", "oggetto": s.GlobalId, "dettaglio": "Nome del piano vuoto"})
        if s.Elevation is None:
            issues.append({"severita": "CRITICA", "ambito": "Piani", "oggetto": s.Name, "dettaglio": "Parametro Elevation nullo"})
        else:
            elevations.append((s.Name, float(s.Elevation)))

    # Controllo ordinamento quote
    for i in range(len(elevations) - 1):
        if elevations[i][1] > elevations[i+1][1]:
            issues.append({
                "severita": "CRITICA",
                "ambito": "Quote Piani",
                "oggetto": f"{elevations[i][0]} vs {elevations[i+1][0]}",
                "dettaglio": f"Quota invertita: {elevations[i][0]} ({elevations[i][1]} m) > {elevations[i+1][0]} ({elevations[i+1][1]} m)"
            })

    # 3. Controllo Elementi Orfani
    contained_elements = set()
    for rel in model.by_type("IfcRelContainedInSpatialStructure"):
        for elem in rel.RelatedElements:
            contained_elements.add(elem.id())

    physical_elements = model.by_type("IfcElement")
    orphan_count = 0
    for elem in physical_elements:
        if elem.id() not in contained_elements:
            orphan_count += 1
            if orphan_count <= 10:  # Limita i log ai primi 10
                issues.append({
                    "severita": "ALTA",
                    "ambito": "Elementi Orfani",
                    "oggetto": f"{elem.is_a()} ({elem.GlobalId})",
                    "dettaglio": f"Elemento non contenuto in alcun piano spaziale (Nome: {elem.Name})"
                })
    if orphan_count > 10:
        issues.append({
            "severita": "ALTA",
            "ambito": "Elementi Orfani",
            "oggetto": f"Totale Orfani: {orphan_count}",
            "dettaglio": f"Ulteriori {orphan_count - 10} elementi orfani rilevati nel modello"
        })

    # 4. Controllo Nomenclatura Oggetti e Default Names
    bad_named_elements = 0
    for elem in physical_elements:
        name = elem.Name or ""
        for pattern in BANNED_OBJECT_PATTERNS:
            if pattern.search(name):
                bad_named_elements += 1
                if bad_named_elements <= 10:
                    issues.append({
                        "severita": "MEDIA",
                        "ambito": "Nomenclatura Oggetti",
                        "oggetto": f"{elem.is_a()} ({elem.GlobalId})",
                        "dettaglio": f"Nome oggetto generico/di default software non conforme: '{name}'"
                    })
                break

    # Riepilogo
    print(f"\nAudit completato. Rilevate {len(issues)} non conformità.")
    return issues
```

---

## Modello di Report di Audit della Struttura Spaziale

```markdown
# REPORT AUDIT STRUTTURA SPAZIALE & NOMENCLATURA IFC

**File Esaminato**: `SCUOLA01-ARCHS-BL01-ZZZ-ARC-MOD-0001-R01.ifc`
**Schema IFC**: IFC4 (ISO 16739-1:2018)
**Data Verifica**: 03/09/2026 — **Auditor**: BIM Coordinator

## 1. Esito Nomenclatura File (UNI 11337-5)
- **Stato**: **CONFORME**
- *Decodifica*: Commessa `SCUOLA01` | Emittente `ARCHS` | Zona `BL01` | Livello `ZZZ` | Disciplina `ARC` | Tipo `MOD` | Progressivo `0001` | Revisione `R01`

## 2. Esito Struttura Spaziale e Georeferenziazione
- **Gerarchia Spaziale**: `IfcProject` $\rightarrow$ `IfcSite` $\rightarrow$ `IfcBuilding` $\rightarrow$ 3 `IfcBuildingStorey`
- **Georeferenziazione**: Presente (`IfcMapConversion` attiva su sistema geodetico proiettato WGS84 / UTM Fuso 32N)
- **Piani Censiti**:
  - `P00 - Piano Terra` (Quota: `+0.00 m`)
  - `P01 - Piano Primo` (Quota: `+3.60 m`)
  - `COV - Copertura` (Quota: `+7.20 m`)
- **Controllo Quote**: Conforme (Ordinamento monotono crescente corretto)

## 3. Rilievi e Non Conformità

| Severità | Ambito | Entità Coinvolta (GUID) | Dettaglio Errore Riscontrato | Azione Correttiva |
| :---: | :--- | :--- | :--- | :--- |
| **ALTA** | Elementi Orfani | `IfcWall` (`3vX_01$8rB4...`) | Setto murario privo di relazione di contenimento spaziale | Assegnare esplicitamente al piano `P00` |
| **ALTA** | Elementi Orfani | `IfcDoor` (`1aQ_99$2wC0...`) | Porta interna priva di piano di appartenenza | Ricollegare alla parete ospite nel piano `P01` |
| **MEDIA**| Nomi Oggetto | `IfcSlab` (`0jK_44$1zM8...`) | Nome generico software: `Muro di base:Soletta Generica 250` | Rinominare in `SOL_SOLAIO_LATEROCEM_SP25` |

## 4. Esito Conclusivo
**ESITO: RESPINTO (Codice CR)**. Il file non può essere pubblicato in area `Shared` fino alla totale risoluzione dei 2 elementi orfani.
```

---

## Anti-pattern Spaziali e di Nomenclatura

| Errore Tipico | Conseguenza di Commessa | Correzione Obbligatoria |
| :--- | :--- | :--- |
| **Nomi file con spazi o caratteri speciali (`%`, `&`, `#`)** | **Crash delle piattaforme cloud ACDat** e rottura dei collegamenti ipertestuali | Utilizzare solo caratteri alfanumerici maiuscoli e il trattino `-` come separatore. |
| **Piani senza quota altimetrica (`Elevation` = None)** | **Impossibilità di federare i modelli** (gli elementi galleggiano nello spazio) | Definire l'altezza reale in metri per ogni `IfcBuildingStorey`. |
| **Tollerare elementi orfani nel modello** | **Gli elementi scompaiono nelle viste per piano** e vengono esclusi dai computi 5D | Assegnare ogni elemento a un piano tramite `IfcRelContainedInSpatialStructure`. |
| **Modelli non georeferenziati o con origini arbitrarie** | **Modelli che atterrano a chilometri di distanza** nelle federazioni multidisciplinari | Bloccare l'origine e il sistema di coordinate condivise all'avvio della commessa. |
| **Nomi di default software per gli oggetti** | **Impossibilità di associare voci di computo (Qto)** o regole di manutenzione CAFM | Istituire una codifica parlante degli oggetti basata sulle tabelle tecnologiche UNI 8290. |

---

## Output Strutturato

Quando invocata, la skill genera:
1. **Report di Conformità Nomenclatura e Struttura Spaziale** (con decodifica token UNI 11337-5 e tabella quote).
2. **Elenco Completo degli Elementi Orfani con GUID** pronti per l'assegnazione nei software di authoring.
3. **Elenco degli Oggetti con Nomenclatura Generica da Bonificare**.
4. **Script di Diagnosi Python Personalizzato** per controlli batch su modelli multipli.

---

## Limiti

- La verifica della corretta denominazione delle stanze (`IfcSpace`) richiede la presenza del layout funzionale di progetto nel modello architettonico.
- La georeferenziazione cartografica avanzata (rotazione angolo topografico su Gauss-Boaga/UTM) deve essere asseverata con il rilievo plano-altimetrico del topografo.
