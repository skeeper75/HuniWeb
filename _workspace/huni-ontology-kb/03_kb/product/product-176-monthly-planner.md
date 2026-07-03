---
id: product-176-monthly-planner
type: product
anchor: t_prd_products/PRD_000176
badge: candidate
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000176 (prd_typ_cd=PRD_TYPE.01·del_yn=N·use_yn=Y·min1/max500/incr1·QTY_UNIT.03·file_upload=N·editor=Y)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "live-snapshot/latest/t_prd_product_sets.csv", source_locator: "테이블:t_prd_product_sets 키:prd_cd=PRD_000176 (299 표지 disp1·300 내지 disp2 28p고정)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-stationery-goods.md", source_locator: "§1.1 문구 셋트 인벤토리(176 먼슬리플래너·고정가형)·§3.10 아키타입·§4 sparse", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-stn}
relations:
  - {rel: in_category, target: category-CAT_000321, note: "플래너(main_cat_yn=N·상위 CAT_000008·live PRD_000176)·축 노드 mint(Stage C1)"}
  - {rel: has_member, target: product-299-monthly-planner-cover, qualifier: {semi_role: "SEMI_ROLE.02", disp_seq: 1, min_cnt: 1, max_cnt: 1}, note: "표지(아트250+무광코팅·1권고정)"}
  - {rel: has_member, target: product-300-monthly-planner-inner, qualifier: {semi_role: "SEMI_ROLE.01", disp_seq: 2, min_cnt: 28, max_cnt: 28, cnt_incr: 0}, note: "내지(백모조100·28p 고정·양면인쇄·page_rule 28/28/0)"}
  - {rel: has_size, target: size-SIZ_000170, note: "A5 148x210(dflt·부모 레벨·정션 활성(t_prd_product_sizes del_yn=N)·마스터 논리삭제(t_siz_sizes del_yn=Y 2026-06-17)이나 load-bearing·형제 181 SIZ_000196 동형·live 재실측)"}
  - {rel: has_print_option, target: printopt-POPT_000002, note: "양면 칼라(dflt·내지 28p 양면인쇄)"}
  - {rel: has_print_option, target: printopt-POPT_000001, note: "단면 칼라"}
  - {rel: has_process, target: process-PROC_000015, note: "무광라미네이팅(표지·옵션·disp5). ★mand 제본공정 부모 미등록(honest)"}
  - {rel: has_qty_rule, target: qty-176, note: "먼슬리플래너 수량규칙(min1/max500/incr1·bundle_qtys 0행·수량 그릇=상품)·축 노드 mint(Stage C1)"}
  - {rel: priced_by, target: formula-PRF_STN_MONTHLY, note: "셋트 부모공식(고정가형·완제품가·use_dims=[siz_cd,min_qty]). evaluate_set_price=구성원 합산+이 부모공식+할인(pricing.py:718)"}
props:
  prd_typ_cd: "PRD_TYPE.01"
  role: "셋트 완제품(t_prd_product_sets 부모)"
  archetype: "고정가형(부모 all-in·완제품가·evaluate_set_price)"
  min_qty: 1
  max_qty: 500
  qty_incr: 1
  qty_unit_typ_cd: "QTY_UNIT.03"
  file_upload_yn: "N"
  editor_yn: "Y"
  단가행: "1셀(sparse·등록 사이즈 SIZ_000170 PRICE≠0(=12,000)·off-grid만 견적0·수량 min_qty=1 단일밴드 전량 커버)"
  구분: "먼슬리플래너(셋트 완제품·표지+내지 조립)"
standards: {schema_org: "Product", xjdf: "Product(먼슬리플래너 assembly)", config_ont: "assembly"}
answers_cq: ["먼슬리플래너 구성·가격 축(셋트 완제품)", "플래너 셋트 조립 상품"]
tags: ["#셋트", "#문구", "#플래너", "#고정가형", "#sparse"]
updated: 2026-07-03
---

# 먼슬리플래너 (product-176-monthly-planner)

