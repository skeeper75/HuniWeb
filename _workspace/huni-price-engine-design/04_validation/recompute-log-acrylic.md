# recompute-log-acrylic.md — 아크릴 골든 독립 재계산 로그

> hpe-validator 독립 실측·재계산 (2026-06-20·라이브 읽기전용 SELECT·DB 쓰기 0).
> 방법: 라이브 `t_prc_component_prices` 238행을 덤프 → `pricing.py`의 `match_component`+`component_subtotal`
> 알고리즘을 **충실 재구현**(Django 비의존)해 골든 8건 재계산 → 기대값 대조(허용오차 0).
> **순환참조 차단**: 단가는 라이브 verbatim·기대값은 권위 가격표(260527) 셀 trace·설계가 산출값 비참조.

---

## 1. 라이브 단가행 실측 (재현 SQL)

```sql
-- comp 마스터 use_dims/prc_typ
SELECT comp_cd, prc_typ_cd, use_dims, comp_typ_cd FROM t_prc_price_components
 WHERE comp_cd LIKE 'COMP_ACRYL_%';
-- 결과:
-- COMP_ACRYL_CLEAR3T  | PRICE_TYPE.02 | ["siz_width","siz_height","mat_cd"] | PRC_COMPONENT_TYPE.01
-- COMP_ACRYL_COROTTO  | PRICE_TYPE.01 | ["siz_width","siz_height"]          | PRC_COMPONENT_TYPE.01
-- COMP_ACRYL_MIRROR3T | PRICE_TYPE.01 | ["siz_width","siz_height"]          | PRC_COMPONENT_TYPE.01
-- COMP_ACRYL_CARABINER / COMP_ACRYL_FINISH : 부재(0행)
```

```sql
-- min_qty 계약 (돈크리티컬)
SELECT comp_cd, count(*) rows, count(distinct min_qty) dist, min(min_qty), max(min_qty),
       sum((min_qty IS NULL)::int) nullq, sum((min_qty=1)::int) eq1
  FROM t_prc_component_prices WHERE comp_cd LIKE 'COMP_ACRYL_%' GROUP BY comp_cd;
-- COMP_ACRYL_CLEAR3T  | 165 | dist=1 | mn=1 mx=1 | null=0 | eq1=165   ← 전건 1
-- COMP_ACRYL_COROTTO  |  21 | dist=1 | mn=1 mx=1 | null=0 | eq1=21    ← 전건 1
-- COMP_ACRYL_MIRROR3T |  52 | dist=0 |  -    -   | null=52| eq1=-     ← 전건 NULL(.01·÷미발생)
```

```sql
-- 두께=mat_cd 분기 (CLEAR3T)
SELECT mat_cd, count(*) FROM t_prc_component_prices WHERE comp_cd='COMP_ACRYL_CLEAR3T' GROUP BY mat_cd;
-- MAT_000042 | 52   (1.5T)
-- MAT_000043 | 113  (3T)   ← 합 165
```

```sql
-- 골든 단가 verbatim
-- CLEAR 30x30 3T  = 3100.00 (min_qty=1)
-- CLEAR 30x30 1.5T= 2480.00 (min_qty=1)   (=3100×0.8)
-- CLEAR 50x30 3T  = 3800.00 (min_qty=1)
-- CLEAR 30x50 3T  = 0행(부재)              ← W×H 비대칭 축 입증(역방향 셀 없음)
-- CLEAR 40x40 3T  = 3800.00 (off-grid 35x35 ceiling 대상)
-- COROTTO 30x30   = 3600.00 (min_qty=1)
-- MIRROR 20x20    = 5000.00 (min_qty=NULL)
```

```sql
-- work-size 미사용 가드 (siz_cd NULL·WH 전환 COMMIT)
SELECT comp_cd, sum((siz_cd IS NULL)::int), sum((siz_width IS NOT NULL)::int), count(*)
  FROM t_prc_component_prices WHERE comp_cd LIKE 'COMP_ACRYL_%' GROUP BY comp_cd;
-- 전건 siz_cd NULL · siz_width NOT NULL (165/21/52 모두)
```

```sql
-- off-grid 격자점(35 부재 확인)
SELECT DISTINCT siz_width FROM t_prc_component_prices
 WHERE comp_cd='COMP_ACRYL_CLEAR3T' AND mat_cd='MAT_000043' ORDER BY 1;
-- 20,30,40,50,60,70,80,90,100,120,140,160,180,200 (35 없음 → 35→ceiling 40)
SELECT count(*) FROM t_prc_component_prices
 WHERE comp_cd='COMP_ACRYL_CLEAR3T' AND (siz_width=35 OR siz_height=35);  -- 0행(ceiling 위장 행 없음)
```

