# CPQ 제약(Constraint) 관리 베스트프랙티스 — 원리별 정리

> Huni-Constraint-Rules 하네스(§31) Phase 1 리서치.
> 목적: 바깥(CPQ 업계가 제약을 어떻게 관리·시각화·강제하는가)의 원리를 뽑아, 후니 webadmin 제약 레이어 개선의 밑그림으로 쓴다.
> 방침: 벤더 마케팅 문구는 "도구 이름"이 아니라 "원리"로 일반화해서 흡수한다(특정 제품 답습 금지).
> 작성일: 2026-07-02.

---

## 0. 두 가지 설정 접근 — 규칙기반 vs 제약기반

두 방식이 업계에 공존한다. 후니의 현재 구조를 어디에 놓을지 판단하는 기준이 된다.

- **규칙기반(rule-based, if-then)** — "A를 고르면 B를 막아라" 같은 절차적 규칙을 하나씩 쓴다. 이해하기 쉽지만, 규칙이 많아지면 서로 충돌·중복이 생기고 순서에 민감해진다.
- **제약기반(constraint-based)** — "허용되는 조합"의 관계망(모델)을 선언해 두면, 엔진이 어느 방향으로든(A→B, B→A) 자동으로 유효한 조합만 남긴다. 복잡한 제조형 상품에서 규칙 폭증을 억제하는 데 유리하다는 것이 업계 공통 견해.

원리: **규칙 수가 적을 때는 규칙기반이 실용적이고, 상품·옵션 상호의존이 늘수록 "허용 조합을 데이터로 선언"하는 제약기반이 유지보수에 유리하다.** 후니는 현재 규칙기반(JSONLogic 절 하나씩)이며, 규모가 커질 때 이 전환점을 의식해야 한다.
[출처: Tacton — Constraint-Based vs. Rules-Based Configuration; Configit — Product Configuration Explained]

---

## 1. 규칙 수명주기 · 버저닝 · 감사추적

**원리 1-A. 설정 로직은 엔진 안에 살고, 버전관리·중앙관리되어야 한다.**
규칙이 코드나 산발적 스크립트에 흩어지면 "규칙 드리프트"(신규 SKU·옵션 추가 시 규칙이 뒤처짐)가 생긴다. 규칙을 한 곳(엔진)에 두고 버전으로 추적하면, 상품팀이 새 SKU를 넣거나 의존관계를 바꾸거나 상품을 은퇴시켜도 견적 흐름이 깨지지 않는다.
[출처: Everstage — CPQ Architecture 2026; Logik.io — Manage CPQ Product Rules]

**원리 1-B. 감사추적은 "누가·언제·왜 바꿨는가"의 서사를 남긴다.**
현대 CPQ는 각 견적/규칙 변경의 전체 맥락(승인만이 아니라 근거·협의 기록)을 남긴다. 실시간 감사추적은 문제 조사 시간을 "몇 주 → 몇 시간"으로 줄인다.
원리로 흡수: 규칙 테이블에 변경 이력(이전 logic·변경자·변경일·사유)을 남기면, 나중에 "왜 이 조합이 막혔지?"를 추적할 수 있다.
[출처: Mobileforce — CPQ Compliance 2025; Everstage]

**원리 1-C. 데이터 거버넌스 — 규칙을 아무나·무분별하게 못 넣게 한다.**
불필요·불일치 규칙이 쌓이지 않도록 등록 정책(누가 어떤 규칙을 넣을 수 있는가)과 정기 감사 루틴을 둔다. 규칙 소유권을 명확히 한다.
[출처: Whatfix — CPQ Implementation; Mobileforce]

---

## 2. 규칙 유형(제약 종류)의 표준 어휘

업계 CPQ는 대체로 다음 의도(intent)를 구분한다. 후니의 3종(호환·금지·필수동반)은 이 표준 어휘의 부분집합이다.

- **포함/필수동반(include/require)** — A를 고르면 B가 반드시 있어야 한다.
- **제외/금지(exclude)** — A와 B는 함께 못 쓴다.
- **추천(recommend)** — A를 고르면 B를 권한다(강제 아님).
- **대체(replace)** — A를 B로 자동 치환.
- **검증(validate)** — 조건을 만족하지 않으면 메시지로 경고/차단.

각 규칙은 **실행 위치(client-side / server-side / both)**를 가진다. 기본은 서버 처리이며, 설정으로 클라이언트/서버를 고를 수 있다.
원리로 흡수: 후니가 앞으로 "추천"이나 "대체" 같은 유형을 넣고 싶다면 이 표준 어휘를 따르는 것이 안전하고, **강제는 서버가 최종 권위**라는 원칙(§6)이 여기서도 확인된다.
[출처: Conga — Managing Constraint Rules; Salesforce — Constraint and Rule Types in the Visual Builder; Cincom — Technical Configuration Rules]

---

## 3. No-code 규칙 빌더 UX

