---
id: product-178-spring-notebook
type: product
anchor: t_prd_products/PRD_000178
badge: candidate
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000178 (prd_typ_cd=PRD_TYPE.01·del_yn=N·use_yn=Y·min4/max500/incr4·QTY_UNIT.03·file_upload=Y·editor=Y)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "live-snapshot/latest/t_prd_product_sets.csv", source_locator: "테이블:t_prd_product_sets 키:prd_cd=PRD_000178 (303 표지 disp1·304 내지 무지 disp2)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-stationery-goods.md", source_locator: "§1.1 문구 셋트 인벤토리(178 스프링수첩·고정가형)·§3.10 아키타입·§4 sparse", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-stn}
relations:
  - {rel: in_category, target: category-CAT_000008, note: "문구(main_cat_yn=Y·disp9·live)"}
  - {rel: in_category, target: category-CAT_000124, note: "노트(live)"}
  - {rel: has_member, target: product-303-spring-notebook-cover, qualifier: {semi_role: "SEMI_ROLE.02", disp_seq: 1, min_cnt: 1, max_cnt: 1}, note: "표지(아트250+무광코팅·1권고정)"}
  - {rel: has_member, target: product-304-spring-notebook-inner, qualifier: {semi_role: "SEMI_ROLE.01", disp_seq: 2}, note: "내지(무지·현재 인쇄없음·min/max 미설정→gap-stn-muji-inner-minmax·추후 커스텀인쇄 확장)"}
  - {rel: has_size, target: size-SIZ_000377, note: "90x145(dflt Y·live PRD_000178)·축 노드 mint(Stage C1)"}
  - {rel: has_print_option, target: printopt-POPT_000001, note: "단면 칼라(dflt)"}
  - {rel: has_process, target: process-PROC_000021, qualifier: mandatory, note: "트윈링제본(스프링 mand·live PRD_000178)"}
  - {rel: has_process, target: process-PROC_000015, note: "무광라미네이팅(표지·옵션)"}
  - {rel: has_qty_rule, target: qty-178, note: "스프링수첩 수량규칙(min4/max500/incr4·★incr=4 특이·bundle_qtys 0행)·축 노드 mint(Stage C1)"}
  - {rel: priced_by, target: formula-PRF_STN_SPRINGNOTEBK, note: "셋트 부모공식(고정가형·완제품가). evaluate_set_price=구성원 합산+이 부모공식+할인(pricing.py:718)"}
  - {rel: references, target: gap-stn-sparse-grid, note: "완제품가 COMP_STN_SPRINGNOTEBK 단가행 1셀(등록 사이즈 SIZ_000377=3,000)·등록=선택가능 사이즈는 PRICE≠0·미등록(off-grid) 사이즈만 견적0·수량은 단가행 min_qty=1 단일밴드로 전량 커버(상품 UI 스텝=4권 단위)"}
props:
  prd_typ_cd: "PRD_TYPE.01"
  role: "셋트 완제품(t_prd_product_sets 부모)"
  archetype: "고정가형(부모 all-in·완제품가·evaluate_set_price)"
  min_qty: 4
  max_qty: 500
  qty_incr: 4
  qty_unit_typ_cd: "QTY_UNIT.03"
  file_upload_yn: "Y"
  editor_yn: "Y"
  단가행: "1셀(sparse·등록 사이즈 SIZ_000377 PRICE≠0(=3,000)·off-grid만 견적0·수량 min_qty=1 단일밴드 전량 커버·UI 스텝 4권)"
  구분: "스프링수첩(셋트 완제품·표지+무지 내지 조립)"
standards: {schema_org: "Product", xjdf: "Product(스프링수첩 assembly)", config_ont: "assembly"}
answers_cq: ["스프링수첩 구성·가격 축(셋트 완제품)", "스프링수첩 셋트 조립 상품"]
tags: ["#셋트", "#문구", "#노트", "#고정가형", "#sparse"]
updated: 2026-07-03
---

# 스프링수첩 (product-178-spring-notebook)

