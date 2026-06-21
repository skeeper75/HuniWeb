# gate-verdict-accessory.md — 상품악세사리(AC-1 단일고정가 + AC-2 변형고정가 + 이중역할 SKU addon) 가격엔진 설계 독립 검증 (E1~E7)

> **hpe-validator 독립 검증 (생성≠검증).** engine-designer 설계 주장을 라이브 t_prd_*·t_prc_*·권위 엑셀(260610 상품악세사리 가격포함 시트 I열)로 직접 재실측해 결판.
> 라이브 읽기전용 SELECT 실측 2026-06-22(Railway `db railway`·psql) · pricing.py(`raw/webadmin/webadmin/catalog/pricing.py`) 코드 직접 검증 · 골든 GC-AC1~15 충실 재구현(허용오차 0).
> 검증 대상: `03_design/engine-design-accessory.md`·`golden-cases-accessory.md`(GC-AC1~15)·`design-decisions.md` 상품악세사리절(D-AC-1~9)·`set-product-design.md` §12.
> 기준점: `01_formula/formula-map-accessory.md`·`02_benchmark/absorption-candidates-accessory.md`(C-AC1~7). 동형 선례: `04_validation/gate-verdict-goods-pouch.md`(GP-1/GP-2).

---

## 0. 종합 판정: **GO** (E1~E7 전건 PASS · 차단 결함 0 · 보정 요구 0 · 정정 권고 1[LOW·문서·가격 무영향])

상품악세사리는 **첫 게이트부터 GO**(아크릴·실사·문구·책자·굿즈 GO 동류·디지털 NO-GO와 대조). 7번째 종단·계산방식은 **inline 고정가형 단일 유형**(면적/원자합산/매트릭스/세트/수량구간할인 전부 0)으로 굿즈와 직계 동형이며, 라이브 가격사슬은 **양 경로(PRODUCT_PRICE·TEMPLATE_PRICE) 단가 모두 0행**으로 6종단 통틀어 완성도 최저다(cartographer 지도를 라이브가 전부 확인).

핵심 결판 5가지를 라이브로 독립 재실측해 **전부 designer 정확**: ① AC-1 PRODUCT_PRICE 단일가 무손실 ② AC-2 (b)variant-매트릭스 formula 그릇(LINEN_FINISH 선례 실재) ③ G-AC-1 평탄화 가드 ④ G-AC-2 묶음 .01 단가형 가드 ⑤ G-AC-3 addon TEMPLATE_PRICE 선점 + GP-2 PRODUCT_PRICE 선점 가드. 골든 GC-AC1~14 허용오차 0 재현·GC-AC15 묶음수 불일치 BLOCKED(정직)·돈크리티컬 양면(평탄화 3250↔1100·.02 붕괴 1100↔22) 독립 재현. 신규 mint 최소(공식 3+comp 3·신규 테이블/가격축 0). **OTC 거울/키링 사실무근 정정 라이브 확인.**

