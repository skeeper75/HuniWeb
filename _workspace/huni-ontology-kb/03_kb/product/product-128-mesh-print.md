---
id: product-128-mesh-print
type: product
anchor: t_prd_products/PRD_000128
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000128(prd_nm=메쉬프린트·prd_typ_cd=PRD_TYPE.01·nonspec_yn=Y·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-dbmap/02_mapping/silsa-poster-area-matrix/mapping.md", source_locator: "문서:§1.2 B11 메쉬프린트128↔면적매트릭스 13상품 (comp 지목은 라이브 배선으로 재판정·아래 가격 경로)", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-silsa}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "문서:§3.1·§3.5·§3.10 실사 정체·메쉬 자재 .08 잔존·면적매트릭스형(승계·재검증 2026-07-03)", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-silsa}
relations:
  - {rel: in_category, target: category-CAT_000076, note: "아트프린트(cat_lvl=2·upr=CAT_000004 포스터·main_cat_yn=N·126-nodes 정의 재사용)"}
  - {rel: has_size, target: size-SIZ_000174, note: "A3 규격 preset(del_yn=N)·off-grid ceiling(앱)"}
  - {rel: has_size, target: size-SIZ_000197, note: "A2 규격 preset(del_yn=N)"}
  - {rel: has_size, target: size-SIZ_000293, note: "A1 규격 preset(상품링크 활성·마스터 del_yn=Y 불일치·정직 관찰)"}
  - {rel: uses_material, target: material-MAT_000183, note: "메쉬(부모·USAGE.07·dflt_yn=Y·★MAT_TYPE.08 미교정)"}
  - {rel: has_qty_rule, target: qty-128, note: "제품레벨 min1/max10000/incr1(QTY_UNIT.01)"}
  - {rel: priced_by, target: formula-PRF_POSTER_MESH, note: "완제품가 면적매트릭스형(포스터사인 가로×세로 셀단가·동형결합 comp)"}
props:
  prd_typ_cd: PRD_TYPE.01
  semi_role_cd: null
  nonspec_yn: Y
  nonspec_range_ref: "전사표(transcribe_product_128.py) — 가로 200~600·세로 200~3000 raw 수치 손전사 아님"
  file_upload_yn: Y
  editor_yn: N
  min_qty_ref: "전사표(1)"
  max_qty_ref: "전사표(10000)"
  qty_incr_ref: "전사표(1)"
  qty_unit_typ_cd: QTY_UNIT.01
  use_yn: Y
  del_yn: N
  archetype: "면적매트릭스형(area-matrix·use_dims=[siz_width,siz_height,min_qty])"
standards: {schema_org: Product, xjdf: "Product(포스터/Poster·LayoutIntent FinishedDimensions)", config_ont: "component type"}
answers_cq: ["구체 상품 질의(메쉬프린트 가격 경로)", "조건 탐색(실사 메쉬 소재·규격)"]
tags: ["#실사", "#포스터", "#메쉬프린트", "#면적매트릭스", "#비종이류"]
updated: 2026-07-03
---

# product-128 메쉬프린트 (PRD_000128)

메쉬프린트는 **실사(대형 실사 출력물)** 카테고리의 **완제품 단일**(`prd_typ_cd=PRD_TYPE.01`)
상품이다. 손님이 **규격(A3/A2/A1) 또는 사용자입력 치수**와 **메쉬 소재**를 고르면, 포스터사인
**[가로×세로] 면적매트릭스**에서 **완제품 통가격**을 조회한다. 파일 업로드 방식
(`file_upload_yn=Y`, 에디터 미사용). 수치(치수·비규격 범위·매트릭스 SHAPE)는
[[product-128-mesh-print-nodes]] 전사표가 권위(스크립트 전사·손전사 금지·D-9).

★**형제 상품 126 레더아트프린트와 동형**(같은 카테고리 CAT_000076·같은 규격 preset
174/197/293·같은 [동형결합] 면적 구성요소를 자기 공식으로 배선)이나, **자재 유형(메쉬
MAT_000183은 아직 `.08` 미교정)** 과 **미보유 축(공정·CPQ·제약 전부 0행)** 이 다르다.

## 정체·유형 (SOT 준수)
- 상품유형 분류 SOT: **완제품(.01)** = 일반 단일 제조상품. 메쉬프린트는 `t_prd_product_sets`
  부모 등록이 없어(라이브 실측 — sets 0행) 셋트 완제품이 아니라 **일반 단일 완제품**(SOT 정합·
  [[rule/rules#RULE_scope_boundary]] 범위 안).
- 상품군 = **실사**(카테고리 004 포스터 하위 아트프린트). 굿즈/포장재 아님(정체 오분류 위험 없음).
- 카테고리: 아트프린트 `CAT_000076`(cat_lvl=2·upr=CAT_000004 포스터·main_cat_yn=N). ★공유 노드
  **재사용**(126-nodes가 canonical 정의·중복 mint 금지·L-3) — 128은 in_category로 참조만.
- ★[REVERIFY→해소] round-13 "실사 28상품 전부 CAT_000298 고아"는 **STALE** — `CAT_000298`은
  `del_yn=Y` 논리삭제(06-18)됐고 128은 정상 카테고리 노드로 재연결됨(pack §1.1·§4 T-1). 현재
  상태=정상연결(defect 아님·양면 불요).

## 차원
- **사이즈:** 규격 3행(A3 `SIZ_000174` / A2 `SIZ_000197` / A1 `SIZ_000293`·상품링크 전부 del_yn=N)
  **+ 비규격 연속범위**(nonspec_yn=Y·가로 200~600mm·세로 200~3000mm·전사표). ★**비규격 범위는
  입력 UX 한계일 뿐 가격격자가 아니다**(pack §3.2) — 유효 가격 권위 = 면적매트릭스 셀(§가격 경로).
  ★128은 118과 달리 **재키잉 전 구 코드(174/197/293)를 그대로 활성**으로 쓴다(118은 07-01
  315/198/294로 재키잉·128은 미재키잉·[[product-128-mesh-print-nodes]] 전사표). A1(SIZ_000293)은
  **상품링크 활성(del_yn=N)이나 사이즈 마스터 del_yn=Y**(2026-06-17 논리삭제) 불일치를 정직 표기
  (단정 아님·126 동형).
- **★가로 범위 캡(600) vs 매트릭스 가로축(600~1200):** 메쉬 nonspec 가로 상한=600·규격 최대
  A1 가로=594(→ceiling 600). 반면 [동형결합] 면적 구성요소 격자의 가로축은 600/800/1000/1200
  4구간이다(캔버스/레더/타이벡은 더 넓은 nonspec을 써서 800~1200 열을 씀). 즉 **메쉬는 공유 격자의
  600 가로열만 도달**한다 — 800~1200 열은 메쉬 주문 경로로 닿지 않음(정직 관찰·격자 자체는 4소재
  공유·[[product-128-mesh-print-nodes]]).
- **도수(인쇄옵션):** 라이브 `t_prd_product_print_options` = 128 행 **없음**. 실사는 **대형 잉크젯
  풀컬러**라 도수(칼라/흑백) 컬럼 자체가 없다 — 결함이 아니라 **설계상 해당 없음**(pack §3.3·
  [[rule/rules#RULE_dosu_is_printopt]] 프레임 밖).
- **수량규칙:** 제품 레벨 수량규칙(전사표 min1/max10000/incr1·QTY_UNIT.01). `t_prd_product_bundle_qtys`에
  128 행 **없음**(제품 레벨 규칙만). ★면적매트릭스형이라 **수량축이 가격 차원이 아니다** — 셀 단가는
  포스터 통가격이며 수량구간 할인 없음. 수량 UI 권위=제품 수량규칙(가격구간과 역할 분리·pack §3.4·
  [[rule/decisions#DEC_qty_audit_260702]]).

## 자재·공정
- **자재:** **메쉬 단일 소재계열**(낱장 완제품·내지/표지 없음·pack §3.5). 부모 `MAT_000183`
  (USAGE.07 단일 슬롯·dflt_yn=Y). ★**자재유형 `MAT_TYPE.08` 미교정 잔존** — 형제 126 레더
  (MAT_000186·06-27 `.05`로 교정됨)와 달리 메쉬는 **아직 `.08`**(pack §1.1·§3.5 SL-DEF-002 "부분
  해소"의 잔존 3소재 중 하나=그래픽천/현수막천/**메쉬**). ★DB note의 "정정 …→원단(.05)" 목표
  라벨은 **STALE**(MAT_TYPE 코드 개편으로 현재 `.05`=특수소재·`.06`=도장부자재·T-2 인접). **정정
  목표유형이 어느 코드인지 미확정**(GAP) → [[gap-128-mesh-mattype-correction]]. 현재값 `.08`은
  live 실측 사실이나 "정답 유형"은 원천 부재(양면 아님·GAP). ★IMPORT 등록 자재 삭제 금지
  ([[rule/rules#RULE_import_material_no_delete]]).
- **공정:** `t_prd_product_processes` = 128 행 **없음**(0행). ★128은 형제 126과 달리 **코팅 공정
  링크가 아예 없다**(126은 07-01 코팅 재키잉 후에도 0공정이었으나 128도 동일 0공정). 실사 대형
  잉크젯 인쇄방식 공정(PROC_000006)도 라이브에 128 행 없음(실사 공통·po=0·설계상 정당·pack §3.7).
  가공(있다면)은 면적매트릭스 통가격에 녹아 있고 별도 공정 원자합산이 아니다(pack §3.10).

## 판형 (★비종이류 — 해당 없음)
- 라이브 `t_prd_product_plate_sizes` = 128에 3행(SIZ_000052/198/294) 있으나 **전부 del_yn=Y**
  (2026-06-30 정리)이고 `output_paper_typ_cd`가 공란, 용도가 "파일사양"(output_file_typ=JPG)이다 —
  판걸이수 산정용 출력용지 판형이 아니라 **파일 규격 플레이스홀더**(전사표). ★실사는 **대형 롤
  출력**이라 절수 기반 전지 규격이 무의미(낱장 임포지션 없음) → 판형(`fn_best_plate`)·판걸이수
  (`fn_calc_pansu`·t_siz_pansu)는 **종이류 전용 로직이므로 실사에 적용 금지**(pack §3.8·T-7·
  [[rule/rules#RULE_plate_paper_only]]·[[harness-domain-rules-12-260701]]). 그래서 `has_plate_size`
  관계를 걸지 않는다(정직 표기·환각 방지·126/050 선례 동형).

## 가격 경로 (D-18 경계 — 값은 evaluate_price 권위)
- `product-128 --priced_by--> formula-PRF_POSTER_MESH --has_component--> component-COMP_POSTER_CANVAS_FABRIC`.
  **가격 경로 연결됨(고아 공식·미배선 아님)** — 공식이 완제품가 구성요소 1건을 배선한다(라이브
  formula_components 실측).
- ★**동형결합 구성요소 재사용:** 라이브 배선은 128 전용 `COMP_POSTER_MESH_PRINT`가 아니라 **4소재
  통합 [동형결합] `COMP_POSTER_CANVAS_FABRIC`**(캔버스패브릭·레더·**메쉬**·타이벡·use_yn=Y·
  use_dims=`[siz_width,siz_height,min_qty]`)을 가리킨다. 이 구성요소는 **125 캔버스가 canonical
  소유**([[product-125-canvas-fabric-poster-nodes#component-COMP_POSTER_CANVAS_FABRIC]]) — 128은
  재정의 없이 재사용(중복 mint 금지·L-3·126 선례). 128 공식 `PRF_POSTER_MESH`는 128 바인딩 전용.
- ★**mapping.md §1.2 vs 라이브 배선(문서-라이브 진화):** mapping.md §1.2 B11은 128 comp를
  `COMP_POSTER_MESH_PRINT`(52셀·19000~126000)로 지목하나, 이는 **현재 use_yn=N 은퇴한 레거시
  구성요소**다(전사표). 라이브 실 배선은 병합된 `COMP_POSTER_CANVAS_FABRIC`으로 이관됨 — 권위
  순서(라이브 현재 배선 + 구성요소 마스터)상 **라이브 배선이 정답**(126 레더 동형·구 per-material
  comp 은퇴). 값 자체는 두 comp 모두 52셀 동일 격자라 견적 영향 없음(전사표 집계).
- **면적매트릭스형** = 원자합산형(디지털 인쇄+용지+공정 합산)·고정룩업형(스티커 siz_cd 룩업)과
  **다른 아키타입**. 단일 구성요소를 use_dims 3축(**가로 siz_width × 세로 siz_height × 수량 min_qty**)
  으로 조회한다. 격자=가로 4구간 × 세로 13구간 = 52셀(전사표). off-grid=가로·세로 각 한 단계 큰
  규격 ceiling(앱 계산·DB는 룩업행·pack §3.10). ★단 메쉬는 nonspec 가로 캡(600)으로 격자의
  600 가로열만 도달(§차원).
- 값(unit_price)은 노드에 기록하지 않는다(연결·격자·차원까지·값=evaluate_price·
  [[rule/rules#RULE_price_value_boundary]]). ★셀단가 산정 로직(롤 소재→셀단가)은 엑셀 미기재
  암묵지(실사 전체 공통 GAP·[[gap-126-roll-material-pricing]] 참조·중복 노드 미생성). min_qty
  차원 선언 vs 격자 공란 미확정도 공유 comp 이슈([[gap-126-minqty-axis]] 참조).

## 옵션·제약·추가상품 (★전부 0행)
- **옵션그룹:** `t_prd_product_option_groups` = 128 행 **없음**(0행). 손님 선택 CPQ 축 미적재 —
  소재/규격은 상품 차원(has_size·uses_material)으로 직접 노출·코팅 옵션 없음(공정 0행과 정합).
  27 실사 옵션 미적재 잔존(일반현수막138만 옵션 레이어 실재·pack §3.9·§4 SL-DEF-006·BATCH-6 대기).
- **제약규칙:** `t_prd_product_constraints` = 128 행 **없음**(0행). ★[REVERIFY] 위키 "실사 constraints
  전부 0행"은 7상품(118/120/121/122/124/125/139)에서 STALE이지만 **128은 그 7상품에 미포함** — 128은
  실제로 0행(pack §1.1·T-3 목록 대조). 비규격 입력 치수 범위 검증 제약(118/122 등이 보유한 RULE_001
  유형)이 128엔 아직 미적재(GAP 성격이나 실사 공통 미적재 잔존으로 gaps.md 색인 몫).
- **추가상품:** `t_prd_product_addons`·`t_prd_product_sets` = 128 행 **없음**. 128은 부속붙는 상품이
  아니다(부속 8상품=133~137·131/132·138/139·pack §3.12). addon 미연결이 결함 아님(설계상 해당 없음).

## 승계·freshness 메모
- 정체·소재계열·면적매트릭스 분기는 pack §3.1·§3.5·§3.10·§3.11(FRESH·INHERIT) + mapping.md §1.2
  승계·재검증(comp 지목만 라이브 배선으로 재판정).
- ★위키 🔴 결함 재조준(pack §4·T-6 오염 회피): 카테고리 고아(SL-DEF-001)는 **라이브 COMMIT으로
  이미 해소**(128 정상 카테고리 연결). 자재유형(SL-DEF-002)은 **메쉬 잔존 미교정**(.08·목표유형
  GAP). round-13/위키를 그대로 옮기면 오염이라 live-snapshot 20260702_1119 실측으로 재판정.
- 좌표 회귀·round-2 sparse 대표셀(T-4·T-5) 인용 안 함 — 명시 매트릭스 52셀 격자만 승계(mapping.md §2).
- 라이브 현재값 = live-snapshot 20260702_1119. 실사 시트는 260702 diff 무영향(pack §5)이라 권위 충돌
  미발견(카테고리·규격·배선은 현재값=정답). ★단 메쉬 자재유형 `.08`은 "현재값 확정·정답 미확정"의
  GAP(양면 아님)이라 유일한 열린 상태([[gap-128-mesh-mattype-correction]]).
