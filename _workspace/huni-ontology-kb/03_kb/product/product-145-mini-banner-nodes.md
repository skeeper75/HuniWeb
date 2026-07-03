<!-- product-local sub-nodes: E3 size 2·E8 bundle_qty·E9 price_formula·E10 price_component·E11 option_group 1·gap 2 for PRD_000145 미니배너. -->
<!-- ★공유 노드 재사용(중복 mint 방지·L-3·재정의 안 함·참조만): -->
<!--   - category-CAT_000097(POP·부모 CAT_000005 사인·lvl2) = 병렬 형제 product-144-mini-board-standing-nodes(미니보드스탠딩)가 canonical 정의 → 145 main이 in_category로 참조만(needed_shared). -->
<!--   - material-MAT_000178(PET·MAT_TYPE.08 실사소재) = axis/materials.md가 canonical 정의(039/120/135/136 횡단) → 145 main이 uses_material로 참조만. -->
<!--   - process-PROC_000014(유광라미)·PROC_000015(무광라미) = axis/processes.md canonical → 145 main이 has_process로, optgroup-145-coating이 option_refs로 참조만(재사용). -->
<!-- ★여기 정의(145 고유·타 빌더 미정의): size 2(SIZ_000028·SIZ_000328)·qty·optgroup 1(코팅)·formula(PRF_POSTER_MINI_BANNER·needed_shared)·component(COMP_POSTER_MINI_BANNER·needed_shared)·gap 2. -->
<!-- ★수치(사이즈·격자 shape·옵션 shape)는 아래 전사표(transcribed-by·transcribe_product_145.py)에만. props raw 미기입(D-9·L-12). -->
<!-- ★가격 값(unit_price)은 전사하지 않음 — 연결·차원·격자완전성까지만(D-18·값=evaluate_price). 고정가 셀 단가범위는 grid shape 증거만. -->

# product-145 하위 노드 (미니배너 전용 축 원자 + 공식/GAP)

미니배너(PRD_000145)가 쓰는 POP 카테고리·150×300/180×420 규격 사이즈 2·가격공식·구성요소·수량규칙·
CPQ 코팅 옵션그룹 1·GAP 2. 상품→축 연결(has_size·uses_material·has_process·priced_by·has_qty_rule·
has_option_group·in_category)은 [[product-145-mini-banner]]가 건다. PET 자재(MAT_000178)·라미네이팅
공정(PROC_000014/015)은 **공유 노드 재사용**(위 주석·재정의 안 함). 공식→구성요소 배선(has_component)은
아래 formula 블록.

## 상품 요소 전사표 (권위 = 라이브 마스터·스크립트 전사)

> 아래 표는 모두 `_meta/scripts/transcribe_product_145.py`가 live-snapshot(snap_20260702_1119)에서 결정론
> 전사(LLM 손전사 금지·D-9). 캐시=`_meta/scripts/cache/transcribed-145-260703.json`. 실사 시트는 260702 diff
> 무영향(pack §5.5)이라 라이브 현재값=권위 정합(양면 소재 없음·PET .08은 실사소재 현재값 정합).

### 상품 정체·수량 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_145.py from live-snapshot/latest (snap_20260702_1119) t_prd_products PRD_000145 @ 2026-07-03 -->
| prd_typ_cd | nonspec | min_qty | max_qty | qty_incr | qty_unit | file_upload | editor | use_yn |
|---|---|---|---|---|---|---|---|---|
| PRD_TYPE.01 | N | 1 | 10000 | 1 | QTY_UNIT.01 | Y | N | Y |

> nonspec_yn=N → 비규격 연속범위 없음(이산 규격 2종 150x300·180x420만). 수량 min1/max10000/incr1(제품 레벨).
> ★상품 min_qty=1인데 가격격자 최저 수량구간=min_qty 4(아래 격자표) — 수량 1~3 가격 tier 부재는 GAP(gap-145-qtytier-floor).

