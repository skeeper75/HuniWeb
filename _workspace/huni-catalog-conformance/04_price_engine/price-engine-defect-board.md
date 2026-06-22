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

---

# 배치1 — 포토북 본체(PRD_000100) · 캘린더 5(PRD_000108~112) 가격엔진 항목 정합

> **Phase 2 배치1 — hcc-price-engine-inspector** · 2026-06-22 · 라이브 읽기전용 SELECT 실측.
> 권위 기준(재조사 0): `engine-contract.md`·`engine-design-photobook.md`·`engine-design-calendar.md`(§18 설계)·
> set BOM/page_rule 라이브 실재. 단가값 날조 0·v03/STALE 인용 0. **직접 교정 금지 — 라우팅만.**
> 반제품 PRD_000101~107(표지/내지/면지)=가격 N(세트 BOM·본체 base24에 internalize·이중계상 가드).

## 배치1.0 요약 — 결함 분포 (6 prd × 가격엔진 축)

| 판정 | prd 수 | 비고 |
|------|:--:|------|
| **MISSING**(frm_cd 미바인딩=견적 0원) | **6** | 전 6건·Phase 1 사전경보 1:1 적중 |
| MATCH | 0 | — |
| MISMATCH | 0 | — |

**돈 크리티컬**: **차단 6건**(전 6 prd 견적 0원·주문 불가·[[huni-widget-red-price-never-zero]] 위반). 저청구/과청구는 0(아예 견적이 안 나옴 — 차단이 가장 비싼 등급).

## 배치1.1 🔴 DEF-PE-06 — 포토북·캘린더 6 prd frm_cd 미바인딩 (MISSING·견적 차단)

| 항목 | 내용 |
|------|------|
| **위치** | t_prd_product_price_formulas (6 prd_cd 행 전부 부재) |
| **증상** | 공식 바인딩 0건 → evaluate_price source=NONE(P1·:329-335) → lenient 0원+경고 / strict None. **견적 자체가 안 나옴** |
| **권위 정답** | 상품마스터 `가격공식` 칸·설계 §2·§5: 포토북=PRF_PHOTOBOOK_SUM(신설)·캘린더=PRF_CAL_DESK220/DESKMINI/POSTCARD/WALL/WALLWIDE(신설) |
| **라이브** | 6/6 미바인딩 확정(bind_cnt=0·product_prices=0·prd_typ=PRD_TYPE.04) |
| **돈영향** | **차단**(견적 0원·주문 불가) |

**대상 6 prd (실측 1:1)**: PRD_000100 포토북·PRD_000108 탁상형·PRD_000109 미니탁상형·PRD_000110 엽서·PRD_000111 벽걸이·PRD_000112 와이드벽걸이 캘린더.

- **디지털 DEF-PE-01과 결정적 차이**: 디지털 미바인딩 10건은 **comp orphan 실재**(공식만 신설+바인딩)였으나, 포토북·캘린더는 **공식(PRF_PHOTOBOOK_SUM·PRF_CAL_*) 자체가 라이브 0행**(실측 A) → **공식 신설 + comp 일부 신설 + 단가행 충전 + 바인딩**의 full WIRE 폐쇄. 디지털보다 작업 깊이 큼.
- **재현 쿼리**:
```sql
SELECT p.prd_cd, p.prd_nm,
  (SELECT count(*) FROM t_prd_product_price_formulas b WHERE b.prd_cd=p.prd_cd) bind_cnt,
  (SELECT count(*) FROM t_prd_product_prices pp WHERE pp.prd_cd=p.prd_cd) prodprice_cnt
FROM t_prd_products p
WHERE p.prd_cd IN ('PRD_000100','PRD_000108','PRD_000109','PRD_000110','PRD_000111','PRD_000112')
ORDER BY p.prd_cd;  -- 6 rows 전부 bind_cnt=0·prodprice_cnt=0
```
- **라우팅**: 공식 신설·comp 신설·단가행 충전·바인딩 설계는 `engine-design-photobook.md §2~5`·`engine-design-calendar.md §2~6`에 이미 명세 → `dbm-price-arbiter` 심의(CONFIRM 동반) 후 `dbm-load-execution`(인간 승인). webadmin 코드 직접수정 금지.

