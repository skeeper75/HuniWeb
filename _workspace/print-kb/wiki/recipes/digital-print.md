# 디지털인쇄(digital-print) 레시피  {전체상태: 🟡}

> slug `digital-print` · 상품마스터 시트2(가장 복잡 — 별도설정 9건). 엽서·포토카드·접지카드·명함·상품권·배경지·인쇄홍보물(라벨택 포함).
> **조립 뷰**(README §3·§9): 횡단 사실은 축 페이지([[../huni/...]])를 `uses`/`requires`/`excludes`/`priced-by`/`loaded-via`/`mapped-to`로 참조만 한다. family 고유 사실(prd_cd 목록·교정대기 행)만 본문에 원자 블록으로 둔다.
> 권위 = 큐레이션 팩 `_curation/pack-digital-print.md`(정답 file:§·tier·freshness 1차 권위). round-13 결함 18건(C-01~C-18).
> **STALE 인용 0**: `price-engine-ddl.md`·v03 xlsx·constraint_json/dep_proc_cd 적재 타깃은 전부 인용 금지(축 STALE 블록 참조).

## CQ 헤더 (이 페이지가 답하는 질문)
- 디지털인쇄는 무엇인가 — 어떤 상품 36종이며 정체(일반 인쇄물 vs 포장 세트)는?
- 어떤 차원(size·판형)·자재/공정·옵션을 갖는가?
- 가격은 어떻게 계산되는가(원자합산형) / DB에 어떻게 등록하는가?
- 현재 라이브 적재 상태·교정 대기(C-01~18)·미결 컨펌은 무엇인가?

---

## 0. 정체 (identity) — 디지털인쇄
앵커: `t_prd_products` · `t_cat_categories`

