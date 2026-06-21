# golden-cases-accessory.md — 상품악세사리 가격엔진 골든 케이스 (E6 검증용·허용오차 0)

> **hpe-engine-designer 산출.** `engine-design-accessory.md` 설계 공식으로 계산되는 대표 케이스 + 기대 골든값(권위 verbatim).
> 검증가(hpe-validator E6)·codex(Phase 5.5)가 **설계 공식·단가행으로 실제 재계산**해 권위값과 **허용오차 0** 대조한다.
> 단가값 출처: ① AC-1=상품마스터 260610 상품악세사리(가격포함) 시트 `가격`(I열) inline verbatim(L1 row 36~68) · ② AC-2 변형단가=상품마스터 I열 행별 verbatim(L1 row 3~62) · ③ addon=동일 봉투 variant I열 verbatim.
> 엔진 계약: pricing.py(PRODUCT_PRICE unit×qty / FORMULA comp variant 단가형 unit×qty / TEMPLATE_PRICE unit×qty / **수량구간할인 없음**=부자재 미해당).

---

## 0. 골든 산출 규칙 (엔진 재현 절차)

### 0-1. AC-1 단일고정가 (PRODUCT_PRICE 경로·구간할인 없음)
```
base_amount = t_prd_product_prices.unit_price × qty          (pricing.py:315-317)
→ _quantity_discount: 부자재 미바인딩 → no-op (할인 0·:482-483 링크 0행)
→ final = round_won(base_amount)
```
★ 굿즈 GP-1과 달리 **수량구간할인 곱 단계 없음**(부자재는 구간할인 미해당). base가 곧 final.

### 0-2. AC-2 변형고정가 (FORMULA 경로·COMP_ACC_* .01 단가형)
```
① 단가행 선택: variant축(siz_cd / opt_cd / bdl_qty) 정확매칭(NON_QTY_DIMS·:38-39)
   = 손님 선택 variant 1행 확정 (평탄화 시 오선택·G-AC-1)
② component_subtotal: prc_typ=.01 단가형 → unit_price × qty   (:177-183·÷min_qty 미발생·1팩당가)
→ final = round_won(unit×qty)   (구간할인 no-op)
```
★ **variant축은 단가행 선택용 판별차원**(1팩당 완제품가 결정)·평탄화하면 230x350 주문에 70x200 가격 오청구. **묶음수 bdl_qty는 식별차원이지 ÷ 분모 아님**(G-AC-2).

### 0-3. addon 봉투 (TEMPLATE_PRICE 경로)
```
base_amount = t_prd_template_prices.unit_price × qty          (pricing.py:296-297)
   (template_prices 미적재 시 fallback → 기준 상품 가격·:299-300 → 둘 다 0이면 0원)
→ final = round_won   (구간할인 no-op)
```

---

## 1. AC-1 단일고정가 골든 (GC-AC1~GC-AC4·PRODUCT_PRICE·구간할인 없음)

> 단가=상품마스터 I열 verbatim·구간할인 없음(부자재 미바인딩).

| ID | 상품 | unit_price(I열) | qty | base=unit×qty | 구간할인 | **final(골든)** |
|----|------|-----------------|-----|---------------|----------|-----------------|
| **GC-AC1** | 볼체인·PRD_000006 | 1,000 | 1 | 1,000 | 없음(no-op) | **1,000** |
| **GC-AC2** | 볼체인·PRD_000006 | 1,000 | 50 | 50,000 | 없음 | **50,000** |
| **GC-AC3** | 와이어링·PRD_000007 | 500 | 10 | 5,000 | 없음 | **5,000** |
| **GC-AC4** | 만년스탬프 리필잉크·PRD_000015 | 2,500 | 7 | 17,500 | 없음 | **17,500** |

★ **구간할인 부재 입증(GC-AC2)**: 볼체인 50개 = 50,000 정가(굿즈였다면 DSC_GOODSA 50~99구간 5% 할인되어 47,500). **부자재는 구간할인 미바인딩이라 정가**(검증가 가드: t_prd_product_discount_tables prd_cd 0행 재대조·할인 링크 발명 금지).

★ **색상 동가 입증(GC-AC1)**: 볼체인 8색(오렌지~화이트) 전부 1000원 → 색상 무관 동가. 색상은 식별축이지 가격축 아님(AC-1 단일가).

★ **돈크리티컬 양면(base 0 현 라이브)**: AC-1 product_prices가 라이브 0행이라 **현재는 source=NONE·가격계산 불가(0원)**. 골든은 **I열 단가 적재 후** 기대값. 진원=t_prd_product_prices 미적재(단가값 결함 아님·I열 verbatim 옳음).

---

