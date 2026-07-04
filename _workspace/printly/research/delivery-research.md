# 프린틀리 — (경량) 인쇄배송 그릇 리서치 (프론트 5)

> 작성: 2026-07-04 · mbo-standards-researcher (프린틀리 확장) · 방법론 = `mbo-standards-research` 스킬.
> **[HARD] 이번엔 스키마/그릇 수준 리서치만**(지니 지시 — 깊이 X). 프린틀리 ⑦ delivery 그릇 근거·표준 이름표 후보까지.
> **[HARD] 실 출처 앵커·지어내기 금지·불명확=GAP.** schema.org 1차 URL(캡처 2026-07-04). §35 라우팅 층이 이미 건 이름표 재사용(search-before-mint).
> **[HARD] 경계**: 온톨로지는 배송 **방식·리드타임 축**까지. 배송비·정확 리드타임 **값 계산 = 결정론 엔진**(원칙3·§35 D-18/D-ROUTE 동형). 값 계산 안 함.
>
> **읽는 법(비전문가용):** 견적·생산 다음은 "언제·어떻게 고객에게 가나"(배송)다. 이번엔 배송을 깊게 안 파고, **어떤 칸(그릇)이 필요한지**만 국제 웹커머스 표준(schema.org)에서 이름표를 빌려 정한다. 실제 "며칠 걸림·얼마" 계산은 온톨로지 밖(엔진)이다.

---

## 0. §35 승계 — 이미 건 배송 이름표 (재조사 금지)

§35 라우팅 층이 배송 관련 이름표를 **이미 앵커**했다(`routing-layer-schema.md` §4.1 RoutingCriterion). 프린틀리 ⑦ delivery는 이를 재사용·구체화:

| §35 기존(재사용) | 내용 | 프린틀리 ⑦ delivery 접점 |
|---|---|---|
| `criterion-leadtime`(U-26.2) | 납기 축 = schema.org **Offer.deliveryLeadTime**(QuantitativeValue) | ⑦ `lead_time` 속성 = 이 이름표 그대로 |
| `criterion-cost`(U-26.1) | 총비용(인쇄+배송 TCO) | ⑦ `cost_axis`(값=엔진 경계) |
| `fulfillment_order`(E24) | 이행 주문(schema.org Order·PrintTalk PO) | ⑦ delivery가 붙는 주문 담체 |
| D-ROUTE 경계 | 배정·값=엔진 | 배송비/정확 리드타임 값=엔진(동형) |

**프린틀리 추가 임무** = 배송 **방식(method)** 축과 리드타임의 **2분해**(생산 리드타임 vs 배송 리드타임)를 schema.org 이름표로 명시.

---

## 1. schema.org 배송 어휘 (⑦ delivery 그릇 표준 근거)

인쇄배송도 결국 "물건을 고객에게 보내는" 커머스 배송 — schema.org 배송 어휘가 브랜드-중립 이름표를 제공한다(§35 schema.org 채택 승계).

