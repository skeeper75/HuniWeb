# price-source-intent — 직접단가(t_prd_product_prices) vs 가격공식(formula) 개발자 의도 진단 (SOT 5)

**진단가:** hped-code-schema-auditor · **일자:** 2026-06-18
**과제:** 가격뷰어 "가격소스 추가(직접단가/가격공식)"의 정확한 개발자 의도를 코드로 규명.
**방법:** price_views.py(UI·저장) + pricing.py(우선순위) + 설계 CONTEXT(11-CONTEXT.md) 3-way. **의도 추론은 [가설]로 명시(코드 실측과 분리).**

---

## 0. 사실 헤드라인 (코드·라이브 실측)

| 항목 | 실측값 | 출처 |
|------|--------|------|
| t_prd_product_prices (직접단가) | **0행** | 라이브 `select count(*)` |
| t_prd_template_prices (템플릿단가) | **0행** | 라이브 |
| t_prd_product_price_formulas (상품↔공식 바인딩) | **76행** | 라이브 |
| 가격소스 우선순위 (코드) | 템플릿단가 → 상품 직접단가 → 상품공식 → NONE | pricing.py:13, 285-327 |
| 우선순위 (설계 원문) | "직접단가 있으면 공식보다 우선(오버라이드)" | 11-CONTEXT.md:43 |

→ **코드는 3소스 전부 구현, 라이브는 FORMULA 단일 경로만 데이터 보유.** 직접단가·템플릿단가는 "코드는 살아있고 데이터는 0"인 잠재 경로.

---

## 1. 가격소스 추가 UI/저장 로직 — 어느 화면에서 직접단가 vs 공식을 선택하나

가격소스는 **상품 상세(price_product_detail) 화면의 ① 가격 소스 섹션**에서 추가/삭제한다. 저장은 단일 엔드포인트 `price_source_save(prd_cd)`가 `kind` 분기로 처리.

- **화면 흐름 주석** (price_views.py:3-6): `① 가격 소스(직접단가/공식, 데이터 기반 '현재 적용') → ② 공식 구성요소 → ③ 단가표 → 템플릿(SKU) 직접단가 → ④ 할인 → ⑤ 시뮬레이션`.
- **현재소스 판정** (price_views.py:256-258):
  ```
  cur_price = _latest(prices)          # t_prd_product_prices 최신
  cur_frm   = _latest(frms, "apply_bgn_ymd")  # product_price_formulas 최신
  current_source = "PRICE" if cur_price else ("FORMULA" if cur_frm else None)
  ```
  → 화면 표시상으로도 **직접단가(PRICE)가 공식(FORMULA)보다 우선** 판정(엔진 우선순위와 동형).
- **저장 분기** (price_views.py:797-841):
  - `kind="price"` → `TPrdProductPrices.update_or_create(prd_cd, apply_ymd, unit_price)` (816-828) = **직접단가 행 추가** (적용일+단가만, 차원 없음).
  - `kind="formula"` → `TPrdProductPriceFormulas.update_or_create(prd_cd, apply_bgn_ymd, frm_cd)` (829-841) = **공식 바인딩 행 추가** (공식 선택, 존재검증 `TPrcPriceFormulas.filter(pk=frm).exists()` 835만).
  - `kind="tmpl_price"` (855~) = **템플릿 직접단가** — 상품 가격소스와 **별개**(주석 285 "템플릿 전용").

**사실:** 직접단가 = `(적용일, 단가)` 한 쌍의 평면 행(차원·수량 무관). 공식 = `(적용시작일, frm_cd)` 바인딩. 두 소스는 같은 화면 같은 엔드포인트에서 자유롭게 공존 추가 가능 — **코드는 한 상품에 둘 다 등록되는 것을 막지 않는다**(그래서 우선순위 규칙이 필요).

---

## 2. 우선순위 — 언제 직접단가를 쓰도록 의도됐나

### 코드 실측 (pricing.py:285-336)
```
if tmpl_cd:                                  # 1순위: 템플릿단가
    if (template_price 존재): source=TEMPLATE_PRICE
    else: prd_cd = base_prd_cd               # 없으면 기준상품으로 폴백
if base_amount is None and prd_cd:
    pp = _latest_ymd(product_prices)         # 2순위: 직접단가
    if pp and pp.unit_price is not None:
        source = "PRODUCT_PRICE"; base_amount = unit_price × qty   # ★공식 평가 SKIP
    else:
        frm = _latest_ymd(product_price_formulas)  # 3순위: 공식
        if frm: source="FORMULA"; _evaluate_formula(...)
```

직접단가가 존재하면 **else 분기로 공식을 아예 평가하지 않음**(312-327). 직접단가 = `unit_price × qty` 단순곱(선택값·차원 전부 무시).

### 설계 원문 (11-CONTEXT.md:43)
> "가격 우선순위(승계): 템플릿단가 → 상품단가 → 상품공식 → 없음. **직접단가 있으면 공식보다 우선(오버라이드).**"

pricing.py:13-14 docstring도 동일: "상품은 직접단가가 공식보다 우선(오버라이드)."

**사실:** 우선순위는 설계 확정 사항(추론 아님). 직접단가는 공식을 **오버라이드(덮어쓰기)** 하는 장치로 설계됨. 코드·설계·화면판정 3원 정합 ✅.

