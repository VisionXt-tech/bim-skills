# BIM Skills Italia - Uninstaller Multi-Agent (Windows PowerShell)
# Esempi d'uso con una riga di codice (One-Liner):
#
#   Disinstallazione guidata / interattiva:
#     irm https://raw.githubusercontent.com/VisionXt-tech/bim-skills/main/scripts/uninstall.ps1 | iex
#
#   Disinstallazione diretta per singolo strumento:
#     & ([scriptblock]::Create((irm https://raw.githubusercontent.com/VisionXt-tech/bim-skills/main/scripts/uninstall.ps1))) -Target claude
#     & ([scriptblock]::Create((irm https://raw.githubusercontent.com/VisionXt-tech/bim-skills/main/scripts/uninstall.ps1))) -Target antigravity
#     & ([scriptblock]::Create((irm https://raw.githubusercontent.com/VisionXt-tech/bim-skills/main/scripts/uninstall.ps1))) -Target cursor
#     & ([scriptblock]::Create((irm https://raw.githubusercontent.com/VisionXt-tech/bim-skills/main/scripts/uninstall.ps1))) -Target all

[CmdletBinding()]
param(
    [ValidateSet("claude", "antigravity", "cursor", "all", "interactive", "")]
    [string]$Target = ""
)

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "  ========================================================" -ForegroundColor Yellow
Write-Host "    BIM Skills Italia - Multi-Agent Uninstaller (VisionXt) " -ForegroundColor Yellow
Write-Host "  ========================================================" -ForegroundColor Yellow
Write-Host ""

