<!-- product-local sub-nodes: E3 size + E11 option_group for PRD_000162 아크릴포카스탠드 (CL-1 M1). -->
<!-- ★재사용(L-3): formula-PRF_CLR_ACRYL·component-COMP_ACRYL_CLEAR3T·material-MAT_000043·process-PROC_000002·category-CAT_000155. -->
<!-- ★여기 정의(162 전용): size SIZ_000364(68x103) + option_group OPT_000078(사이즈·items 0). -->

# product-162 아크릴포카스탠드 하위 노드 (사이즈·옵션그룹)

아크릴포카스탠드 규격 사이즈 + 사이즈 옵션그룹. 상품→축 연결은 [[product-162-acrylic-photocard-stand]]가 건다.

### [size-SIZ_000364] 68x103 {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000364
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "테이블:t_siz_sizes 키:SIZ_000364(siz_nm=68x103·work 68x103·cut 68x103·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_sizes.csv", source_locator: "키:(PRD_000162,SIZ_000364) dflt_yn=Y·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사 SIZ_000364(68x103·work=cut 68x103)", note: "면적매트릭스 입력 W×H=68×103(포카 스탠드 규격)"}
- 본문: 아크릴포카스탠드 규격 68x103. has_size 대상. 면적매트릭스 W×H 조회.

### [optgroup-162-size] 사이즈 (택1) {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000162
- src: {source_file: "01_curation/_cache/acryl-optgroups-260704.csv", source_locator: "행:(PRD_000162,OPT_000078) opt_grp_nm=사이즈·sel_typ_cd=SEL_TYPE.01·mand_yn=Y·items=0", captured_at: "live 2026-07-04", badge: verified, src_id: SR-ac-0704}
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "키:(PRD_000162,OPT_000078)(구조 존재·anchor)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {opt_grp_cd: "OPT_000078", sel_typ_cd: "SEL_TYPE.01", mand_yn: "Y", items: "0(★option_items 미적재·GAP-AC-4)", note: "사이즈 택1. option_items 0행이라 option_refs 미배선. 사이즈는 has_size(68x103)로 표현."}
- 본문: 손님이 사이즈를 고르는 CPQ 옵션(택1). ★라이브 option_items **0행**([GAP-AC-4]) — option_refs 미배선. 면적매트릭스(W×H) 조회.
