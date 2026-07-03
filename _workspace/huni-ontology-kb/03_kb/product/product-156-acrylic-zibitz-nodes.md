<!-- product-local sub-nodes: E3 size(5)·E11 option_group(가공)·qty for PRD_000156 아크릴지비츠. -->
<!-- ★공유 노드 재사용(중복 mint 방지·L-3): -->
<!--   - formula-PRF_ZIBITZ_ACRYL·component-COMP_ACRYL_ZIBITZ = Stage A 공유(formula/acrylic-formulas.md·acrylic-components.md) → 여기 재정의 안 함. main이 priced_by로 참조. -->
<!--   - material-MAT_000043(3mm)·category-CAT_000322(단품형) = Stage A 공유(axis/materials.md·categories.md) → 참조만. -->
<!-- ★여기 정의(156 고유): size 5(SIZ_000352/336/353/330/354)·option_group(OPT_000083 가공)·qty. -->
<!-- ★수치(치수)는 아래 전사표(transcribed-by)에만(D-9·L-12). 가격 값은 미전사(evaluate_price 권위·D-18). -->

# product-156 하위 노드 (아크릴지비츠 전용 사이즈·가공 옵션그룹·수량)

아크릴지비츠(PRD_000156)가 쓰는 규격 사이즈 5행(15~35mm 정사각)·가공 옵션그룹(투명/스핀 택1)·수량규칙.
상품→축 연결(has_size·has_option_group·has_qty_rule)은 [[product-156-acrylic-zibitz]]가 건다.

## 치수 전사표 (권위 = 라이브 마스터)

<!-- transcribed-by: awk t_siz_sizes.csv+t_prd_product_sizes.csv PRD_000156 from live-snapshot/latest snap_20260702_1119 @ 2026-07-04 -->
| siz_cd | 라벨 | 작업(work mm) | del_yn |
|---|---|---|---|
| SIZ_000352 | 15x15 | 15x15 | N |
| SIZ_000336 | 20x20 | 20x20 | N |
| SIZ_000353 | 25x25 | 25x25 | N |
| SIZ_000330 | 30x30 | 30x30 | N |
| SIZ_000354 | 35x35 | 35x35 | N |

## 사이즈 노드 (product-local — 정사각 규격 5행)

### [size-SIZ_000352] 15x15 규격 {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000352
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "키:SIZ_000352(siz_nm=15x15·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_sizes.csv", source_locator: "키:(PRD_000156,SIZ_000352) dflt_yn=Y·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000352(15x15)", note: "아크릴지비츠 규격 15mm 정사각. [[product-156-acrylic-zibitz]] has_size 대상"}
- 본문: 아크릴지비츠 15x15 규격.

### [size-SIZ_000353] 25x25 규격 {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000353
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "키:SIZ_000353(siz_nm=25x25·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_sizes.csv", source_locator: "키:(PRD_000156,SIZ_000353) dflt_yn=Y·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000353(25x25)", note: "아크릴지비츠 규격 25mm 정사각"}
- 본문: 아크릴지비츠 25x25 규격.

### [size-SIZ_000354] 35x35 규격 {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000354
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "키:SIZ_000354(siz_nm=35x35·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_sizes.csv", source_locator: "키:(PRD_000156,SIZ_000354) dflt_yn=Y·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000354(35x35)", note: "아크릴지비츠 규격 35mm 정사각"}
- 본문: 아크릴지비츠 35x35 규격.

## 옵션그룹 노드 (CPQ — 가공 택1)

<!-- ★OPT_000083 가공 = opt_cd(투명/스핀)가 COMP_ACRYL_ZIBITZ use_dims의 가격차원(opt_cd) — -->
<!-- option_items(ref_dim 매핑) 0행이나 opt_cd 자체가 가격축이라 정상(자재/공정 참조 아님·L-18 미해당). -->

### [optgroup-156-gagong] 가공 (투명/스핀 택1) {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000156
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "키:PRD_000156 opt_grp_cd:OPT_000083(가공·SEL_TYPE.01·min_sel=1·max_sel=1·mand_yn=Y·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_options.csv", source_locator: "키:PRD_000156 OPT_000083 (OPV_000493 투명·dflt_yn=Y / OPV_000494 스핀)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {opt_grp_cd: "OPT_000083", sel_typ_cd: "SEL_TYPE.01", mand_yn: "Y", 옵션값: "투명(기본)/스핀(택1)", ref_dim: "없음 — opt_cd가 가격차원(COMP_ACRYL_ZIBITZ use_dims=[opt_cd,min_qty,opt_grp:OPT_000083])", note: "option_items(ref 매핑) 0행이나 opt_cd가 직접 가격축이라 정상(자재/공정 option_refs 아님·L-18 미해당)"}
- 본문: 손님이 가공(투명/스핀)을 고르는 CPQ 옵션(택1·필수). 선택한 opt_cd가 부속선택 공식
  [[formula-PRF_ZIBITZ_ACRYL]]의 구성요소 [[component-COMP_ACRYL_ZIBITZ]] `use_dims`에서 단가를
  가른다(투명↔스핀 각 단가행). ref_dim 참조가 아니라 opt_cd 자체가 가격차원이므로 option_refs·L-18
  대상 아님. evaluate_price는 제약 미참조(위젯/주문이 validate·[[constraint-builder-contract-demo-260702]]).

## 수량규칙 노드 (product-local)

### [qty-156] 아크릴지비츠 수량규칙 {verified}
- type: bundle_qty
- anchor: t_prd_products/PRD_000156
- src: {source_file: "01_curation/_cache/acryl-universe-260704.csv", source_locator: "키:PRD_000156 min_qty/max_qty/qty_incr(1/10000/1)", captured_at: "live 2026-07-04", badge: verified, src_id: SR-ac-0704}
- props: {min_max_incr_ref: "전사(상품 1/10000/1)", bdl_unit_typ_cd: "QTY_UNIT.01", note: "수량축은 공식 use_dims의 min_qty로 반영(수량 티어). 값=evaluate_price"}
- 본문: 수량 그릇 = 상품 마스터 컬럼(min1/max10000/incr1·QTY_UNIT.01). 부속선택 공식이 min_qty를
  가격차원으로 참조.
