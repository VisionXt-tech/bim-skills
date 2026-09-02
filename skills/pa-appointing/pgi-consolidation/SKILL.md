# pGI Consolidation

Assistente per la trasformazione dell'oGI in Piano di Gestione Informativa (pGI) operativo.

## Scope

- Trasformazione oGI approvata in pGI operativo
- Integrazione BEP, MIDP/TIDP, matrice responsabilita
- Definizione regole di controllo qualita e protocolli informativi
- Allineamento con CI e requisiti contrattuali

## NON fa

- Non redige contratti o atti legali
- Non valida la conformita giuridica del pGI
- Non gestisce il processo di aggiudicazione

## Normativa

- **D.Lgs. 36/2023, Allegato I.9, art. 10** — Il piano di gestione informativa (pGI) e' redatto dall'aggiudicatario sulla base dell'oGI presentata in gara, va sottoposto alla stazione appaltante dopo la sottoscrizione del contratto e prima dell'esecuzione, ed e' aggiornabile durante i lavori; la consegna avviene tramite l'ACDat della stazione appaltante (numerazione articolo da riconfermare sul testo vigente prima di citarla in atti contrattuali)
- **D.Lgs. 36/2023, Allegato I.9, art. 11** — Coordinamento, direzione e controllo dell'esecuzione tramite metodi digitali; se il direttore dei lavori non ha le competenze necessarie, va nominato un coordinatore dei flussi informativi; in fase di collaudo l'affidatario consegna i modelli aggiornati e una relazione specialistica che attesti il rispetto del CI
- **ISO 19650-2** — Il pGI e' l'equivalente funzionale del **post-appointment BEP**: conferma l'approccio di gestione informativa del delivery team, con pianificazione e cronoprogrammi di dettaglio (MIDP/TIDP)
- **UNI 11337-5** — Struttura del piano di gestione informativa: ruoli, regole e flussi di coordinamento/approvazione nell'ACDat; requisiti minimi dell'ambiente (permessi per ruolo, conservazione/aggiornabilita nel tempo, tracciabilita delle revisioni)
- **UNI 11337-7** — Le 4 figure professionali che il pGI deve formalizzare nell'organigramma operativo: CDE Manager, BIM Manager, BIM Coordinator, BIM Specialist, con responsabilita e referenti nominativi (non piu generiche come nell'oGI)

## Workflow

### Fase 1: Input

1. oGI approvata e CI di riferimento
2. Contratto di appalto e condizioni particolari
3. Tempistiche contrattuali e milestone

### Fase 2: Costruzione pGI

Sezioni del pGI:
1. **Dati generali**: progetto, committente, team, riferimenti contrattuali
2. **Obiettivi informativi**: derivati da CI e oGI (OIR/PIR del committente tradotti in obiettivi operativi)
3. **BEP operativo**: dettaglio metodologico e procedurale — equivalente del post-appointment BEP ISO 19650-2, con pianificazione e cronoprogrammi di dettaglio che nell'oGI erano solo proposti
4. **Organigramma BIM**: ruoli, responsabilita, contatti — le 4 figure UNI 11337-7 (CDE Manager, BIM Manager, BIM Coordinator, BIM Specialist) con nominativi reali, non piu placeholder come nell'oGI, e relativa matrice di responsabilita (RACI o equivalente) per ogni consegna
5. **MIDP (Master Information Delivery Plan)**: registro centrale delle consegne informative dell'intero delivery team, costruito aggregando i TIDP di ogni task team; risponde a "cosa viene consegnato, quando e da chi" — e' mantenuto dal lead appointed party (in pratica, chi coordina la commessa lato appaltatore)
6. **TIDP (Task Information Delivery Plan)**: piano di dettaglio di ciascun task team (disciplina/sub-affidatario), che specifica gli output assegnati secondo la matrice di responsabilita; ogni TIDP confluisce nel MIDP
7. **Regole ACDat**: struttura cartelle, stati dei container (WIP/Shared/Published/Archived), nomenclatura file (UNI 11337-5), permessi per ruolo, conservazione/aggiornabilita e tracciabilita delle revisioni
8. **Controllo qualita**: checklist di verifica per gate ACDat, KPI informativi (es. % di elementi con pset completi, % di clash risolti entro SLA)
9. **Gestione non conformita**: processo di segnalazione e risoluzione, con tempistiche e responsabile assegnato

