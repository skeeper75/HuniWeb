# engine-design-goods-pouch.md — 굿즈/파우치 고정가형 + 변형단가 + 구간할인타입 가격엔진 설계

> **핵심 설계가(hpe-engine-designer) 산출 — 굿즈/파우치 종단(6번째·디지털[원자합산+고정가]·아크릴[면적]·실사현수막[면적+거치]·문구[고정가+매트릭스]·책자[부품합산세트] 다음).**
> cartographer 지도(`formula-map-goods-pouch.md`)+benchmark 흡수(`absorption-candidates-goods-pouch.md`·`set-pricing-patterns.md` P-7)를 종합해,
> 굿즈/파우치 **GP-1 단일고정가(55) + GP-2 변형고정가(31)** 완제품의 가격공식+가격구성요소+t_prc_*/t_prd_* 단가 그릇+바인딩+수량구간할인타입 연결을
> 라이브 `evaluate_price` 단일 권위 알고리즘이 그대로 먹는 형태로 설계한다. **새 엔진 코드 아님 — 데이터 그릇/바인딩/링크 설계.**
>
> 권위[HARD]: ① 상품마스터(260610) 굿즈파우치(가격포함) 시트 + 계산공식집초안 > ② 인쇄상품 가격표(260527) > ③ 라이브 t_prc_*/t_prd_*(기준선) > ④ 역공학(후보).
> 산출자: hpe-engine-designer · 라이브 읽기전용 SELECT 실측 2026-06-20 · 단가값=권위 verbatim(날조 0) · **DB 미적재**(실 적용 인간 승인 후 dbmap 위임·webadmin 코드 직접수정 금지).
> 디지털인쇄·아크릴·실사현수막·문구·책자 GO 설계와 동일 컨벤션·동일 engine-contract(pricing.py).
> **★이번 스코프: 굿즈/파우치 시트 86 distinct 상품(라이브 활성 88·GP-1 단일고정가 55 + GP-2 변형고정가 31). 폰케이스 기종(Sheet-only·라이브 미등록)은 상품 등록 선행 = 분석/라우팅만(G-GP-7).**

---

## 0. 설계 요약 — 라이브 baseline 대비 무엇을 하나 (5종단 중 가장 단순한 계산 · 가장 미완성한 라이브)

라이브 실측(2026-06-20)이 cartographer 지도를 **전부 확인**했다. 굿즈/파우치는 계산방식이 **단일 고정가형**(면적/원자합산/매트릭스/세트 전부 없음)으로 5종단 중 가장 단순하나, 라이브 가격본체(고정가)는 **0행**으로 완성도 최저다.

| 라이브 실측 (2026-06-20·읽기전용 SELECT) | 값 | 설계 함의 |
|----------------------------------|----|-----------|
| **t_prd_product_prices** (183~280) | **0행** | GP-1 본체 고정가 그릇=이 테이블(차원 없는 단일가). 전무 → INSERT 대상 |
| **활성 상품(use_yn=Y·del_yn=N)** | **88** | 전건 가격계산 불가(source=NONE)·바인딩 0·product_prices 0 |
| **t_prd_product_price_formulas 바인딩** | **0행** | GP-2 변형단가 공식 바인딩 전무(아크릴 G-A1 동형·더 깊음) |
| **구간할인 바인딩(t_prd_product_discount_tables)** | DSC_GOODSA 15·DSC_GOODSB 11·DSC_FABRIC 50·DSC_SQUISHY 5·DSC_ACR 1 = **82** | 할인 골격 절반 적재(round-1·4타입 택1) |
| **할인테이블 4종(t_dsc_discount_tables)** | DSC_GOODSA/B·DSC_FABRIC·DSC_SQUISHY 전건 use_yn=Y·DSC_TYPE.01(정률) | "수량별구간할인 타입"=상품별 4종 택1(문구 단일 DSC_STAT_QTY와 결정적 차이) |
| **자재 BOM 상품 수(t_prd_product_materials)** | **76상품** | round-22 적재분(레더/캔버스/타이벡/메쉬 등)·본체 소재 절반 (validator 2026-06-20 정정·count(DISTINCT prd_cd) del_yn='N'=76) |
| **opt_cd 차원 단가행 선례** | `COMP_POSTEROPT_LINEN_FINISH` use_dims=`["opt_cd","min_qty"]` 실재 | ★GP-2 (b)formula 그릇 선례 라이브 실재(dbmap round-23 린넨 COMMIT) — search-before-mint 강하게 충족 |