---

## 3. 개발자 의도 [가설] — 직접단가는 무엇을 위해 만들었나

코드·주석·설계가 명시한 "오버라이드" 단어에 근거한 가설(확정 아님):

### [가설 A·확신도 높음] 공식으로 표현 못 하는 "완제품 고정가" 오버라이드용
- 직접단가 행 구조 = `(적용일, 단가)`뿐 — **선택 차원이 전혀 없는 단일 스칼라 가격**(price_views.py:825-826). 즉 "이 상품은 옵션·수량 차원 분해 없이 그냥 N원"인 상품을 위한 그릇.
- 공식 사슬(component_prices 매칭→합산)이 과한 단순 완제품(예: 단일 SKU·고정가 기성품)에서, 공식을 짜는 대신 단가 하나만 박는 **간편 경로**.
- 설계 line 43 "오버라이드"·pricing.py:14 "오버라이드"가 이 해석을 직접 지지.
- 근거: component_subtotal(pricing.py:177)이 차원·구간 환산을 하는 반면 직접단가는 `Decimal(unit_price) × qty`(pricing.py:317) 단순곱뿐.

### [가설 B·보조] 공식 결함 시 긴급 수동 단가 덮어쓰기(운영 안전판)
- 한 상품에 공식 바인딩이 이미 있어도, 직접단가를 추가하면 **공식보다 우선**하므로(코드 312-318 else-skip) — 공식이 잘못 계산될 때 운영자가 직접단가로 임시 덮을 수 있는 안전판으로도 기능.
- 화면이 둘 다 등록 가능하게 열려있고(§1), current_source가 PRICE 우선이라(price_views.py:258) 이 "임시 오버라이드" 사용을 구조가 허용.

### [가설 C·약함] 템플릿 폴백 체인의 중간 노드
- 템플릿단가 없을 때 `prd_cd = base_prd_cd`로 폴백(pricing.py:300-301) → 그 기준상품의 직접단가가 있으면 그것을 SKU 가격으로 승계. 템플릿(SKU)이 기준상품 직접단가를 물려받는 경로.

---

## 4. 미사용 이유 [가설] — 직접단가 0행인데 코드는 왜 있나

| 관찰 | 사실 | [가설] |
|------|------|--------|
| 직접단가 0행, 공식 바인딩 76행 | 라이브 실측 | 후니 전 상품이 **공식기반**으로 적재됨(CLAUDE.md "직접단가 0=전 상품 공식기반"과 정합) |
| 코드 경로는 완비(312-318) | pricing.py | "쓰려고 만들었으나 현 데이터셋에서 미발화" — **결함 아닌 미적재** |
| 설계 line 43이 명시 우선순위 | 11-CONTEXT | 직접단가는 **미래 완제품/오버라이드 대비 의도적 예비 경로**([가설 A+B]) — YAGNI 보류 아님(코드 존재) |
| 템플릿단가도 0행 | 라이브 | 11-CONTEXT:68 "템플릿 가격공식 테이블 (YAGNI 보류 유지)"·신설 그릇만, 미적재 |

**종합 [가설]:** 직접단가는 *"특정 케이스(차원 없는 완제품 고정가·공식 오버라이드) 대비"* 로 설계·구현된 정식 경로다. "쓰려다 버린 죽은 코드"가 아니라 **현 적재 단계(전 상품 공식기반)에서 아직 데이터가 안 들어온 잠재 경로**. 향후 완제품 SKU·고정가 기성품 적재 시 활성화될 그릇.

**검증 영향:** 가격 검증·시뮬레이션은 라이브 데이터가 있는 **FORMULA + 수량구간할인** 경로에 집중해야 유효. 직접단가/템플릿단가 분기는 "데이터 레벨 dead"라 현 시점 가격 테스트 대상 아님(향후 적재 시 재검).

---

## 5. file:line 근거 색인

| 주장 | 출처 |
|------|------|
| 우선순위 템플릿→직접→공식 | pricing.py:13-14, 285-327 |
| 직접단가 발화 = pp.unit_price not None → 공식 skip | pricing.py:312-318 |
| 직접단가 = unit_price × qty 단순곱 | pricing.py:317 |
| 공식 평가는 직접단가 없을 때만 | pricing.py:319-327 (else 분기) |
| 화면 현재소스 PRICE 우선 판정 | price_views.py:256-258 |
| 가격소스 추가 UI/저장 분기 | price_views.py:797-841 |
| 직접단가 행 = (적용일,단가)만 | price_views.py:816-828 |
| 공식 바인딩 = (적용시작일,frm_cd) | price_views.py:829-841 |
| 설계 원문 "직접단가 오버라이드" | 11-CONTEXT.md:43 |
| 템플릿 가격공식 YAGNI 보류 | 11-CONTEXT.md:68 |
| 라이브 직접단가/템플릿단가 0행 | 라이브 psql count |

---

## 6. mechanism-researcher 협업 노트
- 직접단가 = "차원 없는 단일 스칼라 가격 오버라이드"의 코드 사실 → 장치가 원리상 "완제품 고정가/긴급오버라이드"임을 확신도 근거로 사용 가능.
- 우선순위 3단은 설계 LOCKED(line 43) — 추정 아닌 확정. mechanism 정의에 그대로 인용 가능.
