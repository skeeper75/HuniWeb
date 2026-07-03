<!-- product-local sub-nodes: E3 size·E4 material·E6 process·E9 price_formula·E11 option_group·E12 constraint·gap for PRD_000118 아트프린트포스터. -->
<!-- ★공유 노드 재사용(중복 mint 방지·L-3): -->
<!--   - category-CAT_000004(포스터)·category-CAT_000314(아트포스터) = 병렬 실사빌더(119/121/125)가 정의 → 여기서 재정의 안 함. 118 main이 in_category로 참조만. -->
<!--   - component-COMP_POSTER_ARTPRINT_PHOTO(동형결합 4소재 면적매트릭스) = ★118이 canonical 정의(comp note "정본 COMP_POSTER_ARTPRINT_PHOTO"·아트프린트=118 본가). 120/121/123 formula가 이 노드를 has_component로 참조. 향후 shared silsa component 파일로 승격(needed_shared). -->
<!-- ★여기 정의(118 고유·타 빌더 미정의): size(재키잉 활성 315/198/294)·material(인화지 176/599)·process(코팅 115/116)·formula(PRF_POSTER_ARTPRINT)·component(동형결합 canonical)·qty·optgroup 2·constraint·gap 2. -->
<!--   process(코팅 115/116)는 전 포스터 공유 축이나 현재 미정의 → 118이 첫 정의(needed_shared 반환·향후 축 승격 시 canonical id 그대로 이관). -->
<!-- ★수치(치수·매트릭스 shape)는 아래 전사표(transcribed-by·transcribe_product_118.py)에만. props raw 미기입(D-9·L-12). -->
<!-- ★가격 값(unit_price)은 전사하지 않음 — 연결·차원·격자완전성까지만(D-18·값=evaluate_price). -->

# product-118 하위 노드 (아트프린트포스터 전용 축 원자 + 공식/옵션/제약/GAP)

