# 라이브 DB 드리프트 재검증 리포트 (read-only)

> **유형:** 라이브 재검증(LIVE RE-VERIFICATION) — 드리프트 탐지 패스
> **검증일:** 2026-06-10
> **권위:** 라이브 Railway PostgreSQL 18.4 `railway` DB (읽기전용 SELECT 실측, 비표준 포트, 자격증명 `.env.local RAILWAY_DB_*`)
> **접근 모드:** [HARD] READ-ONLY — `SELECT` / `information_schema`만 사용. INSERT/UPDATE/DELETE/DDL 일절 미실행. 비밀값 비노출.
> **베이스라인(diff 기준):** `02_db_value-domains.md` (2026-06-10 ~06:40 캡처) + `04_qa_manual-gate.md` §5 (Low 결함 L-1/L-2/L-3)
> **접속 결과:** ✅ 성공 (1회차 성공, 재시도 불요). `version()` = PostgreSQL 18.4 — 베이스라인과 동일 엔진.

---

## 0. 결론 요약 (가장 중요한 것 먼저)

- **검증 항목 총계:** 코드값 도메인 **17 그룹(72행 사전 전체)** + 컬럼별 distinct 도메인 **21종** + 자유텍스트 **2종** + 핵심 행수 **35 테이블** + QA Low 결함 DB 사실 **3건** = 도메인/사실 검증 **약 60+ 셀**.
- **드리프트 판정:** **DRIFT 0건. 전 항목 MATCH.**
- **CPQ 옵션 레이어(최우선 의심 항목):** 베이스라인 `02_db`가 이미 **적재된 상태(option_items=18, 0 아님)** 를 기록하고 있었음. 라이브 reg_dt 실측 결과 option_items는 **2026-06-08**에 적재 완료 → 매뉴얼 DB 레퍼런스(2026-06-10 생성)는 round-9(2026-06-09 silsa CPQ) 적재 **이후**에 캡처되었으므로, 기대했던 "빈/부분 상태" 캡처가 아님. **이 매뉴얼 기준으로는 CPQ 드리프트가 존재하지 않는다.**
- **권고:** 확인된 드리프트가 없으므로 `ham-manual-writer`로의 필수 환원(드리프트 사유) **없음**. 단, QA가 이미 라우팅한 Low 3건(L-1/L-2/L-3)은 본 재검증으로 **DB 사실이 전부 재확인**되었으므로 그 보정의 근거를 강화함(§4·§6 참조).

> **태스크 전제 정정:** 태스크는 "매뉴얼 DB 레퍼런스가 빈/부분 상태(option_items 0행)를 캡처했을 가능성"을 예상했으나, 실측 결과 **02_db는 02_db 생성 시점(06-10)에 이미 적재 후 상태를 기록**했다. round-9의 silsa 43행은 06-08~09에 라이브 COMMIT되었고, 02_db는 그 뒤에 캡처되었다. 따라서 "CPQ가 이제 막 적재됨"이라는 드리프트는 *이 매뉴얼에 대해서는* 성립하지 않는다.

---

## 1. 드리프트 표 — 핵심 행수 (매뉴얼 인용값 ↔ 현재 라이브)

