---
name: information-delivery-planning
description: >-
  Pianificazione analitica delle consegne informative BIM e costruzione di matrici MIDP (Master Information Delivery Plan)
  e TIDP (Task Information Delivery Plan) secondo ISO 19650-2, D.Lgs. 36/2023 Allegato I.9 e UNI 11337-5.
  Usare per strutturare milestone di consegna BIM, analizzare dipendenze critiche interdisciplinari e monitorare i gate ACDat.
---

# BIM Information Delivery Planning (MIDP & TIDP)

Assistente specialistico per il **Lead Appointed Party (Affidatario Principale)** e per i **Task Team Manager** di disciplina nella redazione, riconciliazione e aggiornamento del **Master Information Delivery Plan (MIDP)** e dei singoli **Task Information Delivery Plan (TIDP)**, in conformità allo standard internazionale **UNI EN ISO 19650-2 (Clausole 5.4.4 e 5.4.5)**, alla norma **UNI 11337-5** e al Codice dei Contratti Pubblici (**D.Lgs. 36/2023** e **D.Lgs. 209/2024** - Allegato I.9).

---

## Scope

Questa skill guida la pianificazione temporale e contenutistica della produzione informativa:
- **Redazione dei TIDP disciplinari**: compilazione da parte di ciascun Task Team Manager (Architettura, Strutture, Impianti Meccanici, Impianti Elettrici, Computi 5D, Sicurezza/Cantiere) dell'elenco analitico dei propri contenitori informativi.
- **Costruzione e federazione del MIDP di commessa**: aggregazione, allineamento e verifica di coerenza di tutti i TIDP in un unico piano di consegna master gestito dal Lead Appointed Party.
- **Analisi del percorso critico informativo (*Critical Information Path*)**: mappatura e risoluzione preventiva delle dipendenze e dei predecessori interdisciplinari per prevenire blocchi o slittamenti a catena.
- **Sincronizzazione con il cronoprogramma generale di commessa**: allineamento delle date di rilascio solari (`GG/MM/AAAA`) alle scadenze contrattuali (PFTE, Progetto Esecutivo, SAL di cantiere, As-Built/Handover).
- **Integrazione con i Gate di passaggio dell'ACDat (CDE)**: pianificazione dei tempi di verifica e approvazione interna (buffer di revisione) prima della transizione dei container da `WIP` a `Shared` e da `Shared` a `Published`.
- **Monitoraggio dinamico dell'avanzamento**: tracciamento settimanale/mensile degli stati di lavorazione e gestione tempestiva delle varianti informative.

---

## NON fa

- Non sostituisce il cronoprogramma generale dei lavori (Gantt contrattuale delle opere fisiche redatto dal Project Manager / Direttore di Cantiere).
- Non redige fisicamente gli elaborati o i modelli (pianifica le consegne, non produce i contenuti).
- Non autorizza pagamenti o SAL economici (attività riservata a Direttore dei Lavori e RUP).

---

## Normativa e Standard di Riferimento

1. **UNI EN ISO 19650-2:2019**:
   - **Clausola 5.4.4 (Stabilire il piano di consegna delle informazioni di ciascun task team - TIDP)**: ciascun task team genera e mantiene il proprio piano, definendo contenitori, formati, LOIN, predecessori e stime temporali di produzione e revisione;
   - **Clausola 5.4.5 (Aggregare i piani di consegna delle informazioni nel piano generale - MIDP)**: il Lead Appointed Party consolida i TIDP, risolve conflitti temporali e convalida il piano aggregato a fronte degli Exchange Information Requirements (EIR/CI).
2. **D.Lgs. 36/2023 & D.Lgs. 209/2024 (Allegato I.9)**:
   - **Art. 10 (Offerta e Piano di Gestione Informativa)**: il pGI operativo recepisce e formalizza il MIDP vincolante di commessa;
   - **Art. 11 (Esecuzione e Collaudo)**: il MIDP struttura i flussi informativi per la direzione lavori e per la relazione specialistica finale di collaudo.
3. **UNI 11337-5:2017**: Piano di Gestione Informativa e flussi di interscambio nell'ACDat;
4. **UNI EN 17412-1:2021**: Level of Information Need (LOIN) associato a ciascun deliverable del piano.

---

## Gerarchia Operativa: Dal TIDP al MIDP

