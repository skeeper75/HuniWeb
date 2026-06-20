# golden-cases.md — 디지털인쇄 설계 대표 케이스 + 기대 골든값

> **핵심 설계가(hpe-engine-designer) 산출 4/4.** 설계 공식으로 계산되는 대표 케이스와 기대 골든값.
> 검증가(hpe-validator)·codex가 라이브 `evaluate_price`를 실호출/재구현해 **이 골든값을 재현**한다(허용오차 0).
>
> **★순환참조 금지[HARD]**: 골든값은 **가격표 셀(=라이브 단가행 verbatim)** 에서 가져온다. 설계가 만든 값이 아니다.
> 출처 = 라이브 `t_prc_component_prices` 실측(2026-06-20·가격표260527 적재본)·단가값 verbatim.
> 권위: 상품마스터260610·가격표260527. 계산 규칙 = engine-contract(P2~P4).

---

## 0. 골든 케이스 도출 원칙

- **단일 comp 고정가형**(명함·포토카드·엽서북)은 골든=단가행 unit_price 직독(단가형 ×qty·합가형 ÷min_qty×qty).
- **원자합산형**(엽서)은 Σ comp subtotal — 다비목이라 검증가가 라이브 실호출로 재현(여기선 단일 비목 골든 제시).
- 출처 셀을 명시(comp_cd·차원값·unit_price). 검증가가 같은 selections로 evaluate_price 호출 시 동일값 기대.

> ## ★ [보정 R-1 + 골든 양면표기 — 2026-06-20]
> E6 FAIL의 핵심은 "골든 테이블이 라이브의 ×qty 현실을 미반영"한 것. 따라서 **각 고정가형 골든을 양면 표기**한다:
> - **설계 기대값** = 가격표260527 verbatim(=옳은 값·설계가 만든 값 아님·순환참조 0).
> - **현 라이브 산출값** = 라이브 단가행(verbatim) × 현 엔진(단가형 ×qty)으로 검증가가 실측한 값(결함).
> - **진원** = 라이브 prc_typ 단가형 오적재(묶음/구간총액에 ×qty) + 인쇄면 차원 부재(S1+S2 silent 이중합산). **설계 골든값 오류 아님.**
>
> ★ **R-1 범위(전 고정가형 횡단)**: 명함 전 variant + 엽서북(PCB) + 포토카드 BULK + 박(FOIL/SETUP). 전부 동형 ×qty 결함.
> ★ **교정방향(합가형÷min_qty=X / qty정규화=Y)은 dbm-price-arbiter 심의 + 사용자 컨펌 대기** — 골든 "설계 기대값"은 교정 후 정합 목표값이며, 교정방향이 확정돼야 검증가가 재현 가능.

### 0.1 고정가형 골든 양면표 (전 고정가형 횡단·R-1)

| 골든 | selections | comp(출처) | 설계 기대값(verbatim·교정후 목표) | 현 라이브 산출(×qty·결함) | 배수 | 진원 |
|------|-----------|-----------|-----------------------------------|----------------------------|------|------|
| GC-1 스탠다드명함 단면 | mat=MAT_000074·단면·q100 | STD_S1(min100·u3500) | **3,500** | 350,000(S1) / **800,000**(S1+S2 이중합산) | ×100 | prc_typ ×qty + 인쇄면 이중합산 |
| GC-2 스탠다드명함 양면 | mat=MAT_000074·양면·q100 | STD_S2(u4500) | **4,500** | 450,000 / 800,000(이중합산) | ×100 | 동형 |
| GC-3 코팅명함(교정후 PRF_COAT) | mat=MAT_000081·단면·q100 | COAT_S1(u5500) | **5,500** | 350,000+(STD misfire·D-2a) | — | D-2a 바인딩 misfire + prc_typ |
| GC-4 오리지널박명함 | 단면·q300 | FOIL_S1_STD(min300·u24800)+SETUP(u5000) | **29,800**(박24,800+동판5,000) | **8,940,000**(FOIL 7.44M+SETUP 1.5M) | ×300 | prc_typ ×qty + SETUP use_dims=[] ×qty(D-11) |
| GC-6 포토카드 BULK | q100(bdl 없음) | BULK(min100·u9500·50행구간) | **9,500** | **950,000** | ×100 | prc_typ ×qty(구간총액) |
| GC-7 엽서북 단면 20p | siz=SIZ_000003·단면·q2 | PCB_S1_20P(min2·u11000) | **11,000** | 22,000(S1) / **45,000**(S1+S2 이중합산) | ×2 | prc_typ ×qty + 인쇄면 이중합산 |
| GC-8 엽서북 단면 20p q20 | siz=SIZ_000003·단면·q20 | PCB_S1_20P(min20·u5200) | **5,200** | 104,000 / 212,000(이중합산) | ×20 | 동형 |
| GC-5 포토카드 SET | siz=SIZ_000012·bdl20·q1 | SET(min1·u6000) | **6,000** | **6,000** ✅(min1·×1 우연 정합·q≥2 시 깨짐) | ×1 | (정합·단 SET 주문단위 가정에서만) |

