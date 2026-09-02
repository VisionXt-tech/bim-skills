# oGI Evaluation

Supporto alla valutazione delle Offerte di Gestione Informativa (oGI) in gare BIM.

## Scope

- Analisi e scoring di oGI rispetto ai requisiti del Capitolato Informativo
- Verifica completezza del pre-BEP e del piano di mobilizzazione
- Attribuzione criteri premiali OEPV per gestione informativa
- Generazione scheda di valutazione strutturata

## NON fa

- Non assegna punteggi definitivi — propone valutazioni che la Commissione conferma
- Non valuta aspetti economici dell'offerta
- Non accede a piattaforme di e-procurement

## Normativa di riferimento

- **D.Lgs. 36/2023, Allegato I.9, art. 10** — L'offerta di gestione informativa (oGI) e presentata dal concorrente in risposta ai requisiti informativi del Capitolato Informativo, in procedure con criterio dell'offerta economicamente piu vantaggiosa; struttura temporalmente i flussi informativi e descrive la configurazione organizzativa e strumentale del concorrente. Il pGI e' invece redatto dall'aggiudicatario dopo la sottoscrizione del contratto, sulla base dell'oGI approvata (numerazione articolo da riconfermare sul testo vigente prima di citarla in atti formali)
- **D.Lgs. 36/2023, Allegato I.9, art. 12** — Aree in cui i requisiti informativi possono essere utilizzati come criteri premiali OEPV (vedi elenco dettagliato nella skill `ci-drafting`)
- **ISO 19650-2** — L'oGI e' l'equivalente funzionale del **pre-appointment BEP**: documento che descrive l'approccio, la capacita e la capacita proposti dal team candidato per soddisfare gli EIR del committente, prima dell'aggiudicazione
- **UNI 11337-5** — Contenuti informativi dell'offerta, flussi verso/da e dentro l'ACDat
- **UNI 11337-7** — Le 4 figure professionali BIM che l'oGI deve organizzare in un organigramma coerente: CDE Manager (gestore ACDat), BIM Manager (gestore processi digitalizzati), BIM Coordinator (coordinatore flussi informativi), BIM Specialist (operatore avanzato di modellazione)
- **UNI/PdR 78:2020** — Prassi di riferimento per la valutazione e certificazione dei professionisti BIM sulle 4 figure UNI 11337-7: definisce requisiti di accesso all'esame, modalita di verifica, validita quinquennale del certificato, sorveglianza annuale. Se il CI richiede certificazioni, verificare che siano rilasciate da organismo accreditato (es. Accredia) e non semplici attestati di frequenza a corso
- **Linee Guida ANAC n. 2** (delibera n. 1005/2016, aggiornata con delibera n. 424/2018) — Metodo generale di attribuzione punteggi nell'OEPV (formule, soglie di sbarramento); non esiste una sezione ANAC dedicata specificamente ai criteri premiali per gestione informativa digitale — segnalarlo se l'utente chiede di applicare "le linee guida ANAC sul BIM" come se fossero un documento a se

## Workflow

### Fase 1: Acquisizione documenti

1. Chiedi all'utente: CI di riferimento, oGI da valutare, griglia criteri premiali
2. Estrai requisiti dal CI e criteri OEPV con relativi pesi

### Fase 2: Analisi oGI

Verifica presenza e qualita di, con checklist operativa per ciascun blocco:

- **Pre-BEP** (equivalente funzionale del pre-appointment BEP ISO 19650-2): obiettivi, ruoli proposti, strumenti, metodologia
  - [ ] Gli obiettivi dichiarati rispondono esplicitamente agli obiettivi informativi (OIR) del CI, non sono generici
  - [ ] E' indicata la metodologia di coordinamento interdisciplinare (clash detection, revisioni periodiche)
  - [ ] Sono indicati gli usi del modello coerenti con quanto richiesto dal CI (coordinamento, quantitativi, facility management...)
- **Organigramma BIM**: figure certificate, esperienza dichiarata
  - [ ] Le 4 figure UNI 11337-7 sono tutte coperte (CDE Manager, BIM Manager, BIM Coordinator, BIM Specialist) o e' motivato l'accorpamento di ruoli su progetti di dimensione contenuta
  - [ ] Le certificazioni dichiarate, se richieste, sono verificabili (ente accreditato, numero certificato, validita non scaduta secondo UNI/PdR 78:2020 — 5 anni)
  - [ ] L'esperienza dichiarata e' su progetti comparabili per tipologia e complessita, non generica
- **Piano di mobilizzazione**: tempistiche, risorse, formazione
  - [ ] Le tempistiche di attivazione ACDat sono compatibili con l'avvio lavori/progettazione
  - [ ] E' previsto un piano di formazione per il personale non ancora esperto (coerente con l'art. 2 Allegato I.9 lato committente, ma da valutare anche lato concorrente)
