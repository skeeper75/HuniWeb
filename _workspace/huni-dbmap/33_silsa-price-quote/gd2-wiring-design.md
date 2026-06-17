# G-D2 포스터 본체 후가공 배선 설계 — round-23 (설계+검증+DRY-RUN GO 핸드오프)

> **작성** 2026-06-17 · round-23. **설계까지 — 적재/COMMIT 안 함**(GO 후 인간 승인). 입력 = `silsa-quote-design.md`(U6)·`dimension-basecode-verification.md`(G-D2/G-D1)·`grouping-model-design.md`(GO)·`webadmin-change-mapping.md`(Phase11·proc_grp·11차원) + **pricing.py 코드 직접 확인** + 라이브 read-only psql.
>
> **G-D2:** 포스터 본체 comp use_dims=`["siz_cd"]`만 → 오시/미싱/귀돌이/가변/별색 후가공을 실사 견적에 붙일 경로 부재(formula_components 후가공 0행). 해소 = 후가공 comp를 공식에 합산 배선.

---

## 0. 핵심 5줄

1. **★엔진은 addtn_yn을 안 읽는다(코드 확정).** `_evaluate_formula`(pricing.py:349)는 공식의 **모든 formula_components를 selections와 매칭 → 매칭되면 합산(`total += subtotal`), 매칭 0건이면 자연 제외**. addtn_yn 컬럼 미참조. 즉 후가공 comp를 공식에 배선만 하면 선택 시 가산·미선택 시 제외(Q-A6/Q-A8 해소).
2. **★U6(유형별 공식 분리)가 G-D2의 선행 필수(코드 입증).** `_row_matches`(pricing.py:70): 행 차원 NULL=와일드카드. 본체 소재 comp는 use_dims=`["siz_cd"]`만(mat_cd NULL) → 단일 공식에 27개 소재 comp 배선 시 siz만 맞으면 **27개 동시매칭 = ERR_AMBIGUOUS(합산 거부)**. 따라서 **G-D2 스코프 = U6 포함**(소재별 공식 분리 후 각 공식에 자기 본체 + 공통 후가공 배선).
3. **후가공 정본 comp 단가행 전건 실재**(오시 30·귀돌이 27·가변 69×2·별색 530+8×53). proc_grp 모델 정합 = 오시/귀돌이/가변/별색 ✅(proc_cd+proc_grp 토큰), **미싱(PERF_1L)만 opt_cd/opt_grp 모델 → proc_cd 전환 필요**(BLOCKED 분리).
4. **G-D1 미싱 prcs_dtl_opt = 이미 해소됨**(라이브 재실측: 미싱 부모 PROC_000030에 `{줄수 max3}` 실재·자식 086 NULL 상속). 이전 "EMPTY" 측정은 stale. 남은 건 PERF comp 차원축 opt_cd→proc_cd 전환(C-4).
5. **배선 매트릭스 = 13 면적공식 + 15 고정가공식 각각에 [본체 1 + 후가공 5(오시·미싱·귀돌이·가변텍스트·가변이미지) + 별색 2(S1/S2)]** 합산 배선. 단가행 재적재 0(전부 실재). 미싱은 BLOCKED(차원축 전환 선행).

---

## 1. G-D2 스코프 확정 — U6 포함 (코드 근거)

### 1.1 엔진 동작 (pricing.py 직접 확인)

| 함수 | 라인 | 동작 | G-D2 함의 |
|------|------|------|----------|
| `_evaluate_formula` | 349 | 공식 comp 전건 순회·매칭 시 `total += subtotal`·**addtn_yn 미참조** | 후가공 배선만 하면 선택 가산. addtn_yn은 메타(엔진 무관) |
| `match_component` | 90 | selections·수량 맞는 단일 행. 없으면 row=None(제외·무경고) | 미선택 후가공 = 자연 제외(정상) |
| `_row_matches` | 70 | 행 차원 NULL=와일드카드·dim_vals 키 일치 필수 | 본체 소재 comp(mat NULL)는 소재 무관 매칭 → **동시매칭 위험** |
| 동시매칭 | 107 | combos>1 → `ERR_AMBIGUOUS`(합산 제외·경고) | **27 소재 comp 단일공식 배선 = 전부 동시매칭 = 합산 거부** |

