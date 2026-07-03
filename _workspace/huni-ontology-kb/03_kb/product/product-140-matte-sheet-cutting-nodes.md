<!-- product-local sub-nodes: E2 category(CAT_000092 첫 정의)·E4 material 2·E6 process 1·E8 bundle_qty·E11 option_group·E9 price_formula·E10 price_component·gap for PRD_000140 무광시트커팅. -->
<!-- ★공유 노드 재사용(중복 mint 방지·L-3·재정의 안 함·참조만): -->
<!--   - size-SIZ_000258(A4 210x297) = product-134-linen-woodrod-scroll-nodes가 정의 → 재사용(참조만). 140 A4 활성 규격. -->
<!--   - size-SIZ_000315(A3 297x420) = product-118-artprint-poster-nodes가 정의 → 재사용(참조만). -->
<!--   - size-SIZ_000198(A2 420x594) = product-118-artprint-poster-nodes가 정의 → 재사용(참조만). -->
<!-- ★여기 정의(140 고유·타 빌더 미정의): category-CAT_000092(시트커팅/스티커·needed_shared)·material 2(시트커팅지 화이트/블랙 .19)· -->
<!--   process-PROC_000125(시트커팅·needed_shared)·qty·optgroup-140-color(색상→자재참조)·formula(PRF_POSTER_SHEETCUT_MATTE·needed_shared)· -->
<!--   component(COMP_POSTER_SHEETCUT_MATTE·needed_shared)·gap 1. -->
<!-- ★수치(사이즈·자재·격자 shape·옵션참조)는 아래 전사표(transcribed-by·transcribe_product_140.py)에만. props raw 미기입(D-9·L-12). -->
<!-- ★가격 값(unit_price)은 전사하지 않음 — 연결·차원·격자완전성까지만(D-18·값=evaluate_price). 고정가 3셀 단가범위는 grid shape 증거만. -->

# product-140 하위 노드 (무광시트커팅 전용 축 원자 + 공식/옵션/GAP)

무광시트커팅(PRD_000140)이 쓰는 시트커팅/스티커 카테고리·시트커팅지 자재 2종·시트커팅 공정·가격공식·구성요소·수량규칙·색상 옵션그룹·GAP 1.
상품→축 연결(has_size·uses_material·has_process·priced_by·has_qty_rule·has_option_group·in_category)은
[[product-140-matte-sheet-cutting]]가 건다. 사이즈(SIZ_000258/315/198)는 **공유 노드 재사용**(위 주석·재정의 안 함).
공식→구성요소 배선(has_component)은 아래 formula 블록. 옵션→자재 참조(option_refs)는 아래 optgroup 블록.

## 상품 요소 전사표 (권위 = 라이브 마스터·스크립트 전사)

> 아래 표는 모두 `_meta/scripts/transcribe_product_140.py`가 live-snapshot(snap_20260702_1119)에서 결정론
> 전사(LLM 손전사 금지·D-9). 캐시=`_meta/scripts/cache/transcribed-140-260703.json`. 실사 시트는 260702 diff
> 무영향(pack §5.5)이라 라이브 현재값=권위 정합(양면 소재 없음).

### 상품 정체·수량 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_140.py from live-snapshot/latest (snap_20260702_1119) t_prd_products PRD_000140 @ 2026-07-03 -->
| prd_typ_cd | nonspec | min_qty | max_qty | qty_incr | qty_unit | file_upload | editor | use_yn |
|---|---|---|---|---|---|---|---|---|
| PRD_TYPE.01 | N | 1 | 10000 | 1 | QTY_UNIT.01 | Y | N | Y |

> nonspec_yn=N → 비규격 연속범위 없음(이산 규격 A4/A3/A2만). 수량 min1/max10000/incr1(제품 레벨).

### 카테고리 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_140.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_categories+t_cat_categories @ 2026-07-03 -->
| cat_cd | 이름 | 부모 | lvl | main_cat_yn |
|---|---|---|---|---|
| CAT_000092 | 시트커팅/스티커 | CAT_000005 | 2 | N |

### 사이즈 (전사·전 행·del 표기 — ★2026-07-01 재키잉)

