---
id: sticker-spec-fancy
type: product
anchor: t_prd_products/PRD_000062
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000062 (반칼팬시스티커·prd_typ_cd=PRD_TYPE.01·use_yn=Y·del_yn=N·min_qty=8·qty_incr=8)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-sticker.md", source_locator: "§0~5 스티커 파일럿(정체·형상=size·완제품가·코팅 CONFLICT·연당가 §4)", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-sticker}
  - {source_file: "live-snapshot/latest/t_prd_product_price_formulas.csv", source_locator: "테이블:t_prd_product_price_formulas 키:(PRD_000062,PRF_STK_FIXED)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
relations:
  - {rel: in_category, target: category-CAT_000002, note: "스티커(main_cat_yn=Y·disp 12)"}
  - {rel: in_category, target: category-CAT_000037, note: "규격스티커(부·main_cat_yn=N·상위 CAT_000002)"}
  - {rel: has_size, target: size-SIZ_000059, note: "124x186(A5 4판)·dflt·가격격자 충전 180행"}
  - {rel: has_size, target: size-SIZ_000060, note: "90x190·dflt·가격격자 충전 180행"}
  - {rel: has_size, target: size-SIZ_000058, note: "100x140·dflt_yn=N·★COMP_STK_PRINT 0행(silent-0·[[sticker-spec-fancy#gap-062-siz058-price-missing]])"}
  - {rel: has_plate_size, target: plate-062-SIZ_000521, note: "330x470·OUTPUT_PAPER_TYPE.02(46계열)·종이류=점착지 판형 유효·fn_best_plate. SIZ_000200/201/202(파일사양)는 06-30 del_yn=Y"}
  - {rel: uses_material, target: material-MAT_000584, note: "유포스티커 80g·USAGE.07·MAT_TYPE.11"}
  - {rel: uses_material, target: material-MAT_000609, note: "미색스티커 모조 80g·USAGE.07"}
  - {rel: uses_material, target: material-MAT_000611, note: "아트스티커 90g·USAGE.07(07-01 재키잉 art-clone)"}
  - {rel: uses_material, target: material-MAT_000585, note: "무광코팅스티커·★코팅 CONFLICT(자재 vs 공정)"}
  - {rel: uses_material, target: material-MAT_000586, note: "유광코팅스티커·★코팅 CONFLICT"}
  - {rel: has_print_option, target: printopt-POPT_000001, note: "단면(front CLR_000005 4도·back CLR_000001 인쇄 안 함)·공유 축 재사용"}
  - {rel: has_process, target: process-PROC_000122, note: "반칼커팅(mand_proc_yn=N·상위 PROC_000121)·★상품명 '반칼'과 일치(059의 PROC_000055 불일치와 다름)"}
  - {rel: has_qty_rule, target: qty-062}
  - {rel: priced_by, target: formula-PRF_STK_FIXED, note: "스티커 완제품가 고정가 룩업(원자합산 아님)"}
  - {rel: has_option_group, target: optgroup-062-print, note: "인쇄=단면 도수(OPT-000040)"}
  - {rel: has_option_group, target: optgroup-062-paper, note: "용지=자재 5종(OPT-000041)·★ref_dim 미배선(circle와 다름)"}
props:
  prd_typ_cd: PRD_TYPE.01
  semi_role_cd: null
  file_upload_yn: Y
  editor_yn: Y
  min_qty: 8    # 전사표 권위(손전사 아님) <!-- lint-allow: L-12 src=SR-5-livesnap -->
  qty_incr: 8   # 전사표 권위 <!-- lint-allow: L-12 src=SR-5-livesnap -->
  qty_unit_typ_cd: QTY_UNIT.02
  use_yn: Y
  del_yn: N
  구분: "스티커(반칼·규격팬시·완제품 단일)"
  price_archetype: "완제품가 고정가 룩업(COMP_STK_PRINT·소재·규격·수량)"
  status_note: "라이브 출시(use_yn=Y)·07-01 대규모 재키잉(자재 variant·CPQ 그룹·공정 반칼커팅 교체)·수량/치수/격자 raw는 companion 전사표 권위"
standards: {schema_org: Product, xjdf: "Product(스티커)", config_ont: "component type"}
answers_cq: ["구체 상품 질의(반칼팬시스티커 구성·가격 경로)", "조건 탐색(팬시 자유형 스티커·코팅 선택)"]
tags: ["#스티커", "#반칼", "#규격팬시", "#완제품가고정가", "#코팅CONFLICT"]
updated: 2026-07-03
---

# sticker-spec-fancy 반칼팬시스티커 (PRD_000062)

반칼팬시스티커는 **완제품 단일**(`prd_typ_cd=PRD_TYPE.01`)이다. 점착지(유포/미색/아트/무광코팅/유광코팅)에
칼라 단면 인쇄 후 **반칼(Kiss Cut·`PROC_000122` 반칼커팅)** 으로 팬시(자유) 모양대로 칼집만 내는(백지 유지)
규격 family 스티커(카테고리 = 스티커 `CAT_000002`·규격스티커 `CAT_000037`). 파일 업로드 + 에디터 양쪽
(`file_upload_yn=Y·editor_yn=Y`) — 팬시 자유형상은 손님이 칼선을 업로드한다. 최소 8매·증분 8매(단위 QTY_UNIT.02
"매"). 수량·치수·가격격자 raw 값은 [[sticker-spec-fancy-nodes]] 전사표가 권위(스크립트 전사·손전사 금지·팩 §5-3).

★**스티커 파일럿의 3대 특성**(팩 §0)이 이 상품에 나타난다: ① **형상(팬시 칼틀)이 곧 사이즈**여야 하나 062는
형상을 **어디에도 저장하지 않는다**(사이즈=치수 격자·CPQ 커팅 그룹 없음·058 원형처럼 옵션값도 아님·순수
파일업로드 의존·모델 불일치 GAP-ST-3) ② **가격 = 완제품가(시트가격) 고정가 룩업**(원자합산 아님) ③ **코팅
자재 오적재 CONFLICT**(무광/유광코팅=자재 vs 공정)가 살아있다.

★**058(원형)과 다른 062 고유 사실:** 062는 07-01 재키잉에서 **공정을 `PROC_000122 반칼커팅`으로 교체**(구
`PROC_000055 스티커완칼` del_yn=Y) — 상품명 "반칼"과 공정명이 **일치**(059/규격 family가 겪은 명칭 불일치가
062에선 해소). 대신 **커팅 CPQ 그룹이 없고**(058은 OPT-000031 커팅 10값 보유), **용지 CPQ 그룹은 ref_dim
미배선**(058 종이 그룹은 자재 5값 ref_dim.03 배선). 사이즈도 A4/A5 시트가 아니라 **실치수 3종**(100x140·
124x186·90x190)이다. → 아래 각 절.

## 정체·유형 (SOT 준수)
- 상품유형 분류 SOT: **완제품(.01)** = 일반 단일 제조상품. 062는 `t_prd_product_sets` 부모/구성원 등록 없음
  (셋트 아님) → 일반 단일 완제품. 기성/디자인 아님(제조 상품). ★팩 §1.1·T-1: round-13 "전량 디자인상품(.04)"
  서술은 **STALE** — 라이브 재분류로 **PRD_TYPE.01(완제품)**이 현재값(SOT 정합·교정 완료).
- 카테고리 = 스티커(`CAT_000002` main) + 규격스티커(`CAT_000037` 부). 규격원형/정사각/직사각/띠지/팬시
  (058~062) 같은 family(팩 §3.2 GAP-ST-3). 062 = 팬시.

## 차원
- **사이즈:** t_prd_product_sizes active 3행 = **100x140(SIZ_000058·dflt_yn=N·판걸이 8)·124x186(SIZ_000059·
  dflt·판걸이 4)·90x190(SIZ_000060·dflt·판걸이 6)**. 058/059/060은 058(원형)의 A5/A4 시트 규격과 달리 **실치수
  격자 키**(가격표 "A5(4판)/124x186mm(4판)" 등 인코딩·companion 전사표). ★사이즈 노드 3종은 아무도 소유 안 함
  → 이 상품이 정의(공유 축 승격 후보·needed_shared_nodes). 판걸이수(UP수)는 사이즈의 파생값(`fn_calc_pansu`·
  [[rule/rules#RULE_pansu_db_function]]).
- **형상(팬시 칼틀):** 팬시(자유) 형상이 **size에도·CPQ 옵션에도·prcs_dtl_opt에도 저장 안 됨** — 058(원형=커팅
  옵션값)·066(형상=siz_nm)과 또 다른 모델. 062는 반칼커팅 공정 + **파일업로드**로 손님 칼선을 받는다(형상은
  업로드 파일에 인코딩)·[[sticker-spec-fancy#gap-062-shape-storage]]·팩 GAP-ST-3. 형상을 자재/옵션으로 오판 금지.
- **도수:** 인쇄옵션 코드값(칼라 단면 POPT_000001·공유 축 재사용). 도수는 색상코드가 아니다
  ([[rule/rules#RULE_dosu_is_printopt]]). 앞면 CLR_000005(CMYK 4도)·뒷면 CLR_000001(인쇄 안 함). 화이트
  underbase(PROC_000008)는 062 무관(불투명 규격·팩 §3.3).
- **수량규칙:** 제품 레벨 min 8·incr 8(QTY_UNIT.02). `t_prd_product_bundle_qtys` 062 행 **없음**(제품 레벨
  규칙만). 수량 UI 권위 = 제품/사이즈 수량규칙(가격구간과 역할 분리·팩 §3.4). 하위 [[sticker-spec-fancy#qty-062]].

## 자재·공정
- **자재:** active 5종 — 유포스티커 80g `MAT_000584`·미색스티커 모조 80g `MAT_000609`·아트스티커 90g `MAT_000611`·
  무광코팅스티커 `MAT_000585`·유광코팅스티커 `MAT_000586`. 전부 **MAT_TYPE.11(스티커용지)** = 정답
  (팩 §3.5 C-ST-09 "종이→스티커" 정정 완료). 07-01 재키잉으로 parent(153/242/155/156)는 junction del_yn=Y·
  child variant active([[rule/decisions#DEC_wiring_round22_260702]]·팩 §4-C). ★**비코팅스티커(MAT_000084)는
  062에서 제외**(junction del_yn=Y·child 미추가) — 058/059는 비코팅 보유했으나 062는 드롭. 자재 마스터 노드는
  형제 소유 공유노드([[sticker-spec-fancy-nodes]] 참조 목록). ★IMPORT 등록 자재 삭제 금지
  ([[rule/rules#RULE_import_material_no_delete]]).
  - ★**코팅 CONFLICT(BATCH-3·GAP-ST-1):** 무광/유광코팅스티커(585/586)는 라이브에서 **자재**(라미네이팅 내장
    스티커)로 적재됐으나 실무진 Q9 권위는 **코팅=공정 PROC_000013**. 가격표가 비코팅/무광/유광 3컬럼(코팅=가격축)
    이라 양립 곤란·미해소 → 단정 금지·[[sticker-spec-fancy#gap-062-coating-conflict]] 판단 보류(팩 §3.9·T-4).
- **공정:** active = **PROC_000122 반칼커팅**(상위 PROC_000121 커팅·mand_proc_yn=N) 1행. 삭제=PROC_000055
  스티커완칼(07-01). ★**base 인쇄 공정(PROC_000004) 없음** — 스티커는 완제품가 룩업(COMP_STK_PRINT에 출력+가공
  내장)이라 원자합산 base 인쇄 바인딩이 불필요(디지털인쇄와 다른 가격 모델·결함 아님·팩 §3.10·
  [[rule/rules#RULE_dataline_neq_wiring]] 반대사례). 공정 마스터는 형제 소유 공유노드(process-PROC_000122).

## 가격 경로 (D-18 경계 — 값은 evaluate_price 권위) — ★가격 경로 부분 연결(058은 silent-0)
- `sticker-spec-fancy --priced_by--> formula-PRF_STK_FIXED --has_component--> component-COMP_STK_PRINT`.
  공식/구성요소 노드는 형제 소유 공유노드([[formula-PRF_STK_FIXED]]·[[component-COMP_STK_PRINT]]·052 halfcut 소유).
  **고아 공식 아님**(has_component 1개)·**끊긴 가격 사슬 아님**(priced_by 1개).
- ★**완제품가(시트가격) 고정가 룩업**(원자합산형 아님·팩 §3.10). COMP_STK_PRINT use_dims=`[siz_cd, mat_cd, min_qty]`
  (PRICE_TYPE.01). 가격 = 형상×치수×코팅 격자이나 062는 (siz_cd, mat_cd, min_qty) 키 조회. 격자 충전 실측
  (companion 전사표): **SIZ_000059·060 = active 5소재 각 36행(각 180행) 충전(silent-0 아님)** · **★SIZ_000058
  (100x140) = COMP_STK_PRINT 0행**(전 comp 통틀어 0행·silent-0·미충전) → [[sticker-spec-fancy#gap-062-siz058-price-missing]].
  값 raw는 전사표 권위(손전사 금지).
- ★**소재 연당가(원자재 원가)는 이 완제품가 격자에 직접 없다**(팩 §4-B — COMP_PAPER에 스티커 mat_cd 0행·
  소재 마스터에 가격 컬럼 없음). 062의 완제품 retail 가격표는 260702에서 무변경 → 라이브=권위 일치. 판걸이수는
  DB 함수 계산([[rule/rules#RULE_pansu_db_function]]).
- 완제품가 절대값(예전사이트 골든)은 pcode 미상으로 미대조 → [[sticker-spec-fancy#gap-062-price-golden]] 정직 선언.

## 옵션·제약·추가상품
- **CPQ 옵션그룹(★부분 배선):** 07-01에 2 active 그룹 — **인쇄**(OPT-000040·단면 1값·OPT_REF_DIM.06 도수 참조
  배선됨)·**용지**(OPT-000041·자재 5값·★option_items 미보유=ref_dim 미배선). 058(원형)은 **커팅 그룹 보유+종이
  그룹 ref_dim.03 배선**이었으나 062는 **커팅 그룹 없음·용지 그룹 미배선** — CPQ 성숙도 058보다 낮음. 그룹 노드
  아래 절. 팩 §3.9 "CPQ 옵션 레이어 전면 미적재(BATCH-6)"는 062엔 **부분 반증**(인쇄 그룹 배선 실재).
- **제약규칙:** `t_prd_product_constraints` 062 행 **없음**(058은 RULE_001 보유). 코팅=자재 CONFLICT는 제약이
  아니라 모델링 갭([[sticker-spec-fancy#gap-062-coating-conflict]]).
- **추가상품:** `t_prd_product_addons` 062 행 1개 = **TMPL-000029 "OPP접착봉투 130x200 mm 50장"**(base_prd_cd=
  PRD_000001·06-30 등록). 팬시 스티커에 OPP 접착봉투를 추가상품으로 딸 수 있다. ★단 base 상품(PRD_000001
  OPP봉투)은 이 KB에 노드 미구축 → has_addon 엣지 미생성(끊긴 링크 회피)·prose 기록만(R14 template 접기·
  파일럿 후 승격 재검토). always-add 가드(팩 §3.12) 적용 대상.
- **셋트:** `t_prd_product_sets` 부모/구성원 아님(스티커팩 065만 세트·062 무관).

## 승계·freshness 메모
- 정체·형상=size·완제품가·코팅 CONFLICT 의미 = 팩 §0~5 FRESH 승계. round-13 "디자인상품(.04)"·"CPQ 전면
  미적재"류는 라이브 재분류/재키잉으로 재조준(T-1·T-6 오염 회피).
- 07-01 재키잉(자재 variant·CPQ 그룹·공정 반칼커팅 교체·판형 정리)은 위키에 없던 신사실 — live-snapshot +
  배선 HANDOFF round22 원장으로 재조준([[rule/decisions#DEC_wiring_round22_260702]]).
- ★연당가 양면(defect) 판단 = **062는 해당 없음**(아래 [[sticker-spec-fancy#gap-062-yeondangga]]): 260702
  연당가/국4절 변경은 투명/홀로/크라프트/투명후지 4소재 국한·062 소재(유포/미색/아트/코팅)는 **변경분 아님** →
  false-defect 방지 위해 dual 노드 미생성(팩 §4-D "retail 무변경 dual 금지" 정합).
- STALE 회피: price-engine-ddl 8차원(T-2)·constraint_json(T-3)·판수=앱계산(T-7)·구 연당가 무대조(T-8) 미인용.

---

## 이 상품 전용 하위 노드 (qty·CPQ·gap)

> 축 마스터 노드(사이즈·판형)는 [[sticker-spec-fancy-nodes]] companion에. 자재·공정·공식·구성요소·인쇄옵션·
> 카테고리는 형제 소유 공유노드(companion 참조 목록). 아래는 상품-local 수량규칙 + CPQ 옵션그룹 + 정직 GAP.

### [qty-062] 반칼팬시스티커 수량규칙 {verified}
- type: bundle_qty
- anchor: t_prd_products/PRD_000062
- src: {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000062 min_qty/qty_incr/qty_unit_typ_cd", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/_foundation/batch/qty_rule_audit_260702.py", source_locator: "수량 UI 권위=상품/사이즈 규칙(가격구간과 역할 분리)", captured_at: "2026-07-03", badge: verified, src_id: SR-27-qtyaudit}
- props: {min_incr_ref: "companion 전사표(상품 min 8·incr 8·단위 매)", bdl_unit_typ_cd: "QTY_UNIT.02", bundle_qtys_rows: 0}
- 본문: 수량 그릇 = 상품 마스터 컬럼(min 8·incr 8·단위 "매"). ★058(min 4)과 달리 062는 **min/incr 8** — 팬시 사이즈별 판걸이(4~8판) 반영 추정(단정 금지). `t_prd_product_bundle_qtys` 0행은 정상(수량 UI 권위=상품/사이즈 규칙·팩 §3.4). 사이즈별 수량규칙은 companion 전사표 판걸이 note 참조.

### [optgroup-062-print] 인쇄 (도수) {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000062
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "테이블:t_prd_product_option_groups 키:(PRD_000062,OPT-000040) 인쇄·mand_yn=N·del_yn=N·disp 1", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_option_items.csv", source_locator: "테이블:t_prd_product_option_items 키:(PRD_000062,OPV-000087) ref_dim_cd=OPT_REF_DIM.06(도수)·ref_key1=1", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {sel_typ_cd: "(SEL_TYPE 미기재·미명시)", opt_values: 1, note: "단면(OPV-000087)·OPT_REF_DIM.06 도수 참조(ref_key1=1=인쇄옵션 opt_id 1)"}
- rel: {rel: option_refs, target: printopt-POPT_000001, ref_key1: "1", note: "도수 옵션값→인쇄옵션 차원(단면·공유 축)·fn_chk_opt_item_ref 정합(부모 062 has_print_option 실재)"}
- 본문: 인쇄 그룹은 단면 1값(도수 축·OPT_REF_DIM.06). 옵션참조 타깃=공유 인쇄옵션 printopt-POPT_000001(부모 062 has_print_option에 실재 → L-18 통과).

### [optgroup-062-paper] 용지 (자재 — ★ref_dim 미배선) {candidate}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000062
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "테이블:t_prd_product_option_groups 키:(PRD_000062,OPT-000041) 용지·mand_yn=N·del_yn=N·disp 2", captured_at: "live 20260702_1119", badge: candidate, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_options.csv", source_locator: "테이블:t_prd_product_options 그룹 OPT-000041 옵션값 5개(OPV-000082~086·유포/미색/아트/무광코팅/유광코팅)", captured_at: "live 20260702_1119", badge: candidate, src_id: SR-5-livesnap}
- props: {sel_typ_cd: "(미명시)", opt_values: 5, note: "★용지 5옵션(유포/미색/아트/무광코팅/유광코팅)이 자재명과 일치하나 t_prd_product_option_items에 행 0개=ref_dim_cd 미배선 → 옵션→자재 차원 미참조(058 종이 그룹은 OPT_REF_DIM.03 배선). 옵션 선택이 자재 차원을 구동하는지 미완·badge=candidate"}
- 본문: 용지 그룹은 자재 5종을 옵션값으로 노출하나 **option_items(ref_dim) 미배선** — 058(원형)의 종이 그룹이 OPT_REF_DIM.03로 5자재를 참조한 것과 달리 062는 참조 링크가 없다. 손님이 용지를 골라도 자재 차원(mat_cd)으로 환원되는 경로가 라이브에 미형성 → [[sticker-spec-fancy#gap-062-paper-unwired]]. option_refs 엣지 미생성(참조 대상 item 부재·L-18 대상 아님). 무광/유광코팅이 '용지' 축에 노출됨 = 코팅 CONFLICT 당사이기도([[sticker-spec-fancy#gap-062-coating-conflict]]) → badge=candidate.

### [gap-062-siz058-price-missing] SIZ_000058(100x140) 완제품가 격자 부재 (silent-0) {unknown}
- type: gap
- anchor: none  # 사유: 062 active 사이즈 SIZ_000058(100x140)이 t_prd_product_sizes엔 실재하나 COMP_STK_PRINT(및 전 comp)에 단가행 0개 — 손님이 100x140 선택 시 가격 룩업 실패(silent-0)
- src: {source_file: "live-snapshot/latest/t_prc_component_prices.csv", source_locator: "테이블:t_prc_component_prices $4==SIZ_000058 전 comp 0행(awk 실측·전사표)·SIZ_000059/060은 각 180행 충전", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/_meta/scripts/transcribe_sticker_fancy_062.py", source_locator: "가격격자 충전표(SIZ_000058=0행 silent-0·059/060=180행)", captured_at: "2026-07-03", badge: unknown, src_id: SR-5-livesnap}
- gap_what: "062 사이즈 SIZ_000058(100x140)이 제품 사이즈로 활성(del_yn=N·disp 2)이나 COMP_STK_PRINT 완제품가 격자에 단가행 0개(059=124x186·060=90x190은 각 180행 충전). 100x140 선택 시 가격 0/미산정(silent-0)"
- gap_fill_from: "가격표(price-sticker L1) 100x140 행 존재 여부 확인 → 있으면 §7 dbmap 격자 충전 COMMIT(059/060과 동형 5소재×수량구간), 없으면 SIZ_000058 판매중지/제거 판정(실무진). 인간 승인 후"
- gap_owner: staff
- rel: {rel: references, target: size-SIZ_000058, note: "격자 미충전 사이즈"}
- rel: {rel: references, target: component-COMP_STK_PRINT, note: "완제품가 격자에 이 사이즈 단가행 부재"}
- 본문: 062 고유 실측 결함. 059(124x186)·060(90x190)은 격자 충전됐으나 058(100x140)만 COMP_STK_PRINT에 단가행 0 → silent-0(가격 0/미산정 신호). 지어내지 않고 GAP으로 등재(전사표 실측). 값 채움은 가격표 대조 후 §7 소관.

### [gap-062-paper-unwired] 용지 옵션그룹 ref_dim 미배선 {unknown}
- type: gap
- anchor: none  # 사유: OPT-000041 용지 그룹의 5옵션(OPV-000082~086)이 t_prd_product_option_items에 행 0개 — 옵션→자재(mat_cd) 참조가 라이브에 미형성(058은 OPT_REF_DIM.03 배선)
- src: {source_file: "live-snapshot/latest/t_prd_product_option_items.csv", source_locator: "테이블:t_prd_product_option_items PRD_000062 = OPV-000087(인쇄) 1행뿐·OPV-000082~086(용지) 0행", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- gap_what: "용지 CPQ 그룹(OPT-000041) 5옵션이 자재명(유포/미색/아트/무광/유광)과 일치하나 ref_dim_cd 미배선 → 손님 용지 선택이 자재 차원(mat_cd)으로 환원 안 됨. 058(원형)은 OPT_REF_DIM.03로 동일 5자재 참조 배선됨(대조군)"
- gap_fill_from: "058 종이 그룹 배선(OPV→OPT_REF_DIM.03→MAT_000584/609/611/585/586)을 062 용지 그룹에 동형 적용(§7 dbmap·CPQ 옵션 매핑). fn_chk_opt_item_ref 정합(부모 062 uses_material 5종 실재→통과 예상). 인간 승인 후"
- gap_owner: staff
- rel: {rel: references, target: optgroup-062-paper, note: "ref_dim 미배선 옵션그룹"}
- 본문: 062 CPQ 성숙도가 058보다 낮은 지점. 인쇄 그룹은 배선(OPT_REF_DIM.06)이나 용지 그룹은 옵션값만 있고 자재 참조 링크 부재. 옵션 선택→차원 환원 경로가 끊김. 형제 058이 동형 배선의 정답 형태.

### [gap-062-shape-storage] 팬시 형상 저장처 부재 (GAP-ST-3) {unknown}
- type: gap
- anchor: none  # 사유: 062 팬시(자유) 형상이 size·CPQ 옵션·prcs_dtl_opt 어디에도 저장 안 됨 — 058(형상=커팅 옵션값)·066(형상=siz_nm)과 또 다른 모델(파일업로드 의존)
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-sticker.md", source_locator: "§3.2 GAP-ST-3(규격형 058~062 형상 저장처·F-ST-5·C-ST-06·Q-ST-C)", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-sticker}
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "테이블:t_prd_product_option_groups PRD_000062 = 인쇄/용지 2그룹뿐(커팅 그룹 없음)·file_upload_yn=Y", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- gap_what: "062 반칼팬시의 팬시(자유) 칼틀 형상이 size(치수 3종=100x140/124x186/90x190·형상 아님)·CPQ 옵션(커팅 그룹 없음)·prcs_dtl_opt(PROC_000122 param 없음) 어디에도 저장 안 됨. 손님 칼선은 file_upload로 받음(형상=업로드 파일 인코딩). 058(형상=커팅 옵션값 10개)·066(형상=siz_nm)과 family 내 모델 3중 불일치"
- gap_fill_from: "실무진(Q-ST-C) — 규격 family 형상 저장 모델 통일(size vs 옵션값 vs 공정 param vs 파일업로드). 062는 자유형이라 파일업로드가 정당할 수 있음(단정 금지)"
- gap_owner: staff
- rel: {rel: references, target: process-PROC_000122, note: "형상을 실현하는 반칼커팅 공정(param 없음)"}
- 본문: 팩 GAP-ST-3의 062 실측 = 형상이 어디에도 리터럴 저장 안 됨(자유형=파일업로드). 058(옵션값)·066(siz_nm)과 또 다른 3번째 모델. 라이브 사실(커팅 그룹 부재·file_upload_yn=Y·PROC_000122)은 기록, 해소 방향은 지어내지 않음.

### [gap-062-coating-conflict] 코팅=자재 vs 공정 CONFLICT (BATCH-3·GAP-ST-1) {unknown}
- type: gap
- anchor: none  # 사유: 라이브=자재(MAT_000585/586 스티커 variant) vs Q9 권위=공정(PROC_000013) vs 가격표 3컬럼(코팅=가격축) — 3원천 양립 곤란·미해소(BATCH-3)
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-sticker.md", source_locator: "§3.9 코팅 CONFLICT(BATCH-3·GAP-ST-1)·T-4(단정 금지)", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-sticker}
- gap_what: "무광/유광코팅스티커(MAT_000585/586)의 코팅 모델링 — 라이브=자재(라미네이팅 내장), 실무진 Q9=공정(PROC_000013), 가격표=비코팅/무광/유광 3컬럼(코팅=가격축). 어느 것이 정답인지 미확정. 062는 용지 CPQ 그룹에도 코팅 2값 노출"
- gap_fill_from: "실무진(Q-ST-A) 확인 + §31 제약/§7 자재 모델 결정 — 코팅=공정 통일 시 585/586 자재 은퇴+공정 바인딩"
- gap_owner: staff
- rel: {rel: references, target: material-MAT_000585, note: "코팅 CONFLICT 당사 자재(형제 소유 공유노드)"}
- rel: {rel: references, target: material-MAT_000586, note: "코팅 CONFLICT 당사 자재(형제 소유 공유노드)"}
- 본문: 코팅을 자재로 볼지 공정으로 볼지 3원천이 엇갈린다(팩 §3.9). KB는 양쪽 실재를 기록하되 단정하지 않음(T-4). 양면 노드가 아니라 GAP인 이유 = "현재값 vs 정답"의 정답이 아직 확정 안 됨(권위 미결). 062는 이 CONFLICT의 살아있는 사례(무광/유광 자재+용지옵션 노출).

### [gap-062-yeondangga] 소재 연당가 저장처 부재 (062 소재는 260702 변경분 아님) {unknown}
- type: gap
- anchor: none  # 사유: 스티커 소재 연당가(원자재 원가)가 라이브 어디에도 가격노드로 저장 안 됨(§4-B systemic) — 단 062 소재는 260702 연당가 변경 4소재에 미포함(dual 불요)
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-sticker.md", source_locator: "§4-B(연당가 저장처 부재)·§4-A(변경 4소재=투명/홀로/크라프트/투명후지)·§4-D(retail 무변경 dual 금지)", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-sticker}
- gap_what: "스티커 소재 연당가(원자재 원가)가 t_mat_materials(가격 컬럼 없음)·COMP_PAPER(스티커 mat_cd 0행) 어디에도 저장 안 됨(systemic·§4-B). 062 소재(유포/미색/아트/무광코팅/유광코팅)는 260702 연당가 변경 4소재(투명 백색후지/홀로그램/크라프트/투명후지)에 미포함 → 062 자체는 양면(defect) 노드 불요"
- gap_fill_from: "연당가 저장처 신설·재적재 워크리스트 owner = 투명(053/056/063)·홀로(054) 소재 상품 노드 양면 defect + 크라프트는 라이브 상품 미사용이라 axis material-MAT_000164 양면 노드(owner). 062는 retail 완제품가(무변경)로 가격 성립(SIZ_000058 격자 부재는 별개 GAP) → 062 연당가 dual 불필요(실무진+인간 승인·팩 §4-D)"
- gap_owner: staff
- rel: {rel: references, target: component-COMP_STK_PRINT, note: "062 가격은 완제품가 격자로 성립(연당가 원가 미참조)"}
- rel: {rel: references, target: material-MAT_000164, note: "크라프트 연당가 재적재 owner(라이브 상품 미사용→axis 소유·허위 위임 교정 D-STK-01)"}
- 본문: ★연당가 양면 노드 판정 = **062는 FALSE(dual 불요)**. 근거(팩 §4-A 전사 diff): 260702 연당가/국4절 급변은 투명스·홀로·크라프트·투명후지 4소재 국한 — 062 소재는 무변경. 완제품 retail 가격표도 무변경(팩 §4-D) → false-defect 방지 위해 dual 노드 미생성. 단 "연당가 저장처 부재" systemic 이슈는 스티커 전반에 열림(GAP).

### [gap-062-price-golden] 완제품가 절대값 골든 미검증 {unknown}
- type: gap
- anchor: none  # 사유: COMP_STK_PRINT 격자 충전(059/060)은 확정이나 예전사이트 절대값 골든이 pcode 미상으로 미대조(058/023/051과 동류)
- src: {source_file: "live-snapshot/latest/t_prc_component_prices.csv", source_locator: "테이블:t_prc_component_prices COMP_STK_PRINT 062 059/060 격자 충전 실재(전사표)·절대값 골든 pcode 미상", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- gap_what: "062 완제품가(COMP_STK_PRINT·소재×규격×수량) 059/060 격자 충전은 실측 확인되나, 예전사이트 견적 절대값(골든)과의 대조가 pcode 미상으로 미검증"
- gap_fill_from: "pcode(예전사이트 상품코드) 매핑 후 골든 대조 — 개발팀/§26 소관"
- gap_owner: 개발
- rel: {rel: references, target: formula-PRF_STK_FIXED, note: "이 공식의 완제품가 골든 미검증"}
- 본문: 059/060 격자 실재(silent-0 아님)로 가격 계산 가능성은 확인. 058은 격자 부재(별개 GAP). 절대값 정답 대조는 대기(형제 [[sticker-spec-circle#gap-058-price-golden]]와 동류·지어내지 않고 정직 선언).
