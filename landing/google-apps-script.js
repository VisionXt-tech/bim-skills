/**
 * =========================================================================
 * VisionXt - BIM Skills Italia | Lead Capture & Automated Email Dispatcher
 * Account di invio: amministrazione@visionxt.tech (Google Workspace / Gmail)
 * =========================================================================
 * 
 * ISTRUZIONI DI CONFIGURAZIONE (3 Minuti):
 * 1. Accedi a Google Drive con l'account: amministrazione@visionxt.tech
 * 2. Crea un nuovo Foglio Google (es. "BIM Skills - Lista Lead Qualificati")
 * 3. Dal menu in alto, clicca su: Estensioni > Apps Script
 * 4. Cancella qualsiasi codice presente nell'editor e incolla questo file.
 * 5. Clicca sul pulsante "Esegui" (Run) una volta per autorizzare i permessi.
 * 6. In alto a destra, clicca su "Distribuisci" (Deploy) > "Nuova distribuzione" (New deployment).
 *    - Tipo: Applicazione web (Web app)
 *    - Esegui come: "Io (amministrazione@visionxt.tech)"
 *    - Chi può accedere: "Chiunque" (Anyone)  <--- FONDAMENTALE!
 * 7. Clicca su "Distribuisci" e copia l'URL dell'applicazione web generato.
 * 8. Incolla questo URL nella variabile APPS_SCRIPT_URL nel tuo file HTML!
 */

function doPost(e) {
  try {
    var rawData = e.postData ? e.postData.contents : "{}";
    var data = JSON.parse(rawData);

    var name = (data.name || "Professionista BIM").trim();
    var email = (data.email || "").trim();
    var role = data.role || "Non specificato";
    var software = data.software || "Non specificato";
    var aiTool = data.ai_tool || "Non specificato";
    var timestamp = new Date();

    if (!email) {
      return ContentService.createTextOutput(JSON.stringify({ status: "error", message: "Email mancante" }))
        .setMimeType(ContentService.MimeType.JSON);
    }

    // 1. REGISTRAZIONE SUL FOGLIO GOOGLE ATTIVO
    var sheet = SpreadsheetApp.getActiveSpreadsheet().getActiveSheet();
    
    // Se il foglio è vuoto, inserisci l'intestazione
    if (sheet.getLastRow() === 0) {
      sheet.appendRow([
        "Data/Ora Registrazione", 
        "Nome Completo", 
        "Email", 
        "Ruolo Professionale", 
        "Software Primario", 
        "Strumento AI", 
        "Stato Invio Email"
      ]);
      sheet.getRange(1, 1, 1, 7).setFontWeight("bold").setBackground("#87AFAE").setFontColor("#0A0C0E");
    }

    // 2. INVIO AUTOMATICO DELL'EMAIL TRAMITE GMAIL (amministrazione@visionxt.tech)
    var subject = "Benvenuto in BIM Skills Italia — Accesso e Istruzioni";
    var htmlBody = buildWelcomeEmail(name);

    GmailApp.sendEmail(email, subject, "Benvenuto in BIM Skills Italia. Apri questa email in un client con supporto HTML per leggere le istruzioni.", {
      name: "VisionXt — BIM Skills Italia",
      from: "amministrazione@visionxt.tech",
      replyTo: "amministrazione@visionxt.tech",
      htmlBody: htmlBody
    });

    // 3. Salva la riga nel Foglio Google
    sheet.appendRow([
      timestamp, 
      name, 
      email, 
      role, 
      software, 
      aiTool, 
      "Email inviata con successo"
    ]);

    return ContentService.createTextOutput(JSON.stringify({ status: "success", email: email }))
      .setMimeType(ContentService.MimeType.JSON);

  } catch (error) {
    // In caso di errore logga l'eccezione
    Logger.log("Errore doPost: " + error.toString());
    return ContentService.createTextOutput(JSON.stringify({ status: "error", message: error.toString() }))
      .setMimeType(ContentService.MimeType.JSON);
  }
}

// Health check GET
function doGet(e) {
  return ContentService.createTextOutput("VisionXt BIM Skills Webhook attivo e funzionante.")
    .setMimeType(ContentService.MimeType.TEXT);
}

/**
 * Genera il template HTML responsive per l'email di benvenuto
 */