### 1.2 판정 — G-D2는 U6를 포함해야 독립 실행 가능

- **현 라이브:** `PRF_POSTER_FIXED`에 `COMP_POSTER_ARTPRINT_PHOTO` 1개만 배선(실측). 여기에 나머지 26 소재 comp를 추가하면 → siz_cd만 맞으면 27개 전부 `_row_matches` 통과(소재 차원 없음) → `ERR_AMBIGUOUS` → **가격 0/합산거부**(돈-크리티컬).
- **따라서:** 후가공만 현 단일공식에 add해도 **본체가 동시매칭이라 견적 안 섬**. **U6 공식분리(소재별 PRF_POSTER_<MAT>)가 선행 필수.** 각 공식은 자기 본체 1 comp(동시매칭 없음) + 공통 후가공 N comp.
- **G-D2 스코프 = U6(공식 28분리 + 본체 배선 + 바인딩 교체) + 후가공 배선**. 통합 단위로 실행(분리 불가).

---

## 2. 공식 × 후가공 comp 배선 매트릭스

### 2.1 본체 공식 (U6 분리 — silsa-quote §4 재확인)

면적 13(PRF_POSTER_<MAT> siz_cd) + 고정가 15(PRF_POSTER_FIXED_<X> siz_cd[+min_qty]) = 28 공식. 각 공식 disp_seq 1 = 자기 본체 comp.

### 2.2 후가공 add-on 배선 (각 공식 공통·disp_seq 2~)

| disp_seq | 후가공 comp(정본) | proc_grp | 단가행 | use_dims | 배선 |
|:--:|------|---------|:--:|------|:--:|
| 2 | `COMP_PP_CREASE_1L` 오시 | PROC_000029 | 30 ✅ | proc_cd·min_qty·dim_vals.줄수 | ✅ |
| 3 | `COMP_PP_PERF_1L` 미싱 | (opt_grp:OPT-000005) | 30 ✅ | **opt_cd**·min_qty | 🔴 BLOCKED(C-4 차원전환) |
| 4 | `COMP_PP_CORNER_ROUND` 귀돌이둥근 | PROC_000026 | 9 ✅ | proc_cd·min_qty | ✅ |
| 4' | `COMP_PP_CORNER_RIGHT` 귀돌이직각 | PROC_000026 | 18 ✅ | proc_cd·min_qty | ✅(또는 grouping C-5 통합 후 1 comp) |
| 5 | `COMP_PP_VARTEXT_1EA` 가변텍스트 | PROC_000085 | 69 ✅ | proc_cd·min_qty·dim_vals.개수 | ✅ |
| 6 | `COMP_PP_VARIMG_1EA` 가변이미지 | PROC_000085 | 69 ✅ | proc_cd·min_qty·dim_vals.개수 | ✅ |
| 7 | `COMP_PRINT_SPOT_WHITE_S1` 별색단면 | PROC_000007 | 530 ✅ | plt_siz_cd·proc_cd·print_opt_cd·min_qty | ✅(grouping 정본·5색 흡수) |
| 8 | `COMP_PRINT_SPOT_WHITE_S2` 별색양면 | PROC_000007 | 53 ✅ | 〃 | ✅ |

> **addtn_yn=Y:** 메타데이터로 'Y' 기록(실무 가독성·엔진 무관). disp_seq 1(본체)=Y·후가공도 Y(합산). 엔진은 매칭만 본다.
> **별색 배선:** grouping-model 정본(WHITE_S1=5색 흡수). 형제 색 comp(GOLD/PINK/…)는 grouping U5'에서 use_yn=N → 배선은 정본 2개(S1/S2)만.
> **귀돌이:** grouping C-5 보류 시 ROUND/RIGHT 2 comp 배선, 통합 시 1 comp. proc_cd로 형상 선택 매칭(둥근=PROC_000028·직각=027).