먼슬리플래너(PRD_000176)는 **셋트 완제품**(prd_typ_cd=PRD_TYPE.01·`t_prd_product_sets` 부모 등록 =
셋트 완제품 유일 기준·CLAUDE.md §1 [HARD]). **표지([[product-299-monthly-planner-cover]]·SEMI_ROLE.02)+
내지([[product-300-monthly-planner-inner]]·SEMI_ROLE.01·28p 고정)** 반제품 조립이다. 가격은 단일
`evaluate_price`가 아니라 **`evaluate_set_price`**(구성원별 evaluate_price 합산 + 셋트 부모공식
[[formula/stationery-formulas#formula-PRF_STN_MONTHLY]] + 할인·pricing.py:718)로 계산한다(값 계산=엔진
권위·[[rule/rules#RULE_price_value_boundary]]).

- **정체·구조**: pack §1.1/§3.1(FRESH) + live `t_prd_product_sets` 실측. set-series 094/097 고정가형 동형.
- **가격아키타입 = 고정가형(부모 all-in)**: 부모공식 PRF_STN_MONTHLY가 `[siz_cd,min_qty]` 차원으로 완제품가를
  반환(구성원 기여는 evaluate_set_price 합산). 값 계산은 KB 밖(D-18) — 온톨로지는 priced_by·has_member·아키타입까지.
- **★sparse 정직 표기(pack §4·T-9·badge=candidate)**: 완제품가 구성요소(COMP_STN_MONTHLY)의 단가행은
  **등록 사이즈 1셀**(SIZ_000170 A5)만 채워진 sparse grid다. **등록=선택가능 사이즈는 PRICE≠0**(A5=12,000 라이브
  simulate 실증)이고 **미등록(off-grid) 사이즈만 견적0**이며, 수량은 단가행 min_qty=1 단일밴드로 전량 선형 커버된다.
  즉 grid가 sparse(등록 사이즈 수가 적음)일 뿐 손님이 등록 사이즈를 고르면 0을 만나지 않는다. "공식 존재 ≠ 가격 완성"은
  등록 외 사이즈 확장 한정 → badge=candidate → [[rule/gaps#gap-stn-sparse-grid]].
- **★mand 제본공정 부모 미등록(honest)**: 177/178은 트윈링제본(PROC_000021)이 mand로 등록됐으나 176 부모에는
  mand 제본공정 행이 없다(등록 공정=무광라미네이팅 opt 1행뿐·아래 전사표). 조용한 누락 아님·정직 선언.
- **축 배선(Stage C2)**: 카테고리 CAT_000321(플래너·in_category)·qty-176(has_qty_rule) 축 노드는 mint(C1) 후
  배선 완료. 판형(표지/내지 파일사양 SIZ_000376/SIZ_000180·output_paper_typ 공란)만 plate 축 미민팅 → 아래 전사표 권위.

## 셋트 구성·차원 전사표 (권위 = 라이브 스냅샷 awk 전사)

<!-- transcribed-by: awk t_prd_product_sets from live-snapshot/latest (snap_20260702_1119) prd_cd=PRD_000176 @ 2026-07-03 -->

#### 셋트 구성원 (has_member·R13)
| sub_prd_cd | 역할(semi_role) | disp_seq | min_cnt/max_cnt/incr | note |
|---|---|---|---|---|
| PRD_000299 | 표지(SEMI_ROLE.02) | 1 | 1/1/- | 아트250+무광코팅·1권고정 |
| PRD_000300 | 내지(SEMI_ROLE.01) | 2 | 28/28/0 | 백모조100·28p 고정(양면인쇄)·page_rule 28/28/0 |

#### 사이즈·도수·공정 (부모 레벨)
<!-- transcribed-by: awk t_prd_product_sizes+print_options+processes+page_rules from live-snapshot/latest (snap_20260702_1119) prd_cd=PRD_000176 @ 2026-07-03 -->
| 축 | 코드 | 라벨 | dflt/mand | 축노드 |
|---|---|---|---|---|
| size | SIZ_000170 | A5 148x210 | Y | O(has_size) |
| print_option | POPT_000002 | 양면 | Y(dflt) | O(has_print_option) |
| print_option | POPT_000001 | 단면 | Y(dflt·이중 dflt 데이터 quirk) | O(has_print_option) |
| process | PROC_000015 | 무광라미네이팅 | N(opt·disp5) | O(has_process) |
| page_rule | 28/28/0 | 내지 28p 고정 | — | (부모 page_rule) |

#### 판형(파일사양·output_paper_typ 공란·비표준→축 미민팅)
<!-- transcribed-by: awk t_prd_product_plate_sizes from live-snapshot/latest (snap_20260702_1119) prd_cd=PRD_000176 @ 2026-07-03 -->
| siz_cd | 규격 | note | output_paper_typ |
|---|---|---|---|
| SIZ_000376 | 150x216 | 내지파일사양 | (공란·PDF) |
| SIZ_000180 | 302x216 | 표지파일사양 | (공란·PDF) |

판형 행은 표지/내지 **파일사양**(output_paper_typ 공란)이라 표준 출력용지 plate 노드가 아니다 → `has_plate_size`
미배선(전사표 권위·needs_axis). 카테고리 CAT_000321(플래너)은 축 mint(C1)→`in_category` 배선(Stage C2).

#### 수량 규칙 + 가격공식 바인딩
<!-- transcribed-by: awk t_prd_products+t_prd_product_price_formulas from live-snapshot/latest (snap_20260702_1119) prd_cd=PRD_000176 @ 2026-07-03 -->
| 원천 | 값 |
|---|---|
| 상품 수량 | min 1 / max 500 / incr 1 (QTY_UNIT.03) |
| t_prd_product_bundle_qtys | 0행(수량 그릇=상품/page_rule) |
| 가격공식 | PRF_STN_MONTHLY (2026-06-06 apply·고정가형·단가행 1셀 sparse) |

`priced_by` → [[formula/stationery-formulas#formula-PRF_STN_MONTHLY]](고정가·부모 all-in). 값 계산은
`evaluate_set_price`(D-18 경계). 구성원 옵션그룹 UI 렌더는 후속 [[rule/gaps#gap-stn-member-optgroup-ui]].