아트프린트포스터(PRD_000118)가 쓰는 규격 사이즈 3행·인화지 자재 2종·코팅 공정 2종·가격공식·수량규칙·
CPQ 옵션그룹 2·치수범위 제약·GAP 2. 상품→축 연결(has_size·uses_material·has_process·priced_by·
has_option_group·has_qty_rule)은 [[product-118-artprint-poster]]가 건다. 공식→구성요소 배선
(has_component→[[product-121-adhesive-waterproof-poster-nodes#가격]]의 동형결합 구성요소)은 아래 formula 블록.

## 치수·자재·공정·수량·면적매트릭스 전사표 (권위 = 라이브 마스터)

<!-- transcribed-by: _meta/scripts/transcribe_product_118.py from live-snapshot/latest (snap_20260702_1119) t_siz_sizes PRD_000118 @ 2026-07-03 -->
| siz_cd | 라벨 | 작업(work mm) | 조판(impos_yn) | del_yn |
|---|---|---|---|---|
| SIZ_000315 | A3 (297x420mm) | 297x420 | N | N |
| SIZ_000198 | A2 (420X594mm) | 420x594 | Y | N |
| SIZ_000294 | A1 (594X841mm) | 594x841 | Y | N |
| SIZ_000174 | A3(297x420mm) (구·재키잉) | - | - | N |
| SIZ_000197 | A2(420x594mm) (구·재키잉) | - | - | N |
| SIZ_000293 | A1(594x841mm) (구·재키잉) | - | - | Y |

<!-- transcribed-by: _meta/scripts/transcribe_product_118.py from live-snapshot/latest (snap_20260702_1119) t_mat_materials PRD_000118 @ 2026-07-03 -->
| mat_cd | 자재명 | mat_typ | 상위자재 | del_yn |
|---|---|---|---|---|
| MAT_000176 | 인화지 | MAT_TYPE.08 | - | N |
| MAT_000599 | 인화지 | MAT_TYPE.08 | MAT_000176 | N |

<!-- transcribed-by: _meta/scripts/transcribe_product_118.py from live-snapshot/latest (snap_20260702_1119) t_proc_processes PRD_000118 @ 2026-07-03 -->
| proc_cd | 공정명 | 상위공정 | 상태 |
|---|---|---|---|
| PROC_000115 | 유광코팅 | PROC_000114 | 활성(del_yn=N) |
| PROC_000116 | 무광코팅 | PROC_000114 | 활성(del_yn=N) |
| PROC_000014 | 유광라미네이팅 | PROC_000013 | 상품 del_yn=Y(재키잉전) |
| PROC_000015 | 무광라미네이팅 | PROC_000013 | 상품 del_yn=Y(재키잉전) |

<!-- transcribed-by: _meta/scripts/transcribe_product_118.py from live-snapshot/latest (snap_20260702_1119) t_prd_products PRD_000118 @ 2026-07-03 -->
| nonspec | 가로범위(mm) | 세로범위(mm) | min_qty | max_qty | qty_incr | 단위 |
|---|---|---|---|---|---|---|
| Y | 200~1200 | 200~3000 | 1 | 1000 | 1 | QTY_UNIT.01 |

<!-- transcribed-by: _meta/scripts/transcribe_product_118.py from live-snapshot/latest (snap_20260702_1119) t_prc_component_prices COMP_POSTER_ARTPRINT_PHOTO(SHAPE·값 미전사) @ 2026-07-03 -->
| comp_cd | 차원(use_dims) | 가로구간수 | 세로구간수 | 가로범위(mm) | 세로범위(mm) | (가로,세로)셀수 | 단가행수 | 격자완전 | 비대칭 | 수량축충전 |
|---|---|---|---|---|---|---|---|---|---|---|
| COMP_POSTER_ARTPRINT_PHOTO | siz_width×siz_height×min_qty | 4 | 13 | 600~1200 | 600~3000 | 52 | 52 | True | True | False |

> **격자완전(grid_full)=True** = 가로 4구간 × 세로 13구간 = 52셀이 이 빠짐 없이 채워짐(미적재 셀 0).
> 가로·세로 상한(1200×3000)이 제품 nonspec 상한(전사표)과 일치. 하한(600×600)은 nonspec 하한(200×200)보다
> 크므로 600 미만 입력은 최소셀(600×600)로 off-grid ceiling(→ [[gap-118-small-size-price-floor]]).
> ★**수량축충전=False**: 52셀 전부 min_qty NULL → 셀단가=포스터 통가격(수량무관). 값=evaluate_price(D-18).

## 사이즈 노드 (product-local — 규격 3행·07-01 재키잉 활성분)

<!-- ★118은 A3/A2/A1가 07-01 재키잉되어 활성 코드=SIZ_000315(A3)·SIZ_000198(A2)·SIZ_000294(A1)(del_yn=N). -->
<!-- 구 코드 SIZ_000174/197/293은 상품 del_yn=Y(전사표) — 노드 미생성(환각 차단). -->
<!-- 병렬 빌더(119/121/125)는 구 코드(174/197/293)를 정의하나 118은 재키잉 활성분을 쓰므로 id 충돌 없음. -->

### [size-SIZ_000315] A3 규격 (297x420) {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000315
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "테이블:t_siz_sizes 키:SIZ_000315(siz_nm=A3 297x420mm·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_sizes.csv", source_locator: "키:(PRD_000118,SIZ_000315) dflt_yn=Y·del_yn=N(07-01 재키잉)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000315(작업 297x420·impos_yn=N)", note: "규격 A3. 면적매트릭스에 297×420 정확 셀 없음 → off-grid ceiling 최소셀(600×600)로 수렴([[gap-118-small-size-price-floor]])"}
- 본문: 아트프린트포스터 규격 A3(재키잉 활성·구 SIZ_000174 대체). [[product-118-artprint-poster]] has_size 대상.

### [size-SIZ_000198] A2 규격 (420x594) {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000198
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "테이블:t_siz_sizes 키:SIZ_000198(siz_nm=A2 420X594mm·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_sizes.csv", source_locator: "키:(PRD_000118,SIZ_000198) dflt_yn=Y·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000198(작업 420x594·impos_yn=Y)", note: "규격 A2. off-grid ceiling→최소셀 수렴([[gap-118-small-size-price-floor]])"}
- 본문: 아트프린트포스터 규격 A2(재키잉 활성·구 SIZ_000197 대체). has_size 대상.

### [size-SIZ_000294] A1 규격 (594x841) {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000294
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "테이블:t_siz_sizes 키:SIZ_000294(siz_nm=A1 594X841mm·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_sizes.csv", source_locator: "키:(PRD_000118,SIZ_000294) dflt_yn=Y·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000294(작업 594x841·impos_yn=Y)", note: "규격 A1. 594×841 → 가로 ceiling 600·세로 ceiling 1000셀(600×1000)로 환원(앱 계산)"}
- 본문: 아트프린트포스터 규격 A1(재키잉 활성·구 SIZ_000293 대체). has_size 대상.

