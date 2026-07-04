# 표준 매핑 델타 — §33 standards-mapping 대비 다중브랜드 보강분 (§35 Phase 1)

> 작성: 2026-07-04 · mbo-standards-researcher.
> **[HARD] 이 문서는 §33 표준 매핑의 "델타"만 담는다.** 승계분은 재기술하지 않고 원천을 가리키며, 다중브랜드(와우/레드)를 위해 **추가·수정된 것만** 명시(승계/신규 구분).
> §33 표준 매핑의 실체: 전용 `standards-mapping.md` 파일은 **아직 승격되지 않았고**(§33 `03_kb/standards/README.md`는 자리표시), 실 원천은 ① `02_ontology/ontology-schema.md` §1 "표준 이름표" 열 ② `00_research/product-ontology.md` ②-5 매핑표. 이 델타는 그 둘을 기준선으로 삼는다.

---

## 0. 승계 확인 (변경 없이 그대로 씀 — 재조사 금지)

§33 product-ontology ②-5 매핑표(a~d 4계층)와 ontology-schema §1 표준 이름표 열을 **전량 승계**. 아래는 브랜드-중립적으로 여전히 유효함이 와우 증거로 재확인된 항목:

| §33 매핑 | 와우 증거로 재확인 |
|---|---|
| product = schema.org Product = config-ontology component type | 와우 prodno도 동일 그릇 ✅ |
| size = XJDF FinishedDimensions | 와우 sizeinfo(재단·비규격 w/h) 동형 ✅ |
| material = XJDF MediaIntent = resource | 와우 paperinfo(papergroup·pgram) 동형 ✅ |
| 도수 = XJDF ColorIntent | 와우 colorinfo(colorno·colornoadd 별색) 동형 ✅ |
| 후가공 = XJDF Process/Finishing Intent = function→process | 와우 awkjobinfo(2단 중첩) 동형 ✅ |
| 제본 = XJDF BindingIntent | 와우 책자 제본 그룹 동형 ✅ |
| 판걸이 = XJDF Imposition/number-up | 와우 pjoin(합판/독판) 동형 ✅ |
| constraint = config-ontology constraint | 와우 인라인 req_/rst_ 동형 ✅ |
| 동적 가격 = 표준 어휘 없음(evaluate_price 블랙박스) | 와우 jobcost도 동일(표준 공백 재확인) ✅ |
| Product vs Offer 분리·variesBy 차원 선언 | 와우 catalog(상품) vs jobcost(가격) 분리 동형 ✅ |

→ **§33 표준 채택이 브랜드-중립적으로 타당**함을 다중브랜드 증거가 검증(반증 0). §35는 "재발명"이 아니라 "확장 + 교차 재확인".

---

## 1. 신규 보강분 (표준 근거 있는 추가만)

`standards-playbook.md` §3 델타 6종·`upper-ontology-vocabulary.md` 신규 개념과 1:1.

| ID | 신규 표준 매핑 | 표준 근거 | §33에 없던 이유 | 다중브랜드 필요성 |
|---|---|---|---|---|
| **D-U4** | `PrintMethodIntent` = XJDF Process View(합판/독판·옵셋/디지털/UV/INDIGO) | XJDF Process View 자원(🟡 GAP-STD-2) | §33은 인쇄방식을 print_option에 접음("비절대축") | 와우 prsjob = 가격결정·교차제약 1급 축 → 대등 상위 필요 |
| **D-U7** | `ImpositionStrategy` = XJDF Imposition/number-up·gang-run | XJDF Imposition | §33은 판형/fn_calc_pansu로 암묵 | 와우 pjoin 명시 축 → 상위 명시 |
| **D-U2** | `ConfigurabilityClass` = config-ontology configurable vs non-configurable | Soininen/Felfernig | §33 prd_typ은 후니 고유 5분류(표준 직대응 없음 주석뿐) | 와우 selType(M/S)과 공통 상위로 정렬 |
| **D-U14+** | `AccessoryComponent` 2채널 경계(prodadd vs option) | schema.org isAccessoryOrSparePartFor | §33 has_addon 단일 채널 | 와우 부자재 2필드 경계 명시(GAP-STRUCT-2) |
| **D-U15+** | `CrossAxisConstraint` 세분성=option-item | config-ontology constraint | §33 constraint 상품/그룹 단위 | 와우 req_/rst_ = option-item 인라인 세분 |
| **D-U18** | `QuoteFunction` = 표준 공백 명시(동적 가격 경계) | (표준 없음 — 명시적 공백) | §33은 evaluate_price 경계만(단일 브랜드) | 양 브랜드 공통 메커니즘 = 브랜드-중립 상위로 승격 |
| **D-U20** | `ProductFamily` = 상품군 교차정렬 축 | schema.org category 상위 | §33은 카테고리 트리만 | 후니↔와우 상품군 `same_family_as` 교차의 기준선 |
| **D-U22** | `BrandNode` = schema.org brand(Organization) | schema.org brand | §33 단일 브랜드(전 노드 huni 암묵) | 3브랜드 출처 구분 축 |

## 2. 신규 관계 (§33 관계 폐쇄목록 대비)

| ID | 신규 관계 | §33 대비 | 근거 |
|---|---|---|---|
| **X-1** | `instance_of`(브랜드노드→상위개념) | §33 19종에 없음 | 2층(상위-하위) 연결 필수 엣지 |
| **X-3** | `same_family_as`(product↔product) | §35 규칙 신설 | 교차브랜드 상품군 대응 |
| **X-4** | `price_model_differs`(formula↔formula) | §35 규칙 신설 | 교차브랜드 가격모델 차이 |
| **X-5** | `component_differs`(component↔component) | §35 규칙 신설 | 교차브랜드 구성요소 차이 |

- `mapped_to`(X-2)는 §33 §9 동사에 이미 있음 → **승계**(신규 아님).

## 3. §33 무손상 확인 [HARD]

- 이 델타는 §33 `02_ontology/`·`03_kb/` 파일을 **읽기만** 했고 수정하지 않았다(§35 규칙: §33 골든 자산은 아키텍처 결정 전까지 수정 금지).
- 신규 상위 개념/관계는 §35 `00_research/`에만 산출. §33 스키마에 실제 반영할지는 Phase 4 아키텍처 게이트(§33 확장 vs 독립) + 인간 승인 후 architect가 결정.

## GAP
- **GAP-DELTA-1**: §33 전용 `standards-mapping.md`가 미승격(자리표시 상태) → 이 델타의 기준선이 2개 문서에 분산. 아키텍처 결정 시 §33 표준 매핑을 1페이지로 승격하며 이 델타를 병합할지 architect 판단.
- **GAP-DELTA-2**: 레드프린팅 미포함 → 신규 8개는 후니+와우 2브랜드 검증. 레드 추가 시 델타 재점검(append).

## Sources
- §33 `00_research/product-ontology.md` ②-5(a~d)·`02_ontology/ontology-schema.md` §1·§6 — 승계 기준선
- §35 `00_research/standards-playbook.md`(§3 델타 6종)·`upper-ontology-vocabulary.md`(U-1~U-22·X-1~X-5)
- §35 `01_analysis/` 와우 분석 3종(6+2축·quoted·family)
