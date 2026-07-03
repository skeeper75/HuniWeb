---
id: sticker-tattoo
type: product
anchor: t_prd_products/PRD_000067
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000067 (타투스티커·prd_typ_cd=PRD_TYPE.01·use_yn=Y·del_yn=N·min3/max1000/incr3·QTY_UNIT.02·file_upload_yn=Y·editor_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-sticker.md", source_locator: "§1(스티커 16상품·인쇄방식 5분기 중 전사)·§3.1 정체(타투 067=커팅 0행 순수 인쇄물)·§3.5 타투전용지=종이 .01 정당가능(표본 컨펌)·§3.10 완제품가 룩업·§3.11 COMP_STK_TATTOO 666행(3장세트)·§4-D 연당가 판정", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-sticker}
  - {source_file: "_workspace/huni-dbmap/17_correctness/sticker/product-identity.md", source_locator: "문서:§0~1 스티커 정체(승계·재검증 2026-07-03 — prd_typ은 live PRD_TYPE.01로 갱신·T-1)", captured_at: "2026-07-03", badge: verified, src_id: SR-13-sticker-identity}
  - {source_file: "live-snapshot/latest/t_prd_product_price_formulas.csv", source_locator: "테이블:t_prd_product_price_formulas 키:(PRD_000067,PRF_STK_TATTOO) apply_bgn_ymd 2026-06-01", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
relations:
  - {rel: in_category, target: category-CAT_000002, note: "스티커(root·main_cat_yn=Y·cat_lvl 1·067 disp 16)"}
  - {rel: in_category, target: category-CAT_000311, note: "특수스티커(cat_lvl 2·main_cat_yn=N·상위 CAT_000002·052의 자유형스티커 CAT_000309와 다른 sub)"}
  - {rel: has_size, target: size-SIZ_000060, note: "90x190(작업 94x194·재단 90x190·dflt·master del_yn=N)·단일 사이즈"}
  - {rel: uses_material, target: material-MAT_000594, note: "타투스티커(MAT_TYPE.11·상위 MAT_000167·활성 자식·2026-06-30 신설)·구 부모 MAT_000167(타투전용지)는 07-01 junction 논리삭제(재키잉)"}
  - {rel: has_print_option, target: printopt-POPT_000001, note: "단면 단일(front CLR_000005 CMYK 4도·back CLR_000001 인쇄 안 함)·공유 축 재사용"}
  - {rel: has_plate_size, target: plate-OUTPUT_PAPER_TYPE_03, note: "기타(OUTPUT_PAPER_TYPE.03) 출력용지·플레이트 사이즈 SIZ_000050(A4 316x467 전지)·점착지=종이류라 판형 유효·fn_best_plate 자동선택·구 SIZ_000060 플레이트행은 06-30 논리삭제(재키잉)·공유 축 재사용"}
  - {rel: has_qty_rule, target: qty-067, note: "상품 레벨 min3/max1000/incr3(3장 단위·QTY_UNIT.02)"}
  - {rel: priced_by, target: formula-PRF_STK_TATTOO, note: "완제품가 합가형 룩업(COMP_STK_TATTOO·3장 1세트당 합산가·PRICE_TYPE.02)"}
  - {rel: has_option_group, target: optgroup-067-paper, note: "용지(자재) 택1 선택(mand=N·min_sel 0)·1옵션값→자재 MAT_000594"}
props:
  prd_typ_cd: PRD_TYPE.01
  semi_role_cd: null
  file_upload_yn: Y
  editor_yn: N
  min_qty: 3
  max_qty: 1000
  qty_incr: 3
  qty_unit_typ_cd: QTY_UNIT.02
  use_yn: Y
  del_yn: N
  구분: "스티커(타투스티커·완제품 단일·인쇄방식 5분기 중 전사=열전사 계열·커팅 공정 없음 순수 인쇄물)"
  price_archetype: "완제품가 합가형 룩업(PRICE_TYPE.02·3장 1세트당 합산가·원자합산형 아님·소재 연당가 직접 노드 없음)"
  status_note: "출시 상태(use_yn=Y). 값 raw는 companion 전사표 권위(스크립트 전사·손전사 금지)"
standards: {schema_org: Product, xjdf: "Product(스티커·타투)", config_ont: "component type"}
answers_cq: ["구체 상품 질의(타투스티커 구성·가격 경로)", "조건 탐색(전사 타투 스티커)", "옵션 조합(용지 선택·3장세트 수량)"]
tags: ["#스티커", "#타투스티커", "#전사", "#순수인쇄물", "#완제품가합가형룩업", "#3장세트", "#출시"]
updated: 2026-07-03
---

# sticker-tattoo 타투스티커 (PRD_000067)

타투스티커는 스티커 카테고리의 **완제품 단일**(`prd_typ_cd=PRD_TYPE.01`)이다. 타투전용지(점착지)에
칼라 단면 인쇄만 한 **순수 인쇄물**로, 커팅·라미 공정이 없다(전사=열전사 계열: 손님이 물/열로
피부에 옮겨 붙이는 임시 타투). 파일 업로드 방식(`file_upload_yn=Y`, 에디터 미사용). **3장 1세트**
단위로 팔려 최소 3매·최대 1000매·3매 증분(단위 QTY_UNIT.02). 카테고리 = 스티커 root(`CAT_000002`·main)
·특수스티커(`CAT_000311`). 수량·치수·단가행 raw 값은 [[sticker-tattoo-nodes]] 전사표가 권위
(스크립트 전사·손전사 금지).

★**스티커 가격 = 완제품가(시트가격) 룩업**(원자합산형 아님·팩 §3.10). 타투는 특히 **합가형**
(`COMP_STK_TATTOO`·`PRICE_TYPE.02`·"3장 1세트당 합산가")으로 052 반칼(고정가 `PRICE_TYPE.01`·
`COMP_STK_PRINT`)과 **다른 공식/구성요소**를 쓴다. 소재 연당가(원자재 원가)는 이 상품 가격사슬에
**직접 노드로 존재하지 않는다**(완제품가로 통째 저장·§4-B). 아래 "가격 경로" 절 참조.

## 정체·유형 (SOT 준수)
- 상품유형 분류 SOT: **완제품(.01)** = 일반 단일 제조상품. 타투스티커는 `t_prd_product_sets`
  부모 등록이 없어(셋트 아님) 일반 단일 완제품(SOT 정합). 기성/디자인 아님.
- ★**"3장세트"는 가격 번들이지 셋트 아님:** min_qty=3·qty_incr=3(3장 단위 판매)이고 COMP_STK_TATTOO
  note="3장 1세트당 합산가(합가형)"다. 이는 **수량 단위/가격 격자**의 축이지 `t_prd_product_sets`
  부품조립 셋트가 아니다(067 sets=0행). 진짜 스티커 셋트는 065 스티커팩만(팩 §3.12). 혼동 금지.
- ★**prd_typ_cd 재분류 승계:** round-13 product-identity §0은 스티커 16상품 전량 `PRD_TYPE.04(디자인상품)`
  이라 했으나 live 실측 = `PRD_TYPE.01(완제품)`(SOT .04 폐기→재분류 교정 완료·팩 §1.1·T-1). 온톨로지는
  현재값 `PRD_TYPE.01` 채택. round-13 .04 서술은 STALE 인용 금지.
- 스티커 16상품 **인쇄방식 5분기**(디지털 토너·실사 잉크젯·화이트인쇄·합판 도무송·전사) 중 067은
  **전사(열전사) 계열**. 커팅 공정 0행(052 반칼·066 도무송과 달리 잘라내지 않는 순수 인쇄물·팩 §3.1).

## 차원
- **사이즈:** 활성 1행 — 90x190(`SIZ_000060`·작업 94x194·재단 90x190·dflt·master del_yn=N).
  이산 사이즈 행(면적매트릭스 아님·팩 §3.2). 판걸이수(UP수)는 사이즈의 파생값(`fn_calc_pansu`
  `t_siz_pansu` lookup→기하 폴백·[[rule/rules#RULE_pansu_db_function]]·SIZ_000060 note "판걸이=6.0").
  치수 전사=[[sticker-tattoo-nodes#전사표-권위-라이브-스냅샷스크립트-전사]].
- **도수:** 단면 단일(POPT_000001·front CLR_000005 CMYK 4도·back CLR_000001 인쇄 안 함). 도수는
  색상코드가 아니라 인쇄옵션 코드([[rule/rules#RULE_dosu_is_printopt]]). 화이트 underbase(PROC_000008)는
  067에 없음(불투명 타투전용지라 언더베이스 불요·투명/홀로 베이스 상품군 몫).
- **수량규칙:** 제품 레벨 min 3 / max 1000 / incr 3(QTY_UNIT.02·3장 단위). `t_prd_product_bundle_qtys`에
  067 행 **없음**(제품 레벨 규칙만·실측 0행). 수량 UI 권위 = 제품/사이즈 수량규칙(가격구간과 역할
  분리·팩 §3.4). 하위 [[qty-067]].

## 자재·공정
- **자재:** 활성 1종 — 타투스티커 `MAT_000594`(`MAT_TYPE.11` 점착지·상위 MAT_000167·usage USAGE.07·
  2026-06-30 신설). 구 부모코드 타투전용지 `MAT_000167`은 06-03 본디 자재였으나 **2026-07-01 067
  product_materials에서 논리삭제(del_yn=Y)되고 자식 MAT_000594로 재키잉**됨(052의 부모→자식 재키잉과
  동형). ★IMPORT 시트 등록 자재 삭제 금지([[rule/rules#RULE_import_material_no_delete]]).
  - ★**자재유형 열린 질문(GAP·단정 금지):** live 067 자재는 `MAT_TYPE.11`(스티커 점착지)로 적재됐으나
    팩 §3.5는 "타투전용지(전사·067)=종이(.01) 정당 가능(표본 컨펌)"으로 열어둔다. 260702 권위가 .01을
    확정하지 않아 양면(current/authority) 대신 [[gap-067-mattype-transfer-paper]]로 정직 GAP 표기
    (실무진 표본 컨펌 대기·현재값 .11 채택).
- **공정:** 라이브 `t_prd_product_processes` = 067 행 **0개**(실측). 타투스티커는 잘라내는 커팅
  (반칼/완칼/도무송)도, 코팅/라미도 없는 **순수 인쇄물**(팩 §3.1 "타투 067=커팅 0행"). 형제 스티커
  (052 반칼 PROC_000122·066 도무송 PROC_000055)와 커팅 유무가 정체를 가른다. 코팅 CONFLICT(BATCH-3)는
  무광/유광 코팅스티커 국한 — 067(전사·코팅 무)=무관(정직 표기).

## 가격 경로 (D-18 경계 — 값은 evaluate_price 권위) — ★가격 경로 연결됨
- `sticker-tattoo --priced_by--> formula-PRF_STK_TATTOO --has_component--> component-COMP_STK_TATTOO`.
  **고아 공식 아님**(has_component 1개=COMP_STK_TATTOO)·**끊긴 가격 사슬 아님**(priced_by 1개).
- ★**완제품가 합가형 룩업(원자합산 아님):** COMP_STK_TATTOO(`PRICE_TYPE.02`·`comp_typ_cd=PRC_COMPONENT_TYPE.06`)
  use_dims=`[siz_cd, mat_cd, min_qty]` — 타투스티커 완제품가(출력 포함)를 (사이즈·소재·수량구간) 격자로
  통째 저장. note="타투스티커 완제품가. 3장 1세트당 합산가(합가형)". 052 COMP_STK_PRINT(고정가 .01)과
  달리 **합가형 .02**(합판 COMP_GANGPAN_PRINT와 같은 prc_typ)임을 실측 채택
  ([[sticker-tattoo-nodes#가격구성요소-완제품가-합가형-룩업]] 전사표).
- ★**활성 룩업 경로 = SIZ_000060 × MAT_000594(333 단가행)** 실재 → 가격 산출 가능(견적 0 아님). 구 자재
  MAT_000167 격자(333행)도 잔존하나 옵션이 자식 594만 노출 → 룩업은 활성 594로 해소(052의 구 부모코드
  잔존 격자와 동형·코드 불일치 없음). 값 나열 아님(단가행 접기·D-22)·값 계산=evaluate_price 권위
  ([[rule/rules#RULE_price_value_boundary]]).
- ★**소재 연당가는 이 사슬에 없다:** t_mat_materials에 가격 컬럼 없음·COMP_PAPER(용지비)에 067 소재
  (167/594) **0행**(실측). 스티커는 원가(연당가)를 절가 노드로 펼치지 않고 완제품가로 통째 저장
  (팩 §4-B). 067 소재는 260702 substantive 연당가 대개편 무관(diff에 "타투" 0행·§4 결론) → 연당가
  재적재 판정은 [[gap-067-liandan-out-of-scope]] 참조(067은 clean·false-defect 방지).
- ★**신규 공식/구성요소(스티커 전사 계열 첫 상품):** PRF_STK_TATTOO·COMP_STK_TATTOO은 디지털 공유 축
  (formula/·formula/digital-components)에도, 052 스티커 공유 후보(PRF_STK_FIXED/COMP_STK_PRINT)에도
  없다. companion에 상품-local mint하고 **needed_shared_nodes**로 반환(공유 파일 미수정).

## 옵션·제약·추가상품 (라이브 실측)
- **옵션그룹 1(용지·택1 선택):** 용지(OPT-000042·sel SEL_TYPE.01·min/max=0/1·**mand=N**·disp 1).
  1옵션값(OPV-000088 타투스티커·dflt=N)이 자재 MAT_000594를 가리킴(OPT_REF_DIM.03·ref_key1=MAT_000594·
  ref_key2=USAGE.07). 옵션=자재 BUNDLE(팩 §3.9). ★052(종이/인쇄/커팅 3그룹·전부 mand=Y)와 달리 067은
  **용지 1그룹만·필수 아님(mand=N)**·인쇄/커팅 옵션그룹 없음(단면 고정·커팅 무). 하위 노드=
  [[sticker-tattoo-nodes#옵션그룹-cpq]].
  - ★**옵션참조 정합(clean):** 옵션값이 067 활성 자재 MAT_000594(has_material 실재)를 가리킴 → 같은 부모
    차원에 실재(`fn_chk_opt_item_ref`·L-18 정합). 052 커팅 옵션의 매달린 참조 같은 결함 없음.
- **제약규칙:** `t_prd_product_constraints` = 067 행 **없음**(CPQ 제약 미등록·실측). 물리 제약 필요 여부는
  §31 제약 하네스 소관(현재 데모 미착수·GAP 아님).
- **추가상품:** `t_prd_product_addons` = 067 행 **없음**(실측).
- **셋트:** `t_prd_product_sets` = 067 부모/자식 행 **없음**(부품조립 셋트 아님·완제품 단일 SOT 정합).
  "3장세트"는 가격 번들이지 셋트 아님(위 정체 절).

## 승계·freshness 메모
- 정체·5분기·전사 계열·순수 인쇄물 = 팩 §3.1 FRESH 승계 + round-13 product-identity(승계·재검증
  2026-07-03·prd_typ은 live로 갱신). round-13 결함 상태값(T-6)·prd_typ .04(T-1)은 STALE 인용 금지.
- 완제품가 합가형 룩업·연당가 별개 축 = 팩 §3.10/§3.11/§4-B FRESH. COMP_STK_TATTOO=666행(3장세트)은
  팩 §3.11 실측과 일치(SIZ_000060 × 167·594 각 333행·전사표 권위).
- 자재 재키잉(MAT_000167→594 07-01)·판형 재키잉(SIZ_000060→SIZ_000050 06-30)·용지 옵션 신코드
  (OPT-000042/OPV-000088 07-01)는 live-snapshot 20260702_1119 실측(위키에 없던 신사실).
- **연당가 재적재(§4-D):** 067 소재(타투전용지/타투스티커)는 260702 substantive 연당가 변경 대상 아님
  (price-diff에 "타투" 0행). 팩 §4-A 돈-크리티컬 연당가 대개편은 **투명·홀로·크라프트·투명후지** 소재
  몫이라 067 밖(053 반칼투명·054 홀로 등·구체 연당가 수치는 전사표/§4-A 권위). ⇒ 067 완제품가
  retail 노드 dual 금지(false-defect 방지)·연당가 워크리스트는 [[gap-067-liandan-out-of-scope]]로 정직 지연.

---

> 상품 전용 하위 노드(카테고리 CAT_000311·사이즈·자재·수량·공식·구성요소·옵션그룹·GAP)는
> [[sticker-tattoo-nodes]] companion에 신설(052 방식·공유 axis/*·formula/*·rule/* 미수정).
> 공유 재사용 노드(category-CAT_000002·printopt-POPT_000001·plate-OUTPUT_PAPER_TYPE_03·RULE_*)는
> 중복 신설하지 않는다(L-3).
