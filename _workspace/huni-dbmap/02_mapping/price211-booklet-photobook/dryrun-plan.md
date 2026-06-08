# DRY-RUN PLAN — price-211 slice C2 (BOOKLET/PHOTOBOOK)

| 항목 | 값 |
|------|----|
| 성격 | **PLAN ONLY — 라이브 DRY-RUN 미실행.** 읽기전용 FK 선존재 검증만 수행(zero write) |
| 적재본 | `load.sql` (BEGIN…ROLLBACK), `load/*.csv` |
| 게이트 | R1~R6 (round-5 적재 실행 게이트 패턴) |

## 1. 적재 행수 (INSERTABLE = 31)

| 테이블 | 신규행 | 멱등 가드 |
|----|:--:|----|
| t_prc_price_formulas | 1 | ON CONFLICT (frm_cd) DO NOTHING |
| t_prc_price_components | 2 | ON CONFLICT (comp_cd) DO NOTHING |
| t_prc_formula_components | 2 | ON CONFLICT (frm_cd,comp_cd) DO NOTHING |
| t_prc_component_prices | 22 | WHERE NOT EXISTS (자연키8 IS NOT DISTINCT FROM) |
| t_prd_product_price_formulas | 4 | ON CONFLICT (prd_cd,frm_cd) DO NOTHING |
| **합계** | **31** | |

BLOCKED(미적재, 분리) = 3: 레더링바인더 바인딩 1 + 포토북 10×10소프트 component_prices 2.

## 2. FK 선존재 검증 (read-only 실측 2026-06-07, zero write) — **PASS**

| FK 부모 | 필요 | 라이브 존재 | 판정 |
|----|----|:--:|:--:|
| FRM_TYPE.01 (합산형) | 1 | 1 | PASS |
| PRC_COMPONENT_TYPE.06 (완제품비) | 1 | 1 | PASS |
| t_siz_sizes 269/274/170/172 | 4 | 4 | PASS |
| t_mat_materials 005/006/007 | 3 | 3 | PASS |
| PRF_BIND_SUM (하드커버 바인딩 부모) | 1 | 1 | PASS |
| t_prd_products 072/077/082/100 | 4 | 4 | PASS |
| COMP_BIND_HC_MUSEON/HC_TWINRING (제본 단가 선존재) | 2 | 2 | PASS (§STATUS) |

## 3. R1~R6 게이트 (예상)

| 게이트 | 내용 | 예상 | 근거 |
|----|----|:--:|----|
| R1 멱등 | 2-pass 재실행 0행 | PASS | 모든 INSERT에 ON CONFLICT / NOT EXISTS 가드. 사전 존재행 0(실측). |
| R2 제약위반 | CHECK/NOT NULL/FK 0 | PASS | use_yn='Y', addtn_yn='Y', apply_ymd='2026-06-01', FK 부모 전건 존재(§2). |
| R3 FK 고아 | 0 | PASS | §2 전건 PASS. |
| R4 자연키중복 | component_prices 8키 CSV 내 중복 0 | PASS | (comp_cd,apply_ymd,siz_cd,mat_cd) 22행 유일(나머지 NULL). |
| R5 COMMIT | 0 (ROLLBACK only) | PASS | load.sql 말미 ROLLBACK. 실 COMMIT=인간 승인. |
| R6 IDENTITY 시퀀스 | component_prices.comp_price_id stale 가드 | **주의** | comp_price_id=bigint IDENTITY. round-5/디지털 적재에서 seq stale 적발 전례 → **실 적재 전 setval 재동기화 선행 필수**(아래 §4). |

## 4. 실 적재 시 선행조건 (인간 승인 후)

1. **IDENTITY 시퀀스 재동기화** (R6 함정): 실 COMMIT 전
   `SELECT setval(pg_get_serial_sequence('t_prc_component_prices','comp_price_id'),
   (SELECT max(comp_price_id) FROM t_prc_component_prices));` 선행. (디지털인쇄 적재 교훈.)
2. `load.sql` 말미 `ROLLBACK;` → `COMMIT;` 교체.
3. 2-pass 멱등 확인(재실행 0행).
4. 적재 후 검증: 포토북 가격조회 사슬 완결성(아래 §5 recompute).

## 5. recompute check (page-band, 적재 후 권위 검증용)

포토북 A4 하드커버, 40페이지 주문 예시:
- base = COMP_PBK_BASE24P[siz=SIZ_000172, mat=MAT_000005] = 16000
- add2P = COMP_PBK_ADD2P[siz=SIZ_000172, mat=MAT_000005] = 600
- pages=40 → 증분구간 = ceil((40−24)/2) = 8
- 판매가 = 16000 + 8 × 600 = **20800** (앱 런타임 계산. DB는 16000·600 lookup만 저장).

[HARD] DB에는 40·20800 같은 page-baked 값이 없어야 한다(adversarial 확인). component_prices에는
base 16000 / add2P 600 두 행만 존재(siz·mat 차원, page count는 차원 아님).
