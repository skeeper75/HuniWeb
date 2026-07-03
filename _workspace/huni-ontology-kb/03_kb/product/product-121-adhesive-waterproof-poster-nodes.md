<!-- product-local sub-nodes: E4 material·E9 price_formula·E11 option_group·E12 constraint for PRD_000121 접착방수포스터(실사·면적매트릭스). -->
<!-- ★material(MAT_000179)는 라이브 마스터 원자라 본래 공유 축(axis/materials.md) 소속이고, formula -->
<!--   (PRF_POSTER_ADH_WP)은 formula/silsa-formulas.md 소속이나, 공유 파일 수정 금지 규칙(HARD) 때문에 -->
<!--   여기 임시 거처(broken-link 방지·050-nodes 선례). 축 소유자가 승격 시 canonical id 그대로 이관(삭제) -->
<!--   — needed_shared_nodes로 반환. -->
<!-- ★재사용(중복 mint 없음·본 파일에 노드 미생성·병렬 실사 형제/공유 축이 이미 소유): -->
<!--   category-CAT_000004·category-CAT_000314·size-SIZ_000293 = product-119 companion 기정의(실사 공유 카테고리/A1 규격). -->
<!--   component-COMP_POSTER_ARTPRINT_PHOTO = product-123 companion 기정의(동형결합 4소재 118/120/121/123 공유). -->
<!--   size-SIZ_000174 = product-047 기정의 · size-SIZ_000197 = axis/sizes 기정의 · process-PROC_000014/015 = axis/processes 기정의. -->
<!--   ★이들은 needed_shared_nodes로 반환 — 실사 consolidation(스티커 선례)에서 단일 소유권 확정. -->
<!-- ★수치(치수·매트릭스 shape·수량)는 아래 전사표(transcribed-by·transcribe_product_121.py)에만. props raw 미기입(D-9·L-12). -->
<!-- ★가격 값(unit_price)은 전사하지 않음 — 연결·차원·격자 shape까지만(D-18·값=evaluate_price). -->

# product-121 하위 노드 (접착방수포스터 전용 축 원자 + 공식)

접착방수포스터(PRD_000121) 전용 원자 = PVC 본체 자재·면적매트릭스 가격공식·코팅 옵션 그룹·치수 범위
제약. 실사 공유 원자(카테고리 004/314·A1 규격 293·동형결합 완제품가 comp·A3/A2 규격·라미네이팅 공정)는
형제 상품/공유 축이 이미 소유 → 여기서 중복 mint하지 않고 [[product-121-adhesive-waterproof-poster]]가
참조만 건다(needed_shared_nodes 반환). 공식→구성요소 배선(has_component)·옵션→공정 참조(option_refs)·
제약→상품(constrains)은 아래 블록.

## 치수·자재·수량·면적매트릭스·코팅 전사표 (권위 = 라이브 마스터)

<!-- transcribed-by: _meta/scripts/transcribe_product_121.py from live-snapshot/latest (snap_20260702_1119) t_siz_sizes PRD_000121 @ 2026-07-03 -->
| siz_cd | 라벨 | 작업(work mm) | 재단(cut mm) | 조판(impos_yn) | 마스터 del_yn |
|---|---|---|---|---|---|
| SIZ_000174 | A3(297x420mm) | 297x420 | 297x420 | N | N |
| SIZ_000197 | A2(420x594mm) | 420x594 | 420x594 | N | N |
| SIZ_000293 | A1(594x841mm) | 594x841 | 594x841 | N | Y |

<!-- transcribed-by: _meta/scripts/transcribe_product_121.py from live-snapshot/latest (snap_20260702_1119) t_mat_materials PRD_000121 @ 2026-07-03 -->
| mat_cd | 자재명 | mat_typ | 상위자재 |
|---|---|---|---|
| MAT_000179 | PVC | MAT_TYPE.08 | - |

<!-- transcribed-by: _meta/scripts/transcribe_product_121.py from live-snapshot/latest (snap_20260702_1119) t_prd_products PRD_000121 @ 2026-07-03 -->
| min_qty | max_qty | qty_incr | 단위 | 비규격 | 가로범위(mm) | 세로범위(mm) | 입력증분(mm) |
|---|---|---|---|---|---|---|---|
| 1 | 1000 | 1 | QTY_UNIT.01 | Y | 200~1200 | 200~3000 | 200 |

<!-- transcribed-by: _meta/scripts/transcribe_product_121.py from live-snapshot/latest (snap_20260702_1119) t_prc_component_prices COMP_POSTER_ARTPRINT_PHOTO(SHAPE·값 미전사) @ 2026-07-03 -->
| comp_cd | 차원(use_dims) | distinct 가로 | distinct 세로 | 셀수(단가행) | grid_full | 레거시 comp(use_yn=N) | 레거시 셀수 |
|---|---|---|---|---|---|---|---|
| COMP_POSTER_ARTPRINT_PHOTO | siz_width×siz_height×min_qty | 4 | 13 | 52 | True | COMP_POSTER_ADH_WATERPROOF_PVC | 52 |

