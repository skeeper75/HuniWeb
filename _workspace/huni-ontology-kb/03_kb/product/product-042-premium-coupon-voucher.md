---
id: product-042-premium-coupon-voucher
type: product
anchor: t_prd_products/PRD_000042
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000042(use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-digital-print.md", source_locator: "문서:§3.1 정체(상품권 구분·§4-D 카테고리 재연결)·§1 PRF_DGP_A 바인딩·§3.6 박=공정(박색 8자식)·§3.10 원자합산형", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-dp}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/worklist-digitalprint-remaining.md", source_locator: "문서:§1 상품권(PRD_000042 프리미엄 쿠폰/상품권·PRF_DGP_A+_FOIL·CAT_000295 재연결 재확인)", captured_at: "2026-07-03", badge: verified, src_id: SR-worklist-dp}
relations:
  - {rel: in_category, target: category-CAT_000062}
  - {rel: has_size, target: size-SIZ_000013}
  - {rel: has_size, target: size-SIZ_000014}
  - {rel: uses_material, target: material-MAT_000107, note: "몽블랑 190g(청정·023 mint 재사용)"}
  - {rel: uses_material, target: material-MAT_000118, note: "클래식 크래스트 스티플 270g(청정)"}
  - {rel: uses_material, target: material-MAT_000121, note: "켄도 250g(청정)"}
  - {rel: uses_material, target: material-MAT_000125, note: "한지 170g(청정·028 mint 재사용)"}
  - {rel: uses_material, target: material-MAT_000128, note: "🔴오염: 옵션의도 스타드림(실버)240g인데 마스터=면끈(정답 MAT_000358)"}
  - {rel: uses_material, target: material-MAT_000129, note: "🔴오염: 옵션의도 스타드림(골드)240g인데 마스터=아크릴키링고리(정답 MAT_000359)"}
  - {rel: uses_material, target: material-MAT_000240, note: "🔴오염: 옵션의도 스타드림(다이아)240g인데 마스터=보드스탠딩(정답 MAT_000352)"}
  - {rel: uses_material, target: material-MAT_000241, note: "🔴오염: 옵션의도 스타드림(로츠쿼츠)240g인데 마스터=핀버튼(정답 MAT_000360)"}
  - {rel: has_print_option, target: printopt-POPT_000001}
  - {rel: has_print_option, target: printopt-POPT_000002}
  - {rel: has_process, target: process-PROC_000004, qualifier: mandatory}
  - {rel: has_process, target: process-PROC_000029}
  - {rel: has_process, target: process-PROC_000030}
  - {rel: has_process, target: process-PROC_000031, note: "가변텍스트(라이브 실바인딩·041 형제 동일)"}
  - {rel: has_process, target: process-PROC_000032, note: "가변이미지(라이브 실바인딩)"}
  - {rel: has_process, target: process-PROC_000037, note: "박색 홀로그램(mand N·027-nodes mint 재사용)"}
  - {rel: has_process, target: process-PROC_000038, note: "박색 금유광"}
  - {rel: has_process, target: process-PROC_000039, note: "박색 은유광"}
  - {rel: has_process, target: process-PROC_000040, note: "박색 먹유광"}
  - {rel: has_process, target: process-PROC_000041, note: "박색 동박"}
  - {rel: has_process, target: process-PROC_000042, note: "박색 적박"}
  - {rel: has_process, target: process-PROC_000043, note: "박색 청박"}
  - {rel: has_process, target: process-PROC_000044, note: "박색 트윙클"}
  - {rel: has_plate_size, target: plate-OUTPUT_PAPER_TYPE_01}
  - {rel: priced_by, target: formula-PRF_DGP_A, note: "원자합산형A(기본 분기). 박 선택 시 라이브 2번째 바인딩 PRF_DGP_A_FOIL(needed_shared·아래 가격 경로)"}
  - {rel: has_option_group, target: optgroup-042-print}
  - {rel: has_option_group, target: optgroup-042-paper}
  - {rel: has_option_group, target: optgroup-042-finish}
  - {rel: has_option_group, target: optgroup-042-foil}
props:
  prd_typ_cd: PRD_TYPE.01
  min_qty: 12
  max_qty: 10000
  qty_incr: 12
  qty_unit_typ_cd: QTY_UNIT.02
  file_upload_yn: Y
  editor_yn: N
  use_yn: Y
  archetype: "원자합산형 + 박(FOIL) 분기(041 형제 + 박칼라)"
standards: {schema_org: Product, xjdf: "Product(프리미엄 쿠폰/상품권)", config_ont: "component type"}
tags: [디지털인쇄, 상품권, 박, 가격]
updated: 2026-07-03
---

# product-042-premium-coupon-voucher — 프리미엄 쿠폰/상품권 (PRD_000042)

