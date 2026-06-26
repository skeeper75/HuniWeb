# A2 C5-D1 — 094 엽서북 30P 고아배선(저청구) 교정안

**작성:** dbm-price-arbiter (round-18 확장) · 2026-06-26
**범위:** 094 엽서북 가격 배선 한정 (§23 셋트 직결이나 본 교정은 094 PRF_PCB_FIXED 가격 배선만)
**상태:** 분석·DRY-RUN까지 · **실 COMMIT은 인간 승인 후 dbmap 트랙(round-13 교정) 위임**
**권위:** 가격표 260527 엽서북떡메 시트 B01 블록 (verbatim) · 라이브 읽기전용

---

## 0. 한 줄 결론

엔진에 페이지 차원이 없어 30P 주문이 20P comp로 fallback 매칭(저청구). 30P comp는 단가가 **권위 정합인데 고아**(미배선)다.
교정 = 30P comp를 공식에 배선하되, **페이지를 `dim_vals.page` 차원으로** 20P/30P 양쪽 comp에 부여(배타화) + **30P comp의 `print_opt_cd` 보강**(단면/양면 배타화·R-3 이중합산 가드). 데이터(unit_price)는 한 행도 건드리지 않는다.

---

## 1. 094 엽서북 가격 모델 실측 (라이브)

### 1.1 상품·바인딩·셋트 구조
| 항목 | 값 | 출처 |
|---|---|---|
| 셋트 완제품 | `PRD_000094` 엽서북 | t_prd_products |
| 구성원(BOM) | `PRD_000095` 내지(몽블랑240), `PRD_000096` 표지(스노우300) | t_prd_product_sets |
| 구성원 자기공식 | **없음**(095·096 모두 t_prd_product_price_formulas 0건) | 라이브 실측 |
| 094 자기공식 | `PRF_PCB_FIXED` (apply 2026-06-01) | t_prd_product_price_formulas |
| 페이지 룰 | page_min=20, page_max=30, page_incr=10 → **20 또는 30 선택** | t_prd_product_page_rules (PRD_000094) |

→ **엽서북 전체 가격은 094 부모공식 `PRF_PCB_FIXED` 단일 완제품표(사이즈·면·페이지·수량)에 들어있다.** 구성원은 구조(BOM)일 뿐 가격은 부모표가 전담. `evaluate_set_price`(pricing.py:789)는 094 부모공식을 `set_selections`+`copies`로 평가한다 → **페이지 차원은 094 부모공식 매칭 문제**이며 본 교정의 정확한 스코프.

### 1.2 공식·구성요소 현 배선
```
PRF_PCB_FIXED (엽서북 사이즈/면/페이지/수량별 단가)
  formula_components (현재):
    COMP_PCB_S1_20P  disp_seq=1  addtn_yn=Y   ← 배선됨
    COMP_PCB_S2_20P  disp_seq=2  addtn_yn=Y   ← 배선됨
    (COMP_PCB_S1_30P  미배선 = 고아)
    (COMP_PCB_S2_30P  미배선 = 고아)
```

### 1.3 구성요소 use_dims·단가행 (라이브)
| comp_cd | comp_nm | prc_typ | use_dims | rows | print_opt_cd | dim_vals |
|---|---|---|---|---|---|---|
| COMP_PCB_S1_20P | 단면·20p | PRICE_TYPE.01 | `["siz_cd","min_qty","print_opt_cd"]` | 117 | **POPT_000001(단면) 전행** | NULL |
| COMP_PCB_S2_20P | 양면·20p | PRICE_TYPE.01 | `["siz_cd","min_qty","print_opt_cd"]` | 117 | **POPT_000002(양면) 전행** | NULL |
| COMP_PCB_S1_30P | 단면·30p | PRICE_TYPE.01 | `["siz_cd","min_qty"]` | 117 | **NULL 전행(와일드카드)** | NULL |
| COMP_PCB_S2_30P | 양면·30p | PRICE_TYPE.01 | `["siz_cd","min_qty"]` | 117 | **NULL 전행(와일드카드)** | NULL |

