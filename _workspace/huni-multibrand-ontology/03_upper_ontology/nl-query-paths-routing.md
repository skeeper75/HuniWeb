# NL 질의 경로 — 라우팅·이행(어느 인쇄소에 넘길까) (§35 Phase 3 확장)

> 작성: 2026-07-04 · mbo-ontology-architect · 방법론 = `mbo-ontology-design` 스킬.
> 승계: §35 `nl-query-paths-multibrand.md`(질의 유형 T1~T4·경로 증명 패턴)·`routing-layer-schema.md`(E22~E25·RT-1~RT-6·U-23~U-27·criterion 5축·D-ROUTE).
> **[HARD] 요구사항**: 라우팅 대표 질의 ≥4를 상위 온톨로지 위 탐색 경로로 증명. **경로 안 그려지면 스키마 결함**(§3으로 환류).
> **[HARD] 경계 D-ROUTE**: 경로는 **can_produce 후보 필터 + criterion 축 제공 + routing_function 호출 지점까지**. 실제 배정값(어느 공급자로 최종·며칠·얼마)·다목적 최적화 = 엔진 권위.
> **[HARD] 정직성**: 실 공급자·능력 데이터 부재(G-ROUTE-1) → **후보 집합은 현재 비어 있음(전 supplier 노드 candidate)**. 경로(그래프 형)는 성립하나 인스턴스 답은 GAP — 이 이중성을 정직하게.
>
> **읽는 법:** 손님이 "이 명함을 최단납기로 뽑을 인쇄소?"라 물으면, 그래프를 어떤 점·선을 따라 순회해 **후보 인쇄소를 좁히고 무엇으로 고를지(기준 축)**까지 만드는지 보인다. 화살표=엣지, `⁻¹`=역방향 탐색, `[E-U]`=상위 개념 경유. 단 "최종 누구·며칠"의 숫자는 온톨로지 밖(엔진)이다.

---

## 0. 질의 유형 (§35 T1~T4 + 라우팅 R1~R2 신설)

| 유형 | 의미 | 경로 축 |
|---|---|---|
| **R1 능력 매칭 라우팅** | 사양 → 이 사양 찍을 수 있는 공급자 후보 | 사양 축 → `capability_covers`⁻¹ → `has_capability`⁻¹ → supplier(can_produce) |
| **R2 기준 기반 배정** | 후보 중 비용/납기/용량/MOQ/품질로 고르기 | R1 후보 → criterion 축(U-26) → routing_function 호출(값=엔진) |
| **R2-x 하도급/외주** | 후니가 못 찍는 사양 → 외부 인쇄소 | 후니 능력 포섭 실패 → ext-supplier can_produce + subcontracts_to |
| **R-교차** | 후니·와우 중 누가 이행·가격+납기 비교 | can_produce 양 브랜드 + quote_from + criterion |

---

## 1. 라우팅 대표 질의 (경로 증명)

### RQ1 (R1·R2) "이 명함 사양(90x50·스노우250·양면·유광코팅·500장)을 최단납기로 뽑을 인쇄소?"
```
[사양 축 분해 — fulfillment_order.spec_axes]
  size:90x50 → [E3 size]      material:스노우250 → [E4 material]
  print_side:양면 → [E5]       process:유광코팅 → [E6 process]   qty:500 → [E8 bundle_qty]

[R1 능력 매칭 — 사양 축값 ⊆ 능력 커버(포섭)]
  각 사양 축 노드 --capability_covers⁻¹(RT-3)--> production_capability 후보
    = "이 축값을 커버하는 능력이 어느 것?"
  production_capability --has_capability⁻¹(RT-1)--> supplier
  ∀ 사양 축 ∈ supplier 능력 커버 집합  →  supplier --can_produce(RT-2)--> 그 명함 상품   # 포섭 성립분만 후보

[R2 기준 축 — 최단납기]
  후보 supplier 집합 → criterion-leadtime [E-U/U-26.2·Offer.deliveryLeadTime]
  routefn-huni --references--> criterion-leadtime   # 라우팅 함수가 이 축 참조
  → routing_function(routefn-huni·E25) 호출 지점                # ★여기까지 온톨로지
```
답: 그래프가 **사양을 커버하는 능력을 가진 공급자로 후보를 좁히고**, "최단납기" = criterion-leadtime 축을 routing_function에 넘기는 지점까지. **실제 며칠·최종 1곳 = 엔진**(D-ROUTE). 지금은 실 공급자 0(G-ROUTE-1) → 후보 집합 candidate·인스턴스 답은 GAP.

