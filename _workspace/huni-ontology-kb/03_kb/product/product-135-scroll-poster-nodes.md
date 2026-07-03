<!-- product-local sub-nodes: E3 size(319/320 신설)·E6 process(족자제작)·bundle_qty·E9 price_formula·E10 price_component×2·E11 option_group×2·gap for PRD_000135 족자포스터. -->
<!-- ★공유 노드 재사용(중복 mint 방지·L-3): -->
<!--   - category-CAT_000004(포스터) = 119-nodes 소유 / category-CAT_000080(보드액자) = 131-nodes 소유 → 재정의 안 함. 135 main이 in_category로 참조만. -->
<!--   - size-SIZ_000174(A3)=047 소유 · size-SIZ_000197(A2)=axis/sizes 소유 · size-SIZ_000294(A1)=118-nodes 소유 → 참조만. 여기 신설=SIZ_000319(300x600)·SIZ_000320(900x1200)만(타 빌더 미소유). -->
<!--   - material-MAT_000178(PET)=axis/materials 소유 → 참조만(uses_material). -->
<!-- ★여기 신설(135 고유·타 빌더 미정의): size(319/320)·process(족자제작 PROC_000082·needed_shared)·qty-135·formula(PRF_POSTER_JOKJA)·component(완제품가+천정고리 가산)·optgroup 2·gap 4. -->
<!--   실사 고정가 공유 축(process 족자제작·formula/component)은 131 선례처럼 needed_shared 반환(향후 silsa 축 승격 시 canonical id 그대로 이관). -->
<!-- ★수치(치수·SHAPE)는 아래 전사표(transcribed-by·transcribe_product_135.py)에만. props raw 미기입(D-9·L-12). -->
<!-- ★가격 값(unit_price)은 전사하지 않음 — 연결·차원·격자완전성까지만(D-18·값=evaluate_price). -->

# product-135 하위 노드 (족자포스터 전용 축 원자 + 공식/옵션/GAP)

족자포스터(PRD_000135)가 쓰는 정형치수 사이즈 2행(신설)·PET 자재(참조)·족자제작 공정·가격공식·
수량규칙·가격구성요소 2(완제품가+천정고리 가산)·CPQ 옵션그룹 2·GAP 4. 상품→축 연결
(has_size·uses_material·has_process·priced_by·has_qty_rule·has_option_group)은
[[product-135-scroll-poster]]가 건다. 공식→구성요소 배선(has_component)은 아래 formula 블록.

## 치수·자재·공정·수량·고정가 SHAPE 전사표 (권위 = 라이브 마스터)

<!-- transcribed-by: _meta/scripts/transcribe_product_135.py from live-snapshot/latest (snap_20260702_1119) t_siz_sizes PRD_000135 @ 2026-07-03 -->
| siz_cd | 라벨 | 작업(work mm) | 조판(impos_yn) | del_yn |
|---|---|---|---|---|
| SIZ_000174 | A3(297x420mm) | 297x420 | N | N |
| SIZ_000197 | A2(420x594mm) | 420x594 | N | N |
| SIZ_000294 | A1 (594X841mm) | 594x841 | Y | N |
| SIZ_000319 | 300x600 | 300x600 | N | N |
| SIZ_000320 | 900x1200 | 900x1200 | N | N |

<!-- transcribed-by: _meta/scripts/transcribe_product_135.py from live-snapshot/latest (snap_20260702_1119) t_mat_materials PRD_000135 @ 2026-07-03 -->
| mat_cd | 자재명 | mat_typ | 상위자재 | del_yn |
|---|---|---|---|---|
| MAT_000178 | PET | MAT_TYPE.08 | - | N |

<!-- transcribed-by: _meta/scripts/transcribe_product_135.py from live-snapshot/latest (snap_20260702_1119) t_proc_processes PRD_000135 @ 2026-07-03 -->
| proc_cd | 공정명 | 상위공정 | 상태 |
|---|---|---|---|
| PROC_000082 | 족자제작 | - | 활성(del_yn=N)·mand |

