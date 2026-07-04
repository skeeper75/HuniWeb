# 라우팅 축 스키마 제안 — 신규 노드·관계 (§35 구조 Phase·architecture-neutral)

> 작성: 2026-07-04 · mbo-standards-researcher · 입력 = `order-routing-fulfillment-ontology-research.md`(4프론트).
> **경계:** 이 문서는 **표준 이름표를 재사용한 노드·관계 후보 어휘**까지. 스키마 확정·닫힌세계 규약·개체 승격은 architect(mbo-ontology-design) 몫. 라이브/DB 미접근.
> **[HARD] search-before-mint:** 기존 상위 개념(U-4 print_method·U-6 material·U-8 finishing·U-3 size·U-9 binding·U-11 quantity)을 **능력 표현에 재사용**. 신규는 표준 근거 있을 때만. CIP4 DeviceCapability·PrintTalk·MSDL·schema.org 이름표 우선.
> **[HARD] 경계 동형(D-18 → D-ROUTE):** 능력 매칭·기준 축까지 온톨로지. 배정 최적화 값 = 엔진. 가격 값 = U-18 엔진(승계).
>
> **읽는 법(비전문가용):** 이 문서는 "주문을 어느 인쇄소가 찍나"를 그래프로 그리는 설계도다. 핵심 아이디어 하나만 기억하면 된다 — **공급자의 "능력"은 새 언어가 아니라, 이미 온톨로지가 아는 생산 축(인쇄방식·용지·후가공·사이즈·제본·수량)으로 적는다.** "이 인쇄소는 UV인쇄 O·무선제본 O·최소수량 500"처럼. 그러면 "이 주문 사양이 이 능력 안에 드나?"만 따지면 후보 인쇄소가 걸러진다. 실제로 "누가 제일 싸고 빠른가"의 계산은 온톨로지 밖(엔진)이다.

---

## 0. 설계 요약 (한 장)

- **신규 상위 개념 5종**(U-23~U-27) — 전부 표준 이름표 보유. **신규 브랜드 실물 개체 3종**(E22 supplier·E23 capability·E24 fulfillment_order) + 경계 노드 1종(E25 routing_function). 나머지는 접기.
- **능력 = 기존 생산 축 재사용**: `Capability`(E23)는 자체 열거를 새로 만들지 않고 U-4/U-6/U-8/U-3/U-9/U-11 노드를 `capability_covers`로 가리킨다 → search-before-mint 극대화. 인쇄방식·용지·후가공·사이즈·제본·MOQ가 곧 능력 축.
- **신규 관계 6종**(RT-1~RT-6): `has_capability`·`can_produce`·`capability_covers`·`routed_to`·`quote_from`·`subcontracts_to`. + schema.org `brokered_by`(RT-7, 접기 후보).
- **후니 = 다중역할**: broker(중개·라우터·schema.org broker) + 자기 이행 시 supplier 겸함. 와우/레드/외부 trade printer = supplier.
- **경계 D-ROUTE**: can_produce 필터(사양⊆능력) + RoutingCriterion 축(cost·lead_time·capacity·MOQ·quality) 노드까지 온톨로지. 배정 스코어링·다목적 최적화 = E25 routing_function(값=엔진 권위·U-18 QuoteFunction 동형).
- **닫힌세계 유지**: 실 공급자·능력 데이터 부재(GAP-ROUTE-3) → 모든 브랜드 실물 라우팅 노드는 **현재 GAP/candidate**. 이 문서는 스키마 형(型)만 제안, 실 앵커는 공급자 레지스트리 확보 후.

---

## 1. 신규 상위 개념 후보 어휘 (U-23~U-27·표준 이름표)

`upper-ontology-vocabulary.md` U-1~U-22 연장. 각 행: 상위 개념 → 정의 → schema.org / CIP4 / 제조 온톨로지 이름표 → 브랜드 하위 대응.

