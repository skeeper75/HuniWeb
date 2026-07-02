# 파일 형식 명세 — Huni-Ontology-KB (v1.0)

> 작성: 2026-07-03 · okb-ontology-architect
> 상위: `ontology-schema.md`(개체·관계 사전) · `../00_research/methodology-playbook.md`(D-2·D-8·D-9·D-20) · `.claude/skills/okb-ontology-authoring/SKILL.md`(노드 구조).
> 목적: **노드 파일(정본)의 정확한 문법**을 못박아, 사람·LLM이 쓴 파일을 그래프 빌더가 결정론적으로 파싱하고 lint가 기계 검증할 수 있게 한다.
>
> **읽는 법:** 이 문서는 "지식 파일 1개를 어떻게 생겨먹게 쓸지"의 규칙서다. 파일 머리(frontmatter, YAML)에 구조화 메타데이터를 넣고, 본문에 사람이 읽는 설명을 쓴다. 규칙을 지키면 빌더가 자동으로 그래프를 만들고, 어기면 lint가 잡아낸다.

---

## 1. 디렉토리·파일명 컨벤션

### 1.1 디렉토리 구조 (정본 = `03_kb/`)
```
_workspace/huni-ontology-kb/
├── 02_ontology/           # 이 스키마 문서 3종 + standards-mapping.md
├── 03_kb/                 # ★정본(SOT) — 노드 markdown 파일. 여기만 고치면 됨
│   ├── index.md           # 진입점(매니페스트, D-12) — LLM 질의 시 먼저 읽음
│   ├── log.md             # append-only 연대기(ingest/query/lint)
│   ├── _glossary.md       # 용어집 단일 원천(D-10, term 노드 집합)
│   ├── product/           # E1 product 노드 (product-<slug>.md)
│   ├── formula/           # E9 price_formula + E10 component 노드
│   ├── axis/              # E3~E8 차원·자재·공정·판형·수량 (축 페이지, 원자 항목 묶음)
│   ├── cpq/               # E11 option_group + E12 constraint
│   ├── intent/            # INTENT_* 용도·의도 (KB 전용 레이어)
│   ├── rule/              # E14 RULE_* + E15 DEC_* + gap 노드
│   └── standards/         # → standards-mapping.md 링크 (횡단)
├── 04_graph/              # 파생 빌드 산출(build_graph.py·nodes.jsonl·edges.jsonl) + SQLite(gitignore)
└── 05_verification/       # blocklist.md·lint 리포트·게이트
```

### 1.2 파일명 규칙 (lint L-1)
- 노드 파일명 = `<type-prefix><slug>.md`. slug=소문자·하이픈·prd_cd 번호. 예 `product-016-premium-postcard.md`.
- 축 페이지(axis/·cpq/)는 **여러 원자 항목을 한 파일에** 담을 수 있다(§9 README R-9 과분할 금지). 파일명=축명. 예 `axis/materials.md`, `axis/processes.md`.
- 1 파일 = 1 노드가 기본이나, 축 페이지는 1 파일 = N 원자 항목(각 항목이 `### [ID]` 블록). 빌더는 둘 다 파싱.
- `_`-prefix 파일(`_glossary.md` 제외)·`04_graph/`·`05_verification/`는 노드 추출 대상 아님(빌더 무시).

---

## 2. frontmatter YAML 스키마 (노드 머리)

### 2.1 필수 필드 (없으면 lint L-2 FAIL)
```yaml
---
id: <prefix>-<slug>          # 전역 유일(L-3). ontology-schema §1 접두사 체계 준수
type: <개체 유형>             # 스키마 사전 17종 중 하나(L-4·gap·intent 포함). 없는 유형=FAIL
anchor: <앵커>                # t_<table>/<CODE> | xlsx:<file>#<sheet>!<cell> | none
badge: verified|candidate|defect|unknown   # ✅🟡🔴⚪ (L-5)
sources:                     # 최소 1개(L-6). 5필드 객체
  - {source_file: "...", source_locator: "...", captured_at: "...", badge: verified, src_id: "..."}
---
```
> **필수 필드는 정확히 5개**(id·type·anchor·badge·sources) — L-2가 검사하는 집합. `updated`는 선택(권장) 필드다(§2.3). 과거 이 예시가 `updated`를 필수 블록에 `(L-7)` 라벨로 넣었으나, ①§5 lint 표에 L-7 규칙 행이 없고 ②빌더가 `updated`를 파싱·검사·직렬화하지 않으며 ③블록 노드(`### [id]`)는 파일 레벨 `updated`로 충분해 개별 강제가 부적절하다. 그래서 `updated`를 선택 필드로 강등하고 유령 라벨 `(L-7)`을 제거했다(v1.0.3·fix-log R2 V2-01).