### [DGP-ID-001] 디지털인쇄 = 36 distinct 상품 / 7 구분 그룹 (시트2)  {✅}
- 내용: 디지털인쇄 시트는 **36 distinct 상품**(L1 prd_nm 기준)이며, "7"은 상품 수가 아니라 **7개 `구분`(시트 편의 그룹)** = 엽서·포토카드·접지카드·명함·상품권·배경지·인쇄홍보물이다. round-11/12 "7상품" 표기는 구분 그룹 수를 상품 수로 축약한 오표기(F-ID-0·F-GATE-2 정정: 명함=10·합=36).
- 앵커: `t_prd_products`(36행) · `t_cat_categories`
- 출처: `17_correctness/digital-print/product-identity.md` §0(distinct 36 표·F-ID-0) {tier C13, FRESH}
- 연결: [[#DGP-ID-002]] · [[#DGP-ID-003]]
- answers_cq: CQ-PROD-01 (상품 분류 기준)
- tags: #디지털인쇄 #정체 #36상품 #7구분

### [DGP-ID-002] 구분별 상품·prd_cd 범위·대표 상품  {✅}
- 내용: family 고유 사실 — 구분별 distinct 수·라이브 prd_cd 범위·대표(BOM) 상품.

| 구분 | distinct | prd_cd 범위 | 대표 상품(BOM) | 범주 |
|------|:--:|------|------|------|
| 엽서 | 8 | PRD_000016~019 외 | 프리미엄엽서(016) | 일반 인쇄물 |
| 포토카드 | 3 | PRD_000024 외 | 포토카드(024) | 일반 인쇄물 |
| 접지카드 | 4 | PRD_000027 외 | 2단접지카드(027) | 일반 인쇄물 |
| 명함 | 10 | PRD_000031 외 | 프리미엄명함(031) | 일반 인쇄물 |
| 상품권 | 2 | PRD_000041·042 | 스탠다드쿠폰/상품권(041) | 일반 인쇄물 |
| 배경지 | 4 | PRD_000043·044·045·046 | 인쇄배경지OPP(043) | **포장재(012)** |
| 인쇄홍보물 | 5 | PRD_000047 외 | 소량전단지(047) | 일반 인쇄물 |

- 앵커: `t_prd_products.prd_cd`
- 출처: `17_correctness/digital-print/product-identity.md` §0 표·§1 정체확정표 {tier C13, FRESH}
- 연결: [[#DGP-ID-003]] (배경지 포장세트) · [[#DGP-ST-001]] (카테고리 오연결)
- tags: #디지털인쇄 #prd_cd #구분

### [DGP-ID-003] 배경지(043/044/045) = 포장 세트, 라벨택(046) = 포장 단품  {✅}
- 내용: **배경지(043 OPP봉투타입·044 투명케이스타입·045 인쇄헤더택)는 카테고리 012 "포장" 상품이며 "배경지 카드 + 봉투/케이스(사이즈매칭)" 세트로 판매**된다(일반 인쇄물 아님). 라벨/택(046)은 카테고리 012 포장이나 단품(형상 커팅). 정체를 "일반 인쇄물"로 보면 봉투 세트·전용 커팅·포장 카테고리가 누락된다(round-11/12 오분류 → round-13 정정).
- 앵커: `t_cat_categories`(CAT_000012 포장 하위) · `t_prd_product_sets`/`addons`(세트 — 적재모델 미결 Q-ID-A)
- 출처: `17_correctness/digital-print/product-identity.md` F-ID-1·F-ID-2(사이트 `goods_view_102.html`·product-master:82/172/380) {tier C13, FRESH}
- 연결: [[#DGP-DM-002]] (봉투 세트 축) · [[#DGP-ST-001]] (카테고리 고아) · [[../huni/cpq-options#CPQ-006]] (uses — OTC 세트 표현 후보)
- answers_cq: CQ-PROD-11 (묶음/세트 판매 단위) · CQ-PROD-03 (완제품 귀속)
- tags: #디지털인쇄 #포장세트 #배경지 #정체오분류정정

---

## 1. 차원 (dimensions) — 디지털인쇄
앵커: `t_prd_product_sizes`/`plate_sizes`/`bundle_qtys`/`sets` · `t_siz_sizes`

### [DGP-DM-001] 사이즈 = 이산 행 (엽서 7행·라벨택 3행)  {✅}
- 내용: 디지털인쇄 사이즈는 **이산 사이즈 행**(면적매트릭스 아님). family 고유 실측값: 프리미엄엽서(016) = 7행(73x98~148x210)·라벨택(046) = 3행(40x80·50x50·25x110)로 엑셀 L1 nonblank와 라이브 일치(CORRECT). **round-12 "엽서 13종"은 오류**(C-01 정정).
- 앵커: `t_prd_product_sizes` · `t_siz_sizes`
- 출처: `17_correctness/digital-print/correction-manifest.md` C-01·C-12(독립 SELECT 일치) {tier C13, FRESH}
- 연결: [[../base/sizes#BSZ-001]] (uses — 재단/작업/출력판형 보편) · [[#DGP-DM-003]]
- tags: #디지털인쇄 #사이즈 #이산 #C-01

### [DGP-DM-002] 봉투/케이스 세트 = 사이즈매칭 캐스케이드 (배경지)  {🟡}
- 내용: family 고유 사실 — 배경지(043) = 6 사이즈×매칭 OPP봉투, 배경지(044) = 2 사이즈×PP투명케이스 세트. 봉투가 엑셀 C38 자유텍스트라 `load_rel_addons` 파싱 범위 밖 → **라이브 미적재(addon=0·sets=0)**. 적재모델은 sets vs addons vs CPQ 옵션 미결([DGP-ST-005] Q-ID-A).
- 앵커: `t_prd_product_sets` 또는 `t_prd_product_addons`(미적재) — 사이즈 매칭 캐스케이드
- 출처: `17_correctness/digital-print/correction-manifest.md` C-08·C-11(MISSING) {tier C13, FRESH}
- 연결: [[#DGP-ID-003]] · [[../huni/cpq-options#CPQ-007]] (excludes — 사이즈매칭=캐스케이드 제약 후보)
- tags: #디지털인쇄 #봉투세트 #사이즈매칭 #MISSING

### [DGP-DM-003] 출력판형 = OUTPUT_PAPER_TYPE.01 국전계열 (값정답·경로불명)  {🟡}
- 내용: 전 디지털 상품 plate `output_paper_typ` = **OUTPUT_PAPER_TYPE.01(국전계열 316x467)** — 값은 정답이나 적재 경로가 webadmin 밖(후속 plate교정 c722c24 산물, load_master.py:340은 무조건 .기타 적재). 판형은 출력용지규격을 가리킨다(작업사이즈 아님).
- 앵커: `t_prd_product_plate_sizes`(output_paper_typ_cd) · `t_siz_sizes`
- 출처: `17_correctness/digital-print/correction-manifest.md` C-16(CORRECT-경로불명) {tier C13, FRESH}
- 연결: [[../base/sizes#BSZ-003]] (uses — 출력판형 보편 정의) · [[../huni/load-path#LP-007]] (loaded-via — GO분 적재됨·경로불명)
- answers_cq: CQ-FILE-05 (조판/임포지션 적재 입력값)
- tags: #디지털인쇄 #출력판형 #plate #값정답경로불명

### [DGP-DM-004] 묶음수 단위 = QTY_UNIT.02 매 (값정답·라이브 미적재)  {🟡}
- 내용: 묶음수 단위 컬럼은 `bdl_unit_typ_cd`(라이브 실컬럼)이며 정답값 = **QTY_UNIT.02(매)**(코드 실재). 단 샘플 디지털 상품(016/043/047)의 `t_prd_product_bundle_qtys` 행은 **0행 = 라이브 미적재**(라이브 재측정). load_master.py:269가 단위를 None 하드코딩 → 값정답이나 webadmin 경로로는 미적재(경로불명 finding).
- 앵커: `t_prd_product_bundle_qtys`(bdl_unit_typ_cd)
- 출처: `17_correctness/digital-print/correction-manifest.md` C-15(CORRECT-경로불명) + 라이브 재측정(샘플 016/043/047 bundle_qtys 0행) {tier C13, FRESH}
- 연결: [[../huni/load-path#LP-004]] (loaded-via — 멱등 적재)
- tags: #디지털인쇄 #묶음수 #bdl_unit_typ_cd #값정답미적재

---

## 2. 자재·공정 BOM — 디지털인쇄
앵커: `t_prd_product_materials`/`processes` · `t_mat_materials` · `t_proc_processes`

### [DGP-BM-001] 자재 = parent + usage_cd (낱장 → USAGE.07 공통)  {🟡}
- 내용: 디지털인쇄는 낱장 단일 본문 자재라 자재 모델은 **parent + usage_cd**의 단일 슬롯으로 충분([[../huni/materials#MAT-002]]). family 고유 실측: 엽서(016) 자재 21행이 USAGE.07(공통)으로 적재 — load_master.py:324 빈 용도→USAGE.07 default(정당). 도메인 의미는 "본체"이나 코드는 공통(정당).
- 앵커: `t_prd_product_materials.usage_cd`(USAGE.07)
- 출처: `17_correctness/digital-print/correction-manifest.md` C-03(CORRECT) {tier C13, FRESH}
- 연결: [[../huni/materials#MAT-002]] (uses — parent+usage_cd 낱장 C단일) · [[../base/paper#BPP-003]] (uses — 종이 종류)
- answers_cq: CQ-PROD-05 (자재 축)
- tags: #디지털인쇄 #자재 #usage_cd #낱장

### [DGP-BM-002] 공정 = 디지털출력→별색→코팅→재단→커팅→후가공→포장  {🟡}
- 내용: family 고유 공정 라우트(대표 엽서 016 = 모서리·오시·미싱·가변 6행, 별색/코팅/커팅 없음 = CORRECT C-02). 별색은 도수가 아니라 공정으로 들어온다([[../huni/processes#PRC-003]]). 박/코팅/UV도 공정([[../huni/processes#PRC-005]]).
- 앵커: `t_prd_product_processes` · `t_proc_processes`
- 출처: `17_correctness/digital-print/correction-manifest.md` C-02 + `17_correctness/digital-print/product-identity.md` §1 생산방식 {tier C13, FRESH}
- 연결: [[../huni/processes#PRC-001]] (uses — 공정 구조) · [[../huni/processes#PRC-003]] (uses — 별색=공정 clr_cd=NULL) · [[../base/finishing#BFN-001]] (uses)
- answers_cq: CQ-PROC-01 (공정 라우트)
- tags: #디지털인쇄 #공정 #별색 #라우트

### [DGP-BM-003] 배경지/라벨택 전용 커팅·접지 = MISSING  {🔴 교정대기}
- 내용: family 고유 결함 — 배경지(043)/라벨택(046) 전용 커팅 ~13형상(기본형/타공형/핀고정형/북마크/스마트톡형/카드고정형/키링형/폰스트랩형 등)이 **라이브 0행 → 정답: PROC_000053(완칼) + prcs_dtl_opt(형상 param)**. 배경지(044) 접지 = **0행 → 정답: PROC_000056(접지 family)**. load_master 시트15에 배경지 행 부재(v03 진원)로 미적재.
- 앵커: `t_prd_product_processes`(PROC_000053 완칼·PROC_000056 접지 — 미적재)
- 출처: `17_correctness/digital-print/correction-manifest.md` C-07·C-10·C-13(MISSING) {tier C13, FRESH}
- 연결: [[../huni/processes#PRC-004]] (uses — 완칼=순수공정) · [[../huni/load-path#LP-STALE]] (v03 진원)
- tags: #디지털인쇄 #커팅 #접지 #MISSING #교정대기

### [DGP-BM-004] 박 부모 PROC_000033 vs 박색 8자식 = AMBIGUOUS  {🔴}
- 내용: family 고유 결함 — 상품권(042) `박(있음)` 단일 엑셀 신호인데 라이브는 박색 자식 8종(037~044) 연결·**부모 PROC_000033 미연결**. 8색이 옵션 풀(CPQ option_items)인지 부모 박 행 추가가 필요한지 미결(C-06·Q-DP-C). 위키는 어느 쪽도 단정하지 않는다.
- 앵커: `t_proc_processes`(부모 PROC_000033 미연결) vs 박색 8자식
- 출처: `17_correctness/digital-print/correction-manifest.md` C-06(AMBIGUOUS)·§4 Q-DP-C {tier C13, FRESH}
- 연결: [[../huni/processes#PRC-GAP-3]] (박 부모 미연결 = 축 GAP) · [[../huni/processes#PRC-005]] (uses — 박=공정)
- answers_cq: CQ-FIN-05 (박 vs 형압 vs 별색금 DB 인코딩)
- tags: #디지털인쇄 #박 #옵션풀 #AMBIGUOUS

---

## 3. 가격 사슬 (price chain) — 디지털인쇄
앵커: `t_prc_*` 4단 + `t_dsc_*`

### [DGP-PR-001] 디지털인쇄 가격 = 원자합산형 PRF_DGP_A~F + 용지비  {🟡}
- 내용: 디지털인쇄 가격은 **원자 구성요소 합산**(인쇄비 + 용지비 COMP_PAPER + 공정비). 공식 6종 PRF_DGP_A~F(라이브 308행 COMMIT·공식사슬 완결). 별색=공정이 합산 항목으로 들어온다([[../huni/processes#PRC-003]]). 판수(판걸이수)는 DB 미저장 = 앱 계산([[../huni/price-engine#PE-010]]).
- 앵커: `t_prc_price_formulas`(PRF_DGP_A~F) + COMP_PAPER
- 출처: `02_mapping/digital-print-engine/`(digital-print-price-engine-design.md·PRF/COMP csv) {tier C2, 공식사슬 FRESH·차원 컬럼 PARTIAL-STALE I-1·I-2}
- 연결: [[../huni/price-engine#PE-005]] (priced-by — 원자합산형 PRF_DGP) · [[../huni/price-engine#PE-010]] (uses — 판수=앱 계산) · [[../base/paper#BPP-002]] (uses — 용지 평량)
- answers_cq: CQ-PRICE-03 (디지털인쇄 단가 매트릭스 구조) · CQ-PRICE-06 (후가공 가산 단가)
- tags: #디지털인쇄 #가격 #합산형 #PRF_DGP

### [DGP-PR-002] 가격 차단 = 박·3절/투명/048/019 (plate 교정 대기)  {🔴}
- 내용: family 고유 차단 — 디지털 308행은 COMMIT됐으나 박 등급별 가격 GAP·3절/투명/048/019 등은 plate 교정 대기로 가격 차단(미적재). 박 면적→등급은 앱 계산이고 DB는 등급별 가격만 저장([[../huni/price-engine#PE-010]]).
- 앵커: `t_prc_component_prices`(차단 행) · plate 교정 의존
- 출처: 메모리 `dbmap-digitalprint-atomic-formula-unbuilt`(잔존 차단=3절/투명/박/048/019) + `02_mapping/digital-print-engine/*_BLOCKED_*.csv` {tier C, FRESH}
- 연결: [[../huni/price-engine#PE-GAP-4]] (박 가격 GAP·plate 교정 대기) · [[#DGP-DM-003]]
- tags: #디지털인쇄 #가격차단 #박 #plate교정 #GAP

### [DGP-PR-003] 구간할인 = 디지털인쇄는 카테고리 단위 미적용 (대조)  {🟡}
- 내용: 수량구간 할인(t_dsc_*)은 아크릴/굿즈파우치/문구 카테고리 단위 적용([[../huni/price-engine#PE-008]]) — 디지털인쇄는 그 적용 대상이 아니다(구간형 공식 family 아님). 디지털 가격은 원자합산형([DGP-PR-001]).
- 앵커: `t_dsc_*`(디지털인쇄 미연결)
- 출처: `00_schema/discount-domain-detail.md` + 메모리 `dbmap-discount-authority`(적용 대상 = 아크릴/굿즈파우치/문구) {tier A/C, FRESH}
- 연결: [[../huni/price-engine#PE-008]] (구간형 — 디지털인쇄 비대상)
- answers_cq: CQ-PRICE-04 (수량 구간별 할인 체계)
- tags: #디지털인쇄 #구간할인 #비대상

---

## 4. CPQ 옵션 레이어 — 디지털인쇄
앵커: `t_prd_product_option_groups`/`options`/`option_items` · `constraints` · `templates`

### [DGP-CPQ-001] 엽서 옵션 레이어 파일럿 (postcard L2)  {🟡}
- 내용: 디지털인쇄 CPQ 파일럿 = 엽서. option_groups(택1/택N)→options→option_items가 L1 차원행을 polymorphic ref_dim_cd로 참조한다([[../huni/cpq-options#CPQ-002]]). 도수=opt_id·자재=mat_cd+usage_cd. **단 디지털인쇄 옵션 레이어는 라이브 미적재**(L2 전면 미적재, silsa 파일럿 18행만 — [[../huni/cpq-options#CPQ-008]]).
- 앵커: `t_prd_product_option_groups`/`options`/`option_items`(엽서 — 설계만, 미적재)
- 출처: `10_configurator/postcard-option-layer.md`(엽서 파일럿) + `attribute-entity-map.md` {tier C6, FRESH(설계)}
- 연결: [[../huni/cpq-options#CPQ-001]] (uses — CPQ 7테이블) · [[../huni/cpq-options#CPQ-002]] (requires — ref_dim_cd) · [[../huni/cpq-options#CPQ-008]] (전면 미적재)
- answers_cq: CQ-PROD-05 (옵션 축·캐스케이드 구조)
- tags: #디지털인쇄 #CPQ #엽서파일럿 #미적재

### [DGP-CPQ-002] 봉투 addon = 옵션/추가상품 (엽서 C-04 교정 적용 완료)  {✅}
- 내용: family 고유 사실 — 엽서(016) 봉투 addon은 **라이브 5행**(TMPL-000005/006/009/010/011) — 사이즈별 봉투 매칭(엽서봉투·OPP비접착·카드봉투(W/B)·트레싱지 등). round-13 C-04가 지적한 "TMPL-000005 1행만(MIS-LOADED)" 결함은 **2026-06-12 신규 INSERT(TMPL-000006/009/010/011, reg_dt 16:23~16:31)로 라이브에 교정 적용 완료** — 라이브 재측정으로 5행 확증. 엑셀 C38 자유텍스트 봉투를 누락분 template 재사용(search-before-mint)으로 보강했다.
- 앵커: `t_prd_product_addons`(TMPL-000005/006/009/010/011 = 5행 적재)
- 출처: `17_correctness/digital-print/correction-manifest.md` C-04(MIS-LOADED, 교정 적용됨) + 라이브 재측정(016 addon 5행·06-12 신규 INSERT) {tier C13, FRESH}
- 연결: [[../huni/cpq-options#CPQ-006]] (uses — OTC template) · [[../huni/load-path#LP-004]] (loaded-via — search-before-mint)
- answers_cq: CQ-PROD-11 (묶음/세트 판매 단위)
- tags: #디지털인쇄 #봉투addon #C-04 #교정완료

### [DGP-CPQ-003] 봉투 세트 적재모델 = sets vs addons vs CPQ (미결)  {🔴}
- 내용: family 고유 미결 — 배경지 봉투/케이스 세트를 (a) `t_prd_product_sets`(배경지=상품, 봉투=하위, 사이즈매칭) (b) `t_prd_product_addons`(엽서와 동형) (c) CPQ 옵션(사이즈선택 캐스케이드) 중 어디로 적재할지 미결. 사이트는 "세트" 판매라 (a)/(c)가 정체 부합하나 결정 필요(Q-ID-A·BATCH-5).
- 앵커: `t_prd_product_sets`/`addons` 또는 CPQ option_items (모델 미결)
- 출처: `17_correctness/digital-print/correction-manifest.md` §4 Q-ID-A + `_curation/pack-digital-print.md` GAP-DP-1 {tier C13, FRESH}
- 연결: [[#DGP-ID-003]] · [[../huni/cpq-options#CPQ-006]] (OTC 이중등록 패턴 후보)
- tags: #디지털인쇄 #봉투세트 #적재모델 #GAP-DP-1 #BATCH-5

---

## 5. 위젯 계약 (widget contract) — 디지털인쇄
앵커: 정규화 계약(`huni-widget/03_spec/`) — DB 외 앵커임을 명시

### [DGP-WID-001] 디지털인쇄 위젯 = 정규화 계약 일반형 (전용 스펙 부재)  {⚪ 명세}
- 내용: 위젯은 후니 DB가 아닌 정규화 데이터 계약에 의존한다([[../huni/widget-contract#WID-001]]). 디지털인쇄는 family 전용 위젯 스펙이 없고(전용 스펙 = 아크릴·굿즈파우치·캘린더만), 데이터계약 일반형 + DB매핑으로 도출(위젯코어 불변). 옵션 UI는 14 componentType↔shadcn 매핑([[../huni/widget-contract#WID-003]]).
- 앵커: DB 외 — `huni-widget/03_spec/data-contract.md`(일반형)
- 출처: `huni-widget/03_spec/data-contract.md`·`component-tree.md` + [[../huni/widget-contract#WID-GAP-3]](family 스펙 존재분 = s4~s6만) {tier D, FRESH}
- 연결: [[../huni/widget-contract#WID-001]] (mapped-to — 정규화 계약) · [[../huni/widget-contract#WID-003]] (mapped-to — componentType)
- answers_cq: CQ-PROD-08 (상품-카테고리 UI 노출)
- tags: #디지털인쇄 #위젯 #정규화계약 #전용스펙부재

### [DGP-WID-002] 가격 권위 = 서버 (PRICE=0 불가)  {⚪ 명세}
- 내용: 디지털인쇄 위젯 가격도 서버 권위(후니 가격 = 원자합산형 [DGP-PR-001] → t_prc_*). RedPrinting은 PRICE=0을 절대 반환하지 않으므로 0은 우리측 결함 신호([[../huni/widget-contract#WID-005]]). Red 역산값은 분석용만, 후니 정합·이식 금지.
- 앵커: DB 외 — 서버 가격 API(후니 가격 = t_prc_*)
- 출처: `huni-widget/03_spec/price-engine.md` + 메모리 `huni-widget-red-price-never-zero` {tier D, FRESH(후보)}
- 연결: [[../huni/widget-contract#WID-005]] (priced-by — 서버 가격권위) · [[#DGP-PR-001]]
- answers_cq: CQ-PRICE-01 (가격 권위 = 서버)
- tags: #디지털인쇄 #위젯 #가격권위 #PRICE0불가

---

## 6. 적재 레시피 (load path) — 디지털인쇄
앵커: `raw/webadmin/sql/*`·`tools/load_master.py` · round-8 `13_admin-ui-spec/`

### [DGP-LP-001] 적재 oracle = sql + load_master 로직 (v03 입력 금지)  {🟡}
- 내용: 디지털인쇄 적재 소스 = webadmin `sql/01a~23` + `tools/load_master.py`(전파 로직). **[HARD] load_master.py:39 입력 v03 xlsx 인용 금지** — round-13 결함 진원 ③. 정답 = 상품마스터 L1. load_master는 로직(전파기)만 oracle.
- 앵커: `raw/webadmin/sql/*` · `tools/load_master.py`(로직만)
- 출처: `17_correctness/digital-print/loadlogic-notes.md` + `raw/webadmin/sql/` {tier C13/A, FRESH}
- 연결: [[../huni/load-path#LP-001]] (loaded-via — 적재 oracle) · [[../huni/load-path#LP-STALE]] (v03 입력 금지)
- answers_cq: CQ-PROD-01 (상품 적재 기준)
- tags: #디지털인쇄 #적재 #oracle #v03금지

### [DGP-LP-002] FK 위상 + 멱등 search-before-mint  {🟡}
- 내용: 디지털인쇄 적재도 FK 위상순서(코드값 그룹→마스터 코드행→상품→상품-자식) + 이름 기반 UPSERT + search-before-mint. 봉투 template은 기존 TMPL-000004~009 재사용(신규 채번 전 검색). separator는 코드전략 `_` 통일이나 라이브 봉투 template은 하이픈(`TMPL-000005`)으로 적재됨(C-17 미결 [DGP-ST-004]).
- 앵커: `t_cod_base_codes`(upr_cod_cd 계층) · ON CONFLICT(이름 기반)
- 출처: `17_correctness/digital-print/correction-manifest.md` C-04·C-17(template 재사용·separator) + 메모리 `dbmap-code-identifier-strategy` {tier C, FRESH}
- 연결: [[../huni/load-path#LP-003]] (loaded-via — FK 위상·코드행 선적재) · [[../huni/load-path#LP-004]] (loaded-via — 멱등 search-before-mint)
- tags: #디지털인쇄 #FK위상 #멱등 #search-before-mint

---

## 7. 현황·결함 (state) — 디지털인쇄

> round-13 K0~K6 게이트 **GO**(`_gate/digital-print-gate.md` §0, 06-11 재게이트). 결함 18건(C-01~18). **DB 미적재** — 교정은 제안까지, 실 COMMIT은 인간 승인 대기([[../huni/load-path#LP-GAP-4]]).

### [DGP-ST-001] 라이브 오적재 양면 표기 (C-05·C-09·C-14 카테고리 고아)  {🔴 교정대기}
- 내용: family 고유 라이브 오적재(round-13). 정상 포장 노드(273/274/275/283 upr=CAT_000012)가 이미 실재하는데 상품이 잉여 고아 노드에 오연결됨.

| 항목 | 라이브 현재값 | 정답 | 상태 | 출처 |
|---|---|---|---|---|
| 상품권 041/042 카테고리 | CAT_000295 상품권 (upr_cat_cd=NULL 고아) | 정상 트리 위상 연결 (정상노드 확인 필요) | 🔴 교정대기 | C-05·C-09 |
| 배경지 043 카테고리 | CAT_000296 배경지 (NULL 고아) | CAT_000273 인쇄배경지OPP (upr=012 실재) | 🔴 교정대기 | C-09 |
| 배경지 044 카테고리 | CAT_000296 배경지 (NULL 고아) | CAT_000274 투명케이스 (upr=012 실재) | 🔴 교정대기 | C-09 |
| 인쇄헤더택 045 카테고리 | CAT_000296 배경지 (NULL 고아) | CAT_000275 인쇄헤더택 (upr=012 실재) | 🔴 교정대기 | C-09 |
| 라벨택 046 카테고리 | CAT_000296 배경지 (NULL 고아) | CAT_000283 라벨/포장스티커 (upr=012 실재) | 🔴 교정대기 | C-14 |

- 교정 = 상품을 기존 정상 노드로 재연결(`t_prd_product_categories` UPDATE, search-before-mint) + 잉여 고아 296/295 논리정리. 라이브값을 사실로 단정 금지.
- 앵커: `t_prd_product_categories`(상품→카테고리 오연결)
- 출처: `17_correctness/digital-print/correction-manifest.md` C-05·C-09·C-14 + `product-identity.md` F-ID-3(독립 SELECT 재측정) {tier C13, FRESH}
- 연결: [[../huni/load-path#LP-GAP-3]] (카테고리 고아 113상품 재연결 미적재) · [[#DGP-ID-003]]
- answers_cq: CQ-PROD-01 (상품 분류·적재)
- tags: #결함 #카테고리고아 #양면표기 #round13 #교정대기

### [DGP-ST-002] MISSING 5건 (커팅·접지·봉투세트)  {🔴 교정대기}
- 내용: family 고유 MISSING — C-07(배경지043 커팅 0행→PROC_000053)·C-10(배경지044 접지 0행→PROC_000056)·C-13(라벨택046 커팅 0행→PROC_000053)·C-08·C-11(배경지 봉투/케이스 세트 addon=0·sets=0). 정체=포장 세트인데 전용 커팅·세트가 라이브 미적재(v03 시트15 행 부재).
- 앵커: `t_prd_product_processes`/`sets`/`addons`(0행)
- 출처: `17_correctness/digital-print/correction-manifest.md` §2 분포(MISSING 5) {tier C13, FRESH}
- 연결: [[#DGP-BM-003]] · [[#DGP-DM-002]] · [[../huni/load-path#LP-STALE]] (v03 진원)
- tags: #결함 #MISSING #커팅 #접지 #봉투세트 #교정대기

### [DGP-ST-003] CORRECT 5건 (의심 반증)  {✅}
- 내용: family 고유 CORRECT — C-01(엽서 size 7행, "13종" 오류 반증)·C-02(엽서 공정)·C-03(엽서 자재 USAGE.07)·C-12(라벨택 size 3행) + C-15·C-16(qty_unit/plate 값정답·경로불명). round-13이 라이브를 양방향 교정(과소·과대 평가 모두): 라이브가 "13종"으로 과대평가한 것은 7행 정답으로, "적재됨"이라 표기한 배경지는 불완전(C-07~11)으로 드러남.
- 앵커: `t_prd_product_sizes`/`processes`/`materials`(CORRECT 행)
- 출처: `17_correctness/digital-print/correction-manifest.md` §2 분포(CORRECT 5)·§5 방법론 입증 {tier C13, FRESH}
- 연결: [[#DGP-DM-001]] · [[#DGP-BM-001]]
- tags: #현황 #CORRECT #의심반증

### [DGP-ST-004] AMBIGUOUS 3건 (박부모·separator·배경지 자재)  {🔴}
- 내용: family 고유 AMBIGUOUS — C-06(상품권042 박부모 PROC_000033 미연결 vs 박색 8자식 [DGP-BM-004])·C-17(엽서 addon separator 하이픈 vs `_` 통일)·C-18(배경지043 자재 스노우250 단일 vs 몽블랑240 일부 누락 재확인).
- 앵커: `t_proc_processes`/`addons`/`materials`(AMBIGUOUS 행)
- 출처: `17_correctness/digital-print/correction-manifest.md` §2 분포(AMBIGUOUS 3)·§4 Q-DP-B/C {tier C13, FRESH}
- 연결: [[#DGP-BM-004]] · [[../huni/load-path#LP-004]] (separator 통일)
- tags: #현황 #AMBIGUOUS #박부모 #separator

### [DGP-ST-005] 미결 컨펌·GAP (BATCH·Q-ID)  {🔴}
- 내용: family 고유 미결 — Q-ID-A 봉투/케이스 세트 적재모델(GAP-DP-1·BATCH-5, [DGP-CPQ-003])·Q-ID-B 배경지/상품권/라벨택 카테고리 재연결(GAP-DP-2·BATCH-1, [DGP-ST-001])·Q-DP-C 박색 8자식 옵션풀 vs 부모 박(GAP-DP-3·C-06)·Q-DP-B separator 통일(GAP-DP-4·C-17). 전부 인간 승인 대기.
- 앵커: (결정 미결 — 컨펌)
- 출처: `_curation/pack-digital-print.md` GAP-DP-1~4 + `17_correctness/digital-print/correction-manifest.md` §4 {tier C13, FRESH}
- 연결: [[../huni/load-path#LP-GAP-3]] · [[../huni/processes#PRC-GAP-3]] · [[../huni/cpq-options#CPQ-GAP-1]]
- tags: #GAP #컨펌 #BATCH #Q-ID #미결

---

## Sources
- 큐레이션 팩: `_curation/pack-digital-print.md`(C-01~18 결함·GAP-DP-1~4·stale 함정).
- 정체(C13, FRESH): `17_correctness/digital-print/product-identity.md`(distinct 36·F-ID-0~3·독립 SELECT) — 보조 `06_extract/digital-print-l1.csv`·사이트 `goods_view_102.html`·`product-master.md`.
- 차원/BOM(C11/C13): `15_domain-spec/digital-print/column-dictionary.md`·`product-bom.md`; `17_correctness/digital-print/correction-manifest.md`(C-01~18).
- 가격(C2, 공식사슬 FRESH): `02_mapping/digital-print-engine/`(PRF_DGP_A~F·COMP_PAPER·BLOCKED csv); 메모리 `dbmap-digitalprint-atomic-formula-unbuilt`.
- CPQ(C6): `10_configurator/postcard-option-layer.md`·`attribute-entity-map.md`.
- 위젯(D): `huni-widget/03_spec/data-contract.md`·`component-tree.md`·`price-engine.md`.
- 적재(C13/A): `17_correctness/digital-print/loadlogic-notes.md` + `raw/webadmin/sql/`·`tools/load_master.py`(로직만).
- 게이트: `17_correctness/_gate/digital-print-gate.md`(K0~K6 GO).
- 축 페이지(횡단 사실 권위): [[../huni/materials]]·[[../huni/processes]]·[[../huni/price-engine]]·[[../huni/cpq-options]]·[[../huni/widget-contract]]·[[../huni/load-path]].
- **STALE(인용 금지):** `price-engine-ddl.md` 전체; v03 입력 xlsx(`load_master.py:39`); constraint_json/dep_proc_cd 적재 타깃; `16_*/digital-print/mapping-final.md` "180g→constraint_json"(I-5)·"엽서 13종"(C-01 반증); `extraction-plan.md` L56 dep_proc_cd oracle(I-6); round-2 포스터 면적-좌표 회귀 모델.