**∴ 굿즈/파우치 설계의 핵심 4가지:**
1. **GP-1 단일고정가 55상품 = 문구 본체(A)·`PRODUCT_PRICE` 경로 완전 동형** — `t_prd_product_prices.unit_price × qty`(공식·comp 없이 작동) + 구간할인타입. 명함식 통합 comp 공식 **부결**(과설계·문구 DT-1 동형).
2. **★GP-2 변형고정가 31상품 = 최대 난제 G-GP-1 그릇 결정** — variant별 자기 고정가(S5000/M5500/L6000)를 PRODUCT_PRICE(unit_price 1개)·option_items(add_price 없음) 어디에도 못 담음. **(b)size/variant-매트릭스 formula 채택**(아크릴 면적매트릭스 1축 축소판·`COMP_POSTEROPT_LINEN_FINISH` opt_cd 차원 선례 재사용·엔진 변경 0).
3. **★G-GP-3 평탄화 함정(돈크리티컬)** — GP-2를 GP-1처럼 단일 unit_price로 평탄 적재 시 M 주문에 S가격 오청구. **variant축을 use_dims 판별차원으로 충전(평탄화 절대 금지).** 디지털 인쇄면 silent 합산·실사 면적과 동류 가드.
4. **수량구간할인 = 4타입 택1** — 문구는 단일 DSC_STAT_QTY이나 굿즈는 상품별 GOODSA/B·FABRIC·SQUISHY 택1(바인딩 82 실재·base가 0이라 현재는 0원). 고정가 적재 후 구간할인 곱 골든 검증.
5. **★GP-2 PRODUCT_PRICE 선점 가드(돈크리티컬·codex Phase5.5 독립 발견)** — 엔진 가격소스 우선순위 `PRODUCT_PRICE → FORMULA`(pricing.py). GP-2 상품에 `t_prd_product_prices` 행이 **1건이라도 있으면 FORMULA 경로가 통째로 우회**되어 variant 단가(공식)가 **영영 안 먹힌다**. G-GP-3 평탄화(틀린 값)보다 더 silent한 실패(엉뚱한 평탄가가 formula를 죽임·경고 없음). **[적재 가드] GP-2 상품은 product_prices INSERT 금지·formula 바인딩만**(GP-1만 product_prices). Q-GP-OPT1 적재 시 박제.

★ **5종단 동형 클래스 판정:** GP-1 = **문구 본체(A) 고정가형 완전 동형**(고정가×수량−구간할인·PRODUCT_PRICE). GP-2 = **신규 서브유형**(옵션 variant별 고정가 — 문구엔 없던 제3유형). 그러나 그 그릇은 **신규 가격축이 아니라 기존 면적매트릭스 component_prices를 1축(opt_cd/siz_cd)으로 재사용**(아크릴·실사·떡메모 동형). **세트조합 레이어 불요**(아크릴·실사 동형·set-product-design 굿즈 절). 신규 테이블/가격축 = **0건**(benchmark·rpmeta GS distinct 부결·5종단 정합).

---

## 1. 계산방식 — 단일 고정가형 (frm_typ 미참조·계산방식은 가격소스 경로 차이일 뿐)

calc-formula-draft-l1.csv row 122~123(절대 권위): `[고정가형: 굿즈/파우치] = 고정가 + 수량별구간할인 타입 + 추가상품`.

| 서브클래스 | 정의 | 상품 수 | 엔진 처리(engine-contract·pricing.py) | 가격소스 경로 |
|-----------|------|:--:|---------------------------------------|--------------|
| **GP-1 단일고정가** | 판매가 = [상품 고정단가] × 수량 − 구간할인타입 | **55** | `t_prd_product_prices.unit_price × qty`(:312-317·공식/comp 없이 작동) → `_quantity_discount`(:360) | **PRODUCT_PRICE** |
| **GP-2 변형고정가** | 판매가 = [variant별 고정단가] × 수량 − 구간할인타입 | **31** | comp 1개 variant 차원(opt_cd 또는 siz_cd) 룩업 단가형 unit×qty(:320-326·:191) → 구간할인 | **FORMULA** |

★ **핵심[HARD]**: 엔진은 `frm_typ_cd`를 참조하지 않는다(engine-contract C7·pricing.py:8 "공식유형 frm_typ 폐기→공식은 항상 구성요소 합산"). "GP-1 단일고정가"·"GP-2 변형고정가"는 별 엔진 분기가 아니라 **가격소스 경로(PRODUCT_PRICE vs FORMULA)의 차이**일 뿐. 디지털·아크릴·실사·문구 설계 §1과 동형(frm_typ 미참조 계약 동일).

★ **두 경로의 결정적 차이**: GP-1은 공식·comp **불요**(product_prices가 곧 단가·단일가 무손실). GP-2는 공식·comp **필요**(variant별 단가 룩업). 같은 "고정가" 어휘이나 엔진 그릇이 다르다(문구 본체 vs 떡메모와 동형 구조).

---

## 2. ★(GP-1) 단일고정가 55상품 — PRODUCT_PRICE 경로 (G-GP-2·G-GP-3 단일분·문구 DT-1 동형)

### 2-1. 가격 소스 결정 = t_prd_product_prices 직접 고정가 (명함식 공식 신설 부결)

라이브 pricing.py 가격소스 우선순위(:296-326): ① TEMPLATE_PRICE → **② PRODUCT_PRICE(`t_prd_product_prices`)** → ③ FORMULA. GP-1 굿즈는 **상품마스터 `가격`(C열) 단일 inline 고정가**(차원 없음·카드거울 2500 단 1가)이므로 **② PRODUCT_PRICE 경로가 정답 그릇**이다.