| schema.org 어휘 | 의미 | ⑦ delivery 속성 매핑 | 출처 |
|---|---|---|---|
| **DeliveryMethod** (Enumeration) | 배송 방식 표준 절차(운송수단·계약주체별) | `method`(택배/퀵/방문수령) | [schema.org/DeliveryMethod](https://schema.org/DeliveryMethod) |
| **ParcelDelivery** | 우편/상업 택배로 소포 배송 | `method=parcel`(택배) 세분 | [schema.org/ParcelDelivery](https://schema.org/ParcelDelivery) |
| **ShippingDeliveryTime** | 배송 시간 정보 묶음 | `delivery_time` 컨테이너 | [schema.org/ShippingDeliveryTime](https://schema.org/ShippingDeliveryTime) |
| **deliveryLeadTime** (property) | 주문 수령→**출고**(창고 떠남/픽업 준비) 지연 | `production_lead_time`(생산 리드타임) | [schema.org/deliveryLeadTime](https://schema.org/deliveryLeadTime) |
| **deliveryTime** (property) | 주문 수령→**고객 도착** 총 지연 | `total_lead_time`(전체 리드타임) | [schema.org/deliveryTime](https://schema.org/deliveryTime) |
| **hasDeliveryMethod** (property) | 배송/발송에 쓰인 방식 | delivery↔method 연결 관계 | schema.org (검색 결과 확인) |
| **Order** | 주문(§35 E24 fulfillment_order 승계) | ⑦가 붙는 주문 | [schema.org/Order](https://schema.org/Order) |

### 1.1 ★핵심 발견 — 리드타임 2분해 (인쇄업 특성)

schema.org가 **`deliveryLeadTime`(출고까지)와 `deliveryTime`(고객 도착까지)을 구분**한다. 이는 인쇄업에 정확히 들어맞는다:

```
주문 접수 ──[생산 리드타임]──> 출고(찍고 후가공 끝) ──[배송 리드타임]──> 고객 도착
           = deliveryLeadTime                        = (deliveryTime − deliveryLeadTime)
           ↑ 프린틀리 핵심(장비/공정/제본이 결정)        ↑ 택배사/지역이 결정
                                    총 = deliveryTime
```

- **인쇄배송의 리드타임은 2층** — ① **생산 리드타임**(주문→출고: 인쇄방식·후가공·제본 복잡도가 결정·프린틀리 도메인 핵심) + ② **배송 리드타임**(출고→도착: 택배/퀵/지역). schema.org가 이 2분해 이름표(`deliveryLeadTime` vs `deliveryTime`)를 그대로 제공. → ⑦ delivery 그릇은 두 축을 별 슬롯으로.
- **§35 criterion-leadtime과 정합**: §35 라우팅은 공급자 선택 기준으로 `deliveryLeadTime`을 이미 앵커 — 프린틀리는 같은 이름표를 **고객 대면 배송 옵션**으로 재사용(축 동일·용도 확장).

---

## 2. ⑦ delivery 그릇 속성 후보 (표준 이름표 부착)

01_step1-entities.md ⑦ 초안 속성 + schema.org 이름표:

| ⑦ delivery 속성(초안) | 표준 이름표 | 값 예 | 경계 |
|---|---|---|---|
| `method` | schema.org **DeliveryMethod / ParcelDelivery** | 택배·퀵·방문수령·화물 | 축(온톨로지) |
| `production_lead_time` | schema.org **deliveryLeadTime** | 1~5영업일(공정 복잡도별) | 축 이름만·값=엔진 |
| `total_lead_time` | schema.org **deliveryTime** | 생산+배송 합 | 축 이름만·값=엔진 |
| `region` | schema.org **areaServed**(§35 supplier 승계) | 전국·수도권·지역 | 축 |
| `cost_axis` | (schema.org **ShippingRateSettings** 계열·미조사) | (값=엔진) | ★값=엔진 경계 |
| `badge` | (닫힌세계) | candidate | 데이터 대기(Q6) |

- **★경계(원칙3·§35 D-18 동형)**: 온톨로지는 **배송 방식·리드타임 축·지역 축**(이름)까지. **정확 며칠·정확 얼마 = 엔진**(택배사 API·후니 배송정책). `delivery_function` 경계 노드 후보(quote_function·routing_function·preflight_function 동형·anchor=none·값=엔진). architect 확정.
- **cost_axis 표준**: schema.org에 `ShippingRateSettings`·`MonetaryAmount`·`DeliveryChargeSpecification` 등 배송비 어휘가 있으나 **이번 경량 범위에서 미조사**(GAP) — 값 계산은 어차피 엔진 경계라 이름표만 후속.

---

## 3. 인쇄업 배송 관행 (경량 스케치·그릇 검증용)

> ★경량 — 깊이 X. ⑦ 그릇이 실무를 담는지 sanity check만.

- **인쇄업 배송 = "생산 완료 후 발송"** 모델이 지배적 — 재고 없이 주문생산(MTO)이라 리드타임의 대부분이 **생산 리드타임**(deliveryLeadTime). 이것이 인쇄 견적 사이트가 "○일 발송" 표기의 실체(생산 완료 시점).
- **방식 축**: 택배(parcel·기본)·퀵/당일(급송·수도권)·방문수령(픽업·deliveryLeadTime의 픽업 케이스)·화물(대형 실사·현수막). → ⑦ `method` enum이 커버.
- **§35 supplier/routing과의 접합**: 배송은 어느 인쇄소가 이행하나(§35 supplier·routing_function)와 엮인다 — 공급자별 `areaServed`·생산 리드타임이 라우팅 기준(criterion-leadtime). ⑦ delivery는 **fulfillment_order(E24)에 붙는 이행 결과 축**(§35 라우팅 층 하위).
- **GAP-PRINTLY-DEL1**: 후니·와우·레드 실 배송정책·리드타임 데이터 **미확보**(Q6 미확정) — ⑦ delivery 노드는 스키마 형(型)만·anchor=none+candidate(§35 G-ROUTE-1 닫힌세계 승계).

---

## 4. GAP (정직 기록)

- **GAP-PRINTLY-DEL1**: 실 배송정책·리드타임·배송비 데이터 0(Q6 미확정·지니 배송 범위 확정 대기) — 그릇 형만.
- **GAP-PRINTLY-DEL2**: schema.org 배송비 어휘(`ShippingRateSettings`·`DeliveryChargeSpecification`)·정확 리드타임 계산은 **경량 범위 밖**(값=엔진 경계라 후속). 이번엔 방식·리드타임 2분해 축까지만.
- **GAP-PRINTLY-DEL3**: `delivery_function` 경계 노드는 후보(§2) — 정식 승격은 architect + MB7 게이트 후. 배송비/정확 리드타임 값 계산이 실제 엔진 경계인지 최종 확정 대상.
- **경계 확정**: 이번 산출은 **⑦ delivery = schema.org 이름표 부착된 그릇 + 리드타임 2분해**까지. 실배송 연동·배송비 계산은 후속(원칙3 엔진 경계).

## Sources (실 출처 앵커·캡처 2026-07-04)

**§35 승계(읽기·재사용):**
- §35 `03_upper_ontology/routing-layer-schema.md`(criterion-leadtime U-26.2·criterion-cost·E24 fulfillment_order·D-ROUTE·areaServed·G-ROUTE-1)

**schema.org 1차:**
- [schema.org/DeliveryMethod](https://schema.org/DeliveryMethod) · [schema.org/ParcelDelivery](https://schema.org/ParcelDelivery) · [schema.org/ShippingDeliveryTime](https://schema.org/ShippingDeliveryTime) · [schema.org/deliveryLeadTime](https://schema.org/deliveryLeadTime) · [schema.org/deliveryTime](https://schema.org/deliveryTime) · [schema.org/Order](https://schema.org/Order)

**프린틀리 그릇:**
- `_workspace/printly/01_step1-entities.md`(⑦ delivery 속성 초안)·`00_step0-concept-normalization.md`(Q6 배송 범위 대기)