## 배치1.2 종단 연결 끊김 — 옵션→차원 주입 레이어 전면 부재 (DEF-PE-07·차단 가중)

| 항목 | 내용 |
|------|------|
| **위치** | t_prd_product_option_groups·t_prd_product_discount_tables (6 prd 전부 0행) |
| **증상** | 공식을 신설·바인딩해도 **옵션 선택값→판별차원(mat_cd 표지타입·proc_cd 제본/사이즈) 자동주입이 끊김**. base24/제본비 단가행은 판별차원으로 1행 매칭되는데, 그 차원값을 주입할 option_items가 0행 → 종단 e2e(옵션→차원→단가행) 미완결 |
| **권위 정답** | 설계 Q-PB-OPT(표지타입→mat_cd 주입)·Q-CAL-PROC-INJECT(사이즈→proc_cd 주입) — option_items 적재 선결 |
| **라이브** | option_groups 0·discount_tables 0 (6/6) |
| **돈영향** | **차단 가중**(공식 바인딩 후에도 차원 미주입 시 base24 평탄 매칭·G-PB-FLAT/G-CAL-1 평탄화 위험) |

- **재현 쿼리**:
```sql
SELECT p.prd_cd,
 (SELECT count(*) FROM t_prd_product_option_groups og WHERE og.prd_cd=p.prd_cd) optgrp,
 (SELECT count(*) FROM t_prd_product_discount_tables dt WHERE dt.prd_cd=p.prd_cd) disc
FROM t_prd_products p WHERE p.prd_cd IN ('PRD_000100','PRD_000108','PRD_000109','PRD_000110','PRD_000111','PRD_000112');
-- 전부 optgrp=0·disc=0
```
- **라우팅**: cpq-link-inspector 결과와 합류(옵션 레이어 적재). 가격 측에서는 공식 신설 후 단가행 mat_cd/proc_cd 판별차원 충전이 선결(G-PB-FLAT·G-CAL-1 평탄화 가드). `dbm-cpq-option-mapping`→`dbm-load-execution`.

## 배치1.3 비결함 확인 (clean — 재사용 사슬 준비 입증)

| 영역 | 라이브 실측 | 판정 |
|------|------------|:--:|
| 재사용 comp 단가행 충전 | COMP_PRINT_DIGITAL_S1=212·COMP_PAPER=56·COMP_BIND_PUR=8·COMP_COAT_MATTE=92행 전부 실재 | ✅ 신규 mint 불요분 준비됨 |
| 캘린더 제본비 comp | COMP_BIND_CAL_DESK220/130/MINI 각 6행·WALL 24행(proc99~102×6 통합)·전부 .01 단가형·min_qty NULL 0 | ✅ 부당가 단가행 verbatim·P4-3 안전 |
| 제본비 del_yn 정합 | DESK130/220/MINI=del_yn='Y'(논리삭제)·WALL=del_yn='N'(활성) | ✅ 설계 §3.5 일치(WALL 통합 사용 가능·Q-CAL-BIND-DELYN 컨펌) |
| 포토북 세트 BOM | t_prd_product_sets(100)=7행(101~107·sub_prd_qty=1) | ✅ 부품 구성 실재·가격 비기여(이중계상 가드) |
| 포토북 page_rule | t_prd_product_page_rules(100)=24/150/2(하드 기준) | ✅ 페이지 증분 차원 실재·캘린더 108~112는 page_rule 0(장수=출력매수 곱) |
| 직접단가 우선순위 | product_prices 0행(6/6) → 전부 FORMULA 평가·선점 위험 0(G-PB/CAL PRODPRICE 자동충족·C1) | ✅ 정합 |

