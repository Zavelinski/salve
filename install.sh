#!/usr/bin/env bash
# Install the salve skill into ~/.claude (or $CLAUDE_CONFIG_DIR).
set -euo pipefail

repo="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
claude_dir="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"

mkdir -p "$claude_dir/skills/salve"
cp "$repo/skills/salve/SKILL.md" "$claude_dir/skills/salve/SKILL.md"

echo ""
echo "salve installed into $claude_dir"
echo "Restart Claude Code, then say 'salve' to ship and persist the current work."
