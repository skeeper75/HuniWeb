# webadmin 변경 추적 → 데이터 매핑 가능성 분석 — round-23 Track A

> **작성** 2026-06-17 · round-23 Track A (dbm-schema-change-tracking / round-14 모드)
> **프레임(HARD):** 3-way 정합 — ① git 선언(webadmin `raw/webadmin`, HuniProductPrice2) ② 라이브 적용(Railway `railway` read-only psql, 2026-06-17 실측) ③ 우리 dbmap 산출 영향(stale + 새 매핑 가능).
> **베이스라인 → HEAD:** 우리 가격 산출 분석 시점 `d6026be`(2026-06-09, sql/01a~25 구조·`clr_cd` 단가차원·8컬럼 자연키) → HEAD `b85e376`(2026-06-17). 핵심 변경 = sql/27·28·29 + price_views.py 공정/인쇄옵션 모델 전환 + Phase 11 엔진 구현.
> **권위·안전:** webadmin = read-only oracle(수정 0). DB 쓰기 0. 라이브 비밀값 비노출. "컬럼 존재 ≠ 적용 완료"(DDL/백필 분리).

---

## 0. 핵심 5줄 (결론 먼저)

1. **단가 자연키가 6차원(8컬럼) → 11차원(12컬럼+dim_vals)으로 확장됨** — 라이브 실측 자연키 인덱스가 `siz_cd, plt_siz_cd, clr_cd, mat_cd, proc_cd, opt_cd, print_opt_cd, coat_side_cnt, bdl_qty, min_qty` + dim_vals. **선언·DDL·백필 전부 적용 완료**(컬럼만 아님).
2. **`plt_siz_cd`(판형사이즈) 신설·백필 1,219행** — 사이즈정보 중 `impos_yn='Y'`(조판판형) 전용 축. **실사 면적매트릭스의 가로×세로 매트릭스는 여전히 `siz_cd`**(plt_siz_cd 0건) → 우리 silsa A안 무영향. plt_siz_cd는 별색/디지털 인쇄비 블록 전용(전지 316x467·300x625 2종).
3. **`clr_cd`(도수) 단가차원 폐기 → `print_opt_cd`(인쇄옵션 전역 마스터 `t_prt_print_options` 7행) 전환** — 단가행 `clr_cd` 0건(도수 단가행 424개 DELETE 후 인쇄옵션 기준 재적재), use_dims의 `clr_cd` 토큰 0·`print_opt_cd` 12·`plt_siz_cd` 11. **디지털/별색 인쇄비 전건 새 모델로 재적재 완료.**
4. **공정 `proc_sel`(1개 고정) → `proc_grp`(그룹 범위) 모델 전환·use_dims proc_grp 토큰 35건**(proc_sel 0) + 단가 `proc_cd`·`opt_cd` 차원 백필(proc=1,866·opt=30행). 공정 상세옵션 상위 상속.
5. **Phase 11 가격엔진 `evaluate_price` 구현 완료**(`webadmin/catalog/pricing.py` 23KB·`NON_QTY_DIMS`에 plt_siz_cd/print_opt_cd 포함·시뮬레이터 UI 활성·`tools/test_pricing.py` 존재·커밋 01f2394 "엔진 test_pricing 38 passed"). **단가형/합가형·우선순위·할인 순차곱 전부 코드 존재 → 실 가격계산 경로 열림.** (단 venv 부재로 본 세션 직접 실행 미수행 — 코드+커밋 근거 판정.)

---

## 1. 변경 항목별 3-way 정합표

