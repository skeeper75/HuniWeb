---
id: product-141-hologram-sheet-cutting
type: product
anchor: t_prd_products/PRD_000141
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000141(prd_nm=홀로그램 시트커팅·prd_typ_cd=PRD_TYPE.01·nonspec_yn=N·min/max/incr 공란·use_yn=Y·del_yn=N·editor_yn=N·file_upload_yn=Y·qty_unit=QTY_UNIT.01)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-dbmap/02_mapping/silsa-poster-area-matrix/mapping.md", source_locator: "문서:§1.1·§3.10 홀로그램시트커팅141=고정가형 15상품([수량×규격] 블록·포스터사인)·면적매트릭스 13상품 아님(승계·재검증 2026-07-03)", captured_at: "2026-07-03", badge: verified, src_id: SR-13-silsa-mapping}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "문서:§3.10·§3.3·§3.4·§0 실사 정체·고정가형(수량×규격)·화이트 underbase 홀로그램 도메인필수·수량 L1 빈값 GAP-SL-8(승계·재검증 2026-07-03)", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-silsa}
relations:
  - {rel: in_category, target: category-CAT_000092, note: "시트커팅/스티커(cat_lvl=2·상위 CAT_000005 사인·main_cat_yn=N·141 유일 등록 분류)"}
  - {rel: has_size, target: size-SIZ_000172, note: "A4 규격(210x297·del_yn=N·고정가 셀 실재)"}
  - {rel: has_size, target: size-SIZ_000174, note: "A3 규격(297x420·del_yn=N·고정가 셀 실재)"}
  - {rel: has_size, target: size-SIZ_000197, note: "A2 규격(420x594·del_yn=N·고정가 셀 실재)"}
  - {rel: uses_material, target: material-MAT_000257, note: "홀로그램(USAGE.07·MAT_TYPE.08·★마스터 del_yn=Y·junction 활성=불일치 정직 관찰)"}
  - {rel: has_qty_rule, target: qty-141, note: "제품레벨 min/max/incr 공란(QTY_UNIT.01)·pack GAP-SL-8"}
  - {rel: priced_by, target: formula-PRF_POSTER_SHEETCUT_HOLO, note: "완제품가 고정가형(규격 siz_cd 룩업·통가격·use_dims=[siz_cd] 단일축)"}
props:
  prd_typ_cd: PRD_TYPE.01
  semi_role_cd: null
  nonspec_yn: N
  file_upload_yn: Y
  editor_yn: N
  qty_unit_typ_cd: QTY_UNIT.01
  use_yn: Y
  del_yn: N
  archetype: "고정가형(fixed-price·siz_cd 룩업·use_dims=[siz_cd] 단일축) — 실사 2 가격모델 중 고정가(면적매트릭스 아님)·131과 달리 수량밴드 없음"
standards: {schema_org: Product, xjdf: "Product(시트커팅 출력물·LayoutIntent FinishedDimensions)", config_ont: "component type"}
answers_cq: ["구체 상품 질의(홀로그램 시트커팅 가격 경로)", "조건 탐색(시트커팅 규격 A4/A3/A2)"]
tags: ["#실사", "#시트커팅", "#홀로그램시트커팅", "#고정가형", "#비종이류"]
updated: 2026-07-03
---

# product-141 홀로그램 시트커팅 (PRD_000141)

홀로그램 시트커팅은 **실사(대형 실사 출력물)** 상품군의 **완제품 단일**(`prd_typ_cd=PRD_TYPE.01`) 상품이다.
손님이 **규격(A4/A3/A2)**을 고르면, 포스터사인 **고정가 [규격(siz_cd)]** 단가표에서 **완제품 통가격**
(출력+가공 포함가)을 조회한다. ★118 아트프린트포스터가 **면적매트릭스형**([가로×세로] 셀단가)인 것과
달리, 141은 실사 2 가격모델 중 **고정가형**(등록 규격 룩업)이다(pack §3.10 "고정가 15상품"). ★단 131
프레임리스우드액자(use_dims=`[siz_cd,min_qty]`)와도 달리 141은 **use_dims=`[siz_cd]` 단일축**(수량밴드
없음·규격당 단일 통가격)이다 — 같은 고정가 아키타입의 변형. 파일 업로드 방식(`file_upload_yn=Y`, 에디터
미사용). 수치(규격·고정가 SHAPE)는 [[product-141-hologram-sheet-cutting-nodes]] 전사표가 권위(스크립트
전사·손전사 금지·D-9).

