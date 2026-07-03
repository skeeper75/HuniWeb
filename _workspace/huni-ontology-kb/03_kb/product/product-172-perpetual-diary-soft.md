---
id: product-172-perpetual-diary-soft
type: product
anchor: t_prd_products/PRD_000172
badge: candidate
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000172 (prd_typ_cd=PRD_TYPE.01·del_yn=N·use_yn=Y·min1/max500/incr1·QTY_UNIT.03·file_upload=Y·editor=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "live-snapshot/latest/t_prd_product_sets.csv", source_locator: "테이블:t_prd_product_sets 키:prd_cd=PRD_000172 (sub=293 표지만·disp1·qty1·min/max_cnt 1/1·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-stationery-goods.md", source_locator: "§1.1 문구 셋트 인벤토리(172 소프트커버·표지만·PRF_STN_DIARY_SOFT·sparse 1셀)·§4 sparse 양면표기·§5 SB-1", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-stn}
  - {source_file: "_workspace/huni-ontology-kb/03_kb/formula/stationery-formulas.md", source_locator: "[formula-PRF_STN_DIARY_SOFT] 만년다이어리(소프트커버) 완제품가·has_component COMP_STN_DIARY_SOFT·단가행 1셀", captured_at: "2026-07-03", badge: verified, src_id: SR-okb-stnformula}
relations:
  - {rel: in_category, target: category-CAT_000321, note: "플래너(main_cat_yn=N·live PRD_000172)·축 노드 미민팅(needs_axis)"}
  - {rel: has_member, target: product-293-perpetual-diary-soft-cover, qualifier: {semi_role: "SEMI_ROLE.02", disp_seq: 1, sub_prd_qty: 1, min_cnt: 1, max_cnt: 1}, note: "표지만(면지/내지 없음)·아트250+무광코팅"}
  - {rel: has_size, target: size-SIZ_000375, note: "130x190(dflt·live PRD_000172)·축 노드 미민팅(needs_axis)"}
  - {rel: has_print_option, target: printopt-POPT_000001, note: "단면(front CMYK 4도 CLR_000005·back 인쇄안함 CLR_000001·dflt·live PRD_000172). ★172만 인쇄옵션 실재(173/174/175 0행)"}
  - {rel: has_process, target: process-PROC_000015, note: "무광라미네이팅(옵션·non-mand·disp5·live PRD_000172)"}
  - {rel: has_plate_size, target: plate-SIZ_000251, note: "표지파일사양(300x214·dflt·live PRD_000172 plate)·축 노드 미민팅(needs_axis)"}
  - {rel: priced_by, target: formula-PRF_STN_DIARY_SOFT, note: "셋트 부모공식(고정가형·완제품가). evaluate_set_price=구성원별 evaluate_price 합산+이 부모공식+할인(pricing.py:718)"}
  - {rel: references, target: gap-stn-sparse-grid, note: "완제품가 COMP_STN_DIARY_SOFT 단가행 1셀(등록 사이즈 SIZ_000375뿐)·등록=선택가능 사이즈는 PRICE≠0·미등록(off-grid) 사이즈만 견적0·수량은 단가행 min_qty=1 단일밴드로 전량 커버(grid 확장 시 셀 충전 필요)"}
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
  구분: "만년다이어리(소프트커버)·셋트 완제품·표지만"
standards: {schema_org: "Product", xjdf: "Product(만년다이어리 assembly)", config_ont: "assembly / component type"}
answers_cq: ["만년다이어리(소프트커버) 구성·가격 축(셋트 완제품)", "표지만 조립 다이어리"]
tags: ["#셋트", "#문구", "#만년다이어리", "#고정가형", "#sparse"]
updated: 2026-07-03
---

# 만년다이어리(소프트커버) (product-172-perpetual-diary-soft)

