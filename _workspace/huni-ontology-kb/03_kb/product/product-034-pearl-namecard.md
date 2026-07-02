---
id: product-034-pearl-namecard
type: product
anchor: t_prd_products/PRD_000034
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000034", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-digital-print.md", source_locator: "문서:§3.1 명함 정체·§3.5 자재(펄·오염정리)·§3.6 공정(박)·§3.11 명함 배선교정", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-dp}
relations:
  # 정체·분류 (R1 in_category — 공유 축 재사용)
  - {rel: in_category, target: category-CAT_000003, note: "인쇄홍보물(주·main_cat_yn=Y·disp_seq 4)"}
  - {rel: in_category, target: category-CAT_000313, note: "명함(부·main_cat_yn=N)"}
  # 차원 — 사이즈 (R2 has_size — 공유 축·펄명함은 90x50 단일)
  - {rel: has_size, target: size-SIZ_000008, note: "90x50mm 기본(dflt·펄명함 실 바인딩 사이즈 1종)"}
  # 자재 (R3 uses_material — 스타드림 펄 4종·USAGE.07·companion 정의)
  - {rel: uses_material, target: material-MAT_000352, note: "스타드림(다이아몬드) 240g"}
  - {rel: uses_material, target: material-MAT_000358, note: "스타드림(실버) 240g"}
  - {rel: uses_material, target: material-MAT_000359, note: "스타드림(골드) 240g"}
  - {rel: uses_material, target: material-MAT_000360, note: "스타드림(로즈쿼츠) 240g"}
  # 도수·인쇄방식 (R4 has_print_option — 공유 축·도수=print_opt_cd)
  - {rel: has_print_option, target: printopt-POPT_000001, note: "단면(front CLR_000005 4도·back CLR_000001 인쇄안함)"}
  - {rel: has_print_option, target: printopt-POPT_000002, note: "양면(front/back CLR_000005 4도)"}
  # 공정 (R5 has_process — 전부 mand_proc_yn=N)
  - {rel: has_process, target: process-PROC_000027, qualifier: {mand: N}, note: "직각 모서리(공유 축)"}
  - {rel: has_process, target: process-PROC_000028, qualifier: {mand: N}, note: "둥근 모서리(공유 축)"}
  - {rel: has_process, target: process-PROC_000037, qualifier: {mand: N}, note: "박 홀로그램(특수·027-nodes 정의 재사용)"}
  - {rel: has_process, target: process-PROC_000038, qualifier: {mand: N}, note: "박 금유광(027-nodes 재사용)"}
  - {rel: has_process, target: process-PROC_000039, qualifier: {mand: N}, note: "박 은유광(027-nodes 재사용)"}
  - {rel: has_process, target: process-PROC_000040, qualifier: {mand: N}, note: "박 먹유광(특수·027-nodes 재사용)"}
  - {rel: has_process, target: process-PROC_000041, qualifier: {mand: N}, note: "박 동박(일반·027-nodes 재사용)"}
  - {rel: has_process, target: process-PROC_000042, qualifier: {mand: N}, note: "박 적박(일반·027-nodes 재사용)"}
  - {rel: has_process, target: process-PROC_000043, qualifier: {mand: N}, note: "박 청박(일반·027-nodes 재사용)"}
  - {rel: has_process, target: process-PROC_000044, qualifier: {mand: N}, note: "박 트윙클(특수·027-nodes 재사용)"}
  # 판형 (R6 has_plate_size — 종이류만·공유 축 국전계열·fn_best_plate 자동선택)
  - {rel: has_plate_size, target: plate-OUTPUT_PAPER_TYPE_01, note: "SIZ_000499 출력용지·OUTPUT_PAPER_TYPE.01"}
  # 가격 (R8 priced_by — 2공식·펄 고정가 + 박 분기·companion 정의)
  - {rel: priced_by, target: formula-PRF_NAMECARD_PEARL, note: "박 미선택·펄 완제품가 단/양면"}
  - {rel: priced_by, target: formula-PRF_NAMECARD_PEARL_FOIL, note: "박 선택 시 재바인딩(박 소형 3comp 분기)"}
