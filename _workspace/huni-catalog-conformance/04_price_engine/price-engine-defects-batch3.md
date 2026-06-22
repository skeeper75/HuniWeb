# price-engine-defects-batch3.md — 스티커·아크릴·실사 가격엔진 결함 보드 + 종단 e2e

> Phase 2 — hcc-price-engine-inspector(생성측) · 2026-06-23 · `huni-catalog-conformance` §21 배치3
> 권위 알고리즘[HARD] = `raw/webadmin/webadmin/catalog/pricing.py` `evaluate_price`. 재조사 금지 —
> `huni-price-quote/01_engine/engine-contract.md` 계약(P1~P8·C1~C9) 인용, 라이브 대조만.
> 라이브 읽기전용 SELECT만·DB 미적재·교정명세까지. 셀 표=`price-engine-cells-batch3.csv`(65 전수·빈 셀 0).

## 0. 요약 (65 prd)

| 구분 | 건수 | 판정 |
|------|------|------|
| BOUND·MATCH (스티커16 + 실사28 + 아크릴1) | **45** | 가격엔진 정합. 과대청구 0·차단 0 |
| MISSING_BIND (아크릴 147~166) | **20** | 차단(가격 0·견적 불가) — 결함 아님(라이브 미충족·권위 의도 존재) |
| NULL_WILDCARD(silent 합산) | **0** | 판별차원 전부 충전 확인 |
| AMBIGUOUS(동시매칭) | **0** | NULL행+값행 공존 없음 |
| WIRE_BROKEN(공식↔구성요소 단절) | **0** | 바인딩된 45 전부 1~2 comp 정상 배선 |

**과대청구 0 비준** — 전 카탈로그 과대청구 스캔(2026-06-23) "미검증 4시트 적출 0"이 라이브 판별차원 충전 재실측으로 재확인됨.

## 1. 결함/리스크 보드

### D-B3-1 · 아크릴 MISSING_BIND 20건 (PRD_000147~166) — 차단·최대 리스크
- **증상**: 라이브 `t_prd_product_price_formulas`에 product→formula 바인딩 0행. `evaluate_price`는
  source 우선순위 3단계(직접단가 0행 → FORMULA)로 떨어진 뒤 frm_cd를 못 찾아 **가격 산출 불가**
  (engine-contract C1·P1-3). 미바인딩 = `[[huni-widget-red-price-never-zero]]` 위반 신호.
- **권위 정답**: 엑셀 acrylic 21명 중 20명에 `가격`(고정단가 2700·2500·3100…) + `가공_가격`(부속물 가산)
  존재 → 가격 모델 의도는 분명히 있음. 고정가형 vs 가공가산형 권위 모델 확정 필요(**CONFIRM Q-ACR-MISSING20**).
- **★재현(부분 데이터 존재 입증)**: 일부 comp는 단가까지 있으나 바인딩만 끊김 —
  - `COMP_ACRYL_COROTTO`(21 단가행) → `PRF_COROTTO_ACRYL` 공식까지 배선됐으나 그 공식에 묶인 product 0건.
  - `COMP_ACRYL_KEYRING`(2 단가행)·`COMP_ACRYL_MIRROR3T`(52 단가행) = 공식 미연결 orphan 단가.
  - 즉 MISSING-20은 "데이터 전무"가 아니라 **product→formula 바인딩(엔진 진입점) 부재**가 핵심.
- **돈영향**: 차단(20상품 견적 0원/불가). 과대·과소 아님.
- **재현 SQL**:
  ```sql
  SELECT p.prd_cd, p.prd_nm,
    (SELECT count(*) FROM t_prd_product_price_formulas f WHERE f.prd_cd=p.prd_cd) bind
  FROM t_prd_products p
  WHERE p.prd_cd BETWEEN 'PRD_000147' AND 'PRD_000166';   -- 전건 bind=0
  SELECT frm_cd,(SELECT count(*) FROM t_prd_product_price_formulas x WHERE x.frm_cd=fc.frm_cd) nprd
  FROM t_prc_formula_components fc WHERE fc.comp_cd='COMP_ACRYL_COROTTO';  -- PRF_COROTTO_ACRYL|0
  ```
