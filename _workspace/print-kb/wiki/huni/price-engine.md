# 가격엔진 (Price Engine) — 횡단 축

> huni 레이어(분석대상). 가격공식·구성요소·단가를 원자 항목으로 분리해 상품이 `priced-by`로 참조한다.
> 앵커: 라이브 `t_prc_*` 4단 구조(`t_prc_price_formulas`→`t_prc_price_components`→`t_prc_component_prices`) + `t_dsc_*`(구간할인) + `t_prd_template_prices`(SKU 직접단가).
> **[W3 라이브 실측] `pricing_dims`·`use_dims`는 라이브 테이블 아님**(`information_schema.tables LIKE '%dim%'` → 0행). `sql/21·22`는 **seed/init 스크립트**(테이블 생성 DDL 아님 — "DDL 선언 vs 라이브 미적용·미백필"). 가격 차원 컬럼의 라이브 실재 위치 = `t_prc_component_prices`(proc_cd·opt_cd·siz_cd 등) + 단가유형 `t_prc_price_components.prc_typ_cd`.
> **[HARD] 이 축은 가장 stale 위험이 크다.** 가격엔진 구조 인용은 **라이브 `t_prc_*` information_schema 실측 + webadmin `pricing-erd.md`만**. `00_schema/price-engine-ddl.md`는 **STALE — 인용 금지**(아래 [PE-STALE]).
> 큐레이션 팩: `_curation/axis-price-engine.md`.

---

## 1. 엔진 구조 (라이브 권위)

