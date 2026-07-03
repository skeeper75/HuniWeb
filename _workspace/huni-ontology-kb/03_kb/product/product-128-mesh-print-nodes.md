<!-- product-local sub-nodes: E3 size·E4 material·E8 bundle_qty·E9 price_formula·gap for PRD_000128 메쉬프린트(실사 면적매트릭스·126 레더 동형). -->
<!-- ★공유 노드 재사용(중복 mint 방지·L-3): -->
<!--   - category-CAT_000076(아트프린트) = 126-nodes(레더)가 canonical 정의 → 여기서 재정의 안 함. 128 main이 in_category로 참조만. needed_shared. -->
<!--   - component-COMP_POSTER_CANVAS_FABRIC([동형결합] 4소재 캔버스/레더/메쉬/타이벡) = 125-canvas-nodes가 canonical 소유 → 여기서 재정의 안 함. 128 formula가 has_component로 참조만. needed_shared. -->
<!--   - gap-126-roll-material-pricing·gap-126-minqty-axis(공유 comp COMP_POSTER_CANVAS_FABRIC 귀속 실사 전체 GAP) = 126-nodes 정의 → 여기서 재생성 안 함(중복 방지). 본문 [[ ]] 참조만. -->
<!-- ★여기 정의(128 고유·타 빌더 미정의): size 3(구코드 174/197/293 활성)·material(메쉬 183·.08 미교정)·formula(PRF_POSTER_MESH)·qty·gap(메쉬 자재유형 정정 목표 미확정). -->
<!-- ★수치(치수·매트릭스 shape)는 아래 전사표(transcribed-by·transcribe_product_128.py)에만. props raw 미기입(D-9·L-12). -->
<!-- ★가격 값(unit_price)은 노드에 전사하지 않음 — 연결·차원·격자까지만(D-18·값=evaluate_price). 전사표 단가범위는 스크립트 집계(손전사 아님). -->

# product-128 하위 노드 (메쉬프린트 전용 축 원자 + 공식/GAP)

메쉬프린트(PRD_000128)가 쓰는 규격 사이즈 3행·메쉬 자재 1·가격공식·수량규칙·GAP 1. 카테고리
(CAT_000076)·면적 구성요소(COMP_POSTER_CANVAS_FABRIC)·롤소재/min_qty GAP은 형제 빌더(125/126)가
canonical 소유 — 여기서 재정의 없이 참조만. 상품→축 연결(has_size·uses_material·priced_by·
has_qty_rule)은 [[product-128-mesh-print]]가 건다. 공정·CPQ·제약·추가상품은 전부 0행(전사표).

## 치수·자재·판형·미보유축·가격배선·면적매트릭스 전사표 (권위 = 라이브 마스터)

### 상품 정체·수량·비규격 범위 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_128.py from live-snapshot/latest (snap_20260702_1119) t_prd_products PRD_000128 @ 2026-07-03 -->
| prd_typ_cd | nonspec | min_qty | max_qty | qty_incr | qty_unit | file_upload | editor | use_yn |
|---|---|---|---|---|---|---|---|---|
| PRD_TYPE.01 | Y | 1 | 10000 | 1 | QTY_UNIT.01 | Y | N | Y |

| 비규격축 | width_min | width_max | width_incr | height_min | height_max | height_incr |
|---|---|---|---|---|---|---|
| nonspec | 200 | 600 | 200 | 200 | 3000 | 200 |

### 카테고리 (전사·재사용 — 노드 정의는 126-nodes)

<!-- transcribed-by: _meta/scripts/transcribe_product_128.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_categories+t_cat_categories @ 2026-07-03 -->
| cat_cd | 이름 | 부모 | lvl | main_cat_yn |
|---|---|---|---|---|
| CAT_000076 | 아트프린트 | CAT_000004 | 2 | N |

### 사이즈 (전사·전 행·del 표기)