- **라우팅**: Q-ACR-MISSING20 권위 모델 인간 확정 → `dbm-price-arbiter`(고정가형 PRODUCT_PRICE vs
  공식형 FORMULA 정립) → `dbm-load-execution`(바인딩+필요시 고정단가 적재). 실 COMMIT 인간 승인.

### R-B3-2 · 실사 ARTPRINT_PHOTO 면적그리드 하한 600mm — 게이트 재측정 후보(확정 아님)
- **관찰**: 공유 comp `COMP_POSTER_ARTPRINT_PHOTO` 라이브 단가행 최소 면적 = 600×600(=12,000),
  600mm 미만 단가행 **없음**. 권위 엑셀 `price`는 A3(297×420)=7,000·A2(420×594)=7,000·A1(594×841)=12,000.
- **함의**: A3/A2 같은 sub-600 주문은 `_row_matches` off-grid → ceiling(P3-4)으로 600×600(12,000)로
  올림 → 권위 7,000 대비 **+5,000 과청구 가능**. 단 실사 최소 출력규격이 600이면 sub-600 자체가
  주문 불가(제약축)라 무해. **A3/A2 주문 허용 여부에 종속** → 확정 결함 아님·게이트가 evaluate_price
  재계산 + 제약(최소사이즈) 대조로 독립 재판정.
- **돈영향**: 조건부 과대(+5,000/매, sub-600 허용 시에만). **현재 단정 불가** → 게이트 재측정.
- **재현 SQL**:
  ```sql
  SELECT min(siz_width*siz_height) FROM t_prc_component_prices WHERE comp_cd='COMP_POSTER_ARTPRINT_PHOTO';
  -- 360000(=600x600). 권위 A3=124740(297x420) 단가행 부재
  ```
- **라우팅**: 게이트 K4 재측정 → (sub-600 허용 확정 시) `dbm-price-arbiter` 면적그리드 하한 보강. 보류.

## 2. CONFIRM 해소 (가격엔진 항목)

### ✅ Q-SILSA-SHARE = **MATCH (해소)** — 공유공식 정합 입증
- **검사**: `COMP_POSTER_ARTPRINT_PHOTO`를 4공식(ARTPRINT/ADH_WP/ARTFABRIC/WATERPROOF)이 공유.
  use_dims=`[siz_width,siz_height,min_qty]` — **소재(mat_cd) 판별차원 없음**(전 52행 mat_cd NULL).
- **권위 대조(silsa-l1.csv `price`)**: 4상품 소재가 다름(인화지/PVC/그래픽천/PET)에도 **권위 단가가
  사이즈별 완전 동일** — A3=7,000·A2=7,000·A1=12,000·사용자입력=20,000 (4상품 전건 일치).
- **판정**: 소재 무관 동일가가 권위 의도 → 소재 판별차원 부재는 **정합(MATCH)**. silent 합산·과대청구
  **아님**(각 공식이 단일 comp만 평가, 교차 합산 구조 자체가 없음 — comp count=1).
- **1택매칭 재현**: 각 공식 1 comp → `_match_entry` 단일 조합 매칭(P3-8 ERR_AMBIGUOUS 미발생). 안전.

### ⏸ Q-ACR-MISSING20 = 인간 확정 대기 (D-B3-1 종속)
- 고정가형(PRODUCT_PRICE 순위2) vs 가공가산형(FORMULA 순위3) 권위 모델 — `가격`/`가공_가격` 양 컬럼 존재.
  인스펙터 임의선택 금지. 게이트는 미해소를 NO-GO 사유로 삼지 않되 추적.

## 3. 종단 e2e 골든 추적 (옵션 선택 → 차원 환원 → 단가행 → final_price)

> 정합의 정석 입증. basedata(차원) + cpq-link(옵션→차원) → 가격 단가행으로 끝까지 환원.

