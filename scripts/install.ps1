# BIM Skills Italia — Installer per Windows
# Esegui con: irm https://raw.githubusercontent.com/VisionXt-tech/bim-skills/main/scripts/install.ps1 | iex

$ErrorActionPreference = "Stop"

$REPO_URL = "https://github.com/VisionXt-tech/bim-skills.git"
$INSTALL_DIR = "$env:USERPROFILE\.claude\skills\bim"
$TEMP_DIR = "$env:TEMP\bim-skills-install"

Write-Host ""
Write-Host "  BIM Skills Italia — Installer" -ForegroundColor Cyan
Write-Host "  by VisionXt" -ForegroundColor DarkGray
Write-Host ""

# Check git
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "  ERRORE: git non trovato. Installalo da https://git-scm.com" -ForegroundColor Red
    exit 1
}

# Check Claude Code skills directory
$claudeDir = "$env:USERPROFILE\.claude\skills"
if (-not (Test-Path $claudeDir)) {
    New-Item -ItemType Directory -Path $claudeDir -Force | Out-Null
    Write-Host "  Creata directory skills: $claudeDir" -ForegroundColor Yellow
}

# Clone or update
if (Test-Path $TEMP_DIR) {
    Remove-Item -Recurse -Force $TEMP_DIR
}

Write-Host "  Scaricamento skill..." -ForegroundColor White
git clone --depth 1 --quiet $REPO_URL $TEMP_DIR 2>$null

if ($LASTEXITCODE -ne 0) {
    Write-Host "  ERRORE: impossibile clonare il repository." -ForegroundColor Red
    Write-Host "  Verifica la connessione e riprova." -ForegroundColor Red
    exit 1
}

# Install skills
if (Test-Path $INSTALL_DIR) {
    Remove-Item -Recurse -Force $INSTALL_DIR
}

Copy-Item -Recurse "$TEMP_DIR\skills" $INSTALL_DIR

# Count installed skills
$skillCount = (Get-ChildItem -Recurse -Path $INSTALL_DIR -Filter "SKILL.md").Count

# Cleanup
Remove-Item -Recurse -Force $TEMP_DIR

Write-Host ""
Write-Host "  Installate $skillCount skill in: $INSTALL_DIR" -ForegroundColor Green
Write-Host ""
Write-Host "  Uso: in Claude Code, digita / e cerca le skill BIM." -ForegroundColor White
Write-Host "  Aggiornamento: riesegui questo script." -ForegroundColor DarkGray
Write-Host ""
