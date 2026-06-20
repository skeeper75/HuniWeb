# golden-cases-acrylic.md — 아크릴 면적매트릭스 설계 대표 케이스 + 기대 골든값

> **핵심 설계가(hpe-engine-designer) 산출 — 아크릴.** 설계 공식으로 계산되는 대표 케이스와 기대 골든값.
> 검증가(hpe-validator)·codex가 라이브 `evaluate_price`를 실호출/재구현해 **이 골든값을 재현**한다(허용오차 0).
>
> **★순환참조 금지[HARD]**: 골든값은 **가격표 셀(=라이브 단가행 verbatim)** 에서 가져온다. 설계가 만든 값이 아니다.
> 출처 = 라이브 `t_prc_component_prices` 실측(2026-06-20 읽기전용 SELECT·가격표260527 적재본)·단가값 verbatim.
> 권위: 상품마스터260610·가격표260527. 계산 규칙 = engine-contract(`pricing.py` P2~P4·§2~§3 of engine-design-acrylic).

---

## 0. 골든 케이스 도출 원칙 (아크릴)

- **면적매트릭스 본체**(투명/미러/코롯토)는 골든 = 단가행 unit_price 직독 → `subtotal = (unit ÷ min_qty) × qty` (CLEAR3T `.02`·min_qty=1 → ÷1 → 개당×수량 / COROTTO·MIRROR `.01` → unit×qty).
- **고정가형**(카라비너)은 골든 = 형상 opt_cd 단가행 unit × qty.
- **★디지털인쇄와 결정적 차이 — 양면표 불요**: 아크릴 면적단가는 **개당가**(묶음총액 아님)·prc_typ ×qty 폭발 결함 **없음**(§3 engine-design-acrylic). 따라서 "설계 기대값 = 현 라이브 산출값"(결함 없음). 디지털인쇄 골든의 "설계 vs 라이브 결함" 양면표가 아크릴엔 불필요. 단 **G-A1 미바인딩 17상품은 현재 견적 불가(source=NONE)** → "현재 = 견적 불가, 바인딩 후 = 정상" 두 상태만 표기.

---

## 1. 본체 면적매트릭스 골든 (CLEAR3T·.02·min_qty=1·개당가)

### GC-A1. 아크릴키링 가로30×세로30 3T 100개 (PRF_CLR_ACRYL·라이브 바인딩 실재)
| 항목 | 값 | 출처 |
|------|-----|------|
| 상품 | 아크릴키링 PRD_000146 → PRF_CLR_ACRYL | 라이브 바인딩 실재 |
| selections | `{siz_width: 30, siz_height: 30, mat_cd: MAT_000043, qty: 100}` | — |
| comp | COMP_ACRYL_CLEAR3T | 단가행 `siz_width=30·siz_height=30·mat_cd=MAT_000043·min_qty=1·unit=3100` (라이브 SELECT verbatim) |
| prc_typ | `.02 합가형`·min_qty=1 | `component_subtotal`: `3100 ÷ 1 × 100` |
| **기대 골든(개당가)** | **310,000원** (개당 3,100 × 100) | 가격표 B01 verbatim·라이브 재현 |
| ★수량 1개 골든 | **3,100원** (3100 ÷ 1 × 1) | 개당가 직독 |

★ **min_qty 계약 검증 핵심**: CLEAR3T `.02`인데 min_qty=1이라 `per_item = 3100÷1 = 3100`(개당가)·`subtotal = 3100×100 = 310,000`. **디지털 ×qty 폭발(명함 3500→350,000) 같은 결함 없음** — 단가가 개당가이기 때문(묶음총액 아님). 검증가: evaluate_price(아크릴키링, {30,30,MAT_000043,100})=310,000이면 정합.

### GC-A2. 아크릴키링 가로30×세로30 1.5T 1개 (두께=mat_cd 분기)
| comp | COMP_ACRYL_CLEAR3T·siz_width=30·siz_height=30·mat_cd=**MAT_000042**(1.5mm)·min_qty=1 | unit=**2480** |
| **기대 골든** | **2,480원** (=3,100×0.8·1.5T 매트릭스 verbatim) | 가격표 B02 |

