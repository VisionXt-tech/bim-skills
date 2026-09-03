---
name: pgi-consolidation
description: >-
  Trasformazione dell'Offerta di Gestione Informativa (oGI) in Piano di Gestione Informativa (pGI) BIM operativo
  post-aggiudicazione secondo D.Lgs. 36/2023 Allegato I.9, D.Lgs. 209/2024, ISO 19650-2 e UNI 11337-5.
  Usare per consolidare il post-appointment BEP, sciogliere le riserve di gara, strutturare matrici MIDP/TIDP e allineare
  le obbligazioni contrattuali informative prima dell'avvio dell'esecuzione.
---

# BIM Piano di Gestione Informativa (pGI) — Consolidation & Delivery Alignment

Assistente specialistico per la trasformazione e il consolidamento dell'**Offerta di Gestione Informativa (oGI)** presentata in gara nel **Piano di Gestione Informativa (pGI)** operativo post-aggiudicazione, in conformità al Codice dei Contratti Pubblici (**D.Lgs. 36/2023** coordinato con il **D.Lgs. 209/2024**), all'**Allegato I.9 (Art. 10 e 11)**, alla norma **UNI 11337-5**, allo standard internazionale **UNI EN ISO 19650-2** e alle matrici **MIDP/TIDP**.

---

## Scope

Questa skill guida il BIM Manager dell'Affidatario (e supporta il BIM Manager della Stazione Appaltante e il RUP) nelle seguenti attività:
- **Consolidamento contrattuale dell'oGI in pGI**: conversione degli impegni metodologici e delle migliorie premiate in gara in specifiche obbligazioni operative vincolanti.
- **Riconciliazione e scioglimento delle riserve di gara**: recepimento delle prescrizioni e dei chiarimenti richiesti dalla Commissione Giudicatrice nel verbale di aggiudicazione.
- **Nomina formale dell'organigramma operativo**: sostituzione dei profili generici con i nominativi effettivi, contatti, credenziali e certificazioni **UNI/PdR 78:2020** verificate per le 4 figure normate (UNI 11337-7).
- **Costruzione del Master Information Delivery Plan (MIDP)** e dei **Task Information Delivery Plan (TIDP)**: pianificazione analitica di tutti i deliverable informativi, dei formati aperti (IFC4, BCF, PDF/A) e delle date di rilascio allineate al cronoprogramma contrattuale.
- **Operazionalizzazione dell'ACDat di commessa**: configurazione della tassonomia di cartelle, stati dei container (`WIP`, `Shared`, `Published`, `Archive`), codici di idoneità (`S1-S4`, `A`, `B`), permessi di accesso per ruolo e politiche di backup/cyber security.
- **Definizione del piano di Quality Assurance e KPI informativi**: regole di validazione automatica dei modelli, tolleranze di clash detection, tempi di risoluzione delle interferenze e gestione delle non conformità (NCR).
- **Audit di conformità e approvazione formale del pGI**: procedura di verifica e visto di approvazione da parte del RUP / Coordinatore dei Flussi Informativi della SA prima dell'avvio delle attività.

---

## NON fa

- Non redige il contratto d'appalto o gli atti di sottomissione (attività riservata all'ufficio contratti e al RUP).
- Non autorizza modifiche unilaterali peggiorative rispetto all'oGI approvata in sede di gara (costituirebbe violazione contrattuale e danno erariale).
- Non sostituisce la Direzione Lavori o il Coordinatore dei Flussi Informativi nella verifica continuativa dei SAL informativi.
- Non redige la Relazione Specialistica Finale di conformità al CI (atto conclusivo redatto in fase di collaudo ex art. 11 All. I.9).

---

## Normativa di Riferimento

