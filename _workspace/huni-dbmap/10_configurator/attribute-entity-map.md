# 속성→엔티티 마스터 지도 (CPQ 옵션 레이어 L2 매핑) — round-6

> **목적:** 상품마스터 13시트의 **모든 옵션성 속성**에 대해 "어느 엔티티로 매핑하나"를 결정한다. 사용자 핵심 질문 "각 속성을 어디에 매핑하나"의 직접 답이며, 상품군 파일럿(별도 다음 단계)의 참조 권위다.
>
> **상태/이력** 작성 2026-06-07 · WIP · `dbm-option-mapper` 설계 산출. DB 미적재(실 INSERT/코드행/DDL = 인간 승인).
> **권위 입력(인용, 발명 금지):** `cpq-design.md`(설계 정본) · `00_schema/cpq-schema.md §2/§4`(라이브 트리거·design↔live 정합 권위) · `banner-walkthrough.md`·`postcard-walkthrough.md`(옵션 레이어 shape 실증) · `wowpress-option-model.md`(흡수 6축·입도 A~E) · `_workspace/huni-widget/02_analysis/cascade-rules.md`(RedPrinting 캐스케이드 6종) · `componenttype-mapping-matrix.md`(14 componentType UI) · `huni-goods-option-mapping.md`(굿즈 6축 매핑·오염 자재) · `06_extract/<slug>-l1.csv`(시트별 옵션성 컬럼) · `00_schema/ref-product-*.csv`(라이브 차원행 스냅샷, stale 주의).
> 식별자/테이블/컬럼/코드/JSONLogic = English, 설명 = Korean. 불확실 = `[CONFIRM]`.

---

## 1. 서론 — L1/L2 구분과 4개 타깃 엔티티

### 1.1 L1 ≠ L2 (가장 흔한 실패 방어)

- **L1 (차원 적재):** 엑셀 셀값 → 정규화 차원 테이블(`t_prd_product_sizes/materials/print_options/processes/bundle_qtys/sets/plate_sizes`) + 가격엔진(`t_prc_*`). **대부분 적재 완료**(round-2~GO분).
- **L2 (옵션 레이어):** 위에 얹는 레이어. **새 데이터를 적재하지 않는다.** `option_item`은 *이미 적재된 차원행을 가리키는 포인터*(polymorphic `ref_dim_cd` + `ref_key`)일 뿐, 차원 데이터를 복사하지 않는다. L2를 L1과 혼동(차원값을 option_items로 재적재)하는 것이 1차 실패모드 — 본 지도는 이를 경계한다.
- **대부분의 속성은 L1 차원행이면서 동시에 L2 옵션이다.** 차원행은 주문 가능한 값을 저장하고, option_group은 그것을 선택 가능하게(UI 노출) 만든다. → **둘 다 기록**한다.

### 1.2 4개 타깃 엔티티 (속성이 갈 수 있는 곳)

| 타깃 | 언제 | 예 |
|------|------|----|
| **Dimension table (L1)** | 물리/주문 가능한 축이 이미 모델됨 | 사이즈→sizes, 소재→materials, 도수→print_options, 공정→processes |
| **CPQ option layer (L2)** | 차원행에 대한 *사용자 선택*, 또는 택1/택N 그룹 | 가공 택일그룹, 추가옵션, 복합옵션(각목+끈) |
| **Price engine (t_prc_*)** | 선택 정체성이 아니라 가격을 결정 | 수량구간 단가, 면적 매트릭스, 판수 |
| **Constraint (JSONLogic)** | 교차축 규칙 | 자재→후가공 disable, 각목규격↔세로 정합, 사이즈 범위 |

### 1.3 verdict 스키마 (속성별 기록 항목)

각 속성 = `{primary entity, dimension table, option_group? + sel_typ, constraint?, WowPress 축 대응, RedPrinting 캐스케이드 대응, GAP?}`.

### 1.4 polymorphic ref_dim_cd 디스패치 (라이브 트리거 `fn_chk_opt_item_ref` — 정확히 일치)

| ref_dim_cd | 의미 | 차원 테이블 | ref_key1 | ref_key2 |
|------------|------|------------|----------|----------|
| `OPT_REF_DIM.01` | 사이즈 | t_prd_product_sizes | siz_cd | — |
| `OPT_REF_DIM.02` | 판형 | t_prd_product_plate_sizes | siz_cd | — |
| `OPT_REF_DIM.03` | 자재 | t_prd_product_materials | mat_cd | **usage_cd** |
| `OPT_REF_DIM.04` | 공정 | t_prd_product_processes | proc_cd | — |
| `OPT_REF_DIM.05` | 묶음수 | t_prd_product_bundle_qtys | bdl_qty::int | — |
| `OPT_REF_DIM.06` | **도수** | t_prd_product_print_options | **opt_id::int** (NOT clr_cd) | — |
| `OPT_REF_DIM.07` | 셋트 | t_prd_product_sets | sub_prd_cd | — |

> [HARD] 도수 = `opt_id`(설계 MISMATCH-1 정정, 라이브 반영). **8번째 addon ref_dim 없음** — add-on은 `templates`로 간다(option_items 아님). 권위 `cpq-schema.md §2`.

### 1.5 비옵션성 컬럼 (전 시트 공통 — 옵션 아님, 본 지도 대상 외)

