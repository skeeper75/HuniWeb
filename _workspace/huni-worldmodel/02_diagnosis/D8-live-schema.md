# D8 — 라이브 DB 스키마 실측 진단 (문서상 모델 vs 실제)

대상: Railway PostgreSQL `railway` 라이브 DB (읽기 전용 SELECT), `raw/webadmin/webadmin/catalog/models.py`(1,052줄), `raw/webadmin/sql/*.sql`(91개), `.moai/project/db/`.
접속 자격증명 출처: `/Users/innojini/Dev/HuniWeb/.env.local:128-132` (RAILWAY_DB_HOST/PORT/USER/PASSWORD/NAME).
관측 시각: 2026-08-15. **INSERT/UPDATE/DELETE/DDL 미실행** — 모든 세션에 `SET default_transaction_read_only=on` 선행.
실측 원본 로그: `_workspace/huni-worldmodel/02_diagnosis/_evidence/D8-live-schema-evidence.txt`

---

## 요약

- **라이브 접속 성공.** PostgreSQL 18.4, public 스키마 총 **154 테이블 / 27 MB**. 그중 도메인 테이블 `t_*` 는 **46개**, 나머지 **97개가 `bak_*`/`z_bak_*` 백업 잔해**, 10개가 Django 시스템 테이블이다(`_evidence:70-74`).
- **models.py ↔ 라이브 스키마 컬럼 드리프트는 0.** 46개 db_table 전부 실재하고, 컬럼 집합 차이도 0이다(유일한 차이 23건은 Django 5의 `CompositePrimaryKey` 선언으로, 물리 컬럼이 아님 — `models.py:103`). models.py 는 전부 `managed = False` 인 inspectdb 파생물이므로(`models.py:1-7`) **이 무드리프트는 "설계가 정확하다"가 아니라 "코드가 DB의 사진"이라는 뜻**이다.
- **반면 MoAI 측 문서상 모델은 비어 있다.** `.moai/project/db/schema.md:1-24` 는 `_TBD_` 템플릿 그대로다. 즉 "문서상 모델"의 실체는 `sql/*.sql` + `models.py` + D1/D2 진단서이지 `.moai/project/db/` 가 아니다.
- **설계가 실제로 건드리는 곳은 좁고 깊다.** 23,573행이 `t_prc_component_prices` 한 테이블에 몰려 있고(전체 도메인 행의 다수), 그 다음이 자재 660·사이즈 629·상품별자재 1,406·상품별사이즈 803이다. 반대로 `t_cus_customers`(고객) 0행, `t_dsc_grade_discount_rates`(등급할인) 0행, `t_wgt_handoff_logs` 0행 — **고객·거래 축은 완전한 빈 그릇**이다(`_evidence:8-69`).
- **가격 사슬은 절반쯤 끊겨 있다.** 라이브 상품 288개 중 가격공식이 바인딩된 것은 **171개(59%)**, 가격구성요소 202개 중 **79개(39%)가 어떤 공식에도 미배선**, 32개는 단가행이 0행이다(`_evidence:76-87`).
- **월드모델 관점 판정: (3) 지식/온톨로지 + (2) 심볼릭이 지배적이고, (4) 월드모델은 가격 축에서만 부분 성립, (1) 뉴로는 0.** 결정적 근거 — `t_prc_price_formulas` 에는 **계산방식 컬럼이 아예 없다**(`frm_cd/frm_nm/note/use_yn/reg_dt/upd_dt` 6컬럼뿐, `models.py:267-278`). 즉 "무엇을 더할지"는 DB에, **"어떻게 계산할지"는 `pricing.py:428` `evaluate_price()` 파이썬 코드에** 있다. DB는 세계의 *상태*는 알지만 *전이 함수*는 모른다.

---

## 실측 사실 (모든 주장에 근거 인용)

### 1. 접속·환경