★ 진원은 전부 라이브 데이터/구조 결함이지 설계 골든값(verbatim)의 오류가 아니다. SET만 q=1 주문에 한해 우연 정합.

---

## 1. 명함 고정가형 골든 (단가형·×qty)

### GC-1. 스탠다드명함 단면 (PRF_NAMECARD_FIXED·교정 후)
| 항목 | 값 | 출처 |
|------|-----|------|
| 상품 | 스탠다드명함 PRD_000033 | — |
| selections | `{mat_cd: MAT_000074, print_opt_cd: 단면, qty: 100}` | — |
| comp | COMP_NAMECARD_STD_S1 | 단가행 `mat_cd=MAT_000074·min_qty=100·unit=3500` |
| prc_typ | 단가형(PRICE_TYPE.01) | — |
| **설계 기대값**(verbatim·교정후) | **3,500원** (100매 1세트) | 가격표 verbatim |
| **현 라이브 산출**(결함) | 350,000(S1) / **800,000**(S1+S2 silent 이중합산) | 라이브 재계산 recompute §1 |

★★ **확정 결함(범위·메커니즘 양면·실측 2026-06-20)**:
- **D-10 prc_typ ×qty**: COMP_NAMECARD_STD_S1 `prc_typ=PRICE_TYPE.01`(단가형)·`min_qty=100 단일·unit=3500`. 단가형 `subtotal=unit×qty`(component_subtotal:191) → **qty=100 시 3500×100=350,000 과대청구**. 명함 3500은 "100매 1세트 총액". 교정후보 X=합가형(÷100=35원/장×100=3,500) / Y=qty 묶음정규화 — **교정방향 컨펌 대기**(dbm-price-arbiter·CV-1/CV-2).
- **V-DGP-1 인쇄면 silent 이중합산**: STD_S1·STD_S2 둘 다 배선·단가행 print_opt_cd=NULL → 인쇄면 무관 둘 다 매칭 → 단면(350,000)+양면(450,000)=**800,000 silent 합산**(경고 없음·ERR_AMBIGUOUS 아님). 교정=print_opt_cd 컬럼 충전+use_dims 등재(D-3).
- **검증가 재현**: evaluate_price(스탠다드명함, {mat_cd:MAT_000074, print_opt_cd:단면, qty:100})가 교정후 3,500이면 정합. 현 라이브는 350,000/800,000(결함 입증). 교정방향 확정 전까지 재현 목표값은 "설계 기대값(verbatim)".

### GC-2. 스탠다드명함 양면
| comp | COMP_NAMECARD_STD_S2·MAT_000074·100 | unit=**4500** |
| 기대 골든 | **4,500원** | verbatim |

### GC-3. 코팅명함 단면 (D-2a misfire 검증용·교정 후)
| 상품 | 코팅명함 PRD_000032 → **PRF_NAMECARD_COAT**(신설) |
| comp | COMP_NAMECARD_COAT_S1·MAT_000081·100 | unit=**5500** |
| **기대 골든(교정 후)** | **5,500원** | verbatim |
| ★현재 라이브(결함) | PRF_NAMECARD_FIXED 바인딩 → STD 3500 misfire | D-2a 입증 |

→ **검증가 핵심**: 현재 코팅명함 견적=3500(STD misfire)이면 D-2a 결함 실재 입증. 교정 후=5500이 정답.

### GC-4. 오리지널박명함 단면·일반박 (G-1/G-2 박 배선 검증용)
| 상품 | 오리지널박명함 PRD_000037 → **PRF_NAMECARD_FOIL**(신설) |
| comp | COMP_NAMECARD_FOIL_S1_STD·min_qty=300 | unit=**24800** + SETUP(동판비 5000) |
| **설계 기대값**(verbatim·교정후) | **29,800원** (박 24,800 + 동판 5,000·1회) | FOIL verbatim + SETUP verbatim |
| **현 라이브 산출**(결함) | **8,940,000원** (FOIL 24800×300=7.44M + SETUP 5000×300=1.5M) | 라이브 재계산 recompute §6 |

