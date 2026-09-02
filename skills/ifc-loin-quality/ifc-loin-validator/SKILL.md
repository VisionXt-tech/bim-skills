# IFC LOIN Validator

Validazione di modelli IFC rispetto a matrici LOIN di progetto. Verifica completezza LoG, LoI, pset e proprieta obbligatorie.

## Scope

Questa skill supporta il BIM Coordinator nella:
- Verifica automatica di modelli IFC rispetto a matrice LOIN
- Audit di proprieta obbligatorie (pset) per categoria di elemento
- Controllo struttura spaziale (IfcSite/IfcBuilding/IfcBuildingStorey)
- Generazione report di non conformita con riferimenti normativi
- Preparazione gate ACDat per passaggio da Shared a Published

## NON fa

- Non modifica il modello IFC sorgente (read-only)
- Non esegue clash detection (vedi skill `clash-detection`)
- Non verifica la geometria 3D (solo proprieta e struttura)
- Non valida la correttezza progettuale (solo completezza informativa)

## Normativa di riferimento

- **UNI 11337-4** — Livelli di fabbisogno informativo (LOIN)
- **UNI EN 17412-1** — Level of Information Need framework
- **ISO 16739-1:2018** — IFC4 data schema
- **UNI 11337-5** — Nomenclatura e struttura dei contenitori informativi
- **ISO 19650-2** — Information delivery planning e gate di verifica

## Prerequisiti

- Python 3.8+ con `ifcopenshell` installato (API stabile su 0.7.x/0.8.x — verificare `ifcopenshell.version` prima di usare funzioni recenti)
- Modello IFC da validare (IFC2x3, IFC4 o IFC4X3)
- Matrice LOIN in formato JSON o CSV (opzionale — se assente usa baseline normativa)

## Workflow

### Fase 1: Caricamento e analisi preliminare

1. Chiedi all'utente:
   - Path del file IFC da validare
   - Path della matrice LOIN (JSON/CSV) — se disponibile
   - Fase progettuale corrente (PFTE, PD, PE, esecuzione, as-built)
   - Eventuali categorie da escludere dalla verifica
2. Carica il modello IFC con ifcopenshell
3. Esegui analisi preliminare:
   - Conteggio entita per tipo IFC
   - Verifica schema IFC (IFC2x3 vs IFC4)
   - Check struttura spaziale base

### Fase 2: Verifica struttura spaziale

Verifica la gerarchia spaziale obbligatoria:

```
IfcProject
  └── IfcSite
       └── IfcBuilding
            └── IfcBuildingStorey (uno per piano)
                 └── [elementi]
```

Controlli:
- Esiste almeno un IfcSite con coordinate valide
- Esiste almeno un IfcBuilding con nome significativo
- Ogni IfcBuildingStorey ha elevazione definita
- Nessun elemento orfano (non assegnato a un piano)
- IfcSpace presenti se richiesti dalla matrice LOIN

### Fase 3: Verifica LOIN per categoria

Per ogni categoria di elemento presente nel modello:

1. **LoG (Level of Geometry)**: verifica che la rappresentazione geometrica sia coerente con la fase
   - PFTE: volumi e superfici (LoG basso)
   - PD: geometria di massima con aperture
   - PE: geometria dettagliata con materiali
   - As-built: geometria esatta come costruito

2. **LoI (Level of Information)**: verifica proprieta obbligatorie per fase
   - Controlla i pset standard IFC4 (Pset_WallCommon, Pset_DoorCommon, Pset_WindowCommon, Pset_SlabCommon, Pset_SpaceCommon)
   - Controlla le quantita di base (Qto_WallBaseQuantities, Qto_SlabBaseQuantities, ...)
   - Controlla proprieta custom richieste dalla matrice LOIN
   - Verifica che i valori non siano vuoti, null o placeholder ("TBD", "XXX", "000")

3. **Classificazione**: verifica sistema di classificazione
   - In Italia non esiste un adattamento ufficiale di Uniclass 2015: la prassi comune e l'uso di codici WBS/CDS definiti nel Capitolato Informativo secondo UNI 11337-2 (denominazione e classificazione) e UNI/TS 11337-3 (codifica di opere, prodotti, attivita e risorse)
   - Se il progetto adotta Uniclass 2015 (frequente su commesse internazionali), verificare i riferimenti tramite `IfcClassificationReference` collegati a `IfcClassification`
   - Ogni elemento ha un codice di classificazione valido secondo il sistema dichiarato nel CI — non assumere un sistema di default

### Pset standard IFC4 per categoria (riferimento buildingSMART)

Elenco delle proprieta effettivamente definite nei pset comuni IFC4 (fonte: buildingSMART IFC4 Property Set Definitions). Usare questa tabella come base minima — la matrice LOIN di progetto puo richiederne un sottoinsieme o proprieta aggiuntive.

