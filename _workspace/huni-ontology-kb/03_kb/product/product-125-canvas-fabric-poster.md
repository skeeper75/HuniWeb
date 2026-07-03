---
id: product-125-canvas-fabric-poster
type: product
anchor: t_prd_products/PRD_000125
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000125 (캔버스패브릭포스터·prd_typ_cd=PRD_TYPE.01·nonspec_yn=Y·use_yn=Y·del_yn=N·file_upload_yn=Y·editor_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "§0 특성1~4·§3.1 정체·§3.2 사이즈·§3.5 자재·§3.6 봉제·§3.8 판형없음·§3.10 면적매트릭스 13(B08 캔버스125)·§3.11 comp/셀", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-silsa}
  - {source_file: "_workspace/huni-dbmap/02_mapping/silsa-poster-area-matrix/mapping.md", source_locator: "문서:§1.1 면적 13/고정 16 분류·§1.2 B08 캔버스125↔comp_cd (승계·재검증 2026-07-03 — live comp=COMP_POSTER_CANVAS_FABRIC 동형결합으로 갱신)", captured_at: "2026-07-03", badge: verified, src_id: SR-13-silsa-mapping}
  - {source_file: "live-snapshot/latest/t_prd_product_price_formulas.csv", source_locator: "테이블:t_prd_product_price_formulas 키:(PRD_000125,PRF_POSTER_CANVAS) 캔버스패브릭포스터 완제품가(면적/규격 단가)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
relations:
  - {rel: in_category, target: category-CAT_000004, note: "포스터(cat_lvl 1·main_cat_yn=N·root)"}
  - {rel: in_category, target: category-CAT_000072, note: "패브릭포스터(cat_lvl 2·main_cat_yn=Y·disp 2·상위 CAT_000004)=main 분류"}
  - {rel: has_size, target: size-SIZ_000174, note: "A3(297x420)·이산 규격·dflt·master 실재"}
  - {rel: has_size, target: size-SIZ_000197, note: "A2(420x594)·이산 규격·master 실재"}
  - {rel: has_size, target: size-SIZ_000293, note: "A1(594x841)·★junction 활성(del_yn=N)이나 master t_siz_sizes del_yn=Y(양면 defect·정리 워크리스트)"}
  - {rel: uses_material, target: material-MAT_000185, note: "캔버스(옥스포드)·MAT_TYPE.05 특수소재(06-14 .08→.05 교정됨)·USAGE.07·dflt·본체 단일"}
  - {rel: has_process, target: process-PROC_000080, note: "봉제(opt·mand_proc_yn=N·패브릭 완성형태·prcs_dtl_opt=유형/폭 param)·가공 CPQ가 이 공정 참조"}
  - {rel: priced_by, target: formula-PRF_POSTER_CANVAS, note: "완제품가 면적매트릭스형(COMP_POSTER_CANVAS_FABRIC·[siz_width×siz_height]×min_qty 셀단가·통가격)"}
  - {rel: has_option_group, target: optgroup-125-gagong, note: "가공(봉제) 택1 선택(min0/max1·mand=N)·오버로크→PROC_000080"}
props:
  prd_typ_cd: PRD_TYPE.01
  semi_role_cd: null
  nonspec_yn: Y
  nonspec_range_ref: "전사표(가로 200~1200·세로 200~3000mm·incr 200) — [[product-125-canvas-fabric-poster-nodes]]"
  file_upload_yn: Y
  editor_yn: N
  min_qty: 1
  max_qty: 10000
  qty_incr: 1
  qty_unit_typ_cd: QTY_UNIT.01
  use_yn: Y
  del_yn: N
  구분: "실사(silsa·카테고리 004 포스터/072 패브릭포스터·대형 실사 출력물·완제품 단일)"
  price_archetype: "면적매트릭스형(포스터사인 [가로×세로] 셀단가·off-grid=한 단계 큰 규격 ceiling·원자합산 아님·고정룩업 아님)"
  status_note: "출시(use_yn=Y). 수치 raw는 companion 전사표 권위(스크립트 전사·손전사 금지)"
standards: {schema_org: Product, xjdf: "Product(포스터/사인·LayoutIntent FinishedDimensions)", config_ont: "component type"}
answers_cq: ["구체 상품 질의(캔버스패브릭포스터 구성·면적 가격)", "조건 탐색(패브릭 포스터·봉제 가공)", "옵션 조합(가공 선택)"]
tags: ["#실사", "#포스터", "#패브릭", "#면적매트릭스", "#비종이류판형없음", "#봉제가공", "#출시"]
updated: 2026-07-03
---

# product-125 캔버스패브릭포스터 (PRD_000125)

캔버스패브릭포스터는 **실사(silsa)** 상품군의 **완제품 단일**(`prd_typ_cd=PRD_TYPE.01`)이다.
캔버스(옥스포드) 원단에 **실사 대형 잉크젯**으로 풀컬러 출력하는 대형 패브릭 포스터다. 카테고리 =
포스터(`CAT_000004`·root)·패브릭포스터(`CAT_000072`·main·leaf). 파일 업로드 방식
(`file_upload_yn=Y`, 에디터 미사용). 사용자입력(nonspec) 치수 상품(가로/세로 자유입력·범위는
전사표) + 이산 규격(A3/A2/A1). 수치(치수·nonspec 범위·면적 셀 행수) raw 값은
[[product-125-canvas-fabric-poster-nodes]] 전사표가 권위(스크립트 전사·손전사 금지).

★**실사 가격 = 면적매트릭스형 완제품가**(pack §0 특성2·§3.10). [가로(siz_width)×세로(siz_height)]
셀단가(출력+소재+가공 포함 통가격)를 룩업하고, 격자에 없는 크기(off-grid)는 가로·세로 각 **한 단계 큰
규격으로 ceiling**(앱 계산·DB는 룩업행). 원자합산형(디지털)·고정가룩업형(스티커)과 다른 아키타입.
아래 "가격 경로" 절 참조.

## 정체·유형 (SOT 준수)
- 상품유형 분류 SOT: **완제품(.01)** = 일반 단일 제조상품. 캔버스패브릭포스터는
  `t_prd_product_sets` 부모 등록이 없어(셋트 아님) 일반 단일 완제품(SOT 정합). 기성/디자인 아님.
- ★**실사 = 소재가 상품을 가른다**(pack §0 특성1). 실사는 13 소재군(종이/방수/투명/패브릭/…)이 상품
  정체를 결정하며 125는 **패브릭(캔버스)** 계열. 인쇄방식은 실사 대형 잉크젯 `PROC_000006` 단일
  (아크릴스티커 142/143만 UV 예외로 125 무관).
- 카테고리 재연결 확인(pack §1.1·T-1): round-13이 "실사 28상품 전부 `CAT_000298` 고아"라 했으나
  CAT_000298은 논리삭제(del_yn=Y)되고 125는 정상 노드 `CAT_000004`/`CAT_000072`에 재연결됨(live 실측).
  round-13 고아 서술은 STALE 인용 금지.

## 차원
- **사이즈:** 활성 3행 — A3(`SIZ_000174`)·A2(`SIZ_000197`)·A1(`SIZ_000293`). 이산 규격 SIZ(A계열)
  + **nonspec 연속범위**(가로/세로 자유입력·범위·incr는 전사표). ★**nonspec 범위는 입력 UX 한계일 뿐
  가격격자가 아니다**(pack §3.2) — 유효 가격 권위 = 면적 셀단가(아래 가격 경로). off-grid = 한 단계 큰
  규격 ceiling(앱). ★**A1(`SIZ_000293`)은 junction 활성(del_yn=N)인데 master `t_siz_sizes.SIZ_000293`
  가 논리삭제(del_yn=Y)** 된 불일치(활성 A1 마스터=SIZ_000294) → 공유 [[size-SIZ_000293]] 양면 defect
  노드(병렬 실사 형제 119 owner·125 재사용·current≠authority·정리 워크리스트).
  판걸이수(UP수)는 종이류 파생값이라 실사에 무의미(§판형 절).
- **도수:** ★실사는 **도수(칼라/흑백) 컬럼 자체가 없다**(대형 잉크젯 풀컬러·정당·pack §3.3). 125
  `t_prd_product_print_options` = **0행**(has_print_option 없음). 색상코드로 오모델 금지
  ([[rule/rules#RULE_dosu_is_printopt]]·T-4). 화이트 underbase(PROC_000008)는 투명/반사 소재 몫
  (접착투명122·홀로141)이라 캔버스125에 없음.
- **수량규칙:** ★**면적매트릭스형은 수량축이 얕다**(pack §3.4) — `t_prd_product_bundle_qtys` = **0행**
  (has_qty_rule 없음). 제품 레벨 수량 규칙(min/max/incr·QTY_UNIT.01)은 전사표 참조. 단 면적 구성요소
  use_dims에 `min_qty`가 포함되어 셀 격자의 수량 차원으로는 존재(가격 차원·전사표).

## 자재·공정
- **자재:** 본체 단일 — 캔버스(옥스포드) `MAT_000185`. **`MAT_TYPE.05 특수소재`**(★06-14 `.08 실사소재`→
  `.05`로 교정됨·live note 실측). parent 없음(자체 부모)·usage `USAGE.07 공통`·dflt. 낱장 완제품
  (내지/표지 없음·pack §3.5). ★round-13 목표 라벨 "원단"(구 .05 지칭)은 **MAT_TYPE 코드 개편으로 STALE**
  (현재 `.05=특수소재`·pack §3.5·T-2) — 온톨로지는 현재값 `.05 특수소재` 채택(교정 완료이므로
  자재유형은 양면 아님). ★[HARD] IMPORT 시트 등록 자재 삭제 금지([[rule/rules#RULE_import_material_no_delete]]).
- **공정:** 활성 1행 — **봉제 `PROC_000080`**(opt·mand_proc_yn=N·상위 없음·disp 1). 패브릭은 소재가
  완성형태라 봉제가 후가공(pack §3.6). `PROC_000080.prcs_dtl_opt` = 유형(오버로크/오버로크+리본끈/
  말아박기/말아박기+면끈/봉미싱)·폭(mm) param(전사표). ★가공 CPQ 옵션그룹이 이 공정을 참조(옵션=공정
  BUNDLE·아래 옵션 절). 인쇄방식 공정(PROC_000006) 행은 실사 전반 라이브 부재(po=0·정당).

## 판형 (plate size) — ★실사는 없음(비종이류·pack §3.8·T-7)
- ★**[HARD 도메인] 실사 = 대형 롤 출력이라 판형(plate_size)이 무의미**하다. 125 `t_prd_product_plate_sizes`
  = 3행이나 **전부 `del_yn=Y` 논리삭제**(2026-06-30·output_paper_typ_cd 빈값·JPG 파일사양·전사표). 활성
  판형 0 → **has_plate_size 엣지 없음**(정합). 종이류의 판형(`fn_best_plate`)·판걸이수(`fn_calc_pansu`·
  `t_siz_pansu`)는 종이류 전용 로직이라 실사에 **이식 금지**([[rule/rules#RULE_plate_paper_only]]·
  HARNESS-DOMAIN-RULES). `output_file_typ`(JPG)만 유효.

## 가격 경로 (D-18 경계 — 값은 evaluate_price 권위) — ★가격 경로 연결됨
- `product-125 --priced_by--> formula-PRF_POSTER_CANVAS --has_component--> component-COMP_POSTER_CANVAS_FABRIC`.
  **고아 공식 아님**(has_component 1개)·**끊긴 가격 사슬 아님**(priced_by 1개).
- ★**면적매트릭스형(원자합산·고정룩업과 다름):** COMP_POSTER_CANVAS_FABRIC(`prc_typ_cd=PRICE_TYPE.01`·
  `comp_typ_cd=PRC_COMPONENT_TYPE.06 완제품비`) **use_dims=`[siz_width, siz_height, min_qty]`** — 실사
  완제품가(출력+소재+가공 포함 통가격)를 (가로×세로) 면적 셀로 통째 저장. 125 셀 격자 행수요약=
  [[product-125-canvas-fabric-poster-nodes#가격구성요소-면적매트릭스]] 전사표(값 나열 아님·D-22 접기)·
  값 계산=evaluate_price 권위([[rule/rules#RULE_price_value_boundary]]). 매트릭스 비대칭((가로,세로)
  순서쌍 고유)·off-grid=한 단계 큰 규격 ceiling(앱).
- ★**[동형결합] 4소재 통합 구성요소:** COMP_POSTER_CANVAS_FABRIC는 이름과 달리 **가격표 동일 4소재
  (캔버스패브릭포스터·레더아트프린트·메쉬프린트·타이벡프린트)를 통합**한 완제품가다(live note 실측).
  즉 125·126(레더)·127(타이벡)·128(메쉬)이 같은 comp를 공유. round-2 "28상품 단일 comp 바인딩·
  매트릭스 2~6%만 적재" D-WIRE 오모델(pack §3.11·T-5)과 다른, **의도된 동형결합**(가격표가 4소재
  동일 단가)이다. 셀 전건 적재됨(52셀·전사표).
- ★**신규 공식/구성요소(실사 첫 상품):** PRF_POSTER_CANVAS·COMP_POSTER_CANVAS_FABRIC은 디지털/스티커
  공유 축(formula/·formula/sticker-components)에 없다. companion에 상품-local mint하고
  **needed_shared_nodes**로 반환(면적매트릭스를 공유하는 실사 13상품 향후 승격 후보). 공유 파일 미수정.
- ★**가격 경계(방법론):** 온톨로지는 **use_dims 차원 선언까지만** — off-grid ceiling·롤 소재 가격 계산
  로직은 evaluate_price/암묵지(KB 밖·[[gap-125-roll-price-logic]]). 실사 시트 inline price(R/S/V)는
  가격 권위 아님[HARD](pack §0 특성2).

## 옵션·제약·추가상품 (라이브 실측)
- **옵션그룹 1(가공·택1 선택·mand=N):** `OPT_000010` 가공(오버로크 봉제 가공·SEL_TYPE.01·min0/max1)
  → 옵션값 오버로크(`OPV_000028`·dflt) → `OPT_REF_DIM.04 ref_key1=PROC_000080`(공정 참조). 옵션=공정
  BUNDLE(pack §3.9). 부모 has_process(PROC_000080)에 실재 → `fn_chk_opt_item_ref` 정합(L-18 통과).
  하위=[[product-125-canvas-fabric-poster-nodes#optgroup-125-gagong]].
- **제약규칙 1(nonspec 치수범위):** `RULE_001` 사용자입력 치수 범위(`rule_typ_cd=RULE_TYPE.01`·use_yn=Y)
  — nonspec 입력 시 가로/세로 범위 검증(JSONLogic·폼빌더 shape·전사표). ★pack §1.1 실사 constraints
  신규 발현 7상품 중 125 1행(위키 "constraints 0행"은 STALE·T-3). CN 유형=범위/입력검증. 하위=
  [[product-125-canvas-fabric-poster-nodes#constraint-125-nonspec-range]].
- **추가상품:** `t_prd_product_addons` = 125 행 **없음**(125는 부속붙는 8상품 아님·pack §3.12 목록 밖).
- **셋트:** `t_prd_product_sets` = 125 부모/자식 행 **없음**(부품조립 셋트 아님·완제품 단일 SOT 정합).

## 승계·freshness 메모
- 정체·소재 13군·면적/고정 분기 = pack §3.1/§3.5/§3.10 FRESH + mapping.md(승계·재검증 2026-07-03·
  live comp=동형결합으로 갱신). round-13 결함 상태값(T-6)·CAT_000298 고아(T-1)·레더/패브릭 .08(T-2)·
  constraints 0행(T-3)은 STALE 인용 금지.
- 면적매트릭스·비종이류 판형없음·봉제 완성형태 = pack §0 특성1~4·§3.8 FRESH.
- 캔버스 MAT_TYPE .08→.05 교정·판형 3행 논리삭제(06-30)·comp 동형결합은 live-snapshot 20260702_1119
  실측(round-13/위키에 없던 신사실).
- **연당가/롤가:** 롤 소재 가격 계산 로직(off-grid·엑셀 미기재 암묵지)은 실사 전체 GAP
  ([[gap-125-roll-price-logic]]·source-registry §9 GAP-2)로 정직 지연(값 판정=엔진 소관).

---

> 상품 전용 하위 노드(카테고리·사이즈·자재·공정·공식·구성요소·옵션그룹·양면 defect·GAP)는
> [[product-125-canvas-fabric-poster-nodes]] companion에 신설(052 방식·공유 axis/* 미수정).
> 실사 첫 상품이라 실사 공유 축(카테고리 CAT_000004/072·면적공식 PRF_POSTER_CANVAS·구성요소
> COMP_POSTER_CANVAS_FABRIC·봉제 PROC_000080·캔버스 MAT_000185·A계열 사이즈)은 여기 mint→
> needed_shared_nodes로 반환(향후 실사 13 면적상품 승격 후보).
