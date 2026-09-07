# Guida alla Configurazione: Landing Page & Email da amministrazione@visionxt.tech

Questa guida illustra come raccogliere lead qualificati per **BIM Skills Italia** e inviare in automatico l'email di benvenuto tramite **Gmail** (`amministrazione@visionxt.tech`), salvando tutti i contatti in un **Foglio Google** a costo zero.

---

## Panoramica dell'Architettura

```
[ Utente su visionxt.tech/bim-skills ]
              │
              ▼ (Compila Nome, Email, Ruolo, Software, Tool AI)
       [ Form HTML ]
              │
              ▼ (Invio AJAX/JSON)
  [ Web App Google Apps Script ]
       ┌──────┴─────────────────────────┐
       ▼                                ▼
[ Salva Lead nel Foglio Google ]   [ Invia Email HTML tramite Gmail ]
                                   (Da: amministrazione@visionxt.tech)
```

---

## Passo 1: Configurazione di Google Sheets & Apps Script (3 Minuti)

1. Accedi a [Google Drive](https://drive.google.com) effettuando il login con l'account:
   👉 **`amministrazione@visionxt.tech`**
2. Clicca su **Nuovo** > **Fogli Google** (Google Sheets) e rinomina il foglio, ad esempio:
   `BIM Skills - Lead Qualificati`
3. Nella barra dei menu in alto nel foglio, clicca su:
   👉 **Estensioni** > **Apps Script**
4. Nell'editor che si apre, cancella il codice di default (`function myFunction() {...}`) e incolla l'intero contenuto del file:
   [`landing/google-apps-script.js`](./google-apps-script.js)
5. Clicca sull'icona del floppy disk 💾 (**Salva progetto**).

---

## Passo 2: Distribuzione dell'Applicazione Web (Web App)

1. In alto a destra nella schermata di Apps Script, clicca sul pulsante blu **Distribuisci** (Deploy) > **Nuova distribuzione** (New deployment).
2. Nella finestra modale:
   - Clicca sull'icona a ingranaggio ⚙️ accanto a "Seleziona tipo" e scegli **Applicazione web** (Web app).
   - **Descrizione**: `Webhook Registrazione BIM Skills`.
   - **Esegui come**: `Io (amministrazione@visionxt.tech)`.
   - **Chi può accedere**: seleziona obbligatoriamente 👉 **`Chiunque`** (Anyone).
3. Clicca su **Distribuisci**.
4. Ti verrà richiesta l'autorizzazione di Google per inviare email e modificare il foglio:
   - Clicca su *Autorizza accesso*.
   - Seleziona l'account `amministrazione@visionxt.tech`.
   - Clicca su *Avanzate* > *Apri Progetto (non sicuro)* > *Consenti*.
5. Copia l'**URL dell'applicazione web** generato (avrà una struttura tipo: `https://script.google.com/macros/s/AKfycb.../exec`).

---

## Passo 3: Collega l'URL al Form

Apri il file [`landing/squarespace-embed.html`](./squarespace-embed.html) (oppure [`landing/index.html`](./index.html)):
Alla riga contrassegnata:
```javascript
const APPS_SCRIPT_URL = "https://script.google.com/macros/s/AKfycbz_SOSTITUISCI_CON_IL_TUO_ID/exec";
```
Sostituisci la stringa con l'URL reale copiato al Passo 2.

---

## Passo 4: Pubblicazione su Squarespace (`visionxt.tech`)

Se il tuo sito web è gestito su Squarespace:

1. Accedi alla console di Squarespace su [squarespace.com](https://squarespace.com).
2. Vai su **Pagine** (Pages) e aggiungi una nuova pagina (es. intitolata `BIM Skills Italia`).
3. Nelle impostazioni della pagina ⚙️, imposta lo **Slug URL** come:
   `/bim-skills` (sarà raggiungibile all'indirizzo `https://visionxt.tech/bim-skills`).
4. Entra in modalità modifica della pagina, clicca su **Aggiungi blocco** (Add Block) e seleziona **Codice** (Code Block).
5. Incolla l'intero codice contenuto in [`landing/squarespace-embed.html`](./squarespace-embed.html).
6. Clicca su **Salva** ed esci.

---

## Risultato Finale

- Ogni volta che un visitatore compila il form su `visionxt.tech/bim-skills`:
  1. Riceve a video una schermata di conferma immediata.
  2. Riceve in pochi secondi una mail brandizzata VisionXt spedita da `amministrazione@visionxt.tech` con link al repo GitHub, comandi one-liner e guida.
  3. Il contatto viene registrato in tempo reale nel tuo Foglio Google con: *Data/Ora, Nome, Email, Ruolo professionale, Software principale e Strumento AI*.
