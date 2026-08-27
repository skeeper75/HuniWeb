---
id: SPEC-WIDGET-WIRING-001
doc: progress
version: "0.2.0"
updated: 2026-08-22
status: draft
---

# 진행 원장 — SPEC-WIDGET-WIRING-001

## 상태

| 단계 | 상태 | 비고 |
|---|---|---|
| **plan v0.2.0 (SPEC 확장)** | **완료** 2026-08-22 | 세션 `plan-huniweb` — 렌즈 이원화·엣지 15종·감사 도구 흡수 판정. 아래 §v0.2.0 |
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

## §E.2 v0.2.0 Run-phase Evidence (2차 run · 260822)

### v0.2.0 M0' 스냅샷 확장 + 게시 분모 (PASS · R1)
- 스냅샷 재추출: `SNAPSHOT OK: snap_20260822_1449` · 활성 상품 **266** 유지(AC1)
- **가정 기록**: spec §1.7 "t_wgt_* 미포함(36테이블)"은 stale — snapshot.sh 가 `t_*` 자동수집이라
  t_wgt_widgets/versions/items/handoff_logs/sites 전부 이미 포함(52테이블). **스크립트 수정 불필요**.
- 게시 상태 코드값 라이브 실측(t_cod_base_codes): `WGT_STS_TYPE.02`=게시됨 · 01=작성중 · 03=게시중단
- 게시 위젯 분모: **194 == 감사 분모 194(차이 0 · AC9)** · A∩B=193 · **B−A=1: PRD_000165
  아크릴포카코롯토(use_yn=N — 게시돼있는데 상품 비활성, 치명 · CROSS-VERIFY §1과 일치)**

### v0.2.0 M7 게시 cfg 하베스터 (PASS · R9/G1)
- 신규: `bin/harvest_publish_cfg.py` → `완료: 위젯 194 · G1 결함 34건 · INFO-1 103위젯 · 217s`
- 산출: `out/publish-cfg/*.json` 194 + `out/defects/g1-defects.jsonl`(34)

### v0.2.0 M8 렌즈 B 러너 (파일럿 → 전수 진행)
- 신규: `bin/lens_b_runner.py` — verify_zero_quote(축/조합/제약필터) import + widget_api
  _prep_selections/_prep_proc_sels/_prep_set_body + pricing.evaluate_price +
  price_views.simulate_set_core + _price_gap_errors **호출·조립만**(AC12 — 판정식 재구현 0)
- 오류코드→엣지: no_plate_pansu→E5 · below_min_qty/above_max_size→Q1 · 셋트실패→S1 ·
  price_gap/매칭→E4 · source NONE→E1
- **truncated 의미 정정**: 기본+1변경 스윕의 설계상 미검사(다중변경)는 절단이 아니라 한계 고지 —
  cap 이 스윕 자체를 자른 경우만 절단 계상(코드 수정)
- 파일럿: PRD_000072 셋트 **BROKEN 재현**(SET_MEMBER_NO_SOURCE 3 — 감사 "표지·면지 소스 없음") ·
  PRD_000042 게시 경로 통과(A_ONLY) · **PRD_000108 비재현**(서버 경로 전 16조합 전부 가격 정상 —
  감사 8/22 04:34 이후 데이터/개발 커밋 a91f63b6 반영 가능성. 원인 규명 대상으로 명시 기록)

### v0.2.0 M2' 잔여 정정 (3건 · plan §3)
- TRUNCATED → Defect 분리·사이드카(out/defects/truncated.jsonl) — 조립기가 NOT_EVALUATED 사유로 소비
- use_dims 파싱 → `parse_use_dims`(JSON 배열/문자열 겸용) · `code_of` 한글 첫 워드 결함 수정(정규식+차원명)
- evaluated_by 증거화 → 조립기 EVAL_BY(엣지×센서×스코프 상품수 — 상수 합집합 아님, AC5 대응)

### 렌즈 B 재현율 규명 (260822 · 리드 2차 검증 반영)

리드 지적 → 수정 이력:
1. **"축 스윕 부족" 지적은 리드가 철회** — total 은 전 축 교차곱, picked 는 감사와 동일한
   기본+1변경 선형 스윕. cap 절단 실제 발생 위젯 2/194 (커버리지 결손 아님).
2. **공정축(WGT_SRC_TYPE.14) 미스윕 → 수정**: 박·후가공·모서리는 공정선택이라 proc_sels 로
   가격 영향 — 러너에 공정 옵션 전개(기본 dflt 공정 포함 + 면별 side 후보 2) 추가.