- **t_prd_product_prices** 구조(라이브 실측): `prd_cd`·`apply_ymd`(PK)·`unit_price`·`note`. **차원 컬럼 없음** → 상품당 적용일별 단가 1건. GP-1 굿즈처럼 옵션·사이즈로 단가가 안 갈리는 단일 고정가에 정확히 맞음.
- 엔진 처리(:315-317): `base_amount = unit_price × qty`. 그 후 §4 수량구간할인타입 자동 적용.

★ **search-before-mint 결론[HARD]**: 명함/포토카드(PRF_NAMECARD_FIXED·PRF_PHOTOCARD_FIXED) "고정가형 공식+완제품 통합단가 comp" 패턴을 GP-1 굿즈에 **적용하지 않는다**(문구 DT-1 동형 부결). 근거:
- GP-1 굿즈는 **단일 고정가**(카드거울 2500 단 1가·variant 분기 없음·distinct 가격=1) → comp+공식 그릇은 **과설계**. product_prices 1행이 무손실 표현.
- 명함/포토카드는 소재·사이즈·세트(bdl_qty)로 단가가 갈려 comp 매트릭스가 필요했음(고정가형 공식 정당). GP-1은 그 차원이 없음.
- ∴ GP-1 굿즈 = product_prices 직접가. 명함식 공식 신설 **부결**(디지털 D-4 "고정가형=comp 1배선 합산형"이 명함엔 맞으나 GP-1 단일가엔 product_prices가 더 단순·무손실).

### 2-2. GP-1 단일고정가 그릇 명세 (t_prd_product_prices INSERT·상품마스터 C열 verbatim)

GP-1 55상품 전체를 `t_prd_product_prices`에 unit_price 1행 INSERT한다. 단가값 = **상품마스터 260610 굿즈파우치(가격포함) 시트 `가격`(C열) inline verbatim**(formula-map §3). 대표 예시(designer 값 창작 0 — cartographer 지도가 상품마스터에서 추출한 verbatim):

| prd_cd | 상품(라이브 prd_nm) | unit_price(C열 verbatim) | apply_ymd | 구간할인타입(라이브 바인딩) | 비고 |
|--------|---------------------|--------------------------|-----------|----------------------------|------|
| PRD_000183 | 틴거울 | **3,000** | 2026-06-01 | DSC_GOODSB_QTY ✅ | 거울 본체 BOM(가격 비기여) |
| PRD_000185 | 카드거울 | **2,500** | 2026-06-01 | DSC_GOODSB_QTY ✅ | — |
| PRD_000189 | 코르크코스터 | **3,000** | 2026-06-01 | DSC_GOODSA_QTY ✅ | 코르크 소재 BOM |
| PRD_000196 | 레더여권케이스 | **5,000** | 2026-06-01 | DSC_GOODSA_QTY ✅ | 레더 BOM(round-22 적재) |
| PRD_000230 | 레더 플랫 파우치 | (C열 verbatim) | 2026-06-01 | DSC_FABRIC_QTY ✅ | prd_typ .01·레더 BOM(MAT_000319/320/008·USAGE.07) |
| PRD_000277 | 타이벡 보냉에코백 | (C열 verbatim) | 2026-06-01 | DSC_FABRIC_QTY ✅ | 타이벡 BOM(MAT_000332) |
| PRD_000279 | 메쉬에코백 | (C열 verbatim) | 2026-06-01 | DSC_FABRIC_QTY ✅ | 메쉬 BOM |

- **단가값 출처[HARD]**: 상품마스터 C열 inline verbatim. **GP-1 55상품 전체 단가는 dbmap 적재 시 상품마스터 원본 셀 재대조 필수**(검증가 E1). 위 표는 cartographer 지도가 명시 추출한 대표 verbatim — 미표기분(나머지 ~48상품)은 dbmap이 C열 전수 추출(designer 추측 금지).
- **apply_ymd**: 라이브 구간할인 바인딩 apply_bgn_ymd=2026-06-01과 정합. [[dbmap-live-load-transition-260615]] 적용일 시계열 구조 준수(2026-06-01 유지 UPSERT·신 단가행 분기 금지).

### 2-3. GP-1 바인딩·소스 유효성 가드 (U-7 binding-validity 계승)

- **PRODUCT_PRICE 경로는 product_price_formulas 바인딩 불요**(공식 안 씀). GP-1 55상품 = product_prices 1행씩이면 가격계산 성립.
- **시트 차원경계(SOT 1)**: GP-1 product_prices에 디지털/제본/면적 comp 침입 없음(차원 없는 단일가라 구조적으로 불가). ✅
- **본체 소재 BOM ≠ 가격축[HARD]**: 코르크/레더/타이벡 등 본체 소재(t_prd_product_materials·78상품)는 생산 BOM·MES이고 **가격은 단일 고정가 1건**. 본체 소재 단가를 합산하는 세트 레이어 **불요**(§7·set-product-design 굿즈 절). designer는 materials를 가격에 끌어들이지 말 것(benchmark C-GP2 본체소재는 자재축 오염 정리이지 가격 합산이 아님 — dbmap 위임).

---

## 3. ★(GP-2) 변형고정가 31상품 — 그릇 결정 [G-GP-1·최대 설계난제] + 평탄화 가드 [G-GP-3·돈크리티컬]