| # | 상위 개념 | 정의(쉬운 말) | schema.org | CIP4 | 제조 온톨로지 | 브랜드 하위(예) | 상태 |
|---|---|---|---|---|---|---|---|
| **U-23** | `SupplierConcept` | 주문을 실제 이행하는 인쇄소/공급자 1개 | **seller / provider (Organization)** | PrintTalk provider · **Subcontractor** | MSDL **Supplier** | huni(자기이행)·wowpress·red·외부 trade printer | 신규(표준 강함) |
| **U-24** | `ProductionCapability` | 공급자가 "할 수 있는 것"(인쇄방식·후가공·사이즈·MOQ 커버) | — **(공백)** | **JDF DeviceCapabilities**(속도·색수/용지 한계·모듈) 🟡 | MSDL **ManufacturingCapability** · **MaRCO** capability | (능력 프로파일 = U-4/6/8… 참조 묶음) | 신규(schema.org 공백·§2 차용) |
| **U-25** | `FulfillmentOrder` | 이행 대상 주문(라우팅 입력·사양 담체) | **Order / OrderItem** | **PrintTalk RFQ / PurchaseOrder** | — | (자연어 질의→추천 산출 주문·A 에이전트 경계) | 신규(표준 강함) |
| **U-26** | `RoutingCriterion` | 배정 결정 기준 축(비용·납기·용량·MOQ·품질) | Offer.**deliveryLeadTime**·**eligibleQuantity**·areaServed | (MIS 스코어카드) | Cloud-Mfg matching criteria | criterion-cost·criterion-leadtime·criterion-capacity·criterion-moq·criterion-quality | 신규(축만·값=엔진) |
| **U-27** | `RoutingFunction` | 최적 배정 경계(값=엔진 권위) | — **표준 없음** | — | Cloud-Mfg **multi-objective optimization**(엔진측) | (각사 MIS/브로커 SW·후니 라우팅 엔진) | 신규(표준 공백·U-18 동형) |

- **U-23 SupplierConcept** = schema.org seller/provider(Organization) + PrintTalk subcontractor + MSDL Supplier 3중 앵커 → 표준 강함. brand 축(U-22)과 직교: 한 공급자는 한 brand이나, brand≠supplier(brand=출처 조직, supplier=이행 역할).
- **U-24 ProductionCapability** = schema.org 공백(GAP-ROUTE-2) → JDF DeviceCapabilities(🟡 XJDF 폐기) + MSDL/MaRCO 차용. **자체 열거 안 만듦** — U-4/U-6/U-8/U-3/U-9/U-11 재사용(§2).
- **U-27 RoutingFunction** = U-18 QuoteFunction과 **완전 동형**: 표준 공백, 값=서버/엔진 권위, 온톨로지는 경계 노드까지.

---

## 2. 능력 = 기존 생산 축 재사용 (search-before-mint 핵심)

`ProductionCapability`(E23/U-24)는 새 어휘를 만들지 않는다. 공급자 능력 프로파일 = **이미 있는 상위 축 노드의 커버 집합**:

| 능력 차원 | 재사용 상위 개념 | 능력 표현 예 | can_produce 매칭 규칙 |
|---|---|---|---|
| 인쇄방식 | **U-4 PrintMethodIntent**(E18 print_method) | "합판디지털·독판옵셋 가능" | 주문 print_method ∈ 공급자 커버 집합 |
| 자재/용지 | **U-6 MediaClass**(E4 material) | "스노우·아트지 계열" | 주문 material ⊆ 커버 |
| 후가공 | **U-8 FinishingOp**(E6 process) | "코팅·타공·박 가능·귀도리 불가" | 주문 process ⊆ 커버 |
| 사이즈 | **U-3 DimensionSpec**(E3 size) | "max 국전·min 명함" | 주문 size ∈ 커버 범위 |
| 제본 | **U-9 BindingType** | "무선·중철 가능·양장 불가" | 주문 binding ∈ 커버 |
| 수량/MOQ | **U-11 QuantityRule**(eligibleQuantity) | "MOQ 500·max 100k" | 주문 qty ∈ [MOQ, max] |

- **매칭 = 포섭(subsumption)**: 주문 사양의 각 축값이 공급자 능력 커버 집합의 (하위)원소 → `can_produce`. 학술 근거 = Product Model matchmaking(개념명 수준 포섭·research §2.3).
- **결합 능력**: 공급자가 여러 단순 능력을 가지면 전 사양 커버(MaRCO combined capability·research §2.2). 결합 판정은 reasoner/엔진(경계 밖·D-ROUTE).
- → 라우팅 축은 **기존 축의 재사용 + Supplier/Capability 노드 신설**뿐. 인쇄 개념 재발명 0.

---

## 3. 신규 관계 후보 어휘 (RT-1~RT-7)

`upper-ontology-schema.md` 관계 폐쇄목록(23종·§33 19 + X-1~X-5) 연장. 각 행: 관계 → 방향 → 의미 → 표준 근거 → 카디널리티.