<!-- transcribed-by: _meta/scripts/transcribe_product_140.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_sizes+t_siz_sizes @ 2026-07-03 -->
| siz_cd | 라벨 | 작업(mm) | dflt | 링크 del | 마스터 del |
|---|---|---|---|---|---|
| SIZ_000172 | A4(210x297mm) | 210x297 | Y | Y | N |
| SIZ_000174 | A3(297x420mm) | 297x420 | Y | Y | N |
| SIZ_000197 | A2(420x594mm) | 420x594 | Y | Y | N |
| SIZ_000258 | A4 (210x297mm) | 210x297 | Y | N | N |
| SIZ_000315 | A3 (297x420mm) | 297x420 | Y | N | N |
| SIZ_000198 | A2 (420X594mm) | 420x594 | Y | N | N |

> 구 A4/A3/A2(SIZ_000172/174/197)는 링크 del_yn=Y(2026-07-01 재키잉)·활성=258/315/198(스티커·시트커팅 태그 사이즈).

### 자재 (전사·전 행·del 표기 — ★MAT_TYPE.19 시트커팅지·2026-07-01 재키잉)

<!-- transcribed-by: _meta/scripts/transcribe_product_140.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_materials+t_mat_materials @ 2026-07-03 -->
| mat_cd | 이름 | mat_typ | 상위자재 | usage_cd | dflt | 링크 del | 마스터 del |
|---|---|---|---|---|---|---|---|
| MAT_000255 | 화이트 | MAT_TYPE.08 |  | USAGE.07 | Y | Y | Y |
| MAT_000256 | 블랙 | MAT_TYPE.08 |  | USAGE.07 | Y | Y | Y |
| MAT_000388 | 시트커팅지(화이트) | MAT_TYPE.19 | MAT_000189 | USAGE.07 | Y | N | N |
| MAT_000389 | 시트커팅지(블랙) | MAT_TYPE.19 | MAT_000189 | USAGE.07 | Y | N | N |

> 구 자재 MAT_000255/256(화이트/블랙·MAT_TYPE.08·06-16 마스터 del) → MAT_000388/389(시트커팅지 화이트/블랙·.19)로 재키잉.

### 공정 (전사·시트커팅·mand Y)

<!-- transcribed-by: _meta/scripts/transcribe_product_140.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_processes+t_proc_processes @ 2026-07-03 -->
| proc_cd | 공정명 | 상위공정 | mand | 링크 del |
|---|---|---|---|---|
| PROC_000125 | 시트커팅 | PROC_000121 | Y | N |

### 판형 (전사·전 행·del 표기 — ★비종이류=판형 무의미·전부 del_yn=Y)

<!-- transcribed-by: _meta/scripts/transcribe_product_140.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_plate_sizes @ 2026-07-03 -->
| siz_cd | output_paper_typ | output_file | dflt | del | note |
|---|---|---|---|---|---|
| SIZ_000050 | (공백) | AI | Y | Y | 파일사양 |
| SIZ_000052 | (공백) | AI | Y | Y | 파일사양 |
| SIZ_000198 | (공백) | AI | Y | Y | 파일사양 |

### 옵션그룹·옵션값·옵션아이템 (전사·★색상→자재 참조 CPQ 레이어)

<!-- transcribed-by: _meta/scripts/transcribe_product_140.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_option_groups+options+option_items @ 2026-07-03 -->

옵션그룹 **OPT_000068** 색상 (sel=SEL_TYPE.01·min1/max1·mand=Y)

| opt_cd | 옵션값 | dflt | ref_dim | ref_key1(자재) | ref_key2 | qty |
|---|---|---|---|---|---|---|
| OPV_000449 | 블랙 | N | OPT_REF_DIM.03 | MAT_000389 | USAGE.07 | 1 |
| OPV_000448 | 화이트 | Y | OPT_REF_DIM.03 | MAT_000388 | USAGE.07 | 1 |

### 미보유 축 (전사·0행 실측)

<!-- transcribed-by: _meta/scripts/transcribe_product_140.py from live-snapshot/latest (snap_20260702_1119) print_options/bundle_qtys/addons/constraints/sets @ 2026-07-03 -->
| 축 | 행수 |
|---|---|
| print_options(도수) | 0 |
| bundle_qtys(묶음수) | 0 |
| addons(추가상품) | 0 |
| constraints(제약규칙) | 0 |
| sets(셋트 부모) | 0 |

