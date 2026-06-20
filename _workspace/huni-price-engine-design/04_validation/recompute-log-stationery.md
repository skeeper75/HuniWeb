# recompute-log-stationery.md — 문구 골든 재계산 로그 (E6)

> hpe-validator 독립 재계산. pricing.py(`raw/webadmin/webadmin/catalog/pricing.py`) 충실 재구현으로 GC-ST1~15 전건을 라이브 단가행·DSC 구간으로 재계산해 권위 골든값과 허용오차 0 대조.
> 라이브 읽기전용 SELECT 2026-06-20. 단가값=라이브 verbatim(날조 0).

---

## 0. 재계산 엔진 (pricing.py 충실 재구현·코드 라인 검증)

- **component_subtotal(:177-192)**: 단가형(.01) `return up * q`(÷min_qty 미발생) / 합가형(.02) `up / tier_min_qty * q`.
- **match_component tier 선택(:144-162)**: min_qty TIER='이상' 하한 → 주문량(qty) 이하 최대 min_qty 행.
- **apply_discount(:195-211)**: 정률(DSC_TYPE.01) `amount × (1 − rate/100)`.
- **round_won(:63)**: ROUND_HALF_UP 정수.
- **할인 연결(:360·:478-504)**: `_quantity_discount(eff_prd_cd)` → t_prd_product_discount_tables prd_cd→dsc_tbl_cd.

## 1. 라이브 입력 데이터 (SELECT 결과)

- **COMP_TTEOKME**: comp_typ=.06·prc_typ=.01·use_dims=[siz_cd,bdl_qty,min_qty]·112행·NULL min_qty 0건·unit 850~3200·apply_ymd 전건 2026-06-01.
- **단가 사다리(90x90 100장1권)**: 6=3200·12=2500·18=2400·24=2300·30=2200·...·600=1050 (단조 비증가).
- **단가 사다리(70x120 50장1권)**: 6=3000·12=2300·...·600=850.
- **DSC_STAT_QTY**: 정률·1~49=0%·50~99=5%·100~499=10%·500~999=15%·1000~=20%.
- **본체 AC열**: 9000/12000/15000/15000/12000/4500/3000/5000(6000)/2500.

## 2. 본체 고정가형 재계산 (GC-ST1~9·PRODUCT_PRICE·DSC 링크 보완 후)

```
GC-ST1  9000×1     =9,000      dsc 0%  → 9,000        골든 9,000      ✓
GC-ST2  9000×50    =450,000    dsc 5%  → 427,500      골든 427,500    ✓
GC-ST3  12000×1    =12,000     dsc 0%  → 12,000       골든 12,000     ✓
GC-ST4  15000×100  =1,500,000  dsc 10% → 1,350,000    골든 1,350,000  ✓
GC-ST5  12000×1    =12,000     dsc 0%  → 12,000       골든 12,000     ✓
GC-ST6  4500×10    =45,000     dsc 0%  → 45,000       골든 45,000     ✓
GC-ST7  3000×500   =1,500,000  dsc 15% → 1,275,000    골든 1,275,000  ✓
GC-ST8  2500×1000  =2,500,000  dsc 20% → 2,000,000    골든 2,000,000  ✓
GC-ST9  5000×1     =5,000      dsc 0%  → 5,000        골든 5,000      ✓
```

## 3. 떡메모 매트릭스 재계산 (GC-ST10~15·FORMULA·.01 단가형)

```
GC-ST10 90x90/100/qty6   tier min_qty=6   unit=3200  sub=3200×6=19,200    dsc 0%  → 19,200   골든 19,200   ✓
GC-ST11 90x90/100/qty30  tier min_qty=30  unit=2200  sub=2200×30=66,000   dsc 0%  → 66,000   골든 66,000   ✓
GC-ST12 90x90/100/qty600 tier min_qty=600 unit=1050  sub=1050×600=630,000 dsc 15% → 535,500  골든 535,500  ✓
GC-ST13 90x90/50/qty6    tier min_qty=6   unit=3000  sub=3000×6=18,000    dsc 0%  → 18,000   골든 18,000   ✓
GC-ST14 70x120/50/qty6   tier min_qty=6   unit=3000  sub=3000×6=18,000    dsc 0%  → 18,000   골든 18,000   ✓
GC-ST15 70x120/100/qty12 tier min_qty=12  unit=2500  sub=2500×12=30,000   dsc 0%  → 30,000   골든 30,000   ✓
```

**전건 15/15 일치 (허용오차 0).**

## 4. ★충돌 결판 — 양면 재계산 (cartographer↔designer)

### 4-1. 떡메모 ×qty (DT-2): designer(÷min_qty 미적용) vs cartographer(÷min_qty 적용)

```
GC-ST10  designer: 3200×6      = 19,200  (=골든)
         cartographer: (3200÷6)×6 = 3,200  ← 골든 19,200과 모순
GC-ST12  designer: 1050×600    = 630,000 (=골든, 할인전)
         cartographer: (1050÷600)×600 = 1,050  ← 골든 630,000과 모순
```
**갈린 지점**: component_subtotal 분기. COMP_TTEOKME=prc_typ .01(단가형)이므로 pricing.py :192 `return up*q`로 ÷min_qty가 **발생하지 않음**. cartographer가 가정한 "교정안 A(÷min_qty)"를 적용하면 골든과 정면 모순. **라이브 단가 사다리(min_qty↑→unit↓ 단조)가 unit=권당가를 증명** → designer DT-2 정확.

### 4-2. DSC 링크 (DT-4): 보완 후 vs 현 라이브(누락)

```
GC-ST4 (174·qty100)  보완후: 1,500,000×0.9 = 1,350,000 (10% 할인)
                     현라이브(링크누락): 1,500,000 (할인 0·과청구 +150,000)
GC-ST12 (097·qty600) 보완후: 535,500
                     현라이브(바인딩 0): source=NONE → 가격계산 불가
```
**갈린 지점**: `_quantity_discount`가 `t_prd_product_discount_tables`에서 prd_cd→DSC_STAT_QTY 링크를 못 찾으면 할인 0. 링크 누락 4건(173/174/175/097) = 과청구·계산불가 결함 실증. 진원=링크/바인딩 미적재(단가값 verbatim 옳음).

## 5. 결론

골든 15/15 허용오차 0 재현. 충돌 2종 라이브 결판 = designer 정확. 결함은 그릇 미적재(product_prices 0·바인딩 0)·링크 누락(4)이지 단가값 오류 아님. E6 **PASS**.
