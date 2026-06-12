# Print-KB 위키 — 방법론 권고 (pkw-researcher)

> 작성 2026-06-12. Phase 1 초기 실행. 작업 = ① LLM 레시피 위키 스키마/구조 개선 권고.
> 권고 ID = R-1, R-2 … · 각 권고에 **스키마 변경급(SCHEMA) vs 경미(MINOR)** 분류 표시.
> 권고 채택 여부 = 오케스트레이터→사용자. 본 문서는 권고만, 위키 본문 미수정.
>
> **갭 기반 원칙:** 이미 잘 작동하는 것(Karpathy 3계층·badge·[[교차참조]]·index/log·answers_cq)은 재설계 권고하지 않는다(답습·과설계 금지). 아래는 현 스키마의 갭/약점에 한정.

---

## 0. 현 스키마 진단 (권고의 토대)

읽은 권위 파일: `wiki/README.md`(스키마)·`index.md`·`log.md`·`base/printing-methods.md`·`policy/*`·`pkw-recipe-authoring` 스킬(레시피 뼈대).

| 현 상태 | 평가 |
|---|---|
| Karpathy 3계층(raw/wiki/schema)·2레이어(base/huni) | **유지** — 원전 모델 충실, gist 442a6bf와 정합(검증됨). |
| index.md 카탈로그 먼저 읽기·log.md append-only | **유지** — Karpathy 원전과 일치(검증됨). |
| 원자 블록 컨벤션(항목ID·출처·연결·answers_cq·badge) | **유지·강화** — 약점은 검색성/입력경로(아래 R). |
| base 레이어 | **사실상 비어 있음** — 7페이지 계획 중 1개(printing-methods)만 존재. 레시피가 앵커할 토대 부재(가장 큰 갭). |
| 레시피 페이지 | **0개** — 뼈대만 스킬에 정의. 뼈대 자체에 개선 여지(아래 R-5~R-8). |
| LLM 진입점(llms.txt류) | **부재** — 미래 LLM 세션이 위키 전체를 어떻게 진입하는지의 단일 카탈로그가 index.md뿐, 레시피/축 미반영. |

---

## R-1. index.md를 llms.txt 형식으로 정렬 — LLM 진입 카탈로그 표준화  {MINOR}

- **제안:** `index.md`를 llms.txt 사실상 표준 구조(H1 위키명 → blockquote 한 줄 목적 → H2 섹션별 `[페이지](경로): 한 줄 설명` 링크 리스트)로 정렬한다. 현 index.md는 이미 매우 유사하나, 표(table) 위주라 일부가 llms.txt 파서/LLM 컨텍스트 효율 형식에서 벗어난다. 표는 사람에게 좋지만, llms.txt 권고 형식은 "H2 + 불릿 링크 리스트 + 콜론 설명"이다.
- **근거:** llms.txt 명세 — "an H1 ... a blockquote summary ... H2 sections containing markdown bullet lists of links where each link has a short description after a colon" / "valid markdown and parseable by standard markdown libraries without custom extensions". Karpathy gist도 index.md를 "a catalog of everything in the wiki — each page listed with a link, a one-line summary"로 정의(현 표 형식과 의미 동일 — 형식만 정렬).
  - https://llmstxt.org/ (WebFetch 검증)
  - https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f (WebFetch 검증)
- **적용 위치:** `index.md`(본 문서는 권고만 — 실제 정렬은 writer).
- **변경 규모:** MINOR. 내용 불변, 형식만 표→불릿 링크. badge·상태는 콜론 설명 안에 유지.
- **우선순위:** Medium. (현 형식도 LLM이 읽음 — 효율·표준 정합 개선 차원.)

## R-2. 레시피·축 페이지를 index.md에 1급 섹션으로 추가 (RECIPES / AXES)  {MINOR}

- **제안:** 현 index.md는 BASE·HUNI(policy)만 카탈로그한다. 레시피(11 상품군)·횡단 축(materials·processes·price-engine·cpq-options·widget-contract·load-path) 섹션을 index.md에 명시 추가하고, 각 행에 freshness/상태를 콜론 설명에 넣는다. 미래 LLM이 "상품 조립" 질의 시 가장 먼저 닿는 곳이 레시피여야 한다(하네스 목적).
- **근거:** Karpathy 워크플로 — "updates the index ... on every ingest". index가 콘텐츠 전부를 반영해야 query 진입이 성립. 레시피가 index에 없으면 위키만 읽는 LLM이 레시피에 도달 못함(하네스 목적 직접 훼손).
  - https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f (WebFetch 검증)
- **적용 위치:** `index.md` 카탈로그 구조(섹션 추가). `_`-prefix 작업 폴더는 제외(스킬 §1 준수).
- **변경 규모:** MINOR.
- **우선순위:** High. (레시피 집필 시작 전 index 골격이 있어야 writer가 갱신 누락 안 함.)

