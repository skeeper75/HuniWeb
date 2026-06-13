# 합판도무송스티커 분해 설계 (plywood-domusong-decomposition) — round-16

> **작성** 2026-06-13 · round-16. 입력 = `plywood-domusong-structure.md`(3블록 해부) + 라이브 `t_prc_*`/`t_mat_materials`/`t_siz_sizes` 실측 + round-14 stale 진단 + sticker-material-axis(소재 개별분해 패턴). **분해 기준 = Phase11 `evaluate_price` 매칭 규칙.** **DB 미적재.**

---

## 0. 그릇 (라이브 information_schema 실측 = 권위 · 2026-06-13)

스티커와 동일 — 라이브 `t_prc_price_formulas`에 `frm_typ_cd`·`prd_cd` **부존재**(개념설계 11-CONTEXT의 frm_typ_cd는 라이브에 없음). 그릇 권위 = **라이브 실측**.

```
[공식정의]   t_prc_price_formulas(frm_cd, frm_nm, note, use_yn)          ← frm_typ_cd 없음
[상품바인딩] t_prd_product_price_formulas(prd_cd, frm_cd, apply_bgn_ymd) ← 별 테이블
[배선]       t_prc_formula_components(frm_cd, comp_cd, disp_seq, addtn_yn)
[구성요소]   t_prc_price_components(comp_cd, comp_nm, comp_typ_cd, prc_typ_cd, use_dims, use_yn, note)
[단가행]     t_prc_component_prices(comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd,
                                    coat_side_cnt, bdl_qty, min_qty, unit_price, note, proc_cd, opt_cd)
```

- **PRICE_TYPE 코드(라이브 t_cod_base_codes 실측)**: `PRICE_TYPE.01`=단가형 · `PRICE_TYPE.02`=합가형 (둘 다 use_yn=Y).
- 그릇 엑셀 시트 = `1_price_formulas` + `1b_product_price_formulas`(바인딩) + `2_formula_components` + `3_price_components` + `4_component_prices`.
- **BLOCKED siz 시트 불필요** — 가격표 37 사이즈 전부 라이브 siz 등록(스티커와 달리 미적재 siz 0).

---

## 1. 공식 매핑 (블록 → price_formulas + formula_components)

| 블록 | 상품 | 공식(frm_cd) | 구성요소(comp_cd) | 비고 |
|------|------|-------------|-------------------|------|
| B1~B3 | 합판도무송스티커(PRD_000066) | `PRF_GANGPAN_FIXED`(**기존·라이브**) | `COMP_GANGPAN_PRINT`(종이+인쇄+커팅 통가격) | 3블록이 1공식·1구성요소 공유(형상=siz 차원으로 통합) |

- **3블록 = 단일 공식·단일 구성요소** — 원형/정사각/직사각은 `siz_cd` 차원으로 구분(별 공식 불요). 라이브가 이미 이 구조(37 siz가 1 comp에 통합).
- **공식 신규 없음** — PRF_GANGPAN_FIXED·COMP_GANGPAN_PRINT 모두 라이브 존재(재현·정정만). **재사용 신규 0.**
- 구성요소 1개 = 단순형(합산 아님). T = "종이+인쇄+커팅"이 단일 comp에 통합(스티커 COMP_STK_PRINT 동형·과분할 금지).

---

## 2. 🔴 단가형 / 합가형 판별 (Phase11 핵심 · round-16 정정)

판별 근거 = 셀값 ÷ 수량 = 장당가 거동(라이브 실측 + 가격표 분석).

| 블록 | prc_typ_cd | 근거(원형10mm·비코팅축 실측) | 엔진 계산 |
|------|-----------|------------------------------|----------|
| **B1~B3 전부** | **🔴 .02 합가형** | qty 1000→20000(@20원), 2000→30000(@15원), 3000→40000(@13.3원), 4000→50000(@12.5원), 5000→60000(@12원). **장당가 체감 = 셀값은 수량구간의 총액** | `구간총액 ÷ min_qty = 장당가 × 주문수량` |

### 🔴 라이브 오적재 발견 (횡단 교훈 적중)

```
라이브 COMP_GANGPAN_PRINT.prc_typ_cd = PRICE_TYPE.01 (단가형)  ← 오적재
정답                                  = PRICE_TYPE.02 (합가형)
```

