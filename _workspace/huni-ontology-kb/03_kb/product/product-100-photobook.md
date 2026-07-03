---
id: product-100-photobook
type: product
anchor: t_prd_products/PRD_000100
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000100 (prd_typ_cd=PRD_TYPE.01·del_yn=N·editor_yn=Y)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "live-snapshot/latest/t_prd_product_sets.csv", source_locator: "테이블:t_prd_product_sets 부모 키:PRD_000100 (구성원 7행·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-set-series.md", source_locator: "§1 인벤토리(100 포토북 확정 slug·구성원·고정가형)·§3.10·§4 양면표기", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-set}
  - {source_file: "_workspace/huni-set-product/05_gate/set-price-full-diagnosis-260702.md", source_locator: "§3 고정가형 포토북 엔진골든 실호출", captured_at: "2026-07-03", badge: verified, src_id: SR-23-diag}
relations:
  - {rel: uses_material, target: material-MAT_000005, note: "하드커버 표지(USAGE.02·dflt·live PRD_000100)"}
  - {rel: uses_material, target: material-MAT_000006, note: "레더하드커버 표지(USAGE.02·dflt·live PRD_000100)"}
  - {rel: uses_material, target: material-MAT_000007, note: "소프트커버 표지(USAGE.02·dflt·live PRD_000100)"}
  - {rel: uses_material, target: material-MAT_000250, note: "아트250+무광코팅 표지(USAGE.02·dflt·live PRD_000100)"}
  - {rel: uses_material, target: material-MAT_000251, note: "그레이 면지(USAGE.03·무가격·live PRD_000100)"}
  - {rel: has_size, target: size-SIZ_000269, note: "8x8(200x200)·골든 기준(live PRD_000100)"}
  - {rel: has_size, target: size-SIZ_000274, note: "10x10(250x250)(live PRD_000100)"}
  - {rel: priced_by, target: formula-PRF_PHOTOBOOK_FIXED, note: "고정가형 부모 all-in(base24P·evaluate_set_price)"}
  - {rel: has_member, target: product-101-photobook-inner, qualifier: {disp_seq: 1}, note: "내지=몽블랑130(SEMI_ROLE.01)"}
  - {rel: has_member, target: product-102-photobook-cover-hardcover, qualifier: {disp_seq: 2}, note: "표지=하드커버(SEMI_ROLE.02·택1)"}
  - {rel: has_member, target: product-103-photobook-cover-art-matte, qualifier: {disp_seq: 3}, note: "표지=아트250+무광코팅(SEMI_ROLE.02·택1)"}
  - {rel: has_member, target: product-105-photobook-cover-leather-hardcover, qualifier: {disp_seq: 4}, note: "표지=레더하드커버(SEMI_ROLE.02·택1)"}
  - {rel: has_member, target: product-106-photobook-cover-leather, qualifier: {disp_seq: 5}, note: "표지=레더(SEMI_ROLE.02·택1)"}
  - {rel: has_member, target: product-107-photobook-cover-softcover, qualifier: {disp_seq: 6}, note: "표지=소프트커버(SEMI_ROLE.02·택1)"}
  - {rel: has_member, target: product-104-photobook-membrane, qualifier: {disp_seq: 7}, note: "면지=그레이(SEMI_ROLE.03·무가격)"}
  - {rel: has_size, target: size-SIZ_000170, note: "A5(148x210)·공유 축 존재분만 배선(269/274/172는 축 미민팅·전사표 권위)"}
  - {rel: has_print_option, target: printopt-POPT_000001, note: "단면"}
  - {rel: has_print_option, target: printopt-POPT_000002, note: "양면(dflt)"}
  - {rel: has_process, target: process-PROC_000020, qualifier: mandatory, note: "제본(mand_proc_yn=Y)"}
  - {rel: has_process, target: process-PROC_000015, note: "후가공(옵션)"}
  - {rel: has_option_group, target: optgroup-100-cover, note: "표지타입 택1(OPT_000079)"}
props:
  prd_typ_cd: "PRD_TYPE.01"
  구분: "셋트 완제품(포토북·부품조립형·t_prd_product_sets 부모)"
  min_qty: 1
  max_qty: 1000
  qty_incr: 1
  editor_yn: "Y"
  archetype: "고정가형(부모 all-in·base24P+per2p)"
  set_price_contract: "evaluate_set_price(pricing.py:718)=구성원별 evaluate_price 합산 + 부모공식 PRF_PHOTOBOOK_FIXED + 할인. 시뮬=price_simulate_set(price_views.py:1888)"
