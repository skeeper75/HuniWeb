<!-- product-local sub-nodes: E11 option_group for PRD_000161 판아크릴 (CL-1 M1). -->
<!-- ★공유/재사용(search-before-mint·L-3): formula-PRF_CLR_ACRYL·component-COMP_ACRYL_CLEAR3T·material-MAT_000043·process-PROC_000002·category-CAT_000155·size-SIZ_000359/SIZ_000361(sibling 빌더 product-160-acrylic-free-standing 정의·재-mint 금지). -->
<!-- ★여기 정의(161 전용): option_group OPT_000077(사이즈·items 0). 사이즈는 전부 재사용(신규 없음). -->

# product-161 판아크릴 하위 노드 (옵션그룹)

판아크릴 사이즈 옵션그룹. 사이즈 노드(120x120·120x180)는 병렬 아크릴 빌더
(product-160-acrylic-free-standing)가 정의하므로 재정의하지 않고 has_size로 참조만 한다.
상품→옵션그룹(has_option_group)은 [[product-161-plate-acrylic]]가 건다.

### [optgroup-161-size] 사이즈 (택1) {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000161
- src: {source_file: "01_curation/_cache/acryl-optgroups-260704.csv", source_locator: "행:(PRD_000161,OPT_000077) opt_grp_nm=사이즈·sel_typ_cd=SEL_TYPE.01·mand_yn=Y·items=0", captured_at: "live 2026-07-04", badge: verified, src_id: SR-ac-0704}
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "키:(PRD_000161,OPT_000077)(구조 존재·anchor)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {opt_grp_cd: "OPT_000077", sel_typ_cd: "SEL_TYPE.01", mand_yn: "Y", items: "0(★option_items 미적재·GAP-AC-4)", note: "사이즈 택1. option_items 0행이라 option_refs 미배선. 사이즈는 has_size(120x120/120x180·sibling 정의)로 표현·면적매트릭스 W×H 조회."}
- 본문: 손님이 사이즈를 고르는 CPQ 옵션(택1). ★라이브 option_items **0행**([GAP-AC-4]) — option_refs 미배선(가리킬 item 부재). 면적매트릭스(W×H) 조회.
