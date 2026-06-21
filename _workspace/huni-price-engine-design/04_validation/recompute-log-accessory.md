# recompute-log-accessory.md — 상품악세사리 골든 재계산 로그 (E6·허용오차 0)

> **hpe-validator 독립 재계산.** `golden-cases-accessory.md` GC-AC1~15를 pricing.py 산식(round_won·component_subtotal·:177-192) 충실 재구현으로 실제 재계산해 권위 단가(상품마스터 260610 I열 verbatim)와 허용오차 0 대조.
> 라이브 실측 2026-06-22(Railway `db railway`·psql 읽기전용 SELECT). 단가값 출처: product-accessory-l1.csv(67 variant행) 셀 단위 재대조.

---

## 0. 재계산 환경 (pricing.py 산식 충실 재구현)

```python
round_won(x) = int(Decimal(x).quantize(Decimal('1'), ROUND_HALF_UP))   # :round_won
def comp_subtotal(prc_typ, unit_price, tier_min_qty, qty):             # pricing.py:177-192
    up, q = Decimal(unit_price), Decimal(qty)
    if prc_typ == "PRICE_TYPE.02":          # 합가형
        base = tier_min_qty or 0
        if base <= 0: raise ValueError       # :188
        return (up/Decimal(base))*q          # :189-190
    return up*q                              # 단가형 기본 :191-192
```
- AC-1 = PRODUCT_PRICE: `base = unit_price × qty`(:317)·구간할인 no-op(:356-360 바인딩 0행).
- AC-2 = FORMULA: variant 정확매칭(NON_QTY_DIMS :38-39) 1행 → `.01` 단가형 unit×qty.
- addon = TEMPLATE_PRICE: `unit_price × qty`(:296-297).

---

## 1. AC-1 단일고정가 (PRODUCT_PRICE·.01·구간할인 없음)

| ID | 상품 | unit(I열 verbatim·CSV row) | qty | 재계산 | 골든 | 판정 |
|----|------|----------------------------|-----|--------|------|------|
| GC-AC1 | 볼체인 PRD_000006 | 1,000 (row37~44 8색 동가) | 1 | 1,000 | 1,000 | ✓ |
| GC-AC2 | 볼체인 PRD_000006 | 1,000 | 50 | 50,000 | 50,000 | ✓ |
| GC-AC3 | 와이어링 PRD_000007 | 500 (row45~47 3색 동가) | 10 | 5,000 | 5,000 | ✓ |
| GC-AC4 | 리필잉크 PRD_000015 | 2,500 (row63~69 7색 동가) | 7 | 17,500 | 17,500 | ✓ |

- **구간할인 부재 입증(GC-AC2)**: 볼체인 50개 = 50,000 정가(굿즈였다면 5% 할인 47,500). 라이브 t_prd_product_discount_tables AC 바인딩 0행 재대조 → no-op 정상.
- **색상 동가 입증(GC-AC1)**: CSV row37~44 볼체인 8색(오렌지~화이트) 전부 1,000 → 색상 무관 동가·가격축 아님.

---

## 2. AC-2 변형고정가 (FORMULA·COMP_ACC_* .01 단가형·variant 정확매칭)

| ID | 상품 variant(축) | unit(I열 verbatim·CSV row) | qty | 재계산 | 골든 | 판정 |
|----|-------------------|----------------------------|-----|--------|------|------|
| GC-AC5 | OPP접착 70x200(siz_cd) | 1,100 (row3) | 1 | 1,100 | 1,100 | ✓ |
| GC-AC6 | OPP접착 230x350(siz_cd) | 3,250 (row13) | 1 | 3,250 | 3,250 | ✓ |
| GC-AC7 | 트래싱지 160x110 20장(siz+bdl) | 6,000 (row24) | 1 | 6,000 | 6,000 | ✓ |
| GC-AC8 | 트래싱지 160x110 100장(siz+bdl) | 28,000 (row26) | 1 | 28,000 | 28,000 | ✓ |
| GC-AC9 | 카드봉투 화이트(opt_cd) | 1,000 (row33) | 1 | 1,000 | 1,000 | ✓ |
| GC-AC10 | 카드봉투 블랙(opt_cd) | 1,500 (row34) | 1 | 1,500 | 1,500 | ✓ |
| GC-AC11 | 우드행거 440mm(siz_cd) | 20,000 (row62) | 2 | 40,000 | 40,000 | ✓ |
| GC-AC12 | 투명케이스 75x110x15(siz_cd) | 3,500 (row51) | 10 | 35,000 | 35,000 | ✓ |

