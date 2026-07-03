<!-- product-local sub-nodes: E3 size for PRD_000164 아크릴코롯토(미출시). -->
<!-- ★공유 노드 재사용(중복 mint 방지·L-3): formula-PRF_COROTTO_ACRYL·component-COMP_ACRYL_COROTTO=Stage A(formula/acrylic-formulas.md·acrylic-components.md). material-MAT_000044=axis/materials.md. -->
<!--   size-SIZ_000011(50x50)·SIZ_000043(80x80)=타 상품(046/045) 정의 → 재정의 안 함(has_size 참조만). -->
<!--   size-SIZ_000148(60x60)·SIZ_000330(30x30mm)·SIZ_000333(40x40mm)=병행 아크릴 클러스터(146 키링·155 볼펜·156 지비츠)가 이미 정의 → 여기서 재정의 안 함(has_size 참조만·L-3 중복 회피). -->
<!-- ★여기 정의(164 로컬·타 빌더 미정의): size SIZ_000211(70x70·164 유일). siz_nm verbatim 전사(손전사 금지·live SELECT). -->
<!-- ★가격 값(unit_price) 미전사(D-18). 미출시(추천 제외). -->

# product-164 하위 노드 (아크릴코롯토 전용 사이즈)

아크릴코롯토(PRD_000164·미출시)가 쓰는 규격 사이즈 6행 중 로컬 신설 1행(SIZ_000211 70x70·164 유일).
나머지 5행(50x50·80x80·60x60·30x30mm·40x40mm)은 타 상품/병행 아크릴 클러스터가 정의 → 재사용(has_size 참조만).
상품→사이즈 연결(has_size)은 [[product-164-acrylic-corotto]]가 건다. 코롯토 면적공식은 이 규격들을
`[siz_width, siz_height]`로 조회한다(값=evaluate_price·[[component-COMP_ACRYL_COROTTO]]).

<!-- transcribed-by: live railway t_prd_product_sizes ⋈ t_siz_sizes PRD_000164 (07-04 읽기전용 SELECT) — siz_nm verbatim @ 2026-07-04 -->

### [size-SIZ_000211] 70x70 {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000211
- src: {source_file: "live railway t_siz_sizes ⋈ t_prd_product_sizes (07-04 읽기전용 SELECT)", source_locator: "키:SIZ_000211(siz_nm=70x70)·(PRD_000164,SIZ_000211) dflt_yn=Y·del_yn=N", captured_at: "live 2026-07-04", badge: verified, src_id: SR-live-0704}
- props: {siz_nm_ref: "70x70", note: "아크릴코롯토 규격. 코롯토 면적공식 W×H 조회 대상"}
- 본문: 아크릴코롯토 규격 70x70. [[product-164-acrylic-corotto]] has_size 대상(미출시).
