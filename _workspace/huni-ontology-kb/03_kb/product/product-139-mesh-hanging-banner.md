---
id: product-139-mesh-hanging-banner
type: product
anchor: t_prd_products/PRD_000139
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000139(prd_nm=메쉬현수막·prd_typ_cd=PRD_TYPE.01·nonspec_yn=Y·use_yn=Y·del_yn=N·min/max/incr_qty=빈값)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-dbmap/02_mapping/silsa-poster-area-matrix/mapping.md", source_locator: "문서:§1.2 B27 메쉬현수막139↔면적매트릭스 13상품(면적 base + 옵션 add-on BUNDLE·comp 지목은 라이브 배선으로 재판정)", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-silsa}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "문서:§3.1·§3.6·§3.9·§3.10·§3.12 실사 정체·현수막 공정(타공/열재단/부착)·CPQ 옵션 BUNDLE·면적매트릭스형·부속 현수막(승계·재검증 2026-07-03)", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-silsa}
relations:
  - {rel: in_category, target: category-CAT_000315, note: "배너/현수막(cat_lvl=2·upr=CAT_000005 사인·main_cat_yn=N·06-19 신규노드·★136 PET배너 canonical 재사용·L-3)"}
  - {rel: has_size, target: size-139-SIZ_000323, note: "900x900 규격 preset(del_yn=N·dflt)"}
  - {rel: has_size, target: size-SIZ_000320, note: "900x1200 규격 preset(del_yn=N·dflt)"}
  - {rel: has_size, target: size-SIZ_000322, note: "5000x900 규격 preset(del_yn=N·dflt·★격자 가로축(max1200) 밖=coverage GAP)"}
  - {rel: uses_material, target: material-MAT_000183, note: "메쉬(본체·USAGE.07·dflt_yn=Y·★MAT_TYPE.08 미교정·128-nodes canonical 재사용)"}
  - {rel: uses_material, target: material-MAT_000070, note: "설치용끈(부속 BUNDLE·USAGE.07·dflt_yn=N·MAT_TYPE.16 실사부자재·끈추가 옵션 동반·★138 일반현수막 canonical 재사용)"}
  - {rel: has_process, target: process-PROC_000079, note: "타공(param 구수·가공 옵션그룹 참조대상·공유 axis/processes 재사용)"}
  - {rel: has_process, target: process-PROC_000081, note: "부착(param 대상 enum·끈 부착 BUNDLE·★138 canonical 재사용)"}
  - {rel: has_process, target: process-PROC_000084, note: "열재단(flat·★master del_yn=Y 논리삭제 vs 상품링크 활성 불일치·138이 defect 판정·138 canonical 재사용)"}
  - {rel: has_qty_rule, target: qty-139, note: "제품레벨 수량규칙(★min/max/incr 빈값·GAP-SL-8)"}
  - {rel: priced_by, target: formula-PRF_POSTER_BANNER_M, note: "완제품가 면적매트릭스 base + 옵션 add-on 5(큐방/끈/타공4/6/8) 가산형"}
  - {rel: has_option_group, target: optgroup-139-gagong, note: "가공 택1 필수(타공 4/6/8개)"}
  - {rel: has_option_group, target: optgroup-139-add, note: "추가 택0~1(추가없음/큐방/끈)"}
  - {rel: references, target: gap-126-roll-material-pricing, note: "롤 소재 셀단가 산정 로직 암묵지(엑셀 미기재·실사 전체 영향·GAP-2·126 canonical)"}
  - {rel: references, target: gap-139-add-option-unwired, note: "큐방/끈 추가 옵션 option_items 미배선(가격은 opt_cd 배선·차원 환원 부재)"}
  - {rel: references, target: gap-139-qty-null, note: "수량 min/max/incr 빈값(GAP-SL-8)"}
  - {rel: references, target: gap-139-wide-size-grid-coverage, note: "5000x900 preset이 격자 가로축(max1200) 밖·방향 해석=앱 로직 coverage 미확정"}
