# 렌즈 2 — 문서→지식그래프 구축 방법론 리서치

> 작성: 2026-07-03 · 작성자: okb-methodology-researcher (렌즈: 문서→지식그래프 구축)
> 질문: 비정형 문서(통화록·핸드오프·위키·엑셀 해설)에서 개체·관계를 뽑아 지식그래프(Knowledge Graph, KG — 개념들을 점(개체)과 선(관계)으로 잇는 지식 저장 방식)로 만들 때, 검증된 방법이 무엇인가.
> 선행 열람: `_workspace/excel-to-db/_meta/best-practices-playbook.md` · `docs/kb/KB_01` · `docs/kb/03_레드프린팅_경쟁분석_온톨로지전략.md` (레포 실증 = 1차 증거 원칙 준수)

---

## ① 핵심 발견 (실존 출처 포함)

### 발견 1. 문서→KG 구축은 3단 파이프라인이 표준이고, LLM 시대에도 골격은 같다

최신 서베이(분야 전체를 훑는 정리 논문)인 **"LLM-empowered knowledge graph construction: A survey"** (Bian, arXiv:2510.20345, 2025 — [https://arxiv.org/abs/2510.20345](https://arxiv.org/abs/2510.20345), 초록 직접 확인)는 LLM 기반 KG 구축을 다음 3단계로 정리한다.

1. **온톨로지 공학** — 어떤 종류의 개체·관계를 담을지 그릇(스키마)을 먼저 정함
2. **지식 추출** — 문서에서 개체(entity)와 관계(relation)를 뽑음
3. **지식 융합(fusion)** — 여러 원천에서 뽑힌 같은 개체를 하나로 합치고 충돌을 해소함

같은 서베이가 접근법을 두 갈래로 나눈다(초록 원문 확인): **schema-based**(스키마 우선 — 구조·정규화·일관성 중시) vs **schema-free**(개방 추출 — 유연성·새 발견 중시). 이 구분이 아래 발견 2의 핵심 쟁점이다.

### 발견 2. 스키마 우선 vs 개방 추출 — 개방 추출은 "잡동사니 개체" 유입이 실증된 약점

- 개방형 정보 추출(OpenIE — 스키마 없이 LLM이 마음대로 개체 이름을 지어내는 방식)에 대해, **Youtu-GraphRAG** 논문(arXiv:2508.19855 — [https://arxiv.org/pdf/2508.19855](https://arxiv.org/pdf/2508.19855))은 "열린 추출은 필연적으로 노이즈와 무관한 잡동사니를 그래프에 들여와 사용성을 떨어뜨린다"고 지적한다.
- 접근법 비교 연구 **"Ontology Learning and Knowledge Graph Construction: A Comparison of Approaches and Their Impact on RAG Performance"** (arXiv:2511.05991 — [https://arxiv.org/html/2511.05991v1](https://arxiv.org/html/2511.05991v1))는 **온톨로지에 붙들어 맨(ontology-grounded) 추출 + 원문 조각 연결**이 가장 높은 응답 품질과 최소 환각을 보였다고 보고한다.
- 의료 질의응답에서도 온톨로지 기반 KG가 환각을 줄인다는 결과가 있다(ScienceDirect, [https://www.sciencedirect.com/science/article/abs/pii/S1532046426000171](https://www.sciencedirect.com/science/article/abs/pii/S1532046426000171)).

**레포 실증과의 접점:** 우리 excel-to-db 플레이북(정본)도 "LLM 스키마/FK 추론 환각 → 프로파일링으로 후보를 데이터에서 확정 후 LLM은 판단만"을 이미 실증했다. 외부 연구와 레포 경험이 같은 결론이다.

### 발견 3. Entity Resolution(개체 통합 — 같은 개념의 다른 표기를 하나로 합치는 일)은 3단계가 정석이며, 우리 "표시중복" 문제와 동형이다

업계·학계 공통 절차 ([Entity Resolution at Scale, Medium](https://medium.com/@shereshevsky/entity-resolution-at-scale-deduplication-strategies-for-knowledge-graph-construction-7499a60a97c3) · [The Rise of Semantic Entity Resolution, Towards Data Science](https://towardsdatascience.com/the-rise-of-semantic-entity-resolution/)):

1. **Blocking(후보 묶기)** — 전건 비교(n²)를 피하려 비슷한 것끼리 미리 묶음. 타입(개체 종류)별로 묶는 방식이 일관되게 강함.
2. **Matching(판정)** — 묶음 안에서 "같은 실체인가"를 판정.
3. **Merging(병합)** — 같다고 판정된 것들을 대표(canonical) 하나로 합치고 링크를 이어붙임.

대표 오픈소스 도구는 **Splink**(영국 법무부 제작, Fellegi-Sunter 확률 모델 — 데이터의 실제 오류율에서 일치 확률을 학습, 노트북에서 100만 건 2분 처리 — [https://github.com/moj-analytical-services/splink](https://github.com/moj-analytical-services/splink) · [소개 블로그](https://www.robinlinacre.com/introducing_splink/)).

**레포 실증과의 접점(중요):** §17 기초데이터 표시중복 하네스가 이미 이 문제를 풀었고, 두 가지 교훈을 남겼다.
- 정답 절차 = "권위에서 canonical(의미축+정규치수+단위) 도출 → 라이브 환원 → 충돌 검출" — 즉 **확률 매칭이 아니라 권위 기준 결정론 대조**가 우리 규모의 정답.
- **fuzzy(어림) 자동병합의 false-positive가 의미구분을 파괴**한다(작업사이즈 vs 재단사이즈 — 표기는 같아 보여도 의미가 다름). 플레이북 함정 목록에도 등재됨.

### 발견 4. 동의어 관리의 사실상 표준 = SKOS 라벨 3종 모델 (파일로도 구현 가능)

W3C 표준 **SKOS**(Simple Knowledge Organization System — 용어집·분류체계를 표현하는 웹 표준)의 라벨 모델이 "같은 개념 다른 표기" 관리의 정석이다 ([SKOS Primer, W3C](https://www.w3.org/TR/skos-primer/) · [SKOS Reference](https://www.w3.org/TR/skos-reference/) · [CSIRO 실무 가이드](https://csiro-enviro-informatics.github.io/info-engineering/skos-bp.html)):

| 라벨 | 뜻 | 후니 예 |
|------|-----|---------|
| `prefLabel` | 대표 표기 — 언어당 딱 1개, 시스템 전체에서 중복 금지 | "도무송" |
| `altLabel` | 동의어·약어 — 여러 개 가능 | "완칼", "왕칼" |
| `hiddenLabel` | 검색엔진용 오표기·변형 — 사람에겐 안 보임 | "도무숑"(오타) |

+ 각 개념에 `definition`(정의문) 1개 필수. — 이 모델은 트리플스토어(전용 그래프 DB) 없이 **표/파일로 그대로** 구현 가능하다.

**레포 접점:** `docs/kb/03` 문서의 Seed 용어집 산출물 정의(canonical_term / synonyms / definition / process_mapping)가 이미 SKOS 모델과 사실상 같은 모양이다. 표준과 우리 계획이 수렴함을 확인.

### 발견 5. LLM 기반 KG 구축의 환각 개체 — 근본 원인은 "출처 없음", 방지책은 4계열

- **원인 진단:** "LLM은 원문이 지지하지 않는 그럴듯한 트리플(개체-관계-개체 3요소)을 자주 지어낸다. 근본 원인은 provenance(출처 추적 — 이 주장이 원문 어디서 왔는지) 부재 — 트리플과 원문의 명시적 연결이 없어 검증 자체가 불가능해진다." — **"Grounded Knowledge Graph Extraction via LLMs: An Anchor-Constrained Framework with Provenance Tracking"** (Computers 저널, doi:[10.3390/computers15030178](https://doi.org/10.3390/computers15030178) — 본문은 403으로 미열람, 제목·요지는 검색 결과 초록 기준. ④에 재확인 항목으로 등재).
- **방지책 계열 (외부 연구):**
  - (a) **출처 앵커 강제** — 모든 트리플에 원문 위치(문자/행 단위)를 달아 추적 가능하게 (위 논문).
  - (b) **역변환 검증** — 뽑힌 트리플을 다시 문장으로 되돌려 원문과 대조 (Knowledge Restoration, arXiv:2601.15037 — [https://arxiv.org/pdf/2601.15037](https://arxiv.org/pdf/2601.15037)); 원문↔산출 양방향 트리플 대조(GraphEval+ 계열, [awesome-hallucination-detection 목록](https://github.com/EdinburghNLP/awesome-hallucination-detection)).
  - (c) **자기일관성 검사** — 여러 번 생성해 서로 대조(SelfCheckGPT·FactSelfCheck, arXiv:2503.17229 — [https://arxiv.org/pdf/2503.17229](https://arxiv.org/pdf/2503.17229)).
  - (d) **폐쇄 어휘 강제** — 스키마에 있는 개체·관계 이름만 쓰게 제한(발견 2의 ontology-grounded 계열).
- **레포 실증이 이기는 지점:** 플레이북 횡단 원칙 3 — "자기일관 오류는 자기검증 불가 → 교차검증". 즉 (c) 단독은 우리 레포에서 이미 한계가 실증됐고, **생성≠검증 + 다른 모델 계열(codex) 교차 + 결정론 대조(wiring_scan류)**가 우리의 검증된 조합이다. 외부 (a)(b)(d)는 이 조합에 **추가**할 가치가 있고, (c)는 보조 이상이 못 된다.

### 발견 6. GraphRAG식 "문서 전체 LLM 추출" 인덱싱은 비싸고, 소규모·기구조화 원천에는 과하다

- Microsoft **GraphRAG** 원 논문(arXiv:2404.16130 — [https://arxiv.org/abs/2404.16130](https://arxiv.org/abs/2404.16130))의 구축 방식 = 문서를 청크(조각)로 잘라 LLM으로 개체·관계 추출 → 중복 개체는 같은 노드로 흡수 → 커뮤니티(연관 개체 묶음) 요약 생성. 유용한 세부 실측: **청크 600토큰이 2400토큰 대비 개체를 2배 추출**(작게 잘라야 덜 놓침), gleaning(재추출 반복)으로 누락 보완.
- 비용: 전통 GraphRAG는 문서당 $4–7 수준 vs 경량 대안 **LightRAG**는 $0.15 수준이라는 비교 보고 ([LightRAG 소개, Medium/Accelerated Analyst](https://medium.com/accelerated-analyst/lightrag-a-better-approach-to-graph-enhanced-retrieval-augmented-generation-0ac9e7bf9b74) · [LightRAG 공식](https://lightrag.github.io/) — 2차 출처 수치이므로 ④ 재확인 대상). **nano-graphrag** 같은 경량 구현도 존재 ([분석 글](https://gonamlui.com/blog/brief-breakdown-of-nano-graphrag-a-lightweight-alternative-to-graphrag)).
- **후니에 주는 함의:** 후니의 개체 대부분은 이미 **문서가 아니라 DB에 코드로 존재**한다(상품 283개 = prd_cd, 구성요소 = comp_cd, 공정 = proc_cd …). "텍스트에서 개체를 발견"하는 비싼 단계가 거의 필요 없고, 문서에서 뽑을 것은 **기존 코드들 사이의 관계·설명·결정 이력**이다. 이는 발견 2의 스키마 우선 노선을 한층 더 강하게 뒷받침한다.

---

## ② 후니 적용 권고 (채택 / 기각 / 보류 + 이유)

후니 규모 전제: 상품 283개 · t_* 34테이블 · 단일 운영자 · git 레포(파일 기반). "수억 건 웹 문서"용 기법은 기본적으로 과하다.

| # | 항목 | 판정 | 이유 |
|---|------|------|------|
| R1 | **스키마 우선(폐쇄 스키마) 추출** — KG의 개체 목록은 라이브 DB 코드(prd_cd·comp_cd·proc_cd·siz_cd…)와 SOT 분류(§1)에서 시작. LLM은 문서를 읽고 **기존 개체에 링크만** 하고, 새 개체 발명(mint) 금지. 새 개체 후보는 별도 큐로 격리 후 인간 승인 | **채택** | 발견 2·6: 개방 추출은 노이즈 실증, 후니 개체는 이미 DB에 실재. 레포의 search-before-mint 원칙(§11·§18)의 자연 확장. 환각 개체를 원천 차단하는 가장 싼 방법 |
| R2 | **환각 개체 필터 = 결정론 코드-실재 검사** — LLM이 산출한 모든 개체 참조를 스크립트가 라이브 DB/코드테이블과 대조(토큰 0), 미실재 참조는 전건 사유와 함께 반려 | **채택** | 발견 5(d)의 폐쇄 어휘 강제를 우리 방식(wiring_scan류 결정론 diff)으로 구현. 플레이북 "silent 금지"와 정합 |
| R3 | **전 블록 출처(provenance) 앵커 필수** — KG의 모든 관계·주장에 `파일:행` 또는 `테이블:코드` 앵커를 강제. 앵커 없는 주장은 게이트에서 자동 FAIL | **채택** | 발견 5(a): 환각의 근본 원인 = 출처 부재. §9 위키의 "모든 블록 출처+badge 필수"가 이미 같은 원칙을 실증 — KG로 그대로 승계 |
| R4 | **동의어 = SKOS 3라벨 모델의 파일 기반 경량판** — 개념당 prefLabel 1개(전역 중복 금지)+altLabel 다수+definition 1개. `docs/kb/03`의 Seed 용어집 스키마에 hiddenLabel(오표기)만 추가 | **채택** | 발견 4: W3C 표준이며 표/파일로 구현 가능(추가 인프라 0). 김동학 통화 합의("룰 먼저")·기존 용어집 계획과 수렴 |
| R5 | **entity resolution은 "권위 기준 결정론 대조 + 인간 승인 큐"** — canonical 도출→라이브 환원→충돌 검출(§17 실증 절차)을 KG 구축에도 그대로 사용. 자동 병합은 하지 않고 병합 후보 목록만 산출 | **채택** | 발견 3: 우리 표시중복 해법이 이미 학계 3단계(blocking→matching→merging)의 소규모 최적형. fuzzy 자동병합 false-positive(작업vs재단)가 레포에서 실증된 함정 |
| R6 | **생성≠검증 + codex 교차 + 역변환 대조를 KG 게이트로** — 추출 에이전트와 검증 에이전트 분리, 표본 트리플을 문장으로 되돌려 원문 대조(발견 5(b)) | **채택** | 레포 전 하네스 공통 실증 + 외부 연구(Knowledge Restoration·GraphEval+ 계열)가 같은 방향. 역변환 대조만 신규 추가분 |
| R7 | **문서 추출 시 청크는 작게(제목 단위 블록, 대략 600토큰 이하)** + 누락 의심 시 재추출(gleaning) | **채택** | 발견 6: GraphRAG 실측(600 vs 2400 = 개체 2배). 우리 문서는 마크다운 제목 구조가 있어 자연 경계로 자르면 됨 |
| R8 | **확률적 ER 도구 도입(Splink·Zingg·dedupe 등)** | **기각** | 발견 3: 100만~억 단위 레코드용. 후니는 코드 수백~수천 건·단일 운영자 — 학습시킬 데이터도, 학습할 필요도 없음. R5로 충분 |
| R9 | **Microsoft GraphRAG 전체 인덱싱 파이프라인(LLM 전면 추출+커뮤니티 요약) 채택** | **기각** | 발견 6: 비용 과다(문서당 $4–7 보고)·개체 발견 단계가 후니엔 불필요(개체=DB 코드 실재). 단, 그래프+문서 하이브리드 "검색" 활용 여부는 렌즈 3(GraphRAG·LLM 친화 KB) 소관 — 여기선 "구축 방식으로서" 기각 |
| R10 | **개방 추출(OpenIE) 단독 사용** | **기각** | 발견 2: 노이즈·잡동사니 실증. 단 "새 개념 후보 발굴" 용도로 R1의 격리 큐에 한정 허용(승인 전 KG 미반영) |
| R11 | **NLI(문장 함의 판정) 전용 검증 모델 추가 도입** | **보류** | 발견 5(b) 계열이지만, codex 교차검증이 이미 독립 2차 역할을 수행 중. 추가 모델의 한국어 인쇄 도메인 성능 미검증 — 게이트 FAIL이 누적돼 검증 병목이 실증되면 재검토 |
| R12 | **경쟁사 코퍼스 동의어 자동 클러스터링**(`docs/kb/03` §4.1 정렬 단계) | **보류** | 통화 합의("룰을 상호 협의로 정의 먼저") 준수: Seed 용어집(R4)이 서고 검증 게이트가 작동한 뒤에 자동 정렬을 붙여야 함. false-positive 가드(R5) 없이 먼저 돌리면 §17 함정 재현 위험 |

---

## ③ 설계자(okb-ontology-architect)에게 넘길 결정 항목

1. **개체 ID 체계** — KG 노드 ID를 라이브 코드(prd_cd·comp_cd…)에 직결할지, 별도 URI(웹 주소형 식별자) 층을 둘지. 리서처 권고: **직결**(코드가 이미 유일·안정·검증 스크립트와 호환). 단, DB에 없는 개념(도메인 용어·결정·규칙)의 ID 규칙(예: `TERM_*`, `RULE_*`)은 설계자가 정의 필요.
2. **용어집 스키마 확정** — canonical_term / synonyms(altLabel) / hidden(오표기) / definition / source / status(확정·후보) 필드 구성과, §17 표시중복 판정 산출물과의 **단일 원천 통합** 여부(이중 관리 금지 원칙상 통합 권고).
3. **관계 어휘(relation vocabulary) 폐쇄 목록** — 몇 개의 관계 타입으로 시작할지. 리서처 권고: t_* FK에서 기계적으로 유도되는 관계(has_option·priced_by·member_of·uses_material…)를 1차 목록으로 하고, 문서 유래 관계(decided_because·supersedes·conflicts_with 등)는 소수만 추가. 개방 관계명 금지(R1과 동일 논리).
4. **문서 추출 범위와 우선순위** — docs/kb 6종·각 하네스 HANDOFF/CHANGELOG·§9 위키 중 무엇을 1차 코퍼스로 할지, 청크 경계(마크다운 제목 블록 권고, R7).
5. **환각 필터 게이트 배치** — R2 결정론 검사를 추출 직후 인라인으로 둘지, 검증 단계에서 일괄로 둘지(리서처 권고: 인라인 — 오염이 하류로 전파되기 전에 차단, 플레이북 fail-fast 정합).
6. **새 개체 후보 큐의 승인 절차** — R1 격리 큐를 누가·어떤 근거로 승인하는지(단일 운영자 환경에 맞는 최소 절차).

---

## ④ 미확인 / 추가 조사 필요

1. **Anchor-Constrained 논문 본문 미열람** — doi:10.3390/computers15030178은 MDPI 403 차단으로 초록 수준(검색 결과)만 확인. 문자 단위 provenance의 구체 구현(프롬프트·후처리)을 설계에 쓰려면 본문 재시도 필요.
2. **LightRAG 비용 수치($0.15 vs $4–7)는 2차 출처(블로그)** — 원 논문(LightRAG, HKU) 수치로 재확인 필요. 다만 R9 기각 판정은 이 수치 없이도 성립(후니 개체=DB 실재).
3. **한국어 + 인쇄 도메인 특화 개체 추출 연구 미탐색** — 이번 검색은 영어권 일반 도메인 중심. 한국어 혼용 문서(우리 코퍼스)의 추출 정확도 편차는 파일럿에서 실측으로 확인하는 편이 빠를 것.
4. **agentic KB 유지보수(KARMA 등)·staleness 관리** — 렌즈 4(자기회귀 개선 루프) 소관이라 본 문서에서 의도적으로 제외.
5. **그래프 저장·질의 형식(파일 vs 그래프 DB)** — 구축이 아니라 활용 문제라 렌즈 3 소관. 본 렌즈의 R1~R7은 저장 형식과 무관하게 성립.
