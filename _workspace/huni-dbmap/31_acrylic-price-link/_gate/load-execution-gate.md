# round-5 게이트 종합 — 아크릴 가격사슬 연결 | 판정: **GO**

> **검증** 2026-06-15 · `dbm-validator`(독립 게이트·생성자와 분리). 입력 = `31_acrylic-price-link/_exec/`(`dbm-load-builder` SQL) + `acrylic-chain-design.md`(`dbm-price-arbiter` 설계).
> **모든 수치 독립 재측정**(생성자 dry-run.md 불신·라이브 읽기전용 + 롤백전용 DRY-RUN). 라이브 `BEGIN…ROLLBACK`만 · **COMMIT 0**.
> 권위 = `docs/goal-2026-06-06-02.md`(round-5) + round-4 G1~G9 carry-forward.

---

## G1~G9 carry-forward (round-4 권위 재확인)

본 트랙은 round-21 arbiter 단발 설계 → load-builder 실행본화로, round-4 `load-readiness-gate*.md` 정식 G1~G9 산출이 별도로 없으나, 본 게이트가 등가 항목을 라이브로 재확인:

| Gate | 내용 | round-5 재확인 | 근거 |
|------|------|:--:|------|
| G1 | t_* 화이트리스트(Django 무접촉) | ✅ | 대상 4테이블 전부 `t_prc_*`/`t_prd_*` |
| G2~G3 | 타입/길이·NOT NULL | ✅ | DRY-RUN 28 INSERT 전건 무중단(ON_ERROR_STOP=1)·reg_dt omit DEFAULT |
| G4 | CHECK | ✅ | use_yn='Y'·addtn_yn='N' 위반 0 |
| G5 | FK | ✅ | R5 6 어서션 0고아(아래) |
| G6 | PK 유일성(롤백 DRY-RUN) | ✅ | R5에서 닫음(round-4 보류분) |
| G7 | 적재순서 ↔ FK 그래프 | ✅ | R2(공식→comp→배선→바인딩 위상순) |
| G8~G9 | 매니페스트·독립검증 | ✅ | manifest.md·본 게이트(R6) |

---

## R1~R6

| Gate | 판정 | 근거(독립 재측정) | 라우팅 |
|------|:--:|------|------|
| **R1** 멱등성 | **PASS** | 라이브 BEGIN…ROLLBACK 2회: PASS1 = 26 `INSERT 0 1` + 2 `INSERT 0 0`(PRF_CLR_ACRYL·PRD_000146 스킵), PASS2 = **28 전건 `INSERT 0 0`**. after1=after2(f=4·c=4·w=4·b=19). ON CONFLICT 충돌키 = 라이브 실제 PK 일치 | — |
| **R2** 원자성 | **PASS** | apply.sql 단일 `BEGIN;`·중첩 COMMIT 0(파일 내 COMMIT/ROLLBACK 없음·로더 주입). mid-load FK 오류 주입 시 ON_ERROR_STOP가 전체 abort → 라이브 신규 공식 0행 잔존(half-load 없음). `commit` 모드 EXIT=1 차단 | — |
| **R3** 실행가능성 | **PASS** | `./apply.sh dryrun`이 `.env.local` 접속·4 SQL 순차 실행·ROLLBACK·EXIT=0. 파싱 오류 0. 손편집 없음(gen_load_sql.py 생성) | — |
| **R4** 설계 정합 | **PASS** | arbiter 설계 ↔ SQL 일치. search-before-mint: 신규 comp COROTTO/CARABINER 라이브 **부재 확인**(0행). FK 코드값 4종(PRC_COMPONENT_TYPE.01/.06·PRICE_TYPE.01/.02) 실재. 면적-좌표 회귀 0(단가행 미동봉) | — |
| **R5** 라이브 DRY-RUN | **PASS** | FK 고아 6 어서션 전건 **0**(orphan_fc_frm/comp·bind_frm/prd·comp_typ·prc_typ). 타입/길이/NOT NULL/CHECK 위반 0. golden(component_prices) 121→121 불변 | — |
| **R6** 독립성 | **PASS** | 생성자(arbiter 설계 + builder SQL)와 다른 세션·다른 에이전트(validator)가 전 수치 독립 재측정. ≥1 실 발견(아래 §발견) | — |

**종합: 6/6 PASS → GO**

---

## 멱등성 증명(R1) — 라이브 DRY-RUN 2회 결과 (독립 실측)

