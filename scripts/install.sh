#!/usr/bin/env bash
# BIM Skills Italia — Installer per macOS/Linux
# Esegui con: curl -fsSL https://raw.githubusercontent.com/VisionXt-tech/bim-skills/main/scripts/install.sh | bash

set -euo pipefail

REPO_URL="https://github.com/VisionXt-tech/bim-skills.git"
INSTALL_DIR="$HOME/.claude/skills/bim"
TEMP_DIR="$(mktemp -d)"

echo ""
echo "  BIM Skills Italia — Installer"
echo "  by VisionXt"
echo ""

# Check git
if ! command -v git &> /dev/null; then
    echo "  ERRORE: git non trovato. Installalo prima di procedere."
    exit 1
fi

# Clone
echo "  Scaricamento skill..."
git clone --depth 1 --quiet "$REPO_URL" "$TEMP_DIR" 2>/dev/null

if [ $? -ne 0 ]; then
    echo "  ERRORE: impossibile clonare il repository."
    rm -rf "$TEMP_DIR"
    exit 1
fi

# Install
mkdir -p "$(dirname "$INSTALL_DIR")"
rm -rf "$INSTALL_DIR"
cp -r "$TEMP_DIR/skills" "$INSTALL_DIR"

# Count
SKILL_COUNT=$(find "$INSTALL_DIR" -name "SKILL.md" | wc -l | tr -d ' ')

# Cleanup
rm -rf "$TEMP_DIR"

echo ""
echo "  Installate $SKILL_COUNT skill in: $INSTALL_DIR"
echo ""
echo "  Uso: in Claude Code, digita / e cerca le skill BIM."
echo "  Aggiornamento: riesegui questo script."
echo ""
