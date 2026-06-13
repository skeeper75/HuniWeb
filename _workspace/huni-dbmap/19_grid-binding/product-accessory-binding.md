# 상품악세사리 — 생산형태 × 그릇 × 선택→견적 binding (round-15 확대 #2)

> **작성** 2026-06-13 · round-15 확대(굿즈파우치 파일럿 A~E 구조 준수). 생산형태 = **기성상품(`PRD_TYPE.03`)** 시트.
> **목적:** 시트의 각 컬럼이 ① 어떤 생산형태 상품의 ② 어떤 그릇에 담겨 ③ 고객 선택→견적까지 어떻게 이어지는지 + ④ 경쟁사 대조 + ⑤ 현재 고려/GAP을 한 판에.
> **입력 권위(재유도 0·인용):** `15_domain-spec/product-accessory/`(mapping-info·column-dictionary·product-bom·domain-research-notes) · `17_correctness/product-accessory/product-identity.md`(F-PA-0~4·이중등록=의도) · `17_correctness/_crosscut/accessory-option-research.md`(2축·경쟁사 6그릇·케이스 5권고) · `00_schema/schema-design-intent-map.md`(③ 삼중바인딩·OM-1 카드봉투) · `production-form-grid-matrix.md`(§1.1 기성상품·§2 매트릭스 기성상품 열) · `12_coverage/gap-board.md`(악세사리 적재상태).
> **DB 미적재 — 조망/목표매핑 전용.**

---

## A. 상품군 성격 (생산형태 + 정체)

> **[보정·G1 라이브 실측 2026-06-13] 도메인 생산형태 ↔ 라이브 `prd_typ_cd` 분리 기재**(`production-form-grid-matrix §1.0`). **이 시트는 도메인=라이브 일치(유일 시트)** — 다른 10시트는 도메인 완제품/반제품이 라이브에선 `.04`(디자인상품) 등으로 흩어져 불일치(오모델 OM-신규)인 데 반해, 상품악세사리는 도메인=기성상품이 라이브 `.03`으로도 일관 적재된다(봉투 `.05` 추가상품 이중등록만 예외=OM-1).

| 항목 | 내용 | 실무진 표시용 쉬운 라벨(`§1.0-b`) |
|------|------|-----------------------------------|
| **도메인 생산형태** | **기성상품** — 매입 완제 부자재. 후니가 **인쇄·가공 안 함**(외주 우드만 예외). `production-form-grid-matrix §1.1` "매입 완제 부자재 PRD_TYPE.03". | "기성상품(매입 완제 부자재)" |
| **라이브 `prd_typ_cd` 실측** | **`.03 기성상품` × 15** (PRD_000001~000015 본체) **+ `.05 추가상품` × 3** (봉투/케이스 = 카드봉투 281/282/283 이중등록, OM-1). **도메인=라이브 일치** — 흩어짐 없음(`§1.0` 전역실측 .03=123·.05=3 중 본 시트 분). | `.03`→"기성상품(매입 완제 부자재)" · `.05`→"추가상품(다른 상품에 붙는 옵션)" |
| **정체** | **15 distinct 상품**(라이브 PRD_000001~000015) · 봉투/케이스 11 + 상품액세서리 4. **MES prefix 전부 012(포장)** = 카테고리 012 포장재(`product-identity F-PA-0`). "상품악세사리"는 시트 라벨일 뿐 별 범주 아님. | "포장·부속 부자재 묶음" |
| **부자재 4군** | ⓐ봉투/케이스(OPP·트래싱지·카드·캘린더·투명케이스) ⓑ결속/거치(볼체인·와이어링·천정고리·행택끈·자석고무판) ⓒ우드(거치대·봉·행거, 외주가공) ⓓ리필(만년스탬프 리필잉크). |
| **인쇄 BOM 부재** | **자재/공정/도수/판형 컬럼 전무**(완제 부속) — 후니 인쇄 BOM 미적용 **유일 시트**(`column-dictionary §0` 1차 발견). |
| **이중역할(의도)** | 자체 prd_cd 독립 판매(`PRD_TYPE.03`) + 다른 상품 addon으로 `t_prd_templates` tmpl_cd 참조 = **OTC TEMPLATE 카탈로그**(round-9 OTC 권위). 일부 추가상품(`PRD_TYPE.05`)으로 이중등록(카드봉투 281/282/283). |
| **가격 소스** | **② 상품마스터 "가격포함"**(C9·고정가형) — 인쇄상품 가격표 엑셀 아님. round-2 고정가형 처리. |

> ⚠️ 생산형태는 prd_cd 단위 — 15상품 전부 기성상품이나, 봉투/케이스 11은 **다른 시트(엽서/캘린더/족자/만년스탬프)의 추가상품으로 host가 참조**하는 OTC TEMPLATE이 핵심 역할.

