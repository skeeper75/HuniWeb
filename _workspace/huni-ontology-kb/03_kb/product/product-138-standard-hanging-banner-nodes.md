<!-- product-local sub-nodes: E2 category·E3 size·E4 material·E6 process·E8 qty·E9 price_formula·E10 component·E11 option_group·gap for PRD_000138 일반현수막. -->
<!-- ★공유 노드 재사용(중복 mint 방지·L-3): 아래 축은 138이 첫 정의(타 실사 빌더 미정의). CAT_000315(배너/현수막)·현수막천/끈/큐방/각목 자재·봉제/부착/타공 공정·base+옵션 구성요소 = 138 canonical → needed_shared 반환(향후 silsa CPQ 축 승격 시 id 그대로 이관). -->
<!-- ★118 아트프린트포스터와 다른 점: (1) base comp이 [단독](동형결합 없음·소재축 없음) (2) 가격=base + 8 옵션 추가가격(9 구성요소) (3) CPQ 3그룹 실적재(라이브 최초 실사 옵션 레이어) (4) 삭제 마스터 드리프트 3건(069/340/084)=defect 양면. -->
<!-- ★수치(치수·매트릭스 shape·구성요소 행수)는 아래 전사표(transcribed-by·transcribe_product_138.py)에만. props raw 미기입(D-9·L-12). -->
<!-- ★가격 값(unit_price)은 전사하지 않음 — 연결·차원·격자완전성까지만(D-18·값=evaluate_price). -->

# product-138 하위 노드 (일반현수막 전용 축 원자 + 공식/9구성요소/옵션3/GAP3)

일반현수막(PRD_000138)이 쓰는 규격 사이즈·본체+CPQ 번들 자재·후가공 공정·가격공식(9 구성요소)·수량규칙·
CPQ 옵션그룹 3·GAP 3. 상품→축 연결(has_size·uses_material·has_process·priced_by·has_option_group·
has_qty_rule)은 [[product-138-standard-hanging-banner]]가 건다. 공식→구성요소 배선(has_component)은
아래 formula 블록(seq1 base 면적매트릭스 + seq2~9 옵션 추가가격).

## 치수·자재·공정·카테고리·수량·면적매트릭스·공식 전사표 (권위 = 라이브 마스터)

<!-- transcribed-by: _meta/scripts/transcribe_product_138.py from live-snapshot/latest (snap_20260702_1119) t_siz_sizes PRD_000138 @ 2026-07-03 -->
| siz_cd | 라벨 | 작업(work mm) | 조판(impos_yn) | del_yn |
|---|---|---|---|---|
| SIZ_000322 | 5000x900 | 5000x900 | N | N |

<!-- transcribed-by: _meta/scripts/transcribe_product_138.py from live-snapshot/latest (snap_20260702_1119) t_mat_materials PRD_000138 @ 2026-07-03 -->
| mat_cd | 자재명 | mat_typ | 마스터 del | 상품링크 del | 비고 |
|---|---|---|---|---|---|
| MAT_000182 | 현수막천 | MAT_TYPE.08 | N | N | 본체(현수막천·dflt) |
| MAT_000070 | 설치용끈 | MAT_TYPE.16 | N | N | 설치용끈(CPQ) |
| MAT_000337 | 큐방 | MAT_TYPE.16 | N | N | 큐방(CPQ) |
| MAT_000338 | 각목 | MAT_TYPE.07 | N | N | 각목 900이하(CPQ) |
| MAT_000069 | 양면테입 | MAT_TYPE.07 | Y | N | 양면테입(★마스터 삭제·item 참조 잔존) |
| MAT_000340 | 봉제사 | MAT_TYPE.07 | Y | N | 봉제사(★마스터 삭제·item 참조 잔존) |
| MAT_000339 | 각목(900초과) | MAT_TYPE.07 | Y | Y | 각목 900초과(★완전 삭제·노드 미생성) |

<!-- transcribed-by: _meta/scripts/transcribe_product_138.py from live-snapshot/latest (snap_20260702_1119) t_proc_processes PRD_000138 @ 2026-07-03 -->
| proc_cd | 공정명 | 마스터 del | 상품링크 del | 비고 |
|---|---|---|---|---|
| PROC_000080 | 봉제 | N | N | 봉제(봉미싱 param) |
| PROC_000081 | 부착 | N | N | 부착(끈/테입 등 대상) |
| PROC_000104 | 현수막타공 | N | N | 현수막타공(타공수 param·079 대체) |
| PROC_000084 | 열재단 | Y | N | 열재단(★마스터 삭제·기본값 item 참조 잔존) |
| PROC_000079 | 타공 | N | Y | 타공(상품링크 삭제·104로 교체·노드 미생성) |

<!-- transcribed-by: _meta/scripts/transcribe_product_138.py from live-snapshot/latest (snap_20260702_1119) t_cat_categories PRD_000138 @ 2026-07-03 -->
| cat_cd | 분류명 | cat_lvl | 상위분류 | del_yn |
|---|---|---|---|---|
| CAT_000315 | 배너/현수막 | 2 | CAT_000005 | N |

<!-- transcribed-by: _meta/scripts/transcribe_product_138.py from live-snapshot/latest (snap_20260702_1119) t_prd_products PRD_000138 @ 2026-07-03 -->
| nonspec | 가로범위(mm·incr) | 세로범위(mm·incr) | min_qty | max_qty | qty_incr | 단위 |
|---|---|---|---|---|---|---|
| Y | 500~1750 (incr 100) | 500~5000 (incr 100) | 1 | 10000 | 1 | QTY_UNIT.01 |

<!-- transcribed-by: _meta/scripts/transcribe_product_138.py from live-snapshot/latest (snap_20260702_1119) t_prc_component_prices COMP_POSTER_BANNER_NORMAL(base SHAPE·값 미전사) @ 2026-07-03 -->
| comp_cd | 차원(use_dims) | 가로구간수 | 세로구간수 | 가로범위(mm) | 세로범위(mm) | (가로,세로)셀수 | 단가행수 | 격자완전 | 비대칭 | 수량축충전 |
|---|---|---|---|---|---|---|---|---|---|---|
| COMP_POSTER_BANNER_NORMAL | ["siz_width", "siz_height"] | 5 | 16 | 900~1750 | 900~5000 | 80 | 81 | True | True | True |

