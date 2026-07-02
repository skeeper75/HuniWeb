---
id: product-037-original-foil-namecard
type: product
anchor: t_prd_products/PRD_000037
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000037", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-digital-print.md", source_locator: "문서:§3.1 정체(명함=인쇄홍보물)·§3.6 박=공정(박색 8자식)·§3.11 명함 배선교정", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-dp}
relations:
  # 정체·분류 (R1 in_category — 공유 축 재사용)
  - {rel: in_category, target: category-CAT_000003, note: "인쇄홍보물(main_cat_yn=Y·disp_seq 7)"}
  - {rel: in_category, target: category-CAT_000313, note: "명함(2차·main_cat_yn=N)"}
  # 차원 — 사이즈 (R2 has_size — 공유 명함 사이즈·033 승격분 재사용, 037은 단일 사이즈)
  - {rel: has_size, target: size-SIZ_000008, note: "90x50mm 단일(dflt·037은 사이즈 1종뿐)"}
  # 자재 (R3 uses_material — 큐리어스스킨 단일 활성·USAGE.07 dflt·공유 축 mint 필요)
  - {rel: uses_material, target: material-MAT_000137, note: "큐리어스스킨 270g(USAGE.07 dflt). MAT_000138~141은 2026-06-30 논리삭제(del_yn=Y)로 미연결"}
  # 도수·인쇄방식 (R4 has_print_option — 공유 축·도수=print_opt_cd)
  - {rel: has_print_option, target: printopt-POPT_000001, note: "단면(front CLR_000005·back CLR_000001)"}
  - {rel: has_print_option, target: printopt-POPT_000002, note: "양면(front/back CLR_000005). 양면=CPQ 선결(공식 note)"}
  # 공정 — 박색 8자식 (R5 has_process — 전부 mand_proc_yn=N·공유 박(PROC_000033) 자식·축 mint 필요)
  - {rel: has_process, target: process-PROC_000037, qualifier: {mand: N}, note: "홀로그램(홀로 버킷)"}
  - {rel: has_process, target: process-PROC_000038, qualifier: {mand: N}, note: "금유광(일반박 버킷)"}
  - {rel: has_process, target: process-PROC_000039, qualifier: {mand: N}, note: "은유광(일반박)"}
  - {rel: has_process, target: process-PROC_000040, qualifier: {mand: N}, note: "먹유광(일반박)"}
  - {rel: has_process, target: process-PROC_000041, qualifier: {mand: N}, note: "동박(일반박)"}
  - {rel: has_process, target: process-PROC_000042, qualifier: {mand: N}, note: "적박(일반박)"}
  - {rel: has_process, target: process-PROC_000043, qualifier: {mand: N}, note: "청박(일반박)"}
  - {rel: has_process, target: process-PROC_000044, qualifier: {mand: N}, note: "트윙클(홀로 버킷)"}
  # 판형 — 미연결(정직): plate_sizes 행 있으나 output_paper_typ_cd 공란([[#gap-037-plate-output-paper]])
  # 가격 (R8 priced_by — 오리지널박명함 전용 공식·공유 공식 축 mint 필요)
  - {rel: priced_by, target: formula-PRF_NAMECARD_FOIL}
  # CPQ 옵션 그룹 (R10 has_option_group — 하위 노드·박종류만 존재)
  - {rel: has_option_group, target: optgroup-037-foiltype}
props:
  prd_typ_cd: PRD_TYPE.01            # 완제품 단일(셋트 아님·t_prd_product_sets 부모 미등록)
  min_qty: 200                       # src SR-5-livesnap(상품 스칼라·명함 기본 100과 다름)
  max_qty: 1000
  qty_incr: 100
  qty_unit_typ_cd: QTY_UNIT.02       # "매"
  file_upload_yn: Y
  editor_yn: N
  archetype_price: "고정가(박종류/수량별 단가 + 동판셋업비)"
  qty_rule_note: "수량규칙=상품 스칼라(min200/max1000/incr100). t_prd_product_bundle_qtys 0행·사이즈 수량규칙 공란·has_qty_rule 엣지 없음(정상)"
standards: {schema_org: Product, xjdf: "Product(명함)", config_ont: "component type"}
answers_cq: [S2, S3]
tags: [디지털인쇄, 명함, 박, 고정가]
updated: 2026-07-03
---

# 상품: 오리지널박명함 (PRD_000037)

