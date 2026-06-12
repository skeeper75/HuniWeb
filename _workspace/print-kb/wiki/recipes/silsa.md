# silsa(실사) 레시피  {전체상태: 🟡}

> 조립 뷰. 횡단 사실은 축 페이지(`huni/<axis>.md`) 원자 항목을 `[[링크]] + 관계동사`로 참조만 하고 본문 복붙하지 않는다(README §3·§9). 레시피 고유 사실(실사 29상품 정체표·교정대기 행·일반현수막 CPQ 파일럿)만 본문 원자 블록.
> 큐레이션 팩: `_curation/pack-silsa.md`(1차 권위). round-13 게이트 GO(K0~K6 PASS·분류 정반대 결함 0·size 면적매트릭스 CORRECT 반증).
> **STALE/v03 인용 0**: 가격엔진 `price-engine-ddl.md`·v03 입력 xlsx·constraint_json·dep_proc_cd 인용 금지(축 STALE 블록 참조). 라이브 오적재는 7절 양면 표기(특히 카테고리 고아·자재 .08 평면화).

## CQ 헤더 (이 페이지가 답하는 질문)
- 실사는 무엇인가(카테고리 004 포스터+005 사인 대형 실사 출력물·28등록 PRD_000118~145·소재 기반 13군) / 어떤 차원·옵션(이산 면적매트릭스 size·소재별 자재·봉제/타공/족자/부착 공정·부속 addon)이 있는가
- 가격은 어떻게 계산되는가(포스터사인 [가로×세로] 면적매트릭스 13상품 + 고정가형 16상품·실사 inline price 아님) / DB에 어떻게 등록하는가
- 현재 라이브 적재 상태·교정 대기(카테고리 고아 CAT_000298 28상품·자재 .08 평면화·부속 0행·일반현수막 CPQ 18행만)는 무엇인가
- 미결: 카테고리 재연결(Q-SL-1·BATCH-1)·봉제/족자 param 적재(Q-SL-2)·보드마운팅 공정 신설(Q-SL-3)·부속/액자 귀속(Q-SL-4)·끈/각목 BUNDLE mint(GAP-SL-1)

---

## 0. 정체 (identity) — 실사  앵커: t_prd_products · t_cat_categories