## 배치1.4 CONFIRM 큐 (권위 엑셀끼리 모호 — 결함 아님·임의 확정 금지)

| CONFIRM ID | 내용 | 상태 |
|-----------|------|------|
| **Q-PB-SETPRICE** | 포토북 가격=base24+per2p×페이지증분(row17 명문 산식)·base24 묶음 vs 부품 full 분해 | 설계 §3.2 결판(base24 통합)·base_min 컨펌 대기 |
| **Q-PB-PAGEBASE** | 포토북 base_min 하드/레더하드=24 vs 소프트=4(증분 시작점)·돈크리티컬 | 시트 불명확·인간 컨펌(설계 §4.4) |
| **Q-PB-SOFT8** | 10x10 소프트 base24 시트 공란 → 단가행 INSERT 안 함·BLOCKED 정직 | 시트 공란 |
| **Q-PB-MAT** | 표지타입↔mat_cd 정확 매핑(레더 106이 별 base24 행인지) | 설계 §3.4·컨펌 대기 |
| **Q-CAL-DUAL** | (디자인캘린더) inline 정찰가 스냅샷 vs 단가행 산식 — 5 formula-캘린더(108~112)와 별개·formula 경로 채택·디자인캘린더 inline=BLOCKED 정직 | 설계 §0.2·골든 BLOCKED |
| **Q-CAL-BIND-DELYN** | 제본비 WALL 통합 사용 vs DESK130/220/MINI 부활 | 설계 §3.5·단가 동일(가격 불변·배선 경로만) |
| **Q-CAL-FIN** | 캘린더가공 add-on ×제작수량(개당) vs 주문당 정액 | calc-draft 개당 가설·컨펌 |

★ 이 항목들은 결함이 아니라 **권위 모호**(인스펙터 임의 확정 금지). Q-PB-PAGEBASE(소프트 base_min)·Q-PB-MAT(평탄화)는 잘못 확정 시 돈크리티컬 → 반드시 인간 컨펌.

---

# 배치2 — 책자10·문구9·악세15 (34 prd) 가격엔진 항목 정합

> **Phase 2 배치2 — hcc-price-engine-inspector** · 2026-06-23 · 라이브 읽기전용 SELECT 실측.
> 권위 기준(재조사 0): `engine-contract.md`·`engine-design-booklet.md`(§18·G-BK-1~4)·`engine-design-stationery.md`(G-ST-1/2·Q-ST)·
> `engine-design-accessory.md`(AC-1/AC-2·G-AC-1/2/3). 단가값 날조 0·v03/STALE 인용 0. **직접 교정 금지 — 라우팅만.**

## 배치2.0 요약 — 결함 분포 (34 prd × 가격엔진 축)

| 판정 | prd 수 | 비고 |
|------|:--:|------|
| **MISSING**(미바인딩/미가격=견적0원) | 28 | 책자5(072/077/082/088/097)·문구9·악세14(008 제외) |
| **MISMATCH**(틀린 값으로 성립) | 5 | 책자 PRF_BIND_SUM 4(068~071)·엽서북 PRF_PCB_FIXED(094) |
| **EXCLUDED**(needed=N) | 1 | 천정고리(008) use_yn=N 판매중지 |
| 합계 | **34** | 빈 셀 0 |

**바인딩 5건 대조 결과(Phase 1 사전경보 1:1 적중)**: 책자4=PRF_BIND_SUM(068~071)·엽서북1=PRF_PCB_FIXED(094). **그러나 5건 전부 결함** — 바인딩 존재≠정합. PRF_BIND_SUM 4건=stale 배선+표지내지 누락(MISMATCH), PRF_PCB_FIXED 1건=silent 이중합산+페이지 판별불가(MISMATCH).
**MISSING 29 후보 분포**: 책자5 + 문구9 + 악세15 = 29. 실측 결과 악세 008(use_yn=N)만 EXCLUDED로 빠져 **MISSING 확정 28**.

