# code-schema-matrix — 가격 엔티티 속성 단위 정합 매트릭스 (Phase 1)

**진단가:** hped-code-schema-auditor · **일자:** 2026-06-18
**3-way 출처:** 설계(`raw/webadmin/docs/prcx01-pricing-model.md`·`pricing-erd.md`) ↔ 코드(`raw/webadmin/webadmin/catalog/pricing.py`·`price_views.py`·`models.py`) ↔ 라이브(Railway `railway` DB, information_schema 실측 2026-06-18)
**범위:** 가격 6엔티티 + 할인 3엔티티 + 바인딩. 파일럿 상품군(엽서·실사/현수막·아크릴) 사슬에 쓰이는 속성 우선.

**정합 기호:** ✅일치 / ⚠️부분 / ❌불일치 / ⬛dead(선언됐으나 코드·데이터 미사용) / 👻phantom(코드가 쓰나 정식 DDL 부재)

**라이브 실측 헤드라인(t_prc_component_prices, total=7,293행):**
`siz_cd=4157 · clr_cd=0 · mat_cd=3342 · proc_cd=1901 · opt_cd=5 · print_opt_cd=1431 · plt_siz_cd=1219 · coat_side_cnt=92 · bdl_qty=115 · siz_width=922 · siz_height=922 · min_qty=6503 · dim_vals=310`

---

## 1. t_prc_component_prices (가격 사슬 핵심·최난도)

라이브 컬럼 21개(ordinal 17 결번=드롭됨). 코드 차원상수: `NON_QTY_DIMS`(pricing.py:38)·`TIER_DIMS`(:45)·`TIER_UPPER`(:46).

| 컬럼 | 타입(라이브) | 코드 사용처 (file:line) | 코드 가정 | 라이브 적용 | 정합 |
|------|------------|------------------------|-----------|-------------|:--:|
| comp_price_id | bigint NOT NULL | pricing.py:240,437 (matched_row 식별) | surrogate PK | 7293행 PK | ✅ |
| comp_cd | varchar NOT NULL | pricing.py:239 `_component_rows` filter | 구성요소 FK 매칭 | NOT NULL | ✅ |
| apply_ymd | varchar NOT NULL | pricing.py:128,170 `<=as_of` 시계열·최신 | 'yyyy-MM-dd' 비교 | NOT NULL | ✅ |
| siz_cd | varchar NULL | NON_QTY_DIMS(:38) 정확매칭 | NULL=와일드카드 | 4157/7293 | ✅ |
| clr_cd | varchar NULL | **코드 미참조** (NON_QTY_DIMS에 없음) | — | **0/7293** | ⬛dead |
| mat_cd | varchar NULL | NON_QTY_DIMS(:38) | NULL=와일드카드 | 3342/7293 | ✅ |
| proc_cd | varchar NULL | NON_QTY_DIMS(:38)·is_proc 분기(:461) | 공정 정확매칭 | 1901/7293 | ✅ |
| opt_cd | varchar NULL | NON_QTY_DIMS(:38) | 옵션 정확매칭(FK 없음·코드매칭) | **5/7293** | ⚠️ near-dead |
| print_opt_cd | varchar NULL | NON_QTY_DIMS(:38) | 인쇄옵션 정확매칭 | 1431/7293 | ✅ |
| plt_siz_cd | varchar NULL | NON_QTY_DIMS(:38) | 판형사이즈 정확매칭 | 1219/7293 | ✅ |
| coat_side_cnt | integer NULL | NON_QTY_DIMS(:38) | 코팅면수 정확매칭 | 92/7293 | ✅ |
| bdl_qty | integer NULL | NON_QTY_DIMS(:38) | 묶음수 정확매칭(FK없음) | 115/7293 | ✅ |
| siz_width | numeric NULL | TIER_DIMS·TIER_UPPER(:45-46) '이하' 상한 | 구간 상한 | 922/7293 | ✅ |
| siz_height | numeric NULL | TIER_DIMS·TIER_UPPER(:45-46) '이하' 상한 | 구간 상한 | 922/7293 | ✅ |
| min_qty | integer NULL | TIER_DIMS(:45) '이상' 하한·합가환산(:188) | 수량구간 | 6503/7293 | ✅ |
| dim_vals | jsonb NULL | `_row_matches`(:87)·`_dv_key`(:75)·`_combo_key`(:95) | 공정 상세 {키:값} 정확매칭(와일드카드 없음) | 310/7293 | 👻 (정식 DDL 부재·아래 §갭 참조) |
| unit_price | numeric NULL | component_subtotal(:183) | 단가형=장당가/합가형=구간총액 | NULL 허용 | ✅ |
| note | varchar NULL | price_views만 | 비고 | — | ✅ |
| reg_dt/upd_dt | timestamp | 미참조(감사) | — | — | ✅ |

