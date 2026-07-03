---
id: product-177-spring-note
type: product
anchor: t_prd_products/PRD_000177
badge: candidate
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000177 (★prd_typ_cd=PRD_TYPE.02 라이브 라벨·del_yn=N·use_yn=Y·min1/max1000/incr1·QTY_UNIT.03·file_upload=Y·editor=Y)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "live-snapshot/latest/t_prd_product_sets.csv", source_locator: "테이블:t_prd_product_sets 키:prd_cd=PRD_000177 (301 표지 disp1·302 내지 무지 disp2·부모 등록=셋트 완제품 SOT)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-stationery-goods.md", source_locator: "§1.1 [★177 분류 conflict]·§3.1 GAP-STN-1·§3.10 아키타입·§4 177 양면·sparse", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-stn}
relations:
  - {rel: in_category, target: category-CAT_000008, note: "문구(main_cat_yn=Y·disp8·live)"}
  - {rel: in_category, target: category-CAT_000124, note: "노트(live)"}
  - {rel: has_member, target: product-301-spring-note-cover, qualifier: {semi_role: "SEMI_ROLE.02", disp_seq: 1, min_cnt: 1, max_cnt: 1}, note: "표지(아트250+무광코팅·1권고정)"}
  - {rel: has_member, target: product-302-spring-note-inner, qualifier: {semi_role: "SEMI_ROLE.01", disp_seq: 2}, note: "내지(무지·현재 인쇄없음·min/max 미설정→gap-stn-muji-inner-minmax·추후 커스텀인쇄 확장)"}
  - {rel: has_size, target: size-SIZ_000170, note: "A5 148x210(dflt·부모 레벨·정션 활성(t_prd_product_sizes del_yn=N)·마스터 논리삭제(t_siz_sizes del_yn=Y 2026-06-17)이나 load-bearing·형제 181 SIZ_000196 동형·live 재실측)"}
  - {rel: has_print_option, target: printopt-POPT_000001, note: "단면 칼라(dflt)"}
  - {rel: has_process, target: process-PROC_000021, qualifier: mandatory, note: "트윈링제본(스프링 mand·live PRD_000177)"}
  - {rel: has_process, target: process-PROC_000076, note: "수축포장(옵션)"}
  - {rel: has_process, target: process-PROC_000015, note: "무광라미네이팅(표지·옵션)"}
  - {rel: has_qty_rule, target: qty-177, note: "스프링노트 수량규칙(min1/max1000/incr1·bundle_qtys 0행·수량 그릇=상품)·축 노드 mint(Stage C1)"}
  - {rel: priced_by, target: formula-PRF_STN_SPRINGNOTE, note: "셋트 부모공식(고정가형·완제품가). evaluate_set_price=구성원 합산+이 부모공식+할인(pricing.py:718)"}
  - {rel: references, target: gap-stn-177-classification, note: "★분류 conflict: prd_typ .02(라이브) vs 셋트 완제품(sets 부모·SOT). 프론트매터 badge=defect 회피(088 선례)·gap 노드로 정직 표기"}
  - {rel: references, target: gap-stn-sparse-grid, note: "완제품가 COMP_STN_SPRINGNOTE 단가행 1셀(등록 사이즈 SIZ_000170=4,500)·등록=선택가능 사이즈는 PRICE≠0·미등록(off-grid) 사이즈만 견적0·수량은 min_qty=1 단일밴드로 전량 커버"}
props:
  prd_typ_cd_live: "PRD_TYPE.02"
  prd_typ_authority: "셋트 완제품(t_prd_product_sets 부모 등록·SOT·product-type-classification-sot)"
  classification_conflict: "gap-stn-177-classification (양면·라이브를 SOT에 맞춰 교정·역방향 금지)"
  role: "셋트 완제품(t_prd_product_sets 부모·SOT) — 라이브 라벨만 .02"
  archetype: "고정가형(부모 all-in·완제품가·evaluate_set_price)"
  min_qty: 1
  max_qty: 1000
  qty_incr: 1
  qty_unit_typ_cd: "QTY_UNIT.03"
  file_upload_yn: "Y"
  editor_yn: "Y"
  단가행: "1셀(sparse·등록 사이즈 SIZ_000170 PRICE≠0(=4,500)·off-grid만 견적0·수량 min_qty=1 단일밴드 전량 커버)"
  구분: "스프링노트(셋트 완제품·표지+무지 내지 조립·★분류 conflict)"
standards: {schema_org: "Product", xjdf: "Product(스프링노트 assembly)", config_ont: "assembly"}
answers_cq: ["스프링노트 구성·가격 축(셋트 완제품)", "스프링노트 셋트 조립 상품", "177 분류 conflict 질의"]
tags: ["#셋트", "#문구", "#노트", "#고정가형", "#sparse", "#분류conflict"]
updated: 2026-07-03
---

# 스프링노트 (product-177-spring-note)

