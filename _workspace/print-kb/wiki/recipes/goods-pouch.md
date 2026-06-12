# goods-pouch(굿즈파우치) 레시피  {전체상태: 🟡}

> 조립 뷰. 횡단 사실은 축 페이지(`huni/<axis>.md`) 원자 항목을 `[[링크]] + 관계동사`로 참조만 하고 본문 복붙하지 않는다(README §3·§9). 레시피 고유 사실(굿즈 103상품 목록·교정대기 행)만 본문 원자 블록.
> 큐레이션 팩: `_curation/pack-goods-pouch.md`(1차 권위). round-13 게이트 GO(K0~K6 PASS·F-GP-GATE-1 보정 후 재게이트). **round-12 mapping-research 없음** — 매핑 권위 = round-11(15_domain-spec) + round-13(17_correctness).
> **STALE/v03 인용 0**: 가격엔진 ddl·v03 입력 xlsx·constraint_json·dep_proc_cd·excl_grp_cd 인용 금지(축 STALE 블록 참조). 라이브 오적재는 7절 양면 표기.

## CQ 헤더 (이 페이지가 답하는 질문)
- 굿즈파우치는 무엇인가(103상품·19 상품군·혼합 인쇄방식 7종) / 어떤 차원·옵션(사이즈=옵션 재분류·본체색·형상·잉크색·가공)이 있는가
- 가격은 어떻게 계산되는가(고정가형·구간할인 굿즈A/B타입) / DB에 어떻게 등록하는가(v03 전파·CPQ 신규)
- 현재 라이브 적재 상태·교정 대기(카테고리 고아 35상품·자재 폭증/오염·봉제→부착·공정 누락·CPQ 미적재)는 무엇인가
- 미결: 폰기종/등급 size↔option 경계(Q-GP-1·BATCH-6)·본체색×규격 2축 분리(Q-GP-2)·굿즈 가공 택일그룹(Q-GP-3)·고아 노드 처리(Q-GP-4)

---

## 0. 정체 (identity) — 굿즈파우치  앵커: t_prd_products · t_cat_categories

