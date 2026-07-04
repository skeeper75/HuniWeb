# 상위 온톨로지 후보 어휘 — 브랜드-중립 개체·관계 (§35 Phase 1 주력 산출)

> 작성: 2026-07-04 · mbo-standards-researcher · **사용자 결정 2 = "상위 온톨로지·표준 먼저"의 1차 주력 산출.**
> 원천: `standards-playbook.md`(표준 개념 사전)·§33 `ontology-schema.md`(개체17·관계19)·§35 와우 분석.
> **[HARD] search-before-mint:** 상위 개념 이름표는 표준(schema.org/XJDF/구성 온톨로지)에서만 차용. 후니·와우 하위 노드는 `instance_of`/`mapped_to`로 상위에 잇는다.
> **경계:** 이 문서는 **후보 어휘·대응표**까지. 스키마 확정·닫힌세계 규약·개체 승격은 architect(mbo-ontology-design) 몫. 라이브/DB 미접근.
>
> **읽는 법(비전문가용):** 후니는 상품을 t_* 테이블(prd_cd·material·process…)로, 와우는 6+2축(size·paper·color·prsjob·awkjob·prodadd…)으로 표현한다. 이름이 다를 뿐 "같은 인쇄 개념"이다. 이 문서는 그 위에 브랜드-중립 공통 개념(상위 온톨로지)을 두고, 두 브랜드 표현이 각각 그 공통 개념의 "사례(instance)"임을 잇는 대응표다.

---

## 0. 2층 설계 원칙

```
상위 온톨로지 (브랜드-중립 표준 개념)          ← 이 문서가 도출
     ↑ instance_of / mapped_to
브랜드 하위 노드 (후니 t_* 앵커 · 와우 wowpress-api/catalog 앵커 · [레드 향후])
```

- **상위 노드** = 표준 이름표를 가진 브랜드-중립 개념(예 `MediaClass`). 앵커 = 표준 URL(none·사유="표준 개념 레이어").
- **하위 노드** = §33/§35가 이미 만든 브랜드 실물 노드(후니 `material-MAT_000074`·와우 `wow-paper-*`). 재사용·무손상(§33 골든 수정 금지).
- **`instance_of`** = 브랜드 노드가 상위 개념의 한 사례(예 후니 `material-MAT_000074` --instance_of--> `MediaClass`).
- **`mapped_to`** = 두 브랜드 노드가 같은 상위 개념을 통해 교차 대응(예 후니 material ↔ 와우 paper). §33 §9 동사 `mapped_to` 1급 승계 + §35 규칙 `same_family_as`·`price_model_differs`·`component_differs` 병행.
- **아키텍처 중립:** 상위 노드는 "§33 확장"이면 §33 스키마에 개체 유형 추가(E18~), "독립 §35 KB"면 별도 상위 레이어 파일. 어느 쪽이든 아래 어휘 그대로 재사용.

---

## 1. 상위 개체(노드) 후보 어휘

각 행: 상위 개념 → 정의 → 표준 이름표(schema.org / XJDF / 구성 온톨로지) → 후니 하위(§33 개체) → 와우 하위(6+2축) → 승계/신규.
**승계** = §33 표준 이름표 열에 이미 있음(재사용). **신규** = 다중브랜드 위해 보강(표준 근거 있음).