만년다이어리(소프트커버)(PRD_000172)는 **셋트 완제품**(prd_typ_cd=PRD_TYPE.01·`t_prd_product_sets` 부모
등록 = 셋트 완제품 유일 기준·CLAUDE.md §1 [HARD]). 구성원은 **표지 1멤버뿐**([[product-293-perpetual-diary-soft-cover]]·
SEMI_ROLE.02·면지/내지 없음·pack §1.1·§0.1 5특성 5번). 가격은 단일 `evaluate_price`가 아니라
**`evaluate_set_price`**(구성원별 evaluate_price 합산 + 셋트 부모공식
[[formula/stationery-formulas#formula-PRF_STN_DIARY_SOFT]] + 할인·pricing.py:718)로 계산한다(값 계산=엔진 권위·D-18).

- **정체·구조**: pack §3.1/§3.12(FRESH) + live `t_prd_product_sets` 실측(172→293 표지만·min/max_cnt 1/1=고정 1권).
  set-series 094/097/100 고정가형 동형(부모 all-in).
- **★가격 sparse(pack §4·T-9·badge=candidate)**: 부모공식 PRF_STN_DIARY_SOFT는 존재하고 완제품가 구성요소
  COMP_STN_DIARY_SOFT의 단가행은 **등록 사이즈 1셀**(SIZ_000375=130x190)만 채워진 sparse grid다.
  **등록=선택가능 사이즈는 PRICE≠0**(라이브 simulate 실증)이고 **미등록(off-grid) 사이즈만 견적0**이며,
  수량은 단가행 min_qty=1 단일밴드로 전량 선형 커버된다. 즉 grid가 sparse(등록 사이즈 수가 적음)일 뿐
  "공식 존재 ≠ 가격 완성"은 등록 외 사이즈 확장에 한정된 이야기 → badge=🟡 candidate. [[rule/gaps#gap-stn-sparse-grid]] 라우팅.
- **인쇄옵션 실재(★172 특유)**: 만년다이어리 4종 중 **172만 인쇄옵션 1행**(POPT_000001 단면·CMYK 4도/인쇄안함·dflt).
  173/174/175는 인쇄옵션 0행(live 실측). 후가공=무광라미네이팅(PROC_000015·옵션).
- **가격 경계(D-18)**: 이 노드는 has_member·priced_by·아키타입 선언까지만. 셋트 이중합산 방지도 evaluate_set_price 소관.
- **끊긴 축(정직 선언·needs_axis)**: 카테고리 CAT_000321(플래너)·사이즈 SIZ_000375(130x190)·판형 SIZ_000251(표지파일사양)
  축 노드가 KB 미민팅 → 해당 엣지는 아래 전사표가 권위(needs_axis 반환).

## 차원·구성원·연결 전사표 (권위 = 라이브 스냅샷 awk 전사)

#### 셋트 구성원 (has_member·R13)

<!-- transcribed-by: awk t_prd_product_sets from live-snapshot/latest (snap_20260702_1119) prd_cd=PRD_000172 del_yn=N @ 2026-07-03 -->
| sub_prd_cd | 역할(semi_role) | sub_prd_qty | disp_seq | min/max_cnt | note |
|---|---|---|---|---|---|
| PRD_000293 | 표지(SEMI_ROLE.02) | 1 | 1 | 1/1 | 표지만(면지·내지 없음)·아트250+무광코팅 |

#### 부모 레벨 차원 (현재 DB)

<!-- transcribed-by: awk t_prd_product_sizes/print_options/processes/plate_sizes from live-snapshot/latest prd_cd=PRD_000172 del_yn=N @ 2026-07-03 -->
| 축 | 코드 | 라벨 | dflt/mand | 축노드 존재 |
|---|---|---|---|---|
| size | SIZ_000375 | 130x190 | Y | ✗(미민팅·needs_axis) |
| print_option | POPT_000001 | 단면(CMYK 4도/인쇄안함) | Y(dflt) | O(has_print_option 배선) |
| process | PROC_000015 | 무광라미네이팅 | N(옵션) | O(has_process 배선) |
| plate_size | SIZ_000251 | 300x214(표지파일사양) | Y | ✗(미민팅·needs_axis) |

자재(용지)는 부모 172 활성 0행 → 표지 멤버 293(MAT_000250 아트250+무광코팅·USAGE.02)에 귀속.

#### 수량 규칙 + 가격공식 바인딩

<!-- transcribed-by: awk t_prd_products/price_formulas + t_prc_component_prices from live-snapshot/latest prd_cd=PRD_000172 @ 2026-07-03 -->
| 원천 | 값 |
|---|---|
| 상품 수량 | min 1 / max 500 / incr 1 (QTY_UNIT.03) |
| 가격공식 | PRF_STN_DIARY_SOFT (2026-06-06 apply·"만년다이어리 소프트커버 완제품가") |
| COMP_STN_DIARY_SOFT 단가행 | 1셀(SIZ_000375·sparse)·등록 사이즈 PRICE≠0·off-grid만 견적0·수량 min_qty=1 단일밴드 전량 커버([[rule/gaps#gap-stn-sparse-grid]]) |

`priced_by` → [[formula/stationery-formulas#formula-PRF_STN_DIARY_SOFT]](고정가형·부모 all-in·COMP_STN_DIARY_SOFT).
값 계산은 `evaluate_set_price`(D-18 경계).
</content>
