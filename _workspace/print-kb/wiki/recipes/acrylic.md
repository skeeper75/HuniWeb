# acrylic(아크릴) 레시피  {전체상태: 🟡}

> 조립 뷰. 횡단 사실은 축 페이지(`huni/<axis>.md`) 원자 항목을 `[[링크]] + 관계동사`로 참조만 하고 본문 복붙하지 않는다(README §3·§9). 레시피 고유 사실(아크릴 23등록+2미등록 상품 목록·교정대기 행)만 본문 원자 블록.
> 큐레이션 팩: `_curation/pack-acrylic.md`(1차 권위). round-13 게이트 GO(K0~K6 PASS·F-AC-G1/G2 카운트 보정 재게이트).
> **STALE/v03 인용 0**: 가격엔진 `price-engine-ddl.md`·v03 입력 xlsx·constraint_json·dep_proc_cd 인용 금지(축 STALE 블록 참조). 라이브 오적재는 7절 양면 표기(특히 UV print_side 오적재).

## CQ 헤더 (이 페이지가 답하는 질문)
- 아크릴은 무엇인가(굿즈 UV 평판인쇄 단품·23등록 PRD_000146~169) / 어떤 차원·옵션(두께=자재·형상=완칼 모양·UV 변형·조각수)이 있는가
- 가격은 어떻게 계산되는가(가로×세로 면적매트릭스·미러=투명×2) / DB에 어떻게 등록하는가
- 현재 라이브 적재 상태·교정 대기(UV 변형 print_side 오적재 20상품·완칼 전무·볼체인 소실 등)는 무엇인가
- 미결: UV print_side 일괄 교정(BATCH/CONFIRM-AC-4)·완칼 묵시 적재(CONFIRM-AC-1)·CPQ 미적재(BATCH-6)·★상품 정체(CONFIRM-AC-ID-1/2)

---

## 0. 정체 (identity) — 아크릴  앵커: t_prd_products · t_cat_categories