| 항목 | 실측값 | 근거 |
|---|---|---|
| 엔진 | PostgreSQL 18.4 (Debian, x86_64) | `_evidence:2-7` |
| public 테이블 총수 | 154 | `_evidence:70-74` |
| 그중 `t_*` 도메인 | 46 | 동일 |
| 그중 `bak_*`/`z_bak_*` | 97 | 동일 |
| 전체 크기 | 27 MB | 실측 `pg_total_relation_size` 합 |
| 뷰 | 2 (`v_cfg_ref_impact`, `vc_v_product_detail_tabs`) | `_evidence:139-144` |
| 사용자 함수 | 5 (`fn_best_plate`, `fn_best_plate_default`, `fn_calc_pansu`, `fn_chk_opt_item_ref`, `fn_upd_dt`) | `_evidence:127-137` |
| 트리거(비내부) | 46 | 실측 `pg_trigger WHERE NOT tgisinternal` |
| 제약: PK 46 / FK 86 / CHECK 58 / NOT NULL 228 | `t_*` 한정 | `_evidence:145-149` |
| 최근 데이터 갱신 | `t_prd_products` 2026-08-14 21:29, `t_prc_component_prices` 2026-08-14 19:36 | `_evidence:150-157` |

→ **이 DB는 죽은 스냅샷이 아니라 어제까지 실사용 중인 운영 DB다.**

### 2. 채워진 테이블 vs 빈 그릇 (설계가 실제로 건드리는 곳)

전체 행수는 `_evidence:8-69`. 3계층으로 갈린다.

**(A) 두껍게 채워진 곳 — 실제 자산이 여기 있다**

| 테이블 | 행수 | 도메인 의미 |
|---|---:|---|
| `t_prc_component_prices` | 23,573 | 다차원 단가행 (도메인 전체 행의 압도적 다수) |
| `t_wgt_widget_items` | 2,535 | 위젯 항목 |
| `t_prd_product_materials` | 1,406 | 상품×자재 |
| `t_prd_product_options` | 1,103 | CPQ 옵션 |
| `t_prd_product_option_items` | 906 | 폴리모픽 옵션항목 |
| `t_prd_product_sizes` | 803 | 상품×사이즈 |
| `t_mat_materials` / `t_siz_sizes` | 660 / 629 | 자재·사이즈 마스터 |
| `t_prd_product_processes` | 659 | 상품×공정 |
| `t_prd_product_categories` | 418 | 상품×카테고리 |
| `t_prd_product_plate_sizes` | 404 | 판형사이즈 |
| `t_wgt_widgets` | 387 | 위젯 |
| `t_cat_categories` | 327 | 카테고리 IA |
| `t_prd_products` | 305 (라이브 288) | 상품 |

**(B) 얇게만 채워진 곳 — 그릇은 있으나 소수 사례만**

`t_prd_product_constraints` 82행/34상품, `t_prd_product_prices` 60행, `t_prd_product_sets` 47행, `t_dsc_discount_details` 35행, `t_prd_product_bundle_qtys` 34행, `t_prd_product_page_rules` 23행, `t_prt_print_options` 13행, `t_clr_color_counts` 9행, `t_prd_tmpl_combo_configs` 5행.

**(C) 완전한 빈 그릇 — 0행**

`t_cus_customers`(고객), `t_dsc_grade_discount_rates`(등급별 할인율), `t_wgt_handoff_logs`(핸드오프 로그), 그리고 Django `auth_group`/`auth_group_permissions`/`auth_user_groups`/`auth_user_user_permissions`.

→ **판정: 설계가 실제로 건드리는 축은 "상품 정의 + 가격 단가"이고, "고객·등급·거래·핸드오프" 축은 스키마만 존재한다.** `t_dsc_grade_discount_rates` 가 0행인데 `evaluate_price(grade_cd=...)` 가 등급할인을 인자로 받는다는 점(`pricing.py:428-437`)은, 코드가 아직 데이터가 없는 경로를 이미 열어둔 상태임을 뜻한다.

### 3. 가격 관련 테이블(`t_prc*`)의 채움 정도 — [HARD] 돈 크리티컬

4단 사슬(`t_prc_price_formulas` → `t_prc_formula_components` → `t_prc_price_components` → `t_prc_component_prices`) 실측(`_evidence:76-87`):

| 지표 | 값 |
|---|---:|
| 라이브 상품(del_yn≠Y) | 288 |
| 가격공식이 바인딩된 상품 | **171 (59.4%)** |
| 가격공식 총수 | 110 |
| 구성요소가 1개 이상 붙은 공식 | 109 (빈 공식 **1개**) |
| 가격구성요소 총수 | 202 |
| 단가행이 1행 이상 있는 구성요소 | 170 → **단가행 0인 구성요소 32개** |
| 어떤 공식에도 배선된 구성요소 | 123 → **미배선(고아) 구성요소 79개** |
| 단가행 총수 | 23,573 (단가 0원 행 11개) |