<!-- transcribed-by: _meta/scripts/transcribe_product_128.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_sizes+t_siz_sizes @ 2026-07-03 -->
| siz_cd | 라벨 | 작업(mm) | dflt | 링크 del | 마스터 del |
|---|---|---|---|---|---|
| SIZ_000174 | A3(297x420mm) | 297x420 | Y | N | N |
| SIZ_000197 | A2(420x594mm) | 420x594 | Y | N | N |
| SIZ_000293 | A1(594x841mm) | 594x841 | Y | N | Y |

### 자재 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_128.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_materials+t_mat_materials @ 2026-07-03 -->
| mat_cd | 이름 | mat_typ | usage_cd | dflt |
|---|---|---|---|---|
| MAT_000183 | 메쉬 | MAT_TYPE.08 | USAGE.07 | Y |

### 판형 (전사·전 행·del 표기 — ★비종이류=판형 무의미·전 행 del_yn=Y)

<!-- transcribed-by: _meta/scripts/transcribe_product_128.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_plate_sizes @ 2026-07-03 -->
| siz_cd | output_paper_typ | output_file | dflt | del | note |
|---|---|---|---|---|---|
| SIZ_000052 | (공백) | JPG | Y | Y | 파일사양 |
| SIZ_000198 | (공백) | JPG | Y | Y | 파일사양 |
| SIZ_000294 | (공백) | JPG | Y | Y | 파일사양 |

### 미보유 축 (전사·0행 실측)

<!-- transcribed-by: _meta/scripts/transcribe_product_128.py from live-snapshot/latest (snap_20260702_1119) print_options/processes/bundle_qtys/addons/constraints/option_groups/sets @ 2026-07-03 -->
| 축 | 행수 |
|---|---|
| print_options(도수) | 0 |
| processes(공정) | 0 |
| bundle_qtys(묶음수) | 0 |
| addons(추가상품) | 0 |
| constraints(제약규칙) | 0 |
| option_groups(CPQ 옵션) | 0 |
| sets(셋트 부모) | 0 |

### 가격 배선 (전사·priced_by→공식→구성요소)

<!-- transcribed-by: _meta/scripts/transcribe_product_128.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_price_formulas+t_prc_formula_components+t_prc_price_components @ 2026-07-03 -->

공식 **PRF_POSTER_MESH** — 메쉬프린트 완제품가(면적/규격 단가) (use_yn=Y)

| disp_seq | comp_cd | addtn | prc_typ | comp_nm | use_dims |
|---|---|---|---|---|---|
| 1 | COMP_POSTER_CANVAS_FABRIC | Y | PRICE_TYPE.01 | 실사 완제품가 (캔버스패브릭포스터·레더아트프린트·메쉬프린트·타이벡프린트) | `["siz_width", "siz_height", "min_qty"]` |

### 면적매트릭스 셀 요약 (전사·D-22 접기 — 전개 금지·집계만)

<!-- transcribed-by: _meta/scripts/transcribe_product_128.py from live-snapshot/latest (snap_20260702_1119) t_prc_component_prices (COMP_POSTER_CANVAS_FABRIC/MESH_PRINT[레거시] 집계) @ 2026-07-03 -->
| comp_cd | use_yn | 행수 | 가로축(mm) | 세로축(mm) | 단가범위 | comp_nm |
|---|---|---|---|---|---|---|
| COMP_POSTER_CANVAS_FABRIC | Y | 52 | 600/800/1000/1200 | 600/800/1000/1200/1400/1600/1800/2000/2200/2400/2600/2800/3000 | 19000~126000 | 실사 완제품가 (캔버스패브릭포스터·레더아트프린트·메쉬프린트·타이벡프린트) |
| COMP_POSTER_MESH_PRINT | N | 52 | 600/800/1000/1200 | 600/800/1000/1200/1400/1600/1800/2000/2200/2400/2600/2800/3000 | 19000~126000 | 메쉬프린트 완제품가[레거시] |

