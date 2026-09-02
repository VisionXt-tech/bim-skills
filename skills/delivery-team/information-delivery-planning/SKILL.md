# Information Delivery Planning

Gestione MIDP e TIDP per la pianificazione delle consegne informative.

## Scope

- Costruzione Master Information Delivery Plan (MIDP)
- Costruzione Task Information Delivery Plan (TIDP) disciplinari
- Pianificazione milestone informative per fase progettuale
- Assegnazione responsabilita per pacchetto informativo

## Normativa

- **ISO 19650-2** — clausola 5.4 e ss.: framework MIDP/TIDP nella fase di delivery (dopo l'affidamento)
- **UNI 11337-5:2017** — flussi informativi (PIF) nei processi digitalizzati: ruoli e regole per produzione, gestione e trasmissione delle informazioni, base italiana per MIDP/TIDP
- **Allegato I.9 (D.Lgs. 36/2023)** — milestone e fasi progettuali a cui MIDP/TIDP vanno agganciati

## Definizioni e responsabilita

- **TIDP (Task Information Delivery Plan)**: elenco federato dei deliverable informativi di **un singolo task team** (una disciplina/gruppo di lavoro, non un singolo professionista), con formato, date e responsabilita. E prodotto e mantenuto dal **task team manager** di ciascuna disciplina — chi coordina il gruppo, non necessariamente chi modella
- **MIDP (Master Information Delivery Plan)**: consolidamento di **tutti** i TIDP del progetto in un unico programma di consegna. Risponde alla domanda "cosa viene consegnato, da chi, quando e in che ordine". E prodotto e mantenuto dall'**information manager** all'interno del lead appointed party, a partire dai TIDP ricevuti da ciascun task team — non lo crea da zero, lo aggrega e verifica coerenza tra le discipline
- Il MIDP deve incorporare: le responsabilita assegnate nella matrice responsabilita (vedi skill `bim-execution`), le dipendenze/predecessori tra deliverable di task team diversi, e il tempo necessario per revisione e autorizzazione di ogni container prima della consegna
- **Aggiornamento**: TIDP e MIDP non sono documenti statici — vanno rivisti a ogni gate di progetto/milestone contrattuale e comunque con cadenza periodica (tipicamente mensile o a ogni ciclo di coordinamento), oltre che ogni volta che cambiano scope, team o programma lavori. Un MIDP "congelato" alla firma del contratto e un anti-pattern

## Workflow

### TIDP (prima, per ogni disciplina)

1. Per ogni task team, il task team manager compila il TIDP con le colonne standard:

| Colonna | Contenuto |
|---|---|
| ID container | Identificativo univoco secondo la nomenclatura di progetto |
| Descrizione | Nome/contenuto sintetico del deliverable |
| Disciplina/Task Team | Gruppo responsabile |
| LOIN (LOD/LOI) | Livello di fabbisogno informativo richiesto per la fase |
| Formato | Formato di scambio (IFC, RVT, PDF, ...) coerente col BEP |
| Responsabile | Autore/task team manager (nominativo, non generico) |
| Predecessori/dipendenze | Container da cui questo deliverable dipende |
| Data inizio produzione | Avvio lavorazione |
| Data consegna interna | Bozza per revisione |
| Tempo di revisione | Durata prevista per verifica/approvazione |
| Data consegna finale | Allineata al programma lavori generale + buffer di revisione |
| Stato | Non iniziato / In corso / In revisione / Approvato / Consegnato |

2. Segnala esplicitamente le dipendenze verso task team diversi (es. strutture attende architettonico) — sono l'input principale che il MIDP deve riconciliare

### MIDP (poi, aggregazione)

1. Acquisisci: fasi progettuali, milestone contrattuali, TIDP di tutte le discipline coinvolte
2. L'information manager consolida i TIDP in un'unica matrice MIDP con le stesse colonne chiave (container, task team, LOIN, formato, responsabile, data consegna, stato) piu:
   - Milestone contrattuale/gate ACDat di riferimento per ciascun deliverable
   - Verifica di coerenza tra le date di consegna e le dipendenze incrociate dichiarate nei singoli TIDP
3. Collega ogni riga a milestone contrattuali e gate ACDat; segnala conflitti di programma tra discipline prima che diventino ritardi

## Anti-pattern

| Errore | Correzione |
|--------|------------|
| MIDP creato senza raccogliere i TIDP delle discipline | Il MIDP e un consolidamento: va costruito a partire dai TIDP, non in parallelo o al posto loro |
| TIDP con responsabile indicato come "team X" senza nominativo | Assegnare sempre un responsabile nominale, coerente con la matrice responsabilita del BEP |
| Nessun tempo di revisione previsto tra produzione e consegna | Riservare esplicitamente un buffer di revisione/autorizzazione nel TIDP, non far coincidere fine produzione e data di consegna |
| MIDP/TIDP definiti una volta e mai aggiornati | Rivedere a ogni milestone/gate e a ogni cambio di scope o programma |
| Dipendenze tra discipline non dichiarate nel TIDP | Il task team manager deve elencare esplicitamente i predecessori: e la base per rilevare conflitti nel MIDP |
| Confondere TIDP con la lista di modelli da consegnare | Il TIDP copre ogni container informativo (modelli, documenti, dataset), non solo i modelli 3D |

## Output

Tabelle MIDP/TIDP in formato Markdown o CSV, con le colonne standard indicate sopra, collegabili a project management tool.
