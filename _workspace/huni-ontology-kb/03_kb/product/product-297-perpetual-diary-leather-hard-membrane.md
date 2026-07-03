---
id: product-297-perpetual-diary-leather-hard-membrane
type: product
anchor: t_prd_products/PRD_000297
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000297 (prd_typ_cd=PRD_TYPE.02·semi_role_cd=SEMI_ROLE.03·del_yn=N·prd_nm '만년다이어리(레더하드커버)-면지')", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "live-snapshot/latest/t_prd_product_materials.csv", source_locator: "테이블:t_prd_product_materials 키:prd_cd=PRD_000297 → 0행(면지 자재 미등록·empty-shell)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-stationery-goods.md", source_locator: "§1.1 구성원 slug(297 면지·SEMI_ROLE.03·무가격)·§3.5 면지 empty-shell·§3.10 구성원 derived_from 부모", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-stn}
relations:
  - {rel: in_category, target: category-CAT_000321, note: "플래너(구성원 카테고리·부모 174 상속)·축 노드 미민팅(needs_axis)"}
  - {rel: derived_from, target: product-174-perpetual-diary-leather-hard, note: "면지=무가격(제본비 포함·기여 0·자체 공식 없음·t_prd_product_price_formulas PRD_000297=0행). 가격이 부모 174 셋트에서 파생(기여 0). 구성원 derived_from 타깃=부모 상품 노드 통일(074 면지 동형·C-5)"}
props:
  prd_typ_cd: "PRD_TYPE.02"
  semi_role_cd: "SEMI_ROLE.03"
  role: "만년다이어리(레더하드커버) 면지 구성원(반제품·무가격)"
  set_contribution: "NONE(무가격·제본비 포함)"
  parent: "product-174-perpetual-diary-leather-hard"
  file_upload_yn: "N"
  editor_yn: "N"
  구분: "만년다이어리(레더하드커버)-면지(기본 1종·자재 0행)"
standards: {schema_org: "Product(반제품)", xjdf: "Product(면지 component)", config_ont: "assembly member"}
answers_cq: ["만년다이어리(레더하드커버) 면지 구성 질의"]
tags: ["#셋트구성원", "#면지", "#반제품", "#문구", "#만년다이어리", "#레더", "#무가격"]
updated: 2026-07-03
---

# 만년다이어리(레더하드커버)-면지 (product-297-perpetual-diary-leather-hard-membrane)

만년다이어리(레더하드커버) 면지 구성원(PRD_000297·반제품·SEMI_ROLE.03). 셋트
[[product-174-perpetual-diary-leather-hard]]의 disp_seq2 멤버(기본 1종). 셋트 관계는 부모의 `has_member`
(R13)로 1급 표현되며, 이 노드는 부모를 [[product-174-perpetual-diary-leather-hard]]로 참조한다.

- **★면지 = 무가격**(제본비 포함·기여 0). 자체 가격공식 없음·라이브 `t_prd_product_price_formulas`에
  PRD_000297 바인딩 **0행** → `derived_from → [[product-174-perpetual-diary-leather-hard]]`(부모 셋트 파생·
  기여 0)로 O5 가격사슬을 만족한다(074 하드커버책자 면지·295 동형). 값=`evaluate_set_price`(D-18).
- **★자재 0행(empty-shell)**: 라이브 `t_prd_product_materials` **0행**(면지 자재 미등록·사이즈/인쇄/판형도
  0행). 정직 표기(날조·이식 금지). 면지 색 옵션그룹도 미등록 → 자재/옵션 충전은 dbmap·§7 위임.

## 자재 BOM (권위 = 라이브 스냅샷 awk 전사)

<!-- transcribed-by: awk t_prd_product_materials from live-snapshot/latest (snap_20260702_1119) prd_cd=PRD_000297 del_yn=N @ 2026-07-03 -->
| mat_cd | 자재명 | usage | dflt | 축노드 |
|---|---|---|---|---|
| (0행) | — | — | — | 면지 자재 미등록(empty-shell·무가격·정직 표기) |
</content>
