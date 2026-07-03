<!-- product-local sub-nodes: E2 category 2(CAT_000005 사인·CAT_000092 시트커팅/스티커 첫 정의)·E3 size 4·E4 material 2·E6 process 1·E8 bundle_qty·E9 price_formula·E10 price_component·E11 option_group·gap 2 for PRD_000143 미러아크릴스티커. -->
<!-- ★공유 노드 재사용(중복 mint 방지·L-3·재정의 안 함·참조만): 없음 — 143이 사용하는 카테고리/사이즈/자재/공정이 KB 최초 등장(grep 확인·142 유광아크릴스티커 형제 미빌드). 그래서 여기서 canonical 정의 + needed_shared 반환(consolidation이 142와 dedupe·axis 승격). -->
<!-- ★여기 정의(143 고유·타 빌더 미정의): category 2(CAT_000005·CAT_000092)·size 4(SIZ_000324~327·아크릴스티커 공유규격)·material 2(아크릴 골드/실버 .20)·process 1(PROC_000124 레이저커팅)·qty·formula(PRF_POSTER_ACRYLSTK_MIRROR)·component(COMP_POSTER_ACRYLSTK_MIRROR)·optgroup(143-color 칼라)·gap 2. -->
<!-- ★수치(사이즈·자재·격자 shape)는 아래 전사표(transcribed-by·transcribe_product_143.py)에만. props raw 미기입(D-9·L-12). -->
<!-- ★가격 값(unit_price)은 전사하지 않음 — 연결·차원·격자완전성까지만(D-18·값=evaluate_price). 고정가 4셀 단가범위는 grid shape 증거만. -->

# product-143 하위 노드 (미러아크릴스티커 전용 축 원자 + 공식/옵션/GAP)

미러아크릴스티커(PRD_000143)가 쓰는 사인·시트커팅/스티커 카테고리·아크릴스티커 규격 4종·아크릴(골드/실버)
자재 2종·레이저커팅 공정·가격공식·구성요소·칼라 옵션그룹·수량규칙·GAP 2. 상품→축 연결
(has_size·uses_material·has_process·priced_by·has_qty_rule·has_option_group·in_category)은
[[product-143-mirror-acrylic-sticker]]가 건다. 공식→구성요소 배선(has_component)·옵션→자재 참조
(option_refs)는 아래 formula/optgroup 블록. ★이 상품의 카테고리·사이즈·자재·공정은 KB 최초 등장이라
여기서 canonical 정의하되 형제(142 유광아크릴스티커)와 공유될 축은 **needed_shared_nodes로 반환**(consolidation dedupe).

## 상품 요소 전사표 (권위 = 라이브 마스터·스크립트 전사)

> 아래 표는 모두 `_meta/scripts/transcribe_product_143.py`가 live-snapshot(snap_20260702_1119)에서 결정론
> 전사(LLM 손전사 금지·D-9). 캐시=`_meta/scripts/cache/transcribed-143-260703.json`. 실사 시트는 260702 diff
> 무영향(pack §5.5)이라 라이브 현재값=권위 정합(양면 소재 없음). ★자재는 재키잉 이력 표기 위해 전 행(del 포함).

### 상품 정체·수량 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_143.py from live-snapshot/latest (snap_20260702_1119) t_prd_products PRD_000143 @ 2026-07-03 -->
| prd_typ_cd | nonspec | min_qty | max_qty | qty_incr | qty_unit | file_upload | editor | use_yn |
|---|---|---|---|---|---|---|---|---|
| PRD_TYPE.01 | N | 1 | 10000 | 1 | QTY_UNIT.01 | Y | N | Y |

> nonspec_yn=N → 비규격 연속범위 없음(이산 규격 4종만). 수량 min1/max10000/incr1(제품 레벨).

### 카테고리 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_143.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_categories+t_cat_categories @ 2026-07-03 -->
| cat_cd | 이름 | 부모 | lvl | main_cat_yn |
|---|---|---|---|---|
| CAT_000092 | 시트커팅/스티커 | CAT_000005 | 2 | N |
| CAT_000005 | 사인 |  | 1 | Y |

### 사이즈 (전사·전 행·del 표기·이산 규격 4종)

