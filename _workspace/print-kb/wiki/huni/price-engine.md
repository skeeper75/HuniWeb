# 가격엔진 (Price Engine) — 횡단 축

> huni 레이어(분석대상). 가격공식·구성요소·단가를 원자 항목으로 분리해 상품이 `priced-by`로 참조한다.
> 앵커: 라이브 `t_prc_*` 4단 구조(`t_prc_price_formulas`→`t_prc_formula_components`(배선)→`t_prc_price_components`→`t_prc_component_prices`) + `t_dsc_*`(할인) + `t_prd_template_prices`(SKU 직접단가) + `t_prd_product_prices`(직접단가).
> **단일 권위 알고리즘 = `pricing.py:evaluate_price` 하나** — 시뮬레이터·위젯·주문이 동일 호출. 위키 가격 축 1차 권위.
> **[델타 갱신 2026-06-18] 권위 반전 [HARD]:** 가격엔진을 라이브 `evaluate_price`(pricing.py 570줄) + 라이브 `information_schema`로 재확정한 두 신규 하네스(`huni-price-engine-diag/`·`huni-price-quote/`)가 이 축의 최상위 FRESH 원천. 기존 §정답소스였던 `prcx01-pricing-model.md`·`pricing-erd.md`는 **STALE로 강등**(8차원·clr_cd·frm_typ_cd 시절). 구조·차원·단가유형·도수 인용 금지([PE-STALE2]).
> **[HARD] 이 축은 가장 stale 위험이 크다.** 가격엔진 구조 인용은 **라이브 `t_prc_*` information_schema 실측 + `pricing.py` 직접**만.
> 큐레이션 팩: `_curation/axis-price-engine.md`(§0 FRESH 원천·§0c 핵심사실 7·STALE 함정 7).

---

## 0. SOT — 사용자 권위 도메인 정의 (최상위 권위)

> 사용자가 직접 못박은 7개 SOT(source of truth). **최상위 권위 badge `{✅ SOT}`** — 추정으로 SOT를 덮지 않는다. 가격 축의 모든 블록이 이 7개에 정합해야 한다.