### 카테고리 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_145.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_categories+t_cat_categories @ 2026-07-03 -->
| cat_cd | 이름 | 부모 | lvl | main_cat_yn(링크) |
|---|---|---|---|---|
| CAT_000097 | POP | CAT_000005 | 2 | N |

> ★junction 1행(CAT_000097 POP·lvl2)만. 부모 CAT_000005(사인·root)는 카테고리 계층(upr_cat_cd)이지 junction 링크 아님. CAT_000097은 미니류(144 미니보드스탠딩 형제) 공유 leaf — 144가 in_category로 참조만 하고 def block 미생성이라 145가 companion mint(canonical·needed_shared).

### 사이즈 (전사·전 행·del 표기·nonspec_yn=N 이산 2규격)

<!-- transcribed-by: _meta/scripts/transcribe_product_145.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_sizes+t_siz_sizes @ 2026-07-03 -->
| siz_cd | 라벨 | 작업(mm) | impos_yn | nonspec | dflt | 링크 del | 마스터 del | 마스터 note |
|---|---|---|---|---|---|---|---|---|
| SIZ_000028 | 150x300 | 152x302 | N | N | Y | N | N | 판걸이=3.0 / 전지=316x467 / 적용=3단접지카드 |
| SIZ_000328 | 180x420 | 180x420 | N | N | Y | N | N | - |

> ★SIZ_000028(150x300)·SIZ_000328(180x420) 둘 다 dflt_yn=Y(데이터 특이·전사 그대로). SIZ_000028 마스터 note '판걸이=3.0 / 전지=316x467 / 적용=3단접지카드'는 공유 마스터 사이즈의 카드 잔재 — 비종이류 배너(145)엔 무관(판형 del·판걸이 로직 미적용·T-7). 145 전용 mint(KB 미존재).

### 자재 (전사·★PET MAT_TYPE.08 실사소재·axis/materials canonical 재사용)

<!-- transcribed-by: _meta/scripts/transcribe_product_145.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_materials+t_mat_materials @ 2026-07-03 -->
| mat_cd | 이름 | mat_typ | 상위자재 | usage_cd | dflt |
|---|---|---|---|---|---|
| MAT_000178 | PET | MAT_TYPE.08 | (공백·부모) | USAGE.07 | Y |

> ★PET MAT_000178 = MAT_TYPE.08 실사소재(현재값·pack §3.5 PET 실사소재). material-MAT_000178은 axis/materials.md가 canonical 정의(039 투명명함/120 방수/135 족자/136 PET배너 횡단·공유 축)이라 145는 재사용만(재정의 안 함·L-3). ★IMPORT 등록 자재 삭제 금지(RULE_import_material_no_delete).

### 공정 (전사·유광/무광 라미네이팅·mand N·코팅 옵션이 선택)

<!-- transcribed-by: _meta/scripts/transcribe_product_145.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_processes+t_proc_processes @ 2026-07-03 -->
| proc_cd | 공정명 | 상위공정 | mand | prcs_dtl_opt(param) | 링크 del |
|---|---|---|---|---|---|
| PROC_000015 | 무광라미네이팅 | PROC_000013 | N | `(없음)` | N |
| PROC_000014 | 유광라미네이팅 | PROC_000013 | N | `(없음)` | N |

> ★PROC_000014 유광라미네이팅·PROC_000015 무광라미네이팅(부모 PROC_000013 라미네이팅)·둘 다 mand N. 코팅 CPQ 옵션(OPT_000024)이 이 두 공정을 택1 참조(option_refs·OPT_REF_DIM.04). process-PROC_000014/015는 axis/processes.md canonical 재사용(재정의 안 함).

### 판형 (전사·전 행·del 표기 — ★비종이류=판형 무의미·del_yn=Y)

<!-- transcribed-by: _meta/scripts/transcribe_product_145.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_plate_sizes @ 2026-07-03 -->
| siz_cd | output_paper_typ | output_file | dflt | del | note |
|---|---|---|---|---|---|
| SIZ_000028 | (공백) | JPG | Y | Y | 파일사양 |
| SIZ_000328 | (공백) | JPG | Y | Y | 파일사양 |

