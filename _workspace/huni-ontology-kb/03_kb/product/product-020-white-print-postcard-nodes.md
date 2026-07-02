<!-- product-scoped supplement: PRD_000020(화이트인쇄엽서)이 도입하는 신규 축 항목 + CPQ 옵션그룹 + GAP. -->
<!-- ★공유 axis/*·index.md 수정 금지 제약 하에, 020이 새로 쓰는 축 멤버(자재 362~365·공정 008/009)를 -->
<!--    이 상품 전용 하위 노드로 선언한다(중복 아님 — 공유 axis에 미등재). 공유 축 승격 제안은 needed_shared_nodes로 반환. -->
<!-- ★수치·연결은 _meta/scripts/transcribe_product_020.py 전사(transcribed-by 마커)에서 옮긴 것·LLM 손전사 금지(D-9). -->

# product-020-white-print-postcard 축 보강 (PRD_000020 전용 신규 축 멤버 · CPQ · GAP)

020이 도입하는, 공유 축 노드(axis/)에 아직 없는 항목만 여기 선언한다. 이미 있는 축(사이즈
SIZ_000002/003/004/007·단면/양면 POPT·국전 판형·카테고리 CAT_000307·공식 PRF_DGP_A·구성요소 전량)은
재사용(중복 생성 금지)하고, 상품 노드가 그리로 연결한다. 신규 = **화이트인쇄 색지 4종·별색 공정 2종**
(둘 다 040 화이트인쇄명함과 공유 후보 → 공유 축 승격은 needed_shared_nodes로 반환).

## 신규 자재 (E4 material) — 화이트인쇄 색지 4색 (전부 USAGE.07 공통 슬롯)

> ★화이트인쇄 자재 = **어두운/유색 색지만**(흰 종이에 흰 토너=대비 0 무효). 큐리어스스킨 5색 중 화이트(MAT_000361)는
> 무효라 020 BOM에 부재(이미 교정·040 동형 선례·MEMORY whiteprint-material-4color-unified-spot-component-260630).
> 4 자재는 공유 [[axis/materials]] 미등재라 product-local 민팅(041 방식) — 공유 축 승격 제안=needed_shared_nodes.

### [material-MAT_000362] 큐리어스스킨 레드 270g {verified}
- type: material
- anchor: t_mat_materials/MAT_000362
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "테이블:t_mat_materials 키:MAT_000362", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.01", 사양_ref: "전사표 자재 BOM(product-020 본문)", 사용: "020 화이트인쇄엽서 색지(USAGE.07)·040 공유 후보"}

### [material-MAT_000363] 큐리어스스킨 다크블루 270g {verified}
- type: material
- anchor: t_mat_materials/MAT_000363
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "테이블:t_mat_materials 키:MAT_000363", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.01", 사양_ref: "전사표 자재 BOM", 사용: "020 색지(USAGE.07)·040 공유 후보"}

### [material-MAT_000364] 큐리어스스킨 바이올렛 270g {verified}
- type: material
- anchor: t_mat_materials/MAT_000364
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "테이블:t_mat_materials 키:MAT_000364", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.01", 사양_ref: "전사표 자재 BOM", 사용: "020 색지(USAGE.07)·040 공유 후보"}

### [material-MAT_000365] 큐리어스스킨 블랙 270g {verified}
- type: material
- anchor: t_mat_materials/MAT_000365
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "테이블:t_mat_materials 키:MAT_000365", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.01", 사양_ref: "전사표 자재 BOM", 사용: "020 색지(USAGE.07)·040 공유 후보"}

## 신규 공정 (E6 process) — 별색 인쇄 2종 (도수 아님·공정)

> ★별색(spot)=공정이지 도수 아님([[_glossary#TERM_spot_color]]·팩 §3.3·clr_cd=NULL). 공유 [[axis/processes]]에는
> 별색 상위(PROC_000007)만 등재됐고, 화이트/클리어 별색 인쇄(008/009)는 미등재 → product-local 민팅.
> 가격은 통합 별색 구성요소 [[formula/digital-components#component-COMP_PRINT_SPOT_WHITE_S1]]가 proc_cd 8/9 단가행으로 커버.

### [process-PROC_000008] 화이트인쇄 (별색) {verified}
- type: process
- anchor: t_proc_processes/PROC_000008
- src: {source_file: "live-snapshot/latest/t_proc_processes.csv", source_locator: "테이블:t_proc_processes 키:PROC_000008", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "MEMORY/whiteprint-material-4color-unified-spot-component-260630.md", source_locator: "§2 통합별색 component가 proc_cd 8(화이트) 단가행 보유", captured_at: "2026-07-03", badge: candidate, src_id: SR-mem-whiteprint}
- props: {proc_nm: "화이트인쇄", role: "불투명 흰 토너 별색(색지 위)·020 mand_proc_yn=Y·인쇄비 원천", 공유: "040 화이트인쇄명함 후보"}

### [process-PROC_000009] 클리어인쇄 (별색) {verified}
- type: process
- anchor: t_proc_processes/PROC_000009
- src: {source_file: "live-snapshot/latest/t_proc_processes.csv", source_locator: "테이블:t_proc_processes 키:PROC_000009", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "MEMORY/whiteprint-material-4color-unified-spot-component-260630.md", source_locator: "§2 통합별색 component가 proc_cd 9(클리어) 단가행 보유·이미 과금(별도배선 금지)", captured_at: "2026-07-03", badge: candidate, src_id: SR-mem-whiteprint}
- props: {proc_nm: "클리어인쇄", role: "투명 코팅 토너 별색·020 옵션(mand N)·통합 별색 component가 이미 커버(이중과금 금지)", 공유: "040 후보"}

## 수량규칙 (E8 bundle_qty)

### [qty-020] 화이트인쇄엽서 수량규칙 {verified}
- type: bundle_qty
- anchor: t_prd_products/PRD_000020
- src: {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "키:PRD_000020 min_qty/max_qty/qty_incr", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/_foundation/batch/qty_rule_audit_260702.py", source_locator: "수량 UI 권위=상품/사이즈 규칙(가격구간과 역할 분리)", captured_at: "2026-07-03", badge: verified, src_id: SR-27-qtyaudit}
- props: {min_max_incr_ref: "전사표 수량규칙(상품 12/10000/12)", bdl_unit_typ_cd: "QTY_UNIT.02", bundle_qtys_rows: 0}
- 본문: 수량 그릇 = 상품 마스터 컬럼(min 12·max 10000·incr 12). t_prd_product_bundle_qtys 0행은 정상(수량 UI 권위=상품/사이즈·[[rule/decisions#DEC_qty_audit_260702]]). min/incr 12는 016(15)과 다른 이 상품 고유값.

## CPQ 옵션그룹 (E11 option_group)

> 앵커 규약(junction-키·016/041 방식 통일·V1-03): `t_prd_product_option_groups`는 junction(col0=prd_cd)이라 빌더 L-17
> 닫힌세계 검사는 **부모 prd_cd(PRD_000020)** 실재까지 검증한다. 복합키 `opt_grp_cd`(OPT-000025 등)는 L-17 범위 밖이라
> sources 전사로 확증(각 옵션그룹 src의 `키:(PRD_000020,OPT-0000xx)`). option_refs 타깃은 부모 020 차원에 실재(L-18 fn_chk_opt_item_ref 정합).

### [optgroup-020-white] 화이트인쇄(별색·단/양면) 택1 필수 {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000020
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "테이블:t_prd_product_option_groups 키:(PRD_000020,OPT-000025)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_option_items.csv", source_locator: "키:(PRD_000020,OPV-000046 화이트인쇄단면·OPV-000047 화이트인쇄양면) ref_dim OPT_REF_DIM.04 ref_key1 PROC_000008", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: option_refs, target: process-PROC_000008, qualifier: {ref_dim_cd: "OPT_REF_DIM.04", ref_key1: "PROC_000008"}, note: "화이트인쇄 단면(OPV-000046)·양면(OPV-000047) 둘 다 PROC_000008 참조"}
- props: {opt_grp_cd: "OPT-000025", opt_grp_nm: "화이트인쇄", sel_typ_cd: "SEL_TYPE.01(택1)", mand_yn: Y, disp_seq: 1, ref_dim: "OPT_REF_DIM.04=proc_cd", items: "OPV-000046 단면·OPV-000047 양면(단/양면 구분은 print_opt 매칭·둘 다 화이트 공정)"}
- 본문: 화이트인쇄 택1 필수(별색 mand 공정 PROC_000008 참조). 단면/양면 두 item이 같은 공정을 가리키고 print_side는 has_print_option(POPT_000001/002)과 매칭. 별색=공정([[_glossary#TERM_spot_color]]·도수 아님).

### [optgroup-020-paper] 종이(색지) 택1 필수 {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000020
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "테이블:t_prd_product_option_groups 키:(PRD_000020,OPT-000026)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_options.csv", source_locator: "키:(PRD_000020,OPT-000026) opts=OPV-000048~051(큐리어스스킨 블랙/레드/다크블루/바이올렛)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: option_refs, target: material-MAT_000362, note: "큐리어스스킨 레드(OPV-000049)"}
- rel: {rel: option_refs, target: material-MAT_000363, note: "큐리어스스킨 다크블루(OPV-000050)"}
- rel: {rel: option_refs, target: material-MAT_000364, note: "큐리어스스킨 바이올렛(OPV-000051)"}
- rel: {rel: option_refs, target: material-MAT_000365, note: "큐리어스스킨 블랙(OPV-000048)"}
- props: {opt_grp_cd: "OPT-000026", opt_grp_nm: "종이", sel_typ_cd: "SEL_TYPE.01(택1)", mand_yn: Y, disp_seq: 2, ref_note: "★option_items(ref_dim/ref_key) 행 부재 — 옵션명↔product_materials로 매칭·[[gap-020-paper-optitem-ref]]"}
- 본문: 종이(색지) 택1 필수. 4 색지 옵션참조(전부 USAGE.07·상품 uses_material 실재로 L-18 정합). 단 이 그룹은 화이트/클리어인쇄 그룹과 달리 `t_prd_product_option_items`에 ref_dim/ref_key 행이 없다(옵션명이 자재명과 1:1이나 CPQ ref 레이어 미구성) → [[gap-020-paper-optitem-ref]].

### [optgroup-020-clear] 클리어인쇄(별색·옵션) 택1 {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000020
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "테이블:t_prd_product_option_groups 키:(PRD_000020,OPT-000027)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_option_items.csv", source_locator: "키:(PRD_000020,OPV-000053 클리어단면·OPV-000054 클리어양면) ref_dim OPT_REF_DIM.04 ref_key1 PROC_000009 (+OPV-000052 없음=off항목·ref 없음)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: option_refs, target: process-PROC_000009, qualifier: {ref_dim_cd: "OPT_REF_DIM.04", ref_key1: "PROC_000009"}, note: "클리어인쇄 단면(OPV-000053)·양면(OPV-000054) 참조·없음(OPV-000052)=off"}
- props: {opt_grp_cd: "OPT-000027", opt_grp_nm: "클리어인쇄", sel_typ_cd: "SEL_TYPE.01(택1)", mand_yn: N, disp_seq: 3, ref_dim: "OPT_REF_DIM.04=proc_cd", items: "OPV-000052 없음·OPV-000053 단면·OPV-000054 양면"}
- 본문: 클리어인쇄 택1 옵션(없음/단면/양면). 선택 시 PROC_000009 별색 공정 참조. ★가격은 통합 별색 component가 proc_cd 9로 이미 커버 — 별도 클리어 구성요소 배선 금지(이중과금·MEMORY whiteprint §2).

## GAP (원천 부재·미확정)

### [gap-020-addon-target] 봉투 addon 대상 상품·템플릿 노드 미민팅 {unknown}
- type: gap
- anchor: none  # 사유: 봉투 addon 5행은 live 실재하나 대상 봉투 상품/템플릿 노드가 KB 미민팅으로 has_addon(product→product) 배선 불가
- src: {source_file: "live-snapshot/latest/t_prd_product_addons.csv", source_locator: "prd_cd:PRD_000020 (TMPL-000005/006/038/039/009→base_prd PRD_000001/002/004/283)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- gap_what: "020 봉투 addon 5행(TMPL-000005/006/038/039/009·016과 동일 봉투 세트) 확정이나 대상 봉투 상품(PRD_000001/002/004/283)·template 노드가 KB 미민팅 → has_addon 엣지 미배선"
- gap_fill_from: "봉투 상품 노드 집필 또는 template 노드 승격(스키마 §1.1 R14·파일럿 후 인간 승인). 016 gap-016-addon-target과 동일 대상 — 봉투 상품군 집필 시 일괄 해소"
- gap_owner: 설계
- rel: {rel: references, target: gap-016-addon-target, note: "동일 봉투 addon 대상 노드 부재(016과 공유 — 봉투 상품군 집필 시 일괄 해소)"}
- 본문: 봉투 5행은 실재·확정(전사표 권위). 대상 노드 부재로 엣지만 대기(016과 동일 봉투 세트 4상품 PRD_000001/002/004/283).

### [gap-020-paper-optitem-ref] 종이(색지) 옵션 CPQ ref 레이어 부재 {unknown}
- type: gap
- anchor: none  # 사유: 종이 옵션그룹에 option_items(ref_dim/ref_key) 행이 라이브에 없음 — 자재 참조가 CPQ 계약으로 미형식화
- src: {source_file: "live-snapshot/latest/t_prd_product_option_items.csv", source_locator: "prd_cd:PRD_000020 OPT-000026(종이) 소속 opt_cd(OPV-000048~051)에 대응 option_items 행 0건(화이트/클리어 그룹은 OPT_REF_DIM.04 행 보유)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- gap_what: "020 종이(색지) 옵션그룹의 자재 참조가 t_prd_product_option_items(ref_dim_cd=OPT_REF_DIM.03/ref_key=mat_cd) 행으로 형식화되지 않음 — 옵션명이 자재명과 1:1이나 fn_chk_opt_item_ref 검증 대상 ref 레이어 부재(041 종이그룹은 OPT_REF_DIM.03 행 보유와 대조)"
- gap_fill_from: "실무진/설계 — 종이 옵션에 OPT_REF_DIM.03(mat_cd+usage_cd) option_items 행 보강(041 패턴). 여러 화이트인쇄 상품 공통일 수 있어 040과 함께 확인(open_question)"
- gap_owner: 설계
- rel: {rel: references, target: optgroup-020-paper, note: "이 옵션그룹의 CPQ ref 레이어 공백"}
- 본문: 종이 옵션은 화면 선택은 되나 CPQ ref_dim 레이어가 없어 옵션→자재 매핑이 이름 기반(비형식). uses_material·option_refs 그래프 배선은 정상(자재 실재)이나 라이브 CPQ 계약이 화이트/클리어 그룹만큼 형식화 안 됨(정직 선언).