```
COMMITTENTE (Stazione Appaltante)
  └── Capitolato Informativo (CI / EIR)
        └── Lead Appointed Party (BIM Manager Affidatario)
              ├── MASTER INFORMATION DELIVERY PLAN (MIDP) [Aggregazione Master]
              │     ├── TIDP 01 — Architettura (Task Team Architettonico)
              │     ├── TIDP 02 — Strutture (Task Team Ingegneria Strutturale)
              │     ├── TIDP 03 — Impianti Meccanici HVAC (Task Team Meccanico)
              │     ├── TIDP 04 — Impianti Elettrici e Speciali (Task Team Elettrico)
              │     ├── TIDP 05 — Coordinamento & Clash (BIM Coordination Team)
              │     └── TIDP 06 — Computi & Costi 5D (Task Team Quantity Surveying)
```

---

## Workflow Operativo

### Fase 1: Compilazione del TIDP (per ciascun Task Team)

Il Task Team Manager di ogni disciplina redige il proprio TIDP identificando ogni singolo deliverable informativo (modello disciplinare, tavola grafica estratta in PDF/A, computo metrico, relazione di calcolo, scheda tecnica o report BCF).

#### Campi Obbligatori del TIDP (ISO 19650-2 cl. 5.4.4):
1. **ID Contenitore**: codice univoco conforme al pattern di nomenclatura UNI 11337-5;
2. **Titolo / Descrizione**: descrizione sintetica del contenuto;
3. **Disciplina & Task Team**: gruppo operativo responsabile;
4. **Fase di Progetto**: PFTE, Progetto Esecutivo, Costruttivo, As-Built;
5. **LOIN (UNI EN 17412-1)**: declinazione su Geometria (G1-G4), Dati alfanumerici (D1-D4) e Documenti (Doc1-Doc3);
6. **Formato Principale**: IFC4, BCF 2.1, PDF/A, XLSX, RVT, DWG;
7. **Autore / Responsabile Nominale**: persona fisica che modella/redige;
8. **Verificatore Interno**: BIM Coordinator di disciplina che esegue il check prima della condivisione;
9. **Predecessori / Dipendenze**: ID di altri contenitori indispensabili per iniziare o completare la lavorazione;
10. **Data Inizio Lavorazione**: data solare;
11. **Durata Produzione (gg)**: giorni lavorativi previsti;
12. **Buffer di Verifica Interna (gg)**: giorni riservati al controllo qualità intra-disciplinare (WIP Check);
13. **Data Rilascio in Shared (CDE)**: data di consegna per coordinamento interdisciplinare;
14. **Stato Corrente**: *Pianificato / In Lavorazione / In Verifica / Condiviso / Approvato*.

##### Esempio TIDP Disciplinare Strutture (Estratto):

| ID Contenitore UNI 11337-5 | Titolo Deliverable | LOIN | Formato | Responsabile Nominale | Predecessori | Durata Prod. | Buffer Check | Data Rilascio Shared | Stato |
| :--- | :--- | :---: | :---: | :--- | :---: | :---: | :---: | :---: | :---: |
| `ED01-STR-MOD-0001` | Modello Fondazioni c.a. | G3/D3/Doc2 | IFC4 | Ing. M. Neri | `ED01-ARC-MOD-0001` | 15 gg | 3 gg | 18/04/2026 | In Corso |
| `ED01-STR-MOD-0002` | Modello Elevazioni c.a. | G3/D3/Doc2 | IFC4 | Ing. M. Neri | `ED01-STR-MOD-0001` | 20 gg | 4 gg | 12/05/2026 | Pianificato |
| `ED01-STR-REL-0001` | Relazione di Calcolo Strutturale | — | PDF/A | Ing. R. Galli | `ED01-STR-MOD-0002` | 10 gg | 3 gg | 25/05/2026 | Pianificato |

---

### Fase 2: Consolidamento nel MIDP (Lead Appointed Party)

L'Information Manager / BIM Manager dell'Affidatario acquisisce tutti i TIDP e procede all'aggregazione federata:

1. **Verifica della Completezza**: nessun deliverable richiesto dal Capitolato Informativo (CI) deve mancare all'appello;
2. **Riconciliazione delle Dipendenze Incrociate**:
   - Se il TIDP Impianti prevede di iniziare la modellazione dei cavedi il 10/05, ma il TIDP Strutture rilascia il modello dei solai solo il 15/05, si genera un conflitto di precedenza che va immediatamente corretto;
3. **Assegnazione ai Gate dell'ACDat e Milestone Contrattuali**:
   - Ogni riga del MIDP viene agganciata al gate di progetto formale (Milestone 1, Milestone 2, Validazione Progetto Esecutivo, SAL 1 di cantiere);
4. **Inclusione dei Tempi di Revisione della Committente**:
   - Riservare la finestra temporale formale contrattualizzata (es. 15 giorni lavorativi) per l'istruttoria e il visto di approvazione della Stazione Appaltante (passaggio da Shared a Published).

##### Esempio MIDP Consolidato di Commessa (Estratto Master):