props:
  prd_typ_cd: PRD_TYPE.01            # 완제품 단일(셋트 아님·t_prd_product_sets 미등록)
  min_qty: 100                       # src SR-5-livesnap(상품 스칼라 수량규칙)
  max_qty: 10000
  qty_incr: 100
  qty_unit_typ_cd: QTY_UNIT.02       # "매"
  file_upload_yn: Y
  editor_yn: N
  archetype_price: "고정가(용지포함)+박 분기"
  qty_rule_note: "수량규칙=상품 스칼라(min100/max10000/incr100). t_prd_product_bundle_qtys 0행·사이즈 수량규칙 공란"
standards: {schema_org: Product, xjdf: "Product(명함)", config_ont: "component type"}
answers_cq: [S2, S3]
tags: [디지털인쇄, 명함, 펄, 박, 고정가]
updated: 2026-07-03
---

# 상품: 펄명함 (PRD_000034)

펄명함은 디지털인쇄 **완제품 단일**(`prd_typ_cd=PRD_TYPE.01`·SOT: 완제품=셋트 아닌 단일 제조상품).
명함 카테고리의 **펄지(스타드림) 변형** 상품이다. 사이즈 1종(90×50)·칼라 단/양면·펄지 4종
(스타드림 다이아몬드/실버/골드/로즈쿼츠 240g)·후가공은 모서리(직각/둥근) + **박(홀로그램·금은먹유광·
동적청박·트윙클 8종)**. 파일 업로드형(에디터 미사용). 수량규칙=상품 스칼라(min/max/incr는 props·전사표 참조) <!-- lint-allow: L-12 src=SR-5-livesnap -->.

