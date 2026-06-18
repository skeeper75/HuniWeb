# constraint-mechanism-gap — 상품↔구성요소 유효성 제약 장치 존재/부재 진단 (SOT 4)

**진단가:** hped-code-schema-auditor · **일자:** 2026-06-18
**과제(사용자 SOT):** "가격구성요소를 공식에 묶을 때, 어떤 상품에 적용하느냐에 따라 그 구성요소가 실제 상품에서 사용 가능한지 제약을 만들었다면 나은데 고려 안 됨 → 잘못 묶일 수 있음. 이것이 D-1/2/3 이중합산·D-6 현수막별색의 근본."
**판정:** 코드·스키마·트리거·CHECK·FK 전수 조사. **진단까지만(교정 보류).**

---

## 결론 (한 줄)

**제약 장치 = 없음(부재).** 공식↔구성요소 배선(`t_prc_formula_components`)에도, 상품↔공식 바인딩(`t_prd_product_price_formulas`)에도 **"이 구성요소가 이 상품에서 유효한가"를 강제하는 게이트가 코드·DDL·트리거·CHECK 어디에도 존재하지 않는다.** 유일한 상품-스코프 무결성 트리거 `fn_chk_opt_item_ref`는 **CPQ option_items 레이어 전용**으로, 가격 공식 사슬에는 전혀 부착되지 않는다. → 사용자가 우려한 "잘못 묶임"은 **구조적으로 막을 장치가 없는 상태가 맞다.**

---

## 1. 배선 테이블 구조 — 상품 차원 자체가 없음

`t_prc_formula_components`(공식=구성요소 배선) 라이브 컬럼 전수(information_schema):
```
frm_cd · comp_cd · disp_seq · addtn_yn · reg_dt · upd_dt
```
- **prd_cd 컬럼 부재** — 배선은 (공식, 구성요소) 쌍일 뿐, **상품 개념이 테이블에 존재하지 않는다**(models.py:205-217 동형).
- FK 2개뿐(sql/02_foreign_keys.sql:627-651): `frm_cd→t_prc_price_formulas`, `comp_cd→t_prc_price_components`. **상품 참조 FK 0개**.
- → 설계 자체가 "공식은 상품 독립(product-agnostic)"이다. 상품은 `t_prd_product_price_formulas(prd_cd, frm_cd)`로 공식에 **나중에** 붙는다.

상품↔공식 바인딩 `t_prd_product_price_formulas` FK(sql/02:601-625): `prd_cd→products`, `frm_cd→formulas`. **공식이 가진 구성요소가 그 상품에 유효한지 검사하는 FK·CHECK 없음.**

---

## 2. 코드 레벨 게이트 — 0건

### 배선 추가 경로 (Django admin 인라인)
공식↔구성요소 배선은 price_views.py에 추가 엔드포인트가 **없다**(grep: formula_components save 0건). 오직 **Django admin 가격공식 편집화면 인라인**으로만 편집:
- `TPrcFormulaComponentsInline`(admin.py:938-956) — `form = _FormulaComponentsInlineForm`(931-935).
- **`_FormulaComponentsInlineForm`에 `clean()` 메서드 없음**(admin.py:931-935 = Meta만, exclude=reg_dt/upd_dt). → 구성요소를 공식에 묶을 때 **상품 유효성 검증 코드 0줄**.
- 대조: 같은 파일의 `ProductCategoriesInform._ProductCategoryInlineForm`은 `clean()` 보유(974-979), `CodeAdminForm`도 `clean()`(348) 보유. → 검증 패턴은 쓸 줄 알지만 **formula-component 배선에는 의도적으로/무관심하게 미적용**.

### 상품↔공식 바인딩 경로 (price_views.py:829-841)
```
if not M.TPrcPriceFormulas.objects.filter(pk=frm).exists():
    return fail("가격공식을 선택하세요.")
M.TPrdProductPriceFormulas.objects.update_or_create(prd_cd_id=prd_cd, apply_bgn_ymd=ymd, frm_cd_id=frm)
```
- 검증 = **공식 존재 여부만**(835). 그 공식의 구성요소들이 이 상품(prd_cd)의 자재·공정·사이즈 차원과 호환되는지는 **전혀 안 봄**. → 임의 공식을 임의 상품에 붙일 수 있다.