**차원매칭 3원 정합(use_dims ↔ 충전차원 ↔ NON_QTY_DIMS/TIER_DIMS):**
- 코드 NON_QTY_DIMS 8개 = `siz_cd, plt_siz_cd, print_opt_cd, mat_cd, proc_cd, opt_cd, coat_side_cnt, bdl_qty` — **clr_cd 빠짐**(설계 prcx01 §6의 핵심 차원이었으나 폐기).
- use_dims 선언 토큰에 `proc_grp:PROC_xxxxx`·`opt_grp:`·`proc_grp:` 스코프 토큰 존재(라이브 36개 comp가 proc_grp 사용). pricing.py가 이 토큰을 두 곳에서 **비대칭** 처리 — §impl-gap-board G-2 참조.

---

## 2. t_prc_price_components

| 컬럼 | 타입(라이브) | 코드 사용처 | 코드 가정 | 라이브 | 정합 |
|------|------------|-------------|-----------|--------|:--:|
| comp_cd | varchar | pricing.py:402,450 | PK | 146행 | ✅ |
| comp_nm | varchar | pricing.py:407 entry 표시 | 명 | — | ✅ |
| comp_typ_cd | varchar | 코드 미참조(price_views/admin만) | 유형 enum | — | ⚠️ 코드 미사용 |
| prc_typ_cd | varchar | pricing.py:403 `comp_cd__prc_typ_cd` → 단가/합가 분기(:185) | PRICE_TYPE.01/02 | 채워짐 | ✅ |
| use_dims | jsonb | pricing.py:404,459 차원목록·is_proc·판별차원 | 차원 컬럼명 배열 | 채워짐 | ✅ |
| use_yn | char | 코드 미참조 | 사용여부 | — | ⬛dead(엔진) |
| del_yn/del_dt | char/ts | 코드 미참조 | 논리삭제 | — | ⬛dead(엔진) |
| note | varchar | price_views | 비고 | — | ✅ |

> prc_typ_cd·use_dims는 라이브에 실재하나 **prcx01/pricing-erd 설계 문서엔 부재**(설계 stale — design-artifact-trace 참조).

---

## 3. t_prc_price_formulas

| 컬럼 | 타입(라이브) | 코드 사용처 | 코드 가정 | 라이브 | 정합 |
|------|------------|-------------|-----------|--------|:--:|
| frm_cd | varchar | pricing.py:320,450 | PK·바인딩 | 48행 | ✅ |
| frm_nm | varchar | price_views | 공식명 | — | ✅ |
| ~~frm_typ_cd~~ | **부재** | **코드 미참조**(pricing.py:8 주석만 "폐기") | — | **컬럼 없음** | ⬛dead→제거완료 |
| use_yn | char | 코드 미참조 | 사용여부 | — | ⚠️ 엔진 미사용 |
| note | varchar | price_views | 비고 | — | ✅ |

> **frm_typ_cd: 설계(pricing-erd:24)엔 FK로 존재 → sql/25_drop_frm_typ.sql로 제거 → 라이브 부재 → 코드는 주석으로만 폐기 명시(잔재 0).** 깨끗하게 제거된 모범 사례.

---

## 4. t_prc_formula_components (공식=구성요소 배선)

