# 스티커 분해 설계 (sticker-decomposition) — round-16 파일럿

> **작성** 2026-06-13 · round-16. 입력 = `sticker-structure.md`(7블록 해부) + Phase11 그릇(`11-CONTEXT.md`) + round-14 stale 진단. **분해 기준 = Phase11 가격엔진 `evaluate_price` 매칭 규칙**(보기 좋게 ✗ → 엔진이 먹는 형태 ⭕). **DB 미적재.**

---

## 0. 그릇 (라이브 information_schema 실측 = 권위 · 보정 2026-06-13)

> **[보정 — P1/P5 NO-GO 후]** 초판은 Phase11 `11-CONTEXT.md` 개념모델(`frm_typ_cd` 등)을 그릇으로 옮겼으나, **라이브 실측 결과 `t_prc_price_formulas`에 `frm_typ_cd`·`prd_cd`·`apply_bgn_ymd` 컬럼이 없음.** 그릇 권위 = **라이브 information_schema**(개념설계 아님). 교훈: round-16 스킬의 "라이브 실측 선행" HARD를 인라인에서 건너뛴 결함 → round-13/14 "라이브 권위"와 동일.

```
[공식정의]   t_prc_price_formulas(frm_cd, frm_nm, note, use_yn)          ← frm_typ_cd 없음!
[상품바인딩] t_prd_product_price_formulas(prd_cd, frm_cd, apply_bgn_ymd) ← 별 테이블(공식정의와 분리)
[배선]       t_prc_formula_components(frm_cd, comp_cd, disp_seq, addtn_yn)
[구성요소]   t_prc_price_components(comp_cd, comp_nm, prc_typ_cd[단가/합가], use_dims, use_yn)
[단가행]     t_prc_component_prices(comp_cd, siz_cd, clr_cd, mat_cd, proc_cd, coat_side_cnt, opt_cd, bdl_qty, min_qty, apply_ymd, unit_price)
                                                          ↑신설        ↑신설(8→10차원 자연키)
```

- **단가형/합가형은 `price_components.prc_typ_cd`로만 표현** — 공식정의(`price_formulas`)엔 유형 컬럼 없음. "공식유형 2종"(Phase11 논의)은 prc_typ_cd + 구성요소 수로 발현.
- **그릇 엑셀 시트** = `1_price_formulas`(공식정의) + `1b_product_price_formulas`(바인딩) + `2_formula_components` + `3_price_components` + `4_component_prices`(siz 있는 476행) + `4b_component_prices_BLOCKED`(siz 미적재 240행·round-2 BLOCKED 존중).
- **BLOCKED 240행**: B01 `100*148`·`90*110`(216) + B02/B03 `B4`·`B3`(24) = 라이브 siz 미적재(round-2 `[HARD] search-before-mint·신규 siz mint 금지`). NULL 강제 금지 → 별 시트 분리·siz 선적재 대기.

---

## 1. 공식 매핑 (블록 → price_formulas + formula_components)

| 블록 | 상품 | 공식(frm_cd) | frm_typ | 구성요소(comp_cd) | 비고 |
|------|------|-------------|---------|-------------------|------|
| B01~B04 | 반칼/낱장/대형 변형 | `PRF_STK_FIXED`(기존) | .02 단순형 | `COMP_STK_PRINT`(종이+인쇄+커팅) | round-5 적재·재현 |
| B05 타투 | PRD_000067 | `PRF_STK_TATTOO`(신규) | .02 단순형 | `COMP_STK_TATTOO`(세트단가) | round-2 BLOCKED 해소 |
| B06 스티커팩 | PRD_000065 | `PRF_STK_PACK`(신규) | .02 단순형 | `COMP_STK_PACK`(세트단가·기존2행) | 배선+바인딩 |

- **T3 "종이+인쇄+커팅"** = COMP_STK_PRINT가 담는 합성 단가(단일 구성요소에 3요소 통합 = round-5 단순형 .02 패턴). 합산형으로 쪼개려면 종이/인쇄/커팅 3 comp 분리 필요하나, **라이브는 단일 comp** → 재현(과분할 금지).

---

## 2. 🔴 단가형 / 합가형 판별 (Phase11 핵심 — round-2 미보유)

판별 근거 = 가격표 단위 표기 + 수량-단가 거동.

| 블록 | prc_typ_cd | 근거 | 엔진 계산 |
|------|-----------|------|----------|
| **B01** 반칼 | **.01 단가형** | A열 수량↑ → 단가 소폭↓(1→6000, 3→5900)·장당 단가 거동 | `단가 × 주문수량` |
| **B02** 낱장 | **.01 단가형** | 1→4000, 100→3600(장당가 구간차등) | `단가 × 주문수량` |
| **B03** 투명 | **.01 단가형** | 동형 | `단가 × 주문수량` |
| **B04** 대형 | **.01 단가형** | 동형 | `단가 × 주문수량` |
| **B05** 타투 | **🔴 .02 합가형** | C79 명시 `"3장마다 4000원이라는 의미"` = 3장 **구간총액** | `4000 ÷ 3 = 1333/장 × 주문수량` |
| **B06** 스티커팩 | **🔴 .02 합가형** | A86 `"54장 1세트"` + 1~1000 모두 4000 = 세트 총액 | `4000 ÷ 54 = 74/장 × 주문수량` (또는 세트수 기준) |

> **이것이 round-16의 결정적 가치.** round-2는 B05/B06을 "매트릭스 아님"으로 BLOCKED 했으나, Phase11 합가형(구간총액÷min_qty 환산)은 정확히 이 세트/번들 단가를 위한 그릇이다. B05 타투 = `min_qty=3, unit_price=4000, prc_typ_cd=.02` → 엔진이 자동 환산.

