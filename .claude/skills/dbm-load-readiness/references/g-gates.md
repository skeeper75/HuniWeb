# G1–G9 Completion Gates — criteria, evidence, verdict format

Table of contents:
1. Purpose & verdict rule
2. The nine gates (criteria + evidence each)
3. Gate verdict document format

---

## 1. Purpose & verdict rule

These gates are the harness's Definition of Done for the load-readiness track. The bundle is "ready"
only when **all of G1–G9 are PASS**. A single FAIL = not ready (route back, re-gate the changed steps).

Each gate is a verifiable proposition, not a feeling. "Seems loadable" is never evidence. Every PASS
cites concrete artifacts (file, row, column, count, or query result). Default a gate to FAIL when the
evidence is missing or ambiguous — the burden is on the bundle to prove readiness.

Authority order when two sources disagree (apply throughout): live DB > Excel explicit value > 실무진
cell-text price meaning > 계산공식집 draft > prior validation verdict. Conflicting data is never
deleted — keep both with provenance.

## 2. The nine gates

### G1 — `t_*` whitelist compliance
- **PASS when:** every target table in the manifest/load files is in the `t_*` whitelist
  (`references/fk-load-order.md` §whitelist). Count of load rows targeting Django/non-`t_` tables = 0.
- **Evidence:** list of distinct target tables vs the whitelist; the 0-count of out-of-whitelist rows.

### G2 — Lossless extraction
- **PASS when:** Excel source → L1 extract round-trips 100% (non-empty cells preserved, no dropped
  block). Invented values = 0, dodge (placeholder substituted instead of searching live) = 0.
- **Evidence:** the L1 9-gate self-check result from `06_extract/`; a re-diff of a sample of original
  xlsx cells vs L1; the invention/dodge counts from the prior adversarial validation.

### G3 — Mapping integrity
- **PASS when:** every load row's columns trace 1:1 to an Excel source column (or a documented
  derived/default). Natural-key duplicates within a file = 0. Under-load (a whole Excel block missing
  from the load) = 0. Silent fallback (missing value quietly defaulted) = 0.
- **Evidence:** per-table source↔target column map; natural-key dup query = 0; block-coverage tally
  (Excel blocks vs loaded blocks); provenance back-reference for a sampled set of rows.

### G4 — Schema fit
- **PASS when:** every value satisfies its column's type, length, NOT NULL, and CHECK constraint.
  Length overflow (e.g. `comp_cd` > `varchar(50)`) = 0.
- **Evidence:** per-column type/length/null/CHECK check results (computed locally against `columns.csv`
  or via live read-only lookups); the 0-count of overflow/violation.

### G5 — FK integrity + load order
- **PASS when:** every FK reference in the load files resolves to (a) a row already live, or (b) a row
  in the code pre-load step (00). The manifest's load order is a valid topological sort of the live FK graph.
- **Evidence:** per-FK existence check (live `SELECT` or pre-load membership); the topo-sort order with
  the FK edge fixing each step; 0 unresolved parents, 0 cycles.

### G6 — DRY-RUN passes
- **PASS when:** loading the bundle inside `BEGIN … ROLLBACK` yields 0 constraint violations
  (type/length/NOT NULL/CHECK/FK/PK-dup). If violations occur, they are reported by table/row/constraint.
- **Evidence:** the DRY-RUN transcript (rolled back), violation count = 0, and confirmation that nothing
  was committed. Procedure: `references/dry-run.md`. Requires lead authorization; otherwise local checks.

### G7 — Blocked / escalation explicit
- **PASS when:** every non-insertable row is in `blocked-and-gaps.md` with its blocking reason and the
  exact condition that unblocks it (e.g. "후니 registers siz_cd X in `t_siz_sizes`"). GAP items
  (cannot be losslessly expressed) are escalated, not force-flattened. Nothing is silently dropped.
- **Evidence:** the blocked/GAP list with reason + unblock condition each; reconciliation that
  (insertable + blocked + GAP) = total mapped rows (no silent disappearance).

### G8 — Reproducibility
- **PASS when:** extract → transform → build runs from scripts; the same validated inputs reproduce the
  same bundle. No artifact exists that was only hand-edited and cannot be regenerated.
- **Evidence:** the script paths + a re-run producing an identical bundle (or a documented diff of 0).

### G9 — Independent verification
- **PASS when:** the build (dbm-load-builder) and the gate (dbm-validator) were performed by separate
  agents, and the gate raised ≥1 real defect that was then fixed (evidence the gate is not rubber-stamping).
- **Evidence:** the gate's finding log with at least one defect found→fixed; confirmation the validator
  did not author the bundle it is gating.

## 3. Gate verdict document format

Write to `_workspace/huni-dbmap/03_validation/load-readiness-gate.md` (Korean prose, English identifiers):

```
# 적재 준비 게이트 판정 — round-4

## 종합 판정: GO / NO-GO
(한 줄 사유)

## 게이트별 결과
| Gate | 결과 | 근거(파일·행·쿼리·카운트) |
|------|------|--------------------------|
| G1 t_* 화이트리스트 | PASS/FAIL | ... |
| G2 무손실 추출 | PASS/FAIL | ... |
| ... | ... | ... |
| G9 독립 검증 | PASS/FAIL | ... |

## 발견(Findings)
- [BLOCKER/MAJOR/MINOR] 파일:행:열 — 위반 제약 — 제안 수정 — 라우팅 대상(builder/designer/schema)

## 적재 가능성 요약
- 즉시 적재가능 N행 / 차단 M행 / GAP K건
- 코드행 선적재 제안 X건 (사용자 승인 대기)
```

A NO-GO lists exactly which gates failed and where each finding routes. Carry forward still-valid PASS
verdicts with a note when re-gating only changed steps.
