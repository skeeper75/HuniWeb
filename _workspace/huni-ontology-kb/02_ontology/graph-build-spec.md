# 그래프 빌드 명세 — Huni-Ontology-KB (v1.0)

> 작성: 2026-07-03 · okb-ontology-architect
> 상위: `ontology-schema.md` · `file-format-spec.md` · `../00_research/methodology-playbook.md`(② 3층 저장·D-3·D-4·D-13·D-21).
> 목적: **정본 markdown 파일 → 그래프**를 결정론 스크립트가 만드는 명세. LLM은 이 경로에 개입하지 않는다(D-4). 무결성 검사·질의 인터페이스까지.
>
> **읽는 법:** 정본 파일(사람·LLM이 쓰는 지식)에서 "점과 선"(노드·엣지)을 뽑아 그래프로 만드는 프로그램의 설계서다. 그래프는 언제든 파일에서 다시 만들 수 있는 파생물이라, 깨져도 파일만 있으면 복구된다. 같은 파일이면 항상 같은 그래프가 나와야 한다(멱등).

---

## 1. 3층 저장 구조 (방법론 ② 채택)

| 층 | 형식 | git | 역할 |
|----|------|-----|------|
| ⓐ 정본 | `03_kb/**/*.md` (markdown+frontmatter) | 커밋 | 사람·LLM이 읽고 쓰는 유일 권위 |
| ⓑ 덤프 | `04_graph/nodes.jsonl` + `04_graph/edges.jsonl` (키 정렬·1줄=1객체) | 커밋 | 그래프 변화가 diff/PR로 보임. 재빌드 검증 대상 |
| ⓒ 질의 | `04_graph/graph.db` (SQLite) | **gitignore** | 재귀 CTE 경로 질의. ⓑ에서 재생성 |

- **JSONL 확정 이유(② 판정):** 노드 타입마다 속성이 다르고(product vs term vs gap) provenance가 중첩이라 CSV는 빈칸 범벅. JSONL은 키 정렬 직렬화로 CSV급 diff 가능 + 선택 필드 자연 수용.
- `.gitignore`에 `04_graph/graph.db`·`04_graph/*.db-journal` 등록(D-3).

---

## 2. build_graph.py 입출력 계약 (D-4)

### 2.1 입력 (2원천, LLM 없음)
1. **정본 파일**: `03_kb/**/*.md`의 frontmatter + 본문 `[[ ]]` (`_`-prefix·04_graph·05_verification 제외).
2. **라이브 FK 스냅샷**: `_foundation/live-snapshot/latest/` t_* CSV — 앵커 실재 검사(L-17)·역참조 보강용. **재사용**(재조사 금지, 방법론 원칙 3).

### 2.2 처리 파이프라인 (결정론)
```
① 수집   : 03_kb/**/*.md glob (정렬된 파일 순서)
② 파싱   : frontmatter YAML → 노드 레코드 / relations → 엣지 레코드 / 본문 [[ ]] → references 엣지(약)
③ 앵커검사: anchor가 t_*/코드면 live-snapshot CSV에 실재 확인(L-17)
④ lint   : file-format-spec §5 전 규칙 실행(구조 하드·의미 하드·소프트 경고)
⑤ 역링크 : 들어오는 엣지 집계 → 각 노드 backlinks 필드 계산(파생)
⑥ 직렬화 : 노드/엣지를 키 정렬 JSONL로 04_graph/에 기록
⑦ 적재   : nodes.jsonl+edges.jsonl → SQLite 테이블(node·edge·source) 로드
⑧ 리포트 : 05_verification/build-report-<날짜>.md (lint 결과·노드/엣지 수·무결성)
```

### 2.3 출력
- `04_graph/nodes.jsonl` — 노드 1개=1줄. 필드: `id·type·anchor·badge·props·standards·sources·backlinks·file_path`.
- `04_graph/edges.jsonl` — 엣지 1개=1줄. 필드: `src·rel·dst·origin(fk|doc|derived)·qualifier·note·source_node`.
- `04_graph/graph.db` — SQLite(§4 스키마).
- `05_verification/build-report-<날짜>.md`.