<!-- transcribed-by: _meta/scripts/transcribe_product_135.py from live-snapshot/latest (snap_20260702_1119) t_prd_products PRD_000135 @ 2026-07-03 -->
| nonspec | min_qty | max_qty | qty_incr | 단위 |
|---|---|---|---|---|
| N | 1 | 10000 | 1 | QTY_UNIT.01 |

<!-- transcribed-by: _meta/scripts/transcribe_product_135.py from live-snapshot/latest (snap_20260702_1119) t_prc_component_prices(SHAPE·값 미전사) @ 2026-07-03 -->
| comp_cd | 역할 | 차원(use_dims) | 규격셀수 | 수량밴드수 | 단가행수 | 상품사이즈수 | 격자완전 | 미적재셀 |
|---|---|---|---|---|---|---|---|---|
| COMP_POSTER_JOKJA | 완제품가(고정룩업) | ["siz_cd", "min_qty"] | 5 | 1 | 5 | 5 | True | 없음 |
| COMP_POSTEROPT_JOKJA_CEILHOOK | 천정고리 가산 | ["opt_cd", "min_qty"] | (opt 1) | 0 | 1 | - | - | opt=['OPV_000431'] |

> **완제품가 격자완전=True** = 규격 5셀(A3/A2/A1·300x600·900x1200)이 이 빠짐 없이 채워짐(상품 사이즈 5건 =
> 단가행 5건·미적재셀 0). ★118 면적매트릭스(가로×세로 순서쌍·off-grid ceiling)와 달리 등록 규격 siz_cd 룩업이라
> off-grid·비대칭 개념 없음. **수량밴드=1**(min_qty=1 단일)이라 현재 수량구간 할인 없음. 값=evaluate_price(D-18).

## 사이즈 노드 (product-local — 정형치수 2행 신설·나머지 3규격은 타 빌더 소유노드 참조)

<!-- ★SIZ_000174(047)·SIZ_000197(axis)·SIZ_000294(118)는 이미 정의됨 → 여기 재정의 안 함(L-3). 135 신설=319/320만. -->

### [size-SIZ_000319] 300x600 (정형치수) {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000319
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "테이블:t_siz_sizes 키:SIZ_000319(siz_nm=300x600·work 300x600·impos_yn=N·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_sizes.csv", source_locator: "키:(PRD_000135,SIZ_000319) dflt_yn=N·del_yn=N·disp_seq=1", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000319(작업 300x600·impos_yn=N)", note: "족자포스터 정형치수 300×600. 고정가 완제품가 단가행 실재(COMP_POSTER_JOKJA siz_cd 셀). axis/sizes 미등재·135 최초 소비 → 승격 후보(needed_shared_node)"}
- 본문: 족자포스터 정형치수 300×600. [[product-135-scroll-poster]] has_size 대상. 고정가 siz_cd 룩업 키(면적 순서쌍 아님).

### [size-SIZ_000320] 900x1200 (정형치수) {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000320
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "테이블:t_siz_sizes 키:SIZ_000320(siz_nm=900x1200·work 900x1200·impos_yn=N·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_sizes.csv", source_locator: "키:(PRD_000135,SIZ_000320) dflt_yn=N·del_yn=N·disp_seq=1", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000320(작업 900x1200·impos_yn=N)", note: "족자포스터 정형치수 900×1200(최대). 고정가 완제품가 단가행 실재. axis/sizes 미등재·135 최초 소비 → 승격 후보(needed_shared_node)"}
- 본문: 족자포스터 정형치수 900×1200(최대 규격). has_size 대상. 고정가 siz_cd 룩업 키.

## 공정 노드 (product-local — 족자제작·needed_shared 축 승격 대기)

<!-- ★족자제작 PROC_000082 = 실사 후가공(족자·완성형태). 상위공정 없음(top-level). 135 mand(옵션그룹 가공이 참조). -->
<!-- 실사 인쇄방식 PROC_000006(실사출력)은 135 product_processes 행 없음(실사 공통·정당·전사 제외). -->

