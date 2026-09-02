# Normative Code Checking

Controlli parametrici di conformita normativa sui modelli BIM.

## Scope

- Verifica requisiti edilizi e strutturali su parametri modello
- Controlli NTC (Norme Tecniche per le Costruzioni)
- Verifica regolamenti edilizi locali (altezze, distanze, superfici)
- Controlli antincendio (REI, vie di fuga, compartimentazione)
- Report conformita con riferimenti normativi

## NON fa

- Non sostituisce il calcolo strutturale
- Non certifica la conformita — il tecnico abilitato firma
- Non esegue analisi FEM o simulazioni

## Normativa

- **D.M. 17/01/2018 (NTC 2018)** — Norme Tecniche per le Costruzioni. Testo unico organizzato in 12 capitoli (oggetto e campo di applicazione, sicurezza e prestazioni attese, azioni sulle costruzioni, costruzioni civili e industriali, ecc.); il Cap. 7 e dedicato specificamente alla progettazione per azioni sismiche. Non citare numeri di articolo/comma puntuali senza aver verificato la versione consolidata: il testo e organizzato per capitoli e paragrafi, non per articoli numerati come una legge ordinaria
- **Circolare 21/01/2019 n.7 C.S.LL.PP.** — Istruzioni applicative delle NTC 2018
- **D.M. 03/08/2015 ("Codice di Prevenzione Incendi")** — Approva la Regola Tecnica di Prevenzione Incendi, strutturata in 4 sezioni: **G** Generalita (definizioni, progettazione della sicurezza antincendio, profili di rischio), **S** Strategia antincendio (S.1 reazione al fuoco, S.2 resistenza al fuoco, S.3 compartimentazione, S.4 esodo, S.5 gestione della sicurezza, S.6 controllo fumi, S.7 rivelazione/allarme, S.8 controllo fumi e calore, S.9 operativita antincendio, S.10 sicurezza impianti), **V** Regole tecniche verticali (attivita a rischio specifico), **M** Metodi (fire safety engineering). Riferirsi alla sezione/sottosezione (es. "S.3 Compartimentazione"), non a un articolo puntuale se non espressamente verificato
- **Regolamenti edilizi locali** — variabili per comune (altezze minime, distanze, superfici illuminanti/aeranti, indici urbanistici)

## Prerequisiti

- Python 3.8+ con `ifcopenshell` installato
- Modello IFC con pset compilati (in particolare Pset_WallCommon, Pset_SlabCommon, Pset_SpaceCommon, Pset_DoorCommon — vedi skill `ifc-loin-validator` per l'elenco completo delle proprieta)
- Tabella dei limiti normativi applicabili, confermata dall'utente o dal tecnico abilitato (comune, categoria d'uso, classe di rischio incendio)

## Workflow

1. Acquisisci modello IFC e normativa applicabile (confermata dall'utente — non assumere valori limite)
2. Estrai parametri rilevanti dal modello via ifcopenshell:
   - Altezze: `Qto_SpaceBaseQuantities`/`IfcBuildingStorey.Elevation`, altezza netta vani
   - Superfici: `Pset_SpaceCommon.GrossPlannedArea`/`NetPlannedArea`, `Qto_SlabBaseQuantities.NetArea`
   - Resistenza al fuoco (REI/EI): `Pset_WallCommon.FireRating`, `Pset_SlabCommon.FireRating`, `Pset_DoorCommon.FireRating`
   - Compartimentazione: `Pset_WallCommon.Compartmentation`, `Pset_SlabCommon.Compartmentation`
   - Vie di fuga/accessibilita: `Pset_DoorCommon.FireExit`, `Pset_SpaceCommon.HandicapAccessible`
3. Confronta con i limiti normativi forniti (non inventare soglie)
4. Genera report: conforme / non conforme per ogni check, con riferimento normativo (sezione/capitolo, non articolo inventato)

### Esempio di estrazione parametri (ifcopenshell)

```python
import ifcopenshell
import ifcopenshell.util.element

model = ifcopenshell.open("modello.ifc")


def check_fire_rating(model, element_type, pset_name, required_rating):
    """Confronta il FireRating dichiarato con il valore minimo richiesto (es. 'REI 120')."""
    results = []
    for element in model.by_type(element_type):
        psets = ifcopenshell.util.element.get_psets(element, psets_only=True)
        pset = psets.get(pset_name, {})
        rating = pset.get("FireRating")
        conforme = rating is not None and rating == required_rating
        results.append({
            "element": element.Name,
            "guid": element.GlobalId,
            "rating_dichiarato": rating,
            "rating_richiesto": required_rating,
            "conforme": conforme,
        })
    return results


def check_space_area(model, min_area_sqm):
    """Confronta GrossPlannedArea di ogni IfcSpace con una superficie minima regolamentare."""
    results = []
    for space in model.by_type("IfcSpace"):
        psets = ifcopenshell.util.element.get_psets(space, psets_only=True)
        area = psets.get("Pset_SpaceCommon", {}).get("GrossPlannedArea")
        results.append({
            "space": space.Name,
            "area": area,
            "conforme": area is not None and area >= min_area_sqm,
        })
    return results
```

## Anti-pattern

| Errore | Correzione |
|--------|------------|
| Citare articolo/comma di NTC 2018 senza verifica puntuale | Riferirsi al capitolo/paragrafo del testo, o omettere il riferimento puntuale se non verificabile |
| Inventare soglie normative (altezze, superfici, REI) | Chiedere sempre conferma dei limiti applicabili all'utente o al tecnico abilitato — variano per comune, destinazione d'uso, classe di rischio |
| Dichiarare conformita basandosi solo sul valore del pset senza controllare che non sia vuoto/placeholder | Trattare `None` o valori vuoti come "non verificabile", non come "conforme" |
| Confrontare REI dichiarato in formati diversi (es. "REI 120" vs "120" vs "EI120") senza normalizzare | Normalizzare il formato prima del confronto, segnalando i formati non riconosciuti come anomalia |
| Sostituirsi al tecnico abilitato dichiarando "conforme" in modo definitivo | Il report e un supporto alla verifica, non una certificazione — deve sempre riportare che la firma finale spetta al tecnico abilitato |

## Limiti

- I limiti normativi devono essere forniti o confermati dall'utente (variano per comune)
- La verifica e parametrica, non geometrica (non misura distanze 3D, non verifica percorsi di esodo reali)
- Dipende dalla qualita di compilazione dei pset nel modello IFC — se i pset sono vuoti la verifica non e eseguibile (vedi skill `ifc-loin-validator` per l'audit preliminare)
- Aggiornamenti normativi richiedono revisione dei criteri
