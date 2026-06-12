# product-accessory(상품악세사리) 레시피  {전체상태: 🟡}

> 조립 뷰. 횡단 사실은 축 페이지(`huni/<axis>.md`) 원자 항목을 `[[링크]] + 관계동사`로 참조만 하고 본문 복붙하지 않는다(README §3·§9). 레시피 고유 사실(15 부자재 목록·이중등록 prd_cd·교정대기 행)만 본문 원자 블록.
> 큐레이션 팩: `_curation/pack-product-accessory.md`(1차 권위). **round-12 mapping-research 없음 — 매핑 권위 = round-11 + round-13.** round-13 게이트 GO(K0~K6 PASS·F-PA-GATE-1/2 보정 후 재게이트 PASS).
> **정체 특이[HARD]:** 상품악세사리 15상품 = 인쇄물이 아니라 **카테고리 012 포장재**(완제 부자재 매입/외주 우드). 인쇄 BOM(자재/공정/도수/판형) **N/A**. "상품악세사리"는 시트 라벨일 뿐 별도 범주가 아니다.
> **STALE/v03 인용 0**: 가격엔진 ddl·v03 입력 xlsx·constraint_json·dep_proc_cd 인용 금지(축 STALE 블록 참조). 라이브 오적재는 7절 양면 표기.

## CQ 헤더 (이 페이지가 답하는 질문)
- 상품악세사리는 무엇인가(15 부자재=포장재 012·봉투/케이스 11+상품액세서리 4) / 어떤 차원·옵션(치수·묶음수·색상=3축 복합·이중등록 OTC TEMPLATE)이 있는가
- 가격은 어떻게 계산되는가(variant별 고정가·라이브 0행) / DB에 어떻게 등록하는가(정상 카테고리 노드 재연결·봉투세트 sets+CPQ)
- 현재 라이브 적재 상태·교정 대기(카테고리 고아 오연결·색상=자재 오염·가격 전무·봉투세트 미적재)는 무엇인가
- 미결: 카테고리 재연결(Q-PA-A·BATCH-1)·색상 variant 귀속(Q-PA-B)·봉투세트 모델(Q-ID-A)·사이즈 3축 분해 깊이(Q-PA-C)

---

## 0. 정체 (identity) — 상품악세사리  앵커: t_prd_products · t_cat_categories