<!-- transcribed-by: _meta/scripts/transcribe_product_143.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_sizes+t_siz_sizes @ 2026-07-03 -->
| siz_cd | 라벨 | 작업(mm) | dflt | 링크 del | 마스터 del |
|---|---|---|---|---|---|
| SIZ_000324 | 290x90mm | 290x90 | Y | N | N |
| SIZ_000325 | 290x190mm | 290x190 | Y | N | N |
| SIZ_000326 | 390x290mm | 390x290 | Y | N | N |
| SIZ_000327 | 590x390mm | 590x390 | Y | N | N |

### 자재 (전사·전 행·★재키잉 이력: 구 .08 실사소재 → 현행 .20 아크릴)

<!-- transcribed-by: _meta/scripts/transcribe_product_143.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_materials+t_mat_materials @ 2026-07-03 -->
| mat_cd | 이름 | mat_typ | 상위자재 | usage_cd | dflt | 링크 del | 마스터 del |
|---|---|---|---|---|---|---|---|
| MAT_000258 | 골드 | MAT_TYPE.08 |  | USAGE.07 | Y | Y | Y |
| MAT_000259 | 실버 | MAT_TYPE.08 |  | USAGE.07 | Y | Y | Y |
| MAT_000377 | 아크릴(골드) 3mm | MAT_TYPE.20 | MAT_000195 | USAGE.07 | Y | N | N |
| MAT_000378 | 아크릴(실버) 3mm | MAT_TYPE.20 | MAT_000196 | USAGE.07 | Y | N | N |

> ★구 골드 MAT_000258·실버 MAT_000259(MAT_TYPE.08 실사소재)=상품링크 del_yn=Y(07-01 언링크)·마스터 del_yn=Y(06-16).
> 현행 = 아크릴(골드) MAT_000377·아크릴(실버) MAT_000378(MAT_TYPE.20 아크릴·상위 195/196·07-01 링크). 현재값 .20=정합.

### 공정 (전사·레이저커팅·mand Y — 아크릴 절단)

<!-- transcribed-by: _meta/scripts/transcribe_product_143.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_processes+t_proc_processes @ 2026-07-03 -->
| proc_cd | 공정명 | 상위공정 | mand | 링크 del |
|---|---|---|---|---|
| PROC_000124 | 레이저커팅 | PROC_000121 | Y | N |

> ★인쇄방식(UV PROC_000002) 공정 행은 라이브 부재(print_options=0·도수 없음) — pack §3.7 UV 라우팅=GAP(Q-SL-A).

### 판형 (전사·전 행·del 표기 — ★비종이류=판형 무의미·전부 del_yn=Y)

<!-- transcribed-by: _meta/scripts/transcribe_product_143.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_plate_sizes @ 2026-07-03 -->
| siz_cd | output_paper_typ | output_file | dflt | del | note |
|---|---|---|---|---|---|
| SIZ_000324 | (공백) | AI | Y | Y | 파일사양 |
| SIZ_000325 | (공백) | AI | Y | Y | 파일사양 |
| SIZ_000326 | (공백) | AI | Y | Y | 파일사양 |
| SIZ_000327 | (공백) | AI | Y | Y | 파일사양 |

### CPQ 옵션 레이어 (전사·★칼라 옵션그룹 — 130과 차이·option_items→자재 참조)

<!-- transcribed-by: _meta/scripts/transcribe_product_143.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_option_groups+options+option_items @ 2026-07-03 -->

옵션그룹 **OPT-000046** — 칼라 (sel_typ=SEL_TYPE.01·min 0/max 1·mand N)

| opt_cd | 옵션명 | dflt | item ref_dim | ref_key1(자재) | ref_key2 |
|---|---|---|---|---|---|
| OPV-000095 | 골드아크릴 | N | OPT_REF_DIM.03 | MAT_000377 | USAGE.07 |
| OPV-000096 | 실버아크릴 | N | OPT_REF_DIM.03 | MAT_000378 | USAGE.07 |

### 미보유 축 (전사·0행 실측)