| # | 상위 개념 | 정의(쉬운 말) | schema.org | XJDF | 구성 온톨로지 | 후니(§33) | 와우 | 상태 |
|---|---|---|---|---|---|---|---|---|
| **U-1** | `ProductConcept` | 팔거나 만드는 상품 1개 | Product | Product(제품) | component type | E1 product(prd_cd) | prodno(meta) | 승계 |
| **U-2** | `ConfigurabilityClass` | 상품이 옵션 구성형인가 단순 완제품인가 | — | — | configurable vs non-configurable | prd_typ_cd(.01~.05) | selType(M/S) | **신규**(DELTA-6) |
| **U-3** | `DimensionSpec` | 사이즈(작업 vs 재단 완성 치수) | variesBy(size) | **LayoutIntent FinishedDimensions** | attribute value | E3 size | sizeinfo(sizeno·비규격 w/h) | 승계 |
| **U-4** | `PrintMethodIntent` | 인쇄방식(합판/독판·옵셋/디지털/UV/INDIGO/윤전) | — | Process View(DigitalPrinting/Conventional) 🟡 | attribute | (E5에 접힘·"비절대축") | **prsjobinfo(1급 축)** | **신규**(DELTA-1) |
| **U-5** | `ColorSpec` | 도수·색(단/양면·별색) | — | **ColorIntent** NumColors | attribute | E5 print_option(도수) | colorinfo(colorno·colornoadd) | 승계 |
| **U-6** | `MediaClass` | 자재/용지(재질·평량) | variesBy(material) | **MediaIntent** | resource | E4 material | paperinfo(paperno·papergroup·pgram) | 승계 |
| **U-7** | `ImpositionStrategy` | 조판/판걸이(합판·독판·number-up) | — | **Imposition / number-up** | resource 소요량 규칙 | E7 plate_size+fn_calc_pansu | pjoin(합판9/독판0/별도1) | **신규**(DELTA-2) |
| **U-8** | `FinishingOp` | 후가공 공정 1개(코팅·타공·박·미싱) | — | **Finishing Intent 계열**(HoleMaking·Laminating…) | function→process | E6 process | awkjobinfo(2단 jobgroup→awkjob) | 승계 |
| **U-9** | `BindingType` | 제본 방식(무선·중철·스프링·양장) | — | **BindingIntent @BindingType** | attribute+constraint | E6 process(제본류) | awkjobinfo `제본` 그룹 | 승계(하위 열거 🟡) |
| **U-10** | `FoldScheme` | 접지 패턴(F6-1 등) | — | **FoldingIntent FoldCatalog** | attribute | E6 process(리플렛 오시+접지) | 접지 awkjob | 승계(🟡) |
| **U-11** | `QuantityRule` | 수량규칙(min/max/incr·건수·페이지) | eligibleQuantity(QuantitativeValue) | — | attribute | E8 bundle_qty | ordqty(select/input)·coverinfo.pagecnt | 승계 |
| **U-12** | `VariantAxis` | "달라지는 축"의 추상(옵션 선택 축) | ProductGroup/variesBy | — | attribute 정의 | E11 option_group | 6축 각각(옵션 노출분) | 승계 |
| **U-13** | `AxisValueRef` | 옵션값이 실물 차원을 가리킴 | — | — | port/connection | R11 option_refs(polymorphic) | req_/rst_ 참조·prsjob 맵 내부 필드 | 승계 |
| **U-14** | `AccessoryComponent` | 부자재/추가상품(딸림) | isAccessoryOrSparePartFor | — | optional component | R14 has_addon(product→product) | prodaddinfo / optioninfo(2채널) | 승계(경계 신규 주석·DELTA-5) |
| **U-15** | `CrossAxisConstraint` | 안 되는/필수인 축 조합 | — | — | **constraint** | E12 constraint(CN-1~6) | 인라인 req_*/rst_*(option-item 세분) | 승계(세분성 신규 주석·DELTA-3) |
| **U-16** | `PriceModel` | 가격공식(상품 바인딩·아키타입) | (CompoundPriceSpecification 개념) | — | — | E9 price_formula(원자합산/고정가/매트릭스) | jobcost payload 유형(단일 메커니즘) | 승계 |
| **U-17** | `PriceComponent` | 가격 구성요소(공식의 부품) | UnitPriceSpecification(개념) | — | — | E10 price_component(use_dims) | ordcost_base map(은닉·미재현) | 승계 |
| **U-18** | `QuoteFunction` | 동적 가격 계산 경계(값=서버 권위) | — **표준 없음** | — | — | evaluate_price() | POST /std/prod/jobcost→ordcost_bill | **신규**(DELTA-4·표준 공백 명시) |
| **U-19** | `CategoryNode` | 상품 분류(트리) | category | — | controlled vocabulary | E2 category(3단) | category.path(47·1소속) | 승계 |
| **U-20** | `ProductFamily` | 상품군(명함·스티커·사인·책자…) | (category 상위) | — | — | (카테고리 최상위) | family(catalog-map §1: 명함·스티커·사인제품…) | **신규**(교차정렬 축) |
| **U-21** | `IntentPurpose` | 용도·의도(카페오픈·청첩 등) | — | Product Intent(개념) | function | E-special intent(INTENT_*) | (경쟁분석 용도 코퍼스) | 승계 |
| **U-22** | `BrandNode` | 브랜드 출처(huni/wowpress/red) | brand(Organization) | — | — | (전 노드 huni) | (전 노드 wowpress) | **신규**(§35 brand축) |

**신규 6개**(U-2·U-4·U-7·U-18·U-20·U-22)는 전부 표준 근거 보유(config-ontology·XJDF·schema.org brand). U-14·U-15는 승계이나 다중브랜드 경계/세분성 주석 추가.

---

## 2. 상위 관계(엣지) 후보 어휘

§33 관계 19종을 승계하고, §35 교차브랜드 3종 + 2층 연결 2종을 보강.

| # | 상위 관계 | 방향 | 의미 | 유래 | 상태 |
|---|---|---|---|---|---|
| **X-1** | `instance_of` | 브랜드노드→상위개념 | 브랜드 실물이 상위 개념의 한 사례 | 신규(2층 핵심) | **신규** |
| **X-2** | `mapped_to` | 브랜드노드↔브랜드노드 | 같은 상위 개념 통해 교차 대응(후니↔와우) | §33 §9 동사 승계 | 승계 |
| **X-3** | `same_family_as` | product↔product | 두 브랜드 상품이 같은 상품군(§35 규칙) | 신규 | **신규**(§35) |
| **X-4** | `price_model_differs` | formula↔formula | 같은 상품군인데 가격 모델 상이 | 신규 | **신규**(§35) |
| **X-5** | `component_differs` | component↔component | 같은 개념인데 구성요소 상이 | 신규 | **신규**(§35) |
| — | (§33 R1~R19 전부) | — | product 내부 구조 관계(has_size·uses_material·priced_by·has_component·constrains·has_addon·references 등) | §33 승계 | 승계 |

