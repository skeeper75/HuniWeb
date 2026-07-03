---
id: product-304-spring-notebook-inner
type: product
anchor: t_prd_products/PRD_000304
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000304 (prd_typ_cd=PRD_TYPE.02·semi_role_cd=SEMI_ROLE.01·del_yn=N·use_yn=Y·prd_nm 스프링수첩-내지(무지)·file_upload=N·editor=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "live-snapshot/latest/t_prd_product_materials.csv", source_locator: "테이블:t_prd_product_materials 키:(PRD_000304,MAT_000261 USAGE.01 dflt Y),(PRD_000304,MAT_000072 USAGE.07 dflt Y)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "live-snapshot/latest/t_prd_product_sets.csv", source_locator: "테이블:t_prd_product_sets 키:(PRD_000178,PRD_000304)·disp2·min_cnt/max_cnt/incr 공란(무지·min/max 미설정)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-stationery-goods.md", source_locator: "§1.1 구성원 slug(304 스프링수첩 무지내지)·§3.4 무지 내지 min/max 미설정·§3.5 자재", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-stn}
relations:
  - {rel: uses_material, target: material-MAT_000261, note: "무지내지(USAGE.01 dflt·live PRD_000304)"}
  - {rel: uses_material, target: material-MAT_000072, note: "백색모조지 100g(USAGE.07 dflt·live PRD_000304)·축 노드 재사용(product-041-coupon-axes·Stage C2)"}
  - {rel: derived_from, target: product-178-spring-notebook, note: "가격이 부모 178 고정가 all-in(PRF_STN_SPRINGNOTEBK)에서 파생·구성원 기여 0(자체 공식 없음·t_prd_product_price_formulas PRD_000304=0행 live 재실측). O5 가격사슬=derived_from 만족(priced_by 위조 금지·095/096 동형)"}
  - {rel: references, target: gap-stn-muji-inner-minmax, note: "무지 내지 min/max 미설정(추후 커스텀인쇄 확장 예정)"}
props:
  prd_typ_cd: "PRD_TYPE.02"
  semi_role_cd: "SEMI_ROLE.01"
  role: "스프링수첩 내지 구성원(반제품·무지)"
  parent: "product-178-spring-notebook"
  page_rule: "미설정 (t_prd_product_sets min_cnt/max_cnt/cnt_incr 공란·무지 고정 본문·추후 커스텀인쇄 확장→gap-stn-muji-inner-minmax)"
  file_upload_yn: "N"
  editor_yn: "N"
  구분: "스프링수첩-내지(무지·현재 인쇄없음)"
standards: {schema_org: "Product(반제품)", xjdf: "Component(내지)", config_ont: "assembly member"}
answers_cq: ["스프링수첩 무지 내지 구성(반제품)"]
tags: ["#셋트구성원", "#내지", "#무지", "#반제품", "#문구", "#노트"]
updated: 2026-07-03
---

# 스프링수첩-내지 (product-304-spring-notebook-inner)

스프링수첩 내지(PRD_000304·무지)는 셋트 [[product-178-spring-notebook]]의 **반제품 구성원**(prd_typ_cd=PRD_TYPE.02·
역할 SEMI_ROLE.01 내지). **무지**(현재 인쇄없음·추후 커스텀인쇄 확장 예정). 302 스프링노트 내지와 동형. 셋트 관계는
부모의 `has_member`(R13)로 1급 표현.

- **가격(고정가형 흡수)**: 내지 자체 가격공식 없음. 부모 178 고정가형 all-in(PRF_STN_SPRINGNOTEBK)이 구성원 값을 흡수
  (구성원 기여 0·pack §3.10). 라이브 `t_prd_product_price_formulas` PRD_000304 바인딩 **0행**(재실측)이므로 구성원
  `priced_by`를 두지 않고 `derived_from → [[product-178-spring-notebook]]`로 O5 가격사슬 만족(위조 앵커 회피·284/095 동형). 값 = `evaluate_set_price`(D-18).
- **★무지 내지 min/max 미설정(pack §3.4·gap)**: 셋트 min_cnt/max_cnt/cnt_incr 공란(무지 고정 본문)·추후 커스텀인쇄
  확장 예정 → [[rule/gaps#gap-stn-muji-inner-minmax]]. 300 먼슬리플래너 내지(28p 고정)와 대비.
- **빈껍데기 구성원**: 사이즈·도수·공정 자체 행 현재 DB 0(고정가 부모 all-in·셋트 UI가 부모 차원 사용). 자재 2행 실재.

## 자재 BOM 전사표 (권위 = 라이브 스냅샷 awk 전사)

<!-- transcribed-by: awk t_prd_product_materials+t_mat_materials from live-snapshot/latest (snap_20260702_1119) prd_cd=PRD_000304 @ 2026-07-03 -->
| mat_cd | 자재명 | usage | dflt | 축노드 |
|---|---|---|---|---|
| MAT_000261 | 무지내지 (MAT_TYPE.21) | USAGE.01 | Y | O(uses_material) |
| MAT_000072 | 백색모조지 100g (MAT_TYPE.01) | USAGE.07 | Y | O(uses_material 배선·Stage C2) |

내지는 종이류라 판형 대상이나 내지 자체 plate 행 현재 DB 0(부모 파일사양이 대행·pack §3.8). 사이즈·도수·공정 0행.
MAT_000072(백색모조지 100g·USAGE.07)는 공유 축 노드 재사용(product-041)→`uses_material` 배선(Stage C2·이 BOM 표 정합).
</content>