function buildWelcomeEmail(userName) {
  var repoUrl = "https://github.com/VisionXt-tech/bim-skills";
  var docsUrl = "https://github.com/VisionXt-tech/bim-skills/blob/main/docs/installazione.md";
  var siteUrl = "https://visionxt.tech";

  return `
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <style>
    body { margin: 0; padding: 0; background-color: #0A0C0E; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif; color: #FFFFFF; }
    .wrapper { width: 100%; max-width: 600px; margin: 0 auto; background-color: #12161A; border: 1px solid rgba(255,255,255,0.08); border-radius: 12px; overflow: hidden; }
    .header { padding: 36px 30px; text-align: center; border-bottom: 1px solid rgba(255,255,255,0.08); background: #0F1215; }
    .brand { font-size: 13px; font-weight: 700; color: #87AFAE; letter-spacing: 2px; text-transform: uppercase; margin-bottom: 10px; }
    .title { font-size: 24px; font-weight: 700; color: #FFFFFF; margin: 0; line-height: 1.3; }
    .content { padding: 32px 30px; line-height: 1.6; color: #D1D5DB; font-size: 15px; }
    .btn { display: inline-block; background-color: #87AFAE; color: #0A0C0E !important; font-weight: 700; font-size: 15px; padding: 14px 28px; border-radius: 6px; text-decoration: none; margin: 20px 0; text-align: center; }
    .code-box { background-color: #080A0C; border: 1px solid rgba(135, 175, 174, 0.25); border-radius: 6px; padding: 14px 16px; font-family: 'SFMono-Regular', Consolas, Menlo, monospace; font-size: 13px; color: #87AFAE; overflow-x: auto; margin: 12px 0 20px 0; word-break: break-all; }
    .badge-pill { display: inline-block; background: rgba(135,175,174,0.12); color: #87AFAE; border: 1px solid rgba(135,175,174,0.3); font-size: 11px; padding: 2px 8px; border-radius: 4px; font-weight: 600; margin-right: 6px; }
    .footer { padding: 24px 30px; text-align: center; font-size: 12px; color: #6B7280; border-top: 1px solid rgba(255,255,255,0.08); background-color: #0F1215; }
    .footer a { color: #87AFAE; text-decoration: none; }
  </style>
</head>
<body>
  <div style="padding: 20px 10px;">
    <div class="wrapper">
      
      <div class="header">
        <div class="brand">VISIONXT · OPENBIM & AI</div>
        <h1 class="title">BIM Skills Italia</h1>
      </div>

      <div class="content">
        <p>Ciao <strong>${userName}</strong>,</p>
        
        <p>Grazie per esserti registrato. <strong>BIM Skills Italia</strong> è la suite aperta sviluppata da <strong>VisionXt</strong> per portare la conformità alle normative italiane (D.Lgs. 36/2023, UNI 11337, ISO 19650) direttamente nei tuoi assistenti AI (<strong>Claude Code</strong>, <strong>Google Antigravity</strong> e <strong>Cursor</strong>).</p>

        <div style="text-align: center;">
          <a href="${repoUrl}" class="btn" target="_blank">Apri il Repository Ufficiale su GitHub →</a>
        </div>

        <h3 style="color: #FFFFFF; font-size: 17px; margin-top: 30px; margin-bottom: 8px;">⚡ Installazione Rapida (One-Liner in 1 Click)</h3>
        <p style="font-size: 14px; margin-bottom: 8px;">Non occorre scaricare o clonare il repository manualmente. Apri il tuo terminale ed esegui una riga di codice:</p>
        
        <div style="margin-top: 12px;">
          <span class="badge-pill">Windows (PowerShell)</span>
          <div class="code-box">irm https://raw.githubusercontent.com/VisionXt-tech/bim-skills/main/scripts/install.ps1 | iex</div>
        </div>

        <div>
          <span class="badge-pill">macOS / Linux (Terminal)</span>
          <div class="code-box">curl -fsSL https://raw.githubusercontent.com/VisionXt-tech/bim-skills/main/scripts/install.sh | bash</div>
        </div>

        <p style="font-size: 13px; color: #9CA3AF;">
          L'installer visualizzerà un menu guidato per installare automaticamente le 26 skill e i 6 agenti su Claude Code, Google Antigravity o Cursor.
        </p>

        <h3 style="color: #FFFFFF; font-size: 17px; margin-top: 28px; margin-bottom: 8px;">📖 Documentazione e Supporto</h3>
        <p style="font-size: 14px;">
          Per consultare i percorsi di installazione e la guida alla risoluzione problemi, consulta la <a href="${docsUrl}" style="color: #87AFAE;">Guida Ufficiale all'Installazione</a>.<br>
          Se hai domande o desideri integrare workflow dedicati per la tua organizzazione, rispondi direttamente a questa email.
        </p>
      </div>

      <div class="footer">
        BIM Skills Italia è un progetto curato da <a href="${siteUrl}" target="_blank"><strong>VisionXt</strong></a>.<br>
        Hai ricevuto questa email perché ti sei registrato su <strong>visionxt.tech</strong>.<br>
        Contatto diretto: <a href="mailto:amministrazione@visionxt.tech">amministrazione@visionxt.tech</a>
      </div>

    </div>
  </div>
</body>
</html>
  `;
}
