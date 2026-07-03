<!-- product-local sub-nodes: E11 option_group for PRD_000157 아크릴네임택 (CL-1 M1). -->
<!-- ★공유/재사용(L-3): formula-PRF_CLR_ACRYL·component-COMP_ACRYL_CLEAR3T·material-MAT_000043·process-PROC_000002·category-CAT_000322/CAT_000181·size-SIZ_000148(product-150-nodes)·size-SIZ_000012(product-024-photocard). -->
<!-- ★여기 정의(157 전용): option_group OPT_000075(사이즈·items 0). 사이즈 노드는 전부 재사용(신규 없음). -->

# product-157 아크릴네임택 하위 노드 (옵션그룹)

아크릴네임택 사이즈 옵션그룹. 사이즈 노드(60x60·55x86)는 공유 재사용. 상품→옵션그룹
(has_option_group)은 [[product-157-acrylic-nametag-photocard]]가 건다.

### [optgroup-157-size] 사이즈 (택1) {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000157
- src: {source_file: "01_curation/_cache/acryl-optgroups-260704.csv", source_locator: "행:(PRD_000157,OPT_000075) opt_grp_nm=사이즈·sel_typ_cd=SEL_TYPE.01·mand_yn=Y·items=0", captured_at: "live 2026-07-04", badge: verified, src_id: SR-ac-0704}
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "키:(PRD_000157,OPT_000075)(구조 존재·anchor)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {opt_grp_cd: "OPT_000075", sel_typ_cd: "SEL_TYPE.01", mand_yn: "Y", items: "0(★option_items 미적재·GAP-AC-4)", note: "사이즈 택1 옵션그룹. option_items 0행이라 option_refs 미배선(가리킬 item 부재). 사이즈 선택은 has_size(60x60/55x86)로 이미 표현·면적매트릭스 W×H 조회."}
- 본문: 손님이 사이즈를 고르는 CPQ 옵션(택1). ★라이브 option_items **0행**([GAP-AC-4]) — 그룹만 있고 값(item)이 미적재라 option_refs 엣지를 걸지 않는다(환각 차단). 사이즈 차원은 has_size(SIZ_000148/SIZ_000012)로 표현되고 면적매트릭스(W×H)로 가격 조회.
