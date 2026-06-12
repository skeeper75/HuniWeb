# sticker(스티커) 레시피  {전체상태: 🟡}

> 조립 뷰. 횡단 사실은 축 페이지(`huni/<axis>.md`) 원자 항목을 `[[링크]] + 관계동사`로 참조만 하고 본문 복붙하지 않는다(README §3·§9). 레시피 고유 사실(스티커 16상품 목록·교정대기 행)만 본문 원자 블록.
> 큐레이션 팩: `_curation/pack-sticker.md`(1차 권위). round-13 게이트 GO(K0~K6 PASS·dodge-hunt 실결함 0).
> **STALE/v03 인용 0**: 가격엔진 ddl·v03 입력 xlsx·constraint_json·dep_proc_cd 인용 금지(축 STALE 블록 참조). 라이브 오적재는 7절 양면 표기.

## CQ 헤더 (이 페이지가 답하는 질문)
- 스티커는 무엇인가(16상품·인쇄방식 5분기) / 어떤 차원·옵션(형상=칼틀 size·조각수·코팅·화이트)이 있는가
- 가격은 어떻게 계산되는가(형상×치수×코팅 격자) / DB에 어떻게 등록하는가
- 현재 라이브 적재 상태·교정 대기(코팅 자재 오적재·카테고리 거침·063 화이트 누락 등)는 무엇인가
- 미결: 코팅=공정 통일(BATCH-3)·조각수 저장처(OM-7)·규격형 형상 저장처

---

## 0. 정체 (identity) — 스티커  앵커: t_prd_products · t_cat_categories

