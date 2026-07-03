---
id: product-121-adhesive-waterproof-poster
type: product
anchor: t_prd_products/PRD_000121
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000121(prd_nm=접착방수포스터·prd_typ_cd=PRD_TYPE.01·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "문서:§3.10 면적매트릭스 13상품 B04 접착방수121=COMP 동형결합·§1.1 라이브 교정 (승계·재검증 2026-07-03)", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-silsa}
relations:
  - {rel: in_category, target: category-CAT_000004, note: "포스터(main_cat_yn=Y·level1 root·companion 노드)"}
  - {rel: in_category, target: category-CAT_000314, note: "아트포스터(main_cat_yn=N·level2·companion 노드)"}
  - {rel: has_size, target: size-SIZ_000174, note: "A3 297x420(등록규격·047 기정의 재사용)"}
  - {rel: has_size, target: size-SIZ_000197, note: "A2 420x594(등록규격·axis/sizes 기정의 재사용)"}
  - {rel: has_size, target: size-SIZ_000293, note: "A1 594x841(등록규격·★마스터 del_yn=Y 잔존·공유 사이즈 노드 119 재사용)"}
  - {rel: uses_material, target: material-MAT_000179, note: "PVC(접착방수 본체·MAT_TYPE.08 실사소재·USAGE.07)"}
  - {rel: has_process, target: process-PROC_000014, note: "유광라미네이팅(opt·mand_yn=N·코팅 옵션 대상)"}
  - {rel: has_process, target: process-PROC_000015, note: "무광라미네이팅(opt·mand_yn=N·코팅 옵션 대상)"}
  - {rel: priced_by, target: formula-PRF_POSTER_ADH_WP, note: "완제품가 면적매트릭스(상품전용 공식·companion)"}
  - {rel: has_option_group, target: optgroup-121-coating, note: "코팅 택1(유광/무광·가격은 코팅포함 통가격)"}
props:
  prd_typ_cd: PRD_TYPE.01
  semi_role_cd: null
  file_upload_yn: Y
  editor_yn: N
  nonspec_yn: Y
  min_qty: 1
  max_qty: 1000
  qty_incr: 1
  qty_unit_typ_cd: QTY_UNIT.01
  use_yn: Y
  del_yn: N
  archetype: "면적매트릭스(area-matrix·[가로×세로] 셀단가)"
  qty_src: "전사표(transcribe_product_121.py) — raw 수치 손전사 아님"
standards: {schema_org: Product, xjdf: "Product(포스터/Poster)", config_ont: "component type"}
answers_cq: ["구체 상품 질의(접착방수포스터 가격 경로)", "조건 탐색(방수/접착 포스터 소재·규격)"]
tags: ["#실사", "#포스터", "#면적매트릭스", "#접착방수", "#완제품가"]
updated: 2026-07-03
---

# product-121 접착방수포스터 (PRD_000121)

접착방수포스터는 실사(대형 실사 출력물) 카테고리 **포스터**의 **완제품 단일**
(`prd_typ_cd=PRD_TYPE.01`) 상품이다. 접착면이 있는 방수 **PVC** 소재에 실사 대형 잉크젯으로
출력한다. 손님이 **규격(A3/A2/A1) 또는 비규격 치수**(가로 200~1200mm·세로 200~3000mm·200mm 증분)를
입력하면, 포스터사인 **[가로×세로] 면적매트릭스**에서 완제품가(코팅포함 통가격)를 조회한다. 파일
업로드 방식(`file_upload_yn=Y`·에디터 미사용). 수량·치수·자재·매트릭스 SHAPE raw 값은
[[product-121-adhesive-waterproof-poster-nodes]] 전사표가 권위(스크립트 전사·손전사 금지).

