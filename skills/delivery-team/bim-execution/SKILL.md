# BIM Execution Plan

Supporto alla redazione e aggiornamento del BEP (BIM Execution Plan) per il delivery team.

## Scope

- Redazione pre-appointment BEP (per gara/oGI)
- Sviluppo post-appointment BEP (operativo, per pGI)
- Piano di mobilizzazione risorse informative
- Matrice responsabilita e rischi informativi

## NON fa

- Non gestisce la gara o l'offerta economica
- Non certifica competenze del team
- Non configura fisicamente il CDE

## Normativa

- **ISO 19650-2** — clausola 5.3 (pre-appointment BEP, redatto dal concorrente in risposta alla gara), clausola 5.4/5.6 (post-appointment BEP, sviluppato dal lead appointed party con l'intero delivery team dopo l'affidamento)
- **UNI 11337-5:2017** — ruoli, requisiti e flussi per la produzione, gestione e trasmissione delle informazioni nei processi digitalizzati; definisce la catena CI → oGI → pGI, corrispondente in UNI/PdR alla coppia pre/post-appointment BEP di ISO 19650-2
- **UNI 11337-6:2017** — linee guida per la redazione del Capitolato Informativo (CI), documento a monte a cui il BEP risponde
- **UNI/PdR 78:2020** — requisiti di conoscenza, abilita e competenza delle figure professionali BIM, utile per la sezione "team e competenze" del BEP
- **PAS 1192-2** — standard storico britannico predecessore di ISO 19650-2, **ritirato da BSI nel 2019** e sostituito integralmente da ISO 19650-1/2. Citarlo solo come riferimento storico, mai come base normativa attuale

### Chiarimento terminologico: BEP (UK/ISO) vs oGI/pGI (Italia)

- **oGI (Offerta di Gestione Informativa)** e l'equivalente italiano del **pre-appointment BEP**: documento prodotto dal concorrente in fase di gara, in risposta al CI, con contenuti generici/proposti perche il team definitivo non e ancora consolidato
- **pGI (Piano di Gestione Informativa)** e l'equivalente del **post-appointment BEP**: versione operativa e dettagliata, redatta dall'affidatario dopo l'aggiudicazione, che approfondisce l'oGI con responsabilita nominali, MIDP/TIDP definitivi e procedure vincolanti
- Un **Task Team** (ISO 19650-2) NON coincide con il singolo professionista: e il gruppo (interno o esterno al delivery team) responsabile della produzione di un insieme di informazioni per una disciplina — puo essere composto da piu persone con ruoli diversi (autore, verificatore, approvatore). Non confondere "responsabile del task team" con "unico redattore"

## Struttura del BEP

ISO 19650-2 (Guidance Part E) organizza i contenuti del BEP in tre macro-aree, valide sia per il pre- sia per il post-appointment BEP, con livello di dettaglio crescente:

1. **Commerciale**: composizione del delivery team, scopi informativi (purposes), elenco dei deliverable informativi attesi, relazione con le condizioni contrattuali/di appalto
2. **Gestionale**: processi di gestione (QA informativa, sicurezza e privacy delle informazioni, gestione del CDE, ruoli e responsabilita, procedure di revisione/approvazione)
3. **Tecnico**: standard, metodi e procedure (nomenclatura, formati di scambio, sistema di coordinate, strategia di federazione), livelli di fabbisogno informativo (LOIN)

## Workflow

### Pre-appointment BEP (per oGI)

1. Analizza requisiti del CI/EIR (competenze richieste, standard, milestone, formati)
2. Genera BEP con:
   - **Approccio proposto** per soddisfare il CI, con riferimento esplicito ai requisiti numerati del capitolato
   - **Team e capacita**: composizione prospettica del delivery team, competenze/certificazioni (UNI/PdR 78), disponibilita di risorse (capacity, non solo capability)
   - **Strumenti e piattaforme**: software, hardware, ambiente CDE proposto
   - **Matrice responsabilita di alto livello (high-level responsibility matrix)**: assegna in modo preliminare, per ciascun task team prospettico, quali deliverable produce — senza ancora nomi di persone
   - **Strategia di federazione e struttura di scomposizione informativa**: regole di aggregazione/segregazione dei container informativi
   - **Approccio al coordinamento**: processo di clash detection e gestione interferenze, frequenza
   - **Estratto preliminare del MIDP**: bozza dei principali deliverable e milestone
   - **Registro dei rischi informativi**: rischi legati a capacita/capability del team, redatto a valle del pre-BEP
   - **Piano di mobilizzazione preliminare**: risorse, formazione, setup ambiente da attivare in caso di aggiudicazione

