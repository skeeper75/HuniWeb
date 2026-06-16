# vessel-template-price (#4 템플릿/SKU 가격 facet) — WEAK 🟡 → 그릇 설계

> rpm-vessel-designer. RP `Template`(SKU) 번들 추가가격 보관처. gap-matrix #4 WEAK(templates 구조 PASS·가격 facet 결손).
> 권위 = 라이브 read-only 실측(2026-06-17) + `dbmap-acrylic-price-chain-link`(완제SKU=항상 가격사슬). design ≠ apply.

## 0. 한 줄 평결
**그릇 신설 보류 권고 — 후니 가격 철학상 "가격은 항상 component 사슬"이라 templates.price 컬럼은 철학 충돌.** RP는 SKU에 add_price 직결이나, 후니는 `dbmap-acrylic-price-chain-link` 확정대로 완제 SKU도 component_prices 합산(addtn_yn=Y). → **templates.price 컬럼 mint = 후니 가격모델과 불일치**. open decision으로 둠(가격 트랙 결정 우선).

## 1. search-before-mint (라이브 실측 + dbmap 권위)
| 후보 | 근거 | 무손실/정합? |
|---|---|:--:|
| `t_prd_templates.price` 컬럼(설계 원안) | cpq-schema §4 🟡9 "미구현". RP SKU add_price 직역 | ❌ **철학 충돌** — 후니=가격은 t_prc_* 사슬(`option_items`에도 add_price 컬럼 부재가 의도적) |
| 완제 SKU를 component_prices로 | `dbmap-acrylic-price-chain-link`: 본체=component 사슬·후가공=component 합산(addtn_yn=Y)·완제SKU=addons/templates/template_prices | ✅ 후니 정합 — **신규 그릇은 가격 트랙(component) 측** |
| `template_selections.qty` + 사슬 | 라이브 template_selections(14행)는 polymorphic+opt_cd+sel_val+qty 보유 | ✅ 구성은 표현, 가격은 사슬 |

**결론:** templates에 가격 컬럼을 다는 것은 후니가 일관되게 거부해온 패턴(option_items add_price 부재가 선례). 완제 SKU 번들가는 **가격 사슬(component_prices, prc_typ=합가)** 로 표현하는 것이 정답. → **본 하네스에서 templates.price 그릇 mint 안 함.**

## 2. 그릇 설계
- **신규 그릇 0(권고).** 번들 추가가격은 dbmap 가격 트랙(`t_prc_component_prices` 합가행 + 완제 SKU 바인딩)으로. 만약 후니가 SKU 직결 가격을 *반드시* 원하면 → 그건 가격모델 변경(가격 트랙·인간 결정), vessel 단독 판정 영역 아님.

## 3. 영향
- 그릇 0 → 영향 0. 번들가 표현은 가격 트랙 데이터.

## 4. WEAK → 판정
- #4 템플릿 WEAK → **구조는 PASS, 가격 facet은 "가격 트랙으로 위임"(DEFER)**. vessel 신설 아님.

## 5. open decision
1. **완제 SKU 번들가 = component 사슬(후니 정합) vs templates.price 컬럼(RP 직역):** 권고 = 사슬. 후니 가격모델 변경 결정 시만 컬럼 재평가(가격 트랙).
2. 실 결정 = 인간 승인(가격 = 돈 크리티컬).
