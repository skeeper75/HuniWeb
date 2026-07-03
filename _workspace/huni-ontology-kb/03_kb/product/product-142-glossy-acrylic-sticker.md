---
id: product-142-glossy-acrylic-sticker
type: product
anchor: t_prd_products/PRD_000142
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000142(prd_nm=유광아크릴스티커·prd_typ_cd=PRD_TYPE.01·nonspec_yn=N·min/max/qty_incr=공백·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "문서:§3.10 고정가형 15상품 중 유광아크릴스티커142(B28~B31)·§3.7(아크릴스티커 UV PROC_000002 라우팅)·§3.8(비종이류 판형없음)(승계·재검증 2026-07-03)", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-silsa}
  - {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "테이블:t_prc_price_components 키:COMP_POSTER_ACRYLSTK_GLOSS use_dims=[siz_cd](고정가 단일축 룩업·면적매트릭스 아님)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
relations:
  - {rel: in_category, target: category-CAT_000005, note: "사인(cat_lvl=1 root·142 main_cat_yn=Y 주 분류·live 실측)"}
  - {rel: in_category, target: category-CAT_000092, note: "시트커팅/스티커(cat_lvl=2·upr=CAT_000005·main_cat_yn=N·142-nodes 첫 정의)"}
  - {rel: has_size, target: size-SIZ_000324, note: "290x90mm(dflt_yn=Y·del_yn=N·142-nodes 정의·tags=아크릴스티커)"}
  - {rel: has_size, target: size-SIZ_000325, note: "290x190mm(dflt_yn=Y·del_yn=N·142-nodes 정의)"}
  - {rel: has_size, target: size-SIZ_000326, note: "390x290mm(dflt_yn=Y·del_yn=N·142-nodes 정의)"}
  - {rel: has_size, target: size-SIZ_000327, note: "590x390mm(dflt_yn=Y·del_yn=N·142-nodes 정의)"}
  - {rel: uses_material, target: material-MAT_000255, note: "화이트(MAT_TYPE.08 실사소재·USAGE.07·링크 활성·★마스터 del_yn=Y 불일치)"}
  - {rel: uses_material, target: material-MAT_000256, note: "블랙(MAT_TYPE.08 실사소재·USAGE.07·링크 활성·★마스터 del_yn=Y 불일치)"}
  - {rel: has_option_group, target: optgroup-142-color, note: "색상 택1(화이트/블랙)→자재 참조·가격 무관"}
  - {rel: has_qty_rule, target: qty-142, note: "★제품레벨 수량 공백(GAP-SL-8·미설정)"}
  - {rel: priced_by, target: formula-PRF_POSTER_ACRYLSTK_GLOSS, note: "완제품가 고정가 룩업형(siz_cd 단일축 셀단가·수량/색상축 없음)"}
props:
  prd_typ_cd: PRD_TYPE.01
  semi_role_cd: null
  nonspec_yn: N
  file_upload_yn: Y
  editor_yn: N
  min_qty: null
  max_qty: null
  qty_incr: null
  qty_unit_typ_cd: QTY_UNIT.01
  use_yn: Y
  del_yn: N
  archetype: "고정가 룩업형(fixed·use_dims=[siz_cd]·규격별 셀단가·수량/색상축 없음·면적매트릭스 아님)"
standards: {schema_org: Product, xjdf: "Product(스티커/Sticker·LayoutIntent FinishedDimensions)", config_ont: "component type"}
answers_cq: ["구체 상품 질의(유광아크릴스티커 가격 경로)", "조건 탐색(아크릴스티커 규격·색상)"]
tags: ["#실사", "#스티커", "#아크릴스티커", "#유광아크릴스티커", "#고정가룩업", "#비종이류"]
updated: 2026-07-03
---

# product-142 유광아크릴스티커 (PRD_000142)

유광아크릴스티커는 **실사(대형 실사 출력물·아크릴스티커)** 카테고리의 **완제품 단일**
(`prd_typ_cd=PRD_TYPE.01`) 상품이다. 손님이 **규격 4종**(290×90 / 290×190 / 390×290 / 590×390mm)과
**색상**(화이트/블랙)을 고르면, `(siz_cd)` **단일축 고정가 룩업**에서 **완제품 통가격**
(소재+출력+가공 포함)을 조회한다. ★색상(화이트/블랙)은 **가격에 영향을 주지 않는다**(구성요소
`use_dims=[siz_cd]`에 mat_cd가 없고 4셀 전부 색상 무관 통가격). 파일 업로드 방식(`file_upload_yn=Y`,
에디터 미사용·`nonspec_yn=N`이라 비규격 자유치수 없음). 수치는
[[product-142-glossy-acrylic-sticker-nodes]] 전사표가 권위(스크립트 전사·손전사 금지·D-9).

## 정체·유형 (SOT 준수)
- 상품유형 분류 SOT: **완제품(.01)** = 일반 단일 제조상품. 유광아크릴스티커는 `t_prd_product_sets`
  부모 등록이 없어(라이브 실측 — sets 0행) 셋트 완제품이 아니라 **일반 단일 완제품**(SOT 정합·
  [[rule/rules#RULE_scope_boundary]] 범위 안).
- 상품군 = **실사**(카테고리 005 사인 하위 092 시트커팅/스티커). 대형 실사 출력물의 아크릴 스티커
  완제품 — 굿즈/포장재 아님. ★자매 상품 미러아크릴스티커143(별도 comp `COMP_POSTER_ACRYLSTK_MIRROR`)와
  형제이나 별개 상품·별개 공식(142는 유광만).
- 카테고리: 사인 `CAT_000005`(root·lvl1·142 main_cat_yn=Y) + 시트커팅/스티커 `CAT_000092`(leaf·lvl2·
  upr=CAT_000005·main_cat_yn=N). ★[REVERIFY→해소] round-13 "실사 28상품 전부 CAT_000298 고아"는
  **STALE** — `CAT_000298`은 `del_yn=Y` 논리삭제(06-18)됐고 142는 정상 카테고리 노드로 재연결됨
  (pack §1.1·§4 T-1). 현재 상태=정상연결(defect 아님·양면 불요). ★포스터(004) 하위가 아니라 **사인(005)
  하위**임에 유의(130 포맥스=포스터 하위와 다른 계열).

## 차원
- **사이즈:** 이산 규격 **4행**(290×90 `SIZ_000324` / 290×190 `SIZ_000325` / 390×290 `SIZ_000326` /
  590×390 `SIZ_000327`·전부 dflt_yn=Y·del_yn=N·tags=`["아크릴스티커"]`·142/143 아크릴스티커 전용 규격).
  작업=재단 치수 동일(마진 0). `nonspec_yn=N`이라 **비규격 연속범위가 아예 없다**(사용자입력 치수 UX 없음·
  pack §3.2 부수). ★면적매트릭스(118/126 [가로×세로])와 달리 규격을 siz_cd로 직접 룩업한다.
- **도수(인쇄옵션):** 라이브 `t_prd_product_print_options` = 142 행 **없음**. 실사는 **대형 잉크젯/UV
  풀컬러**라 도수(칼라/흑백) 컬럼 자체가 없다 — 결함이 아니라 **설계상 해당 없음**(pack §3.3·
  [[rule/rules#RULE_dosu_is_printopt]] 프레임 밖).
- **색상(CPQ):** 도수와 별개로 **색상 옵션그룹**(화이트/블랙 택1·`optgroup-142-color`)이 있다. 색상은
  자재(MAT_000255/256)를 가리키는 CPQ 선택이며 **가격은 바꾸지 않는다**(옵션·제약 절 참조).
- **수량규칙:** ★제품 레벨 수량 컬럼(min_qty/max_qty/qty_incr)이 **전부 공백**이다(130의 1/10000/1과
  차이). `t_prd_product_bundle_qtys`도 0행. 수량 미설정은 pack §3.4 **[GAP-SL-8]**(유광아크릴스티커 수량
  L1 빈값·원본 미명시 정합)에 해당 — 값 미상 정직 선언
  ([[product-142-glossy-acrylic-sticker-nodes#gap-142-qty-blank]]). ★고정가 룩업형이라 **수량축이 가격
  차원이 아니다**(구성요소 use_dims=[siz_cd]에 수량 없음·min_qty NULL·수량구간 할인 없음·t_dsc_* 0행).
  총액=셀단가×수량. 수량 UI 권위=상품/사이즈 수량규칙(가격구간과 역할 분리·pack §3.4·
  [[rule/decisions#DEC_qty_audit_260702]]).

## 자재·공정
- **자재:** **화이트/블랙 2종**(낱장 완제품·내지/표지 없음·pack §3.5) — `MAT_000255`(화이트)·`MAT_000256`
  (블랙)·둘 다 `MAT_TYPE.08 실사소재`·USAGE.07 단일 슬롯·상위자재 없음. ★MAT_TYPE.08은 **실사소재**(코드
  개편 후에도 유효·pack §3.5)이며 실사 팩이 경고한 **레더 `MAT_000186` .08→.05 교정 crosscut과 무관**
  (레더는 100/126/296/298 횡단·pack §1.1·T-2 — 142는 아크릴스티커 색상 소재). ★[정직 관찰·잔존] 두 자재
  **마스터 `del_yn=Y`(06-16 논리삭제)** 인데 상품링크(`t_prd_product_materials`)는 `del_yn=N` 활성 →
  **불일치**(127 MAT_000188 선례). 색상 옵션이 이 두 자재를 참조하므로 삭제 마스터를 가리키는 상태·의도
  vs 결함 미확정([[product-142-glossy-acrylic-sticker-nodes#gap-142-color-material-deleted]]). ★IMPORT
  등록 자재 삭제 금지([[rule/rules#RULE_import_material_no_delete]]).
- **공정:** 라이브 `t_prd_product_processes` = 142 행 **0**. 아크릴스티커 인쇄방식 = **UV
  `PROC_000002`(레이저커팅 라인·pack §3.7·F-ID-4)** 이나 실사 공통으로 인쇄방식 공정 행이 라이브에 부재
  (proc=0·po=0·정당). 라미네이팅/후가공 공정도 없다(130 포맥스와 차이). ★공정 행 미적재는
  **[GAP-SL-A]**(UV 라우팅 공정 행 추가 여부·영향 작음·
  [[product-142-glossy-acrylic-sticker-nodes#gap-142-uv-process]]). 가격은 (siz_cd) 완제품 통가격이라
  UV 커팅이 통가격에 포함(comp note "출력+가공 포함")이면 별도 공정 노드 없이도 견적 무손상.

## 판형 (★비종이류 — 해당 없음)
- 라이브 `t_prd_product_plate_sizes` = 142에 4행(SIZ_000324~327) 있으나 `output_paper_typ_cd`가
  **전부 공란**이고 용도가 "파일사양"(output_file_typ=AI)이며 **전부 `del_yn=Y`(2026-06-30 정리)** —
  판걸이수 산정용 출력용지 판형이 아니라 삭제된 파일 규격 플레이스홀더다. ★실사 아크릴스티커는
  **비종이류**라 절수 기반 전지 규격이 무의미(낱장 임포지션 없음) → 판형(`fn_best_plate`)·판걸이수
  (`fn_calc_pansu`·t_siz_pansu)는 **종이류 전용 로직이므로 실사에 적용 금지**(pack §3.8·T-7·
  [[rule/rules#RULE_plate_paper_only]]·[[rule/rules#RULE_pansu_db_function]]). 그래서 `has_plate_size`
  관계를 걸지 않는다(정직 표기·환각 방지·130/126 선례 동형).

## 가격 경로 (D-18 경계 — 값은 evaluate_price 권위)
- `product-142 --priced_by--> formula-PRF_POSTER_ACRYLSTK_GLOSS --has_component--> component-COMP_POSTER_ACRYLSTK_GLOSS`.
  **가격 경로 연결됨(고아 공식·미배선 아님)** — 공식이 완제품가 구성요소 1건을 배선한다(formula_components
  06-18 배선·addtn_yn=Y·pack §27 배선 정합).
- **고정가 룩업형(단일축)** = 면적매트릭스형(118/126 포스터·[가로×세로])·원자합산형(디지털 인쇄+용지+공정
  합산)·2축 고정가(130 포맥스 [mat_cd×siz_cd])과 **다른 아키타입**. 단일 구성요소
  `COMP_POSTER_ACRYLSTK_GLOSS`를 use_dims **1축**(**사이즈 siz_cd**)으로 조회한다. 격자=**유효 4셀**
  (규격 4종 각 1행)이 이 빠짐 없이 충전(전사표 grid_full 4/4·수량축·색상축 없음·min_qty·mat_cd NULL).
- ★공식 frm_nm이 "(면적/규격 단가)"로 명명됐으나 실 use_dims는 [siz_cd] **규격 직접 룩업**(면적매트릭스
  아님·전사표 검증·130 포맥스 동일 명명 함정). "실사 전부 면적매트릭스로 일괄"(round-2 오모델·pack §3.10
  적대적 주의)에 넘어가지 않음.
- 값(unit_price)은 기록하지 않는다(연결·격자완전성·차원까지·값=evaluate_price·
  [[rule/rules#RULE_price_value_boundary]]). 단가는 인쇄상품 가격표 260527/comp note verbatim이며 계산은
  엔진 권위. 산정 근거는 엑셀 미기재 암묵지 GAP
  ([[product-142-glossy-acrylic-sticker-nodes#gap-142-fixedprice-basis]]).

## 옵션·제약·추가상품
- **옵션그룹:** `t_prd_product_option_groups` = 142에 **1행**(색상 `OPT_000069`·SEL_TYPE.01 택1·min/max
  1/1·mand_yn=Y·use_yn=Y). 130(0행)과 달리 142는 **색상 CPQ 축**을 가진다. 화이트(OPV_000450·dflt)/블랙
  (OPV_000451) 각 option_item이 자재(MAT_000255/256)를 `OPT_REF_DIM.03`으로 가리켜(R11 option_refs·
  L-18 부모 142 uses_material 실재·`fn_chk_opt_item_ref` 정합) uses_material 차원으로 환원된다. ★색상은
  **가격 무관**(구성요소 use_dims=[siz_cd]에 mat_cd 없음·4셀 색상 불문 동일가). 상세=
  [[product-142-glossy-acrylic-sticker-nodes#optgroup-142-color]].
- **제약규칙:** `t_prd_product_constraints` = 142 행 **0**. 142는 pack §1.1의 constraints 신규 발현
  7상품(118/120/121/122/124/125/139)에 **포함되지 않는다** — 0행이 현재값(nonspec_yn=N이라 사용자입력
  치수 범위 제약 자체가 불필요·defect 아님·양면 불요·SL-CPQ-003 재조준 결과 142=무관).
- **추가상품:** `t_prd_product_addons`·`t_prd_product_sets` = 142 행 **없음**. 142는 부속붙는 상품이
  아니다(부속 8상품=133~137·131/132·138/139·pack §3.12). addon 미연결이 결함 아님(설계상 해당 없음).

## 승계·freshness 메모
- 정체·소재계열·고정가형 분기는 pack §3.1·§3.7·§3.8·§3.10(FRESH·INHERIT) 승계·재검증. 142=고정가 15상품
  (B28~B31·pack §3.10 verbatim).
- ★위키 🔴 결함 재조준(pack §4·T-6 오염 회피): 카테고리 고아(SL-DEF-001)는 **라이브 COMMIT으로 이미
  해소** — 142는 정상 카테고리 연결(사인+시트커팅/스티커). constraints는 142가 신규 발현 7상품에 없어
  0행이 정당(SL-CPQ-003 재조준 결과 142=무관). round-13/위키를 그대로 옮기면 오염이라 live-snapshot
  20260702_1119 실측으로 재판정(현재값=정답).
- ★면적매트릭스 오모델 회피(T-4·T-5): 142는 **면적매트릭스가 아니라 고정가 단일축 룩업**
  (use_dims=[siz_cd])임을 라이브 실측으로 확정. 공식 frm_nm "(면적/규격 단가)"는 명명일 뿐·실 use_dims=
  [siz_cd] 규격 직접 룩업(전사표 검증).
- 라이브 현재값 = live-snapshot 20260702_1119. 실사 시트는 260702 diff 무영향(pack §5)이라 값 권위 충돌
  미발견(현재값=정답 판정). 단, ① 자재 마스터 del_yn=Y 불일치 ② 수량 공백 ③ UV 공정 미적재는 GAP/정직
  관찰로 명시(지어내지 않음).
