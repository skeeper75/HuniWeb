<!-- product-local sub-nodes: E7 plate·gap for PRD_000059 반칼정사각스티커. -->
<!-- ★공유축 승격 대기 원자. 공유 축 파일(axis/*·formula/*) 수정 금지라 여기 임시 거처 — needed_shared_nodes로 반환. -->
<!-- ★중복 금지(directive "needed_shared_nodes로 반환만"): 스티커 병렬 형제 빌더(halfcut·circle·rectangle)가 -->
<!--   bare-canonical id로 이미 정의하는 공유 노드(category 2·size·formula·component·material 5·process)는 -->
<!--   여기서 재정의하지 않고 참조만(L-3 중복 회피). 아래 '공유 스티커 노드' 목록 = needed_shared_nodes 반환분. -->
<!-- ★이 파일 단독 소유 = 판형 OUTPUT_PAPER_TYPE.02(canonical·형제는 local plate-0XX-*)·gap 2(059 전용). -->
<!-- ★수치(치수·평량·수량)는 아래 전사표(transcribed-by·transcribe_sticker_059.py)에만. props에 raw 미기입(D-9·L-12). -->

# 반칼정사각스티커(PRD_000059) 하위 노드 — 스티커 전용 축 원자

[[sticker-spec-square]] product 노드가 거는 축 원자 중 이 파일 단독 소유분(판형·gap)과,
형제 빌더/승격이 소유하는 공유 스티커 노드 참조 목록. 상품→축 연결은 product 노드가 건다.
059의 소재별 관찰(MAT_000084 유형 불일치·코팅 CONFLICT)은 product 노드 relation note와 gap에 귀속(공유 노드 오염 없이).

## 공유 스티커 노드 (참조 전용 — 형제 빌더/승격 소유·재정의 안 함·needed_shared_nodes 반환분)

스티커 상품군 공통이라 병렬 형제 파일이 bare-canonical id로 정의한다. 중복(L-3) 회피 위해 **참조만** 한다.
축 소유자가 공유 `axis/*`·`formula/*`로 단일 승격(dedup) 대상:

- `category-CAT_000002` 스티커(root) · `category-CAT_000037` 규격스티커(부모 CAT_000002) — product in_category 타깃(halfcut·circle 소유).
- `size-SIZ_000520` A4(210x297) 반칼(적용 058~061 공유) — product has_size·[[gap-059-spec-shape-cut]] 타깃(circle 소유).
- `formula-PRF_STK_FIXED` 스티커 완제품가 고정가 공식(전 스티커 공통) — product priced_by 타깃(halfcut 소유).
- `component-COMP_STK_PRINT` 스티커 완제품가 구성요소(use_dims=[siz_cd,mat_cd,min_qty]) — 공식 has_component 타깃(halfcut 소유).
- `material-MAT_000153`(유포)·`material-MAT_000084`(비코팅·라이브 .13↔note .11)·`material-MAT_000242`(미색)·
  `material-MAT_000155`(무광코팅·CONFLICT)·`material-MAT_000156`(유광코팅·CONFLICT) — product uses_material 타깃(rectangle 소유·059/060 공유).
- `process-PROC_000055` 스티커완칼(Die Cut+조각수·058~062 공통) — product has_process 타깃(rectangle 소유).
- `plate-OUTPUT_PAPER_TYPE_02` 46계열 전지(330x470·SIZ_000521)·점착지=종이류라 판형 유효([[rule/rules#RULE_plate_paper_only]])·
  고객 미선택 fn_best_plate 자동선택 — product has_plate_size 타깃(052 소유·기존 `plate-OUTPUT_PAPER_TYPE_01` 국전계열과 동형 canonical). 국전 SIZ_000007/A4 SIZ_000050은 06-30 del_yn=Y.

## 전사표 (권위 = 라이브 마스터·전사 스크립트 산출)

<!-- transcribed-by: _meta/scripts/transcribe_sticker_059.py from live-snapshot/latest (snap_20260702_1119) t_mat_materials @ 2026-07-03 -->
| mat_cd | 자재명 | mat_typ | 규격(mm) | 평량(g) | note |
|---|---|---|---|---|---|
| MAT_000153 | 유포스티커 | MAT_TYPE.11 | 330.00x470.00 | 80.00 | - |
| MAT_000084 | 비코팅스티커 | MAT_TYPE.13 | 316.00x467.00 | 90.00 | · 정정 2026-06-14: 자재유형 종이(.01)→스티커(.11) 점착지 |
| MAT_000242 | 미색스티커 | MAT_TYPE.11 | 미기재 | 미기재 | · 정정 2026-06-14: 자재유형 종이(.01)→스티커(.11) 점착지 |
| MAT_000155 | 무광코팅스티커 | MAT_TYPE.11 | 미기재 | 90.00 | - |
| MAT_000156 | 유광코팅스티커 | MAT_TYPE.11 | 미기재 | 90.00 | - |

★소재 관찰(공유 노드 아닌 059 귀속): MAT_000084 라이브 `mat_typ_cd=MAT_TYPE.13`(합판스티커용지)인데 note는
".11(스티커용지) 정정" 주장 → **값↔note 불일치**(candidate·재적재/실무진 확인). 팩 §3.5 정답=.11. 단정 금지.

<!-- transcribed-by: _meta/scripts/transcribe_sticker_059.py from live-snapshot/latest (snap_20260702_1119) t_siz_sizes @ 2026-07-03 -->
| siz_cd | siz_nm | 작업(mm) | 재단(mm) | del_yn | note |
|---|---|---|---|---|---|
| SIZ_000520 | A4(210x297mm) 반칼 | 미기재 | 미기재 | N | 판걸이=2.0 / 적용=반칼스티커(058~061) / B02 낱장 SIZ_172와 분리(반칼 전용가) |
| SIZ_000521 | 330x470 | 330.00x470.00 | 320.00x460.00 | N | 전지(46계열)·반칼 스티커 표준전지 / 출처: 상품마스터260610·출력소재IMPORT |

<!-- transcribed-by: _meta/scripts/transcribe_sticker_059.py from live-snapshot/latest (snap_20260702_1119) t_prd_products @ 2026-07-03 -->
| min_qty | max_qty | qty_incr | 단위 |
|---|---|---|---|
| 4 | 10000 | 4 | QTY_UNIT.02 |

<!-- transcribed-by: _meta/scripts/transcribe_sticker_059.py from live-snapshot/latest (snap_20260702_1119) t_prc_component_prices COMP_STK_PRINT @ 2026-07-03 -->
가격경로 연결 증거(단가행 존재·★값 미전사): COMP_STK_PRINT 전체 6498행 · 059 SIZ_000520 참조 540행 ·
SIZ_000520 x {MAT_000153/084/242/155/156} 각 36행. (값 계산=evaluate_price 권위·D-18)

## 수량규칙 (product-local) {#qty}

### [qty-059] 반칼정사각스티커 수량규칙 {verified}
- type: bundle_qty
- anchor: t_prd_products/PRD_000059
- src: {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000059 (min_qty 4·max_qty 10000·qty_incr 4·qty_unit_typ_cd QTY_UNIT.02)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/_foundation/batch/qty_rule_audit_260702.py", source_locator: "수량 UI 권위=상품/사이즈 규칙(가격구간과 역할 분리)", captured_at: "2026-07-03", badge: verified, src_id: SR-27-qtyaudit}
- props: {min_max_incr_ref: "전사표(min 4·max 10000·incr 4)", bdl_unit_typ_cd: "QTY_UNIT.02", bundle_qtys_rows: 0, note: "상품레벨 수량규칙만·t_prd_product_bundle_qtys 0행(정상·규격 family 058~062 관례). 수량 UI 권위=상품/사이즈 규칙(가격구간과 역할 분리·pack §3.4·DEC_qty_audit_260702). min_qty는 가격 차원(COMP_STK_PRINT use_dims)에도 등장(수량구간). 형제 15 스티커 동형(qty-0xx)"}

---

## GAP 노드 (이 파일 단독 소유)

### [gap-059-coating-conflict] 코팅=자재 vs 공정 CONFLICT (BATCH-3·GAP-ST-1) {unknown}
- type: gap
- anchor: none  # 사유: 세 권위 충돌(라이브 코팅=자재 MAT_000155/156 · Q9 코팅=공정 PROC_000013 · 가격표 3컬럼=코팅 가격축) — 양립 곤란·미해소
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-sticker.md", source_locator: "문서:§3.9 BATCH-3·T-4·GAP-ST-1 Q-ST-A", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-stk}
- gap_what: "무광/유광코팅스티커(MAT_000155/156)가 자재로 적재됨 vs Q9 권위 코팅=공정(PROC_000013). 가격표는 비코팅/무광/유광 3컬럼(코팅=가격축). 어느 모델이 정답인지 미결"
- gap_fill_from: "실무진(Q-ST-A) — 코팅=공정 통일 시 MAT_000155/156 은퇴+PROC_000013 배선, 자재 유지 시 3컬럼 가격축 유지. 인간 승인 후 §7 dbmap"
- gap_owner: staff
- rel: {rel: references, target: material-MAT_000155, note: "이 자재가 CONFLICT 당사자(형제 소유 공유노드 참조)"}
- rel: {rel: references, target: material-MAT_000156, note: "이 자재가 CONFLICT 당사자(형제 소유 공유노드 참조)"}
- 본문: 코팅 3중 권위 충돌. 지어내지 않고 GAP으로 등재(단정 금지·팩 §3.9). 059는 이 CONFLICT의 살아있는 사례(무광/유광 자재 실재).

### [gap-059-spec-shape-cut] 규격형 형상 저장처·커팅공정 명칭 불일치 (GAP-ST-3·Q-ST-C) {unknown}
- type: gap
- anchor: none  # 사유: 규격형 058~062의 '정사각' 형상이 size에도 옵션에도 미저장 + 상품명 '반칼'(PROC_000054)과 라이브 바인딩 PROC_000055 불일치 — 형상/커팅 저장 모델 미결
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-sticker.md", source_locator: "문서:§3.2 GAP-ST-3·§3.6 커팅 Q-ST-C", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-stk}
- gap_what: "① 059 '정사각' 형상이 size(SIZ_000520=A4 시트)·옵션 어디에도 별도 저장 안 됨(066처럼 siz_nm 흡수 아님) ② 상품명 '반칼'(Kiss Cut=PROC_000054)인데 라이브 공정=PROC_000055 스티커완칼(family 058~062 공통) — 명칭↔공정 불일치"
- gap_fill_from: "실무진(Q-ST-C) — PROC_000055→054+param 교체 vs siz_nm 형상 통일 결정. 규격 family 일괄"
- gap_owner: staff
- rel: {rel: references, target: process-PROC_000055, note: "명칭 불일치 당사 공정(형제 소유 공유노드 참조)"}
- rel: {rel: references, target: size-SIZ_000520, note: "형상 미저장 사이즈(A4 시트)·형제 소유 공유노드 참조"}
- 본문: 규격 family 형상/커팅 모델 미결. 059는 GAP-ST-3의 대표 케이스. 라이브 사실(PROC_000055·SIZ_000520 A4)은 그래프에 기록, 해소 방향은 지어내지 않음.
