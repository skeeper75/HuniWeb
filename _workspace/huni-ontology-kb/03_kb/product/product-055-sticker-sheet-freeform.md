---
id: product-055-sticker-sheet-freeform
type: product
anchor: t_prd_products/PRD_000055
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000055 (prd_nm=낱장 자유형 스티커·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-sticker.md", source_locator: "§1.1(prd_typ .01 재분류)·§3.1 정체·§3.10 완제품가 고정룩업·§4-B/4-C(055 사이즈 재키잉 복구·유포 무변경)", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-sticker}
  - {source_file: "live-snapshot/latest/t_prd_product_price_formulas.csv", source_locator: "테이블:t_prd_product_price_formulas 키:(PRD_000055,PRF_STK_FIXED) note:낱장 자유형 스티커(완칼)→규격/수량 단가", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
relations:
  - {rel: in_category, target: category-CAT_000002, note: "스티커(main_cat_yn=Y·disp 3)"}
  - {rel: in_category, target: category-CAT_000309, note: "자유형스티커(스티커 하위·main_cat_yn=N)"}
  - {rel: has_size, target: size-SIZ_000172, note: "A4(210x297)·dflt_yn=Y(재키잉 복구 활성)"}
  - {rel: has_size, target: size-SIZ_000174, note: "A3(297x420)·활성"}
  - {rel: has_size, target: size-SIZ_000197, note: "A2(420x594)·활성"}
  - {rel: uses_material, target: material-MAT_000593, note: "유포+무광쿨코팅·MAT_TYPE.11(스티커 점착지)·USAGE.07·dflt(활성 자재 1종)"}
  - {rel: has_print_option, target: printopt-POPT_000001, note: "단면 단일(front CMYK 4도·back 인쇄 안 함)·공유 축 재사용"}
  - {rel: has_process, target: process-PROC_000123, note: "완칼커팅(mand_proc_yn=N·023 companion 노드 재사용·2소비 상품 023/055)"}
  - {rel: has_process, target: process-PROC_000114, note: "쿨코팅(mand_proc_yn=N·자재명에 내장된 무광쿨코팅의 공정 표현)"}
  - {rel: has_plate_size, target: plate-OUTPUT_PAPER_TYPE_03, note: "출력용지 기타(.03)·파일사양(A4/A3/A2)·완제품가 모델이라 국전 판걸이수 미적용"}
  - {rel: has_qty_rule, target: qty-055}
  - {rel: priced_by, target: formula-PRF_STK_FIXED, note: "완제품가 고정룩업(COMP_STK_PRINT·siz×mat×수량구간)"}
  - {rel: has_option_group, target: optgroup-055-paper, note: "종이(자재) 택1 필수"}
  - {rel: has_option_group, target: optgroup-055-print, note: "인쇄(도수) 택1 필수"}
  - {rel: has_option_group, target: optgroup-055-cutting, note: "커팅(공정) 택1 필수·option_item ref PROC_000053 stale(gap)"}
  - {rel: has_option_group, target: optgroup-055-jogaksu, note: "조각수(5~10) 선택·리터럴값(물리차원 미참조·GAP-ST-2)"}
props:
  prd_typ_cd: PRD_TYPE.01
  semi_role_cd: null
  nonspec_yn: N
  file_upload_yn: Y
  editor_yn: N
  min_qty: 1
  max_qty: 10000
  qty_incr: 1
  qty_unit_typ_cd: QTY_UNIT.02
  use_yn: Y
  del_yn: N
  구분: "스티커(완칼 자유형·완제품가 고정룩업)"
  status_note: "출시(use_yn=Y). 수량·치수·배선 raw는 companion 전사표 권위(스크립트 전사·손전사 아님)"
standards: {schema_org: Product, xjdf: "Product(스티커)", config_ont: "component type"}
answers_cq: ["구체 상품 질의(낱장 자유형 스티커 구성·가격 경로)", "조건 탐색(완칼 자유형 유포 스티커)"]
tags: ["#스티커", "#완칼", "#완제품가고정룩업", "#유포지", "#출시"]
updated: 2026-07-03
---

# product-055 낱장 자유형 스티커 (PRD_000055)

낱장 자유형 스티커는 스티커 상품군의 **완제품 단일**(`prd_typ_cd=PRD_TYPE.01`)이다. 유포(점착지)에
칼라 단면 인쇄 후 **완칼(자유형 칼틀)** 로 모양대로 잘라내는 낱장 스티커(카테고리 = 스티커
`CAT_000002` · 자유형스티커 `CAT_000309`). 파일 업로드 방식(`file_upload_yn=Y`, 에디터 미사용).
최소 1매·최대 10,000매·1매 증분(단위 QTY_UNIT.02 "매"). 수량·치수·배선 raw 값은
[[product-055-sticker-sheet-freeform-nodes]] 전사표가 권위(스크립트 전사·손전사 금지).

★**출시 상태(use_yn=Y·del_yn=N)** — 라이브 화면 노출. 사이즈·자재·공정은 2026-07-01
**재키잉 복구·재구성** COMMIT(배선 §27 round22 계열)으로 활성분이 바뀐 이력이 있다(§승계 절).
현재값=정답(양면 노드 아님·해당 축 무불일치).

## 정체·유형 (SOT 준수)
- 상품유형 분류 SOT: **완제품(.01)** = 일반 단일 제조상품. 낱장 자유형 스티커는 `t_prd_product_sets`
  부모 등록이 없어(셋트 아님) 일반 단일 완제품(SOT 정합). 기성/디자인 아님(제조 상품).
  ★팩 §1.1·T-1: round-13 "전량 PRD_TYPE.04(디자인상품)" 서술은 STALE — 라이브 재분류로
  **PRD_TYPE.01(완제품)** 이 현재값([[rule/rules#RULE_scope_boundary]] 범위 안).
- 스티커 인쇄방식 5분기(팩 §3.1) 중 **디지털/완칼 계열**. 형제 065 스티커팩만 셋트(sets)이고 055는
  낱장 단품(셋트 아님). 스티커 정체 오분류 0(명백한 스티커).

## 차원 (★스티커 특유 — 형상=칼틀·완제품가 격자)
- **사이즈:** 활성 3행(A4 SIZ_000172·A3 SIZ_000174·A2 SIZ_000197) — 규격 이산 사이즈(면적매트릭스
  아님). A4(172)가 dflt. ★삭제분(SIZ_000258/315/198-dup/515/514 등 del_yn=Y)은 재키잉 복구 과정의
  구행이므로 활성분만 노드화([[product-055-sticker-sheet-freeform-nodes#size-SIZ_000172]]). 낱장 자유형은
  **칼틀 형상이 "자유형"**(치수만 규격·모양은 파일 업로드 완칼) — 합판도무송 066처럼 형상별
  siz_nm 격자를 흡수하지 않는다(팩 §3.2 형상=size는 규격/합판형 국한·055는 자유형=치수 규격).
- **도수:** 인쇄옵션 코드값(단면 POPT_000001·front CMYK 4도 CLR_000005·back 인쇄 안 함
  CLR_000001). 도수는 색상코드가 아니다([[rule/rules#RULE_dosu_is_printopt]]).
- **수량규칙:** 제품 레벨 min 1 / max 10,000 / incr 1(QTY_UNIT.02 "매"). `t_prd_product_bundle_qtys`
  에 055 행 **없음**(제품 레벨 규칙만). 수량 UI 권위 = 제품/사이즈 수량규칙(가격구간과 역할 분리·
  팩 §3.4·[[rule/decisions#DEC_qty_audit_260702]]). 하위 [[qty-055]] 노드.

## 자재·공정
- **자재:** 활성 1종 = **유포+무광쿨코팅 `MAT_000593`**(MAT_TYPE.11 스티커 점착지·상위
  MAT_000165 유포지+엠보코팅·USAGE.07). 자재유형 .11(스티커)은 정답(팩 §3.5·C-ST-09 교정 계열·
  round-13 "종이(.01) 혼재"는 6-14 정정으로 해소). ★구 자재 MAT_000153(유포스티커)은
  2026-07-01 논리삭제(del_yn=Y)되고 MAT_000593으로 교체됨(재키잉/자재 재구성 계열).
  ★IMPORT 시트 등록 자재 삭제 금지([[rule/rules#RULE_import_material_no_delete]]).
  - ★**자재명 정합(GAP)**: live 명 "유포 + 무광쿨코팅" vs 팩 §3.5/C-ST-10 복원목표 "유포지+엠보코팅"
    (상위 MAT_000165 명) — 명칭 불일치가 컨펌 대기(멱등키 영향) → [[gap-055-material-name-cst10]]로
    정직 선언(단정 금지·양면 아님·권위 명 미확정).
- **공정:** 라이브 `t_prd_product_processes` 활성 = **2행** — 완칼커팅(PROC_000123·mand=N) +
  쿨코팅(PROC_000114·mand=N). ★구 완칼(PROC_000053)은 2026-07-01 논리삭제되고 PROC_000123으로
  교체됨(023 모양엽서와 같은 완칼커팅 코드 공유·2소비 상품). ★쿨코팅(PROC_000114)은 자재명에
  내장된 "무광쿨코팅"을 공정으로도 표현한 것.
  - ★**base 인쇄 공정(PROC_000004) 없음 = 정상** — 디지털 상품과 달리 스티커는 **완제품가
    (COMP_STK_PRINT)** 에 출력+가공이 이미 포함되므로([[component-COMP_STK_PRINT]] note "출력+가공
    포함") 별도 base 인쇄 공정·인쇄비 구성요소가 없다. 이는 디지털 base-proc 미바인딩 결함
    ([[rule/decisions#DEC_baseproc_260701]])과 **다른 모델** — 스티커에 PROC_000004가 없다고
    "인쇄비 0 결함"으로 오판 금지(false-defect 회피·[[rule/rules#RULE_dataline_neq_wiring]]).

## 가격 경로 (D-18 경계 — 값은 evaluate_price 권위) — ★가격 경로 연결됨
- `product-055 --priced_by--> formula-PRF_STK_FIXED --has_component--> COMP_STK_PRINT`.
  완제품가 고정룩업 = **[siz_cd, mat_cd, min_qty] 격자에서 시트가격 통째 조회**(원자합산형 아님·
  팩 §3.10). 배선 사슬 [[formula-PRF_STK_FIXED]] · [[component-COMP_STK_PRINT]]은 **스티커 공유 노드**
  (여러 스티커 상품이 공유 — 형제 상품 companion에 정의·통합 시 공유 formula 페이지 승격
  needed_shared_node·L-3 중복 회피 위해 055는 재정의 않고 참조만·공유 formula/* 미수정).
  **고아 공식 아님**(has_component 1개)·**끊긴 가격 사슬 아님**(priced_by 1개).
- ★**완제품가 룩업 커버리지 연결됨**: 활성 사이즈 3종(A4/A3/A2)×활성 자재 MAT_000593이
  COMP_STK_PRINT 단가행에 각 6행 실재(수량구간별·[[product-055-sticker-sheet-freeform-nodes]] 커버리지표).
  → 견적 PRICE≠0 경로 확보(값은 evaluate_price·[[rule/rules#RULE_price_value_boundary]]).
- ★**소재 연당가(원자재 원가)는 이 가격사슬에 노드로 없다**(팩 §3.11·§4-B). 스티커는 원가를
  절가로 펼치지 않고 완제품 시트가격으로 통째 저장한다. 055 자재=유포(MAT_000593)는 260702
  연당가/국4절가 **변경 없음**(price-diff에 유포는 라벨 재편만·§4-A "부수·가격무관 라벨") →
  **연당가 양면(defect) 노드 미해당**(팩 §4-D "retail 무변경·dual 금지"·[[gap-055-material-cost-storage]]
  로 원가 저장처 부재만 정직 기록).

## 옵션·제약·추가상품 (CPQ 레이어 라이브 실측)
- **옵션그룹 4종(활성):** 종이(택1 필수·[[optgroup-055-paper]])·인쇄(택1 필수·[[optgroup-055-print]])·
  커팅(택1 필수·[[optgroup-055-cutting]])·조각수(선택·[[optgroup-055-jogaksu]]). 옵션→차원 연결은
  다형참조 `ref_dim_cd`(.03 자재·.04 공정·.06 도수)로 option_item 단위 귀속(스키마 R11).
  - ★**커팅 옵션 stale 참조(GAP)**: 커팅 option_item(OPV_000031)이 `ref_key1=PROC_000053`을
    가리키나 그 공정은 상품에서 논리삭제됨(활성=PROC_000123). `fn_chk_opt_item_ref` 정합 위반
    소지(L-18) → option_refs 엣지 미생성·[[gap-055-cutting-optref-stale]]로 정직 선언(지어내지 않음).
  - ★**조각수 리터럴(GAP-ST-2)**: 조각수 5~10(OPV-000076~081)은 물리 차원 참조 없는 리터럴값·
    저장처(prcs_dtl_opt.조각수) 스키마 부재 → [[gap-055-jogaksu-storage]].
- **제약:** `t_prd_product_constraints` = 055 행 **없음**(정형 제약 0건). 완칼×사이즈 물리제약 필요
  여부는 §31 제약 하네스 소관(현재 GAP 아님·"제약 없음"이 라이브 사실).
- **추가상품:** `t_prd_product_addons` = 055 행 **없음**(단품 스티커·addon 축 얕음·팩 §3.12).
- **셋트:** `t_prd_product_sets` = 055 행 **없음**(낱장 단품·완제품 단일 SOT 정합·065 스티커팩만 셋트).

## 승계·freshness 메모
- 정체·완제품가 모델·형상 의미 = 팩 §3.1/§3.10 FRESH 승계. prd_typ=PRD_TYPE.01로 갱신(T-1 회피).
- 사이즈·자재·공정 활성분은 2026-07-01 재키잉 복구/자재·공정 재구성 COMMIT 반영(팩 §4-C·배선 §27
  round22 [[rule/decisions#DEC_wiring_round22_260702]]). 위키 결함표(T-6)를 "현재 결함"으로
  직접 이관하지 않고 live-snapshot으로 재조준.
- 연당가 4소재(투명/홀로/크라프트/투명후지) 양면 워크리스트(팩 §4-D)는 **055 무관**(055=유포) —
  그 dual 노드는 형제 투명/홀로/크라프트 스티커 상품 소관(범위 밖·false-defect 회피).
