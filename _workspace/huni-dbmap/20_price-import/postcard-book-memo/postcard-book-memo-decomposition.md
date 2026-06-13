# 엽서북떡메 분해 설계 (postcard-book-memo-decomposition) — round-16

> **작성** 2026-06-13 · round-16. 입력 = `postcard-book-memo-structure.md`(2블록 해부) + 라이브 `t_prc_*` 실측 + round-14 stale 진단. **분해 기준 = Phase11 가격엔진 `evaluate_price` 매칭 규칙.** **DB 미적재.**

---

## 0. 그릇 (라이브 information_schema 실측 = 권위)

```
[공식정의]   t_prc_price_formulas(frm_cd, frm_nm, note, use_yn)          ← frm_typ_cd·prd_cd 없음(실측)
[상품바인딩] t_prd_product_price_formulas(prd_cd, frm_cd, apply_bgn_ymd) ← 별 테이블
[배선]       t_prc_formula_components(frm_cd, comp_cd, disp_seq, addtn_yn)
[구성요소]   t_prc_price_components(comp_cd, comp_nm, comp_typ_cd, prc_typ_cd[단가/합가], use_dims, use_yn)
[단가행]     t_prc_component_prices(comp_cd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, proc_cd, opt_cd, apply_ymd)
                                                                                                          ↑신설   ↑신설(8→10차원)
```

- **그릇 엑셀 시트** = `1_price_formulas_RU` + `1b_product_price_formulas_RU`(바인딩) + `2_formula_components_RU` + `3_price_components_RU` + `4_component_prices_RU`(580행) + `8_FIX_wiring_chain`(단절1) + `9_FIX_binding_chain`(단절2).
- **BLOCKED 사이즈 0** — siz 5종 전부 라이브 실재(스티커 240행 BLOCKED와 대조). 별 BLOCKED 시트 불필요.

---

## 1. 공식 매핑 (블록 → price_formulas + formula_components)

| 블록 | 상품 | 공식(frm_cd) | 구성요소(comp_cd) | 배선 상태 |
|------|------|-------------|-------------------|----------|
| B1 엽서북 | PRD_000094 | `PRF_PCB_FIXED`(기존) | `COMP_PCB_S1_20P`·`S1_30P`·`S2_20P`·`S2_30P` | 🔴 20P 2개만 배선(30P 미배선) |
| B2 떡메 | PRD_000097 | `PRF_TTEOKME_FIXED`(기존) | `COMP_TTEOKME` | ✅ 배선 정상(바인딩 🔴) |

- **엽서북의 면·페이지를 comp_cd로 분리한 이유**: 인쇄(단면 S1/양면 S2)·페이지(20P/30P)는 단가표에서 독립 컬럼축이지만 라이브 component_prices에 `clr/proc/coat_side` 같은 직접 차원이 없어, **4개 구성요소(S1_20P/S1_30P/S2_20P/S2_30P)로 분리**해 표현. 손님이 (단면, 30P) 선택 → 엔진이 `COMP_PCB_S1_30P` 구성요소 선택 → 그 안에서 siz·min_qty 매칭. (라이브 실측 구조 — 재현)
- **떡메는 권당장수를 `bdl_qty` 차원으로** 흡수(단일 comp). 사이즈·권당장수·수량이 모두 component_prices 직접 차원으로 표현 가능해 1 comp.

> **분해 단위 차이(엔진 매칭 규칙 §2)**: 엽서북 인쇄·페이지=comp 분리 vs 떡메 권당장수=bdl_qty 차원. 둘 다 라이브 실측이 권위 — 기계적 통일 금지. 차이의 이유: bdl_qty라는 전용 차원 컬럼이 묶음수 표현에 맞고, 인쇄면/페이지는 맞는 직접 컬럼이 없어 comp로 분리.

---

## 2. 🔴 단가형 / 합가형 판별 (Phase11 핵심)

판별 근거 = 가격표 단위 표기 + 수량-단가 거동 + 라이브 `prc_typ_cd` 실측.

