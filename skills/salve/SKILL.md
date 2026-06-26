---
name: salve
description: Use when the user says "salve" (or /salve) to ship and persist the current work in one shot. Persists context, commits, pushes to GitHub, opens and merges a PR into the main branch, triggers/confirms the deploy if the project has one, fast-forward-updates the local checkout, and reports evidence. Saying "salve" is the user's explicit OK to merge to the main branch and deploy. Variants - "salve doc" (doc-only, uses [skip ci], no redeploy) and "salve sem deploy" / "salve no deploy" (push + PR, do NOT merge to production).
---

# salve - ship + persist the current work

Trigger: the user writes `salve` (or `/salve`). **Saying "salve" is the user's explicit OK to merge to the main branch and deploy.** That is the one approval this skill needs; do not ask again, just run the steps and report.

Run the steps IN ORDER. Apply judgment (commit message, conflict resolution). If a step fails, STOP and report, do not push blindly past it.

## 0. Pre-flight
- `git status` and `git branch --show-current`. See what changed.
- Identify the project's main branch (`main`, `master`, or whatever the repo uses).
- **If code changed (not doc-only): run the project's tests FIRST** (e.g. `npm test`, `pytest`, `go test`). If they fail, STOP and report. Never ship broken code.

## 1. Persist context
- Update the project's own notes so the next session can continue: a `CLAUDE.md` / `README` / `NOTES.md` status section (what's done, what's next), if the project keeps one.
- `git add` only the work (**never secrets**; keep `.env` and credentials gitignored).
- Commit with a clear subject + body. Use `[skip ci]` ONLY in `salve doc` mode.

## 2. Push to GitHub
- `git push -u origin HEAD`.
- On a feature branch: `gh pr create --base <main>` then `gh pr merge <#> --squash` (the squash subject carries `[skip ci]` if this is `salve doc`).
- Merge conflict blocking: `git fetch origin <main>` -> `git merge origin/<main>` -> resolve -> push -> re-merge.
- Already on the main branch: push directly (or branch first if the project requires PRs).

## 3. Deploy (only if the project has one)
- If the host auto-deploys on push to the main branch (Render, Vercel, Fly, Railway, etc.), **confirm it ran** - check the deploy dashboard or a health endpoint (e.g. `curl -s -o /dev/null -w "%{http_code}\n" <prod-url>/health`).
- If the host does NOT auto-deploy, trigger the deploy via its CLI / API / dashboard. `salve` deploys by default.
- If the project has no deploy target, skip this step.
- `salve sem deploy`: skip the merge-to-production - push and open the PR only, do not merge.

## 4. Update the local checkout
- On the main checkout: `git -C <project-root> pull --ff-only origin <main>`.
- Confirm `behind=0, ahead=0`.

## 5. Report evidence
- Commit SHA, PR #, merge SHA, deploy/health state, local sync. Give a concrete rollback (`git revert <sha>`).

## Variants
- `salve doc` - doc-only change: use `[skip ci]` on the commit/merge, do not redeploy.
- `salve sem deploy` / `salve no deploy` - push + persist + open PR, do NOT merge to the main branch (leave the PR for the user).

## Safety
- Tests before merge. Red = stop.
- Never commit secrets.
- Merge-to-main + deploy happen only because the user said `salve`. Anything beyond that (rotating secrets, destructive migrations) is still an escalation - ask.

## Notes
- Configure once per project: tell the skill your main branch, your deploy target (or "none"), and your health URL, and it follows them. Defaults are sensible (`main`, auto-deploy-on-push, `/health`).
- Original work, MIT-licensed.
