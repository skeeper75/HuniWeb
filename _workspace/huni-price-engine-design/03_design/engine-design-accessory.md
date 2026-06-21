# engine-design-accessory.md — 상품악세사리 inline 고정가형(AC-1/AC-2) + 이중역할 SKU(addon) 가격엔진 설계

> **핵심 설계가(hpe-engine-designer) 산출 — 상품악세사리 종단(7번째·디지털[원자합산+고정가]·아크릴[면적]·실사현수막[면적+거치]·문구[고정가+매트릭스]·책자[부품합산세트]·굿즈/파우치[고정가형] 다음).**
> cartographer 지도(`formula-map-accessory.md`·`component-inventory-accessory.md`·`gap-board-accessory.md`)+benchmark 흡수(`competitor-pricing-models-accessory.md`·`absorption-candidates-accessory.md` C-AC1~7·`set-pricing-patterns-accessory.md` A-1~A-4)를 종합해,
> 상품악세사리 **AC-1 단일고정가(3) + AC-2 변형고정가(11) + 이중역할 SKU 봉투 addon(5행)** 완제품의 가격공식+가격구성요소+t_prc_*/t_prd_* 단가 그릇+바인딩을
> 라이브 `evaluate_price` 단일 권위 알고리즘이 그대로 먹는 형태로 설계한다. **새 엔진 코드 아님 — 데이터 그릇/바인딩/링크 설계.**
>
> 권위[HARD]: ① 상품마스터(260610) 상품악세사리(가격포함) 시트 inline 가격(I열·67 variant행 verbatim) > ② 인쇄상품 가격표(260527)[해당 블록 없음] > ③ 라이브 t_prc_*/t_prd_*(기준선) > ④ 역공학(후보·naming 유입 금지).
> 산출자: hpe-engine-designer · 라이브 읽기전용 SELECT 실측 2026-06-22 · 단가값=권위 verbatim(날조 0) · **DB 미적재**(실 적용 인간 승인 후 dbmap 위임·webadmin 코드 직접수정 금지).
> 굿즈/파우치 GO 설계(GP-1/GP-2·G-GP-1 variant-매트릭스·G-GP-3 평탄화·GP-2 PRODUCT_PRICE 선점 가드)와 동일 컨벤션·동일 engine-contract(pricing.py).
> **★이번 스코프: 상품악세사리 시트 14 distinct 상품(67 variant행·라이브 PRD_000001~015 활성 14[008 use_yn=N]) + 이중역할 봉투 별 PRD 3(281/282/283) + 봉투 addon 5행(엽서 PRD_000016).**

---

## 0. 설계 요약 — 라이브 baseline 대비 무엇을 하나 (6종단 통틀어 가격사슬 절대 최저 = 전무)

라이브 실측(2026-06-22 읽기전용 SELECT)이 cartographer 지도를 **전부 확인**했다. 상품악세사리는 계산방식이 **inline 고정가형 단일 유형**(면적/원자합산/매트릭스/세트/수량구간할인 전부 0)으로 굿즈와 동형이나, 라이브 가격사슬은 **양 경로(PRODUCT_PRICE·TEMPLATE_PRICE) 단가 모두 0행**으로 6종단 통틀어 완성도 최저다.

| 라이브 실측 (2026-06-22·읽기전용 SELECT) | 값 | 설계 함의 |
|----------------------------------|----|-----------|
| **t_prd_product_prices** (18상품) | **0행** | AC-1 본체 고정가 그릇=이 테이블(차원 없는 단일가). 전무 → INSERT 대상 |
| **t_prd_product_price_formulas 바인딩** | **0행** | AC-2 변형단가 공식 바인딩 전무(굿즈 G-GP-1 동형·더 깊음) |
| **t_prd_template_prices** (봉투 addon) | **0행** | 봉투 template 5(엽서) 존재하나 단가 0 → addon 봉투 0원 |
| **t_prc_price_formulas / price_components / component_prices** (악세사리 전용) | **0/0/0** | AC-2 그릇 신규 설계 대상 |
| **t_prd_product_addons** | **5행**(PRD_000016→TMPL-000005/006/009/010/011) | 봉투 addon 배선 실재(엽서 본체에 봉투 선택)·단가만 0 |
| **수량구간할인 바인딩(t_prd_product_discount_tables)** | **0행**(부자재 미해당) | 🟢 정당 부재(굿즈 DSC 4타입과 결정적 차이 — 부자재엔 구간할인 없음) |
| **prd_typ_cd** (18상품 전수) | **PRD_TYPE.03(기성품)** | round-13 "281/282/283=PRD_TYPE.05" 거짓·라이브 권위 우선(F-PA-1 정정 확인) |
| **천정고리(PRD_000008)** | **use_yn=N**(판매중지) | 가격 적재 대상에서 제외·컨펌큐 Q-AC-CEIL |
| **GP-2 variant-매트릭스 그릇 선례** | `COMP_POSTEROPT_LINEN_FINISH` use_dims=`["opt_cd","min_qty"]`·PRICE_TYPE.01 실재 | ★AC-2 그릇 선례 라이브 실재(dbmap round-23 린넨 COMMIT) — search-before-mint 강하게 충족(굿즈와 동일) |
| **t_prc_component_prices 차원 컬럼** | `siz_cd·opt_cd·bdl_qty·min_qty…` 실재(information_schema) | AC-2 variant축(siz_cd/opt_cd/bdl_qty)·신규 가격축 0 |