## 정체·유형 (SOT 준수)
- 상품유형 분류 SOT: **완제품(.01)** = 일반 단일 제조상품. 접착방수포스터는 `t_prd_product_sets`
  부모 등록이 없어(라이브 실측 — sets 0행) 셋트 완제품이 아니라 **일반 단일 완제품**(SOT 정합·
  [[rule/rules#RULE_scope_boundary]] 범위 안).
- 소재가 상품을 가른다(실사 4대 특성): 접착방수포스터 = 방수 PVC(접착면) — 방수포스터(120·비접착
  PET)와 소재/정체 구분. 인쇄방식 = 실사 대형 잉크젯 단일(도수 컬럼 없음·[[rule/rules#RULE_dosu_is_printopt]]).
- 카테고리: 주 = 포스터 `CAT_000004`(main_cat_yn=Y·level1 root) + 부 = 아트포스터 `CAT_000314`
  (main_cat_yn=N·level2·[[product-121-adhesive-waterproof-poster-nodes]] companion·축 승격 대기).

## 차원
- **사이즈:** 등록 규격 3행(A3 SIZ_000174 / A2 SIZ_000197 / A1 SIZ_000293) + **비규격 연속범위**
  (nonspec_yn=Y·가로 200~1200·세로 200~3000·200mm 증분·전사표). ★**비규격 범위는 입력 UX 한계일 뿐
  가격격자가 아니다** — 유효 가격 권위 = 면적매트릭스 셀(가격 경로 참조). off-grid = 가로·세로 각
  한 단계 큰 치수 ceiling(앱 런타임 계산·DB는 룩업행·[[rule/rules#RULE_price_value_boundary]]).
  ★A1 SIZ_000293은 정션 활성이나 마스터 `del_yn=Y`(2026-06-17 논리삭제) — dangling. 이 사이즈는
  실사 형제가 공유해 공유 사이즈 노드(product-119 companion size-SIZ_000293·[[gap-119-a1-master-deleted]])를
  재사용하며, 삭제 잔존 정합은 거기에 기록됨(121은 중복 mint 없이 참조).
- **도수(인쇄옵션):** 라이브 `t_prd_product_print_options` = 121 행 **없음**. 실사는 대형 잉크젯
  풀컬러라 도수(칼라/흑백) 컬럼 자체가 없다 — 결함이 아니라 **설계상 해당 없음**(pack §3.3·
  [[rule/rules#RULE_dosu_is_printopt]]).
- **수량규칙:** 제품 레벨 min 1 / max 1000 / incr 1(QTY_UNIT.01·전사표). `t_prd_product_bundle_qtys`에
  121 행 **없음**. ★**면적매트릭스는 수량축이 없다**(매트릭스 셀 = 완제품 통가격·min_qty=NULL)
  — 고정가형 실사(수량×규격)와 다른 아키타입(pack §3.4·§3.10).

## 자재·공정
- **자재:** PVC 단일(`MAT_000179`·MAT_TYPE.08 실사소재·USAGE.07 낱장 단일 슬롯). 접착방수 본체 자재.
  parent 없음(상위자재 -). 상세 = [[product-121-adhesive-waterproof-poster-nodes]].
  ★IMPORT 등록 자재 삭제 금지([[rule/rules#RULE_import_material_no_delete]]).
- **공정:** 라이브 `t_prd_product_processes` = 유광라미네이팅 `PROC_000014`·무광라미네이팅
  `PROC_000015` 2행(둘 다 `mand_proc_yn=N` 선택·부모 PROC_000013 라미네이팅). 이 두 공정이 곧
  **코팅 옵션**(아래 옵션그룹)의 선택지다. 두 공정 노드는 [[axis/processes#process-PROC_000014]]·
  [[axis/processes#process-PROC_000015]] 공유 축 기정의 **재사용**(중복 mint 없음).
  ★인쇄 base 공정(PROC_000004 디지털 base)은 실사에 **해당 없음** — 실사 인쇄방식은 대형 잉크젯이고
  가격은 완제품가 매트릭스에 출력·소재가 포함된다(디지털 "base proc 미바인딩=인쇄비 0" 결함
  [[rule/decisions#DEC_baseproc_260701]]과 **다름**·모델링 주의).

## 판형 (종이류 규칙 — ★해당 없음·비종이류)
- 라이브 `t_prd_product_plate_sizes` = 121에 3행(SIZ_000052/198/294) 있으나 `output_paper_typ_cd`가
  **"파일사양"**(output_file_typ=JPG)이다 — 판걸이수 산정용 출력용지 판형이 아니라 **파일 규격
  플레이스홀더**다. ★**실사는 비종이류 대형 롤 출력이라 절수 기반 전지(판형)가 무의미**
  (pack §3.8·[[rule/rules#RULE_plate_paper_only]] 종이류만 판형). 스티커/디지털 팩의 판형
  (fn_best_plate·fn_calc_pansu 판걸이수) 로직을 실사에 이식하면 오모델(pack T-7). 그래서
  `has_plate_size` 관계를 **걸지 않는다**(정직 표기·환각 방지).

## 가격 경로 (D-18 경계 — 값은 evaluate_price 권위)
- `product-121 --priced_by--> formula-PRF_POSTER_ADH_WP --has_component--> component-COMP_POSTER_ARTPRINT_PHOTO`.
  **가격 경로 연결됨(고아 공식 아님)** — 상품전용 공식이 완제품가 구성요소 1건을 배선한다.
- ★**D-WIRE 교정 반영(라이브 현재값):** round-2(mapping.md 2026-06-07)는 28 실사를 공유공식
  `PRF_POSTER_FIXED`에 묶고 매트릭스를 sparse(1~2셀)로 적재했으나, 라이브는 **상품전용 공식
  `PRF_POSTER_ADH_WP`로 재모델**(2026-06-17 upd)돼 배선 단절이 해소됐다. pack §3.11 round-2 D-WIRE
  GAP은 이 상품에 대해 **해소**(현재값 확증·mapping.md "PRF_POSTER_FIXED 바인딩"은 STALE).
- ★**동형결합(4소재 통합):** 배선된 구성요소 `COMP_POSTER_ARTPRINT_PHOTO`는 가격표가 동일한 4소재
  (아트프린트118·방수120·접착방수121·아트패브릭123)를 통합한 **완제품가**(comp_typ=PRC_COMPONENT_TYPE.06
  완제품비·use_dims=[siz_width,siz_height,min_qty]·52셀)다. 상품별 레거시 comp
  `COMP_POSTER_ADH_WATERPROOF_PVC`(52셀)는 `use_yn=N`으로 **은퇴**됐고 어떤 공식에도 미배선(정본
  공식이 동형 통합 comp를 씀). 상세 = [[product-121-adhesive-waterproof-poster-nodes]].
- **면적매트릭스형** = 원자합산형(인쇄+용지+공정 합산)·고정가 룩업과 다른 아키타입. (가로×세로)
  순서쌍이 고유 셀(**비대칭** — 가로600×세로1000 ≠ 가로1000×세로600·pack §3.11). 값은 기록하지 않는다(연결·차원·
  격자 shape까지만·값=evaluate_price·[[rule/rules#RULE_price_value_boundary]]).
- ★실사 시트 inline price(R/S/V 컬럼)는 가격 권위 **아님** [HARD] — 권위는 인쇄상품 가격표
  "포스터사인" 시트(pack §3.10·HARNESS-DOMAIN-RULES). 가격 계산 DDL(좌표 회귀·price-engine-ddl)은
  STALE(pack T-4)이라 인용하지 않음.

## 옵션·제약·추가상품
- **옵션그룹:** 코팅(`OPT_000007`·SEL_TYPE.01·min_sel=0·max_sel=1·mand_yn=N) — 무광코팅
  (OPV_000022·dflt_yn=Y)/유광코팅(OPV_000023) 2택. 2 item이 각각 공정(무광 PROC_000015·유광
  PROC_000014)을 가리켜(R11 option_refs·OPT_REF_DIM.04) 부모 has_process에 실재(L-18 통과). ★가격은
  **코팅포함 통가격**이라 코팅 선택이 매트릭스 단가를 바꾸지 않는다(마감 선택·가격 미가산). 상세 =
  [[product-121-adhesive-waterproof-poster-nodes]].
- **제약규칙:** `t_prd_product_constraints` = 121 **1행**(RULE_001 사용자입력 치수 범위·RULE_TYPE.01·
  가로 200~1200·세로 200~3000). 비규격 입력 시 치수 범위 검증(CN-5 범위형)·[[constraint-121-size-range]]로
  기록. ★pack §1.1/T-3: 위키 "실사 constraints 전부 0행"은 낡음 — 121은 1행 신규 발현(REVERIFY→현재값).
- **추가상품:** `t_prd_product_addons` = 121 **없음**(addon 미연결·부속붙는 8상품에 해당 안 됨).

## 승계·freshness 메모
- 정체·소재 13군·면적/고정 분기 의미 = pack-silsa §3(FRESH·INHERIT). ★결함 상태값은 §1.1·§4로
  재조준 — 위키 round-13 🔴을 그대로 옮기면 T-6 오염. 121 관련 재판정: 카테고리 정상연결(SL-DEF-001
  해소)·PVC .08 실사소재 정합(SL-DEF-002는 레더/패브릭 축·PVC 무관)·constraints 1행 발현(SL-CPQ-003
  신규)·부속 해당 없음.
- ★가격 배선은 mapping.md(2026-06-07)의 `PRF_POSTER_FIXED` 서술이 STALE — 라이브 20260702_1119는
  상품전용 `PRF_POSTER_ADH_WP` + 동형결합 comp. 본 노드는 **라이브 현재값 기준**(권위 순서상 라이브 >
  하네스 산출). 260702 엑셀 diff에 접착방수포스터 셀 변경 있으면 양면 표기 필요 — 현재 별도 권위
  충돌 미발견(면적매트릭스 값은 D-18 경계로 미전사).
- 라이브 현재값 = live-snapshot 20260702_1119. A1 규격(SIZ_000293) 마스터 삭제 잔존만 defect(양면)로
  분리 기록.
