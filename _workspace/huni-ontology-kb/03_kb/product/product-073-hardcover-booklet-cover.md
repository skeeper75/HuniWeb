---
id: product-073-hardcover-booklet-cover
type: product
anchor: t_prd_products/PRD_000073
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000073 (prd_typ_cd=PRD_TYPE.02·semi_role_cd=SEMI_ROLE.02·del_yn=N·prd_nm 하드커버책자-표지(전용지))", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "live-snapshot/latest/t_prd_product_materials.csv", source_locator: "테이블:t_prd_product_materials 키:(PRD_000073,MAT_000246,USAGE.02) dflt=Y", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-set-series.md", source_locator: "§3.6 COVERBIND 통가(표지+제본·자재 미종속)·§3.5 표지 자재", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-set}
relations:
  - {rel: in_category, target: category-CAT_000105, note: "하드커버책자(main·live)"}
  - {rel: uses_material, target: material-MAT_000246, note: "표지 전용지(USAGE.02·dflt·live PRD_000073)"}
  - {rel: derived_from, target: product-072-hardcover-booklet, note: "표지 가격=부모 072 COVERBIND 통가에 baked(자체 공식 없음·set_eval 기여=NONE). COVERBIND use_dims=[min_qty]라 표지 자재 델타 미반영(gap-set-088-redesign 인접·C트랙). 구성원 derived_from 타깃=부모 상품 노드 통일(082/088/100 동형·C-5)"}
props:
  prd_typ_cd: "PRD_TYPE.02"
  semi_role_cd: "SEMI_ROLE.02"
  role: "하드커버책자 표지 구성원(반제품·전용지)"
  set_contribution: "NONE(COVERBIND all-in)"
  구분: "하드커버책자-표지(전용지)"
standards: {schema_org: "Product", xjdf: "Product(표지 component)", config_ont: "component"}
answers_cq: ["하드커버책자 표지 자재 질의"]
tags: ["#셋트구성원", "#표지", "#반제품", "#책자", "#COVERBIND"]
updated: 2026-07-03
---

# 하드커버책자-표지 (product-073-hardcover-booklet-cover)

하드커버책자 표지 구성원(PRD_000073·반제품·SEMI_ROLE.02). 셋트
[[product-072-hardcover-booklet]]의 disp_seq1 멤버(1권고정). 표지 자재=**전용지(MAT_000246·USAGE.02)**.
표지 가격은 부모 셋트공식 [[formula/set-formulas#formula-PRF_HC_MUSEON_SET]]의 **COVERBIND 통가에 포함**
(표지+제본 통가·use_dims=[min_qty]·자재 미종속·팩 §3.6)이라 자체 가격공식이 없고 evaluate_set_price 기여=NONE
(072-post-verify §2). 그 관계를 `derived_from → [[product-072-hardcover-booklet]]`(가격이 부모 셋트에서 파생·타깃=부모 상품 노드로 통일·C-5)으로 표기한다.

- **사이즈·인쇄·판형 0행**: 표지는 COVERBIND 통가라 라이브에 사이즈/인쇄/판형 미등록(팩 §3.2 표지 펼침 siz는 가격 좌표 밖).
- **표지 자재 델타 미반영(C트랙)**: COVERBIND use_dims=[min_qty]라 전용지/레더 델타 미반영 → [[product-072-hardcover-booklet-nodes#gap-set-leather-coverbind-delta]].

## 자재 BOM (권위 = 라이브 스냅샷 awk 전사)

<!-- transcribed-by: awk t_prd_product_materials from live-snapshot/latest (snap_20260702_1119) prd_cd=PRD_000073 @ 2026-07-03 -->
| mat_cd | 자재명 | usage | dflt | 축노드 |
|---|---|---|---|---|
| MAT_000246 | 전용지 | USAGE.02 | Y | ✗ 축 미민팅(needs_axis) |

표지 자재 MAT_000246은 공유 축 미민팅 → needs_axis 반환(uses_material 배선 없이 이 BOM이 권위).
</content>
