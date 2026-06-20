# recompute-log.md — 디지털인쇄 골든 재계산 로그 (독립 재실측)

> **hpe-validator 산출 (E6 핵심).** engine-designer의 golden-cases(GC-1~10)를 라이브 `t_prc_*`
> 실측 단가행으로 **pricing.py 순수 헬퍼를 직접 import해 동치 재계산**했다(ORM 부트스트랩 회피).
> 동치 입증: `catalog.pricing`의 `match_component`/`component_subtotal`/`_row_matches`/`_combo_key`를
> 소스에서 그대로 추출 exec → 동일 로직. selections는 설계 golden-cases와 동일.
> 라이브 읽기전용 SELECT만 · DB 쓰기 0 · 실측 2026-06-20 · 단가값 verbatim(날조 0).

---

## 0. 동치성 입증

`pricing.py` line 38~192(상수 + 순수 헬퍼: `match_component` 118~174, `component_subtotal` 177~192)를
소스에서 추출해 exec. ORM 의존 함수(`_evaluate_formula`)는 import하지 않고, 단가행을 psql로 직접 주입해
각 comp를 `match_component → component_subtotal`로 평가하고 disp_seq 합산을 수동 재현.
`_evaluate_formula`(pricing.py:457~474)가 각 comp를 독립 `_match_entry`로 매칭·합산하는 구조와 동일.

**순환참조 가드**: 골든 기대값은 설계 golden-cases가 가격표 verbatim이라 주장한 값(3500·11000·9500·29800).
재계산값은 라이브 단가행(verbatim) × 엔진 환산. 둘을 대조 → 불일치 = 라이브 환산 결함 지목(설계값 아님).

---

## 1. GC-1 / GC-9 — 스탠다드명함 단면 (PRF_NAMECARD_FIXED)

selections `{mat_cd: MAT_000074}`, 공식 = [COMP_NAMECARD_STD_S1(단가형), COMP_NAMECARD_STD_S2(단가형)].

| qty | STD_S1 subtotal | STD_S2 subtotal | FORMULA 합 | 설계 기대(GC-1) |
|-----|-----------------|-----------------|-----------|-----------------|
| 1 | ERR_BELOW_MIN(min_qty=100, 합산제외→0) | ERR_BELOW_MIN→0 | **0원** | — |
| 100 | **350,000** (3500×100) | **450,000** (4500×100) | **800,000원** | 3,500원 |

**갈린 지점**:
- COMP_NAMECARD_STD_S1 `prc_typ=PRICE_TYPE.01(단가형)`·단가행 `mat_cd=MAT_000074·min_qty=100·unit=3500`.
  단가형은 `subtotal = unit × qty`(pricing.py:191-192) → qty=100 시 **3500×100=350,000**.
  가격표 "100매 세트 = 3,500원"이 **×100 과대청구**. → **D-10 확정(돈크리티컬)**.
- STD_S1·S2가 **둘 다 disp_seq로 배선·둘 다 매칭**(print_opt_cd 차원 NULL → 인쇄면 무관 항상 매칭)
  → 단면(350,000) + 양면(450,000) **이중합산 800,000원**. → **신규 결함 V-DGP-1(이중합산)**.
- qty<100이면 `ERR_BELOW_MIN`(min_qty=100 단일 구간)으로 0원. 명함은 **qty=100에서만 비0**.

재현 SQL:
```sql
SELECT comp_cd, mat_cd, min_qty, unit_price FROM t_prc_component_prices
WHERE comp_cd IN ('COMP_NAMECARD_STD_S1','COMP_NAMECARD_STD_S2');
-- STD_S1|MAT_000074|100|3500  STD_S1|MAT_000082|100|3800
-- STD_S2|MAT_000074|100|4500  STD_S2|MAT_000082|100|4800  (전부 prc_typ=PRICE_TYPE.01)
```

## 2. GC-3 — 코팅명함 misfire (D-2a)

