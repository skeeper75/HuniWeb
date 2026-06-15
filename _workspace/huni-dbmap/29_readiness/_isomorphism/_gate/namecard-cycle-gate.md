# 명함 고정가형 2차 사이클 — 독립 검증 게이트 (V1~V6)

> 작성 2026-06-15 · `dbm-validator`(검증 전담·생성자≠검증자) · **적대적 재측정**.
> 생성자 산출 = `namecard-class.md`(Sc) · `namecard-rep-5layer.md`(S0~S5) · `namecard-cycle-report.md` (round-21 2차 사이클, `dbm-readiness-auditor`).
> 1차 권위 = 라이브 read-only SELECT(2026-06-15) + 가격표 엑셀 `docs/huni/후니프린팅_인쇄상품_가격표_260527.xlsx`(명함포토카드 시트).
> 생성자 판정 = NO-GO(NAMECARD-WIRE). 본 게이트 = 그 NO-GO가 **정직한가**(거짓 GO·거짓 NO-GO·날조·카운트 오류) 적대 점검.
> [HARD] 라이브 읽기전용 SELECT만. 모든 판정 = SQL 결과·엑셀 셀 인용. 추측 0.

---

## 0. 결론 (게이트 요약)

| 게이트 | 검증 대상 주장 | 판정 | 한 줄 근거 |
|--------|----------------|:--:|------|
| **V1** | 동형 클래스=3상품(031/032/033만 완비)·034~040 제외 | **REPRODUCED** | 라이브 items 30/8/11 vs 034~040=0·038 use_yn=N·공식 3상품만 PRF_NAMECARD_FIXED |
| **V2** | 대표 031 superset(종이16·박8·items30)·코팅 032 보완 | **REPRODUCED** | 라이브 031 siz3/mat16/proc12/grp5/opt31·items30 = 클래스 최대·031 박8 유일·032만 코팅 |
| **V3** | NAMECARD-WIRE: STD 2 comp만 배선·나머지 미배선 | **REPRODUCED (카운트 미세 정정)** | 라이브 formula_components = STD_S1/S2 단 2개 배선. 미배선 = **23개**(생성자 "22") |
| **V4** | 데이터 L1 정합·값 결함 0 (STD/PREMIUM/COAT/FOIL) | **REPRODUCED** | 라이브 단가행 = 가격표 엑셀 셀 전건 일치(STD 3,500/PREMIUM 4,500/COAT 5,800/FOIL 19,200/SETUP 5,000) |
| **V5** | PRICE_TYPE .03 부재·명함=순수 배선결함(메타 오적재 아님) | **REPRODUCED (강화 정정)** | 라이브 prc_typ = **.01 단일값만**(.02조차 부재)·명함 comp 전부 .01 |
| **V6** | 032 거짓 GO 차단 정당(STD 3,800 오산을 NO-GO로) | **REPRODUCED** | 라이브 032 mat082 STD=3,800·COAT=5,800·COAT미배선 → 3,800 과소 오산 입증·031 16소재 STD 0매칭=전단절 |

### 전체 게이트 = **GO (생성자 NO-GO 판정은 정직함)**

- 생성자의 핵심 결함(NAMECARD-WIRE)·NO-GO 판정·인간 승인 큐(NAMECARD-WIRE/MATGROUP/031-FOIL)는 **라이브·엑셀 1차 권위로 전건 재현**.
- **거짓 GO 없음**: 032가 STD로 떨어진 3,800을 "가격 나옴"으로 위장하지 않고 오산(과소)으로 정직 차단(라이브 확정).
- **거짓 NO-GO 없음**: 033 STD 부분 GO를 정당하게 GO로 인정(STD 배선 실재·값 정합)했고, NO-GO 사유를 가격 배선 1점으로 정확히 좁힘(constraint 0·addon 0을 결함으로 과장하지 않음).
- **날조 없음**: 인용한 단가값·comp·배선 상태 모두 라이브에 실재.
- **카운트 오류 2건(경미·결론 무영향)**: ① 미배선 comp = 라이브 **23개**인데 생성자 본문 일부 "22 comp"(§Q4)·"22개 wired_to=∅"(§2-3). ② PRICE_TYPE 도메인을 생성자는 ".01·.02 2종"이라 했으나 라이브는 **.01 단일**. 둘 다 NO-GO 결론을 강화하는 방향(미배선이 더 많고, 메타축 자체가 단순)이라 판정에 영향 없음.