| ID Deliverable | Titolo Contenitore | Disciplina | Task Team | Formato | Data Shared | Gate ACDat | Milestone Contrattuale | Codice Idoneità Previsto |
| :--- | :--- | :---: | :--- | :---: | :---: | :---: | :---: | :---: |
| `ED01-ARC-MOD-0001` | Modello Involucro Architettonico | ARC | Studio Architettura | IFC4 | 10/04/2026 | Gate 1 (Shared) | Consegna PE 30% | `S2` (Coordinamento) |
| `ED01-STR-MOD-0001` | Modello Strutturale Fondazioni | STR | Ingegneria Strutture | IFC4 | 18/04/2026 | Gate 1 (Shared) | Consegna PE 30% | `S2` (Coordinamento) |
| `ED01-MEP-MOD-0001` | Modello Centrale Termica | MEP | Studio Termotecnico | IFC4 | 28/04/2026 | Gate 1 (Shared) | Consegna PE 30% | `S2` (Coordinamento) |
| `ED01-FED-REP-0001` | Report di Coordinamento e BCF | COORD | BIM Management | BCF+PDF | 05/05/2026 | Gate 2 (Federazione)| Consegna PE 60% | `S3` (Revisione Interna) |
| `ED01-GEN-MOD-FED01` | Modello Federato Coordinato | ALL | Mandataria RTI | IFC4 | 20/05/2026 | Gate 3 (Published)  | Validazione Finale PE | `A` (Approvato per Gara/Lav) |

---

### Fase 3: Monitoraggio Dinamico e Gestione dei Ritardi

Il MIDP non è un documento statico. Deve essere monitorato con cadenza settimanale attraverso il calcolo del **Delivery Variance Index (DVI)**:

$$\text{DVI} = \frac{\text{Consegne Effettuate in Tempo entro la Data Target}}{\text{Totale Consegne Pianificate per la Data Target}} \times 100$$

- **DVI $\ge 95\%$**: Flusso regolare, nessun allarme;
- **$80\% \le \text{DVI} < 95\%$**: Allerta media: attivazione del BIM Coordinator per accelerare i task in ritardo;
- **DVI $< 80\%$**: Criticità grave: convocazione d'urgenza dell'ICE meeting con i responsabili dei singoli Task Team e rimodulazione concordata dei predecessori.

---

## Anti-pattern nell'Information Delivery Planning

| Errore Tipico | Conseguenza di Cantiere/Progetto | Procedura Corretta |
| :--- | :--- | :--- |
| **MIDP redatto dall'alto senza consultare i Task Team** | **Piani irrealistici**, scadenze mancate e rifiuto di responsabilità da parte dei modellatori | Il MIDP deve nascere dal basso aggregando i TIDP redatti dai rispettivi specialisti disciplinari. |
| **Ignorare il buffer di verifica interna nei TIDP** | **Caricamento di modelli grezzi o con clash gravi** nell'area Shared dell'ACDat | Prevedere sempre 2-4 giorni lavorativi di buffer per l'autocontrollo e la verifica interna del BIM Coordinator. |
| **MIDP con sole date di consegna finale (senza date di condivisione)** | **Impossibilità di eseguire il coordinamento interdisciplinare** prima del rilascio ufficiale | Distinguere chiaramente la data di rilascio in `Shared` (per clash) dalla data di emissione in `Published` (per SA). |
| **Omettere i deliverable documentali e computistici** | **Disallineamento tra modelli 3D e computi metrici/relazioni** | Il TIDP e il MIDP devono contenere tutti i container informativi: modelli IFC, relazioni PDF/A, computi e report BCF. |
| **Non tracciare le dipendenze tra discipline** | **Blocco improvviso di interi gruppi di lavoro** in attesa di informazioni da altri team | Esplicitare obbligatoriamente i predecessori per ciascun deliverable per evidenziare il percorso critico informativo. |

---

## Output Strutturato

Quando invocata, la skill genera:
1. **Template e Matrice TIDP Disciplinare** (compilabile dal singolo Task Team).
2. **Master Information Delivery Plan (MIDP) Federato** (strutturato con ID, date solari, LOIN e codici di idoneità).
3. **Diagramma delle Dipendenze Interdisciplinari** (evidenziazione del percorso critico informativo).
4. **Dashboard di Monitoraggio DVI** per il controllo dell'avanzamento settimanale delle consegne.

---

## Limiti

- La pianificazione MIDP/TIDP governa la produzione informativa: eventuali ritardi dovuti a cause esterne (mancato rilascio di pareri da enti terzi, modifiche sostanziali del quadro esigenziale della SA) richiedono una formale sospensione o proroga dei termini contrattuali concordata con il RUP.
