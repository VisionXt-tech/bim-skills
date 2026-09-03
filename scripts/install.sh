#!/usr/bin/env bash
# BIM Skills Italia - Multi-Agent Installer (macOS & Linux)
# Esempi d'uso con una riga di codice (One-Liner):
#
#   Installazione guidata / interattiva:
#     curl -fsSL https://raw.githubusercontent.com/VisionXt-tech/bim-skills/main/scripts/install.sh | bash
#
#   Installazione diretta per singolo strumento:
#     curl -fsSL https://raw.githubusercontent.com/VisionXt-tech/bim-skills/main/scripts/install.sh | bash -s -- --target claude
#     curl -fsSL https://raw.githubusercontent.com/VisionXt-tech/bim-skills/main/scripts/install.sh | bash -s -- --target antigravity
#     curl -fsSL https://raw.githubusercontent.com/VisionXt-tech/bim-skills/main/scripts/install.sh | bash -s -- --target cursor
#     curl -fsSL https://raw.githubusercontent.com/VisionXt-tech/bim-skills/main/scripts/install.sh | bash -s -- --target all

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

REPO_URL="https://github.com/VisionXt-tech/bim-skills.git"

echo -e "\n  ========================================================"
echo -e "    BIM Skills Italia - Multi-Agent Installer (VisionXt)   "
echo -e "  ========================================================\n"

# Modalità guidata se il target non è specificato e il terminale è interattivo
if [[ -z "$TARGET" || "$TARGET" == "interactive" ]]; then
  if [[ -t 0 ]]; then
    echo -e "  Seleziona l'ambiente in cui installare le skill e gli agenti BIM:"
    echo -e "    [1] Claude Code        (~/.claude/skills e ~/.claude/agents)"
    echo -e "    [2] Google Antigravity (~/.gemini/config/skills)"
    echo -e "    [3] Cursor             (~/.cursor/skills)"
    echo -e "    [4] Tutti gli ambienti (Claude Code + Antigravity + Cursor) [Consigliato]"
    echo -e "    [0] Esci senza installare\n"
    
    read -r -p "  Digita il numero dell'opzione desiderata [1-4, default: 4]: " CHOICE
    case "${CHOICE:-4}" in
      1) TARGET="claude" ;;
      2) TARGET="antigravity" ;;
      3) TARGET="cursor" ;;
      0) 
        echo -e "\n  Installazione annullata dall'utente.\n"
        exit 0
        ;;
      *) TARGET="all" ;;
    esac
  else
    TARGET="all"
  fi
fi

echo -e "  -> Ambiente di destinazione selezionato: ${TARGET}\n"

# Determina sorgente (locale o clonata)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd || echo "")"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
TEMP_DIR=""

if [[ -n "$SCRIPT_DIR" && -d "$REPO_ROOT/skills" ]]; then
  SOURCE_ROOT="$REPO_ROOT"
else
  if ! command -v git &> /dev/null; then
    echo -e "  ERRORE: git non trovato. Installalo prima di procedere."
    exit 1
  fi
  TEMP_DIR="$(mktemp -d)"
  echo -e "  Scaricamento repository openBIM..."
  if ! git clone --depth 1 --quiet "$REPO_URL" "$TEMP_DIR" 2>/dev/null; then
    echo -e "  ERRORE: download fallito. Verifica la connessione e riprova."
    rm -rf "$TEMP_DIR"
    exit 1
  fi
  SOURCE_ROOT="$TEMP_DIR"
fi

SKILLS_SOURCE="$SOURCE_ROOT/skills"
AGENTS_SOURCE="$SOURCE_ROOT/agents"

install_skills_flattened() {
  local dest_dir="$1"
  mkdir -p "$dest_dir"
  local count=0
  while IFS= read -r skill_file; do
    local skill_dir
    skill_dir="$(dirname "$skill_file")"
    local skill_name
    skill_name="$(basename "$skill_dir")"
    local target_folder="$dest_dir/$skill_name"
    mkdir -p "$target_folder"
    cp "$skill_file" "$target_folder/SKILL.md"
    ((count++))
  done < <(find "$SKILLS_SOURCE" -type f -name "SKILL.md")
  echo "$count"
}

install_agents() {
  local dest_dir="$1"
  local as_skill="$2"
  mkdir -p "$dest_dir"
  local count=0
  for agent_file in "$AGENTS_SOURCE"/*.md; do
    [[ -f "$agent_file" ]] || continue
    local agent_filename
    agent_filename="$(basename "$agent_file")"
    local agent_name="${agent_filename%.md}"
    if [[ "$as_skill" == "true" ]]; then
      local target_folder="$dest_dir/$agent_name"
      mkdir -p "$target_folder"
      cp "$agent_file" "$target_folder/SKILL.md"
    else
      cp "$agent_file" "$dest_dir/$agent_filename"
    fi
    ((count++))
  done
  echo "$count"
}

clean_legacy_agents() {
  local dir="$1"
  local is_folder="$2"
  local legacy=("gara-bim" "delivery-team" "cde-manager" "quality-gate" "asset-manager" "revit-dev")
  for l in "${legacy[@]}"; do
    if [[ "$is_folder" == "true" ]]; then
      rm -rf "$dir/$l"
    else
      rm -f "$dir/$l.md"
    fi
  done
}

if [[ "$TARGET" == "claude" || "$TARGET" == "all" ]]; then
  CLAUDE_SKILLS="$HOME/.claude/skills"
  CLAUDE_AGENTS="$HOME/.claude/agents"
  clean_legacy_agents "$CLAUDE_AGENTS" "false"
  C_SKILLS=$(install_skills_flattened "$CLAUDE_SKILLS")
  C_AGENTS=$(install_agents "$CLAUDE_AGENTS" "false")
  echo -e "  [OK] Claude Code        : $C_SKILLS skill in $CLAUDE_SKILLS e $C_AGENTS agenti in $CLAUDE_AGENTS"
fi

if [[ "$TARGET" == "antigravity" || "$TARGET" == "all" ]]; then
  AG_SKILLS="$HOME/.gemini/config/skills"
  clean_legacy_agents "$AG_SKILLS" "true"
  AG_SKILLS_COUNT=$(install_skills_flattened "$AG_SKILLS")
  AG_AGENTS_COUNT=$(install_agents "$AG_SKILLS" "true")
  echo -e "  [OK] Google Antigravity : $AG_SKILLS_COUNT skill e $AG_AGENTS_COUNT workflow agenti in $AG_SKILLS"
fi

if [[ "$TARGET" == "cursor" || "$TARGET" == "all" ]]; then
  CUR_SKILLS="$HOME/.cursor/skills"
  clean_legacy_agents "$CUR_SKILLS" "true"
  CUR_SKILLS_COUNT=$(install_skills_flattened "$CUR_SKILLS")
  CUR_AGENTS_COUNT=$(install_agents "$CUR_SKILLS" "true")
  echo -e "  [OK] Cursor             : $CUR_SKILLS_COUNT skill e $CUR_AGENTS_COUNT agenti in $CUR_SKILLS"
fi

if [[ -n "$TEMP_DIR" && -d "$TEMP_DIR" ]]; then
  rm -rf "$TEMP_DIR"
fi

echo -e "\n  Installazione completata con successo!"
echo -e "  Come usare le skill e gli agenti:"
echo -e "    - In Claude Code        : digita / per le skill e seleziona gli agenti bim-*"
echo -e "    - In Google Antigravity : digita / per visualizzare e invocare le skill BIM"
echo -e "    - In Cursor             : usa @ per richiamare skill e agenti BIM\n"