| Pset | Applicabile a | Proprieta (nome esatto, tipo) |
|------|----------------|-------------------------------|
| `Pset_WallCommon` | IfcWall | Reference (IfcIdentifier), Status (IfcLabel, enum: NEW/EXISTING/DEMOLISH/...), AcousticRating (IfcLabel), FireRating (IfcLabel), Combustible (IfcBoolean), SurfaceSpreadOfFlame (IfcLabel), ThermalTransmittance (IfcThermalTransmittanceMeasure), IsExternal (IfcBoolean), ExtendToStructure (IfcBoolean), LoadBearing (IfcBoolean), Compartmentation (IfcBoolean) |
| `Pset_DoorCommon` | IfcDoor | Reference, Status, FireRating, AcousticRating, SecurityRating, DurabilityRating, HygrothermalRating, IsExternal (IfcBoolean), Infiltration (IfcVolumetricFlowRateMeasure), ThermalTransmittance, GlazingAreaFraction (IfcPositiveRatioMeasure), HandicapAccessible (IfcBoolean), HasDrive (IfcBoolean), FireExit (IfcBoolean), SelfClosing (IfcBoolean), SmokeStop (IfcBoolean) |
| `Pset_WindowCommon` | IfcWindow | Reference, Status, AcousticRating, FireRating, SecurityRating, IsExternal, Infiltration, ThermalTransmittance, GlazingAreaFraction, HasSillExternal (IfcBoolean), HasSillInternal (IfcBoolean), HasDrive (IfcBoolean), SmokeStop (IfcBoolean), FireExit (IfcBoolean) |
| `Pset_SlabCommon` | IfcSlab | Reference, Status, AcousticRating, FireRating, Combustible, SurfaceSpreadOfFlame, ThermalTransmittance, IsExternal, LoadBearing, Compartmentation, PitchAngle (IfcPlaneAngleMeasure) |
| `Pset_SpaceCommon` | IfcSpace | Reference, IsExternal (IfcBoolean), GrossPlannedArea (IfcAreaMeasure), NetPlannedArea (IfcAreaMeasure), PubliclyAccessible (IfcBoolean), HandicapAccessible (IfcBoolean) |
| `Qto_WallBaseQuantities` | IfcWall | Length, Width, Height, GrossFootprintArea, NetFootprintArea, GrossSideArea, NetSideArea, GrossVolume, NetVolume, GrossWeight, NetWeight (tutte Q_LENGTH/Q_AREA/Q_VOLUME/Q_WEIGHT) |
| `Qto_SlabBaseQuantities` | IfcSlab | Width, Length, Depth, Perimeter, GrossArea, NetArea, GrossVolume, NetVolume, GrossWeight, NetWeight |

Nota: `Status`, `SecurityRating`, `DurabilityRating`, `HygrothermalRating` sono state introdotte in IFC4 e non esistono in IFC2x3 — un modello IFC2x3 non le avra mai valorizzate, non e un errore di completezza ma un limite di schema.

### Fase 4: Report

Genera un report strutturato:

```
REPORT VALIDAZIONE LOIN
=======================
Modello: [nome file]
Schema: IFC4
Fase: Progetto Definitivo
Data: [data]
Elementi totali: [n]
Elementi verificati: [n]

STRUTTURA SPAZIALE: [OK/ERRORI]
- [dettaglio errori se presenti]

NON CONFORMITA PER CATEGORIA:
┌──────────────┬────────┬──────────────────────────┬──────────┐
│ Categoria    │ Tipo   │ Descrizione              │ Severita │
├──────────────┼────────┼──────────────────────────┼──────────┤
│ IfcWall (45) │ LoI    │ Pset_WallCommon mancante │ CRITICA  │
│ IfcDoor (12) │ LoI    │ FireRating vuoto (8/12)  │ ALTA     │
│ IfcSpace (0) │ LoG    │ Nessun IfcSpace presente │ MEDIA    │
└──────────────┴────────┴──────────────────────────┴──────────┘

RIEPILOGO:
- Critiche: [n]
- Alte: [n]
- Medie: [n]
- Info: [n]

RACCOMANDAZIONI:
[lista azioni correttive ordinate per priorita]
```

## Script di riferimento

La verifica usa `ifcopenshell` (API verificata su 0.7.x/0.8.x). Esempio di check base:

```python
import ifcopenshell
import ifcopenshell.util.element
import ifcopenshell.util.classification

PLACEHOLDER_VALUES = ("", "TBD", "XXX", "000", "N/A", "N/D")


def validate_spatial_structure(ifc_file):
    """Verifica gerarchia spaziale obbligatoria (IfcProject > IfcSite > IfcBuilding > IfcBuildingStorey)."""
    issues = []
    if not ifc_file.by_type("IfcSite"):
        issues.append(("CRITICA", "Nessun IfcSite presente"))
    if not ifc_file.by_type("IfcBuilding"):
        issues.append(("CRITICA", "Nessun IfcBuilding presente"))
    storeys = ifc_file.by_type("IfcBuildingStorey")
    if not storeys:
        issues.append(("CRITICA", "Nessun IfcBuildingStorey presente"))
    for storey in storeys:
        if storey.Elevation is None:
            issues.append(("ALTA", f"Elevazione mancante: {storey.Name}"))
    return issues


def validate_pset(element, pset_name, required_props):
    """Verifica proprieta obbligatorie in un pset (occorrenza + tipo, via should_inherit)."""
    issues = []
    # should_inherit=True (default) unisce automaticamente le proprieta
    # ereditate dal tipo (IfcWallType, IfcDoorType, ...): non serve
    # richiamare ifcopenshell.util.element.get_type() a parte.
    psets = ifcopenshell.util.element.get_psets(element, psets_only=True)
    if pset_name not in psets:
        issues.append(("CRITICA", f"{pset_name} mancante su {element.Name} ({element.GlobalId})"))
        return issues
    pset = psets[pset_name]
    for prop in required_props:
        val = pset.get(prop)
        if val is None or (isinstance(val, str) and val.strip().upper() in PLACEHOLDER_VALUES):
            issues.append(("ALTA", f"{prop} vuoto/placeholder in {pset_name} su {element.Name}"))
    return issues


def validate_quantities(element, qto_name, required_qtos):
    """Verifica grandezze in un Qto_* (es. Qto_WallBaseQuantities)."""
    issues = []
    qtos = ifcopenshell.util.element.get_psets(element, qtos_only=True)
    if qto_name not in qtos:
        issues.append(("MEDIA", f"{qto_name} mancante su {element.Name}"))
        return issues
    for qty in required_qtos:
        if qtos[qto_name].get(qty) is None:
            issues.append(("MEDIA", f"{qty} mancante in {qto_name} su {element.Name}"))
    return issues


def validate_classification(element):
    """Verifica presenza di almeno un riferimento di classificazione (IfcClassificationReference)."""
    references = ifcopenshell.util.classification.get_references(element)
    if not references:
        return [("MEDIA", f"Nessuna classificazione assegnata a {element.Name}")]
    return []
```

Esempio d'uso su tutti i muri del modello:

```python
model = ifcopenshell.open("modello.ifc")

all_issues = []
for wall in model.by_type("IfcWall"):
    all_issues += validate_pset(
        wall, "Pset_WallCommon",
        ["IsExternal", "LoadBearing", "FireRating", "ThermalTransmittance"],
    )
    all_issues += validate_quantities(
        wall, "Qto_WallBaseQuantities", ["NetSideArea", "GrossVolume"],
    )
```

## Anti-pattern

| Errore | Correzione |
|--------|------------|
| Modificare il file IFC durante la validazione | MAI scrivere sull'IFC — solo lettura e report |
| Ignorare GlobalId duplicati | Segnalare sempre — indica copia errata di elementi |
| Validare solo i pset standard | Includere anche pset custom da matrice LOIN di progetto |
| Report con solo conteggio errori | Dettagliare per elemento con path spaziale completo |
| Usare criteri LOIN fissi | Calibrare su fase progettuale e matrice LOIN del CI |
| Inventare nomi di proprieta pset "plausibili" | Verificare sempre il nome esatto su buildingsmart.org o nei psd XML ufficiali — un nome sbagliato produce falsi negativi silenziosi |
| Cercare proprieta solo sull'occorrenza (`element.IsDefinedBy`) navigando manualmente le relazioni | Usare `ifcopenshell.util.element.get_psets()`, che gestisce automaticamente `IfcRelDefinesByProperties`, `IfcRelDefinesByType` e l'ereditarieta (`should_inherit=True`) |
| Trattare `get_psets()` senza argomenti come "solo proprieta" | Di default restituisce sia pset che quantity set: usare `psets_only=True` o `qtos_only=True` per isolarli |
| Confrontare pset di IFC2x3 e IFC4 come fossero identici | `Status`, `SecurityRating`, `DurabilityRating`, `HygrothermalRating` esistono solo da IFC4 in poi — non segnalarle come mancanti su modelli IFC2x3 |

## Formato matrice LOIN (input opzionale)

```json
{
  "fase": "PD",
  "categorie": {
    "IfcWall": {
      "log": "medio",
      "pset_richiesti": {
        "Pset_WallCommon": ["IsExternal", "FireRating", "ThermalTransmittance"],
        "VXt_Custom": ["Codice_WBS", "Fase_Cantiere"]
      }
    },
    "IfcDoor": {
      "log": "medio",
      "pset_richiesti": {
        "Pset_DoorCommon": ["FireRating", "IsExternal", "AcousticRating"]
      }
    },
    "IfcSlab": {
      "log": "medio",
      "pset_richiesti": {
        "Pset_SlabCommon": ["LoadBearing", "FireRating", "ThermalTransmittance"],
        "Qto_SlabBaseQuantities": ["NetArea", "GrossVolume"]
      }
    },
    "IfcSpace": {
      "log": "basso",
      "pset_richiesti": {
        "Pset_SpaceCommon": ["GrossPlannedArea", "HandicapAccessible"]
      }
    }
  }
}
```

## Limiti

- La verifica LoG e approssimativa (basata su tipo di rappresentazione, non su misure geometriche precise)
- Pset custom richiedono matrice LOIN esplicita — non sono inferibili
- Performance: modelli >500MB possono richiedere tempo significativo
- Non verifica coerenza tra modelli federati (richiede clash detection)