### 2.4 멱등성 계약 (D-4·SKILL §3)
- **같은 입력 → 바이트 동일 출력.** 정렬: 노드=id 오름차순, 엣지=(src,rel,dst) 오름차순, JSON 키=사전순, 시각/난수/실행경로 등 비결정 요소 배제.
- 검증: `build_graph.py` 2회 실행 → nodes.jsonl·edges.jsonl 해시 동일(I-멱등). 다르면 빌드 FAIL.
- **전면 재빌드만**(D-21·증분 병합 금지 — §17 "일괄 merge 함정" 실증). 매 빌드는 04_graph를 새로 씀.

---

## 3. 노드·엣지 추출 규칙

### 3.1 노드 추출
- 1 파일 1 노드: frontmatter 전체 → 노드 레코드. `file_path`에 정본 경로 저장(D-11 하이브리드 검색 — 그래프로 노드 확정 후 이 경로 Read).
- 축 페이지(1 파일 N 항목): 각 `### [ID] 제목 {badge}` 블록 → 노드. 블록은 **자체 필드를 영문 키 리스트 항목으로 기술**한다 — 빌더 `parse_block`이 파싱하는 키: `- type:`·`- anchor:`·`- src:`(=출처, 반복)·`- rel:`(=연결, 반복)·`- props:`·`- standards:`·`- prefLabel:`/`- definition:`/`- gap_what:`/`- gap_fill_from:`/`- gap_owner:`/`- current_value:`/`- authority_value:`/`- altLabel:`. badge는 헤더 `{badge}`에서 파싱.
- ★**파일 frontmatter 자동 상속 없음**: 블록 노드는 필수 필드(type·badge·anchor·src)를 **자체 기술**해야 한다. 한글 라벨(`- 출처:`/`- 연결:`)은 파싱하지 않으므로 쓰지 말 것(빌더가 조용히 드롭 → 해당 블록 L-6/L-2 하드 FAIL). 상속 미구현은 엄격 파싱(회귀 안전)이며 명세도 이에 맞춘다(v1.0.3·fix-log R2 V2-02). 본문 `[[ ]]`는 references(R19) 엣지로 추출(§3.2).
- gap·양면·term 특수 필드는 위 영문 키로 기술하며 그대로 노드 속성으로.

### 3.2 엣지 추출 (3원천)
| 원천 | origin 태그 | 규칙 |
|------|-----------|------|
| frontmatter `relations` | fk 또는 doc(관계유형이 R1~R12=fk, R13~R16·R19=doc) | rel·target → 엣지. target 실재 검사 |
| 본문 `[[노드id]]`·`[[페이지#항목ID]]` | doc(references=R19·약) | frontmatter에 없는 참조만 `references`(R19) 엣지 |
| `derived_from`·`alias_of` | derived | R17·R18 |
- 엣지 방향 = 스키마 사전 정의(ontology-schema §2). 양방향 필요분(역링크)은 backlinks로 파생, 별도 엣지 미생성.

### 3.3 alias 투영 (D-10)
`_glossary.md`의 term 노드 altLabel/hiddenLabel → 각각 `alias_of` 엣지(변형→prefLabel)로 자동 생성. 별도 term 노드 미생성(투영만).

---

## 4. SQLite 스키마 + 질의 인터페이스

### 4.1 테이블
```sql
CREATE TABLE node (
  id TEXT PRIMARY KEY, type TEXT, anchor TEXT, badge TEXT,
  props JSON, standards JSON, file_path TEXT
);
CREATE TABLE edge (
  src TEXT, rel TEXT, dst TEXT, origin TEXT, qualifier TEXT, note TEXT,
  PRIMARY KEY (src, rel, dst)
);
CREATE TABLE source (
  node_id TEXT, source_file TEXT, source_locator TEXT,
  captured_at TEXT, badge TEXT, src_id TEXT
);
CREATE INDEX idx_edge_src ON edge(src, rel);
CREATE INDEX idx_edge_dst ON edge(dst, rel);
CREATE INDEX idx_node_type ON node(type);
```

### 4.2 재귀 CTE 질의 예시 (경로 추적 — D-11)

**(a) 상품 → 가격 사슬 전체(공식·구성요소):**
```sql
WITH RECURSIVE chain(id, rel, depth) AS (
  SELECT dst, rel, 1 FROM edge WHERE src='product-016-premium-postcard' AND rel='priced_by'
  UNION ALL
  SELECT e.dst, e.rel, c.depth+1 FROM edge e JOIN chain c ON e.src=c.id
  WHERE e.rel='has_component' AND c.depth < 5
)
SELECT n.id, n.type, n.badge FROM chain c JOIN node n ON n.id=c.id;
-- → PRF_DGP_A + COMP_PRINT_DIGITAL_S1·COMP_PAPER·… (구성요소 전체)
```

