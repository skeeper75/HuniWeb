---
id: product-124-linen-fabric-poster
type: product
anchor: t_prd_products/PRD_000124
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000124", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "§1(정답소스)·§3.1 정체·§3.2 사이즈(이산+nonspec)·§3.10 면적매트릭스형 13(B07 린넨124)·§3.9 constraints 7상품·§3.6 봉제 PROC_000080·§5 인계메모", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-silsa}
  - {source_file: "_workspace/huni-dbmap/02_mapping/silsa-poster-area-matrix/mapping.md", source_locator: "§1.2 B07 린넨패브릭포스터 PRD_000124 → COMP_POSTER_LINEN_FABRIC 52셀(면적매트릭스 룩업 모델만 승계·좌표회귀 DROP T-4)", captured_at: "2026-07-03", badge: verified, src_id: SR-mapping-silsa}
relations:
  - {rel: in_category, target: category-CAT_000072, note: "패브릭포스터(main_cat_yn=Y 주)·cat_lvl2(부모 CAT_000004)·라이브 정상연결(round-13 CAT_000298 고아설 STALE=해소·pack T-1)·★공유 노드=product-125-canvas 선점 정의(중복 mint 금지·reference만·needed_shared)"}
  - {rel: in_category, target: category-CAT_000004, note: "포스터(main_cat_yn=N 부·cat_lvl1 root)·★공유 노드=sibling 선점 정의(reference만)"}
  - {rel: has_size, target: size-SIZ_000542, note: "A3세로 프리셋(work 치수 공백=라벨 프리셋·구 SIZ_000295~301 del_yn=Y 교체)"}
  - {rel: has_size, target: size-SIZ_000543, note: "A3가로 프리셋"}
  - {rel: has_size, target: size-SIZ_000544, note: "A2세로 프리셋"}
  - {rel: has_size, target: size-SIZ_000545, note: "A2가로 프리셋"}
  - {rel: has_size, target: size-SIZ_000546, note: "A1세로 프리셋"}
  - {rel: has_size, target: size-SIZ_000547, note: "A1가로 프리셋"}
  - {rel: uses_material, target: material-MAT_000607, note: "린넨(내추럴)·MAT_TYPE.05·USAGE.07 단일 슬롯·dflt Y(부모 MAT_000184 린넨은 del_yn=Y 07-01 교체)"}
  - {rel: has_process, target: process-PROC_000130, note: "봉제가공(활성·mand_proc_yn=N·07-01 교체분·upr=PROC_000080)"}
  - {rel: has_process, target: process-PROC_000080, note: "봉제(del_yn=Y 교체됨)·★마감 옵션 param(유형 enum)이 여기 있고 활성 option_items가 여전히 참조 → L-18 앵커·mismatch=gap-124-finish-process·★공유 노드=product-125-canvas 선점 정의(reference만)"}
  - {rel: has_qty_rule, target: qty-124, note: "상품레벨 min1·max10000·incr1·QTY_UNIT.01(bundle_qtys 0행)"}
  - {rel: priced_by, target: formula-PRF_POSTER_LINEN, note: "린넨패브릭포스터 완제품가(면적매트릭스+마감옵션)"}
  - {rel: has_option_group, target: optgroup-124-OPT_000009, note: "마감(봉제 오버로크/말아박기/봉미싱·SEL_TYPE.01·min0/max1)"}
props:
  prd_typ_cd: PRD_TYPE.01   # 완제품 단일(t_prd_product_sets 부모/구성원 0/0 실측)
  archetype: "면적매트릭스형(포스터사인 [가로×세로] 셀단가·off-grid=한 단계 큰 규격 ceiling)"
  min_qty: 1                # 단일 스칼라 허용(file-format-spec §2.4)·전사표 권위
  file_upload_yn: "Y"       # 파일 업로드 지원·에디터 미지원(editor_yn=N)
  editor_yn: "N"
  use_yn: "Y"               # 출시 상태(라이브 현재값)
  nonspec_yn: "Y"           # 비규격 연속범위 입력 지원(가로 200~1200·세로 200~3000·incr 200)
standards: {schema_org: Product, xjdf: "Product(린넨패브릭포스터 대형 실사 출력물)", config_ont: "component type"}
tags: [실사, 포스터, 패브릭, 면적매트릭스, 봉제마감]
updated: 2026-07-03
---

# product-124-linen-fabric-poster — 린넨패브릭포스터 (PRD_000124)