# Modalità guidata se Target non è specificato
if ([string]::IsNullOrWhiteSpace($Target) -or $Target -eq "interactive") {
    $isInteractive = $null -ne $Host.UI.RawUI -and [System.Environment]::UserInteractive
    if ($isInteractive) {
        Write-Host "  Seleziona l'ambiente da cui rimuovere le skill e gli agenti BIM:" -ForegroundColor White
        Write-Host "    [1] Claude Code        (~/.claude/skills e ~/.claude/agents)" -ForegroundColor Yellow
        Write-Host "    [2] Google Antigravity (~/.gemini/config/skills)" -ForegroundColor Yellow
        Write-Host "    [3] Cursor             (~/.cursor/skills)" -ForegroundColor Yellow
        Write-Host "    [4] Tutti gli ambienti (Claude Code + Antigravity + Cursor)" -ForegroundColor Green
        Write-Host "    [0] Annulla ed esci" -ForegroundColor DarkGray
        Write-Host ""
        
        $choice = Read-Host "  Digita il numero dell'opzione desiderata [1-4, default: 4]"
        switch ($choice.Trim()) {
            "1" { $Target = "claude" }
            "2" { $Target = "antigravity" }
            "3" { $Target = "cursor" }
            "0" { 
                Write-Host "  Disinstallazione annullata." -ForegroundColor DarkGray
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

# Elenco ufficiale delle 26 skill
$repoSkills = @(
    "construction-sequencing", "materials-traceability", "quantities-cost-linking",
    "aim-construction", "digital-twin-analytics", "maintenance-cmms",
    "grasshopper", "pyrevit", "revit-api", "revit-cpp-plugin", "revit-dynamo", "rhino", "rhino-inside-revit",
    "cde-configuration", "cde-cybersecurity", "cde-workflow",
    "bim-execution", "information-delivery-planning", "information-protocol",
    "clash-detection", "ifc-loin-validator", "naming-spatial-structure", "normative-code-checking",
    "ci-drafting", "ogi-evaluation", "pgi-consolidation"
)

# Elenco ufficiale dei 6 agenti
$repoAgents = @(
    "bim-asset-manager", "bim-cde-manager", "bim-delivery-team",
    "bim-gara", "bim-quality-gate", "bim-revit-dev"
)

# Residui di agenti legacy
$legacyAgents = @(
    "gara-bim", "delivery-team", "cde-manager", "quality-gate", "asset-manager", "revit-dev"
)

# Unione dinamica con eventuali nuove skill presenti nella cartella locale
$cmdPath = if ($MyInvocation.MyCommand -and $MyInvocation.MyCommand.Path) { $MyInvocation.MyCommand.Path } else { $null }
$scriptDir = if ($cmdPath) { Split-Path -Parent $cmdPath } else { $null }
$repoRoot = if ($scriptDir) { Split-Path -Parent $scriptDir } else { $null }
if ($repoRoot -and (Test-Path (Join-Path $repoRoot "skills"))) {
    $localSkills = Get-ChildItem -Path (Join-Path $repoRoot "skills") -Recurse -Filter "SKILL.md" | ForEach-Object { $_.Directory.Name }
    $repoSkills = ($repoSkills + $localSkills) | Select-Object -Unique
}

# Funzione per rimuovere cartelle di skill
function Remove-BimSkills {
    param([string]$DestDir)
    if (-not (Test-Path $DestDir)) { return 0 }
    $removed = 0
    foreach ($skill in $repoSkills) {
        $p = Join-Path $DestDir $skill
        if (Test-Path $p) {
            Remove-Item -Path $p -Recurse -Force -ErrorAction SilentlyContinue
            $removed++
        }
    }
    return $removed
}

# Funzione per rimuovere agenti
function Remove-BimAgents {
    param(
        [string]$DestDir,
        [switch]$AsFolder
    )
    if (-not (Test-Path $DestDir)) { return 0 }
    $removed = 0
    $allAgents = ($repoAgents + $legacyAgents) | Select-Object -Unique
    foreach ($agent in $allAgents) {
        if ($AsFolder) {
            $p = Join-Path $DestDir $agent
            if (Test-Path $p) {
                Remove-Item -Path $p -Recurse -Force -ErrorAction SilentlyContinue
                $removed++
            }
        } else {
            $p = Join-Path $DestDir "$agent.md"
            if (Test-Path $p) {
                Remove-Item -Path $p -Force -ErrorAction SilentlyContinue
                $removed++
            }
        }
    }
    return $removed
}

# Esecuzione per target
if ($Target -eq "claude" -or $Target -eq "all") {
    $claudeSkills = "$env:USERPROFILE\.claude\skills"
    $claudeAgents = "$env:USERPROFILE\.claude\agents"
    $cSkillsRemoved = Remove-BimSkills -DestDir $claudeSkills
    $cAgentsRemoved = Remove-BimAgents -DestDir $claudeAgents
    Write-Host "  [OK] Claude Code        : $cSkillsRemoved skill rimosse da $claudeSkills e $cAgentsRemoved agenti rimossi da $claudeAgents" -ForegroundColor Green
}

if ($Target -eq "antigravity" -or $Target -eq "all") {
    $agSkills = "$env:USERPROFILE\.gemini\config\skills"
    $agSkillsRemoved = Remove-BimSkills -DestDir $agSkills
    $agAgentsRemoved = Remove-BimAgents -DestDir $agSkills -AsFolder
    Write-Host "  [OK] Google Antigravity : $agSkillsRemoved skill e $agAgentsRemoved workflow agenti rimossi da $agSkills" -ForegroundColor Green
}

if ($Target -eq "cursor" -or $Target -eq "all") {
    $curSkills = "$env:USERPROFILE\.cursor\skills"
    $curSkillsRemoved = Remove-BimSkills -DestDir $curSkills
    $curAgentsRemoved = Remove-BimAgents -DestDir $curSkills -AsFolder
    Write-Host "  [OK] Cursor             : $curSkillsRemoved skill e $curAgentsRemoved agenti rimossi da $curSkills" -ForegroundColor Green
}

Write-Host ""
Write-Host "  Disinstallazione completata con successo!" -ForegroundColor Cyan
Write-Host "  Le altre tue skill e configurazioni personali sono rimaste intatte." -ForegroundColor White
Write-Host ""
