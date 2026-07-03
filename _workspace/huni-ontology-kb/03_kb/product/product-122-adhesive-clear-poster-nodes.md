<!-- companion nodes for product-122 접착투명포스터 — 공유 축(axis/*·formula/*)에 없는 122 전용 마스터 노드. -->
<!-- ★공유 파일 수정 금지 규칙에 따라, axis/*·formula/*에 없는 것만 여기 신설(051/052 방식). -->
<!-- ★실사 첫 area-matrix 계열이라 면적매트릭스 공식(PRF_POSTER_ADH_CLEAR)·구성요소(COMP_POSTER_ADH_CLEAR_PVC)는 여기 mint→needed_shared_nodes로 반환(향후 면적 13상품 승격 후보). -->
<!-- ★수치(치수·단가셀수·범위·골든)는 전사 스크립트 transcribe_product_122.py 출력만(transcribed-by 마커). LLM 손전사 금지. -->

# product-122 전용 노드 (접착투명포스터 — 122 전용 마스터 축)

[[product-122-adhesive-clear-poster]]가 연결하는 축 중 **이미 노드가 실재하는 것은 재사용**하고 여기 중복
신설하지 않는다(L-3·중복 금지):

- **재사용(mint 안 함):** category-CAT_000004(포스터)·category-CAT_000314(아트포스터)·size-SIZ_000174(A3)·
  size-SIZ_000293(A1) = 병렬 실사 빌더(119/121/123/125)가 이미 mint한 공유 실사 노드 · size-SIZ_000197(A2) =
  공유 [[axis/sizes#size-SIZ_000197]] · **process-PROC_000008**(화이트인쇄) = [[product-020-white-print-postcard-nodes]]
  가 이미 mint. 이들은 통합 단계 shared axis 승격 후보(needed_shared_nodes)로 반환.
- **122 전용 mint(아래):** material-MAT_000180(투명PVC)·formula-PRF_POSTER_ADH_CLEAR·component-COMP_POSTER_ADH_CLEAR_PVC·
  optgroup-122-white·constraint-122-size-range·qty-122.

전사표는 상위 파일 [[product-122-adhesive-clear-poster]]의 "차원·BOM·연결 전사표"(권위·멱등)를 참조한다.

---

## 자재 (material) — 투명PVC (실사소재·122 전용 mint)

### [material-MAT_000180] 투명PVC (접착투명포스터 본체 자재) {verified}
- type: material
- anchor: t_mat_materials/MAT_000180
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "키:MAT_000180(투명PVC·mat_typ_cd=MAT_TYPE.08 실사소재·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_materials.csv", source_locator: "키:(PRD_000122,MAT_000180) usage_cd=USAGE.07·dflt_yn=Y", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "§3.5 자재(parent+usage_cd 단일 슬롯·투명PVC)·§1.1 MAT_TYPE 코드 개편(.08 실사소재 유지)", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-silsa}
- props: {mat_typ_cd: "MAT_TYPE.08", usage_cd: "USAGE.07", note: "★MAT_TYPE.08 실사소재는 현재값이자 정합(레더 .08→.05 교정 대상과 다름·투명PVC는 실사소재 유지·pack §1.1). parent+usage_cd 단일 슬롯(낱장 완제품). 공유 axis/materials 미등재·단일 소비자·승격 대기(needed_shared). IMPORT 자재 삭제 금지(RULE_import_material_no_delete)"}
- 본문: 접착투명포스터 본체 자재 = 투명PVC 단일(낱장 완제품·내지/표지 없음·pack §3.5). MAT_TYPE.08(실사소재)는 코드 개편 후 실사소재로 유지되는 현재값이라 권위 충돌 없음(레더 crosscut 교정 대상 아님). 공유 axis/materials 미민팅이라 여기 선언(승격 후보).

---

## 가격공식·구성요소 (★실사 첫 area-matrix 계열 — 상품-local mint·needed_shared_node)

> 실사 = 면적매트릭스형(포스터사인 [가로×세로] 셀단가·pack §3.10). 디지털 원자합산형(PRF_DGP_*)·스티커
> 고정가 룩업(PRF_STK_*)과 다른 아키타입이라 실사 전용 공식/구성요소를 여기 신설(면적 13상품 향후 승격 후보).

### [formula-PRF_POSTER_ADH_CLEAR] 접착투명포스터 완제품가 (면적매트릭스형) {verified}
- type: price_formula
- anchor: t_prc_price_formulas/PRF_POSTER_ADH_CLEAR
- src: {source_file: "live-snapshot/latest/t_prc_price_formulas.csv", source_locator: "키:PRF_POSTER_ADH_CLEAR(frm_nm 접착투명포스터 완제품가(면적/규격 단가)·use_yn=Y)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_price_formulas.csv", source_locator: "키:(PRD_000122,PRF_POSTER_ADH_CLEAR) apply_bgn_ymd 2026-06-01", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-dbmap/02_mapping/silsa-poster-area-matrix/mapping.md", source_locator: "§1.2 B05 접착투명122↔COMP_POSTER_ADH_CLEAR_PVC (면적매트릭스·승계·재검증 2026-07-03)", captured_at: "2026-07-03", badge: verified, src_id: SR-silsa-mapping}
- props: {frm_cd: "PRF_POSTER_ADH_CLEAR", archetype: "면적매트릭스형(area-matrix)", note: "★단일 구성요소 매트릭스 룩업(원자합산 아님)·완제품 통가격(도수/자재/코팅면/묶음/수량 무관·코팅포함). off-grid=가로·세로 각 한 단계 큰 규격 ceiling(앱 계산·값=evaluate_price·D-18). 실사 area-matrix 공식·formula/silsa-formulas 승격 후보(needed_shared·126 PRF_POSTER_LEATHER_AP 동류)"}
- rel: {rel: has_component, target: component-COMP_POSTER_ADH_CLEAR_PVC, qualifier: {addtn: "Y"}, note: "disp_seq 1·PRICE_TYPE.01·면적셀 룩업(t_prc_formula_components 배선)"}
- 본문: 접착투명포스터 가격공식. `t_prd_product_price_formulas`로 PRD_000122에 바인딩(apply_bgn 2026-06-01). 단일 구성요소 COMP_POSTER_ADH_CLEAR_PVC를 (가로×세로) 셀단가로 룩업해 완제품 통가격 산출(O6 충족·has_component ≥1). 원자합산형(여러 구성요소 addtn 합산)과 대비되는 매트릭스 아키타입.

### [component-COMP_POSTER_ADH_CLEAR_PVC] 실사 완제품가 (접착투명포스터·면적셀) {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_POSTER_ADH_CLEAR_PVC
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_POSTER_ADH_CLEAR_PVC(comp_nm 실사 완제품가(접착투명포스터)·prc_typ_cd PRICE_TYPE.01·comp_typ_cd PRC_COMPONENT_TYPE.06·use_dims [siz_width,siz_height]·use_yn=Y)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prc_component_prices.csv", source_locator: "COMP_POSTER_ADH_CLEAR_PVC 단가행 52셀(siz_width×siz_height long-form·range 16000~198000·master note 골든 600×1800=59,400) — 상위 전사표 요약(D-22 접기)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {comp_cd: "COMP_POSTER_ADH_CLEAR_PVC", prc_typ_cd: "PRICE_TYPE.01", comp_typ_cd: "PRC_COMPONENT_TYPE.06", use_dims_ref: "[siz_width, siz_height]", cells_ref: "상위 전사표 52셀(값 나열 아님·D-22)", note: "★면적매트릭스 단가행은 (가로,세로) 순서쌍 52개=고유 셀(매트릭스 비대칭 가능). 값 전건은 접기(count/range/골든만)·계산은 evaluate_price(가격 경계 D-18). 아크릴/126 레더 면적매트릭스와 동형. formula/silsa-components 승격 후보(needed_shared)"}
- 본문: 접착투명포스터 완제품가 구성요소. use_dims=[siz_width, siz_height]로 손님이 고른 가로·세로가 가격을 결정한다(코팅포함 통가격·도수/자재/수량 무관). off-grid 치수는 가로·세로 각 한 단계 큰 규격으로 ceiling(앱·pack §3.10). 단가 값은 KB 밖(evaluate_price)·라이브 골든 600×1800=59,400원(master note 실측). <!-- lint-allow: L-12 src=SR-5-livesnap(master note 골든 단일 스칼라) -->

---

## 옵션그룹 (CPQ) — 화이트별색 1그룹 (택1·mand N·option_refs 청정 배선)

> 옵션 = 자재/공정 BUNDLE(pack §3.9). 옵션참조(ref_dim_cd)는 같은 부모 prd_cd 차원에 실재 필수
> (`fn_chk_opt_item_ref` 트리거·L-18). 화이트인쇄 PROC_000008이 노드 실재(020 mint)+부모 has_process 배선 → 청정 배선.

### [optgroup-122-white] 화이트별색 (화이트 underbase·택1·선택) {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000122
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "키:(PRD_000122,OPT_000008) opt_grp_nm=화이트별색·sel_typ=SEL_TYPE.01·min/max=0/1·mand_yn=N·note:화이트 underbase 별색 선택", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_option_items.csv", source_locator: "그룹 OPT_000008 옵션값 1(OPV_000024 단면)·OPT_REF_DIM.04(process) ref_key1=PROC_000008·qty 1", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {opt_grp_cd: "OPT_000008", sel_typ_cd: "SEL_TYPE.01", mand: "N", items: "단면(OPV_000024→OPT_REF_DIM.04 ref_key1=PROC_000008)", note: "화이트 underbase 별색 택1(손님 선택·mand=N). 옵션참조는 부모 122 has_process(PROC_000008)에 실재→L-18 정합(fn_chk_opt_item_ref)"}
- rel: {rel: option_refs, target: process-PROC_000008, ref_key1: "PROC_000008", note: "단면(OPV_000024·OPT_REF_DIM.04 process 참조·부모 has_process 실재)"}
- 본문: 투명 소재 밑판 화이트 underbase 선택 그룹(택1·mand=N). 옵션값 "단면"(OPV_000024)이 OPT_REF_DIM.04로 PROC_000008(화이트인쇄)을 가리킨다. PROC_000008이 노드 실재(020 mint)이고 부모 122 has_process에도 배선돼 있어 `option_refs`를 청정 배선한다(L-18 정합). ★화이트별색이 가격에 별도 기여하는지는 단일 매트릭스 comp(코팅포함 통가격)에 흡수되는지 별도 가산인지 엔진 소관(값 판정=evaluate_price·D-18 경계) — 손님 선택 축으로만 표현.

---

## 제약규칙 (constraint) — 사용자입력 치수 범위 (122 전용)

### [constraint-122-size-range] 사용자입력 치수 범위 (nonspec 가로 200~1200·세로 200~3000) {verified}
- type: constraint
- anchor: t_prd_product_constraints/PRD_000122
- src: {source_file: "live-snapshot/latest/t_prd_product_constraints.csv", source_locator: "키:(PRD_000122,RULE_001) rule_nm=사용자입력 치수 범위·rule_typ_cd=RULE_TYPE.01·use_yn=Y·err_msg=가로 200~1200mm, 세로 200~3000mm 범위로 입력하세요", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "§3.9 constraints 신규 발현(122 1행)·§1.1 T-3(위키 0행 STALE)", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-silsa}
- props: {rule_cd: "RULE_001", cn_type: "CN-5(범위증분)", logic_ref: "상위 전사표 RULE_001 logic(size_mode≠nonspec OR (width 200~1200 AND height 200~3000))", note: "nonspec(자유 치수) 모드에서만 가로 200~1200mm·세로 200~3000mm 강제. 이산 규격 A3/A2/A1 선택 시 통과(size_mode≠nonspec). 폼빌더 정형 shape(§31·CN-5). 위키 constraints 0행(T-3)은 STALE"}
- rel: {rel: constrains, target: product-122-adhesive-clear-poster, note: "접착투명포스터 nonspec 치수 입력 범위 강제(RULE_001·use_yn=Y)"}
- 본문: 사용자입력(nonspec) 치수의 유효 범위를 강제하는 제약규칙(CN-5 범위증분류·§31). JSONLogic이 size_mode가 nonspec일 때만 가로·세로 범위를 검사한다(이산 규격 선택 시 무조건 통과). 실사 7상품(118/120/121/122/124/125/139) 신규 발현 constraints 중 하나(pack §1.1). evaluate_price는 제약 미참조 — 위젯/주문이 validate 호출해야 강제(constraint-builder 계약).

---

## 수량규칙 (bundle_qty) — 상품 레벨

### [qty-122] 접착투명포스터 수량규칙 {verified}
- type: bundle_qty
- anchor: t_prd_products/PRD_000122
- src: {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000122 min_qty/max_qty/qty_incr(1/1000/1·QTY_UNIT.01)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/_foundation/batch/qty_rule_audit_260702.py", source_locator: "수량 UI 권위=상품/사이즈 규칙(가격구간과 역할 분리)", captured_at: "2026-07-03", badge: verified, src_id: SR-27-qtyaudit}
- props: {min_max_incr_ref: "상위 전사표(상품 1/1000/1)", bdl_unit_typ_cd: "QTY_UNIT.01", bundle_qtys_rows: 0}
- 본문: 수량 그릇 = 상품 마스터 컬럼(min 1·max 1000·incr 1·단위 QTY_UNIT.01). `t_prd_product_bundle_qtys` 0행은 정상(면적매트릭스는 수량축 없음·완제품 통가격·pack §3.4). 수량 UI 권위=상품/사이즈 규칙(가격구간과 역할 분리·[[rule/decisions#DEC_qty_audit_260702]]).