standards: {schema_org: "Product(셋트)", xjdf: "Product(포토북)", config_ont: "component type(assembly)"}
answers_cq: ["포토북 구성·표지 선택지·가격 축", "셋트상품 구조(부모↔구성원) 질의"]
tags: ["#셋트", "#포토북", "#고정가형", "#부품조립"]
updated: 2026-07-03
---

# 포토북 (product-100-photobook)

포토북(PRD_000100)은 **셋트 완제품**(부품 조립형·`t_prd_product_sets` 부모·prd_typ_cd=PRD_TYPE.01·editor_yn=Y).
구성원 7 = **내지 1**(101 몽블랑130·SEMI_ROLE.01) + **표지 5종 택1**(102 하드커버·103 아트250+무광코팅·105 레더하드커버·
106 레더·107 소프트커버·전부 SEMI_ROLE.02) + **면지 1**(104 그레이·SEMI_ROLE.03·무가격). 셋트 관계는 부모가
`has_member`로 잇고(R13), 구성원의 역방향은 그래프 backlink로 파생된다(스키마에 `member_of` 관계 없음·has_member 단일 방향).

- **정체**: live `t_prd_product_sets`(부모↔구성원 7행 실재 = 셋트 성립·pack §3.1) + `t_prd_products`(prd_typ_cd·editor_yn).
  셋트 완제품의 유일 판정 = `t_prd_product_sets` 부모 등록(CLAUDE.md §1 [HARD]).
