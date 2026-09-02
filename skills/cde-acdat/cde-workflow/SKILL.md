# CDE Workflow & Status

Analisi flussi informativi e verifica stati container nel CDE.

## Scope

- Analisi log del CDE e audit trail
- Verifica corretto passaggio tra stati (WIP/Shared/Published/Archived)
- Controllo codici di revisione e autorizzazione
- Identificazione colli di bottiglia informativi
- Report di stato per gate di consegna

## Normativa

- **ISO 19650-1, §12** — CDE concept: le 4 aree (WIP, Shared, Published, Archive) e il flusso dei container tra di esse
- **ISO 19650-2** — richiede che ogni container abbia un codice di stato (status/suitability code); non impone un elenco universale — vedi terminologia sotto
- **UNI 11337-5** — flussi informativi, Aree e Stati di Lavorazione/Approvazione dell'ACDat

## Terminologia: area CDE vs codice di stato

Due livelli distinti da non confondere in fase di audit:

- **Area CDE** (WIP/Shared/Published/Archived): la posizione logica del container nel flusso — terminologia formale ISO 19650-1 e UNI 11337-5.
- **Codice di stato** (status/suitability code): metadato sul singolo container che ne indica l'idoneita d'uso in quel momento. La tabella diffusa S0→S4 (WIP/Shared) e A/B (Published) deriva dal National Annex NA (informativo) di BS EN ISO 19650-2 — verificare sempre la tabella codici effettivamente adottata nel Capitolato Informativo del progetto, perche puo differire.

| Codice | Area attesa | Significato indicativo |
|--------|-------------|--------------------------|
| S0 | WIP | In elaborazione, non condiviso |
| S1-S3 | Shared | Coordinamento / informativo / revisione |
| S4 | Shared | Approvazione di fase |
| A | Published | Autorizzato, contrattuale |
| B | Published | Pubblicato con riserve |

Un container con codice A o B fuori dall'area Published, o un codice S0 fuori dall'area WIP, e una transizione anomala da segnalare.

## Workflow

1. Acquisisci log CDE o report di stato corrente (idealmente export machine-readable, non screenshot)
2. Verifica:
   - ogni container ha un codice di stato coerente con l'area in cui si trova (vedi tabella sopra)
   - le transizioni tra aree seguono l'ordine WIP→Shared→Published→(Archived) senza salti non autorizzati
   - i revisori/approvatori che hanno firmato le transizioni sono effettivamente autorizzati secondo la matrice permessi (ruolo x area x azione) del progetto
   - non esistono piu revisioni "attive" con stesso Numero ma codici di stato contrastanti (es. due S4 paralleli sullo stesso container)
   - il log delle transizioni riporta timestamp, autore e area di provenienza/destinazione per ogni evento (traccia di audit — cfr. ISO 27001 Annex A, controllo 8.15 "Logging")
3. Identifica: container bloccati in WIP oltre soglia concordata, ritardi rispetto a MIDP/TIDP, transizioni anomale (salti di stato, approvazioni fuori ruolo, revisioni duplicate)
4. Genera report con dashboard stato e azioni richieste

## Anti-pattern

| Errore | Correzione |
|--------|------------|
| Trattare "area" e "codice di stato" come sinonimi nel report | Verificarli separatamente: un'anomalia puo esistere su uno solo dei due livelli |
| Accettare transizioni senza verificare il ruolo dell'approvatore | Incrociare sempre con la matrice permessi ruolo x area x azione |
| Ignorare container fermi in WIP senza soglia di allarme | Definire una soglia (es. giorni) oltre cui segnalare come collo di bottiglia |
| Report basato solo su conteggio, senza timestamp/autore | Ogni riga del report deve riportare chi, quando, da quale area a quale area |
| Assumere la tabella codici UK (S0-S4/A/B) come valida a priori | Verificarla nel Capitolato Informativo del progetto specifico |
