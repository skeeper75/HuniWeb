<!-- product-local sub-nodes: E3 size·E4 material·E11 option_group·gap for PRD_000226 아크릴쉐이커코롯토(미출시·§23 재바인딩). -->
<!-- ★공유 노드 재사용(L-3): formula-PRF_GOODS_FIXED_SIZ·component-COMP_GOODS_FIXED_SIZ=product-240(굿즈 공유). category-CAT_000009/159=axis/categories.md. -->
<!-- ★여기 정의(226 로컬·타 빌더 미정의): size SIZ_000611/612/613(인쇄면)·material MAT_000310/312/314/315(글리터)·optgroup 2(인쇄면/글리터). ※구 gap-226-acryl-tbd는 D-AC-P1(07-04 재-SELECT false-gap 정정)로 제거 — 자기 siz 3행 단가 실재. -->
<!-- ★수치 siz_nm/mat_nm verbatim(live 07-04 SELECT). 가격 값 미전사(D-18). 미출시(추천 제외). -->

# product-226 하위 노드 (아크릴쉐이커코롯토 전용 축)

아크릴쉐이커코롯토(PRD_000226·미출시)의 인쇄면 사이즈 3·글리터 자재 4·옵션그룹 2(인쇄면/글리터)·로컬 gap.
상품→축 연결(has_size·uses_material·has_option_group·priced_by·references)은 [[product-226-acrylic-shaker-corotto]]가 건다.
가격 공유공식=[[formula-PRF_GOODS_FIXED_SIZ]](굿즈)·자기 3사이즈는 COMP_GOODS_FIXED_SIZ에 단가행 3건 실재(611=9,000·612/613=7,500·재-SELECT 07-04)=견적가능(미출시).

## 사이즈 노드 (인쇄면 siz화·§23)

<!-- transcribed-by: live railway t_prd_product_sizes ⋈ t_siz_sizes PRD_000226 (07-04 읽기전용 SELECT) — siz_nm verbatim @ 2026-07-04 -->
<!-- ★siz_nm이 규격이 아니라 인쇄면 종류(양면/전면만/배면만) — 인쇄면 옵션(OPT_000203)이 이 siz로 환원되어 고정가 siz_cd 가격축이 됨. -->

### [size-SIZ_000611] 아크릴쉐이커코롯토 양면인쇄 {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000611
- src: {source_file: "live railway t_siz_sizes ⋈ t_prd_product_sizes (07-04 읽기전용 SELECT)", source_locator: "키:SIZ_000611(siz_nm=아크릴쉐이커코롯토 양면인쇄)·(PRD_000226,SIZ_000611) dflt_yn=Y·del_yn=N", captured_at: "live 2026-07-04", badge: verified, src_id: SR-live-0704}
- props: {siz_nm_ref: "아크릴쉐이커코롯토 양면인쇄", note: "인쇄면 siz화(양면·dflt). 고정가 공식 siz_cd 가격축. ★COMP_GOODS_FIXED_SIZ에 이 siz 단가행 실재=9,000(재-SELECT 07-04·미출시)"}
- 본문: 인쇄면 '양면인쇄'가 siz로 이관된 노드(§23). [[product-226-acrylic-shaker-corotto]] has_size + optgroup-226-print-face option_refs 대상.

### [size-SIZ_000612] 아크릴쉐이커코롯토 전면만 인쇄 {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000612
- src: {source_file: "live railway t_siz_sizes ⋈ t_prd_product_sizes (07-04 읽기전용 SELECT)", source_locator: "키:SIZ_000612(siz_nm=아크릴쉐이커코롯토 전면만 인쇄)·(PRD_000226,SIZ_000612) dflt_yn=N·del_yn=N", captured_at: "live 2026-07-04", badge: verified, src_id: SR-live-0704}
- props: {siz_nm_ref: "아크릴쉐이커코롯토 전면만 인쇄", note: "인쇄면 siz화(전면만). 단가행 실재=7,500(재-SELECT 07-04·미출시)"}
- 본문: 인쇄면 '전면만 인쇄' siz 노드. has_size + optgroup-226-print-face option_refs 대상.

### [size-SIZ_000613] 아크릴쉐이커코롯토 배면만 인쇄 {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000613
- src: {source_file: "live railway t_siz_sizes ⋈ t_prd_product_sizes (07-04 읽기전용 SELECT)", source_locator: "키:SIZ_000613(siz_nm=아크릴쉐이커코롯토 배면만 인쇄)·(PRD_000226,SIZ_000613) dflt_yn=N·del_yn=N", captured_at: "live 2026-07-04", badge: verified, src_id: SR-live-0704}
- props: {siz_nm_ref: "아크릴쉐이커코롯토 배면만 인쇄", note: "인쇄면 siz화(배면만). 단가행 실재=7,500(재-SELECT 07-04·미출시)"}
- 본문: 인쇄면 '배면만 인쇄' siz 노드. has_size + optgroup-226-print-face option_refs 대상.