## R-3. base 레이어를 우선 보강 — 레시피 앵커 토대 (계획 7페이지 → 집필)  {SCHEMA}

- **제안:** base 레이어(현 1/7 페이지)를 레시피 집필 **이전에** 채운다. 레시피 뼈대(스킬 §2)는 차원·자재/공정·가격·임포지션을 일반 도메인 지식에 앵커하는데, 그 일반 지식 페이지(paper·finishing·binding·color·sizes·prepress-file)가 없으면 레시피가 `[[base/...]]`로 링크할 대상이 없어 횡단 사실을 레시피마다 복붙하게 된다(단일 사실 원칙 위반의 뿌리). 이것은 "어느 페이지가 존재해야 하는가"의 스키마 구조 결정이므로 SCHEMA로 분류.
- **근거:** ① 본 위키 자체 설계 의도(README §1 "base를 상세한 권위 토대로 깔고 그 위에 huni 분석대상"). ② 단일 사실 원칙(스킬 §3 "횡단 사실은 축 페이지에 1회만") — base가 그 1회의 거처. ③ 온톨로지 공학의 역량질문(CQ) 선행 원칙: 페이지를 채우기 전 "위키가 답해야 할 질문"을 먼저 정의(METHONTOLOGY/NeOn은 specification 단계에서 CQ를 use case에 연결). base 페이지 = 일반 CQ("옵셋이 뭔가" "절수란" "임포지션이란")의 거처.
  - METHONTOLOGY/NeOn CQ: https://link.springer.com/chapter/10.1007/978-3-031-47262-6_3 (WebSearch 인용 — 초록 수준 [2차인용])
  - https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f (WebFetch 검증)
- **적용 위치:** `base/` 신규 페이지(paper·finishing·binding·color·sizes·prepress-file). 뼈대는 index.md에 이미 계획됨.
- **변경 규모:** SCHEMA (어떤 토대 페이지가 존재해야 하는지 = 구조 결정. 단, 사용자 비준이 필요한 것은 "base를 레시피보다 먼저 집필"이라는 순서 결정이지 새 컨벤션은 아님).
- **우선순위:** High. (레시피 앵커의 선결 조건.)
- **검증 연계:** 본 권고로 집필될 base 사실들은 `base-verification.md`에 이미 외부 표준 교차검증 완료(printing-methods 전건 [검증]). 신규 base 페이지 집필 시 동일 검증 절차 적용 권고.

## R-4. base 페이지에 출처 freshness/검증 badge 도입 — base도 [검증]/[단일출처] 표기  {MINOR}

- **제안:** README §1은 "base는 보편 사실이라 badge 불필요"로 정의하나, base 사실도 외부 검증 신뢰도가 다르다(2+ 독립출처 vs 단일출처 vs 미검증). base 페이지 각 사실 옆에 `[검증]`(2+ 독립)·`[단일출처]`·`[추정]` 표기를 도입한다. 이는 huni badge(✅🟡🔴⚪)와 별개 축(=출처 신뢰도)이며 충돌하지 않는다.
- **근거:** ① 본 하네스 검증 역할의 산출물이 그대로 base에 반영되려면 표기 슬롯 필요. ② Karpathy lint 워크플로 — "stale claims that newer sources have superseded" 점검이 가능하려면 사실별 출처 추적이 필요. ③ 현 printing-methods.md는 출처를 페이지 말미에 일괄 기재(나무위키 포함) — 사실별 추적 불가. 본 권고는 사실 단위 추적성을 추가.
  - https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f (WebFetch 검증, lint 정의)
- **적용 위치:** README §1·§3(base badge 정책)·base 페이지.
- **변경 규모:** MINOR (새 표기 축 1개 추가, 기존 huni badge 불변).
- **우선순위:** Medium.
- **주의:** 현 printing-methods.md 출처 줄에 "나무위키"가 있음 — base의 권위 토대로는 약함(R-4 도입 시 [단일출처]→교과서/표준으로 격상 권고. `base-verification.md` 참조).

## R-5. 레시피 뼈대에 "역량질문(CQ) 헤더" 추가 — 페이지 상단에 답하는 질문 명시  {MINOR}

