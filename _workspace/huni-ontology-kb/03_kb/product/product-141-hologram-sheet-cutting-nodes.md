<!-- product-local sub-nodes: E2 category·E4 material·E8 bundle_qty·E9 price_formula·E10 price_component·gap for PRD_000141 홀로그램 시트커팅. -->
<!-- ★공유 노드 재사용(중복 mint 방지·L-3): -->
<!--   - size-SIZ_000172(A4)·size-SIZ_000174(A3) = product-047-small-flyer.md owner → 재사용 참조만(재정의 안 함). -->
<!--   - size-SIZ_000197(A2) = 공유 axis/sizes.md owner → 재사용 참조만. -->
<!-- ★여기 신설(141 고유·타 빌더 미정의): category-CAT_000092(공유 보증·needed_shared)·material-MAT_000257·qty-141 -->
<!--   ·formula-PRF_POSTER_SHEETCUT_HOLO·component-COMP_POSTER_SHEETCUT_HOLO(★실사 고정가형 시트커팅 공식/구성요소)·gap 4. -->
<!-- ★수치(규격·고정가 SHAPE)는 아래 전사표(transcribed-by·transcribe_product_141.py)에만. props raw 미기입(D-9·L-12). -->
<!-- ★가격 값(unit_price)은 전사하지 않음 — 연결·차원·격자완전성까지만(D-18·값=evaluate_price). -->

# product-141 하위 노드 (홀로그램 시트커팅 — 실사 고정가형 전용 마스터 + GAP)

홀로그램 시트커팅(PRD_000141)이 여기 신설하는 것 = 시트커팅/스티커 카테고리(★병렬 형제 공유·node 실재
보증)·자재(홀로그램)·수량규칙·가격공식·가격구성요소(★실사 고정가형 시트커팅)·GAP 4. 규격 사이즈(A4/A3/A2)는
공유 축(product-047·axis/sizes)이 이미 소유해 재사용 참조만 한다(중복 mint 금지·L-3). 상품→축 연결
(has_size·uses_material·priced_by·has_qty_rule)은 [[product-141-hologram-sheet-cutting]]가 건다. 판형
(plate_size)은 실사 비종이류라 노드 없음(파일사양 placeholder·전부 del_yn=Y·pack §3.8·T-7). 인쇄옵션(도수)도
없음(실사 대형잉크젯 풀컬러·po=0). 공정 0행(화이트 underbase 미연결=GAP). CPQ 옵션그룹·제약규칙 0행
(nonspec_yn=N·설계상 해당 없음).

## 전사표 (권위 = 라이브 스냅샷·스크립트 전사)

> 아래 표는 `_meta/scripts/transcribe_product_141.py`가 live-snapshot에서 결정론 전사(손전사 아님).
> `python3 transcribe_product_141.py` 재실행 시 동일 출력(멱등). JSON 캐시=`cache/transcribed-141-260703.json`.

<!-- transcribed-by: _meta/scripts/transcribe_product_141.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_categories+t_cat_categories PRD_000141 @ 2026-07-03 -->
| cat_cd | 분류명 | 상위 | lvl | main |
|---|---|---|---|---|
| CAT_000092 | 시트커팅/스티커 | CAT_000005 | 2 | N |

<!-- transcribed-by: _meta/scripts/transcribe_product_141.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_sizes+t_siz_sizes PRD_000141 @ 2026-07-03 -->
| siz_cd | 라벨 | 작업(work mm) | master_del_yn | junction_del_yn |
|---|---|---|---|---|
| SIZ_000172 | A4(210x297mm) | 210x297 | N | N |
| SIZ_000174 | A3(297x420mm) | 297x420 | N | N |
| SIZ_000197 | A2(420x594mm) | 420x594 | N | N |

<!-- transcribed-by: _meta/scripts/transcribe_product_141.py from live-snapshot/latest (snap_20260702_1119) t_mat_materials+t_prd_product_materials PRD_000141 @ 2026-07-03 -->
| mat_cd | 자재명 | mat_typ | usage | master_del_yn(★) | junction_del_yn |
|---|---|---|---|---|---|
| MAT_000257 | 홀로그램 | MAT_TYPE.08 | USAGE.07 | Y | N |
> ★자재 마스터 del_yn=Y(2026-06-16 논리삭제)이나 상품링크(junction) del_yn=N 활성 = 링크활성/마스터삭제 불일치(정직 관찰·127 동형).