| 블록 | comp | prc_typ_cd(라이브) | 근거 | 엔진 계산 |
|------|------|-------------------|------|----------|
| B1 엽서북 | 4 comp 전건 | **PRICE_TYPE.01 단가형** | 수량↑단가↓(2→11000, 4→9100… 권당 차등), 완제품가(comp_typ_cd.06) | `단가 × 주문수량` |
| B2 떡메 | COMP_TTEOKME | **PRICE_TYPE.01 단가형** | 수량↑단가↓(6→3000, 12→2300), 권당 단가 차등 | `단가 × 주문수량(권)` |

> **가설 반증 결정 근거**: 핸드오프는 떡메를 "합가형 세트"로 봤으나, 라이브 `COMP_TTEOKME.prc_typ_cd=PRICE_TYPE.01`(단가형). 가격표도 "54장 1세트 4000" 식 **구간총액 표기가 아니라** 권당 단가가 수량따라 차등(6권→3000, 600권→850). 즉 "장당가×수량" 단가형이지 "구간총액÷환산" 합가형이 아니다. 스티커 타투(B05 "3장마다 4000"=합가형)와 명확히 다름.

> **권 단위 주의**: 떡메 단가는 "권당" 가격(50장 1권=3000원/권). 주문수량=권 수. `bdl_qty`(권당장수 50/100)는 단가 차원일 뿐, 단가는 이미 권당 총액으로 표기 → 단가형으로 정상.

---

## 3. use_dims (구성요소별 차원 집합 — 라이브 실측)

각 구성요소가 실제 쓰는 component_prices 차원(나머지=NULL 와일드카드):

| comp_cd | use_dims(라이브) | 안 쓰는 차원(NULL) |
|---------|------------------|-------------------|
| `COMP_PCB_S1_20P`·`S1_30P`·`S2_20P`·`S2_30P` | `["siz_cd","min_qty"]` | clr·mat·proc·coat_side·opt·bdl_qty |
| `COMP_TTEOKME` | `["siz_cd","bdl_qty","min_qty"]` | clr·mat·proc·coat_side·opt |

- **인쇄면·페이지는 use_dims에 없음** — comp_cd 자체로 분기(차원이 아니라 구성요소 식별로 흡수). 엔진은 선택값(단면/30P)→comp 선택→그 comp의 use_dims(siz,min_qty)만 매칭.
- **clr_cd=NULL** 전건 — 완제품가(도수 무관·별색 분리 없음).
- **proc_cd·opt_cd=NULL** 전건 — 엽서북떡메 공정/옵션 가격 차원 없음(라이브 0).

---

## 4. component_prices long-form 분해 규칙

```
B1 엽서북 셀 (수량 r, 사이즈 c, 인쇄 s, 페이지 p)
  → comp_cd = COMP_PCB_{S1|S2}_{20P|30P}  (s,p로 결정)
     siz_cd = {c의 규격코드}, min_qty = r, unit_price = 셀값
     clr/mat/proc/coat_side/opt/bdl_qty = NULL

B2 떡메 셀 (수량 r, 사이즈 c, 권당장수 b)
  → comp_cd = COMP_TTEOKME
     siz_cd = {c}, bdl_qty = b(50|100), min_qty = r, unit_price = 셀값
     clr/mat/proc/coat_side/opt = NULL
```

**사이즈 매핑**(라이브 실측):

| 가격표 표기 | siz_cd | siz_nm(라이브) |
|------------|--------|---------------|
| 100*150 | SIZ_000003 | 100x150 |
| 150*100 | SIZ_000124 | 150x100 |
| 135*135 | SIZ_000004 | 135x135 |
| 90x90mm | SIZ_000119 | 90x90 |
| 70x120mm | SIZ_000266 | 70x120 |

- **동시매칭 0 검증(Phase11)**: 같은 (comp,siz,bdl,min) 조합에 단가행 1개만. 빌드 검증 통과(중복 0·충돌 0).
- **무손실**: 원본 셀 580 ↔ long 행 580 round-trip(아래 §6).

---

## 5. 🔴 가격사슬 점검 (단절 2건 발견 — 아크릴과 동형)