### [GP-ID-001] 굿즈파우치 = 103상품·19 상품군·혼합 인쇄방식 7종  {✅}
- 내용: 굿즈파우치(가격포함) 시트 = **103 distinct 상품**(L1 `prd_nm` 기준 멱등키). 라이브 굿즈 범위 ≈ `PRD_000183`~`PRD_000290`(약 101 상품). 디지털인쇄와 달리 **`구분`(상품군)이 풍부 — 19종**(거울/머그/티셔츠/말랑/레더파우치/에코백/필통/폰케이스 등)이 인쇄방식·후가공·구간할인을 가른다. 범주 = **굿즈(009 액세서리)** + **패션잡화(파우치·에코백)** 의 단품(낱장 C단일). **정체 오분류 0**(round-13 K0 PASS·의심 반증) — 거울/머그/파우치 전부 일상 굿즈로 비전형 부재, 라이브 결함은 정체가 아닌 **속성축 적재 결함**(F-ID-1~5). 라이브 전수 `prd_typ_cd=PRD_TYPE.03(기성상품)`·`MES_ITEM_CD=NULL`·`file_upload_yn=Y`·`use_yn=Y`·`editor_yn=Y`(만년스탬프만 N).
- 앵커: `t_prd_products`(PRD_000183~290) · `t_cat_categories`
- 출처: `17_correctness/goods-pouch/product-identity.md` §0·§1·§3 (라이브 read-only psql 재현) + `_gate/goods-pouch-gate.md` K0 PASS {tier C13, FRESH}
- 연결: [[../base/printing-methods#3-방식-선택을-가르는-변수]] (uses — 인쇄방식 보편) · [[#GP-BOM-001]] (uses — 인쇄방식=공정 root) · [[load-path#LP-GAP-3]] (카테고리 고아 재연결 미적재)
- answers_cq: CQ-PROD-01 (상품 분류) · CQ-PROD-03 (완제품 귀속)
- tags: #굿즈파우치 #정체 #103상품 #19상품군 #인쇄방식7종

### [GP-ID-002] 인쇄방식 7종 = `폴더`(C12) 생산라우팅 권위  {✅}
- 내용: 인쇄방식 = `파일사양_폴더`(C12)가 권위 — **패브릭인쇄(86)·UV인쇄(18)·전사인쇄(17·외주)·이지굿즈(13·PVC고주파)·디지털인쇄(7)·만년도장(7)·실사출력(2)**. 상품군이 인쇄방식을 결정한다(패브릭=레더/에코백/파우치→봉제·UV=거울/핀버튼→레이저커팅·전사=의류 외주·이지굿즈=말랑 PVC고주파 융착·만년도장=만년스탬프). 폴더=생산팀 라우팅이라 공정 root 도출의 1차 키. 인쇄방식은 후니의 최상위 분기축이 **아니다**([[modeling-axioms#HMOD-01]] — 시트=1차 단위).
- 앵커: 폴더(C12) → `t_prd_product_processes`(인쇄방식 root 공정 도출) · `t_proc_processes`
- 출처: `15_domain-spec/goods-pouch/column-dictionary.md` C12·§0 1차발견ⓐ (07_domain process-recipe §207 혼합인쇄) {tier C11, FRESH}
- 연결: [[modeling-axioms#HMOD-01]] (uses — 인쇄방식≠최상위 분기) · [[../base/printing-methods#2-무판--디지털-인쇄]] (uses — 무판 UV/디지털 보편) · [[#GP-BOM-002]]
- answers_cq: CQ-PROD-01 (상품 분류) · CQ-PROC-01 (공정 라우트)
- tags: #굿즈파우치 #인쇄방식 #폴더 #생산라우팅

---

## 1. 차원 (dimensions) — 굿즈파우치  앵커: t_prd_product_sizes/sets · t_siz_sizes · t_prd_product_options(옵션형)

### [GP-DIM-001] 사이즈 = 치수형(22) vs 옵션형(202) 이중축 — round-10 size→option 재분류  {🟡}
- 내용: `사이즈(필수)`(C5) 컬럼이 **두 의미축 혼재** — 비빈값 224행 중 **202행(90%)이 비치수 옵션성**(폰기종·M/L/XL 사이즈등급·세로/가로형 방향·구수 2/3/4구·면 단/양면), 진짜 치수(NxN)는 22행뿐. round-10 변경추적이 굿즈파우치 **448셀을 `사이즈(필수)`→`상품(옵션)`으로 재분류**(224쌍·58상품, [[load-path#LP-007]]·OM-2). **올바른 모델: 치수형 → size, 옵션형 → CPQ option_items**([[#GP-CPQ-001]])·형상 → 규격축 융합·구수 → 개수형 공정·면 → 도수. **[HARD] 기계적 size 삭제 금지**(적재된 size/price 사슬 파손 — [[load-path#LP-004]]·메모리). 라이브 `t_prd_product_sizes`=29행(치수형만 정상 적재·W3 실측).
- 앵커: `t_prd_product_sizes`(치수형 ≈29행) · `t_prd_product_options`/`option_items`(옵션형 목표·미적재)
- 출처: `15_domain-spec/goods-pouch/column-dictionary.md` C5·§2·§10 + `17_correctness/goods-pouch/correction-manifest.md` GP-C-11(치수형 CORRECT)·GP-C-15(경계 AMBIGUOUS) {tier C11/C13, FRESH}
- 연결: [[cpq-options#CPQ-002]] (requires — 옵션형은 polymorphic ref_dim_cd) · [[load-path#LP-007]] (size→option 변경추적 이력) · [[#GP-CPQ-001]] (옵션 매핑) · [[#GP-ST-001]] (교정대기)
- answers_cq: CQ-PROD-06 (variant → 차원 분해) · CQ-PROD-05 (옵션 축)
- tags: #굿즈파우치 #사이즈 #치수형옵션형 #size→option #round10

### [GP-DIM-002] 치수 권위 = 작업사이즈(C7) — 재단/블리드/출력판형 전 빈값  {🟡}
- 내용: 굿즈는 리지드 단품이라 `블리드`(C6)·`재단사이즈`(C8)·`출력용지규격`(C9)이 **전부 빈값** — `작업사이즈`(C7, 132행 `100x90`·`220x300` 등)가 **유일 치수 권위**. **출력판형(전지) 양면표기:** 엑셀 출력용지규격(C9)은 빈값(굿즈=직인쇄/단품, 전지규격 무의미 추론 — [[../base/sizes#BSZ-003]] 출력판형 보편의 N/A 케이스로 본 column-dictionary §10 근거) ↔ **그러나 라이브 `t_prd_product_plate_sizes`는 122행(85상품) 적재됨**(W3 read-only 실측). 인용 소스는 엑셀 빈값만 근거로 "미적재"를 추론했을 뿐 라이브 미측정 → "미적재 정당" 단정 불가(round-8 tags jsonb 교훈: 권위=라이브). 적재 의미·정합 재판정 필요(작업사이즈/판형 혼동 G-GP-2 인접·작업사이즈가 plate에 잘못 들어갔을 가능성). 단 재단치수 누락은 G-GP-2 결함(77상품)·작업사이즈/사이즈(C5)에서 도출 필요. 세트(`t_prd_product_sets`)=0행 정당(굿즈=세트 아님·GP-C-13 CORRECT).
- 앵커: `t_siz_sizes.work_*`(작업사이즈) · `t_prd_product_plate_sizes`(엑셀 빈값 ↔ 라이브 122행/85상품·정합 재판정 필요) · `t_prd_product_sets`(0행)
- 출처: `15_domain-spec/goods-pouch/column-dictionary.md` C6~C9·§10(G-GP-2) + `17_correctness/goods-pouch/correction-manifest.md` GP-C-13(sets CORRECT) {tier C11/C13, FRESH}
- 연결: [[../base/sizes#BSZ-003]] (uses — 작업/재단/출력판형 3축 보편) · [[#GP-DIM-001]]
- answers_cq: CQ-PROD-06 (치수 축)
- tags: #굿즈파우치 #작업사이즈 #재단누락 #출력판형N/A #sets0

---

## 2. 자재·공정 BOM — 굿즈파우치  앵커: t_prd_product_materials/processes · t_mat_materials · t_proc_processes

### [GP-BOM-001] 본체색 = 재질행 합성 (과분할 금지 — 굿즈파우치가 정답 모델)  {🟡}
- 내용: 본체색(블랙/화이트/반투명/투명/멜란지 등)은 **재질행에 합성**한다 — "블랙 파우치" = "파우치원단(블랙)" 1행([[materials#MAT-004]] 과분할 금지·wowpress 규칙B). **굿즈파우치는 이 합성 모델이 이미 정답**(다른 family의 색=자재 오염과 구분 — 큐레이션 팩 stale함정#1). 단 라이브는 본체색×규격을 **8행 직교 폭증**으로 과분할 적재(반팔티셔츠 화이트 M/L/XL/XXL·블랙 M/L/XL/XXL) → 정답 = 본체색 2축(색=재질 2행)·규격은 옵션([[#GP-ST-002]] 교정대기). 잉크색(만년스탬프)은 본체색이 **아니라 도수**([[#GP-BOM-003]]).
- 앵커: `t_prd_product_materials`(본체색=mat_cd 합성) · `t_mat_materials`
- 출처: `10_configurator/huni-goods-option-mapping.md` §2.1(본체색=재질행 합성) + `15_domain-spec/goods-pouch/column-dictionary.md` C15·§10 + `17_correctness/goods-pouch/correction-manifest.md` GP-C-03 {tier C6/C11/C13, FRESH}
- 연결: [[materials#MAT-002]] (uses — parent+usage_cd) · [[materials#MAT-004]] (uses — 정규화 5축·과분할 금지) · [[materials#MAT-GAP-1]] (본체색 합성 vs 색=자재 통일 미결) · [[#GP-ST-002]]
- answers_cq: CQ-PROD-05 (자재 축) · CQ-TERM-04 (소재 약어)
- tags: #굿즈파우치 #본체색 #재질행합성 #과분할금지

### [GP-BOM-002] 자재유형 = 소재별 정확 MAT_TYPE (.05 원단·.04 금속·.09 파우치·.10 악세사리)  {🟡}
- 내용: 굿즈 자재유형은 소재가 상품군 정체를 결정 — `MAT_TYPE.09(파우치)`·`.10(악세사리)`·`.05(원단)`·`.04(금속)`·`.02(필름)` 등. 자재 모델 = [[materials#MAT-002]] parent + usage_cd(굿즈 낱장은 전부 `USAGE.07 공통`·GP-C-12 CORRECT). 단 라이브는 `MAT_TYPE.09(파우치)`가 **비-파우치 상품의 만능 쓰레기통**으로 오염(티셔츠=원단 .05여야·핀버튼=금속 .04여야인데 전부 .09) → 횡단 자재 오염 패턴([[materials#MAT-005]] .07~.10)의 굿즈 사례([[#GP-ST-003]]).
- 앵커: `t_mat_materials.mat_typ_cd`(.05/.04/.09/.10) · `t_prd_product_materials`(mat_cd+usage_cd=.07)
- 출처: `15_domain-spec/goods-pouch/column-dictionary.md` §0 1차발견ⓓ·C15 + `17_correctness/goods-pouch/correction-manifest.md` GP-C-05·GP-C-12(usage CORRECT) {tier C11/C13, FRESH}
- 연결: [[materials#MAT-001]] (uses — 자재 마스터 구조) · [[materials#MAT-003]] (uses — MAT_TYPE 코드도메인) · [[materials#MAT-005]] (오염 패턴) · [[#GP-ST-003]]
- answers_cq: CQ-PROD-05 (자재 축)
- tags: #굿즈파우치 #자재유형 #MAT_TYPE #USAGE07 #오염

### [GP-BOM-003] 굿즈 후가공 = 봉제/에폭시/맥세이프 (인쇄방식별)  {🟡}
- 내용: 굿즈 완성 공정 = **봉제미싱**(`PROC_000080` D-24, 패브릭/레더/타이벡/메쉬 파우치·에코백·필통 — 패브릭인쇄→봉제미싱 입고)·**에폭시**(`PROC_000083` b.12, 말랑 PVC고주파 전용)·**맥세이프**(폰케이스 자석링 부속+부착)·**라벨부착**(부속+공정). 잉크색(만년스탬프 청보라/빨강 등 7색)·면(단/양면)은 자재가 아니라 **도수**([[processes#PRC-003]] 별색=공정 인접 개념·clr/print_options). 라이브는 공정 6행뿐(전부 캔버스류 `PROC_000081 부착`) — 봉제→부착 오적재([[#GP-ST-004]])·봉제/에폭시/맥세이프 공정 0행([[#GP-ST-005]]).
- 앵커: `t_prd_product_processes`(PROC_000080 봉제·PROC_000083 에폭시) · `t_proc_processes` · `t_prd_product_print_options`(잉크색/면 도수)
- 출처: `15_domain-spec/goods-pouch/column-dictionary.md` C17·§6(07_domain PROC_000080 D-24·PROC_000083 b.12) + `17_correctness/goods-pouch/product-identity.md` F-ID-5 + `correction-manifest.md` GP-C-06/07/08 {tier C11/C13, FRESH}
- 연결: [[processes#PRC-001]] (uses — 공정 마스터·연결 구조) · [[processes#PRC-005]] (uses — 박/코팅/UV=공정 인접) · [[processes#PRC-GAP-2]] (신규 공정 신설 미결) · [[#GP-ST-004]] · [[#GP-ST-005]]
- answers_cq: CQ-PROC-01 (공정 라우트) · CQ-FIN-03 (별색/도수 용도) · CQ-FIN-10 (굿즈 전용 후가공: 봉제미싱·에폭시·아크릴가공)
- tags: #굿즈파우치 #봉제 #에폭시 #맥세이프 #후가공

---

## 3. 가격 사슬 (price chain) — 굿즈파우치  앵커: t_prc_* 4단 + t_dsc_*

### [GP-PRC-001] 가격 = 고정가형 (수량×옵션 단가, 가격포함 시트)  {🟡}
- 내용: 굿즈 가격 = [[price-engine#PE-007]] **고정가형(수량×옵션 고정단가)** — 리지드 단품 단가(3000·3600·2500·5000원 등). 실사·포스터사인 같은 **면적매트릭스 아님**([[price-engine#PE-006]] 미적용 — 면적-좌표 회귀 인용 금지). `굿즈파우치(가격포함)` 시트 inline 가격 4컬럼(`가격` C23·`선택가격`·`가공가격`·`추가가격`)은 round-2 트랙 처리분 — color/size variant 추가가는 전부 0(동가). **라이브 가격 적재 확인 필요**(가격포함이나 prices 0행 family군 가능성 — 큐레이션 팩 stale함정#4·[[price-engine#PE-GAP-3]] 인접). 멱등 가격 PK = (prd_cd, apply_bgn_ymd)([[price-engine#PE-003]]).
- 앵커: `t_prc_component_prices`(고정가형 룩업) · `t_prc_price_components.prc_typ_cd`(.01 단가형)
- 출처: `15_domain-spec/goods-pouch/column-dictionary.md` C23·§9(고정가형) + `06_extract/goods-pouch-l1.csv`(가격포함 L1·B) {tier C11/B, FRESH(도메인)·PARTIAL-STALE(라이브 적재 미확인·I-7)}
- 연결: [[price-engine#PE-007]] (priced-by — 고정가형) · [[price-engine#PE-001]] (uses — t_prc_* 4단) · [[price-engine#PE-003]] (uses — 멱등 PK) · [[#GP-PRC-002]]
- answers_cq: CQ-PRICE-01 (단가표 vs 공식) · CQ-PRICE-05 (면적/격자 계산)
- tags: #굿즈파우치 #가격 #고정가형 #가격포함시트

### [GP-PRC-002] 구간할인 = 굿즈A/B타입·말랑·파우치/에코백 (카테고리단위)  {✅}
- 내용: 굿즈 수량구간 할인 권위 = `구간할인적용테이블`(C24) — **굿즈상품 A타입(15)·B타입(11)·구간할인(말랑상품)(5)·구간할인(파우치/에코백)(1)·구간할인없음(2)**. 카테고리단위 적용(구간할인 권위=C24·메모리 dbmap-discount-authority·round-1 [[price-engine#PE-008]] 구간형). 폰케이스(7상품)는 구간할인 아닌 **inline 가격메모**(7700/무광6600/맥세이프 실무 코멘트·할인테이블 링크 아님). 할인테이블 자체는 round-1 GO·미적재.
- 앵커: `t_dsc_*`(할인테이블 링크) · `구간할인적용테이블`(C24)
- 출처: `15_domain-spec/goods-pouch/column-dictionary.md` C24·§8 (round-1 구간할인 권위 = 메모리 dbmap-discount-authority) {tier C11/round-1, FRESH}
- 연결: [[price-engine#PE-008]] (priced-by — 구간형 t_dsc_*) · [[#GP-PRC-001]]
- answers_cq: CQ-PRICE-04 (수량구간 할인)
- tags: #굿즈파우치 #구간할인 #굿즈AB타입 #카테고리단위

---

## 4. CPQ 옵션 레이어 — 굿즈파우치  앵커: t_prd_product_option_groups/options/option_items · constraints · templates

### [GP-CPQ-001] 옵션축(폰기종·등급·방향·구수·면·본체색·가공·addon) → 4엔티티 매핑  {🟡}
- 내용: 굿즈 옵션성 축(폰기종·M/L/XL 등급·세로/가로형 방향·구수·면·본체색·가공·추가상품)은 [[cpq-options#CPQ-004]] **속성→4엔티티 지도**로 분기: 본체색=자재 합성([[#GP-BOM-001]])·구수=개수형 공정·면=도수·가공/추가상품=옵션. 옵션형 사이즈 202행은 `option_items`가 polymorphic `ref_dim_cd`로 L1 차원행 참조([[cpq-options#CPQ-002]]), 무결성은 트리거 `fn_chk_opt_item_ref`([[cpq-options#CPQ-003]])가 강제 → 차원행 선적재 필수. WowPress 6축 흡수 원칙(본체색→재질·형상→규격, 과분할 금지)이 후니 모델에 정합([[cpq-options#CPQ-004]]). **단 굿즈 CPQ 레이어 전면 미적재**([[#GP-ST-006]]).
- 앵커: `t_prd_product_option_items.ref_dim_cd` · `t_prd_product_option_groups`
- 출처: `10_configurator/huni-goods-option-mapping.md`(속성→엔티티·6축 흡수) + `15_domain-spec/goods-pouch/column-dictionary.md` C5·§10 (round-10 size→option) {tier C6/C11, FRESH(매핑)·PARTIAL-STALE(I-5·I-9)}
- 연결: [[cpq-options#CPQ-004]] (uses — 속성→4엔티티) · [[cpq-options#CPQ-002]] (uses — polymorphic ref_dim_cd) · [[cpq-options#CPQ-003]] (requires — 무결성 트리거) · [[cpq-options#CPQ-005]] (uses — BUNDLE 자재+공정) · [[#GP-ST-006]]
- answers_cq: CQ-PROD-05 (옵션 축·캐스케이드)
- tags: #굿즈파우치 #CPQ #속성매핑 #4엔티티 #size→option

### [GP-CPQ-002] 추가상품(addon) = 볼체인·리필잉크·아크릴스탠드 (BUNDLE·별 상품 재사용)  {🟡}
- 내용: 굿즈 추가상품(C22) = **볼체인(9색 키링 부속)·5cc 잉크(만년스탬프 리필)·아크릴스탠드(거치)** — addon SKU([[cpq-options#CPQ-005]] BUNDLE = 부속 자재+옵션). 목표 = `t_prd_product_addons(addon_prd_cd)` + `t_prd_templates`(SKU). **볼체인 `PRD_000006`·리필잉크 `PRD_000015`는 별 상품으로 라이브 실재** → 재연결만(search-before-mint·mint 불요·[[load-path#LP-004]]). 단 라이브 addon 링크 0행([[#GP-ST-007]] — v03 `20` 시트 굿즈 행 부재).
- 앵커: `t_prd_product_addons`(addon_prd_cd) · `t_prd_templates`(tmpl_cd)
- 출처: `15_domain-spec/goods-pouch/column-dictionary.md` C22·§7 (07_domain §3 #9) + `17_correctness/goods-pouch/correction-manifest.md` GP-C-09 {tier C11/C13, FRESH}
- 연결: [[cpq-options#CPQ-005]] (uses — BUNDLE 자재+공정) · [[load-path#LP-004]] (requires — search-before-mint 재사용) · [[#GP-ST-007]]
- answers_cq: CQ-PROD-05 (추가상품) · CQ-PROD-08 (UI 노출)
- tags: #굿즈파우치 #추가상품 #addon #볼체인 #BUNDLE

---

## 5. 위젯 계약 (widget contract) — 굿즈파우치  앵커: 정규화 계약(huni-widget 03_spec) — DB 외 앵커

### [GP-WID-001] 위젯은 정규화 계약 의존 (DB 독립·어댑터 경계)  {⚪}
- 내용: 굿즈 위젯은 후니 DB 스키마가 아닌 **정규화 데이터 계약**(상품·옵션·가격 안정 shape)에 의존([[widget-contract#WID-001]]). 옵션축(폰기종·등급·방향·본체색·가공·addon)→14 componentType→shadcn 매핑([[widget-contract#WID-003]]). DB 확정 시 후니 어댑터만 교체([[widget-contract#WID-002]]) → 위젯 코어 불변. 굿즈는 옵션 캐스케이드(Zustand)+Edicus 브리지([[widget-contract#WID-004]]) 활성(에디터 주력 — 폰케이스/키링/거울 디자인). 위젯 스펙 = `huni-widget/03_spec/s5-goods-pouch-spec.md`(D·FRESH).
- 앵커: DB 외 — `huni-widget/03_spec/s5-goods-pouch-spec.md`(어댑터 경계에서 t_*로)
- 출처: `huni-widget/03_spec/s5-goods-pouch-spec.md`·`data-contract.md`(축 WID-001 경유) {tier D, FRESH}
- 연결: [[widget-contract#WID-001]] (mapped-to — 정규화 계약) · [[widget-contract#WID-002]] (mapped-to — 어댑터) · [[widget-contract#WID-003]] (mapped-to — componentType) · [[widget-contract#WID-004]] (mapped-to — 캐스케이드·Edicus)
- answers_cq: CQ-PROD-05 (옵션 축 shape) · CQ-PROD-08 (UI 노출)
- tags: #굿즈파우치 #위젯 #정규화계약 #DB독립

### [GP-WID-002] 가격 권위 = 서버 (PRICE=0 불가 신호)  {⚪}
- 내용: 굿즈 위젯 가격은 **서버 권위 + 클라 캐싱**([[widget-contract#WID-005]]). 후니 가격은 가격엔진 축([[price-engine#PE-001]]·고정가형 [[#GP-PRC-001]]) 권위. RedPrinting PRICE=0은 절대 불가 — 0은 우리측 요청/세션 결함 신호(Red 역산값 후니 이식 금지·[[widget-contract#WID-STALE]] ATTB 날조 전례).
- 앵커: DB 외 — 서버 가격 API(후니 가격=t_prc_*)
- 출처: `huni-widget/03_spec/price-engine.md`(축 WID-005 경유) {tier D, FRESH(후보)}
- 연결: [[widget-contract#WID-005]] (priced-by — 서버 가격권위) · [[price-engine#PE-001]] (priced-by — 후니 가격) · [[widget-contract#WID-STALE]]
- answers_cq: CQ-PRICE-01 (가격 권위=서버)
- tags: #굿즈파우치 #위젯 #가격권위 #PRICE0불가

---

## 6. 적재 레시피 (load path) — 굿즈파우치  앵커: raw/webadmin sql/tools · round-8 admin-ui-spec

### [GP-LP-001] 적재 oracle = load_master(순수 전파기) · 진원=상류 v03  {🟡}
- 내용: 굿즈 라이브 값 = `tools/load_master.py`가 v03 통합시트(10_상품·11_상품별카테고리·13_사이즈·14_자재·15_공정 등)를 **거의 무변환 1:1 전파**한 결과(굿즈 전용 분기 없음). **load_master는 순수 전파기** — 결함의 1차 진원은 상류 **v03 마이그레이션 정규화 단계**(상품마스터→정규화·레포 미동봉), load_master 코드 결함은 없다(변환 로직 부재를 §1~§5에서 입증). 따라서 교정은 v03 재생성보다 **라이브 t_* 직접 교정**(상품마스터 260610 L1 권위)이 실효적. **[HARD] v03 입력 xlsx 인용 금지**([[load-path#LP-STALE]]) — 정답 기준 = 상품마스터 L1.
- 앵커: `raw/webadmin/tools/load_master.py`(로직만 oracle) · `sql/01a~23`
- 출처: `17_correctness/goods-pouch/loadlogic-notes.md` §0·§1~§6 (file:line) {tier C13/A, FRESH}
- 연결: [[load-path#LP-001]] (loaded-via — 적재 oracle) · [[load-path#LP-STALE]] (v03 금지) · [[load-path#LP-GAP-1]] (v03 상류 vs DB 직접·BATCH-12) · [[#GP-ST-001]]
- answers_cq: CQ-PROD-01 (적재 기준)
- tags: #굿즈파우치 #적재 #load_master #순수전파기 #v03진원

### [GP-LP-002] FK 위상순서·멱등 UPSERT·CPQ 범위 밖  {🟡}
- 내용: 굿즈 적재 = [[load-path#LP-003]] **FK 위상순서**(코드행 → 카테고리/자재/공정 마스터 → 상품 → 상품-자식). 멱등 = 이름(prd_nm) 기반 UPSERT([[load-path#LP-004]]). **CPQ 옵션 레이어는 load_master 범위 밖**(RELATIONS 리스트에 옵션 로더 부재·line 461~481) → option_groups 0행은 결함이 아니라 **애초 미적재**([[#GP-ST-006]]·round-6 신규 트랙). 카테고리 부모 무추론(line 170·175 빈 상위코드 NULL 잔존)이 고아 노드 원인([[#GP-ST-008]]). 입력경로 = admin product-viewer pvEdit([[load-path#LP-006]]) — 단 "컬럼 존재 ≠ 백필 완료".
- 앵커: `t_cod_base_codes`(upr_cod_cd 계층) · RELATIONS 461~481(옵션 로더 부재) · `13_admin-ui-spec/`
- 출처: `17_correctness/goods-pouch/loadlogic-notes.md` §2·§3·§5·§6(L-GP-2/3) + `_gate/goods-pouch-gate.md` K2/K3 PASS {tier C13/A, FRESH}
- 연결: [[load-path#LP-003]] (loaded-via — FK 위상·코드행 선적재) · [[load-path#LP-004]] (loaded-via — 멱등 UPSERT) · [[load-path#LP-006]] (loaded-via — admin 입력경로) · [[cpq-options#CPQ-008]] (CPQ 범위 밖)
- answers_cq: CQ-FILE-05 (적재 입력값)
- tags: #굿즈파우치 #FK위상 #멱등 #CPQ범위밖

---

## 7. 현황·결함 (state) — 굿즈파우치

> round-13 게이트 GO(K0~K6 PASS·F-GP-GATE-1 "CPQ 전면 미적재 과대단언" 보정 후 재게이트). 라이브 = 교정대상(피고). 아래 양면표기는 `17_correctness/goods-pouch/correction-manifest.md`·`live-diff.md` 대조분만(미대조 라이브값 인용 금지 — G-1/F-PB-1 교훈). 분류 분포: CORRECT 4·MIS-LOADED 6·MISSING 4·EXTRA 1·AMBIGUOUS 2(합 17).

### 7.1 라이브 오적재 양면표기 (라이브 현재값 ↔ 정답)

| ID | 항목 | 라이브 현재값 | 정답 | 상태 | 출처(correction-manifest) |
|---|---|---|---|---|---|
| GP-ST-001 | 옵션형 사이즈(폰기종·M/L/XL·방향·구수·면 58상품) | 자재행 흡수 또는 누락 (size→option 미적용) | option_groups/options/option_items(ref_dim_cd) — 치수형만 size | 🔴 교정대기·AMBIGUOUS(Q-GP-1·BATCH-6) | GP-C-10·GP-C-15 |
| GP-ST-002 | 본체색×규격 폭증(반팔티셔츠 등 8행) | "화이트 M/L/XL/XXL·블랙 M/L/XL/XXL" 8 자재행(MAT_TYPE.09) | 본체색 2행(화이트/블랙) + 규격=옵션. 자재유형 .05 원단 | 🔴 교정대기(Q-GP-2 의존) | GP-C-03 |
| GP-ST-003 | 자재유형 오염(티셔츠·핀버튼·만년스탬프·머그) | `MAT_TYPE.09(파우치)` 무차별 | 소재별 정확 MAT_TYPE(.05 원단·.04 금속·.02 필름 등) | 🔴 교정대기(High) | GP-C-05 |
| GP-ST-003b | 비-소재 값(형상·용량·잉크색)이 자재행 | 핀버튼 형상·머그 11온스·만년스탬프 잉크색 = materials(.09) | 형상→t_siz_sizes·용량→비치수 siz·잉크색→t_clr/print_options | 🔴 교정대기(High) | GP-C-04 |
| GP-ST-004 | 봉제 공정(캔버스 파우치/필통/에코백 6상품) | `PROC_000081 부착` | `PROC_000080 봉제`(D-24·패브릭→봉제미싱) | 🔴 교정대기(High) | GP-C-06 |
| GP-ST-008 | 카테고리 위상(35상품) | 고아 노드(CAT_000301 소품·305 레더파우치 등·upr NULL·lvl3) | 개별 정상 노드(거울→CAT_000165~169·레더→CAT_000213~221·upr=010/011) | 🔴 교정대기(High) | GP-C-01 |
| GP-ST-009 | 잉여 고아 노드(CAT_000293~306·굿즈 6개) | upr NULL·lvl3 고아 잔존 | 재연결 후 논리삭제(use_yn=N) 또는 부모 부여 | 🔴 논리삭제/부모부여 제안(EXTRA·hard-delete 금지) | GP-C-02 |
| GP-ST-010 | 머그=라이프 ROOT 직결(8상품) | `CAT_000010 라이프`(lvl1 ROOT) | 말단 노드(머그=CAT_000170 등) 정밀화 | 🟡 선택(무결성 위반 아님) | GP-C-16 |

> **정합(CORRECT·유지):** GP-C-11 치수형 size 22행(기계삭제 금지)·GP-C-12 usage USAGE.07 공통·GP-C-13 sets 0(굿즈=세트 아님)·GP-C-14 정상 노드 56상품·GP-C-17 MES NULL(신규 등록 대상). (이 5건은 양면표기 불요 — 라이브=정답.)

### 7.2 횡단/MISSING 결함 (축 페이지 권위)

### [GP-ST-001] 옵션형 사이즈 size→option 미적용 (AMBIGUOUS·BATCH-6)  {🔴 교정대기}
- 내용: 라이브 현재값 옵션형 사이즈(폰기종·M/L/XL·방향·구수·면 58상품)가 자재행 흡수 또는 누락 → 정답 `option_groups/options/option_items`(ref_dim_cd), 치수형만 size([[#GP-DIM-001]]). round-10이 448셀 size→option 재분류 의도했으나 적재 파이프라인 미반영(loadlogic §2). 폰기종/등급 경계는 AMBIGUOUS(Q-GP-1 컨펌·기계적 size 삭제 금지). round-6 CPQ 트랙.
- 앵커: `t_prd_product_options`/`option_items`(미적재) vs `t_prd_product_sizes`
- 출처: `17_correctness/goods-pouch/correction-manifest.md` GP-C-10·GP-C-15 + `product-identity.md` F-ID-4 {tier C13, FRESH}
- 연결: [[#GP-DIM-001]] (치수형/옵션형 이중축) · [[#GP-ST-006]] (CPQ 미적재) · [[cpq-options#CPQ-GAP-1]] (BATCH-6)
- tags: #결함 #size→option #AMBIGUOUS #BATCH-6 #교정대기

### [GP-ST-002] 본체색×규격 8행 직교 폭증 (과분할)  {🔴 교정대기}
- 내용: 라이브 현재값 반팔티셔츠 등 "화이트 M/L/XL/XXL·블랙 M/L/XL/XXL" 8 자재행(MAT_TYPE.09) → 정답 본체색 2행(화이트/블랙)+규격=옵션, 자재유형 .05 원단([[#GP-BOM-001]] 과분할 금지). 진원 = v03 무변환 전파(loadlogic §1·line 326). Q-GP-2 컨펌(색×규격 2축 분리·글리터/멜란지 본체색 여부) 의존.
- 앵커: `t_prd_product_materials`(8행 → 2행) · `t_mat_materials.mat_typ_cd`(.09 → .05)
- 출처: `17_correctness/goods-pouch/correction-manifest.md` GP-C-03 + `loadlogic-notes.md` §1(L-GP-1) {tier C13, FRESH}
- 연결: [[#GP-BOM-001]] (정답 본체색=재질행 합성) · [[materials#MAT-004]] (과분할 금지) · [[materials#MAT-GAP-1]] (본체색 합성 vs 색=자재 통일)
- tags: #결함 #본체색 #폭증 #과분할 #교정대기

### [GP-ST-003] 자재유형 .09 무차별 오염 + 비-소재 값 자재화  {🔴 교정대기}
- 내용: 라이브 현재값 `MAT_TYPE.09(파우치)`가 티셔츠·핀버튼·만년스탬프·머그 등 무차별(GP-C-05) + 비-소재 값(핀버튼 형상·머그 11온스 용량·만년스탬프 잉크색)이 자재행(GP-C-04) → 정답 소재별 정확 MAT_TYPE(.05 원단·.04 금속·.02 필름) + 형상→t_siz_sizes·용량→비치수 siz·잉크색→t_clr/print_options([[#GP-BOM-002]]·[[#GP-BOM-003]]). 진원 = v03 `자재구분` 오기·무변환(loadlogic §1·line 237). 횡단 자재 오염([[materials#MAT-005]])의 굿즈 사례.
- 앵커: `t_mat_materials.mat_typ_cd`(.09 → 소재별) · 비-소재 → 정확 축(siz/clr)
- 출처: `17_correctness/goods-pouch/correction-manifest.md` GP-C-04·GP-C-05 + `loadlogic-notes.md` §1 {tier C13, FRESH}
- 연결: [[materials#MAT-005]] (오염 패턴 .07~.10) · [[#GP-BOM-002]] (정답 자재유형) · [[#GP-BOM-003]] (잉크색=도수)
- tags: #결함 #자재유형 #MAT_TYPE오염 #비소재자재화 #교정대기

### [GP-ST-004] 봉제→부착 공정 오적재 (캔버스 6상품)  {🔴 교정대기}
- 내용: 라이브 현재값 캔버스 파우치/필통/에코백 6상품 `PROC_000081 부착` → 정답 `PROC_000080 봉제`(D-24·패브릭→봉제미싱 §9·GP-C-06). 진원 = v03가 부착으로 적재·load_master 무변환 전파(loadlogic §4·line 415). 부착이 별개 의미면 보존(정체별 후가공). 봉제 자체 누락은 [[#GP-ST-005]].
- 앵커: `t_prd_product_processes.proc_cd`(PROC_000081 → PROC_000080)
- 출처: `17_correctness/goods-pouch/correction-manifest.md` GP-C-06 + `loadlogic-notes.md` §4 {tier C13, FRESH}
- 연결: [[#GP-BOM-003]] (정답 봉제 후가공) · [[processes#PRC-001]] (공정 마스터) · [[#GP-ST-005]]
- tags: #결함 #봉제 #부착오적재 #교정대기

### [GP-ST-005] 봉제/에폭시/맥세이프 공정 MISSING (0행)  {🔴 교정대기}
- 내용: 라이브 현재값 레더/타이벡/메쉬 파우치·말랑·폰케이스 공정 0행 → 정답 봉제(`PROC_000080`)·에폭시(`PROC_000083` b.12)·맥세이프(부속+부착) 신규 INSERT. 진원 = v03 `15_상품별공정`에 굿즈 공정 거의 부재(load_master는 없는 행 안 만듦·loadlogic §4). search-before-mint(PROC 기존행 우선). 신규 공정 신설 여부는 [[processes#PRC-GAP-2]] 인접·Q-GP-5(인쇄방식 root) 컨펌.
- 앵커: `t_prd_product_processes`(PROC_000080/083 → 굿즈)
- 출처: `17_correctness/goods-pouch/correction-manifest.md` GP-C-07 + `loadlogic-notes.md` §4(L-GP-4) {tier C13, FRESH}
- 연결: [[#GP-BOM-003]] (정답 후가공=공정) · [[processes#PRC-001]] (공정 마스터·배타) · [[processes#PRC-GAP-2]] (신규 공정 신설 미결)
- answers_cq: CQ-FIN-10 (굿즈 전용 후가공: 봉제미싱·에폭시·아크릴가공)
- tags: #결함 #공정 #봉제 #에폭시 #맥세이프 #MISSING #교정대기

### [GP-ST-006] CPQ 옵션 레이어 전면 미적재 (BATCH-6)  {🔴 미적재}
- 내용: 라이브 현재값 굿즈(183~290) `t_prd_product_option_groups`=**0행(정확)** → 정답 옵션 레이어(폰기종·등급·방향·구수·면·가공·addon) 적재 필요. 전역 6행은 굿즈 무관(PRD_000001/002 테스트 잔재·066 스티커·138 현수막). round-7 횡단 발견(option_items 거의 전역 0·R7 FAIL)의 굿즈 실증([[cpq-options#CPQ-008]]). CPQ는 load_master 범위 밖 — round-6 신규 트랙·Q-GP-1 선결.
- 앵커: `t_prd_product_option_groups`(굿즈 0행)
- 출처: `17_correctness/goods-pouch/product-identity.md` F-ID-4(굿즈 0·전역 6 재현) + `_gate/goods-pouch-gate.md` K4 재게이트 PASS {tier C13/A, FRESH}
- 연결: [[cpq-options#CPQ-008]] (전면 미적재) · [[cpq-options#CPQ-GAP-1]] (BATCH-6) · [[#GP-CPQ-001]] · [[#GP-ST-001]]
- tags: #결함 #CPQ미적재 #BATCH-6 #미적재

### [GP-ST-007] 추가상품(addon)·도수 링크 MISSING  {🔴 교정대기}
- 내용: 라이브 현재값 굿즈 `t_prd_product_addons`=0·`t_prd_product_print_options`=0 → 정답 addon 링크(볼체인 `PRD_000006`·리필잉크 `PRD_000015` 별 상품 재사용)·도수(만년스탬프 잉크색→clr/print_options·면→print_side). 진원 = v03 `16`/`20` 시트 굿즈 행 부재(loadlogic §5·L-GP-5). search-before-mint(대상 PRD 실재·mint 불요).
- 앵커: `t_prd_product_addons`(addon_prd_cd 0행) · `t_prd_product_print_options`(0행)
- 출처: `17_correctness/goods-pouch/correction-manifest.md` GP-C-08·GP-C-09 + `loadlogic-notes.md` §5(L-GP-5) {tier C13, FRESH}
- 연결: [[#GP-CPQ-002]] (정답 addon BUNDLE) · [[#GP-BOM-003]] (잉크색=도수)
- tags: #결함 #addon #도수 #MISSING #교정대기

### [GP-ST-008] 카테고리 고아 35상품 + 잉여 노드 6 (횡단 BATCH-1)  {🔴 교정대기}
- 내용: 라이브 현재값 굿즈 35상품이 고아 노드(upr NULL·lvl3)에 오연결 → 정답 개별 정상 노드 재연결(거울 5→CAT_000165~169·레더 9→CAT_000213~221 실재). 잉여 고아 노드 6개(CAT_000301/302/303/304/305/306) = 재연결 후 논리삭제 또는 부모 부여. 진원 = v03 카테고리 시트 빈 상위코드·load_master 무추론(loadlogic §3·L-GP-3). 횡단 패턴([[load-path#LP-GAP-3]] 113상품·9 family·BATCH-1)의 굿즈 사례. 일부 노드 처리(논리삭제 vs 부모부여 vs 보존)는 Q-GP-4 컨펌.
- 앵커: `t_prd_product_categories.cat_cd`(고아 → 정상 노드) · `t_cat_categories.upr_cat_cd`
- 출처: `17_correctness/goods-pouch/correction-manifest.md` GP-C-01·GP-C-02 + `product-identity.md` F-ID-1(라이브 분포 ORPHAN 35·NORMAL 56·ROOT 8) {tier C13, FRESH}
- 연결: [[load-path#LP-GAP-3]] (횡단 카테고리 고아·BATCH-1) · [[#GP-ID-001]]
- tags: #결함 #카테고리고아 #BATCH-1 #교정대기

### 7.3 GAP / 🔴 컨펌 (인간 결정 대기)

- **[GAP-GP-1] 🔴 폰기종·등급 size↔option 경계 (Q-GP-1·BATCH-6)** — 폰기종(아이폰15프로맥스 등)·사이즈등급(M/L/XL)을 size로 둘지 CPQ option 차원으로 둘지. 잠정 권고 = 옵션형은 `option_items`(ref_dim_cd)·치수형만 size. **기계적 size 삭제는 가격사슬 파손**. → [[#GP-ST-001]]·[[cpq-options#CPQ-GAP-1]].
- **[GAP-GP-2] 🔴 본체색×규격 2축 분리 (Q-GP-2)** — "블랙 XL"을 재질(블랙)×규격(XL) 2축으로 분리할지·글리터/멜란지=본체색 맞는지. 현 라이브=8행 직교 폭증. → [[#GP-ST-002]]·[[materials#MAT-GAP-1]].
- **[GAP-GP-3] 🔴 굿즈 가공 택일그룹 (Q-GP-3)** — 라벨/에폭시/맥세이프를 신규 택일그룹(GRP-GP-가공)으로 둘지 상품별 단순공정으로 둘지. **`excl_grp_cd` 컬럼은 sql/23에서 삭제됨**(Phase11) → 택일그룹 표현 방식 재검토([[processes#PRC-GAP-5]]·SEL_TYPE.01 단일선택). → [[#GP-ST-005]].
- **[GAP-GP-4] 🔴 잉여 고아 노드 처리 (Q-GP-4)** — CAT_000293~306을 (a) 재연결 후 논리삭제 (b) 부모 부여(upr=009/010/011) (c) 보존 중 무엇? digital-print Q-ID 동형. → [[#GP-ST-008]].
- **[GAP-GP-5] 🔴 인쇄방식 root PROC 귀속 (Q-GP-5)** — 인쇄방식 7종(이지굿즈 PVC고주파·만년도장·전사 외주·패브릭인쇄)을 어느 PROC root에 둘지·외주를 신규 mint할지 기존 트리 흡수할지. → [[processes#PRC-GAP-2]].

> 실 교정 COMMIT은 round-5/6/10 트랙 인간 승인 대기 — **DB 미적재 유지**([[load-path#LP-GAP-4]]). v03 상류 수정 vs DB 직접 교정 방향은 BATCH-12 선결([[load-path#LP-GAP-1]]).

---

## Sources
- **큐레이션 팩:** `_curation/pack-goods-pouch.md`(1차 권위·tier·freshness).
- **정체:** `17_correctness/goods-pouch/product-identity.md`(C13·FRESH) — 보조 `06_extract/goods-pouch-l1.csv`(B·103상품).
- **차원/BOM:** `15_domain-spec/goods-pouch/column-dictionary.md`·`product-bom.md`(C11·본체색=재질행 합성).
- **CPQ 옵션:** `10_configurator/huni-goods-option-mapping.md`·`wowpress-option-model.md`(C6·6축 흡수) + round-10 size→option.
- **가격:** `15_domain-spec/goods-pouch/column-dictionary.md` C23/C24 + `06_extract/goods-pouch-l1.csv`(가격포함 L1·B) + round-1 구간할인.
- **적재경로:** `17_correctness/goods-pouch/loadlogic-notes.md`(C13·file:line) + `raw/webadmin/sql/`·`tools/load_master.py`(로직만·A).
- **결함:** `17_correctness/goods-pouch/correction-manifest.md`·`live-diff.md`(C13) + `_gate/goods-pouch-gate.md`(K0~K6 GO).
- **위젯:** `huni-widget/03_spec/s5-goods-pouch-spec.md`·`data-contract.md`(D·FRESH).
- **축 페이지(횡단 참조):** `huni/{modeling-axioms,materials,processes,price-engine,cpq-options,widget-contract,load-path}.md`.
- **STALE(인용 0 확인):** `price-engine-ddl.md`([[price-engine#PE-STALE]])·`constraint_json`([[cpq-options#CPQ-STALE]])·`dep_proc_cd`·`excl_grp_cd`(Phase11 삭제)·v03 입력 xlsx([[load-path#LP-STALE]]) — 본 페이지 미인용.