<!-- transcribed-by: _meta/scripts/transcribe_product_143.py from live-snapshot/latest (snap_20260702_1119) print_options/bundle_qtys/addons/constraints/sets @ 2026-07-03 -->
| 축 | 행수 |
|---|---|
| print_options(도수) | 0 |
| bundle_qtys(묶음수) | 0 |
| addons(추가상품) | 0 |
| constraints(제약규칙) | 0 |
| sets(셋트 부모) | 0 |

### 가격 배선 (전사·priced_by→공식→구성요소)

<!-- transcribed-by: _meta/scripts/transcribe_product_143.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_price_formulas+t_prc_formula_components+t_prc_price_components @ 2026-07-03 -->

공식 **PRF_POSTER_ACRYLSTK_MIRROR** — 미러아크릴스티커 완제품가(면적/규격 단가) (use_yn=Y)

| disp_seq | comp_cd | addtn | prc_typ | comp_nm | use_dims |
|---|---|---|---|---|---|
| 1 | COMP_POSTER_ACRYLSTK_MIRROR | Y | PRICE_TYPE.01 | 미러아크릴스티커 완제품가 | `["siz_cd"]` |

### 고정가 룩업 셀 요약 (전사·D-22 접기 — 전개 금지·값=range shape 증거만·개별값 미노출)

<!-- transcribed-by: _meta/scripts/transcribe_product_143.py from live-snapshot/latest (snap_20260702_1119) t_prc_component_prices (COMP_POSTER_ACRYLSTK_MIRROR 집계) @ 2026-07-03 -->
| comp_cd | use_yn | 행수 | 사이즈축(개수) | 자재축 | 셀존재/잠재 | 단가범위(shape) | use_dims |
|---|---|---|---|---|---|---|---|
| COMP_POSTER_ACRYLSTK_MIRROR | Y | 4 | 4(SIZ_000324/SIZ_000325/SIZ_000326/SIZ_000327) | (없음·siz 단일축) | 4/4 | 11000~50000 | `["siz_cd"]` |

> ★셀존재/잠재=4/4: 사이즈 4종 각 1셀(use_dims=[siz_cd] 단일축·mat_cd 컬럼 공란=골드/실버 동일가).
> 격자완전(유효 4/4)·수량축 없음(min_qty NULL). 130(2축 mat×siz)보다 단순한 siz 단일축 룩업.
> 단가범위는 격자 shape 증거일 뿐 — 개별 셀단가·계산=evaluate_price 권위(D-18·값 노드 미기록).

## 카테고리 노드 (★143 첫 정의 — 사인·시트커팅/스티커·needed_shared 반환)

<!-- ★CAT_000005 사인(root)·CAT_000092 시트커팅/스티커(lvl2)는 KB 최초 등장(grep 확인). 143이 canonical 정의하되 -->
<!-- 형제 사인 상품(142 유광아크릴스티커·140/141 시트커팅 등)이 공유할 축 → needed_shared 반환(consolidation dedupe·axis/categories 승격). -->

