---
id: product-110-postcard-calendar
type: product
anchor: t_prd_products/PRD_000110
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "키:PRD_000110 (prd_typ_cd=PRD_TYPE.01·del_yn=N·use_yn=Y·editor_yn=N·upd 2026-06-29)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-set-series.md", source_locator: "§0.1 캘린더 universe 판정(단품 완제품·엽서캘린더 PRF_DGP_INNER 재사용·110 editor_yn=N)", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-set}
  - {source_file: "_workspace/huni-ontology-kb/_meta/scripts/cal_golden.py", source_locator: "라이브 evaluate_price simulate 100부 final=21555 (PRICE≠0·인쇄+용지 코어 기여 정합)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-27-golden}
relations:
  - {rel: in_category, target: category-CAT_000114, note: "엽서캘린더(main·live)"}
  - {rel: uses_material, target: material-MAT_000090, note: "스노우지 200g(USAGE.07·dflt·live PRD_000110)"}
  - {rel: uses_material, target: material-MAT_000098, note: "앙상블 190g(USAGE.07·live PRD_000110)"}
  - {rel: uses_material, target: material-MAT_000127, note: "스타드림(USAGE.07·live PRD_000110)"}
  - {rel: has_size, target: size-SIZ_000072, note: "엽서캘린더 사이즈(live PRD_000110)"}
  - {rel: has_size, target: size-SIZ_000073, note: "엽서캘린더 사이즈(live PRD_000110)"}
  - {rel: has_size, target: size-SIZ_000074, note: "엽서캘린더 사이즈(live PRD_000110)"}
  - {rel: has_size, target: size-SIZ_000007, note: "148x210(공유 축 노드 실재)"}
  - {rel: has_print_option, target: printopt-POPT_000001, note: "단면 칼라(dflt·재단만)"}
  - {rel: uses_material, target: material-MAT_000107, note: "몽블랑 190g(대표)"}
  - {rel: uses_material, target: material-MAT_000113, note: "아코팩"}
  - {rel: uses_material, target: material-MAT_000114, note: "리사이클러스"}
  - {rel: uses_material, target: material-MAT_000115, note: "매쉬멜로우"}
  - {rel: uses_material, target: material-MAT_000116, note: "린넨커버"}
  - {rel: uses_material, target: material-MAT_000118, note: "클래식 크래스트"}
  - {rel: uses_material, target: material-MAT_000123, note: "띤또레또 200g"}
  - {rel: has_process, target: process-PROC_000004, qualifier: mandatory, note: "디지털인쇄 base(mand)"}
  - {rel: has_process, target: process-PROC_000079, note: "타공(옵션·묶음 고리용)"}
  - {rel: has_plate_size, target: plate-OUTPUT_PAPER_TYPE_01, note: "국전 출력용지(종이류·자동선택)"}
  - {rel: priced_by, target: formula-PRF_DGP_INNER}
props:
  prd_typ_cd: "PRD_TYPE.01"
  min_qty: 1
  max_qty: 10000
  qty_incr: 1
  qty_unit_typ_cd: "QTY_UNIT.01"
  file_upload_yn: "Y"
  editor_yn: "N"
  구분: "엽서캘린더(디지털인쇄 완제품 단품·셋트 아님·제본없음 단면 재단)"
standards: {schema_org: "Product", xjdf: "Product(캘린더)", config_ont: "component type"}
answers_cq: ["엽서 캘린더 구성·가격 축", "제본 없는 낱장 캘린더 탐색"]
tags: ["#캘린더", "#엽서캘린더", "#원자합산형", "#단품완제품"]
updated: 2026-07-03
---

# 엽서캘린더 (product-110-postcard-calendar)

엽서캘린더(PRD_000110)는 **디지털인쇄 완제품 단품**(PRD_TYPE.01·셋트 아님·제본 없음·단면 재단). 가격은
내지 공식 [[formula/set-formulas#formula-PRF_DGP_INNER]](PRF_DGP_INNER = 인쇄비+용지비·재사용)으로 계산 —
탁상/벽걸이와 달리 캘린더제본 공정이 없어(낱장 엽서형) base 공식만 바인딩. 값 계산은 evaluate_price 권위(D-18).

- **정체(위키 STALE 교정)**: 라이브 = PRD_TYPE.01 완제품(위키 .04 STALE·팩 §2 T-6) + PRF_DGP_INNER 바인딩(2026-07-01·단면·재단만·제본없음). `editor_yn=N`(디자인 surface 미구성·팩 §0.1).
- **가격 상태(PRICE≠0 실호출)**: simulate(100부·단면·스노우지200g·SIZ_000007·PROC_000004)로 인쇄+용지 코어 기여 정합·PRICE≠0 확인 → verified. 값은 하단 가격 골든 표(transcribed-by cal_golden.py).
- **단품 완제품(셋트 아님)**: has_member 없음. PRF_DGP_INNER는 셋트 내지 구성원에도 쓰이나(072/077/082/088), 여기서는 단품 완제품의 base 공식으로 재사용([[product-016-premium-postcard]] 원자합산형 동류).
- **삼각대/링 오적재 없음**: 이 상품은 자재에 삼각대/링 미포함(낱장형) — 108/109/111/112의 REVERIFY 대상 아님.
- **design-calendar 고정가 미적재**: [[gap-design-calendar-fixedprice]].

## 차원·BOM·연결 전사표 (권위 = 라이브 스냅샷·스크립트 전사)

<!-- transcribed-by: _meta/scripts/transcribe_calendars.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_* PRD_000110 @ 2026-07-03 -->

#### 사이즈
| siz_cd | 라벨 | dflt | 축노드 |
|---|---|---|---|
| SIZ_000072 | 145x145 | Y | 미민팅 |
| SIZ_000073 | 220x130 | Y | 미민팅 |
| SIZ_000069 | 220x145 | Y | 미민팅 |
| SIZ_000070 | 130x220 | Y | 미민팅 |
| SIZ_000007 | 148x210 | Y | O(has_size 배선) |
| SIZ_000074 | 145x300 | Y | 미민팅 |

6 사이즈 중 SIZ_000007만 공유 축 노드 실재 → has_size 배선. 나머지 5종은 BOM 표 권위([[gap-110-size-nodes]]).

#### 자재(활성 10종·전부 USAGE.07)
| mat_cd | 자재명 | dflt |
|---|---|---|
| MAT_000107 | 몽블랑 190g | Y |
| MAT_000090 | 스노우지 200g | Y |
| MAT_000098 | 앙상블 190g | N |
| MAT_000113 | 아코팩 | N |
| MAT_000114 | 리사이클러스 | N |
| MAT_000115 | 매쉬멜로우 | N |
| MAT_000116 | 린넨커버 | N |
| MAT_000118 | 클래식 크래스트 | N |
| MAT_000123 | 띤또레또 200g | N |
| MAT_000127 | 스타드림 | N |

`uses_material`은 축 노드 있는 7종(107/113/114/115/116/118/123)만 배선. 스노우지200g(090)·앙상블190g(098)·스타드림(127)은 축 미민팅→BOM 표 권위([[gap-110-size-nodes]]).

#### 인쇄옵션·공정·판형·가격공식
| 축 | 값 |
|---|---|
| 인쇄옵션 | POPT_000001 단면(dflt) |
| 공정 | PROC_000004 디지털인쇄(mand) · PROC_000079 타공(옵션) |
| 판형 | SIZ_000499 → OUTPUT_PAPER_TYPE.01 국전(dflt·종이류) |
| 가격공식 | PRF_DGP_INNER (인쇄+용지 base·단면·재단만·제본없음 260701) |

<!-- transcribed-by: _meta/scripts/cal_golden.py live /admin/price-viewer/PRD_000110/simulate/ @ 2026-07-03 -->
| 가격 골든(100부·단면·스노우지200g·SIZ_000007·PROC_000004) | 값 |
|---|---|
| 디지털인쇄비 | 20,000 |
| 용지비 | 1,555 |
| final_price | 21,555 (PRICE≠0) |

---

## 이 상품 전용 하위 노드 (gap)

### [gap-110-size-nodes] 엽서캘린더 사이즈·기본용지 축 노드 미민팅 (그래프 커버리지) {unknown}
- type: gap
- anchor: none  # 사유: SIZ_000072/073/069/070/074·MAT_000090/098/127이 live 실재하나 공유 axis 미민팅으로 has_size·uses_material 배선 부분적
- src: {source_file: "live-snapshot/latest/t_prd_product_sizes.csv", source_locator: "prd_cd:PRD_000110 siz 6종 중 5종 축미민팅·mat:MAT_000090/098/127", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- gap_what: "엽서캘린더 사이즈 6종 중 SIZ_000007만 축 노드 실재(has_size 배선)·나머지 5종(SIZ_000072/073/069/070/074) 미민팅. 기본용지(스노우지200g)·앙상블190g·스타드림 미민팅"
- gap_fill_from: "architect 완전성 정책 — 캘린더 전용 size/material 축 노드 민팅 후 has_size·uses_material 전수 배선(needs_axis 반환분)"
- gap_owner: 설계
- 본문: 값은 아는데 축 노드 부재로 배선 부분적(016 GAP_016_material 동류). 정직 선언.
