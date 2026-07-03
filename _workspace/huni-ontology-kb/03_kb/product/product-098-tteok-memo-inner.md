---
id: product-098-tteok-memo-inner
type: product
anchor: t_prd_products/PRD_000098
badge: verified
sources:
  - {source_file: "RAILWAY_DB live (railway·읽기전용 SELECT)", source_locator: "테이블:t_prd_products 키:PRD_000098 (prd_typ_cd=PRD_TYPE.02·semi_role_cd=SEMI_ROLE.01·del_yn=N)", captured_at: "live 2026-07-03", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-set-series.md", source_locator: "§1(097 구성원 098 내지)·§3.10 고정가 부모 all-in", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-set}
relations:
  - {rel: in_category, target: category-CAT_000129, note: "떡메모지(main·live)"}
  - {rel: has_plate_size, target: plate-SIZ_000499-gukc4, note: "국4절(316x467) 내지 판형(live PRD_000098)"}
  - {rel: derived_from, target: product-097-tteok-memo, note: "가격이 부모 097 고정가 all-in(PRF_TTEOKME_FIXED)에서 파생·구성원 기여 0(자체 공식 없음·t_prd_product_price_formulas PRD_000098=0행 live 재실측). 082/100 클러스터 동형(083/084/104=derived_from 부모)"}
props:
  prd_typ_cd: "PRD_TYPE.02"
  semi_role_cd: "SEMI_ROLE.01"
  구분: "떡메모지 내지(반제품 구성원·백모조120)"
  parent: "product-097-tteok-memo"
  file_upload_yn: "N"
  editor_yn: "N"
standards: {schema_org: "Product(반제품)", xjdf: "Component(내지)", config_ont: "assembly member"}
answers_cq: ["떡메모지 내지 구성(반제품)"]
tags: ["#셋트", "#반제품", "#떡메모지", "#내지"]
updated: 2026-07-03
---

# 떡메모지 내지 (product-098-tteok-memo-inner)

떡메모지 내지(PRD_000098·백모조120)는 셋트 [[product-097-tteok-memo]]의 **반제품 구성원**
(prd_typ_cd=PRD_TYPE.02·역할 SEMI_ROLE.01 내지). 셋트 관계는 부모의 `has_member`(R13)로 1급 표현
(스키마에 member_of 없음 — 역방향은 빌더 backlinks 파생).

- **가격(★고정가형 흡수)**: 내지 자체 가격공식 없음. 부모 097 고정가형 all-in(PRF_TTEOKME_FIXED)이 구성원 값을
  흡수(기여 0·pack §3.10). 라이브 `t_prd_product_price_formulas`에 PRD_000098 바인딩 **0행**(재실측)이므로
  구성원 `priced_by`를 두지 않고 `derived_from → [[product-097-tteok-memo]]`로 O5 가격사슬 만족
  (083/084/104 동형·위조 앵커 회피). 값 = `evaluate_set_price`(D-18).
- **빈껍데기 구성원(정직)**: 현재 DB에서 098은 자체 사이즈·자재·도수·공정·판형 행이 **0**(자재 백모조120은 부모
  097에 귀속·pack §3.10 부모 all-in verbatim). 카테고리 CAT_000129(떡메모지) 축 노드 미민팅 → needs_axis.

## 구성·연결 전사표 (권위 = 라이브 DB·읽기전용 SELECT)

<!-- transcribed-by: RAILWAY_DB SELECT t_prd_product_sizes/materials/print_options/processes/plate_sizes/categories where prd_cd=PRD_000098 and del_yn=N @ 2026-07-03 -->
| 축 | 현재 DB 행 | 비고 |
|---|---|---|
| size / material / print_option / process | 0행 | 고정가 부모 all-in·구성원 빈껍데기(자재는 부모 097 귀속) |
| plate_size | SIZ_000499(국4절·316x467·output_paper_typ 미기재) | plate 축 노드 미민팅·전사표 권위 |
| category | CAT_000129(떡메모지·main_cat_yn=Y) | 축노드 미민팅·needs_axis |

live-snapshot 20260702_1119과 07-03 재확인 정합(098은 일관되게 빈껍데기). 값 = 부모 evaluate_set_price(D-18).