| 게이트 | 판정 | 핵심 근거(라이브 실측 2026-06-22) |
|--------|------|------------------------------------|
| E1 공식 추출 충실성 | **PASS** | calc-draft AC 전용 공식 부재·상품마스터 I열 inline이 권위·67 variant행 단가 verbatim 셀 단위 재대조(날조·누락 0)·v03 미인용. AC-1 distinct 가격=1(볼체인1000/와이어링500/리필2500)·AC-2 variant별 단가 일치 |
| E2 구성요소 분해 정합 | **PASS** | AC-1 PRODUCT_PRICE(차원없는 단일가·comp 침입 불가·product_prices 컬럼=prd_cd/apply_ymd/unit_price/note만)·AC-2 COMP_ACC_* 1배선(siz_cd/opt_cd/bdl_qty 판별차원)·면적매트릭스 아님(siz_width 미사용)·시트경계 SOT 1 |
| E3 경쟁사 흡수 타당성 | **PASS** | 신규 가격축 0·naming(tmpl_price/jobcost/papername/DIR_MTR) 유입 0·굿즈 GP 동형 전파가 답습 아닌 메커니즘 흡수·자재오염 dbmap 위임 스코프 분리 적절 |
| E4 엔진 설계 건전성 | **PASS** | TEMPLATE→PRODUCT_PRICE→FORMULA(:285-326)·NON_QTY_DIMS에 siz_cd/opt_cd/bdl_qty(:38-39)·.01 단가형 unit×qty(:177-192)·LINEN_FINISH 선례 실재·묶음 .01 가드·GP-2 선점 가드·평탄화 가드·search-before-mint(PRF_ACC_*/COMP_ACC_* 라이브 0행 입증) |
| E5 세트/이중역할 SKU 정합 | **PASS** | t_prd_product_sets 악세사리 0행·세트 레이어 불요 라이브 확정·봉투 이중역할(독립 PRODUCT_PRICE + 엽서 addon TEMPLATE_PRICE) 경로 분기·addon 5행+template 5행(base_prd_cd 매핑 정확) 실재·가격 충돌 없음 |
| E6 골든 재현 | **PASS** | GC-AC1~14 **14/14 일치(허용오차 0)**·GC-AC15 묶음수 불일치 BLOCKED 정직·평탄화 양면(66%/78.6% 과소)·.02 붕괴(98%) 독립 재현 |
| E7 생성검증 독립성 | **PASS** | 핵심 5결판·AC 분류·inline 단가·variant 그릇 실재·이중역할·OTC 사실무근 전부 라이브 독립 재실측·골든 충실 재구현·dodge/self-approve 없음 |

---

## E1 — 공식 추출 충실성 (cartographer 지도 ↔ 권위 엑셀/라이브 셀 재대조) · **PASS**

**재현 SQL:**
```sql
-- AC 18상품 정체·가격사슬 완성도
SELECT prd_cd, prd_nm, prd_typ_cd, use_yn, del_yn FROM t_prd_products
 WHERE prd_cd IN ('PRD_000001'..'PRD_000015','PRD_000281'..'PRD_000283') ORDER BY prd_cd;
SELECT count(*) FROM t_prd_product_prices         WHERE prd_cd IN (...);  -- 0
SELECT count(*) FROM t_prd_product_price_formulas WHERE prd_cd IN (...);  -- 0
SELECT count(*) FROM t_prd_product_discount_tables WHERE prd_cd IN (...); -- 0
SELECT count(*) FROM t_prd_template_prices WHERE tmpl_cd IN ('TMPL-000005','006','009','010','011');  -- 0
```

| 항목 | 설계 기술 | 라이브/권위 실측 | 판정 |
|------|-----------|-------------------|------|
| 계산방식 유형 | inline 고정가형 단일(AC-1/AC-2) | calc-draft AC 전용 row 부재·상품마스터 I열 inline 권위·면적/원자/세트/구간할인 0 | ✓ |
| AC-1 단일고정가 3상품 | 볼체인8색=1000·와이어링3색=500·리필7색=2500(distinct=1) | CSV row37~44/45~47/63~69 전부 동가 verbatim | ✓ |
| AC-2 변형고정가 11상품 | variant별 단가 | CSV OPP 70x200=1100·230x350=3250·트래싱지 20/40/100장=6000/12000/28000·카드 화1000/흑1500 verbatim | ✓ |
| product_prices(고정가 본체) | 0행 | **0** | ✓ |
| formula 바인딩 | 0행 | **0** | ✓ |
| template_prices(봉투 addon) | 0행 | **0** | ✓ |
| 구간할인 바인딩 | 0행(부자재 미해당) | **0** | ✓ |
| prd_typ_cd(18 전수) | PRD_TYPE.03(기성품)·round-13 ".05" 거짓 정정 | **18 전건 PRD_TYPE.03** | ✓ designer 정정 확인 |
| 천정고리 008 use_yn | N(판매중지·제외) | **N** | ✓ |

