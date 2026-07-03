---
id: product-052-sticker-halfcut-freeform
type: product
anchor: t_prd_products/PRD_000052
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000052 (반칼 자유형 스티커·prd_typ_cd=PRD_TYPE.01·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-sticker.md", source_locator: "§1(스티커 16상품 5분기)·§3.1 정체·§3.6 커팅 반칼·§3.10 완제품가 룩업·§4-D 연당가 판정", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-sticker}
  - {source_file: "_workspace/huni-dbmap/17_correctness/sticker/product-identity.md", source_locator: "문서:§0~1 스티커 정체(승계·재검증 2026-07-03 — prd_typ은 live PRD_TYPE.01로 갱신·T-1)", captured_at: "2026-07-03", badge: verified, src_id: SR-13-sticker-identity}
  - {source_file: "live-snapshot/latest/t_prd_product_price_formulas.csv", source_locator: "테이블:t_prd_product_price_formulas 키:(PRD_000052,PRF_STK_FIXED) note:반칼 자유형 스티커→규격/소재/수량 단가", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
relations:
  - {rel: in_category, target: category-CAT_000002, note: "스티커(root·main_cat_yn=Y·cat_lvl 1)"}
  - {rel: in_category, target: category-CAT_000309, note: "자유형스티커(cat_lvl 2·main_cat_yn=N·상위 CAT_000002)"}
  - {rel: has_size, target: size-SIZ_000057, note: "A6 105x148·반칼(판걸이=8.0·master 실재)"}
  - {rel: has_size, target: size-SIZ_000520, note: "A4 반칼(판걸이=2.0·반칼 전용가·낱장 SIZ_172와 분리)"}
  - {rel: has_size, target: size-SIZ_000170, note: "A5 148x210·★junction 활성이나 master del_yn=Y(양면 defect·정리 워크리스트)"}
  - {rel: uses_material, target: material-MAT_000584, note: "유포스티커 80g·dflt(종이 옵션값)"}
  - {rel: uses_material, target: material-MAT_000611, note: "아트스티커 90g"}
  - {rel: uses_material, target: material-MAT_000585, note: "무광코팅스티커(아트지90g+무광라미)·★코팅=자재 흡수(BATCH-3 CONFLICT)"}
  - {rel: uses_material, target: material-MAT_000586, note: "유광코팅스티커(아트지90g+유광라미)·★코팅=자재 흡수(BATCH-3 CONFLICT)"}
  - {rel: uses_material, target: material-MAT_000609, note: "미색스티커(모조80g)"}
  - {rel: has_print_option, target: printopt-POPT_000001, note: "단면 단일(front CMYK 4도·back 인쇄 안 함)·공유 축 재사용"}
  - {rel: has_process, target: process-PROC_000122, qualifier: mandatory, note: "반칼커팅(Kiss Cut·mand·disp 1·상위 PROC_000121 커팅)·★PROC_000054 반칼→122로 이관(구 코드 논리삭제)"}
  - {rel: has_process, target: process-PROC_000014, note: "유광라미네이팅(opt·상위 PROC_000013 코팅)·★코팅=공정 표현(자재 585/586와 이중·CONFLICT)·공유 축 재사용"}
  - {rel: has_process, target: process-PROC_000015, note: "무광라미네이팅(opt·상위 PROC_000013 코팅)·★코팅=공정 표현·공유 축 재사용"}
  - {rel: has_plate_size, target: plate-OUTPUT_PAPER_TYPE_02, note: "46계열 출력용지(SIZ_000521 330x470 표준전지)·점착지=종이류라 판형 유효·fn_best_plate 자동선택"}
  - {rel: has_qty_rule, target: qty-052}
  - {rel: priced_by, target: formula-PRF_STK_FIXED, note: "완제품가 고정가 룩업형(COMP_STK_PRINT·형상×치수×소재×수량 격자)"}
  - {rel: has_option_group, target: optgroup-052-paper, note: "종이(자재) 택1 필수·5옵션값"}
  - {rel: has_option_group, target: optgroup-052-print, note: "인쇄(도수) 택1 필수·단면 단일"}
  - {rel: has_option_group, target: optgroup-052-cut, note: "커팅(공정) 택1 필수·반칼(자유형)·★ref_key1=PROC_000054(삭제됨)→gap"}
props:
  prd_typ_cd: PRD_TYPE.01
  semi_role_cd: null
  file_upload_yn: Y
  editor_yn: N
  min_qty: 8
  max_qty: 10000
  qty_incr: 8
  qty_unit_typ_cd: QTY_UNIT.02
  use_yn: Y
  del_yn: N
  구분: "스티커(반칼 자유형·완제품 단일·5분기 중 디지털 토너 계열)"
  price_archetype: "완제품가 고정가 룩업(원자합산형 아님·소재 연당가 직접 노드 없음)"
  status_note: "출시 상태(use_yn=Y). 값 raw는 companion 전사표 권위(스크립트 전사·손전사 금지)"
standards: {schema_org: Product, xjdf: "Product(스티커)", config_ont: "component type"}
answers_cq: ["구체 상품 질의(반칼 자유형 스티커 구성·가격 경로)", "조건 탐색(자유형 반칼 스티커)", "옵션 조합(종이/인쇄/커팅 선택)"]
tags: ["#스티커", "#반칼", "#자유형", "#완제품가룩업", "#코팅CONFLICT", "#출시"]
updated: 2026-07-03
---

# product-052 반칼 자유형 스티커 (PRD_000052)

반칼 자유형 스티커는 스티커 카테고리의 **완제품 단일**(`prd_typ_cd=PRD_TYPE.01`)이다. 점착지
(유포·아트·미색·코팅스티커)에 칼라 단면 인쇄 후 **반칼(Kiss Cut·`PROC_000122`)** 로 자유형
모양대로 반만 잘라(뒷지 남김) 떼어 쓰는 스티커다. 파일 업로드 방식(`file_upload_yn=Y`, 에디터
미사용). 최소 8매·최대 10,000매·8매 증분(단위 QTY_UNIT.02 "매"). 카테고리 = 스티커
root(`CAT_000002`·main)·자유형스티커(`CAT_000309`). 수량·치수·단가행 raw 값은
[[product-052-sticker-halfcut-freeform-nodes]] 전사표가 권위(스크립트 전사·손전사 금지).

★**스티커 가격 = 완제품가(시트가격) 고정가 룩업**(원자합산형 아님·팩 §3.10). 소재 연당가
(원자재 원가)는 이 상품 가격사슬에 **직접 노드로 존재하지 않는다**(완제품가로 통째 저장·§4-B).
아래 "가격 경로" 절 참조.

## 정체·유형 (SOT 준수)
- 상품유형 분류 SOT: **완제품(.01)** = 일반 단일 제조상품. 반칼 자유형 스티커는
  `t_prd_product_sets` 부모 등록이 없어(셋트 아님) 일반 단일 완제품(SOT 정합). 기성/디자인 아님.
- ★**prd_typ_cd 재분류 승계:** round-13 product-identity §0은 스티커 16상품 전량 `PRD_TYPE.04(디자인상품)`
  이라 했으나 live 실측 = `PRD_TYPE.01(완제품)`(SOT .04 폐기→재분류 교정 완료·팩 §1.1·T-1). 온톨로지는
  현재값 `PRD_TYPE.01` 채택. round-13 .04 서술은 STALE 인용 금지.
- 스티커 16상품 **인쇄방식 5분기**(디지털 토너 PROC_000004·실사 잉크젯·화이트인쇄·합판 도무송·전사)
  중 052는 **디지털 계열**(반칼 커팅). 형제 합판도무송 066(완칼 도무송·형상=size)과 커팅 방식이 다르다.

## 차원
- **사이즈:** 활성 3행 — A6(`SIZ_000057` 105x148·판걸이 8.0)·A4반칼(`SIZ_000520`)·A5(`SIZ_000170`
  148x210). 이산 사이즈 행(면적매트릭스 아님). ★**A5(SIZ_000170)는 junction 활성인데 master가
  논리삭제(del_yn=Y)** 된 불일치 → 양면 defect 노드
  [[product-052-sticker-halfcut-freeform-nodes#size-SIZ_000170]](정리 워크리스트·current≠authority).
  판걸이수(UP수)는 사이즈의 파생값(`fn_calc_pansu` t_siz_pansu lookup→기하 폴백·
  [[rule/rules#RULE_pansu_db_function]]). 치수 전사=
  [[product-052-sticker-halfcut-freeform-nodes#전사표-권위-라이브-스냅샷스크립트-전사]].
- **도수:** 단면 단일(POPT_000001·front CLR_000005 CMYK 4도·back CLR_000001 인쇄 안 함). 도수는
  색상코드가 아니라 인쇄옵션 코드([[rule/rules#RULE_dosu_is_printopt]]). 화이트 underbase(PROC_000008)는
  052에 없음(투명/홀로 베이스 상품군 몫·063 등).
- **수량규칙:** 제품 레벨 min 8 / max 10,000 / incr 8(QTY_UNIT.02). `t_prd_product_bundle_qtys`에
  052 행 **없음**(제품 레벨 규칙만). 수량 UI 권위 = 제품/사이즈 수량규칙(가격구간과 역할 분리·팩 §3.4).
  하위 [[qty-052]].

## 자재·공정
- **자재:** 활성 5종(유포 `MAT_000584`·아트 `MAT_000611`·무광코팅 `MAT_000585`·유광코팅 `MAT_000586`·
  미색 `MAT_000609`) — 전부 `MAT_TYPE.11(스티커)` 점착지·parent+usage_cd 단일 슬롯(USAGE.07). 정답
  자재유형 = MAT_TYPE.11(팩 §3.5). 구 부모코드(유포 153·무광 155·유광 156·미색 242)는 06-30~07-01
  자식코드로 재키잉되며 052 product_materials에서 논리삭제(del_yn=Y)·자식이 활성. ★IMPORT 시트 등록
  자재 삭제 금지([[rule/rules#RULE_import_material_no_delete]]).
- ★**코팅 CONFLICT(BATCH-3·미해소):** 무광/유광코팅스티커(585/586)가 **자재(종이 옵션값)** 로 흡수돼
  있는데, 라이브는 동시에 **라미네이팅 공정(PROC_000014 유광·PROC_000015 무광 opt)** 도 붙여 코팅을
  **자재와 공정 양쪽**으로 표현한다. 실무진 Q9 권위=코팅=공정(PROC_000013). 260702 가격표=코팅을
  가격컬럼축(비코팅/무광/유광)으로 취급(자재 흡수 지지). **양립 곤란·미해소** → 단정 금지·
  [[gap-052-coating-conflict]](양면 기록·Q-ST-A). 팩 §3.9·T-4.
- **공정:** 라이브 `t_prd_product_processes` 활성 3행 — **반칼커팅(PROC_000122·mand·disp 1·상위
  PROC_000121 커팅)** + 유광라미(014·opt) + 무광라미(015·opt). ★반칼은 구 `PROC_000054`(Kiss Cut)
  에서 **PROC_000122로 이관**(구 코드는 052 product_processes에서 논리삭제·pack §3.6 "반칼=PROC_000054"는
  live 재측정으로 갱신). 023 완칼이 PROC_000053→PROC_000123으로 이관된 것과 동형(상위 PROC_000121 커팅).

## 가격 경로 (D-18 경계 — 값은 evaluate_price 권위) — ★가격 경로 연결됨
- `product-052 --priced_by--> formula-PRF_STK_FIXED --has_component--> component-COMP_STK_PRINT`.
  **고아 공식 아님**(has_component 1개=COMP_STK_PRINT)·**끊긴 가격 사슬 아님**(priced_by 1개).
- ★**완제품가 룩업형(원자합산 아님):** COMP_STK_PRINT(PRICE_TYPE.01·`comp_typ_cd=PRC_COMPONENT_TYPE.06`)
  use_dims=`[siz_cd, mat_cd, min_qty]` — 스티커 완제품가(출력+가공 포함)를 (사이즈·소재·수량구간) 격자로
  통째 저장. 052 활성 (siz×mat) 15조합 전부 단가행 실재(SIZ_000057/520/170 × 5소재, 조합당 36 수량구간행·
  [[product-052-sticker-halfcut-freeform-nodes#가격구성요소-완제품가-룩업]] 전사표 행수요약). 값 나열 아님
  (단가행 접기·D-22)·값 계산=evaluate_price 권위([[rule/rules#RULE_price_value_boundary]]).
- ★**소재 연당가는 이 사슬에 없다:** COMP_PAPER(용지비)에 052 소재(584/585/586/609/611) **0행**(실측)·
  t_mat_materials에 가격 컬럼 없음. 스티커는 원가(연당가)를 절가 노드로 펼치지 않고 완제품가로 통째 저장
  (팩 §4-B). 연당가 재적재 판정은 [[gap-052-liandan-out-of-scope]] 참조(052는 clean·false-defect 방지).
- ★**신규 공식/구성요소(스티커 첫 상품):** PRF_STK_FIXED·COMP_STK_PRINT은 디지털 공유 축
  (formula/·formula/digital-components)에 없다. companion에 상품-local mint하고 **needed_shared_nodes**로
  반환(스티커 6,498행 완제품가를 공유하는 16상품 향후 승격 후보). 공유 파일 미수정.
- ★**옵션값 자재코드 ↔ 단가행 자재코드 정합(관찰):** 종이 옵션값이 자식코드(584/585/586/609/611)를
  가리키고 COMP_STK_PRINT 격자도 같은 자식코드로 재키잉됨(실측 15조합 매칭) → 052는 코드 불일치 없음.
  (구 부모코드 격자행도 SIZ_000520에 잔존하나 옵션이 자식만 노출 → 룩업은 자식으로 해소.)

## 옵션·제약·추가상품 (라이브 실측)
- **옵션그룹 3(전부 택1 필수):** 종이(OPT_000006·5옵션값→자재)·인쇄(OPT_000007·1옵션값→도수)·
  커팅(OPT_000008·1옵션값→공정). 옵션=자재/공정/도수 BUNDLE(팩 §3.9). 하위 노드=
  [[product-052-sticker-halfcut-freeform-nodes#옵션그룹-cpq]].
  - ★**커팅 옵션 매달린 참조:** 커팅 옵션값 OPV_000023(반칼 자유형)이 `OPT_REF_DIM.04 ref_key1=PROC_000054`
    를 가리키는데 PROC_000054는 052 활성 공정이 아니다(이관된 PROC_000122가 활성). fn_chk_opt_item_ref
    정합 위반 신호 → [[gap-052-cut-optref-dangling]]. 정직 GAP(옵션참조는 같은 부모 차원에 실재해야 함).
- **제약규칙:** `t_prd_product_constraints` = 052 행 **없음**(CPQ 제약 미등록). 코팅×종이두께 등 물리제약
  필요 여부는 §31 제약 하네스 소관(현재 데모 미착수·GAP 아님).
- **추가상품:** `t_prd_product_addons` = 052 행 **없음**.
- **셋트:** `t_prd_product_sets` = 052 부모/자식 행 **없음**(부품조립 셋트 아님·완제품 단일 SOT 정합).
  스티커 세트는 065 스티커팩만(팩 §3.12·052 무관).

## 승계·freshness 메모
- 정체·5분기·형상 의미 = 팩 §3.1/§3.6 FRESH 승계 + round-13 product-identity(승계·재검증 2026-07-03·
  prd_typ은 live로 갱신). round-13 결함 상태값(T-6)·prd_typ .04(T-1)은 STALE 인용 금지.
- 완제품가 룩업·연당가 별개 축 = 팩 §3.10/§4-B FRESH.
- 반칼 PROC_000054→122 이관·A5 master 삭제는 live-snapshot 20260702_1119 실측(위키에 없던 신사실).
- **연당가 재적재(§4-D):** 052 소재(유포/아트/미색/코팅)는 260702 substantive 연당가 변경 대상 아님
  (전사표 "연당가 대조" 전행 NO·N2 라벨/무변). 팩 §4-A 돈-크리티컬 연당가 대개편(투명 149,500/홀로
  253,700/크라프트 81,500/투명후지 222,000)은 **투명·홀로·크라프트** 소재 몫이라 052 밖(063 반칼팬시투명
  등). ⇒ 052 완제품가 retail 노드 dual 금지(false-defect 방지)·연당가 워크리스트는
  [[gap-052-liandan-out-of-scope]]로 정직 지연.

---

> 상품 전용 하위 노드(카테고리·사이즈·자재·공정·판형·수량·공식·구성요소·옵션그룹·양면 defect·GAP)는
> [[product-052-sticker-halfcut-freeform-nodes]] companion에 신설(023 방식·공유 axis/* 미수정).
> 공유 재사용 노드(printopt-POPT_000001·process-PROC_000013/014/015)는 중복 신설하지 않는다(L-3).