★ **이중 결함(D-10 + D-11)**:
- FOIL `prc_typ=PRICE_TYPE.01`·min_qty=300·unit=24800(=300매 박 총액) → ×300 폭발(D-10 동형·교정방향 컨펌 대기).
- **SETUP(동판비) 별 결함 D-11**: `use_dims=[]`(판별차원 0·라이브 재확인)·`min_qty=NULL·unit=5000`·단가형 → ×qty로 5000×300=1,500,000 폭발. 동판비는 **수량 무관 1회 정액**이어야 함. 현 엔진은 정액 모드 부재(단가형/합가형 모두 ×qty) → **정액 처리법 컨펌 대기**(CV-4·dbm-price-arbiter). 이전 설계가 "SETUP=정액 5000·항상 1회"라 가정한 것은 엔진 계약과 불일치(정정).

---

## 2. 포토카드 골든 (세트 vs 대량)

### GC-5. 포토카드 세트 (bdl_qty 판별)
| 상품 | 포토카드 PRD → PRF_PHOTOCARD_FIXED |
| selections | `{siz_cd: SIZ_000012, bdl_qty: 20, qty: 1}` |
| comp | COMP_PHOTOCARD_SET | 단가행 `siz=SIZ_000012·bdl=20·min_qty=1·unit=6000` |
| 기대 골든 | **6,000원**(세트단가·합가형 ÷1×1) | verbatim |

### GC-6. 포토카드 대량 100매 (BULK orphan 바인딩 검증)
| comp | COMP_PHOTOCARD_BULK·min_qty=100 | unit=**9500**(50행 구간·구간총액) |
| selections | `{qty: 100}`(bdl_qty 없음) |
| **설계 기대값**(verbatim·교정후) | **9,500원** | verbatim |
| **현 라이브 산출**(결함) | **950,000원**(9500×100) | 라이브 재계산 recompute §5 |
| ★현재 | BULK orphan(미바인딩) → 견적 시 BULK 매칭 안 됨 | D-6 입증 |

★ **R-1 범위 포함**: BULK도 prc_typ 단가형·단가=구간총액 → 바인딩하면 ×qty 폭발(D-10 동형). 부수: 이전 설계가 "BULK=min_qty=100·unit=9500 단일행"이라 기술했으나 실제 **50행 구간(20~3000)**(recompute §5 정정).
→ **검증가**: BULK 바인딩 전엔 대량 견적 누락. bdl_qty 유무로 SET/BULK 동시매칭 안 되는지 확인. prc_typ 교정방향 컨펌 대기.

---

## 3. 엽서북 골든 (고정가·세트조합 아님·D-5)

### GC-7. 엽서북 단면 20p
| 상품 | 엽서북 PRD_000094 → PRF_PCB_FIXED(유지) |
| selections | `{siz_cd: SIZ_000003, print_opt_cd: 단면, qty: 2}` |
| comp | COMP_PCB_S1_20P·siz=SIZ_000003·min_qty=2 | unit=**11000** |
| **설계 기대값**(verbatim·교정후) | **11,000원**(완제품 통합단가·내지+표지 합산 아님) | verbatim |
| **현 라이브 산출**(결함) | 22,000(S1) / **45,000**(S1+S2 silent 이중합산) | 라이브 재계산 recompute §4 |

★ **[R-3] 두 종류 이중계상 분리 검증**:
- **BOM 이중계상 = 0** ✅ — 내지(몽블랑240)+표지(스노우300) 별 합산 안 함(완제품 통합단가). 별 합산 시 오류 가드 유효(D-5·codex 합의).
- **가격엔진 축 결함 ≠ 0** ❌ — S1_20P+S2_20P silent 이중합산(45,000) + prc_typ 단가형 ×qty(22,000). 명함과 동일 결함군(R-3 정정·이전 "이중계상 0" 철회). 교정방향 컨펌 대기.

### GC-8. 엽서북 단면 20p 수량 20 (구간단가 하향)
| comp | COMP_PCB_S1_20P·SIZ_000003·min_qty=20 | unit=**5200** |
| **설계 기대값**(verbatim·교정후) | **5,200원**(볼륨디스카운트·min_qty 구간 P3 '이상' 하한) | verbatim |
| **현 라이브 산출**(결함) | 104,000(S1) / **212,000**(S1+S2 이중합산) | 라이브 재계산 recompute §4 |

→ 검증가: qty=20 → min_qty=20 구간 선택(P3 min_qty='이상' 최대임계). 2매 구간(11000) 아님. 단 prc_typ ×qty + 인쇄면 이중합산으로 현 라이브는 212,000(결함·D-10/V-DGP-1 동형).

---

## 4. 인쇄면 silent 이중합산 회귀 케이스 (D-2b·V-DGP-1 검증·R-2 정정)

