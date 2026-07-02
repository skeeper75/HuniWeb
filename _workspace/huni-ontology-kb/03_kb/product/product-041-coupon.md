---
id: product-041-coupon
type: product
anchor: t_prd_products/PRD_000041
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000041(use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-digital-print.md", source_locator: "문서:§3.1 정체(상품권 구분)·§1 PRF_DGP_A 바인딩·§3.10 원자합산형", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-dp}
relations:
  - {rel: in_category, target: category-CAT_000062}
  - {rel: has_size, target: size-SIZ_000013}
  - {rel: has_size, target: size-SIZ_000014}
  - {rel: uses_material, target: material-MAT_000072}
  - {rel: uses_material, target: material-MAT_000078}
  - {rel: uses_material, target: material-MAT_000088}
  - {rel: uses_material, target: material-MAT_000105}
  - {rel: has_print_option, target: printopt-POPT_000001}
  - {rel: has_print_option, target: printopt-POPT_000002}
  - {rel: has_process, target: process-PROC_000004, qualifier: mandatory}
  - {rel: has_process, target: process-PROC_000029}
  - {rel: has_process, target: process-PROC_000030}
  - {rel: has_process, target: process-PROC_000031, note: "가변텍스트(R2·라이브 실바인딩·형제 033/027 동일)"}
  - {rel: has_process, target: process-PROC_000032, note: "가변이미지(R2·라이브 실바인딩)"}
  - {rel: has_plate_size, target: plate-OUTPUT_PAPER_TYPE_01}
  - {rel: priced_by, target: formula-PRF_DGP_A}
  - {rel: has_option_group, target: optgroup-041-print}
  - {rel: has_option_group, target: optgroup-041-paper}
  - {rel: has_option_group, target: optgroup-041-finish}
props:
  prd_typ_cd: PRD_TYPE.01
  min_qty: 12
  max_qty: 10000
  qty_incr: 12
  qty_unit_typ_cd: QTY_UNIT.02
  file_upload_yn: Y
  editor_yn: N
standards: {schema_org: Product, xjdf: "Product(쿠폰/상품권)", config_ont: "component type"}
tags: [디지털인쇄, 상품권, 가격]
updated: 2026-07-03
---

# product-041-coupon — 스탠다드 쿠폰/상품권 (PRD_000041)

디지털인쇄 **완제품 단일**(`prd_typ_cd=PRD_TYPE.01` — 셋트 아님·[[rule/rules#RULE_scope_boundary]] SOT 정합).
쿠폰/상품권 구분(카테고리 [[axis/categories#category-CAT_000062]] 쿠폰/상품권, 상위 인쇄홍보물 CAT_000003).
낱장 소형(148×68·148×75) 카드형으로, 칼라 단/양면 인쇄에 종이 택1·후가공 택N을 얹는다.
파일 업로드형(`file_upload_yn=Y`·에디터 미사용 `editor_yn=N`). 최소 12매·12매 단위·최대 10,000매.

## 정체·수량 요약 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_041.py from live-snapshot/latest (snap_20260702_1119) t_prd_products @ 2026-07-03 -->
| prd_typ_cd | min_qty | max_qty | qty_incr | qty_unit | file_upload | editor |
|---|---|---|---|---|---|---|
| PRD_TYPE.01 | 12 | 10000 | 12 | QTY_UNIT.02 | Y | N |

> 수량 UI 권위 = 상품/사이즈 수량규칙(가격 구간과 역할 분리·[[rule/decisions#DEC_qty_audit_260702]]).
> 041은 `t_prd_product_bundle_qtys` 0행 — 수량규칙은 상품 레벨 `min/max/incr`(위 표)에서 나온다.
> 그래서 `has_qty_rule` 엣지 없음(bundle_qty 노드 부재) — 끊긴 게 아니라 이 상품의 수량축이 상품 스칼라로 표현됨.

## 차원·자재·공정 연결

- **사이즈(has_size):** `size-SIZ_000013`(148×68)·`size-SIZ_000014`(148×75) — 2행 이산 사이즈(041 전용 신규 축 멤버). 상세 전사표 = [product-041-coupon-axes.md](product-041-coupon-axes.md).
- **자재(uses_material):** 백색모조지 100g·아트지 150g·스노우지 150g·몽블랑 130g 4종(전부 `USAGE.07` 공통 슬롯·[[rule/rules#RULE_import_material_no_delete]]).
- **도수(has_print_option):** 단면 [[axis/print-options#printopt-POPT_000001]] / 양면 [[axis/print-options#printopt-POPT_000002]] — 칼라. ★도수=`print_opt_cd`(색상코드 아님·[[rule/rules#RULE_dosu_is_printopt]]).
- **공정(has_process):** 디지털인쇄 base [[axis/processes#process-PROC_000004]](`mand_proc_yn=Y`) + 오시 [[axis/processes#process-PROC_000029]]·미싱 [[axis/processes#process-PROC_000030]]·가변텍스트 [[axis/processes#process-PROC_000031]]·가변이미지 [[axis/processes#process-PROC_000032]](후가공 전부 옵션·`mand_proc_yn=N`). ★라이브 041 공정=004/029/030/031/032 (5)이며 그대로 배선한다(R2 교정). 이전엔 자식 031/032가 공유축 미등재라 부모 가변데이타(PROC_000085)로 접었으나, 260703 공유 [[axis/processes]] 축 승격으로 031/032 노드가 생겨 라이브 부합 직접 배선(형제 033/027 동일 패턴). ★PROC_000085는 라이브 `t_prd_product_processes`에 상품 바인딩 0건이라 has_process로 쓰지 않는다(부모접기=라이브 부재값 배선=환각 위험). 가격측 `proc_grp:PROC_000085`(단가행 차원)는 별개 — 그건 공식/구성요소 노드가 유지.
  - ★base 공정 PROC_000004는 [[rule/decisions#DEC_baseproc_260701]]의 18건 COMMIT 대상군 계열 — 미바인딩이면 인쇄비 영구 0. 041은 라이브에 `mand_proc_yn=Y`로 결합됨(전사표 확인).
- **판형(has_plate_size):** 국전계열 [[axis/plate-sizes#plate-OUTPUT_PAPER_TYPE_01]](출력용지 SIZ_000499·`OUTPUT_PAPER_TYPE.01`). 종이류라 판형 유효([[rule/rules#RULE_plate_paper_only]])·고객 미선택(`fn_best_plate` 자동선택). 판걸이수=`fn_calc_pansu`([[rule/rules#RULE_pansu_db_function]]).

## 가격 경로 (priced_by → 공식 → 구성요소 → 차원)

- **priced_by:** [[formula/digital-formulas#formula-PRF_DGP_A]] 원자합산형A(엽서·상품권·슬로건 공유). 라이브 바인딩 `t_prd_product_price_formulas`(apply 2026-06-01).
- 그 다음 `has_component`(공식→구성요소)·`use_dims`(구성요소 차원)는 **공식 노드가 이미 배선**([[formula/digital-formulas#formula-PRF_DGP_A]] 10구성요소: base 인쇄·별색화이트·용지·모서리(.03 교정)·오시·미싱·가변텍스트·가변이미지·유광/무광 코팅). 041은 그 공식에 연결만 한다(중복 배선 금지).
- ★**값은 기록하지 않는다** — 온톨로지 경계(D-18·[[rule/rules#RULE_price_value_boundary]]): 최종 가격 값 계산은 `evaluate_price` 단일 권위. KB는 "어떤 축으로 달라지나(연결·차원)"까지만.
- **골든 스냅샷:** 가격 골든 값 대조는 라이브 `live 20260702_1119` 시점 라벨로만 참조(값 미기입) — 재계산·검증은 별도 레인(§13/§15·okb-adversarial-gate).

## 옵션·제약

- **옵션그룹(has_option_group):** 인쇄(도수) 택1 필수 `optgroup-041-print` · 종이(자재) 택1 필수 `optgroup-041-paper` · 후가공 택N(0~4) `optgroup-041-finish`. 상세·참조 배선 = [product-041-coupon-axes.md](product-041-coupon-axes.md).
- **옵션참조 정합:** 각 옵션그룹의 `option_refs`는 이 상품에 실재하는 도수/자재/공정 노드를 가리킨다(`fn_chk_opt_item_ref` 정합·pack §3.9).
- **제약(constraints):** `t_prd_product_constraints` 0행 = **041에 등록된 제약규칙 없음**(라이브 실측). 제약 필요상황(코팅×종이두께 등)이 실무 확인되면 §31 폼빌더 shape로 등록(현재는 없음 — 지어내지 않음).

## 추가상품

- **has_addon:** `t_prd_product_addons` 0행 = **041에 딸린 추가상품 없음**(016 프리미엄엽서의 봉투 addon과 대비). addon 축은 노드로 만들지 않는다(사실=없음).

## 미확정 (이 상품)

- 041 후가공 줄수/개수 파라미터 보존불가 = `GAP_finish_param_041`([product-041-coupon-axes.md](product-041-coupon-axes.md)).
- 사이즈 2행이 **둘 다 `dflt_yn=Y`**(기본 사이즈 중복 지정) — 데이터 품질 확인 필요(open_question).
