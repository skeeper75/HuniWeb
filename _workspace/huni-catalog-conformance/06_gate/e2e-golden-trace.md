# e2e-golden-trace.md — K5 종단 골든 추적 (게이트 독립 재계산)

> **Phase 6 — hcc-conformance-gate** · 2026-06-22 · `huni-catalog-conformance/06_gate`
> 대표 상품에 `옵션 선택값 → polymorphic 차원 환원 → component_prices 단가행 매칭 → evaluate_price → final_price`를
> 게이트가 **직접 재계산**(생성측 trace 인용 아님). 단가값 verbatim(라이브 SELECT). 정합의 살아있는 증거.
> 권위 알고리즘: `raw/webadmin/webadmin/catalog/pricing.py` `evaluate_price`/`_evaluate_formula`/`component_subtotal`(직독).

---

## 알고리즘 계약(게이트가 직독 확인)

- **source 우선순위**(L311-326): ① 상품직접단가(t_prd_product_prices) → ② 공식(t_prd_product_price_formulas). 디지털 전 상품 직접단가 0 → 전부 FORMULA.
- **`_evaluate_formula`**(L444-475): `t_prc_formula_components`를 disp_seq 순 순회, **각 component를 `_match_entry`로 매칭해 무조건 합산**(addtn_yn은 평가에서 미사용 — 전 component 합산). proc 차원 component만 proc_sels로 다중평가.
- **`_match_entry`**(L398-440): comp의 `use_dims` 비수량 차원으로 정확 매칭 + min_qty/사이즈는 구간(이상/이하). `non_qty_dims` 없으면 "선택 무관 항상 매칭"(L414-415).
- **`component_subtotal`**(L177-188): 단가형(PRICE_TYPE.01) = `unit_price × qty`. 합가형(.02) = `unit_price ÷ tier_min_qty × qty`.
- **final**(L346-369): `Σ included subtotal` → 수량구간 할인 → 등급할인 → `round_won`.

---

## 추적 1 — ✅ 성공: 스탠다드엽서 PRD_000018 (PRF_DGP_A 원자합산형)

**바인딩 재확인:** `SELECT frm_cd FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000018';` → PRF_DGP_A ✅

| 단계 | 게이트 재계산 | 라이브 근거(verbatim) |
|------|--------------|----------------------|
| ① 옵션 선택 | 출력판형=국4절·인쇄=양면(POPT_000002,4도)·용지=MAT_000074·코팅=무광1면·수량 Q | option_items(OPT_REF_DIM.03→MAT_000074 등) |
| ② 차원 환원 | selections `{plt_siz_cd:SIZ_000499, print_opt_cd:POPT_000002, mat_cd:MAT_000074, coat_side_cnt:1, min_qty:출력매수}` | 018 plate = SIZ_000499(316x467·OUTPUT_PAPER_TYPE.01) |
| ③ 단가행 매칭 | PRF_DGP_A 구성요소: COMP_PRINT_DIGITAL_S1(use_dims=[proc_cd,**plt_siz_cd**,print_opt_cd,min_qty]) + COMP_PAPER([plt_siz_cd,mat_cd]) + COMP_COAT_MATTE([proc_cd,plt_siz_cd,coat_side_cnt,min_qty]). 유광 미선택→COMP_COAT_GLOSSY no-match(자연 제외) | t_prc_component_prices |
| ④ evaluate_price | 단가형 각 unit×qty 합산 | pricing.py `_evaluate_formula` |
| ⑤ final_price | round_won(Σ)·수량할인 0·등급 0 → final | — |

**단가행 verbatim(게이트 SELECT):**
- 인쇄 COMP_PRINT_DIGITAL_S1 / plt_siz_cd=SIZ_000499 / POPT_000002 / 출력매수구간: min_qty=1→4,000 ··· 100→350 ··· 1000→165 ··· 10000→145 (51 tier).
- 용지 COMP_PAPER / SIZ_000499 / MAT_000074 → **70.64**원/장.
- 코팅 COMP_COAT_MATTE / SIZ_000499 / 1면 / min_qty=1→2,000 ··· 20→800.

**핵심 검증:** COMP_PRINT는 siz_cd가 아니라 **plt_siz_cd**로 키잉됨(생성측 trace의 "siz_cd=SIZ_000077" 표기는 부정확하나 SIZ_000077·SIZ_000499 두 판형 모두 plt_siz_cd 실재 → 환원 성립).
**판정: 종단 성공.** 원자합산형(엽서·접지카드·배경지·헤더택·전단류 ~20상품)은 비-0 final 산출. 유광 선택분만 COMP_COAT_GLOSSY 0행으로 과소(K4-d).

---

## 추적 2 — 🔴 끊긴 지점(가장 비싼 결함): 코팅명함 PRD_000032 (PRF_NAMECARD_FIXED)

