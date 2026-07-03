---
id: product-268-canvas-simple-bag
type: product
anchor: t_prd_products/PRD_000268
badge: candidate
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "키:PRD_000268 (캔버스심플백·prd_typ_cd=PRD_TYPE.01·nonspec_yn=N·use_yn=Y·del_yn=N·min1/max10000/incr1·QTY_UNIT.01)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-stationery-goods.md", source_locator: "§1.3 파우치·백(봉제)·§3.5 자재 오염/empty-shell·§3.10 굿즈 고정가룩업/NEITHER-gap·§4 정직표기표", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-stn}
relations:
  - {rel: uses_material, target: material-MAT_000185, note: "캔버스(옥스포드)·MAT_TYPE.05·USAGE.07·실 substrate(공유 축 노드 재사용)"}
  - {rel: has_process, target: process-PROC_000081, qualifier: {mand: "N"}, note: "부착(옵션·정체공정 봉제 아님)"}
  - {rel: references, target: gap-goods-neither, note: "가격 원천 부재(공식·고정가 둘 다 0행·NEITHER-gap)"}
  - {rel: references, target: gap-goods-sewing-missing, note: "부착(PROC_000081)만 있고 봉제 정체공정 미배선"}
  - {rel: references, target: gap-goods-material-contamination, note: ".09 형상/규격값 자재화(비-substrate): MAT_000334(세로M·MAT_TYPE.09)"}
props:
  prd_typ_cd: "PRD_TYPE.01"
  min_qty: 1
  max_qty: 10000
  qty_incr: 1
  qty_unit_typ_cd: "QTY_UNIT.01"
  nonspec_yn: "N"
  file_upload_yn: "Y"
  editor_yn: "Y"
  price_archetype: "NEITHER-gap(t_prd_product_price_formulas·t_prd_product_prices 둘 다 0행·견적 원천 부재)"
  substrate_ref: "캔버스(옥스포드)(MAT_000185)"
  size_print_status: "has_size 0행·has_print_option 0행(라이브 미적재·정직 표기)"
  main_category_ref: "CAT_000011 에코백(축 노드 미민팅·needs_axis·in_category 미배선)"
standards: {schema_org: "Product", xjdf: "Product(백류·봉제)", config_ont: "component type"}
answers_cq: ["구체 상품 질의(캔버스심플백 구성·가격)", "백류/에코백 탐색"]
tags: ["#백류", "#봉제상품", "#비종이류판형없음", "#NEITHER-gap", "#자재오염"]
updated: 2026-07-04
---

# 캔버스심플백 (product-268-canvas-simple-bag)

캔버스심플백(`PRD_000268`)는 **백류·필통(봉제) 완제품 단품**(`prd_typ_cd=PRD_TYPE.01`)이다. 셋트 아님
(`t_prd_product_sets` 부모/구성원 미등록·has_member 없음)·기성/디자인 아님. 비종이(봉제 원단/가죽)라
**판형 불필요**([[rule/rules#RULE_plate_paper_only]]). 파일 업로드·에디터 지원.

- **정체**: pack §1.3(FRESH) + live-snapshot(`PRD_000268` 실재·use_yn=Y·del_yn=N).
- **사이즈/도수**: 라이브 `t_prd_product_sizes`·`t_prd_product_print_options` **0행**(has_size·has_print_option 미배선·정직 표기).
- **substrate 자재**: 캔버스(옥스포드)(MAT_000185). ★비종이 → 판형 없음(도메인 [HARD]).
- **가격 경계(D-18)**: 이 노드는 "가격 존재/부재" 사실까지만. 값 계산=`evaluate_price` 권위.

## 상품 요소 전사 (권위 = 라이브 스냅샷·awk 전사·손전사 금지)

#### 수량 규칙 (전사)

<!-- transcribed-by: awk t_prd_products.csv PRD_000268 from live-snapshot/latest (snap_20260702_1119) @ 2026-07-04 -->
| min_qty | max_qty | qty_incr | qty_unit | nonspec_yn |
|---|---|---|---|---|
| 1 | 10000 | 1 | QTY_UNIT.01 | N |

#### 자재 BOM (전사)

<!-- transcribed-by: awk t_prd_product_materials.csv + t_mat_materials.csv PRD_000268 from live-snapshot/latest (snap_20260702_1119) @ 2026-07-04 -->
| mat_cd | 자재명 | mat_typ | usage_cd | 역할 판정 | KB 배선 |
|---|---|---|---|---|---|
| MAT_000334 | 세로M | MAT_TYPE.09 | USAGE.07 | ★.09 형상/규격값=비-substrate(오염) | 미배선(오염) |
| MAT_000185 | 캔버스(옥스포드) | MAT_TYPE.05 | USAGE.07 | 실 substrate(원단/가죽) | uses_material 배선 |

> ★**자재 오염 주의**(pack §3.5·[[gap-goods-material-contamination]]): `MAT_TYPE.09` 이름이 "세로형/가로형/M/L/블랙M" 등 **형상·규격값**이면 substrate 자재가 아니라 비-소재 값의 자재화(오염)다 → `uses_material` 미배선. 실 원단/가죽(캔버스 .05·린넨 .05·레더 .06·메쉬 .08)만 배선.

#### 공정 (전사)

<!-- transcribed-by: awk t_prd_product_processes.csv + t_proc_processes.csv PRD_000268 from live-snapshot/latest (snap_20260702_1119) @ 2026-07-04 -->
| proc_cd | 공정명 | mand |
|---|---|---|
| PROC_000081 | 부착 | N |

> 부착(PROC_000081)은 옵션 공정. 백류 정체공정 **봉제**는 has_process 0행(미배선)=[[gap-goods-sewing-missing]].

#### 가격 (NEITHER-gap 정직 표기)

가격공식(t_prd_product_price_formulas)·고정가(t_prd_product_prices) **둘 다 0행** = 견적 원천 부재([[gap-goods-neither]]). "가격 있는 것처럼" 배선하지 않음(정직 표기).

## 가격·BOM 정직 표기 (양면/GAP)

O5(끊긴 가격 사슬) 충족 = **가격공식 노드 없음**(priced_by 미배선)이나 아래 gap 선언 보유:
- [[gap-goods-neither]] — 가격 원천 부재(공식·고정가 둘 다 0행·NEITHER-gap)
- [[gap-goods-sewing-missing]] — 부착(PROC_000081)만 있고 봉제 정체공정 미배선
- [[gap-goods-material-contamination]] — .09 형상/규격값 자재화(비-substrate): MAT_000334(세로M·MAT_TYPE.09)

★삭제·날조 금지: 라이브 IMPORT 등록 자재는 "배선 안 됨"을 사유로 삭제 금지
([[gap-goods-material-contamination]]).