- **날조 0·누락 0.** AC-1/AC-2 단가 67 variant행이 상품마스터 I열 verbatim과 일치(designer 창작 0). 라이브 완성도 수치(0/0/0/0)도 전건 일치.
- **v03 인용 차단**: 설계는 상품마스터(260610)+라이브만 인용·인쇄상품 가격표는 해당 블록 없음(봉투제작 PRD_000050=PRD_TYPE.01 별 상품군 라이브 확인·혼동 금지 정당). ✓
- **LOW 정정 1(문서·가격 무영향)**: engine-design §5 표는 "와이어링007·행택끈010은 2026-06-22 라이브 0행·round-13 GATE-1 stale"이라 기술 — 가격 무관 자재축 stale 주장이라 본 검증 미확인 영역이나 가격 결론 불변(가격엔진은 inline 고정가 verbatim만). 자재오염 실재는 볼체인 8색 MAT_TYPE.10(MAT_000202~209) 라이브 확인.

---

## E2 — 구성요소 분해 정합 (시트 차원경계 SOT 1·완제품/반제품) · **PASS**

**재현 SQL:**
```sql
SELECT column_name FROM information_schema.columns WHERE table_name='t_prd_product_prices';
-- prd_cd|apply_ymd|unit_price|note|reg_dt|upd_dt  (차원 컬럼 없음)
SELECT column_name FROM information_schema.columns WHERE table_name='t_prc_component_prices'
 AND column_name IN ('siz_cd','opt_cd','bdl_qty','siz_width','siz_height','min_qty');
-- bdl_qty|min_qty|opt_cd|siz_cd|siz_height|siz_width  (전부 실재)
```

- **AC-1 = PRODUCT_PRICE(차원 없는 단일가)**: `t_prd_product_prices` = `prd_cd·apply_ymd(PK)·unit_price·note` — **차원 컬럼 없음**(라이브 information_schema 확인). 볼체인 단일가(8색 동가 1000)에 정확히 맞고 면적/제본 comp가 **구조적으로 침입 불가**. 명함식 통합 comp 공식 부결(과설계)이 무손실 표현 근거. ✓
- **AC-2 = COMP_ACC_* 1배선**: variant축(siz_cd/opt_cd/bdl_qty)을 판별차원으로 둔 단가형 comp 1개. **가격축 = variant 식별축뿐**(siz_width/siz_height 미사용 → 면적매트릭스 아님·이산 룩업). comp 1배선·addtn_yn=N → silent 이중합산 구조적 불가. ✓
- **bdl_qty는 식별차원이지 ÷ 분모 아님[HARD]**: bdl_qty는 NON_QTY_DIMS(:38-39) 정확매칭축이지 .02 합가형 tier_min_qty(:181) 분모가 아님. 트래싱지 20/40/100장은 단가행 룩업 판별차원(어느 묶음팩이냐). ✓
- **본체 색상/소재 ≠ 가격축[HARD]**: 볼체인 8색 MAT_TYPE.10(MAT_000202~209) 오염은 생산 BOM·색상 동가 → 가격 비기여. 자재축 정리는 dbmap 위임(가격엔진 스코프 밖). ✓
- **완제품/반제품 구분 정확**: 전 18상품 완제품(AC-1 단일 / AC-2 variant)·세트 0(라이브 sets 0행·E5)·봉투-엽서 결합은 세트가 아니라 addon. 의미축 이중 인코딩 없음. ✓

---

## E3 — 경쟁사 흡수 타당성 (답습 아닌 흡수·naming 유입·자재오염 위임) · **PASS**

- **신규 가격축 0**: C-AC1~7 전부 후니 기존 그릇(product_prices.unit_price·component_prices siz_cd/opt_cd/bdl_qty 차원·addons/template·materials)에 매핑. 신규 테이블/가격축 0건(라이브 PRF_ACC_*/COMP_ACC_* 0행 입증·아래 E4). rpmeta 17축 재포화·WowPress 6축 흡수 규칙·7종단 누적 결론과 정합. ✓
- **naming 유입 0**: `tmpl_price`/`jobcost`/`papername`/`papergroup`/`ordqty`/`DIR_MTR`/`PCS_DTL_NME` 등 후니 유입 없음. 후니 `frm_cd`/`comp_cd`/`unit_price`/`siz_cd`/`opt_cd`/`bdl_qty` 컨벤션만 사용. ✓
- **굿즈 GP 동형 전파 = 메커니즘 흡수**: AC-1=GP-1(PRODUCT_PRICE 단일가)·AC-2=GP-2(variant-매트릭스 formula)·LINEN_FINISH opt_cd 그릇 재사용. 엔진 분기 신설 아님(frm_typ 미참조·경로 차이일 뿐)=답습 아닌 흡수. 추가 1요소(addon TEMPLATE_PRICE)는 부자재 고유. ✓
- **자재오염 dbmap 위임 = 스코프분리 적절**: 색상/형상/용량(C-AC4/5)은 가격축 아님(AC-1 동가·AC-2는 opt_cd variant) → dbm-axis-staged-load ④자재 위임. 이중 작업 회피. ✓