## 자재 노드 (글리터·226 로컬·MAT_TYPE.09 오타이핑)

<!-- transcribed-by: live railway t_prd_product_materials ⋈ t_mat_materials PRD_000226 (07-04 읽기전용 SELECT·dflt_yn=Y·del_yn=N) — mat_nm verbatim @ 2026-07-04 -->
<!-- ★글리터=장식 소재(substrate 아님·부속 아님·pack §3.5 T-8 경계). 글리터 옵션(OPT_000204·무가) 대상. 구 인쇄면자재(309/311/313)는 del_yn=Y 은퇴(미생성). -->

### [material-MAT_000310] 핑크글리터 {verified}
- type: material
- anchor: t_mat_materials/MAT_000310
- src: {source_file: "live railway t_mat_materials ⋈ t_prd_product_materials (07-04 읽기전용 SELECT)", source_locator: "키:MAT_000310(mat_nm=핑크글리터·mat_typ_cd MAT_TYPE.09)·(PRD_000226,MAT_000310) dflt_yn=Y·del_yn=N", captured_at: "live 2026-07-04", badge: verified, src_id: SR-live-0704}
- props: {mat_typ_cd: "MAT_TYPE.09", note: "글리터 장식 소재(핑크·글리터 옵션 dflt). substrate 아님(T-8). MAT_TYPE.09 봉제부자재 오타이핑(GAP-AC-1)"}
- 본문: 핑크글리터(글리터 옵션 무가 대상). [[product-226-acrylic-shaker-corotto]] uses_material + optgroup-226-glitter option_refs 대상.

### [material-MAT_000312] 화이트글리터 {verified}
- type: material
- anchor: t_mat_materials/MAT_000312
- src: {source_file: "live railway t_mat_materials ⋈ t_prd_product_materials (07-04 읽기전용 SELECT)", source_locator: "키:MAT_000312(mat_nm=화이트글리터·mat_typ_cd MAT_TYPE.09)·(PRD_000226,MAT_000312) dflt_yn=Y·del_yn=N", captured_at: "live 2026-07-04", badge: verified, src_id: SR-live-0704}
- props: {mat_typ_cd: "MAT_TYPE.09", note: "글리터 장식 소재(화이트). substrate 아님(T-8·GAP-AC-1)"}
- 본문: 화이트글리터(글리터 옵션 무가 대상). uses_material + optgroup-226-glitter option_refs 대상.

### [material-MAT_000314] 블루글리터 {verified}
- type: material
- anchor: t_mat_materials/MAT_000314
- src: {source_file: "live railway t_mat_materials ⋈ t_prd_product_materials (07-04 읽기전용 SELECT)", source_locator: "키:MAT_000314(mat_nm=블루글리터·mat_typ_cd MAT_TYPE.09)·(PRD_000226,MAT_000314) dflt_yn=Y·del_yn=N", captured_at: "live 2026-07-04", badge: verified, src_id: SR-live-0704}
- props: {mat_typ_cd: "MAT_TYPE.09", note: "글리터 장식 소재(블루). substrate 아님(T-8·GAP-AC-1)"}
- 본문: 블루글리터(글리터 옵션 무가 대상). uses_material + optgroup-226-glitter option_refs 대상.

### [material-MAT_000315] 블랙글리터 {verified}
- type: material
- anchor: t_mat_materials/MAT_000315
- src: {source_file: "live railway t_mat_materials ⋈ t_prd_product_materials (07-04 읽기전용 SELECT)", source_locator: "키:MAT_000315(mat_nm=블랙글리터·mat_typ_cd MAT_TYPE.09)·(PRD_000226,MAT_000315) dflt_yn=Y·del_yn=N", captured_at: "live 2026-07-04", badge: verified, src_id: SR-live-0704}
- props: {mat_typ_cd: "MAT_TYPE.09", note: "글리터 장식 소재(블랙). substrate 아님(T-8·GAP-AC-1)"}
- 본문: 블랙글리터(글리터 옵션 무가 대상). uses_material + optgroup-226-glitter option_refs 대상.

## 옵션그룹 노드 (CPQ)