props:
  prd_typ_cd: PRD_TYPE.01
  semi_role_cd: null
  nonspec_yn: Y
  nonspec_range_ref: "전사표(transcribe_product_139.py) — 가로 500~900·세로 500~3000 raw 수치 손전사 아님"
  file_upload_yn: Y
  editor_yn: N
  min_qty_ref: "전사표(빈값·GAP-SL-8)"
  max_qty_ref: "전사표(빈값·GAP-SL-8)"
  qty_incr_ref: "전사표(빈값·GAP-SL-8)"
  qty_unit_typ_cd: QTY_UNIT.01
  use_yn: Y
  del_yn: N
  archetype: "면적매트릭스형(area-matrix·base use_dims=[siz_width,siz_height]) + 옵션 add-on 가산(BUNDLE)"
standards: {schema_org: Product, xjdf: "Product(현수막/Banner·LayoutIntent FinishedDimensions)", config_ont: "component type"}
answers_cq: ["구체 상품 질의(메쉬현수막 가격 경로·옵션)", "조건 탐색(실사 현수막 소재·타공·끈)"]
tags: ["#실사", "#사인", "#현수막", "#메쉬현수막", "#면적매트릭스", "#비종이류", "#CPQ"]
updated: 2026-07-03
---

# product-139 메쉬현수막 (PRD_000139)

메쉬현수막은 **실사(대형 실사 출력물)** 카테고리(배너/현수막)의 **완제품 단일**
(`prd_typ_cd=PRD_TYPE.01`) 상품이다. 바람이 통하는 **그물망(메쉬) 소재**의 대형 현수막으로,
손님이 **규격(900×900·900×1200·5000×900) 또는 사용자입력 치수**를 고르면 포스터사인
**[가로×세로] 면적매트릭스**에서 **기본 완제품가**를 조회하고, 여기에 **가공(타공 필수)·추가
(큐방/끈)** CPQ 옵션의 가산가를 더한다. 파일 업로드 방식(`file_upload_yn=Y`, 에디터 미사용).
수치(치수·매트릭스 SHAPE·옵션 단가)는 [[product-139-mesh-hanging-banner-nodes]] 전사표가
권위(스크립트 전사·손전사 금지·D-9).

★**형제 128 메쉬프린트와 소재(메쉬 MAT_000183)를 공유**하나, 128은 순수 면적매트릭스(옵션 0행)인
반면 **139는 현수막이라 후가공(타공·열재단·부착)·부속(끈/큐방)·CPQ 옵션 2그룹·제약 1행을 갖춘
풍부한 상품**이다(138 일반현수막 파일럿 동형). 128과 달리 base 구성요소도 **[단독](standalone)**
(4소재 동형결합 comp가 아님).

