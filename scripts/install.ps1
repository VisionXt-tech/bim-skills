# BIM Skills Italia - Installer Multi-Agent (Windows PowerShell)
# Esempi d'uso con una riga di codice (One-Liner):
#
#   Installazione guidata / interattiva:
#     irm https://raw.githubusercontent.com/VisionXt-tech/bim-skills/main/scripts/install.ps1 | iex
#
#   Installazione diretta per singolo strumento:
#     & ([scriptblock]::Create((irm https://raw.githubusercontent.com/VisionXt-tech/bim-skills/main/scripts/install.ps1))) -Target claude
#     & ([scriptblock]::Create((irm https://raw.githubusercontent.com/VisionXt-tech/bim-skills/main/scripts/install.ps1))) -Target antigravity
#     & ([scriptblock]::Create((irm https://raw.githubusercontent.com/VisionXt-tech/bim-skills/main/scripts/install.ps1))) -Target cursor
#     & ([scriptblock]::Create((irm https://raw.githubusercontent.com/VisionXt-tech/bim-skills/main/scripts/install.ps1))) -Target all

[CmdletBinding()]
param(
    [ValidateSet("claude", "antigravity", "cursor", "all", "interactive", "")]
    [string]$Target = ""
)

$ErrorActionPreference = "Stop"
$REPO_URL = "https://github.com/VisionXt-tech/bim-skills.git"

Write-Host ""
Write-Host "  ========================================================" -ForegroundColor Cyan
Write-Host "    BIM Skills Italia - Multi-Agent Installer (VisionXt)   " -ForegroundColor Cyan
Write-Host "  ========================================================" -ForegroundColor Cyan
Write-Host ""

# Modalità guidata se Target non è specificato
if ([string]::IsNullOrWhiteSpace($Target) -or $Target -eq "interactive") {
    # Verifica se siamo in console interattiva
    $isInteractive = $Host.UI.RawUI -ne $null -and [System.Environment]::UserInteractive
    if ($isInteractive) {
        Write-Host "  Seleziona l'ambiente in cui installare le skill e gli agenti BIM:" -ForegroundColor White
        Write-Host "    [1] Claude Code        (~/.claude/skills e ~/.claude/agents)" -ForegroundColor Yellow
        Write-Host "    [2] Google Antigravity (~/.gemini/config/skills)" -ForegroundColor Yellow
        Write-Host "    [3] Cursor             (~/.cursor/skills)" -ForegroundColor Yellow
        Write-Host "    [4] Tutti gli ambienti (Claude Code + Antigravity + Cursor) [Consigliato]" -ForegroundColor Green
        Write-Host "    [0] Esci senza installare" -ForegroundColor DarkGray
        Write-Host ""
        
        $choice = Read-Host "  Digita il numero dell'opzione desiderata [1-4, default: 4]"
        switch ($choice.Trim()) {
            "1" { $Target = "claude" }
            "2" { $Target = "antigravity" }
            "3" { $Target = "cursor" }
            "0" { 
                Write-Host "  Installazione annullata dall'utente." -ForegroundColor DarkGray
                exit 0 
            }
            default { $Target = "all" }
        }
    } else {
        $Target = "all"
    }
}

Write-Host "  -> Ambiente di destinazione selezionato: $Target" -ForegroundColor Magenta
Write-Host ""

# Determina sorgente (locale o clonata)
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path -ErrorAction SilentlyContinue
$repoRoot = if ($scriptDir) { Split-Path -Parent $scriptDir } else { $null }
$isLocal = ($repoRoot -and (Test-Path (Join-Path $repoRoot "skills")))

$sourceRoot = $null
$tempDir = $null

if ($isLocal) {
    $sourceRoot = $repoRoot
} else {
    if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
        Write-Host "  ERRORE: git non trovato. Installalo da https://git-scm.com" -ForegroundColor Red
        exit 1
    }
    $tempDir = Join-Path $env:TEMP "bim-skills-install-$(Get-Random)"
    Write-Host "  Scaricamento repository openBIM..." -ForegroundColor White
    git clone --depth 1 --quiet $REPO_URL $tempDir 2>$null
    if ($LASTEXITCODE -ne 0) {
        Write-Host "  ERRORE: download fallito. Verifica la connessione e riprova." -ForegroundColor Red
        exit 1
    }
    $sourceRoot = $tempDir
}

$skillsSource = Join-Path $sourceRoot "skills"
$agentsSource = Join-Path $sourceRoot "agents"

