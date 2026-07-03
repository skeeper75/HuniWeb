---
id: sticker-spec-circle
type: product
anchor: t_prd_products/PRD_000058
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000058 (반칼원형스티커·prd_typ_cd=PRD_TYPE.01·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-sticker.md", source_locator: "§0~5 스티커 파일럿(정체·형상=size·완제품가·코팅 CONFLICT·연당가 §4)", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-sticker}
  - {source_file: "live-snapshot/latest/t_prd_product_price_formulas.csv", source_locator: "테이블:t_prd_product_price_formulas 키:(PRD_000058,PRF_STK_FIXED)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
relations:
  - {rel: in_category, target: category-CAT_000002, note: "스티커(main_cat_yn=Y·disp 8)"}
  - {rel: in_category, target: category-CAT_000037, note: "규격스티커(부·main_cat_yn=N·disp 11·상위 CAT_000002)"}
  - {rel: has_size, target: size-SIZ_000170, note: "A5 148x210·dflt(가격격자 B01 col1 키)"}
  - {rel: has_size, target: size-SIZ_000520, note: "A4 반칼(시트 규격·라벨 인코딩)"}
  - {rel: has_plate_size, target: plate-058-SIZ_000521, note: "330x470·OUTPUT_PAPER_TYPE.02(46계열)·종이류=점착지 판형 유효·fn_best_plate"}
  - {rel: uses_material, target: material-MAT_000584, note: "유포스티커 80g·USAGE.07·MAT_TYPE.11"}
  - {rel: uses_material, target: material-MAT_000609, note: "미색스티커 모조 80g·USAGE.07"}
  - {rel: uses_material, target: material-MAT_000611, note: "아트스티커 90g·USAGE.07(07-01 재키잉 art-clone)"}
  - {rel: uses_material, target: material-MAT_000585, note: "무광코팅스티커·★코팅 CONFLICT(자재 vs 공정)"}
  - {rel: uses_material, target: material-MAT_000586, note: "유광코팅스티커·★코팅 CONFLICT"}
  - {rel: has_print_option, target: printopt-POPT_000001, note: "단면(front CMYK 4도·back 인쇄 안 함)·공유 축 재사용"}
  - {rel: has_process, target: process-PROC_000122, note: "반칼커팅(mand_proc_yn=N·상위 PROC_000121)"}
  - {rel: has_qty_rule, target: qty-058}
  - {rel: priced_by, target: formula-PRF_STK_FIXED, note: "스티커 완제품가 고정가 룩업(원자합산 아님)"}
  - {rel: has_option_group, target: optgroup-058-cutting, note: "커팅=원형 형상 25~90mm 10값(형상 저장처)"}
  - {rel: has_option_group, target: optgroup-058-print, note: "인쇄=단면 도수"}
  - {rel: has_option_group, target: optgroup-058-paper, note: "종이=자재 5종(코팅 포함)"}
props:
  prd_typ_cd: PRD_TYPE.01
  semi_role_cd: null
  file_upload_yn: Y
  editor_yn: Y
  min_qty: 4    # 전사표 권위(손전사 아님) <!-- lint-allow: L-12 src=SR-5-livesnap -->
  qty_unit_typ_cd: QTY_UNIT.02
  use_yn: Y
  del_yn: N
  구분: "스티커(반칼·규격원형·완제품 단일)"
  price_archetype: "완제품가 고정가 룩업(COMP_STK_PRINT·소재·규격·수량)"
  status_note: "라이브 출시(use_yn=Y)·수량/치수/격자 raw는 companion 전사표 권위"
standards: {schema_org: Product, xjdf: "Product(스티커)", config_ont: "component type"}
answers_cq: ["구체 상품 질의(반칼원형스티커 구성·가격 경로)", "조건 탐색(원형 스티커·코팅 선택)"]
tags: ["#스티커", "#반칼", "#규격원형", "#완제품가고정가", "#코팅CONFLICT"]
updated: 2026-07-03
---

# sticker-spec-circle 반칼원형스티커 (PRD_000058)

반칼원형스티커는 **완제품 단일**(`prd_typ_cd=PRD_TYPE.01`)이다. 점착지(유포/미색/아트/무광코팅/유광코팅)에
칼라 단면 인쇄 후 **반칼(Kiss Cut·`PROC_000122`)** 로 원형 모양대로 칼집만 내는(백지 유지) 스티커
(카테고리 = 스티커 `CAT_000002`·규격스티커 `CAT_000037`). 파일 업로드 + 에디터 양쪽(`file_upload_yn=Y·editor_yn=Y`).
최소 4매·증분 4매(단위 QTY_UNIT.02 "매"). 수량·치수·가격격자 raw 값은
[[sticker-spec-circle-nodes]] 전사표가 권위(스크립트 전사·손전사 금지·팩 §5-3).

★**스티커 파일럿의 3대 특성**(팩 §0)이 이 상품에 그대로 나타난다: ① **형상(원형 칼틀)이 곧 사이즈**이나
058은 형상을 size가 아닌 **CPQ 커팅 옵션값**으로 저장(모델 불일치·GAP-ST-3) ② **가격 = 완제품가(시트가격)
고정가 룩업**(원자합산 아님) ③ **코팅 자재 오적재 CONFLICT**(무광/유광코팅=자재 vs 공정)가 살아있다.

## 정체·유형 (SOT 준수)
- 상품유형 분류 SOT: **완제품(.01)** = 일반 단일 제조상품. 058은 `t_prd_product_sets` 부모 등록 없음(셋트 아님)
  → 일반 단일 완제품. 기성/디자인 아님(제조 상품). ★팩 §1.1·T-1: round-13 "전량 디자인상품(.04)" 서술은
  **STALE** — 라이브 재분류로 **PRD_TYPE.01(완제품)**이 현재값(SOT 정합·교정 완료).
- 카테고리 = 스티커(`CAT_000002` main) + 규격스티커(`CAT_000037` 부). 규격원형/정사각/직사각/띠지/팬시(058~062)
  같은 family(팩 §3.2 GAP-ST-3).

## 차원
- **사이즈:** t_prd_product_sizes active = **A5(SIZ_000170·dflt) + A4반칼(SIZ_000520)** 시트 규격 2행. 손님이
  고르는 **원형 형상(25~90mm)은 size가 아니라 CPQ 커팅 옵션값**(OPT-000031·아래 옵션 절) → 형상 저장처가
  066(형상=size)과 다름([[sticker-spec-circle#gap-058-shape-storage]]). 판걸이수(UP수)는 사이즈의 파생값
  (`fn_calc_pansu`·[[rule/rules#RULE_pansu_db_function]]). 치수 전사=[[sticker-spec-circle-nodes]].
- **도수:** 인쇄옵션 코드값(칼라 단면 POPT_000001·공유 축 재사용). 도수는 색상코드가 아니다
  ([[rule/rules#RULE_dosu_is_printopt]]). 앞면 CLR_000005(CMYK 4도)·뒷면 CLR_000001(인쇄 안 함).
- **수량규칙:** 제품 레벨 min 4·incr 4(QTY_UNIT.02). `t_prd_product_bundle_qtys` 058 행 **없음**(제품 레벨
  규칙만). 수량 UI 권위 = 제품/사이즈 수량규칙(가격구간과 역할 분리·팩 §3.4). 하위 [[sticker-spec-circle#qty-058]].

## 자재·공정
- **자재:** active 5종 — 유포스티커 80g `MAT_000584`·미색스티커 모조 80g `MAT_000609`·아트스티커 90g `MAT_000611`·
  무광코팅스티커 `MAT_000585`·유광코팅스티커 `MAT_000586`. 전부 **MAT_TYPE.11(스티커용지)** = 정답
  (팩 §3.5 C-ST-09 "종이→스티커" 정정 완료·라이브 note 실증). 07-01 재키잉으로 parent(153/242/155/156)는
  del_yn=Y·child variant active([[rule/decisions#DEC_wiring_round22_260702]]·팩 §4-C). 자재 마스터 노드
  [[sticker-spec-circle-nodes]]. ★IMPORT 등록 자재 삭제 금지([[rule/rules#RULE_import_material_no_delete]]).
  - ★**코팅 CONFLICT(BATCH-3·GAP-ST-1):** 무광/유광코팅스티커(585/586)는 라이브에서 **자재**(라미네이팅 내장
    스티커)로 적재됐으나 실무진 Q9 권위는 **코팅=공정 PROC_000013**. 가격표가 비코팅/무광/유광 3컬럼(코팅=가격축)
    이라 양립 곤란·미해소 → 단정 금지·[[sticker-spec-circle#gap-058-coating-conflict]] 양면 판단 보류(팩 §3.9·T-4).
- **공정:** active = **PROC_000122 반칼커팅**(상위 PROC_000121 커팅·mand_proc_yn=N) 1행. 삭제=PROC_000055
  도무송(07-01). ★**base 인쇄 공정(PROC_000004) 없음** — 스티커는 완제품가 룩업(COMP_STK_PRINT에 출력+가공
  내장)이라 원자합산 base 인쇄 바인딩이 불필요(디지털인쇄와 다른 가격 모델·결함 아님·팩 §3.10). 공정 마스터
  [[sticker-spec-circle-nodes]].

## 가격 경로 (D-18 경계 — 값은 evaluate_price 권위) — ★가격 경로 연결됨
- `sticker-spec-circle --priced_by--> formula-PRF_STK_FIXED --has_component--> component-COMP_STK_PRINT`.
  공식/구성요소 노드는 companion [[sticker-spec-circle-nodes]]에 신설(스티커 첫 등장·공유 축 승격 후보).
  **고아 공식 아님**(has_component 1개)·**끊긴 가격 사슬 아님**(priced_by 1개).
- ★**완제품가(시트가격) 고정가 룩업**(원자합산형 아님·팩 §3.10). COMP_STK_PRINT use_dims=`[siz_cd, mat_cd, min_qty]`
  (PRICE_TYPE.01). 가격 = 형상×치수×코팅 격자이나 058은 (siz_cd, mat_cd, min_qty) 키 조회. 격자 충전 실측
  (companion 전사표): COMP_STK_PRINT 6,498행 중 058 active 5소재에 각 500~540행 충전(예 A5×무광코팅 수량구간
  단가) → **silent-0 아님**(격자 실재·07-01 STK-RESTORE 재키잉). 값 raw는 전사표 권위(손전사 금지).
- ★**소재 연당가(원자재 원가)는 이 완제품가 격자에 직접 없다**(팩 §4-B — COMP_PAPER에 스티커 mat_cd 0행·
  소재 마스터에 가격 컬럼 없음). 058의 완제품 retail 가격표는 260702에서 무변경 → 라이브=권위 일치
  ([[sticker-spec-circle#gap-058-yeondangga]]). 판걸이수는 DB 함수 계산([[rule/rules#RULE_pansu_db_function]]).
- 완제품가 절대값(예전사이트 골든)은 pcode 미상으로 미대조 → [[sticker-spec-circle#gap-058-price-golden]] 정직 선언.

## 옵션·제약·추가상품
- **CPQ 옵션그룹(★실재):** 07-01 재키잉으로 3 active 그룹 배선 — **커팅**(OPT-000031·원형 25~90mm 10값·형상)·
  **인쇄**(OPT-000035·단면)·**종이**(OPT-000036·자재 5종). 그룹 노드 아래 절 참조. ★per-size 명명 그룹
  (OPT-000032~038 "원형 30mm" 등)은 **del_yn=Y로 정리**됨(커팅 그룹으로 통합·빈 orphan 그룹 아님).
  팩 §3.9 "CPQ 옵션 레이어 전면 미적재(BATCH-6)"는 058엔 **부분 반증**(옵션 레이어 실재) — live 재측정 정합.
- **제약규칙:** RULE_001 "A5 커팅"(RULE_TYPE.03) 1행 실재 — 아래 절. ★단 logic이 **삭제된 SIZ_000426**을
  참조(현 A5=SIZ_000170) → 유효성 의심([[sticker-spec-circle#gap-058-constraint-stale-size]]·§31 소관).
- **추가상품/셋트:** `t_prd_product_addons`·`t_prd_product_sets` = 058 행 **없음**(단품 인쇄물·팩 §3.12).

## 승계·freshness 메모
- 정체·형상=size·완제품가·코팅 CONFLICT 의미 = 팩 §0~5 FRESH 승계. round-13 "디자인상품(.04)"·"CPQ 전면
  미적재"류는 라이브 재분류/재키잉으로 재조준(T-1·T-6 오염 회피).
- 07-01 재키잉(자재 variant·CPQ 그룹·사이즈 복구)은 위키에 없던 신사실 — live-snapshot + 배선 HANDOFF round22
  원장으로 재조준([[rule/decisions#DEC_wiring_round22_260702]]).
- ★연당가 양면(defect) 판단 = **058은 해당 없음**(아래 GAP): 260702 연당가/국4절 변경은 투명/홀로/크라프트
  4소재 국한(전사표 diff)·058 소재(유포/미색/아트/코팅)는 **변경분 아님** → false-defect 방지 위해 dual 노드
  미생성(팩 §4-D "retail 무변경 dual 금지" 정합).

---

## 이 상품 전용 하위 노드 (qty·CPQ·constraint·gap)

> 축 마스터 노드(사이즈·자재·공정·판형·공식·구성요소)는 [[sticker-spec-circle-nodes]] companion에.
> 아래는 상품-local 수량규칙 + CPQ 옵션그룹 + 제약 + 정직 GAP.

### [qty-058] 반칼원형스티커 수량규칙 {verified}
- type: bundle_qty
- anchor: t_prd_products/PRD_000058
- src: {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000058 min_qty/qty_incr/qty_unit_typ_cd", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/_foundation/batch/qty_rule_audit_260702.py", source_locator: "수량 UI 권위=상품/사이즈 규칙(가격구간과 역할 분리)", captured_at: "2026-07-03", badge: verified, src_id: SR-27-qtyaudit}
- props: {min_incr_ref: "companion 전사표(상품 min 4·incr 4·단위 매)", bdl_unit_typ_cd: "QTY_UNIT.02", bundle_qtys_rows: 0}
- 본문: 수량 그릇 = 상품 마스터 컬럼(min 4·incr 4·단위 "매"). `t_prd_product_bundle_qtys` 0행은 정상(수량 UI 권위=상품/사이즈 규칙·팩 §3.4). 사이즈별 수량규칙(per-size)은 A5/A4 시트 규격 기준·형상별 EA(24ea/20ea…)는 커팅 옵션 라벨에 인코딩(bundle_qtys 아님).

### [optgroup-058-cutting] 커팅 (원형 형상 25~90mm) {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000058
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "테이블:t_prd_product_option_groups 키:(PRD_000058,OPT-000031) sel_typ=SEL_TYPE.01·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_options.csv", source_locator: "테이블:t_prd_product_options 그룹:OPT-000031 옵션값 10개(OPV-000066~075·원형 25/30/35/40/45/50/55/60/80/90mm·전사표)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {sel_typ_cd: "SEL_TYPE.01(단일)", opt_values: 10, note: "★형상(원형 칼틀) 저장처 = 이 커팅 그룹의 옵션값(라벨 '원형 NNmm (NNea)')·ref_dim 없음(size/자재 미참조 = 리터럴 형상)·066(형상=size)과 모델 불일치(GAP-ST-3)"}
- 본문: 반칼원형스티커의 **형상(칼틀)** 은 이 커팅 그룹의 옵션값 10개(원형 25~90mm·각 시트당 EA 인코딩)로 저장된다. 옵션값이 `ref_dim_cd`를 갖지 않아(size/자재 미참조) L-18 부모정합 대상 아님. 형상=size(066) vs 형상=옵션값(058) 불일치는 [[sticker-spec-circle#gap-058-shape-storage]].

### [optgroup-058-print] 인쇄 (도수) {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000058
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "테이블:t_prd_product_option_groups 키:(PRD_000058,OPT-000035) sel_typ=SEL_TYPE.01·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_option_items.csv", source_locator: "테이블:t_prd_product_option_items 키:(PRD_000058,OPV-000060) ref_dim_cd=OPT_REF_DIM.06(도수)·ref_key1=1", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {sel_typ_cd: "SEL_TYPE.01(단일)", opt_values: 1, note: "단면(OPV-000060)·OPT_REF_DIM.06 도수 참조(ref_key1=1)"}
- rel: {rel: option_refs, target: printopt-POPT_000001, ref_key1: "1", note: "도수 옵션값→인쇄옵션 차원(단면·공유 축)·fn_chk_opt_item_ref 정합(부모 has_print_option 실재)"}
- 본문: 인쇄 그룹은 단면 1값(도수 축·OPT_REF_DIM.06). 옵션참조 타깃=공유 인쇄옵션 printopt-POPT_000001(부모 058 has_print_option에 실재 → L-18 통과).

### [optgroup-058-paper] 종이 (자재) {candidate}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000058
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "테이블:t_prd_product_option_groups 키:(PRD_000058,OPT-000036) sel_typ=SEL_TYPE.01·del_yn=N", captured_at: "live 20260702_1119", badge: candidate, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_option_items.csv", source_locator: "테이블:t_prd_product_option_items 그룹 OPT-000036 5값(OPV-000061~065·ref_dim_cd=OPT_REF_DIM.03 자재·ref_key1=MAT_000584/609/611/585/586)", captured_at: "live 20260702_1119", badge: candidate, src_id: SR-5-livesnap}
- props: {sel_typ_cd: "SEL_TYPE.01(단일)", opt_values: 5, note: "★코팅(무광 585·유광 586)을 '종이'(자재) 옵션값으로 노출 = 코팅 CONFLICT(가격축 vs 공정)·badge=candidate"}
- rel: {rel: option_refs, target: material-MAT_000584, ref_key1: "MAT_000584", note: "유포스티커"}
- rel: {rel: option_refs, target: material-MAT_000609, ref_key1: "MAT_000609", note: "미색스티커"}
- rel: {rel: option_refs, target: material-MAT_000611, ref_key1: "MAT_000611", note: "아트스티커"}
- rel: {rel: option_refs, target: material-MAT_000585, ref_key1: "MAT_000585", note: "무광코팅스티커·코팅 CONFLICT"}
- rel: {rel: option_refs, target: material-MAT_000586, ref_key1: "MAT_000586", note: "유광코팅스티커·코팅 CONFLICT"}
- 본문: 종이 그룹은 자재 5값(OPT_REF_DIM.03). 5 타깃 모두 부모 058 uses_material에 실재(L-18 fn_chk_opt_item_ref 통과). 무광/유광코팅이 '종이'(자재) 축으로 노출됨 = 코팅 CONFLICT([[sticker-spec-circle#gap-058-coating-conflict]]) → 그룹 badge=candidate.

### [constraint-058-a5-cutting] A5 커팅 제약 (RULE_001) {candidate}
- type: constraint
- anchor: t_prd_product_constraints/PRD_000058
- src: {source_file: "live-snapshot/latest/t_prd_product_constraints.csv", source_locator: "테이블:t_prd_product_constraints 키:(PRD_000058,RULE_001) RULE_TYPE.03·logic 전사표(siz_cd SIZ_000426 + OPV-000066~073)", captured_at: "live 20260702_1119", badge: candidate, src_id: SR-5-livesnap}
- props: {rule_typ_cd: "RULE_TYPE.03", cn_type: "물리/규격 제약(§31 CN 분류 소관)", note: "★logic이 삭제된 SIZ_000426을 참조(현 A5=SIZ_000170) → 유효성 의심·badge=candidate"}
- rel: {rel: constrains, target: sticker-spec-circle, note: "A5×특정 원형커팅 조합 금지(NOT and)·단 참조 사이즈가 stale"}
- 본문: RULE_001은 "A5에서 특정 원형 커팅(OPV-000066~073) 동시 선택 금지" 형태(JSONLogic NOT·전사표). 그러나 logic이 **삭제된 SIZ_000426**을 참조(active A5=SIZ_000170)라 현행 사이즈에 매칭 안 될 수 있음 → 단정 금지·[[sticker-spec-circle#gap-058-constraint-stale-size]]. 폼빌더 정형 shape 여부·CN 분류·재작성은 §31 제약 하네스 소관(KB는 실재+의심 기록).

### [gap-058-coating-conflict] 코팅=자재 vs 공정 CONFLICT {unknown}
- type: gap
- anchor: none  # 사유: 라이브=자재(MAT_000585/586 스티커 variant) vs Q9 권위=공정(PROC_000013) vs 가격표 3컬럼(코팅=가격축) — 3원천 양립 곤란·미해소(BATCH-3)
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-sticker.md", source_locator: "§3.9 코팅 CONFLICT(BATCH-3·GAP-ST-1)·T-4(단정 금지)", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-sticker}
- gap_what: "무광/유광코팅스티커(MAT_000585/586)의 코팅 모델링 — 라이브=자재(라미네이팅 내장), 실무진 Q9=공정(PROC_000013), 가격표=비코팅/무광/유광 3컬럼(코팅=가격축). 어느 것이 정답인지 미확정"
- gap_fill_from: "실무진(Q-ST-A) 확인 + §31 제약/§7 자재 모델 결정 — 코팅=공정 통일 시 585/586 자재 은퇴+공정 바인딩"
- gap_owner: staff
- rel: {rel: references, target: material-MAT_000585, note: "코팅 CONFLICT 당사 자재"}
- rel: {rel: references, target: material-MAT_000586, note: "코팅 CONFLICT 당사 자재"}
- 본문: 코팅을 자재로 볼지 공정으로 볼지 3원천이 엇갈린다(팩 §3.9). KB는 양쪽 실재를 기록하되 단정하지 않음(T-4). 양면 노드가 아니라 GAP인 이유 = "현재값 vs 정답"의 정답이 아직 확정 안 됨(권위 미결).

### [gap-058-shape-storage] 원형 형상 저장처 모델 불일치 (GAP-ST-3) {unknown}
- type: gap
- anchor: none  # 사유: 058 원형 형상=CPQ 커팅 옵션값(OPT-000031) vs 066 합판=형상 흡수 size(siz_nm) — 같은 스티커 family인데 형상 저장 모델 불일치
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-sticker.md", source_locator: "§3.2 GAP-ST-3(규격형 058~062 형상 저장처·F-ST-5·C-ST-06·Q-ST-C)", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-sticker}
- gap_what: "058 반칼원형스티커의 원형 형상(25~90mm)이 CPQ 커팅 옵션값(OPT-000031)에 저장 — 066 합판도무송은 형상을 size(siz_nm)로 흡수. 규격형 058~062의 형상 저장처가 size인지 옵션값인지 prcs_dtl_opt param인지 미통일"
- gap_fill_from: "실무진(Q-ST-C) 확인 — 형상 모델 통일(size vs 옵션값 vs 공정 param). 058은 07-01 옵션값 방식으로 배선됨(live 신사실)이나 family 정합 미결"
- gap_owner: staff
- rel: {rel: references, target: optgroup-058-cutting, note: "형상이 저장된 커팅 옵션그룹"}
- 본문: 팩 §3.2 GAP-ST-3의 058 실측 = 형상이 CPQ 커팅 옵션값으로 산다(07-01 재키잉). 이는 팩이 예상한 "형상이 size에도 prcs_dtl_opt에도 없음"을 **부분 갱신**(옵션값에 실재)하나, 066(형상=size)과의 모델 불일치는 그대로 열림.

### [gap-058-yeondangga] 소재 연당가 저장처 부재 (058 소재는 260702 변경분 아님) {unknown}
- type: gap
- anchor: none  # 사유: 스티커 소재 연당가(원자재 원가)가 라이브 어디에도 가격노드로 저장 안 됨(§4-B) — 단 058 소재는 260702 연당가 변경 4소재에 미포함(dual 불요)
- src: {source_file: "_workspace/huni-ontology-kb/_meta/scripts/transcribe_sticker_058.py", source_locator: "260702 price-diff 전사(연당가 변경=투명/홀로/크라프트/투명후지 4소재만·058 유포/미색/아트/코팅 무변경)", captured_at: "2026-07-03", badge: unknown, src_id: SR-2.2-diff}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-sticker.md", source_locator: "§4-B(연당가 저장처 부재)·§4-D(retail 무변경 dual 금지)", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-sticker}
- gap_what: "스티커 소재 연당가(원자재 원가)가 t_mat_materials(가격 컬럼 없음)·COMP_PAPER(스티커 mat_cd 0행) 어디에도 저장 안 됨(systemic·§4-B). 058 소재(유포/미색/아트/무광코팅/유광코팅)는 260702 연당가 변경 4소재(투명/홀로/크라프트/투명후지)에 미포함 → 058 자체는 양면(defect) 노드 불요"
- gap_fill_from: "연당가 저장처 신설·재적재 워크리스트 owner = 투명(053/056/063)·홀로(054) 소재 상품 노드의 양면 defect + 크라프트는 라이브 상품 미사용이라 axis material-MAT_000164 양면 노드(owner). 058은 retail 완제품가(무변경)로 가격 성립 → 058 dual 불필요(실무진+인간 승인·팩 §4-D)"
- gap_owner: staff
- rel: {rel: references, target: component-COMP_STK_PRINT, note: "058 가격은 완제품가 격자로 성립(연당가 원가 미참조)"}
- rel: {rel: references, target: material-MAT_000164, note: "크라프트 연당가 재적재 owner(라이브 상품 미사용→axis 소유·허위 위임 교정 D-STK-01)"}
- 본문: ★연당가 양면 노드 판정 = **058은 FALSE(dual 불요)**. 근거(전사 diff): 260702 연당가/국4절 급변은 투명스(130k→149.5k)·홀로(360k→253.7k)·크라프트(156k→81.5k)·투명후지(신규 222k) 4소재 국한 — 058 소재는 무변경. 완제품 retail 가격표도 무변경(팩 §4-D) → false-defect 방지 위해 dual 노드 미생성. 단 "연당가 저장처 부재" systemic 이슈는 스티커 전반에 열림(GAP).

### [gap-058-price-golden] 완제품가 절대값 골든 미검증 {unknown}
- type: gap
- anchor: none  # 사유: COMP_STK_PRINT 격자 충전은 확정이나 예전사이트 절대값 골든이 pcode 미상으로 미대조(023/051과 동류)
- src: {source_file: "live-snapshot/latest/t_prc_component_prices.csv", source_locator: "테이블:t_prc_component_prices COMP_STK_PRINT 058 격자 충전 실재(전사표)·절대값 골든 pcode 미상", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- gap_what: "058 완제품가(COMP_STK_PRINT·소재×규격×수량) 격자 충전은 실측 확인되나, 예전사이트 견적 절대값(골든)과의 대조가 pcode 미상으로 미검증"
- gap_fill_from: "pcode(예전사이트 상품코드) 매핑 후 골든 대조 — 개발팀/§26 소관"
- gap_owner: 개발
- rel: {rel: references, target: formula-PRF_STK_FIXED, note: "이 공식의 완제품가 골든 미검증"}
- 본문: 격자 실재(silent-0 아님)로 가격 계산 가능성은 확인. 절대값 정답 대조는 대기(형제 [[product-023-shaped-postcard#gap-023-diecut-golden]]와 동류·지어내지 않고 정직 선언).

### [gap-058-constraint-stale-size] 제약 RULE_001 참조 사이즈 stale {unknown}
- type: gap
- anchor: none  # 사유: RULE_001 logic이 삭제된 SIZ_000426을 참조(현 A5=SIZ_000170) — 제약이 현행 사이즈에 매칭 안 될 수 있음
- src: {source_file: "live-snapshot/latest/t_prd_product_constraints.csv", source_locator: "테이블:t_prd_product_constraints RULE_001 logic siz_cd=SIZ_000426(t_prd_product_sizes del_yn=Y)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- gap_what: "제약 RULE_001(A5 커팅)의 JSONLogic이 삭제된 SIZ_000426을 참조 — 07-01 사이즈 재키잉으로 A5가 SIZ_000170으로 바뀌었으나 제약 logic은 미갱신. 제약이 현행 A5에 발동 안 될 수 있음"
- gap_fill_from: "§31 제약 하네스 — logic siz_cd를 SIZ_000170으로 갱신 or 재작성(폼빌더 정형 shape)·인간 승인 후 COMMIT"
- gap_owner: staff
- rel: {rel: references, target: constraint-058-a5-cutting, note: "stale 사이즈 참조 제약"}
- 본문: 재키잉 후 제약 logic이 옛 사이즈 코드에 고착된 drift. KB는 실재+drift를 기록, 교정은 §31 소관.