<!-- transcribed-by: _meta/scripts/transcribe_product_121.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_option_items PRD_000121(코팅) @ 2026-07-03 -->
| opt_cd | 옵션명 | ref_dim_cd | ref_key1(공정) | 기본 |
|---|---|---|---|---|
| OPV_000022 | 무광코팅 | OPT_REF_DIM.04 | PROC_000015 | Y |
| OPV_000023 | 유광코팅 | OPT_REF_DIM.04 | PROC_000014 | N |

> **grid_full=True** = distinct 가로 4 × distinct 세로 13 = 52 셀이 이 빠짐 없이 채워짐(미적재 셀 0).
> (가로,세로) 순서쌍이 고유 셀(**비대칭**·pack §3.11). 등록 규격 밖 off-grid 치수는 한 단계 큰 치수로
> ceiling(앱 런타임·DB는 룩업행). 가격 값은 이 표에 없다(연결·격자 shape만·값=evaluate_price·D-18).
> ★A1 SIZ_000293은 마스터 `del_yn=Y`(2026-06-17)인데 상품 정션 활성 — dangling 정합은 공유 사이즈
> 노드(product-119 companion size-SIZ_000293·[[gap-119-a1-master-deleted]])에 기록됨. 가격은 면적매트릭스
> (594×841=off-grid→ceiling)라 견적 자체는 동작·UX 노출 불일치만(저severity).

## 자재 노드 (product-local — axis/materials.md 승격 대기·121 전용 PVC)

