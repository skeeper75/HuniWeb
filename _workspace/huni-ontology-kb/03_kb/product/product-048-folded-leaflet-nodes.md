<!-- companion nodes for product-048 접지리플렛 — 공유 축/형제 노드에 없는 상품 전용 노드만 신설. -->
<!-- ★공유 파일(axis/*·formula/*·rule/*·index.md) 수정 금지 규칙에 따라, 기존에 없는 것만 여기 신설. -->
<!-- ★신규 mint = formula-PRF_FOLD_SUM(접지비 sub-formula·형제 027 PRF_DGP_E_FOIL이 product-027-nodes에 -->
<!--   지역 mint된 선례와 동형·needed_shared_nodes로 formula/digital-formulas 승격 보고) + GAP 3종. -->
<!-- ★사이즈/공정/판형/인쇄옵션/카테고리(CAT_000003)/구성요소(COMP_FOLD_CARD_2H)는 전부 기존 전역 노드 재사용(L-3). -->
<!-- ★수치(치수·사양·배선)는 전사 스크립트 transcribe_product_048.py 출력만(transcribed-by 마커). LLM 손전사 금지. -->

# product-048 전용 노드 (접지리플렛 — 상품 전용 마스터·전사·GAP)

[[product-048-folded-leaflet]]가 연결하는 축 중, **기존 전역 노드에 아직 없는 것만** 신설한다.
접지리플렛은 접지카드(027/029)와 계열이 가깝지만, 라이브가 **가격 경로 불완전·사이즈 0행·자재 46종
대량**이라 재사용이 기본이고 신규 mint는 **접지비 sub-formula(PRF_FOLD_SUM)** 뿐이다. 나머지 미커버
축은 지어내지 않고 GAP으로 선언한다.

## 재사용 목록 (신규 mint 아님 — 전역 노드 참조)

- **카테고리**: `category-CAT_000003` 인쇄홍보물([[axis/categories]]). CAT_000058 전단지/리플랫은
  미민팅(needed_shared_nodes) — 배선 유보.
- **인쇄옵션**: `printopt-POPT_000002` 양면([[axis/print-options]]). 신규 없음.
- **공정 4종**: PROC_000014/015(유광/무광라미네이팅)·PROC_000031/032(가변)([[axis/processes]]). 신규 없음.
- **판형**: `plate-OUTPUT_PAPER_TYPE_01` 국전계열([[axis/plate-sizes]]). 신규 없음.
- **자재 14종**: [[axis/materials]] 7(074/081/082/091/092/101/109)·[[product-027-nodes]] 2(108/123)·
  [[product-023-shaped-postcard-nodes]] 5(113/114/115/116/125). 나머지 30 종이자재=미민팅(needed_shared).
- **가격구성요소**: `component-COMP_FOLD_CARD_2H` 접지비 카드 2단([[formula/digital-components]]). 신규 없음.

---

## 정체·수량 (전사)

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

## 카테고리 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_048.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_categories+t_cat_categories prd_cd=PRD_000048 @ 2026-07-03 -->
| cat_cd | 분류명 | cat_lvl | upr_cat_cd | 노드 정의처 |
|---|---|---|---|---|
| CAT_000003 | 인쇄홍보물 | 1 |  | axis/categories |
| CAT_000058 | 전단지/리플랫 | 2 | CAT_000003 | 미민팅(needed_shared_nodes) |

## 사이즈 (전사·★0행)

<!-- transcribed-by: _meta/scripts/transcribe_product_048.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_sizes prd_cd=PRD_000048 @ 2026-07-03 -->
- 활성 사이즈 행(del_yn=N): **0행**  (★손님 재단사이즈 선택 축 라이브 미등록 — `gap-048-no-size`)

## 자재 46행 (전사)

자재 모델 = parent + usage_cd 단일 슬롯(USAGE.07·팩 §3.5). ★[HARD] 실무진이 IMPORT 시트로 등록한
자재는 "배선 안 됐다"고 삭제 금지([[rule/rules#RULE_import_material_no_delete]]) — 아래 비종이 2종도
삭제 판정이 아니라 오염 의심(candidate) 태깅이다.

<!-- transcribed-by: _meta/scripts/transcribe_product_048.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_materials+t_mat_materials prd_cd=PRD_000048 @ 2026-07-03 -->
- 활성 자재 행(del_yn=N): **46행**

| mat_cd | 자재명 | mat_typ | 규격(mm) | 평량(g) | usage | 노드 정의처 |
|---|---|---|---|---|---|---|
| MAT_000072 | 백색모조지 100g | MAT_TYPE.01 | 316x467 | 100 | USAGE.07 | 미민팅(needed_shared) |
| MAT_000073 | 백색모조지 120g | MAT_TYPE.01 | 316x467 | 120 | USAGE.07 | 미민팅(needed_shared) |
| MAT_000074 | 백색모조지 220g | MAT_TYPE.01 | 316x467 | 220 | USAGE.07 | axis/materials |
| MAT_000076 | 아트지 100g | MAT_TYPE.01 | 316x467 | 100 | USAGE.07 | 미민팅(needed_shared) |
| MAT_000077 | 아트지 120g | MAT_TYPE.01 | 316x467 | 120 | USAGE.07 | 미민팅(needed_shared) |
| MAT_000078 | 아트지 150g | MAT_TYPE.01 | 316x467 | 150 | USAGE.07 | 미민팅(needed_shared) |
| MAT_000079 | 아트지 180g | MAT_TYPE.01 | 316x467 | 180 | USAGE.07 | 미민팅(needed_shared) |
| MAT_000080 | 아트지 200g | MAT_TYPE.01 | 316x467 | 200 | USAGE.07 | 미민팅(needed_shared) |
| MAT_000081 | 아트지 250g | MAT_TYPE.01 | 316x467 | 250 | USAGE.07 | axis/materials |
| MAT_000082 | 아트지 300g | MAT_TYPE.01 | 316x467 | 300 | USAGE.07 | axis/materials |
| MAT_000086 | 스노우지 100g | MAT_TYPE.01 | 316x467 | 100 | USAGE.07 | 미민팅(needed_shared) |
| MAT_000087 | 스노우지 120g | MAT_TYPE.01 | 316x467 | 120 | USAGE.07 | 미민팅(needed_shared) |
| MAT_000088 | 스노우지 150g | MAT_TYPE.01 | 316x467 | 150 | USAGE.07 | 미민팅(needed_shared) |
| MAT_000089 | 스노우지 180g | MAT_TYPE.01 | 316x467 | 180 | USAGE.07 | 미민팅(needed_shared) |
| MAT_000090 | 스노우지 200g | MAT_TYPE.01 | 316x467 | 200 | USAGE.07 | 미민팅(needed_shared) |
| MAT_000091 | 스노우지 250g | MAT_TYPE.01 | 316x467 | 250 | USAGE.07 | axis/materials |
| MAT_000092 | 스노우지 300g | MAT_TYPE.01 | 316x467 | 300 | USAGE.07 | axis/materials |
| MAT_000095 | 앙상블 100g | MAT_TYPE.01 | 316x467 | 100 | USAGE.07 | 미민팅(needed_shared) |
| MAT_000096 | 앙상블 130g | MAT_TYPE.01 | 316x467 | 130 | USAGE.07 | 미민팅(needed_shared) |
| MAT_000097 | 앙상블 160g | MAT_TYPE.01 | 316x467 | 160 | USAGE.07 | 미민팅(needed_shared) |
| MAT_000098 | 앙상블 190g | MAT_TYPE.01 | 316x467 | 190 | USAGE.07 | 미민팅(needed_shared) |
| MAT_000099 | 앙상블 210g | MAT_TYPE.01 | 316x467 | 210 | USAGE.07 | 미민팅(needed_shared) |
| MAT_000101 | 랑데뷰 WH 240g | MAT_TYPE.01 | 316x467 | 240 | USAGE.07 | axis/materials |
| MAT_000102 | 랑데뷰 WH 310g | MAT_TYPE.01 | 316x467 | 310 | USAGE.07 | 미민팅(needed_shared) |
| MAT_000104 | 몽블랑 100g | MAT_TYPE.01 | 316x467 | 100 | USAGE.07 | 미민팅(needed_shared) |
| MAT_000105 | 몽블랑 130g | MAT_TYPE.01 | 316x467 | 130 | USAGE.07 | 미민팅(needed_shared) |
| MAT_000106 | 몽블랑 160g | MAT_TYPE.01 | 316x467 | 160 | USAGE.07 | 미민팅(needed_shared) |
| MAT_000107 | 몽블랑 190g | MAT_TYPE.01 | 316x467 | 190 | USAGE.07 | 미민팅(needed_shared) |
| MAT_000108 | 몽블랑 210g | MAT_TYPE.01 | 316x467 | 210 | USAGE.07 | product-027-nodes |
| MAT_000109 | 몽블랑 240g | MAT_TYPE.01 | 316x467 | 240 | USAGE.07 | axis/materials |
| MAT_000113 | 아코팩 | MAT_TYPE.01 | 316x467 | 250 | USAGE.07 | product-023-nodes |
| MAT_000114 | 리사이클러스 | MAT_TYPE.01 | 316x467 | 240 | USAGE.07 | product-023-nodes |
| MAT_000115 | 매쉬멜로우 | MAT_TYPE.01 | 316x467 | 233 | USAGE.07 | product-023-nodes |
| MAT_000116 | 린넨커버 | MAT_TYPE.01 | 316x467 | 216 | USAGE.07 | product-023-nodes |
| MAT_000117 | 스타화이트 | MAT_TYPE.01 | 316x467 | 238 | USAGE.07 | 미민팅(needed_shared) |
| MAT_000118 | 클래식 크래스트 | MAT_TYPE.01 | 316x467 | 270 | USAGE.07 | 미민팅(needed_shared) |
| MAT_000119 | 리브스디자인 250g | MAT_TYPE.01 | ?x? | 250 | USAGE.07 | 미민팅(needed_shared) |
| MAT_000120 | 매직터치 | MAT_TYPE.01 | 316x467 | 250 | USAGE.07 | 미민팅(needed_shared) |
| MAT_000121 | 켄도 | MAT_TYPE.01 | 316x467 | 250 | USAGE.07 | 미민팅(needed_shared) |
| MAT_000123 | 띤또레또 200g | MAT_TYPE.01 | 464x320 | 200 | USAGE.07 | product-027-nodes |
| MAT_000124 | 띤또레또 250g | MAT_TYPE.01 | 464x320 | 250 | USAGE.07 | 미민팅(needed_shared) |
| MAT_000125 | 한지 | MAT_TYPE.01 | 316x467 | 170 | USAGE.07 | product-023-nodes |
| MAT_000126 | 스코트랜드 | MAT_TYPE.01 | 316x467 | 220 | USAGE.07 | 미민팅(needed_shared) |
| MAT_000127 | 스타드림 | MAT_TYPE.01 | 316x467 | 240 | USAGE.07 | 미민팅(needed_shared) |
| MAT_000128 | 면끈 | MAT_TYPE.17 | 316x467 | 240 | USAGE.07 | ★오염의심(candidate·비종이) |
| MAT_000130 | 네오디움자석 | MAT_TYPE.03 | 316x467 | 240 | USAGE.07 | ★오염의심(candidate·비종이) |

- 요약: 기존 노드 재사용 **14** · 미민팅(공유 axis 대기) **30** · 오염의심(비종이) **2**

## 공정 4행 (전사·전부 재사용)

<!-- transcribed-by: _meta/scripts/transcribe_product_048.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_processes+t_proc_processes prd_cd=PRD_000048 @ 2026-07-03 -->
| proc_cd | 공정명 | mand | disp_seq | 노드 정의처 |
|---|---|---|---|---|
| PROC_000014 | 유광라미네이팅 | N | 1 | axis/processes |
| PROC_000015 | 무광라미네이팅 | N | 1 | axis/processes |
| PROC_000031 | 가변텍스트 | N | 10 | axis/processes |
| PROC_000032 | 가변이미지 | N | 11 | axis/processes |

- base 인쇄공정 PROC_000004 바인딩: **없음(★인쇄비 0 신호·§4-A 18건 COMMIT 목록에 048 미포함)**

## 인쇄옵션·판형 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_048.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_print_options / t_prd_product_plate_sizes prd_cd=PRD_000048 @ 2026-07-03 -->
| opt_id | print_side | front | back | print_opt_cd |
|---|---|---|---|---|
| 1 | 양면 | CLR_000005 | CLR_000005 | POPT_000002 |

| siz_cd | dflt | output_paper_typ_cd |
|---|---|---|
| SIZ_000499 | Y | OUTPUT_PAPER_TYPE.01 |

> plate 행의 siz_cd=SIZ_000499(316×467 국4절)는 **출력용지규격(판형)** 이지 손님 재단사이즈가
> 아니다(팩 §3.8·[[rule/rules#RULE_plate_paper_only]]). 손님 재단사이즈는 `t_prd_product_sizes` 0행.

## 가격공식 바인딩 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_048.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_price_formulas prd_cd=PRD_000048 @ 2026-07-03 -->
| frm_cd | apply_bgn_ymd | note |
|---|---|---|
| PRF_FOLD_SUM | 2026-06-01 | 접지리플렛→접지(오시+접지) 후가공 구성요소 |

## 공식→구성요소 배선 (전사·★접지비만)

<!-- transcribed-by: _meta/scripts/transcribe_product_048.py from live-snapshot/latest (snap_20260702_1119) t_prc_formula_components+t_prc_price_components (PRD_000048 바인딩 공식) prd_cd=PRD_000048 @ 2026-07-03 -->
- **PRF_FOLD_SUM** (접지 합산형(오시+접지 후가공 구성요소)) — 카드·리플렛 접지비. 제작수량 표에서 접지비를 찾아 상위 공식에 더함.

| disp | comp_cd | addtn | 구성요소명 | prc_typ | use_dims | 노드 정의처 |
|---|---|---|---|---|---|---|
| 1 | COMP_FOLD_CARD_2H | Y | 접지비 카드 2단 | PRICE_TYPE.01 | ["min_qty"] | formula/digital-components |

  - 배선 구성요소 수: **1** (★인쇄비 COMP_PRINT_DIGITAL_S1·용지비 COMP_PAPER 미배선 = 견적 접지비만)

## 옵션그룹·추가상품·제약·수량 (전사·전부 0)

<!-- transcribed-by: _meta/scripts/transcribe_product_048.py from live-snapshot/latest (snap_20260702_1119) 옵션그룹 / 추가상품 / 제약 / 수량규칙 카운트 prd_cd=PRD_000048 @ 2026-07-03 -->
- 옵션그룹(option_groups del_yn=N): 0
- 추가상품(addons): 0
- 활성 제약(constraints del_yn=N): 0
- bundle_qtys 행: 0  (0=상품 스칼라 수량규칙만)

---

## 가격공식 (price_formula) — ★신규 mint (접지비 sub-formula)

접지리플렛이 바인딩하는 PRF_FOLD_SUM은 공유 [[formula/digital-formulas]]에 아직 없어 여기 지역 mint한다
(형제 027의 PRF_DGP_E_FOIL이 product-027-nodes에 지역 mint된 선례와 동형). 향후 축 승격 대상
(needed_shared_nodes로 통합 단계 보고). ★이 공식은 **접지비 구성요소 1개만** 배선된 sub-formula이며,
048이 이를 단독 상품 공식으로 바인딩한 것이 가격 경로 불완전의 원인이다(아래 GAP).

### [formula-PRF_FOLD_SUM] 접지 합산형(접지비 sub-formula) {verified}
- type: price_formula
- anchor: t_prc_price_formulas/PRF_FOLD_SUM
- src: {source_file: "live-snapshot/latest/t_prc_price_formulas.csv", source_locator: "키:PRF_FOLD_SUM(frm_nm 접지 합산형)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prc_formula_components.csv", source_locator: "frm_cd:PRF_FOLD_SUM (구성요소 1건 COMP_FOLD_CARD_2H)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: has_component, target: component-COMP_FOLD_CARD_2H, qualifier: {disp_seq: 1, addtn: Y}}
- props: {archetype: "원자합산형(sub-formula)", use_yn: Y, note: "접지비만 배선(인쇄비/용지비 미포함)·공식 note '상위 공식에 더함'=sub-formula 설계. 048 단독 바인딩=가격 경로 불완전(gap-048-price-path-incomplete)"}

본문: PRF_FOLD_SUM은 접지비(COMP_FOLD_CARD_2H)를 제작수량(min_qty)으로 찾는 합산 sub-formula다.
`has_component` 배선 1개 보유(고아 공식 아님·O6 충족). 값 계산은 evaluate_price 권위
([[rule/rules#RULE_price_value_boundary]]).

---

## GAP (원천 부재·미해결 — 지어내지 않음)

### [gap-048-price-path-incomplete] 접지리플렛 가격 경로 불완전 {unknown}
- type: gap
- anchor: none  # 사유: 라이브가 접지비 sub-formula만 바인딩(인쇄/용지 미배선)·정답 배선은 §18/§26/§27 판정
- src: {source_file: "live-snapshot/latest/t_prd_product_price_formulas.csv", source_locator: "prd_cd:PRD_000048 frm_cd:PRF_FOLD_SUM 단독", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-digital-print.md", source_locator: "§3.11 DGP-PR-002 가격차단 048 plate 교정 대기", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-dp}
- gap_what: "048 접지리플렛은 PRF_FOLD_SUM(접지비 카드 2단 COMP_FOLD_CARD_2H 1건)만 바인딩 → 견적 = 접지비만. 인쇄비(COMP_PRINT_DIGITAL_S1)·용지비(COMP_PAPER)·코팅비 미배선 + base 공정 PROC_000004 미바인딩(§4-A 18건 COMMIT 목록에 048 미포함). KB 공식 축은 PRF_DGP_E를 '접지카드·접지리플렛' 완전 원자합산형으로 라벨 → 라이브 바인딩(PRF_FOLD_SUM) vs 후보(PRF_DGP_E) 불일치"
- gap_fill_from: "§18(가격공식 설계)·§26(적재 무결성)·§27(배선 수렴)에서 완전 공식 재바인딩/구성요소 배선 판정 후 §7 dbmap 적재(인간 승인). base 공정은 [[rule/decisions#DEC_baseproc_260701]] 동형 처리 대상"
- gap_owner: 설계
- rel: {rel: references, target: formula-PRF_FOLD_SUM, note: "불완전 바인딩 대상 공식"}

### [gap-048-no-size] 접지리플렛 손님 재단사이즈 축 미등록 {unknown}
- type: gap
- anchor: none  # 사유: t_prd_product_sizes 라이브 0행(판형만 등록·재단치수 미등록)
- src: {source_file: "live-snapshot/latest/t_prd_product_sizes.csv", source_locator: "prd_cd:PRD_000048 활성 0행", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- gap_what: "048은 손님이 고르는 재단사이즈(t_prd_product_sizes) 행이 0. 판형(출력용지 SIZ_000499 316×467)만 등록. 형제 접지카드 027/029가 사이즈 3행 보유한 것과 대비 — 리플렛 재단치수 선택 축 부재"
- gap_fill_from: "권위 엑셀 260702(인쇄홍보물/리플렛 사이즈열)·§26 적재 무결성으로 재단사이즈 도출 후 §7 적재(인간 승인). 파일 업로드 자유치수(작업자 판단)인지 여부도 함께 확인"
- gap_owner: 설계

### [gap-048-material] 접지리플렛 자재 46종 중 32 미커버(30 미민팅 + 2 오염의심) {unknown}
- type: gap
- anchor: none  # 사유: 공유 axis/materials 미민팅 30 + 비종이 오염의심 2(GAP_016_material 선례와 동형)
- src: {source_file: "live-snapshot/latest/t_prd_product_materials.csv", source_locator: "prd_cd:PRD_000048 활성 46행(14 노드 존재·30 미민팅·2 비종이)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-digital-print.md", source_locator: "§3.5 자재 모델·IMPORT 자재 삭제금지", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-dp}
- gap_what: "048 활성자재 46 중 14만 공유 노드 존재(배선). 30 종이자재(MAT_000072/073/076/077/078/079/080/086/087/088/089/090/095/096/097/098/099/102/104/105/106/107/117/118/119/120/121/124/126/127)는 공유 axis 미민팅 → 그래프 커버리지 공백. 비종이 2(MAT_000128 면끈 MAT_TYPE.17·MAT_000130 네오디움자석 MAT_TYPE.03)는 낱장 리플렛에 부적합=오염 의심(candidate·삭제 판정 아님·RULE_import_material_no_delete 준수)"
- gap_fill_from: "30 종이자재는 공유 axis/materials 일괄 mint(needed_shared_nodes) 후 048 uses_material 배선. 비종이 2종은 실무진/§7(굿즈 자재 오염 진단 선례 goods-material-contamination-260630)로 정오 판정 후 처리"
- gap_owner: 설계