**돈 크리티컬 Top**: ① MISSING 28(견적0원·차단·[[huni-widget-red-price-never-zero]] 위반) → ② 엽서북 094 silent 이중합산(과대 +11,500/장·DEF-PE-10) → ③ 책자 068~071 제본방식 misfire+표지내지 누락(과소/미완성가·DEF-PE-08).

## 배치2.1 🔴 DEF-PE-08 — 책자 PRF_BIND_SUM stale 배선 + 미완성가 (MISMATCH·068~071)

| 항목 | 내용 |
|------|------|
| **위치** | t_prc_formula_components(PRF_BIND_SUM) = COMP_BIND_JUNGCHEOL 1개뿐 |
| **증상** | ① 배선된 COMP_BIND_JUNGCHEOL이 **del_yn='Y'(논리삭제)** comp(G-BK-2 stale). pricing.py del_yn 필터 부재(설계 §2.1 검증)라 평가엔 포함되나 **무선/PUR/트윈링도 중철 단가만 매김**(자기 제본비 misfire). ② **표지/내지 인쇄·용지 comp 0행**(G-BK-3) → 제본비만 산출=미완성가(상품마스터 다부품 완성가 미달). ③ proc_cd 미주입 시 4 proc_cd 단가행 silent 다중매칭 위험(§2.3) |
| **권위 정답** | 설계 §2.3: COMP_BIND_TWINRING(활성·del_yn=N·4 proc_cd 통합 32행) 재배선 + 표지/내지 comp 신설·합산(W3) + 중철 단가행 오염 교정(W2·G-BK-1) |
| **라이브** | 068~071 전부 PRF_BIND_SUM·COMP_BIND_JUNGCHEOL(del_yn=Y)만. COMP_BIND_MUSEON/PUR(각 8행·del_yn=Y)·TWINRING(32행·del_yn=N) 별존재·미배선 |
| **돈영향** | **과소/미완성가** — 무선/PUR/트윈링이 중철값(저가)으로 misfire + 표지내지비 0 |

- **재현 쿼리**:
```sql
SELECT fc.frm_cd, fc.comp_cd, pc.del_yn comp_del, pc.use_dims,
  (SELECT count(*) FROM t_prc_component_prices cp WHERE cp.comp_cd=fc.comp_cd) rows
FROM t_prc_formula_components fc JOIN t_prc_price_components pc ON pc.comp_cd=fc.comp_cd
WHERE fc.frm_cd='PRF_BIND_SUM';   -- COMP_BIND_JUNGCHEOL del_yn=Y 1행뿐
SELECT comp_cd, del_yn FROM t_prc_price_components WHERE comp_cd LIKE 'COMP_BIND_%';
-- TWINRING/SSABARI/CAL_WALL=N(활성)·나머지 8=Y(삭제)
```
- **라우팅**: 설계 `engine-design-booklet.md §2(W1 재배선)·§2.4(W2 중철 오염)·§3(W3 표지내지 신설)` 이미 명세 → `dbm-price-arbiter` 심의(Q-BK-PROC proc_cd 주입) 후 `dbm-load-execution`(인간 승인·단가값 verbatim).

## 배치2.2 🔴 DEF-PE-09 — 하드커버 책자 미바인딩 full WIRE (MISSING·072/077/082/088)

| 항목 | 내용 |
|------|------|
| **위치** | t_prd_product_price_formulas (4 prd 행 부재) + 표지/내지 comp 0행 |
| **증상** | 공식 바인딩 0 → source=NONE → 견적0원. 추가로 표지/내지 comp 0행(G-BK-3)·HC제본 comp del_yn='Y'(HC_MUSEON/HC_TWINRING 각 6행 삭제·SSABARI만 활성 18행) → **공식 신설 + 표지/내지 comp 신설 + 단가행 충전 + 바인딩의 full WIRE** 필요(디지털 orphan-only보다 깊음) |
| **권위 정답** | 설계 §4·set-product-design: 세트 부모(072/077/082/088)에 PRF_<제본>_SUM 바인딩 + 표지비/내지비(페이지)/제본비 B02 합산. 세트 BOM(표지·면지 별 prd_cd) 실재 |
| **라이브** | bind=0(4/4)·product_prices=0·표지내지 comp 0·세트 분해 실재 |
| **돈영향** | **차단**(견적0원) |