- **제안:** 레시피 페이지 뼈대(스킬 §2) 상단(0.정체 위)에 "이 페이지가 답하는 질문" 블록을 추가한다. 예: "이 상품군은 무엇인가 / 어떤 차원·옵션이 있는가 / 가격은 어떻게 계산되는가 / DB에 어떻게 등록하는가". answers_cq는 이미 블록 단위로 있으나, 페이지 단위 진입 질문은 없다.
- **근거:** 온톨로지 공학 CQ 원칙 — "Competency Questions specify the questions one's ontology should be able to answer". NeOn/METHONTOLOGY가 CQ를 specification 단계 use case에 연결. 미래 LLM이 위키만 읽고 상품을 조립(하네스 목적)하려면, 각 레시피가 "어떤 조립 질문에 답하는지"를 페이지 머리에 선언하는 것이 retrieval 진입을 돕는다.
  - https://link.springer.com/chapter/10.1007/978-3-031-47262-6_3 (WebSearch 초록 [2차인용])
  - https://eng.libretexts.org/Bookshelves/Computer_Science/Programming_and_Computation_Fundamentals/An_Introduction_to_Ontology_Engineering_(Keet)/06:_Methods_and_Methodologies/6.01:_Methodologies_for_Ontology_Development (WebSearch 인용)
- **적용 위치:** `pkw-recipe-authoring` 스킬 §2 뼈대 + 레시피 페이지.
- **변경 규모:** MINOR (뼈대에 헤더 1블록 추가).
- **우선순위:** Medium.

## R-6. 레시피 페이지에 구조 인지형 청킹 경계 강화 — 섹션 자기완결성(self-contained)  {MINOR}

- **제안:** 레시피 뼈대 8섹션 각각이 retrieval 시 단독으로 의미가 통하도록 자기완결성을 강화한다. 구체적으로 ① 각 섹션 첫 줄에 상품군명 명시(예 "## 3. 가격 사슬 — 디지털인쇄"), ② 앵커 t_* 명을 섹션 머리에 노출(이미 뼈대에 있음 — 유지), ③ 횡단 링크는 링크만 두되 "한 줄 요약 + [[링크]]" 패턴(링크 대상 미로드 시에도 최소 의미 전달).
- **근거:** RAG 구조 인지형 청킹 — "Document-aware chunking ... preserves semantic units that humans naturally recognize as coherent (a table, a section)"; "respecting each corpus's native boundaries". 마크다운 H2 섹션이 자연 청크 경계이므로, 미래 RAG/agentic 검색이 섹션 단위로 잘라도 의미가 보존되게 한다. Anthropic contextual retrieval 계열의 "각 청크에 맥락 부여" 원칙과 정합.
  - https://atlan.com/know/chunking-strategies-rag/ (WebSearch 인용)
  - https://www.firecrawl.dev/blog/best-chunking-strategies-rag (WebSearch 인용)
- **적용 위치:** `pkw-recipe-authoring` 스킬 §2~§3 + 레시피 페이지.
- **변경 규모:** MINOR.
- **우선순위:** Medium. (위키가 markdown grep/Read로 권위 조회되는 한[README §6], 이 효과는 RAG 도입 시 발현 — 미리 대비.)

## R-7. 항목ID에 안정적 식별자(stable @id) 성격 부여 — 교차참조 깨짐 방지  {MINOR}

