---
name: information-protocol
description: >-
  Definizione, redazione e controllo del Protocollo Informativo BIM di commessa secondo ISO 19650-1/2, ISO 19650-5,
  D.Lgs. 36/2023 Allegato I.9 e UNI 11337-5. Usare per recepire gli obblighi informativi nel contratto, disciplinare
  la prevalenza documentale, la proprieta intellettuale (IPR), le responsabilita di modellazione, la sicurezza dei dati e il GDPR.
---

# BIM Protocollo Informativo di Commessa — Information Protocol & Contractual Governance

Assistente specialistico per la redazione, negoziazione e controllo del **Protocollo Informativo di Commessa (*Information Protocol*)**, lo strumento contrattuale integrativo che formalizza e rende legalmente vincolanti gli obblighi di gestione informativa digitale tra Committente, Lead Appointed Party (Affidatario) e Sub-affidatari / Task Team, in conformità agli standard internazionali **UNI EN ISO 19650-1/2**, **ISO 19650-5 (Security)**, al Codice dei Contratti Pubblici (**D.Lgs. 36/2023** e **D.Lgs. 209/2024** - Allegato I.9) e al quadro normativo italiano sul diritto d'autore e sul **GDPR (Reg. UE 2016/679)**.

---

## Scope

Questa skill supporta il BIM Manager, il Legal Counsel e il Project Manager nelle seguenti attività:
- **Redazione del Protocollo Informativo contrattuale**: redazione dello schema di patto accessorio (*Information Schedule*) da allegare al contratto principale di appalto o ai contratti di sub-affidamento/consulenza specialistica.
- **Definizione dell'Ordine di Prevalenza Documentale**: regolamentazione del valore probatorio e della gerarchia giuridica tra modelli informativi digitali (IFC/nativi), elaborati grafici 2D (tavole PDF/A), relazioni specialistiche e computi metrici estimativi in caso di contrasto o incongruenza.
- **Disciplina della Proprietà Intellettuale (IPR) e Licenze d'Uso**: regolamentazione dei diritti di autore sui modelli, sulle librerie parametriche proprietarie e concessione della licenza d'uso perpetua e trasferibile a favore della Stazione Appaltante per le finalità di gestione e manutenzione del cespite.
- **Limitazione di Responsabilità e Usi Autorizzati (*Authorized Uses*)**: delimitazione della responsabilità dell'autore del modello all'uso conforme ai livelli LOIN concordati, escludendo responsabilità per usi impropri o per alterazioni successive apportate da terzi non autorizzati.
- **Governance dell'ACDat e Livelli di Servizio (SLA)**: obbligazioni contrattuali relative a tempi di caricamento, disponibilità della piattaforma cloud ($\ge 99.5\%$), backup immutabile e continuità operativa (disaster recovery).
- **Conformità alla Cyber Security e alla Protezione Dati Personali (GDPR & ISO 19650-5)**: clausole per la nomina a Responsabile del Trattamento (Art. 28 GDPR) per i gestori ACDat, vincolo di residenza dei dati nello Spazio Economico Europeo (SEE) e tracciamento immutabile degli accessi.
- **Regime delle Penali Informative e Risoluzione**: definizione di penali specifiche per ritardi ingiustificati nelle consegne rispetto al MIDP o per reiterata mancata risoluzione delle non conformità (NCR) e dei clash gravi.

---

## NON fa

- Non sostituisce il contratto d'appalto generale redatto ai sensi del Codice Civile e del Codice dei Contratti Pubblici.
- Non redige clausole fiscali, assicurative generali o societarie (attività riservata a legali e commercialisti).
- Non risolve contenziosi giudiziari o perizie legali di parte (CTU / CTP).

---

## Normativa e Standard di Riferimento

1. **UNI EN ISO 19650-1 & 19650-2**:
   - **Clausola 5.1.8 & 5.4.6**: Obbligo di incorporare un Information Protocol negli accordi di incarico (*appointments*) sia tra committente e affidatario principale, sia a cascata tra affidatario principale e sub-affidatari.
   - *Modello di riferimento internazionale:* UK BIM Framework Information Protocol to support BS EN ISO 19650-2.
2. **ISO 19650-5:2020**:
   - Gestione della sicurezza delle informazioni sensibili e dei cespiti critici (security-minded approach).
3. **D.Lgs. 36/2023 & D.Lgs. 209/2024 (Allegato I.9)**:
   - **Art. 4-5**: Ambiente di condivisione dati e interoperabilità su formati aperti non proprietari (IFC - ISO 16739-1);
   - **Art. 10-11**: Esecuzione, direzione dei lavori digitale e rispetto contrattuale del CI.