### 2.3 실사 본체 vs 후가공 매칭 흐름 (검산)

```
실사 견적: PRD_000118(인화지) 600×1800, 오시 2줄 선택
  공식 PRF_POSTER_ARTPRINT (U6 분리 후)
   disp1 COMP_POSTER_ARTPRINT_PHOTO: selections{siz_cd=600x1800} 매칭 → 본체가
   disp2 COMP_PP_CREASE_1L: selections{proc_cd=PROC_000090, dim_vals.줄수=2} 매칭 → 오시 2줄 가산
   disp3~ 미선택 후가공: row=None → 제외(무경고)
  total = 본체 + 오시  ✅ 엔진 합산
```

---

## 3. Phase11 엔진 add-on 합산 검증 (코드 근거·Q-A8 해소)

| 검증 | 결과 | 근거(pricing.py) |
|------|------|------------------|
| add-on 합산 방식 | 공식 comp 전건 매칭·합산(addtn_yn 무관) | `_evaluate_formula` total += subtotal (357·430) |
| 선택적 가산 | selections 매칭 시만 가산·미선택 제외 | `match_component` row=None 제외(143) |
| 단일공식 다소재 | ERR_AMBIGUOUS(동시매칭 거부) | combos>1 (107) → **U6 필수 근거** |
| Q-A8(소재별 vs 단일공식 조건분기) | **소재별 공식 분리가 정답**(엔진이 조건분기 미지원·동시매칭만 함) | _row_matches 와일드카드(70)+combos(107) |
| 후가공 차원 매칭 | proc_cd/dim_vals/print_opt_cd로 선택 매칭 | _row_matches NON_QTY_DIMS+dim_vals(73-81) |
| 합가형 환산 | 합가형은 ÷min_qty(후가공은 .01 단가형이라 무관) | component_subtotal(129) |

**결론:** 엔진은 add-on을 **공식 배선 + selections 매칭**으로 합산한다. 별 add_price 컬럼·addtn_yn 로직 없음. 후가공 comp가 적절한 use_dims(proc_cd 등)를 갖고 공식에 배선되면 가산. **Q-A6(합산 vs CPQ)=합산 확정·Q-A8(소재별 vs 단일)=소재별 분리 확정.**

---

## 4. G-D1 미싱 prcs_dtl_opt 명세 (재실측 정정)

- **재실측:** 미싱 부모 `PROC_000030`에 `{"inputs":[{"key":"줄수","max":3,"min":0,"unit":"줄"}]}` **이미 실재**. 자식 `PROC_000086` NULL(상속). → **이전 "EMPTY 누락"(dimension-basecode §3.3 G-D1) 정정: 상세옵션은 이미 설정됨**(그 사이 적재 또는 이전 측정 stale).
- **남은 작업 = 미싱 comp 차원축 전환(grouping C-4):** `COMP_PP_PERF_1L` use_dims=`["opt_cd","min_qty","opt_grp:OPT-000005"]` → 오시 동형 `["proc_cd","min_qty","proc_grp:PROC_000030"]` + dim_vals.줄수로 재정규화. + prc_typ .02→.01. 이게 돼야 미싱이 다른 후가공과 동일 proc_grp 모델로 배선됨.
- **명세:** ① 미싱 comp use_dims opt→proc 전환 ② 단가행 opt_cd(OPV-000007/8/9) → dim_vals.줄수(1/2/3) 이설 ③ prc_typ .02→.01 ④ PERF_2L/3L use_yn=N. **이설(값동일·신규0)**. 이는 grouping C-4와 동일 — G-D2 배선의 BLOCKED 해소 선행.