### [category-CAT_000005] 사인 (root·main) {verified}
- type: category
- anchor: t_cat_categories/CAT_000005
- src: {source_file: "live-snapshot/latest/t_cat_categories.csv", source_locator: "테이블:t_cat_categories 키:CAT_000005(cat_nm=사인·upr_cat_cd=(없음·root)·cat_lvl=1·main_cat_yn=Y·disp_seq=9·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "문서:§0(실사=카테고리 004 포스터+005 사인 대형 실사 출력물)(승계·재검증 2026-07-03)", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-silsa}
- props: {cat_lvl: 1, upr_cat_cd: null, main_cat_yn: "Y", role: "실사 사인 계열 root 카테고리(대형 실사 출력물)", note: "143 미러아크릴스티커의 main 카테고리(main_cat_yn=Y). 143 KB 최초 정의·142 등 형제 공유 예정·needed_shared"}
- 사용처:
- 본문: 실사 사인 계열 최상위 분류(포스터 CAT_000004와 병렬 root). 미러아크릴스티커는 사인 하위 시트커팅/스티커에 귀속. ★round-13 "실사 28상품 전부 CAT_000298 고아"는 STALE — 143은 정상 사인 카테고리 재연결(pack §1.1·§4 T-1·CAT_000298 del_yn=Y 06-18).

<!-- ★consolidation(260703): category-CAT_000092(시트커팅/스티커·lvl2·upr CAT_000005)는 형제 141 홀로그램시트커팅(product-141-hologram-sheet-cutting-nodes.md)이 canonical 소유 → 143은 참조만(중복 mint 제거·L-3 dedupe). 143 product는 in_category CAT_000092 엣지로 참조. 실사 축 axis/categories.md 정식 승격은 후속 패스. -->
- 참조: [[category-CAT_000092]] (canonical=product-141-hologram-sheet-cutting-nodes.md)

## 사이즈 노드 (★consolidation: 142 canonical 참조만 — 아크릴스티커 규격 4종)

<!-- ★consolidation(260703): SIZ_000324~327(아크릴스티커 290x90/290x190/390x290/590x390)는 형제 142 유광아크릴스티커(product-142-glossy-acrylic-sticker-nodes.md)가 canonical 소유(파일 정렬 선점) → 143은 참조만(중복 mint 제거·L-3 dedupe). 143 product는 has_size 엣지로 참조. 실사 축 axis/sizes.md 정식 승격은 후속 패스. -->
- 참조: [[size-SIZ_000324]] · [[size-SIZ_000325]] · [[size-SIZ_000326]] · [[size-SIZ_000327]] (canonical=product-142-glossy-acrylic-sticker-nodes.md)

## 자재 노드 (product-local — 아크릴 골드/실버 3mm·MAT_TYPE.20 아크릴·★재키잉 후 현행)

<!-- ★143 현행 자재=아크릴(골드/실버) 3mm·MAT_TYPE.20 아크릴(06-27 마스터 신설·07-01 상품링크). -->
<!-- ★구 골드 MAT_000258·실버 MAT_000259(MAT_TYPE.08 실사소재)=상품링크 del_yn=Y(07-01)·마스터 del_yn=Y(06-16) → 노드 미생성(은퇴·전사표 이력만). -->
<!-- ★이것이 task가 경고한 "레더 .08→.06 주의"의 아크릴판 — 다만 현행 .20=정합이라 양면 defect 아님(권위 목표 라벨 충돌 없음). -->
<!-- 부모 MAT_000195(아크릴 골드)·MAT_000196(아크릴 실버)는 상품 직접 링크 없음(자식 3mm만 uses_material) → 노드 미생성·props upr로만 표기(환각 차단). -->

### [material-MAT_000377] 아크릴(골드) 3mm {verified}
- type: material
- anchor: t_mat_materials/MAT_000377
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "테이블:t_mat_materials 키:MAT_000377(mat_nm=아크릴(골드) 3mm·mat_typ_cd=MAT_TYPE.20 아크릴·upr_mat_cd=MAT_000195·06-27 마스터 신설·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_materials.csv", source_locator: "키:(PRD_000143,MAT_000377) USAGE.07·dflt_yn=Y·07-01 링크·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.20", upr_mat_cd: "MAT_000195", 두께: "3mm", 사용: "143 본체 자재(USAGE.07)", note: "★재키잉: 구 골드 MAT_000258(.08 실사소재·del_yn=Y)에서 07-01 교체. 현행 .20 아크릴=현재값이자 정합(양면 defect 아님). 칼라 옵션 골드아크릴(OPV-000095)이 option_refs로 참조. IMPORT 자재 삭제 금지"}
- 사용처:
- 본문: 미러아크릴스티커 본체 자재(골드 아크릴 3mm). 낱장 완제품 단일 슬롯(USAGE.07·내지/표지 없음·pack §3.5). ★"레더 .08→.06 주의"의 아크릴판 — 구 골드(.08 실사소재)에서 .20 아크릴로 재키잉됐고 현행 .20=정합(권위 목표 라벨 충돌 없음·양면 불요). 칼라 옵션그룹의 골드아크릴 선택 대상([[optgroup-143-color]] option_refs·L-18 정합). ★가격 무관(use_dims=[siz_cd]·골드/실버 동일가). [[product-143-mirror-acrylic-sticker]] uses_material 대상.