| # | rel | 방향(source→target) | 의미 | 표준 이름표 | 카디널리티 |
|---|-----|--------------------|------|-----------|-----------|
| **RT-1** | `has_capability` | supplier → capability | 공급자가 능력 프로파일 보유 | MSDL hasCapability | 1:N |
| **RT-2** | `can_produce` | supplier → product / product_family / 사양 | 공급자가 이 상품(군)/사양을 생산 가능(포섭 매칭 결과) | Product Model matchmaking · schema.org **provider** | N:M |
| **RT-3** | `capability_covers` | capability → U-4/U-6/U-8/U-3/U-9/U-11 노드 | 능력이 어느 생산 축값을 커버 | JDF DeviceCapabilities · MaRCO | N:M |
| **RT-4** | `routed_to` | fulfillment_order → supplier | 주문이 이 공급자에 배정됨(값=엔진 결정·경계) | schema.org Order.**seller** · PrintTalk PurchaseOrder | N:1 |
| **RT-5** | `quote_from` | fulfillment_order / product → supplier (경유 quote_function) | 이 공급자에게 받은 견적(값=U-18 엔진) | schema.org acceptedOffer · PrintTalk **Quotation** | N:M |
| **RT-6** | `subcontracts_to` | supplier → supplier | 하도급 이행(신원 은닉 가능) | **PrintTalk Subcontracting** | N:M |
| **RT-7** | `brokered_by` | fulfillment_order → supplier(broker 역할) | 중개자가 배정 주선(후니=broker) | schema.org Order.**broker** | N:1 (접기 후보) |

- **RT-7 접기 검토**: schema.org broker는 실재 어휘이나, 후니=broker는 대개 고정(단일 중개자) → 개체 신설보다 fulfillment_order 속성 `broker=brand-huni`로 접기 권고(architect 판단). 다중 중개(레드도 중개) 실증 시 승격.
- **폐쇄목록 유지**: 개방 관계명 금지(§33 D-7 승계). 라우팅 추가 시 총 23 + RT-1~RT-6 = **29종**(RT-7 접기 시).
- **경계 관계**: RT-4 `routed_to`·RT-5 `quote_from`은 **엣지는 온톨로지, 값(어느 공급자로 최종·얼마)은 엔진**. 엣지 존재 = "배정 관계가 있다"까지, 최적 선택 = routing_function.

---

## 4. 신규 브랜드 실물 개체 (E22~E25·닫힌세계·현재 GAP)

`upper-ontology-schema.md` 개체(E1~E21+E-U) 연장. **★현재 전부 GAP/candidate**(GAP-ROUTE-3: 실 공급자 데이터 부재).

| # | type | 정의 | id 접두사 | 앵커 정책 | 핵심 속성 | 표준 이름표 |
|---|------|------|-----------|-----------|-----------|-------------|
| **E22** | `supplier` | 이행 공급자 1개 | `supplier-`(huni자기)·`wow-supplier-`·`red-supplier-`·`ext-supplier-` | ⚪ GAP(실 공급자 레지스트리 부재) · 확보 후 조직 앵커 | brand·legal_name·roles(supplier/broker)·homepage | schema.org seller/provider · MSDL Supplier |
| **E23** | `capability` | 능력 프로파일 1개(축 커버 묶음) | `cap-` | ⚪ GAP(능력 실측 부재) | supplier_ref·covered_axes(→U-4/6/8…)·moq·max_qty | JDF DeviceCapabilities · MaRCO |
| **E24** | `fulfillment_order` | 이행 대상 주문(A 에이전트 산출 경계) | `ford-` | ⚪ GAP(주문 인스턴스는 런타임) · 스키마 형만 | ordered_item(→product)·qty·criteria_weights(엔진)·status | schema.org Order/OrderItem · PrintTalk RFQ |
| **E25** | `routing_function` | 배정 최적화 경계(값=엔진) | `routefn-` | `none`(+사유="배정 엔진·표준 공백") | engine_ref·input_criteria(→U-26)·output(routed supplier) | (표준 없음·U-27) |

- **E22 supplier 다중역할**: `roles` 속성으로 supplier/broker 병기. 후니 = `roles:[broker, supplier]`(중개 + 자기이행). 와우/레드/외부 = `roles:[supplier]`.
- **E24 fulfillment_order 경계**: 주문 인스턴스는 런타임 데이터(라이브) → 온톨로지엔 **형(型)만**. 실 주문 노드화는 KB 범위 밖(A 에이전트 추천→주문 경계와 접합).
- **E25 routing_function** = E19 quote_function과 동형 노드(anchor=none·사유). 두 경계 노드가 D-ROUTE·D-18 경계를 그래프에 명시.

---

## 5. 2층 매핑 (instance_of 배선·라우팅 축)