<!-- ★IMPORT 등록 자재 삭제 금지([[rule/rules#RULE_import_material_no_delete]]). PVC는 접착방수121 전용(형제 미공유). -->

### [material-MAT_000179] PVC (접착방수 본체) {verified}
- type: material
- anchor: t_mat_materials/MAT_000179
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "테이블:t_mat_materials 키:MAT_000179(mat_nm=PVC·mat_typ_cd=MAT_TYPE.08 실사소재·upr_mat_cd 없음·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_materials.csv", source_locator: "키:(PRD_000121,MAT_000179) usage_cd=USAGE.07·dflt_yn=Y", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.08", 사양_ref: "전사표 MAT_000179", 사용: "121 접착방수포스터 본체(USAGE.07 낱장 단일)", note: "실사 소재=상품 정체 결정(pack §3.5). PVC=접착방수(방수포스터120 비접착 PET와 구분). .08 실사소재 정합(레더/패브릭 .05 교정축과 무관·PVC는 .08 유지)"}
- 본문: 접착방수포스터 본체 자재(방수 PVC). parent+usage_cd 단일 슬롯(USAGE.07·pack §3.5). MAT_TYPE.08 실사소재. 형제 실사 상품과 미공유(접착방수 전용).

## 가격공식 노드 (product-local — formula/silsa-formulas.md 승격 대기·121 전용)

<!-- ★접착방수포스터 = 면적매트릭스형(원자합산형·고정가 룩업과 다름). 단일 완제품가 구성요소(코팅·출력·소재 포함 -->
<!--   통가격)를 (가로×세로) 셀에서 조회. round-2 공유공식 PRF_POSTER_FIXED → 상품전용 PRF_POSTER_ADH_WP 재모델(D-WIRE 해소). -->
<!-- ★has_component 타깃 component-COMP_POSTER_ARTPRINT_PHOTO는 형제 product-123 companion 기정의(동형결합 공유)를 참조. -->

### [formula-PRF_POSTER_ADH_WP] 접착방수포스터 완제품가 (면적/규격 단가) {verified}
- type: price_formula
- anchor: t_prc_price_formulas/PRF_POSTER_ADH_WP
- src: {source_file: "live-snapshot/latest/t_prc_price_formulas.csv", source_locator: "테이블:t_prc_price_formulas 키:PRF_POSTER_ADH_WP(frm_nm=접착방수포스터 완제품가(면적/규격 단가)·use_yn=Y·upd 2026-06-18)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prc_formula_components.csv", source_locator: "frm_cd:PRF_POSTER_ADH_WP(comp COMP_POSTER_ARTPRINT_PHOTO·disp_seq 1·addtn Y·1행)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "문서:§3.11 D-WIRE 상품전용 공식 재모델 (승계·재검증 2026-07-03·라이브 PRF_POSTER_ADH_WP 확증)", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-silsa}
- rel: {rel: has_component, target: component-COMP_POSTER_ARTPRINT_PHOTO, qualifier: {disp_seq: 1, addtn: Y}}
- props: {archetype: "면적매트릭스(area-matrix·[가로×세로] 셀 룩업·완제품가)", use_yn: Y, note: "121 접착방수포스터 전용 바인딩(t_prd_product_price_formulas). round-2 PRF_POSTER_FIXED 공유공식에서 상품전용으로 재모델(2026-06-17·D-WIRE 배선단절 해소). 값=evaluate_price"}
- 본문: 접착방수포스터 공식. 단일 완제품가 구성요소 1건 배선(동형결합 공유 comp) — 인쇄·용지·공정을 원자 합산하지 않고 (가로×세로) 면적매트릭스에서 완제품가(코팅포함 통가격)를 조회한다. 값 계산=evaluate_price 권위(D-18·[[rule/rules#RULE_price_value_boundary]]).

## 옵션그룹 노드 (CPQ)

### [optgroup-121-coating] 코팅 (유광/무광 택1) {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000121
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "테이블:t_prd_product_option_groups 키:PRD_000121 opt_grp_cd:OPT_000007(코팅·SEL_TYPE.01·min_sel=0·max_sel=1·mand_yn=N·use_yn=Y)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_options.csv", source_locator: "키:PRD_000121 opt_grp_cd:OPT_000007 (OPV_000022 무광코팅 dflt_yn=Y / OPV_000023 유광코팅)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_option_items.csv", source_locator: "키:PRD_000121 (OPV_000022→PROC_000015 무광 / OPV_000023→PROC_000014 유광·전부 OPT_REF_DIM.04=공정)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: option_refs, target: process-PROC_000015, ref_key1: PROC_000015, note: "무광코팅(OPV_000022)→무광라미네이팅 공정"}
- rel: {rel: option_refs, target: process-PROC_000014, ref_key1: PROC_000014, note: "유광코팅(OPV_000023)→유광라미네이팅 공정"}
- props: {opt_grp_cd: "OPT_000007", sel_typ_cd: "SEL_TYPE.01", mand_yn: "N", 옵션값: "무광코팅(dflt)/유광코팅(2택)", ref_dim: "OPT_REF_DIM.04=공정(라미네이팅)", 가격영향: "없음(코팅포함 통가격·마감 선택)"}
- 본문: 손님이 코팅 마감을 고르는 CPQ 옵션(무광 dflt/유광). 2 option_item이 각각 공정(무광 PROC_000015·유광 PROC_000014)을 가리켜(R11 option_refs·OPT_REF_DIM.04), 부모(PRD_000121) has_process에 실재(L-18 통과·fn_chk_opt_item_ref 정합). 타깃 공정 2종은 [[axis/processes#process-PROC_000014]]·[[axis/processes#process-PROC_000015]] 공유 축 재사용. ★가격은 면적매트릭스 완제품가에 코팅이 포함(통가격)이라 코팅 선택이 단가를 바꾸지 않음(가격 미가산·마감 선택).

## 제약규칙 노드 (§31 — 비규격 치수 범위)

### [constraint-121-size-range] 사용자입력 치수 범위 {verified}
- type: constraint
- anchor: t_prd_product_constraints/PRD_000121
- src: {source_file: "live-snapshot/latest/t_prd_product_constraints.csv", source_locator: "테이블:t_prd_product_constraints 키:(PRD_000121,RULE_001) rule_nm=사용자입력 치수 범위·rule_typ_cd=RULE_TYPE.01·use_yn=Y·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "문서:§1.1/§3.9 constraints 7상품 신규 발현(121 포함) (승계·재검증 2026-07-03·라이브 1행 확증)", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-silsa}
- rel: {rel: constrains, target: product-121-adhesive-waterproof-poster, note: "비규격 입력 시 가로 200~1200·세로 200~3000 범위 검증"}
- props: {rule_typ_cd: "RULE_TYPE.01", cn_type: "CN-5(범위·비규격 치수)", logic_ref: "size_mode=nonspec이면 200≤width≤1200 AND 200≤height≤3000(라이브 JSONLogic·shape는 폼빌더 확인 대상)", note: "위키 round-13 'constraints 0행'은 낡음(pack T-3)·121 1행 신규 발현(REVERIFY→현재값). 범위 상하한은 전사표 nonspec 범위와 동일"}
- 본문: 접착방수포스터 비규격 치수 입력 검증 제약. size_mode=nonspec(사용자입력)일 때 가로 200~1200mm·세로 200~3000mm 범위를 벗어나면 막는다(CN-5 범위형). ★제약 shape는 폼빌더에서 읽고 조정 가능한 정형이어야 함(raw JSONLogic escape hatch 금지·CLAUDE.md §31)·shape 상세는 §31 하네스 소관. evaluate_price는 제약 미참조(위젯/주문이 validate 호출해야 강제).