| # | 변경 | git 선언(커밋·파일:라인) | 라이브 적용(DDL / 백필) | 우리 산출 영향 | 심각도 |
|---|------|--------------------------|--------------------------|----------------|--------|
| C1 | **인쇄옵션 마스터 신설** `t_prt_print_options` | `d92f706`+`df195c8`+`81c9f88`+`7b19243` · sql/27:8-21 (CREATE TABLE) | ✅ DDL 적용 · ✅ 백필 **7행**(POPT_000001~007: 단면/양면/풀빼다/배면양면/투명테두리 시드 5 + 양면9도·단면7도 운영추가 2) | 우리 산출에 이 테이블 미존재(전부 `clr_cd` 도수축으로 모델) → 인쇄면/도수 통합 매핑 경로 신규 | MAJOR |
| C2 | **상품 인쇄옵션 FK 재연결** `t_prd_product_print_options.print_opt_cd` | `d92f706` · sql/27:35-45 (ADD COLUMN + FK + 조합매칭 UPDATE) | ✅ DDL · ✅ 백필 **166/166행** FK 채움 | 상품별 opt_id 의미 상품마다 다름 문제 해소 — 인쇄면을 전역 코드로 매핑 가능 | MAJOR |
| C3 | **단가차원 도수→인쇄옵션** `clr_cd` 폐기 / `print_opt_cd` 신설 | `c1924df` · sql/28:7(clr_cd행 DELETE)·17-26(print_opt_cd 컬럼+FK+nat_key 재생성)·10-13(use_dims 토큰 치환) | ✅ DDL · ✅ 백필: 단가 `clr_cd`=**0행**(424행 삭제·백업 `sql/_backup_digital_clr_rows_20260617.json`) / `print_opt_cd`=**1,431행** · use_dims clr_cd 토큰 **0** | **우리 `00_schema/price-engine-ddl.md` §4 "clr_cd=도수 축" + 8컬럼 자연키 전부 STALE.** 126 md가 clr_cd 참조 | **CRITICAL** |
| C4 | **단가차원 판형사이즈 신설** `plt_siz_cd` | `e18eea8` · sql/29:8-16 (ADD COLUMN + FK→t_siz_sizes + nat_key 재생성) | ✅ DDL · ✅ 백필 **1,219행**(별색·디지털 인쇄비 블록) · distinct 2(전지 316x467·300x625, impos_yn='Y') | silsa 면적매트릭스는 siz_cd 유지(plt 0건) → **silsa A안 무영향**. 단 별색/디지털 가격 매핑은 새 축 반영 필요 | MAJOR |
| C5 | **공정 proc_sel→proc_grp** + 상세옵션 상위 상속 + 단가 proc_cd/opt_cd 차원 | `01f2394`(price_views.py:전반)·`eb1e0ce`·`02e414f` | ✅ use_dims `proc_grp:` 토큰 **35**(proc_sel 0) · 단가 `proc_cd`=**1,866행**·`opt_cd`=**30행** 백필 | round-2/16 가격공식의 공정 차원 모델(proc_sel·1고정) 기술 STALE | MAJOR |
| C6 | **frm_typ_cd 폐기** | `06cdcbc` · sql/25 | ✅ 적용(라이브 `t_prc_price_formulas.frm_typ_cd` 컬럼 부재 실측) | round-16/17이 이미 "frm_typ_cd 라이브 부재" 기록 → **이미 인지·추가 stale 없음** | NONE |
| C7 | **마스터-디테일 UI + 기초코드 제네릭 통합** | `7753d7e`·`b85e376` · admin.py·views.py | UI only(스키마 무변경) | admin UI 명세(round-8) 화면 구조 변경 — 데이터 매핑 무관 | MINOR |
| C8 | **Phase 11 가격엔진** `evaluate_price` | `pricing.py`(신규 23KB)·`price_views.py` 시뮬레이터·`tools/test_pricing.py`(15KB)·Phase11 PLAN/CONTEXT | ✅ 코드 존재·NON_QTY_DIMS 신차원 포함·시뮬 UI 활성(placeholder 제거 실측)·커밋 "38 passed". template_prices·product_prices=0행(직접단가 미적재, 공식 경로만) | **실 가격계산 경로 확정** — 우리 round-2/16 산출의 단가행을 엔진이 실제로 소비 | MAJOR(긍정) |

---

## 2. 데이터 매핑 가능 부분 보드 (변경이 열어준 매핑 경로)

webadmin 변경이 실사·인쇄 가격을 **매핑/적재 가능하게** 만든 지점:

| 매핑 대상 | 변경 전(베이스라인) | 변경 후 열린 경로 | 매핑 가능성 | 근거 |
|-----------|---------------------|-------------------|-------------|------|
| **인쇄면(단/양면)·도수 통합** | 단/양면 전용축 없음·도수 clr_cd 5종(별색 자리 없음, 우리 §6 G-1/G-2 fit-gap) | `print_opt_cd` 전역 마스터 — 단면/양면/양면9도/별색 인쇄면을 **1축으로** 단가 매칭 | ✅ **즉시 가능** — 7행 마스터 존재·166 상품 FK·1,431 단가행 | sql/27·28·라이브 백필 |
| **판형사이즈(전지) 가격축** | siz_cd 단일 — 작업사이즈와 전지 혼동 | `plt_siz_cd`(impos_yn='Y') 전용축 — 사이즈 + 판형사이즈 동시 단가 매칭 | ✅ **즉시 가능** — 1,219행 백필·DIM_FK_FILTER로 UI 필터 | sql/29·price_views.py:44-46 |
| **공정 그룹 단가** | proc_sel 1개 고정(그룹 표현 불가) | `proc_grp` 그룹범위 + 하위공정 컬럼값 + 상위 상속 상세 → 공정군 단가표 매핑 | ✅ **가능** — proc_cd 1,866행·proc_grp 토큰 35 | 01f2394·price_views.py:564-607 |
| **공정 상세 파라미터(줄수·개수)** | 단가행에 표현 한계 | `dim_vals` jsonb(자연키 포함) — 오시 줄수·미싱 개수 등 그룹 공통 상세 | ✅ 가능 — nat_key에 dim_vals 포함(라이브 실측) | sql/29·use_dims proc_grp |
| **실 가격계산(견적)** | 엔진 미구현(가격뷰어 ⑤ placeholder) | `evaluate_price(target, selections, qty)` — 단가행→공식→최종가 | ✅ **경로 확정**(코드·시뮬 UI) — 단 직접단가/템플릿단가 0행이라 **공식(FORMULA) 경로만** 실효 | pricing.py:198·Phase11 PLAN |
| **실사 면적매트릭스 적재** | (우리 silsa A안 = siz_cd 좌표) | 변경 없음 — siz_cd 유지(plt_siz_cd는 별색/디지털 전용) | ✅ **A안 그대로 유효** — 신차원 영향 0 | COMP_POSTER% siz_cd 86행·plt 0행 |

**실사 트랙 핵심:** 이번 webadmin 변경은 silsa 면적매트릭스(siz_cd)를 **건드리지 않음**. 새 축(plt_siz_cd/print_opt_cd)은 인쇄비·별색 블록 전용. 따라서 **silsa-quote-design A안(siz_cd 좌표 채번) 설계는 그대로 유효**. 단 silsa 가격공식이 인쇄/코팅/후가공 구성요소를 합산형으로 배선할 때, 그 인쇄 구성요소(있다면)는 새 print_opt_cd/proc_grp 모델을 따라야 정합.

---

## 3. stale 영향 매트릭스 (갱신 필요한 우리 가격 산출)

| 우리 산출 | stale 부분 | 무엇이 틀렸나 | 심각도 | 갱신 방향 |
|-----------|------------|---------------|--------|-----------|
| `00_schema/price-engine-ddl.md` | §4 "6차원 의미" 표·§"자연키 8컬럼"·§5 흐름도·G-1/G-2 fit-gap | 자연키 8→12컬럼·clr_cd 폐기·print_opt_cd/plt_siz_cd/proc_cd/opt_cd 신설. G-1(별색 자리 없음)·G-2(단/양면 축 없음)는 **print_opt_cd로 해소됨** | **CRITICAL** | §4를 11차원+dim_vals로 재작성·자연키 12컬럼 갱신·G-1/G-2를 "RESOLVED(print_opt_cd)"로 |
| round-2 가격 산출(`02_mapping/*`) | clr_cd=도수 단가차원 매핑·디지털인쇄비 clr 기반 | 디지털/별색 인쇄비가 clr_cd→print_opt_cd로 재적재됨(라이브 단가 clr=0행) | MAJOR | 디지털·별색 매핑을 print_opt_cd 기준으로 재기술 |
| round-16 price-import(`20_price-import/*`) | "8차원"·proc_sel·clr_cd 기반 분해(8개+ 파일) | 차원 수·공정 모델 변경 | MAJOR | 차원 표를 11차원으로·proc_sel→proc_grp |
| round-23 silsa(`silsa-dimension-analysis.md`·`silsa-quote-design.md`) | 면적매트릭스 siz_cd 부분 | **무변경 — A안 유효**. 단 인쇄/후가공 구성요소 배선 시 신모델 참조 필요 | MINOR | siz_cd 축은 유지·인쇄 구성요소 배선만 print_opt_cd/proc_grp 참조 주석 |
| round-23 `component-inventory.md`·`grouping-*`·`_exec/apply.sh` | clr_cd/print_side/proc_sel 참조 | 신모델 미반영 | MAJOR | print_opt_cd/proc_grp 기준 재확인(grouping-recheck 후속) |
| 전역(126 md clr_cd · 112 md print_side) | 도수 단가축·print_side 단가컬럼 | clr_cd 단가축 폐기·print_side는 component_prices에서 DROP(인쇄옵션 마스터로 이전) | MAJOR(분산) | 가격 맥락의 clr_cd/print_side는 print_opt_cd로 라우팅(상품 도수 표현 자체는 t_clr 유지) |