→ 검증가: 같은 사이즈 mat_cd만 MAT_000042로 바꾸면 2,480(두께=mat_cd 정확매칭 1행 선택·별 comp 아님·§2-1 검증).

### GC-A3. 비대칭 사이즈 — 가로50×세로30 3T 1개 (★W×H 축 권위 검증·돈크리티컬)
| comp | COMP_ACRYL_CLEAR3T·**siz_width=50·siz_height=30**·MAT_000043·min_qty=1 | unit=**3800** (라이브 SELECT verbatim) |
| **기대 골든** | **3,800원** | 가격표 B01 가로50×세로30 |

★ **축 권위 회귀 케이스**: W=가로(앞)=50·H=세로(뒤)=30. 만약 축이 뒤바뀌면(가로30×세로50) 다른 셀을 룩업해 틀린 단가. 검증가: evaluate_price(키링, {siz_width:50, siz_height:30, MAT_000043, 1})=3,800이면 축 정합. **work사이즈(블리드 가산) 기준이면 50→60·30→40으로 룩업해 더 비싼 단가** → work 미사용 검증(라이브 siz_cd=NULL·WH numeric 확인).

### GC-A4. off-grid ceiling — 가로35×세로35 3T 1개 (엔진 TIER ceiling 검증)
| selections | `{siz_width: 35, siz_height: 35, mat_cd: MAT_000043, qty: 1}` (격자에 35 없음) |
| 엔진 처리 | width 35 → '이하 최소 임계' 없음 → '이상 최소' ceiling = **40**(`pricing.py:158-162`)·height 동일 → 40×40 셀 |
| comp | CLEAR3T·siz_width=40·siz_height=40·MAT_000043 | unit=가격표 40×40 3T 셀 verbatim |
| **기대 골든** | **40×40 3T 셀 단가** (한 단계 큰 격자·ceiling) | [[dbmap-compute-in-app-db-stores-lookup]] |

→ 검증가: 35×35 주문 시 40×40 단가 적용(보간/ceiling 행 단가행에 없음·런타임). 200 초과 시 `ERR_ABOVE_MAX`.

---

## 2. 코롯토 골든 (COROTTO·.01·단가형)

### GC-A5. 아크릴입체코롯토 가로30×세로30 1개 (PRF_COROTTO_ACRYL·바인딩 명세 검증)
| 상품 | 아크릴입체코롯토 PRD_000168 → **PRF_COROTTO_ACRYL**(바인딩 명세·§4-2) |
| selections | `{siz_width: 30, siz_height: 30, qty: 1}` (mat_cd 무관·단일소재) |
| comp | COMP_ACRYL_COROTTO·siz_width=30·siz_height=30 | unit=**3600** (라이브 SELECT verbatim) |
| prc_typ | `.01 단가형` | `subtotal = 3600 × 1` |
| **기대 골든** | **3,600원** | 가격표 B06 verbatim |
| ★현재 라이브 | 바인딩 0 → 견적 불가(source=NONE) | G-A3 입증 |

→ 검증가: 현재 코롯토 견적 시도 시 공식 미바인딩(견적 불가). 바인딩 후 evaluate_price(입체코롯토, {30,30,1})=3,600이면 정합.

---

## 3. 미러 골든 (MIRROR3T·.01·단가행 실재·공식/바인딩 GAP)

### GC-A6. 미러아크릴3T 가로20×세로20 1개 (단가행 verbatim·바인딩 BLOCKED)
| comp | COMP_ACRYL_MIRROR3T·siz_width=20·siz_height=20 | unit=**5000** (라이브 SELECT verbatim·셀 formula `=투명3T×2`) |
| prc_typ | `.01 단가형`·min_qty NULL(÷ 미발생) | `subtotal = 5000 × qty` |
| **기대 골든(공식 신설·바인딩 후)** | **5,000원** | 가격표 B03 verbatim |
| ★현재 라이브 | 공식 0·배선 0·바인딩 0 → 가격사슬 단절 | G-A2 입증 |

