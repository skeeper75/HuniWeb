---
id: product-122-adhesive-clear-poster
type: product
anchor: t_prd_products/PRD_000122
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000122 (접착투명포스터·del_yn=N·use_yn=Y·prd_typ_cd=PRD_TYPE.01·nonspec_yn=Y)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "§0 특성1~4·§3.1 정체·§3.3 화이트 underbase·§3.8 판형 없음·§3.10 면적매트릭스 B05·§3.11 comp_cd 687셀", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-silsa}
  - {source_file: "_workspace/huni-dbmap/02_mapping/silsa-poster-area-matrix/mapping.md", source_locator: "§1.1·§1.2 B05 접착투명122↔COMP_POSTER_ADH_CLEAR_PVC (면적매트릭스 13상품·승계·재검증 2026-07-03)", captured_at: "2026-07-03", badge: verified, src_id: SR-silsa-mapping}
relations:
  - {rel: in_category, target: category-CAT_000004, note: "포스터(main_cat_yn=Y·disp_seq 3·라이브 실측)"}
  - {rel: in_category, target: category-CAT_000314, note: "아트포스터(main_cat_yn=N·부 카테고리·2026-06-19 신규 junction)"}
  - {rel: has_size, target: size-SIZ_000174, note: "A3(297x420) 이산 규격(dflt)·상품-local"}
  - {rel: has_size, target: size-SIZ_000197, note: "A2(420x594) 이산 규격(dflt)·공유 axis/sizes 재사용(055 승격분)"}
  - {rel: has_size, target: size-SIZ_000293, note: "A1(594x841) 이산 규격(dflt)·상품-local"}
  - {rel: uses_material, target: material-MAT_000180, note: "투명PVC(MAT_TYPE.08 실사소재·USAGE.07 단일 슬롯·dflt Y)"}
  - {rel: has_process, target: process-PROC_000008, qualifier: {mand: "N"}, note: "화이트인쇄 underbase(상위 별색 PROC_000007·투명 소재 밑판·mand N·020 mint 재사용)"}
  - {rel: has_qty_rule, target: qty-122, note: "상품레벨 min 1·max 1000·incr 1·QTY_UNIT.01(면적매트릭스=수량축 없음·bundle_qtys 0행)"}
  - {rel: priced_by, target: formula-PRF_POSTER_ADH_CLEAR, note: "★면적매트릭스형(area-matrix)·[가로×세로] 셀단가 완제품 통가격(코팅포함)"}
  - {rel: has_option_group, target: optgroup-122-white, note: "화이트별색(OPT_000008·화이트 underbase 별색 선택·sel SEL_TYPE.01·mand N)"}
  - {rel: references, target: constraint-122-size-range, note: "사용자입력 치수 범위 제약(nonspec 가로 200~1200·세로 200~3000)"}
props:
  prd_typ_cd: "PRD_TYPE.01"     # 완제품 단일(t_prd_product_sets 부모/구성원 0/0 실측)
  archetype: "면적매트릭스형(area-matrix·use_dims=[siz_width,siz_height]·off-grid ceiling)"
  min_qty: 1                    # 단일 스칼라 허용(file-format-spec §2.4)·전사표 권위
  qty_unit_typ_cd: "QTY_UNIT.01"
  file_upload_yn: "Y"
  editor_yn: "N"
  nonspec_yn: "Y"              # 사용자입력 연속 치수 지원(이산 규격 A3/A2/A1 + nonspec 범위)
  use_yn: "Y"                  # 출시 상태(라이브 현재값)
  substrate: "투명PVC(비종이류·대형 롤 출력)"
standards: {schema_org: Product, xjdf: "Product(실사 대형 출력물·포스터)", config_ont: "component type"}
answers_cq: ["구체 상품 질의(접착투명포스터 구성·가격 축)", "실사 대형 출력물(포스터/사인·조건 탐색)", "면적매트릭스 가격 상품(가로×세로 셀단가)", "투명/반사 소재 화이트 underbase 상품"]
tags: ["#실사", "#포스터", "#접착투명", "#면적매트릭스", "#투명PVC", "#화이트별색"]
updated: 2026-07-03
---

# 접착투명포스터 (product-122-adhesive-clear-poster)