## 자재 노드 (product-local — 인화지·축 승격 대기)

<!-- ★118 자재=인화지(MAT_TYPE.08 실사소재·정당). 실사 팩이 경고한 레더 MAT_000186 .08→.05 crosscut과 무관 -->
<!-- (레더=100/126/296/298 횡단·pack §1.1·T-2). 인화지 .08=현재값이자 정답(양면 불요). IMPORT 자재 삭제 금지. -->

### [material-MAT_000176] 인화지 (부모) {verified}
- type: material
- anchor: t_mat_materials/MAT_000176
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "테이블:t_mat_materials 키:MAT_000176(mat_nm=인화지·mat_typ_cd=MAT_TYPE.08·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_materials.csv", source_locator: "키:(PRD_000118,MAT_000176) USAGE.07·dflt_yn=Y·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.08", 사용: "118 본체 자재(USAGE.07·dflt_yn=Y)", note: "실사소재 인화지(정당·레더 crosscut 아님·pack §3.5)"}
- 본문: 아트프린트포스터 본체 자재(인화지 부모 코드). 낱장 완제품 단일 슬롯(USAGE.07·내지/표지 없음).

### [material-MAT_000599] 인화지 (자식·소재옵션 참조) {verified}
- type: material
- anchor: t_mat_materials/MAT_000599
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "테이블:t_mat_materials 키:MAT_000599(mat_nm=인화지·mat_typ_cd=MAT_TYPE.08·upr_mat_cd=MAT_000176·06-30 신설·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_materials.csv", source_locator: "키:(PRD_000118,MAT_000599) USAGE.07·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.08", upr_mat_cd: "MAT_000176", 사용: "118 소재옵션(OPT-000043) 참조대상(OPV-000089 인화지)", note: "부모 MAT_000176의 자식(06-30 신설). 소재옵션 item이 이 자식 코드를 가리킴"}
- 본문: 소재옵션이 가리키는 인화지 자식 코드. optgroup-118-material의 option_refs 타깃(L-18 부모정합 통과·uses_material에 실재).

## 공정 노드 (product-local — 코팅·07-01 재키잉·needed_shared 축 승격 대기)

<!-- ★07-01 재키잉: 구 라미네이팅(PROC_000014/015·상위 013)이 상품 del_yn=Y되고 코팅(115/116·상위 114)으로 교체. -->
<!-- 코팅은 면적매트릭스 통가격에 포함(코팅포함가·pack §3.10)이라 별도 코팅비 원자합산 아님. 실사 인쇄방식(PROC_000006)은 118 행 없음(정당). -->

