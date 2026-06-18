# engine-contract.md — `evaluate_price` 권위 알고리즘 계약

> **검증의 자(尺).** 라이브 데이터가 옳은지 판정하려면 먼저 "엔진이 데이터를 어떻게
> 해석하는가"가 권위로 고정돼야 한다. 이 문서는 `raw/webadmin/webadmin/catalog/pricing.py`
> (이하 `pricing.py`)의 실제 로직만 명세한다. 모든 규칙에 `pricing.py:line` 인용을 붙인다.
> 추측 0 — 인용 없는 규칙은 `UNVERIFIED`로 표기.
>
> 소스 권위: `pricing.py` (2026-06-18 시점, 570줄). 라이브 실측: 2026-06-18 읽기전용 SELECT.
> 산출자: hpq-engine-cartographer (Phase 1 기준점). 검증자가 P1~P7에서 이 명제들을 참조.

---

## 0. 함수 시그니처 & 반환 계약

```
evaluate_price(target, selections, qty, grade_cd=None, mode="lenient",
               as_of=None, only_comps=None, proc_sels=None)   # pricing.py:247
```

| 인자 | 타입 | 의미 | 근거 |
|------|------|------|------|
| `target` | `{"prd_cd":..}` 또는 `{"tmpl_cd":..}` | 평가 대상 (상품 또는 템플릿) | :251, :276-277 |
| `selections` | `{차원키: 값}` | 차원 선택값(부분 가능) | :252, :264 |
| `qty` | int ≥1 | 주문수량 | :253, :266-268 |
| `grade_cd` | str\|None | 고객등급(미지정=등급할인 미적용 기준가) | :254, :363 |
| `mode` | `"lenient"`\|`"strict"` | 매칭실패 처리 모드 | :255, :269 |
| `as_of` | `'yyyy-MM-dd'`\|None | 기준일(기본 오늘) — 시계열·미래분 제외 | :256, :263 |
| `only_comps` | set/list\|None | 구성요소 부분집합 합산제한(what-if) | :257, :270 |
| `proc_sels` | `[{"proc_cd":..,"detail":{..}}..]`\|None | 다중공정 평가 | :444-449 |

**반환 dict 계약** (:375-395): `ok`, `target{kind,code,name}`, `qty`, `as_of`, `mode`,
`base{source,amount,components,warnings}`, `discounts[]`, `final_price`(int\|None), `warnings[]`, `errors[]`.

- **명제 E0-1**: `qty`가 int 변환 불가면 `qty=0`이 된다 (:266-268). 이후 단가형은 0원, 합가형은
  per_item×0=0원. → 호출측(`price_simulate`)이 qty<1을 422로 막아야 함(뷰가 막음, 엔진은 안 막음).
- **명제 E0-2**: `final_price`는 `ok=False`(strict+errors)면 `None`, 아니면 `round_won(running)`(:369).

---

## 1. 가격 우선순위 (소스 결정)

CONTEXT 승계 규칙(:13, :43): **템플릿단가 → 상품 직접단가 → 상품 공식 → 없음.**

| 순위 | source 코드 | 조건 | 근거 |
|------|------------|------|------|
| 1 | `TEMPLATE_PRICE` | `tmpl_cd` 타깃 + `t_prd_template_prices` 최신행 unit_price≠NULL | :285-297 |
| 2 | `PRODUCT_PRICE` | `prd_cd` + `t_prd_product_prices` 최신행 unit_price≠NULL | :311-317 |
| 3 | `FORMULA` | 위 둘 부재 + `t_prd_product_price_formulas` 최신 frm_cd 존재 | :319-327 |
| — | `NONE` | 셋 다 부재 | :329-335 |

- **명제 P1-1 (템플릿 폴백)**: `tmpl_cd` 타깃인데 템플릿단가가 없으면 `base_prd_cd`(:291)로
  내려가 상품 직접단가→공식 순으로 재시도한다 (:298-301, prd_cd=eff_prd_cd 전환).
- **명제 P1-2 (직접단가 오버라이드)**: 상품에 직접단가가 1행이라도 있으면 공식을 **타지 않는다**
  (:315 if cur_pp → base_amount 세팅, :318 else 에서만 공식). 직접단가가 공식보다 우선.
- **명제 P1-3 (최신행 선택)**: 우선순위 각 단계의 "현재 적용"은 `_latest_ymd(rows, key, as_of)`
  = `as_of` 이하 행 중 `apply_ymd`(또는 `apply_bgn_ymd`) 최대 (:232-235). 미래분 자동 제외.