### 엔진 (pricing.py)
- `_evaluate_formula`(pricing.py:444-475)는 `frm_cd`로 구성요소를 끌어와 **선택값↔차원 자동매칭**으로 합산. 상품군 경계 검증 0. 매칭되면 합산, 안 되면 와일드카드(NULL)거나 제외 — "이 comp가 이 상품에 속하나"는 **묻지 않는다**.
- 와일드카드(NULL 차원, pricing.py:83-84) + 판별차원 없는 comp(pricing.py:414-415 "선택과 무관하게 항상 매칭")가 결합하면 **상품과 무관한 comp가 무조건 합산** — 이중합산(D-1/2/3)의 정확한 코드 메커니즘.

---

## 3. DB 레벨 게이트 — 0건 (CHECK·트리거)

| 대상 | CHECK 제약 | 트리거 | 결과 |
|------|-----------|--------|------|
| t_prc_formula_components | `use_yn/del_yn IN(Y,N)` 류 도메인 CHECK만(sql/10:63-153 = 타 테이블) | `fn_upd_dt` 감사 트리거뿐(sql/03 동형) | 상품-스코프 게이트 0 |
| t_prd_product_price_formulas | 없음 | 없음 | 0 |
| t_prc_price_components | 없음(스코프) | 감사만 | 0 |

- 가격 6엔티티 부착 트리거 = `fn_upd_dt`(updated_at 감사)뿐. **유효성 트리거 0.**

---

## 4. fn_chk_opt_item_ref — 존재하나 "다른 레이어"를 지킴

사용자가 "기존 트리거가 부분이라도 막는지" 물은 트리거. **결론: 가격 공식 사슬은 전혀 못 막는다.**

- 정의: sql/10_phase7_ddl.sql:189-233. 부착: `BEFORE INSERT/UPDATE ON t_prd_product_option_items`(236) — **CPQ option_items 전용**.
- 검사 내용: option_item의 `ref_dim_cd`(OPT_REF_DIM.01~07)별로, 참조키가 **그 상품(NEW.prd_cd)에 실제 등록된** 사이즈/판형/자재/공정/묶음수/도수/셋트인지 EXISTS 검증(194-227). 예: 자재 옵션은 `t_prd_product_materials WHERE prd_cd=NEW.prd_cd AND mat_cd=...` 존재해야 통과(204-206).
- → **이것이야말로 사용자가 원하는 "상품-스코프 유효성 게이트"의 모범**이다. 단 적용 대상이 **CPQ 옵션 레이어**일 뿐. 같은 발상이 **가격 공식↔구성요소 배선에는 복제되지 않았다.**
- 즉 후니는 "상품-스코프 참조 무결성"이라는 장치를 **알고 만들었고 한 곳(옵션)엔 적용했으나, 가격 공식 배선에는 미적용** — D-1/2/3·D-6의 구조적 공백.

---

## 5. 부재가 "잘못 묶임"을 만드는 메커니즘 (라이브 실증)

구성요소는 **여러 공식에 광범위 공유**되고, 공식은 **여러 상품에 바인딩**되는데, 둘 사이를 거르는 게이트가 없다 → 한 상품에 무관한 comp가 들어가도 탐지 불가.

라이브 실측(읽기전용 SELECT):
| 구성요소 | 묶인 공식 수 | 도달 가능 상품 수 | 의미 |
|----------|-------------|------------------|------|
| COMP_PP_VARIMG_1EA (가변이미지) | 30 공식 | **38 상품** | 한 comp가 38개 상품 가격에 도달 |
| COMP_PRINT_SPOT_WHITE_S1 (별색) | 29 공식 | 多 | **D-6 현수막별색**과 직결 — 별색 comp가 별색 없는 상품에 묶일 위험 |
| COMP_PAPER (용지비) | 6 공식 | 19 상품 | 용지비 광역 공유 |