**∴ 상품악세사리 설계의 핵심 5가지:**
1. **AC-1 단일고정가 3상품(볼체인·와이어링·리필잉크) = 굿즈 GP-1·문구 DT-1 완전 동형** — `t_prd_product_prices.unit_price × qty`(공식·comp 없이 작동·PRODUCT_PRICE 경로). 색상은 식별축이지 가격축 아님(전 variant 동가) → product_prices 1행이 무손실 표현. 명함식 통합 comp 공식 **부결**(과설계).
2. **★AC-2 변형고정가 11상품 = G-AC-1 그릇 결정(굿즈 G-GP-1 동형)** — variant별 자기 고정가(OPP 11규격·트래싱지 8 규격×묶음·우드 3길이·카드 2색·투명 3D)를 PRODUCT_PRICE(unit_price 1개)·option_items(add_price 없음) 어디에도 못 담음. **(b)variant-매트릭스 formula 채택**(굿즈 GP-2 동형·LINEN_FINISH opt_cd 그릇 선례 재사용·엔진 변경 0·신규 테이블/축 0).
3. **★G-AC-2 묶음 .01 팩단가 가드(돈크리티컬)** — "(50장)"·"(20장)" 묶음수는 ÷min_qty(합가형 .02) 대상 **절대 아님**. inline 가격=1팩 단가(.01·단가형). 합가형 오적용 시 1100원 봉투가 22원/장 × 주문수로 환산되어 가격 붕괴(봉투제작 PRD_000050 MATRIX 합가형과 정반대). prc_typ=`.01` 강제.
4. **★G-AC-3 addon TEMPLATE_PRICE 선점 + 양 경로 단가 전무(돈크리티컬·부자재 고유·굿즈엔 없음)** — 봉투(001/002/281/282/283)가 엽서(PRD_000016) addon으로 붙음(addon 5행·template 5행 실재). 엔진 우선순위 TEMPLATE_PRICE→PRODUCT_PRICE(pricing.py:296→316)라 tmpl_cd 타깃이면 template 단가가 우선. template_prices 0행이면 "기준 상품 가격으로 계산"(:300 fallback)→product_prices도 0이면 0원. **양 경로 단가 일관 적재** + GP-2 PRODUCT_PRICE 선점 가드 재적용.
5. **G-AC-1 평탄화 가드(돈크리티컬·굿즈 G-GP-3 동형)** — AC-2를 단일 unit_price로 평탄 적재 시 OPP 230x350 주문에 70x200 가격(1100), 트래싱지 100장 주문에 20장 가격(28000 대신 6000) 과소청구. variant축(siz_cd/opt_cd/bdl_qty)을 use_dims 판별차원으로 충전(평탄화 절대 금지).

★ **6종단 동형 클래스 판정[HARD]**: AC-1 = **굿즈 GP-1·문구 본체(A) 고정가형 완전 동형**(고정가×수량·PRODUCT_PRICE·단 **수량구간할인 없음** — 부자재 미해당이 굿즈와 결정적 차이). AC-2 = **굿즈 GP-2 완전 동형**(variant별 고정가). 추가 1요소 = **이중역할 SKU addon(TEMPLATE_PRICE)** — 굿즈엔 없는 부자재 고유. 신규 테이블/가격축 = **0건**(benchmark C-AC1~7 전부 후니 그릇 보유·rpmeta 17축 재포화·WowPress 6축 흡수 규칙 정합). **세트조합 레이어 불요**(t_prd_product_sets sub_prd_cd 0행·봉투-엽서 결합은 세트가 아니라 addon).

---

## 1. 계산방식 — inline 고정가형 (frm_typ 미참조·계산방식은 가격소스 경로 차이일 뿐)

calc-formula-draft-l1.csv에 **상품악세사리 전용 공식 row 부재** → 상품마스터 상품악세사리(가격포함) 시트 inline 가격(I열)이 가격 권위. 부자재는 인쇄 BOM(자재/공정/도수/판형)이 없는 완제 부속이라 공식 합산이 아니라 **variant당 고정 단가표**다.

| 서브클래스 | 정의 | 상품 수 | 엔진 처리(engine-contract·pricing.py) | 가격소스 경로 |
|-----------|------|:--:|---------------------------------------|--------------|
| **AC-1 단일고정가** | 판매가 = [상품 고정단가] × 수량 (구간할인 없음) | **3** (볼체인·와이어링·리필잉크) | `t_prd_product_prices.unit_price × qty`(:315-317·공식/comp 없이 작동) | **PRODUCT_PRICE** |
| **AC-2 변형고정가** | 판매가 = [variant별 고정단가] × 수량 | **11** | comp 1개 variant 차원(siz_cd/opt_cd/bdl_qty) 룩업 단가형 unit×qty(:320-326·:191) | **FORMULA** |
| **(적용경로) addon 봉투** | 봉투가 본체 상품(엽서) addon으로 붙음(tmpl_cd 타깃) | 5행(엽서 PRD_000016) | `t_prd_template_prices.unit_price × qty`(:296-297) | **TEMPLATE_PRICE** |

★ **핵심[HARD]**: 엔진은 `frm_typ_cd`를 참조하지 않는다(engine-contract C7·pricing.py:8 "공식유형 frm_typ 폐기→공식은 항상 구성요소 합산"). "AC-1/AC-2"는 별 엔진 분기가 아니라 **가격소스 경로(PRODUCT_PRICE vs FORMULA)의 차이**일 뿐(굿즈 §1·디지털·아크릴·문구 설계 §1과 동형).

★ **세 경로의 결정적 차이**:
- AC-1은 공식·comp **불요**(product_prices가 곧 단가·단일가 무손실).
- AC-2는 공식·comp **필요**(variant별 단가 룩업).
- addon은 **다른 테이블(template_prices)·다른 우선순위**(엔진이 tmpl_cd 타깃이면 TEMPLATE_PRICE를 PRODUCT_PRICE보다 먼저 봄) → 독립판매 단가와 충돌 없음(경로 분기·F-PA-1).

---

## 2. ★(AC-1) 단일고정가 3상품 — PRODUCT_PRICE 경로 (굿즈 GP-1·문구 DT-1 동형·구간할인 없음)

