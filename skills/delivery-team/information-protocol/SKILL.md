# Information Protocol

Definizione e controllo del protocollo informativo ISO 19650.

## Scope

- Definizione protocollo informativo per progetto
- Integrazione nei contratti e negli appointment
- Verifica coerenza tra livelli di servizio e requisiti informativi
- Aggiornamento del protocollo durante il ciclo di vita del progetto

## Normativa

- **ISO 19650-1/2** — concetto di "information protocol": documento contrattuale (schedule) che formalizza gli obblighi di gestione informativa richiamati dal contratto/appointment
- **UNI 11337-5:2017** — annesso nazionale italiano a ISO 19650: definisce ruoli, requisiti e flussi informativi, ma **non** definisce un documento a se stante chiamato "protocollo informativo" nel senso legale del termine UK. L'equivalente funzionale italiano e distribuito tra CI, contratto d'appalto e pGI (vedi chiarimento sotto)
- **Allegato I.9 (D.Lgs. 36/2023)** — requisiti contrattuali informativi richiamati nel capitolato/contratto

## Chiarimento terminologico importante

Il termine "information protocol" di ISO 19650 nasce nel contesto britannico come **schedule contrattuale a se stante**, allegato al contratto/appointment, che rende legalmente vincolanti i processi di gestione informativa. Il modello di riferimento e il documento pubblicato dal UK BIM Framework ("Information Protocol to support BS EN ISO 19650-2"), che contiene tipicamente:

- **Information Particulars**: tabella di apertura che raccoglie in un unico punto i dati di progetto — appointor/appointee, riferimenti a EIR e BEP, livelli di fabbisogno informativo (LOIN), parti chiave e processi di gestione informativa. E il punto di raccordo tra il protocollo e gli altri documenti del progetto
- **Obblighi delle parti** (documentazione, registro rischi, TIDP) richiamati dal contratto
- **Requisiti per il Common Data Environment** (CDE): come deve essere predisposto e supportato
- **Governance informativa**: gestione, uso, trasferimento, trattamento dati personali (GDPR), licenze sui contenuti prodotti

**In Italia** non esiste un documento normato con questo stesso nome e questa stessa funzione legale autonoma: il D.Lgs. 36/2023 e la UNI 11337 raggiungono un effetto analogo distribuendo gli stessi contenuti tra il **Capitolato Informativo (CI)** (requisiti), il **contratto d'appalto** (clausole vincolanti, richiami normativi) e il **pGI** (procedure operative). Quando questa skill genera un "documento protocollo", va inteso come una sintesi operativa di queste regole utile al progetto — non come un atto giuridico autonomo equivalente all'Information Protocol UK, a meno che il contratto specifico non lo preveda esplicitamente come schedule separato.

## Catena documentale (Italia vs ISO 19650)

| Fase | Italia (UNI 11337 / D.Lgs. 36/2023) | ISO 19650-2 |
|---|---|---|
| Requisiti del committente | CI (Capitolato Informativo) | EIR (Exchange Information Requirements) |
| Risposta di gara | oGI (Offerta di Gestione Informativa) | Pre-appointment BEP |
| Piano operativo post-affidamento | pGI (Piano di Gestione Informativa) | Post-appointment BEP |
| Regole vincolanti di processo/CDE | Contratto + CI + pGI (nessun documento unico dedicato) | Information Protocol (schedule contrattuale) |

Non usare "protocollo informativo" come sinonimo di CI o di pGI: sono documenti distinti con scopo diverso (il CI definisce i requisiti, il pGI il piano operativo, il "protocollo" — dove previsto — rende vincolanti le regole di processo).

## Workflow

1. Analizza CI/EIR e contratto, individuando dove le regole di processo sono gia vincolate contrattualmente e dove mancano
2. Definisci protocollo con:
   - Regole di nomenclatura file e modelli
   - Formati richiesti e versioni
   - Processo di revisione e approvazione
   - Regole di stato container (WIP/Shared/Published/Archived)
   - Frequenza di coordinamento e meeting informativi
   - Requisiti minimi per il CDE (accessi, backup, tracciabilita delle versioni)
   - Trattamento dati personali e licenze sui contenuti prodotti, se rilevanti per il progetto
   - Gestione delle modifiche al protocollo (chi puo modificarlo, con quale approvazione)
3. Genera documento protocollo strutturato, con una tabella "Information Particulars" iniziale (parti, riferimenti a CI/EIR e BEP/pGI, LOIN, milestone chiave) analoga a quella del modello UK
4. Verifica allineamento con BEP e pGI: nessuna regola del protocollo deve contraddire quanto gia dichiarato nel pGI approvato

## Anti-pattern

| Errore | Correzione |
|--------|------------|
| Usare "protocollo informativo" come sinonimo di CI o pGI | Sono documenti distinti: il CI definisce i requisiti, il pGI il piano operativo, il protocollo le regole di processo vincolanti |
| Presentare il protocollo come atto giuridico autonomo senza verificarne il richiamo contrattuale | In Italia va sempre verificato che il contratto lo richiami esplicitamente, altrimenti resta un documento tecnico interno |
| Regole di stato container generiche senza legame col CDE reale del progetto | Calibrare WIP/Shared/Published/Archived sulla configurazione CDE effettivamente adottata |
| Protocollo scritto una sola volta e mai aggiornato | Prevedere un meccanismo esplicito di gestione delle modifiche, con approvazione e tracciamento versioni |
| Nessun riferimento a LOIN o milestone nella tabella iniziale | Includere sempre un blocco "Information Particulars" con i riferimenti chiave, per evitare ambiguita su quali documenti prevalgono |