전 상품시트 공통 비옵션 컬럼: `구분`·`ID`·`MES ITEM_CD`·`상품명`(=식별/메타), `파일사양_*`(블리드·작업사이즈·재단사이즈·파일명약어·출력파일·폴더 — **MES 생산용 파일메타**, 단 `출력용지규격`은 판형 L1이라 별도), `주문방법(필수)_업로드/편집기`(= POD 주문플로우, 시스템 경계 밖), `가격공식`·`추가가격`·`price`·`가격`(= 가격엔진 t_prc_*), `가이드파일`·`템플릿`·`디자인보유`(= 에디터 자산), `_anchor*`·`cell_meta_json`(= 추출 메타). **이들은 옵션성 속성이 아니므로 verdict 대상에서 제외**(단 §2에서 "판형"은 옵션 가능 차원으로 다룬다).

---

## 2. 시트별 옵션성 속성 인벤토리 × 타깃 엔티티

13시트를 6 패밀리로 묶는다: ① 디지털인쇄류(digital-print·sticker) ② 책자·포토북·캘린더(booklet·photobook·calendar·design-calendar) ③ 실사·아크릴 면적형(silsa·acrylic) ④ 굿즈·파우치·악세사리(goods-pouch·product-accessory) ⑤ 문구(stationery) ⑥ 비상품 보조(map·calc-formula-draft).

> 범례 — **PE**=primary entity. sel_typ: 01=단일(택1)/02=다중(택N). C?=constraint 필요. WP=WowPress 축. Red=캐스케이드 대응. GAP은 §4 등록.

### 패밀리 ① — 디지털인쇄류 (digital-print 36 · sticker 16)

권위 워크스루: `postcard-walkthrough.md`(프리미엄엽서 PRD_000016, digital-print 소속). digital-print가 옵션 표현력이 가장 풍부(별색 다중·후가공 다중·박/형압 composite·봉투 add-on).

| 속성(L1 컬럼) | PE | 차원 테이블 | option_group? sel_typ | constraint? | WP 축 | Red 캐스케이드 | GAP |
|---|---|---|---|---|---|---|---|
| `사이즈(필수)` | L1 사이즈 | t_prd_product_sizes | Y · OG-SIZE 01 mand | — | 규격 sizeinfo | size 제약(CUT/WRK) | — |
| `판수` | **Price engine** | (size 부속속성) | N | R-QTY-PANSU(수량=판수 배수) | — | quantity 제약 | GAP-PANSU(§4) |
| `파일사양_출력용지규격` | L1 판형 | t_prd_product_plate_sizes | (보통 미노출) `.02` | — | — | base 제약 | — |
| `종이(필수)` | L1 자재 | t_prd_product_materials | Y · OG-JONGI 01 mand | — | 재질 paperinfo | material→pcs disable | (엽서 `*별도설정`=0행 GAP-DEFER §4) |
| `인쇄(옵션)`(단/양면) | L1 도수 | t_prd_product_print_options | Y · OG-DOSU 01 mand | — | 도수 colorinfo | dosu↔bnc 매핑 | — |
| `별색인쇄_화이트/클리어/핑크/금색/은색` | L1 공정(별색) | t_prd_product_processes (PROC_000007 family) | Y · OG-BYEOLSAEK **02** (max_sel 5) | 별색×도수 호환 | 도수 colorinfo(별색) | — | 별색=공정(clr_cd=NULL) |
| `코팅(옵션)` | L1 공정 | t_prd_product_processes | Y · OG-COATING 01 | 자재→코팅 disable | 후가공 awkjobinfo | **material→pcs disable** | — |
| `커팅(옵션)` | L1 공정 | t_prd_product_processes | Y · OG-CUTTING 01 | — | 후가공 | — | — |
| `접지(옵션)` | L1 공정 | t_prd_product_processes | Y · OG-FOLD 01 | — | 후가공 | — | — |
| `후가공_모서리`(직각/둥근) | L1 공정 | t_prd_product_processes (027/028) | Y · OG-MOSEORI 01 | — | 후가공 | — | — |
| `후가공_오시/미싱`(0~3줄) | L1 공정 + **param** | t_prd_product_processes (029/030) | Y · OG-HUGAGONG **02** (max_sel 4) | R-HUGA-PARAM(줄수 0~3) | 후가공 namestep2 | — | **GAP-PARAM**(줄수 보존, §4) |
| `후가공_가변(텍스트/이미지)`(0~3개) | L1 공정 + **param** | t_prd_product_processes (031/032) | Y · OG-HUGAGONG **02** | R-HUGA-PARAM(개수 0~3) | 후가공 namestep2 | — | **GAP-PARAM** |
| `박/형압_박/형압 가공` | L1 공정 (composite) | t_prd_product_processes (033 박 / 050 형압) | Y · OG-BAK 01 | 박색상⊂박 계층종속 | 후가공 | — | **GAP-COMPOSITE**(계층종속 표현, §4) |
| `박/형압_크기` | L1 공정 param | (PROC_000033 {크기}) | — | 박크기→등급(앱계산) | — | — | **GAP-PARAM** |
| `박/형압_박칼라`(16종) | L1 공정 (박 자식) | t_prd_product_processes (박색상 16종) | Y · 박그룹 내 01 | 박 선택 시만 활성 | — | — | (max-N 진짜상한 GAP-A 후보) |
| `추가상품_추가상품`(봉투류) | **L2 add-on** | t_prd_templates (=SKU) | Y · OG-CHUGA 01 | — | 부자재 prodaddinfo | — | (template_selections로 siz freeze) |
| `조각수(옵션)`(sticker) | L1 공정 + param | t_prd_product_processes (조각/도무송) | Y · OG-JOGAK 01 | — | 후가공 namestep2 | — | **GAP-PARAM**(조각수 N) |
| `제작수량_최소/최대/증가` | **products 범위** | t_prd_products(MIN/MAX/INCR) | N (옵션 아님) | — | ordqty | **quantity 제약** | — |
| `제작수량_건수(옵션)` | products 범위 | t_prd_products | N | — | ordqty | quantity 제약 | — |

