# Guida all'Installazione delle Skill e Agenti BIM

Questa guida illustra nel dettaglio come installare e manutenere la suite **BIM Skills Italia** nel tuo ambiente di lavoro AI preferito (**Claude Code**, **Google Antigravity**, **Cursor**).

---

## Metodo 1: Installazione Guidata con One-Liner (Consigliata)

Non serve scaricare o clonare manualmente il repository. Puoi incollare una singola riga nel tuo terminale per avviare l'installatore interattivo:

### Windows (PowerShell)
Apri Windows Terminal o PowerShell ed esegui:
```powershell
irm https://raw.githubusercontent.com/VisionXt-tech/bim-skills/main/scripts/install.ps1 | iex
```

### macOS / Linux (Bash)
Apri il terminale ed esegui:
```bash
curl -fsSL https://raw.githubusercontent.com/VisionXt-tech/bim-skills/main/scripts/install.sh | bash
```

Il terminale ti mostrerà il menu di scelta:
```text
  ========================================================
    BIM Skills Italia - Multi-Agent Installer (VisionXt)   
  ========================================================

  Seleziona l'ambiente in cui installare le skill e gli agenti BIM:
    [1] Claude Code        (~/.claude/skills e ~/.claude/agents)
    [2] Google Antigravity (~/.gemini/config/skills)
    [3] Cursor             (~/.cursor/skills)
    [4] Tutti gli ambienti (Claude Code + Antigravity + Cursor) [Consigliato]
    [0] Esci senza installare
```

Basterà digitare il numero corrispondente al tuo strumento per completare l'installazione in pochi istanti.

---

## Metodo 2: Installazione Diretta per Strumento

Se desideri eseguire l'installazione in modalità non interattiva (o all'interno di script CI/CD):

### 1. Claude Code (Anthropic)
- **Cosa viene installato**: 26 skill operative e 6 agenti multi-skill completi.
- **Percorsi di destinazione**:
  - Skill: `~/.claude/skills/<skill-name>/SKILL.md`
  - Agenti: `~/.claude/agents/<agent-name>.md`
- **Comando One-Liner Windows**:
  ```powershell
  & ([scriptblock]::Create((irm https://raw.githubusercontent.com/VisionXt-tech/bim-skills/main/scripts/install.ps1))) -Target claude
  ```
- **Comando One-Liner macOS/Linux**:
  ```bash
  curl -fsSL https://raw.githubusercontent.com/VisionXt-tech/bim-skills/main/scripts/install.sh | bash -s -- --target claude
  ```

### 2. Google Antigravity (Gemini)
- **Cosa viene installato**: 26 skill e 6 workflow agenti (ciascuno registrato come skill globale di alto livello).
- **Percorso di destinazione**:
  - Global Customizations Root: `~/.gemini/config/skills/<skill-name>/SKILL.md`
- **Comando One-Liner Windows**:
  ```powershell
  & ([scriptblock]::Create((irm https://raw.githubusercontent.com/VisionXt-tech/bim-skills/main/scripts/install.ps1))) -Target antigravity
  ```
- **Comando One-Liner macOS/Linux**:
  ```bash
  curl -fsSL https://raw.githubusercontent.com/VisionXt-tech/bim-skills/main/scripts/install.sh | bash -s -- --target antigravity
  ```

### 3. Cursor (Anysphere)
- **Cosa viene installato**: 26 skill e 6 agenti specialistici per l'IDE Cursor.
- **Percorso di destinazione**:
  - `~/.cursor/skills/<skill-name>/SKILL.md`
- **Comando One-Liner Windows**:
  ```powershell
  & ([scriptblock]::Create((irm https://raw.githubusercontent.com/VisionXt-tech/bim-skills/main/scripts/install.ps1))) -Target cursor
  ```
- **Comando One-Liner macOS/Linux**:
  ```bash
  curl -fsSL https://raw.githubusercontent.com/VisionXt-tech/bim-skills/main/scripts/install.sh | bash -s -- --target cursor
  ```

### 4. Tutti gli Ambienti (Installazione Universale)
Installa simultaneamente per tutti e tre i software rilevati sul computer:
- **Windows**:
  ```powershell
  & ([scriptblock]::Create((irm https://raw.githubusercontent.com/VisionXt-tech/bim-skills/main/scripts/install.ps1))) -Target all
  ```
- **macOS / Linux**:
  ```bash
  curl -fsSL https://raw.githubusercontent.com/VisionXt-tech/bim-skills/main/scripts/install.sh | bash -s -- --target all
  ```

---

## Metodo 3: Installazione da Clone Locale

Se stai sviluppando o personalizzando le skill nel tuo clone locale del repository:

1. Clona il repository:
   ```bash
   git clone https://github.com/VisionXt-tech/bim-skills.git
   cd bim-skills
   ```
2. Esegui lo script locale:
   - **Windows**:
     ```powershell
     powershell.exe -ExecutionPolicy Bypass -File scripts\install.ps1
     ```
   - **macOS / Linux**:
     ```bash
     chmod +x scripts/install.sh
     ./scripts/install.sh
     ```

---

## Risoluzione dei Problemi (Troubleshooting)

### 1. PowerShell: "L'esecuzione degli script è disattivata sul sistema in uso"
Se ricevi un errore di policy di esecuzione in PowerShell (`ExecutionPolicy`), esegui una volta il comando:
```powershell
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
```
oppure esegui lo script bypassando la policy per la sola sessione corrente:
```powershell
powershell -ExecutionPolicy Bypass -File scripts\install.ps1
```

### 2. Git non trovato
Gli installer one-liner scaricano l'archivio del repository via `git clone --depth 1`. Assicurati che `git` sia installato sul sistema e presente nel `PATH`.

### 3. Aggiornamento delle Skill alle versioni più recenti
Per aggiornare la libreria alle ultime modifiche pubblicate su GitHub, è sufficiente rieseguire il comando one-liner: i file esistenti verranno sovrascritti con l'ultima versione ufficiale.

### 4. Disinstallazione
Per rimuovere le skill BIM dal tuo ambiente:
- **Claude Code**: elimina le cartelle delle skill in `~/.claude/skills/` e gli agenti `bim-*.md` in `~/.claude/agents/`.
- **Google Antigravity**: elimina le cartelle delle skill da `~/.gemini/config/skills/`.
- **Cursor**: elimina le cartelle da `~/.cursor/skills/`.
