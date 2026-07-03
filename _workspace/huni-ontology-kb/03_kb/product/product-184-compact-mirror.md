---
id: product-184-compact-mirror
type: product
anchor: t_prd_products/PRD_000184
badge: candidate
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "키:PRD_000184 (prd_typ_cd=PRD_TYPE.01·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-stationery-goods.md", source_locator: "§1.2 거울류(183~187)·§3.10 NEITHER-gap·§4 정직표기", captured_at: "2026-07-04", badge: verified, src_id: SR-pack-sg}
relations:
  - {rel: uses_material, target: material-MAT_000262, note: "틴거울 소재(183 canonical·활성)·USAGE.07"}
  - {rel: references, target: gap-goods-neither, note: "가격 원천 부재→O5 충족"}
props:
  prd_typ_cd: "PRD_TYPE.01"
  min_qty: 1
  qty_unit_typ_cd: "QTY_UNIT.01"
  file_upload_yn: "Y"
  editor_yn: "Y"
  가격상태: "NEITHER-gap(공식 0행·고정가 0행)"
  구분: "거울류 완제품 단품(비종이·금속)"
standards: {schema_org: "Product", xjdf: "Product(굿즈·거울)", config_ont: "component type"}
tags: ["#굿즈", "#거울류", "#NEITHER-gap", "#비종이"]
updated: 2026-07-04
---

# 컴팩트거울 (product-184-compact-mirror)

컴팩트거울(PRD_000184)은 **굿즈 완제품 단품**(PRD_TYPE.01·비종이). 단품(셋트 아님). 본체 소재는
**틴거울(MAT_000262·활성·183 canonical)** 1종을 공유 참조(USAGE.07). 가격은 **NEITHER-gap** —
공식도 고정가도 라이브 부재 → [[gap-goods-neither]] 정직 선언.

- **비종이=판형 없음**([[rule/rules#RULE_plate_paper_only]]): plate 행(SIZ_000017·JPG)은 del_yn=Y 파일업로드 규격 → `has_plate_size` 0(정상).
- **없는 축(정직)**: 도수·인쇄옵션·CPQ·제약·추가상품·product_sizes 전부 0행.
- 수량규칙=상품 컬럼(min 1·max 10000·incr 1·QTY_UNIT.01).

## 자재 BOM (권위 = 라이브 스냅샷·awk 전사)

<!-- transcribed-by: awk t_prd_product_materials.csv + t_mat_materials.csv from live-snapshot/latest (snap_20260702_1119) PRD_000184 @ 2026-07-04 -->
| mat_cd | 자재명 | mat_typ_cd | usage_cd | master del_yn |
|---|---|---|---|---|
| MAT_000262 | 틴거울 | MAT_TYPE.12 | USAGE.07 | N (활성) |

틴거울 소재를 183과 공유(축 노드 canonical=product-183·오염 없음).
