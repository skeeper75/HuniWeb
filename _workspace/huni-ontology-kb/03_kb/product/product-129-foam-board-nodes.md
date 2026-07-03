<!-- product-local sub-nodes: E2 category·E4 material·E6 process·E8 bundle_qty·E9 price_formula·E10 price_component·E11 option_group·gap for PRD_000129 폼보드(실사 ★고정가형 파일럿 첫 상품). -->
<!-- ★실사 고정가형 첫 상품이라 공유 axis(materials/categories/processes)·formula 파일에 폼보드 노드가 아직 없다 — 공유 축 파일 수정 금지 규칙 때문에 여기 임시 거처(118/126 선례). 축 소유자 승격 시 canonical id 그대로 이관 — index_entries/needed_shared로 반환. -->
<!-- ★수치(치수·격자 coverage·자재명)는 아래 전사표(transcribed-by·transcribe_product_129.py)에만. props raw 미기입(D-9·L-12). -->
<!-- ★가격 값(unit_price)은 전사하지 않음 — 연결·차원·격자 coverage(엇갈림)까지만(D-18·값=evaluate_price). -->
<!-- ★재사용(재정의 금지·L-3): category-CAT_000004(119-nodes)·size-SIZ_000315/SIZ_000198(118-nodes)·process-PROC_000115/PROC_000116(118-nodes). 아래는 129 전용 신규 mint만. -->

# product-129-foam-board 하위 노드 (폼보드 PRD_000129 전용 축 원자)

폼보드(PRD_000129) 전용 신규 mint = 자재 4(보드)·공정 1(실사가공)·수량규칙 1·가격공식 1·
가격구성요소 1(동형결합)·옵션그룹 2·GAP 4. 재사용 축(포스터/보드액자 카테고리·A3/A2 사이즈·
유광/무광코팅)은 118/119/134 등 병렬 companion이 canonical 소유(재정의 안 함·L-3 회피).
상품→축 연결은 [[product-129-foam-board]]가 건다.

## 치수·자재·공정·수량·고정가격자 전사표 (권위 = 라이브 마스터·고정가형(fixed-lookup·use_dims=[mat_cd,siz_cd]))

<!-- transcribed-by: _meta/scripts/transcribe_product_129.py from live-snapshot/latest (snap_20260702_1119) t_siz_sizes PRD_000129 @ 2026-07-03 -->

**사이즈(이산 규격·nonspec_yn=N — 자유치수 없음)**

| siz_cd | siz_nm | 작업(가로×세로) | 링크 del |
|---|---|---|---|
| SIZ_000315 | A3 (297x420mm) | 297×420 | N |
| SIZ_000198 | A2 (420X594mm) | 420×594 | N |
| SIZ_000174 | A3(297x420mm) | (구 코드) | Y(07-01 재키잉) |
| SIZ_000197 | A2(420x594mm) | (구 코드) | Y(07-01 재키잉) |

<!-- transcribed-by: _meta/scripts/transcribe_product_129.py from live-snapshot/latest (snap_20260702_1119) t_mat_materials PRD_000129 @ 2026-07-03 -->

**자재(보드 4종 = 색상 2 × 규격 2·자재명에 사이즈 내장·MAT_TYPE.16 실사부자재)**

| mat_cd | mat_nm | mat_typ | del |
|---|---|---|---|
| MAT_000398 | A3 폼보드(화이트) 5mm | MAT_TYPE.16 | N |
| MAT_000399 | A3 폼보드(블랙) 5mm | MAT_TYPE.16 | N |
| MAT_000612 | A2 폼보드(화이트) 5mm | MAT_TYPE.16 | N |
| MAT_000613 | A2 폼보드(블랙) 5mm | MAT_TYPE.16 | N |

<!-- transcribed-by: _meta/scripts/transcribe_product_129.py from live-snapshot/latest (snap_20260702_1119) t_proc_processes PRD_000129 @ 2026-07-03 -->

