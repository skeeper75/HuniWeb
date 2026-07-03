<!-- product-local sub-nodes: E3 size + E11 option_group for PRD_000159 아크릴 코스터 (CL-1 M1·★미출시 use_yn=N). -->
<!-- ★재사용(L-3): formula-PRF_CLR_ACRYL·component-COMP_ACRYL_CLEAR3T·material-MAT_000043·category-CAT_000322/CAT_000328. -->
<!-- ★여기 정의(159 전용): size SIZ_000355(100x100원형)·SIZ_000356(100x100사각) + option_group OPT_000074(사이즈·items 0). -->
<!-- ★159=미출시(use_yn=N)·공정 0행(GAP-AC-2 UV 미배선). 추천 제외·팬텀 금지. -->

# product-159 아크릴 코스터 하위 노드 (사이즈·옵션그룹·미출시)

아크릴 코스터(★미출시) 규격 사이즈 2종 + 사이즈 옵션그룹. 상품→축 연결은
[[product-159-acrylic-coaster]]가 건다. 미출시라 추천 결과 제외(정직).

### [size-SIZ_000355] 100x100mm원형 {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000355
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "테이블:t_siz_sizes 키:SIZ_000355(siz_nm=100x100mm원형·work 100x100·cut 100x100·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_sizes.csv", source_locator: "키:(PRD_000159,SIZ_000355) dflt_yn=Y·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사 SIZ_000355(100x100mm원형·work=cut 100x100)", note: "면적매트릭스 입력 W×H=100×100(형상=원형 param·가격은 외접 W×H)"}
- 본문: 아크릴 코스터 규격 100x100 원형. has_size 대상(미출시 상품). 면적매트릭스 W×H 조회.

### [size-SIZ_000356] 100x100mm사각 {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000356
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "테이블:t_siz_sizes 키:SIZ_000356(siz_nm=100x100mm사각·work 100x100·cut 100x100·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_sizes.csv", source_locator: "키:(PRD_000159,SIZ_000356) dflt_yn=Y·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사 SIZ_000356(100x100mm사각·work=cut 100x100)", note: "면적매트릭스 입력 W×H=100×100(사각). 355 원형과 동일 치수·형상만 상이"}
- 본문: 아크릴 코스터 규격 100x100 사각. has_size 대상(미출시).

### [optgroup-159-size] 사이즈 (택1) {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000159
- src: {source_file: "01_curation/_cache/acryl-optgroups-260704.csv", source_locator: "행:(PRD_000159,OPT_000074) opt_grp_nm=사이즈·sel_typ_cd=SEL_TYPE.01·mand_yn=Y·items=0", captured_at: "live 2026-07-04", badge: verified, src_id: SR-ac-0704}
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "키:(PRD_000159,OPT_000074)(구조 존재·anchor)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {opt_grp_cd: "OPT_000074", sel_typ_cd: "SEL_TYPE.01", mand_yn: "Y", items: "0(★option_items 미적재·GAP-AC-4)", note: "사이즈 택1(미출시 상품). ★159 OPT_000074=사이즈이나 147 아크릴마그넷 OPT_000074(자석)와 코드 동일·상품별 의미 상이(라이브 verbatim). option_items 0행이라 option_refs 미배선."}
- 본문: 사이즈 택1 옵션(미출시). ★option_items **0행**([GAP-AC-4]) — option_refs 미배선. 사이즈는 has_size(원형/사각 100x100)로 표현·면적매트릭스 W×H 조회.
