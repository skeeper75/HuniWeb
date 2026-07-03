<!-- product-local sub-nodes: E3 size·E8 bundle_qty·E9 formula·E10 component·E11 option_group·E12 constraint·gap for PRD_000139 메쉬현수막(실사 면적매트릭스 + 옵션 add-on BUNDLE·138 일반현수막 파일럿 동형). -->
<!-- ★공유 노드 재사용(중복 mint 방지·L-3 — 병렬 빌더 실측 후 재조준): -->
<!--   - category-CAT_000315(배너/현수막) = 136-nodes(PET배너)가 canonical 정의 → 여기서 재정의 안 함. 139 main이 in_category로 참조만. -->
<!--   - material-MAT_000183(메쉬) = 128-nodes(메쉬프린트)가 canonical 정의 → 재정의 안 함. 139 main이 uses_material로 참조만. -->
<!--   - material-MAT_000070(설치용끈) = 138-nodes(일반현수막)가 canonical 정의 → 재정의 안 함. 139 main이 uses_material로 참조만. -->
<!--   - process-PROC_000079(타공) = 공유 axis/processes.md가 canonical 정의 → 재정의 안 함. 139 main·optgroup이 참조만. -->
<!--   - process-PROC_000081(부착)·process-PROC_000084(열재단·138이 defect 판정) = 138-nodes가 canonical 정의 → 재정의 안 함. 139 main이 has_process로 참조만. -->
<!--   - gap-126-roll-material-pricing·gap-128-mesh-mattype-correction = 126/128-nodes 정의 → 재생성 안 함. 참조만. -->
<!-- ★여기 정의(139 고유·타 빌더 미정의): size 3(323/320/322)·formula(PRF_POSTER_BANNER_M)·component 6(base COMP_POSTER_BANNER_MESH[단독]+add-on5)·optgroup 2·constraint 1·gap 3. -->
<!-- ★수치(치수·매트릭스 shape·옵션 단가)는 상단 전사표(transcribed-by·transcribe_product_139.py)에만. props raw 미기입(D-9·L-12). -->
<!-- ★가격 값(unit_price)은 노드에 전사하지 않음 — 연결·차원·격자까지만(D-18·값=evaluate_price). 전사표 단가범위는 스크립트 집계(손전사 아님). -->

# product-139 하위 노드 (메쉬현수막 전용 축 원자 + 공식/구성요소/옵션/제약/GAP)

메쉬현수막(PRD_000139)이 쓰는 규격 3·가격공식·구성요소 6(base + add-on 5)·옵션그룹 2·제약 1·
수량규칙·GAP 3. ★카테고리(CAT_000315=136 PET배너)·메쉬 자재(MAT_000183=128)·설치용끈
(MAT_000070=138 일반현수막)·타공 공정(PROC_000079=axis)·부착/열재단(PROC_000081/084=138)·롤소재
GAP(126)·메쉬 자재유형 GAP(128)은 **형제 빌더가 canonical 소유 — 여기서 재정의 없이 참조만**(병렬
빌더 실측 후 재조준·L-3 중복 회피). 상품→축 연결(in_category·has_size·uses_material·has_process·
priced_by·has_qty_rule·has_option_group)은 [[product-139-mesh-hanging-banner]]가 건다.

## 치수·자재·공정·판형·옵션·제약·가격배선·단가행 전사표 (권위 = 라이브 마스터)

### 상품 정체·수량·비규격 범위 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_139.py from live-snapshot/latest (snap_20260702_1119) t_prd_products PRD_000139 @ 2026-07-03 -->
| prd_typ_cd | nonspec | min_qty | max_qty | qty_incr | qty_unit | file_upload | editor | use_yn |
|---|---|---|---|---|---|---|---|---|
| PRD_TYPE.01 | Y | (빈값) | (빈값) | (빈값) | QTY_UNIT.01 | Y | N | Y |

| 비규격축 | width_min | width_max | width_incr | height_min | height_max | height_incr |
|---|---|---|---|---|---|---|
| nonspec | 500 | 900 | 100 | 500 | 3000 | 100 |

### 카테고리 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_139.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_categories+t_cat_categories @ 2026-07-03 -->
| cat_cd | 이름 | 부모 | lvl | main_cat_yn |
|---|---|---|---|---|
| CAT_000315 | 배너/현수막 | CAT_000005 | 2 | N |

### 사이즈 (전사·전 행·del 표기)

<!-- transcribed-by: _meta/scripts/transcribe_product_139.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_sizes+t_siz_sizes @ 2026-07-03 -->
| siz_cd | 라벨 | 작업(mm) | dflt | 링크 del | 마스터 del |
|---|---|---|---|---|---|
| SIZ_000323 | 900x900 | 900x900 | Y | N | N |
| SIZ_000320 | 900x1200 | 900x1200 | Y | N | N |
| SIZ_000322 | 5000x900 | 5000x900 | Y | N | N |

### 자재 (전사·2 슬롯 — 본체 메쉬 + 설치용끈 BUNDLE)

<!-- transcribed-by: _meta/scripts/transcribe_product_139.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_materials+t_mat_materials @ 2026-07-03 -->
| mat_cd | 이름 | mat_typ | usage_cd | dflt |
|---|---|---|---|---|
| MAT_000183 | 메쉬 | MAT_TYPE.08 | USAGE.07 | Y |
| MAT_000070 | 설치용끈 | MAT_TYPE.16 | USAGE.07 | N |

### 공정 (전사·전 행·del/param 표기)