| 컬럼 | 타입(라이브) | 코드 사용처 | 코드 가정 | 라이브 | 정합 |
|------|------------|-------------|-----------|--------|:--:|
| frm_cd | varchar | pricing.py:450 filter | PK,FK | 301행 | ✅ |
| comp_cd | varchar | pricing.py:452 | PK,FK | — | ✅ |
| disp_seq | integer | pricing.py:451 order_by·:407 | 표시·평가순서 | — | ✅ |
| addtn_yn | char | **코드 미참조** | Y=합산(설계:39) | Y=299·**N=2**·NULL=0 | ⬛dead |

> **addtn_yn(가산여부): 설계 pricing-erd:39 "Y=합산"의 핵심 플래그인데 pricing.py가 전혀 읽지 않음** — 공식은 "항상 전 구성요소 합산"(pricing.py:14)으로 단순화. **라이브 N=2행 실재**(PRF_CLR_ACRYL/COMP_ACRYL_CLEAR3T·PRF_COROTTO_ACRYL/COMP_ACRYL_COROTTO — 직전 "전부 Y" 정정). 운영자가 "합산 말라" 표기했으나 엔진은 그래도 합산. 설계 11-CONTEXT.md:23이 "addtn_yn=이번 엔진에서 무시·의도 불확실·차후 재정의"로 **의도적 deferred** 명시(우연 아님). 차감(N) 표현 불가. impl-gap-board G-4 · constraint-mechanism-gap §6.

---

## 5. 할인 t_dsc_* (순차 곱 적용)

엔진 적용: 수량구간 할인(`_quantity_discount`:478) → 등급 할인(`_grade_discount`:508), 순차 곱(running 누적).

| 테이블.컬럼 | 코드 사용처 | 코드 가정 | 라이브 | 정합 |
|------------|-------------|-----------|--------|:--:|
| t_prd_product_discount_tables.dsc_tbl_cd | pricing.py:482 링크 | 상품→할인테이블(시계열) | 102 링크 | ✅ |
| t_dsc_discount_tables.dsc_typ_cd | pricing.py:488,496 `tbl["dsc_typ_cd"]` | **테이블 단위** 정률/정액 | 컬럼 실재 | ✅ |
| t_dsc_discount_details.(min_qty,max_qty) | pricing.py:223 `pick_discount_detail` | min≤qty≤max | 35행 | ✅ |
| t_dsc_discount_details.dsc_rate/dsc_amt | pricing.py:497 apply_discount | 정률율/정액 | — | ✅ |
| t_dsc_discount_details.**dsc_typ_cd** | **코드 미참조**(typ는 table에서 읽음) | — | **라이브 컬럼 부재** | ⬛dead(설계 stale) |
| t_dsc_grade_discount_rates.* | pricing.py:522 등급할인 | cat_cd+grade_cd | **0행** | ⚠️ 코드 정상·데이터 0(경로 미작동) |

> **할인유형 위치 이동: 설계 sql/01a:242는 details에 dsc_typ_cd 선언(stale) → 라이브는 table master에만 보유 → 코드는 table에서 읽음(CONTEXT 변경 ②반영, 정합).** DDL 01a가 진실을 따라오지 못함.

---

## 6. 바인딩·가격소스 우선순위 (pricing.py:13 TEMPLATE→PRODUCT→FORMULA)

| 소스 | 코드 분기 | 라이브 데이터 | 정합 |
|------|-----------|--------------|:--:|
| TEMPLATE_PRICE | pricing.py:292-297 | t_prd_template_prices **0행** | ⚠️ 코드 정상·데이터 0(경로 dead) |
| PRODUCT_PRICE(직접단가) | pricing.py:312-317 | t_prd_product_prices **0행** | ⚠️ 코드 정상·데이터 0(전 상품 공식기반) |
| FORMULA | pricing.py:320-327 | product_price_formulas 76 바인딩·48 공식·301 배선·146 comp | ✅ 유일 활성 경로 |

**해석:** 코드는 3-우선순위를 모두 구현하나 라이브는 FORMULA 단일 경로만 데이터 보유. TEMPLATE/PRODUCT 분기는 "데이터 레벨 dead"(코드 결함 아님·미적재). 가격 검증은 FORMULA 사슬에 집중해야.