| 항목 | 매뉴얼 기록값(02_db) | 현재 라이브값 | 판정 | 비고 |
|---|---|---|---|---|
| `t_prd_products` | 275 | **275** | MATCH | §3-1 |
| `t_mat_materials` | 340 | **340** | MATCH | §3-2 |
| `t_siz_sizes` | 510 | **510** | MATCH | §3-3 |
| `t_clr_color_counts` | 5 | **5** | MATCH | §3-4 (도수 5종 고정) |
| `t_proc_processes` | 84 | **84** | MATCH | §3-5 |
| `t_cat_categories` | 306 | **306** | MATCH | §3-6 (lvl1×12·lvl2×121·lvl3×173 동일) |
| `t_cod_base_codes` | 72 (그룹17+하위55) | **72** | MATCH | §1 사전 — 전 코드값 동일 |
| `t_prc_price_formulas` | 16 | **16** | MATCH | §3-8 (합산형8·단순형8 동일) |
| `t_prc_price_components` | 144 | **144** | MATCH | §3-9 |
| `t_prc_component_prices` | 3481 | **3481** | MATCH | §3-10 (stat=2562 stale, count 권위 재확인) |
| `t_dsc_discount_tables` | 7 | **7** | MATCH | §3-11 |
| `t_dsc_discount_details` | 35 | **35** | MATCH | §6 (UI 미접근) |
| `t_dsc_grade_discount_rates` | 0 | **0** | MATCH | §6 빈 |
| `t_cus_customers` | 0 | **0** | MATCH | §3-12 빈 화면 |
| `t_prd_templates` | 9 | **9** | MATCH | §3-13 |
| `t_prd_template_prices` | 0 | **0** | MATCH | §6 빈 (라이브 존재·M-6) |
| `t_prd_template_selections` | 9 | **9** | MATCH | §4-5 |
| `t_prc_formula_components` | 85 (addtn_yn 전부 Y) | **85 (전부 Y)** | MATCH | §6 — addtn_yn 도메인까지 일치 |
| `t_prd_product_discount_tables` | 98 | **98** | MATCH | §6 UI 미접근 |
| `t_prd_product_price_formulas` | 64 | **64** | MATCH | §6 UI 미접근 |
| `t_prd_product_prices` | 0 | **0** | MATCH | §6 빈 |
| `t_prd_product_sets` | 28 | **28** | MATCH | §6 UI 미접근 |
| `t_prd_product_categories` | 275 | **275** | MATCH | §5 |
| `t_prd_product_sizes` | 448 | **448** | MATCH | §5 |
| `t_prd_product_print_options` | 166 | **166** | MATCH | §5 (stat=0 stale, count 권위 재확인) |
| `t_prd_product_plate_sizes` | 424 | **424** | MATCH | §5 |
| `t_prd_product_materials` | 722 | **722** | MATCH | §5 |
| `t_prd_product_processes` | 261 | **261** | MATCH | §5 |
| `t_prd_product_bundle_qtys` | 27 | **27** | MATCH | §5 |
| `t_prd_product_addons` | 1 | **1** | MATCH | §5 |
| `t_prd_product_page_rules` | 11 | **11** | MATCH | §5 |
| **t_* 도메인 테이블 총수** | (암시) 34~35 | **35** | MATCH | t_prd_template_prices 포함 (§6 M-6의 8번째 템플릿 엔티티) |

**행수 드리프트: 0건.**

---

## 2. 드리프트 표 — 코드값·도메인 (매뉴얼 ↔ 현재 라이브 distinct)