**(b) 용도(intent) → 상품군 추천:**
```sql
SELECT n.id, n.props FROM edge e JOIN node n ON n.id=e.dst
WHERE e.src='INTENT_cafe_opening' AND e.rel IN ('references');
```

**(c) 끊긴 가격 사슬(무결성 — priced_by 없는 상품):**
```sql
SELECT id FROM node WHERE type='product'
AND id NOT IN (SELECT src FROM edge WHERE rel='priced_by')
AND id NOT IN (SELECT src FROM edge WHERE rel='derived_from')  -- gap 연결 예외
AND anchor NOT LIKE 'none%';
```

**(d) 자재 → 이 자재 쓰는 상품(역추적, 추천 지원):**
```sql
SELECT src FROM edge WHERE rel='uses_material' AND dst='material-MAT_000074';
```

> NetworkX는 빌드 시점 **분석 도구**로만 사용(저장소 아님, D-13) — 고아 노드·순환·연결 성분 검출. 상시 질의는 SQLite 재귀 CTE.

---

## 5. 무결성 검사 규칙 (빌드 내장 — D-13·SHACL-lite)

> file-format-spec §5 lint를 빌드가 실행하는 관점에서, **그래프 구조 무결성** 4범주로 재편성. 하드 위반=빌드 FAIL.

### 5.1 고아 노드 (I-1)
- 어떤 엣지에도 안 닿는 노드 검출(NetworkX degree=0). 단 term·rule·decision·intent은 독립 허용(경고만·file-format-spec L-19와 통일). product·formula·component가 고아면 FAIL 후보.

### 5.2 끊긴 링크 (I-2, 하드)
- 모든 edge.dst·edge.src가 node 테이블에 실재. 미실재 target = FAIL(끊긴 링크 0).

### 5.3 타입 위반 (I-3, 하드)
- edge.rel이 스키마 19종에 존재 + rel의 source/target 타입이 사전 정의와 일치(예 `priced_by`의 dst는 반드시 price_formula). 불일치=FAIL. **단 R19 `references`는 any→any이므로 source/target 타입 검사에서 예외**(폐쇄 목록 등재라 rel 존재 검사는 통과).
- node.type이 17종에 존재(앵커 12+KB전용 term·rule·decision 3+특수 `gap`·`intent` 2 — 화이트리스트에 gap·intent 포함). anchor가 t_*/코드면 live-snapshot 실재(닫힌 세계·환각 차단).

### 5.4 필수 엣지 (I-4, 하드 — SHACL-lite 개수 제약)
| 노드 타입 | 필수 엣지 규칙 |
|-----------|---------------|
| product | `priced_by` ≥1 또는 gap/양면 선언(O5) |
| price_formula | `has_component` ≥1(O6·고아 공식=견적 0) |
| option_group | `option_refs` 타깃이 같은 부모 product에 실재(L-18) |

### 5.5 멱등 검사 (I-5, 하드)
- 2회 빌드 → nodes.jsonl·edges.jsonl 해시 동일. 다르면 비결정 요소 존재 → FAIL.

### 5.6 오염 검사 (I-6, 하드)
- 전 노드 sources.src_id가 blocklist.md에 없음(O2). 있으면 FAIL(STALE/v03·환각 인용 차단).

### 5.6b 마스터 앵커 단일소유권 (L-20, 소프트 — 동형결합 계약)
- 같은 `t_*/CODE` **마스터** 앵커를 2+ 노드가 **동일 type**으로 소유하면 소프트 경고(공유 축 파편화·질의 누락 위험). L-3(id 중복)이 못 잡는 앵커 중복 사각지대(동형결합 단일소유권 = 공유 마스터행은 단일 owner 노드).
- **제외:** `t_prd_product_*` 정션 테이블(prd_cd 조밀 앵커=자식행 by-design 공유·D-SILSA-INT-2 architect 소관). 크로스타입 공유(product↔bundle_qty·decision↔component)는 (type,anchor) 그룹핑으로 자동 제외(적대 패널 by-design 판정 정합).
- **소프트 사유:** 로컬 preset 재선언이 같은 마스터 앵커로 해석되면 가격사슬은 무손상(가격 무영향)이나 공유 축 모델이 파편화되므로 회귀 가드로 노출. 하드 승격은 전 축 로컬 preset 정리 후 검토(현 잔여=스티커 축 등 타 레인 소관). 실사 축은 D-SILSA-INT-1 교정으로 0.