### Fase 3: Verifica coerenza

- Confronto pGI vs CI: tutti i requisiti CI sono coperti (matrice di tracciabilita requisito -> sezione pGI)
- Confronto pGI vs oGI: tutti gli impegni dell'offerta sono mantenuti — eventuali scostamenti vanno giustificati esplicitamente, non silenziati
- Verifica MIDP vs cronoprogramma lavori: le milestone di consegna informativa sono coerenti con le milestone contrattuali/di cantiere, non solo con fasi progettuali generiche
- Verifica che ogni TIDP sia effettivamente ricondotto al MIDP (nessuna consegna disciplinare "orfana")
- Checklist minima di chiusura:
  - [ ] Ogni requisito del CI ha un riscontro esplicito nel pGI
  - [ ] Ogni impegno dell'oGI approvata e' mantenuto o lo scostamento e' motivato e approvato dalla stazione appaltante
  - [ ] MIDP copre tutte le milestone contrattuali, non solo quelle "BIM"
  - [ ] Organigramma con le 4 figure UNI 11337-7 nominate con referenti reali
  - [ ] Regole ACDat coerenti con quanto gia definito nel CI (stessa struttura, stessi stati, stessa nomenclatura — non una versione alternativa)
  - [ ] E' previsto un processo di aggiornamento periodico del pGI durante l'esecuzione (il pGI non e' un documento statico)

## Anti-pattern

| Errore | Correzione |
|--------|------------|
| pGI generico copia-incolla da template | Personalizzare su CI e oGI specifici, con riferimenti puntuali a paragrafi |
| MIDP senza date reali | Collegare a cronoprogramma lavori contrattuale, non a fasi progettuali astratte |
| Nessun processo di aggiornamento | Prevedere revisioni periodiche del pGI — non e' un documento statico, va aggiornato quando cambiano team, cronoprogramma o scope |
| TIDP scollegati dal MIDP | Ogni TIDP disciplinare deve confluire nel MIDP: nessuna consegna "orfana" fuori dal registro centrale |
| Organigramma con ruoli generici ("il BIM Manager") senza nominativi | Il pGI, a differenza dell'oGI, richiede referenti nominativi reali con contatti e responsabilita assegnate |
| Regole ACDat diverse da quelle gia definite nel CI | Il pGI deve essere coerente con la struttura, gli stati e la nomenclatura ACDat gia fissati dal CI, non proporne una versione alternativa |
| Scostamenti dall'oGI approvata non motivati | Ogni scostamento tra pGI e oGI va giustificato esplicitamente e sottoposto ad approvazione della stazione appaltante |
| Confondere pGI con collaudo/relazione di conformita | Il pGI e' il piano operativo di gestione informativa; la relazione specialistica di conformita al CI (art. 11 Allegato I.9) e' un documento separato prodotto in fase di collaudo |

## Output

Il pGI viene generato come documento strutturato con:
- Le 9 sezioni indicate in Fase 2, numerate e tracciabili
- Matrice di tracciabilita requisito CI -> impegno oGI -> sezione pGI
- MIDP in formato tabellare (consegna, disciplina, milestone, data, formato, responsabile)
- Checklist di chiusura compilata (Fase 3)
- Note per il professionista sui punti da personalizzare o su cui manca informazione dal CI/oGI/contratto

Formato: Markdown strutturato, convertibile in formato compatibile con l'ACDat di progetto.

## Limiti

- La skill costruisce il pGI a partire da CI, oGI e contratto forniti dall'utente — non inventa contenuti se questi documenti sono incompleti o assenti, e segnala le lacune invece di colmarle con ipotesi
- Non verifica la validita giuridica del pGI rispetto al contratto: il professionista o il consulente legale deve validare la coerenza contrattuale
- La numerazione degli articoli dell'Allegato I.9 citata in questa skill e' incrociata su fonti secondarie (codiceappalti.it, puntoappalti.it) e va riconfermata sul testo vigente prima dell'uso in un documento contrattuale
- MIDP e TIDP proposti sono basati sulla struttura ISO 19650-2; non sostituiscono un vero e proprio cronoprogramma di commessa, che resta responsabilita del team di progetto
- Non gestisce la fase di collaudo (relazione specialistica di conformita, art. 11 Allegato I.9) — vedi eventuale skill dedicata se disponibile