**원리 3-A. 비전문가는 자연어에 가깝게 규칙을 쓰고, 시스템이 뒤에서 코드를 생성한다.**
좋은 빌더는 관리자가 드롭다운·조건 블록으로 규칙을 만들면, 뒤에서 정형 코드(예: CML, JSONLogic)를 자동 생성한다. 개발자는 그 코드를 열어 미세조정할 수 있는 "고급 경로"를 갖는다.
원리로 흡수: 후니의 폼빌더(드롭다운) + 고급 JSONLogic 직접입력의 2층 구조는 이 베스트프랙티스와 정합한다.
[출처: Salesforce — Visual Builder (CML 자동생성); InRule — UX Builder; Feathery — Visual Rule Builder]

**원리 3-B. 규칙은 여러 "가지(branch)"로 나뉘고, 각 가지는 조건 + 동작을 갖는다.**
복수 조건(AND/OR 조합)과 그에 따른 동작을 시각적으로 배치할 수 있어야 한다.
원리로 흡수: 후니의 복수조건 빌더(그룹·AND/OR 배지)는 이 패턴을 구현하고 있다.
[출처: Feathery — Visual Rule Builder]

**원리 3-C. 자연어 규칙 요약 렌더링.**
정형 코드(JSONLogic)를 사람이 읽는 문장("A4 + 50매는 함께 선택할 수 없습니다")으로 되돌려 보여주면, 비전문가가 규칙 목록을 훑을 때 실수를 잡는다.
[출처: r-sun.ai — natural language in, valid SKUs; Insight Works — Rule Builder]

---

## 4. 실시간 유도 + 충돌/중복/도달불가(dead rule) 감지

**원리 4-A. 유효한 조합만 실시간으로 남긴다.**
사용자가 옵션을 고르면 엔진이 즉시 유효하지 않은 조합을 걸러, 잘못된 구성이 가격 단계까지 못 가게 한다. "선택 → 필터링 → 유효한 것만 노출"이 핵심 루프.
[출처: DealHub — Product Configurator; Zoovu — Visual Product Configurator; Hypha — CPQ Systems Explained]

**원리 4-B. 모델을 컴파일할 때 불일치·틈·죽은 규칙을 미리 검출한다.**
상품이 복잡해지면 "막다른 길"(유효한 해가 하나도 없는 조합)이 생긴다. 좋은 시스템은 컴파일 시점에 이런 불일치·gap을 감지한다. 학계에서도 피처모델 편집 시 동시 변경의 충돌을 체계적으로 검출하는 방법이 연구된다.
원리로 흡수: 규칙을 저장할 때 배치로 "① 서로 모순되는 규칙 ② 완전히 겹치는 중복 ③ 어떤 조합으로도 발동 안 되는 죽은 규칙"을 스캔해 관리자에게 경고할 수 있다.
[출처: Configit — inconsistencies, gaps detection; arXiv 1604.00347 — Conflict Detection on Feature Models; USPTO 7734559 — exclude cover removal]

---

## 5. 호환성 매트릭스 시각화 + 영향 미리보기

**원리 5-A. 다차원 관계는 매트릭스(격자)로 보여준다.**
여러 속성이 서로 얽힌 규칙은 매트릭스(예: 자재 × 사이즈 격자)로 표현하면 사용자가 "무엇이 무엇과 되고 안 되는가"를 한눈에 본다. 자연어 설명을 SKU로 변환하는 호환성 매트릭스가 사용자가 속성의 미로에서 길을 잃지 않게 돕는다.
원리로 흡수: 후니는 "이 상품의 자재↔사이즈 호환 격자"를 초록/빨강 히트맵으로 렌더링하면, 관리자가 규칙 커버리지의 구멍을 즉시 본다.
[출처: USPTO 7734559 — matrix of rule statements; r-sun.ai — compatibility matrix]

**원리 5-B. 규칙의 "영향 미리보기".**
규칙을 저장하기 전에 "이 규칙이 막는(또는 요구하는) 조합이 N개"라고 미리 보여주면, 관리자가 과잉·과소 제약을 저장 전에 잡는다.
원리로 흡수: 후니 폼빌더에 "이 규칙 적용 시 현재 등록된 조합 중 M개가 막힘"을 계산해 보여주는 미리보기를 붙일 수 있다(현재는 샘플 1건 수동 테스트만 가능).
[출처: Salesforce — configurator filters invalid combinations in real time; Zoovu]

---

## 6. 견적 → 카트 → 주문 단계별 validate 강제 아키텍처

**원리 6-A. "add → configure → price → validate → checkout"이 표준 흐름이다.**
디지털 커머스/CPQ의 공통 패턴은 담기 → 구성 → 가격 → 검증 → 결제다. Checkout API는 결제 확정 전에 **모든 필수 검증**을 다시 수행한다.
[출처: Salesforce Developers — Checkout Items in Cart; Validate Cart Action]

