---
id: product-248-tyvek-flat-clutch
type: product
anchor: t_prd_products/PRD_000248
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000248(prd_nm=타이벡 플랫 클러치·prd_typ_cd=PRD_TYPE.01·nonspec_yn=N·min_qty=1·max_qty=10000·qty_incr=1·qty_unit_typ_cd=QTY_UNIT.01·file_upload_yn=Y·editor_yn=Y·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-stationery-goods.md", source_locator: "§1.3 파우치(★248 클러치=고정가 12,500)·§3.10 고정가룩업·§4 굿즈 고정가 행", captured_at: "2026-07-04", badge: verified, src_id: SR-pack-stn}
  - {source_file: "live-snapshot/latest/t_prd_product_prices.csv", source_locator: "테이블:t_prd_product_prices 키:PRD_000248 apply_ymd=2026-06-10 unit_price(GP-1 base 단일고정가 §21 R-GP4-1·260610 verbatim)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
relations:
  - {rel: references, target: gap-pouch-empty-shell, note: "가격은 고정가룩업 실재이나 BOM은 자재 0행·공정 0행(empty-shell)·O5는 이 gap 참조로 충족(공식 노드 없음)"}
  - {rel: references, target: gap-goods-sewing-missing, note: "봉제 공정 has_process 0행(MISSING)"}
props:
  prd_typ_cd: "PRD_TYPE.01"
  min_qty: 1
  max_qty: 10000
  qty_incr: 1
  qty_unit_typ_cd: "QTY_UNIT.01"
  file_upload_yn: "Y"
  editor_yn: "Y"
  price_archetype: "고정가룩업(t_prd_product_prices 단일 unit_price·260610 verbatim·전사표 참조·priced_by 공식 노드 없음)"
  substrate: "실 원단 자재 미적재(empty-shell·가격만 고정가 실재)"
  구분: "파우치·백(봉제 상품·비종이·판형 없음)"
standards: {schema_org: "Product", xjdf: "Product(파우치)", config_ont: "component type"}
answers_cq: ["타이벡 플랫 클러치 구성·가격 질의(고정가 실재·값=엔진 권위)"]
tags: ["#파우치", "#타이벡", "#클러치", "#봉제", "#비종이", "#고정가룩업"]
updated: 2026-07-04
---

# 타이벡 플랫 클러치 (product-248-tyvek-flat-clutch)

타이벡 플랫 클러치(PRD_000248)는 **봉제 완제품 단품**(PRD_TYPE.01·셋트 아님). **비종이 → 판형 없음**.
★이 배정 중 유일하게 **가격 원천 실재** — `t_prd_product_prices`에 단일 고정가(260610 verbatim)가 있어
**고정가룩업**으로 견적된다(값 계산=`evaluate_price` 권위·D-18 경계). 다만 BOM은 자재 0행·공정 0행으로
**empty-shell**([[gap-pouch-empty-shell]]·[[gap-goods-sewing-missing]]).

- **가격 경계(D-18)**: 온톨로지는 "고정가 존재" 사실까지만. 실제 값은 아래 전사표가 권위이고 계산은 엔진.
- **O5 충족(공식 노드 없음)**: 고정가룩업은 `t_prd_product_price_formulas` 바인딩이 없어 priced_by 엣지가 없다 → 가격 사슬은 고정가로 닫혀 있으나 그래프 상 formula 노드가 없으므로 empty-shell/봉제 gap 참조로 O5를 충족한다(BOM은 실제로 비어 있어 정직).
- 원단 상품이라 has_plate_size 미배선(도메인 [HARD]). 실 사이즈·카테고리 축 노드 미민팅 → needs_axis.

## 상품 요소 전사표 (권위 = 라이브 스냅샷·awk 결정론 전사)

<!-- transcribed-by: awk over live-snapshot/latest (snap_20260702_1119) t_prd_product_materials+t_prd_product_processes+t_prd_product_prices+t_prd_product_price_formulas+t_prd_product_plate_sizes+t_prd_product_categories PRD_000248 @ 2026-07-04 -->

| 축 | 라이브 값 | 판정 |
|---|---|---|
| 카테고리 | CAT_000228 타이벡파우치 → CAT_000011 에코백 | 축 노드 미민팅(needs_axis) |
| 자재 | 0행 | empty-shell([[gap-pouch-empty-shell]]) |
| 공정 | 0행 | 봉제 MISSING([[gap-goods-sewing-missing]]) |
| 가격공식(t_prd_product_price_formulas) | 0행 | 공식 바인딩 없음(고정가룩업) |
| 고정가(t_prd_product_prices) | 12,500원 <!-- lint-allow: L-12 src=SR-5-livesnap 260610 verbatim --> (apply 2026-06-10) | ★가격 원천 실재(verified·값=엔진 권위) |
| plate_sizes(비종이 오용) | SIZ_000442 640x230 | 판형 아님(관찰·미배선) |

수량 규칙 = 상품 마스터(min 1·max 10000·incr 1·QTY_UNIT.01). 값·치수는 스크립트 전사(D-9).
