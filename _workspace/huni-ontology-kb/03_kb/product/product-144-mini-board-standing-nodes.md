<!-- product-local sub-nodes: E2 category·E8 bundle_qty·E9 price_formula·E10 price_component·gap for PRD_000144 미니보드스탠딩. -->
<!-- ★공유 노드 재사용(중복 mint 방지·L-3): -->
<!--   - size-SIZ_000170(A5) = 공유 axis/sizes.md owner(★양면 defect·master del_yn=Y·junction 활성) → 재사용 참조만(재정의 안 함). -->
<!--   - size-SIZ_000172(A4)·size-SIZ_000174(A3) = product-047-small-flyer.md owner → 재사용 참조만. -->
<!-- ★category-CAT_000005(사인 root) = 병렬 형제 product-142/143(아크릴스티커) 선점 소유 → 재사용 참조만(재정의 안 함·L-3 중복 방지). needed_shared 반환. -->
<!-- ★여기 신설(144 고유/공유 보증): category-CAT_000097(POP leaf·needed_shared) -->
<!--   ·qty-144·formula-PRF_POSTER_MINI_STANDBOARD·component-COMP_POSTER_MINI_STANDBOARD(★실사 고정가형·131 형제·수량밴드 실충전)·gap 4. 실사 고정가 공유 축 승격 후보=needed_shared. -->
<!-- ★수치(규격·수량밴드·고정가 SHAPE)는 아래 전사표(transcribed-by·transcribe_product_144.py)에만. props raw 미기입(D-9·L-12). -->
<!-- ★가격 값(unit_price)은 전사하지 않음 — 연결·차원·격자완전성까지만(D-18·값=evaluate_price). -->

# product-144 하위 노드 (미니보드스탠딩 — 실사 고정가형 전용 마스터 + GAP)

미니보드스탠딩(PRD_000144)이 여기 신설하는 것 = 사인/POP 카테고리 2종(★root 사인+POP leaf·병렬 사인 형제
공유 보증)·수량규칙·가격공식·가격구성요소(★실사 고정가형·131 형제·수량밴드 5 실충전)·GAP 4. 규격 사이즈
(A5/A4/A3)는 공유 축(axis/sizes·product-047)이 이미 소유해 재사용 참조만 한다(중복 mint 금지·L-3). 상품→축
연결(has_size·priced_by·has_qty_rule·in_category)은 [[product-144-mini-board-standing]]가 건다. 판형
(plate_size)은 실사 비종이류라 노드 없음(파일사양 placeholder·junction del_yn=Y·pack §3.8·T-7). 인쇄옵션
(도수)도 없음(실사 대형잉크젯 풀컬러·po=0). 자재·공정·CPQ 옵션그룹·제약규칙 0행(통가격 baked·nonspec_yn=N·
설계상 해당 없음).

## 전사표 (권위 = 라이브 스냅샷·스크립트 전사)

> 아래 표는 `_meta/scripts/transcribe_product_144.py`가 live-snapshot에서 결정론 전사(손전사 아님).
> `python3 transcribe_product_144.py` 재실행 시 동일 출력(멱등). JSON 캐시=`cache/transcribed-144-260703.json`.

<!-- transcribed-by: _meta/scripts/transcribe_product_144.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_categories+t_cat_categories PRD_000144 @ 2026-07-03 -->
| cat_cd | 분류명 | 상위 | lvl | main_cat_yn |
|---|---|---|---|---|
| CAT_000097 | POP | CAT_000005 | 2 | N |
| CAT_000005 | 사인 | - | 1 | Y |

<!-- transcribed-by: _meta/scripts/transcribe_product_144.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_sizes+t_siz_sizes PRD_000144 @ 2026-07-03 -->
| siz_cd | 라벨 | 작업(work mm) | master_del_yn | junction_del_yn |
|---|---|---|---|---|
| SIZ_000170 | A5(148x210mm) | 148x210 | Y | N |
| SIZ_000172 | A4(210x297mm) | 210x297 | N | N |
| SIZ_000174 | A3(297x420mm) | 297x420 | N | N |

