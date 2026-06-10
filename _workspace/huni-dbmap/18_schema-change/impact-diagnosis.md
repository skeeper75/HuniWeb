# webadmin Phase 10/11 스키마 진화 → huni-dbmap 산출 영향 정밀 진단

> 작성 2026-06-11 · 진단 전용(우리 dbmap 산출 무변경) · DB 읽기전용 SELECT만 · git 읽기전용
> 권위: webadmin git diff(선언) + 라이브 information_schema 실측(적용). 추정 0.
> 입력처: 신규 round-14(webadmin 스키마 변경 추적) 하네스 설계.

---

## 1. 커밋 범위 + Phase 10/11 타임라인

- **레포**: `raw/webadmin`(HuniProductPrice2 — 라이브 DB 스키마+적재 소스 오브 트루스)
- **베이스라인 커밋**: `d6026be` (2026-06-09 02:02) — Phase 10/11 스키마 변경 직전. 이 시점 `sql/`은 01a~16(태그)까지, `constraint_json`·`dep_proc_cd` 존재. 우리 round-9 admin-ui-spec(06-08)·round-11 loadspec(06-10 초)이 본 스키마.
- **현재 HEAD**: `bd12d03` (2026-06-11 02:07)
- **신규 sql**: 15 → **23** (16~23 신규 8개)
- **t_\* 테이블**: 34 → **35** (라이브 실측 일치)

### Phase 10/11 변경 커밋(델타)

| 커밋 | 시각 | 분류 | 내용 | 대응 sql |
|------|------|------|------|----------|
| `e5ee96b` | 06-09 17:02 | 제약(앱) | 옵션그룹/옵션을 제약 차원으로 추가(포함 in 비교) — **앱 로직만**(views.py/builder), DB 컬럼 무변경 | — |
| `0e2ca7d` | 06-09 16:20 | 코드값 | 호환 규칙유형(RULE_TYPE.01) 제거 → 금지+필수동반 2종 | 19 |
| `fdbd978`/`6a52e67` | 06-09 16:24~16:50 | 컬럼 add | usr_def_cd·usr_def_nm(옵션·옵션그룹·템플릿) | 19 |
| `10ff57c` | 06-09 08:47 | PK modify | 상품 가격공식·할인테이블 PK → (상품, 적용시작일) 통일 | 18 |
| `3763d89` | 06-10 00:21 | 테이블 add | `t_prd_template_prices` 신설(템플릿 직접단가) | 20 |
| `4a16c6f` | 06-10 23:14 | 컬럼 add + 코드값 | 가격엔진 차원 `proc_cd`·`opt_cd`(component_prices) + 단가유형 `prc_typ_cd`(price_components) + PRICE_TYPE 코드 3종 | 21 |
| `bd7d290` | 06-11 01:10 | 컬럼 add | `use_dims` jsonb(price_components) — 사용차원 추론 초기화 | 22 |
| `93e271b` | 06-11 01:57 | 컬럼 drop + 로직 | `constraint_json`(products)·`dep_proc_cd`(product_materials) **삭제** + 제약평가 즉석병합 전환(cfg_utils) | 23 |
| (태그) `c597038` 등 | 06-08~09 | 컬럼 add | tags jsonb(옵션·템플릿) | 16 |

우리 분석 시점 겹침: round-11 loadspec·schema-design-intent-map(06-10), round-12 mapping-research(06-10), round-13 correctness(06-11) — **전부 Phase 11 가격엔진 차원(21/22)·constraint_json 삭제(23) 이전 또는 미인지 상태에서 작성**.

---

## 2. 스키마 구조 변경 분류표(선언된 변경 — git diff 실증)