## 2. AC-2 변형고정가 골든 (GC-AC5~GC-AC12·FORMULA·평탄화 양면 입증)

> variant 단가=상품마스터 I열 행별 verbatim(L1 실측). ★variant축 정확매칭 입증 + 평탄화·묶음 ÷ 양면.

| ID | 상품 | variant(축) | unit_price(I열 verbatim) | qty | base=unit×qty | **final(골든)** |
|----|------|-------------|--------------------------|-----|---------------|-----------------|
| **GC-AC5** | OPP접착봉투·PRD_000001 | 70x200mm(siz_cd) | 1,100 | 1 | 1,100 | **1,100** |
| **GC-AC6** | OPP접착봉투·PRD_000001 | 230x350mm(siz_cd) | 3,250 | 1 | 3,250 | **3,250** |
| **GC-AC7** | 트래싱지카드봉투·PRD_000003 | 160x110mm 20장(siz_cd+bdl_qty) | 6,000 | 1 | 6,000 | **6,000** |
| **GC-AC8** | 트래싱지카드봉투·PRD_000003 | 160x110mm 100장(siz_cd+bdl_qty) | 28,000 | 1 | 28,000 | **28,000** |
| **GC-AC9** | 카드봉투·PRD_000004 | 화이트(opt_cd) | 1,000 | 1 | 1,000 | **1,000** |
| **GC-AC10** | 카드봉투·PRD_000004 | 블랙(opt_cd) | 1,500 | 1 | 1,500 | **1,500** |
| **GC-AC11** | 우드행거·PRD_000014 | 440mm(siz_cd) | 20,000 | 2 | 40,000 | **40,000** |
| **GC-AC12** | 투명케이스·PRD_000009 | 75x110x15mm(siz_cd) | 3,500 | 10 | 35,000 | **35,000** |

★ **GC-AC5/6 = 규격 variant 정확매칭(G-AC-1 핵심)**: 같은 OPP접착봉투라도 70x200=1,100·230x350=3,250을 **각 variant 단가행이 siz_cd 정확매칭**(NON_QTY_DIMS·:38-39)으로 룩업. 손님이 230x350 선택 시 3,250이 나와야 정상.

★ **GC-AC7/8 = 묶음수 variant 정확매칭(G-AC-2 핵심·돈크리티컬)**: 같은 160x110mm라도 20장=6,000·100장=28,000을 **bdl_qty 차원으로 분리 룩업**. 100장 주문이 6,000(20장가)으로 뭉개지면 78% 과소청구. bdl_qty=100 단가행 28,000은 "100장 1팩당"이고 ×qty(팩수)가 정당(÷ 환산 금지).

### 2-1. ★평탄화 오청구 양면 케이스 (G-AC-1 돈크리티컬·NO-GO 입증용)

AC-2를 AC-1처럼 단일 unit_price로 평탄 적재하면(잘못된 설계) 규격/묶음이 한 값으로 뭉개진다.

| 시나리오 | OPP접착봉투 230x350 주문(qty=1) | 결과 | 판정 |
|----------|---------------------------------|------|------|
| **올바른 설계 (variant 판별차원)** | siz_cd=230x350 정확매칭 → 3,250 룩업 | **3,250** | ✅ 정상 |
| **잘못된 설계 (평탄화 — 70x200가로 뭉갬)** | 단일 unit_price=1,100(첫 행) → 1,100 | **1,100** | 🔴 과소청구(66%) |

| 시나리오 | 트래싱지 160x110 100장 주문(qty=1) | 결과 | 판정 |
|----------|------------------------------------|------|------|
| **올바른 설계 (bdl_qty 판별차원)** | siz_cd+bdl_qty=100 정확매칭 → 28,000 | **28,000** | ✅ 정상 |
| **잘못된 설계 (묶음 평탄화 — 20장가로 뭉갬)** | bdl_qty 무시·6,000 | **6,000** | 🔴 과소청구(78%) |

### 2-2. ★묶음 합가형(.02) 오적용 양면 케이스 (G-AC-2 돈크리티컬)

묶음수 "(50장)"을 합가형(.02·구간총액÷min_qty)으로 오해 시(잘못된 설계) 가격 붕괴.

| 시나리오 | OPP접착봉투 70x200 (50장) 1팩 주문(qty=1) | 계산 | 결과 | 판정 |
|----------|-------------------------------------------|------|------|------|
| **올바른 설계 (.01 단가형)** | unit×qty = 1,100×1 (:181 ÷ 미발생) | 1,100 | **1,100** | ✅ 정상(1팩 가격) |
| **잘못된 설계 (.02 합가형·min_qty=50)** | unit÷min_qty×qty = 1,100÷50×1 (:181) | 22 | **22** | 🔴 가격 붕괴(98% 손실) |