3. **cfg 기본값 정규화 [HARD 위반 → 수정]**: cfg dflt 가 상품 활성값에 없으면 정상값으로
   몰래 치환하고 있었음(리드 3단계 지적 적중) — cfg 값을 **있는 그대로** 쓰도록 수정.

**E5(판수 환산) 0건·미재현 24건의 원인 규명(실측 증거)**:
- `pricing.py` 최종 변경 08-19(`02e5f2b2`) · price_views 08-20 — 감사(08-22 04:34)와 현재 사이
  **가격 경로 코드 무변경**.
- PRD_000108 `종이=스노우지200g(MAT_000090)` 직접 평가: `final=6063, error=None` 전 조합 정상.
  stale 기본값(print POPT_000001)을 넣어도 `final=4113` 정상.
- 판형 자동도출(`widget_api._prep_selections:576` → `PV._select_default_plate`)은 **서버 경로
  자체** — 실고객(HTTP API)도 같은 도출을 받는다.
- **결론[추정]**: 감사 도구는 `_prep_selections` 를 거치지 않고 요청을 조립한 것으로 보임 —
  plt 없이 직접 evaluate 하면 정확히 감사 문구(`판수 환산 불가(판형/완제품사이즈 확인)`,
  pricing.py:926)가 재현됨(1차 디버그 실측). 즉 감사 E5 다수는 도구 경로 아티팩트 가능성.
  단 확증 불가(감사 도구 원본 부재 — spec §1.6 U-5 승계). 렌즈 B 는 **서버 동일 경로**를
  유지하며, E5 는 서버가 판형을 도출 못 하는 조합에서만 발화한다(과소가 아니라 정확).
- PRD_000042(사이즈 148x68·148x75 매칭 0)도 서버 경로 전 조합 통과 — 동일 범주로 기록.
- 오탐 0 유지(감사 결함 아닌데 BROKEN/WARN 0건).

- run_status: audit-ready
- run_complete_at: 2026-08-22 00:2x
- M0~M6 전 마일스톨 완료 · AC1~AC8 전부 PASS · 산출물 `out/` 정리 완료
- review 260822 교정 3건 반영 후 재실행 체인(w3→M4→worklist→M5→AC7 재스모크) 완료
- 잔여(비차단): HANDOFF.md·CHANGELOG.md 갱신은 sync 단계 소관. → §E.4에서 완료

## §E.4 Sync-phase Audit-Ready Signal

- sync_status: audit-ready
- sync_complete_at: 2026-08-22 00:38
- sync_commit_sha: 5c844f504a797bfe1a1e184df87beba1ca6e682e
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


## §v0.2.0 — SPEC 확장 (plan 재진입 · 2026-08-22)

입력: 외부 감사 `docs/huni/widget-price-audit-260822.html`(게시 위젯 194 실호출) ·
`CROSS-VERIFY-260822.md`(리드 교차검증) · `out/REVIEW-260822.md` · 기존 SPEC v0.1.0.

### 확정 변경 (spec/plan/acceptance v0.2.0)

1. **렌즈 이원화** — 렌즈 A(상품 데이터 266) + **렌즈 B(게시 위젯 194)** 신설. 분모 차이를 결함이 아닌
   정보로 정의: A∩B 대조 · A−B 미게시(강등) · **B−A 치명**(고객엔 보이는데 뒤가 없음).
   게시 그릇 정본 = `t_wgt_widget_versions.cfg` + `t_wgt_widget_items`(`models.py:830-891`).
2. **엣지 10 → 15 + INFO 1** — 신규 **E5 판수 환산 실패**(독립 엣지·E4 흡수 금지) · **S1 셋트 계산 실패** ·
   **Q1 경계 위반** · **W6 옵션 유형 어긋남** · **G1 게시 기본값 소실** · INFO-1 기본값 미지정.
3. **`NOT_EVALUATED` verdict 를 SPEC 본문으로 승격**(run 이 구현한 것을 규범 고정).
4. **가격 원리 선행 이해(§1.5)** — 직접가 1순위(`pricing.py:568-581`) · 판수 환산(`:259-273`·`ERR_NO_PLATE`) ·
   배선 규모(공식 110·구성요소 146·배선 232·바인딩 178) · 공유도(공유 31/전용 88, 최다 31상품) ·
   경로 배타(직접 57·공식 159·둘다없음 50) · 차원 종류는 맞고 **값(코드) 층 재키 드리프트**가 본체.