### 2-1. 가격 소스 결정 = t_prd_product_prices 직접 고정가 (통합 comp 공식 부결)

라이브 pricing.py 가격소스 우선순위(:296-326): ① TEMPLATE_PRICE → **② PRODUCT_PRICE(`t_prd_product_prices`)** → ③ FORMULA. AC-1 부자재는 **상품마스터 `가격`(I열) 단일 inline 고정가**(볼체인 8색 전부 1000·와이어링 3색 전부 500·리필잉크 7색 전부 2500 = variant 무관 동가·distinct 가격=1)이므로 **② PRODUCT_PRICE 경로가 정답 그릇**이다.

- **t_prd_product_prices** 구조(라이브 실측): `prd_cd·apply_ymd`(PK)·`unit_price`·`note`. **차원 컬럼 없음** → 상품당 적용일별 단가 1건. AC-1처럼 색상으로 단가가 안 갈리는 단일 고정가에 정확히 맞음.
- 엔진 처리(:315-317): `base_amount = unit_price × qty`. **그 후 수량구간할인 없음**(부자재 미바인딩·`_quantity_discount`는 t_prd_product_discount_tables 링크 없으면 no-op·:482-483 → 정가 그대로).

★ **search-before-mint 결론[HARD]**: AC-1에 "고정가형 공식+완제품 통합단가 comp" 패턴(명함식)을 **적용하지 않는다**(굿즈 GP-1·문구 DT-1 동형 부결). 근거:
- AC-1은 **단일 고정가**(볼체인 1000 단 1가·색상 variant 동가·distinct 가격=1) → comp+공식 그릇은 **과설계**. product_prices 1행이 무손실 표현.
- AC-1엔 소재·사이즈·세트 단가 분기가 없음(색상은 동가) → 명함 통합 comp 매트릭스 불필요.
- ∴ AC-1 = product_prices 직접가. 명함식 공식 신설 **부결**.

### 2-2. AC-1 단일고정가 그릇 명세 (t_prd_product_prices INSERT·상품마스터 I열 verbatim)

AC-1 3상품을 `t_prd_product_prices`에 unit_price 1행 INSERT한다. 단가값 = **상품마스터 260610 상품악세사리(가격포함) 시트 `가격`(I열) inline verbatim**(L1 67행 실측).

| prd_cd | 상품(라이브 prd_nm) | unit_price(I열 verbatim) | apply_ymd | variant축(가격무영향) | 비고 |
|--------|---------------------|--------------------------|-----------|----------------------|------|
| PRD_000006 | 볼체인 | **1,000** | 2026-06-01 | 색상 8종(동가·식별축) | (3개1팩) — 1팩당 단가·구간할인 없음 |
| PRD_000007 | 와이어링 | **500** | 2026-06-01 | 색상 3종(동가·식별축) | 단일·구간할인 없음 |
| PRD_000015 | 만년스탬프 리필잉크 | **2,500** | 2026-06-01 | 색상 7종(동가·식별축) | (5cc) — 1병당 단가·구간할인 없음 |

- **단가값 출처[HARD]**: 상품마스터 I열 inline verbatim(L1 row 36~68 실측·designer 창작 0). 적재 시 검증가 E1 재대조.
- **apply_ymd**: [[dbmap-live-load-transition-260615]] 적용일 시계열 구조 준수(2026-06-01 유지 UPSERT·신 단가행 분기 금지). 굿즈 GP-1과 동일.
- **단가 단위 명시(C-AC2·G-AC-2)**: 볼체인 1000=3개1팩 1팩당·리필잉크 2500=5cc 1병당·와이어링 500=1개당. `note`에 "3개1팩당"·"5cc 1병당" 명시 → ×수량(팩수/병수) 정당성. **÷ 환산 금지.**

### 2-3. AC-1 바인딩·소스 유효성 가드 (U-7 binding-validity 계승)

- **PRODUCT_PRICE 경로는 product_price_formulas 바인딩 불요**(공식 안 씀). AC-1 3상품 = product_prices 1행씩이면 가격계산 성립.
- **시트 차원경계(SOT 1)**: AC-1 product_prices에 디지털/제본/면적 comp 침입 없음(차원 없는 단일가라 구조적으로 불가). ✅
- **색상 = 자재 오염은 가격축 아님[HARD]**: 볼체인 8색·리필잉크 7색이 t_mat_materials MAT_TYPE.10 오염(G-AC-5)이나 **색상은 동가 → 가격 비기여**. 색상 자재 정리는 **dbmap 자재축 트랙 위임**(가격엔진은 inline 고정가 verbatim만·[[dbmap-material-option-normalization]]).
- **구간할인 없음 가드[HARD]**: AC-1에 굿즈 DSC_GOODSA/B·FABRIC·SQUISHY 같은 수량구간할인 **링크를 만들지 말 것**. 부자재는 구간할인 미해당(라이브 0행 정당·발명 금지). product_prices 적재 후 `_quantity_discount` no-op이 정상.

---

## 3. ★(AC-2) 변형고정가 11상품 — 그릇 결정 [G-AC-1·최대 설계난제·굿즈 G-GP-1 동형] + 평탄화 가드 [돈크리티컬]

### 3-1. G-AC-1 그릇 결정 — (b)variant-매트릭스 formula 채택 (search-before-mint 결판·굿즈 GP-2 전파)

