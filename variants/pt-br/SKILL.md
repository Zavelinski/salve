---
name: salve
description: Use quando o usuario disser "salve" (ou /salve) para entregar e persistir o trabalho atual de uma vez. Persiste contexto, commita, sobe no GitHub, abre e mergeia um PR na branch principal, dispara/confirma o deploy se o projeto tiver, atualiza a checkout local com fast-forward e reporta evidencia. Dizer "salve" e o OK explicito do usuario para mergear na branch principal e deployar. Variantes - "salve doc" (so-doc, usa [skip ci], sem redeploy) e "salve sem deploy" (push + PR, NAO mergear em producao).
---

# salve - ship + persistir o trabalho atual

Gatilho: o usuario escreve `salve` (ou `/salve`). **Dizer "salve" e o OK explicito do usuario para mergear na branch principal e deployar.** E a unica aprovacao que o skill precisa; nao perguntar de novo, executar os passos e reportar.

Executar os passos NA ORDEM. Aplicar julgamento (mensagem de commit, resolucao de conflito). Se um passo falhar, PARAR e reportar, nao seguir cego.

## 0. Pre-flight
- `git status` e `git branch --show-current`. Ver o que mudou.
- Identificar a branch principal do projeto (`main`, `master`, ou a que o repo usar).
- **Se mudou codigo (nao for so-doc): rodar os testes do projeto ANTES** (ex.: `npm test`, `pytest`, `go test`). Se RED, PARAR e reportar. Nunca subir codigo quebrado.

## 1. Persistir contexto
- Atualizar as notas do proprio projeto pra proxima sessao continuar: uma secao de status num `CLAUDE.md` / `README` / `NOTES.md` (o que foi feito, o que falta), se o projeto mantiver.
- `git add` so do trabalho (**nunca segredos**; `.env` e credenciais ficam gitignored).
- Commit com subject claro + corpo. `[skip ci]` SO no modo `salve doc`.

## 2. Subir no GitHub
- `git push -u origin HEAD`.
- Em branch de feature: `gh pr create --base <principal>` e depois `gh pr merge <#> --squash` (o subject do squash carrega `[skip ci]` se for `salve doc`).
- Conflito de merge bloqueando: `git fetch origin <principal>` -> `git merge origin/<principal>` -> resolver -> push -> re-mergear.
- Ja na branch principal: push direto (ou branchar antes se o projeto exige PR).

## 3. Deploy (so se o projeto tiver)
- Se o host auto-deploya no push pra branch principal (Render, Vercel, Fly, Railway, etc.), **confirmar que rodou** - ver o dashboard de deploy ou um endpoint de health (ex.: `curl -s -o /dev/null -w "%{http_code}\n" <prod-url>/health`).
- Se o host NAO auto-deploya, disparar o deploy via CLI / API / dashboard dele. `salve` deploya por padrao.
- Se o projeto nao tem deploy, pular este passo.
- `salve sem deploy`: pular o merge-pra-producao - so push e abrir o PR, nao mergear.

## 4. Atualizar a checkout local
- Na checkout principal: `git -C <raiz-do-projeto> pull --ff-only origin <principal>`.
- Confirmar `behind=0, ahead=0`.

## 5. Reportar evidencia
- Commit SHA, PR #, merge SHA, estado do deploy/health, sync local. Rollback concreto (`git revert <sha>`).

## Variantes
- `salve doc` - mudanca so-de-doc: usar `[skip ci]` no commit/merge, nao redeploya.
- `salve sem deploy` - push + persistir + abrir PR, NAO mergear na branch principal (deixa o PR pro usuario).

## Seguranca
- Testes antes do merge. Red = parar.
- Nunca commitar segredos.
- Merge-na-principal + deploy so acontecem porque o usuario disse `salve`. Alem disso (rotacionar segredos, migracao destrutiva) continua sendo escalada - perguntar.

## Notas
- Configurar uma vez por projeto: dizer ao skill a branch principal, o alvo de deploy (ou "nenhum") e a URL de health, e ele segue. Defaults sensatos (`main`, auto-deploy-no-push, `/health`).
- Trabalho original, licenca MIT.