★ **바인딩 대상 상품 불명 = BLOCKED(컨펌큐 Q-ACR-MIR1)**: 미러 본체 상품 라이브 0개. 골든값 자체는 단가행 verbatim으로 확정(5,000)이나, **어느 상품에 바인딩할지·소재옵션(투명/미러 택1)으로 PRF_CLR_ACRYL에 합류할지 컨펌 대기**. 합류 시 mat_cd 판별차원 충전 선결(§5-B engine-design·silent 이중합산 가드).

---

## 4. 카라비너 골든 (고정가형·comp/공식 신설 대기)

### GC-A7. 아크릴카라비너 사각자물쇠 1개 (고정가·B07 verbatim·미설계)
| 상품 | 아크릴카라비너 PRD_000166(비활성) → **PRF_CARABINER_ACRYL**(신설 대기) |
| selections | `{opt_cd: <사각자물쇠 형상·채번 대기>, qty: 1}` (면적 아님) |
| comp | COMP_ACRYL_CARABINER(신설)·use_dims=[opt_cd] | unit=**5800** (가격표 B07 사각자물쇠 verbatim) |
| prc_typ | `.01 단가형`·comp_typ=`.06 완제품비` | `subtotal = 5800 × qty` |
| **기대 골든(신설 후)** | **5,800원** | 가격표 B07 |
| 형상별 골든 | 사각자물쇠 5,800·하트A 5,800·하트B 6,300·원형B 6,900 | B07 4형상 verbatim |
| ★현재 라이브 | comp 부재·opt_cd 미채번·PRD 비활성 → 2중 GAP | G-A4 입증 |

★ **형상=opt_cd(면적 아님)**: 사각자물쇠 40×69 등 치수는 명칭설명·가격축 아님(같은 형상 다른 치수 없음). 형상을 siz_width/siz_height로 오모델 금지(benchmark C-A6 가드). 검증가: 신설 후 evaluate_price(카라비너, {opt_cd:하트B, 1})=6,300이면 정합.

---

## 5. 검증가 재현 체크리스트

| 골든 | 검증 명제 | engine-contract |
|------|----------|-----------------|
| GC-A1 | 키링 30×30 3T 100개 = 310,000(개당 3,100×100·×qty 폭발 없음) | min_qty=1 계약(§3·P4) |
| GC-A2 | 1.5T = 2,480(두께=mat_cd 정확매칭 1행·별 comp 아님) | §2-1 mat_cd 직교 |
| GC-A3 | 가로50×세로30 = 3,800(W×H 축 권위·work 미사용) | §2-2 돈크리티컬 |
| GC-A4 | 35×35 → 40×40 ceiling 단가 | TIER_UPPER §2-3 |
| GC-A5 | 입체코롯토 30×30 = 3,600(바인딩 후·현재 견적 불가) | G-A3 바인딩 |
| GC-A6 | 미러 20×20 = 5,000(단가행 verbatim·공식/바인딩 BLOCKED) | G-A2 |
| GC-A7 | 카라비너 형상별 고정가(5,800~6,900·면적 아님) | G-A4·C-A6 |
| 회귀 | G-A1 미바인딩 17상품 현재 견적 불가(source=NONE)→바인딩 후 정상 | §4 바인딩 |

★ **모든 "기대 골든값" 출처 = 라이브 단가행 verbatim(가격표260527)·옳음**(순환참조 0). **아크릴은 디지털인쇄와 달리 prc_typ ×qty 결함·인쇄면 silent 이중합산이 없으므로**(§3·§7 engine-design-acrylic) "설계 기대값 = 정상 산출값". 불일치가 나온다면 진원은 **G-A1 미바인딩(견적 불가)**이지 단가/엔진 결함 아님. 미러/카라비너만 신설 후 재현(컨펌 대기).