- **제안:** 원자 블록 항목ID(`<FAMILY약어>-<섹션약어>-NNN`)를 페이지 이동·이름 변경 시에도 불변하는 안정 식별자로 운용한다(이미 영문 ID 체계 존재 — 운용 규칙 명문화). [[페이지#항목ID]] 교차참조가 ID 기반이므로, 페이지 분할(스킬 §5: 500줄 근접 시 `<family>-pricing.md` 분리) 시 ID는 따라가되 링크의 페이지 부분만 갱신하는 lint 규칙을 추가.
- **근거:** 지식그래프 엔티티 모델링 — "stable @id URIs ... these nodes form a graph that search engines and AI assistants can traverse"; "@id/url helps establish connections between your own content". 안정 ID = 그래프 순회 가능성의 전제. 본 위키의 [[교차참조]]가 사실상 내부 엣지이므로 동일 원리.
  - https://momenticmarketing.com/blog/id-schema-for-seo-llms-knowledge-graphs (WebSearch 인용)
- **적용 위치:** README §3 + lint 워크플로(README §4 / 스킬 §4).
- **변경 규모:** MINOR (기존 ID 체계의 운용 규칙 명문화).
- **우선순위:** Low. (페이지 분할이 실제 발생할 때 가치 — 선제 규칙.)

## R-8. 라이브 오적재 양면 표기를 "전형 패턴"으로 뼈대에 고정  {MINOR}

- **제안:** 스킬 §3에 이미 있는 `라이브 현재값 X → 정답 Y {🔴 교정대기}` 양면 표기를, 레시피 7절(현황·결함)의 **필수 하위 구조**로 승격한다. round-13이 라이브=교정대상으로 다수 오적재를 확정했으므로(MAT_000186 레더, 아크릴 UV PROC, size↔option 등), 레시피마다 "현재값 vs 정답" 테이블이 7절에 표준 슬롯으로 있어야 미래 LLM이 라이브 값을 사실로 오인하지 않는다.
- **근거:** Karpathy lint — "contradictions between pages, stale claims". 라이브 오적재값은 본질적으로 stale/모순 사실 — 양면 표기는 그 모순을 명시적으로 보존하는 장치. 하네스 핵심 규칙(CLAUDE.md §9 "라이브 오적재는 현재값 vs 정답 양면 표기")의 스키마 고정.
  - https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f (WebFetch 검증)
- **적용 위치:** `pkw-recipe-authoring` 스킬 §2 7절 + 레시피 페이지.
- **변경 규모:** MINOR.
- **우선순위:** High. (라이브 오적재가 다수 확정된 상태 — 잘못 인용 위험 큼.)

---

## 권고 요약 표

| R-ID | 제안 한 줄 | 분류 | 우선순위 | 적용 위치 |
|---|---|---|---|---|
| R-1 | index.md를 llms.txt 형식(H2+불릿 링크)으로 정렬 | MINOR | Medium | index.md |
| R-2 | 레시피·축을 index.md 1급 섹션으로 추가 | MINOR | High | index.md |
| R-3 | base 레이어 7페이지를 레시피보다 먼저 집필 | **SCHEMA** | High | base/* |
| R-4 | base 사실에 [검증]/[단일출처] 신뢰도 badge 도입 | MINOR | Medium | README·base/* |
| R-5 | 레시피 상단에 CQ 헤더(답하는 질문) 추가 | MINOR | Medium | 스킬·recipes/* |
| R-6 | 레시피 섹션 자기완결성(청킹 경계) 강화 | MINOR | Medium | 스킬·recipes/* |
| R-7 | 항목ID를 안정 @id로 운용(교차참조 lint 규칙) | MINOR | Low | README·lint |
| R-8 | 라이브 현재값 vs 정답 양면 표기를 7절 필수 슬롯화 | MINOR | High | 스킬·recipes/* |

**스키마 변경급(사용자 비준 권장):** R-3 (base 토대를 레시피 선행 집필 — 구조·순서 결정).
**경미(writer 재량 + 오케스트레이터 확인):** R-1·R-2·R-4·R-5·R-6·R-7·R-8.

> 채택된 R만 pkw-recipe-writer 스키마에 반영된다. 본 researcher는 writer에게 직접 지시하지 않는다.

---

## 외부 근거 부재 / 한계

- Karpathy gist 댓글의 "typed edges(YAML frontmatter contradicts/extends)"는 **커뮤니티 확장**이지 원전 설계 아님(WebFetch 확인). 현 위키의 단순 [[링크]]로 충분 — typed edge는 권고하지 않음(과설계 회피).
- "개발 커뮤니티가 실제 LLM-readable 내부 위키를 어떻게 유지하는가"의 1차 사례는 대부분 블로그 해설(Medium/Substack)로, 1차 운영 데이터가 아님 — 본 권고는 1차 명세(llmstxt.org·gist·CQ 논문)에 가중치를 두고 블로그는 보조 인용만 사용.

---

## Sources (전부 본 세션 WebFetch/WebSearch 확인)

- [Karpathy LLM wiki gist 442a6bf](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f) — WebFetch 검증(3계층·index/log·ingest/query/lint·page 컨벤션은 도메인 의존).
- [llms.txt 명세 (llmstxt.org)](https://llmstxt.org/) — WebFetch 검증(H1+blockquote+H2 불릿 링크 형식·markdown 파서블).
- [Use of Competency Questions in Ontology Engineering: A Survey (Springer)](https://link.springer.com/chapter/10.1007/978-3-031-47262-6_3) — WebSearch 초록 [2차인용](CQ 정의·METHONTOLOGY/NeOn).
- [Methodologies for Ontology Development (Engineering LibreTexts)](https://eng.libretexts.org/Bookshelves/Computer_Science/Programming_and_Computation_Fundamentals/An_Introduction_to_Ontology_Engineering_(Keet)/06:_Methods_and_Methodologies/6.01:_Methodologies_for_Ontology_Development) — WebSearch 인용.
- [Chunking Strategies for RAG (Atlan)](https://atlan.com/know/chunking-strategies-rag/) — WebSearch 인용(document-aware chunking).
- [Best Chunking Strategies for RAG (Firecrawl)](https://www.firecrawl.dev/blog/best-chunking-strategies-rag) — WebSearch 인용(native boundaries).
- [Using @id in Schema.org for SEO/LLMs/Knowledge Graphs (Momentic)](https://momenticmarketing.com/blog/id-schema-for-seo-llms-knowledge-graphs) — WebSearch 인용(stable @id·그래프 순회).
