---
id: product-002-opp-non-adhesive-envelope
type: product
anchor: t_prd_products/PRD_000002
badge: candidate
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "키:PRD_000002 (prd_typ_cd=PRD_TYPE.03·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-stationery-goods.md", source_locator: "§1.4 봉투류 002 OPP비접착봉투(NEITHER-gap)·§0.1 기성.03·§4 NEITHER-gap 행", captured_at: "2026-07-04", badge: candidate, src_id: SR-pack-stn}
relations:
  - {rel: references, target: gap-goods-neither, note: "가격 원천 부재(price_formulas 0행·prices 0행)=NEITHER-gap. O5 충족(priced_by 없음)"}
props:
  prd_typ_cd: "PRD_TYPE.03"
  archetype: "기성(제조없음)·NEITHER-gap(가격 원천 부재)"
  use_yn: "Y"
  del_yn: "N"
  min_qty: 1
  max_qty: 100
  qty_incr: 1
  file_upload_yn: "N"
  editor_yn: "N"
  addon_target_of: "016 프리미엄엽서(TMPL-000006)·024 포토카드(TMPL-000012/030) 봉투 추가상품 base_prd"
standards: {schema_org: "Product", xjdf: "Product(봉투/Envelope)", config_ont: "component type"}
answers_cq: ["구체 상품 질의(OPP비접착봉투 규격)", "봉투 추가상품 대상 확인"]
tags: ["#봉투", "#기성상품", "#NEITHER-gap", "#addon대상"]
updated: 2026-07-04
---

# OPP비접착봉투 (product-002-opp-non-adhesive-envelope)

OPP비접착봉투(PRD_000002)는 **기성상품**(`prd_typ_cd=PRD_TYPE.03`·제조 없음). 접착 밴드가 없는
OPP 필름 봉투 완성품이다. `t_prd_product_sets` 미등재(셋트 아님)·파일 업로드/에디터 미사용. 최소 1·
최대 100·증분 1. 미리 정해진 규격(60x90~160x250mm)에서 고른다.

- **정체:** 라이브 `t_prd_products`(기성.03·라이브 정직 표기 — 팩 §1.4 `.01` 서술과 상이, 권위=라이브).
- **NEITHER-gap:** 가격공식·고정가 **둘 다 0행**(견적 원천 부재) → [[gap-goods-neither]]. 값 있는 것처럼
  표기 금지.
- **판형 없음:** OPP 비종이 + 완성 기성품 → 판형·판걸이수 해당 없음(라이브 plate_sizes 0행).

## 규격(사이즈) — 관찰 전사

<!-- transcribed-by: awk t_prd_product_sizes.csv+t_siz_sizes.csv (del_yn≠Y) PRD_000002 from live-snapshot/latest snap_20260702_1119 @ 2026-07-04 -->
| siz_cd | 라벨 |
|---|---|
| SIZ_000372 | 60x90mm |
| SIZ_000079 | 80x100mm |
| SIZ_000080 | 80x120mm |
| SIZ_000081 | 80x180mm |
| SIZ_000085 | 110x160mm |
| SIZ_000091 | 110x250mm |
| SIZ_000092 | 140x180mm |
| SIZ_000093 | 140x200mm |
| SIZ_000094 | 150x150mm |
| SIZ_000095 | 160x250mm |

활성 10행(SIZ_000089/090은 del_yn=Y 은퇴). 사이즈 축 미민팅 → `has_size` 배선 대기(전사표 관찰 권위).

## 자재(BOM) — 관찰 전사 (자기참조 변형 SKU)

<!-- transcribed-by: awk t_prd_product_materials.csv+t_mat_materials.csv (del_yn≠Y) PRD_000002 from live-snapshot/latest snap_20260702_1119 @ 2026-07-04 -->
활성 10행 · 전부 USAGE.07. 자재명=봉투 규격 변형("OPP비접착봉투 NN x NN mm") = 기성 자기참조 SKU
(substrate 아님). 대표: MAT_000508(60x90) ~ MAT_000519(160x250). `uses_material` 배선은 미민팅 대기.

## 옵션·제약·추가상품

- **CPQ 옵션그룹:** `t_prd_product_option_groups` = 002 행 1개(OPT-000001 "제본방식")이나 **del_yn=Y**
  (삭제 스캐폴딩) → 활성 옵션 없음. 노드 미등재.
- **제약규칙:** 002 행 없음.
- **추가상품(피참조):** 002는 봉투 추가상품 대상(base_prd) — 016(TMPL-000006)·024 포토카드
  (TMPL-000012 20장·TMPL-000030 50장)이 이 상품을 가리킨다. `has_addon`은 엽서/포토카드 쪽에서 배선.
  이 노드 생성으로 [[gap-016-addon-target]]·[[gap-024-addon-envelope]] 대상 부재 일부 해소 가능(엣지
  배선은 검증가/Stage C 소관).
