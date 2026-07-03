---
id: product-187-black-square-hand-mirror
type: product
anchor: t_prd_products/PRD_000187
badge: candidate
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "키:PRD_000187 (prd_typ_cd=PRD_TYPE.01·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "live-snapshot/latest/t_prd_product_sizes.csv", source_locator: "키:PRD_000187 siz_cd SIZ_000384/386/388 (del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-stationery-goods.md", source_locator: "§1.2 거울류·§3.10 NEITHER-gap·§4", captured_at: "2026-07-04", badge: verified, src_id: SR-pack-sg}
relations:
  - {rel: in_category, target: category-CAT_000323, qualifier: sub, note: "굿즈 카테고리(보조·live t_prd_product_categories 20260702_1119)"}
  - {rel: in_category, target: category-CAT_000010, qualifier: main, note: "굿즈 카테고리(main·live t_prd_product_categories 20260702_1119)"}
  - {rel: has_size, target: size-SIZ_000384, note: "S(75x130mm)·186 canonical"}
  - {rel: has_size, target: size-SIZ_000386, note: "M(95x166mm)·186 canonical"}
  - {rel: has_size, target: size-SIZ_000388, note: "L(120x218mm)·186 canonical"}
  - {rel: references, target: gap-goods-neither, note: "가격 원천 부재→O5 충족"}
props:
  prd_typ_cd: "PRD_TYPE.01"
  min_qty: 1
  qty_unit_typ_cd: "QTY_UNIT.01"
  file_upload_yn: "Y"
  editor_yn: "Y"
  가격상태: "NEITHER-gap(공식 0행·고정가 0행)"
  구분: "거울류 완제품 단품(블랙·비종이·S/M/L 3규격)"
standards: {schema_org: "Product", xjdf: "Product(굿즈·거울)", config_ont: "component type"}
tags: ["#굿즈", "#거울류", "#NEITHER-gap", "#비종이"]
updated: 2026-07-04
---

# 블랙사각손거울 (product-187-black-square-hand-mirror)

블랙사각손거울(PRD_000187)은 **굿즈 완제품 단품**(PRD_TYPE.01·비종이·블랙 색상 변형). 단품(셋트 아님).
사각손거울(186)과 동일한 **S/M/L 3규격**을 공유(186 canonical). 가격은 **NEITHER-gap** — 공식도 고정가도
라이브 부재 → [[gap-goods-neither]] 정직 선언.

- **비종이=판형 없음**([[rule/rules#RULE_plate_paper_only]]): plate 행(SIZ_000385/387/389·PDF)은 del_yn=Y 파일업로드 규격 → `has_plate_size` 0.
- **없는 축(정직)**: 자재 product_materials 0행·도수·인쇄옵션·CPQ·제약·추가상품 전부 0행.
- 수량규칙=상품 컬럼(min 1·max 10000·incr 1·QTY_UNIT.01).

## 사이즈 전사 (권위 = 라이브 스냅샷·awk 전사)

<!-- transcribed-by: awk t_prd_product_sizes.csv + t_siz_sizes.csv from live-snapshot/latest (snap_20260702_1119) PRD_000187 @ 2026-07-04 -->
| siz_cd | 라벨 | 작업/재단(mm) | master del_yn |
|---|---|---|---|
| SIZ_000384 | S(75x130mm) | 75×130 | N |
| SIZ_000386 | M(95x166mm) | 95×166 | N |
| SIZ_000388 | L(120x218mm) | 120×218 | N |

3규격 전부 `has_size` 배선(축 노드 canonical=product-186 공유·재-mint 없음·L-3 회피).
