---
id: product-173-perpetual-diary-hard
type: product
anchor: t_prd_products/PRD_000173
badge: candidate
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000173 (prd_typ_cd=PRD_TYPE.01·del_yn=N·use_yn=Y·min1/max500/incr1·QTY_UNIT.03·file_upload=Y·editor=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "live-snapshot/latest/t_prd_product_sets.csv", source_locator: "테이블:t_prd_product_sets 키:prd_cd=PRD_000173 (sub=294 표지·disp1 / 295 면지·disp2·각 qty1·min/max_cnt 1/1·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-stationery-goods.md", source_locator: "§1.1 문구 셋트 인벤토리(173 하드커버·표지+면지·PRF_STN_DIARY_HARD·단가행 1셀 130x190=12,000)·§4 sparse·§5 SB-1", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-stn}
  - {source_file: "_workspace/huni-ontology-kb/03_kb/formula/stationery-formulas.md", source_locator: "[formula-PRF_STN_DIARY_HARD] 만년다이어리(하드커버) 완제품가·has_component COMP_STN_DIARY_HARD·단가행 1셀", captured_at: "2026-07-03", badge: verified, src_id: SR-okb-stnformula}
relations:
  - {rel: in_category, target: category-CAT_000321, note: "플래너(main_cat_yn=N·live PRD_000173)·축 노드 미민팅(needs_axis)"}
  - {rel: has_member, target: product-294-perpetual-diary-hard-cover, qualifier: {semi_role: "SEMI_ROLE.02", disp_seq: 1, sub_prd_qty: 1, min_cnt: 1, max_cnt: 1}, note: "표지·아트250+무광코팅"}
  - {rel: has_member, target: product-295-perpetual-diary-hard-membrane, qualifier: {semi_role: "SEMI_ROLE.03", disp_seq: 2, sub_prd_qty: 1, min_cnt: 1, max_cnt: 1}, note: "면지(기본 1종·무가격·자재 0행)"}
  - {rel: has_size, target: size-SIZ_000375, note: "130x190(dflt·live PRD_000173)·축 노드 미민팅(needs_axis)"}
  - {rel: has_process, target: process-PROC_000023, qualifier: mandatory, note: "하드커버무선제본(제본 공정·mand·live PRD_000173)"}
  - {rel: has_process, target: process-PROC_000076, note: "수축포장(옵션·non-mand·live PRD_000173)"}
  - {rel: has_process, target: process-PROC_000015, note: "무광라미네이팅(옵션·non-mand·disp5·live PRD_000173)"}
  - {rel: has_plate_size, target: plate-SIZ_000181, note: "표지파일사양(426x303·dflt·live PRD_000173 plate)·축 노드 미민팅(needs_axis)"}
  - {rel: priced_by, target: formula-PRF_STN_DIARY_HARD, note: "셋트 부모공식(고정가형·완제품가). evaluate_set_price=구성원별 evaluate_price 합산+이 부모공식+할인(pricing.py:718)"}
  - {rel: references, target: gap-stn-sparse-grid, note: "완제품가 COMP_STN_DIARY_HARD 단가행 1셀(등록 사이즈 SIZ_000375=130x190=12,000)·등록=선택가능 사이즈는 PRICE≠0·미등록(off-grid) 사이즈만 견적0·수량은 단가행 min_qty=1 단일밴드로 전량 커버"}
props:
  prd_typ_cd: "PRD_TYPE.01"
  role: "셋트 완제품(t_prd_product_sets 부모)"
  archetype: "고정가형(완제품가·부모 all-in·evaluate_set_price)"
  min_qty: 1
  max_qty: 500
  qty_incr: 1
  qty_unit_typ_cd: "QTY_UNIT.03"
  file_upload_yn: "Y"
  editor_yn: "N"
  단가행: "1셀(sparse·SIZ_000375만)"
  구분: "만년다이어리(하드커버)·셋트 완제품·표지+면지"
standards: {schema_org: "Product", xjdf: "Product(만년다이어리 assembly·BindingIntent)", config_ont: "assembly / component type"}
answers_cq: ["만년다이어리(하드커버) 구성·가격 축(셋트 완제품)", "표지+면지 조립 다이어리"]
tags: ["#셋트", "#문구", "#만년다이어리", "#하드커버", "#고정가형", "#sparse"]
updated: 2026-07-03
---

# 만년다이어리(하드커버) (product-173-perpetual-diary-hard)