오리지널박명함은 디지털인쇄 **완제품 단일**(`prd_typ_cd=PRD_TYPE.01`·SOT: 완제품=셋트 아닌 단일
제조상품). 명함 카테고리의 **박(foil) 가공** 특화 상품이다. 사이즈 1종(90×50)·칼라 단/양면·용지
큐리어스스킨(단일 활성)·박색 8종([[axis/processes#process-PROC_000033]] 박 자식) 중 택1을 손님이 고른다.
파일 업로드형(`file_upload_yn=Y`·`editor_yn=N`). 가격은 박종류·수량별 단가 + 동판셋업비 공식
[[formula/digital-formulas#formula-PRF_NAMECARD_FOIL]]로 결정되며, 값 계산은 `evaluate_price` 권위
([[rule/rules#RULE_price_value_boundary]]) — 온톨로지는 배선까지만(D-18). 최소 **200매**·100매 증분·최대 1000매.

**명함 형제 상품과의 관계:** 스탠다드명함([[product-033-standard-namecard]])=코팅없는 baseline·고정가
`PRF_NAMECARD_FIXED`, 코팅명함([[product-032-coated-namecard]])=코팅 변형·`PRF_NAMECARD_COAT`. 오리지널박명함은
**박 가공 변형**·`PRF_NAMECARD_FOIL`(박 본체 + 동판셋업). 세 명함 모두 완제품가(용지포함) 고정가 아키타입이나
037은 여기에 **박종류(일반박/홀로) 판별 차원**과 **동판셋업비**(주문 1건당 1회 부과·수량 미곱)가 더해진다.

**가격 차원(use_dims·박 본체 4종):** `[print_opt_cd, opt_cd, min_qty, opt_grp:OPT_000080]` — 즉 **단/양면 ·
박종류(일반박/홀로) · 수량**으로 가격이 갈린다. 동판셋업비 component는 `[print_opt_cd, (min_qty)]` 차원.
**자재무관·박색 8종 내 세부색 동일가**(공식 note "면 동일가·자재무관") — 그래서 큐리어스스킨 색상 자식
(화이트/레드/…)이나 박색 8종 세부 선택은 가격 차원이 아니다(생산 스펙).

## 오리지널박명함 사이즈 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_037.py from live-snapshot/latest (snap_20260702_1119) t_siz_sizes @ 2026-07-03 -->
| siz_cd | 라벨 | 작업(work mm) | 재단(cut mm) |
|---|---|---|---|
| SIZ_000008 | 90x50mm | 92x52 | 90x50 |

> 스탠다드/코팅명함(033/032)은 90×50·86×52 두 사이즈이나 037은 **90×50 단일**이다(live
> `t_prd_product_sizes` 1행). 판걸이수(UP수)는 사이즈 컬럼이 아니라 파생값(`fn_calc_pansu`·엔진)이며,
> 037 가격은 고정가(박종류/수량)라 판걸이수를 참여시키지 않는다(F-9·T-7).

## 오리지널박명함 자재 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_037.py from live-snapshot/latest (snap_20260702_1119) t_mat_materials @ 2026-07-03 -->
| mat_cd | 자재명 | mat_typ | 규격(mm) | 평량(g) | 관계 |
|---|---|---|---|---|---|
| MAT_000137 | 큐리어스스킨 | MAT_TYPE.01 | 316x467 | 270 | 부모(037 has_material dflt) |
| MAT_000361 | 큐리어스스킨 화이트 270g | MAT_TYPE.01 | (부모상속) | (부모상속) | 색상 자식 |
| MAT_000362 | 큐리어스스킨 레드 270g | MAT_TYPE.01 | (부모상속) | (부모상속) | 색상 자식 |
| MAT_000363 | 큐리어스스킨 다크블루 270g | MAT_TYPE.01 | (부모상속) | (부모상속) | 색상 자식 |
| MAT_000364 | 큐리어스스킨 바이올렛 270g | MAT_TYPE.01 | (부모상속) | (부모상속) | 색상 자식 |
| MAT_000365 | 큐리어스스킨 블랙 270g | MAT_TYPE.01 | (부모상속) | (부모상속) | 색상 자식 |

> 037의 활성 자재는 큐리어스스킨 **부모 MAT_000137 단일**(USAGE.07 dflt). 색상 자식(화이트/레드/다크블루/
> 바이올렛/블랙 5종)은 마스터에 실재하나 037 `t_prd_product_materials`에는 부모만 연결됐다. 과거 연결된
> MAT_000138~141은 **2026-06-30 논리삭제**(`del_yn=Y`)라 relations에서 제외(정직). 자재=USAGE.07 단일 슬롯 모델(팩 §3.5).
> ★[HARD] 실무진 IMPORT 등록 자재는 "배선 안 됐다"고 삭제 금지(팩 §3.5) — 삭제는 실무진 논리삭제 근거(del_dt) 기준으로만 반영.

## 오리지널박명함 박색 공정 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_037.py from live-snapshot/latest (snap_20260702_1119) t_proc_processes @ 2026-07-03 -->
| proc_cd | 공정명(박색) | 상위공정(upr) |
|---|---|---|
| PROC_000037 | 홀로그램 | PROC_000033 |
| PROC_000038 | 금유광 | PROC_000033 |
| PROC_000039 | 은유광 | PROC_000033 |
| PROC_000040 | 먹유광 | PROC_000033 |
| PROC_000041 | 동박 | PROC_000033 |
| PROC_000042 | 적박 | PROC_000033 |
| PROC_000043 | 청박 | PROC_000033 |
| PROC_000044 | 트윙클 | PROC_000033 |

> 박색 8종은 전부 공유 박 공정([[axis/processes#process-PROC_000033]])의 **자식 코드**다(전부 mand_proc_yn=N).
> 가격상 **박종류 2버킷**으로 접힌다: 일반박(금유광/은유광/먹유광/동박/적박/청박 6종) → STD 본체,
> 홀로그램/트윙클 2종 → HOLO 본체. 세부 8색 자체는 가격 차원이 아님(동일가·자재무관). 이 8색 중 손님이
> 어떻게 택1하는지는 옵션 레이어에 미표현([[#gap-037-foil-color-select]]·공유 [[rule/gaps#GAP_foil_parent_children]]).

## 오리지널박명함 수량규칙 스칼라 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_037.py from live-snapshot/latest (snap_20260702_1119) t_prd_products PRD_000037 @ 2026-07-03 -->
| min_qty | max_qty | qty_incr | qty_unit_typ_cd |
|---|---|---|---|
| 200 | 1000 | 100 | QTY_UNIT.02 |

> 수량규칙은 **상품 레벨 스칼라**(min200/max1000/incr100·단위 QTY_UNIT.02 "매"). 명함 baseline
> (033·min100/max10000)과 **다르다**(037은 박 가공이라 소량 고정). `t_prd_product_bundle_qtys` 0행 →
> 별도 bundle_qty 노드 미생성·`has_qty_rule` 엣지 없음(정상·팩 §3.4).

---

<!-- 이하: PRD_000037 전용 하위 노드(공유 축에 없는 것만). 공유 축(사이즈·박 부모공정·자재·도수·카테고리·공식·박색 자식공정·박 본체 component)은 위 relations로 재사용/축 mint. -->

## CPQ 옵션 그룹 (손님 선택 축 — 박종류만 존재)

> 037은 option_group이 **박종류(OPT_000080) 1개뿐**이다. 인쇄(단/양면)·종이(자재) 전용 option_group이
> 없다 — 자재는 큐리어스스킨 단일이고, 단/양면은 print_options(POPT_000001/002) + 가격 component
> S1/S2 분기 + CPQ 선결(공식 note "양면=CPQ 선결")로 표현된다. 이 두 축의 별도 option_group 부재는
> 아래 §끊긴 경로에 정직 기록한다.

### [optgroup-037-foiltype] 박종류 택1 필수 {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000037
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "키:(PRD_000037,OPT_000080)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: references, target: process-PROC_000033, note: "박종류(일반박/홀로)는 박 공정(PROC_000033) 자식 8색을 2버킷으로 판별 — opt_cd 기반 가격 판별차원(use_dims opt_grp:OPT_000080)"}
- props: {opt_grp_cd: "OPT_000080", opt_grp_nm: "박종류", sel_typ_cd: "SEL_TYPE.01", min_sel_cnt: 1, max_sel_cnt: 1, mand_yn: "Y", opt_values: "OPV_000487 일반박(dflt·금/은/먹유광·청박·적박·동박→STD body) / OPV_000488 홀로그램·트윙클(→HOLO body·프리미엄)", item_note: "opt_cd 판별차원(선택수단)·option_items 0행(ref_key 없음)→ref-기반 option_refs 아님·박색 세부 택1은 미표현([[#gap-037-foil-color-select]])"}

## 결정·공백 (교정 이력·미확정)

### [DEC_namecard037_foil_wiring_260630] 박명함 공식 HOLO/양면 body 배선 COMMIT {verified}
- type: decision
- anchor: none  # 사유: KB 전용 결정(근거=라이브 formula_components 배선 타임스탬프 + 공식 note)
- src: {source_file: "live-snapshot/latest/t_prc_formula_components.csv", source_locator: "frm_cd:PRF_NAMECARD_FOIL disp_seq 3~6 reg_dt 2026-06-30 18:01:30", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/_foundation/batch/wiring/HANDOFF.md", source_locator: "명함 고아 component 배선(단가행 존재≠배선 완료)", captured_at: "2026-07-03", badge: verified, src_id: SR-27-wiring}
- rel: {rel: decided_because, target: formula-PRF_NAMECARD_FOIL, note: "STD S1/S2 + 동판셋업 S1(2026-06-26)에 HOLO S1/S2·STD S2·셋업 S2 배선(2026-06-30) 추가 — 양면/홀로 견적 발현"}
- props: {일자: "2026-06-30", 내용: "공식 초기 배선(2026-06-26)=일반박 단면 본체+동판셋업 단면 2행. 2026-06-30 홀로 단/양면·일반박 양면·동판셋업 양면 4행 추가 배선→총 6 component. 단가행 존재≠배선 완료 교훈([[rule/rules#RULE_dataline_neq_wiring]])"}

### [gap-037-foil-color-select] 박색 8자식 세부 선택 수단 미표현 {unknown}
- type: gap
- anchor: none  # 사유: 박종류 옵션(OPT_000080)은 일반박/홀로 2버킷(가격 판별)뿐·박색 8색 택1을 손님이 고르는 수단이 옵션 레이어(option_items)에 없음(0행)
- src: {source_file: "live-snapshot/latest/t_prd_product_option_items.csv", source_locator: "키:PRD_000037 opt_items 0행", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- gap_what: "박색 8종(홀로그램/금유광/은유광/먹유광/동박/적박/청박/트윙클) 중 손님 택1 선택 수단이 옵션 레이어에 미표현 — has_process 8행은 있으나 option_group은 박종류 2버킷(OPT_000080)뿐·option_items 0행. 가격은 동일가라 무영향이나 생산 스펙(어느 박색) 캡처 경로 공백"
- gap_fill_from: "실무진 확인(박색 선택 UI 수단) 또는 §31 제약규칙/폼빌더 파라미터 — 공유 [[rule/gaps#GAP_foil_parent_children]](박 부모 vs 박색 8자식 옵션풀 C-06 미결)와 동일 축"
- gap_owner: staff
- rel: {rel: references, target: process-PROC_000033, note: "박 부모 공정의 8색 자식 선택 공백"}

### [gap-037-plate-output-paper] 판형 출력용지규격 미배정 {unknown}
- type: gap
- anchor: none  # 사유: t_prd_product_plate_sizes 행은 있으나 output_paper_typ_cd 공란(siz_cd=SIZ_000008·output_file_typ=AI·note 파일사양) — 종이류임에도 출력용지규격 미지정
- src: {source_file: "live-snapshot/latest/t_prd_product_plate_sizes.csv", source_locator: "키:PRD_000037 siz_cd:SIZ_000008 output_paper_typ_cd:(공란)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- gap_what: "037 plate_sizes 행의 output_paper_typ_cd가 공란이라 공유 판형 노드(plate-OUTPUT_PAPER_TYPE_01 국전 316x467)로 resolve 불가 → has_plate_size 엣지 미연결. 큐리어스스킨(MAT_000137)은 316x467 종이류라 국전계열이 자연스러우나 라이브가 미배정(RULE_plate_paper_only 관점 종이류=판형 필요). 단 037 가격은 고정가(박종류/수량)로 판걸이수 비참여→가격 무영향"
- gap_fill_from: "실무진 확인(output_paper_typ_cd=OUTPUT_PAPER_TYPE.01 배정 여부) 또는 fn_best_plate 자동선택 재확인 — §26/§7 판형 트랙"
- gap_owner: staff
- rel: {rel: references, target: plate-OUTPUT_PAPER_TYPE_01, note: "공유 국전 판형 노드로 미배정(공란)"}

## 끊긴 경로·미해결 (정직 선언)

- **가격 경로 = 연결됨(✅)**: product-037 → `priced_by` → [[formula/digital-formulas#formula-PRF_NAMECARD_FOIL]]
  → `has_component` → 박 본체 4종(단/양면 × 일반박/홀로) + 동판셋업 2종(단/양면) = **6 component**. 박 본체
  component는 수량구간 단가행(각 9행)·동판셋업은 고정가(각 1행) 보유(값 계산=evaluate_price 권위·값 미기록).
  단, formula/component/자재/박색 자식 공정 노드는 **공유 축 mint 대기**(needed_shared_nodes 반환) — mint 후 L-15 resolve.
- **박색 세부 선택 GAP**: [[#gap-037-foil-color-select]] — 8색 중 택1 수단 옵션 레이어 미표현(가격 무영향·생산 스펙 공백).
- **판형 미배정 GAP**: [[#gap-037-plate-output-paper]] — plate_sizes 행 output_paper_typ_cd 공란(가격 무영향).
- **인쇄(단/양면)·종이 전용 option_group 부재**: 037은 option_group이 박종류 1개뿐. 단/양면은
  print_options(POPT_000001/002)+component S1/S2 분기+CPQ 선결로, 종이는 단일 자재라 각각 별도 option_group
  없이 표현된다(033/032와 다른 구조). GAP 아님(선택축이 다른 수단으로 표현·정상)이나 형제 상품과 구조 차이로 기록.
- **제약규칙(constraint) 없음**: `t_prd_product_constraints` PRD_000037 행 0. 박종류 택1 카디널리티
  (sel_typ SEL_TYPE.01·min1/max1)로 표현되어 별도 교차제약 불요(정상).
- **추가상품 없음**: `t_prd_product_addons` 행 0 → `has_addon` 없음.
- **수량규칙 노드 부재**: `t_prd_product_bundle_qtys` 0행 → bundle_qty 노드 미생성. 수량=상품 스칼라(min200/max1000/incr100)로만 표현(정상·GAP 아님).

## Sources
- live-snapshot 20260702_1119 실측(del_yn=N 기준): `t_prd_products`(PRD_000037 정체·수량 min200/max1000)·`t_prd_product_categories`(CAT_000003 main/CAT_000313)·`t_prd_product_sizes`(SIZ_000008 1행)·`t_prd_product_materials`(MAT_000137 활성·138~141 del_yn=Y)·`t_prd_product_print_options`(POPT_000001/002)·`t_prd_product_processes`(PROC_000037~044 8행 mand=N)·`t_prd_product_plate_sizes`(SIZ_000008 output_paper_typ_cd 공란)·`t_prd_product_price_formulas`(PRF_NAMECARD_FOIL)·`t_prd_product_option_groups`(OPT_000080 박종류)·`t_prd_product_options`(OPV_000487 일반박/OPV_000488 홀로)·`t_prd_product_option_items`(0행)·`t_prd_product_bundle_qtys/addons/constraints`(각 0행) — 전사=`_meta/scripts/transcribe_product_037.py`.
- 가격 배선 실측: `t_prc_price_formulas`(PRF_NAMECARD_FOIL note "일반박 본체+동판셋업·면 동일가·자재무관·HOLO/양면=CPQ 선결")·`t_prc_formula_components`(6 component 배선)·`t_prc_price_components`(COMP_NAMECARD_FOIL_S1/S2_STD/HOLO use_dims [print_opt_cd,opt_cd,min_qty,opt_grp:OPT_000080]·SETUP_S1/S2 PRICE_TYPE.03)·`t_prc_component_prices`(본체 9행·셋업 1행).
- `01_curation/pack-digital-print.md` §3.1(명함 정체)·§3.3(도수=print_opt_cd)·§3.5(자재 USAGE.07·IMPORT 자재 삭제금지)·§3.6(박=공정·박색 8자식 GAP C-06)·§3.11(명함 배선교정·단가행≠배선).
- 공유 축·공식 노드(mint 대기): `axis/materials.md`(MAT_000137)·`axis/processes.md`(PROC_000037~044)·`formula/digital-formulas.md`(PRF_NAMECARD_FOIL)·`formula/digital-components.md`(COMP_NAMECARD_FOIL_S1/S2_STD/HOLO·SETUP_S1/S2). 재사용(기존): `axis/sizes.md`(SIZ_000008)·`axis/processes.md`(PROC_000033)·`axis/print-options.md`(POPT_000001/002)·`axis/categories.md`(CAT_000003/313)·`axis/plate-sizes.md`(OUTPUT_PAPER_TYPE_01·미배정).
