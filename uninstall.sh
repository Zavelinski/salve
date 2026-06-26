#!/usr/bin/env bash
# Remove the salve skill from ~/.claude (or $CLAUDE_CONFIG_DIR).
set -euo pipefail
claude_dir="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
rm -rf "$claude_dir/skills/salve"
echo "salve uninstalled from $claude_dir."