> ★plate 2행 전부 del_yn=Y(06-30 정리)·output_paper_typ 공백. 비종이류(대형 롤 배너)라 판형·판걸이수 무의미(has_plate_size 엣지 0=정상·pack §3.8·T-7·RULE_plate_paper_only).

### CPQ 옵션 레이어 (전사·★137과 차이·1그룹 코팅)

<!-- transcribed-by: _meta/scripts/transcribe_product_145.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_option_groups+t_prd_product_options @ 2026-07-03 -->
| opt_grp_cd | 그룹명 | sel_typ | min/max_sel | mand | 옵션값(opt_cd·dflt) | 그룹 note |
|---|---|---|---|---|---|---|
| OPT_000024 | 코팅 | SEL_TYPE.01 | 0/1 | N | 무광코팅(OPV_000046·dflt=Y) / 유광코팅(OPV_000047·dflt=N) | 코팅 택1 선택 |

### CPQ 옵션 아이템 (전사·다형참조 ref_dim_cd)

<!-- transcribed-by: _meta/scripts/transcribe_product_145.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_option_items @ 2026-07-03 -->
| opt_cd | item_seq | ref_dim_cd | ref_key1 | ref_key2 | qty |
|---|---|---|---|---|---|
| OPV_000046 | 1 | OPT_REF_DIM.04 | PROC_000015 | - | 1 |
| OPV_000047 | 1 | OPT_REF_DIM.04 | PROC_000014 | - | 1 |

> ★OPV_000046 무광코팅(dflt) → OPT_REF_DIM.04(공정)·ref_key1=PROC_000015(무광라미)·qty 1. OPV_000047 유광코팅 → ref_key1=PROC_000014(유광라미). 두 옵션 다 145 has_process에 실재(L-18 부모정합 통과). ★코팅은 공정 선택(마감)이지 별도 가격 component 배선 없음 — 통가격에 포함.

### 미보유 축 (전사·0행 실측)

<!-- transcribed-by: _meta/scripts/transcribe_product_145.py from live-snapshot/latest (snap_20260702_1119) print_options/bundle_qtys/addons/constraints/sets @ 2026-07-03 -->
| 축 | 행수 |
|---|---|
| print_options(도수) | 0 |
| bundle_qtys(묶음수) | 0 |
| addons(추가상품) | 0 |
| constraints(제약규칙) | 0 |
| sets(셋트 부모) | 0 |
| option_groups(CPQ 옵션) | 1 |

> ★addons/sets 0행 = 정합(거치대가 통가격 baked·'[출력+코팅+거치대 포함가]'라 별도 부속 불요·137 standoff BLOCKED과 대비). constraints 0행 = 정합(145는 신규발현 7상품 118/120/121/122/124/125/139에 미포함·nonspec_yn=N이라 치수범위 제약 불필요).

### 가격 배선 (전사·priced_by→공식→구성요소)

<!-- transcribed-by: _meta/scripts/transcribe_product_145.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_price_formulas+t_prc_formula_components+t_prc_price_components @ 2026-07-03 -->

공식 **PRF_POSTER_MINI_BANNER** — 미니배너 완제품가(면적/규격 단가) (use_yn=Y)

| disp_seq | comp_cd | addtn | prc_typ | comp_nm | use_dims |
|---|---|---|---|---|---|
| 1 | COMP_POSTER_MINI_BANNER | Y | PRICE_TYPE.01 | 미니배너 완제품가 | `["siz_cd", "min_qty"]` |

### 고정가 룩업 셀 요약 (전사·D-22 접기 — 전개 금지·값=range shape 증거만·개별값 미노출)

