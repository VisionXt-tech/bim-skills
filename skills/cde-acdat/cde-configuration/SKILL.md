# CDE Configuration & Governance

Assistente per la configurazione e governance dell'Ambiente Comune di Condivisione Dati (ACDat/CDE).

## Scope

- Configurazione struttura CDE/ACDat (cartelle, stati, permessi)
- Definizione regole di stato container ISO 19650
- Setup nomenclatura e codifica file
- Governance permessi e ruoli utente
- Allineamento con CI e protocollo informativo

## NON fa

- Non configura fisicamente piattaforme CDE specifiche (Autodesk ACC, Trimble Connect, etc.)
- Non gestisce licenze o abbonamenti
- Non esegue backup o migrazione dati

## Normativa

- **ISO 19650-1, §12 (CDE concept)** — definisce le 4 aree del CDE: Work in Progress, Shared, Published, Archive
- **ISO 19650-1, def. 3.3.11 "information container"** — "named persistent set of information retrievable from within a file, system or application storage hierarchy": l'unita minima di gestione nel CDE (un modello, un disegno, un documento, un foglio dati); ogni container ha ID univoco, metadati e uno stato
- **ISO 19650-2** — richiede che ogni container abbia un codice di stato (status/suitability code) ma non impone un elenco universale di codici: la tabella va definita nel progetto (vedi sotto)
- **UNI 11337-5** — struttura ACDat, conferma le stesse 4 Aree (Deposito/WIP, Condivisione/Share, Pubblicazione/Publish, Archiviazione/Archive) e i relativi Stati di Lavorazione/Approvazione
- **Allegato I.9, art. 1, D.Lgs. 36/2023** — la stazione appaltante adotta l'ACDat definendone caratteristiche, prestazioni, proprieta dei dati e modalita di gestione; richiede piattaforme interoperabili con formati aperti non proprietari (IFC/ISO 16739-1, UNI EN ISO 19650), contenitori sia strutturati che non strutturati, e la definizione esplicita di condizioni di accesso, tutela/sicurezza dei dati e riservatezza nel Capitolato Informativo

## Workflow

### Fase 1: Requisiti

1. Piattaforma CDE scelta (ACC, Trimble, SharePoint, Nextcloud, etc.)
2. Numero discipline e team coinvolti
3. Requisiti dal CI (se presente)
4. Policy di sicurezza e retention

### Fase 2: Struttura

Genera schema CDE con:

```
ACDat/
├── WIP/                          # Work In Progress — area di lavoro
│   ├── ARC/                      # Architettura
│   ├── STR/                      # Strutture
│   ├── MEP/                      # Impianti
│   └── [disciplina]/
├── SHARED/                       # Condiviso — pronto per coordinamento
│   └── [stessa struttura]
├── PUBLISHED/                    # Pubblicato — approvato per consegna
│   └── [stessa struttura]
└── ARCHIVED/                     # Archiviato — versioni storiche
    └── [stessa struttura]
```

### Fase 3: Regole

- **Nomenclatura file**: `[Progetto]-[Disciplina]-[Zona]-[Tipo]-[Numero]-[Revisione]`
- **Aree**: WIP → Shared → Published → Archived
- **Transizioni**: chi autorizza il passaggio di area
- **Permessi**: matrice ruolo x area x azione (lettura/scrittura/approvazione) — vedi esempio sotto

### Terminologia: aree del CDE vs codici di stato — due livelli distinti

Sono spesso confusi ma descrivono due cose diverse:

1. **Aree del CDE (WIP / Shared / Published / Archived)**: la terminologia formale usata sia da ISO 19650-1 (§12, CDE concept) sia da UNI 11337-5 (le "4 Aree"). Sono le zone logiche/fisiche in cui i container si spostano nel corso del ciclo di vita informativo.
2. **Codice di stato (status/suitability code)**: metadato assegnato a ogni singolo container per indicarne l'idoneita d'uso in un dato momento (es. "adatto al coordinamento", "adatto all'approvazione di fase"). ISO 19650-2 impone che ogni container abbia un codice di stato, ma **non** impone un elenco universale di codici: la tabella S0-S4/A/B piu diffusa proviene dal National Annex NA (informativo) di BS EN ISO 19650-2 nel Regno Unito ed e stata adottata de facto da molte piattaforme CDE anche fuori UK. **Per un progetto italiano la tabella codici va definita esplicitamente nel Capitolato Informativo / piano di gestione informativa — non va assunta come automatica.**

Convenzione diffusa (da verificare/adattare nel CI di progetto, non normativa universale):

| Codice | Area CDE | Significato indicativo |
|--------|----------|-------------------------|
| S0 | WIP | Stato iniziale in elaborazione, non condiviso fuori dal team autore |
| S1 | Shared | Adatto al coordinamento tra discipline |
| S2 | Shared | Adatto a scopo informativo (non per geometria definitiva) |
| S3 | Shared | Adatto a revisione e commento formale |
| S4 | Shared | Adatto all'approvazione di fase / invio al committente |
| A | Published | Autorizzato e accettato — informazione contrattuale |
| B | Published | Pubblicato con commenti da risolvere — uso condizionato |

### Esempio matrice permessi (ruolo x area x azione)

R = lettura, W = scrittura, A = approvazione/transizione di stato

| Ruolo | WIP (propria disciplina) | WIP (altre discipline) | Shared | Published | Archived |
|-------|---------------------------|--------------------------|--------|------------|----------|
| Autore/Task Team | R/W | — | R | R | R |
| Task Information Manager | R/W | R | R/W, A (WIP→Shared) | R | R |
| Information Manager (Lead Appointed Party) | R | R | R/W | R/W, A (Shared→Published) | A (Published→Archived) |
| Appointing Party / Committente | — | — | R (su invito) | R, A (approvazione contrattuale) | R |
| Auditor / Security Officer | R (solo log) | R (solo log) | R (solo log) | R (solo log) | R (solo log) |

## Anti-pattern

| Errore | Correzione |
|--------|------------|
| Struttura piatta senza aree | SEMPRE 4 aree ISO 19650 / UNI 11337-5 (WIP, Shared, Published, Archived) |
| Permessi "tutti possono tutto" | Matrice permessi per ruolo, area e azione (vedi esempio) |
| Nomenclatura libera | Codifica obbligatoria da protocollo |
| Nessun log di transizione | Tracciare ogni cambio stato con timestamp e autore |
| Confondere "area CDE" con "codice di stato" | Sono due livelli distinti: area fisica/logica + metadato di idoneita del container |
| Adottare la tabella codici UK (S0-S4, A, B) senza verificarla nel CI | La tabella codici del progetto va definita nel Capitolato Informativo; ISO 19650-2 non la impone come elenco fisso |
| Scrittura diretta in Published da parte degli autori | Solo l'Information Manager autorizza la transizione Shared→Published |
