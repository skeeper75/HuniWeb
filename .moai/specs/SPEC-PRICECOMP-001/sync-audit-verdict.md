---
audit_type: sync-auditor independent post-implementation review
spec_id: SPEC-PRICECOMP-001
scope: Track A only (아크릴·스티커·포스터/사인, 신설 43건) — Track B (P1~P6) excluded, matches SPEC status
audited_at: 2026-09-03
worktree: .claude/worktrees/t34 (branch WT-price-comp-rebuild)
---

# SPEC-PRICECOMP-001 Track A — Sync-Readiness Audit

## Overall Verdict: **CONDITIONAL**

Track A's underlying pricing work is well-evidenced and shows genuine rigor — four
regressions (D-14, D-15, D-17, plus the C-3 placeholder correction) were caught and
fixed by the team's own sensors before this audit, not by me. Spot-checks below confirm
the cited golden/widget evidence files exist, match the claimed row counts, and show
zero errors/zero-price rows. Gaps around live-DB re-verification, M7 screen capture, and
the unconfirmed actor behind a row deletion are disclosed candidly in §E.3/§E.4 — no
attempt to gloss over them was found.

However, two **documentation/evidence-integrity defects** keep this from a clean PASS.
Both are fixable without touching the pricing engine or re-running any live work; they
are still must-fix because a "no money regression" claim on money-critical work needs an
internally consistent audit trail, and right now the trail contradicts itself.

## Must-Fix Items

### M-1 — §E.3 baseline-attribution cites the wrong authority-excel version

`progress.md` §E.3 "baseline 귀속" states:

> 권위 = 상품마스터 260822_1 · 인쇄상품 가격표 260822_1(붙여넣기표 `grid/*.csv` 로 고정).

This is wrong. Every other citation in the same SPEC — frontmatter, `acceptance.md`,
§E.1 (`"권위 가격표: docs/huni/후니프린팅_인쇄상품_가격표_260902_2.xlsx"`), M1② (`"권위
260902_2.xlsx 를 결정론 파서로..."`), and `CHANGELOG.md` itself — names `260902_2` as the
authority. `260822_1` is a different, older file that genuinely exists on disk
(`docs/huni/후니프린팅_인쇄상품_가격표_260822_1.xlsx`, Aug 25) — this is not a typo that
resolves to nothing; it silently points the reader at a stale, wrong authority version.
This is exactly the "이 날짜를 믿지 말고 매번 확인" hazard this project has been burned by
three times before (per project memory `authority-excel-latest-version-260706`), now
recurring inside the audit-ready evidence section itself.

Per `verification-claim-integrity.md` §2, baseline-attribution must name the actual
measured baseline — a stale/wrong citation here is an unattributed claim even though the
underlying work (golden.py runs, M1② registry extraction, etc.) was in fact grounded in
`260902_2` throughout. **Fix**: correct the `260822_1` references in §E.3's baseline
paragraph to `260902_2` (both the "상품마스터" and "인쇄상품 가격표" mentions), and re-check
§E.4 which repeats the same baseline block by reference.

### M-2 — AC-003/004/005 denominator (55 vs 54) is not reconciled in `acceptance.md`

`acceptance.md` AC-003's Given-clause and 통과선 explicitly fix the denominator at
**55** ("아크릴 14 · 스티커 13 · 포스터 28, 모두 55개 상품... **분모는 55다**"). AC-004 and
AC-005 inherit the same 55.

But `progress.md`'s "리드 결정 반영" section records a live re-scoping decision:

> **분모 2. 54 채택.** 정의 = 판정 시각의 `t_wgt_widgets.sts_typ_cd='WGT_STS_TYPE.02'`(게시됨)
> ... → 아크릴 **13** · 스티커 13 · 포스터 28. **AC-003 · AC-004 · AC-005 분모를 54로 정정**하고
> 판정 시각을 함께 적는다.

And the actual delivered evidence used 54 throughout, not 55:
- M1④ golden table: "범위 안 상품 **54 / 54**"
- M5 widget diagnostic: "분모 ... `in_scope=Y` = **54상품**"
- §E.3 §baseline 귀속: "위젯 진단 분모 ... **54상품**"

I confirmed the cited files match these counts (`golden-m5.csv` = 142 lines = 141 data
rows as claimed; `widget-diag-m5.csv` = 105 lines = 104 rows as claimed; `price_nonzero`
column has zero `N` rows; `errors` column is empty for all rows).

The problem is not that 54 is wrong — the lead's re-scoping rationale (one acrylic
product's publish status changed between the SPEC being written and the live
measurement) is sound and transparently recorded. The problem is that `acceptance.md`
— the document whose text is what "AC-003 PASS" is measured against — was **never
amended** to reflect this. This SPEC otherwise treats every denominator change as
HISTORY-worthy (see `acceptance.md`'s own v0.2.0 through v0.5.1 log entries, several of
which exist solely to correct a denominator). A change of this kind landing only in
`progress.md`'s run-log, with `acceptance.md` still reading "55" unmodified, means a
literal reading of `acceptance.md` cannot currently be said to PASS AC-003/004/005 —
only a reading that also cross-references `progress.md`'s embedded correction can.
**Fix**: add a HISTORY entry to `acceptance.md` recording the 55→54 denominator
correction (with the `in_scope=Y` / publish-status rationale and judgment timestamp,
same as `progress.md` already records), and update the AC-003/004/005 body text
accordingly. This is a documentation edit, not new verification work.

### M-3 — AC-006 (orphan-vessel check) has no final-state re-verification after the M6 rollback + concurrent staff rebinding