### 가격 배선 (전사·priced_by→공식→구성요소)

<!-- transcribed-by: _meta/scripts/transcribe_product_140.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_price_formulas+t_prc_formula_components+t_prc_price_components @ 2026-07-03 -->

공식 **PRF_POSTER_SHEETCUT_MATTE** — 무광시트커팅 완제품가(면적/규격 단가) (use_yn=Y)

| disp_seq | comp_cd | addtn | prc_typ | comp_nm | use_dims |
|---|---|---|---|---|---|
| 1 | COMP_POSTER_SHEETCUT_MATTE | Y | PRICE_TYPE.01 | 무광시트커팅 완제품가 | `["siz_cd"]` |

### 고정가 룩업 셀 요약 (전사·D-22 접기 — 전개 금지·값=range shape 증거만·개별값 미노출)

<!-- transcribed-by: _meta/scripts/transcribe_product_140.py from live-snapshot/latest (snap_20260702_1119) t_prc_component_prices (COMP_POSTER_SHEETCUT_MATTE 집계) @ 2026-07-03 -->
| comp_cd | use_yn | 격자행 | 사이즈축(격자) | 상품활성사이즈 | 도달셀/활성 | legacy siz | 단가범위(shape) | use_dims |
|---|---|---|---|---|---|---|---|---|
| COMP_POSTER_SHEETCUT_MATTE | Y | 6 | SIZ_000172/SIZ_000174/SIZ_000197/SIZ_000198/SIZ_000258/SIZ_000315 | SIZ_000198/SIZ_000258/SIZ_000315 | 3/3 | SIZ_000172/SIZ_000174/SIZ_000197 | 6000~32000 | `["siz_cd"]` |

> ★use_dims=[siz_cd] **단일축**(130 포맥스보드 [mat_cd,siz_cd]와 다름): 사이즈만 가격축이고 색상
> (화이트/블랙)은 가격 무관(mat_cd 비차원). 상품 활성 사이즈 3(A4 258/A3 315/A2 198)이 격자에
> 전부 도달(도달 3/3 완전격자·수량축 없음·min_qty NULL). legacy siz(172/174/197)=재키잉 잔여
> 격자행(상품이 더 이상 참조 안 함·2026-07-01 dedup rekey→258/315/198). 단가범위는 격자 shape
> 증거일 뿐 — 개별 셀단가·계산=evaluate_price 권위(D-18·값 노드 미기록).

## 카테고리 노드 (★재사용 — 시트커팅/스티커 CAT_000092·재정의 안 함·L-3 회피·needed_shared)

<!-- ★CAT_000092 시트커팅/스티커(사인 CAT_000005 하위 leaf)는 병렬 시트커팅/스티커 빌더 -->
<!-- (141 홀로그램시트커팅·142 유광아크릴스티커)가 동시에 정의 → 140은 참조만(재정의 금지·L-3 중복 회피·134 교훈 "재정의 제거로 dup 기여0"). -->
<!-- 140 main이 in_category→category-CAT_000092로 참조(node는 141/142 정의로 실재). needed_shared 반환(consolidation이 canonical 선정·향후 axis/categories.md 승격). -->
<!-- 부모 사인 CAT_000005는 별도 노드 미생성(상품이 in_category로 걸지 않음=고아 회피). -->
<!-- 140↔CAT_000092 junction 증거(main_cat_yn=N·라이브 유일 junction)는 상단 전사표 '카테고리' 절이 보존. -->

## 자재 노드 (product-local — 시트커팅지 2종·MAT_TYPE.19 시트커팅지)

<!-- ★140 자재=시트커팅지(MAT_TYPE.19 전용소재·06-27 신설·정당). 실사 팩이 경고한 레더 MAT_000186 .08→.05 crosscut과 완전 무관 -->
<!-- (레더=100/126/296/298 횡단·pack §1.1·T-2). 시트커팅지 .19=현재값이자 정답(양면 불요). IMPORT 자재 삭제 금지. -->
<!-- 부모 MAT_000189(시트커팅지)은 상품 링크 없음(자식 2종만 uses_material) → 노드 미생성·props upr로만 표기(환각 차단). -->
<!-- ★재키잉: 구 MAT_000255/256(화이트/블랙·MAT_TYPE.08·06-16 마스터 del)은 상품 링크도 del_yn=Y → uses_material 대상 아님(노드 미생성·전사표 del 표기로만 이력 보존). -->