| 선택지 | 설명 | search-before-mint 판정 |
|--------|------|------------------------|
| (a) variant마다 별 prd_cd | OPP 11규격 = 11 prd_cd·각 PRODUCT_PRICE 1행 | ❌ 상품 폭증(14상품→~50 prd_cd)·옵션 UX 분리·round-10 size→option 의도 역행 |
| **(b) variant-매트릭스 formula** | PRF_ACC_* 등·comp 1개·use_dims=[siz_cd]/[opt_cd]/[bdl_qty]·variant당 단가행 1행 | **✅ 채택** — 굿즈 GP-2 동형·**라이브 `COMP_POSTEROPT_LINEN_FINISH` use_dims=["opt_cd","min_qty"] 선례 실재**(dbmap round-23 린넨 COMMIT)·아크릴 면적매트릭스 1축 축소판·엔진 변경 0·기존 component_prices 그릇 재사용 |
| (c) option_items add_price 신규 컬럼 | base + 옵션 add | ❌ DDL 필요(dbm-ddl-proposer)·라이브 add_price 컬럼 부재(information_schema 실측·굿즈 검증분)·과설계 |

★ **결판 근거(라이브 실측 2026-06-22)[HARD]**: AC-2 변형단가는 **신규 가격축이 아니다.** `t_prc_component_prices`는 이미 `siz_cd·opt_cd·bdl_qty` 차원 컬럼을 보유하고, `t_prc_price_components`는 `use_dims`로 그 차원을 판별차원으로 등재할 수 있다(굿즈 GP-2 결판과 동일·LINEN_FINISH 실작동 그릇). **무손실 표현 가능 = vessel-gap 해소(신규 mint = 공식+comp 그릇 뿐·신규 테이블/축 0)**.

### 3-2. AC-2 공식·구성요소 그릇 명세 (variant축 = siz_cd / opt_cd / bdl_qty 판별)

AC-2 11상품은 variant축 의미에 따라 그릇이 갈린다(전부 동일 엔진·comp 1개 단가형·variant 판별차원). **3 공식·3 comp로 충분**(상품별 공식 폭발 금지·맛간장 철학·[[dbmap-print-domain-recipe-philosophy]]).

| variant축 의미 | 상품 | 공식(신설) | 구성요소(신설) | use_dims | 단가행 차원 |
|---------------|------|-----------|----------------|----------|-------------|
| **규격(siz)** | OPP접착봉투(001)·OPP비접착봉투(002)·캘린더봉투(005)·투명케이스(009·3D규격)·우드봉(013·길이)·우드행거(014·길이)·자석고무판(011·단일)·우드거치대(012·단일) | `PRF_ACC_SIZED` | `COMP_ACC_SIZED` | `["siz_cd"]` | siz_cd별 1행 |
| **규격×묶음수(siz+bdl)** | 트래싱지 카드봉투(003·★같은 규격 다른 묶음=다른 가격) | `PRF_ACC_BUNDLE` | `COMP_ACC_BUNDLE` | `["siz_cd","bdl_qty"]` | (siz_cd × bdl_qty)별 1행 |
| **색상/종류(opt)** | 카드봉투(004·화이트1000/블랙1500)·행택끈(010·종류 3종) | `PRF_ACC_VARIANT` | `COMP_ACC_VARIANT` | `["opt_cd"]` | opt_cd별 1행 |

★ **단일행 상품(자석고무판011·우드거치대012)도 PRF_ACC_SIZED로 통일**(variant 1개여도 siz_cd 1행·평탄화 함정 없으나 그릇 일관성). 향후 규격 추가 시 무손실 확장.

**구성요소 정의(t_prc_price_components 신설·굿즈/아크릴 컨벤션):**

| comp_cd | comp_nm(한글 표준) | comp_typ_cd | prc_typ_cd | use_dims | 비고 |
|---------|-------------------|-------------|------------|----------|------|
| **COMP_ACC_SIZED** | 악세사리 규격변형 완제품가 | `PRC_COMPONENT_TYPE.06`(완제품) | **`PRICE_TYPE.01`(단가형)** | `["siz_cd"]` | 규격(봉투/우드길이/3D케이스) variant·1팩/1점당가 |
| **COMP_ACC_BUNDLE** | 악세사리 규격묶음변형 완제품가 | `PRC_COMPONENT_TYPE.06`(완제품) | **`PRICE_TYPE.01`(단가형)** | `["siz_cd","bdl_qty"]` | 규격×묶음수(트래싱지) variant·1팩당가 |
| **COMP_ACC_VARIANT** | 악세사리 색상/종류변형 완제품가 | `PRC_COMPONENT_TYPE.06`(완제품) | **`PRICE_TYPE.01`(단가형)** | `["opt_cd"]` | 색상/종류(카드봉투·행택끈) variant·1팩당가 |

★ **prc_typ_cd = `.01` 단가형 채택[HARD·돈크리티컬·G-AC-2]**: AC-2 변형단가는 **1팩(또는 1점)당 완제품가**(OPP 70x200 1100=50장 1팩당). 단가형(`.01`)이면 `component_subtotal`(:177-183) = `unit_price × qty`(÷min_qty 미발생) → **묶음수 ÷ 환산 위험 0·min_qty 자유**. **합가형(`.02`) 절대 금지** — .02면 `unit_price ÷ min_qty × qty`(:181)로 1팩 가격이 장당가로 환산되어 묶음수 다른 variant 가격 전손(봉투제작 PRD_000050 MATRIX와 정반대). §3-4 min_qty=1 명시(아크릴 CLEAR3T .02+NULL ValueError 선례 회피).

**공식 정의(t_prc_price_formulas 신설) + 배선(t_prc_formula_components):**

| frm_cd | 배선 comp | disp_seq | addtn_yn | 비고 |
|--------|-----------|----------|----------|------|
| **PRF_ACC_SIZED** | COMP_ACC_SIZED | 1 | N | 본체 단독(아크릴 PRF_CLR_ACRYL·굿즈 PRF_GOODS_SIZED 동형·comp 1배선) |
| **PRF_ACC_BUNDLE** | COMP_ACC_BUNDLE | 1 | N | 본체 단독 |
| **PRF_ACC_VARIANT** | COMP_ACC_VARIANT | 1 | N | 본체 단독 |