```sql
-- G-A1 바인딩 실상
SELECT prd_cd, frm_cd FROM t_prd_product_price_formulas WHERE frm_cd LIKE '%ACRYL%';
-- PRD_000142 | PRF_POSTER_ACRYLSTK_GLOSS   (별 poster-sign 트랙)
-- PRD_000143 | PRF_POSTER_ACRYLSTK_MIRROR  (별 poster-sign 트랙)
-- PRD_000146 | PRF_CLR_ACRYL               ← 본체 아크릴 바인딩 1건뿐 ★G-A1 입증
-- 설계 17 바인딩 대상 상품 전건 use_yn=Y·del_yn=N(활성)·1만 기바인딩 → 16 미바인딩
```

```sql
-- 공식·배선 (각 공식 comp 1개=이중합산 구조적 불가)
SELECT frm_cd, comp_cd, disp_seq, addtn_yn FROM t_prc_formula_components WHERE frm_cd LIKE '%ACRYL%';
-- PRF_CLR_ACRYL     | COMP_ACRYL_CLEAR3T | 1 | N
-- PRF_COROTTO_ACRYL | COMP_ACRYL_COROTTO | 1 | N
SELECT frm_cd, use_yn FROM t_prc_price_formulas WHERE frm_cd LIKE '%ACRYL%';
-- PRF_CLR_ACRYL Y · PRF_COROTTO_ACRYL Y · (PRF_MIRROR_ACRYL 부재 · PRF_CARABINER_ACRYL 부재)
```

```sql
-- 카라비너 GAP
SELECT (SELECT count(*) FROM t_prc_price_components WHERE comp_cd='COMP_ACRYL_CARABINER') comp,
       (SELECT count(*) FROM t_prc_price_formulas  WHERE frm_cd='PRF_CARABINER_ACRYL') frm;
-- comp=0 · frm=0 (2중 GAP)
```

---

## 2. 골든 8건 독립 재계산 (engine 충실 재구현·허용오차 0)

| 케이스 | 매칭단가 | tier_min_qty | 계산식 | 재계산 | 기대(가격표) | 판정 |
|--------|---------|-------------|--------|--------|-------------|------|
| GC-A1 키링30×30 3T ×100 | 3,100 | 1 | (3100÷1)×100 | **310,000** | 310,000 | ✅ |
| GC-A1 키링30×30 3T ×1 | 3,100 | 1 | (3100÷1)×1 | **3,100** | 3,100 | ✅ |
| GC-A2 키링30×30 1.5T ×1 | 2,480 | 1 | (2480÷1)×1 | **2,480** | 2,480 | ✅ |
| GC-A3 비대칭 50×30 3T ×1 | 3,800 | 1 | (3800÷1)×1 | **3,800** | 3,800 | ✅ |
| GC-A4 off-grid 35×35 3T ×1 | 3,800(40×40 ceiling) | 1 | (3800÷1)×1 | **3,800** | 40×40 셀=3,800 | ✅ |
| GC-A5 코롯토 30×30 ×1 | 3,600 | 1 | 3600×1 | **3,600** | 3,600 | ✅ |
| GC-A6 미러 20×20 ×1 | 5,000 | NULL | 5000×1(÷미발생) | **5,000** | 5,000 | ✅ |
| GC-A6b 미러 20×20 ×10 | 5,000 | NULL | 5000×10 | **50,000** | — | ✅(scaling) |

**ALL GOLDEN REPRODUCED (tol 0) = True.**

- GC-A4 off-grid: `match_component` TIER_UPPER 로직(`pricing.py:149-152`) 실행 — width 35 → eligible tiers≥35 = {40,50,...} → min=40·height 동일 → 40×40 셀(라이브 3,800) 선택. **단가행에 35×35 행 0건 confirm = ceiling은 런타임 계산이지 위장 룩업 아님**(dodge 없음).
- GC-A6 미러: prc_typ=.01·min_qty=NULL → `component_subtotal` 단가형 분기(`pricing.py:191-192`)로 ÷ 자체 미발생 → ValueError 위험 0 confirm.

---

## 3. ×qty 계약 재현 증명 (디지털인쇄 결함과 정반대 입증)

```
CLEAR3T .02 + min_qty=1 : per_item = unit÷1 = unit(개당가) → subtotal = unit × qty
  → 3,100 ×100 = 310,000  (개당 3,100·정상)
대조(디지털 결함 클래스): 단가가 "묶음총액"이고 min_qty=100이면 .02는 3100÷100×100=3,100
  → 단가 의미(개당 vs 묶음)가 결과를 가른다.
```

라이브 단가 = **개당 완제품가**(가격표 매트릭스 셀이 "그 사이즈 1개 완제품가")이고 min_qty=1 → `component_subtotal`이 곧 `unit×qty`. 디지털인쇄 명함 결함(단가가 100매 묶음총액인데 ×100 폭발)과 **단가 의미가 정반대** → ×qty 과청구 위험 아크릴에 **없음**. designer 주장 §3-2 **라이브·코드로 재현 확인**.

---

## 4. 갈린 지점 (불일치) — 없음

골든 8건 전건 일치(허용오차 0). 불일치 0건. 진원 추적 불요.
유일한 "현재 견적 불가" 상태는 **G-A1 미바인딩**(엔진·단가 결함 아님·바인딩 INSERT 후 정상) — 설계가 닫는 대상.