### RQ2 (R2) "명함 500장, 가장 싸게 찍을 곳은?"
```
RQ1과 동일하게 can_produce 후보 필터
후보 → criterion-cost [E-U/U-26.1·TCO=인쇄+배송]
routefn-huni --references--> criterion-cost
→ routing_function 호출 (다목적 아님·단일 기준=cost 가중 100%)
```
답: 후보 공급자 + cost 축 제공 → 엔진이 최저비용 배정. **비용 값·순위 = 엔진**(온톨로지는 "cost 축으로 고른다"까지). N-라우팅 참조 N2.

### RQ3 (R2-x·하도급) "후니가 직접 못 찍는 UV인쇄 대형 사양 — 어느 외부 인쇄소로 외주?"
```
[포섭 실패 검출]
  사양 print_method:UV + size:대형 → capability_covers⁻¹
  supplier-huni.has_capability 커버 집합에 UV/대형 ∉  →  supplier-huni can_produce ✗  (포섭 실패)

[외부 공급자 매칭 + 하도급]
  UV/대형을 커버하는 production_capability --has_capability⁻¹--> ext-supplier-* (can_produce ✓)
  supplier-huni --subcontracts_to(RT-6)--> ext-supplier-*   # PrintTalk Subcontracting(신원 은닉 가능)
  fulfillment_order.broker = brand-huni (RT-7 접기)          # 후니=중개자
→ routing_function 호출 (criterion 축으로 외부 후보 중 배정)
```
답: 후니 능력 포섭 실패 → capability_covers로 UV/대형 커버하는 **외부 trade printer** 후보 → subcontracts_to로 하도급 관계. **후니 다중역할(broker)** 실증. 최종 외주처·조건 = 엔진.

### RQ4 (R-교차·T3·T4) "이 사양을 후니와 와우 중 누가 이행? 가격이랑 납기 비교"
```
[양 브랜드 can_produce]
  사양 축 → capability_covers⁻¹ → has_capability⁻¹
    → supplier-huni (can_produce ✓?)   → wow-supplier-* (can_produce ✓?)   # 각 포섭 판정

[가격 — quote_from 브랜드별 엔진]
  fulfillment_order --quote_from(RT-5)--> supplier-huni  --(경유)--> quotefn-huni-evaluate-price [U-18]
  fulfillment_order --quote_from(RT-5)--> wow-supplier-*  --(경유)--> quotefn-wow-jobcost [U-18]
[납기 — criterion 축]
  후보 → criterion-leadtime + criterion-cost → routing_function 호출
[왜 가격 구조 다른가 — 교차관계 재사용]
  quotefn-huni ↔ quotefn-wow: price_model_differs(PMD-1·§35 승계)  # 고정가룩업 vs 조회 API
```
답: 양 브랜드 공급자 후보 + 각 브랜드 엔진 견적 호출(quote_from→quote_function) + 납기/비용 축. **가격·납기 수치 비교 = 각 엔진**(D-18·D-ROUTE). "왜 구조가 다른가"=기존 price_model_differs 재사용. 라우팅 층 + 기존 교차관계가 결합.

### RQ5 (R2·MOQ) "이 사양 300장인데, 최소수량 되는 공급자만?"
```
사양 qty:300 → [E8 bundle_qty/eligibleQuantity]
후보 supplier 능력 → criterion-moq [E-U/U-26.4·Offer.eligibleQuantity]
  능력.moq ≤ 300 ≤ 능력.max_qty 인 supplier만  →  can_produce 유지 (MOQ 포섭)
  moq > 300 인 supplier  →  can_produce ✗ (수량 미달·후보 탈락)
→ routing_function 호출 (남은 후보)
```
답: MOQ = 능력의 수량 커버 구간(bundle_qty 재사용) 포섭 판정 → 300장 못 받는 공급자 자동 탈락. **축(MOQ 개념)은 온톨로지·구간값은 능력 실측(현재 GAP)**.

### RQ6 (R2·다목적 경계 명시) "품질 좋고 납기 빠르고 싼 곳 — 종합해서 추천"
```
후보 supplier(can_produce) → criterion-quality + criterion-leadtime + criterion-cost (3축)
routefn-huni --references--> [criterion-quality, criterion-leadtime, criterion-cost]
→ routing_function 호출 (다목적·가중)                    # ★온톨로지는 3축 제공까지
   ‖ 엔진: multi-objective optimization(가중 스코어링·Pareto) → 최종 1곳    # 경계 밖
```
답: 온톨로지는 **3개 criterion 축을 routing_function에 묶어 넘기는 지점까지**. 실제 가중·다목적 최적화·최종 선택 = 엔진(Cloud-Mfg "semantic matching→multi-objective optimization" 2단계·research §2.4). D-ROUTE 경계 정직 노출.

---

## 2. 답 못하는 시나리오 (경계·정직 거절)