- 횡단 교훈("셀=구간총액이면 prc_typ=.02, 라이브 .01 오적재")에 **정확히 해당**.
- 셀값이 장당가가 아니라 수량구간 총액(1000매 묶음당 20000원)이므로, 엔진이 `unit_price × 주문수량`(단가형)으로 계산하면 1000매 주문 시 20000×1000=2천만원으로 **폭증**. 합가형(.02)이어야 `20000 ÷ 1000 = 20원/매 × 1000 = 20000원` 정확.
- **단, 이 가격표는 수량구간이 명시(1000~5000)이고 각 구간 총액이 직접 주어짐** → `min_qty`에 각 수량, `unit_price=구간총액`, `prc_typ_cd=.02`로 적재. 엔진이 주문수량 이하 최대 min_qty 구간 선택 후 `÷min_qty` 환산.

> **컨펌 Q-GP-1**: 주문수량이 구간 사이(예 1500매)일 때 처리 — 합가형은 1000매 구간(20000)을 선택해 `20000÷1000×1500=30000`? 아니면 가격표가 1000 단위 고정주문 전제? 라이브 동작 확인 필요(다른 합가형 상품 거동 대조).

---

## 3. 🔴 소재 2축 개별 분해 (사용자 피드백 핵심 · 라이브 mat_cd 실측)

가격표 헤더 `비코팅/무광코팅/유광코팅` + `유포/투명데드롱/은데드롱` = **6개 개별 소재**(라이브 `t_mat_materials` 실측):

| 가격표 축 | 컬럼 | 개별 소재 | 라이브 mat_cd | mat_nm | mat_typ_cd | 비고 |
|----------|------|----------|--------------|--------|-----------|------|
| **코팅축** | B/D/F… (홀수) | 비코팅 | `MAT_000084` | 비코팅스티커 | **.01 ❌** | round-13 .11 교정대상(그릇은 정답코드 사용) |
| | | 무광코팅 | `MAT_000155` | 무광코팅스티커 | .11 ✅ | |
| | | 유광코팅 | `MAT_000156` | 유광코팅스티커 | .11 ✅ | |
| **데드롱축** | C/E/G… (짝수) | 유포 | `MAT_000153` | 유포스티커 | .11 ✅ | |
| | | **투명데드롱** | **`MAT_000170`** | **투명데드롱스티커** | .11 ✅ | **[HARD 메모리] 162(투명스티커) 아님** |
| | | 은데드롱 | `MAT_000171` | 은데드롱스티커 | .11 ✅ | |

### 분해 규칙: 한 컬럼 = 3소재 공유단가

```
B4=20000 (원형10/코팅축/1000매)
  → component_prices 3행 (같은 단가 20000):
     (siz=SIZ_000501, mat=MAT_000084, min_qty=1000, unit_price=20000)  비코팅
     (siz=SIZ_000501, mat=MAT_000155, min_qty=1000, unit_price=20000)  무광코팅
     (siz=SIZ_000501, mat=MAT_000156, min_qty=1000, unit_price=20000)  유광코팅
C4=26100 (원형10/데드롱축/1000매)
  → 3행 (같은 단가 26100): MAT_000153(유포)·MAT_000170(투명데드롱)·MAT_000171(은데드롱)
```

- **collapse 금지**: 라이브 2종(084·153)이 아니라 6종 전부 개별 행.
- 코팅축 3소재 = 같은 셀값 공유 / 데드롱축 3소재 = 같은 셀값 공유(가격표 컬럼이 3소재 묶음 단가).
- **proc_cd = NULL**: 코팅이 컬럼 헤더에 묶여 있으나, 여기서는 **자재 variant**(코팅된 점착지)로 분해(sticker M-2 (a)안 확정 동형). 코팅을 공정으로 전환 여부는 스티커 BATCH-3 결정과 연동(컨펌 Q-GP-2).

> **컨펌 Q-GP-2**: 코팅축 = 자재 variant(현 분해·무광/유광=별 mat_cd) vs 공정 전환(비코팅 base + 코팅 proc_cd). 스티커 BATCH-3와 동일 쟁점 — 가격표 컬럼이 비코팅·무광·유광을 **같은 단가**로 묶음(공정이면 코팅이 +0원?) → 자재 variant 해석이 가격표와 정합. 사용자 BATCH-3 최종 결정 따름.

---

## 4. 🔴 형상 = siz_cd 매핑 (G-SK-2 형상=size 흡수 · 전 37종 라이브 실측)

전 사이즈 라이브 등록 — **mint 0·BLOCKED 0**.

### 원형 (11종)
| 가격표 | siz_cd | 가격표 | siz_cd |
|--------|--------|--------|--------|
| 원형10mm | SIZ_000501 | 원형40mm | SIZ_000506 |
| 원형15mm | SIZ_000502 | 원형45mm | SIZ_000507 |
| 원형20mm | SIZ_000503 | 원형50mm | SIZ_000508 |
| 원형25mm | SIZ_000504 | 원형55mm | SIZ_000509 |
| 원형30mm | SIZ_000505 | 원형60mm | SIZ_000510 |
| 원형35mm | **SIZ_000422**(비연속 — 원형35x35) | | |

