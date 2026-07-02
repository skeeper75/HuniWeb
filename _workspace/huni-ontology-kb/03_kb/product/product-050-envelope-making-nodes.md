<!-- product-local sub-nodes: E3 size·E4 material·E2 category·E9 price_formula·E10 price_component·E11 option_group for PRD_000050 봉투제작. -->
<!-- ★이 파일의 size(SIZ_000191~194)·material(MAT_000159/168/169)·category(CAT_000065)는 라이브 마스터 원자라 본래 -->
<!--   공유 축(axis/sizes.md·axis/materials.md·axis/categories.md) 소속이고, formula(PRF_ENV_MAKING)·component -->
<!--   (COMP_ENV_MAKING)은 formula/digital-formulas.md·formula/digital-components.md 소속이나, 공유 파일 수정 -->
<!--   금지 규칙(HARD) 때문에 여기 임시 거처(broken-link 방지·046-nodes 선례 동일). 축 소유자가 승격 시 -->
<!--   canonical id 그대로 이관(삭제) — needed_shared_nodes로 반환. -->
<!-- ★수치(치수·평량·수량·매트릭스 shape)는 아래 전사표(transcribed-by·transcribe_product_050.py)에만. props raw 미기입(D-9·L-12). -->
<!-- ★가격 값(unit_price)은 전사하지 않음 — 연결·차원까지만(D-18·값=evaluate_price). -->

# product-050 하위 노드 (봉투제작 전용 축 원자 + 공식/구성요소)

봉투제작(PRD_000050)이 쓰는 봉투종류 사이즈 4행·전용 자재 3종·소속 부카테고리·가격공식·완제품가
구성요소·봉투옵션 그룹. 상품→축 연결(has_size·uses_material·in_category·priced_by·has_option_group)은
[[product-050-envelope-making]]가 건다. 공식→구성요소 배선(has_component)은 아래 formula 블록.

## 치수·자재·수량·가격매트릭스 전사표 (권위 = 라이브 마스터)

<!-- transcribed-by: _meta/scripts/transcribe_product_050.py from live-snapshot/latest (snap_20260702_1119) t_siz_sizes PRD_000050 @ 2026-07-03 -->
| siz_cd | 라벨 | 작업(work mm) | 조판(impos_yn) |
|---|---|---|---|
| SIZ_000191 | 225x193 | 225x193 | N |
| SIZ_000192 | 238x262 | 238x262 | N |
| SIZ_000193 | 262x238 | 262x238 | N |
| SIZ_000194 | 510x387 | 510x387 | N |

<!-- transcribed-by: _meta/scripts/transcribe_product_050.py from live-snapshot/latest (snap_20260702_1119) t_mat_materials PRD_000050 @ 2026-07-03 -->
| mat_cd | 자재명 | mat_typ | 상위자재 | 평량(g) |
|---|---|---|---|---|
| MAT_000159 | 모조 120g | MAT_TYPE.01 | MAT_000157 | 120 |
| MAT_000168 | 레자크체크백색 | MAT_TYPE.14 | - | 110 |
| MAT_000169 | 레자크줄무늬백색 | MAT_TYPE.14 | - | 110 |

<!-- transcribed-by: _meta/scripts/transcribe_product_050.py from live-snapshot/latest (snap_20260702_1119) t_prd_products PRD_000050 @ 2026-07-03 -->
| min_qty | max_qty | qty_incr | 단위 |
|---|---|---|---|
| 1000 | 5000 | 1000 | QTY_UNIT.02 |

<!-- transcribed-by: _meta/scripts/transcribe_product_050.py from live-snapshot/latest (snap_20260702_1119) t_prc_component_prices COMP_ENV_MAKING(SHAPE·값 미전사) @ 2026-07-03 -->
| comp_cd | 차원(use_dims) | 사이즈 | 자재 | 수량구간 | 단가행수 | 격자완전 |
|---|---|---|---|---|---|---|
| COMP_ENV_MAKING | siz_cd×mat_cd×min_qty | 4 | 3 | 1000/2000/3000/4000/5000 | 60 | True |

> **격자완전(grid_full)=True** = 4 사이즈 × 3 자재 × 5 수량구간 = 60 단가행이 이 빠짐 없이 채워짐
> (미적재 셀 0). 봉투옵션·자재·수량 어떤 조합을 골라도 단가가 조회되어 **견적 0/최소가 위험 없음**.
> 가격 값은 이 표에 없다(연결·격자완전성만 기록·값=evaluate_price 권위·D-18).

## 사이즈 노드 (product-local — 축 승격 대기·봉투 "종류"가 곧 사이즈)

<!-- 봉투제작은 사이즈 축이 곧 "봉투 종류"(티켓/소/자켓/대). 작업치수만 있고 재단·조판(impos_yn=N) 없음 -->
<!-- — 낱장 조판 인쇄가 아니라 완제품(봉투) 제작이기 때문(값=완제품가 매트릭스). -->

