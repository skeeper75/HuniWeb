---
id: product-112-wide-wall-calendar
type: product
anchor: t_prd_products/PRD_000112
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "키:PRD_000112 (prd_typ_cd=PRD_TYPE.01·del_yn=N·use_yn=Y·upd 2026-06-26)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-set-series.md", source_locator: "§0.1 캘린더 universe 판정(단품 완제품·셋트 아님·PRF_DGP_CAL_WIDE 바인딩 2026-07-01·3절 판형이관)", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-set}
  - {source_file: "_workspace/huni-ontology-kb/_meta/scripts/cal_golden.py", source_locator: "라이브 evaluate_price simulate 100부 final=261922 (PRICE≠0·인쇄+용지+제본 코어 기여 정합)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-27-golden}
relations:
  - {rel: in_category, target: category-CAT_000115, note: "벽걸이캘린더(super·live main_cat_yn=N)"}
  - {rel: in_category, target: category-CAT_000116, note: "와이드벽걸이캘린더(main·live)"}
  - {rel: has_size, target: size-SIZ_000077, note: "와이드벽걸이 사이즈(live PRD_000112)"}
  - {rel: has_print_option, target: printopt-POPT_000001, note: "단면(dflt)"}
  - {rel: has_print_option, target: printopt-POPT_000002, note: "양면(dflt)"}
  - {rel: uses_material, target: material-MAT_000093, note: "스노우지 250g (3절)·기본"}
  - {rel: uses_material, target: material-MAT_000111, note: "몽블랑 190g (3절)"}
  - {rel: uses_material, target: material-MAT_000112, note: "몽블랑 240g (3절)"}
  - {rel: has_process, target: process-PROC_000004, qualifier: mandatory, note: "디지털인쇄 base(mand)"}
  - {rel: has_process, target: process-PROC_000099, note: "벽걸이캘린더제본(트윈링·COMP_BIND_CAL_WALL 매칭)"}
  - {rel: priced_by, target: formula-PRF_DGP_CAL_WIDE}
props:
  prd_typ_cd: "PRD_TYPE.01"
  min_qty: 1
  max_qty: 10000
  qty_incr: 1
  qty_unit_typ_cd: "QTY_UNIT.01"
  file_upload_yn: "Y"
  editor_yn: "Y"
  구분: "와이드벽걸이캘린더(디지털인쇄 완제품 단품·셋트 아님·3절 판형)"
standards: {schema_org: "Product", xjdf: "Product(캘린더)", config_ont: "component type"}
answers_cq: ["와이드 벽걸이 캘린더 구성·가격 축", "큰 벽걸이 캘린더 탐색"]
tags: ["#캘린더", "#벽걸이캘린더", "#원자합산형", "#단품완제품"]
updated: 2026-07-03
---

# 와이드벽걸이캘린더 (product-112-wide-wall-calendar)

와이드벽걸이캘린더(PRD_000112)는 **디지털인쇄 완제품 단품**(PRD_TYPE.01·셋트 아님). 벽걸이(111)의 대형 3절 판형
버전으로 같은 공식 [[formula/set-formulas#formula-PRF_DGP_CAL_WIDE]](PRF_DGP_CAL_WIDE = 인쇄비+용지비+캘린더제본비)을
공유한다. 값 계산은 evaluate_price 권위(D-18).

- **정체(위키 STALE 교정)**: 라이브 = PRD_TYPE.01 완제품(위키 .04 STALE·팩 §2 T-6) + PRF_DGP_CAL_WIDE 바인딩(2026-07-01·3절 판형이관+트윈링제본 신설).
- **가격 상태(PRICE≠0 실호출)**: simulate(100부·단면·스노우지250g(3절)·300x625·PROC_000004+PROC_000099)로 인쇄+용지+캘린더제본 코어 기여 정합·PRICE≠0 확인 → verified. 값은 하단 가격 골든 표(transcribed-by cal_golden.py).
- **단품 완제품(셋트 아님)**: has_member 없음. 원자합산형([[product-016-premium-postcard]]) 동형.
- **★판형 = 3절(OUTPUT_PAPER_TYPE.03)**: 111과 달리 국전(01)이 아닌 3절 판형(SIZ_000475·330x660). 공유 판형 축 노드 `plate-OUTPUT_PAPER_TYPE_03` 미민팅 → has_plate_size 미배선([[gap-112-plate-3jeol]]·needs_axis 반환분).
- **★잔존 결함(REVERIFY)**: 링 블랙 MAT_000253이 용지 슬롯(USAGE.07·dflt=Y)에 섞임(scoreboard R1_contamination) → [[gap-108-tripod-ring-material]] 계열 REVERIFY.
- **design-calendar 고정가 미적재**: [[gap-design-calendar-fixedprice]].

## 차원·BOM·연결 전사표 (권위 = 라이브 스냅샷·스크립트 전사)

<!-- transcribed-by: _meta/scripts/transcribe_calendars.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_* PRD_000112 @ 2026-07-03 -->

#### 사이즈
| siz_cd | 라벨 | dflt |
|---|---|---|
| SIZ_000077 | 300x625 | Y |

사이즈 축 노드 미민팅 → BOM 표 권위([[gap-112-plate-3jeol]]).

#### 자재(활성 4종·전부 USAGE.07·3절 전용)
| mat_cd | 자재명 | dflt |
|---|---|---|
| MAT_000093 | 스노우지 250g (3절) | Y |
| MAT_000253 | 링 블랙 | Y ★REVERIFY 오적재의심 |
| MAT_000111 | 몽블랑 190g (3절) | Y |
| MAT_000112 | 몽블랑 240g (3절) | Y |

`uses_material`은 종이류 3종(093/111/112) 배선. 링(MAT_000253)은 REVERIFY로 배선 제외.

#### 인쇄옵션·공정·판형·가격공식
| 축 | 값 |
|---|---|
| 인쇄옵션 | POPT_000001 단면 · POPT_000002 양면(둘 다 dflt) |
| 공정 | PROC_000004 디지털인쇄(mand) · PROC_000099 벽걸이캘린더제본 |
| 판형 | SIZ_000475 → OUTPUT_PAPER_TYPE.03 **3절**(dflt·종이류·축 노드 미민팅→needs_axis) |
| 가격공식 | PRF_DGP_CAL_WIDE (3절 판형이관+트윈링제본 신설 260701) |

<!-- transcribed-by: _meta/scripts/cal_golden.py live /admin/price-viewer/PRD_000112/simulate/ @ 2026-07-03 -->
| 가격 골든(100부·단면·스노우지250g(3절)·300x625·PROC_000004+099) | 값 |
|---|---|
| 디지털인쇄비 | 47,000 |
| 용지비 | 14,922 |
| 벽걸이캘린더제본비 | 200,000 |
| final_price | 261,922 (PRICE≠0) |

---

## 이 상품 전용 하위 노드 (gap)

### [gap-112-plate-3jeol] 와이드벽걸이 3절 판형·사이즈 축 노드 미민팅 (그래프 커버리지) {unknown}
- type: gap
- anchor: none  # 사유: OUTPUT_PAPER_TYPE.03(3절 판형)·SIZ_000077이 live 실재하나 공유 axis 미민팅으로 has_plate_size·has_size 배선 부재
- src: {source_file: "live-snapshot/latest/t_prd_product_plate_sizes.csv", source_locator: "prd_cd:PRD_000112 siz:SIZ_000475 output_paper_typ_cd:OUTPUT_PAPER_TYPE.03(3절·330x660)·prod siz:SIZ_000077", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- gap_what: "와이드벽걸이 판형 = 3절(OUTPUT_PAPER_TYPE.03) — 공유 판형 축 노드 plate-OUTPUT_PAPER_TYPE_03 미민팅(현 axis는 01/02만) → has_plate_size 미배선. 사이즈 SIZ_000077·3절 자재도 축 미민팅"
- gap_fill_from: "architect 완전성 정책 — plate-OUTPUT_PAPER_TYPE_03(3절) + 캘린더 전용 size 축 노드 민팅 후 has_plate_size·has_size 배선(needs_axis 반환분)"
- gap_owner: 설계
- 본문: 값은 아는데 축 노드 부재로 배선 부분적(016 GAP_016_material 동류). 3절은 썬캡 등 타 상품군도 쓰는 판형이라 공유 축 승격 대상. 정직 선언.
