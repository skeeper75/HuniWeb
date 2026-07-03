---
id: product-290-perfect-bound-booklet-cover
type: product
anchor: t_prd_products/PRD_000290
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "키:PRD_000290 (prd_nm=무선책자-표지·prd_typ_cd=PRD_TYPE.02·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "live-snapshot/latest/t_prd_product_price_formulas.csv", source_locator: "테이블:t_prd_product_price_formulas 키:(PRD_000290,PRF_BOOK_COVER)·note '펼침 cover_mult=1·SIZ_000499 판형·068 동형'", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-set-series.md", source_locator: "§3.10 표지 3비목·§3.12 구성원 역할·§4 코팅 드롭 C트랙·§1 인벤토리 069", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-set}
relations:
  - {rel: uses_material, target: material-MAT_000073, note: "무선표지 종이(USAGE.01·live PRD_000290)"}
  - {rel: uses_material, target: material-MAT_000077, note: "무선표지 종이(USAGE.01·live PRD_000290)"}
  - {rel: uses_material, target: material-MAT_000087, note: "무선표지 종이(USAGE.01·live PRD_000290)"}
  - {rel: uses_material, target: material-MAT_000095, note: "무선표지 종이(USAGE.01·live PRD_000290)"}
  - {rel: uses_material, target: material-MAT_000096, note: "무선표지 종이(USAGE.01·live PRD_000290)"}
  - {rel: uses_material, target: material-MAT_000104, note: "무선표지 종이(USAGE.01·live PRD_000290)"}
  - {rel: priced_by, target: formula-PRF_BOOK_COVER}
  - {rel: has_process, target: process-PROC_000004, qualifier: mandatory, note: "디지털인쇄 base(mand_proc_yn=Y·인쇄비 원천)"}
  - {rel: has_process, target: process-PROC_000015, note: "무광라미네이팅(표지 코팅)"}
  - {rel: has_plate_size, target: plate-OUTPUT_PAPER_TYPE_01, note: "국전 출력용지(종이류·SIZ_000499·A3펼침 pansu=1)"}
props:
  prd_typ_cd: "PRD_TYPE.02"
  semi_role_cd: "SEMI_ROLE.02"
  member_of: "product-069-perfect-bound-booklet"
  cover_mult: 1
  구분: "무선책자 표지(반제품 구성원·펼침·3비목)"
standards: {schema_org: "Product(부품)", xjdf: "Component(Cover)", config_ont: "component instance"}
tags: ["#셋트구성원", "#표지", "#무선제본", "#반제품", "#펼침"]
updated: 2026-07-03
---

# 무선책자 표지 (product-290-perfect-bound-booklet-cover)

무선책자 표지(PRD_000290)는 **반제품 구성원**(`PRD_TYPE.02`·역할 `SEMI_ROLE.02 표지`)으로, 셋트 부모
[[product-069-perfect-bound-booklet]]의 has_member(disp_seq=1)로 조립된다. 중철 표지(288)와 동형(펼침·
`cover_mult=1`·3비목)이며, 무선/PUR 표지(290/292)와 사실상 같은 표지 사양이다.

- **가격(D-18 경계)**: [[formula/set-formulas#formula-PRF_BOOK_COVER]](인쇄+코팅+용지 3비목). 표지 기여 →
  부모 `evaluate_set_price` 합산(068/069/070 표지 골든 동일 88,688 단품 기준).
- **★코팅 드롭 양면(C트랙)**: 288과 동일 — 셋트 시뮬레이터가 `coat_side_cnt` 드롭 → 셋트경로 표지 기여
  38,688(코팅 50,000 저평가·PRICE≠0 무해) = 코드 C트랙 [[rule/gaps#gap-set-s1s2-double]].
- **판형·사이즈**: 종이류 → `plate-OUTPUT_PAPER_TYPE_01`(국전·A3펼침 pansu=1). 작업 사이즈 = SIZ_000174
  (A3 297x420·펼침) — 축 노드 미민팅(needs_axis).
- **자재 커버리지**: 표지 자재 7종(백색모조지120/아트지120/스노우지120/앙상블100~130/몽블랑100~130 USAGE.01)
  공유 axis 미민팅 → BOM 표 권위(needs_axis).

## 구성원 축 (BOM·전사표)

<!-- transcribed-by: awk t_prd_product_processes.csv PRD_000290 from live-snapshot/latest @ 2026-07-03 -->
| proc_cd | 공정명 | mand | 축노드 | has_process |
|---|---|---|---|---|
| PROC_000004 | 디지털인쇄 | Y | O | O |
| PROC_000015 | 무광라미네이팅 | N | O | O |

<!-- transcribed-by: awk t_prd_product_materials.csv PRD_000290 (USAGE.01) from live-snapshot/latest @ 2026-07-03 -->
| mat_cd | 자재명 | usage_cd |
|---|---|---|
| MAT_000073 | 백색모조지 120g | USAGE.01 |
| MAT_000077 | 아트지 120g | USAGE.01 |
| MAT_000087 | 스노우지 120g | USAGE.01 |
| MAT_000095 | 앙상블 100g | USAGE.01 |
| MAT_000096 | 앙상블 130g | USAGE.01 |
| MAT_000104 | 몽블랑 100g | USAGE.01 |
| MAT_000105 | 몽블랑 130g | USAGE.01 |

사이즈 = SIZ_000174(A3 펼침·dflt) 1행. 인쇄옵션 = 단면/양면 × CLR_000005(CMYK 4도). BOM 관찰만.
</content>
