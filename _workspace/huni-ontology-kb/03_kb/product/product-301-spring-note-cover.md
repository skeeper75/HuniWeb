---
id: product-301-spring-note-cover
type: product
anchor: t_prd_products/PRD_000301
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000301 (prd_typ_cd=PRD_TYPE.02·semi_role_cd=SEMI_ROLE.02·del_yn=N·use_yn=Y·prd_nm 스프링노트-표지(아트250+무광코팅)·file_upload=N·editor=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "live-snapshot/latest/t_prd_product_materials.csv", source_locator: "테이블:t_prd_product_materials 키:(PRD_000301,MAT_000250)·USAGE.02·dflt Y", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-stationery-goods.md", source_locator: "§1.1 구성원 slug(301 스프링노트 표지)·§3.5 자재·§3.12 has_member", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-stn}
relations:
  - {rel: uses_material, target: material-MAT_000250, note: "아트250+무광코팅(USAGE.02 표지종이·live PRD_000301)"}
  - {rel: derived_from, target: product-177-spring-note, note: "가격이 부모 177 고정가 all-in(PRF_STN_SPRINGNOTE)에서 파생·구성원 기여 0(자체 공식 없음·t_prd_product_price_formulas PRD_000301=0행 live 재실측). O5 가격사슬=derived_from 만족(priced_by 위조 금지·095/096 동형)"}
props:
  prd_typ_cd: "PRD_TYPE.02"
  semi_role_cd: "SEMI_ROLE.02"
  role: "스프링노트 표지 구성원(반제품)"
  parent: "product-177-spring-note"
  file_upload_yn: "N"
  editor_yn: "N"
  구분: "스프링노트-표지(아트250+무광코팅)"
standards: {schema_org: "Product(반제품)", xjdf: "Component(표지)", config_ont: "assembly member"}
answers_cq: ["스프링노트 표지 구성(반제품)"]
tags: ["#셋트구성원", "#표지", "#반제품", "#문구", "#노트"]
updated: 2026-07-03
---

# 스프링노트-표지 (product-301-spring-note-cover)

스프링노트 표지(PRD_000301·아트250+무광코팅)는 셋트 [[product-177-spring-note]]의 **반제품 구성원**
(prd_typ_cd=PRD_TYPE.02·역할 SEMI_ROLE.02 표지·1권고정). 셋트 관계는 부모의 `has_member`(R13)로 1급 표현.

- **가격(고정가형 흡수)**: 표지 자체 가격공식 없음. 부모 177 고정가형 all-in(PRF_STN_SPRINGNOTE)이 구성원 값을 흡수
  (구성원 기여 0·pack §3.10). 라이브 `t_prd_product_price_formulas` PRD_000301 바인딩 **0행**(재실측)이므로 구성원
  `priced_by`를 두지 않고 `derived_from → [[product-177-spring-note]]`로 O5 가격사슬 만족(위조 앵커 회피·095/096 동형). 값 = `evaluate_set_price`(D-18).
- **빈껍데기 구성원**: 사이즈·도수·공정 자체 행 현재 DB 0(고정가 부모 all-in·셋트 UI가 부모 차원 사용). 자재 1행만 실재.

## 자재 BOM 전사표 (권위 = 라이브 스냅샷 awk 전사)

<!-- transcribed-by: awk t_prd_product_materials+t_mat_materials from live-snapshot/latest (snap_20260702_1119) prd_cd=PRD_000301 @ 2026-07-03 -->
| mat_cd | 자재명 | usage | dflt | 축노드 |
|---|---|---|---|---|
| MAT_000250 | 아트250+무광코팅 (MAT_TYPE.01) | USAGE.02 | Y | O(uses_material) |

표지는 종이류라 판형 대상이나 표지 자체 plate 행 현재 DB 0(부모 파일사양이 대행·pack §3.8). 사이즈·도수·공정 0행.
</content>