1. **D.Lgs. 36/2023 & D.Lgs. 209/2024 (Decreto Correttivo)**:
   - **Art. 43**: Gestione informativa digitale obbligatoria sopra i 2.000.000 €;
   - **Allegato I.9, Art. 10 (Regole di affidamento e pGI)**:
     - L'aggiudicatario redige il **Piano di Gestione Informativa (pGI)** sulla base dell'oGI approvata in gara;
     - Il pGI va sottoposto formalmente alla Stazione Appaltante dopo la stipula del contratto e prima dell'avvio dell'esecuzione delle prestazioni;
     - Il pGI è un documento dinamico, aggiornabile durante l'esecuzione dell'appalto previo accordo scritto tra le parti;
     - La trasmissione dei modelli e la gestione del pGI avvengono obbligatoriamente all'interno dell'ACDat.
   - **Allegato I.9, Art. 11 (Esecuzione, direzione e collaudo digitale)**:
     - Coordinamento e controllo esecutivo tramite metodi digitali;
     - Se la direzione lavori non dispone internamente delle competenze digitali, la SA nomina un **Coordinatore dei Flussi Informativi** dedicato;
     - In sede di collaudo l'appaltatore consegna i modelli as-built e una relazione specialistica di attestazione della piena rispondenza al Capitolato Informativo.
2. **UNI EN ISO 19650-2 (Fase di consegna dei cespiti immobili)**:
   - Il pGI costituisce il **post-appointment BEP (BIM Execution Plan)**;
   - Clausola 5.4: Conferma e consolidamento del BEP, del piano di mobilitazione delle risorse e della matrice di assegnazione delle responsabilità (RACI);
   - Clausole 5.4.4 e 5.4.5: Strutturazione formale dei **TIDP** (piani di consegna dei singoli task team) e loro aggregazione nel **MIDP** generale di commessa gestito dal Lead Appointed Party.
3. **UNI 11337 (Gestione digitale dei processi informativi)**:
   - **Parte 5**: Struttura dettagliata del pGI (Sezione tecnica, gestionale ed economica di processo);
   - **Parte 7 e UNI/PdR 78:2020**: Requisiti formali per le figure di CDE Manager, BIM Manager, BIM Coordinator e BIM Specialist.

---

## Workflow Operativo di Consolidamento

### Fase 1: Riconciliazione Documentale e Matrice di Tracciabilità

1. **Acquisizione Documenti Fondativi**:
   - Capitolato Informativo (CI) di gara;
   - Offerta di Gestione Informativa (oGI) del concorrente risultato aggiudicatario;
   - Verbale della Commissione Giudicatrice (con punteggi, motivazioni ed eventuali prescrizioni/riserve);
   - Contratto d'appalto sottoscritto con cronoprogramma generale e date contrattuali vincolanti.
2. **Costruzione della Matrice di Riconciliazione (CI $\rightarrow$ oGI $\rightarrow$ pGI)**:
   - Mappare ciascun requisito del CI e ciascun impegno premiale dell'oGI nella corrispondente clausola attuativa del pGI.
   - *Regola inderogabile:* Nessun impegno premiale assunto nell'oGI (es. sessioni di coordinamento settimanali, protocolli di sicurezza avanzati, attributi CAM) può essere eliminato o ridotto nel pGI, a pena di inadempimento contrattuale.
   - Trattare punto per punto le riserve espresse dalla Commissione Giudicatrice, fornendo nel pGI la soluzione tecnica definitiva.

---

### Fase 2: Redazione del pGI Operativo (Struttura in 10 Sezioni)

Il documento consolidato deve articolarsi nelle seguenti sezioni operative:

#### 1. Informazioni Generali e Riferimenti Contrattuali
- Committente, RUP, Direttore dei Lavori / Coordinatore dei Flussi Informativi della SA;
- Aggiudicatario (ragione sociale, mandataria/mandanti in caso di RTI o consorzio);
- Oggetto della commessa, CIG, CUP, data stipula contratto, data consegna prestazioni.

#### 2. Organigramma Nominativo e Matrice delle Responsabilità (RACI)
- Sostituzione di ogni dicitura generica con **nomi e cognomi, ruoli formali, indirizzi PEC, numeri di cellulare e certificati**:
  - **BIM Manager di Commessa**: nominativo e certificazione UNI/PdR 78:2020 (allegato certificato in corso di validità);
  - **CDE Manager di Commessa**: nominativo e credenziali di amministrazione ACDat;
  - **BIM Coordinator Architettonico, Strutturale e Impiantistico**: nominativi e relative aree disciplinari;
  - **BIM Specialist**: elenco degli operatori operativi per ciascun task team / fornitore.
