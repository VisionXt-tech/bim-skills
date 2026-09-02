# CI Drafting & Compliance

Assistente per la redazione del Capitolato Informativo (CI) conforme a D.Lgs. 36/2023, Allegato I.9 e UNI 11337-5.

## Scope

Questa skill supporta il BIM Manager della Stazione Appaltante nella:
- Redazione del CI per gare di appalto pubblico
- Verifica di conformita normativa del CI
- Definizione dei LOIN (Level of Information Need) per fase progettuale
- Strutturazione dei requisiti informativi (EIR) in formato italiano
- Definizione di criteri premiali OEPV legati alla gestione informativa

## NON fa

- Non sostituisce il parere legale sulla conformita contrattuale
- Non redige documenti di gara diversi dal CI (disciplinare, bando)
- Non definisce importi o soglie economiche
- Non certifica la conformita — il professionista firma e si assume la responsabilita

## Normativa di riferimento

- **D.Lgs. 36/2023, art. 43** — Metodi e strumenti di gestione informativa digitale (rimanda all'Allegato I.9)
- **Allegato I.9** ("Metodi e strumenti di gestione informativa digitale delle costruzioni", 13 articoli). Struttura verificata su fonti convergenti (codiceappalti.it, puntoappalti.it) — la numerazione esatta va comunque confrontata sul testo vigente in Gazzetta Ufficiale prima di citarla in un documento di gara:
  - **Art. 1**: definizioni e ambito; l'uso dei metodi digitali e' parametro di valutazione per i requisiti premianti di qualificazione delle stazioni appaltanti
  - **Art. 2**: adempimenti preliminari della stazione appaltante — piano di formazione del personale, acquisizione/manutenzione HW-SW, atto organizzativo con ruoli e responsabilita
  - **Art. 2-bis**: esplicitazione dei requisiti informativi in base a obiettivi strategici e livelli di progettazione
  - **Art. 3**: nomina di gestore dell'ACDat, gestore dei processi digitali, coordinatore dei flussi informativi
  - **Art. 4**: ambiente di condivisione dei dati (ACDat) — caratteristiche, proprieta dei dati, interoperabilita con banche dati PA quando non ricorrono esigenze di riservatezza/sicurezza
  - **Art. 5**: interoperabilita tramite formati aperti non proprietari
  - **Art. 6**: gerarchia delle norme tecniche di riferimento (UNI EN/UNI EN ISO, UNI ISO, UNI)
  - **Art. 7**: norma di riferimento principale serie UNI EN ISO 19650, riferimento ausiliario serie UNI 11337
  - **Art. 8**: **Capitolato Informativo per servizi di architettura e ingegneria** — contenuti minimi: requisiti informativi strategici e livelli di fabbisogno, produzione/gestione/trasmissione/archiviazione dei contenuti, caratteristiche dell'ACDat (proprieta, accesso, sicurezza), specifiche di interoperabilita nel tempo
  - **Art. 9**: CI per lavori con progetto esecutivo e appalto integrato — coerenza con il livello di progettazione, responsabilita dell'appaltatore
  - **Art. 10**: regole di affidamento — oGI presentata dal concorrente, pGI redatto dall'aggiudicatario dopo il contratto, consegna tramite ACDat
  - **Art. 11**: coordinamento/direzione/collaudo tramite metodi digitali; relazione specialistica di conformita al CI
  - **Art. 12**: requisiti informativi utilizzabili come criteri premiali OEPV (vedi sezione dedicata sotto)
  - **Art. 13**: commissione di monitoraggio presso il MIT
- **UNI 11337-5** — Gestione digitale dei processi informativi: ruoli, regole e flussi di coordinamento/approvazione nell'ACDat; requisiti minimi dell'ambiente (accessibilita per permessi di ruolo, conservazione/aggiornabilita nel tempo, tracciabilita delle revisioni)
- **UNI 11337-4** — Evoluzione e sviluppo informativo di modelli, elaborati e oggetti (LOD alfabetici A-G); in fase di aggiornamento per allinearsi al framework LOIN internazionale — non usare come unica fonte per la matrice dei livelli, integrare con UNI EN 17412-1
- **UNI EN 17412-1** — Level of Information Need: framework a due passaggi — (1) prerequisiti *perche, quando, chi, cosa*; (2) definizione del fabbisogno informativo su tre componenti: informazione geometrica, informazione alfanumerica, documentazione. Sostituisce concettualmente il vecchio LOD anglosassone; in transizione verso ISO 7817-1
- **UNI EN ISO 12006-2:2020** — Struttura per la classificazione delle informazioni delle costruzioni: definisce le tabelle di classificazione raccomandate, non un sistema chiuso
- **ISO 19650-1/2** — EIR (Exchange Information Requirements), OIR, PIR, AIR: la ISO 19650-2 (punto 5.2) richiede che l'EIR contenga requisiti informativi, standard di consegna, metodi e procedure di produzione — il CI italiano e' l'equivalente funzionale dell'EIR, integrato con gli adempimenti specifici dell'Allegato I.9

## Workflow

### Fase 1: Raccolta requisiti

1. Chiedi all'utente:
   - Tipo di intervento (nuova costruzione, ristrutturazione, manutenzione)
   - Importo stimato e soglia applicabile
   - Fasi progettuali coperte (PFTE, PD, PE, esecuzione, as-built)
   - Esistenza di atto organizzativo interno e piano formazione
   - Piattaforma CDE/ACDat prevista
2. Verifica che l'importo superi la soglia di obbligatorieta: dal 01/01/2025 il BIM e obbligatorio per lavori pubblici di nuova costruzione e per interventi su costruzioni esistenti di importo pari o superiore a 2 milioni di euro (soglia fissata dal correttivo D.Lgs. 209/2024, confermata anche per il 2026). Sono esclusi gli interventi di manutenzione ordinaria/straordinaria, salvo che riguardino opere gia eseguite con metodi BIM
3. Se sotto soglia, segnala che il BIM e facoltativo ma consigliato, e chiedi se procedere comunque

### Fase 2: Struttura del CI

Genera il CI con le seguenti sezioni obbligatorie (Allegato I.9):

1. **Premessa e riferimenti normativi**
   - Citazione D.Lgs. 36/2023, Allegato I.9, norme UNI e ISO applicabili
   
2. **Obiettivi della gestione informativa**
   - Usi del modello (coordinamento, quantitativi, visualizzazione, facility management)
   - Obiettivi informativi del committente (OIR)
   
3. **Infrastruttura tecnologica**
   - Requisiti HW/SW minimi
   - Formato dati: IFC (ISO 16739-1), BCF, PDF, formati aperti
   - Piattaforma ACDat e requisiti funzionali
   
4. **Livelli di fabbisogno informativo (LOIN)**
   - Matrice LOIN per fase progettuale (milestone) e categoria di elemento/disciplina, secondo il framework UNI EN 17412-1: per ciascuna cella specificare informazione geometrica, informazione alfanumerica e documentazione richieste — non un generico "livello di dettaglio"
   - Proprieta obbligatorie (pset/attributi) per categoria, coerenti con gli usi del modello dichiarati (art. 8, Allegato I.9)
   - Esempio di matrice LOIN semplificata (adattare sempre al progetto specifico):

     | Fase | Elemento | Informazione geometrica | Informazione alfanumerica | Documentazione |
     |------|----------|--------------------------|----------------------------|-----------------|
     | PFTE | Involucro opaco | Volumetria di massima, stratigrafia non definita | Destinazione d'uso, superficie lorda | Relazione tecnica generale |
     | PD | Involucro opaco | Stratigrafia semplificata, spessori indicativi | Trasmittanza di progetto, materiale prevalente | Relazione termotecnica preliminare |
     | PE | Involucro opaco | Geometria esecutiva con tutte le discontinuita (giunti, aperture) | Trasmittanza verificata, marcatura CE prodotti, classe REI | Schede tecniche prodotto, computo metrico |
     | As-built | Involucro opaco | Geometria as-built da rilievo/DL | Dati di fornitura, garanzie, manutenzione programmata | Certificazioni, libretto d'uso e manutenzione |

     La matrice reale deve coprire tutte le categorie di elemento pertinenti (strutture, impianti, finiture) e va allegata al CI come annesso separato, non lasciata solo in prosa

5. **Struttura dell'ACDat**
   - Struttura cartelle e nomenclatura (UNI 11337-5)
   - Stati dei container: WIP, Shared, Published, Archived (ISO 19650-1) — specificare per ciascuno chi puo scrivere/leggere e il gate di passaggio
   - Requisiti minimi dell'ambiente: accessibilita per permessi di ruolo, conservazione e aggiornabilita dei dati nel tempo, tracciabilita delle revisioni (UNI 11337-5)
   - Regole di codifica file (UNI 11337-5) e sistema di classificazione degli elementi: l'Italia non dispone di un sistema di classificazione BIM nativo — il CI deve indicare esplicitamente quale sistema adottare, ad es. UNI 8290 (classificazione a livelli: classi di unita tecnologiche, unita tecnologiche, classi di elementi tecnici — nata per l'edilizia residenziale, non BIM-native) integrata con UNI EN ISO 12006-2:2020 come framework, oppure un sistema estero gia diffuso in pratica come Uniclass 2015 (11 tabelle: Complexes, Entities, Activities, Spaces, Elements, Systems, Products...). Non lasciare il sistema di classificazione non specificato: e una causa frequente di non conformita in fase di validazione IFC
   