### [size-SIZ_000191] 225x193 (티켓봉투) {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000191
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "테이블:t_siz_sizes 키:SIZ_000191", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000191", note: "봉투종류=티켓봉투. impos_yn=N(조판 없음·완제품 제작). 봉투옵션 OPV-000028가 이 사이즈를 가리킴"}
- 본문: 티켓봉투 작업 225x193(전사표). [[product-050-envelope-making]] has_size + 봉투옵션 option_refs 대상.

### [size-SIZ_000192] 238x262 (소봉투) {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000192
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "테이블:t_siz_sizes 키:SIZ_000192", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000192", note: "봉투종류=소봉투. 봉투옵션 OPV-000030 대상"}

### [size-SIZ_000193] 262x238 (자켓봉투) {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000193
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "테이블:t_siz_sizes 키:SIZ_000193", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000193", note: "봉투종류=자켓봉투(가로세로가 소봉투와 전치). 봉투옵션 OPV-000029 대상"}

### [size-SIZ_000194] 510x387 (대봉투) {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000194
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "테이블:t_siz_sizes 키:SIZ_000194", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000194", note: "봉투종류=대봉투. 봉투옵션 OPV-000031 대상"}

## 자재 노드 (product-local — 축 승격 대기)

<!-- ★IMPORT 등록 자재 삭제 금지([[rule/rules#RULE_import_material_no_delete]]). -->
<!-- 레자크체크(168)·레자크줄무늬(169)는 단가 동일("레자크체크=줄무늬 동일단가"·라이브 note). -->
<!-- MAT_000168/169의 자식 코드 MAT_000595/596(레자크...110g)는 상품에 미바인딩(상품은 부모 168/169 바인딩·단가행도 부모 코드). -->

### [material-MAT_000159] 모조 120g {verified}
- type: material
- anchor: t_mat_materials/MAT_000159
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "테이블:t_mat_materials 키:MAT_000159", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.01", 상위자재: "MAT_000157", 사양_ref: "전사표 MAT_000159(평량 120g)", 사용: "050 봉투제작 본문(USAGE.07·dflt_yn=Y)"}
- 본문: 봉투 본문 자재(모조지 120g). parent+usage_cd 단일 슬롯(USAGE.07·팩 §3.5).

### [material-MAT_000168] 레자크체크백색 110g {verified}
- type: material
- anchor: t_mat_materials/MAT_000168
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "테이블:t_mat_materials 키:MAT_000168", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.14", 사양_ref: "전사표 MAT_000168(평량 110g)", 사용: "050 봉투제작 본문(USAGE.07)·단가=레자크줄무늬와 동일"}

### [material-MAT_000169] 레자크줄무늬백색 110g {verified}
- type: material
- anchor: t_mat_materials/MAT_000169
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "테이블:t_mat_materials 키:MAT_000169", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.14", 사양_ref: "전사표 MAT_000169(평량 110g)", 사용: "050 봉투제작 본문(USAGE.07)·단가=레자크체크와 동일"}

## 카테고리 노드 (product-local — 축 승격 대기·부카테고리)

### [category-CAT_000065] 봉투/홀더 외 {verified}
- type: category
- anchor: t_cat_categories/CAT_000065
- src: {source_file: "live-snapshot/latest/t_cat_categories.csv", source_locator: "테이블:t_cat_categories 키:CAT_000065", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {cat_nm: "봉투/홀더 외", cat_lvl: 2, upr_cat_cd: "CAT_000003", note: "050 봉투제작 부카테고리(main_cat_yn=N). 주카테고리=CAT_000003 인쇄홍보물(공유 축 실재)"}

## 가격공식 노드 (product-local — formula/digital-formulas.md 승격 대기)

<!-- ★봉투제작 = 완제품가 매트릭스형(원자합산형 아님). 원자합산형(엽서 등)은 인쇄+용지+공정을 합산하나, -->
<!--   봉투제작은 단일 완제품가 구성요소(용지 포함)를 (봉투종류×소재×수량) 표에서 조회한다. 별도 인쇄비/용지비/공정비 없음. -->

### [formula-PRF_ENV_MAKING] 봉투제작 소재/수량별 단가 (완제품가 매트릭스) {verified}
- type: price_formula
- anchor: t_prc_price_formulas/PRF_ENV_MAKING
- src: {source_file: "live-snapshot/latest/t_prc_price_formulas.csv", source_locator: "테이블:t_prc_price_formulas 키:PRF_ENV_MAKING(frm_nm=봉투제작 소재/수량별 단가·use_yn=Y)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prc_formula_components.csv", source_locator: "frm_cd:PRF_ENV_MAKING(comp COMP_ENV_MAKING·disp_seq 1·addtn Y·1행)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: has_component, target: component-COMP_ENV_MAKING, qualifier: {disp_seq: 1, addtn: Y}}
- props: {archetype: "완제품가 매트릭스(fixed-good matrix·용지포함)", use_yn: Y, note: "050 봉투제작 바인딩. 봉투종류·소재·수량 표에서 완제품가 조회(evaluate_price)"}
- 본문: 봉투제작 공식. 단일 구성요소(완제품가) 1건만 배선 — 인쇄·용지·공정을 원자 합산하지 않고 봉투 제작 완제품가를 (봉투종류×소재×수량) 매트릭스에서 조회한다. 값 계산=evaluate_price 권위(D-18·[[rule/rules#RULE_price_value_boundary]]).

## 가격구성요소 노드 (product-local — formula/digital-components.md 승격 대기)

### [component-COMP_ENV_MAKING] 봉투제작 완제품가 (용지 포함) {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_ENV_MAKING
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "테이블:t_prc_price_components 키:COMP_ENV_MAKING(comp_typ PRC_COMPONENT_TYPE.06·prc_typ PRICE_TYPE.02)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.02", use_dims: '["siz_cd", "mat_cd", "min_qty"]', role: "봉투 제작 완제품가(용지 포함)·봉투종류(siz_cd)×소재(mat_cd)×주문수량구간(min_qty) 단가표", 단가행_ref: "전사표 매트릭스 shape(60행·격자완전 True)"}
- 본문: 봉투제작 완제품가 구성요소. use_dims 3축(봉투종류·소재·수량구간)으로 단가가 달라진다(차원 선언까지·D-22 단가행 접기). 단가행 60개 격자완전([[product-050-envelope-making-nodes]] 매트릭스 전사표). 값=evaluate_price.

## 옵션그룹 노드 (CPQ)

### [optgroup-050-envelope-type] 봉투옵션 (티켓/자켓/소/대봉투) {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000050
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "테이블:t_prd_product_option_groups 키:PRD_000050 opt_grp_cd:OPT-000014(봉투옵션·SEL_TYPE.01·mand_yn=N·use_yn=Y)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_options.csv", source_locator: "키:PRD_000050 opt_grp_cd:OPT-000014 (OPV-000028 티켓봉투/OPV-000029 자켓봉투/OPV-000030 소봉투/OPV-000031 대봉투)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_option_items.csv", source_locator: "키:PRD_000050 (OPV-000028→SIZ_000191·OPV-000029→SIZ_000193·OPV-000030→SIZ_000192·OPV-000031→SIZ_000194·전부 OPT_REF_DIM.01=사이즈)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: option_refs, target: size-SIZ_000191, ref_key1: SIZ_000191, note: "티켓봉투(OPV-000028)→사이즈"}
- rel: {rel: option_refs, target: size-SIZ_000193, ref_key1: SIZ_000193, note: "자켓봉투(OPV-000029)→사이즈"}
- rel: {rel: option_refs, target: size-SIZ_000192, ref_key1: SIZ_000192, note: "소봉투(OPV-000030)→사이즈"}
- rel: {rel: option_refs, target: size-SIZ_000194, ref_key1: SIZ_000194, note: "대봉투(OPV-000031)→사이즈"}
- props: {opt_grp_cd: "OPT-000014", sel_typ_cd: "SEL_TYPE.01", mand_yn: "N", 옵션값: "티켓/자켓/소/대봉투(4택)", ref_dim: "OPT_REF_DIM.01=사이즈(봉투종류가 곧 siz_cd·가격 매트릭스 1축)"}
- 본문: 손님이 봉투 종류를 고르는 CPQ 옵션. 4 option_item이 각각 사이즈(SIZ_000191~194)를 가리켜(R11 option_refs·OPT_REF_DIM.01), 선택이 가격 매트릭스의 siz_cd 축으로 환원된다(가격 사슬 참여·option_items 실재로 fn_chk_opt_item_ref 정합). option_refs 타깃 4 사이즈는 전부 같은 부모(PRD_000050) has_size에 실재(L-18 통과).

## 빈 옵션그룹 (라이브 스캐폴딩 — 노드 미생성·정직 기록)

<!-- OPT-000013(봉투제작)·OPT-000015(소봉투)·OPT-000016(자켓봉투)·OPT-000017(대봉투)는 라이브에 -->
<!-- 존재하나 연결된 옵션(t_prd_product_options)·option_item이 0건인 빈 그룹(명명 스캐폴딩·기능 그룹은 -->
<!-- OPT-000014 봉투옵션 단일). 손님 선택·가격에 미참여하므로 option_group 노드로 등재하지 않는다 -->
<!-- (환각 개체 차단·search-before-mint). 정리 필요 여부는 §12 기초코드 거버넌스 소관(현재 GAP 아님). -->
