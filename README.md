# salve for Claude Code

A [Claude Code](https://claude.com/claude-code) skill that ships and persists your work in one word. Say **`salve`** and it runs the whole close-out: persist context, commit, push, open and merge a PR to your main branch, trigger/confirm the deploy, fast-forward your local checkout, and report evidence (commit/PR/merge SHAs, deploy state, rollback).

Saying `salve` is your explicit OK to merge to the main branch and deploy — that one word is the approval, so the agent stops asking and just ships.

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

## Install

```bash
git clone https://github.com/Zavelinski/salve.git
cd salve
```

**macOS / Linux**
```bash
bash install.sh
```

**Windows (PowerShell)**
```powershell
.\install.ps1
```

Skill-only install (no hooks, no `settings.json` changes). Restart Claude Code, then say **`salve`** when you want to ship.

> Configure once per project: tell it your main branch, deploy target (or "none"), and health URL. Defaults are sensible (`main`, auto-deploy-on-push, `/health`).

## Português

A PT-BR version lives in [`variants/pt-br/`](variants/pt-br/). After installing, copy it over:

```bash
cp variants/pt-br/SKILL.md ~/.claude/skills/salve/SKILL.md
```

## Uninstall

```bash
bash uninstall.sh      # macOS / Linux
```
```powershell
.\uninstall.ps1        # Windows
```

## License

MIT. See [LICENSE](LICENSE). Original work.