★ **comp 1배선·addtn_yn=N → silent 이중합산 구조적 불가**(공식당 comp 1개·변형단가 1행 룩업). 디지털 인쇄면 S1+S2 합산 위험 부재.

### 3-3. ★G-AC-1 평탄화 오청구 가드 [HARD·돈크리티컬·굿즈 G-GP-3 동형]

AC-2를 AC-1처럼 `t_prd_product_prices` unit_price 1개로 평탄 적재하면 **OPP 11규격이 한 값** → 230x350 주문에 70x200 가격(1100·정답 3250) 과소청구. 트래싱지 100장 주문에 20장 가격(6000·정답 28000) **78% 과소청구**.

- **방지 메커니즘[HARD]**: variant 각 행을 **comp 단가행(component_prices) 1행씩 + use_dims 판별차원(siz_cd/opt_cd/bdl_qty)으로 충전**. 손님이 230x350(siz_cd) 선택하면 엔진 NON_QTY_DIMS 정확매칭(:38-39)이 그 단가행 1행만 후보로 골라 3250 룩업. variant축을 **절대 NULL/와일드카드로 비우지 않음**.
- **단가행 verbatim INSERT**: OPP접착봉투 70x200=1100…230x350=3250(11행)·트래싱지 160x110 20장6000/40장12000/100장28000·100x100 20장6800/40장13600/100장32000·70x100 30장3600/100장10000(8행)·카드봉투 화이트1000/블랙1500·우드봉 270mm7000/360mm9800/480mm12000·우드행거 230mm16000/320mm18000/440mm20000·투명케이스 42x57x20=3000/75x75x15=3000/75x110x15=3500·캘린더봉투 240x230=2500/150x310=2400·행택끈 사각검정3000/사각백색3000/사각마사4000·자석고무판1000·우드거치대4000(상품마스터 I열 행별 verbatim·L1 실측). **각 variant 행이 자기 고정가를 component_prices에 1행 보유**(평탄화 절대 금지).
- **검증 가드(E6)**: 골든에서 OPP 규격별·트래싱지 묶음별 다른 단가가 매칭되는지(GC-AC 평탄화 양면 케이스로 입증)·100장 주문에 20장 가격이 안 나오는지 재현.

### 3-4. AC-2 신규 단가행 INSERT 가드 (min_qty + variant 정확매칭)

- **COMP_ACC_* 는 `.01`(단가형)** → ÷min_qty 미발생(:181-183) → **min_qty NULL이어도 ValueError 없음**(아크릴 CLEAR3T `.02`+NULL ValueError와 다름). 단 일관성 위해 신규 행 **min_qty=1 명시**(굿즈/아크릴 동일 가드).
- **variant 정확매칭(NON_QTY_DIMS)**: siz_cd·opt_cd·bdl_qty는 NON_QTY_DIMS(:38-39) 정확매칭 → 손님 선택 variant 1행 확정·모호성 0(P3-8 ERR_AMBIGUOUS 회피).
- **★bdl_qty는 묶음수 식별(차원)이지 ÷ 분모 아님[HARD]**: 트래싱지 bdl_qty=20/40/100은 **단가행 룩업 판별차원**(어느 묶음팩이냐)이지 `component_subtotal`의 ÷min_qty 분모가 아니다(분모는 .02 합가형의 tier_min_qty·:181). bdl_qty=100 단가행 28000은 "100장 1팩당 28000"이고 ×qty(팩수)가 정당. **bdl_qty를 ÷ 환산축으로 오해 금지**(G-AC-2 함정).

### 3-5. AC-2 바인딩 명세 (product_price_formulas — search-before-mint·굿즈 동형)

AC-2 11상품을 variant축에 따라 3 공식 중 하나에 바인딩(굿즈 GP-2·아크릴 G-A1 동형·신규 공식은 위 3개만·상품마다 신규 공식 안 만듦).

| 바인딩 대표 | 공식 | apply_bgn_ymd | 근거 |
|-------------|------|---------------|------|
| PRD_000001 OPP접착봉투 → PRF_ACC_SIZED | (2026-06-01) | 규격 variant |
| PRD_000003 트래싱지카드봉투 → PRF_ACC_BUNDLE | (2026-06-01) | 규격×묶음 variant |
| PRD_000004 카드봉투 → PRF_ACC_VARIANT | (2026-06-01) | 색상 variant |
| PRD_000010 행택끈 → PRF_ACC_VARIANT | (2026-06-01) | 종류 variant |
| PRD_000013 우드봉 → PRF_ACC_SIZED | (2026-06-01) | 길이=규격 variant |

★ **신규 mint = 공식 3(PRF_ACC_SIZED·PRF_ACC_BUNDLE·PRF_ACC_VARIANT) + comp 3(COMP_ACC_SIZED·BUNDLE·VARIANT) 뿐.** 신규 테이블/가격축 0. 11상품 전체는 이 3공식에 바인딩(상품별 공식 폭발 금지). variant 단가행은 상품마다 다르나 그릇(공식·comp·use_dims)은 3개 공유.

### 3-6. ★GP-2 PRODUCT_PRICE 선점 가드 재적용 [HARD·돈크리티컬·굿즈 codex 발견]

엔진 가격소스 우선순위 `PRODUCT_PRICE → FORMULA`(pricing.py:316→324). **AC-2 11상품에 `t_prd_product_prices` 행이 1건이라도 있으면 FORMULA 경로가 통째로 우회**되어 variant 단가(공식)가 **영영 안 먹힌다**(평탄화보다 더 silent·경고 없음).

- **[적재 가드]** AC-2 11상품은 **product_prices INSERT 금지·formula 바인딩만**(AC-1 3상품만 product_prices). AC-1과 AC-2를 INSERT 트랙에서 명확히 분리(굿즈 GP-1/GP-2 가드 동형).
- 검증가 E4가 AC-2 상품의 product_prices 0행 + formula 바인딩 실재를 양면 확인.

