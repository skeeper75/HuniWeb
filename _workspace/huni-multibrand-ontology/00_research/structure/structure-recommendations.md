# 후니 온톨로지 구조 권고 — 개선·보완·확장·수정 (설계자 인계본)

> 작성: 2026-07-04 · mbo-standards-researcher(구조 렌즈). 입력 = `recommendation-configuration-kg-research.md`·`ontology-studio-comparison.md`.
> 대상 설계자 = okb-ontology-architect(§33) / mbo-ontology-architect(§35). **architecture-neutral**(§33 확장/독립 §35 어느 쪽이든 재사용).
> [HARD] search-before-mint(§33/§35 이름표 재사용 우선·신규는 근거 있을 때만) · 가격 경계 D-18 · 실 출처 앵커 · 생성≠검증(이 문서는 권고까지·확정은 architect+게이트).
> **4구분 정의**: 개선=기존을 더 정밀/표준정합 · 보완=빠진 것 채움 · 확장=새 능력 추가 · 수정=현행 오류/과공학 교정.

---

## A. 개선 (기존을 더 정밀·표준정합하게)

### 개선-1 — 가격 표준 이름표를 R9 엣지·차원까지 정밀화
- **무엇**: E9 price_formula→CompoundPriceSpecification, E10 price_component→**UnitPriceSpecification**, R9 `has_component` 엣지→**priceComponent** 이름표, component.use_dims→**UnitPriceSpecification.name(차원 지시)** 이름표 추가.
- **근거**: [schema.org CompoundPriceSpecification](https://schema.org/CompoundPriceSpecification)/[priceComponent](https://schema.org/priceComponent)/[UnitPriceSpecification](https://schema.org/UnitPriceSpecification) — "priceComponent가 병렬 UnitPriceSpecification들을 묶고, name으로 차원을 지시". 후니 원자합산형(출력+소재×수량/판걸이+후가공)과 개념 동형.
- **어디**: `standards-mapping.md`(§33) / `upper-ontology-vocabulary.md` U-16/U-17. 값 아님·이름표만(D-1·D-19).
- **리스크**: 낮음(문서 이름표 추가). schema.org는 정적 가격이라 **계산 재현 아님**을 명시(D-18).

### 개선-2 — nl-query-paths를 TOVE식 형식 CQ 테이블로 승격
- **무엇**: 산문 시나리오 → **4열(동기 시나리오 | 비정형 CQ | 형식 질의=재귀CTE/그래프탐색 | 통과판정)** 표로 형식화. 회귀검증 스위트가 됨.
- **근거**: [Grüninger & Fox TOVE](https://www.researchgate.net/publication/2288533_Methodology_for_the_Design_and_Evaluation_of_Ontologies)(비정형→형식 CQ→평가) · [CQ 유형화 (arXiv 2412.13688)](https://arxiv.org/html/2412.13688v1)(검색·집계·비교·경로 유형 구분).
- **어디**: §33 `nl-query-paths.md`·§35 `nl-query-paths-multibrand.md` 재구조화. graph-build-spec의 CTE와 1:1 링크.
- **리스크**: 낮음. 기존 16+10 시나리오가 이미 재료.

### 개선-3 — 구성 온톨로지 6개념 매핑을 명시 재확인표로
- **무엇**: component=E1 · attribute=E5/E11/E3 · resource=E4/E7 · port=R11 option_refs · function=E-intent · constraint=E12 를 한 표로 못박음(이미 산재).
- **근거**: [Soininen (ACM)](https://dl.acm.org/doi/abs/10.1017/S0890060498124083) · [Felfernig book](https://shop.elsevier.com/books/knowledge-based-configuration/felfernig/978-0-12-415817-7). 후니가 학술 구성 온톨로지를 이미 충실 구현함을 증명(재발명 없음 근거).
- **리스크**: 없음(문서화).

---

## B. 보완 (빠진 것 채움)

### 보완-1 — intent(용도)를 원자 기능으로 분해 [키스톤]
- **무엇**: 현재 `intent` 1노드(INTENT_cafe_opening) → **원자 기능 하위 분해**. 예 INTENT_wedding = {function:안내(초대) + theme:예식 + accessory:봉투동반 + qty:소량다품종}. intent→product 연결(R19)을 **원자 기능 매칭**으로 정밀화.
- **근거**: [AliCoCo (arXiv 2003.13230)](https://arxiv.org/abs/2003.13230) — 쇼핑 니즈를 "원자 개념" 레이어로 분해해 의미 이해("야외 바비큐"→그릴·숯·재료). 사용자 북극성의 "원자적 의미 단위"와 직결. 구성 온톨로지 `function` 개념([Soininen](https://dl.acm.org/doi/abs/10.1017/S0890060498124083)).
- **어디**: §33 E-intent 하위에 `function`/`theme` 속성 or 소수 원자 intent 노드 신설(접두 `INTENT_`·anchor=none+용어집/경쟁사 근거). **search-before-mint**: 신규 개체 유형 신설 말고 intent의 **속성·하위 references**로 먼저(D-5 접두 체계 내).
- **리스크**: 중. intent 코퍼스가 후니 기준(§35 G-NLQ-2) → 원자 기능도 후니 편향 가능. **badge=candidate**로 두고 실 질의로 검증(생성≠검증). 과분해 금지(283상품 규모에 맞게 소수).

### 보완-2 — 가격 component 유형을 표준 enum 이름표로 태깅
- **무엇**: E10 prc_typ_cd에 PriceComponentType식 이름표(UnitPrice·SetupFee(박 셋업)·AreaMatrix·FixedLookup 등) 병기. "이 옵션 왜 오르나"(S12) 설명 품질↑.
- **근거**: [schemaorg PriceComponentType 제안 #2689](https://github.com/schemaorg/schemaorg/issues/2689).
- **어디**: E10 표준 이름표 열. 값 아님.
- **리스크**: 낮음. 후니 아키타입(6종)과 매핑만.

### 보완-3 — NeOn 시나리오2(NOR 재공학) 방법론 명시
- **무엇**: 구축 방법론 헤더에 "후니 KB = NeOn Scenario 2(비온톨로지 자원 t_*·엑셀·catalog 재공학), 백지 구축 아님" 1줄 선언.
- **근거**: [NeOn (OEG-UPM)](https://oeg.fi.upm.es/index.php/en/methodologies/59-neon-methodology/index.html) · [NeOn scenario paper](https://research.uni-sofia.bg/bitstream/10506/672/1/S3T2009_24_AGomez-Perez_MCSuarez-Figueroa.pdf).
- **어디**: §33 `methodology-playbook.md` 서두 or 이 하네스 산출. 방법론 정당성·재현성.
- **리스크**: 없음.

---

## C. 확장 (새 능력 추가)

### 확장-1(E-1) — Global/집계 질의용 community 요약 노드
- **무엇**: category(E2)/product_family(E20)를 **커뮤니티**로 삼아 **요약 노드/속성**("이 family에 흔한 후가공·자재·가격 아키타입") 추가. "명함류에 흔한 후가공?" 같은 **집계·주제 질의**를 답함.
- **근거**: [MS GraphRAG global search](https://www.microsoft.com/en-us/research/blog/graphrag-improving-global-search-via-dynamic-community-selection/)(커뮤니티 요약으로 전역 질의). **단 Leiden 자동탐지 대신 기존 트리를 커뮤니티로**(결정론·환각 회피).
- **어디**: E2/E20 노드 파생 속성 or `summary` 노드(anchor=파생·derived_from family 멤버들). §35 nl-query T-신설(집계).
- **리스크**: 중. 요약은 파생이라 노후(staleness) 위험 → **재빌드 시 재생성**(파일 정본→그래프 파생 원칙으로 자동 갱신). badge·src_id로 freshness 추적.

### 확장-2(X-1) — intent 브랜드 무관화(§35 이미 부분 설계·강화)
- **무엇**: intent→family(E20)→same_family_as로 브랜드 무관 추천(§35 nl-query T2 이미 있음). **보강**: intent 코퍼스에 와우/레드 용도 증거 추가(§35 G-NLQ-2 해소).
- **근거**: [AliCoCo](https://arxiv.org/abs/2003.13230)(니즈 노드가 다상품 연결) · §35 crossbrand `same_family_as`.
- **리스크**: 낮음(구조는 §35 완비·데이터 보강만).

### 확장-3 — self-refine 자기개선 루프를 KB 유지보수에 명문화
- **무엇**: "질의 실패(경로 안 그려짐)·GAP·양면 결함 → 보강 티켓 → 재검증"의 **feedback→refine→feedback 루프**를 하네스 규약으로. Ontology Studio의 Golden Question 드라이버와 결합(개선-2).
- **근거**: [Self-Refine (OpenReview)](https://openreview.net/pdf?id=S37hOerQLB) · [OpenAI self-evolving agents](https://developers.openai.com/cookbook/examples/partners/self_evolving_agents/autonomous_agent_retraining) · [COSMO 생성+검증](https://www.amazon.science/publications/cosmo-a-large-scale-e-commerce-common-sense-knowledge-generation-and-serving-system-at-amazon). 후니는 이미 badge/게이트/codex로 실증 → 명문화만.
- **리스크**: 낮음. **자기 산출 자기 승인 금지**(생성≠검증) 유지가 핵심 — refine 제안은 생성, 채택은 검증 게이트+인간.

---

## D. 수정 (현행 오류·과공학 교정 — 대부분 "하지 마라"로 방어)

### 수정-1 — 임베딩·트리플스토어·OWL 추론기 도입 유혹 차단(재확인)
- **무엇**: Ontology Studio/GraphRAG가 임베딩·Neo4j·Leiden·KG 임베딩 사전학습을 쓴다고 후니가 따라가지 말 것.
- **근거**: 후니 283상품·1485노드 규모엔 과공학. §33 D-2(RDF 미도입) 승계. 결정론 트리(category/family)·SQLite 3층이 더 검증가능. [PKGM](https://arxiv.org/pdf/2203.00964)/[billion-scale KG](https://arxiv.org/pdf/2105.00388)는 수십억 규모 전제.
- **결정**: **기각 유지**. 임베딩은 NL 진입 fallback으로만 보류(도구 결정=architect).

### 수정-2 — 개방추출(schema-free) 유혹 차단
- **무엇**: LLM 개방 개체·관계 추출(AutoSchemaKG류) 도입 금지. 후니 폐쇄목록(개체17/22·관계19/23·D-7) 유지.
- **근거**: [LLM-KG survey (arXiv 2510.20345)](https://arxiv.org/abs/2510.20345)(개방추출 환각·노이즈) · [AutoSchemaKG (arXiv 2505.23628)](https://arxiv.org/pdf/2505.23628)(유연하나 정밀·감사 약화). 후니 닫힌세계 앵커가 환각 원천 차단(우위·comparison §2.1).
- **결정**: **기각 유지**(스키마-우선 고수).

### 수정-3 — intent 원자 분해 과잉 방지
- **무엇**: 보완-1 실행 시 원자 기능을 수백 개로 쪼개지 말 것(AliCoCo는 수십억 상품이라 정당·후니는 아님).
- **결정**: 소수(용도 대분류당 2~4 원자)·badge=candidate·실 질의로 필요분만 승격.

---

## 설계자에게 넘길 결정 항목 (architect 판단 필요)

1. **[D1] intent 원자 분해(보완-1)를 속성으로 접을지 vs 소수 노드 신설**: search-before-mint상 속성 우선 권장. 파일럿 실측 후 승격 판정. (§33 D-22 접기 원칙 동형)
2. **[D2] community 요약 노드(확장-1)를 개체 신설 vs family/category 파생 속성**: 파생 속성 권장(노드 폭발 회피·재빌드 자동 갱신).
3. **[D3] 임베딩 NL 진입 fallback 채택 여부**: 결정론 alias 1차 확정 후, 미해결 표현 실측 시에만. 초기=미채택 권장.
4. **[D4] 이 권고들의 반영 위치**: §33 확장이면 §33 스키마 v1.1 머지 / 독립 §35면 상위 온톨로지에. **architecture 게이트(MB7)+인간 승인 후** 확정(§35 G-SCHEMA-5 승계).
5. **[D5] CQ 형식화(개선-2) 자동생성(RAG) 채택 여부**: [CQ RAG gen](https://link.springer.com/chapter/10.1007/978-3-031-81974-2_6) — 초안 가속용, 검증은 인간. 보류 권장(현행 16+10 CQ 충분).

---

## 가장 큰 구조 권고 3개 (우선순위)

1. **보완-1 (intent 원자 분해)** — 사용자 북극성 "원자적 의미 단위 → 추천"의 핵심. AliCoCo 검증 패턴. 추천 정밀도 직결.
2. **개선-2 + 확장-3 (CQ 형식화 + self-refine 루프)** — Ontology Studio의 Golden Question 드라이버를 후니에 이식. 구축·유지보수를 회귀검증 가능한 루프로. 후니가 이미 가진 badge/게이트와 결합해 저비용.
3. **확장-1 (community 요약 노드)** — GraphRAG global 질의 능력. "명함류 흔한 후가공?"류 집계 질의 대응. 결정론 트리 재사용으로 과공학 회피.

## GAP
- **G-STR-1**: 위 권고의 실 질의 품질 이득은 그래프 빌드·질의 엔진 구현 후에만 실측(설계 권고까지·DB 미적재).
- **G-STR-2**: intent 원자 분해의 와우/레드 용도 코퍼스 미보강(§35 G-NLQ-2) — B트랙/rpm 하네스 산출 대기.
- **G-STR-3**: uEngine Ontology Studio 실사양 미확인(G-RES-1) → 배울점 3개는 일반 GraphRAG 패턴 기준.

## Sources
- 본 하네스 `recommendation-configuration-kg-research.md`·`ontology-studio-comparison.md`(4프론트 출처 집약)
- 현행 승계: §33 `02_ontology/ontology-schema.md`·`nl-query-paths.md` · §35 `03_upper_ontology/upper-ontology-schema.md`·`nl-query-paths-multibrand.md`·`00_research/standards-playbook.md`
- 학술·표준 앵커: 프론트별 인라인 URL(TOVE·NeOn·CQ유형·Soininen·Felfernig·AliCoCo·Amazon COSMO/AutoKnow·MS GraphRAG·schema.org 가격·Self-Refine·LLM-KG survey)