- **재현 쿼리**:
```sql
SELECT count(*) FROM t_prc_price_components WHERE comp_nm ILIKE '%표지%' OR comp_nm ILIKE '%내지%'; -- 0
SELECT comp_cd, del_yn FROM t_prc_price_components WHERE comp_cd IN ('COMP_BIND_HC_MUSEON','COMP_BIND_HC_TWINRING','COMP_BIND_SSABARI');
-- HC_MUSEON/HC_TWINRING=Y(삭제)·SSABARI=N(활성·레더링바인더 088 재사용)
```
- **라우팅**: `engine-design-booklet.md §3~4·set-product-design.md` → `dbm-price-arbiter`(이중계상 가드 W5·표지/내지 신설) → `dbm-load-execution`.

## 배치2.3 🔴 DEF-PE-10 — 엽서북 PRF_PCB_FIXED silent 이중합산 + 페이지 판별불가 (MISMATCH·094)

| 항목 | 내용 |
|------|------|
| **위치** | t_prc_formula_components(PRF_PCB_FIXED) = COMP_PCB_S1_20P + COMP_PCB_S2_20P |
| **증상** | ① S1(단면)·S2(양면) **둘 다 print_opt_cd=NULL**(전 117행) + 같은 use_dims=[siz_cd,min_qty] → 단/양면 선택 무관 둘 다 와일드카드 통과(P3-1). 별 comp_cd라 ERR_AMBIGUOUS 비해당(P3-8) → **silent 이중합산**(경고 없음·명함 D-B 동형). ② **30p variant(COMP_PCB_S1/S2_30P) orphan**(미배선) → 30p 주문도 20p 단가로 매김. 20p≠30p(11,000 vs 11,500) → 페이지축 판별불가 |
| **권위 정답** | 단면=S1만·양면=S2만(print_opt_cd 판별차원 충전 필요)·페이지(20p/30p)도 판별차원 또는 bdl_qty 축 |
| **라이브** | SIZ_000003·min_qty=2: S1=11,000 + S2=11,500 둘 다 매칭 → 22,500/장(정답 단면 11,000 or 양면 11,500) |
| **돈영향** | **과대청구 +11,500원/장**(silent·경고 없음=틀린 값으로 성립) |

- **재현 쿼리**:
```sql
SELECT comp_cd, COALESCE(print_opt_cd,'<NULL>') popt, count(*) FROM t_prc_component_prices
WHERE comp_cd IN ('COMP_PCB_S1_20P','COMP_PCB_S2_20P') GROUP BY 1,2; -- 둘 다 NULL 117행
```
- **라우팅**: print_opt_cd 충전 + use_dims 등재 + 30p variant 배선/페이지축 설계 → `dbm-price-arbiter` 심의 후 `dbm-load-execution`(단가값 불변).

## 배치2.4 🔴 DEF-PE-11 — 떡메모지 미바인딩(comp 충전 실재) (MISSING·097)

| 항목 | 내용 |
|------|------|
| **위치** | t_prd_product_price_formulas (PRD_000097 부재) |
| **증상** | PRF_TTEOKME_FIXED(use_yn=Y)·COMP_TTEOKME(112행·min_qty NULL 0·850~3200 verbatim) **전부 실재**하나 바인딩 0 → source=NONE → 견적0원. **신규 mint 0·바인딩만 필요**(디지털 DEF-PE-01과 동형이나 공식·comp·단가행 다 실재) |
| **권위 정답** | 설계 G-ST-2: PRD_000097→PRF_TTEOKME_FIXED 바인딩 + DSC_STAT_QTY 링크 |
| **돈영향** | **차단**(견적0원) |