**핵심 verdict:** ① 단/양면=**도수(opt_id, NOT clr_cd)**, 별색=**공정(PROC_000007 다중, clr_cd=NULL)** — 둘 다 "인쇄 색상"이나 환원 경로가 print_option↔process로 갈림(postcard §5.2(a)). ② 후가공 4종(오시·미싱·가변텍스트·가변이미지)=**SEL_TYPE.02 다중 한 그룹**(L1 동시선택 실증). ③ 박/형압=composite(박가공+박색상[계층종속]+형압[별트리])(postcard §5.2(c) 정정). ④ 추가상품(봉투)=**add-on template**(option_items 아님), template_selections가 siz_cd freeze(postcard GAP-3 CLOSED).

### 패밀리 ② — 책자·포토북·캘린더 (booklet 12 · photobook 1 · calendar 5 · design-calendar 5)

내지/표지 2축(booklet·photobook·stationery) — WowPress `coverinfo`(covercd 스코프)와 동형. 후니는 **차원행을 내지/표지 2벌로 적재**(예 `내지종이`·`표지종이`)하고 option_group을 분리한다(coverinfo 스코프를 option_group 분할로 표현). **제본 택일그룹은 라이브 적재 실증**(GRP-BOOK-제본, cpq-schema §1.5).

| 속성(L1 컬럼) | PE | 차원 테이블 | option_group? sel_typ | constraint? | WP 축 | Red 캐스케이드 | GAP |
|---|---|---|---|---|---|---|---|
| `사이즈(필수)` | L1 사이즈 | t_prd_product_sizes | Y · 01 mand | — | 규격 | size 제약 | — |
| `내지종이`/`표지종이`(필수) | L1 자재 | t_prd_product_materials | Y · 내지·표지 **각 01** mand | — | 재질(coverinfo 스코프) | material→pcs disable | — |
| `내지인쇄`/`표지인쇄`(필수) | L1 도수 | t_prd_product_print_options | Y · 각 01 mand | dosu↔bnc | 도수(coverinfo 스코프) | **dosu↔bnc 매핑**(내지/표지 색도) | — |
| `내지페이지_최소/최대/증가` | **products/page_rule** | t_prd_product_page_rules | N (counter-input) | R-PAGE(범위·step) | ordqty(내지면) | **quantity 제약**(MIN/MAX/STEP innerPage) | — |
| `표지코팅`/`투명커버`(옵션) | L1 공정 | t_prd_product_processes | Y · 01 | 자재→코팅 disable | 후가공 | material→pcs disable | — |
| `박(표지)/형압_가공·크기·박칼라` | L1 공정 composite | t_prd_product_processes (033/050) | Y · 01 | 박색상⊂박 | 후가공 | — | **GAP-COMPOSITE·GAP-PARAM** |
| `제본(필수)` | **L2 택일그룹** | t_prd_product_processes (제본 공정) | Y · **GRP-BOOK-제본 01**(excl 흡수) | — | 후가공 | **pcs essential**(제본 필수) | (excl_group 마이그 실증=라이브 해소) |
| `제본_제본방향`(옵션) | L1 공정 param | t_prd_product_processes | Y · 01 | — | 후가공 | — | **GAP-PARAM**(좌철/상철) |
| `제본_면지`(옵션) | L1 자재 or 공정 | t_prd_product_materials/processes `[CONFIRM]` | Y · 01 | — | 재질/후가공 | — | `[CONFIRM]` 면지=자재 vs 공정 |
| `제본_링컬러`(옵션) | L1 공정 (링컬러) | t_prd_product_processes | Y · 01 (mini-color-chip UI) | 링제본일 때만 | — | dosu↔bnc류 | (color-chip: hex 보유 시 §3) |
| `제본_바인더링`(옵션) | L1 공정/셋트 | t_prd_product_processes/sets `[CONFIRM]` | Y · 01 | — | 부자재 | — | `[CONFIRM]` |
| `표지타입(필수)`(photobook) | **L2 택일** | t_prd_product_processes or option | Y · 01 mand | 표지타입→제본 호환 | — | dosu↔bnc류 | — |
| `제본사양_책등`(photobook) | L1 공정 param | t_prd_product_processes | Y · 01 | 책등=페이지수 함수 | — | quantity 연동 | **GAP-PARAM** |
| `캘린더가공(필수)`(calendar) | **L2 택일그룹** | t_prd_product_processes | Y · **GRP-CAL-가공 01**(excl 흡수) | — | 후가공 | pcs essential | (라이브 마이그 실증) |
| `캘린더가공_삼각대컬러`/`링칼라` | L1 공정/자재 | t_prd_product_processes | Y · 01 (color-chip) | 가공종류 의존 | — | — | (hex 보유 시 color-chip §3) |
| `장수(필수)`(calendar) | products 범위/page_rule | t_prd_product_page_rules | N | R-PAGE | ordqty | quantity 제약 | — |
| `개별포장(옵션)` | **L2 옵션그릇 or 묶음수** | (GAP-OPT 후보) | Y · 01 | — | optioninfo 포장 | — | **GAP-OPT**(§4) |
| `제작수량_최소/최대/증가` | products 범위 | t_prd_products | N | — | ordqty | quantity 제약 | — |
| `추가상품_추가상품` | L2 add-on | t_prd_templates | Y · 01 | — | 부자재 | — | — |