| 종류 | 객체 | 변경 | 상세 | sql |
|------|------|------|------|-----|
| **테이블** | `t_prd_template_prices` | **add** | (tmpl_cd, apply_ymd) PK · unit_price · 시계열 · FK→templates · upd_dt 트리거 | 20 |
| **컬럼** | `t_prc_component_prices.proc_cd` | **add** | varchar(50) NULL, FK→t_proc_processes. 가격 **공정 차원** 신설 | 21 |
| **컬럼** | `t_prc_component_prices.opt_cd` | **add** | varchar(50) NULL, FK 없음(코드매칭). 가격 **옵션 차원** 신설 | 21 |
| **컬럼** | `t_prc_price_components.prc_typ_cd` | **add** | varchar(50), FK→base_codes. **단가유형**(01 단가형=장당가, 02 합가형=구간총액÷환산) | 21 |
| **컬럼** | `t_prc_price_components.use_dims` | **add** | jsonb. 구성요소 단가표가 쓰는 차원 컬럼명 배열(그리드/엔진검증) | 22 |
| **컬럼** | options/groups/templates `usr_def_cd`·`usr_def_nm` | **add** | 외부 매핑코드 + UI 표시명 오버라이드 | 19 |
| **컬럼** | options/templates `tags` | **add** | jsonb 자유텍스트 칩 | 16 |
| **컬럼** | `t_prd_products.constraint_json` | **drop** | 제약 compile 캐시 폐기(즉석병합 전환) | 23 |
| **컬럼** | `t_prd_product_materials.dep_proc_cd` | **drop** | 종속공정코드 폐기 | 23 |
| **PK** | `t_prd_product_price_formulas` | **modify** | (prd_cd, frm_cd) → **(prd_cd, apply_bgn_ymd)** | 18 |
| **PK** | `t_prd_product_discount_tables` | **modify** | (prd_cd, dsc_tbl_cd, apply_bgn_ymd) → **(prd_cd, apply_bgn_ymd)** | 18 |
| **FK** | fk_template_prices_tmpl / fk_comp_prices_proc / fk_price_components_prc_typ | **add** | +3 | 20·21 |
| **FK** | dep_proc_cd FK | **drop** | −1 | 23 |
| **인덱스** | ix_t_prc_comp_prices_proc_cd / _opt_cd | **add** | +2 차원조회 | 21 |
| **인덱스** | ux_t_prc_comp_prices_nat_key | **modify** | 자연키 UNIQUE **8컬럼 → 10컬럼**(+proc_cd, +opt_cd) | 21 |
| **인덱스** | dep_proc_cd 인덱스 | **drop** | −1 | 23 |
| **트리거** | trg_t_prd_template_prices_upd_dt | **add** | +1 | 20 |
| **코드값** | PRICE_TYPE / .01 단가형 / .02 합가형 | **add(seed)** | base_codes 신규 enum 3행 | 21 |
| **코드값** | RULE_TYPE.01(호환) | **modify** | use_yn → 'N'(비활성). 제약=금지/필수동반 2종 | 19 |
| **적재로직** | tools/load_master.py | **modify** | products INSERT에서 `constraint_json` 제거 · product_materials INSERT에서 `dep_proc_cd` 제거 | (23 연동) |
| **적재로직** | tools/init_use_dims.py | **add** | use_dims 초기 추론 백필 스크립트(신규) | 22 |
| **적재로직** | tools/deploy.py | **modify** | SQL_FILES 17~23 추가 · 객체 기대치 **테이블44→45·FK71→73·인덱스61→62·트리거36→37** | — |
| **앱로직** | cfg_utils.py | **modify** | compile_constraints 캐시쓰기 제거 → 규칙 원본 **즉석병합 평가**. views on_commit 재컴파일 3곳 제거 | (23 연동) |
| **앱로직** | views.py | **modify** | 제약 차원에 OPT_GRP/OPT(배열 in 비교) 합성차원 추가. POD 런타임 data에 sel_opts/sel_opt_grps 필요 | (e5ee96b) |

deploy.py 객체 기대치 합산 검산: 테이블 +1(template_prices), FK +3−1=+2(71→73), 인덱스 +2(proc/opt)−1(dep_proc)=+1(61→62 ⚠ 명목 — nat_key는 교체라 ±0), 트리거 +1(36→37). **모두 라이브와 일치(§3)**.

---

## 3. 라이브 적용 대조표(선언 vs 적용 — 읽기전용 실측)

| 선언된 변경 | 라이브 information_schema 실측 | 갭 |
|-------------|------------------------------|-----|
| t_\* 35테이블 | **35** | 없음 |
| t_prd_template_prices 신설 | 존재 · **0행** | 없음(데이터만 0) |
| constraint_json 삭제 | t_prd_products에 **부존재(0)** | 없음 |
| dep_proc_cd 삭제 | t_prd_product_materials에 **부존재(0)** | 없음 |
| component_prices.proc_cd·opt_cd | **둘 다 존재** | 없음(데이터는 §아래) |
| price_components.prc_typ_cd | **존재** | 없음 |
| price_components.use_dims | **존재** | 없음 |
| PRICE_TYPE 코드 3종 | **3행 전부 use_yn=Y** | 없음 |
| RULE_TYPE.01 비활성 | **use_yn=N**(02·03만 Y) | 없음 |
| usr_def/tags 컬럼 | 옵션·그룹·템플릿에 **존재** | 없음 |
| price_formulas PK | **PRIMARY KEY (prd_cd, apply_bgn_ymd)** | 없음 |
| discount_tables PK | **PRIMARY KEY (prd_cd, apply_bgn_ymd)** | 없음 |
| product_constraints.logic 잔존 | **logic 컬럼 존재**(prd_cd·rule_cd·logic·err_msg…) | 없음 |