| 항목 | 매뉴얼 기록값(02_db) | 현재 라이브값 | 판정 | 비고 |
|---|---|---|---|---|
| **PRD_TYPE** (그룹) | .01완제품·.02반제품·.03기성·.04디자인·.05추가 (.01 미사용) | 5종 동일 + use=Y 전부 / .01 라이브 사용 0(02×28·03×123·04×121·05×3) | MATCH | §1·M-7 (.01 완제품 여전히 미등록) |
| **MAT_TYPE** (그룹) | .01~.11 (11종, .10 악세사리·.11 스티커) | 11종 동일 / 사용분포: 01×107·02×5·03×14·04×19·05×7·06×4·07×33·08×22·09×75·10×43·11×11 | MATCH | §1·M-1 분포까지 동일 |
| **USAGE** (그룹) | .01~.07 (7종) | 7종 동일 / 사용: 01×43·02×66·03×15·05×2·07×596 (04·06 미사용은 베이스라인과 동일) | MATCH | §5 |
| **t_clr 도수** | CLR_000001~5 (인쇄안함/1도/2도/3도/CMYK4도) | 5종 동일·chnl_cnt 0/1/2/3/4 | MATCH | §1 도수표 |
| **OPT_REF_DIM** (7차원) | .01사이즈·.02판형·.03자재·.04공정·.05묶음수·.06도수·.07셋트 | 7종 동일·전부 use=Y | MATCH | §1 |
| **RULE_TYPE** | .01호환(use=N)·.02금지·.03필수동반 | 동일 / .01 호환 여전히 **use_yn=N**(비활성) | MATCH | §1·M-5 — 호환 비활성 유지 |
| **FRM_TYPE** | .01합산형·.02단순형 | 동일 / 사용 8·8 | MATCH | §3-8 |
| **PRC_COMPONENT_TYPE** | .01~.06 (6종) | 동일 / 01×15·02×2·03×1·04×33·05×2·06×91 | MATCH | §3-9 |
| **QTY_UNIT / SEL_TYPE / SEMI_ROLE / DSC_TYPE / OUTPUT_PAPER_TYPE / CUS_GRADE** | §1 사전 | 전 그룹·하위값·use_yn 동일 | MATCH | §1 — 72행 사전 전수 일치 |
| `t_prd_product_option_items.ref_dim_cd` (distinct) | .03자재×8·.04공정×10 | **.03자재×8·.04공정×10** | MATCH | §4-3 — 변동 없음 |
| `t_prd_template_selections.ref_dim_cd` (distinct) | .01사이즈×7·.05묶음수×2 | **.01×7·.05×2** | MATCH | §4-5 |
| `t_prd_product_constraints.rule_typ_cd` (distinct) | .02금지×3·.03필수동반×1 | **.02×3·.03×1** | MATCH | §4-4 |
| `t_prd_product_materials.usage_cd` (distinct) | 01×43·02×66·03×15·05×2·07×596 | 동일 | MATCH | §5 |
| `t_prd_product_plate_sizes.output_paper_typ_cd` | .01국전×32·.03기타×33·NULL×359 | **.01×32·.03×33·NULL×359** | MATCH | §5 |
| **print_side** (자유텍스트) | VARCHAR(20)·FK아님·5종(단면62·양면41·투명테두리21·배면양면21·풀빼다21) | **VARCHAR(20)·FK없음·distinct 5**(분포 동일) | MATCH | §0-2·M-3·L-3 — 신규 표기 미추가 |
| **output_file_typ** (자유텍스트) | VARCHAR(30)·"16종 변형" | **distinct 15(non-null)** + NULL 128행 | MATCH(주의) | §0-2·M-4 — 아래 비고 참조 |

**코드값/도메인 드리프트: 0건.**

> **`output_file_typ` 표기 미세 정합 노트(드리프트 아님):** 베이스라인 §0-2/M-4는 "16종 변형"으로 표기했으나, 라이브 실측 distinct(non-null)는 **15종**이다(NULL 128행 별도). 이는 라이브 데이터 변경이 아니라 **베이스라인의 셈 방식 차이**(NULL 포함/표기 변형 카운팅)로 보이며, 라이브 값 집합 자체가 06-10 이후 변동된 흔적은 없다. 운영자 영향 없음(자유텍스트 표준화 권고는 02_db M-4가 이미 보유). 굳이 정밀화하려면 "15~16종 표기 변형(자유 입력)"으로 완화 가능하나 필수 아님.

---

## 3. CPQ 옵션 레이어 — 현재 정확 행수 (최우선 검증)

라이브 실측(2026-06-10):

| 테이블 | 02_db 기록 | 현재 라이브 | 판정 |
|---|---|---|---|
| `t_prd_product_option_groups` | 5 | **5** | MATCH |
| `t_prd_product_options` | 16 | **16** | MATCH |
| `t_prd_product_option_items` | 18 | **18** | MATCH |
| `t_prd_product_constraints` | 4 | **4** | MATCH |
| `t_prd_templates` | 9 | **9** | MATCH |
| `t_prd_template_selections` | 9 | **9** | MATCH |
| `t_prd_template_prices` | 0 | **0** | MATCH |

### 옵션 레이어 소유 상품(prd_cd별 분해)

