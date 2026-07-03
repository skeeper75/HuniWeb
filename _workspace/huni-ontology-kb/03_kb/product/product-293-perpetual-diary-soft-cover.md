---
id: product-293-perpetual-diary-soft-cover
type: product
anchor: t_prd_products/PRD_000293
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000293 (prd_typ_cd=PRD_TYPE.02·semi_role_cd=SEMI_ROLE.02·del_yn=N·prd_nm '만년다이어리(소프트커버)-표지(아트250+무광코팅)')", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "live-snapshot/latest/t_prd_product_materials.csv", source_locator: "테이블:t_prd_product_materials 키:(PRD_000293,MAT_000250,USAGE.02) dflt=Y", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-stationery-goods.md", source_locator: "§1.1 구성원 slug(293 표지·SEMI_ROLE.02)·§3.5 표지 자재·§3.10 구성원 derived_from 부모(자체공식 0)", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-stn}
relations:
  - {rel: in_category, target: category-CAT_000321, note: "플래너(구성원 카테고리·부모 172 상속)·축 노드 미민팅(needs_axis)"}
  - {rel: uses_material, target: material-MAT_000250, note: "아트250+무광코팅(USAGE.02·dflt·live PRD_000293)"}
  - {rel: derived_from, target: product-172-perpetual-diary-soft, note: "표지 가격=부모 172 고정가형 all-in(PRF_STN_DIARY_SOFT)에서 파생·구성원 기여 0(자체 공식 없음·t_prd_product_price_formulas PRD_000293=0행). 구성원 derived_from 타깃=부모 상품 노드 통일(073/095 동형·C-5)"}
props:
  prd_typ_cd: "PRD_TYPE.02"
  semi_role_cd: "SEMI_ROLE.02"
  role: "만년다이어리(소프트커버) 표지 구성원(반제품)"
  set_contribution: "0(부모 고정가 all-in 흡수)"
  parent: "product-172-perpetual-diary-soft"
  file_upload_yn: "N"
  editor_yn: "N"
  구분: "만년다이어리(소프트커버)-표지(아트250+무광코팅)"
standards: {schema_org: "Product(반제품)", xjdf: "Product(표지 component)", config_ont: "assembly member"}
answers_cq: ["만년다이어리(소프트커버) 표지 자재 질의"]
tags: ["#셋트구성원", "#표지", "#반제품", "#문구", "#만년다이어리"]
updated: 2026-07-03
---

# 만년다이어리(소프트커버)-표지 (product-293-perpetual-diary-soft-cover)

만년다이어리(소프트커버) 표지 구성원(PRD_000293·반제품·SEMI_ROLE.02). 셋트
[[product-172-perpetual-diary-soft]]의 disp_seq1 멤버(1권 고정·표지만 셋트라 유일 구성원). 표지 자재=
**아트250+무광코팅(MAT_000250·USAGE.02·MAT_TYPE.01)**. 셋트 관계는 부모의 `has_member`(R13)로 1급
표현되며(스키마 19관계에 member_of 없음), 이 노드는 부모를 [[product-172-perpetual-diary-soft]]로 참조한다.

- **가격(★고정가형 흡수)**: 표지 자체 가격공식 없음. 부모 172가 **고정가형 all-in**(PRF_STN_DIARY_SOFT)으로
  구성원 값을 흡수하므로 **구성원 기여 = 0**(pack §3.10). 라이브 `t_prd_product_price_formulas`에 PRD_000293
  바인딩 **0행**이므로 자체 `priced_by`를 두지 않고 `derived_from → [[product-172-perpetual-diary-soft]]`(가격이
  부모 all-in에서 파생)으로 O5 가격사슬을 만족한다(073/095 동형·라이브 미실재 앵커 위조 회피). 값=`evaluate_set_price`(D-18).
- **사이즈·인쇄·판형 0행**: 표지 멤버는 라이브에 사이즈/인쇄/판형 미등록(부모 172가 차원 보유). 자재 1행만.

## 자재 BOM (권위 = 라이브 스냅샷 awk 전사)

<!-- transcribed-by: awk t_prd_product_materials from live-snapshot/latest (snap_20260702_1119) prd_cd=PRD_000293 del_yn=N @ 2026-07-03 -->
| mat_cd | 자재명 | usage | dflt | 축노드 |
|---|---|---|---|---|
| MAT_000250 | 아트250+무광코팅 | USAGE.02 | Y | O(uses_material 배선·materials.md 기존) |
</content>