### [process-PROC_000115] 유광코팅 (실사) {verified}
- type: process
- anchor: t_proc_processes/PROC_000115
- src: {source_file: "live-snapshot/latest/t_proc_processes.csv", source_locator: "테이블:t_proc_processes 키:PROC_000115(proc_nm=유광코팅·upr_proc_cd=PROC_000114·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_processes.csv", source_locator: "키:(PRD_000118,PROC_000115) mand_proc_yn=N·del_yn=N(07-01 재키잉)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {upr_proc_cd: "PROC_000114", mand_proc_yn: "N", note: "코팅 택1 옵션값(유광). 구 PROC_000014 유광라미 대체(상품 del_yn=Y). 가격=매트릭스 통가격 포함"}
- 본문: 유광코팅 공정(선택). optgroup-118-coating의 option_refs 타깃(OPT_REF_DIM.04·PROC_000115). 전 포스터 공유 축(needed_shared).

### [process-PROC_000116] 무광코팅 (실사) {verified}
- type: process
- anchor: t_proc_processes/PROC_000116
- src: {source_file: "live-snapshot/latest/t_proc_processes.csv", source_locator: "테이블:t_proc_processes 키:PROC_000116(proc_nm=무광코팅·upr_proc_cd=PROC_000114·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_processes.csv", source_locator: "키:(PRD_000118,PROC_000116) mand_proc_yn=N·del_yn=N(07-01 재키잉)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {upr_proc_cd: "PROC_000114", mand_proc_yn: "N", note: "코팅 택1 옵션값(무광). 구 PROC_000015 무광라미 대체(상품 del_yn=Y). 가격=매트릭스 통가격 포함"}
- 본문: 무광코팅 공정(선택). optgroup-118-coating의 option_refs 타깃(OPT_REF_DIM.04·PROC_000116). 전 포스터 공유 축(needed_shared).

## 수량규칙 노드 (product-local)

### [qty-118] 아트프린트포스터 수량규칙 {verified}
- type: bundle_qty
- anchor: t_prd_products/PRD_000118
- src: {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "키:PRD_000118 min_qty/max_qty/qty_incr(1/1000/1)·qty_unit_typ_cd=QTY_UNIT.01", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/_foundation/batch/qty_rule_audit_260702.py", source_locator: "수량 UI 권위=상품/사이즈 규칙(가격구간과 역할 분리)", captured_at: "2026-07-03", badge: verified, src_id: SR-27-qtyaudit}
- props: {min_max_incr_ref: "전사표 수량규칙(상품 1/1000/1)", bdl_unit_typ_cd: "QTY_UNIT.01", bundle_qtys_rows: 0, note: "★면적매트릭스형이라 수량축이 가격 차원 아님(매트릭스 52셀 min_qty NULL). 셀단가=포스터1장가·총액=셀×수량(수량구간 할인 없음)"}
- 본문: 수량 그릇 = 상품 마스터 컬럼(min 1·max 1000·incr 1). t_prd_product_bundle_qtys 0행 정상(수량 UI 권위=상품 레벨·[[rule/decisions#DEC_qty_audit_260702]]). 가격은 수량 무관 통가격.

## 가격공식 노드 (product-local — silsa formula 축 승격 대기)

<!-- ★면적매트릭스형(원자합산·고정룩업과 다른 아키타입). 단일 구성요소(동형결합 완제품가)를 (가로×세로) 셀에서 조회. -->
<!-- has_component 타깃 component-COMP_POSTER_ARTPRINT_PHOTO = 아래 118 canonical 정의(동형결합 4소재 공유·120/121/123도 이 노드 참조). -->

### [formula-PRF_POSTER_ARTPRINT] 아트프린트포스터 완제품가 (면적/규격 단가) {verified}
- type: price_formula
- anchor: t_prc_price_formulas/PRF_POSTER_ARTPRINT
- src: {source_file: "live-snapshot/latest/t_prc_price_formulas.csv", source_locator: "테이블:t_prc_price_formulas 키:PRF_POSTER_ARTPRINT(frm_nm=아트프린트포스터 완제품가(면적/규격 단가)·use_yn=Y)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prc_formula_components.csv", source_locator: "frm_cd:PRF_POSTER_ARTPRINT(comp COMP_POSTER_ARTPRINT_PHOTO·disp_seq 1·addtn_yn Y·1행)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_price_formulas.csv", source_locator: "키:(PRD_000118,PRF_POSTER_ARTPRINT) 바인딩", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: has_component, target: component-COMP_POSTER_ARTPRINT_PHOTO, qualifier: {disp_seq: 1, addtn: Y}}
- props: {archetype: "면적매트릭스형(area-matrix·코팅포함 통가격)", use_yn: Y, note: "118 바인딩 전용 공식. 단일 구성요소(동형결합 완제품가)를 가로×세로 셀에서 조회(evaluate_price). off-grid=ceiling(앱)"}
- 본문: 아트프린트포스터 가격공식. 단일 구성요소(동형결합 완제품가) 1건 배선 — 인쇄·용지·코팅을 원자 합산하지 않고 포스터사인 [가로×세로] 면적매트릭스에서 완제품 통가격을 조회한다. 배선 타깃 [[component-COMP_POSTER_ARTPRINT_PHOTO]](아래 118 canonical 정의·아트프린트118/방수120/접착방수121/아트패브릭123 공유). 값 계산=evaluate_price 권위(D-18·[[rule/rules#RULE_price_value_boundary]]).

## 가격구성요소 노드 (product-local canonical — 동형결합 4소재·silsa component 축 승격 대기)

<!-- ★COMP_POSTER_ARTPRINT_PHOTO = comp note "정본(canonical) COMP_POSTER_ARTPRINT_PHOTO(레거시 3종)". -->
<!-- 아트프린트118이 본가라 여기 정의. 가격표 동일 4소재(아트프린트118·방수120·접착방수121·아트패브릭123)를 [동형결합] 통합 → 네 상품 formula가 이 단일 노드를 has_component로 참조. -->
<!-- ★단가행(52셀)은 노드로 펼치지 않고 use_dims 차원+SHAPE로 접음(D-22). 값(unit_price·골든 등)은 미전사(evaluate_price 권위). -->

### [component-COMP_POSTER_ARTPRINT_PHOTO] 실사 완제품가 (동형결합 4소재·면적매트릭스) {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_POSTER_ARTPRINT_PHOTO
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "테이블:t_prc_price_components 키:COMP_POSTER_ARTPRINT_PHOTO(comp_typ=PRC_COMPONENT_TYPE.06·prc_typ_cd=PRICE_TYPE.01·use_dims=[siz_width,siz_height,min_qty])", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-dbmap/02_mapping/silsa-poster-area-matrix/mapping.md", source_locator: "문서:§1.2 B01~ 동형결합 4소재↔COMP_POSTER_ARTPRINT_PHOTO(가로×세로 52셀)", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-silsa}
- props: {prc_typ_cd: "PRICE_TYPE.01", comp_typ_cd: "PRC_COMPONENT_TYPE.06", use_dims: '["siz_width", "siz_height", "min_qty"]', role: "실사 포스터 완제품 통가격(코팅 포함)·[동형결합] 아트프린트118/방수120/접착방수121/아트패브릭123 통합", 단가행_ref: "전사표 매트릭스 SHAPE(52셀=가로4×세로13·격자완전 True·수량축 미충전)", archetype: "면적매트릭스(area-matrix·off-grid ceiling=앱)"}
- 본문: 실사 포스터 완제품가 구성요소(canonical). use_dims 3축(가로 siz_width × 세로 siz_height × 수량 min_qty)으로 셀단가가 달라진다(차원 선언까지·D-22 단가행 접기). 가로 4구간 × 세로 13구간 = 52셀 완전격자(전사표 SHAPE). [동형결합]으로 가격표 동일 4소재를 통합하므로 네 상품이 동일 셀단가. 값=evaluate_price(값·골든 미전사·D-18·[[rule/rules#RULE_price_value_boundary]]).

## 옵션그룹 노드 (CPQ)

### [optgroup-118-coating] 코팅 (없음/무광/유광) {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000118
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "키:PRD_000118 opt_grp_cd:OPT_000005(코팅·SEL_TYPE.01·min_sel=0·max_sel=1·mand_yn=Y·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_options.csv", source_locator: "키:PRD_000118 OPT_000005 (OPV_000017 코팅없음/OPV_000018 무광코팅/OPV_000019 유광코팅)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_option_items.csv", source_locator: "키:PRD_000118 (OPV_000018→PROC_000116·OPV_000019→PROC_000115·전부 OPT_REF_DIM.04=공정)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: option_refs, target: process-PROC_000115, ref_key1: PROC_000115, note: "유광코팅(OPV_000019)→공정"}
- rel: {rel: option_refs, target: process-PROC_000116, ref_key1: PROC_000116, note: "무광코팅(OPV_000018)→공정"}
- props: {opt_grp_cd: "OPT_000005", sel_typ_cd: "SEL_TYPE.01", mand_yn: "Y", 옵션값: "코팅없음/무광코팅/유광코팅(택1)", ref_dim: "OPT_REF_DIM.04=공정(코팅=면적매트릭스 통가격 포함·가산 아님)"}
- 본문: 손님이 코팅을 고르는 CPQ 옵션(택1). 코팅없음(OPV_000017)은 참조 없음. 무광/유광 item이 각각 공정(PROC_000116/115)을 가리켜(R11 option_refs·OPT_REF_DIM.04) has_process 차원으로 환원(L-18 통과·부모 118 has_process 실재). 코팅 선택은 매트릭스 통가격에 포함이라 별도 가산 아님(pack §3.10).

### [optgroup-118-material] 소재 (인화지) {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000118
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "키:PRD_000118 opt_grp_cd:OPT-000043(소재·SEL_TYPE.01·min_sel=1·max_sel=1·mand_yn=Y·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_options.csv", source_locator: "키:PRD_000118 OPT-000043 (OPV-000089 인화지·dflt_yn=Y)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_option_items.csv", source_locator: "키:PRD_000118 (OPV-000089→MAT_000599·OPT_REF_DIM.03=자재·ref_key2=USAGE.07)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: option_refs, target: material-MAT_000599, ref_key1: MAT_000599, note: "인화지(OPV-000089)→자재"}
- props: {opt_grp_cd: "OPT-000043", sel_typ_cd: "SEL_TYPE.01", mand_yn: "Y", 옵션값: "인화지(택1·현재 단일)", ref_dim: "OPT_REF_DIM.03=자재(소재→면적매트릭스 소재축·동형결합이라 4소재 동일가)"}
- 본문: 손님이 소재를 고르는 CPQ 옵션(택1·현재 인화지 단일). option_item이 자재 MAT_000599를 가리켜(R11 option_refs·OPT_REF_DIM.03) uses_material 차원으로 환원(L-18 통과·부모 118 uses_material 실재). 동형결합 구성요소라 4소재(아트프린트/방수/접착방수/아트패브릭)가 동일 셀단가.

## 제약규칙 노드 (§31 — 사용자입력 치수 범위)

### [constraint-118-nonspec-range] 사용자입력 치수 범위 {verified}
- type: constraint
- anchor: t_prd_product_constraints/PRD_000118
- src: {source_file: "live-snapshot/latest/t_prd_product_constraints.csv", source_locator: "키:PRD_000118 rule_cd:RULE_001(rule_nm=사용자입력 치수 범위·rule_typ=RULE_TYPE.01·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-constraint-rules/03_rules", source_locator: "CN-5 범위형(size_mode=nonspec일 때 width/height 범위 검증)·폼빌더 정형 shape(§31)", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-silsa}
- rel: {rel: constrains, target: product-118-artprint-poster, note: "비규격 입력 치수 범위 검증"}
- props: {rule_cd: "RULE_001", 유형: "CN-5 범위형(range)", 검증: "size_mode=nonspec이면 가로/세로가 제품 nonspec 범위(전사표) 안인지", 상태: "라이브 실등록(데모 아님)·정당"}
- 본문: 비규격 입력 시 가로/세로가 제품 nonspec 범위(전사표 200~1200 × 200~3000) 안인지 검증하는 범위 제약(CN-5·§31). 폼빌더 정형 shape(raw JSONLogic escape hatch 금지·[[rule/rules]] §31). ★[REVERIFY] 위키 "실사 constraints 전부 0행"은 STALE(118 포함 7상품 신규 발현·pack §1.1·T-3). evaluate_price는 제약 미참조 — validate는 위젯/주문이 호출(constraint-builder 계약).

## GAP 노드 (원천 부재·정직 선언)

### [gap-118-roll-price-logic] 롤 소재 가격 셀단가 산정 로직 {unknown}
- type: gap
- anchor: none  # 사유: 롤(대형롤) 소재 완제품 셀단가 도출 규칙이 어느 엑셀/문서에도 명시 없음(암묵지)
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/source-registry.md", source_locator: "문서:§9 GAP-2 롤 소재 가격 계산 로직(엑셀 미기재 암묵지·실사 전체 영향)", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-silsa}
- gap_what: "면적매트릭스 52셀 완제품 통가격이 롤 원가/폭/마진 어떤 규칙으로 도출됐는지 — 값은 라이브에 적재됐으나 산정 근거 문서 부재"
- gap_fill_from: "실무진 확인(source-registry §9 GAP-2·실사 전체 영향). 예전사이트 골든 대조로 값 정합 검증 가능하나 산정식 자체는 암묵지"
- gap_owner: staff
- 본문: 가격 경로는 연결됨([[formula-PRF_POSTER_ARTPRINT]]→[[component-COMP_POSTER_ARTPRINT_PHOTO]]·52셀 완전격자)이라 견적 0 위험 없음. 다만 셀단가가 **어떻게** 산정됐는지는 엑셀 미기재 암묵지(실사 전체 공통 GAP). 온톨로지는 연결·차원까지, 값 계산은 evaluate_price 권위이므로 이 GAP은 값 정합이 아니라 "산정 근거 문서 부재"의 정직 선언.

### [gap-118-small-size-price-floor] 소형 규격 최소셀 수렴(최저가 floor) {unknown}
- type: gap
- anchor: none  # 사유: A3/A2가 최소셀(600×600)로 ceiling 수렴해 동일가 — 의도된 floor인지 소형셀 누락인지 권위 부재
- src: {source_file: "_workspace/huni-ontology-kb/_meta/scripts/transcribe_product_118.py", source_locator: "매트릭스 SHAPE 가로/세로 하한=600(전사표)·제품 nonspec 하한=200", captured_at: "2026-07-03", badge: unknown, src_id: SR-5-livesnap}
- gap_what: "규격 A3(297×420)·A2(420×594)가 면적매트릭스 최소셀(600×600) 미만이라 off-grid ceiling으로 동일 셀단가에 수렴 — A3·A2 포스터가 같은 가격이 됨. 의도된 최저가 floor인지, 600mm 미만 소형 셀 누락(coverage gap)인지 미확정"
- gap_fill_from: "실무진 + 예전사이트 골든(A3·A2 포스터 실제가) 대조 — 다르면 소형셀 누락, 같으면 의도된 floor"
- gap_owner: staff
- 본문: off-grid ceiling은 문서화된 아키타입 동작(pack §3.10·한 단계 큰 규격)이나, 최소셀(600×600)이 규격 A3/A2보다 커서 소형 포스터가 **최저가 하나로 수렴**하는 것은 비자명한 가격 결과다. 매트릭스 상한(1200×3000)은 nonspec 상한과 정확히 일치(coverage 완전)하나 하한은 gap. [[formula-PRF_POSTER_ARTPRINT]] 가격 사슬은 끊기지 않음(ceiling으로 조회 가능) — 값 의도만 미확정.
