# price-engine-defect-board.md — 가격엔진 항목 정합 결함 보드 (디지털인쇄 36상품)

> **Phase 4 — hcc-price-engine-inspector** · 2026-06-22 · `huni-catalog-conformance/04_price_engine`
> 스코프: 디지털인쇄 36상품(PRD_000016~PRD_000051). 라이브 읽기전용 SELECT 실측 2026-06-22.
> 권위 기준(재조사 0): `engine-contract.md`(evaluate_price 계약)·`engine-design-digitalprint.md`(설계)·
> `binding-violation-board.md`(U-7)·`digital-print-l1.csv`(권위 단가). 단가값 날조 0·v03/STALE 인용 0.
> **직접 교정 금지 — 라우팅만.** 돈영향(과대/과소/차단) 명시. 게이트가 evaluate_price 재계산으로 독립 재실측.

---

## 0. 요약 — 결함 분포 (36상품 × 가격엔진 축)

| 판정 | 상품 수 | 비고 |
|------|:--:|------|
| **MATCH**(견적 정합) | 23 | 원자합산형 엽서/접지카드/배경지/전단류 + 포토카드 + 봉투 (코팅 유광 선택분만 V-4) |
| **MISSING**(frm_cd 미바인딩=견적 0원) | 10 | 큐레이터 단서 10건과 1:1 일치 |
| **MISMATCH/silent**(틀린 값으로 성립) | 3 | 명함 PRF_NAMECARD_FIXED 바인딩 3상품(D-A·D-B) |
| 합계 | **36** | 빈 셀 0 |

**돈 크리티컬 Top 3**: ① MISSING 10상품(견적 자체 차단·0원) → ② 명함 D-A misfire(과소 −200,000/100매) + D-B silent 이중합산(과대 +450,000/100매) → ③ COMP_COAT_GLOSSY 0원 침묵(유광 과소).

---

## 1. 🔴 DEF-PE-01 — frm_cd 미바인딩 10상품 (MISSING·견적 차단)

| 항목 | 내용 |
|------|------|
| **위치** | t_prd_product_price_formulas (해당 prd_cd 행 부재) |
| **증상** | 공식 바인딩 0건 → evaluate_price source=NONE → lenient 0원+경고 / strict None. **견적 자체가 안 나옴**([[huni-widget-red-price-never-zero]] 위반: PRICE=0은 항상 우리측 결함) |
| **권위 정답** | 상품마스터 `가격공식` 칸에 공식 의도 존재 + 설계문서 §4 바인딩 명세(전 상품 needed=Y) |
| **라이브** | 미바인딩 확정 10건 |
| **돈영향** | **차단**(견적 0원·주문 불가) |

**대상 10상품(실측 1:1)**: PRD_000019 투명엽서·PRD_000030 지그재그엽서·PRD_000034 펄명함·PRD_000035 모양명함·PRD_000036 미니모양명함·PRD_000037 오리지널박명함·PRD_000038 형압명함·PRD_000039 투명명함·PRD_000040 화이트인쇄명함·PRD_000049 와이드 접지리플렛.

- **comp는 대부분 실재(orphan)**: COMP_NAMECARD_PEARL/SHAPE/MINISHAPE/CLEAR/FOIL/WHITE_* 전부 단가행 충전 확인(설계 §3.1). → **신규 mint 아닌 "공식 신설+바인딩"** 문제. 형압명함(PRD_000038)만 comp 미실재(설계 G-4 컨펌큐).
- **재현 쿼리**:
```sql
SELECT p.prd_cd, p.prd_nm,
  (SELECT count(*) FROM t_prd_product_price_formulas b WHERE b.prd_cd=p.prd_cd) bind_cnt
FROM t_prd_products p
WHERE p.prd_cd BETWEEN 'PRD_000016' AND 'PRD_000051' AND COALESCE(p.del_yn,'N')='N'
  AND NOT EXISTS (SELECT 1 FROM t_prd_product_price_formulas b WHERE b.prd_cd=p.prd_cd);
-- 10 rows
```
- **라우팅**: 공식 신설·바인딩 설계는 `engine-design-digitalprint.md §3.1·§4`에 이미 명세 → 실 적재 `dbm-load-execution`(인간 승인). 형압명함 comp 부재는 `dbm-price-arbiter` 심의(G-4).

---

## 2. 🔴 DEF-PE-02 — 명함 D-A misfire (MISMATCH·과소청구)

