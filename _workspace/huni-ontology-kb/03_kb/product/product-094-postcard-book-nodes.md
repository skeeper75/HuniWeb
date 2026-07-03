<!-- 클러스터-로컬 하위 노드: 엽서북(094) 전용 수량규칙·옵션그룹. Stage B set-cluster(094+097) 260703. -->
<!-- 공유 축(size/material/process/formula)은 참조만·미민팅분은 needs_axis 반환. -->

# 엽서북(094) 전용 하위 노드 (qty·option_group)

### [qty-094] 엽서북 수량규칙 {verified}
- type: bundle_qty
- anchor: t_prd_products/PRD_000094
- src: {source_file: "RAILWAY_DB live (railway·읽기전용 SELECT)", source_locator: "테이블:t_prd_products 키:PRD_000094 min_qty/max_qty/qty_incr + t_prd_product_page_rules 키:PRD_000094", captured_at: "live 2026-07-03", badge: verified, src_id: SR-5-livesnap}
- props: {min_max_incr_ref: "전사표 수량규칙(상품 2/10000/1)", bdl_unit_typ_cd: "QTY_UNIT.03", page_rule: "20/30/+10", bundle_qtys_rows: 0}
- 본문: 엽서북 수량 그릇 = 상품 마스터 컬럼(min 2·max 10000·incr 1) + page_rule(20~30P/+10). t_prd_product_bundle_qtys 0행(수량 UI 권위=상품/페이지 규칙). 07-02 수량 진단 min 1→2 교정([[qty-system-audit-260702]]).

### [optgroup-094-pages] 페이지수(20P/30P 택1) {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000094
- src: {source_file: "RAILWAY_DB live (railway·읽기전용 SELECT)", source_locator: "테이블:t_prd_product_option_groups 키:(PRD_000094,OPT_000082) sel_typ=SEL_TYPE.01 mand=Y + t_prd_product_options OPV_000491(20P dflt)/OPV_000492(30P)", captured_at: "live 2026-07-03", badge: verified, src_id: SR-5-livesnap}
- props: {opt_grp_cd: "OPT_000082", opt_grp_nm: "페이지수", sel_typ_cd: "SEL_TYPE.01", mand_yn: "Y", 값: "20P(OPV_000491·dflt)·30P(OPV_000492)", 배선: "§27 260701·30p 견적 활성화·opt_cd 판별 선택수단"}
- 본문: 엽서북 페이지수 택1 필수 그룹(20P/30P). page 선택이 body 매칭(20P→COMP_PCB_S1_20P/S2_20P·30P→_30P)으로 고정가 부모공식에 전달. option_refs 없음(페이지수는 size/material/process/print_option 차원 아님·page_rule 축 참조 → L-18 미해당). 현재 094 활성 옵션그룹 = 이 1개(사이즈/내지종이/표지 등 나머지 그룹은 07-02 menu-first 롤백으로 은퇴).