상품유형별 가격공식 미바인딩(`_evidence` 재현 쿼리 참조): 완제품 66 / 반제품 37 / 기성상품 18 = 117개 상품이 가격공식 없음.

**단가행 차원 충전도**(23,573행 기준, `_evidence:88-93`):

| 차원 컬럼 | 채워진 행수 | 비율 |
|---|---:|---:|
| `min_qty` | 22,086 | 93.7% |
| `proc_cd` | 14,665 | 62.2% |
| `dim_vals`(JSONB) | 11,994 | 50.9% |
| `siz_cd` | 7,301 | 31.0% |
| `mat_cd` | 6,577 | 27.9% |
| `plt_siz_cd` | 2,279 | 9.7% |
| `print_opt_cd` | 2,227 | 9.4% |
| `siz_width` | 1,082 | 4.6% |
| `opt_cd` | 953 | 4.0% |
| `spot_side_cnt` | 532 | 2.3% |
| `coat_side_cnt` | 276 | 1.2% |
| `bdl_qty` | 114 | 0.5% |
| **`clr_cd`(도수)** | **0** | **0%** |

`dim_vals` JSONB 키 분포는 `가로`/`세로` 11,660 · `개수` 230 · `줄수` 80 · `구수` 18 · `타공수` 6 (`_evidence:158-166`).

→ **관측: 물리 차원 컬럼 13개 중 실질 사용은 5개 미만이고, 도수(`clr_cd`)는 FK·인덱스까지 갖췄으나 단가행에서 전혀 쓰이지 않는다.** 실제 가변 차원은 상당 부분 `dim_vals` JSONB(가로/세로)로 이동했다.

**계산 의미론의 소재**: `t_prc_price_formulas` 컬럼은 `frm_cd, frm_nm, note, use_yn, reg_dt, upd_dt` 6개뿐 — **계산방식/연산자 컬럼 없음**(`models.py:267-278`). 연산 힌트는 두 곳에만 존재한다:
- `t_prc_formula_components.addtn_yn`(가산 여부) — Y 201 / N 24 / **NULL 7**(`_evidence:121-125`)
- `t_prc_price_components.prc_typ_cd`(단가형 PRICE_TYPE.01=130, 합가형 .02=47, .03=25) + `use_dims` JSONB(`models.py:249-252`, `_evidence:113-119`)

나머지 산술은 `raw/webadmin/webadmin/catalog/pricing.py:428` `evaluate_price()`(1,003줄 파일) 안에 있다.

### 4. 옵션/제약 관련 테이블의 채움 정도

라이브 288 상품 기준 축별 커버리지(`_evidence:94-99`):

| 축 | 커버 상품수 | 비율 |
|---|---:|---:|
| 카테고리 귀속 | 275 | 95.5% |
| 자재 | 268 | 93.1% |
| 사이즈 | 240 | 83.3% |
| 공정 | 217 | 75.3% |
| **CPQ 옵션그룹** | **150** | **52.1%** |
| CPQ 옵션 | 149 | 51.7% |
| 인쇄옵션 | 130 | 45.1% |
| **제약규칙** | **34** | **11.8%** |

옵션그룹 없는 상품 140개의 유형 분포: 완제품 88 / 반제품 40 / 기성상품 12.

`t_prd_product_option_items` 906행의 폴리모픽 참조차원(`ref_dim_cd`) 분포 — 자재 469 / 공정 250 / 사이즈 117 / 도수 58 / 묶음수 10 / 셋트 2, **판형(OPT_REF_DIM.02)은 0건**. `ref_key1` NULL/빈값은 **0건**(폴리모픽 링크 자체는 건전).

제약규칙 `t_prd_product_constraints` 82행 중 논리삭제 미포함 라이브 60행, 상품 34개.

→ **판정: "고객이 무엇을 고를 수 있는가"(CPQ)는 절반, "고를 수 없는 조합은 무엇인가"(제약)는 1/8만 채워져 있다.**