---

## B. 실무진이 준비한 그릇 (스키마 인벤토리)

`production-form-grid-matrix §2 매트릭스 **기성상품 열**` 기준, 상품악세사리에 실제 쓰이는 그릇:

| 그릇 (t_*) | 상품악세사리에서 담는 것 | 엑셀 컬럼 | 실무진 표시용 쉬운 라벨(`§1.0-b`) | 비고(매트릭스 §2 기성상품 셀) |
|-----------|------------------------|----------|--------------------------------|------------------------------|
| `t_prd_products` | 부자재 정체·수량범위(min/max/incr)·MES·use_yn | C4·C6~8·C3 | "부자재 상품" | 멱등키=prd_nm. PRD_000001~015 적재됨 |
| `t_cat_categories`+`_categories` | 카테고리 012 포장재(봉투/케이스·포장부자재·상품액세서리) | C1 | "분류(포장·부속)" | **정상 노드 276/285/287**(고아 293 아님·F-PA-2) |
| `t_siz_sizes`+`_sizes` | **매입 고정규격**(봉투 치수·우드 길이·잉크 5cc) | C5(치수분) | "매입 고정규격(고를 게 적음)" | §2#1 "매입 고정규격(siz 단일, 선택 적음)" |
| `t_prd_product_bundle_qtys` | **묶음수**(50장·3개1팩·2개1세트·20개입·10개) | C5(묶음분) | "몇 개 묶음" | §2#9 bundle_qtys+매입단위. QTY_UNIT 장/개/팩/세트 |
| `t_mat_materials`+`_materials` | **본체색=variant/자재행**(볼체인 8·리필잉크 7·와이어링 3·행택끈 3) | C5(색상분) | "본체 색상(부자재 자체 색)" | §2#3 "본체색=variant/자재행". 단 라이브 MAT_TYPE.10 오염(F-PA-3) |
| `t_prd_templates` | **별 SKU + addon 참조**(봉투=host 캐스케이드 참조·볼체인=키링·우드=족자/행잉·리필=만년스탬프) | C4 | "다른 상품에 붙는 옵션 묶음" | §2#8 "별 SKU + templates 참조(봉투=host가 참조)" |
| `t_prd_product_prices` (가격) | **고정가 base**(가격포함) | C9 | "고정 판매가" | §2#10 고정가(`t_prd_product_prices`). round-2 |
| `t_prd_product_option_*` (CPQ) | 색상 옵션(볼체인 8색 등 option_items로 자재행 포인터) | C5(색상분) | "고객이 고르는 색상 옵션" | §2 셀 내부 2축: 색=자재행+option 포인터(ref_dim_cd=03) |
| `t_prd_product_sets` | **봉투세트**(배경지+봉투 동봉·사이즈 자동매칭) | (도출) | "세트로 함께 담기(봉투 동봉)" | §2#11 "사이즈 자동매칭(host↔봉투)"·BATCH-5 |

→ **인쇄 BOM 그릇(print_options·processes·plate_sizes)은 N/A**(매입품·인쇄 안 함). 우드 외주가공만 §2#6 후가공 예외. **그릇은 갖춰져 있고, 인쇄 5속성축이 빠진 것이 기성상품의 특징.**

---

## C. 선택 → 견적 end-to-end 목표 매핑 (★핵심·기성상품 흐름)

고객이 견적 화면에서 **고르는 순서**대로, 각 선택이 어느 그릇→가격으로 이어지는지:

| 단계 | 고객 선택 | 담기는 그릇 | UI(componentType) | 가격 기여 |
|:--:|----------|-----------|------------------|----------|
| 1 | **부자재 상품** (or host의 추가상품) | products+categories | (카탈로그) or (host addon) | 고정가 base 결정 |
| 2 | **규격/치수** (봉투 치수·우드 길이·잉크 용량) | `sizes`(매입 고정규격, 선택 적음) | `option-button`/`select-box` | base 단가 키 |
| 3 | **색상** (볼체인 8·리필잉크 7·와이어링 3·카드봉투 W/B) | `materials`(본체색=자재행) + 색=`option_items`(ref_dim=03) | `color-chip` | 선택가격(variant) |
| 4 | **묶음수** (n개1팩·n장·n세트·n개입) | `bundle_qtys`(QTY_UNIT) | (묶음 선택) | 묶음 단위 단가 |
| 5 | **수량** | products(min 1/max 100/incr 1) | `counter-input` | × 수량, − 구간할인 |
| → | **견적 = 고정가(variant별) × 수량 − 구간할인** | `t_prd_product_prices` 고정가형 + `t_dsc_*` | `summary` | ④ 가격 사슬 |
| ★ | **봉투세트 경로**: host(배경지/엽서/캘린더) 사이즈 선택 → 봉투 사이즈 **자동매칭** | `t_prd_product_sets` + 캐스케이드 | (host 옵션) | host 견적에 봉투 동봉가 합산 |