스프링노트(PRD_000177)는 **셋트 완제품**(`t_prd_product_sets` 부모 등록 = 셋트 완제품 유일 기준·CLAUDE.md §1
[HARD]). **표지([[product-301-spring-note-cover]]·SEMI_ROLE.02)+무지 내지([[product-302-spring-note-inner]]·
SEMI_ROLE.01)** 반제품 조립이다. 가격은 **`evaluate_set_price`**(구성원 합산 + 셋트 부모공식
[[formula/stationery-formulas#formula-PRF_STN_SPRINGNOTE]] + 할인·pricing.py:718)로 계산한다(값=엔진 권위·D-18).

- **★분류 conflict(pack §1.1·§3.1·양면·badge=defect 프론트매터 회피)**: 라이브 라벨 prd_typ_cd=**PRD_TYPE.02(반제품)**
  이나 SOT(셋트 완제품=`t_prd_product_sets` 부모 등록)상 **셋트 완제품이 정답**이다(라이브를 SOT에 맞춰 교정·역방향
  금지). 프론트매터 badge=defect를 쓰지 않고(088 선례) props(prd_typ_cd_live / prd_typ_authority)로 양면을 기록하고
  gap 노드 [[rule/gaps#gap-stn-177-classification]]로 라우팅한다. prd_typ 정정은 dbmap/실무진 승인 후.
- **가격아키타입 = 고정가형(부모 all-in)**: 부모공식 PRF_STN_SPRINGNOTE가 `[siz_cd,min_qty]` 차원으로 완제품가 반환.
  set-series 094/097 동형. 값 계산은 KB 밖(D-18).
- **★sparse 정직 표기(pack §4·T-9·badge=candidate)**: 완제품가 구성요소(COMP_STN_SPRINGNOTE) 단가행은 **등록 사이즈 1셀**
  (SIZ_000170 A5)만 채워진 sparse grid다. **등록=선택가능 사이즈는 PRICE≠0**(A5=4,500 라이브 simulate 실증)이고
  **미등록(off-grid) 사이즈만 견적0**이며, 수량은 min_qty=1 단일밴드로 전량 선형 커버. "공식 존재≠가격 완성"은 등록 외
  사이즈 확장 한정·badge=candidate → [[rule/gaps#gap-stn-sparse-grid]].
- **축 배선(Stage C2)**: qty-177(has_qty_rule) 축 노드 mint(C1)→배선 완료. 판형(표지 파일사양 SIZ_000171·output_paper_typ
  공란)만 plate 축 미민팅 → 아래 전사표 권위.

## 셋트 구성·차원 전사표 (권위 = 라이브 스냅샷 awk 전사)

<!-- transcribed-by: awk t_prd_product_sets from live-snapshot/latest (snap_20260702_1119) prd_cd=PRD_000177 @ 2026-07-03 -->

#### 셋트 구성원 (has_member·R13)
| sub_prd_cd | 역할(semi_role) | disp_seq | min_cnt/max_cnt/incr | note |
|---|---|---|---|---|
| PRD_000301 | 표지(SEMI_ROLE.02) | 1 | 1/1/- | 아트250+무광코팅·1권고정 |
| PRD_000302 | 내지(SEMI_ROLE.01) | 2 | -/-/- | 무지·현재 인쇄없음·min/max 미설정(gap-stn-muji-inner-minmax) |

#### 사이즈·도수·공정·카테고리 (부모 레벨)
<!-- transcribed-by: awk t_prd_product_sizes+print_options+processes+categories from live-snapshot/latest (snap_20260702_1119) prd_cd=PRD_000177 @ 2026-07-03 -->
| 축 | 코드 | 라벨 | dflt/mand | 축노드 |
|---|---|---|---|---|
| size | SIZ_000170 | A5 148x210 | Y | O(has_size) |
| print_option | POPT_000001 | 단면 | Y(dflt) | O(has_print_option) |
| process | PROC_000021 | 트윈링제본 | Y(mand) | O(has_process·mand) |
| process | PROC_000076 | 수축포장 | N(opt) | O(has_process) |
| process | PROC_000015 | 무광라미네이팅 | N(opt) | O(has_process) |
| category | CAT_000008 | 문구 | main Y·disp8 | O(in_category) |
| category | CAT_000124 | 노트 | N | O(in_category) |

#### 판형(파일사양·비표준→축 미민팅)
<!-- transcribed-by: awk t_prd_product_plate_sizes from live-snapshot/latest (snap_20260702_1119) prd_cd=PRD_000177 @ 2026-07-03 -->
| siz_cd | 규격 | note | output_paper_typ |
|---|---|---|---|
| SIZ_000171 | 152x214 | 표지파일사양 | (공란) |

판형 행은 표지 **파일사양**(output_paper_typ 공란)이라 표준 출력용지 plate 노드 아님 → `has_plate_size` 미배선(needs_axis).

#### 수량 규칙 + 가격공식 바인딩
<!-- transcribed-by: awk t_prd_products+t_prd_product_price_formulas from live-snapshot/latest (snap_20260702_1119) prd_cd=PRD_000177 @ 2026-07-03 -->
| 원천 | 값 |
|---|---|
| 상품 수량 | min 1 / max 1000 / incr 1 (QTY_UNIT.03) |
| t_prd_product_bundle_qtys | 0행(수량 그릇=상품) |
| 가격공식 | PRF_STN_SPRINGNOTE (2026-06-06 apply·고정가형·단가행 1셀 sparse) |

`priced_by` → [[formula/stationery-formulas#formula-PRF_STN_SPRINGNOTE]](고정가·부모 all-in). 값 계산은
`evaluate_set_price`(D-18 경계).
</content>
