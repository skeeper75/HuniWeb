---
id: product-023-shaped-postcard
type: product
anchor: t_prd_products/PRD_000023
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000023 (del_yn=N·use_yn=N 미출시)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-digital-print.md", source_locator: "§3.1 정체(36 distinct·엽서 구분)·§3.11/§4-B 완칼 die-cut 교정(023 8.04M→120K)", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-dp}
  - {source_file: "live-snapshot/latest/t_prd_product_price_formulas.csv", source_locator: "테이블:t_prd_product_price_formulas 키:(PRD_000023,PRF_DGP_B) note:모양엽서 → PRF_DGP_B (use_yn=N 미출시)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
relations:
  - {rel: in_category, target: category-CAT_000307, note: "엽서(main_cat_yn=Y·disp 8)"}
  - {rel: in_category, target: category-CAT_000001, note: "엽서/카드 상위(main_cat_yn=Y·disp 8)"}
  - {rel: has_size, target: size-SIZ_000119, note: "90x90 완칼 재단(단일 사이즈·companion 민팅)"}
  - {rel: uses_material, target: material-MAT_000107, note: "몽블랑 190g·USAGE.07(companion 민팅)"}
  - {rel: uses_material, target: material-MAT_000109, note: "몽블랑 240g·USAGE.07(공유 축 재사용)"}
  - {rel: uses_material, target: material-MAT_000113, note: "아코팩 250g·USAGE.07(companion 민팅)"}
  - {rel: has_print_option, target: printopt-POPT_000001, note: "단면(front CMYK 4도·back 인쇄 안 함)"}
  - {rel: has_print_option, target: printopt-POPT_000002, note: "양면(front/back CMYK 4도)"}
  - {rel: has_process, target: process-PROC_000004, qualifier: mandatory, note: "디지털인쇄 base·mand_proc_yn=Y(07-01 18건 COMMIT 계열·인쇄비 원천)"}
  - {rel: has_process, target: process-PROC_000123, qualifier: mandatory, note: "완칼커팅·mand_proc_yn=Y(생산 라우팅·companion 민팅·2소비 상품 023/055)"}
  - {rel: has_plate_size, target: plate-OUTPUT_PAPER_TYPE_01, note: "국전(국4절) 출력용지 SIZ_000499·종이류라 판형 유효·fn_best_plate 자동선택"}
  - {rel: has_qty_rule, target: qty-023}
  - {rel: priced_by, target: formula-PRF_DGP_B, note: "원자합산형B(인쇄+용지+완칼)·완칼 die-cut 계열"}
props:
  prd_typ_cd: PRD_TYPE.01
  semi_role_cd: null
  file_upload_yn: Y
  editor_yn: N
  min_qty: 12
  max_qty: 10000
  qty_incr: 12
  qty_unit_typ_cd: QTY_UNIT.02
  use_yn: N
  del_yn: N
  구분: "엽서(디지털인쇄 완제품 단일·완칼 모양)"
  status_note: "use_yn=N 미출시(라이브 데이터 실재·화면 미노출) — 값 raw는 companion 전사표 권위(손전사 아님)"
standards: {schema_org: Product, xjdf: "Product(모양엽서)", config_ont: "component type"}
answers_cq: ["구체 상품 질의(모양엽서 구성·가격 경로)", "조건 탐색(완칼 모양 엽서)"]
tags: ["#디지털인쇄", "#엽서", "#완칼", "#원자합산형", "#미출시"]
updated: 2026-07-03
---

# product-023 모양엽서 (PRD_000023)

모양엽서는 디지털인쇄 **완제품 단일**(`prd_typ_cd=PRD_TYPE.01`)이다. 몽블랑/아코팩 낱장 용지에
칼라 단/양면 인쇄 후 **완칼(die-cut)** 로 90×90 모양대로 잘라내는 엽서(카테고리 = 엽서
`CAT_000307`·엽서카드 상위 `CAT_000001`). 파일 업로드 방식(`file_upload_yn=Y`, 에디터 미사용).
최소 12매·최대 10,000매·12매 증분(단위 QTY_UNIT.02 "매"). 수량·치수 raw 값은
[[product-023-shaped-postcard-nodes]] 전사표가 권위(스크립트 전사·손전사 금지).

★**미출시 상태(use_yn=N)** — 라이브 DB에 데이터는 실재(del_yn=N)하나 사용자 화면에 노출되지
않는다. 가격공식 바인딩 행 note가 이를 명기("모양엽서 → PRF_DGP_B (use_yn=N 미출시)"). 결함이
아니라 운영 상태이므로 badge=verified·양면 노드 아님(현재값=정답).

## 정체·유형 (SOT 준수)
- 상품유형 분류 SOT: **완제품(.01)** = 일반 단일 제조상품. 모양엽서는 `t_prd_product_sets` 부모
  등록이 없어(셋트 아님) 일반 단일 완제품(SOT 정합). 기성/디자인 아님(제조 상품).
- 구분 그룹 = "엽서"(디지털인쇄 7구분 중 하나·팩 §3.1). 형제 016 프리미엄엽서와 같은 엽서 카테고리·
  다른 공식(016=PRF_DGP_A 원자합산·023=PRF_DGP_B 완칼). 023은 라벨택 046과 **같은 완칼 공식**
  (PRF_DGP_B)을 공유하되 카테고리(엽서 vs 인쇄포장재)가 다르다.

## 차원
- **사이즈:** 1행(90x90·작업 92x92·재단 90x90) — 이산 사이즈 행(면적매트릭스 아님). 완칼 상품은
  대개 사이즈 소수. 치수 전사·판형연동은 [[product-023-shaped-postcard-nodes#size-SIZ_000119]].
  90×90의 판걸이수(UP수)는 **사이즈의 파생값**(`fn_calc_pansu` t_siz_pansu lookup→기하 폴백·
  [[rule/rules#RULE_pansu_db_function]]).
- **도수:** 인쇄옵션 코드값(칼라 단면 POPT_000001 / 양면 POPT_000002). 도수는 색상코드가
  아니다([[rule/rules#RULE_dosu_is_printopt]]). 라이브 색상수 코드 = 앞면 CLR_000005(CMYK 4도),
  단면의 뒷면 = CLR_000001(인쇄 안 함).
- **수량규칙:** 제품 레벨 min 12 / max 10,000 / incr 12(QTY_UNIT.02). `t_prd_product_bundle_qtys`
  에 023 행 **없음**(제품 레벨 규칙만). 수량 UI 권위 = 제품/사이즈 수량규칙(가격구간과 역할 분리·
  팩 §3.4). 하위 [[qty-023]] 노드.

## 자재·공정
- **자재:** 3종(몽블랑 190g `MAT_000107`·몽블랑 240g `MAT_000109`·아코팩 250g `MAT_000113`) —
  전부 parent + usage_cd 단일 슬롯(USAGE.07 default·정당·팩 §3.5). MAT_000109는 공유 축 재사용
  ([[axis/materials#material-MAT_000109]]), 107/113은 companion 민팅(공유 축 승격 후보).
  ★IMPORT 시트 등록 자재 삭제 금지([[rule/rules#RULE_import_material_no_delete]]).
- **공정:** 라이브 `t_prd_product_processes` = **2행** — PROC_000004(디지털인쇄 base·mand·disp -1)
  + **PROC_000123(완칼커팅·mand·disp 1·상위 PROC_000121 커팅)**. base 공정 미바인딩이면 인쇄비
  영구 0이 되는 결함을 교정한 계열([[rule/decisions#DEC_baseproc_260701]]·[[rule/rules#RULE_dataline_neq_wiring]]).
  - ★**완칼의 이중 표현(모델링 주의):** 023은 완칼을 **공정행(PROC_000123)** 으로도, **가격공식
    구성요소(COMP_CUT_FULL_DIECUT)** 로도 갖는다. 라벨택 046은 공정행 없이 구성요소로만 표현했다.
    공정행=생산 라우팅 메타, 구성요소=가격. 두 표현이 같은 물리 완칼을 가리킨다(중복 아님·역할 다름).

## 가격 경로 (D-18 경계 — 값은 evaluate_price 권위) — ★가격 경로 연결됨
- `product-023 --priced_by--> formula-PRF_DGP_B --has_component--> {COMP_PRINT_DIGITAL_S1(인쇄),
  COMP_PAPER(용지), COMP_CUT_FULL_DIECUT(완칼)}`. 배선 사슬은 공유 공식 노드
  [[formula/digital-formulas#formula-PRF_DGP_B]] · 구성요소 [[formula/digital-components]]에 이미 등재(재사용).
  **고아 공식 아님**(has_component 3개)·**끊긴 가격 사슬 아님**(priced_by 1개).
- 원자합산형B = [디지털출력] + [용지비] + [완칼 커팅비]. **판걸이수는 DB 함수 계산**(앱 아님·
  [[rule/rules#RULE_pansu_db_function]]).
- 완칼 단가(COMP_CUT_FULL_DIECUT)는 단가형×판수 이중적용 과대청구를 `.01→.03` 고정으로 교정한
  계열([[rule/decisions#DEC_diecut_260701]]·팩 §4-B: 023 8,040,000→120,000). use_dims=`[plt_siz_cd, min_qty]`
  (국4절 SIZ_000499 판형×수량구간·"작업 1건 고정 금액·수량 미곱"). 단, **절대값 골든은 pcode 미상으로
  미검증** → [[gap-023-diecut-golden]]로 정직 선언(지어내지 않음).
- ★COMP_CUT_FULL_DIECUT note="인쇄비+소재+커팅 **합가**"인데 공식이 COMP_PRINT_DIGITAL_S1·COMP_PAPER를
  **별도 배선**한다 → 이중합산 가능성. 판정은 evaluate_price/§26 소관(KB 경계 밖) →
  [[gap-023-diecut-combined-doublecount]]로 관찰 기록(정직 선언).

## 옵션·제약·추가상품 (라이브 실측 — 전부 미등록)
- **옵션그룹:** `t_prd_product_option_groups` = 023 행 **없음**(CPQ 옵션 미등록). 손님 선택 축은
  사이즈·도수·자재가 상품 차원(has_*)으로만 존재(옵션 레이어 미구성).
- **옵션아이템/제약:** `t_prd_product_option_items`·`t_prd_product_constraints` = 023 행 **없음**.
  완칼 모양×사이즈 물리제약 필요 여부는 미확정(§31 제약 하네스 소관·현재 GAP 아님·데모 미착수).
- **추가상품:** `t_prd_product_addons` = 023 행 **없음**(형제 016은 봉투 addon 5행 보유·023은 무연결).
- **셋트:** `t_prd_product_sets` = 023 행 **없음**(부품조립 셋트 아님·완제품 단일 SOT 정합).

## 승계·freshness 메모
- 정체·엽서 구분 = 팩 §3.1 FRESH 승계. "엽서 13종"류 STALE(T-2)는 023 무관(단일 사이즈).
- base 공정·완칼 교정은 위키에 없던 7월 신사실 — 팩 §4-A/§4-B 원장으로 재조준(T-6 오염 회피).
- use_yn=N 미출시는 라이브 현재 상태(권위=live-snapshot·판형/공식 note 정합).

---

## 이 상품 전용 하위 노드 (qty·gap)

> 공유 축에 없는 사이즈·자재·공정 축 노드는 [[product-023-shaped-postcard-nodes]] companion에
> 별도 민팅(027 방식·공유 axis/* 미수정). 아래는 상품-local 수량규칙 + 정직 GAP.

### [qty-023] 모양엽서 수량규칙 {verified}
- type: bundle_qty
- anchor: t_prd_products/PRD_000023
- src: {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000023 min_qty/max_qty/qty_incr", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/_foundation/batch/qty_rule_audit_260702.py", source_locator: "수량 UI 권위=상품/사이즈 규칙(가격구간과 역할 분리)", captured_at: "2026-07-03", badge: verified, src_id: SR-27-qtyaudit}
- props: {min_max_incr_ref: "companion 전사표(상품 12/10000/12)", bdl_unit_typ_cd: "QTY_UNIT.02", bundle_qtys_rows: 0}
- 본문: 수량 그릇 = 상품 마스터 컬럼(min 12·max 10000·incr 12·단위 "매"). `t_prd_product_bundle_qtys` 0행은 정상(수량 UI 권위=상품/사이즈 규칙·팩 §3.4 STALE 함정 회피). 사이즈별 수량규칙(per-size min/max) 미설정(단일 사이즈).

### [gap-023-diecut-golden] 완칼 단가 절대값 골든 미검증 {unknown}
- type: gap
- anchor: none  # 사유: COMP_CUT_FULL_DIECUT .03 고정 구조는 확정이나 예전사이트 절대값 골든이 pcode 미상으로 미대조(형제 046과 동류)
- src: {source_file: "_workspace/huni-price-table-integrity/_batch/diecut-flat-fix-260701-load.sql", source_locator: "문서:완칼 .01→.03 교정(023 8.04M→120K)·절대값 골든 pcode 미상 대기", captured_at: "2026-07-03", badge: unknown, src_id: SR-26-baseproc}
- gap_what: "모양엽서 완칼 단가(COMP_CUT_FULL_DIECUT·국4절 SIZ_000499×수량) .03 고정 교정 구조는 확정이나, 예전사이트 견적 절대값(골든)과의 대조가 pcode 미상으로 미검증"
- gap_fill_from: "pcode(예전사이트 상품코드) 매핑 후 골든 대조 — 팩 §4-E·§4-B(개발팀/§26 소관)"
- gap_owner: 개발
- rel: {rel: references, target: formula-PRF_DGP_B, note: "이 공식의 완칼 구성요소 골든 미검증"}
- 본문: 완칼 교정(DEC_diecut_260701)으로 과대청구 구조는 잡혔으나 절대값 정답 대조는 대기. 형제 [[gap-046-diecut-golden]]와 동류(같은 COMP_CUT_FULL_DIECUT). 지어내지 않고 정직 선언.

### [gap-023-diecut-combined-doublecount] 완칼 합가 vs 인쇄/용지 별도배선 이중합산 여부 {unknown}
- type: gap
- anchor: none  # 사유: COMP_CUT_FULL_DIECUT가 "인쇄+소재+커팅 합가"인데 공식이 인쇄/용지 구성요소를 별도 배선 — 이중합산 여부는 evaluate_price 계산 소관(KB 경계 밖)
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "테이블:t_prc_price_components 키:COMP_CUT_FULL_DIECUT note:인쇄비+소재+커팅 합가", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- gap_what: "PRF_DGP_B가 COMP_CUT_FULL_DIECUT(인쇄+소재+커팅 합가)와 COMP_PRINT_DIGITAL_S1·COMP_PAPER를 함께 배선 — 완칼 합가가 인쇄·용지를 이미 포함하면 이중합산 위험. 실제 evaluate_price에서 addtn/disp_seq·prc_typ.03 조합으로 상쇄되는지 미확인"
- gap_fill_from: "evaluate_price 재계산 실측(§26 무결성·§27 배선 검증) — KB는 배선 사실만 기록, 값 판정은 엔진 권위(D-18)"
- gap_owner: 엔진
- rel: {rel: references, target: formula-PRF_DGP_B, note: "합가 구성요소 이중합산 관찰"}
- 본문: 배선 자체는 라이브 실재(3구성요소). 다만 완칼 구성요소가 합가(인쇄+소재 포함)라 인쇄·용지 별도 배선과 겹칠 수 있다는 관찰. 판정은 KB 밖(evaluate_price)·정직 기록. 라벨택 046(공정행 없이 완칼 component만)과 대비하면 023의 이중표현이 이 관찰을 더 두드러지게 한다.
