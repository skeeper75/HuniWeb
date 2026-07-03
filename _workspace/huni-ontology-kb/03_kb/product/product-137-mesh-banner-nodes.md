<!-- product-local sub-nodes: E2 category(CAT_000315 첫 정의)·E3 size·E8 bundle_qty·E9 price_formula·E10 price_component·E11 option_group 2·gap 3 for PRD_000137 메쉬배너. -->
<!-- ★공유 노드 재사용(중복 mint 방지·L-3·재정의 안 함·참조만): -->
<!--   - material-MAT_000183(메쉬·MAT_TYPE.08 미교정) = product-128-mesh-print-nodes가 canonical 정의 → 137 main이 uses_material로 참조만. -->
<!--     그 정정 목표유형 미확정 GAP(gap-128-mesh-mattype-correction)도 128 소유 → 137은 재정의 안 함(참조만). needed_shared 반환. -->
<!--   - process-PROC_000079(타공·4구 아일렛) = axis/processes.md canonical → 137 main이 has_process로 참조만(재사용). -->
<!--   - category-CAT_000315(배너/현수막·lvl2·부모 CAT_000005 사인)·size-SIZ_000321(600x1800) = 병렬 형제 product-136-pet-banner-nodes(PET배너)가 companion mint(canonical·needed_shared) → 137은 참조만(재정의 금지·L-3 회피). 부모 CAT_000005는 계층 참조(props upr_cat_cd)이지 노드 미생성. -->
<!-- ★여기 정의(137 고유·타 빌더 미정의): qty·optgroup 2(가공 holepunch·추가 standoff BLOCKED)·formula(PRF_POSTER_MESH_BANNER·needed_shared)·component(COMP_POSTER_MESH_BANNER·needed_shared)·gap 3. -->
<!-- ★수치(사이즈·격자 shape·옵션 shape)는 아래 전사표(transcribed-by·transcribe_product_137.py)에만. props raw 미기입(D-9·L-12). -->
<!-- ★가격 값(unit_price)은 전사하지 않음 — 연결·차원·격자완전성까지만(D-18·값=evaluate_price). 고정가 셀 단가범위는 grid shape 증거만. -->

# product-137 하위 노드 (메쉬배너 전용 축 원자 + 공식/GAP)

메쉬배너(PRD_000137)가 쓰는 배너/현수막 카테고리·600×1800 규격 사이즈·가격공식·구성요소·수량규칙·
CPQ 옵션그룹 2·GAP 3. 상품→축 연결(has_size·uses_material·has_process·priced_by·has_qty_rule·
has_option_group·in_category)은 [[product-137-mesh-banner]]가 건다. 메쉬 자재(MAT_000183)·타공 공정
(PROC_000079)는 **공유 노드 재사용**(위 주석·재정의 안 함). 공식→구성요소 배선(has_component)은 아래 formula 블록.

## 상품 요소 전사표 (권위 = 라이브 마스터·스크립트 전사)

> 아래 표는 모두 `_meta/scripts/transcribe_product_137.py`가 live-snapshot(snap_20260702_1119)에서 결정론
> 전사(LLM 손전사 금지·D-9). 캐시=`_meta/scripts/cache/transcribed-137-260703.json`. 실사 시트는 260702 diff
> 무영향(pack §5.5)이라 라이브 현재값=권위 정합(양면 소재 없음·메쉬 .08은 128 canonical GAP).

### 상품 정체·수량 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_137.py from live-snapshot/latest (snap_20260702_1119) t_prd_products PRD_000137 @ 2026-07-03 -->
| prd_typ_cd | nonspec | min_qty | max_qty | qty_incr | qty_unit | file_upload | editor | use_yn |
|---|---|---|---|---|---|---|---|---|
| PRD_TYPE.01 | N | 1 | 10000 | 1 | QTY_UNIT.01 | Y | N | Y |