<!-- transcribed-by: _meta/scripts/transcribe_product_139.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_processes+t_proc_processes @ 2026-07-03 -->
| proc_cd | 이름 | mand | 링크 del | 마스터 del | param |
|---|---|---|---|---|---|
| PROC_000079 | 타공 | N | N | N | Y |
| PROC_000084 | 열재단 | N | N | Y | N |
| PROC_000081 | 부착 | N | N | N | Y |

### 판형 (전사·전 행·del 표기 — ★비종이류=판형 무의미·전 행 del_yn=Y)

<!-- transcribed-by: _meta/scripts/transcribe_product_139.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_plate_sizes @ 2026-07-03 -->
| siz_cd | output_paper_typ | output_file | dflt | del | note |
|---|---|---|---|---|---|
| SIZ_000323 | (공백) | JPG | Y | Y | 파일사양 |
| SIZ_000320 | (공백) | JPG | Y | Y | 파일사양 |
| SIZ_000322 | (공백) | (공백) | Y | Y | 파일사양 |

### 보유/미보유 축 (전사·행수 실측)

<!-- transcribed-by: _meta/scripts/transcribe_product_139.py from live-snapshot/latest (snap_20260702_1119) print_options/processes/bundle_qtys/addons/constraints/option_groups/options/option_items/sets @ 2026-07-03 -->
| 축 | 행수 |
|---|---|
| print_options(도수) | 0 |
| processes(공정) | 3 |
| bundle_qtys(묶음수) | 0 |
| addons(추가상품) | 0 |
| constraints(제약규칙) | 1 |
| option_groups(CPQ 옵션그룹) | 2 |
| options(옵션값) | 6 |
| option_items(옵션→차원 배선) | 3 |
| sets(셋트 부모) | 0 |

### 옵션그룹 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_139.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_option_groups @ 2026-07-03 -->
| opt_grp_cd | 이름 | sel_typ | min_sel | max_sel | mand | note |
|---|---|---|---|---|---|---|
| OPT_000022 | 가공 | SEL_TYPE.01 | 1 | 1 | Y | 타공 필수 (구수 param=GAP). 재단만=L1 LINK 의존 BLOCKED |
| OPT_000023 | 추가 | SEL_TYPE.01 | 0 | 1 | N | 끈추가=L1 LINK 의존 BLOCKED. 추가없음만 INSERTABLE |

### 옵션값 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_139.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_options @ 2026-07-03 -->
| opt_cd | 그룹 | 이름 | dflt |
|---|---|---|---|
| OPV_000042 | OPT_000022 | 타공(4개) | Y |
| OPV_000043 | OPT_000022 | 타공(6개) | N |
| OPV_000044 | OPT_000022 | 타공(8개) | N |
| OPV_000045 | OPT_000023 | 추가없음 | Y |
| OPV_000425 | OPT_000023 | 큐방(4개)추가 | N |
| OPV_000426 | OPT_000023 | 끈(4개)추가 | N |

### 옵션→차원 배선 (전사·option_items — ★타공만 배선·큐방/끈 미배선)

<!-- transcribed-by: _meta/scripts/transcribe_product_139.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_option_items @ 2026-07-03 -->
| opt_cd | ref_dim_cd | ref_key1 | ref_key2 | qty |
|---|---|---|---|---|
| OPV_000042 | OPT_REF_DIM.04 | PROC_000079 | (공백) | 1 |
| OPV_000043 | OPT_REF_DIM.04 | PROC_000079 | (공백) | 1 |
| OPV_000044 | OPT_REF_DIM.04 | PROC_000079 | (공백) | 1 |

### 제약규칙 (전사·logic 원문은 노드 props로 접기·D-22)

<!-- transcribed-by: _meta/scripts/transcribe_product_139.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_constraints @ 2026-07-03 -->
| rule_cd | 이름 | rule_typ | use_yn |
|---|---|---|---|
| RULE_001 | 사용자입력 치수 범위 | RULE_TYPE.01 | Y |

### 가격 배선 (전사·priced_by→공식→구성요소)

<!-- transcribed-by: _meta/scripts/transcribe_product_139.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_price_formulas+t_prc_formula_components+t_prc_price_components @ 2026-07-03 -->

공식 **PRF_POSTER_BANNER_M** — 메쉬현수막 완제품가(면적/규격 단가) (use_yn=Y)

| disp_seq | comp_cd | addtn | prc_typ | comp_nm | use_dims |
|---|---|---|---|---|---|
| 1 | COMP_POSTER_BANNER_MESH | Y | PRICE_TYPE.01 | 실사 완제품가 (메쉬현수막) | `["siz_width", "siz_height"]` |
| 2 | COMP_POSTEROPT_BANNER_MESH_ADD_QBANG_4 | Y | PRICE_TYPE.01 | 메쉬현수막 큐방(4개) 추가가격 | `["opt_cd", "opt_grp:OPT_000023"]` |
| 3 | COMP_POSTEROPT_BANNER_MESH_ADD_STRING_4 | Y | PRICE_TYPE.01 | 메쉬현수막 끈(4개) 추가가격 | `["opt_cd", "opt_grp:OPT_000023"]` |
| 4 | COMP_POSTEROPT_BANNER_MESH_PROC_PUNCH_4 | Y | PRICE_TYPE.01 | 메쉬현수막 타공(4개) 추가가격 | `["proc_cd", "min_qty", "proc_grp:PROC_000079"]` |
| 5 | COMP_POSTEROPT_BANNER_MESH_PROC_PUNCH_6 | Y | PRICE_TYPE.01 | 메쉬현수막 타공(6개) 추가가격 | `["proc_cd", "min_qty", "proc_grp:PROC_000079"]` |
| 6 | COMP_POSTEROPT_BANNER_MESH_PROC_PUNCH_8 | Y | PRICE_TYPE.01 | 메쉬현수막 타공(8개) 추가가격 | `["proc_cd", "min_qty", "proc_grp:PROC_000079"]` |