5. **교정 안전 규범(R12)** — "과등록/삭제" 문구 금지 · `ANCHOR_*` `auto_data` 금지 · 파급 상품 수 표기.
6. **AC 교체·신설** — AC3(nested repo status+해시) · AC5(`evaluated_by` 실행 증거) · AC9~AC13(렌즈 B·신규 엣지·
   미평가 0통과·재사용 검증·문구 안전).

### 감사 도구 흡수 판정 [HARD · search-before-mint 이행]

저장소 전수 탐색 결과 **감사 생성기 소스는 이 저장소에 없다**:
- `grep -rl "게시 위젯 가격계산 점검"` → 적중 1건(산출 HTML 자기 자신)
- `raw/webadmin/tools/` 전 목록 확인 — 생성기 없음(유사 계열: `verify_zero_quote`·`test_widget_parity`·
  `e2e_price_viewer`·`bulk_publish_widgets`)
- `raw/widget_monitor/`·`raw/widget_ui/` — 위젯 캡처·SDK 점검기만

⇒ 흡수 대상은 **도구 파일이 아니라 그 경로**로 재정의. 렌즈 B 러너는 `t_wgt_*` + `widget_api._prep_*` +
`pricing.evaluate_price` **호출**로만 구성(알고리즘 mint 금지·AC12 로 검증).

### 리뷰 지적 상태 반영

위험 3건(E1 오탐·문구·NOT_EVALUATED/auto_data)은 **run 이 이미 교정 완료** → v0.2.0 은 이를 본문 규범으로
승격(되돌림 방지). 잔여: AC5 증거화 · TRUNCATED 분류 · `use_dims` 파싱 · 책자 공정축 · 트윈링 `proc_cd`
(백로그 t2~t5 와 대응).

### 미검증으로 남긴 것 [추정]

| # | 항목 |
|---|---|
| U-1 | 우리에만 BROKEN 10건 = 미게시 가설 — 게시 스냅샷(M7)으로 확인 전까지 `[추정]` |
| U-4 | "가격경로 둘 다 없음 50"의 성격(미완성 vs 미게시) |
| U-5 | 감사 도구가 우리와 동일 경로를 탔는지 — 원본 부재로 확증 불가(수렴 82%가 방증) |

### 신규 선행 조건

- **스냅샷에 `t_wgt_*` 3테이블 없음**(현행 52테이블에 미포함) → `snapshot.sh` 확장이 M0' 차단 조건.
- 게시 상태 코드값은 `t_cod_base_codes` 실측으로 확정(하드코딩 추정 금지).

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

### 렌즈 B 최종 수치 (260822 3차 전수 + 재시도 병합 · 리드 정정 반영)

- 실행 이력: ① 전수(cfg충실) → ② 인프라 실패 11건 재시도(--merge·INFRA_FAIL 분리) →
  ③ 리드 정정 반영(stale 기본값은 미락 낙하·G1 단일 계상) stale-fk 31건 재평가 → ④ 잔여 INFRA 1건 재시도(지속 실패).
- **최종 lens-b: BROKEN 66 · WARN 2 · OK 119 · NE 6 · INFRA_FAIL 1(PRD_000036 — 2회 재시도 모두 DB 접속 실패)**
- 엣지: E1 75 · S1 26 · Q1 5 · E4(ZERO_FINAL+PRICE_GAP) 다수 · **E5 0·W6 0**(E5 발화 조건 = 서버 판형 도출 실패 조합만)
- 조립: 266 = BROKEN 78·WARN 92·NE 38·OK 58 · cross CONVERGE 51·A_ONLY 154·B_ONLY 15·BOTH_OK 46 · 15/15 엣지 · 아티팩트 795KB
- **재현율(감사 ①+② 추출가능 86): 56/86 = 65%** (cfg충실 해석 시 71%·오탐 1)
- **[감사 내부 모순 — 리드 판정 대기]**: 감사는 PRD_000031 stale 기본값은 ④(정상)으로,
  PRD_000018·32-34 등은 ①(막힘)으로 분류 — stale 태우기/미락 낙하 중 어느 쪽이 실제 렌더 동작인지 프런트 확인 필요.
- E5 0건 최종 답변: PRD_000108 전 16조합 included=False/error 0(전부 정상가). plt 미포함 직접 evaluate 시에만
  no_plate_pansu 발화(실측) → 감사 도구가 판형 자동도출 없이 조립한 아티팩트 추정(pricing 8/19 이후 무변경).
- INFRA_FAIL 분리 완료(verdict·조립기 사유). 미재현 27 = 감사 E5 범주 + stale 해석분.