---

## E4 — 엔진 설계 건전성 (evaluate_price 계약·NON_QTY_DIMS·.01·선점 가드·search-before-mint) · **PASS**

**pricing.py 코드 직접 검증:**

| 계약 | 코드 라인 | 설계 인용 | 검증 |
|------|-----------|-----------|------|
| 소스 우선순위 TEMPLATE→PRODUCT_PRICE→FORMULA | :285-326 | 정확 | ✓ tmpl_cd 타깃 TEMPLATE_PRICE(:296-297)→없으면 fallback base_prd_cd(:299-301)→PRODUCT_PRICE(:312-317)→FORMULA(:319-327) |
| **★G-AC-3 addon TEMPLATE_PRICE 선점** | :285-297 | 정확 | ✓ tmpl_cd 타깃이면 template 단가가 PRODUCT_PRICE보다 먼저. 봉투 독립판매(prd_cd)와 addon(tmpl_cd)이 다른 테이블·경로 분기 → 충돌 없음 |
| **★G-AC-3/GP-2 PRODUCT_PRICE 선점 가드** | :311-326 | 정확 | ✓ product_prices 행이 1건이라도 있으면 cur_pp 채택(:315-317)·else에서만 FORMULA(:318-327). AC-2에 product_prices INSERT하면 FORMULA가 통째 우회되어 variant 단가 영영 안 먹힘(경고 0·silent) → 설계 "AC-2 product_prices INSERT 금지·formula 바인딩만" 정확 |
| frm_typ 미참조(C7) | frm_typ_cd 컬럼 부재·:8 | 정확 | ✓ |
| **★G-AC-2 단가형(.01) unit×qty·÷min_qty 미발생** | :177-192 | 정확 | ✓ `PRC_TYPE_UNIT` 기본 `up*q`(:191-192)·`.02`만 `up/base*q`(:185-190)·base≤0 시 ValueError(:188). 묶음수를 .01 단가형으로 두면 ÷ 위험 0 |
| siz_cd·opt_cd·**bdl_qty** 모두 NON_QTY_DIMS 정확매칭 | :38-39 | 정확 | ✓ `NON_QTY_DIMS=("siz_cd",…,"opt_cd","coat_side_cnt","bdl_qty")` — variant 1행 정확매칭(ERR_AMBIGUOUS 회피·:54) |
| **G-AC-1 평탄화 가드(NULL=와일드카드)** | :16-18·_row_matches | 정확 | ✓ 차원 컬럼 NULL=무관 → variant축을 NULL로 비우면 와일드카드화 위험 → "절대 NULL/와일드카드로 비우지 않음" 정확 |
| 수량구간할인 연결 prd_cd→dsc_tbl | :356-360·:215-226 | 정확 | ✓ 부자재 바인딩 0행 → `_quantity_discount` no-op(정상)·발명 금지 |
| addon fallback(template 0 → base prd) | :299-301 | 정확 | ✓ template_prices 0행 시 base_prd_cd로 회귀·base도 0이면 0원 → 양 경로 단가 적재가 0원 회피 핵심 |