---

## 4. ★(이중역할 SKU) 봉투 addon — TEMPLATE_PRICE 경로 [G-AC-3·돈크리티컬·부자재 고유]

### 4-1. 이중역할 구조 (독립판매 + 본체 addon·가격 권위 충돌 없음)

봉투(OPP접착001/비접착002·카드봉투 화이트281/블랙282·트레싱지283)는 두 경로로 가격이 매겨진다:

| 경로 | 타깃 | 엔진 source | 그릇 | 단가 |
|------|------|------------|------|------|
| **독립판매** | prd_cd(예 PRD_000001) | PRODUCT_PRICE(차원 AC-2) 또는 FORMULA | §3 PRF_ACC_* | I열 inline variant 단가 |
| **본체 addon** | tmpl_cd(TMPL-000005 등) | TEMPLATE_PRICE(:296-297) | `t_prd_template_prices.unit_price` | 그 템플릿 1 variant 단가 |

★ **엔진 우선순위(pricing.py:296→316)**: tmpl_cd 타깃이면 TEMPLATE_PRICE가 PRODUCT_PRICE보다 **우선**. 두 경로가 **다른 테이블**(template_prices vs product_prices)이라 **가격 권위 충돌 없음**(경로 분기·F-PA-1). 손님이 봉투를 직접 주문하면 product 단가, 엽서 옵션으로 붙이면 template 단가.

### 4-2. ★template = 단일 variant 인코딩 (라이브 실측 핵심)

라이브 봉투 template 5행은 **이미 variant가 tmpl_cd에 baked-in**:
- TMPL-000005 = "OPP접착봉투 110x160 mm 50장" · TMPL-000006 = "OPP비접착봉투 110x160 mm 50장"
- TMPL-000009 = "트레싱지봉투 160x110 mm 20장" · TMPL-000010 = "카드봉투(화이트) 165x115 mm 50장" · TMPL-000011 = "카드봉투(블랙) 165x115 mm 50장"

→ template_prices는 **차원 없는 단일 단가**(tmpl_cd+apply_ymd PK·unit_price 1·:296 unit×qty). 각 template이 1 규격/묶음을 고정하므로 AC-2 variant-매트릭스를 template 경로에 끌어올 필요 없음(template 자체가 1 variant). **addon 단가 = 그 template이 가리키는 봉투 variant의 독립 단가와 동일**(I열 verbatim).

| tmpl_cd | 봉투 variant | template_prices.unit_price(I열 verbatim) | apply_ymd | 비고 |
|---------|-------------|------------------------------------------|-----------|------|
| TMPL-000005 | OPP접착봉투 110x160mm 50장 | **1,200** | 2026-06-01 | L1 row10 110x160=1200 |
| TMPL-000006 | OPP비접착봉투 110x160mm 50장 | **1,200** | 2026-06-01 | L1 row19 110x160=1200 |
| TMPL-000009 | 트레싱지봉투 160x110mm 20장 | **6,000** | 2026-06-01 | L1 row24 160x110 20장=6000 |
| TMPL-000010 | 카드봉투(화이트) 165x115mm 50장 | (I열 verbatim·아래★) | 2026-06-01 | L1 카드봉투 화이트=1000(10장)·★묶음수 불일치 |
| TMPL-000011 | 카드봉투(블랙) 165x115mm 50장 | (I열 verbatim·아래★) | 2026-06-01 | L1 카드봉투 블랙=1500(10장)·★묶음수 불일치 |

★ **돈크리티컬 묶음수 불일치(G-AC-3 세부·컨펌큐 Q-AC-TMPL)**: TMPL-000010/011 라벨은 "50장"인데 L1 카드봉투(004)는 "10장 1000/1500". template 묶음수(50장)와 시트 묶음수(10장)가 다름 → addon 단가를 시트 10장가(1000)로 넣으면 50장 template에 10장 가격 오청구. **template 묶음수에 맞는 단가가 시트에 없음**(시트는 10장가만 보유). designer는 이를 **추측 적재 금지**·컨펌큐로 라우팅(addon 봉투의 실제 묶음 단가 권위 필요). OPP/트레싱지는 template 묶음수(50장/20장)가 시트 행과 일치 → verbatim 적재 가능.

### 4-3. addon 단가 적재 가드 (양 경로 정합 + fallback 차단)

- **template_prices 미적재 시 fallback(:299-300)**: "템플릿 직접단가 없음 → 기준 상품 가격으로 계산"(base prd_cd의 product_prices/formula로 회귀). 봉투 product_prices/formula도 미적재면 0원. → **template_prices 단가 적재가 addon 봉투 0원 회피의 핵심**.
- **양 경로 단가 정합[HARD]**: 동일 봉투의 독립 단가(§3 component_prices)와 addon 단가(§4 template_prices)는 **동일 variant면 동일 단가**(verbatim·마진 차이 없으면). 마진/번들가가 다르면 컨펌큐 Q-AC-PRICE로 의도 확인(추측 금지).
- **required vs optional addon(set-pricing A-3·책자 DV-BK4 저청구 가드)**: 봉투 addon은 **optional**(엽서 손님이 선택)·required 아님 → 미선택 시 본체 가격에 silent 합산 안 됨(엔진 addon은 손님 선택분만 가산). 강제 합산 금지.

---

## 5. ★본체 소재/색상 자재축 오염 = dbmap 트랙 위임 (이번 스코프 = 가격엔진 설계만) [HARD]

benchmark C-AC4(색=무료 직교)·C-AC5(형상/용량=규격 융합)가 흡수로 권고한 색상/형상 정리는 **가격엔진 설계가 아니라 자재축 데이터 정리**다 — 이번 스코프 밖·dbmap 라우팅만(굿즈 §5 동형).

