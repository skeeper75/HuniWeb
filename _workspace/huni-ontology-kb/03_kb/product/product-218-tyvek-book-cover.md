---
id: product-218-tyvek-book-cover
type: product
anchor: t_prd_products/PRD_000218
badge: candidate
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "키:PRD_000218 (prd_typ_cd=PRD_TYPE.03·use_yn=Y·del_yn=N·min/max/incr 공란)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-stationery-goods.md", source_locator: "§0.1 218 타이벡북커버(기성.03·인쇄 BOM N/A)·§1.2 굿즈", captured_at: "2026-07-04", badge: candidate, src_id: SR-pack-stn}
relations:
  - {rel: references, target: gap-goods-neither, note: "가격 원천 부재(price_formulas 0행·prices 0행)=NEITHER-gap. O5 충족"}
props:
  prd_typ_cd: "PRD_TYPE.03"
  archetype: "기성(제조없음)·NEITHER-gap(가격 원천 부재)"
  use_yn: "Y"
  del_yn: "N"
  min_qty: null
  max_qty: null
  qty_incr: null
  file_upload_yn: "N"
  editor_yn: "N"
standards: {schema_org: "Product", xjdf: "Product(기성 부자재)", config_ont: "component type"}
answers_cq: ["구체 상품 질의(타이벡북커버)"]
tags: ["#기성상품", "#굿즈", "#NEITHER-gap"]
updated: 2026-07-04
---

# 타이벡북커버 (product-218-tyvek-book-cover)

타이벡북커버(PRD_000218)는 **기성상품**(`prd_typ_cd=PRD_TYPE.03`·제조 없음·인쇄 BOM N/A). 타이벡
원단 북커버 완성품이다. `t_prd_product_sets` 미등재·파일 업로드/에디터 미사용. 상품 레벨 수량규칙
(min/max/incr) 공란(제조 없는 기성이라 수량 그릇 미설정).

- **정체:** 라이브 `t_prd_products`(기성.03). 팩 §0.1 "기성상품 → 인쇄 BOM N/A"(218 명시).
- **NEITHER-gap:** 가격공식·고정가 **둘 다 0행** → [[gap-goods-neither]]. 값 있는 것처럼 표기 금지.
- **자재·공정 empty-shell:** `t_prd_product_materials` 0행·`t_prd_product_processes` 0행. 판형 없음
  (타이벡 비종이·plate_sizes 0행).

## 규격(사이즈) — 관찰 전사

<!-- transcribed-by: awk t_prd_product_sizes.csv+t_siz_sizes.csv (del_yn≠Y) PRD_000218 from live-snapshot/latest snap_20260702_1119 @ 2026-07-04 -->
| siz_cd | 라벨 |
|---|---|
| SIZ_000426 | A5 (148x210) |

활성 1행. SIZ_000426(A5)는 스티커 계열과도 공유되는 사이즈이나 축 노드 소유가 모호(실사 A5는 별도
SIZ_000170) → `has_size` 배선 대기(전사표 관찰 권위·needs_axis).

## 옵션·제약·추가상품
- CPQ 옵션그룹·제약규칙·추가상품 라이브 행 **없음**. 카테고리 = 홀더/클립보드(CAT_000130·축 노드
  미민팅=needs_axis).