### [material-MAT_000388] 시트커팅지(화이트) {verified}
- type: material
- anchor: t_mat_materials/MAT_000388
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "테이블:t_mat_materials 키:MAT_000388(mat_nm=시트커팅지(화이트)·mat_typ_cd=MAT_TYPE.19·upr_mat_cd=MAT_000189·06-27 신설·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_materials.csv", source_locator: "키:(PRD_000140,MAT_000388) USAGE.07·dflt_yn=Y·disp_seq=1·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.19", upr_mat_cd: "MAT_000189", 색상: "화이트지", 사용: "140 본체 자재(USAGE.07)", note: "시트커팅지 화이트(전용 유형 .19·정당·레더 crosscut 아님·pack §3.5). 색상 옵션 OPV_000448(화이트) 참조 대상. 가격 무관(use_dims=[siz_cd]에 mat_cd 없음)"}
- 본문: 무광시트커팅 본체 자재(화이트 시트지). 낱장 완제품 단일 슬롯(USAGE.07·내지/표지 없음). 색상 옵션그룹(색상)의 화이트 옵션값이 OPT_REF_DIM.03(자재)로 이 자재를 참조한다. ★가격은 규격(siz_cd)만으로 결정되고 색상은 가격축이 아니다(화이트/블랙 동가). [[product-140-matte-sheet-cutting]] uses_material 대상·[[optgroup-140-color]] 참조 대상.

### [material-MAT_000389] 시트커팅지(블랙) {verified}
- type: material
- anchor: t_mat_materials/MAT_000389
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "테이블:t_mat_materials 키:MAT_000389(mat_nm=시트커팅지(블랙)·mat_typ_cd=MAT_TYPE.19·upr_mat_cd=MAT_000189·06-27 신설·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_materials.csv", source_locator: "키:(PRD_000140,MAT_000389) USAGE.07·dflt_yn=Y·disp_seq=1·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.19", upr_mat_cd: "MAT_000189", 색상: "블랙지", 사용: "140 본체 자재(USAGE.07)", note: "시트커팅지 블랙(전용 유형 .19·정당). 색상 옵션 OPV_000449(블랙) 참조 대상. 가격 무관(use_dims=[siz_cd]에 mat_cd 없음)"}
- 본문: 무광시트커팅 본체 자재(블랙 시트지). USAGE.07 단일 슬롯. 색상 옵션그룹의 블랙 옵션값이 OPT_REF_DIM.03(자재)로 이 자재를 참조한다. 가격 무관(색상 비가격축). [[product-140-matte-sheet-cutting]] uses_material 대상·[[optgroup-140-color]] 참조 대상.

## 공정 노드 (product-local — 시트커팅·mand Y·needed_shared)

<!-- ★PROC_000125 시트커팅=140 첫 정의(06-29 신설·타 상품 미공유·향후 141 홀로그램시트커팅과 공유 시 axis/processes 승격 후보·needed_shared). -->
<!-- 상위 PROC_000121 커팅은 상품 링크 없음(자식만 부착) → 노드 미생성·props upr로만 표기(환각 차단). -->