공정(t_prd_product_processes) 활성 행수 = 0 (★화이트 underbase PROC_000008 미연결·pack §3.3 홀로그램 도메인필수인데 라이브 부재=GAP·시트커팅 커팅공정도 0행·통가격 baked 추정)
인쇄옵션(t_prd_product_print_options) 행수 = 0 (실사 대형잉크젯 풀컬러·도수 컬럼 없음·설계상 정당)
옵션그룹(t_prd_product_option_groups) 행수 = 0 / 제약(t_prd_product_constraints) 행수 = 0 (nonspec_yn=N·141은 constraints 신규발현 7상품 미포함=정당)
추가상품(t_prd_product_addons) 행수 = 0 / 셋트(t_prd_product_sets 부모) 행수 = 0 (부속 8상품 미해당·통가격 단일상품)
수량규칙(t_prd_product_bundle_qtys) 행수 = 0 (제품 레벨 수량 공란·pack §3.4 GAP-SL-8 홀로그램 L1 빈값)

<!-- transcribed-by: _meta/scripts/transcribe_product_141.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_plate_sizes (★전 행 output_paper_typ 공란·del_yn=Y=파일사양 placeholder·비종이류 판형 무의미·pack §3.8·T-7) PRD_000141 @ 2026-07-03 -->
| siz_cd | 라벨 | 용도 |
|---|---|---|
| SIZ_000050 | A4 (210X297) | AI 파일사양(판형 아님·del_yn=Y) |
| SIZ_000052 | A3 (297X420mm) | AI 파일사양(판형 아님·del_yn=Y) |
| SIZ_000198 | A2 (420X594mm) | AI 파일사양(판형 아님·del_yn=Y) |

<!-- transcribed-by: _meta/scripts/transcribe_product_141.py from live-snapshot/latest (snap_20260702_1119) t_prd_products PRD_000141 @ 2026-07-03 -->
| 항목 | 값 |
|---|---|
| prd_nm | 홀로그램 시트커팅 |
| prd_typ_cd | PRD_TYPE.01 |
| nonspec_yn(★N=사용자입력 없음) | N |
| min_qty | (공란) |
| max_qty | (공란) |
| qty_incr | (공란) |
| qty_unit | QTY_UNIT.01 |
| use_yn | Y |
| del_yn | N |
| file_upload | Y |
| editor | N |

<!-- transcribed-by: _meta/scripts/transcribe_product_141.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_price_formulas+t_prc_formula_components+t_prc_price_components PRD_000141 @ 2026-07-03 -->
| frm_cd | 상품 바인딩 | comp_cd(배선) | prc_typ_cd | comp_typ_cd | use_dims |
|---|---|---|---|---|---|
| PRF_POSTER_SHEETCUT_HOLO | True | COMP_POSTER_SHEETCUT_HOLO | PRICE_TYPE.01 | PRC_COMPONENT_TYPE.06 | ["siz_cd"] |

<!-- transcribed-by: _meta/scripts/transcribe_product_141.py from live-snapshot/latest (snap_20260702_1119) t_prc_component_prices COMP_POSTER_SHEETCUT_HOLO (★고정가 SHAPE·값 미전사) @ 2026-07-03 -->
| comp_cd | 차원(use_dims) | 규격셀수 | siz 셀 | 수량밴드수 | 단가행수 | 격자완전 | 수량축충전 | 규격=가격셀 정합 |
|---|---|---|---|---|---|---|---|---|
| COMP_POSTER_SHEETCUT_HOLO | ["siz_cd"] | 3 | SIZ_000172,SIZ_000174,SIZ_000197 | 0 | 3 | True | False | True |

> **격자완전(grid_full)=True** = 규격 3셀(A4·A3·A2)이 이 빠짐 없이 채워짐(미적재 셀 0·수량밴드 없음).
> **규격=가격셀 정합=True**: 상품 등록 규격 3행(SIZ_000172/174/197)이 고정가 단가표 3셀과 정확히 일치.
> ★**수량축충전=False**: use_dims=[siz_cd] 단일축 → 수량밴드 자체가 없음(min_qty 공란). 규격당 통가격(수량구간 할인 없음). 값=evaluate_price(D-18).
> ★**131과 다름**: 131은 use_dims=[siz_cd,min_qty](수량축 1밴드)이나 141은 [siz_cd] 단일축(수량축 부재)·둘 다 면적매트릭스 아님(등록 규격 키 룩업·off-grid ceiling·비대칭 없음).

