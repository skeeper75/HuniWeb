---
id: product-298-perpetual-diary-leather-soft-cover
type: product
anchor: t_prd_products/PRD_000298
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000298 (prd_typ_cd=PRD_TYPE.02·semi_role_cd=SEMI_ROLE.02·del_yn=N·prd_nm '만년다이어리(레더소프트커버)-표지(레더)')", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "live-snapshot/latest/t_prd_product_materials.csv", source_locator: "테이블:t_prd_product_materials 키:(PRD_000298,MAT_000186,USAGE.02) dflt=Y", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-stationery-goods.md", source_locator: "§1.1 구성원 slug(298 표지 레더·SEMI_ROLE.02·표지만)·§3.5 표지 자재·§3.10 구성원 derived_from 부모", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-stn}
relations:
  - {rel: in_category, target: category-CAT_000321, note: "플래너(구성원 카테고리·부모 175 상속)·축 노드 미민팅(needs_axis)"}
  - {rel: uses_material, target: material-MAT_000186, note: "레더(USAGE.02·dflt·MAT_TYPE.05 비종이·live PRD_000298·materials.md 재사용)"}
  - {rel: derived_from, target: product-175-perpetual-diary-leather-soft, note: "표지 가격=부모 175 고정가형 all-in(PRF_STN_DIARY_LSOFT)에서 파생·구성원 기여 0(자체 공식 없음·t_prd_product_price_formulas PRD_000298=0행). 구성원 derived_from 타깃=부모 상품 노드 통일(073/095 동형·C-5)"}
props:
  prd_typ_cd: "PRD_TYPE.02"
  semi_role_cd: "SEMI_ROLE.02"
  role: "만년다이어리(레더소프트커버) 표지 구성원(반제품·레더)"
  set_contribution: "0(부모 고정가 all-in 흡수)"
  parent: "product-175-perpetual-diary-leather-soft"
  file_upload_yn: "N"
  editor_yn: "N"
  구분: "만년다이어리(레더소프트커버)-표지(레더)"
standards: {schema_org: "Product(반제품)", xjdf: "Product(표지 component)", config_ont: "assembly member"}
answers_cq: ["만년다이어리(레더소프트커버) 표지 레더 자재 질의"]
tags: ["#셋트구성원", "#표지", "#반제품", "#문구", "#만년다이어리", "#레더", "#소프트커버"]
updated: 2026-07-03
---

# 만년다이어리(레더소프트커버)-표지 (product-298-perpetual-diary-leather-soft-cover)

만년다이어리(레더소프트커버) 표지 구성원(PRD_000298·반제품·SEMI_ROLE.02). 셋트
[[product-175-perpetual-diary-leather-soft]]의 disp_seq1 멤버(1권 고정·표지만 셋트라 유일 구성원). 표지
자재=**레더(MAT_000186·USAGE.02·MAT_TYPE.05 비종이·판형 불요)**. 셋트 관계는 부모의 `has_member`(R13)로
1급 표현되며, 이 노드는 부모를 [[product-175-perpetual-diary-leather-soft]]로 참조한다.

- **가격(★고정가형 흡수)**: 표지 자체 가격공식 없음. 부모 175가 **고정가형 all-in**(PRF_STN_DIARY_LSOFT)으로
  구성원 값을 흡수하므로 **구성원 기여 = 0**(pack §3.10). 라이브 `t_prd_product_price_formulas`에 PRD_000298
  바인딩 **0행**이므로 자체 `priced_by`를 두지 않고 `derived_from → [[product-175-perpetual-diary-leather-soft]]`
  (부모 all-in 파생)으로 O5 가격사슬을 만족한다(073/095·126 레더 동형). 값=`evaluate_set_price`(D-18).
- **레더=비종이(판형 불요)**: 표지 자재 레더(MAT_TYPE.05)라 판형 미대상(도메인 [HARD]). 자재 1행만.

## 자재 BOM (권위 = 라이브 스냅샷 awk 전사)

<!-- transcribed-by: awk t_prd_product_materials from live-snapshot/latest (snap_20260702_1119) prd_cd=PRD_000298 del_yn=N @ 2026-07-03 -->
| mat_cd | 자재명 | usage | dflt | 축노드 |
|---|---|---|---|---|
| MAT_000186 | 레더 | USAGE.02 | Y | O(uses_material 배선·materials.md 재사용) |
</content>