> **격자완전(grid_full)=True** = 가로 5구간 × 세로 16구간 = 80셀 조합이 채워짐(단가행 81 = 1중복). mapping.md는
> 79셀로 기록했으나 라이브 현재=80셀/81행(현재값 전사·SHAPE만·값 미전사). off-grid=가로·세로 각 한 단계 큰
> 규격 ceiling(앱 계산·DB는 룩업행·pack §3.10). 매트릭스 하한(900×900)이 제품 nonspec 하한(500×500)보다
> 크므로 500~900 입력은 최소셀로 수렴(→ [[gap-138-roll-price-logic]] 범위 안). ★수량축충전=True나 전부
> min_qty=1(수량무관 통가격).

<!-- transcribed-by: _meta/scripts/transcribe_product_138.py from live-snapshot/latest (snap_20260702_1119) t_prc_formula_components + t_prc_component_prices PRF_POSTER_BANNER_N(9 구성요소 배선·옵션 추가가격 SHAPE) @ 2026-07-03 -->
| disp_seq | comp_cd | addtn | use_dims | 단가행수 | 역할 |
|---|---|---|---|---|---|
| 1 | COMP_POSTER_BANNER_NORMAL | Y | ["siz_width", "siz_height"] | 81 | base 면적매트릭스 완제품가([단독]) |
| 2 | COMP_POSTEROPT_BANNER_NORMAL_PROC_PUNCH_4 | Y | ["proc_cd", "min_qty", "proc_grp:PROC_000104"] | 3 | 타공 추가가격(현수막타공) |
| 3 | COMP_POSTEROPT_BANNER_NORMAL_PROC_CUTEDGE | Y | ["opt_cd", "opt_grp:OPT_000003"] | 1 | 열재단 추가가격 |
| 4 | COMP_POSTEROPT_BANNER_NORMAL_PROC_DTAPE | Y | ["opt_cd", "opt_grp:OPT_000003"] | 1 | 양면테잎 추가가격 |
| 5 | COMP_POSTEROPT_BANNER_NORMAL_PROC_BONGSEW | Y | ["opt_cd", "opt_grp:OPT_000003"] | 1 | 봉미싱 추가가격 |
| 6 | COMP_POSTEROPT_BANNER_NORMAL_ADD_QBANG_4 | Y | ["opt_cd", "opt_grp:OPT_000004"] | 1 | 큐방 추가가격 |
| 7 | COMP_POSTEROPT_BANNER_NORMAL_ADD_STRING_4 | Y | ["opt_cd", "opt_grp:OPT_000004"] | 1 | 끈 추가가격 |
| 8 | COMP_POPT_BNR_GAKMOK_STR_900_4_LE | Y | ["opt_cd", "opt_grp:OPT_000004"] | 1 | 각목900이하+끈 추가가격 |
| 9 | COMP_POPT_BNR_GAKMOK_STR_900_4_GT | Y | ["opt_cd", "opt_grp:OPT_000004"] | 1 | 각목900초과+끈 추가가격 |

## 카테고리 노드 (★재사용 — 재정의 안 함·L-3)

<!-- ★category-CAT_000315(배너/현수막·사인 하위 leaf)은 병렬 실사 빌더 product-136-pet-banner-nodes.md가 canonical 소유. -->
<!-- 138은 in_category로 참조만(재정의 시 L-3 중복 id). needed_shared_nodes 반환(향후 axis/categories 승격 후보). -->
<!-- 137 메쉬배너도 같은 카테고리 참조. round-13 CAT_000298 고아는 해소(del_yn=Y 06-18)·정상 재연결(pack §1.1 T-1). -->
<!-- [[product-138-standard-hanging-banner]] in_category → category-CAT_000315(136 정의)로 배선(L-15 실재·끊긴링크 0). -->
<!-- category-CAT_000315 참조 유지: [[category-CAT_000315]] -->
- 사용처(참조): [[category-CAT_000315]]

## 사이즈 노드 (product-local — preset 규격 1행 + nonspec 연속범위)

### [size-SIZ_000322] 5000x900 규격 (dflt) {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000322
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "테이블:t_siz_sizes 키:SIZ_000322(siz_nm=5000x900·work 5000x900·impos_yn=N·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_sizes.csv", source_locator: "키:(PRD_000138,SIZ_000322) dflt_yn=Y·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000322(작업 5000x900·impos_yn=N)", note: "현수막 preset 규격 1행(대형 롤). 대부분 nonspec 사용자입력(가로 500~1750·세로 500~5000)에 의존. 면적매트릭스 셀로 환원(→ [[gap-138-roll-price-logic]])"}
- 본문: 일반현수막 preset 규격(5000×900·dflt). [[product-138-standard-hanging-banner]] has_size 대상. 118 포스터(A3/A2/A1 규격 3행)와 달리 preset 1개+nonspec 연속범위 위주.

## 자재 노드 (product-local — 본체 현수막천 + CPQ 번들·삭제 드리프트 2 defect·needed_shared)

<!-- ★138 본체=현수막천(MAT_TYPE.08·현재값·note "→.05" 목표는 코드개편 STALE T-2). CPQ 번들 자재=끈/큐방/각목(활성)·양면테입/봉제사(마스터 삭제 드리프트=defect 양면). 각목900초과(339)는 완전 삭제라 노드 미생성. -->

