---
id: SPEC-WIDGET-WIRING-001
doc: progress
version: "0.1.0"
updated: 2026-08-22
status: completed
---

# 진행 원장 — SPEC-WIDGET-WIRING-001

## 상태

| 단계 | 상태 | 비고 |
|---|---|---|
| plan (SPEC 작성) | **완료** 2026-08-21 | 카드 t1 · 세션 `plan-huniweb`(워크트리 design-viewer) |
| run (M0~M6) | **완료** 2026-08-22 | run 세션 `run-huniweb`(메인 체크아웃) — M0~M6·AC1~AC8 전부 PASS |
| review | **완료** 2026-08-22 | 세션 `review-huniweb`(`--deep`+오탐검증) — 오탐 57·권고 반영 run 교정 완료. `out/REVIEW-260822.md` |
| sync | **완료** 2026-08-22 | 세션 `sync-huniweb` — HANDOFF/CHANGELOG 작성·수치 확정·커밋(3-phase close) |

## §E.2 Run-phase Evidence

### B-2 환경 확인 (착수 직후 · PASS)
- `raw/.venv/bin/python -c "import django..."` → `ok 5.2.15` (django 포함 venv = **raw/.venv**)
- `raw/webadmin/.env` 존재(DATABASE_URL) · `.env.local` RAILWAY_DB_* 6개
- **가정 기록**: 센서 주석의 `../.venv` 는 `raw/.venv` 이고, `raw/webadmin/.venv` 는 django 부재 → 어댑터는 raw/.venv 우선 사용.

### M0 스냅샷 갱신 (PASS · AC1)
- 명령: `bash _workspace/_foundation/live-snapshot/snapshot.sh` → exit 0
- 출력: `SNAPSHOT OK: _workspace/_foundation/live-snapshot/snap_20260821_2319 (52 tables) · latest -> snap_20260821_2319`
- 분모: `awk -F, '$17=="Y" && $21=="N"' t_prd_products.csv | wc -l` → **266** (완제품 211·셋트구성원 40·기성 15) == 라이브 실측 266 → **AC1 PASS**

### M1 hdx 가격 레이어 as-is 재실행 (PASS — 무수정)
- 명령: `python3 _workspace/_foundation/hdx/diagnose_remediate.py --scope price --round 26 --note "widget-wiring t1 M1"` → exit 1(=NO-GO·결함 존재의 정상 신호)
- 출력 요지: `defects=553 => NO-GO` (wiring 8 · dim_conformance 69 · contribution 387 · component_merge 0 · calcability 4 · option_cpq 18 · qty_rule 56 · platesize 0 · price_grid 11 · 돈영향 89 · 치명 4)
- 보드: `_workspace/_foundation/hdx/board/defect-board.csv` — **주의: 위젯 스코프 실행 시 같은 파일을 덮어씀** → M2 완료 후 price 스코프 재실행 + `out/defects/price-defects.jsonl` 변환 저장으로 승계.

### M2 위젯 어댑터 (진행 중 → 완료 시 갱신)
- 신규: `_workspace/_foundation/hdx/diagnose/widget_wiring_dx.py` (센서 5종 어댑터·이식)
- 최소 수정: `hdx/diagnose_remediate.py` (widget 스코프 등록 + JSONL 덤프 — hdx 루트 파일, AC3 diff-0 대상 아님)
- 시행착오 기록: ① `parents[5]` 경로 오타 → venv 부재 오탐. ② `raw/webadmin/.venv`(django 부재) 사용 → 센서 크래시가 exit 1 로 묵음 통과 → `_run_sensor` 에 "exit1·JSON0·stderr" 크래시 명시 FAIL 추가 후 수정(raw/.venv 우선).

### M3 sim-meta 하베스터 (PASS)
- 신규: `_workspace/huni-widget-wiring/bin/harvest_sim_meta.py`
- 시행착오: `parents[2]` 경로 오타(config 모듈 미발견) → `parents[3]` 수정. 산출 경로 오타(`bin/out/sim-meta`) → 정본 `out/sim-meta/`로 이동 완료(스크립트도 수정).
- 출력: `완료: 266상품 · 예외 0 · 1572s -> out/sim-meta` (B-3 실측: 하베스터 26분)

