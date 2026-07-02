<!-- _glossary.md — term(E13) 단일 원천(D-10). ★_-prefix이나 노드 추출 대상(file-format-spec §1.4 예외). -->
<!-- altLabel/hiddenLabel은 빌드 시 alias_of 엣지(변형→prefLabel)로 투영(graph-build §3.3). -->

# 용어집 (term) — 표준어·동의어·오표기 정리

자연어 질의의 표현 다양성(귀돌이/라운딩 등)을 표준어로 정렬해 검색 라우팅(nl-query §0)을 돕는다.
prefLabel은 언어당 1개·전역 유일(L-11). 각 term은 최소 1 출처.

### [TERM_digital_print] 디지털인쇄 {verified}
- type: term
- anchor: xlsx:docs/huni/후니프린팅_상품마스터_260702.xlsx#디지털인쇄
- src: {source_file: "docs/huni/후니프린팅_상품마스터_260702.xlsx", source_locator: "시트:디지털인쇄(시트2)", captured_at: "2026-07-03", badge: verified, src_id: SR-2.2-diff}
- src: {source_file: "docs/kb/KB_01_엑셀해부_접근방법론.md", source_locator: "§1.2 시트 인벤토리", captured_at: "2026-07-03", badge: verified, src_id: SR-1-kb01}
- prefLabel: 디지털인쇄
- altLabel: [디지털출력, 디지털프린팅, 디지털 인쇄]
- definition: "토너 기반 소량 인쇄 상품군(상품마스터 시트2). 36 distinct 상품/7 구분(엽서·포토카드·접지카드·명함·상품권·배경지·인쇄홍보물). 파일럿 상품군."
- props: {status: "표준어", scope: "상품군 개념(라이브 단일 카테고리 없음 — 시트 단위 그룹)"}

### [TERM_corner_round] 귀돌이 {verified}
- type: term
- anchor: none  # 사유: 용어집 단일 원천(공정 PROC_000026에 매핑되는 표기 정리)
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "COMP_PP_CORNER_RIGHT 귀돌이비", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- prefLabel: 귀돌이
- altLabel: [라운딩, 모서리둥글리기, 모서리라운딩]
- definition: "모서리를 둥글게 자르는 후가공(공정 PROC_000026). 가격구성요소 COMP_PP_CORNER_RIGHT."
- props: {process_mapping: "PROC_000026"}

### [TERM_spot_color] 별색 {verified}
- type: term
- anchor: none  # 사유: 용어집 단일 원천(도메인 개념)
- src: {source_file: "_workspace/print-kb/wiki/base/color.md", source_locator: "§2 별색/도수/화이트 (승계)", captured_at: "2026-07-03", badge: verified, src_id: SR-3-wikibase}
- prefLabel: 별색
- altLabel: [스팟컬러, 스팟, spot color]
- definition: "CMYK 외 특수 색(화이트·금은 등). ★후니에서 별색은 도수가 아니라 공정(PROC_000007)으로 들어온다(clr_cd=NULL)."
- props: {process_mapping: "PROC_000007"}

### [TERM_pansu] 판걸이수 {verified}
- type: term
- anchor: none  # 사유: 용어집 단일 원천(파생값 개념)
- src: {source_file: "_workspace/_foundation/HARNESS-DOMAIN-RULES-260701.md", source_locator: "판걸이수 규칙", captured_at: "2026-07-03", badge: verified, src_id: SR-4-domrules}
- prefLabel: 판걸이수
- altLabel: [UP수, 판수, 절수]
- definition: "출력용지 1판에 몇 개의 제작 단위가 들어가는가(UP수). 사이즈의 파생값 — DB 함수 fn_calc_pansu(t_siz_pansu lookup→기하 폴백)로 계산(앱 아님·T-7 정정)."
- props: {derived_from: "size", engine_fn: "fn_calc_pansu"}

### [TERM_atomic_sum] 원자합산형 {verified}
- type: term
- anchor: none  # 사유: 용어집 단일 원천(가격 아키타입)
- src: {source_file: "docs/kb/02_상품마스터_가격표_구조_가격아키타입.md", source_locator: "가격 아키타입 3종", captured_at: "2026-07-03", badge: verified, src_id: SR-1-kb02}
- prefLabel: 원자합산형
- altLabel: [원자합산, atomic sum]
- definition: "가격 아키타입 1종 = [출력]+[소재]×[제작수량/판걸이수]+[후가공] 각 원자를 더함. 디지털인쇄 주 아키타입(PRF_DGP_A~F)."

### [TERM_die_cut] 완칼 {verified}
- type: term
- anchor: none  # 사유: 용어집 단일 원천(공정 PROC_000053)
- src: {source_file: "live-snapshot/latest/t_proc_processes.csv", source_locator: "PROC_000053 완칼", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- prefLabel: 완칼
- altLabel: [도무송, 완칼따기, die-cut]
- definition: "임의 모양으로 완제품을 따내는 커팅(공정 PROC_000053). 모양엽서·라벨택. 가격구성요소 COMP_CUT_FULL_DIECUT."
- props: {process_mapping: "PROC_000053"}

### [TERM_plate] 판형 {verified}
- type: term
- anchor: none  # 사유: 용어집 단일 원천(출력용지규격 개념)
- src: {source_file: "_workspace/_foundation/HARNESS-DOMAIN-RULES-260701.md", source_locator: "판형 규칙(종이류만)", captured_at: "2026-07-03", badge: verified, src_id: SR-4-domrules}
- prefLabel: 판형
- altLabel: [출력용지규격, 출력판형]
- definition: "출력용지규격(작업사이즈 아님). 종이류에만 유효. 고객 미선택 — fn_best_plate 자동선택."