★ **prc_typ=.01 강제(§3-2)**가 이 붕괴를 막는다. 봉투제작(PRD_000050 별 상품군)은 합가형이나 상품악세사리 봉투는 inline 고정가형(.01·1팩당)이라 정반대(검증가 가드: COMP_ACC_* prc_typ_cd=PRICE_TYPE.01 재대조).

---

## 3. addon 봉투 골든 (GC-AC13~GC-AC15·TEMPLATE_PRICE·이중역할 양면)

> addon 단가=동일 봉투 variant I열 verbatim·엽서(PRD_000016) 손님이 봉투 옵션 선택 시.

| ID | template | tmpl 봉투 variant | template_prices.unit_price | qty | base=unit×qty | **final(골든)** |
|----|----------|-------------------|----------------------------|-----|---------------|-----------------|
| **GC-AC13** | TMPL-000005 | OPP접착봉투 110x160mm 50장 | 1,200(I열 row10) | 100 | 120,000 | **120,000** |
| **GC-AC14** | TMPL-000009 | 트레싱지봉투 160x110mm 20장 | 6,000(I열 row24) | 50 | 300,000 | **300,000** |
| **GC-AC15** | TMPL-000010 | 카드봉투(화이트) 165x115mm 50장 | (★Q-AC-TMPL 미해소) | — | — | **구조 검증만** |

★ **GC-AC13/14 = TEMPLATE_PRICE 경로 입증**: 봉투를 엽서 addon으로 붙이면 엔진이 tmpl_cd 타깃→TEMPLATE_PRICE(:296-297)로 template 단가 룩업(PRODUCT_PRICE보다 우선·경로 분기·충돌 없음). template_prices 미적재면 fallback(:300)→기준상품 0원.

★ **GC-AC15 = 묶음수 불일치 BLOCKED(돈크리티컬·Q-AC-TMPL)**: TMPL-000010 라벨 "50장"인데 시트 카드봉투(004)는 "10장 1000". **template 50장 묶음 단가가 시트에 없음** → 추측 적재 금지·구조 검증만(컨펌큐). 시트 10장가(1000)를 50장 template에 넣으면 오청구.

★ **이중역할 양면(GC-AC13 vs GC-AC9)**: 같은 봉투라도 독립 주문(GC-AC9 카드봉투 화이트=PRODUCT_PRICE/FORMULA)과 addon 주문(GC-AC15=TEMPLATE_PRICE)이 **다른 테이블 경로**로 가격 산정. 충돌 없음(F-PA-1)·단 동일 variant면 단가 정합(양 경로 verbatim).

---

## 4. 골든 종합 + 검증가 재현 가드

| 골든군 | 케이스 수 | 입증 대상 | 핵심 가드 |
|--------|:--:|-----------|-----------|
| AC-1 단일고정가(§1) | 4 | PRODUCT_PRICE unit×qty·구간할인 없음 | 부자재 할인 미바인딩·색상 동가·base 0 양면 |
| AC-2 변형고정가(§2) | 8+양면 | FORMULA variant 정확매칭·1팩당가 ×qty | ★평탄화(G-AC-1)·묶음 .02 붕괴(G-AC-2) 돈크리티컬 NO-GO 입증 |
| addon 봉투(§3) | 3 | TEMPLATE_PRICE 경로·이중역할 | 묶음수 불일치 BLOCKED(Q-AC-TMPL)·양 경로 정합 |

**검증가 재현 절차(E6·허용오차 0):**
1. **AC-1**: 상품마스터 I열 단가 재대조(verbatim) → unit×qty → **구간할인 no-op 확인**(t_prd_product_discount_tables prd_cd 0행) → round_won.
2. **AC-2**: variant축(siz_cd/opt_cd/bdl_qty) 단가행 정확매칭 1행 룩업(:38-39) → 단가형 unit×qty(÷ 미발생) → round_won. **평탄화 양면(§2-1)·.02 붕괴 양면(§2-2)으로 입증**.
3. **addon**: template_prices verbatim → unit×qty. 묶음수 불일치(GC-AC15) BLOCKED 확인.
4. **돈크리티컬 양면**: AC-1 base 0(현 라이브 source=NONE)·AC-2 평탄화/.02 붕괴 양면 대조 → 결함 진원이 적재/평탄화/prc_typ이지 단가값 아님 입증.

★ **단가값 출처 재확인[HARD]**: AC-1/AC-2/addon 단가는 전부 상품마스터 I열 verbatim(designer 창작 0·L1 row 3~68 실측). 할인 없음(부자재 미해당). DB 미적재 — 실 적용 인간 승인 후 dbmap 위임.
