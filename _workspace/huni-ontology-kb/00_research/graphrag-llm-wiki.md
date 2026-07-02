# 렌즈 3 — GraphRAG · LLM 친화 지식베이스 (그래프 저장 형식 권고 포함)

> 작성: 2026-07-03 · okb-methodology-researcher
> 배정 렌즈: Microsoft GraphRAG / 파일 기반 위키(Karpathy 모델) / llms.txt / 하이브리드(그래프+문서) 검색 / 임베딩 vs 그래프 탐색 trade-off / ★그래프 저장 형식 권고
> 전제(사용자 확정): **파일=정본(正本), 그래프=파생 빌드** — 그래프는 언제든 파일에서 다시 만들 수 있는 "빌드 산출물"이다.
> 후니 규모 기준: 상품 283개 · t_* 34테이블 · 단일 운영자 · git 레포(서버 없음).

---

## 용어 풀이 (처음 나오는 기술용어)

| 용어 | 쉬운 설명 |
|---|---|
| RAG (Retrieval-Augmented Generation, 검색증강생성) | AI가 답하기 전에 관련 자료를 먼저 찾아 읽고 답하게 하는 방식 |
| GraphRAG (그래프 기반 RAG) | 자료를 "개체(점)와 관계(선)의 그물망(지식그래프)"으로 만들어 두고, 그 그물망을 따라가며 답을 찾는 RAG |
| 임베딩 (embedding) | 글을 숫자 벡터로 바꿔 "의미가 비슷한 글"을 수학적으로 찾게 하는 기술 |
| 커뮤니티 요약 | 그래프에서 서로 가까운 점들의 묶음(커뮤니티)마다 미리 만들어 두는 요약문 |
| 엣지 테이블 (edge table) | "A가 B와 연결됨"을 한 줄씩 담는 표. 표 두 개(점 목록·선 목록)만으로 그래프를 저장하는 가장 단순한 방식 |
| 임베디드 DB (embedded database) | 서버를 따로 띄우지 않고 파일 하나로 동작하는 데이터베이스(예: SQLite) |

---

## ① 핵심 발견 (출처 포함)

### 발견 1. Microsoft GraphRAG의 본질 = "비정형 글 → 그래프" 변환기. 후니는 그 단계가 필요 없다

