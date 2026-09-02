# Maintenance Strategy & CMMS Integration

Integrazione AIM con sistemi CMMS/CAFM per manutenzione programmata.

## Scope

- Definizione piani manutentivi basati su AIM
- Integrazione dati AIM con sistemi CMMS/CAFM
- Creazione flussi di ticket manutentivi
- Storicizzazione interventi e analisi trend

## NON fa

- Non configura fisicamente il CMMS
- Non esegue ordini di lavoro
- Non gestisce contratti di manutenzione

## Normativa

- **UNI EN ISO 19650-3:2021** (ISO 19650-3:2020) — Fase gestionale dei cespiti immobili. Il piano manutentivo e uno dei processi che consumano l'AIM per rispondere agli AIR del committente
- **UNI 11257:2007** — "Manutenzione dei patrimoni immobiliari — Criteri per la stesura del piano e del programma di manutenzione dei beni edilizi — Linee guida". Definisce la struttura del piano di manutenzione (manuale d'uso, manuale di manutenzione, programma di manutenzione) e i criteri per la sua articolazione su edifici, subsistemi e componenti
- **UNI 10604:1997** — "Manutenzione — Criteri di progettazione, gestione e controllo dei servizi di manutenzione di immobili". Definisce le caratteristiche essenziali di un sistema informativo per la gestione della manutenzione immobiliare, propedeutico all'integrazione con un CMMS
- **COBie** — formato di scambio piu diffuso per il trasferimento strutturato di dati asset dal BIM al CMMS/CAFM (vedi skill `aim-construction` per la struttura completa dei 18 fogli)

## Integrazione dati AIM → CMMS/CAFM

Il canale di scambio piu comune tra AIM e CMMS/CAFM e un file COBie (foglio elettronico o IFC con pset equivalenti), importato una tantum al passaggio in esercizio e poi sincronizzato periodicamente. I fogli COBie piu rilevanti per il CMMS:

| Foglio COBie | Uso nel CMMS |
|---|---|
| Component | Anagrafica cespite (asset register): identificativo, ubicazione, matricola, data messa in servizio |
| Type | Scheda tecnica di modello: produttore, garanzia, vita utile attesa — alimenta gli allarmi di scadenza garanzia |
| System | Raggruppamento per criticita impiantistica (es. tutti i componenti del sistema antincendio) |
| Job | Template di intervento programmato: frequenza, durata stimata, competenza richiesta — diventa il piano di manutenzione preventiva nel CMMS |
| Spare | Elenco ricambi collegati al Type — alimenta la gestione magazzino del CMMS |
| Resource | Risorse (manodopera, attrezzature) necessarie per eseguire un Job |
| Document | Collegamento a manuali d'uso e manutenzione, certificati, garanzie (UNI 11257) |
| Attribute | Proprieta manutentive non standard (es. classe di criticita, ore di funzionamento) |

Formati alternativi quando il CMMS non supporta COBie nativamente: pset IFC dedicati (es. `Pset_Maintenance*` custom), CSV con mapping manuale colonna→colonna, o connettori proprietari (es. plugin BIM-CMMS specifici del vendor) — in questi casi documentare sempre la matrice di mapping campo per campo per evitare perdita di tracciabilita.

## Esempio mapping asset IFC → record CMMS

| Sorgente | Campo | Destinazione CMMS |
|---|---|---|
| `IfcPump` (Tag) + COBie.Component.Name | Identificativo cespite | Asset ID |
| COBie.Component.Space | Ubicazione | Location / Building-Floor-Room |
| COBie.Type.Name + Manufacturer + ModelNumber | Scheda tecnica | Equipment Type |
| `Pset_Warranty`.WarrantyStartDate + COBie.Type.WarrantyDurationParts | Scadenza garanzia | Warranty Expiry Date |
| COBie.Job (frequenza, task) | Piano manutentivo | Preventive Maintenance Schedule |
| COBie.Spare.Name | Ricambio associato | Spare Parts Catalog |

## Workflow

1. Acquisisci AIM e lista asset con dati manutentivi (COBie o pset equivalenti)
2. Per ogni asset: definisci piano manutenzione secondo UNI 11257 (frequenza, tipo preventivo/correttivo, competenza richiesta) e criteri di controllo secondo UNI 10604
3. Genera mapping asset IFC/COBie ↔ record CMMS, documentando la matrice campo per campo
4. Definisci flusso ticket: segnalazione → assegnazione → esecuzione → chiusura → feedback AIM (storicizzazione intervento nel modello per il ciclo successivo)

## Anti-pattern

| Errore | Correzione |
|--------|------------|
| Importare in CMMS solo COBie.Component senza COBie.Type | Si perdono garanzia, vita utile attesa e dati produttore: importare sempre Component + Type collegati |
| Confondere UNI 11257 (pianificazione manutenzione) con UNI 10604 (criteri di progettazione/gestione del servizio) | Sono complementari: UNI 11257 struttura il piano/programma, UNI 10604 definisce i requisiti del sistema informativo che lo gestisce — citarle entrambe, non come sinonimi |
| Sincronizzare AIM → CMMS solo all'handover iniziale | Il flusso deve essere bidirezionale e periodico: gli interventi eseguiti nel CMMS devono retroalimentare l'AIM (as-maintained), non solo l'import one-shot |
| Usare identificativi diversi tra modello BIM e CMMS per lo stesso asset | Mantenere lo stesso Tag/GlobalId come chiave primaria in tutta la catena BIM → COBie → CMMS, altrimenti il mapping si rompe ad ogni aggiornamento |
| Definire piani di manutenzione senza classificare la criticita dell'asset | UNI 11257 richiede di correlare frequenza/tipo di intervento al livello di criticita del bene, non un piano uniforme per tutti gli asset |