---

## 1. V1 — 동형 클래스 = 3상품 (REPRODUCED)

라이브 실측(`t_prd_products` × items × `t_prd_product_price_formulas`):

```
PRD_000031 프리미엄명함   Y items=30 PRF_NAMECARD_FIXED
PRD_000032 코팅명함       Y items=8  PRF_NAMECARD_FIXED
PRD_000033 스탠다드명함   Y items=11 PRF_NAMECARD_FIXED
PRD_000034 펄명함         Y items=0  (미바인딩)
PRD_000035 모양명함       Y items=0  (미바인딩)
PRD_000036 미니모양명함   Y items=0  (미바인딩)
PRD_000037 오리지널박명함 Y items=0  (미바인딩)
PRD_000038 형압명함       N items=0  (미바인딩)  ← use_yn=N
PRD_000039 투명명함       Y items=0  (미바인딩)
PRD_000040 화이트인쇄명함 Y items=0  (미바인딩)
```

- 031/032/033만 items>0 + 공식 바인딩 = **클래스 3상품** 정확.
- 034~040 items=0·공식 미바인딩 = 미완비, 038 use_yn=N = 미출시 → §8 제외 정당.
- 035/036/037 별공식(SHAPE/MINISHAPE/FOIL): 라이브에 SHAPE/MINISHAPE comp 단가행 실재(가격표 R43~53 모양/미니모양·R57~69 오리지널박)이나 **공식(PRF_*) 자체는 미바인딩**(items=0). 생성자 "별공식이라 동형도 아님"은 가격표상 산정구조(모양=18,000 고정·박=수량구간)가 다름으로 뒷받침되나, 라이브엔 아직 별 공식이 INSERT돼 있지 않음(comp만 존재) — 생성자 표현 "공식 자체가 SHAPE/MINISHAPE/FOIL"은 **가격표 구조 기준 서술**이며 라이브 공식 부재와 모순 아님(제외 결론 동일).

> V1 = REPRODUCED. 클래스 크기·제외 7상품·use_yn 전건 라이브 일치. 날조·카운트 오류 0.

---

## 2. V2 — 대표 031 superset (REPRODUCED)

라이브 per-product 차원 카운트:

```
PRD_000031 siz=3 mat=16 proc=12 grp=5 opt=31  items=30
PRD_000032 siz=2 mat=2  proc=4  grp=4 opt=9   items=8
PRD_000033 siz=2 mat=5  proc=4  grp=4 opt=11  items=11
```

- 031이 mat(16)·proc(12)·opt(31)·items(30)에서 클래스 최대 = superset 확정.
- 031 proc12 = 모서리2+가변2+박8 (생성자 분해와 일치, §3 차원환원 .04 12개 검증으로 교차확인).
- **코팅 차원 = 032만 보유** 확인: 032 mat=2(아트250/300)·coat 옵션 그룹 실재. 031엔 코팅 없음 → "코팅 보완 대표=032" 정당.
- 1차 엽서(016 superset+017 코팅 보완)와 동형 보정 패턴 = 일반화 오류 회피 패턴이 공식 유형 무관하게 동일 적용 = 입증.

> V2 = REPRODUCED. superset·코팅 보완 라이브 일치. 단 생성자 §2-1 표가 "031 grp 5/opt 31"을 명시했고 라이브 grp=5·opt=31 정확.

---

## 3. V3 — NAMECARD-WIRE 배선 (REPRODUCED · 카운트 미세 정정)