코팅명함 PRD_000032 → `PRF_NAMECARD_FIXED` 바인딩(실측 Q5). 그 공식엔 STD comp만 배선.
→ 코팅명함 견적 = STD_S1(350,000) + STD_S2(450,000). **COAT_S1(5500)·COAT_S2(6500) 무시**.
설계 기대(교정 후 PRF_NAMECARD_COAT 신설) = 5,500. → **D-2a misfire 라이브 확정**.

## 3. GC-9 — D-2b ERR_AMBIGUOUS (설계 오진단 적발)

설계 주장: `{mat_cd, qty}` 선택 시 STD_S1·S2 동시매칭 → ERR_AMBIGUOUS.

**재실측 반증**:
```
COMP_NAMECARD_STD_S1 단독, sel={mat_cd:MAT_000074, qty:100}: error=None, row=HIT  (ambiguous 아님)
```
- `ERR_AMBIGUOUS`(pricing.py:136-138)는 **한 comp의 단가행들** 중 `_combo_key`가 2개 이상일 때만 발생.
- STD_S1과 STD_S2는 **서로 다른 comp_cd**라 `match_component` 내부에서 만나지 않음 → 각자 1 combo → 정상 매칭.
- 실제 결과는 ambiguous가 아니라 **둘 다 정상 매칭되어 조용히 합산**(800,000). 견적은 "깨지는" 게 아니라
  "틀린 값으로 성립"한다 — **더 위험**(오류 경고 없이 과청구).

→ **설계 D-2b는 엔진 메커니즘 오해.** 진짜 결함은 ERR_AMBIGUOUS가 아니라 **인쇄면 차원 부재로 인한 S1+S2 이중합산**(V-DGP-1).

## 4. GC-7 / GC-8 — 엽서북 (PRF_PCB_FIXED·명함 동형 결함)

공식 = [COMP_PCB_S1_20P(단가형), COMP_PCB_S2_20P(단가형)], selections `{siz_cd: SIZ_000003}`.

| qty | S1_20P | S2_20P | FORMULA 합 | 설계 기대 |
|-----|--------|--------|-----------|-----------|
| 2 | 22,000 (11000×2) | 23,000 (11500×2) | **45,000원** | 11,000(GC-7) |
| 20 | 104,000 (5200×20) | 108,000 | **212,000원** | 5,200(GC-8) |
| 100 | 450,000 (4500×100) | 450,000 | **900,000원** | — |

**갈린 지점**:
- COMP_PCB_S1_20P `prc_typ=PRICE_TYPE.01`·단가행 `min_qty=2·unit=11000`(=2매 묶음 총액).
  단가형 ×qty → 11000×2=22,000. → **D-10 동형(엽서북도 단가형인데 묶음총액)**.
- S1_20P·S2_20P 둘 다 배선·print_opt_cd 없음 → **단면+양면 이중합산**(V-DGP-1 동형).
- **∴ 설계 §set-product의 "엽서북=고정가 단일·이중계상 0" 판정은 라이브에서 거짓.**
  엽서북은 명함과 똑같이 ① ×qty 과대청구 ② S1+S2 이중합산 두 결함을 가짐. 설계는 이를 누락.

## 5. GC-5 / GC-6 — 포토카드 SET / BULK

| 케이스 | 재계산 | 설계 기대 | 판정 |
|--------|--------|-----------|------|
| SET `{siz:SIZ_000012, bdl_qty:20}` q=1 | **6,000** | 6,000 | ✅ 일치(min_qty=1·÷1·×1) |
| BULK `{}` q=100 | **950,000** (9500×100) | 9,500 | ❌ ×100 과대청구 |

- **SET만 우연히 정합**: min_qty=1 단일이라 단가형 ×1 = 단가행값. q를 1로만 주문하는 한 정확.
  단 q=2 SET 주문 시 6000×2=12,000(세트 2개)이라 의미는 성립(세트=주문단위).