디지털인쇄 **완제품 단일**(`prd_typ_cd=PRD_TYPE.01` — 셋트 아님·[[rule/rules#RULE_scope_boundary]] SOT 정합).
쿠폰/상품권 구분(카테고리 [[axis/categories#category-CAT_000062]] 쿠폰/상품권, 상위 인쇄홍보물 CAT_000003).
스탠다드 쿠폰/상품권([[product-041-coupon]])의 **형제**로, 같은 사이즈 2종(148×68·148×75)·같은 후가공(오시·미싱·가변)을
쓰되 **① 프리미엄 종이 8종**(041 basic 4종 대신 몽블랑190·클래식크래스트·켄도·한지·스타드림4)과 **② 박(FOIL) 가공
분기**(박칼라 8종 + 박 분기 공식 `PRF_DGP_A_FOIL`)가 더해진다. 파일 업로드형(`file_upload_yn=Y`·에디터 미사용
`editor_yn=N`). 최소 12매·12매 단위·최대 10,000매 <!-- lint-allow: L-12 src=SR-5-livesnap 수량스칼라 -->. 라이브 활성(`use_yn=Y`).

## 정체·수량 요약 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_042.py from live-snapshot/latest (snap_20260702_1119) t_prd_products @ 2026-07-03 -->
| prd_typ_cd | min_qty | max_qty | qty_incr | qty_unit | file_upload | editor | use_yn |
|---|---|---|---|---|---|---|---|
| PRD_TYPE.01 | 12 | 10000 | 12 | QTY_UNIT.02 | Y | N | Y |

> 수량 UI 권위 = 상품/사이즈 수량규칙(가격 구간과 역할 분리·[[rule/decisions#DEC_qty_audit_260702]]).
> 042는 `t_prd_product_bundle_qtys` 0행 — 수량규칙은 상품 레벨 `min/max/incr`(위 표)에서 나온다.
> 그래서 `has_qty_rule` 엣지 없음(bundle_qty 노드 부재) — 끊긴 게 아니라 이 상품의 수량축이 상품 스칼라로 표현됨(041 동일).

> **★카테고리 재연결 확인(pack §4-D):** worklist 힌트는 042가 CAT_000295(고아)로 오적재됐다고 했으나,
> 라이브 스냅샷(07-02)은 `t_prd_product_categories`에서 **CAT_000062(쿠폰/상품권·main_cat_yn=Y·disp 2)로 재연결됨**을 실측한다(정정·해소).
> 즉 "CAT_000295 고아"는 07월 재연결로 낡은 값 → 현재값=CAT_000062([[axis/categories#category-CAT_000062]]).

## 차원·자재·공정 연결

- **사이즈(has_size):** `size-SIZ_000013`(148×68)·`size-SIZ_000014`(148×75) — 041이 mint한 공유 사이즈 노드 **재사용**(중복 mint 금지·L-3). 042·041 동일 상품권 사이즈. 둘 다 `dflt_yn=Y`(기본 중복·041과 동일 open_question).
- **자재(uses_material·8종·전부 `USAGE.07` 공통 슬롯):**
  - **청정 4종:** 몽블랑 190g([[product-023-shaped-postcard-nodes#material-MAT_000107]] 재사용)·클래식 크래스트 스티플 270g(MAT_000118)·켄도 250g(MAT_000121)·한지 170g([[product-028-mini-folded-card-nodes#material-MAT_000125]] 재사용).
  - **🔴오염 4종(잔존 defect):** 종이 옵션 라벨은 스타드림(실버/골드/다이아/로츠쿼츠) 240g이나, 라이브 `t_prd_product_materials`가 가리키는 mat_cd가 **굿즈 부자재**(MAT_000128 면끈·129 아크릴키링고리·240 보드스탠딩·241 핀버튼). 034 펄명함이 2026-06-30 정리(정답 스타드림 MAT_000352/358/359/360 채택)했으나 **042에는 잔존** → [[product-042-premium-coupon-voucher-nodes#GAP_paper_material_042]]. 자재 삭제가 아니라 올바른 mat_cd로 재배선이 필요(§17·[[rule/rules#RULE_import_material_no_delete]] 별개=명백한 굿즈 오적재).
  - 상세 전사·노드 = [product-042-premium-coupon-voucher-nodes.md](product-042-premium-coupon-voucher-nodes.md).
- **도수(has_print_option):** 단면 [[axis/print-options#printopt-POPT_000001]] / 양면 [[axis/print-options#printopt-POPT_000002]] — 칼라. ★도수=`print_opt_cd`(색상코드 아님·[[rule/rules#RULE_dosu_is_printopt]]).
- **공정(has_process·13종):**
  - base 디지털인쇄 [[axis/processes#process-PROC_000004]](`mand_proc_yn=Y`·[[rule/decisions#DEC_baseproc_260701]] 18건 계열 — 미바인딩이면 인쇄비 영구 0. 042는 `mand_proc_yn=Y`로 결합됨·전사표 확인).
  - 후가공 오시 [[axis/processes#process-PROC_000029]]·미싱 [[axis/processes#process-PROC_000030]]·가변텍스트 [[axis/processes#process-PROC_000031]]·가변이미지 [[axis/processes#process-PROC_000032]](전부 `mand_proc_yn=N`·041 형제 동일).
  - **박색 8종**(홀로그램037·금유광038·은유광039·먹유광040·동박041·적박042·청박043·트윙클044) — 공유 박 [[axis/processes#process-PROC_000033]]의 자식이며 **product-027-nodes.md가 mint한 노드 재사용**(중복 mint 금지). 전부 `mand_proc_yn=N`. ★박 부모(PROC_000033)는 042 라이브 `t_prd_product_processes`에 바인딩 0건 → has_process로 쓰지 않고 8자식만 직접 배선(부모접기=라이브 부재값 배선=환각 위험·041 PROC_000085 교훈 동일).
- **판형(has_plate_size):** 국전계열 [[axis/plate-sizes#plate-OUTPUT_PAPER_TYPE_01]](출력용지 SIZ_000499·`OUTPUT_PAPER_TYPE.01`). 종이류라 판형 유효([[rule/rules#RULE_plate_paper_only]])·고객 미선택(`fn_best_plate` 자동선택). 판걸이수=`fn_calc_pansu`([[rule/rules#RULE_pansu_db_function]]).

## 가격 경로 (priced_by → 공식 → 구성요소 → 차원)

- **priced_by(기본 분기):** [[formula/digital-formulas#formula-PRF_DGP_A]] 원자합산형A(엽서·상품권·슬로건 공유). 라이브 `t_prd_product_price_formulas` 바인딩(apply 2026-06-01). 그 공식의 `has_component`·`use_dims`는 공식 노드가 이미 배선(042는 연결만·중복 배선 금지).
- **★priced_by(박 분기·부분 연결):** 라이브 `t_prd_product_price_formulas`에 **2번째 바인딩 `PRF_DGP_A_FOIL`(apply 2026-07-01·note "박 분기 공식으로 재바인딩·동형전파")** 이 존재한다(전사표 확인). 이 공식 노드는 공유 `formula/`에 **아직 미mint** → 이 상품에서 `priced_by` 엣지를 걸면 끊긴 링크(L-15)가 되므로 **엣지는 걸지 않고** `needed_shared_nodes`로 반환한다(통합 단계 mint 후 배선·037 오리지널박명함 `PRF_NAMECARD_FOIL` 처리와 동형). 즉 **가격 경로 = 기본 분기(PRF_DGP_A) 연결됨(✅·O5 충족) + 박 분기(PRF_DGP_A_FOIL) mint 대기(부분)**.
- ★**값은 기록하지 않는다** — 온톨로지 경계(D-18·[[rule/rules#RULE_price_value_boundary]]): 최종 가격 값 계산은 `evaluate_price` 단일 권위. KB는 "어떤 축으로 달라지나(연결·차원)"까지만.
- **골든 스냅샷:** 가격 골든 값 대조는 라이브 `live 20260702_1119` 시점 라벨로만 참조(값 미기입) — 재계산·검증은 별도 레인(§13/§15·okb-adversarial-gate).

## 옵션·제약

- **옵션그룹(has_option_group·4종):** 인쇄(도수) 택1 필수 `optgroup-042-print` · 종이(자재) 택1 필수 `optgroup-042-paper` · 후가공 택N(0~4) `optgroup-042-finish` · **박칼라 택1 선택(0~1·박없음 센티넬)** `optgroup-042-foil`. 상세·참조 배선 = [product-042-premium-coupon-voucher-nodes.md](product-042-premium-coupon-voucher-nodes.md).
- **옵션참조 정합:** 각 옵션그룹의 `option_refs`는 이 상품에 실재하는 도수/자재/공정 노드를 가리킨다(`fn_chk_opt_item_ref` 정합·L-18·pack §3.9). ★종이 그룹의 오염 4종 참조(MAT_000128/129/240/241)도 uses_material에 실재하므로 L-18은 통과하나, 그 자재 노드 자체가 defect(오염)임을 각 노드가 표기.
- **제약(constraints):** `t_prd_product_constraints` 0행 = **042에 등록된 제약규칙 없음**(라이브 실측). 지어내지 않음 — 제약 필요상황이 실무 확인되면 §31 폼빌더 shape로 등록.

## 추가상품

- **has_addon:** `t_prd_product_addons` 0행 = **042에 딸린 추가상품 없음**(라이브 실측·016 봉투 addon과 대비). addon 축은 노드로 만들지 않는다(사실=없음).

## 미확정 (이 상품)

- **자재 오염 잔존** = [[product-042-premium-coupon-voucher-nodes#GAP_paper_material_042]](MAT_000128/129/240/241 → 스타드림 정답 재배선·§17/실무진).
- **박 분기 공식 미mint** = `formula-PRF_DGP_A_FOIL`(needed_shared_nodes 반환·통합 단계 mint 후 priced_by 배선).
- **후가공 줄수/개수 파라미터 보존불가** = [[product-042-premium-coupon-voucher-nodes#GAP_finish_param_042]].
- **박칼라 박크기 파라미터 보존불가** = [[product-042-premium-coupon-voucher-nodes#GAP_foil_param_042]](공유 [[rule/gaps#GAP_foil_parent_children]] 동일 축).
- 사이즈 2행이 **둘 다 `dflt_yn=Y`**(기본 사이즈 중복 지정·041 동일) — 데이터 품질 확인 필요(open_question).
