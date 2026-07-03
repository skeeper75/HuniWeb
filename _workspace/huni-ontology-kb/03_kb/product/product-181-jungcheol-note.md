---
id: product-181-jungcheol-note
type: product
anchor: t_prd_products/PRD_000181
badge: candidate
sources:
  - {source_file: "RAILWAY_DB live (railway·읽기전용 SELECT)", source_locator: "테이블:t_prd_products 키:PRD_000181 (prd_typ_cd=PRD_TYPE.01·del_yn=N·use_yn=Y·min4/max500/incr4·QTY_UNIT.03·file_upload_yn=Y·editor_yn=Y)", captured_at: "live 2026-07-03", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "RAILWAY_DB live (railway·읽기전용 SELECT)", source_locator: "테이블:t_prd_product_sets 키:prd_cd=PRD_000181 (307 표지 disp1 1/1/1·308 내지무지 disp2 min/max 미설정)·t_prd_product_price_formulas (PRD_000181,PRF_STN_JUNGCHEOL) apply_bgn 2026-06-06·t_prc_component_prices COMP_STN_JUNGCHEOL=1셀", captured_at: "live 2026-07-03", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-stationery-goods.md", source_locator: "§1.1 인벤토리(181 중철노트·고정가형·단가행 1셀)·§3.10 가격아키타입·§4 sparse 양면표기·SB-1", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-stn}
relations:
  - {rel: in_category, target: category-CAT_000008, note: "문구(main_cat_yn=Y·live PRD_000181)"}
  - {rel: in_category, target: category-CAT_000124, note: "노트(sub·live PRD_000181)"}
  - {rel: has_member, target: product-307-jungcheol-note-cover, qualifier: {semi_role: "SEMI_ROLE.02", disp_seq: 1, min_cnt: 1, max_cnt: 1, cnt_incr: 1}, note: "표지(307·아트250+무광코팅·1권고정)"}
  - {rel: has_member, target: product-308-jungcheol-note-inner, qualifier: {semi_role: "SEMI_ROLE.01", disp_seq: 2}, note: "내지(308·무지·중철제본·min/max 미설정=gap-stn-muji-inner-minmax)"}
  - {rel: has_size, target: size-SIZ_000196, note: "A6(105x148mm·dflt Y·live PRD_000181·정션 활성·마스터 논리삭제이나 load-bearing)·축 노드 mint(Stage C1)"}
  - {rel: has_plate_size, target: plate-SIZ_000382, note: "표지파일사양 216x154(dflt·live PRD_000181 plate·output_paper_typ 공란 신규축)·축 노드 mint(Stage C1)"}
  - {rel: has_print_option, target: printopt-POPT_000001, note: "단면(front CMYK 4도 CLR_000005 / back 인쇄안함 CLR_000001·dflt Y·live)"}
  - {rel: has_process, target: process-PROC_000018, qualifier: mandatory, note: "중철제본(제본 공정·mand_proc_yn=Y·live PRD_000181)"}
  - {rel: has_process, target: process-PROC_000015, note: "무광라미네이팅(옵션·mand N·disp5·live PRD_000181)"}
  - {rel: priced_by, target: formula-PRF_STN_JUNGCHEOL, note: "셋트 부모공식(고정가형·완제품가·use_dims=[siz_cd,min_qty]). evaluate_set_price=구성원 evaluate_price 합산+이 부모공식+할인(pricing.py:718)"}
  - {rel: references, target: gap-stn-sparse-grid, note: "완제품가 COMP_STN_JUNGCHEOL 단가행 1셀(등록 사이즈 SIZ_000196 A6=2,500)·등록=선택가능 사이즈는 PRICE≠0·미등록(off-grid) 사이즈만 견적0·수량은 min_qty=1 단일밴드로 전량 커버(UI 스텝=4권)"}
  - {rel: references, target: gap-stn-member-optgroup-ui, note: "구성원 옵션그룹 UI 렌더(D-1 동류)"}
props:
  prd_typ_cd: "PRD_TYPE.01"
  role: "셋트 완제품(t_prd_product_sets 부모)"
  archetype: "고정가형(부모 all-in·evaluate_set_price)"
  min_qty: 4
  max_qty: 500
  qty_incr: 4
  qty_unit_typ_cd: "QTY_UNIT.03"
  file_upload_yn: "Y"
  editor_yn: "Y"
  단가행: "1셀(sparse)"
  구분: "중철노트(셋트 완제품·표지+내지 조립·중철제본)"
standards: {schema_org: "Product", xjdf: "Product(중철노트 assembly·BindingIntent 중철제본)", config_ont: "assembly"}
answers_cq: ["중철노트 구성·가격 축(셋트 완제품)", "표지+무지내지 중철제본 조립 상품"]
tags: ["#셋트", "#문구", "#중철노트", "#고정가형", "#sparse"]
updated: 2026-07-03
---

# 중철노트 (product-181-jungcheol-note)

중철노트(PRD_000181)는 **셋트 완제품**(prd_typ_cd=PRD_TYPE.01·`t_prd_product_sets` 부모 등록 = 셋트
완제품 유일 기준·CLAUDE.md §1 [HARD]). **표지(307)+내지(308·무지)** 반제품 조립이다
([[product-307-jungcheol-note-cover]]·[[product-308-jungcheol-note-inner]]). 가격은 단일 `evaluate_price`가
아니라 **`evaluate_set_price`**(구성원별 evaluate_price 합산 + 셋트 부모공식
[[formula/stationery-formulas.md#formula-PRF_STN_JUNGCHEOL]] + 할인·pricing.py:718)로 계산한다(값 계산
=엔진 권위·[[rule/rules.md#RULE_price_value_boundary]]·D-18 경계).

- **정체·구조**: pack §3.1/§3.12(FRESH) + live `t_prd_product_sets` 실측(2026-07-03 재확인). 구성원 mint
  = 2026-07-01(reg_dt). set-series 고정가형 부모 all-in 동형. 수량 규칙 = **4권 묶음**(min4/max500/incr4).
- **가격아키타입 = 고정가형(부모 all-in)**: 부모공식 PRF_STN_JUNGCHEOL가 `[siz_cd,min_qty]` 차원으로 완제품가를
  룩업하고 evaluate_set_price가 구성원 값을 합산한다. 온톨로지는 priced_by·has_member·아키타입 선언까지.
- **★sparse GAP 양면(pack §4·T-9·badge=candidate)**: 완제품가 구성요소 COMP_STN_JUNGCHEOL의 단가행은
  **등록 사이즈 1셀**(A6 SIZ_000196=2,500)만 채워진 sparse grid다. **등록=선택가능 사이즈는 PRICE≠0**(A6=2,500 라이브
  simulate 실증)이고 **미등록(off-grid) 사이즈만 견적0**이며, 수량은 단가행 min_qty=1 단일밴드로 전량 선형 커버(상품 UI 스텝=4권).
  "공식 존재 ≠ 가격 완성"은 등록 외 사이즈 확장 한정이므로 이 부모 노드 badge=**candidate**(🟡)이고
  [[rule/gaps.md#gap-stn-sparse-grid]]로 라우팅한다(등록 외 사이즈 grid 충전 대기·L-12·D-22).
- **판형(표지파일사양·Stage C2 배선)**: 부모 181에 plate_size 1행(SIZ_000382 216x154·note "표지파일사양"·
  output_paper_typ 공란 신규축)이 실재하며 plate 축 노드 mint(C1)→**`has_plate_size` 배선 완료**. 내지 구성원(308)에는 plate 행 없음.
- **축 배선(Stage C2)**: 사이즈 SIZ_000196(A6 105x148·정션 활성)·판형 SIZ_000382 축 노드 mint(C1)→`has_size`·
  `has_plate_size` 배선 완료(전사표 정합).

## 차원·구성원·연결 전사표 (권위 = 라이브 DB·읽기전용 SELECT 전사)

#### 셋트 구성원 (has_member·R13)

<!-- transcribed-by: RAILWAY_DB SELECT t_prd_product_sets JOIN t_prd_products where prd_cd=PRD_000181 and del_yn=N @ 2026-07-03 -->
| sub_prd_cd | 역할(semi_role) | sub_prd_qty | disp_seq | min/max/incr | note |
|---|---|---|---|---|---|
| PRD_000307 | 표지(SEMI_ROLE.02) | 1 | 1 | 1/1/- | 표지=아트250+무광코팅(MAT_000250)·1권고정 |
| PRD_000308 | 내지(SEMI_ROLE.01) | 1 | 2 | -/-/- | 내지=무지(무지내지 MAT_000261)·중철제본·min/max 미설정=[[rule/gaps.md#gap-stn-muji-inner-minmax]] |

#### 사이즈+판형+도수+공정 (부모 레벨·현재 DB)

<!-- transcribed-by: RAILWAY_DB SELECT t_prd_product_sizes/plate_sizes/print_options/processes where prd_cd=PRD_000181 and del_yn=N @ 2026-07-03 -->
| 축 | 코드 | 라벨 | dflt/mand | 축노드 존재 |
|---|---|---|---|---|
| size | SIZ_000196 | A6(105x148mm) | Y | O(has_size 배선·Stage C2) |
| plate | SIZ_000382 | 216x154(표지파일사양) | Y | O(has_plate_size 배선·Stage C2) |
| print_option | POPT_000001 | 단면(front CMYK4도/back 인쇄안함) | Y(dflt) | O |
| process | PROC_000018 | 중철제본 | Y(mand) | O(has_process 배선) |
| process | PROC_000015 | 무광라미네이팅 | N(opt·disp5) | O(has_process 배선) |

#### 수량 규칙 + 가격공식 바인딩

<!-- transcribed-by: RAILWAY_DB SELECT t_prd_products/price_formulas/component_prices where prd_cd=PRD_000181 @ 2026-07-03 -->
| 원천 | 값 |
|---|---|
| 상품 수량 | min 4 / max 500 / incr 4 (QTY_UNIT.03·4권 묶음) |
| t_prd_product_bundle_qtys | 0행(수량 그릇=상품 min/max) |
| 가격공식 | PRF_STN_JUNGCHEOL (apply_bgn 2026-06-06·"중철노트 완제품가") |
| 완제품가 구성요소 | COMP_STN_JUNGCHEOL·use_dims=[siz_cd,min_qty]·**단가행 1셀(sparse)** |

`priced_by` → [[formula/stationery-formulas.md#formula-PRF_STN_JUNGCHEOL]](고정가·부모 all-in·has_component
COMP_STN_JUNGCHEOL). 값 계산은 `evaluate_set_price`(D-18 경계). 카테고리(CAT_000008 문구·CAT_000124 노트)·사이즈
SIZ_000196·판형 SIZ_000382 축 노드는 mint(C1)→has_size·has_plate_size 배선(Stage C2·전사표 정합).