> **주의(과교정 금지):** `clr_cd`/`print_side`는 **단가 차원**으로서만 폐기됐다. 인쇄옵션 마스터(`t_prt_print_options`)가 여전히 `front_colrcnt_cd`/`back_colrcnt_cd`로 `t_clr_color_counts`를 참조하고, `print_side` 컬럼도 마스터에 보존된다(component_prices에서만 DROP). 상품 도수/인쇄면 표현 자체는 살아있음 — 갱신은 "단가 매칭 축" 맥락에 한정.

---

## 4. Phase 11 evaluate_price 구현 상태 판정

| 판정 축 | 상태 | 근거 |
|---------|------|------|
| 엔진 코드 존재 | ✅ **구현** | `webadmin/catalog/pricing.py` 23KB · `def evaluate_price`/`match_component`/`round_won`/`component_subtotal`/`_evaluate_formula` 전부 존재 |
| 신차원 반영 | ✅ | `NON_QTY_DIMS=(siz_cd, plt_siz_cd, print_opt_cd, mat_cd, proc_cd, opt_cd, coat_side_cnt, bdl_qty)` — sql/27~29 신축 전부 소비 |
| 단가형/합가형 | ✅ | `PRC_TYPE_UNIT=PRICE_TYPE.01`·`PRC_TYPE_TOTAL=PRICE_TYPE.02`·`component_subtotal` 합가 환산(÷tier_min_qty) |
| 우선순위/할인 | ✅ | 템플릿단가→상품직접단가→공식(FORMULA) · 수량구간→등급 순차곱 (pricing.py:236-287) |
| 시뮬레이터 UI | ✅ **활성** | price_viewer.html ⑤ placeholder 제거·sim-meta/simulate fetch 실측(228·501·571행) |
| 테스트 | ✅ 존재(미실행) | `tools/test_pricing.py`(evaluate_price 호출)·커밋 01f2394 "엔진 test_pricing 38 passed". **본 세션 venv 부재로 직접 실행 미수행 → 코드+커밋 근거 판정(날조 아님).** |
| **실 가격계산 가능 시점** | ✅ **지금 가능(공식 경로)** | 단 `t_prd_product_prices`=0행·`t_prd_template_prices`=0행 → 직접단가·템플릿단가 경로는 데이터 없음. **공식(FORMULA)+component_prices 경로만 실효**. silsa는 공식 경로이므로 단가행만 채우면 견적 산출 가능 |

**종합 판정: Phase 11 evaluate_price = 구현 완료(엔진+시뮬+테스트 코드). 실 가격계산 경로 열림. 제약 = 데이터(직접/템플릿단가 0행·일부 공식 배선 단절[silsa 27상품 등]).** 즉 **엔진이 막힌 게 아니라 단가 데이터가 채워지면 곧 견적 가능**. 이것이 round-23 silsa 트랙이 단가행을 채우는 작업의 가치를 직접 입증한다.

---

## 5. 게이트 인계 (dbm-validator W1~W6)

- W1 베이스라인: `d6026be`(우리 가격 산출이 본 8컬럼 자연키·clr_cd 단가축 시점) → HEAD `b85e376`. sql 27/28/29 미존재 시점 = d6026be 이전 교차검증 가능.
- W2 변경분류: sql/25·27·28·29 + price_views/admin/pricing 커밋 8건 모두 §1에 분류(해시 실재).
- W3 라이브 대조: §1 백필 수치 전부 read-only psql 재현 대상(자연키 인덱스 12컬럼·print_opt 7행·clr 0행 등).
- W4 영향: clr_cd 126·print_side 112 md grep 전수 + price-engine-ddl §4.
- W5 DDL/백필 분리: 본 분석은 전 항목 백필 실측 수치 동반(0행 미적용 = 직접/템플릿단가만, 정직 표기).
- W6 갱신 라우팅: §3 갱신 방향이 HEAD 스키마(11차원)와 정합·기존 silsa siz_cd 사슬 무손상.

**산출 한정:** 본 라운드는 추적·영향·매핑가능 식별까지. 실제 우리 산출 갱신·DB 적재·webadmin 수정은 별도(인간 승인).