접착투명포스터(PRD_000122)는 **실사(대형 잉크젯) 완제품 단일**(prd_typ_cd=`PRD_TYPE.01` ·
`t_prd_product_sets`에 부모/구성원 등록 없음 — [[product-type-classification-sot]] 준수). 카테고리
004 **포스터**(main_cat_yn=Y) + 314 **아트포스터**(부). **투명PVC** 소재에 접착층을 둔 대형 실사
출력물로, 실사 파일럿 4대 특성의 대표 사례다(pack §0):

1. **소재가 상품을 가른다** — 소재=투명PVC(MAT_TYPE.08 실사소재). 인쇄방식은 실사 대형 잉크젯 단일.
2. **가격 = 면적매트릭스형(area-matrix)** — [가로(siz_width)×세로(siz_height)] 셀단가로 완제품 통가격을
   룩업한다. 도수·자재·코팅면·묶음·수량 **무관**(코팅포함 통가격·pack §3.10 B05). 원자합산형(디지털)·
   고정가 룩업(스티커)과 **다른 아키타입**([[formula/digital-formulas]]·[[formula/sticker-formulas]] 대비).
3. **★비종이류라 판형(plate_size)이 없다** — 대형 롤 출력이라 절수 기반 전지가 무의미. 활성 판형 **0행**
   (3행 전부 2026-06-30 파일사양 논리삭제). 종이류의 `fn_best_plate`/`fn_calc_pansu` 판걸이수 로직을
   여기 이식 금지([[rule/rules#RULE_plate_paper_only]]·pack §3.8·T-7).
4. **화이트 underbase(별색)** — 투명 소재 위에 CMYK만 얹으면 비쳐 보이므로, 불투명 백색 받침
   화이트인쇄(PROC_000008·상위 별색 PROC_000007)를 별색 옵션으로 태운다(도수가 아니라 **공정**·pack §3.3).

- **정체·소재·가격 분기**: pack §3.1/§3.10 + `mapping.md` §1.2(B05 접착투명122↔COMP_POSTER_ADH_CLEAR_PVC) +
  live-snapshot(prd_cd·frm_cd 실재). round-13 위키의 카테고리 고아(SL-DEF-001)·constraints 0행(SL-CPQ-003)
  서술은 **STALE**(T-1·T-3) — 현재값으로 재조준(아래 "결함 재조준" 절).
- **가격 경계(D-18)**: 이 노드는 상품→공식→구성요소→차원(use_dims)까지만 잇는다. 최종 가격 값과 off-grid
  ceiling 계산은 견적기(evaluate_price)가 권위([[rule/rules#RULE_price_value_boundary]]). 실사 시트 inline
  price(R/S/V 컬럼)는 가격 권위 아님(pack §3.10 [HARD]) — 권위는 인쇄상품 가격표 "포스터사인" 시트.
- **가격 경로 연결 확인**: `priced_by`→PRF_POSTER_ADH_CLEAR(✅ 실재·use_yn=Y)→`has_component`→
  COMP_POSTER_ADH_CLEAR_PVC(use_dims=`[siz_width, siz_height]`·52 면적셀). 끊긴 가격 사슬 아님(O5/O6 충족).

## 결함 재조준 (위키 round-13 🔴 → 현재값·pack §4·§1.1)

| 위키 결함 | 현재 상태(07-02 실측) | 판정 |
|---|---|---|
| SL-DEF-001 카테고리 CAT_000298 고아 | CAT_000298 del_yn=Y·122→CAT_000004(포스터)+CAT_000314(아트포스터) 정상 junction | **해소**(T-1·양면 아님) |
| SL-CPQ-003 constraints 0행 | RULE_001 사용자입력 치수 범위 **1행** 신규 발현 | **신규 발현**(T-3·위키 "0행" 낡음) |
| SL-DEF-005 부속 addon/set 0행 | 122는 부속붙는 8상품 아님·addon=0 정상 | **N/A**(오누락 아님) |

> 위 3건 모두 현재값=정답(정상)이라 **양면(defect) 노드 없음** — round-13 서술이 STALE일 뿐 값 충돌 아님
> (false-defect 방지·pack §5.6). 전 축 노드가 실재하고 가격 사슬이 완결돼 **끊긴 경로·정직 GAP도 없다**(122는
> 깨끗하게 배선된 실사 완제품). 화이트인쇄 PROC_000008은 020 mint 노드를 재사용해 배선됨(미민팅 GAP 아님).

## 차원·BOM·연결 전사표 (권위 = 라이브 스냅샷·스크립트 전사)

> 아래 표는 모두 `_meta/scripts/transcribe_product_122.py`가 live-snapshot에서 결정론 전사(사람 손전사
> 아님·D-9·[HARD]). 캐시=`_meta/scripts/cache/transcribed-122-260703.json`. `python3 transcribe_product_122.py`
> 재실행 시 동일 출력(멱등).

### 상품 정체·수량 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_122.py from live-snapshot/latest (snap_20260702_1119) t_prd_products PRD_000122 @ 2026-07-03 -->
| prd_typ_cd | min_qty | max_qty | qty_incr | qty_unit | file_upload | editor | nonspec | use_yn |
|---|---|---|---|---|---|---|---|---|
| PRD_TYPE.01 | 1 | 1000 | 1 | QTY_UNIT.01 | Y | N | Y | Y |

수량 단위 QTY_UNIT.01(장)·min/incr **1**·max 1000. 파일 업로드만(에디터 미지원). nonspec_yn=Y(사용자입력
연속 치수 지원 — 이산 규격 A3/A2/A1 + 자유 치수 범위·아래 제약 RULE_001).

### 카테고리 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_122.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_categories+t_cat_categories @ 2026-07-03 -->
| cat_cd | 이름 | main_cat_yn |
|---|---|---|
| CAT_000314 | 아트포스터 | N |
| CAT_000004 | 포스터 | Y |

주 카테고리(main_cat_yn=Y)=포스터(CAT_000004)·부=아트포스터(CAT_000314). CAT_000298 실사(구 고아 루트)는
del_yn=Y로 논리삭제됐고 정상 junction으로 재연결됨(pack §1.1·T-1). 두 카테고리 모두 공유 axis/categories 미등재
→ 이 상품이 companion에 임시 선언(승격 대기·needed_shared).

### 사이즈 치수 (이산 규격·전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_122.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_sizes+t_siz_sizes (del_yn=N) @ 2026-07-03 -->
| siz_cd | 라벨 | 작업(work mm) | 재단(cut mm) | dflt |
|---|---|---|---|---|
| SIZ_000174 | A3(297x420mm) | 297x420 | 297x420 | Y |
| SIZ_000197 | A2(420x594mm) | 420x594 | 420x594 | Y |
| SIZ_000293 | A1(594x841mm) | 594x841 | 594x841 | Y |

사이즈 = **이산 규격 3행(A3/A2/A1)** + **nonspec 연속범위**(사용자입력·제약 RULE_001 가로 200~1200·세로
200~3000). ★비규격 범위는 입력 UX일 뿐 가격격자가 아니다(pack §3.2) — 유효 가격 권위 = 면적매트릭스 셀
(siz_width×siz_height). 이산 규격 A3/A2/A1은 면적매트릭스 셀과 **독립**이고, off-grid는 가로·세로 각 한 단계
큰 규격으로 ceiling(앱 계산). A2(SIZ_000197)는 공유 [[axis/sizes#size-SIZ_000197]] 재사용(055 스티커 승격분)·
A3(SIZ_000174)/A1(SIZ_000293)은 companion local(승격 후보).

### 자재 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_122.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_materials+t_mat_materials @ 2026-07-03 -->
| mat_cd | 이름 | mat_typ | usage_cd | dflt |
|---|---|---|---|---|
| MAT_000180 | 투명PVC | MAT_TYPE.08 | USAGE.07 | Y |

본체 자재 단일 = **투명PVC**(parent+usage_cd 단일 슬롯·낱장 완제품·내지/표지 없음·pack §3.5). mat_typ_cd=
**MAT_TYPE.08 실사소재**는 현재값이며(코드 개편 후 실사소재 유지·pack §1.1) 권위 충돌 없음 — 레더(MAT_000186)
같은 `.08→.05` 교정 대상 아님(투명PVC는 실사소재로 정합). ★IMPORT 시트 등록 자재 삭제 금지
([[rule/rules#RULE_import_material_no_delete]]). 공유 [[axis/materials]] 미민팅 → companion local 선언(승격 후보).

### 인쇄옵션 (전사·0행 실측)

<!-- transcribed-by: _meta/scripts/transcribe_product_122.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_print_options @ 2026-07-03 -->
인쇄옵션 **0행** — 실사=대형 잉크젯 풀컬러라 도수(칼라/흑백) 컬럼 자체가 없다(po=0·정당·pack §3.3/§3.7).
`has_print_option` 엣지 없음(오누락 아님). 도수 축이 얕은 실사 특성.

### 공정 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_122.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_processes+t_proc_processes @ 2026-07-03 -->
| proc_cd | 공정명 | 상위공정 | mand |
|---|---|---|---|
| PROC_000008 | 화이트인쇄 | PROC_000007 | N |

공정 **1행 = 화이트인쇄(PROC_000008·상위 proc_grp PROC_000007 별색·mand=N)**. 투명 소재의 밑판 흰 잉크로,
도수(clr_cd)가 아니라 **공정**으로 들어온다([[rule/rules#RULE_dosu_is_printopt]]·pack §3.3 "화이트 underbase=공정").
PROC_000008은 [[product-020-white-print-postcard-nodes]]가 이미 mint한 노드라 `has_process`(mand N)로 배선한다
(중복 mint 없음·019 gap-019-white-process가 미민팅 전제였던 것과 달리 현재는 노드 실재). 후가공(봉제/타공/
족자/열재단)은 없음(접착투명포스터=평면 대형 출력). ★process-PROC_000008은 019/020/025/141과 공유되는 축이라
통합 단계 axis/processes 승격 후보(needed_shared).

### 판형 (전사·★del 이력 포함·활성 0 확인)

<!-- transcribed-by: _meta/scripts/transcribe_product_122.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_plate_sizes (전 행·del 표기) @ 2026-07-03 -->
| siz_cd | output_paper_typ | output_file | dflt | del | note |
|---|---|---|---|---|---|
| SIZ_000052 | (공백) | PDF | Y | Y | 파일사양 |
| SIZ_000198 | (공백) | PDF | Y | Y | 파일사양 |
| SIZ_000294 | (공백) | PDF | Y | Y | 파일사양 |

활성 판형(del_yn=N) **0행** — `has_plate_size` 엣지 없음. ★비종이류(투명PVC 대형 롤)라 판형 무의미(pack §3.8·
T-7·[[rule/rules#RULE_plate_paper_only]]). 3행 전부 2026-06-30 파일사양 논리삭제(파일사양 정리)—현재값 아님.
종이류 상품(디지털/스티커)의 `fn_best_plate`·`fn_calc_pansu` 판걸이수 로직을 실사에 이식하면 오모델.

### 제약규칙 (전사·logic 그대로)

<!-- transcribed-by: _meta/scripts/transcribe_product_122.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_constraints @ 2026-07-03 -->
| rule_cd | rule_nm | rule_typ | use | err_msg |
|---|---|---|---|---|
| RULE_001 | 사용자입력 치수 범위 | RULE_TYPE.01 | Y | 가로 200~1200mm, 세로 200~3000mm 범위로 입력하세요 |

> `RULE_001` logic(전사): `{"or": [{"!=": [{"var": "size_mode"}, "nonspec"]}, {"and": [{">=": [{"var": "width"}, 200]}, {"<=": [{"var": "width"}, 1200]}, {">=": [{"var": "height"}, 200]}, {"<=": [{"var": "height"}, 3000]}]}]}`

제약 **1행 = 사용자입력 치수 범위**(RULE_001·use_yn=Y). nonspec(자유 치수) 모드일 때만 가로 200~1200mm·세로
200~3000mm를 강제(CN-5 범위증분류·§31). 이산 규격(A3/A2/A1) 선택 시 조건 통과(size_mode≠nonspec). 위키 "constraints
0행"(T-3)은 STALE — 이 1행이 현재값. companion에 constraint 노드로 선언([[constraint-122-size-range]]).

### 옵션그룹·옵션·아이템 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_122.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_option_groups+options+option_items @ 2026-07-03 -->

**OPT_000008 화이트별색** (sel=SEL_TYPE.01·min/max=0/1·mand=N·note:화이트 underbase 별색 선택)
| opt_cd | opt_nm | dflt | ref_dim_cd | ref_key1 | qty |
|---|---|---|---|---|---|
| OPV_000024 | 단면 | N | OPT_REF_DIM.04 | PROC_000008 | 1 |

CPQ 옵션그룹 **1개 = 화이트별색**(택1·mand=N·손님 선택). 옵션값 "단면"(OPV_000024)이 OPT_REF_DIM.04(process)로
**PROC_000008**(화이트인쇄)를 가리킨다. PROC_000008이 노드 실재(020 mint)이고 부모 122 has_process에도 배선돼
있어 `option_refs`→process-PROC_000008(ref_key1=PROC_000008)을 청정 배선한다(L-18 정합·fn_chk_opt_item_ref). companion
optgroup-122-white 노드로 선언.

### 미보유 축 (전사·0행 실측)

<!-- transcribed-by: _meta/scripts/transcribe_product_122.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_bundle_qtys/addons @ 2026-07-03 -->
| 축 | 행수 |
|---|---|
| bundle_qtys(묶음수) | 0 |
| addons(추가상품) | 0 |

수량은 상품레벨 규칙(min 1·incr 1·QTY_UNIT.01)만 — 별도 묶음수 행 없음(면적매트릭스는 수량축 없음·완제품
통가격·pack §3.4). 추가상품 0행(122는 부속붙는 8상품 아님·정상). 제약은 위 RULE_001 1행(0행 아님).

### 가격 배선 PRF_POSTER_ADH_CLEAR (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_122.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_price_formulas+t_prc_formula_components+t_prc_price_components @ 2026-07-03 -->
| disp_seq | comp_cd | addtn | prc_typ | comp_typ | comp_nm | use_dims |
|---|---|---|---|---|---|---|
| 1 | COMP_POSTER_ADH_CLEAR_PVC | Y | PRICE_TYPE.01 | PRC_COMPONENT_TYPE.06 | 실사 완제품가 (접착투명포스터) | `["siz_width", "siz_height"]` |

`priced_by`→[[formula-PRF_POSTER_ADH_CLEAR]](면적매트릭스형·frm_nm "접착투명포스터 완제품가(면적/규격 단가)").
단일 구성요소 COMP_POSTER_ADH_CLEAR_PVC가 **완제품 통가격**(코팅포함·도수/자재/수량 무관)을 (가로×세로) 셀단가로
룩업한다. 원자합산형(여러 구성요소 addtn 합산)과 달리 **단독 매트릭스 룩업**(comp_typ_cd=PRC_COMPONENT_TYPE.06).
값은 evaluate_price(D-18 경계).

### 면적매트릭스 단가행 요약 (★접기·값 나열 아님·D-22·pack §3.11)

<!-- transcribed-by: _meta/scripts/transcribe_product_122.py from live-snapshot/latest (snap_20260702_1119) t_prc_component_prices (COMP_POSTER_ADH_CLEAR_PVC·count/range/golden 요약) @ 2026-07-03 -->
| comp_cd | 단가셀수 | (가로,세로) 순서쌍수 | 단가 min | 단가 max | master note |
|---|---|---|---|---|---|
| COMP_POSTER_ADH_CLEAR_PVC | 52 | 52 | 16000.0 | 198000.0 | [단독] 동형 없음 · 가격축: 가로×세로 구간(52셀) · 골든 600×1800=59,400원 |

> ★단가행은 (siz_width×siz_height) long-form 격자(52셀·52 순서쌍 = 각 가로·세로 조합이 고유 셀). 값 전건은
> KB에 나열하지 않고 count/range/골든으로 접는다(D-22·pack §3.11·아크릴 면적매트릭스 동형). 매트릭스 비대칭
> ((가로,세로)≠(세로,가로) 가능). off-grid=가로·세로 각 한 단계 큰 규격 ceiling(앱 계산). 골든 600×1800=59,400원은
> master note 실측(값 계산은 evaluate_price).

---

## 이 상품 전용 하위 노드

> **122 전용 mint**(companion [[product-122-adhesive-clear-poster-nodes]]): material-MAT_000180(투명PVC)·formula-
> PRF_POSTER_ADH_CLEAR·component-COMP_POSTER_ADH_CLEAR_PVC·optgroup-122-white·constraint-122-size-range·qty-122.
> ★**재사용(중복 mint 금지·L-3)**: category-CAT_000004/CAT_000314·size-SIZ_000174(A3)/SIZ_000293(A1)는 병렬 실사
> 빌더(119/121/123/125)가 이미 mint한 공유 실사 노드라 참조만 한다. size-SIZ_000197(A2)는 공유 axis/sizes 재사용.
> process-PROC_000008(화이트인쇄)은 020이 mint한 노드 재사용. ★실사 첫 area-matrix 계열이라 면적매트릭스 공식/
> 구성요소·실사 공유 축(카테고리/A3·A1 사이즈/투명PVC 자재/PROC_000008)은 통합 단계 승격 후보=needed_shared_nodes
> (formula/silsa-formulas.md·axis/* — consolidate 스크립트가 단일 소유권 이관·스티커 선례). 끊긴 경로·정직 GAP 없음
> (전 축 노드 실재·가격 사슬 완결).