### 5.7 빌드 리포트 필수 항목
노드 수(타입별)·엣지 수(rel별)·lint 위반 목록(하드/소프트)·고아 노드·끊긴 링크·멱등 해시·blocklist 히트. 게이트(okb-adversarial-gate O1~O7)가 이 리포트를 판정 입력으로.

---

## 6. 재빌드 트리거 (D-21·⑤Q5 권고 ⓑ)
- 하네스 실행 시 **Phase 0으로 lint+빌드 선행**(하네스 실행=Lint 선행). 사람 수동 트리거도 허용. 스케줄 자동화는 미채택(실 COMMIT 인간 승인 원칙).
- 정본 파일 변경 → 빌드 → 리포트 검토 → 게이트. SQLite는 항상 nodes/edges.jsonl에서 재생성(로컬).

## 7. 성능·확장 보류(방법론 ④ 보류분)
- 임베딩(sqlite-vec): 질의 게이트에서 "노드 미발견율" 실측 누적 시 같은 .db에 추가(선제 도입 안 함, D-11·H-1).
- 수만 노드 재귀 CTE 성능 상한: 파일럿 실측으로 확인(D-22 연동). 부족 시 DuckDB+duckpgq 재검토(H-2).

## Sources
- `../00_research/methodology-playbook.md` (②3층저장·JSONL판정·D-3·D-4·D-13·D-21·④보류)
- `ontology-schema.md` (개체17·관계19·필수엣지·단가행접기 D-22)
- `file-format-spec.md` (§5 lint 규칙 — 빌드가 실행)
- `.claude/skills/okb-ontology-authoring/SKILL.md` (§3 무결성 5종·멱등)
- `_foundation/live-snapshot/latest/` (앵커 실재검사 원천·재사용)

---

## 변경 이력

### v1.0.5 — 2026-07-04 (O5 코드-스펙 정렬 + 가격 gap 화이트리스트 — 굿즈/파우치/봉투 확장)
> 실질 변경: O5(끊긴 가격사슬) 게이트를 spec §5.4(§151 "priced_by ≥1 또는 gap/양면 선언")에 정렬하되, **가격류 gap 선언만** 인정하도록 강화.

- **배경**: 굿즈/파우치/봉투 다수가 진짜 가격 원천 부재(NEITHER-gap)이거나 고정가룩업(t_prd_product_prices 직접 unit_price·공식 없음→priced_by 불가). 기존 O5 코드는 priced_by/derived_from 엣지만 인정해 스펙의 "gap 선언" 경로가 미구현이었다(88 하드).
- **변경**(`build_graph.py` O5 블록): product가 (a) priced_by/derived_from, **또는** (b) **가격류 gap 노드로의 out-edge**(type=gap ∧ id ∈ `PRICE_GAP_HINTS`=`neither·fixed-lookup·price-unloaded·sparse-grid·redesign-pending·fixedprice·price-pending·tbd`)를 보유하면 O5 충족. **비가격 gap**(sewing·contamination·empty-shell·option-ui)만으로는 O5 우회 불가(가격 사슬 게이트 의도 보존·D-GD-INT-2 강화).
- **정직 경로**: NEITHER-gap→`gap-goods-neither`(가격 gap)·고정가룩업→`gap-goods-fixed-lookup-no-formula`(가격 gap·값은 props 기재·엔진 권위)·미출시(use_yn=N)도 가격 gap 선언. 가산적 변경(기존 통과 상품 회귀 0). file-format-spec §O5와 정합.
- **후속(비차단)**: `PRICE_GAP_HINTS` 화이트리스트를 gap 노드 필드 마커(`price_slot`)로 대체하면 더 견고(architect 판단).

### v1.0.4 — 2026-07-03 (실사 검증 결함 교정 — `_meta/fix-log-silsa-260703.md`)
> 실질 신규: §5.6b L-20(마스터 앵커 단일소유권·소프트) 추가. 빌더 구현과 정합.

- **D-SILSA-INT-1(b)/INT-3 [Medium/Low]** §5.6b 신설 — 마스터 `t_*/CODE` 앵커를 2+ 노드가 동일 type으로 소유하는 앵커 중복을 소프트 경고(L-20). `t_prd_product_*` 정션·크로스타입 제외. 빌더 `build_graph.py`에 `_anchor_owners` 그룹핑 구현. 실사 size 중복은 정본 재지향으로 0·잔여는 회귀 가드. file-format-spec §5.3 L-20과 통일.

