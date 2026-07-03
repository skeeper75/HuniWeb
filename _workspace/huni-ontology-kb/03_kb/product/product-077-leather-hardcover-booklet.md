---
id: product-077-leather-hardcover-booklet
type: product
anchor: t_prd_products/PRD_000077
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000077 (prd_typ_cd=PRD_TYPE.01·del_yn=N·use_yn=Y·min1/max1000/incr1·QTY_UNIT.03)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "live-snapshot/latest/t_prd_product_sets.csv", source_locator: "테이블:t_prd_product_sets 키:prd_cd=PRD_000077 (활성 sub=078/285/079·080/081 은퇴)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-set-product/06_load/leather-hardcover-membrane-077-post-verify.md", source_locator: "§1 면지 통합 재설계 활성 구성원(078/285/079·080/081 del_yn=Y)·§2 골든 실호출", captured_at: "2026-07-03", badge: verified, src_id: SR-23-postverify}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-set-series.md", source_locator: "§1 인벤토리 077(072 COVERBIND 동형)·§4 latest-wins", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-set}
relations:
  - {rel: in_category, target: category-CAT_000105, note: "하드커버책자(super·live main_cat_yn=N)"}
  - {rel: in_category, target: category-CAT_000106, note: "레더하드커버책자(main·live)"}
  - {rel: has_process, target: process-PROC_000023, note: "하드커버무선제본(셋트 form 공정·live PRD_000077)"}
  - {rel: has_process, target: process-PROC_000076, note: "수축포장(옵션·live PRD_000077)"}
  - {rel: has_member, target: product-078-leather-hardcover-booklet-cover, note: "표지(SEMI_ROLE.02·disp_seq1·1권고정·레더(화이트) COVERBIND)"}
  - {rel: has_member, target: product-285-leather-hardcover-booklet-inner, qualifier: {semi_role: "SEMI_ROLE.01", disp_seq: 2, min_cnt: 24, max_cnt: 300, cnt_incr: 2}, note: "내지(별도설정종이·페이지 24~300/+2=page_rule·284 동형)"}
  - {rel: has_member, target: product-079-leather-hardcover-booklet-membrane, note: "면지(SEMI_ROLE.03·disp_seq3·색 3택1 화/블/그·무가격·기여0)"}
  - {rel: priced_by, target: formula-PRF_HC_MUSEON_SET, note: "셋트 부모공식(072 동형 COVERBIND 재사용·use_dims=[min_qty]). evaluate_set_price(pricing.py:718)"}
props:
  prd_typ_cd: "PRD_TYPE.01"
  role: "셋트 완제품(t_prd_product_sets 부모)"
  archetype: "원자합산형(셋트조합·COVERBIND·072 동형)"
  min_qty: 1
  max_qty: 1000
  qty_incr: 1
  qty_unit_typ_cd: "QTY_UNIT.03"
  file_upload_yn: "Y"
  editor_yn: "N"
  구분: "레더 하드커버책자(셋트 완제품·레더 표지+내지+면지 조립)"
standards: {schema_org: "Product", xjdf: "Product(레더 하드커버책자 assembly)", config_ont: "assembly / component type"}
answers_cq: ["레더 하드커버책자 구성·가격 질의(셋트)", "레더 표지 하드커버 조립 상품"]
tags: ["#셋트", "#책자", "#하드커버", "#레더", "#원자합산형", "#COVERBIND"]
updated: 2026-07-03
---

# 레더 하드커버책자 (product-077-leather-hardcover-booklet)

레더 하드커버책자(PRD_000077)는 **셋트 완제품**(prd_typ_cd=PRD_TYPE.01·`t_prd_product_sets` 부모).
**072 하드커버책자와 COVERBIND 동형** — 표지 자재가 전용지(072) 대신 **레더(화이트)**인 점만 다르다.
표지(078)+내지(285)+면지(079) 조립이며(전용 카테고리 CAT_000106 레더하드커버책자 = 축 노드 미민팅 →
needs_axis·상위 CAT_000105도 잔여 연결), 가격은 **`evaluate_set_price`**(구성원 합산 + 부모공식
[[formula/set-formulas#formula-PRF_HC_MUSEON_SET]] + 할인)로 계산한다([[rule/rules#RULE_price_value_boundary]]).

- **정체·구조**: 팩 §1(FRESH) + live `t_prd_product_sets` + 077-post-verify §1(면지 통합 재설계·072 per-set 전파).
- **★면지 통합 재설계(2026-07-03·latest-wins)**: 면지 3빈멤버(079 화이트·080 블랙·081 그레이) → **면지 1멤버(079) + 색 내부 택1**.
  080/081 `del_yn=Y` 은퇴(노드 미생성). 면지 자재는 부모 077 → 면지 멤버 079로 이관·부모 면지자재/OPT_065 **은퇴(활성 0)**
  (077-post-verify §1). live-snapshot 20260702_1119의 077 면지 3멤버·부모 구조는 **STALE**(팩 §2 T-3) — post-verify 정본.
- **가격 경계(D-18)**: has_member·priced_by·아키타입 선언까지. 값=엔진.
- **골든 무손상**: 077 apply 전=후 완전 일치(077-post-verify §2 실증)·072와 동일 골든.
- **레더 델타 미반영(C트랙)**: COVERBIND use_dims=[min_qty]라 표지 자재(레더 vs 전용지) 델타가 가격에 반영 안 됨
  (072와 골든 동일한 근본 이유) → 엔진 use_dims 확장 C트랙 [[product-072-hardcover-booklet-nodes#gap-set-leather-coverbind-delta]].

## 셋트 골든 (권위 = simulate-set 실호출)

<!-- transcribed-by: pack-set-series.md §1 <- 06_load/leather-hardcover-membrane-077-post-verify.md §2 (POST /admin/price-viewer/PRD_000077/simulate-set/ apply 전=후 실호출). 손전사 아님. -->
| 부수(copies) | final_price | ok | errors(제외) |
|---|---|---|---|
| 1 | 34,100 | true | [] |
| 10 | 159,100 | true | [] |
| 100 | 796,900 | true | [] |

PRICE≠0·제외 0·warnings 0·이중합산 0(078 표지·285 내지·079 면지 전부 set_eval 비배선·base_total=set_eval 단독).
</content>
