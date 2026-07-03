---
id: product-236-leather-flat-clutch
type: product
anchor: t_prd_products/PRD_000236
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "키:PRD_000236 (prd_typ=PRD_TYPE.01·use_yn=Y·del_yn=N·nonspec_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-stationery-goods.md", source_locator: "§1.3 하위군③ 파우치·백(레더 파우치/미니/필통 230~237·251~260)·§3.10 가격아키타입·§4 GAP표·§3.5 자재 empty-shell·§3.6 봉제 MISSING", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-stn}
  - {source_file: "live-snapshot/latest/t_prd_product_prices.csv", source_locator: "키:PRD_000236 unit_price (GP-1 base 단일고정가·260610 verbatim)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
relations:
  - {rel: in_category, target: category-CAT_000011, qualifier: main, note: "굿즈 카테고리(main·live t_prd_product_categories 20260702_1119)"}
  - {rel: in_category, target: category-CAT_000324, qualifier: sub, note: "굿즈 카테고리(보조·live t_prd_product_categories 20260702_1119)"}
  - {rel: uses_material, target: material-MAT_000008, note: "레더 substrate(USAGE.07)·마스터 del_yn=Y이나 정션 활성=load-bearing(정직 관찰·127 선례)"}
  - {rel: references, target: gap-goods-sewing-missing, note: "봉제 공정 0행(has_process 미배선·empty on process axis)"}
  - {rel: references, target: gap-goods-fixed-lookup-no-formula, note: "고정가룩업(t_prd_product_prices 단일 unit_price·frm_cd 없음)·O5 가격gap 정직 선언(07-04 live 재프라이싱)"}
props:
  prd_typ_cd: "PRD_TYPE.01"
  min_qty: 1   # 단일 스칼라(§2.4)·src=SR-5-livesnap
  max_qty: 10000
  qty_incr: 1
  qty_unit_typ_cd: "QTY_UNIT.01"
  file_upload_yn: "Y"
  editor_yn: "Y"
  가격아키타입: "고정가룩업(t_prd_product_prices 단일 unit_price·18000.00원·transcribed·priced_by 불요=완결 원천)"
  판형: "없음(비종이=레더 MAT_TYPE.06·plate_sizes 전행 del_yn=Y 파일사양·종이류만 판형 도메인[HARD])"
  구분: "봉제 굿즈(레더 파우치/미니파우치/필통 단품·셋트 아님·has_member 없음)"
  fixed_price: "18000원 (t_prd_product_prices unit_price·transcribed-by reprice_goods_260704 @ 07-04 live)"
  가격상태: "고정가룩업·18000원(unit_price·transcribed·07-04 live·reg_dt=2026-06-22)"
standards: {schema_org: "Product", xjdf: "Product(봉제 파우치)", config_ont: "component type"}
tags: ["#굿즈", "#파우치", "#레더", "#봉제", "#고정가룩업"]
updated: 2026-07-03
---

# 레더 플랫 클러치 (product-236-leather-flat-clutch)

레더 소재 **봉제 굿즈 단품**(prd_typ_cd=`PRD_TYPE.01`·`t_prd_product_sets` 미등록=셋트 부모/구성원 아님·[[product-type-classification-sot]] 준수). 가격은 **고정가룩업**(`t_prd_product_prices` 단일 unit_price·완결 원천)이라 가격공식(priced_by) 없이 단가 조회로 견적한다(값 권위=엔진·[[rule/rules#RULE_price_value_boundary]]·D-18 경계).

- **비종이=판형 없음**: 본체 자재=레더(MAT_000008·`MAT_TYPE.06`)·봉제 상품 → `plate_size` 없음([[rule/rules#RULE_plate_paper_only]]). live `t_prd_product_plate_sizes` 행은 전부 del_yn=Y(파일사양 JPG·판형 아님).
- **봉제 공정 MISSING**: `t_prd_product_processes` **0행**(봉제/후가공 미배선) → [[gap-goods-sewing-missing]] (has_process 엣지 없음 정직 표기).
- **정체·가격 경계(D-18)**: 이 노드는 상품·가격 원천 존재/부재까지만 잇는다. 값 계산=견적기 권위.

## 상품 요소 전사 (권위 = 라이브 스냅샷·스크립트 전사)

> 아래 표는 `_meta/scripts/gen_leather_pouch_nodes.py`가 live-snapshot에서 결정론 전사(손전사 금지·D-9).

<!-- transcribed-by: _meta/scripts/gen_leather_pouch_nodes.py from live-snapshot/latest (snap_20260702_1119) t_prd_products PRD_000236 @ 2026-07-03 -->
| prd_typ | min_qty | max_qty | qty_incr | qty_unit | file_upload | editor | use_yn | del_yn |
|---|---|---|---|---|---|---|---|---|
| PRD_TYPE.01 | 1 | 10000 | 1 | QTY_UNIT.01 | Y | Y | Y | N |

#### 가격 원천

<!-- transcribed-by: _meta/scripts/gen_leather_pouch_nodes.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_prices+t_prd_product_price_formulas PRD_000236 @ 2026-07-03 -->
| 원천 테이블 | 행 | 값 |
|---|---|---|
| t_prd_product_prices | 1 | unit_price=18000.00 (GP-1 base 단일고정가 §21 R-GP4-1 (260610 verbatim)) |
| t_prd_product_price_formulas | 0 | (미바인딩) |

고정가룩업 = 완결 원천(공식 사슬 불요). 값 18000.00원은 260610 verbatim(260702 diff 미해당=권위 일치)·값 권위=엔진.

#### 자재 BOM (활성 del_yn=N)

<!-- transcribed-by: _meta/scripts/gen_leather_pouch_nodes.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_materials+t_mat_materials PRD_000236 @ 2026-07-03 -->
| mat_cd | 자재명 | mat_typ | usage_cd | 역할 |
|---|---|---|---|---|
| MAT_000008 | 레더 | MAT_TYPE.06 | USAGE.07 | substrate(레더 본체) |

substrate 자재 = 레더(MAT_000008·`MAT_TYPE.06`)만 정당. `uses_material`은 공유 [[axis/materials]]에 material-MAT_000008 축 노드가 **미민팅**이라 배선 대기(needs_axis)·위 BOM 표가 권위. ★IMPORT 등록 자재 삭제 금지([[rule/rules#RULE_import_material_no_delete]]).

#### 사이즈

<!-- transcribed-by: _meta/scripts/gen_leather_pouch_nodes.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_sizes+t_siz_sizes PRD_000236 @ 2026-07-03 -->
| siz_cd | 라벨 |
|---|---|
| (0행) | t_prd_product_sizes 미적재 |

사이즈 축 0행(미적재) — §7 dbmap 충전 대기.

#### 카테고리

<!-- transcribed-by: _meta/scripts/gen_leather_pouch_nodes.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_categories+t_cat_categories PRD_000236 @ 2026-07-03 -->
| cat_cd | 카테고리명 | main | 상위 |
|---|---|---|---|
| CAT_000011 | 에코백 | Y |  |
| CAT_000324 | 레더파우치 | N | CAT_000011 |

`in_category`는 공유 [[axis/categories]] 축 노드 미민팅이라 배선 대기(needs_axis)·위 표가 권위.

---

## GAP·정직 표기 (주 산출)

이 상품은 **고정가 있음(견적 가능)** + 봉제 공정 0행. 연결된 공유 GAP: [[gap-goods-sewing-missing]] (Stage A 민팅·rule/gaps.md). 축 노드(카테고리·자재·사이즈) 미민팅분은 needs_axis로 반환 — 조용한 누락 아님.
