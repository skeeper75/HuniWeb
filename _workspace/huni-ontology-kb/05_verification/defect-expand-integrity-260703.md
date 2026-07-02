# 결함 보드 — 그래프 무결성 재실행 + 스키마 정합(전 36상품) · 2026-07-03

> 적대적 검증가(okb-adversarial-verifier). 배정 축 = ①build_graph.py 직접 2회 실행(멱등·하드0) ②신규 28상품 공유 축 mint 단일소유권·중복id·고아 ③frontmatter/블록 문법 파서 밖 수색 ④jsonl/SQLite↔정본 대응(그래프 전용 사실0).
> **생성자·기존 리포트 비신뢰 — 전 판정 직접 재실측.** 기계 대조는 스크립트, 자연어는 표본/의심 노드만.
> 대상: 03_kb(노드 466·엣지 1521) · 스키마 v1.0.1 · 빌더 build_graph.py.

## 판정 요약

| 축 | 판정 | 근거(재실측) |
|----|------|------|
| ① 그래프 무결성 재실행 | **PASS** | `--idem`+from-scratch(산출물 삭제 후 재빌드) 2방식 모두 nodes.jsonl/edges.jsonl **바이트 동일**. 하드 0·소프트 120. 커밋된 산출물 == 갓 빌드 해시(11a4c1727614a548 / 7e02a509a194e2e9). |
| ② 공유 축 mint 단일소유권 | **PASS** | material 56·size 52·process 37·category 11·plate_size 3·print_option 4·bundle_qty 15 **전부 t_* 앵커**(anchor=none/xlsx 0건). id=`<type>-<CODE>` ↔ anchor 1:1. **중복 anchor 0**(같은 t_코드 이중 mint 없음). KB 발명 축 노드 0. |
| ③ frontmatter/블록 문법 파서 밖 | **2 결함(Medium)** | `### [` 헤더 430개 전부 엄격 정규식 통과(near-miss 0)·타 레벨 헤더 노드문법 0·frontmatter id 누락 0·노드수 정합(36 frontmatter + 430 블록 = 466). **단, 파서가 못 잡는 "의도했으나 미파싱된 참조" 2종 적발(아래 M1·M2).** |
| ④ jsonl/SQLite↔정본 | **PASS** | jsonl(466n/1521e) == SQLite(466n/1521e) **집합 완전 동일**(jsonl-only 0·sqlite-only 0). fk/doc 엣지 1497건 **전부 정본 .md rel/[[ref]] 역추적 성공 → 그래프 전용 사실 0**. derived 24 = alias_of 19(term 투영·정당) + derived_from 5(전부 정본 선언). |

**종합: 하드 무결성 결함 0. 가격 영향(High) 결함 0. Medium 2·Low 3.** "무결" 단정 아님 — 아래 범위/한계 참조.

---

## 결함 상세

### M1 — 깨진 rule 참조 `RULE_import_material_keep`(존재 안 함) · Medium
- **노드/위치:** `product-027-nodes.md:71` · `product-029-trifold-card-nodes.md:44` · `product-031-premium-namecard-nodes.md:34` (3파일)
- **축:** ③ 블록 문법(파서 밖) — `[[rule/rules#RULE_import_material_keep]]`
- **결함:** 참조 대상 노드 id `RULE_import_material_keep`가 **KB에 존재하지 않음.** 실제 노드 = `RULE_import_material_no_delete`(rule/rules.md). 파서는 `#` 뒤를 노드 id로 잡아 미해결→소프트로 조용히 강등(엣지 미생성). 결과: "IMPORT시트 등록 자재 삭제 금지" rule로의 의도된 시맨틱 링크 3건이 그래프에 부재.
- **증거:** `sqlite3 graph.db "SELECT id FROM node WHERE id LIKE 'RULE_%'"` → `RULE_import_material_no_delete` 존재·`RULE_import_material_keep` 부재. 소프트 경고 "본문 [[ ]] 미해결 참조 -> RULE_import_material_keep".
- **심각도:** Medium(가격 무영향·정직성/추적성 손상. 조용한 드롭이라 리포트만 보면 안 보임).
- **교정안:** 3파일에서 `RULE_import_material_keep` → `RULE_import_material_no_delete`.
- **라우팅:** builder.