### 2.2 조건부 필수 필드
| 필드 | 언제 필수 | 형식 |
|------|-----------|------|
| `relations` | product·formula 등 연결 있는 노드 | 타입드 링크 리스트(§3) |
| `anchor` 사유 | anchor=none일 때 | `none  # 사유: <왜 앵커 없나>` (L-8) |
| `current_value`+`authority_value` | badge=defect(양면 노드) | 둘 다 필수·둘 중 하나만 있으면 FAIL(L-9) |
| `gap_what`+`gap_fill_from`+`gap_owner` | type=gap | 3필드 전부(L-10) |
| `prefLabel`+`definition` | type=term | prefLabel 언어당 1개·전역 중복 금지(L-11)·definition 필수 |
| `supersedes` | type=decision이 옛 결정 대체 | 옛 decision id(→ STALE 전파) |

### 2.3 선택 필드
- `updated`: 파일 갱신일(ISO). **file-node(1파일=1노드·frontmatter) 권장** — block-node(축 페이지 `### [id]`)는 파일 레벨 `updated`로 충분하므로 개별 강제하지 않는다. 강제 lint 규칙 없음(빌더 미파싱·미직렬화). 갱신 이력은 log.md·fix-log가 1급 원천.
- `props`: 노드 고유 속성(prd_typ_cd·min_qty·archetype·use_dims 등).
- `standards`: `{schema_org: ..., xjdf: ..., config_ont: ...}` 표준 이름표.
- `answers_cq`: 이 노드가 답하는 CQ ID(질의 레지스트리 연동).
- `tags`: `#디지털인쇄 #가격` 등.

### 2.4 값 규약
- **수치 금지 위치(D-9·L-12):** frontmatter `props`와 본문 산문에 **가격·치수·수량 raw 숫자 직접 기입 금지**. 수치는 ① CSV 캐시를 가리키는 참조 또는 ② 스크립트 전사 표(§4)에만. 예외: min_qty 같은 단일 스칼라는 `props`에 허용하되 `src_id`로 원천 명시.
- **badge 일관성(L-13):** 노드 최상위 badge와 sources 안 badge가 모순이면 경고(예: 노드 verified인데 모든 source가 candidate).

---

## 3. 타입드 링크 문법 (relations)

### 3.1 기본 형식
```yaml
relations:
  - {rel: <관계유형>, target: <노드 id>}                      # 최소형
  - {rel: <관계유형>, target: <노드 id>, note: "한 줄 요약"}   # 설명 추가
  - {rel: <관계유형>, target: <노드 id>, qualifier: mandatory} # 한정자(mand 공정 등)
```
- `rel` = ontology-schema §2 관계 19종 중 하나만(L-14·R19 `references` 포함). 없는 관계명 = FAIL.
- `target` = 실재하는 노드 id(L-15, 끊긴 링크 = FAIL). 빌더가 전 노드 id 집합과 대조.
- 방향은 스키마 사전이 정의(source=이 노드, target=가리키는 노드). 역방향 자동 생성은 빌더 몫(역링크 슬롯).

### 3.2 본문 인라인 교차참조 (§9 [[ ]] 문법 승계)
본문에서 `[[다른-노드-id]]` 또는 `[[axis/materials#MAT-TYPE-001]]`로 참조. 빌더는 본문 `[[ ]]`도 **약한 관계(rel: `references`=R19·any→any, ontology-schema §2.2 등재)로 추출**하되, frontmatter relations가 1급(타입 있음). 인라인은 서술 보조용. `references`는 폐쇄 목록에 있으므로 L-14는 통과하고, any→any라 I-3 타입 검사에서는 예외.

### 3.3 역링크 슬롯 (README §3-3 승계)
축 원자 항목 끝에 `- 사용처:` 슬롯. 빌더가 `has_component`·`uses_material` 등 들어오는 엣지를 여기 자동 채움(빌드 산출). **사람이 손으로 채우지 않는다**(파생물). 즉 정본에는 빈 슬롯만, 채움은 04_graph 리포트.

---

## 4. 본문 수치 전사 규약 (D-9)

수치 표는 반드시 스크립트가 CSV 캐시에서 삽입하고 마커를 단다:
```markdown
<!-- transcribed-by: _meta/scripts/transcribe_sizes.py from live-snapshot/latest/t_prd_product_sizes.csv PRD_000016 @ 2026-07-03 -->
| 사이즈(재단) | 작업사이즈 | 판수 |
|---|---|---|
| 73×98 | 75×100 | 15 |
```
- 마커 없는 수치 표 = lint L-16 경고(손전사 의심).
- 전사 스크립트는 `_meta/scripts/`에 보존(재현성).
- 양면 노드의 current/authority 수치도 스크립트 전사 대상.