### 3-1. G-GP-1 그릇 결정 — (b)variant-매트릭스 formula 채택 (search-before-mint 결판)

cartographer Q-GP-1 3선택지를 라이브 search-before-mint로 결판한다.

| 선택지 | 설명 | search-before-mint 판정 |
|--------|------|------------------------|
| (a) variant마다 별 prd_cd | S/M/L = 3 prd_cd·각 PRODUCT_PRICE 1행 | ❌ 상품 폭증(31상품→~80 prd_cd)·옵션 UX 분리·round-10 size→option 의도(한 상품 내 옵션) 역행 |
| **(b) variant-매트릭스 formula** | PRF_GOODS_SIZED 등·comp 1개·use_dims=[opt_cd or siz_cd]·variant당 단가행 1행 | **✅ 채택** — 아크릴 면적매트릭스 1축 축소판·**라이브 `COMP_POSTEROPT_LINEN_FINISH` use_dims=["opt_cd","min_qty"] 선례 실재**(dbmap round-23 린넨 COMMIT)·엔진 변경 0·기존 component_prices 그릇 재사용 |
| (c) option_items add_price 신규 컬럼 | base + 옵션 add | ❌ DDL 필요(dbm-ddl-proposer)·rpmeta AC GAP·라이브 그릇 부재에 신규 컬럼=과설계 |

★ **결판 근거(라이브 실측 2026-06-20)[HARD]**: GP-2 변형단가는 **신규 가격축이 아니다.** 후니 `t_prc_component_prices`는 이미 `opt_cd`·`siz_cd` 차원 컬럼을 보유하고, `t_prc_price_components`는 `use_dims`로 그 차원을 판별차원으로 등재할 수 있다. **라이브에 `use_dims=["opt_cd","min_qty"]` 그릇이 실제로 작동 중**(LINEN_FINISH)이므로 **무손실 표현 가능 = vessel-gap 해소(신규 mint = 공식+comp 그릇 뿐·신규 테이블/축 0)**. 아크릴이 면적 2축(siz_width/siz_height)으로 한 것을 굿즈는 variant 1축(opt_cd 또는 siz_cd)으로 축소한 것일 뿐 — 동일 엔진 경로(:78-192).

### 3-2. GP-2 공식·구성요소 그릇 명세 (variant축 = opt_cd vs siz_cd 판별)

GP-2 31상품은 variant축 의미에 따라 2 그릇으로 갈린다(둘 다 동일 엔진·comp 1개 단가형·variant 판별차원).

| variant축 의미 | 상품 (4 서브유형) | 공식(신설) | 구성요소(신설) | use_dims | 단가행 차원 |
|---------------|------------------|-----------|----------------|----------|-------------|
| **사이즈등급(S/M/L)** | 사각손거울(186)·블랙사각손거울(187)·미니매트/피크닉매트·반팔티/후드티 | `PRF_GOODS_SIZED` | `COMP_GOODS_SIZED` | `["siz_cd"]` (사이즈등급=비치수 siz) 또는 `["opt_cd"]` | siz_cd(S/M/L)별 1행 |
| **용량(온스/ml)** | 머그컵(193·11온스/대용량)·워터북보틀(194·350ml/500ml) | `PRF_GOODS_VARIANT` | `COMP_GOODS_VARIANT` | `["opt_cd"]` (용량=옵션) | opt_cd(용량)별 1행 |
| **인쇄면(단면/양면)** | 벨벳쿠션(195·15000/16000)·이미지피켓(229·228) | `PRF_GOODS_VARIANT` | `COMP_GOODS_VARIANT` | `["opt_cd"]` (면=옵션) | opt_cd(면)별 1행 |
| **기종(폰케이스)** | 슬림하드/블랙젤리/임팩트/에어팟/버즈(라이브 미등록·G-GP-7) | `PRF_GOODS_VARIANT` | `COMP_GOODS_VARIANT` | `["opt_cd"]` (기종=옵션) | opt_cd(기종)별 1행 |

**구성요소 정의(t_prc_price_components 신설·아크릴/문구 컨벤션):**

| comp_cd | comp_nm(한글 표준) | comp_typ_cd | prc_typ_cd | use_dims | 비고 |
|---------|-------------------|-------------|------------|----------|------|
| **COMP_GOODS_SIZED** | 굿즈 사이즈등급 완제품가 | `PRC_COMPONENT_TYPE.06`(완제품) | **`PRICE_TYPE.01`(단가형)** | `["siz_cd"]` | 사이즈등급(S/M/L) variant·개당가 |
| **COMP_GOODS_VARIANT** | 굿즈 옵션변형 완제품가 | `PRC_COMPONENT_TYPE.06`(완제품) | **`PRICE_TYPE.01`(단가형)** | `["opt_cd"]` | 용량/면/기종 variant·개당가 |

★ **prc_typ_cd = `.01` 단가형 채택[HARD·돈크리티컬]**: GP-2 변형단가는 **개당 완제품가**(사각손거울 S=1개당 5,000·아크릴 면적단가=개당 동형). 단가형(`.01`)이면 `component_subtotal`(:191) = `unit_price × qty`(÷min_qty 미발생) → **min_qty 자유·ValueError 위험 0**. 단 §3-4 min_qty=1 명시 권장(일관성). (LINEN_FINISH 선례는 후가공 가산형이라 min_qty NULL이지만, GP-2 본체는 개당가이므로 단가형 + min_qty=1이 정합.)