- **라우팅**: `engine-design-stationery.md §(B)` → `dbm-load-execution`(바인딩 1행 + DSC 링크).

## 배치2.5 🔴 DEF-PE-12 — 문구 본체 9 미가격 PRODUCT_PRICE (MISSING·172~181)

| 항목 | 내용 |
|------|------|
| **위치** | t_prd_product_prices (9 prd 0행) |
| **증상** | 본체 문구(만년다이어리4·먼슬리·스프링노트/수첩·메모패드·중철노트)는 **PRODUCT_PRICE 경로**(상품마스터 AC열 inline 고정가·차원 없음). product_prices 0행 → source=NONE → 견적0원. ★수량구간할인(DSC_STAT_QTY)은 6/9 링크 실재하나 **base=0에 곱→P6-4 가드(amount≤0 할인 스킵)로 dead** |
| **권위 정답** | 설계 §2: AC열 고정가 verbatim → product_prices INSERT(공식·comp 불요) + DSC_STAT_QTY 링크 누락 3(173/174/175) 보완 |
| **라이브** | bind=0·product_prices=0(9/9)·DSC링크 6(172/176/177/178/179/181)·누락3(173/174/175) |
| **돈영향** | **차단**(견적0원) |

- **재현 쿼리**:
```sql
SELECT p.prd_cd, (SELECT count(*) FROM t_prd_product_prices pp WHERE pp.prd_cd=p.prd_cd) pp,
 (SELECT count(*) FROM t_prd_product_discount_tables dt WHERE dt.prd_cd=p.prd_cd) disc
FROM t_prd_products p WHERE p.prd_cd BETWEEN 'PRD_000172' AND 'PRD_000181'; -- pp=0 전건·disc 6/9
```
- **라우팅**: `engine-design-stationery.md §2` → `dbm-load-execution`(product_prices INSERT + DSC 링크).

## 배치2.6 🔴 DEF-PE-13 — 악세 AC-2 변형고정가 full mint (MISSING·봉투/우드/투명류 11)

| 항목 | 내용 |
|------|------|
| **위치** | 가격사슬 전무(공식0·comp0·단가0·product_prices0·template_prices0) |
| **증상** | AC-2(OPP봉투·트래싱지·카드봉투·캘린더봉투·투명케이스·행택끈·자석고무판·우드거치대/봉/행거 = 11)는 variant별 자기 고정가 → **FORMULA 경로(variant-매트릭스)**. 가격사슬 6종단 통틀어 최저(전무) → 견적0원. ★봉투류는 **이중역할**(엽서 PRD_000016 addon으로도 붙음·t_prd_product_addons 5행)인데 template_prices=0 → addon 경로도 0원 |
| **권위 정답** | 설계 AC-2: comp 신규 mint(LINEN_FINISH opt_cd 그릇 선례 재사용·use_dims=variant축 siz_cd/opt_cd/bdl_qty)+공식+단가행 충전+바인딩. ★G-AC-1 평탄화 가드(variant축 판별차원 충전)·G-AC-2 묶음=.01 팩단가(합가형÷min_qty 금지·돈크리티컬) |
| **돈영향** | **차단**(견적0원) — 교정 시 평탄화하면 과소청구 |

- **재현 쿼리**:
```sql
SELECT count(*) FROM t_prc_price_components WHERE comp_cd ILIKE '%OPP%' OR comp_cd ILIKE '%WOOD%'; -- 0(orphan 없음·full mint)
SELECT count(*) FROM t_prd_template_prices; -- 0(봉투 addon 단가 전무)
```
- **라우팅**: `engine-design-accessory.md AC-2·G-AC-1/2/3` → `dbm-price-arbiter`(평탄화·팩단가 가드) → `dbm-load-execution`.

## 배치2.7 🔴 DEF-PE-14 — 악세 AC-1 단일고정가 미가격 (MISSING·볼체인/와이어링/리필잉크 3)

