# SB-1 문구셋트 needs_axis (Stage C 배선 대상)

> 형식 id|anchor|설명|출처. C1=민팅(search-before-mint·dedup)·C2=상품→축 엣지 배선.

## category (2)
- category-CAT_000321|t_cat_categories/CAT_000321|플래너(만년다이어리 172~175 카테고리·main_cat_yn=N·upr CAT_000008·10노드 전부 in_category 대상)|live-snapshot/latest/t_cat_categories.csv
- category-CAT_000321|t_cat_categories/CAT_000321|플래너(문구 CAT_000008 하위) — 176 먼슬리플래너 유일 카테고리 축 미민팅→in_category 미배선(176은 in_category 엣지 0·전사표 권위)|live-snapshot/latest t_prd_product_categories PRD_000176 + t_cat_categories CAT_000321

## material (1)
- material-MAT_000072|t_mat_materials/MAT_000072|백색모조지 100g — 300/302/304 내지 자재(USAGE.01/07) 축 미민팅→uses_material 미배선(BOM 표 권위)|live-snapshot/latest t_prd_product_materials PRD_000300/302/304 + t_mat_materials MAT_000072

## plate (5)
- plate-SIZ_000251|t_prd_product_plate_sizes/(PRD_000172,SIZ_000251)|표지파일사양 300x214(172 소프트커버 부모 판형·dflt)|live-snapshot/latest/t_prd_product_plate_sizes.csv+t_siz_sizes.csv
- plate-SIZ_000181|t_prd_product_plate_sizes/(PRD_000173,SIZ_000181)|표지파일사양 426x303(173 하드커버 부모 판형·dflt)|live-snapshot/latest/t_prd_product_plate_sizes.csv+t_siz_sizes.csv
- plate-SIZ_000007|t_prd_product_plate_sizes/(PRD_000179,SIZ_000007)|148x210 표지파일사양 (179 부모 판형·size-SIZ_000007 노드는 존재하나 plate 노드 미민팅)|RAILWAY_DB live SELECT t_prd_product_plate_sizes PRD_000179 @2026-07-03
- plate-SIZ_000381|t_prd_product_plate_sizes/(PRD_000179,SIZ_000381)|186x261 표지파일사양 (179 부모 판형·plate 노드 미민팅)|RAILWAY_DB live SELECT t_prd_product_plate_sizes PRD_000179 @2026-07-03
- plate-SIZ_000382|t_prd_product_plate_sizes/(PRD_000181,SIZ_000382)|216x154 표지파일사양 (181 부모 판형·plate 노드 미민팅)|RAILWAY_DB live SELECT t_prd_product_plate_sizes PRD_000181 @2026-07-03

## qty (3)
- qty-176|none(bundle_qtys 0행·수량 그릇=상품 min1/max500/incr1)|먼슬리플래너 수량규칙 per-product 노드 미민팅→has_qty_rule 미배선(props min/max 스칼라 보유·094 qty-094 동형 노드 필요 시)|live-snapshot/latest t_prd_products PRD_000176 + t_prd_product_bundle_qtys(0행)
- qty-177|none(bundle_qtys 0행·수량 그릇=상품 min1/max1000/incr1)|스프링노트 수량규칙 per-product 노드 미민팅→has_qty_rule 미배선(props 보유)|live-snapshot/latest t_prd_products PRD_000177
- qty-178|none(bundle_qtys 0행·수량 그릇=상품 min4/max500/incr4)|스프링수첩 수량규칙 per-product 노드 미민팅→has_qty_rule 미배선(★incr=4 특이·props 보유)|live-snapshot/latest t_prd_products PRD_000178

## size (4)
- size-SIZ_000375|t_siz_sizes/SIZ_000375|130x190(만년다이어리 4종 완제품 dflt 사이즈·완제품가 sparse 유일 단가행 좌표)|live-snapshot/latest/t_siz_sizes.csv
- size-SIZ_000377|t_siz_sizes/SIZ_000377|178 스프링수첩 기본 사이즈 90x145 축 미민팅→has_size 미배선(전사표 권위)|live-snapshot/latest t_prd_product_sizes PRD_000178 + t_siz_sizes SIZ_000377(90.00x145.00)
- size-SIZ_000379|t_siz_sizes/SIZ_000379|144x206 (179 부모 사이즈·dflt Y·has_size 미배선)|RAILWAY_DB live SELECT t_prd_product_sizes PRD_000179 @2026-07-03
- size-SIZ_000196|t_siz_sizes/SIZ_000196|A6(105x148mm) (181 부모 유일 사이즈·dflt Y·미민팅이라 181 has_size 엣지 없음)|RAILWAY_DB live SELECT t_prd_product_sizes PRD_000181 @2026-07-03