**공정(활성 = 유광/무광코팅 + 실사가공·구 라미네이팅 논리삭제)**

| proc_cd | proc_nm | 상위 | 상태 |
|---|---|---|---|
| PROC_000115 | 유광코팅 | PROC_000114 | 활성(del_yn=N) |
| PROC_000116 | 무광코팅 | PROC_000114 | 활성(del_yn=N) |
| PROC_000135 | 실사가공 | PROC_000083 | 활성(del_yn=N) |
| PROC_000014 | 유광라미네이팅 | — | 구 라미(product del_yn=Y·07-01 교체) |
| PROC_000015 | 무광라미네이팅 | — | 구 라미(product del_yn=Y·07-01 교체) |

<!-- transcribed-by: _meta/scripts/transcribe_product_129.py from live-snapshot/latest (snap_20260702_1119) t_prd_products PRD_000129 @ 2026-07-03 -->

**수량규칙(제품 레벨):** min=1 · max=10000 · incr=1 · 단위=QTY_UNIT.01 · nonspec_yn=N

<!-- transcribed-by: _meta/scripts/transcribe_product_129.py from live-snapshot/latest (snap_20260702_1119) t_prc_component_prices COMP_POSTER_FOAMBOARD_BOARD(SHAPE·값 미전사) @ 2026-07-03 -->

**고정가 격자 SHAPE (구성요소 COMP_POSTER_FOAMBOARD_BOARD·use_dims=[mat_cd,siz_cd]·값 미전사·D-18):**

- 단가행 실재 조합 **4개**(대각선): (SIZ_000198,MAT_000612) · (SIZ_000198,MAT_000613) · (SIZ_000315,MAT_000398) · (SIZ_000315,MAT_000399)
- 상품제공 자재 4 × 사이즈 2 = naive **8조합**
- ★단가행 부재(엇갈림·대각선-밖) **4조합**: (SIZ_000198,MAT_000398) · (SIZ_000198,MAT_000399) · (SIZ_000315,MAT_000612) · (SIZ_000315,MAT_000613)
- 옵션 보드칼라 참조 자재(OPT_REF_DIM.03) = ['MAT_000398', 'MAT_000399'] (★A3 자재만 배선·A2 자재 미배선)

> ★해석(엇갈림·CN-2·§31 판례 P-1): 자재명에 사이즈 내장(A3/A2 전용 mat) → 격자는 (A3siz×A3mat)·(A2siz×A2mat) 대각선 4셀만 단가행. 옵션 보드칼라가 A3 자재(398/399)만 참조하므로 **사이즈=A2 선택 시 (A2siz, A3mat) 대각선-밖 조합 → 단가행 부재 → 견적 0 위험**. 가격 값은 전사 안 함(evaluate_price 권위). 이 표는 격자 coverage(구조)만.

## 재사용 축 (★재정의 금지 — canonical 소유 명시)

