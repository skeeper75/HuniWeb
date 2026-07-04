# 주문 라우팅·이행(Order Routing / Fulfillment) 온톨로지 리서치 — 신규 확장 축 (§35 구조 Phase)

> 작성: 2026-07-04 · mbo-standards-researcher · 방법론 = `mbo-standards-research` 스킬.
> **범위(B):** "주문을 어느 인쇄소/공급자에게 배정하나"의 온톨로지·매칭 구조. 추천/가격 연결(A)은 병렬 에이전트.
> **[HARD]** 실 출처 앵커·지어내기 금지·불명확=GAP. search-before-mint(§33/§35·CIP4 기존 어휘 재사용 우선). 경계 동형(D-18): 온톨로지는 능력매칭·기준 축까지, 최적 배정 값은 엔진.
> 상위 원천 재사용: `standards-playbook.md`(CIP4/XJDF·schema.org·config-ontology 채택)·`upper-ontology-vocabulary.md`(U-1~U-22)·`upper-ontology-schema.md`(개체22·관계23).
>
> **읽는 법(비전문가용):** 지금 온톨로지는 "이 고객 질의 → 이 상품 → 이 가격"까지만 안다. 이 문서는 그 뒤에 **"그럼 이 주문을 어느 인쇄소가 실제로 찍나"**를 붙이는 신규 축을 국제 표준·학술로 조사한 것이다. 핵심 통찰: 인쇄소마다 "할 수 있는 것(능력)"이 다르고(어떤 곳은 UV 인쇄가 되고 어떤 곳은 무선제본만 됨), 주문의 사양이 그 능력 안에 들어가는 공급자만 후보가 된다. 이 "사양 ↔ 능력" 맞춤이 이번 축의 심장이다.

---

## 0. 한 장 요약 (채택 표준·경계·GAP)

- **채택 표준 4종**: ① **CIP4 PrintTalk**(RFQ→Quotation→PurchaseOrder→OrderStatus→Invoice·**Subcontracting**·다중 인쇄소 load-balancing) — §33에서 A11 "보류"였던 것을 **라우팅 축 위해 재소환**. ② **JDF DeviceCapabilities**(설비가 수용 가능한 JDF 설정 범위·속도·색수/용지크기 한계·모듈 가용성) — 단 XJDF는 CIP4 정의 capability 구문을 **폐기**하고 XSD에 위임(GAP). ③ **schema.org** Order/OrderItem·seller·**broker**·acceptedOffer·orderDelivery·deliveryLeadTime·eligibleQuantity(MOQ). ④ **제조능력 온톨로지**(MSDL·MaRCO·Product Model matchmaking·Cloud Manufacturing) — 어휘만 차용.
- **핵심 구조**: 공급자의 **능력(Capability)은 이미 온톨로지에 있는 생산 축**(U-4 print_method·U-6 material·U-8 finishing·U-3 size·U-9 binding·U-11 quantity/MOQ)으로 표현된다. 주문 사양의 축값 ⊆ 공급자 능력의 커버 축값 = **can_produce 매칭**(포섭/subsumption). → 라우팅 축은 재발명이 아니라 **기존 생산 축의 재사용 + 공급자 노드**.
- **경계 동형(D-18 → 신규 D-ROUTE)**: 온톨로지 = 후보 공급자 필터(능력 매칭) + 기준 축(비용·납기·능력·MOQ·품질) 노드화까지. 실제 배정 스코어링·다목적 최적화 = **엔진 권위**(값 계산 안 함). Cloud-Manufacturing 학술이 이 경계를 그대로 검증: "semantic matching으로 후보 서비스 검색 → multi-objective optimization으로 자원 배정".
- **표준 공백**: 배정 최적화 함수(RoutingFunction)는 브랜드-중립 표준 어휘가 **없다**(U-18 QuoteFunction과 동형). schema.org에 **ProductionCapability 타입 없음**(seller/broker/provider만 있음) → 능력 개념은 제조 온톨로지(MSDL/MaRCO)에서 차용.
- **최대 GAP**: 후니 라이브에 **공급자·능력 데이터 자체가 없다**(라우팅은 아직 미도입 도메인) → 이 산출은 **설계 근거·구조 제안까지**, 실 공급자 노드는 전부 GAP/candidate. MSDL/MaRCO는 기계가공 도메인 → 인쇄 특화 능력 열거는 미확정.