### M2 최종 (PASS)
- 3차 실행: `defects=461 => NO-GO · 돈영향 433 · 치명 390` → `out/defects/widget-defects.jsonl`(461행)
- 코드별: ZERO_FINAL 297 · NO_FORMULA 59 · ANCHOR_DELETED 28 · UNCOVERED 18 · PRICE_MISSING 13 · TRUNCATED 13 · PARENT_DEAD 12 · ANCHOR_MISSING 11 · NO_SOURCE 6 · RULE_DEAD_REF 2 · MISSING_DIM 1 · MASTER_DELETED 1
- B-3 실측: verify_zero_quote 전수 211상품 541~558s (cap=32 기본 유지 — 축소 불필요)

### M1 승계 (PASS)
- price 스코프 재실행(round 27) → 보드 복원(553건·round26과 동일=결정론 확인) → `out/defects/price-defects.jsonl` 553행 변환 저장
- **가정 기록**: board CSV는 스코프마다 같은 파일을 덮어씀 → M4 입력은 스냅샷 시점의 jsonl 승계본 사용.

### M4 조립 (PASS)
- 명령: `python3 bin/build_wiring_health.py` → `wiring-health 266상품 · BROKEN 62 · WARN 145 · OK 59 · edges_evaluated 10종 전부`
- 시행착오: price-defects(보드 CSV)의 evidence 가 문자열 → 적재 시 dict로 정규화.
- 가정 기록: reachable_ratio 는 verify_price_coverage 의 any-row-exists 판정을 같은 스냅샷 조인으로 집계(센서 상수 verbatim·재판정 아님).

### M5 아티팩트 (PASS · AC7)
- `python3 bin/build_artifact.py` → `out/wiring-explorer.html` (560KB·266상품·데이터 인라인)
- gstack 헤드리스 스모크: 분모 266 헤더 ✓ · 상품목록 266 ✓ · BROKEN 필터 62 ✓ · 상품 클릭 시 가격축 체인 4스텝(단절 2 강조)·옵션계층 4그룹·결함배지 10 ✓ · evidence 패널 block ✓ · 콘솔 에러 0 ✓

### M6 보고·worklist (PASS)
- `out/REPORT-260821.md`(AC 대조표 포함) · `out/worklist.csv`(982행 · review 607 / needs_authority 328 / auto_data 29 / needs_design 18)

### AC 종합 (acceptance.md 8종 전부 기계 판정)
| AC | 판정 | 증거 요지 |
|---|---|---|
| AC1 | PASS | snap_20260821_2319 활성 266 == 266 |
| AC2 | PASS | wiring-health 266파일 |
| AC3 | PASS | 신규 코드 5개 이하(어댑터1·bin3·html1) · raw/webadmin·hdx/diagnose 기존파일 diff 0 |
| AC4 | PASS | 원본 5센서 직접 실행 vs 어댑터 집계 — 코드별 전부 일치(REPORT §5 대조표) |
| AC5 | PASS | edges_evaluated = W1~W5·C1·E1~E4 전부 |
| AC6 | PASS | 전 파이프라인 SELECT/COPY 만 — write 0건 |
| AC7 | PASS | gstack 스모크(위 M5) |
| AC8 | PASS | M4 2회 실행 diff -rq 바이트 동일 |

→ **전역 GO(판정 기준 통과) — 결함 다수는 진단 결과이지 실패 아님(acceptance 판정 규칙)**

### review 260822 교정 반영 — 확정 수치 (요약 · 상세는 아래 "교정 3건 반영" 절)

위 §E.2의 3차 실행 수치(461·WARN 145·worklist 982)는 **교정 전 값**. 최종 확정값:

- 어댑터 결함 **404건**(치명 333) — 엣지 E4 347 · W4 40 · W2 12 · E1 2 · C1 2 · E3 1
- verdict 266상품 — **BROKEN 62 · WARN 90 · NOT_EVALUATED 51 · OK 63**
- worklist **925행** — review 577 · needs_authority 328 · needs_design 20 · **auto_data 0**
- 핵심 발견 확정: **코드 재키(re-key) 드리프트 = E4 근본원인**(상품=신규 코드·가격 그리드=구 코드.
  예: 아크릴볼펜 SIZ_000216/218 활성 vs SIZ_000330/333 그리드 — 같은 물리치수 코드 2벌).
  [HARD] 교정 방향 = 그리드 신규 코드 재적재/코드 통합, **값 삭제·del_yn 복구 금지**(2026-07 0원 사고).