> ⚠️ **컨펌 Q-STK-1**: B05 타투 "기본가 2000"(A80)의 의미 — 3장 미만 최소가? 별도 base 구성요소? "3장 4000"과의 관계(3장=4000인데 기본가 2000은 1~2장?). 합가형 환산만으로 표현 가능한지 확인 필요.

---

## 3. 🔴 코팅 차원 결정 (BATCH-3 — round-15 Wave-0 확정 적용)

B01 소재그룹 3종을 어느 차원으로:

| 소재그룹 | 의미 | 차원 결정 | 근거 |
|----------|------|----------|------|
| 유포/비코팅/미색 | 비코팅 점착지 | `mat_cd`(점착지 소재) | round-15 Wave-0: 출력소재=자재 |
| 무광코팅/유광코팅 | 코팅 | 🔴 **mat_cd(현행) vs proc_cd(신설)** | BATCH-3 |
| 투명/홀로그램 | 투명 점착지 | `mat_cd`(점착지 소재) | 출력소재=자재 |

**BATCH-3 round-15 Wave-0 확정**: "스티커 출력소재(점착지)=자재 유지 / 입히는 코팅=공정". 두 해석:
- **(현행·라이브)** round-5가 무광/유광코팅을 `mat_cd`(MAT_000155 등 코팅된 점착지)로 적재 — "코팅된 완제 점착지" 해석.
- **(Phase11 신설)** `proc_cd` 차원으로 코팅을 공정 분리 — "출력 후 입히는 코팅 공정" 해석. 비코팅 6000 + 코팅공정 +1000 = 7000 합산.

→ **round-16 권고**: 라이브 현행(mat_cd) **보존**하되, Phase11 proc_cd 차원이 열렸으므로 그릇 엑셀에 `proc_cd` 컬럼을 두고 **현재는 NULL**(비활성)로 둔다. 코팅을 공정으로 전환할지는 **컨펌 Q-STK-2**(BATCH-3 최종 결정·가격모델 영향). 전환 시 코팅 단가행(+1000)을 별 proc_cd 행으로 분리.

> Wave-0 확정 "코팅=공정"을 문자 그대로 적용하면 mat_cd 3그룹→2그룹(비코팅·투명) + 코팅 proc_cd 차원이나, 라이브 가격모델(3컬럼 통단가)과 충돌(BATCH-3 핵심 쟁점). 기계적 전환 금지 — 컨펌 후.

---

## 4. use_dims (구성요소별 차원 집합)

각 구성요소가 실제 쓰는 component_prices 차원(나머지=NULL 와일드카드):

| comp_cd | use_dims | 안 쓰는 차원(NULL) |
|---------|----------|-------------------|
| `COMP_STK_PRINT` | `["siz_cd","mat_cd","min_qty"]`(+코팅 전환 시 `proc_cd`) | clr_cd·coat_side_cnt·opt_cd·bdl_qty |
| `COMP_STK_TATTOO` | `["siz_cd","min_qty","bdl_qty"]` | mat_cd·proc_cd·clr_cd·coat_side_cnt·opt_cd·clr_cd |
| `COMP_STK_PACK` | `["siz_cd","bdl_qty"]` | min_qty·mat_cd·proc_cd 등 |

- **clr_cd = NULL**(스티커 가격행은 도수 무관·별색=공정, [[dbmap-digitalprint-atomic-formula-unbuilt]] 규칙).
- **siz_cd = 임포지션 규격**(124x186 등 판걸이 키), 상품 표시사이즈와 다름(round-2 §2.1 보존·면적-좌표 오모델 금지).
- **opt_cd·coat_side_cnt = NULL**(스티커 옵션·코팅면수 축 없음).

---

## 5. component_prices long-form 분해 규칙

```
B01 매트릭스 셀 (수량 r, 사이즈 c, 소재그룹 m)
  → component_prices row:
     comp_cd=COMP_STK_PRINT, siz_cd=<사이즈 c의 규격코드>, mat_cd=<소재그룹 m 대표코드>,
     proc_cd=NULL, coat_side_cnt=NULL, opt_cd=NULL, clr_cd=NULL, bdl_qty=NULL,
     min_qty=<수량 r>, unit_price=<셀값>, apply_ymd=<적용일>
```

- **동시매칭 0 검증**(Phase11): 같은 (siz,mat,min_qty)에 단가행 1개만. 공통 NULL행 + 전용행 공존 금지.
- **무손실**: 원본 셀 ↔ long 행 round-trip(validator P3).

---

## 6. 미해소 컨펌 (추정 금지)

| ID | 컨펌 | 영향 |
|----|------|------|
| **Q-STK-1** | 타투 "기본가 2000" vs "3장 4000" 관계 — base 구성요소 별도? | B05 합가형 표현 |
| **Q-STK-2** | BATCH-3 코팅 = mat_cd 유지 vs proc_cd 전환(가격모델 영향) | B01 코팅 차원 |
| **Q-STK-3** | 스티커팩 환산 기준 — 장당(÷54) vs 세트당 | B06 합가형 단위 |
| Q-STK-4(참고) | B01 100x148·90x110 규격 라이브 미적재(round-2 §7-1) | 보완 트랙 |

---

## 7. 한 줄 현황

스티커 분해 설계 완료 — 공식 3(STK_FIXED 재현·TATTOO/PACK 신규)·**단가형 4블록 / 합가형 2블록(round-2 BLOCKED 해소)**·use_dims 3 comp·코팅 proc_cd 컬럼 준비(NULL·컨펌). 컨펌 3건(타투 base·코팅 차원·팩 환산). **다음 = webadmin 복붙용 import.xlsx 빌드 + mapping-flow mermaid → validator P1~P6.**
