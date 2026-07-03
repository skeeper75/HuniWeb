---
id: product-308-jungcheol-note-inner
type: product
anchor: t_prd_products/PRD_000308
badge: verified
sources:
  - {source_file: "RAILWAY_DB live (railway·읽기전용 SELECT)", source_locator: "테이블:t_prd_products 키:PRD_000308 (prd_typ_cd=PRD_TYPE.02·semi_role_cd=SEMI_ROLE.01·del_yn=N·use_yn=Y·file_upload_yn=N·editor_yn=N)", captured_at: "live 2026-07-03", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "RAILWAY_DB live (railway·읽기전용 SELECT)", source_locator: "테이블:t_prd_product_materials 키:(PRD_000308,MAT_000261,USAGE.01 dflt Y)·(PRD_000308,MAT_000072,USAGE.07 dflt Y disp2)·t_prd_product_sets(PRD_000181,PRD_000308) disp2 min/max/incr 미설정·t_prd_product_price_formulas PRD_000308=0행", captured_at: "live 2026-07-03", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-stationery-goods.md", source_locator: "§1.1(181 구성원 308 내지무지·slug product-308-jungcheol-note-inner)·§3.4 무지 내지 min/max GAP·§3.5 자재", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-stn}
relations:
  - {rel: uses_material, target: material-MAT_000261, note: "무지내지(USAGE.01 내지종이·MAT_TYPE.21·dflt Y·live PRD_000308)"}
  - {rel: uses_material, target: material-MAT_000072, note: "백색모조지 100g(USAGE.07 공통·MAT_TYPE.01·dflt Y·disp2·live PRD_000308)"}
  - {rel: derived_from, target: product-181-jungcheol-note, note: "가격이 부모 181 고정가 all-in(PRF_STN_JUNGCHEOL)에서 파생·구성원 기여 0(자체 공식 없음·t_prd_product_price_formulas PRD_000308=0행 live 재실측). 내지 member(095 클러스터 동형)"}
  - {rel: references, target: gap-stn-muji-inner-minmax, note: "무지 내지(308) 페이지 수량규칙 min/max/incr 미설정·추후 커스텀인쇄 확장 예정"}
props:
  prd_typ_cd: "PRD_TYPE.02"
  semi_role_cd: "SEMI_ROLE.01"
  구분: "중철노트 내지(반제품 구성원·무지·중철제본)"
  parent: "product-181-jungcheol-note"
  member_qty: "min/max/incr 미설정(GAP·무지·gap-stn-muji-inner-minmax)"
  file_upload_yn: "N"
  editor_yn: "N"
standards: {schema_org: "Product(반제품)", xjdf: "Component(내지)", config_ont: "assembly member"}
answers_cq: ["중철노트 내지 구성(반제품·무지)"]
tags: ["#셋트", "#반제품", "#중철노트", "#내지", "#무지"]
updated: 2026-07-03
---

# 중철노트 내지 (product-308-jungcheol-note-inner)

중철노트 내지(PRD_000308·무지)는 셋트 [[product-181-jungcheol-note]]의 **반제품 구성원**
(prd_typ_cd=PRD_TYPE.02·역할 SEMI_ROLE.01 내지). 현재 **무지**(인쇄 없음·본문 고정)이며 추후 커스텀인쇄
(페이지 가변) 확장 예정(sets note). 셋트 관계는 부모의 `has_member`(R13)로 1급 표현되고, 이 노드는 부모를
[[product-181-jungcheol-note]]로 참조한다.

- **가격(★고정가형 흡수)**: 내지 자체 가격공식 없음. 부모 181이 **고정가형 all-in**(PRF_STN_JUNGCHEOL)으로
  구성원 값을 흡수하므로 **구성원 기여 = 0**(pack §3.10). 라이브 `t_prd_product_price_formulas`에 PRD_000308
  바인딩 **0행**(재실측)이므로 `derived_from → [[product-181-jungcheol-note]]`으로 O5 가격사슬을 만족한다(095
  내지 클러스터 동형·라이브 미실재 앵커 위조 회피). 값 = `evaluate_set_price`(D-18).
- **★무지 내지 min/max GAP(정직 표기)**: 이 무지 내지 구성원의 페이지 수량규칙(sets min/max/incr)이
  **미설정**(sets 행에 값 없음·live 재실측)이다. 302/304/306과 동류 → [[rule/gaps.md#gap-stn-muji-inner-minmax]]
  로 라우팅(무지=고정 본문·추후 커스텀인쇄 확장 시 page_rule 설정·페이지 단가 무손상 [HARD]).
- **자재**: 무지내지(MAT_000261·USAGE.01·MAT_TYPE.21·dflt Y) + 백색모조지 100g(MAT_000072·USAGE.07 공통).
  종이류이나 내지 member에 판형 행은 현재 DB 0(판형은 부모 181 표지파일사양에 실재·member empty-shell).
  중철제본(부모 181 PROC_000018)의 내지.

## 구성·연결 전사표 (권위 = 라이브 DB·읽기전용 SELECT)

<!-- transcribed-by: RAILWAY_DB SELECT t_prd_product_materials/sizes/plate_sizes/sets where prd_cd=PRD_000308 and del_yn=N @ 2026-07-03 -->
| 축 | 코드 | 라벨/usage | 축노드 존재 |
|---|---|---|---|
| material | MAT_000261 | 무지내지 (USAGE.01 내지종이·MAT_TYPE.21) | O(uses_material 배선) |
| material | MAT_000072 | 백색모조지 100g (USAGE.07 공통) | O(uses_material 배선·product-041 소유 노드 재사용) |
| size / plate / print / process | — | 0행(구성원 빈껍데기·부모 all-in) | — |
| member min/max/incr | — | 미설정(GAP·gap-stn-muji-inner-minmax) | — |

내지는 종이류(무지내지)이나 판형·사이즈·도수·공정 자체 행은 현재 DB 0(고정가 부모 all-in·
[[product-181-jungcheol-note]] 전사표 참조). 무지 내지 수량규칙 미설정은 정직 표기(GAP·커스텀인쇄 확장 대기).