### v1.0.3 — 2026-07-03 (검증 라운드 2 결함 교정 — `_meta/fix-log-260703.md` R2)
> 실질 불변(빌더 코드 무수정). §3.1 블록 파싱 서술을 실제 구현대로 정정 — 명세-구현 불일치 해소.

- **V2-02 [Low]** §3.1 블록 노드 파싱 서술 정정. 종전 "블록 로컬 frontmatter 없으면 파일 frontmatter 상속 + 블록 내 `- 출처:`·`- 연결:` 파싱"은 구현과 불일치(빌더 `parse_block`은 ①영문 키 `- type:`/`- src:`/`- rel:`/`- anchor:` 등만 파싱, 한글 라벨 무시 ②파일 frontmatter 상속 미구현). 명세를 실제 구현(영문 키 파싱·상속 없음·블록 필수필드 자체 기술)으로 맞춤. 상속을 실제 원하면 별도 결정으로 `parse_block`에 상속 로직 추가(현재는 엄격 파싱이 회귀 안전 — 명세가 이를 채택). 파싱 대상 영문 키 목록 명기.

### v1.0.3 — 2026-07-03 (스티커 검증 라운드 결함 교정 — `_meta/fix-log-sticker-260703.md`)
> 실질 불변. O4 발견성 규칙 강화만(무결성 I-set 불변·하드 0 유지).

- **D-STK-3 [Low]** O4(index 등재)에 **O4b index dead-link 스캔** 추가(소프트) — 기존 O4는 `basename in idx` 부분문자열 매칭이라 존재하지 않는 index 링크 텍스트(예 `product-059-sticker-spec-square.md`)가 실파일 basename(`sticker-spec-square.md`)을 부분포함하면 "등재됨"으로 오판(false-negative)하여 실 dead-link(404)를 놓쳤음. O4b는 index.md 마크다운 링크 `](path.md)` target 파일 실재를 직접 검사해 부재 링크를 소프트 경고. 발견성 규칙이므로 소프트 유지(I-set 미포함·V1-04B 정합). 빌더 `build_graph.py` O4 블록에 O4b 구현.

### v1.0.2 — 2026-07-03 (검증 라운드 1 결함 교정 — `_meta/fix-log-260703.md` R1)
> 실질 불변. file-format-spec과의 정합 확인·명시만.

- **V1-02B [Medium]** §5.4 L-18(option_group option_refs 부모정합)은 본래 하드(I-4)로 규정돼 있었음 — file-format-spec가 소프트로 어긋나 있던 것을 이번에 하드로 통일(이 문서는 불변). 빌더가 L-18 하드 구현.
- **V1-04B [Low]** O4(index 등재)는 이 문서 §5 무결성 I-set에 **의도적으로 미포함**(소프트) — file-format-spec §5.2(하드)에서 §5.3(소프트)으로 이동해 통일. 그래프 무결성이 아니라 발견성 규칙이므로 I-set 제외가 맞음.
- **V1-06B [Medium]** §5.6 I-6 오염 검사: blocklist.md 부재 시 하드 FAIL(빌더 `load_blocklist` present=False→하드) + source_file 경로 부분포함 대조 추가(src_id 우회 방지). "검사 원천 없음"을 PASS로 위장하던 조용한 통과 차단.

### v1.0.1 — 2026-07-03 (스키마 리뷰 교정 — `05_verification/schema-review-260703.md`)
> 스키마 실질 불변. 문서 정합 결함만 해소.

- **F-1 [High]** §3.2 엣지 추출 origin 매핑에 R19 `references`=doc 추가·I-3 "관계 18종"→"19종"·R19 any→any는 source/target 타입 검사 예외로 명시. §4.2(b) intent 질의 `e.rel IN ('references')`는 이제 등재 관계로 정상. Sources 갱신.
- **F-2 [High]** I-3 "node.type 15종"→"17종"(앵커 12+KB전용 3+특수 gap·intent 2·화이트리스트 gap·intent 포함). Sources 갱신.
- **F-8 [Low]** I-1 고아 예외 "term·rule·decision"→"term·rule·decision·intent"로 file-format-spec L-19와 통일.