### 3-1. PRF_NAMECARD_FIXED 배선 comp 전체 (라이브 formula_components)

```
COMP_NAMECARD_STD_S1  disp_seq=1 addtn_yn=Y PRICE_TYPE.01
COMP_NAMECARD_STD_S2  disp_seq=2 addtn_yn=Y PRICE_TYPE.01
```

= **단 2 comp(STD_S1/S2)만 배선**. 생성자 "STD_S1/S2 단 2 comp만 배선" 정확 REPRODUCED.

### 3-2. 명함종 comp 미배선 카운트 — **라이브 23개** (생성자 "22" 미세 오류)

라이브 `t_prc_price_components WHERE comp_cd LIKE '%NAMECARD%'` = **25개 distinct**. 그 중 STD_S1/S2 2개 배선 → **미배선 23개**(NOT EXISTS 쿼리 실측 = `unwired_namecard_comp=23`).

| comp군 | 라이브 개수 | 배선 |
|--------|:--:|:--:|
| STD | 2 | ✅ 2 배선 |
| PREMIUM (S1/S2 × MGA/MGB) | 4 | ❌ |
| COAT (S1/S2 × 미세는 단가행 mat분기) | 2 | ❌ |
| FOIL 본체(S1/S2 × STD/HOLO) | 4 | ❌ |
| FOIL_SETUP(S1/S2_STD) | 2 | ❌ |
| PEARL | 2 | ❌ |
| WHITE | 4 | ❌ |
| CLEAR | 1 | ❌ |
| SHAPE | 2 | ❌ |
| MINISHAPE | 2 | ❌ |
| **합** | **25** | 2 배선 · **23 미배선** |

- 생성자 §Q4/§2-3 = "22 comp 미배선" → 라이브 실측은 **23**. (생성자 §2-3 표가 PEARL/WHITE/CLEAR/SHAPE/MINISHAPE를 "현 클래스 외"로 묶어 본체 명함종(PREMIUM4+COAT2+FOIL4+SETUP2=12)만 세었거나, FOIL_SETUP 2개 누락 가능성.)
- **결론 영향 0**: 미배선이 22든 23이든 NAMECARD-WIRE 결함·NO-GO 동일. 실측이 생성자보다 1개 더 미배선 = NO-GO 강화 방향.

> V3 = REPRODUCED. STD 2개만 배선 = 정확. **카운트 정정: 미배선 23개(생성자 22)** — 경미·결론 무영향.

---

## 4. V4 — 데이터 L1 정합 · 값 결함 0 (REPRODUCED)

라이브 `t_prc_component_prices` ↔ 가격표 엑셀 `명함포토카드` 시트 셀 직접 대조:

| 명함종 | 라이브 단가행 | 엑셀 셀(명함포토카드) | 일치 |
|--------|------|------|:--:|
| STD 단면 | STD_S1 mat074=3,500·mat082=3,800 | R4: B4=3,500(백모조220/아트250/스노우250)·C4=3,800(아트300/스노우300) | ✅ |
| STD 양면 | STD_S2 mat074=4,500·mat082=4,800 | R4: D4=4,500·E4=4,800 | ✅ |
| PREMIUM 단면 | PREMIUM_S1_MGA=4,500·MGB=5,000 | R11: B11=4,500(A군)·C11=5,000(B군) | ✅ |
| PREMIUM 양면 | PREMIUM_S2_MGA=5,500·MGB=6,500 | R11: D11=5,500·E11=6,500 | ✅ |
| COAT 단면 | COAT_S1 mat081=5,500·mat082=5,800 | R18: B18=5,500(아트250)·C18=5,800(아트300) | ✅ |
| COAT 양면 | COAT_S2 mat081=6,500·mat082=6,800 | R18: D18=6,500·E18=6,800 | ✅ |
| FOIL 단면 STD | FOIL_S1_STD 200=19,200 … 1000=63,000 | R61~69 B열: 19,200/24,800/30,400/36,000/41,600/47,200/52,800/58,400/63,000 | ✅ 9구간 전건 |
| FOIL 단면 HOLO | FOIL_S1_HOLO 200=24,800 … 1000=92,000 | R61~69 C열: 24,800/33,200/41,600/50,000/54,400/66,800/75,200/83,600/92,000 | ✅ 9구간 전건 |
| FOIL SETUP | FOIL_SETUP_S1/S2=5,000 | R60: 기본가(아연판) B60=5,000·D60=5,000 | ✅ |

