# 포토북(photobook) 레시피  {전체상태: 🟡}

> 조립 뷰(README §3·§9). 횡단 사실은 축 페이지를 `[[링크]] + 관계동사`로 참조만 한다(본문 복붙 금지). 이 페이지 고유 사실(prd_cd 목록·교정대기 행)만 원자 블록으로 둔다.
> **권위:** 정체 = `17_correctness/photobook/product-identity.md`(C13, FRESH) · 차원/BOM = `15_domain-spec/photobook/`(C11)·`16_mapping-research/photobook/mapping-final.md`(C12) · 가격 = `02_mapping/price211-booklet-photobook/mapping.md`(B/C, 라이브 미적재 주의) · 결함 = `17_correctness/photobook/correction-manifest.md`(C13)·`_gate/photobook-gate.md`(GO). 큐레이션 팩 = `_curation/pack-photobook.md`.
> **STALE 금지:** `price-engine-ddl.md`(price-engine [[huni/price-engine#PE-STALE]])·v03 입력 xlsx([[huni/load-path#LP-STALE]]) 인용 0. 라이브 오적재는 "라이브 현재값 → 정답" 양면 표기(7절).
> **F-PB-1 주의(이 family 핵심 교훈):** 소프트/레더 page 범위 "4~14"는 **엑셀 L1에 없는 추정값**이었다(validator oracle 날조 적발). 라이브 24/150/2(하드 기준 1행)는 오적재 아님 — 소프트 page는 **엑셀 공란 GAP**이지 MISSING 아님.

---

## CQ 헤더 (이 페이지가 답하는 질문)

- 포토북은 무엇인가 — **1 논리상품(PRD_000100) + size4×표지타입 variant**인가, 책자처럼 상품 N개인가(정반대 모델).
- 어떤 차원·옵션이 있는가 — size 4·표지타입 5(sub_prd)·page_rule·면지·제본.
- 가격은 어떻게 계산되는가 — page-band 합산형(base 24P + 2P당 증분)·**라이브 미적재**.
- DB에 어떻게 등록하는가 — webadmin load_master 적재 경로·FK 위상·sets(B셋트).
- 현재 라이브 적재 상태·교정 대기는 무엇인가 — PB-C1~C4·PB-M1~M2·PB-A1~A2 + 컨펌 Q1~Q5.

---

## 0. 정체 (identity) — 포토북
앵커: `t_prd_products` · `t_cat_categories` · `t_prd_product_sets`

### [PB-ID-001] 포토북 = 1 논리상품(PRD_000100) + 반제품 7 (책자와 정반대 모델)  {✅}
- 내용: 포토북 family는 **1 논리상품** `포토북 [디자인명]`(`PRD_000100`, PRD_TYPE.04 디자인 완제품) + **반제품 7(sub_prd, PRD_TYPE.02)** = 내지 PRD_000101·표지 5(PRD_000102 하드커버·103 아트250+무광·105 레더하드커버·106 레더·107 소프트커버)·면지 PRD_000104. **[HARD] 책자(10완제품 1상품=1행)와 정반대** — 포토북은 **1상품 + variant(size4×표지타입)**. 디자인명 3종(심플모던/여행/큐티키즈)은 에디터 템플릿 자산(상품 아님) — 라이브가 PRD_000100 단일로 폭증 안 함 = 정합. editor_yn=Y·file_upload_yn=N·qty_unit=권(QTY_UNIT.03)·MES NULL.
- 앵커: `t_prd_products`(PRD_000100 .04 + 101~107 .02) · `t_prd_product_sets`(7행)
- 출처: `17_correctness/photobook/product-identity.md` §1·§2(PB-OK-1) + `_gate/photobook-gate.md` K0(독립 SELECT 8행 일치) {tier C(round-13), FRESH·라이브 재현}
- 연결: [[#PB-ID-002]] · [[huni/materials#MAT-002]] (uses — parent+usage_cd·B셋트 빈 껍데기) · [[huni/load-path#LP-001]] (loaded-via — load_master 10_상품정보+19_sets)
- answers_cq: CQ-PROD-01 (상품 분류·적재 기준) · CQ-PROD-03 (반제품 귀속)
- tags: #포토북 #정체 #1상품 #variant #반제품7

### [PB-ID-002] 생산구조 = B 셋트 (소프트커버만 A통합 근접)  {🟡}
- 내용: 포토북 생산구조는 **B 셋트** — 하드/레더 표지 = 반제품 sub_prd(USAGE.02 표지) + 면지(USAGE.03) + 내지(USAGE.01 parent). **소프트커버만 종이표지 PUR이라 A 통합 근접**(반제품 아닐 수 있음 — CONFIRM-PB-1). **[HARD] 자재 권위는 항상 parent(PRD_000100) + usage_cd** — 표지 sub_prd(101~107)는 9속성 0행=정상(빈 껍데기, 결함 아님). 공통 레시피: `내지 출력(디지털) → 표지 출력(디지털/특수) → 표지 무광코팅 → 면지 부착 → PUR제본(책등 mm) → 재단 → 포장`.
- 앵커: `t_prd_product_sets`(B셋트 sub_prd 연결) · `t_prd_product_materials`(usage_cd 슬롯)
- 출처: `15_domain-spec/photobook/product-bom.md` §0·§1~3 + `17_correctness/photobook/product-identity.md` §1(생산방식) {tier C(round-11/13), FRESH}
- 연결: [[#PB-ID-001]] · [[huni/materials#MAT-002]] (uses — B셋트 parent+usage_cd) · [[huni/cpq-options#CPQ-006]] (uses — sets=묶음 단위)
- answers_cq: CQ-PROD-11 (묶음/세트 판매 단위) · CQ-PROD-03 (반제품 귀속)
- tags: #포토북 #생산구조 #B셋트 #소프트A통합

### [PB-ID-003] 포토북은 정체 오분류 0 · 카테고리 고아 0 (반증)  {✅}
- 내용: 포토북 1논리상품은 일반 인쇄물 범주(`CAT_000108 포토북` → 상위 `CAT_000006 06 책자`, main=Y). digital-print(인쇄배경지=포장재 오분류·043~046→CAT_000296 고아) 같은 **정체 오분류·카테고리 고아가 포토북엔 없다**(PB-OK-2 의심 반증). 결함은 정체가 아니라 **속성축**(자재유형·코팅 공정 귀속·가격 미적재)에 집중 — 굿즈파우치(round-13)와 동형.
- 앵커: `t_cat_categories`(CAT_000108 → CAT_000006, 정상 노드)
- 출처: `17_correctness/photobook/product-identity.md` §0·F-OK + `_gate/photobook-gate.md` K0(고아 0 반증 확정) {tier C(round-13), FRESH·라이브 재실측}
- 연결: [[#PB-ID-001]] · [[huni/load-path#LP-GAP-3]] (카테고리 고아 횡단 — 포토북 미포함)
- answers_cq: CQ-PROD-01 (상품 분류)
- tags: #포토북 #정체오분류0 #카테고리고아0 #반증

---

## 1. 차원 (dimensions) — 포토북
앵커: `t_prd_product_sizes`/`plate_sizes`/`page_rules` · `t_siz_sizes`

### [PB-DIM-001] 사이즈 = 4 이산 variant (재단치수, 책등 펼침은 별 siz)  {✅}
- 내용: 포토북 size는 **4 이산 variant**(8x8 SIZ_000269·10x10 SIZ_000274·A5 SIZ_000170·A4 SIZ_000172, `t_prd_product_sizes` 4행). 완성품 재단치수(cut=work, impos_yn=N). **표지 펼침 작업사이즈(책등 포함)는 마스터(SIZ_000272/273/277~281 7종)엔 실재하나 `t_prd_product_sizes`에 미연결**(생산 작업지시용 — 고객 미선택, PB-A1 컨펌). 실사처럼 면적매트릭스 아님(이산 정사이즈).
- 앵커: `t_prd_product_sizes.siz_cd`(완성품 4종) · `t_siz_sizes`(펼침 siz 7종 마스터)
- 출처: `16_mapping-research/photobook/mapping-final.md` C5·C21 + `_gate/photobook-gate.md` K4(size4·펼침siz7 미연결 재현) {tier C(round-12/13), FRESH·라이브 실측}
- 연결: [[base/sizes#BSZ-001]] (uses — 재단/작업/출력판형 보편 구분) · [[#PB-DEF-003]] (PB-A1 펼침 siz 귀속 컨펌)
- answers_cq: CQ-PROD-06 (variant 사이즈 → 차원 분해) · CQ-PROD-07 (선택 가능 사이즈 목록 4 이산 variant·비규격 미허용)
- tags: #포토북 #사이즈 #이산variant #펼침siz

### [PB-DIM-002] page_rule = 24/150/증가2 (하드 권위·소프트/레더 엑셀 공란 GAP)  {🟡}
- 내용: `t_prd_product_page_rules` = 24/150/2(라이브 단일 행, page_min/max/incr). **증가2 = 가격 추가(2P)당 정합**(spread 단위). **[HARD·F-PB-1] 엑셀 L1은 하드커버 행만 page(24/150/2) 명시·레더하드/소프트 행은 page 전 공란.** 종전 "소프트 4~14"는 product-bom 추정을 엑셀 권위로 오인용한 값(validator 날조 적발·삭제). 라이브 24/150/2는 **하드 기준 유일 page 행을 정확히 적재**(오적재 아님) — 소프트/레더 page 정책은 **엑셀 미규정 GAP**(실무진 컨펌 Q4 필요·MISSING 아님).
- 앵커: `t_prd_product_page_rules`(page_min/max/incr = 24/150/2)
- 출처: `17_correctness/photobook/correction-manifest.md` PB-A2(F-PB-1 재분류) + `_gate/photobook-gate.md` §2.2(F-PB-1·photobook-l1.csv 전 12행 파싱) {tier C(round-13), FRESH·엑셀 직접 파싱}
- 연결: [[base/binding#BBD-001]] (uses — 시그니처/페이지 보편) · [[#PB-PRC-001]] (uses — 24P base + 2P당 증분) · [[#PB-DEF-002]] (PB-A2 소프트 page GAP)
- answers_cq: CQ-PROD-01 (페이지 룰 적재 기준)
- tags: #포토북 #page_rule #증가2 #엑셀공란GAP #F-PB-1

### [PB-DIM-003] 책등(두께) = 앱 런타임 계산 (DB 미저장)  {🟡}
- 내용: PUR 책등(10/12/14/16mm)은 **페이지수 따라 앱 런타임 계산**(DB는 룩업만). 라이브 `PROC_000020 prcs_dtl_opt` 빈값 = 정합(미저장 정상, PB-OK-8). 스키마에 책등 컬럼이 없는 것은 GAP이 아니라 "앱 계산".
- 앵커: (DB 외 — 앱 계산) · 입력 = `t_proc_processes.prcs_dtl_opt`(PUR 책등 mm, 빈값)
- 출처: `16_mapping-research/photobook/mapping-final.md` C30 + 메모리 `dbmap-compute-in-app-db-stores-lookup` {tier C, FRESH}
- 연결: [[huni/price-engine#PE-010]] (uses — 책등=앱 계산 동일 철학·off-grid ceiling)
- answers_cq: CQ-PRICE-06 (후가공 가산·가변 차원)
- tags: #포토북 #책등 #앱계산 #PUR

---

## 2. 자재·공정 BOM — 포토북
앵커: `t_prd_product_materials`/`processes` · `t_mat_materials` · `t_proc_processes`

### [PB-BOM-001] 자재 usage 슬롯 = 내지.01·표지.02·면지.03  {🟡}
- 내용: 포토북 자재(7행, usage_cd 슬롯) — **내지(USAGE.01)** 몽블랑130(MAT_000105, MAT_TYPE.01 종이)·**표지(USAGE.02)** 5행(하드커버 MAT_000005·아트250+무광 MAT_000250·레더하드커버 MAT_000006·레더 MAT_000186·소프트커버 MAT_000007)·**면지(USAGE.03)** 그레이(MAT_000251, D-29 면지). **[HARD] 자재 권위 = parent(PRD_000100) + usage_cd** — 표지 sub_prd 9속성 0행=정상. 레더 표지 자재유형은 오염(.01/.08 → 정답 .06, 7절 PB-C1).
- 앵커: `t_prd_product_materials.usage_cd` · `t_mat_materials.mat_typ_cd`
- 출처: `16_mapping-research/photobook/mapping-final.md` §0·C13/C26/C29 + `_gate/photobook-gate.md` K4(materials 7행 재현) {tier C(round-12/13), FRESH·라이브 실측}
- 연결: [[huni/materials#MAT-001]] (uses — 자재 마스터·usage_cd 구조) · [[huni/materials#MAT-002]] (uses — parent+usage_cd) · [[huni/materials#MAT-006]] (requires — 레더 정답 .06 가죽·교정대기)
- answers_cq: CQ-PROD-05 (상품별 자재 축) · CQ-TERM-04 (소재 약어)
- tags: #포토북 #자재 #usage슬롯 #내지 #표지 #면지

### [PB-BOM-002] 공정 = PUR제본(필수·단일)·무광코팅(표지)·포장  {🟡}
- 내용: 포토북 공정 — **제본 = PUR(PROC_000020) 단일**(책자 GRP-BOOK-제본 택일그룹과 달리 PUR만 → excl_group 불요·mand_proc_yn=Y가 의미상 정답, 라이브 현재값 N → 교정 PB-C3). **무광코팅(PROC_000015, 부모 PROC_000013)**은 표지(하드/소프트)에 연결되어야 하나 라이브는 **자재명에 평면화**(MAT_000250 "아트250+무광코팅") → 코팅 공정 **미연결**(PB-C2/PB-M2). 책자류(068~072·082)는 동일 무광코팅을 PROC_000015 공정으로 분리 — 포토북만 family 이탈(코팅=공정 통일 미결 [PRC-006]). 레이플랫(PROC_000025) 미운영.
- 앵커: `t_proc_processes`(PROC_000020 PUR·PROC_000015 무광) · `t_prd_product_processes`
- 출처: `16_mapping-research/photobook/mapping-final.md` C28/C26 + `17_correctness/photobook/correction-manifest.md` PB-C2·PB-C3·PB-M2 {tier C(round-12/13), FRESH·라이브 실측}
- 연결: [[huni/processes#PRC-005]] (uses — 박/코팅=공정 실무진확정) · [[huni/processes#PRC-006]] (코팅 CONFLICT — 포토북은 자재 평면화 측·BATCH-3 미결) · [[base/binding#BBD-003]] (uses — 제본 방식 보편)
- answers_cq: CQ-FIN-01 (후가공 공정 목록) · CQ-FIN-02 (코팅 종류)
- tags: #포토북 #공정 #PUR #무광코팅 #family이탈

### [PB-BOM-003] 도수 = 내지 양면 CMYK4 · 표지 단면 CMYK4 (별색 없음)  {✅}
- 내용: `t_prd_product_print_options` 2행 — opt1 내지 양면(front=back=CLR_000005 CMYK4)·opt2 표지 단면(front=CMYK4·back=인쇄안함). **별색 없음**(별색=공정으로 모델링하나 포토북 미적용). ACRYLIC 전개 미적용=정상(PB-OK-6).
- 앵커: `t_prd_product_print_options`(opt1 양면·opt2 단면)
- 출처: `16_mapping-research/photobook/mapping-final.md` C14·C27 + `_gate/photobook-gate.md` K4(print_options 2 재현) {tier C(round-13), FRESH·라이브 실측}
- 연결: [[base/color#BCL-001]] (uses — CMYK/도수 보편) · [[huni/processes#PRC-003]] (별색=공정 — 포토북 미사용)
- answers_cq: CQ-FIN-03 (별색인쇄 용도) · CQ-PROD-05 (인쇄옵션 축)
- tags: #포토북 #도수 #양면 #단면 #별색없음

---

## 3. 가격 사슬 (price chain) — 포토북
앵커: `t_prc_*` 4단(`t_prc_price_formulas`→components→component_prices)·`t_prd_product_price_formulas`(바인딩)

### [PB-PRC-001] page-band 합산형 — PRF_PBK_PAGEBAND (제안·라이브 미적재)  {🟡}
- 내용: 포토북 가격은 **page-band 합산형**(base 24P 매트릭스 + 24P 초과 2P당 증분). **[HARD] 라이브 미적재** — `t_prd_product_prices` 0행·`t_prd_product_price_formulas` PRD_000100 **바인딩 0행**(`hasf=0`). 제안 공식 = **신규 `PRF_PBK_PAGEBAND`**(mapping.md D-1 mint) + component_prices base(11 활성조합)+add2P(11) = **22행**, comp_typ=완제품비(PRC_COMPONENT_TYPE.06, 인쇄/코팅/용지로 분해 안 됨·통가격). **10x10 소프트커버 = 엑셀 base/add 공란 → BLOCKED 1조합**(2행 미적재). 활성 11조합 매트릭스: 8x8{하드15000/+500·레더하드23000·소프트12000}·10x10{하드22000·레더하드32000}·A5{하드12000/+300·레더하드19000·소프트10000}·A4{하드16000/+600·레더하드26000·소프트13000}.
- 앵커: `t_prc_price_formulas`(PRF_PBK_PAGEBAND 신규·미적재) · `t_prc_component_prices`(22행 INSERTABLE) · `t_prd_product_price_formulas`(PRD_000100 바인딩 0행)
- 출처: `02_mapping/price211-booklet-photobook/mapping.md` §1.B·§리스트(D-1·B-2·A-1) + `06_extract/photobook-l1.csv`(11조합 셀 일치 검증) {tier B/C, 공식설계 FRESH·라이브 미적재}
- 연결: [[huni/price-engine#PE-005]] (priced-by — 원자/page-band 합산형) · [[huni/price-engine#PE-001]] (uses — t_prc 4단) · [[huni/price-engine#PE-GAP-3]] (포토북 가격 미적재 횡단) · [[#PB-DIM-002]] (uses — 24P base+2P당)
- answers_cq: CQ-PRICE-08 (견적 합산 공식) · CQ-PRICE-01 (단가표 vs 공식)
- tags: #포토북 #가격 #page-band합산형 #PRF_PBK_PAGEBAND #미적재

### [PB-PRC-002] 가격 ≠ PRF_PCB_FIXED (그건 엽서북 PRD_000094)  {✅}
- 내용: **주의 — 포토북 가격을 `PRF_PCB_FIXED`로 인용 금지.** `PRF_PCB_FIXED`(+ COMP_PCB 단가)는 **엽서북(PRD_000094, 책자 family)** 의 떡제본 고정가 공식이지 포토북 공식이 아니다(같은 slice 문서에 공존해 혼동 유발). 포토북(PRD_000100) 정답 = page-band 합산형 PRF_PBK_PAGEBAND([PB-PRC-001]) + 미적재. 가격 미적재를 "✓ 적재됨"으로 단정한 인용은 F-PB-1 동형(라이브 갭 은폐) — `t_prd_product_price_formulas WHERE prd_cd='PRD_000100'` = 0행이 권위.
- 앵커: `t_prd_product_price_formulas`(PRD_000094=PRF_PCB_FIXED 엽서북 / PRD_000100=미바인딩 포토북)
- 출처: `02_mapping/price211-booklet-photobook/mapping.md` L25·L28·§1.B + `17_correctness/photobook/correction-manifest.md` PB-M1(0행) {tier B/C, FRESH·라이브 0행 확인}
- 연결: [[recipes/booklet#BK-PRC-002]] (엽서북 PRF_PCB_FIXED = 책자 family) · [[huni/price-engine#PE-007]] (고정가형 — 엽서북 측)
- answers_cq: CQ-PRICE-01 (가격 공식 귀속)
- tags: #포토북 #가격 #혼동주의 #엽서북구별 #PRD_000094

---

## 4. CPQ 옵션 레이어 — 포토북
앵커: `t_prd_product_option_groups`/`options`/`option_items` · `constraints` · `templates`

### [PB-CPQ-001] 포토북 option_groups 0행 (CPQ 전면 미적재)  {🔴 미적재}
- 내용: **라이브 현재값: 포토북 option_groups/options/option_items 0행** → 정답: 표지타입(택1)·page·면지 등은 CPQ 옵션 레이어로 표현 가능하나 **전 family CPQ 전면 미적재**(silsa 파일럿만)와 정합. 일괄 적재 미결(BATCH-6). 현재는 표지타입=표지 sub_prd(sets)·size=차원행으로 흡수(차원/sub_prd 모델이 현행 정상).
- 앵커: `t_prd_product_option_groups`(라이브 0행)
- 출처: `16_mapping-research/photobook/mapping-final.md` §0(option 미언급=미적재) + `17_correctness/photobook/correction-manifest.md`(CPQ 미적재) {tier C(round-12/13), FRESH·라이브 0행}
- 연결: [[huni/cpq-options#CPQ-008]] (CPQ 전면 미적재 silsa 파일럿만) · [[huni/cpq-options#CPQ-GAP-1]] (BATCH-6 일괄 적재 미결)
- answers_cq: CQ-PROD-05 (선택 옵션 축·캐스케이드)
- tags: #포토북 #CPQ미적재 #BATCH-6

### [PB-CPQ-002] 표지타입 옵션 = 자재+공정 BUNDLE 후보 (CPQ 적재 시)  {🟡}
- 내용: 포토북 CPQ 적재 시 **표지타입(택1)** = 표지 자재(USAGE.02) + 무광코팅 공정(하드/소프트) BUNDLE 대상 — 옵션을 자재만/공정만으로 반쪽 매핑 금지. 소프트/레더 page 차등([PB-DIM-002])은 표지타입별 caskade(constraints.logic)로 표현 가능하나 **엑셀 공란이라 page 차등 정답 미확정**(컨펌 Q4 선행). 제약은 `constraints.logic` 단일경로(constraint_json 삭제 [CPQ-STALE]).
- 앵커: `t_prd_product_option_items`(다중 seq) · `t_prd_product_constraints.logic`(표지타입↔page 차등 후보)
- 출처: `16_mapping-research/photobook/mapping-final.md` C18·C26·§2(CONFLICT-PB-A page 차등) {tier C, FRESH}
- 연결: [[huni/cpq-options#CPQ-005]] (uses — BUNDLE 자재+공정) · [[huni/cpq-options#CPQ-007]] (requires — caskade constraints.logic) · [[huni/cpq-options#CPQ-STALE]] (constraint_json 삭제 — logic 단일경로)
- answers_cq: CQ-FIN-10 (옵션=자재+공정)
- tags: #포토북 #CPQ #BUNDLE #표지타입 #page차등

---

## 5. 위젯 계약 (widget contract) — 포토북
앵커: 정규화 계약(`huni-widget/03_spec/`) — DB 외 앵커임을 명시

### [PB-WID-001] 포토북 위젯 = 정규화 계약 일반형 (전용 스펙 부재)  {⚪ 명세}
- 내용: 포토북은 **전용 위젯 스펙이 없다**(아크릴·굿즈파우치·캘린더만 family 스펙 존재). 포토북 위젯은 데이터계약 일반형 + 후니 어댑터로 도출(위젯 코어 불변). size 택1·표지타입 택1·page 증분(증가2)·면지는 componentType 매핑으로, **가격은 서버 권위(PRICE=0 불가)** — 단 포토북 가격 라이브 미적재라 어댑터는 가격 적재([PB-PRC-001]) 선행 필요. 에디터 중심(editor_yn=Y)이라 Edicus 브리지 연동축.
- 앵커: DB 외 — `huni-widget/03_spec/data-contract.md`(일반형) · 어댑터 경계
- 출처: `huni-widget/03_spec/data-contract.md` + [[huni/widget-contract#WID-GAP-3]](family 스펙 존재분) {tier D, FRESH}
- 연결: [[huni/widget-contract#WID-001]] (mapped-to — 정규화 계약) · [[huni/widget-contract#WID-003]] (mapped-to — 14 componentType) · [[huni/widget-contract#WID-005]] (priced-by — 서버 가격권위·PRICE=0 불가)
- answers_cq: CQ-PROD-08 (상품-카테고리 UI 노출) · CQ-PRICE-01 (가격 권위=서버)
- tags: #포토북 #위젯 #정규화계약 #전용스펙부재 #에디터

---

## 6. 적재 레시피 (load path) — 포토북
앵커: `raw/webadmin/sql/*`·`tools/load_master.py` · round-8 `13_admin-ui-spec/`

### [PB-LP-001] 포토북 적재 = load_master 10_상품정보 + relation 시트 (가격 함수 부재)  {🟡}
- 내용: 포토북은 `load_master.py` `run_all()` 단일 트랜잭션으로 적재 — 10_상품정보(PRD_000100 + sub_prd 101~107) + relation 시트(11 카테고리·13 사이즈 L307·14 자재[usage_cd] L318·15 공정·17 판형·19 셋트 L424·21 페이지룰 L447). **[HARD] load_master에 가격 적재 함수 부재**(MASTERS/RELATIONS 목록에 없음·`grep price|prc_` = 0건) → 포토북 가격은 round-2 별 트랙(`dbm-price-formula`)이라 **한 번도 실행 안 됨**(PB-M1). **[HARD] load_master는 순수 전파기** — 입력 v03 xlsx 인용 금지(진원=상류 v03·정답=상품마스터 L1). 멱등=이름 기반 UPSERT·search-before-mint.
- 앵커: `raw/webadmin/tools/load_master.py`(L307/318/416/424/447 함수군, 로직만) · `13_admin-ui-spec/`
- 출처: `_gate/photobook-gate.md` §2.1(load_master 라인 전건 실재·가격 함수 부재 grep 0건) + `17_correctness/photobook/loadlogic-notes.md` {tier A/C, FRESH(HEAD)·로직만 oracle}
- 연결: [[huni/load-path#LP-001]] (loaded-via — 적재 oracle) · [[huni/load-path#LP-003]] (uses — FK 위상순서) · [[huni/load-path#LP-004]] (uses — 멱등 search-before-mint) · [[huni/load-path#LP-STALE]] (v03 입력 금지)
- answers_cq: CQ-PROD-01 (상품 적재 기준) · CQ-FILE-01 (운영자 입력경로)
- tags: #포토북 #적재 #load_master #가격함수부재 #v03전파기

### [PB-LP-002] 적재 결함 진원 = v03 정규화 · 교정 = L1 권위 델타  {🟡}
- 내용: 포토북 MIS-LOADED(레더 자재유형·코팅 평면화·PUR mand=N)는 **load_master 코드 결함이 아니라 v03 정규화 결함**(load_master 충실 전파). 원인 코드 라인: 레더 .01/.08 = `MAT_TYP_OVERRIDE` 슬러그 불일치(L116~121, 포토북 연결 MAT_000006은 "A"없음→미적용·MAT_000186은 ENUM_ALIAS "실사"→.08) + PUR mand=N = `_yn` 빈값→N(L416·L80). 교정 = v03 행 직접 수정이 아니라 **상품마스터 L1 권위 델타**(round-5/6 + 인간 승인). **qty_unit_typ_cd(.03 권)은 load_master NULL 강제(L269)인데 라이브 .03 존재 = 적재경로 불명(별도 backfill)** → 재적재 시 NULL 회귀 주의(PB-C4).
- 앵커: `raw/webadmin/tools/load_master.py`(L116~121·L416·L269) · 정답 = 상품마스터 L1
- 출처: `_gate/photobook-gate.md` K3(적재로직 근거 전건 정확) + `17_correctness/photobook/correction-manifest.md` PB-C1/C3/C4 why {tier A/C, FRESH}
- 연결: [[huni/load-path#LP-STALE]] (v03 진원) · [[huni/load-path#LP-GAP-1]] (BATCH-12 v03 상류 vs DB 직접) · [[#PB-DEF-001]] (교정대기 양면표기)
- answers_cq: CQ-PROD-01 (적재 기준)
- tags: #포토북 #적재결함 #v03진원 #L1권위델타 #qty_unit경로불명

---

## 7. 현황·결함 (state) — 포토북

### 적재 현황
- **GO분 적재됨:** 포토북 1논리상품 + 반제품 7·sets 7행·자재 usage 슬롯 7행·PUR 공정·page_rule(24/150/2)·print_options 2·카테고리(CAT_000108)가 라이브 적재됨([[huni/load-path#LP-007]]). round-13 게이트 = **GO**(`_gate/photobook-gate.md` K0~K6 보정 후 전건 PASS).
- **미적재/BLOCKED:** **가격 전체 미적재**(`t_prd_product_prices`·`t_prd_product_price_formulas` PRD_000100 0행 — 가장 영향 큰 미적재, 견적 불가, [PB-PRC-001]·PB-M1)·option_groups 0행(CPQ 전면 미적재)·무광코팅 공정 미연결(자재 평면화, PB-M2)·10x10 소프트 가격 BLOCKED(엑셀 공란)·표지 펼침 siz 미연결(생산용·PB-A1).

### [PB-DEF-001] 라이브 오적재 양면 표기 (round-13 correction-manifest)  {🔴 교정대기}
- 내용: round-13이 확정한 포토북 라이브 오적재. 라이브값을 사실로 단정 금지 — correction-manifest 대조 필수. **레더 자재유형(PB-C1)은 [[huni/materials#MAT-006]] 레더 .06 권위와 연결**(MAT_000186은 6상품 횡단이라 .06 일괄 교정 영향 확인 후 — 컨펌 Q1).

| 항목 | 라이브 현재값 | 정답 | 분류·심각도 | 출처 |
|---|---|---|---|---|
| **PB-C1** 레더 표지 자재유형 | MAT_000006 mat_typ_cd=.01 종이 + MAT_000186 .08 실사소재 | **.06 가죽**(자재유형만 UPDATE·prd_cd 재연결 아님) | MIS-LOADED·**High** | correction-manifest.md PB-C1 / Q1 |
| **PB-C2** 아트250+무광코팅 표지 | MAT_000250 "아트250+무광코팅" 단일 자재(.01)·코팅 평면화 + 중복 250/260/172 | 자재=아트250(.01) + 무광코팅 공정 PROC_000015 분리 | MIS-LOADED·Medium-High | correction-manifest.md PB-C2 / Q2 |
| **PB-C3** PUR 제본 필수성 | PROC_000020 mand_proc_yn=**N** | mand_proc_yn=**Y**(제본=본질 필수·PUR 단일·택일 불요) | MIS-LOADED·Low-Med(직접 UPDATE) | correction-manifest.md PB-C3 |
| **PB-M1** 가격 | `t_prd_product_prices`·`_price_formulas` PRD_000100 **0행** | size×표지타입 매트릭스 base(11활성) + per-page 증분(PRF_PBK_PAGEBAND) | MISSING·**High** | correction-manifest.md PB-M1 / Q3 |
| **PB-M2** 무광코팅 공정 | 코팅 공정 연결 0행(자재명 평면화) | PROC_000015 무광 연결(표지) | MISSING·Medium | correction-manifest.md PB-M2 / Q2 |
| **PB-C4** qty_unit_typ_cd | .03 권(값 정답)·단 load_master NULL 강제(L269) | .03(맞음)·적재경로 불명(backfill) | 경로불명·Low | correction-manifest.md PB-C4 |
| **PB-A1** 표지 펼침 작업사이즈 | SIZ_000272/273/277~281(7종) 마스터 실재·`t_prd_product_sizes` 미연결 | 불확실 — 미연결 유지(생산용·견적밖) vs 표지 sub_prd 연결 | AMBIGUOUS·Low | correction-manifest.md PB-A1 / Q5 |
| **PB-A2** 소프트/레더 page_rule | 24/150/2 단일 행(하드 기준) | **불확실(엑셀 공란 GAP)** — 종전 "4~14"는 추정 오인용·삭제. 라이브 24/150/2는 오적재 아님 | AMBIGUOUS/GAP·Low | correction-manifest.md PB-A2(F-PB-1) / Q4 |

- 출처: `17_correctness/photobook/correction-manifest.md` §1~3 분류표 + `_gate/photobook-gate.md`(GO·K4 독립 SELECT 재현·F-PB-1/F-PB-2 보정) {tier C(round-13), FRESH}
- 연결: [[huni/materials#MAT-006]] (PB-C1 레더 정답 .06·6상품 횡단) · [[huni/materials#MAT-005]] (.07~10 자재오염) · [[huni/processes#PRC-006]] (PB-C2 코팅 family 이탈) · [[#PB-LP-002]] (v03 진원)
- tags: #포토북 #결함 #교정대기 #round13

### [PB-DEF-002] 소프트 page_rule = 엑셀 공란 GAP (F-PB-1 oracle 날조 적발 사례)  {🔴 GAP}
- 내용: **이 family의 핵심 검증 교훈.** 종전 산출물이 "소프트 page 4~14"를 엑셀 L1 권위로 단언했으나 validator가 `photobook-l1.csv` 전 12행 직접 파싱 → **하드커버 행만 24/150/2·소프트/레더 행은 page 전 공란**(`grep "4~14"`=0건). "4~14"는 product-bom 추정을 엑셀 권위로 오인용한 **oracle 날조**(F-PB-1 BLOCKER → 보정). 따라서 라이브 24/150/2(하드 1행)는 MISSING 아니라 **충실 적재**, 소프트/레더 page 정책은 **엑셀 미규정 GAP**(실무진 컨펌 Q4 후 반영). 인용은 의미 일치까지 — "page 차등"을 L1 권위로 쓰지 말 것.
- 앵커: `t_prd_product_page_rules`(24/150/2 단일·소프트 행 부재) · 정답 = `06_extract/photobook-l1.csv`(소프트 page 공란)
- 출처: `_gate/photobook-gate.md` §2.2(F-PB-1·전 12행 파싱) + `17_correctness/photobook/correction-manifest.md` PB-A2 {tier C(round-13), FRESH·엑셀 직접 파싱}
- 연결: [[#PB-DIM-002]] · [[#PB-DEF-003]] (Q4 컨펌)
- tags: #포토북 #page공란GAP #F-PB-1 #oracle날조교훈

### [PB-DEF-003] 컨펌 미결 (Q1~Q5)  {🔴 미결}
- 내용: 포토북 인간 결정 대기 5건 — **Q1**(레더 자재유형 정리: MAT_000006/186 mat_typ_cd .06 가죽 UPDATE — prd_cd 재연결 아님·가죽 고아행 008/173 끌어오기 금지[note 모순]·MAT_000186 6상품 횡단 영향 통합 결정, 책자 BK-4/round-12 CONFLICT-PB-1과 통합 가능)·**Q2**(무광코팅 공정 분리 vs 자재명 통합·중복 250/260/172 정리, family 통일)·**Q3**(가격 목표 테이블: `t_prd_product_prices` 직접단가 vs `t_prd_template_prices` SKU별 Phase11 신설)·**Q4**(소프트/레더 page = 엑셀 공란 → 실무진 확인)·**Q5**(표지 펼침 siz 귀속). 횡단 결정 = BATCH-1(고아노드·포토북 무관)·BATCH-3(코팅 통일, 포토북은 자재 평면화 측)·BATCH-12(v03 상류 vs DB 직접).
- 출처: `17_correctness/photobook/correction-manifest.md` §5(Q1~Q5) + `16_mapping-research/photobook/mapping-final.md` §3 {tier C(round-13), FRESH}
- 연결: [[huni/processes#PRC-GAP-1]] (BATCH-3 코팅) · [[huni/load-path#LP-GAP-1]] (BATCH-12 v03 상류) · [[huni/materials#MAT-006]] (Q1 레더 6상품 횡단)
- tags: #포토북 #컨펌미결 #Q1Q5 #BATCH

### GAP (이 family 고유)
- **[GAP-PB-1]** 가격 전체 미적재(PB-M1·Q3) — page-band 합산형 PRF_PBK_PAGEBAND 적재 필요(10x10 소프트 1조합 BLOCKED) — [[huni/price-engine#PE-GAP-3]].
- **[GAP-PB-2]** 레더 .08→.06 일괄 교정(MAT_000186 6상품 횡단·Q1) — [[huni/materials#MAT-006]].
- **[GAP-PB-3]** 코팅=공정 통일(BATCH-3) — 포토북은 자재 평면화 측, 책자 공정 측과 통일 미결 — [[huni/processes#PRC-006]].
- **[GAP-PB-4]** 소프트/레더 page_rule 엑셀 공란(F-PB-1·Q4) — 실무진 확인 필요 — [[#PB-DEF-002]].

---

## Sources
- 큐레이션 팩: `_curation/pack-photobook.md`
- 정체/결함(C13, FRESH): `17_correctness/photobook/product-identity.md`·`correction-manifest.md`·`loadlogic-notes.md`·`live-diff.md`·`extraction-plan.md` + `_gate/photobook-gate.md`(GO·F-PB-1/F-PB-2 보정).
- 차원/BOM(C11): `15_domain-spec/photobook/product-bom.md`·`column-dictionary.md`·`mapping-info.md`·`domain-research-notes.md`.
- 매핑확정(C12): `16_mapping-research/photobook/mapping-final.md`·`live-crosscheck.md`·`research-gap-board.md`.
- 가격(B/C): `02_mapping/price211-booklet-photobook/mapping.md`(§1.B 포토북 page-band·라이브 미적재)·`06_extract/photobook-l1.csv`. **price-engine-ddl.md 인용 0(STALE).** **주의: PRF_PCB_FIXED/COMP_PCB 234·468행은 엽서북 PRD_000094(책자), 포토북 아님([PB-PRC-002]).**
- 위젯(D): `huni-widget/03_spec/data-contract.md`.
- 적재(A): `raw/webadmin/tools/load_master.py`(로직만).
- 메모리: `dbmap-correctness-audit-round13`·`dbmap-mapping-research-round12`·`dbmap-compute-in-app-db-stores-lookup`·`dbmap-round3-mapping-audit`.
- **STALE/v03 (인용 금지):** `00_schema/price-engine-ddl.md`([[huni/price-engine#PE-STALE]]); v03 입력 xlsx([[huni/load-path#LP-STALE]]); 라이브 오적재값 직접 단정(correction-manifest 미대조 시 — G-1·F-PB-1 교훈); 소프트 page "4~14"(F-PB-1 oracle 날조·삭제).