## 사이즈 (재사용 참조 — 공유 축 owner·중복 mint 금지)

★**consolidation 정합:** 141 규격은 전부 다른 파일이 이미 소유하므로 141은 **재사용 참조만**(L-3 중복 mint
금지)·has_size 프론트매터 엣지는 유지(target 실재):
- `size-SIZ_000172`(A4 210x297) = **product-047(소량전단지) owner**(재사용·A계열 공용).
- `size-SIZ_000174`(A3 297x420) = **product-047(소량전단지) owner**(재사용·A계열 공용).
- `size-SIZ_000197`(A2 420x594) = **공유 [axis/sizes.md](../axis/sizes.md) owner**(재사용).

실사 사이즈 = 이산 등록 규격 SIZ(A4/A3/A2)만(nonspec_yn=N·연속범위 없음·pack §3.2). 판걸이수(UP수)는 종이류
파생값이라 실사 무의미(판형 절). 고정가 단가는 규격(siz_cd) 키로 저장(면적 siz_width/siz_height 아님·가격
구성요소 절).

---

## 카테고리 (category) — 시트커팅/스티커 (실사 leaf·★병렬 다중귀속·needed_shared)

★**consolidation 정합:** `category-CAT_000092`(시트커팅/스티커·cat_lvl 2·상위 CAT_000005 사인)는 141의 유일
등록 분류이자, **병렬 시트커팅 빌더 140 무광시트커팅·142 유광아크릴스티커·143 미러아크릴스티커 등이 동시에
귀속**하는 공유 leaf다(pack §1.1 CAT_000092(4)). 실사 시트커팅/스티커 카테고리는 공유 categories.md에 아직
없어 여기 정의하고 **needed_shared_nodes**로 반환(consolidation이 단일 소유권으로 이관·향후 승격 대상).
★동시 빌드 중 여러 형제가 이 노드를 mint하면 L-3 중복이 뜰 수 있으나(consolidation이 dedupe), 아무도 정의
안 하면 I-2 끊긴 링크(더 나쁨)라 141이 실재 노드를 보증한다. 상위 사인(CAT_000005)은 실사 형제 소유 — 141은
등록 junction이 있는 leaf CAT_000092만 in_category(직접 CAT_000005 junction 없음).

