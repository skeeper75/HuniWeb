---
id: product-078-leather-hardcover-booklet-cover
type: product
anchor: t_prd_products/PRD_000078
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000078 (prd_typ_cd=PRD_TYPE.02·semi_role_cd=SEMI_ROLE.02·del_yn=N·prd_nm 레더 하드커버책자-표지(레더(화이트)))", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "live-snapshot/latest/t_prd_product_materials.csv", source_locator: "테이블:t_prd_product_materials 키:(PRD_000078,MAT_000379,USAGE.02) dflt=Y", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-set-series.md", source_locator: "§3.6 COVERBIND 통가·§3.5 표지 레더 자재", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-set}
relations:
  - {rel: uses_material, target: material-MAT_000379, note: "레더(화이트) 표지(USAGE.02·dflt·live PRD_000078)"}
  - {rel: derived_from, target: product-077-leather-hardcover-booklet, note: "표지 가격=부모 077 COVERBIND 통가에 baked(자체 공식 없음·set_eval 기여=NONE). 레더 자재 델타 미반영(use_dims=[min_qty]·C트랙). 구성원 derived_from 타깃=부모 상품 노드 통일(082/088/100 동형·C-5)"}
props:
  prd_typ_cd: "PRD_TYPE.02"
  semi_role_cd: "SEMI_ROLE.02"
  role: "레더 하드커버책자 표지 구성원(반제품·레더(화이트))"
  set_contribution: "NONE(COVERBIND all-in)"
  구분: "레더 하드커버책자-표지(레더(화이트))"
standards: {schema_org: "Product", xjdf: "Product(표지 component)", config_ont: "component"}
answers_cq: ["레더 하드커버책자 표지 자재 질의"]
tags: ["#셋트구성원", "#표지", "#반제품", "#책자", "#레더", "#COVERBIND"]
updated: 2026-07-03
---

# 레더 하드커버책자-표지 (product-078-leather-hardcover-booklet-cover)

레더 하드커버책자 표지 구성원(PRD_000078·반제품·SEMI_ROLE.02). 셋트
[[product-077-leather-hardcover-booklet]]의 disp_seq1 멤버(1권고정). **073 표지와 동형이되 자재만
레더(화이트·MAT_000379·USAGE.02)**. 표지 가격은 부모 셋트공식
[[formula/set-formulas#formula-PRF_HC_MUSEON_SET]]의 COVERBIND 통가에 포함(자체 공식 없음·기여=NONE·
077-post-verify §2). `derived_from → [[product-077-leather-hardcover-booklet]]`로 부모 셋트 파생 표기(타깃=부모 상품 노드 통일·C-5).

- **★레더 델타 미반영(C트랙)**: COVERBIND use_dims=[min_qty]라 레더(078) vs 전용지(073) 자재 델타가 가격에
  반영 안 됨 → 077/072 골든이 동일한 근본 이유. 엔진 use_dims 확장 C트랙 [[product-072-hardcover-booklet-nodes#gap-set-leather-coverbind-delta]].
- **사이즈·인쇄·판형 0행**: COVERBIND 통가라 미등록.

## 자재 BOM (권위 = 라이브 스냅샷 awk 전사)

<!-- transcribed-by: awk t_prd_product_materials from live-snapshot/latest (snap_20260702_1119) prd_cd=PRD_000078 @ 2026-07-03 -->
| mat_cd | 자재명 | usage | dflt | 축노드 |
|---|---|---|---|---|
| MAT_000379 | 레더(화이트) | USAGE.02 | Y | ✗ 축 미민팅(needs_axis) |

레더 자재 MAT_000379은 공유 축 미민팅 → needs_axis 반환.
</content>