---

## 5. BLOCKED / 컨펌 정직 분류 + load-builder 인계 단위

### 5.1 BLOCKED

| ID | 항목 | 이유 | 해소 선행 |
|----|------|------|----------|
| **B-1 미싱 배선** | PERF_1L 차원축 opt_cd(proc_grp 부정합) | 다른 후가공과 모델 불일치 | C-4(opt→proc 전환·dim_vals.줄수)·이후 배선 |

### 5.2 load-builder 인계 단위 (멱등 SQL·DRY-RUN R1~R6)

| 단위 | 테이블 | 조치 | 행수 | 멱등키 | 단가행 재적재 |
|------|--------|------|:--:|--------|:--:|
| **W1 본체 공식 분리(U6)** | price_formulas | 28 유형별 공식 INSERT(PRF_POSTER_<MAT>·_FIXED_<X>) | ~28 | frm_cd | 0 |
| **W2 본체 배선** | formula_components | 각 공식 disp1=자기 본체 comp | 28 | (frm_cd,comp_cd) | 0 |
| **W3 바인딩 교체** | product_price_formulas | 28상품 PRF_POSTER_FIXED→자기 공식 | 28 UPDATE | (prd_cd,frm_cd) | 0 |
| **W4 후가공 배선** | formula_components | 각 공식 disp2~ 후가공 comp(오시·귀돌이·가변·별색 7, addtn_yn=Y) | 28×7=~196 | (frm_cd,comp_cd) | 0 |
| **W5 미싱 전환(B-1)** | price_components / component_prices | PERF use_dims opt→proc·dim_vals.줄수 이설·prc_typ.02→.01·2L/3L use_yn=N | 정정1+이설20 | comp_cd+dim_vals | 이설(값동일) |
| **W6 미싱 배선** | formula_components | W5 후 각 공식에 PERF_1L | 28 | (frm_cd,comp_cd) | 0 |

- **순서:** W1→W2→W3(본체 견적 성립) ; W4(후가공 add) 독립 ; W5(미싱 전환)→W6(미싱 배선).
- **DRY-RUN 검증 포인트(R1~R6):** ① 멱등 재실행 delta 0 ② FK 고아 0(comp/frm/prd 선존재) ③ 동시매칭 0(각 공식 본체 1 comp·소재 차원 불요) ④ 골든 재현(인화지 600×1800 = 본체+후가공 손계산 일치) ⑤ 후가공 미선택 시 제외 ⑥ 별색 정본만 배선(형제 use_yn=N 정합).

---

## 6. 미해소 컨펌

| ID | 컨펌 | 권고 |
|----|------|------|
| Q-G2-1 | addtn_yn 값 = 본체/후가공 모두 'Y' | Y(메타·엔진무관). 가독성용 |
| Q-G2-2 | 귀돌이 ROUND/RIGHT 2 comp 배선 vs C-5 통합 1 comp | C-5 통합 후 1 comp(grouping) |
| Q-G2-3 | 별색 배선 정본 2(S1/S2) — 형제 use_yn=N 선행 | grouping U5' 선행 |
| Q-G2-4 | 미싱 차원전환(B-1) = 이번 포함 vs 별 단위 | 포함(배선 완결 위해) |
| Q-G2-5 | U6 공식 명명·고정가 15 공식 단위(상품별 vs 그룹) | 소재/유형별 28 |

---

## 7. read-only 준수

- 라이브 SELECT(후가공 단가행·use_dims·PRF_POSTER_FIXED 배선·미싱 prcs_dtl_opt) + pricing.py 코드 직접 확인(addtn_yn 미참조·동시매칭·_row_matches). INSERT/UPDATE/DDL/COMMIT 0. 비밀값 미출력.
- 설계까지 — load-builder가 W1~W6 멱등 SQL+DRY-RUN 조립·GO는 dbm-validator·실 COMMIT 인간 승인.