---

## 5. lint 규칙 목록 (기계 검증 가능 문장)

> 빌드마다 실행(D-13·SKILL §3). 위반 = 빌드 FAIL(하드) 또는 경고(소프트). 각 규칙은 결정론 스크립트로 판정.

### 5.1 구조 lint (하드 — 빌드 중단)
| ID | 규칙(검사 문장) | 판정 방법 |
|----|----------------|-----------|
| L-1 | 파일명이 `<type-prefix><slug>.md` 패턴에 맞고 id 접두사와 일치한다 | 정규식 |
| L-2 | 필수 5필드(id·type·anchor·badge·sources) 전부 존재 | YAML 키 검사 |
| L-3 | id가 전 노드에서 유일하다 | id 집합 중복 검사 |
| L-4 | type이 스키마 사전 17종에 존재(앵커 12+KB전용 term·rule·decision 3+특수 `gap`·`intent` 2) | 화이트리스트 대조(gap·intent 포함) |
| L-5 | badge가 4종 중 하나 | enum 검사 |
| L-6 | sources ≥1이고 각 source에 5필드(source_file·locator·captured_at·badge·src_id) | 리스트·키 검사 |
| L-8 | anchor=none이면 사유 주석 존재 | 정규식 `none\s*#\s*사유:` |
| L-9 | badge=defect이면 current_value·authority_value 둘 다 존재 | 키 검사 |
| L-10 | type=gap이면 gap_what·gap_fill_from·gap_owner 존재 | 키 검사 |
| L-11 | type=term의 prefLabel이 언어당 1개·전역 유일 | 라벨 집합 대조 |
| L-14 | 모든 relations.rel이 관계 사전 19종에 존재(R19 `references` 포함) | 화이트리스트 |
| L-15 | 모든 relations.target이 실재 노드 id | id 집합 대조(끊긴 링크 0) |
| L-17 | anchor가 t_*/코드면 그 코드가 live-snapshot에 실재(닫힌 세계·D-6) | 스냅샷 CSV 조회 |
| L-18 | option_group의 option_refs 타깃이 같은 부모 product 차원(uses_material·has_process·has_size·has_print_option)에 실재(fn_chk_opt_item_ref 정합) | 부모(has_option_group 역참조) 차원 집합 대조 |

### 5.2 의미 lint (하드 — 오염 차단)
| ID | 규칙 | 판정 |
|----|------|------|
| O1 | 출처 없는 사실 블록 없음(모든 `### ` 블록에 source 또는 상속) | 블록 파싱 |
| O2 | sources의 src_id/source_file가 blocklist.md(오염 4종)에 없음 | blocklist 대조(src_id 정확일치 + source_file 경로 부분포함). **blocklist.md 부재 시 하드 FAIL**(검사 원천 없음을 PASS로 위장 금지) |
| O3 | 인용한 위키 원천이 DROP 판정 아님(승계맵) — `(승계·재검증 날짜)` 라벨 확인 | 라벨 정규식. **현 빌더 구현 = 소프트 프록시**(print-kb/wiki recipes/16_/17_ 인용에 승계·재검증 라벨 부재 시 경고). 전체 DROP-리스트(wiki-inheritance-map) 배선은 미완 — 하드 승격은 그 배선 후(검증가 O3 수동판정이 1차) |
| O5 | product 노드는 priced_by 엣지 ≥1 또는 gap/양면 선언 보유(끊긴 가격 사슬) | 엣지 검사 |
| O6 | price_formula 노드는 has_component 엣지 ≥1(고아 공식) | 엣지 검사 |

### 5.3 소프트 lint (경고 — 빌드 계속)
| ID | 규칙 |
|----|------|
| O4 | index.md에 이 노드가 등재됨(끊긴 index 0) — **소프트**(발견성 문제이지 그래프 무결성/오염 아님. graph-build §5는 O4를 I-set에 미포함=소프트로 통일·V1-04 교정) |
| L-12 | 본문 산문에 raw 가격형 수치(천단위 콤마·원-접미) 없음(스크립트 전사·예외 태그 권장) |
| L-13 | 노드 badge와 source badge 불일치 없음(노드 verified인데 source 전부 비verified 경고) |
| L-16 | 수치 표에 transcribed-by 마커 존재(표 직전 5줄 룩백) |
| L-19 | 고아 노드 없음(어떤 엣지에도 안 닿는 노드) — 단 term·rule·decision·intent은 예외 허용(graph-build I-1과 통일) |