- **라이브 실측 (2026-06-18)**: `t_prd_product_prices`=0행, `t_prd_template_prices`=0행
  → **현재 전 상품이 순위 3(FORMULA)으로만 평가됨.** 순위 1·2 경로는 코드엔 있으나 데이터 0건.
  → **검증 함의**: 순위 1·2 적재가 0인 한, 직접단가 오버라이드(P1-2)는 라이브에서 발화하지 않는다.

---

## 2. 공식 = 구성요소 합산

CONTEXT(:14-15, :8①): **frm_typ 폐기 — 공식은 항상 구성요소 합산.** `frm_typ_cd`는 엔진이
참조하지 않는다(`_evaluate_formula`에 frm_typ 분기 없음, :444-475).

- **명제 P2-1 (배선)**: 공식의 구성요소는 `t_prc_formula_components`를 `frm_cd`로 필터,
  `disp_seq` 순으로 가져온다 (:450-453). 각 행은 `comp_cd__prc_typ_cd`, `comp_cd__use_dims`를
  조인으로 가져온다.
- **명제 P2-2 (자동매칭 = 호출자 무관)**: 호출자는 구성요소 목록을 넘기지 않는다. 각 구성요소가
  selections와 차원 자동매칭되어 매칭행이 있으면 포함, 없으면 자연 제외 (:457-474, `_match_entry`).
- **명제 P2-3 (합계 = included만)**: `base_amount`(FORMULA)는 `included=True`인 entry의
  `subtotal` 합 (:346, :347-348). 매칭 0건이면 strict=error, lenient=0원+경고 (:349-352).
- **명제 P2-4 (`addtn_yn` 무시)**: CONTEXT(:23) — `t_prc_formula_components.addtn_yn`은 엔진이
  사용하지 않는다. `_evaluate_formula`가 addtn_yn을 select/분기에 쓰지 않음(:450-453 select 목록에 없음).

---

## 3. 차원 자동매칭 — NON_QTY_DIMS / TIER_DIMS

엔진 상수 (실제 코드명):

```python
NON_QTY_DIMS = ("siz_cd","plt_siz_cd","print_opt_cd","mat_cd","proc_cd",
                "opt_cd","coat_side_cnt","bdl_qty")           # pricing.py:38-39
TIER_DIMS    = ("siz_width","siz_height","min_qty")           # pricing.py:45
TIER_UPPER   = ("siz_width","siz_height")                     # pricing.py:46
```

### 3.1 비수량 차원(정확값 매칭) — `_row_matches` (:78-90)

- **명제 P3-1 (NULL=와일드카드)**: 단가행의 비수량 차원이 NULL이면 그 차원은 어떤 선택값이든
  통과 (:83-84 `if rv is None: continue`).
- **명제 P3-2 (비교 정규화)**: 코드/정수 혼재를 문자열로 통일해 비교(`_norm`, :68-70).
  `_norm(selections.get(d)) != _norm(rv)` 이면 불일치 → 행 탈락 (:85-86).
- **명제 P3-3 (dim_vals 정확매칭·와일드카드 없음)**: 단가행 `dim_vals`(공정 상세 파라미터,
  예 `{"개수":1}`)의 키들은 selections와 **반드시 일치**해야 한다. dim_vals에는 와일드카드 없음
  (:87-89). → 라이브 실측: `COMP_PP_VARTEXT_1EA`가 `{"개수":1}` 단가행 보유 → 가변텍스트
  개수 선택값이 dim_vals와 정확히 맞아야 매칭.

> **★검증 가능 명제 (데이터 결함 탐지용) P3-DEF**:
> 구성요소의 `use_dims`에 선언된 비수량 차원이 그 구성요소의 단가행에서 **전부 NULL**이면,
> 판별차원이 없어 항상 매칭된다(`_row_matches`가 모든 행 통과). 이때 `_match_entry`는
> `note="판별차원 없음 — 선택과 무관하게 항상 매칭(opt_cd 등 미적재)"`를 세팅한다 (:412-415).
> → 이 경고가 뜨는 구성요소는 "옵션 선택과 무관하게 무조건 합산"되는 데이터 갭이다.

### 3.2 구간(티어) 차원 — `match_component` (:118-174)

방향이 둘로 갈린다 (:41-46):

- **min_qty (수량)**: '이상' 하한. 주문수량 **이하**의 **최대** 임계 선택(높은 구간). NULL=0 (:99, :157-162).
- **siz_width / siz_height (mm)**: '이하' 상한. 주문값을 담는 **가장 작은** 구간 = 주문값
  **이상** 임계 중 **최소** (:149-155). NULL=∞(catch-all, :101 upper면 Infinity).

