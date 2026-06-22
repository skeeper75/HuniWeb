# e2e-golden-trace-batch3.md — 배치3 종단 골든 추적 (옵션→차원→단가행→final_price)

> Phase 4 — hcc-conformance-gate · 2026-06-23 · §21 배치3. 게이트 라이브 evaluate_price 재계산(허용오차 0).
> 정합의 정석: 사용자 옵션 선택부터 최종 가격까지 게이트가 직접 재현. 라이브 읽기전용.

## G-1 (BOUND·정합) — 스티커 PRD_000052

| 단계 | 값(게이트 재측정) |
|------|-------------------|
| 옵션 선택 | 소재=유포(MAT_000155)·사이즈=SIZ_000036·수량=1 |
| 바인딩 | PRF_STK_FIXED (라이브 bind 확인) |
| 차원 환원 | COMP_STK_PRINT · use_dims=[siz_cd,mat_cd,min_qty] · PRICE_TYPE.01(단가형) |
| 단가행 매칭 | (SIZ_000036, MAT_000155, min_qty=1) → **1행**, proc_cd/print_opt_cd NULL(단면 와일드카드) |
| **final_price** | **7,000** × qty=1 = **7,000** ✅ 골든 일치(오차 0) |

## G-2 (BOUND·합가형 P4-3 안전) — 아크릴키링 PRD_000146

| 단계 | 값 |
|------|----|
| 옵션 | 두께=3mm(MAT_000042)·20×20·수량1 |
| 바인딩 | PRF_CLR_ACRYL |
| 차원 환원 | COMP_ACRYL_CLEAR3T · use_dims=[siz_width,siz_height,mat_cd] · PRICE_TYPE.02(합가형) |
| P4-3 안전 | comp 165행 중 min_qty NULL/0 = **0건** → ValueError 안전(직접 카운트) |
| 단가행 매칭 | (mat=MAT_000042, 20×20 이하티어) → 1행 |
| **final_price** | **2,000** ✅ 골든 일치(오차 0) (참고: 20×30=2,160·20×40=2,400 티어 정상) |

## G-3 (BOUND·면적+add-on) — 일반현수막 PRD_000138

| 단계 | 값 |
|------|----|
| 바인딩 | PRF_POSTER_BANNER_N |
| 차원 환원 | ① 본체 COMP_POSTER_BANNER_NORMAL [siz_width,siz_height] ② 타공 COMP_POSTEROPT_BANNER_NORMAL_PROC_PUNCH_4 [proc_cd,min_qty,proc_grp:PROC_000104] |
| 단가행 매칭 | 본체=(가로,세로) 이하 ceiling 1행 / 타공=proc_cd 충전(선택 시만 매칭·미선택 no-match 자연제외 P2-2) |
| final_price | 본체 + 타공(선택 시). ✅ silent 합산 없음·판별차원 정합(2-comp 배선 라이브 재현) |

## G-4 (MISSING·끊김 시연) — 아크릴마그넷 PRD_000147

| 단계 | 값 |
|------|----|
| 옵션→차원 | 정상(basedata/cpq 축 등록) |
| 단가행 매칭 | source=FORMULA 진입 → t_prd_product_price_formulas **bind=0**(게이트 직접 카운트) → 공식 부재 → **끊김** |
| 결과 | 가격 산출 불가(견적 0원). [[huni-widget-red-price-never-zero]] 위반 신호. D-B3-1(20상품 동형). |

## ★ R-B3-2 면적그리드 A-사이즈 과대청구 — evaluate_price ceiling 재계산 (게이트 신규 격상)

> 인스펙터 "조건부"·codex "confirmable" → 게이트 **확정** + A1 +8,000 신규발굴.

**메커니즘**: pricing.py L49-50 `TIER_UPPER=(siz_width,siz_height)` '이하 상한'. 주문값 이상 최소 임계행 선택. 그리드 최소=600×600. sub-600 입력 → 600(또는 그 이상) 행으로 ceiling 상향.

**재현(118/120/121/123 동일·4상품 각 A3/A2/A1 selectable preset, 제약 width≥200만 강제):**

| 프리셋 | 입력 | 엔진 ceiling 매칭행 | 엔진가 | 권위가(silsa-l1) | 과대 |
|--------|------|---------------------|--------|------------------|------|
| A3 | 297×420 | 600×600 | 12,000 | 7,000 | **+5,000** |
| A2 | 420×594 | 600×600 | 12,000 | 7,000 | **+5,000** |
| A1 | 594×841 | (594<600→상향) | **20,000** | 12,000 | **+8,000** |
| 사용자입력 | ≥600 | on-grid | 20,000 | 20,000 | 0 |

재현 SQL(요지):
```sql
-- 그리드 하한 = 600x600, sub-600 행 0
SELECT min(siz_width), min(siz_height) FROM t_prc_component_prices WHERE comp_cd='COMP_POSTER_ARTPRINT_PHOTO';  -- 600|600
-- 프리셋별 ceiling 가격
SELECT pr.siz_nm, (SELECT cp.unit_price FROM t_prc_component_prices cp
  WHERE cp.comp_cd='COMP_POSTER_ARTPRINT_PHOTO' AND cp.siz_width>=pr.w AND cp.siz_height>=pr.h
  ORDER BY cp.siz_width, cp.siz_height LIMIT 1)
FROM (presets of 118/120/121/123) pr;  -- A3=12000 A2=12000 A1=20000
```
**근본**: A3/A2/A1 고정가 프리셋 행(7,000/7,000/12,000) **미적재**(사용자입력 ≥600 연속티어만 적재). authority `price`가 프리셋별 고정가인데 면적매트릭스로만 평면화한 적재 오류.

## codex 가설 2건 — 게이트 라이브 기각 (double-count 없음)

| 가설 | 재현 | 결과 |
|------|------|------|
| H1 스티커 tuple 중복 | (siz_cd,mat_cd,min_qty) GROUP BY HAVING>1 (STK_PRINT/TATTOO/GANGPAN) | **0/0/0 기각** |
| H2 실사 formula_components 중복 | (frm_cd,comp_cd) GROUP BY HAVING>1 | **0 기각** (5공식 각 1행) |

→ 동시매칭(ERR_AMBIGUOUS)·double-count 실재 0. 과대청구 면 = R-B3-2(off-grid ceiling)가 유일하며, 이는 tuple/연결 중복이 아니라 **프리셋 행 미적재**가 원인.