### 선언≠적용 갭 = **DDL 레벨 0건**. 단, **데이터 백필 상태**가 변경의 실효를 가른다:

| 신규 컬럼/코드 | 라이브 데이터 상태 | 함의 |
|----------------|-------------------|------|
| price_components.prc_typ_cd | 144행 **전부 PRICE_TYPE.01(단가형)** | 합가형(02)은 아직 **미지정** — 합가형 상품 식별은 미래 작업 |
| price_components.use_dims | 144행 중 **142행 백필**(2행 component_prices 데이터 없어 NULL) | 차원 추론 적용됨 |
| component_prices.proc_cd / opt_cd | 3481행 **둘 다 0행 채움** | 차원 **컬럼만 신설·데이터 미투입** → 기존 적재(우리 산출 기준)는 정합 유지, 단 모델은 확장됨 |
| template_prices | **0행** | 스키마만 |
| product_constraints | **4행**(silsa round-9) | 즉석병합 전환은 평가경로 변경, 데이터 영향 0 |

---

## 4. 우리 산출 영향 매트릭스(핵심)

심각도: **CRITICAL**(매핑 무효·재작업) · **MAJOR**(부분 갱신) · **MINOR**(주석/명칭) · NONE.

| # | 스키마 변경 | 영향 산출 | stale 부분 | 심각도 | 갱신 필요 |
|---|------------|-----------|-----------|--------|-----------|
| I-1 | component_prices +proc_cd·opt_cd (6→**8차원**, 자연키 8→**10컬럼**) | `00_schema/price-engine-ddl.md` §4·§6, 메모리 dbmap-round2-price-engine | "6차원/8컬럼 자연키" 명시가 틀림(현재 8차원/10컬럼). §6 fit-gap **G-1(별색 no clr slot)·G-2(단/양면)** 가 신규 proc_cd 차원으로 일부 해소 가능 → 미반영 | **MAJOR** | 차원표·자연키·fit-gap 재서술. 가격사슬 자체는 유효 |
| I-2 | price_components +prc_typ_cd(단가형/합가형) | `00_schema/price-engine-ddl.md`, `02_mapping/` 가격, 메모리 round2 | **단가형 vs 합가형** 개념 전무. 우리 모든 단가 매핑은 암묵 "장당가×수량"(=단가형) 가정 — 합가형(구간총액÷환산) 상품을 잘못 매핑할 위험 | **MAJOR** | 공식유형 분류에 단가/합가 축 추가, 상품별 prc_typ 판별 절차 |
| I-3 | price_components +use_dims | `00_schema/price-engine-ddl.md`, `02_mapping/` 단가 평면화 | 단가표 차원집합이 이제 DB 선언(use_dims)으로 권위화 — 우리 평면화의 "쓰는 차원" 판정과 대조 안 됨 | MAJOR | 평면화 차원집합 ↔ live use_dims 대조 절차 신설 |
| I-4 | t_prd_template_prices 신설 | `00_schema/price-engine-ddl.md`, `00_schema/cpq-schema.md`, `15_domain-spec/_loadspec/loadspec.md` | 가격엔진을 "6테이블+보조1"로 서술 → 템플릿 직접단가(SKU별 단가 오버라이드) 경로 누락. 상품악세사리(OTC TEMPLATE) 가격이 여기 갈 수 있음 | **MAJOR** | 가격 테이블 인벤토리에 template_prices 추가, SKU 가격 경로 |
| I-5 | constraint_json **삭제** + 즉석병합 | `00_schema/cpq-schema.md`(✅5·미적재행), `00_schema/schema-design-intent-map.md`(ERD L91·§11), `16_mapping-research/digital-print/mapping-final.md`(180g→constraint_json), `15_domain-spec/_loadspec/loadspec.md`(L79 constraint_json 입력컬럼) | constraint_json을 "compile 캐시(설계대로 실재)"로 서술·ERD에 컬럼 표기·**적재 타깃**으로 지정. 컬럼 부존재 → 적재 매핑 무효(180g 코팅 조건부는 이제 product_constraints.logic 원본에만, 캐시 없음) | **MAJOR** | constraint_json 적재 타깃 제거, 제약=product_constraints.logic 단일경로(즉석병합)로 재서술 |
| I-6 | dep_proc_cd **삭제** | `15_domain-spec/_loadspec/loadspec.md`(L96 자재→코팅 게이팅), `00_schema/schema-design-intent-map.md`(ERD L111·자재행), `17_correctness/digital-print/extraction-plan.md`(L56 oracle 컬럼), 다수 09_load 산출 | dep_proc_cd를 자재 적재 컬럼·자재→공정 게이팅 메커니즘으로 명시. 컬럼 부존재 → 적재 스펙 무효(게이팅은 이제 제약/공정 경로로) | **MAJOR** | 자재 loadspec에서 dep_proc_cd 제거, round-13 oracle 재생성, 게이팅 대체경로 명시 |
| I-7 | price_formulas·discount_tables PK 통일 (상품, 적용시작일) | `09_load/*` 적재본, `00_schema/price-engine-ddl.md`, round-1 구간할인 매핑 | 적재 PK·ON CONFLICT 키가 구 PK(frm_cd 포함 / dsc_tbl_cd 포함) 기준이면 멱등 UPSERT 충돌 가능 | **MAJOR** | 적재 SQL의 ON CONFLICT 절을 새 PK로 갱신 |
| I-8 | RULE_TYPE.01(호환) 비활성, 2종 체계 | `00_schema/cpq-schema.md`, `10_configurator/` 제약, 메모리 cpq | 호환 규칙유형을 활성으로 가정한 제약 설계 stale(현 금지+필수동반만) | MINOR | 제약유형 enum 2종으로 정정 |
| I-9 | 옵션그룹/옵션 제약 차원(OPT_GRP/OPT, in 비교) | `10_configurator/cpq-design.md`, constraints JSONLogic | 7스칼라 차원 === 만 가정 → 배열 in 비교(옵션복수선택) 미반영. POD data 계약(sel_opts/sel_opt_grps) 누락 | MINOR | JSONLogic 변환에 in 연산자·옵션 합성차원 추가 |
| I-10 | usr_def_cd/nm·tags 컬럼 add | `13_admin-ui-spec/`(332컬럼·information_schema 권위), loadspec | 컬럼 카운트·admin 입력항목 누락(외부매핑코드·표시명·태그) | MINOR | 컬럼 인벤토리 +N, admin UI 명세 항목 추가 |
| I-11 | t_\* 34→35 | `00_schema/cpq-schema.md`·`schema-overview.md`·`schema-relationship-analysis.md`·CHANGELOG·메모리(34 표기) | "34 t_\* 엔티티" 카운트 stale(현 35) | MINOR | 카운트 35로 정정 |
| — | tags/usr_def는 dbm-coverage 비대상 | round-7 coverage-matrix | 209셀 매트릭스에 신규 차원/테이블 미반영 | MINOR | 다음 coverage 재실행 시 흡수 |

