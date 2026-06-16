---
name: rpm-deep-augment
description: RedPrinting 카테고리별 분석 자료(reverse+metamodel+gap)를 codex-cli(OpenAI 모델)에 주고 "분석이 놓친 옵션/자재/공정/관리축/제약/엣지케이스/도메인 정보"를 독립 second-opinion으로 심층 발굴하는 방법론 스킬(후니 RP-Meta 하네스). 환각 경계(codex 제안=unverified 가설·라이브/엑셀 권위 검증 전 사실 아님), codex exec read-only 안전 호출(codex-cli 위임·output-last-message 수집), 갭발굴 질문 설계(checkable 주장 강제), 결과 triage(신규 후보→stage 라우팅/기존→폐기/오류→거부), summary 포인터를 제공한다. 'codex 심층보강', '누락 정보 확인', 'codex second opinion', '분석 외 정보', 'codex-cli 검토', '심층 발굴', 'deepcheck', '심층보강 다시', '추가 정보 확인' 작업 시 반드시 이 스킬을 사용. 실제 codex exec 명령 상세는 codex-cli 스킬이, 발굴 후보의 라이브 검증은 rpm-gap-vessel/rpm-validation이 담당한다.
---

# rpm-deep-augment — codex-cli Deep-Augmentation Method

Feed a category's analysis to an independent OpenAI model and mine for what we missed, then triage its output
into verifiable candidates. External opinion is a hypothesis, never a finding.

## Why this method

A single pipeline can have blind spots — an option axis no sampled product showed, a domain fact nobody
encoded. A different model with different training is a cheap way to surface those blind spots. But that model
also hallucinates, so its value is *only* as a candidate generator: every suggestion must be verifiable against
후니 live / 권위 엑셀 / RedPrinting live before it counts. Skipping that check imports hallucinations as facts.

## Workflow

1. **Assemble context.** Read the category's reverse.md + relevant metamodel/gap rows. Summarize concisely
   (codex has no repo access in read-only) — what we found: axes, options, materials, processes, verdicts.
2. **Design gap-finding prompt.** Ask codex targeted, *checkable* questions:
   - "What order-option axes does this product category typically have that are missing from this list?"
   - "What materials / processes / finishes / constraints are we likely missing?"
   - "What edge cases or variant patterns would break this model?"
   - "What industry-standard domain facts about this category should inform a base-data schema?"
   Demand specific, falsifiable claims; reject requests for vague advice.
3. **Pre-flight codex + model fallback (HARD).** Two traps: `codex login status` falsely reports "Logged in"
   on an *expired* token, AND a codex deadlock is often a *model* problem, not a token one (gpt-5-codex/gpt-5
   are `400 not supported` on a ChatGPT account; gpt-5.5 works). Run
   `.claude/skills/rpm-visualize/scripts/codex-preflight.sh` (pings supported model candidates, gpt-5.5 first)
   — it prints `AVAILABLE model=<m>` / `DEADLOCK` / `AUTH_STALE` / `UNAVAILABLE`. On `AVAILABLE`, call codex
   with `-m <m>` (step 4). On any non-AVAILABLE, mark `deepcheck pending` — deepcheck has **no text fallback**
   (its whole value is an external model's opinion; mermaid can't substitute). For `AUTH_STALE`, ask the user
   to re-run `codex login` (or `codex login --device-auth` if headless). `DEADLOCK` = all model candidates
   failed (add a newer model to the preflight). Never fabricate candidates.
4. **Call codex-cli (read-only, model from preflight).** Load the `codex-cli` skill and follow it: `codex exec
   -m <model> --sandbox read-only --output-last-message /tmp/rpm-deepcheck-{CAT}.md "<prompt>"` (use the `<m>`
   from `AVAILABLE model=<m>`). Read-only = no side effects (safe default). Collect the answer from the output
   file (stdout has noise). Never paste credentials/.env into the prompt.
5. **Triage the output.** Classify every item:
   - **(a) new candidate** → tag `unverified` + route: new axis→metamodel-architect, new gap→gap-analyst,
     missed option→reverse-engineer, vessel implication→vessel-designer.
   - **(b) already covered** → discard with a one-line note (so it isn't re-mined).
   - **(c) wrong / inapplicable** → reject with the reason.
   Prefer checkable candidates; drop unfalsifiable ones.
6. **Record & route.** Write `categories/{CAT}/deepcheck.md` (consult summary + triaged candidates, each with
   how-to-verify) and append a pointer to summary.md. Send candidates to owning agents; hand the list to validator.

## Rules (HARD)

- **External opinion ≠ fact** — every codex claim is `unverified` until checked against live/엑셀/RP live.
- **Live wins on conflict** — if codex contradicts a verified finding, keep ours, log a double-check candidate, never auto-flip.
- **Checkable only** — keep claims that can be tested; drop platitudes.
- **Read-only & safe** — codex exec read-only; never write repo/DB via codex; no credentials in prompt.
- **Honest empty** — if codex yields nothing actionable, say so; don't pad with invented gaps.

## Outputs
- `_workspace/huni-rpmeta/categories/{CAT}/deepcheck.md` — consult summary + triaged candidate list.
- `_workspace/huni-rpmeta/categories/{CAT}/summary.md` — deepcheck pointer.

## Done when
codex was consulted read-only, output is triaged into routed `unverified` candidates (or an honest "none"),
and the list is handed to the owning agents + validator for verification. No candidate is adopted here.
