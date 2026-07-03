---
id: product-138-standard-hanging-banner
type: product
anchor: t_prd_products/PRD_000138
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000138(prd_nm=일반현수막·prd_typ_cd=PRD_TYPE.01·nonspec_yn=Y·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-dbmap/02_mapping/silsa-poster-area-matrix/mapping.md", source_locator: "문서:§1.2 B26 일반현수막138↔COMP_POSTER_BANNER_NORMAL(면적매트릭스 13상품 중 1·base [단독])", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-silsa}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "문서:§3.1·§3.9·§3.10·§3.11 실사 정체·CPQ 파일럿·면적매트릭스형(승계·재검증 2026-07-03)", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-silsa}
relations:
  - {rel: in_category, target: category-CAT_000315, note: "배너/현수막(cat_lvl=2·upr=CAT_000005 사인·06-19 신규노드)"}
  - {rel: has_size, target: size-SIZ_000322, note: "5000x900 규격(dflt·impos_yn=N) + nonspec 연속범위"}
  - {rel: uses_material, target: material-MAT_000182, note: "현수막천(본체·USAGE.07·dflt)"}
  - {rel: uses_material, target: material-MAT_000070, note: "설치용끈(CPQ 추가·부착 번들)"}
  - {rel: uses_material, target: material-MAT_000337, note: "큐방(CPQ 추가·부착 번들)"}
  - {rel: uses_material, target: material-MAT_000338, note: "각목 900이하(CPQ 추가·부착 번들)"}
  - {rel: uses_material, target: material-MAT_000069, note: "양면테입(가공 번들·★마스터 삭제 드리프트·defect)"}
  - {rel: uses_material, target: material-MAT_000340, note: "봉제사(봉미싱 번들·★마스터 삭제 드리프트·defect)"}
  - {rel: has_process, target: process-PROC_000080, note: "봉제(봉미싱 param)"}
  - {rel: has_process, target: process-PROC_000081, note: "부착(끈/테입 등 대상 enum)"}
  - {rel: has_process, target: process-PROC_000104, note: "현수막타공(타공수 param·079 대체)"}
  - {rel: has_process, target: process-PROC_000084, note: "열재단(가공 기본값·★마스터 삭제 드리프트·defect)"}
  - {rel: has_qty_rule, target: qty-138, note: "제품레벨 min1/max10000/incr1(QTY_UNIT.01)"}
  - {rel: priced_by, target: formula-PRF_POSTER_BANNER_N, note: "base 면적매트릭스 완제품가 + 8 옵션 추가가격(9 구성요소)"}
  - {rel: has_option_group, target: optgroup-138-processing, note: "가공 택1 필수(열재단/타공/양면테입/봉미싱)"}
  - {rel: has_option_group, target: optgroup-138-additional, note: "추가 택1 선택(추가없음/큐방/끈/각목+끈)"}
  - {rel: has_option_group, target: optgroup-138-gakmok-side, note: "각목 부착 변 택1(세로변/가로변·UX만)"}
props:
  prd_typ_cd: PRD_TYPE.01
  semi_role_cd: null
  nonspec_yn: Y
  nonspec_range_ref: "전사표(transcribe_product_138.py) — 가로 500~1750(incr100)·세로 500~5000(incr100) raw 수치 손전사 아님"
  file_upload_yn: Y
  editor_yn: N
  min_qty: 1
  max_qty: 10000
  qty_incr: 1
  qty_unit_typ_cd: QTY_UNIT.01
  use_yn: Y
  del_yn: N
  archetype: "면적매트릭스형+CPQ(area-matrix base [단독]·use_dims=[siz_width,siz_height] + 옵션 추가가격 8종·라이브 최초 옵션 레이어 파일럿)"
standards: {schema_org: Product, xjdf: "Product(현수막/Banner·LayoutIntent FinishedDimensions·Finishings 봉제/타공)", config_ont: "component type + option group"}
answers_cq: ["구체 상품 질의(일반현수막 가격 경로)", "조건 탐색(현수막 소재·규격·가공옵션·부속)"]
tags: ["#실사", "#현수막", "#일반현수막", "#면적매트릭스", "#CPQ", "#비종이류"]
updated: 2026-07-03
---

# product-138 일반현수막 (PRD_000138)

일반현수막은 **실사(대형 실사 출력물)** 카테고리의 **완제품 단일**(`prd_typ_cd=PRD_TYPE.01`)
상품이다. 손님이 **규격(5000×900) 또는 사용자입력 치수**와 **가공(열재단/타공/양면테입/봉미싱)·
부속 추가(큐방/끈/각목+끈)** 를 고르면, 포스터사인 **[가로×세로] 면적매트릭스**의 base 완제품가에
선택 옵션의 **추가가격**을 합산한다. 파일 업로드 방식(`file_upload_yn=Y`·에디터 미사용). 138은
실사 상품 중 **라이브 최초 CPQ 옵션 레이어**(og=3·oi=18)가 실적재된 파일럿이다(pack §3.9). 수치
(치수·매트릭스 SHAPE·구성요소 행수)는 [[product-138-standard-hanging-banner-nodes]] 전사표가
권위(스크립트 전사·손전사 금지·D-9).

## 정체·유형 (SOT 준수)
- 상품유형 분류 SOT: **완제품(.01)** = 일반 단일 제조상품. 일반현수막은 `t_prd_product_sets`
  부모 등록이 없어(라이브 실측 — sets 0행) 셋트 완제품이 아니라 **일반 단일 완제품**(SOT 정합·
  [[rule/rules#RULE_scope_boundary]] 범위 안). 부속(끈/각목)은 셋트 구성원이 아니라 **CPQ 옵션+옵션
  자재**로 표현된다(addon/set 0행·§추가상품).
- 상품군 = **실사**(카테고리 005 사인 하위 배너/현수막). 굿즈/포장재 아님(정체 오분류 위험 없음).
- 카테고리: 배너/현수막 `CAT_000315`(cat_lvl=2·upr=`CAT_000005` 사인·06-19 신규노드). 라이브
  `t_prd_product_categories`에 138 행은 CAT_000315 **1건**(main_cat_yn=N). ★[REVERIFY→해소] round-13
  "실사 28상품 전부 CAT_000298 고아"는 **STALE** — `CAT_000298`은 `del_yn=Y` 논리삭제(06-18)됐고 138은
  정상 카테고리 노드로 재연결됨(pack §1.1·§4 T-1). 현재 상태=정상연결(defect 아님·양면 불요).

## 차원
- **사이즈:** 규격 1행(`SIZ_000322` 5000×900·dflt·impos_yn=N) **+ 비규격 연속범위**(nonspec_yn=Y·가로
  500~1750mm·세로 500~5000mm·각 incr 100·전사표). ★**비규격 범위는 입력 UX 한계일 뿐 가격격자가
  아니다**(pack §3.2) — 유효 가격 권위 = 면적매트릭스 셀(§가격 경로). 118 포스터(A3/A2/A1 규격 3행)와
  달리 138은 preset 규격 1개(5000×900 대형 롤)만 두고 대부분 사용자입력에 의존.
- **도수(인쇄옵션):** 라이브 `t_prd_product_print_options` = 138 행 **없음**. 실사는 **대형 잉크젯
  풀컬러**라 도수(칼라/흑백) 컬럼 자체가 없다 — 결함이 아니라 **설계상 해당 없음**(pack §3.3·
  [[rule/rules#RULE_dosu_is_printopt]] 프레임 밖).
- **수량규칙:** 제품 레벨 수량규칙(전사표 min1/max10000/incr1·QTY_UNIT.01). `t_prd_product_bundle_qtys`에
  138 행 **없음**(제품 레벨 규칙만). ★base 면적매트릭스 단가행에는 min_qty가 채워져 있으나(수량축충전
  =True·전사표) 전부 min_qty=1이라 사실상 수량무관 셀단가다. 총액=셀단가×수량(수량구간 할인 없음). 수량
  UI 권위=제품 수량규칙(가격구간과 역할 분리·pack §3.4·[[rule/decisions#DEC_qty_audit_260702]]).

## 자재·공정
- **자재(본체 + CPQ 번들):** 본체 = **현수막천 `MAT_000182`**(USAGE.07·dflt·`MAT_TYPE.08 실사소재`).
  ★현수막천은 마스터 note에 "정정 2026-06-14: 실사소재(.08)→원단(.05)"이 적혀 있으나 **현재값은 여전히
  `.08`**(패브릭 3소재=그래픽천/현수막천/메쉬는 아직 .08·pack §1.1·§3.5·T-2 목표 라벨 STALE 주의). 그
  외 CPQ 옵션 자재 = 설치용끈 `MAT_000070`(.16)·큐방 `MAT_000337`(.16)·각목 `MAT_000338`(.07·900이하).
  ★**삭제 마스터 드리프트 2건**: 양면테입 `MAT_000069`·봉제사 `MAT_000340`는 **마스터 `del_yn=Y`(06-30/
  06-27 삭제)** 인데 상품링크·활성 option_item·가격 구성요소가 여전히 참조 → **양면(defect) 노드**로
  선언(현재값 vs 정답·[[product-138-standard-hanging-banner-nodes#자재]]). ★IMPORT 등록 자재 삭제 금지
  ([[rule/rules#RULE_import_material_no_delete]]).
- **공정(후가공):** 봉제 `PROC_000080`(봉미싱 유형·폭 param)·부착 `PROC_000081`(대상 enum: 라벨/맥세이프/
  끈/테입)·현수막타공 `PROC_000104`(타공수 0~8 param·구 타공 `PROC_000079`를 상품에서 06-22 교체). ★**삭제
  마스터 드리프트 1건**: 열재단 `PROC_000084`는 **마스터 `del_yn=Y`(06-30 삭제)** 인데 가공 필수그룹의
  **기본값** option_item + 열재단 추가가격 구성요소가 참조 → **양면(defect) 노드**로 선언
  ([[product-138-standard-hanging-banner-nodes#공정]]). 실사 대형 잉크젯 인쇄방식 공정(PROC_000006)은
  라이브에 138 행이 없다(실사 공통·po=0·설계상 정당·pack §3.7).

## 판형 (★비종이류 — 해당 없음)
- 라이브 `t_prd_product_plate_sizes` = 138 행이 있었으나 `output_file_typ=JPG`·용도 "파일사양"의
  placeholder였고 **06-30 `del_yn=Y` 논리삭제**됐다(전사 원천 실측). ★실사는 **대형 롤 출력**이라 절수
  기반 전지 규격이 무의미(낱장 임포지션 없음) → 판형(`fn_best_plate`)·판걸이수(`fn_calc_pansu`·t_siz_pansu)는
  **종이류 전용 로직이므로 실사에 적용 금지**(pack §3.8·T-7·[[rule/rules#RULE_plate_paper_only]]·
  [[harness-domain-rules-12-260701]]). 그래서 `has_plate_size` 관계를 걸지 않는다(정직 표기·환각 방지·
  118/050 선례 동형).

## 가격 경로 (D-18 경계 — 값은 evaluate_price 권위)
- `product-138 --priced_by--> formula-PRF_POSTER_BANNER_N --has_component--> {base + 8 옵션 추가가격}`.
  **가격 경로 연결됨(고아 공식·미배선 아님)** — 공식이 **9 구성요소**를 배선한다(전사표 formula 블록).
- **면적매트릭스형+CPQ** = 118 포스터(단일 comp)와 달리 **base + 옵션 추가가격 합산** 구조:
  - seq1 base = `COMP_POSTER_BANNER_NORMAL`(use_dims=`[siz_width,siz_height]`·**[단독] 동형결합 없음**·
    가로 5구간×세로 16구간=80셀·격자완전 True·완제품 통가격). ★118의 동형결합(4소재 공유)과 달리 현수막은
    **단독 comp**(comp note "[단독] 동형 없음")이라 소재축이 없다(현수막천 단일).
  - seq2~9 = 선택 가공/추가 옵션의 **추가가격** 구성요소(타공/열재단/양면테입/봉미싱/큐방/끈/각목+끈).
    use_dims가 `[opt_cd, opt_grp:...]` 또는 `[proc_cd, min_qty, proc_grp:...]`로 옵션 선택을 가격에 환원.
- 값(unit_price)은 기록하지 않는다(연결·격자완전성·차원까지·값=evaluate_price·
  [[rule/rules#RULE_price_value_boundary]]). base 셀단가 산정 근거는 롤 소재 암묵지
  ([[gap-138-roll-price-logic]]).

## 옵션·제약·추가상품
- **옵션그룹 3(라이브 최초 실사 CPQ):** ① 가공(`OPT_000003`·SEL_TYPE.01·min1/max1·mand_yn=Y — 열재단
  기본/타공4·6·8/양면테입/봉미싱) ② 추가(`OPT_000004`·min0/max1·mand_yn=N — 추가없음 센티넬/큐방/끈/
  각목900이하+끈/각목900초과+끈) ③ 각목 부착 변(`OPT_000063`·min0/max1 — 세로변/가로변·option_item 없음
  =UX 선택만). 옵션 item은 자재(OPT_REF_DIM.03)·공정(OPT_REF_DIM.04)을 polymorphic 참조해 선택이
  uses_material·has_process 차원으로 환원(R11 option_refs·L-18 부모정합 통과). 상세=
  [[product-138-standard-hanging-banner-nodes]]. ★옵션=자재+공정 BUNDLE(한 옵션 두 의미·pack §3.9).
- **제약규칙:** `t_prd_product_constraints` = 138에 **0행**. ★[REVERIFY] 위키 "실사 constraints 전부
  0행"은 다른 6상품(118/120/121/122/124/125)에선 STALE(1행씩 신규 발현)이나 **138은 여전히 0행이 맞다**
  (pack §1.1·§3.9·§4 SL-CPQ-003). 비규격 입력 치수 범위(500~1750×500~5000)·각목 부착변 선택이 제약으로
  표현되지 않은 상태 → [[gap-138-nonspec-no-constraint]](GAP-SL-7). 118/122가 가진 RULE_001 치수범위
  제약을 138은 아직 갖지 않음.
- **추가상품:** `t_prd_product_addons`·`t_prd_product_sets` = 138 행 **없음**. 138의 부속(끈/각목/큐방)은
  addon/set이 아니라 **CPQ 옵션 자재**로 표현(pack §3.12 — 138/139는 "현수막 CPQ 옵션" 유형). ★각목
  900초과 옵션(OPV_000016)이 900이하 자재(MAT_000338)를 참조하는 드리프트=[[gap-138-gakmok-gt-material]]
  (GAP-SL-5·MAT_000339 삭제 후 미대체).

## 승계·freshness 메모
- 정체·소재·면적매트릭스+CPQ 분기는 pack §3.1·§3.9·§3.10·§3.11(FRESH·INHERIT) + mapping.md §1.2 승계·재검증.
- ★위키 🔴 결함 재조준(pack §4·T-6 오염 회피): 카테고리 고아(SL-DEF-001)는 **라이브 COMMIT으로 이미 해소**
  (138 정상 연결). constraints는 **138에 한해 0행이 정답**(SL-CPQ-003·다른 6상품과 달리 미발현·GAP 잔존).
  삭제 마스터 드리프트(069/340/084)는 현재값 실측으로 defect 양면 표기(재연결/정리 대기).
- 좌표 회귀·round-2 sparse 대표셀(T-4·T-5) 인용 안 함 — 명시 매트릭스 80셀 완전격자만 승계(mapping.md §2).
  ★mapping.md는 79셀로 적었으나 라이브 현재=80셀(81행·1중복) — 현재값 전사(SHAPE만·값 미전사).
- 라이브 현재값 = live-snapshot 20260702_1119. 실사 시트는 260702 diff 무영향(pack §5.5)이라 권위 충돌
  미발견(현재값=정답 판정). 롤 소재 가격 계산 로직은 엑셀 미기재 암묵지 GAP([[gap-138-roll-price-logic]]).