| upper_concept(U-) | 브랜드 실물 --instance_of--> | 브랜드 실물 유형 |
|---|---|---|
| `UPPER_SupplierConcept`(U-23) | `supplier-huni`·`wow-supplier-*`·`ext-supplier-*`(E22) | E22 supplier |
| `UPPER_ProductionCapability`(U-24) | `cap-*`(E23·covered_axes→기존 U-4/6/8…) | E23 capability |
| `UPPER_FulfillmentOrder`(U-25) | `ford-*`(E24·형만) | E24 fulfillment_order |
| `UPPER_RoutingCriterion`(U-26) | `criterion-cost`·`-leadtime`·`-capacity`·`-moq`·`-quality`(E-U 하위 or 축노드) | 기준 축 노드 |
| `UPPER_RoutingFunction`(U-27) | `routefn-huni`·`routefn-wow`(E25) | E25 routing_function |

- **레드 확장 안전**: 레드 공급자 추가 = `red-supplier-*`·`cap-red-*` 노드에 instance_of만 → 어휘·스키마 불변(§35 architecture-neutral 승계).
- **가격 축 접합**: RT-5 `quote_from` → 각 supplier의 quote_function(U-18)로. "공급자마다 다른 가격 엔진" = 기존 U-18 경계 재사용(신규 가격 어휘 0).

---

## 6. 경계 규칙 D-ROUTE (D-18 동형·신규 경계 선언)

```
온톨로지 (KB)                                  |  엔진 (권위)
------------------------------------------------|-------------------------
· has_capability / capability_covers (능력 기술)  |
· can_produce (사양⊆능력 포섭 필터·후보 공급자)     |
· RoutingCriterion 축 노드(cost·leadtime·        |  · 기준 값 측정·수집
  capacity·moq·quality) — 축만                    |  · 다목적 스코어링·가중 최적화
· routed_to / quote_from 엣지(관계 존재)          |  · 최종 배정 공급자 결정(값)
· routing_function 경계 노드(anchor=none)         |  · quote 값(U-18 엔진·서버 권위)
```

- **근거**: Cloud-Manufacturing "semantic matching(온톨로지) → multi-objective optimization(엔진)" 2단계(research §2.4·§4.3). 가격 D-18("축·구성요소 연결까지·값은 엔진")과 완전 동형.
- **판정**: 온톨로지가 **후보 공급자를 좁히고 기준 축을 제공**하면 임무 완료. "누가 최종·얼마·며칠"은 엔진(routing_function·quote_function). KB는 배정 값 계산·저장 안 함.

---

## 7. GAP (정직 기록)

- **G-ROUTE-1(최대)**: 실 공급자·능력·라우팅 데이터 부재 → E22~E25 전 노드 **현재 GAP/candidate**. 스키마 형만 제안. 실 앵커 = 공급자 레지스트리(외부 trade printer 능력 프로파일 포함) 확보 = 별도 도메인 작업·인간 결정.
- **G-ROUTE-2**: U-24 ProductionCapability의 XJDF canonical 어휘 부재(XJDF DeviceCapability 구문 폐기·research GAP-ROUTE-1) → JDF 레거시 + MSDL/MaRCO(제조 도메인) 차용. 인쇄 특화 능력 열거 미확정(🟡).
- **G-ROUTE-3**: E24 fulfillment_order는 런타임 주문(라이브) → 온톨로지엔 형만. A 에이전트(추천→주문 경계)와의 접합점 = architect 조율 필요.
- **G-ROUTE-4**: RT-7 brokered_by 승격/접기·후니 다중역할(broker+supplier) 모델링은 architect 결정(§5 권고=접기).
- **G-ROUTE-5**: 관계 폐쇄목록 정식 등재(RT-1~RT-6)·개체 승격(E22~E25)은 **아키텍처 게이트(MB7)+인간 승인** 후 확정(§33 확장이면 스키마 머지·독립이면 §35 시드). 이 문서는 후보 어휘까지·DB 미적재.
- **G-ROUTE-6**: 레드 미포함(후니+와우 2브랜드 검증)·MSDL 원문 403·PrintTalk payload 정밀 스키마 미직독(research GAP-ROUTE-5·6 승계).

## Sources
- `order-routing-fulfillment-ontology-research.md`(4프론트·실 출처 앵커 — 본 제안의 근거)
- §35 `03_upper_ontology/upper-ontology-schema.md`(개체22·관계23·D-18·anchor=none 선례·접기 원칙)·`00_research/upper-ontology-vocabulary.md`(U-1~U-22·instance_of/mapped_to 설계근거)·`standards-playbook.md`(A11 PrintTalk·§1.4 QuoteFunction 표준공백)
- 표준 URL 전량 = research 문서 Sources(CIP4 PrintTalk/JDF·schema.org Order/Offer·MSDL/MaRCO/Cloud-Mfg·인쇄 브로커 실무)
</content>
