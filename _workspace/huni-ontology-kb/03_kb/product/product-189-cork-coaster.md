---
id: product-189-cork-coaster
type: product
anchor: t_prd_products/PRD_000189
badge: candidate
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "키:PRD_000189 (prd_typ_cd=PRD_TYPE.01·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "live-snapshot/latest/t_prd_product_materials.csv", source_locator: "키:(PRD_000189,MAT_000263) — MAT_000263 원형90mm master del_yn=Y", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-stationery-goods.md", source_locator: "§1.2 코스터류·§3.5 자재 오염·§3.10 NEITHER-gap·§4", captured_at: "2026-07-04", badge: verified, src_id: SR-pack-sg}
relations:
  - {rel: references, target: gap-goods-neither, note: "가격 원천 부재→O5 충족"}
  - {rel: references, target: gap-goods-material-contamination, note: "MAT_000263 원형90mm=형상값 .09·del_yn=Y·코르크 실 substrate 부재"}
props:
  prd_typ_cd: "PRD_TYPE.01"
  min_qty: 1
  qty_unit_typ_cd: "QTY_UNIT.01"
  file_upload_yn: "Y"
  editor_yn: "Y"
  가격상태: "NEITHER-gap(공식 0행·고정가 0행)"
  자재상태: "활성 substrate 0(참조 1종 형상값·del_yn=Y·코르크 소재 미적재)"
  구분: "코스터류 완제품 단품(비종이·코르크)"
standards: {schema_org: "Product", xjdf: "Product(굿즈·코스터)", config_ont: "component type"}
tags: ["#굿즈", "#코스터류", "#NEITHER-gap", "#자재오염", "#비종이"]
updated: 2026-07-04
---

# 코르크코스터 (product-189-cork-coaster)

코르크코스터(PRD_000189)은 **굿즈 완제품 단품**(PRD_TYPE.01·비종이·코르크). 단품(셋트 아님). 가격은
**NEITHER-gap** → [[gap-goods-neither]]. 자재는 product_materials 1행(MAT_000263 "원형 90mm")뿐인데
이는 MAT_TYPE.09 **형상값 오염**(비-소재·master del_yn=Y)이라 **코르크 실 substrate가 없다** →
[[gap-goods-material-contamination]] 정직 선언(`uses_material` 배선 없음).

- **자재 오염(T-4·pack §3.5·[GP-ST-003])**: "원형 90mm"=형상 descriptor를 자재로 오적재(del_yn=Y). junction(del_yn=N)이 삭제 master를 가리키는 고아. 코르크 소재 자체는 미적재.
- **비종이=판형 없음**: plate 행(SIZ_000113·PDF) del_yn=Y 파일업로드 규격 → `has_plate_size` 0.
- **없는 축(정직)**: 도수·인쇄옵션·CPQ·제약·추가상품·product_sizes 전부 0행.
- 수량규칙=상품 컬럼(min 1·max 10000·incr 1·QTY_UNIT.01).

## 자재 BOM (권위 = 라이브 스냅샷·awk 전사·오염 판정)

<!-- transcribed-by: awk t_prd_product_materials.csv + t_mat_materials.csv from live-snapshot/latest (snap_20260702_1119) PRD_000189 @ 2026-07-04 -->
| mat_cd | 자재명 | mat_typ_cd | master del_yn | 판정 |
|---|---|---|---|---|
| MAT_000263 | 원형 90mm | MAT_TYPE.09 | Y | 형상값 오염(비-소재)·코르크 실소재 부재 |

활성 substrate 0 → `uses_material` 없음. 코르크 소재 충전=실무진/dbmap 대기.