**공식 정의(t_prc_price_formulas 신설) + 배선(t_prc_formula_components):**

| frm_cd | 배선 comp | disp_seq | addtn_yn | 비고 |
|--------|-----------|----------|----------|------|
| **PRF_GOODS_SIZED** | COMP_GOODS_SIZED | 1 | N | 본체 단독(아크릴 PRF_CLR_ACRYL 동형·comp 1배선) |
| **PRF_GOODS_VARIANT** | COMP_GOODS_VARIANT | 1 | N | 본체 단독 |

★ **comp 1배선·addtn_yn=N → silent 이중합산 구조적 불가**(공식당 comp 1개·변형단가 1행 룩업). 디지털 인쇄면 S1+S2 합산 위험 부재.

### 3-3. ★G-GP-3 평탄화 오청구 가드 [HARD·돈크리티컬]

GP-2를 GP-1처럼 `t_prd_product_prices` unit_price 1개로 평탄 적재하면 **S/M/L이 한 값** → M 주문에 S가격 오청구(round-10 size→option 재분류의 가격 함정·[[dbmap-change-tracking-round10]]).

- **방지 메커니즘[HARD]**: variant 각 행을 **comp 단가행(component_prices) 1행씩 + use_dims 판별차원(opt_cd/siz_cd)으로 충전**. 손님이 M(siz_cd=M 또는 opt_cd=M)을 선택하면 엔진 NON_QTY_DIMS 정확매칭(:38-39)이 M 단가행 1행만 후보로 골라 5,500 룩업. variant축을 **절대 NULL/와일드카드로 비우지 않음**(silent 이중합산·오선택 방지).
- **단가행 verbatim INSERT**: 사각손거울 S=5,000/M=5,500/L=6,000·블랙 S6,000/M7,500/L9,000·머그 6,500/7,500·보틀 350ml9,000/500ml9,300·벨벳쿠션 단면15,000/양면16,000(상품마스터 `가격` C열 행별 verbatim). **각 variant 행이 자기 고정가를 component_prices에 1행 보유**(평탄화 절대 금지).
- **검증 가드(E6)**: 골든에서 S/M/L 각각 다른 단가가 매칭되는지(GC-GP2 평탄화 양면 케이스로 입증)·M 주문에 S가격이 안 나오는지 재현.

### 3-4. GP-2 신규 단가행 INSERT 가드 (min_qty + variant 정확매칭)

- **COMP_GOODS_SIZED/VARIANT는 `.01`(단가형)** → ÷min_qty 미발생(:191) → **min_qty NULL이어도 ValueError 없음**(아크릴 CLEAR3T `.02`+NULL ValueError와 다름). 단 min_qty가 TIER 선택축(:42)이면 NULL=0 취급되어 모든 주문량 후보가 될 수 있으나, GP-2는 min_qty가 차원이 아니라 단일가(variant당 1행)이므로 무관. **일관성 위해 신규 행 min_qty=1 명시 권장**(아크릴/문구 동일 가드).
- **variant 정확매칭(NON_QTY_DIMS)**: opt_cd·siz_cd는 NON_QTY_DIMS(:38-39) 정확매칭 → 손님 선택 variant 1행 확정·모호성 0(P3-8 ERR_AMBIGUOUS 회피).

### 3-5. GP-2 바인딩 명세 (product_price_formulas — search-before-mint)

GP-2 31상품을 variant축에 따라 PRF_GOODS_SIZED 또는 PRF_GOODS_VARIANT에 바인딩(아크릴 G-A1 동형·신규 공식은 위 2개만·상품마다 신규 공식 안 만듦).

| 바인딩 대표 | 공식 | 근거 |
|-------------|------|------|
| PRD_000186 사각손거울 → PRF_GOODS_SIZED | (apply_bgn_ymd 2026-06-01) | 사이즈등급 S/M/L variant |
| PRD_000193 머그컵 → PRF_GOODS_VARIANT | (apply_bgn_ymd 2026-06-01) | 용량 variant |
| PRD_000195 벨벳쿠션 → PRF_GOODS_VARIANT | (apply_bgn_ymd 2026-06-01) | 인쇄면 variant |

★ **신규 mint = 공식 2(PRF_GOODS_SIZED·PRF_GOODS_VARIANT) + comp 2(COMP_GOODS_SIZED·COMP_GOODS_VARIANT) 뿐.** 신규 테이블/가격축 0. 31상품 전체는 이 2공식에 바인딩(상품별 공식 폭발 금지). variant 단가행은 상품마다 다르나 그릇(공식·comp·use_dims)은 2개 공유(맛간장 철학·[[dbmap-print-domain-recipe-philosophy]]).

---

## 4. ★수량구간할인 타입 [HARD·돈크리티컬·GP-1/GP-2 공통·문구와 결정적 차이]

### 4-1. 할인 연결 경로 (라이브 코드 확정·pricing.py:478-504·문구 §4와 동일 엔진)

