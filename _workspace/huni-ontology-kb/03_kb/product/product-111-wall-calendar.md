---
id: product-111-wall-calendar
type: product
anchor: t_prd_products/PRD_000111
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "키:PRD_000111 (prd_typ_cd=PRD_TYPE.01·del_yn=N·use_yn=Y·upd 2026-06-26)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-set-series.md", source_locator: "§0.1 캘린더 universe 판정(단품 완제품·셋트 아님·PRF_DGP_CAL_WIDE 바인딩 2026-07-01·112와 공용)", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-set}
  - {source_file: "_workspace/huni-ontology-kb/_meta/scripts/cal_golden.py", source_locator: "라이브 evaluate_price simulate 100부 final=231032 (PRICE≠0·인쇄+용지+제본 코어 기여 정합)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-27-golden}
relations:
  - {rel: in_category, target: category-CAT_000115, note: "벽걸이캘린더(main·live)"}
  - {rel: in_category, target: category-CAT_000118, note: "디자인캘린더(super·live main_cat_yn=N)"}
  - {rel: uses_material, target: material-MAT_000098, note: "앙상블 190g(USAGE.07·live PRD_000111)"}
  - {rel: uses_material, target: material-MAT_000127, note: "스타드림(USAGE.07·live PRD_000111)"}
  - {rel: has_size, target: size-SIZ_000050, note: "벽걸이 사이즈(live PRD_000111)"}
  - {rel: has_size, target: size-SIZ_000075, note: "벽걸이 사이즈(live PRD_000111)"}
  - {rel: has_size, target: size-SIZ_000076, note: "벽걸이 사이즈(live PRD_000111)"}
  - {rel: has_print_option, target: printopt-POPT_000001, note: "단면(dflt)"}
  - {rel: has_print_option, target: printopt-POPT_000002, note: "양면(dflt)"}
  - {rel: uses_material, target: material-MAT_000074, note: "백색모조지 220g(대표)"}
  - {rel: uses_material, target: material-MAT_000082, note: "아트지 300g"}
  - {rel: uses_material, target: material-MAT_000091, note: "스노우지 250g"}
  - {rel: uses_material, target: material-MAT_000092, note: "스노우지 300g"}
  - {rel: uses_material, target: material-MAT_000108, note: "몽블랑 210g"}
  - {rel: uses_material, target: material-MAT_000118, note: "클래식 크래스트"}
  - {rel: has_process, target: process-PROC_000004, qualifier: mandatory, note: "디지털인쇄 base(mand)"}
  - {rel: has_process, target: process-PROC_000099, note: "벽걸이캘린더제본(트윈링·COMP_BIND_CAL_WALL 매칭)"}
  - {rel: has_process, target: process-PROC_000079, note: "타공(옵션)"}
  - {rel: has_plate_size, target: plate-OUTPUT_PAPER_TYPE_01, note: "국전 출력용지(종이류·자동선택)"}
  - {rel: priced_by, target: formula-PRF_DGP_CAL_WIDE}
props:
  prd_typ_cd: "PRD_TYPE.01"
  min_qty: 1
  max_qty: 10000
  qty_incr: 1
  qty_unit_typ_cd: "QTY_UNIT.01"
  file_upload_yn: "Y"
  editor_yn: "Y"
  구분: "벽걸이캘린더(디지털인쇄 완제품 단품·셋트 아님)"
standards: {schema_org: "Product", xjdf: "Product(캘린더)", config_ont: "component type"}
answers_cq: ["벽걸이 캘린더 구성·가격 축", "벽에 거는 캘린더 탐색"]
tags: ["#캘린더", "#벽걸이캘린더", "#원자합산형", "#단품완제품"]
updated: 2026-07-03
---

# 벽걸이캘린더 (product-111-wall-calendar)

벽걸이캘린더(PRD_000111)는 **디지털인쇄 완제품 단품**(PRD_TYPE.01·셋트 아님). 가격은 원자합산형 공식
[[formula/set-formulas#formula-PRF_DGP_CAL_WIDE]](PRF_DGP_CAL_WIDE = 인쇄비+용지비+벽걸이캘린더제본비 `COMP_BIND_CAL_WALL`)으로
계산 — 와이드벽걸이(112)와 공용 공식. 값 계산은 evaluate_price 권위(D-18).

- **정체(위키 STALE 교정)**: 라이브 = PRD_TYPE.01 완제품(위키 .04 STALE·팩 §2 T-6) + PRF_DGP_CAL_WIDE 바인딩(2026-07-01·112와 공용).
- **가격 상태(PRICE≠0 실호출)**: simulate(100부·단면·백색모조지220g·A4·PROC_000004+PROC_000099)로 인쇄+용지+벽걸이캘린더제본 코어 기여 정합·PRICE≠0 확인 → verified. 값은 하단 가격 골든 표(transcribed-by cal_golden.py).
- **단품 완제품(셋트 아님)**: has_member 없음. 원자합산형([[product-016-premium-postcard]]) 동형.
- **★잔존 결함(REVERIFY)**: 링 블랙 MAT_000253이 용지 슬롯(USAGE.07·dflt=Y)에 섞임(scoreboard R1_contamination) → [[gap-108-tripod-ring-material]] 계열 REVERIFY.
- **design-calendar 고정가 미적재**: [[gap-design-calendar-fixedprice]].

## 차원·BOM·연결 전사표 (권위 = 라이브 스냅샷·스크립트 전사)

<!-- transcribed-by: _meta/scripts/transcribe_calendars.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_* PRD_000111 @ 2026-07-03 -->

#### 사이즈
| siz_cd | 라벨 | dflt |
|---|---|---|
| SIZ_000050 | A4 (210X297) | Y |
| SIZ_000075 | 210x420 | Y |
| SIZ_000076 | 300x420 | Y |

사이즈 축 노드 미민팅 → BOM 표 권위([[gap-111-size-nodes]]).

#### 자재(활성 23종·전부 USAGE.07·대표 발췌)
| mat_cd | 자재명 | dflt |
|---|---|---|
| MAT_000253 | 링 블랙 | Y ★REVERIFY 오적재의심 |
| MAT_000107 | 몽블랑 190g | Y |
| MAT_000074 | 백색모조지 220g | Y |
| MAT_000079~099 | 아트지/스노우지/앙상블 계열 | N (다수) |
| MAT_000108/118/119/123/127 | 몽블랑210/클래식/리브스/띤또레또/스타드림 | N |

`uses_material`은 축 노드 있는 대표 6종(074/082/091/092/108/118)만 배선. 활성 23종 전량은 BOM(live) 권위·축 미민팅 다수([[gap-111-size-nodes]]). 링(MAT_000253)은 REVERIFY로 배선 제외.

#### 인쇄옵션·공정·판형·가격공식
| 축 | 값 |
|---|---|
| 인쇄옵션 | POPT_000001 단면 · POPT_000002 양면(둘 다 dflt) |
| 공정 | PROC_000004 디지털인쇄(mand) · PROC_000099 벽걸이캘린더제본 · PROC_000079 타공(옵션) |
| 판형 | SIZ_000499 → OUTPUT_PAPER_TYPE.01 국전(dflt·종이류) |
| 가격공식 | PRF_DGP_CAL_WIDE (인쇄+용지+캘린더제본 CAL_WALL·112와 공용 260701) |

<!-- transcribed-by: _meta/scripts/cal_golden.py live /admin/price-viewer/PRD_000111/simulate/ @ 2026-07-03 -->
| 가격 골든(100부·단면·백색모조지220g·A4·PROC_000004+099) | 값 |
|---|---|
| 디지털인쇄비 | 27,500 |
| 용지비 | 3,532 |
| 벽걸이캘린더제본비 | 200,000 |
| final_price | 231,032 (PRICE≠0) |

---

## 이 상품 전용 하위 노드 (gap)

### [gap-111-size-nodes] 벽걸이캘린더 사이즈·자재 축 노드 미민팅 (그래프 커버리지) {unknown}
- type: gap
- anchor: none  # 사유: SIZ_000050/075/076·활성 자재 23종 중 다수가 live 실재하나 공유 axis 미민팅으로 has_size 0·uses_material 대표 6종만
- src: {source_file: "live-snapshot/latest/t_prd_product_sizes.csv", source_locator: "prd_cd:PRD_000111 siz:SIZ_000050/075/076·mat 활성 23종", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- gap_what: "벽걸이캘린더 사이즈 3종·활성 자재 23종의 상당수가 공유 axis 미민팅 → has_size 0·uses_material 대표 6종만 배선. BOM 표(live)가 권위"
- gap_fill_from: "architect 완전성 정책 — 캘린더 전용 size/material 축 노드 민팅 후 전수 배선(needs_axis 반환분)"
- gap_owner: 설계
- 본문: 값은 아는데 축 노드 부재로 배선 부분적(016 GAP_016_material 동류). 정직 선언.
