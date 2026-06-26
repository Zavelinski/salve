# Install the salve skill into ~/.claude (or $env:CLAUDE_CONFIG_DIR).
$ErrorActionPreference = 'Stop'

$repo = Split-Path -Parent $MyInvocation.MyCommand.Path
$claudeDir = if ($env:CLAUDE_CONFIG_DIR) { $env:CLAUDE_CONFIG_DIR } else { Join-Path $HOME '.claude' }

New-Item -ItemType Directory -Force -Path (Join-Path $claudeDir 'skills\salve') | Out-Null
Copy-Item (Join-Path $repo 'skills\salve\SKILL.md') (Join-Path $claudeDir 'skills\salve\SKILL.md') -Force

Write-Host ""
Write-Host "salve installed into $claudeDir"
Write-Host "Restart Claude Code, then say 'salve' to ship and persist the current work."
