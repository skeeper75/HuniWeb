<!-- product-local sub-nodes: E2 category(CAT_000080 첫 정의)·E4 material 4·E8 bundle_qty·E9 price_formula·E10 price_component·gap for PRD_000130 포맥스보드. -->
<!-- ★공유 노드 재사용(중복 mint 방지·L-3·재정의 안 함·참조만): -->
<!--   - category-CAT_000004(포스터·root) = product-119-artpaper-poster-nodes가 canonical 정의 → 130 main이 in_category로 참조만. -->
<!--   - size-SIZ_000174(A3 297x420) = product-047-small-flyer가 정의 → 재사용(참조만). 130 A3 규격 동일 siz_cd. -->
<!--   - size-SIZ_000197(A2 420x594) = axis/sizes.md가 정의 → 재사용(참조만). -->
<!--   - process-PROC_000014(유광라미)·process-PROC_000015(무광라미) = axis/processes.md가 정의 → 재사용(참조만·118은 코팅 115/116으로 재키잉됐으나 130은 구 라미 코드 유지). -->
<!--   - category-CAT_000080(보드액자) = 병렬 보드/액자 빌더(131 프레임리스우드액자·132 레더아트액자)가 정의 → 130도 재사용(참조만·재정의 안 함·L-3 회피). needed_shared 반환(consolidation이 canonical 선정). -->
<!-- ★여기 정의(130 고유·타 빌더 미정의): material 4(포맥스 보드)·qty·formula(PRF_POSTER_FOMEXBOARD·needed_shared)·component(COMP_POSTER_FOMEXBOARD_BOARD·needed_shared)·gap 3. -->
<!-- ★수치(사이즈·자재·격자 shape)는 아래 전사표(transcribed-by·transcribe_product_130.py)에만. props raw 미기입(D-9·L-12). -->
<!-- ★가격 값(unit_price)은 전사하지 않음 — 연결·차원·격자완전성까지만(D-18·값=evaluate_price). 고정가 4셀 단가범위는 grid shape 증거만. -->

# product-130 하위 노드 (포맥스보드 전용 축 원자 + 공식/GAP)

포맥스보드(PRD_000130)가 쓰는 보드액자 카테고리·포맥스 보드 자재 4종·가격공식·구성요소·수량규칙·GAP 3.
상품→축 연결(has_size·uses_material·has_process·priced_by·has_qty_rule·in_category)은
[[product-130-formax-board]]가 건다. 사이즈(SIZ_000174/197)·라미 공정(PROC_000014/015)·포스터 카테고리
(CAT_000004)는 **공유 노드 재사용**(위 주석·재정의 안 함). 공식→구성요소 배선(has_component)은 아래 formula 블록.

## 상품 요소 전사표 (권위 = 라이브 마스터·스크립트 전사)

> 아래 표는 모두 `_meta/scripts/transcribe_product_130.py`가 live-snapshot(snap_20260702_1119)에서 결정론
> 전사(LLM 손전사 금지·D-9). 캐시=`_meta/scripts/cache/transcribed-130-260703.json`. 실사 시트는 260702 diff
> 무영향(pack §5.5)이라 라이브 현재값=권위 정합(양면 소재 없음).

### 상품 정체·수량 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_130.py from live-snapshot/latest (snap_20260702_1119) t_prd_products PRD_000130 @ 2026-07-03 -->
| prd_typ_cd | nonspec | min_qty | max_qty | qty_incr | qty_unit | file_upload | editor | use_yn |
|---|---|---|---|---|---|---|---|---|
| PRD_TYPE.01 | N | 1 | 10000 | 1 | QTY_UNIT.01 | Y | N | Y |

> nonspec_yn=N → 비규격 연속범위 없음(이산 규격 A3/A2만). 수량 min1/max10000/incr1(제품 레벨).

### 카테고리 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_130.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_categories+t_cat_categories @ 2026-07-03 -->
| cat_cd | 이름 | 부모 | lvl | main_cat_yn |
|---|---|---|---|---|
| CAT_000080 | 보드액자 | CAT_000004 | 2 | N |
| CAT_000004 | 포스터 |  | 1 | Y |

### 사이즈 (전사·전 행·del 표기)

<!-- transcribed-by: _meta/scripts/transcribe_product_130.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_sizes+t_siz_sizes @ 2026-07-03 -->
| siz_cd | 라벨 | 작업(mm) | dflt | 링크 del | 마스터 del |
|---|---|---|---|---|---|
| SIZ_000174 | A3(297x420mm) | 297x420 | Y | N | N |
| SIZ_000197 | A2(420x594mm) | 420x594 | Y | N | N |

