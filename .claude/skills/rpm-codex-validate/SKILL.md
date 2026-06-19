---
name: rpm-codex-validate
description: >
  후니 RP-Meta 하네스의 게이트 판정을 Codex(gpt-5.5)로 독립 교차검증(2nd opinion)하고 rpm-validator(Claude)
  판정과 reconcile하는 방법론 스킬(Phase 6.5). `codex exec` 읽기전용 비대화 호출
  (hqv-codex-cross-verify/scripts/codex-review.sh 재사용)로 카테고리 분석(reverse+metamodel+gap+vessel)을
  넘겨 "distinct 축 승격/부결과 M1~M6 GO/NO-GO 결론이 옳은가"를 Claude와 독립으로 판정받고, 합의/불일치를
  reconcile한다. ★핵심 경계[HARD] = Codex 판정은 외부 의견·가설(라이브/권위 검증 전 채택 금지·환각 경계·
  rpm-deepcheck 계승). ★독립성[HARD] = codex 프롬프트에 rpm-validator의 verdict를 넣지 않는다(같은 입력 독립
  판정). 검증 초점은 deepcheck(누락 발굴)와 다르다 — 결론(승격/부결·GO/NO-GO)의 정확성을 검증. codex-preflight로
  가용성 판정(AUTH_STALE 인증만료 vs DEADLOCK 모델데드락 구분), 미가용 시 "codex 미가용·Claude 단독" 명시 폴백
  (pending 금지). 구독=ChatGPT OAuth(종량과금 없음)·codex 읽기전용(파일쓰기·DB 없음)·비밀값 비노출.
  'codex 게이트 검증', 'codex 교차검증', '판정 2nd opinion', 'distinct 독립 재판정', 'reconcile',
  'M게이트 codex 검증', 'codex 검증 다시' 작업 시 반드시 이 스킬을 사용. 누락 정보 발굴(deepcheck)은
  rpm-deep-augment, Claude측 M1~M6 게이트는 rpm-validation이 담당하므로 그 작업에는 트리거하지 않는다.
---

# rpm-codex-validate — Codex Independent Gate Cross-Validation Method

Get an independent Codex (gpt-5.5) second opinion on the RP-Meta **verdict** (distinct 승격/부결 + M1~M6
GO/NO-GO), then reconcile with rpm-validator's Claude verdict to raise confidence — or surface a real conflict.

## Why this method

The RP-Meta convergence claim ("17축 재포화, 신규 그릇 최소") rests on repeated distinct-axis 부결 calls. A
single model can rationalize a 부결 that should be a 승격 (or vice-versa). An independent external model judging
the *same evidence* catches a rationalized verdict that one lane talked itself into. 후니 codex = ChatGPT
subscription (OAuth) → no per-call API metering → a cross-check lane is cheap. This is the formalization of what
already happened ad hoc ("codex도 #18 부결 독립 동의") into a repeatable Phase 6.5 gate.

## How this differs from deepcheck (do not conflate)

| | rpm-deepcheck (Phase 4.5) | rpm-codex-validate (Phase 6.5) |
|---|---|---|
| Question | "What did we **miss**?" | "Is our **verdict correct**?" |
| Mode | discovery / generative | verification of the conclusion |
| Output | `unverified` candidates → route to generators | reconcile matrix on 승격/부결 + GO/NO-GO |
| Runs | before vessel design | after rpm-validator's M-gate |

If codex surfaces a genuinely new missed item here, capture it as a one-line pointer to deepcheck and stay on
the verdict — don't turn this into a second discovery pass.

## ★Core boundaries [HARD]

- **External opinion ≠ fact.** Every codex judgment is an `unverified` hypothesis until checked against 후니
  live / 권위 엑셀 / RedPrinting live. codex "라이브 인용→checkable" is confabulation — never trust a codex
  live-citation; re-measure or route to rpm-validator. A codex verdict never auto-flips ours.