**가격 아키타입 = 고정가(용지포함) + 박 분기** — 명함 고정가 공식이되, 박 선택 시 별도 공식으로
재바인딩된다. 즉 **두 공식**에 바인딩: [[formula-PRF_NAMECARD_PEARL]]
(박 미선택·펄 완제품가 단/양면·use_dims `[mat_cd, min_qty, print_opt_cd]`)와
[[formula-PRF_NAMECARD_PEARL_FOIL]](박 선택 시·펄 공식 + 박 소형
3구성요소). 027 2단접지카드의 박 분기(대형)와 **동형**이며 명함은 소형 변형(FOIL_*_SMALL)을 쓴다.
값 계산은 `evaluate_price` 단일 권위([[rule/rules#RULE_price_value_boundary]]) — 온톨로지는 배선까지만
(D-18). 골든 스냅샷 = live 20260702_1119 기준(값 미기록·날짜 라벨만).

**스탠다드명함(033)·코팅명함(032)과의 관계:** 세 명함은 같은 명함 사이즈 축을 공유하나 자재·후가공·
공식이 다르다 — 033=일반 용지 고정가(PRF_NAMECARD_FIXED), 032=코팅 고정가(PRF_NAMECARD_COAT),
034=펄지+박 고정가(PRF_NAMECARD_PEARL). ★도수는 색상코드가 아니라 print_opt_cd이며 박은 도수가
아니라 공정으로 들어온다([[rule/rules#RULE_dosu_is_printopt]]).

## 펄명함 사이즈 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_034.py from live-snapshot/latest (snap_20260702_1119) t_siz_sizes @ 2026-07-03 -->
| siz_cd | 라벨 | 작업(work mm) | 재단(cut mm) |
|---|---|---|---|
| SIZ_000008 | 90x50mm | 92x52 | 90x50 |

> 판걸이수(UP수)는 사이즈 컬럼이 아니라 파생값(`fn_calc_pansu`·엔진·[[rule/rules#RULE_pansu_db_function]]).
> SIZ_000008 note에 "판걸이=24.0" 기재가 있으나 참고 메모이며 권위 판걸이수는 엔진 계산이다.
> 스탠다드명함(033)은 86×52(SIZ_000133)도 갖지만 펄명함은 90×50 단일 바인딩이다(라이브 실측).

## 자재 오염 정리 이력 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_034.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_materials(del_yn=Y) @ 2026-07-03 -->
| mat_cd | 자재명 | mat_typ | del_dt |
|---|---|---|---|
| MAT_000128 | 면끈 | MAT_TYPE.17 | 2026-06-30 11:30:58.226017 |
| MAT_000129 | 아크릴키링고리 | MAT_TYPE.03 | 2026-06-30 11:30:58.226017 |
| MAT_000240 | 보드스탠딩 | MAT_TYPE.16 | 2026-06-30 11:30:58.226017 |
| MAT_000241 | 핀버튼 | MAT_TYPE.12 | 2026-06-30 11:30:58.226017 |

> 위 4종은 굿즈 부자재(면끈·키링고리·보드·핀버튼)로 펄명함(종이 명함)에 **오적재**됐던 것이
> 2026-06-30 논리삭제(del_yn=Y)로 정리됐다([[#DEC_pearl034_material_260630]]). 현재 활성 자재는
> 스타드림 펄 4종뿐이며 `uses_material` 엣지도 이 4종만(삭제분은 엣지 없음·정상).

## 펄 자재·박 공정·공식 (companion 노드)

> 스타드림 펄 4종(material-MAT_000352/358/359/360)·펄 완제품가 2종 + 박 소형 3종 구성요소·
> 공식 2종은 공유 축에 없어 [[product-034-pearl-namecard-nodes]]에 상품 전용 마스터로 신설했다
> (전사표·use_dims·배선 포함). 박색 8자식 공정(PROC_000037~044)은 027이 이미 노드화해 **재사용**한다
> (중복 신설 금지·L-3). 위 relations의 uses_material/has_process/priced_by 타깃이 그 노드로 resolve.

## 결정·공백 (교정 이력·미해결 — 정직 선언)

### [DEC_pearl034_material_260630] 펄명함 자재 오염 정리 + collapse 해소(4종 전개) {verified}
- type: decision
- anchor: none  # 사유: KB 전용 결정(근거=라이브 del_yn=Y 이력 + 펄 자재 4종 전개 + 팩 §3.5)
- src: {source_file: "live-snapshot/latest/t_prd_product_materials.csv", source_locator: "키:PRD_000034 (MAT_000128/129/240/241 del_yn=Y·del_dt 2026-06-30)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-digital-print.md", source_locator: "문서:§3.5 자재(굿즈 자재 오염·펄 단가행 오염)", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-dp}
- rel: {rel: decided_because, target: material-MAT_000352, note: "펄 collapse 해소로 전개된 스타드림 4종 중 대표"}
- rel: {rel: decided_because, target: material-MAT_000358}
- rel: {rel: decided_because, target: material-MAT_000359}
- rel: {rel: decided_because, target: material-MAT_000360}
- props: {일자: "2026-06-30", 내용: "굿즈 부자재 4종(면끈/키링고리/보드/핀버튼)이 펄명함에 오적재된 것을 논리삭제(del_yn=Y). 병행해 펄 완제품가 자재 collapse를 스타드림 4종 전개로 해소(use_dims mat_cd 값 실재화·공식 PRF_NAMECARD_PEARL 바인딩 근거)", 규칙: "[[rule/rules#RULE_import_material_no_delete]] — IMPORT 자재 삭제 금지 원칙과 별개(이건 명백한 굿즈 오적재 정리)"}

### [GAP_034_foil_optgroup] 박색 선택 옵션그룹 부재 {unknown}
- type: gap
- anchor: none  # 사유: 박 8공정·FOIL 공식 배선은 있으나 손님이 박색을 고를 CPQ 옵션그룹(t_prd_product_option_groups) 0행
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "키:PRD_000034 (0행)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-digital-print.md", source_locator: "문서:§3.6 박 부모/박색 8자식 옵션풀 미결(C-06·Q-DP-C)", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-dp}
- gap_what: "펄명함은 박 8공정(PROC_000037~044·has_process)과 박 분기 공식(PRF_NAMECARD_PEARL_FOIL·proc_cd 게이트 구성요소)을 갖지만, 손님이 어느 박색을 고를지 정할 CPQ 옵션그룹이 없다(option_groups 0행). 027 접지카드는 박칼라 옵션그룹(OPT_000033)으로 노출하나 034는 선택 UI 경로 공백 — 가격 경로(proc_cd 게이트)는 있으나 옵션 선택 경로가 끊김"
- gap_fill_from: "실무진 확인 + §31 제약규칙/옵션그룹 하네스(박칼라 옵션그룹을 027처럼 신설·박 부모자식 통일 여부 결정)"
- gap_owner: staff
- rel: {rel: references, target: formula-PRF_NAMECARD_PEARL_FOIL, note: "이 공식이 박색(proc_cd)으로 가격 분기하나 선택 옵션그룹 부재"}
- rel: {rel: references, target: GAP_foil_parent_children, note: "박 부모 PROC_000033 vs 박색 8자식 전 상품 통일 미결(횡단 GAP)의 034 실현형"}

## 끊긴 경로·미해결 (정직 선언)

- **박색 옵션그룹 GAP**: 위 [[#GAP_034_foil_optgroup]] — 박 공정·박 분기 공식은 있으나 손님 선택
  옵션그룹이 없어 "어느 박색"을 고르는 CPQ 경로가 끊김(⚪). 027은 옵션풀로 노출하나 034는 공백.
- **옵션그룹 전무**: `t_prd_product_option_groups`에 PRD_000034 행 0. 032/033 명함은 인쇄·종이·모서리
  옵션그룹을 갖지만 펄명함은 옵션그룹·옵션·옵션아이템 전부 0행이다. 손님 선택(도수·자재·모서리·박)이
  라이브 옵션 레이어로 표현되지 않음 — CPQ 노출 미완(가격 차원은 use_dims에 실재하나 선택 UI 배선 공백).
- **펄 자재 사양 미기재**: 스타드림 4종의 규격/평량 컬럼이 마스터에 공란(전사 "?"). 평량 240g은
  자재명에만 있음(companion props 기록·날조 금지). 채움은 실무진/자재 마스터 보강 소관.
- **수량규칙 노드 부재**: `t_prd_product_bundle_qtys`에 PRD_000034 행 없음 → 별도 `bundle_qty` 노드
  미생성. 수량은 상품 스칼라(min100/max10000/incr100)로만 표현(정상·GAP 아님·팩 §3.4).
- **제약규칙 없음**: `t_prd_product_constraints` 0행. 옵션그룹 자체가 없어 교차제약 대상도 없음(현 상태).
- **추가상품·셋트 없음**: `t_prd_product_addons`·`t_prd_product_sets` 0행 → `has_addon`·`has_member` 없음.

## Sources
- live-snapshot 20260702_1119 실측(del_yn=N 기준): `t_prd_products`(PRD_000034 정체·수량)·`t_prd_product_sizes`(SIZ_000008)·`t_prd_product_materials`(활성 4종 스타드림 USAGE.07 + del_yn=Y 4종 오염정리)·`t_prd_product_print_options`(POPT_000001/002)·`t_prd_product_processes`(PROC_000027/028 + 박 037~044·전부 mand=N)·`t_prd_product_plate_sizes`(SIZ_000499 OUTPUT_PAPER_TYPE.01)·`t_prd_product_price_formulas`(PRF_NAMECARD_PEARL·_FOIL)·`t_prd_product_option_groups/items/options`(0행)·`t_prd_product_bundle_qtys/addons/constraints/sets`(0행)·`t_prd_product_categories`(CAT_000003 main·CAT_000313).
- `_workspace/huni-ontology-kb/01_curation/pack-digital-print.md` §3.1(명함 정체)·§3.5(자재 오염·펄 collapse)·§3.6(공정·박 부모자식 GAP)·§3.11(명함 배선교정).
- companion 노드: [[product-034-pearl-namecard-nodes]](스타드림 4자재·펄/박 구성요소 5·공식 2). 박색 8자식 공정=product-027-nodes.md 재사용.
- 수치 전사: `_meta/scripts/transcribe_product_034.py`(cache/transcribed-034-260703.json).
