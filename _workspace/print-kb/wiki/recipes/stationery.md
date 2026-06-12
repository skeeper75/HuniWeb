# 문구(stationery) 레시피  {전체상태: 🟡}

> 조립 뷰(README §3·§9). 횡단 사실은 축 페이지를 `[[링크]] + 관계동사`로 참조만 한다(본문 복붙 금지). 이 페이지 고유 사실(prd_cd 목록·교정대기 행)만 원자 블록으로 둔다.
> **권위:** 정체 = `17_correctness/stationery/product-identity.md`(C13, FRESH) · 차원/BOM = `15_domain-spec/stationery/product-bom.md`·`column-dictionary.md`(C11, booklet 동형 참조 `15_domain-spec/booklet/`) · 결함 = `17_correctness/stationery/correction-manifest.md`(C13)·`_gate/stationery-gate.md`(GO·K0~K6 PASS). 큐레이션 팩 = `_curation/pack-stationery.md`.
> **booklet 동형:** 문구(카테고리 008)는 책자(006)와 **구조 동형**(내지+표지+제본 이중블록). 단 ① 가격 inline(C29·round-2 고정가형) ② 박/형압 블록 없음(문구=박 미운영) ③ **미싱제본 신규 공정 필요**가 차이. booklet pack과 교차참조([[booklet#BK-ID-002]]).
> **STALE 금지:** `price-engine-ddl.md`([[huni/price-engine#PE-STALE]])·v03 입력 xlsx([[huni/load-path#LP-STALE]]) 인용 0. round-12 mapping-research **없음**(매핑 권위 = round-11 booklet 동형 + round-13). 라이브 오적재는 "라이브 현재값 → 정답" 양면 표기(7절).

---

## CQ 헤더 (이 페이지가 답하는 질문)

- 문구는 무엇인가 — 어떤 상품(만년다이어리 4종/먼슬리/스프링노트·수첩/메모패드/중철노트/떡메모지)이고 어떤 생산구조(A통합·B셋트·단순)인가.
- 어떤 차원·옵션이 있는가 — 사이즈(고정규격)·page_rule/장수/묶음수 3축·내지/표지/면지 자재 슬롯·제본/코팅 공정.
- 가격은 어떻게 계산되는가 — C29 inline 고정가형(round-2)·떡메모지=묶음수×size 매트릭스·문구 카테고리 수량구간 할인.
- DB에 어떻게 등록하는가 — webadmin load_master 10·11~21 시트 적재(booklet 동형·v03 전파기).
- 현재 라이브 적재 상태·교정 대기는 무엇인가 — ST-01~16 교정대기(미싱제본 MISSING·종이 usage.07·코팅 평면화·카테고리 고아 등) + 컨펌 Q-ST-A~M·GAP.

---

## 0. 정체 (identity) — 문구
앵커: `t_prd_products` · `t_cat_categories` · `t_prd_product_sets`

### [ST-ID-001] 문구 = 11 활성 완제품(만년다이어리 4·노트류 7) + 반제품 1 (PRD_000172~181·097/098)  {✅}
- 내용: 문구 family는 **카테고리 008 문구·일반 인쇄물**. 11 활성 완제품 = 만년다이어리 4종(소프트 PRD_000172·하드 173·레더하드 174·레더소프트 175)·먼슬리플래너 176·스프링노트 177·스프링수첩 178·메모패드 179·중철노트 181·**떡메모지 097**(booklet 시트에도 중복 노출·동일 상품) + 준비중 1(메모패드 내지커스텀 PRD_000180·use_yn=N) + 반제품 1(떡메모지 내지 PRD_000098 SEMI_ROLE.01). 정체 오분류 0(포장재/굿즈로 오인하지 않음 — 인쇄배경지=포장재 오분류 같은 실수 회피).
- 앵커: `t_prd_products`(prd_typ_cd .03 기성상품(활성 10)·.04 디자인상품(떡메모지 097)·.02 반제품(098)) · `t_cat_categories`(CAT_000008 문구)
- 출처: `17_correctness/stationery/product-identity.md` §0·§1(12 상품표) + `_gate/stationery-gate.md` K0 PASS {tier C(round-13), FRESH·product-master:78/137-141·크롤 product_list_1.html}
- 연결: [[#ST-ID-002]] · [[booklet#BK-ID-001]] (떡메모지 097 booklet 중복 노출) · [[huni/load-path#LP-001]] (loaded-via — load_master 10_상품정보)
- answers_cq: CQ-PROD-01 (상품 분류·적재 기준)
- tags: #문구 #정체 #완제품11 #008문구 #일반인쇄물

### [ST-ID-002] 생산구조 3종 (A통합·B셋트·단순) — booklet 동형  {✅}
- 내용: 문구 정체의 핵심은 **생산구조 3종**(책자 동형). **A 통합**(먼슬리·스프링노트·스프링수첩·중철노트) = 내지(USAGE.01)+표지(USAGE.02) parent 자재. **B 셋트**(만년다이어리 하드 173·레더하드 174) = 표지 하드보드 반제품 sub_prd + 면지(USAGE.03). **단순**(만년다이어리 소프트 172·레더소프트 175·메모패드 179·떡메모지 097) = 내지만/PVC/레더·미싱/떡제본. **[HARD] 자재 권위는 항상 parent + usage_cd**(반제품 098 9속성 0행=정상).
- 앵커: `t_prd_product_sets`(B셋트 sub_prd 연결) · `t_prd_product_materials`(usage_cd 슬롯)
- 출처: `15_domain-spec/stationery/product-bom.md` §0 + `17_correctness/stationery/product-identity.md` §2 {tier C, FRESH}
- 연결: [[huni/materials#MAT-002]] (uses — parent+usage_cd 모델) · [[booklet#BK-ID-002]] (책자 A통합/B셋트/떡제본 동형) · [[#ST-DEF-005]] (B셋트 sub_prd 미적재 교정대기)
- answers_cq: CQ-PROD-11 (묶음/세트 판매 단위) · CQ-PROD-03 (반제품 귀속)
- tags: #문구 #생산구조 #A통합 #B셋트 #단순 #booklet동형

### [ST-ID-003] 만년다이어리 4종 = 별상품 적재 (variant 아님·ST2-2)  {🟡}
- 내용: 만년다이어리 커버타입 4종(소프트/하드/레더하드/레더소프트)은 라이브가 **별 prd_cd 4상품**(별 MES 008-0020~0023)으로 적재 — round-11 가설(A) 별상품 모델과 정합(USAGE.06 표지타입 variant 통합 모델 아님). 정체 자체는 확정(4 커버타입 별 판매상품). 단 "별 prd_cd 유지 vs 1상품+표지타입 variant" **데이터모델 결정**은 인간 컨펌(ST2-2).
- 앵커: `t_prd_products`(PRD_000172~175 별 prd_cd·별 MES)
- 출처: `17_correctness/stationery/product-identity.md` §1 주(ST2-2) + `_gate/stationery-gate.md` K0 {tier C(round-13), FRESH·별 MES 008-0020~0023}
- 연결: [[#ST-DEF-006]] (컨펌 Q-ST 미결) · [[huni/cpq-options#CPQ-004]] (uses — 별상품 vs variant 데이터모델 결정)
- answers_cq: CQ-PROD-06 (variant 사이즈/커버타입 → 차원 분해)
- tags: #문구 #만년다이어리 #별상품 #variant #ST2-2

---

## 1. 차원 (dimensions) — 문구
앵커: `t_prd_product_sizes`/`plate_sizes`/`bundle_qtys`/`page_rules` · `t_siz_sizes`

### [ST-DIM-001] 사이즈 = 고정규격 (면적계산·박 없음)  {🟡}
- 내용: 문구 사이즈는 `t_prd_product_sizes.siz_cd → t_siz_sizes`의 **고정규격**(만년다이어리 4종 130x190 동일·중철노트 A6 105x148·스프링수첩 90x145·메모패드 144x206/182x257 2종·떡메모지 90x90/70x120 2종). 실사·아크릴 같은 면적매트릭스가 아니다(앱 면적/박 계산 **없음** — 고정 size·고정가). 표지/내지 펼침 작업치수는 `t_prd_product_plate_sizes.siz_cd`로 별도.
- 앵커: `t_prd_product_sizes.siz_cd` · `t_prd_product_plate_sizes.siz_cd`
- 출처: `15_domain-spec/stationery/product-bom.md` §1~§11(상품별 size) + `17_correctness/stationery/loadlogic-notes.md` §4("미저장: 없음·문구=고정 size·고정가") {tier C(round-11/13), FRESH·라이브 실측}
- 연결: [[base/sizes#BSZ-001]] (uses — 재단/작업/출력판형 보편 구분) · [[#ST-DIM-002]]
- answers_cq: CQ-PROD-06 (variant 사이즈 → 차원 분해)
- tags: #문구 #사이즈 #고정규격 #박없음

### [ST-DIM-002] 주문 축 3종 = page_rule / 장수 / 묶음수(권)  {🟡}
- 내용: 문구 주문 차원은 **3축 차등**(booklet 동형) — ① **page_rule(고정)**: 먼슬리플래너=28~28·증가0(28P 단일 고정 페이지). ② **page=장수**: 떡메모지=3~3·증가3(장수 단위·라이브 3/3/3 잡음 의심 [ST-DEF-002]). ③ **묶음수(권)**: 떡메모지=50장1권·100장1권(`t_prd_product_bundle_qtys.bdl_qty`, bdl_unit_typ_cd=QTY_UNIT.03). page 무의미(빈값)=스프링노트/수첩(무지내지)·메모패드·중철노트.
- 앵커: `t_prd_product_page_rules`(page_min/max/incr) · `t_prd_product_bundle_qtys`(bdl_qty·bdl_unit_typ_cd=QTY_UNIT.03)
- 출처: `15_domain-spec/stationery/product-bom.md` "page_rule vs 묶음수 vs 장수 3축 차등"(§166~170) + `17_correctness/stationery/correction-manifest.md` ST-07·ST-15 {tier C, FRESH·라이브 실측 097=3/3/3·176=28/28/0}
- 연결: [[base/binding#BBD-001]] (uses — 시그니처=제본 단위) · [[booklet#BK-DIM-002]] (책자 page_rule 제본별 차등 동형) · [[#ST-DEF-002]] (떡메모지 page_rule 3/3/3 잡음 교정대기)
- answers_cq: CQ-PROD-01 (페이지/묶음 적재 기준) · CQ-PROD-11 (묶음 판매 단위)
- tags: #문구 #page_rule #장수 #묶음수 #3축

---

## 2. 자재·공정 BOM — 문구
앵커: `t_prd_product_materials`/`processes` · `t_mat_materials` · `t_proc_processes`

### [ST-BOM-001] 자재 usage 슬롯 = 내지.01·표지.02·면지.03·투명커버(PVC).05·부속  {🟡}
- 내용: 문구 자재는 usage_cd 슬롯으로 구분 — **내지(USAGE.01)**(백모조100·백모조120·무지내지 옵션·`*별도설정` 공통풀, MAT_TYPE.01 종이)·**표지(USAGE.02)**(아트250·레더화이트)·**면지(USAGE.03)**(하드커버 화이트/블랙/그레이 MAT_000001~004 재사용)·**투명커버(USAGE.05)**(PVC커버·만년다이어리 소프트)·**부속**(실버링 MAT_000016·합지보드/하드보드 MAT_TYPE.07). 단 **면지·실버링·PVC·합지보드는 라이브 미연결**(L1 C27/C37 힌트 미반영 [ST-DEF-004]).
- 앵커: `t_prd_product_materials.usage_cd` · `t_mat_materials.mat_typ_cd`
- 출처: `15_domain-spec/stationery/product-bom.md` "BOM 횡단 자재"(§145~152) + `17_correctness/stationery/correction-manifest.md` ST-08~11 {tier C(round-11/13), FRESH·라이브 실측}
- 연결: [[huni/materials#MAT-001]] (uses — 자재 마스터·usage_cd 구조) · [[huni/materials#MAT-002]] (uses — parent+usage_cd) · [[booklet#BK-BOM-001]] (책자 usage 슬롯 동형) · [[huni/cpq-options#CPQ-005]] (requires — 부속=옵션 자재축)
- answers_cq: CQ-PROD-05 (상품별 자재 축) · CQ-TERM-04 (소재 약어)
- tags: #문구 #자재 #usage슬롯 #면지 #PVC #부속

### [ST-BOM-002] 공정 = 제본(PROC_000017 자식)·코팅 (박/형압 없음)  {🟡}
- 내용: 문구 공정 — **제본**(PROC_000017 자식: 트윈링 PROC_000021[스프링노트 좌철·수첩 상철]·중철[중철노트]·떡제본[메모패드·떡메모지]·하드커버[만년다이어리 하드/레더하드], 상품=제본 1:1, mand_proc_yn)·**코팅**(표지 무광코팅 PROC_000015, **코팅=공정** Q9 정합·책자 측 기준점). **박/형압 블록 없음**(문구=박 미운영, 책자와 차이). 단순 상품(소프트/레더소프트/먼슬리)은 **미싱제본 MISSING**([ST-DEF-001]).
- 앵커: `t_proc_processes`(PROC_000017/021/015 자식) · `t_prd_product_processes`
- 출처: `15_domain-spec/stationery/product-bom.md` "BOM 횡단 공정"(§154~164) + `17_correctness/stationery/correction-manifest.md` ST-03·ST-05·ST-06 {tier C, FRESH·라이브 실측}
- 연결: [[huni/processes#PRC-001]] (uses — 공정 마스터·mand_proc_yn) · [[huni/processes#PRC-005]] (uses — 코팅=공정 실무진확정) · [[huni/processes#PRC-006]] (코팅 CONFLICT — 책자/문구는 공정 측 기준점) · [[booklet#BK-BOM-002]] (책자 제본/코팅=공정 동형·단 책자는 박 운영) · [[base/binding#BBD-003]] (uses — 제본 방식 보편 정의)
- answers_cq: CQ-FIN-01 (후가공 공정 목록) · CQ-PROC-01 (공정 라우트)
- tags: #문구 #공정 #제본 #코팅공정 #박없음

### [ST-BOM-003] 미싱제본 = 신규 공정 필요 (030/074는 제본 family 아님)  {🔴 교정대기}
- 내용: 만년다이어리 소프트(172)·레더소프트(175)·먼슬리(176)는 L1 COMMENT `*출력+미싱`(미싱제본·사철=실박음 소프트커버 표준)이나 **라이브 제본 공정 0행(MISSING)**. PROC_000017 자식 9종에 미싱**제본** 부재. **[search-before-mint 완결]** 기존 미싱류 공정 2개를 검토했으나 둘 다 제본 family 아님: `PROC_000030 미싱`(부모 NULL·후가공 줄수 param=재봉선)·`PROC_000074 6단미싱접지`(부모 PROC_000056 접지). → 제본 family 내 재사용 후보 없음. 정답 = 신규 자식 mint(Q-ST-A (a))·또는 PROC_000030 후가공 재해석(b)·무선/중철 변형(c) — 인간 컨펌.
- 앵커: `t_proc_processes`(미싱제본 — 미신설·PROC_000017 자식)
- 출처: `17_correctness/stationery/correction-manifest.md` ST-06·Q-ST-A(F-ST-G2 search-before-mint) + `_gate/stationery-gate.md` §11 K5(030 부모 NULL·074 부모 PROC_000056 독립 재실측) {tier C(round-13), FRESH·라이브 실측}
- 연결: [[huni/processes#PRC-008]] (미싱제본 MISSING 축 권위) · [[huni/processes#PRC-GAP-2]] (BATCH-13 신규 공정 신설 미결) · [[huni/load-path#LP-004]] (requires — search-before-mint 완결)
- answers_cq: CQ-FIN-01 (후가공/제본 공정 목록) · CQ-PROC-01 (공정 라우트·신설)
- tags: #문구 #미싱제본 #MISSING #신규공정 #BATCH-13 #교정대기

---

## 3. 가격 사슬 (price chain) — 문구
앵커: `t_prc_*` 4단(`t_prd_product_price_formulas`→components→component_prices) + `t_dsc_*`

### [ST-PRC-001] 가격 = C29 inline 고정가형 (round-2 미실행·prices 0행)  {🔴 미적재}
- 내용: 문구 가격은 **C29 inline 고정가형**(만년다이어리 소프트 9000·중철노트 4500 등 수량×옵션 격자 룩업). **라이브 현재값: `t_prd_product_prices` 0행(전 상품 미적재) → 정답: 고정형 PRF + component_prices 적재(round-2 양식)**. 가격은 round-2 트랙 책임(load_master 미관여·:469~481에 가격 없음) → 라이브 0행은 load_master 결함이 아니라 **round-2 문구 미실행**(GAP-ST-4·BATCH-7). 가격값 분석 자체는 round-2 트랙.
- 앵커: `t_prc_price_formulas`(고정형 PRF·미적재) · `t_prd_product_prices`(라이브 0행)
- 출처: `17_correctness/stationery/correction-manifest.md` ST-13(L-ST-J) + `15_domain-spec/stationery/product-bom.md` "가격(round-2 고정가형)"(§174) + `06_extract/stationery-l1.csv`(C29 inline 단가) {tier C/B, FRESH·라이브 0행·차단=round-2 미실행}
- 연결: [[huni/price-engine#PE-007]] (priced-by — 고정가형 수량×옵션) · [[huni/price-engine#PE-GAP-3]] (문구 가격 미적재 prices 0행·6상품군 부재) · [[huni/load-path#LP-007]] (loaded-via — GO분 적재됨·문구 가격 미적재)
- answers_cq: CQ-PRICE-01 (가격 공식 계산) · CQ-PRICE-07 (고정가 구조)
- tags: #문구 #가격 #고정가형 #미적재 #round2미실행 #BATCH-7

### [ST-PRC-002] 떡메모지 가격 = 묶음수×size 매트릭스 (`*가격표참고`)  {🔴 미적재}
- 내용: 떡메모지(PRD_000097)는 C29=`*가격표참고`(오렌지) — **묶음수(50/100장1권)×size(90x90/70x120) 별도 가격표 매트릭스**(다른 문구 상품의 단순 inline 고정가와 다름·ST2-7). 라이브 미적재(round-2 트랙). booklet 시트의 떡메모지(097)와 동일 상품. **[혼동 차단]** booklet `mapping.md` L26의 "떡메모지 ... PRF_TTEOKME_FIXED + 112행 **✓**"는 라이브 미확인 — 그 "✓"가 라이브 갭을 은폐(F-PB-1 동형). 라이브 권위: PRD_000097 가격공식 **바인딩 0행**([[booklet#BK-PRC-002]] 참조).
- 앵커: `t_prd_product_prices`(묶음수×size 매트릭스·라이브 0행) · 단가 `t_prc_component_prices`(COMP_TTEOKME 112행 존재·바인딩만 미적재)
- 출처: `15_domain-spec/stationery/product-bom.md` §11·§136(가격표참고 매트릭스) + `17_correctness/stationery/correction-manifest.md` ST-13(떡메모지=묶음수×size) {tier C, FRESH·떡메모지 가격=양면표기(라이브 갭)}
- 연결: [[huni/price-engine#PE-007]] (priced-by — 고정가/매트릭스 격자) · [[#ST-DIM-002]] (uses — 묶음수 격자) · [[booklet#BK-PRC-002]] (떡메모지 바인딩 미적재 booklet 측 권위)
- answers_cq: CQ-PRICE-01 (가격 공식 계산)
- tags: #문구 #가격 #떡메모지 #매트릭스 #가격표참고 #미적재

### [ST-PRC-003] 문구 카테고리 수량구간 할인 (t_dsc_*)  {🟡}
- 내용: 문구는 **카테고리 단위 수량구간 할인**(round-1·아크릴/굿즈파우치/문구 카테고리 단위 적용) 곱 적용. C36 `문구 구간할인`. 고정가/매트릭스 단가 × 구간할인율.
- 앵커: `t_dsc_*`(헤더·구간·링크)
- 출처: `15_domain-spec/stationery/product-bom.md` §174(C36 문구 구간할인) + [[huni/price-engine#PE-008]](문구 카테고리 단위) {tier C, FRESH}
- 연결: [[huni/price-engine#PE-008]] (priced-by — 수량구간 할인 t_dsc_*·문구 카테고리) · 메모리 `dbmap-discount-authority`
- answers_cq: CQ-PRICE-04 (수량 구간별 할인 체계)
- tags: #문구 #구간할인 #t_dsc #카테고리단위

---

## 4. CPQ 옵션 레이어 — 문구
앵커: `t_prd_product_option_groups`/`options`/`option_items` · `constraints` · `templates`

### [ST-CPQ-001] 문구 option_groups 0행 (제본 1:1·CPQ 전면 미적재)  {🔴 미적재}
- 내용: **라이브 현재값: 문구 option_groups 0행** → 정답: 문구는 booklet 동형으로 **상품=제본 1:1**(스프링노트→트윈링제본)이라 제본 택일그룹 불요(현 1:1 모델 정상). 단 면지 색상·코팅·실버링/PVC 등 옵션은 CPQ 옵션 레이어로 표현 가능하나 **전 family CPQ 전면 미적재**(silsa 파일럿만 18행)와 정합 — 일괄 적재 미결(BATCH-6).
- 앵커: `t_prd_product_option_groups`(라이브 0행)
- 출처: `17_correctness/stationery/product-identity.md` §2(제본 1:1) + `_gate/stationery-gate.md` K6(별색 N/A·v03 비참조) {tier C(round-13), FRESH·라이브 0행}
- 연결: [[huni/cpq-options#CPQ-008]] (CPQ 전면 미적재 silsa 파일럿만 18행) · [[huni/cpq-options#CPQ-GAP-1]] (BATCH-6 일괄 적재 미결) · [[booklet#BK-CPQ-001]] (책자 option_groups 0행·제본 1:1 동형)
- answers_cq: CQ-PROD-05 (선택 옵션 축·캐스케이드)
- tags: #문구 #CPQ미적재 #제본1대1 #BATCH-6

### [ST-CPQ-002] 표지/부속 옵션 = 자재+공정 BUNDLE 후보 (면지·실버링·PVC)  {🟡}
- 내용: 문구 표지/부속 옵션은 CPQ 적재 시 BUNDLE 원칙 적용 대상 — **면지**(USAGE.03 화이트/블랙/그레이 자재 + 부착, 색상 3종=variant)·**실버링**(USAGE.07 부속 자재 + 트윈링 결합·또는 트윈링 prcs_dtl_opt 링컬러 param)·**PVC커버**(USAGE.05 필름 자재 + 부착). 옵션을 공정만/자재만으로 반쪽 매핑 금지.
- 앵커: `t_prd_product_option_items`(다중 seq) · `t_prd_product_constraints.logic`(조건부)
- 출처: `17_correctness/stationery/correction-manifest.md` ST-08·ST-09·ST-10(면지/실버링/PVC) + `15_domain-spec/stationery/product-bom.md` §150~152 {tier C, FRESH}
- 연결: [[huni/cpq-options#CPQ-005]] (uses — BUNDLE 자재+공정) · [[huni/cpq-options#CPQ-002]] (requires — polymorphic ref_dim_cd mat_cd+usage_cd) · [[booklet#BK-CPQ-002]] (책자 투명커버/링/면지 BUNDLE 동형)
- answers_cq: CQ-FIN-10 (옵션=자재+공정)
- tags: #문구 #CPQ #BUNDLE #면지 #실버링 #PVC

---

## 5. 위젯 계약 (widget contract) — 문구
앵커: 정규화 계약(`huni-widget/03_spec/`) — DB 외 앵커임을 명시

### [ST-WID-001] 문구 위젯 = 정규화 계약 일반형 (전용 스펙 부재)  {⚪ 명세}
- 내용: 문구는 **전용 위젯 스펙이 없다**(아크릴·굿즈파우치·캘린더만 family 스펙 존재). 문구 위젯은 데이터계약 일반형 + 후니 어댑터로 도출(위젯 코어 불변). page_rule(28P 고정)·묶음수(권) 격자·제본 택1(상품=제본 1:1이라 단순)·면지/커버 옵션·만년다이어리 커버타입 선택은 componentType 매핑으로, 가격은 서버 권위(PRICE=0 불가·가격 적재 선행 필요 [ST-PRC-001]).
- 앵커: DB 외 — `huni-widget/03_spec/data-contract.md`(일반형) · 어댑터 경계
- 출처: `huni-widget/03_spec/data-contract.md` + [[huni/widget-contract#WID-GAP-3]](family 스펙 존재분) {tier D, FRESH}
- 연결: [[huni/widget-contract#WID-001]] (mapped-to — 정규화 계약) · [[huni/widget-contract#WID-003]] (mapped-to — 14 componentType) · [[huni/widget-contract#WID-005]] (priced-by — 서버 가격권위·가격 적재 선행) · [[booklet#BK-WID-001]] (책자 정규화 계약 일반형 동형)
- answers_cq: CQ-PROD-08 (상품-카테고리 UI 노출) · CQ-PRICE-01 (가격 권위=서버)
- tags: #문구 #위젯 #정규화계약 #전용스펙부재

---

## 6. 적재 레시피 (load path) — 문구
앵커: `raw/webadmin/sql/*`·`tools/load_master.py` · round-8 `13_admin-ui-spec/`

### [ST-LP-001] 문구 적재 = load_master 10_상품정보 + 11~21 relation 시트 (booklet 동형)  {🟡}
- 내용: 문구는 `load_master.py` 단일 트랜잭션으로 적재 — 10_상품정보(완제품+sub_prd) + relation 시트(11 카테고리·12 묶음수·13 사이즈·14 자재[usage_cd]·15 공정[mand_proc_yn]·16 인쇄옵션·17 판형·19 셋트·21 페이지룰). **[HARD] load_master는 순수 전파기** — 입력 v03 xlsx 인용 금지(진원=상류 v03 정규화·정답=상품마스터 L1). 멱등=이름 기반 UPSERT·search-before-mint. 가격(C29)·구간할인(C36)은 load_master 미관여(round-2/round-1 별 트랙).
- 앵커: `raw/webadmin/tools/load_master.py`(L164~456 함수군, 로직만) · `13_admin-ui-spec/`
- 출처: `17_correctness/stationery/loadlogic-notes.md` §0(테이블↔함수 매핑·v03 시트 10/11/13/14/15/16/17/18/21) {tier A/C, FRESH(HEAD)·로직만 oracle}
- 연결: [[huni/load-path#LP-001]] (loaded-via — 적재 oracle) · [[huni/load-path#LP-003]] (uses — FK 위상순서) · [[huni/load-path#LP-004]] (uses — 멱등 search-before-mint) · [[huni/load-path#LP-STALE]] (v03 입력 금지) · [[booklet#BK-LP-001]] (책자 load_master 적재 동형)
- answers_cq: CQ-PROD-01 (상품 적재 기준) · CQ-FILE-01 (운영자 입력경로)
- tags: #문구 #적재 #load_master #v03전파기 #booklet동형

### [ST-LP-002] 적재 결함 진원 = v03 정규화 (L-ST-A~K) · 교정 = L1 권위 델타  {🟡}
- 내용: 문구 적재 결함 L-ST-A~K(종이 usage.07 fallback·코팅 평면화·카테고리 고아·레더 .08·제본 mand 혼재·미싱제본 누락·page 3/3/3 잡음·면지/실버링/PVC 미연결·B셋트 sub_prd 미적재·가격 전무·레더소프트 공정 0행)는 **전부 load_master 코드 결함이 아니라 v03 정규화 결함**(load_master는 충실 전파). 대표 결함원 = `load_rel_materials:324` `r["용도"] or "공통"`(종이 용도 공란 → USAGE.07 fallback). 교정 = v03 행 직접 수정이 아니라 **상품마스터 L1 권위 델타**(round-5/6 + 인간 승인).
- 앵커: `raw/webadmin/tools/load_master.py`(L324/175/288/116-121/415/453) · 정답 = `06_extract/stationery-l1.csv`
- 출처: `17_correctness/stationery/loadlogic-notes.md` §1·§2(R-CAT/R-MAT/R-PMAT/R-PROC/R-PAGE 재구성 + L-ST-A~K file:line) {tier A/C, FRESH}
- 연결: [[huni/load-path#LP-STALE]] (v03 진원) · [[huni/load-path#LP-GAP-1]] (BATCH-12 v03 상류 vs DB 직접) · [[#ST-DEF-001]] (교정대기 양면표기)
- answers_cq: CQ-PROD-01 (적재 기준)
- tags: #문구 #적재결함 #v03진원 #L1권위델타

---

## 7. 현황·결함 (state) — 문구

### 적재 현황
- **GO분 적재됨:** 문구 11 완제품 + 반제품 1·일부 자재 usage 슬롯·일부 제본/코팅 공정·page_rule·묶음수·sub_prd/sets(떡메모지 097→098)가 라이브 적재됨([[huni/load-path#LP-007]]). round-13 게이트 = **GO**(`_gate/stationery-gate.md` K0~K6 PASS·F-ST-G1/G2/G3 보정 RESOLVED).
- **미적재/MISSING:** 가격 전 상품 **0행**(round-2 미실행)·option_groups 0행(CPQ 전면 미적재)·**미싱제본 공정 MISSING**(소프트/레더소프트/먼슬리)·면지/실버링/PVC/합지보드 자재 미연결·B셋트 sub_prd(만년다이어리 하드/레더하드) 미적재·plate output_paper_typ_cd 전량 NULL.

### [ST-DEF-001] 라이브 오적재 양면 표기 (round-13 correction-manifest)  {🔴 교정대기}
- 내용: round-13이 확정한 문구 라이브 오적재/미적재. 라이브값을 사실로 단정 금지 — correction-manifest 대조 필수(ST-04 레더는 [[huni/materials#MAT-006]] .06 권위와 연결).

| 항목 | 라이브 현재값 | 정답 | 분류·심각도 | 출처 |
|---|---|---|---|---|
| **ST-06** 미싱제본 (172/175/176) | 제본 공정 0행 | 미싱제본(신규 공정·030/074는 제본 아님) | MISSING·**High** | correction-manifest.md ST-06 / Q-ST-A |
| **ST-01** 플래너 5 카테고리 | CAT_000300 플래너(upr=NULL·lvl3 고아) | 커버타입 의미 매칭: 소프트172→121·하드173→122·레더하드174→120·레더소프트175→119·먼슬리176→123 (노드순≠prd_cd순!) | MIS-LOADED·**High** | correction-manifest.md ST-01 / F-ST-G1 |
| **ST-02** 종이 usage (176/177/178/179/181·097) | USAGE.07 공통 | USAGE.01 내지 | MIS-LOADED·High | correction-manifest.md ST-02 |
| **ST-13** 가격 (전 상품) | `t_prd_product_prices` 0행 | C29 inline 고정가·떡메모지=묶음수×size 매트릭스 | MISSING·High | correction-manifest.md ST-13 |
| **ST-03** 표지 코팅 평면화 (172~179/181) | `아트250 + 무광코팅` 한 자재행(MAT_000260/250 중복) | 아트250(자재 USAGE.02) + 무광코팅(공정 PROC_000015) 분리 | MIS-LOADED·Med | correction-manifest.md ST-03 |
| **ST-04** 레더 (174/175 표지) | MAT_000186 MAT_TYPE.08 실사소재 | .06 가죽(.06 고아행 4개 실재) | AMBIGUOUS·Med | correction-manifest.md ST-04 / Q-BK-A 통합 |
| **ST-08~11** 면지·실버링·PVC·합지보드 | 자재 0행(미연결) | 면지 USAGE.03·실버링 USAGE.07·PVC USAGE.05·합지보드 MAT_TYPE.07(기존행 재사용·신설 0) | MISSING·Med~Low | correction-manifest.md ST-08~11 |
| **ST-12** B셋트 sub_prd (173/174) | sets 0행·표지 sub_prd 없음 | 표지 하드보드 반제품 sub_prd + sets(또는 parent usage만) | MISSING·Low | correction-manifest.md ST-12 |
| **ST-05** 떡제본 mand (097 vs 179) | 097 떡제본=N·179 떡제본=Y(비일관) | 같은 떡제본 일관 통일(필수 여부 도메인 판단) | MIS-LOADED·Low | correction-manifest.md ST-05 / Q-ST-F |
| **ST-07** 떡메모지 page_rule | 3/3/3 | 떡제본 page 무의미(묶음수=진짜 축)·또는 page=장수3 | MIS-LOADED·Med | correction-manifest.md ST-07 / Q-BK-B 통합 |
| **ST-16** plate 출력용지규격 | output_paper_typ_cd NULL | 폴더(디지털/특수인쇄)=출력용지규격 또는 견적밖 | AMBIGUOUS·Low | correction-manifest.md ST-16 / Q-BK-C 통합 |

- 출처: `17_correctness/stationery/correction-manifest.md` §1 분류표(18건: CORRECT 2·MIS-LOADED 5·MISSING 8·EXTRA 0·AMBIGUOUS 3) + `_gate/stationery-gate.md` §11(GO·K4 독립 SELECT 재현·F-ST-G1 커버타입 의미 매칭 입증) {tier C(round-13), FRESH}
- 연결: [[huni/processes#PRC-008]] (ST-06 미싱제본 MISSING) · [[huni/materials#MAT-006]] (ST-04 레더 정답 .06) · [[huni/materials#MAT-005]] (.07~10 자재오염) · [[#ST-LP-002]] (v03 진원)
- tags: #문구 #결함 #교정대기 #round13

### [ST-DEF-002] 카테고리 의미매칭 — 노드순≠prd_cd순 (F-ST-G1·적재 안전 관문)  {🔴 교정대기}
- 내용: 문구는 이 교훈의 **원천**. 플래너 5상품이 고아 노드 CAT_000300(upr=NULL)에 연결 → 정상 노드 CAT_000119~123(전부 upr=008 문구 lvl2)이 이미 실재(search-before-mint). **[HARD] 노드 발급순(레더소프트119/레더하드120/소프트121/하드122/먼슬리123)≠prd_cd순(소프트172/하드173/레더하드174/레더소프트175)** → **상품 이름/커버타입 의미로 매칭**해야(172→121·173→122·174→120·175→119·176→123). prd_cd 순차 재연결 시 4상품 전부 오연결(기계적 번호 매칭 금지). 교정 = 의미 매칭 재연결 + 고아 300 논리정리(BATCH-1).
- 앵커: `t_cat_categories`(CAT_000119~123·300) · `t_prd_product_categories`
- 출처: `17_correctness/stationery/correction-manifest.md` ST-01 + `_gate/stationery-gate.md` §11 K4(노드명 커버타입 field-for-field 일치·독립 재실측) {tier C(round-13), FRESH·라이브 재실측}
- 연결: [[huni/load-path#LP-GAP-3]] (카테고리 고아 113상품 횡단·BATCH-1) · [[#ST-DEF-001]]
- tags: #문구 #카테고리고아 #의미매칭 #F-ST-G1 #BATCH-1

### [ST-DEF-005] B셋트 sub_prd 미적재 (booklet 비대칭)  {🔴 교정대기}
- 내용: 만년다이어리 하드(173)·레더하드(174)는 생산구조 B 셋트(표지 하드보드 반제품)이나 **라이브 sets 0행·표지 sub_prd 없음**(v03 19시트 행 없음). booklet은 하드커버 sub_prd 보유(비대칭). 단 **자재 권위=parent usage_cd**라 sub_prd 없이 parent 자재로도 가능(booklet Q3=parent usage + sets 병행) → 컨펌 Q-ST-L.
- 앵커: `t_prd_product_sets`(173/174 미적재) · `t_prd_product_materials`(parent usage 권위)
- 출처: `17_correctness/stationery/correction-manifest.md` ST-12(L-ST-I) {tier C(round-13), FRESH}
- 연결: [[#ST-ID-002]] (B셋트 생산구조) · [[booklet#BK-ID-002]] (책자 하드커버 sub_prd 보유 동형·비대칭)
- tags: #문구 #B셋트 #sub_prd #미적재 #Q-ST-L

### [ST-DEF-006] 컨펌 미결 (Q-ST-A~M)  {🔴 미결}
- 내용: 문구 인간 결정 대기 12건 — **고유 핵심**: Q-ST-A(미싱제본 신규 mint vs PROC_000030 후가공 재해석 vs 변형)·Q-ST-F(떡제본 필수 여부 → mand 통일). **일괄 결정 후보**(중복 제거): Q-ST-B=Q-ID-B/PA-01(카테고리 고아)·Q-ST-D=Q-BK-A(레더 .06/.08·포토북 D-PB-1)·Q-ST-E=Q9(코팅 family 통일)·Q-ST-G=Q-BK-B(떡메 page 잡음)·Q-ST-C=Q-BK-C(폴더)·Q-ST-I=BK-3(링/실버링)·Q-ST-H(면지 색상 variant)·Q-ST-J(PVC 견적밖 여부)·Q-ST-K=ST2-8(합지보드 부속)·Q-ST-L(B셋트 sub_prd)·Q-ST-M(bundle dflt). 횡단 결정 = BATCH-1(고아)·BATCH-3(코팅)·BATCH-13(미싱제본 신규)·BATCH-12(v03 상류 vs DB 직접).
- 출처: `17_correctness/stationery/correction-manifest.md` §4(Q-ST-A~M) {tier C(round-13), FRESH}
- 연결: [[huni/processes#PRC-GAP-2]] (BATCH-13 미싱제본) · [[huni/processes#PRC-GAP-1]] (BATCH-3 코팅) · [[huni/materials#MAT-006]] (Q-ST-D 레더) · [[huni/load-path#LP-GAP-1]] (BATCH-12 v03 상류)
- tags: #문구 #컨펌미결 #Q-ST #BATCH

### GAP (이 family 고유)
- **[GAP-ST-1]** 미싱제본 신규 공정 신설(BATCH-13·Q-ST-A) — [[huni/processes#PRC-GAP-2]]. (search-before-mint 완결: 030/074는 제본 family 아님.)
- **[GAP-ST-2]** 카테고리 의미매칭 재연결 미적재(BATCH-1·F-ST-G1) — [[huni/load-path#LP-GAP-3]].
- **[GAP-ST-3]** 떡메모지 page_rule 3/3/3 잡음 정리(BATCH-8·Q-ST-G/B) — [[#ST-DIM-002]].
- **[GAP-ST-4]** 가격 전 상품 적재(round-2 문구 미실행·prices 0행·BATCH-7) — [[huni/price-engine#PE-GAP-3]].

---

## Sources
- 큐레이션 팩: `_curation/pack-stationery.md`
- 정체/결함(C13, FRESH): `17_correctness/stationery/product-identity.md`·`correction-manifest.md`·`loadlogic-notes.md`·`live-diff.md`·`extraction-plan.md` + `_gate/stationery-gate.md`(GO·K0~K6 PASS·F-ST-G1/G2/G3 RESOLVED).
- 차원/BOM(C11): `15_domain-spec/stationery/product-bom.md`·`column-dictionary.md`·`mapping-info.md`·`domain-research-notes.md` + `15_domain-spec/booklet/`(동형 참조).
- 가격(B/C·round-2 미실행): `06_extract/stationery-l1.csv`(C29 inline 단가)·`stationery-l1-meta.csv`. **price-engine-ddl.md 인용 0(STALE).** booklet `mapping.md` L26 "✓"는 라이브 미확인(인용 금지·F-PB-1 동형).
- 위젯(D): `huni-widget/03_spec/data-contract.md`.
- 적재(A): `raw/webadmin/sql/`·`tools/load_master.py`(로직만).
- 메모리: `dbmap-correctness-audit-round13`·`dbmap-column-domain-loadspec-round11`·`dbmap-discount-authority`·`dbmap-schema-design-intent-first`.
- **STALE/v03 (인용 금지):** `00_schema/price-engine-ddl.md`([[huni/price-engine#PE-STALE]]); v03 입력 xlsx `prdmaster_full_migration_v03_20260518.xlsx`([[huni/load-path#LP-STALE]]); round-12 mapping-research 부재(권위=round-11+round-13); 라이브 오적재값 직접 단정(correction-manifest 미대조 시 — G-1·F-PB-1 교훈).