**핵심 verdict:** ① 내지/표지 2축 = **차원행 2벌 + option_group 분리**(coverinfo 스코프). ② 제본·캘린더가공 = **택일그룹(GRP-BOOK/GRP-CAL, excl_groups 흡수)** — 라이브 적재 실증(GAP-2가 여기서 해소). ③ 내지페이지·장수 = **page_rule/products 범위(counter-input)**, 옵션 아님. ④ 링컬러/삼각대컬러 = 색 hex 보유 시 color-chip 계열(componentType matrix D-2/D-3).

### 패밀리 ③ — 실사·아크릴 면적형 (silsa 29 · acrylic 25)

권위 워크스루: `banner-walkthrough.md`(일반현수막 PRD_000138). 비규격(사용자입력) 사이즈 + 면적형 가격. 복합옵션(각목+끈) polymorphic 실증.

| 속성(L1 컬럼) | PE | 차원 테이블 | option_group? sel_typ | constraint? | WP 축 | Red 캐스케이드 | GAP |
|---|---|---|---|---|---|---|---|
| `사이즈(필수)`(규격) | L1 사이즈 | t_prd_product_sizes | Y · OG-SIZE 01 | — | 규격 | size 제약 | — |
| `비규격(최소/최대)_가로/세로` | **products 범위 + constraint** | t_prd_products(nonspec_w/h_min/max) | N (사이즈그룹=규격/입력 토글) | **R-SIZE-NONSPEC**(범위) | 규격 req_w/h | size 제약(비표준 허용) | (banner §5.2(c): nonspec≠이산옵션) |
| `소재(필수)` | L1 자재 | t_prd_product_materials | Y · OG-SOJAE 01 mand | — | 재질 | material→pcs disable | — |
| `인쇄사양`(acrylic) | L1 도수/공정 | t_prd_product_print_options/processes `[CONFIRM]` | Y · 01 | — | 도수 | — | `[CONFIRM]` 양면/단면 도수 |
| `조각수(옵션)`(acrylic) | L1 공정 + param | t_prd_product_processes | Y · 01 | — | 후가공 namestep2 | — | **GAP-PARAM**(조각수 N) |
| `가공_가공`(옵션) | **L2 택일그룹** | t_prd_product_processes (079 타공/080 봉제/081 부착/053 완칼) | Y · OG-GAGONG 01 mand | — | 후가공 | — | (열재단→053 미적재 GAP-DEFER) |
| `가공`내 타공(4/6/8개) | L1 공정 + **param** | t_prd_product_processes (079, `{구수:N}`) | (한 그룹 내 옵션 3개, 1 공정행 재사용) | — | 후가공 namestep2 | — | **GAP-PARAM**(구수 N — 핵심) |
| `추가_추가`(끈/큐방/각목) | **L2 복합옵션** | process(끈/큐방=부착 081) + set(각목) | Y · OG-CHUGA 01 | **R-GAKMOK-HEIGHT**(각목규격↔세로) | 부자재/후가공 | — | (각목 코드 `[CONFIRM]`·큐방 enum 확장) |
| `추가상품_추가상품`(거치대) | L2 add-on | t_prd_templates | Y · 01 | — | 부자재 prodaddinfo | — | (거치대 base_prd `[CONFIRM]`) |
| `제작수량_최소/최대/증가` | products 범위 | t_prd_products | N | — | ordqty | quantity 제약 | — |
| 가격(면적 매트릭스) | **Price engine** | t_prc_* (면적매트릭스형) | N | 비가격조합=주문불가 | 동적견적 | **제약 최종판정=가격엔진** | — |

**핵심 verdict:** ① 비규격 사이즈 = **products 범위 + constraint**(연속수치, option_items로 열거 불가 — banner §5.2(c)). 사이즈그룹은 [규격행/사용자입력 토글]만. ② 가공 = **택일그룹**, 타공 4/6/8개 = **공정 1행 + param{구수:N}**(공정 마스터 비대화 방지 — polymorphic+param 핵심 이득). ③ 복합 "각목+끈" = **item_seq 2행**(끈=공정081, 각목=셋트) — polymorphic이 이종 차원 결합 표현. ④ 면적형 가격 = price engine, 비가격조합=주문불가(WowPress 규칙 E·RedPrinting "제약 최종판정=가격엔진").

### 패밀리 ④ — 굿즈·파우치·악세사리 (goods-pouch 103 · product-accessory 15)

권위: `huni-goods-option-mapping.md`(오염 자재 재분류 + WowPress 6축). 자재 마스터 오염(색/형상/사이즈/구수가 자재로 ~120행) → 5축 재배선.