| 항목 | 내용 |
|------|------|
| **위치** | t_prc_formula_components(PRF_NAMECARD_FIXED) — COMP_NAMECARD_STD_S1/S2만 배선 |
| **증상** | 코팅명함(PRD_000032)·프리미엄명함(PRD_000031)이 PRF_NAMECARD_FIXED 바인딩인데 그 공식엔 STD comp만 배선. variant comp(COAT 5,500·PREMIUM 4,500)는 orphan(미배선) → **STD 단가(3,500)가 매겨짐** |
| **권위 정답** | 코팅명함=COMP_NAMECARD_COAT_S1(MAT_000081=5,500)·프리미엄=COMP_NAMECARD_PREMIUM_S1_MGA(4,500) — 라이브 단가행 verbatim 실재 |
| **라이브** | 단면 100매: 코팅 350,000(STD) vs 정답 550,000(COAT). **−200,000원** |
| **돈영향** | **과소청구**(회사 손해·variant 프리미엄 가격이 STD로 매겨짐) |

- **재현 쿼리**:
```sql
SELECT b.prd_cd, p.prd_nm, b.frm_cd, fc.comp_cd, cp.mat_cd, cp.min_qty, cp.unit_price
FROM t_prd_product_price_formulas b
JOIN t_prd_products p ON p.prd_cd=b.prd_cd
JOIN t_prc_formula_components fc ON fc.frm_cd=b.frm_cd
JOIN t_prc_component_prices cp ON cp.comp_cd=fc.comp_cd
WHERE b.prd_cd IN ('PRD_000031','PRD_000032')
ORDER BY b.prd_cd, fc.comp_cd, cp.min_qty;
-- 코팅·프리미엄명함이 STD comp(3500/4500)만 매칭됨을 확인
```
- **라우팅**: 코팅·프리미엄·펄 등 variant별 전용 PRF 신설+바인딩(설계 §3.1) → `dbm-price-arbiter` 심의 후 `dbm-load-execution`.

---

## 3. 🔴 DEF-PE-03 — 명함 D-B silent 이중합산 (MISMATCH·과대청구)

| 항목 | 내용 |
|------|------|
| **위치** | t_prc_component_prices(COMP_NAMECARD_STD_S1/S2) — print_opt_cd 전 행 NULL |
| **증상** | STD_S1·S2 둘 다 배선·단가행 print_opt_cd=NULL → 단면 선택해도 S1·S2 **둘 다 와일드카드 통과(P3-1)** → ERR_AMBIGUOUS 아님(별 comp_cd·P3-8 비해당) → **silent 합산**(경고 없음) |
| **권위 정답** | 단면=S1만(3,500), 양면=S2만(4,500). 인쇄면 선택이 판별차원이어야 함 |
| **라이브** | 단면 100매: (3,500+4,500)×100 = 800,000 vs 정답 350,000. **+450,000원** |
| **돈영향** | **과대청구**(손님 손해·견적이 깨지지 않고 틀린 값으로 성립=더 위험) |

- **해소(설계 §3.2 안①)**: S1 단가행에 print_opt_cd=POPT_000001(단면)·S2에 POPT_000002(양면) 충전 + comp use_dims에 print_opt_cd 등재(둘 다 필요). 단가값 불변(verbatim).
- **재현 쿼리**:
```sql
SELECT comp_cd, COALESCE(print_opt_cd,'<NULL>') popt, count(*)
FROM t_prc_component_prices
WHERE comp_cd IN ('COMP_NAMECARD_STD_S1','COMP_NAMECARD_STD_S2') GROUP BY 1,2;
-- 둘 다 print_opt_cd=<NULL> → 인쇄면 무관 둘 다 매칭(silent 이중합산 입증)
```
- **라우팅**: 차원 충전 UPDATE + use_dims 등재 UPDATE → `dbm-load-execution`(단가값 불변·dbmap). 명함 옵션값↔POPT 매핑 0행(option_items)도 동반(G-7 컨펌).

---

## 4. 🟡 DEF-PE-04 — COMP_COAT_GLOSSY 단가행 0 (MISSING·과소·0원 침묵)

| 항목 | 내용 |
|------|------|
| **위치** | t_prc_component_prices(COMP_COAT_GLOSSY) = 0행. 배선=PRF_DGP_A·D·E |
| **증상** | 유광코팅 comp가 3개 디지털 공식에 배선됐으나 단가행 0 → 유광 선택 시 매칭 0건 → 합산 제외(0원)·lenient 경고만 |
| **권위 정답** | 인쇄상품 가격표 `코팅` 시트 유광 단/양면 단가 존재(설계 §5 V-4) |
| **라이브** | 유광 선택분 0원 산출 |
| **돈영향** | **과소청구**(유광코팅비 미부과·회사 손해) |