- Matrice RACI (Responsible, Accountable, Consulted, Informed) per ogni tipologia di attività informativa (creazione modello, esportazione IFC, clash check, caricamento ACDat, validazione).

#### 3. Infrastruttura Software e Ambito di Modellazione
- Software di authoring adottati per ciascuna disciplina con indicazione della release esatta (es. *Revit 2025.2, Tekla Structures 2024, Archicad 28*): nessun cambio di versione software consentito a commessa avviata senza autorizzazione del CDE Manager della SA;
- Piattaforme di coordinamento e model checking (es. *Solibri, Navisworks Manage, Bimplus, Revizto*);
- Software di authoring computi e cronoprogrammi (es. *STR Vision CPM, Primus, Primavera P6, Microsoft Project*).

#### 4. Disciplinare Operativo dell'ACDat (CDE)
- Piattaforma adottata e credenziali/URL di accesso per la SA e gli organi di vigilanza;
- Albero delle cartelle operativo e segregazione delle autorizzazioni (lettura, scrittura, amministrazione);
- Workflow degli stati dei container conforme a ISO 19650-1 e UNI 11337-5:
  - `WIP` (Lavorazione interna del singolo specialista);
  - `Shared` (Condivisione per coordinamento interdisciplinare - Codici di idoneità da S1 a S4);
  - `Published` (Rilascio ufficiale per approvazione SA, autorizzazioni o SAL - Codici A e B);
  - `Archive` (Stato congelato e tracciamento storico non modificabile).
- Pattern di nomenclatura rigoroso:
  - `[COMMESSA]-[AUTORE]-[ZONA]-[LIVELLO]-[DISCIPLINA]-[TIPO]-[PROGR]-[REV].[EXT]`
  - Esempio: `OSPEDALE-STRUTTURE-BLOCSOA-P02-STR-MOD-0002-R01.ifc`
- Politiche di backup giornaliero incrementale, replica geografica e disaster recovery certificato ISO 27001.

#### 5. Strategia di Federazione e Sistema di Coordinate Condiviso
- Punto di origine globale, coordinate geografiche (es. UTM WGS84 o Gauss-Boaga), quota assoluta s.l.m. e angolo di rotazione rispetto al Nord reale;
- Punto di controllo condiviso (Shared Coordinate System) validato fisicamente su tutti i modelli prima dell'avvio della modellazione dettagliata (evita lo slittamento spaziale dei modelli federati);
- Strategia di suddivisione spaziale e volumetrica dei modelli (`IfcSite`, `IfcBuilding`, `IfcBuildingStorey`).

#### 6. Declinazione Operativa dei LOIN e Proprietà IFC
- Recepimento della matrice LOIN del CI integrata con i requisiti esecutivi di dettaglio;
- Elenco dettagliato dei Property Set obbligatori:
  - Property set standard IFC (`Pset_BeamCommon`, `Pset_WallCommon`, ecc.);
  - Property set specifici della SA (`Pset_SA_Anagrafica`, `Pset_SA_CAM`, `Pset_SA_Manutenzione`);
- Mappatura puntuale del sistema di classificazione (UNI 8290 a 3 livelli o Uniclass 2015) valorizzato nel parametro `IfcClassificationReference`.

#### 7. Workflow di Coordinamento e Risoluzione Interferenze (Clash Detection)
- Matrice delle priorità e delle tolleranze geometriche:

| Tipologia di Conflitto | Discipline Coinvolte | Tolleranza Severa (Hard Clash) | Tolleranza Moderata | Azione Richiesta |
| :--- | :--- | :---: | :---: | :--- |
| **Strutture vs Impianti** | `STR` vs `MEP` | **$\Delta \le 10$ mm** | $10 < \Delta \le 50$ mm | Creazione foro strutturale approvato da ingegnere strutturista |
| **Architettura vs Impianti** | `ARC` vs `MEP` | **$\Delta \le 15$ mm** | $15 < \Delta \le 30$ mm | Spostamento percorso condotta o abbassamento controsoffitto |
| **Impianti vs Impianti** | `MEP_MECC` vs `MEP_ELET` | **$\Delta \le 20$ mm** | $20 < \Delta \le 50$ mm | Risoluzione prioritaria al condotto con pendenza a gravità |
| **Clearance Manutenzione** | Apparecchio vs Ostacoli | **$D < D_{\min}$ (catalogo)** | — | Riposizionamento obbligatorio per garantire accessibilità |

- Frequenza degli ICE (Integrated Concurrent Engineering) meetings (es. settimanali);
- Gestione dei report di interferenza tramite standard aperto **BCF (BIM Collaboration Format)** versione XML 2.1 o API REST integrata su ACDat con tracciamento dello stato (`Open`, `Assigned`, `Resolved`, `Closed`).

#### 8. Master Information Delivery Plan (MIDP) e Matrice TIDP
- Aggregazione dei TIDP di ciascuna disciplina in un unico registro centralizzato:

| ID Consegna | Titolo Deliverable | Disciplina | Task Team Responsabile | Formato Primario | Formato Ausiliario | Milestone Contrattuale | Data Rilascio | Dipendenze |
| :--- | :--- | :---: | :--- | :---: | :---: | :---: | :---: | :--- |
| `DEL-ARC-01` | Modello Architettonico Involucro | ARC | Studio Rossi Arch. | IFC4 | PDF/A (Tavole) | Milestone 1 (30% PE) | 15/04/2026 | — |
| `DEL-STR-01` | Modello Strutturale Fondazioni/Elev. | STR | Bianchi Engineering | IFC4 | PDF/A (Relazioni) | Milestone 1 (30% PE) | 22/04/2026 | `DEL-ARC-01` |
| `DEL-MEP-01` | Modello Impianti Meccanici | MEP | Termotecnica Srl | IFC4 | PDF/A (Schemi) | Milestone 2 (60% PE) | 10/05/2026 | `DEL-STR-01` |
| `DEL-FED-01` | Modello Federato e Report BCF | COORD | BIM Manager Affidatario | IFC4 + BCF | Report PDF/A | Milestone 2 (60% PE) | 20/05/2026 | `DEL-MEP-01` |

#### 9. Gestione della Qualità, KPI Informativi e Non Conformità (NCR)
- KPI quantitativi di accettazione delle consegne all'interno dell'ACDat:
  - **KPI-1 (Completezza Parametrica)**: $\ge 98\%$ degli elementi IFC valorizzati con i parametri obbligatori del pset di riferimento;
  - **KPI-2 (Clash severi residui)**: 0 hard clash non gestiti tra strutture e impianti principali al gate Published;
  - **KPI-3 (Puntualità Consegne MIDP)**: scostamento temporale $\le 3$ giorni lavorativi rispetto alla data pianificata;
  - **KPI-4 (Accuratezza Nomenclatura)**: $100\%$ conformità al pattern UNI 11337-5 verificata da script automatico.
- Procedura di emissione di Non-Conformance Report (NCR): classificazione in Minore (risoluzione entro 5 gg) e Maggiore (blocco del gate di transizione a Published).

