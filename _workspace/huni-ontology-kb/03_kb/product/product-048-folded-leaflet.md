---
id: product-048-folded-leaflet
type: product
anchor: t_prd_products/PRD_000048
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000048", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/worklist-digitalprint-remaining.md", source_locator: "§1 인쇄홍보물 PRD_000048 접지리플렛(PRF_FOLD_SUM·판형 교정 대기)", captured_at: "2026-07-03", badge: verified, src_id: SR-worklist-dp}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-digital-print.md", source_locator: "§3.11 DGP-PR-002 가격차단 048 plate 교정 대기·§3.10 접지 원자합산형", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-dp}
relations:
  - {rel: in_category, target: category-CAT_000003}
  - {rel: has_print_option, target: printopt-POPT_000002}
  - {rel: has_process, target: process-PROC_000014, qualifier: {mand: N, note: "유광라미네이팅(코팅 옵션)"}}
  - {rel: has_process, target: process-PROC_000015, qualifier: {mand: N, note: "무광라미네이팅(코팅 옵션)"}}
  - {rel: has_process, target: process-PROC_000031, qualifier: {mand: N, note: "가변텍스트 옵션"}}
  - {rel: has_process, target: process-PROC_000032, qualifier: {mand: N, note: "가변이미지 옵션"}}
  - {rel: has_plate_size, target: plate-OUTPUT_PAPER_TYPE_01}
  - {rel: uses_material, target: material-MAT_000074}
  - {rel: uses_material, target: material-MAT_000081}
  - {rel: uses_material, target: material-MAT_000082}
  - {rel: uses_material, target: material-MAT_000091}
  - {rel: uses_material, target: material-MAT_000092}
  - {rel: uses_material, target: material-MAT_000101}
  - {rel: uses_material, target: material-MAT_000108}
  - {rel: uses_material, target: material-MAT_000109}
  - {rel: uses_material, target: material-MAT_000113}
  - {rel: uses_material, target: material-MAT_000114}
  - {rel: uses_material, target: material-MAT_000115}
  - {rel: uses_material, target: material-MAT_000116}
  - {rel: uses_material, target: material-MAT_000123}
  - {rel: uses_material, target: material-MAT_000125}
  - {rel: priced_by, target: formula-PRF_FOLD_SUM, note: "★접지비 sub-formula 단독 바인딩 — 인쇄비/용지비 미배선(가격 경로 불완전·gap-048-price-path-incomplete)"}
  # 끊긴 경로 GAP 배선(traversal 도달 — 038 derived_from/references 패턴 동형·O5는 priced_by로 이미 충족이라 references 사용)
  - {rel: references, target: gap-048-price-path-incomplete, note: "가격 경로 불완전(접지비만 배선)을 그래프 질의로 노출"}
  - {rel: references, target: gap-048-no-size, note: "손님 재단사이즈 축 라이브 0행(t_prd_product_sizes)을 그래프 질의로 노출"}
  - {rel: references, target: gap-048-material, note: "자재 46종 중 32 미커버(30 미민팅+2 오염의심)를 그래프 질의로 노출"}
props:
  prd_typ_cd: PRD_TYPE.01
  min_qty: 2
  max_qty: 100000
  qty_incr: 1
  qty_unit_typ_cd: QTY_UNIT.02
  file_upload_yn: Y
  editor_yn: N
standards: {schema_org: Product, xjdf: "Product(접지리플렛)·FoldingIntent", config_ont: "component type"}
updated: 2026-07-03
---

# product-048 · 접지리플렛 (PRD_000048)

디지털인쇄 **완제품 단일**(`PRD_TYPE.01`·[[product-type-classification-sot]] 정합·셋트 아님·
`t_prd_product_sets` 부모/구성원 미등록·라이브 실측 0행). **인쇄홍보물** 구분 그룹(팩 §0 7구분 중
"인쇄홍보물" 5상품 047~051 중 하나·전단지/리플렛 계열). 파일 업로드로 주문(`file_upload_yn=Y`·에디터
미사용 `editor_yn=N`). 형제 소량전단지(PRD_000047·미집필)·와이드 접지리플렛(PRD_000049·미집필)와
동형 계열(인쇄홍보물 047~051). 접지(fold) 홍보물 용도라 [[INTENT_cafe_opening]]와 연관(약참조).

★이 상품은 **가격 경로가 불완전**하다(현재값) — 팩 §3.11 DGP-PR-002 "가격차단 048"에 대응하는
라이브 상태를 정직 반영한다([[product-048-folded-leaflet-nodes]] GAP 3종). 결함 상태값은 지어내지
않고 GAP 노드로 선언한다.