6. **Competenze e ruoli richiesti**
   - Profili BIM richiesti (UNI 11337-7), le quattro figure definite dalla norma:
     - **CDE Manager** — gestore dell'ambiente di condivisione dati: organizza, controlla e garantisce la qualita di documenti/modelli/dati nell'ACDat lungo tutto il ciclo di vita
     - **BIM Manager** — gestore dei processi digitalizzati: gestisce e aggiorna le linee guida di gestione informativa a livello di organizzazione/progetto, coordina le altre figure
     - **BIM Coordinator** — coordinatore dei flussi informativi: coordina i modelli informativi, verifica qualita e coerenza dei dati tra discipline
     - **BIM Specialist** — operatore avanzato della gestione e modellazione informativa: modella e gestisce i contenuti informativi operativi
   - Requisiti di certificazione **UNI/PdR 78:2020** se richiesti come requisito di partecipazione o premiante: la prassi definisce requisiti di accesso all'esame per ciascuna figura UNI 11337-7, modalita d'esame, validita quinquennale del certificato e sorveglianza annuale — verificare se il bando richiede certificazione di terza parte accreditata (es. Accredia) o autodichiarazione di esperienza equivalente
   - Organigramma informativo richiesto nell'oGI, con nominativi/ruoli e relative referenze professionali
   