### 단가행 셀 요약 (전사·D-22 접기 — 전개 금지·집계만)

<!-- transcribed-by: _meta/scripts/transcribe_product_139.py from live-snapshot/latest (snap_20260702_1119) t_prc_component_prices (공식 배선 comp 전건 집계) @ 2026-07-03 -->
| comp_cd | use_yn | 행수 | 가로축(mm) | 세로축(mm) | 단가범위 | 판별키(proc/opt/dim_vals) |
|---|---|---|---|---|---|---|
| COMP_POSTER_BANNER_MESH | Y | 48 | 900/1000/1200 | 900/1000/1200/1400/1600/1800/2000/2200/2400/2600/2800/3000/3500/4000/4500/5000 | 20000~120000 | proc=- opt=- dim_vals=- |
| COMP_POSTEROPT_BANNER_MESH_ADD_QBANG_4 | Y | 1 | - | - | 3000~3000 | proc=- opt=OPV_000425 dim_vals=- |
| COMP_POSTEROPT_BANNER_MESH_ADD_STRING_4 | Y | 1 | - | - | 4000~4000 | proc=- opt=OPV_000426 dim_vals=- |
| COMP_POSTEROPT_BANNER_MESH_PROC_PUNCH_4 | Y | 1 | - | - | 3000~3000 | proc=PROC_000079 opt=- dim_vals={"타공수": 4} |
| COMP_POSTEROPT_BANNER_MESH_PROC_PUNCH_6 | Y | 1 | - | - | 4000~4000 | proc=PROC_000079 opt=- dim_vals={"타공수": 6} |
| COMP_POSTEROPT_BANNER_MESH_PROC_PUNCH_8 | Y | 1 | - | - | 5000~5000 | proc=PROC_000079 opt=- dim_vals={"타공수": 8} |

> **base 격자** = 가로 3구간 × 세로 16구간 = 48셀(전사표). use_dims=`[siz_width, siz_height]`(수량축
> 없음·통가격). **add-on 5**는 각 1셀(옵션/공정 판별키 룩업·큐방/끈=opt_cd·타공=proc_cd+dim_vals
> 타공수). 단가값은 스크립트 집계 범위만(D-22 접기·개별 셀 미전개·값 계산=evaluate_price).

## 카테고리·자재·공정 노드 (★재정의 안 함 — 형제 canonical 재사용)