영향 없음(NONE): round-1 구간할인 매핑값 자체·round-2 component_prices 적재값(3,504행, 차원 컬럼 add는 기존 행 무손상)·상품마스터 적재값(398행). **데이터는 무손상, 모델/스펙 문서가 stale**.

### 산출별 심각도 요약

| 산출(라운드) | 최고 심각도 | 영향 항목 |
|--------------|-------------|-----------|
| **round-2 가격**(price-engine-ddl·02_mapping·메모리) | **MAJOR** | I-1·I-2·I-3·I-4·I-7 (차원/자연키/단가유형/template_prices/PK) |
| **round-6 CPQ**(cpq-schema·10_configurator) | **MAJOR** | I-5·I-8·I-9 (constraint_json 삭제·제약유형·옵션차원) |
| **round-11**(loadspec·schema-design-intent-map) | **MAJOR** | I-4·I-5·I-6·I-10·I-11 |
| **round-12**(mapping-research/*/mapping-final) | **MAJOR** | I-5(180g→constraint_json 타깃 무효) |
| **round-13**(17_correctness/digital-print) | **MAJOR** | I-6(oracle dep_proc_cd 컬럼·구 스키마 기반) |
| round-7 coverage / round-9 admin-ui | MINOR | I-10·I-11 |

CRITICAL(매핑 자체 무효로 전면 재작업) **없음** — 전부 MAJOR 이하(부분 갱신으로 회복). 적재값 무손상이 CRITICAL 부재의 근거.

---

## 5. 가장 시급한 stale 항목 Top 3

1. **constraint_json 삭제(I-5)** — round-6/11/12가 이 컬럼을 적재 타깃으로 명시(특히 round-12 digital-print mapping-final의 "180g 코팅 조건부→constraint_json"). 컬럼 부존재로 **적재 매핑이 무효**. 제약=`t_prd_product_constraints.logic` 단일경로(즉석병합)로 즉시 정정 필요. 가장 광범위 참조(50+ 파일에 constraint_json 등장).

2. **가격엔진 차원 확장 + 단가유형(I-1·I-2)** — price-engine-ddl.md의 "6차원/8컬럼 자연키"가 사실과 다르고(8차원/10컬럼), **단가형/합가형** 개념 부재로 합가형 상품(구간총액형)을 단가형으로 오매핑할 위험. round-2 가격 전 트랙의 모델 기반.

3. **dep_proc_cd 삭제(I-6)** — round-13 correctness oracle이 이 컬럼을 자재 적재 oracle로 사용 → oracle이 구 스키마라 round-13 정합검증 결과 신뢰성 훼손. 자재→공정 게이팅 대체경로 확정 + oracle 재생성 필요.

---

## 6. round-14(webadmin 스키마 변경 추적) 하네스 설계 권고

### 무엇을 추적·갱신해야 하나
1. **webadmin git 델타 모니터**: `raw/webadmin` `sql/`·`tools/`·`webadmin/catalog/{models,views,cfg_utils,admin}.py`의 baseline↔HEAD diff를 정기 캡처. sql 파일 번호 증가(15→23 같은)와 `93e271b` 류 schema 커밋(feat(schema)/refactor(schema)) 자동 탐지.
2. **3-way 정합**(round-10 dbm-change-tracking 패턴 재사용): ① webadmin 선언(git diff) ② 라이브 적용(information_schema 실측) ③ 우리 dbmap 산출 참조. 선언≠적용 갭 + 산출 stale을 한 판에서 분류.
3. **DDL 레벨 + 데이터 백필 레벨 분리 추적**: 이번 진단의 핵심 교훈 — DDL 갭은 0이어도 **신규 컬럼의 데이터 백필 상태(proc_cd 0행·prc_typ 전부 단가형·template_prices 0행)**가 실효를 가른다. "컬럼 존재=적용완료" 판정 금지(round-7 D-1 "LOADED=행존재만" 결함의 가격엔진판).
4. **영향 매트릭스 산출**: 변경 → 영향 산출 → stale 부분 → 심각도(CRITICAL/MAJOR/MINOR/NONE) → 갱신경로. 본 §4가 round-14 산출 템플릿.
5. **게이트**: 변경 누락 0(전 sql/tools 델타 커버)·라이브 실측 인용 실재·심각도 분류 정당(데이터 무손상→CRITICAL 금지)·우리 산출 읽기전용.

### 재사용 기존 자산
- **dbm-change-tracking 스킬(round-10)**: 키 기반 3-way diff·V1~V8 게이트 — webadmin 스키마 버전(엑셀 버전 대신)으로 일반화. dbm-change-tracker 에이전트 재사용.
- **dbm-schema-extract 스킬**: 라이브 information_schema 읽기전용 실측 툴킷(본 진단의 §3 쿼리 패턴).
- **schema-design-intent-map(00_schema)**: 변경된 컬럼의 "WHY"를 재유도 없이 갱신할 권위 베이스(단 ERD를 constraint_json/dep_proc_cd 제거로 갱신해야 — 본 진단 입력).
- **deploy.py 객체 기대치**: webadmin이 이미 테이블/FK/인덱스/트리거 기대 카운트를 유지 → 변경 탐지 신호로 차용(44→45 등).

### 신규 필요(최소)
- webadmin 커밋↔sql파일↔라이브객체↔우리산출 4중 매핑 레지스터(`18_schema-change/` 확장). 신규 에이전트 불요(dbm-change-tracker 모드 추가로 충분).

---

## 부록: 베이스라인 식별 근거
- `d6026be`(06-09 02:02)를 베이스라인으로 택한 이유: 직후 `10ff57c`(PK 통일)부터 Phase 10/11 스키마 변경 시작. 우리 round-9 admin-ui-spec(06-08·information_schema 권위)가 본 332컬럼·constraint_json/dep_proc_cd 존재 상태가 이 시점.
- HEAD `bd12d03`(06-11 02:07) — 진단 실행 시점 webadmin tip.
