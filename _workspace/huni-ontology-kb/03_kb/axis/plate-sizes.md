<!-- axis page: E7 plate_size — 출력용지규격(종이류만·판형). -->
<!-- ★[HARD 도메인] 판형 = 출력용지규격(작업사이즈 아님)·종이류에만 유효·고객 미선택(fn_best_plate 자동선택). -->

# 축: 판형 (plate_size) — 출력용지규격

디지털 전 상품 = 국전계열(OUTPUT_PAPER_TYPE.01·316×467). 판형은 고객이 안 고른다 →
`fn_best_plate(prd,item)`가 판수>0 연결을 자동선택한다. 판걸이수(UP수)는 판형에서
`fn_calc_pansu`(t_siz_pansu lookup→기하 폴백)로 계산(파생·[[rule/rules#RULE_pansu_db_function]]).
상품→판형(R6 `has_plate_size`)은 상품 노드(Phase 4)가 종이류에만 건다.

### [plate-OUTPUT_PAPER_TYPE_01] 국전계열 (316x467) {verified}
- type: plate_size
- anchor: t_cod_base_codes/OUTPUT_PAPER_TYPE.01
- src: {source_file: "live-snapshot/latest/t_cod_base_codes.csv", source_locator: "키:OUTPUT_PAPER_TYPE.01", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/_foundation/HARNESS-DOMAIN-RULES-260701.md", source_locator: "문서:판형·판걸이수 규칙", captured_at: "2026-07-03", badge: verified, src_id: SR-4-domrules}
- props: {cod_nm: "국전계열", 규격: "316x467(전사표 SIZ_000499)", 적용: "디지털 전 상품 출력용지"}
- 본문: 디지털인쇄 출력용지 국전계열. 판형은 t_prd_product_plate_sizes로 상품에 연결되고 fn_best_plate가 자동선택한다. 016은 SIZ_000499(국전) 판형 보유(라이브 실측).


<!-- 스티커 공유 원자(consolidation 2026-07-03·병렬 product-local L-3 중복을 단일 소유권으로 이관·consolidate_sticker_axes.py) -->

### [plate-OUTPUT_PAPER_TYPE_02] 46계열 출력용지 (330x470 표준전지) {verified}
- type: plate_size
- anchor: t_cod_base_codes/OUTPUT_PAPER_TYPE.02
- src: {source_file: "live-snapshot/latest/t_cod_base_codes.csv", source_locator: "테이블:t_cod_base_codes 키:OUTPUT_PAPER_TYPE.02 (46계열)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_plate_sizes.csv", source_locator: "테이블:t_prd_product_plate_sizes 키:(PRD_000052,SIZ_000521) output_paper_typ_cd=OUTPUT_PAPER_TYPE.02·dflt_plt=Y·note:전지(46계열) 반칼 스티커 표준전지", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {output_paper_typ_cd: "OUTPUT_PAPER_TYPE.02", plate_siz_cd: "SIZ_000521(330x470)", note: "공유 axis/plate-sizes는 국전 OUTPUT_PAPER_TYPE_01만 등재 → 46계열은 needed_shared_node(반칼스티커 표준전지)"}