실사(대형 실사 출력물) **완제품 단일**(prd_typ_cd=`PRD_TYPE.01`·`t_prd_product_sets` 부모/구성원
등록 없음 — [[product-type-classification-sot]] 준수). 린넨(내추럴) 패브릭 소재에 대형 잉크젯으로
포스터를 출력하고 가장자리를 **봉제 마감**하는 상품. 카테고리는 **패브릭포스터**(CAT_000072·주)
아래 **포스터**(CAT_000004·부) 루트에 속한다. 가격은 실사 파일럿의 **면적매트릭스형**
아키타입 — `PRF_POSTER_LINEN`이 **[가로×세로] 면적 셀단가(52셀)** + **봉제 마감 옵션 단가**를
더해 완제품 통가격을 만든다(값 계산=`evaluate_price` 권위·[[rule/rules#RULE_price_value_boundary]]).

- **★면적매트릭스형(pack §3.10·[[harness-domain-rules-12-260701]]):** 이 상품은 디지털인쇄
  원자합산형(썬캡 [[product-051-suncap]])·스티커 고정룩업과 **다른 아키타입**이다. 가격축 =
  `COMP_POSTER_LINEN_FABRIC`의 `use_dims=["siz_width","siz_height"]` — (가로,세로) 순서쌍마다
  고유 셀단가(52셀·매트릭스 비대칭 594×420≠420×594). 손님이 규격 밖(nonspec) 치수를 넣으면
  **가로·세로 각 한 단계 큰 규격으로 ceiling**해 셀을 찾는다(앱/`evaluate_price` 계산·DB는 룩업행).
  도수·자재·코팅·묶음·수량은 면적매트릭스 가격에 무관(코팅포함 통가격·pack §3.10 clr/mat/coat/bdl=NULL).
- **★비종이류라 판형(plate_size) 없음(pack §3.8·T-7·[[rule/rules#RULE_plate_paper_only]]):** 실사는
  대형 롤 출력이라 절수 기반 전지 규격이 무의미. `t_prd_product_plate_sizes` 6행 **전부 del_yn=Y**
  (`output_paper_typ_cd`=.기타/공백·JPG 파일사양뿐). 종이류 상품의 판형(`fn_best_plate`)·판걸이수
  (`fn_calc_pansu`·`t_siz_pansu`) 로직을 **이 상품에 이식 금지**(스티커/디지털 팩 판형 SOT는 실사 무효).
- **★도수(인쇄옵션) 축 없음(pack §3.3/§3.7):** 실사는 대형 잉크젯 풀컬러라 `t_prd_product_print_options`
  0행(도수 컬럼 자체가 없음·정당). 이는 미적재 결함이 아니라 실사 아키타입의 특성이다
  ([[rule/rules#RULE_dosu_is_printopt]]와 별개 — 실사엔 도수축이 얕음).
- **사이즈 = 이산 프리셋 + 비규격 범위(pack §3.2):** 활성 프리셋 6종(A3/A2/A1 세로·가로·SIZ_000542~547·
  work 치수 공백=라벨 프리셋)은 **입력 UX**이고, 유효 **가격격자는 면적매트릭스 셀**이다(프리셋≠가격격자).
  비규격 연속범위(가로 200~1200·세로 200~3000·incr 200)는 자유 입력용. 구 SIZ_000295~301(실치수 보유)은
  07-01 del_yn=Y로 교체됨. round-9가 우려한 "비치수 연속범위 오판"은 라이브에 없음(pack §3.2 CORRECT).
- **자재(pack §3.5):** 활성 본체 자재 = `MAT_000607` 린넨(내추럴)·`MAT_TYPE.05`(특수소재)·USAGE.07 단일
  슬롯. 부모 `MAT_000184` 린넨은 07-01 del_yn=Y로 교체됨. ★round-13의 '원단'(.05) 목표 라벨은 MAT_TYPE
  코드 개편(현재 .05=특수소재)으로 **STALE**(pack T-2·round-13 목표 라벨 '원단'=.05) — 값 `.05`는 현재값이자 개편 후 정답이라 양면 아님.
- **★봉제 마감 = 공정 + CPQ 옵션 + 옵션 단가(pack §3.6·§3.9):** 마감 옵션그룹 `OPT_000009`(마감)이
  봉제 param(유형: 오버로크/오버로크+리본끈/말아박기/말아박기+면끈/봉미싱7cm)을 손님 선택 축으로 노출.
  옵션 단가는 `COMP_POSTEROPT_LINEN_FINISH`(use_dims=`[opt_cd,min_qty]`·5행)로 가격에 가산된다
  (오버로크=무료 기본·리본끈/말아박기/면끈/봉미싱=가산). 옵션 값은 polymorphic `ref_dim_cd=OPT_REF_DIM.04`로
  공정 `PROC_000080`을 가리킨다(옵션=공정 BUNDLE·pack §3.9·형제 [[product-125-canvas-fabric-poster]] 동형).
- **★공정/옵션 참조 mismatch(정직 GAP):** 상품의 활성 공정은 `PROC_000130`(봉제가공)인데, 마감 옵션은
  아직 교체 전 `PROC_000080`(봉제·del_yn=Y)을 참조한다(param이 PROC_000080에만 있음). 어느 쪽으로
  정합시킬지 미결 → [[gap-124-finish-process]]로 정직 선언(pack GAP-SL-2).
- **제약(pack §3.9·신규 발현):** `RULE_001`(사용자입력 치수 범위·RULE_TYPE.01·use_yn=Y) 1행 —
  비규격 입력 시 가로 200~1200·세로 200~3000 범위 검증([[constraint-124-size-range]]). round-13/위키
  "실사 constraints 전부 0행"은 STALE(pack T-3·124는 constraints 발현 7상품 중 하나).
- **미보유 축(정직):** 추가상품(addons)·묶음수(bundle_qtys)·셋트(sets)는 라이브 0행 — 없는 것을 지어내지
  않는다. 린넨124는 부속붙는 8상품(pack §3.12·133~137 등)에 속하지 않는 단품이다.
- **범위 밖 거절:** 주문·배송·회원·쿠폰 축은 KB 범위 밖([[rule/rules#RULE_scope_boundary]]·pack §0).

## 상품 요소 전사 (권위 = 라이브 마스터·스크립트 전사)

> 아래 표는 모두 `_meta/scripts/transcribe_product_124.py`가 live-snapshot에서 뽑은 값이다
> (LLM 손전사 금지·D-9). 캐시=`_meta/scripts/cache/transcribed-124-260703.json`.

### 상품 정체·수량·비규격범위 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_124.py from live-snapshot/latest (snap_20260702_1119) t_prd_products PRD_000124 @ 2026-07-03 -->
| prd_typ | min | max | incr | unit | file_up | editor | use_yn | nonspec |
|---|---|---|---|---|---|---|---|---|
| PRD_TYPE.01 | 1 | 10000 | 1 | QTY_UNIT.01 | Y | N | Y | Y |

<!-- transcribed-by: _meta/scripts/transcribe_product_124.py from live-snapshot/latest (snap_20260702_1119) t_prd_products PRD_000124 nonspec 범위 @ 2026-07-03 -->
| 축 | min(mm) | max(mm) | incr(mm) |
|---|---|---|---|
| 가로(width) | 200 | 1200 | 200 |
| 세로(height) | 200 | 3000 | 200 |

### 카테고리 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_124.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_categories+t_cat_categories @ 2026-07-03 -->
| cat_cd | 이름 | main_cat_yn |
|---|---|---|
| CAT_000072 | 패브릭포스터 | Y |
| CAT_000004 | 포스터 | N |

### 사이즈 프리셋 (전사·이산 규격·work 치수 공백=라벨 프리셋)

<!-- transcribed-by: _meta/scripts/transcribe_product_124.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_sizes(활성)+t_siz_sizes @ 2026-07-03 -->
| siz_cd | 라벨 | 작업(work mm) | tags |
|---|---|---|---|
| SIZ_000542 | A3세로 (297x420mm) | (공백·라벨전용) | ["패브릭포스터"] |
| SIZ_000543 | A3가로 (420x297mm) | (공백·라벨전용) | ["패브릭포스터"] |
| SIZ_000544 | A2세로 (420x594mm) | (공백·라벨전용) | ["패브릭포스터"] |
| SIZ_000545 | A2가로(594x420mm) | (공백·라벨전용) | ["패브릭포스터"] |
| SIZ_000546 | A1세로(594x841mm) | (공백·라벨전용) | ["패브릭포스터"] |
| SIZ_000547 | A1가로 (841x594mm) | (공백·라벨전용) | ["패브릭포스터"] |

### 자재 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_124.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_materials(활성)+t_mat_materials @ 2026-07-03 -->
| mat_cd | 이름 | mat_typ | upr_mat | usage_cd | dflt |
|---|---|---|---|---|---|
| MAT_000607 | 린넨(내추럴) | MAT_TYPE.05 | MAT_000184 | USAGE.07 | Y |

### 공정 (전사·활성+삭제 — 07-01 교체 신호)

<!-- transcribed-by: _meta/scripts/transcribe_product_124.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_processes+t_proc_processes @ 2026-07-03 -->
| proc_cd | 공정명 | upr_proc | mand | del_yn | param보유 |
|---|---|---|---|---|---|
| PROC_000080 | 봉제 |  | N | Y | Y |
| PROC_000130 | 봉제가공 | PROC_000080 | N | N | N |

### 판형·인쇄옵션 (전사·★실사 비종이류=판형 0·도수축 0)

<!-- transcribed-by: _meta/scripts/transcribe_product_124.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_plate_sizes+t_prd_product_print_options @ 2026-07-03 -->
| 축 | 활성행수 | 비고 |
|---|---|---|
| plate_sizes(판형) | 0 | 전 6행 del_yn=Y(대형 롤·비종이류·pack §3.8·T-7) |
| print_options(도수/인쇄방식) | 0 | 실사=대형 잉크젯 풀컬러·도수 컬럼 없음(pack §3.3/§3.7) |

### 제약·옵션그룹·미보유 축 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_124.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_constraints/option_groups/option_items/bundle_qtys/addons @ 2026-07-03 -->
| 축 | 행수 | 비고 |
|---|---|---|
| constraints | 1 | RULE_001 사용자입력 치수 범위(RULE_TYPE.01·use_yn=Y) |
| option_group | 1 | OPT_000009 마감(SEL_TYPE.01·min0/max1·mand=N) |
| option_items(마감) | 5 | 봉제 param via OPT_REF_DIM.04→PROC_000080 |
| bundle_qtys | 0 | 상품레벨 수량규칙만 |
| addons | 0 | 부속 미적재(정직) |

### 마감 옵션 아이템 (전사·finishing)

<!-- transcribed-by: _meta/scripts/transcribe_product_124.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_option_items(활성) @ 2026-07-03 -->
| opt_cd | item_seq | ref_dim_cd | ref_key1 | dtl_opt(유형) |
|---|---|---|---|---|
| OPV-000024 | 3 | OPT_REF_DIM.04 | PROC_000080 | {"유형": "오버로크+리본끈"} |
| OPV_000025 | 2 | OPT_REF_DIM.04 | PROC_000080 | {"유형": "오버로크"} |
| OPV_000026 | 2 | OPT_REF_DIM.04 | PROC_000080 | {"유형": "말아박기"} |
| OPV_000027 | 2 | OPT_REF_DIM.04 | PROC_000080 | {"폭": 7.0, "유형": "봉미싱(7cm)"} |
| OPV_000424 | 2 | OPT_REF_DIM.04 | PROC_000080 | {"유형": "말아박기+면끈"} |

## 가격 경로 (priced_by → 공식 → 구성요소 → 차원)

`product-124-linen-fabric-poster` --priced_by--> [[formula-PRF_POSTER_LINEN]]
--has_component--> `COMP_POSTER_LINEN_FABRIC`(면적매트릭스 52셀·use_dims=[siz_width,siz_height])
+ `COMP_POSTEROPT_LINEN_FINISH`(봉제 마감 옵션 단가 5행·use_dims=[opt_cd,min_qty]).
두 구성요소 모두 라이브 `t_prc_formula_components`에 배선됨(고아 없음·O6 충족). 각 구성요소의
`use_dims`가 이 상품 가격이 어떤 축으로 달라지는지 선언한다(값 계산=엔진·D-18 경계).

### 가격 배선 PRF_POSTER_LINEN (전사·★면적매트릭스+마감옵션·D-22 접기=행수)

<!-- transcribed-by: _meta/scripts/transcribe_product_124.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_price_formulas+t_prc_formula_components+t_prc_price_components(행수) @ 2026-07-03 -->
| disp_seq | comp_cd | addtn | prc_typ | comp_nm | use_dims | 단가행수 |
|---|---|---|---|---|---|---|
| 1 | COMP_POSTER_LINEN_FABRIC | Y | PRICE_TYPE.01 | 실사 완제품가 (린넨패브릭포스터) | `["siz_width", "siz_height"]` | 52 |
| 2 | COMP_POSTEROPT_LINEN_FINISH | Y | PRICE_TYPE.01 | 린넨 마감가공비 | `["opt_cd", "min_qty"]` | 5 |

> 골든 라벨: 위 배선은 live-snapshot 20260702_1119 기준. 면적매트릭스 셀단가 범위·절대값은
> mapping.md §1.2 B07(52셀) 원천에만 두고 본문엔 셀값을 옮기지 않는다(D-22 접기=행수만 전사·
> 셀 열거 금지·손전사 금지 D-9). off-grid ceiling 계산은 KB 밖(evaluate_price·D-18). 단가행은
> 노드로 펼치지 않고 구성요소 노드 속성으로 접는다.

---

> 이 상품 전용 하위 노드(카테고리·사이즈·자재·공정·수량·공식·구성요소·옵션그룹·제약·GAP)는
> [[product-124-linen-fabric-poster-nodes]]에 정의한다(실사 첫 파일럿 상품이라 공유 축 파일 미수정
> 원칙·썬캡 051 선례). 공유 승격 후보(formula/·axis/materials·axis/categories·axis/processes)는
> needed_shared로 인계한다.