- **재현 쿼리**:
```sql
SELECT fc.frm_cd, fc.comp_cd,
  (SELECT count(*) FROM t_prc_component_prices cp WHERE cp.comp_cd=fc.comp_cd) rows
FROM t_prc_formula_components fc
WHERE fc.comp_cd='COMP_COAT_GLOSSY'; -- PRF_DGP_A/D/E, rows=0
```
- **라우팅**: 가격표 유광 단가행 INSERT → [[dbmap-price-import-round16]] → `dbm-load-execution`.

---

## 5. 🟡 DEF-PE-05 — prc_typ 단가형 ×qty 과대청구 가능성 (고정가형·CONFIRM/심의)

| 항목 | 내용 |
|------|------|
| **위치** | 전 고정가형 comp(명함 STD/COAT/PREMIUM·포토카드 SET·박 FOIL) prc_typ_cd=PRICE_TYPE.01(단가형) |
| **증상** | 명함 STD MAT_000074·100매=3,500은 **묶음/구간 총액 성격**(100매 박스 단가)인데 단가형(P4-1: unit×qty)이면 qty=100 시 3,500×100=350,000으로 다시 ×qty 곱해질 위험(설계 D-10·R-1) |
| **권위 정답** | 가격표 단가 의미(장당 vs 100매 묶음가) 확정 필요 — 합가형(÷min_qty) 교정 시 P4-3 min_qty 必 |
| **라이브** | 명함 단가행 min_qty=100 보유(합가형 환산 가능 구조) |
| **돈영향** | **과대(잠재)** — 단가 의미 오해 시 ×qty 이중곱 |

- **판정**: 이 건은 **CONFIRM/심의 대기** — 단가가 장당가인지 100매 묶음가인지 권위 엑셀끼리 명시 모호(설계 R-1 컨펌 대기). 인스펙터가 임의 확정하지 않음.
- **라우팅**: `dbm-price-arbiter` 심의(교정방향: 합가형÷min_qty / qty 정규화) — 사용자 컨펌 대기.

---

## 6. CONFIRM 큐 계승 (권위 엑셀끼리 모호 — 결함 아님)

authority-spec §5 계승. 인스펙터가 임의 선택하지 않고 인간 확인으로 보류:

| CONFIRM ID | 내용 | 상태 |
|-----------|------|------|
| Q-ROUND | 합산형 final_price 반올림(round/floor) 미명시 | 가격표 미명시 |
| Q-COAT-TIER | 코팅/인쇄비 수량행 비연속 구간 경계(이상/이하) 미명시 | 미명시 |
| Q-DGP-SPOT | 별색엽서 인쇄비 공식 변형(일반엽서와 상이) | 공식집 행7 |
| Q-DGP-PLATE | 3절 vs 국4절 출력판형 분기(판걸이수 시트 결정) | 구조적 모호 |
| **DEF-PE-05** | 명함 단가 장당가 vs 묶음가(prc_typ ×qty) | 설계 R-1 컨펌 대기 |

---

## 7. 비결함 확인 (clean — 정합 입증)

| 영역 | 라이브 실측 | 판정 |
|------|------------|:--:|
| 원자합산 6공식(PRF_DGP_A~F) 배선·단가행 | 인쇄 212·용지 56·코팅무광 92·완칼 36·접지 48행 등 전부 충전 | ✅ |
| 직접단가 우선순위(순위1·2) | t_prd_product_prices 0행 → 전 상품 FORMULA 평가(C1) | ✅ 정합 |
| 수량구간 할인 | 디지털 36상품 t_prd_product_discount_tables 0건 — 단가가 min_qty 구간에 내장(별도 할인테이블 미사용) | ✅ needed=N 성격 |
| 등급할인 | t_dsc_grade_discount_rates 0행 → 경고만(C9) | ✅ 정합(미적재 설계) |
| 종단 골든(엽서 PRF_DGP_A) | 옵션 4축 전부 단가행 환원 | ✅ 견적 가능 |
| V-1 포스터 광역 오배선(196행) | 디지털 스코프 밖(PRF_POSTER_*) — 본 보드 비대상 | 참고(binding-violation-board) |
