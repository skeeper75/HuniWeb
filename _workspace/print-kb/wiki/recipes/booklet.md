# 책자(booklet) 레시피  {전체상태: 🟡}

> 조립 뷰(README §3·§9). 횡단 사실은 축 페이지를 `[[링크]] + 관계동사`로 참조만 한다(본문 복붙 금지). 이 페이지 고유 사실(prd_cd 목록·교정대기 행)만 원자 블록으로 둔다.
> **권위:** 정체 = `17_correctness/booklet/product-identity.md`(C13, FRESH) · 차원/BOM = `15_domain-spec/booklet/`(C11)·`16_mapping-research/booklet/mapping-final.md`(C12) · 결함 = `17_correctness/booklet/correction-manifest.md`(C13)·`_gate/booklet-gate.md`(GO). 큐레이션 팩 = `_curation/pack-booklet.md`.
> **STALE 금지:** `price-engine-ddl.md`(price-engine [PE-STALE])·v03 입력 xlsx([[huni/load-path#LP-STALE]]) 인용 0. 라이브 오적재는 "라이브 현재값 → 정답" 양면 표기(7절).

---

## CQ 헤더 (이 페이지가 답하는 질문)

- 책자는 무엇인가 — 어떤 상품(중철/무선/PUR/트윈링/하드커버/레더/링바인더/엽서북/떡메모지)이고 어떤 생산구조(A통합·B셋트·떡제본)인가.
- 어떤 차원·옵션이 있는가 — 사이즈·page_rule·묶음수·내지/표지 자재 슬롯·제본/코팅/박/형압 공정.
- 가격은 어떻게 계산되는가 — 제본비 합산형(PRF_BIND_SUM)·떡제본 고정가형.
- DB에 어떻게 등록하는가 — webadmin sql/tools 적재 경로·FK 위상.
- 현재 라이브 적재 상태·교정 대기는 무엇인가 — BK-1~BK-CAT 교정대기 + 컨펌 Q-BK-A~E.

---

## 0. 정체 (identity) — 책자
앵커: `t_prd_products` · `t_cat_categories` · `t_prd_product_sets`

### [BK-ID-001] 책자 = 10 활성 완제품 + 21 반제품 (PRD_000068~098)  {✅}
- 내용: 책자 family는 **10 활성 완제품**(중철 PRD_000068·무선 069·PUR 070·트윈링 071·하드커버 072·레더하드커버 077·하드커버링 082·레더링바인더 088·엽서북 094·떡메모지 097) + **21 반제품(sub_prd, PRD_TYPE.02)**. 라이브 PRD_000068~098 = PRD_TYPE.04×10 + PRD_TYPE.02×21. round-11 "11상품"은 **보류중 링바인더(라이브 미적재 정상)** 포함 수치 — 활성은 10. URL 가이드행 R85는 상품 아님(제외).
- 앵커: `t_prd_products`(prd_typ_cd .04 완제품·.02 반제품)
- 출처: `17_correctness/booklet/product-identity.md` §0·§1(F-ID-0·F-GATE-BK-1) {tier C(round-13), FRESH·라이브 GROUP BY 재현}
- 연결: [[#BK-ID-002]] · [[huni/load-path#LP-001]] (loaded-via — load_master 10_상품정보 시트)
- answers_cq: CQ-PROD-01 (상품 분류·적재 기준)
- tags: #책자 #정체 #완제품10 #반제품21

### [BK-ID-002] 생산구조 3종 (A통합·B셋트·떡제본)  {✅}
- 내용: 책자 정체의 핵심은 **생산구조 3종**. **A 통합**(중철/무선/PUR/트윈링) = 내지(USAGE.01)+표지(USAGE.02) parent 자재, sets=0. **B 셋트**(하드커버/레더하드/하드링/레더바인더) = 내지 parent + 표지=반제품(sub_prd USAGE.02) + 면지(USAGE.03), sub_prd+sets 병행 적재. **떡제본**(엽서북/떡메모지) = 권 묶음. **[HARD] 자재 권위는 항상 parent + usage_cd** — B셋트라도 sub_prd 9속성 0행=정상([BK-DEF-001 BK-2 예외 주의]).
- 앵커: `t_prd_product_sets`(B셋트 sub_prd 연결) · `t_prd_product_materials`(usage_cd 슬롯)
- 출처: `15_domain-spec/booklet/product-bom.md` §0 + `17_correctness/booklet/product-identity.md` §3 + 메모리 `dbmap-round3-mapping-audit`(K-1~5 photobook 엑셀 제본대로) {tier C, FRESH}
- 연결: [[huni/materials#MAT-002]] (uses — parent+usage_cd 모델) · [[huni/cpq-options#CPQ-006]] (uses — sets=OTC 묶음)
- answers_cq: CQ-PROD-11 (묶음/세트 판매 단위) · CQ-PROD-03 (반제품 귀속)
- tags: #책자 #생산구조 #A통합 #B셋트 #떡제본

### [BK-ID-003] 책자는 정체 오분류 0 (결함은 속성축·카테고리 위계)  {✅}
- 내용: 책자 10 완제품은 전부 일반 인쇄물 책자 범주(`CAT_000006 책자` 트리 또는 `CAT_000026 엽서북`/`CAT_000124 노트` 하위). digital-print(인쇄배경지=포장재 오분류)·goods-pouch 같은 **정체 오분류는 책자에 없다**(F-ID-1 의심 반증). 결함은 ① 카테고리 연결 위계(전용 잎노드 고아 [BK-DEF-005]) ② 속성축 오적재(레더 자재·sub_prd·page_rule)에 집중.
- 앵커: `t_cat_categories`(CAT_000006 책자 트리)
- 출처: `17_correctness/booklet/product-identity.md` F-ID-1 + `_gate/booklet-gate.md` K0 PASS {tier C(round-13), FRESH}
- 연결: [[#BK-DEF-005]] (BK-CAT 카테고리 위계 결함) · [[huni/load-path#LP-GAP-3]] (카테고리 고아 횡단)
- answers_cq: CQ-PROD-01 (상품 분류)
- tags: #책자 #정체오분류0 #반증

---

## 1. 차원 (dimensions) — 책자
앵커: `t_prd_product_sizes`/`plate_sizes`/`bundle_qtys`/`page_rules` · `t_siz_sizes`

### [BK-DIM-001] 사이즈 = 재단치수 + 책등(두께)  {🟡}
- 내용: 책자 사이즈는 `t_prd_product_sizes.siz_cd → t_siz_sizes`(A5 SIZ_000170·A4 SIZ_000172/258 등). **하드커버링/레더바인더의 책등(두께)은 별도 size로 미적재** — 두께A/B는 제본 `prcs_dtl_opt.책등mm` 또는 D링 mm(USAGE.07 부속 variant)로 교차 표현(중복 size 등록 불요, 컨펌 Q-BK-E). 작업치수(내지/표지 펼침)는 `t_prd_product_plate_sizes.siz_cd`로 별도 적재.
- 앵커: `t_prd_product_sizes.siz_cd` · `t_prd_product_plate_sizes.siz_cd`
- 출처: `16_mapping-research/booklet/mapping-final.md` C5·C8·C20(🟡) + 메모리 `dbmap-platesize-is-output-paper` {tier C(round-12), FRESH}
- 연결: [[base/sizes#BSZ-001]] (uses — 재단/작업/출력판형 보편 구분) · [[#BK-DEF-007]] (Q-BK-E 책등 모델 컨펌)
- answers_cq: CQ-PROD-06 (variant 사이즈 → 차원 분해) · CQ-PROD-07 (선택 가능 사이즈 목록·비규격 사용자입력 허용 여부)
- tags: #책자 #사이즈 #책등 #두께

### [BK-DIM-002] page_rule = 제본별 차등 (떡메모지는 묶음수)  {🟡}
- 내용: `t_prd_product_page_rules`(page_min/max/incr)는 제본별 차등 — **중철 4~28·증가4(4배수 규칙)**·무선/PUR 24~300·증가2·트윈링/하드링 8~100·증가2. **엽서북=page 활성**(20~30·증가10=엽서 장수). **떡메모지=page 무의미** → 진짜 축은 묶음수(권). page_rule은 앱 계산(임포지션) 입력이 아니라 주문 제약치.
- 앵커: `t_prd_product_page_rules`(page_min/max/incr)
- 출처: `16_mapping-research/booklet/mapping-final.md` C15~17 + `15_domain-spec/booklet/product-bom.md` §1·§11 {tier C, FRESH·라이브 실측 일치}
- 연결: [[base/binding#BBD-001]] (uses — 시그니처=제본 단위) · [[#BK-DIM-003]] · [[#BK-DEF-005]] (BK-8 떡메모지 page_rule 잡음)
- answers_cq: CQ-PROD-01 (페이지 룰 적재 기준)
- tags: #책자 #page_rule #4배수 #제본별차등

### [BK-DIM-003] 묶음수(권) = 떡메모지/엽서북  {✅}
- 내용: 떡메모지(PRD_000097)는 **묶음수(QTY_UNIT.03 권) = 50장1권·100장1권**(`t_prd_product_bundle_qtys.bdl_qty`, bdl_unit_typ_cd=QTY_UNIT.03). page_rule이 아니라 묶음수가 주문 권위 축. 떡제본의 1차 차원.
- 앵커: `t_prd_product_bundle_qtys`(bdl_qty·bdl_unit_typ_cd=QTY_UNIT.03)
- 출처: `16_mapping-research/booklet/mapping-final.md` C36 + `15_domain-spec/booklet/product-bom.md` §11 {tier C, FRESH·PRD_000097 50/100 라이브 적재}
- 연결: [[#BK-DIM-002]] · [[#BK-PRC-002]] (priced-by — 떡제본 고정가)
- answers_cq: CQ-PROD-11 (묶음 판매 단위)
- tags: #책자 #묶음수 #권 #떡메모지

---

## 2. 자재·공정 BOM — 책자
앵커: `t_prd_product_materials`/`processes` · `t_mat_materials` · `t_proc_processes`

### [BK-BOM-001] 자재 usage 슬롯 = 내지.01·표지.02·면지.03·투명커버.05·링/D링.07  {🟡}
- 내용: 책자 자재는 usage_cd 슬롯으로 구분 — **내지(USAGE.01)**(`*별도설정` 공통풀·몽블랑240·백모조120)·**표지(USAGE.02)**(`*별도설정`·전용지·레더·스노우300)·**면지(USAGE.03)**(화이트/블랙/그레이/인쇄면지, MAT_TYPE.01 종이 MAT_000001~004)·**투명커버(USAGE.05)**(MAT_TYPE.02 필름 MAT_000244/245)·**링/D링(USAGE.07)**(링=MAT_TYPE.04 금속 MAT_000013~015·D링=MAT_TYPE.07 부속 MAT_000247~249). 링/D링/투명커버는 **전부 자재**(Q5 확정 — 공정 아님).
- 앵커: `t_prd_product_materials.usage_cd` · `t_mat_materials.mat_typ_cd`
- 출처: `16_mapping-research/booklet/mapping-final.md` ★3·★4·C13/24/33/34/35 {tier C(round-12), FRESH·라이브 실측}
- 연결: [[huni/materials#MAT-001]] (uses — 자재 마스터·usage_cd 구조) · [[huni/materials#MAT-002]] (uses — parent+usage_cd) · [[huni/cpq-options#CPQ-005]] (requires — 부속=옵션 자재축)
- answers_cq: CQ-PROD-05 (상품별 자재 축) · CQ-TERM-04 (소재 약어)
- tags: #책자 #자재 #usage슬롯 #면지 #링

### [BK-BOM-002] 공정 = 제본(PROC_000017 자식)·코팅·박/형압·포장  {🟡}
- 내용: 책자 공정 — **제본**(PROC_000017 자식 7종, 상품=제본 1:1, mand_proc_yn=N)·**코팅**(PROC_000014 유광/PROC_000015 무광, 부모 PROC_000013, **코팅=공정** Q9 정합)·**박**(PROC_000033 family·박색 8종 자식 PROC_000037~044=홀로그램/금유광/은유광/먹유광/동박/적박/청박/트윙클, **박색=공정 자식·자재 아님** Q2★)·**형압**(PROC_000050 양각051/음각052)·**포장**(PROC_000076 수축포장). 책자 코팅은 자재 오적재(스티커/포토북) 동형이 **아니다** — 공정으로 정합(Q9 기준점).
- 앵커: `t_proc_processes`(PROC_000017/013/033/050/075 family) · `t_prd_product_processes`
- 출처: `16_mapping-research/booklet/mapping-final.md` C26/28/30/31/42 + `17_correctness/booklet/correction-manifest.md` BK-10·BK-12 {tier C(round-12/13), FRESH·라이브 실측}
- 연결: [[huni/processes#PRC-005]] (uses — 박/코팅=공정 실무진확정) · [[huni/processes#PRC-006]] (코팅 CONFLICT — 책자는 공정 측 기준점) · [[base/finishing#BFN-004]] (uses — 박 보편 정의) · [[base/binding#BBD-003]] (uses — 제본 방식)
- answers_cq: CQ-FIN-01 (후가공 공정 목록) · CQ-FIN-05 (박 vs 형압 vs 별색금 구별) · CQ-PROC-06 (제본 N종 물리 차이·각자 필요 기초데이터 책등/링/면지 — BOM-001 자재 슬롯 교차)
- tags: #책자 #공정 #제본 #박색공정 #코팅공정

### [BK-BOM-003] 박 크기→등급 = 앱 계산 (DB 미저장)  {🟡}
- 내용: 박/형압 크기(mm)는 `prcs_dtl_opt`에 입력 UX로 저장되나, **박 면적→등급은 앱 런타임 계산**(DB는 등급별 가격만). 스키마에 등급 컬럼이 없는 것은 GAP이 아니라 "앱 계산".
- 앵커: (DB 외 — 앱 계산) · 입력 = `t_proc_processes.prcs_dtl_opt`(박 크기 mm)
- 출처: `15_domain-spec/booklet/product-bom.md` "미저장(앱 런타임)" + `16_mapping-research/booklet/mapping-final.md` C29 {tier C, FRESH}
- 연결: [[huni/price-engine#PE-010]] (uses — 박 등급=앱 계산 동일 철학)
- answers_cq: CQ-PRICE-06 (후가공 가산 단가)
- tags: #책자 #박등급 #앱계산

---

## 3. 가격 사슬 (price chain) — 책자
앵커: `t_prc_*` 4단(`t_prd_product_price_formulas`→components→component_prices)

### [BK-PRC-001] 제본 합산형 — PRF_BIND_SUM + COMP_BIND_* (일반책자·하드커버)  {🟡}
- 내용: 책자 가격은 **제본비 합산형**(원자합산형). 일반책자(068~071)는 **PRF_BIND_SUM 이미 라이브 바인딩**. 제본비 단가 `t_prc_component_prices`는 **이미 전부 적재**(중철 COMP_BIND_JUNGCHEOL·무선 COMP_BIND_MUSEON·트윈링 COMP_BIND_TWINRING·PUR COMP_BIND_PUR 각 8행 / 하드커버무선 COMP_BIND_HC_MUSEON·하드커버트윈링 COMP_BIND_HC_TWINRING·싸바리 COMP_BIND_SSABARI 각 6행). 하드커버(072/077/082)는 제본비 단가는 적재됐고 **상품→공식 바인딩만 추가**하면 됨(binding-only INSERTABLE).
- 앵커: `t_prd_product_price_formulas`(PRF_BIND_SUM) + `t_prc_component_prices`(COMP_BIND_*)
- 출처: `02_mapping/price211-booklet-photobook/mapping.md` §0.1·§0.2(라이브 실측·값 verbatim) + `06_extract/price-binding-l1.csv`(B01·B02 제본비) {tier B/C, 라이브 실측 FRESH·차원컬럼 PARTIAL-STALE I-1·I-2}
- 연결: [[huni/price-engine#PE-005]] (priced-by — 원자합산형) · [[huni/price-engine#PE-001]] (uses — t_prc 4단)
- answers_cq: CQ-PRICE-08 (견적 합산 공식) · CQ-PRICE-01 (단가표 vs 공식)
- tags: #책자 #가격 #합산형 #PRF_BIND_SUM #제본비

### [BK-PRC-002] 떡제본 고정가형 — PRF_PCB_FIXED(엽서북 적재)·떡메모지(공식 미바인딩)  {🟡}
- 내용: 떡제본은 **고정가형**(수량×옵션 격자 룩업). 엽서북(PRD_000094) = **PRF_PCB_FIXED + component_prices 이미 적재**(PRD_000094 바인딩 라이브 확인. component_prices는 COMP_PCB 4컴포넌트×117 = 라이브 468행 — 인용 소스 "234행"은 4중 2개[S1_20P+S2_20P]만 집계한 소스 정밀도 차이). 떡메모지(PRD_000097)는 **라이브 현재값 = 가격공식 미바인딩**: 공식 **마스터** `t_prc_price_formulas`에는 `PRF_TTEOKME_FIXED`가 **실재**(`SELECT frm_cd FROM t_prc_price_formulas WHERE frm_cd ILIKE '%TTEOK%'` → 1행)하나, **바인딩 테이블** `t_prd_product_price_formulas`에 PRD_000097 **바인딩 0행**(`SELECT count(*) FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000097'` → 0). `t_prc_component_prices`에 **COMP_TTEOKME 112행 단가도 존재** → **정답 = PRF_TTEOKME_FIXED 바인딩만 적재 필요(공식 신설 불요·바인딩 미적재)**. 인용 소스 `mapping.md` L124의 "PRF_TTEOKME_FIXED ✓"는 라이브 미확인 — 그 "✓"가 라이브 갭을 은폐했음(F-PB-1 동형). 일반책자는 PRF_BIND_SUM 적재 완료(가격사슬 부재 6상품군 [PE-GAP-3]에 책자 미포함이나, 떡메모지 공식 바인딩만 미적재).
- 앵커: 공식 마스터 `t_prc_price_formulas`(PRF_PCB_FIXED·PRF_TTEOKME_FIXED 둘 다 실재) / 바인딩 `t_prd_product_price_formulas`(PRD_000094 PRF_PCB_FIXED 바인딩됨 / PRD_000097 미바인딩) · `t_prc_component_prices`(COMP_TTEOKME 112행 단가)
- 출처: `02_mapping/price211-booklet-photobook/mapping.md` §0.1(엽서북) + `06_extract/price-postcard-book-l1.csv` + `_qa/booklet-gate.md` F-BK-1(라이브 실측 떡메모지 미바인딩) {tier B/C, 엽서북 FRESH·떡메모지 양면표기(라이브 갭)}
- 연결: [[huni/price-engine#PE-007]] (priced-by — 고정가형) · [[#BK-DIM-003]] (uses — 묶음수 격자)
- answers_cq: CQ-PRICE-01 (가격 공식 계산)
- tags: #책자 #가격 #고정가형 #떡제본 #엽서북

### [BK-PRC-003] 레더 링바인더(088) 가격 BLOCKED (제본종류 미상)  {🔴}
- 내용: 레더 링바인더(PRD_000088)는 제본 합산형 바인딩 대상이나 **제본종류 미상으로 BLOCKED**(제본 family 미연결 [BK-PRC-003]). 가격 공식 바인딩 보류 — 088 후공정/제본 귀속 컨펌(Q-BK-D) 선행.
- 앵커: `t_prd_product_price_formulas`(PRD_000088 미바인딩 BLOCKED)
- 출처: `02_mapping/price211-booklet-photobook/mapping.md` §0.3(BLOCKED 제본종류 미상) {tier C, FRESH}
- 연결: [[#BK-DEF-007]] (BK-6 088 공정 0행) · [[huni/price-engine#PE-009]] (상품별 공식 후보)
- tags: #책자 #가격BLOCKED #레더링바인더 #088

---

## 4. CPQ 옵션 레이어 — 책자
앵커: `t_prd_product_option_groups`/`options`/`option_items` · `constraints` · `templates`

### [BK-CPQ-001] 책자 option_groups 0행 (제본 택일그룹 불요·CPQ 전면 미적재)  {🔴 미적재}
- 내용: **라이브 현재값: 책자 option_groups 0행** → 정답: 책자는 **상품=제본 1:1**(중철책자→중철제본)이라 제본 택일그룹(GRP-BOOK-제본) **불요**(현 1:1 모델이 정상). round-11/intent-map의 GRP-BOOK-제본 택일 가정은 철회. 단 코팅/박/면지/링컬러 등 표지 옵션은 CPQ 옵션 레이어로 표현 가능하나 **전 family CPQ 전면 미적재**(silsa 파일럿만)와 정합 — 일괄 적재 미결(BATCH-6).
- 앵커: `t_prd_product_option_groups`(라이브 0행)
- 출처: `16_mapping-research/booklet/mapping-final.md` ★7·GAP-OG + `17_correctness/booklet/correction-manifest.md` BK-9 {tier C(round-12/13), FRESH·라이브 0행}
- 연결: [[huni/cpq-options#CPQ-008]] (CPQ 전면 미적재 silsa 파일럿만) · [[huni/cpq-options#CPQ-GAP-1]] (BATCH-6 일괄 적재 미결)
- answers_cq: CQ-PROD-05 (선택 옵션 축·캐스케이드)
- tags: #책자 #CPQ미적재 #제본1대1 #BATCH-6

### [BK-CPQ-002] 표지 옵션 = 자재+공정 BUNDLE 후보 (투명커버·링·면지)  {🟡}
- 내용: 책자 표지 옵션은 CPQ 적재 시 BUNDLE 원칙 적용 대상 — **투명커버**(USAGE.05 필름 자재 + 부착 공정)·**링/D링**(USAGE.07 부속 자재 + 결합)·**인쇄면지**(하드링/레더바인더 조건부 → constraints 캐스케이드). 옵션을 공정만/자재만으로 반쪽 매핑 금지.
- 앵커: `t_prd_product_option_items`(다중 seq) · `t_prd_product_constraints.logic`(인쇄면지 조건)
- 출처: `16_mapping-research/booklet/mapping-final.md` C27/33/34/35(★인쇄면지=조건부) {tier C, FRESH}
- 연결: [[huni/cpq-options#CPQ-005]] (uses — BUNDLE 자재+공정) · [[huni/cpq-options#CPQ-007]] (requires — 인쇄면지 캐스케이드 constraints.logic) · [[huni/cpq-options#CPQ-STALE]] (constraint_json 삭제 — logic 단일경로)
- answers_cq: CQ-FIN-10 (옵션=자재+공정)
- tags: #책자 #CPQ #BUNDLE #투명커버 #인쇄면지

---

## 5. 위젯 계약 (widget contract) — 책자
앵커: 정규화 계약(`huni-widget/03_spec/`) — DB 외 앵커임을 명시

### [BK-WID-001] 책자 위젯 = 정규화 계약 일반형 (전용 스펙 부재)  {⚪ 명세}
- 내용: 책자는 **전용 위젯 스펙이 없다**(아크릴·굿즈파우치·캘린더만 family 스펙 존재). 책자 위젯은 데이터계약 일반형 + 후니 어댑터로 도출(위젯 코어 불변). page_rule(증가 규칙)·제본 택1·표지 옵션 캐스케이드는 componentType 매핑으로, 가격은 서버 권위(PRICE=0 불가).
- 앵커: DB 외 — `huni-widget/03_spec/data-contract.md`(일반형) · 어댑터 경계
- 출처: `huni-widget/03_spec/data-contract.md` + [[huni/widget-contract#WID-GAP-3]](family 스펙 존재분) {tier D, FRESH}
- 연결: [[huni/widget-contract#WID-001]] (mapped-to — 정규화 계약) · [[huni/widget-contract#WID-003]] (mapped-to — 14 componentType) · [[huni/widget-contract#WID-005]] (priced-by — 서버 가격권위)
- answers_cq: CQ-PROD-08 (상품-카테고리 UI 노출) · CQ-PRICE-01 (가격 권위=서버)
- tags: #책자 #위젯 #정규화계약 #전용스펙부재

---

## 6. 적재 레시피 (load path) — 책자
앵커: `raw/webadmin/sql/*`·`tools/load_master.py` · round-8 `13_admin-ui-spec/`

### [BK-LP-001] 책자 적재 = load_master 10_상품정보 + 11~21 relation 시트  {🟡}
- 내용: 책자는 `load_master.py` `run_all()` 단일 트랜잭션으로 적재 — 10_상품정보(완제품+sub_prd) + relation 시트(11 카테고리·12 묶음수·13 사이즈·14 자재[usage_cd]·15 공정[mand_proc_yn]·17 판형·19 셋트·21 페이지룰). **[HARD] load_master는 순수 전파기** — 입력 v03 xlsx 인용 금지(진원=상류 v03 정규화·정답=상품마스터 L1). 멱등=이름 기반 UPSERT·search-before-mint.
- 앵커: `raw/webadmin/tools/load_master.py`(L250~447 함수군, 로직만) · `13_admin-ui-spec/`
- 출처: `17_correctness/booklet/loadlogic-notes.md` §0(테이블↔함수 매핑) {tier A/C, FRESH(HEAD)·로직만 oracle}
- 연결: [[huni/load-path#LP-001]] (loaded-via — 적재 oracle) · [[huni/load-path#LP-003]] (uses — FK 위상순서) · [[huni/load-path#LP-004]] (uses — 멱등 search-before-mint) · [[huni/load-path#LP-STALE]] (v03 입력 금지)
- answers_cq: CQ-PROD-01 (상품 적재 기준) · CQ-FILE-01 (운영자 입력경로)
- tags: #책자 #적재 #load_master #v03전파기

### [BK-LP-002] 적재 결함 진원 = v03 정규화 (LL-1~6) · 교정 = L1 권위 델타  {🟡}
- 내용: 책자 적재 결함 LL-1~6(usage.07 종이 떨굼·레더 .08·plate NULL·078 sub_prd 자재·088 공정 0행·카테고리 2중)은 **전부 load_master 코드 결함이 아니라 v03 정규화 결함**(load_master는 충실 전파). 교정 = v03 행 직접 수정이 아니라 **상품마스터 L1 권위 델타**(round-5/6 + 인간 승인). LL-7(option_groups)만 적재 경로 부재(CPQ 별 트랙).
- 앵커: `raw/webadmin/tools/load_master.py`(L324/237/346/318/404/282) · 정답 = `06_extract/booklet-l1.csv`
- 출처: `17_correctness/booklet/loadlogic-notes.md` §2(LL-1~7 file:line) {tier A/C, FRESH}
- 연결: [[huni/load-path#LP-STALE]] (v03 진원) · [[#BK-DEF-001]] (교정대기 양면표기)
- answers_cq: CQ-PROD-01 (적재 기준)
- tags: #책자 #적재결함 #v03진원 #L1권위델타

---

## 7. 현황·결함 (state) — 책자

### 적재 현황
- **GO분 적재됨:** 책자 10 완제품 + 21 반제품·자재 usage 슬롯·제본/코팅/박 공정·page_rule·묶음수·sets·가격(PRF_BIND_SUM·PRF_PCB_FIXED + COMP_BIND_*·COMP_TTEOKME 단가)이 라이브 적재됨([[huni/load-path#LP-007]]). round-13 게이트 = **GO**(`_gate/booklet-gate.md` K0~K6 PASS).
- **미적재/BLOCKED:** 떡메모지(PRD_000097) 가격공식 **바인딩 미적재**(공식 마스터 `t_prc_price_formulas`에 PRF_TTEOKME_FIXED 실재 + COMP_TTEOKME 112행 단가도 존재 / 단 바인딩 `t_prd_product_price_formulas` PRD_000097 0행 → 공식 신설 불요·**바인딩만 적재 필요**, [BK-PRC-002])·option_groups 0행(CPQ 전면 미적재)·레더링바인더(088) 가격 BLOCKED·plate output_paper_typ_cd 전량 NULL.

### [BK-DEF-001] 라이브 오적재 양면 표기 (round-13 correction-manifest)  {🔴 교정대기}
- 내용: round-13이 확정한 책자 라이브 오적재. 라이브값을 사실로 단정 금지 — correction-manifest 대조 필수(BK-2·BK-3은 [[huni/materials#MAT-006]] 레더 .06 권위와 연결).

| 항목 | 라이브 현재값 | 정답 | 분류·심각도 | 출처 |
|---|---|---|---|---|
| **BK-2** PRD_000078 sub_prd 자재 | 몽블랑130g .01/.02 2행 | sub_prd=빈 껍데기(자재 0행)·표지 레더=parent 077 .02 | MIS-LOADED·**High(Top finding)** | correction-manifest.md BK-2 |
| **BK-1** 떡메모지 097 자재 | 백색모조120 USAGE.01 + USAGE.07 동일 mat 복제 | 내지 .01 1행만(표지·링 없음) | MIS-LOADED·High | correction-manifest.md BK-1 |
| **BK-3** 레더 077/088 표지 자재유형 | MAT_000186 MAT_TYPE.08 실사소재 | .06 가죽(Q4 의도·.06 고아행 4개 실재) | AMBIGUOUS·Medium | correction-manifest.md BK-3 / Q-BK-A |
| **BK-CAT** 068~071·077·082 카테고리 | 068~071=CAT_000006 lvl1 직결·전용 잎노드 6개(CAT_000100~103/106/107) 상품 0(고아) | 각 상품을 전용 잎노드 재연결(신설 0) | EXTRA·Medium | correction-manifest.md BK-CAT |
| **BK-4** 떡메모지 097 카테고리 | CAT_000129(lvl3)+CAT_000124 노트(lvl2) 2중 main=Y | CAT_000129 단일 주카테고리 | EXTRA·Medium | correction-manifest.md BK-4 |
| **BK-5** CAT_000297 가이드 노드 | upr=NULL·lvl3 고아(상품 0) | 상품 아님(논리삭제) | EXTRA·Low | correction-manifest.md BK-5 |
| **BK-7** plate 출력용지규격 | output_paper_typ_cd 전량 NULL(32/32) | 폴더(책자/디지털/실사/특수인쇄)=출력용지규격 또는 견적밖(Q-BK-C) | MISSING·Low | correction-manifest.md BK-7 |
| **BK-8** 떡메모지 page_rule | 3/3/3 + bundle 50/100권 | 묶음수(권)=권위·page_rule 3/3/3=잡음 정리 | EXTRA·Low | correction-manifest.md BK-8 |

- 출처: `17_correctness/booklet/correction-manifest.md` §1 분류표 + `_gate/booklet-gate.md`(GO·K4 독립 SELECT 재현) {tier C(round-13), FRESH}
- 연결: [[huni/materials#MAT-006]] (BK-2·BK-3 레더 정답 .06) · [[huni/materials#MAT-005]] (.07~10 자재오염) · [[#BK-LP-002]] (v03 진원)
- tags: #책자 #결함 #교정대기 #round13

### [BK-DEF-005] BK-CAT 카테고리 전용 잎노드 고아 (digital-print F-GATE-1 동형)  {🔴 교정대기}
- 내용: 책자 완제품이 전용 잎노드가 아닌 상위 중간노드에 직결 → 전용 잎노드 6개(CAT_000100 중철책자·101 무선·102 PUR·103 트윈링·106 레더하드·107 하드커버링)가 **상품 0(고아)**. CAT_000105 하드커버책자만 22 연결. 정상 잎노드 이미 실재(search-before-mint = 신설 0) → 교정 = 상품을 전용 잎노드로 재연결 + 빈 고아 노드 논리정리(BATCH-1).
- 앵커: `t_cat_categories`(CAT_000100~107) · `t_prd_product_categories`
- 출처: `17_correctness/booklet/product-identity.md` F-ID-5 + correction-manifest.md BK-CAT {tier C(round-13), FRESH·라이브 재실측}
- 연결: [[huni/load-path#LP-GAP-3]] (카테고리 고아 113상품 횡단·BATCH-1) · [[#BK-ID-003]]
- tags: #책자 #카테고리고아 #전용잎노드 #BATCH-1

### [BK-DEF-007] 컨펌 미결 (Q-BK-A~E)  {🔴 미결}
- 내용: 책자 인간 결정 대기 5건 — **Q-BK-A**(레더 .08 유지/.06 고아행 재연결/.06 신설, 포토북 D-PB-1 통합 가능)·**Q-BK-B**(떡메모지 page_rule 3/3/3 정리)·**Q-BK-C**(폴더=출력용지규격 적재 vs 견적밖)·**Q-BK-D**(088 후공정 존재 여부)·**Q-BK-E**(D링 mm=책등 모델 의도 확인). 횡단 결정 = BATCH-1(고아노드)·BATCH-3(코팅 통일, 책자는 이미 공정)·BATCH-12(v03 상류 vs DB 직접).
- 출처: `17_correctness/booklet/correction-manifest.md` §4 + `16_mapping-research/booklet/mapping-final.md` Q-BK-A~C {tier C(round-13), FRESH}
- 연결: [[huni/processes#PRC-GAP-1]] (BATCH-3 코팅) · [[huni/load-path#LP-GAP-1]] (BATCH-12 v03 상류) · [[huni/materials#MAT-006]] (Q-BK-A 레더)
- tags: #책자 #컨펌미결 #Q-BK #BATCH

### GAP (이 family 고유)
- **[GAP-BK-1]** BK-CAT 고아 잎노드 6개 재연결 미적재(BATCH-1) — [[huni/load-path#LP-GAP-3]].
- **[GAP-BK-2]** 코팅=공정 통일(BATCH-3) — 책자는 이미 공정 측 기준점, 스티커/포토북 자재 측과 통일 미결 — [[huni/processes#PRC-006]].
- **[GAP-BK-3]** page_rule 떡제본 잡음 정리(BATCH-8/Q-BK-B) — [[#BK-DIM-002]].
- **[GAP-BK-4]** 레더링바인더(088) 가격 BLOCKED — 제본종류 미상([BK-PRC-003]).

---

## Sources
- 큐레이션 팩: `_curation/pack-booklet.md`
- 정체/결함(C13, FRESH): `17_correctness/booklet/product-identity.md`·`correction-manifest.md`·`loadlogic-notes.md`·`live-diff.md`·`extraction-plan.md` + `_gate/booklet-gate.md`(GO).
- 차원/BOM(C11): `15_domain-spec/booklet/product-bom.md`·`column-dictionary.md`·`mapping-info.md`·`domain-research-notes.md`.
- 매핑확정(C12): `16_mapping-research/booklet/mapping-final.md`·`live-crosscheck.md`·`research-gap-board.md`.
- 가격(B/C): `02_mapping/price211-booklet-photobook/mapping.md`(라이브 실측 §0)·`06_extract/price-binding-l1.csv`·`price-postcard-book-l1.csv`. **price-engine-ddl.md 인용 0(STALE).**
- 위젯(D): `huni-widget/03_spec/data-contract.md`.
- 적재(A): `raw/webadmin/sql/`·`tools/load_master.py`(로직만).
- 메모리: `dbmap-correctness-audit-round13`·`dbmap-mapping-research-round12`·`dbmap-round3-mapping-audit`·`dbmap-platesize-is-output-paper`.
- **STALE/v03 (인용 금지):** `00_schema/price-engine-ddl.md`([[huni/price-engine#PE-STALE]]); v03 입력 xlsx([[huni/load-path#LP-STALE]]); 라이브 오적재값 직접 단정(correction-manifest 미대조 시 — G-1·F-PB-1 교훈).
