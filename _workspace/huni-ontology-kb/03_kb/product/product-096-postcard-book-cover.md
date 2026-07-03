---
id: product-096-postcard-book-cover
type: product
anchor: t_prd_products/PRD_000096
badge: verified
sources:
  - {source_file: "RAILWAY_DB live (railway·읽기전용 SELECT)", source_locator: "테이블:t_prd_products 키:PRD_000096 (prd_typ_cd=PRD_TYPE.02·semi_role_cd=SEMI_ROLE.02·del_yn=N)", captured_at: "live 2026-07-03", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-set-series.md", source_locator: "§1(094 구성원 096 표지)·§3.5 자재 멤버 이관", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-set}
relations:
  - {rel: in_category, target: category-CAT_000026, note: "엽서북(구성원 카테고리·main·live)"}
  - {rel: has_plate_size, target: plate-SIZ_000499-gukc4, note: "국4절(316x467) 표지 판형(live PRD_000096)"}
  - {rel: uses_material, target: material-MAT_000092, note: "스노우지 300g(USAGE.02 표지종이·현재 DB 멤버 귀속)"}
  - {rel: derived_from, target: product-094-postcard-book, note: "가격이 부모 094 고정가 all-in(PRF_PCB_FIXED)에서 파생·구성원 기여 0(자체 공식 없음·t_prd_product_price_formulas PRD_000096=0행 live 재실측). 082/100 클러스터 동형(083/084/104=derived_from 부모)"}
props:
  prd_typ_cd: "PRD_TYPE.02"
  semi_role_cd: "SEMI_ROLE.02"
  구분: "엽서북 표지(반제품 구성원)"
  parent: "product-094-postcard-book"
  file_upload_yn: "N"
  editor_yn: "N"
standards: {schema_org: "Product(반제품)", xjdf: "Component(표지)", config_ont: "assembly member"}
answers_cq: ["엽서북 표지 구성(반제품)"]
tags: ["#셋트", "#반제품", "#엽서북", "#표지"]
updated: 2026-07-03
---

# 엽서북 표지 (product-096-postcard-book-cover)

엽서북 표지(PRD_000096·스노우300)는 셋트 [[product-094-postcard-book]]의 **반제품 구성원**
(prd_typ_cd=PRD_TYPE.02·역할 SEMI_ROLE.02 표지·1권고정). 셋트 관계는 부모의 `has_member`(R13)로 1급 표현.

- **가격(★고정가형 흡수)**: 표지 자체 가격공식 없음. 부모 094 고정가형 all-in(PRF_PCB_FIXED)이 구성원 값을
  흡수(구성원 기여 0·pack §3.10). 라이브 `t_prd_product_price_formulas`에 PRD_000096 바인딩 **0행**(재실측)이므로
  구성원 `priced_by`를 두지 않고 `derived_from → [[product-094-postcard-book]]`로 O5 가격사슬 만족
  (083/084/104 동형·위조 앵커 회피). 값 = `evaluate_set_price`(D-18).
- **끊긴 축(정직)**: 카테고리 CAT_000026(엽서북)·판형 SIZ_000499(국4절 표지) 축 노드 미민팅 → needs_axis.

## 구성·연결 전사표 (권위 = 라이브 DB·읽기전용 SELECT)

<!-- transcribed-by: RAILWAY_DB SELECT t_prd_product_materials/plate_sizes/categories where prd_cd=PRD_000096 and del_yn=N @ 2026-07-03 -->
| 축 | 코드 | 라벨/usage | 축노드 존재 |
|---|---|---|---|
| material | MAT_000092 | 스노우지 300g (USAGE.02 표지종이) | O(uses_material 배선) |
| plate_size | SIZ_000499 | 국4절(316x467·output_paper_typ 미기재) | ✗(미민팅·전사표 권위) |
| category | CAT_000026 | 엽서북(main_cat_yn=Y) | ✗(미민팅·needs_axis) |

표지는 종이류라 판형 대상(종이류만·pack §3.8). 사이즈·도수·공정 자체 행 현재 DB 0(고정가 부모 all-in·구성원
빈껍데기). live-snapshot 20260702_1119은 자재 멤버 이관 前 STALE(pack §4·T-3) — 위는 07-03 재확인값.