스프링수첩(PRD_000178)은 **셋트 완제품**(prd_typ_cd=PRD_TYPE.01·`t_prd_product_sets` 부모 등록 = 셋트 완제품
유일 기준·CLAUDE.md §1 [HARD]). **표지([[product-303-spring-notebook-cover]]·SEMI_ROLE.02)+무지 내지
([[product-304-spring-notebook-inner]]·SEMI_ROLE.01)** 반제품 조립이다. 가격은 **`evaluate_set_price`**
(구성원 합산 + 셋트 부모공식 [[formula/stationery-formulas#formula-PRF_STN_SPRINGNOTEBK]] + 할인·pricing.py:718)로
계산한다(값=엔진 권위·D-18).

- **정체·구조**: pack §1.1/§3.1(FRESH) + live `t_prd_product_sets` 실측. 177 스프링노트와 동형(무지 내지·트윈링제본).
- **가격아키타입 = 고정가형(부모 all-in)**: 부모공식 PRF_STN_SPRINGNOTEBK가 `[siz_cd,min_qty]` 차원으로 완제품가 반환.
  값 계산은 KB 밖(D-18).
- **★sparse 정직 표기(pack §4·T-9·badge=candidate)**: 완제품가 구성요소(COMP_STN_SPRINGNOTEBK) 단가행은 **등록 사이즈 1셀**
  (SIZ_000377)만 채워진 sparse grid다. **등록=선택가능 사이즈는 PRICE≠0**(=3,000 라이브 simulate 실증)이고 **미등록(off-grid)
  사이즈만 견적0**이며, 수량은 단가행 min_qty=1 단일밴드로 전량 선형 커버(상품 UI 스텝은 4권 단위). "공식 존재≠가격 완성"은
  등록 외 사이즈 확장 한정·badge=candidate → [[rule/gaps#gap-stn-sparse-grid]].
- **★수량 incr=4(honest)**: 상품 수량 min4/max500/incr4(4권 단위)로 176/177(incr1)과 다르다(아래 전사표).
- **축 배선(Stage C2)**: 기본 사이즈 SIZ_000377(90x145·has_size)·qty-178(has_qty_rule) 축 노드 mint(C1)→배선 완료.
  판형(표지 파일사양 SIZ_000378)만 plate 축 미민팅 → 아래 전사표 권위.

## 셋트 구성·차원 전사표 (권위 = 라이브 스냅샷 awk 전사)

<!-- transcribed-by: awk t_prd_product_sets from live-snapshot/latest (snap_20260702_1119) prd_cd=PRD_000178 @ 2026-07-03 -->

#### 셋트 구성원 (has_member·R13)
| sub_prd_cd | 역할(semi_role) | disp_seq | min_cnt/max_cnt/incr | note |
|---|---|---|---|---|
| PRD_000303 | 표지(SEMI_ROLE.02) | 1 | 1/1/- | 아트250+무광코팅·1권고정 |
| PRD_000304 | 내지(SEMI_ROLE.01) | 2 | -/-/- | 무지·현재 인쇄없음·min/max 미설정(gap-stn-muji-inner-minmax) |

#### 사이즈·도수·공정·카테고리 (부모 레벨)
<!-- transcribed-by: awk t_prd_product_sizes+print_options+processes+categories from live-snapshot/latest (snap_20260702_1119) prd_cd=PRD_000178 @ 2026-07-03 -->
| 축 | 코드 | 라벨 | dflt/mand | 축노드 |
|---|---|---|---|---|
| size | SIZ_000377 | 90x145 | Y | O(has_size 배선·Stage C2) |
| print_option | POPT_000001 | 단면 | Y(dflt) | O(has_print_option) |
| process | PROC_000021 | 트윈링제본 | Y(mand) | O(has_process·mand) |
| process | PROC_000015 | 무광라미네이팅 | N(opt) | O(has_process) |
| category | CAT_000008 | 문구 | main Y·disp9 | O(in_category) |
| category | CAT_000124 | 노트 | N | O(in_category) |

#### 판형(파일사양·비표준→축 미민팅)
<!-- transcribed-by: awk t_prd_product_plate_sizes from live-snapshot/latest (snap_20260702_1119) prd_cd=PRD_000178 @ 2026-07-03 -->
| siz_cd | 규격 | note | output_paper_typ |
|---|---|---|---|
| SIZ_000378 | 94x149 | 표지파일사양 | (공란) |

판형 행은 표지 **파일사양**(output_paper_typ 공란)이라 표준 출력용지 plate 노드 아님 → `has_plate_size` 미배선(needs_axis).
기본 사이즈 SIZ_000377(90x145)은 축 mint(C1)→`has_size` 배선(Stage C2).

#### 수량 규칙 + 가격공식 바인딩
<!-- transcribed-by: awk t_prd_products+t_prd_product_price_formulas from live-snapshot/latest (snap_20260702_1119) prd_cd=PRD_000178 @ 2026-07-03 -->
| 원천 | 값 |
|---|---|
| 상품 수량 | min 4 / max 500 / incr 4 (QTY_UNIT.03) |
| t_prd_product_bundle_qtys | 0행(수량 그릇=상품) |
| 가격공식 | PRF_STN_SPRINGNOTEBK (2026-06-06 apply·고정가형·단가행 1셀 sparse) |

`priced_by` → [[formula/stationery-formulas#formula-PRF_STN_SPRINGNOTEBK]](고정가·부모 all-in). 값 계산은
`evaluate_set_price`(D-18 경계).
</content>