4. **Legge 22 aprile 1941, n. 633 (Protezione del diritto d'autore)**:
   - Tutela delle opere dell'ingegno, dei progetti di ingegneria e architettura e delle banche dati digitali.
5. **Regolamento UE 2016/679 (GDPR)**:
   - Artt. 5, 25 (Privacy by Design e by Default), 28 (Responsabile del Trattamento) e 32 (Sicurezza del trattamento).

---

## Struttura Tipica dell'Information Protocol (Modello Contrattuale)

Il Protocollo Informativo operativo si articola nei seguenti articoli fondamentali:

### Articolo 1 — Definizioni e Documenti Contrattuali di Riferimento
- Richiamo esplicito a Capitolato Informativo (CI), Offerta di Gestione Informativa (oGI), Piano di Gestione Informativa (pGI approvato) e Master Information Delivery Plan (MIDP);
- **Clausola di Ordine di Prevalenza**:
  > *"In caso di contrasto, discordanza o incongruenza tra le informazioni contenute nei modelli informativi digitali e gli elaborati grafici bidimensionali o relazioni cartacee/PDF, salvo diversa espressa pattuizione scritta nel Capitolato Informativo, prevarrà la seguente gerarchia: (1) Contratto d'Appalto; (2) Capitolato Informativo; (3) Elaborati grafici e relazioni tecniche 2D ufficialmente firmati digitalmente; (4) Modelli informativi digitali IFC conformi al livello LOIN prescritto."*

### Articolo 2 — Tabella "Information Particulars" (Dati di Commessa)
Tabella sintetica iniziale che ancora il protocollo all'appalto:

| Parametro Contrattuale | Dettaglio di Commessa |
| :--- | :--- |
| **Committente / Appointing Party** | [Stazione Appaltante / Ente Concedente] |
| **Affidatario Principale / Lead Appointed Party** | [Ragione Sociale Appaltatore / Mandataria RTI] |
| **Sub-affidatari / Appointed Parties** | [Elenco Task Team Specialistici e Consulenti] |
| **Piattaforma ACDat Ufficiale** | [Nome Piattaforma Cloud, URL di accesso, Provider, Localizzazione Server UE] |
| **BIM Manager della Committente** | [Nome, Cognome, PEC, Certificazione UNI/PdR 78:2020] |
| **BIM Manager dell'Affidatario** | [Nome, Cognome, PEC, Certificazione UNI/PdR 78:2020] |
| **Normativa Tecnica Applicata** | UNI EN ISO 19650-1/2, UNI 11337 (Parti 1-7), UNI EN 17412-1 |

### Articolo 3 — Obblighi Informativi e Flusso di Consegna (MIDP)
- Obbligo di ciascun task team di rispettare le date e i requisiti LOIN stabiliti nel MIDP e nel proprio TIDP;
- Obbligo di esecuzione dei controlli di qualità e validazione interna (WIP check) prima di condividere qualsiasi contenitore nell'area Shared dell'ACDat;
- Partecipazione obbligatoria dei coordinatori disciplinari agli ICE (Integrated Concurrent Engineering) meeting settimanali/quindicinali per la risoluzione delle interferenze (Clash Detection).

### Articolo 4 — Diritti di Proprietà Intellettuale (IPR) e Licenze
- **Titolarità dei Modelli e degli Oggetti**:
  - Ciascun task team conserva la proprietà intellettuale sui propri modelli originali, sul codice di scripting e sulle librerie di oggetti parametrici sviluppate indipendentemente (*Background IPR*);
  - Le informazioni, i dati specifici e i modelli realizzati specificamente per la commessa (*Foreground IPR*) formano oggetto di licenza d'uso esclusiva, irrevocabile e trasferibile a favore della Stazione Appaltante;
- **Finalità della Licenza d'Uso**:
  - La Stazione Appaltante ha il diritto pieno di utilizzare, duplicare, modificare e trasmettere a terzi i modelli informativi per le finalità di costruzione, collaudo, esercizio, manutenzione ordinaria e straordinaria (AIM / Facility Management) e successiva dismissione dell'opera;
  - È vietato l'uso dei modelli per opere diverse da quella oggetto del presente appalto senza il consenso scritto dei progettisti autori.

### Articolo 5 — Usi Autorizzati e Limitazione di Responsabilità (*Authorized Uses*)
- L'autore di ciascun contenitore informativo risponde della correttezza e affidabilità dei dati **esclusivamente** nei limiti del livello di fabbisogno informativo (**LOIN**) prescritto per la specifica fase di consegna (es. un modello a livello volumetrico PFTE non può essere utilizzato per ordinare armature o calcolare tolleranze millimetriche);
- **Esonero di Responsabilità per Manomissione**:
  - L'autore è manlevato da qualsiasi responsabilità per errori, danni o costi derivanti da manomissioni, modifiche o estrazioni eseguite da soggetti terzi dopo il caricamento nell'area Published o dopo il rilascio ufficiale del file aperto IFC4 certificato;
- In caso di conversione automatica di formati eseguita dalla piattaforma ACDat o da terzi, fa fede esclusivamente il file originario firmato digitalmente dall'autore.

### Articolo 6 — Sicurezza, Cyber Security e Protezione dei Dati Personali (GDPR)
- **Sicurezza dell'ACDat (ISO 19650-5)**:
  - Obbligo di autenticazione a due fattori (MFA) per tutti gli account operativi;
  - Cifratura end-to-end con algoritmo minimo AES-256 e protocollo TLS 1.3 in transito;
  - Divieto assoluto di memorizzare dati di commessa su server o cloud localizzati al di fuori dello Spazio Economico Europeo (SEE) senza adeguate clausole tipo UE;
- **Trattamento Dati Personali (GDPR - Reg. UE 2016/679)**:
  - Nomina formale del Gestore dell'ACDat a Responsabile del Trattamento (Art. 28 GDPR);
  - Registrazione immutabile dei log di accesso e tracciamento delle modifiche (audit log non alterabile);
  - Anonimizzazione o pseudonimizzazione di eventuali dati personali non strettamente necessari (es. orari di ingresso in cantiere collegati a nominativi di maestranze).

### Articolo 7 — Livelli di Servizio (SLA) dell'Ambiente Dati e Continuità Operativa
- Garantire una disponibilità della piattaforma ACDat cloud $\ge 99.5\%$ su base mensile, con esclusione delle finestre di manutenzione programmata comunicate con almeno 48 ore di preavviso;
- Obbligo di backup giornaliero incrementale e settimanale completo, conservato in modalità geograficamente ridondata;
- Procedura di restituzione integrale di tutti i modelli, documenti, metadati e registri di log storici alla Stazione Appaltante al termine della commessa in formato aperto nativo e non proprietario.

### Articolo 8 — Regime delle Penali Informative
L'inadempimento delle obbligazioni informative comporta l'applicazione di specifiche penali contrattuali:
1. **Ritardo nelle Consegne MIDP**: applicazione di una penale giornaliera (es. 0,5 per mille dell'importo contrattuale per ogni giorno di ritardo non giustificato rispetto alle date target del MIDP);
2. **Mancata Partecipazione agli ICE Meeting**: penale forfettaria per ogni assenza non motivata del BIM Coordinator designato;
3. **Mancata Risoluzione delle Non Conformità (NCR) Gravi**: penale progressiva in caso di mancata risoluzione dei clash severi entro il termine stabilito (SLA di 5-10 giorni lavorativi).

### Articolo 9 — Risoluzione Rapida delle Controversie Informative
- In caso di controversia tecnica relativa a interferenze di modellazione, titolarità dei dati o conformità LOIN, le parti demandano la decisione tecnica in prima istanza a un **Collegio Tecnico Informativo** composto dal BIM Manager della SA e dal BIM Manager dell'Affidatario, che si pronuncia entro 10 giorni lavorativi prima di attivare le tutele giudiziarie ordinarie.

---

## Anti-pattern Contrattuali da Evitare

| Errore Tipico nel Protocollo | Rischio Contrattuale / Giudiziario | Soluzione Corretta |
| :--- | :--- | :--- |
| **Non definire l'ordine di prevalenza tra 2D e modelli** | **Blocco del cantiere in caso di divergenza geometrica** tra tavola PDF e modello IFC | Specificare sempre la gerarchia contrattuale nell'Articolo 1 del protocollo. |
| **Cedere indiscriminatamente tutti i diritti d'autore alla SA** | **Rifiuto di firma dei sub-affidatari** per perdita di know-how e dettagli di libreria proprietari | Distinguere tra Background IPR (di proprietà del progettista/produttore) e Foreground IPR (in licenza d'uso alla SA). |
| **Omettere la clausola di Authorized Uses / LOIN** | **Esposizione illimitata dell'autore** a richieste di risarcimento per uso improprio del modello | Limitare la garanzia informativa agli usi esplicitamente previsti dal livello LOIN della specifica milestone. |
| **Server ACDat localizzati in paesi extra-UE non sicuri** | **Violazione grave del GDPR (sanzioni fino al 4% del fatturato)** e invalidità dell'appalto | Vincolare il fornitore dell'ACDat all'hosting all'interno del SEE o a conformità certificata. |
| **Nessuna penale per ritardi MIDP** | **I deliverable BIM vengono subordinati** e consegnati con mesi di ritardo rispetto alle tavole cartacee | Prevedere penali contrattuali dedicate e vincolanti per il mancato rispetto delle milestone informative. |

---

## Output

Quando invocata, la skill genera:
1. **Schema di Protocollo Informativo di Commessa (*Information Protocol*)** completo in 9 articoli formali personalizzabili.
2. **Tabella Information Particulars** compilata per la commessa.
3. **Clausola di Ordine di Prevalenza Documentale** calibrata sul Capitolato Informativo della SA.
4. **Accordo sul Trattamento Dati ex Art. 28 GDPR** da allegare al contratto di servizio ACDat.

---

## Limiti

- La skill fornisce la struttura giuridico-tecnica di eccellenza conforme a ISO 19650-2; la revisione finale e l'integrazione nel contratto d'appalto generale devono essere convalidate dall'Ufficio Legale o dal consulente contrattuale delle parti.
