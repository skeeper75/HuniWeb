---
name: rpm-validation
description: 후니 RP-Meta 하네스(RedPrinting 메타모델 역공학→갭→그릇) 산출물을 경계면 교차 비교로 독립 검증하는 M1~M6 게이트 방법론 스킬. M1 추출 충실성(소스 재대조·날조 적발), M2 메타모델 정합(증거 도출·오버피팅·관계 무모순), M3 추가 메타모델 타당성(distinct vs facet 재검), M4 갭 판정 정확(라이브 information_schema 재실측·dbmap 정합), M5 그릇 설계 건전성(search-before-mint·정규화·컨벤션·영향분석), M6 생성-검증 독립성(self-approve 적발·dodge-hunt). 라이브 읽기전용 재실측 강제·생성자 주장 비신뢰·점진 게이팅·단일 결함 FAIL·정직 CONDITIONAL을 제공한다. '메타모델 검증', 'RP-Meta 검증', '갭 검증', '그릇 검증', 'M게이트', 'M1 M6', '교차검증', '검증 다시', 'dodge-hunt' 작업 시 반드시 이 스킬을 사용. 생성(역공학/메타모델/갭/그릇)은 각 생성 스킬이 담당하므로 본 스킬은 검증 전용이다.
---

# rpm-validation — RP-Meta Cross-Boundary Gates (M1~M6)

Independently verify each pipeline stage by re-measuring boundaries, not by trusting the generator. Emit
GO/NO-GO/CONDITIONAL per gate with cited evidence.

## Why this method

The generator and the verifier must be separate lanes — a model that grades its own metamodel rationalizes
it. Cross-boundary QA (re-read the source, re-query the schema) is the only way to catch fabricated atoms,
overfit axes, wrong gap verdicts, and duplicate-mint vessels before they propagate.

## The gates

### M1 — Extraction fidelity (after 01_reverse)
Re-open each cited source (live capture, huni-widget asset, API field). Atoms in `01_reverse/` must match it.
Fabricated/unsourced fragments, or `unobserved` dressed as fact → FAIL.

### M2 — Metamodel soundness (after 02_metamodel)
Each axis derivable from extraction evidence; no overfit (single-product axis without clean generalization);
relationships internally consistent (no contradictory FK/composition); ERD matches dictionary.

### M3 — Discovered-axis validity (after 02_metamodel)
Re-test each `discovered-axes.md` distinctness argument. Facets mis-labeled as distinct axes → FAIL. If
evidence plainly shows a *missed* axis, note it as a gap (not an auto-FAIL).

### M4 — Gap-verdict accuracy (after 03_gap)
Re-query 후니 live `information_schema` (read-only). Every PASS/WEAK/GAP must match the live schema and be
consistent with dbmap findings. PASS citing a non-existent column, or GAP for an existing vessel → FAIL.
Verify both sides of each verdict.

### M5 — Vessel soundness (after 04_vessel)
Re-check search-before-mint (existing structure truly can't hold it), normalization (lossless/non-redundant/
no bad dependency), convention fit (t_* patterns), impact completeness (rows/FK/apply-order/backfill/
rollback). Duplicate-mint or convention drift → FAIL.

### M6 — Generation/verification independence (all stages)
Confirm no stage self-approved; confirm you re-derived key facts rather than echoing the generator.
Dodge-hunt: per stage, pick the riskiest claim and actively try to break it.

## Method rules

1. **Re-measure, don't trust.** Re-run live read-only queries and re-open captures. Generator assertions are
   hypotheses until reproduced.
2. **Incremental.** Gate each stage as it completes, not one pass at the end.
3. **One real defect fails the gate.** No averaging. Cite file:line + your re-measurement.
4. **Read-only, safe.** SELECT / information_schema only; never write DB; never submit to RedPrinting; never print credentials.
5. **Honest CONDITIONAL.** If something couldn't be verified (live down, capture missing), mark CONDITIONAL — never silent PASS.

## Outputs
- `_workspace/huni-rpmeta/05_validation/mgate-verdict.md` — per gate verdict + evidence + defects.
- `_workspace/huni-rpmeta/05_validation/_defects.md` — actionable defects routed to the owning agent.

## Done when
M1~M6 each carry GO/NO-GO/CONDITIONAL with reproduced evidence; every defect is cited and routed; a NO-GO
blocks its stage until the owner revises and you re-gate.