#### 10. Processo di Aggiornamento del pGI
- Modalità di revisione dinamica durante l'appalto (in occasione di perizie di variante, modifiche dell'organigramma o slittamenti autorizzati del cronoprogramma generale);
- Tracciamento della tabella delle revisioni del pGI con approvazione formale congiunta (firma del RUP e del Legale Rappresentante dell'Affidatario).

---

## Checklist di Approvazione del pGI per la Stazione Appaltante

Il BIM Manager della SA e il RUP verificano il pGI prima dell'approvazione formale:

- [ ] **Coerenza al 100% con il CI**: nessun requisito del capitolato originale è stato omesso o declassato.
- [ ] **Recepimento di tutte le migliorie dell'oGI**: tutte le proposte premiate dalla Commissione Giudicatrice sono tradotte in specifiche operative concrete.
- [ ] **Scioglimento delle riserve**: tutte le osservazioni e riserve formulate dalla Commissione nel verbale di gara risultano risolte ed esplicitate.
- [ ] **Organigramma nominativo completo**: indicati nomi, contatti e verificate le certificazioni UNI/PdR 78:2020 con organismi accreditati Accredia per i ruoli chiave.
- [ ] **MIDP allineato al cronoprogramma lavori**: le date del registro di consegna informativa sono perfettamente coerenti con le scadenze del contratto d'appalto.
- [ ] **TIDP integrati**: ogni task team specialistico dispone di un piano di consegna riconducibile al MIDP generale (nessuna consegna orfana).
- [ ] **Regole ACDat operative conformi**: stati ISO 19650, matrice dei permessi, crittografia e server UE conformi a UNI 11337-5 e GDPR.
- [ ] **Protocollo BCF e Clash Detection definito**: specificate le tolleranze numeriche e le regole di ingaggio per gli ICE meeting.
- [ ] **KPI e penali informative chiariti**: definite le metriche di accettazione dei deliverable e la gestione delle non conformità.

---

## Anti-pattern nel Consolidamento del pGI

| Errore Tipico nel pGI | Conseguenza Operativa/Contrattuale | Correzione Obbligatoria |
| :--- | :--- | :--- |
| **Riutilizzare l'oGI semplicemente cambiandole il titolo in pGI** | **Rigetto del pGI da parte della SA** per mancata operatività e mancanza di nominativi reali | Il pGI deve trasformare le intenzioni di gara in dettagli esecutivi (nomi, software, tolleranze, date certe). |
| **Omettere migliorie promesse in gara per risparmiare costi** | **Grave inadempimento contrattuale** (frode nelle pubbliche forniture / danno erariale) | Tutti gli elementi dell'oGI che hanno concorso al punteggio premiale sono vincolanti e devono figurare nel pGI. |
| **MIDP con date generiche ("Mese 1", "Settimana 4")** | **Impossibilità di monitorare le scadenze e applicare penali** | Il MIDP deve contenere date solari effettive (`GG/MM/AAAA`) allineate al cronoprogramma contrattuale. |
| **Lasciare i TIDP disallineati rispetto al MIDP** | **Sovrapposizioni, ritardi e consegne non tracciate** | Il Lead Appointed Party deve garantire che la somma dei TIDP disciplinari corrisponda esattamente al MIDP federato. |
| **Modificare la nomenclatura dei file rispetto a quanto richiesto dal CI** | **Incompatibilità con i sistemi di archiviazione della SA** | Il pGI deve rispettare rigidamente la codifica file e i metadati imposti dal CI (UNI 11337-5). |
| **Considerare il pGI come un documento statico immutabile** | **Obsolescenza immediata del pGI al primo imprevisto di cantiere** | Il pGI deve contenere la procedura formale di revisione periodica (`Rev. 00`, `Rev. 01`...) concordata col RUP. |

---

## Output

Quando invocata per il consolidamento o la verifica, la skill genera:
1. **Matrice di Riconciliazione CI $\rightarrow$ oGI $\rightarrow$ pGI** (con evidenza delle migliorie e delle riserve sciolte).
2. **Documento pGI Consolidato Completo** articolato nelle 10 sezioni operative conformi a UNI 11337-5 e ISO 19650-2.
3. **Master Information Delivery Plan (MIDP)** in formato tabellare strutturato.
4. **Verbale di Approvazione Formale del pGI** pronto per la firma congiunta del RUP e del BIM Manager dell'Affidatario.

---

## Limiti

- La skill fornisce il quadro tecnico-gestionale completo ma non redige atti di modifica contrattuale (perizie di variante o addendum al contratto d'appalto), che restano di competenza del RUP.
- Le nomine dei professionisti e i relativi certificati UNI/PdR 78:2020 devono essere verificati dal RUP sui registri ufficiali degli organismi di certificazione accreditati prima dell'approvazione del documento.