### [material-MAT_000182] 현수막천 (본체) {verified}
- type: material
- anchor: t_mat_materials/MAT_000182
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "테이블:t_mat_materials 키:MAT_000182(mat_nm=현수막천·mat_typ_cd=MAT_TYPE.08·del_yn=N·note '정정 06-14 실사소재.08→원단.05')", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_materials.csv", source_locator: "키:(PRD_000138,MAT_000182) USAGE.07·dflt_yn=Y·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.08", 사용: "138 본체 자재(USAGE.07·dflt_yn=Y)", note: "현수막천. ★현재값 mat_typ=.08(패브릭 3소재 그래픽천/현수막천/메쉬는 아직 .08·pack §1.1·§3.5). note의 '→원단.05' 목표는 MAT_TYPE 코드 개편(.05=특수소재)으로 STALE(T-2)"}
- 본문: 일반현수막 본체 자재(현수막천). 낱장 완제품 단일 슬롯(USAGE.07). base comp이 [단독](소재축 없음)이라 이 자재가 소재옵션으로 나뉘지 않음. IMPORT 자재 삭제 금지([[rule/rules#RULE_import_material_no_delete]]). 실사 CPQ 축 needed_shared.

### [material-MAT_000070] 설치용끈 (CPQ) {verified}
- type: material
- anchor: t_mat_materials/MAT_000070
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "테이블:t_mat_materials 키:MAT_000070(mat_nm=설치용끈·mat_typ_cd=MAT_TYPE.16·sel_typ_cd=SEL_TYPE.01·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_materials.csv", source_locator: "키:(PRD_000138,MAT_000070) USAGE.07·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.16", 사용: "끈(4개)추가 옵션 자재(OPV_000014/015/016)·부착 PROC_000081 BUNDLE", note: "설치용끈. 추가 그룹(OPT_000004) 옵션 자재. 각목+끈 조합에도 포함"}
- 본문: 끈 추가 옵션의 자재(끈=자재 + 부착=공정 BUNDLE·pack §3.9·§3.12). optgroup-138-additional의 option_refs 타깃(OPT_REF_DIM.03). [[product-138-standard-hanging-banner]] uses_material에 실재(L-18 부모정합). 실사 CPQ 축 needed_shared.

### [material-MAT_000337] 큐방 (CPQ) {verified}
- type: material
- anchor: t_mat_materials/MAT_000337
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "테이블:t_mat_materials 키:MAT_000337(mat_nm=큐방·mat_typ_cd=MAT_TYPE.16·del_yn=N·note '큐방(4개)추가 옵션 자재·금속 부속')", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_materials.csv", source_locator: "키:(PRD_000138,MAT_000337) USAGE.07·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.16", 사용: "큐방(4개)추가 옵션 자재(OPV_000013)·부착 PROC_000081 BUNDLE(qty 4)", note: "큐방(금속 부속). search-before-mint 부재 재확인 후 신설(마스터 note)"}
- 본문: 큐방 추가 옵션의 자재(BUNDLE: 자재 큐방 + 공정 부착). optgroup-138-additional의 option_refs 타깃(OPT_REF_DIM.03). uses_material에 실재(L-18). 실사 CPQ 축 needed_shared.

### [material-MAT_000338] 각목 900이하 (CPQ) {verified}
- type: material
- anchor: t_mat_materials/MAT_000338
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "테이블:t_mat_materials 키:MAT_000338(mat_nm=각목·mat_typ_cd=MAT_TYPE.07·del_yn=N·note '각목(900이하)+끈 옵션 자재·900이하 규격·2규격 별 mat_cd 모델')", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_materials.csv", source_locator: "키:(PRD_000138,MAT_000338) USAGE.07·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.07", 사용: "각목(900mm이하)+끈 옵션 자재(OPV_000015 item1)", note: "사각단면 목재 900이하. ★각목900초과(MAT_000339)는 삭제됐고 OPV_000016(900초과)가 이 338을 참조하는 드리프트=[[gap-138-gakmok-gt-material]]"}
- 본문: 각목(900이하) 추가 옵션의 자재. optgroup-138-additional의 option_refs 타깃(OPT_REF_DIM.03·각목+끈+부착 MULTI-BUNDLE). uses_material에 실재(L-18). 900초과 규격은 별 자재(339)로 계획됐으나 삭제됨([[gap-138-gakmok-gt-material]]).

### [material-MAT_000069] 양면테입 (가공 번들·삭제 드리프트) {defect}
- type: material
- anchor: t_mat_materials/MAT_000069
- current_value: "MAT_000069 양면테입 마스터 del_yn=Y(2026-06-30 삭제)·그러나 상품링크(del_yn=N)+가공그룹 활성 option_item(OPV_000010)+양면테잎 추가가격 구성요소(COMP_POSTEROPT_BANNER_NORMAL_PROC_DTAPE)가 여전히 참조 {transcribed-by transcribe_product_138.py}"
- authority_value: "138 가공 그룹에 양면테입 옵션이 활성 제공되고 가격이 배선되므로, 자재 마스터가 활성(del_yn=N)이어야 하거나 옵션/가격 배선을 함께 정리해야 함(실무진 결정·재연결 vs 옵션 은퇴)"
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "테이블:t_mat_materials 키:MAT_000069(mat_nm=양면테입·mat_typ_cd=MAT_TYPE.07·del_yn=Y·del_dt 2026-06-30·note D9-1)", captured_at: "live 20260702_1119", badge: defect, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_option_items.csv", source_locator: "키:(PRD_000138,OPV_000010,item1) ref_dim_cd=OPT_REF_DIM.03·ref_key1=MAT_000069·use_yn=Y·del_yn=N", captured_at: "live 20260702_1119", badge: defect, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.07", 상태: "마스터 삭제 vs item 참조 잔존(드리프트)", note: "★양면 노드 — 어느 한쪽 삭제 금지(D-9). uses_material 링크 활성이라 L-18 부모정합은 통과"}
- 본문: 양면테입 가공 옵션의 자재. ★마스터가 06-30 논리삭제됐는데 활성 option_item·가격 구성요소가 참조하는 **삭제 마스터 드리프트**. 현재값(마스터 del) vs 정답(재연결 또는 옵션 정리) 양면 표기. optgroup-138-processing의 option_refs 타깃. 값 판단 아님 — 참조 무결성 관찰.

### [material-MAT_000340] 봉제사 (봉미싱 번들·삭제 드리프트) {defect}
- type: material
- anchor: t_mat_materials/MAT_000340
- current_value: "MAT_000340 봉제사 마스터 del_yn=Y(2026-06-27 삭제)·그러나 상품링크(del_yn=N)+가공그룹 활성 option_item(OPV_000011 봉미싱)+봉미싱 추가가격 구성요소(COMP_POSTEROPT_BANNER_NORMAL_PROC_BONGSEW)가 여전히 참조 {transcribed-by transcribe_product_138.py}"
- authority_value: "138 가공 그룹에 봉미싱 옵션이 활성 제공되고 가격이 배선되므로, 자재 마스터가 활성이어야 하거나 옵션/가격을 함께 정리해야 함(실무진 결정·D② 실=자재 확정 이력이 있으나 이후 삭제됨)"
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "테이블:t_mat_materials 키:MAT_000340(mat_nm=봉제사·mat_typ_cd=MAT_TYPE.07·del_yn=Y·del_dt 2026-06-27·note 'silsa 봉미싱 옵션 자재·소모성 미등록 후보 철회')", captured_at: "live 20260702_1119", badge: defect, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_option_items.csv", source_locator: "키:(PRD_000138,OPV_000011,item1) ref_dim_cd=OPT_REF_DIM.03·ref_key1=MAT_000340·use_yn=Y·del_yn=N", captured_at: "live 20260702_1119", badge: defect, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.07", 상태: "마스터 삭제 vs item 참조 잔존(드리프트)", note: "★양면 노드. 봉미싱=자재(봉제사)+공정(봉제 PROC_000080) BUNDLE. uses_material 링크 활성이라 L-18 통과"}
- 본문: 봉미싱 가공 옵션의 자재(봉제용 실). ★마스터가 06-27 논리삭제됐는데 활성 option_item·가격 구성요소가 참조하는 삭제 마스터 드리프트. 현재값 vs 정답 양면. optgroup-138-processing의 option_refs 타깃(봉제 PROC_000080과 BUNDLE).

