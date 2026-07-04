# 추천·구성 KG 방법론 리서치 — 4프론트 (§35 구조 개선 A트랙)

> 작성: 2026-07-04 · mbo-standards-researcher(구조 렌즈) · 방법론 = `mbo-standards-research` 스킬 확장.
> 범위: **NL질의 → 원자적 의미 분해 → 추천 → 가격 연결**의 온톨로지 구조·구축 방법론. 주문 라우팅=병렬 B트랙.
> [HARD] 실 출처 앵커·지어내기 금지·불명확=GAP. search-before-mint(§33/§35 이름표 재사용 우선). 가격 경계(D-18) 준수.
> 승계 재사용: §33 `02_ontology/ontology-schema.md`(개체17·관계19)·`nl-query-paths.md`(5유형) · §35 `03_upper_ontology/`(상위22·교차4)·`00_research/standards-playbook.md`(CIP4/schema.org/config-ont 채택). **이 문서는 표준 어휘가 아니라 "구축 방법론·추천 패턴"을 보강한다**(표준 어휘는 이미 완료).
>
> **읽는 법(비전문가용):** §33/§35는 이미 "무엇을 점·선으로 그릴지(스키마)"를 정했다. 이 문서는 그 위에 "어떻게 잘 지을지(구축 방법론)"와 "고객 질문에 어떻게 잘 답할지(추천 패턴)"를 세계 학계·대형 커머스(알리바바·아마존·MS) 사례에서 빌려온다.

---

## 프론트 1 — 온톨로지 구축 방법론 (Golden/Competency Question 주도)

### 핵심 발견