- comp_cd가 30 공식에 공유 + 각 공식이 여러 상품 바인딩 + 상품-스코프 게이트 0 = **"이 comp가 이 상품에 정말 필요한가"를 시스템이 절대 묻지 않음**. 운영자가 공식에 comp를 잘못 추가하거나, 잘못된 공식을 상품에 바인딩하면 **무성(silent)으로 합산에 포함** — 이중합산/오합산.
- 엔진의 와일드카드(NULL 차원)·"판별차원 없음 항상 매칭"(pricing.py:415)이 이 오묶임을 **차단이 아니라 증폭**(무관 comp일수록 차원 비어 와일드카드로 통과).

---

## 6. addtn_yn — 부재의 보강 증거 (G-4 정밀화)

- 라이브: `t_prc_formula_components.addtn_yn` = Y 299행 · **N 2행**(`PRF_CLR_ACRYL/COMP_ACRYL_CLEAR3T`, `PRF_COROTTO_ACRYL/COMP_ACRYL_COROTTO`) · NULL 0.
  → 직전 매트릭스의 "전부 Y"는 정정: **N이 2행 실재**. 운영자가 "이건 합산 말라(차감/제외)"는 의도를 DB에 표기한 흔적.
- 그러나 **pricing.py가 addtn_yn을 전혀 안 읽음**(grep 0건·_evaluate_formula values에 미포함:452). 엔진은 이 2행도 **그냥 합산**.
- 설계 원문(11-CONTEXT.md:23): "addtn_yn ... = 이번 엔진에서 무시. **의도 불확실 → 매칭 자동판정만 사용. 필요해지면 차후 재정의.**"
- **사실:** addtn_yn은 "구성요소를 합산할지 말지"의 **유일한 잠재 게이트**인데, 의도적으로 미구현(deferred). 만약 활성화됐다면 N=2행은 합산 제외됐을 것. → "잘못 묶여도 끄는" 부분 안전판조차 코드에서 비활성. **부재의 직접 증거.**

---

## 7. file:line / 재현 근거 색인

| 주장 | 출처 |
|------|------|
| formula_components 컬럼에 prd_cd 없음 | 라이브 information_schema (frm_cd·comp_cd·disp_seq·addtn_yn·reg_dt·upd_dt) · models.py:205-217 |
| FK 2개·상품참조 FK 0 | sql/02_foreign_keys.sql:627-651 |
| product_price_formulas 검증=공식존재만 | price_views.py:835 |
| 배선 인라인 폼 clean() 없음 | admin.py:931-935, 938-956 |
| 비교: 카테고리/코드 인라인은 clean() 보유 | admin.py:348, 974-979 |
| 엔진 상품-스코프 검증 0 | pricing.py:444-475 |
| 판별차원 없음 항상 매칭 | pricing.py:414-415 |
| 가격 6엔티티 트리거=감사만 | sql/03_triggers.sql:99-129 |
| fn_chk_opt_item_ref = option_items 전용 | sql/10_phase7_ddl.sql:189-236 |
| comp 광역 공유 (30 공식·38 상품) | 라이브 join count (§5) |
| addtn_yn N 2행·엔진 미사용·설계 deferred | 라이브 count · pricing.py:452 · 11-CONTEXT.md:23 |

---

## 8. mechanism-researcher 협업 노트
- "상품-구성요소 유효성 게이트 부재"는 D-1/2/3 이중합산·D-6 현수막별색의 **구조적 근본 원인**으로 확정 가능(추정 아님 — 코드/스키마 부재 실측).
- 후니가 같은 장치(`fn_chk_opt_item_ref`)를 CPQ 옵션엔 구현했다는 사실 = "할 줄 알면서 가격 배선엔 안 한" 것 → 향후 장치 설계 시 fn_chk_opt_item_ref 패턴을 formula_components/product_price_formulas로 확장하는 처방이 자연스러운 토대(설계 트랙 몫·여기선 진단까지).