> **[보정 R-2 — 2026-06-20]** 이전 제목 "ERR_AMBIGUOUS 회귀 케이스" 폐기. STD_S1·STD_S2는 서로 다른 comp_cd라 `match_component` 내부에서 만나지 않으므로 ERR_AMBIGUOUS(한 comp의 단가행들 사이에서만 발생·pricing.py:136-138)는 **일어나지 않는다**. 실제는 두 comp가 둘 다 매칭되어 disp_seq 순으로 **silent 합산**(경고 없이 과청구).

### GC-9. 스탠다드명함 인쇄면 silent 이중합산 재현 (현재 라이브 결함)
| selections | `{mat_cd: MAT_000074, qty: 100}` (인쇄면 미지정·또는 단면 선택) |
| 현재 라이브 | STD_S1(print_opt_cd=NULL)·STD_S2(NULL) 둘 다 와일드카드 통과 → `_evaluate_formula`가 둘 다 합산 → 단면 350,000 + 양면 450,000 = **800,000원**(경고 없음·ERR_AMBIGUOUS 아님) | recompute §3 |
| **기대(교정 후)** | print_opt_cd 컬럼 충전 + use_dims 등재 → 인쇄면 선택 시 1개만 매칭(단면=3,500·양면=4,500·prc_typ 교정 후) | D-3 해소 |

→ **검증가 핵심**: 현재 evaluate_price(스탠다드명함, {mat_cd, 단면, qty})가 800,000(둘 다 합산)이면 V-DGP-1 결함 실재. ERR_AMBIGUOUS 경고는 **뜨지 않는다**(별 comp). 교정 후 print_opt_cd로 1개만 매칭. ★ D-2 use_dims 가설(라이브 검증): 매칭은 행 컬럼(NON_QTY_DIMS) 기준이라 컬럼 충전만으로 매칭은 되나, use_dims 미등재 시 "항상 매칭" 오경고 + 옵션 주입 미연결 시 0원 침묵 → **컬럼 충전 + use_dims 등재 둘 다 필요**(design-decisions D-3 ★).

---

## 5. 원자합산형 골든 (검증가 라이브 실호출 권장)

### GC-10. 엽서(코팅엽서 PRD_000017) 합산 — 다비목
원자합산형은 인쇄비+별색+용지+코팅+후가공 Σ로, 단일 골든값 제시보다 **검증가가 라이브 evaluate_price 실호출**로 재현하는 게 정확(huni-price-quote/§9 엽서 경로·17 comp). 여기선 단일 비목 골든만:
- 무광코팅 1비목: COMP_COAT_MATTE 단가행(siz_cd·coat_side_cnt·min_qty) verbatim.
- ★유광코팅(COMP_COAT_GLOSSY)은 **단가행 결손 의심**(V-4) → 선택 시 0원 침묵. 검증가 점검(가격표 코팅 유광 단가 대조).

---

## 6. 검증가 재현 체크리스트

| 골든 | 검증 명제 | engine-contract |
|------|----------|-----------------|
| GC-1~3 | 명함 variant 전용 PRF 단가 정확(misfire 0) | P2-1 배선 |
| GC-3 | 코팅명함 5500(STD 3500 아님) | D-2a |
| GC-4 | 박 = FOIL + SETUP·설계기대 29,800 vs 라이브 8,940,000(×qty+SETUP use_dims=[]) | D-10·D-11 |
| GC-5/6 | SET 6,000(q1 정합)·BULK 설계 9,500 vs 라이브 950,000(×qty) | D-10·D-6 |
| GC-7/8 | 엽서북 BOM 이중계상 0 ✅ but 가격축 silent 이중합산+×qty(설계 11,000/5,200 vs 라이브 45,000/212,000) | R-3·V-DGP-1·D-10 |
| GC-9 | 인쇄면 silent 이중합산 재현(800,000·ERR_AMBIGUOUS 아님)→교정 후 해소 | R-2·V-DGP-1·D-3 |
| GC-10 | 유광코팅 단가행 결손(0원 침묵) | V-4·P3-DEF |

★ **모든 "설계 기대값" 출처 = 라이브 단가행 verbatim(가격표260527)·옳음**(순환참조 0). "현 라이브 산출값"은 라이브 단가행(verbatim) × 현 엔진(단가형 ×qty + 인쇄면 차원 부재)으로 검증가가 실측한 결함값. **불일치 진원은 전부 라이브 prc_typ 오적재 + 인쇄면 차원 부재이지 설계 골든값 오류 아님**(E6 진원 분석 일치).
★ **R-1 범위(전 고정가형) + 교정방향 컨펌 대기**: 고정가형 단가 의미(묶음/구간총액 vs 장당가) 확정 → 교정방향(합가형÷min_qty=X / qty정규화=Y) → dbm-price-arbiter 심의 + 사용자 컨펌. 확정 전까지 검증가 재현 목표값 = "설계 기대값(verbatim)". 박 SETUP 정액 처리(D-11)도 컨펌 대기.
