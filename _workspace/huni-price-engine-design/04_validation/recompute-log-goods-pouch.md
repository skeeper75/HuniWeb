# recompute-log-goods-pouch.md — 굿즈/파우치 골든 재계산 로그 (E6·허용오차 0)

> hpe-validator 독립 재계산. pricing.py(`raw/webadmin/webadmin/catalog/pricing.py`) 산식 충실 재구현(ORM 비의존 헬퍼 직접).
> 라이브 4종 구간할인 디테일 verbatim(SELECT 2026-06-20). GP-1/GP-2 단가=상품마스터 C열 verbatim(designer 표기분 12건). 결과: **GC-GP1~12 12/12 일치(허용오차 0)·GC-GP13~15 rate 재현·평탄화 양면 독립 재현.**

---

## 0. 재구현 산식 (pricing.py 라인 충실)

| 단계 | 코드 | 재구현 |
|------|------|--------|
| GP-1 base | `PRODUCT_PRICE` :315-317 | `unit_price × qty` |
| GP-2 base | `FORMULA`→`component_subtotal` :191-192(`.01`) | `unit_price × qty`(÷min_qty 미발생) |
| 구간 선택 | `pick_discount_detail` :215-226 | `min_qty ≤ qty ≤ max_qty(또는 max NULL)`·최신·max(min_qty) |
| 정률 할인 | `apply_discount` :206-209 | `amount × (1 − rate/100)`·음수 0막음 |
| 반올림 | `round_won` :63-65 | ROUND_HALF_UP |

**라이브 4종 구간 verbatim(2026-06-20 SELECT):**
```
DSC_GOODSA_QTY : 1~49=0 · 50~99=5 · 100~499=10 · 500~999=15 · 1000~=20
DSC_GOODSB_QTY : 1~99=0 · 100~499=5 · 500~=10
DSC_FABRIC_QTY : 1~49=0 · 50~99=5 · 100~499=10 · 500~999=15 · 1000~=20  (A타입 동일구조)
DSC_SQUISHY_QTY: 1~1=0 · 2~9=10 · 10~29=15 · 30~49=20 · 50~99=25 · 100~499=30 · 500~999=40 · 1000~=50
```
헤더 전건 use_yn=Y·DSC_TYPE.01(정률). 골든 단가표와 byte-동일.

---

## 1. GP-1 단일고정가 (GC-GP1~6·PRODUCT_PRICE)

| GC | 상품(라이브 식별 확인) | unit×qty | 타입(라이브 바인딩) | 구간 | rate | 재계산 | 골든 | 일치 |
|----|------------------------|----------|---------------------|------|------|--------|------|------|
| GC-GP1 | 카드거울(PRD_000185) | 2500×1 | DSC_GOODSB ✓ | 1~99 | 0% | 2,500 | 2,500 | ✓ |
| GC-GP2 | 틴거울(PRD_000183) | 3000×100 | DSC_GOODSB ✓ | 100~499 | 5% | 285,000 | 285,000 | ✓ |
| GC-GP3 | 틴거울(PRD_000183) | 3000×500 | DSC_GOODSB ✓ | 500~ | 10% | 1,350,000 | 1,350,000 | ✓ |
| GC-GP4 | 코르크코스터(PRD_000189) | 3000×100 | DSC_GOODSA ✓ | 100~499 | 10% | 270,000 | 270,000 | ✓ |
| GC-GP5 | 레더여권케이스(PRD_000196) | 5000×50 | DSC_GOODSA ✓ | 50~99 | 5% | 237,500 | 237,500 | ✓ |
| GC-GP6 | 코르크코스터(PRD_000189) | 3000×1000 | DSC_GOODSA ✓ | 1000~ | 20% | 2,400,000 | 2,400,000 | ✓ |

★A/B타입 구간차 입증: 코르크코스터(A·qty100=10%) vs 틴거울(B·qty100=5%) — 같은 100개 다른 할인. 굿즈 "타입입력"=4종 택1.

---

## 2. GP-2 변형고정가 (GC-GP7~12·FORMULA `.01`)