> nonspec_yn=N → 비규격 연속범위 없음(이산 단일 규격 600x1800만). 수량 min1/max10000/incr1(제품 레벨).

### 카테고리 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_137.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_categories+t_cat_categories @ 2026-07-03 -->
| cat_cd | 이름 | 부모 | lvl | main_cat_yn(링크) |
|---|---|---|---|---|
| CAT_000315 | 배너/현수막 | CAT_000005 | 2 | N |

> ★junction 1행(CAT_000315 배너/현수막·lvl2)만. 부모 CAT_000005(사인·root)는 카테고리 계층(upr_cat_cd)이지 junction 링크 아님. CAT_000315는 신규노드(06-19·pack §1.1 신규 314/315·leaf 귀속 정밀도 확인 대상).

### 사이즈 (전사·전 행·del 표기·nonspec_yn=N 이산 단일)

<!-- transcribed-by: _meta/scripts/transcribe_product_137.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_sizes+t_siz_sizes @ 2026-07-03 -->
| siz_cd | 라벨 | 작업(mm) | impos_yn | nonspec | dflt | 링크 del | 마스터 del |
|---|---|---|---|---|---|---|---|
| SIZ_000321 | 600x1800mm | 600x1800 | N | N | Y | N | N |

### 자재 (전사·★메쉬 MAT_TYPE.08 미교정·128 canonical 재사용)

<!-- transcribed-by: _meta/scripts/transcribe_product_137.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_materials+t_mat_materials @ 2026-07-03 -->
| mat_cd | 이름 | mat_typ | 상위자재 | usage_cd | dflt |
|---|---|---|---|---|---|
| MAT_000183 | 메쉬 | MAT_TYPE.08 | (공백·부모) | USAGE.07 | Y |

> ★메쉬 MAT_000183 = MAT_TYPE.08 실사소재(미교정 잔존·형제 레더 MAT_000186은 .05 교정됨). DB note '→원단(.05)'는 MAT_TYPE 코드 개편으로 STALE(pack T-2). material-MAT_000183·GAP은 128 메쉬프린트가 canonical 정의(재정의 안 함·L-3).

### 공정 (전사·타공 4구 아일렛·mand N·구수 param)

<!-- transcribed-by: _meta/scripts/transcribe_product_137.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_processes+t_proc_processes @ 2026-07-03 -->
| proc_cd | 공정명 | 상위공정 | mand | prcs_dtl_opt(param) | 링크 del |
|---|---|---|---|---|---|
| PROC_000079 | 타공 | (없음) | N | `{"inputs": [{"key": "구수", "max": 8, "min": 1, "type": "integer", "unit": "개"}]}` | N |

### 판형 (전사·전 행·del 표기 — ★비종이류=판형 무의미·del_yn=Y)

<!-- transcribed-by: _meta/scripts/transcribe_product_137.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_plate_sizes @ 2026-07-03 -->
| siz_cd | output_paper_typ | output_file | dflt | del | note |
|---|---|---|---|---|---|
| SIZ_000321 | (공백) | JPG | Y | Y | 파일사양 |

### CPQ 옵션 레이어 (전사·★130과 차이·2그룹)

<!-- transcribed-by: _meta/scripts/transcribe_product_137.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_option_groups+t_prd_product_options @ 2026-07-03 -->
| opt_grp_cd | 그룹명 | sel_typ | min/max_sel | mand | 옵션값(opt_cd·dflt) | 그룹 note |
|---|---|---|---|---|---|---|
| OPT_000020 | 가공 | SEL_TYPE.01 | 1/1 | Y | 4구타공(OPV_000040·dflt=Y) | 4구타공 필수 (구수 param=GAP) |
| OPT_000021 | 추가 | SEL_TYPE.01 | 0/1 | N | 거치대없음(OPV_000041·dflt=Y) | 배너거치대 추가 (template·BLOCKED) |

### CPQ 옵션 아이템 (전사·다형참조 ref_dim_cd)