| 항목 | 본질 | 가격엔진 함의 | 라우팅 |
|------|------|---------------|--------|
| 색상=자재 오염(G-AC-5) | 볼체인8·리필7 MAT_TYPE.10(★와이어링007·행택끈010은 2026-06-22 라이브 0행·round-13 GATE-1 stale) | AC-1 색상 동가 → **가격 비기여**. AC-2 카드봉투 색상은 가격축이나 opt_cd variant(자재 아님) | dbm-axis-staged-load ④자재·[[dbmap-material-option-normalization]] |
| 형상/용량=규격 융합(C-AC5) | 우드 길이·3D케이스·5cc 용량 = siz_nm 융합 | 길이/3D가 가격축이면 siz_cd variant 단가행(§3)으로 충분·별 형상축 금지(과분할) | dbmap(GAP-SHAPE 비치수 siz) |
| siz_nm 묶음수/색상 잔존(G-AC-4) | "70x200mm(50장)"·"화이트165x115mm" 텍스트 잔존 | AC-2 variant축 정의 시 묶음수→bdl_qty·색상→opt_cd 분리(use_dims 충전 선결) | dbmap size→option 트랙(가격엔진은 use_dims 충전만 협업) |

★ **가격엔진 설계 입장에서 색상/형상/용량은 전부 "상품 inline 고정가에 이미 포함"** — 후니 부자재는 RedPrinting `tmpl_price`(완제 개당단가)·WowPress `jobcost`(unit=개)처럼 **완제 SKU 개당단가로 계산**(부품 합산 아님). 따라서 가격엔진은 AC-1/AC-2 단가행 verbatim만 충전하면 되고, 색상/형상 정리는 **자재축 데이터 트랙(dbmap)**이 별도로 처리(이중 작업 금지).

---

## 6. CPQ 옵션 (variant 선택 주입 — 가격축 직결)

라이브 악세사리 CPQ option_items 미연결(테스트 잔재 2·items 0). AC-2 variant 선택이 selections에 실려 siz_cd/opt_cd/bdl_qty로 주입되는 레이어가 가격축과 직결(미연결 시 variant 단가 룩업 불가·디폴트 variant 필요).

| 항목 | 가격 처리 | 선택 처리 | 그릇 |
|------|----------|----------|------|
| **AC-2 variant(규격/묶음/색상)** | **가격축**(COMP_ACC_* use_dims 판별차원) | 택1 → siz_cd/opt_cd/bdl_qty 주입 | round-6 CPQ option_group(택1)→option_items→ref_dim_cd=siz_cd/opt_cd/bdl_qty |
| **AC-1 색상** | **가격 비기여**(동가) | 본체색=재질 합성(생산 BOM) | dbmap(가격 무관·UI 옵션표시만) |
| **봉투 addon(엽서)** | TEMPLATE_PRICE 별 라인 | 엽서 손님 봉투 선택(optional) | t_prd_product_addons(5행 실재)→template_prices |

- **G-AC-4(CPQ 미적재)**: AC-2 variant 룩업이 작동하려면 AC-2 상품에 option_items(ref_dim_cd=siz_cd/opt_cd/bdl_qty) 적재 선결(round-6 dbm-option-mapper). 미연결 시 AC-2는 디폴트 variant 필요(0원 침묵 회피). **컨펌큐 Q-AC-OPT.**
- ★AC엔 **가공 가산 항 없음**(굿즈 라벨/맥세이프 같은 후가공 미수록) → addtn_yn=Y 별 comp 불요(굿즈와 차이). 발명 금지.

---

## 7. 완제품 vs 반제품(세트) — 가격축 경계

| 구분 | 상품악세사리 상품 | 가격 처리 |
|------|------------------|-----------|
| **완제품(단일/변형 고정가)** | 봉투·케이스·볼체인·와이어링·리필잉크·우드부속·자석·끈 전부(AC-1·AC-2) | 각 상품 1 고정가(또는 variant별 고정가). 면적/원자합산/세트조합 분해 없음 |
| **반제품/세트(조합)** | **부재**(t_prd_product_sets sub_prd_cd 0행) | calc-draft 세트 분해 없음·각 부자재=단일 완제품(매입/외주 1점) |
| **적용경로(세트 아님)** | 봉투-엽서 결합 = addon(§4·TEMPLATE_PRICE) | 세트 부품 합산이 아니라 본체+옵션 별 라인. 우드행거-포스터 결합도 addon 귀속(독립 고정가 + addon) |

★ **상품악세사리는 세트조합 레이어 불요(굿즈·아크릴·실사 본체와 동일·set-product-design 악세사리 절).** 부속물(우드 등)은 RedPrinting 부속물#8(addons.tmpl_cd)·후니 봉투 addon 5행과 동형 — **독립 완제 고정가(C-AC1) + 본체 addon 귀속(A-3)** 두 경로로 모델링(세트 분해 아님). 부속물 BUNDLE(우드+면끈+부착)은 가격은 완제 고정가에 baked-in·자재/공정 분해는 생산 BOM(dbmap·A-4). `확신도: 높음(t_prd_product_sets 0행·addon 5행·calc-draft 단일 고정가형)`

---

## 8. evaluate_price 계약 정합 체크 (설계 자기검증)

