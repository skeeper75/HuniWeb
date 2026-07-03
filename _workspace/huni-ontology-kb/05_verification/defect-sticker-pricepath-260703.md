# defect-sticker-pricepath-260703 — 스티커(052~067) 가격 경로 완전성 적대 검증

- 배정 축: 스티커 가격 경로 완전성(형상×치수×코팅 격자)
- 대상: 16 스티커 상품 PRD_000052~067 / graph.db(node 652·edge 2124·스키마 v1.0.1)
- 방법: graph.db 재귀 탐색 + live-snapshot(20260702_1119) 결정론 대조. 생성자 리포트 비신뢰·직접 재실측.
- 판정: **CONDITIONAL-GO** — 가격 경로 골격 건전(전 16상품 product→formula→component 완전·PRICE≠0 격자 실재·선언 GAP 정직). High(가격영향) 결함 0. 구조 일관성 결함 1(Medium)+정밀도 nit 3(Low).
- 범위/한계: 그래프+live-snapshot 전수 대조(스크립트). evaluate_price 실호출 미수행(라이브 읽기전용 SELECT만·격자 실재로 계산가능성만 입증). 자연어 판정은 052/055/059/062/063/064 표본 심층.

## 반증 실패(=생존, 검증 통과) 요약
- **경로 완전성:** 16/16 스티커 `product→priced_by→PRF_*→has_component→COMP_*` 완결. 고아 공식 0·끊긴 사슬 0. 공식 4종=PRF_STK_FIXED(52~64)·PRF_STK_PACK(65)·PRF_GANGPAN_FIXED(66)·PRF_STK_TATTOO(67), 전부 live 실재(명칭 일치).
- **PRICE≠0 격자 실재:** COMP_STK_PRINT 6,498행(20 siz×15 mat) 전행 nonzero·GANGPAN 1,110(37×6)·PACK 1행·TATTOO 666행 — zero 0건. "완제품가 고정가 룩업·원자합산 아님" 아키타입 실측 부합.
- **형상×치수 격자 연결:** 전 상품 has_size의 SIZ_cd가 해당 COMP 격자에 실재. **유일 예외 SIZ_000058(062)=격자 부재** → `gap-062-siz058-price-missing`(silent-0)로 KB가 이미 정직 선언(적대적 재현이 KB 자기선언과 일치).
- **코팅 CONFLICT 양면/GAP:** coated-material 이중표현 상품 052/058/059/060/061/062/064/066 각각 `gap-0xx-coating-conflict` 선언·product references 연결. coat_side_cnt='' 전행(코팅=독립 가격축 아님·자재 흡수) → 아키타입 "코팅 격자"는 conflict 선언으로 완화.
- **미출시(use_yn=N) 처리:** 063·064 미배선(CPQ 0행 등)을 "use_yn=N 미출시와 정합"으로 명시(`gap-063-cpq-option-layer`/`gap-064-cpq-missing`) — 결함 아닌 라이브 상태로 정직 표기. 정합.
- **그래프 무결성:** build_graph.py 2회 재실행 해시 동일(멱등 True)·nodes/edges md5 불변·hard lint 0·끊긴 링크(dead_dst) 0·dead_src 19=전부 alias_of(스키마 예외). orphan 7=soft(gap/print_option/process/size, ORPHAN_HARD 아님).
- **연당가(roll material) GAP 실재성:** `GAP_roll_material_price` anchor=none·"엑셀 미기재 암묵지" — 진짜 원천부재(반증 실패). per-product yeondangga 워크리스트 양면 defect 노드로 분리.

## 결함 보드