### [STK-ID-001] 스티커 = 16상품·단일 카테고리·인쇄방식 5분기  {✅}
- 내용: 스티커 시트 = **16 distinct 상품**(라이브 `PRD_000052`~`PRD_000067`, L1 154 데이터행 = 형상/사이즈×자재 variant 평면화). 전부 **일반 인쇄물(스티커)·단품**(스티커팩 065만 세트). 1차 분기축 = `파일사양_폴더`(C13) 인쇄방식 5종: 디지털인쇄·실사출력·화이트인쇄·합판인쇄·전사인쇄. **정체 오분류 0**(비전형 상품 없음 — 굿즈파우치/배경지와 달리 전부 명백한 스티커). 라이브 전수 `prd_typ_cd=PRD_TYPE.04(디자인상품)`·`MES_ITEM_CD=NULL`.
- 앵커: `t_prd_products`(PRD_000052~067) · `t_cat_categories`
- 출처: `17_correctness/sticker/product-identity.md` §0·§1 (라이브 read-only psql 재현) {tier C13, FRESH}
- 연결: [[../base/printing-methods#3-방식-선택을-가르는-변수]] (uses — 인쇄방식 보편) · [[load-path#LP-GAP-3]] (카테고리 고아 재연결 미적재)
- answers_cq: CQ-PROD-01 (상품 분류) · CQ-PROD-03 (완제품 귀속)
- tags: #스티커 #정체 #16상품 #인쇄방식5분기

### [STK-ID-002] 16상품 prd_cd 목록 (인쇄방식별)  {✅}
- 내용: **디지털인쇄**(토너 PROC_000004): 반칼자유형 052·투명 053·홀로그램 054·규격원형 058·정사각 059·직사각 060·띠지 061·팬시 062·팬시투명 063·소량 064·스티커팩 065. **실사출력**(잉크젯 PROC_000006): 낱장자유형 055·대형자유형 057. **화이트인쇄**(디지털+화이트): 낱장자유형 투명 056. **합판인쇄**: 합판도무송 066. **전사인쇄**(열전사): 타투 067. 라이브 비활성: 063·064 `use_yn=N`. 파일업로드 예외: 스티커팩 065 `file_upload_yn=N`.
- 앵커: `t_prd_products`(052~067) · `t_prd_product_processes`(인쇄방식 root 공정)
- 출처: `17_correctness/sticker/product-identity.md` §0 표·§1 정체표(product-bom §1~16 정체출처) {tier C13, FRESH}
- 연결: [[#STK-BOM-001]] (uses — 커팅 공정) · [[#STK-ID-001]]
- answers_cq: CQ-PROD-01 (상품 분류)
- tags: #스티커 #prd_cd목록 #인쇄방식

---

## 1. 차원 (dimensions) — 스티커  앵커: t_prd_product_sizes/bundle_qtys/sets · t_siz_sizes

### [STK-DIM-001] 형상 = 칼틀(size) 1:1 — 합판도무송 066  {✅}
- 내용: 합판도무송(066)은 **형상=칼틀을 size(`siz_nm`)로 흡수**(원형/정사각/직사각류 37행, 예 `정사각30x30mm(2EA)`). 가격표가 형상별 가격 격자([[#STK-PRC-001]])라 size 유지가 정답(Q7 실무진 확정). round-11 "형상 size 흡수=오모델 의심" 가설은 **반증·철회**(round-13 CORRECT C-ST-03). 형상을 자재/옵션으로 오판 금지.
- 앵커: `t_prd_product_sizes` · `t_siz_sizes`(siz_nm에 형상+치수 인코딩)
- 출처: `17_correctness/sticker/correction-manifest.md` C-ST-03 + `16_mapping-research/sticker/live-crosscheck.md` §5 (Q7 종결) {tier C13/C12, FRESH}
- 연결: [[../base/sizes#BSZ-003]] (uses — 출력판형/규격 보편) · [[#STK-DIM-002]] (규격형 형상은 미해결)
- answers_cq: CQ-PROD-06 (variant 형상 → 차원 분해)
- tags: #스티커 #형상 #칼틀 #size #Q7

### [STK-DIM-002] 묶음수·조각수 = 부분 GAP (066만 적재)  {🟡}
- 내용: L1 `조각수(옵션)`(C25)에 `*최대20조각`·`5~10조각`·`*1조각` 등 실재하나, 라이브 `t_prd_product_bundle_qtys`는 **합판도무송 066만 5행**(형상별 EA), 나머지 15상품 0행. Q8★ = 묶음수(권/세트 기준) + 조각수(판당 개수+제한) **둘 다** 기록이 정답이나, 조각수의 공정 param 저장처(`prcs_dtl_opt.조각수`)가 스키마에 부재(OM-7) → 미실현. 판수(판걸이수)는 [[price-engine#PE-010]] **앱 계산**(DB 미저장 — 입력=판형 인쇄가능영역+작업사이즈). 판수축 해법은 bundle_qty 칸이 아니다(메모리 정정).
- 앵커: `t_prd_product_bundle_qtys`(066만) · prcs_dtl_opt.조각수(저장처 GAP)
- 출처: `17_correctness/sticker/correction-manifest.md` C-ST-05 + `16_mapping-research/sticker/mapping-final.md` L47(Q8) {tier C13/C12, FRESH}
- 연결: [[price-engine#PE-010]] (uses — 판수=앱 계산) · [[cpq-options#CPQ-GAP-2]] (requires — ref_param_json 미구현) · [[#STK-ST-005]] (교정대기)
- answers_cq: CQ-PRICE-10 (판걸이수 영향)
- tags: #스티커 #조각수 #묶음수 #OM-7 #부분GAP

---

## 2. 자재·공정 BOM — 스티커  앵커: t_prd_product_materials/processes · t_mat_materials · t_proc_processes

### [STK-BOM-001] 커팅 공정 = 스티커 정체 (반칼/완칼/스티커완칼)  {✅}
- 내용: 스티커 정체 공정 = **커팅**(반칼 Kiss Cut `PROC_000054`[모양 input+조각수]·완칼 Die Cut·스티커완칼 `PROC_000055`[조각수만]). 디지털=반칼·실사/화이트=완칼·합판=도무송(스티커완칼). 타투(067)·스티커팩(065)은 커팅 없음(공정 0행). 순수공정 패턴([[processes#PRC-004]]) — 부착 자재 없음.
- 앵커: `t_prd_product_processes`(PROC_000054/000055) · `t_proc_processes`
- 출처: `17_correctness/sticker/product-identity.md` §1·`loadlogic-notes.md` §1(커팅 C24) + `_gate/sticker-gate.md` K6(PROC_000054 모양 input 실측) {tier C13, FRESH}
- 연결: [[processes#PRC-001]] (uses — 공정 마스터·연결 구조) · [[processes#PRC-004]] (uses — 순수공정=자재없음) · [[../base/finishing#BFN-001]] (uses — 후가공 보편)
- answers_cq: CQ-PROC-01 (공정 라우트)
- tags: #스티커 #커팅 #반칼 #완칼 #도무송

### [STK-BOM-002] 화이트 underbase = 공정 (투명/홀로그램 베이스)  {✅}
- 내용: 화이트 underbase(`PROC_000008`)는 투명/홀로그램 베이스 스티커에 **도메인 필수**(투명 위 인쇄 가시화). 별색/화이트는 **도수가 아니라 공정**([[processes#PRC-003]]) — `print_side` 슬롯이 아니다. 라이브 정합 = 053·054·056 연결(CORRECT C-ST-14). **단 063(반칼팬시투명)에 누락**(교정대기 [[#STK-ST-003]]).
- 앵커: `t_prd_product_processes`(PROC_000008 화이트, clr_cd=NULL) · `t_proc_processes`
- 출처: `17_correctness/sticker/correction-manifest.md` C-ST-14(CORRECT)·C-ST-07(063 누락) {tier C13, FRESH}
- 연결: [[processes#PRC-003]] (uses — 별색=공정·clr_cd=NULL) · [[../base/color#BCL-003]] (uses — 별색 보편) · [[#STK-ST-003]]
- answers_cq: CQ-FIN-03 (별색인쇄 용도)
- tags: #스티커 #화이트 #underbase #별색공정

### [STK-BOM-003] 자재 = 점착지 (parent + usage_cd, MAT_TYPE.11)  {🟡}
- 내용: 스티커 자재 = 점착지(유포·코팅·투명·홀로그램·데드롱). 자재 모델은 [[materials#MAT-002]] **parent + usage_cd**(낱장은 단일축). 정답 자재유형 = **MAT_TYPE.11(스티커)**. 단 라이브는 일부 점착지가 .01(종이)로 혼재 적재([[#STK-ST-004]] 교정대기). 코팅은 자재가 아니라 공정([[#STK-ST-001]] CONFLICT 미결).
- 앵커: `t_mat_materials`(mat_typ_cd .11) · `t_prd_product_materials`(mat_cd+usage_cd)
- 출처: `17_correctness/sticker/correction-manifest.md` C-ST-09 + `loadlogic-notes.md` L-ST-F {tier C13, FRESH}
- 연결: [[materials#MAT-001]] (uses — 자재 마스터 구조) · [[materials#MAT-002]] (uses — parent+usage_cd) · [[materials#MAT-003]] (uses — MAT_TYPE 코드도메인) · [[#STK-ST-004]]
- answers_cq: CQ-PROD-05 (자재 축) · CQ-TERM-04 (소재 약어)
- tags: #스티커 #자재 #점착지 #MAT_TYPE11

---

## 3. 가격 사슬 (price chain) — 스티커  앵커: t_prc_* 4단 + t_dsc_*

### [STK-PRC-001] 가격 = 형상×치수×코팅 격자 (가격표 권위)  {🟡}
- 내용: 스티커 가격 = **형상+치수(=사이즈)별 가격 격자**, 코팅(비코팅/무광/유광)이 **가격 컬럼 축**(합판도무송 가격표 505행 실측: `원형 10mm > 비코팅/무광코팅/유광코팅` 밴드). 면적만이 아닌 형상별 격자라 [[price-engine#PE-007]] **고정가형(수량×옵션 격자)** 룩업에 정합(`t_prc_component_prices`). 가격원 = `price-sticker-price-l1.csv`·`price-gangpan-sticker-l1.csv`(L1 FRESH). 코팅이 가격 변수축인 점이 코팅=공정 단가 CONFLICT([[#STK-ST-001]])와 얽힘.
- 앵커: `t_prc_component_prices`(형상×치수×코팅 격자) · `t_prc_price_components`
- 출처: `16_mapping-research/sticker/live-crosscheck.md` §5(Q7 C3 가격표 실측) + `06_extract/price-{sticker-price,gangpan-sticker}-l1.csv` {tier C12/B, FRESH}
- 연결: [[price-engine#PE-007]] (priced-by — 고정가형 격자) · [[price-engine#PE-001]] (uses — t_prc_* 4단) · [[#STK-PRC-002]]
- answers_cq: CQ-PRICE-01 (단가표 vs 공식) · CQ-PRICE-05 (면적/격자 계산)
- tags: #스티커 #가격 #형상치수코팅격자 #고정가형

### [STK-PRC-002] 가격 차원 컬럼·단가유형 = 라이브 실측 권위  {🟡}
- 내용: 가격 차원의 라이브 실재 위치 = `t_prc_component_prices`(siz_cd·proc_cd·opt_cd) + 단가유형 `t_prc_price_components.prc_typ_cd`(현 라이브 전부 .01 단가형). **`pricing_dims`/`use_dims`는 라이브 테이블 아님·`price-engine-ddl.md`는 STALE — 인용 금지**([[price-engine#PE-STALE]]). 가격공식 멱등 PK = (prd_cd, apply_bgn_ymd)([[price-engine#PE-003]]).
- 앵커: `t_prc_component_prices`(차원 컬럼) · `t_prc_price_components.prc_typ_cd`
- 출처: 라이브 psql `information_schema`(price-engine 축 [PE-001~003] 경유) + `18_schema-change/impact-diagnosis.md` I-1·I-2 {tier A, FRESH}
- 연결: [[price-engine#PE-001]] (uses — 차원 8/10컬럼·W3) · [[price-engine#PE-002]] (uses — 단가유형) · [[price-engine#PE-STALE]] (STALE 금지)
- answers_cq: CQ-PRICE-08 (견적 합산)
- tags: #스티커 #가격차원 #prc_typ_cd #W3

---

## 4. CPQ 옵션 레이어 — 스티커  앵커: t_prd_product_option_groups/options/option_items · constraints · templates

### [STK-CPQ-001] 옵션축(코팅·화이트·조각수·형상) → 4엔티티 매핑  {🟡}
- 내용: 스티커 옵션성 축(코팅·화이트 별색·조각수·규격형 형상)은 [[cpq-options#CPQ-004]] **속성→4엔티티 지도**로 분기: 화이트/커팅=공정(L1)·자재=mat_cd+usage·형상=size(066)·조각수=bundle_qty+param. `option_items`는 polymorphic `ref_dim_cd`로 L1 차원행 참조([[cpq-options#CPQ-002]]), 무결성은 트리거 `fn_chk_opt_item_ref`([[cpq-options#CPQ-003]])가 강제 → 차원행 선적재 필수. **단 스티커 CPQ 레이어 전면 미적재**([[#STK-ST-006]]).
- 앵커: `t_prd_product_option_items.ref_dim_cd` · `t_prd_product_option_groups`
- 출처: `16_mapping-research/sticker/mapping-final.md`(속성→엔티티) + `10_configurator/attribute-entity-map.md`(축 CPQ-004 경유) {tier C12/C, FRESH(매핑)·PARTIAL-STALE(I-5·I-9)}
- 연결: [[cpq-options#CPQ-004]] (uses — 속성→4엔티티) · [[cpq-options#CPQ-002]] (uses — polymorphic ref_dim_cd) · [[cpq-options#CPQ-003]] (requires — 무결성 트리거) · [[#STK-ST-006]]
- answers_cq: CQ-PROD-05 (옵션 축·캐스케이드)
- tags: #스티커 #CPQ #속성매핑 #4엔티티

### [STK-CPQ-002] 제약 = constraints.logic 단일경로 (constraint_json STALE)  {🟡}
- 내용: 스티커 캐스케이드 제약(예: 투명 베이스 → 화이트 underbase requires)은 [[cpq-options#CPQ-007]] **`t_prd_product_constraints.logic`(JSONLogic) 단일경로**로 표현한다. **`constraint_json` 컬럼은 삭제됨 — 인용 금지**([[cpq-options#CPQ-STALE]]). RULE_TYPE는 금지+필수동반 2종만. 공정 택일그룹 전용 테이블(`excl_groups`)도 라이브 부존재([[processes#PRC-GAP-5]]) — 배타는 `mand_proc_yn` 또는 constraints.logic.
- 앵커: `t_prd_product_constraints.logic`(JSONLogic, NOT NULL)
- 출처: `10_configurator/attribute-entity-map.md`(축 CPQ-007 경유) + `18_schema-change/impact-diagnosis.md` I-5 {tier A/C, FRESH}
- 연결: [[cpq-options#CPQ-007]] (uses — constraints.logic) · [[cpq-options#CPQ-STALE]] (STALE 금지) · [[processes#PRC-GAP-5]] (excl_groups 부재)
- answers_cq: CQ-PROC-05 (공정 선행 종속)
- tags: #스티커 #제약 #constraints.logic #STALE금지

---

## 5. 위젯 계약 (widget contract) — 스티커  앵커: 정규화 계약(huni-widget 03_spec) — DB 외 앵커

### [STK-WID-001] 위젯은 정규화 계약 의존 (DB 독립·어댑터 경계)  {⚪}
- 내용: 스티커 위젯은 후니 DB 스키마가 아닌 **정규화 데이터 계약**(상품·옵션·가격 안정 shape)에 의존([[widget-contract#WID-001]]). 옵션축(형상·코팅·화이트·조각수)→14 componentType→shadcn 매핑([[widget-contract#WID-003]]). DB 확정 시 후니 어댑터만 교체([[widget-contract#WID-002]]) → 위젯 코어 불변. 단 `huni-db-mapping.md` 후니 t_* 매핑은 PARTIAL-STALE(라이브 스키마 대조 필요).
- 앵커: DB 외 — `huni-widget/03_spec/data-contract.md`(어댑터 경계에서 t_*로)
- 출처: `huni-widget/03_spec/data-contract.md`(축 WID-001 경유) {tier D, FRESH}
- 연결: [[widget-contract#WID-001]] (mapped-to — 정규화 계약) · [[widget-contract#WID-002]] (mapped-to — 어댑터) · [[widget-contract#WID-003]] (mapped-to — componentType)
- answers_cq: CQ-PROD-05 (옵션 축 shape) · CQ-PROD-08 (UI 노출)
- tags: #스티커 #위젯 #정규화계약 #DB독립

### [STK-WID-002] 가격 권위 = 서버 (PRICE=0 불가 신호)  {⚪}
- 내용: 스티커 위젯 가격은 **서버 권위 + 클라 캐싱**([[widget-contract#WID-005]]). 후니 가격은 가격엔진 축([[price-engine#PE-001]]) 권위. RedPrinting PRICE=0은 절대 불가 — 0은 우리측 요청/세션 결함 신호(Red 역산값 후니 이식 금지).
- 앵커: DB 외 — 서버 가격 API(후니 가격=t_prc_*)
- 출처: `huni-widget/03_spec/price-engine.md`(축 WID-005 경유) {tier D, FRESH(후보)}
- 연결: [[widget-contract#WID-005]] (priced-by — 서버 가격권위) · [[price-engine#PE-001]] (priced-by — 후니 가격) · [[widget-contract#WID-STALE]]
- answers_cq: CQ-PRICE-01 (가격 권위=서버)
- tags: #스티커 #위젯 #가격권위 #PRICE0불가

---

## 6. 적재 레시피 (load path) — 스티커  앵커: raw/webadmin sql/tools · round-8 admin-ui-spec

### [STK-LP-001] 적재 oracle = load_master(v03 전파기) · 진원=상류 v03  {🟡}
- 내용: 스티커 라이브 값 = `tools/load_master.py`가 v03 통합시트(05_자재·06_공정·10_상품·14_상품별자재·15_상품별공정 등)를 전 상품 공통 처리한 직접 결과(스티커 전용 분기 없음). **load_master는 v03 전파기** — 라이브 결함 8건 중 5건이 상류 v03 정규화 결함(코팅·조각수·063화이트·카테고리·자재유형/명), load_master 코드 결함은 1건(MES NULL 의도)뿐. **[HARD] v03 입력 xlsx 인용 금지**([[load-path#LP-STALE]]) — 정답 기준 = 상품마스터 L1.
- 앵커: `raw/webadmin/tools/load_master.py`(로직만 oracle) · `sql/01a~23`
- 출처: `17_correctness/sticker/loadlogic-notes.md` §0·§2·§3 (file:line) {tier C13/A, FRESH}
- 연결: [[load-path#LP-001]] (loaded-via — 적재 oracle) · [[load-path#LP-STALE]] (v03 금지) · [[#STK-ST-001]]
- answers_cq: CQ-PROD-01 (적재 기준)
- tags: #스티커 #적재 #load_master #v03전파기

### [STK-LP-002] FK 위상순서·멱등 UPSERT·search-before-mint  {🟡}
- 내용: 스티커 적재 = [[load-path#LP-003]] **FK 위상순서**(코드행 → 카테고리/자재/공정 마스터 → 상품 → 상품-자식). 멱등 = 이름 기반 UPSERT([[load-path#LP-004]]). 교정 재연결 대상(카테고리 030~047·PROC_000013 코팅·PROC_000054 반칼·MAT_000084 비코팅) **전부 라이브 실재** → 신규 mint 0(search-before-mint 충족·게이트 K5 입증). ddl 라우팅 2건은 ref_param_json만(OM-7). 입력경로 = admin product-viewer pvEdit([[load-path#LP-006]]) — 단 "컬럼 존재 ≠ 백필 완료".
- 앵커: `t_cod_base_codes`(upr_cod_cd 계층) · `13_admin-ui-spec/`
- 출처: `_gate/sticker-gate.md` K5(search-before-mint 실재 입증) + `loadlogic-notes.md`(FK 경로) {tier C13, FRESH}
- 연결: [[load-path#LP-003]] (loaded-via — FK 위상·코드행 선적재) · [[load-path#LP-004]] (loaded-via — 멱등 UPSERT) · [[load-path#LP-006]] (loaded-via — admin 입력경로)
- answers_cq: CQ-FILE-05 (적재 입력값)
- tags: #스티커 #FK위상 #멱등 #search-before-mint

---

## 7. 현황·결함 (state) — 스티커

> round-13 게이트 GO(K0~K6 PASS·dodge-hunt 실결함 0). 라이브 = 교정대상(피고). 아래 양면표기는 `17_correctness/sticker/correction-manifest.md`·`live-diff.md` 대조분만(미대조 라이브값 인용 금지 — G-1/F-PB-1 교훈). 분류 분포: CORRECT 5·MIS-LOADED 5·MISSING 5·EXTRA 1·AMBIGUOUS 1(합 17).

### 7.1 라이브 오적재 양면표기 (라이브 현재값 ↔ 정답)

| ID | 항목 | 라이브 현재값 | 정답 | 상태 | 출처(correction-manifest §1) |
|---|---|---|---|---|---|
| STK-ST-001 | 코팅(8상품 052·058~062·064·066) | 무광/유광코팅스티커 **자재**(MAT_000155/156, MAT_TYPE.11) | Q9★=코팅 **공정**(PROC_000013)+비코팅 자재(MAT_000084) | 🔴 교정대기·CONFLICT 미결(BATCH-3) | C-ST-04 |
| STK-ST-002 | 카테고리 위상(16상품) | 전부 `CAT_000002`(lvl1 root) | 개별 정상 노드(052→030·058→038···067→046, 030~047 실재) | 🔴 교정대기(Low) | C-ST-02 |
| STK-ST-003 | 063 화이트 별색 | `PROC_000008` 미연결(053/054/056만) | PROC_000008 화이트 underbase 연결 | 🔴 교정대기(MISSING) | C-ST-07 |
| STK-ST-004 | 자재유형(비코팅·미색·투명전용·타투전용 4자재) | `MAT_TYPE.01`(종이) | `MAT_TYPE.11`(스티커) — 단 타투전용지(전사)는 종이 정당 가능 | 🔴 교정대기(Low·표본 컨펌) | C-ST-09 |
| STK-ST-005 | 조각수(~12상품) | `bundle_qtys` 0행(066만 5행) | bundle_qty(상한)+prcs_dtl_opt.조각수(Q8 둘 다) | 🔴 교정대기(OM-7 선결) | C-ST-05 |
| STK-ST-007 | 규격형 형상(058~062) | 형상이 size·공정·product 어디에도 없음(PROC_000055=조각수만) | 형상=PROC_000054 반칼(모양 param)+prcs_dtl_opt.모양 | 🔴 교정대기(OM-7) | C-ST-06 |
| STK-ST-008 | MES_ITEM_CD(16상품) | 전량 NULL(load_master 의도·중복 회피) | L1 002-0001~0016 실값 | 🔴 교정대기(정책 결정) | C-ST-08 |
| STK-ST-009 | 066 빈 옵션그룹 | `OPT-000004 원형`(option_items 0행) | 없어야(형상=size로 표현) | 🔴 논리삭제 제안(EXTRA·hard-delete 금지) | C-ST-12 |
| STK-ST-010 | 055/057 자재명 | "유포지"(MAT_000154, 엠보 소실) | "유포지+엠보코팅" | 🔴 교정대기(멱등키 영향·컨펌) | C-ST-10 |

> **정합(CORRECT·유지):** C-ST-01 size(L1 정합)·C-ST-03 합판형상=size(Q7)·C-ST-14 화이트 053/054/056·C-ST-15 도수(052 단면 4도/0도)·C-ST-17 타투/팩 공정 0행. (이 5건은 양면표기 불요 — 라이브=정답.)

### 7.2 횡단 결함 참조 (축 페이지 권위)

### [STK-ST-001] 코팅 = 자재 오적재 (Q9 공정 CONFLICT 미결)  {🔴 교정대기}
- 내용: 라이브 현재값 코팅=자재(8상품) → 정답 Q9★ 코팅=공정 `PROC_000013`. **단 CONFLICT 미해소** — round-11 product-bom §44는 "점착지 완제 표면사양=자재 variant 정당", 가격표는 비코팅/무광/유광 3컬럼(코팅별 단가축, [[#STK-PRC-001]]). 게이트 K4 검증자가 "라이브 코팅 자재 8상품·PROC_000013 공정 둘 다 실재로 양립 곤란" 동의. 통일은 **BATCH-3 컨펌 대기**(Q-ST-A) — 위키는 양면 표기만, 단정 금지.
- 앵커: `t_prd_product_materials`(MAT_000155/156) vs `t_proc_processes`(PROC_000013)
- 출처: `17_correctness/sticker/correction-manifest.md` C-ST-04·Q-ST-A + `_gate/sticker-gate.md` §10 {tier C13, FRESH}
- 연결: [[processes#PRC-006]] (코팅 family별 분산·BATCH-3) · [[processes#PRC-GAP-1]] (통일 미결) · [[#STK-PRC-001]] (코팅=가격축)
- answers_cq: CQ-FIN-02 (코팅 종류)
- tags: #결함 #코팅 #CONFLICT #BATCH-3 #교정대기

### [STK-ST-003] 063 화이트 underbase MISSING (도메인 필수 위반)  {🔴 교정대기}
- 내용: 라이브 현재값 063(반칼팬시투명, 자재=투명스티커)에 화이트 `PROC_000008` 미연결 → 정답 연결 필요(투명 베이스 화이트 = G-SK-1 도메인 필수). 진원 = v03 15시트 063 화이트 행 부재(load_master 충실 전파). search-before-mint 충족(PROC_000008 마스터 실재).
- 앵커: `t_prd_product_processes`(PROC_000008 → 063)
- 출처: `17_correctness/sticker/correction-manifest.md` C-ST-07 + `loadlogic-notes.md` L-ST-D {tier C13, FRESH}
- 연결: [[#STK-BOM-002]] (정답 화이트=공정) · [[processes#PRC-003]] (별색=공정)
- tags: #결함 #화이트 #063 #MISSING #교정대기

### [STK-ST-004] 자재유형 .01/.11 혼재 (MAT_TYPE 오염 동형)  {🔴 교정대기}
- 내용: 라이브 현재값 점착지 일부 `MAT_TYPE.01`(종이) → 정답 `.11`(스티커). 횡단 자재 오염 패턴([[materials#MAT-005]] .07~.10 + .01 혼재)의 스티커 사례. 진원 = v03 05시트 자재구분 라벨 불일치(load_materials:239 else 경로 충실 변환). 타투전용지(전사)는 종이 정당 가능 → 표본 컨펌.
- 앵커: `t_mat_materials.mat_typ_cd`(.01 → .11)
- 출처: `17_correctness/sticker/correction-manifest.md` C-ST-09 + `loadlogic-notes.md` L-ST-F(line 239 정밀화·G-ST-V1) {tier C13, FRESH}
- 연결: [[materials#MAT-005]] (오염 패턴) · [[materials#MAT-003]] (MAT_TYPE 도메인) · [[#STK-BOM-003]]
- tags: #결함 #자재유형 #MAT_TYPE혼재 #교정대기

### [STK-ST-005] 조각수 bundle_qtys 부분 적재 (066만·OM-7 선결)  {🔴 교정대기}
- 내용: 라이브 현재값 조각수(~12상품) `bundle_qtys` 0행(066만 5행) → 정답 bundle_qty(상한)+`prcs_dtl_opt.조각수`(Q8 둘 다 기록). 조각수의 공정 param 저장처(`prcs_dtl_opt.조각수`)가 스키마 부재(OM-7) → 미실현. 판수(판걸이수)는 [[price-engine#PE-010]] 앱 계산(DB 미저장). 교정은 OM-7 ref_param_json 선결.
- 앵커: `t_prd_product_bundle_qtys`(066만 5행) · prcs_dtl_opt.조각수(저장처 GAP)
- 출처: `17_correctness/sticker/correction-manifest.md` C-ST-05 + `16_mapping-research/sticker/mapping-final.md` L47(Q8) {tier C13/C12, FRESH}
- 연결: [[#STK-DIM-002]] (묶음수·조각수 부분 GAP) · [[cpq-options#CPQ-GAP-2]] (requires — ref_param_json 미구현) · [[price-engine#PE-010]] (판수=앱 계산)
- tags: #결함 #조각수 #bundle_qtys #OM-7 #교정대기

### [STK-ST-006] CPQ 옵션 레이어 전면 미적재 (BATCH-6)  {🔴 미적재}
- 내용: 라이브 현재값 스티커 CPQ option_items 0행(전 family 18행은 silsa 파일럿뿐, [[cpq-options#CPQ-008]]) → 정답 스티커 옵션 레이어(코팅·화이트·조각수·형상) 적재 필요. BATCH-6 일괄 적재 미결. 066 빈 옵션그룹(STK-ST-009)은 잔재(논리삭제).
- 앵커: `t_prd_product_option_items`(스티커 0행)
- 출처: `_gate/sticker-gate.md` §10 + 축 [[cpq-options#CPQ-008]](라이브 18행 CONF-1) {tier A/C13, FRESH}
- 연결: [[cpq-options#CPQ-008]] (전면 미적재) · [[cpq-options#CPQ-GAP-1]] (BATCH-6) · [[#STK-CPQ-001]]
- tags: #결함 #CPQ미적재 #BATCH-6 #미적재

### 7.3 GAP / 🔴 컨펌 (인간 결정 대기)

- **[GAP-ST-1] 🔴 코팅 = 공정 통일 (Q-ST-A·BATCH-3)** — Q9 권위(공정) vs round-11 §44(자재 variant 정당)·가격표 3컬럼. 양립 곤란·미해소. → [[processes#PRC-GAP-1]].
- **[GAP-ST-2] 🔴 조각수 저장처 (Q-ST-B·OM-7)** — prcs_dtl_opt.조각수 상품 레벨 저장처 부재. ref_param_json 미구현 선결. 판수=앱 계산(DB 미저장·입력=판형 인쇄가능영역+작업사이즈). → [[cpq-options#CPQ-GAP-2]].
- **[GAP-ST-3] 🔴 규격형 058~062 형상 저장처 (Q-ST-C)** — PROC_000055→054 교체+param vs siz_nm 통일 미결.
- **[GAP-ST-4] 🔴 스티커팩 065 세트 구성 (Q-ST-E)** — sets=0(미적재). 구성품 데이터 필요.
- **[GAP-ST-5] 🔴 MES_ITEM_CD 적재 정책 (Q-ST-MES)** — 중복 정리 후 재적재 vs 의도 NULL 유지.
- **[GAP-ST-6] 🔴 CPQ 옵션 레이어 일괄 적재 (BATCH-6)** — [[#STK-ST-006]]. → [[cpq-options#CPQ-GAP-1]].

> 실 교정 COMMIT은 round-5/10 트랙 인간 승인 대기 — **DB 미적재 유지**([[load-path#LP-GAP-4]]).

---

## Sources
- **큐레이션 팩:** `_curation/pack-sticker.md`(1차 권위·tier·freshness).
- **정체:** `17_correctness/sticker/product-identity.md`(C13·FRESH) — 보조 `06_extract/sticker-l1.csv`(B·16상품 154행).
- **차원/BOM:** `15_domain-spec/sticker/column-dictionary.md`·`product-bom.md`(C11) · `16_mapping-research/sticker/mapping-final.md`(C12).
- **가격:** `16_mapping-research/sticker/live-crosscheck.md` §5(Q7 가격표) + `06_extract/price-{sticker-price,gangpan-sticker}-l1.csv`(B·L1 FRESH).
- **적재경로:** `17_correctness/sticker/loadlogic-notes.md`(C13·file:line) + `raw/webadmin/sql/`·`tools/load_master.py`(로직만·A).
- **결함:** `17_correctness/sticker/correction-manifest.md`·`live-diff.md`(C13) + `_gate/sticker-gate.md`(K0~K6 GO).
- **축 페이지(횡단 참조):** `huni/{materials,processes,price-engine,cpq-options,widget-contract,load-path}.md`.
- **STALE(인용 0 확인):** `price-engine-ddl.md`([[price-engine#PE-STALE]])·`constraint_json`([[cpq-options#CPQ-STALE]])·`dep_proc_cd`·v03 입력 xlsx([[load-path#LP-STALE]]) — 본 페이지 미인용.