- **BULK는 D-10 동형**: 단가형·min_qty 구간(20~3000)·단가=구간총액(100매=9500) → ×100 폭발.
  설계 GC-6 "9,500원" 거짓. BULK orphan 바인딩 시 대량주문 전부 과청구.
- 부수 설계 오류: 설계는 BULK가 "min_qty=100·unit=9500"이라 단일행처럼 기술했으나 실제 **50행 구간**(20~3000).
- CLEAR_SET=8500(설계 미언급, SET=6000과 별개).

## 6. GC-4 — 오리지널박명함 FOIL + SETUP

현재 PRD_000037 **미바인딩**(공식 없음·Q5). 설계 신설 PRF_NAMECARD_FOIL 가정 재계산:
공식 = [COMP_NAMECARD_FOIL_S1_STD(단가형), COMP_NAMECARD_FOIL_SETUP_S1_STD(단가형)].

| qty | FOIL_S1_STD | SETUP | 합 | 설계 기대(GC-4) |
|-----|-------------|-------|-----|-----------------|
| 300 | **7,440,000** (24800×300) | **1,500,000** (5000×300) | **8,940,000원** | 29,800 |

**갈린 지점 (이중 결함)**:
- FOIL `prc_typ=PRICE_TYPE.01`·`min_qty=300·unit=24800`(=300매 박 총액) → ×300 폭발(D-10 동형).
- **SETUP(동판비)가 더 심각**: `use_dims=[]`(판별차원 0)·단가행 `min_qty=NULL·unit=5000`.
  단가형 ×qty → 5000×300=1,500,000. 동판비는 **수량 무관 1회 정액**이어야 하는데 ×qty로 폭발.
  설계 GC-4는 "SETUP은 정액 5000·항상 1회"라 가정했으나 **엔진은 SETUP도 단가형 ×qty로 환산**.
  → SETUP은 **합가형(min_qty=1) 또는 별도 정액 처리**가 필요. 설계는 이를 인지 못함.
- min_qty=NULL이라 SETUP은 `_tier_order_val`에서 min_qty tier=0... 실제 단가형이라 환산엔 안 쓰임(단가형은 ÷ 없음).
  단 합가형이면 P4-3 ValueError. 현 단가형이라 ValueError는 안 나지만 ×qty 폭발.

---

## 7. 종합 — 갈린 지점 한 줄 정리

| 골든 | 설계 기대 | 라이브 재계산 | 진원 |
|------|-----------|---------------|------|
| GC-1 명함 STD q100 | 3,500 | 350,000(S1) / 800,000(S1+S2) | prc_typ 단가형(묶음총액) + 인쇄면 이중합산 |
| GC-3 코팅명함 | 5,500 | 350,000+(STD misfire) | D-2a 바인딩 misfire(라이브 결함·확정) |
| GC-7 엽서북 q2 | 11,000 | 22,000 / 45,000 | 동형(prc_typ + 이중합산) |
| GC-8 엽서북 q20 | 5,200 | 104,000 / 212,000 | 동형 |
| GC-5 포토카드 SET | 6,000 | 6,000 ✅ | min_qty=1·×1 우연 정합 |
| GC-6 포토카드 BULK | 9,500 | 950,000 | prc_typ 단가형(구간총액) |
| GC-4 박명함 q300 | 29,800 | 8,940,000 | prc_typ ×qty + SETUP ×qty |

**★ 모든 불일치의 진원은 라이브 데이터/구조 결함이지 설계 골든값의 오류가 아니다.** 설계 골든값(3500·11000·
9500·29800)은 가격표 verbatim으로 옳다. 라이브가 그 값을 ① prc_typ 단가형 오적재 ② 인쇄면 차원 부재로
망가뜨린다. **그러나 설계는 이 결함의 범위(전 고정가형 횡단)와 메커니즘(이중합산 vs ambiguous)을 오판**했다.
재현 스크립트: `/tmp/recompute_namecard.py`·`/tmp/recompute_rest.py`(pricing.py 순수 헬퍼 직접 import).