- 후속 카드 승계: 백로그 **t2~t5**(트윈링 proc_cd 불일치 · 책자 5상품 공정축 미스윕 ·
  TRUNCATED 전수화+AC5 증거수정+E2 누락 판정 · 아티팩트 표시결함).
- **sync 세션 재실측(260822 · 커밋 전 검증)**: `widget-defects.jsonl` 404행·치명 333 ·
  index `verdict_counts` {BROKEN 62, WARN 90, NOT_EVALUATED 51, OK 63} ·
  `worklist.csv` 925행(remediation_class: review 577·needs_authority 328·needs_design 20) ·
  `wiring-health/` 266파일 — 전부 REPORT 확정수치와 일치 확인.

### review 260822 교정 3건 반영 (운영자 승인 "위험 3건만 교정 후 sync")

입력: 리드 재디스패치(OUT/REVIEW-260822.md 확정 301·오탐 57·미판정 103 기반).

- **교정1 (E1 NO_FORMULA 오탐 제거)**: `widget_wiring_dx._coverage` — 직접단가 보유 상품
  (t_prd_product_prices.unit_price non-null · 엔진 1순위 PRODUCT_PRICE, pricing.py:568-581)의
  NO_FORMULA 는 Defect 를 만들지 않음(원본 센서와 동일하게 정보성). 무소스성 NO_FORMULA만 치명 유지.
  결과: E1 59→**2**(PRD_000038·PRD_000220). widget-defects 461→**404**(치명 390→333).
- **교정2 (suggested_fix 문구 + auto_data 제거)**: UNCOVERED/MISSING_DIM fix 문구를
  "권위 대조 후 판단(재적재 vs 코드 통합). [HARD] 값 삭제 금지 — 2026-07 대리키 오판 사고 전례"로 교체.
  REMEDIATION: ANCHOR_DELETED auto_data→**review**, MASTER_DELETED→review (재키 케이스 — del_yn 복구는
  구코드 중복 부활). **auto_data 29→0건**.
- **교정3 (NOT_EVALUATED)**: 가격 센서 2종이 PRD_TYPE.01 하드코딩(verify_price_coverage.py:180,
  --all-types 플래그 부재 → 원본 수정 금지로 확대 불가 — **가정 기록**; zero 는 --all-types 있으나
  coverage 없어 부분 확대는 의미 없음) → `build_wiring_health` 에 evaluated_edges 축별 기록 +
  결함 0 & E1/E3/E4 미평가 상품을 **NOT_EVALUATED** verdict 로 산출. 센서 환경 FAIL 시 전 상품
  미평가 강등 처리도 추가. 아티팩트 범례·필터 반영(스모크: NOT_EVALUATED 필터 51건·콘솔 에러 0).
- AC3 증거 교체: raw/webadmin 은 **별도 git 저장소**(toplevel=raw/webadmin)이며 tracked 수정 0
  — mtime 08-21 22:39는 개발팀 커밋 a91f63b6 체크아웃 결과(리드 검증 완료).
- AC4 대조표에 교정1 의도분(NO_FORMULA) 주기 명시.

**변경 전후 수치**

| 항목 | 전 | 후 |
|---|---|---|
| widget-defects | 461 (치명 390) | **404** (치명 333) |
| E1 NO_FORMULA | 59 | **2** |
| verdict 분포 | BROKEN 62·WARN 145·OK 59 | **BROKEN 62·WARN 90·OK 63·NOT_EVALUATED 51** |
| 치명 broken_edges | E4 55·W4 10 | E4 55·W4 10·**E1 2** |
| worklist | 982행 (auto_data 29) | **925행 (auto_data 0 · review 577·needs_authority 328·needs_design 20)** |

재실행 체인: widget w3 (교정 코드 확정 후 재시작) → M4 재조립 → worklist 재생성 → M5 재빌드(574KB) →
AC7 재스모크 통과 → REPORT 수치 갱신. 백로그 이관 항목(AC5 합집합·AC4 서술·use_dims 파싱·TRUNCATED
분류·책자 mand_proc_yn·트윈링책자 PROC 불일치)은 리드 백로그 카드로 이관 — 본 세션 미처리.

## §E.3 Run-phase Audit-Ready Signal