### G-1 (BOUND·정합) — 스티커 PRD_000052 반칼 자유형 스티커
1. **옵션 선택**(cpq-link): 소재=유포(MAT_000155)·사이즈=SIZ_000036·수량=1.
2. **차원 환원**(basedata): `PRF_STK_FIXED` → COMP_STK_PRINT, use_dims=`[siz_cd,mat_cd,min_qty]`.
3. **단가행 매칭**(`_row_matches`): (SIZ_000036, MAT_000155, min_qty≤1 최대) → 정확매칭 **1행**
   (proc_cd/print_opt_cd 전행 NULL=단면 와일드카드, 판별 불요). 동시매칭 0(P3-8 clean).
4. **final_price**: PRICE_TYPE.01 단가형 → per_item = unit_price = **7,000** × qty. ✅ 끊김 없음.

### G-2 (BOUND·합가형 P4-3 안전) — 아크릴 PRD_000146 아크릴키링 (engine-contract 골든 앵커)
1. **옵션**: 두께=3mm(MAT_000042)·가로20×세로20·수량1.
2. **차원 환원**: `PRF_CLR_ACRYL` → COMP_ACRYL_CLEAR3T(PRICE_TYPE.02 합가형), use_dims=`[siz_width,siz_height,mat_cd]`.
3. **단가행 매칭**: mat_cd=두께축(정확매칭) + (20,20) 면적 '이하'티어 → 1행, **min_qty=1 전행**(MAT_000042
   52행·MAT_000043 113행 모두 min_qty≥1, NULL/0 **0건** → P4-3 ValueError 안전).
4. **final_price**: 합가형 구간총액 ÷ min_qty(=1) × qty = **2,000**(20×20·3mm). ✅ 끊김 없음.

### G-3 (BOUND·면적+add-on) — 실사 PRD_000138 일반현수막 (engine-contract 골든 앵커)
1. **옵션**: 가로900×세로1800·타공4개 선택·수량1.
2. **차원 환원**: `PRF_POSTER_BANNER_N` → ① 본체 COMP_POSTER_BANNER_NORMAL `[siz_width,siz_height]`
   ② 타공 add-on COMP_POSTEROPT_BANNER_NORMAL_PROC_PUNCH_4 `[proc_cd,min_qty,proc_grp:PROC_000104]`.
3. **단가행 매칭**: 본체 = (900,1800) '이하'상한 ceiling(P3-4) 1행 / 타공 = proc_cd **충전**(NULL 0건)
   → 선택 시에만 1행 매칭, 미선택 시 no-match 자연 제외(P2-2). **silent 합산 없음**.
4. **final_price**: 본체단가 + 타공단가(선택 시). ✅ 끊김 없음·판별차원 정합.

### G-4 (MISSING·끊김 지점 시연) — 아크릴 PRD_000147 아크릴마그넷
1. **옵션→차원**: 정상(basedata/cpq-link 축은 등록).
2. **단가행 매칭**: source=FORMULA 진입 → `t_prd_product_price_formulas` frm_cd **부재** → 매칭할
   공식 자체 없음. **여기서 끊김** = 가장 비싼 결함(견적 0원/불가). D-B3-1.

## 4. 라우팅 종합

| ID | 결함 | 라우팅 | 인간 승인 |
|----|------|--------|----------|
| D-B3-1 | 아크릴 20 MISSING_BIND | Q-ACR-MISSING20 확정 → dbm-price-arbiter → dbm-load-execution | 필요(모델 확정+적재) |
| R-B3-2 | 실사 면적그리드 하한 600 | 게이트 K4 재측정 → (조건부) dbm-price-arbiter | 보류(게이트 선행) |

- 직접 교정 금지·생성측. 단가값 verbatim 불변·날조 0. v03/STALE 인용 0.
- 게이트(K4)가 evaluate_price 독립 재계산으로 D-B3-1 차단·R-B3-2 조건부과대를 재실측.
