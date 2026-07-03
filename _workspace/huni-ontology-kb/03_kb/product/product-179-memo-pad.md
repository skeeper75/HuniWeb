---
id: product-179-memo-pad
type: product
anchor: t_prd_products/PRD_000179
badge: candidate
sources:
  - {source_file: "RAILWAY_DB live (railway·읽기전용 SELECT)", source_locator: "테이블:t_prd_products 키:PRD_000179 (prd_typ_cd=PRD_TYPE.01·del_yn=N·use_yn=Y·min1/max1000/incr1·QTY_UNIT.03·file_upload_yn=Y·editor_yn=Y)", captured_at: "live 2026-07-03", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "RAILWAY_DB live (railway·읽기전용 SELECT)", source_locator: "테이블:t_prd_product_sets 키:prd_cd=PRD_000179 (305 표지 disp1 1/1/1·306 내지무지 disp2 min/max 미설정)·t_prd_product_price_formulas (PRD_000179,PRF_STN_MEMOPAD) apply_bgn 2026-06-06·t_prc_component_prices COMP_STN_MEMOPAD=2셀", captured_at: "live 2026-07-03", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-stationery-goods.md", source_locator: "§1.1 인벤토리(179 메모패드·고정가형·단가행 2셀)·§3.10 가격아키타입·§4 sparse 양면표기·SB-1", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-stn}
relations:
  - {rel: in_category, target: category-CAT_000008, note: "문구(main_cat_yn=Y·live PRD_000179)"}
  - {rel: in_category, target: category-CAT_000124, note: "노트(sub·live PRD_000179)"}
  - {rel: has_member, target: product-305-memo-pad-cover, qualifier: {semi_role: "SEMI_ROLE.02", disp_seq: 1, min_cnt: 1, max_cnt: 1, cnt_incr: 1}, note: "표지(305·아트250+무광코팅·1권고정)"}
  - {rel: has_member, target: product-306-memo-pad-inner, qualifier: {semi_role: "SEMI_ROLE.01", disp_seq: 2}, note: "내지(306·무지·min/max 미설정=gap-stn-muji-inner-minmax)"}
  - {rel: has_size, target: size-SIZ_000380, note: "B5(182x257·dflt Y·live)"}
  - {rel: has_size, target: size-SIZ_000379, note: "144x206(dflt Y·live PRD_000179)·축 노드 mint(Stage C1)"}
  - {rel: has_plate_size, target: plate-SIZ_000007, note: "표지파일사양 148x210(dflt·live PRD_000179 plate·output_paper_typ 공란 신규축)·축 노드 mint(Stage C1)"}
  - {rel: has_plate_size, target: plate-SIZ_000381, note: "표지파일사양 186x261(dflt·live PRD_000179 plate·output_paper_typ 공란 신규축)·축 노드 mint(Stage C1)"}
  - {rel: has_print_option, target: printopt-POPT_000001, note: "단면(front CMYK 4도 CLR_000005 / back 인쇄안함 CLR_000001·dflt Y·live)"}
  - {rel: has_process, target: process-PROC_000022, qualifier: mandatory, note: "떡제본(제본 공정·mand_proc_yn=Y·live PRD_000179)"}
  - {rel: has_process, target: process-PROC_000015, note: "무광라미네이팅(옵션·mand N·disp5·live PRD_000179)"}
  - {rel: priced_by, target: formula-PRF_STN_MEMOPAD, note: "셋트 부모공식(고정가형·완제품가·use_dims=[siz_cd,min_qty]). evaluate_set_price=구성원 evaluate_price 합산+이 부모공식+할인(pricing.py:718)"}
  - {rel: references, target: gap-stn-sparse-grid, note: "완제품가 COMP_STN_MEMOPAD 단가행 2셀(등록 사이즈 144x206=5,000·B5=6,000)·등록=선택가능 사이즈는 PRICE≠0·미등록(off-grid) 사이즈만 견적0·수량은 min_qty=1 단일밴드로 전량 커버(9 문구공식 중 유일 2셀)"}
  - {rel: references, target: gap-stn-member-optgroup-ui, note: "구성원 옵션그룹 UI 렌더(D-1 동류)"}
props:
  prd_typ_cd: "PRD_TYPE.01"
  role: "셋트 완제품(t_prd_product_sets 부모)"
  archetype: "고정가형(부모 all-in·evaluate_set_price)"
  min_qty: 1
  max_qty: 1000
  qty_incr: 1
  qty_unit_typ_cd: "QTY_UNIT.03"
  file_upload_yn: "Y"
  editor_yn: "Y"
  단가행: "2셀(sparse·9 문구공식 중 유일 2셀)"
  구분: "메모패드(셋트 완제품·표지+내지 조립)"
standards: {schema_org: "Product", xjdf: "Product(메모패드 assembly·BindingIntent 떡제본)", config_ont: "assembly"}
answers_cq: ["메모패드 구성·가격 축(셋트 완제품)", "표지+무지내지 조립 상품"]
tags: ["#셋트", "#문구", "#메모패드", "#고정가형", "#sparse"]
updated: 2026-07-03
---

# 메모패드 (product-179-memo-pad)

메모패드(PRD_000179)는 **셋트 완제품**(prd_typ_cd=PRD_TYPE.01·`t_prd_product_sets` 부모 등록 = 셋트
완제품 유일 기준·CLAUDE.md §1 [HARD]). **표지(305)+내지(306·무지)** 반제품 조립이다
([[product-305-memo-pad-cover]]·[[product-306-memo-pad-inner]]). 가격은 단일 `evaluate_price`가
아니라 **`evaluate_set_price`**(구성원별 evaluate_price 합산 + 셋트 부모공식
[[formula/stationery-formulas.md#formula-PRF_STN_MEMOPAD]] + 할인·pricing.py:718)로 계산한다(값 계산
=엔진 권위·[[rule/rules.md#RULE_price_value_boundary]]·D-18 경계).

- **정체·구조**: pack §3.1/§3.12(FRESH) + live `t_prd_product_sets` 실측(2026-07-03 재확인). 구성원 mint
  = 2026-07-01(reg_dt). set-series 094 엽서북과 동형(고정가형 부모 all-in).
- **가격아키타입 = 고정가형(부모 all-in)**: 부모공식 PRF_STN_MEMOPAD가 `[siz_cd,min_qty]` 차원으로 완제품가를
  룩업하고 evaluate_set_price가 구성원 값을 합산한다. 온톨로지는 priced_by·has_member·아키타입 선언까지.
- **★sparse GAP 양면(pack §4·T-9·badge=candidate)**: 완제품가 구성요소 COMP_STN_MEMOPAD의 단가행은
  **등록 사이즈 2셀(144x206=5,000·B5 182x257=6,000)**만 채워진 sparse grid다(문구 셋트 9공식 중 유일 2셀·나머지 1셀).
  **등록=선택가능 사이즈는 전부 PRICE≠0**(라이브 simulate 실증)이고 **미등록(off-grid) 사이즈만 견적0**이며, 수량은
  단가행 min_qty=1 단일밴드로 전량 선형 커버된다. "공식 존재 ≠ 가격 완성"은 등록 외 사이즈 확장 한정이므로 이 부모 노드
  badge=**candidate**(🟡)이고 [[rule/gaps.md#gap-stn-sparse-grid]]로 라우팅한다(등록 외 사이즈 grid 충전 대기·L-12·D-22).
- **판형(표지파일사양·Stage C2 배선)**: 부모 179에 plate_size 2행(SIZ_000007 148x210·SIZ_000381 186x261·note
  "표지파일사양"·output_paper_typ 공란 신규축)이 실재하며 plate 축 노드 mint(C1)→**`has_plate_size` 배선 완료**. 내지
  구성원(306)에는 plate 행 없음(멤버 empty-shell·아래 전사표).
- **축 배선(Stage C2)**: 사이즈 SIZ_000380(B5)·SIZ_000379(144x206)·판형 SIZ_000007/000381 축 노드 mint(C1)→
  `has_size`·`has_plate_size` 배선 완료(전사표 정합).

## 차원·구성원·연결 전사표 (권위 = 라이브 DB·읽기전용 SELECT 전사)

#### 셋트 구성원 (has_member·R13)

<!-- transcribed-by: RAILWAY_DB SELECT t_prd_product_sets JOIN t_prd_products where prd_cd=PRD_000179 and del_yn=N @ 2026-07-03 -->
| sub_prd_cd | 역할(semi_role) | sub_prd_qty | disp_seq | min/max/incr | note |
|---|---|---|---|---|---|
| PRD_000305 | 표지(SEMI_ROLE.02) | 1 | 1 | 1/1/- | 표지=아트250+무광코팅(MAT_000250)·1권고정 |
| PRD_000306 | 내지(SEMI_ROLE.01) | 1 | 2 | -/-/- | 내지=무지(무지내지 MAT_000261)·min/max 미설정=[[rule/gaps.md#gap-stn-muji-inner-minmax]]·추후 커스텀인쇄 확장 |

#### 사이즈+판형+도수+공정 (부모 레벨·현재 DB)

<!-- transcribed-by: RAILWAY_DB SELECT t_prd_product_sizes/plate_sizes/print_options/processes where prd_cd=PRD_000179 and del_yn=N @ 2026-07-03 -->
| 축 | 코드 | 라벨 | dflt/mand | 축노드 존재 |
|---|---|---|---|---|
| size | SIZ_000380 | B5(182x257) | Y | O(has_size 배선) |
| size | SIZ_000379 | 144x206 | Y | O(has_size 배선·Stage C2) |
| plate | SIZ_000007 | 148x210(표지파일사양) | Y | O(has_plate_size 배선·Stage C2) |
| plate | SIZ_000381 | 186x261(표지파일사양) | Y | O(has_plate_size 배선·Stage C2) |
| print_option | POPT_000001 | 단면(front CMYK4도/back 인쇄안함) | Y(dflt) | O |
| process | PROC_000022 | 떡제본 | Y(mand) | O(has_process 배선) |
| process | PROC_000015 | 무광라미네이팅 | N(opt·disp5) | O(has_process 배선) |

#### 수량 규칙 + 가격공식 바인딩

<!-- transcribed-by: RAILWAY_DB SELECT t_prd_products/price_formulas/component_prices where prd_cd=PRD_000179 @ 2026-07-03 -->
| 원천 | 값 |
|---|---|
| 상품 수량 | min 1 / max 1000 / incr 1 (QTY_UNIT.03) |
| t_prd_product_bundle_qtys | 0행(수량 그릇=상품 min/max) |
| 가격공식 | PRF_STN_MEMOPAD (apply_bgn 2026-06-06·"메모패드 완제품가") |
| 완제품가 구성요소 | COMP_STN_MEMOPAD·use_dims=[siz_cd,min_qty]·**단가행 2셀(sparse)** |

`priced_by` → [[formula/stationery-formulas.md#formula-PRF_STN_MEMOPAD]](고정가·부모 all-in·has_component
COMP_STN_MEMOPAD). 값 계산은 `evaluate_set_price`(D-18 경계). 카테고리(CAT_000008 문구·CAT_000124 노트)·사이즈
SIZ_000379·판형 SIZ_000007/000381 축 노드는 mint(C1)→has_size·has_plate_size 배선(Stage C2·전사표 정합).