### [process-PROC_000082] 족자제작 (실사 후가공·mand) {verified}
- type: process
- anchor: t_proc_processes/PROC_000082
- src: {source_file: "live-snapshot/latest/t_proc_processes.csv", source_locator: "테이블:t_proc_processes 키:PROC_000082(proc_nm=족자제작·upr_proc_cd=공란·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_processes.csv", source_locator: "키:(PRD_000135,PROC_000082) del_yn=N(mand·135 유일 공정)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {upr_proc_cd: null, note: "족자 후가공(봉/천정고리 완성형태). 옵션그룹 가공(사각/원형)이 이 공정 참조(OPT_REF_DIM.04). 모양 param 미분화(GAP-SL-2). 가격=완제품 통가격 포함(별도 가공비 원자합산 아님). 실사 고정가 공유 축(needed_shared)"}
- 본문: 족자제작 공정(mand·상품 유일 공정). [[optgroup-135-gagong]]의 option_refs 타깃(OPT_REF_DIM.04·PROC_000082). 족자모양(사각/원형)이 이 공정을 가리키나 모양 param 인스턴스는 미분화([[gap-135-jokja-shape-param]]). 전 실사 족자상품 공유 축(needed_shared·134 린넨우드봉족자 등).

## 수량규칙 노드 (product-local)

### [qty-135] 족자포스터 수량규칙 {verified}
- type: bundle_qty
- anchor: t_prd_products/PRD_000135
- src: {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "키:PRD_000135 min_qty/max_qty/qty_incr(1/10000/1)·qty_unit_typ_cd=QTY_UNIT.01", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/_foundation/batch/qty_rule_audit_260702.py", source_locator: "수량 UI 권위=상품/사이즈 규칙(가격구간과 역할 분리)", captured_at: "2026-07-03", badge: verified, src_id: SR-27-qtyaudit}
- props: {min_max_incr_ref: "전사표 수량규칙(상품 1/10000/1)", bdl_unit_typ_cd: "QTY_UNIT.01", bundle_qtys_rows: 0, note: "★고정가형이라 use_dims에 min_qty 있으나 완제품가 단가행은 수량 단일밴드(1)·현재 수량구간 할인 없음. 셀단가=규격별 통가격·총액=규격셀×수량"}
- 본문: 수량 그릇 = 상품 마스터 컬럼(min 1·max 10000·incr 1). t_prd_product_bundle_qtys 0행 정상(수량 UI 권위=상품 레벨·[[rule/decisions#DEC_qty_audit_260702]]). 가격은 규격별 통가격×수량(단일밴드).

## 가격공식 노드 (product-local — silsa 고정가 formula 축 승격 대기)

<!-- ★고정가형(원자합산·면적매트릭스와 다른 아키타입). 완제품가 1(siz_cd 룩업) + 천정고리 가산 1(opt_cd) 배선. -->
<!-- 131 PRF_POSTER_FRAMELESS 동형이나 135는 가산 구성요소(CEILHOOK)가 추가된 2-component 공식. -->

### [formula-PRF_POSTER_JOKJA] 족자포스터 완제품가 (고정가·규격 단가) {verified}
- type: price_formula
- anchor: t_prc_price_formulas/PRF_POSTER_JOKJA
- src: {source_file: "live-snapshot/latest/t_prc_price_formulas.csv", source_locator: "테이블:t_prc_price_formulas 키:PRF_POSTER_JOKJA(frm_nm='족자포스터 완제품가(면적/규격 단가)'·use_yn=Y)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prc_formula_components.csv", source_locator: "frm_cd:PRF_POSTER_JOKJA(COMP_POSTER_JOKJA disp_seq1·addtn_yn Y / COMP_POSTEROPT_JOKJA_CEILHOOK disp_seq2·addtn_yn Y·2행)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_price_formulas.csv", source_locator: "키:(PRD_000135,PRF_POSTER_JOKJA) 바인딩", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: has_component, target: component-COMP_POSTER_JOKJA, qualifier: {disp_seq: 1, addtn: Y}, note: "고정가 완제품가(단일 규격셀 통가격)"}
- rel: {rel: has_component, target: component-COMP_POSTEROPT_JOKJA_CEILHOOK, qualifier: {disp_seq: 2, addtn: Y}, note: "천정고리 가산가(opt_cd 선택 시·06-23 배선)"}
- props: {archetype: "고정가형(fixed-price·siz_cd 룩업·use_dims=[siz_cd,min_qty])", use_yn: Y, note: "135 바인딩 전용 공식. 완제품가 1 + 천정고리 가산 1 = 2 구성요소 배선. 규격 siz_cd 셀 조회+옵션 가산(evaluate_price). 면적매트릭스 아님(가로×세로 순서쌍 없음·off-grid 개념 없음)"}
- 본문: 족자포스터 가격공식. 완제품가(규격 siz_cd 통가격) + 천정고리 가산(opt 선택 시)을 배선 — 인쇄·용지·가공을 원자 합산하지 않고 등록 규격별 완제품 통가격을 조회하고 천정고리 선택 시 별도 가산가를 더한다(고아 공식 아님·has_component 2개). 배선 타깃 [[component-COMP_POSTER_JOKJA]]·[[component-COMP_POSTEROPT_JOKJA_CEILHOOK]]. ★131(단일 component)과 달리 가산 구성요소 추가·118(면적매트릭스)과 달리 use_dims=[siz_cd,min_qty]. 값 계산=evaluate_price 권위(D-18·[[rule/rules#RULE_price_value_boundary]]).

## 가격구성요소 노드 (product-local — 고정가 완제품가 + 천정고리 가산·silsa component 축 승격 대기)

<!-- ★단가행은 노드로 펼치지 않고 use_dims 차원+SHAPE로 접음(D-22). 값(unit_price·골든)은 미전사(evaluate_price 권위). -->

### [component-COMP_POSTER_JOKJA] 족자포스터 완제품가 (고정가 siz_cd 셀) {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_POSTER_JOKJA
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "테이블:t_prc_price_components 키:COMP_POSTER_JOKJA(comp_nm='족자포스터 완제품가'·comp_typ_cd=PRC_COMPONENT_TYPE.06·prc_typ_cd=PRICE_TYPE.01·use_dims=[siz_cd,min_qty]·note '포스터·사인 완제품가(소재+출력+가공 포함 통가격). 사이즈·수량별 단가표.'·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prc_component_prices.csv", source_locator: "comp_cd=COMP_POSTER_JOKJA 5셀(siz_cd별·값=전사표 SHAPE·D-22 접기)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.01", comp_typ_cd: "PRC_COMPONENT_TYPE.06", use_dims: '["siz_cd", "min_qty"]', role: "실사 족자 완제품 통가격(소재 PET+출력+족자제작 가공 포함)·고정가 규격 룩업", 단가행_ref: "전사표 고정가 SHAPE(5셀=규격5×수량1·격자완전 True·수량축 미충전·규격=가격셀 정합 True)", archetype: "고정가형(fixed-price·siz_cd 룩업·off-grid 개념 없음)"}
- 본문: 족자포스터 완제품가 구성요소. use_dims 2축(규격 siz_cd × 수량 min_qty)으로 셀단가가 달라진다(차원 선언까지·D-22 단가행 접기). 규격 5셀 완전격자(전사표 SHAPE·미적재셀 0). 소재+출력+족자가공(사각/원형 동일가)이 통가격에 baked. 값=evaluate_price(값·골든 미전사·D-18·[[rule/rules#RULE_price_value_boundary]]).

### [component-COMP_POSTEROPT_JOKJA_CEILHOOK] 족자포스터 천정형고리 추가가격 (opt_cd 가산) {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_POSTEROPT_JOKJA_CEILHOOK
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "테이블:t_prc_price_components 키:COMP_POSTEROPT_JOKJA_CEILHOOK(comp_nm='족자포스터 천정형고리 추가가격'·comp_typ_cd=PRC_COMPONENT_TYPE.06·prc_typ_cd=PRICE_TYPE.01·use_dims=[opt_cd,min_qty]·upd_dt 2026-06-23·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prc_component_prices.csv", source_locator: "comp_cd=COMP_POSTEROPT_JOKJA_CEILHOOK 1셀(opt_cd=OPV_000431·note '천정형고리 포함 추가가격(별도 add-on·2개1세트=bdl_qty 2)'·값=D-22 접기)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.01", comp_typ_cd: "PRC_COMPONENT_TYPE.06", use_dims: '["opt_cd", "min_qty"]', role: "천정형고리 부속 가산가(옵션 OPV_000431 선택 시·규격무관 플랫·2개1세트)", 단가행_ref: "전사표 SHAPE(1셀=opt OPV_000431×수량밴드·D-22 접기)", archetype: "가산형(additive·opt_cd 룩업·addtn_yn=Y)"}
- 본문: 천정형고리 가산 구성요소(06-23 배선). use_dims 2축(옵션 opt_cd × 수량 min_qty). 천정고리 옵션(OPV_000431) 선택 시만 완제품가에 가산(addtn_yn=Y·규격무관 플랫·2개1세트). ★부속(천정고리)이 addon 테이블이 아니라 이 가산 가격구성요소+CPQ 옵션으로 표현됨([[gap-135-ceilhook-addon-path]]). 값=evaluate_price(D-18·[[rule/rules#RULE_price_value_boundary]]).

## 옵션그룹 노드 (CPQ)

### [optgroup-135-gagong] 가공 (사각족자/원형족자) {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000135
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "키:PRD_000135 opt_grp_cd:OPT_000015(opt_grp_nm=가공·SEL_TYPE.01·min_sel=1·max_sel=1·mand_yn=Y·use_yn=Y·del_yn=N·note '족자제작 필수 (모양 param=GAP)')", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_options.csv", source_locator: "키:PRD_000135 OPT_000015 (OPV_000033 사각족자·dflt_yn=Y / OPV_000034 원형족자)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_option_items.csv", source_locator: "키:PRD_000135 (OPV_000033→PROC_000082·OPV_000034→PROC_000082·둘 다 OPT_REF_DIM.04=공정·qty=1)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: option_refs, target: process-PROC_000082, ref_key1: PROC_000082, note: "사각족자(OPV_000033)→족자제작 공정"}
- props: {opt_grp_cd: "OPT_000015", sel_typ_cd: "SEL_TYPE.01", mand_yn: "Y", 옵션값: "사각족자(dflt)/원형족자(택1)", ref_dim: "OPT_REF_DIM.04=공정(족자제작 PROC_000082·모양 param 미분화 GAP)"}
- 본문: 손님이 족자모양을 고르는 CPQ 옵션(택1·mand). 사각족자(OPV_000033·dflt)/원형족자(OPV_000034) 두 item 모두 공정 PROC_000082를 가리켜(R11 option_refs·OPT_REF_DIM.04) has_process 차원으로 환원(L-18 통과·부모 135 has_process 실재). ★모양(사각↔원형) 구별이 공정 param 인스턴스로 흐르지 않음(둘 다 동일 PROC_000082 지목·param 미분화·[[gap-135-jokja-shape-param]]). 가격은 두 모양 동일(완제품 통가격 포함).

### [optgroup-135-add] 추가 (추가없음/천정형고리 포함) {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000135
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "키:PRD_000135 opt_grp_cd:OPT_000016(opt_grp_nm=추가·SEL_TYPE.01·min_sel=0·max_sel=1·mand_yn=N·use_yn=Y·del_yn=N·note '천정형고리 추가 선택')", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_options.csv", source_locator: "키:PRD_000135 OPT_000016 (OPV_000035 추가없음·dflt_yn=Y / OPV_000431 천정형고리 포함·06-23 신설)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: references, target: component-COMP_POSTEROPT_JOKJA_CEILHOOK, note: "천정형고리 포함(OPV_000431)→가산 가격구성요소(opt_cd 경로·option_items ref_dim 없음)"}
- props: {opt_grp_cd: "OPT_000016", sel_typ_cd: "SEL_TYPE.01", mand_yn: "N", 옵션값: "추가없음(dflt)/천정형고리 포함(택1·선택)", ref_dim: "없음(option_items 무행) — 경제효과=가산 구성요소 CEILHOOK(use_dims opt_cd)로 흐름"}
- 본문: 손님이 천정형고리 부속을 고르는 CPQ 옵션(택1·선택·mand_yn=N). 추가없음(OPV_000035·dflt)/천정형고리 포함(OPV_000431·06-23). ★이 옵션은 option_items에 ref_dim 행이 없어 자재/공정 차원으로 환원되지 않고, 대신 가격구성요소 [[component-COMP_POSTEROPT_JOKJA_CEILHOOK]](opt_cd=OPV_000431)로 가산가가 흐른다(옵션→가격 경로). 부속을 addon이 아니라 옵션+가격으로 표현하는 실사 방식([[gap-135-ceilhook-addon-path]]).

## GAP 노드 (원천 부재·정직 선언)

### [gap-135-jokja-shape-param] 족자모양 param(사각↔원형) 미분화 {unknown}
- type: gap
- anchor: none  # 사유: 사각/원형 족자모양이 공정 param 인스턴스로 흐르는 경로가 라이브에 없음(option_item 둘 다 동일 PROC_000082 지목·param 미분화)
- src: {source_file: "live-snapshot/latest/t_prd_product_option_items.csv", source_locator: "키:PRD_000135 OPV_000033/034 둘 다 ref_key1=PROC_000082·ref_key2 공란·dtl_opt 공란(모양 param 없음)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "문서:§3.6 GAP-SL-2 봉제/족자 variant 적재 위치(CPQ option_items vs prcs_dtl_opt param·Q-SL-2)", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-silsa}
- gap_what: "사각족자(OPV_000033)·원형족자(OPV_000034)가 서로 다른 모양인데 둘 다 동일 공정 PROC_000082를 param 없이 가리킴 — 모양 구별이 생산지시(prcs_dtl_opt param)로 흐르는 경로가 미확정. 가격은 동일(통가격 포함)이라 견적 영향은 없으나 생산 param 손실"
- gap_fill_from: "실무진 확인(GAP-SL-2·Q-SL-2) — 족자 모양 param을 CPQ option_items ref_key2/dtl_opt로 넣을지, prcs_dtl_opt param 인스턴스로 넣을지 스키마 결정"
- gap_owner: staff
- 본문: 가격 경로는 연결됨(옵션→공정 환원·가격 동일)이라 견적 영향 없음. 이 GAP은 값 정합이 아니라 "모양 param이 생산지시로 흐르는 경로 미확정"의 정직 선언(pack §3.6 SL-DEF-003 잔존 추정·족자 param 손실).

### [gap-135-ceilhook-addon-path] 천정고리 부속 표현 경로 미결 (CPQ+가격 vs addon 재연결) {unknown}
- type: gap
- anchor: none  # 사유: 천정고리 부속을 CPQ 옵션+가산 구성요소(현재 작동)로 둘지, t_prd_product_addons로 PRD_000008(천정고리) 재연결할지 미결(권위 결정 부재)
- src: {source_file: "live-snapshot/latest/t_prd_product_addons.csv", source_locator: "테이블:t_prd_product_addons PRD_000135 0행(addon 미연결)·t_prd_product_sets PRD_000135 0행", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "문서:§3.12·§4 SL-DEF-005 부속 addon/set 0행 잔존(족자포스터135→천정고리008 재연결·천정고리 use_yn=N 활성화 선행)", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-silsa}
- rel: {rel: references, target: component-COMP_POSTEROPT_JOKJA_CEILHOOK, note: "현재 작동하는 천정고리 표현(가산 가격구성요소+옵션)"}
- gap_what: "천정고리 부속이 현재 CPQ 옵션(OPT_000016)+가산 구성요소(COMP_POSTEROPT_JOKJA_CEILHOOK)로 이미 작동(가격 흐름)하나, pack §3.12는 부속 PRD_000008(천정고리·use_yn=N 비활성)로 addon 재연결을 권고 — 두 표현 경로 중 어느 것이 정본인지 미결. addon=0·set=0 잔존"
- gap_fill_from: "실무진 확인(GAP-SL-4·Q-SL-4) — 부속을 addon으로 정규화할지(PRD_000008 활성화 선행), 현재 CPQ+가격 표현을 정본으로 둘지. 견적은 CEILHOOK 배선으로 이미 가능(0 위험 없음)"
- gap_owner: staff
- 본문: 견적 0 위험 없음(천정고리 가격=CEILHOOK로 배선). 이 GAP은 결함이 아니라 "부속 표현 경로가 두 갈래(현재 CPQ+가격 vs 권고 addon 재연결)"의 정직 선언. pack §4 SL-DEF-005 잔존(addon/set 0행).

### [gap-135-jokja-material-partial] 족자 완성부자재(봉/천정고리 하드웨어) 자재 미명시 {unknown}
- type: gap
- anchor: none  # 사유: 족자 완성형태(봉·고리 하드웨어)가 자재로 명시되지 않고 완제품 통가격+CEILHOOK 가산에 baked — 부자재 자재코드 원본 미명시
- src: {source_file: "live-snapshot/latest/t_prd_product_materials.csv", source_locator: "키:PRD_000135 MAT_000178(PET) 단일 행 — 족자 봉/고리 하드웨어 자재 행 없음", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "문서:§3.5 보드/우드 소재 L1 빈값(원본 미명시 정당·AMBIGUOUS)·§3.12 GAP-SL-5 끈/각목 BUNDLE 자재 mint", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-silsa}
- gap_what: "족자포스터 본체 자재=PET(명시)이나 족자 완성부자재(봉·천정형고리 하드웨어)는 자재로 등록되지 않고 완제품 통가격/CEILHOOK 가산에 baked. 부자재를 자재로 명시할지(BUNDLE mint) 원본 미명시"
- gap_fill_from: "실무진 확인(GAP-SL-5) — 끈/봉/고리류 BUNDLE 자재 신설 여부. 자재 날조 금지(IMPORT 자재 삭제 금지 원칙과 별개·[[rule/rules#RULE_import_material_no_delete]])"
- gap_owner: staff
- 본문: 가격 경로 연결됨(PET 자재+가공+CEILHOOK)이라 견적 0 위험 없음. 이 GAP은 '족자 하드웨어 부자재를 자재로 명시할지'가 원본 미명시라 정직 선언(자재 날조 금지).

### [gap-135-price-basis] 고정가 완제품가 산정 근거 문서 부재 (엑셀 미기재 암묵지) {unknown}
- type: gap
- anchor: none  # 사유: 규격별 완제품 통가격이 롤 원가/폭/마진 어떤 규칙으로 산정됐는지 어느 엑셀/문서에도 명시 없음(암묵지·실사 전체 공통)
- src: {source_file: "live-snapshot/latest/t_prc_component_prices.csv", source_locator: "테이블:t_prc_component_prices COMP_POSTER_JOKJA 5셀(규격별 통가격·값 적재됨·산정근거 문서 부재)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/source-registry.md", source_locator: "문서:§9 GAP-2 롤 소재 가격 계산 로직(엑셀 미기재 암묵지·실사 전체 영향)", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-silsa}
- rel: {rel: references, target: component-COMP_POSTER_JOKJA, note: "고정가 5셀(산정 근거 문서 부재)"}
- gap_what: "고정가 5셀(규격별 완제품 통가격)이 롤 원가/폭/마진 어떤 규칙으로 도출됐는지 — 값은 라이브에 적재됐으나 산정 근거 문서 부재(실사 전체 공통·118/131과 동일 GAP)"
- gap_fill_from: "실무진 확인(source-registry §9 GAP-2). 예전사이트 골든 대조로 값 정합 검증 가능하나 산정식 자체는 암묵지"
- gap_owner: staff
- 본문: 가격 경로는 연결됨([[formula-PRF_POSTER_JOKJA]]→[[component-COMP_POSTER_JOKJA]]·5셀 완전격자)이라 견적 0 위험 없음. 다만 셀단가가 **어떻게** 산정됐는지는 엑셀 미기재 암묵지(실사 전체 공통 GAP). 온톨로지는 연결·차원까지, 값 계산은 evaluate_price 권위이므로 이 GAP은 값 정합이 아니라 "산정 근거 문서 부재"의 정직 선언.