단가행 적재만으로는 엔진이 못 찾는다. `price_formulas → formula_components → price_components → component_prices` + 상품바인딩(`product_price_formulas`)이 모두 연결돼야 "엔진 조회 가능".

| 단절 | 내용 | 라이브 실측 | 영향 | 교정 제안(그릇 시트) |
|------|------|------------|------|---------------------|
| **단절1** | 30P 구성요소 미배선 | `PRF_PCB_FIXED`는 `COMP_PCB_S1_20P`(seq1)·`S2_20P`(seq2)만 배선. **`S1_30P`·`S2_30P` 배선 0** | 손님이 30P 선택 시 엔진이 30P 구성요소를 못 찾음. **30P 단가행 234행 적재됐으나 사장(死藏)** | `8_FIX_wiring_chain` +2행(disp_seq 3·4) |
| **단절2** | 떡메 바인딩 누락 | `PRD_000097`(떡메모지)→`PRF_TTEOKME_FIXED` 바인딩 **0행** | 떡메 공식·구성요소·단가행 112행 다 있는데 상품 연결 없어 **엔진 조회 전면 불가** | `9_FIX_binding_chain` +1행 |

- 단절1은 **배선 누락**(아크릴 "단가행 있으나 formula_components 배선 0"과 동형). 단절2는 **바인딩 누락**(상품↔공식 별 테이블이 비어있음).
- 두 단절 모두 **단가행은 정상 적재**(엑셀로 단가는 조회되나 엔진 계산 경로가 끊김). 교정은 INSERT 2종(배선 2행 + 바인딩 1행)으로 닫힘 — DDL 불요·기존 행 무손상.
- **추정 금지**: apply_bgn_ymd=2026-06-01(엽서북 바인딩과 동일·단가행 apply_ymd와 동일)로 제안. 다른 날짜 의도면 컨펌(아래 §7).

---

## 6. 무손실 round-trip 검산

| 블록 | 가격표 데이터셀 | 라이브 component_prices 행 | 그릇 엑셀 행 | 일치 |
|------|----------------|---------------------------|-------------|------|
| B1 엽서북 | 39 수량 × 12열 = **468** | 4 comp × 117 = **468** | 468 | ✅ |
| B2 떡메 | 28 수량 × 4열 = **112** | COMP_TTEOKME **112** | 112 | ✅ |
| **합계** | **580** | **580** | **580** | ✅ |

- 빈 셀·구멍(hole) 0(no-hole 매트릭스). 부유셀/노트 0(보존 대상 없음).
- 단가 round-trip 샘플 검증: 엽서북 S1_20P 100x150 (가격표 11000/9100 = 라이브 min_qty 2/4 일치), 떡메 90x90 50장 (가격표 3000/2300 = 라이브 6/12 일치).

---

## 7. 미해소 컨펌 (추정 금지)

| ID | 컨펌 | 영향 |
|----|------|------|
| **Q-PCB-1** | 단절1 30P 배선 추가 시 disp_seq 3·4·addtn_yn=Y 적정한가(엽서북 20P 패턴 답습) | 8_FIX 적재 |
| **Q-PCB-2** | 단절2 떡메 바인딩 apply_bgn_ymd=2026-06-01 적정한가(엽서북 바인딩·단가행 적용일과 동일 가정) | 9_FIX 적재 |
| Q-PCB-3(참고) | 떡메 "장수/수량"의 주문 단위가 권 수인지 낱장 수인지 — bdl_qty=권당장수로 해석(라이브 일치) 확인 | 떡메 수량 단위 |

---

## 8. 한 줄 현황

엽서북떡메 분해 완료 — **공식 2(엽서북·떡메 기존 재현)·전건 단가형(.01)·use_dims 2종(엽서북 [siz,min] / 떡메 [siz,bdl,min])·BLOCKED 0**. **가격사슬 단절 2건 발견·교정 제안**(30P 배선 +2행·떡메 바인딩 +1행). 무손실 580=580. 컨펌 2건(배선·바인딩 적용일). **다음 = mapping-flow mermaid → validator P1~P6.**