```
evaluate_price (:360) → _quantity_discount(prd_cd, amount, qty, as_of)
  └─ t_prd_product_discount_tables.filter(prd_cd) → dsc_tbl_cd 링크 (:482-483)
       └─ t_dsc_discount_tables(헤더·dsc_typ_cd) (:487-488)
            └─ t_dsc_discount_details(구간·:491) → pick_discount_detail(min_qty≤qty≤max_qty·:493)
                 └─ apply_discount(amount, dsc_typ, rate%, amt) (:497)
```

★ **핵심[HARD]**: 할인은 **`t_prd_product_discount_tables`의 prd_cd→dsc_tbl_cd 링크**가 있어야 작동. 링크 누락 = 구간할인 0 적용 = 정가 과청구(돈크리티컬). 굿즈는 바인딩 82 실재(아래)·고정가(base)만 0.

### 4-2. ★굿즈 "구간할인 타입" = 4종 택1 (문구 단일 DSC_STAT_QTY와 결정적 차이·라이브 실측 verbatim)

calc-draft가 굿즈를 `수량별구간할인 **타입**`(타입입력)이라 규정했고, 라이브에 4종 할인테이블이 상품별로 택1 바인딩됐다(82링크). 4종 구간 디테일(t_dsc_discount_details verbatim·2026-06-20 실측):

| dsc_tbl_cd | 이름 | 바인딩 상품 수 | 구간(정률 %) |
|-----------|------|:--:|--------------|
| **DSC_GOODSA_QTY** | 굿즈상품 A타입 | 15 | 1~49=0% · 50~99=5% · 100~499=10% · 500~999=15% · 1000~=20% |
| **DSC_GOODSB_QTY** | 굿즈상품 B타입 | 11 | 1~99=0% · 100~499=5% · 500~=10% (3구간·완만) |
| **DSC_FABRIC_QTY** | 파우치/에코백 | 50 | 1~49=0% · 50~99=5% · 100~499=10% · 500~999=15% · 1000~=20% (A타입 동일 구조) |
| **DSC_SQUISHY_QTY** | 말랑상품 | 5 | 1~1=0% · 2~9=10% · 10~29=15% · 30~49=20% · 50~99=25% · 100~499=30% · 500~999=40% · 1000~=50% (소량 급할인 8구간) |

★ **상품별 타입 바인딩은 권위 상품마스터 "구간할인적용테이블" 컬럼**(상품명 추측 금지·[[dbmap-discount-authority]]). 라이브 실측 대표: 틴거울/카드거울/머그=B타입·사각손거울/코르크코스터/보틀/쿠션/여권케이스=A타입·파우치/에코백 3=FABRIC(카테고리단위). 말랑류=SQUISHY.

### 4-3. ★FABRIC = 카테고리 단위 바인딩 (신규 파우치 추가 시 누락 점검·G-GP-6)

DSC_FABRIC_QTY 바인딩 50링크는 **파우치/에코백 카테고리 family 일괄**(round-1 권위·개별 상품마다 행이 아니라 family·[[dbmap-discount-authority]]). 신규 파우치 추가 시 prd_cd→DSC_FABRIC 링크 INSERT가 누락되면 그 상품은 할인 0=과청구. **고정가 적재 후 family 전건 링크 점검**(검증가 가드).

### 4-4. 할인 적용 순서 (엔진 단일 경로·별 설계 불요)

```
① base_amount   (GP-1=product_prices unit×qty / GP-2=comp variant subtotal)
② 수량구간할인타입 (_quantity_discount: 상품별 GOODSA/B·FABRIC·SQUISHY 택1·정률 rate%)
③ 등급할인       (_grade_discount: 선택적)
   → ②③ 순차 곱·final_price = round_won
```

- GP-1·GP-2·아크릴·문구 전부 동일 엔진 경로(:356-369·별 분기 없음).
- ★**이중할인 없음[HARD]**: 굿즈는 변형단가(GP-2)도 variant별 단일 개당가일 뿐 단가 내장 볼륨할인이 아님(떡메모 min_qty 사다리와 다름). DSC_*_QTY 1회 적용이 정상(이중 볼륨할인 위험 부재). GP-1 단일가도 동일.

---

## 5. ★본체 소재/색/형상/구수의 자재축 오염 = dbmap 트랙 위임 (이번 스코프 = 가격엔진 설계만) [HARD]

benchmark C-GP2~C-GP4·C-GP7가 흡수로 권고한 본체 소재/색/형상/구수 정리는 **가격엔진 설계가 아니라 자재축 데이터 정리**다 — 이번 스코프 밖·dbmap 라우팅만.