**가격 소스 확정:** 상품악세사리 가격은 **상품마스터 "가격포함" C9**(variant별 고정가)에 **이미 존재** — 인쇄상품 가격표 엑셀이 아니라 상품마스터에 내장. **고정가형**(round-2)이므로 단가행(`comp_prices`)을 거치지 않고 상품별 고정가가 직접 가격이 된다. **라이브 ❌ = "전역 0"이 아니라 *공식 바인딩 미완***(`§1.2` 정정 실측: 전역 `comp_prices` 3,481행·`price_formulas` 63 바인딩·단 직접 고정가 `product_prices` **0행**·악세사리 `option_items` 미적재). 즉 단가행은 광범위 적재되나 **악세사리는 고정가형이라 `product_prices`에 들어가야 하는데 그 트랙이 0행** — 미적재일 뿐 그릇 부재 아님(`gap-board` 악세사리 가격 MISSING·DIM-UNLOADED·"마스터 inline 가격").

> **2축 도출 적용(셀 내부·`accessory-option-research §3`):** "색상" → ①BOM축: 본체색=재질행 합성(자재, WowPress 정당) · ②판매축: 색=`option_items`(ref_dim_cd=03 자재 포인터). "묶음" → ①자재행+수량 · ②`bundle_qtys`(조성동일+수량=variant, Lasso). 매트릭스 셀이 1차, 2축이 2차.

> **봉투 사이즈 자동매칭(`BATCH-5(a)` 권장):** product-accessory가 실측으로 답함 — 봉투=하위상품, host 사이즈 선택→봉투 사이즈 자동 연동(캐스케이드). 캘린더봉투만 템플릿 신규 생성 필요. 단순 addon(b)은 사이즈 매칭·동봉 표현 불가.

---

## D. 경쟁사 대조 (생산형태=기성품 부자재 관점 · `accessory-option-research` 전면)

> 이 시트가 **악세사리 리서치의 직접 대상** — 6그릇 매핑 + 5 케이스 권고가 모두 여기서 나옴.

| 쟁점 | 경쟁사 패턴 | 후니 정합/권고 | 케이스ID |
|------|-----------|---------------|:--:|
| **볼체인 8색·3개1팩** | WowPress 본체색=재질(정당) / Lasso 묶음=수량축 | **자재행 8색 유지**(과분할 아님) + **묶음수 → `bundle_qtys` 분리**(현재 mat_nm 융합 오모델 교정) + 8색=`option_items`(ref_dim=03) | Q-ACC-4 |
| **카드봉투 이중등록** | Lasso 구매맥락 split이되 **물리 SKU 1** / Shopify product+bundle 참조 | **봉투 1 base(004)** + add-on은 `t_prd_templates`로 참조(281/282 별 PRD 폐기 검토). 색상 **004에서 일원화**(siz 합성[OM-1] 폐기→option/variant) | Q-ACC-5·OM-1 |
| **본체색 귀속** | WowPress: 본체색=재질행(새 축 안 만듦) | ✅ 후니 재질행 합성 동형 (단 라이브 MAT_TYPE.10 오염=F-PA-3, 색≠자재 정규화 권위와 충돌) | Q-PA-2 |
| **묶음 판매** | Lasso: 조성 같고 수량만 다르면 variant | bundle_qtys 분리. 별 SKU도 bundle도 아닌 **자재행+묶음수+옵션 포인터 결합** | Q-ACC-4 |
| **각인 텍스트**(만년스탬프류) | Shopify: 각인 내용=line item property(재고 무관) | **GAP-1** — 후니에 "재고 없는 1회성 주문입력값" 그릇 부재(주문 스키마는 본 하네스 범위 밖) | GAP-1 |

→ **후니 8그릇이 경쟁사 6 표준 그릇(Product/Variant/Attribute/Option/LineItemProperty/Bundle)을 전부 흡수·능가**(`accessory-option-research §6`). 기성품 부자재 실 GAP은 **line item property(각인 텍스트, GAP-1)** 단 하나.

---

## E. 현재 고려 여부 + GAP (사슬 끊긴 곳)

`12_coverage/gap-board.md` + `production-form-grid-matrix §1.2`(악세사리 행: ①✅ ②◆ ③◆소수 ④❌ 견적 0). **[정정 §1.2 라이브 실측 2026-06-13] "전역 0"은 부정확** — 전역 `option_items` **25행**·`comp_prices` **3,481행**·`price_formulas` **63 바인딩**은 적재됨. 본 시트의 ❌는 **악세사리 *상품별* 미적재**(커버리지 미흡)이지 그릇/전역 부재 아님:

| 레이어 | 상태 | GAP/조치 |
|--------|------|---------|
| ①골격 | ✅ 적재 (PRD_000001~015) | 단 카테고리 고아 293 오연결(F-PA-2·정상 276/285/287로 재연결) |
| ②차원그릇 | 🟡 부분(sizes 7/15·`gap-board` DOMAIN-UNDECIDED) | 치수/묶음/색상 3축 분리 적재(C5 복합). 색상은 MAT_TYPE.10 오염 교정(F-PA-3) |
| **③선택(CPQ)** | ◆ **소수 잔재** (전역 `option_items` 25행 ≠ 0, 단 악세사리분 미흡) | OPP비접착봉투(PRD_000002) opt_group/option **items 0**(`gap-board` 테스트 잔재 의심) → 정식 색상 option_items 적재(round-6) |
| **④가격** | ❌ 악세사리분 미적재 (전역 `comp_prices` 3,481·`price_formulas` 63 有 / 단 `product_prices` 전역 0) | 악세사리=**고정가형** → `product_prices` 트랙으로 적재 필요(상품마스터 C9 가격포함). 단가행 그릇 부재 아닌 **고정가 바인딩 미완** |

**잔존 컨펌(인간 결정·`domain-research-notes` PA-1~5 + `accessory-option-research` Q-ACC):**
- 🔴 **OM-1 / Q-ACC-5 / Q-PA-1** 카드봉투 이중등록 일원화 — 004(기성) vs 281/282/283(추가+template base) 역할 분리. 봉투 1 base + template 참조, 색상 004 일원화(siz 합성 폐기). **이중등록=의도(09_delete_dup 삭제 제외 입증)** 이나 물리 SKU 중복 정합 위험.
- 🔴 **Q-PA-2 / Q-ACC-4** 색상 variant 귀속 — 라이브는 색상을 `t_mat_materials` MAT_TYPE.10으로 적재(F-PA-3 오염). 정답=옵션(option_items)인가 자재 유지인가? 8색 가격差·묶음 가변성에 의존(가격 미적재로 판정 불가) → **BATCH-6 색→옵션·BATCH-2와 동일**.
- 🟡 **PA-4 / Q-ACC-5** 우드거치대 C-4 분기(본체가공 OPTION vs 별매 TEMPLATE) — 캘린더 CL-2·실사 SL-4 동류(일괄).
- 🟡 **Q-PA-3** 천정고리 use_yn=N 의도(판매 중지) vs 적재 누락. **PA-5** MES 공유(012-0004 OPP접착=비접착) 별 prd_cd 분리.
- 🟡 **GAP-1** line item property(각인 텍스트) — **주문 스키마 범위 밖**(본 하네스 외, dbm-ddl-proposer 또는 주문 측).
- 🟡 **BATCH-5** 봉투세트 — `t_prd_product_sets` + 사이즈 자동매칭(권장 a). 영향 3 family(digital-print·product-accessory·calendar).

> **횡단 연결:** Q-ACC-5·OM-1=카드봉투 일원화 · Q-PA-2·Q-ACC-4=`BATCH-6`(색→옵션)·`BATCH-2`(색·부속 분리) · BATCH-5=봉투세트(`BATCH-5`) · 본체색 합성=`§2.1 원리`. **케이스 컨펌이 §2 매트릭스 기성상품 열 원칙으로 수렴** — round-15 목표 입증(악세사리 리서치가 그릇 미준비가 아니라 적재·정합 GAP임을 확정).

---

## 한 줄 현황

**확대 #2 GO 대기:** 상품악세사리를 A(성격=기성상품·**도메인=라이브 일치 유일 시트**[.03×15+.05×3 봉투]·OTC TEMPLATE·인쇄 BOM 부재·쉬운 라벨 병기)·B(그릇=기성상품 열 9종+쉬운 라벨, 인쇄 5축 N/A)·C(선택→견적: 상품/규격/색/묶음/수량 + 봉투세트 자동매칭·가격=상품마스터 C9 가격포함 **고정가형**)·D(경쟁사 6그릇 흡수·5 케이스 권고·실 GAP=line item property 1건)·E(③CPQ 악세사리분 미흡[전역 25행≠0] ④가격 악세사리분 미적재[전역 comp 3,481·formula 63 有, product_prices 0]·카드봉투 OM-1·색→옵션 BATCH-6·봉투세트 BATCH-5). **가격 소스 규명: 상품마스터 내장 고정가형(라이브 ❌=악세사리분 미적재이지 전역 0 아님).** **DB 미적재.**