- variant 정확매칭(NON_QTY_DIMS·siz_cd/opt_cd/bdl_qty) 1행 룩업 → .01 단가형 unit×qty. 전건 일치.

### 2-1. 돈크리티컬 양면 — 평탄화 (G-AC-1·NO-GO 입증)

| 시나리오 | 계산 | 결과 | 판정 |
|----------|------|------|------|
| OPP 230x350 올바른(variant) | siz_cd 정확매칭 3,250 | **3,250** | ✅ |
| OPP 230x350 잘못된(평탄화) | 첫행 1,100 뭉갬 | **1,100** | 🔴 66% 과소 |
| 트래싱지 100장 올바른(bdl_qty) | bdl_qty=100 28,000 | **28,000** | ✅ |
| 트래싱지 100장 잘못된(평탄화) | 20장가 6,000 뭉갬 | **6,000** | 🔴 78.6% 과소 |

### 2-2. 돈크리티컬 양면 — .02 합가형 오적용 (G-AC-2)

| 시나리오 | 계산(:185-192) | 결과 | 판정 |
|----------|----------------|------|------|
| OPP 70x200 (50장) .01 단가형 | 1,100×1 (÷ 미발생) | **1,100** | ✅ 1팩가 |
| OPP 70x200 (50장) .02 합가형 min_qty=50 | 1,100÷50×1 | **22** | 🔴 98% 붕괴 |

→ prc_typ=PRICE_TYPE.01 강제(설계 §3-2)가 붕괴를 막음. 봉투제작 PRD_000050(PRD_TYPE.01·합가형 MATRIX 별 상품군 라이브 확인)과 정반대.

---

## 3. addon 봉투 (TEMPLATE_PRICE·.01·이중역할)

| ID | template | 봉투 variant | unit(I열·CSV row) | qty | 재계산 | 골든 | 판정 |
|----|----------|--------------|--------------------|-----|--------|------|------|
| GC-AC13 | TMPL-000005 | OPP접착 110x160 50장 | 1,200 (row9) | 100 | 120,000 | 120,000 | ✓ |
| GC-AC14 | TMPL-000009 | 트레싱지봉투 160x110 20장 | 6,000 (row24) | 50 | 300,000 | 300,000 | ✓ |
| GC-AC15 | TMPL-000010 | 카드봉투 화이트 165x115 50장 | **불일치** | — | — | 구조검증만 | BLOCKED |

- **GC-AC13/14**: TEMPLATE_PRICE 경로(tmpl_cd 타깃 → :296-297 unit×qty). 단가 CSV verbatim. template base_prd_cd 매핑 라이브 확인(TMPL-000005→PRD_000001·009→PRD_000283).
- **★GC-AC15 묶음수 불일치 BLOCKED(정직)**: TMPL-000010 라벨 "50장"인데 CSV 카드봉투(row33)는 "화이트 165x115 mm (10장) 1000". **50장 묶음 단가가 시트에 없음** → 10장가(1000)를 50장 template에 넣으면 오청구. 추측 적재 금지·Q-AC-TMPL 컨펌큐. designer 정직 처리 정당.

---

## 4. 재계산 종합

| 골든군 | 케이스 | 결과 |
|--------|:--:|------|
| AC-1 단일고정가 | 4 | **4/4 허용오차 0** |
| AC-2 변형고정가 | 8 | **8/8 허용오차 0** |
| addon 봉투 | 2(+1 BLOCKED) | **2/2 허용오차 0**·GC-AC15 정직 BLOCKED |
| 돈크리티컬 양면 | 평탄화 2·.02 붕괴 1 | **전건 NO-GO 방향 독립 재현** |

- **결함 진원**: AC 현 라이브 0원은 t_prd_product_prices/template_prices/formula 전무(적재 결함)이지 단가값 결함 아님(I열 verbatim 옳음). 평탄화/.02 오적용은 적재 방식 함정 → 설계 가드(variant use_dims 충전·.01 강제)가 정확히 차단.
- **허용오차 0 달성**·날조 0·designer 창작 0(전 단가 CSV/I열 verbatim).