| 계약(engine-contract·pricing.py) | 설계 준수 |
|----------------------------------|-----------|
| 가격소스 우선순위(TEMPLATE→PRODUCT_PRICE→FORMULA·:296-326) | ✅ AC-1=PRODUCT_PRICE(단일가 무손실)·AC-2=FORMULA(variant 단가·product_prices INSERT 금지 §3-6)·addon=TEMPLATE_PRICE(:296). 명함식 공식 AC-1 적용 부결(과설계) |
| C7 frm_typ 미참조·공식=합산 | ✅ AC-2 comp 1배선 합산형(frm_typ 무참조)·AC-1은 공식 안 씀 |
| P3-8 ERR_AMBIGUOUS 금지(한 comp 단가행 사이) | ✅ COMP_ACC_* variant축(siz_cd/opt_cd/bdl_qty) NON_QTY_DIMS 정확매칭 1행 → 모호성 0 |
| P3-DEF 판별차원 없음 / silent 이중합산 | ✅ AC-2 comp 1개·addtn_yn=N·variant 판별차원 명시→구조적 이중합산 불가. AC-1 product_prices 차원 없음→침입 불가 |
| P4-1 단가형 ×qty / P4-3 합가형 min_qty 필수 | ✅ COMP_ACC_* `.01` 단가형·unit×qty(÷ 미발생·G-AC-2 묶음 ÷ 금지)·min_qty=1. **합가형 금지** |
| TIER min_qty '이상' 하한(:42·144) | ✅ AC-2 min_qty=차원 아님(variant당 단일가 1행·min_qty=1)·bdl_qty는 식별차원이지 tier 분모 아님(§3-4) |
| 수량구간할인 연결(:478-504) | ✅ **부자재 미해당·링크 0행 정당**(no-op 정상·발명 금지·굿즈 DSC 4타입과 결정적 차이) |
| U-7 시트 차원경계(SOT 1) | ✅ AC-1 product_prices=단일가(타 comp 침입 불가)·AC-2 COMP_ACC_* 1개(타 comp 침입 없음)·본체 색상/형상=가격축 아님(§5) |
| 할인 적용 순서(:356-369) | ✅ ① base → ② 구간할인 no-op(부자재 미바인딩) → ③ 등급(엔진 단일 경로) |
| addon fallback(:299-300) | ✅ template_prices 단가 적재로 fallback(기준상품 가격) 회피·양 경로 정합(§4-3) |
| search-before-mint | ✅ AC-1=product_prices INSERT(공식/comp 신설 0)·AC-2=공식 3+comp 3 뿐(LINEN_FINISH opt_cd 그릇 선례 재사용)·addon=template_prices 단가만 충전·**신규 테이블/가격축 0**·평탄화 금지(G-AC-1) |

---

## 9. search-before-mint 표 (신규 mint 최소·전부 기존 그릇 재사용 입증)

| 설계 요소 | 신규 여부 | 재사용 그릇·선례 | 무손실 표현 입증 |
|-----------|----------|-------------------|-------------------|
| AC-1 단가 그릇 | INSERT(신규 mint 0) | `t_prd_product_prices`(굿즈 GP-1·문구 DT-1) | unit_price 1행=단일 고정가 무손실 |
| AC-2 공식 | mint 3(PRF_ACC_SIZED/BUNDLE/VARIANT) | 굿즈 PRF_GOODS_SIZED/VARIANT·아크릴 PRF_CLR_ACRYL 컨벤션 | comp 1배선 합산형(엔진 변경 0) |
| AC-2 comp | mint 3(COMP_ACC_SIZED/BUNDLE/VARIANT) | `COMP_POSTEROPT_LINEN_FINISH`(use_dims=[opt_cd,min_qty]·PRICE_TYPE.01 라이브 실작동) | variant 1축(siz/opt/bdl) 단가형=린넨 그릇 동형 |
| AC-2 단가행 | INSERT | `t_prc_component_prices`(siz_cd·opt_cd·bdl_qty 컬럼 실재) | variant당 1행·use_dims 판별차원 |
| AC-2 바인딩 | INSERT | `t_prd_product_price_formulas`(굿즈·아크릴) | prd_cd→frm_cd 3공식 공유 |
| addon 단가 | INSERT | `t_prd_template_prices`(봉투 template 5행·addon 5행 실재) | tmpl_cd 단일가·엔진 TEMPLATE_PRICE 경로 |
| 수량구간할인 | **신규 0**(부자재 미해당) | (발명 금지·라이브 0행 정당) | 부자재 구간할인 없음 |
| 신규 테이블/가격축 | **0건** | benchmark C-AC1~7·rpmeta 17축 재포화·WowPress 6축 | — |

**∴ 신규 mint = 공식 3 + comp 3 뿐.** 신규 테이블·가격축·할인테이블 = 0. 나머지는 전부 기존 그릇 INSERT/바인딩/링크(굿즈 종단 그릇 직계 전파).

---

## 10. designer 큐 잔여 (golden-cases·design-decisions로 이관)

- **AC-1 3상품 product_prices INSERT**(§2·I열 verbatim 볼체인1000/와이어링500/리필잉크2500) = 1순위(가격계산 불가 직결).
- **AC-2 변형단가 그릇 = (b)formula 확정**(§3·공식 3+comp 3·LINEN_FINISH 선례) + **평탄화 가드**(G-AC-1·돈크리티컬) + **묶음 .01 가드**(G-AC-2·돈크리티컬) + **PRODUCT_PRICE 선점 가드**(§3-6·AC-2 product_prices INSERT 금지) = 1순위.
- **봉투 addon template_prices 단가 + 양 경로 정합**(§4·G-AC-3) = High·단 ★카드봉투 묶음수 불일치(Q-AC-TMPL) 컨펌 선결.
- **CPQ option_items 주입**(§6) → 컨펌큐 Q-AC-OPT(round-6).
- **천정고리(008·use_yn=N) 가격 제외**(§0) → 컨펌큐 Q-AC-CEIL.
- **색상/형상 자재 오염 정리**(§5) → dbmap 트랙 위임(가격엔진 스코프 밖·라우팅만).

실 적용(product_prices INSERT·AC-2 공식/comp/단가행/바인딩·addon template_prices)은 **DB 미적재·인간 승인 후 dbmap 위임**(dbm-load-execution·dbm-price-arbiter·dbm-axis-staged-load).
