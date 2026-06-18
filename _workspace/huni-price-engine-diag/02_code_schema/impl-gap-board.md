# impl-gap-board — 3-way 갭 보드 (Phase 1)

**진단가:** hped-code-schema-auditor · **일자:** 2026-06-18
설계 ↔ 코드 ↔ 라이브 DB 불일치·dead·phantom·트리거/토큰 충돌. 각 항목 file:line·DDL 라인·재현 SQL 증거 첨부. **진단까지만(교정·판정 보류).**

> mechanism-researcher 협업 노트: ⬛dead/👻phantom/⚠️비대칭은 "장치가 원리상 무엇을 해야 하나"의 확신도 근거로 쓰라고 명료히 기록함.

---

## G-1 [👻 phantom-DDL] `dim_vals` 컬럼 — 라이브·코드·모델엔 있으나 정식 ADD COLUMN DDL 부재

- **코드:** pricing.py:75 `_dv_key`·:87 `_row_matches`·:95 `_combo_key`·:194 `_component_rows` SELECT. 공정 상세 파라미터 {키:값} 정확매칭(와일드카드 없음)의 핵심.
- **모델:** models.py:194 `dim_vals = models.JSONField(...)`·:201 unique_together 포함.
- **라이브:** information_schema 실측 — `t_prc_component_prices` ordinal 16 `dim_vals jsonb`, comment '차원값(공정상세 파라미터 등 동적 차원)', **310행 사용**.
- **설계/DDL:** `sql/*` 어디에도 `ALTER TABLE … ADD COLUMN dim_vals` 없음. sql/28·29/32의 unique 인덱스 식 `((COALESCE(dim_vals,'{}'::jsonb))::text)`에서만 참조 — 즉 인덱스 생성이 성공하려면 **컬럼이 이미 존재**해야 하므로 out-of-band ALTER로 라이브에 직접 추가된 것(frm_typ 제거와 동형 패턴, 메모리 [[dbmap-schema-change-round14]] "라이브 ad-hoc" 교훈).
- **재현:** `grep -rn "ADD COLUMN.*dim_vals" raw/webadmin/sql/` → 0건. 라이브 `select count(dim_vals) from t_prc_component_prices` → 310.
- **사실(판정 아님):** 코드·모델·라이브는 3원 정합(✅). repo DDL만 누락 — 신규 DB 재구축 시 dim_vals 컬럼이 안 생겨 인덱스 생성 실패 위험. **DDL stale/phantom**.

## G-2 [⚠️ 비대칭 처리] use_dims 그룹 토큰(`proc_grp:`·`opt_grp:`) 코드 두 곳 불일치

- **코드 A** `_match_entry`(pricing.py:412-413): `non_qty_dims = [d for d in use_dims if d != "min_qty" and not d.startswith("opt_grp:")]` — **`proc_grp:`·`proc_sel:`을 스트립하지 않음**. → proc_grp 토큰이 실제 차원으로 오인되어 "판별차원 없음" 분기(:414)를 통과시킬 수 있고, `proc_grp:PROC_xxx`가 차원으로 남음.
- **코드 B** `_evaluate_formula`(pricing.py:460): `non_qty = [d for d in use_dims if not (":" in d)]` — 모든 `xxx:` 토큰을 일괄 스트립(opt_grp·proc_grp·proc_sel 전부). is_proc 판정은 정확.
- **price_views.py:55-57**: `OPT_GRP_PREFIX`·`PROC_GRP_PREFIX`·`_SCOPE_KEYS=("opt_grp","proc_grp","proc_sel")` — 뷰어는 세 스코프 모두 명시 분리(split_use_dims:61).
- **라이브:** use_dims에 `proc_grp:PROC_xxxxx` 보유 comp **36개**(예: `["proc_cd","min_qty","proc_grp:PROC_000017"]`).
- **재현:** `select count(distinct comp_cd) from t_prc_price_components where use_dims::text like '%proc_grp:%'` → 36.
- **사실:** A는 `opt_grp:`만, B는 `:` 일반, 뷰어는 3종 명시 — 토큰 스트립 기준이 세 지점에서 다름. A의 "판별차원 없음" 라벨(:415)이 proc_grp comp에서 잘못 안 붙을지는 추가 추적 필요. **비대칭 사실 기록.**

## G-3 [⬛ dead-data] `clr_cd` — 컬럼·FK 존재·코드 미참조·라이브 0행