자재(t_prd_product_materials) 활성 행수 = 0 (★소재 미등록·완제품 통가격 baked[출력+코팅+가공(보드접착+거치대)]·pack §3.5 보드/우드 5상품 L1 빈값 AMBIGUOUS·GAP)
공정(t_prd_product_processes) 활성 행수 = 0 (★보드접착·거치대 가공이 통가격 baked·별도 공정 미등록·pack §3.6)
인쇄옵션(t_prd_product_print_options) 행수 = 0 (실사 도수 없음·대형 잉크젯 풀컬러·pack §3.3)
옵션그룹(t_prd_product_option_groups) 행수 = 0 · 제약(t_prd_product_constraints) = 0 · 추가상품(t_prd_product_addons) = 0 · 셋트부모(t_prd_product_sets) = 0 · bundle_qtys = 0 (★전부 0행·CPQ 미적재 BATCH-6·수량 UI=상품레벨)

<!-- transcribed-by: _meta/scripts/transcribe_product_144.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_plate_sizes (★전 행 output_paper_typ 공란=파일사양 placeholder·junction del_yn=Y 논리삭제·비종이류 판형 무의미·pack §3.8·T-7) PRD_000144 @ 2026-07-03 -->
| siz_cd | 라벨 | 용도 | junction_del_yn |
|---|---|---|---|
| SIZ_000007 | 148x210 | JPG 파일사양(판형 아님) | Y |
| SIZ_000050 | A4 (210X297) | JPG 파일사양(판형 아님) | Y |
| SIZ_000052 | A3 (297X420mm) | JPG 파일사양(판형 아님) | Y |

<!-- transcribed-by: _meta/scripts/transcribe_product_144.py from live-snapshot/latest (snap_20260702_1119) t_prd_products PRD_000144 @ 2026-07-03 -->
| 항목 | 값 |
|---|---|
| prd_nm | 미니보드스탠딩 |
| prd_typ_cd | PRD_TYPE.01 |
| nonspec_yn(★N=사용자입력 없음) | N |
| min_qty | 1 |
| max_qty | 10000 |
| qty_incr | 1 |
| qty_unit | QTY_UNIT.01 |
| use_yn | Y |
| del_yn | N |
| file_upload | Y |
| editor | N |

<!-- transcribed-by: _meta/scripts/transcribe_product_144.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_price_formulas+t_prc_formula_components+t_prc_price_components PRD_000144 @ 2026-07-03 -->
| frm_cd | 상품 바인딩 | comp_cd(배선) | prc_typ_cd | comp_typ_cd | use_dims |
|---|---|---|---|---|---|
| PRF_POSTER_MINI_STANDBOARD | True | COMP_POSTER_MINI_STANDBOARD | PRICE_TYPE.01 | PRC_COMPONENT_TYPE.06 | [siz_cd, min_qty] |

<!-- transcribed-by: _meta/scripts/transcribe_product_144.py from live-snapshot/latest (snap_20260702_1119) t_prc_component_prices COMP_POSTER_MINI_STANDBOARD (★고정가 SHAPE·수량밴드 존재·값 미전사) @ 2026-07-03 -->
| comp_cd | 차원(use_dims) | 규격셀수 | siz 셀 | 수량밴드수 | 수량밴드 하한 | 단가행수 | 격자완전 | 수량축충전 | 규격=가격셀 정합 |
|---|---|---|---|---|---|---|---|---|---|
| COMP_POSTER_MINI_STANDBOARD | siz_cd×min_qty | 3 | SIZ_000170,SIZ_000172,SIZ_000174 | 5 | 4 | 15 | True | True | True |