- **Grüninger & Fox TOVE 방법론** = 온톨로지 구축의 고전. 5단계: ① **동기 시나리오(motivating scenarios)** → ② **비정형 competency question(CQ)** → ③ 형식 용어(terminology) → ④ **형식 CQ**(SPARQL 등 질의로 변환) → ⑤ 형식 공리. CQ = "온톨로지가 답할 수 있어야 하는 질문"으로 **설계 범위(scope)와 완성 판정(evaluation)을 동시에 규정**한다. 출처: [Methodology for the Design and Evaluation of Ontologies (Grüninger & Fox)](https://www.researchgate.net/publication/2288533_Methodology_for_the_Design_and_Evaluation_of_Ontologies).
- **Uschold & King Enterprise Ontology** = 4단계(목적 식별 → 구축 → 평가 → 문서화). CQ가 "설계 탐색 공간을 특징짓는 메커니즘"이라 최초 정의. 비정형 CQ는 **형식 질의(SPARQL)로 변환 가능하게 설계**해야 초기 평가에 쓸 수 있음. 출처: [On the Roles of Competency Questions in Ontology Engineering (Springer 2024)](https://link.springer.com/chapter/10.1007/978-3-031-77792-9_8) · [CQ 사용 서베이 (Springer 2023)](https://dl.acm.org/doi/10.1007/978-3-031-47262-6_3).
- **NeOn 방법론** = 시나리오 기반(9 시나리오). 경직된 워크플로 대신 상황별 경로 제시: 시나리오1=백지 구축, **시나리오2=비온톨로지 자원(NOR: DB·엑셀·폴크소노미) 재공학**, 시나리오3~6=기존 온톨로지 재사용·병합·ODP·재구조화. CQ로 요구사항 명세·검증. 출처: [NeOn Methodology (OEG-UPM)](https://oeg.fi.upm.es/index.php/en/methodologies/59-neon-methodology/index.html) · [NeOn scenario-based (Suárez-Figueroa et al.)](https://research.uni-sofia.bg/bitstream/10506/672/1/S3T2009_24_AGomez-Perez_MCSuarez-Figueroa.pdf).
- **CQ 유형화(최신)** = CQ가 다 같지 않다. 검색·집계·비교·경로 등 유형이 다르며, 모호·불완전 CQ는 불완전 온톨로지를 낳음. 출처: [Discerning Types of Competency Questions (arXiv 2412.13688)](https://arxiv.org/html/2412.13688v1).
- **CQ 자동생성(RAG)** = LLM이 CQ를 생성·형식화하는 최신 시도(초안 가속·인간 검증 병행). 출처: [A RAG Approach for Generating Competency Questions (Springer 2025)](https://link.springer.com/chapter/10.1007/978-3-031-81974-2_6).
- **온톨로지 개발 101(Noy & McGuinness)** = 반복적(iterative) 구축·"용어 열거 → 클래스 → 속성 → 제약" 절차의 실무 표준 입문서(널리 인용되는 canonical 참고문헌). URL: `https://protege.stanford.edu/publications/ontology_development/ontology101.pdf`(🟡 URL 재확인 권장).

### 후니 적용 시사점

- **채택 — CQ를 1급 산출물로 승격**: §33 `nl-query-paths.md`(5유형 16시나리오)·§35 `nl-query-paths-multibrand.md`(Q1~Q10)는 **이미 CQ 주도 설계의 실체**다("경로 안 그려지면 스키마 결함"=CQ 기반 평가). 학술 정합 100%. 다만 현재는 산문 시나리오라, TOVE식으로 **① 동기 시나리오 → ② 비정형 CQ → ③ 형식 질의(재귀 CTE/그래프 탐색) → ④ 통과/실패 판정**의 4열 테이블로 **형식화**하면 자동 회귀검증(regression)이 된다. → structure-recommendations E-2.
- **채택 — NeOn 시나리오2(NOR 재공학) 명명**: 후니 구축은 명백히 "비온톨로지 자원(t_* DB·260702 엑셀·와우 catalog JSON) → 온톨로지" 재공학이다. §33/§35가 이미 이렇게 하나, **"우리는 NeOn S2를 따른다"고 명시**하면 방법론 정당성·재현성이 선다(백지 구축 아님을 명확히).
- **기각 — 형식 공리(OWL axiom)·SPARQL-OWL 추론**: TOVE 5단계 중 ④⑤ 형식 공리는 후니 규모(283상품·단일 운영자)엔 과함. §33 D-2(RDF/트리플스토어 미도입) 승계. CQ는 "형식 질의=재귀 CTE/SQLite"로 충분(§33 graph-build-spec).

---

## 프론트 2 — 원자적 의미 분해 & 상품 구성 온톨로지

### 핵심 발견

- **구성(configuration) = 조립 설계**: "잘 정의된 컴포넌트 타입 집합의 인스턴스를, 제약 집합을 만족하도록 조합해 맞춤 상품을 만드는 특수 설계 활동"(대량 맞춤화의 핵심 기술). 출처: [Knowledge-based configuration (Wikipedia)](https://en.wikipedia.org/wiki/Knowledge-based_configuration) · [Felfernig et al., *Knowledge-Based Configuration: From Research to Business Cases* (Morgan Kaufmann 2014)](https://shop.elsevier.com/books/knowledge-based-configuration/felfernig/978-0-12-415817-7).
- **구성 온톨로지 6개념(Soininen/Tiihonen)** = component·attribute·resource·port(connection)·function·constraint. 표현 형식은 여러 개나 **개념 집합은 하나**(학계 수렴). 후니 §33이 이미 표준 이름표로 채택. 출처: [Towards a general ontology of configuration (ACM)](https://dl.acm.org/doi/abs/10.1017/S0890060498124083).
- **OWL 기반 구성 지식 모델링** = 구성 지식을 온톨로지로 표현하면 **재사용·정밀 추론·표현력**이 좋다(구성 지식 모델링 프로세스 촉진). 출처: [Product configuration knowledge modeling using OWL (ScienceDirect)](https://www.sciencedirect.com/science/article/abs/pii/S0957417408002418) · [A meta-model for product configuration ontologies (academia.edu)](https://www.academia.edu/89503491/A_meta_model_for_product_configuration_ontologies).
- **feature model ↔ 구성**: feature model 자동분석과 구성은 시너지가 크고, **conjunctive query로 제약충족(CSP)·feature 구성**을 푼다. 출처: [Conjunctive Query Based Constraint Solving for Feature Model Configuration (arXiv 2304.13422)](https://arxiv.org/pdf/2304.13422) · Benavides/Felfernig/Galindo/Reinfrank 2013(automated analysis of feature models).
- **원자 개념 = 조합의 원료**: 알리바바 AliCoCo는 상품을 **"원자 개념(atomic/primitive concept) 레이어"**로 분해해 의미 이해의 원료로 삼는다(예 "야외 바비큐" → 그릴·숯불·재료). 출처: [AliCoCo (arXiv 2003.13230)](https://arxiv.org/abs/2003.13230).

### 후니 적용 시사점

- **채택(이미 강함) — 인쇄물의 원자 = 용지·인쇄·후가공·제본·판걸이**: 사용자 북극성의 "원자적 의미 단위(atomic semantic units)"는 §33 개체 E4 material·E5 print_option·E6 process·E3 size·E7 plate_size·**E10 price_component**로 **이미 원자화**돼 있고, E9 price_formula가 `has_component`로 **조합(합성)**한다. 이는 Soininen 6개념(component=product, resource=material/plate, attribute=option/size, function=intent, constraint=constraint, port=option_refs)에 1:1 대응. **후니 구조가 학술 구성 온톨로지를 이미 충실히 구현** = 재발명 불필요.
- **보완 — `function`(용도·기능) 축의 원자화 강화**: 6개념 중 `function`이 후니에선 `intent`(KB전용) 1종으로만 존재. AliCoCo식으로 **"용도 = 원자 기능들의 조합"**(예 "청첩장" = {안내 기능 + 예식 테마 + 봉투 동반})으로 잘게 쪼개면 추천 정밀도가 오른다(프론트3 연계). → structure-recommendations B-1.
- **채택 — feature-model식 제약을 CQ로 검증**: §33 constraint(E12·CN-1~6)는 이미 feature-model 제약과 동형. "이 조합 만들 수 있나"(nl-query S10·§35 N6)를 **conjunctive query(그래프 탐색)로 판정**하는 것이 학술 정합. 단 **CSP 솔버·추론기 도입은 기각**(런타임 유효성=엔진/API status가 권위·§35 N6). 온톨로지는 후보 판정까지.
- **채택 — EBOM/MBOM 명명 유지**: 셋트(부모=완제품 ← 반제품 구성원)는 이미 §33 A5로 EBOM/MBOM 채택. `has_member`(R13)가 조립 BOM. 학술 정합.

---

## 프론트 3 — KG/GraphRAG 기반 상품 추천

### 핵심 발견

- **AliCoCo 4레이어 = "쇼핑 니즈를 노드로"**: ① **e-commerce concept**(쇼핑 니즈·"야외 바비큐"를 명시 노드로) → ② **primitive/atomic concept**(의미 이해 레이어) → ③ taxonomy → ④ **product**(수십억 상품을 니즈·원자개념에 연결). **니즈 노드가 상품 추천의 진입점**. 반자동 구축. 출처: [AliCoCo (arXiv 2003.13230)](https://arxiv.org/abs/2003.13230) · [SIGMOD 2020](https://dl.acm.org/doi/10.1145/3318464.3386132) · [AliCoCo2 (Semantic Scholar)](https://www.semanticscholar.org/paper/7ffd8333d9a7e9a059999ef844fb3e3347fac468).
- **Amazon Broad Product Graph / AutoKnow** = **이분 그래프(bipartite)**: 한쪽=상품 노드, 다른쪽=상품 속성 노드(브랜드·맛·성분). AutoKnow가 **상품 타입 분류체계(taxonomy) 구축 → 타입별 적용 속성 결정**부터 시작. 70억+ 트리플·300만+ 규칙. 검색·QA·추천·BI에 사용. 출처: [Building a Broad Knowledge Graph for Products (Dong et al. KDD 2020)](https://www.researchgate.net/publication/345426291_Building_a_Broad_Knowledge_Graph_for_Products) · [Building product graphs automatically (Amazon Science)](https://www.amazon.science/blog/building-product-graphs-automatically).
- **Amazon COSMO = LLM 생성 + 검증 파이프라인**: LLM이 고객 상호작용 데이터에서 **커먼센스 관계 가설을 생성 → 인간 주석 + ML 필터로 검증**해 KG 구축(추천 개선). **"생성 ≠ 검증" 분리가 산업 표준**임을 실증. 출처: [COSMO (Amazon Science)](https://www.amazon.science/publications/cosmo-a-large-scale-e-commerce-common-sense-knowledge-generation-and-serving-system-at-amazon) · [ZenML LLMOps DB](https://www.zenml.io/llmops-database/building-a-commonsense-knowledge-graph-for-e-commerce-product-recommendations).
- **PKGM = 사전학습 KG 모델(임베딩)**: 커머스 KG를 사전학습해 하위 태스크(추천 등)에 서빙. 경로/임베딩 추천의 산업 사례. 출처: [PKGM (arXiv 2203.00964)](https://arxiv.org/pdf/2203.00964) · [Billion-scale Pre-trained E-commerce Product KG (arXiv 2105.00388)](https://arxiv.org/pdf/2105.00388).
- **Microsoft GraphRAG = 2단 검색**: ① **Local search**(특정 엔티티 → 이웃·관계 확장) ② **Global search**(Leiden 커뮤니티 탐지 → 커뮤니티 요약 → 전역 주제 질의). **DRIFT**=지역+전역 결합. 인덱싱=엔티티/관계 추출 → 커뮤니티 → 요약. 출처: [GraphRAG dynamic community selection (MS Research)](https://www.microsoft.com/en-us/research/blog/graphrag-improving-global-search-via-dynamic-community-selection/) · [DRIFT search (MS Research)](https://www.microsoft.com/en-us/research/blog/introducing-drift-search-combining-global-and-local-search-methods-to-improve-quality-and-efficiency/) · [graphrag.com reference](https://graphrag.com/reference/graphrag/global-community-summary-retriever/).

### 후니 적용 시사점

- **채택(키스톤) — AliCoCo "니즈 노드" 패턴으로 intent 레이어 강화**: 후니 `intent`(E-intent·INTENT_cafe_opening 등)는 **정확히 AliCoCo의 e-commerce concept 노드**다. 세계 최대 커머스가 검증한 패턴을 후니가 소규모로 이미 채택. → **강화 방향**: ① intent 노드를 **원자 기능으로 분해**(프론트2 B-1) ② intent → product 연결(R19 references)을 **product_family(§35 E20) 경유**로 브랜드 무관화(§35 이미 설계). → structure-recommendations X-1.
- **채택 — Amazon bipartite = 후니 product↔속성이 이미 이분 구조**: product(E1) ↔ {material·print_option·process·size}는 Amazon broad graph의 상품↔속성 이분 그래프와 동형. **taxonomy 우선(AutoKnow) = 후니 category(E2) 3단 트리 우선**과 동형. 재발명 불필요.
- **채택 — GraphRAG 2단 검색을 질의 라우팅에 명시**: §33 nl-query-paths §0 "하이브리드 2단(노드 확정 → 경로 탐색)"은 **GraphRAG local search와 동형**. **보완 = global search(커뮤니티 요약)**를 후니 규모에 맞게 경량 채택: "명함류 전체는 어떤 후가공이 흔한가" 같은 **집계·주제 질의**는 local 경로만으론 약하다. product_family(E20)·category(E2)를 **커뮤니티로 삼아 요약 노드**를 두면 global 질의를 답할 수 있다. → structure-recommendations E-1.
- **기각 — KG 임베딩(PKGM)·Leiden 커뮤니티 탐지 자동화**: 283상품·1485노드 규모엔 임베딩 사전학습·자동 커뮤니티 탐지가 과공학. 커뮤니티=이미 있는 category/family 트리로 **결정론적**으로 대체(임베딩 불투명성·환각 회피). 단 자연어 진입(1단 노드 확정)의 **표현 다양성 흡수**엔 임베딩이 유용 → 용어집(term alias) + 선택적 임베딩 진입은 보류(프론트4 도구 결정).
- **채택 — COSMO "생성≠검증"은 후니가 이미 실증**: LLM이 intent→상품 연결·커먼센스 관계를 **생성**하되 `badge`(candidate)·`okb-adversarial-gate`·codex 교차로 **검증**. 산업 표준과 정합. 후니 강점을 방법론으로 명문화.

---

## 프론트 4 — 가격을 그래프에 연결하는 패턴 (D-18 경계 내)

### 핵심 발견

- **schema.org CompoundPriceSpecification = 다차원 가격 합성**: "여러 소비 차원에 병렬 적용되는 가격들을 묶는 명세." `priceComponent`가 병렬 적용되는 **UnitPriceSpecification 노드들**을 연결. 각 component의 `name`으로 **차원(dimension)을 지시**(예 "electricity", "final cleaning"). 출처: [CompoundPriceSpecification](https://schema.org/CompoundPriceSpecification) · [priceComponent](https://schema.org/priceComponent) · [UnitPriceSpecification](https://schema.org/UnitPriceSpecification).
- **PriceComponentTypeEnumeration** = component 유형(Installment·CleaningFee·ActivationFee·DistanceFee 등) 명시 제안. 출처: [schemaorg issue #2689](https://github.com/schemaorg/schemaorg/issues/2689) · [PriceSpecification](https://schema.org/PriceSpecification).
- **PropertyValue(additionalProperty)** = 임의 옵션·속성값 표현(옵션→가격 차원 연결 그릇). 출처: [PropertyValue](https://schema.org/PropertyValue).
- **한계(§35 이미 확인)**: schema.org Offer는 **정적 가격만** 표현. 동적 계산(후니 evaluate_price·와우 jobcost)은 **표준 어휘 없음**(§35 U-18 QuoteFunction=표준 공백). 온톨로지는 축·구성요소 연결까지.

### 후니 적용 시사점

- **채택 — CompoundPriceSpecification/priceComponent를 표준 이름표로 명시**: 후니 E9 price_formula ↔ **CompoundPriceSpecification**, E10 price_component ↔ **UnitPriceSpecification(priceComponent)**, `has_component`(R9) ↔ **priceComponent** 속성. §33이 E10에 "CompoundPriceSpecification(개념)"만 붙였는데, **R9 엣지에 priceComponent 이름표, component의 use_dims에 UnitPriceSpecification.name(차원 지시) 이름표**를 추가하면 표준 정합이 더 정밀해진다. 값 아님·이름표만(D-1). → structure-recommendations 개선-1.
- **채택 — 가격 차원 축을 PropertyValue로 명명**: 후니 use_dims(가격이 달라지는 축: 사이즈·수량·자재)·와우 6축을 **additionalProperty(PropertyValue)** 이름표로 통일(§35 U-13 AxisValueRef와 정합).
- **기각 — schema.org로 동적 가격 재현**: 표준 공백 확정(§35 §1.4). D-18 경계 유지. quote_function(E19) 노드가 계산 경계·값=서버 권위.
- **보완 — 가격 component 유형을 PriceComponentTypeEnumeration식으로 태깅**: 후니 prc_typ_cd(가격 유형)에 표준 enum 이름표(SetupFee=박 셋업비·UnitPrice=단가·AreaMatrix 등)를 병기하면 "이 옵션 고르면 왜 오르나"(S12) 설명 품질↑. → structure-recommendations 보완-2.

---

## GAP (정직 기록)

- **G-RES-1**: uEngine Ontology Studio의 **내부 사양(OCR→임베딩→Neo4j→골든질의 파이프라인 세부)**은 공개 문서 미확인 → 참조 아키텍처는 사용자 제공 서술 + 일반 ontology-driven GraphRAG 사례(deepsense.ai·OntoForge·Protégé→Neo4j)로 대체. ontology-studio-comparison.md에서 이 경계 명시.
- **G-RES-2**: AliCoCo 원논문 15p 정밀 레이어 구조(primitive concept 세분·연결 알고리즘)는 abstract/2차 요약까지만 확인(PDF 직독 미완). 4레이어 골자·니즈 노드 패턴은 확정, 구축 알고리즘 세부는 🟡.
- **G-RES-3**: Ontology Development 101(Noy & McGuinness) canonical URL(`protege.stanford.edu/.../ontology101.pdf`) 실접속 미검증(🟡). 방법론 골자(반복 구축)는 널리 인용된 사실.
- **G-RES-4**: GraphRAG global search의 후니 규모 실효(283상품에서 커뮤니티 요약이 실제 이득인지)는 그래프 빌드 후 실측 필요(설계 권고까지).

## Sources (본문 인라인 + 집약)
- 구축 방법론: [Grüninger & Fox](https://www.researchgate.net/publication/2288533_Methodology_for_the_Design_and_Evaluation_of_Ontologies) · [NeOn OEG-UPM](https://oeg.fi.upm.es/index.php/en/methodologies/59-neon-methodology/index.html) · [NeOn scenario paper](https://research.uni-sofia.bg/bitstream/10506/672/1/S3T2009_24_AGomez-Perez_MCSuarez-Figueroa.pdf) · [CQ roles (Springer)](https://link.springer.com/chapter/10.1007/978-3-031-77792-9_8) · [CQ types (arXiv)](https://arxiv.org/html/2412.13688v1) · [CQ survey](https://dl.acm.org/doi/10.1007/978-3-031-47262-6_3) · [CQ RAG gen](https://link.springer.com/chapter/10.1007/978-3-031-81974-2_6)
- 구성: [Soininen (ACM)](https://dl.acm.org/doi/abs/10.1017/S0890060498124083) · [Felfernig book (Elsevier)](https://shop.elsevier.com/books/knowledge-based-configuration/felfernig/978-0-12-415817-7) · [OWL config modeling (ScienceDirect)](https://www.sciencedirect.com/science/article/abs/pii/S0957417408002418) · [config meta-model](https://www.academia.edu/89503491/A_meta_model_for_product_configuration_ontologies) · [feature model CSP (arXiv)](https://arxiv.org/pdf/2304.13422) · [KBC Wikipedia](https://en.wikipedia.org/wiki/Knowledge-based_configuration)
- 추천 KG: [AliCoCo (arXiv)](https://arxiv.org/abs/2003.13230) · [AliCoCo SIGMOD](https://dl.acm.org/doi/10.1145/3318464.3386132) · [Amazon Broad KG](https://www.researchgate.net/publication/345426291_Building_a_Broad_Knowledge_Graph_for_Products) · [Amazon product graphs auto](https://www.amazon.science/blog/building-product-graphs-automatically) · [COSMO](https://www.amazon.science/publications/cosmo-a-large-scale-e-commerce-common-sense-knowledge-generation-and-serving-system-at-amazon) · [PKGM (arXiv)](https://arxiv.org/pdf/2203.00964) · [MS GraphRAG](https://www.microsoft.com/en-us/research/blog/graphrag-improving-global-search-via-dynamic-community-selection/) · [MS DRIFT](https://www.microsoft.com/en-us/research/blog/introducing-drift-search-combining-global-and-local-search-methods-to-improve-quality-and-efficiency/)
- 가격: [CompoundPriceSpecification](https://schema.org/CompoundPriceSpecification) · [priceComponent](https://schema.org/priceComponent) · [UnitPriceSpecification](https://schema.org/UnitPriceSpecification) · [PropertyValue](https://schema.org/PropertyValue) · [schemaorg #2689](https://github.com/schemaorg/schemaorg/issues/2689)
- LLM-KG 구축·자기개선: [LLM-KG construction survey (arXiv 2510.20345)](https://arxiv.org/abs/2510.20345) · [AutoSchemaKG (arXiv 2505.23628)](https://arxiv.org/pdf/2505.23628) · [Self-Refine](https://selfrefine.info/) · [Self-Refine (OpenReview)](https://openreview.net/pdf?id=S37hOerQLB) · [OpenAI self-evolving agents](https://developers.openai.com/cookbook/examples/partners/self_evolving_agents/autonomous_agent_retraining)
