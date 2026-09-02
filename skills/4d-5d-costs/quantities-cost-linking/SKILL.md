# 5D Quantities & Cost Linking

Estrazione quantitativi da IFC e collegamento con voci di computo metrico.

## Scope

- Estrazione quantitativi da modelli IFC (superfici, volumi, lunghezze, conteggi) tramite i quantity set (Qto_*) standard
- Associazione con voci di computo metrico e prezzari regionali
- Costruzione viste 5D per analisi costi
- Verifica coerenza quantitativi modello vs computo (scostamenti oltre soglia)
- Distinzione esplicita tra quantitativi certi (da Qto del modello) e stimati (da geometria, in assenza di Qto)

## NON fa

- Non genera computi metrici estimativi (supporta l'estimatore)
- Non certifica costi — il tecnico abilitato firma
- Non accede a prezzari online (richiede file prezzario fornito dall'utente)
- Non sostituisce il cost planner nella validazione del mapping voce-elemento

## Normativa

- **D.Lgs. 36/2023, Allegato I.7, art. 31** — Elenco prezzi unitari, computo metrico estimativo e quadro economico
- **D.Lgs. 36/2023, Allegato I.14** — Criteri di formazione e aggiornamento dei prezzari regionali
- **Prezzari regionali** — strumento ufficiale di riferimento per i costi negli appalti pubblici, redatti da Regioni/Province autonome
- **Prezzario DEI** (Tipografia del Genio Civile) — pubblicazione commerciale di uso diffuso, non un prezzario ufficiale di ente pubblico: va usato solo se richiamato dal CI/documenti di gara
- Nota: e in fase di istituzione un prezzario nazionale delle opere pubbliche (L. 199/2025, Osservatorio nazionale) — verificare aggiornamento normativo prima di assumerlo come riferimento primario rispetto ai prezzari regionali

## Metodologia 5D (riferimento)

- Il flusso 5D collega il quantity take-off automatico dal modello (BOQ, Bill of Quantities) alla voce di prezzo, mantenendo tracciabilita tra revisione del modello e revisione del computo.
- **RICS NRM (New Rules of Measurement)**: standard internazionale di misurazione in 3 volumi (NRM1 per la quantificazione a supporto di stime/cost planning in fase preliminare, NRM2 per la misurazione dettagliata a base di gara). Non e obbligatorio nel contesto italiano ma e un riferimento utile per i criteri di misurazione quando manca una prassi consolidata equivalente nel CI.

## Prerequisiti

- Python 3.8+ con `ifcopenshell` installato
- Modello IFC con i quantity set (Qto_*) popolati in fase di modellazione — se assenti, i quantitativi vanno ricalcolati da geometria e dichiarati come stime
- Prezzario in formato strutturato (CSV/Excel) con codice voce, descrizione, unita di misura, prezzo unitario
- Mapping preliminare categoria IFC → capitolo di prezzario, se disponibile dal CI

## Workflow

### Fase 1: Acquisizione dati

1. Acquisisci modello IFC e prezzario (CSV/Excel)
2. Verifica la presenza dei Qto (quantity set) nel modello per le categorie di interesse
3. Se assenti, segnala che i quantitativi risultanti saranno stime geometriche, non dati certificati dal modellatore

### Fase 2: Estrazione quantitativi

1. Estrai quantitativi per categoria IFC (IfcWall, IfcSlab, IfcColumn, IfcDoor, etc.) usando i pset `Qto_*` standard
2. Per elementi privi di Qto, calcola un quantitativo di fallback dalla geometria (bounding box) e marcalo esplicitamente come "stimato"

### Fase 3: Mapping e calcolo

1. Proponi mapping: categoria/tipo IFC ↔ voce prezzario (basato su tipo, materiale, spessore/classificazione)
2. Segnala per conferma del cost planner i mapping ambigui (piu voci compatibili con lo stesso elemento)
3. Calcola gli importi per voce: quantita × prezzo unitario

### Fase 4: Verifica e report

1. Verifica coerenza quantitativi modello vs. computo esistente (se fornito) — segnala scostamenti oltre soglia (es. superiori al 5%)
2. Genera la tabella 5D: elemento, quantita, unita di misura, prezzo unitario, importo, voce di riferimento

## Script quantitativi

```python
import ifcopenshell
import ifcopenshell.util.element

# Qto_WallBaseQuantities (IFC4): Length, Width, Height, GrossFootprintArea,
# NetFootprintArea, GrossSideArea, NetSideArea, GrossVolume, NetVolume, GrossWeight, NetWeight
def extract_wall_quantities(ifc_file):
    walls = ifc_file.by_type("IfcWall")
    data = []
    for wall in walls:
        qsets = ifcopenshell.util.element.get_psets(wall, qtos_only=True)
        qto = qsets.get("Qto_WallBaseQuantities", {})
        data.append({
            "id": wall.GlobalId,
            "name": wall.Name,
            "net_side_area": qto.get("NetSideArea", 0),
            "gross_side_area": qto.get("GrossSideArea", 0),
            "net_volume": qto.get("NetVolume", 0),
            "gross_volume": qto.get("GrossVolume", 0),
        })
    return data

# Qto_SlabBaseQuantities (IFC4): Width, Length, Depth, Perimeter,
# GrossArea, NetArea, GrossVolume, NetVolume, GrossWeight, NetWeight
def extract_slab_quantities(ifc_file):
    slabs = ifc_file.by_type("IfcSlab")
    data = []
    for slab in slabs:
        qsets = ifcopenshell.util.element.get_psets(slab, qtos_only=True)
        qto = qsets.get("Qto_SlabBaseQuantities", {})
        data.append({
            "id": slab.GlobalId,
            "name": slab.Name,
            "net_area": qto.get("NetArea", 0),
            "gross_area": qto.get("GrossArea", 0),
            "net_volume": qto.get("NetVolume", 0),
            "gross_volume": qto.get("GrossVolume", 0),
        })
    return data

def flag_missing_qto(quantities, key="net_volume"):
    """Elements with an unpopulated Qto value: recompute from geometry or ask the modeler."""
    return [q for q in quantities if not q.get(key)]
```

## Anti-pattern

| Errore | Correzione |
|--------|------------|
| Usare GrossVolume/GrossArea per il computo senza dichiararlo | Usare NetVolume/NetArea salvo diversa indicazione del CI, e dichiarare sempre quale valore si sta usando |
| Assumere che tutti gli elementi abbiano i Qto popolati | Verificare sempre la presenza del pset `Qto_*` per categoria; segnalare i mancanti invece di sostituirli silenziosamente con 0 |
| Mappare automaticamente un'unica voce di prezzario per intera categoria IFC | Distinguere per tipo/materiale/spessore: una IfcWall puo mappare a voci diverse (tamponamento, tramezzo, muro portante) |
| Sommare quantitativi provenienti da IFC2x3 e IFC4 senza verifica | Verificare lo schema IFC prima di aggregare — i nomi dei Qto possono differire tra versioni |
| Presentare la tabella 5D come computo metrico ufficiale firmato | E un documento di supporto: la firma e la responsabilita del computo restano del tecnico abilitato |

## Output

Tabella 5D (CSV/Excel/JSON): GlobalId, categoria IFC, quantita netta, quantita lorda, unita di misura, codice voce prezzario, prezzo unitario, importo, stato mapping (confermato/da validare/mancante).

## Limiti

- Quantitativi dipendono dalla qualita del modello (se mancano Qto, il calcolo e approssimativo e va dichiarato come tale)
- Mapping voce-elemento richiede validazione del cost planner, specialmente per voci compound (es. opere murarie complete)
- Prezzari regionali cambiano periodicamente (tipicamente annualmente) — verificare sempre la versione in vigore alla data di riferimento del computo
- E in corso l'istituzione di un prezzario nazionale delle opere pubbliche (L. 199/2025): verificare se e quando diventa il riferimento primario rispetto ai prezzari regionali