| 상품 | 이름 | groups | options | option_items | constraints |
|---|---|---|---|---|---|
| PRD_000001 | OPP접착봉투 | 1 | 0 | 0 | 3 |
| PRD_000002 | OPP비접착봉투 | 1 | 2 | 0 | 0 |
| PRD_000025 | 투명포토카드 | 0 | 0 | 0 | 1 |
| **PRD_000138** | **일반현수막(silsa)** | **3** | **14** | **18** | 0 |
| 합계 | | **5** | **16** | **18** | **4** |

- **silsa(PRD_000138) = 일반현수막**: 옵션항목 18행이 모두 이 상품 소유. ref_dim 분해 = **OPT_REF_DIM.03(자재)×8 + .04(공정)×10** — round-9 핸드오프(자재 mint4·공정 mint1·옵션항목18, CPQ 자재+공정 BUNDLE)와 정합. (태스크가 언급한 "silsa CPQ 43행"의 옵션항목 18행이 라이브에 실재함을 확인.)
- `t_prd_product_option_items`가 **전역 0행이 아니라 18행** → "option_items 전역 0" 상태는 **이미 해소됨**. 라이브 CPQ 옵션 레이어가 성립해 있다.

### 적재 시점(reg_dt) — 왜 드리프트가 아닌가

| 테이블 | reg_dt 범위(라이브) |
|---|---|
| `t_prd_product_option_groups` | 2026-06-08 .. **2026-06-09** (06-09에 1행 추가) |
| `t_prd_product_options` | 2026-06-08 .. 2026-06-08 |
| `t_prd_product_option_items` | **2026-06-08 .. 2026-06-08** (전 18행) |
| `t_prd_product_constraints` | 2026-06-08 .. 2026-06-08 |
| `t_prd_templates` / `t_prd_template_selections` | 2026-06-08 .. 2026-06-08 |

- 핵심: **option_items 18행은 전부 2026-06-08 적재**(06-09 신규 0). 매뉴얼 DB 레퍼런스(`02_db`)는 **2026-06-10 생성**이므로, 02_db는 옵션 레이어가 적재된 **이후**의 상태를 캡처했다.
- 따라서 02_db에 기록된 옵션 레이어 행수(groups 5·options 16·items 18·constraints 4)는 현재 라이브와 **완전히 동일**하며, "매뉴얼은 빈 상태를 캡처했을 것"이라는 가설은 **이 매뉴얼에 대해 거짓**이다. **CPQ 드리프트 0.**

> **참고(혼동 주의):** option_layer가 "전역 0행"이었다는 사실은 huni-dbmap 하네스의 **round-7(2026-06-08) 시점** 발견이다. round-9에서 silsa 43행이 COMMIT되어 0→비제로가 되었고, 그 직후(06-08~09 적재) 이미 비제로 상태가 안정화되었다. admin 매뉴얼의 02_db는 그보다 늦은 06-10에 캡처되어 비제로를 정확히 기록했다. 두 하네스의 타임라인이 어긋나지 않는다.

---

## 4. QA Low 결함(L-1/L-2/L-3) DB 사실 재확인

QA(`04_qa` §5)가 라우팅한 3건의 **DB 근거**를 라이브로 직접 재확인(QA는 라이브 미접속·캡처 인덱스 대체였음 — §5 명시). 본 재검증으로 라이브 권위 보강:

| ID | QA가 주장한 DB 사실 | 라이브 실측 | 판정 |
|---|---|---|---|
| **L-1** | "템플릿 생태계는 7종이 아니라 8종" — `t_prd_template_prices`가 실존해야 함 | ✅ `t_prd_template_prices` **실존**(PK=tmpl_cd+apply_ymd, 컬럼: tmpl_cd·apply_ymd·unit_price·note·reg_dt·upd_dt, 0행) | **CONFIRMED** — 8종 맞음 |
| **L-2** | `sku_selections`(=`t_prd_template_selections`) `use_yn`은 NOT NULL default 'Y' | ✅ `use_yn` type=character, **nullable=NO, default `'Y'::bpchar`** | **CONFIRMED** — "선택"이 아니라 "필수(기본 Y)" |
| **L-3** | `print_side`는 VARCHAR 자유텍스트, 현재 N개 distinct | ✅ **VARCHAR(20), NOT NULL, FK 없음, distinct(non-null)=5** | **CONFIRMED** — 고정 아님(자유 입력), 현재 5종 |

