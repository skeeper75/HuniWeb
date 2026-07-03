<!-- companion nodes for product-133 캔버스 행잉포스터 — 공유 축(axis/*·formula/*·rule/*)에 없는 상품 전용 마스터 노드. -->
<!-- ★공유 파일 수정 금지 규칙에 따라, axis/*·formula/*·rule/*에 없는 것만 여기 신설(125 방식). -->
<!-- ★재사용 참조(중복 mint 금지·L-3): category-CAT_000004(119 owner)·category-CAT_000080(131 owner·129~134 공유)·size-SIZ_000172/174(product-047 owner)·size-SIZ_000197(axis/sizes.md owner)·material-MAT_000185·process-PROC_000080(125 owner). 여기서 신규 mint=공식 PRF_POSTER_CANVAS_HANGING·구성요소 2·옵션그룹 2·GAP 2뿐. -->
<!-- ★수치(치수·규격 단가행·배선)는 전사 스크립트 transcribe_product_133.py 출력만(transcribed-by 마커). LLM 손전사 금지. -->

# product-133 전용 노드 (캔버스 행잉포스터 — 실사 고정가형 전용 마스터 축)

[[product-133-canvas-hanging-poster]]가 연결하는 축 중 **다른 파일이 이미 소유한 노드(카테고리 root·A계열
사이즈·캔버스 자재·봉제 공정)는 재사용 참조**하고, 133 전용만 여기 신설한다. 판형(plate_size)은 실사
비종이류라 노드 없음(전 행 논리삭제·pack §3.8·T-7). 인쇄옵션(도수)도 없음(실사 대형잉크젯 풀컬러·po=0).
★133 = **고정가형**([규격×수량] 단가·pack §3.10) — 면적매트릭스형(118~128) 아님.

---

## 전사표 (권위 = 라이브 스냅샷·스크립트 전사)

> 아래 표는 `_meta/scripts/transcribe_product_133.py`가 live-snapshot에서 결정론 전사(손전사 아님).
> `python3 transcribe_product_133.py` 재실행 시 동일 출력(멱등). JSON 캐시=`cache/transcribed-133-260703.json`.

### 상품 정체·수량 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_133.py from live-snapshot/latest (snap_20260702_1119) t_prd_products PRD_000133 @ 2026-07-03 -->
| prd_nm | prd_typ_cd | nonspec | min_qty | max_qty | qty_incr | qty_unit | file_upload | editor | use_yn | del_yn |
|---|---|---|---|---|---|---|---|---|---|---|
| 캔버스 행잉포스터 | PRD_TYPE.01 | N | 1 | 10000 | 1 | QTY_UNIT.01 | Y | Y | Y | N |

### 카테고리 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_133.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_categories+t_cat_categories @ 2026-07-03 -->
| cat_cd | 이름 | lvl | 상위 | main_cat_yn |
|---|---|---|---|---|
| CAT_000080 | 보드액자 | 2 | CAT_000004 | N |
| CAT_000004 | 포스터 | 1 |  | Y |

### 사이즈 치수 (이산 규격·nonspec_yn=N·전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_133.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_sizes+t_siz_sizes (del_yn=N·master_del 별도 검출) @ 2026-07-03 -->
| siz_cd | 라벨 | 작업(work mm) | 재단(cut mm) | dflt | master_del_yn |
|---|---|---|---|---|---|
| SIZ_000172 | A4(210x297mm) | 210x297 | 210x297 | Y | N |
| SIZ_000174 | A3(297x420mm) | 297x420 | 297x420 | Y | N |
| SIZ_000197 | A2(420x594mm) | 420x594 | 420x594 | Y | N |

### 자재 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_133.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_materials+t_mat_materials @ 2026-07-03 -->
| mat_cd | 이름 | mat_typ | usage_cd | dflt |
|---|---|---|---|---|
| MAT_000185 | 캔버스(옥스포드) | MAT_TYPE.05 | USAGE.07 | Y |

### 인쇄옵션 (전사·0행 실측)

<!-- transcribed-by: _meta/scripts/transcribe_product_133.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_print_options @ 2026-07-03 -->
인쇄옵션 **0행** — 실사=대형 잉크젯 풀컬러(도수 컬럼 없음·po=0·정당·pack §3.3/§3.7)

### 공정 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_133.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_processes+t_proc_processes @ 2026-07-03 -->
| proc_cd | 공정명 | 상위공정 | mand |
|---|---|---|---|
| PROC_000080 | 봉제 |  | N |

### 판형 (전사·★del 이력 포함·활성 0 확인)

<!-- transcribed-by: _meta/scripts/transcribe_product_133.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_plate_sizes (전 행·del 표기) @ 2026-07-03 -->
| siz_cd | output_paper_typ | output_file | dflt | del | note |
|---|---|---|---|---|---|
| SIZ_000050 | (공백) | JPG | Y | Y | 파일사양 |
| SIZ_000052 | (공백) | JPG | Y | Y | 파일사양 |
| SIZ_000198 | (공백) | JPG | Y | Y | 파일사양 |

> 활성 판형(del_yn=N) **0행** — 비종이류(캔버스 대형 롤)라 판형 무의미(pack §3.8·T-7). 3행 전부 파일사양 논리삭제.

### 제약규칙 (전사·0행 실측)

<!-- transcribed-by: _meta/scripts/transcribe_product_133.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_constraints @ 2026-07-03 -->
제약규칙 **0행** — 133은 실사 constraints 발현 7상품(118/120/121/122/124/125/139) 밖(pack §3.9·정합·위키 "0행"이 133엔 정합).

### 옵션그룹·옵션·아이템 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_133.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_option_groups+options+option_items @ 2026-07-03 -->

**OPT_000011 가공** (sel=SEL_TYPE.01·min/max=1/1·mand=Y·disp=1·note:오버로크 봉제 필수)
| opt_cd | opt_nm | dflt | disp | ref_dim_cd | ref_key1 | qty |
|---|---|---|---|---|---|---|
| OPV_000029 | 오버로크 | Y | 1 | OPT_REF_DIM.04 | PROC_000080 | 1 |

**OPT_000012 추가** (sel=SEL_TYPE.01·min/max=0/1·mand=N·disp=2·note:우드행거 추가 선택)
| opt_cd | opt_nm | dflt | disp | ref_dim_cd | ref_key1 | qty |
|---|---|---|---|---|---|---|
| OPV_000429 | 우드행거+면끈 추가 | N | 2 |  |  |  |
| OPV_000030 | 출력만 | Y | 1 |  |  |  |

> ★OPT_000012 추가의 옵션값(출력만 OPV_000030·우드행거+면끈 OPV_000429)은 option_items 행이 없다(ref_dim 없음). 우드행거 가격은 공식 구성요소 COMP_POSTEROPT_CANVAS_HANGING_WOODHANGER의 (opt_cd,siz_cd) 단가행으로 표현(아래 배선).

### 미보유 축 (전사·0행 실측)

<!-- transcribed-by: _meta/scripts/transcribe_product_133.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_bundle_qtys/addons/sets @ 2026-07-03 -->
| 축 | 행수 |
|---|---|
| bundle_qtys(묶음수) | 0 |
| addons(추가상품) | 0 |
| sets(부모 셋트) | 0 |
| sets(구성원) | 0 |

> ★addon=0 — 133은 pack §3.12 '부속붙는 8상품'이나 우드행거(PRD_000014·기성 PRD_TYPE.03) addon 재연결 미적재(GAP 잔존·[[gap-133-woodhanger-addon-reconnect]]). 현재는 CPQ 옵션(OPT_000012)+단가행으로만 부속 표현.

### 가격 배선 PRF_POSTER_CANVAS_HANGING (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_133.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_price_formulas+t_prc_formula_components+t_prc_price_components @ 2026-07-03 -->

**PRF_POSTER_CANVAS_HANGING** — 캔버스 행잉포스터 완제품가(면적/규격 단가) (use_yn=Y)
| disp_seq | comp_cd | addtn | prc_typ | comp_typ | comp_nm | use_dims(선언) |
|---|---|---|---|---|---|---|
| 1 | COMP_POSTER_CANVAS_HANGING | Y | PRICE_TYPE.01 | PRC_COMPONENT_TYPE.06 | 캔버스 행잉포스터 완제품가 | `["siz_width", "siz_height", "min_qty"]` |
| 2 | COMP_POSTEROPT_CANVAS_HANGING_WOODHANGER | Y | PRICE_TYPE.01 | PRC_COMPONENT_TYPE.06 | 캔버스행잉포스터 우드행거+면끈 추가가격 | `["opt_cd", "siz_cd", "opt_grp:OPT_000012"]` |

### 단가행 요약 (★고정가·접기·값 나열 아님·D-22·L-12·pack §3.11)

<!-- transcribed-by: _meta/scripts/transcribe_product_133.py from live-snapshot/latest (snap_20260702_1119) t_prc_component_prices (comp별 count/dim키/range 요약) @ 2026-07-03 -->
| comp_cd | 단가셀수 | 선언 use_dims | 실 셀 차원컬럼 | siz_cd | opt_cd | min_qty | 단가 min | 단가 max |
|---|---|---|---|---|---|---|---|---|
| COMP_POSTER_CANVAS_HANGING | 3 | `["siz_width", "siz_height", "min_qty"]` | `['siz_cd', 'min_qty']` | ['SIZ_000172', 'SIZ_000174', 'SIZ_000197'] | [] | ['1'] | 6000.0 | 20000.0 |
| COMP_POSTEROPT_CANVAS_HANGING_WOODHANGER | 3 | `["opt_cd", "siz_cd", "opt_grp:OPT_000012"]` | `['siz_cd', 'opt_cd']` | ['SIZ_000172', 'SIZ_000174', 'SIZ_000197'] | ['OPV_000429'] | [] | 16000.0 | 20000.0 |

> ★고정가형 = [규격(siz_cd)×수량(min_qty)] 단가행(면적매트릭스의 siz_width×siz_height 아님). 값 전건은 KB에 나열하지 않고 count/range로 접는다(D-22). 값 계산=evaluate_price(가격 경계 D-18).
> ★[선언≠셀키 불일치] COMP_POSTER_CANVAS_HANGING의 comp 선언 use_dims=[siz_width,siz_height,min_qty](면적템플릿)이나 실 단가행은 siz_cd+min_qty 키(고정가·이산 규격). evaluate_price 룩업 정합은 엔진/검증 소관(양면 defect·[[gap-133-usedims-cellkey-mismatch]] 참조).

---

## 카테고리 (category) — 전부 재사용 참조 (형제 owner·중복 mint 금지)

★**동시 빌드 정합(consolidation):** 133 카테고리 2종은 전부 다른 파일이 이미 소유하므로 133은 **재사용
참조만**(L-3 중복 mint 금지)·in_category 프론트매터 엣지는 유지(target 실재):
- `category-CAT_000004`(포스터·root·★133 main_cat_yn=Y 주 분류) = 병렬 실사 형제 119(아트페이퍼포스터) owner(재사용).
- `category-CAT_000080`(보드액자·lvl2·main=N·133 보조 분류) = 실사 형제 **131(프레임리스우드액자) owner**
  (134 등 129~134 공유·재사용). ★live 실측(t_cat_categories CAT_000080 cat_nm=보드액자·cat_lvl=2·
  upr=CAT_000004·del_yn=N / t_prd_product_categories (PRD_000133,CAT_000080) main_cat_yn=N).

★133은 main_cat_yn=Y가 root 포스터(CAT_000004)에 있고 보드액자는 보조(main=N) — 125(main=leaf 패브릭포스터)와
반대 구성(라이브 실측·정체 오분류 아님·행잉포스터의 카탈로그 귀속 특성). 실사 카테고리는 공유 categories.md에
아직 없어 **needed_shared_nodes**로 반환(실사 카테고리 승격 시 consolidate 대상).

---

## 사이즈 (size) — 전부 재사용 참조 (공유 axis/형제 owner·중복 mint 금지)

★**동시 빌드 정합(consolidation):** 133 이산 사이즈 A4/A3/A2는 전부 다른 파일이 이미 소유하므로 133은
**재사용 참조만**(L-3 중복 mint 금지)·has_size 프론트매터 엣지는 유지(target 실재):
- `size-SIZ_000172`(A4 210x297) = product-047(소량전단지) owner(재사용·A계열 공용).
- `size-SIZ_000174`(A3 297x420) = product-047(소량전단지) owner(재사용).
- `size-SIZ_000197`(A2 420x594) = 공유 [axis/sizes.md](../axis/sizes.md) owner(재사용).

★125(A3/A2/A1)와 달리 133은 **A4/A3/A2**를 쓰고 A1(SIZ_000293·마스터 삭제 양면)을 쓰지 않는다 —
133 세 마스터(SIZ_000172/174/197) 전부 `del_yn=N`(양면 없음·전사표 master_del_yn=N). 실사 사이즈 =
이산 규격 SIZ만(133은 nonspec_yn=N이라 연속범위·off-grid 없음·pack §3.2). 판걸이수(UP수)는 종이류
파생값이라 실사 무의미(판형 절). 고정가 단가행은 (siz_cd×min_qty) 키로 저장(가격구성요소 절).

---

## 가격공식·구성요소 (실사 고정가형·133-local mint·needed_shared_node 아님)

133 = 고정가형 완제품가(포스터사인 [규격×수량] 단가·pack §3.10). 125의 면적공식 PRF_POSTER_CANVAS(4소재
동형결합)와 다른 별도 공식이며, 라이브 formula_components에서 다른 상품에 미공유(133 전용·실측). 상품-local
mint(공유 formula/* 미수정).

### [formula-PRF_POSTER_CANVAS_HANGING] 캔버스 행잉포스터 완제품가(규격 단가·고정가형) {verified}
- type: price_formula
- anchor: t_prc_price_formulas/PRF_POSTER_CANVAS_HANGING
- src: {source_file: "live-snapshot/latest/t_prc_price_formulas.csv", source_locator: "테이블:t_prc_price_formulas 키:PRF_POSTER_CANVAS_HANGING frm_nm='캔버스 행잉포스터 완제품가(면적/규격 단가)'·use_yn=Y", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prc_formula_components.csv", source_locator: "테이블:t_prc_formula_components 키:(PRF_POSTER_CANVAS_HANGING,COMP_POSTER_CANVAS_HANGING disp_seq 1·addtn_yn Y)+(…,COMP_POSTEROPT_CANVAS_HANGING_WOODHANGER disp_seq 2·addtn_yn Y)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {archetype: "고정가형(포스터사인 [규격(siz_cd)×수량(min_qty)] 단가·면적매트릭스 아님·off-grid 없음)", use_yn: Y, 구성요소수: 2}
- rel: {rel: has_component, target: component-COMP_POSTER_CANVAS_HANGING, qualifier: {disp_seq: 1, addtn: Y}, note: "완제품가(규격×수량 단가·통가격)"}
- rel: {rel: has_component, target: component-COMP_POSTEROPT_CANVAS_HANGING_WOODHANGER, qualifier: {disp_seq: 2, addtn: Y}, note: "우드행거+면끈 추가가격(옵션×규격 단가·가산)"}
- standards: {schema_org: "(Offer 계산 — schema.org 표현 불가)", note: "값 계산=evaluate_price 권위(D-18)·고정가라 off-grid ceiling 무관"}
- 본문: 고정가형 = [규격(siz_cd)×수량(min_qty)] 단가 룩업(완제품가) + 우드행거 옵션 선택 시 추가가격 가산. 고아 공식 아님(has_component 2개). 면적매트릭스(siz_width×siz_height)와 다른 아키타입 — 이산 규격 단가행이라 off-grid ceiling 없음(pack §3.10). 온톨로지는 배선까지, 값은 엔진.

### [component-COMP_POSTER_CANVAS_HANGING] 캔버스 행잉포스터 완제품가 (규격×수량·★선언≠셀키 양면) {defect}
- type: price_component
- anchor: t_prc_price_components/COMP_POSTER_CANVAS_HANGING
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "테이블:t_prc_price_components 키:COMP_POSTER_CANVAS_HANGING prc_typ_cd=PRICE_TYPE.01·comp_typ_cd=PRC_COMPONENT_TYPE.06(완제품비)·use_dims='[\"siz_width\",\"siz_height\",\"min_qty\"]'(선언)·note '포스터·사인 완제품가(소재+출력+가공 포함 통가격). 사이즈·수량별 단가표'·use_yn=Y", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prc_component_prices.csv", source_locator: "테이블:t_prc_component_prices comp_cd=COMP_POSTER_CANVAS_HANGING 3셀·★실 키=siz_cd(SIZ_000172/174/197)+min_qty(1)·siz_width/siz_height 컬럼 전부 빈값", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "§3.10 고정가형(수량×규격 블록·캔버스행잉133)·§3.11 단가행 접기(D-22)", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-silsa}
- current_value: 'use_dims 선언(t_prc_price_components.use_dims) = ["siz_width","siz_height","min_qty"] (면적매트릭스 템플릿 그대로 — 라이브 현재값·2026-06-17)'
- authority_value: '실 단가행(t_prc_component_prices 3셀)이 실제로 쓰는 키 = siz_cd + min_qty (siz_width/siz_height 컬럼 전부 빈값·고정가 이산 규격이므로 정합상 use_dims=["siz_cd","min_qty"]여야 함·데이터 자체가 권위)'
- props: {prc_typ_cd: "PRICE_TYPE.01", comp_typ_cd: "PRC_COMPONENT_TYPE.06", 셀행수_ref: "전사표(3셀·A4/A3/A2×min_qty=1)", 수량tier_ref: "전사표(min_qty=1 단일 tier만·수량 구간 미적재)"}
- 본문: 완제품가(소재+출력+봉제 포함 통가격)를 규격(siz_cd)×수량(min_qty) 단가행으로 저장(A4/A3/A2 각 1행·전사표). ★**양면(현재값 vs 정답):** comp가 use_dims를 면적템플릿 `[siz_width,siz_height,min_qty]`로 **선언**했으나 실 단가행은 `siz_cd+min_qty` 키(siz_width/siz_height 빈값)다 — 고정가·이산 규격 정합상 `[siz_cd,min_qty]`여야 한다. 어느 한쪽 삭제 금지(현재값·정답 둘 다 보존). evaluate_price 룩업 정합(siz_cd 폴백 처리 여부)은 엔진/검증 소관([[gap-133-usedims-cellkey-mismatch]]·값 날조 금지·D-18). ★부수: min_qty=1 단일 tier만 적재(수량 구간 t_dsc_* 미적재). 단가행 실값 나열 아님(D-22 접기).

### [component-COMP_POSTEROPT_CANVAS_HANGING_WOODHANGER] 우드행거+면끈 추가가격 (옵션×규격 단가) {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_POSTEROPT_CANVAS_HANGING_WOODHANGER
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "테이블:t_prc_price_components 키:COMP_POSTEROPT_CANVAS_HANGING_WOODHANGER prc_typ_cd=PRICE_TYPE.01·comp_typ_cd=PRC_COMPONENT_TYPE.06·use_dims='[\"opt_cd\",\"siz_cd\",\"opt_grp:OPT_000012\"]'·note '포스터·사인 추가옵션 가격(거치대·끈·타공 등 별도 추가). 옵션·수량별 단가표'·use_yn=Y", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prc_component_prices.csv", source_locator: "테이블:t_prc_component_prices comp_cd=COMP_POSTEROPT_CANVAS_HANGING_WOODHANGER 3셀·키=opt_cd(OPV_000429)+siz_cd(SIZ_000172/174/197)·선언 use_dims와 셀키 정합", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.01", comp_typ_cd: "PRC_COMPONENT_TYPE.06", 셀행수_ref: "전사표(3셀·OPV_000429×A4/A3/A2)", 부속: "우드행거+면끈(OPT_000012 추가 옵션)"}
- rel: {rel: references, target: optgroup-133-chuga, note: "우드행거 옵션값 OPV_000429 선택 시 이 단가행 가산(opt_cd 키)"}
- 본문: 부속 우드행거+면끈 가격을 옵션(opt_cd=OPV_000429)×규격(siz_cd) 단가행으로 저장(A4/A3/A2 각 1행·전사표). 선언 use_dims=[opt_cd,siz_cd,opt_grp:OPT_000012]와 셀키(opt_cd+siz_cd) 정합(양면 아님). ★우드행거는 addon 테이블(0행)이 아니라 이 구성요소+CPQ 옵션으로 표현([[gap-133-woodhanger-addon-reconnect]] — addon 재연결은 미교정 잔존). 우드행거 미선택(출력만 OPV_000030) 시 이 가산 없음. 값 계산=evaluate_price.

---

## 옵션그룹 (CPQ) — 가공(봉제) 필수 + 추가(우드행거) 선택

옵션 = 공정/부속 BUNDLE(pack §3.9). 옵션참조(ref_dim_cd)가 있으면 같은 부모 prd_cd 차원에 실재 필수
(`fn_chk_opt_item_ref`·L-18). 133은 옵션그룹 2개: 가공(필수·봉제 참조)·추가(선택·우드행거 가격 참조).

### [optgroup-133-gagong] 가공(봉제) 택1 필수 (min1/max1·mand=Y) {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000133
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "테이블:t_prd_product_option_groups 키:(PRD_000133,OPT_000011) opt_grp_nm=가공·sel_typ=SEL_TYPE.01·min/max=1/1·mand_yn=Y·note='오버로크 봉제 필수'·use_yn=Y·disp 1", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_option_items.csv", source_locator: "테이블:t_prd_product_option_items 키:(PRD_000133,OPV_000029) ref_dim_cd=OPT_REF_DIM.04(공정)·ref_key1=PROC_000080·qty 1·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {sel_typ_cd: "SEL_TYPE.01", mand: "Y", items: "오버로크(OPV_000029·dflt)→PROC_000080", 차이: "125 가공(min0/max1·선택)과 달리 133은 min1/max1 필수"}
- rel: {rel: option_refs, target: process-PROC_000080, ref_key1: PROC_000080, note: "오버로크(OPV_000029·OPT_REF_DIM.04 공정·ref_key1=PROC_000080)"}
- 본문: 가공 옵션값 오버로크가 부모 has_process(봉제 PROC_000080)를 가리킨다(L-18 정합). ★133은 이 그룹이 **mand=Y(필수·min1/max1)**라 봉제(오버로크)가 실질 필수 — 제품행 mand_proc_yn=N이나 옵션그룹이 필수화(패브릭 완성형태). 옵션=공정 BUNDLE(pack §3.9). 봉제 variant(오버로크/말아박기/봉미싱 등)의 적재 위치는 실사 GAP-SL-2(현재 133은 오버로크 1값만 노출)·값 계산=엔진.

### [optgroup-133-chuga] 추가(우드행거) 택0/1 선택 (min0/max1·mand=N) {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000133
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "테이블:t_prd_product_option_groups 키:(PRD_000133,OPT_000012) opt_grp_nm=추가·sel_typ=SEL_TYPE.01·min/max=0/1·mand_yn=N·note='우드행거 추가 선택'·use_yn=Y·disp 2", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_options.csv", source_locator: "테이블:t_prd_product_options 키:(PRD_000133,OPT_000012) 옵션값 OPV_000030 출력만(dflt·disp1)·OPV_000429 우드행거+면끈(disp2)·★option_items 행 없음(ref_dim 없음)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {sel_typ_cd: "SEL_TYPE.01", mand: "N", items: "출력만(OPV_000030·dflt)/우드행거+면끈(OPV_000429)", ref_dim: "없음(option_items 0행)"}
- rel: {rel: references, target: component-COMP_POSTEROPT_CANVAS_HANGING_WOODHANGER, note: "우드행거+면끈(OPV_000429) 선택→우드행거 추가가격 단가행 가산(opt_cd 키)"}
- 본문: 추가 옵션은 출력만(dflt·가산 없음)/우드행거+면끈(OPV_000429·가산) 택1(선택적·mand=N). ★이 그룹의 옵션값은 `option_items` 행이 없다(ref_dim 없음) → L-18 option_refs 대상 아님. 우드행거 선택 시 가격은 공식 구성요소 COMP_POSTEROPT_CANVAS_HANGING_WOODHANGER의 (opt_cd,siz_cd) 단가행이 가산한다(부속=옵션+단가행 모델). ★부속 우드행거의 addon 테이블 재연결은 미교정 잔존([[gap-133-woodhanger-addon-reconnect]]).

---

## 정직 GAP (원천 부재·미해소)

### [gap-133-woodhanger-addon-reconnect] 우드행거 부속 addon 재연결 부재 (SL-DEF-005 잔존) {unknown}
- type: gap
- anchor: none  # 사유: 우드행거(PRD_000014·기성 PRD_TYPE.03) addon 재연결의 정답 적재 형태(addon 테이블 vs 현행 CPQ 옵션+단가행)를 단정할 권위 원천 없음·pack은 재연결 대상만 지목(미교정 잔존)
- src: {source_file: "live-snapshot/latest/t_prd_product_addons.csv", source_locator: "테이블:t_prd_product_addons PRD_000133 = 0행(addon 미적재)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "§3.12 부속붙는 8상품·재연결 대상 캔버스행잉133→우드행거014·§1.1/§4 [잔존·미교정] SL-DEF-005(addon=0·set=0 여전히 0행)", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-silsa}
- gap_what: "133은 부속붙는 8상품(캔버스+우드행거)이나 t_prd_product_addons=0행이다. pack §3.12는 재연결 대상을 '캔버스행잉133→우드행거(PRD_000014·기성 PRD_TYPE.03)'로 지목하나, 현재 라이브는 우드행거를 addon이 아니라 CPQ 옵션(OPT_000012 추가·OPV_000429)+가격 구성요소(COMP_POSTEROPT_CANVAS_HANGING_WOODHANGER)로 표현한다. 어느 것이 정답 형태(addon 재연결 vs 옵션 유지)인지·둘 다 필요한지 미결"
- gap_fill_from: "실무진 + pack GAP-SL-4(부속·액자 귀속·Q-SL-4) 결정 후·라이브 교정 인간 승인(§7 dbmap/§23 set 위임). 우드행거 PRD_000014는 라이브 실재(search-before-mint 충족·재연결만)"
- gap_owner: staff
- rel: {rel: references, target: product-133-canvas-hanging-poster, note: "부속붙는 8상품(addon=0 잔존)"}
- rel: {rel: references, target: optgroup-133-chuga, note: "현행 우드행거 표현=CPQ 옵션(addon 아님)"}
- rel: {rel: references, target: component-COMP_POSTEROPT_CANVAS_HANGING_WOODHANGER, note: "현행 우드행거 가격=옵션 단가행"}
- 본문: 가격/선택 자체는 동작(옵션+단가행으로 우드행거 가산). 이 GAP은 '부속을 addon 테이블로 재연결할지'가 KB 밖 결정(pack 지목·실무진 승인)임을 정직 선언(단정 금지·라이브 인간 승인).

### [gap-133-usedims-cellkey-mismatch] COMP_POSTER_CANVAS_HANGING use_dims 선언≠셀키 (엔진 정합 미상) {unknown}
- type: gap
- anchor: none  # 사유: 완제품가 구성요소의 use_dims 선언(면적템플릿 [siz_width,siz_height,min_qty])과 실 단가행 키(siz_cd+min_qty)의 불일치가 evaluate_price 룩업에서 실제로 문제되는지(siz_cd 폴백 처리 여부) 판정할 권위=엔진 실행·KB use_dims 선언 밖
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "테이블:t_prc_price_components COMP_POSTER_CANVAS_HANGING use_dims='[\"siz_width\",\"siz_height\",\"min_qty\"]'(선언)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prc_component_prices.csv", source_locator: "테이블:t_prc_component_prices COMP_POSTER_CANVAS_HANGING 3셀 실 키=siz_cd+min_qty(siz_width/siz_height 빈값)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- gap_what: "완제품가 구성요소 COMP_POSTER_CANVAS_HANGING이 use_dims를 면적매트릭스 템플릿 [siz_width,siz_height,min_qty]로 선언했으나 실 단가행 3셀은 siz_cd+min_qty로만 키잉됐다(siz_width/siz_height 컬럼 전부 빈값). 고정가·이산 규격이므로 use_dims는 [siz_cd,min_qty]여야 정합. evaluate_price가 siz_cd로 폴백 룩업해 정상 계산하는지, 아니면 선언대로 siz_width/siz_height를 찾다 실패하는지 미상. 부수로 수량 tier가 min_qty=1 단일뿐(수량 구간 미적재)"
- gap_fill_from: "evaluate_price 실행 실측(pricing.py 룩업 로직·값 계산은 KB 밖·D-18) + §26 가격테이블 무결성/§27 배선 진단 + use_dims 교정 여부 인간 승인. 온톨로지는 양면(현재값 선언 vs 정답 셀키) 보존까지"
- gap_owner: staff
- rel: {rel: references, target: component-COMP_POSTER_CANVAS_HANGING, note: "선언≠셀키 양면 defect 구성요소"}
- rel: {rel: references, target: product-133-canvas-hanging-poster, note: "이 상품의 완제품가 배선(가격 경로는 연결됨)"}
- 본문: 가격 경로 자체는 연결됨(priced_by→formula→component 2개). 이 GAP은 완제품가 구성요소의 use_dims 선언과 실 셀키 불일치의 엔진 영향이 KB(use_dims 선언) 밖·엔진 실측 소관임을 정직 선언(값 날조 금지·D-18 경계). 양면 값은 [[product-133-canvas-hanging-poster-nodes#component-COMP_POSTER_CANVAS_HANGING]]에 보존.