**원리 6-B. 강제는 서버가 최종 권위다.**
제약 규칙은 기본적으로 서버에서 처리된다. 클라이언트(위젯) 검증은 UX용 즉시 피드백이고, **주문 확정 직전 서버가 다시 검증해야 우회를 막는다.**
원리로 흡수: 후니는 위젯(§6)이 실시간 필터링/경고를 하되, 카트/주문 확정 시 서버가 `evaluate_constraints`(또는 validate 엔드포인트)를 다시 호출해야 진짜 강제가 된다.
[출처: Conga — 서버측 기본 처리, Constraint Rule Execution Mode; Salesforce — validate cart action]

**원리 6-C. Validate는 여러 지점에 배치한다.**
카트 담을 때(구성 검증), 카트 조회/수정 시(재검증), 결제 직전(최종 필수 검증) — 각 단계마다 검증 훅을 둔다.
[출처: Salesforce Developers — CPQ Cart APIs (Validate Cart / Checkout)]

---

## 7. 데이터(가격표) 기반 규칙 자동 유도

**원리 7-A. 수동 규칙은 드리프트한다 — 데이터에서 규칙을 파생할 수 있으면 그게 낫다.**
가격표/BOM 같은 권위 데이터에 이미 "어떤 자재가 어떤 사이즈로 존재하는가"가 들어 있다면, 그 데이터로부터 호환 격자를 자동 유도해 수동 규칙 유지 부담을 줄인다. 상품이 진화할 때 규칙이 자동으로 따라온다.
원리로 흡수: 후니의 단가행(component_prices)·차원행이 곧 "실재하는 조합"의 원천이다. 자재가 은퇴하면 단가행도 사라지므로, **단가행 격자에서 호환 규칙을 자동 유도**하면 수동 규칙이 부패(자재 은퇴 시 규칙이 존재하지 않는 코드를 가리키는 문제)하는 것을 막을 수 있다.
[출처: Everstage — centralized config prevents drift; Zoovu — CPQ for complex products (AI-derived valid combinations)]

---

## 출처 목록

- Tacton — Constraint-Based vs. Rules-Based Configuration: https://www.tacton.com/cpq-blog/constraint-based-vs-rules-based-configuration-the-advantage-for-complex-manufacturing/
- Configit — Product Configuration Explained: https://configit.com/learn/blog/product-configuration-explained/
- Everstage — CPQ Architecture 2026: https://www.everstage.com/cpq/cpq-architecture
- Logik.io — Best Way to Manage CPQ Product Rules: https://www.logik.io/cpq-product-rules
- Mobileforce — CPQ Compliance 2025: https://mobileforce.ai/blog/cpq-compliance-meeting-industry-regulations-and-standards-2025/
- Whatfix — CPQ Implementation: https://whatfix.com/blog/cpq-implementation/
- Conga — Managing Constraint Rules: https://documentation.conga.com/cpq/latest/salesforce/managing-constraint-rules-213456636.html
- Cincom — Technical Configuration Rules in Enterprise CPQ: https://www.cincom.com/glossary/technical-configuration-rules-in-enterprise-cpq/
- Salesforce — Constraint and Rule Types in the Visual Builder: https://help.salesforce.com/s/articleView?id=ind.product_configurator_visual_builder_constraint_and_rule_types.htm
- Salesforce — Rules and Constraints in Configurator (Constraint Rules Engine): https://help.salesforce.com/s/articleView?id=ind.product_configurator_advanced.htm
- Salesforce Trailhead — Product Configurator & Constraint Rules Overview: https://trailhead.salesforce.com/content/learn/modules/product-configuration-with-revenue-cloud/explore-product-configurator-with-constraint-rules-engine
- InRule — UX Builder: https://inrule.com/ux-builder/
- Feathery — Visual Rule Builder: https://docs.feathery.io/platform/build-forms/advanced-logic/visual-rule-builder
- Insight Works — Use Rule Builder: https://kb.dmsiworks.com/knowledge-base/use-rule-builder/
- r-sun.ai — AI Product Configurator: https://r-sun.ai/products/co-seller/product-configurator-software
- DealHub — What is a Product Configurator?: https://dealhub.io/glossary/product-configurator/
- Zoovu — Visual Product Configurator / CPQ for Complex Products: https://zoovu.com/visual-product-configurator , https://zoovu.com/blog/cpq-for-complex-products
- Hypha — CPQ Systems Explained: https://www.hyphadev.io/blog/cpq-systems-explained
- Salesforce Developers — Checkout Items in Cart: https://developer.salesforce.com/docs/industries/cme/guide/std_comms-checkout-items-in-cart.html
- Salesforce Developers — Validate Cart Action: https://developer.salesforce.com/docs/industries/cme/guide/comms-validate-cart-action.html
- arXiv 1604.00347 — Conflict Detection for Edits on Extended Feature Models: https://arxiv.org/pdf/1604.00347
- USPTO 7734559 — Rule processing (exclude cover removal): https://image-ppubs.uspto.gov/dirsearch-public/print/downloadPdf/7734559