- run_status: audit-ready
- run_complete_at: 2026-08-22 00:2x
- M0~M6 전 마일스톨 완료 · AC1~AC8 전부 PASS · 산출물 `out/` 정리 완료
- review 260822 교정 3건 반영 후 재실행 체인(w3→M4→worklist→M5→AC7 재스모크) 완료
- 잔여(비차단): HANDOFF.md·CHANGELOG.md 갱신은 sync 단계 소관. → §E.4에서 완료

## §E.4 Sync-phase Audit-Ready Signal

- sync_status: audit-ready
- sync_complete_at: 2026-08-22 00:5x
- sync_commit_sha: pending-backfill-SPEC-WIDGET-WIRING-001
- sync 세션: `sync-huniweb`(칸반 t1 · 리드 디스패치 — HANDOFF/CHANGELOG·수치 확정·AC3 증거 문구 교체·커밋)
- 산출:
  - `_workspace/huni-widget-wiring/HANDOFF.md`(재시작 지점·재키 드리프트 근본원인·t2~t5 연계·[HARD] 제약)
  - `_workspace/huni-widget-wiring/CHANGELOG.md`(0.1.0 — 교정 반영 확정값)
  - `out/REPORT-260821.md` — 리드 검증 기반 AC3 증거 문구 교체:
    raw/webadmin 은 별도(nested) git 저장소·tracked 파일 수정 0(git status --porcelain M/A/D 없음) ·
    보호파일 2종 mtime 08-21 22:39 = 개발팀 커밋 a91f63b6 체크아웃 결과(본 SPEC 변경 아님 · 리드 검증 260822) ·
    센서 5종 mtime(07-06~08-08) 전부 실행일 선행
- 커밋 방식: 메인 체크아웃 · 명시 pathspec만 스테이징(git add -A 금지 준수 · 병행 세션 보호) ·
  PR/push 없음(운영자 지시 — 커밋까지만)
- sync_commit_sha 백필: 자기 커밋 SHA는 자기 커밋에 담을 수 없어 placeholder 후 후속 커밋으로 백필
  (D3 SHA placeholder backfill exemption).


## plan 단계 기록

- 입력: `_workspace/huni-widget-wiring/CONSULT-DENOMINATOR-260821.md`.
- 실측으로 확인한 **컨설트 정정 1건**: "미커버 배선 엣지 4종"은 이미 `raw/webadmin/tools/` 에
  결정론 센서로 존재(`verify_option_ref_integrity` · `verify_price_coverage` · `verify_zero_quote` ·
  `audit_constraints` · `verify_optcode_integrity`). → 신규 판정 로직 mint 없음, 어댑터만.
- 실측으로 확인한 **하이라키 정본**: `price_views._build_sim_meta(prd_cd, customer=True)`
  (위젯 임베드 config 와 관리자 시뮬레이터가 공유하는 단일 빌더) → 위젯 그릇을 새로 모델링하지 않는다.
- 배선 엣지 정본표 10종 확정(W1~W5 · C1 · E1~E4), 상품별 산출 스키마 확정(spec §5).

## 미해결 / 결정 대기

| # | 항목 | 상태 |
|---|---|---|
| B-1 | SPEC 3종이 워크트리 `design-viewer` 에 있음 → 메인 이관 필요 | **해결** — 메인 체크아웃에 존재 확인(sync 260822) |
| B-2 | `raw/webadmin/../.venv` + `DATABASE_URL` 가용 여부 | **해결** — §E.2 B-2 PASS(raw/.venv django 5.2.15) |
| B-3 | `verify_zero_quote` 266상품 전수 소요시간 | **해결** — 211상품 541~558s·cap 유지(§E.2 M2 최종) |
| R-* | review 파생 후속(트윈링 proc_cd·책자 공정축·TRUNCATED 전수화·AC5 증거·아티팩트 표시결함) | **백로그 이관** — 카드 t2~t5(`.moai/state/kanban/backlog.json`) |

## 건드리지 말 것 [HARD]

- `raw/webadmin/**` 전체(센서 5종·`price_views.py`·`widget_api.py`) — 읽기 전용, 어댑터는 호출/이식만.
- `hdx/foundation/engine.py`(pricing.py verbatim) · `hdx/diagnose/*` 기존 9 Diagnoser.
- 라이브 DB write·DDL — 인간 승인 게이트.