---

## 1. 프론트 1 — 인쇄 생산/공급 표준 (CIP4)

### 1.1 PrintTalk — 인쇄 주문 거래의 1급 표준 (라우팅 축의 중심 발견)

CIP4 PrintTalk = (X)JDF의 **비즈니스·거래 계층**. "JDF를 감싸는 봉투(envelope)" — 봉투(거래 정보)=PrintTalk, 내용물(제품 기술)=JDF. 인쇄 조달·판매(procurement & vending)를 자동화해 print buyer의 조달 시스템 ↔ print provider의 MIS/ERP를 잇는다.

- **거래 객체 15종**(PrintTalk 2.1): `RFQ`·`Quotation`·`PurchaseOrder`·`Confirmation`·`Refusal`·`Cancellation`·`OrderStatusRequest`·`OrderStatusResponse`·`ProofApprovalRequest/Response`·`ContentDelivery/Response`·`Invoice`·`StockLevelRequest/Response`.
- **표준 플로우**: RFQ(견적요청) → Quotation(견적) → PurchaseOrder(발주) → OrderStatusRequest/Response(상태추적) → Invoice(청구)·결제. 데이터 재입력 없이 end-to-end 자동화.
- **★Subcontracting 모델(라우팅 직결)**: "제조의 일부 또는 전부를 외주(outsourcing)". 투명한 상태 보고를 유지하되, 원하면 **하도급자(subcontractor)의 신원을 최종 고객에게 은닉**. → 후니가 주문을 외부 인쇄소로 넘기는 정확한 표준 모델.
- **★다중 인쇄소 load-balancing**: PrintTalk가 "여러 인쇄 로케이션 간 부하 분산"과 change-order 관리를 지원 → 능력·용량 기반 배정의 거래 프로토콜 근거.
- 출처: [What is PrintTalk (CIP4)](https://www.cip4.org/print-automation/print-talk) · [PrintTalk Specification 2.2 PDF](https://www.cip4.org/files/cip4/documents/PrintTalk%20Specification%202.2.pdf) · [PrintTalk glossary](https://www.cip4.org/glossary/printtalk) (캡처 2026-07-04) · badge ✅(거래 객체·subcontracting 확인) / 🟡(각 객체 정밀 스키마는 스펙 PDF 직독 미완).
- **§33 승계 관계**: standards-playbook §0 표에서 PrintTalk = A11 **"⏸ 보류(주문 체결 어휘 — §24 위임)"**. 이번 라우팅 축이 그 **"다중브랜드 주문 확장 시 재소환"** 조건을 발동 → PrintTalk를 라우팅 축의 표준 이름표로 승격.

### 1.2 (X)JDF DeviceCapabilities — 설비 능력 기술 (능력 매칭의 인쇄 앵커·단 XJDF 폐기)

- **JDF**는 설비가 수용 가능한 JDF 설정의 **범위(range)**를 기술하는 메커니즘 제공: 설비 타입·처리 속도·**한계(색수·용지 크기 제한)**·모듈 가용성(예 duplex 유닛). RIP이 XML capabilities 파일을 제공.
- **★XJDF 변화(GAP)**: XJDF는 **CIP4 정의 capability 구문을 더 이상 제공하지 않고 XSD(XML 스키마)에 위임**. → 인쇄방식·용지·후가공이 "어느 설비/공급자에서 가능한가"를 표현하는 **canonical XJDF 어휘가 없다**. capability는 JDF DeviceCapabilities(레거시)를 이름표 앵커로만 차용.
- **ICS(Interoperability Conformance Specifications)**: 개별 설비 클래스가 (X)JDF·PrintTalk로 무엇을 해야 하는지 최소 기대치 규정 → 능력 프로파일의 표준 근거.
- **JMF(Job Messaging Format)**: job 메시징(상태·큐) — PrintTalk OrderStatus와 상보.
- 출처: [What is (X)JDF (CIP4)](https://www.cip4.org/print-automation/jdf) · [What is an ICS (CIP4)](https://www.cip4.org/print-automation/ics) · [XJDF - evolution of JDF (CIP4 Confluence)](https://cip4.atlassian.net/wiki/spaces/PUB/pages/1192034556/XJDF+-+The+evolution+of+JDF) (캡처 2026-07-04) · badge ✅(DeviceCapabilities 개념·XJDF 폐기 사실) / ⚪(정밀 자원 위치 = GAP-ROUTE-1).

---

## 2. 프론트 2 — 공급자 능력·주문 배정 온톨로지 (학술)

인쇄 버티컬엔 능력 온톨로지가 없어 **제조(manufacturing) 도메인 학술**에서 어휘 차용(어휘만·기술스택 미도입).

### 2.1 MSDL — Manufacturing Service Description Language (공급자 4원 구조)

MSDL = 제조 서비스 기술 상위 온톨로지. 핵심 4원 사슬:
> **ManufacturingService** ─provided-by→ **Supplier** · ─hasCapability→ **ManufacturingCapability** · ─enabledBy→ **ManufacturingResource** · ─deliveredBy→ **ManufacturingProcess**.

→ 라우팅 축의 노드 골격 직대응: `Supplier`(공급자)·`Capability`(능력)·`Resource`(설비/자원)·`Process`(공정, 후니 U-8과 동형).
- 출처: [An Upper Ontology for Manufacturing Service Description (ResearchGate/Semantic Scholar)](https://www.semanticscholar.org/paper/3a54ba797d597b0cac83707901f4edc8efb21ea3) (캡처 2026-07-04) · badge 🟡(구조 2차 확인·원문 403).

### 2.2 MaRCO — Manufacturing Resource Capability Ontology (능력 합성 추론)

OWL 기반. 자원의 능력을 기술하고 **단순 능력들의 표현으로부터 결합 능력(combined capability)을 자동 추론**. 자원 벤더는 MaRCO로 자기 제품 기능을 비교가능하게 기술, 통합자·사용자는 특정 생산 니즈에 맞는 후보 자원·자원 조합을 빠르게 식별.
- 출처: [The development of an ontology for describing the capabilities of manufacturing resources (J. Intelligent Manufacturing, Springer)](https://link.springer.com/article/10.1007/s10845-018-1427-6) (캡처 2026-07-04) · badge 🟡.

### 2.3 Product Model ontology + Capability-based Matchmaking (사양↔능력 매칭 = 심장)

Järvenpää/Siltala 계열. **제품 요구(product requirement) vs 자원 능력(resource capability)**을 규칙으로 비교해 매칭. **★매칭 방식 = 개념명 수준 포섭(subsumption)**: "요구된 process 클래스 또는 그 하위 클래스에 속하는 능력 인스턴스"를 매칭. SWRL 규칙으로 명시 안 된 능력 추론, reasoner(SPIN/SPARQL)로 후보 필터·대안 시나리오 생성.
- → 라우팅 매칭의 학술 근거: **주문 사양의 축값이 공급자 능력 축값의 (하위)집합이면 can_produce**. 온톨로지는 여기(필터)까지.
- 출처: [Product Model ontology and its use in capability-based matchmaking (ScienceDirect)](https://www.sciencedirect.com/science/article/pii/S2212827118303718) · [Tampere Univ Research Portal](https://researchportal.tuni.fi/en/publications/product-model-ontology-and-its-use-in-capability-based-matchmakin/) · [Semantic rules for capability matchmaking (Taylor&Francis)](https://www.tandfonline.com/doi/full/10.1080/0951192X.2022.2081361) (캡처 2026-07-04) · badge ✅(매칭 원리·subsumption).

### 2.4 Cloud Manufacturing 서비스 발견·매칭 (경계선을 그은 학술)

클라우드 제조: 서비스 제공자가 공개한 서비스 풀에서 **요구 온톨로지 vs 자원 기술을 semantic matching**으로 후보 검색 → **multi-objective optimization으로 자원 배정**. 두 단계가 명확히 분리 = **온톨로지(매칭) / 엔진(최적 배정)** 경계의 직접 증거.
- 출처: [Research on Cloud Manufacturing Service Discovery Based on Ontology (ResearchGate)](https://www.researchgate.net/publication/271970280) · [Matching of Manufacturing Resources in Cloud Manufacturing (MDPI Symmetry 13(10):1970)](https://www.mdpi.com/2073-8994/13/10/1970) · [Ontology-Based Cloud Manufacturing Framework (CEUR FOMI)](https://ceur-ws.org/Vol-2969/paper41-FOMI.pdf) (캡처 2026-07-04) · badge ✅(2단계 분리).

---

## 3. 프론트 3 — 주문 이행 표현 (schema.org·전자상거래)

### 3.1 schema.org Order / OrderItem / Offer (LLM 공용어·이행 이름표)

| schema.org 어휘 | 정의(발췌) | 타입 | 라우팅 역할 |
|---|---|---|---|
| **Order.seller** | "An entity which offers (sells/leases…) the services/goods" | Organization / Person | 배정 결과 = 주문을 이행하는 인쇄소 |
| **Order.broker** | "An entity that **arranges for an exchange between a buyer and a seller**" | Organization / Person | ★후니 = broker(중개·라우터). 자기 이행 시 seller 겸함 |
| **Order.acceptedOffer** | "The offer(s) — product, quantity, price combinations — in the order" | Offer | 공급자별 가격 제안(U-16/U-18 경유) |
| **Order.orderedItem** | "The item ordered" | OrderItem / Product / Service | 사양 담체(라우팅 입력) |
| **Order.orderDelivery** | "The delivery of the parcel…" | ParcelDelivery | 납기·배송 기준 |
| **Order.orderStatus** | "The current status of the order" | OrderStatus | PrintTalk OrderStatus와 동형 |
| **OrderItem** | orderItemNumber·orderQuantity·orderItemStatus·orderDelivery | — | 주문 항목 단위 |
| **Offer.deliveryLeadTime** | "typical delay between receipt of order and goods leaving warehouse" | QuantitativeValue | ★라우팅 기준 축 = 납기(lead time) |
| **Offer.eligibleQuantity** | "interval and unit of ordering quantities for which the offer is valid" | QuantitativeValue | ★MOQ·수량 유효구간(공급자 제약) |
| **Offer.seller / areaServed / availability** | — | — | 공급자·서비스 지역·가용성 |

- 출처: [schema.org/Order](https://schema.org/Order) · [schema.org/OrderItem](https://schema.org/OrderItem) · [schema.org/Offer](https://schema.org/Offer) · [schema.org/deliveryLeadTime](https://schema.org/deliveryLeadTime) · [schema.org/eligibleQuantity](https://schema.org/eligibleQuantity) (캡처 2026-07-04) · badge ✅(어휘 실재).
- **★GAP-ROUTE-2**: schema.org에 **"ProductionCapability"·"can produce" 타입이 없다**. seller/broker/provider(주체)·Offer(제안)·deliveryLeadTime/eligibleQuantity(기준)는 있으나, "이 공급자가 UV인쇄·무선제본을 할 수 있다"는 **능력 자체를 표현할 schema.org 어휘가 없음** → 능력 개념은 MSDL/MaRCO(§2)에서 차용.
- **GS1/전자상거래**: eCl@ss·GS1 GPC는 상품 분류 식별자(카테고리 외부 앵커)까지 — 공급자 배정 자체 어휘는 아님(standards-playbook GAP-STD-4 승계·미조사).

### 3.2 라우팅 결정 기준(criteria) 노드화 — 공급자 스코어카드

공급자 선택 다기준(multi-criteria) 표준 실무: **총비용(TCO)·납기(lead time)·용량/가용성(capacity)·품질(불량률)·정시납품률**. 가중 스코어카드로 후보 비교(가중치=기업 목표). → 라우팅 기준 축(RoutingCriterion) 노드 셋의 근거. **단 값·가중·스코어링은 엔진**(§4 경계).
- 출처: [Supplier Evaluation and Selection Criteria (ISM)](https://www.ism.ws/logistics/supplier-evaluation/) · [Supplier Scorecard Criteria (GraphiteConnect)](https://www.graphiteconnect.com/blog/5-supplier-performance-criteria-every-scorecard-should-include) (캡처 2026-07-04) · badge ✅(기준 축).

---

## 4. 프론트 4 — 매칭/최적화 경계 (베스트프랙티스·D-18 동형)

### 4.1 인쇄 브로커 소프트웨어 실무 (auto-routing)

인쇄 브로커 SW는 각 주문을 **가격·재고·납기·위치** 기반으로 최적 벤더에 **자동 라우팅**(주문당 30분 절감). 브로커는 라우팅 전 마진·마크업 규칙(카테고리별)을 설정. Sage/ASI 등 aggregator와 연결해 실시간 재고·단가 취득. gang-run 스케줄링·rush order를 단일 MIS 파이프라인에서 관리.
- 출처: [Print Broker Software — Automate Vendor Routing (PrintXpand)](https://www.printxpand.com/print-broker-software/) · [Cloud Print MIS for Brokers (PrintPlanr)](https://www.printplanr.com/cloud-print-mis-for-print-brokers/) (캡처 2026-07-04) · badge ✅(auto-routing 실무).

### 4.2 인쇄 벤더 실시간 선택 특허 (라우팅 기준 집합의 실물 근거)

USPTO 8,861,005 — "복수 인쇄 서비스 벤더 중 **가장 경제적으로 실현가능한** 벤더의 실시간 발견·선택·계약(engagement) 방법". 시스템이 **현재 작업 용량 능력·납기 추정·과거 생산시간·인쇄+배송 비용 추정**을 취득해 상품별 최적 벤더 선택. → 라우팅 기준 축(capacity·lead_time·cost)의 실물 앵커.
- 출처: [USPTO Patent 8,861,005](https://image-ppubs.uspto.gov/dirsearch-public/print/downloadPdf/8861005) (캡처 2026-07-04) · badge 🟡(특허·상용 구현 근거).

### 4.3 경계선 베스트프랙티스 (D-18 → D-ROUTE)

| 층 | 소속 | 근거 |
|---|---|---|
| **후보 공급자 필터**(사양⊆능력·can_produce) | **온톨로지** | Product Model matchmaking §2.3(포섭)·Cloud-Mfg §2.4(semantic matching) |
| **기준 축 노드**(cost·lead_time·capacity·MOQ·quality) | **온톨로지**(축만·값 아님) | 스코어카드 §3.2·특허 §4.2(기준 집합) |
| **능력↔생산축 커버리지**(capability_covers → U-4/U-6/U-8…) | **온톨로지** | MSDL/MaRCO §2.1-2.2·기존 축 재사용 |
| **실제 배정 스코어링·다목적 최적화**(비용×납기×용량 가중) | **엔진**(값 권위) | Cloud-Mfg §2.4("multi-objective optimization")·브로커 SW §4.1(마진규칙 엔진) |
| **가격 값**(공급자별 견적) | **엔진**(U-18 QuoteFunction·서버 권위) | §33 D-18 승계·standards-playbook §1.4 |

- **경계 동형 확정**: 가격 축(D-18)이 "축·구성요소 연결까지·값은 엔진"이듯, 라우팅 축도 **"능력 매칭·기준 축까지·배정 값은 엔진"**. Cloud-Manufacturing 학술의 "semantic matching → multi-objective optimization" 2단계가 이 경계를 표준 문헌으로 검증. → **신규 경계 규칙 D-ROUTE(D-18 동형)**.

---

## 5. GAP (정직 기록)

- **GAP-ROUTE-1**: XJDF가 CIP4 정의 device capability 구문 폐기(XSD 위임) → 인쇄 능력의 **canonical XJDF 어휘 부재**. JDF DeviceCapabilities(레거시)를 이름표 앵커로만 차용. 정밀 자원 위치 미확정.
- **GAP-ROUTE-2**: schema.org에 ProductionCapability/can-produce 타입 없음 → 능력 개념은 MSDL/MaRCO(제조·기계가공 도메인)에서 차용. **인쇄 특화 능력 열거는 미확정**(brand 실증 필요).
- **GAP-ROUTE-3(최대)**: 후니·와우·레드 라이브에 **공급자·능력·라우팅 데이터 자체가 없다**(라우팅 미도입 도메인). 이 산출은 **구조·근거 제안까지**, 모든 Supplier/Capability 노드는 실 앵커 부재 → 전부 GAP/candidate(닫힌세계 유지·지어내기 차단). 실 공급자 레지스트리 확보 = 별도 도메인 작업.
- **GAP-ROUTE-4**: RoutingFunction(배정 최적화)은 U-18 QuoteFunction처럼 **브랜드-중립 표준 어휘 공백**. 각사 MIS/브로커 SW 고유(표준화 안 됨).
- **GAP-ROUTE-5**: MSDL 원문 403(ResearchGate 차단) → 4원 구조는 2차 확인(🟡). 정밀 관계명(provided-by/hasCapability/enabledBy/deliveredBy)은 원논문 직독 시 확정.
- **GAP-ROUTE-6**: PrintTalk 15 거래 객체의 정밀 스키마(RFQ/Quotation payload)는 스펙 PDF 2.2 직독 미완(🟡). subcontracting·load-balancing은 개요 수준 확인.

## Sources
- **CIP4/XJDF/PrintTalk**: [PrintTalk (CIP4)](https://www.cip4.org/print-automation/print-talk) · [PrintTalk Spec 2.2](https://www.cip4.org/files/cip4/documents/PrintTalk%20Specification%202.2.pdf) · [What is (X)JDF](https://www.cip4.org/print-automation/jdf) · [ICS](https://www.cip4.org/print-automation/ics) · [XJDF evolution (Confluence)](https://cip4.atlassian.net/wiki/spaces/PUB/pages/1192034556/XJDF+-+The+evolution+of+JDF)
- **제조 능력 온톨로지**: [MSDL Upper Ontology (Semantic Scholar)](https://www.semanticscholar.org/paper/3a54ba797d597b0cac83707901f4edc8efb21ea3) · [Capabilities ontology (Springer JIM 10845-018-1427-6)](https://link.springer.com/article/10.1007/s10845-018-1427-6) · [Product Model matchmaking (ScienceDirect S2212827118303718)](https://www.sciencedirect.com/science/article/pii/S2212827118303718) · [Semantic rules for capability matchmaking (T&F)](https://www.tandfonline.com/doi/full/10.1080/0951192X.2022.2081361) · [Cloud Mfg Matching (MDPI Symmetry 13/10/1970)](https://www.mdpi.com/2073-8994/13/10/1970) · [Ontology Cloud Mfg (CEUR FOMI)](https://ceur-ws.org/Vol-2969/paper41-FOMI.pdf)
- **schema.org 이행**: [Order](https://schema.org/Order) · [OrderItem](https://schema.org/OrderItem) · [Offer](https://schema.org/Offer) · [deliveryLeadTime](https://schema.org/deliveryLeadTime) · [eligibleQuantity](https://schema.org/eligibleQuantity)
- **매칭·배정 실무**: [PrintXpand Broker Routing](https://www.printxpand.com/print-broker-software/) · [PrintPlanr Broker MIS](https://www.printplanr.com/cloud-print-mis-for-print-brokers/) · [USPTO 8,861,005](https://image-ppubs.uspto.gov/dirsearch-public/print/downloadPdf/8861005) · [ISM Supplier Evaluation](https://www.ism.ws/logistics/supplier-evaluation/) · [Supplier Scorecard (GraphiteConnect)](https://www.graphiteconnect.com/blog/5-supplier-performance-criteria-every-scorecard-should-include)
- **§35 원천**: `00_research/standards-playbook.md`(A11 PrintTalk 보류·§1.4 QuoteFunction 표준공백·D-18)·`upper-ontology-vocabulary.md`(U-1~U-22)·`03_upper_ontology/upper-ontology-schema.md`(개체22·관계23·D-18)
</content>
</invoke>
