---
id: product-135-scroll-poster
type: product
anchor: t_prd_products/PRD_000135
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000135(prd_nm=족자포스터·prd_typ_cd=PRD_TYPE.01·nonspec_yn=N·file_upload_yn=Y·editor_yn=N·use_yn=Y·del_yn=N·min1/max10000/incr1)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-dbmap/02_mapping/silsa-poster-area-matrix/mapping.md", source_locator: "문서:§1.1·§5 고정가형 15상품(포스터사인 [수량×규격] 블록) 중 족자포스터135", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-silsa}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "문서:§3.6·§3.10·§3.12 실사 정체·고정가형·족자제작 공정·천정고리 부속(승계·재검증 2026-07-03)", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-silsa}
relations:
  - {rel: in_category, target: category-CAT_000004, note: "포스터(cat_lvl=1 root·병렬 실사빌더 119 소유노드 참조·135 junction 실재)"}
  - {rel: in_category, target: category-CAT_000080, note: "보드액자(cat_lvl=2·upr CAT_000004·131 소유노드 참조·135 junction 실재)"}
  - {rel: has_size, target: size-SIZ_000174, note: "A3 규격(047 소유노드 참조·del_yn=N)"}
  - {rel: has_size, target: size-SIZ_000197, note: "A2 규격(axis/sizes 공유노드 참조·del_yn=N)"}
  - {rel: has_size, target: size-SIZ_000294, note: "A1 규격(118 소유노드 참조·del_yn=N)"}
  - {rel: has_size, target: size-SIZ_000319, note: "300x600 정형치수(135 신설·del_yn=N)"}
  - {rel: has_size, target: size-SIZ_000320, note: "900x1200 정형치수(135 신설·del_yn=N)"}
  - {rel: uses_material, target: material-MAT_000178, note: "PET(실사소재 MAT_TYPE.08·단일 슬롯 USAGE.07·dflt_yn=Y·axis/materials 공유노드 참조)"}
  - {rel: has_process, target: process-PROC_000082, qualifier: mandatory, note: "족자제작(mand·족자모양 param=GAP·135 신설·needed_shared)"}
  - {rel: has_qty_rule, target: qty-135, note: "제품레벨 min1/max10000/incr1(QTY_UNIT.01)"}
  - {rel: priced_by, target: formula-PRF_POSTER_JOKJA, note: "완제품가 고정가형(siz_cd 룩업)+천정고리 opt 가산"}
  - {rel: has_option_group, target: optgroup-135-gagong, note: "가공 택1(사각족자/원형족자·족자제작 param)"}
  - {rel: has_option_group, target: optgroup-135-add, note: "추가 택1(추가없음/천정형고리 포함·가산가격)"}
props:
  prd_typ_cd: PRD_TYPE.01
  semi_role_cd: null
  nonspec_yn: N
  file_upload_yn: Y
  editor_yn: N
  min_qty: 1
  max_qty: 10000
  qty_incr: 1
  qty_unit_typ_cd: QTY_UNIT.01
  use_yn: Y
  del_yn: N
  archetype: "고정가형(fixed-price·siz_cd 룩업·use_dims=[siz_cd,min_qty] + 천정고리 opt_cd 가산·면적매트릭스 아님)"
standards: {schema_org: Product, xjdf: "Product(족자포스터/Scroll Poster·LayoutIntent FinishedDimensions)", config_ont: "component type"}
answers_cq: ["구체 상품 질의(족자포스터 가격 경로)", "조건 탐색(실사 소재·규격·족자모양·천정고리)"]
tags: ["#실사", "#포스터", "#족자포스터", "#고정가형", "#비종이류"]
updated: 2026-07-03
---

# product-135 족자포스터 (PRD_000135)