| 사슬(아크릴) | BEFORE | AFTER1 | AFTER2 | 멱등 |
|------|:--:|:--:|:--:|:--:|
| formulas | 1 | 4 | 4 | ✅ |
| components | 2 | 4 | 4 | ✅ |
| wiring | 1 | 4 | 4 | ✅ |
| binding | 1 | 19 | 19 | ✅ |
| golden(component_prices) | 121 | 121 | 121 | ✅ |

- PASS1 INSERT 명세: 01 = `0 0`(PRF_CLR 스킵)+3×`0 1`, 02 = 2×`0 1`, 03 = 3×`0 1`, 04 = `0 0`(PRD_000146 스킵)+18×`0 1`. **총 28 시도 / 26 신규 / 2 스킵**.
- PASS2 = 28 전건 `INSERT 0 0`(델타 0). ON CONFLICT 가드 정상 작동 실증.

> **생성자 dry-run.md 수치 정정**: 생성자는 4테이블 절대 카운트를 formulas 20·components 145·wiring 89·binding 82로 보고(전 사슬). 본 게이트는 **아크릴 사슬만** 필터링 재측정(1→4·2→4·1→4·1→19). 양쪽 모순 아님(스코프 차이) — 멱등 결론 동일. golden은 생성자 "84+37" 분할 보고 = 본 게이트 "121 합계" 동일값.

---

## 라이브 DRY-RUN(R5) — 제약 위반 목록

**제약 위반 0** (전 어서션 명시):

| 어서션 | 결과 |
|--------|:--:|
| formula_components.frm_cd → price_formulas 고아 | **0** |
| formula_components.comp_cd → price_components 고아 | **0** |
| binding.frm_cd → price_formulas 고아 | **0** |
| binding.prd_cd → t_prd_products 고아 | **0** |
| 신규 comp comp_typ_cd → t_cod_base_codes 고아 | **0** |
| 신규 comp prc_typ_cd → t_cod_base_codes 고아 | **0** |

타입/길이/NOT NULL/CHECK = ON_ERROR_STOP=1 하 28 INSERT 무중단 → 위반 0.

---

## 라이브 진화 5주장 독립 재현 (arbiter §0 — 권위 라이브 직접 SELECT)

| arbiter 주장 | 독립 라이브 재측정 | 판정 |
|------|------|:--:|
| 1. `PRF_CLR_ACRYL` 라이브 실재 | `t_prc_price_formulas`에 1행(frm_nm=투명 아크릴 공식·use_yn=Y)·MIRROR/COROTTO/CARABINER 부재 | ✅ **참** |
| 2. `COMP_ACRYL_CLEAR3T` prc_typ **.02**·dims `[siz_cd,mat_cd,min_qty]` | 라이브 = `PRICE_TYPE.02`·`["siz_cd","mat_cd","min_qty"]` 정확 일치 | ✅ **참** |
| 3. 골든 CLEAR3T 84·MIRROR3T 37 | 라이브 단가행 = 84·37(합계 121) | ✅ **참** |
| 4. 배선 `PRF_CLR_ACRYL→CLEAR3T` disp_seq/addtn_yn **NULL** | 라이브 실측 둘 다 NULL | ✅ **참**(메타 미완) |
| 5. 바인딩 `PRD_000146→PRF_CLR_ACRYL` apply_bgn_ymd 2026-06-15 | 라이브 1행 정확 일치 | ✅ **참** |

> **dodge-hunt 결과**: arbiter가 "round-21 wire-batch DRY-RUN을 실재로 착각"했는지 검증 → **착각 아님**. 5주장 전건 라이브 직접 SELECT로 실재 확정(wire-batch가 실제로 투명아크릴 사슬을 부분 COMMIT한 흔적). 거짓 토대 아님.

---

## 신규 26행·골든 재현 검증

- **신규 26행 = 공식 3 + comp 2 + 배선 3 + 바인딩 18.** DRY-RUN PASS1 신규 카운트(3+2+3+18=26) 일치. manifest "28 시도 / 26 신규 / 2 스킵"과 정합(스킵 = PRF_CLR_ACRYL·PRD_000146).
- **18 바인딩 상품** 전건 `t_prd_products` 실재(상품명 설계와 일치)·2026-06-15 기존 바인딩 0 → 18 진짜 INSERT.
- **골든 byte 재현**(설계 §6 5좌표 라이브 직접): 20x30=2700/2160·30x30=3100/2480·30x40=3400/2720·50x50=4800/3840·100x100=12700/10160 — 전건 일치. 1.5T=3T×0.8 정확. **단가행 재적재 0**(apply.sql에 component_prices INSERT 없음·주석만) → 골든 불변 보증.

---

## DDL 제안 정합(R4)

