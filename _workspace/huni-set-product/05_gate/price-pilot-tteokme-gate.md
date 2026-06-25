# 가격 파일럿 독립 게이트 — 떡메모지(PRD_000097) 가격공식 바인딩

검증: hsp-set-gate (생성≠검증·set-designer 주장 비신뢰·직접 재실측) · 라이브 읽기전용 SELECT + 롤백전용 DRY-RUN · 자격증명 `.env.local RAILWAY_DB_*` · 실측일 2026-06-25 · **DB 미적재(COMMIT 0)** · 단가 verbatim·날조 0.

검증 대상 = `t_prd_product_price_formulas` 1행 INSERT: `(PRD_000097, PRF_TTEOKME_FIXED, 2026-06-01)`. PK=(prd_cd, apply_bgn_ymd)·신규 mint 0(바인딩 연결만).

---

## 0. 종합 판정 — ✅ **GO**

| 게이트 | 판정 | 핵심 근거(직접 재실측) |
|---|---|---|
| S1 권위/공식 충실성 | ✅ PASS | PRF/comp/formula_components/112 단가행 전부 라이브 실재·use_dims 정합 |
| S2 구성원 유형 정합 | ✅ PASS | 097=PRD_TYPE.01(완제품 부모)·098=PRD_TYPE.02(반제품 구성원) 라이브 실측 |
| S3 무결성 | ✅ PASS | 097 바인딩 0행(충돌 0)·FK 2개 실재·직접단가 0(공식 적용)·할인 0 |
| S4 가격 e2e [HARD·돈] | ✅ PASS | 골든1=60,000·골든2=19,200 독립 재현 정확 일치(허용오차 0)·PRICE≠0·이중합산 0 |
| S5 경쟁사 흡수 | ✅ N/A-PASS | 신규 mint 0·naming/codes 유입 0(전부 라이브 재사용)·권위 덮어쓰기 0 |
| S6 적재 가능성 DRY-RUN | ✅ PASS | INSERT 0 1→재실행 INSERT 0 0(멱등 delta 0)·부작용 0·ROLLBACK 무변경 |
| S7 생성≠검증 독립성 | ✅ PASS | 전 게이트 직접 psql 재실측·설계 주장 인용 의존 0·codex 미해결 0 |

**단일 FAIL 0 → GO.** 097 가격공식 바인딩은 라이브 적재 안전. CFM-097(apply_bgn_ymd) 라이브 3중 정합 확인.

---

## 1. S1 — 권위/공식 충실성 (✅ PASS)

라이브 직접 실측(set-designer 주장 비신뢰·verbatim 재확인):

| 항목 | 라이브 실측값 | 설계 주장 | 정합 |
|---|---|---|---|
| PRF_TTEOKME_FIXED 정의 | 실재·frm_nm="떡메모지 사이즈/권당장수/장수별 단가"·use_yn=Y | 라이브 실재 | ✅ |
| formula_components | COMP_TTEOKME·disp_seq=1·addtn_yn=Y (1건) | 1 comp | ✅ |
| COMP_TTEOKME prc_typ_cd | PRICE_TYPE.01(단가형) | 단가형 | ✅ |
| COMP_TTEOKME use_dims | `["siz_cd","bdl_qty","min_qty"]` | 동일 | ✅ |
| component_prices 행수 | **112행**·apply_ymd 전부 2026-06-01 | 112행 | ✅ |

- 권위 = set-price-authority §1.4 고정가형 `판매가 = [수량행][옵션열]`(calc-formula L72 `*(가격포함)`). 단일 통합단가 comp가 내지·표지·제본·용지 내장 → 고정가형 정합.
- `t_prc_price_formulas`에는 del_yn 컬럼 부재(use_yn만 존재) — 설계 산출물의 "del_yn" 표기는 무해한 오기(use_yn=Y로 실측 대체). 판정 무영향.

## 2. S2 — 구성원 유형 정합 (✅ PASS)

```
PRD_000097  떡메모지              prd_typ_cd=PRD_TYPE.01  del_yn=N use_yn=Y  ← 셋트 완제품(부모)
PRD_000098  떡메모지-내지(백모조120) prd_typ_cd=PRD_TYPE.02  del_yn=N use_yn=Y  ← 반제품(구성원)
```
- 셋트 부모 097 = PRD_TYPE.01(완제품)·구성원 098 = PRD_TYPE.02(반제품). admin.py:1082 인라인 필터 규칙(구성원=반제품) 정합. 완제품/기성/디자인 혼입 0.
- 본 트랙은 가격 바인딩 전용 — t_prd_product_sets 구성행 변경 없음(이전 §23 세션 COMMIT 완료분 이월).