- **설계:** prcx01-pricing-model.md §6·pricing-erd.md:46 — clr_cd(도수)는 인쇄비 핵심 차원(설계 LOCKED).
- **코드:** pricing.py NON_QTY_DIMS(:38)에 **clr_cd 없음**. 엔진 매칭에서 완전 배제. (sql/28 주석: clr_cd→print_opt_cd 전환, 컬럼 잔존.)
- **라이브:** `t_prc_component_prices.clr_cd varchar NULL` 존재 + FK, 하지만 `count(clr_cd)=0` (sql/28이 `DELETE … WHERE clr_cd IS NOT NULL` 424행 삭제).
- **재현:** `select count(clr_cd) from t_prc_component_prices` → 0.
- **사실:** clr_cd는 컬럼·FK·unique 인덱스 멤버로 남아있으나 코드·데이터 양면 dead. 도수 차원 역할은 `print_opt_cd`(인쇄옵션, front/back colrcnt 내포)로 이관. **dead vestige.**

## G-4 [⬛ dead] `addtn_yn`(가산여부) — 설계 핵심 플래그·코드 미참조

- **설계:** pricing-erd.md:39 `addtn_yn 가산여부 "char(1) (Y=합산)"` — 공식 구성요소의 합산/차감 구분. **단, 11-CONTEXT.md:23이 "addtn_yn=이번 엔진에서 무시·의도 불확실·필요해지면 차후 재정의"로 의도적 deferred 명시(우연 dead 아님).**
- **코드:** pricing.py `_evaluate_formula`(:444-475)가 formula_components를 읽을 때 `addtn_yn` SELECT·사용 **0회**(:452 values에 미포함). 공식=**무조건 전 구성요소 합산**(pricing.py:14 "공식 = 구성요소 합산").
- **라이브:** `t_prc_formula_components.addtn_yn char` — Y=299·**N=2**(PRF_CLR_ACRYL/COMP_ACRYL_CLEAR3T·PRF_COROTTO_ACRYL/COMP_ACRYL_COROTTO)·NULL=0. 직전 "301행 채워짐(전부 Y)"는 정정: N이 2행 실재.
- **재현:** `grep -n addtn_yn raw/webadmin/webadmin/catalog/pricing.py` → 0건. `select addtn_yn,count(*) from t_prc_formula_components group by 1` → Y:299·N:2.
- **사실:** 합산/차감 분기 의도가 코드에서 비활성(설계가 의도적으로 deferred). N=2행조차 엔진은 합산. 차감형(N) 표현 불가 + "잘못 묶여도 끄는" 부분 안전판조차 코드 미발화. **설계-코드 의도 불일치(deferred 플래그)** — SOT 4 제약장치 부재의 직접 증거(constraint-mechanism-gap §6).

## G-5 [❌ DDL stale] 할인유형 `dsc_typ_cd` 위치 — DDL은 details, 라이브·코드는 table master

- **설계/DDL:** sql/01a_tables_master.sql:242 — `t_dsc_discount_details.dsc_typ_cd varchar(50)` 선언(상세 단위).
- **코드:** pricing.py:488,496 — `tbl = M.TDscDiscountTables…values("dsc_typ_cd")` / `dsc_typ = tbl["dsc_typ_cd"]` — **테이블 마스터 단위**에서 읽음(pricing.py:8-9 CONTEXT 변경 ② "할인유형 정률/정액은 t_dsc_discount_tables.dsc_typ_cd 마스터 단위").
- **라이브:** `t_dsc_discount_details`에 `dsc_typ_cd` **컬럼 없음**, `t_dsc_discount_tables`에 **있음**.
- **재현:** `\d t_dsc_discount_details` → dsc_typ_cd 부재; `select dsc_typ_cd from t_dsc_discount_details` → ERROR column does not exist. `t_dsc_discount_tables` → 있음.
- **사실:** 할인유형이 상세→마스터로 이동. 코드·라이브는 정합, DDL 01a:242만 stale(옛 위치 유지). **DDL stale 불일치.**

## G-6 [⚠️ data-dead 경로] 코드 정상·라이브 데이터 0인 분기 3종