### 5. models.py 정의 vs 실제 스키마 드리프트

기계적 대조(models.py 파싱 → `information_schema.columns` 534행과 비교):

| 항목 | 결과 |
|---|---|
| models.py db_table 선언 | 46개 (47 클래스, `TPaperMaterials`는 proxy) |
| 라이브에 실재하지 않는 db_table | **0** |
| 테이블별 컬럼 차이 (models.py 전용) | 23건 — 전부 `pk`(`models.CompositePrimaryKey`, 물리 컬럼 아님, 예: `models.py:103`) |
| 테이블별 컬럼 차이 (라이브 전용) | **0** |
| models.py 미정의 라이브 릴레이션 | 2개 — `vc_product_detail_publications`, `vc_v_product_detail_tabs` (뷰/파생, ORM 대상 아님) |

→ **컬럼 수준 드리프트 0.** 단, 이는 `managed = False` + inspectdb 파생 구조의 필연이다(`models.py:1-7`). **진짜 드리프트는 "코드 vs DB"가 아니라 "설계 문서 vs DB"에 있다** — `.moai/project/db/schema.md:1-24`는 `_TBD_` 템플릿, `.moai/project/db/erd.mmd`·`seed-data.md`·`rls-policies.md`도 동일 계열 산출물이고, DDL의 실체는 `raw/webadmin/sql/` 의 **91개 순차 마이그레이션 파일**(`01a_tables_master.sql` ~ `85_tmpl_combo_dims.sql`)에 흩어져 있다. 즉 **단일 권위 스키마 문서가 존재하지 않는다.**

---

## 구조 해설

라이브 스키마는 다음 5층으로 읽힌다.

1. **기초 마스터층** — `t_cod_base_codes`(148행, enum 전체의 단일 저장소), `t_cat_categories`(327), `t_siz_sizes`(629), `t_mat_materials`(660), `t_proc_processes`(168), `t_clr_color_counts`(9), `t_prt_print_options`(13). "세상에 어떤 것들이 있는가"의 어휘집이다. `t_cod_base_codes` 는 `PRD_TYPE.01~05`, `OPT_REF_DIM.01~07`, `PRC_COMPONENT_TYPE.01~07`, `PRICE_TYPE.01~03` 같은 **온톨로지 축 자체를 데이터로** 들고 있다(`_evidence` 재현 쿼리).
2. **상품 정의층** — `t_prd_products`(305) + 상품별 N:M 결합 9종. "이 상품은 무엇으로 구성되는가".
3. **CPQ 옵션층** — `t_prd_product_option_groups/options/option_items` + `t_prd_product_constraints`. 폴리모픽 `ref_dim_cd`+`ref_key1/2` 로 1층·2층의 차원을 참조한다. 무결성은 DB 함수 `fn_chk_opt_item_ref()` 로 지킨다.
4. **가격 엔진층** — 4단 사슬 + 할인 2종. 단가행이 10개 물리 차원 + `dim_vals` JSONB 로 다차원 매칭된다. 판형 계산만 DB 함수(`fn_calc_pansu`, `fn_best_plate`, `fn_best_plate_default`)로 내려와 있다.
5. **부수층** — 위젯(`t_wgt_*`), Edicus 연동(`t_prd_edicus_configs` 91 / `t_prd_edicus_templates` 233), 비서 로그(`t_ast_*`), Django 운영 테이블.

핵심 비대칭: **1~3층은 선언적 데이터로 완전히 표현되지만, 4층의 "계산"만 데이터 밖(pricing.py)에 있다.** 그리고 5층 너머 — 주문·생산·납기 — 는 테이블 자체가 없다.

---

## 결함·공백

