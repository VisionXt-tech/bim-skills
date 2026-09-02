# Materials & Supply Chain Traceability

Tracciabilita materiali nel ciclo di vita BIM.

## Scope

- Gestione tracciabilita materiali tramite codici (QR/RFID) collegati a oggetti BIM
- Verifica sostenibilita e economia circolare (contenuto di riciclato/recuperato/sottoprodotto)
- Supporto a documentazione CAM (Criteri Ambientali Minimi) — contenuto riciclato, tracciabilita di filiera, End of Waste
- Collegamento schede tecniche materiali (DoP, EPD, certificazioni) a elementi IFC
- Verifica presenza di Dichiarazione di Prestazione (DoP) e marcatura CE per prodotti soggetti a norma armonizzata

## NON fa

- Non genera codici QR/RFID fisici
- Non certifica conformita ambientale — verifica la presenza documentale, non la validita tecnica della certificazione
- Non gestisce logistica di cantiere
- Non sostituisce l'organismo di valutazione della conformita nella verifica di autenticita dei documenti

## Normativa

- **D.M. 24 novembre 2025 (MASE)** — nuovi Criteri Ambientali Minimi per l'edilizia, pubblicato in G.U. n. 281 del 3/12/2025, in vigore dal 2 febbraio 2026. Sostituisce integralmente il **D.M. 23 giugno 2022, n. 256** (a sua volta modificato dal decreto correttivo del 5 agosto 2024). Regime transitorio: il DM 256/2022 puo restare applicabile alle procedure con PFTE validato prima dell'entrata in vigore del nuovo decreto, secondo le tempistiche indicate nel decreto stesso — verificare caso per caso quale versione si applica alla procedura in corso.
- **Reg. (UE) 2024/3110 (CPR)** — nuovo Regolamento Prodotti da Costruzione, in vigore dal 7/1/2025 e pienamente applicabile dall'8/1/2026 (con alcune disposizioni a scadenze differenziate); abroga il **Reg. (UE) 305/2011**. Introduce, tra l'altro, il passaporto digitale di prodotto (Digital Product Passport) e requisiti di sostenibilita rafforzati rispetto al 305/2011.
- **ISO 19650** (parti 1-2) — Asset/project information management, gestione del ciclo di vita informativo
- Nota normativa: la transizione 256/2022 → DM 24/11/2025 e 305/2011 → 2024/3110 e recente — verificare sempre l'aggiornamento normativo prima di applicare soglie o percentuali specifiche, che qui non vengono riportate per evitare riferimenti obsoleti

## Prerequisiti

- Modello IFC con pset materiali popolato (IfcMaterial associato agli elementi, o pset custom di tracciabilita)
- Set documentale disponibile per confronto: DoP, schede tecniche, certificazioni di contenuto riciclato, EPD
- Matrice CAM di progetto, se il CI ha definito requisiti specifici oltre il baseline normativo

## Workflow

### Fase 1: Acquisizione

1. Acquisisci la lista materiali da modello IFC (pset materiali, IfcMaterial associato agli elementi)
2. Chiedi il set documentale disponibile per ciascun materiale (DoP, scheda tecnica, EPD, certificato di contenuto riciclato)
3. Individua quale decreto CAM si applica alla procedura (nuovo DM 24/11/2025 o regime transitorio DM 256/2022) prima di valutare la conformita

### Fase 2: Verifica documentale

1. Verifica che ogni materiale soggetto a marcatura CE abbia una Dichiarazione di Prestazione (DoP) associata (Reg. UE 2024/3110, gia 305/2011)
2. Verifica presenza di scheda tecnica e indicazione di provenienza/produttore
3. Per prodotti con dichiarazione di contenuto riciclato/recuperato/sottoprodotto: verifica che la certificazione sia rilasciata da un organismo di valutazione della conformita accreditato, non un'autodichiarazione — salvo i casi ammessi dalla disciplina End of Waste, esplicitamente documentati

### Fase 3: Conformita CAM

1. Controlla la conformita ai criteri CAM applicabili (contenuto di riciclato, emissioni, provenienza, gestione dei rifiuti di cantiere)
2. Verifica la presenza di EPD (Environmental Product Declaration) per i materiali indicati come tali dal CI
3. Segnala i materiali privi di documentazione minima come non conformi, non come "da approfondire": la CAM e cogente negli appalti pubblici

### Fase 4: Report

Genera report tracciabilita con stato per materiale.

## Script di riferimento

```python
import ifcopenshell
import ifcopenshell.util.element

def extract_materials(ifc_file):
    """Extract materials associated with elements and traceability pset data, if present.

    Note: there is no standardized IFC pset for DoP/EPD/recycled-content traceability.
    Property names below assume a project-defined custom pset agreed in the CI/EIR.
    """
    data = []
    for element in ifc_file.by_type("IfcElement"):
        materials = ifcopenshell.util.element.get_material(element)
        psets = ifcopenshell.util.element.get_psets(element)
        traceability = psets.get("Pset_Traceability", {})
        data.append({
            "global_id": element.GlobalId,
            "ifc_class": element.is_a(),
            "materials": materials,
            "dop_reference": traceability.get("DoP_Reference"),
            "recycled_content_pct": traceability.get("Recycled_Content_Percent"),
            "epd_reference": traceability.get("EPD_Reference"),
        })
    return data

def flag_missing_documentation(materials_data):
    """Elements with an associated material but no DoP reference on record."""
    return [m for m in materials_data if m["materials"] and not m["dop_reference"]]
```

## Anti-pattern

| Errore | Correzione |
|--------|------------|
| Trattare la DoP come opzionale per materiali soggetti a norma armonizzata | La DoP e obbligatoria per prodotti coperti da norma armonizzata (Reg. UE 2024/3110, ex 305/2011): segnalarne sempre l'assenza come non conformita |
| Accettare autodichiarazioni di contenuto riciclato senza certificazione | Richiedere certificazione di organismo accreditato, salvo i casi di End of Waste esplicitamente documentati |
| Applicare i criteri del DM 256/2022 a procedure bandite dopo il 2/2/2026 | Verificare sempre quale decreto CAM si applica alla procedura in corso (nuovo DM 24/11/2025 o regime transitorio) |
| Usare pset di tracciabilita non concordati con il CI | I pset materiali/tracciabilita non sono standardizzati in IFC base: vanno definiti nel CI/EIR di progetto prima della modellazione |
| Confondere marcatura CE con conformita CAM | Sono requisiti distinti: la marcatura CE riguarda sicurezza/prestazione del prodotto (CPR), la CAM riguarda la sostenibilita ambientale negli appalti pubblici |

## Output

Report tracciabilita (CSV/JSON/tabellare): materiale, elemento/i associati, DoP presente (si/no + riferimento), scheda tecnica presente, contenuto riciclato dichiarato (%), certificazione (ente, validita), conformita CAM (si/no/da verificare), decreto CAM di riferimento applicato.

## Limiti

- Non esistono pset IFC standardizzati per tracciabilita/DoP/EPD: la skill richiede pset custom definiti nel CI/EIR, altrimenti il controllo si riduce alla sola presenza di IfcMaterial
- Non verifica l'autenticita dei documenti (DoP, certificati) — solo la loro presenza/riferimento nel modello
- Il regime CAM e in transizione (DM 256/2022 → DM 24/11/2025): verificare sempre quale decreto si applica prima di dichiarare una non conformita
- Il Reg. (UE) 2024/3110 e di applicazione progressiva, con disposizioni a scadenze differenziate: verificare l'aggiornamento normativo per gli articoli non ancora pienamente applicabili alla data del progetto