| GC | 상품 | variant(축) | unit×qty | 타입 | 구간 | rate | 재계산 | 골든 | 일치 |
|----|------|-------------|----------|------|------|------|--------|------|------|
| GC-GP7 | 사각손거울(186) | S(siz_cd) | 5000×1 | DSC_GOODSA ✓ | 1~49 | 0% | 5,000 | 5,000 | ✓ |
| GC-GP8 | 사각손거울(186) | M(siz_cd) | 5500×1 | DSC_GOODSA ✓ | 1~49 | 0% | 5,500 | 5,500 | ✓ |
| GC-GP9 | 사각손거울(186) | L(siz_cd) | 6000×100 | DSC_GOODSA ✓ | 100~499 | 10% | 540,000 | 540,000 | ✓ |
| GC-GP10 | 머그컵(193) | 11온스(opt_cd) | 6500×50 | DSC_GOODSB ✓ | 1~99 | 0% | 325,000 | 325,000 | ✓ |
| GC-GP11 | 머그컵(193) | 대용량(opt_cd) | 7500×100 | DSC_GOODSB ✓ | 100~499 | 5% | 712,500 | 712,500 | ✓ |
| GC-GP12 | 벨벳쿠션(195) | 양면(opt_cd) | 16000×10 | DSC_GOODSA ✓ | 1~49 | 0% | 160,000 | 160,000 | ✓ |

★variant 정확매칭(NON_QTY_DIMS siz_cd/opt_cd·:38-39·:81-86): S=5000/M=5500/L=6000 각 variant 단가행 정확매칭. ÷min_qty 미발생(`.01`).

### 2-1. ★평탄화 오청구 양면 (G-GP-3·돈크리티컬·NO-GO 입증) — 독립 재계산

사각손거울 M 주문(qty=1):
| 시나리오 | 룩업 | 재계산 | 판정 |
|----------|------|--------|------|
| 올바른 설계(variant 판별차원) | siz_cd=M 정확매칭 → 5500 | **5,500** | ✓ 정상 |
| 잘못된 평탄화(S단가로 뭉갬) | 단일 unit_price=5000 | **5,000** | 🔴 과소청구 |
| 잘못된 평탄화(L단가로 뭉갬) | 단일 unit_price=6000 | **6,000** | 🔴 과대청구 |

평탄화 방향에 따라 과소(M에 S가)·과대(M에 L가) 둘 다 발생. variant 행별 단가를 component_prices use_dims=[siz_cd/opt_cd]로 충전하면 방지. 디지털 인쇄면 silent 합산·실사 면적 좌표축 동류 가드.

---

## 3. 수량구간할인타입 (GC-GP13~15·rate 재현·단가 정직 보류)

| GC | 상품 | 타입 | qty | 구간 | rate(라이브 재현) | 골든식 |
|----|------|------|-----|------|-------------------|--------|
| GC-GP13 | 파우치(FABRIC·230) | DSC_FABRIC ✓ | 100 | 100~499 | **10%** | C열×100×0.90 |
| GC-GP14 | 메쉬에코백(FABRIC·279) | DSC_FABRIC ✓ | 500 | 500~999 | **15%** | C열×500×0.85 |
| GC-GP15 | 말랑(SQUISHY) | DSC_SQUISHY | 10 | 10~29 | **15%** | C열×10×0.85 |

★SQUISHY 소량급할인 교차 재계산(qty=10): GOODSA=0%·GOODSB=0%·FABRIC=0%·**SQUISHY=15%** — 할인타입별 구간 경계 완전 상이. 평탄 단일 할인 금지.
★C열 단가는 cartographer 미표기(dbmap C열 전수 추출 대상)=designer 정직 보류·날조 아님. rate 로직만 라이브 verbatim 재현(허용오차 0).

---

## 4. 종합

- **GC-GP1~12 12/12 일치(허용오차 0).** PRODUCT_PRICE/FORMULA `.01` 산식·pick_discount_detail bracket·정률 할인·round_won 라이브 코드 충실.
- **GC-GP13~15 rate 재현 OK·단가 보류(정직).**
- **평탄화 양면 독립 재현**(5500↔5000/6000) = G-GP-3 돈크리티컬 NO-GO 입증 논리 비준.
- **돈크리티컬 양면**: GP-1/GP-2 모두 현 라이브 product_prices 0·formula 0 → source=NONE·0원(가격계산 불가). 진원=고정가 본체 미적재(단가값 결함 아님·C열 verbatim 옳음·구간할인 바인딩 82+디테일 라이브 실재). 골든=적재 후 기대값.
- **재계산 코드**: ORM 비의존 헬퍼 충실 재구현(component_subtotal `.01` `up*q`·pick_discount_detail min≤qty≤max·apply_discount 정률·round_won ROUND_HALF_UP).