| 속성(L1 컬럼 / 오염자재) | PE | 차원 테이블 | option_group? sel_typ | constraint? | WP 축 | Red 캐스케이드 | GAP |
|---|---|---|---|---|---|---|---|
| `사이즈(필수)` | L1 사이즈 | t_prd_product_sizes | Y · 01 | — | 규격 | — | — |
| 형상(원형/하트/별 — 오염 MAT) | L1 사이즈 (**형상→규격 융합**) | t_prd_product_sizes (siz_nm에 형상) | Y · 01 (image-chip UI) | — | 규격 sizeinfo(형상융합) | — | **GAP-SHAPE**(비치수 siz, §4) |
| 사이즈+방향(가로L/세로M — 오염 MAT) | L1 사이즈 (**방향→규격 융합**) | t_prd_product_sizes | Y · 01 | — | 규격(40479 에코백) | — | — |
| 용량(11온스 — 오염 MAT) | L1 사이즈 (**용량→규격**) `[CONFIRM]` | t_prd_product_sizes | Y · 01 | — | 규격 후보 | — | **GAP-SHAPE**(비치수 siz) |
| 본체색(파우치 블랙/머그 화이트 — 자재) | L1 자재 (**본체색→재질행 합성**) | t_prd_product_materials | Y · 01 (color-chip UI) | — | 재질 paperinfo(본체색융합) | — | (파우치는 이미 정답 패턴) |
| 잉크색(만년스탬프 검정/빨강 — 오염 MAT) | L1 도수 **vs** 옵션그릇 `[CONFIRM]` | t_prd_product_print_options vs GAP-OPT | Y · 01/02 | — | 도수 vs optioninfo | — | **설계 결정 필요**(§ ambiguous) |
| 구수(1구~4구 — 오염 MAT) | L1 공정 + param (**개수형 공정**) | t_prd_product_processes | Y · 01 | — | 후가공 namestep2 | — | **GAP-PARAM/GAP-COUNT**(구수 N) |
| `선택(옵션)_선택`(goods-pouch) | **L2 옵션그릇** `[CONFIRM]` | (자유옵션 — GAP-OPT 후보) | Y · 01 | — | optioninfo | — | **GAP-OPT**(§4) |
| `가공(옵션)_가공` | L1 공정 | t_prd_product_processes | Y · 01 | — | 후가공 | — | — |
| `포장/N개팩`(OPP봉투·N개1팩) | **L2 묶음수 or 옵션그릇** | t_prd_product_bundle_qtys vs GAP-OPT | Y · 01 | — | optioninfo/묶음수 | — | **GAP-OPT**(자유포장) |
| `추가상품_추가상품` | L2 add-on / 셋트 | t_prd_templates / t_prd_product_sets | Y · 01 | — | 부자재 | — | — |
| `구간할인적용테이블` | **Price engine** | t_dsc_* (round-1 적재) | N | — | — | — | — |
| `사이즈(필수)`(accessory) | L1 사이즈 | t_prd_product_sizes | Y · 01 | — | 규격 | — | — |
| `수량(필수)_최소/최대/증가`(accessory) | products 범위 | t_prd_products | N | — | ordqty | quantity 제약 | — |

**핵심 verdict (WowPress 흡수 — "과분할 금지"의 구체형):** ① **본체색=재질행 합성**(split 금지 — "빨간 파우치"="파우치원단(빨강)" 1행, 파우치는 이미 정답). ② **형상/방향=규격 융합**(별도 형상축 신설 금지 — 원형=siz 1행). ③ **잉크색·인쇄면=도수**(본체색과 의미 다름) — 단 만년스탬프 잉크색은 도수 vs 옵션그릇 **설계 결정 필요**(아래 ambiguous). ④ **구수=개수형 공정+param**. ⑤ product-accessory는 옵션 거의 없음(사이즈·수량만) — 부자재 셋트 후보.

### 패밀리 ⑤ — 문구 (stationery 12)

내지/표지 2축(책자류와 동형) + `구간할인적용테이블`.

| 속성(L1 컬럼) | PE | 차원 테이블 | option_group? sel_typ | constraint? | WP 축 | Red 캐스케이드 | GAP |
|---|---|---|---|---|---|---|---|
| `사이즈(필수)` | L1 사이즈 | t_prd_product_sizes | Y · 01 | — | 규격 | size 제약 | — |
| `내지(옵션)`/`종이(옵션)` | L1 자재 | t_prd_product_materials | Y · 내지 01 | — | 재질(coverinfo) | material→pcs disable | — |
| `내지인쇄사양` | L1 도수 | t_prd_product_print_options | Y · 01 | dosu↔bnc | 도수 | dosu↔bnc | — |
| `페이지사양_최소/최대/증가` | products/page_rule | t_prd_product_page_rules | N (counter-input) | R-PAGE | ordqty | quantity 제약 | — |
| `표지사양`/`표지인쇄사양` | L1 자재·도수 | t_prd_product_materials/print_options | Y · 표지 01 | — | 재질·도수(coverinfo) | — | — |
| `제본옵션(옵션)`/`제본사양` | **L2 택일그룹** | t_prd_product_processes (제본) | Y · GRP 01 | — | 후가공 | pcs essential | (excl 흡수) |
| `개별포장(옵션)` | L2 옵션그릇 | GAP-OPT 후보 | Y · 01 | — | optioninfo | — | **GAP-OPT** |
| `구간할인적용테이블` | Price engine | t_dsc_* | N | — | — | — | — |
| `제작수량_최소/최대/증가` | products 범위 | t_prd_products | N | — | ordqty | quantity 제약 | — |

**핵심 verdict:** 책자류와 동일 패턴(내지/표지 2축·제본 택일그룹·page_rule). `개별포장`=GAP-OPT.

### 패밀리 ⑥ — 비상품 보조 (map · calc-formula-draft)