본 트랙은 **신규 DDL 제안 없음**(신규 엔티티 미생성). 신규 comp 2종은 기존 `t_prc_price_components` 테이블에 행 추가(스키마 변경 0)·FK 코드값 전부 실재. search-before-mint 충족(COROTTO/CARABINER 부재 확인). 정규화·충돌 위반 0.

---

## BLOCKED 정직성 비준

| BLOCKED-ID | 항목 | 비준 |
|-----------|------|:--:|
| **B-CLR-META (Q-ACR-7)** | PRF_CLR_ACRYL 배선 메타(disp_seq/addtn_yn NULL→1/N) | ✅ **정당** — 라이브 실측으로 NULL 확정. .02 prc_typ 계산법(수량 곱 vs 총액) 엔진 미확정이라 메타 확정 보류는 돈-크리티컬 합당. 03 SQL에 주석 보존(즉시 활성화 가능) |
| **B-MIRROR-BIND (Q-ACR-9)** | PRF_MIRROR_ACRYL 상품 바인딩 | ✅ **정당** — MIRROR3T 단가행 37 실재하나 미러 본체 상품 라이브 불명. 공식정의+배선만 적재(04 바인딩 0행). 추측 바인딩 금지 준수 |
| **B-Q8-BIND (Q-ACR-8)** | 169/159/153 바인딩 | ✅ **정당** — 본체 소재 불명(투명? 미러? 별가격?). 투명 명백분 18만 바인딩 |
| **GAP-COROTTO/CARABINER-PRICE** | 단가행(코롯토21·카라비너4) | ✅ **정당** — comp/공식/배선/바인딩 골격만 닫고 단가행 미동봉. 엔진 룩업 시 GAP 노출(거짓 0 아님) |

> **결함 은폐 검사**: BLOCKED를 핑계로 진짜 결함을 숨겼는지 → **없음**. 미러 바인딩 0·코롯토/카라비너 단가행 0은 정직하게 표기(BLOCKED·GAP 폐루프 명시). 23 아크릴 상품 중 19 바인딩(미러/Q8 4상품만 보류)으로 커버 최대화.

---

## 적발된 사항 (R6 독립성 — 실 발견)

1. **[정정·비결함] golden 카운트 표기 차이**: 생성자 dry-run.md §4가 골든을 "CLEAR3T 84·MIRROR3T 37"(per-comp 분할)로, 본 게이트 집계 쿼리는 "121 합계"로 측정 — 동일값(84+37=121)·모순 아님. 양쪽 골든 불변 결론 일치.
2. **[정정·비결함] 사슬 카운트 스코프 차이**: 생성자가 4테이블 전체 절대 카운트(20/145/89/82)를, 본 게이트가 아크릴 필터 카운트(4/4/4/19)를 보고 — 스코프 차이일 뿐 멱등 결론 동일.
3. **[비결함·정합 확인] component_prices 컬럼명**: 가격 컬럼은 `price`가 아닌 `unit_price`. 설계/SQL은 단가행 미동봉이라 영향 0(검증 쿼리만 정정).
4. **[정직성 확인] 라이브 FK 제약 실재**: `fk_prc_formula_comps_frm_cd` 등 라이브 FK가 실제 enforce됨을 오류주입으로 실증 — 멱등/원자성이 DB 제약으로 뒷받침.

> **거짓 GO·날조·라이브 오인 0건.** 생성자 6 핵심 주장(라이브 진화 5 + 신규 26행) 전건 독립 라이브 재현으로 참 확정. 검증자가 발견한 차이는 전부 스코프/표기 차이(비결함)로, 멱등·원자·골든·FK 결론을 흔들지 않음.

---

## 최종 판정 — **GO** (실 COMMIT은 인간 승인 대기)

R1~R6 + G1~G9 carry-forward 전건 PASS. 신규 26행 멱등 적재 가능·골든 보존·FK 고아 0·원자성 보장·BLOCKED 정직. 실 적재 = **인간 승인 + webadmin Phase11 엔진 동시배포 선결**(엔진 미구현 = 실청구 0). 본 게이트 산출까지 **COMMIT 0**.

### 인간 승인 대기 큐
- 실 COMMIT(영구 적재) — GO 번들 제시 완료.
- B-CLR-META 메타보정(Q-ACR-7 .02 계산법 확정 후 03 주석 해제).
- B-MIRROR-BIND·B-Q8-BIND(미러/169/159/153 상품 정체 확정 후 바인딩).
- GAP-COROTTO/CARABINER 단가행(좌표·opt_cd 확정 후).