### 정사각 (12종)
10x10→SIZ_000212, 15x15→213, 20x20→214, 25x25→215, 30x30→216, 35x35→217, 40x40→218, 45x45→219, 50x50→220, 55x55→221, 60x60→222, 90x90→223 (연속).

### 직사각 (14종 — 비연속 siz_cd 주의)
35x25→SIZ_000224, 40x30→226, 42x20→228, 50x20→230, 50x30→232, 55x15→234, 55x20→236, 55x24→238, 55x33→240, 90x40→242, 90x50→244, 90x60→245, 90x70→247, 90x80→249.

> 직사각·원형35는 라이브 siz_cd가 **비연속**(짝수만·422 단독) — 가격표 순서로 기계 증분 금지. 위 명시 매핑 권위(라이브 siz_nm 1:1 대조).

---

## 5. use_dims (구성요소 차원 집합)

| comp_cd | use_dims | 안 쓰는 차원(NULL 와일드카드) |
|---------|----------|------------------------------|
| `COMP_GANGPAN_PRINT` | `["siz_cd","mat_cd","min_qty"]`(라이브 일치) | clr_cd·proc_cd·coat_side_cnt·opt_cd·bdl_qty |

- **clr_cd = NULL**(도수 무관·별색=공정 규칙).
- **proc_cd·opt_cd·coat_side_cnt·bdl_qty = NULL**(이 구성요소 안 씀).
- use_dims는 라이브와 **동일**(소재 분해·합가형 정정으로 바뀌지 않음 — 차원집합은 그대로, 값만 6소재로 늘고 prc_typ만 바뀜).

---

## 6. component_prices long-form 분해 규칙

```
밴드 셀 (수량 q, 사이즈 c, 소재축 m[3소재])
  → 소재축 3소재 각각 component_prices row:
     comp_cd=COMP_GANGPAN_PRINT, siz_cd=<c의 siz_cd>, mat_cd=<3소재 중 하나>,
     clr_cd=NULL, proc_cd=NULL, coat_side_cnt=NULL, opt_cd=NULL, bdl_qty=NULL,
     min_qty=<q>, unit_price=<셀값>, apply_ymd=<적용일>
```

- **동시매칭 0 검증**: 같은 (siz, mat, min_qty)에 단가행 1개만(6소재 분해해도 mat_cd가 달라 충돌 0). 공통 NULL행 없음.
- **무손실**: 원본 셀 370 ↔ 분해행 1110(셀당 3소재). round-trip = 1110÷3 = 370셀 복원.

---

## 7. round-trip 무손실 카운트 (validator P3)

| 단계 | 카운트 |
|------|--------|
| 가격표 데이터셀 | **370** (110+120+140) |
| 6소재 분해 후 component_prices 행 | **1110** (370셀 × 3소재/축) |
| 형상 siz_cd | 37종 (BLOCKED 0) |
| 소재 mat_cd | 6종 (084·155·156·153·170·171) |
| 수량 min_qty | 5구간 (1000~5000) |
| 부유/노트 셀 | 0 |

---

## 8. 미해소 컨펌 (추정 금지)

| ID | 컨펌 | 영향 |
|----|------|------|
| **Q-GP-1** | 합가형 구간 사이 수량(1500매) 처리 — 환산식 vs 고정주문 전제 | prc_typ .02 엔진동작 |
| **Q-GP-2** | 코팅축 = 자재 variant(현) vs 공정 전환(proc_cd) — 스티커 BATCH-3 연동 | 소재 6 vs 4+proc |
| **Q-GP-3** | 라이브 prc_typ .01→.02 정정 시 기존 PRD_000066 가격조회 영향 검증(현재 .01로 계산 중일 수 있음) | 라이브 정정 안전성 |
| Q-GP-4(참고) | 비코팅(084) MAT_TYPE .01→.11 오적재 — 그릇은 정답코드, 교정은 round-13 | 데이터 정합 |

---

## 9. 한 줄 현황

합판도무송 분해 설계 완료 — 공식 **재사용(PRF_GANGPAN_FIXED·신규 0)**·**합가형(.02) 판별**(라이브 .01 오적재 적발)·**소재 2축→6 개별분해**(투명데드롱=170 확인)·형상 siz **37종 전부 매핑**(BLOCKED 0)·use_dims 라이브 일치. round-trip 370셀→1110행. 컨펌 3건(합가형 구간·코팅 차원·정정 안전성). **다음 = import.xlsx 빌드 + mapping-flow mermaid → validator P1~P6.**
