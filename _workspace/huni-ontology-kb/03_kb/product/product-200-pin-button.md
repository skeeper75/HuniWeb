---
id: product-200-pin-button
type: product
anchor: t_prd_products/PRD_000200
badge: candidate
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000200(prd_nm=핀버튼·prd_typ_cd=PRD_TYPE.01·min_qty=4·qty_incr=4·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-stationery-goods.md", source_locator: "문서:§1.2 굿즈/악세사리·§3.5 자재 오염(핀버튼 부속)·§3.10 NEITHER-gap·§4", captured_at: "2026-07-04", badge: verified, src_id: SR-pack-sg}
relations:
  - {rel: derived_from, target: gap-goods-neither, note: "가격 원천 부재(공식·고정가 둘 다 없음)를 GAP으로 정직 선언·O5 gap 연결 예외"}
  - {rel: references, target: gap-goods-price-unloaded, note: "채움 경로=상품마스터 고정가 verbatim 적재 대기"}
  - {rel: references, target: gap-goods-material-contamination, note: "핀버튼 부속(핀·원형/사각 규격)=substrate 자재 아님. MAT_000273/274(원형58/사각57mm)는 del_yn=Y 은퇴(active 0)"}
props:
  prd_typ_cd: "PRD_TYPE.01"
  archetype: "NEITHER-gap(공식·고정가 둘 다 미적재)"
  min_qty: 4           # 단일 스칼라(핀버튼 묶음 4단위·본문 전사표 권위)
  file_upload_yn: "Y"
  editor_yn: "Y"
standards: {schema_org: Product, xjdf: "Product(굿즈)", config_ont: "component type"}
tags: ["#굿즈", "#핀버튼", "#NEITHER-gap", "#비종이", "#자재오염주의"]
updated: 2026-07-04
---

# 핀버튼 (product-200-pin-button)

핀버튼(PRD_000200)은 **굿즈/악세사리 완제품 단품**(prd_typ_cd=`PRD_TYPE.01`). 수량은 4단위 묶음
(min 4·incr 4). 핀(금속 부속)에 인쇄지를 끼우는 뱃지형 굿즈.

- **가격(정직 GAP)**: 공식 0행·고정가 0행 = NEITHER-gap → [[gap-goods-neither]](O5 `derived_from` 예외)·
  채움 경로 [[gap-goods-price-unloaded]].
- **★자재 오염 주의**(팩 §3.5·T-4): `t_prd_product_materials`의 MAT_000273(원형 58mm)·MAT_000274(사각 57mm)는
  **규격 변형값(MAT_TYPE.09)이자 del_yn=Y 은퇴**로 active substrate 0. 핀(부속)은 substrate 자재가 아니라
  `has_addon`/부자재 축(정정본 교훈 [[gap-goods-material-contamination]]) → `uses_material` 미배선.
- **비종이 → 판형 없음**(도메인 [HARD]): `has_plate_size` 미배선. 공정 0행·옵션그룹 0행.
- **카테고리**: 라이프(CAT_000010·main)·기념품/액세서리(CAT_000189) — 축 노드 미민팅 → `in_category` 미배선·needs_axis.

## 상품 정체·수량 (전사)

<!-- transcribed-by: awk t_prd_products.csv PRD_000200 from live-snapshot/latest (snap_20260702_1119) @ 2026-07-04 -->
| prd_typ_cd | use_yn | min_qty | max_qty | qty_incr | qty_unit | file_upload | editor |
|---|---|---|---|---|---|---|---|
| PRD_TYPE.01 | Y | 4 | 10000 | 4 | QTY_UNIT.01 | Y | Y |

## 자재행(전사·은퇴) — substrate 아님

<!-- transcribed-by: awk t_prd_product_materials.csv PRD_000200 from live-snapshot/latest (snap_20260702_1119) @ 2026-07-04 -->
| mat_cd | 자재명 | mat_typ | usage | del_yn |
|---|---|---|---|---|
| MAT_000273 | 원형 58mm | MAT_TYPE.09 | USAGE.07 | Y(은퇴) |
| MAT_000274 | 사각 57mm | MAT_TYPE.09 | USAGE.07 | Y(은퇴) |

> 두 행은 규격 변형값(형상)일 뿐 원단/금속 substrate가 아니며 은퇴 상태 → `uses_material` 미배선(오염 가드).
