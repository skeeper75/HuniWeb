# HANDOFF — Huni-Multibrand-Ontology (§35) · 2026-07-04 (2nd)

## 다음 시작점

**Phase 1~5 완주 + 구조 리서치 + 라우팅 층 설계·검증까지 완료.** 다음 세션 시작점 후보(사용자 선택):
1. **intent(용도) 원자 분해 파일럿** — 구조 리서치 최우선 권고(키스톤·AliCoCo). 한 상품군(명함/청첩장)에서 용도를 원자 기능으로 분해 → 추천 정밀도 실증. search-before-mint상 **속성으로 먼저**(D1 결정), 파일럿 후 노드 승격 판정.
2. **아키텍처 게이트(MB7) 정식 통과 + 개체/관계 승격** — 라우팅 E22~E25·RT-1~6, 상위개체 E18~E21 정식 등재는 **인간 승인** 후. 결정=독립 시작 후 통합(옵션 C) 이미 확정.
3. **구조 권고 게이트 검증** — 이번 구조 리서치·권고(개선/보완/확장/수정)를 mbo-verify-gate로 아직 독립 검증 안 함(라우팅 층만 검증됨).

## 사용자 확정 결정 (relitigate 금지)

1. **아키텍처 = 독립 시작 후 나중에 통합**(옵션 C). §33 골든 보호 + 와우 노후 격리 → 안정화 후 단일 그래프 머지. Phase 3 스키마·라우팅 층 모두 architecture-neutral(어느 쪽이든 재작업 0).
2. **★북극성**: 자연어 질의 → **원자 단위 의미 연결** → 상품 추천 + 가격 → **(추후) 어느 인쇄소에 주문 넘길지 라우팅**. 참조=uEngine Ontology Studio.
3. **상위 온톨로지·표준 먼저**(기존)·라우팅은 "추후"(형만 열고 데이터는 공급자 레지스트리 확보 후).

## 산출 현황 (2026-07-04)

- `00_research/` — standards-playbook·upper-ontology-vocabulary(22개념)·standards-mapping-delta + **`structure/`(5파일: recommendation-configuration-kg·ontology-studio-comparison·structure-recommendations·order-routing-fulfillment·routing-schema-proposal)**.
- `01_analysis/` + `_cache/`(13 CSV) — 와우 47카테고리·326상품 전량 quoted(jobcost)·6+2축·손전사0.
- `02_crossbrand/` — family-alignment(16쌍)·difference-matrix(4대 델타)·crossbrand-edges.
- `03_upper_ontology/` — upper-ontology-schema(E1~E21+E-U·관계23)·brand-anchor-spec·crossbrand-relations·nl-query-paths-multibrand + **routing-layer-schema(E22~E25·RT-1~6·폐쇄목록29)·nl-query-paths-routing(RQ1~6)**.
- `04_verification/` — gate-verdict-MB(MB1~7 GO)·architecture-recommendation + **gate-verdict-routing(GO 7/7)**.

## 핵심 구조 결론 (구조 리서치)

- **4개 층**: ①상위개념(브랜드-중립 뼈대·완성) ②원자 의미 단위(구성요소 있음·**intent 원자 분해 미완=키스톤**) ③상품·가격 연결(완성) ④**이행·라우팅(형만 설계·데이터 GAP)**.
- **후니 방식 검증됨**: NeOn 시나리오2(재공학)·TOVE/NeOn CQ 주도·Soininen/Felfernig 구성 온톨로지 정합. **스키마-우선 닫힌세계 앵커가 범용 GraphRAG 도구보다 환각 차단 우위**.
- **수정=하지 마라**: 임베딩·트리플스토어·OWL 추론기·Leiden 자동탐지·개방추출 **기각 유지**(후니 283상품 규모엔 과공학·결정론 트리+SQLite가 더 감사 가능). 임베딩은 NL 진입 fallback으로만 보류.
- **라우팅 재발명 0**: capability_covers가 기존 생산 축(print_method·material·finishing·size·binding·MOQ)을 가리킴. 매칭=사양 ⊆ 능력(포섭). 표준=CIP4 PrintTalk.

## 미해결 / 블로커

- **G-ROUTE-1(최대)**: 실 공급자·능력·라우팅 데이터 0(미도입 도메인) → E22~E25 전 노드 candidate. 실 앵커=공급자 레지스트리 확보 후(별도 도메인·인간 결정).
- **intent 원자 분해**: 후니 편향 가능(G-NLQ-2·와우/레드 용도 코퍼스 미보강). badge=candidate·실 질의로 검증·과분해 금지.
- **개체/관계 정식 승격**: 아키텍처 게이트(MB7)+인간 승인 후(DB 미적재).
- **레드프린팅**: 와우 우선·레드는 brand 열 확장으로 후속(instance_of 구조라 append 안전).
- **팀 파일 버그**: Agent `name` 파라미터 사용 시 team file 오류 → name 없이 foreground 실행.

## 건드리지 말 것

- §33 골든 자산(`_workspace/huni-ontology-kb/03_kb/`·`02_ontology/`·`04_graph/build_graph.py`) — 읽기 재사용만·수정 금지(git-clean 확인됨).
- 아키텍처는 독립 시작으로 확정 — §33 조기 머지 금지(안정화 후 인간 승인).
- 라우팅 실물 노드를 실 앵커처럼 단정 금지(공급자 레지스트리 전까지 candidate·L-ROUTE-1).
