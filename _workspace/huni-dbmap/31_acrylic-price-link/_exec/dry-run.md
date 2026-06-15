# 아크릴 가격사슬 — 롤백전용 라이브 DRY-RUN 결과

> **실행** 2026-06-15 · `dbm-load-builder`(빌드 §2 지시). 라이브 `BEGIN…ROLLBACK` 1회·**NEVER COMMIT**.
> 본 결과는 생성자 예비 실증 — 게이트 권위는 `dbm-validator` R1~R6(`03_validation/`). 자기승인 아님.

---

## 1. R1 — 멱등성 (2회 적용·델타 0) ✅

같은 트랜잭션에서 `apply.sql` 본문 2회 실행:

| 테이블 | after1 | after2 | 멱등 |
|--------|:--:|:--:|:--:|
| t_prc_price_formulas | 20 | 20 | ✅ |
| t_prc_price_components | 145 | 145 | ✅ |
| t_prc_formula_components | 89 | 89 | ✅ |
| t_prd_product_price_formulas | 82 | 82 | ✅ |

2회차 INSERT 전건 **`INSERT 0 0`**(0행 영향) — ON CONFLICT 가드 정상. 충돌키 = 라이브 PK 일치.

## 2. R5 — 제약 위반 (FK 고아·0이어야 PASS) ✅

| 어서션 | 결과 |
|--------|:--:|
| formula_components.frm_cd → price_formulas 미존재 | **0행** ✅ |
| formula_components.comp_cd → price_components 미존재 | **0행** ✅ |
| binding.frm_cd → price_formulas 미존재 | **0행** ✅ |
| binding.prd_cd → t_prd_products 미존재(아크릴) | **0행** ✅ |
| 신규 comp comp_typ_cd/prc_typ_cd → t_cod_base_codes 미존재 | **0행** ✅(괄호 정확 재실행) |

> 첫 통합 어서션에서 COROTTO 1행이 출력됐으나 이는 `OR…AND` 연산자 우선순위 아티팩트(고아 아님). 괄호 정확 재실행 시 0행 확정 — `PRC_COMPONENT_TYPE.01`·`PRICE_TYPE.01` 라이브 실재(코드 [8]/[9] 사전 확인).
>
> 타입/길이/NOT NULL/CHECK: ON_ERROR_STOP=1 하 전 INSERT 무중단 실행 = 위반 0. reg_dt 컬럼 omit으로 DEFAULT now() 발화(명시 NULL 회피).

## 3. 라이브 진화 교차 — arbiter "라이브 진화" 주장 전건 실증 ✅

| arbiter 주장(acrylic-chain-design §0) | DRY-RUN 교차 결과 | 판정 |
|------|------|:--:|
| `PRF_CLR_ACRYL` 라이브 실재 | 01 첫 INSERT `INSERT 0 0`(스킵)·before formulas=1 | ✅ 참 |
| `COMP_ACRYL_CLEAR3T` prc_typ **.02**·dims `[siz_cd,mat_cd,min_qty]` | 라이브 실측 prc=PRICE_TYPE.02·dims 일치 | ✅ 참 |
| `COMP_ACRYL_MIRROR3T` prc .01·dims `[siz_cd,mat_cd]` | 라이브 실측 일치 | ✅ 참 |
| 배선 `PRF_CLR_ACRYL→CLEAR3T` seq/addtn **NULL** | 라이브 실측 seq=NULL·addtn=NULL | ✅ 참(메타 보정 필요) |
| 바인딩 `PRD_000146→PRF_CLR_ACRYL` apply_bgn_ymd 2026-06-15 | 04 첫 INSERT `INSERT 0 0`(스킵)·before binding=1 | ✅ 참 |

> arbiter의 "round-21 wire-batch 부분 적재" 주장이 **거짓 토대 아님** — 라이브가 실제로 투명아크릴 사슬을 부분 보유. 본 빌드는 그 위에 나머지(미러 공식정의·코롯토·카라비너·22상품 바인딩)를 안전히 얹음.

## 4. 골든 재현 (단가행 불변) ✅

| comp | DRY-RUN 후 카운트 | 기대(불변) |
|------|:--:|:--:|
| COMP_ACRYL_CLEAR3T | 84 | 84 ✅ |
| COMP_ACRYL_MIRROR3T | 37 | 37 ✅ |

단가행(t_prc_component_prices) 재적재 0 — apply.sql에 component_prices INSERT 없음. 골든 보존(키링 20x20=2,500 등 룩업 불변).

## 5. 신규분 노출 (before → after)

| 사슬 | before | after | 신규 |
|------|:--:|:--:|:--:|
| formulas(아크릴) | 1 | 4 | +3(MIRROR/COROTTO/CARABINER) |
| components(아크릴) | 4 | 6 | +2(COROTTO/CARABINER) |
| wiring(아크릴) | 1 | 4 | +3 |
| binding(아크릴) | 1 | 19 | +18 |

## 6. 안전

- 전 쿼리 `BEGIN…ROLLBACK` — **COMMIT 0**(ROLLBACK 로그 확인).
- `RAILWAY_DB_*`는 `.env.local`에서만·`PGPASSWORD` 환경변수·stdout/`_workspace` 미기록.
- 실 적재 = 인간 승인 + Phase11 엔진 동시배포 선결(엔진 미구현 = 실청구 0).