### 자재 (전사·★두께×사이즈 내장·MAT_TYPE.16 실사부자재)

<!-- transcribed-by: _meta/scripts/transcribe_product_130.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_materials+t_mat_materials @ 2026-07-03 -->
| mat_cd | 이름 | mat_typ | 상위자재 | usage_cd | dflt |
|---|---|---|---|---|---|
| MAT_000022 | 포맥스(화이트) 3mm A3 | MAT_TYPE.16 | MAT_000021 | USAGE.07 | N |
| MAT_000023 | 포맥스(화이트) 5mm A3 | MAT_TYPE.16 | MAT_000021 | USAGE.07 | N |
| MAT_000554 | 포맥스(화이트) 3mm A2 | MAT_TYPE.16 | MAT_000021 | USAGE.07 | N |
| MAT_000555 | 포맥스(화이트) 5mm A2 | MAT_TYPE.16 | MAT_000021 | USAGE.07 | N |

### 공정 (전사·라미네이팅·mand N — ★재사용 axis/processes)

<!-- transcribed-by: _meta/scripts/transcribe_product_130.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_processes+t_proc_processes @ 2026-07-03 -->
| proc_cd | 공정명 | 상위공정 | mand | 링크 del |
|---|---|---|---|---|
| PROC_000014 | 유광라미네이팅 | PROC_000013 | N | N |
| PROC_000015 | 무광라미네이팅 | PROC_000013 | N | N |

### 판형 (전사·전 행·del 표기 — ★비종이류=판형 무의미·둘 다 del_yn=Y)

<!-- transcribed-by: _meta/scripts/transcribe_product_130.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_plate_sizes @ 2026-07-03 -->
| siz_cd | output_paper_typ | output_file | dflt | del | note |
|---|---|---|---|---|---|
| SIZ_000175 | (공백) | JPG | Y | Y | 파일사양 |
| SIZ_000303 | (공백) | JPG | Y | Y | 파일사양 |

### 미보유 축 (전사·0행 실측)

<!-- transcribed-by: _meta/scripts/transcribe_product_130.py from live-snapshot/latest (snap_20260702_1119) print_options/bundle_qtys/addons/constraints/option_groups/sets @ 2026-07-03 -->
| 축 | 행수 |
|---|---|
| print_options(도수) | 0 |
| bundle_qtys(묶음수) | 0 |
| addons(추가상품) | 0 |
| constraints(제약규칙) | 0 |
| option_groups(CPQ 옵션) | 0 |
| sets(셋트 부모) | 0 |

### 가격 배선 (전사·priced_by→공식→구성요소)

<!-- transcribed-by: _meta/scripts/transcribe_product_130.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_price_formulas+t_prc_formula_components+t_prc_price_components @ 2026-07-03 -->

공식 **PRF_POSTER_FOMEXBOARD** — 포맥스보드 완제품가(면적/규격 단가) (use_yn=Y)

| disp_seq | comp_cd | addtn | prc_typ | comp_nm | use_dims |
|---|---|---|---|---|---|
| 1 | COMP_POSTER_FOMEXBOARD_BOARD | Y | PRICE_TYPE.01 | 포맥스보드(두께×사이즈) 완제품가 | `["mat_cd", "siz_cd"]` |

### 고정가 룩업 셀 요약 (전사·D-22 접기 — 전개 금지·값=range shape 증거만·개별값 미노출)

<!-- transcribed-by: _meta/scripts/transcribe_product_130.py from live-snapshot/latest (snap_20260702_1119) t_prc_component_prices (COMP_POSTER_FOMEXBOARD_BOARD 집계) @ 2026-07-03 -->
| comp_cd | use_yn | 행수 | 자재축(개수) | 사이즈축 | 셀존재/잠재 | 단가범위(shape) | use_dims |
|---|---|---|---|---|---|---|---|
| COMP_POSTER_FOMEXBOARD_BOARD | Y | 4 | 4(MAT_000022/MAT_000023/MAT_000554/MAT_000555) | SIZ_000174/SIZ_000197 | 4/8 | 8500~16000 | `["mat_cd", "siz_cd"]` |

