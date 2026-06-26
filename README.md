# salve for Claude Code

[![License: MIT](https://img.shields.io/github/license/Zavelinski/claude-code-salve)](LICENSE)
[![Stars](https://img.shields.io/github/stars/Zavelinski/claude-code-salve?style=flat)](https://github.com/Zavelinski/claude-code-salve/stargazers)
[![Last commit](https://img.shields.io/github/last-commit/Zavelinski/claude-code-salve)](https://github.com/Zavelinski/claude-code-salve/commits)
[![Claude Code skill](https://img.shields.io/badge/Claude%20Code-skill-8A2BE2)](https://claude.com/claude-code)

A [Claude Code](https://claude.com/claude-code) skill that ships and persists your work in one word. Say **`salve`** and it runs the whole close-out: persist context, commit, push, open and merge a PR to your main branch, trigger/confirm the deploy, fast-forward your local checkout, and report evidence (commit/PR/merge SHAs, deploy state, rollback).

Saying `salve` is your explicit OK to merge to the main branch and deploy — that one word is the approval, so the agent stops asking and just ships.

## Prerequisites

Claude Code with `/plugin` support (v2.x+) and a shell if you use the manual fallback.

## Install

### Option 1 — Claude Code plugin marketplace (recommended)

```bash
/plugin marketplace add Zavelinski/claude-code-skills
/plugin install salve@claude-code-skills
```

Registered hooks (if any) install through the Claude Code consent UI, with no manual edit to `~/.claude/settings.json`.

### Option 2 — Manual fallback (run it yourself)

> **Security note.** This script mutates `~/.claude/settings.json` directly. Claude Code auto-mode blocks it because a third-party `UserPromptSubmit` hook that injects text into every prompt is a known risk vector. The script is benign and local-only (no network), but you must review and run it yourself. Prefer Option 1.

```bash
git clone https://github.com/Zavelinski/claude-code-salve.git
cd claude-code-salve
bash install.sh        # macOS / Linux
.\install.ps1          # Windows (PowerShell)
```

## Uninstall

```bash
/plugin uninstall salve@claude-code-skills    # Option 1
bash uninstall.sh                                # Option 2 (or uninstall.ps1 on Windows)
```

## Update

```bash
/plugin marketplace update claude-code-skills    # Option 1
# Option 2: pull the latest commit and re-run the manual fallback.
```

## The flow

0. **Pre-flight** — `git status`, find the main branch, and if code changed, **run the tests first** (red = stop, never ship broken).
1. **Persist context** — update the project's own status notes, commit the work (never secrets).
2. **Push** — push the branch; on a feature branch, open a PR and squash-merge it.
3. **Deploy** (if the project has one) — confirm the host auto-deployed, or trigger it; verify via a health check.
4. **Update local** — `git pull --ff-only` on the main checkout.
5. **Report** — commit/PR/merge SHAs, deploy/health, local sync, and a concrete rollback.

## Variants

- **`salve`** — full ship: merge to main + deploy.
- **`salve doc`** — doc-only change: commits with `[skip ci]`, no redeploy.
- **`salve sem deploy`** / **`salve no deploy`** — push and open the PR, but do **not** merge to production (leaves the PR for you).

## Safety

- Tests run before any merge; failures stop the ship.
- Secrets are never committed (`.env` stays gitignored).
- Merge-to-main and deploy happen **only** because you said `salve`. Anything more dangerous (rotating secrets, destructive migrations) is still flagged as an escalation.

## Português

A PT-BR version lives in [`variants/pt-br/`](variants/pt-br/). After installing, copy it over:

```bash
cp variants/pt-br/SKILL.md ~/.claude/skills/salve/SKILL.md
```

## License

MIT. See [LICENSE](LICENSE). Original work.

---

Part of the **[claude-code-skills](https://github.com/Zavelinski/claude-code-skills)** collection: a suite of focused, original Claude Code skills.