| 흡수 항목 | 본질 | 가격엔진 함의 | 라우팅 |
|-----------|------|---------------|--------|
| 본체 소재(C-GP2) | 소재가 상품정체(상품명에만·.05/.06 고아) | GP-1/GP-2 단가는 이미 상품별 inline 고정가에 baked-in(소재 단가 합산 아님) → **가격축 아님** | dbm-axis-staged-load ④자재(GPM-4·[[dbmap-material-option-normalization]]) |
| 본체색=재질행 합성(C-GP3·split 금지) | 파우치 이미 정답(MAT_000061 root+색 자식) | 색 variant 추가가격 0(동가) → **가격 비기여** | dbmap(생산 BOM·UI 옵션표시만) |
| 형상=규격축 융합(C-GP4·가드) | siz_nm 형상·도무송 칼틀 | **형상이 가격축인지 가드[돈크리티컬]** — 같은 사이즈/소재면 형상별 가격 동일(스티커 반칼·아크릴 모양재단 정합) → 형상별 다른 단가 적재 금물 | dbmap(GAP-SHAPE 비치수 siz) |
| 구수/개수(C-GP7·GAP-COUNT) | 키캡키링 1~4구 | 구수가 가격축이면(타공 개수 비례) 개수 보존 필요·아니면 비기여 | dbm-ddl-proposer(ref_param_json·발명 금지) |
| 자재 .09 오염(74행) | 색/형상/구수가 자재행 | 본체 단가에 직접 영향 없음(component_prices 0참조·[[dbmap-axis-staged-load-round22]]) | dbm-axis-staged-load ④자재 B-3 |
| 3 GAP(SHAPE/COUNT/OPT) | 비치수 siz·개수보존·포장그릇 | vessel 신설 아니라 컬럼/코드행 사다리 | dbm-ddl-proposer(발명 금지·플래그만) |

★ **가격엔진 설계 입장에서 본체 소재/색/형상은 전부 "상품 inline 고정가에 이미 포함"** — 후니 굿즈는 RedPrinting `tmpl_price`(완제 개당단가)·WowPress `paperinfo`(블랭크 합성)처럼 **본체를 부품 합산이 아니라 완제 SKU 개당단가로 계산**한다. 따라서 가격엔진은 GP-1/GP-2 단가행 verbatim만 충전하면 되고, 소재/색/형상 정리는 **자재축 데이터 트랙(dbmap)**이 별도로 처리한다(이중 작업 금지·경계 명확).

---

## 6. CPQ 옵션 (G-GP-4·G-GP-5·가산항)

라이브 굿즈/파우치 CPQ option_items 미연결(round-7 횡단 — 전역 477행이나 굿즈 미적재). GP-2 variant 선택이 selections에 실려 opt_cd/siz_cd로 주입되는 레이어가 가격축과 직결(미연결 시 변형단가 룩업 불가).

| 항목 | 가격 처리 | 선택 처리 | 그릇 |
|------|----------|----------|------|
| **GP-2 variant(사이즈등급/용량/면/기종)** | **가격축**(COMP_GOODS_* use_dims 판별차원) | 택1 → siz_cd 또는 opt_cd 주입 | round-6 CPQ option_group(택1)→option_items→ref_dim_cd=siz_cd/opt_cd |
| **가공(라벨부착 +300·맥세이프 +6500·에폭시 0)** | 본체 + **정액 가산**(addtn_yn=Y 별 comp·G-GP-5) | 가공 택1 옵션 | 후가공 comp(개당 1회 vs ×수량 가드·아래) |
| **추가상품(잉크 5cc +2500·볼체인 +1000·아크릴스탠드)** | 별 부속 SKU | 색상 variant=동가 | `t_prd_product_addons`+`t_prd_templates` SKU(round-6) |
| **색상 variant** | **가격 비기여**(선택_가격 전부 0·동가) | 본체색=재질 합성(생산 BOM) | dbmap(가격 무관·UI 옵션표시만) |

- ★**가공 가산 = 개당 1회 vs ×수량 [HARD·돈크리티컬]**: 라벨부착(+300)·맥세이프(+6500)가 **개당 가산**이면 후가공 comp `.01`·use_dims=[opt_cd]·min_qty=1(unit×qty=개당×수량·각 개에 라벨 1개)·**1회 정액**이면 use_dims=[]·qty=1 격리. 디지털 후가공 prc_typ .01 ×수량 과청구·아크릴 Q-ACR-FIN1 동일 클래스. **추측 적재 금지·컨펌큐 Q-GP-FIN1 + dbm-price-arbiter 심의.** (현재 라이브 미적재 → 신설 시 가드.)
- **G-GP-4(CPQ 미적재)**: 변형단가 룩업이 작동하려면 GP-2 상품에 option_items(ref_dim_cd=siz_cd/opt_cd) 적재 선결(round-6 dbm-option-mapper). 미연결 시 GP-2는 디폴트 variant 필요(0원 침묵 회피). **컨펌큐 Q-GP-OPT1.**

---

## 7. 완제품 vs 반제품(세트) — 가격축 경계 (G-GP-세트)

| 구분 | 굿즈/파우치 상품 | 가격 처리 |
|------|----------------|-----------|
| **완제품(단일/변형 고정가)** | 거울·코스터·머그·보틀·쿠션·파우치·에코백·필통·말랑류 전부(GP-1·GP-2) | 각 상품 1 고정가(또는 variant별 고정가). 면적/원자합산/세트조합 분해 없음 |
| **반제품/세트(조합)** | **명시적 세트 상품 부재** | calc-draft가 굿즈를 세트조합으로 분해하지 않음. 디지털 엽서북식 내지+표지 별 SKU 합산·책자 부품 합산 없음 |
| **가산/옵션(공식 외)** | 가공(라벨/맥세이프/에폭시)·추가상품(잉크/볼체인/스탠드)·색상 | §6. 가공=본체 + 가산·추가상품=addon SKU·색상=동가 |

