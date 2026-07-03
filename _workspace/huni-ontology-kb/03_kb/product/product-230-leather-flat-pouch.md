---
id: product-230-leather-flat-pouch
type: product
anchor: t_prd_products/PRD_000230
badge: candidate
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "키:PRD_000230 (prd_typ=PRD_TYPE.01·use_yn=Y·del_yn=N·nonspec_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-stationery-goods.md", source_locator: "§1.3 하위군③ 파우치·백(레더 파우치/미니/필통 230~237·251~260)·§3.10 가격아키타입·§4 GAP표·§3.5 자재 empty-shell·§3.6 봉제 MISSING", captured_at: "2026-07-03", badge: candidate, src_id: SR-pack-stn}
relations:
  - {rel: references, target: gap-goods-sewing-missing, note: "봉제 공정 0행(has_process 미배선·empty on process axis)"}
  - {rel: references, target: gap-goods-neither, note: "가격 원천 부재(공식·고정가 둘 다 0행=견적 불가)"}
props:
  prd_typ_cd: "PRD_TYPE.01"
  min_qty: 1   # 단일 스칼라(§2.4)·src=SR-5-livesnap
  max_qty: 10000
  qty_incr: 1
  qty_unit_typ_cd: "QTY_UNIT.01"
  file_upload_yn: "Y"
  editor_yn: "Y"
  가격아키타입: "NEITHER-gap(t_prd_product_price_formulas·t_prd_product_prices 둘 다 0행=견적 원천 부재)"
  판형: "없음(비종이=레더 MAT_TYPE.06·plate_sizes 전행 del_yn=Y 파일사양·종이류만 판형 도메인[HARD])"
  구분: "봉제 굿즈(레더 파우치/미니파우치/필통 단품·셋트 아님·has_member 없음)"
standards: {schema_org: "Product", xjdf: "Product(봉제 파우치)", config_ont: "component type"}
tags: ["#굿즈", "#파우치", "#레더", "#봉제", "#NEITHER-gap"]
updated: 2026-07-03
---

# 레더 플랫 파우치 (product-230-leather-flat-pouch)

레더 소재 **봉제 굿즈 단품**(prd_typ_cd=`PRD_TYPE.01`·`t_prd_product_sets` 미등록=셋트 부모/구성원 아님·[[product-type-classification-sot]] 준수). 가격은 **NEITHER-gap** — `t_prd_product_price_formulas`·`t_prd_product_prices` 둘 다 0행이라 견적 원천이 아직 없다(정직 표기·[[gap-goods-neither]]). 손님이 0/최소가를 만나는 상태.

- **비종이=판형 없음**: 본체 자재=레더(MAT_000008·`MAT_TYPE.06`)·봉제 상품 → `plate_size` 없음([[rule/rules#RULE_plate_paper_only]]). live `t_prd_product_plate_sizes` 행은 전부 del_yn=Y(파일사양 JPG·판형 아님).
- **봉제 공정 MISSING**: `t_prd_product_processes` **0행**(봉제/후가공 미배선) → [[gap-goods-sewing-missing]] (has_process 엣지 없음 정직 표기).
- **정체·가격 경계(D-18)**: 이 노드는 상품·가격 원천 존재/부재까지만 잇는다. 값 계산=견적기 권위.

## 상품 요소 전사 (권위 = 라이브 스냅샷·스크립트 전사)

> 아래 표는 `_meta/scripts/gen_leather_pouch_nodes.py`가 live-snapshot에서 결정론 전사(손전사 금지·D-9).

<!-- transcribed-by: _meta/scripts/gen_leather_pouch_nodes.py from live-snapshot/latest (snap_20260702_1119) t_prd_products PRD_000230 @ 2026-07-03 -->
| prd_typ | min_qty | max_qty | qty_incr | qty_unit | file_upload | editor | use_yn | del_yn |
|---|---|---|---|---|---|---|---|---|
| PRD_TYPE.01 | 1 | 10000 | 1 | QTY_UNIT.01 | Y | Y | Y | N |

#### 가격 원천

<!-- transcribed-by: _meta/scripts/gen_leather_pouch_nodes.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_prices+t_prd_product_price_formulas PRD_000230 @ 2026-07-03 -->
| 원천 테이블 | 행 | 값 |
|---|---|---|
| t_prd_product_prices | 0 | (미적재) |
| t_prd_product_price_formulas | 0 | (미바인딩) |

두 원천 모두 0행 = 견적 불가(NEITHER-gap). 채움 원천=상품마스터 파우치 시트 고정가 or 공식 → §26/§7·실무진 대기.

#### 자재 BOM (활성 del_yn=N)

<!-- transcribed-by: _meta/scripts/gen_leather_pouch_nodes.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_materials+t_mat_materials PRD_000230 @ 2026-07-03 -->
| mat_cd | 자재명 | mat_typ | usage_cd | 역할 |
|---|---|---|---|---|
| MAT_000008 | 레더 | MAT_TYPE.06 | USAGE.07 | substrate(레더 본체) |

substrate 자재 = 레더(MAT_000008·`MAT_TYPE.06`)만 정당. `uses_material`은 공유 [[axis/materials]]에 material-MAT_000008 축 노드가 **미민팅**이라 배선 대기(needs_axis)·위 BOM 표가 권위. ★IMPORT 등록 자재 삭제 금지([[rule/rules#RULE_import_material_no_delete]]).

#### 사이즈

<!-- transcribed-by: _meta/scripts/gen_leather_pouch_nodes.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_sizes+t_siz_sizes PRD_000230 @ 2026-07-03 -->
| siz_cd | 라벨 | 작업 w×h(mm) | dflt |
|---|---|---|---|
| SIZ_000433 | 220x300 | 220.00×300.00 | Y |
| SIZ_000434 | 260x340 | 260.00×340.00 | N |

`has_size`는 공유 [[axis/sizes]] 축 노드 미민팅이라 배선 대기(needs_axis)·위 표가 권위.

#### 카테고리

<!-- transcribed-by: _meta/scripts/gen_leather_pouch_nodes.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_categories+t_cat_categories PRD_000230 @ 2026-07-03 -->
| cat_cd | 카테고리명 | main | 상위 |
|---|---|---|---|
| CAT_000324 | 레더파우치 | N | CAT_000011 |
| CAT_000011 | 에코백 | Y |  |

`in_category`는 공유 [[axis/categories]] 축 노드 미민팅이라 배선 대기(needs_axis)·위 표가 권위.

#### 옵션그룹

<!-- transcribed-by: _meta/scripts/gen_leather_pouch_nodes.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_option_groups PRD_000230 @ 2026-07-03 -->
| opt_grp_cd | 그룹명 | sel_typ | mand |
|---|---|---|---|
| OPT_000073 | 사이즈 | SEL_TYPE.01 | Y |

사이즈 선택 그룹(option_items → SIZ 차원 참조). option_refs 대상 사이즈 축 노드 미민팅이라 optgroup 노드는 사이즈 축 민팅 후 배선(needs_axis)·위 표가 권위.

---

## GAP·정직 표기 (주 산출)

이 상품은 **NEITHER-gap(견적 원천 부재)** + 봉제 공정 0행. 연결된 공유 GAP: [[gap-goods-sewing-missing]]·[[gap-goods-neither]] (Stage A 민팅·rule/gaps.md). 축 노드(카테고리·자재·사이즈) 미민팅분은 needs_axis로 반환 — 조용한 누락 아님.