> ★**category-CAT_000315**(배너/현수막) = [[product-136-pet-banner-nodes#category-CAT_000315]]가 canonical 소유(139 in_category 참조만). **material-MAT_000183**(메쉬) = [[product-128-mesh-print-nodes#material-MAT_000183]]·**material-MAT_000070**(설치용끈) = [[product-138-standard-hanging-banner-nodes#material-MAT_000070]]. **process-PROC_000079**(타공) = 공유 axis/processes.md·**process-PROC_000081**(부착)·**process-PROC_000084**(열재단·138이 마스터삭제 드리프트 defect 판정) = [[product-138-standard-hanging-banner-nodes]]. 139는 이들을 재정의하지 않고 main 노드가 관계로만 참조(L-3 중복 회피·병렬 빌더 실측 후 재조준).

## 사이즈 노드 (product-local — 규격 3행·현수막 치수)

<!-- ★139 사이즈=900x900/900x1200/5000x900(전부 링크·마스터 활성·전사표). SIZ_000323(900x900)은 현수막 전용이라 정본 부재→로컬 유지. SIZ_000320/322는 정본(product-135/138)과 앵커 중복이라 D-SILSA-INT-1 교정으로 로컬 은퇴·has_size를 size-SIZ_000320/322로 재지향(fix-log-silsa-260703). -->

### [size-139-SIZ_000323] 900x900 (메쉬현수막 규격 preset·격자 최소셀 일치) {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000323
- src: {source_file: "live-snapshot/latest/t_prd_product_sizes.csv", source_locator: "키:(PRD_000139,SIZ_000323) 링크 del_yn=N dflt_yn=Y", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "키:SIZ_000323(900x900·work=cut·마스터 del_yn=N·impos_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000323", note: "900×900 규격 preset. base 면적매트릭스 최소셀(900×900)과 정확히 일치(off-grid 불요·최저가 셀)"}
- 사용처:
- 본문: 900×900 정사각 현수막 규격 preset([[product-139-mesh-hanging-banner]] has_size). 격자 최소셀과 일치. 비규격 연속범위(500~900×500~3000)는 상품 nonspec축(입력 UX). 공유 axis/sizes.md 미등재·승격 대기(needed_shared).

> ★D-SILSA-INT-1 교정(fix-log-silsa-260703): 900x1200(SIZ_000320)·5000x900(SIZ_000322)은 정본
> `size-SIZ_000320`(product-135)·`size-SIZ_000322`(product-138)과 동일 마스터 앵커 중복이었다. 단일소유권
> 계약대로 로컬 preset size-139-SIZ_000320/322를 은퇴하고 [[product-139-mesh-hanging-banner]] has_size를 정본으로
> 재지향. 5000x900의 격자 가로축 밖 coverage 관찰은 has_size 엣지 note + [[gap-139-wide-size-grid-coverage]]
> (main 파일 references 엣지로 연결 유지)에 보존.

## 수량규칙 노드 (product-local·★빈값)

### [qty-139] 메쉬현수막 수량규칙 (min/max/incr 빈값) {verified}
- type: bundle_qty
- anchor: t_prd_products/PRD_000139
- src: {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "키:PRD_000139 min_qty/max_qty/qty_incr=빈값·qty_unit_typ_cd=QTY_UNIT.01·dflt_qty=빈값", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/_foundation/batch/qty_rule_audit_260702.py", source_locator: "수량 UI 권위=상품/사이즈 규칙(가격구간과 역할 분리)", captured_at: "2026-07-03", badge: verified, src_id: SR-27-qtyaudit}
- props: {min_max_incr_ref: "전사표 수량규칙(전부 빈값)", bdl_unit_typ_cd: "QTY_UNIT.01", bundle_qtys_rows: 0, note: "★min/max/incr 전부 빈값(원본 미명시·pack §3.4 GAP-SL-8·[[gap-139-qty-null]]). 면적매트릭스 base라 수량축이 가격 차원 아님(base use_dims에 min_qty 없음·통가격). t_prd_product_bundle_qtys 0행 정상"}
- 사용처:
- 본문: 수량 그릇 = 상품 마스터 컬럼(QTY_UNIT.01만 설정·min/max/incr 빈값). 원본 미명시라 GAP-SL-8([[gap-139-qty-null]]). 가격은 수량 무관 통가격(base use_dims=[siz_width,siz_height]).

## 가격공식 노드 (139 canonical·base + add-on 가산형·silsa formula 축 승격 대기)

<!-- ★면적매트릭스 base + 옵션 add-on 5(BUNDLE·138 파일럿 동형). has_component 6개(전부 addtn_yn=Y). -->

### [formula-PRF_POSTER_BANNER_M] 메쉬현수막 완제품가 (면적 base + 옵션 add-on) {verified}
- type: price_formula
- anchor: t_prc_price_formulas/PRF_POSTER_BANNER_M
- src: {source_file: "live-snapshot/latest/t_prc_price_formulas.csv", source_locator: "키:PRF_POSTER_BANNER_M(frm_nm=메쉬현수막 완제품가(면적/규격 단가)·use_yn=Y·note 포스터사인 메쉬현수막 소재/사이즈/수량별 완제품 통가격)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prc_formula_components.csv", source_locator: "frm_cd:PRF_POSTER_BANNER_M → 6구성요소(disp1 COMP_POSTER_BANNER_MESH base + disp2~6 add-on 큐방/끈/타공4/6/8·전부 addtn_yn=Y)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_price_formulas.csv", source_locator: "키:(PRD_000139,PRF_POSTER_BANNER_M) apply_bgn_ymd=2026-06-01 바인딩", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "§3.10 면적매트릭스형 13상품 B27 메쉬현수막139·[가로×세로] 셀단가 base + 옵션 가산·실사 inline price 권위 아님", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-silsa}
- rel: {rel: has_component, target: component-COMP_POSTER_BANNER_MESH, qualifier: {disp_seq: 1, addtn: "Y"}, note: "base 면적매트릭스([단독] standalone·48셀)"}
- rel: {rel: has_component, target: component-COMP_POSTEROPT_BANNER_MESH_ADD_QBANG_4, qualifier: {disp_seq: 2, addtn: "Y"}, note: "큐방(4개)추가 가산"}
- rel: {rel: has_component, target: component-COMP_POSTEROPT_BANNER_MESH_ADD_STRING_4, qualifier: {disp_seq: 3, addtn: "Y"}, note: "끈(4개)추가 가산"}
- rel: {rel: has_component, target: component-COMP_POSTEROPT_BANNER_MESH_PROC_PUNCH_4, qualifier: {disp_seq: 4, addtn: "Y"}, note: "타공(4개) 가산"}
- rel: {rel: has_component, target: component-COMP_POSTEROPT_BANNER_MESH_PROC_PUNCH_6, qualifier: {disp_seq: 5, addtn: "Y"}, note: "타공(6개) 가산"}
- rel: {rel: has_component, target: component-COMP_POSTEROPT_BANNER_MESH_PROC_PUNCH_8, qualifier: {disp_seq: 6, addtn: "Y"}, note: "타공(8개) 가산"}
- props: {frm_cd: "PRF_POSTER_BANNER_M", use_yn: "Y", archetype: "면적매트릭스 base(use_dims=[siz_width,siz_height]) + 옵션 add-on 가산(BUNDLE)", note: "139 바인딩 전용. base 셀단가 + 손님 선택 옵션(타공 필수·큐방/끈 선택)의 add-on 셀단가 합산(evaluate_price). off-grid=ceiling(앱). 값 계산=evaluate_price 권위(D-18)"}
- 사용처:
- 본문: 메쉬현수막 완제품가 공식([[product-139-mesh-hanging-banner]] priced_by). has_component 6개(base 1 + add-on 5)·고아 공식 아님(O6 충족). base는 139 전용 [단독] 구성요소([[component-COMP_POSTER_BANNER_MESH]])·128 4소재 동형결합과 다름. 공유 formula 파일 미등재·승격 대기(needed_shared). 값=evaluate_price 권위([[rule/rules#RULE_price_value_boundary]]).

## 가격구성요소 노드 (139 canonical — base [단독] + add-on 5·silsa component 축 승격 대기)

<!-- ★base COMP_POSTER_BANNER_MESH=comp note '[단독] 동형 없음'=139 전용(128 4소재 동형결합과 다름). add-on 5=옵션/공정 단가. 단가행 D-22 접기(본문 전사표 집계가 요약 권위). -->

### [component-COMP_POSTER_BANNER_MESH] 실사 완제품가 메쉬현수막 (base·면적매트릭스·[단독]) {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_POSTER_BANNER_MESH
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_POSTER_BANNER_MESH(comp_nm=실사 완제품가 (메쉬현수막)·prc_typ_cd=PRICE_TYPE.01·use_dims=[siz_width,siz_height]·use_yn=Y·note '[단독] 동형 없음·가격축: 가로×세로 구간(46셀)')", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prc_component_prices.csv", source_locator: "COMP_POSTER_BANNER_MESH 48행(가로 900/1000/1200 × 세로 900~5000·단가 20000~120000·집계 전사표)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {comp_cd: "COMP_POSTER_BANNER_MESH", prc_typ_cd: "PRICE_TYPE.01", use_dims_ref: "전사표 [siz_width, siz_height]", cells_ref: "전사표 48셀", note: "★[단독] standalone(comp note '동형 없음')=139 전용. 128 4소재 동형결합(COMP_POSTER_CANVAS_FABRIC)과 다름. base 면적매트릭스(가로3×세로16)·수량축 없음(통가격). comp note '46셀'은 마스터 기록·실 단가행 48(전사표 집계 권위·라이브 실측)"}
- 사용처:
- 본문: 메쉬현수막 base 완제품가 구성요소([[formula-PRF_POSTER_BANNER_M]] has_component). [단독] standalone이라 139가 canonical 소유. 면적매트릭스 48셀(가로×세로)·값=evaluate_price. ★셀단가 산정 로직은 실사 전체 공통 GAP([[gap-126-roll-material-pricing]]). 공유 component 파일 미등재·승격 대기(needed_shared).

### [component-COMP_POSTEROPT_BANNER_MESH_ADD_QBANG_4] 큐방(4개) 추가가격 {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_POSTEROPT_BANNER_MESH_ADD_QBANG_4
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_POSTEROPT_BANNER_MESH_ADD_QBANG_4(comp_nm=메쉬현수막 큐방(4개) 추가가격·prc_typ_cd=PRICE_TYPE.01·use_dims=[opt_cd, opt_grp:OPT_000023]·use_yn=Y)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prc_component_prices.csv", source_locator: "COMP_POSTEROPT_BANNER_MESH_ADD_QBANG_4 1행(opt_cd=OPV_000425·단가 3000·전사표)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {comp_cd: "COMP_POSTEROPT_BANNER_MESH_ADD_QBANG_4", prc_typ_cd: "PRICE_TYPE.01", use_dims_ref: "전사표 [opt_cd, opt_grp:OPT_000023]", note: "큐방 4개 추가 옵션(OPV_000425) 선택 시 가산되는 add-on 단가(1셀). base에 addtn_yn=Y로 더해짐"}
- 사용처:
- 본문: 큐방(4개)추가 옵션 가산 구성요소([[formula-PRF_POSTER_BANNER_M]] has_component). opt_cd(OPV_000425) 키 룩업 add-on. 큐방 옵션은 option_items 미배선([[gap-139-add-option-unwired]])이나 가격은 이 comp로 배선됨.

### [component-COMP_POSTEROPT_BANNER_MESH_ADD_STRING_4] 끈(4개) 추가가격 {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_POSTEROPT_BANNER_MESH_ADD_STRING_4
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_POSTEROPT_BANNER_MESH_ADD_STRING_4(comp_nm=메쉬현수막 끈(4개) 추가가격·prc_typ_cd=PRICE_TYPE.01·use_dims=[opt_cd, opt_grp:OPT_000023]·use_yn=Y)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prc_component_prices.csv", source_locator: "COMP_POSTEROPT_BANNER_MESH_ADD_STRING_4 1행(opt_cd=OPV_000426·단가 4000·전사표)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: references, target: material-MAT_000070, note: "끈추가 옵션의 실물 자재(설치용끈)·가격측 add-on"}
- props: {comp_cd: "COMP_POSTEROPT_BANNER_MESH_ADD_STRING_4", prc_typ_cd: "PRICE_TYPE.01", use_dims_ref: "전사표 [opt_cd, opt_grp:OPT_000023]", note: "끈 4개 추가 옵션(OPV_000426) 선택 시 가산되는 add-on 단가(1셀). 실물 자재=설치용끈 MAT_000070(부착 PROC_000081 BUNDLE)"}
- 사용처:
- 본문: 끈(4개)추가 옵션 가산 구성요소([[formula-PRF_POSTER_BANNER_M]] has_component). opt_cd(OPV_000426) 키 룩업 add-on. 실물 자재 [[material-MAT_000070]] 참조(끈 옵션 option_items 미배선=[[gap-139-add-option-unwired]]).

### [component-COMP_POSTEROPT_BANNER_MESH_PROC_PUNCH_4] 타공(4개) 추가가격 {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_POSTEROPT_BANNER_MESH_PROC_PUNCH_4
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_POSTEROPT_BANNER_MESH_PROC_PUNCH_4(comp_nm=메쉬현수막 타공(4개) 추가가격·prc_typ_cd=PRICE_TYPE.01·use_dims=[proc_cd, min_qty, proc_grp:PROC_000079]·use_yn=Y)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prc_component_prices.csv", source_locator: "COMP_POSTEROPT_BANNER_MESH_PROC_PUNCH_4 1행(proc_cd=PROC_000079·dim_vals 타공수=4·단가 3000·전사표)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: references, target: process-PROC_000079, note: "타공 4개 공정(가공 옵션그룹)·가격측 add-on"}
- props: {comp_cd: "COMP_POSTEROPT_BANNER_MESH_PROC_PUNCH_4", prc_typ_cd: "PRICE_TYPE.01", use_dims_ref: "전사표 [proc_cd, min_qty, proc_grp:PROC_000079]", dim_vals_ref: "전사표 타공수=4", note: "타공 4개(OPV_000042·dflt) 선택 시 가산되는 add-on 단가(1셀). 공정 PROC_000079·구수 4를 dim_vals로 표현"}
- 사용처:
- 본문: 타공(4개) 옵션 가산 구성요소([[formula-PRF_POSTER_BANNER_M]] has_component). 공정 [[axis/processes#process-PROC_000079]] 참조·구수 4 dim_vals. 가공 옵션그룹(타공 필수)의 기본값 짝.

### [component-COMP_POSTEROPT_BANNER_MESH_PROC_PUNCH_6] 타공(6개) 추가가격 {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_POSTEROPT_BANNER_MESH_PROC_PUNCH_6
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_POSTEROPT_BANNER_MESH_PROC_PUNCH_6(comp_nm=메쉬현수막 타공(6개) 추가가격·prc_typ_cd=PRICE_TYPE.01·use_dims=[proc_cd, min_qty, proc_grp:PROC_000079]·use_yn=Y)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prc_component_prices.csv", source_locator: "COMP_POSTEROPT_BANNER_MESH_PROC_PUNCH_6 1행(proc_cd=PROC_000079·dim_vals 타공수=6·단가 4000·전사표)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: references, target: process-PROC_000079, note: "타공 6개 공정·가격측 add-on"}
- props: {comp_cd: "COMP_POSTEROPT_BANNER_MESH_PROC_PUNCH_6", prc_typ_cd: "PRICE_TYPE.01", use_dims_ref: "전사표 [proc_cd, min_qty, proc_grp:PROC_000079]", dim_vals_ref: "전사표 타공수=6", note: "타공 6개(OPV_000043) 선택 시 add-on 단가(1셀)"}
- 사용처:
- 본문: 타공(6개) 옵션 가산 구성요소([[formula-PRF_POSTER_BANNER_M]] has_component). 공정 PROC_000079·구수 6.

### [component-COMP_POSTEROPT_BANNER_MESH_PROC_PUNCH_8] 타공(8개) 추가가격 {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_POSTEROPT_BANNER_MESH_PROC_PUNCH_8
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_POSTEROPT_BANNER_MESH_PROC_PUNCH_8(comp_nm=메쉬현수막 타공(8개) 추가가격·prc_typ_cd=PRICE_TYPE.01·use_dims=[proc_cd, min_qty, proc_grp:PROC_000079]·use_yn=Y)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prc_component_prices.csv", source_locator: "COMP_POSTEROPT_BANNER_MESH_PROC_PUNCH_8 1행(proc_cd=PROC_000079·dim_vals 타공수=8·단가 5000·전사표)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: references, target: process-PROC_000079, note: "타공 8개 공정·가격측 add-on"}
- props: {comp_cd: "COMP_POSTEROPT_BANNER_MESH_PROC_PUNCH_8", prc_typ_cd: "PRICE_TYPE.01", use_dims_ref: "전사표 [proc_cd, min_qty, proc_grp:PROC_000079]", dim_vals_ref: "전사표 타공수=8", note: "타공 8개(OPV_000044) 선택 시 add-on 단가(1셀)·구수 최대(PROC_000079 param max8과 정합)"}
- 사용처:
- 본문: 타공(8개) 옵션 가산 구성요소([[formula-PRF_POSTER_BANNER_M]] has_component). 공정 PROC_000079·구수 8(param max8 상한).

## 옵션그룹 노드 (CPQ)

<!-- ★가공(타공 필수·option_items 3행 배선)과 추가(큐방/끈·option_items 미배선=gap). -->

### [optgroup-139-gagong] 가공 (타공 4/6/8개·필수 택1) {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000139
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "키:PRD_000139 opt_grp_cd:OPT_000022(가공·SEL_TYPE.01·min_sel=1·max_sel=1·mand_yn=Y·use_yn=Y·del_yn=N·note '타공 필수 (구수 param=GAP). 재단만=L1 LINK 의존 BLOCKED')", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_options.csv", source_locator: "키:PRD_000139 OPT_000022 (OPV_000042 타공4개·dflt / OPV_000043 타공6개 / OPV_000044 타공8개)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_option_items.csv", source_locator: "키:PRD_000139 (OPV_000042/043/044 각 → PROC_000079·전부 OPT_REF_DIM.04=공정·3행)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: option_refs, target: process-PROC_000079, ref_key1: PROC_000079, note: "타공4/6/8(OPV_000042/043/044)→공정(구수는 옵션값·가격 add-on으로 표현)"}
- props: {opt_grp_cd: "OPT_000022", sel_typ_cd: "SEL_TYPE.01", mand_yn: "Y", 옵션값: "타공4개(dflt)/타공6개/타공8개(택1·필수)", ref_dim: "OPT_REF_DIM.04=공정(PROC_000079)", note: "★필수 옵션(mand_yn=Y·min1/max1). 3 옵션값 모두 PROC_000079를 가리키되 구수(4/6/8)는 opt_items에 저장 안 되고 각 옵션값별 가격 add-on(PROC_PUNCH_4/6/8)으로 표현(discrete-option 방식·og note '구수 param=GAP'·pack §3.6 GAP-SL-2)"}
- 사용처:
- 본문: 손님이 타공 구수를 고르는 필수 CPQ 옵션(택1)([[product-139-mesh-hanging-banner]] has_option_group). 3 옵션값 item이 공정 PROC_000079를 가리켜(R11 option_refs·OPT_REF_DIM.04) has_process 차원으로 환원(L-18 통과·부모 139 has_process 실재). 구수(4/6/8)는 가격 add-on 3구성요소로 표현.

### [optgroup-139-add] 추가 (추가없음/큐방/끈·선택 택0~1) {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000139
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "키:PRD_000139 opt_grp_cd:OPT_000023(추가·SEL_TYPE.01·min_sel=0·max_sel=1·mand_yn=N·use_yn=Y·del_yn=N·note '끈추가=L1 LINK 의존 BLOCKED. 추가없음만 INSERTABLE')", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_options.csv", source_locator: "키:PRD_000139 OPT_000023 (OPV_000045 추가없음·dflt / OPV_000425 큐방4개추가 / OPV_000426 끈4개추가)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_option_items.csv", source_locator: "키:PRD_000139 OPT_000023 옵션값 option_items=0행(★큐방/끈 미배선·추가없음도 참조 없음)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {opt_grp_cd: "OPT_000023", sel_typ_cd: "SEL_TYPE.01", mand_yn: "N", 옵션값: "추가없음(dflt)/큐방4개추가/끈4개추가(택0~1)", ref_dim: "없음(★option_items 미배선)", note: "★선택 옵션(mand_yn=N·min0/max1). 큐방/끈 옵션값이 option_items에 미배선(L1 LINK BLOCKED·og note)이라 선택→실물 차원(끈=MAT_000070·부착=PROC_000081) 환원이 끊김. 가격만 add-on(opt_cd)으로 배선. 배선 결함=[[gap-139-add-option-unwired]]"}
- 사용처:
- 본문: 손님이 부속(큐방/끈)을 고르는 선택 CPQ 옵션(택0~1)([[product-139-mesh-hanging-banner]] has_option_group). ★큐방/끈 옵션값은 option_items 미배선이라 option_refs 엣지를 걸 수 없다(선택이 uses_material·has_process로 환원 안 됨)·가격만 add-on 구성요소로 배선됨(L1 LINK BLOCKED·[[gap-139-add-option-unwired]]). "추가없음"만 안전 삽입.

## 제약규칙 노드 (§31 — 사용자입력 치수 범위)

### [constraint-139-nonspec-range] 사용자입력 치수 범위 {verified}
- type: constraint
- anchor: t_prd_product_constraints/PRD_000139
- src: {source_file: "live-snapshot/latest/t_prd_product_constraints.csv", source_locator: "키:PRD_000139 rule_cd:RULE_001(rule_nm=사용자입력 치수 범위·rule_typ=RULE_TYPE.01·use_yn=Y·del_yn=N·logic=size_mode!=nonspec OR (width 500~900 AND height 500~3000))", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-constraint-rules/03_rules", source_locator: "CN-5 범위형(size_mode=nonspec일 때 width/height 범위 검증)·폼빌더 정형 shape(§31)", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-silsa}
- rel: {rel: constrains, target: product-139-mesh-hanging-banner, note: "비규격 입력 치수 범위 검증"}
- props: {rule_cd: "RULE_001", 유형: "CN-5 범위형(range)", 검증: "size_mode=nonspec이면 가로 500~900·세로 500~3000 안인지(전사표 nonspec 범위와 일치)", 상태: "라이브 실등록(데모 아님)·정당·logic 원문은 D-22 접기(shape만 표기)"}
- 사용처:
- 본문: 비규격 입력 시 가로/세로가 제품 nonspec 범위(전사표 500~900 × 500~3000) 안인지 검증하는 범위 제약(CN-5·§31·폼빌더 정형 shape·raw JSONLogic escape hatch 금지·[[rule/rules]] §31). ★[REVERIFY] 위키 "실사 constraints 전부 0행"은 STALE(139 포함 7상품 신규 발현·pack §1.1·§4·T-3). evaluate_price는 제약 미참조 — validate는 위젯/주문이 호출(constraint-builder 계약).

## GAP 노드 (원천 부재·정직 선언)

### [gap-139-add-option-unwired] 큐방/끈 추가 옵션 option_items 미배선 (차원 환원 부재) {unknown}
- type: gap
- anchor: none  # 사유: 큐방/끈 옵션값(OPV_000425/426)의 option_items가 0행이라 선택→실물 차원(끈 자재·부착 공정) 환원 배선이 부재. 가격은 opt_cd로 배선되나 CPQ 무결성(fn_chk_opt_item_ref) 관점 미완
- src: {source_file: "live-snapshot/latest/t_prd_product_option_items.csv", source_locator: "키:PRD_000139 OPT_000023 옵션값 option_items=0행(큐방/끈 미배선·타공 OPT_000022만 3행 배선)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "키:PRD_000139 OPT_000023 note '끈추가=L1 LINK 의존 BLOCKED. 추가없음만 INSERTABLE'(라이브 note가 배선 미완 자인)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "§3.9 GAP-SL-6/7 CPQ 옵션 레이어 적재·비표준 var·§3.12 GAP-SL-5 끈/각목 BUNDLE 자재 mint", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-silsa}
- gap_what: "추가 옵션그룹(OPT_000023)의 큐방(OPV_000425)·끈(OPV_000426) 옵션값이 option_items에 미배선(0행) — 선택이 실물 차원(끈 자재 MAT_000070·부착 공정 PROC_000081)으로 환원되지 않는다. 가격은 add-on 구성요소(opt_cd)로 배선돼 견적은 되나, CPQ 무결성(fn_chk_opt_item_ref)·차원 환원 관점에서 배선 미완(og note 'L1 LINK 의존 BLOCKED')"
- gap_fill_from: "실무진/dev — 큐방/끈 option_items를 OPT_REF_DIM.03(자재 MAT_000070)+OPT_REF_DIM.04(공정 PROC_000081)로 배선(silsa-option-layer-v2 D-1 BUNDLE·pack §3.9 GAP-SL-6). 인간 승인 후 §7 dbmap 적재"
- gap_owner: staff
- rel: {rel: references, target: optgroup-139-add, note: "미배선 옵션그룹"}
- 사용처:
- 본문: 큐방/끈 추가 옵션은 가격(add-on)만 배선되고 실물 차원(끈 자재·부착 공정) option_items가 없어 CPQ 선택→차원 환원이 끊긴다(라이브 note가 'L1 LINK BLOCKED'로 자인). 견적 자체는 opt_cd 가격 룩업으로 되지만, 옵션이 실물 자재/공정을 정확히 가리키는 배선은 미완(실무진 배선 대기). 타공 옵션(OPT_000022)은 3행 정상 배선과 대조.

### [gap-139-qty-null] 수량 min/max/incr 빈값 (GAP-SL-8) {unknown}
- type: gap
- anchor: none  # 사유: 상품 수량 min/max/incr가 라이브 빈값이고 원본(L1) 미명시라 정답값(유지 vs 동류 보완)이 원천 부재
- src: {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "키:PRD_000139 min_qty/max_qty/qty_incr/dflt_qty=빈값(QTY_UNIT.01만 설정)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "§3.4 GAP-SL-8 메쉬현수막/홀로그램/유광아크릴 수량 L1 빈값(유지 vs 동류값 보완·Q-SL-5·6)", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-silsa}
- gap_what: "메쉬현수막 수량규칙(min/max/incr)이 라이브 빈값. L1 추출 캐시에도 미명시라 '정당한 빈값 유지'인지 '동류 실사값으로 보완'해야 하는지 미확정. 면적매트릭스 base라 가격 차원은 아니나 수량 UI(주문 최소/최대) 표현에 영향"
- gap_fill_from: "실무진 확인(pack §3.4 GAP-SL-8·Q-SL-5/6·홀로그램/유광아크릴과 함께 결정). 수량 UI 권위=상품/사이즈 규칙(가격구간과 역할 분리)"
- gap_owner: staff
- 사용처:
- 본문: 수량 min/max/incr가 빈값(원본 미명시)이라 수량 UI 기본값이 미확정. 면적매트릭스 통가격이라 가격 사슬엔 무영향([[formula-PRF_POSTER_BANNER_M]] base use_dims에 min_qty 없음)이나, 주문 최소/최대 수량 표현은 실무진 확인 대기(GAP-SL-8).

### [gap-139-wide-size-grid-coverage] 초대형 규격(5000x900) vs 격자 가로축 coverage {unknown}
- type: gap
- anchor: none  # 사유: 규격 SIZ_000322(5000x900)의 가로 5000mm가 base 격자 가로축(max1200) 밖·방향 해석(회전)은 앱 로직이라 어느 셀로 수렴하는지 KB에서 못 박을 원천 부재
- src: {source_file: "_workspace/huni-ontology-kb/_meta/scripts/transcribe_product_139.py", source_locator: "base 격자 가로축=900/1000/1200(max1200)·규격 SIZ_000322=5000x900(가로 5000)·세로축 max5000(전사표)", captured_at: "2026-07-03", badge: unknown, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "§3.10 off-grid=가로·세로 각 한 단계 큰 규격 ceiling(앱 계산·DB는 룩업행)·롤 소재 가격 로직 GAP", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-silsa}
- gap_what: "규격 preset SIZ_000322(5000×900)의 가로 5000mm가 base 격자 가로축(900/1000/1200·max1200) 밖. 세로축엔 5000이 있어 방향(가로↔세로) 회전 해석 시 매칭 가능하나, 그 회전 규칙은 앱 evaluate_price 런타임 로직(KB 경계 밖)이라 이 preset이 어느 셀로 수렴하는지·정상 견적되는지 미확정. off-grid ceiling(한 단계 큰 규격) 규칙만으로는 가로 5000 커버 불가"
- gap_fill_from: "실무진/설계 + 예전사이트 골든(5000×900 현수막 실제가) 대조 — evaluate_price가 방향 회전으로 세로 5000셀에 매칭하는지, 아니면 별도 처리인지 확인. 값 계산은 evaluate_price 권위(D-18 경계)"
- gap_owner: staff
- rel: {rel: references, target: size-SIZ_000322, note: "격자 밖 초대형 규격(정본 재지향·D-SILSA-INT-1)"}
- 사용처:
- 본문: 5000×900 초대형 가로 현수막 규격이 base 면적매트릭스 가로축 범위(max1200)를 벗어난다. 세로축(max5000)에 5000이 있어 방향 회전으로 매칭될 여지는 있으나 그 규칙은 앱 로직(KB 경계 밖). 가격 사슬 자체는 연결됨([[formula-PRF_POSTER_BANNER_M]])이나 이 특정 preset의 셀 수렴·정상 견적 여부는 미확정(골든 대조 필요·값 계산=evaluate_price 권위).