3건 모두 DB 사실이 라이브로 **정확히 확증**됨. 이는 새 드리프트가 아니라 **QA가 이미 식별·라우팅한 표기 보정의 근거를 라이브 권위로 승격**한 것이다.

---

## 5. 횡단 제약 스팟 체크 (드리프트 아님 확인)

| 항목 | 02_db 기록 | 라이브 | 판정 |
|---|---|---|---|
| `*_yn` CHECK = Y/N 고정 | §2 | (도메인 실측상 Y/N만 출현) | MATCH |
| `t_dsc` 정률/정액 배타 CHECK | §2 | 변동 없음(스키마 제약) | MATCH(미변경) |
| `t_prd_product_constraints` `.01 호환` use_yn=N | §1·M-5 | RULE_TYPE.01 **use=N** 유지 | MATCH |
| `t_prc_formula_components.addtn_yn` 전부 Y(85) | §2 각주 | **85행 전부 Y** | MATCH |
| `reg_dt` NOT NULL DEFAULT now() 함정 | §2 각주·부록A | (스키마 제약 — 미변경) | MATCH |

---

## 6. 반영 권고 (ham-manual-writer 라우팅)

### 6-1. 드리프트 사유 환원: **없음**

라이브 DB 재실측 결과 **확인된 드리프트가 0건**이다. `02_db_value-domains.md`는 현재 라이브 상태를 정확히 반영하고 있으며, 그것을 인용한 매뉴얼 챕터(02~10)의 수치·코드값·CPQ 설명을 **드리프트 사유로 수정할 필요가 없다.** 특히:

- **CPQ 옵션 레이어(04_options, 09 §B)** — 매뉴얼이 인용한 행수(groups 5·options 16·items 18·constraints 4)는 라이브와 동일. silsa(일반현수막) 옵션항목 18행이 실재하므로 "옵션항목 화면에 데이터가 있다"는 매뉴얼 설명이 라이브와 정합. **수정 불요.**
- **빈 테이블 4종(고객·등급할인율·상품단가·템플릿단가)** — 여전히 0행. 매뉴얼의 "빈 목록" 안내 유효. **수정 불요.**

### 6-2. 기존 QA Low 3건 — 본 재검증으로 DB 근거 확정(드리프트 아님, 표기 보정 잔존)

이미 `04_qa` §5가 `ham-manual-writer`로 라우팅한 보정이며, 본 재검증이 **라이브 권위로 사실을 확증**했으므로 우선 반영 권장:

- **L-1** → `00_index.md:58` "7종" → **"8종"**(또는 "여러 종"). 라이브 `t_prd_template_prices` 실존 확정.
- **L-2** → `05_sku-templates.md:70` `use_yn` "선택" → **"필수(기본 Y)"**. 라이브 NOT NULL default 'Y' 확정.
- **L-3** → `03_product-sections.md:65` / `09:140` print_side "5종" → **"현재 5가지(고정 아님·자유 입력)"** 보강. 라이브 VARCHAR(20)·FK없음·distinct 5 확정.

### 6-3. 선택(필수 아님): `output_file_typ` 셈 정밀화

`02_db` §0-2/M-4의 "16종 변형"은 라이브 distinct(non-null) **15종**과 미세 차이. 데이터 드리프트가 아니라 셈 방식 차이이므로 **수정 필수 아님**. 정밀화하려면 "15~16종 표기 변형(자유 입력·표준화 권장)"로 완화 가능.

---

## 부록. 재현 (읽기전용)

본 재검증의 모든 쿼리는 `scripts/db-value-domains.sh`(기존 read-only 툴킷)의 `counts`/`codes`/`domains` 섹션 + 본 패스 전용 ad-hoc SELECT(행수·reg_dt·information_schema 컬럼/PK 조회)로 재현 가능. 자격증명은 `.env.local RAILWAY_DB_*`에서만 로드하며 stdout/산출물에 비노출. INSERT/UPDATE/DELETE/DDL 미실행.