`product-info-foundation.md §1`: MAP(카테고리×상품 매핑) = **`t_prd_product_categories`(라이브 274행 적재)** 대상이지 옵션 레이어 아님. 계산공식집초안 = **가격엔진(t_prc_*)** 텍스트 권위, 옵션 아님. **둘 다 본 옵션 지도 대상 외**(verdict 없음).

---

## 3. 교차절단 결정 규칙 (재사용 — 시트별 아님)

### 3.1 흡수 vs 분할 입도 (WowPress 규칙 A~E — "과분할 금지"의 구체형)

| 후니 속성 | 결정 | 근거(WowPress) | 후니 적용 (ref_dim_cd) |
|-----------|------|----------------|------------------------|
| **본체색** (파우치 블랙, 머그 화이트, 에코백 천색) | **COMPOSE — 재질행 1행** | 규칙 A·B: 소재+본체색=한 재질행 | `OPT_REF_DIM.03` mat_cd 합성. **색 독립축 신설 금지** |
| **형상** (원형/하트/별) | **COMPOSE — 규격 융합** | 규칙 B: sizeinfo에 형상 융합(40185) | `OPT_REF_DIM.01` siz_nm에 형상. **형상축 신설 금지** |
| **사이즈+방향** (가로L/세로M) | **COMPOSE — 규격 1행** | 규칙 A: 함께 고르는 물리속성(40479) | `OPT_REF_DIM.01` siz_nm="가로형 L" |
| **인쇄면** (단/양면), **잉크 도수** | **SPLIT — 도수축** | 규칙 B: 인쇄 면/잉크=colorinfo | `OPT_REF_DIM.06` opt_id |
| **별색** (화이트~은색) | **SPLIT — 공정축(다중)** | 인쇄 색상이나 도수와 별 모델 | `OPT_REF_DIM.04` proc_cd(PROC_000007 family, clr_cd=NULL) |
| **구수/개수** (1구~4구, 타공 N, 조각수) | **SPLIT — 개수형 공정 + param** | 규칙 C: awkjob namestep2 개수형 | `OPT_REF_DIM.04` + 개수 param(→GAP-PARAM) |
| **용량** (11온스/350ml) | **COMPOSE — 규격** `[CONFIRM]` | 머그 직접대응 없음, 물리사양=규격 | `OPT_REF_DIM.01` 비치수 siz(→GAP-SHAPE) |
| **포장/구성** (OPP봉투, N개팩, 개별포장) | **묶음수 or 옵션그릇** | optioninfo flat / 묶음수 | `.05` bdl_qty 또는 GAP-OPT |
| **추가상품** (봉투, 거치대) | **add-on template** (option_item 아님) | 부자재 prodaddinfo | `t_prd_templates` + template_selections |

> 한 줄 지침: **함께 고르는 물리 속성은 한 행으로 합성하라(소재+본체색=재질, 형상+치수+방향=규격). 색을 무조건 분리하지 말 것 — 본체색은 재질, 잉크색/인쇄면만 도수, 별색은 공정.**

### 3.2 도수/별색/색 hex의 3분기 (componentType matrix 정합)

UI 측면에서 "색"은 4갈래로 갈린다(`componenttype-mapping-matrix.md` ②5종 색계열):
- **단/양면(도수)** = `OPT_REF_DIM.06` print_option → UI `option-button`.
- **별색(인쇄)** = `OPT_REF_DIM.04` process(다중) → 색 hex 보유 시 `large-color-chip`(별색 팔레트), 없으면 `finish-button`.
- **링컬러/삼각대컬러/박칼라(부자재·후가공 색)** = `OPT_REF_DIM.04` process → 색 hex 보유 시 `mini/color-chip`.
- **본체색(블랭크)** = `OPT_REF_DIM.03` 재질행 합성 → `color-chip`(mat 색) 또는 `select-box`.
> [HARD·componentType matrix §4] color-chip/mini/large-color-chip/image-chip은 **후니 데이터에 colorHex/imageUrl이 실재할 때만** 살아난다(Red 데이터 0). 옵션 마스터 수령 시 "어떤 옵션이 hex/url을 갖는가"를 먼저 확인해야 부활 여부 결정.

### 3.3 캐스케이드 → constraint (RedPrinting 6종 → JSONLogic)

| Red 캐스케이드 | 후니 표현 | rule_typ_cd | 비고 |
|----------------|-----------|-------------|------|
| **material→pcs disable** | constraint(forbidden) JSONLogic | RULE_TYPE.02 | 저평량·비코팅 자재 선택 시 코팅/후가공 일괄 disable(PRBKYPR 24건) |
| **dosu↔bnc 매핑** | constraint(required/compatible) | RULE_TYPE.03/.01 | 도수→제본그룹·내지/표지 색도(SID_S 단면4 / SID_D 양면8) |
| **size 제약** | constraint(compatible) + products nonspec 범위 | RULE_TYPE.01 | 규격 CUT/WRK·비표준 허용(R-SIZE-NONSPEC) |
| **quantity 제약** | **t_prd_products** MIN/MAX/INCR/STEP 컬럼 | (옵션 아님) | 수량·내지페이지 범위 — products/page_rule, constraint 아님 |
| **pcs essential/hidden** | option_groups.mand_yn + (hidden=GAP) | — | 필수 자동적용(ESN_YN=Y)·미표시(VIEW_YN=N)=**GAP-HIDDEN**(§4) |
| **base 제약** | t_prd_products / t_siz_sizes margin | — | 단위·재단마진·최소/최대 |

