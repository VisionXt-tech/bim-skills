# 4D Construction Sequencing

Collegamento modelli IFC con cronoprogrammi lavori per simulazioni 4D (4D BIM / 4D simulation).

## Scope

- Collegamento elementi IFC con attivita WBS (Work Breakdown Structure) / cronoprogramma
- Costruzione e verifica del parametro di collegamento (es. codice WBS) sugli elementi IFC
- Verifica coerenza tra fasi cantiere e milestone informative
- Supporto alla costruzione di viste 4D (sequenza elemento-attivita-tempo, non il video)
- Controllo SAL informativi (stato di avanzamento del modello rispetto al cronoprogramma)
- Identificazione di elementi non collegati a nessuna attivita e di attivita senza elementi associati

## NON fa

- Non genera cronoprogrammi (li collega al modello, non li crea da zero)
- Non esegue simulazioni 4D direttamente (richiede software dedicato: Navisworks, Synchro, Bexel, iTWO, etc.)
- Non gestisce contabilita lavori o SAL economici (vedi skill `quantities-cost-linking`)
- Non definisce la logica di sequenza (predecessori/successori/vincoli) — quella resta del project scheduler

## Normativa

- **D.Lgs. 36/2023** — Programmazione lavori
- **ISO 19650-2** — Information delivery milestones e pianificazione della consegna informativa

## Terminologia di riferimento

- **4D BIM**: collegamento tra componenti del modello 3D e informazioni temporali/di programma — la "quarta dimensione" e il tempo. E il dato, non la sua rappresentazione.
- **4D simulation**: la visualizzazione (playback) della sequenza costruttiva nel tempo, generata a partire dal collegamento 4D BIM in un software dedicato.
- **WBS (Work Breakdown Structure)**: struttura gerarchica che scompone il progetto in attivita elementari; e la chiave di collegamento tra modello e cronoprogramma — ogni oggetto deve essere riconducibile a una o piu attivita WBS.
- **PBS (Product Breakdown Structure)**: struttura gerarchica del prodotto/opera, usata in alcuni framework per integrare la scomposizione fisica con la WBS.

## Prerequisiti

- Python 3.8+ con `ifcopenshell` installato
- Modello IFC con parametro di collegamento WBS previsto in fase di modellazione (es. pset custom con proprieta tipo `Codice_WBS`) — se assente, va concordato con il team di modellazione prima di procedere
- Cronoprogramma esportato in formato tabellare (CSV da MS Project, Primavera P6, o altro) con almeno: ID attivita, nome, data inizio, data fine
- Mapping preliminare (anche parziale) tra categorie IFC e macro-fasi di cantiere, se disponibile dal CI

## Workflow

### Fase 1: Acquisizione e normalizzazione dati

1. Acquisisci modello IFC e cronoprogramma (MS Project, Primavera P6, CSV)
2. Verifica che il cronoprogramma abbia un identificativo univoco per attivita (Activity ID)
3. Verifica se il modello ha gia un parametro di collegamento (es. `Codice_WBS`) popolato sugli elementi

### Fase 2: Mapping elemento-attivita

1. Se il parametro di collegamento esiste: estrai il valore per ogni elemento e verifica corrispondenza con gli Activity ID del cronoprogramma
2. Se non esiste: proponi un mapping per categoria IFC (es. tutte le IfcWall del piano terra ↔ attivita "Tamponamenti PT") da validare col pianificatore
3. Costruisci la tabella di mapping: GlobalId, categoria IFC, Codice_WBS, Activity ID, nome attivita

### Fase 3: Verifica di coerenza

1. Ogni elemento ha un'attivita associata (nessun elemento orfano)
2. Ogni attivita ha almeno un elemento associato — puo essere legittimo il contrario per attivita non modellabili (es. collaudi, forniture)
3. Identifica conflitti temporali: elementi la cui fase costruttiva risulta incompatibile con la sequenza dichiarata (es. finitura con data di inizio antecedente alla struttura portante che la contiene)
4. Verifica coerenza tra milestone informative (ISO 19650-2) e milestone di cantiere (es. la consegna del modello As-Built deve essere coerente con la data di fine lavori)

### Fase 4: Report

Genera report mapping e anomalie: elementi non mappati, attivita senza elementi, conflitti temporali, riepilogo per fase.

## Script di riferimento

```python
import ifcopenshell
import ifcopenshell.util.element

def get_wbs_mapping(ifc_file, pset_name="Pset_Costruzione", prop_name="Codice_WBS"):
    """Extract element-to-WBS linkage from a project-defined custom pset."""
    mapping = []
    for element in ifc_file.by_type("IfcElement"):
        psets = ifcopenshell.util.element.get_psets(element)
        wbs_code = psets.get(pset_name, {}).get(prop_name)
        mapping.append({
            "global_id": element.GlobalId,
            "ifc_class": element.is_a(),
            "name": element.Name,
            "wbs_code": wbs_code,
        })
    return mapping

def find_orphan_elements(mapping):
    """Elements with no WBS code associated."""
    return [m for m in mapping if not m["wbs_code"]]

def find_empty_activities(mapping, activity_ids):
    """Schedule activities with no linked elements in the model."""
    linked_ids = {m["wbs_code"] for m in mapping if m["wbs_code"]}
    return [a for a in activity_ids if a not in linked_ids]
```

## Anti-pattern

| Errore | Correzione |
|--------|------------|
| Collegare elementi ad attivita solo per corrispondenza testuale libera del nome | Usare un codice WBS univoco e stabile come chiave di collegamento, non il nome descrittivo |
| Ignorare elementi orfani perche "pochi" | Segnalarli sempre — indicano modellazione incompleta o attivita mancante nel cronoprogramma |
| Correggere autonomamente le incoerenze temporali rilevate | Segnalarle soltanto: la decisione sulla sequenza spetta al pianificatore |
| Mappare per intera categoria IFC senza distinguere per fase/zona | Raffinare il mapping per piano/zona quando la stessa categoria appartiene a fasi diverse (es. muri PT vs muri P1) |
| Confondere 4D BIM (il collegamento dati) con 4D simulation (il playback) | Distinguere le due fasi nel report: la skill produce il collegamento tabellare, non il video |

## Output

Report mapping in formato tabellare (CSV/JSON): GlobalId, categoria IFC, Codice_WBS, Activity ID, nome attivita, esito verifica (OK/orfano/conflitto). Riepilogo con conteggio anomalie per tipologia e per fase.

## Limiti

- Non gestisce la logica di sequenza (predecessori/successori/vincoli): resta nel software di scheduling
- La qualita del mapping dipende dalla presenza di un parametro di collegamento esplicito nel modello — senza di esso il mapping proposto e solo un suggerimento da validare
- Non produce simulazioni video 4D: l'output e tabellare, da importare in Navisworks/Synchro/Bexel per il playback