- **명제 P3-4 (사이즈 off-grid → ceiling)**: 주문 사이즈가 격자 어떤 임계도 안 맞으면 그 값보다
  큰 다음 구간 임계를 쓴다(min(eligible), eligible=t≥cmp_val, :150-155). 격자에 정확값이
  없어도 ceiling 구간으로 자동 흡수. → 라이브 현수막 실측: siz_width 임계 900/1000/1400…
  → 주문 1300mm는 1400 구간 단가(10,080) 적용.
- **명제 P3-5 (사이즈 상한 초과 = ERR_ABOVE_MAX)**: 주문값이 최대 임계도 초과(eligible 비었음)면
  `ERR_ABOVE_MAX` 반환(:151-154). 다음 구간 미정의 → 합산 제외(:423-424 경고).
- **명제 P3-6 (수량 최소구간 미달 = ERR_BELOW_MIN)**: 주문수량 < 최소 min_qty 임계(eligible
  비었음)면 `ERR_BELOW_MIN` 반환(:158-161). 계산불가 → 합산 제외(:421-422 경고).
- **명제 P3-7 (희소 그리드 갭)**: 티어 조합은 골랐는데 그 조합 행이 없으면(:163-165 tier_rows
  빈 경우) error=None + reason="no_tier_row" → 매칭 없음으로 처리(0원, 오류 아님).

### 3.3 동시매칭 = 데이터 오류 (:132-138)

- **명제 P3-8 (ERR_AMBIGUOUS)**: 같은 selections에 **비수량 차원조합(`_combo_key`, :93-95)이
  2개 이상** 매칭되면 흡수하지 않고 `ERR_AMBIGUOUS` 오류 (:136-138). "최구체 우선" 없음.
  공통가 NULL행 + 전용가 행 공존도 여기 걸림(NULL과 값은 다른 combo_key). → 합산 제외(:417-418).
- **명제 P3-9 (ERR_DUPLICATE)**: 동일 (조합·구간) 내 같은 최신 `apply_ymd` 행이 2개 이상이면
  `ERR_DUPLICATE` (:170-173). → 합산 제외(:419-420).

> **검증 함의**: 뷰어 `price_dup_check`(price_views.py:767)가 이 두 오류의 사전 진단 도구.
> NULL을 동일 취급해 (apply_ymd+차원조합) 중복행을 찾음. 엔진의 ERR_AMBIGUOUS/DUPLICATE와 동치.

---

## 4. 단가형 / 합가형 환산 — `component_subtotal` (:177-192)

```python
PRC_TYPE_UNIT  = "PRICE_TYPE.01"   # 단가형 = 장당가         # pricing.py:48
PRC_TYPE_TOTAL = "PRICE_TYPE.02"   # 합가형 = 구간 총액       # pricing.py:49
```

- **명제 P4-1 (단가형)**: `unit_price` = 장당가 → `subtotal = unit_price × qty`,
  `per_item = unit_price` (:191-192). prc_typ가 NULL/미지정이면 단가형 기본 (:402, :185 else).
- **명제 P4-2 (합가형)**: `unit_price` = 해당 **구간 총액** → `per_item = unit_price ÷ tier_min_qty`,
  `subtotal = per_item × qty` (:185-190). 예(CONTEXT :18): 100개 구간=20,000 → 200원/장 × 150 = 30,000.
- **★명제 P4-3 (합가형 min_qty 필수 — 위험지점)**: 합가형인데 `tier_min_qty`가 0/NULL이면
  `ValueError("합가형 단가행에 수량구간(min_qty)이 없어 장당가 환산 불가")` 발생 (:187-188).
  `_match_entry`가 잡아 `calc_error` 세팅 + 경고(:432-433). strict면 fatal(:340-341).
  - 라이브 실측: 합가형 3건 = `COMP_ACRYL_CLEAR3T`, `COMP_STK_PACK`, `COMP_STK_TATTOO`.
    `COMP_ACRYL_CLEAR3T`는 165행 **전부 min_qty=1**(÷1, 골든 불변) → 현재 안전.
  - **검증 함의**: 합가형 구성요소의 단가행에 min_qty가 NULL인 행이 1개라도 있고 그 행이
    티어로 선택되면 견적 자체가 ValueError로 깨진다. → P-게이트 필수 점검 항목.

---

## 5. 시계열 (apply_ymd)

- **명제 P5-1 (구성요소 단가행)**: 후보는 `apply_ymd ≤ as_of`로 1차 필터(:127-128). 같은
  (조합·구간) 내 최신 apply_ymd 1행 선택(:169-171). 동일 최신 2행 = ERR_DUPLICATE(P3-9).
