# WIRE 통합 배선 — 라이브 롤백전용 DRY-RUN 결과 (2-pass)

> 실행 2026-06-15 · `dbm-load-builder` · 라이브 `railway` DB(읽기/롤백전용 트랜잭션·실 COMMIT 0).
> `BEGIN … (적용) … ROLLBACK`. 비밀번호 미노출. **돈-크리티컬 6항목 전건 검증.**

---

## ① 1회차 배선 적용 (PASS1)

| step | 문 | 결과 |
|------|-----|------|
| 00 공식 | INSERT t_prc_price_formulas | **2 (NAMECARD) + 1 (SILSA) = 3행** |
| 01 배선 | INSERT t_prc_formula_components | PREMIUM 4(본체)+6(박)+COAT 2+BANNER 1+BULK 1 = **14행** |
| 02 바인딩 | UPDATE t_prd_product_price_formulas | **3행** (031·032·138) |
| 03 복제 | INSERT t_prc_component_prices | 3,500군 4 + 3,800군 2 = **6행** |

배선 14건 상품군별: 명함 12 · 실사 1 · 포토카드 1.

---

## ② 2회차 재실행 멱등 (PASS2) — delta 0

| step | PASS2 결과 |
|------|------|
| 00 공식 | INSERT 0 0 (×2 VALUES) |
| 01 배선 | INSERT 0 0 (×5 블록) |
| 02 바인딩 | UPDATE 0 (×3) |
| 03 복제 | INSERT 0 0 (×2) |

→ **전건 delta 0**. 재실행 안전(R1). ON CONFLICT/WHERE 가드/NOT EXISTS 정상 작동.

---

## ③ 배선 후 가격사슬 완결 검증 (배선 전 단절 → 배선 후 도달)

상품→공식→formula_components→comp→component_prices 단가행 도달:

| 상품 | 공식 | 배선 comp | 단가행 도달 |
|------|------|----------|:--:|
| 031 | PRF_NAMECARD_PREMIUM | 본체 4(MGA/MGB×면) + 박 6 | 각 1~9행 ✅ |
| 032 | PRF_NAMECARD_COAT | COAT S1/S2 | 각 2행(소재별) ✅ |
| 033 | PRF_NAMECARD_FIXED | STD S1/S2 | 각 **5행**(074+082+복제 081/091/092) ✅ |
| 138 | PRF_POSTER_BANNER_NORMAL | BANNER_NORMAL | **3행**(배선 전 미도달) ✅ |
| 024 | PRF_PHOTOCARD_FIXED | SET·CLEAR_SET·**BULK** | 1·1·**50**(배선 전 BULK 단절) ✅ |

→ **배선 전: 031/032 단절·138 인화지만·024 BULK 단절 → 배선 후 전건 단가행 도달.**

---

## ④ 단가행 불변 (unit_price 절대 불변) [HARD]

| 시점 | 기존 단가행 체크섬 | 행수 |
|------|------|:--:|
| 적용 전 (전체) | `3547b5e34b3734f08e7dc141605a5660` | 3,488 |
| 적용 후 (기존행만·max id 5161 이하) | `3547b5e34b3734f08e7dc141605a5660` | 3,488 |

→ **byte-identical.** 기존 행 unit_price 변경 0. MATGROUP 복제 6행은 신규 IDENTITY(id>5161)로만 추가. 돈-크리티컬 보증 충족.

---

## ⑤ 골든 재현 (보정 하드코딩 0·라이브 단가 직접 룩업)

| 케이스 | 입력 | 도달값 | 제안본 기대 | 일치 |
|--------|------|:--:|:--:|:--:|
| 명함 PREMIUM | 031 A군 단면 100매 | **4,500** | 4,500 | ✅ |
| 명함 COAT | 032 아트300(082) 단면 100매 | **5,800** | 5,800 | ✅ |
| 명함 STD 복제 | 033 스노우250(091) 단면 100매 | **3,500** | 3,500 | ✅ |
| 실사 현수막 | 138 BANNER_NORMAL 900x900 | **8,000** | 8,000 | ✅ |
| 포토카드 BULK | 024 대량 100매 | **9,500** | 9,500 | ✅ |

→ 전건 제안본 골든 일치. 보정 하드코딩 0(전부 라이브 단가행 룩업·복제값=원본).

---

## ⑥ ROLLBACK 후 무변경

| 항목 | ROLLBACK 후 |
|------|:--:|
| 신규 공식(PREMIUM/COAT/BANNER_NORMAL) | **0행** |
| PHOTOCARD BULK 배선 | **0행** |

→ 라이브 완전 무변경. 비파괴 보증.

---

## 종합

| 검증 | 결과 |
|------|:--:|
| 1회차 배선 | 공식3·배선14·바인딩3·복제6 |
| 2회차 멱등 delta | **0** |
| 가격사슬 완결 | **5상품 전건 도달**(배선 전 단절분 해소) |
| 단가행 불변 | **byte-identical**(unit_price 변경 0) |
| 골든 재현 | **5/5 일치**(하드코딩 0) |
| ROLLBACK 무변경 | **0** |

**빌드 + DRY-RUN GO.** 단, R1~R6 독립 게이트(`dbm-validator`) 후 + 엔진 동시배포 + 인간 승인 후에만 실 COMMIT(자기승인 금지).