## 정체·유형 (SOT 준수)
- 상품유형 분류 SOT: **완제품(.01)** = 일반 단일 제조상품. 메쉬현수막은 `t_prd_product_sets`
  부모 등록이 없어(라이브 실측 — sets 0행) 셋트 완제품이 아니라 **일반 단일 완제품**(SOT 정합·
  [[rule/rules#RULE_scope_boundary]] 범위 안). 끈/큐방은 셋트 구성원(반제품)이 아니라 **CPQ 추가
  옵션**으로 표현된다(sets/addons 0행·option 레이어로 부속 표현·pack §3.12).
- 상품군 = **실사**(카테고리 005 사인 하위 배너/현수막). 굿즈/포장재 아님(정체 오분류 위험 없음).
- 카테고리: 배너/현수막 `CAT_000315`(cat_lvl=2·upr=CAT_000005 사인·main_cat_yn=N·06-19 신규노드).
  ★이 카테고리 노드는 **136 PET배너가 canonical 소유**([[product-136-pet-banner-nodes#category-CAT_000315]]·137 메쉬배너·138 일반현수막도 재사용) — 139는 in_category로 참조만(중복 mint 금지·L-3·병렬 배너/현수막 형제 공유 축).
- ★[REVERIFY→해소] round-13 "실사 28상품 전부 CAT_000298 고아"는 **STALE** — `CAT_000298`은
  `del_yn=Y` 논리삭제(06-18)됐고 139는 정상 카테고리 노드(CAT_000315)로 재연결됨(pack §1.1·§4
  T-1). 현재 상태=정상연결(defect 아님·양면 불요).

## 차원
- **사이즈:** 규격 3행(900×900 `SIZ_000323` / 900×1200 `SIZ_000320` / 5000×900 `SIZ_000322`·전부
  링크·마스터 del_yn=N·dflt_yn=Y) **+ 비규격 연속범위**(nonspec_yn=Y·가로 500~900mm incr100·세로
  500~3000mm incr100·전사표). ★**비규격 범위는 입력 UX 한계일 뿐 가격격자가 아니다**(pack §3.2) —
  유효 가격 권위 = 면적매트릭스 셀(§가격 경로).
- ★**소형·초대형 규격 vs 격자 coverage(정직 관찰):** base 매트릭스 가로축=900/1000/1200(3구간)·
  세로축=900~5000(16구간). 규격 `SIZ_000323`(900×900)은 최소셀과 정확히 일치하나, **`SIZ_000322`
  (5000×900)의 가로 5000mm는 격자 가로축(최대 1200) 밖**이다 — 방향 해석(가로↔세로 회전)은 앱
  런타임 로직 몫이라 KB 경계 밖이며, 이 preset이 어느 셀로 수렴하는지 원천 미확정
  ([[gap-139-wide-size-grid-coverage]]). 또 nonspec 하한(500)이 격자 최소(900)보다 작아 500~899
  주문은 900셀로 ceiling(pack §3.10 off-grid·118 small-size floor 동형).
- **도수(인쇄옵션):** 라이브 `t_prd_product_print_options` = 139 행 **없음**. 실사는 **대형 잉크젯
  풀컬러**라 도수(칼라/흑백) 컬럼 자체가 없다 — 결함이 아니라 **설계상 해당 없음**(pack §3.3·
  [[rule/rules#RULE_dosu_is_printopt]] 프레임 밖).
- **수량규칙:** 제품 레벨 수량규칙이나 **min/max/incr가 전부 빈값**(전사표·QTY_UNIT.01만 설정).
  `t_prd_product_bundle_qtys`에 139 행 **없음**. ★면적매트릭스형이라 **수량축이 가격 차원이 아니다**
  (base 셀단가=완제품 통가격·수량구간 할인 없음). 수량 빈값은 원본 미명시(pack §3.4 GAP-SL-8·
  [[gap-139-qty-null]]) — 홀로그램/유광아크릴과 함께 "유지 vs 동류값 보완" 미결(양면 아님·GAP).

## 자재·공정
- **자재 2슬롯:** ① **메쉬 `MAT_000183`**(본체·USAGE.07·dflt_yn=Y·★`MAT_TYPE.08` 미교정) — 형제
  128과 **동일 소재**라 [[product-128-mesh-print-nodes#material-MAT_000183]]가 canonical(재정의
  금지·L-3·139는 uses_material로 참조만). 메쉬 자재유형 정정 목표 미확정은 128 소유 GAP
  ([[gap-128-mesh-mattype-correction]]) 재참조. ② **설치용끈 `MAT_000070`**(부속 BUNDLE·USAGE.07·
  dflt_yn=N·`MAT_TYPE.16 실사부자재`·★138 일반현수막 canonical 소유·재사용) — "끈추가" 옵션 선택
  시 동반되는 실물 자재. ★IMPORT 등록 자재 삭제 금지([[rule/rules#RULE_import_material_no_delete]]).
- **공정 3:** ① **타공 `PROC_000079`**(param 구수 min1/max8·가공 옵션그룹이 참조·공유
  axis/processes 재사용) — 손님이 4/6/8개 택1. ② **열재단 `PROC_000084`**(flat·param 없음·메쉬천
  자체 열절단·순수 process·자재 없음·★138 canonical 소유) — ★상품링크는 활성(del_yn=N)이나 **공정
  마스터 del_yn=Y(2026-06-30 논리삭제)** 불일치(138이 defect 판정·127 타이벡 자재 마스터삭제 동형).
  ③ **부착 `PROC_000081`**(param 대상 enum=라벨/맥세이프/끈/테입·설치용끈 부착 BUNDLE·138 소유).
  실사 대형 잉크젯
  인쇄방식 공정(PROC_000006)은 라이브에 139 행 없다(실사 공통·po=0·설계상 정당·pack §3.7).
- ★타공 구수(4/6/8)는 **CPQ 옵션 3값 + 가격 add-on 3구성요소**로 표현되지, PROC_000079의
  prcs_dtl_opt param 인스턴스로 저장되지 않는다(og note "구수 param=GAP"·pack §3.6 GAP-SL-2 variant
  적재위치 논쟁) — 139는 **discrete-option 방식**을 실측(라이브 현재값·정직 표기).

## 판형 (★비종이류 — 해당 없음)
- 라이브 `t_prd_product_plate_sizes` = 139에 3행(SIZ_000323/320/322) 있으나 **전부 del_yn=Y**
  (2026-06-30 정리)이고 `output_paper_typ_cd`가 공란, 용도가 "파일사양"(output_file_typ=JPG)이다 —
  판걸이수 산정용 출력용지 판형이 아니라 **파일 규격 플레이스홀더**(전사표). ★실사는 **대형 롤
  출력**이라 절수 기반 전지 규격이 무의미(낱장 임포지션 없음) → 판형(`fn_best_plate`)·판걸이수
  (`fn_calc_pansu`·t_siz_pansu)는 **종이류 전용 로직이므로 실사에 적용 금지**(pack §3.8·T-7·
  [[rule/rules#RULE_plate_paper_only]]·[[harness-domain-rules-12-260701]]). 그래서 `has_plate_size`
  관계를 걸지 않는다(정직 표기·환각 방지·118/128 선례 동형).

## 가격 경로 (D-18 경계 — 값은 evaluate_price 권위)
- `product-139 --priced_by--> formula-PRF_POSTER_BANNER_M --has_component--> {6 구성요소}`.
  **가격 경로 연결됨(고아 공식·미배선 아님)** — 공식이 base 1 + add-on 5 = 6 구성요소를 배선한다
  (라이브 formula_components 6행 실측·O6 충족).
- ★**base + 옵션 add-on 가산 구조(BUNDLE·138 파일럿 동형):**
  - **base** = `COMP_POSTER_BANNER_MESH`([단독] standalone·comp note "동형 없음"·use_dims=
    `[siz_width, siz_height]`·48셀=가로3×세로16·20000~120000·전사표). 128의 4소재 동형결합
    (`COMP_POSTER_CANVAS_FABRIC`)과 달리 **139 전용**이라 139가 canonical 소유.
  - **옵션 add-on 5**(전부 addtn_yn=Y·가산): 큐방추가 `COMP_POSTEROPT_..._ADD_QBANG_4`(opt_cd
    OPV_000425·3000)·끈추가 `..._ADD_STRING_4`(opt_cd OPV_000426·4000)·타공 `..._PROC_PUNCH_4/6/8`
    (proc PROC_000079·dim_vals 타공수 4/6/8·3000/4000/5000). use_dims는 각각 `[opt_cd,opt_grp:...]`·
    `[proc_cd,min_qty,proc_grp:PROC_000079]`(전사표). 손님 선택이 해당 add-on 셀단가를 base에 더한다.
- **면적매트릭스형**(base) = 원자합산형(디지털)·고정룩업형(스티커 siz_cd)과 **다른 아키타입**.
  base는 단일 구성요소를 use_dims 2축(**가로 siz_width × 세로 siz_height**)으로 조회한다. off-grid=
  가로·세로 각 한 단계 큰 규격 ceiling(앱 계산·DB는 룩업행·pack §3.10). ★단 base use_dims에는
  min_qty가 없어(128의 3축과 달리 2축) 수량 무관 통가격(qty-139 빈값과 정합).
- 값(unit_price)은 노드에 기록하지 않는다(연결·격자·차원까지·값=evaluate_price·
  [[rule/rules#RULE_price_value_boundary]]). ★셀단가 산정 로직(롤 소재→셀단가)은 엑셀 미기재
  암묵지(실사 전체 공통 GAP·[[gap-126-roll-material-pricing]] 참조·중복 노드 미생성).

## 옵션·제약·추가상품
- **옵션그룹 2:** ① **가공**(`OPT_000022`·SEL_TYPE.01·min1/max1·mand_yn=**Y** 필수 — 타공4개
  OPV_000042(dflt)/타공6개 OPV_000043/타공8개 OPV_000044). option_items 3행이 각 타공 옵션→
  `PROC_000079`를 가리켜(R11 option_refs·OPT_REF_DIM.04) has_process 차원으로 환원(L-18 통과·부모
  139 has_process 실재). ② **추가**(`OPT_000023`·SEL_TYPE.01·min0/max1·mand_yn=N — 추가없음
  OPV_000045(dflt)/큐방4개 OPV_000425/끈4개 OPV_000426). ★**큐방·끈 옵션은 option_items 미배선**
  (0행·og note "L1 LINK 의존 BLOCKED"·추가없음만 INSERTABLE)이라 선택이 실물 차원(끈=MAT_000070·
  부착=PROC_000081)으로 환원되지 않는다 — 가격만 add-on 구성요소(opt_cd)로 배선됨. 이 배선 결함=
  [[gap-139-add-option-unwired]]. 상세=[[product-139-mesh-hanging-banner-nodes]].
- **제약규칙:** `t_prd_product_constraints` = 139에 **1행**(RULE_001 사용자입력 치수 범위·
  RULE_TYPE.01). 비규격 입력 시 가로/세로가 제품 nonspec 범위(전사표 500~900 × 500~3000) 안인지
  검증(CN-5 범위형·§31·폼빌더 정형 shape). ★[REVERIFY] 위키 "실사 constraints 전부 0행"은 **STALE**
  (139 포함 7상품 1행씩 신규 발현·pack §1.1·§4·T-3). 현재값=정답(정당한 범위 제약·defect 아님·양면
  불요·단 138 일반현수막은 여전히 0행). 상세=[[product-139-mesh-hanging-banner-nodes]].
- **추가상품:** `t_prd_product_addons`·`t_prd_product_sets` = 139 행 **없음**. 139는 부속(끈/큐방)을
  addon/set이 아니라 **CPQ 옵션**으로 표현한다(pack §3.12 138/139 현수막 CPQ 옵션·addon 미연결이
  결함 아님·설계 선택). 물리 부속 자재(끈 MAT_000070)는 uses_material로 실재.

## 승계·freshness 메모
- 정체·현수막 공정·CPQ BUNDLE·면적매트릭스 분기는 pack §3.1·§3.6·§3.9·§3.10·§3.12(FRESH·INHERIT)
  + mapping.md §1.2 승계·재검증(comp 지목만 라이브 배선으로 재판정).
- ★위키 🔴 결함 재조준(pack §4·T-6 오염 회피): 카테고리 고아(SL-DEF-001)·constraints 0행
  (SL-CPQ-003)은 **라이브 COMMIT으로 이미 해소** — 139는 정상 카테고리(CAT_000315) 연결 + 제약 1행.
  CPQ 옵션(SL-DEF-006)은 위키가 "138만"이라 했으나 **라이브 실측=139도 옵션 2그룹 보유**(위키/pack §4
  "나머지 27 실사 0행" 서술과 델타 — 139는 138과 함께 옵션 레이어 실재·정직 표기). round-13/위키를
  그대로 옮기면 오염이라 live-snapshot 20260702_1119 실측으로 재판정.
- 좌표 회귀·round-2 sparse 대표셀(T-4·T-5) 인용 안 함 — 명시 매트릭스 48셀 격자만 승계(mapping.md §2).
- 라이브 현재값 = live-snapshot 20260702_1119. 실사 시트는 260702 diff 무영향(pack §5)이라 권위 충돌
  미발견(카테고리·규격·배선은 현재값=정답). ★열린 상태 = 메쉬 자재유형 .08 미교정(128 GAP 재참조)·
  큐방/끈 옵션 배선 부재·수량 빈값·초대형 규격 격자 coverage(4 GAP 정직 선언).
