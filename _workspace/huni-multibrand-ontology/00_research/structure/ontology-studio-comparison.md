# Ontology Studio 패턴 대비 — 현행 §33/§35 구조 (배울 것 vs 이미 나은 것)

> 작성: 2026-07-04 · mbo-standards-researcher(구조 렌즈).
> 참조 시스템 = uEngine Ontology Studio(사용자 제공 서술: 문서→OCR→임베딩→Neo4j 그래프→온톨로지 빌드·Golden Question 주도·GraphRAG형 Q&A).
> [HARD] uEngine 내부 사양은 공개 문서 미확인(G-RES-1) → **일반 ontology-driven GraphRAG 사례**로 대체 비교하고 경계 명시. 지어내기 금지.

---

## 0. Ontology Studio류 파이프라인 (참조 아키텍처)

사용자 서술 + 일반 사례([deepsense.ai ontology-driven KG for GraphRAG](https://deepsense.ai/resource/ontology-driven-knowledge-graph-for-graphrag/) · [OntoForge (Neo4j-native ontology studio)](https://github.com/rawe/ontoforge) · [Protégé→Neo4j GraphRAG](https://medium.com/@visrow/prot%C3%A9g%C3%A9-to-neo4j-graphrag-transforming-owl-ontologies-into-ai-ready-powerful-knowledge-graphs-700963c46a42))에서 공통 단계:

| 단계 | Ontology Studio류 | 후니 §33/§35 대응 |
|---|---|---|
| S1 원천 수집 | 문서 업로드 | 260702 엑셀·live-snapshot·와우 catalog JSON (구조화 원천·OCR 불필요) |
| S2 텍스트화 | **OCR**(스캔 문서) | **불필요**(원천이 이미 표/코드·결정론 전사) |
| S3 청킹·임베딩 | 벡터 임베딩 | 용어집(term alias)·index.md 진입점(결정론) — 임베딩은 선택 보류 |
| S4 개체·관계 추출 | **LLM 추출**(스키마 유도 or 개방) | **스키마-우선**(FK 결정론 유도 + 문서 집필) |
| S5 그래프 적재 | **Neo4j** | markdown 정본 → nodes/edges.jsonl → **SQLite 3층** |
| S6 온톨로지 빌드 | 스키마 정의(Protégé/UI) | ontology-schema.md(개체17·관계19) + 상위22 |
| S7 검증 주도 | **Golden Question** | **nl-query-paths(CQ 16+Q10)** = 동일 개념 |
| S8 Q&A | **GraphRAG**(local+global) | 하이브리드 2단(노드확정→경로탐색+정본 Read) |

---

## 1. Ontology Studio에서 배울 것 (후니 보강 후보)

1. **[배운다] Golden Question을 구축 드라이버로 전면화**
   Ontology Studio는 Golden Question이 "무엇을 채울지"를 역으로 규정한다(질의가 안 되면 채운다). 후니는 nl-query-paths가 **사후 증명**에 가깝다. → **CQ를 구축 백로그로 전환**(질의 실패 → 노드/엣지 보강 티켓). 프론트1 TOVE ④와 정합. → structure-recommendations E-2.

2. **[배운다] Global(집계·주제) 질의 = GraphRAG community summary**
   Ontology Studio/GraphRAG는 local(엔티티 이웃)뿐 아니라 **global(커뮤니티 요약)**을 답한다. 후니 하이브리드 2단은 local 중심. "명함류에 흔한 후가공" 같은 집계 질의는 category/family를 커뮤니티로 삼는 **요약 노드**가 필요. 출처: [MS GraphRAG](https://www.microsoft.com/en-us/research/blog/graphrag-improving-global-search-via-dynamic-community-selection/). → structure-recommendations E-1.

3. **[배운다·조건부] 임베딩 진입(1단 노드 확정의 표현 다양성)**
   자연어 진입에서 "카페 오픈 기념품"·"돌잔치 답례" 같은 미등록 표현은 용어집 alias만으론 못 잡는다. Ontology Studio는 임베딩으로 근접 노드를 찾는다. → **선택적 임베딩 진입**(term/intent 노드 임베딩 매칭)은 **보류**(값·추론 아닌 라우팅 보조로만·환각 경계). 결정론 alias가 1차, 임베딩은 fallback.

4. **[배운다] 원천 provenance를 노드에 강제(Studio도 doc→span 추적)**
   후니는 이미 출처 5필드로 이걸 한다 = 오히려 후니가 더 엄격. (배울 것 아님·재확인)

---

## 2. 후니가 이미 더 나은 것 (Ontology Studio류 대비 우위)

1. **[우위] 스키마-우선 + 닫힌세계 앵커 = 환각 개체 원천 차단**
   Ontology Studio류 LLM 추출은 **환각 관계**(co-mention을 인과로 오인) 위험이 상존한다. 출처: [LLM-KG construction survey (arXiv 2510.20345)](https://arxiv.org/abs/2510.20345)(자동 검증·외부 KB 대조로 완화 시도). 후니는 **모든 노드가 실 앵커(t_*/엑셀 셀) or GAP**(D-6) → 환각 개체가 **구조적으로 불가능**. 개방추출(AutoSchemaKG류)보다 정밀·감사 가능. 출처: [AutoSchemaKG (arXiv 2505.23628)](https://arxiv.org/pdf/2505.23628)(개방추출은 유연하나 노이즈↑).

2. **[우위] 파일=정본, 그래프=파생 (Karpathy형)**
   Ontology Studio는 Neo4j가 정본이라 그래프 오염 시 원천 추적이 약할 수 있다. 후니는 **markdown 정본 → 그래프 파생**이라 그래프를 언제든 재빌드(멱등)·인간 가독·git 이력. §33 실증(build_graph.py·275상품 멱등).

3. **[우위] 생성≠검증 분리가 하네스에 내장**
   Ontology Studio류는 LLM 추출→적재가 한 파이프라인. 후니는 **생성(집필) ↔ 검증(okb-adversarial-gate·codex 교차·결정론 diff)** 분리. Amazon COSMO(LLM 생성 + 인간/ML 검증)와 동형이나, 후니는 이를 **하네스 규약(⑤ codex 폴백·게이트)**으로 상시화. 출처: [COSMO (Amazon Science)](https://www.amazon.science/publications/cosmo-a-large-scale-e-commerce-common-sense-knowledge-generation-and-serving-system-at-amazon).

4. **[우위] 가격 경계(D-18) 명시 = 값 날조 차단**
   Ontology Studio류는 그래프에 값을 넣으면 노후·오염 위험. 후니는 **값=서버 권위(evaluate_price/jobcost), 온톨로지는 축·연결까지**로 경계를 노드(quote_function)로 명시. 동적 가격 표준 공백(§35 U-18)을 정직 표기.

5. **[우위] 규모 적정성**
   Ontology Studio/Neo4j/임베딩/커뮤니티 탐지는 대규모(수십억 노드) 전제. 후니 283상품·1485노드엔 SQLite 3층 + 결정론 트리(category/family)가 **더 단순·검증가능**. 대규모 트리플스토어·OWL 추론기·KG 임베딩 사전학습은 과공학(기각).

---

## 3. 대비 요약 (결정 지향)

| 항목 | Ontology Studio류 | 후니 현행 | 결론 |
|---|---|---|---|
| 원천→텍스트 | OCR+임베딩 | 결정론 전사(엑셀/코드) | 후니 유지(OCR 불요) |
| 개체·관계 추출 | LLM 개방/유도 | 스키마-우선 FK+집필 | **후니 우위**(환각 차단) |
| 저장 | Neo4j | 파일 정본→SQLite | **후니 우위**(멱등·가독) |
| 검증 | 파이프라인 내 | 생성≠검증 게이트 | **후니 우위** |
| Golden Question | 구축 드라이버 | 사후 증명 | **배운다**(E-2 전면화) |
| Global/집계 질의 | community summary | local 중심 | **배운다**(E-1 요약노드) |
| NL 진입 다양성 | 임베딩 | alias 결정론 | **보류**(임베딩 fallback) |
| 규모 | 대규모 | 소규모 적정 | 후니 유지 |

## GAP
- **G-CMP-1**: uEngine Ontology Studio 실제 내부(골든질의 자동화 정도·임베딩 모델·Neo4j 스키마 강제 여부) 미확인 → 위 비교는 "일반 ontology-driven GraphRAG 패턴" 기준. uEngine 데모/문서 확보 시 재대조.
- **G-CMP-2**: 후니 하이브리드 2단의 실 질의 품질은 그래프 빌드·질의 엔진 구현 후 실측(설계 대비까지).

## Sources
- [deepsense.ai ontology-driven KG for GraphRAG](https://deepsense.ai/resource/ontology-driven-knowledge-graph-for-graphrag/) · [OntoForge](https://github.com/rawe/ontoforge) · [Protégé→Neo4j GraphRAG](https://medium.com/@visrow/prot%C3%A9g%C3%A9-to-neo4j-graphrag-transforming-owl-ontologies-into-ai-ready-powerful-knowledge-graphs-700963c46a42)
- [MS GraphRAG global/local](https://www.microsoft.com/en-us/research/blog/graphrag-improving-global-search-via-dynamic-community-selection/) · [LLM-KG survey (arXiv)](https://arxiv.org/abs/2510.20345) · [AutoSchemaKG (arXiv)](https://arxiv.org/pdf/2505.23628) · [COSMO (Amazon)](https://www.amazon.science/publications/cosmo-a-large-scale-e-commerce-common-sense-knowledge-generation-and-serving-system-at-amazon)
- 후니 현행: §33 `02_ontology/ontology-schema.md`·`nl-query-paths.md`·`graph-build-spec.md` · §35 `03_upper_ontology/*`
