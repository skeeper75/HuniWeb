# Stage B needs_axis — 셋트 계열 미민팅 축 노드 (Stage C 배선 대상)

> 형식: id|anchor|설명|출처. Stage C1=민팅(search-before-mint·dedup)·Stage C2=상품→축 엣지 배선.

## category (13)
- category-CAT_000105|t_cat_categories/CAT_000105|하드커버책자(072/073/074 카테고리·in_category 배선 대기)|live-snapshot t_prd_product_categories+t_cat_categories
- category-CAT_000106|t_cat_categories/CAT_000106|레더하드커버책자(077 전용 카테고리)|live-snapshot t_prd_product_categories+t_cat_categories
- category-CAT_000107|t_cat_categories/CAT_000107|하드커버링책자(082 main category)·공유 category 축 미민팅→in_category 배선 대기|live t_cat_categories.csv
- category-CAT_000105|t_cat_categories/CAT_000105|하드커버책자 상위(082/088 공유·main_cat_yn=N)|live t_prd_product_categories.csv
- category-CAT_000008|t_cat_categories/CAT_000008|문구(088 main category·라이브 실값)|live t_prd_product_categories.csv PRD_000088
- category-CAT_000006|axis/categories.md|책자(booklet 최상위 분류·068/069/070 in_category 대상)|live t_cat_categories.csv CAT_000006
- category-CAT_000316|axis/categories.md|일반책자(⊂CAT_000006·068/069/070 main_cat_yn=Y 소속)|live t_cat_categories.csv CAT_000316
- category-CAT_000308|t_cat_categories/CAT_000308|엽서북(094 주카테고리)·in_category 미배선|RAILWAY_DB t_prd_product_categories PRD_000094
- category-CAT_000124|t_cat_categories/CAT_000124|노트(094 부·097 부 카테고리)|RAILWAY_DB t_prd_product_categories
- category-CAT_000026|t_cat_categories/CAT_000026|엽서북(095/096 구성원 카테고리)|RAILWAY_DB t_prd_product_categories PRD_000095/096
- category-CAT_000129|t_cat_categories/CAT_000129|떡메모지(097 주·098 카테고리)|RAILWAY_DB t_prd_product_categories PRD_000097/098
- category-CAT_000008|t_cat_categories/CAT_000008|문구(097 카테고리 disp_seq2)|RAILWAY_DB t_prd_product_categories PRD_000097
- category-CAT_000112|t_cat_categories/CAT_000112,113,114,115,116,118|캘린더 카테고리 6종(탁상형/미니탁상형/엽서/벽걸이/와이드벽걸이/디자인캘린더) 축 노드 미민팅 → 108~112 in_category 전부 미배선(브로큰링크 회피 위해 relations 미기입, 프로즈 기록)|live-snapshot t_prd_product_categories.csv PRD_000108~112

## material (25)
- material-MAT_000246|t_mat_materials/MAT_000246|전용지(073 하드커버책자 표지 자재·USAGE.02)|live-snapshot t_prd_product_materials PRD_000073+t_mat_materials
- material-MAT_000379|t_mat_materials/MAT_000379|레더(화이트)(078 레더 표지 자재·USAGE.02)|live-snapshot t_prd_product_materials PRD_000078+t_mat_materials
- material-MAT_000072|t_mat_materials/MAT_000072|백색모조지 100g(284/285 내지 dflt·USAGE.07)|live-snapshot t_prd_product_materials PRD_000284/285
- material-MAT_000073|t_mat_materials/MAT_000073|백색모조지 120g(284/285 내지·USAGE.07)|live-snapshot t_prd_product_materials
- material-MAT_000076|t_mat_materials/MAT_000076|아트지 100g(284/285 내지·USAGE.07)|live-snapshot t_prd_product_materials
- material-MAT_000077|t_mat_materials/MAT_000077|아트지 120g(284/285 내지·USAGE.07)|live-snapshot t_prd_product_materials
- material-MAT_000086|t_mat_materials/MAT_000086|스노우지 100g(284/285 내지·USAGE.07)|live-snapshot t_prd_product_materials
- material-MAT_000087|t_mat_materials/MAT_000087|스노우지 120g(284/285 내지·USAGE.07)|live-snapshot t_prd_product_materials
- material-MAT_000095|t_mat_materials/MAT_000095|앙상블 100g(284/285 내지·USAGE.07)|live-snapshot t_prd_product_materials
- material-MAT_000104|t_mat_materials/MAT_000104|몽블랑 100g(284/285 내지·USAGE.07)|live-snapshot t_prd_product_materials
- material-MAT_000105|t_mat_materials/MAT_000105|몽블랑 130g(284/285 내지·USAGE.07)|live-snapshot t_prd_product_materials
- material-MAT_000246|t_mat_materials/MAT_000246|082 표지 전용지(USAGE.02·MAT_TYPE.01)|live t_prd_product_materials PRD_000083
- material-MAT_000379|t_mat_materials/MAT_000379|088 표지 레더(USAGE.02·MAT_TYPE.05)|live t_prd_product_materials PRD_000089
- material-MAT_000013,MAT_000014,MAT_000015|t_mat_materials/MAT_000013..015|082 트윈링 링자재(USAGE.07·★불가침·은퇴금지)|live t_prd_product_materials PRD_000082
- material-MAT_000072,073,076,077,086,087,095,104,105|t_mat_materials/MAT_000072..105|286 내지 종이 9종(USAGE.07)|live t_prd_product_materials PRD_000286
- material-(booklet-cover-inner-군)|axis/materials.md|표지 USAGE.01(MAT_000073/077/078/079/080/087/090/095/096/104~107)+중철내지287 USAGE.07(MAT_000072/073/076/077/086/095/104/105) 자재군 미민팅·BOM표가 권위|live t_prd_product_materials.csv PRD_000287/288/290/292
- material-MAT_000073|t_mat_materials/MAT_000073|백모조 120g(097 부모 자재 USAGE.01·uses_material 미배선)|RAILWAY_DB t_prd_product_materials PRD_000097
- material-MAT_000105|t_mat_materials/MAT_000105|몽블랑 130g(내지 101 USAGE.01)|live t_prd_product_materials PRD_000100
- material-MAT_000005|t_mat_materials/MAT_000005|하드커버(표지 102 USAGE.02)|live t_prd_product_materials PRD_000100
- material-MAT_000250|t_mat_materials/MAT_000250|아트250+무광코팅(표지 103 USAGE.02)|live t_prd_product_materials PRD_000100
- material-MAT_000251|t_mat_materials/MAT_000251|그레이(면지 104 USAGE.03·무가격)|live t_prd_product_materials PRD_000100
- material-MAT_000006|t_mat_materials/MAT_000006|레더하드커버(표지 105 USAGE.02)|live t_prd_product_materials PRD_000100
- material-MAT_000186|t_mat_materials/MAT_000186|레더(표지 106 USAGE.02)|live t_prd_product_materials PRD_000100
- material-MAT_000007|t_mat_materials/MAT_000007|소프트커버(표지 107 USAGE.02)|live t_prd_product_materials PRD_000100
- material-MAT_000090,127,098|t_mat_materials|캘린더 기본용지 3종(스노우지200g MAT_000090·스타드림 127·앙상블190g 098) 축 노드 미민팅 → uses_material가 축 노드 있는 대표 subset만 배선(016 커버리지 GAP 동류·per-file gap 노드로 정직선언)|live-snapshot t_prd_product_materials.csv