**바인딩 재확인:** 031·032 둘 다 PRF_NAMECARD_FIXED ✅
**공식 배선 재확인:** `SELECT comp_cd,disp_seq,addtn_yn FROM t_prc_formula_components WHERE frm_cd='PRF_NAMECARD_FIXED';`
→ COMP_NAMECARD_STD_S1(seq1,Y) · COMP_NAMECARD_STD_S2(seq2,Y) **단 둘만**. COAT/PREMIUM/PEARL/SHAPE/FOIL/WHITE 전부 **미배선(orphan)**.

### 032가 제공하는 자재(option_items 재실측)
`OPT_REF_DIM.03` ref_key1 = **MAT_000081, MAT_000082**.

### STD comp 단가행(공식에 배선된 유일 comp)
| comp | mat_cd | min_qty | unit_price |
|------|--------|--------:|-----------:|
| STD_S1 | MAT_000074 | 100 | 3,500 |
| STD_S1 | MAT_000082 | 100 | 3,800 |
| STD_S2 | MAT_000074 | 100 | 4,500 |
| STD_S2 | MAT_000082 | 100 | 4,800 |

→ **STD엔 MAT_000081 행이 없다.** (use_dims=[mat_cd,min_qty], print_opt_cd 부재)

### COAT comp 단가행(정답·그러나 orphan)
| comp | mat_cd | min_qty | unit_price |
|------|--------|--------:|-----------:|
| COAT_S1 | MAT_000081 | 100 | 5,500 |
| COAT_S1 | MAT_000082 | 100 | 5,800 |
| COAT_S2 | MAT_000081 | 100 | 6,500 |

### 게이트 골든 재계산 — 두 시나리오 (단가형 unit×qty)

**시나리오 A: 고객이 MAT_000082 선택, 단면, qty=100**
- 기대(권위): 코팅 단면 = COAT_S1(MAT_000082)=5,800 ×100 = **580,000**
- 라이브 엔진 실제: PRF엔 STD만 배선 + STD use_dims에 print_opt_cd 없음 → 단면이라도 **S1·S2 둘 다 매칭**
  → (STD_S1 3,800 + STD_S2 4,800) ×100 = **860,000**
- **차이 = +280,000원 과대** (이중합산 D-B + COAT 미배선 D-A 합성 = 부호 과대)

**시나리오 B: 고객이 MAT_000081 선택, 단면, qty=100**
- 기대(권위): COAT_S1(MAT_000081)=5,500 ×100 = **550,000**
- 라이브 엔진 실제: STD엔 MAT_000081 행 부재 → 두 STD comp 모두 no-match → included 0
  → `_evaluate_formula` 합계 0 → lenient "매칭 0건·합계 0원" 경고 → **final 0원**
- **차이 = −550,000원 과소(0원)** (견적이 안 나옴·주문불가)

> **★끊긴 지점 = ③ 단가행 매칭.** 옵션이 가리키는 variant(COAT)가 공식에 배선되지 않아, 엔진이 같은 공식의
> STD comp를 매기거나(MAT_000082→이중합산 과대) 아예 매칭 실패(MAT_000081→0원). comp는 실재(orphan)하나 **공식↔comp 배선이 끊겼다.**
> codex N1(합성 부호) 입증: 동일 상품에서 자재 선택에 따라 과대(+280K)와 0원(−550K)이 갈린다 → 상품별 최종 부호는 합성 재계산해야 확정.

---

## 추적 3 — 🔴 미바인딩 10상품 (frm_cd 공란)

`PRD_000019·030·034·035·036·037·038·039·040·049` — t_prd_product_price_formulas 행 부재.
→ ② 차원 환원까지 가더라도 ④에서 source=NONE(pricing.py L329-335) → base=0 → **final 0원/None(견적 자체 불가).**
comp는 대부분 orphan으로 실재(COMP_NAMECARD_PEARL/SHAPE/CLEAR/FOIL 단가행 충전) → "신규 mint 아닌 공식 신설+바인딩" 문제. 형압명함(038)만 comp 미실재(G-4).

---

## 종합 — K5 FAIL

| 경로 | 상품군 | 게이트 재계산 결과 |
|------|--------|--------------------|
| 원자합산형 PRF_DGP_A~F | 엽서·접지카드·배경지·헤더택·전단·상품권 | ✅ 비-0 final(유광 선택분만 0원 침묵) |
| 고정가형 명함 PRF_NAMECARD_FIXED | 명함류 | 🔴 MAT_000082→860,000 과대 / MAT_000081→0원 (D-A+D-B 합성) |
| 고정가형 포토카드 PRF_PHOTOCARD_FIXED | 포토카드 | △ 본체 SET 단가행 실재(종단 가능)·화이트인쇄 옵션 미적재(K7 X2) |
| 미바인딩 10 | 투명엽서·지그재그·명함7·와이드접지 | 🔴 final 0원/None |

**가장 비싼 결함 순위:** ① 미바인딩 10(견적 0원·아예 안 나옴) → ② 명함 D-A/D-B 합성(MAT별 +280K 과대 또는 −550K 0원·틀린값 성립) → ③ COMP_COAT_GLOSSY 0행(유광 과소).