### [PE-SOT-1] 상품마스터 11시트 = 상품군 그릇 = 허용 차원 경계  {✅ SOT}
- 내용: 상품마스터 11시트 각각이 한 상품군의 **그릇**이며, 그 시트 옵션(컬럼)이 그 상품이 **허용할 수 있는 차원의 경계(boundary)**다. 시트에 없는 차원은 그 상품 가격에 들어올 수 없다(예: 현수막 시트에 별색이 없으면 현수막 가격에 별색 구성요소를 합치면 오적재). 시트엔 이미 가격계산공식이 있어 상품군별 공식 형태(합산형/면적형/고정형)도 여기서 안다.
- 앵커: 상품마스터 11시트(원천) — 라이브 `t_prc_*` 배선이 이 경계 안에 있어야 함
- 출처: `huni-price-engine-diag/01_mechanism/sot-definitions.md §SOT 1` {tier A, FRESH·사용자SOT}
- 연결: [[#PE-SOT-4]] (제약 부재가 이 경계를 강제 못함) · [[#PE-001]] (엔진은 경계를 모름)
- 사용처: _(레시피 집필 시 채움 — 각 family 차원 경계 근거)_
- answers_cq: CQ-PRICE-11 (상품군이 허용하는 차원의 출처)
- tags: #SOT #그릇경계 #상품마스터 #허용차원

### [PE-SOT-2] 가격구성요소 = 가격표 차원 추출 → 결합형 vs 독립형  {✅ SOT}
- 내용: 가격구성요소는 인쇄상품 가격표에서 **차원을 추출**해 만든다. 같은 가격테이블 내에서 **차원을 공유하면 통합(결합형)**, 차원이 독립이면 **별도 구성요소(독립형)**. 결합형 예=디지털인쇄비(국4절 1도/4도 + 3절, 판형·도수·수량 차원 공유 → `COMP_PRINT_DIGITAL_S1/S2`). 독립형 예=별색은 국4절에만 존재(3절엔 없음) → 인쇄비와 분리한 "별색인쇄비"(`COMP_PRINT_SPOT_*`)로 두고 그 안에서 화이트/핑크/은/금/클리어를 색 차원으로 결합. **판별 기준 = "차원을 공유해 한 룩업 행집합으로 표현 가능한가"**(가능=결합 / 불가=독립).
- 앵커: `t_prc_price_components` (결합=한 comp의 use_dims 다차원 / 독립=별 comp)
- 출처: `sot-definitions.md §SOT 2` + `01_mechanism/device-roles.md §2a` {tier A, FRESH·사용자SOT}
- 연결: [[#PE-SOT-3]] (10차원) · [[processes#PRC-003]] (별색=공정·독립형 별색인쇄비) · [[#PE-005]]
- 사용처: [[recipes/digital-print#DGP-PR-001]] (uses — 결합형 디지털인쇄비)
- answers_cq: CQ-PRICE-12 (구성요소를 왜 합치고 쪼개나)
- tags: #SOT #결합형 #독립형 #차원공유

### [PE-SOT-3] 가격구성요소 차원 = 10차원 (clr_cd 폐기)  {✅ SOT}
- 내용: 전체 가격표 조사 결과 가격구성요소의 차원은 **10개** — ① 판형사이즈 `plt_siz_cd` ② 사이즈 `siz_cd` ③ 인쇄옵션 `print_opt_cd`(=도수) ④ 묶음수 `bdl_qty` ⑤ 자재 `mat_cd` ⑥ 공정 `proc_cd`(+`dim_vals` 상세) ⑦ 옵션코드 `opt_cd` ⑧ 코팅면수 `coat_side_cnt` ⑨ 사이즈가로구간 `siz_width` ⑩ 사이즈세로구간 `siz_height`. **수량(`min_qty`)은 10차원에 없음 = 상품요소 차원이 아니라 주문 입력 축**(엔진은 min_qty도 티어로 쓰나 SOT의 "차원" 개념과 양립). **★`clr_cd`는 10차원에 없음 → 도수=`print_opt_cd`, clr_cd 폐기를 SOT가 추인.**
- 앵커: `t_prc_component_prices`(차원 컬럼) · `t_prc_price_components.use_dims`(jsonb 차원 선언)
- 출처: `sot-definitions.md §SOT 3`(라이브 충전 대조표) + `02_code_schema/code-schema-matrix.md` {tier A, FRESH·사용자SOT+코드근거+데이터}
- 연결: [[#PE-001]] · [[#PE-002]] · [[#PE-GAP-6]] (clr_cd 폐기 의도 문서 충돌)
- 사용처: [[recipes/sticker#STK-PRC-002]] (가격 차원 컬럼 = 라이브 실측 권위·10차원) · [[recipes/acrylic#AC-PRC-002]] (uses — 가격 차원 t_prc_*)
- answers_cq: CQ-PRICE-13 (가격구성요소 차원 개수·도수 컬럼)
- tags: #SOT #10차원 #clr_cd폐기 #print_opt_cd

### [PE-SOT-4] 제약장치 부재 = 오적재 근본  {✅ SOT}
- 내용: 가격구성요소를 공식에 묶을 때 "이 구성요소가 **이 상품에서 사용 가능한가**(SOT 1 허용 차원 안인가)"를 검사하는 **제약 장치가 없다.** `t_prc_formula_components`(배선)에 **`prd_cd` 컬럼 부재**(frm_cd·comp_cd·disp_seq·addtn_yn·reg_dt·upd_dt만, 상품 참조 FK 0개) → 시트 밖 차원의 구성요소(현수막의 별색)가 잘못 묶여도 막을 수단 없음. 이것이 이중합산(D-1/2/3)·현수막별색(D-6) 오적재의 **단일 병인**. 엔진 무차별 합산(C7)은 증상, 제약 부재가 병인. **CPQ 옵션 제약(`t_prd_product_constraints`·JSONLogic·round-6)과 별개** — 그건 UI 옵션 선택 조합 제약이고, SOT 4는 공식↔구성요소 **배선 레벨** 제약(가격 그릇 경계). 후자는 라이브 부재(가격 6엔티티 유효성 트리거 0건).
- 앵커: `t_prc_formula_components`(prd_cd 부재) · 부재 — 신규 설계 필요
- 출처: `02_code_schema/constraint-mechanism-gap.md`(라이브 information_schema·FK·트리거·CHECK 전수) + `sot-definitions.md §SOT 4` {tier A, FRESH·사용자SOT+코드근거}
- 연결: [[#PE-SOT-1]] · [[cpq-options#CPQ-003]] (CPQ fn_chk_opt_item_ref = 옵션 전용·가격 미복제) · [[#PE-GAP-9]]
- 사용처: [[recipes/silsa#SL-PRC-001]] (현수막 별색 오적재 위험 근본) · [[recipes/acrylic#AC-PRC-002]] (배선 검증 장치 부재)
- answers_cq: CQ-PRICE-14 (오적재가 왜 일어나나)
- tags: #SOT #제약부재 #오적재근본 #배선

### [PE-SOT-5] 가격소스 우선순위 = 템플릿단가>직접단가>공식>없음  {✅ SOT}
- 내용: 가격소스 우선순위(타깃별 base 산출) = **템플릿단가(`t_prd_template_prices`) → 상품 직접단가(`t_prd_product_prices`) → 상품공식(FORMULA) → 없음(NONE)** (pricing.py:13-14, 285-328). 직접단가가 1행이라도 있으면 공식을 타지 않는다(오버라이드). **직접단가 = `(적용일, 단가)` 한 쌍의 평면 행(차원·수량 무관) — 공식으로 표현 못 하는 "완제품 고정가" 오버라이드용 예비 그릇**(가설 A·확신도 높음). **라이브 실측: 직접단가 0행·템플릿단가 0행·공식 바인딩 76행 → 현재 전 상품이 FORMULA 단일 경로**. 직접단가/템플릿단가는 죽은 코드가 아니라 "코드 살아있고 데이터 0"인 잠재 경로.
- 앵커: pricing.py:285-328 · `t_prd_product_prices`(0행) · `t_prd_template_prices`(0행) · `t_prd_product_price_formulas`(76행)
- 출처: `02_code_schema/price-source-intent.md`(3-way·가설 A/B/C) + `huni-price-quote/01_engine/engine-contract.md §1`(P1-1~3) {tier A, FRESH·코드근거+라이브실측}
- 연결: [[#PE-004]] (template_prices) · [[#PE-007]] (직접단가=고정가 오버라이드)
- 사용처: [[recipes/product-accessory#PA-PRC-001]] (uses — OTC 부자재 SKU 직접단가 경로 후보·라이브 0행) · [[recipes/calendar#CAL-DC-001]] (디자인캘린더 고정가 직접단가 후보)
- answers_cq: CQ-PRICE-15 (직접단가와 공식을 왜 둘 다 두나)
- tags: #SOT #가격소스우선순위 #직접단가 #오버라이드

### [PE-SOT-6] 수량×단가 = 두 갈래 (완제SKU 재귀 / 부자재 10차원 흡수)  {✅ SOT}
- 내용: 수량×단가 요소(상품악세사리·부자재·추가상품)는 **두 갈래로 갈린다** — **(a) 추가상품(addon) = 별도 SKU 재귀평가 장치**(`t_prd_product_addons` 가격없음 5행 → `t_prd_templates` base_prd_cd+dflt_qty 13행 → 시뮬레이터가 **개별 `evaluate_price` 호출**로 고정수량 SKU 견적해 grand_total 합산. 메인 10차원 사슬 **밖**. SKU 단가 그릇=`t_prd_template_prices` 0행). **(b) 부자재/악세사리(옵션 환원형) = 10차원 ⑤자재·⑥공정 + 수량축으로 흡수**(option_items에 `add_price` 컬럼 부재 → 옵션=가격없음·자재/공정 BUNDLE 환원·SOT 3a → 부자재 가격은 mat_cd/proc_cd 단가행이 책임). **★가격구성요소에 "수량×단가" 전용 차원을 새로 넣을 필요 없음.** 단 (b)의 "수량"이 주문수량/BOM소요량/출력매수 중 무엇인지 축 미해소([PE-GAP-8]).
- 앵커: `t_prd_product_addons`(5) · `t_prd_templates`(13) · `t_prd_template_prices`(0) · `t_prd_product_option_items`(477·add_price 없음)
- 출처: `sot-definitions.md §SOT 6`(라이브 실측 판정) + `device-roles.md §⑤·§SOT 6` + `engine-contract.md §8`(P8-3 addon 개별평가) {tier A, FRESH·사용자SOT+라이브실측}
- 연결: [[#PE-004]] (SKU 직접단가 그릇) · [[#PE-SOT-3]] (부자재=10차원 흡수) · [[#PE-GAP-8]]
- 사용처: [[recipes/product-accessory#PA-PRC-001]] (priced-by — 부자재 variant별 고정가) · [[cpq-options#CPQ-005]] (옵션=BUNDLE·가격 없음)
- answers_cq: CQ-PRICE-16 (추가상품·부자재 가격을 어떻게 관리하나)
- tags: #SOT #수량단가 #추가상품 #부자재 #SKU재귀

### [PE-SOT-7] 옵션·추가상품은 가격장치가 아니다 (옵션=BUNDLE)  {✅ SOT}
- 내용: 옵션그릇은 **UI 선택용** — 사용자 선택을 받아 그 선택이 생산에 어떤 자재·공정을 쓰는지 알기 위해 자재/공정/자재+공정 형태로 투입(BUNDLE). **옵션 자체는 가격을 갖지 않는다**(라이브 `t_prd_product_option_items`에 `add_price` 컬럼 부재). 가격은 항상 그 환원된 자재/공정 차원으로 **구성요소 사슬**이 책임. → `opt_cd` 단가행 5행(near-dead)은 "CPQ→가격 단절 결함"이 아니라 **설계 정합**(옵션은 보통 가격축이 아니라 자재/공정 환원축; opt_cd 직접 가격=린넨 마감 예외). **★round-7 "CPQ→가격 단절 결함"·"opt_cd near-dead 결함" 판정은 정정됨**(결함 아님).
- 앵커: `t_prd_product_option_items`(add_price 없음·BUNDLE) · `opt_cd` 단가행 5행(예외)
- 출처: `sot-definitions.md §SOT 3a` + `device-roles.md §⑤ 0′` {tier A, FRESH·사용자SOT+라이브실측}
- 연결: [[cpq-options#CPQ-005]] (옵션=자재+공정 BUNDLE) · [[#PE-SOT-6]] (부자재 10차원 흡수) · [[processes]]·[[materials]]
- 사용처: [[recipes/sticker#STK-CPQ-001]] (옵션=BUNDLE·가격 사슬은 구성요소) · [[recipes/goods-pouch#GP-CPQ-001]] (옵션→자재/공정 환원)
- answers_cq: CQ-PRICE-17 (옵션이 가격을 갖나)
- tags: #SOT #옵션BUNDLE #가격장치아님 #설계정합

---

## 1. 5개 가격 장치 (라이브 권위·pricing.py)

> 가격엔진은 5개 장치로 구성. 단일 권위 알고리즘 `evaluate_price`(⑤ 시뮬레이터가 그대로 호출)에 ①②③이 데이터 공급, ④는 읽기, ⑤가 실행·검증.

### [PE-DEV-1] ① 가격공식 = 값 없는 레시피 헤더 (구성요소 묶음)  {✅}
- 내용: `t_prc_price_formulas`는 **레시피 헤더** — 어느 구성요소들을 묶을지의 이름표일 뿐 **계산식·연산자·값을 갖지 않는다**(곱/나눗셈/조건분기 없음·합산은 엔진이 함). 상품→공식은 바인딩 `t_prd_product_price_formulas`(시계열 `apply_bgn_ymd` 최신 1건). **`frm_typ_cd`(합산형/단순형 유형 구분)는 폐기 — 엔진 미참조**(공식은 항상 구성요소 합산). 라이브: 공식 48행·바인딩 76행.
- 앵커: `t_prc_price_formulas` + 바인딩 `t_prd_product_price_formulas`(PK = prd_cd, apply_bgn_ymd)
- 출처: `device-roles.md §①` + `engine-contract.md §2`(P2-1·C7) — pricing.py:8,320-327,444-475 {tier A, FRESH·코드근거}
- 연결: [[#PE-DEV-2]] · [[#PE-003]] (멱등 PK) · [[#PE-001]]
- 사용처: [[recipes/digital-print#DGP-PR-001]] (priced-by — PRF_DGP_A~F 헤더) · [[recipes/silsa#SL-PRC-001]] (priced-by — PRF_POSTER_*)
- answers_cq: CQ-PRICE-01 (단가표 vs 공식 계산) · CQ-PRICE-08 (견적 합산 공식)
- tags: #장치 #가격공식 #레시피헤더 #frm_typ폐기

### [PE-DEV-2] ② 가격구성요소 = 차원 책임 + 단가 룩업 (3테이블 1세트)  {✅}
- 내용: ②는 사실 **3테이블 한 세트** — 마스터 `t_prc_price_components`(원자 비용 항목 정의·`use_dims`·`prc_typ_cd`, **단가값·차원값 없음**) + 배선 `t_prc_formula_components`(공식↔구성요소 묶음·disp_seq·addtn_yn) + 단가행 `t_prc_component_prices`(차원조합별 **실제 단가값** 다차원 룩업·**7,293행**). 차원 책임은 전부 구성요소+단가행이 짊어진다(공식은 묶음만). 동일 차원조합·구간·적용일 행이 2개 이상이면 데이터 오류(흡수 안 함).
- 앵커: `t_prc_price_components`(146) · `t_prc_formula_components`(301) · `t_prc_component_prices`(7,293)
- 출처: `device-roles.md §② 2a/2b/2c`(pricing.py:401-405,450-457,118-174) + `known-vs-unknown.md K-3` {tier A, FRESH·코드근거+데이터}
- 연결: [[#PE-DEV-1]] · [[#PE-SOT-2]] (결합/독립) · [[#PE-SOT-3]] (10차원) · [[#PE-001]]
- 사용처: [[recipes/sticker#STK-PRC-001]] (priced-by — 단가행 룩업) · [[recipes/silsa#SL-PRC-001]] (priced-by — 면적 단가행)
- answers_cq: CQ-PRICE-02 (구성요소 3테이블 역할)
- tags: #장치 #구성요소 #단가행 #7293행

### [PE-DEV-3] ③ 할인테이블 = base 후처리 순차곱  {✅}
- 내용: `t_dsc_discount_tables`(수량구간) + `t_dsc_grade_discount_rates`(등급)는 가격 "구성"이 아니라 base 산출 후의 **후처리(곱·차감)**. 흐름 = base → 수량구간 할인 → 등급 할인 **순차 곱(차감)** → ROUND_HALF_UP. 정률 `after=금액×(1−rate/100)`·정액 `after=금액−amt`(음수는 0 가드). 할인유형(정률/정액)은 **할인테이블 마스터 단위**(dsc_typ_cd·디테일 행 단위 아님). 라이브: 할인테이블 7·디테일 35·상품연결 102·**등급할인율 0행(미발화)**.
- 앵커: `t_dsc_discount_tables`·`t_dsc_discount_details`·`t_dsc_grade_discount_rates`(0행)
- 출처: `device-roles.md §③`(pricing.py:24,356-368,478-537) + `engine-contract.md §6`(P6-1~4·C9) {tier A, FRESH·코드근거+데이터}
- 연결: [[#PE-008]] (구간형) · [[load-path#LP-001]] (loaded-via)
- 사용처: [[recipes/acrylic#AC-PRC-001]] (priced-by — 카테고리 수량구간 할인) · [[recipes/goods-pouch#GP-PRC-002]] (priced-by — 굿즈 구간할인)
- answers_cq: CQ-PRICE-04 (수량 구간별 할인 체계)
- tags: #장치 #할인 #순차곱 #등급할인0행

### [PE-DEV-4] ④ 가격뷰어 = 읽기 (계산 안 함)  {✅}
- 내용: `price_viewer`·`price_diagram`은 적재된 가격구조를 **사람이 확인하는 읽기 UI** — 계산을 하지 않는다. 뷰어=카테고리→상품 트리 + 가격소스 배지(PRC/FRM/NONE), 다이어그램=한 상품의 현재 공식→구성요소→단가표를 mermaid 스냅샷(오늘 이하 최신 1건). **수량·선택값에 따른 실제 견적은 안 냄**("무엇이 적재됐나"만·"얼마인가"는 ⑤). 부속 진단 뷰: `price_dup_check`(중복 단가행)·`price_comp_usage`(구성요소 사용처).
- 앵커: `price_viewer`·`price_diagram`(price_views.py:212-518)
- 출처: `device-roles.md §④`(price_views.py:177-184,388-487,767-786) {tier A, FRESH·코드근거}
- 연결: [[#PE-DEV-5]] · [[#PE-DEV-2]]
- 사용처: _(읽기 도구 — 레시피 적재 확인 시 참조)_
- answers_cq: CQ-PRICE-18 (가격뷰어 역할)
- tags: #장치 #가격뷰어 #읽기전용 #다이어그램

### [PE-DEV-5] ⑤ 가격시뮬레이터 = evaluate_price 단일 알고리즘  {✅}
- 내용: `price_simulator`/`price_simulate`는 선택값+수량을 입력하면 실제 견적을 산출하는 실행·검증 도구. **위젯/주문 재검증과 동일한 `evaluate_price`를 그대로 호출**(자기 계산 로직 없음·전부 위임). 입력=target(prd_cd|tmpl_cd)+selections+qty+grade_cd+mode(lenient/strict)+procs+addons. lenient=데이터 구멍 발견(0원 스킵+경고·시뮬레이터 기본)·strict=계산불가 차단(실서비스 위젯/주문). **★메모리 `huni-price-quote-harness`의 "evaluate_price 미구현(round-18)"은 STALE — 현재 라이브 구현·호출 가능**(gate-verdict P1 입증: 라이브 Railway DB에 부트스트랩 직접 호출 성공).
- 앵커: `price_simulate`→`evaluate_price`(pricing.py:247) — 위젯 가격계약 원형
- 출처: `device-roles.md §⑤`(price_views.py:1270-1328) + `engine-contract.md §0`(시그니처) + `gate-verdict.md P1` {tier A, FRESH·코드근거}
- 연결: [[#PE-001]] · [[widget-contract#WID-005]] (위젯=strict 재검증·서버 가격권위) · [[#PE-DEV-4]]
- 사용처: [[recipes/digital-print#DGP-WID-001]] (mapped-to — 시뮬레이터=위젯 가격계약 원형) · [[recipes/product-accessory#PA-WID-002]] (가격 권위=서버 evaluate_price)
- answers_cq: CQ-PRICE-19 (시뮬레이터·위젯·주문 동일 알고리즘인가)
- tags: #장치 #시뮬레이터 #evaluate_price #단일알고리즘 #미구현STALE정정

---

## 2. 엔진 거동 (evaluate_price 계약·라이브 권위)

### [PE-001] t_prc_* 4단 구조 + 10차원 자동매칭  {✅}
- 내용: 가격은 단가표가 아니라 **공식 엔진** — `t_prc_*` 4단(공식 → 배선 → 구성요소 → 단가행)으로 전개. 엔진은 호출자가 구성요소 목록을 넘기지 않아도 각 구성요소를 selections와 **차원 자동매칭**한다(매칭행 있으면 포함·없으면 자연 제외). 차원 = **10차원**: 비수량 정확매칭 `NON_QTY_DIMS` 8(siz_cd·plt_siz_cd·print_opt_cd·mat_cd·proc_cd·opt_cd·coat_side_cnt·bdl_qty·NULL=와일드카드) + 티어 `siz_width`/`siz_height`('이하' 상한·off-grid ceiling). 수량 `min_qty`는 티어('이상' 하한)이나 SOT 10차원엔 미포함(주문 입력 축). `dim_vals`(공정 상세·`{"개수":N}`)는 와일드카드 없는 정확매칭. **[W3] `pricing_dims`·`use_dims`는 라이브 테이블 아님**(seed/init 스크립트·차원의 라이브 실재 위치 = `t_prc_component_prices` 컬럼 + `t_prc_price_components.use_dims` jsonb).
- 앵커: `t_prc_*` 4단 · `NON_QTY_DIMS`(pricing.py:38-39) · `TIER_DIMS`(pricing.py:45-46)
- 출처: `engine-contract.md §3`(P3-1~9) + `02_code_schema/code-schema-matrix.md` + `device-roles.md §2c` — pricing.py:38-46,78-174 {tier A, FRESH·코드근거}
- 연결: [[#PE-SOT-3]] (10차원 정의) · [[#PE-DEV-2]] · [[#PE-006]] (ceiling) · [[load-path#LP-002]] (loaded-via)
- 사용처: [[recipes/sticker#STK-PRC-002]] (uses — 가격 차원 컬럼) · [[recipes/acrylic#AC-PRC-002]] (uses — 가격 차원 t_prc_*) · [[recipes/goods-pouch#GP-PRC-001]] (uses — t_prc_* 4단) · [[recipes/calendar#CAL-PRC-001]] (uses — 캘린더 t_prc 4단·미연결)
- answers_cq: CQ-PRICE-01 · CQ-PRICE-08
- tags: #가격 #t_prc #10차원 #자동매칭 #W3

### [PE-002] 단가유형 prc_typ_cd (.01 단가형 / .02 합가형)  {✅}
- 내용: 구성요소는 `prc_typ_cd`로 단가 환산이 갈린다. **`.01 단가형`(`unit_price`=장당가 → `subtotal = unit_price × qty`)** / **`.02 합가형`(`unit_price`=구간 총액 → `per_item = unit_price ÷ tier_min_qty`, `× qty`)**. prc_typ NULL/미지정이면 단가형 기본. **라이브 분포: 단가형 143 / 합가형 3**(`COMP_ACRYL_CLEAR3T`·`COMP_STK_PACK`·`COMP_STK_TATTOO`). **★합가형 위험지점(C3): `tier_min_qty`가 0/NULL이면 `÷0` → `ValueError`(견적 자체가 깨짐)** — strict 치명. `COMP_ACRYL_CLEAR3T`는 165행 전부 min_qty=1(÷1·골든 불변)이라 현재 안전. **[정정] 기존 블록의 "144행 전부 .01"은 STALE — 합가형 3건 확정.**
- 앵커: `t_prc_price_components.prc_typ_cd`(PRICE_TYPE.01/.02) · `component_subtotal`(pricing.py:177-192)
- 출처: `device-roles.md §② prc_typ`(pricing.py:48-49,185-192) + `engine-contract.md §4`(P4-1~3·C3) {tier A, FRESH·코드근거+데이터}
- 연결: [[#PE-001]] · [[#PE-GAP-1]] (합가형 전수 식별)
- 사용처: [[recipes/acrylic#AC-PRC-001]] (uses — CLEAR3T 합가형·min_qty=1) · [[recipes/sticker#STK-PRC-001]] (uses — STK_PACK/TATTOO 합가형)
- answers_cq: CQ-PRICE-20 (단가형과 합가형 차이)
- tags: #가격 #단가유형 #prc_typ_cd #합가형 #ValueError위험

### [PE-003] 가격공식 바인딩 PK = (prd_cd, apply_bgn_ymd)  {✅}
- 내용: 상품↔공식 바인딩 `t_prd_product_price_formulas`의 멱등 키 = **(prd_cd, apply_bgn_ymd)**. 시계열 — `apply_bgn_ymd ≤ as_of` 중 최신 1건이 현재 유효 공식. 구 PK(frm_cd/dsc_tbl_cd 포함) 가정한 ON CONFLICT는 충돌하므로 적재 SQL 갱신 필요([[load-path#LP-005]]).
- 앵커: `t_prd_product_price_formulas` PK (prd_cd, apply_bgn_ymd)
- 출처: `raw/webadmin/sql/18_unify_price_keys.sql`(impact-diagnosis I-7) + `engine-contract.md §5`(P5-2) {tier A, FRESH}
- 연결: [[load-path#LP-005]] · [[#PE-DEV-1]]
- 사용처: [[recipes/acrylic#AC-PRC-002]] (uses — 멱등 PK) · [[recipes/goods-pouch#GP-PRC-001]] (uses — 멱등 가격 PK) · [[recipes/silsa#SL-PRC-002]] (가격 = 면적+고정가 2 모델)
- answers_cq: CQ-PRICE-21 (가격공식 멱등 키)
- tags: #가격 #PK #멱등 #I-7 #시계열

### [PE-004] template 직접단가 (t_prd_template_prices)  {🔴 0행}
- 내용: SKU(템플릿) 직접단가 오버라이드 경로 + 추가상품(addon) SKU 단가 그릇. **현재 0행(스키마만 존재)** — addon 5건은 현재 base_prd_cd 공식사슬로 평가(SKU 직접단가 미적재). 가격소스 우선순위 1순위([PE-SOT-5]). SKU별 고정가가 필요한 상품의 가격 오버라이드 자리(가설: 완제품 고정가·YAGNI 아님·미적재).
- 앵커: `t_prd_template_prices`(0행) · 우선순위 1순위
- 출처: `raw/webadmin/sql/20_template_prices.sql`(impact-diagnosis I-4) + `price-source-intent.md` + `engine-contract.md §1`(순위1) {tier A, FRESH(스키마만)}
- 연결: [[cpq-options#CPQ-006]] (templates) · [[#PE-SOT-5]] · [[#PE-SOT-6]] (addon SKU) · [[#PE-GAP-3]]
- 사용처: [[recipes/product-accessory#PA-PRC-001]] (uses — OTC 부자재 SKU 직접단가 경로 후보·라이브 0행)
- answers_cq: CQ-PRICE-22 (SKU 직접단가 그릇)
- tags: #가격 #template_prices #SKU #0행

---

## 3. 공식 유형 (후니 권위)

### [PE-005] 원자합산형 (디지털인쇄) PRF_DGP_A~F + 용지비  {🟡}
- 내용: 디지털인쇄 가격 = **원자 구성요소 합산**(인쇄비 + 용지비 + 공정비). 공식 6종 `PRF_DGP_A~F` + 용지비 `COMP_PAPER`. 라이브 308행 COMMIT(공식사슬 완결). 별색=공정([[processes#PRC-003]])이 독립형 별색인쇄비로 합산 항목에 들어옴([PE-SOT-2]). **★검증 주의(N-1·[PE-GAP-7]): 합산형(엽서) 가격사슬은 골든과 미정합** — 엽서 인쇄비 골든 20,000 ≠ 라이브 11,750(gate-verdict P2 FAIL). 면적매트릭스는 완전 재현·합산형은 검증 미완.
- 앵커: `t_prc_price_formulas`(PRF_DGP_A~F) + COMP_PAPER
- 출처: `huni-dbmap/02_mapping/digital-print-engine/` + `engine-contract.md §9`(엽서 경로) + `gate-verdict.md P2` {tier C·공식사슬 FRESH / 차원 PARTIAL-STALE I-1·I-2}
- 연결: [[#PE-SOT-2]] (결합/독립) · [[processes#PRC-003]] (uses — 별색=공정) · [[../base/paper#BPP-002]] · [[#PE-GAP-7]]
- 사용처: [[recipes/digital-print#DGP-PR-001]] (priced-by — 원자합산형) · [[recipes/booklet#BK-PRC-001]] (priced-by — 제본 합산형 PRF_BIND_SUM) · [[recipes/photobook#PB-PRC-001]] (priced-by — page-band 합산형·미적재) · [[recipes/calendar#CAL-PRC-001]] (priced-by — 캘린더 원자합산형·미적재)
- answers_cq: CQ-PRICE-03 · CQ-PRICE-06
- tags: #가격 #합산형 #디지털인쇄 #PRF_DGP #검증미완

### [PE-006] 면적매트릭스형 (실사·현수막·아크릴·포스터사인)  {✅}
- 내용: **[가로][세로] 면적 매트릭스 + off-grid ceiling**(siz_width/siz_height '이하' 상한·격자에 없는 크기는 한 단계 큰 구간 = 주문값 이상 임계 중 최소). 최대 임계 초과면 `ERR_ABOVE_MAX`(strict여도 비치명·0원 제외). 실사 가격은 자체 inline price가 아니라 **포스터사인 가격표 면적매트릭스** 권위([PE-STALE]의 좌표 회귀 모델 인용 금지). **★검증 GO: 골든 4앵커 오차 0 재현**(실사 1000×1000=20,000·off-grid 600×900=20,000·아크릴 3T=3,100·1.5T=2,480·×0.8 두께축 직교)(gate-verdict P2 PASS).
- 앵커: `t_prc_component_prices`(siz_width/siz_height) + ceiling(pricing.py:149-155)
- 출처: `huni-dbmap/02_mapping/silsa-poster-area-matrix/` + `engine-contract.md §3.2/§9`(P3-4·P3-5) + `gate-verdict.md P2`·`02_authority/golden-cases.md` {tier A/C, FRESH}
- 연결: [[../base/sizes#BSZ-003]] · [[#PE-001]] (티어 매칭) · [[#PE-STALE]]
- 사용처: [[recipes/acrylic#AC-PRC-001]] (priced-by — 아크릴 면적매트릭스·미러=투명×2) · [[recipes/silsa#SL-PRC-001]] (priced-by — 실사 포스터사인 [가로×세로]·inline 금지) · [[recipes/goods-pouch#GP-PRC-001]] (비대상 — 굿즈=고정가형)
- answers_cq: CQ-PRICE-05 (면적 기반 가로×세로 계산)
- tags: #가격 #면적매트릭스 #ceiling #포스터사인 #검증GO

### [PE-007] 고정가형 (수량×옵션)  {🟡}
- 내용: **수량×옵션 격자의 고정 단가** 룩업. round-2가 28 포스터를 전부 면적-좌표 회귀로 오모델 → 그중 **15개는 고정가형**이 정답(교정분 `_migrate_fixedprice/` 권위). 완제품 고정가는 [PE-SOT-5] 직접단가 오버라이드 경로(현재 0행)로도 표현 가능.
- 앵커: `t_prc_component_prices`(수량×옵션 고정가)
- 출처: `huni-dbmap/09_load/_migrate_fixedprice/` + `02_mapping/price211-fixedgrid/` {tier C, FRESH}
- 연결: [[#PE-006]] · [[#PE-SOT-5]] (직접단가) · [[#PE-STALE]]
- 사용처: [[recipes/booklet#BK-PRC-002]] (책자 떡제본 고정가) · [[recipes/sticker#STK-PRC-001]] (priced-by — 형상×치수×코팅 격자) · [[recipes/calendar#CAL-DC-001]] (priced-by — 디자인캘린더 고정가 4000~24000) · [[recipes/calendar#CAL-PRC-002]] (캘린더가공 옵션 추가가 격자) · [[recipes/product-accessory#PA-PRC-001]] (priced-by — 부자재 variant별 고정가) · [[recipes/stationery#ST-PRC-001]] (priced-by — 문구 C29 inline 고정가·미적재) · [[recipes/stationery#ST-PRC-002]] (priced-by — 떡메모지 묶음수×size 매트릭스) · [[recipes/silsa#SL-PRC-002]] (priced-by — 실사 고정가형 16상품) · [[recipes/goods-pouch#GP-PRC-001]] (priced-by — 굿즈 고정가형 수량×옵션) · [[recipes/photobook#PB-PRC-002]] (가격 ≠ PRF_PCB_FIXED)
- tags: #가격 #고정가형 #포스터교정

### [PE-008] 구간형 (수량구간 할인) t_dsc_*  {✅}
- 내용: 수량 구간별 할인율(round-1). 상품→`t_prd_product_discount_tables` 최신 연결→`t_dsc_discount_tables`(유형)→`t_dsc_discount_details`(min_qty ≤ qty ≤ max_qty(또는 max NULL)·최신). base 후처리(곱/차감)·base≤0이면 스킵. 아크릴/굿즈파우치/문구 카테고리 단위 적용. **현재 발화하는 두 경로 중 하나**(나머지=FORMULA·[PE-DEV-3]).
- 앵커: `t_dsc_discount_tables`·`t_dsc_discount_details`·연결 `t_prd_product_discount_tables`
- 출처: `00_schema/discount-domain-detail.md` + `raw/webadmin/tools/load_discounts.py` + `engine-contract.md §6`(P6-1) {tier A/C, PARTIAL-STALE: I-7 PK}
- 연결: [[#PE-DEV-3]] · [[load-path#LP-001]] (loaded-via) · 메모리 `dbmap-discount-authority`
- 사용처: [[recipes/digital-print#DGP-PR-003]] (비대상 — 디지털인쇄는 구간형 아님) · [[recipes/acrylic#AC-PRC-001]] (priced-by — 아크릴 카테고리 수량구간 할인) · [[recipes/stationery#ST-PRC-003]] (priced-by — 문구 카테고리 수량구간 할인) · [[recipes/silsa#SL-PRC-002]] (priced-by — 실사 수량구간 할인 t_dsc_*) · [[recipes/goods-pouch#GP-PRC-002]] (priced-by — 굿즈A/B타입 구간할인)
- answers_cq: CQ-PRICE-04
- tags: #가격 #구간할인 #t_dsc #후처리

### [PE-009] 상품별 공식 PRF_<X> (가격사슬 단절 해소)  {🟡}
- 내용: 상품→comp 직결경로 부재 시 가격사슬 단절. 공유공식 + 상품별 택일 comp가 끊기면 **상품별 1:1 공식 `PRF_<X>`**로 해소. broken 4 = 포스터28/제본/명함/포토카드. **★근본 = 제약장치 부재([PE-SOT-4])** — 공유 comp가 상품 경계 검사 없이 묶이는 구조가 단절·오묶임을 함께 낳음.
- 앵커: `t_prc_price_formulas`(PRF_<X> 상품별)
- 출처: `huni-dbmap/02_mapping/dwire-poster-formula-remodel/`·`dwire-bind-namecard-photocard-remodel/` + 메모리 `dbmap-price-chain-dwire-per-product-formula` {tier C, FRESH}
- 연결: [[#PE-005]] · [[#PE-007]] · [[#PE-SOT-4]]
- 사용처: [[recipes/booklet#BK-PRC-003]] (레더 링바인더 가격 BLOCKED)
- tags: #가격 #상품별공식 #가격사슬 #broken4

---

## 4. 앱 계산 경계 (DB 미저장)

### [PE-010] 판수(판걸이수)·박 등급 = 앱 계산  {🟡}
- 내용: **판수(판걸이수)는 임포지션/네스팅 런타임 계산**(DB 미저장 — 입력=판형 인쇄가능영역 + 작업사이즈). **박 면적→등급도 앱 계산**(DB는 등급별 가격만 저장). off-grid ceiling과 동일 철학. 스키마에 없다고 GAP이 아니라 "앱 계산". **★주의(N-1 연결·[PE-GAP-8]): 엔진엔 판걸이수→출력매수 변환이 없다**(pricing.py grep 0건·엔진은 qty 직접 티어 사용) → 수량×단가의 "수량" 축이 출력매수인지 주문수량인지 미해소.
- 앵커: (DB 외 — 앱 계산) · 입력 = `t_prd_product_plate_sizes` + 작업사이즈
- 출처: 메모리 `dbmap-compute-in-app-db-stores-lookup`·`pangeori-l1.csv` + `gate-verdict.md P2`(임포지션 변환 부재) {tier B/C, FRESH}
- 연결: [[../base/prepress-file#BPF-002]] · [[#PE-006]] (ceiling) · [[#PE-GAP-8]]
- 사용처: [[recipes/digital-print#DGP-PR-001]] (uses — 판수=앱 계산) · [[recipes/sticker#STK-DIM-002]] (uses — 스티커 판수=앱) · [[recipes/acrylic#AC-DIM-003]] (uses — UV 평판 판걸이수=앱) · [[recipes/booklet#BK-BOM-003]] (박 크기→등급=앱) · [[recipes/photobook#PB-DIM-003]] (책등 두께=앱) · [[recipes/silsa#SL-PRC-001]] (포스터사인 면적매트릭스)
- answers_cq: CQ-PRICE-10 (판걸이수가 가격에 미치는 영향)
- tags: #앱계산 #판수 #판걸이수 #박등급

---

## 5. STALE 함정 (인용 금지)

### [PE-STALE] price-engine-ddl.md 전체 = STALE (인용 금지)  {🔴 STALE}
- 내용: `00_schema/price-engine-ddl.md`(C-PRICEENG)는 **인용 금지**. 사유: ① "6차원/8컬럼 자연키" → 사실 10차원(I-1) ② 단가형/합가형 개념 전무(I-2) ③ template_prices 누락(I-4) ④ 구 PK(I-7). **대체: 라이브 information_schema + `pricing.py` 직접**([PE-001~004]·[PE-DEV-*]). 추가 함정: 단가형 가정(합가형 오매핑 위험 I-2)·round-2 포스터 면적-좌표 오모델(교정분 권위).
- 출처: `18_schema-change/impact-diagnosis.md` I-1·I-2·I-4·I-7 {tier A, FRESH}
- 연결: [[#PE-001]] · [[#PE-006]] · [[#PE-007]] · [[#PE-STALE2]]
- 사용처: [[recipes/acrylic#AC-PRC-002]] (면적매트릭스 적재) · [[recipes/silsa#SL-PRC-001]] · [[recipes/silsa#SL-PRC-002]] · [[recipes/sticker#STK-PRC-002]] · [[recipes/booklet#sources]] (STALE 미인용 확인) · [[recipes/calendar#sources]] · [[recipes/goods-pouch#sources]] · [[recipes/photobook#sources]] · [[recipes/product-accessory#sources]] · [[recipes/stationery#sources]]
- tags: #STALE #price-engine-ddl #인용금지 #Phase11

### [PE-STALE2] prcx01-pricing-model.md · pricing-erd.md = STALE (델타 강등·인용 금지)  {🔴 STALE}
- 내용: **★권위 반전(2026-06-18)** — 기존 §정답소스가 FRESH로 등급했던 `raw/webadmin/docs/prcx01-pricing-model.md`·`pricing-erd.md`는 **STALE로 강등**. 사유(코드 추적 확정): ① 8차원(사실 10차원·proc_cd/opt_cd/print_opt_cd/plt_siz_cd/siz_w/h/dim_vals는 이후 추가) ② **`clr_cd`를 도수 차원으로 정의(엔진 NON_QTY_DIMS에 clr_cd 없음·매칭은 print_opt_cd)** ③ `frm_typ_cd`(공식유형·엔진 미참조·라이브 컬럼 부재). → **가격엔진 구조·차원·단가유형·도수 인용 금지.** **허용 = "왜 두 가지 가격소스(직접단가/공식)를 두나" 같은 의도 배경 only**([PE-SOT-5] 참조). 가격엔진 구조는 라이브 information_schema + `pricing.py` 직접.
- 출처: `02_code_schema/design-artifact-trace.md`(코드 추적) + `device-roles.md §discrepancy D-1~D-4` + `known-vs-unknown.md K-8` {tier A, FRESH}
- 연결: [[#PE-STALE]] · [[#PE-SOT-3]] (clr_cd 폐기) · [[#PE-SOT-5]] (허용=의도배경만) · [[#PE-GAP-6]]
- 사용처: _(전 레시피 — 가격 블록에서 prcx01/pricing-erd 구조·차원 인용 금지)_
- tags: #STALE #prcx01 #pricing-erd #권위반전 #clr_cd #frm_typ

---

## 6. GAP (미모델링·미결)

### [PE-GAP-1] 합가형(prc_typ_cd=.02) 상품 전수 식별 절차 부재  {🔴}
- 내용: 라이브 합가형 3 comp 확정(CLEAR3T·STK_PACK·STK_TATTOO·[PE-002]). 그러나 전수 식별 절차(어느 상품이 합가형 단가행을 쓰는가·min_qty NULL 행 점검)는 미신설. C3 ValueError 위험 잔존.
- 출처: `_curation/axis-price-engine.md` GAP-PE-1 + `engine-contract.md §4`(C3) {tier A}
- 연결: [[#PE-002]]
- tags: #GAP #합가형 #전수식별

### [PE-GAP-2] 평면화 차원집합 ↔ 라이브 use_dims 대조 절차 미신설 (I-3)  {🔴}
- 내용: 우리 평면화 차원집합과 라이브 `use_dims` 대조 절차 부재. **부분 해소**: `huni-price-quote/03_chain/dimension-mapping-matrix.md`가 파일럿 3상품군 3원 대조(P3 PASS). 전수는 잔존.
- 출처: `_curation/axis-price-engine.md` GAP-PE-2 + impact-diagnosis I-3 + `gate-verdict.md P3` {tier A}
- 연결: [[#PE-001]] · [[#PE-DEV-2]]
- tags: #GAP #use_dims #I-3

### [PE-GAP-3] 포토북·디자인캘린더·문구·부자재 가격 미적재 (prices 0행)  {🔴}
- 내용: 6상품군 가격사슬 부재. template_prices 0행([PE-004])·직접단가 0행([PE-SOT-5]).
- 출처: `_curation/axis-price-engine.md` GAP-PE-3 {tier C}
- 연결: [[#PE-004]] · [[#PE-SOT-5]]
- 사용처: [[recipes/photobook#PB-PRC-001]] · [[recipes/calendar#CAL-PRC-001]] · [[recipes/calendar#CAL-DC-001]] · [[recipes/product-accessory#PA-ST-003]] · [[recipes/stationery#ST-PRC-001]] · [[recipes/goods-pouch#GP-PRC-001]]
- tags: #GAP #가격미적재

### [PE-GAP-4] 박 가격 GAP · plate 교정 대기 차단 (3절/투명/048/019)  {🔴}
- 내용: 박 등급별 가격 GAP 잔존. 3절/투명/048/019 등 plate 교정 대기로 가격 차단.
- 출처: `_curation/axis-price-engine.md` GAP-PE-4·GAP-PE-5 + 메모리 `dbmap-digitalprint-atomic-formula-unbuilt` {tier C}
- 연결: [[#PE-010]] · [[load-path#LP-006]]
- 사용처: [[recipes/digital-print#DGP-PR-002]] (디지털인쇄 가격 차단 — 박·3절/투명/048/019)
- tags: #GAP #박 #plate교정

### [PE-GAP-6] 도수 clr_cd→print_opt_cd 폐기가 의도된 설계 변경인가 (U-1/C-1)  {🔴}
- 내용: 코드는 `print_opt_cd`로 도수 매칭, 설계문서(prcx01 LOCKED)는 `clr_cd`. SOT 3b가 clr_cd를 10차원에서 제외해 **폐기 의도 추인**하나, prcx01 LOCKED 문서와 형식 충돌(최종 의도 문서 부재). → **🔴 사용자/도메인 컨펌 필요**(가격구성요소 적재 시 도수 차원을 어디에 넣을지 결정).
- 출처: `known-vs-unknown.md U-1·C-1` + `_curation/axis-price-engine.md` GAP-PE-6 {tier A}
- 연결: [[#PE-SOT-3]] · [[#PE-STALE2]]
- tags: #GAP #도수 #clr_cd폐기 #컨펌필요

### [PE-GAP-7] 합산형(엽서) 가격사슬 미완성 (N-1)  {🔴}
- 내용: 골든 엽서 인쇄비 20,000 ≠ 라이브 11,750(gate-verdict P2 FAIL·arbiter N1). 갈린 지점 = ① 단가표 값 불일치(라이브 470@min_qty25 vs 골든 800@출력매수25) ② 엔진에 판걸이수→출력매수 변환 부재. **면적매트릭스는 완전 재현·합산형은 NO-GO**. 위키는 엽서 가격을 "검증 미완"으로 표기. 보정 경로 = 엽서 인쇄비 단가행 재적재 + 임포지션 변환 위치 정립(Q-IMPOSITION).
- 출처: `gate-verdict.md P2`·`05_gate/arbiter-deliberation-N1.md` {tier A, FRESH}
- 연결: [[#PE-005]] · [[#PE-GAP-8]]
- 사용처: [[recipes/digital-print#DGP-PR-001]] (엽서 가격 검증 미완)
- tags: #GAP #합산형 #엽서 #N-1 #검증미완

### [PE-GAP-8] 수량×단가의 "수량" = 출력매수(판수) vs 주문수량 vs BOM소요량 (U-6/C-3)  {🔴}
- 내용: 부자재 10차원 흡수(SOT 6b)·합산형 엽서(N-1) 둘 다의 선결 미지 — 단가행 티어의 "수량"이 출력매수(판걸이수 변환)인지 주문수량인지 option_items.qty(BOM소요량)인지 축 확정 부재. 엔진엔 임포지션 변환 부재([PE-010]). → **🔴 사용자/도메인 컨펌 필요**.
- 출처: `known-vs-unknown.md U-6·C-3` + `sot-definitions.md §SOT 6` + `_curation/axis-price-engine.md` GAP-PE-8 {tier A}
- 연결: [[#PE-SOT-6]] · [[#PE-010]] · [[#PE-GAP-7]]
- tags: #GAP #수량축 #출력매수 #BOM소요량 #컨펌필요

### [PE-GAP-9] 배선 레벨 제약 장치 신규 설계 필요 (SOT 4)  {🔴}
- 내용: 공식↔구성요소 배선이 시트 허용 차원 안인지 강제하는 제약 장치 라이브 부재([PE-SOT-4]). CPQ `fn_chk_opt_item_ref`(option_items 전용·상품-스코프 무결성)가 **모범**이나 가격 배선엔 미복제 → 처방 = 그 패턴을 `t_prc_formula_components`/`t_prd_product_price_formulas`로 확장(설계 트랙 몫). 신규 설계 미지.
- 출처: `constraint-mechanism-gap.md §8`(fn_chk_opt_item_ref 확장 토대) + `_curation/axis-price-engine.md` GAP-PE-9 {tier A, FRESH}
- 연결: [[#PE-SOT-4]] · [[cpq-options#CPQ-003]] (fn_chk_opt_item_ref)
- tags: #GAP #제약장치 #신규설계 #배선

### [PE-GAP-10] addtn_yn='N'(차감) 행 처리 (U-2/C-2)  {🔴}
- 내용: 엔진이 `addtn_yn`을 미참조(전부 합산·C7) → 차감 의도 행이 합산되면 과대합산. 라이브: addtn_yn N 2행 실재(`PRF_CLR_ACRYL/COMP_ACRYL_CLEAR3T`·`PRF_COROTTO_ACRYL/COMP_ACRYL_COROTTO`)·설계 deferred("의도 불확실·필요해지면 차후 재정의"). 필요 시 개발자 백로그(코드 수정), 불필요 시 dead 컬럼. → 사용자 컨펌.
- 출처: `constraint-mechanism-gap.md §6`(addtn_yn N 2행·deferred) + `known-vs-unknown.md U-2·C-2` + `_curation/axis-price-engine.md` GAP-PE-10 {tier A, FRESH}
- 연결: [[#PE-DEV-1]] (frm_typ·addtn_yn 미참조) · [[#PE-SOT-4]]
- tags: #GAP #addtn_yn #차감 #컨펌필요

---

## Sources
- 큐레이션 팩: `_curation/axis-price-engine.md`(§0 FRESH 원천 소스맵·§0c 핵심사실 7·STALE 함정 7·GAP) · `_curation/source-registry.md`.
- **★1차 권위(FRESH·2026-06-18 라이브 information_schema + pricing.py 실측):**
  - 가격엔진 이해·진단 하네스 `huni-price-engine-diag/`: `01_mechanism/{sot-definitions,device-roles,combination-mechanism,knowledge-map}.md`(SOT 1~7·5장치·결합/독립) · `02_code_schema/{code-schema-matrix,price-source-intent,constraint-mechanism-gap,impl-gap-board,design-artifact-trace}.md`(코드↔스키마·제약부재·STALE 확정) · `03_synthesis/{known-vs-unknown,sot-reconciliation,engine-comprehension}.md`(K1~8·U1~6·C1~3).
  - 가격검증 하네스 `huni-price-quote/`: `01_engine/engine-contract.md`(evaluate_price 권위 계약·C1~9·pricing.py:line) · `01_engine/{price-flow-map,widget-price-contract}.md` · `02_authority/{authority-golden,golden-cases,authority-gaps}.md`(골든 케이스) · `03_chain/{dimension-mapping-matrix,chain-defect-board,size-dedup-report}.md` · `04_option/*` · `05_gate/{gate-verdict,arbiter-deliberation-N1,confirmed-defects,recompute-log}.md`(P1~P7 CONDITIONAL-GO).
- 구조 정답(FRESH): 라이브 psql `information_schema`(t_prc_* 컬럼·행수 실측 — 차원의 라이브 실재 권위); `raw/webadmin/webadmin/catalog/pricing.py`(570줄·evaluate_price)·`price_views.py`; `raw/webadmin/sql/18_unify_price_keys.sql`·`sql/20_template_prices.sql`(보조 DDL).
- 공식유형 정답(tier C): `huni-dbmap/02_mapping/{digital-print-engine,silsa-poster-area-matrix,price211-fixedgrid,dwire-poster-formula-remodel,dwire-bind-namecard-photocard-remodel}/`; `09_load/_migrate_areamatrix/`·`_migrate_fixedprice/`; `00_schema/discount-domain-detail.md`; `raw/webadmin/tools/load_discounts.py`.
- 보조: `05_method/F2-price-sheet-structures.md`·`06_extract/price-<slug>-l1.csv`·`pangeori-l1.csv`.
- freshness: `18_schema-change/impact-diagnosis.md` I-1·I-2·I-3·I-4·I-7.
- 메모리: `dbmap-price-formula-types-authority`·`dbmap-silsa-price-via-poster-sign`·`dbmap-compute-in-app-db-stores-lookup`·`dbmap-output-plate-mapping`·`dbmap-price-chain-dwire-per-product-formula`·`dbmap-digitalprint-atomic-formula-unbuilt`·`dbmap-discount-authority`.
- **STALE(인용 금지) [HARD]:** `00_schema/price-engine-ddl.md` 전체(I-1·I-2·I-4·I-7·[PE-STALE]); **`raw/webadmin/docs/prcx01-pricing-model.md`·`pricing-erd.md`(8차원·clr_cd·frm_typ_cd·[PE-STALE2] — 구조/차원/단가유형/도수 인용 금지·의도 배경만 허용)**; round-2 포스터 면적-좌표 회귀 모델; "evaluate_price 미구현" 진술; v03 마이그레이션.
