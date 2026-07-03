---
id: product-305-memo-pad-cover
type: product
anchor: t_prd_products/PRD_000305
badge: verified
sources:
  - {source_file: "RAILWAY_DB live (railway·읽기전용 SELECT)", source_locator: "테이블:t_prd_products 키:PRD_000305 (prd_typ_cd=PRD_TYPE.02·semi_role_cd=SEMI_ROLE.02·del_yn=N·use_yn=Y·file_upload_yn=N·editor_yn=N)", captured_at: "live 2026-07-03", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "RAILWAY_DB live (railway·읽기전용 SELECT)", source_locator: "테이블:t_prd_product_materials 키:(PRD_000305,MAT_000250,USAGE.02) dflt_yn=Y·t_prd_product_sets(PRD_000179,PRD_000305) 1권고정 1/1/1·t_prd_product_price_formulas PRD_000305=0행", captured_at: "live 2026-07-03", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-stationery-goods.md", source_locator: "§1.1(179 구성원 305 표지·slug product-305-memo-pad-cover)·§3.5 자재·§3.12 has_member", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-stn}
relations:
  - {rel: uses_material, target: material-MAT_000250, note: "아트250+무광코팅(USAGE.02 표지종이·MAT_TYPE.01·dflt Y·live PRD_000305)"}
  - {rel: derived_from, target: product-179-memo-pad, note: "가격이 부모 179 고정가 all-in(PRF_STN_MEMOPAD)에서 파생·구성원 기여 0(자체 공식 없음·t_prd_product_price_formulas PRD_000305=0행 live 재실측). 표지 member(095/096 클러스터 동형)"}
props:
  prd_typ_cd: "PRD_TYPE.02"
  semi_role_cd: "SEMI_ROLE.02"
  구분: "메모패드 표지(반제품 구성원)"
  parent: "product-179-memo-pad"
  member_qty: "1권고정(sets min/max/incr 1/1/1)"
  file_upload_yn: "N"
  editor_yn: "N"
standards: {schema_org: "Product(반제품)", xjdf: "Component(표지)", config_ont: "assembly member"}
answers_cq: ["메모패드 표지 구성(반제품)"]
tags: ["#셋트", "#반제품", "#메모패드", "#표지"]
updated: 2026-07-03
---

# 메모패드 표지 (product-305-memo-pad-cover)

메모패드 표지(PRD_000305·아트250+무광코팅)는 셋트 [[product-179-memo-pad]]의 **반제품 구성원**
(prd_typ_cd=PRD_TYPE.02·역할 SEMI_ROLE.02 표지·1권고정). 셋트 관계는 부모의 `has_member`(R13)로 1급
표현되며(스키마 19관계에 member_of 없음 — 역방향은 빌더 backlinks 파생), 이 노드는 부모를
[[product-179-memo-pad]]로 참조한다.

- **가격(★고정가형 흡수)**: 표지 자체 가격공식 없음. 부모 179가 **고정가형 all-in**(PRF_STN_MEMOPAD)으로
  구성원 값을 흡수하므로 **구성원 기여 = 0**(pack §3.10). 라이브 `t_prd_product_price_formulas`에 PRD_000305
  바인딩 **0행**(재실측)이므로 구성원 자체 `priced_by`는 두지 않고 `derived_from → [[product-179-memo-pad]]`
  으로 O5 가격사슬을 만족한다(095/096 클러스터 동형·라이브 미실재 앵커 위조 회피). 값 = `evaluate_set_price`(D-18).
- **자재**: 아트250+무광코팅(MAT_000250·USAGE.02 표지종이·MAT_TYPE.01·dflt Y). 종이류이나 표지 member에
  판형(plate_size) 행은 현재 DB 0(판형은 부모 179 표지파일사양에 실재·member는 empty-shell). 사이즈·도수·공정
  자체 행도 현재 DB 0(고정가 부모 all-in·구성원 빈껍데기).

## 구성·연결 전사표 (권위 = 라이브 DB·읽기전용 SELECT)

<!-- transcribed-by: RAILWAY_DB SELECT t_prd_product_materials/sizes/plate_sizes/processes where prd_cd=PRD_000305 and del_yn=N @ 2026-07-03 -->
| 축 | 코드 | 라벨/usage | 축노드 존재 |
|---|---|---|---|
| material | MAT_000250 | 아트250+무광코팅 (USAGE.02 표지종이) | O(uses_material 배선) |
| size / plate / print / process | — | 0행(구성원 빈껍데기·부모 all-in) | — |

표지는 부모 179 셋트의 표지 반제품. 자재만 실재하고 사이즈·판형·도수·공정 행은 현재 DB 0(고정가 부모
all-in·[[product-179-memo-pad]] 전사표 참조). member 수량규칙 = 1권고정(sets min/max/incr 1/1/-).