- **명제 P5-2 (소스 단가/공식/할인 연결)**: `_latest_ymd`로 as_of 이하 최신(:232-235).
  공식 바인딩은 `apply_bgn_ymd`(:320-322), 수량할인 연결은 `apply_bgn_ymd`(:482-484).

---

## 6. 할인 — 순차 곱 (:356-368)

CONTEXT(:37): 수량구간 할인 → 등급 할인, 직전 결과 기준 순차 곱. 단, `ok`일 때만 적용(:359).

```python
DSC_TYPE_RATE = "DSC_TYPE.01"   # 정률   # pricing.py:50
DSC_TYPE_AMT  = "DSC_TYPE.02"   # 정액   # pricing.py:51
```

- **명제 P6-1 (수량구간 할인)**: `_quantity_discount`(:478-505). 상품→`t_prd_product_discount_tables`
  최신 연결→`t_dsc_discount_tables`(유형)→`t_dsc_discount_details`. 적용행 = `pick_discount_detail`
  (min_qty ≤ qty ≤ max_qty(또는 max NULL), 최신, :215-226).
- **명제 P6-2 (등급 할인)**: `_grade_discount`(:508-537). `grade_cd` 지정 시만. 주카테고리
  (`main_cat_yn='Y'`, 없으면 임의 첫 카테고리, :513-518)→`t_dsc_grade_discount_rates`(cat_cd+grade_cd).
  - 라이브 실측(Phase0): `t_dsc_grade_discount_rates`=0행 → 등급할인 미등록 경고만(:526-527),
    실제 할인 0. **검증 함의**: 등급할인은 코드·로직만 존재, 데이터 미적재.
- **명제 P6-3 (할인 계산)**: `apply_discount`(:195-212). 정률 `amount×(1−rate/100)`,
  정액 `amount−amt`. 음수는 0으로 막음(:210-211). rate/amt가 None이면 할인 0(:204,:207).
- **명제 P6-4 (할인 가드)**: `amount ≤ 0`이면 할인 스킵(:480, :511). 0원 베이스에 할인 안 탐.

---

## 7. 모드 — lenient / strict (:269, :331-354)

| 상황 | lenient | strict | 근거 |
|------|---------|--------|------|
| 가격 소스 부재(NONE) | 0원 + 경고, `ok=True` 유지 | error, `ok=False` | :331-333 |
| 공식 매칭 0건 | 0원 + 경고 | error | :349-352 |
| ERR_AMBIGUOUS/DUPLICATE/BELOW_MIN | 경고, 합산 제외 | error(fatal, :340-344) | :340-344, :417-422 |
| calc_error(합가형 ValueError) | 경고, 합산 제외 | error(fatal) | :340-341, :432-433 |
| ERR_ABOVE_MAX | 경고, 합산 제외 | 경고만(fatal 목록에 없음) | :340, :423-424 |

- **명제 P7-1 (ok 판정)**: `ok = not (strict and errors)` (:354). lenient는 거의 항상 ok.
- **명제 P7-2 (lenient 목적)**: 데이터 구멍 발견용 — 0원 스킵으로 어디가 비었는지 경고로 노출.
  시뮬레이터 기본 모드. strict = 실서비스(위젯/주문 재검증).
- **명제 P7-3 (ERR_ABOVE_MAX는 strict에서도 비치명)**: fatal 목록(:340)에 ERR_ABOVE_MAX 없음
  → strict여도 ok=True 가능, 그 구성요소만 0원 제외. (BELOW_MIN과 비대칭 — 의도된 차이.)

---

## 8. 다중공정 / what-if / 추가상품

- **명제 P8-1 (proc_sels 다중평가)**: 공정 차원(`proc_cd` in use_dims) 구성요소는 `proc_sels`의
  각 공정마다 개별 평가·합산 (:462-471). 공정별 detail은 selections에 병합돼 dim_vals 충돌 없음
  (:466-468). 무관 공정의 no-match 항목은 표시 생략(:470).
- **명제 P8-2 (only_comps what-if)**: 시뮬레이터 전용. comp_cd가 only에 없으면 매칭됐어도
  `included=False` + note "수동 제외" (:427-428). 합계에서 빠짐. 기본 None=전 구성요소 합산.
- **명제 P8-3 (추가상품)**: 엔진 본체 밖. `price_simulate`(price_views.py:1300-1327)가 각
  addon을 `evaluate_price({"tmpl_cd":..}, {}, aq, ...)`로 개별 평가해 grand_total에 합산.

---

## 9. 3 파일럿 상품군이 엔진을 타는 경로 (라이브 실측 grounded)

