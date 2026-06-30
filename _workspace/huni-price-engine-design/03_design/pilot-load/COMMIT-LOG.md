# COMMIT-LOG — 박류 파일럿 + 명함박 G6 실 COMMIT 로그

라이브 production DB(`railway`)에 인간 승인 후 실제 적재한 기록. 모든 단가 권위 verbatim·undo 보존.

---

## 2026-06-30 10:11 KST — 박류 파일럿(namecard031) + 명함박 G6 동시 COMMIT

**승인:** 사용자 명시 승인(foil pilot + namecard G6 동시 COMMIT). 양쪽 build + 독립 R1~R6 검증 GO(mismatch 0).
**실행자 프로토콜:** safe-load(사전 종결자 점검 → 트랜잭션별 COMMIT → 사후 라이브 재조회 → 시뮬레이터 e2e).

### 사전 점검(pre-flight)
- 두 load.sql 원본은 dryrun(BEGIN…ROLLBACK·COMMIT 주석)임을 확인 → 실-COMMIT 버전 신규 생성:
  - `foil-pilot-namecard031-COMMIT.sql` (BEGIN … `\i body` … COMMIT · ON_ERROR_STOP on)
  - `namecard-foil-g6-COMMIT.sql` (BEGIN … UPDATE … COMMIT · ON_ERROR_STOP on)
- body 멱등 가드 NOT EXISTS NULL-safe(IS NOT DISTINCT FROM) 무결 확인. G6 멱등 가드(unit_price=63000만) 확인.
- undo 양쪽 실재·정확 확인: `foil-pilot-namecard031-undo.sql`(FK 역순 DELETE) / `namecard-foil-g6-undo.sql`(64000→63000 역연산).
- 사전 라이브 상태: COMP_FOIL_ comps=0·prices=0·formula=0·binding=0 (DB 미변경 확인). G6 1000구간=63000.00(S1/S2).

### 적재 결과(post-COMMIT 라이브 재조회)

**① 박류 파일럿 — COMMIT 성공(Y)**
| 항목 | 적재 | 검증 |
|---|---|---|
| price_components | 3 | COMP_FOIL_SETUP_SMALL(.05)·PROC_SMALL_STD(.01)·PROC_SMALL_SPECIAL(.01)·전부 PRICE_TYPE.03 ✓ |
| component_prices | 2,168 | SETUP_SMALL 8 · PROC_SMALL_STD 1,620 · PROC_SMALL_SPECIAL 540 = 2,168 ✓ |
| price_formulas | 1 | PRF_NAMECARD_FIXED_FOIL ✓ |
| formula_components | 5 | STD_S1·STD_S2(본체 2) + FOIL SETUP/PROC_STD/PROC_SPECIAL(박 3)·disp_seq 1~5 ✓ |
| product_price_formulas | 1 | PRD_000031 → PRF_NAMECARD_FIXED_FOIL @2026-07-01 ✓ (형제 032/033 = 기존 PRF_NAMECARD_FIXED @2026-06-01 만·박 미노출 ✓) |

- 표본 단가: STD 금유광(PROC_000038) 40×80 q1000 = **64,000.00** ✓ · SETUP = **5,000.00** ✓ (권위 일치).
- ★바인딩은 **미래일자(2026-07-01)** — 라이브 엔진(`_latest_ymd`·미래분 제외)이 오늘(2026-06-30)은 base 공식 사용. 박 분기는 2026-07-01부터 활성(production 무영향·설계 의도).

**② 명함박 G6 — COMMIT 성공(Y)**
- `UPDATE 2` (COMP_NAMECARD_FOIL_S1_STD + _S2_STD 1000구간 63,000 → 64,000·권위 verbatim).
- 사후 재조회: 두 comp 1000구간 = **64,000.00** ✓.

### 시뮬레이터 e2e (HUNI_ADMIN 인증 POST /simulate/)

| 골든 | 입력 | 기대 | 결과 | 판정 |
|---|---|---|---|---|
| G-F4 | STD 금유광 40×80 q1000 → 박_총액 | 69,000 (64,000+5,000) | 라이브행 SETUP 5,000 + PROC E@1000 64,000 = 69,000 | **PASS** |
| G-F5 | SPECIAL 트윙클 10×10 q200 → 박_총액 | 19,300 (14,300+5,000) | 라이브행 PROC A@200 14,300 + 5,000 | **PASS** |
| off-band q850 | STD 금유광 40×80 q850 | 57,800 (.03 FLAT) | 라이브 band lookup min_qty=800 → 52,800(×qty 0) + 5,000 = 57,800 | **PASS** |
| 박-미선택 | 미등록 색상(PROC_000045) | 박 0 기여 | 라이브 0행 → no_match → 0 | **PASS** |
| G6 e2e | PRD_000037 오리지널박명함 1000매 단면 일반박 | 69,000 (64,000+5,000) | 시뮬레이터 final_price=**69,000** (S1_STD 64,000 + SETUP 5,000·둘 다 matched) | **PASS** |
| 회귀 | PRD_000031 base 명함 q1000 단면(MAT_000074) | >0·박 미노출 | final_price=35,000·foil comps 없음(미래 바인딩 오늘 비활성 입증) | **PASS** |

- ★박류 골든(G-F4/F5/off-band/gate)은 바인딩이 미래일자(2026-07-01)라 오늘 HTTP 시뮬레이터로는 분기공식 비활성 → **라이브-적재행에 evaluate_price 알고리즘(ceiling tier + min_qty band + .03 FLAT)을 그대로 적용한 골든 재계산으로 입증**(라이브 행 = 권위 verbatim 일치). golden_recalc.py 도 build 행 대상 6/6 PASS(동일 단가).
- ★G6·회귀는 오늘 활성 경로라 실 시뮬레이터 직접 호출로 PASS.

### undo 경로(회수용·보존)
- 박류: `/Users/innojini/Dev/HuniWeb/_workspace/huni-price-engine-design/03_design/pilot-load/foil-pilot-namecard031-undo.sql` (실행 시 ROLLBACK→COMMIT 주석 해제 필요)
- G6: `/Users/innojini/Dev/HuniWeb/_workspace/huni-price-table-integrity/_batch/namecard-foil-g6-undo.sql` (동일)

### 종합
- COMMIT 성공: 박류 파일럿 **Y** · 명함박 G6 **Y**.
- 사후 검증·시뮬레이터 e2e: 전 항목 PASS. undo 미실행(NO-GO 없음).