**설계 근거 (instance_of vs mapped_to):**
- **`instance_of`**(X-1)는 **수직**(브랜드 → 상위). 상위 개념이 표준에 근거하면 이 엣지 1개로 브랜드 노드가 깔끔히 걸린다. 예: `wow-paper-40196-스노우` --instance_of--> `MediaClass`(=XJDF MediaIntent).
- **`mapped_to`**(X-2)는 **수평**(브랜드 ↔ 브랜드). 두 브랜드가 **같은 상위 개념에 instance_of** 되어 있으면, 그 상위를 경유해 교차 매핑이 유도된다. 예: 후니 `material-MAT_000074` ↔ 와우 `wow-paper-*` (둘 다 --instance_of--> `MediaClass`).
- 즉 **상위 개념이 "공통 그릇"**이라 브랜드가 늘어나도(레드 추가) `instance_of` 엣지만 붙이면 교차 매핑이 자동 확장 → architecture-neutral·3브랜드 확장 안전.

---

## 3. 상위 개념이 세 브랜드 차이를 흡수하는가 (자기점검)

| 점검 | 결과 |
|---|---|
| 후니 12 라이브 유형이 상위 U-1~U-19에 빠짐없이 걸리나 | ✅ 됨(U-1~U-19 후니 열 전부 채워짐) |
| 와우 6+2축이 상위에 걸리나 | ✅ size→U-3·paper→U-6·color→U-5·prsjob→**U-4(신규)**·awkjob→U-8/U-9/U-10·prodadd→U-14·수량→U-11·pjoin→**U-7(신규)** |
| 와우 인쇄방식(prsjob 1급 축)이 후니에 억지 접힘 없이 표현되나 | ✅ U-4 `PrintMethodIntent` 신설로 양 브랜드 대등 표현(후니는 print_option 접힘분을 U-4로 투영) |
| 양 브랜드 동적 가격이 상위로 통일되나 | ✅ U-18 `QuoteFunction`(표준 공백 명시)·값=서버 권위(§33 D-18 동형) |
| 와우 교차제약(req_/rst_)이 후니 constraint로 흡수되나 | ✅ U-15 `CrossAxisConstraint`(세분 단위=option-item 주석) |
| 레드(3번째) 추가 시 어휘가 버티나 | 🟡 후니+와우 2브랜드로 검증. 레드 축이 U-1~U-22 밖 개념을 요구하면 델타 추가(현재 GAP-STD-3) — instance_of 구조라 확장 안전 |
| **발견된 한계** | ① U-4 `PrintMethodIntent`의 XJDF 정확 자원 위치 미확정(GAP-STD-2) → architect가 확정 ② U-9/U-10 하위 열거값 🟡(GAP-STD-1) ③ 가격 구성내역(ordcost_base map)은 상위로 재현 안 함(값 권위 경계·의도적) |

---

## 4. architect(mbo-ontology-design)에게 넘길 결정 항목

1. **신규 6 상위 개념(U-2·U-4·U-7·U-18·U-20·U-22)을 개체 유형으로 승격할지**, 기존 §33 개체의 속성/태그로 접을지. 권고: U-4(PrintMethodIntent)·U-18(QuoteFunction)·U-22(BrandNode)는 승격(브랜드 차이 흡수 핵심), U-2·U-20은 속성/파생으로 접기 검토.
2. **상위 노드의 저장 위치**(§33 확장=E18~ 개체 추가 / 독립 §35=상위 레이어 파일). = Phase 4 아키텍처 게이트와 묶임.
3. **`instance_of`(X-1) 신설을 §33 관계 폐쇄목록(19종)에 추가할지** — 2층 설계의 필수 엣지. 권고: 추가(표준 개념 레이어 연결 수단).
4. **U-4 PrintMethodIntent의 XJDF 자원 확정**(GAP-STD-2 해소) — Process View 자원 직독 필요.
5. **와우 하위 노드 id 접두사 규약**(예 `wow-paper-*`·`wow-size-*`) 확정 — §33 후니 접두사와 충돌 없게(brand 축 U-22 병기).

## Sources
- `standards-playbook.md`(§0 승계·§1 표준 사전·§3 델타 6종·GAP)
- §33 `ontology-schema.md`(§1 개체 12+5·§2 관계 19·§6 표준 이름표) — 상위 어휘 원천 재사용
- §35 `01_analysis/wowpress-structure.md`(6+2축·selType·pjoin)·`wowpress-price-mechanism.md`(quoted 단일 메커니즘·U-18)·`wowpress-catalog-map.md`(family U-20)
- 표준 URL 전량 = `standards-playbook.md` Sources 승계(CIP4 XJDF·schema.org·구성 온톨로지)
