---
id: product-072-hardcover-booklet
type: product
anchor: t_prd_products/PRD_000072
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000072 (prd_typ_cd=PRD_TYPE.01·del_yn=N·use_yn=Y·min1/max1000/incr1·QTY_UNIT.03)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "live-snapshot/latest/t_prd_product_sets.csv", source_locator: "테이블:t_prd_product_sets 키:prd_cd=PRD_000072 (활성 sub=073/284/074·075/076 은퇴)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-set-product/06_load/leather-hardcover-membrane-072-post-verify.md", source_locator: "§1 면지 통합 재설계 활성 구성원(073/284/074·075/076 del_yn=Y)·§2 골든 실호출", captured_at: "2026-07-03", badge: verified, src_id: SR-23-postverify}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-set-series.md", source_locator: "§1 인벤토리 072·§3.10/§3.12 셋트 구성/가격·§4 latest-wins", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-set}
relations:
  - {rel: in_category, target: category-CAT_000105, note: "하드커버책자(main·live)"}
  - {rel: has_process, target: process-PROC_000023, note: "하드커버무선제본(셋트 form 공정·live PRD_000072)"}
  - {rel: has_process, target: process-PROC_000076, note: "수축포장(옵션·live PRD_000072)"}
  - {rel: has_member, target: product-073-hardcover-booklet-cover, note: "표지(SEMI_ROLE.02·disp_seq1·1권고정·전용지 COVERBIND)"}
  - {rel: has_member, target: product-284-hardcover-booklet-inner, qualifier: {semi_role: "SEMI_ROLE.01", disp_seq: 2, min_cnt: 24, max_cnt: 300, cnt_incr: 2}, note: "내지(별도설정종이·페이지 24~300/+2=page_rule·db_comment '구성원개수'는 실제 페이지수 오등록이나 load-bearing·pack §3.4)"}
  - {rel: has_member, target: product-074-hardcover-booklet-membrane, note: "면지(SEMI_ROLE.03·disp_seq3·색 3택1 화/블/그·무가격·기여0)"}
  - {rel: priced_by, target: formula-PRF_HC_MUSEON_SET, note: "셋트 부모공식(COVERBIND 통가·use_dims=[min_qty]). evaluate_set_price=구성원 합산+이 부모공식+할인(pricing.py:718)"}
props:
  prd_typ_cd: "PRD_TYPE.01"
  role: "셋트 완제품(t_prd_product_sets 부모)"
  archetype: "원자합산형(셋트조합·COVERBIND)"
  min_qty: 1
  max_qty: 1000
  qty_incr: 1
  qty_unit_typ_cd: "QTY_UNIT.03"
  file_upload_yn: "Y"
  editor_yn: "N"
  구분: "하드커버책자(셋트 완제품·표지+내지+면지 조립)"
standards: {schema_org: "Product", xjdf: "Product(하드커버책자 assembly)", config_ont: "assembly / component type"}
answers_cq: ["하드커버책자 구성·가격 질의(셋트)", "표지/내지/면지 조립 상품"]
tags: ["#셋트", "#책자", "#하드커버", "#원자합산형", "#COVERBIND"]
updated: 2026-07-03
---

# 하드커버책자 (product-072-hardcover-booklet)

하드커버책자(PRD_000072)는 **셋트 완제품**(prd_typ_cd=PRD_TYPE.01·`t_prd_product_sets` 부모 등록 =
셋트 완제품 유일 기준·CLAUDE.md §1 [HARD]). **표지(073)+내지(284)+면지(074)** 반제품 조립이다
([[axis/categories]] 하드커버책자 CAT_000105 = 축 노드 미민팅 → needs_axis). 가격은 단일
`evaluate_price`가 아니라 **`evaluate_set_price`**(구성원별 evaluate_price 합산 + 셋트 부모공식
[[formula/set-formulas#formula-PRF_HC_MUSEON_SET]] + 할인·pricing.py:718)로 계산한다(값 계산=엔진
권위·[[rule/rules#RULE_price_value_boundary]]).

- **정체·구조**: 팩 §3.1/§3.12(FRESH) + live `t_prd_product_sets` 실측 + 072-post-verify §1(면지 통합 재설계 후 활성 구성원).
- **★면지 통합 재설계(2026-07-03·latest-wins)**: 재설계 전 면지는 3개 빈멤버(074 화이트·075 블랙·076 그레이)였으나,
  **면지 1멤버(074) + 색 내부 택1(용지 드롭다운)**으로 통합했다. 075/076은 `del_yn=Y` 은퇴(노드 미생성·정상 은퇴).
  면지 자재(화/블/그)는 부모 072 → 면지 멤버 074로 이관됐고 부모의 면지 자재·옵션그룹은 **은퇴(활성 0)**
  (072-post-verify §1·§3). live-snapshot 20260702_1119의 072 면지 4멤버·부모 면지자재/OPT_064 구조는 이 재설계보다 앞선
  스냅샷이라 **STALE**(팩 §2 T-3) — 이 노드는 재설계 후 상태(post-verify)를 정본으로 한다.
- **가격 경계(D-18)**: 이 노드는 has_member·priced_by·아키타입 선언까지만. 셋트 이중합산 방지도 evaluate_set_price 소관(스키마 §4.4).
- **골든 무손상**: 면지 재설계가 건드린 요소(면지멤버·면지자재·면지옵션)는 전부 가격 미배선 → 골든 불변(아래 전사표·072-post-verify §2).

## 셋트 골든 (권위 = simulate-set 실호출)

<!-- transcribed-by: pack-set-series.md §1 <- 06_load/leather-hardcover-membrane-072-post-verify.md §2 (POST /admin/price-viewer/PRD_000072/simulate-set/ 실호출·인증세션). 손전사 아님·실호출 전사. -->
| 부수(copies) | final_price | ok | errors(제외) |
|---|---|---|---|
| 1 | 34,100 | true | [] |
| 10 | 159,100 | true | [] |
| 100 | 796,900 | true | [] |

PRICE≠0·제외 0·이중합산 0(073 표지=NONE·284 내지=FORMULA→0·074 면지=NONE·set_eval COVERBIND 단독).
멤버 옵션그룹 UI 렌더(D-1)·내지 페이지 단가(D-2)는 후속 [[rule/gaps#gap-set-member-optgroup-ui]]·[[rule/gaps#gap-set-inner-page-price]].
</content>
</invoke>