| # | 노드/엣지 | 축 | 결함 | 증거(재현) | 심각도 | 교정안 | 라우팅 |
|---|---|---|---|---|---|---|---|
| D1 | PRD_000059 (sticker-spec-square) · qty-059 부재 · has_qty_rule 엣지 부재 | 5 연결완전성 | **스티커 16상품 중 059만 유일하게 bundle_qty 노드+has_qty_rule 엣지 없음**(15 형제 전부 qty-0xx 보유). 059 md는 수량규칙(min4/max10000/incr4)을 prose·props로 기술하나 그래프 노드/엣지로 미모델링. GAP 미선언(silent). `min_qty`는 COMP_STK_PRINT use_dims 축(가격격자 다리) | `WHERE anchor='t_prd_products/PRD_000059' AND type='bundle_qty'` → 0행(타 15상품 1행). 059 md relations 블록에 has_qty_rule 라인 부재. gaps.md에 059 qty 항목 0 | Medium(구조 불일치·가격축 노드 누락. 단 live 격자 실재로 계산은 가능·prose 문서화됨→High 아님) | qty-059 노드 신설(형제 동형)+has_qty_rule 엣지 배선. 또는 059가 의도적 제외면 GAP 선언 | builder |
| D2 | PRD_000055 (sheet-freeform) · gap-055-coating-conflict 부재 | 3 오염/5 완전성 | 055는 coated material(MAT_000593 "유포+무광쿨코팅")+coating process(PROC_000114 쿨코팅)의 **BATCH-3 코팅 이중표현**을 가지나 052-family(8건 gap 노드)와 달리 coating-conflict를 **gap 노드로 미격상**(prose-note만). 055 gaps=cutting-optref-stale·jogaksu·material-cost·material-name(coating-conflict 없음) | 055 md L19/L90-91 "쿨코팅은 자재명 내장 무광쿨코팅의 공정 표현"(prose). t_prd_product_materials PRD_000055=MAT_000593(coated)·t_prd_product_processes PRD_000055=PROC_000114(쿨코팅). all-gap 목록에 gap-055-coating-conflict 없음 | Low(완화: 활성자재 1종·완제품가 fixed lookup·coat_side_cnt=''→이중과금 경로 없음. 단 052-family와 선언 불일치) | gap-055-coating-conflict 신설(양면 기록)해 BATCH-3 추적 일관화, 또는 055 exempt 사유 명문화 | curator confirm(staff owns BATCH-3) |
| D3 | 052 relation note(L31) · gaps.md L114 "삭제 PROC_000054" | 1 출처 정확성 | PROC_000054(반칼)를 "삭제됨"으로 표기하나 t_proc_processes PROC_000054 del_yn=N(마스터 실활성). 실제=052 product_processes에서만 delist(→PROC_000122 이관). 052 본문(L100-102)은 정확("052 활성 공정 아니다")하나 relation note/gaps 요약은 마스터 삭제로 오독 가능 | t_proc_processes PROC_000054 → ('반칼','N','Y'). 052 md L31 "ref_key1=PROC_000054(삭제됨)" vs L102 "052 product_processes에서 논리삭제" | Low(가격 무영향·본문 정합. dangling-optref gap 자체는 정확 선언) | "삭제됨"→"052 상품공정에서 delist(마스터 활성)"로 문안 정밀화 | curator |
| D4 | GAP_roll_material_price · GAP_product_count | 4 그래프 무결성 | 시스템성 GAP 2건이 소비 상품 back-reference 없이 orphan(soft-lint). 진짜 원천부재이나 per-product 연당가 gap과 미연결 | `id NOT IN (SELECT src FROM edge) AND NOT IN (SELECT dst FROM edge)` → 포함. incoming edge 0 | Low(soft·systemic. 내용 정직) | 소비 상품(yeondangga 스티커군)에서 references 링크, 또는 systemic-orphan 허용 명문화 | curator/architect |

## 라우팅 요약
- builder: D1(qty-059 노드/엣지 배선).
- curator/staff confirm: D2(055 코팅 conflict 선언 여부·BATCH-3 소관), D3(문안), D4(링크).
- architect: 없음(스키마 한계 아님).
- 원천 자체 결함: 없음(라이브 코팅 이중표현·연당가 부재는 이미 staff-owned GAP로 정직 격리).

## 미검증(정직 명시)
- evaluate_price 실호출/시뮬레이터 POST 미수행(가격값 오차 0 미입증 — 격자 PRICE≠0·계산가능성까지만).
- 자연어 심층은 052/055/059/062/063/064 표본. 053/054/056/057/060/061/065/066/067은 스크립트 전수(경로·격자·GAP)만·prose 정밀 미독.
- codex 독립 2차 미실행(Claude 단독).