### [material-MAT_000378] 아크릴(실버) 3mm {verified}
- type: material
- anchor: t_mat_materials/MAT_000378
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "테이블:t_mat_materials 키:MAT_000378(mat_nm=아크릴(실버) 3mm·mat_typ_cd=MAT_TYPE.20 아크릴·upr_mat_cd=MAT_000196·06-27 마스터 신설·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_materials.csv", source_locator: "키:(PRD_000143,MAT_000378) USAGE.07·dflt_yn=Y·07-01 링크·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.20", upr_mat_cd: "MAT_000196", 두께: "3mm", 사용: "143 본체 자재(USAGE.07)", note: "★재키잉: 구 실버 MAT_000259(.08 실사소재·del_yn=Y)에서 07-01 교체. 현행 .20 아크릴=현재값이자 정합. 칼라 옵션 실버아크릴(OPV-000096)이 option_refs로 참조. IMPORT 자재 삭제 금지"}
- 사용처:
- 본문: 미러아크릴스티커 본체 자재(실버 아크릴 3mm). USAGE.07 단일 슬롯. 구 실버(.08)에서 .20 아크릴로 재키잉·현행 정합. 칼라 옵션그룹의 실버아크릴 선택 대상([[optgroup-143-color]] option_refs). 가격 무관(골드/실버 동일가). [[product-143-mirror-acrylic-sticker]] uses_material 대상.

## 공정 노드 (★143 첫 정의 — 레이저커팅·needed_shared 반환)

<!-- ★PROC_000124 레이저커팅(상위 PROC_000121 커팅·06-29 신설)은 KB 최초 등장(axis/processes.md엔 형제 PROC_000122 반칼커팅만). -->
<!-- 143이 canonical 정의 + needed_shared(형제 142 유광아크릴스티커 공유 예정·axis/processes 승격 후보). -->