`progress.md`'s own "병행 쓰기 원장" section documents that a separate actor
(`huniprinting`) created 29 new `FORM_*` formulas during the M6 window and rebound 31
poster products away from the team's `PRF_*` formulas to these new formulas — and that
M6's own deprecation of the 34 old vessels was then **fully rolled back** (`use_yn`
N→Y) at staff's request. The rollback's own verification checked only that the rollback
matched the pre-M6 snapshot ("스냅샷 38개 전건 `use_yn`·`del_yn` 일치") — it did not re-run
AC-006's orphan query in this final, post-rebind state. Given that formula ownership is
now explicitly staff's responsibility ("§E.3 잔여 위험 3"), whether the reverted-to-`Y`
old vessels are still legitimately non-orphan (referenced by something) or have become
newly orphaned by the `FORM_*` rebind is exactly the class of question AC-006 exists to
catch, and it is currently unanswered. This is adjacent to, but not identical with, the
already-disclosed Gap #1 (poster-31 golden/widget staleness) — that gap covers *price*
correctness; this one covers *orphan-vessel* correctness, which golden/widget diagnostics
do not test. **Fix**: either run AC-006's orphan query (`use_yn=Y` AND no referencing
formula) once more against current live state and record it, or add this explicitly as a
named Gap in §E.3/§E.4 rather than leaving it implicit inside the "병행 쓰기" narrative.

## Nice-to-Have / Optional Observations (non-blocking)

- **Frontmatter `status: draft` despite substantial completed run-phase work.** All four
  SPEC files (`spec.md`, `plan.md`, `acceptance.md`, `progress.md`) still read
  `status: draft` even though `§E.2`/`§E.3` document a large, largely-converged run
  phase. This is **already self-disclosed** by manager-docs in `progress.md`'s own
  `frontmatter_status_transitions.*` block, which correctly identifies that `draft →
  in-progress` is outside manager-docs' transition authority
  (`spec-frontmatter-schema.md` § Status Transition Ownership Matrix) and declines to
  force it. I agree with that self-assessment: this is a process/orchestration gap (the
  `draft → in-progress` transition was apparently never triggered during run-phase entry),
  not a defect in the pricing work itself. It is worth surfacing to the orchestrator as a
  blocker to resolve before this SPEC can be considered lifecycle-consistent, but it should
  not block Track A's sync content from landing.
- A single consolidated AC-007 (fingerprint) diff across the *entire* Track A campaign
  (M1 baseline → final state, after M4/M6/rollback and the concurrent `huniprinting`
  writes) was never run — only piecewise checks at M2/M3 checkpoints, before the
  concurrent-write complications arose. The team's own reasoning for why they pivoted to
  direct-path verification instead of a final AC-007 diff (§ "병행 쓰기 원장": "골든 대조로는
  M6를 귀속할 수 없다") is sound, but a reader relying on AC-007 as written would expect a
  final before/after checksum comparison to exist, and it does not for the post-rollback
  state. Worth a note in Gaps if this SPEC is revisited.
- Gaps disclosure in §E.3/§E.4 (poster-31 staleness, M6 post-verification, M7 skip,
  `COMP_STK_PRINT` deletion actor, direct-input coverage) reads as honest and specific
  rather than hedged — each names the exact mechanism of why it is unverified rather than
  a generic disclaimer. No evidence of a glossed-over or minimized gap was found beyond
  M-3 above.
- Track A/Track B scope separation is used correctly throughout: `sync_status: 트랙 A
  부분 완료(partial)`, CHANGELOG's Notes section explicitly states Track B is out of
  scope, and the AC identifier count check (`grep -oE 'AC-...' | sort -u | wc -l` → 20)
  confirms no AC was silently dropped from the count. This does not read as the SPEC's
  status model being misused to claim more than Track A.

## Spot-Checks Performed (read-only, no live DB / no script re-execution)

| Claim | Check | Result |
|---|---|---|
| `golden-m5.csv` = 141 lines, PRD_000146 discount(300) preserved | `wc -l` + `grep PRD_000146` | 142 lines (141 data + header) ✓; discount row present with renamed vessel `아크릴_투명3T_출력가`, rate 30%, 750000→525000 ✓ |
| `widget-diag-m5.csv` = 104 lines, PRICE=0 0건, errors 0건 | `wc -l` + `awk` column scan | 105 lines (104 data + header) ✓; `price_nonzero` has no `N` rows ✓; `errors` column empty for all rows ✓ |
| AC-005 "재단만" (cutting-only) combination present for mesh banner and non-zero | `grep PRD_000139` in widget-diag-m5.csv | Default combo uses `opt_cd=OPV_001000` (= "재단만" per D-16 table), `final_price=20000`, `price_nonzero=Y` ✓ |
| `HANDOFF-TO-STAFF-260903.md`, `HANDOFF-vessels-43.csv` exist | `ls` | Both present ✓ |
| `golden/`, `m4/`, `screens/` directories with cited artifacts exist | `ls` | All present with dated files matching narrative timestamps ✓ |
| Authority excel `260902_2.xlsx` vs `260822_1.xlsx` both exist on disk | `ls docs/huni/*.xlsx` | Both exist as distinct files (506,750 bytes / Sep 2 18:56 vs Aug 25 17:53) — confirms M-1 is a real citation error, not a harmless alias |
| CHANGELOG.md Track A entry present, dates/paths consistent | `Read` | Present, cites `260902_2.xlsx` correctly, cites `progress.md §E.3` correctly |

## Summary for the Orchestrator

Do not treat this as a rejection of the pricing work — the underlying evidence is
strong and the disclosed gaps are honest. Treat it as: fix M-1 and M-2 (both pure
documentation edits — no live DB touch, no re-running scripts), decide on M-3 (either
run one more read-only orphan query, or explicitly log it as a Gap), then this Track A
sync is ready to close. None of the three block on Track B or on any capability this
session lacks (all three are read-only-verifiable or doc-only fixes).