| 상품군 | 상품(prd_cd) | 공식(frm_cd) | 구조 | 핵심 차원·환산 |
|--------|-------------|-------------|------|----------------|
| **엽서** | PRD_000017 코팅엽서 | PRF_DGP_A | **합산형** (17 comp) | proc_grp별 공정 단가형(min_qty 구간) + 용지비(siz_cd+mat_cd) + 코팅비(siz_cd+coat_side_cnt). dim_vals(공정 상세 `{"개수":N}`) 정확매칭 |
| **현수막** | PRD_000138 일반현수막 | PRF_POSTER_BANNER_N | **면적매트릭스** | 본체 COMP_POSTER_BANNER_NORMAL use_dims=`[siz_width,siz_height]` '이하'상한 ceiling(P3-4) + 공정 add-on(오시·귀돌이·가변·미싱) 단가형 |
| **아크릴** | PRD_000146 아크릴키링 | PRF_CLR_ACRYL | **면적+두께(합가형)** | 단일 comp COMP_ACRYL_CLEAR3T use_dims=`[siz_width,siz_height,mat_cd]`, **PRICE_TYPE.02 합가형**(P4-2/P4-3). mat_cd=두께축(정확매칭). min_qty=1 전행 → ÷1 안전 |

- **엽서 경로**: source=FORMULA → `_evaluate_formula(PRF_DGP_A)` → 17개 구성요소 disp_seq순.
  손님이 무광 코팅 선택 → COMP_COAT_MATTE만 매칭, COMP_COAT_GLOSSY는 no-match 자연 제외(P2-2).
  공정(오시/미싱 등)은 proc_grp로 묶여 proc_sels 다중평가(P8-1).
- **현수막 경로**: 본체 1개(면적 ceiling) + 선택 공정 add-on. siz_width/height 선택값이
  selections에 들어와 '이하' 상한 매칭. off-grid면 ceiling(P3-4), 최대초과면 ERR_ABOVE_MAX(P3-5).
- **아크릴 경로**: 단일 합가형 comp. (siz_width,siz_height,mat_cd) 정확+티어 혼합 매칭 →
  구간총액 ÷ min_qty(=1) × qty. **위험**: 만약 어느 두께(mat_cd) 행에 min_qty=NULL 유입되면
  P4-3 ValueError로 그 두께 견적 전체가 깨진다.

---

## 10. 검증자(P1~P7)가 즉시 쓸 수 있는 결정적 규칙 요약

| ID | 검증 가능 명제 (TRUE/FALSE 판정 대상) | 엔진 근거 |
|----|-----------------------------------|-----------|
| C1 | 직접단가(순위1·2) 0행이면 전 상품 FORMULA로만 평가된다 | P1-1~3, 라이브 0행 |
| C2 | 구성요소 use_dims 비수량 차원이 단가행 전부 NULL → 항상 매칭(판별불가 데이터 갭) | P3-DEF |
| C3 | 합가형(PRICE_TYPE.02) 단가행 중 티어선택될 행의 min_qty가 NULL/0이면 견적 ValueError | P4-3 |
| C4 | 한 selections에 비수량 차원조합 2개 매칭(NULL행+값행 공존 포함) = ERR_AMBIGUOUS | P3-8 |
| C5 | 사이즈 주문값 > 최대 임계 = ERR_ABOVE_MAX(strict여도 비치명, 0원 제외) | P3-5, P7-3 |
| C6 | 수량 < 최소 min_qty 임계 = ERR_BELOW_MIN(strict 치명) | P3-6 |
| C7 | frm_typ_cd·addtn_yn은 엔진이 참조하지 않음(공식=항상 구성요소 합산) | P2-1, P2-4 |
| C8 | apply_ymd > as_of 행은 절대 선택 안 됨(미래 단가 미발화) | P5-1, P5-2 |
| C9 | grade_discount_rates 0행이면 등급할인은 경고만, 실 할인 0 | P6-2, 라이브 0행 |

---

## 부록 A. UNVERIFIED / 미지 (출처 표기)

- `frm_typ_cd`는 라이브 `t_prc_price_formulas`에 컬럼 존재하나 **엔진 미참조**(메모리
  [[dbmap-price-formula-audit-round17]]와 일치). 본 계약은 엔진 기준이라 frm_typ 무관으로 명세 — 결함 아님.
- 등급할인 주카테고리 폴백(:516-518, main_cat_yn 없을 때 첫 행)은 라이브 등급데이터 0이라
  실발화 미관측. 로직만 검증, 동작 결과 UNVERIFIED(데이터 부재).
