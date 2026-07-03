---
id: product-097-tteok-memo
type: product
anchor: t_prd_products/PRD_000097
badge: verified
sources:
  - {source_file: "RAILWAY_DB live (railway·읽기전용 SELECT)", source_locator: "테이블:t_prd_products 키:PRD_000097 (del_yn=N·prd_typ_cd=PRD_TYPE.01)", captured_at: "live 2026-07-03", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-set-series.md", source_locator: "§1 인벤토리(097 떡메모지·고정가형 부모 all-in)·§3.4 묶음수·§4 양면표기·§5", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-set}
  - {source_file: "_workspace/huni-set-product/05_gate/set-price-full-diagnosis-260702.md", source_locator: "§3 떡메모지 엔진골든 100부 135,000(bdl_qty=50·simulate_set 실호출)", captured_at: "2026-07-03", badge: verified, src_id: SR-23-setdiag}
relations:
  - {rel: in_category, target: category-CAT_000124, note: "노트(super·live main_cat_yn=N)"}
  - {rel: in_category, target: category-CAT_000008, note: "문구(main·live)"}
  - {rel: uses_material, target: material-MAT_000073, note: "백색모조지 120g(부모 자재 USAGE.01·dflt·live PRD_000097)"}
  - {rel: has_size, target: size-SIZ_000266, note: "70x120(live PRD_000097)"}
  - {rel: has_member, target: product-098-tteok-memo-inner, note: "내지(SEMI_ROLE.01·백모조120·묶음 50/100장)"}
  - {rel: has_print_option, target: printopt-POPT_000001, note: "단면 칼라"}
  - {rel: has_process, target: process-PROC_000022, note: "떡제본(mand_proc_yn=N·snapshot)"}
  - {rel: has_qty_rule, target: qty-097}
  - {rel: priced_by, target: formula-PRF_TTEOKME_FIXED, note: "고정가형·부모 all-in"}
props:
  prd_typ_cd: "PRD_TYPE.01"
  archetype: "고정가형(부모 all-in)"
  min_qty: 6
  max_qty: 1000
  qty_incr: 3
  qty_unit_typ_cd: "QTY_UNIT.03"
  file_upload_yn: "Y"
  editor_yn: "Y"
  구분: "떡메모지(셋트 완제품·t_prd_product_sets 부모)"
standards: {schema_org: "Product", xjdf: "Product(셋트·BindingIntent 떡제본)", config_ont: "assembly"}
answers_cq: ["떡메모지 구성·가격 축(셋트 완제품)", "떡제본 메모지(묶음 50/100장)"]
tags: ["#셋트", "#떡메모지", "#고정가형", "#부모all-in"]
updated: 2026-07-03
---

# 떡메모지 (product-097-tteok-memo)

떡메모지(PRD_000097)는 **셋트 완제품**(prd_typ_cd=PRD_TYPE.01·`t_prd_product_sets` 부모). 반제품 구성원
**내지**([[product-098-tteok-memo-inner]]·SEMI_ROLE.01·백모조120)를 떡제본으로 묶는다. 가격은
**`evaluate_set_price`**(구성원 합산 + 부모공식 + 할인)로, 부모공식
[[formula/set-formulas#formula-PRF_TTEOKME_FIXED]](PRF_TTEOKME_FIXED·고정가형)이 사이즈·권당장수(bdl_qty
50/100)·수량 차원을 요구한다.

- **가격아키타입 = 고정가형(부모 all-in)**: 부모공식이 옵션 차원을 all-in 계산하고 구성원(098) 기여 = 0
  (pack §3.10). 값 계산은 `evaluate_set_price` 권위(D-18).
- **★양면 정직 표기(pack §4·T-5·badge≠defect)**: 가격 사실 = **엔진 골든 100부 135,000원(bdl_qty=50·PRICE≠0)**.
  webadmin 화면 0원은 셋트 UI siz_cd 미전파 **코드 C트랙**(가격 결함 아님) → [[rule/gaps#gap-set-simulate-sizcd]].
  defect 양면 노드 아님.
- **묶음수 = 셋트 특유 수량축**: 097 = bundle_qtys(50 dflt / 100장). 내지 페이지 가변형(094)과 달리 묶음 장수로 과금.
- **끊긴 축(정직)**: 카테고리(CAT_000129 떡메모지·CAT_000008 문구·CAT_000124 노트)·상품 사이즈 SIZ_000119(90x90)·
  SIZ_000266(70x120) 축 노드 미민팅 → `in_category` 미배선·전사표 권위·needs_axis 반환.

## 차원·구성원·연결 전사표 (권위 = 라이브 DB·읽기전용 SELECT)

> ★latest-wins: live-snapshot 20260702_1119은 07-02 수량 교정(097 min 3→6) 前이라 STALE(pack §4). 아래는
> 07-03 현재 DB 재확인값(결정론 SELECT 전사).

#### 셋트 구성원 (has_member·R13)

<!-- transcribed-by: RAILWAY_DB SELECT t_prd_product_sets where prd_cd=PRD_000097 and del_yn=N @ 2026-07-03 -->
| sub_prd_cd | 역할(semi_role) | sub_prd_qty | disp_seq | note |
|---|---|---|---|---|
| PRD_000098 | 내지(SEMI_ROLE.01) | 1 | 1 | 내지=백모조120 |

#### 사이즈+도수+공정+자재 (부모 레벨·현재 DB)

<!-- transcribed-by: RAILWAY_DB SELECT t_prd_product_sizes/print_options/processes/materials where prd_cd=PRD_000097 and del_yn=N @ 2026-07-03 -->
| 축 | 코드 | 라벨/usage | 축노드 존재 |
|---|---|---|---|
| size | SIZ_000119 | 90x90 | ✗(미민팅·needs_axis) |
| size | SIZ_000266 | 70x120 | ✗(미민팅·needs_axis) |
| print_option | POPT_000001 | 단면 | O(has_print_option 배선) |
| process | PROC_000022 | 떡제본 | O(has_process 배선) |
| material | MAT_000073 | 백모조 120g (USAGE.01·부모 귀속) | ✗(미민팅·needs_axis) |
| plate_size | SIZ_000499 | 국4절(316x467·내지 판형·output_paper_typ 미기재) | ✗(SIZ_000499 size 노드는 있으나 판형축은 별개·전사표 권위) |

★097은 094와 달리 자재(백모조120 MAT_000073·USAGE.01)가 **부모에 귀속**(구성원 098은 자재 0행). 상품 사이즈
90x90/70x120은 축 노드 미민팅이라 전사표 권위(has_size 미배선). 판형 SIZ_000499(국4절)는 종이류 내지 판형이나
plate 축 노드 미민팅이라 전사표 권위(has_plate_size 미배선).

#### 수량 규칙 + 가격공식 바인딩

<!-- transcribed-by: RAILWAY_DB SELECT t_prd_products/bundle_qtys/page_rules/price_formulas where prd_cd=PRD_000097 @ 2026-07-03 -->
| 원천 | 값 |
|---|---|
| 상품 수량 | min 6 / max 1000 / incr 3 (QTY_UNIT.03) |
| t_prd_product_bundle_qtys | 50(dflt) / 100 장 |
| page_rule | 3 / 3 / +3 |
| 가격공식 | PRF_TTEOKME_FIXED (2026-06-01 apply·round-16 단절2 해소) |

#### 셋트 골든 (권위 = simulate_set 실호출)

<!-- transcribed-by: pack-set-series.md §1/§3.10 <- set-price-full-diagnosis-260702.md §3 (simulate_set 실호출) @ 2026-07-03 -->
| 조건 | 골든 100부 |
|---|---|
| bdl_qty=50 (권당 50장) | 135,000 |

`priced_by` → [[formula/set-formulas#formula-PRF_TTEOKME_FIXED]](고정가·부모 all-in·bdl_qty 50/100 차원).
값 계산은 `evaluate_set_price`(D-18). 이 셋트 전용 하위 노드(수량규칙)는 [[product-097-tteok-memo-nodes]] 참조.