# Funzione per installare le skill appiattendole
function Install-SkillsFlattened {
    param([string]$DestDir)
    if (-not (Test-Path $DestDir)) { New-Item -ItemType Directory -Path $DestDir -Force | Out-Null }
    $skills = Get-ChildItem -Path $skillsSource -Recurse -Filter "SKILL.md"
    foreach ($s in $skills) {
        $skillName = $s.Directory.Name
        $targetFolder = Join-Path $DestDir $skillName
        if (-not (Test-Path $targetFolder)) { New-Item -ItemType Directory -Path $targetFolder -Force | Out-Null }
        Copy-Item -Path $s.FullName -Destination (Join-Path $targetFolder "SKILL.md") -Force
    }
    return $skills.Count
}

# Funzione per installare gli agenti
function Install-Agents {
    param(
        [string]$DestDir,
        [switch]$AsSkill
    )
    if (-not (Test-Path $DestDir)) { New-Item -ItemType Directory -Path $DestDir -Force | Out-Null }
    $agents = Get-ChildItem -Path $agentsSource -Filter "*.md"
    foreach ($a in $agents) {
        if ($AsSkill) {
            $agentName = [System.IO.Path]::GetFileNameWithoutExtension($a.Name)
            $targetFolder = Join-Path $DestDir $agentName
            if (-not (Test-Path $targetFolder)) { New-Item -ItemType Directory -Path $targetFolder -Force | Out-Null }
            Copy-Item -Path $a.FullName -Destination (Join-Path $targetFolder "SKILL.md") -Force
        } else {
            Copy-Item -Path $a.FullName -Destination $DestDir -Force
        }
    }
    return $agents.Count
}

# Pulizia vecchi agenti senza prefisso bim-
function Clean-LegacyAgents {
    param([string]$Dir, [switch]$IsFolder)
    $legacy = @("gara-bim", "delivery-team", "cde-manager", "quality-gate", "asset-manager", "revit-dev")
    foreach ($l in $legacy) {
        if ($IsFolder) {
            $p = Join-Path $Dir $l
            if (Test-Path $p) { Remove-Item -Path $p -Recurse -Force -ErrorAction SilentlyContinue }
        } else {
            $p = Join-Path $Dir "$l.md"
            if (Test-Path $p) { Remove-Item -Path $p -Force -ErrorAction SilentlyContinue }
        }
    }
}

# Esecuzione per target
if ($Target -eq "claude" -or $Target -eq "all") {
    $claudeSkills = "$env:USERPROFILE\.claude\skills"
    $claudeAgents = "$env:USERPROFILE\.claude\agents"
    Clean-LegacyAgents -Dir $claudeAgents
    $cSkillsCount = Install-SkillsFlattened -DestDir $claudeSkills
    $cAgentsCount = Install-Agents -DestDir $claudeAgents
    Write-Host "  [OK] Claude Code        : $cSkillsCount skill in $claudeSkills e $cAgentsCount agenti in $claudeAgents" -ForegroundColor Green
}

if ($Target -eq "antigravity" -or $Target -eq "all") {
    $agSkills = "$env:USERPROFILE\.gemini\config\skills"
    Clean-LegacyAgents -Dir $agSkills -IsFolder
    $agSkillsCount = Install-SkillsFlattened -DestDir $agSkills
    $agAgentsCount = Install-Agents -DestDir $agSkills -AsSkill
    Write-Host "  [OK] Google Antigravity : $agSkillsCount skill e $agAgentsCount workflow agenti in $agSkills" -ForegroundColor Green
}

if ($Target -eq "cursor" -or $Target -eq "all") {
    $curSkills = "$env:USERPROFILE\.cursor\skills"
    Clean-LegacyAgents -Dir $curSkills -IsFolder
    $curSkillsCount = Install-SkillsFlattened -DestDir $curSkills
    $curAgentsCount = Install-Agents -DestDir $curSkills -AsSkill
    Write-Host "  [OK] Cursor             : $curSkillsCount skill e $curAgentsCount agenti in $curSkills" -ForegroundColor Green
}

# Pulizia temp
if ($tempDir -and (Test-Path $tempDir)) {
    Remove-Item -Recurse -Force $tempDir
}

Write-Host ""
Write-Host "  Installazione completata con successo!" -ForegroundColor Cyan
Write-Host "  Come usare le skill e gli agenti:" -ForegroundColor White
Write-Host "    - In Claude Code        : digita / per le skill e seleziona gli agenti bim-*" -ForegroundColor Gray
Write-Host "    - In Google Antigravity : digita / per visualizzare e invocare le skill BIM" -ForegroundColor Gray
Write-Host "    - In Cursor             : usa @ per richiamare skill e agenti BIM" -ForegroundColor Gray
Write-Host ""