<!-- transcribed-by: _meta/scripts/transcribe_product_145.py from live-snapshot/latest (snap_20260702_1119) t_prc_component_prices (COMP_POSTER_MINI_BANNER 집계) @ 2026-07-03 -->
| comp_cd | use_yn | 행수 | 사이즈축 | 수량구간축(min_qty) | 셀존재/잠재 | 단가범위(shape) | use_dims |
|---|---|---|---|---|---|---|---|
| COMP_POSTER_MINI_BANNER | Y | 10 | SIZ_000028/SIZ_000328 | 4/19/49/99/10000 | 10/10 | 2800~6500 | `["siz_cd", "min_qty"]` |

> ★셀존재/잠재 = 사이즈 2(SIZ_000028·SIZ_000328) × 수량구간 5(min_qty 4/19/49/99/10000) = 10셀 전부 실재
> (격자완전 True·137과 달리 다-tier 수량할인 실재). use_dims=[siz_cd, min_qty]=규격×수량구간 블록
> (면적매트릭스 아님·siz_width/siz_height 미사용). 통가격=출력+코팅+거치대 포함(가격 note).
> 단가범위는 격자 shape 증거일 뿐 — 개별 셀단가·계산=evaluate_price 권위(D-18·값 노드 미기록).
> ★수량구간 최저 tier=min_qty 4(상품 min_qty 1과 불일치) — 수량 1~3 tier 부재=GAP(gap-145-qtytier-floor).

## 카테고리 노드 (★재사용 — 144 미니보드스탠딩이 canonical·재정의 안 함·L-3 회피)

<!-- ★category-CAT_000097(POP·부모 CAT_000005 사인·lvl2)은 병렬 형제 product-144-mini-board-standing-nodes(미니보드스탠딩)가 -->
<!-- companion mint(canonical·needed_shared)한 공유 축이라 145는 참조만(재정의 금지·L-3 중복 회피). -->
<!-- 144/145 둘 다 실사 미니류(POP)로 같은 CAT_000097 leaf 공유. 145 main이 in_category→category-CAT_000097로 참조(빌더가 144 정의로 해소). -->
<!-- consolidation이 144/145 중 canonical 선정·향후 axis/categories.md 승격(needed_shared 반환). -->
<!-- 부모 CAT_000005(사인·root)는 카테고리 계층(props upr_cat_cd)이지 노드 미생성(145 junction 미링크·orphan 회피). -->
<!-- 카테고리 전사값은 위 '카테고리 (전사)' 표(CAT_000097 POP·lvl2)에 이미 기록·144 canonical과 동일 실측. -->

## 사이즈 노드 (product-local — 150x300·180x420 이산 2규격)

<!-- ★size-SIZ_000028(150x300)·size-SIZ_000328(180x420)은 KB 미존재라 145 전용 mint. -->
<!-- SIZ_000028 마스터 note는 공유 마스터 사이즈의 카드 잔재(비종이류 배너엔 무관·판형 del·T-7). 145 가격 격자는 이 두 siz_cd × 수량구간 룩업. -->