- 사이즈 3종: SIZ_000003(100x150)·SIZ_000124(150x100)·SIZ_000004(135x135). 각 comp = 3사이즈 × 39수량구간 = 117행 완전 그리드(갭 0).
- **20P comp = print_opt_cd로 단면/양면 배타** (S1=단면, S2=양면). 두 20P comp가 같은 공식에 addtn_yn=Y로 배선됐지만, print_opt 차원이 선택값과 정확히 매칭돼 **하나만 살아남는다**(이게 기존 R-3 이중합산 가드).
- **30P comp = print_opt_cd NULL + use_dims에서 print_opt 빠짐 → 와일드카드.** 단면/양면 구분이 오직 comp_cd 접미사(S1/S2)에만 존재 → 엔진은 이를 모름.

### 1.4 페이지(20/30)가 엔진에 들어오는 경로
- **엔진에는 페이지 차원이 없다.** `NON_QTY_DIMS = (siz_cd, plt_siz_cd, print_opt_cd, mat_cd, proc_cd, opt_cd, coat_side_cnt, bdl_qty)` — page 없음(pricing.py:42).
- 페이지는 `t_prd_product_page_rules`로 화면에 노출(price_views.py:1464 `page_rule`)되고, `derive_inner_sheets`로 **내지 매수(수량) 산출**에만 쓰인다(price_views.py:1701~1707). **price `selections`에는 들어가지 않는다.**
- 단, **셋트 부모공식은 `set_selections`(price_views.py:1728)를 그대로 받는다** — 클라이언트가 보내는 자유 dict. ★ 따라서 페이지 판별자를 `set_selections`에 실어 보낼 수 있다(클라이언트가 page_rule을 이미 알고 있음).

---

## 2. 결함 근본원인 (root-cause)

### 2.1 진짜 원인 = "엔진 페이지 차원 부재 + comp_cd 접미사에만 페이지 인코딩"
엔진 매칭은 `_row_matches`(pricing.py:82)로 **use_dims의 NON_QTY_DIM + dim_vals만** 본다. 페이지는 둘 다 아니다.
→ 30P를 **comp_cd 접미사(S1_30P)** 로만 구분하는 설계는 엔진이 해석 못 하는 차원이다. 공식에 배선해도 엔진은 "20P냐 30P냐"를 모른다.

### 2.2 현 상태 동작 (저청구 실증)
30페이지 주문(SIZ_000003·단면·qty100):
- 엔진은 바인딩된 `COMP_PCB_S1_20P`만 평가 → siz·print_opt·qty 매칭 → **4,500 청구**.
- 30페이지 선택은 가격에 **아무 효과 없음**(수량 산출에만 반영). 권위 30P 단가 **5,100**을 못 받음.
- **장당 600원 저청구** (qty100 → 60,000원 저청구). 사이즈·수량구간마다 갭은 다름(예 30P 100*150 qty6 = 8,100 vs 20P 7,300 = 800원 갭).

### 2.3 ★naive-fix가 만드는 이중함정 (배선 시 동반 교정 필수)
30P comp를 use_dims 현상태로 그냥 배선하면:
1. **페이지 이중합산** — 20P comp(4,500)와 30P comp(5,100)가 **둘 다 매칭**(서로를 배제할 차원 없음) → addtn_yn=Y로 **합산** = 9,600. 30P 주문도 20P comp가 살아남고, 20P 주문도 30P comp가 살아남음.
2. **단면/양면 이중합산(R-3 재활성)** — 30P comp의 `print_opt_cd=NULL`은 와일드카드라 **단면 주문에 S1_30P(5,100)와 S2_30P(5,300)가 둘 다 매칭** → 합산.
   → naive 4-comp 배선 = 4,500 + 5,100 + 5,300 = **14,900**(올바른 값 5,100의 2.9배 과대청구). A2 기록의 "print_opt 차원 보강 동반 필수"가 정확히 이 함정.

### 2.4 데이터는 무결 (A2-class = 배선/차원 결함, 데이터 아님)
권위 260527 엽서북떡메 B01 verbatim:
- 100*150 단면 20P @ qty100 (row18 col B) = **4,500**
- 100*150 단면 30P @ qty100 (row18 col C) = **5,100**