## 3. S3 — 무결성 (✅ PASS)

| 검사 | 실측 | 판정 |
|---|---|---|
| 097 현재 바인딩 행수 | **0행** → PK 충돌 0 | ✅ |
| PK 제약 | `PRIMARY KEY (prd_cd, apply_bgn_ymd)` (frm_cd 미포함·apply.sql ON CONFLICT 정합) | ✅ |
| FK frm_cd | `→ t_prc_price_formulas(frm_cd)` · PRF_TTEOKME_FIXED 실재 | ✅ 고아 0 |
| FK prd_cd | `→ t_prd_products(prd_cd)` · PRD_000097 실재 | ✅ 고아 0 |
| 097 직접단가(t_prd_product_prices) | **0행** → 공식이 가격 소스(evaluate_price L405-419) | ✅ |
| 098 가격공식·직접단가 | **0행·0행** → 구성원 contribution=0 | ✅ |
| 097 수량구간 할인(t_prd_product_discount_tables) | **0행** → 할인 없음 | ✅ |

## 4. S4 — 가격 e2e [HARD·돈 크리티컬] (✅ PASS)

상세 종단 재현 → `price-pilot-tteokme-e2e.md` 참조. 엔진 계약(`pricing.py`) 그대로 손계산·SQL 재현(허용오차 0).

### 엔진 계약 확인 (라이브 코드 재실측)
- `NON_QTY_DIMS`(L42-43)에 **`bdl_qty` 포함** → `_row_matches`에서 정확매칭. use_dims 정합.
- `match_component`(L122): siz_cd·bdl_qty 정확매칭(NULL=와일드카드), min_qty 티어(L162-166: 주문값 이하 최대 임계).
- `component_subtotal`(L196) 단가형: unit_price × qty.
- `evaluate_set_price`(L718): 구성원 합산(L759-786) + 셋트 자기공식(L789) + 할인 1회(L807). 구성원 qty<1 → "합산 제외"·contribution=0(L766-773).

### 골든1 — 90x90(SIZ_000119) / 50장1권(bdl_qty=50) / 30권(copies=30)
| 단계 | 재현 |
|---|---|
| [A] 구성원 098 | 가격공식 0행 → evaluate_price base=0 → contribution=0·included=False |
| [B] 셋트공식 097 | PRF_TTEOKME_FIXED → COMP_TTEOKME 매칭행: siz=119·bdl=50 정확매칭·기타 NON_QTY 전부 NULL(와일드카드)·단일 combo(ambiguous 0)·min_qty≤30 최대=30 → unit_price=**2,000**(행 3925·단일·duplicate 0) |
| 소계 | 단가형 2,000 × 30 = **60,000** |
| [C] base_total | 0 + 60,000 = 60,000 |
| [D] 할인 | 097 discount 0행 → 0 |
| [E] final | round_won(60,000) = **60,000** ✅ PRICE≠0 |

→ 설계 골든1 **60,000원 일치**. 트랜잭션 내 SQL 재현 g1_subtotal=60000.00 동일.

### 골든2 — 70x120(SIZ_000266) / 100장1권(bdl_qty=100) / 6권(copies=6)
| 단계 | 재현 |
|---|---|
| 매칭행 | siz=266·bdl=100 정확매칭·min_qty≤6 최대=6 → unit_price=**3,200**(행 3912·단일·duplicate 0) |
| 소계 | 3,200 × 6 = **19,200** |
| final | 098=0·할인 0 → **19,200** ✅ PRICE≠0 |

→ 설계 골든2 **19,200원 일치**. SQL 재현 g2_subtotal=19200.00 동일.

### 이중합산 점검 (돈)
- COMP_TTEOKME = 단일 comp(통합단가) → comp간 중복 0.
- 구성원 098 가격공식 0행 → 구성원 기여 0 → 셋트공식과 이중계상 0.
- 골든 매칭행 단일 combo·단일 티어행(라이브 COUNT 검산) → silent 다중매칭 0.
→ **이중합산 = 0**(입증).

### 단가 verbatim sanity (날조 0)
- 90x90/50/30권 행 3925 = 2,000·90x90/50/6권 행 3909 = 3,000·90x90/50/600권 행 4017 = 850 → 설계 표 일치.
- 70x120/100/6권 행 3912 = 3,200 → 설계 표 일치. **날조·모호성 0**.

## 5. S5 — 경쟁사 흡수 타당 (✅ N/A-PASS)