## plate (2)
- plate-SIZ_000499-gukc4|t_prd_product_plate_sizes/(PRD_000095,SIZ_000499)|국4절(316x467) 내지/표지 판형 축노드 부재(plate-OUTPUT_PAPER_TYPE_01/02만 존재)·has_plate_size 미배선|RAILWAY_DB t_prd_product_plate_sizes PRD_000095/096/098
- plate-OUTPUT_PAPER_TYPE_03|t_prd_product_plate_sizes(OUTPUT_PAPER_TYPE.03·3절)|3절 판형 축 노드 미민팅(현 axis plate-sizes.md=01/02만) → 112 has_plate_size 미배선. 썬캡 등 타 상품군도 쓰는 공유 판형이라 승격 대상|live-snapshot t_prd_product_plate_sizes.csv PRD_000112 SIZ_000475(330x660)

## process (3)
- process-(booklet-aux-군)|axis/processes.md|무선/PUR 부가 후가공·제본 부가공정(PROC_000037~044·051·052·076) 069/070 부모 보유·축 미민팅|live t_prd_product_processes.csv PRD_000069/070
- process-PROC_000076|t_proc_processes/PROC_000076|수축포장(094 공정 mand·has_process 미배선)|RAILWAY_DB t_prd_product_processes PRD_000094
- process-PROC_000076|t_proc_processes/PROC_000076|수축포장 공정 축 노드 미민팅 → 108/109 has_process 미배선(디지털인쇄 004·캘린더제본 100/102는 배선됨)|live-snapshot t_prd_product_processes.csv PRD_000108/109

## size (11)
- size-SIZ_000172|t_siz_sizes/SIZ_000172|A4 210x297(284/285 내지 사이즈·has_size 배선 대기)|live-snapshot t_prd_product_sizes PRD_000284/285+t_siz_sizes
- size-SIZ_000172|t_siz_sizes/SIZ_000172|286 내지 A4(210x297) 사이즈 축 미민팅(SIZ_170·380만 존재)|live t_prd_product_sizes PRD_000286
- size-SIZ_000172|axis/sizes.md|A4(210x297)·068/069/070 부모 및 289/291 내지 사이즈(비dflt)|live t_siz_sizes.csv SIZ_000172
- size-SIZ_000174|axis/sizes.md|A3(297x420) 표지 펼침 사이즈(288/290/292 cover·dflt·가격표 좌표 밖)|live t_siz_sizes.csv SIZ_000174
- size-SIZ_000124|t_siz_sizes/SIZ_000124|150x100(094 사이즈·has_size 미배선)|RAILWAY_DB t_prd_product_sizes PRD_000094
- size-SIZ_000119|t_siz_sizes/SIZ_000119|90x90(097 사이즈)|RAILWAY_DB t_prd_product_sizes PRD_000097
- size-SIZ_000266|t_siz_sizes/SIZ_000266|70x120(097 사이즈)|RAILWAY_DB t_prd_product_sizes PRD_000097
- size-SIZ_000269|t_siz_sizes/SIZ_000269|8x8(200x200mm)·★골든 기준선택 사이즈|live t_prd_product_sizes PRD_000100
- size-SIZ_000274|t_siz_sizes/SIZ_000274|10x10(250x250mm)|live t_prd_product_sizes PRD_000100
- size-SIZ_000172|t_siz_sizes/SIZ_000172|A4(210x297mm)|live t_prd_product_sizes PRD_000100
- size-SIZ_000069,070,018,071,072,073,074,050,075,076,077|t_prd_product_sizes(+t_siz_sizes)|캘린더 전용 사이즈 11종 축 노드 미민팅(공유 SIZ_000007만 존재·110에서 배선) → 108/109/111/112 has_size 미배선·110 부분배선. BOM 전사표가 권위|live-snapshot t_prd_product_sizes.csv PRD_000108~112
