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

## 셋트 내지 판형 (국4절) — Stage C1(okb-knowledge-builder 260703)

<!-- 엽서북/떡메모지(095/096/098) 내지·표지 판형=국4절 316x467. output_paper_typ_cd 공란(OUTPUT_PAPER_TYPE 미배정) → -->
<!-- 기존 plate-OUTPUT_PAPER_TYPE_01/02/03 중 어느 것도 아님(신규 축 노드 필요). SIZ_000499(316x467) 출력용지. -->
<!-- 앵커=정션(t_prd_product_plate_sizes/PRD_000095·L-20 제외·복합키 대신 prd_cd 대표키). 소비 095/096/098 공유. -->
<!-- has_plate_size(product→plate·R6)는 상품 노드(Stage B/C2)가 종이류에만 배선. plate-OUTPUT_PAPER_TYPE_03(3절·112)은 product-030에 이미 존재=재사용. -->

### [plate-SIZ_000499-gukc4] 국4절 (316x467·엽서북/떡메모지 내지) {verified}
- type: plate_size
- anchor: t_prd_product_plate_sizes/PRD_000095
- src: {source_file: "live-snapshot/latest/t_prd_product_plate_sizes.csv", source_locator: "테이블:t_prd_product_plate_sizes 키:(PRD_000095,SIZ_000499)·(PRD_000098,SIZ_000499) dflt_plt_yn=Y·output_paper_typ_cd 공란·note '엽서북/떡메모지 내지 판형 국4절 등록(260701 교정)'·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "키:SIZ_000499(316x467·국전 출력용지·치수 원천)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {plate_siz_cd: "SIZ_000499", output_paper_typ_cd: "(공란·OUTPUT_PAPER_TYPE 미배정)", 규격: "316x467(t_siz_sizes SIZ_000499 치수)", 소비상품: "095/096/098 엽서북·떡메모지 내지/표지", note: "★output_paper_typ_cd 공란이라 기존 plate-OUTPUT_PAPER_TYPE_01/02/03 어느 것도 아님(신규 축). 260701 판형 교정으로 등록. 라벨 '국4절' vs SIZ_000499 '국전 출력용지' 명칭 상이 관찰(원천 표기 그대로·단정 금지). 종이류 판형(fn_best_plate 자동선택)·이 판형이 316x467 표현을 단독 담당(size 노드 미민팅·C-3)"}
- 본문: 엽서북(095/096)·떡메모지(098) 내지/표지의 국4절(316x467) 출력용지 판형. output_paper_typ_cd가 공란이라 기존 3판형 노드(01 국전·02 46계열·03 3절)와 별개의 신규 축이다. 판형은 고객이 안 고르고 fn_best_plate가 자동선택([[rule/rules#RULE_pansu_db_function]]). has_plate_size는 상품/구성원 노드(Stage C2)가 배선한다.

## 문구 셋트(SB-1) 표지파일사양 판형 — Stage C1(okb-knowledge-builder 260703)

<!-- 문구 셋트 표지 부모(소프트커버172/하드커버173/메모패드179/정철노트181)의 표지파일사양 판형. -->
<!-- output_paper_typ_cd 공란(OUTPUT_PAPER_TYPE 미배정) → 기존 plate-OUTPUT_PAPER_TYPE_01/02/03·SIZ_000499-gukc4 어느 것도 아님(신규 축·note='표지파일사양'). -->
<!-- 앵커=정션(t_prd_product_plate_sizes/PRD_XXX·L-20 제외·복합키 대신 prd_cd 대표키). SIZ는 props/src. -->
<!-- has_plate_size(product→plate·R6)는 상품 노드(Stage C2)가 배선. SIZ_000007 size 노드는 이미 존재(재사용)·plate만 신규. -->

### [plate-SIZ_000251] 표지파일사양 300x214 (172 소프트커버 부모) {verified}
- type: plate_size
- anchor: t_prd_product_plate_sizes/PRD_000172
- src: {source_file: "live-snapshot/latest/t_prd_product_plate_sizes.csv", source_locator: "키:(PRD_000172,SIZ_000251) dflt_plt_yn=Y·output_paper_typ_cd 공란·note '표지파일사양'·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "키:SIZ_000251(300x214·work 300.00x214.00·치수 원천)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {plate_siz_cd: "SIZ_000251", output_paper_typ_cd: "(공란)", 규격: "300x214(t_siz_sizes SIZ_000251)", 소비상품: "172 소프트커버 만년다이어리 표지", note: "★output_paper_typ_cd 공란=신규 축(기존 판형 노드 아님). note '표지파일사양'. 판형은 고객 미선택(fn_best_plate 자동)·has_plate_size는 상품 노드(Stage C2)가 배선"}

### [plate-SIZ_000181] 표지파일사양 426x303 (173 하드커버 부모) {verified}
- type: plate_size
- anchor: t_prd_product_plate_sizes/PRD_000173
- src: {source_file: "live-snapshot/latest/t_prd_product_plate_sizes.csv", source_locator: "키:(PRD_000173,SIZ_000181) dflt_plt_yn=Y·output_paper_typ_cd 공란·note '표지파일사양'·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "키:SIZ_000181(426x303·work 426.00x303.00·치수 원천)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {plate_siz_cd: "SIZ_000181", output_paper_typ_cd: "(공란)", 규격: "426x303(t_siz_sizes SIZ_000181)", 소비상품: "173 하드커버 만년다이어리 표지", note: "★output_paper_typ_cd 공란=신규 축. note '표지파일사양'. has_plate_size는 상품 노드(Stage C2)가 배선"}

### [plate-SIZ_000007] 표지파일사양 148x210 (179 메모패드 부모) {verified}
- type: plate_size
- anchor: t_prd_product_plate_sizes/PRD_000179
- src: {source_file: "live-snapshot/latest/t_prd_product_plate_sizes.csv", source_locator: "키:(PRD_000179,SIZ_000007) dflt_plt_yn=Y·output_paper_typ_cd 공란·note '표지파일사양'·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "키:SIZ_000007(148x210·work 150.00x212.00·cut 148.00x210.00·치수 원천)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {plate_siz_cd: "SIZ_000007", output_paper_typ_cd: "(공란)", 규격: "148x210(t_siz_sizes SIZ_000007)", 소비상품: "179 메모패드 표지", note: "★size-SIZ_000007(148x210 엽서) size 노드는 이미 존재=재사용. 이건 plate(표지파일사양) 신규 축. PRD_000179는 SIZ_000007·SIZ_000381 두 판형 보유(정션 앵커=L-20 제외). has_plate_size는 상품 노드(Stage C2)가 배선"}

### [plate-SIZ_000381] 표지파일사양 186x261 (179 메모패드 부모) {verified}
- type: plate_size
- anchor: t_prd_product_plate_sizes/PRD_000179
- src: {source_file: "live-snapshot/latest/t_prd_product_plate_sizes.csv", source_locator: "키:(PRD_000179,SIZ_000381) dflt_plt_yn=Y·output_paper_typ_cd 공란·note '표지파일사양'·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "키:SIZ_000381(186x261·work 186.00x261.00·치수 원천)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {plate_siz_cd: "SIZ_000381", output_paper_typ_cd: "(공란)", 규격: "186x261(t_siz_sizes SIZ_000381)", 소비상품: "179 메모패드 표지", note: "★output_paper_typ_cd 공란=신규 축. 앵커 PRD_000179는 plate-SIZ_000007과 공유(정션·L-20 제외). has_plate_size는 상품 노드(Stage C2)가 배선"}

### [plate-SIZ_000382] 표지파일사양 216x154 (181 정철노트 부모) {verified}
- type: plate_size
- anchor: t_prd_product_plate_sizes/PRD_000181
- src: {source_file: "live-snapshot/latest/t_prd_product_plate_sizes.csv", source_locator: "키:(PRD_000181,SIZ_000382) dflt_plt_yn=Y·output_paper_typ_cd 공란·note '표지파일사양'·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "키:SIZ_000382(216x154·work 216.00x154.00·치수 원천)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {plate_siz_cd: "SIZ_000382", output_paper_typ_cd: "(공란)", 규격: "216x154(t_siz_sizes SIZ_000382)", 소비상품: "181 정철노트 표지", note: "★output_paper_typ_cd 공란=신규 축. note '표지파일사양'. has_plate_size는 상품 노드(Stage C2)가 배선"}