**search-before-mint 라이브 입증:**
```sql
SELECT count(*) FROM t_prc_price_formulas WHERE frm_cd LIKE 'PRF_ACC%';   -- 0
SELECT count(*) FROM t_prc_price_components WHERE comp_cd LIKE 'COMP_ACC%'; -- 0
SELECT count(*) FROM information_schema.columns
 WHERE table_name='t_prd_product_option_items' AND column_name='add_price'; -- 0
SELECT comp_cd,comp_typ_cd,prc_typ_cd,use_dims FROM t_prc_price_components
 WHERE comp_cd='COMP_POSTEROPT_LINEN_FINISH';
-- COMP_POSTEROPT_LINEN_FINISH|PRC_COMPONENT_TYPE.06|PRICE_TYPE.01|["opt_cd","min_qty"]  (선례 실재)
```
- **신규 mint = 공식 3 + comp 3 뿐**(PRF_ACC_SIZED/BUNDLE/VARIANT·COMP_ACC_SIZED/BUNDLE/VARIANT). 라이브 PRF_ACC_*/COMP_ACC_* 0행 → 전부 신규 INSERT 대상(중복 mint 0). ✓
- **신규 테이블/가격축 0**: component_prices siz_cd/opt_cd/bdl_qty 컬럼·LINEN_FINISH opt_cd 그릇 실재 → variant-매트릭스 무손실 표현. ✓
- **(c) option_items add_price 부결 정당**: add_price 컬럼 라이브 부재(0) → AC-2 variant 단가 option_items에 못 담음 → (b)formula 채택 정합. ✓

---

## E5 — 세트/이중역할 SKU 정합 (이중계상·addon 경로) · **PASS**

**재현 SQL:**
```sql
SELECT count(*) FROM t_prd_product_sets
 WHERE sub_prd_cd ~ '^PRD_0000(0[1-9]|1[0-5])$' OR sub_prd_cd IN ('PRD_000281','PRD_000282','PRD_000283');  -- 0
SELECT prd_cd,tmpl_cd FROM t_prd_product_addons WHERE prd_cd='PRD_000016';  -- 5행
SELECT tmpl_cd,tmpl_nm,base_prd_cd FROM t_prd_templates WHERE tmpl_cd IN (...);  -- 5행
```

- **세트 레이어 불요**: t_prd_product_sets에 악세사리 sub_prd_cd 0행 라이브 확정. 각 부자재 = 단일 완제품(매입/외주). ✓
- **이중역할 SKU 경로 분기 정확**: 봉투 addon 5행 실재(PRD_000016 엽서 → TMPL-000005/006/009/010/011). template base_prd_cd 매핑 정확(TMPL-000005→PRD_000001 OPP접착·009→PRD_000283 트레싱지·010→PRD_000281 화이트·011→PRD_000282 블랙). 독립판매=PRODUCT_PRICE(prd_cd)·addon=TEMPLATE_PRICE(tmpl_cd) → **다른 테이블·우선순위 분기로 가격 충돌 없음**(F-PA-1 라이브 확인). ✓
- **엽서 본체 PRD_000016 = PRD_TYPE.01(프리미엄엽서)** 라이브 확인 — addon base 정합. ✓
- **required vs optional addon**: 봉투 addon은 optional(엽서 손님 선택)·미선택 시 본체에 silent 합산 안 됨 → 책자 DV-BK4 저청구 가드 동형 준수. ✓

---

## E6 — 골든 재현 (설계 공식으로 실제 재계산·허용오차 0) · **PASS**

`recompute-log-accessory.md` 상세. pricing.py 산식 충실 재구현(round_won·component_subtotal):

| 골든군 | 결과 | 핵심 입증 |
|--------|------|-----------|
| AC-1 단일고정가 GC-AC1~4 | **4/4 일치** | PRODUCT_PRICE unit×qty·구간할인 no-op(볼체인50=50,000 정가·할인 없음)·색상 동가 |
| AC-2 변형고정가 GC-AC5~12 | **8/8 일치** | FORMULA variant 정확매칭(70x200=1100·230x350=3250·20장6000·100장28000)·우드행거440 ×2=40,000·투명케이스 ×10=35,000 |
| addon 봉투 GC-AC13~14 | **2/2 일치** | TEMPLATE_PRICE unit×qty(110x160=1200×100=120,000·트레싱지6000×50=300,000)·단가 CSV verbatim |
| addon GC-AC15 | **BLOCKED(구조검증만·정직)** | TMPL-000010 라벨 "50장" vs 시트 카드봉투 "10장 1000"·50장 묶음 단가 시트 부재 → 추측 적재 금지·Q-AC-TMPL 컨펌큐 |