### [process-PROC_000125] 시트커팅 (필수공정·mand Y) {verified}
- type: process
- anchor: t_proc_processes/PROC_000125
- src: {source_file: "live-snapshot/latest/t_proc_processes.csv", source_locator: "테이블:t_proc_processes 키:PROC_000125(proc_nm=시트커팅·upr_proc_cd=PROC_000121 커팅·prcs_dtl_opt 공백·use_yn=Y·06-29 신설·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_processes.csv", source_locator: "키:(PRD_000140,PROC_000125) mand_proc_yn=Y·disp_seq=1·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {upr_proc_cd: "PROC_000121", upr_proc_nm: "커팅", mand: "Y", prcs_dtl_opt: null, note: "시트지 커팅 후가공(필수 공정·mand Y·모든 주문 강제). 통가격에 baked(comp note '소재+출력+가공 포함')·손님 선택 아님(선택형 라미의 130과 다른 정합 상태). param 인스턴스 없음(prcs_dtl_opt 공백)"}
- 본문: 무광시트커팅의 필수 후가공(시트지를 원하는 형태로 커팅). mand_proc_yn=Y라 모든 주문에 강제 적용되고 가격은 규격별 완제품 통가격에 녹아 있다(별도 가산 아님·pack §3.6). 130 라미네이팅(선택·mand N·CPQ UI 없음 GAP)과 달리 140 시트커팅은 필수라 CPQ 옵션 불필요(정합). [[product-140-matte-sheet-cutting]] has_process 대상.

## 수량규칙 노드 (product-local)

### [qty-140] 무광시트커팅 수량규칙 {verified}
- type: bundle_qty
- anchor: t_prd_products/PRD_000140
- src: {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "키:PRD_000140 min_qty/max_qty/qty_incr(1/10000/1)·qty_unit_typ_cd=QTY_UNIT.01", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/_foundation/batch/qty_rule_audit_260702.py", source_locator: "수량 UI 권위=상품/사이즈 규칙(가격구간과 역할 분리)", captured_at: "2026-07-03", badge: verified, src_id: SR-27-qtyaudit}
- props: {min_max_incr_ref: "전사표 수량규칙(상품 1/10000/1)", bdl_unit_typ_cd: "QTY_UNIT.01", bundle_qtys_rows: 0, note: "★고정가 룩업형이라 수량축이 가격 차원 아님(구성요소 use_dims=[siz_cd]·수량 없음). 셀단가=시트1장가·총액=셀×수량(수량구간 할인 없음)"}
- 본문: 수량 그릇 = 상품 마스터 컬럼(min 1·max 10000·incr 1). t_prd_product_bundle_qtys 0행 정상(수량 UI 권위=상품 레벨·[[rule/decisions#DEC_qty_audit_260702]]). 가격은 수량 무관 통가격.

## 옵션그룹 노드 (product-local — 색상 택1·자재 참조·L-18 정합)

<!-- ★OPT_000068 색상=SEL_TYPE.01 단일·min1/max1·mand Y. 옵션값 화이트/블랙이 OPT_REF_DIM.03(자재)로 MAT_000388/389 참조. -->
<!-- ★L-18: option_refs 타깃(material-MAT_000388/389)은 부모 140 has_option_group 역참조 시 uses_material에 실재해야 함 → main 파일이 uses_material로 둘 다 걸어 정합. -->
<!-- ★130과 차이: 130 옵션그룹 0행 vs 140 색상 옵션 1행(라이브 CPQ 레이어 실례·pack §3.9 "138만" 서술 확장). -->

### [optgroup-140-color] 색상 필수 택1 (mand=Y·min/max=1/1·자재 참조) {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000140
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "테이블:t_prd_product_option_groups 키:(PRD_000140,OPT_000068) opt_grp_nm=색상·sel_typ=SEL_TYPE.01(단일)·min/max=1/1·mand_yn=Y·use_yn=Y·disp 1", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_option_items.csv", source_locator: "테이블:t_prd_product_option_items 키:(PRD_000140,OPV_000448) ref_dim_cd=OPT_REF_DIM.03(자재)·ref_key1=MAT_000388·ref_key2=USAGE.07·qty=1·del_yn=N ; 키:(PRD_000140,OPV_000449) ref_key1=MAT_000389·ref_key2=USAGE.07", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {sel_typ_cd: "SEL_TYPE.01", mand: "Y", min_sel: "1", max_sel: "1", items: "OPV_000448 화이트(dflt)→MAT_000388·OPV_000449 블랙→MAT_000389", note: "색상 선택=시트지 색상(화이트/블랙) 자재 참조 BUNDLE. 가격 무관(use_dims=[siz_cd]에 mat_cd 없음·화이트/블랙 동가). pack §3.9 '실사 옵션 138만' 서술의 확장 실례(현재값)"}
- rel: {rel: option_refs, target: material-MAT_000388, ref_key1: MAT_000388, note: "화이트 옵션값 OPV_000448(OPT_REF_DIM.03 자재·ref_key1=MAT_000388·ref_key2=USAGE.07)"}
- rel: {rel: option_refs, target: material-MAT_000389, ref_key1: MAT_000389, note: "블랙 옵션값 OPV_000449(OPT_REF_DIM.03 자재·ref_key1=MAT_000389·ref_key2=USAGE.07)"}
- 본문: 색상 필수 옵션(mand Y·택1). 옵션값 화이트(dflt)/블랙이 부모 has_material(시트커팅지 화이트 MAT_000388·블랙 MAT_000389)를 가리킨다(L-18 정합·옵션=자재 BUNDLE·pack §3.9). ★가격은 규격만으로 결정되므로 색상 선택은 소재를 바꿀 뿐 가격은 동일하다(화이트/블랙 동가·use_dims=[siz_cd]). 값 계산=엔진. [[product-140-matte-sheet-cutting]] has_option_group 대상.

## 가격공식 노드 (product-local — silsa formula 축 승격 대기·needed_shared)

<!-- ★고정가 룩업형(면적매트릭스·원자합산과 다른 아키타입). 단일 구성요소(완제품가)를 (siz_cd) 단일축 셀에서 조회. -->
<!-- has_component 타깃 component-COMP_POSTER_SHEETCUT_MATTE = 아래 140 canonical 정의(140 전용·타 상품 미공유·141 홀로는 별도 PRF_POSTER_SHEETCUT_HOLO). -->

### [formula-PRF_POSTER_SHEETCUT_MATTE] 무광시트커팅 완제품가 (고정가 룩업·규격 단일축) {verified}
- type: price_formula
- anchor: t_prc_price_formulas/PRF_POSTER_SHEETCUT_MATTE
- src: {source_file: "live-snapshot/latest/t_prc_price_formulas.csv", source_locator: "테이블:t_prc_price_formulas 키:PRF_POSTER_SHEETCUT_MATTE(frm_nm=무광시트커팅 완제품가(면적/규격 단가)·note=포스터사인 무광시트커팅 소재/사이즈/수량별 완제품 통가격·use_yn=Y)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prc_formula_components.csv", source_locator: "frm_cd:PRF_POSTER_SHEETCUT_MATTE(comp COMP_POSTER_SHEETCUT_MATTE·disp_seq 1·addtn_yn Y·1행·06-17 배선)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_price_formulas.csv", source_locator: "키:(PRD_000140,PRF_POSTER_SHEETCUT_MATTE) 바인딩·apply_bgn_ymd=2026-06-01", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: has_component, target: component-COMP_POSTER_SHEETCUT_MATTE, qualifier: {disp_seq: 1, addtn: Y}}
- props: {archetype: "고정가 룩업형(fixed·통가격·단일축)", use_yn: Y, note: "140 바인딩 전용 공식. 단일 구성요소(완제품가)를 (siz_cd) 3셀에서 조회(evaluate_price). frm_nm '(면적/규격 단가)'는 명명일 뿐·실 use_dims=[siz_cd] 고정 룩업(면적매트릭스 아님·130 [mat_cd,siz_cd] 2축과도 다른 단일축·전사표 검증). 141 홀로그램시트커팅은 별도 PRF_POSTER_SHEETCUT_HOLO(140 미공유)"}
- 본문: 무광시트커팅 가격공식. 단일 구성요소(완제품가) 1건 배선 — 인쇄·용지·커팅을 원자 합산하지 않고 (규격) 고정 룩업에서 완제품 통가격을 조회한다. 배선 타깃 [[component-COMP_POSTER_SHEETCUT_MATTE]](아래 140 canonical 정의). 고아 공식 아님(has_component 1건·06-17 배선·pack §27 정합). 값 계산=evaluate_price 권위(D-18·[[rule/rules#RULE_price_value_boundary]]).

## 가격구성요소 노드 (product-local canonical — 고정가 룩업·silsa component 축 승격 대기·needed_shared)

<!-- ★COMP_POSTER_SHEETCUT_MATTE = 무광시트커팅 완제품가(규격 단일축). 140 전용(타 상품 미공유·130의 2축 결합 comp와도 다름). -->
<!-- ★단가행(격자)은 노드로 펼치지 않고 use_dims 차원+SHAPE로 접음(D-22). 값(unit_price·단가범위 6000~32000)은 grid shape 증거로만·개별 셀단가 미전사(evaluate_price 권위). -->

### [component-COMP_POSTER_SHEETCUT_MATTE] 무광시트커팅 완제품가 (규격 단일축·고정 룩업) {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_POSTER_SHEETCUT_MATTE
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "테이블:t_prc_price_components 키:COMP_POSTER_SHEETCUT_MATTE(comp_typ=PRC_COMPONENT_TYPE.06 완제품비·prc_typ_cd=PRICE_TYPE.01 단가형·use_dims=[siz_cd]·note=포스터·사인 완제품가(소재+출력+가공 포함 통가격)·사이즈·수량별 단가표·use_yn=Y)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/_meta/scripts/cache/transcribed-140-260703.json", source_locator: "grid.COMP_POSTER_SHEETCUT_MATTE(격자행6·사이즈6·상품활성사이즈3·도달 3/3·legacy siz 3·단가범위 shape 6000~32000)", captured_at: "2026-07-03", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.01", comp_typ_cd: "PRC_COMPONENT_TYPE.06", use_dims: '["siz_cd"]', role: "무광시트커팅 완제품 통가격(소재+출력+가공[시트커팅] 포함·색상 무관)", 단가행_ref: "전사표 고정가 shape(격자6행=활성3(258/315/198)+legacy3(172/174/197)·상품활성 도달 3/3·수량축 미충전 min_qty NULL)", archetype: "고정가 룩업(fixed·단일축·면적매트릭스 아님·130 2축과도 다름)", 재키잉메모: "2026-07-01 dedup rekey→258/315/198(구 172/174/197 격자행 잔여·상품 미참조)"}
- 본문: 무광시트커팅 완제품가 구성요소(canonical·140 전용). use_dims **1축**(사이즈 siz_cd)으로 셀단가가 달라진다(차원 선언까지·D-22 단가행 접기). ★130 포맥스보드가 [mat_cd,siz_cd] 2축인 것과 달리 140은 [siz_cd] 단일축 — 색상(화이트/블랙)이 자재를 바꾸지만 가격은 규격만으로 결정(동가). 상품 활성 사이즈 3종(A4 258·A3 315·A2 198)이 격자에 전부 도달(도달 3/3 완전격자·전사표 SHAPE). 격자에는 재키잉 잔여 legacy siz(172/174/197) 3행도 남아 있으나 상품이 참조하지 않는다(2026-07-01 dedup rekey·기능 영향 없음). 값=evaluate_price(개별 셀단가 미전사·단가범위는 grid shape 증거만·D-18·[[rule/rules#RULE_price_value_boundary]]). 단가는 인쇄상품 가격표 260527 verbatim(comp note).

## GAP 노드 (원천 부재·정직 선언)

### [gap-140-fixedprice-basis] 시트 완제품 통가격 산정 근거 문서 부재 {unknown}
- type: gap
- anchor: none  # 사유: 고정가 3셀 완제품 통가격(소재+출력+가공[시트커팅])이 어떤 규칙으로 산정됐는지 엑셀 미기재 암묵지
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/source-registry.md", source_locator: "문서:§9 GAP-2 롤 소재 가격 계산 로직(엑셀 미기재 암묵지·실사 전체 영향)", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-silsa}
- gap_what: "고정가 3셀(A4/A3/A2) 완제품 통가격이 시트지 원가+출력비+시트커팅 가공비를 어떤 규칙으로 통합해 산출됐는지 — 값은 라이브에 적재됐고(260527 verbatim) 라이브 셀단가=가격표 원본이나 산정식 자체는 문서 부재"
- gap_fill_from: "실무진 확인(source-registry §9 GAP-2·실사 전체 공통). 예전사이트 골든 대조로 값 정합 검증 가능하나 산정식은 암묵지"
- gap_owner: staff
- 본문: 가격 경로는 연결됨([[formula-PRF_POSTER_SHEETCUT_MATTE]]→[[component-COMP_POSTER_SHEETCUT_MATTE]]·도달 3/3셀 완전격자)이라 견적 0 위험 없음. 다만 통가격이 **어떻게** 산정됐는지는 엑셀 미기재 암묵지(실사 전체 공통 GAP). 온톨로지는 연결·차원까지, 값 계산은 evaluate_price 권위이므로 이 GAP은 값 정합이 아니라 "산정 근거 문서 부재"의 정직 선언. 140은 시트(비종이류)라 "롤 소재"는 아니나 완제품 통가격 산정 암묵지는 동일 부류.