족자포스터는 **실사(대형 실사 출력물)** 카테고리의 **완제품 단일**(`prd_typ_cd=PRD_TYPE.01`)
상품이다. 손님이 **등록 규격(A3/A2/A1·300×600·900×1200)** 과 **족자모양(사각/원형)·천정형고리 추가**를
고르면, 포스터사인 **[수량 × 규격] 고정가**에서 **완제품 통가격**(소재+출력+가공 포함)을 규격
`siz_cd`로 조회하고, 천정고리 선택 시 별도 가산가를 더한다. 파일 업로드 방식(`file_upload_yn=Y`,
에디터 미사용). 수치(치수·SHAPE)는 [[product-135-scroll-poster-nodes]] 전사표가 권위(스크립트
전사·손전사 금지·D-9).

★**아키타입 구별:** 118 아트프린트포스터의 **면적매트릭스형**(가로×세로 순서쌍 셀·off-grid ceiling)과
달리, 135는 **고정가형**(등록 규격 `siz_cd` 키 룩업·수량 단일밴드)이다 — 131 프레임리스우드액자와 동형
아키타입(실사 고정가 15상품·pack §3.10). "29 실사 전부 면적매트릭스" 일괄은 round-2 오모델(적대적 주의).

## 정체·유형 (SOT 준수)
- 상품유형 분류 SOT: **완제품(.01)** = 일반 단일 제조상품. 족자포스터는 `t_prd_product_sets`
  부모 등록이 없어(라이브 실측 — sets 0행) 셋트 완제품이 아니라 **일반 단일 완제품**(SOT 정합·
  [[rule/rules#RULE_scope_boundary]] 범위 안).
- 상품군 = **실사**(카테고리 004 포스터). 굿즈/포장재 아님(정체 오분류 위험 없음·product-master 권위0 일관).
- 카테고리: 포스터 `CAT_000004`(root·119 소유노드) + 보드액자 `CAT_000080`(leaf·131 소유노드). 둘 다
  `t_prd_product_categories`에 135 junction 실재(2행). ★[REVERIFY→해소] round-13 "실사 28상품 전부
  CAT_000298 고아"는 **STALE** — `CAT_000298`은 `del_yn=Y` 논리삭제(06-18)됐고 135는 정상 카테고리
  2행으로 재연결됨(pack §4 SL-DEF-001·해소). 현재 상태=정상연결(defect 아님·양면 불요).

## 차원
- **사이즈:** 등록 규격/정형치수 **5행**(A3 `SIZ_000174` / A2 `SIZ_000197` / A1 `SIZ_000294` /
  300×600 `SIZ_000319` / 900×1200 `SIZ_000320`·전부 상품 `del_yn=N`·전사표). ★`nonspec_yn=N` —
  118(비규격 연속범위 Y)과 달리 **135는 등록 규격만**(사용자입력 자유치수 없음). 가격 조회 키 = 등록
  규격 `siz_cd`(면적 가로×세로 순서쌍 아님). 라이브 사이즈 마스터 `siz_width/height`는 규격 명목치라
  가격 차원이 아니며, 조회는 `siz_cd`로 한다.
- **도수(인쇄옵션):** 라이브 `t_prd_product_print_options` = 135 행 **없음**. 실사는 **대형 잉크젯
  풀컬러**라 도수(칼라/흑백) 컬럼 자체가 없다 — 결함이 아니라 **설계상 해당 없음**(pack §3.7·
  [[rule/rules#RULE_dosu_is_printopt]] 프레임 밖).
- **수량규칙:** 제품 레벨 수량규칙(전사표 min1/max10000/incr1·QTY_UNIT.01). `t_prd_product_bundle_qtys`에
  135 행 **없음**(제품 레벨 규칙만). ★고정가형이라 use_dims에 `min_qty`가 있으나 완제품가 단가행은
  **수량 단일밴드**(min_qty=1 한 밴드·전사표 수량밴드수=1)라 현재 수량구간 할인이 없다(총액=규격셀단가×수량).
  수량 UI 권위=제품 수량규칙(가격구간과 역할 분리·pack §3.4·[[rule/decisions#DEC_qty_audit_260702]]).

## 자재·공정
- **자재:** **PET 단일 소재**(`MAT_000178`·`MAT_TYPE.08 실사소재`·USAGE.07 단일 슬롯·dflt_yn=Y·낱장
  완제품·내지/표지 없음·pack §3.5). ★PET `.08` = **현재값이자 정답**(실사소재 정당·양면 불요). 실사
  팩이 경고한 **레더 `MAT_000186` .08→`.05` 교정 crosscut과 무관**(레더는 100/126/296/298 횡단이고
  135 PET은 아님·pack §1.1·§3.5·T-2). ★자재유형 라벨 개편으로 round-13 "레더=.06 가죽" 목표는 STALE —
  135와 무관하나 오전파 방지 위해 명기. ★IMPORT 등록 자재 삭제 금지([[rule/rules#RULE_import_material_no_delete]]).
- **공정:** **족자제작 `PROC_000082`**(mand·상위공정 없음·del_yn=N·전사표). 족자 후가공(봉/고리 등
  완성형태). 옵션그룹 "가공"(사각족자/원형족자)이 이 공정을 참조하나 **족자모양 param(사각↔원형)이
  공정 param 인스턴스로 흐르지 않는다**(option item 둘 다 `PROC_000082` 지목·param 미분화·GAP-SL-2·
  [[gap-135-jokja-shape-param]]). 실사 인쇄방식 공정(실사출력 `PROC_000006`)은 라이브에 135 행이 없다
  (실사 공통·po=0·설계상 정당·pack §3.7). 코팅은 완제품 통가격에 포함(별도 공정행 없음).

## 판형 (★비종이류 — 해당 없음)
- 라이브 `t_prd_product_plate_sizes` = 135에 5행(SIZ_000052/198/294/319/320) 있으나
  `output_paper_typ_cd`가 **전부 공란**이다 — 판걸이수 산정용 출력용지 판형이 아니라 **파일 규격
  플레이스홀더**다. ★실사는 **대형 롤 출력**이라 절수 기반 전지 규격이 무의미(낱장 임포지션 없음) →
  판형(`fn_best_plate`)·판걸이수(`fn_calc_pansu`·t_siz_pansu)는 **종이류 전용 로직이므로 실사에 적용
  금지**(pack §3.8·T-7·[[rule/rules#RULE_plate_paper_only]]·[[harness-domain-rules-12-260701]]). 그래서
  `has_plate_size` 관계를 걸지 않는다(정직 표기·환각 방지·118/131 선례 동형).

## 가격 경로 (D-18 경계 — 값은 evaluate_price 권위)
- `product-135 --priced_by--> formula-PRF_POSTER_JOKJA --has_component-->` **2 구성요소**:
  1. `COMP_POSTER_JOKJA`(disp_seq 1·addtn_yn=Y) — **완제품 통가격**(소재+출력+가공 포함·PRC_COMPONENT_TYPE.06·
     use_dims=`[siz_cd, min_qty]`). 규격 5셀 × 수량 1밴드 = **5셀 완전격자**(전사표 격자완전=True·미적재셀 0·
     상품 사이즈 5건 전부 단가행 실재).
  2. `COMP_POSTEROPT_JOKJA_CEILHOOK`(disp_seq 2·addtn_yn=Y·06-23 배선) — **천정형고리 가산가**
     (PRC_COMPONENT_TYPE.06·use_dims=`[opt_cd, min_qty]`). 천정고리 옵션(OPV_000431) 선택 시만 가산
     (2개1세트·규격무관 플랫). opt 1셀.
  **가격 경로 연결됨(고아 공식·미배선 아님)** — 공식이 완제품가 1 + 가산 1 = 2 구성요소를 배선한다.
- **고정가형** = 원자합산형(디지털 인쇄+용지+공정 합산)·면적매트릭스형(포스터사인 가로×세로 셀)과 **다른
  아키타입**. 규격 `siz_cd` 키 룩업이라 **off-grid ceiling·비대칭이 없다**(등록 규격만·118과 대비). 천정고리는
  addon 테이블이 아니라 **CPQ 옵션+가산 구성요소**로 표현된다(부속 표현 경로 미결·[[gap-135-ceilhook-addon-path]]).
- 값(unit_price)은 기록하지 않는다(연결·격자완전성·차원까지·값=evaluate_price·
  [[rule/rules#RULE_price_value_boundary]]).

## 옵션·제약·추가상품
- **옵션그룹 2:**
  - `OPT_000015` **가공**(SEL_TYPE.01·min1/max1·mand_yn=Y) — 족자모양 택1: 사각족자(OPV_000033·dflt) /
    원형족자(OPV_000034). 두 item 모두 `ref_dim_cd=OPT_REF_DIM.04`로 공정 `PROC_000082`를 가리켜 선택이
    has_process 차원으로 환원(R11 option_refs·L-18 부모정합 통과). 단 모양(사각↔원형) param은 미분화(GAP).
  - `OPT_000016` **추가**(SEL_TYPE.01·min0/max1·mand_yn=N) — 천정형고리 택1: 추가없음(OPV_000035·dflt) /
    천정형고리 포함(OPV_000431). 천정고리 옵션값은 option_items에 ref_dim이 없고, 대신 가격 구성요소
    `COMP_POSTEROPT_JOKJA_CEILHOOK`(opt_cd=OPV_000431)로 가산가가 흐른다(옵션→가격 경로).
  상세 = [[product-135-scroll-poster-nodes]].
- **제약규칙:** `t_prd_product_constraints` = 135에 **0행**. 118(nonspec 범위 제약 1행)과 달리 135는
  `nonspec_yn=N`(등록 규격만)이라 사용자입력 치수 범위 검증이 불필요 → **0행이 정당**(defect 아님·pack §3.9
  138 선례 동형). ★[REVERIFY] 위키 "실사 constraints 전부 0행"은 118 등 7상품에서 신규 발현으로 일부 낡았으나,
  135는 규격 상품이라 0행이 설계상 정답(양면 불요).
- **추가상품:** `t_prd_product_addons`·`t_prd_product_sets` = 135 행 **없음**. ★천정고리 부속은 addon/set이
  아니라 CPQ 옵션(OPT_000016)+가산 구성요소(CEILHOOK)로 이미 작동한다 — pack §3.12가 권고한 "족자포스터135→
  천정고리 PRD_000008 addon 재연결"은 미실행 잔존(PRD_000008 use_yn=N 비활성·활성화 선행). 부속 표현 경로가
  두 갈래(현재 작동 CPQ+가격 vs 권고 addon 재연결)라 결함이 아니라 **표현 경로 미결**([[gap-135-ceilhook-addon-path]]).

## 승계·freshness 메모
- 정체·소재계열·고정가 분기는 pack §3.6·§3.10·§3.12(FRESH·INHERIT) + mapping.md §1.1 승계·재검증. 고정가
  아키타입 정의는 131 선례 계승([[product-131-frameless-wood-frame-nodes]]).
- ★위키 🔴 결함 재조준(pack §4·T-6 오염 회피): 카테고리 고아(SL-DEF-001)는 **라이브 COMMIT으로 이미 해소**
  (135는 정상 카테고리 2행). 부속 0행(SL-DEF-005)은 **잔존**이나 천정고리는 CPQ+가격으로 작동(견적 0 아님).
  round-13/위키를 그대로 옮기면 오염이라 live-snapshot 20260702_1119 실측으로 재판정.
- ★족자 모양 param 손실(SL-DEF-003)은 **잔존 추정**(GAP-SL-2·option item param 미분화 실측·[[gap-135-jokja-shape-param]]).
- 라이브 현재값 = live-snapshot 20260702_1119. 실사 시트는 260702 diff 무영향(pack §5.5)이라 권위 충돌
  미발견(현재값=정답 판정). 롤 소재 완제품가 산정 로직은 엑셀 미기재 암묵지 GAP([[gap-135-price-basis]]).
