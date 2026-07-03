---
id: product-109-mini-desk-calendar
type: product
anchor: t_prd_products/PRD_000109
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "키:PRD_000109 (prd_typ_cd=PRD_TYPE.01·del_yn=N·use_yn=Y·upd 2026-06-26)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-set-series.md", source_locator: "§0.1 캘린더 universe 판정(단품 완제품·셋트 아님·PRF_DGP_CAL_* 바인딩 2026-07-01)", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-set}
  - {source_file: "_workspace/huni-ontology-kb/_meta/scripts/cal_golden.py", source_locator: "라이브 evaluate_price simulate 100부 final=197660 (PRICE≠0·인쇄+용지+제본 코어 기여 정합)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-27-golden}
relations:
  - {rel: in_category, target: category-CAT_000112, note: "탁상형캘린더(super·live main_cat_yn=N)"}
  - {rel: in_category, target: category-CAT_000113, note: "미니탁상형캘린더(main·live)"}
  - {rel: uses_material, target: material-MAT_000090, note: "스노우지 200g(USAGE.07·dflt·live PRD_000109)"}
  - {rel: uses_material, target: material-MAT_000127, note: "스타드림(USAGE.07·live PRD_000109)"}
  - {rel: has_size, target: size-SIZ_000018, note: "미니탁상형 사이즈(live PRD_000109)"}
  - {rel: has_size, target: size-SIZ_000071, note: "미니탁상형 사이즈(live PRD_000109)"}
  - {rel: has_print_option, target: printopt-POPT_000002, note: "양면 칼라(dflt)"}
  - {rel: uses_material, target: material-MAT_000107, note: "몽블랑 190g(대표)"}
  - {rel: uses_material, target: material-MAT_000113, note: "아코팩"}
  - {rel: uses_material, target: material-MAT_000114, note: "리사이클러스"}
  - {rel: uses_material, target: material-MAT_000115, note: "매쉬멜로우"}
  - {rel: uses_material, target: material-MAT_000116, note: "린넨커버"}
  - {rel: has_process, target: process-PROC_000004, qualifier: mandatory, note: "디지털인쇄 base(mand)"}
  - {rel: has_process, target: process-PROC_000102, note: "탁상형캘린더제본(미니)·COMP_BIND_CAL_WALL 매칭"}
  - {rel: has_plate_size, target: plate-OUTPUT_PAPER_TYPE_01, note: "국전 출력용지(종이류·자동선택)"}
  - {rel: priced_by, target: formula-PRF_DGP_CAL_DESK}
props:
  prd_typ_cd: "PRD_TYPE.01"
  min_qty: 1
  max_qty: 10000
  qty_incr: 1
  qty_unit_typ_cd: "QTY_UNIT.01"
  file_upload_yn: "Y"
  editor_yn: "Y"
  구분: "미니탁상형캘린더(디지털인쇄 완제품 단품·셋트 아님)"
standards: {schema_org: "Product", xjdf: "Product(캘린더)", config_ont: "component type"}
answers_cq: ["미니 탁상 캘린더 구성·가격 축", "작은 탁상 캘린더 탐색"]
tags: ["#캘린더", "#탁상캘린더", "#원자합산형", "#단품완제품"]
updated: 2026-07-03
---

# 미니탁상형캘린더 (product-109-mini-desk-calendar)

미니탁상형캘린더(PRD_000109)는 **디지털인쇄 완제품 단품**(PRD_TYPE.01·셋트 아님). 탁상형(108)의 소형 form factor로
같은 공식 [[formula/set-formulas#formula-PRF_DGP_CAL_DESK]](PRF_DGP_CAL_DESK)을 공유하되 제본 공정이 미니 전용(PROC_000102).
값 계산은 evaluate_price 권위([[rule/rules#RULE_price_value_boundary]]·D-18).

- **정체(위키 STALE 교정)**: 라이브 = PRD_TYPE.01 완제품(위키 .04 디자인상품 STALE·팩 §2 T-6) + PRF_DGP_CAL_DESK 바인딩(2026-07-01).
- **가격 상태(PRICE≠0 실호출)**: simulate(100부·양면·스노우지200g·PROC_000004+PROC_000102)로 인쇄+용지+미니캘린더제본 코어 기여 정합·PRICE≠0 확인 → verified. 값은 하단 가격 골든 표(transcribed-by cal_golden.py).
- **단품 완제품(셋트 아님)**: has_member 없음. 원자합산형([[product-016-premium-postcard]]) 동형.
- **★잔존 결함(REVERIFY)**: 삼각대(종이) MAT_000254·링 블랙 MAT_000253이 용지 슬롯(USAGE.07)에 섞임(scoreboard R1_contamination) → [[gap-108-tripod-ring-material]] 계열 REVERIFY.
- **design-calendar 고정가 미적재**: [[gap-design-calendar-fixedprice]].

## 차원·BOM·연결 전사표 (권위 = 라이브 스냅샷·스크립트 전사)

<!-- transcribed-by: _meta/scripts/transcribe_calendars.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_* PRD_000109 @ 2026-07-03 -->

#### 사이즈
| siz_cd | 라벨 | dflt |
|---|---|---|
| SIZ_000018 | 90x100 | Y |
| SIZ_000071 | 148x60 | Y |

#### 자재(활성 9종·전부 USAGE.07)
| mat_cd | 자재명 | dflt |
|---|---|---|
| MAT_000254 | 삼각대(종이) | Y ★REVERIFY 오적재의심 |
| MAT_000253 | 링 블랙 | Y ★REVERIFY 오적재의심 |
| MAT_000107 | 몽블랑 190g | Y |
| MAT_000090 | 스노우지 200g | Y |
| MAT_000113 | 아코팩 | N |
| MAT_000114 | 리사이클러스 | N |
| MAT_000115 | 매쉬멜로우 | N |
| MAT_000116 | 린넨커버 | N |
| MAT_000127 | 스타드림 | N |

`uses_material`은 축 노드 있는 종이류 5종(107/113/114/115/116)만 배선. 스노우지200g(090)·스타드림(127)은 축 미민팅→BOM 표 권위([[gap-109-size-nodes]]). 삼각대/링은 REVERIFY로 배선 제외.

#### 인쇄옵션·공정·판형·가격공식
| 축 | 값 |
|---|---|
| 인쇄옵션 | POPT_000002 양면(dflt) |
| 공정 | PROC_000004 디지털인쇄(mand) · PROC_000102 탁상형캘린더제본(미니) · PROC_000076 수축포장(축 미민팅) |
| 판형 | SIZ_000499 → OUTPUT_PAPER_TYPE.01 국전(dflt·종이류) |
| 가격공식 | PRF_DGP_CAL_DESK (인쇄+용지+캘린더제본 CAL_WALL/PROC_000102 배선 260701) |

<!-- transcribed-by: _meta/scripts/cal_golden.py live /admin/price-viewer/PRD_000109/simulate/ @ 2026-07-03 -->
| 가격 골든(100부·양면·스노우지200g·PROC_000004+102) | 값 |
|---|---|
| 디지털인쇄비 | 17,100 |
| 용지비 | 559.8 |
| 미니탁상캘린더제본비 | 180,000 |
| final_price | 197,660 (PRICE≠0) |

---

## 이 상품 전용 하위 노드 (gap)

### [gap-109-size-nodes] 미니탁상캘린더 사이즈·기본용지 축 노드 미민팅 (그래프 커버리지) {unknown}
- type: gap
- anchor: none  # 사유: SIZ_000018/071·MAT_000090/127이 live 실재하나 공유 axis 미민팅으로 has_size·uses_material 배선 부재
- src: {source_file: "live-snapshot/latest/t_prd_product_sizes.csv", source_locator: "prd_cd:PRD_000109 siz:SIZ_000018/071·mat:MAT_000090/127", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- gap_what: "미니탁상캘린더 사이즈(90x100·148x60)·기본용지(스노우지200g)·스타드림이 공유 axis 미민팅 → has_size 0·uses_material 대표 5종만"
- gap_fill_from: "architect 완전성 정책 — 캘린더 전용 size/material 축 노드 민팅 후 108~112 전수 배선(needs_axis 반환분)"
- gap_owner: 설계
- 본문: 값은 아는데 축 노드 부재로 배선 부분적(016 GAP_016_material 동류). 정직 선언.