- **Independence.** Do **not** put rpm-validator's `mgate-verdict` or the 승격/부결 conclusion into the codex
  prompt. Leaking our verdict makes codex echo it and the cross-check is worthless. Give codex the evidence,
  ask for its own call.
- **Live wins on conflict.** If codex contradicts a verified live finding, keep ours; log a double-check.

## Procedure

### 1. Preflight (availability)
`scripts/codex-review.sh` runs `rpm-visualize/scripts/codex-preflight.sh` internally:
- `AVAILABLE model=<m>` → proceed with that model.
- `AUTH_STALE` → token expired (`codex login` needed) → record **"codex 미가용·Claude 단독"**.
- `DEADLOCK`/`UNAVAILABLE` → model deadlock/missing → fallback attempt, then **"codex 미가용·Claude 단독"**.
- Unavailable = **fallback, not pending** (the verdict still stands on rpm-validator alone). Distinguish token
  vs model-deadlock in the note. Never fabricate a codex verdict, never fake agreement.

### 2. Compose the prompt (independence + security)
- Include only: the category's **reverse** atoms (axes/options/materials/processes), the **discovered-axes**
  dictionary context (so codex knows the existing 17-axis frame it's testing against), and the **gap** rows.
- **Exclude** rpm-validator's verdict, the 승격/부결 label, and any GO/NO-GO. Ask codex to judge cold.
- Questions (demand a verdict + reason, not platitudes):
  1. "Beyond the listed management axes, does this category introduce a *genuinely new, distinct* axis, or does
     an existing axis absorb its variation without distortion? Verdict: NEW-AXIS / ABSORBED + why."
  2. "Any sign of fabrication, overfit (an axis only one product needs), or an implausible gap verdict?"
  3. "If NEW-AXIS: what live slot would it need that no existing axis provides? (checkable)"
- ★Never paste credentials / `.env.local` / live connection info into the prompt.

### 3. codex exec call
`scripts/codex-review.sh <prompt_file> gpt-5.5 <project_root_or_category_dir>`:
- `-s read-only` enforced (codex cannot write files or touch the DB).
- workdir = `_workspace/huni-rpmeta/categories/<CAT>/` or project root so codex can read the analysis files.
- Collect the verdict from stdout (the script returns codex output; preflight noise goes to stderr).

### 4. Reconcile
rpm-validator verdict (`05_validation/mgate-verdict-<CAT>.md`: distinct 승격/부결 + M1~M6) ↔ codex verdict:
- **Agreement** (codex ABSORBED == our 부결, or codex NEW-AXIS == our 승격) → high-confidence confirm.
- **Divergence** (codex NEW-AXIS vs our 부결, or a soundness flag we didn't raise) → investigation signal:
  decide which side matches live/권위 (re-measure read-only or route to rpm-validator), classify codex's lone
  claim as `unverified hypothesis`, keep the gate CONDITIONAL until resolved.
- The apply-side rule (승격 = ① dedicated live slot exists + ② 후니 KB can't hold it without distortion) is the
  tiebreaker — if codex says NEW-AXIS but only ① holds, our 부결 stands; record codex's ① as a deepcheck pointer.

## Outputs
- `categories/<CAT>/codex-verdict.md` — codex's independent verdict verbatim, each claim `unverified` + model used.
- `05_validation/codex-reconcile-<CAT>.md` — reconcile matrix (codex ↔ rpm-validator per item · agreements ·
  divergences with resolution + owner) + availability note.
- `categories/<CAT>/summary.md` — codex cross-validation pointer.

## Safety [HARD]
- codex `-s read-only` · no credentials in prompt · codex verdict = hypothesis (hallucination boundary).
- Unavailable = honest **"codex 미가용·Claude 단독"** (no fake GO, no pending disguise). Live wins on conflict.

## Done when
codex was consulted read-only on the *evidence only* (our verdict withheld), its independent verdict is
reconciled against rpm-validator's into an agreement/divergence matrix, divergences are routed with an owner,
and codex availability is recorded honestly. No verdict was flipped on an unverified codex claim.