### [SL-ID-001] 실사 = 카테고리 004(포스터)+005(사인) 일반 인쇄물·소재 기반  {✅}
- 내용: 실사 시트 = **카테고리 004 포스터 + 005 사인** 두 묶음의 **일반 인쇄물(대형 실사 출력물)** — 굿즈/포장재/액세서리 **아님**. 인쇄방식 = **실사(`PROC_000006` 대형 잉크젯)** 단일(폴더 `실사출력`/`특수인쇄`/`현수막`/`시트커팅`). **소재가 상품을 가른다**(13 소재군: 종이/방수/투명/패브릭/특수소재/보드/액자/행잉족자/배너/현수막/시트커팅/아크릴스티커/스탠딩). 정체 오분류 위험 **없음**(디지털인쇄 인쇄배경지=포장재 오분류 사례와 대조 — product-master 권위0이 전 29상품을 "일반 인쇄물"로 일관 확정). 단 **아크릴스티커(005-0007/0008)는 폴더=레이저커팅 → UV(`PROC_000002`) 라인**(소재가 아크릴이라 UV — 실사 시트에 묶였으나 라우팅은 UV).
- 앵커: `t_prd_products`(PRD_000118~145) · `t_cat_categories`(004 포스터·005 사인)
- 출처: `17_correctness/silsa/product-identity.md` §0·§2 (product-master.md L23/L74/L75 인용·라이브 prd_typ 실측) {tier C13, FRESH}
- 연결: [[../base/printing-methods#2-무판--디지털-인쇄]] (uses — 실사 무판 출력 보편) · [[../huni/modeling-axioms#HMOD-01]] (uses — 인쇄방식≠최상위 축·시트=1차 단위)
- answers_cq: CQ-PROD-01 (상품 분류) · CQ-PROD-03 (완제품 귀속)
- tags: #실사 #정체 #포스터사인 #소재기반 #004_005

### [SL-ID-002] 28등록 상품 목록 (단품 + 부속붙는 8상품) · 투명포스터★ 비활성  {✅}
- 내용: 라이브 등록 **28상품**(PRD_000118~145, L1 29 = +투명포스터★ 비활성). **단품형**: 종이포스터(아트프린트118/아트페이퍼119)·방수(120/접착방수121)·접착투명122·패브릭(아트패브릭123/린넨124/캔버스125)·특수소재(레더아트126/타이벡127/메쉬128)·보드(폼보드129/포맥스130)·시트커팅(무광140/홀로그램141)·아크릴스티커(유광142/미러143)·미니배너145·미니보드스탠딩144. **단품+부속형 8상품**: 프레임리스우드액자131·레더아트액자132(에디터)·캔버스행잉133(에디터)·린넨우드봉족자134(에디터)·족자포스터135·PET배너136·메쉬배너137·일반현수막138·메쉬현수막139. **비활성(EXTRA 아님·정당)**: 투명포스터★(라이브 부재·방수포스터와 MES 004-0003 공유+숨김행+PM "신규/검토중").
- 앵커: `t_prd_products`(PRD_000118~145·투명포스터★ 부재) · `t_prd_product_addons`/`t_prd_product_sets`(부속붙는 8상품·현 대부분 0행 [[#SL-DEF-005]])
- 출처: `17_correctness/silsa/product-identity.md` §1 정체표(29상품·라이브 prd_cd 매핑·C-13 투명포스터★ 정당 비활성) {tier C13, FRESH}
- 연결: [[#SL-ID-001]] · [[#SL-BOM-005]] (부속=addon/set) · [[#SL-DEF-005]] (부속 미적재 교정대기)
- answers_cq: CQ-PROD-01 (상품 분류) · CQ-PROD-03 (완제품 귀속)
- tags: #실사 #prd_cd목록 #단품 #부속 #투명포스터별표

---

## 1. 차원 (dimensions) — 실사  앵커: t_prd_product_sizes/plate_sizes · t_siz_sizes

### [SL-DIM-001] size = 이산 면적매트릭스 + nonspec 범위 (입력UX≠가격격자·CORRECT)  {✅}
- 내용: 실사 size = **이산 규격 SIZ(A3/A2/A1 등) + 비규격(nonspec_*) 연속범위 + 사용자입력**. 유효 사이즈·가격 권위 = **포스터사인 면적매트릭스 셀**([[#SL-PRC-001]]) — 비규격 범위는 **입력 UX 한계일 뿐 가격격자가 아니다**([[../huni/price-engine#PE-006]]). **round-9가 우려한 "비치수 연속범위 오판"이 라이브에 없음을 round-13이 검증자 독립 SELECT로 반증**(이산 규격 SIZ + nonspec 200~1200/200~3000 정확 분리 — 의심 반증·CORRECT). off-grid = 가로·세로 각 한 단계 큰 규격 ceiling([[../huni/price-engine#PE-006]] 앱 계산). 배너=600x1800(고정)·현수막=5000x900(대형)·아크릴스티커=290x90~590x390(고정 규격).
- 앵커: `t_prd_product_sizes`(이산 SIZ + nonspec_w/h_min/max) · `t_siz_sizes`
- 출처: `17_correctness/silsa/correction-manifest.md` C-02(size CORRECT·연속범위 오판 부재) + `_gate/silsa-gate.md` K4(검증자 독립 SELECT 재현) {tier C13, FRESH}
- 연결: [[../base/sizes#BSZ-001]] (uses — 재단 사이즈 보편) · [[../base/sizes#BSZ-002]] (uses — 작업 사이즈) · [[../huni/price-engine#PE-006]] (priced-by — 면적매트릭스 size 차원·off-grid ceiling) · [[#SL-PRC-001]]
- answers_cq: CQ-PROD-06 (size 차원 분해) · CQ-PRICE-05 (면적 기반 계산)
- tags: #실사 #size #면적매트릭스 #nonspec #입력UX

### [SL-DIM-002] 판형(출력용지규격) = .기타 (실사 대형롤·전지 무의미)  {✅}
- 내용: 실사 판형(`output_paper_typ_cd`)은 **전부 `.기타`** — 실사는 **대형 롤 출력이라 절수 기반 전지(원지) 규격이 무의미**(낱장 임포지션 없음). `output_file_typ`(JPG/AI)은 정확. [[../base/sizes#BSZ-003]] 출력판형 보편 정의에서 실사는 롤 기반이라 제외. 적재 경로 = load_master:340 `.기타` 무조건(정합). 박/면적 등 앱 런타임 계산 없음(가격 룩업만).
- 앵커: `t_prd_product_plate_sizes`(output_paper_typ_cd=.기타) · `output_file_typ`
- 출처: `17_correctness/silsa/loadlogic-notes.md` §1·§3(load_master:340/346 `.기타` 무조건·실사 대형롤 전지 무의미 정합) + correction C-10(CORRECT-경로불명) {tier C13, FRESH}
- 연결: [[../base/sizes#BSZ-003]] (uses — 출력판형 보편·실사 롤 예외) · [[../huni/load-path#LP-STALE]] (plate 교정 별도 트랙)
- answers_cq: CQ-PROD-06 (판형 차원)
- tags: #실사 #판형 #output_paper #기타 #대형롤

---

## 2. 자재·공정 BOM — 실사  앵커: t_prd_product_materials/processes · t_mat_materials · t_proc_processes

### [SL-BOM-001] 자재 = 소재별 parent + usage_cd (낱장 본체 단일)  {🟡}
- 내용: 실사 BOM = **소재별 본체 자재 단일**(낱장 완제품/단일 — 내지/표지 개념 없음). 자재 모델 = [[../huni/materials#MAT-002]] **parent + usage_cd**(낱장은 C단일). 소재 정체 자체는 정확(인화지·매트지·PET·PVC·린넨·캔버스·레더·타이벡·메쉬·현수막천·시트지·아크릴 등 L1 일치). usage = `USAGE.07 공통`(seed에 본체 슬롯 없음·낱장 단일, C-03 CORRECT). **단 자재유형(mat_typ_cd)이 전부 `.08 실사소재`로 평면화** — 패브릭/가죽 재질 구분 소실([[#SL-DEF-002]] 교정대기). 보드/우드/액자 5상품은 L1 소재 빈값(원본 미명시 정당·AMBIGUOUS).
- 앵커: `t_mat_materials`(mat_typ_cd·소재별) · `t_prd_product_materials`(mat_cd + usage_cd=USAGE.07)
- 출처: `15_domain-spec/silsa/product-bom.md` §0·"BOM 횡단 자재" 표 + `17_correctness/silsa/correction-manifest.md` C-03(usage CORRECT)·C-12(보드 소재 빈값 AMBIGUOUS) {tier C11/C13, FRESH}
- 연결: [[../huni/materials#MAT-001]] (uses — 자재 마스터 구조) · [[../huni/materials#MAT-002]] (uses — parent+usage_cd·낱장 C단일) · [[../huni/materials#MAT-003]] (uses — MAT_TYPE 코드도메인) · [[#SL-DEF-002]] (자재 .08 평면화 교정대기)
- answers_cq: CQ-PROD-05 (자재 축) · CQ-TERM-04 (소재 약어)
- tags: #실사 #자재 #parent_usage #낱장본체 #USAGE07

### [SL-BOM-002] 인쇄방식 = 실사 PROC_000006 (아크릴스티커만 UV PROC_000002)  {✅}
- 내용: 실사 인쇄방식 = **실사 대형 잉크젯 `PROC_000006`**("b.9 실사 default") 단일. **예외: 아크릴스티커(유광142/미러143)는 폴더=레이저커팅 → UV `PROC_000002` 라인**(소재 아크릴 — 시트엔 실사로 묶였으나 폴더가 라우팅 권위). **주의: `PROC_000002`=라이브 db-structure §47 권위로 UV/별색인쇄 코드** — 아크릴 레시피의 UV와 동일 코드([[../huni/processes#PRC-005]] 박·코팅·UV=공정). 라이브엔 **인쇄방식 공정 행 자체가 전 실사 부재**(po=0·실사는 도수 컬럼 없음 — 정당) → 아크릴스티커 UV 라우팅은 정체 인지 사항(Q-SL-A, 영향 작음).
- 앵커: `t_prd_product_processes`(PROC_000006 실사·PROC_000002 UV) · `t_proc_processes`
- 출처: `15_domain-spec/silsa/product-bom.md` §0 인쇄방식 주의·§12 아크릴스티커 + `17_correctness/silsa/product-identity.md` §2 F-ID-4(UV 라우팅) {tier C11/C13, FRESH}
- 연결: [[../huni/processes#PRC-001]] (uses — 공정 마스터·연결 구조) · [[../huni/processes#PRC-005]] (uses — UV=공정 PROC_000002) · [[../base/printing-methods#2-무판--디지털-인쇄]] (uses — 무판 실사/UV 보편)
- answers_cq: CQ-PROC-01 (공정 라우트) · CQ-FIN-04 (인쇄방식 정의)
- tags: #실사 #PROC_000006 #PROC_000002 #아크릴스티커UV

### [SL-BOM-003] 후가공 = 봉제·타공·족자·열재단·보드마운팅 (소재가 완성형태)  {🟡}
- 내용: 실사 후가공은 **소재/완성형태가 가른다**: 패브릭=**봉제(`PROC_000080` param 유형 오버로크/말아박기/봉미싱·폭)**·배너=**4구타공(`PROC_000079` param 구수)**·족자=**족자제작(`PROC_000082` param 모양 사각/원형)**·현수막=**열재단(`PROC_000084`, round-9 silsa CPQ mint)**·보드=**보드마운팅(화이트보드/포맥스 3mm — 공정 마스터 부재)**·코팅=유광(`PROC_000014`)/무광(`PROC_000015`)(코팅=공정 Q9·C-05 CORRECT). **라이브 결함: param variant 손실**(봉제/족자 PROC 행만·param 인스턴스 없음 [[#SL-DEF-003]])·**보드마운팅 공정 마스터 0개**([[#SL-DEF-004]] ddl-proposer). 순수공정(열재단/재단)은 자재 없음([[../huni/processes#PRC-004]]).
- 앵커: `t_proc_processes`(PROC_000079/080/082/084·보드마운팅 부재) · `t_prd_product_processes`
- 출처: `15_domain-spec/silsa/product-bom.md` §4·§8·§9·§10·"BOM 횡단 공정" 표 + `17_correctness/silsa/correction-manifest.md` C-05(코팅 CORRECT)·C-06/C-07(param·보드 MISSING) {tier C11/C13, FRESH}
- 연결: [[../huni/processes#PRC-001]] (uses — 공정 마스터·연결) · [[../huni/processes#PRC-004]] (uses — 열재단=순수공정 자재없음) · [[../base/finishing#BFN-005]] (uses — 타공/도무송 후가공 보편) · [[#SL-DEF-003]] · [[#SL-DEF-004]]
- answers_cq: CQ-PROC-01 (공정 라우트) · CQ-FIN-01 (후가공 공정 목록)
- tags: #실사 #후가공 #봉제 #타공 #족자 #열재단 #보드마운팅

### [SL-BOM-004] 화이트 별색(underbase) = 투명/홀로그램 소재 도메인 필수 (PROC_000008)  {🟡}
- 내용: 투명 소재(접착투명포스터122·투명포스터★) + 홀로그램(141)은 **화이트 underbase(별색) 도메인 필수** — 투명/반사 소재 위 불투명 백색 받침([[../base/color#BCL-005]] white underbase). 별색 = 공정([[../huni/processes#PRC-003]] clr_cd=NULL) → `PROC_000008 화이트`(부모 `PROC_000007 별색`). 접착투명122 라이브 PROC_000008 1행 적재됨(C K6 재현·CORRECT). 라텍스(화이트) 출력 → 재단 레시피(process-recipe §1 Case7).
- 앵커: `t_prd_product_processes`(PROC_000008 화이트·clr_cd=NULL) · `t_proc_processes`(PROC_000007 별색)
- 출처: `15_domain-spec/silsa/product-bom.md` §3 화이트 별색(C18·G-SL-2) + `_gate/silsa-gate.md` K6(접착투명122 PROC_000008 재현) {tier C11/C13, FRESH}
- 연결: [[../base/color#BCL-005]] (uses — 화이트 underbase 보편) · [[../huni/processes#PRC-003]] (uses — 별색=공정 clr_cd=NULL) · [[../huni/processes#PRC-005]] (uses — 별색 공정 풀)
- answers_cq: CQ-FIN-03 (별색=공정) · CQ-FIN-04 (화이트 underbase)
- tags: #실사 #화이트 #underbase #PROC_000008 #투명소재

### [SL-BOM-005] 부속 = addon/set (우드행거·우드봉·천정고리·거치대·끈/각목)  {🟡}
- 내용: 부속붙는 8상품의 부속(우드행거·우드봉·천정형고리·배너거치대·끈/각목/큐방)은 **추가상품 addon 또는 세트** = "단품+부속" 정체. 부속 상품 **`PRD_000008`(천정고리·use_yn=N 비활성)·`PRD_000012`(우드거치대)·`PRD_000013`(우드봉)·`PRD_000014`(우드행거) + 부속 자재 `MAT_000223~229` 전수 실재**(search-before-mint 충족·재연결만). "출력만" = 부속 미선택 기본. **단 라이브 addon=0·set=0**([[#SL-DEF-005]] — 일반현수막138만 round-9 CPQ로 부속 옵션 적재). 끈/각목은 현수막 내부 옵션재료로 보면 자재(.03) BUNDLE([[#SL-CPQ-002]])·독립 동반상품으로 보면 template — 귀속 컨펌(Q-SL-4·CONFIRM-SL-4).
- 앵커: `t_prd_product_addons`(현 0행) · `t_prd_product_sets`(현 0행) · `t_prd_products`(PRD_000008/012/013/014 부속 실재)
- 출처: `17_correctness/silsa/correction-manifest.md` C-08(부속 MISSING·PRD 실재)·C-14(액자 귀속 AMBIGUOUS) + `15_domain-spec/silsa/product-bom.md` §7·§8·§9(부속·우드봉·거치대) {tier C13/C11, FRESH}
- 연결: [[../huni/cpq-options#CPQ-006]] (uses — OTC TEMPLATE 부속 구조) · [[../huni/materials#MAT-001]] (uses — 부속 자재 마스터) · [[#SL-DEF-005]] (부속 미적재) · [[#SL-CPQ-002]] (현수막 끈/각목 BUNDLE)
- answers_cq: CQ-PROD-03 (완제품/부속 귀속) · CQ-PROD-05 (옵션 축)
- tags: #실사 #부속 #addon #set #우드봉 #거치대

---

## 3. 가격 사슬 (price chain) — 실사  앵커: t_prc_* 4단 + t_dsc_*

### [SL-PRC-001] 가격 = 포스터사인 [가로×세로] 면적매트릭스 (실사 inline price 아님 [HARD])  {🟡}
- 내용: 실사 가격 = **인쇄상품 가격표 "포스터사인" 시트의 [가로(col)×세로(row)] 면적매트릭스 셀단가(코팅포함가)** — **실사 시트 자체 inline price(R=price·S=VAT·V=가공가)는 가격 권위 아님 [HARD·사용자]**([[../huni/price-engine#PE-006]] 면적매트릭스형). 셀 687개를 long-form `(comp_cd, siz_cd=치수, unit_price)`로 평면화(13 면적매트릭스 상품 B01~B11 포스터 11 + B26 일반현수막 + B27 메쉬현수막). `clr/mat/coat/bdl/min = NULL`(면적매트릭스는 도수·자재·코팅면·묶음·수량 무관·코팅포함 통가격). **off-grid = 한 단계 큰 치수 ceiling = 앱 런타임 계산·DB는 룩업행만**([[../huni/price-engine#PE-006]]·[[../huni/price-engine#PE-010]]). 실사 시트는 prd_cd 해소(상품명→prd_cd)에만 사용. **[round-2 오모델링 금지]** round-2가 28 포스터상품을 단일 `PRF_POSTER_FIXED`+sparse 대표셀(상품당 1~2셀)로 적재해 매트릭스 소실 → 본 트랙이 명시 매트릭스 셀 전건+ceiling으로 정정. R² 면적-좌표 회귀 미사용([[../huni/price-engine#PE-STALE]] 좌표 회귀 모델 인용 금지).
- 앵커: `t_prc_component_prices`(siz 차원 [가로×세로] long-form 687셀) + 면적공식 + ceiling
- 출처: `02_mapping/silsa-poster-area-matrix/mapping.md` HARD USER RULE·§1.2(13상품 687셀 전수 매핑·prd_cd↔comp_cd) + `06_extract/price-poster-sign-l1.csv`(B·셀단가) {tier C/B, 면적모델 FRESH}
- 연결: [[../huni/price-engine#PE-006]] (priced-by — 면적매트릭스형·off-grid ceiling) · [[../huni/price-engine#PE-010]] (uses — ceiling=앱 계산) · [[../huni/price-engine#PE-STALE]] (STALE — 좌표 회귀 금지) · [[../base/sizes#BSZ-001]] (uses — 가로×세로 치수) · [[#SL-PRC-002]]
- answers_cq: CQ-PRICE-05 (면적 기반 계산) · CQ-PRICE-01 (단가표 vs 공식)
- tags: #실사 #가격 #면적매트릭스 #포스터사인 #실사inline금지

### [SL-PRC-002] 가격 = 면적매트릭스 13상품 + 고정가형 16상품 (2 모델 공존)  {🟡}
- 내용: 실사 29상품 = **면적매트릭스형 13상품**(포스터사인 매트릭스 보유·[[#SL-PRC-001]]) + **고정가형(수량×옵션) 16상품**(포스터사인 매트릭스 미보유 — 보드/액자/시트커팅/아크릴스티커/스탠딩 등 → [[../huni/price-engine#PE-007]] 고정가형). 즉 실사 가격은 단일 공식 아님 — 상품별 모델 분기. 면적매트릭스 적재 구조는 **아크릴 면적매트릭스와 동형**(`09_load/_migrate_areamatrix/` — siz 신규등록 + component_prices long-format, [[recipes/acrylic#AC-PRC-002]] 동형 권위). 가격공식 멱등 PK = (prd_cd, apply_bgn_ymd)([[../huni/price-engine#PE-003]]). 수량구간 할인은 [[../huni/price-engine#PE-008]] `t_dsc_*`(`dsc-code-proposals.md` 제안). **`price-engine-ddl.md` STALE — 인용 금지**([[../huni/price-engine#PE-STALE]]).
- 앵커: `t_prc_component_prices`(면적 13)·고정가 16(수량×옵션) · `t_prc_price_components.prc_typ_cd`(현 라이브 .01 단가형) · `t_dsc_*`
- 출처: `02_mapping/silsa-poster-area-matrix/mapping.md` §1.1(13 면적·16 고정가)·§5 + `02_mapping/silsa-price-engine/price-mapping-spec.md`(고정가형) {tier C, 면적 FRESH·고정가 PARTIAL}
- 연결: [[../huni/price-engine#PE-006]] (priced-by — 면적매트릭스 13) · [[../huni/price-engine#PE-007]] (priced-by — 고정가형 16) · [[../huni/price-engine#PE-008]] (priced-by — 수량구간 할인) · [[../huni/price-engine#PE-003]] (uses — 공식 PK) · [[recipes/acrylic#AC-PRC-002]] (면적매트릭스 동형) · [[#SL-PRC-001]]
- answers_cq: CQ-PRICE-01 (단가표 vs 공식) · CQ-PRICE-08 (견적 합산)
- tags: #실사 #가격 #면적+고정가 #2모델 #silsa-acrylic동형

---

## 4. CPQ 옵션 레이어 — 실사  앵커: t_prd_product_option_groups/options/option_items · constraints · templates

### [SL-CPQ-001] 옵션축(코팅·봉제유형·타공구수·족자모양·부속) → 4엔티티 매핑  {🟡}
- 내용: 실사 옵션성 축은 [[../huni/cpq-options#CPQ-004]] **속성→4엔티티 지도**로 분기: 코팅(무광/유광)=공정·봉제유형/타공구수/족자모양=공정+param·부속(끈/각목/큐방)=자재+공정 BUNDLE([[#SL-CPQ-002]])·소재=mat_cd+usage·size=면적매트릭스 차원([[#SL-DIM-001]]). `option_items`는 polymorphic `ref_dim_cd`로 L1 차원행 참조([[../huni/cpq-options#CPQ-002]]), 무결성은 트리거 `fn_chk_opt_item_ref`([[../huni/cpq-options#CPQ-003]]) 강제 → 차원행 선적재 필수(자재는 `(mat_cd, usage_cd)` 둘 다 PRD 링크 존재해야). 라이브 표준 var 키 = 차원 코드 7종(자재=`mat_cd__usage_cd`·공정=`proc_cd`·도수=`opt_id`). **실사 CPQ는 일반현수막138 파일럿만 적재**([[#SL-CPQ-002]]·[[#SL-DEF-006]]).
- 앵커: `t_prd_product_option_items.ref_dim_cd` · `t_prd_product_option_groups`
- 출처: `10_configurator/silsa-option-layer-v2.md` §0·§4 + `silsa-live-reconciliation.md` §1(라이브 표준 var 7종) {tier C/A, FRESH}
- 연결: [[../huni/cpq-options#CPQ-004]] (uses — 속성→4엔티티) · [[../huni/cpq-options#CPQ-002]] (uses — polymorphic ref_dim_cd) · [[../huni/cpq-options#CPQ-003]] (requires — 무결성 트리거·차원행 선적재) · [[#SL-CPQ-002]]
- answers_cq: CQ-PROD-05 (옵션 축·캐스케이드)
- tags: #실사 #CPQ #속성매핑 #4엔티티

### [SL-CPQ-002] 일반현수막138 = 끈/각목 자재+공정 BUNDLE 파일럿 (oi=18행 COMMIT·라이브 실측)  {🟡}
- 내용: 일반현수막138 옵션(가공6: 열재단/타공4·6·8/양면테입/봉미싱 + 추가5: 추가없음/큐방4/끈4/각목+끈 2규격)은 [[../huni/cpq-options#CPQ-005]] **자재(.03)+공정(.04) BUNDLE 원칙** — 한 옵션이 두 의미(끈=자재 `MAT_000070` + 부착공정 `PROC_000081`·양면테입=자재 `MAT_000069`+부착·봉미싱=실 자재+봉제·각목=신규 자재 mint+끈+부착 다중 seq). **silsa v1은 공정만 반쪽 매핑 → v2가 자재+공정 BUNDLE 재정합**(v1 인용 금지·v2 권위). polymorphic 다중 item_seq가 자재 2개+공정 1개를 한 옵션에 표현. **라이브 일반현수막 option_groups 3·option_items 18행 COMMIT 실재**(round-9 silsa CPQ 파일럿·열재단 `PROC_000084` mint·코드행 멱등 실증·재-dryrun delta 0). 타공=bare-hole(구멍만·아일렛 안 끼움 [D①])이라 process-only([[../huni/processes#PRC-004]]). 큐방/각목/봉제사(실)=신규 자재 mint(인간 승인·[[#SL-DEF-006]]).
- 앵커: `t_prd_product_option_groups`/`options`/`option_items`(PRD_000138 og=3·oi=18 라이브) · `MAT_000069/070`·`PROC_000079/080/081/084`
- 출처: `10_configurator/silsa-option-layer-v2.md` §0·§1·§2·§3(BUNDLE 분해·search-before-mint·DRY-RUN A/B/D 실증) + `_gate/silsa-gate.md` K4(og=3·oi=18 독립 SELECT 재현) {tier C/A, FRESH}
- 연결: [[../huni/cpq-options#CPQ-005]] (uses — 옵션=자재+공정 BUNDLE) · [[../huni/cpq-options#CPQ-002]] (uses — polymorphic 다중 seq) · [[../huni/processes#PRC-004]] (uses — 타공 bare-hole=순수공정) · [[../huni/cpq-options#CPQ-008]] (실사가 라이브 최초 옵션 레이어 사례) · [[#SL-DEF-006]]
- answers_cq: CQ-PROD-05 (옵션 축·BUNDLE) · CQ-FIN-10 (굿즈/사인 전용 후가공 옵션)
- tags: #실사 #CPQ #일반현수막 #BUNDLE #끈각목 #oi18행COMMIT

### [SL-CPQ-003] 캐스케이드 제약 = 비치수 수치 범위 GAP (constraints 0행)  {🔴}
- 내용: 일반현수막138 제약 3종(R-SIZE-NONSPEC 비치수 가로 500~1750/세로 500~5000·R-GAKMOK 각목규격↔세로 호환·R-BONGJE 봉미싱 시 사이즈 확정)은 **전부 라이브 제약 모델로 표현 불가** = GAP — 라이브 폼빌더는 "코팅지→박 금지" 류 **차원 코드 2항 관계**용이지 **연속 수치 범위**용이 아님(표준 var 7종에 width/height/size_mode 수치 var 부재). 라이브 적재 constraint **0행**. 제약은 [[../huni/cpq-options#CPQ-007]] `constraints.logic`(JSONLogic 즉석병합·`constraint_json`은 삭제 STALE [[../huni/cpq-options#CPQ-STALE]]). 검증처 후보 = (A) products 범위 컬럼+앱 검증(유력·DD-1) / (B) 비표준 var JSONLogic / (C) 앱 런타임 — 도메인 결정(Q-SL-7·GAP-NONSPEC-RANGE).
- 앵커: `t_prd_product_constraints`(현 0행) · `t_prd_products.constraint_json`(R-GAKMOK 미적재)
- 출처: `10_configurator/silsa-live-reconciliation.md` §1·§2·§3(LV-1/LV-2 GAP·라이브 표준 var 7종·검증처 후보 A/B/C) {tier C/A, FRESH}
- 연결: [[../huni/cpq-options#CPQ-007]] (uses — constraints.logic) · [[../huni/cpq-options#CPQ-STALE]] (STALE — constraint_json 금지) · [[../huni/price-engine#PE-006]] (size 면적매트릭스 경계) · [[#SL-DIM-001]]
- answers_cq: CQ-PROD-05 (캐스케이드 제약)
- tags: #실사 #CPQ #제약 #비치수범위 #GAP

---

## 5. 위젯 계약 (widget contract) — 실사  앵커: 정규화 계약(huni-widget 03_spec) — DB 외 앵커

### [SL-WID-001] 위젯은 정규화 계약 의존 (DB 독립·면적 입력UX≠가격격자)  {⚪}
- 내용: 실사 위젯은 후니 DB 스키마가 아닌 **정규화 데이터 계약**(상품·옵션·가격 안정 shape)에 의존([[../huni/widget-contract#WID-001]]). 옵션축(소재·size·코팅·후가공·부속)→14 componentType→shadcn 매핑([[../huni/widget-contract#WID-003]]). DB 확정 시 후니 어댑터만 교체([[../huni/widget-contract#WID-002]]) → 위젯 코어 불변. **면적매트릭스 가격은 가로×세로 입력 UX ≠ 가격격자**([[#SL-DIM-001]] silsa 핵심 교훈) — 비치수 범위는 입력 한계일 뿐 유효 가격은 매트릭스 셀. 옵션 캐스케이드 Zustand·Edicus 브리지([[../huni/widget-contract#WID-004]]).
- 앵커: DB 외 — `huni-widget/03_spec/data-contract.md`(어댑터 경계에서 t_*로)
- 출처: `huni-widget/03_spec/data-contract.md`(축 WID-001 경유) {tier D, FRESH}
- 연결: [[../huni/widget-contract#WID-001]] (mapped-to — 정규화 계약) · [[../huni/widget-contract#WID-002]] (mapped-to — 어댑터) · [[../huni/widget-contract#WID-003]] (mapped-to — componentType) · [[../huni/widget-contract#WID-004]] (mapped-to — 캐스케이드·Edicus)
- answers_cq: CQ-PROD-05 (옵션 축 shape) · CQ-PROD-08 (UI 노출)
- tags: #실사 #위젯 #정규화계약 #DB독립 #면적입력UX

### [SL-WID-002] 가격 권위 = 서버 면적매트릭스 (PRICE=0 불가 신호)  {⚪}
- 내용: 실사 위젯 가격은 **서버 권위 + 클라 캐싱**([[../huni/widget-contract#WID-005]]). 후니 가격은 가격엔진 축([[../huni/price-engine#PE-006]] 면적매트릭스·[[../huni/price-engine#PE-007]] 고정가) 권위. RedPrinting PRICE=0은 절대 불가 — 0은 우리측 요청/세션 결함 신호(Red 역산값 후니 이식 금지·ATTB 날조 전례 [[../huni/widget-contract#WID-STALE]]).
- 앵커: DB 외 — 서버 가격 API(후니 가격=t_prc_* 면적매트릭스+고정가)
- 출처: `huni-widget/03_spec/data-contract.md`(축 WID-005 경유) {tier D, FRESH(후보)}
- 연결: [[../huni/widget-contract#WID-005]] (priced-by — 서버 가격권위) · [[../huni/price-engine#PE-006]] (priced-by — 면적매트릭스) · [[../huni/widget-contract#WID-STALE]]
- answers_cq: CQ-PRICE-01 (가격 권위=서버)
- tags: #실사 #위젯 #가격권위 #PRICE0불가

---

## 6. 적재 레시피 (load path) — 실사  앵커: raw/webadmin sql/tools · round-8 admin-ui-spec

### [SL-LP-001] 적재 oracle = load_master(v03 전파기·실사 원본 시트 미독)  {🟡}
- 내용: 실사 라이브 값 = `tools/load_master.py`가 **번호 시트**(`10_상품정보`·`14_상품별자재`·`15_상품별공정` 등)를 전 상품 공통 처리한 직접 결과 — **실사 원본 시트("실사")는 읽지 않는다**(핵심 발견). 번호 시트 = v03 마이그레이션이 실사 원본을 변환한 정규화 산출물. **load_master는 v03 전파기**(거의 정확) — 실사 결함 **거의 전부 v03 마이그레이션 단계**(자재 .08 평면화·카테고리 고아·가공 param 손실·부속 미생성). **[HARD] v03 입력 xlsx 인용 금지**([[../huni/load-path#LP-STALE]]) — 정답 기준 = 상품정체(실제 사이트) > 상품마스터 L1(`silsa-l1.csv`). **사이즈만은 v03이 정확히 변환**(이산 규격+nonspec·CORRECT).
- 앵커: `raw/webadmin/tools/load_master.py`(로직만 oracle·line 165/228/251/261/324/340/404·oracle [[../huni/load-path#LP-001]]) · `sql/01a~23`
- 출처: `17_correctness/silsa/loadlogic-notes.md` §0·§1·§4 (file:line·v03 전파기 입증) {tier C13/A, FRESH}
- 연결: [[../huni/load-path#LP-001]] (loaded-via — 적재 oracle sql+로직) · [[../huni/load-path#LP-STALE]] (v03 금지) · [[#SL-DEF-001]] · [[#SL-DEF-002]]
- answers_cq: CQ-PROD-01 (적재 기준) · CQ-FILE-05 (적재 입력값)
- tags: #실사 #적재 #load_master #v03전파기 #원본시트미독

### [SL-LP-002] FK 위상순서·멱등 UPSERT·search-before-mint  {🟡}
- 내용: 실사 적재 = [[../huni/load-path#LP-003]] **FK 위상순서**(코드행 → 카테고리/자재/공정 마스터 → 상품 → 상품-자식). 멱등 = 이름 기반 UPSERT([[../huni/load-path#LP-004]]). 교정 재연결 대상 **전부 라이브 master 실재** → 신규 mint 최소(search-before-mint·게이트 K5 입증): 정상 카테고리 노드 `CAT_000067~099`·부속 PRD_000012/013/014·정상 자재유형 `.05`/`.06` 코드. **신규 mint 후보** = 보드마운팅 공정 마스터(`C-07` 라이브 0개·ddl-proposer)·끈/각목 BUNDLE 자재(큐방·각목·봉제사 실·열재단 PROC_000084는 적재됨). 입력경로 = admin product-viewer pvEdit([[../huni/load-path#LP-006]]) — 단 "컬럼 존재 ≠ 백필 완료". **천정고리 PRD_000008=use_yn=N**(재연결 전 활성화 필요·F-SL-2).
- 앵커: `t_cat_categories`(067~099 정상노드) · `13_admin-ui-spec/`
- 출처: `17_correctness/_gate/silsa-gate.md` K5(search-before-mint 실재 입증·부속 PRD·정상노드 재사용·보드공정만 mint)·F-SL-2(천정고리 use_yn=N) {tier C13, FRESH}
- 연결: [[../huni/load-path#LP-003]] (loaded-via — FK 위상·코드행 선적재) · [[../huni/load-path#LP-004]] (loaded-via — 멱등 UPSERT·search-before-mint) · [[../huni/load-path#LP-006]] (loaded-via — admin 입력경로) · [[../huni/load-path#LP-007]] (실 적재 현황)
- answers_cq: CQ-FILE-05 (적재 입력값)
- tags: #실사 #FK위상 #멱등 #search-before-mint

---

## 7. 현황·결함 (state) — 실사

> round-13 게이트 GO(K0~K6 PASS·분류 정반대 결함 0·독립 재현 어긋남 0). 라이브 = 교정대상(피고). 아래 양면표기는 `17_correctness/silsa/correction-manifest.md`·`live-diff.md` 대조분만(미대조 라이브값 인용 금지 — G-1/F-PB-1 교훈). 분류 분포(14건): CORRECT 5(+C-09/10 경로불명)·MIS-LOADED 2·MISSING 3·EXTRA 0·AMBIGUOUS 3. **사이즈만은 v03이 정확 변환**(이산 규격+nonspec, round-9 연속범위 오판 부재 입증).

### 7.1 라이브 오적재 양면표기 (라이브 현재값 ↔ 정답)

| ID | 항목 | 라이브 현재값 | 정답 | 상태 | 출처(correction-manifest) |
|---|---|---|---|---|---|
| SL-DEF-001 | 카테고리(28상품) | 전부 `CAT_000298 실사`(upr=NULL 고아·lvl3 부모없음) | 상품명별 정상 노드 `CAT_000067~099`(포스터=CAT_000004·사인=CAT_000005 하위, 전수 실재) + CAT_000298 논리정리 | 🔴 교정대기(High·MIS-LOADED·Q-SL-1) | C-01 |
| SL-DEF-002 | 자재유형(패브릭/가죽 6상품) | 전부 `MAT_TYPE.08 실사소재` | 패브릭(그래픽천/린넨/캔버스/타이벡/메쉬/현수막천)=`.05 원단`·레더(`MAT_000186`)=`.06 가죽` | 🔴 교정대기(Med·MIS-LOADED) | C-04 |
| SL-DEF-003 | 봉제/족자 공정 param(4상품) | 봉제/족자 PROC 1행·param 없음 | 봉제 5종(오버로크/말아박기/봉미싱+폭)·족자 사각/원형 = prcs_dtl_opt param 또는 round-6 CPQ option_items | 🔴 교정대기(Med·MISSING·Q-SL-2) | C-06 |
| SL-DEF-004 | 보드가공 공정(폼/포맥스/스탠딩) | 코팅만·보드마운팅 공정 마스터 **0개** | 보드마운팅 공정 신설(param 색/두께 3mm) + 연결 | 🔴 교정대기(Med·MISSING·ddl-proposer·Q-SL-3) | C-07 |
| SL-DEF-005 | 부속 addon/set(8상품) | addon **0**·set **0**(일반현수막 CPQ만) | 부속 PRD_000008/012/013/014 연결(133→014·134→013·135→008·136/137→012) | 🔴 교정대기(Med·MISSING·Q-SL-4) | C-08 |
| SL-DEF-006 | CPQ 옵션 레이어 | 일반현수막138만 og=3·oi=18(나머지 전 실사 0행) | 면적/고정가 상품 옵션 레이어(코팅·후가공·부속) 적재 필요 | 🔴 미적재(BATCH-6) | C-06·CPQ-008 |
| SL-DEF-007 | 액자 귀속(프레임리스131/레더아트132) | 프레임리스=유광+무광 코팅·레더아트=공정 0 | 액자=공정(액자가공 신설) vs 부속(프레임 별매) 미확정 | 🔴 미결정(AMBIGUOUS·Q-SL-4) | C-14 |

> **정합(CORRECT·유지):** C-02 size(이산 규격+nonspec·연속범위 오판 부재)·C-03 usage(USAGE.07 낱장 단일)·C-05 코팅(유광+무광 옵션 풀)·C-13 투명포스터★ 비활성·C-09 MES NULL(중복 회피 의도)·C-10 qty_unit/output_paper(.01/.기타 경로불명·값 정답)·C-11 수량 NULL(L1 원본 빈값 정합·정정)·C-12 보드 소재 빈값(L1 미명시 정당). (양면표기 불요 — 라이브=정답 또는 L1 정합.)

### 7.2 횡단 결함 참조 (축 페이지 권위)

### [SL-DEF-001] 카테고리 고아 CAT_000298 (28상품·정상노드 067~099 미연결)  {🔴 교정대기}
- 내용: 라이브 현재값 = 실사 28상품 전부 `CAT_000298 실사`(upr_cat_cd=NULL·cat_lvl=3인데 부모 없음 = 고아) 단일 노드 연결 → 정답 = 상품명별 정상 노드 `CAT_000067~099`(포스터=`CAT_000004` 하위·사인=`CAT_000005` 하위, 전수 실재). 진원 = v03 시트11이 실사 28상품을 잉여 "실사" 묶음에 넣음 + `load_categories`(164-178) 상위코드 NULL → 고아 생성(`load_rel_categories`:282-291 충실 치환). **디지털인쇄 #1 C-09(배경지 296)·횡단 카테고리 고아축과 동형**([[../huni/load-path#LP-001]]). 재연결(`t_prd_product_categories` UPDATE cat_cd·search-before-mint) + CAT_000298 논리삭제. **단 정상노드는 lvl 혼재**(067/068=lvl2 upr=004·095/096=lvl3 upr=092·088=lvl2 upr=005·F-SL-1 트리 레벨 보강). Q-SL-1 컨펌(BATCH-1).
- 앵커: `t_prd_product_categories`(CAT_000298 고아 vs CAT_000067~099 정상노드)
- 출처: `17_correctness/silsa/correction-manifest.md` C-01 + `loadlogic-notes.md` §2 L-C(load_categories:164-178·load_rel_categories:282-291) + `_gate/silsa-gate.md` K4(고아 28상품·정상노드 067/088/095/099 독립 SELECT 재현)·F-SL-1 {tier C13, FRESH}
- 연결: [[../huni/load-path#LP-001]] (라이브 권위 — 카테고리 고아 패턴) · [[#SL-ID-001]] (정답 정체) · [[#SL-LP-002]] (재연결 search-before-mint)
- answers_cq: CQ-PROD-01 (카테고리 귀속)
- tags: #결함 #카테고리 #고아 #MIS-LOADED #교정대기

### [SL-DEF-002] 자재유형 .08 평면화 (패브릭=.05·레더=.06이어야)  {🔴 교정대기}
- 내용: 라이브 현재값 = 실사 패브릭/가죽 소재 전부 `MAT_TYPE.08 실사소재`(린넨/캔버스/그래픽천/타이벡/메쉬/현수막천·레더 전부 .08) → 정답 = 패브릭류=`.05 원단`·레더(`MAT_000186`)=`.06 가죽`. 진원 = v03 시트05가 실사 소재 자재구분을 일괄 "실사"(ENUM_ALIAS:110 "실사"→"실사소재"=.08)로 채움 → 재질 분류(원단/가죽) 소실(`load_materials`:239 충실 반영·MAT_TYP_OVERRIDE:116은 실사 소재 미포함). **결정적 대조: 같은 레더가 책자=`MAT_000008/173~175 .06`인데 실사 레더 `MAT_000186`=.08**(K4 독립 SELECT 입증). **`MAT_000186` 레더 1행→6상품 횡단 오염**([[../huni/materials#MAT-006]] 레더 3-way·[[../huni/materials#MAT-005]] MAT_TYPE 오염축). 자재 마스터 mat_typ_cd UPDATE(search-before-mint·.05/.06 코드 실재).
- 앵커: `t_mat_materials`(mat_typ_cd .08 → .05/.06·MAT_000181~188)
- 출처: `17_correctness/silsa/correction-manifest.md` C-04 + `loadlogic-notes.md` §2 L-A(load_materials:239·ENUM_ALIAS:110·OVERRIDE:116) + `_gate/silsa-gate.md` K4(레더 .08 vs 책자 .06 결정 대조) {tier C13, FRESH}
- 연결: [[../huni/materials#MAT-005]] (라이브 권위 — MAT_TYPE 오염 ~120행) · [[../huni/materials#MAT-006]] (레더 .06 3-way·MAT_000186 6상품) · [[../huni/materials#MAT-003]] (MAT_TYPE 도메인) · [[#SL-BOM-001]]
- answers_cq: CQ-PROD-05 (자재유형 분류)
- tags: #결함 #자재유형 #08평면화 #레더 #MIS-LOADED #교정대기

### [SL-DEF-003] 봉제/족자 공정 param 손실 (4상품·variant 축약)  {🔴 교정대기}
- 내용: 라이브 현재값 = 린넨패브릭124·캔버스패브릭125·린넨우드봉족자134·족자포스터135 봉제/족자 PROC 1행·param 없음 → 정답 = 봉제 5종(오버로크/말아박기/봉미싱7cm+리본끈/면끈)·린넨우드봉=오버로크+봉미싱(4cm)·족자=사각/원형. 진원 = v03 시트15가 옵션 variant 축약 + `load_rel_processes`(404-421)가 PROC 행만 치환·param 인스턴스 경로 없음(스키마상 product_processes에 param 인스턴스 컬럼 부재·param은 마스터 prcs_dtl_opt에만). 공정 마스터 봉제(`PROC_000080` param 유형/폭)·족자(`PROC_000082` param 모양) 실재 → param 보존처가 GAP([[../huni/cpq-options#CPQ-GAP-2]] ref_param_json). round-6 CPQ option_items(일반현수막 패턴) 또는 prcs_dtl_opt param 인스턴스로 적재. Q-SL-2.
- 앵커: `t_prd_product_processes`(PROC_000080/082 param 인스턴스 부재) · `t_proc_processes`(param 마스터 실재)
- 출처: `17_correctness/silsa/correction-manifest.md` C-06 + `loadlogic-notes.md` §2 L-B(load_rel_processes:404-421·param 경로 없음) {tier C13, FRESH}
- 연결: [[../huni/processes#PRC-001]] (정답 공정 param) · [[../huni/cpq-options#CPQ-GAP-2]] (ref_param_json GAP) · [[#SL-BOM-003]]
- tags: #결함 #봉제 #족자 #param손실 #MISSING #교정대기

### [SL-DEF-004] 보드마운팅 공정 마스터 0개 (폼/포맥스/스탠딩 표현 불가)  {🔴 교정대기}
- 내용: 라이브 현재값 = 폼보드129/포맥스보드130(코팅만)·미니보드스탠딩144(공정 0) → 정답 = 폼보드=화이트보드/블랙보드·포맥스=화이트포맥스(3mm)/(5mm)·스탠딩=스탠딩가공. 진원 = **보드/포맥스/마운팅/스탠딩 공정 마스터 자체가 라이브 0개**(K4 count=0 입증) → 표현 불가. v03 시트15/06이 보드가공 공정 미생성(`load_rel_processes` 범위 밖). 보드마운팅 공정 마스터 신설(PROC `보드마운팅` + param 색/두께·스탠딩) = 코드 신규 mint(데이터 INSERT·ddl-proposer). Q-SL-3.
- 앵커: `t_proc_processes`(보드마운팅/스탠딩 공정 0개)
- 출처: `17_correctness/silsa/correction-manifest.md` C-07 + `loadlogic-notes.md` §2 L-B(보드 공정 마스터 부재 SELECT count=0) + `_gate/silsa-gate.md` K5(보드공정만 정당 mint) {tier C13, FRESH}
- 연결: [[../huni/processes#PRC-001]] (공정 마스터 신설) · [[#SL-BOM-003]] (보드마운팅 후가공)
- tags: #결함 #보드마운팅 #공정마스터부재 #MISSING #ddl-proposer #교정대기

### [SL-DEF-005] 부속 addon/set 미생성 (8상품·PRD 실재·재연결만)  {🔴 교정대기}
- 내용: 라이브 현재값 = 실사 addon **0행**·set **0행**(일반현수막138만 round-9 CPQ로 옵션 적재) → 정답 = 캔버스행잉133=우드행거(`PRD_000014`)·린넨우드봉족자134=우드봉(`PRD_000013`)·족자포스터135=천정고리(`PRD_000008`)·PET배너136/메쉬배너137=우드거치대(`PRD_000012`). 진원 = v03 시트20/19에 실사 부속 행 미생성(L1 추가 C21 자유텍스트 "우드봉+면끈 포함" 등이 별매 PRD로 정규화 안 됨·`load_rel_addons`:436 범위 밖·디지털인쇄 C-04 동형). **부속 PRD_000008/012/013/014 + 자재 MAT_000223~229 전수 실재 → hard-delete 아님·재연결만**(search-before-mint·K5 입증). **단 천정고리 PRD_000008=use_yn=N**(비활성·재연결 전 활성화 필요·F-SL-2). "출력만"=addon 미선택 기본. Q-SL-4.
- 앵커: `t_prd_product_addons`(현 0행·PRD_000008/012/013/014 부속) · `t_prd_product_sets`(현 0행)
- 출처: `17_correctness/silsa/correction-manifest.md` C-08 + `loadlogic-notes.md` §2 L-D(load_rel_addons:436·시트20 미생성) + `_gate/silsa-gate.md` K4(부속 PRD search·천정고리 use_yn=N)·F-SL-2 {tier C13, FRESH}
- 연결: [[#SL-BOM-005]] (부속=addon/set) · [[../huni/cpq-options#CPQ-006]] (OTC TEMPLATE 구조) · [[#SL-LP-002]] (재연결 search-before-mint)
- tags: #결함 #부속 #addon #set #MISSING #재연결 #교정대기

### [SL-DEF-006] CPQ 옵션 레이어 = 일반현수막138 파일럿만 (나머지 전 실사 미적재)  {🔴 미적재}
- 내용: 라이브 현재값 = 실사 CPQ는 **일반현수막138 og=3·option_items 18행만 실재**(round-9 silsa 파일럿 COMMIT·라이브 최초 옵션 레이어 사례 중 하나·LV-3), 나머지 전 실사 0행 → 정답 = 면적/고정가 상품의 옵션 레이어(코팅·봉제유형·타공구수·족자모양·부속) 적재 필요. **일반현수막은 constraints 0행**(비치수 수치 범위 표현 불가 GAP [[#SL-CPQ-003]]). 전 family CPQ 전면 미적재 횡단([[../huni/cpq-options#CPQ-008]]). BATCH-6 일괄 적재 미결([[../huni/cpq-options#CPQ-GAP-1]]).
- 앵커: `t_prd_product_option_items`(일반현수막 18행·나머지 0행)
- 출처: `10_configurator/silsa-live-reconciliation.md` §4 LV-3(L2 전 상품 미적재·silsa 최초 사례) + `_gate/silsa-gate.md` K4(og=3 재현) + 축 [[../huni/cpq-options#CPQ-008]](라이브 18행 CONF-1) {tier C/A/C13, FRESH}
- 연결: [[../huni/cpq-options#CPQ-008]] (전면 미적재·silsa 파일럿) · [[../huni/cpq-options#CPQ-GAP-1]] (BATCH-6) · [[#SL-CPQ-002]] (일반현수막 파일럿)
- tags: #결함 #CPQ미적재 #일반현수막파일럿 #BATCH-6 #미적재

### [SL-DEF-007] 액자 귀속 = 공정(액자가공) vs 부속(프레임 별매) 미확정  {🔴 미결정}
- 내용: 라이브 현재값 = 프레임리스우드액자131(유광+무광 코팅만)·레더아트액자132(공정 0행) → 정답 미확정 = 액자를 **공정(액자가공 신설)**으로 볼지 **부속(프레임 별매 PRD/template)**으로 볼지 결정 대기(AMBIGUOUS). 진원 = L1 추가 자유텍스트("우드 프레임 포함" 등)가 액자 가공/별매 정규화 미수행. 레더아트액자132는 에디터 surface(디자인명 변형)이라 본체+액자 결합 형태가 정체에 묶임. **부속 8상품 귀속(Q-SL-4)과 동일 결정 묶음** — 우드행거/우드봉/천정고리/거치대가 기존 PRD addon 재연결(search-before-mint 충족)인 반면, 액자는 기존 PRD 부재라 공정 신설 vs PRD 신규 mint 분기. 디지털인쇄 봉투세트 Q-ID-A·상품악세사리 봉투 sets 결정과 동류(완제품에 묶인 부속의 모델 선택).
- 앵커: `t_prd_product_processes`(액자가공 공정 0개) · `t_prd_product_addons`/`t_prd_product_sets`(프레임 별매 0행) · `t_prd_products`(PRD_000131/132)
- 출처: `17_correctness/silsa/correction-manifest.md` C-14(액자 귀속 AMBIGUOUS) + `_gate/silsa-gate.md` K4(131 코팅·132 공정 0 재현) {tier C13, FRESH}
- 연결: [[#SL-DEF-005]] (부속 귀속 동일 결정 묶음·Q-SL-4) · [[#SL-BOM-005]] (부속=addon/set) · [[../huni/cpq-options#CPQ-006]] (OTC TEMPLATE 부속 구조) · [[../huni/processes#PRC-001]] (액자가공 공정 신설 경로)
- answers_cq: CQ-PROD-03 (완제품/부속 귀속)
- tags: #결함 #액자 #귀속미확정 #AMBIGUOUS #미결정

### 7.3 GAP / 🔴 컨펌 (인간 결정 대기)

- **[GAP-SL-1] 🔴 카테고리 재연결 + 잉여 고아 정리 (Q-SL-1·BATCH-1)** — [[#SL-DEF-001]]. 실사 28상품을 정상노드 067~099로 재연결 + CAT_000298 논리삭제(권장·search-before-mint) vs CAT_000298 upr만 보정(잉여 노드 잔존)? 디지털인쇄 Q-ID-B 동형 결정. → [[../huni/load-path#LP-001]].
- **[GAP-SL-2] 🔴 봉제/족자 옵션 variant 적재 위치 (Q-SL-2)** — [[#SL-DEF-003]]. 봉제 5종·족자 사각/원형을 round-6 CPQ option_items(일반현수막 패턴) vs 공정 prcs_dtl_opt param 인스턴스? → [[../huni/cpq-options#CPQ-GAP-2]].
- **[GAP-SL-3] 🔴 보드마운팅 공정 마스터 신설 (Q-SL-3)** — [[#SL-DEF-004]]. PROC `보드마운팅`(param 색/두께) 신설? → [[../huni/processes#PRC-001]] · ddl-proposer.
- **[GAP-SL-4] 🔴 부속·액자 귀속 (Q-SL-4·CONFIRM-SL-4)** — [[#SL-DEF-005]]·[[#SL-DEF-007]]. 우드행거/우드봉/천정고리/거치대=기존 PRD addon 연결(search-before-mint 충족·천정고리 활성화 선행)? 액자(프레임리스/레더아트)=공정(액자가공) vs 부속(프레임 별매)? "출력만"=addon 미선택 기본 맞나?
- **[GAP-SL-5] 🔴 끈/각목 BUNDLE 자재 mint·각목 2규격 모델 (silsa-option-layer-v2 D-1/D-2)** — [[#SL-CPQ-002]]. 큐방·각목(900이하/초과)·봉제사(실) 신규 자재 mint(MAT_TYPE.07·search-before-mint 재증명 부재). 각목 2규격 = 별 mat_cd 2개 vs 단일+param. 타공 구수(4/6/8)·각목 규격 param 보존처(ref_param_json) GAP-PARAM. → [[../huni/cpq-options#CPQ-005]] · [[../huni/cpq-options#CPQ-GAP-2]].
- **[GAP-SL-6] 🔴 CPQ 옵션 레이어 일괄 적재 (BATCH-6)** — [[#SL-DEF-006]]. → [[../huni/cpq-options#CPQ-GAP-1]].
- **[GAP-SL-7] 🔴 비치수 수치 범위 검증처 (Q-SL-7·DD-1·GAP-NONSPEC-RANGE)** — [[#SL-CPQ-003]]. R-SIZE-NONSPEC/R-GAKMOK/R-BONGJE = products 범위 컬럼+앱(A·유력) vs 비표준 var JSONLogic(B) vs 앱 런타임(C)? → [[../huni/cpq-options#CPQ-007]].
- **[GAP-SL-8] 🟡 수량 빈값 보완·보드/우드 자재 신설·아크릴스티커 UV 라우팅 (Q-SL-5·6·A)** — 메쉬현수막/홀로그램/유광아크릴 수량 L1 빈값(유지 vs 동류값 1/10000/1)·보드/우드 자재 신설(L1 빈값 정당 여부)·아크릴스티커 인쇄방식 공정 행 추가 여부(영향 작음).

> 실 교정 COMMIT은 round-5/10 트랙 인간 승인 대기 — **DB 미적재 유지**([[../huni/load-path#LP-GAP-4]]·[[../huni/load-path#LP-007]] GO분만 적재).

---

## Sources
- **큐레이션 팩:** `_curation/pack-silsa.md`(1차 권위·tier·freshness).
- **정체:** `17_correctness/silsa/product-identity.md`(C13·FRESH·실제 사이트+product-master 권위0·29상품 정체표) — 보조 `06_extract/silsa-l1.csv`(B·115행)·`silsa-l1-report.md`.
- **차원/BOM:** `15_domain-spec/silsa/product-bom.md`·`column-dictionary.md`(C11·소재 기반 13군·면적형·화이트 underbase·봉제/타공/족자) · `mapping-info.md`.
- **가격:** `02_mapping/silsa-poster-area-matrix/mapping.md`(C·포스터사인 [가로×세로] 면적매트릭스 687셀·13상품·HARD USER RULE·면적모델 FRESH) + `06_extract/price-poster-sign-l1.csv`(B·셀단가) + `silsa-price-engine/price-mapping-spec.md`(고정가형 16) + `09_load/_migrate_areamatrix/`(아크릴 동형 적재).
- **CPQ:** `10_configurator/silsa-option-layer-v2.md`(C/A·자재+공정 BUNDLE 재정합·DRY-RUN 실증) + `silsa-live-reconciliation.md`(라이브 표준 var 7종·LV-1~5·비치수 범위 GAP) — v1 `silsa-option-layer.md` §3 supersede.
- **위젯:** `huni-widget/03_spec/data-contract.md`(D·FRESH).
- **적재경로:** `17_correctness/silsa/loadlogic-notes.md`(C13·file:line·load_master v03 전파기·원본 시트 미독) + `raw/webadmin/sql/`·`tools/load_master.py`(로직만·A).
- **결함:** `17_correctness/silsa/correction-manifest.md`·`live-diff.md`(C13·14건 분류) + `17_correctness/_gate/silsa-gate.md`(K0~K6 GO·분류 정반대 0·F-SL-1/2 Low).
- **축 페이지(횡단 참조):** `huni/{materials,processes,price-engine,cpq-options,widget-contract,load-path}.md`.
- **STALE(인용 0 확인):** `price-engine-ddl.md`([[../huni/price-engine#PE-STALE]] 좌표 회귀·mapping.md가 DDL 권위로 인용하나 본 페이지는 미인용)·`constraint_json`([[../huni/cpq-options#CPQ-STALE]])·`dep_proc_cd`(silsa-option-layer-v2 §4 0행 사용 확인)·v03 입력 xlsx([[../huni/load-path#LP-STALE]]) — 본 페이지 미인용.