### [AC-ID-001] 아크릴 = UV 평판인쇄 디자인 굿즈·단품(카테고리 009)  {✅}
- 내용: 아크릴 시트 = **굿즈(액세서리 성격) 범주·단품**(낱장 아크릴 조각 굿즈). 카테고리 `009 아크릴`. 생산방식 = **UV 평판인쇄 단일**(폴더 `UV인쇄` 직생 또는 `루아샵` 외주 — 둘 다 UV 라인). 라이브 전수 `prd_typ_cd=PRD_TYPE.04(디자인상품)`·`MES_ITEM_CD=NULL`(load_master 의도). **정체 오분류 위험 낮음**(디지털인쇄 인쇄배경지가 포장재로 오분류된 함정과 달리, product-master·prd_typ_cd·L1 폴더 3원이 "UV 굿즈 단품"을 일관 확정). 조합형은 다조각 결합(조각수 variant)이나 **세트 SKU 묶음은 아님**.
- 앵커: `t_prd_products`(PRD_000146~169·167 결번) · `t_cat_categories`(009)
- 출처: `17_correctness/acrylic/product-identity.md` §0·§2(product-master.md:79·143-147·라이브 prd_typ_cd 실측) {tier C13, FRESH}
- 연결: [[../base/printing-methods#2-무판--디지털-인쇄]] (uses — UV 무판 인쇄 보편) · [[../huni/modeling-axioms#HMOD-01]] (uses — 인쇄방식≠최상위 축·시트=1차 단위)
- answers_cq: CQ-PROD-01 (상품 분류) · CQ-FIN-04 (UV평판인쇄 정의·대상소재 아크릴)
- tags: #아크릴 #정체 #UV굿즈 #단품 #009

### [AC-ID-002] 23등록 상품 목록 (단품형 14 + 조합형 9)  {✅}
- 내용: 라이브 등록 **23상품**(L1 25 = +★미등록 2). **단품형**: 키링146·마그넷147·뱃지148·집게149·스마트톡150·맥세이프톡151·명찰152·명찰(골드실버)153·머리끈154·볼펜155·지비츠156·네임택157·포카키링158·코스터159. **조합형**: 자유형스탠드160·판아크릴161·포카스탠드162·미니파츠163·코롯토164·포카코롯토165·카라비너166·입체코롯토168·입체블럭169. 비활성(`use_yn=N`): 153·156·159·164·165·166. 외주(루아샵): 164·165·166. **신규 ★미등록**(prd_cd 부재·L1 전행 숨김): 아크릴쉐이커★·지비츠★([[#AC-DEF-009]] 정체 컨펌).
- 앵커: `t_prd_products`(146~166·168·169) · `t_prd_product_processes`(UV root 공정)
- 출처: `17_correctness/acrylic/product-identity.md` §1 정체표(라이브 read-only psql 재현·use_yn/폴더 출처 동반) {tier C13, FRESH}
- 연결: [[#AC-ID-001]] · [[#AC-BOM-002]] (uses — UV 공정) · [[#AC-DEF-009]] (★상품 정체 컨펌)
- answers_cq: CQ-PROD-01 (상품 분류) · CQ-PROD-03 (완제품 귀속)
- tags: #아크릴 #prd_cd목록 #단품형 #조합형

---

## 1. 차원 (dimensions) — 아크릴  앵커: t_prd_product_sizes/bundle_qtys/sets · t_siz_sizes

### [AC-DIM-001] 두께 = 자재 식별자 (1.5/3/8mm·라미10T)  {✅}
- 내용: 아크릴 **두께는 자재(본체 아크릴)로 식별**한다(G-AC-3) — 별도 차원 컬럼이 아니라 mat_cd가 두께를 인코딩: 투명아크릴 1.5mm(`MAT_000042`, 미니파츠)·3mm(`MAT_000043`, 대부분)·8mm(`MAT_000044`, 코롯토/포카코롯토). 골드/실버 3mm(`MAT_000195/196`)는 색 variant 자재. 자재 모델 원칙은 [[../huni/materials#MAT-004]] **본체색=재질행 합성·과분할 금지**. round-3 라이브 22상품 192(두께없음) 일괄 적재 결함은 v03 시트 수정으로 042/043/044 구분 적재됨([[#AC-DEF-001]] 입체블럭 1상품만 192 잔존).
- 앵커: `t_mat_materials`(mat_typ_cd .03 아크릴·MAT_000042/043/044/195/196) · `t_prd_product_materials`
- 출처: `15_domain-spec/acrylic/product-bom.md` "BOM 횡단 본체 자재" 표·G-AC-3 + `17_correctness/acrylic/correction-manifest.md` AC-C1(CORRECT) {tier C11/C13, FRESH}
- 연결: [[../huni/materials#MAT-001]] (uses — 자재 마스터 구조) · [[../huni/materials#MAT-004]] (uses — 본체색 합성·과분할 금지) · [[../base/paper#BPP-005]] (uses — 비종이 소재=방식 종속)
- answers_cq: CQ-PROD-06 (variant 두께 → 차원 분해) · CQ-PROD-05 (자재 축)
- tags: #아크릴 #두께 #자재식별자 #G-AC-3

### [AC-DIM-002] 형상 = 완칼(die-cut) 모양 param·siz_nm 부기  {🟡}
- 내용: 아크릴 형상(원형/사각/하트/자물쇠 등)은 **완칼(레이저커팅 die-cut) 모양 param**으로 표현하고, 동일 치수 형상 2종 이상은 `siz_nm`에 형상을 부기한다(코스터 `100x100 원형`/`100x100 사각`·카라비너 4형상 `40x69 자물쇠`···). 형상부기 siz 보존은 라이브 정합(AC-C7 CORRECT). **단 완칼 공정 자체가 라이브 전 아크릴 0건**([[#AC-DEF-002]] MISSING) → 형상=완칼 모양 param도 미실현. 사이즈는 규격(이산) + 사용자입력(nonspec min/max, 12상품 적재).
- 앵커: `t_siz_sizes`(siz_nm 형상 부기) · `t_proc_processes`(PROC_000053 완칼 모양 param·미연결)
- 출처: `15_domain-spec/acrylic/product-bom.md` A14 코스터·B7 카라비너 형상 + `17_correctness/acrylic/correction-manifest.md` AC-C7(CORRECT)·AC-X1(완칼 MISSING) {tier C11/C13, FRESH}
- 연결: [[../base/sizes#BSZ-001]] (uses — 재단 사이즈 보편) · [[../huni/processes#PRC-004]] (uses — 완칼=순수공정) · [[#AC-BOM-003]] (완칼 공정) · [[#AC-DEF-002]] (완칼 전무 교정대기)
- answers_cq: CQ-PROD-06 (variant 형상 → 차원 분해)
- tags: #아크릴 #형상 #완칼 #siz_nm부기

### [AC-DIM-003] 조각수 = 묶음수 + 완칼 param (조합형만)  {🟡}
- 내용: 조합형(자유형스탠드 2~6조각·미니파츠 10조각)의 조각수 = **`t_prd_product_bundle_qtys`(묶음수·적재됨) + 완칼 조각수 param(prcs_dtl_opt·미실현)** 둘 다(Q8). bundle은 round-3 0행 → 자유형스탠드 5행·미니파츠 1행 적재됨(AC-C4 CORRECT). 단 완칼 process 자체가 0건이라 조각수 param 부재(AC-X6, 완칼 AC-X1 종속). 판걸이수(UV 평판 임포지션)는 [[../huni/price-engine#PE-010]] **앱 계산**(DB 미저장). 단품형=1조각(빈값).
- 앵커: `t_prd_product_bundle_qtys`(자유형스탠드/미니파츠) · prcs_dtl_opt.조각수(저장처 GAP)
- 출처: `15_domain-spec/acrylic/product-bom.md` B1·B4 조각수·"조각수(묶음수+공정param)" + `17_correctness/acrylic/correction-manifest.md` AC-C4(bundle CORRECT)·AC-X6(param MISSING) {tier C11/C13, FRESH}
- 연결: [[../huni/price-engine#PE-010]] (uses — 판수=앱 계산) · [[../huni/cpq-options#CPQ-GAP-2]] (requires — ref_param_json 미구현) · [[#AC-DEF-006]] (완칼 조각수 param 교정대기)
- answers_cq: CQ-PRICE-10 (판걸이수 영향)
- tags: #아크릴 #조각수 #bundle_qty #OM-7

---

## 2. 자재·공정 BOM — 아크릴  앵커: t_prd_product_materials/processes · t_mat_materials · t_proc_processes

### [AC-BOM-001] 본체+부속 자재 = parent + usage_cd (MAT_TYPE .03/.07)  {🟡}
- 내용: 아크릴 BOM = **본체 아크릴(MAT_TYPE.03, 두께별 mat_cd)** + **부속(MAT_TYPE.07, MAT_000045~057: 고리/자석/핀/집게/바디/끈/와이어링)**. 자재 모델은 [[../huni/materials#MAT-002]] **parent + usage_cd**(sub_prd 분해 없음 — 낱장 굿즈). 부속은 가공(C20) = 부속자재 + 부착공정 2축 동시([[#AC-BOM-004]]). **단 라이브 usage 미분화**(33행 전부 USAGE.07 공통 — 본체/부속 동일, [[#AC-DEF-003]] 교정대기) — 단 mat_typ_cd로 본체/부속 우회 식별 가능.
- 앵커: `t_mat_materials`(mat_typ_cd .03 본체·.07 부속) · `t_prd_product_materials`(mat_cd + usage_cd)
- 출처: `15_domain-spec/acrylic/product-bom.md` "공통 옵션 BOM"·"부속 자재" 표 + `17_correctness/acrylic/correction-manifest.md` AC-M2(usage 미분화) {tier C11/C13, FRESH}
- 연결: [[../huni/materials#MAT-001]] (uses — 자재 마스터 구조) · [[../huni/materials#MAT-002]] (uses — parent+usage_cd) · [[../huni/materials#MAT-003]] (uses — MAT_TYPE 코드도메인) · [[#AC-DEF-003]] (usage 미분화 교정대기)
- answers_cq: CQ-PROD-05 (자재 축) · CQ-TERM-04 (소재 약어)
- tags: #아크릴 #자재 #본체부속 #MAT_TYPE03_07

### [AC-BOM-002] 인쇄방식 = UV 평판인쇄 단일 (PROC_000002)  {✅}
- 내용: 아크릴 인쇄방식 = **UV 평판인쇄 단일**(`PROC_000002`) — 스티커(5분기)·실사(소재정체)와 정반대. 폴더 UV인쇄(직생)·루아샵(외주) 둘 다 UV 라인. UV는 풀컬러 4도 단일이므로 **도수 개념 약함**(굿즈는 단/양면 면 개념 약함). 라이브 14상품 연결됨(round-3 1상품 → 14, AC-C3 CORRECT) — 단 활성 머리끈154·입체블럭169 UV 미연결([[#AC-DEF-005]] MISSING). UV는 박/코팅과 같은 **공정**([[../huni/processes#PRC-005]] 실무진 확정).
- 앵커: `t_prd_product_processes`(PROC_000002 UV) · `t_proc_processes`
- 출처: `15_domain-spec/acrylic/product-bom.md` §0·"공정" 표 + `17_correctness/acrylic/correction-manifest.md` AC-C3(UV 14 CORRECT) {tier C11/C13, FRESH}
- 연결: [[../huni/processes#PRC-001]] (uses — 공정 마스터·연결 구조) · [[../huni/processes#PRC-005]] (uses — UV=공정 PROC_000002 실무진확정) · [[../base/printing-methods#2-무판--디지털-인쇄]] (uses — UV 무판 보편)
- answers_cq: CQ-PROC-01 (공정 라우트) · CQ-FIN-04 (UV평판인쇄 정의·변형)
- tags: #아크릴 #UV #PROC_000002 #단일인쇄방식

### [AC-BOM-003] 완칼(die-cut) = 형상 굿즈 묵시 필수 (PROC_000053)  {🟡}
- 내용: 아크릴 굿즈는 **완칼(레이저커팅 die-cut, `PROC_000053`)이 도메인상 묵시 필수**(모양대로 절단·G-AC-1) — 엑셀 명시 컬럼 없어도 적용. 형상 굿즈(키링/뱃지/스탠드/코스터/카라비너 등)에 + prcs_dtl_opt 모양 param. 순수공정 패턴([[../huni/processes#PRC-004]] — 부착 자재 없음). **판아크릴161·입체코롯토168·입체블럭169 제외**(단순 판/입체 블록 — 모양 절단 불요, round-3 over-reach 보정·CONFIRM-AC-2). **단 라이브 전 아크릴 완칼 0건**([[#AC-DEF-002]] BLOCKER급 MISSING) — 묵시 모델링 컨펌(CONFIRM-AC-1) 선행.
- 앵커: `t_proc_processes`(PROC_000053 완칼·모양 param) · `t_prd_product_processes`
- 출처: `15_domain-spec/acrylic/product-bom.md` §0(공통 레시피)·B2 over-reach 주의 + `17_correctness/acrylic/correction-manifest.md` AC-X1(완칼 0건)·CONFIRM-AC-1 {tier C11/C13, FRESH}
- 연결: [[../huni/processes#PRC-004]] (uses — 완칼=순수공정·자재없음) · [[../base/finishing#BFN-005]] (uses — 도무송/타공 후가공 보편) · [[#AC-DIM-002]] (형상=완칼 모양) · [[#AC-DEF-002]] (완칼 전무 교정대기)
- answers_cq: CQ-PROC-01 (공정 라우트) · CQ-FIN-01 (후가공 공정 목록)
- tags: #아크릴 #완칼 #die-cut #묵시필수 #G-AC-1

### [AC-BOM-004] 부착공정 = 부속자재 + 부착 2축 BUNDLE (PROC_000081)  {🟡}
- 내용: 부속(맥세이프/자석/핀/끈/집게)은 **부속자재(MAT_TYPE.07) + 부착공정(`PROC_000081`, 대상 enum) 2축 동시** = [[../huni/cpq-options#CPQ-005]] BUNDLE 원칙(옵션=자재+공정). 라이브 부착 = 맥세이프151·마그넷147 2상품만(AC-X2 부분 MISSING) — 나머지 부속 상품(뱃지/명찰/집게/머리끈/네임택)·카라비너 고리7색 미연결([[#AC-DEF-004]]·[[#AC-DEF-007]]). 대상 enum에 핀/자석/집게 부재 → enum 확장 컨펌(CONFIRM-AC-3). 볼펜대 6색·지비츠 타입·바디 등은 부속 vs variant 분기 컨펌(AC-A3).
- 앵커: `t_proc_processes`(PROC_000081 부착·대상 param) · `t_prd_product_materials`(부속 MAT_000045~057)
- 출처: `15_domain-spec/acrylic/product-bom.md` "부속 자재"·"공정" 표·Q5 운영원칙 + `17_correctness/acrylic/correction-manifest.md` AC-X2/X4/X5/A3 {tier C11/C13, FRESH}
- 연결: [[../huni/cpq-options#CPQ-005]] (uses — 옵션=자재+공정 BUNDLE) · [[../huni/processes#PRC-004]] (uses — 순수공정 대비) · [[../huni/materials#MAT-001]] (uses — 부속 자재 마스터) · [[#AC-DEF-004]] (부착 부분 교정대기)
- answers_cq: CQ-PROC-01 (공정 라우트) · CQ-PROD-05 (옵션 축)
- tags: #아크릴 #부착 #PROC_000081 #BUNDLE

---

## 3. 가격 사슬 (price chain) — 아크릴  앵커: t_prc_* 4단 + t_dsc_*

### [AC-PRC-001] 가격 = 가로×세로 면적매트릭스 (전 아크릴 통용·미러=투명×2)  {🟡}
- 내용: 아크릴 가격 = **[가로][세로] 면적 매트릭스**, 단가표 B01 헤더 "투명아크릴3T 양면9도/단면7도 통용 단가 · 아크릴 모든 상품에 적용"(가로/세로 그리드, 예 `20mm 가로 × 20mm 세로 = 2500원`). [[../huni/price-engine#PE-006]] **면적매트릭스형 + off-grid ceiling**(격자에 없는 크기는 한 단계 큰 크기 가격)에 정합(`t_prc_component_prices` siz 차원). **미러(거울) 가격 = 투명 × 2**(면적매트릭스 동형, 가격수식81). 실사·포스터사인과 동일 모델([[#AC-PRC-002]] silsa 동형 마이그레이션 권위). 수량구간 할인은 [[../huni/price-engine#PE-008]] `t_dsc_*`(아크릴 카테고리 단위).
- 앵커: `t_prc_component_prices`(siz 차원 [가로][세로]) + 면적공식 + ceiling · `t_dsc_*`
- 출처: `06_extract/price-acrylic-price-l1.csv` B01([가로][세로] 통용단가·"모든 상품에 적용") {tier B, FRESH} + 큐레이션 팩 stale §3(미러=투명×2)
- 연결: [[../huni/price-engine#PE-006]] (priced-by — 면적매트릭스형) · [[../huni/price-engine#PE-008]] (priced-by — 수량구간 할인) · [[../base/sizes#BSZ-001]] (uses — 가로×세로 치수) · [[#AC-PRC-002]]
- answers_cq: CQ-PRICE-05 (면적 기반 가로×세로 계산) · CQ-PRICE-01 (단가표 vs 공식)
- tags: #아크릴 #가격 #면적매트릭스 #미러투명x2

### [AC-PRC-002] 면적매트릭스 적재 = silsa-poster 동형 마이그레이션  {🟡}
- 내용: 아크릴 면적매트릭스의 적재 구조는 **실사 포스터사인 면적매트릭스와 동형**(`02_mapping/silsa-poster-area-matrix/` + `09_load/_migrate_areamatrix/` 권위 — siz 신규등록 + component_prices long-format). 가격 차원의 라이브 실재 위치 = `t_prc_component_prices`(siz_cd) + 단가유형 `t_prc_price_components.prc_typ_cd`(현 라이브 전부 .01 단가형). **`price-engine-ddl.md`는 STALE — 인용 금지**([[../huni/price-engine#PE-STALE]] round-2 좌표 회귀 모델 인용 금지). 가격공식 멱등 PK = (prd_cd, apply_bgn_ymd)([[../huni/price-engine#PE-003]]).
- 앵커: `t_prc_component_prices`(siz 차원) · `t_prc_price_components.prc_typ_cd`
- 출처: `02_mapping/silsa-poster-area-matrix/mapping.md` + `09_load/_migrate_areamatrix/MIGRATION.md`(동형 권위) + `18_schema-change/impact-diagnosis.md` I-1·I-3(차원 stale) {tier C/A, 면적모델 FRESH·차원 PARTIAL-STALE I-1·I-3}
- 연결: [[../huni/price-engine#PE-006]] (uses — 면적매트릭스 적재) · [[../huni/price-engine#PE-001]] (uses — t_prc_* 4단·차원) · [[../huni/price-engine#PE-STALE]] (STALE 금지) · [[#AC-PRC-001]]
- answers_cq: CQ-PRICE-05 (면적 계산) · CQ-PRICE-08 (견적 합산)
- tags: #아크릴 #가격적재 #silsa동형 #면적매트릭스

---

## 4. CPQ 옵션 레이어 — 아크릴  앵커: t_prd_product_option_groups/options/option_items · constraints · templates

### [AC-CPQ-001] 옵션축(UV변형·완칼모양·부속·조각수) → 4엔티티 매핑  {🟡}
- 내용: 아크릴 옵션성 축(인쇄사양 UV 변형·완칼 모양·부속 가공·조각수·볼체인 addon)은 [[../huni/cpq-options#CPQ-004]] **속성→4엔티티 지도**로 분기: UV변형/완칼/부착=공정(L1)·본체+부속=mat_cd+usage·형상=완칼 모양 param·조각수=bundle_qty+param·볼체인=addon(template). 면적형 패밀리(silsa·acrylic) `인쇄사양`은 도수/공정 `[CONFIRM]`, `조각수(옵션)`은 공정+param `GAP-PARAM`(attribute-entity-map §③). `option_items`는 polymorphic `ref_dim_cd`로 L1 차원행 참조([[../huni/cpq-options#CPQ-002]]), 무결성은 트리거 `fn_chk_opt_item_ref`([[../huni/cpq-options#CPQ-003]]) 강제 → 차원행 선적재 필수. **단 아크릴 CPQ 레이어 전면 미적재**([[#AC-DEF-008]]).
- 앵커: `t_prd_product_option_items.ref_dim_cd` · `t_prd_product_option_groups`
- 출처: `10_configurator/attribute-entity-map.md` §114-124(패밀리③ 실사·아크릴 면적형) {tier C, PARTIAL-STALE(I-5·I-9)}
- 연결: [[../huni/cpq-options#CPQ-004]] (uses — 속성→4엔티티) · [[../huni/cpq-options#CPQ-002]] (uses — polymorphic ref_dim_cd) · [[../huni/cpq-options#CPQ-003]] (requires — 무결성 트리거) · [[#AC-DEF-008]] (CPQ 미적재)
- answers_cq: CQ-PROD-05 (옵션 축·캐스케이드)
- tags: #아크릴 #CPQ #속성매핑 #4엔티티

### [AC-CPQ-002] 볼체인 addon = template 경로 (Phase7 tmpl_cd 구조)  {🔴 교정대기}
- 내용: 키링146·포카키링158의 볼체인(9색)은 **추가상품 addon**(`PRD_000006`)이나, Phase7 마이그레이션이 `t_prd_product_addons`를 `addon_prd_cd`→`tmpl_cd`(template 참조)로 재구조화하면서 **라이브 addon 0행 소실**([[#AC-DEF-007]] REMOVED). 정답 = PRD_000006 master 건재 → 볼체인 template 신설(`t_prd_templates`, 현 11행=테스트3+봉투류8·볼체인 0) 후 재연결(search-before-mint·hard-delete 금지). 9색은 template 색 variant vs addon 분기 컨펌(CONFIRM-AC-6). 제약은 [[../huni/cpq-options#CPQ-007]] `constraints.logic`(JSONLogic, `constraint_json`은 삭제 STALE [[../huni/cpq-options#CPQ-STALE]]).
- 앵커: `t_prd_product_addons`(prd_cd·tmpl_cd) · `t_prd_templates`(볼체인 template 미신설)
- 출처: `17_correctness/acrylic/correction-manifest.md` AC-R1·CONFIRM-AC-6 + `loadlogic-notes.md` §1 addons(Phase7 D-AC-5) {tier C13, FRESH}
- 연결: [[../huni/cpq-options#CPQ-006]] (uses — OTC TEMPLATE 구조) · [[../huni/cpq-options#CPQ-007]] (uses — constraints.logic) · [[../huni/cpq-options#CPQ-STALE]] (STALE 금지) · [[#AC-DEF-007]] (볼체인 소실)
- answers_cq: CQ-PROD-05 (옵션 축·추가상품)
- tags: #아크릴 #볼체인 #addon #template #교정대기

---

## 5. 위젯 계약 (widget contract) — 아크릴  앵커: 정규화 계약(huni-widget 03_spec) — DB 외 앵커

### [AC-WID-001] 위젯은 정규화 계약 의존 (DB 독립·어댑터 경계)  {⚪}
- 내용: 아크릴 위젯은 후니 DB 스키마가 아닌 **정규화 데이터 계약**(상품·옵션·가격 안정 shape)에 의존([[../huni/widget-contract#WID-001]]). 옵션축(두께·형상·UV변형·부속·조각수)→14 componentType→shadcn 매핑([[../huni/widget-contract#WID-003]]). DB 확정 시 후니 어댑터만 교체([[../huni/widget-contract#WID-002]]) → 위젯 코어 불변. 아크릴 위젯 스펙(`huni-widget/03_spec/s4-acryl-spec.md`)이 보조 권위. 면적매트릭스 가격은 가로×세로 입력 UX ≠ 가격격자(silsa 교훈) — 옵션 캐스케이드 Zustand·Edicus 브리지([[../huni/widget-contract#WID-004]]).
- 앵커: DB 외 — `huni-widget/03_spec/s4-acryl-spec.md`·`data-contract.md`(어댑터 경계에서 t_*로)
- 출처: `huni-widget/03_spec/s4-acryl-spec.md`(축 WID-001 경유) {tier D, FRESH}
- 연결: [[../huni/widget-contract#WID-001]] (mapped-to — 정규화 계약) · [[../huni/widget-contract#WID-002]] (mapped-to — 어댑터) · [[../huni/widget-contract#WID-003]] (mapped-to — componentType) · [[../huni/widget-contract#WID-004]] (mapped-to — 캐스케이드·Edicus)
- answers_cq: CQ-PROD-05 (옵션 축 shape) · CQ-PROD-08 (UI 노출)
- tags: #아크릴 #위젯 #정규화계약 #DB독립

### [AC-WID-002] 가격 권위 = 서버 (PRICE=0 불가 신호)  {⚪}
- 내용: 아크릴 위젯 가격은 **서버 권위 + 클라 캐싱**([[../huni/widget-contract#WID-005]]). 후니 가격은 가격엔진 축([[../huni/price-engine#PE-006]] 면적매트릭스) 권위. RedPrinting PRICE=0은 절대 불가 — 0은 우리측 요청/세션 결함 신호(Red 역산값 후니 이식 금지 [[../huni/widget-contract#WID-STALE]]).
- 앵커: DB 외 — 서버 가격 API(후니 가격=t_prc_* 면적매트릭스)
- 출처: `huni-widget/03_spec/price-engine.md`(축 WID-005 경유) {tier D, FRESH(후보)}
- 연결: [[../huni/widget-contract#WID-005]] (priced-by — 서버 가격권위) · [[../huni/price-engine#PE-006]] (priced-by — 면적매트릭스) · [[../huni/widget-contract#WID-STALE]]
- answers_cq: CQ-PRICE-01 (가격 권위=서버)
- tags: #아크릴 #위젯 #가격권위 #PRICE0불가

---

## 6. 적재 레시피 (load path) — 아크릴  앵커: raw/webadmin sql/tools · round-8 admin-ui-spec

### [AC-LP-001] 적재 oracle = load_master(v03 전파기) · 진원=상류 v03  {🟡}
- 내용: 아크릴 라이브 값 = `tools/load_master.py`(527 LOC, "Phase 4 single-pass loader")가 v03 통합시트(`14_상품별자재`·`15_상품별공정`·`16_상품별인쇄옵션` 등)를 전 상품 공통 처리한 직접 결과(도메인 변환 거의 없음). **load_master는 v03 전파기** — 라이브 결함 대부분이 상류 v03 정규화 결함(두께 소실·완칼 미부여·usage 빈값), 단 line 357-369 ACRYLIC 하드코딩은 결함을 **증폭**(D-AC-1, [[#AC-DEF-001]]). **[HARD] v03 입력 xlsx 인용 금지**([[../huni/load-path#LP-STALE]]) — 정답 기준 = 상품정체(실제 사이트) > 상품마스터 L1. round-3 이후 라이브가 v03 시트 수정으로 두께/UV/부속/nonspec 상당 부분 자가교정됨(loadlogic-notes §4).
- 앵커: `raw/webadmin/tools/load_master.py`(로직만 oracle·line 357-369·324·404-421) · `sql/01a~23`
- 출처: `17_correctness/acrylic/loadlogic-notes.md` §0·§1·§3 (file:line) {tier C13/A, FRESH}
- 연결: [[../huni/load-path#LP-001]] (loaded-via — 적재 oracle) · [[../huni/load-path#LP-STALE]] (v03 금지) · [[#AC-DEF-001]]
- answers_cq: CQ-PROD-01 (적재 기준) · CQ-FILE-05 (적재 입력값)
- tags: #아크릴 #적재 #load_master #v03전파기

### [AC-LP-002] FK 위상순서·멱등 UPSERT·search-before-mint  {🟡}
- 내용: 아크릴 적재 = [[../huni/load-path#LP-003]] **FK 위상순서**(코드행 → 카테고리/자재/공정 마스터 → 상품 → 상품-자식). 멱등 = 이름 기반 UPSERT([[../huni/load-path#LP-004]]). 교정 재연결 대상(완칼 PROC_000053·UV PROC_000002·부속 MAT_000045~057·볼체인 PRD_000006·두께 MAT_000042/044) **전부 라이브 master 실재** → 신규 mint 0(search-before-mint 충족·게이트 K5 입증). 신규 mint 후보 = 라미10T 자재(입체블럭·CONFIRM-AC-A1)·카라비너 고리 5색·본체/부속 USAGE 코드(ddl-proposer 라우팅). 입력경로 = admin product-viewer pvEdit([[../huni/load-path#LP-006]]) — 단 "컬럼 존재 ≠ 백필 완료".
- 앵커: `t_cod_base_codes`(upr_cod_cd 계층) · `13_admin-ui-spec/`
- 출처: `17_correctness/_gate/acrylic-gate.md` K5(search-before-mint 실재 입증) + `17_correctness/acrylic/correction-manifest.md` §7 라우팅 {tier C13, FRESH}
- 연결: [[../huni/load-path#LP-003]] (loaded-via — FK 위상·코드행 선적재) · [[../huni/load-path#LP-004]] (loaded-via — 멱등 UPSERT) · [[../huni/load-path#LP-006]] (loaded-via — admin 입력경로)
- answers_cq: CQ-FILE-05 (적재 입력값)
- tags: #아크릴 #FK위상 #멱등 #search-before-mint

---

## 7. 현황·결함 (state) — 아크릴

> round-13 게이트 GO(K0~K6 PASS·F-AC-G1 print_side 22→20·F-AC-G2 UV 16→14 카운트 보정 재게이트). 라이브 = 교정대상(피고). 아래 양면표기는 `17_correctness/acrylic/correction-manifest.md`·`live-diff.md` 대조분만(미대조 라이브값 인용 금지 — G-1/F-PB-1 교훈). 분류 분포(14 finding): CORRECT 8·MIS-LOADED 3·MISSING 6·REMOVED 1·AMBIGUOUS 4(결함성 ID 6류). round-3 이후 라이브가 두께/UV/부속/조각수/nonspec/qty_unit 상당 부분 자가교정됨.

### 7.1 라이브 오적재 양면표기 (라이브 현재값 ↔ 정답)

| ID | 항목 | 라이브 현재값 | 정답 | 상태 | 출처(correction-manifest) |
|---|---|---|---|---|---|
| AC-DEF-001 | UV 변형 적재 위치(20상품) | `t_prd_product_print_options.print_side`에 배면양면/풀빼다/투명테두리 3행 하드코딩(도수 c4/c0 쌍) | UV 변형 → `t_prd_product_processes`(PROC_000002) + prcs_dtl_opt `변형` param·print_side=실제 단/양면(또는 비움) | 🔴 교정대기(High·MIS-LOADED) | AC-M1·M3 |
| AC-DEF-002 | 완칼(PROC_000053) | 전 아크릴 0건 | 형상 굿즈에 PROC_000053(묵시 필수)+모양 param(판161·입체168/169 제외) | 🔴 교정대기(BLOCKER급·MISSING·CONFIRM-AC-1) | AC-X1 |
| AC-DEF-003 | usage 분화(33행) | 전부 `USAGE.07`(공통·본체/부속 동일) | 본체/부속 usage 분화(단 본체·부속 USAGE 코드 부재→신설 컨펌) | 🔴 교정대기(Medium·mat_typ 우회 가능) | AC-M2·CONFIRM-AC-usage |
| AC-DEF-004 | 부착공정(PROC_000081) | 맥세이프151·마그넷147 2상품만 | 부속 상품(뱃지/명찰/집게/머리끈/네임택)에 부착+대상 param(enum 확장) | 🔴 교정대기(Medium·MISSING) | AC-X2·CONFIRM-AC-3 |
| AC-DEF-005 | 활성상품 UV(머리끈154·입체블럭169) | PROC_000002 0행(use_yn=Y) | UV 필수(머리끈=변형 일반·입체블럭=UV+라미) | 🔴 교정대기(High·MISSING) | AC-X3 |
| AC-DEF-006 | 완칼 조각수 param(자유형160·미니파츠163) | bundle 적재됨이나 완칼 param 부재 | bundle_qty + 완칼 조각수 param 둘 다(AC-X1 종속) | 🔴 교정대기(Low) | AC-X6 |
| AC-DEF-007 | 볼체인 addon(키링146·포카키링158) | addon **0행**(Phase7 미이관 소실) | PRD_000006 볼체인+9색(template 신설 후 재연결·hard-delete 금지) | 🔴 재연결 제안(Medium·REMOVED) | AC-R1·CONFIRM-AC-6 |
| AC-DEF-010 | 입체블럭169 두께 | `MAT_000192`(두께없음 투명아크릴 폴백) | 라미10T 자재(master 부재→mint vs 192 유지 컨펌) | 🔴 교정대기(AMBIGUOUS) | AC-A1·CONFIRM-AC-A1 |

> **정합(CORRECT·유지):** AC-C1 두께 042/043/044(round-3 192 일괄 교정됨)·AC-C2 부속 다행·AC-C3 UV 14상품·AC-C4 조각수 bundle·AC-C5 nonspec 12상품·AC-C6 qty_unit QTY_UNIT.01(backfill)·AC-C7 형상 siz 부기·AC-C8 size 차원(작업>재단). (이 8건은 양면표기 불요 — 라이브=정답.)

### 7.2 횡단 결함 참조 (축 페이지 권위)

### [AC-DEF-001] UV 변형 print_side 오적재 (20상품·상품별 무시)  {🔴 교정대기}
- 내용: 라이브 현재값 = print_option 보유 **20상품**(146~153·155~166) `print_side`에 `배면양면·풀빼다·투명테두리` 3행 하드코딩(각 변형 20건씩·도수 c4 4도/c0 0도 쌍) → 정답 = UV 변형은 `PROC_000002` 변형 param([[../huni/processes#PRC-007]]·[[../huni/processes#PRC-005]]). **print_side(`sql/01b:108` "인쇄면 단/양면")는 UV 변형 슬롯 아님** — 의미축 오적재. load_master:359 하드코딩이 v03 DEFAULT 1행을 전 상품 동일 전개 → **상품별 변형 진실 소실**(L1: 마그넷=단면인쇄/투명테두리/풀빼다·명찰=풀빼다만·키링=배면양면만). 제외 3상품(머리끈154·입체코롯토168·입체블럭169)=print_option 0행. UV 출력은 풀컬러 4도 단일이라 도수 슬롯 부적합. 검증된 카운트=print_side 20·UV 14(F-AC-G1/G2 보정 재게이트). 일괄 교정 PROC_000002는 CONFIRM-AC-4 컨펌 대기.
- 앵커: `t_prd_product_processes`(PROC_000002 변형 param) vs `t_prd_product_print_options.print_side` 오적재
- 출처: `17_correctness/acrylic/correction-manifest.md` AC-M1·M3 + `loadlogic-notes.md` §1·§2 D-AC-1(load_master:357-369) + `_gate/acrylic-gate.md` K4 재게이트 {tier C13, FRESH}
- 연결: [[../huni/processes#PRC-007]] (라이브 권위 — UV print_side 오적재) · [[../huni/processes#PRC-005]] (UV=공정 정답) · [[../huni/materials#MAT-005]] (오적재 동형 패턴)
- answers_cq: CQ-FIN-04 (UV 변형 5종) · CQ-FIN-03 (별색=공정)
- tags: #결함 #UV #print_side #오적재 #교정대기

### [AC-DEF-002] 완칼(PROC_000053) 전 아크릴 0건 MISSING (묵시 필수 위반)  {🔴 교정대기}
- 내용: 라이브 현재값 = 완칼/반칼/스티커완칼(053/054/055) 아크릴 0건 → 정답 = 형상 굿즈에 PROC_000053(완칼·묵시 필수 die-cut)+모양 param. 진원 = v03 `15_상품별공정` 시트 완칼 행 미부여(load_master 충실 전파·D-AC-3). master PROC_000053(`모양 string`) 건재 — 연결만 결손(search-before-mint 충족). **판아크릴161·입체코롯토168·입체블럭169 제외**(round-3 over-reach 보정·단순 판/입체). 위젯 "모양/완칼" 옵션 통째 부재 = BLOCKER급. 묵시 모델링 컨펌(CONFIRM-AC-1) 선행.
- 앵커: `t_prd_product_processes`(PROC_000053 → 형상 굿즈·미연결)
- 출처: `17_correctness/acrylic/correction-manifest.md` AC-X1·CONFIRM-AC-1 + `loadlogic-notes.md` §1 D-AC-3 {tier C13, FRESH}
- 연결: [[#AC-BOM-003]] (정답 완칼=묵시 필수) · [[#AC-DIM-002]] (형상=완칼 모양) · [[../huni/processes#PRC-004]] (순수공정)
- tags: #결함 #완칼 #MISSING #BLOCKER급 #교정대기

### [AC-DEF-003] usage 미분화 (33행 전부 USAGE.07)  {🔴 교정대기}
- 내용: 라이브 현재값 = 아크릴 33 material 행 전부 `USAGE.07`(공통·본체/부속 동일) → 정답 = 본체/부속 usage 분화(단 라이브 USAGE 코드에 본체·부속 자체 부재 — 내지/표지/면지/공통뿐). 진원 = v03 `14_상품별자재` 시트 `용도` 빈값 → load_master:324 `용도 or 공통` 폴백(D-AC-2). **mat_typ_cd로 본체(.03)/부속(.07) 우회 식별 가능** → 즉시 견적 결함 아님(Medium). 본체/부속 USAGE 코드 신설은 굿즈 전 family 영향 → CONFIRM-AC-usage.
- 앵커: `t_prd_product_materials.usage_cd`(전 USAGE.07)
- 출처: `17_correctness/acrylic/correction-manifest.md` AC-M2 + `loadlogic-notes.md` §1 D-AC-2(line 324) {tier C13, FRESH}
- 연결: [[#AC-BOM-001]] (정답 본체/부속 usage 분화) · [[../huni/materials#MAT-002]] (parent+usage_cd) · [[../huni/materials#MAT-GAP-2]] (코드 신설)
- tags: #결함 #usage #USAGE07 #교정대기

### [AC-DEF-004] 부착공정(PROC_000081) 부분 적재 (맥세이프·마그넷만)  {🔴 교정대기}
- 내용: 라이브 현재값 = 부착공정 맥세이프151·마그넷147 2상품만 → 정답 = 부속 상품(뱃지/명찰/집게/머리끈/네임택)·카라비너 고리7색에 PROC_000081 + 대상 param. 진원 = v03 `15` 시트가 나머지 부속에 부착 행 미부여(D-AC-6). 대상 enum(라벨/맥세이프/끈/테입)에 핀/자석/집게 부재 → enum 확장 또는 기존 매핑 컨펌(CONFIRM-AC-3). 부속 자재(이미 적재)와 2축 BUNDLE([[#AC-BOM-004]]).
- 앵커: `t_prd_product_processes`(PROC_000081 → 부속 상품 일부만)
- 출처: `17_correctness/acrylic/correction-manifest.md` AC-X2/X4/X5·CONFIRM-AC-3 {tier C13, FRESH}
- 연결: [[#AC-BOM-004]] (부착=자재+공정 BUNDLE) · [[../huni/cpq-options#CPQ-005]] (BUNDLE 원칙)
- tags: #결함 #부착 #PROC_000081 #부분적재 #교정대기

### [AC-DEF-005] 활성상품 UV 미연결 (머리끈154·입체블럭169)  {🔴 교정대기}
- 내용: 라이브 현재값 = 머리끈154·입체블럭169(둘 다 use_yn=Y) PROC_000002 0행 → 정답 = 활성 상품 UV 필수(머리끈=변형 일반·입체블럭=UV+라미). 진원 = v03 `15` 시트가 이 상품에 UV 행 미부여(D-AC-6). 머리끈은 인쇄사양 공백(=일반)이라 누락된 듯하나 UV 출력 자체는 필요. 입체블럭은 라미 자재([[#AC-DEF-010]])와 연동.
- 앵커: `t_prd_product_processes`(PROC_000002 → 154/169 미연결)
- 출처: `17_correctness/acrylic/correction-manifest.md` AC-X3 + `loadlogic-notes.md` §1 D-AC-6 {tier C13, FRESH}
- 연결: [[#AC-BOM-002]] (정답 UV 공정) · [[#AC-DEF-010]] (입체블럭 라미 연동)
- tags: #결함 #UV #미연결 #교정대기

### [AC-DEF-006] 완칼 조각수 param 부재 (자유형160·미니파츠163)  {🔴 교정대기}
- 내용: 라이브 현재값 = bundle_qty 적재됨(자유형 2~6·미니파츠 10)이나 완칼 process 자체 0건이라 조각수 param 부재 → 정답 = bundle_qty(적재됨) + 완칼/스티커완칼 조각수 param 둘 다(Q8). 완칼 process 미적재([[#AC-DEF-002]])의 종속 결함 — AC-X1 해소 시 함께 적재(자유형=2~6·미니파츠=10). 판수(판걸이수)는 [[../huni/price-engine#PE-010]] 앱 계산(DB 미저장).
- 앵커: `t_prd_product_bundle_qtys`(적재됨) + prcs_dtl_opt.조각수(부재)
- 출처: `17_correctness/acrylic/correction-manifest.md` AC-X6 {tier C13, FRESH}
- 연결: [[#AC-DIM-003]] (조각수=묶음수+param) · [[#AC-DEF-002]] (완칼 종속) · [[../huni/cpq-options#CPQ-GAP-2]] (ref_param_json)
- tags: #결함 #조각수 #완칼param #교정대기

### [AC-DEF-007] 볼체인 addon 소실 REMOVED (Phase7 미이관)  {🔴 교정대기}
- 내용: 라이브 현재값 = 키링146·포카키링158 addon 0행(round-3엔 PRD_000006 볼체인 1행씩 있었음) → 정답 = PRD_000006 볼체인+9색 재연결. 진원 = Phase7 마이그레이션이 `t_prd_product_addons`를 `addon_prd_cd`→`tmpl_cd` 재구조화하며 구 볼체인 행 미이관(볼체인 전용 template 부재·D-AC-5). **hard-delete 아님 — 미이관 복원**(PRD_000006 master use_yn=Y 건재·search-before-mint). 볼체인 template 신설(`t_prd_templates`) 후 재연결. 9색=variant vs addon 컨펌(CONFIRM-AC-6).
- 앵커: `t_prd_product_addons`(prd_cd·tmpl_cd) · `t_prd_templates`(볼체인 미신설)
- 출처: `17_correctness/acrylic/correction-manifest.md` AC-R1 + `loadlogic-notes.md` §1 addons(D-AC-5) {tier C13, FRESH}
- 연결: [[#AC-CPQ-002]] (볼체인 template 경로) · [[../huni/cpq-options#CPQ-006]] (OTC TEMPLATE 구조)
- tags: #결함 #볼체인 #addon #REMOVED #교정대기

### [AC-DEF-008] CPQ 옵션 레이어 전면 미적재 (BATCH-6)  {🔴 미적재}
- 내용: 라이브 현재값 아크릴 CPQ option_items 0행(전 family 18행은 silsa 파일럿뿐, [[../huni/cpq-options#CPQ-008]]) → 정답 = 아크릴 옵션 레이어(두께·UV변형·완칼 모양·부속·조각수·볼체인) 적재 필요. BATCH-6 일괄 적재 미결.
- 앵커: `t_prd_product_option_items`(아크릴 0행)
- 출처: `17_correctness/_gate/acrylic-gate.md` §10 + 축 [[../huni/cpq-options#CPQ-008]](라이브 18행 CONF-1) {tier A/C13, FRESH}
- 연결: [[../huni/cpq-options#CPQ-008]] (전면 미적재) · [[../huni/cpq-options#CPQ-GAP-1]] (BATCH-6) · [[#AC-CPQ-001]]
- tags: #결함 #CPQ미적재 #BATCH-6 #미적재

### [AC-DEF-009] ★상품·입체류 정체 미확정 (4건 컨펌)  {🔴 미결정}
- 내용: 라이브 현재값 = 쉐이커★·지비츠★ 미등록(prd_cd 부재·L1 전행 숨김)·입체코롯토168 전 속성 0행·입체블럭169 UV/완칼 미연결 → 정답 미확정(추측 단정 금지). 쉐이커★·지비츠★ = 출시 예정 등록 vs 영구 보류(CONFIRM-AC-ID-1). 입체코롯토168·입체블럭169 = 루아샵 외주 명세 확보 후 속성 적재(CONFIRM-AC-ID-2). 정체 컨펌 전 등록/적재 보류(EXTRA 삭제단정 금지).
- 앵커: `t_prd_products`(쉐이커★/지비츠★ 미등록·168/169 속성 0행)
- 출처: `17_correctness/acrylic/product-identity.md` §3 + `correction-manifest.md` AC-A2·A4·CONFIRM-AC-ID-1/2 {tier C13, FRESH}
- 연결: [[#AC-ID-002]] (23등록+2미등록) · [[#AC-DEF-010]] (입체블럭 두께)
- tags: #결함 #정체미확정 #★상품 #입체류 #컨펌

### [AC-DEF-010] 입체블럭169 두께 192 폴백 (라미10T 자재 부재)  {🔴 교정대기}
- 내용: 라이브 현재값 = 입체블럭169 `MAT_000192`(두께없음 투명아크릴 폴백) → 정답 후보 = L1 소재 `투명아크릴라미(10T)`(라미네이트 10mm 입체 블록). **master에 아크릴 라미 자재 부재** → v03이 192 폴백(D-AC-4·AMBIGUOUS). 라미10T 전용 자재 mint(MAT_TYPE.03) vs 192 유지+두께/가공 속성축 컨펌(CONFIRM-AC-A1). 입체블럭 정체 자체도 미확정([[#AC-DEF-009]] CONFIRM-AC-ID-2).
- 앵커: `t_mat_materials`(MAT_000192 폴백 → 라미10T 자재 미신설)
- 출처: `17_correctness/acrylic/correction-manifest.md` AC-A1·CONFIRM-AC-A1 + `loadlogic-notes.md` §1 D-AC-4 {tier C13, FRESH}
- 연결: [[#AC-DIM-001]] (두께=자재 식별자) · [[#AC-DEF-009]] (입체블럭 정체) · [[../huni/materials#MAT-GAP-2]] (자재 신설)
- tags: #결함 #입체블럭 #라미10T #AMBIGUOUS #교정대기

### 7.3 GAP / 🔴 컨펌 (인간 결정 대기)

- **[GAP-AC-1] 🔴 UV 변형 print_side → PROC_000002 일괄 교정 (CONFIRM-AC-4·BATCH)** — [[#AC-DEF-001]]. UV 변형을 print_side에서 PROC_000002 변형 param으로 옮기고 print_side 정정/비움? 상품별 L1 변형 적재. → [[../huni/processes#PRC-007]].
- **[GAP-AC-2] 🔴 완칼 묵시 적재 (CONFIRM-AC-1)** — [[#AC-DEF-002]]. 완칼(PROC_000053)을 형상 굿즈에 묵시 적재? 판/입체류(161/168/169) 제외 확인. → [[../huni/processes#PRC-004]] (완칼 PROC_000053=순수공정 die-cut 축).
- **[GAP-AC-3] 🔴 CPQ 옵션 레이어 일괄 적재 (BATCH-6)** — [[#AC-DEF-008]]. → [[../huni/cpq-options#CPQ-GAP-1]].
- **[GAP-AC-4] 🔴 가공 부속 귀속·대상 enum 확장 (CONFIRM-AC-3)** — 부착 부속(고리/자석/핀/집게/끈)=자재+부착공정 2축, 볼펜색/지비츠타입/바디=variant 분기? 대상 enum(핀/자석/집게) 확장. → [[#AC-BOM-004]].
- **[GAP-AC-5] 🔴 볼체인 9색 재연결 (CONFIRM-AC-6)** — [[#AC-DEF-007]]. addon 1+색 variant vs 볼체인 template 신설. → [[#AC-CPQ-002]].
- **[GAP-AC-6] 🔴 본체/부속 USAGE 코드 신설 (CONFIRM-AC-usage)** — [[#AC-DEF-003]]. 현 내지/표지/공통에 본체·부속 코드 신설 vs mat_typ_cd 우회(굿즈 전 family 영향). → [[../huni/materials#MAT-GAP-2]].
- **[GAP-AC-7] 🔴 라미10T 자재 mint·★상품 정체 (CONFIRM-AC-A1·ID-1·ID-2)** — [[#AC-DEF-010]]·[[#AC-DEF-009]]. 입체블럭 라미10T mint vs 192 유지·★상품 출시 등록 vs 보류·입체류 외주 명세.

> 실 교정 COMMIT은 round-5/10 트랙 인간 승인 대기 — **DB 미적재 유지**([[../huni/load-path#LP-GAP-4]]).

---

## Sources
- **큐레이션 팩:** `_curation/pack-acrylic.md`(1차 권위·tier·freshness).
- **정체:** `17_correctness/acrylic/product-identity.md`(C13·FRESH·실제 사이트+product-master 권위 0) — 보조 `06_extract/acrylic-l1.csv`(B·25상품).
- **차원/BOM:** `15_domain-spec/acrylic/column-dictionary.md`·`product-bom.md`(C11·두께자재·UV·완칼·부속) · `mapping-info.md`.
- **가격:** `06_extract/price-acrylic-price-l1.csv`(B·B01 [가로][세로] 통용단가) + `02_mapping/silsa-poster-area-matrix/`·`09_load/_migrate_areamatrix/`(면적매트릭스 동형 적재 권위·FRESH).
- **CPQ:** `10_configurator/attribute-entity-map.md` §③(실사·아크릴 면적형·PARTIAL-STALE I-5·I-9).
- **위젯:** `huni-widget/03_spec/s4-acryl-spec.md`(D·FRESH) + `data-contract.md`.
- **적재경로:** `17_correctness/acrylic/loadlogic-notes.md`(C13·file:line·load_master 357-369/324/404-421) + `raw/webadmin/sql/`·`tools/load_master.py`(로직만·A).
- **결함:** `17_correctness/acrylic/correction-manifest.md`·`live-diff.md`(C13·14 finding) + `17_correctness/_gate/acrylic-gate.md`(K0~K6 GO·F-AC-G1/G2 보정).
- **축 페이지(횡단 참조):** `huni/{materials,processes,price-engine,cpq-options,widget-contract,load-path}.md`.
- **STALE(인용 0 확인):** `price-engine-ddl.md`([[../huni/price-engine#PE-STALE]] round-2 좌표 회귀)·`constraint_json`([[../huni/cpq-options#CPQ-STALE]])·`dep_proc_cd`·v03 입력 xlsx([[../huni/load-path#LP-STALE]]) — 본 페이지 미인용.