### [process-PROC_000124] 레이저커팅 (아크릴 절단·mand) {verified}
- type: process
- anchor: t_proc_processes/PROC_000124
- src: {source_file: "live-snapshot/latest/t_proc_processes.csv", source_locator: "테이블:t_proc_processes 키:PROC_000124(proc_nm=레이저커팅·upr_proc_cd=PROC_000121 커팅·06-29 신설·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_processes.csv", source_locator: "키:(PRD_000143,PROC_000124) mand_proc_yn=Y·disp_seq=1·07-01 링크·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {proc_nm: "레이저커팅", upr_proc_cd: "PROC_000121", role: "아크릴 스티커 레이저 절단(필수공정)", note: "143 필수공정(mand_proc_yn=Y). pack §3.7 아크릴스티커 폴더=레이저커팅. UV 인쇄방식(PROC_000002) 공정 행은 별도(라이브 부재·gap-143-uv-print-routing). 142 공유 예정·needed_shared"}
- 사용처:
- 본문: 미러아크릴스티커 필수 절단 공정(mand Y). 아크릴 판재를 규격대로 레이저 절단(커팅 PROC_000121 하위). pack §3.7이 실사 아크릴스티커를 UV PROC_000002 라인으로 지목하나 라이브 product_processes엔 레이저커팅만 부착됨(UV 인쇄방식 공정 행 부재→[[gap-143-uv-print-routing]]). [[product-143-mirror-acrylic-sticker]] has_process 대상(mand 한정자).

## 수량규칙 노드 (product-local)

### [qty-143] 미러아크릴스티커 수량규칙 {verified}
- type: bundle_qty
- anchor: t_prd_products/PRD_000143
- src: {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "키:PRD_000143 min_qty/max_qty/qty_incr(1/10000/1)·qty_unit_typ_cd=QTY_UNIT.01", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/_foundation/batch/qty_rule_audit_260702.py", source_locator: "수량 UI 권위=상품/사이즈 규칙(가격구간과 역할 분리)", captured_at: "2026-07-03", badge: verified, src_id: SR-27-qtyaudit}
- props: {min_max_incr_ref: "전사표 수량규칙(상품 1/10000/1)", bdl_unit_typ_cd: "QTY_UNIT.01", bundle_qtys_rows: 0, note: "★고정가 룩업형이라 수량축이 가격 차원 아님(구성요소 use_dims=[siz_cd]·수량 없음). 셀단가=아크릴스티커1장가·총액=셀×수량(수량구간 할인 없음·t_dsc_* 0행)"}
- 사용처:
- 본문: 수량 그릇 = 상품 마스터 컬럼(min 1·max 10000·incr 1). t_prd_product_bundle_qtys 0행 정상(수량 UI 권위=상품 레벨·[[rule/decisions#DEC_qty_audit_260702]]). 가격은 수량 무관 통가격(siz_cd 룩업).

## 가격공식 노드 (product-local canonical — silsa formula 축 승격 대기·needed_shared)

<!-- ★고정가 룩업형(면적매트릭스·원자합산과 다른 아키타입). 단일 구성요소(완제품가)를 (siz_cd) 셀에서 조회. -->
<!-- has_component 타깃 component-COMP_POSTER_ACRYLSTK_MIRROR = 아래 143 canonical 정의(143 전용·타 상품 미공유). -->

### [formula-PRF_POSTER_ACRYLSTK_MIRROR] 미러아크릴스티커 완제품가 (고정가 룩업·siz_cd) {verified}
- type: price_formula
- anchor: t_prc_price_formulas/PRF_POSTER_ACRYLSTK_MIRROR
- src: {source_file: "live-snapshot/latest/t_prc_price_formulas.csv", source_locator: "테이블:t_prc_price_formulas 키:PRF_POSTER_ACRYLSTK_MIRROR(frm_nm=미러아크릴스티커 완제품가(면적/규격 단가)·note=포스터사인 미러아크릴스티커 소재/사이즈/수량별 완제품 통가격·use_yn=Y)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prc_formula_components.csv", source_locator: "frm_cd:PRF_POSTER_ACRYLSTK_MIRROR(comp COMP_POSTER_ACRYLSTK_MIRROR·disp_seq 1·addtn_yn Y·1행)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_price_formulas.csv", source_locator: "키:(PRD_000143,PRF_POSTER_ACRYLSTK_MIRROR) 바인딩·apply_bgn_ymd=2026-06-01", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: has_component, target: component-COMP_POSTER_ACRYLSTK_MIRROR, qualifier: {disp_seq: 1, addtn: Y}}
- props: {archetype: "고정가 룩업형(fixed·통가격)", use_yn: Y, note: "143 바인딩 전용 공식. 단일 구성요소(완제품가)를 (siz_cd) 4셀에서 조회(evaluate_price). frm_nm '(면적/규격 단가)'는 명명일 뿐·실 use_dims=[siz_cd] 고정 룩업(면적매트릭스 아님·전사표 검증). 130(mat×siz 2축)보다 단순한 siz 단일축"}
- 사용처:
- 본문: 미러아크릴스티커 가격공식. 단일 구성요소(완제품가) 1건 배선 — 아크릴 소재·레이저커팅·출력을 원자 합산하지 않고 (규격 siz_cd) 고정 룩업에서 완제품 통가격을 조회한다. 배선 타깃 [[component-COMP_POSTER_ACRYLSTK_MIRROR]](아래 143 canonical 정의). 고아 공식 아님(has_component 1건). 값 계산=evaluate_price 권위(D-18·[[rule/rules#RULE_price_value_boundary]]).

## 가격구성요소 노드 (product-local canonical — 고정가 룩업·silsa component 축 승격 대기·needed_shared)

<!-- ★COMP_POSTER_ACRYLSTK_MIRROR = 미러아크릴스티커 완제품가(siz_cd 단일축). 143 전용(타 상품 미공유). -->
<!-- ★단가행(4셀)은 노드로 펼치지 않고 use_dims 차원+SHAPE로 접음(D-22). 값(unit_price·단가범위 11000~50000)은 grid shape 증거로만·개별 셀단가 미전사(evaluate_price 권위). -->

### [component-COMP_POSTER_ACRYLSTK_MIRROR] 미러아크릴스티커 완제품가 (siz_cd·고정 룩업) {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_POSTER_ACRYLSTK_MIRROR
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "테이블:t_prc_price_components 키:COMP_POSTER_ACRYLSTK_MIRROR(comp_typ=PRC_COMPONENT_TYPE.06·prc_typ_cd=PRICE_TYPE.01·use_dims=[siz_cd]·note=포스터·사인 완제품가(소재+출력+가공 포함 통가격). 사이즈·수량별 단가표.·use_yn=Y)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/_meta/scripts/cache/transcribed-143-260703.json", source_locator: "grid.COMP_POSTER_ACRYLSTK_MIRROR(행4·사이즈4·자재축 없음·셀 4/4 유효·단가범위 shape 11000~50000)", captured_at: "2026-07-03", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.01", comp_typ_cd: "PRC_COMPONENT_TYPE.06", use_dims: '["siz_cd"]', role: "미러아크릴스티커 완제품 통가격(소재+출력+가공 포함·골드/실버 동일가)", 단가행_ref: "전사표 고정가 shape(4행=규격4·유효격자 4/4·수량축 미충전 min_qty NULL·자재축 없음)", archetype: "고정가 룩업(fixed·siz 단일축·면적매트릭스 아님)"}
- 사용처:
- 본문: 미러아크릴스티커 완제품가 구성요소(canonical·143 전용). use_dims 단일축(사이즈 siz_cd)으로 셀단가가 달라진다(차원 선언까지·D-22 단가행 접기). ★130(mat_cd×siz_cd 2축)과 달리 143은 siz_cd 단일축 — 골드/실버(칼라 옵션)는 mat_cd 컬럼 공란이라 가격 무관(동일가). 유효 4셀(규격 4종·전사표 SHAPE). 값=evaluate_price(개별 셀단가 미전사·단가범위는 grid shape 증거만·D-18·[[rule/rules#RULE_price_value_boundary]]). 단가는 인쇄상품 가격표 260527 verbatim(comp note).

## 옵션그룹 노드 (product-local — 칼라 골드/실버·★option_refs→자재·L-18 정합)

<!-- ★OPT-000046 칼라(SEL_TYPE.01·min0/max1/mand N)·옵션 2(골드아크릴 OPV-000095·실버아크릴 OPV-000096). -->
<!-- option_items가 OPT_REF_DIM.03(자재)로 MAT_000377/378 참조 → option_refs 엣지(ref_key1 한정자·L-18: 타깃이 부모 uses_material에 실재해야 함=정합). -->
<!-- ★130(옵션그룹 0행)과 결정적 차이: 143은 손님 선택 CPQ 축(칼라)이 실재. 단 가격 무관(use_dims=[siz_cd]·동일가). -->

### [optgroup-143-color] 칼라 (골드/실버 아크릴·택1) {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000143
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "키:(PRD_000143,OPT-000046) opt_grp_nm=칼라·sel_typ_cd=SEL_TYPE.01·min_sel_cnt=0·max_sel_cnt=1·mand_yn=N·use_yn=Y·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_option_items.csv", source_locator: "키:(OPV-000095,item1) ref_dim_cd=OPT_REF_DIM.03·ref_key1=MAT_000377·(OPV-000096,item1) ref_dim_cd=OPT_REF_DIM.03·ref_key1=MAT_000378", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: option_refs, target: material-MAT_000377, ref_key1: MAT_000377, note: "골드아크릴(OPV-000095)→아크릴(골드) 3mm"}
- rel: {rel: option_refs, target: material-MAT_000378, ref_key1: MAT_000378, note: "실버아크릴(OPV-000096)→아크릴(실버) 3mm"}
- props: {sel_typ_cd: "SEL_TYPE.01", min_sel_cnt: 0, max_sel_cnt: 1, mand_yn: "N", options: "골드아크릴 OPV-000095·실버아크릴 OPV-000096", ref_dim: "OPT_REF_DIM.03 자재", note: "★칼라=자재(골드/실버) 선택이나 가격 무관(use_dims=[siz_cd]·동일가). option_refs 타깃 MAT_000377/378이 부모 uses_material에 실재(fn_chk_opt_item_ref·L-18 정합)"}
- 사용처:
- 본문: 미러아크릴스티커 칼라 옵션그룹(골드/실버 아크릴 택1·max_sel 1·mand N). 두 옵션(골드아크릴·실버아크릴)이 option_items로 OPT_REF_DIM.03(자재) → MAT_000377/378을 각각 참조(다형참조·polymorphic ref_dim_cd). ★타깃 자재가 부모 상품(143)의 uses_material 차원에 실재하므로 fn_chk_opt_item_ref 무결성 트리거 정합(L-18 통과). ★130(옵션그룹 0행)과 달리 143은 손님 선택 CPQ 축이 실재하나, 골드/실버가 가격을 바꾸지 않음(가격 use_dims=[siz_cd]·동일가). [[product-143-mirror-acrylic-sticker]] has_option_group 대상.

## GAP 노드 (원천 부재·정직 선언)

### [gap-143-uv-print-routing] 아크릴스티커 UV 인쇄방식 공정 행 부재 {unknown}
- type: gap
- anchor: none  # 사유: pack §3.7이 아크릴스티커를 UV PROC_000002 라인으로 지목하나 라이브 product_processes엔 레이저커팅만·UV 인쇄방식 공정 행 없음
- src: {source_file: "live-snapshot/latest/t_prd_product_processes.csv", source_locator: "키:PRD_000143 = PROC_000124 레이저커팅 1행만(mand Y)·UV PROC_000002 행 없음·print_options 0행", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "문서:§3.7 GAP 아크릴스티커 UV 라우팅 공정 행 추가 여부(Q-SL-A·영향 작음)", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-silsa}
- gap_what: "pack §3.7은 유광아크릴스티커142·미러아크릴스티커143이 UV PROC_000002 인쇄 라인이라 지목하나, 라이브 143 product_processes엔 레이저커팅(PROC_000124) 절단 공정만 부착됨. UV 인쇄방식(PROC_000002·변형 enum 보유)을 인쇄 공정으로 별도 행 추가해야 하는지, 아니면 실사 공통(도수 없음·po=0)처럼 인쇄방식 공정 행이 원래 없는 게 맞는지 미확정(Q-SL-A·pack '영향 작음')"
- gap_fill_from: "실무진 + pack §3.7(아크릴스티커 UV 라우팅)·webadmin 실화면(143 옵션/공정 UI에 UV 인쇄방식 노출 여부)"
- gap_owner: staff
- 본문: 가격 경로는 연결됨([[formula-PRF_POSTER_ACRYLSTK_MIRROR]]→[[component-COMP_POSTER_ACRYLSTK_MIRROR]]·유효 4/4셀)이라 견적 0 위험 없음. 다만 pack이 UV 인쇄방식으로 분류한 것과 라이브(레이저커팅만 부착·인쇄방식 공정 행 부재)가 표면상 어긋나 정직 선언. 영향 작음(pack 판정)·완제품 통가격이 인쇄 포함이면 별도 공정 행 불요일 수 있음.

### [gap-143-fixedprice-basis] 아크릴스티커 완제품 통가격 산정 근거 문서 부재 {unknown}
- type: gap
- anchor: none  # 사유: 고정가 4셀 완제품 통가격(소재+출력+가공)이 어떤 규칙으로 산정됐는지 엑셀 미기재 암묵지
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/source-registry.md", source_locator: "문서:§9 GAP-2 롤 소재 가격 계산 로직(엑셀 미기재 암묵지·실사 전체 영향)", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-silsa}
- gap_what: "고정가 4셀(규격별) 완제품 통가격이 아크릴 판재비+레이저커팅비+출력비를 어떤 규칙으로 통합해 산출됐는지 — 값은 라이브에 적재됐고(260527 verbatim) 라이브 셀단가=가격표 원본이나 산정식 자체는 문서 부재(실사 전체 공통)"
- gap_fill_from: "실무진 확인(source-registry §9 GAP-2·실사 전체 공통). 예전사이트 골든 대조로 값 정합 검증 가능하나 산정식은 암묵지"
- gap_owner: staff
- 본문: 가격 경로는 연결됨([[formula-PRF_POSTER_ACRYLSTK_MIRROR]]→[[component-COMP_POSTER_ACRYLSTK_MIRROR]]·유효 4/4셀 완전격자)이라 견적 0 위험 없음. 다만 통가격이 **어떻게** 산정됐는지는 엑셀 미기재 암묵지(실사 전체 공통 GAP). 온톨로지는 연결·차원까지, 값 계산은 evaluate_price 권위이므로 이 GAP은 값 정합이 아니라 "산정 근거 문서 부재"의 정직 선언.