만년다이어리(하드커버)(PRD_000173)는 **셋트 완제품**(prd_typ_cd=PRD_TYPE.01·`t_prd_product_sets` 부모
등록·[HARD]). **표지(294)+면지(295)** 반제품 조립이다([[product-294-perpetual-diary-hard-cover]]·SEMI_ROLE.02 /
[[product-295-perpetual-diary-hard-membrane]]·SEMI_ROLE.03). 가격은 **`evaluate_set_price`**(구성원별
evaluate_price 합산 + 셋트 부모공식 [[formula/stationery-formulas#formula-PRF_STN_DIARY_HARD]] + 할인·pricing.py:718).

- **정체·구조**: pack §3.1/§3.12(FRESH) + live `t_prd_product_sets`(173→294 표지·295 면지·각 min/max_cnt 1/1).
  하드커버는 제본공정 **하드커버무선제본(PROC_000023·mand)**이 부모에 결합(070/072 하드커버 계열 동형).
- **★가격 sparse(pack §4·T-9·badge=candidate)**: COMP_STN_DIARY_HARD 단가행은 **등록 사이즈 1셀**(SIZ_000375=130x190=12,000·
  pack §1.1)만 채워진 sparse grid다. **등록=선택가능 사이즈는 PRICE≠0**(130x190=12,000 라이브 simulate 실증)이고 **미등록(off-grid)
  사이즈만 견적0**이며, 수량은 단가행 min_qty=1 단일밴드로 전량 선형 커버(예 100권=1,200,000). "공식 존재≠가격 완성"은 등록 외
  사이즈 확장 한정 → badge=🟡. [[rule/gaps#gap-stn-sparse-grid]] 라우팅.
- **면지=무가격**: 295 면지 자재 0행·자체 공식 없음 → 기여 0(무가격·074 하드커버책자 면지 동형). 삭제 금지(선택지 보존).
- **인쇄옵션 0행**: 173은 인쇄옵션 미등록(172만 실재). 표지 인쇄는 표지 멤버/파일사양(plate SIZ_000181 표지파일사양) 경유.
- **가격 경계(D-18)**: has_member·priced_by·아키타입 선언까지. 이중합산 방지=evaluate_set_price 소관.
- **끊긴 축(needs_axis)**: 카테고리 CAT_000321·사이즈 SIZ_000375·판형 SIZ_000181 축 노드 미민팅 → 전사표 권위.

## 차원·구성원·연결 전사표 (권위 = 라이브 스냅샷 awk 전사)

#### 셋트 구성원 (has_member·R13)

<!-- transcribed-by: awk t_prd_product_sets from live-snapshot/latest (snap_20260702_1119) prd_cd=PRD_000173 del_yn=N @ 2026-07-03 -->
| sub_prd_cd | 역할(semi_role) | sub_prd_qty | disp_seq | min/max_cnt | note |
|---|---|---|---|---|---|
| PRD_000294 | 표지(SEMI_ROLE.02) | 1 | 1 | 1/1 | 표지·아트250+무광코팅 |
| PRD_000295 | 면지(SEMI_ROLE.03) | 1 | 2 | 1/1 | 면지(기본 1종·무가격·자재 0행) |

#### 부모 레벨 차원 (현재 DB)

<!-- transcribed-by: awk t_prd_product_sizes/print_options/processes/plate_sizes from live-snapshot/latest prd_cd=PRD_000173 del_yn=N @ 2026-07-03 -->
| 축 | 코드 | 라벨 | dflt/mand | 축노드 존재 |
|---|---|---|---|---|
| size | SIZ_000375 | 130x190 | Y | ✗(미민팅·needs_axis) |
| process | PROC_000023 | 하드커버무선제본 | Y(mand) | O(has_process 배선) |
| process | PROC_000076 | 수축포장 | N(옵션) | O(has_process 배선) |
| process | PROC_000015 | 무광라미네이팅 | N(옵션) | O(has_process 배선) |
| plate_size | SIZ_000181 | 426x303(표지파일사양) | Y | ✗(미민팅·needs_axis) |
| print_option | — | (0행·인쇄옵션 미등록) | — | — |

자재(용지)는 부모 173 활성 0행 → 표지 멤버 294(MAT_000250 아트250+무광코팅·USAGE.02)에 귀속. 면지 295 자재 0행.

#### 수량 규칙 + 가격공식 바인딩

<!-- transcribed-by: awk t_prd_products/price_formulas + t_prc_component_prices from live-snapshot/latest prd_cd=PRD_000173 @ 2026-07-03 -->
| 원천 | 값 |
|---|---|
| 상품 수량 | min 1 / max 500 / incr 1 (QTY_UNIT.03) |
| 가격공식 | PRF_STN_DIARY_HARD (2026-06-06 apply·"만년다이어리 하드커버 완제품가") |
| COMP_STN_DIARY_HARD 단가행 | 1셀(SIZ_000375=130x190=12,000·sparse)·등록 사이즈 PRICE≠0·off-grid만 견적0·수량 min_qty=1 단일밴드 전량 커버([[rule/gaps#gap-stn-sparse-grid]]) |

`priced_by` → [[formula/stationery-formulas#formula-PRF_STN_DIARY_HARD]]. 값 계산=`evaluate_set_price`(D-18).
</content>