> ★셀존재/잠재=4/8: 자재 4종 × 사이즈 2종 = 8 잠재조합이나, **자재코드가 사이즈를 내장**
> (3mm-A3/5mm-A3=SIZ_000174·3mm-A2/5mm-A2=SIZ_000197)이라 유효 격자는 **두께2 × 사이즈2 = 4셀**
> (각 자재의 내장 사이즈와 siz_cd 일치행만 실재). 격자완전(유효 4/4)·수량축 없음(min_qty NULL).
> 단가범위는 격자 shape 증거일 뿐 — 개별 셀단가·계산=evaluate_price 권위(D-18·값 노드 미기록).

## 카테고리 노드 (★재사용 — 보드액자 CAT_000080·재정의 안 함·L-3 회피)

<!-- ★CAT_000080 보드액자는 병렬 보드/액자 빌더(131 프레임리스우드액자·132 레더아트액자)가 이미 정의 → 130은 -->
<!-- 참조만(재정의 금지·L-3 중복 회피). 130 main이 in_category→category-CAT_000080로 참조. needed_shared 반환 -->
<!-- (consolidation이 131/132/130 중 canonical 선정·향후 axis/categories.md 승격). -->
<!-- 부모 CAT_000004(포스터)도 119-nodes canonical 재사용(참조만). -->

## 자재 노드 (product-local — 포맥스 보드 4종·MAT_TYPE.16 실사부자재)

<!-- ★130 자재=포맥스 보드(MAT_TYPE.16 실사부자재·정당). 실사 팩이 경고한 레더 MAT_000186 .08→.05 crosscut과 완전 무관 -->
<!-- (레더=100/126/296/298 횡단·pack §1.1·T-2). 포맥스 .16=현재값이자 정답(양면 불요). IMPORT 자재 삭제 금지. -->
<!-- 부모 MAT_000021(포맥스)은 상품 링크 없음(자식 4종만 uses_material) → 노드 미생성·props upr로만 표기(환각 차단). -->

### [material-MAT_000022] 포맥스(화이트) 3mm A3 {verified}
- type: material
- anchor: t_mat_materials/MAT_000022
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "테이블:t_mat_materials 키:MAT_000022(mat_nm=포맥스(화이트) 3mm A3·mat_typ_cd=MAT_TYPE.16·upr_mat_cd=MAT_000021·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_materials.csv", source_locator: "키:(PRD_000130,MAT_000022) USAGE.07·dflt_yn=N·disp_seq=1·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.16", upr_mat_cd: "MAT_000021", 두께: "3mm", 내장사이즈: "A3(SIZ_000174)", 사용: "130 본체 자재(USAGE.07)", note: "실사부자재 포맥스 보드(정당·레더 crosscut 아님·pack §3.5). 고정가 룩업 (MAT_000022,SIZ_000174) 셀"}
- 본문: 포맥스보드 본체 자재(3mm A3). 낱장 완제품 단일 슬롯(USAGE.07·내지/표지 없음). 두께+사이즈를 자재코드에 내장 → 가격 구성요소 use_dims=[mat_cd,siz_cd]의 mat_cd 축. [[product-130-formax-board]] uses_material 대상.

### [material-MAT_000023] 포맥스(화이트) 5mm A3 {verified}
- type: material
- anchor: t_mat_materials/MAT_000023
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "테이블:t_mat_materials 키:MAT_000023(mat_nm=포맥스(화이트) 5mm A3·mat_typ_cd=MAT_TYPE.16·upr_mat_cd=MAT_000021·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_materials.csv", source_locator: "키:(PRD_000130,MAT_000023) USAGE.07·dflt_yn=N·disp_seq=3·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.16", upr_mat_cd: "MAT_000021", 두께: "5mm", 내장사이즈: "A3(SIZ_000174)", 사용: "130 본체 자재(USAGE.07)", note: "실사부자재 포맥스 보드. 고정가 룩업 (MAT_000023,SIZ_000174) 셀"}
- 본문: 포맥스보드 본체 자재(5mm A3). USAGE.07 단일 슬롯. [[product-130-formax-board]] uses_material 대상.