> JSONLogic rule은 `t_prd_product_constraints.logic`에 행단위 저장 → 활성행 AND-compile → `t_prd_products.constraint_json`(POD `json-logic-js`·백엔드 `json-logic-py` 동일평가). **최종 가격유효성 = 가격엔진**(비가격조합=주문불가, WowPress 규칙 E·RedPrinting §6.4 line594). enumerate 제약테이블로 모든 불가조합을 닫으려 들지 않는다.

### 3.4 수량/페이지는 옵션이 아니다 (반복 패턴)

`제작수량_최소/최대/증가`·`내지페이지`·`장수`는 전 시트에서 **products/page_rule 범위 컬럼**(counter-input/page-counter-input), option_group이 아니다. RedPrinting quantity 제약(MIN/FIR/INC/STEP)과 정합. 다만 **판수**(digital-print)는 size 부속속성이면서 가격엔진 입력 → GAP-PANSU.

---

## 4. GAP 레지스터 (→ `cpq-option-gaps.md`, dbm-ddl-proposer)

본 지도가 발굴/집약한 라이브 GAP 전건은 별도 파일 `10_configurator/cpq-option-gaps.md`에 등록한다(dbm-ddl-proposer 입력). 요약:

| GAP | 내용 | 영향 | 라이브 권위 | 상태 |
|-----|------|------|------------|------|
| **GAP-PARAM** | 공정 파라미터(타공 구수·오시/미싱 줄수·가변 개수·조각수·박크기) 보존 컬럼 부재 = `ref_param_json` 미구현 | 후가공·박·조각수 다수 | cpq-schema §4 🔴8 | 신규 컬럼 vs qty 재사용 — ddl-proposer |
| **GAP-HIDDEN** | hidden-essential(ESN_YN=Y/VIEW_YN=N 자동적용·미표시) 플래그 부재 | 재단 CUT_DFT 등 | cascade-rules §5 | option_groups에 auto-apply hidden 플래그 |
| **GAP-OPT** | 포장/각인/자유옵션(WowPress optioninfo) 대응 차원 부재 | 개별포장·선택·잉크색팩 | huni-goods §5.2 | 신규 OPT_REF_DIM vs 전용테이블 vs bdl_qty |
| **GAP-SHAPE** | 비치수 형상/용량(원형/별/11온스)을 siz 등록 시 width/height 부재 | 굿즈 형상·용량 | round-5 11_ddl_proposals | siz width/height NULL 허용 vs 형상 enum |
| **GAP-COUNT** | 개수형 공정의 개수 N(1구~4구) 보존 — GAP-PARAM의 굿즈 특수형 | 키캡키링·구수 | huni-goods §5.2 | GAP-PARAM과 통합 |
| **GAP-COMPOSITE** | 복합옵션 항목 간 관계(AND동반/계층종속 박색상⊂박) 표현 부재 | 박/형압·각목+끈 | banner §5.2(b)·postcard §5.2(c) | item_combine_typ/parent_item_seq |
| **GAP-DEFER** | "별도설정" 종이·미적재 공정(열재단 053·후가공 029~032)을 옵션 등록 시 EXISTS 트리거 위반 | 엽서 종이·후가공 다수 | banner GAP-5·postcard GAP-5 | 차원 선적재 vs deferred 센티넬(mat_cd=NULL) |
| **GAP-PANSU** | 판수(사이즈별 판걸이)=가격축이나 차원 7종에 전용축 없음 | digital-print 전반 | postcard §5.2(b) | size 부속속성(이미 결정) — 가격엔진 입력 |

> [HARD] 8건 전부 **발명 금지·플래그만**. search-before-mint(사다리: 코드행<컬럼<JSONB<테이블)는 dbm-ddl-proposer 소관.

---

## 5. 설계 결정 필요 (ambiguous — 침묵 선택 금지)

타깃이 진짜 모호한 속성은 양 후보를 증거와 함께 제시하고 사용자/도메인 확정을 요청한다.

### 5.1 잉크색(만년스탬프 검정/빨강/…) = 도수 vs 자유옵션그릇

- **후보 A — 도수축(`OPT_REF_DIM.06` print_option):** WowPress 규칙 B "잉크색=colorinfo(도수)". 인쇄 잉크 색상이므로 도수 성격.
- **후보 B — 자유옵션그릇(GAP-OPT):** 만년스탬프 잉크는 인쇄 도수(front_colrcnt CMYK)와 결이 다르다(스탬프 잉크 자체 선택, 인쇄 도수 아님). WowPress `optioninfo`(기타 가공) 성격이 더 맞을 수 있음.
- **증거:** `huni-goods-option-mapping.md §2.2` — "엄밀히는 GAP-OPT가 더 맞을 수 있음, 후니 도메인 확인 필요". 리필잉크(PRD_000015)는 별도 상품(부자재)이라 잉크색 7종은 그 상품 옵션 or `t_prd_product_sets`.
- **판정:** **DESIGN DECISION NEEDING CONFIRMATION** — 침묵 선택 안 함.

### 5.2 용량(머그 11온스) = 비치수 size vs 규격