라이브 unit_price(COMP_PCB_S1_30P @ SIZ_000003 min_qty100 = 5,100)는 **권위와 verbatim 일치**. → 30P 단가는 올바로 적재돼 있다. **결함은 오직 (a)배선 누락 + (b)판별차원 부재**. unit_price는 한 행도 손대지 않는다.

★ 권위 가격표 구조가 `사이즈 > 단면/양면 > 20P/30P` 3단 헤더(price-postcard-book-l1.csv B01) → **페이지는 권위가 정한 1급 가격축**. 교정은 권위 구조를 라이브에 복원하는 것이지 신설이 아니다.

---

## 3. 교정 구조 — 대안·트레이드오프·권고

페이지(20/30)를 엔진이 인식하는 가격 매칭 차원으로 연결해야 한다. 4 대안:

### 대안 ⓐ — `dim_vals.page` 판별자 (권고 ★)
- 4 comp 전 단가행에 `dim_vals` 부여: 20P comp → `{"page":"20"}`, 30P comp → `{"page":"30"}`.
- 30P comp에 `print_opt_cd` 보강: S1_30P → POPT_000001(단면), S2_30P → POPT_000002(양면). use_dims에도 `print_opt_cd` 추가.
- 4 comp 전부 공식에 배선(addtn_yn=Y).
- 클라이언트는 `set_selections`에 `page` 키 추가 전송(이미 page_rule 보유).
- **엔진 코드 수정 0** — `_row_matches`가 dim_vals를 이미 와일드카드 없이 정확매칭(pricing.py:91). page는 NON_QTY_DIM이 아니어도 dim_vals 경로로 동작.
- 트레이드오프: dim_vals는 본래 "공정 상세 파라미터"용 → page를 여기 싣는 건 의미축 약간 확장(단 와일드카드 없는 정확매칭이 페이지에 정확히 부합). 신규 dim_vals 키 'page'는 라이브에 0건(충돌 없음).

### 대안 ⓑ — `opt_cd`에 페이지 코드 부여
- page를 opt_cd(예 PAGE_20/PAGE_30)로 인코딩, NON_QTY_DIM `opt_cd`로 매칭.
- 트레이드오프: opt_cd는 NULL이면 와일드카드 → 20P/30P 양쪽에 opt_cd 부여 필요(=ⓐ와 동일 노력). opt_cd는 CPQ 옵션코드 의미와 충돌 소지(페이지는 옵션 선택지가 아니라 page_rule 파생). 의미 오염 위험 → 비권고.

### 대안 ⓒ — 페이지를 NON_QTY_DIMS에 신설(엔진 코드 수정)
- `pricing.py`에 page_cnt 차원 추가 + component_prices 컬럼 신설.
- 트레이드오프: 엔진 코드 + 스키마 DDL 동시 변경 = 가장 침습적. 책자 전반(072 등)에 광역 영향. **돈-크리티컬 영역에서 최소 변경 원칙 위배** → 본 결함엔 과잉. (장기적으로 책자류 페이지가 보편화되면 별 트랙으로 재검토 — 컨펌 분리.)

### 대안 ⓓ — 30P를 별도 공식 PRF_PCB_30P로 분리 + 페이지로 공식 라우팅
- 트레이드오프: 상품-공식 바인딩은 페이지별 분기 불가(t_prd_product_price_formulas는 prd_cd 단위). 라우팅 로직 신설 필요 → 엔진 수정. 비권고.

### 권고 = ⓐ `dim_vals.page` + `print_opt_cd` 보강
근거: ① 엔진 코드 무변경(돈-크리티컬 최소 침습) ② dim_vals 정확매칭이 페이지 배타에 정확 부합(와일드카드 없음 = 페이지 누락 시 매칭0=안전) ③ 기존 20P print_opt 가드 패턴을 30P에 동형 복원 ④ 권위 3단 헤더 구조를 그대로 차원화. **트랙 = round-13 교정**(라이브 UPDATE/배선, 데이터 무변경·구조 교정).

---

## 4. 이중합산 가드 (배타성 증명)