### [material-MAT_000554] 포맥스(화이트) 3mm A2 {verified}
- type: material
- anchor: t_mat_materials/MAT_000554
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "테이블:t_mat_materials 키:MAT_000554(mat_nm=포맥스(화이트) 3mm A2·mat_typ_cd=MAT_TYPE.16·upr_mat_cd=MAT_000021·06-29 신설·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_materials.csv", source_locator: "키:(PRD_000130,MAT_000554) USAGE.07·dflt_yn=N·disp_seq=2·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.16", upr_mat_cd: "MAT_000021", 두께: "3mm", 내장사이즈: "A2(SIZ_000197)", 사용: "130 본체 자재(USAGE.07)", note: "실사부자재 포맥스 보드(06-29 신설). 고정가 룩업 (MAT_000554,SIZ_000197) 셀"}
- 본문: 포맥스보드 본체 자재(3mm A2·06-29 신설). USAGE.07 단일 슬롯. [[product-130-formax-board]] uses_material 대상.

### [material-MAT_000555] 포맥스(화이트) 5mm A2 {verified}
- type: material
- anchor: t_mat_materials/MAT_000555
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "테이블:t_mat_materials 키:MAT_000555(mat_nm=포맥스(화이트) 5mm A2·mat_typ_cd=MAT_TYPE.16·upr_mat_cd=MAT_000021·06-29 신설·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_materials.csv", source_locator: "키:(PRD_000130,MAT_000555) USAGE.07·dflt_yn=N·disp_seq=4·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.16", upr_mat_cd: "MAT_000021", 두께: "5mm", 내장사이즈: "A2(SIZ_000197)", 사용: "130 본체 자재(USAGE.07)", note: "실사부자재 포맥스 보드(06-29 신설). 고정가 룩업 (MAT_000555,SIZ_000197) 셀"}
- 본문: 포맥스보드 본체 자재(5mm A2·06-29 신설). USAGE.07 단일 슬롯. [[product-130-formax-board]] uses_material 대상.

## 수량규칙 노드 (product-local)