- **가격 = 고정가형(부모 all-in)**: 부모공식 [[../formula/set-formulas.md#formula-PRF_PHOTOBOOK_FIXED]](PRF_PHOTOBOOK_FIXED)이
  **기본24P**(사이즈·표지타입별)를 verbatim 468셀로 담고, 페이지 추가가는 내지 구성원 공식
  [[../formula/set-formulas.md#formula-PRF_PHOTOBOOK_INNER]](추가2P당). 표지 5종·면지의 가격은 부모 all-in에
  귀속(구성원 자체 priced_by 없음·[[postcard-book-sim-convergence-260702]] 부모 verbatim·자식 분리 금지).
- **가격 경계(D-18)**: 이 노드는 priced_by·has_member·차원 선언까지만. 값 계산은 `evaluate_set_price` 권위(KB 밖).
- **★양면(정직 표기·pack §4·T-5)**: **가격 사실 = 엔진 골든 100부 1,500,000(PRICE≠0·아래 전사표)**.
  **화면 0원**은 셋트 UI가 set_selections에 siz_cd를 미전파하는 **코드 C트랙**(가격 사실 아님·개발팀)
  → [[../rule/gaps.md#gap-set-simulate-sizcd]]. 화면 0원을 "가격 결함"으로 넣지 않는다(그래서 badge=verified).
- **면지(104)**: 무가격(제본비 포함·기여 0)·색은 부모 표지타입과 별개 단일 그레이(재설계 4셋트 072/077/082/088의
  "면지 1멤버 색 내부 택1"과 달리 100 포토북은 면지 단일·1색). 자재는 MAT_000251 그레이(축 노드 미민팅·needs_axis).

## 셋트 골든 (권위 = simulate_set 실호출)

<!-- transcribed-by: awk pack-set-series.md §1 <- {set-price-full-diagnosis-260702.md §3 실호출·PRF_PHOTOBOOK_FIXED} @ 2026-07-03 (LLM 손전사 아님·인벤토리표 전사) -->
| 셋트 부모 | 부모공식 | 아키타입 | 엔진골든(정확선택) | 정확선택 옵션 | 화면 |
|---|---|---|---|---|---|
| 100 포토북 | PRF_PHOTOBOOK_FIXED | 고정가(부모 all-in) | 100부 1,500,000 | opt OPV_000484(하드커버)+siz SIZ_000269(8x8) | 0원=코드 C트랙(gap-set-simulate-sizcd) |

<!-- lint-allow: L-12 src=SR-23-diag (골든 1,500,000 = 전사표 sanctioned 위치·화면0원은 가격사실 아님) -->

## 차원·구성원 전사표 (권위 = 라이브 스냅샷·awk 전사)

> ★고정가형 특성: **축 데이터(사이즈·자재·도수·공정·옵션)는 전부 부모 100에 적재**(부모 all-in·verbatim).
> 표지 구성원 102/103/105/106/107·면지 104는 **빈 껍데기**(자체 축 0행)·내지 101만 판형(국4절) 보유.

#### 부모 사이즈 (t_prd_product_sizes PRD_000100)

<!-- transcribed-by: awk live-snapshot/latest (snap_20260702_1119) t_prd_product_sizes+t_siz_sizes PRD_000100 @ 2026-07-03 -->
| siz_cd | 라벨 | dflt | 축노드 존재 |
|---|---|---|---|
| SIZ_000269 | 8x8(200x200mm) | Y | 미민팅(needs_axis·★골든 기준) |
| SIZ_000274 | 10x10(250x250mm) | Y | 미민팅(needs_axis) |
| SIZ_000170 | A5(148x210mm) | Y | O(has_size 배선) |
| SIZ_000172 | A4(210x297mm) | Y | 미민팅(needs_axis) |

#### 부모 자재 (t_prd_product_materials PRD_000100·usage 슬롯 = 구성원 역할 대응)

<!-- transcribed-by: awk live-snapshot/latest (snap_20260702_1119) t_prd_product_materials+t_mat_materials PRD_000100 @ 2026-07-03 -->
| mat_cd | 자재명 | usage_cd | 대응 구성원 |
|---|---|---|---|
| MAT_000105 | 몽블랑 130g | USAGE.01(내지) | 101 내지 |
| MAT_000005 | 하드커버 | USAGE.02(표지) | 102 |
| MAT_000250 | 아트250+무광코팅 | USAGE.02 | 103 |
| MAT_000006 | 레더하드커버 | USAGE.02 | 105 |
| MAT_000186 | 레더 | USAGE.02 | 106 |
| MAT_000007 | 소프트커버 | USAGE.02 | 107 |
| MAT_000251 | 그레이 | USAGE.03(면지) | 104 |

자재 축 노드는 공유 [[../axis/materials.md]]에 이 7종 미민팅(면지 MAT_382~385는 072/082/088 계열용·100 포토북 면지는
MAT_000251 그레이 단일) → uses_material 그래프 배선 대기(needs_axis). 전사표가 권위. IMPORT 자재 삭제 금지.

#### 부모 도수·공정·판형

<!-- transcribed-by: awk live-snapshot/latest (snap_20260702_1119) t_prd_product_print_options+t_prd_product_processes+t_prd_product_plate_sizes PRD_000100/101 @ 2026-07-03 -->
| 축 | 값 | 비고 |
|---|---|---|
| 도수 | POPT_000002 양면(dflt·CLR_000005 4도)·POPT_000001 단면 | has_print_option 배선(축 존재) |
| 공정 | PROC_000020 제본(mand)·PROC_000015 후가공(옵션) | has_process 배선(축 존재) |
| 판형(부모 100) | 표지/내지 파일사양 11행 **전부 del_yn=Y**(2026-07-01 논리삭제) | 부모 활성 판형 0(파일사양 surface) |
| 판형(내지 101) | SIZ_000499 국4절(316x467·output_file=PDF·활성) | 종이류 내지 판형(도메인 [HARD]·fn_best_plate) |

#### 가격공식 바인딩

<!-- transcribed-by: awk live-snapshot/latest (snap_20260702_1119) t_prd_product_price_formulas PRD_000100/101 @ 2026-07-03 -->
| prd_cd | frm_cd | note(live) |
|---|---|---|
| PRD_000100 | PRF_PHOTOBOOK_FIXED | 포토북 세트 부모(기본24P) |
| PRD_000101 | PRF_PHOTOBOOK_INNER | 포토북 내지 구성원(추가2P당) |

표지 5종(102/103/105/106/107)·면지(104)는 **자체 가격공식 바인딩 없음**(0행) — 부모 all-in에 귀속.
구성원 노드는 [[product-100-photobook-nodes]] 참조(고정가형이라 `derived_from` 부모공식으로 O5 충족).