### M2 — product-048 GAP 참조가 산문/백틱뿐 → 조용한 고아 GAP 2건 · Medium
- **노드:** `gap-048-no-size` · `gap-048-material` (product-048-folded-leaflet-nodes.md 선언)
- **축:** ③ 블록 문법(의도했으나 미파싱) + I-1 고아
- **결함:** product-048-folded-leaflet.md가 3개 GAP을 `[[...-nodes]] \`gap-048-no-size\``(파일포인터+**백틱**) 형태로만 참조 — `[[gap-048-no-size]]` 노드 참조가 아님 → 그래프 엣지 미생성. gap-048-no-size·gap-048-material은 **완전 고아**(어떤 노드도 안 가리킴). GAP은 정직하게 선언됐으나 **graph traversal("048에 뭐가 빠졌나")로 도달 불가.** 형제 GAP 61/67은 `[[ ]]` 노드참조로 연결되는 것과 **비일관**(참고: product-038은 gap을 derived_from으로 정상 연결).
- **증거:** `sqlite3 graph.db "SELECT src,rel,dst FROM edge WHERE dst IN ('gap-048-no-size','gap-048-material')"` → 0행. gap 전체 67 중 62 연결(references 117·derived_from 1)·4 고아(이 2건 + 아래 L3 2건).
- **심각도:** Medium(정직 선언 존재→은폐 아님이나, 그래프 연결완전성 손상·연결축 조용한 누락).
- **교정안:** product-048에서 `gap-048-no-size`/`gap-048-material`을 `[[ ]]` 노드참조 또는 rel(references/derived_from)로 명시 연결.
- **라우팅:** builder.

### L1 — 미해결 `[[ ]]` 참조 91건: 파일포인터·외부인용 컨벤션 드리프트 · Low
- **축:** ③/④(사실 손실 없음 확인)
- **내용:** 91건 대부분 = ① 분할 companion 파일 포인터 `[[product-027-nodes]]` 등(해당 파일은 frontmatter id 없는 순수 블록 컨테이너 → 노드 아님) ② 외부 SOT/MEMORY 인용 `[[product-type-classification-sot]]`(12x)·`[[harness-domain-rules-12-260701]]`(5x)·`[[goods-material-contamination-260630]]`(3x). **둘 다 잘못된 엣지를 만들지 않음(fabrication 0)** — 정상적으로 미해결 소프트 처리. 단 소프트 노이즈 91건으로 진짜 결함(M1·M2)을 묻히게 함.
- **교정안:** 파일 포인터는 `[[파일#노드id]]`(# 형) 또는 경로형(`/` 포함→스킵)으로, 외부 인용은 산문/각주로. (advisory — 문법 규약 정비)
- **라우팅:** architect(file-format-spec 참조 규약 명확화) / builder(표기 정정).

### L2 — L-12 소프트 19건 = 수량("매") 오탐 · Low
- **축:** ③(린트 과민)
- **내용:** L-12(산문 raw 가격 의심) 19건 전부 "최소 12매·최대 10,000매·100매 증분" 등 **수량 규칙 수치**(가격 전사 아님). 천단위 콤마 정규식이 수량을 가격으로 오탐. 데이터 결함 아님.
- **교정안:** L-12 린트에 "매/장/부 등 수량 단위 문맥" 제외 규칙 추가(선택). 데이터 교정 불요.
- **라우팅:** architect(lint 튜닝·선택).

### L3 — 전역 floating GAP 2건 + 미사용 공유축 고아 6건 = 커버리지 경계 · Low
- **노드:** `GAP_product_count`·`GAP_roll_material_price`(rule/gaps.md) / printopt POPT_000008·009·process PROC_000001·013·056·size SIZ_000499
- **축:** ② 고아 판정 / I-1 소프트
- **내용:** 전역 GAP 2건은 특정 상품 비귀속(source-registry §9 성격)·공유축 6노드는 파일럿 36상품이 아직 안 쓰는 축 항목. **전부 ORPHAN_EXEMPT 아닌 소프트 유형으로 정확히 강등**(하드 아님). 빌드 리포트가 "커버리지 경계"로 자기선언한 것과 일치 — 조용한 은폐 아님.
- **교정안:** 없음(연결완전성 축5에서 상품 연결 여부 재판정 대상). 전역 GAP은 index/영향 상품에서 [[ ]] 연결 권고.
- **라우팅:** curator/connectivity 라운드(축5).

---

## 검증 범위·한계(정직 선언)

- **전수(스크립트 결정론):** 멱등 2방식·노드수 정합·anchor 중복·jsonl↔SQLite 집합·엣지 역추적(1497 전건)·전 36상품 필수엣지(O5/O6·anchor=none 회피)·430 블록헤더 정규식.
- **표본/의심노드(자연어):** L-12 6/19 표본·미해결 참조는 target 집계 후 intra-KB 후보만 정밀(파일/외부 자동 제외). M1은 전건 grep 확인.
- **안 본 것:** ⑤ 연결 완전성(상품→단가행 종단 경로)·가격 evaluate_price 실측·출처 원문 왜곡인용(축1)·권위 260702 diff 대조(축2)·오염 blocklist 실효(축3) = **타 축 배정(본 라운드 밖).** floating GAP의 상품 귀속 타당성은 축5 소관.
- **재현:** 전 스크립트 `05_verification/scripts/` + 본 보드 내 인라인 쿼리로 재실행 가능. 빌더 리포트(build-report-20260703.md)의 하드0·소프트120 = 직접 재실측 일치.

**결함 0 단정 금지:** 배정 4축 내 하드 무결성 결함은 0이나, ③에서 파서가 못 잡는 의도-참조 드롭 2건(M1·M2)이 실재. 이는 build 하드게이트 사각(소프트 강등)이며 연결완전성으로 이어짐.