### 5.4 lint 예외 태그
raw 수치가 불가피한 경우(단일 스칼라 설명 등) 인라인 태그로 예외 선언:
```markdown
최소 주문 15부 <!-- lint-allow: L-12 src=SR-2.2-diff -->
```

---

## 6. 파일 작성 워크플로 (집필 층, D-20)
1. 원천 읽기(청크=markdown 제목 블록 ~600토큰, gleaning 허용) → 기존 노드에 **링크만** 추가(신규 개체 발명 금지).
2. 신규 개체 후보는 `05_verification/mint-queue.md`에 격리(인간 승인 전 노드화 금지).
3. 수치는 스크립트 전사(§4). 파일 저장 시 인라인 lint(입구 방벽·C-7).
4. index.md 갱신(O4) + log.md append.
5. 빌드 시 전체 lint(출구 방벽).

## Sources
- `ontology-schema.md` (개체 17종·관계 19종·출처 5필드·badge)
- `../00_research/methodology-playbook.md` (D-2·D-8·D-9·D-20·②저장형식·판정 C-7 이중배치)
- `.claude/skills/okb-ontology-authoring/SKILL.md` (§1 노드구조·§3 빌드 무결성·§5 index)
- `_workspace/print-kb/wiki/README.md` (§3 [[ ]]·R-7 안정@id·R-9 과분할금지·역링크 슬롯)

---

## 변경 이력

### v1.0.3 — 2026-07-03 (검증 라운드 2 결함 교정 — `_meta/fix-log-260703.md` R2)
> 스키마 실질: `updated` 필드를 필수 → 선택(권장)으로 강등·유령 규칙 참조 제거. 명세-구현 정합.

- **V2-01 [Low]** L-7(updated 필수) 유령 규칙 해소. §2.1이 `updated`를 필수 5필드에 더해 `(L-7)` 라벨로 required 선언했으나 ①§5 lint 표에 L-7 규칙 행 부재 ②빌더 parse/serialize/L-2 검사 모두 `updated` 미포함 ③block-node 196개는 `updated` 자체가 없음. → §2.1 필수 YAML 예시에서 `updated` 제거(필수=id·type·anchor·badge·sources 5개로 명시), §2.3 선택 필드에 `updated`(file-node 권장·강제 없음) 이설, 유령 라벨 `(L-7)` 삭제. 실제 강제(옵션 a) 대신 강등(옵션 b) 채택 — block-node 전수 FAIL을 유발하는 강제는 부적절(파일 레벨 갱신일로 충분).

### v1.0.2 — 2026-07-03 (검증 라운드 1 결함 교정 — `_meta/fix-log-260703.md` R1)
> 스키마 실질: L-18 하드 승격(graph-build와 원래 일치·문서만 소프트로 어긋나 있던 것 통일)·O4 소프트 확정. 빌더 구현 정합.

- **V1-02B [Medium]** L-18(option_refs 부모정합·fn_chk_opt_item_ref)을 §5.3 소프트 → §5.1 구조 하드로 이동. graph-build §5.4 I-4 표가 이미 하드로 규정했는데 file-format만 소프트여서 두 명세가 불일치하던 것을 하드로 통일(빌더도 하드 구현). 판정 방법(부모 has_option_group 역참조 차원 집합 대조) 명시.
- **V1-04B [Low]** O4(index 등재)를 §5.2(의미 하드) → §5.3 소프트로 이동. index 미등재는 발견성 문제이지 그래프 무결성/오염이 아니며, graph-build §5는 O4를 I-set에 미포함(소프트)·빌더도 soft 처리 — 세 원천 소프트로 통일.
- **V1-01B/V1-02B [Medium]** O2 판정에 source_file 경로 부분포함 대조 추가(src_id 우회 방지)·blocklist.md 부재 시 하드 FAIL 명문화. O3은 현 빌더가 소프트 프록시(위키 승계·재검증 라벨 부재 경고)이고 전체 DROP-리스트 배선은 미완임을 정직 표기(하드 승격은 배선 후).

### v1.0.1 — 2026-07-03 (스키마 리뷰 교정 — `05_verification/schema-review-260703.md`)
> 스키마 실질 불변. 문서 정합 결함만 해소.

- **F-2 [High]** 개체 유형 "15종"→"17종" 통일. §2.1 type 주석·L-4 화이트리스트(gap·intent 명시 포함)·Sources 인용 갱신.
- **F-1 [High]** 관계 "18종"→"19종"(R19 `references`) 통일. §3.1 rel 규칙·§3.2 `[[ ]]` 추출 설명(R19·I-3 예외)·L-14 화이트리스트·Sources 갱신.
- **F-8 [Low]** L-19 고아 예외 목록 "term·rule"→"term·rule·decision·intent"로 graph-build I-1과 통일(두 판본 불일치 해소).