- 본 파일럿 = 신규 mint 0(PRF·comp·112 단가행·formula_components 전부 라이브 재사용). 경쟁사/도메인 보강으로 권위 덮어쓰기 0·naming/codes 후니 유입 0.
- 단가 출처 = 인쇄상품 가격표(260527) 엽서북/떡메 시트 → round-16 적재. verbatim 정합.

## 6. S6 — 적재 가능성 DRY-RUN (BEGIN…ROLLBACK·✅ PASS)

롤백전용 트랜잭션 실증(COMMIT 0):

| 단계 | 실측 결과 |
|---|---|
| before | 097=0행·total=77 |
| 1st INSERT | `INSERT 0 1` → 097=1·total=78 (제약위반 0) |
| 2nd INSERT(멱등) | `INSERT 0 0` → 097=1·total=78 (**멱등 delta 0**) |
| 부작용 | 097 외 행수 77 불변 (**타 상품 영향 0**) |
| 삽입행 | `PRD_000097 | PRF_TTEOKME_FIXED | 2026-06-01` (기대 일치) |
| ROLLBACK 후 | 097=0행 (**무변경**) |
| 견적 재현(트랜잭션 내) | g1=60,000·g2=19,200 (**바인딩 후 PRICE≠0** 실증) |

예상 적재 카운트 = **INSERT 1행**(097 바인딩). UPDATE 0·DELETE 0.

## 7. S7 — 생성≠검증 독립성 (✅ PASS)

- S1~S6 전부 hsp-set-gate가 직접 psql 읽기전용 SELECT·DRY-RUN으로 재실측(설계 주장은 인용·대조 목적·신뢰 의존 0).
- 엔진 계약(pricing.py)도 직접 Read해 bdl_qty NON_QTY 포함·티어 로직·구성원 비기여 경로 독립 확인.
- codex reconcile 미해결 0(본 파일럿 codex 레인 미해당·Claude 단독 명시).

---

## 8. CFM-097 판정 (apply_bgn_ymd=2026-06-01) — ✅ PASS

라이브 3중 정합:
- COMP_TTEOKME 단가행 apply_ymd = **전부 2026-06-01**(견적 as_of 정합).
- 엽서북 094 선례 바인딩 apply_bgn_ymd = **2026-06-01**(동형 고정가 셋트·PRF_PCB_FIXED).
- 전체 바인딩 76행이 2026-06-01(압도적 패턴)·1행만 2026-06-15.
→ 추정 아닌 라이브 근거 충분. **CFM-097 = PASS**(인간 확인 형식 권고는 가능하나 적재 차단 사유 아님).

---

## 9. 적재 GO 큐 → hsp-load-executor

| 대상 t_* | 작업 | 행 | 멱등 키 | 인간 승인 |
|---|---|---|---|---|
| t_prd_product_price_formulas | INSERT `(PRD_000097, PRF_TTEOKME_FIXED, 2026-06-01, note)` ON CONFLICT (prd_cd, apply_bgn_ymd) DO NOTHING | 1 | (prd_cd, apply_bgn_ymd) | 필요(돈 크리티컬) |

- apply.sql 그대로 사용 가능(검증 완료). 단일 트랜잭션 래핑·사후검증 SELECT 1행 기대.
- 본 게이트는 COMMIT 안 함 — 인간 승인 후 load-executor가 COMMIT.

## 10. 잔여 결함 / BLOCKED

- **없음.** 097 가격 바인딩 단독 트랙 결함 0.
- (범위 외 이월) 094 엽서북 S1/S2 silent 이중합산·prc_typ ×qty(§18 R-3)·088 보류·072/077/082/100 적재 대상은 본 파일럿 무관(set-price-authority §3 트랙).

## 11. 출처 (날조 0)
- 라이브 실측(2026-06-25 읽기전용 SELECT): 097/098 prd_typ·PRF 정의·formula_components·COMP_TTEOKME use_dims+112 단가행·097 바인딩 0행·직접단가 0·098 공식 0·097 할인 0·PK/FK 제약·골든 매칭행(2,000/3,200)·DRY-RUN(INSERT 0 1→0 0·부작용 0·ROLLBACK 무변경)·CFM apply_ymd 정합.
- 엔진: `raw/webadmin/webadmin/catalog/pricing.py` L42-43(NON_QTY_DIMS·bdl_qty)·L122-178(match_component)·L181-196(component_subtotal)·L340-459(evaluate_price)·L537-596(_evaluate_formula)·L718-827(evaluate_set_price).
- 권위: set-price-authority.md §1.4. 설계: price-pilot-tteokme-design.md·apply.sql(인용·대조 목적·비신뢰).