### [qty-130] 포맥스보드 수량규칙 {verified}
- type: bundle_qty
- anchor: t_prd_products/PRD_000130
- src: {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "키:PRD_000130 min_qty/max_qty/qty_incr(1/10000/1)·qty_unit_typ_cd=QTY_UNIT.01", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/_foundation/batch/qty_rule_audit_260702.py", source_locator: "수량 UI 권위=상품/사이즈 규칙(가격구간과 역할 분리)", captured_at: "2026-07-03", badge: verified, src_id: SR-27-qtyaudit}
- props: {min_max_incr_ref: "전사표 수량규칙(상품 1/10000/1)", bdl_unit_typ_cd: "QTY_UNIT.01", bundle_qtys_rows: 0, note: "★고정가 룩업형이라 수량축이 가격 차원 아님(구성요소 use_dims=[mat_cd,siz_cd]·수량 없음). 셀단가=보드1장가·총액=셀×수량(수량구간 할인 없음)"}
- 본문: 수량 그릇 = 상품 마스터 컬럼(min 1·max 10000·incr 1). t_prd_product_bundle_qtys 0행 정상(수량 UI 권위=상품 레벨·[[rule/decisions#DEC_qty_audit_260702]]). 가격은 수량 무관 통가격.

## 가격공식 노드 (product-local — silsa formula 축 승격 대기·needed_shared)

<!-- ★고정가 룩업형(면적매트릭스·원자합산과 다른 아키타입). 단일 구성요소(완제품가)를 (mat_cd×siz_cd) 셀에서 조회. -->
<!-- has_component 타깃 component-COMP_POSTER_FOMEXBOARD_BOARD = 아래 130 canonical 정의(130 전용·타 상품 미공유). -->

### [formula-PRF_POSTER_FOMEXBOARD] 포맥스보드 완제품가 (고정가 룩업·두께×사이즈) {verified}
- type: price_formula
- anchor: t_prc_price_formulas/PRF_POSTER_FOMEXBOARD
- src: {source_file: "live-snapshot/latest/t_prc_price_formulas.csv", source_locator: "테이블:t_prc_price_formulas 키:PRF_POSTER_FOMEXBOARD(frm_nm=포맥스보드 완제품가(면적/규격 단가)·note=포스터사인 포맥스보드 소재/사이즈/수량별 완제품 통가격·use_yn=Y)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prc_formula_components.csv", source_locator: "frm_cd:PRF_POSTER_FOMEXBOARD(comp COMP_POSTER_FOMEXBOARD_BOARD·disp_seq 1·addtn_yn Y·1행·07-02 배선)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_price_formulas.csv", source_locator: "키:(PRD_000130,PRF_POSTER_FOMEXBOARD) 바인딩·apply_bgn_ymd=2026-06-01", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: has_component, target: component-COMP_POSTER_FOMEXBOARD_BOARD, qualifier: {disp_seq: 1, addtn: Y}}
- props: {archetype: "고정가 룩업형(fixed·통가격)", use_yn: Y, note: "130 바인딩 전용 공식. 단일 구성요소(완제품가)를 (mat_cd×siz_cd) 4셀에서 조회(evaluate_price). frm_nm '(면적/규격 단가)'는 명명일 뿐·실 use_dims=[mat_cd,siz_cd] 고정 룩업(면적매트릭스 아님·전사표 검증)"}
- 본문: 포맥스보드 가격공식. 단일 구성요소(완제품가) 1건 배선 — 인쇄·용지·라미를 원자 합산하지 않고 (두께×사이즈) 고정 룩업에서 완제품 통가격을 조회한다. 배선 타깃 [[component-COMP_POSTER_FOMEXBOARD_BOARD]](아래 130 canonical 정의). 고아 공식 아님(has_component 1건·07-02 배선·pack §27 정합). 값 계산=evaluate_price 권위(D-18·[[rule/rules#RULE_price_value_boundary]]).

## 가격구성요소 노드 (product-local canonical — 고정가 룩업·silsa component 축 승격 대기·needed_shared)

<!-- ★COMP_POSTER_FOMEXBOARD_BOARD = 포맥스보드 완제품가(두께×사이즈). 130 전용(타 상품 미공유·118의 동형결합 4소재 comp와 다름). -->
<!-- ★단가행(4셀)은 노드로 펼치지 않고 use_dims 차원+SHAPE로 접음(D-22). 값(unit_price·단가범위 8500~16000)은 grid shape 증거로만·개별 셀단가 미전사(evaluate_price 권위). -->

### [component-COMP_POSTER_FOMEXBOARD_BOARD] 포맥스보드 완제품가 (두께×사이즈·고정 룩업) {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_POSTER_FOMEXBOARD_BOARD
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "테이블:t_prc_price_components 키:COMP_POSTER_FOMEXBOARD_BOARD(comp_typ=PRC_COMPONENT_TYPE.06·prc_typ_cd=PRICE_TYPE.01·use_dims=[mat_cd,siz_cd]·note=포스터·사인 완제품가(소재+출력+가공 포함 통가격)·단가=가격표260527 verbatim·use_yn=Y)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/_meta/scripts/cache/transcribed-130-260703.json", source_locator: "grid.COMP_POSTER_FOMEXBOARD_BOARD(행4·자재4·사이즈2·셀 4/8 유효·단가범위 shape 8500~16000)", captured_at: "2026-07-03", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.01", comp_typ_cd: "PRC_COMPONENT_TYPE.06", use_dims: '["mat_cd", "siz_cd"]', role: "포맥스보드 완제품 통가격(소재+출력+가공 포함·라미 통가격 포함)", 단가행_ref: "전사표 고정가 shape(4행=두께2×사이즈2·유효격자 4/4·수량축 미충전 min_qty NULL)", archetype: "고정가 룩업(fixed·면적매트릭스 아님)", 폼보드동형: "폼보드 BOARD 동형 260702(comp note)"}
- 본문: 포맥스보드 완제품가 구성요소(canonical·130 전용). use_dims 2축(자재 mat_cd × 사이즈 siz_cd)으로 셀단가가 달라진다(차원 선언까지·D-22 단가행 접기). 자재코드가 두께+사이즈를 내장(3mm/5mm × A3/A2)이라 유효 4셀(전사표 SHAPE). 값=evaluate_price(개별 셀단가 미전사·단가범위는 grid shape 증거만·D-18·[[rule/rules#RULE_price_value_boundary]]). 단가는 인쇄상품 가격표 260527 verbatim(comp note·폼보드 BOARD 동형 260702).

## GAP 노드 (원천 부재·정직 선언)

### [gap-130-lamination-no-optiongroup] 라미네이팅 공정 부착·CPQ 옵션그룹 부재 {unknown}
- type: gap
- anchor: none  # 사유: 라미(014/015) 공정이 상품에 부착됐으나 option_group 0행 → 손님 선택 UI·가산 여부 미확정
- src: {source_file: "live-snapshot/latest/t_prd_product_processes.csv", source_locator: "키:(PRD_000130,PROC_000014/015) mand_proc_yn=N·del_yn=N vs t_prd_product_option_groups PRD_000130 0행", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- gap_what: "유광/무광 라미네이팅(PROC_000014/015)이 130에 부착됐으나 CPQ 옵션그룹이 0행이라 손님이 라미를 고르는 경로가 없음. 118은 코팅 옵션그룹(optgroup-118-coating)으로 선택하나 130은 옵션그룹 자체가 없음. 라미가 (1) 통가격에 포함된 기본가공이라 선택 불필요인지, (2) 옵션 미적재(BATCH-6 대기)인지 미확정"
- gap_fill_from: "실무진 + webadmin 실화면(포맥스보드 옵션 UI에 라미 선택 노출 여부)·pack §3.9 GAP-SL-6(CPQ 옵션 레이어 일괄 적재)"
- gap_owner: staff
- 본문: 가격 경로는 연결됨([[formula-PRF_POSTER_FOMEXBOARD]]→[[component-COMP_POSTER_FOMEXBOARD_BOARD]]·유효 4셀)이라 견적 0 위험 없음. 다만 라미네이팅 공정이 부착만 되고 선택 UI(옵션그룹)가 없어 손님 라미 선택 경로가 불명. comp note "가공 포함 통가격"이면 라미가 통가격에 녹아 선택 불필요일 수 있으나 권위 확정 부재(정직 선언).

### [gap-130-cpq-option-layer] CPQ 옵션 레이어 미적재 (두께/규격 선택 UI) {unknown}
- type: gap
- anchor: none  # 사유: 두께(3mm/5mm)·규격(A3/A2) 선택이 자재(mat_cd)로 환원되나 option_group 0행이라 손님 선택 UI 부재
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "키:PRD_000130 0행(옵션그룹 미적재)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- gap_what: "포맥스보드는 두께(3mm/5mm)·규격(A3/A2)이 자재코드(MAT_000022/023/554/555)에 내장돼 가격 축이나, CPQ 옵션그룹이 0행이라 손님이 두께/규격을 고르는 정형 옵션 UI가 없음. 자재 선택→uses_material 차원 환원 경로만 존재. 실사 27상품 CPQ 미적재(pack §3.9 GAP-SL-6·BATCH-6)의 일부"
- gap_fill_from: "실무진 + pack §3.9 silsa-option-layer-v2(자재+공정 BUNDLE 매핑)·BATCH-6 일괄 적재 인간 승인"
- gap_owner: staff
- 본문: 130은 옵션그룹 0행(118과 차이). 두께/규격 선택이 자재 4종으로 표현되나 손님 선택 옵션 레이어가 미적재. 가격 사슬은 끊기지 않음(자재 선택으로 셀 조회 가능) — 옵션 UI 구성만 GAP(BATCH-6 대기).

### [gap-130-fixedprice-basis] 보드 완제품 통가격 산정 근거 문서 부재 {unknown}
- type: gap
- anchor: none  # 사유: 고정가 4셀 완제품 통가격(소재+출력+가공)이 어떤 규칙으로 산정됐는지 엑셀 미기재 암묵지
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/source-registry.md", source_locator: "문서:§9 GAP-2 롤 소재 가격 계산 로직(엑셀 미기재 암묵지·실사 전체 영향)", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-silsa}
- gap_what: "고정가 4셀(두께×사이즈) 완제품 통가격이 보드 원가+출력비+라미 가공비를 어떤 규칙으로 통합해 산출됐는지 — 값은 라이브에 적재됐고(260527 verbatim) 라이브 셀단가=가격표 원본이나 산정식 자체는 문서 부재"
- gap_fill_from: "실무진 확인(source-registry §9 GAP-2·실사 전체 공통). 예전사이트 골든 대조로 값 정합 검증 가능하나 산정식은 암묵지"
- gap_owner: staff
- 본문: 가격 경로는 연결됨([[formula-PRF_POSTER_FOMEXBOARD]]→[[component-COMP_POSTER_FOMEXBOARD_BOARD]]·유효 4/4셀 완전격자)이라 견적 0 위험 없음. 다만 통가격이 **어떻게** 산정됐는지는 엑셀 미기재 암묵지(실사 전체 공통 GAP). 온톨로지는 연결·차원까지, 값 계산은 evaluate_price 권위이므로 이 GAP은 값 정합이 아니라 "산정 근거 문서 부재"의 정직 선언. 130은 보드(비종이류)라 "롤 소재"는 아니나 완제품 통가격 산정 암묵지는 동일 부류.