- **후보 A — 규격(`OPT_REF_DIM.01` 비치수 siz):** 물리 사양=규격(WowPress 구조상 sizeinfo 후보). width/height 대신 용량라벨.
- **후보 B — 별도 사양축:** 용량은 부피라 width/height 없음 → GAP-SHAPE(비치수 siz) 발생. 형상(원형/별)과 동류로 묶을지, 별 컬럼(volume)을 둘지 미정.
- **증거:** `huni-goods-option-mapping.md §2.3` — "WowPress엔 머그 직접대응 없음, 구조상 규격 후보". round-5 11_ddl_proposals 'goods 비치수 size'로 이미 식별.
- **판정:** **DESIGN DECISION NEEDING CONFIRMATION** — GAP-SHAPE 처리 방식(siz width/height NULL 허용 vs 형상/용량 enum 컬럼)이 ddl-proposer 결정에 종속.

### 5.3 면지·바인더링(booklet) = 자재 vs 공정/셋트

- **후보 A — 자재(`OPT_REF_DIM.03`):** 면지는 종이(물리 소재).
- **후보 B — 공정/셋트(`OPT_REF_DIM.04/.07`):** 제본 부속이라 공정 또는 동반 셋트.
- **증거:** L1 `제본_면지(옵션)`·`제본_바인더링(옵션)` 컬럼만 존재, 라이브 차원행 정체 `[CONFIRM]` 미확인.
- **판정:** **`[CONFIRM]`** — 라이브 차원행 정체 확인 후 확정(dbm-schema-analyst 조회 필요).

---

## 6. 파일럿 권고 (다음 단계 — 리드가 사용자 확정)

상품군 파일럿은 본 지도를 실행으로 입증하는 별도 단계다. 후보 2-3개:

| 우선 | 상품군 | 근거 | 행사하는 ref_dim 축 | 닫는 GAP |
|:----:|--------|------|---------------------|----------|
| **1 (권장)** | **digital-print (프리미엄엽서 PRD_000016)** | postcard-walkthrough 검증완료(CONDITIONAL-GO). 옵션 표현력 최대 — 도수·별색·후가공 다중·박/형압 composite·봉투 add-on 전부 보유 | .01 사이즈·.03 자재·.04 공정·.06 도수 + add-on template | GAP-1(다중) CLOSED·GAP-3(복합 add-on) CLOSED·GAP-PARAM·GAP-DEFER 노출 |
| **2** | **silsa (일반현수막 PRD_000138)** | banner-walkthrough 검증완료(CONDITIONAL-GO). 비규격 사이즈 + 복합옵션(각목+끈 polymorphic 2행) + 면적형 가격 | .01 사이즈·.03 자재·.04 공정·.07 셋트 | nonspec 이원성·복합옵션·GAP-PARAM(구수) 실증 |
| **3** | **goods-pouch (말랑키링/머그/만년스탬프)** | 오염 자재 재분류·WowPress 흡수 원칙·GAP-SHAPE/OPT/COUNT 총집결. 형상→규격·본체색→재질·잉크색 ambiguous를 한 상품군에서 행사 | .01 사이즈(형상)·.03 자재(본체색)·.04 공정(구수)·.05 묶음수 | GAP-SHAPE·GAP-OPT·GAP-COUNT 노출·잉크색 ambiguous 해소 트리거 |

> **권고:** 파일럿 1=digital-print(엽서)부터. 이미 walkthrough 검증완료라 master map 정합을 즉시 입증하고, GAP-PARAM(공정 파라미터)·GAP-DEFER(차원 선적재)라는 가장 광범위한 GAP을 행사한다. ②책자류(제본 택일그룹·내지/표지 2축)는 라이브 excl_group 마이그 실증(GAP-2 해소)을 잇는 후보로 4순위. **excl_group 마이그레이션 실증(GAP-2)은 두 walkthrough 모두 미행사 — 책자/캘린더 파일럿이 별도로 닫아야 함.**

---

## 부록 — 패밀리별 시트 매핑 + 옵션성 컬럼 출처

| 패밀리 | 시트(slug) | 고유 prd_nm | 권위 walkthrough | l1.csv 옵션성 컬럼 출처 |
|--------|-----------|:----:|------------------|------------------------|
| ① 디지털인쇄류 | digital-print·sticker | 36·16 | postcard-walkthrough | 사이즈/판수/종이/인쇄/별색5/코팅/커팅/접지/후가공4/박3/조각수/추가상품 |
| ② 책자·캘린더 | booklet·photobook·calendar·design-calendar | 12·1·5·5 | (excl_group 라이브 실증) | 내지·표지 2축/제본/캘린더가공/링컬러/페이지/장수/개별포장 |
| ③ 면적형 | silsa·acrylic | 29·25 | banner-walkthrough | 사이즈/비규격가로세로/소재/인쇄사양/조각수/가공/추가(끈/각목)/추가상품 |
| ④ 굿즈 | goods-pouch·product-accessory | 103·15 | huni-goods-option-mapping | 사이즈/선택/가공/추가상품/구간할인 + 오염자재(형상/색/구수/방향) |
| ⑤ 문구 | stationery | 12 | (책자류 동형) | 내지·표지 2축/제본옵션/페이지/개별포장/구간할인 |
| ⑥ 보조 | map·calc-formula-draft | — | (옵션 대상 아님) | 카테고리매핑(→categories)·가격공식(→t_prc_*) |

> 전 옵션성 컬럼은 `06_extract/<slug>-l1.csv` 헤더(그룹헤더 composite `그룹명_하위명`) 권위. 비옵션 컬럼(파일사양·주문방법·가격·가이드)은 §1.5 기준 제외.