| # | 질의 | 못 답하는 이유 | 정직 응답 |
|---|------|---------------|-----------|
| **N-R1** | "그래서 최종 어느 인쇄소로 갔어? 며칠 걸려?" | 배정값·납기 일수 = 엔진 권위(D-ROUTE). 온톨로지는 후보 필터 + criterion 축까지·최종 배정값 계산 안 함 | "후보 공급자 집합·기준 축(leadtime)까지 제공 — 최종 1곳·일수는 routing_function(엔진) 결과" |
| **N-R2** | "A인쇄소가 B보다 정확히 얼마 싸?" | 값·순위 = 엔진(비용 스코어링). 온톨로지는 criterion-cost 축만 | "cost 축으로 고른다까지 — 값·순위는 엔진 다목적 최적화" |
| **N-R3(최대)** | "지금 이 명함 찍을 수 있는 인쇄소 목록 줘" | **실 공급자·능력 데이터 0**(G-ROUTE-1·라우팅 미도입) → supplier 노드 전부 candidate·후보 집합 비어 있음 | "라우팅 층은 스키마(형)만 완성·**실 공급자 레지스트리 미확보** → 현재 후보 인스턴스 0. 레지스트리 확보(별도 도메인·인간 결정) 후 채워짐" |
| **N-R4** | "이 공급자 지금 용량 여유 있어?" | criterion-capacity는 **실시간 런타임 값**(엔진/MIS) | "capacity 축은 노드화·현재 가용량 값=런타임 엔진(온톨로지 밖)" |
| **N-R5** | "레드프린팅도 이거 찍을 수 있어?" | 레드 미포함(GAP-ROUTE-6) | "레드 supplier 미적재 — red-supplier-* append + instance_of만으로 확장 가능" |
| **N-R6** | "와우 이 상품 하도급 인쇄소가 어디야?" | PrintTalk Subcontracting = 신원 은닉 가능(research §1.1)·데이터 부재 | "하도급 관계(subcontracts_to)는 스키마 존재·실 하도급처 데이터 없음(은닉 정책 + G-ROUTE-1)" |

---

## 3. 경로 증명 요약 (스키마 결함 없음)

- **R1·R2·R2-x·R-교차 전 유형 답됨(형(型) 수준)** — 사양 축 → capability_covers⁻¹ → has_capability⁻¹ → supplier(can_produce 포섭) → criterion 축 → routing_function 호출까지 전 경로 성립.
- **★능력 재사용 검증**: 전 경로가 **기존 축 노드(print_method/material/process/size/bundle_qty)를 capability_covers로 순회** — 새 어휘 없이 라우팅 작동(재발명 0·§8.3 시연).
- **D-ROUTE 경계 준수**: 전 경로 routing_function 호출까지·N-R1/N-R2/N-R4 값 거절(배정값·순위·실시간 용량=엔진).
- **후니 다중역할 실증**: RQ3(subcontracts_to·broker)·RQ4(자기 이행 supplier). 
- **★정직성(최중요)**: 경로(그래프 형)는 전부 성립하나, **실 공급자·능력 인스턴스는 0**(N-R3·G-ROUTE-1). "스키마는 열되 인스턴스는 GAP" — 이 이중성이 지어내기 차단의 핵심. 못 답하는 6종은 전부 **의도적 경계**(배정값·순위·실시간·미적재·은닉)이지 스키마 결함 아님.

## GAP
- **G-RQ-1(최대)**: 실 공급자·능력 데이터 0(G-ROUTE-1) → 전 라우팅 질의는 **경로 설계 증명까지**·실 후보 답은 레지스트리 확보 후. supplier 노드 전부 candidate.
- **G-RQ-2**: fulfillment_order 사양 축은 A 에이전트(추천→주문) 산출을 주입받음 — 접합점 미구현(G-ROUTE-3). 현재 경로는 사양 축이 주어졌다고 가정.
- **G-RQ-3**: criterion 축의 실측값(능력.moq·capacity·leadtime 일수)은 능력 실측·런타임 엔진 후(온톨로지는 축 노드까지·§4.1). 실 질의 응답 품질 = 그래프 빌드·라우팅 엔진 구현 후 실측(DB 미적재).

## Sources
- §35 `03_upper_ontology/routing-layer-schema.md`(E22~E25·RT-1~RT-6·U-23~U-27·criterion 5축·§2 능력 재사용·§6 D-ROUTE·§8 파일럿 노드) — 경로의 스키마 근거
- §35 `03_upper_ontology/nl-query-paths-multibrand.md`(T1~T4 유형·PMD-1 price_model_differs 재사용·N-시나리오 패턴)·`upper-ontology-schema.md`(U-18 quote_function 경계)
- §35 `00_research/structure/order-routing-fulfillment-ontology-research.md`(§2.3 포섭 매칭·§2.4 semantic matching→multi-objective optimization 2단계·§3.2 스코어카드 기준·§1.1 PrintTalk Subcontracting·경계 D-ROUTE)
