---
id: sticker-pack
type: product
anchor: t_prd_products/PRD_000065
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000065 (스티커팩·prd_typ_cd=PRD_TYPE.01·use_yn=Y·del_yn=N·file_upload_yn=N·editor_yn=Y·min1/max1000/incr1·QTY_UNIT.02)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-sticker.md", source_locator: "§1(스티커 16상품 5분기)·§3.1 정체·§3.10 완제품가 룩업·§3.12 스티커팩 065=세트(GAP)·§4-A/§4-D 연당가 판정", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-sticker}
  - {source_file: "_workspace/huni-dbmap/17_correctness/sticker/product-identity.md", source_locator: "문서:§0~1 스티커 정체(승계·재검증 2026-07-03 — prd_typ은 live PRD_TYPE.01로 갱신·T-1)", captured_at: "2026-07-03", badge: verified, src_id: SR-13-sticker-identity}
  - {source_file: "live-snapshot/latest/t_prd_product_price_formulas.csv", source_locator: "테이블:t_prd_product_price_formulas 키:(PRD_000065,PRF_STK_PACK)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
relations:
  - {rel: in_category, target: category-CAT_000002, note: "스티커(root·main_cat_yn=Y·cat_lvl 1)·공유 재사용"}
  - {rel: in_category, target: category-CAT_000312, note: "스티커팩(cat_lvl 2·main_cat_yn=N·상위 CAT_000002)·local"}
  - {rel: has_size, target: size-SIZ_000068, note: "75x110·판걸이=16·적용 스티커팩(단일 사이즈)"}
  - {rel: uses_material, target: material-MAT_000084, note: "비코팅스티커(★live mat_typ=MAT_TYPE.13·note는 .11 주장·dflt)·공유 재사용(spec-rectangle)"}
  - {rel: uses_material, target: material-MAT_000242, note: "미색스티커(MAT_TYPE.11·dflt)·공유 재사용(spec-rectangle)"}
  - {rel: has_print_option, target: printopt-POPT_000001, note: "단면 단일(front CMYK 4도·back 인쇄 안 함)·공유 축 재사용"}
  - {rel: has_plate_size, target: plate-OUTPUT_PAPER_TYPE_02, note: "46계열 전지 SIZ_000521 330x470(active·dflt)·점착지=종이류라 판형 유효·fn_best_plate 자동선택·공유 재사용(052)"}
  - {rel: has_qty_rule, target: qty-065}
  - {rel: priced_by, target: formula-PRF_STK_PACK, note: "완제품가 합가형(54장1세트 4000·COMP_STK_PACK·소재무관)"}
props:
  prd_typ_cd: PRD_TYPE.01
  semi_role_cd: null
  file_upload_yn: N
  editor_yn: Y
  min_qty: 1
  max_qty: 1000
  qty_incr: 1
  qty_unit_typ_cd: QTY_UNIT.02
  use_yn: Y
  del_yn: N
  구분: "스티커팩(완제품 단일·합가형 완제품가 54장1세트 고정가)"
  price_archetype: "완제품가 합가형 고정가 룩업(원자합산형 아님·COMP_STK_PACK 1행·소재 연당가 직접 노드 없음)"
  status_note: "출시 상태(use_yn=Y). 값 raw는 companion 전사표 권위(스크립트 전사·손전사 금지)"
standards: {schema_org: Product, xjdf: "Product(스티커팩)", config_ont: "component type"}
answers_cq: ["구체 상품 질의(스티커팩 구성·가격 경로)", "조건 탐색(스티커 완제품 팩)", "가격 경로(합가형 54장1세트 고정가)"]
tags: ["#스티커", "#스티커팩", "#완제품가룩업", "#합가형", "#세트여부GAP", "#출시"]
updated: 2026-07-03
---

# sticker-pack 스티커팩 (PRD_000065)

스티커팩은 스티커 카테고리의 **완제품 단일**(`prd_typ_cd=PRD_TYPE.01`)이다. 여러 장의 스티커를
한 팩(**54장 = 1세트**)으로 묶어 **고정가(4,000원)** 로 파는 상품이다. 에디터로 편집
(`editor_yn=Y`)하고 파일 업로드는 안 쓴다(`file_upload_yn=N`). 최소 1·최대 1,000·1 증분
(단위 QTY_UNIT.02). 카테고리 = 스티커 root(`CAT_000002`·main)·스티커팩(`CAT_000312`·cat_lvl 2).
수량·치수·단가행 raw 값은 [[sticker-pack-nodes]] 전사표가 권위(스크립트 전사·손전사 금지).

★**스티커 가격 = 완제품가 고정가 룩업**(원자합산형 아님·팩 §3.10). 스티커팩은 그중에서도 **합가형**
(`COMP_STK_PACK`·PRICE_TYPE.02) — 54장 1세트를 4,000원에 통째로 룩업한다. 소재 연당가(원자재 원가)는
이 상품 가격사슬에 **직접 노드로 존재하지 않는다**(완제품가로 통째 저장·§4-B). 아래 "가격 경로" 참조.

## 정체·유형 (SOT 준수)
- 상품유형 분류 SOT: **완제품(.01)** = 일반 단일 제조상품. 스티커팩은 **현재 `t_prd_product_sets`
  부모 등록이 없어(sets 0행)** 단일 완제품으로 적재돼 있다(SOT 정합). 기성/디자인 아님.
- ★**"팩=세트" 미결(GAP-ST-4·Q-ST-E):** 상품명·카테고리(스티커팩)는 여러 스티커를 묶는 **세트**를
  시사하나, 라이브 `t_prd_product_sets`는 **부모/구성원 0행**(구성품 미적재). 현재는 세트 조립이 아니라
  **합가형 완제품가(54장1세트 4,000)** 단일 룩업으로 구현. 팩이 반제품 구성원을 갖는 셋트여야 하는지는
  미결 → [[gap-065-set-composition]](단정 금지·정직 선언). 팩 §3.12·§5.
- ★**prd_typ_cd 재분류 승계:** round-13 product-identity §0은 스티커 16상품 전량 `PRD_TYPE.04(디자인상품)`
  이라 했으나 live 실측 = `PRD_TYPE.01(완제품)`(SOT .04 폐기→재분류·팩 §1.1·T-1). round-13 .04 서술은
  STALE 인용 금지.
- 스티커 16상품 **인쇄방식 5분기** 중 065는 **순수 인쇄물**(커팅·후가공 공정 0행·아래 자재·공정 절).

## 차원
- **사이즈:** 단일 1행 — `SIZ_000068`(75×110·재단=작업 동일·판걸이=16.0·전지 미지정·적용=스티커팩·dflt).
  이산 단일 사이즈(면적매트릭스 아님). 판걸이수(UP수)는 사이즈의 파생값(`fn_calc_pansu` t_siz_pansu
  lookup→기하 폴백·[[rule/rules#RULE_pansu_db_function]]·note 판걸이=16). 치수 전사=
  [[sticker-pack-nodes#전사표-권위-라이브-스냅샷-스크립트-전사]].
- **도수:** 단면 단일(POPT_000001·front CLR_000005 CMYK 4도·back CLR_000001 인쇄 안 함). 도수는
  색상코드가 아니라 인쇄옵션 코드([[rule/rules#RULE_dosu_is_printopt]]). 화이트 underbase(PROC_000008)는
  065에 없음(투명/홀로 베이스 상품군 몫).
- **수량규칙:** 제품 레벨 min 1 / max 1,000 / incr 1(QTY_UNIT.02). `t_prd_product_bundle_qtys` 065 행
  **없음**(제품 레벨 규칙만). ★단 가격 격자(COMP_STK_PACK)는 **min_qty=54 필수**(54장1세트) — 제품 수량
  단위(1~1,000)와 가격 격자 밴드(54장)의 관계가 합가형 특유라 [[gap-065-pack-qty-band]]에 정직 관찰
  (손님 수량 선택↔54장1세트 룩업 정합은 evaluate_price 소관). 수량 UI 권위 = 제품/사이즈 수량규칙
  (가격구간과 역할 분리·팩 §3.4). 하위 [[qty-065]].

## 자재·공정
- **자재:** 활성 2종 — 비코팅스티커 `MAT_000084`·미색스티커 `MAT_000242`(둘 다 usage USAGE.07·dflt_yn=Y·
  단일 슬롯). 정답 자재유형 = MAT_TYPE.11(스티커 점착지·팩 §3.5). ★**MAT_000084는 live mat_typ=`MAT_TYPE.13`**
  (은/투명데드롱 등 6개 점착지 variant가 공유하는 실사용 유형)인데 **자기 note는 "정정 종이(.01)→스티커(.11)"**
  로 .11을 주장 → 라벨 nuance 불일치. .13도 종이(.01)에서 벗어난 점착지 계열이라 재분류 본질은 달성됐으나
  .11↔.13 라벨은 기초코드 거버넌스(§12) 판정 대상 → [[gap-065-material-type-label]](단정 금지·honest 관찰).
  미색스티커 242는 .11로 note와 일치. ★IMPORT 시트 등록 자재 삭제 금지([[rule/rules#RULE_import_material_no_delete]]).
- ★**자재는 가격 차원 아님:** COMP_STK_PACK use_dims=`[siz_cd, min_qty]` — **mat_cd 미포함**. 즉 팩 가격은
  소재와 무관(2 자재는 BOM·선택지일 뿐 단가 축 아님). 옵션그룹 0행이라 손님이 자재를 CPQ로 고르지도 않는다.
- **공정:** `t_prd_product_processes` 065 행 **0개**(활성·삭제 모두 없음). 커팅(반칼/완칼/도무송)·라미·별색
  underbase 전부 없음 = **순수 인쇄물**(팩 §3.6 "스티커팩 065·타투 067 = 커팅 0행"). 완제품가(합가형)로
  출력·가공이 통째 반영되므로 공정 원자가 필요 없다.

## 가격 경로 (D-18 경계 — 값은 evaluate_price 권위) — ★가격 경로 연결됨
- `sticker-pack --priced_by--> formula-PRF_STK_PACK --has_component--> component-COMP_STK_PACK`.
  **고아 공식 아님**(has_component 1개=COMP_STK_PACK)·**끊긴 가격 사슬 아님**(priced_by 1개).
- ★**완제품가 합가형 룩업(원자합산 아님):** COMP_STK_PACK(PRICE_TYPE.02 합가형·`comp_typ_cd=PRC_COMPONENT_TYPE.06`)
  use_dims=`[siz_cd, min_qty]` — 스티커팩 완제품가(출력+가공 포함)를 (사이즈·수량밴드) 격자로 통째 저장.
  live 격자 = **단 1행**(SIZ_000068·min_qty=54·unit_price 4,000·note "54장1세트·min_qty=54 필수"·mat_cd 무).
  값 나열 아님(단가행 접기·D-22)·값 계산=evaluate_price 권위([[rule/rules#RULE_price_value_boundary]]).
  전사=[[sticker-pack-nodes#전사표-권위-라이브-스냅샷-스크립트-전사]].
- ★**소재 연당가는 이 사슬에 없다:** COMP_PAPER(용지비)에 065 소재(084/242) **0행**(실측)·t_mat_materials에
  가격 컬럼 없음. 스티커는 원가(연당가)를 절가 노드로 펼치지 않고 완제품가로 통째 저장(팩 §4-B).
- ★**신규 공식/구성요소(스티커 합가형 첫 등재):** PRF_STK_PACK·COMP_STK_PACK은 공유 축(formula/·
  digital-components)에도 052 계열(PRF_STK_FIXED·COMP_STK_PRINT)에도 없다. companion에 상품-local mint하고
  **needed_shared_nodes**로 반환(팩류 승계 후보). 공유 파일 미수정.

## 연당가 재적재 판정 (§4-D 돈-크리티컬)
- ★**065 소재(비코팅스티커·미색스티커)는 260702 substantive 연당가 변경 대상 아님** — 전사 diff 대조 결과
  §4-A 돈-크리티컬 4소재(투명스 149,500·홀로 253,700·크라프트 81,500·투명후지 222,000)에 **065 소재 미포함**
  (065 소재 언급은 N2 좌표 라벨 1행뿐·단가 무영향). ⇒ 065는 clean → **양면(defect) 노드 만들지 않음**
  (false-defect 방지·052 선례). 연당가 워크리스트는 투명/홀로/크라프트/투명후지 소재 몫(053/056/063 등).
- ★**완제품가 retail 노드도 dual 금지:** 스티커 완제품 가격표(COMP_STK_PACK 포함)는 260702 무변경(change-manifest
  §1 라벨만) → 라이브 retail=권위 일치. 065에는 연당가 급변→retail 전파 열린질문(053의 [[gap-053-yeondangga-repricing]])이
  적용되지 않는다(소재가 급변 4소재가 아님). 정직 지연 포인터=[[gap-065-liandan-out-of-scope]].

## 옵션·제약·추가상품·셋트 (라이브 실측·0행)
- **옵션그룹:** `t_prd_product_option_groups` 065 행 **0개**(CPQ 옵션 레이어 미적재). 자재/도수/커팅을 손님이
  CPQ로 고르지 않음(고정 팩) → 팩 §3.9 BATCH-6(스티커 CPQ 일괄 적재 대기)에 065도 포함(빈 축·GAP 표기).
  [[gap-065-cpq-option-layer]].
- **제약규칙:** `t_prd_product_constraints` 065 행 **0개**(제약 미등록). 코팅 CONFLICT(052 등)는 자재/공정
  코팅 상품 몫 — 065는 순수 인쇄물이라 코팅 축 없음(CONFLICT 무관).
- **추가상품:** `t_prd_product_addons` 065 행 **0개**.
- **셋트:** `t_prd_product_sets` 065 부모/구성원 **0행** → 위 정체 절 [[gap-065-set-composition]](팩이 세트여야
  하는지 미결·Q-ST-E). 스티커 세트는 065 스티커팩만 후보(팩 §3.12).

## 승계·freshness 메모
- 정체·5분기·완제품가 룩업 의미 = 팩 §3.1/§3.10/§4-B FRESH 승계 + round-13 product-identity(승계·재검증
  2026-07-03·prd_typ은 live로 갱신). round-13 결함 상태값(T-6)·prd_typ .04(T-1)은 STALE 인용 금지.
- 합가형(PRF_STK_PACK·COMP_STK_PACK·54장1세트 4,000·min_qty=54)·공정 0행·옵션 0행·sets 0행은
  live-snapshot 20260702_1119 실측(위키 recipe에 065 전용 블록 없음 — live 재측정으로 신규 등재).
- 연당가 재적재(§4-D): 065 소재(비코팅/미색)는 260702 substantive 변경 아님 → dual 금지·[[gap-065-liandan-out-of-scope]].

---

> 상품 전용 하위 노드(카테고리 CAT_000312·사이즈 SIZ_000068·공식 PRF_STK_PACK·구성요소 COMP_STK_PACK·
> 수량·GAP 5·전사표)는 [[sticker-pack-nodes]] companion에 신설(052/053 방식·공유 axis/* 미수정).
> 공유 재사용 노드(category-CAT_000002·material-MAT_000084/242·printopt-POPT_000001·plate-OUTPUT_PAPER_TYPE_02)는
> 중복 신설하지 않는다(L-3).