교정 후 매칭 규칙(`_row_matches` 적용):
| 차원 | 20P comp 행 | 30P comp 행 | 효과 |
|---|---|---|---|
| `print_opt_cd` | POPT_000001(S1)/POPT_000002(S2) | **POPT_000001(S1)/POPT_000002(S2) 보강** | 단면/양면 배타(와일드카드 제거) |
| `dim_vals.page` | `"20"` 부여 | `"30"` 부여 | 페이지 배타(정확매칭·와일드카드 없음) |
| `siz_cd` | 기존 | 기존 | 사이즈 매칭 |
| `min_qty` | 기존 | 기존 | 수량구간 |

- 30P·단면 주문 → S1_30P만 생존(S2_30P는 print_opt 불일치, 20P 양쪽은 page 불일치). **정확히 1 comp**.
- 각 comp는 독립 평가(공식 iterate)되므로 cross-comp 모호성 없음. comp 내부는 (siz,popt,page) 1조합 → ERR_AMBIGUOUS 미발생.
- **page 누락 주문(클라이언트가 page 미전송)** → 4 comp 모두 dim_vals.page 불일치로 매칭0 → 합계 0원 + 경고("매칭되는 구성요소 없음"). **silent 저청구 대신 명시적 0원/경고**(lenient) 또는 차단(strict). ★이게 핵심 안전 개선: 현재는 page 무시하고 20P로 silent fallback이지만, 교정 후엔 page를 반드시 선택해야 가격이 나옴 → 저청구 불가능.

---

## 5. DRY-RUN 4조합 실증 (라이브 시뮬레이션, SIZ_000003·qty100)

| 주문 | 현재(저청구) | naive-fix(과대) | **교정 후(정확)** | 권위 |
|---|---|---|---|---|
| 20P 단면 | 4,500 ✓ | 4,500 | **S1_20P=4,500** | 4,500 |
| 20P 양면 | (20P양면=4,500) | — | **S2_20P=4,500** | 4,500 |
| 30P 단면 | **4,500 🔴(−600)** | 14,900 🔴 | **S1_30P=5,100** | 5,100 |
| 30P 양면 | **4,500 🔴(−800)** | — | **S2_30P=5,300** | 5,300 |

→ 교정 후 4조합 각자 올바른 단가로 **정확히 1 comp 청구·이중합산 0**. (SQL 시뮬은 pcb-30p-fix.dryrun 참조.)

---

## 6. 미해소·컨펌 분리

| # | 항목 | 상태 |
|---|---|---|
| C-1 | **클라이언트(price_views set quote)가 `set_selections`에 `page` 키를 전송하도록 위젯/뷰어 보강** — 본 DB 교정과 **별 트랙**(코드). DB 교정만으로 page 미전송 시 매칭0(저청구는 막히나 견적불가). 위젯 트랙 컨펌 필요. | 컨펌 |
| C-2 | 094 옵션그룹 오염(사이즈 그룹에 종이 옵션 혼입 OPV_000091 등) — 본 결함과 무관·별 정합 트랙. | 범위 외 |
| C-3 | dim_vals 키명 `page` 확정 — 라이브 0건이라 충돌 없음. webadmin price_grid UI가 dim_vals를 공정 파라미터로 렌더하므로 page 키 표시 영향 점검 필요. | 컨펌(경미) |
| C-4 | 엽서북떡메 시트엔 떡메(B02)도 있음 — 본 교정은 엽서북(B01) 094만. | 범위 명시 |

---

## 7. 폐루프 RTM

| 가격요소 | 20P | 30P | 게이트 |
|---|---|---|---|
| 사이즈(siz_cd) | ✓ 배선·매칭 | ✓ 배선(117행 완전) | 라이브 실측 GO |
| 면(print_opt) | ✓ 배타 | **교정: NULL→POPT 보강** | DRY-RUN 배타 실증 |
| 페이지(page) | **교정: dim_vals.page=20** | **교정: dim_vals.page=30** | DRY-RUN 배타 실증 |
| 수량구간(min_qty) | ✓ | ✓ | 라이브 실측 GO |
| 단가값(unit_price) | ✓ 권위 verbatim | ✓ 권위 verbatim(무변경) | A1 인용 실재 GO |

재검증 게이트: 인간 승인 → round-13 적용 → `evaluate_set_price` 094 4조합 재계산 → 권위 일치 + 이중합산 0 → RESOLVED.