- **값 결함 = 0 REPRODUCED**. 고정가형 단가행 = 세트당 최종가 = 가격표 셀과 1:1 일치.
- 생성자가 5layer §1에서 적은 "PREMIUM 4,500/5,000·COAT 5,500/5,800·FOIL 19,200~63,000" 전부 엑셀·라이브 동시 정합.

> V4 = REPRODUCED. 단가행=골든(가격표 셀) 직접 대조 전건 일치. 값 날조 0.

---

## 5. V5 — PRICE_TYPE .03 부재 · 순수 배선결함 (REPRODUCED · 강화 정정)

- 라이브 `SELECT DISTINCT prc_typ_cd FROM t_prc_price_components` = **`PRICE_TYPE.01` 단일값만**.
- 명함 comp 25개 전부 `PRICE_TYPE.01`.
- 생성자 ".03 부재" = 맞음. 단 생성자는 "라이브 PRICE_TYPE = .01(단가형)·.02(합가형) 2종만(.03 부재)"이라 했는데 **라이브엔 .02조차 부재**(.01 단일). → ".03 부재" 결론 옳으나 도메인 서술 부정확(현 라이브 적재 기준 .01만).
- **명함 결함 = 순수 배선 누락(NAMECARD-WIRE)이지 prc_typ 메타 오적재(합산형 D-1b)와 다른 유형** = REPRODUCED. 명함 comp가 .01(단가형)이고 고정가형은 단가행=세트당 총액 직접 룩업이라 .01 정합 = 옳음.

> V5 = REPRODUCED. .03 부재·배선결함 유형 구분 정확. **정정: 라이브 prc_typ는 .01 단일(.02도 부재)** — 생성자 도메인 서술 오류, 결론(메타 정합·배선결함) 무영향이며 오히려 강화.

---

## 6. V6 — 032 거짓 GO 차단 정당 (REPRODUCED)

라이브 032 코팅명함 소재 × 단가행 매칭:

```
MAT_000081 아트지250g  in_STD_S1=f  COAT_S1=5,500
MAT_000082 아트지300g  in_STD_S1=t  STD_S1=3,800  COAT_S1=5,800
```

라이브 031 프리미엄 16소재 × STD_S1 매칭: **prem_mat_total=16 · in_std=0** (전건 STD 단가행 부재).

- **거짓 GO 차단 입증**: 032 mat082는 STD_S1에 3,800이 실재 → COAT 미배선 시 엔진이 STD로 떨어지면 **3,800 반환**. 그러나 코팅 정가는 COAT_S1 mat082=**5,800** → **2,000 과소 오산**. 생성자가 이 3,800을 "가격 나옴(GO)"으로 위장하지 않고 NO-GO(오산)로 정직 차단 = 정당. C3 시뮬 라이브 재현.
- 032 mat081은 STD_S1에 부재(f) → 코팅 무광 아트250 선택 시 룩업 단절(또 다른 NO-GO). 생성자가 "032 STD 오산"으로 묶은 것은 mat082 케이스 기준이며, mat081은 단절이라 더 무거움(생성자 과장 아님·오히려 보수적).
- **031 전 견적 단절 입증**: 16소재 전부 STD 단가행 0매칭 → STD로 떨어져도 도달 불가 = 031 PREMIUM 미배선이 전 견적 단절. 생성자 "031 전 견적 단절" 정확.