> **격자완전(grid_full)=True** = 규격 3셀(A5·A4·A3) × 수량 5밴드 = 15행이 이 빠짐 없이 채워짐(미적재 셀 0).
> **규격=가격셀 정합=True**: 상품 등록 규격 3행(SIZ_000170/172/174)이 고정가 단가표 3규격 셀과 정확히 일치.
> ★**수량축충전=True**(★131과 다른 점): 3규격 모두 수량 5밴드(하한 4/19/49/99/10000·코드값만 전사·단가
> 미전사) → 수량구간 할인 있음. 총액=규격×해당 수량밴드 통가격. 값=evaluate_price(D-18).
> ★**면적매트릭스와 다름**: siz_width×siz_height 순서쌍이 아니라 등록 규격(siz_cd) 키 룩업 → off-grid
> ceiling·비대칭 개념 없음(nonspec_yn=N).
> ★**밴드 하한(4) ≠ 상품 min_qty(1)**: 수량 1~3 가격 밴드 명시 부재 → [[#gap-144-qty-band-floor]](수량 UI
> 권위=상품레벨·가격구간과 역할 분리·pack §3.4·폴백 거동 미확증).

## 사이즈 (재사용 참조 — 공유 축 owner·중복 mint 금지)

★**consolidation 정합:** 144 규격은 전부 다른 파일이 이미 소유하므로 144는 **재사용 참조만**(L-3 중복 mint
금지)·has_size 프론트매터 엣지는 유지(target 실재):
- `size-SIZ_000170`(A5 148x210) = **공유 [axis/sizes.md](../axis/sizes.md) owner** — ★**양면 defect**
  (master del_yn=Y 06-17 논리삭제 · junction 활성). 052 스티커에 이어 **144가 SIZ_000170의 또 다른 활성
  참조자**이며 고정가 단가표에 A5 5밴드가 실재한다(defect 보강·양면 어느 쪽도 삭제 금지·정리 워크리스트).
  144는 재정의하지 않고 참조만(공유 노드 소유권=axis/sizes).
- `size-SIZ_000172`(A4 210x297) = **product-047(소량전단지) owner**(재사용·A계열 공용).
- `size-SIZ_000174`(A3 297x420) = **product-047(소량전단지) owner**(재사용·A계열 공용·131도 재사용).

실사 사이즈 = 이산 등록 규격 SIZ(A5/A4/A3)만(nonspec_yn=N·연속범위 없음·pack §3.2). 판걸이수(UP수)는 종이류
파생값이라 실사 무의미(판형 절). 고정가 단가는 규격(siz_cd)×수량밴드(min_qty) 키로 저장(면적
siz_width/siz_height 아님·가격 구성요소 절).

---

## 카테고리 (category) — 사인 root + POP leaf (★needed_shared·병렬 사인 형제 공유)

★**consolidation 정합:** 144는 `category-CAT_000005`(사인 root·main_cat_yn=Y=대표분류)와
`category-CAT_000097`(POP leaf·상위 사인)에 동시 귀속한다.
- `category-CAT_000005`(사인 root·cat_lvl 1) = **병렬 형제 product-142/143(아크릴스티커)이 선점 정의**한 공유
  노드다(build-report L-3). 144는 **재정의하지 않고 재사용 참조만** 한다(L-3 중복 방지). in_category 엣지는
  [[product-144-mini-board-standing]]가 걸며 target(142/143 정의)이 실재해 링크는 해소된다. 단일 소유권은
  consolidation 소관(needed_shared 반환·[[axis/categories]] 승격 대기).
- `category-CAT_000097`(POP leaf) = 아래 여기 정의(타 빌더 미정의·144 등록 leaf·node 실재 보증). 아무도
  정의 안 하면 I-2 끊긴 링크(더 나쁨)라 144가 실재 노드를 보증한다(needed_shared).

### [category-CAT_000097] POP (실사 leaf·cat_lvl 2·상위 사인·144 등록 분류·★needed_shared) {verified}
- type: category
- anchor: t_cat_categories/CAT_000097
- src: {source_file: "live-snapshot/latest/t_cat_categories.csv", source_locator: "테이블:t_cat_categories 키:CAT_000097 cat_nm=POP·cat_lvl=2·upr_cat_cd=CAT_000005·use_yn=Y·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_categories.csv", source_locator: "테이블:t_prd_product_categories 키:(PRD_000144,CAT_000097) main_cat_yn=N·144 등록 leaf 분류", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {cat_lvl: 2, upr_cat_cd: "CAT_000005", main_cat_yn_for_144: "N", 공유귀속: "POP 스탠딩류 실사 leaf(사인 CAT_000005 하위·consolidation dedupe 대상)"}
- 본문: POP(Point Of Purchase) 스탠딩류 실사 leaf(사인 CAT_000005 하위). 소재·완성형태(보드+거치대 스탠딩)가 상품 정체를 가르는 실사 특성(pack §0 특성1)이 카테고리에 반영. ★병렬 형제 다중귀속 공유 노드(needed_shared·단일 소유권은 consolidation 소관·[[axis/categories]] 승격 대기).

---

## 수량규칙 노드 (product-local)

### [qty-144] 미니보드스탠딩 수량규칙 {verified}
- type: bundle_qty
- anchor: t_prd_products/PRD_000144
- src: {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "키:PRD_000144 min_qty/max_qty/qty_incr(1/10000/1)·qty_unit_typ_cd=QTY_UNIT.01", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/_foundation/batch/qty_rule_audit_260702.py", source_locator: "수량 UI 권위=상품/사이즈 규칙(가격구간과 역할 분리)", captured_at: "2026-07-03", badge: verified, src_id: SR-27-qtyaudit}
- props: {min_max_incr_ref: "전사표 수량규칙(상품 1/10000/1)", bdl_unit_typ_cd: "QTY_UNIT.01", bundle_qtys_rows: 0, note: "★131과 달리 고정가 단가표 수량축이 5밴드 실충전(하한 4/19/49/99/10000·수량구간 할인 있음). 상품 수량규칙(min1)은 UI 권위·가격 밴드 하한(4)과 역할 분리(pack §3.4). 밴드 하한≠min_qty=[[#gap-144-qty-band-floor]]"}
- 본문: 수량 그릇 = 상품 마스터 컬럼(min 1·max 10000·incr 1). t_prd_product_bundle_qtys 0행 정상(수량 UI 권위=상품 레벨·[[rule/decisions#DEC_qty_audit_260702]]). 가격은 규격×수량밴드 통가격(수량구간 할인 존재·값=evaluate_price).

---

## 가격공식·구성요소 (★실사 고정가형·131 형제·수량밴드 실충전 — 상품-local mint·needed_shared_node)

실사 = 2 가격모델 공존(pack §3.10). 118·125 등은 **면적매트릭스형**(포스터사인 [가로×세로] 셀단가)이고,
144는 **고정가형**(등록 규격 siz_cd 키 룩업·★수량축 5밴드 실충전). 디지털 원자합산(PRF_DGP_*)·면적매트릭스
(PRF_POSTER_CANVAS 등)·스티커 고정룩업(PRF_STK_FIXED)·131 고정가(수량 단일밴드)와 구별되는 **실사 고정가
[수량×규격] 아키타입**(pack §3.10 "고정가 15상품 수량축 보유")을 여기 신설(실사 고정가 15상품 향후 승격 후보).

### [formula-PRF_POSTER_MINI_STANDBOARD] 미니보드스탠딩 완제품가(면적/규격 단가) {verified}
- type: price_formula
- anchor: t_prc_price_formulas/PRF_POSTER_MINI_STANDBOARD
- src: {source_file: "live-snapshot/latest/t_prc_price_formulas.csv", source_locator: "테이블:t_prc_price_formulas 키:PRF_POSTER_MINI_STANDBOARD frm_nm='미니보드스탠딩 완제품가(면적/규격 단가)'·note '포스터사인 미니보드스탠딩 소재/사이즈/수량별 완제품 통가격'·use_yn=Y", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prc_formula_components.csv", source_locator: "테이블:t_prc_formula_components 키:(PRF_POSTER_MINI_STANDBOARD,COMP_POSTER_MINI_STANDBOARD) disp_seq 1·addtn_yn=Y·1행", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_price_formulas.csv", source_locator: "키:(PRD_000144,PRF_POSTER_MINI_STANDBOARD) 바인딩", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: has_component, target: component-COMP_POSTER_MINI_STANDBOARD, qualifier: {disp_seq: 1, addtn: Y}, note: "고정가 완제품가(단일 구성요소·통가격[출력+코팅+가공(보드접착+거치대)])"}
- props: {archetype: "고정가형(fixed-price·siz_cd×수량밴드 룩업·use_dims=[siz_cd,min_qty])", use_yn: Y, note: "144 바인딩 전용 공식. 단일 구성요소(완제품 통가격)를 규격 siz_cd × 수량 min_qty 셀에서 조회(evaluate_price). ★131(수량 단일밴드)과 달리 수량축 5밴드 실충전. 면적매트릭스 아님(가로×세로 순서쌍 없음)"}
- 본문: 미니보드스탠딩 가격공식. 단일 구성요소(완제품 통가격) 1건 배선 — 인쇄·용지·코팅·가공(보드접착+거치대)을 원자 합산하지 않고 등록 규격(siz_cd)×수량밴드(min_qty)별 완제품 통가격을 조회한다. 고아 공식 아님(has_component 1개·O6 통과). 배선 타깃 [[component-COMP_POSTER_MINI_STANDBOARD]]. ★118(면적매트릭스)와 달리 use_dims=[siz_cd,min_qty]라 off-grid ceiling·비대칭이 없다(등록 규격 키 룩업). 값 계산=evaluate_price 권위(D-18·[[rule/rules#RULE_price_value_boundary]]).

### [component-COMP_POSTER_MINI_STANDBOARD] 미니보드스탠딩 완제품가 (고정가 siz_cd×수량밴드 셀) {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_POSTER_MINI_STANDBOARD
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "테이블:t_prc_price_components 키:COMP_POSTER_MINI_STANDBOARD comp_nm='미니보드스탠딩 완제품가'·comp_typ_cd=PRC_COMPONENT_TYPE.06(완제품비)·prc_typ_cd=PRICE_TYPE.01·use_dims=[siz_cd,min_qty]·note '포스터·사인 완제품가(소재+출력+가공 포함 통가격). 사이즈·수량별 단가표.'·use_yn=Y·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prc_component_prices.csv", source_locator: "테이블:t_prc_component_prices comp_cd=COMP_POSTER_MINI_STANDBOARD 15셀(siz_cd 3규격×수량 5밴드·값=전사표 SHAPE·D-22 접기·단가행 note '출력+코팅+가공(보드접착+거치대) 포함가')", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-dbmap/02_mapping/silsa-poster-area-matrix/mapping.md", source_locator: "문서:§1.1 고정가형 15상품([수량×규격] 블록·포스터사인·수량축 보유·승계·재검증 2026-07-03 — 면적매트릭스 13상품 아님)", captured_at: "2026-07-03", badge: verified, src_id: SR-13-silsa-mapping}
- props: {prc_typ_cd: "PRICE_TYPE.01", comp_typ_cd: "PRC_COMPONENT_TYPE.06", use_dims: '["siz_cd", "min_qty"]', role: "실사 POP 완제품 통가격(출력+코팅+가공(보드접착+거치대) 포함)·고정가 규격×수량밴드 룩업", 단가행_ref: "전사표 고정가 SHAPE(15셀=규격3×수량5·격자완전 True·수량축 충전 True·규격=가격셀 정합 True·밴드 하한 4)", archetype: "고정가형(fixed-price·siz_cd×수량밴드 룩업·off-grid 개념 없음)"}
- 본문: 실사 POP 완제품가 구성요소. use_dims 2축(규격 siz_cd × 수량 min_qty)으로 셀단가가 달라진다(차원 선언까지·D-22 단가행 접기). 규격 3셀(A5·A4·A3) × 수량 5밴드 = 15셀 완전격자(전사표 SHAPE). ★131 프레임리스우드액자(수량 단일밴드)와 달리 144는 수량축이 진짜 있어(5밴드) 수량구간 단가차가 존재한다. ★소재+출력+가공(보드접착+거치대)이 통가격에 baked라 자재 미등록([[#gap-144-material-absent]])·거치대 부속 미분해([[#gap-144-stand-attribution]])와 정합. 값=evaluate_price(값·골든 미전사·D-18·[[rule/rules#RULE_price_value_boundary]]).

---

## 정직 GAP (원천 부재·미결·AMBIGUOUS)

### [gap-144-material-absent] 보드/출력물 본체 소재 미등록 (통가격 baked·pack §3.5) {unknown}
- type: gap
- anchor: none  # 사유: t_prd_product_materials 144 행 0개 — 보드/출력물 소재를 자재로 등록할지 통가격 baked로 둘지 미결(원본 미명시·AMBIGUOUS)
- src: {source_file: "live-snapshot/latest/t_prd_product_materials.csv", source_locator: "테이블:t_prd_product_materials PRD_000144 활성 행수 0(전사표)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "§3.5 보드/우드 5상품 소재 L1 빈값(원본 미명시 정당·AMBIGUOUS)·C-04 자재유형", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-silsa}
- gap_what: "미니보드스탠딩 본체(출력물+보드+거치대)의 자재가 t_prd_product_materials에 0행이다. 완제품가 note가 '출력+코팅+가공(보드접착+거치대) 포함 통가격'이라 소재비가 통가격에 baked된 것으로 보이나, 보드/출력물을 별도 자재(parent+usage_cd)로 등록해야 하는지 통가격 baked로 두는 게 정답인지 원본(L1)에 미명시"
- gap_fill_from: "실무진(보드/우드 5상품 소재 정책·pack §3.5) + L1 원본 자재 셀 확인. 통가격 baked면 자재 미등록이 정당, 별도 등록이 필요하면 dbmap 트랙(인간 승인)"
- gap_owner: staff
- rel: {rel: references, target: product-144-mini-board-standing, note: "자재 0행 상품(통가격 baked 추정)"}
- rel: {rel: references, target: component-COMP_POSTER_MINI_STANDBOARD, note: "출력+코팅+가공(보드접착+거치대) 포함 통가격(자재비 baked)"}
- 본문: 가격 경로는 연결됨(priced_by→formula→component·15셀 완전격자)이라 견적 0 위험 없음. 이 GAP은 '보드/출력물을 자재로 명시할지'가 원본 미명시라 정직 선언(자재 날조 금지·IMPORT 자재 삭제 금지 원칙과 별개·[[rule/rules#RULE_import_material_no_delete]]).

### [gap-144-stand-attribution] 거치대 귀속 — 공정(통가격 baked) vs 부속(거치대 별매) (GAP-SL-4·pack §3.12) {unknown}
- type: gap
- anchor: none  # 사유: 미니보드스탠딩의 거치대(스탠딩 홀더)가 상품 완성 공정(통가격 baked)인지 부속(별매 addon/set)인지 미결(pack §3.12 부속 귀속 AMBIGUOUS)
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "§3.12 부속붙는 8상품(거치대 포함)·부속 귀속 AMBIGUOUS·[GAP-SL-4]·Q-SL-4·거치대=PRD_000012 우드거치대 후보", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-silsa}
- src: {source_file: "live-snapshot/latest/t_prd_product_addons.csv", source_locator: "테이블:t_prd_product_addons PRD_000144 행 0개(sets도 0행·부속 미연결)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- gap_what: "미니보드스탠딩의 '거치대(스탠딩 홀더)'가 완제품가 note상 통가격에 baked(출력+코팅+가공(보드접착+거치대))라 현재는 단품 통가격 상품이나, 이 거치대가 상품 완성 공정(baked)인지 별매 부속(addon/set·PRD_000012 우드거치대류 재연결)인지 미결. addon=0·set=0이라 현재는 통가격 단일 상품이나, pack §3.12는 거치대류 부속 귀속을 AMBIGUOUS로 남김(형제 136/137 PET/메쉬배너의 우드거치대 재연결 후보와 대비)"
- gap_fill_from: "실무진 Q-SL-4(거치대=공정 baked vs 부속). 부속이면 거치대 PRD/자재 재연결(search-before-mint·라이브 addon/set 인간 승인), 공정이면 통가격 baked 정당"
- gap_owner: staff
- rel: {rel: references, target: product-144-mini-board-standing, note: "거치대 귀속 미결 상품(addon/set 0행·거치대 baked)"}
- 본문: addon/set 0행이 결함인지 정당인지는 거치대 귀속 판정에 달렸다. 통가격 단일 상품으로 보면 정당, 거치대 별매 모델이면 부속 미연결이 잔존 결함. pack §3.12가 미결로 남긴 AMBIGUOUS를 그대로 정직 선언(단정 금지·GAP-SL-4).

### [gap-144-qty-band-floor] 수량 밴드 하한(4) ≠ 상품 min_qty(1) — 수량 1~3 가격 밴드 부재 {unknown}
- type: gap
- anchor: none  # 사유: 고정가 단가표 최저 수량밴드 하한=4인데 상품 min_qty=1 — 수량 1~3 구간 가격 밴드 명시 부재·evaluate_price 폴백 거동 미확증
- src: {source_file: "live-snapshot/latest/t_prc_component_prices.csv", source_locator: "테이블:t_prc_component_prices COMP_POSTER_MINI_STANDBOARD 수량밴드 하한 4/19/49/99/10000(전사표·최저 밴드=4)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "§3.4 수량 UI 권위=상품/사이즈 수량규칙·가격구간과 역할 분리·제안 min=max(권위,가격표구간)", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-silsa}
- gap_what: "상품 min_qty=1(전사표)인데 고정가 단가표 최저 수량밴드 하한=4다. 수량 1~3 구간의 가격 밴드가 명시 부재라, evaluate_price가 이 구간을 최저 밴드(4)로 폴백하는지 견적 불가인지 확증 원천이 없다(가격 UI 권위=상품레벨 min1 vs 가격구간 하한 4의 역할 분리)"
- gap_fill_from: "실무진(수량 1~3 처리 정책) + pricing.py evaluate_price 밴드 폴백 로직(§27 배선/§26 무결성 트랙·인간 승인). 제안 min=max(권위,가격표구간) 선례(qty_rule_audit_260702)면 상품 min_qty를 4로 상향할지 검토 대상"
- gap_owner: staff
- rel: {rel: references, target: qty-144, note: "상품 min_qty=1 vs 가격 밴드 하한 4"}
- rel: {rel: references, target: component-COMP_POSTER_MINI_STANDBOARD, note: "최저 수량밴드 하한=4(수량 1~3 밴드 부재)"}
- 본문: 가격 경로는 연결됨(15셀 완전격자)이라 수량 4 이상 견적은 정상. 이 GAP은 수량 1~3의 가격 밴드가 명시 부재라 evaluate_price 폴백 거동이 미확증인 것의 정직 선언(단정 금지·값 계산은 엔진 권위·D-18). 온톨로지는 차원·격자완전성까지, 폴백 거동은 §26/§27 트랙 소관.

### [gap-144-price-basis] 고정가 완제품가 산정 근거 문서 부재 (엑셀 미기재 암묵지) {unknown}
- type: gap
- anchor: none  # 사유: 규격×수량밴드별 통가격이 어떤 원가/마진 규칙으로 도출됐는지 어느 엑셀/문서에도 명시 없음(암묵지)
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/source-registry.md", source_locator: "문서:§9 GAP-2 롤/소재 가격 계산 로직(엑셀 미기재 암묵지·실사 전체 영향)", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-silsa}
- src: {source_file: "live-snapshot/latest/t_prc_component_prices.csv", source_locator: "테이블:t_prc_component_prices COMP_POSTER_MINI_STANDBOARD 15셀(규격×수량밴드별 통가격·값 적재됨·산정근거 문서 부재)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- gap_what: "규격(A5·A4·A3)×수량밴드(4~10000)별 미니보드스탠딩 완제품 통가격이 출력/보드/거치대 원가·가공비 어떤 규칙으로 도출됐는지 — 값은 라이브에 적재됐으나(15셀) 산정 근거 문서 부재"
- gap_fill_from: "실무진 확인(source-registry §9 GAP-2·실사 전체 영향). 예전사이트 골든 대조로 값 정합 검증 가능하나 산정식 자체는 암묵지"
- gap_owner: staff
- rel: {rel: references, target: component-COMP_POSTER_MINI_STANDBOARD, note: "고정가 15셀(산정 근거 문서 부재)"}
- 본문: 가격 경로는 연결됨([[formula-PRF_POSTER_MINI_STANDBOARD]]→[[component-COMP_POSTER_MINI_STANDBOARD]]·15셀 완전격자)이라 견적 0 위험 없음. 다만 통가격이 **어떻게** 산정됐는지는 엑셀 미기재 암묵지(실사 전체 공통 GAP). 온톨로지는 연결·차원까지, 값 계산은 evaluate_price 권위이므로 이 GAP은 값 정합이 아니라 "산정 근거 문서 부재"의 정직 선언.
