# CHANGELOG — Huni-Multibrand-Ontology (§35)

> 최신이 위(PREPEND). rules 파일(`.claude/rules/harness/huni-multibrand-ontology.md`)의 "변경이력:" 라인은 최신 1줄 포인터만.

## 2026-07-04 — tykimos 추출 + 질의 시뮬레이터 명세

- **tykimos/ontoair·onto-osint 추출**(→ `00_research/structure/tykimos-onto-projects-extraction.md`): Onto-OSINT=후니 형제 아키텍처(Claude·파일 핸드오프·경량 JSON·Neo4j/임베딩 배제)→경량 원칙 외부검증. 추출 개선(엣지 confidence·추론로그)/보완(★근거 N+ 승격 임계=키스톤 게이트·시간태깅 노후/드리프트)/확장(Reasoner 추론규칙·자동 재수집·config 브랜드확장). OntoAir=시각화 도구(RDF/OWL·연구용 비오픈)·아이디어만.
- **질의 결합 시뮬레이터 명세**(→ `00_research/structure/query-simulator-spec.md`): ★결정 — 온톨로지 스튜디오 *행위*(질의→순회→답+하이라이트) 채택, 무거운 기질(Neo4j/OCR/임베딩) 기각→**우리 경량 그래프+nl-query-paths 위에** 얹음. OntoAir=시각화 아이디어만(코드 재사용 불가). 5단계 파이프라인(용어해석→경로순회→경계호출→답합성→시각화)·재사용 자산 조립(nl-query-paths×3·product_viewer/Cytoscape·evaluate_price)·경계=엔진 값 권위(D-18/D-ROUTE). 파일럿 P1(Q1 명함 후니vs와우 종단)→P2~P4. 명세까지·DB 미적재.

## 2026-07-04 — Phase 1~5 실행 + 구조 리서치 + 라우팅 층 설계·검증

- **Phase 1~4 완주** — mbo-standards-researcher(00_research·상위개념22)∥mbo-catalog-analyst(01_analysis·와우 326상품 전량 quoted/jobcost·13 CSV 스크립트 전사) → mbo-crossbrand-mapper(02_crossbrand·정렬16쌍·4대 델타·최대=인쇄방식 prsjob) → mbo-ontology-architect(03_upper_ontology·개체17→22·관계19→23·NL질의10) → mbo-verify-gate(04_verification·**MB1~MB7 전부 GO**·codex 교차). ★팀 파일 버그: Agent `name` 파라미터 사용 시 "team file not found" → **name 없이 foreground 실행**으로 우회(전 에이전트 정상).
- **아키텍처 결정(사용자 확정)**: **독립 시작 후 나중에 통합**(옵션 C·게이트 권고와 일치). §33 골든 보호+와우 노후 격리 후 안정화 시 단일 그래프 머지.
- **★북극성 재정의(사용자)**: 자연어 질의 → **원자 단위 의미 연결** → 추천+가격 → **(추후) 인쇄소 주문 라우팅**. 참조=uEngine Ontology Studio(Golden Question 주도·문서→OCR→임베딩→Neo4j·GraphRAG). 지시=국내외 논문·표준·베스트프랙티스로 개선/보완/확장/수정.
- **구조 리서치**(→ `00_research/structure/` 5파일): okb-methodology-researcher(추천·구성 KG·AliCoCo·TOVE/NeOn CQ·Soininen/Felfernig·MS GraphRAG·schema.org 가격)∥mbo-standards-researcher(라우팅·CIP4 PrintTalk·MSDL·schema.org broker). ★결론: 후니 방식=정통(NeOn 시나리오2 재공학·CQ 주도)·**스키마-우선 닫힌세계 앵커가 범용 도구보다 환각 차단 우위**. 최우선 보완=intent 원자 분해(키스톤). 최대 갭=라우팅 층 부재. 수정=임베딩/트리플스토어/OWL/개방추출 **기각 유지(과공학)**.
- **라우팅 층 설계·검증**(→ `03_upper_ontology/routing-layer-schema.md`·`nl-query-paths-routing.md`·`04_verification/gate-verdict-routing-2026-07-04.md`): 신규 개체 E22~E25(supplier·production_capability·fulfillment_order·routing_function)·관계 RT-1~RT-6(폐쇄목록23→29)·상위개념 U-23~U-27. ★capability_covers=기존 생산 축 재사용(재발명0). 경계 D-ROUTE(D-18 동형·값=엔진). **전 실물 노드 anchor=none+candidate+gap_ref=G-ROUTE-1**(공급자 데이터 0·지어내기 차단). RQ1~RQ6 경로 성립. **게이트 GO 7/7**·codex 교차(NO-GO 주장 D-18 선례로 기각)·Low 3 정정 완료.

## 2026-07-04 — 하네스 초기 구성

- **신규 §35 하네스 구성** — 경쟁사(와우프레스 우선·레드 확장) 상품 정밀 분석 → 후니(§33 KB) 교차 연관 →
  국제 인쇄표준(CIP4/XJDF·schema.org·구성 온톨로지) 기반 브랜드-중립 상위 온톨로지 설계. 목표=자연어→추천→가격→주문 확장.
- **사용자 결정 반영**: ① 아키텍처 커밋 지연(§33 확장 vs 독립 §35, 게이트 후 인간 승인) ② 상위 온톨로지·표준 먼저.
- **팀 5인**: mbo-standards-researcher ∥ mbo-catalog-analyst(기준점 병렬) → mbo-crossbrand-mapper(차이 지도) →
  mbo-ontology-architect(상위 온톨로지 설계) → mbo-verify-gate(MB1~MB7 게이트+아키텍처 권고).
- **방법론 스킬 5**: mbo-catalog-analysis·mbo-standards-research·mbo-crossbrand-mapping·mbo-ontology-design·mbo-verify-gate-validation.
- **오케스트레이터**: huni-multibrand-ontology-orchestrator(Phase 0 컨텍스트 확인 → 1 병렬 팬아웃 → 2 차이 지도 →
  3 상위 온톨로지 → 4 게이트 → 5 인간 승인 아키텍처 결정).
- **핵심 설계**: 와우 앵커 네임스페이스(catalog/api/pdf·지어내기 차단 유지)·가격 경계 동형(값=브랜드별 엔진/API)·
  브랜드축+교차관계(same_family_as/price_model_differs/component_differs)·§33 골든 재사용·무손상.
- 등록: 루트 CLAUDE.md 레지스트리 §35 행 + `.claude/rules/harness/huni-multibrand-ontology.md`(경로 게이트).
- 상태: 구성 완료·미실행(00~04 스캐폴드만). 다음=Phase 1 실행.