<!-- transcribed-by: _meta/scripts/transcribe_product_137.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_option_items @ 2026-07-03 -->
| opt_cd | item_seq | ref_dim_cd | ref_key1 | ref_key2 | qty |
|---|---|---|---|---|---|
| OPV_000040 | 1 | OPT_REF_DIM.04 | PROC_000079 | - | 1 |

> ★OPV_000040 4구타공 → OPT_REF_DIM.04(공정)·ref_key1=PROC_000079(타공)·qty 1. 구수 param(구수 min1/max8)은 item에 미지정=GAP. ★OPV_000041 거치대없음 → option_item 없음(배너거치대 template BLOCKED·부속 우드거치대 PRD_000012 재연결 대기).

### 미보유 축 (전사·0행 실측)

<!-- transcribed-by: _meta/scripts/transcribe_product_137.py from live-snapshot/latest (snap_20260702_1119) print_options/bundle_qtys/addons/constraints/sets @ 2026-07-03 -->
| 축 | 행수 |
|---|---|
| print_options(도수) | 0 |
| bundle_qtys(묶음수) | 0 |
| addons(추가상품) | 0 |
| constraints(제약규칙) | 0 |
| sets(셋트 부모) | 0 |
| option_groups(CPQ 옵션) | 2 |

### 가격 배선 (전사·priced_by→공식→구성요소)

<!-- transcribed-by: _meta/scripts/transcribe_product_137.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_price_formulas+t_prc_formula_components+t_prc_price_components @ 2026-07-03 -->

공식 **PRF_POSTER_MESH_BANNER** — 메쉬배너 완제품가(면적/규격 단가) (use_yn=Y)

| disp_seq | comp_cd | addtn | prc_typ | comp_nm | use_dims |
|---|---|---|---|---|---|
| 1 | COMP_POSTER_MESH_BANNER | Y | PRICE_TYPE.01 | 메쉬배너 완제품가 | `["siz_cd", "min_qty"]` |

### 고정가 룩업 셀 요약 (전사·D-22 접기 — 전개 금지·값=range shape 증거만·개별값 미노출)

<!-- transcribed-by: _meta/scripts/transcribe_product_137.py from live-snapshot/latest (snap_20260702_1119) t_prc_component_prices (COMP_POSTER_MESH_BANNER 집계) @ 2026-07-03 -->
| comp_cd | use_yn | 행수 | 사이즈축 | 수량구간축(min_qty) | 셀존재/잠재 | 단가범위(shape) | use_dims |
|---|---|---|---|---|---|---|---|
| COMP_POSTER_MESH_BANNER | Y | 1 | SIZ_000321 | 1 | 1/1 | 38000~38000 | `["siz_cd", "min_qty"]` |

> ★셀존재/잠재 = 사이즈 1(SIZ_000321) × 수량구간(min_qty) 조합. use_dims=[siz_cd, min_qty]=규격×수량구간 블록
> (면적매트릭스 아님·siz_width/siz_height 미사용). 수량구간이 min_qty=1 단일 tier면 사실상 수량무관 flat 가격
> (600x1800 수량 1 이상 완제품가·출력+코팅+가공(4구아일렛) 포함가). 격자완전(cells_present=combos_potential).
> 단가범위는 격자 shape 증거일 뿐 — 개별 셀단가·계산=evaluate_price 권위(D-18·값 노드 미기록).

## 카테고리·사이즈 노드 (★재사용 — 136 PET배너가 canonical·재정의 안 함·L-3 회피)