| 항목 | 내용 |
|------|------|
| **위치** | t_prd_product_prices (3 prd 0행) |
| **증상** | AC-1(볼체인 006·와이어링 007·리필잉크 015)=단일고정가·색상은 식별축(가격축 아님) → **PRODUCT_PRICE 경로**(공식·comp 불요). product_prices 0행 → 견적0원. 부자재라 수량구간할인 정당 부재 |
| **권위 정답** | 설계 AC-1: product_prices unit_price 1행 INSERT(굿즈 GP-1·문구 본체 동형) |
| **돈영향** | **차단**(견적0원) |

- **라우팅**: `engine-design-accessory.md AC-1` → `dbm-load-execution`(product_prices INSERT).

## 배치2.8 CONFIRM 분리 보고 (Q-PA-ADDON·Q-ST-PRICE2WAY — 권위로 해소)

| CONFIRM ID | 질의 | 라이브 실측 + 설계 권위로 해소 | 잔여 컨펌 |
|-----------|------|-------------------------------|----------|
| **Q-PA-ADDON** (악세 자체 고정가 vs 본상품 가산) | 악세는 자기 가격인가 본상품 add-on인가 | **둘 다(이중역할)** — AC-1/AC-2는 **자기 완제품가**(PRODUCT_PRICE/FORMULA·own price). 동시에 봉투류는 엽서(PRD_000016) **addon**으로도 붙음(t_prd_product_addons 5행→TEMPLATE_PRICE 경로). 설계 §0 명문: 자체 가격 + addon 경로 단가 **양쪽 일관 적재** 필요. 현재 양 경로 전무(0행) | tmpl 타깃 시 TEMPLATE_PRICE 선점 가드(GP-2 동형)·Q-AC-CEIL(008 제외) |
| **Q-ST-PRICE2WAY** (문구 고정가+구간할인 둘 다 보유) | 고정가와 수량구간할인이 충돌인가 | **충돌 아님·설계 의도** — 본체 9=PRODUCT_PRICE 고정가(base) **위에** DSC_STAT_QTY(정률 5구간 50/100/500/1000개=5/10/15/20%) 순차 곱(engine-contract P6-1). 단 base=0이면 P6-4로 할인 dead → **고정가 INSERT가 선결**. 떡메모(097)도 FORMULA base + DSC 동일 구조 | DSC 링크 누락 3(173/174/175)·097 보완 |

★ 두 CONFIRM 모두 **권위(설계 doc)로 해소** — 인스펙터 임의 확정 아님. 잔여는 적재 시 가드 항목.

## 배치2.9 비결함 확인 (clean — 정합 입증)

| 영역 | 라이브 실측 | 판정 |
|------|------------|:--:|
| 엽서북 단가행 충전(siz_cd+min_qty) | COMP_PCB_S1/S2_20P/30P 각 117행·NULL 0·verbatim(11,000/9,100/…) | ✅ 단가값 정합(배선·판별차원만 결함) |
| 떡메모 comp 충전 | COMP_TTEOKME 112행·min_qty NULL 0·850~3200·×qty 권당단가(÷min_qty 아님·설계 §3 반증) | ✅ verbatim·P4-3 안전 |
| 책자 제본 comp 단가행 | JUNGCHEOL(중철 B01 정답 3000/2000/…)·TWINRING(활성32행)·SSABARI(18행) 실재 | ✅ 단가행 존재(배선만 stale) |
| 문구 수량구간할인 | DSC_STAT_QTY 정률 5구간 verbatim·use_yn=Y | ✅ 할인테이블 정합(base 부재로 미발화) |
| 악세 수량구간할인 부재 | t_prd_product_discount_tables 0(부자재) | ✅ 정당 부재(굿즈와 결정적 차이) |
| 천정고리(008) | use_yn=N 판매중지 | ✅ EXCLUDED 정당(needed=N) |
| 직접단가 선점 | 전 34 prd product_prices 0(문구/악세 INSERT 대상) → 현재 전부 FORMULA/NONE(C1) | ✅ 선점 위험 0 |