> **격자** = 가로 4구간 × 세로 13구간 = 52셀. 라이브 배선 comp=`COMP_POSTER_CANVAS_FABRIC`(use_yn=Y·
> 4소재 동형결합)이고, `COMP_POSTER_MESH_PRINT`(use_yn=N)는 은퇴한 128 전용 레거시(52셀 동일 격자·
> 배선 안 함). mapping.md §1.2가 지목한 comp는 이 레거시라 라이브 배선으로 재판정(본문 가격 경로).
> ★메쉬 nonspec 가로 캡=600이라 실주문은 격자 600 가로열만 도달(800~1200 열은 넓은 nonspec 소재 몫).
> 단가값은 스크립트 집계 범위만(D-22 접기·개별 셀 미전개·값 계산=evaluate_price).

## 사이즈 노드 (정본 재사용 — 로컬 preset 은퇴)

> ★D-SILSA-INT-1 교정(fix-log-silsa-260703): 구 로컬 preset size-128-SIZ_000174/197/293은 정본
> `size-SIZ_000174`/`size-SIZ_000197`/`size-SIZ_000293`와 동일 마스터 앵커를 중복소유했다. 단일소유권 계약에
> 맞춰 로컬 은퇴, [[product-128-mesh-print]] has_size를 정본으로 재지향(off-grid ceiling 최소셀 수렴·마스터삭제
> 정직관찰은 has_size 엣지 note와 main 본문 전사표에 보존). 126/127 형제 동형.

## 자재 노드 (메쉬·★MAT_TYPE.08 미교정)

<!-- ★128 자재=메쉬 MAT_000183·mat_typ_cd=MAT_TYPE.08(미교정). 형제 126 레더(MAT_000186·.05 교정됨)와 달리 아직 .08. -->
<!-- DB note "정정 …→원단(.05)"는 STALE(MAT_TYPE 코드 개편·.05=특수소재/.06=도장부자재). 정정 목표유형 미확정=GAP(양면 아님). -->

### [material-MAT_000183] 메쉬 (실사 소재·MAT_TYPE.08 미교정) {verified}
- type: material
- anchor: t_mat_materials/MAT_000183
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "키:MAT_000183(mat_nm=메쉬·mat_typ_cd=MAT_TYPE.08·upr_mat_cd 공백·use_yn=Y·del_yn=N·note '정정 2026-06-14: 실사소재(.08)→원단(.05) product-bom §146')", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_materials.csv", source_locator: "키:(PRD_000128,MAT_000183) usage_cd=USAGE.07 dflt_yn=Y del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "§1.1·§3.5 메쉬183=아직 .08(SL-DEF-002 부분해소 잔존 3소재)·round-13 목표 라벨 원단(구 .05)은 코드개편 STALE(T-2)·정정 목표유형 확정=GAP", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-silsa}
- props: {mat_cd: "MAT_000183", mat_nm: "메쉬", mat_typ_cd: "MAT_TYPE.08", usage_cd: "USAGE.07", note: "★자재유형 현재값 MAT_TYPE.08(실사소재·미교정). 형제 레더 MAT_000186은 .05로 교정됐으나(06-27) 메쉬는 잔존(pack §1.1·§3.5 그래픽천/현수막천/메쉬 3소재 미교정). DB note의 '→원단(.05)' 목표 라벨은 MAT_TYPE 코드 개편(현재 .05=특수소재·.06=도장부자재)으로 STALE(pack T-2). 정정 목표유형이 어느 코드인지 미확정=[[gap-128-mesh-mattype-correction]]. 현재값 .08은 live 실측 사실이나 정답 유형은 원천 부재(양면 아님·GAP). 낱장 완제품 단일 슬롯(USAGE.07·내지/표지 없음). IMPORT 자재 삭제 금지([[rule/rules#RULE_import_material_no_delete]])"}
- 본문: 메쉬 소재(그물망 실사 대형 출력)·MAT_TYPE.08 미교정 상태([[product-128-mesh-print]] uses_material). 형제 126 레더는 .05 교정 완료이나 메쉬는 잔존 — "현재값 확정·정답 유형 미확정"이라 양면(defect)이 아니라 GAP으로 정직 선언([[gap-128-mesh-mattype-correction]]). 공유 axis/materials.md 미등재·승격 대기(needed_shared).

