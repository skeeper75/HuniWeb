---
id: product-030-zigzag-postcard
type: product
anchor: t_prd_products/PRD_000030
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000030 (use_yn=Y·del_yn=N 출시)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-digital-print.md", source_locator: "§3.1 정체(36 distinct·접지카드 구분)·§3.6 접지 공정·§4-E 3절 라인(112/049/030) 동형처리", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-dp}
  - {source_file: "live-snapshot/latest/t_prd_product_price_formulas.csv", source_locator: "테이블:t_prd_product_price_formulas 키:(PRD_000030,PRF_DGP_C_6CR) note:3절 판형이관+6단접지 공식 신설 260701", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
relations:
  - {rel: in_category, target: category-CAT_000021, note: "접지카드(upr CAT_000001·main_cat_yn=N·disp 1)"}
  - {rel: in_category, target: category-CAT_000001, note: "엽서/카드 상위(main_cat_yn=Y·disp 10)"}
  - {rel: has_size, target: size-SIZ_000031, note: "600x150 지그재그 가로(companion 민팅·dflt Y)"}
  - {rel: has_size, target: size-SIZ_000032, note: "150x600 지그재그 세로(companion 민팅·dflt Y)"}
  - {rel: uses_material, target: material-MAT_000110, note: "몽블랑 130g (3절)·USAGE.07·활성(companion 민팅). ★구자재 MAT_000105는 07-01 논리삭제(교체)"}
  - {rel: has_print_option, target: printopt-POPT_000002, note: "양면 전용(front/back CMYK 4도)·단면 미제공"}
  - {rel: has_process, target: process-PROC_000004, qualifier: mandatory, note: "디지털인쇄 base·mand_proc_yn=Y(07-01 06:56 추가·인쇄비 원천)"}
  - {rel: has_process, target: process-PROC_000073, qualifier: {mand: N, note: "6단오시접지 옵션(companion 민팅·상위 PROC_000056 접지)"}}
  - {rel: has_process, target: process-PROC_000074, qualifier: {mand: N, note: "6단미싱접지 옵션(companion 민팅·상위 PROC_000056)"}}
  - {rel: has_plate_size, target: plate-OUTPUT_PAPER_TYPE_03, note: "3절 판형이관(OUTPUT_PAPER_TYPE.03 기타·SIZ_000475 330x660·06-30 이관·companion 민팅)"}
  - {rel: has_qty_rule, target: qty-030}
  - {rel: priced_by, target: formula-PRF_DGP_C_6CR, note: "원자합산형C-6단접지(인쇄+용지+6단접지비+타공)·07-01 신설(companion 민팅)"}
  - {rel: has_option_group, target: optgroup-OPT-000028, note: "인쇄(양면)"}
  - {rel: has_option_group, target: optgroup-OPT-000029, note: "종이(★삭제자재 참조 불일치)"}
  - {rel: has_option_group, target: optgroup-OPT-000030, note: "접지(6단오시/6단미싱)"}
props:
  prd_typ_cd: PRD_TYPE.01
  semi_role_cd: null
  file_upload_yn: Y
  editor_yn: N
  min_qty: 2
  max_qty: 10000
  qty_incr: 2
  qty_unit_typ_cd: QTY_UNIT.02
  use_yn: Y
  del_yn: N
  구분: "접지카드(디지털인쇄 완제품 단일·6단접지 지그재그)"
standards: {schema_org: Product, xjdf: "Product(지그재그엽서)·FoldingIntent(6-fold zigzag)", config_ont: "component type"}
answers_cq: ["구체 상품 질의(지그재그엽서 구성·가격 경로)", "조건 탐색(6단접지 카드)"]
tags: ["#디지털인쇄", "#접지카드", "#6단접지", "#원자합산형", "#3절판형", "#출시"]
updated: 2026-07-03
---

# product-030 지그재그엽서 (PRD_000030)

지그재그엽서는 디지털인쇄 **완제품 단일**(`prd_typ_cd=PRD_TYPE.01`)이다. 몽블랑 130g 낱장 용지에
**양면**(CMYK 4도) 인쇄 후 **6단접지**(오시 또는 미싱·아코디언식 지그재그로 6번 접음)하는
접지카드다. 카테고리 = 접지카드 `CAT_000021`(엽서/카드 `CAT_000001` 하위). 파일 업로드 방식
(`file_upload_yn=Y`·에디터 미사용 `editor_yn=N`). 최소 2매·최대 1만매·2매 증분(단위
QTY_UNIT.02 "매"·2-up folding 특성). 수량·치수·배선 raw 값은
[[product-030-zigzag-postcard-nodes]] 전사표가 권위(스크립트 전사·손전사 금지).

★**출시 상태(use_yn=Y·del_yn=N)** — 사용자 화면에 노출되는 정상 운영 상품. 형제 027(2단접지카드)이
접지 2단인 데 비해 030은 **6단(6크리즈) 지그재그**이며, 이 때문에 07-01에 **전용 공식
`PRF_DGP_C_6CR`**(6단접지비 `COMP_FOLD_CARD_6CR` 교체)과 **3절 판형이관**(`OUTPUT_PAPER_TYPE.03`)이
신설됐다(팩 §4-E "3절 라인 112/049/030 동형처리"의 030 실현).

## 정체·유형 (SOT 준수)
- 상품유형 분류 SOT: **완제품(.01)** = 일반 단일 제조상품. 지그재그엽서는 `t_prd_product_sets`
  부모 등록이 없어(셋트 아님) 일반 단일 완제품(SOT 정합·[[product-type-classification-sot]]). 기성/디자인
  아님(제조 상품).
- 구분 그룹 = "접지카드"(디지털인쇄 7구분 중 하나·팩 §0/§3.1). 형제 027(2단접지카드·`PRF_DGP_E`)과
  같은 접지카드 카테고리·다른 공식(030=`PRF_DGP_C_6CR` 6단접지). 접지 단수(2단 vs 6단)가 공식·판형을
  가른다.

## 차원 — 사이즈·도수·수량
- **사이즈:** 2행 — SIZ_000031(600×150 가로 지그재그)·SIZ_000032(150×600 세로 지그재그). **둘 다
  dflt_yn=Y**(가로/세로 방향 택일·펼침 치수 604×154 동일·접는 방향만 다름). 이산 사이즈 행
  (면적매트릭스 아님·팩 §3.2). 치수 전사는 [[product-030-zigzag-postcard-nodes#size-SIZ_000031]]·
  [[product-030-zigzag-postcard-nodes#size-SIZ_000032]]. 판걸이수(UP수)는 사이즈의 파생값
  (`fn_calc_pansu`·[[rule/rules#RULE_pansu_db_function]]·라이브 note "판걸이=2.0" 기록).
- **도수:** 인쇄옵션 코드값 **양면 전용**(POPT_000002·front/back CLR_000005 CMYK 4도). 단면 미제공.
  도수는 색상코드가 아니다([[rule/rules#RULE_dosu_is_printopt]]·T-4 함정 회피).
- **수량규칙:** 제품 레벨 min·max·incr는 [[qty-030]] 전사표 권위(QTY_UNIT.02). `t_prd_product_bundle_qtys`에
  030 행 **없음**(제품 레벨 규칙만·수량 UI 권위=제품/사이즈 규칙·팩 §3.4). 하위 [[qty-030]] 노드.

## 자재·공정 BOM
- **자재:** 활성 1종 — 몽블랑 130g (3절) `MAT_000110`(parent MAT_000103·USAGE.07 단일 슬롯·팩 §3.5).
  ★**구자재 몽블랑 130g `MAT_000105`는 07-01 논리삭제**(del_yn=Y·3절 판형이관과 동시 교체). 그러나
  종이 옵션(OPV-000056)은 여전히 삭제된 MAT_000105를 참조 → 불일치를
  [[gap-030-paper-optref-mismatch]]로 정직 선언. IMPORT 등록 자재 삭제 금지 규칙
  ([[rule/rules#RULE_import_material_no_delete]])과 별개(여기선 자재 교체가 이미 라이브 실재).
- **공정:** 라이브 `t_prd_product_processes` = **3행** —
  - PROC_000004(디지털인쇄 base·mand·disp -1) — base 공정 미바인딩이면 인쇄비 영구 0이 되는 결함을
    교정한 계열([[rule/decisions#DEC_baseproc_260701]]·[[rule/rules#RULE_dataline_neq_wiring]]).
  - PROC_000073(6단오시접지·opt·상위 PROC_000056 접지)·PROC_000074(6단미싱접지·opt) — 접지 방식
    택일(오시=접는 자국·미싱=절취선식 접기). 접지는 공정이지 도수 아님(팩 §3.3). 두 공정은 공유
    axis/processes 미등재 → companion 민팅([[product-030-zigzag-postcard-nodes#process-PROC_000073]]·
    [[product-030-zigzag-postcard-nodes#process-PROC_000074]])·공유 축 승격 후보(needed_shared_node).
- **판형:** [[plate-OUTPUT_PAPER_TYPE_03]] **3절(기타·OUTPUT_PAPER_TYPE.03)** — 디지털 대다수가
  국전(.01)인 것과 달리 030은 3절 판형이관(06-30 SIZ_000142/143→SIZ_000475 330×660 교체). 종이류라
  판형 유효([[rule/rules#RULE_plate_paper_only]])·`fn_best_plate` 자동선택·고객 미선택. 공유
  axis/plate-sizes에 .03 미등재 → companion 민팅·승격 후보.

## 가격 경로 (D-18 경계 — 값은 evaluate_price 권위) — ★가격 경로 연결됨
- `product-030 --priced_by--> formula-PRF_DGP_C_6CR --has_component--> {COMP_PRINT_DIGITAL_S1(인쇄),
  COMP_PAPER(용지), COMP_FOLD_CARD_6CR(6단접지비), COMP_CUT_PERF_1H6(타공)}`. 공식·6단접지 구성요소는
  공유 축에 없어 companion에 민팅([[product-030-zigzag-postcard-nodes#formula-PRF_DGP_C_6CR]]·
  [[product-030-zigzag-postcard-nodes#component-COMP_FOLD_CARD_6CR]])하고, 인쇄·용지·타공 구성요소는
  공유 [[formula/digital-components]] 재사용. **고아 공식 아님**(has_component 4개)·**끊긴 가격
  사슬 아님**(priced_by 1개).
- 원자합산형C-6단접지 = [디지털출력] + [용지비] + [6단접지비] + [타공비]. 공식 note="PRF_DGP_C
  복제+6단접지(COMP_FOLD_CARD_6CR) 교체. 인쇄비+용지비+6단접지비+타공비(미등록시0). 260701 지그재그엽서
  전용 신설". 6단접지비(COMP_FOLD_CARD_6CR) use_dims=`["min_qty"]`("접지 종류·주문수량 구간별 작업 1건
  고정 금액·수량 미곱"). **판걸이수는 DB 함수 계산**(앱 아님·[[rule/rules#RULE_pansu_db_function]]).
- 가격 값 계산은 **evaluate_price 단일 권위**([[rule/rules#RULE_price_value_boundary]]·D-18) — KB는
  "어떤 구성요소가 어떤 차원(use_dims)으로 붙나"까지만. 골든 스냅샷은 날짜 라벨(live 20260702_1119)로만
  참조하며 이 노드에 수치 값을 기록하지 않는다(단가행은 D-22로 접음).

## CPQ 옵션 (has_option_group) — 3그룹
손님이 고르는 선택 축 3종(전부 SEL_TYPE.01 단일선택·mand N):
- **인쇄** [[optgroup-OPT-000028]] — 양면(고정·POPT_000002).
- **종이** [[optgroup-OPT-000029]] — 몽블랑 130g. ★옵션값이 **삭제된 MAT_000105**를 참조(활성 상품자재는
  MAT_000110) → option_refs 배선 유보·[[gap-030-paper-optref-mismatch]] 관찰.
- **접지** [[optgroup-OPT-000030]] — 6단오시접지(PROC_000073)/6단미싱접지(PROC_000074) 택일.

각 옵션값은 다형참조 `ref_dim_cd`+`ref_key1`로 실물 차원(인쇄옵션/자재/공정)을 가리킨다(R11·같은 부모
prd_cd에 실재 필수·`fn_chk_opt_item_ref`·L-18). 노드 정의는 [[product-030-zigzag-postcard-nodes]].

## 제약 (constraint) — 현재 0건
live-snapshot 20260702_1119 실측: `t_prd_product_constraints`에서 PRD_000030 **활성 제약 0건**. 접지
방식×사이즈 물리제약이 도메인상 있을 수 있으나 현재 등록된 정형 제약규칙은 없다(§31 거버넌스 소관).
결함이 아니라 "현재값"이며 제약 노드를 만들지 않는다(원천 부재 아님·"제약 없음"이 라이브 사실).

## 추가상품 (has_addon) — 봉투 2템플릿 (대상 상품 미노드 → GAP)
OPP접착봉투(TMPL-000005→PRD_000001)·OPP비접착봉투(TMPL-000006→PRD_000002)를 addon으로 딸 수 있으나,
대상 봉투 상품이 아직 KB 노드가 아니라 has_addon 엣지는 유보한다 → [[gap-030-addon-envelope]]
(정직 GAP 선언).

## 승계·freshness 메모
- 정체·접지카드 구분 = 팩 §3.1 FRESH 승계(round-13 정체 의미 시점 무관).
- 6단접지 공식·3절 판형이관·base 공정은 **07월 신사실**(위키에 없음) — 팩 §4-A(base 공정)·§4-E(3절
  라인) 원장 + live-snapshot로 재조준(T-6 오염 회피).
- 라이브 현재값(snap_20260702_1119)과 권위 260702 충돌 미대조 항목 없음(자재 교체·판형이관·공식신설은
  전부 라이브 COMMIT 실재). 종이 옵션의 삭제자재 참조만 미해소 관찰(GAP).

---

## 이 상품 전용 하위 노드 (qty·gap)

> 축(사이즈·자재·공정·판형·공식·구성요소·옵션그룹) companion 노드는 [[product-030-zigzag-postcard-nodes]]에
> 별도 민팅(023/027 방식·공유 axis/* 미수정). 아래는 상품-local 수량규칙 + 정직 GAP 3종.

### [qty-030] 지그재그엽서 수량규칙 {verified}
- type: bundle_qty
- anchor: t_prd_products/PRD_000030
- src: {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000030 min_qty/max_qty/qty_incr", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/_foundation/batch/qty_rule_audit_260702.py", source_locator: "수량 UI 권위=상품/사이즈 규칙(가격구간과 역할 분리)", captured_at: "2026-07-03", badge: verified, src_id: SR-27-qtyaudit}
- props: {min_max_incr_ref: "companion 전사표(상품 2/10000/2)", bdl_unit_typ_cd: "QTY_UNIT.02", bundle_qtys_rows: 0}
- 본문: 수량 그릇 = 상품 마스터 컬럼(min 2·max 10000·incr 2·단위 "매"). `t_prd_product_bundle_qtys` 0행은 정상(수량 UI 권위=상품/사이즈 규칙·팩 §3.4 STALE 함정 회피). 사이즈별 수량규칙(per-size min/max) 미설정(2사이즈 공통 제품레벨 규칙).

### [gap-030-paper-optref-mismatch] 종이 옵션이 삭제된 자재(MAT_000105)를 참조 {unknown}
- type: gap
- anchor: none  # 사유: 종이 옵션값(OPV-000056)의 ref가 논리삭제된 상품자재를 가리킴 — 의도(스테일 잔재) vs 결함 판정 원천 부재
- src: {source_file: "live-snapshot/latest/t_prd_product_option_items.csv", source_locator: "테이블:t_prd_product_option_items 키:(PRD_000030,OPV-000056) ref_dim_cd=OPT_REF_DIM.03 ref_key1=MAT_000105 ref_key2=USAGE.07", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_materials.csv", source_locator: "테이블:t_prd_product_materials PRD_000030: MAT_000105(del_yn=Y·07-01 논리삭제) vs MAT_000110(활성)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- gap_what: "종이 옵션 '몽블랑 130g'(OPV-000056)이 ref_key1=MAT_000105(07-01 논리삭제)를 참조하는데, 활성 상품자재는 MAT_000110(몽블랑 130g 3절)이다. 3절 판형이관 시 자재는 105→110 교체됐으나 옵션 참조는 미갱신 — fn_chk_opt_item_ref 정합/손님 선택 시 용지 매칭에 영향 가능(현재값이지 정답 아님)"
- gap_fill_from: "실무진/개발 확인 — 옵션 ref를 MAT_000110로 갱신할지, 105 잔재가 의도인지 판정(§7 dbmap 교정 트랙·인간 승인). KB는 배선 사실만 기록(값/교정 판정은 밖)"
- gap_owner: staff
- rel: {rel: references, target: material-MAT_000110, note: "활성 자재(옵션 ref가 가리켜야 할 후보)"}
- 본문: 3절 판형이관(자재 105→110 교체)의 잔재로 종이 옵션이 삭제 자재를 참조한다. 지어내 정답을 단정하지 않고, 두 자재코드(삭제 105 / 활성 110)를 명기해 관찰로 남긴다. option_refs 엣지는 이 불일치 때문에 [[optgroup-OPT-000029]]에서 배선 유보(삭제 노드 민팅 금지·L-15/L-18 오염 회피).

### [gap-030-addon-envelope] 봉투 addon 대상 상품 미노드 {unknown}
- type: gap
- anchor: none  # 사유: has_addon(R14)은 product→product인데 대상 봉투 상품이 아직 KB 노드 아님
- src: {source_file: "live-snapshot/latest/t_prd_product_addons.csv", source_locator: "테이블:t_prd_product_addons prd_cd:PRD_000030 tmpl_cd:TMPL-000005/TMPL-000006", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_templates.csv", source_locator: "TMPL-000005 base_prd:PRD_000001(OPP접착봉투)·TMPL-000006 base_prd:PRD_000002(OPP비접착봉투)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- gap_what: "지그재그엽서 addon = OPP접착봉투(TMPL-000005→PRD_000001)·OPP비접착봉투(TMPL-000006→PRD_000002). has_addon 엣지는 대상 봉투 상품(PRD_000001/002)이 KB 노드가 돼야 배선 가능(F-7 template 접기)"
- gap_fill_from: "봉투 상품(PRD_000001/002) 노드 집필 후 product-030에 has_addon 배선. 봉투/케이스 세트 적재모델은 [[rule/gaps#GAP_envelope_set_model]]와 함께 결정"
- gap_owner: 설계
