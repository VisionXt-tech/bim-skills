#!/usr/bin/env bash
# BIM Skills Italia - Multi-Agent Uninstaller (macOS & Linux)
# Esempi d'uso con una riga di codice (One-Liner):
#
#   Disinstallazione guidata / interattiva:
#     curl -fsSL https://raw.githubusercontent.com/VisionXt-tech/bim-skills/main/scripts/uninstall.sh | bash
#
#   Disinstallazione diretta per singolo strumento:
#     curl -fsSL https://raw.githubusercontent.com/VisionXt-tech/bim-skills/main/scripts/uninstall.sh | bash -s -- --target claude
#     curl -fsSL https://raw.githubusercontent.com/VisionXt-tech/bim-skills/main/scripts/uninstall.sh | bash -s -- --target antigravity
#     curl -fsSL https://raw.githubusercontent.com/VisionXt-tech/bim-skills/main/scripts/uninstall.sh | bash -s -- --target cursor
#     curl -fsSL https://raw.githubusercontent.com/VisionXt-tech/bim-skills/main/scripts/uninstall.sh | bash -s -- --target all

set -euo pipefail

TARGET=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --target|-t)
      TARGET="$2"
      shift 2
      ;;
    --all|-a)
      TARGET="all"
      shift
      ;;
    *)
      TARGET="$1"
      shift
      ;;
  esac
done

echo -e "\n  ========================================================"
echo -e "    BIM Skills Italia - Multi-Agent Uninstaller (VisionXt) "
echo -e "  ========================================================\n"

# Modalità guidata se il target non è specificato e il terminale è interattivo
if [[ -z "$TARGET" || "$TARGET" == "interactive" ]]; then
  if [[ -t 0 ]]; then
    echo -e "  Seleziona l'ambiente da cui rimuovere le skill e gli agenti BIM:"
    echo -e "    [1] Claude Code        (~/.claude/skills e ~/.claude/agents)"
    echo -e "    [2] Google Antigravity (~/.gemini/config/skills)"
    echo -e "    [3] Cursor             (~/.cursor/skills)"
    echo -e "    [4] Tutti gli ambienti (Claude Code + Antigravity + Cursor)"
    echo -e "    [0] Annulla ed esci\n"
    
    read -r -p "  Digita il numero dell'opzione desiderata [1-4, default: 4]: " CHOICE
    case "${CHOICE:-4}" in
      1) TARGET="claude" ;;
      2) TARGET="antigravity" ;;
      3) TARGET="cursor" ;;
      0) 
        echo -e "\n  Disinstallazione annullata.\n"
        exit 0
        ;;
      *) TARGET="all" ;;
    esac
  else
    TARGET="all"
  fi
fi

echo -e "  -> Ambiente di destinazione selezionato: ${TARGET}\n"

REPO_SKILLS=(
  "construction-sequencing" "materials-traceability" "quantities-cost-linking"
  "aim-construction" "digital-twin-analytics" "maintenance-cmms"
  "grasshopper" "pyrevit" "revit-api" "revit-cpp-plugin" "revit-dynamo" "rhino" "rhino-inside-revit"
  "cde-configuration" "cde-cybersecurity" "cde-workflow"
  "bim-execution" "information-delivery-planning" "information-protocol"
  "clash-detection" "ifc-loin-validator" "naming-spatial-structure" "normative-code-checking"
  "ci-drafting" "ogi-evaluation" "pgi-consolidation"
)

REPO_AGENTS=(
  "bim-asset-manager" "bim-cde-manager" "bim-delivery-team"
  "bim-gara" "bim-quality-gate" "bim-revit-dev"
)

LEGACY_AGENTS=(
  "gara-bim" "delivery-team" "cde-manager" "quality-gate" "asset-manager" "revit-dev"
)

remove_skills() {
  local dest_dir="$1"
  [[ -d "$dest_dir" ]] || return 0
  local count=0
  for skill in "${REPO_SKILLS[@]}"; do
    if [[ -d "$dest_dir/$skill" ]]; then
      rm -rf "$dest_dir/$skill"
      ((count++))
    fi
  done
  echo "$count"
}

remove_agents() {
  local dest_dir="$1"
  local as_folder="$2"
  [[ -d "$dest_dir" ]] || return 0
  local count=0
  local all_agents=("${REPO_AGENTS[@]}" "${LEGACY_AGENTS[@]}")
  for agent in "${all_agents[@]}"; do
    if [[ "$as_folder" == "true" ]]; then
      if [[ -d "$dest_dir/$agent" ]]; then
        rm -rf "$dest_dir/$agent"
        ((count++))
      fi
    else
      if [[ -f "$dest_dir/$agent.md" ]]; then
        rm -f "$dest_dir/$agent.md"
        ((count++))
      fi
    fi
  done
  echo "$count"
}

if [[ "$TARGET" == "claude" || "$TARGET" == "all" ]]; then
  CLAUDE_SKILLS="$HOME/.claude/skills"
  CLAUDE_AGENTS="$HOME/.claude/agents"
  C_SKILLS=$(remove_skills "$CLAUDE_SKILLS")
  C_AGENTS=$(remove_agents "$CLAUDE_AGENTS" "false")
  echo -e "  [OK] Claude Code        : $C_SKILLS skill rimosse da $CLAUDE_SKILLS e $C_AGENTS agenti rimossi da $CLAUDE_AGENTS"
fi

if [[ "$TARGET" == "antigravity" || "$TARGET" == "all" ]]; then
  AG_SKILLS="$HOME/.gemini/config/skills"
  AG_SKILLS_COUNT=$(remove_skills "$AG_SKILLS")
  AG_AGENTS_COUNT=$(remove_agents "$AG_SKILLS" "true")
  echo -e "  [OK] Google Antigravity : $AG_SKILLS_COUNT skill e $AG_AGENTS_COUNT workflow agenti rimossi da $AG_SKILLS"
fi

if [[ "$TARGET" == "cursor" || "$TARGET" == "all" ]]; then
  CUR_SKILLS="$HOME/.cursor/skills"
  CUR_SKILLS_COUNT=$(remove_skills "$CUR_SKILLS")
  CUR_AGENTS_COUNT=$(remove_agents "$CUR_SKILLS" "true")
  echo -e "  [OK] Cursor             : $CUR_SKILLS_COUNT skill e $CUR_AGENTS_COUNT agenti rimossi da $CUR_SKILLS"
fi

echo -e "\n  Disinstallazione completata con successo!"
echo -e "  Le altre tue skill e configurazioni personali sono rimaste intatte.\n"
