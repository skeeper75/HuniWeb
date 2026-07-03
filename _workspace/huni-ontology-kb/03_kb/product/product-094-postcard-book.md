---
id: product-094-postcard-book
type: product
anchor: t_prd_products/PRD_000094
badge: verified
sources:
  - {source_file: "RAILWAY_DB live (railway·읽기전용 SELECT)", source_locator: "테이블:t_prd_products 키:PRD_000094 (del_yn=N·prd_typ_cd=PRD_TYPE.01)", captured_at: "live 2026-07-03", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-set-series.md", source_locator: "§1 인벤토리(094 엽서북·고정가형 부모 all-in)·§3.10·§4 양면표기·§5", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-set}
  - {source_file: "_workspace/huni-set-product/05_gate/set-price-full-diagnosis-260702.md", source_locator: "§3 엽서북 엔진골든 100부 450,000(simulate_set 실호출)", captured_at: "2026-07-03", badge: verified, src_id: SR-23-setdiag}
relations:
  - {rel: in_category, target: category-CAT_000308, note: "엽서북(main·live)"}
  - {rel: has_process, target: process-PROC_000076, note: "수축포장(옵션·live PRD_000094)"}
  - {rel: has_member, target: product-095-postcard-book-inner, note: "내지(SEMI_ROLE.01·몽블랑240·페이지20~30/+10)"}
  - {rel: has_member, target: product-096-postcard-book-cover, note: "표지(SEMI_ROLE.02·스노우300·1권고정)"}
  - {rel: has_size, target: size-SIZ_000003, note: "100x150(dflt)"}
  - {rel: has_size, target: size-SIZ_000004, note: "135x135"}
  - {rel: has_print_option, target: printopt-POPT_000001, note: "단면 칼라"}
  - {rel: has_print_option, target: printopt-POPT_000002, note: "양면 칼라(dflt)"}
  - {rel: has_process, target: process-PROC_000022, qualifier: mandatory, note: "떡제본(제본 공정·mand)"}
  - {rel: has_qty_rule, target: qty-094}
  - {rel: priced_by, target: formula-PRF_PCB_FIXED, note: "고정가형·부모 all-in"}
  - {rel: has_option_group, target: optgroup-094-pages}
props:
  prd_typ_cd: "PRD_TYPE.01"
  archetype: "고정가형(부모 all-in)"
  min_qty: 2
  max_qty: 10000
  qty_incr: 1
  qty_unit_typ_cd: "QTY_UNIT.03"
  file_upload_yn: "Y"
  editor_yn: "N"
  구분: "엽서북(셋트 완제품·t_prd_product_sets 부모)"
standards: {schema_org: "Product", xjdf: "Product(셋트·BindingIntent)", config_ont: "assembly"}
answers_cq: ["엽서북 구성·가격 축(셋트 완제품)", "엽서로 만든 책(셋트 조립 상품)"]
tags: ["#셋트", "#엽서북", "#고정가형", "#부모all-in"]
updated: 2026-07-03
---

# 엽서북 (product-094-postcard-book)

엽서북(PRD_000094)은 **셋트 완제품**(prd_typ_cd=PRD_TYPE.01·`t_prd_product_sets`에 부모로 등록된 상품·
CLAUDE.md §1 [HARD]). 반제품 구성원 **내지**([[product-095-postcard-book-inner]]·SEMI_ROLE.01)와
**표지**([[product-096-postcard-book-cover]]·SEMI_ROLE.02)를 조립한다. 가격은 단일 `evaluate_price`가
아니라 **`evaluate_set_price`**(pricing.py:718 — 구성원별 evaluate_price 합산 + 셋트 부모공식 + 할인)로
계산하며, 부모공식 [[formula/set-formulas#formula-PRF_PCB_FIXED]](PRF_PCB_FIXED·고정가형)이 사이즈·면·
페이지·수량 옵션 차원을 요구한다.

- **정체**: 셋트 = 부품 조립(pack §3.1·§3.12·R13 has_member). 부모 등록 여부 = 셋트 완제품 판정 기준([HARD]).
- **가격아키타입 = 고정가형(부모 all-in)**: 부모공식 PRF_PCB_FIXED가 옵션 차원(사이즈/면/페이지/수량)을 verbatim
  468셀로 all-in 계산하고 **구성원(095/096) 기여 = 0**(자식 분리 금지·pack §3.10·[[postcard-book-sim-convergence-260702]]).
  값 계산은 `evaluate_set_price` 권위(D-18 경계) — 온톨로지는 priced_by·has_member·아키타입 선언까지.
- **★양면 정직 표기(pack §4·T-5·badge≠defect)**: 이 셋트의 **가격 사실 = 엔진 골든 100부 450,000원(PRICE≠0)**
  이다(아래 골든 전사표). webadmin **화면 0원**은 가격 결함이 아니라 **셋트 UI가 set_selections에 siz_cd를
  미전파하는 코드 C트랙**(`DEV-REQUEST-set-sim-sizcd-260702`·백필 원천=내지[HARD])이므로 "화면 0원 = 견적
  결함"으로 넣지 않는다 → [[rule/gaps#gap-set-simulate-sizcd]]. 그래서 이 노드는 defect 양면 노드가 아니다.
- **끊긴 축(정직 선언)**: 카테고리(CAT_000308 엽서북·CAT_000124 노트) 축 노드가 KB 미민팅이라 `in_category`
  엣지 미배선(아래 전사표 권위·needs_axis 반환). 사이즈 SIZ_000124(150x100)도 축 노드 미민팅(대표 003/004만 배선).

## 차원·구성원·연결 전사표 (권위 = 라이브 DB·읽기전용 SELECT 전사)

> ★latest-wins: live-snapshot 20260702_1119은 07-02 수량·구성원 롤백(menu-first 데이터-only 6후보 전부
> ROLLBACK 실측 NO-GO·[[postcard-book-sim-convergence-260702]]) **前** 상태라 이 4상품 구성에 STALE(pack §4·T-3).
> 아래는 07-03 현재 DB 재확인값(결정론 SELECT 전사·손전사 아님).

#### 셋트 구성원 (has_member·R13)

<!-- transcribed-by: RAILWAY_DB SELECT t_prd_product_sets where prd_cd=PRD_000094 and del_yn=N @ 2026-07-03 -->
| sub_prd_cd | 역할(semi_role) | sub_prd_qty | disp_seq | min/max/incr | note |
|---|---|---|---|---|---|
| PRD_000095 | 내지(SEMI_ROLE.01) | 1 | 1 | 20/30/10 | 내지=몽블랑240·페이지20~30/+10 |
| PRD_000096 | 표지(SEMI_ROLE.02) | 1 | 2 | - | 표지=스노우300·1권고정 |

내지 member의 min/max/incr(20/30/10) = **페이지 가변**(db_comment "구성원 개수"이나 실제=페이지수 오등록·
load-bearing·pack §3.4 [HARD]·[[set-membrane-1member-taku1-target-model-260703]]). page_rule(20/30/10)과 정합.

#### 사이즈+도수+공정 (부모 레벨·현재 DB)

<!-- transcribed-by: RAILWAY_DB SELECT t_prd_product_sizes/print_options/processes where prd_cd=PRD_000094 and del_yn=N @ 2026-07-03 -->
| 축 | 코드 | 라벨 | dflt/mand | 축노드 존재 |
|---|---|---|---|---|
| size | SIZ_000003 | 100x150 | Y | O(has_size 배선) |
| size | SIZ_000124 | 150x100 | Y | ✗(미민팅·needs_axis) |
| size | SIZ_000004 | 135x135 | Y | O(has_size 배선) |
| print_option | POPT_000002 | 양면 | Y(dflt) | O |
| print_option | POPT_000001 | 단면 | N | O |
| process | PROC_000022 | 떡제본 | Y(mand) | O(has_process 배선) |
| process | PROC_000076 | 수축포장 | Y(mand) | ✗(미민팅·needs_axis) |

자재(용지)는 07-02 재설계로 **부모→구성원 멤버 이관**(094 부모 자재 0행·내지 몽블랑240→095·표지 스노우300→096).
판형은 부모 094 활성 0행(전 plate del_yn=Y). 사이즈 SIZ_000124·공정 PROC_000076은 축 노드 미민팅이라 전사표가
권위(needs_axis 반환).

#### 수량 규칙 + 가격공식 바인딩

<!-- transcribed-by: RAILWAY_DB SELECT t_prd_products/page_rules/price_formulas where prd_cd=PRD_000094 @ 2026-07-03 -->
| 원천 | 값 |
|---|---|
| 상품 수량 | min 2 / max 10000 / incr 1 (QTY_UNIT.03) |
| page_rule | page 20 / 30 / +10 |
| t_prd_product_bundle_qtys | 0행(수량 그릇=상품/page_rule) |
| 가격공식 | PRF_PCB_FIXED (2026-06-01 apply·"엽서북→사이즈/면/페이지/수량") |

#### 셋트 골든 (권위 = simulate_set 실호출)

<!-- transcribed-by: pack-set-series.md §1/§3.10 <- set-price-full-diagnosis-260702.md §3 (simulate_set 실호출) @ 2026-07-03 -->
| 조건 | 골든 100부 |
|---|---|
| opt OPV_000491(20P) + siz SIZ_000003(100x150) | 450,000 |

`priced_by` → [[formula/set-formulas#formula-PRF_PCB_FIXED]](고정가·부모 all-in·구성원 20P/30P body 매칭
COMP_PCB_S1/S2). 값 계산은 `evaluate_set_price`(D-18 경계). 이 셋트 전용 하위 노드(수량규칙·페이지수 옵션그룹)는
[[product-094-postcard-book-nodes]] 참조.
