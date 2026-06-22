# 세트/완제품·add-on 가격 패턴 — 디자인캘린더(가격포함) (11번째·최종 종단)

> `hpe-benchmark-analyst` 디자인캘린더 종단 3/3. 디자인캘린더가 **반제품 부품합산(책자 BOOKLET 패턴)** 으로 가는지 **inline 정찰가 완제품 + add-on 가산**으로 가는지를 경쟁사 증거로 판정해 후니 세트상품 설계 입력으로 제공.
> **중복 금지·재사용**: 일반 캘린더 `set-pricing-patterns-calendar.md`(부품합산❌·본체단일+가공가산✅)는 **보존(재유도 0)**. 본 파일은 디자인캘린더 정찰가+add-on 차이만 보강.
> **흡수 vs 답습[HARD]**: 메커니즘만 흡수·naming/codes 유입 금지·권위 엑셀 최종.

## 출처
- `[red:design]` = RedPrinting edicus 완제 `tmpl_price`(`competitor-pricing-models-calendar.md` §2.3·디자인캘린더 동형).
- `[huni:dcal]` = `_workspace/huni-dbmap/24_master-extract-260610/design-calendar-l1.csv`(상품마스터·세트 컬럼 없음·정찰가+추가상품 확인).
- `[prior:set]` = `set-pricing-patterns-calendar.md`(일반 캘린더 세트 판정·재사용) · `set-pricing-patterns.md` P-1(다부품)/P-3(변형 SKU).

---

## 0. 디자인캘린더 세트 판정 한눈 — 부품합산 ❌ / 정찰가 완제품 + add-on 가산 ✅

★**핵심 판정**: 일반 캘린더 종단의 "부품합산 아님·본체단일+가공가산" 판정이 **그대로 성립**. 디자인캘린더는 한 단계 더 단순 — 본체가 **inline 정찰가 완제품**(가공/디자인이 정찰가에 baked)이고, 봉투/거치대만 add-on 가산.

| 패턴 | 책자(BOOKLET) | 디자인캘린더 | 근거 |
|------|---------------|--------------|------|
| 부품 분리(표지/내지 별 prd_cd) | ✅ `t_prd_product_sets` | ❌ **단일 prd_cd·세트 미분리** | `[huni:dcal]` 5상품 전부 단일 행·`[prior:set §0]` 캘린더 sets 0 |
| 페이지(장수) 처리 | 내지 단가×페이지수(별 부품) | **본체 정찰가에 baked**(30P/26P/12P/13P = 사양 고정값·옵션축 아님) | `[huni:dcal]` 페이지 컬럼=고정 사양 |
| 본체 가격 | 표지+내지+제본 Σ | **inline 정찰가 단일값**(탁상10400 등) | `[huni:dcal]` 가격 컬럼 |
| 제본/거치대 | 제본비 항/부품 | **정찰가에 baked**(삼각대/트윈링) + 외부 거치대만 add-on | `[huni:dcal]` |
| add-on | — | **캘린더봉투(2500/2400)·우드거치대(4000)** = 외부 부속물 가산 | `[huni:dcal]` |
| RedPrinting 엔진 | `book2025_price`(WGT 분리) | **`tmpl_price`**(edicus 완제 개당 정찰가·부품 분리 0) | `[red:design]` |

→ **디자인캘린더 = "inline 정찰가 완제품 + 외부 add-on 가산"** 이지 반제품 다부품 세트 아님. 후니 `t_prd_product_sets` 디자인캘린더 미사용이 **정합**.

---

## 1. RedPrinting 디자인 라인 세트 패턴 — 완제 단가·부품합산 아님 `[red:design]`

- **tmpl_price(edicus 완제·디자인 제공)**: MTRL_CD/부품 분리 **없음**·디자인(템플릿)+사양이 baked된 **개당 정찰가 1종**. 책자(book2025 표지/내지 WGT 분리)와 결정적으로 다름.
- starting-year/month 등 옵션은 가격 무영향(템플릿 baked·P-3 변형 SKU와도 다름·variant 가격분기 0).
- → RedPrinting도 디자인 제공 완제품을 **부품합산으로 안 푼다**(완제 정찰가). **후니 디자인캘린더 inline 정찰가와 동형.**

---

## 2. 후니 디자인캘린더 세트 설계 입력 (designer 공급) `[huni:dcal]`

### 2.1 세트 구조 = 불요 (본체 단일 prd·정찰가 완제품)
- 디자인캘린더 5상품(탁상/미니탁상/엽서/벽걸이/와이드벽걸이) **전부 단일 prd_cd·inline 정찰가**. 페이지(30P/26P/12P/13P)는 baked 사양값(옵션축도 별 내지 부품도 아님).
- → **`t_prd_product_sets` 디자인캘린더 미사용 유지**(부품 분리 금지·책자 패턴 오적용 금지).

### 2.2 가격 합성식 (정찰가 + add-on 가산)
```
디자인캘린더 가격 = 본체 inline 정찰가(고정가형 완제 SKU·use_dims=[siz_cd])
                  + 캘린더봉투 가산  (탁상형·사이즈별 2500/2400)  ← add-on
                  + 우드거치대 가산  (엽서캘린더·4000)            ← add-on
```
- **본체** = 고정가형 완제 SKU 정찰가(굿즈 GP-1·상품악세사리 inline 동형). 디지털 SUM 산식 아님(정찰가 룩업).
- **add-on** = 외부 부속물(봉투/거치대)만 가산. 삼각대/트윈링제본은 **본체 정찰가에 baked**(별 가산 없음).
- **세트 조합(t_prd_product_sets) 불요** — 본체 부품 분리 없음·이중계상 위험 없음.

### 2.3 ★봉투/거치대 add-on nuance
- **캘린더봉투**(탁상형) = 사이즈별 변형가(220×145 / 240×230=2500 / 150×310=2400) — **사이즈축 use_dims 충전 필수**(평탄화 시 오청구). 봉투=완제 부속물(addon)이지 제본 부품 아님.
- **우드거치대**(엽서캘린더 4000) = 부속물(addon·rpmeta PD addons·상품악세사리 정합). 일반 캘린더 §2.3 동일 nuance.
- → 둘 다 add-on comp 가산(`absorption-candidates-design-calendar.md` DC-2)·세트 분해 불요.

---

## 3. 한 줄 결론 (세트 각도)

디자인캘린더는 **반제품 다부품 세트(책자 BOOKLET P-1)가 아니라 "inline 정찰가 완제품(고정가형 완제 SKU) + 외부 add-on(봉투/거치대) 가산"** 이다. 일반 캘린더("본체단일+가공가산")보다 한 단계 더 단순 — 제본/삼각대/디자인이 전부 정찰가에 baked되고, 외부 부속물만 add-on. RedPrinting(`tmpl_price` edicus 완제 개당 정찰가)도 디자인 제공 완제품을 부품합산으로 풀지 않음 — **후니 권위(디자인캘린더 단일 prd·정찰가·`t_prd_product_sets` 미분리)와 동형**. 세트 그릇 신설/사용 **불요**. 페이지(장수)=baked 사양값(책자 내지 부품 오적용 금지). add-on 봉투=사이즈별 변형가 use_dims 충전·거치대=부속물 가산.