## 정체·유형 (SOT 준수)
- 상품유형 분류 SOT: **완제품(.01)** = 일반 단일 제조상품. 홀로그램 시트커팅은 `t_prd_product_sets`
  부모 등록이 없어(라이브 실측 — sets 0행) 셋트 완제품이 아니라 **일반 단일 완제품**(SOT 정합·
  [[rule/rules#RULE_scope_boundary]] 범위 안).
- 상품군 = **실사**(카테고리 005 사인 하위 시트커팅/스티커). 굿즈/포장재 아님. 소재(홀로그램 시트)가
  상품 정체를 가르는 실사 특성(pack §0 특성1).
- 카테고리: **시트커팅/스티커 `CAT_000092`**(cat_lvl 2·상위 `CAT_000005` 사인·main_cat_yn=N·141 유일
  등록 분류·[[product-141-hologram-sheet-cutting-nodes]]). ★[REVERIFY→해소] round-13 "실사 28상품 전부
  CAT_000298 고아"는 **STALE** — `CAT_000298`은 `del_yn=Y` 논리삭제(06-18)됐고 141은 정상 시트커팅/스티커
  노드로 재연결됨(pack §1.1 CAT_000092(4)·§4 T-1). 현재 상태=정상연결(defect 아님·양면 불요).

## 차원
- **사이즈:** 등록 규격 **3행**(A4 `SIZ_000172` / A3 `SIZ_000174` / A2 `SIZ_000197`·전부 master·junction
  del_yn=N). ★**nonspec_yn=N** — 118·122·126 등 면적매트릭스 형제와 달리 141은 **사용자입력 치수가 없다**
  (등록 규격만 선택). 그래서 nonspec 연속범위·치수 입력 UX가 없고, off-grid ceiling 개념도 없다. 규격 3행이
  고정가 단가표의 3 셀(A4·A3·A2)과 정확히 일치(전사표 규격=가격셀 정합=True).
- **도수(인쇄옵션):** 라이브 `t_prd_product_print_options` = 141 행 **없음**. 실사는 **대형 잉크젯
  풀컬러**라 도수(칼라/흑백) 컬럼 자체가 없다 — 결함이 아니라 **설계상 해당 없음**(pack §3.3·
  [[rule/rules#RULE_dosu_is_printopt]] 프레임 밖).
- **수량규칙:** 제품 레벨 수량규칙 `min_qty/max_qty/qty_incr`이 **전부 공란**(QTY_UNIT.01·전사표).
  `t_prd_product_bundle_qtys`에 141 행 **없음**. ★고정가형 단가표의 수량축은 **밴드 0**(min_qty 공란·
  전사표 수량축충전=False) — 규격당 단일 통가격이며 수량구간 할인이 use_dims에 없다(131은 min_qty 축이라도
  있으나 141은 그마저 없다). 총액=규격 통가격×수량(엔진). ★수량 L1 빈값은 pack §3.4 GAP-SL-8(메쉬현수막/
  홀로그램/유광아크릴 수량 원본 미명시)에 해당 — 유지 vs 동류값 보완 미결로
  [[product-141-hologram-sheet-cutting-nodes#gap-141-qty-empty]] 정직 선언.

## 자재·공정
- **자재:** ★`t_prd_product_materials` = 141에 **1행**(홀로그램 `MAT_000257`·usage `USAGE.07` 낱장
  단일·mat_typ `MAT_TYPE.08` 실사소재). 131(자재 0행 baked)과 달리 141은 소재가 등록됐다. ★단 자재 마스터
  (`t_mat_materials`) `del_yn=Y`(2026-06-16 논리삭제)인데 상품링크(junction) `del_yn=N` 활성 = **링크활성/
  마스터삭제 불일치**(정직 관찰·127 타이벡소프트 동형·단정 아님·양면 아님=코드값 자체 불변). MAT_TYPE.08
  실사소재는 round-13 목표라벨(.06=가죽·.05=원단)이 코드 개편으로 **STALE**(T-2)이며 홀로그램 소재는 pack
  §1.1 교정 목록(레더/타이벡 .05)에 없어 `.08` 현재값 그대로 기록. IMPORT 등록 자재 삭제 금지
  ([[rule/rules#RULE_import_material_no_delete]]).
- **공정:** ★라이브 `t_prd_product_processes` = 141 행 **0개**(전사표). ①**화이트 underbase**
  (`PROC_000008`·상위 `PROC_000007 별색`)는 pack §3.3이 홀로그램141을 **도메인 필수**(반사 소재 위 불투명
  백색 받침)로 지목하나 **라이브에 연결 없음** → 결함 후보를 지어내지 않고
  [[product-141-hologram-sheet-cutting-nodes#gap-141-white-underbase]] 정직 선언(pack §3.3 "홀로그램141
  화이트 underbase 연결 여부 live 재측정"의 재측정 결과=부재). ②시트커팅의 커팅 공정도 0행 — 완제품가 note
  가 "소재+출력+가공 포함 통가격"이라 커팅이 통가격에 baked된 것으로 보인다. 실사 대형 잉크젯 인쇄방식 공정
  (PROC_000006)도 라이브에 141 행이 없다(실사 공통·po=0·설계상 정당·pack §3.7).

## 판형 (★비종이류 — 해당 없음)
- 라이브 `t_prd_product_plate_sizes` = 141에 3행(SIZ_000050 A4·SIZ_000052 A3·SIZ_000198 A2) 있으나
  `output_paper_typ_cd`가 **전부 공란**이고 `output_file_typ=AI`·용도가 "파일사양"이며 **전 행 `del_yn=Y`**
  (2026-06-30 논리삭제)다 — 판걸이수 산정용 출력용지 판형이 아니라 **파일 규격 플레이스홀더**(현재 삭제됨).
  ★실사는 **대형 롤/시트 출력**이라 절수 기반 전지 규격이 무의미(낱장 임포지션 없음) → 판형(`fn_best_plate`)·
  판걸이수(`fn_calc_pansu`·t_siz_pansu)는 **종이류 전용 로직이므로 실사에 적용 금지**(pack §3.8·T-7·
  [[rule/rules#RULE_plate_paper_only]]·[[harness-domain-rules-12-260701]]). 그래서 `has_plate_size` 관계를
  걸지 않는다(정직 표기·환각 방지·131 동형).

## 가격 경로 (D-18 경계 — 값은 evaluate_price 권위)
- `product-141 --priced_by--> formula-PRF_POSTER_SHEETCUT_HOLO --has_component--> component-COMP_POSTER_SHEETCUT_HOLO`.
  **가격 경로 연결됨(고아 공식·미배선 아님)** — 공식이 완제품가 구성요소 1건을 배선한다(formula_components
  실측 1행·전사표).
- ★**고정가형(fixed-price·siz_cd 룩업)** = 원자합산형(디지털 인쇄+용지+공정 합산)·면적매트릭스형(포스터
  가로×세로 셀)·고정룩업형(스티커 siz_cd)과 대비되는 실사 아키타입. 단일 구성요소
  `COMP_POSTER_SHEETCUT_HOLO`를 use_dims **1축(규격 siz_cd)**으로 조회한다. 단가표=**규격 3셀(A4·A3·A2) ×
  수량밴드 0 = 3행 완전격자**(grid_full=True·전사표). ★131(use_dims=[siz_cd,min_qty])보다 얕은 단일축이라
  수량구간 할인 자체가 차원에 없다. 면적(가로×세로) 셀이 아니라 **등록 규격(siz_cd) 키** 룩업이라 off-grid
  ceiling·비대칭 개념이 없다(nonspec_yn=N).
- ★공식/구성요소는 **141 전용 신규**(실사 고정가형 시트커팅) — [[product-141-hologram-sheet-cutting-nodes]]에
  mint. 실사 고정가 15상품(129/130/131/140/141/142/… pack §3.10) 공유 축 승격 후보(→ needed_shared_nodes).
- 값(unit_price)은 기록하지 않는다(연결·격자완전성·차원까지·값=evaluate_price·
  [[rule/rules#RULE_price_value_boundary]]).

## 옵션·제약·추가상품
- **옵션그룹:** `t_prd_product_option_groups` = 141 행 **없음**(CPQ 옵션 0). 손님 선택축은 규격뿐이며
  소재/코팅 선택 옵션이 없다. 실사 CPQ는 일반현수막138 파일럿만 적재된 상태라(pack §1.1·§3.9) 141 옵션
  0행은 실사 공통(BATCH-6 대기·설계상 해당 없음).
- **제약규칙:** `t_prd_product_constraints` = 141에 **0행**. ★118·122 등 면적매트릭스 형제는 nonspec
  치수범위 제약(RULE_001) 1행을 갖지만, 141은 **nonspec_yn=N**(사용자입력 치수 없음)이라 검증할 범위가
  없어 제약 0행이 **정당**하다(defect 아님). pack §1.1의 constraints 신규 발현 7상품(118/120/121/122/124/
  125/139)에 141이 **포함되지 않는 것**과 정합(nonspec 상품만 범위 제약 보유·T-3 회피).
- **추가상품:** `t_prd_product_addons`·`t_prd_product_sets` = 141 행 **없음**. ★141은 pack §3.12의 부속붙는
  8상품(133/134/135/136/137·액자 131/132)에 **미해당** — 통가격 단일 상품이라 addon/set 0행이 정당(부속
  미연결 잔존 결함 대상 아님).

## 승계·freshness 메모
- 정체·고정가형 분기(면적매트릭스 아님)는 pack §3.10·§5.2(FRESH·INHERIT) + mapping.md §1.1 승계·재검증.
- ★위키 🔴 결함 재조준(pack §4·T-6 오염 회피): 카테고리 고아(SL-DEF-001)는 **라이브 COMMIT으로 이미
  해소** — 141은 정상 시트커팅/스티커 연결. constraints는 141이 nonspec_yn=N이라 애초에 해당 없음(0행 정당).
  부속 addon(SL-DEF-005)은 141이 부속 8상품 미해당이라 무관. round-13/위키를 그대로 옮기면 오염이라
  live-snapshot 20260702_1119 실측으로 재판정(현재값=정답 or GAP).
- ★화이트 underbase(pack §3.3): 홀로그램은 도메인상 백색 받침이 필요하나 라이브 공정 0행 — "연결 여부 live
  재측정" 결과를 **부재(GAP)**로 정직 선언(투명 소재 122만 PROC_000008 확증됨). 지어내지 않음.
- 좌표 회귀·round-2 sparse 대표셀(T-4·T-5)·"29 실사 전부 면적매트릭스 일괄"(T-5)은 인용 안 함 — 141은
  명시 고정가 3셀 완전격자(전사표)만 승계(mapping.md §1.1 고정가 분류·실사 inline price R/S/V 비권위).
- 라이브 현재값 = live-snapshot 20260702_1119. 실사 시트는 260702 diff 무영향(pack §5.5)이라 권위 충돌
  미발견(현재값=정답 판정·양면 노드 없음). 고정가 완제품가 산정 근거는 엑셀 미기재 암묵지 GAP
  ([[product-141-hologram-sheet-cutting-nodes#gap-141-price-basis]]).