> ★[[product-129-foam-board]]가 아래 노드를 relations로 재사용(L-3 중복 방지). 여기서 재정의하지 않는다:
> - **category-CAT_000004** 포스터(root) = [[product-119-artpaper-poster-nodes#category-CAT_000004]] canonical.
> - **category-CAT_000080** 보드액자(leaf·cat_lvl=2·upr=CAT_000004) = 병렬 실사 보드/액자 빌더(134 린넨우드봉족자 등)가 canonical 소유 — 129는 재정의 안 하고 in_category로 재사용(L-3 중복 회피·2026-07-03 build에서 130/131/132/134 중복 mint 적발→재사용 전환). 카테고리 고아 해소(CAT_000298 del_yn=Y·pack §1.1·T-1) 사실은 canonical 노드가 보유.
> - **size-SIZ_000315** A3·**size-SIZ_000198** A2 = [[product-118-artprint-poster-nodes]] canonical(규격 preset).
> - **process-PROC_000115** 유광코팅·**process-PROC_000116** 무광코팅 = [[product-118-artprint-poster-nodes]] canonical.
> 공유 axis 파일 승격 시 이 재사용 노드 + 아래 129 mint를 함께 이관(needed_shared).

## 자재 노드 (폼보드 4종·MAT_TYPE.16 실사부자재)

### [material-MAT_000398] A3 폼보드(화이트) 5mm {verified}
- type: material
- anchor: t_mat_materials/MAT_000398
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "키:MAT_000398(mat_nm=A3 폼보드(화이트) 5mm·mat_typ_cd=MAT_TYPE.16·upr_mat_cd=MAT_000004·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_materials.csv", source_locator: "키:(PRD_000129,MAT_000398) usage_cd=USAGE.07 dflt_yn=N disp_seq=1 del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_cd: "MAT_000398", mat_nm_ref: "전사표 MAT_000398", mat_typ_cd: "MAT_TYPE.16", usage_cd: "USAGE.07", note: "★MAT_TYPE.16 실사부자재(현재값=정답·06-26 신설 코드·레더 .05/.08 crosscut과 무관·양면 불요). 자재명에 사이즈(A3)+색상(화이트)+두께(5mm) 내장 → 가격 격자 대각선 축([[gap-129-matsize-mismatch]]). 보드칼라 옵션 참조대상(OPV-000092)"}
- 본문: A3 화이트 폼보드 5mm([[product-129-foam-board]] uses_material). 낱장 완제품 단일 슬롯(USAGE.07). 공유 axis/materials.md 미등재·승격 대기(needed_shared).

### [material-MAT_000399] A3 폼보드(블랙) 5mm {verified}
- type: material
- anchor: t_mat_materials/MAT_000399
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "키:MAT_000399(mat_nm=A3 폼보드(블랙) 5mm·mat_typ_cd=MAT_TYPE.16·upr_mat_cd=MAT_000004·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_materials.csv", source_locator: "키:(PRD_000129,MAT_000399) usage_cd=USAGE.07 dflt_yn=N disp_seq=2 del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_cd: "MAT_000399", mat_nm_ref: "전사표 MAT_000399", mat_typ_cd: "MAT_TYPE.16", usage_cd: "USAGE.07", note: "A3 블랙 폼보드 5mm. 보드칼라 옵션 참조대상(OPV-000093). MAT_TYPE.16 실사부자재(현재값=정답)"}
- 본문: A3 블랙 폼보드 5mm([[product-129-foam-board]] uses_material). 공유 axis 미등재·승격 대기(needed_shared).

### [material-MAT_000612] A2 폼보드(화이트) 5mm {verified}
- type: material
- anchor: t_mat_materials/MAT_000612
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "키:MAT_000612(mat_nm=A2 폼보드(화이트) 5mm·mat_typ_cd=MAT_TYPE.16·upr_mat_cd=MAT_000004·use_yn=Y·del_yn=N·07-01 신설)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_materials.csv", source_locator: "키:(PRD_000129,MAT_000612) usage_cd=USAGE.07 dflt_yn=N disp_seq=3 del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_cd: "MAT_000612", mat_nm_ref: "전사표 MAT_000612", mat_typ_cd: "MAT_TYPE.16", usage_cd: "USAGE.07", note: "A2 화이트 폼보드 5mm. ★단가행에는 (A2siz×MAT_000612) 대각선 셀 존재(전사표)이나 보드칼라 옵션 미참조(A3 자재만 배선)=엇갈림([[gap-129-matsize-mismatch]])"}
- 본문: A2 화이트 폼보드 5mm([[product-129-foam-board]] uses_material). 격자 대각선 셀은 있으나 옵션 미배선(엇갈림). 공유 axis 미등재·승격 대기(needed_shared).

### [material-MAT_000613] A2 폼보드(블랙) 5mm {verified}
- type: material
- anchor: t_mat_materials/MAT_000613
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "키:MAT_000613(mat_nm=A2 폼보드(블랙) 5mm·mat_typ_cd=MAT_TYPE.16·upr_mat_cd=MAT_000004·use_yn=Y·del_yn=N·07-01 신설)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_materials.csv", source_locator: "키:(PRD_000129,MAT_000613) usage_cd=USAGE.07 dflt_yn=N disp_seq=4 del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_cd: "MAT_000613", mat_nm_ref: "전사표 MAT_000613", mat_typ_cd: "MAT_TYPE.16", usage_cd: "USAGE.07", note: "A2 블랙 폼보드 5mm. 단가행 (A2siz×MAT_000613) 존재이나 보드칼라 옵션 미참조=엇갈림([[gap-129-matsize-mismatch]])"}
- 본문: A2 블랙 폼보드 5mm([[product-129-foam-board]] uses_material). 공유 axis 미등재·승격 대기(needed_shared).

## 공정 노드 (실사가공 — 축 승격 대기)

### [process-PROC_000135] 실사가공 (보드 가공·mand N) {verified}
- type: process
- anchor: t_proc_processes/PROC_000135
- src: {source_file: "live-snapshot/latest/t_proc_processes.csv", source_locator: "키:PROC_000135(proc_nm=실사가공·upr_proc_cd=PROC_000083 가공·disp_seq=2·use_yn=Y·del_yn=N·06-29 신설)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_processes.csv", source_locator: "키:(PRD_000129,PROC_000135) mand_proc_yn=N disp_seq=2 del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {proc_cd: "PROC_000135", proc_nm: "실사가공", upr_proc_cd: "PROC_000083", mand_proc_yn: "N", note: "보드 가공(상위 PROC_000083 가공). 보드칼라 옵션 item(OPV-000092/093 item_seq2·OPT_REF_DIM.04)이 참조 — 보드 선택 시 실사가공 동반. 가격은 고정가 통가격에 포함(별도 원자합산 아님·pack §3.10)"}
- 본문: 실사(보드) 가공 공정([[product-129-foam-board]] has_process). 보드칼라 옵션이 참조(선택 동반). 공유 axis/processes.md 미등재·승격 대기(needed_shared).

## 수량규칙 노드

### [qty-129] 폼보드 수량규칙 (제품 레벨) {verified}
- type: bundle_qty
- anchor: t_prd_products/PRD_000129
- src: {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "키:PRD_000129 min_qty=1·max_qty=10000·qty_incr=1·qty_unit_typ_cd=QTY_UNIT.01(전사표)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "§3.4 고정가 15상품 수량축·수량 UI 권위=상품/사이즈 수량규칙(가격구간과 역할 분리)", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-silsa}
- props: {min_qty: "1", max_qty: "10000", qty_incr: "1", qty_unit_typ_cd: "QTY_UNIT.01", note: "★t_prd_product_bundle_qtys 129 행 0 — 제품 레벨 규칙만. ★가격 구성요소 use_dims=[mat_cd,siz_cd]에 min_qty 없음 → 수량은 가격 차원 아님(총액=단가×수량·구간할인 없음). 공식명 '수량별' vs 격자 수량축 부재=[[gap-129-qty-band-absent]]"}
- 본문: 폼보드 주문 수량규칙(제품 레벨·1~10000)([[product-129-foam-board]] has_qty_rule). 수량 UI 권위이며 가격구간(격자)과 역할 분리(pack §3.4).

## 가격공식 노드 (실사 고정가형)

### [formula-PRF_POSTER_FOAMBOARD] 폼보드 완제품가(면적/규격 단가) {verified}
- type: price_formula
- anchor: t_prc_price_formulas/PRF_POSTER_FOAMBOARD
- src: {source_file: "live-snapshot/latest/t_prc_price_formulas.csv", source_locator: "키:PRF_POSTER_FOAMBOARD(frm_nm=폼보드 완제품가(면적/규격 단가)·use_yn=Y·note 포스터사인 폼보드 소재/사이즈/수량별 완제품 통가격)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prc_formula_components.csv", source_locator: "frm_cd:PRF_POSTER_FOAMBOARD → comp COMP_POSTER_FOAMBOARD_BOARD(disp_seq=2·addtn_yn=Y) 1행", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-dbmap/02_mapping/silsa-poster-area-matrix/mapping.md", source_locator: "§5 고정가형 15상품(폼보드)·[수량×규격] 계열·BLOCKED-OUT-OF-SCOPE from 면적매트릭스", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-silsa}
- props: {frm_cd: "PRF_POSTER_FOAMBOARD", use_yn: "Y", archetype: "고정가형(fixed-lookup·소재/사이즈별 완제품 통가격)", note: "★frm_nm이 '면적/규격 단가'라 하나 실 아키타입=고정 룩업([mat_cd,siz_cd]·nonspec_yn=N·면적 가로×세로 아님). 값 계산=evaluate_price 권위(D-18)"}
- rel: {rel: has_component, target: component-COMP_POSTER_FOAMBOARD_BOARD, qualifier: {disp_seq: 2, addtn: "Y"}, note: "★[동형결합 260702] 보드칼라×사이즈 통합 구성요소(구 per-color COMP_POSTER_FOAMBOARD_WHITE/_BLACK은 use_yn=N 은퇴)"}
- 본문: 폼보드 고정가 완제품가 공식([[product-129-foam-board]] priced_by). has_component→[[component-COMP_POSTER_FOAMBOARD_BOARD]]. 고아 공식 아님(O6 충족). 공유 formula 파일 미등재·승격 대기(needed_shared).

## 가격구성요소 노드 (고정가 룩업·동형결합)

### [component-COMP_POSTER_FOAMBOARD_BOARD] 폼보드(보드칼라×사이즈) 완제품가 {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_POSTER_FOAMBOARD_BOARD
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_POSTER_FOAMBOARD_BOARD(comp_nm=폼보드(보드칼라×사이즈) 완제품가·comp_typ_cd=PRC_COMPONENT_TYPE.01·prc_typ_cd=PRICE_TYPE.01·use_dims=[mat_cd,siz_cd]·use_yn=Y·del_yn=N·07-01 신설)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prc_component_prices.csv", source_locator: "comp_cd:COMP_POSTER_FOAMBOARD_BOARD 단가행 4행(대각선 (siz,mat)·전사표 SHAPE·값 미전사·note '260527 verbatim')", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {comp_cd: "COMP_POSTER_FOAMBOARD_BOARD", prc_typ_cd: "PRICE_TYPE.01", use_dims: "[mat_cd, siz_cd]", note: "★[동형결합 260702] 구 per-color(COMP_POSTER_FOAMBOARD_WHITE/_BLACK·use_yn=N 은퇴)를 mat_cd 축으로 통합. 단가행 4행(대각선 완전·off-diag 4조합 부재=엇갈림·[[gap-129-matsize-mismatch]]). 값=인쇄상품 가격표 260527 verbatim(전사 안 함·D-22 접기·evaluate_price 권위). 포맥스보드130 COMP_POSTER_FOMEXBOARD_BOARD는 별 comp(미통합)"}
- 본문: 폼보드 고정가 룩업 구성요소([[formula-PRF_POSTER_FOAMBOARD]] has_component). use_dims=[mat_cd,siz_cd]·PRICE_TYPE.01. 단가행은 D-22 접기(노드 미전개·전사표 SHAPE가 격자 coverage 권위). 공유 formula 파일 미등재·승격 대기(needed_shared).

## 옵션그룹 노드 (CPQ 손님 선택 축)

### [optgroup-129-boardcolor] 보드칼라 (화이트/블랙 택1) {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000129
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "키:PRD_000129 opt_grp_cd:OPT-000045(보드칼라·SEL_TYPE.01·min_sel=1·max_sel=1·mand_yn=Y·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_options.csv", source_locator: "키:PRD_000129 OPT-000045 (OPV-000092 화이트보드(5mm)·dflt_yn=Y / OPV-000093 블랙보드(5mm))", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_option_items.csv", source_locator: "키:PRD_000129 (OPV-000092→MAT_000398[OPT_REF_DIM.03·ref_key2=USAGE.07]+PROC_000135[OPT_REF_DIM.04] / OPV-000093→MAT_000399+PROC_000135)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: option_refs, target: material-MAT_000398, ref_key1: MAT_000398, note: "화이트보드(OPV-000092)→자재(A3 화이트)"}
- rel: {rel: option_refs, target: material-MAT_000399, ref_key1: MAT_000399, note: "블랙보드(OPV-000093)→자재(A3 블랙)"}
- rel: {rel: option_refs, target: process-PROC_000135, ref_key1: PROC_000135, note: "보드칼라 item_seq2→실사가공 공정(보드 선택 동반)"}
- props: {opt_grp_cd: "OPT-000045", sel_typ_cd: "SEL_TYPE.01", mand_yn: "Y", 옵션값: "화이트보드/블랙보드(택1·5mm)", ref_dim: "OPT_REF_DIM.03=자재 + OPT_REF_DIM.04=실사가공", note: "★A3 자재(398/399)만 참조·A2 자재(612/613) 미참조 → 사이즈=A2 선택 시 격자 대각선-밖 → 견적0 위험([[gap-129-matsize-mismatch]])"}
- 본문: 손님이 보드 색상을 고르는 CPQ 옵션(택1·화이트/블랙). item이 자재(R11 option_refs·OPT_REF_DIM.03)+실사가공 공정을 가리켜 uses_material·has_process 차원으로 환원(L-18 통과·부모 129 실재). ★A3 자재만 배선한 엇갈림은 [[gap-129-matsize-mismatch]].

### [optgroup-129-coating] 코팅 (없음/무광/유광 택1) {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000129
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "키:PRD_000129 opt_grp_cd:OPT-000044(코팅·SEL_TYPE.01·min_sel=0·max_sel=1·mand_yn=N·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_options.csv", source_locator: "키:PRD_000129 OPT-000044 (OPV-000090 무광코팅 / OPV-000091 유광코팅)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_option_items.csv", source_locator: "키:PRD_000129 (OPV-000090→PROC_000116[OPT_REF_DIM.04 무광코팅] / OPV-000091 유광코팅=item 행 부재)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: option_refs, target: process-PROC_000116, ref_key1: PROC_000116, note: "무광코팅(OPV-000090)→공정"}
- props: {opt_grp_cd: "OPT-000044", sel_typ_cd: "SEL_TYPE.01", mand_yn: "N", 옵션값: "무광코팅/유광코팅(택1·선택)", ref_dim: "OPT_REF_DIM.04=공정", note: "코팅은 고정가 통가격에 포함(가격 미가산·MES 라우팅용). ★유광코팅(OPV-000091) item 참조행 부재=[[gap-129-glossy-coating-optref]]. 무광만 PROC_000116 참조 배선"}
- 본문: 손님이 코팅을 고르는 CPQ 옵션(택1·mand N). 무광 item이 공정 PROC_000116을 가리켜 has_process로 환원(L-18 통과). ★유광 item은 참조 공정 미배선(정직 표기·[[gap-129-glossy-coating-optref]]). 코팅비는 통가격 포함(별도 가산 아님).

## GAP 노드 (원천 부재·미확정 — 정직 선언)

### [gap-129-matsize-mismatch] 자재↔사이즈 엇갈림 (CN-2·대각선-밖 견적0 위험) {unknown}
- type: gap
- anchor: none  # 사유: 대각선-밖 조합 차단(제약) 또는 옵션 자재 사이즈연동이 라이브 미등록(스냅샷)·정답 배선 원천 미확정
- src: {source_file: "live-snapshot/latest/t_prc_component_prices.csv", source_locator: "comp_cd:COMP_POSTER_FOAMBOARD_BOARD 단가행 4(대각선)·상품제공 mat4×siz2=8조합 중 4조합(off-diag) 부재(전사표 SHAPE)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-constraint-rules/01_scenario/constraint-need-spec.md", source_locator: "판례 P-1 129/130 자재↔사이즈 엇갈림=CN-2 전형(mat4×siz2 8셀 중 4셀만·나머지 견적0·단가행 대각선 자동유도 권고)", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-silsa}
- gap_what: "폼보드 자재명에 사이즈 내장(A3 mat / A2 mat)이라 단가행은 (A3siz×A3mat)·(A2siz×A2mat) 대각선 4셀만 존재. 보드칼라 옵션은 A3 자재(398/399)만 참조 → 사이즈=A2 선택 시 (A2siz, A3mat) 대각선-밖 조합이 단가행 부재로 견적 0 가능. 라이브 스냅샷(20260702_1119) 시점 129 constraints=0행(엇갈림 차단 미등록)"
- gap_fill_from: "§31 constraint-rules 하네스(판례 P-1·단가행 존재 조합만 허용하는 CN-2 제약 자동유도) 또는 옵션 자재의 사이즈연동 배선(A2 선택 시 MAT_000612/613 참조). ★[HARD] evaluate_price는 제약 미참조 — 실 차단은 위젯/주문 validate. COMMIT은 인간 승인 후 §31/§7"
- gap_owner: staff
- rel: {rel: references, target: component-COMP_POSTER_FOAMBOARD_BOARD, note: "엇갈림이 발생하는 고정가 격자 구성요소(대각선 4셀)"}
- rel: {rel: references, target: optgroup-129-boardcolor, note: "A3 자재만 참조해 A2 사이즈 엇갈림 유발하는 옵션그룹"}
- 본문: 폼보드의 중심 결함 패턴(§31 판례 P-1). 자재모델링(사이즈 내장)이 근원이라 단가행 대각선만 존재하고 옵션이 A3 자재만 배선해 A2 사이즈에서 견적 0 위험. 지어내지 않고 GAP으로 등재 — 실 차단(제약)·배선 교정은 §31/개발 레인·인간 승인.

### [gap-129-qty-band-absent] 공식명 '수량별' vs use_dims 수량축 부재 {unknown}
- type: gap
- anchor: none  # 사유: 공식/구성요소가 '수량별' 통가격을 표방하나 use_dims에 min_qty 없음·권위 260527 수량축 유무 대조 원천 미확인
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_POSTER_FOAMBOARD_BOARD use_dims=[mat_cd,siz_cd](min_qty 없음) vs 공식 note '소재/사이즈/수량별'", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-dbmap/02_mapping/silsa-poster-area-matrix/mapping.md", source_locator: "§5 고정가형=[수량(행)×규격(A3/A2/A1 열)] 블록(수량축 보유)·pack §3.4 고정가 15상품 수량축", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-silsa}
- gap_what: "공식명·note가 '소재/사이즈/수량별 완제품 통가격'이라 하고 pack §3.4/mapping.md §5는 고정가형에 [수량×규격] 블록(수량축)이 있다고 하나, 라이브 구성요소 use_dims=[mat_cd,siz_cd]에 min_qty가 없다(수량 무관 단일 단가). 권위 260527 포스터사인 폼보드 블록에 수량 구간 단가가 있는데 라이브에 수량축이 미적재된 것인지, 폼보드가 실제 flat-per-unit인지 미확정"
- gap_fill_from: "권위 260527 포스터사인 폼보드 블록 수량축 대조(§26 무결성) + evaluate_price 실측(§21). 그 전까지 '수량 무관' 단정 금지"
- gap_owner: staff
- rel: {rel: references, target: component-COMP_POSTER_FOAMBOARD_BOARD, note: "수량축을 use_dims에 선언하지 않은 고정가 구성요소"}
- rel: {rel: references, target: qty-129, note: "제품 수량규칙(1~10000)은 있으나 가격 차원과 분리"}
- 본문: 고정가형 수량축 원칙(pack §3.4·mapping.md §5)과 라이브 use_dims(수량축 부재)가 어긋난다. 값 정합이 아니라 '권위 수량 구간이 적재됐는가'의 정직 GAP — 검증/무결성 레인 몫.

### [gap-129-glossy-coating-optref] 유광코팅 옵션값 참조공정 미배선 {unknown}
- type: gap
- anchor: none  # 사유: 유광코팅 옵션값(OPV-000091)의 option_item 참조행이 라이브 부재·의도(빠뜨림 vs 통가격 포함이라 불필요) 미확정
- src: {source_file: "live-snapshot/latest/t_prd_product_option_items.csv", source_locator: "키:PRD_000129 OPV-000090(무광)→PROC_000116 존재 vs OPV-000091(유광) item 행 부재", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- gap_what: "코팅 옵션의 유광코팅(OPV-000091)이 무광(→PROC_000116)과 달리 option_item 참조행이 없어 선택해도 공정(PROC_000115 유광코팅)으로 환원되지 않는다. 가격은 통가격 포함이라 영향 없으나 MES 라우팅/공정 지시 관점에서 유광 선택 시 공정 미연결"
- gap_fill_from: "실무진(유광 item→PROC_000115 배선 필요 여부) 또는 §31 옵션 배선 점검. 가격 무영향이라 우선순위 낮음"
- gap_owner: staff
- rel: {rel: references, target: optgroup-129-coating, note: "유광 item 참조 미배선 옵션그룹"}
- 본문: 유광코팅 옵션값이 참조 공정 미배선(무광은 배선됨). 가격 무영향(통가격 포함)이나 공정 환원 관점의 정직 GAP — 지어내지 않고 등재.

### [gap-129-board-price-logic] 보드 소재 완제품 셀단가 산정 로직 암묵지 (GAP-2·실사 전체 영향) {unknown}
- type: gap
- anchor: none  # 사유: 보드 완제품 셀단가(6종 등) 산정 규칙이 엑셀에 미기재(암묵지)·정답 원천 부재
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/source-registry.md", source_locator: "문서:§9 GAP-2 롤/보드 소재 가격 계산 로직(엑셀 미기재 암묵지·실사 전체 영향)", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-silsa}
- src: {source_file: "live-snapshot/latest/t_prc_component_prices.csv", source_locator: "comp_cd:COMP_POSTER_FOAMBOARD_BOARD 4셀 단가는 라이브 실재(note '260527 verbatim')하나 산정 규칙(보드원가+출력+가공→셀단가)은 DB에 없음", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- gap_what: "폼보드 완제품 셀단가가 보드원가·출력·가공에서 어떤 규칙으로 산정됐는지가 엑셀에 미기재된 실무 암묵지. 셀단가 자체는 라이브 실재(4셀·260527 verbatim)이나 유도 로직 불명 — 신규 규격/색상 추가 시 셀단가 산정 기준 부재"
- gap_fill_from: "실무진 답변(보드 소재 단가 산정식·source-registry §9 GAP-2). 그 전까지 셀단가 유도 규칙 단정 금지(라이브 셀값은 260527 verbatim 권위로 사용 가능)"
- gap_owner: staff
- rel: {rel: references, target: component-COMP_POSTER_FOAMBOARD_BOARD, note: "산정 로직이 불명한 고정가 셀단가 구성요소"}
- 본문: 고정가 셀단가는 라이브에 실재(260527 verbatim)하나 그 값이 어떻게 산정됐는지(보드원가→셀단가)는 엑셀 미기재 암묵지(실사 전체 공통 GAP·118/126 동형). 온톨로지는 연결·차원까지, 값 계산은 evaluate_price 권위이므로 이 GAP은 값 정합이 아니라 '산정 근거 문서 부재'의 정직 선언.
