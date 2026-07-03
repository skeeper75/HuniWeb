---
id: product-108-desk-calendar
type: product
anchor: t_prd_products/PRD_000108
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "키:PRD_000108 (prd_typ_cd=PRD_TYPE.01·del_yn=N·use_yn=Y·upd 2026-06-26)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-set-series.md", source_locator: "§0.1 캘린더 universe 판정(단품 완제품·셋트 아님·PRF_DGP_CAL_* 바인딩 2026-07-01)", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-set}
  - {source_file: "_workspace/huni-ontology-kb/_meta/scripts/cal_golden.py", source_locator: "라이브 evaluate_price simulate 100부 final=271555 (PRICE≠0·인쇄+용지+제본 코어 기여 정합)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-27-golden}
relations:
  - {rel: in_category, target: category-CAT_000112, note: "탁상형캘린더(main·live)"}
  - {rel: in_category, target: category-CAT_000118, note: "디자인캘린더(super·live main_cat_yn=N)"}
  - {rel: uses_material, target: material-MAT_000090, note: "스노우지 200g(USAGE.07·dflt·live PRD_000108)"}
  - {rel: uses_material, target: material-MAT_000127, note: "스타드림(USAGE.07·live PRD_000108)"}
  - {rel: has_size, target: size-SIZ_000069, note: "탁상형 사이즈(live PRD_000108)"}
  - {rel: has_size, target: size-SIZ_000070, note: "탁상형 사이즈(live PRD_000108)"}
  - {rel: has_print_option, target: printopt-POPT_000002, note: "양면 칼라(dflt)"}
  - {rel: uses_material, target: material-MAT_000107, note: "몽블랑 190g(대표·활성 자재 중)"}
  - {rel: uses_material, target: material-MAT_000113, note: "아코팩"}
  - {rel: uses_material, target: material-MAT_000114, note: "리사이클러스"}
  - {rel: uses_material, target: material-MAT_000115, note: "매쉬멜로우"}
  - {rel: uses_material, target: material-MAT_000116, note: "린넨커버"}
  - {rel: uses_material, target: material-MAT_000123, note: "띤또레또 200g"}
  - {rel: has_process, target: process-PROC_000004, qualifier: mandatory, note: "디지털인쇄 base(mand_proc_yn=Y·인쇄비 원천)"}
  - {rel: has_process, target: process-PROC_000100, note: "탁상형캘린더제본(220)·COMP_BIND_CAL_WALL 매칭"}
  - {rel: has_plate_size, target: plate-OUTPUT_PAPER_TYPE_01, note: "국전 출력용지(종이류·fn_best_plate 자동선택)"}
  - {rel: priced_by, target: formula-PRF_DGP_CAL_DESK}
props:
  prd_typ_cd: "PRD_TYPE.01"
  min_qty: 1
  max_qty: 10000
  qty_incr: 1
  qty_unit_typ_cd: "QTY_UNIT.01"
  file_upload_yn: "Y"
  editor_yn: "Y"
  구분: "탁상형캘린더(디지털인쇄 완제품 단품·셋트 아님)"
standards: {schema_org: "Product", xjdf: "Product(캘린더)", config_ont: "component type"}
answers_cq: ["탁상 캘린더 구성·가격 축", "캘린더 종류(탁상/벽걸이/엽서) 비교"]
tags: ["#캘린더", "#탁상캘린더", "#원자합산형", "#단품완제품"]
updated: 2026-07-03
---

# 탁상형캘린더 (product-108-desk-calendar)

탁상형캘린더(PRD_000108)는 **디지털인쇄 완제품 단품**(prd_typ_cd=PRD_TYPE.01·셋트 아님·
`t_prd_product_sets` 미등록). 가격은 **원자합산형 공식** [[formula/set-formulas#formula-PRF_DGP_CAL_DESK]]
(PRF_DGP_CAL_DESK = 디지털인쇄비 + 용지비 + 탁상캘린더제본비 `COMP_BIND_CAL_WALL`)으로 계산한다.
값 계산은 evaluate_price 권위([[rule/rules#RULE_price_value_boundary]]·D-18 경계).

- **정체(★위키 STALE 교정)**: 위키 round-13은 캘린더를 "전부 PRD_TYPE.04 디자인상품·가격공식 0행 🔴 미적재"로 적었으나,
  라이브 = **PRD_TYPE.01 완제품**(SOT 재분류·upd 2026-06-26) + **PRF_DGP_CAL_DESK 바인딩**(2026-07-01). 위키 서술은 STALE(팩 §2 T-6).
- **가격 상태(PRICE≠0 실호출 확인)**: 라이브 evaluate_price simulate(100부·양면·스노우지 200g·PROC_000004+PROC_000100)로 인쇄+용지+탁상캘린더제본 코어 3비목 기여 정합(silent-0 없음)·PRICE≠0 확인 → badge=verified. 값은 하단 가격 골든 표(transcribed-by cal_golden.py).
- **단품 완제품(셋트 아님)**: has_member 엣지 없음. 디지털인쇄 원자합산형([[product-016-premium-postcard]])과 동형 —
  다만 캘린더제본 공정이 form을 만든다.
- **★잔존 결함(REVERIFY)**: 활성 자재에 **삼각대(싸바리) MAT_000252·링 블랙 MAT_000253**이 용지 슬롯(USAGE.07)에 섞여 있다(scoreboard R1_contamination 적발).
  판형=종이류만 원칙상 비종이 부속의 자재-슬롯 오적재 의심 → [[gap-108-tripod-ring-material]] REVERIFY.
- **design-calendar 고정가**: `t_prd_product_prices` 캘린더 0행(직접단가 미적재) → 업로드 공식가는 위처럼 실재하나, 디자인 고정가 surface는 미적재 GAP([[gap-design-calendar-fixedprice]]).

## 차원·BOM·연결 전사표 (권위 = 라이브 스냅샷·스크립트 전사)

<!-- transcribed-by: _meta/scripts/transcribe_calendars.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_* PRD_000108 @ 2026-07-03 -->

#### 사이즈
| siz_cd | 라벨 | dflt |
|---|---|---|
| SIZ_000069 | 220x145 | Y |
| SIZ_000070 | 130x220 | Y |

사이즈 축 노드 미민팅(캘린더 전용 siz) → 위 표가 권위. has_size 그래프 배선은 [[gap-108-size-nodes]].

#### 자재(활성 10종·전부 USAGE.07)
| mat_cd | 자재명 | dflt |
|---|---|---|
| MAT_000252 | 삼각대(싸바리) | Y ★REVERIFY 오적재의심 |
| MAT_000253 | 링 블랙 | Y ★REVERIFY 오적재의심 |
| MAT_000107 | 몽블랑 190g | Y |
| MAT_000090 | 스노우지 200g | Y |
| MAT_000113 | 아코팩 | N |
| MAT_000114 | 리사이클러스 | N |
| MAT_000115 | 매쉬멜로우 | N |
| MAT_000116 | 린넨커버 | N |
| MAT_000123 | 띤또레또 200g | N |
| MAT_000127 | 스타드림 | N |

`uses_material`은 공유 축 노드가 있는 종이류 6종(107/113/114/115/116/123)만 relations로 배선. 스노우지 200g(MAT_000090·기본 용지)·스타드림(127)은 축 노드 미민팅 → BOM 표가 권위([[gap-108-size-nodes]] 계열·커버리지 공백). 삼각대/링 2종은 비종이 오적재 의심으로 배선 제외(REVERIFY).

#### 인쇄옵션·공정·판형·가격공식
| 축 | 값 |
|---|---|
| 인쇄옵션 | POPT_000002 양면(dflt) |
| 공정 | PROC_000004 디지털인쇄(mand) · PROC_000100 탁상형캘린더제본(220) · PROC_000076 수축포장(축 노드 미민팅) |
| 판형 | SIZ_000499 → OUTPUT_PAPER_TYPE.01 국전(dflt·종이류) |
| 가격공식 | PRF_DGP_CAL_DESK (인쇄+용지+캘린더제본 CAL_WALL 배선 260701) |

<!-- transcribed-by: _meta/scripts/cal_golden.py live /admin/price-viewer/PRD_000108/simulate/ @ 2026-07-03 -->
| 가격 골든(100부·양면·스노우지200g·PROC_000004+100) | 값 |
|---|---|
| 디지털인쇄비 | 40,000 |
| 용지비 | 1,555 |
| 탁상캘린더제본비 | 230,000 |
| final_price | 271,555 (PRICE≠0) |

---

## 이 상품 전용 하위 노드 (gap)

### [gap-108-tripod-ring-material] 탁상캘린더 삼각대/링 자재 용지슬롯 오적재 의심 {unknown}
- type: gap
- anchor: none  # 사유: MAT_000252/253은 live 실재하나 비종이(삼각대/링)가 USAGE.07 용지 슬롯에 적재된 오적재 여부 미판정(REVERIFY)
- src: {source_file: "live-snapshot/latest/t_prd_product_materials.csv", source_locator: "prd_cd:PRD_000108 mat_cd:MAT_000252(삼각대싸바리)·MAT_000253(링블랙) usage_cd=USAGE.07", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/_foundation/batch/scoreboard-general.csv", source_locator: "PRD_000108 R1_contamination=MAT_000252(삼각대(싸바리));MAT_000253(링 블랙)", captured_at: "2026-07-03", badge: unknown, src_id: SR-27-scoreboard}
- gap_what: "삼각대(싸바리·MAT_000252)·링(MAT_000253)이 용지 자재 슬롯(USAGE.07·dflt=Y)에 적재 — 판형=종이류만 원칙상 비종이 부속의 자재 오적재 의심. 위키 calendar.md §7 잔존 결함(삼각대/링)과 동일 신호"
- gap_fill_from: "live 재측정 + 실무진 확인 — 비종이 부속을 자재 슬롯 유지할지(선택지) vs 옵션/제약으로 이관할지. 가격 무영향(COMP_PAPER는 종이 mat만 매칭·삼각대 선택 시 용지비 미발현 여부 REVERIFY)"
- gap_owner: staff
- 본문: 캘린더 잔존 결함(팩 §0.1·위키 REVERIFY 승계). 조용한 누락 대신 정직 선언. 골든(271,555)은 스노우지 용지로 산출·삼각대/링 자재는 가격 미검증(REVERIFY).

### [gap-108-size-nodes] 탁상캘린더 사이즈·기본용지 축 노드 미민팅 (그래프 커버리지) {unknown}
- type: gap
- anchor: none  # 사유: SIZ_000069/070·MAT_000090(스노우지200g)·MAT_000127 등이 live 실재하나 공유 axis 미민팅으로 has_size·uses_material 배선 부재
- src: {source_file: "live-snapshot/latest/t_prd_product_sizes.csv", source_locator: "prd_cd:PRD_000108 siz:SIZ_000069/070·mat:MAT_000090/127", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- gap_what: "탁상캘린더 사이즈(SIZ_000069 220x145·SIZ_000070 130x220)·기본용지(MAT_000090 스노우지200g)·MAT_000127이 공유 axis 미민팅 → has_size 0·uses_material 대표 6종만. BOM 표가 권위이나 그래프 탐색 시 침묵 누락"
- gap_fill_from: "architect 완전성 정책 — 캘린더 전용 size/material 축 노드 민팅 후 108~112 has_size·uses_material 전수 배선(needs_axis 반환분)"
- gap_owner: 설계
- 본문: 값은 아는데(live·BOM) 공유 축 노드 부재로 배선 부분적인 커버리지 공백(016 GAP_016_material 동류). 정직 선언.

> **design-calendar 고정가 GAP**은 이미 [[rule/gaps#gap-design-calendar-fixedprice]]에 공유 노드로 존재(전 캘린더 108~112 공유·중복 미민팅) — 본 파일은 참조만.