**돈크리티컬 양면 독립 재현:**
- G-AC-1 평탄화: OPP 230x350 정답 3,250 vs 평탄화 1,100(66% 과소)·트래싱지 100장 정답 28,000 vs 평탄화 6,000(78.6% 과소). variant 판별차원 충전 필수 입증.
- G-AC-2 .02 붕괴: OPP 70x200 (50장) .01 정답 1,100 vs .02(min_qty=50) 붕괴 22(98% 손실). prc_typ=.01 강제 필수 입증.

- **단가값 출처[HARD]**: GC-AC1~14 단가 전부 상품마스터 I열 verbatim(CSV 셀 단위 재대조·designer 창작 0). GC-AC15 묶음수 불일치 정직 보류. ✓ 허용오차 0.

---

## E7 — 생성-검증 독립성 (self-approve·dodge-hunt) · **PASS**

- **핵심 명제 라이브 독립 재실측(designer 주장 비신뢰)**:
  - AC 분류 18상품 정체·prd_typ_cd·use_yn 직접 SELECT(round-13 ".05" 거짓 정정 확인)
  - inline 단가 67 variant행 CSV verbatim 재대조
  - variant 그릇 선례 LINEN_FINISH 라이브 실재 확인(use_dims/prc_typ/comp_typ)
  - 이중역할 addon 5행·template 5행·base_prd_cd 매핑 라이브 확인
  - **★OTC 사실무근 독립 검증**: 거울/키링/뱃지(PRD_000146/148/183~187/201~227)는 전부 PRD_000016 이후 코드(아크릴 PRD_TYPE.04·굿즈 PRD_TYPE.03)이지 악세사리 시트(PRD_000001~015·281~283) 아님. 악세사리 CSV 67행에도 거울/키링 0건 → designer "OTC 이중등록 사실무근·시트 혼동 정정" **정확**.
- **dodge-hunt**: 평탄화 가드(G-AC-1)·.02 붕괴 가드(G-AC-2)·PRODUCT_PRICE 선점 가드(GP-2)·addon 묶음수 불일치 BLOCKED(GC-AC15) 전부 명시·미확정을 GO로 가린 흔적 없음. 카드봉투 묶음수 불일치를 추측 적재 회피로 정직 BLOCKED 처리 = 정당.
- **self-approve 없음**: 골든 충실 재구현·돈크리티컬 양면 자체 재계산·라이브 SQL 재현 첨부. ✓

---

## 보정/컨펌큐 라우팅

**차단 결함 0·보정 요구 0.** 아래는 designer가 이미 명시한 컨펌큐(인간/designer·실 적재 선결·차단 아님):

| 항목 | 라우팅 | 비고 |
|------|--------|------|
| Q-AC-TMPL 카드봉투 묶음수 불일치(template 50장 vs 시트 10장) | **인간 승인**(addon 봉투 실제 묶음 단가 권위 필요) | GC-AC15 BLOCKED 정당·추측 적재 금지 |
| Q-AC-OPT CPQ option_items 주입(AC-2 variant 룩업 선결) | dbm-option-mapper(round-6) | 미연결 시 디폴트 variant 필요(0원 침묵 회피) |
| Q-AC-CEIL 천정고리(008·use_yn=N) 가격 제외 | 인간(판매재개 시 적재) | 라이브 use_yn=N 확인 |
| 색상/형상 자재 오염 정리(볼체인 MAT_TYPE.10 등) | dbm-axis-staged-load ④자재 | 가격엔진 스코프 밖·가격 무관 |
| LOW 정정: §5 와이어링/행택끈 자재 "0행" stale 주장 | 문서 정밀화(가격 무관) | 결론 불변 |

**실 적용(AC-1 product_prices INSERT·AC-2 공식3/comp3/단가행/바인딩·addon template_prices)은 DB 미적재·인간 승인 후 dbmap 위임**(dbm-load-execution·dbm-price-arbiter·dbm-axis-staged-load).

---

## 산출
- `gate-verdict-accessory.md`(본 문서)
- `recompute-log-accessory.md`(골든 재계산 단계·권위 대조)