### Post-appointment BEP (per pGI)

1. Parti dal pre-BEP approvato e sviluppalo con l'intero delivery team (non solo il lead appointed party — il post-BEP deve essere concordato e rappresentativo di tutti gli appointed party)
2. Dettaglia:
   - **Organigramma BIM nominale**: nomi, contatti, ruoli operativi (information manager, task team manager, autori)
   - **Matrice responsabilita dettagliata (detailed responsibility matrix)**: per ogni deliverable/container, assegna RACI a livello di task team — evoluzione della matrice di alto livello del pre-BEP (vedi esempio sotto)
   - **Procedure operative per ogni disciplina**: standard di modellazione, naming, LOIN per fase
   - **MIDP/TIDP dettagliati e vincolanti** (vedi skill `information-delivery-planning`)
   - **Procedure di coordinamento e clash management**: frequenza meeting, strumenti (BCF), workflow di chiusura issue
   - **Piano di mobilizzazione confermato**: risorse effettivamente allocate, timeline legata a milestone contrattuali
   - **KPI e metriche di qualita**: indicatori di conformita LOIN, puntualita consegne, tasso di non conformita

### Esempio di matrice responsabilita (estratto)

| Deliverable/Container | Task Team | Ruolo | Responsabile (nome) | R | A | C | I |
|---|---|---|---|---|---|---|---|
| Modello architettonico LOD D | Team Architettura | Autore | [Nome Cognome] | X | | | |
| Modello architettonico LOD D | BIM Coordinator | Verifica/coordinamento | [Nome Cognome] | | X | | |
| Modello strutturale LOD D | Team Strutture | Autore | [Nome Cognome] | X | | | |
| Report clash coordinamento | BIM Manager | Approvazione | [Nome Cognome] | | X | X | |
| Computo metrico | Team 5D | Autore | [Nome Cognome] | X | | | X |

R = Responsible (esegue), A = Accountable (approva/risponde), C = Consulted (consultato), I = Informed (informato). Nel pre-BEP questa tabella ha solo le colonne Deliverable/Task Team; nel post-BEP si aggiungono nome, RACI e date (che confluiscono nel MIDP).

## Anti-pattern

| Errore | Correzione |
|--------|------------|
| BEP generico senza riferimento al CI | SEMPRE calibrare su requisiti specifici del CI, citando il numero di paragrafo del requisito soddisfatto |
| Competenze dichiarate senza evidenza | Suggerire di allegare certificazioni UNI/PdR 78 o CV nominali |
| Piano mobilizzazione senza timeline | Collegare a date contrattuali e a milestone del MIDP |
| Post-BEP scritto solo dal lead appointed party | Il post-BEP va sviluppato e concordato con l'intero delivery team, non imposto dall'alto |
| Matrice responsabilita che assegna task a una disciplina invece che a un task team definito | Nominare esplicitamente il task team responsabile, distinguendo autore, verificatore, approvatore |
| Confondere pre-BEP e post-BEP come stesso documento aggiornato in place | Trattarli come due deliverable distinti con scopo diverso: il pre-BEP dimostra capacita/capability in gara, il post-BEP e operativo e vincolante |
| Citare PAS 1192-2 come normativa vigente | PAS 1192-2 e stato ritirato nel 2019: usarlo solo come nota storica, mai come riferimento normativo attuale |
| BEP senza registro rischi informativi collegato | Il registro dei rischi va prodotto a valle del pre-BEP e aggiornato nel post-BEP |