## 정체·수량

<!-- transcribed-by: _meta/scripts/transcribe_product_048.py from live-snapshot/latest (snap_20260702_1119) t_prd_products prd_cd=PRD_000048 @ 2026-07-03 -->
| 필드 | 값 |
|---|---|
| prd_nm | 접지리플렛 |
| prd_typ_cd | PRD_TYPE.01 |
| min_qty | 2 |
| max_qty | 100000 |
| qty_incr | 1 |
| qty_unit_typ_cd | QTY_UNIT.02 |
| file_upload_yn | Y |
| editor_yn | N |
| use_yn | Y |
| del_yn | N |

- **수량 규칙:** 최소 2 · 최대 100000 · 증분 1 (단위 QTY_UNIT.02 "매"). `t_prd_product_bundle_qtys`·
  사이즈 수량규칙 행이 **라이브 0행**이라 수량 규칙 = **상품 스칼라**(min/max/incr)로만 표현된다
  (별도 `bundle_qty` 노드·`has_qty_rule` 엣지 없음 — 팩 §3.4 상품레벨 케이스·형제 029와 동일 패턴).

## 정체 — 카테고리

- **인쇄홍보물 CAT_000003**([[axis/categories#category-CAT_000003]]·cat_lvl 1) 에 연결(`in_category`).
  라이브 2번째 분류 **CAT_000058 전단지/리플랫**(cat_lvl 2·upr=CAT_000003)은 아직 공유 축 노드가
  아니라 배선을 유보한다 → needed_shared_nodes(통합 단계 mint 후 `in_category` 추가). 전사표는
  [[product-048-folded-leaflet-nodes]] 카테고리 절.

## 차원 — 사이즈·도수

- **사이즈 = 라이브 0행**(`t_prd_product_sizes` 활성 0). 손님이 고르는 재단사이즈 선택 축이
  등록돼 있지 않다 → [[product-048-folded-leaflet-nodes]] `gap-048-no-size`(정직 GAP·형제 접지카드
  027/029가 사이즈 3행 보유한 것과 대비). 판형(출력용지)만 등록돼 있고(아래) 재단치수는 미등록.
- **도수 = 인쇄옵션**([[rule/rules#RULE_dosu_is_printopt]]): [[printopt-POPT_000002]] 양면 전용
  (front/back CLR_000005 칼라·라이브 인쇄옵션 1행 opt_id=1). 색상코드가 아니다(T-4 함정 회피).

## 자재/공정 BOM

- **자재 46종**(전부 USAGE.07·낱장 단일 슬롯·MAT_TYPE.01 종이 44 + 비종이 2). 이 중 **14종은 기존
  전역 노드 재사용**(공유 [[axis/materials]] 7: MAT_000074/081/082/091/092/101/109 · [[product-027-nodes]]
  2: MAT_000108/123 · [[product-023-shaped-postcard-nodes]] 5: MAT_000113/114/115/116/125)으로 `uses_material`
  배선했다. **나머지 30종(종이·미민팅)은 공유 축 미민팅**이라 배선을 유보한다(GAP_016_material 선례와
  동일 패턴) → [[product-048-folded-leaflet-nodes]] `gap-048-material` + needed_shared_nodes.
  ★**비종이 2종(MAT_000128 면끈 MAT_TYPE.17 · MAT_000130 네오디움자석 MAT_TYPE.03)** 은 낱장 리플렛에
  부적합한 오염 의심([[rule/rules#RULE_import_material_no_delete]] 준수 — 삭제 판정 아님·candidate 태깅·
  실무진/§7 검토 대상). 전사표=[[product-048-folded-leaflet-nodes]] 자재 절(46행 전수).
- **공정 4행(전부 옵션·mand=N·기존 노드 재사용)**: 유광라미네이팅 [[axis/processes#process-PROC_000014]]·
  무광라미네이팅 [[axis/processes#process-PROC_000015]] (코팅 옵션) + 가변 2종 [[axis/processes#process-PROC_000031]]
  /[[axis/processes#process-PROC_000032]]. ★코팅·가변은 도수 아닌 공정(팩 §3.3). **신규 공정 노드 없음**(L-3).
  ★**base 인쇄공정 PROC_000004 미바인딩**(라이브 실측·§4-A 18건 COMMIT 목록에 048 미포함) — 인쇄비 0
  신호([[rule/rules#RULE_dataline_neq_wiring]])이며 가격 경로 GAP의 일부다(아래).
- **판형**: [[plate-OUTPUT_PAPER_TYPE_01]] 국전계열(316×467·종이류만·`fn_best_plate` 자동선택·고객
  미선택). 라이브 plate 행 = SIZ_000499(OUTPUT_PAPER_TYPE.01·dflt Y). 판걸이수는 파생
  (`fn_calc_pansu`·[[rule/rules#RULE_pansu_db_function]]). 46 종이자재 보유 상품이라 판형 유효
  ([[rule/rules#RULE_plate_paper_only]] 정합).

## 가격 경로 (priced_by → 공식 → has_component) — ★불완전(가격차단)

라이브 단일 바인딩 = [[product-048-folded-leaflet-nodes]] `formula-PRF_FOLD_SUM`(접지 합산형). 그러나
이 공식은 **구성요소 1개(COMP_FOLD_CARD_2H 접지비 카드 2단)만** 배선돼 있다 — 공식 자체 note가
"제작수량 표에서 접지비를 찾아 **상위 공식에 더함**"(즉 sub-formula 설계)이라, 048이 이를 **단독
상품 공식으로 바인딩**하면 견적은 **접지비만** 계산되고 **인쇄비([[formula/digital-components#component-COMP_PRINT_DIGITAL_S1]])·
용지비([[formula/digital-components#component-COMP_PAPER]])·코팅비**가 빠진다.

→ 정직 GAP: [[product-048-folded-leaflet-nodes]] `gap-048-price-path-incomplete`. KB 공식 축은
[[formula/digital-formulas#formula-PRF_DGP_E]]를 "접지카드·접지리플렛"(인쇄+용지+코팅+리플렛 접지
4종 완전 원자합산형)으로 라벨하므로, 라이브 바인딩(PRF_FOLD_SUM 접지비만) vs KB 후보(PRF_DGP_E)의
불일치를 §18/§26/§27 교정 트랙에 넘긴다(값·정답 배선은 이 KB가 단정하지 않음). base 공정
PROC_000004 미바인딩도 같은 계보([[rule/decisions#DEC_baseproc_260701]] 18건 COMMIT에 048 미포함).

가격 값 계산은 **evaluate_price 단일 권위**([[rule/rules#RULE_price_value_boundary]]·D-18) — KB는
"어떤 구성요소가 어떤 차원(use_dims)으로 붙나"까지만. 골든 스냅샷은 날짜 라벨로만 참조하며 이 노드에
수치 값을 기록하지 않는다(단가행은 D-22로 접음). 공식 노드는 `has_component` 배선 1개를 보유
(고아 공식 아님·O5/O6 구조 충족)하되, **기능적 완전성은 GAP으로 별도 선언**(구조 통과 ≠ 견적 정확).

## CPQ 옵션·제약 — 라이브 0건

live-snapshot 20260702_1119 실측: `t_prd_product_option_groups`/`options`/`option_items`·
`t_prd_product_constraints` **활성 0건**. 형제 접지카드(027/029)가 옵션그룹 5축을 가진 것과 대비되며,
048은 손님 선택 축(종이·후가공·접지 단수 등)이 CPQ로 표현돼 있지 않다(현재값). 이는 "제약 없음"이
아니라 "옵션 구성 미적재"에 가까우나, 필요 옵션·제약 도출은 §31(CN-1~CN-6)·§7(CPQ 적재) 소관이며
여기서는 옵션그룹/제약 노드를 만들지 않는다(원천 부재·현재값 반영). 가격 경로 GAP과 함께 준비도 낮음.

## 추가상품 (has_addon) — 라이브 0건

`t_prd_product_addons` **0행**(봉투 addon 미등록). 형제 접지카드가 봉투 addon(TMPL)을 가진 것과 대비.
추가 addon 도출은 §7/§23 소관(여기서는 GAP 미선언 — "없음"이 라이브 사실).

## 승계·출처

정체·구분·가격모델 힌트는 `worklist-digitalprint-remaining.md`(§1 인쇄홍보물 048)·`pack-digital-print.md`
(§3.10/§3.11)에서 승계(재검증 2026-07-03·prd_cd 라이브 실재 확인). 축·배선 수치는 전부
`transcribe_product_048.py` 스크립트 전사(손전사 금지). 라이브 현재값(snap_20260702_1119)을 "현재값"으로
표기하며, 가격 경로 불완전·사이즈 0행·자재 미민팅/오염의심은 권위(260702 엑셀/설계)와의 판정을 열어
GAP·candidate로 정직 선언한다(자기 검증·해소 단정 금지 — 별도 검증 레인 소관).