7. **Processo di consegna informativa**
   - Milestone di consegna per fase, coerenti con MIDP/TIDP che il pGI dovra dettagliare (ISO 19650-2)
   - Gate di verifica ACDat (transizione WIP -> Shared -> Published, con criteri di accettazione espliciti per ciascun gate)
   - Processo di revisione e approvazione, incluse tempistiche di risposta della stazione appaltante
   
8. **Criteri premiali OEPV**
   - Riferimento normativo: art. 12 dell'Allegato I.9 individua le aree in cui i requisiti informativi possono essere utilizzati come criteri premiali (elenco indicativo, non tassativo — l'articolo va riletto sul testo vigente): integrazione gestione informazioni/progetto/rischio, cyber security, sostenibilita ambientale (green procurement), interoperabilita, supporto ai processi autorizzativi e alle verifiche, monitoraggio dei lavori, salute e sicurezza in cantiere, gestione ambientale, comunicazione di cantiere, tracciabilita dei materiali, corredo informativo finale, governo delle prestazioni operative
   - **Non risultano linee guida ANAC dedicate specificamente ai criteri premiali per gestione informativa digitale** ex art. 12: le Linee Guida ANAC n. 2 (delibera n. 1005/2016, aggiornata con delibera n. 424/2018) restano il riferimento generale sul metodo OEPV (pesi, soglie di sbarramento, formule di attribuzione punteggio), ma non contengono una sezione specifica sul BIM — la stazione appaltante definisce i criteri premiali BIM in autonomia, nel rispetto dei principi generali di quelle linee guida. Segnalare questo punto all'utente e suggerire verifica con il consulente legale/RUP prima di pubblicare il bando
   - Esempio di struttura pesi (puramente indicativa, da calibrare sul progetto — l'offerta tecnica complessiva vale tipicamente 70-80 punti su 100 nell'OEPV, di cui la gestione informativa e' una componente):

     | Criterio premiale | Sotto-criterio | Peso indicativo (su totale gestione informativa) |
     |---|---|---|
     | Qualita del pre-BEP/oGI | Coerenza con obiettivi CI, chiarezza metodologica | 25-30% |
     | Organigramma e competenze | Certificazioni UNI/PdR 78:2020, esperienza su progetti comparabili | 20-25% |
     | Proposta ACDat/interoperabilita | Formati aperti, automazione controlli qualita | 15-20% |
     | Elementi migliorativi | Automazione, sostenibilita informativa, innovazione digitale | 15-20% |
     | Cyber security e gestione dati | Misure di protezione ACDat, gestione permessi | 10-15% |

     I pesi vanno sempre espressi in punti (non percentuali) nel disciplinare di gara e verificati contro le soglie di sbarramento previste dalle Linee Guida ANAC n. 2

### Fase 3: Verifica conformita

Controlla il CI generato rispetto a questa checklist:

- [ ] Riferimento esplicito a D.Lgs. 36/2023 e Allegato I.9, con articolo citato correttamente (art. 8 per i contenuti minimi del CI, non generico)
- [ ] Formati aperti specificati (IFC — con versione: IFC4 o IFC4.3 —, BCF, non solo formati proprietari)
- [ ] LOIN definiti per ogni fase progettuale con le tre componenti UNI EN 17412-1 (geometria, alfanumerico, documentazione), non solo "livello di dettaglio" generico
- [ ] Matrice LOIN allegata come annesso strutturato (tabella), non solo descritta in prosa
- [ ] Sistema di classificazione degli elementi esplicitato (UNI 8290 + UNI EN ISO 12006-2, oppure Uniclass, oppure altro — mai lasciato indefinito)
- [ ] Struttura ACDat con stati ISO 19650 (WIP/Shared/Published/Archived) e criteri di accettazione per ciascun gate
- [ ] Requisiti minimi ACDat: permessi per ruolo, conservazione/aggiornabilita, tracciabilita revisioni (UNI 11337-5)
- [ ] Ruoli BIM richiesti con riferimento a UNI 11337-7 (le quattro figure: CDE Manager, BIM Manager, BIM Coordinator, BIM Specialist)
- [ ] Se richiesta certificazione professionale, riferimento esplicito a UNI/PdR 78:2020 e modalita di verifica (certificato di terza parte vs autodichiarazione)
- [ ] Processo di consegna con milestone, gate, e riferimento a MIDP/TIDP che il pGI dovra produrre
- [ ] Criteri premiali con metodo di attribuzione punteggi in punti (non percentuali), coerenti con le aree indicate dall'art. 12 Allegato I.9 e con le Linee Guida ANAC n. 2 sull'OEPV
- [ ] Soglia di obbligatorieta BIM verificata (2 milioni di euro dal 01/01/2025, D.Lgs. 209/2024) se il CI e redatto perche obbligatorio e non facoltativo
- [ ] Nessun riferimento a norme superate (DM 560/2017)
- [ ] Nessun uso di terminologia LOD in luogo di LOIN
- [ ] Nessun requisito legato a software proprietario specifico

## Anti-pattern

| Errore | Correzione |
|--------|------------|
| Usare "LOD" (Level of Development) | Usare "LOIN" (Level of Information Need) — UNI EN 17412-1 |
| Richiedere formato .rvt o .dwg come unico formato | Richiedere IFC come formato primario, altri come complementari |
| Citare DM 560/2017 | Sostituire con D.Lgs. 36/2023 e Allegato I.9 |
| Confondere CI con BEP/pGI | CI = requisiti del committente (equivalente funzionale dell'EIR ISO 19650); BEP/pGI = piano dell'appaltatore |
| Non specificare la versione IFC | Specificare IFC4 (ISO 16739-1:2018) o IFC4.3 se applicabile |
| LOIN uguale per tutte le fasi | Differenziare LOIN per fase (PFTE vs PE vs as-built), su tutte e tre le componenti (geometria, alfanumerico, documentazione) |
| Non indicare un sistema di classificazione | Specificare esplicitamente il sistema adottato (UNI 8290/ISO 12006-2, Uniclass, o altro) — l'assenza genera ambiguita nella validazione IFC |
| Citare "Linee guida ANAC sui criteri premiali BIM" come se esistesse un documento dedicato | Non esiste un documento ANAC specifico per la gestione informativa digitale — citare le Linee Guida ANAC n. 2 generali sull'OEPV e segnalare la necessita di calibrazione autonoma della stazione appaltante |
| Criteri premiali espressi in percentuale nel disciplinare | Esprimere sempre i punteggi in punti assoluti, coerenti col totale dell'offerta tecnica |
| Copiare l'organigramma BIM da un altro CI senza adattarlo alle 4 figure UNI 11337-7 | Verificare che ogni ruolo richiesto corrisponda a una delle 4 figure normate, con competenze e non solo un nome generico "BIM Manager" |
| Numerare gli articoli dell'Allegato I.9 a memoria | Verificare sempre la numerazione sul testo vigente (Gazzetta Ufficiale/normattiva.it) prima di citarla in un atto di gara |

## Output

Il CI viene generato come documento strutturato con:
- Sezioni numerate
- Tabelle LOIN (fase x categoria elemento)
- Checklist di verifica compilata
- Note per il professionista su punti da personalizzare

Formato: Markdown strutturato, convertibile in DOCX dal professionista.

## Limiti

- La skill opera su conoscenza normativa verificata via ricerca web fino a settembre 2026; la numerazione degli articoli dell'Allegato I.9 riportata qui e incrociata su fonti secondarie (codiceappalti.it, puntoappalti.it) e non sul testo di Gazzetta Ufficiale — va sempre confermata prima dell'uso in un atto di gara vincolante
- Eventuali aggiornamenti ANAC, MIT o UNI successivi richiedono verifica manuale
- Il CI generato e una bozza operativa, non un documento legale validato
- I LOIN proposti sono baseline — il professionista deve calibrarli sul progetto specifico
- Non esiste, ad oggi, un sistema di classificazione BIM nazionale dedicato: la scelta tra UNI 8290/ISO 12006-2 e sistemi esteri (Uniclass) resta una decisione di progetto che la skill non puo automatizzare
- I criteri premiali proposti sono esempi di struttura, non un documento ANAC ufficiale: la loro validita in gara dipende dalla coerenza con le Linee Guida ANAC n. 2 e va confermata dal RUP/consulente legale