<!-- ★category-CAT_000315(배너/현수막·부모 CAT_000005 사인·lvl2)·size-SIZ_000321(600x1800mm 배너 단일 규격)은 -->
<!-- 병렬 형제 product-136-pet-banner-nodes(PET배너)가 companion mint(canonical·needed_shared)한 공유 축이라 -->
<!-- 137은 참조만(재정의 금지·L-3 중복 회피). 136/137 둘 다 실사 배너류로 같은 배너/현수막 카테고리·600x1800 규격 공유. -->
<!-- 137 main이 in_category→category-CAT_000315·has_size→size-SIZ_000321로 참조(빌더가 136 정의로 해소). -->
<!-- consolidation이 136/137 중 canonical 선정·향후 axis/categories.md·axis/sizes.md 승격(needed_shared 반환). -->
<!-- 부모 CAT_000005(사인·root)는 카테고리 계층(props upr_cat_cd)이지 노드 미생성(137 junction 미링크·orphan 회피). -->

## 수량규칙 노드 (product-local)

### [qty-137] 메쉬배너 수량규칙 {verified}
- type: bundle_qty
- anchor: t_prd_products/PRD_000137
- src: {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "키:PRD_000137 min_qty/max_qty/qty_incr(1/10000/1)·qty_unit_typ_cd=QTY_UNIT.01", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/_foundation/batch/qty_rule_audit_260702.py", source_locator: "수량 UI 권위=상품/사이즈 규칙(가격구간과 역할 분리)", captured_at: "2026-07-03", badge: verified, src_id: SR-27-qtyaudit}
- props: {min_max_incr_ref: "전사표 수량규칙(상품 1/10000/1)", bdl_unit_typ_cd: "QTY_UNIT.01", bundle_qtys_rows: 0, note: "★130과 달리 137 구성요소 use_dims에 수량구간 min_qty 축 있음(규격×수량구간). 다만 라이브 격자는 min_qty=1 단일 tier라 사실상 수량무관 flat 가격(수량구간 할인 없음·t_dsc_* 0행). t_prd_product_bundle_qtys 0행 정상(수량 UI 권위=상품 레벨)"}
- 본문: 수량 그릇 = 상품 마스터 컬럼(min 1·max 10000·incr 1). t_prd_product_bundle_qtys 0행 정상(수량 UI 권위=상품 레벨·[[rule/decisions#DEC_qty_audit_260702]]). 가격 격자에 min_qty 축이 있으나 단일 tier(1 이상)라 flat.

## CPQ 옵션그룹 노드 (product-local — 137 CPQ 2그룹·실사 옵션 레이어 실재 사례)

<!-- ★137은 130/131과 달리 옵션그룹 2행 실재. optgroup-137-holepunch(가공·mand Y)의 option_refs 타깃 PROC_000079는 -->
<!-- 137 has_process에 실재(L-18 부모정합 통과). optgroup-137-standoff(추가·mand N)는 배너거치대 template BLOCKED이라 option_item 없음(option_refs 미배선·GAP). -->

### [optgroup-137-holepunch] 가공 (4구타공 필수·택1) {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000137
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "키:(PRD_000137,OPT_000020)(opt_grp_nm=가공·SEL_TYPE.01·min_sel=1·max_sel=1·mand_yn=Y·use_yn=Y·del_yn=N·note '4구타공 필수 (구수 param=GAP)')", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_options.csv", source_locator: "키:(PRD_000137,OPT_000020) OPV_000040 4구타공(dflt_yn=Y)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_option_items.csv", source_locator: "키:(PRD_000137,OPV_000040,item_seq 1) ref_dim_cd=OPT_REF_DIM.04·ref_key1=PROC_000079·qty=1", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: option_refs, target: process-PROC_000079, ref_key1: PROC_000079, note: "4구타공(OPV_000040)→공정 타공(OPT_REF_DIM.04)"}
- props: {opt_grp_cd: "OPT_000020", sel_typ_cd: "SEL_TYPE.01", mand_yn: "Y", 옵션값: "4구타공(택1·단일 옵션)", ref_dim: "OPT_REF_DIM.04=공정(4구 아일렛 타공=완제품 통가격 포함·가산 아님)", 구수_param: "GAP(구수 min1/max8 미지정)"}
- 본문: 손님이 가공을 고르는 CPQ 옵션(필수·택1·현재 4구타공 단일). option_item이 공정 PROC_000079(타공)를 가리켜(R11 option_refs·OPT_REF_DIM.04) has_process 차원으로 환원(L-18 통과·부모 137 has_process 실재). ★단 구수(구멍 개수) param(min1/max8)이 item에 미지정 → 몇 구멍 타공인지 미확정([[product-137-mesh-banner-nodes#gap-137-holepunch-param]]·pack §3.6 GAP-SL-2). 타공은 고정가 통가격에 포함(comp note "가공(4구아일렛) 포함가"·별도 가산 아님).

### [optgroup-137-standoff] 추가 (배너거치대·택1·★template BLOCKED) {defect}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000137
- current_value: "옵션값=거치대없음(OPV_000041) 단일·option_item 0건(배너거치대 template 미배선·부속 우드거치대 미연결)"
- authority_value: "배너거치대(우드거치대 PRD_000012) 추가 옵션이 template로 연결돼 손님이 거치대 유무를 고를 수 있어야 함(pack §3.12 137→우드거치대012 재연결 대상). 현재는 '거치대없음'만 있어 실질 선택 불가(BLOCKED)"
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "키:(PRD_000137,OPT_000021)(opt_grp_nm=추가·SEL_TYPE.01·min_sel=0·max_sel=1·mand_yn=N·use_yn=Y·del_yn=N·note '배너거치대 추가 (template·BLOCKED)')", captured_at: "live 20260702_1119", badge: defect, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_options.csv", source_locator: "키:(PRD_000137,OPT_000021) OPV_000041 거치대없음(dflt_yn=Y)·이 opt_cd에 대한 t_prd_product_option_items 0건", captured_at: "live 20260702_1119", badge: defect, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "문서:§3.12 부속붙는 8상품(137→우드거치대012)·§1.1 SL-DEF-005 addon/set 0행 잔존·GAP-SL-4/5(승계·재검증 2026-07-03)", captured_at: "2026-07-03", badge: defect, src_id: SR-pack-silsa}
- props: {opt_grp_cd: "OPT_000021", sel_typ_cd: "SEL_TYPE.01", mand_yn: "N", 옵션값: "거치대없음(단일·거치대 자체 미배선)", note: "배너거치대 추가 template이 BLOCKED — '거치대없음'(OPV_000041)만 있고 option_item 0건이라 부속 우드거치대(PRD_000012)를 얹는 경로가 없음. 부속 미연결(addon/set 0행)과 정합(pack §3.12·GAP-SL-4/5). option_refs 미배선이라 L-18 대상 아님(옵션 아이템 자체 부재)"}
- 본문: 손님이 배너거치대를 추가하는 CPQ 옵션(선택·mand N)이나 현재 "거치대없음"(OPV_000041) 단일 옵션만 있고 option_item이 0건이라 **실질 선택 불가(template BLOCKED)**. pack §3.12는 137 메쉬배너를 우드거치대 PRD_000012 재연결 대상으로 지목하나 라이브 addon/set 0행 잔존(SL-DEF-005 미교정). 양면 표기: 현재값=거치대없음만·정답=우드거치대 추가 가능해야 함. 상세 GAP=[[product-137-mesh-banner-nodes#gap-137-standoff-addon-blocked]]. ★부속 PRD_000012 실재(search-before-mint 충족·재연결만·신규 mint 금지).

## 가격공식 노드 (product-local — silsa formula 축 승격 대기·needed_shared)

<!-- ★고정가 룩업형(규격×수량구간·면적매트릭스·원자합산과 다른 아키타입). 단일 구성요소(완제품가)를 (siz_cd×min_qty) 셀에서 조회. -->
<!-- has_component 타깃 component-COMP_POSTER_MESH_BANNER = 아래 137 canonical 정의(137 전용·타 상품 미공유·128 메쉬프린트의 동형결합 COMP_POSTER_CANVAS_FABRIC와 다름). -->

### [formula-PRF_POSTER_MESH_BANNER] 메쉬배너 완제품가 (고정가 룩업·규격×수량구간) {verified}
- type: price_formula
- anchor: t_prc_price_formulas/PRF_POSTER_MESH_BANNER
- src: {source_file: "live-snapshot/latest/t_prc_price_formulas.csv", source_locator: "테이블:t_prc_price_formulas 키:PRF_POSTER_MESH_BANNER(frm_nm=메쉬배너 완제품가(면적/규격 단가)·note=포스터사인 메쉬배너 소재/사이즈/수량별 완제품 통가격·use_yn=Y)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prc_formula_components.csv", source_locator: "frm_cd:PRF_POSTER_MESH_BANNER(comp COMP_POSTER_MESH_BANNER·disp_seq 1·addtn_yn Y·1행)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_price_formulas.csv", source_locator: "키:(PRD_000137,PRF_POSTER_MESH_BANNER) 바인딩·apply_bgn_ymd=2026-06-01", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: has_component, target: component-COMP_POSTER_MESH_BANNER, qualifier: {disp_seq: 1, addtn: Y}}
- props: {archetype: "고정가 룩업형(fixed·통가격)", use_yn: Y, note: "137 바인딩 전용 공식. 단일 구성요소(완제품가)를 (siz_cd×min_qty) 셀에서 조회(evaluate_price). frm_nm '(면적/규격 단가)'는 명명일 뿐·실 use_dims=[siz_cd,min_qty] 고정 룩업(면적매트릭스 아님·전사표 검증). ★128 메쉬프린트(면적매트릭스 PRF_POSTER_MESH)와 다른 공식·다른 아키타입"}
- 본문: 메쉬배너 가격공식. 단일 구성요소(완제품가) 1건 배선 — 인쇄·용지·타공을 원자 합산하지 않고 (규격×수량구간) 고정 룩업에서 완제품 통가격을 조회한다. 배선 타깃 [[component-COMP_POSTER_MESH_BANNER]](아래 137 canonical 정의). 고아 공식 아님(has_component 1건·O6 충족·pack §27 정합). 값 계산=evaluate_price 권위(D-18·[[rule/rules#RULE_price_value_boundary]]). 공유 formula 파일 미등재·승격 대기(needed_shared·실사 고정가 15상품 축).

## 가격구성요소 노드 (product-local canonical — 고정가 룩업·silsa component 축 승격 대기·needed_shared)

<!-- ★COMP_POSTER_MESH_BANNER = 메쉬배너 완제품가(규격×수량구간). 137 전용(타 상품 미공유). -->
<!-- ★단가행(1셀)은 노드로 펼치지 않고 use_dims 차원+SHAPE로 접음(D-22). 값(unit_price)은 grid shape 증거로만·개별 셀단가 미전사(evaluate_price 권위). -->

### [component-COMP_POSTER_MESH_BANNER] 메쉬배너 완제품가 (규격×수량구간·고정 룩업) {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_POSTER_MESH_BANNER
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "테이블:t_prc_price_components 키:COMP_POSTER_MESH_BANNER(comp_typ=PRC_COMPONENT_TYPE.06·prc_typ_cd=PRICE_TYPE.01·use_dims=[siz_cd,min_qty]·note '포스터·사인 완제품가(소재+출력+가공 포함 통가격). 사이즈·수량별 단가표.'·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/_meta/scripts/cache/transcribed-137-260703.json", source_locator: "grid.COMP_POSTER_MESH_BANNER(행1·사이즈 SIZ_000321·수량구간 1·셀 1/1 유효·단가범위 shape 38000)", captured_at: "2026-07-03", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.01", comp_typ_cd: "PRC_COMPONENT_TYPE.06", use_dims: '["siz_cd", "min_qty"]', role: "메쉬배너 완제품 통가격(소재+출력+가공(4구아일렛) 포함)", 단가행_ref: "전사표 고정가 shape(1행=규격1×수량구간1·유효격자 1/1·min_qty=1 단일 tier)", archetype: "고정가 룩업(fixed·규격×수량구간·면적매트릭스 아님)"}
- 본문: 메쉬배너 완제품가 구성요소(canonical·137 전용). use_dims 2축(사이즈 siz_cd × 수량구간 min_qty)으로 셀단가가 달라진다(차원 선언까지·D-22 단가행 접기). 라이브 격자는 규격1(600×1800)×수량구간1(min_qty=1) = 유효 1셀(전사표 SHAPE·격자완전). 값=evaluate_price(개별 셀단가 미전사·단가범위는 grid shape 증거만·D-18·[[rule/rules#RULE_price_value_boundary]]). 단가는 인쇄상품 가격표 260527 verbatim(comp note). 공유 component 파일 미등재·승격 대기(needed_shared).

## GAP 노드 (원천 부재·정직 선언)

### [gap-137-holepunch-param] 4구타공 구수 param 미지정 (GAP-SL-2) {unknown}
- type: gap
- anchor: none  # 사유: 타공 공정 param(구수 min1/max8)이 옵션 아이템에 미지정 — 몇 구멍 타공인지 확정 원천 부재
- src: {source_file: "live-snapshot/latest/t_prd_product_option_items.csv", source_locator: "키:(PRD_000137,OPV_000040,item_seq 1) ref_dim_cd=OPT_REF_DIM.04·ref_key1=PROC_000079·qty=1 — dtl_opt 공백(구수 값 미지정) vs PROC_000079 prcs_dtl_opt '구수' min1/max8", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "문서:§3.6 GAP-SL-2(봉제/족자 variant 적재 위치·param 인스턴스 경로·CPQ option_items vs prcs_dtl_opt param)·Q-SL-2", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-silsa}
- gap_what: "4구타공 옵션(OPV_000040)이 공정 PROC_000079(타공)를 가리키나, 타공 공정의 param '구수'(구멍 개수·min1/max8)가 option_item에 값으로 지정되지 않음. 그룹 note가 '4구타공'이라 4구로 추정되나 구수 param 인스턴스(어디에 4가 저장되는지)가 미확정 — CPQ option_item의 dtl_opt vs 공정 prcs_dtl_opt param 인스턴스 경로 확정 원천 부재(pack GAP-SL-2)"
- gap_fill_from: "실무진 + pack §3.6 GAP-SL-2(봉제/족자/타공 variant param 적재 위치 결정·Q-SL-2). 타공은 통가격 포함이라 가격 영향 없음(구수는 생산 지시 param)"
- gap_owner: staff
- 본문: 가격 경로는 연결됨([[formula-PRF_POSTER_MESH_BANNER]]→[[component-COMP_POSTER_MESH_BANNER]]·유효 1/1셀)이라 견적 0 위험 없음(타공=통가격 포함). 다만 4구타공의 구수 param(구멍 개수) 값이 option_item에 미지정 → 생산 지시 param 인스턴스 경로가 미확정(pack GAP-SL-2·봉제/족자와 동류). 정직 선언(값 정합 아님·param 저장처 미상).

### [gap-137-standoff-addon-blocked] 배너거치대 부속 addon/set 0행 (template BLOCKED·GAP-SL-4/5) {unknown}
- type: gap
- anchor: none  # 사유: 배너거치대(우드거치대 PRD_000012) 부속이 addon/set 0행·옵션 template BLOCKED이라 부속 연결 경로 미확정
- src: {source_file: "live-snapshot/latest/t_prd_product_addons.csv", source_locator: "키:PRD_000137 0행(addons) + t_prd_product_sets PRD_000137 0행(부모) + t_prd_product_option_items OPV_000041 0건(거치대없음만)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "문서:§3.12 부속붙는 8상품(PET배너136/메쉬배너137→우드거치대012)·§1.1 SL-DEF-005 addon/set 0행 잔존·§5 GAP-SL-4/5·§4 SL-DEF-005 잔존 판정", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-silsa}
- gap_what: "메쉬배너는 '단품+부속(배너거치대)' 정체이나 라이브 t_prd_product_addons=0·t_prd_product_sets(부모)=0이라 부속 미연결. 옵션그룹 OPT_000021(추가)도 '거치대없음'(OPV_000041) 단일에 option_item 0건이라 template BLOCKED. pack §3.12는 137→우드거치대 PRD_000012 재연결 대상으로 지목(부속 PRD 실재·search-before-mint 충족·재연결만)이나 방식(addon vs set vs 옵션 template) 미확정(GAP-SL-4/5)"
- gap_fill_from: "실무진 + 인간 승인(pack §5 GAP-SL-4 부속 귀속·GAP-SL-5 BUNDLE 자재 mint·137→우드거치대012 재연결). 부속 PRD_000012 실재(신규 mint 금지·재연결만)·라이브 COMMIT은 dbmap/§23 트랙 위임"
- gap_owner: staff
- 본문: 메쉬배너의 부속(배너거치대=우드거치대 PRD_000012) 연결이 라이브에 미적재(addon/set 0행·옵션 template BLOCKED). 이것은 실사 부속붙는 8상품 공통 잔존(SL-DEF-005·pack §3.12·§4)이다. 부속 PRD_000012는 실재하므로 신규 mint 없이 재연결만 필요하나 방식(addon/set/옵션 template)·값이 미확정 → 정직 선언(GAP-SL-4/5). 양면 노드 optgroup-137-standoff와 짝(그 노드는 옵션 template BLOCKED의 현재값/정답, 이 GAP은 부속 연결 방식 미상).

### [gap-137-fixedprice-basis] 배너 완제품 통가격 산정 근거 문서 부재 {unknown}
- type: gap
- anchor: none  # 사유: 고정가 셀 완제품 통가격(소재+출력+가공)이 어떤 규칙으로 산정됐는지 엑셀 미기재 암묵지
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/source-registry.md", source_locator: "문서:§9 GAP-2 롤 소재 가격 계산 로직(엑셀 미기재 암묵지·실사 전체 영향)", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-silsa}
- gap_what: "고정가 1셀(600×1800·수량 1 이상) 완제품 통가격이 메쉬 소재 롤 원가+대형 잉크젯 출력비+코팅+4구 아일렛 타공 가공비를 어떤 규칙으로 통합해 산출됐는지 — 값은 라이브에 적재됐고(260527 verbatim) 라이브 셀단가=가격표 원본이나 산정식 자체는 문서 부재(롤 소재 실사 전체 공통 GAP)"
- gap_fill_from: "실무진 확인(source-registry §9 GAP-2·실사 전체 공통·롤 소재 가격 계산 로직). 예전사이트 골든 대조로 값 정합 검증 가능하나 산정식은 암묵지"
- gap_owner: staff
- 본문: 가격 경로는 연결됨([[formula-PRF_POSTER_MESH_BANNER]]→[[component-COMP_POSTER_MESH_BANNER]]·유효 1/1셀 완전격자)이라 견적 0 위험 없음. 다만 통가격이 **어떻게** 산정됐는지는 엑셀 미기재 암묵지(실사 롤 소재 전체 공통 GAP·source-registry §9 GAP-2). 온톨로지는 연결·차원까지, 값 계산은 evaluate_price 권위이므로 이 GAP은 값 정합이 아니라 "산정 근거 문서 부재"의 정직 선언. 137은 메쉬 그물망 대형 롤이라 "롤 소재 가격 계산 로직" GAP에 직접 해당.