| # | 결함 | 근거 | 성격 |
|---|---|---|---|
| F1 | **가격공식 미바인딩 상품 117개**(288 중 41%) — 완제품 66 포함 | `_evidence:76-81` | 돈 크리티컬 공백 |
| F2 | **고아 가격구성요소 79개** — 단가행은 있으나 어떤 공식에도 미배선 → 계산에 절대 반영 안 됨 | `_evidence:82-87` | 배선 결함 |
| F3 | **단가행 0인 구성요소 32개** — 공식에 붙어도 0원 또는 strict 모드 차단 | 동일 | 데이터 공백 |
| F4 | **구성요소 0개인 공식 1개** — 호출 시 무조건 0원 | 동일 | 배선 결함 |
| F5 | **`addtn_yn` NULL 7건** — 가산/비가산 미확정. `evaluate_price` 의 silent 합산 위험 | `_evidence:121-125` | 의미 결측 |
| F6 | **`comp_typ_cd` NULL 4건** — 구성요소 유형 미분류 | `_evidence:100-112` | 의미 결측 |
| F7 | **`use_dims` NULL 1건**(PRICE_TYPE.01) — 차원 매칭 검증 불가 | `_evidence:113-119` | 의미 결측 |
| F8 | **제약규칙 커버리지 11.8%**(34/288) — "불가능한 조합"의 지식이 거의 없음 | `_evidence:94-99` | 온톨로지 공백 |
| F9 | **CPQ 옵션그룹 커버리지 52%** — 140개 상품은 고객 선택지가 정의 안 됨 | 동일 | 온톨로지 공백 |
| F10 | **`clr_cd`(도수) 단가행 사용 0건** — FK·인덱스는 있으나 죽은 차원 | `_evidence:88-93` | 스키마-데이터 괴리 |
| F11 | **`OPT_REF_DIM.02`(판형) 옵션항목 0건** — 코드값만 존재 | 실측 `ref_dim_cd` 분포 | 미사용 축 |
| F12 | **운영 스키마에 백업 테이블 97개**(전체 154 중 63%) — `bak_*`/`z_bak_*` | `_evidence:70-74` | 위생 결함 |
| F13 | **단일 권위 스키마 문서 부재** — `.moai/project/db/schema.md` 는 `_TBD_` 템플릿, 실체는 sql/ 91파일에 분산 | `.moai/project/db/schema.md:1-24`, `raw/webadmin/sql/` 실측 | 문서 드리프트 |
| F14 | **고객·등급 축 0행** — `t_cus_customers`, `t_dsc_grade_discount_rates` 빈 그릇인데 `evaluate_price(grade_cd=...)` 는 이미 인자를 받음 | `_evidence:8-69`, `pricing.py:428` | 미구현 경로 |

---

## 월드모델 관점 판정

**판정: 이 영역은 (3) 지식/온톨로지가 주(主), (2) 심볼릭이 부(副)이며, (4) 월드모델은 가격 축에서만 부분 성립하고, (1) 뉴로는 0이다.**

**(1) 뉴로 — 0.** 라이브 스키마 46개 `t_*` 어디에도 임베딩·벡터·가중치·모델 아티팩트 컬럼이 없다. `pgvector` 등 확장 사용 흔적도 없다(사용자 함수 5개 전부 결정론적 판형/타임스탬프 함수 — `_evidence:127-137`). `t_ast_chat_logs`(190행)·`t_ast_issue_reports`(4행)는 LLM 비서의 **운영 로그**이지 도메인 추론 장치가 아니다.

**(2) 심볼릭 — 성립하나 절반이 DB 밖.** DB 안의 심볼릭 규칙은 실재한다: CHECK 58 · FK 86 · NOT NULL 228 · 트리거 46 · `fn_chk_opt_item_ref()` 참조 무결성 함수 · `fn_calc_pansu`/`fn_best_plate` 판형 계산 함수 · `t_prd_product_constraints` JSONLogic 제약. 그러나 **핵심 연산자는 데이터가 아니다** — `t_prc_price_formulas` 에 계산방식 컬럼이 없고(`models.py:267-278`), 실제 산술은 `pricing.py:428 evaluate_price()` 에 있다. DB가 들고 있는 연산 정보는 `addtn_yn`(가산 여부)과 `prc_typ_cd`(단가형/합가형) 두 플래그뿐이며 그마저 NULL 7건·4건이 있다(F5·F6).

**(3) 지식/온톨로지 — 가장 강한 층, 그러나 커버리지 구멍.** `t_cod_base_codes`(148행)가 축 자체를 데이터로 들고(`PRD_TYPE`, `OPT_REF_DIM`, `PRC_COMPONENT_TYPE`, `PRICE_TYPE`), 자재 660·사이즈 629·공정 168 마스터가 어휘를 채우고, 상품별 N:M 결합 5,000여 행이 "이 상품은 무엇으로 구성되는가"를 선언한다. 폴리모픽 `ref_dim_cd`+`ref_key1`(906행, NULL 0건)은 온톨로지적 링크로 건전하다. 다만 **부정 지식(무엇이 불가능한가)은 11.8%만 존재**(F8)하고, 선택 가능 공간 자체가 52%만 정의됐다(F9).

