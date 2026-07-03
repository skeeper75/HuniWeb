---
id: product-300-monthly-planner-inner
type: product
anchor: t_prd_products/PRD_000300
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000300 (prd_typ_cd=PRD_TYPE.02·semi_role_cd=SEMI_ROLE.01·del_yn=N·use_yn=Y·prd_nm 먼슬리플래너-내지(백모조100)·file_upload=Y·editor=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "live-snapshot/latest/t_prd_product_materials.csv", source_locator: "테이블:t_prd_product_materials 키:(PRD_000300,MAT_000072)·USAGE.01·dflt Y", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "live-snapshot/latest/t_prd_product_sets.csv", source_locator: "테이블:t_prd_product_sets 키:(PRD_000176,PRD_000300)·disp2·min_cnt/max_cnt/incr=28/28/0(내지 28p 고정·양면인쇄)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-stationery-goods.md", source_locator: "§1.1 구성원 slug(300 내지·28p고정)·§3.4 수량규칙·§3.5 자재·§3.12 has_member", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-stn}
relations:
  - {rel: uses_material, target: material-MAT_000072, note: "백색모조지 100g(USAGE.01 dflt·live PRD_000300)·축 노드 재사용(product-041-coupon-axes·Stage C2)"}
  - {rel: derived_from, target: product-176-monthly-planner, note: "가격이 부모 176 고정가 all-in(PRF_STN_MONTHLY)에서 파생·구성원 기여 0(자체 공식 없음·t_prd_product_price_formulas PRD_000300=0행 live 재실측). O5 가격사슬=derived_from 만족(priced_by 위조 금지·095/096 동형)"}
props:
  prd_typ_cd: "PRD_TYPE.02"
  semi_role_cd: "SEMI_ROLE.01"
  role: "먼슬리플래너 내지 구성원(반제품)"
  parent: "product-176-monthly-planner"
  page_rule: "28p 고정 (t_prd_product_sets min_cnt/max_cnt/cnt_incr=28/28/0·db_comment '구성원개수'=페이지수 오등록이나 load-bearing·pack §3.4 [HARD])"
  file_upload_yn: "Y"
  editor_yn: "N"
  구분: "먼슬리플래너-내지(백모조100·28p 양면인쇄)"
standards: {schema_org: "Product(반제품)", xjdf: "Component(내지)", config_ont: "assembly member"}
answers_cq: ["먼슬리플래너 내지 사양·페이지 질의(반제품)"]
tags: ["#셋트구성원", "#내지", "#반제품", "#문구", "#플래너"]
updated: 2026-07-03
---

# 먼슬리플래너-내지 (product-300-monthly-planner-inner)

먼슬리플래너 내지(PRD_000300·백색모조지 100g)는 셋트 [[product-176-monthly-planner]]의 **반제품 구성원**
(prd_typ_cd=PRD_TYPE.02·역할 SEMI_ROLE.01 내지). **28p 고정**(무지 아님·양면인쇄·셋트 note '내지=28p 고정(양면인쇄)').
셋트 관계는 부모의 `has_member`(R13)로 1급 표현.

- **가격(고정가형 흡수)**: 내지 자체 가격공식 없음. 부모 176 고정가형 all-in(PRF_STN_MONTHLY)이 구성원 값을 흡수
  (구성원 기여 0·pack §3.10). 라이브 `t_prd_product_price_formulas` PRD_000300 바인딩 **0행**(재실측)이므로 구성원
  `priced_by`를 두지 않고 `derived_from → [[product-176-monthly-planner]]`로 O5 가격사슬 만족(위조 앵커 회피·284/095 동형). 값 = `evaluate_set_price`(D-18).
- **페이지 수량규칙 [HARD]**: 셋트 min_cnt/max_cnt/cnt_incr=28/28/0(고정 28p)=page_rule. db_comment는 '구성원 개수'이나
  실제 페이지수(오등록이나 load-bearing·pack §3.4·[[set-membrane-1member-taku1-target-model-260703]]). 302/304 무지 내지와 달리
  min/max 설정됨(28p 고정)이라 gap-stn-muji-inner-minmax 대상 아님.
- **빈껍데기 구성원**: 사이즈·도수·공정 자체 행 현재 DB 0(고정가 부모 all-in·셋트 UI가 부모 차원 사용). 자재 1행만 실재.

## 자재 BOM 전사표 (권위 = 라이브 스냅샷 awk 전사)

<!-- transcribed-by: awk t_prd_product_materials+t_mat_materials from live-snapshot/latest (snap_20260702_1119) prd_cd=PRD_000300 @ 2026-07-03 -->
| mat_cd | 자재명 | usage | dflt | 축노드 |
|---|---|---|---|---|
| MAT_000072 | 백색모조지 100g (MAT_TYPE.01) | USAGE.01 | Y | O(uses_material 배선·Stage C2) |

내지는 종이류라 판형 대상이나 내지 자체 plate 행 현재 DB 0(부모 파일사양이 대행·pack §3.8). 사이즈·도수·공정 0행.
자재 MAT_000072(백색모조지 100g)는 공유 축 노드 재사용(product-041)→`uses_material` 배선(Stage C2·이 BOM 표 정합).
</content>