- **Proposta CDE/ACDat**: piattaforma, struttura, interoperabilita
  - [ ] La piattaforma proposta supporta formati aperti (IFC, BCF) e non solo l'ecosistema proprietario del concorrente
  - [ ] Sono descritti gli stati dei container (WIP/Shared/Published/Archived) e i permessi per ruolo
  - [ ] E' garantita l'interoperabilita con l'ACDat della stazione appaltante, se gia definito nel CI
- **Elementi migliorativi**: innovazione, automazione, sostenibilita informativa
  - [ ] Gli elementi migliorativi sono verificabili e non solo dichiarazioni di intenti ("useremo l'AI per...")
  - [ ] Sono ricondotti a una delle aree premiali indicate dall'art. 12 Allegato I.9 (cyber security, sostenibilita ambientale, interoperabilita, tracciabilita materiali, ecc.), non generiche

### Fase 3: Scoring

Per ogni criterio premiale:
- Confronta contenuto oGI con requisito CI
- Valuta su scala definita (0-insufficiente, 1-sufficiente, 2-buono, 3-ottimo) oppure sulla scala definita nel disciplinare di gara specifico — non inventare una scala se il disciplinare ne specifica una diversa
- Motiva ogni valutazione con riferimento normativo e puntuale (sezione del CI, non generico "conforme al CI")
- Se il punteggio e' insufficiente su un criterio essenziale (es. assenza totale di organigramma BIM), segnala se il disciplinare prevede soglie di sbarramento (Linee Guida ANAC n. 2) che escludono l'offerta

### Fase 4: Report

Genera scheda di valutazione con: criterio, peso, punteggio, motivazione, riferimento CI, riferimento normativo (se pertinente).

Esempio struttura riga:

| Criterio | Peso max | Punteggio proposto | Motivazione | Rif. CI | Rif. normativo |
|---|---|---|---|---|---|
| Organigramma BIM e certificazioni | 20 pt | 15 pt | Coperte 3/4 figure UNI 11337-7, manca CDE Manager dedicato (accorpato a BIM Manager senza motivazione) | CI par. 6 | UNI 11337-7 |
| Proposta ACDat | 15 pt | 12 pt | Formati aperti garantiti, stati container non dettagliati per i permessi di ruolo | CI par. 5 | UNI 11337-5 |

## Anti-pattern

| Errore | Correzione |
|--------|------------|
| Valutare senza CI di riferimento | SEMPRE partire dal CI come benchmark |
| Punteggio senza motivazione | Ogni score deve avere giustificazione scritta e puntuale (paragrafo del CI) |
| Confondere oGI con pGI | oGI = offerta (pre-gara, equivalente pre-appointment BEP); pGI = piano operativo (post-aggiudicazione, equivalente post-appointment BEP) |
| Accettare certificazioni BIM senza verificarne l'ente emittente | Controllare che siano rilasciate da organismo accreditato secondo UNI/PdR 78:2020, non attestati di corso non certificanti |
| Valutare l'organigramma BIM contando solo i nomi, non le 4 figure normate | Verificare che ciascuna delle 4 figure UNI 11337-7 (CDE Manager, BIM Manager, BIM Coordinator, BIM Specialist) sia effettivamente coperta con competenze distinte |
| Applicare "le linee guida ANAC sul BIM" come se esistesse un documento dedicato ai criteri premiali digitali | Citare le Linee Guida ANAC n. 2 generali sull'OEPV; i criteri premiali BIM specifici sono definiti dalla singola stazione appaltante nel CI/disciplinare |
| Ignorare le soglie di sbarramento previste dal disciplinare | Segnalare sempre se un punteggio basso su un criterio essenziale comporta esclusione, prima di procedere con lo scoring degli altri criteri |
| Valutare elementi migliorativi generici ("useremo tecnologie innovative") come punteggio pieno | Richiedere verificabilita: strumento specifico, processo descritto, area premiale collegata (art. 12 Allegato I.9) |

## Limiti

- La skill propone valutazioni, la Commissione Giudicatrice decide
- Non verifica veridicita delle dichiarazioni (certificazioni, esperienze) — un certificato UNI/PdR 78:2020 dichiarato va controllato dalla stazione appaltante presso l'ente accreditato
- Criteri premiali variano per gara — devono essere forniti dall'utente, la skill non inventa pesi se non dichiarati
- La numerazione degli articoli dell'Allegato I.9 citata qui e' incrociata su fonti secondarie e va confermata sul testo vigente prima dell'uso in un verbale di gara