### [category-CAT_000092] 시트커팅/스티커 (실사 leaf·cat_lvl 2·상위 사인·140~143 공유·141 등록 분류) {verified}
- type: category
- anchor: t_cat_categories/CAT_000092
- src: {source_file: "live-snapshot/latest/t_cat_categories.csv", source_locator: "테이블:t_cat_categories 키:CAT_000092 cat_nm=시트커팅/스티커·cat_lvl=2·upr_cat_cd=CAT_000005·use_yn=Y·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_categories.csv", source_locator: "테이블:t_prd_product_categories 키:(PRD_000141,CAT_000092) main_cat_yn=N·141 유일 등록 분류(140/142/143 형제도 동일 leaf 귀속)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "문서:§1.1 실사 28상품 카테고리 재연결(CAT_000092(2)~(4))·CAT_000298 고아 STALE(승계·재검증 2026-07-03)", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-silsa}
- props: {cat_lvl: 2, upr_cat_cd: "CAT_000005", main_cat_yn_for_141: "N", 공유귀속: "140 무광시트커팅·141 홀로그램시트커팅·142 유광아크릴스티커·143 미러아크릴스티커 등(consolidation dedupe 대상)"}
- 본문: 시트커팅/스티커 계열 실사 leaf(사인 CAT_000005 하위). 소재·완성형태(시트커팅)가 상품 정체를 가르는 실사 특성(pack §0 특성1)이 카테고리에 반영. ★병렬 형제 다중귀속 공유 노드(needed_shared·단일 소유권은 consolidation 소관·[[axis/categories]] 승격 대기). round-13 "CAT_000298 고아"는 해소(STALE·T-1).

---

## 자재 노드 (material) — 홀로그램 (★마스터 논리삭제·링크 활성 불일치 정직 관찰)

### [material-MAT_000257] 홀로그램 (실사 시트커팅 소재·USAGE.07·MAT_TYPE.08·★마스터 del_yn=Y) {verified}
- type: material
- anchor: t_mat_materials/MAT_000257
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "키:MAT_000257(mat_nm=홀로그램·mat_typ_cd=MAT_TYPE.08 실사소재·upr_mat_cd 공백·use_yn=Y·del_yn=Y 2026-06-16 논리삭제)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_materials.csv", source_locator: "키:(PRD_000141,MAT_000257) usage_cd=USAGE.07·dflt_yn=Y·del_yn=N(junction 활성)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "문서:§3.5 실사 자재=소재별 본체 단일(parent+usage_cd·USAGE.07 공통)·자재유형 .08 목표라벨 코드개편 STALE T-2(승계·재검증 2026-07-03)", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-silsa}
- props: {mat_cd: "MAT_000257", mat_nm: "홀로그램", mat_typ_cd: "MAT_TYPE.08", usage_cd: "USAGE.07", note: "★마스터(t_mat_materials) del_yn=Y(2026-06-16 논리삭제)이나 상품링크(t_prd_product_materials)는 활성(del_yn=N·dflt_yn=Y) — 링크활성/마스터삭제 불일치(정직 관찰·127 타이벡소프트/A1 사이즈 동형). 손님 노출/재등록 여부는 검증 레인 몫(단정 아님·양면 아님=코드값 자체 불변). 낱장 단일 슬롯(USAGE.07). MAT_TYPE.08 실사소재(round-13 목표라벨 .06/.05는 코드개편으로 STALE T-2·홀로그램은 pack §1.1 교정목록 미포함=.08 현재값 유지). IMPORT 등록 자재 삭제 금지([[rule/rules#RULE_import_material_no_delete]])"}
- 본문: 홀로그램 시트커팅 본체 소재(반사 홀로그램 시트). 마스터 논리삭제와 상품링크 활성 불일치를 정직 표기([[product-141-hologram-sheet-cutting]] uses_material). 소재가 상품 정체를 가르는 실사 특성(pack §0 특성1). 이 소재 위에 화이트 underbase(백색 받침)가 도메인상 필요하나 라이브 공정 부재([[#gap-141-white-underbase]]).

---

## 수량규칙 노드 (product-local)

### [qty-141] 홀로그램 시트커팅 수량규칙 (★제품레벨 공란·GAP-SL-8) {verified}
- type: bundle_qty
- anchor: t_prd_products/PRD_000141
- src: {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "키:PRD_000141 min_qty/max_qty/qty_incr(전부 공란)·qty_unit_typ_cd=QTY_UNIT.01", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/_foundation/batch/qty_rule_audit_260702.py", source_locator: "수량 UI 권위=상품/사이즈 규칙(가격구간과 역할 분리)", captured_at: "2026-07-03", badge: verified, src_id: SR-27-qtyaudit}
- props: {min_max_incr_ref: "전사표 수량규칙(상품 공란/공란/공란)", bdl_unit_typ_cd: "QTY_UNIT.01", bundle_qtys_rows: 0, note: "★고정가형이라 수량축이 가격 차원이 아님(use_dims=[siz_cd] 단일축·수량밴드 0). 규격당 통가격·총액=통가격×수량(수량구간 할인 없음). 제품레벨 min/max/incr 공란=pack §3.4 GAP-SL-8 홀로그램 L1 빈값([[#gap-141-qty-empty]])"}
- 본문: 수량 그릇 = 상품 마스터 컬럼(min/max/incr 공란). t_prd_product_bundle_qtys 0행. 131(1/1000/1 채움)과 달리 141은 제품레벨 수량도 공란이라 수량 UI 권위값이 빈값(pack §3.4 GAP-SL-8·[[rule/decisions#DEC_qty_audit_260702]]). 가격은 규격별 통가격(수량 무관·use_dims에 수량축 없음).

---

## 가격공식·구성요소 (★실사 고정가형 시트커팅 — 상품-local mint·needed_shared_node)

실사 = 2 가격모델 공존(pack §3.10). 118·122·126 등은 **면적매트릭스형**(포스터사인 [가로×세로] 셀단가)이고,
141은 **고정가형**(등록 규격 siz_cd 키 룩업). ★131(use_dims=[siz_cd,min_qty])과도 다른 **단일축**
(use_dims=[siz_cd]) 변형. 디지털 원자합산(PRF_DGP_*)·면적매트릭스(PRF_POSTER_CANVAS 등)·스티커 고정룩업
(PRF_STK_FIXED)과 구별되는 실사 고정가 아키타입을 여기 신설(실사 고정가 15상품 향후 승격 후보).

### [formula-PRF_POSTER_SHEETCUT_HOLO] 홀로그램 시트커팅 완제품가(면적/규격 단가) {verified}
- type: price_formula
- anchor: t_prc_price_formulas/PRF_POSTER_SHEETCUT_HOLO
- src: {source_file: "live-snapshot/latest/t_prc_price_formulas.csv", source_locator: "테이블:t_prc_price_formulas 키:PRF_POSTER_SHEETCUT_HOLO frm_nm='홀로그램 시트커팅 완제품가(면적/규격 단가)'·note '포스터사인 홀로그램 시트커팅 소재/사이즈/수량별 완제품 통가격'·use_yn=Y", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prc_formula_components.csv", source_locator: "테이블:t_prc_formula_components 키:(PRF_POSTER_SHEETCUT_HOLO,COMP_POSTER_SHEETCUT_HOLO) disp_seq 1·addtn_yn=Y·1행", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_price_formulas.csv", source_locator: "키:(PRD_000141,PRF_POSTER_SHEETCUT_HOLO) 바인딩", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: has_component, target: component-COMP_POSTER_SHEETCUT_HOLO, qualifier: {disp_seq: 1, addtn: Y}, note: "고정가 완제품가(단일 구성요소·통가격)"}
- props: {archetype: "고정가형(fixed-price·siz_cd 룩업·use_dims=[siz_cd] 단일축)", use_yn: Y, note: "141 바인딩 전용 공식. 단일 구성요소(완제품 통가격)를 규격 siz_cd 셀에서 조회(evaluate_price). 면적매트릭스 아님(가로×세로 순서쌍 없음)·131보다 얕은 단일축(수량밴드 없음)"}
- 본문: 홀로그램 시트커팅 가격공식. 단일 구성요소(완제품 통가격) 1건 배선 — 인쇄·용지·가공을 원자 합산하지 않고 등록 규격(siz_cd)별 완제품 통가격을 조회한다. 고아 공식 아님(has_component 1개). 배선 타깃 [[component-COMP_POSTER_SHEETCUT_HOLO]]. ★118(면적매트릭스)·131(siz_cd×min_qty)와 달리 use_dims=[siz_cd]라 off-grid ceiling·비대칭·수량밴드가 없다. 값 계산=evaluate_price 권위(D-18·[[rule/rules#RULE_price_value_boundary]]).

### [component-COMP_POSTER_SHEETCUT_HOLO] 홀로그램 시트커팅 완제품가 (고정가 siz_cd 셀) {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_POSTER_SHEETCUT_HOLO
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "테이블:t_prc_price_components 키:COMP_POSTER_SHEETCUT_HOLO comp_nm='홀로그램 시트커팅 완제품가'·comp_typ_cd=PRC_COMPONENT_TYPE.06(완제품비)·prc_typ_cd=PRICE_TYPE.01·use_dims=[siz_cd]·note '포스터·사인 완제품가(소재+출력+가공 포함 통가격). 사이즈·수량별 단가표.'·use_yn=Y·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prc_component_prices.csv", source_locator: "테이블:t_prc_component_prices comp_cd=COMP_POSTER_SHEETCUT_HOLO 3셀(siz_cd별·값=전사표 SHAPE·D-22 접기)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-dbmap/02_mapping/silsa-poster-area-matrix/mapping.md", source_locator: "문서:§1.1 고정가형 15상품 홀로그램시트커팅141([수량×규격] 블록·포스터사인·승계·재검증 2026-07-03 — 면적매트릭스 13상품 아님)", captured_at: "2026-07-03", badge: verified, src_id: SR-13-silsa-mapping}
- props: {prc_typ_cd: "PRICE_TYPE.01", comp_typ_cd: "PRC_COMPONENT_TYPE.06", use_dims: '["siz_cd"]', role: "실사 시트커팅 완제품 통가격(소재+출력+가공 포함)·고정가 규격 룩업", 단가행_ref: "전사표 고정가 SHAPE(3셀=규격3·격자완전 True·수량축 미충전·규격=가격셀 정합 True)", archetype: "고정가형(fixed-price·siz_cd 단일축 룩업·off-grid·수량밴드 개념 없음)"}
- 본문: 실사 시트커팅 완제품가 구성요소. use_dims 1축(규격 siz_cd)으로 셀단가가 달라진다(차원 선언까지·D-22 단가행 접기). 규격 3셀(A4·A3·A2) 완전격자(전사표 SHAPE·수량밴드 없음). ★131 전용 단일 공식이 이 comp를 배선(formula_components 실측 1:1). ★소재+출력+가공이 통가격에 baked라 공정 미등록([[#gap-141-white-underbase]])과 정합(커팅·화이트 underbase가 통가격에 흡수 추정). 값=evaluate_price(값·골든 미전사·D-18·[[rule/rules#RULE_price_value_boundary]]).

---

## 정직 GAP (원천 부재·미결·AMBIGUOUS)

### [gap-141-white-underbase] 화이트 underbase 미연결 (홀로그램 도메인필수인데 라이브 공정 0행·pack §3.3) {unknown}
- type: gap
- anchor: none  # 사유: pack §3.3이 홀로그램141을 화이트 underbase(PROC_000008) 도메인필수로 지목하나 t_prd_product_processes 0행 — 연결 여부 재측정 결과=부재
- src: {source_file: "live-snapshot/latest/t_prd_product_processes.csv", source_locator: "테이블:t_prd_product_processes PRD_000141 활성 행수 0(전사표·PROC_000008 화이트 underbase 미연결)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "문서:§3.3 화이트 underbase(PROC_000008)=공정·도메인 필수=접착투명122·투명포스터·홀로그램141·GAP '홀로그램141 화이트 underbase 연결 여부 live 재측정(투명 소재만 확증됨)'", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-silsa}
- gap_what: "홀로그램(반사) 소재 위 불투명 백색 받침(화이트 underbase·PROC_000008)이 도메인상 필요하나 141의 t_prd_product_processes에 0행(미연결). 접착투명포스터122는 PROC_000008 1행 적재됐으나(pack §3.3 CORRECT) 홀로그램141은 부재 — 통가격에 baked돼 별도 공정이 불필요한지, 누락 결함인지 미결"
- gap_fill_from: "실무진(홀로그램 시트커팅에 화이트 백색 받침 인쇄가 실제 들어가는지·통가격 포함인지) + 예전사이트/생산지시 확인. 필요하면 PROC_000008 적재(dbmap 트랙·인간 승인), 통가격 baked면 미연결 정당"
- gap_owner: staff
- rel: {rel: references, target: product-141-hologram-sheet-cutting, note: "화이트 underbase 미연결 상품(공정 0행)"}
- rel: {rel: references, target: material-MAT_000257, note: "홀로그램 반사 소재(백색 받침 도메인 필요)"}
- 본문: 가격 경로는 연결됨(priced_by→formula→component·3셀 완전격자)이라 견적 0 위험 없음. 이 GAP은 '홀로그램 백색 받침 공정이 있어야 하는데 라이브 0행'이 누락인지 통가격 baked인지 원천 미결이라 정직 선언(공정 날조 금지·pack §3.3 재측정 결과=부재).

### [gap-141-qty-empty] 제품레벨 수량 공란 (pack §3.4 GAP-SL-8) {unknown}
- type: gap
- anchor: none  # 사유: min_qty/max_qty/qty_incr 전부 공란·bundle_qtys 0행 — 원본(L1) 미명시(유지 vs 동류값 보완 미결)
- src: {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "키:PRD_000141 min_qty/max_qty/qty_incr 전부 공란(전사표)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "문서:§3.4 [GAP-SL-8] 메쉬현수막/홀로그램/유광아크릴 수량 L1 빈값(유지 vs 동류값 보완)·Q-SL-5·6", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-silsa}
- gap_what: "홀로그램 시트커팅의 제품레벨 수량규칙(min/max/incr)이 전부 공란이고 bundle_qtys 0행이다. 원본(L1)에 수량이 미명시(정합)이나, 수량 UI 최소/최대 값을 비운 채 둘지 동류 실사 상품값으로 보완할지 미결(pack GAP-SL-8)"
- gap_fill_from: "실무진 Q-SL-5/6(홀로그램/메쉬현수막/유광아크릴 수량 최소·최대). 빈값 유지가 정합이면 그대로, 보완 필요하면 동류 실사값 적재(dbmap 트랙·인간 승인)"
- gap_owner: staff
- rel: {rel: references, target: qty-141, note: "제품레벨 수량 공란(L1 빈값)"}
- 본문: 가격은 규격당 통가격(수량 무관·use_dims에 수량축 없음)이라 수량 공란이 견적을 막지는 않는다. 다만 손님 수량 입력 UI의 최소/최대 경계가 빈값이라 pack §3.4 GAP-SL-8로 정직 선언(수량값 날조 금지).

### [gap-141-material-master-mismatch] 자재 마스터 논리삭제 vs 상품링크 활성 불일치 (정직 관찰) {unknown}
- type: gap
- anchor: none  # 사유: MAT_000257 마스터 del_yn=Y(논리삭제)인데 상품 junction del_yn=N(활성) — 정합 판정은 검증 레인 몫(단정 아님)
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "키:MAT_000257 del_yn=Y(2026-06-16 논리삭제·홀로그램 마스터)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_materials.csv", source_locator: "키:(PRD_000141,MAT_000257) del_yn=N·dflt_yn=Y(상품링크 활성)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- gap_what: "홀로그램 소재(MAT_000257) 마스터가 논리삭제(del_yn=Y·2026-06-16)됐는데 141 상품링크는 여전히 활성(del_yn=N·dflt_yn=Y)이다. 손님에게 노출되는 유일 소재가 삭제된 마스터를 가리키는 상태 — 마스터 재활성이 필요한지, 신규 홀로그램 소재로 교체 예정인지 원천 미결(127 타이벡소프트 동형)"
- gap_fill_from: "실무진(홀로그램 소재 마스터 삭제 사유·교체 계획) + 검증 레인 정합 판정. IMPORT 등록 자재 삭제 금지 원칙([[rule/rules#RULE_import_material_no_delete]])과 별개의 마스터/링크 정합 이슈"
- gap_owner: staff
- rel: {rel: references, target: material-MAT_000257, note: "마스터 del_yn=Y·링크 활성 불일치"}
- 본문: 코드값 자체는 불변이라 양면(현재값vs정답) 노드가 아니라 정직 관찰 GAP으로 선언(단정 금지). 가격 경로·소재 정체는 유효하나, 삭제된 마스터를 링크가 가리키는 정합성은 검증 레인 몫.

### [gap-141-price-basis] 고정가 완제품가 산정 근거 문서 부재 (엑셀 미기재 암묵지) {unknown}
- type: gap
- anchor: none  # 사유: 규격별 시트커팅 통가격이 어떤 원가/마진 규칙으로 도출됐는지 어느 엑셀/문서에도 명시 없음(암묵지)
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/source-registry.md", source_locator: "문서:§9 GAP-2 롤/소재 가격 계산 로직(엑셀 미기재 암묵지·실사 전체 영향)", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-silsa}
- src: {source_file: "live-snapshot/latest/t_prc_component_prices.csv", source_locator: "테이블:t_prc_component_prices COMP_POSTER_SHEETCUT_HOLO 3셀(규격별 통가격·값 적재됨·산정근거 문서 부재)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- gap_what: "규격별(A4·A3·A2) 홀로그램 시트커팅 완제품 통가격이 홀로그램 소재원가/시트커팅 출력·가공비 어떤 규칙으로 도출됐는지 — 값은 라이브에 적재됐으나(3셀) 산정 근거 문서 부재"
- gap_fill_from: "실무진 확인(source-registry §9 GAP-2·실사 전체 영향). 예전사이트 골든 대조로 값 정합 검증 가능하나 산정식 자체는 암묵지"
- gap_owner: staff
- rel: {rel: references, target: component-COMP_POSTER_SHEETCUT_HOLO, note: "고정가 3셀(산정 근거 문서 부재)"}
- 본문: 가격 경로는 연결됨([[formula-PRF_POSTER_SHEETCUT_HOLO]]→[[component-COMP_POSTER_SHEETCUT_HOLO]]·3셀 완전격자)이라 견적 0 위험 없음. 다만 통가격이 **어떻게** 산정됐는지는 엑셀 미기재 암묵지(실사 전체 공통 GAP). 온톨로지는 연결·차원까지, 값 계산은 evaluate_price 권위이므로 이 GAP은 값 정합이 아니라 "산정 근거 문서 부재"의 정직 선언.