> V6 = REPRODUCED. 거짓 GO 위장 없음·NO-GO 정직. 031 전단절·032 과소오산 라이브 확정.

---

## 7. 인간 승인 큐 정직성 점검

| 큐 항목 | 생성자 주장 | 라이브 검증 | 정직? |
|---------|------|------|:--:|
| NAMECARD-WIRE 배선 | STD만 배선·PREMIUM/COAT 미배선·데이터 실재(배선만) | formula_components STD 2개·단가행 PREMIUM/COAT 실재·미배선 23 | ✅ 정직(comp 신설 0·배선만) |
| NAMECARD-MATGROUP | 033 STD 074/082만·081/091/092 키 부재 | has_std_row: 074=t·082=t·081/091/092=f | ✅ 정직(3건 부재 정확) |
| 031-FOIL 배선 | FOIL comp 데이터 실재(9구간)·미배선 | FOIL_S1_STD/HOLO 각 9구간·SETUP 실재·미배선 | ✅ 정직(comp 신설 0·배선만) |

- 인간 승인 큐 3건 모두 "데이터/단가행 실재 → 배선·복제만(신설 0)" = 라이브 실측 정확. 과장(신설 요구)·축소(없는 데이터 가정) 없음.

---

## 8. 적발 사항 종합

### 8-1. 카운트/서술 오류 (경미 · 결론 무영향 · NO-GO 강화 방향)

1. **미배선 comp 카운트**: 생성자 "22 comp 미배선"(§Q4·§2-3) → 라이브 실측 **23개**. (FOIL_SETUP 2개 또는 미출시 명함종 포함 셈 차이.) → NO-GO 강화 방향, 결론 무영향.
2. **PRICE_TYPE 도메인 서술**: 생성자 ".01·.02 2종(.03 부재)" → 라이브 **.01 단일**(.02도 부재). → ".03 부재" 결론 옳고 "배선결함 유형" 정확, 도메인 서술만 부정확.

### 8-2. 날조 / 거짓 GO / 거짓 NO-GO = **0건**

- 인용 단가값·comp·배선상태·use_yn·items·차원카운트 전부 라이브/엑셀에 실재.
- 거짓 GO(없는 가격을 GO로): 없음. 032 3,800 오산을 정직 차단.
- 거짓 NO-GO(되는데 NO-GO): 없음. 033 STD 부분 GO를 정당 인정, NO-GO를 가격 배선 1점으로 정확히 한정.

---

## 9. 고정가형 일반성 입증 여부 (한 줄)

**입증됨** — 동일 Q-게이트가 1차 합산형(PRF_DGP_A)에 이어 2차 고정가형(PRF_NAMECARD_FIXED)에서도, ×수량 안 함·단가행=세트당 골든·배선누락(NAMECARD-WIRE)을 메타 오적재(D-1b)와 구분·032의 STD 강하 3,800을 오산으로 차단함을 라이브·엑셀 1차 권위로 전건 재현했고, 검증 과정에서 발견한 오류는 결론을 바꾸지 않는 카운트/서술 2건뿐이라 고정가형에서 파이프라인이 올바로 작동함이 독립 검증으로 확정됐다.

---

## 10. 게이트 최종 판정

| 항목 | 판정 |
|------|:--:|
| V1 클래스 3상품 | REPRODUCED |
| V2 대표 superset | REPRODUCED |
| V3 NAMECARD-WIRE | REPRODUCED (미배선 23 정정) |
| V4 값 결함 0 | REPRODUCED |
| V5 .03 부재·배선결함 | REPRODUCED (.01 단일 정정) |
| V6 032 거짓 GO 차단 | REPRODUCED |
| **전체 게이트** | **GO — 생성자 NO-GO(NAMECARD-WIRE) 판정은 정직하다** |

> 본 게이트 = 검증 전용. 실 배선/COMMIT/DDL은 인간 승인. 라이브 = 읽기전용 SELECT만 수행(쓰기 0).