### [PA-ID-001] 상품악세사리 = 15 부자재·전부 카테고리 012 포장재  {✅}
- 내용: 상품악세사리 시트 = **67 데이터행 · 15 distinct 상품**(라이브 `PRD_000001`~`PRD_000015`, 봉투/케이스 11 + 상품액세서리 4). **전부 카테고리 012 포장재**(완제 부자재 — 봉투·볼체인·우드거치대·리필잉크 등 매입/외주, 인쇄 안 함). MES prefix가 전부 `012`(포장 라인)이고 `product-master:172~177`이 012 포장 트리에 15상품을 전수 매핑 → "상품악세사리"는 시트 라벨일 뿐 별도 범주가 아니다. 라이브 전수 `prd_typ_cd=PRD_TYPE.03(기성상품)`. **인쇄 5속성축(자재 본체/공정/도수/판형)은 N/A**(완제 부자재라 인쇄 안 함).
- 앵커: `t_prd_products`(PRD_000001~015) · `t_cat_categories`(CAT_000012 포장)
- 출처: `17_correctness/product-accessory/product-identity.md` §0·§3 (라이브 read-only psql·product-master:172~177) {tier C13, FRESH}
- 연결: [[../base/finishing#BFN-001]] (uses — 후가공/포장 보편) · [[load-path#LP-GAP-3]] (카테고리 고아 재연결 미적재)
- answers_cq: CQ-PROD-01 (상품 분류) · CQ-PROD-03 (완제품 귀속)
- tags: #상품악세사리 #정체 #15부자재 #포장재012

### [PA-ID-002] 15 부자재 prd_cd 목록 (구분별)  {✅}
- 내용: **봉투/케이스**(7상품): OPP접착봉투 001·OPP비접착봉투 002·트래싱지카드봉투 003·카드봉투 004·캘린더봉투 005·투명케이스 009·행택끈 010. **봉투/케이스(부속)**: 볼체인 006·와이어링 007·천정고리 008. **포장부자재**: 자석고정용고무판 011. **상품액세서리**(우드/리필): 우드거치대 012·우드봉 013·우드행거 014·만년스탬프리필잉크 015. 라이브 비활성: 천정고리 008 `use_yn=N`(판매중지 의심·교정대기 §7.1 PA-ST-007). MES NULL: 008·010·013·015(load_master 무조건 None 적재·라이브 7/15만 채움=후속 손작업, §7.1 PA-ST-007).
- 앵커: `t_prd_products`(001~015) · `t_prd_product_categories`
- 출처: `17_correctness/product-accessory/product-identity.md` §0 표·§1 정체표 {tier C13, FRESH}
- 연결: [[#PA-ID-001]] · [[#PA-CPQ-001]] (uses — 봉투=다른 상품 addon base)
- answers_cq: CQ-PROD-01 (상품 분류)
- tags: #상품악세사리 #prd_cd목록 #구분

### [PA-ID-003] 부자재 이중등록 = 의도 (OTC TEMPLATE·결함 아님)  {🟡}
- 내용: 카드봉투류는 라이브에 **두 번 등록**됐다 — ① 기성상품 `PRD_000004` 카드봉투(`PRD_TYPE.03`) ② 추가상품 `PRD_000281` 카드봉투(화이트)·`PRD_000282` 카드봉투(블랙)·`PRD_000283` 트레싱지봉투(`PRD_TYPE.05`, 각각 `t_prd_templates` base_prd_cd로도 등록 — addon SKU 이중역할). 이는 [[cpq-options#CPQ-006]] **OTC TEMPLATE 이중등록=의도**의 라이브 실증 — `sql/09_delete_dup_products.sql`이 281/282/283을 **삭제 대상에서 제외**(삭제 목록=099/113~117/167/182 8건)했다 → 의도적 보존. **이중등록을 결함으로 오판 금지**(round-13 반증). 단 004(기성·색상 siz 합성) ↔ 281/282(추가·별 PRD) 역할 분리는 미해소(컨펌 [[#PA-ST-004]]·Q-PA-D).
- 앵커: `t_prd_products`(004 .03 / 281·282·283 .05) · `t_prd_templates`(TMPL-000007/008/009)
- 출처: `17_correctness/product-accessory/correction-manifest.md` PA-12(CORRECT 의도) + `_gate/product-accessory-gate.md` K2(09_delete_dup SQL 직접 Read 입증) {tier C13/A, FRESH}
- 연결: [[cpq-options#CPQ-006]] (uses — OTC TEMPLATE 이중등록=의도) · [[#PA-CPQ-001]] · [[#PA-ST-004]]
- answers_cq: CQ-PROD-11 (묶음/세트 판매 단위) · CQ-PROD-03 (아키타입 완제품 귀속)
- tags: #상품악세사리 #이중등록의도 #OTC #PRD_000281

---

## 1. 차원 (dimensions) — 상품악세사리  앵커: t_prd_product_sizes/bundle_qtys/sets · t_siz_sizes

### [PA-DIM-001] 사이즈(필수) 셀 = 3축 복합 (치수·묶음수·색상)  {🟡}
- 내용: L1 `사이즈(필수)`(C5)가 **치수 + 묶음수 + 색상을 한 셀에 복합 인코딩**(`70x200mm (50장)`·`오렌지 (3개1팩)`·`청보라 (5cc)`·`PP투명케이스 75x75x15mm (10개)`·`270mm + 면끈`). 정답 = **3축 분해**: 치수→`t_siz_sizes`(cut_*)·묶음수→`t_prd_product_bundle_qtys`(QTY_UNIT 장/개/팩/세트)·색상→variant(옵션, [[#PA-CPQ-002]]). **단일 size 축으로 평면화 금지**(round-11 핵심 함정 PA-2). 라이브는 치수만 cut_*로 분해되고 묶음수·색상이 `siz_nm` 텍스트에 잔존(§7.1 PA-ST-005 교정대기).
- 앵커: `t_siz_sizes`(cut_*) · `t_prd_product_bundle_qtys`(bdl_unit_typ_cd=QTY_UNIT.*) · `t_prd_product_sizes`
- 출처: `15_domain-spec/product-accessory/column-dictionary.md` §2(C5 3축 복합)·§5 {tier C11, FRESH}
- 연결: [[../base/sizes#BSZ-003]] (uses — 작업/재단 치수 보편) · [[#PA-DIM-002]] (묶음수) · [[#PA-CPQ-002]] (색상=옵션) · §7.1 PA-ST-005 (siz_nm 잔존 교정대기)
- answers_cq: CQ-PROD-06 (variant 색/사이즈 → 차원 분해)
- tags: #상품악세사리 #사이즈 #3축복합 #PA-2

### [PA-DIM-002] 묶음수 = bundle_qty (부분 GAP·일부 부자재 0행)  {🟡}
- 내용: 묶음수(`(50장)`·`(3개1팩)`·`(2개1세트)`·`(20개입)`·`(100개)`)는 `t_prd_product_bundle_qtys`(QTY_UNIT 코드 — 장/매/팩/세트/개)로 분리가 정답. 라이브 적재 = 봉투/케이스 일부만(001=50/QTY_UNIT.01·002=50/QTY_UNIT.02·003·004·005·009·011·283 등), **볼체인 006·와이어링 007·천정고리 008·행택끈 010·우드 012~014·리필잉크 015 = bundle 0행**(정규화 시트12 미분해). 단위도 혼선(001=EA·002=매인데 L1은 둘 다 "장", §7.1 PA-ST-009·Q-PA-E). 수량 축(C6~C8)은 `min/max/qty_incr`=1/100/1(부자재 100 상한·묶음 단위 주문).
- 앵커: `t_prd_product_bundle_qtys`(bdl_unit_typ_cd=QTY_UNIT.*) · `t_prd_products.min_qty/max_qty/qty_incr`
- 출처: `17_correctness/product-accessory/loadlogic-notes.md` §1-3(라이브 실측 묶음수)·`correction-manifest.md` PA-05 {tier C13, FRESH}
- 연결: [[#PA-DIM-001]] (3축 복합 분해) · §7.1 PA-ST-008 (묶음수 누락 교정대기) · [[load-path#LP-004]] (멱등 적재)
- answers_cq: CQ-PROD-11 (묶음/세트 판매 단위)
- tags: #상품악세사리 #묶음수 #bundle_qty #부분GAP

---

## 2. 자재·공정 BOM — 상품악세사리  앵커: t_prd_product_materials/processes · t_mat_materials

### [PA-BOM-001] 인쇄 BOM N/A · 완제 부자재 (우드거치대=자재)  {✅}
- 내용: 상품악세사리는 **완제 부자재**라 인쇄 5속성축(자재 본체/공정/도수/판형)이 **N/A**(인쇄 안 함). 정당한 자재행은 외주 우드가공 부속뿐 — **우드거치대=자재**(실무진 확정 [[processes#PRC-005]]·메모리 round-11, `t_mat_materials` MAT_000222 "120mm (4mm홈) 내추럴" 1행). 공정/옵션으로 오판 금지. 우드봉 013·우드행거 014는 길이 variant가 라이브 미분해(siz·material·option 전부 0행, §7.1 PA-ST-010·Q-PA-G). 이 BOM 슬롯 구조는 [[materials#MAT-001]] 마스터·`usage_cd`를 따른다.
- 앵커: `t_mat_materials`(MAT_000222 우드거치대) · `t_prd_product_materials`(usage_cd=USAGE.07 공통)
- 출처: `17_correctness/product-accessory/product-identity.md` §3(인쇄축 N/A) + `correction-manifest.md` PA-13(우드 길이 variant) {tier C13, FRESH}
- 연결: [[materials#MAT-001]] (uses — 자재 마스터·usage_cd 구조) · [[materials#MAT-002]] (uses — parent+usage_cd·우드거치대=부속 자재) · [[processes#PRC-005]] (uses — 우드거치대=자재 실무진 확정)
- answers_cq: CQ-PROD-05 (자재 축) · CQ-PROD-03 (완제품 귀속)
- tags: #상품악세사리 #BOM #완제부자재 #우드거치대자재

### [PA-BOM-002] 색상 부자재 = 자재 오적재 (MAT_TYPE.10 오염)  {🔴 교정대기}
- 내용: 라이브 현재값 **색상 부자재 4종이 `t_mat_materials` MAT_TYPE.10으로 적재(색상=자재 오염)** → 정답 색상=옵션([[#PA-CPQ-002]]). 볼체인 006(8색)·리필잉크 015(7색)·와이어링 007(실버/화이트/블랙 3색·MAT_000210/212/213)·행택끈 010(사각검정/백색/마사 3종·MAT_000217/219/220), 전부 MAT_TYPE.10·USAGE.07. 횡단 자재 오염 패턴([[materials#MAT-005]] .07~.10)의 상품악세사리 사례 — 진원 = `05_자재정보` 시트가 색상을 자재행으로 정의·load_master가 변환 없이 그대로 적재(L-PA-D). 메모리 정규화 권위 = "색상≠자재·본체색=재질행 합성"([[materials#MAT-004]]). **단 묶음/용량("3개1팩"·"100개"·"5cc")은 색상 자재명에서 분리**(축②/시즈). 귀속 미결(Q-PA-B·AMBIGUOUS).
- 앵커: `t_mat_materials`(mat_typ_cd .10 색상 오염행) · `t_prd_product_materials`
- 출처: `17_correctness/product-accessory/correction-manifest.md` PA-02·PA-08 + `_gate/product-accessory-gate.md` §11①②(독립 SELECT mat_cd까지 일치) {tier C13/A, FRESH}
- 연결: [[materials#MAT-005]] (오염 패턴 .07~.10) · [[materials#MAT-004]] (정답 — 색상≠자재·과분할 금지) · [[#PA-CPQ-002]] (정답 색상=옵션) · [[#PA-ST-002]] (교정대기)
- answers_cq: CQ-PROD-06 (variant 색 → 차원 분해)
- tags: #결함 #색상자재오염 #MAT_TYPE10 #교정대기

---

## 3. 가격 사슬 (price chain) — 상품악세사리  앵커: t_prc_* 4단 + t_dsc_*

### [PA-PRC-001] 가격 = variant별 고정가 (가격포함 시트·라이브 0행)  {🔴 교정대기}
- 내용: 상품악세사리는 **(가격포함) 시트**라 가격이 inline 고정가(variant=치수×묶음×색상별 단가, L1에 1100/3000/16000원 등 명시). 처리 모델 = [[price-engine#PE-007]] **고정가형**(포토북/캘린더/문구 패턴 — 면적/구간 아님). 봉투=치수×묶음 격자·색상부자재=색상별. **라이브 현재값: 부자재 가격 공식·component 0행**(`t_prd_product_price_formulas` 0·`t_prc_component_prices` 0) → 정답: L1 variant 단가 적재. 진원 = round-2 가격 트랙이 부자재를 커버 안 함(load_master 미관여 :469-481, L-PA-F). 6상품군 가격 미적재 GAP([[price-engine#PE-GAP-3]])의 부자재 사례. **OTC 가격은 SKU 직접단가 `t_prd_template_prices` 경로 가능**([[price-engine#PE-004]], 단 라이브 0행·`price-engine-ddl.md` template_prices 누락 STALE).
- 앵커: `t_prd_product_prices`(고정가) / `t_prd_template_prices`(SKU 직접단가·0행) — 라이브 가격사슬 부재
- 출처: `15_domain-spec/product-accessory/column-dictionary.md` §4(C9 가격포함→고정가) + `17_correctness/product-accessory/loadlogic-notes.md` §1-7(라이브 0행 실측) {tier C11/C13, FRESH}
- 연결: [[price-engine#PE-007]] (priced-by — 고정가형) · [[price-engine#PE-004]] (uses — template_prices SKU 직접단가 경로) · [[price-engine#PE-GAP-3]] (가격 미적재 GAP) · [[#PA-ST-003]] (교정대기)
- answers_cq: CQ-PRICE-01 (단가표 vs 공식) · CQ-PRICE-08 (견적 합산)
- tags: #상품악세사리 #가격 #고정가형 #라이브0행 #교정대기

---

## 4. CPQ 옵션 레이어 — 상품악세사리  앵커: t_prd_product_option_groups/options/option_items · constraints · templates

### [PA-CPQ-001] OTC TEMPLATE = 봉투가 다른 상품 addon base (이중역할)  {🟡}
- 내용: 봉투/케이스 상품(001~009)은 독립 판매 + **다른 상품(엽서·캘린더·배경지)의 addon으로 참조되는 별매 SKU** 이중역할([[cpq-options#CPQ-006]] OTC TEMPLATE). 봉투 template `TMPL-000004~011`은 봉투가 addon으로 참조될 때 migrate_phase7가 자동 생성(`'TMPL-'||addon_prd_cd`). 라이브 활성(`del_yn=N`) = TMPL-000005/006/009/010/011(004/007/008·001~003 테스트는 `del_yn=Y`). 라이브 실측 addon 연결 = **PRD_000016(프리미엄엽서)→TMPL-000005/006/009/010/011 5행**(전부 봉투 base — 005=OPP접착·006=OPP비접착·009=트레싱지·010=카드화이트·011=카드블랙·전부 `del_yn=N`). 단 배경지(043/044)는 addon 0행 = 봉투 세트 미적재([[#PA-ST-001]]·Q-ID-A). 가격은 SKU 직접단가 [[price-engine#PE-004]] 경로 가능.
- 앵커: `t_prd_templates`(TMPL-000005/006/009/010/011 활성) · `t_prd_product_addons`(prd_cd+tmpl_cd — addon 대상은 tmpl_cd가 가리키는 template의 base_prd_cd)
- 출처: `17_correctness/product-accessory/loadlogic-notes.md` §1-6(template 자동생성·addon 1행) + `10_configurator/all-sheets-otc-extract.md`·`option-vs-template-guide.md`(OTC) {tier C13/C, FRESH}
- 연결: [[cpq-options#CPQ-006]] (uses — OTC TEMPLATE 이중등록) · [[cpq-options#CPQ-001]] (uses — templates 2계층) · [[#PA-ID-003]] · [[#PA-ST-001]] (봉투세트 미적재)
- answers_cq: CQ-PROD-11 (묶음/세트 판매 단위) · CQ-PROD-03 (완제품 귀속)
- tags: #상품악세사리 #OTC #봉투template #이중역할

### [PA-CPQ-002] 색상 variant → option_items (정답·ref_dim_cd·전면 미적재)  {🟡}
- 내용: 색상 variant(볼체인 8색·리필잉크 7색·와이어링 3색·행택끈 3종)의 정답 귀속 = **`t_prd_product_option_groups`(택1·색상)→options→option_items**([[cpq-options#CPQ-002]] polymorphic `ref_dim_cd`). 현 라이브는 색상을 자재(MAT_TYPE.10)로 오적재([[#PA-BOM-002]])했으므로 교정 = 색상 자재 논리삭제 + option_items 신설(테이블 실재·ddl 불요·트리거 `fn_chk_opt_item_ref` [[cpq-options#CPQ-003]] 무결성). **단 상품악세사리 CPQ 옵션 레이어 전면 미적재**([[#PA-ST-002]]·전 family 18행은 silsa 파일럿뿐 [[cpq-options#CPQ-008]]). 라이브 옵션그룹 2(PRD_000001 "테스트"·002 "제본방식")는 테스트 잔재(부자재 색상 옵션 아님·논리삭제 후보·F-PA-GATE-2). 귀속 자체가 미결(Q-PA-B·AMBIGUOUS — 옵션 vs 자재 vs 별 SKU).
- 앵커: `t_prd_product_option_items.ref_dim_cd` · `t_prd_product_option_groups`
- 출처: `17_correctness/product-accessory/correction-manifest.md` PA-02(색상→option_items 권고)·Q-PA-B + `10_configurator/attribute-entity-map.md`(축 경유) {tier C13/C, FRESH(매핑)·PARTIAL-STALE(I-5·I-9)}
- 연결: [[cpq-options#CPQ-002]] (uses — polymorphic ref_dim_cd) · [[cpq-options#CPQ-003]] (requires — 무결성 트리거·차원행 선적재) · [[cpq-options#CPQ-004]] (uses — 속성→4엔티티) · [[#PA-BOM-002]] (라이브 오적재 자재) · [[#PA-ST-002]]
- answers_cq: CQ-PROD-05 (옵션 축·캐스케이드)
- tags: #상품악세사리 #CPQ #색상옵션 #ref_dim_cd #미적재

### [PA-CPQ-003] 봉투세트 = sets + CPQ 사이즈매칭 캐스케이드 (Q-ID-A 권고)  {🟡}
- 내용: 배경지(043/044)가 봉투/케이스를 **세트로 동봉**(사이트 "배경지(76x100)+투명봉투")하는 모델 = round-13 §5 권고 **(a) `t_prd_product_sets`(prd_cd=배경지·sub_prd_cd=봉투 상품·sub_prd_qty=1) + (c) CPQ 사이즈매칭 캐스케이드**([[cpq-options#CPQ-007]] constraints.logic — 배경지 siz↔봉투 siz 연동). 봉투=하위상품(sub_prd_cd, 독립 PRD 재사용·search-before-mint). 엽서식 단순 addon(tmpl_cd)은 사이즈 매칭·세트 동봉 표현 불가라 배경지엔 부적합. 봉투 세트는 sets 0행·미적재([[#PA-ST-001]]). **단 sets vs addon은 인간 결정(Q-ID-A·🔴)** — 본 블록은 라이브 실측·정체 근거 권고이며 단정 아님.
- 앵커: `t_prd_product_sets`(28행 정상 작동) · `t_prd_product_constraints.logic`(사이즈매칭)
- 출처: `17_correctness/product-accessory/correction-manifest.md` §5(Q-ID-A 권고 라이브 실측 기반) + `_gate/product-accessory-gate.md` K6(봉투세트 정합) {tier C13, FRESH(권고)}
- 연결: [[cpq-options#CPQ-007]] (requires — 사이즈매칭 캐스케이드 constraints.logic) · [[cpq-options#CPQ-006]] (uses — OTC 봉투 template) · [[#PA-CPQ-001]] · [[#PA-ST-001]] (봉투세트 미적재)
- answers_cq: CQ-PROD-11 (묶음/세트 판매 단위) · CQ-PROD-05 (캐스케이드)
- tags: #상품악세사리 #봉투세트 #sets #사이즈매칭 #Q-ID-A

---

## 5. 위젯 계약 (widget contract) — 상품악세사리  앵커: 정규화 계약(huni-widget 03_spec) — DB 외 앵커

### [PA-WID-001] 위젯은 정규화 계약 의존 (DB 독립·family 전용 스펙 부재)  {⚪}
- 내용: 상품악세사리 위젯은 후니 DB 스키마가 아닌 **정규화 데이터 계약**(상품·옵션·가격 안정 shape)에 의존([[widget-contract#WID-001]]). 부자재는 주로 다른 상품의 addon/세트로 노출(봉투세트·볼체인 색상선택)되므로 위젯 표현은 옵션축(색상·묶음·치수)→14 componentType→shadcn([[widget-contract#WID-003]]). family 전용 위젯 스펙은 부재(7-stage 확대 중 아크릴·굿즈파우치·캘린더만 존재, [[widget-contract#WID-GAP-3]]) → 데이터계약 일반형 + DB매핑으로 도출(위젯 코어 불변). DB 확정 시 후니 어댑터만 교체([[widget-contract#WID-002]]).
- 앵커: DB 외 — `huni-widget/03_spec/data-contract.md`(어댑터 경계에서 t_*로)
- 출처: `huni-widget/03_spec/data-contract.md`(축 WID-001 경유) {tier D, FRESH}
- 연결: [[widget-contract#WID-001]] (mapped-to — 정규화 계약) · [[widget-contract#WID-002]] (mapped-to — 어댑터) · [[widget-contract#WID-003]] (mapped-to — componentType) · [[widget-contract#WID-GAP-3]] (family 전용 스펙 부재)
- answers_cq: CQ-PROD-05 (옵션 축 shape) · CQ-PROD-08 (UI 노출)
- tags: #상품악세사리 #위젯 #정규화계약 #DB독립

### [PA-WID-002] 가격 권위 = 서버 (PRICE=0 불가 신호)  {⚪}
- 내용: 상품악세사리 위젯 가격은 **서버 권위 + 클라 캐싱**([[widget-contract#WID-005]]). 후니 가격은 가격엔진 축([[price-engine#PE-001]]) 권위(고정가형 [[#PA-PRC-001]]). RedPrinting PRICE=0은 절대 불가 — 0은 우리측 요청/세션 결함 신호(Red 역산값 후니 이식 금지). **단 부자재 가격사슬 라이브 0행** → 위젯 가격 노출 전 가격 적재 선행 필요([[#PA-ST-003]]).
- 앵커: DB 외 — 서버 가격 API(후니 가격=t_prc_*)
- 출처: `huni-widget/03_spec/price-engine.md`(축 WID-005 경유) {tier D, FRESH(후보)}
- 연결: [[widget-contract#WID-005]] (priced-by — 서버 가격권위) · [[price-engine#PE-001]] (priced-by — 후니 가격) · [[widget-contract#WID-STALE]]
- answers_cq: CQ-PRICE-01 (가격 권위=서버)
- tags: #상품악세사리 #위젯 #가격권위 #PRICE0불가

---

## 6. 적재 레시피 (load path) — 상품악세사리  앵커: raw/webadmin sql/tools · round-8 admin-ui-spec

### [PA-LP-001] 적재 oracle = load_master(순수 전파기) · 진원=정규화 시트  {🟡}
- 내용: 상품악세사리 라이브 값 = `tools/load_master.py`가 v03 정규화 시트(04_사이즈·05_자재·12_묶음수·14_상품별자재 등)를 전 상품 공통 처리한 직접 결과. **load_master는 변환 없는 순수 전파기** — 3축 미분해(L-PA-C)·색상 자재 오염(L-PA-D)·카테고리 고아(L-PA-B)의 라이브 결함은 **정규화 시트 작성 단계의 산물**(스크립트 버그 아님, 코드 부재로 입증). 반대로 MES·qty_unit은 load_master가 None 적재(:261,269)인데 라이브 일부 채워짐 → **webadmin 밖 후속 손작업**(적재 경로 불명, L-PA-A). 가격은 round-2 미커버(L-PA-F). **[HARD] v03 입력 xlsx 인용 금지**([[load-path#LP-STALE]]) — 정답 기준 = 상품마스터 L1.
- 앵커: `raw/webadmin/tools/load_master.py`(로직만 oracle) · `sql/05·09`·`migrate_phase7.py`
- 출처: `17_correctness/product-accessory/loadlogic-notes.md` §0·§1·§2 (file:line) {tier C13/A, FRESH}
- 연결: [[load-path#LP-001]] (loaded-via — 적재 oracle) · [[load-path#LP-STALE]] (v03 금지) · §7.1 PA-ST-007 (MES 경로불명)
- answers_cq: CQ-PROD-01 (적재 기준)
- tags: #상품악세사리 #적재 #load_master #순수전파기

### [PA-LP-002] FK 위상순서·멱등 UPSERT·search-before-mint (ddl 불요)  {🟡}
- 내용: 상품악세사리 적재 = [[load-path#LP-003]] **FK 위상순서**(코드행 → 정상 카테고리/자재 마스터 → 상품 → 상품-자식). 멱등 = 이름 기반 UPSERT([[load-path#LP-004]]). 교정 재연결 대상(정상 카테고리 노드 CAT_000276/285/287·봉투 template TMPL-000005/006/009·볼체인 별 PRD) **전부 라이브 실재** → 신규 mint 0(search-before-mint 충족·게이트 K5 입증). **ddl-proposer 라우팅 0**(option_items·sets·addons·bundle 테이블 전부 실재 — 스키마 부족 없음). 입력경로 = admin product-viewer pvEdit([[load-path#LP-006]]) — "컬럼 존재 ≠ 백필 완료".
- 앵커: `t_cat_categories`(CAT_000276/285/287 정상노드) · `13_admin-ui-spec/`
- 출처: `_gate/product-accessory-gate.md` K5(search-before-mint·ddl 0 실재 입증) + `correction-manifest.md` §3(라우팅 ddl 0) {tier C13, FRESH}
- 연결: [[load-path#LP-003]] (loaded-via — FK 위상·코드행 선적재) · [[load-path#LP-004]] (loaded-via — 멱등 UPSERT·search-before-mint) · [[load-path#LP-006]] (loaded-via — admin 입력경로) · [[cpq-options#CPQ-003]] (requires — 색상 옵션 차원행 선적재)
- answers_cq: CQ-FILE-05 (적재 입력값)
- tags: #상품악세사리 #FK위상 #멱등 #search-before-mint #ddl불요

---

## 7. 현황·결함 (state) — 상품악세사리

> round-13 게이트 GO(K0~K6 PASS·F-PA-GATE-1/2 보정 후 K4 재게이트 PASS). 라이브 = 교정대상(피고). 아래 양면표기는 `17_correctness/product-accessory/correction-manifest.md`·`_gate/product-accessory-gate.md` 대조분만(미대조 라이브값 인용 금지 — G-1/F-PB-1 교훈). 분류 분포: CORRECT 2·MIS-LOADED 6·MISSING 3·EXTRA 0·AMBIGUOUS 3(합 14).

### 7.1 라이브 오적재 양면표기 (라이브 현재값 ↔ 정답)

| ID | 항목 | 라이브 현재값 | 정답 | 상태 | 출처(correction-manifest) |
|---|---|---|---|---|---|
| PA-ST-001 | 카테고리 위상(15상품) | 전부 `CAT_000293` 상품악세사리(upr=NULL·lvl3 잉여 고아) | 봉투/케이스→`CAT_000276`·자석→`CAT_000285`·부속→`CAT_000287`(전부 upr=012 실재) | 🔴 교정대기(High·Q-PA-A) | PA-01 |
| PA-ST-002 | 색상 variant(006/007/010/015) | `MAT_TYPE.10` 자재 오염(006=8·007=3·010=3·015=7행) | `option_items`(택1·색상) | 🔴 교정대기·AMBIGUOUS(Q-PA-B) | PA-02·PA-08 |
| PA-ST-003 | 가격(15 전부) | 공식 0·component 0행 | L1 variant별 고정가(1100/3000/16000원) | 🔴 교정대기(MISSING·round-2 양식) | PA-03 |
| PA-ST-004 | 봉투세트 addon/sets(043/044↔봉투) | 엽서 PRD_000016=봉투 template 5행(005/006/009/010/011)·**배경지 043/044 addon 0·sets 0** | sets + CPQ 사이즈매칭(§5 권고) | 🔴 교정대기(MISSING·Q-ID-A) | PA-04 |
| PA-ST-005 | 사이즈 siz_nm(봉투/케이스) | siz_nm에 "(50장)" 묶음수·색상 잔존 | 치수만(묶음/색상 분리) | 🔴 교정대기(MIS-LOADED·Q-PA-C) | PA-06·PA-10 |
| PA-ST-006 | 카드봉투 004 색상 + 이중등록 역할 | 색상 W/B가 siz_nm 합성(2 siz)·281/282 별 PRD 병존 | 색상 처리 일원화·004↔281/282 역할 분리 | 🔴 교정대기·AMBIGUOUS(Q-PA-D) | PA-07 |
| PA-ST-007 | 천정고리 008 use_yn·MES | use_yn=N·MES NULL | 판매 활성 여부 미상(L1 가격 6500 존재) | 🔴 교정대기·AMBIGUOUS(Q-PA-F) | PA-11 |
| PA-ST-008 | 묶음수(006/007/008/010/012~015) | `bundle_qtys` 0행(시트12 미분해) | 볼체인 3·팩·천정고리 2·세트·행택끈 100·개 등 | 🔴 교정대기(MISSING) | PA-05 |
| PA-ST-009 | 묶음 단위(001 vs 002) | 001=QTY_UNIT.01(EA)·002=QTY_UNIT.02(매) 혼선(L1 둘 다 "장") | 후니 통일 단위 | 🔴 교정대기(Low·Q-PA-E) | PA-09 |
| PA-ST-010 | 우드 길이(013/014) | 우드봉/행거 siz·material·option 전부 0행 | 길이 3종(270/360/480mm)=siz 또는 옵션 | 🔴 교정대기·AMBIGUOUS(Q-PA-G) | PA-13 |

> **정합(CORRECT·유지):** PA-12 이중등록 의도(281/282/283 삭제 제외·09_delete_dup 입증)·PA-14 MES/qty_unit 값정답(경로불명·후속 손작업). (이 2건은 양면표기 불요 — 라이브 값=정답, 단 PA-14 적재 경로는 webadmin 밖.)

### 7.2 횡단 결함 참조 (축 페이지 권위)

### [PA-ST-001] 카테고리 고아 오연결 (15상품·BATCH-1)  {🔴 교정대기}
- 내용: 라이브 현재값 15 부자재 전부 잉여 고아 노드 `CAT_000293`(upr=NULL·lvl3) → 정답 정상 노드 재연결(봉투/케이스→276·자석→285·부속→287, 전부 upr=012 실재). 디지털인쇄 배경지(296)·상품권(295)과 **완전 동형**(`구분` 라벨 파생 잉여 고아). 진원 = load_categories(:171,175 빈 상위코드 영구 NULL)·load_rel_categories(:288 고아 연결). PRD_000283(트레싱지봉투·추가)이 정상 276에 연결된 것이 교정 패턴(search-before-mint) 라이브 반례 입증. 횡단 카테고리 고아 113상품([[load-path#LP-GAP-3]])의 부자재 사례·BATCH-1 일괄 결정.
- 앵커: `t_prd_product_categories`(CAT_000293 → 276/285/287)
- 출처: `17_correctness/product-accessory/correction-manifest.md` PA-01 + `_gate/product-accessory-gate.md` §11④(분류 14·라우팅 불변) {tier C13, FRESH}
- 연결: [[load-path#LP-GAP-3]] (카테고리 고아 BATCH-1) · [[load-path#LP-003]] (FK 위상·정상노드 재연결) · [[#PA-ID-001]]
- answers_cq: CQ-PROD-08 (상품-카테고리 노출 구조)
- tags: #결함 #카테고리고아 #BATCH-1 #교정대기

### [PA-ST-002] 색상=자재 오염 → option_items (Q-PA-B·AMBIGUOUS)  {🔴 교정대기}
- 내용: 라이브 현재값 색상 부자재 4종 MAT_TYPE.10 자재 오염([[#PA-BOM-002]]) → 정답 색상=option_items([[#PA-CPQ-002]]). 횡단 자재 오염 패턴([[materials#MAT-005]] .07~.10)의 사례. 진원 = `05_자재정보` 시트가 색상을 자재행으로 정의(L-PA-D). round-11 mapping-info는 색상 귀속을 "미확정(PA-3)"으로 남겼으나 round-13이 라이브 실측해 "이미 자재로 잘못 채워짐"을 밝힘(미정 아닌 MIS-LOADED). 교정 = 색상 자재 논리삭제 + option_items 신설(델타 경로=UPDATE/논리삭제+옵션 INSERT). **귀속 미결(Q-PA-B: 옵션 vs 자재 유지 vs 별 SKU)** — 굿즈파우치 본체색·CONFIRM-PA-3과 일괄.
- 앵커: `t_mat_materials`(MAT_TYPE.10 색상행 논리삭제) → `t_prd_product_option_items`
- 출처: `17_correctness/product-accessory/correction-manifest.md` PA-02·PA-08(GATE-1 재분류) + `_gate/product-accessory-gate.md` §11①②(라이브 mat_cd까지 일치) {tier C13/A, FRESH}
- 연결: [[materials#MAT-005]] (오염 패턴) · [[materials#MAT-GAP-1]] (본체색 합성 vs 색=자재 통일 BATCH-2) · [[cpq-options#CPQ-008]] (전면 미적재) · [[#PA-CPQ-002]] (정답 색상=옵션)
- tags: #결함 #색상자재오염 #Q-PA-B #AMBIGUOUS #교정대기

### [PA-ST-011] CPQ 옵션 레이어 전면 미적재 (BATCH-6)  {🔴 미적재}
- 내용: 라이브 현재값 상품악세사리 CPQ option_items 0행(전 family 18행은 silsa 파일럿뿐, [[cpq-options#CPQ-008]]) → 정답 색상 옵션·봉투세트 캐스케이드 적재 필요. BATCH-6 일괄 적재 미결. 라이브 옵션그룹 2(PRD_000001 "테스트"·002 "제본방식")는 테스트 잔재(부자재 색상 옵션 아님·논리삭제 후보·F-PA-GATE-2).
- 앵커: `t_prd_product_option_items`(상품악세사리 0행) · `t_prd_product_option_groups`(테스트 잔재 2행)
- 출처: `_gate/product-accessory-gate.md` §11③(테스트 잔재 2행 라이브 실측) + 축 [[cpq-options#CPQ-008]](라이브 18행 CONF-1) {tier A/C13, FRESH}
- 연결: [[cpq-options#CPQ-008]] (전면 미적재·silsa 파일럿만) · [[cpq-options#CPQ-GAP-1]] (BATCH-6) · [[#PA-CPQ-002]]
- tags: #결함 #CPQ미적재 #BATCH-6 #테스트잔재 #미적재

### [PA-ST-003] 가격사슬 전무 (round-2 부자재 미커버)  {🔴 교정대기}
- 내용: 라이브 현재값 부자재 가격 공식·component 0행 → 정답 L1 variant별 고정가 적재([[#PA-PRC-001]]). 진원 = round-2 가격 트랙이 부자재를 커버 안 함(load_master 미관여 L-PA-F). 6상품군 가격 미적재 GAP([[price-engine#PE-GAP-3]])의 부자재 사례. 교정 = 부자재 component(예 COMP_ACCESSORY) + 고정형 PRF + variant 단가 적재(round-2 양식·봉투=치수×묶음 격자·색상부자재=색상별). SKU 직접단가 [[price-engine#PE-004]] template_prices 경로도 가능(라이브 0행).
- 앵커: `t_prd_product_price_formulas`(0행) · `t_prc_component_prices`(0행)
- 출처: `17_correctness/product-accessory/correction-manifest.md` PA-03 + `loadlogic-notes.md` §1-7(라이브 0행) {tier C13, FRESH}
- 연결: [[price-engine#PE-GAP-3]] (가격 미적재 6상품군) · [[price-engine#PE-007]] (정답 고정가형) · [[#PA-PRC-001]]
- tags: #결함 #가격전무 #MISSING #교정대기

### [PA-ST-004] 봉투세트 미적재 (Q-ID-A·디지털인쇄 L-G 반대 끝)  {🔴 교정대기}
- 내용: 라이브 현재값 **배경지(043/044)↔봉투 세트 addon 0행·sets 0** → 정답 sets + CPQ 사이즈매칭(§5 권고 [[#PA-CPQ-003]]). 봉투 addon 관계는 실재하나(엽서 PRD_000016→봉투 template 5행 005/006/009/010/011, [[#PA-CPQ-001]]) **배경지는 봉투를 참조 안 함** = 디지털인쇄 L-G(배경지가 봉투 addon 못 받음)의 **반대 끝**(봉투=addon base). 진원 = load_rel_addons 시트20만 읽음(:436)·배경지 C38 자유텍스트 미참조(L-PA-E). search-before-mint 충족(봉투 상품·template 실재). **sets vs addon은 인간 결정(Q-ID-A·🔴)**.
- 앵커: `t_prd_product_sets`(배경지 0행) · `t_prd_product_addons`(prd_cd+tmpl_cd · 배경지 0행 · 엽서 5행)
- 출처: `17_correctness/product-accessory/correction-manifest.md` PA-04·§5 + `loadlogic-notes.md` §3(L-G 반대 끝) {tier C13, FRESH}
- 연결: [[#PA-CPQ-003]] (정답 sets+캐스케이드) · [[cpq-options#CPQ-006]] (OTC 봉투 template) · [[load-path#LP-004]] (search-before-mint)
- answers_cq: CQ-PROD-11 (세트 판매 단위)
- tags: #결함 #봉투세트 #Q-ID-A #MISSING #교정대기

### 7.3 GAP / 🔴 컨펌 (인간 결정 대기)

- **[GAP-PA-1] 🔴 카테고리 재연결 vs 고아 보수 (Q-PA-A·BATCH-1)** — (a) 정상 노드 276/285/287 재연결 + 고아 293 논리정리(권장·search-before-mint·PRD_000283 반례 입증) vs (b) 고아 293 upr만 012로 UPDATE. 디지털인쇄 Q-ID-B와 일괄 결정 후보. → [[load-path#LP-GAP-3]].
- **[GAP-PA-2] 🔴 색상 variant 귀속 (Q-PA-B·BATCH-2)** — 볼체인 8색·리필 7색·와이어링 3색·행택끈 3종을 (a) option_items(권장·정규화 권위 "색상≠자재") vs (b) 자재 유지 vs (c) 별 SKU. 굿즈파우치 본체색·CONFIRM-PA-3과 일괄. → [[materials#MAT-GAP-1]].
- **[GAP-PA-3] 🔴 봉투세트 적재 모델 (Q-ID-A)** — sets + CPQ 사이즈매칭(§5 권고) vs addon vs CPQ 옵션. 디지털인쇄 파일럿 인계 핵심 컨펌. → [[#PA-CPQ-003]].
- **[GAP-PA-4] 🔴 사이즈 3축 분해 깊이 (Q-PA-C·BATCH-6)** — (a) 완전 분해(치수=siz·묶음=bundle·siz_nm 정리) vs (b) 현 합성 유지(표시 편의). book/굿즈 묶음수 처리와 정합. → [[#PA-DIM-001]].
- **[GAP-PA-5] 🔴 카드봉투 색상·이중등록 역할 (Q-PA-D)** — 004(기성·색상 siz 합성) vs 281/282(추가·별 PRD) 색상 처리 일원화 + 역할 분리. → [[#PA-ID-003]].
- **[GAP-PA-6] 🟡 천정고리 use_yn=N / 묶음 단위 통일 / 우드 길이 (Q-PA-E·F·G)** — 천정고리 판매중지 의도 vs 적재 누락(L1 가격 6500)·"장" 단위 통일(EA/매/팩)·우드봉/행거 길이=siz vs 옵션(domain-research PA-4·캘린더 CL-2 일괄).

> 실 교정 COMMIT은 round-5/6/10 트랙 인간 승인 대기 — **DB 미적재 유지**([[load-path#LP-GAP-4]]). 게이트 컨펌 8건(Q-ID-A·Q-PA-A~G).

---

## Sources
- **큐레이션 팩:** `_curation/pack-product-accessory.md`(1차 권위·tier·freshness). round-12 mapping-research 없음 — 권위=round-11+round-13.
- **정체:** `17_correctness/product-accessory/product-identity.md`(C13·FRESH·이중등록 의도) — 보조 `06_extract/product-accessory-l1.csv`(B·15상품 67행).
- **차원/BOM:** `15_domain-spec/product-accessory/column-dictionary.md`(C11·9 의미컬럼·사이즈 3축 복합)·`product-bom.md`.
- **가격:** `15_domain-spec/product-accessory/column-dictionary.md` §4(C9 가격포함→고정가) + `loadlogic-notes.md` §1-7(라이브 0행).
- **CPQ/적재경로:** `17_correctness/product-accessory/loadlogic-notes.md`(C13·file:line) + `10_configurator/all-sheets-otc-extract.md`·`option-vs-template-guide.md`(OTC) + `raw/webadmin/sql/09_delete_dup_products.sql`·`tools/load_master.py`·`migrate_phase7.py`(로직만·A).
- **결함:** `17_correctness/product-accessory/correction-manifest.md`(C13·PA-01~14·Q-ID-A 권고) + `_gate/product-accessory-gate.md`(K0~K6 GO·K4 재게이트).
- **축 페이지(횡단 참조):** `huni/{materials,processes,price-engine,cpq-options,widget-contract,load-path}.md`.
- **STALE(인용 0 확인):** `price-engine-ddl.md`([[price-engine#PE-STALE]]·template_prices 누락)·`constraint_json`([[cpq-options#CPQ-STALE]])·`dep_proc_cd`·v03 입력 xlsx([[load-path#LP-STALE]]) — 본 페이지 미인용.