★ **굿즈/파우치는 세트조합 레이어 불요(아크릴·실사·문구 본체와 동일·set-product-design 굿즈 절).** 완제 굿즈는 RedPrinting `tmpl_price` 동형 **개당단가**(부품 합산 아님·set-pricing P-7a). 단 노트류/파우치의 본체+조립(지퍼/끈) BUNDLE은 자재+공정(addtn_yn 합산)일 수 있으나 **가격은 여전히 상품 inline 고정가에 baked-in**(BUNDLE은 생산 BOM·set-pricing P-7c·dbmap 위임). 디지털 엽서북·책자 같은 별 SKU 분리단가 합산 세트가 굿즈엔 없다. `확신도: 높음(calc-draft 단일 고정가형·라이브 세트 0)`

---

## 8. evaluate_price 계약 정합 체크 (설계 자기검증)

| 계약(engine-contract·pricing.py) | 설계 준수 |
|----------------------------------|-----------|
| 가격소스 우선순위(TEMPLATE→PRODUCT_PRICE→FORMULA·:296-326) | ✅ GP-1=PRODUCT_PRICE(차원 없는 단일가 무손실)·GP-2=FORMULA(variant 단가). 명함식 공식 GP-1 적용 부결(과설계) |
| C7 frm_typ 미참조·공식=합산 | ✅ GP-2 comp 1배선 합산형(frm_typ 무참조)·GP-1은 공식 안 씀 |
| P3-8 ERR_AMBIGUOUS 금지(한 comp 단가행 사이) | ✅ COMP_GOODS_* variant축(opt_cd/siz_cd) NON_QTY_DIMS 정확매칭 1행 → 모호성 0 |
| P3-DEF 판별차원 없음 / silent 이중합산 | ✅ GP-2 comp 1개·addtn_yn=N·variant 판별차원 명시→구조적 이중합산 불가. GP-1 product_prices 차원 없음(단일가)→침입 불가 |
| P4-1 단가형 ×qty / P4-3 합가형 min_qty 필수 | ✅ COMP_GOODS_* `.01` 단가형·unit×qty(÷ 미발생·min_qty 자유). GP-1 product_prices unit×qty. ÷min_qty 교정 불요(개당가) |
| TIER min_qty '이상' 하한(:42·144) | ✅ GP-2 min_qty=차원 아님(variant당 단일가 1행·min_qty=1 권장) |
| 수량구간할인 연결(:478-504) | ✅ 4타입 택1(GOODSA/B·FABRIC·SQUISHY)·바인딩 82 실재·base 0 적재 후 곱(§4)·FABRIC 카테고리단위 누락 점검 |
| U-7 시트 차원경계(SOT 1) | ✅ GP-1 product_prices=단일가(타 comp 침입 불가)·GP-2 COMP_GOODS_* 1개(타 comp 침입 없음)·본체 소재 BOM=가격축 아님(§5·§7) |
| 할인 적용 순서(:356-369) | ✅ ① base → ② 구간할인타입 → ③ 등급(엔진 단일 경로·이중할인 없음) |
| search-before-mint | ✅ GP-1=product_prices INSERT(공식/comp 신설 0)·GP-2=공식 2+comp 2 뿐(LINEN_FINISH opt_cd 그릇 선례 재사용)·**신규 테이블/가격축 0**·할인테이블 4종 재사용(링크만)·평탄화 금지(G-GP-3) |

---

## 9. designer 큐 잔여 (golden-cases·design-decisions로 이관)

- **G-GP-2 GP-1 단일고정가 55상품 product_prices INSERT**(§2·C열 verbatim·미표기 ~48상품 dbmap C열 전수) = 1순위(가격계산 불가 직결).
- **G-GP-1 GP-2 변형단가 그릇 = (b)formula 확정**(§3·공식 2+comp 2·LINEN_FINISH 선례) + **G-GP-3 평탄화 가드**(돈크리티컬·variant 판별차원) = 1순위.
- **수량구간할인 4타입 곱 골든 검증**(§4·base 0 적재 후) = High(틴거울 3000×100개 B타입 −5% 등).
- **가공 가산 개당/×수량 의미**(§6) → 컨펌큐 Q-GP-FIN1·dbm-price-arbiter.
- **CPQ option_items 주입**(§6) → 컨펌큐 Q-GP-OPT1(round-6).
- **본체 소재/색/형상/구수 오염 정리**(§5) → dbmap 트랙 위임(가격엔진 스코프 밖·라우팅만).
- **폰케이스 기종(Sheet-only·라이브 미등록)**(G-GP-7) → 상품 등록 선행(round-24)·등록 후 GP-2 PRF_GOODS_VARIANT 바인딩.

실 적용(product_prices INSERT·GP-2 공식/comp/단가행·바인딩·할인 링크)은 **DB 미적재·인간 승인 후 dbmap 위임**(dbm-load-execution·dbm-axis-staged-load·dbm-price-arbiter).