## 수량규칙 노드 (product-local)

### [qty-128] 메쉬프린트 수량규칙 {verified}
- type: bundle_qty
- anchor: t_prd_products/PRD_000128
- src: {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "키:PRD_000128 min_qty/max_qty/qty_incr(1/10000/1)·qty_unit_typ_cd=QTY_UNIT.01", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/_foundation/batch/qty_rule_audit_260702.py", source_locator: "수량 UI 권위=상품/사이즈 규칙(가격구간과 역할 분리)", captured_at: "2026-07-03", badge: verified, src_id: SR-27-qtyaudit}
- props: {min_max_incr_ref: "전사표 수량규칙(상품 1/10000/1)", bdl_unit_typ_cd: "QTY_UNIT.01", bundle_qtys_rows: 0, note: "★면적매트릭스형이라 수량축이 가격 차원 아님(셀단가=통가격). t_prd_product_bundle_qtys 0행 정상(수량 UI 권위=상품 레벨·[[rule/decisions#DEC_qty_audit_260702]])"}
- 본문: 수량 그릇 = 상품 마스터 컬럼(min 1·max 10000·incr 1). t_prd_product_bundle_qtys 0행 정상(수량 UI 권위=상품 레벨). 가격은 수량 무관 통가격.

## 가격공식 노드 (실사 면적매트릭스형·128 바인딩 전용)

<!-- ★면적매트릭스형(원자합산·고정룩업과 다른 아키타입). 단일 [동형결합] 구성요소를 (가로×세로) 셀에서 조회. -->
<!-- has_component 타깃 component-COMP_POSTER_CANVAS_FABRIC = 125-canvas-nodes 정의(4소재 공유)·여기서 재정의 안 함(재사용). -->

### [formula-PRF_POSTER_MESH] 메쉬프린트 완제품가 (면적/규격 단가) {verified}
- type: price_formula
- anchor: t_prc_price_formulas/PRF_POSTER_MESH
- src: {source_file: "live-snapshot/latest/t_prc_price_formulas.csv", source_locator: "키:PRF_POSTER_MESH(frm_nm=메쉬프린트 완제품가(면적/규격 단가)·use_yn=Y·note 포스터사인 메쉬프린트 소재/사이즈/수량별 완제품 통가격)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prc_formula_components.csv", source_locator: "frm_cd:PRF_POSTER_MESH → comp COMP_POSTER_CANVAS_FABRIC(disp_seq=1·addtn_yn=Y) 1행 (★128 전용 레거시 COMP_POSTER_MESH_PRINT(use_yn=N)은 미배선)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_price_formulas.csv", source_locator: "키:(PRD_000128,PRF_POSTER_MESH) apply_bgn_ymd=2026-06-01 바인딩", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "§3.10 면적매트릭스형 13상품 B11 메쉬128·[가로×세로] 셀단가·off-grid ceiling·실사 inline price 권위 아님", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-silsa}
- rel: {rel: has_component, target: component-COMP_POSTER_CANVAS_FABRIC, qualifier: {disp_seq: 1, addtn: "Y"}, note: "★[동형결합] 4소재 통합 구성요소(구 per-mesh COMP_POSTER_MESH_PRINT는 use_yn=N 은퇴)"}
- props: {frm_cd: "PRF_POSTER_MESH", use_yn: "Y", archetype: "면적매트릭스형(포스터사인 [가로×세로] 셀단가·통가격)", note: "128 바인딩 전용 공식. 단일 [동형결합] 구성요소를 가로×세로 셀에서 조회(evaluate_price). off-grid=ceiling(앱). 값 계산=evaluate_price 권위(D-18)"}
- 본문: 메쉬프린트 면적매트릭스 완제품가 공식([[product-128-mesh-print]] priced_by). has_component→[[product-125-canvas-fabric-poster-nodes#component-COMP_POSTER_CANVAS_FABRIC]](캔버스=namesake canonical·레더126/타이벡127/메쉬128 공유). 고아 공식 아님(O6 충족). ★mapping.md §1.2가 지목한 COMP_POSTER_MESH_PRINT는 use_yn=N 은퇴 레거시라 라이브 배선(CANVAS_FABRIC)으로 재판정(126 동형). 공유 formula 파일 미등재·승격 대기(needed_shared). 값=evaluate_price 권위([[rule/rules#RULE_price_value_boundary]]).

## 가격구성요소 노드 (★재사용 — 재정의 금지)

> ★[동형결합] 4소재 통합 구성요소 **component-COMP_POSTER_CANVAS_FABRIC**(캔버스패브릭·레더·**메쉬**·타이벡)는
> 이미 [[product-125-canvas-fabric-poster-nodes#component-COMP_POSTER_CANVAS_FABRIC]](캔버스=namesake·125가
> canonical 소유)가 정의 — **재정의 금지**(L-3 중복 id 회피·126 선례). [[formula-PRF_POSTER_MESH]]
> has_component→component-COMP_POSTER_CANVAS_FABRIC로 재사용. 구 per-mesh **COMP_POSTER_MESH_PRINT[레거시]**
> (use_yn=N·52행 동일 격자·mapping.md §1.2가 지목한 구 comp)는 은퇴(배선 안 함·노드 미생성). 단가행은
> D-22 접기(노드 미전개·본문 전사표 면적매트릭스 셀 집계가 요약 권위·라이브 52셀=권위 포스터사인 격자
> 19000~126000). ★롤 소재 셀단가 산정 로직·min_qty 차원 이슈는 공유 comp 귀속 GAP
> [[gap-126-roll-material-pricing]]·[[gap-126-minqty-axis]]로 이미 등재(126 소유·128 재생성 안 함).

## GAP 노드 (원천 부재·미확정 — 정직 선언)

### [gap-128-mesh-mattype-correction] 메쉬 자재유형 정정 목표유형 미확정 (SL-DEF-002 잔존) {unknown}
- type: gap
- anchor: none  # 사유: 메쉬 MAT_000183이 아직 MAT_TYPE.08이고 정정 목표유형(어느 코드로 옮길지)이 MAT_TYPE 코드 개편으로 미확정·정답 원천 부재
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "§3.5 GAP '그래픽천/현수막천/메쉬 잔여 .08 정정 목표유형 확정(개편된 코드 도메인 기준)'·§1.1 SL-DEF-002 부분해소 잔존 3소재·T-2 목표 라벨 STALE", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-silsa}
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "키:MAT_000183 mat_typ_cd=MAT_TYPE.08·note '→원단(.05)' — 현재값 .08 확정이나 note 목표 라벨은 MAT_TYPE 개편(.05=특수소재)으로 무효", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- gap_what: "메쉬 MAT_000183 자재유형이 라이브 현재 MAT_TYPE.08(실사소재)로 잔존. 형제 레더(.05 교정됨)와 달리 미교정. DB note가 지목한 원단(구 .05) 목표는 MAT_TYPE 코드 개편(현재 .05=특수소재·.06=도장부자재)으로 라벨 무효 — 정정할 목표유형이 어느 코드인지 확정 원천 부재(양면 defect 아님=authority_value 미상)"
- gap_fill_from: "실무진 확인(개편된 MAT_TYPE 코드 도메인 기준 메쉬/그래픽천/현수막천 목표유형 확정·pack §3.5). 그 전까지 목표유형 단정 금지·현재값 .08은 live 사실로 사용 가능"
- gap_owner: staff
- rel: {rel: references, target: material-MAT_000183, note: "정정 목표유형 미확정 대상 자재"}
- 본문: 메쉬 자재유형 .08은 v03 마이그레이션 평면화 잔재(pack T-9)로 교정 대기이나, 정정 목표유형이 코드 개편으로 미확정이라 양면(현재값 vs 정답)으로 못 박지 않고 GAP으로 정직 선언(authority_value 원천 부재). 현재값 .08은 그대로 사용 가능하되 "정답 유형"은 실무진 확인 대기. 가격 사슬과 무관(자재유형은 가격 차원 아님·면적매트릭스 통가격).