### [optgroup-226-print-face] 인쇄면 (양면/전면만/배면만) {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000226
- src: {source_file: "live railway t_prd_product_options ⋈ option_items PRD_000226 (07-04 읽기전용 SELECT)", source_locator: "opt_grp_cd:OPT_000203(인쇄면·SEL_TYPE.01·mand_yn=Y)·OPV_000745 양면인쇄(dflt)→SIZ_000611·OPV_000746 전면만→SIZ_000612·OPV_000747 배면만→SIZ_000613(전부 OPT_REF_DIM.01=size)", captured_at: "live 2026-07-04", badge: verified, src_id: SR-live-0704}
- rel: {rel: option_refs, target: size-SIZ_000611, ref_key1: SIZ_000611, note: "양면인쇄(OPV_000745·dflt)→size"}
- rel: {rel: option_refs, target: size-SIZ_000612, ref_key1: SIZ_000612, note: "전면만 인쇄(OPV_000746)→size"}
- rel: {rel: option_refs, target: size-SIZ_000613, ref_key1: SIZ_000613, note: "배면만 인쇄(OPV_000747)→size"}
- props: {opt_grp_cd: "OPT_000203", sel_typ_cd: "SEL_TYPE.01", mand_yn: "Y", 옵션값: "양면인쇄/전면만/배면만(택1)", ref_dim: "OPT_REF_DIM.01=size(인쇄면→siz 환원·고정가 siz_cd 가격축)"}
- 본문: 손님이 인쇄면을 고르는 CPQ 옵션(택1·mand). 각 item이 siz(SIZ_000611/612/613)를 가리켜(R11 option_refs·OPT_REF_DIM.01) has_size 차원으로 환원(L-18 통과·부모 226 has_size 실재). ★인쇄면=가격축(siz_cd)이고 자기 siz 단가행 3건 실재(611=9,000·612/613=7,500·재-SELECT 07-04)=견적가능(미출시).

### [optgroup-226-glitter] 글리터 (핑크/화이트/블루/블랙) {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000226
- src: {source_file: "live railway t_prd_product_options ⋈ option_items PRD_000226 (07-04 읽기전용 SELECT)", source_locator: "opt_grp_cd:OPT_000204(글리터·SEL_TYPE.01·mand_yn=Y)·OPV_000748 핑크(dflt)→MAT_000310·OPV_000749 화이트→MAT_000312·OPV_000750 블루→MAT_000314·OPV_000751 블랙→MAT_000315(전부 OPT_REF_DIM.03=자재·ref_key2 USAGE.07)", captured_at: "live 2026-07-04", badge: verified, src_id: SR-live-0704}
- rel: {rel: option_refs, target: material-MAT_000310, ref_key1: MAT_000310, ref_key2: USAGE.07, note: "핑크글리터(OPV_000748·dflt)→자재"}
- rel: {rel: option_refs, target: material-MAT_000312, ref_key1: MAT_000312, ref_key2: USAGE.07, note: "화이트글리터(OPV_000749)→자재"}
- rel: {rel: option_refs, target: material-MAT_000314, ref_key1: MAT_000314, ref_key2: USAGE.07, note: "블루글리터(OPV_000750)→자재"}
- rel: {rel: option_refs, target: material-MAT_000315, ref_key1: MAT_000315, ref_key2: USAGE.07, note: "블랙글리터(OPV_000751)→자재"}
- props: {opt_grp_cd: "OPT_000204", sel_typ_cd: "SEL_TYPE.01", mand_yn: "Y", 옵션값: "핑크/화이트/블루/블랙 글리터(택1)", ref_dim: "OPT_REF_DIM.03=자재(ref_key2 USAGE.07)", 가격영향: "무가(고정가 공식 use_dims=[siz_cd]만·글리터 선택 가격 무변동)"}
- 본문: 손님이 글리터 색을 고르는 CPQ 옵션(택1·mand·무가). 각 item이 자재(MAT_000310/312/314/315)를 가리켜(R11 option_refs·OPT_REF_DIM.03·ref_key2 USAGE.07) uses_material 차원으로 환원(L-18 통과·부모 226 uses_material 실재). ★무가 CPQ — 고정가 공식이 siz_cd만 참조해 글리터 선택은 가격에 영향 없음(pack §3.9).

<!-- GAP 노드 없음: 구 gap-226-acryl-tbd는 D-AC-P1(2026-07-04 재-SELECT)로 제거.
     226 자기 3사이즈(611/612/613)는 COMP_GOODS_FIXED_SIZ에 단가행 3건 실재(611=9,000·612/613=7,500·reg_dt 07-03·병행 §7 굿즈 GB-2 세션 적재)=견적가능(미출시).
     구축 초기 "0건=견적불가" 판정은 07-03 적재 이전 스냅샷 기준 H-1 드리프트(false-gap·사실오류)였고 재-SELECT(acryl-226-reselect-260704.csv)로 정정.
     O5는 priced_by(→PRF_GOODS_FIXED_SIZ)로 충족(gap 참조 불요). 값 계산=evaluate_price 권위(D-18). -->