**(4) 월드모델(행동→결과 예측) — 가격 축에서만 부분 성립.** 성립하는 예측은 하나뿐이다: `(상품, 옵션 선택, 수량) → 최종가`. 이는 `evaluate_price()`(`pricing.py:428-437`)가 `t_prc_*` 상태를 읽어 결정론적으로 산출하는 진짜 전이 함수다. 그러나

- **커버리지가 59%다** — 라이브 288 상품 중 171개만 공식이 바인딩돼 있어, 41%의 상품은 "행동을 넣어도 결과가 나오지 않는다"(F1).
- **전이 함수가 DB 밖에 있다** — DB만으로는 미래를 예측할 수 없고, `pricing.py` 1,003줄이 있어야 한다. 세계의 *상태*는 DB에, *동역학*은 코드에 갈라져 있다.
- **가격 외 결과 축은 전무하다.** 라이브 46 테이블 어디에도 납기/리드타임/수율/불량률/설비부하/재고 테이블이 없다(`_evidence:8-69` 전수 목록). "이 주문을 넣으면 언제 나오는가", "이 조합이 물리적으로 제작 가능한가"는 **예측 불가**다. 제작 가능성은 `t_prd_product_constraints` 60행(34상품)이 부분적으로만 부정 지식으로 표현한다.
- **행동의 주체와 결과 기록이 없다.** `t_cus_customers` 0행, 주문 테이블 부재 → 실제 행동 이력이 축적되지 않으므로, 예측을 관측으로 교정하는 루프(모델 갱신)가 구조적으로 불가능하다.

**요약 좌표**: 이 DB는 **잘 정규화된 제품 온톨로지 + 부분적으로 배선된 가격 전이 함수**이며, 월드모델로서는 *가격 1축*만 얕게 성립한다. 월드모델화의 다음 임계는 두 가지다 — ① 전이 함수를 DB로 끌어내리거나(공식 계산방식의 데이터화) 최소한 코드-데이터 계약을 명시화, ② 결과 축(납기·제작가능성)을 상태로 도입.

> [추정] "전이 함수를 DB로 끌어내려야 한다"는 방향 자체는 본 진단에서 관측한 구조(공식 테이블의 연산자 컬럼 부재 + `addtn_yn`/`prc_typ_cd` 부분 데이터화)로부터의 **해석**이며, 실제로 그것이 옳은 설계 선택인지는 본 진단으로 검증하지 않았다.

---

## 미확인

- **`evaluate_price()` 실행 결과 미관측.** 가격 계산은 Python 함수(`pricing.py:428`)이고 DB 함수가 아니므로, 읽기 전용 SELECT만으로는 재계산 검증이 불가능했다. F1~F7이 실제로 어떤 상품에서 어떤 오차를 내는지는 **본 진단의 범위 밖**이다(§13/§15/§18 하네스 소관).
- **`t_prd_products.del_yn='Y'` 17건의 성격 미확인** — 논리삭제 사유·복구 대상 여부를 조사하지 않았다.
- **97개 백업 테이블의 삭제 가능성 미판정** — 참조/의존 여부를 조사하지 않았다. 위생 결함(F12)으로만 기록했고 정리 제안은 하지 않는다.
- **`bak_*` 를 제외한 154→46 축약 과정에서 Django 시스템 테이블 10개의 상세는 미조사**(운영 무관 판단).
- **sql/ 91개 마이그레이션 파일 전문 미독해.** 파일 목록(`01a`~`85`)과 존재만 확인했고, 각 파일이 라이브에 실제 적용됐는지는 **컬럼 집합 일치(드리프트 0)로 간접 확인**했을 뿐 파일별 대조는 하지 않았다.
- **인덱스 46개 트리거의 개별 동작 미확인** — 개수만 실측했다.
- **웹 검색 미사용** — 따라서 Sources 절 없음. 모든 근거는 로컬 파일과 라이브 DB 직접 관측이다.