## 공정 노드 (product-local — 후가공·삭제 드리프트 1 defect·needed_shared)

<!-- ★138 후가공=봉제(봉미싱)/부착(끈·테입)/현수막타공(079 대체)·열재단(마스터 삭제 드리프트=defect). 실사 인쇄방식(PROC_000006)은 138 행 없음(정당). 타공079는 상품링크 삭제(104로 교체)라 노드 미생성. -->

<!-- ★process-PROC_000080(봉제)은 병렬 실사 빌더 product-125-canvas-fabric-poster-nodes.md가 canonical 소유(134/137도 재사용). -->
<!-- 138은 has_process·option_refs로 참조만(재정의 시 L-3 중복 id). 봉미싱 옵션(OPV_000011)이 유형=봉미싱으로 이 공정 참조. -->
<!-- [[product-138-standard-hanging-banner]] has_process → process-PROC_000080(125 정의)로 배선(L-15 실재·L-18 부모정합). needed_shared_nodes 반환. -->
<!-- process-PROC_000080 참조 유지: [[process-PROC_000080]] -->

### [process-PROC_000081] 부착 {verified}
- type: process
- anchor: t_proc_processes/PROC_000081
- src: {source_file: "live-snapshot/latest/t_proc_processes.csv", source_locator: "테이블:t_proc_processes 키:PROC_000081(proc_nm=부착·prcs_dtl_opt 대상 enum[라벨/맥세이프/끈/테입]·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_processes.csv", source_locator: "키:(PRD_000138,PROC_000081) mand_proc_yn=N·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mand_proc_yn: "N", prcs_dtl_opt: "대상 enum[라벨/맥세이프/끈/테입]", note: "부착 공정. 끈/양면테입/큐방/각목 옵션 BUNDLE의 공정 반쪽. ★대상 enum에 '큐방' 부재(큐방 옵션 CONFIRM 잔존·pack)"}
- 본문: 부착 후가공(대상별). 끈·양면테입·큐방·각목+끈 옵션의 공정 반쪽(자재+공정 BUNDLE·pack §3.9). optgroup-138-processing/additional의 option_refs 타깃(OPT_REF_DIM.04). has_process에 실재(L-18).

### [process-PROC_000104] 현수막타공 {verified}
- type: process
- anchor: t_proc_processes/PROC_000104
- src: {source_file: "live-snapshot/latest/t_proc_processes.csv", source_locator: "테이블:t_proc_processes 키:PROC_000104(proc_nm=현수막타공·prcs_dtl_opt 타공수 integer 0~8·del_yn=N·06-22 신설)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_processes.csv", source_locator: "키:(PRD_000138,PROC_000104) mand_proc_yn=N·del_yn=N(06-22 079 교체)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mand_proc_yn: "N", prcs_dtl_opt: "타공수 integer 0~8(개)", note: "현수막타공. 구 타공 PROC_000079를 상품에서 06-22 교체(079는 상품링크 del·마스터는 유지). 타공4/6/8 옵션(OPV_000007/008/009)이 dtl_opt {타공수:N}으로 참조"}
- 본문: 현수막 타공 후가공(타공수 param). 타공(4/6/8개) 옵션이 이 공정을 dtl_opt로 참조. optgroup-138-processing의 option_refs 타깃(OPT_REF_DIM.04). has_process에 실재(L-18). 가격=PROC_PUNCH_4 구성요소(proc_grp:PROC_000104).

### [process-PROC_000084] 열재단 (가공 기본값·삭제 드리프트) {defect}
- type: process
- anchor: t_proc_processes/PROC_000084
- current_value: "PROC_000084 열재단 마스터 del_yn=Y(2026-06-30 삭제)·그러나 상품링크(del_yn=N)+가공 필수그룹의 기본값 option_item(OPV_000006·dflt_yn=Y)+열재단 추가가격 구성요소(COMP_POSTEROPT_BANNER_NORMAL_PROC_CUTEDGE)가 여전히 참조 {transcribed-by transcribe_product_138.py}"
- authority_value: "열재단은 가공(OPT_000003·mand min1/max1) 필수그룹의 기본 선택지이므로 마스터가 활성(del_yn=N)이어야 함 — 삭제 상태면 기본 옵션의 공정 참조가 끊김(실무진 복원/정리 대기)"
- src: {source_file: "live-snapshot/latest/t_proc_processes.csv", source_locator: "테이블:t_proc_processes 키:PROC_000084(proc_nm=열재단·del_yn=Y·del_dt 2026-06-30·note 'silsa 열재단·flat(param 없음)')", captured_at: "live 20260702_1119", badge: defect, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_option_items.csv", source_locator: "키:(PRD_000138,OPV_000006,item1) ref_dim_cd=OPT_REF_DIM.04·ref_key1=PROC_000084·use_yn=Y·del_yn=N", captured_at: "live 20260702_1119", badge: defect, src_id: SR-5-livesnap}
- props: {mand_proc_yn: "N", 상태: "마스터 삭제 vs 필수그룹 기본값 item 참조 잔존(드리프트)", note: "★양면 노드 — 가공 필수그룹 기본 선택지라 영향 큼. has_process 링크 활성이라 L-18 통과·anchor 코드는 스냅샷에 실재(del_yn=Y·L-17 존재)"}
- 본문: 열재단 후가공(천 자체 열절단·순수 공정·추가 자재 없음). ★가공 필수그룹(OPT_000003)의 **기본값**인데 마스터가 06-30 논리삭제된 드리프트. 현재값(마스터 del) vs 정답(활성이어야 함) 양면. optgroup-138-processing의 option_refs 타깃. 필수그룹 기본이라 우선 확인 대상.

## 수량규칙 노드 (product-local)

### [qty-138] 일반현수막 수량규칙 {verified}
- type: bundle_qty
- anchor: t_prd_products/PRD_000138
- src: {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "키:PRD_000138 min_qty/max_qty/qty_incr(1/10000/1)·qty_unit_typ_cd=QTY_UNIT.01", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/_foundation/batch/qty_rule_audit_260702.py", source_locator: "수량 UI 권위=상품/사이즈 규칙(가격구간과 역할 분리)", captured_at: "2026-07-03", badge: verified, src_id: SR-27-qtyaudit}
- props: {min_max_incr_ref: "전사표 수량규칙(상품 1/10000/1)", bdl_unit_typ_cd: "QTY_UNIT.01", bundle_qtys_rows: 0, note: "★base 면적매트릭스 단가행에 min_qty 채워짐(수량축충전 True)이나 전부=1(수량무관 통가격). 셀단가=현수막1장가·총액=셀×수량(수량구간 할인 없음)"}
- 본문: 수량 그릇 = 상품 마스터 컬럼(min 1·max 10000·incr 1). t_prd_product_bundle_qtys 0행 정상(수량 UI 권위=상품 레벨·[[rule/decisions#DEC_qty_audit_260702]]). 가격은 수량 무관 통가격.

## 가격공식 노드 (product-local — silsa formula 축 승격 대기·9 구성요소 배선)

<!-- ★면적매트릭스형+CPQ. base(seq1) 완제품가 + 옵션 추가가격 8종(seq2~9)을 has_component로 배선. 118(단일 comp)과 다른 복합 공식. -->

### [formula-PRF_POSTER_BANNER_N] 일반현수막 완제품가 (면적/규격 단가 + 옵션 추가가격) {verified}
- type: price_formula
- anchor: t_prc_price_formulas/PRF_POSTER_BANNER_N
- src: {source_file: "live-snapshot/latest/t_prc_price_formulas.csv", source_locator: "테이블:t_prc_price_formulas 키:PRF_POSTER_BANNER_N(frm_nm=일반현수막 완제품가(면적/규격 단가)·use_yn=Y)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prc_formula_components.csv", source_locator: "frm_cd:PRF_POSTER_BANNER_N(9 구성요소·seq1 base + seq2~9 옵션 추가가격·전부 addtn_yn=Y)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_price_formulas.csv", source_locator: "키:(PRD_000138,PRF_POSTER_BANNER_N) 바인딩(apply_bgn 2026-06-01)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: has_component, target: component-COMP_POSTER_BANNER_NORMAL, qualifier: {disp_seq: 1, addtn: Y}, note: "base 면적매트릭스"}
- rel: {rel: has_component, target: component-COMP_POSTEROPT_BANNER_NORMAL_PROC_PUNCH_4, qualifier: {disp_seq: 2, addtn: Y}, note: "타공 추가가격"}
- rel: {rel: has_component, target: component-COMP_POSTEROPT_BANNER_NORMAL_PROC_CUTEDGE, qualifier: {disp_seq: 3, addtn: Y}, note: "열재단 추가가격"}
- rel: {rel: has_component, target: component-COMP_POSTEROPT_BANNER_NORMAL_PROC_DTAPE, qualifier: {disp_seq: 4, addtn: Y}, note: "양면테잎 추가가격"}
- rel: {rel: has_component, target: component-COMP_POSTEROPT_BANNER_NORMAL_PROC_BONGSEW, qualifier: {disp_seq: 5, addtn: Y}, note: "봉미싱 추가가격"}
- rel: {rel: has_component, target: component-COMP_POSTEROPT_BANNER_NORMAL_ADD_QBANG_4, qualifier: {disp_seq: 6, addtn: Y}, note: "큐방 추가가격"}
- rel: {rel: has_component, target: component-COMP_POSTEROPT_BANNER_NORMAL_ADD_STRING_4, qualifier: {disp_seq: 7, addtn: Y}, note: "끈 추가가격"}
- rel: {rel: has_component, target: component-COMP_POPT_BNR_GAKMOK_STR_900_4_LE, qualifier: {disp_seq: 8, addtn: Y}, note: "각목900이하+끈"}
- rel: {rel: has_component, target: component-COMP_POPT_BNR_GAKMOK_STR_900_4_GT, qualifier: {disp_seq: 9, addtn: Y}, note: "각목900초과+끈"}
- props: {archetype: "면적매트릭스형+CPQ(base [단독] + 옵션 추가가격 8종)", use_yn: Y, note: "138 바인딩 전용. base(seq1)를 가로×세로 셀에서 조회 + 선택 옵션 추가가격 합산(evaluate_price). off-grid=ceiling(앱)"}
- 본문: 일반현수막 가격공식. 9 구성요소 배선 — seq1 base 면적매트릭스([[component-COMP_POSTER_BANNER_NORMAL]]) 완제품 통가격 + seq2~9 선택 가공/추가 옵션 추가가격. 118(단일 comp)보다 복잡한 base+addon 합산 구조. 값 계산=evaluate_price 권위(D-18·[[rule/rules#RULE_price_value_boundary]]).

## 가격구성요소 노드 (product-local — base 1 + 옵션 추가가격 8·단가행 접기 D-22·값 미전사)

<!-- ★COMP_POSTER_BANNER_NORMAL = comp note "[단독] 동형 없음"(118 동형결합 4소재와 다름). 현수막천 단일이라 소재축 없음. -->
<!-- ★단가행(base 81셀·옵션 1~3행)은 노드로 펼치지 않고 use_dims 차원+행수로 접음(D-22). 값(unit_price)은 미전사(evaluate_price 권위). -->

### [component-COMP_POSTER_BANNER_NORMAL] 실사 완제품가 (일반현수막·면적매트릭스·[단독]) {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_POSTER_BANNER_NORMAL
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "테이블:t_prc_price_components 키:COMP_POSTER_BANNER_NORMAL(comp_nm=실사 완제품가(일반현수막)·comp_typ=PRC_COMPONENT_TYPE.06·prc_typ_cd=PRICE_TYPE.01·use_dims=[siz_width,siz_height]·note '[단독] 동형 없음·79셀')", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.01", comp_typ_cd: "PRC_COMPONENT_TYPE.06", use_dims: '["siz_width", "siz_height"]', role: "현수막 완제품 base 통가격([단독]·소재축 없음·현수막천 단일)", 단가행_ref: "전사표 base SHAPE(가로5×세로16=80셀·81행 1중복·격자완전 True·수량무관)", archetype: "면적매트릭스(area-matrix·off-grid ceiling=앱)"}
- 본문: 일반현수막 완제품 base 가격구성요소. use_dims 2축(가로 siz_width × 세로 siz_height)으로 셀단가가 달라진다(차원 선언까지·D-22 단가행 접기). ★118의 동형결합(4소재 공유)과 달리 [단독](소재 통합 없음). 값=evaluate_price(값·골든 미전사·D-18·[[rule/rules#RULE_price_value_boundary]]). base 셀단가 산정=롤 소재 암묵지([[gap-138-roll-price-logic]]).

### [component-COMP_POSTEROPT_BANNER_NORMAL_PROC_PUNCH_4] 타공 추가가격 {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_POSTEROPT_BANNER_NORMAL_PROC_PUNCH_4
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "테이블:t_prc_price_components 키:COMP_POSTEROPT_BANNER_NORMAL_PROC_PUNCH_4(comp_nm=일반현수막 타공(4개) 추가가격·use_dims=[proc_cd,min_qty,proc_grp:PROC_000104]·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.01", use_dims: '["proc_cd", "min_qty", "proc_grp:PROC_000104"]', 단가행_ref: "전사표 3행", note: "타공(4/6/8개) 추가가격. proc_grp:PROC_000104로 현수막타공 참조. 구 PUNCH_6/8 comp은 del(104 그룹으로 통합)"}
- 본문: 타공 옵션의 추가가격 구성요소(현수막타공 공정 그룹 기준). PRF_POSTER_BANNER_N seq2 배선. 값=evaluate_price(D-18).

### [component-COMP_POSTEROPT_BANNER_NORMAL_PROC_CUTEDGE] 열재단 추가가격 {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_POSTEROPT_BANNER_NORMAL_PROC_CUTEDGE
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "테이블:t_prc_price_components 키:COMP_POSTEROPT_BANNER_NORMAL_PROC_CUTEDGE(comp_nm=일반현수막 열재단 추가가격·use_dims=[opt_cd,opt_grp:OPT_000003]·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.01", use_dims: '["opt_cd", "opt_grp:OPT_000003"]', 단가행_ref: "전사표 1행", note: "열재단(가공 기본값) 추가가격. opt_grp:OPT_000003(가공) 기준. 참조 공정 열재단=삭제 드리프트([[process-PROC_000084]])"}
- 본문: 열재단 옵션의 추가가격 구성요소(가공 그룹 기준). PRF_POSTER_BANNER_N seq3 배선. 값=evaluate_price(D-18).

### [component-COMP_POSTEROPT_BANNER_NORMAL_PROC_DTAPE] 양면테잎 추가가격 {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_POSTEROPT_BANNER_NORMAL_PROC_DTAPE
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "테이블:t_prc_price_components 키:COMP_POSTEROPT_BANNER_NORMAL_PROC_DTAPE(comp_nm=일반현수막 양면테잎 추가가격·use_dims=[opt_cd,opt_grp:OPT_000003]·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.01", use_dims: '["opt_cd", "opt_grp:OPT_000003"]', 단가행_ref: "전사표 1행", note: "양면테입(가공) 추가가격. 참조 자재 양면테입=삭제 드리프트([[material-MAT_000069]])"}
- 본문: 양면테잎 옵션의 추가가격 구성요소(가공 그룹 기준). PRF_POSTER_BANNER_N seq4 배선. 값=evaluate_price(D-18).

### [component-COMP_POSTEROPT_BANNER_NORMAL_PROC_BONGSEW] 봉미싱 추가가격 {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_POSTEROPT_BANNER_NORMAL_PROC_BONGSEW
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "테이블:t_prc_price_components 키:COMP_POSTEROPT_BANNER_NORMAL_PROC_BONGSEW(comp_nm=일반현수막 봉미싱 추가가격·use_dims=[opt_cd,opt_grp:OPT_000003]·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.01", use_dims: '["opt_cd", "opt_grp:OPT_000003"]', 단가행_ref: "전사표 1행", note: "봉미싱(가공) 추가가격. 봉제 PROC_000080 + 봉제사 MAT_000340(삭제 드리프트) BUNDLE"}
- 본문: 봉미싱 옵션의 추가가격 구성요소(가공 그룹 기준). PRF_POSTER_BANNER_N seq5 배선. 값=evaluate_price(D-18).

### [component-COMP_POSTEROPT_BANNER_NORMAL_ADD_QBANG_4] 큐방 추가가격 {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_POSTEROPT_BANNER_NORMAL_ADD_QBANG_4
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "테이블:t_prc_price_components 키:COMP_POSTEROPT_BANNER_NORMAL_ADD_QBANG_4(comp_nm=일반현수막 큐방(4개) 추가가격·use_dims=[opt_cd,opt_grp:OPT_000004]·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.01", use_dims: '["opt_cd", "opt_grp:OPT_000004"]', 단가행_ref: "전사표 1행", note: "큐방(추가 그룹) 추가가격. 큐방 MAT_000337 + 부착 PROC_000081 BUNDLE"}
- 본문: 큐방 옵션의 추가가격 구성요소(추가 그룹 기준). PRF_POSTER_BANNER_N seq6 배선. 값=evaluate_price(D-18).

### [component-COMP_POSTEROPT_BANNER_NORMAL_ADD_STRING_4] 끈 추가가격 {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_POSTEROPT_BANNER_NORMAL_ADD_STRING_4
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "테이블:t_prc_price_components 키:COMP_POSTEROPT_BANNER_NORMAL_ADD_STRING_4(comp_nm=일반현수막 끈(4개) 추가가격·use_dims=[opt_cd,opt_grp:OPT_000004]·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.01", use_dims: '["opt_cd", "opt_grp:OPT_000004"]', 단가행_ref: "전사표 1행", note: "끈(추가 그룹) 추가가격. 끈 MAT_000070 + 부착 PROC_000081 BUNDLE"}
- 본문: 끈 옵션의 추가가격 구성요소(추가 그룹 기준). PRF_POSTER_BANNER_N seq7 배선. 값=evaluate_price(D-18).

### [component-COMP_POPT_BNR_GAKMOK_STR_900_4_LE] 각목900이하+끈 추가가격 {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_POPT_BNR_GAKMOK_STR_900_4_LE
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "테이블:t_prc_price_components 키:COMP_POPT_BNR_GAKMOK_STR_900_4_LE(comp_nm=현수막 각목(900mm이하)+끈(4개) 추가가격·use_dims=[opt_cd,opt_grp:OPT_000004]·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.01", use_dims: '["opt_cd", "opt_grp:OPT_000004"]', 단가행_ref: "전사표 1행", note: "각목900이하+끈(추가 그룹). 각목 MAT_000338 + 끈 MAT_000070 + 부착 PROC_000081 MULTI-BUNDLE"}
- 본문: 각목(900이하)+끈 옵션의 추가가격 구성요소(추가 그룹 기준). PRF_POSTER_BANNER_N seq8 배선. 값=evaluate_price(D-18).

### [component-COMP_POPT_BNR_GAKMOK_STR_900_4_GT] 각목900초과+끈 추가가격 {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_POPT_BNR_GAKMOK_STR_900_4_GT
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "테이블:t_prc_price_components 키:COMP_POPT_BNR_GAKMOK_STR_900_4_GT(comp_nm=현수막 각목(900mm 초과)+끈(4개) 추가가격·use_dims=[opt_cd,opt_grp:OPT_000004]·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.01", use_dims: '["opt_cd", "opt_grp:OPT_000004"]', 단가행_ref: "전사표 1행", note: "각목900초과+끈(추가 그룹). ★참조 자재가 각목900초과(MAT_000339 삭제) 대신 900이하(MAT_000338)로 드리프트=[[gap-138-gakmok-gt-material]]"}
- 본문: 각목(900초과)+끈 옵션의 추가가격 구성요소(추가 그룹 기준). PRF_POSTER_BANNER_N seq9 배선. 900초과 각목 자재 삭제 드리프트 주의([[gap-138-gakmok-gt-material]]). 값=evaluate_price(D-18).

## 옵션그룹 노드 (CPQ — 라이브 최초 실사 옵션 레이어 og=3·oi=18)

<!-- ★138 CPQ 3그룹: 가공(mand 택1)·추가(선택 택1)·각목부착변(UX 택1·option_item 없음). option_refs는 같은 부모 차원(uses_material/has_process)에 실재해야 L-18 통과. -->

### [optgroup-138-processing] 가공 (열재단/타공/양면테입/봉미싱·택1 필수) {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000138
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "키:PRD_000138 opt_grp_cd:OPT_000003(가공·SEL_TYPE.01·min_sel=1·max_sel=1·mand_yn=Y·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_options.csv", source_locator: "키:PRD_000138 OPT_000003 (OPV_000006 열재단 dflt/OPV_000007·008·009 타공4·6·8/OPV_000010 양면테입/OPV_000011 봉미싱)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_option_items.csv", source_locator: "키:PRD_000138 (열재단→PROC_000084·타공→PROC_000104{타공수}·양면테입→MAT_000069+PROC_000081·봉미싱→MAT_000340+PROC_000080)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: option_refs, target: process-PROC_000084, ref_key1: PROC_000084, note: "열재단(OPV_000006·기본값)→공정(삭제 드리프트)"}
- rel: {rel: option_refs, target: process-PROC_000104, ref_key1: PROC_000104, note: "타공4/6/8(OPV_000007~009)→현수막타공(dtl_opt 타공수)"}
- rel: {rel: option_refs, target: material-MAT_000069, ref_key1: MAT_000069, note: "양면테입(OPV_000010)→자재(삭제 드리프트)"}
- rel: {rel: option_refs, target: process-PROC_000081, ref_key1: PROC_000081, note: "양면테입 부착→공정"}
- rel: {rel: option_refs, target: material-MAT_000340, ref_key1: MAT_000340, note: "봉미싱(OPV_000011)→봉제사 자재(삭제 드리프트)"}
- rel: {rel: option_refs, target: process-PROC_000080, ref_key1: PROC_000080, note: "봉미싱→봉제 공정"}
- props: {opt_grp_cd: "OPT_000003", sel_typ_cd: "SEL_TYPE.01", mand_yn: "Y", 옵션값: "열재단(기본)/타공4·6·8/양면테입/봉미싱(택1 필수)", ref_dim: "OPT_REF_DIM.03 자재 + OPT_REF_DIM.04 공정(옵션=자재+공정 BUNDLE)", note: "★가공 필수그룹 기본값 열재단의 공정 마스터 삭제 드리프트([[process-PROC_000084]])"}
- 본문: 손님이 가공을 고르는 CPQ 옵션(택1 필수). 각 item이 공정(OPT_REF_DIM.04)·자재(OPT_REF_DIM.03)를 polymorphic 참조해 has_process·uses_material 차원으로 환원(R11·L-18 부모정합 통과). 가격=열재단/양면테입/봉미싱 각 추가가격 구성요소. ★삭제 마스터 드리프트 3건(열재단 PROC_000084·양면테입 MAT_000069·봉제사 MAT_000340)이 이 그룹에 몰림.

### [optgroup-138-additional] 추가 (큐방/끈/각목+끈·택1 선택) {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000138
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "키:PRD_000138 opt_grp_cd:OPT_000004(추가·SEL_TYPE.01·min_sel=0·max_sel=1·mand_yn=N·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_options.csv", source_locator: "키:PRD_000138 OPT_000004 (OPV_000012 추가없음 dflt 센티넬/OPV_000013 큐방/OPV_000014 끈/OPV_000015 각목900이하+끈/OPV_000016 각목900초과+끈)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_option_items.csv", source_locator: "키:PRD_000138 (큐방→MAT_000337+PROC_000081·끈→MAT_000070+PROC_000081·각목→MAT_000338+MAT_000070+PROC_000081)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: option_refs, target: material-MAT_000337, ref_key1: MAT_000337, note: "큐방(OPV_000013)→자재(qty 4)"}
- rel: {rel: option_refs, target: material-MAT_000070, ref_key1: MAT_000070, note: "끈(OPV_000014/015/016)→자재"}
- rel: {rel: option_refs, target: material-MAT_000338, ref_key1: MAT_000338, note: "각목900이하(OPV_000015)→자재(900초과 OPV_000016도 이 338 참조=드리프트)"}
- rel: {rel: option_refs, target: process-PROC_000081, ref_key1: PROC_000081, note: "부착 공정(큐방/끈/각목 공통)"}
- props: {opt_grp_cd: "OPT_000004", sel_typ_cd: "SEL_TYPE.01", mand_yn: "N", 옵션값: "추가없음(센티넬)/큐방/끈/각목900이하+끈/각목900초과+끈(택1 선택)", ref_dim: "OPT_REF_DIM.03 자재 + OPT_REF_DIM.04 공정 BUNDLE", note: "추가없음(OPV_000012)=option_item 0행 센티넬. 각목900초과=자재 드리프트([[gap-138-gakmok-gt-material]])"}
- 본문: 손님이 부속 추가를 고르는 CPQ 옵션(택1 선택·기본 추가없음). item이 자재+공정 BUNDLE을 참조해 차원 환원(L-18 통과). 가격=큐방/끈/각목+끈 각 추가가격 구성요소. 각목 900초과 옵션의 자재 참조 드리프트 주의.

### [optgroup-138-gakmok-side] 각목 부착 변 (세로변/가로변·UX 선택) {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000138
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "키:PRD_000138 opt_grp_cd:OPT_000063(각목 부착 변·SEL_TYPE.01·min_sel=0·max_sel=1·mand_yn=N·use_yn=Y·del_yn=N·06-23 신설)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_options.csv", source_locator: "키:PRD_000138 OPT_000063 (OPV_000432 세로변부착(좌우)/OPV_000433 가로변부착(상하))·option_item 0행", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {opt_grp_cd: "OPT_000063", sel_typ_cd: "SEL_TYPE.01", mand_yn: "N", 옵션값: "세로변부착(좌우)/가로변부착(상하)", ref_dim: "없음(option_item 0행·차원 참조 없음)", note: "★UX/생산메타 선택만 — 각목을 어느 변에 붙일지. 가격·차원 영향 없음(추가가격 구성요소 미배선). 부착변 유효성 제약 미표현=[[gap-138-nonspec-no-constraint]] 범위"}
- 본문: 각목을 세로변/가로변 중 어디에 부착할지 고르는 UX 선택(option_item 0행·차원 참조 없음). 가격 구성요소·제약으로 표현되지 않은 순수 생산 메타. option_refs 없음(L-18 공허 통과). 각목 추가(OPT_000004) 선택 시에만 의미(조건 관계는 제약 미등록=GAP).

## GAP 노드 (원천 부재·정직 선언 — 3)

### [gap-138-roll-price-logic] 롤 소재 base 셀단가 산정 로직 {unknown}
- type: gap
- anchor: none  # 사유: 롤(대형롤) 현수막천 완제품 base 셀단가 도출 규칙이 어느 엑셀/문서에도 명시 없음(암묵지)
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/source-registry.md", source_locator: "문서:§9 GAP-2 롤 소재 가격 계산 로직(엑셀 미기재 암묵지·실사 전체 영향)", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-silsa}
- gap_what: "base 면적매트릭스 80셀(81행) 완제품 통가격이 롤 원가/폭/마진 어떤 규칙으로 도출됐는지 — 값은 라이브 적재됐으나 산정 근거 문서 부재(실사 전체 공통 GAP)"
- gap_fill_from: "실무진 확인(source-registry §9 GAP-2). 예전사이트 골든 대조로 값 정합 검증 가능하나 산정식 자체는 암묵지"
- gap_owner: staff
- 본문: 가격 경로는 연결됨([[formula-PRF_POSTER_BANNER_N]]→[[component-COMP_POSTER_BANNER_NORMAL]]·80셀 완전격자)이라 견적 0 위험 없음. 셀단가가 **어떻게** 산정됐는지는 엑셀 미기재 암묵지(실사 공통). 온톨로지는 연결·차원까지, 값 계산은 evaluate_price 권위이므로 이 GAP은 "산정 근거 문서 부재"의 정직 선언.

### [gap-138-nonspec-no-constraint] 비규격 치수 범위·부착변 제약 미표현 {unknown}
- type: gap
- anchor: none  # 사유: 138 constraints 0행 — nonspec 치수 범위/각목 부착변 유효성이 제약규칙으로 표현되지 않음(라이브 실측)
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "문서:§3.9·§4 SL-CPQ-003(138은 여전히 constraints 0행·비치수 수치 범위 표현 불가 GAP 잔존) + GAP-SL-7 비치수 수치 범위 검증처", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-silsa}
- gap_what: "138은 constraints 0행(t_prd_product_constraints 실측) — 비규격 입력 치수 범위(가로 500~1750·세로 500~5000)와 각목 부착변(OPT_000063) 유효성이 제약규칙으로 검증되지 않음. 118/122는 RULE_001 치수범위 제약 보유(신규발현 7상품)이나 138은 미발현"
- gap_fill_from: "§31 제약규칙 하네스(CN-5 범위형·폼빌더 정형 shape) + 실무진(비치수 수치 범위 검증처 Q-SL-7 — products 범위 컬럼+앱 vs 비표준 var vs 앱 런타임)"
- gap_owner: staff
- 본문: ★[REVERIFY] 위키 "실사 constraints 전부 0행"은 다른 6상품엔 STALE이나 **138에 한해 0행이 현재값이자 사실**(pack §1.1·§4). 비규격 치수 범위·각목 부착변 유효성 제약 미표현이 잔존 GAP(GAP-SL-7). 가격 경로와 무관(견적 0 위험 없음) — 입력 검증 강제처 미확정의 정직 선언.

### [gap-138-gakmok-gt-material] 각목900초과 자재 삭제 후 미대체 {unknown}
- type: gap
- anchor: none  # 사유: 각목900초과 자재(MAT_000339) 완전 삭제 후, 900초과 옵션(OPV_000016)이 900이하 자재(MAT_000338)를 참조하는 드리프트 — 대체 자재/모델 미확정
- src: {source_file: "live-snapshot/latest/t_prd_product_option_items.csv", source_locator: "키:(PRD_000138,OPV_000016,item1) ref_key1=MAT_000338(각목900이하)·MAT_000339(각목900초과) del_yn=Y 완전삭제", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "문서:§3.12 GAP-SL-5(끈/각목 BUNDLE 자재 mint·각목 2규격 모델 900이하/초과)", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-silsa}
- gap_what: "각목 2규격(900이하 MAT_000338·900초과 MAT_000339) 모델에서 900초과 자재가 삭제(del_yn=Y)됐는데 900초과 옵션(OPV_000016)+가격 구성요소(COMP_POPT_BNR_GAKMOK_STR_900_4_GT)는 유지 — item이 900이하 자재(338)를 참조하는 드리프트. 900초과가 별 자재를 다시 가져야 하는지 단일 모델로 갈지 미확정"
- gap_fill_from: "실무진(각목 2규격 모델 vs 단일·pack §3.12 GAP-SL-5 D-2 적용결정 재검토) + §7 dbmap 자재 mint 트랙"
- gap_owner: staff
- 본문: 각목 900초과 옵션은 활성이나 그 자재(MAT_000339)가 삭제돼 900이하 자재를 참조하는 참조 드리프트. 가격 구성요소([[component-COMP_POPT_BNR_GAKMOK_STR_900_4_GT]])는 배선돼 있어 견적은 나오나 자재 정체가 900이하와 뒤섞임. 900초과 각목의 자재 모델 미확정의 정직 선언.
