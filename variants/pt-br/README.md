# Variant: pt-br

Portuguese version of the `salve` skill. Same flow as the default (English) one, in PT-BR. To use it, overwrite the installed skill after running the normal installer:

```bash
cp variants/pt-br/SKILL.md ~/.claude/skills/salve/SKILL.md
```

```powershell
Copy-Item variants\pt-br\SKILL.md (Join-Path $HOME '.claude\skills\salve\SKILL.md') -Force
```

Restart Claude Code afterward.