| 경로 | 코드 | 라이브 데이터 | 사실 |
|------|------|--------------|------|
| TEMPLATE_PRICE | pricing.py:292-297 | t_prd_template_prices **0행** | 템플릿단가 우선분기 미작동(데이터 없음) |
| PRODUCT_PRICE(직접단가) | pricing.py:312-317 | t_prd_product_prices **0행** | 전 상품 공식기반(직접단가 0·CLAUDE.md 정합) |
| 등급할인 | pricing.py:508-537 | t_dsc_grade_discount_rates **0행** | 등급할인 경로 데이터 미구성 |

- **재현:** 각 `select count(*) from …` → 0/0/0.
- **사실:** 코드 결함 아님. "데이터 레벨 dead"(미적재) — 검증·가격 테스트는 **FORMULA + 수량구간할인** 경로에 집중해야 유효. 향후 적재 시 활성화될 잠재 경로.

## G-7 [⚠️ near-dead] `opt_cd` 차원 — NON_QTY_DIMS 멤버·라이브 5행만

- **코드:** pricing.py:38 NON_QTY_DIMS에 opt_cd 포함(정확매칭). FK 없이 코드매칭(sql/21 주석).
- **라이브:** count(opt_cd)=5 (단일 comp `COMP_POSTEROPT_LINEN_FINISH`, use_dims `["opt_cd","min_qty"]`, 5행 전부 opt_cd 채움 → 그 comp 내에선 판별차원 정상).
- **사실:** opt_cd 차원은 전체 사슬에서 거의 미사용(린넨 마감 1 comp). "판별차원 없음"(pricing.py:415) 광역 위험은 아니나, 옵션→가격 연결이 라이브에 사실상 부재. CPQ option_items와 가격사슬 단절 가능성(전 하네스 round-7 발견과 정합 — 추가 추적 권고).

## G-8 [❌ 제약장치 부재] 상품↔구성요소 유효성 게이트 없음 (SOT 4 근본·신규)

- **사실:** 공식↔구성요소 배선(`t_prc_formula_components`)에 **prd_cd 컬럼·FK 부재**(라이브 컬럼 = frm_cd·comp_cd·disp_seq·addtn_yn·reg_dt·upd_dt만). 배선은 product-agnostic 설계.
- **코드:** 배선 인라인 폼 `_FormulaComponentsInlineForm`(admin.py:931-935) **clean() 없음**. 상품↔공식 바인딩(price_views.py:835) 검증 = 공식 존재 여부만. 엔진(pricing.py:444-475) 상품-스코프 검증 0.
- **트리거/CHECK:** 가격 6엔티티 = `fn_upd_dt` 감사 트리거뿐. **유효성 트리거·CHECK 0.**
- **유일 유사장치 `fn_chk_opt_item_ref`(sql/10:189-236):** 상품-스코프 참조 무결성을 정확히 구현하나 **CPQ option_items 전용** — 가격 공식 사슬엔 미부착. (후니가 "할 줄 알면서 가격 배선엔 안 함".)
- **라이브 실증:** comp가 광역 공유 — `COMP_PP_VARIMG_1EA` 30공식·**38상품 도달**, `COMP_PRINT_SPOT_WHITE_S1`(별색) 29공식(D-6 직결), `COMP_PAPER` 6공식·19상품. 게이트 0이라 무관 comp 묶임이 silent 합산.
- **재현:** `\d t_prc_formula_components`(prd_cd 없음) · join count §constraint-mechanism-gap §5.
- **사실(판정 아님):** 사용자 우려대로 "이 comp가 이 상품에 유효한가"를 강제하는 장치는 **코드·DDL·트리거·CHECK 어디에도 없다(부재)**. D-1/2/3 이중합산·D-6 현수막별색의 구조적 근본. → 전용 보드 `constraint-mechanism-gap.md`.

---

## 트리거 충돌 점검 결과

- `fn_chk_opt_item_ref`(메모리 [[dbmap-...]] 언급 검증 트리거): **sql/03_triggers.sql에 정의 없음**(grep 0건 — 03은 fn_upd_dt 감사 트리거만). 라이브에 다른 경로로 존재할 수 있으나 가격 6엔티티에는 트리거 미부착. pricing.py도 트리거 가정 없음 → **가격엔진 범위 내 트리거 충돌 0**. (option_items 무결성 트리거는 CPQ 영역·본 진단 범위 밖.)
- 가격 6엔티티 부착 트리거 = `fn_upd_dt` 감사 트리거뿐(formulas:99·components:105·product_prices:111·dsc_*:117/123/129). 코드 가정과 무충돌.