Microsoft GraphRAG(논문 [arXiv:2404.16130](https://arxiv.org/abs/2404.16130), 2024)는 ① LLM이 원문에서 개체·관계를 **추출**해 지식그래프를 만들고 ② 그래프를 커뮤니티로 나눠 ③ 커뮤니티마다 요약을 미리 생성해 두는 3단계다. 이 방식의 가치는 "**구조가 없는 대량의 글**"에서 전체 조망형 질문("이 문서 전체의 주제는?")에 답하게 하는 것이다.

핵심 시사점: **후니의 지식은 이미 구조화되어 있다.** 상품 283개·자재·공정·옵션·가격공식은 라이브 t_* 34테이블에 FK(외래키)로, 위키(§9)에는 [[교차참조]]로 이미 관계가 명시돼 있다. 즉 GraphRAG의 가장 비싸고 가장 위험한 단계(LLM 개체 추출 — 환각 개체 위험)가 후니에서는 **애초에 불필요**하다. 그래프는 DB의 FK와 파일의 교차참조에서 **결정론적으로(스크립트로, LLM 없이)** 뽑아내면 된다. 이는 이 레포의 기존 실증(§27 `wiring_scan.py` — 라이브 스냅샷 결정론 diff, 토큰 0)과 정확히 같은 계보다.

### 발견 2. 사전 요약(커뮤니티 요약)은 비용 함정 — LazyGraphRAG가 스스로 입증

원조 GraphRAG는 색인(indexing) 단계에서 모든 개체·커뮤니티를 LLM으로 요약하느라 비용이 매우 크다. Microsoft Research 스스로 2024-11 **LazyGraphRAG**를 발표하며 "색인 비용을 원조의 0.1%로(벡터 RAG와 동일 수준), 요약은 질의 시점으로 미룬다"고 밝혔다([Microsoft Research 블로그](https://www.microsoft.com/en-us/research/blog/lazygraphrag-setting-a-new-standard-for-quality-and-cost/), [The Stack 보도](https://www.thestack.technology/microsoft-lazygraphrag/)). 교훈: **미리 다 요약해 두지 말고, 가벼운 그래프만 만들어 두고 무거운 생성은 질문 들어올 때 하라.** §9 위키가 이미 "질의 시 index.md 먼저 읽기"로 같은 원리를 쓰고 있다.

### 발견 3. GraphRAG가 항상 이기지 않는다 — 작은 코퍼스에서는 벡터/단순 검색과 비슷하거나 밀림

체계적 비교 연구 "RAG vs. GraphRAG"([arXiv:2502.11371](https://arxiv.org/html/2502.11371v3))의 결론: 코퍼스가 작으면(수만 단어 수준) 일반 RAG가 GraphRAG와 비슷하거나 오히려 낫고, 그래프 구축이 **잡음(distractor)을 더할 수 있다**. 성능은 과제 의존적 — 사실 조회형 질문은 일반 검색이, 여러 단계를 건너뛰는 추론(multi-hop)·전체 요약은 그래프가 유리. 후니 KB(위키+docs/kb, 파일 수백 개 규모)는 "작은 코퍼스"에 해당하므로, **그래프의 가치는 '검색 성능 향상'보다 '관계의 정확한 항해(상품→공식→구성요소→단가행 사슬 추적)와 누락 감지'에 있다**고 봐야 한다.

### 발견 4. 하이브리드(그래프+문서)가 단독보다 낫다 — 단, 임베딩 없이도 구현 가능

HybridRAG([arXiv:2408.04948](https://arxiv.org/abs/2408.04948), BlackRock·NVIDIA, 금융 문서 QA)는 벡터 검색과 지식그래프 검색을 **합쳤을 때** 각각 단독보다 검색 정확도·답변 품질이 좋았다고 보고한다. LightRAG([arXiv:2410.05779](https://arxiv.org/abs/2410.05779), [GitHub](https://github.com/HKUDS/LightRAG))는 "저수준(특정 개체·관계) + 고수준(주제·테마)" **이중 수준 검색**과 증분 갱신을 경량으로 구현한 오픈소스다. 후니 번역: "그래프로 노드를 찾고 → 그 노드가 가리키는 **정본 파일 구간을 읽는다**"는 2단 구조가 하이브리드의 본질이며, 이는 임베딩 없이 그래프 탐색+파일 Read만으로 구현된다.

### 발견 5. 파일 기반 위키(Karpathy 모델)는 이 레포에서 이미 검증된 토대

Karpathy LLM Wiki([gist 442a6bf](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f))의 요지: "RAG처럼 매번 재발견하지 말고, LLM이 새 자료를 읽으면 **기존 위키에 통합**(개체 페이지 갱신·모순 기록)하라. 3계층 = 원천(인간 큐레이션·불변) / 위키(LLM 전담) / 스키마(행동 규약)." §9 print-kb 위키(`_workspace/print-kb/wiki/README.md`)가 이 모델을 이미 채택·확장했다(base/huni 2레이어·출처 badge ✅🟡🔴⚪·index.md·log.md). **본 하네스는 이것을 대체하지 않고 승계한다** — 파일=정본 확정과 정확히 합치.

### 발견 6. llms.txt — 표준으로서는 실패 중, "단일 진입점 인덱스" 아이디어만 유효

llms.txt(웹사이트 루트에 LLM용 안내 파일을 두자는 제안)는 2026년 현재 도입률 약 10%까지 왔으나([Presenc AI 조사](https://presenc.ai/research/state-of-llms-txt-2026)), **주요 LLM 사업자(OpenAI·Anthropic·Google·Meta) 누구도 공식 지원하지 않고**, Google은 지원 계획 없음을 명시했다([codersera 정리](https://codersera.com/blog/llms-txt-complete-guide-2026/), [llms-txt.io](https://llms-txt.io/blog/is-llms-txt-dead)). 이것은 **외부 크롤러용** 표준이라 내부 KB인 후니와는 용도가 다르다. 다만 그 핵심 아이디어 — "LLM이 처음 읽을 **루트 매니페스트 하나**를 정해진 위치에 둔다" — 는 §9 index.md가 이미 실현했고, 온톨로지 KB에서도 같은 관례(루트 진입 문서 1개)를 유지하면 된다.

### 발견 7. ★그래프 저장 형식 — Kuzu는 후보 탈락(프로젝트 중단), SQLite 엣지 테이블이 최적합

- **Kuzu(임베디드 그래프DB): 2025-10-10 GitHub 레포 아카이브(중단).** 후원사 Kùzu Inc.가 지원 종료를 선언했고, 이후 EU DMA 서류로 Apple이 2025-10-09 Kùzu Inc. 인수에 합의한 사실이 드러났다. 커뮤니티 포크(bighorn, Kineviz)가 나왔으나 지속성 미검증([The Register](https://www.theregister.com/2025/10/14/kuzudb_abandoned/), [Hacker News](https://news.ycombinator.com/item?id=45560036), [kuzudb GitHub](https://github.com/kuzudb/kuzu)). → **신규 채택 부적격.**
- **SQLite 엣지 테이블 + 재귀 CTE(WITH RECURSIVE — 표 안에서 연결을 따라가는 SQL 문법):** 서버 없는 단일 파일, 설정 0, ACID, 소규모 그래프에서 Neo4j를 대체한 실전 사례가 있다([dev.to: SQLite as a Graph Database](https://dev.to/rohansx/sqlite-as-a-graph-database-recursive-ctes-semantic-search-and-why-we-ditched-neo4j-1ai)). 필요 시 같은 .db 파일에 sqlite-vec 확장으로 벡터 검색까지 추가 가능([sqlite-vec 해설](https://dev.to/aairom/embedded-intelligence-how-sqlite-vec-delivers-fast-local-vector-search-for-ai-3dpb), [SQLite.ai 블로그](https://blog.sqlite.ai/building-a-rag-on-sqlite)).
- **NetworkX(파이썬 그래프 라이브러리): 저장소가 아니라 빌드/분석 도구.** 메모리 안에서만 동작하므로 정본 저장에는 부적합하나, 노드 수천 규모(후니: 상품 283 + 자재·공정·공식·구성요소·옵션 ≈ 수천 노드)에서는 전체를 메모리에 올려 커뮤니티 탐지·고아 노드 검출·경로 탐색을 하기에 충분하다([Memgraph NetworkX guide FAQ](https://memgraph.github.io/networkx-guide/faq/)).
- **DuckDB + duckpgq(SQL:2023 표준 그래프 질의):** 흥미롭지만 CWI 연구 프로젝트 기반 커뮤니티 확장으로 아직 개발 진행 중([duckpgq 확장](https://duckdb.org/community_extensions/extensions/duckpgq), [VLDB 논문](https://www.vldb.org/pvldb/vol16/p4034-wolde.pdf)). → 성숙도 이유로 보류.

---

## ② 후니 적용 권고 (채택 / 기각 / 보류)

### 채택

| # | 권고 | 이유 (후니 규모 기준) |
|---|------|----------------------|
| A-1 | **파일=정본, 그래프=파생 빌드 구조 확정 유지** (Karpathy 모델 승계) | 사용자 확정 + §9 위키가 이미 검증(badge·index·log 운영 실적). 그래프가 깨져도 파일에서 언제든 재빌드 — "컴파일 산출물" 취급 |
| A-2 | **그래프는 LLM 추출이 아니라 결정론 스크립트로 빌드** — 원천 = ① 라이브 t_* FK/스냅샷 ② 위키·docs/kb의 frontmatter+[[교차참조]] | 후니 지식은 이미 정형(발견 1). LLM 개체 추출은 환각 개체를 낳는 비용·위험 단계인데 생략 가능. 레포 실증(`wiring_scan.py` 토큰 0 결정론 diff) 계보 |
| A-3 | **그래프 저장 = 2단 구성: ① 텍스트 덤프(nodes.csv + edges.csv 또는 JSONL) = git 커밋 ② SQLite .db = gitignore되는 로컬 빌드 산출물** | 단일 운영자·git 레포에 최적: 텍스트 덤프는 diff/리뷰 가능(그래프 변화가 PR에 보임), SQLite는 재귀 CTE로 경로 질의·sqlite-vec 여지까지. 바이너리를 git에 커밋하지 않아 레포 오염 0 |
| A-4 | **NetworkX = 빌드 시점 분석 도구로 채택**(저장소 아님) — 고아 노드·끊긴 사슬(상품→공식→구성요소→단가행) 검출, 커뮤니티/차수 통계 | 수천 노드는 메모리에 전부 올라감. §27 배선 결함 스캔과 동형의 "그래프 lint"를 값싸게 구현 |
| A-5 | **LazyGraphRAG 원리 채택: 사전 커뮤니티 요약 생성 금지, 무거운 생성은 질의 시점에** | 색인 비용 0.1% 교훈(발견 2). 후니는 요약 대신 index.md(이미 존재)가 진입점 역할 |
| A-6 | **하이브리드 검색 = "그래프 탐색으로 노드 확정 → 노드가 가리키는 정본 파일 구간 Read" 2단 구조** | HybridRAG 증거(발견 4)의 후니식 번역. 임베딩 없이 구현 가능 — 그래프 노드에 정본 파일 경로+앵커를 속성으로 저장 |
| A-7 | **자연어 동의어 처리는 임베딩보다 용어집(glossary) 우선** — canonical/synonym 표(완칼=왕칼=도무송, 모서리=귀돌이)를 그래프의 별칭(alias) 엣지로 | `docs/kb/03_레드프린팅_경쟁분석_온톨로지전략.md` §4.2가 이미 용어집을 산출물로 정의. 283개 상품 규모에서 동의어는 유한·열거 가능 — 결정론이 임베딩보다 설명 가능하고 유지비 0 |
| A-8 | **루트 진입 매니페스트 1개 유지**(llms.txt의 아이디어만 차용) — KB 루트에 "무엇이 어디 있고 어떤 순서로 읽어라" 단일 문서 | §9 index.md 관례 승계. 외부 표준 llms.txt 파일 형식 자체를 따를 필요는 없음(발견 6) |

### 기각

| # | 기각 대상 | 이유 |
|---|----------|------|
| R-1 | **Microsoft GraphRAG 풀 파이프라인 도입**(LLM 개체 추출 + 커뮤니티 사전 요약) | 색인 비용 과대(원조 대비 LazyGraphRAG가 0.1%로 만든 그 비용) + LLM 추출 환각 개체 위험 + **후니는 추출할 필요 자체가 없음**(이미 정형·발견 1). 작은 코퍼스에서 이득도 불확실(발견 3) |
| R-2 | **Kuzu 채택** | 2025-10 프로젝트 중단·레포 아카이브(발견 7). 신규 시스템의 토대로 부적격. 포크(bighorn)도 지속성 미검증 |
| R-3 | **서버형 그래프DB**(Neo4j 등)·대규모 트리플스토어·OWL 추론기 | 단일 사용자·git 레포·수천 노드에 서버 운영은 순수 과잉. 이 레포의 "가장 가벼운 경로" 원칙 위배 |
| R-4 | **llms.txt 표준 파일 채택** | 외부 크롤러용 제안이고 주요 LLM 사업자 0곳 지원(발견 6). 내부 KB에는 무의미 — 아이디어만 A-8로 흡수 |
| R-5 | **LightRAG 등 외부 GraphRAG 프레임워크 도입** | 프레임워크 종속(파이썬 서비스·자체 저장 포맷)이 "파일=정본" 구조와 충돌. 이중 수준 검색 **원리만** 차용(A-6) — 코드는 자체 결정론 스크립트가 더 단순 |

### 보류

| # | 보류 대상 | 재검토 조건 |
|---|----------|------------|
| H-1 | **임베딩 검색 추가(sqlite-vec)** | 용어집+그래프 탐색(A-6·A-7)으로 자연어 질의 게이트를 먼저 돌려보고, **리콜 실패(질의가 노드를 못 찾는 사례)가 실측으로 누적되면** 그때 같은 SQLite 파일에 sqlite-vec로 추가(발견 7 — 추가 비용 작음). 선제 도입은 유지비(임베딩 모델 버전·재색인)만 늘림 |
| H-2 | **DuckDB + duckpgq** | SQL:2023 표준 그래프 질의라는 장점은 있으나 연구 프로젝트 단계. SQLite 재귀 CTE가 한계에 부딪히면(예: 최단경로·복잡 패턴 질의 다발) 재평가 |
| H-3 | **커뮤니티 탐지 기반 자동 페이지 묶음**(GraphRAG의 커뮤니티 아이디어를 위키 구조에 역적용) | 후니는 상품군 11시트라는 인간 확정 분류가 이미 있음 — 자동 커뮤니티가 이것과 충돌하면 혼란. 위키가 커진 뒤(수백 페이지+) "분류 밖 군집" 발견 도구로만 검토 |

---

## ③ 설계자(okb-ontology-architect)에게 넘길 결정 항목

1. **그래프 스키마(노드/엣지 타입 사전)** — 노드: 상품·자재·공정·옵션(그룹/아이템)·사이즈·도수·가격공식·가격구성요소·단가행·제약·상품군·위키페이지. 엣지: FK 유래(구성·바인딩·배선·참조 ref_dim_cd)와 문서 유래([[교차참조]]·출처 badge)를 **구분 태그**로 나눌 것인지, 하나로 합칠 것인지 결정 필요.
2. **텍스트 덤프 포맷 확정**(A-3) — nodes/edges를 CSV로 갈지 JSONL로 갈지, 파일 위치(`04_graph/` 제안), SQLite .db의 gitignore 등록.
3. **빌드 트리거·freshness 규약** — 라이브 DB 스냅샷 시점 메타데이터(수집일 필수 — docs/kb 03 §4.3 계승)를 그래프에 어떻게 새길지, 위키 갱신 시 그래프 재빌드를 누가/언제 돌리는지(§9 log.md 연동 여부).
4. **질의 라우팅 규칙**(이중 수준 원리) — "특정 상품 사슬 추적"(저수준→그래프 탐색) vs "상품군 전반 질문"(고수준→index/상품군 페이지 직접 Read)을 나누는 판정 기준.
5. **용어집의 그래프 내 위치**(A-7) — 별칭을 노드 속성으로 넣을지, alias 엣지(별도 synonym 노드)로 만들지. 자연어 질의 정규화의 첫 관문이므로 스키마 확정 필요.
6. **임베딩 추가 판단 지표**(H-1) — 질의 게이트(okb-query-gate)에서 "노드 미발견율" 같은 측정 항목을 미리 정의해 두어야 보류→채택 전환이 데이터로 결정됨.
7. **그래프 lint 게이트 항목**(A-4) — 고아 노드·끊긴 가격 사슬·양방향 참조 불일치 등 결정론 검출 목록을 검증자(okb-adversarial-verifier) 게이트에 편입할 것.

---

## ④ 미확인 / 추가 조사 필요

- **LazyGraphRAG의 오픈소스 공개 범위** — Microsoft Research 블로그(2024-11)는 "GraphRAG 라이브러리에 포함 예정"이라 했으나, 현재 graphrag 리포에서의 구현 완성도는 직접 확인하지 못함. (다만 R-1로 풀 파이프라인 자체를 기각했으므로 설계 영향 낮음)
- **llms.txt 도입률 수치(10.13%, SE Ranking 30만 도메인)** — 2차 출처([Presenc AI](https://presenc.ai/research/state-of-llms-txt-2026)) 경유 인용. 원 보고서 미확인.
- **HybridRAG의 도메인 이전성** — 근거 논문이 금융 문서 QA 도메인. 커머스/CPQ 카탈로그에서의 직접 재현 증거는 미확인 — 후니 파일럿(대표 상품군 1개)에서 자체 측정으로 대체해야 함.
- **arXiv:2502.11371의 세부 수치** — "작은 코퍼스에서 벡터 RAG가 GraphRAG Local과 비슷하거나 우세" 결론은 확인했으나 후니 규모(문서 수백 건)와 완전히 동일 조건의 실험은 아님.
- **Kuzu 포크(bighorn) 및 Apple 인수 후 행보** — 인수 사실은 [The Register 보도](https://www.theregister.com/2025/10/14/kuzudb_abandoned/) 기준. Apple의 계획 미공개 — 어차피 기각이므로 추적 불요, 기록만 남김.
- **SQLite 재귀 CTE의 성능 상한** — 수천 노드에서는 문제없다는 실전 보고가 있으나, 후니 그래프가 단가행(7,293행)까지 노드로 포함해 수만 노드가 될 경우의 경로 질의 성능은 파일럿에서 실측 필요(단가행을 노드로 할지 속성으로 접을지는 설계자 결정 항목 1과 연동).

---

## 참고 출처 일람

| 주제 | 출처 |
|---|---|
| GraphRAG 원논문 | https://arxiv.org/abs/2404.16130 |
| LazyGraphRAG | https://www.microsoft.com/en-us/research/blog/lazygraphrag-setting-a-new-standard-for-quality-and-cost/ |
| RAG vs GraphRAG 체계 비교 | https://arxiv.org/html/2502.11371v3 |
| HybridRAG | https://arxiv.org/abs/2408.04948 |
| LightRAG | https://arxiv.org/abs/2410.05779 · https://github.com/HKUDS/LightRAG |
| Karpathy LLM Wiki | https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f |
| llms.txt 현황 | https://presenc.ai/research/state-of-llms-txt-2026 · https://llms-txt.io/blog/is-llms-txt-dead · https://codersera.com/blog/llms-txt-complete-guide-2026/ |
| Kuzu 중단 | https://www.theregister.com/2025/10/14/kuzudb_abandoned/ · https://news.ycombinator.com/item?id=45560036 · https://github.com/kuzudb/kuzu |
| SQLite 그래프/벡터 | https://dev.to/rohansx/sqlite-as-a-graph-database-recursive-ctes-semantic-search-and-why-we-ditched-neo4j-1ai · https://blog.sqlite.ai/building-a-rag-on-sqlite · https://dev.to/aairom/embedded-intelligence-how-sqlite-vec-delivers-fast-local-vector-search-for-ai-3dpb |
| NetworkX 특성 | https://memgraph.github.io/networkx-guide/faq/ |
| DuckDB duckpgq | https://duckdb.org/community_extensions/extensions/duckpgq · https://www.vldb.org/pvldb/vol16/p4034-wolde.pdf |
| 레포 내부 실증 | `_workspace/print-kb/wiki/README.md`(§9 Karpathy 채택) · `docs/kb/03_레드프린팅_경쟁분석_온톨로지전략.md`(용어집·수집일 메타) · `_workspace/_foundation/batch/wiring_scan.py`(결정론 diff 계보) |
