---
id: product-215-clipboard
type: product
anchor: t_prd_products/PRD_000215
badge: candidate
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000215(prd_nm=클립보드·prd_typ_cd=PRD_TYPE.01·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-stationery-goods.md", source_locator: "문서:§1.2 굿즈/악세사리(스탬프·기타 215 클립보드)·§3.8 판형 종이류만·§3.10 NEITHER-gap·§4", captured_at: "2026-07-04", badge: verified, src_id: SR-pack-sg}
relations:
  - {rel: in_category, target: category-CAT_000130, qualifier: sub, note: "굿즈 카테고리(보조·live t_prd_product_categories 20260702_1119)"}
  - {rel: in_category, target: category-CAT_000008, note: "문구(main·CAT_000008)·홀더/클립보드(CAT_000130·축 미민팅)"}
  - {rel: derived_from, target: gap-goods-neither, note: "가격 원천 부재(공식·고정가 둘 다 없음)를 GAP으로 정직 선언·O5 gap 연결 예외"}
  - {rel: references, target: gap-goods-price-unloaded, note: "채움 경로=상품마스터 고정가 verbatim 적재 대기"}
props:
  prd_typ_cd: "PRD_TYPE.01"
  archetype: "NEITHER-gap(공식·고정가 둘 다 미적재)"
  min_qty: 1
  file_upload_yn: "Y"
  editor_yn: "Y"
standards: {schema_org: Product, xjdf: "Product(굿즈)", config_ont: "component type"}
tags: ["#굿즈", "#클립보드", "#NEITHER-gap", "#비종이"]
updated: 2026-07-04
---

# 클립보드 (product-215-clipboard)

클립보드(PRD_000215)는 **문구/홀더 완제품 단품**(prd_typ_cd=`PRD_TYPE.01`). A5/A4 규격 클립보드 굿즈.

- **가격(정직 GAP)**: 공식 0행·고정가 0행 = NEITHER-gap → [[gap-goods-neither]](O5 `derived_from` 예외)·
  채움 [[gap-goods-price-unloaded]].
- **자재·공정 empty-shell**: 자재 0행·공정 0행·옵션그룹 0행.
- **판형 없음**(도메인 [HARD]·팩 §3.8): 보드(비종이) 상품이라 `has_plate_size` 미배선. ★live `t_prd_product_plate_sizes`
  2행(SIZ_000414/416)은 **PDF 파일사양·del_yn=Y 은퇴**(active 0)라 종이 판형 아님(관찰 기록).
- **사이즈**: A5용(SIZ_000413·164×230)·A4용(SIZ_000415·230×330) — 굿즈 전용 규격. shared size 축 미민팅이라
  본문 전사표가 권위·`has_size` 미배선(끊긴 링크 방지).
- **카테고리**: 문구(CAT_000008·main) 배선. 홀더/클립보드(CAT_000130) 미민팅 → needs_axis.

## 상품 정체·수량 (전사)

<!-- transcribed-by: awk t_prd_products.csv PRD_000215 from live-snapshot/latest (snap_20260702_1119) @ 2026-07-04 -->
| prd_typ_cd | use_yn | min_qty | max_qty | qty_incr | qty_unit | file_upload | editor |
|---|---|---|---|---|---|---|---|
| PRD_TYPE.01 | Y | 1 | 10000 | 1 | QTY_UNIT.01 | Y | Y |

## 사이즈(전사)

<!-- transcribed-by: awk t_prd_product_sizes.csv+t_siz_sizes.csv PRD_000215 from live-snapshot/latest (snap_20260702_1119) @ 2026-07-04 -->
| siz_cd | 라벨 | work(mm) |
|---|---|---|
| SIZ_000413 | A5용(164x230mm) | 164x230 |
| SIZ_000415 | A4용(230x330mm) | 230x330 |