### [size-SIZ_000028] 미니배너 규격 (150x300) {verified}
- type: size
- anchor: t_prd_product_sizes/PRD_000145
- src: {source_file: "live-snapshot/latest/t_prd_product_sizes.csv", source_locator: "키:(PRD_000145,SIZ_000028) dflt_yn=Y·disp_seq=1·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "키:SIZ_000028(siz_nm=150x300·work 152x302·impos_yn=N·del_yn=N·note '판걸이=3.0 / 전지=316x467 / 적용=3단접지카드')", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm: "150x300", work_dim_ref: "전사표 사이즈(작업 152x302·재단 150x300)", impos_yn: "N", dflt_yn: "Y", note: "★공유 마스터 사이즈(150x300)이나 마스터 note '판걸이=3.0/전지=316x467/적용=3단접지카드'는 카드 잔재 — 비종이류 배너(145)엔 무관(판형 del_yn=Y·판걸이수 로직 미적용·T-7·RULE_plate_paper_only). 145 가격 격자의 사이즈축 키"}
- 본문: 미니배너 이산 규격 1(150×300mm). [[product-145-mini-banner]] has_size 대상. 가격 구성요소 [[component-COMP_POSTER_MINI_BANNER]] use_dims의 siz_cd 축(SIZ_000328과 함께 규격 2). 마스터 note의 판걸이/전지 값은 종이류 카드 잔재로 배너엔 미적용(비종이류·판형 del).

### [size-SIZ_000328] 미니배너 규격 (180x420) {verified}
- type: size
- anchor: t_prd_product_sizes/PRD_000145
- src: {source_file: "live-snapshot/latest/t_prd_product_sizes.csv", source_locator: "키:(PRD_000145,SIZ_000328) dflt_yn=Y·disp_seq=1·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "키:SIZ_000328(siz_nm=180x420·work 180x420·impos_yn=N·del_yn=N·note 공백)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm: "180x420", work_dim_ref: "전사표 사이즈(작업 180x420·재단 180x420)", impos_yn: "N", dflt_yn: "Y", note: "미니배너 2번째 이산 규격. SIZ_000028과 함께 둘 다 dflt_yn=Y(데이터 특이·전사 그대로). 가격 격자의 사이즈축 키"}
- 본문: 미니배너 이산 규격 2(180×420mm). [[product-145-mini-banner]] has_size 대상. 가격 구성요소 use_dims의 siz_cd 축(SIZ_000028과 규격 2). SIZ_000028과 함께 두 규격 모두 dflt_yn=Y로 표기된 데이터 특이(전사 그대로·단정 아님).

## 수량규칙 노드 (product-local)

### [qty-145] 미니배너 수량규칙 {verified}
- type: bundle_qty
- anchor: t_prd_products/PRD_000145
- src: {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "키:PRD_000145 min_qty/max_qty/qty_incr(1/10000/1)·qty_unit_typ_cd=QTY_UNIT.01", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/_foundation/batch/qty_rule_audit_260702.py", source_locator: "수량 UI 권위=상품/사이즈 규칙(가격구간과 역할 분리)", captured_at: "2026-07-03", badge: verified, src_id: SR-27-qtyaudit}
- props: {min_max_incr_ref: "전사표 수량규칙(상품 1/10000/1)", bdl_unit_typ_cd: "QTY_UNIT.01", bundle_qtys_rows: 0, note: "★137과 달리 145는 구성요소 use_dims 수량구간(min_qty)이 다-tier(4/19/49/99/10000)=실제 수량할인 격자(단가 6500→2800). t_prd_product_bundle_qtys 0행 정상(수량 UI 권위=상품 레벨). ★격자 최저 tier=min_qty 4 vs 상품 min_qty 1 불일치=gap-145-qtytier-floor"}
- 본문: 수량 그릇 = 상품 마스터 컬럼(min 1·max 10000·incr 1). t_prd_product_bundle_qtys 0행 정상(수량 UI 권위=상품 레벨·[[rule/decisions#DEC_qty_audit_260702]]). 가격 격자에 min_qty 축이 다-tier로 실재(수량할인)하나 최저 tier가 min_qty 4라 상품 min_qty 1과 불일치([[product-145-mini-banner-nodes#gap-145-qtytier-floor]]).

## CPQ 옵션그룹 노드 (product-local — 145 CPQ 1그룹·코팅 옵션→라미 공정)

<!-- ★145 코팅 옵션그룹(OPT_000024·mand N·택1)의 option_refs 타깃 PROC_000015(무광라미·dflt)·PROC_000014(유광라미)는 -->
<!-- 145 has_process에 실재(L-18 부모정합 통과). 코팅은 공정 선택(마감)이지 별도 가격 component 배선 없음(통가격 포함). -->

### [optgroup-145-coating] 코팅 (무광/유광·택1·mand N) {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000145
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "키:(PRD_000145,OPT_000024)(opt_grp_nm=코팅·SEL_TYPE.01·min_sel=0·max_sel=1·mand_yn=N·use_yn=Y·del_yn=N·note '코팅 택1 선택')", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_options.csv", source_locator: "키:(PRD_000145,OPT_000024) OPV_000046 무광코팅(dflt_yn=Y)·OPV_000047 유광코팅(dflt_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_option_items.csv", source_locator: "키:(PRD_000145,OPV_000046,item_seq 1) ref_dim_cd=OPT_REF_DIM.04·ref_key1=PROC_000015·qty=1 + (PRD_000145,OPV_000047,item_seq 1) ref_key1=PROC_000014", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: option_refs, target: process-PROC_000015, ref_key1: PROC_000015, note: "무광코팅(OPV_000046·dflt)→공정 무광라미네이팅(OPT_REF_DIM.04)"}
- rel: {rel: option_refs, target: process-PROC_000014, ref_key1: PROC_000014, note: "유광코팅(OPV_000047)→공정 유광라미네이팅(OPT_REF_DIM.04)"}
- props: {opt_grp_cd: "OPT_000024", sel_typ_cd: "SEL_TYPE.01", mand_yn: "N", 옵션값: "무광코팅(dflt·PROC_000015) / 유광코팅(PROC_000014)·택1", ref_dim: "OPT_REF_DIM.04=공정(라미네이팅=완제품 통가격 포함·별도 가산 아님)", note: "코팅은 생산 마감 선택이지 가격 component 배선 없음 — 통가격('[출력+코팅+거치대 포함가]')에 baked"}
- 본문: 손님이 코팅을 고르는 CPQ 옵션(택1·mand N·기본 무광). 두 option_item이 각각 공정 PROC_000015(무광라미)·PROC_000014(유광라미)를 가리켜(R11 option_refs·OPT_REF_DIM.04) has_process 차원으로 환원(L-18 통과·부모 145 has_process에 두 공정 실재). ★코팅 선택이 별도 가격을 더하지 않는다 — 공식 단일 구성요소(COMP_POSTER_MINI_BANNER)가 코팅 포함 통가격이라 코팅은 생산 마감 지시(가격 무영향). 137 4구타공과 동형(옵션이 공정을 가리키되 통가격 포함).

## 가격공식 노드 (product-local — silsa formula 축 승격 대기·needed_shared)

<!-- ★고정가 룩업형(규격×수량구간·면적매트릭스·원자합산과 다른 아키타입). 단일 구성요소(완제품가)를 (siz_cd×min_qty) 셀에서 조회. -->
<!-- has_component 타깃 component-COMP_POSTER_MINI_BANNER = 아래 145 canonical 정의(145 전용·타 상품 미공유). -->

### [formula-PRF_POSTER_MINI_BANNER] 미니배너 완제품가 (고정가 룩업·규격×수량구간) {verified}
- type: price_formula
- anchor: t_prc_price_formulas/PRF_POSTER_MINI_BANNER
- src: {source_file: "live-snapshot/latest/t_prc_price_formulas.csv", source_locator: "테이블:t_prc_price_formulas 키:PRF_POSTER_MINI_BANNER(frm_nm=미니배너 완제품가(면적/규격 단가)·note=포스터사인 미니배너 소재/사이즈/수량별 완제품 통가격·use_yn=Y)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prc_formula_components.csv", source_locator: "frm_cd:PRF_POSTER_MINI_BANNER(comp COMP_POSTER_MINI_BANNER·disp_seq 1·addtn_yn Y·1행)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_price_formulas.csv", source_locator: "키:(PRD_000145,PRF_POSTER_MINI_BANNER) 바인딩·apply_bgn_ymd=2026-06-01", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: has_component, target: component-COMP_POSTER_MINI_BANNER, qualifier: {disp_seq: 1, addtn: Y}}
- props: {archetype: "고정가 룩업형(fixed·통가격)", use_yn: Y, note: "145 바인딩 전용 공식. 단일 구성요소(완제품가)를 (siz_cd×min_qty) 셀에서 조회(evaluate_price). frm_nm '(면적/규격 단가)'는 명명일 뿐·실 use_dims=[siz_cd,min_qty] 고정 룩업(면적매트릭스 아님·전사표 검증). ★118~128 면적매트릭스와 다른 아키타입"}
- 본문: 미니배너 가격공식. 단일 구성요소(완제품가) 1건 배선 — 출력·코팅·거치대를 원자 합산하지 않고 (규격×수량구간) 고정 룩업에서 완제품 통가격을 조회한다. 배선 타깃 [[component-COMP_POSTER_MINI_BANNER]](아래 145 canonical 정의). 고아 공식 아님(has_component 1건·O6 충족·pack §27 정합). 값 계산=evaluate_price 권위(D-18·[[rule/rules#RULE_price_value_boundary]]). 공유 formula 파일 미등재·승격 대기(needed_shared·실사 고정가 15상품 축).

## 가격구성요소 노드 (product-local canonical — 고정가 룩업·silsa component 축 승격 대기·needed_shared)

<!-- ★COMP_POSTER_MINI_BANNER = 미니배너 완제품가(규격×수량구간·다-tier). 145 전용(타 상품 미공유). -->
<!-- ★단가행(10셀)은 노드로 펼치지 않고 use_dims 차원+SHAPE로 접음(D-22). 값(unit_price)은 grid shape 증거로만·개별 셀단가 미전사(evaluate_price 권위). -->

### [component-COMP_POSTER_MINI_BANNER] 미니배너 완제품가 (규격×수량구간·고정 룩업) {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_POSTER_MINI_BANNER
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "테이블:t_prc_price_components 키:COMP_POSTER_MINI_BANNER(comp_typ=PRC_COMPONENT_TYPE.06·prc_typ_cd=PRICE_TYPE.01·use_dims=[siz_cd,min_qty]·note '포스터·사인 완제품가(소재+출력+가공 포함 통가격). 사이즈·수량별 단가표.'·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/_meta/scripts/cache/transcribed-145-260703.json", source_locator: "grid.COMP_POSTER_MINI_BANNER(행10·사이즈 SIZ_000028/SIZ_000328·수량구간 4/19/49/99/10000·셀 10/10 유효·단가범위 shape 2800~6500)", captured_at: "2026-07-03", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.01", comp_typ_cd: "PRC_COMPONENT_TYPE.06", use_dims: '["siz_cd", "min_qty"]', role: "미니배너 완제품 통가격(소재+출력+코팅+거치대 포함)", 단가행_ref: "전사표 고정가 shape(10행=규격2×수량구간5·유효격자 10/10·다-tier 수량할인)", archetype: "고정가 룩업(fixed·규격×수량구간·면적매트릭스 아님)"}
- 본문: 미니배너 완제품가 구성요소(canonical·145 전용). use_dims 2축(사이즈 siz_cd × 수량구간 min_qty)으로 셀단가가 달라진다(차원 선언까지·D-22 단가행 접기). 라이브 격자는 규격2(150×300·180×420)×수량구간5(min_qty 4/19/49/99/10000) = 유효 10셀(전사표 SHAPE·격자완전). 값=evaluate_price(개별 셀단가 미전사·단가범위는 grid shape 증거만·D-18·[[rule/rules#RULE_price_value_boundary]]). 단가는 인쇄상품 가격표 260527 verbatim(comp note). 통가격에 거치대 포함(가격 note '[출력+코팅+거치대 포함가]'). 공유 component 파일 미등재·승격 대기(needed_shared).

## GAP 노드 (원천 부재·정직 선언)

### [gap-145-qtytier-floor] 수량 tier floor 불일치 — 상품 min_qty 1 vs 격자 최저 4 {unknown}
- type: gap
- anchor: none  # 사유: 상품 min_qty=1인데 가격격자 최저 수량구간 min_qty=4 — 수량 1~3의 가격 tier 부재(어떻게 청구되는지 확정 원천 부재)
- src: {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "키:PRD_000145 min_qty=1(상품 수량규칙) vs t_prc_component_prices COMP_POSTER_MINI_BANNER 최저 min_qty=4(격자표 4/19/49/99/10000)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "문서:§3.4 수량규칙(수량 UI 권위=상품/사이즈 규칙·가격구간과 역할 분리)·[[rule/decisions#DEC_qty_audit_260702]]", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-silsa}
- gap_what: "상품 마스터 min_qty=1인데 가격 구성요소(COMP_POSTER_MINI_BANNER) 수량구간 격자의 최저 tier가 min_qty=4('수량 4 이상'). evaluate_price가 요청 수량의 tier를 min_qty≤qty로 고르면 수량 1~3은 매칭 tier가 없어 가격 미정(0/폴백 가능). 이것이 의도된 실질 최소주문(4부)인지, 아니면 수량 1~3 tier 누락 결함인지 확정 원천 부재. 참고: 엽서북 '1부 0원=단가표 2부 시작 정상' 선례처럼 저수량 tier 부재가 정상일 수 있음(qty-system-audit-260702)"
- gap_fill_from: "실무진 확인(수량 1~3 실질 청구 규칙·min 주문 정책) + pack §3.4 수량 UI 권위=상품 수량규칙 vs 가격구간 역할 분리 원칙. 예전사이트 골든 대조로 수량 1~3 청구값 검증 가능"
- gap_owner: staff
- 본문: 가격 경로 자체는 연결됨([[formula-PRF_POSTER_MINI_BANNER]]→[[component-COMP_POSTER_MINI_BANNER]]·유효 10/10셀 격자완전)이라 수량 4 이상은 견적 정상. 다만 상품 min_qty=1과 격자 최저 tier min_qty=4의 불일치로 수량 1~3의 가격이 미정 — 의도된 최소주문 4부인지 tier 누락인지 원천 부재(정직 선언·수량 UI 권위=상품 규칙·가격구간 역할 분리·pack §3.4).

### [gap-145-fixedprice-basis] 배너 완제품 통가격 산정 근거 문서 부재 {unknown}
- type: gap
- anchor: none  # 사유: 고정가 셀 완제품 통가격(소재+출력+코팅+거치대)이 어떤 규칙으로 산정됐는지 엑셀 미기재 암묵지
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/source-registry.md", source_locator: "문서:§9 GAP-2 롤 소재 가격 계산 로직(엑셀 미기재 암묵지·실사 전체 영향)", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-silsa}
- gap_what: "고정가 격자(규격2×수량구간5=10셀) 완제품 통가격이 PET 소재 롤 원가+대형 잉크젯 출력비+라미네이팅 코팅+거치대(스탠드)비를 어떤 규칙으로 통합해 산출됐는지 — 값은 라이브에 적재됐고(260527 verbatim·2800~6500) 라이브 셀단가=가격표 원본이나 산정식 자체는 문서 부재(롤 소재 실사 전체 공통 GAP)"
- gap_fill_from: "실무진 확인(source-registry §9 GAP-2·실사 전체 공통·롤 소재 가격 계산 로직). 예전사이트 골든 대조로 값 정합 검증 가능하나 산정식은 암묵지"
- gap_owner: staff
- 본문: 가격 경로는 연결됨([[formula-PRF_POSTER_MINI_BANNER]]→[[component-COMP_POSTER_MINI_BANNER]]·유효 10/10셀 완전격자)이라 견적 0 위험 없음. 다만 통가격이 **어떻게** 산정됐는지는 엑셀 미기재 암묵지(실사 롤 소재 전체 공통 GAP·source-registry §9 GAP-2). 온톨로지는 연결·차원까지, 값 계산은 evaluate_price 권위이므로 이 GAP은 값 정합이 아니라 "산정 근거 문서 부재"의 정직 선언. 145는 PET 대형 롤+거치대 통가격이라 "롤 소재 가격 계산 로직" GAP에 직접 해당.
