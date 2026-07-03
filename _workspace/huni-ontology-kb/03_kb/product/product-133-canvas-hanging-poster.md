---
id: product-133-canvas-hanging-poster
type: product
anchor: t_prd_products/PRD_000133
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000133 (캔버스 행잉포스터·prd_typ_cd=PRD_TYPE.01·nonspec_yn=N·file_upload_yn=Y·editor_yn=Y·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "§0 특성1~4·§3.1 정체(에디터 상품 3종=132/133/134)·§3.2 사이즈·§3.5 자재·§3.6 봉제·§3.8 판형없음·§3.10 고정가형 15상품(캔버스행잉133)·§3.12 부속붙는 8상품(133→우드행거014)", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-silsa}
  - {source_file: "_workspace/huni-dbmap/02_mapping/silsa-poster-area-matrix/mapping.md", source_locator: "문서:§1.1 면적 13/고정 16 분류(캔버스행잉133=고정가형·수량×규격 블록) (승계·재검증 2026-07-03 — live PRF_POSTER_CANVAS_HANGING/2구성요소 실측으로 갱신)", captured_at: "2026-07-03", badge: verified, src_id: SR-13-silsa-mapping}
  - {source_file: "live-snapshot/latest/t_prd_product_price_formulas.csv", source_locator: "테이블:t_prd_product_price_formulas 키:(PRD_000133,PRF_POSTER_CANVAS_HANGING) 완제품가(규격 단가)+우드행거 추가가격", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
relations:
  - {rel: in_category, target: category-CAT_000004, note: "포스터(cat_lvl 1·root)·★133 main_cat_yn=Y(주 분류·live 실측)"}
  - {rel: in_category, target: category-CAT_000080, note: "보드액자(cat_lvl 2·main=N·상위 CAT_000004·133 보조 분류)"}
  - {rel: has_size, target: size-SIZ_000172, note: "A4(210x297)·이산 규격·dflt·master 실재(del_yn=N)"}
  - {rel: has_size, target: size-SIZ_000174, note: "A3(297x420)·이산 규격·dflt·master 실재(del_yn=N)"}
  - {rel: has_size, target: size-SIZ_000197, note: "A2(420x594)·이산 규격·dflt·master 실재(del_yn=N)"}
  - {rel: uses_material, target: material-MAT_000185, note: "캔버스(옥스포드)·MAT_TYPE.05 특수소재(06-14 .08→.05 교정)·USAGE.07·본체 단일(125와 동일 자재)"}
  - {rel: has_process, target: process-PROC_000080, note: "봉제(mand_proc_yn=N이나 가공 옵션그룹 OPT_000011 mand=Y로 필수화·패브릭 완성형태)"}
  - {rel: priced_by, target: formula-PRF_POSTER_CANVAS_HANGING, note: "고정가형([규격×수량] 단가·완제품가 COMP_POSTER_CANVAS_HANGING + 우드행거 추가가격 COMP_POSTEROPT_CANVAS_HANGING_WOODHANGER)"}
  - {rel: has_option_group, target: optgroup-133-gagong, note: "가공(봉제) OPT_000011·★택1 필수(min1/max1·mand=Y)·오버로크→PROC_000080"}
  - {rel: has_option_group, target: optgroup-133-chuga, note: "추가(우드행거) OPT_000012·택0/1(min0/max1·mand=N)·출력만(dflt)/우드행거+면끈"}
props:
  prd_typ_cd: PRD_TYPE.01
  semi_role_cd: null
  nonspec_yn: N
  file_upload_yn: Y
  editor_yn: Y
  min_qty: 1
  max_qty: 10000
  qty_incr: 1
  qty_unit_typ_cd: QTY_UNIT.01
  use_yn: Y
  del_yn: N
  구분: "실사(silsa·카테고리 004 포스터/080 보드액자·대형 실사 출력물·완제품 단일·부속붙는 8상품)"
  price_archetype: "고정가형(포스터사인 [규격(siz_cd)×수량(min_qty)] 단가·면적매트릭스 아님·off-grid 없음·이산 규격 3종만)"
  editor_note: "에디터 상품 3종(132/133/134) 중 하나(editor_yn=Y·file_upload_yn=Y 병행·pack §3.1)"
  status_note: "출시(use_yn=Y). 수치 raw는 companion 전사표 권위(스크립트 전사·손전사 금지)"
standards: {schema_org: Product, xjdf: "Product(포스터/사인·LayoutIntent FinishedDimensions)", config_ont: "component type"}
answers_cq: ["구체 상품 질의(캔버스 행잉포스터 구성·규격 가격)", "조건 탐색(캔버스 포스터·행잉·우드행거)", "옵션 조합(봉제 가공·우드행거 추가)"]
tags: ["#실사", "#포스터", "#캔버스", "#행잉포스터", "#고정가형", "#비종이류판형없음", "#봉제가공", "#부속우드행거", "#에디터상품", "#출시"]
updated: 2026-07-03
---

# product-133 캔버스 행잉포스터 (PRD_000133)

캔버스 행잉포스터는 **실사(silsa)** 상품군의 **완제품 단일**(`prd_typ_cd=PRD_TYPE.01`)이다.
캔버스(옥스포드) 원단에 **실사 대형 잉크젯**으로 풀컬러 출력한 뒤 **봉제(오버로크)** 마감하고, 선택적으로
**우드행거+면끈**을 달아 벽에 거는(hanging) 대형 포스터다. 카테고리 = 포스터(`CAT_000004`·root·★main)
+ 보드액자(`CAT_000080`·lvl2·보조). **에디터 상품**(`editor_yn=Y`) + 파일 업로드(`file_upload_yn=Y`)
병행(실사 에디터 3종 132/133/134 중 하나·pack §3.1). ★**고정 규격 상품**(`nonspec_yn=N`) — 자유입력
치수가 없고 이산 규격 A4/A3/A2 3종만. 수치(치수·규격 단가행)는 [[product-133-canvas-hanging-poster-nodes]]
전사표가 권위(스크립트 전사·손전사 금지).

★**실사 가격 = 고정가형 완제품가**(pack §0 특성2·§3.10). 캔버스행잉133은 **면적매트릭스형(118~128)이
아니라 고정가형 15상품**(129~137·140~145) 계열이다 — [규격(siz_cd)×수량(min_qty)] 블록 단가를 룩업한다
(면적매트릭스의 `siz_width×siz_height` 셀 아님·off-grid ceiling 없음). "29 전부 면적매트릭스" 일괄 모델은
round-2 오모델(pack §3.10·T-5)이며 133은 명시적으로 고정가형이다. 아래 "가격 경로" 절 참조.

## 정체·유형 (SOT 준수)
- 상품유형 분류 SOT: **완제품(.01)** = 일반 단일 제조상품. 캔버스행잉포스터는 `t_prd_product_sets`
  부모/구성원 등록이 없어(셋트 아님·전사표 0행) 일반 단일 완제품(SOT 정합). 기성/디자인 아님.
- ★**실사 = 소재가 상품을 가른다**(pack §0 특성1). 133은 **패브릭(캔버스)** 계열이며 인쇄방식은 실사
  대형 잉크젯 `PROC_000006` 단일(아크릴스티커 142/143만 UV 예외로 133 무관).
- ★**부속붙는 8상품**(pack §0 특성4·§3.12): 133 = "단품(캔버스 출력+봉제) + 부속(우드행거)" 정체.
  단 부속은 현재 `t_prd_product_addons`(0행)가 아니라 **CPQ 옵션(OPT_000012 추가)+단가행**으로 표현
  (아래 옵션·GAP 절·[[gap-133-woodhanger-addon-reconnect]]).
- 카테고리 재연결 확인(pack §1.1·T-1): round-13 "실사 28상품 전부 `CAT_000298` 고아"는 STALE —
  CAT_000298은 논리삭제(del_yn=Y)되고 133은 정상 노드 `CAT_000004`(포스터·★main)·`CAT_000080`
  (보드액자)에 재연결됨(live 실측). round-13 고아 서술 인용 금지.

## 차원
- **사이즈:** 활성 3행 — A4(`SIZ_000172`)·A3(`SIZ_000174`)·A2(`SIZ_000197`). ★**`nonspec_yn=N`이라
  자유입력 치수가 없다** — 125(nonspec=Y)와 달리 이산 규격 3종만. 3 마스터 모두 `del_yn=N`(양면 없음).
  판걸이수(UP수)는 종이류 파생값이라 실사에 무의미(§판형 절).
- **도수:** ★실사는 **도수(칼라/흑백) 컬럼 자체가 없다**(대형 잉크젯 풀컬러·정당·pack §3.3). 133
  `t_prd_product_print_options` = **0행**(has_print_option 없음). 색상코드로 오모델 금지
  ([[rule/rules#RULE_dosu_is_printopt]]·T-4). 화이트 underbase(PROC_000008)는 투명/반사 소재 몫
  (접착투명122·홀로141)이라 캔버스133에 없음.
- **수량규칙:** ★고정가형이라 수량축이 원리상 존재하나(pack §3.4 [수량×규격] 블록), 133 라이브는
  `t_prd_product_bundle_qtys` = **0행**(has_qty_rule 없음)이고 완제품 단가행도 `min_qty=1` 단일 tier만
  적재됨(전사표) — 수량 구간(t_dsc_*)·수량별 단가 미적재(전사표·[[gap-133-usedims-cellkey-mismatch]]에
  수량 tier 부재 부수 기록). 제품 레벨 수량 규칙(min/max/incr 1/10000/1·QTY_UNIT.01)은 전사표 참조.

## 자재·공정
- **자재:** 본체 단일 — 캔버스(옥스포드) `MAT_000185`. **`MAT_TYPE.05 특수소재`**(★06-14 `.08 실사소재`→
  `.05`로 교정됨·live note 실측). parent 없음(자체 부모)·usage `USAGE.07 공통`·dflt. 낱장 완제품
  (내지/표지 없음·pack §3.5). 125(캔버스패브릭포스터)와 **동일 자재 MAT_000185 공유**. ★round-13 목표
  라벨 "원단"(구 .05 지칭)은 MAT_TYPE 코드 개편으로 STALE(현재 `.05=특수소재`·pack §3.5·T-2) — 온톨로지는
  현재값 `.05 특수소재` 채택(교정 완료·자재유형 양면 아님). ★[HARD] IMPORT 시트 등록 자재 삭제 금지
  ([[rule/rules#RULE_import_material_no_delete]]). ※레더(.08→.06/.05) 이슈는 레더 소재(126/132) 몫이라
  캔버스133 무관(pack §1.1·T-2).
- **공정:** 활성 1행 — **봉제 `PROC_000080`**(제품행 `mand_proc_yn=N`·상위 없음·disp 1). ★단 **가공
  옵션그룹 OPT_000011이 mand=Y(min1/max1 필수)**라 실질적으로 봉제(오버로크)가 필수 선택(125는 가공
  옵션 min0/max1 선택적이었던 것과 차이). 패브릭은 소재가 완성형태라 봉제가 후가공(pack §3.6).
  `PROC_000080.prcs_dtl_opt` = 유형(오버로크/말아박기/봉미싱 등)·폭(mm) param(전사표). 인쇄방식 공정
  (PROC_000006) 행은 실사 전반 라이브 부재(po=0·정당).

## 판형 (plate size) — ★실사는 없음(비종이류·pack §3.8·T-7)
- ★**[HARD 도메인] 실사 = 대형 롤 출력이라 판형(plate_size)이 무의미**하다. 133 `t_prd_product_plate_sizes`
  = 3행이나 **전부 `del_yn=Y` 논리삭제**(output_paper_typ_cd 빈값·JPG 파일사양·전사표). 활성 판형 0 →
  **has_plate_size 엣지 없음**(정합). 종이류의 판형(`fn_best_plate`)·판걸이수(`fn_calc_pansu`·`t_siz_pansu`)는
  종이류 전용 로직이라 실사에 **이식 금지**([[rule/rules#RULE_plate_paper_only]]·HARNESS-DOMAIN-RULES).
  `output_file_typ`(JPG)만 유효.

## 가격 경로 (D-18 경계 — 값은 evaluate_price 권위) — ★가격 경로 연결됨(구성요소 2개)
- `product-133 --priced_by--> formula-PRF_POSTER_CANVAS_HANGING --has_component--> {COMP_POSTER_CANVAS_HANGING(disp1), COMP_POSTEROPT_CANVAS_HANGING_WOODHANGER(disp2)}`.
  **고아 공식 아님**(has_component 2개)·**끊긴 가격 사슬 아님**(priced_by 1개).
- ★**고정가형(면적매트릭스·원자합산과 다름):**
  - **① COMP_POSTER_CANVAS_HANGING**(완제품가·`prc_typ_cd=PRICE_TYPE.01`·`comp_typ_cd=PRC_COMPONENT_TYPE.06
    완제품비) = 소재+출력+봉제 포함 통가격을 **규격(siz_cd)×수량(min_qty)** 단가행으로 저장(A4/A3/A2 각 1행·
    min_qty=1·전사표 3셀). ★**[선언≠셀키 불일치] 이 구성요소는 use_dims를 면적템플릿
    `[siz_width, siz_height, min_qty]`로 선언했으나 실 단가행은 `siz_cd+min_qty` 키**(siz_width/siz_height
    컬럼 전부 빈값)다 — 고정가·이산 규격이라 정합상 `[siz_cd, min_qty]`여야 한다. 선언과 셀키의 불일치를
    양면(현재값 vs 정답)으로 표기(badge=defect·[[product-133-canvas-hanging-poster-nodes#component-COMP_POSTER_CANVAS_HANGING]]).
    evaluate_price 룩업 정합 판정은 엔진/검증 소관(값 날조 금지·D-18).
  - **② COMP_POSTEROPT_CANVAS_HANGING_WOODHANGER**(우드행거+면끈 추가가격·PRICE_TYPE.01·comp_typ .06) =
    부속 우드행거 가격을 **옵션(opt_cd=OPV_000429)×규격(siz_cd)** 단가행으로 저장(A4/A3/A2 각 1행·전사표
    3셀). use_dims=`[opt_cd, siz_cd, opt_grp:OPT_000012]` — 선언과 셀키(opt_cd+siz_cd) 정합. 우드행거를
    선택(OPV_000429)하면 가산(addtn_yn=Y).
- ★**신규 공식/구성요소(133-local):** PRF_POSTER_CANVAS_HANGING·COMP_POSTER_CANVAS_HANGING·
  COMP_POSTEROPT_CANVAS_HANGING_WOODHANGER은 133 전용(라이브 formula_components에서 다른 상품 미공유·실측).
  125의 면적공식 PRF_POSTER_CANVAS(4소재 동형결합)와 다른 별도 공식·companion에 상품-local mint
  (공유 파일 미수정·[[rule/rules]] 등 shared 무수정).
- ★**가격 경계(방법론):** 온톨로지는 **use_dims 차원 선언까지만** — 규격별 단가값·수량 tier 계산은
  evaluate_price/암묵지(KB 밖·[[rule/rules#RULE_price_value_boundary]]). 실사 시트 inline price(R/S/V)는
  가격 권위 아님[HARD](pack §0 특성2). ★고정가형이라 off-grid ceiling(면적매트릭스 로직)은 133에 무관.

## 옵션·제약·추가상품 (라이브 실측)
- **옵션그룹 1(가공·★택1 필수·mand=Y):** `OPT_000011` 가공(오버로크 봉제 필수·SEL_TYPE.01·min1/max1)
  → 옵션값 오버로크(`OPV_000029`·dflt) → `OPT_REF_DIM.04 ref_key1=PROC_000080`(공정 참조). 옵션=공정
  BUNDLE(pack §3.9). 부모 has_process(PROC_000080)에 실재 → `fn_chk_opt_item_ref` 정합(L-18 통과).
  하위=[[product-133-canvas-hanging-poster-nodes#optgroup-133-gagong]].
- **옵션그룹 2(추가·택0/1·mand=N):** `OPT_000012` 추가(우드행거 추가 선택·SEL_TYPE.01·min0/max1) → 옵션값
  출력만(`OPV_000030`·dflt)/우드행거+면끈(`OPV_000429`). ★이 두 옵션값은 `option_items` 행이 없다
  (ref_dim 없음) — 우드행거 가격은 공식 구성요소 COMP_POSTEROPT_CANVAS_HANGING_WOODHANGER의 (opt_cd,siz_cd)
  단가행으로 표현(옵션 선택→단가행 가산). 하위=[[product-133-canvas-hanging-poster-nodes#optgroup-133-chuga]].
- **제약규칙:** `t_prd_product_constraints` = 133 행 **없음**(0행·전사표). ★pack §1.1·§3.9 실사 constraints
  신규 발현 7상품(118/120/121/122/124/125/139)에 **133은 포함되지 않는다** — 위키 "constraints 0행"이
  133에는 오히려 정합(nonspec=N이라 치수범위 검증 불필요). T-3 STALE 함정은 발현 7상품에만 해당.
- **추가상품(addon):** `t_prd_product_addons` = 133 행 **없음**(0행). ★133은 부속붙는 8상품이나 우드행거
  (PRD_000014·기성 PRD_TYPE.03) addon 재연결이 미적재(pack §3.12 [잔존·미교정] SL-DEF-005) →
  [[gap-133-woodhanger-addon-reconnect]] GAP. 현재는 CPQ 옵션(OPT_000012)+단가행으로만 부속 표현.
- **셋트:** `t_prd_product_sets` = 133 부모/자식 행 **없음**(부품조립 셋트 아님·완제품 단일 SOT 정합).

## 승계·freshness 메모
- 정체·소재 13군·면적/고정 분기 = pack §3.1/§3.5/§3.10 FRESH + mapping.md(승계·재검증 2026-07-03·
  live PRF_POSTER_CANVAS_HANGING/2구성요소로 갱신). round-13 결함 상태값(T-6)·CAT_000298 고아(T-1)·
  레더/패브릭 .08(T-2)은 STALE 인용 금지.
- 고정가형·비종이류 판형없음·봉제 완성형태·에디터 상품 = pack §0 특성1~4·§3.1/§3.8 FRESH.
- 캔버스 MAT_TYPE .08→.05 교정·판형 3행 논리삭제·2구성요소(완제품가+우드행거)·가공 옵션 mand=Y·
  use_dims 선언≠셀키 불일치는 live-snapshot 20260702_1119 실측(round-13/위키에 없던 신사실).
- **부속 우드행거:** addon=0 잔존(pack §3.12 미교정)은 양면/GAP로 정직 지연([[gap-133-woodhanger-addon-reconnect]]).

---

> 상품 전용 하위 노드(공식·구성요소 2·옵션그룹 2·양면 defect·GAP 2)는
> [[product-133-canvas-hanging-poster-nodes]] companion에 신설(125 방식·공유 axis/*·formula/*·rule/* 미수정).
> 재사용 참조(중복 mint 금지·L-3): 포스터 root `category-CAT_000004`(119 owner)·보드액자
> `category-CAT_000080`(131 owner·129~134 공유)·A4/A3 사이즈 `size-SIZ_000172`/`SIZ_000174`(product-047
> owner)·A2 `size-SIZ_000197`(axis/sizes.md owner)·캔버스 `material-MAT_000185`·봉제 `process-PROC_000080`
> (125 owner). 이들은 needed_shared_nodes로 반환(실사 공유 축 승격 후보).