### [PE-001] t_prc_* 4단 구조 + 가격차원(8차원/자연키 10컬럼)  {🟡}
- 내용: 가격은 단가표가 아니라 **공식 엔진**이다. `t_prc_*` 4단(공식 → 구성요소 → 차원 → 단가)으로 전개하며, Phase11 기준 **가격차원 8차원(자연키 10컬럼)**, 차원 컬럼에 `proc_cd`·`opt_cd`·`prc_typ_cd`가 추가됐다. **[W3] 차원의 라이브 실재 위치 = `t_prc_component_prices`(proc_cd·opt_cd·siz_cd 등) + `t_prc_price_components.prc_typ_cd`** — `pricing_dims`/`use_dims`는 라이브 테이블이 아니라 seed/init 스크립트(헤더 [W3]).
- 앵커: `t_prc_*` 4단 · 차원 컬럼=`t_prc_component_prices`(proc_cd·opt_cd·siz_cd) + `t_prc_price_components.prc_typ_cd`
- 출처: 라이브 psql `information_schema`(t_prc_* 컬럼 실측) + `raw/webadmin/sql/21_pricing_dims.sql`·`sql/22_use_dims.sql`(seed/init) + `raw/webadmin/docs/prcx01-pricing-model.md`·`pricing-erd.md` {tier A, FRESH}
- 연결: [[#PE-002]] · [[load-path#LP-002]] (loaded-via — 적재 경로)
- 사용처: [[recipes/sticker#STK-PRC-002]] (uses — 스티커 가격 차원 컬럼) · [[recipes/calendar#CAL-PRC-001]] (uses — 캘린더 t_prc 4단·미연결) · [[recipes/acrylic#AC-PRC-002]] (uses — 아크릴 가격 차원 t_prc_*)
- answers_cq: CQ-PRICE-01 (단가표 vs 공식 계산) · CQ-PRICE-08 (견적 합산 공식)
- tags: #가격 #t_prc #차원 #Phase11 #W3

### [PE-002] 단가유형 prc_typ_cd (.01 단가형 / .02 합가형)  {🟡}
- 내용: Phase11 신설. **`.01 단가형`(장당가) / `.02 합가형`(구간총액 ÷ 환산)**. 단가형은 장당가×수량, 합가형은 구간 총액을 환산. **라이브 실측: `t_prc_price_components.prc_typ_cd` 144행 전부 .01(단가형)**(`SELECT prc_typ_cd,count(*) FROM t_prc_price_components` → PRICE_TYPE.01\|144)이라 합가형 식별은 미래 작업(GAP [PE-GAP-1]).
- 앵커: `t_prc_price_components.prc_typ_cd` (PRICE_TYPE 코드 — `pricing_dims` 아님, 라이브 부존재)
- 출처: 라이브 psql(`t_prc_price_components` 144행 .01 실측) + `18_schema-change/impact-diagnosis.md` I-2·§3 백필 {tier A, FRESH}
- 연결: [[#PE-001]] · [[#PE-GAP-1]]
- 사용처: _(레시피 집필 시 채움)_
- tags: #가격 #단가유형 #prc_typ_cd #합가형미식별 #W3

### [PE-003] 가격공식 PK = (prd_cd, apply_bgn_ymd)  {🟡}
- 내용: Phase11 통합 PK. 가격공식의 멱등 키는 **(prd_cd, apply_bgn_ymd)**. 구 PK(frm_cd/dsc_tbl_cd 포함) 가정한 ON CONFLICT는 충돌하므로 적재 SQL 갱신 필요([[load-path#LP-005]]).
- 앵커: 가격공식 PK (prd_cd, apply_bgn_ymd)
- 출처: `sql/18_unify_price_keys.sql` (impact-diagnosis I-7) {tier A, FRESH}
- 연결: [[load-path#LP-005]] · [[#PE-STALE]]
- 사용처: [[recipes/acrylic#AC-PRC-002]] (uses — 멱등 PK)
- tags: #가격 #PK #멱등 #I-7

### [PE-004] template 직접단가 (t_prd_template_prices)  {🟡}
- 내용: Phase11 신설 — SKU(템플릿) 직접단가 오버라이드 경로. **현재 0행(스키마만 존재)**. SKU별 고정가가 필요한 상품의 가격 오버라이드 자리.
- 앵커: `t_prd_template_prices` (0행)
- 출처: `sql/20_template_prices.sql` (impact-diagnosis I-4) {tier A, FRESH(스키마만)}
- 연결: [[cpq-options#CPQ-006]] (templates) · [[#PE-GAP-3]]
- 사용처: _(레시피 집필 시 채움)_
- tags: #가격 #template_prices #SKU #0행

---

## 2. 공식 유형 (후니 권위)

### [PE-005] 원자합산형 (디지털인쇄) PRF_DGP_A~F + 용지비  {🟡}
- 내용: 디지털인쇄 가격 = **원자 구성요소 합산**(인쇄비 + 용지비 + 공정비). 공식 6종 `PRF_DGP_A~F` + 용지비 `COMP_PAPER`. 라이브 308행 COMMIT(공식사슬 완결). 별색=공정([[processes#PRC-003]])이 합산 항목으로 들어온다.
- 앵커: `t_prc_price_formulas`(PRF_DGP_A~F) + COMP_PAPER
- 출처: `02_mapping/digital-print-engine/` {tier C, 공식사슬 FRESH·차원 컬럼 PARTIAL-STALE I-1·I-2}
- 연결: [[processes#PRC-003]] (uses — 별색=공정 합산 항목) · [[../base/paper#BPP-002]] (uses — 용지 평량)
- 사용처: [[recipes/digital-print#DGP-PR-001]] (priced-by — 디지털인쇄 원자합산형) · [[recipes/booklet#BK-PRC-001]] (priced-by — 책자 제본 합산형 PRF_BIND_SUM) · [[recipes/photobook#PB-PRC-001]] (priced-by — 포토북 page-band 합산형 PRF_PBK_PAGEBAND·미적재) · [[recipes/calendar#CAL-PRC-001]] (priced-by — 캘린더 원자합산형 디지털 계열·미적재)
- answers_cq: CQ-PRICE-03 (디지털인쇄 단가 매트릭스 구조) · CQ-PRICE-06 (후가공 가산 단가)
- tags: #가격 #합산형 #디지털인쇄 #PRF_DGP

### [PE-006] 면적매트릭스형 (실사·현수막·아크릴·포스터사인)  {🟡}
- 내용: **[세로][가로] 면적 매트릭스 + off-grid ceiling**(격자에 없는 크기는 한 단계 큰 크기 가격). 실사 가격은 자체 inline price가 아니라 **포스터사인 가격표 면적매트릭스** 권위([PE-STALE]의 좌표 회귀 모델 인용 금지).
- 앵커: `t_prc_component_prices`(siz 차원, [세로][가로]) + 면적공식 + ceiling
- 출처: `02_mapping/silsa-poster-area-matrix/` + `09_load/_migrate_areamatrix/` + 메모리 `dbmap-price-formula-types-authority`·`dbmap-silsa-price-via-poster-sign` {tier C, FRESH}
- 연결: [[../base/sizes#BSZ-003]] (uses — 출력판형 보편 정의) · [[#PE-STALE]]
- 사용처: [[recipes/acrylic#AC-PRC-001]] (priced-by — 아크릴 면적매트릭스·미러=투명×2)
- answers_cq: CQ-PRICE-05 (면적 기반 가로×세로 계산)
- tags: #가격 #면적매트릭스 #ceiling #포스터사인

### [PE-007] 고정가형 (수량×옵션)  {🟡}
- 내용: **수량×옵션 격자의 고정 단가** 룩업. round-2가 28 포스터를 전부 면적-좌표 회귀로 오모델 → 그중 **15개는 고정가형**이 정답(교정분 `_migrate_fixedprice/` 권위).
- 앵커: `t_prc_component_prices`(수량×옵션 고정가)
- 출처: `09_load/_migrate_fixedprice/` + `02_mapping/price211-fixedgrid/` {tier C, FRESH}
- 연결: [[#PE-006]] · [[#PE-STALE]]
- 사용처: [[recipes/booklet#BK-PRC-002]] (책자 떡제본 고정가 엽서북/떡메모지) · [[recipes/sticker#STK-PRC-001]] (priced-by — 형상×치수×코팅 격자) · [[recipes/calendar#CAL-DC-001]] (priced-by — 디자인캘린더 고정가 직접단가 4000~24000) · [[recipes/calendar#CAL-PRC-002]] (캘린더가공 옵션 추가가 격자)
- tags: #가격 #고정가형 #포스터교정

### [PE-008] 구간형 (수량구간 할인) t_dsc_*  {🟡}
- 내용: 수량 구간별 할인율(round-1). 범위문자열 "1~49" → min/max, 할인율 단위 판별. 아크릴/굿즈파우치/문구 카테고리 단위 적용.
- 앵커: `t_dsc_*`(헤더·구간·링크)
- 출처: `00_schema/discount-domain-detail.md` + `raw/webadmin/tools/load_discounts.py` {tier A/C, PARTIAL-STALE: I-7 PK}
- 연결: [[load-path#LP-001]] (loaded-via) · 메모리 `dbmap-discount-authority`
- 사용처: [[recipes/digital-print#DGP-PR-003]] (비대상 — 디지털인쇄는 구간형 아님·대조) · [[recipes/acrylic#AC-PRC-001]] (priced-by — 아크릴 카테고리 수량구간 할인)
- answers_cq: CQ-PRICE-04 (수량 구간별 할인 체계)
- tags: #가격 #구간할인 #t_dsc

### [PE-009] 상품별 공식 PRF_<X> (가격사슬 단절 해소)  {🟡}
- 내용: 상품→comp 직결경로 부재 시 가격사슬 단절. 공유공식 + 상품별 택일 comp가 끊기면 **상품별 1:1 공식 `PRF_<X>`** 로 해소. broken 4 = 포스터28/제본/명함/포토카드.
- 앵커: `t_prc_price_formulas`(PRF_<X> 상품별)
- 출처: `02_mapping/dwire-poster-formula-remodel/`·`dwire-bind-namecard-photocard-remodel/` + 메모리 `dbmap-price-chain-dwire-per-product-formula` {tier C, FRESH}
- 연결: [[#PE-005]] · [[#PE-007]]
- 사용처: _(레시피 집필 시 채움)_
- tags: #가격 #상품별공식 #가격사슬 #broken4

---

## 3. 앱 계산 경계 (DB 미저장)

### [PE-010] 판수(판걸이수)·박 등급 = 앱 계산  {🟡}
- 내용: **판수(판걸이수)는 임포지션/네스팅 런타임 계산**(DB 미저장 — 입력=판형 인쇄가능영역 + 작업사이즈). **박 면적→등급도 앱 계산**(DB는 등급별 가격만 저장). off-grid ceiling과 동일 철학. 스키마에 없다고 GAP이 아니라 "앱 계산".
- 앵커: (DB 외 — 앱 계산) · 입력 = `t_prd_product_plate_sizes` + 작업사이즈
- 출처: 메모리 `dbmap-compute-in-app-db-stores-lookup`·`pangeori-l1.csv`(판걸이수=판형 마진 권위) {tier B/C, FRESH}
- 연결: [[../base/prepress-file#BPF-002]] (uses — 판걸이 N-up 보편 개념) · [[#PE-006]] (ceiling 동일 철학)
- 사용처: [[recipes/digital-print#DGP-PR-001]] (uses — 판수=앱 계산) · [[recipes/sticker#STK-DIM-002]] (uses — 스티커 판수=앱) · [[recipes/acrylic#AC-DIM-003]] (uses — UV 평판 판걸이수=앱 계산)
- answers_cq: CQ-PRICE-10 (판걸이수가 가격에 미치는 영향·계산)
- tags: #앱계산 #판수 #판걸이수 #박등급

---

## 4. STALE 함정 (인용 금지)

### [PE-STALE] price-engine-ddl.md 전체 = STALE (인용 금지)  {🔴 STALE}
- 내용: `00_schema/price-engine-ddl.md`(C-PRICEENG)는 **인용 금지**. 사유: ① "6차원/8컬럼 자연키" → 사실 8차원/10컬럼(I-1) ② 단가형/합가형 개념 전무(I-2) ③ template_prices 누락(I-4) ④ 구 PK(I-7). **대체: `sql/21·22` + `pricing-erd.md`**([PE-001~004]). 추가 함정: 단가형 가정(합가형 오매핑 위험 I-2)·round-2 포스터 면적-좌표 오모델(교정분 권위).
- 출처: `18_schema-change/impact-diagnosis.md` I-1·I-2·I-4·I-7 {tier A, FRESH}
- 연결: [[#PE-001]] · [[#PE-006]] · [[#PE-007]]
- tags: #STALE #price-engine-ddl #인용금지 #Phase11

---

## 5. GAP (미모델링·미결)

### [PE-GAP-1] 합가형(prc_typ_cd=.02) 상품 식별 절차 부재  {🔴}
- 내용: 라이브 전부 .01 → 합가형 식별 절차 미신설.
- 출처: `_curation/axis-price-engine.md` GAP-PE-1 {tier A}
- 연결: [[#PE-002]]
- tags: #GAP #합가형

### [PE-GAP-2] 평면화 차원집합 ↔ 라이브 use_dims 대조 절차 미신설 (I-3)  {🔴}
- 내용: 우리 평면화 차원집합과 라이브 `use_dims` 대조 절차 부재.
- 출처: `_curation/axis-price-engine.md` GAP-PE-2 · impact-diagnosis I-3 {tier A}
- 연결: [[#PE-001]]
- tags: #GAP #use_dims #I-3

### [PE-GAP-3] 포토북·디자인캘린더·문구·부자재 가격 미적재 (prices 0행)  {🔴}
- 내용: 6상품군 가격사슬 부재(crosscut 추가-I). template_prices 0행([PE-004]).
- 출처: `_curation/axis-price-engine.md` GAP-PE-3 {tier C}
- 연결: [[#PE-004]]
- 사용처: [[recipes/photobook#PB-PRC-001]] (포토북 가격 0행·PRF_PBK_PAGEBAND 적재 필요) · [[recipes/calendar#CAL-PRC-001]] (캘린더 가격사슬 부재·미연결) · [[recipes/calendar#CAL-DC-001]] (디자인캘린더 prices 0행·고정가 미적재)
- tags: #GAP #가격미적재

### [PE-GAP-4] 박 가격 GAP · plate 교정 대기 차단 (3절/투명/048/019)  {🔴}
- 내용: 박 등급별 가격 GAP 잔존. 3절/투명/048/019 등 plate 교정 대기로 가격 차단.
- 출처: `_curation/axis-price-engine.md` GAP-PE-4·GAP-PE-5 + 메모리 `dbmap-digitalprint-atomic-formula-unbuilt` {tier C}
- 연결: [[#PE-010]] · [[load-path#LP-006]]
- 사용처: [[recipes/digital-print#DGP-PR-002]] (디지털인쇄 가격 차단 — 박·3절/투명/048/019)
- tags: #GAP #박 #plate교정

---

## Sources
- 큐레이션 팩: `_curation/axis-price-engine.md`
- 구조 정답(FRESH): 라이브 psql `information_schema`(t_prc_* 컬럼·행수 실측 — 차원의 라이브 실재 권위); `raw/webadmin/sql/21_pricing_dims.sql`·`sql/22_use_dims.sql`(**seed/init 스크립트 — `pricing_dims`/`use_dims`는 라이브 테이블 아님, W3**)·`sql/18_unify_price_keys.sql`·`sql/20_template_prices.sql`; `raw/webadmin/docs/prcx01-pricing-model.md`·`pricing-erd.md`; `raw/webadmin/tools/init_use_dims.py`.
- 공식유형 정답: `02_mapping/{digital-print-engine,silsa-poster-area-matrix,price211-fixedgrid,dwire-poster-formula-remodel,dwire-bind-namecard-photocard-remodel}/`; `09_load/_migrate_areamatrix/`·`_migrate_fixedprice/`; `00_schema/discount-domain-detail.md`; `raw/webadmin/tools/load_discounts.py`.
- 보조: `05_method/F2-price-sheet-structures.md`·`06_extract/price-<slug>-l1.csv`·`pangeori-l1.csv`.
- freshness: `18_schema-change/impact-diagnosis.md` I-1·I-2·I-3·I-4·I-7.
- 메모리: `dbmap-round2-price-engine`·`dbmap-compute-in-app-db-stores-lookup`·`dbmap-output-plate-mapping`·`dbmap-price-formula-types-authority`·`dbmap-silsa-price-via-poster-sign`·`dbmap-price-chain-dwire-per-product-formula`·`dbmap-digitalprint-atomic-formula-unbuilt`.
- **STALE(인용 금지):** `00_schema/price-engine-ddl.md` 전체(I-1·I-2·I-4·I-7); round-2 포스터 면적-좌표 회귀 모델.
