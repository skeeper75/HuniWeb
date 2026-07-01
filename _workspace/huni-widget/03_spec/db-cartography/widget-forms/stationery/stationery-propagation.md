# stationery-propagation.md — 문구(C5 셋트조립-제본) 동형 전파 (경량)

> 파이프라인 ③' 컨버전 선행 · **경량 전파**(동형 판정+델타+대표+갭만·전체 재유도 금지·코드 0줄).
> **클래스 대표(동형 기준)** = C5 `../book/book-form-spec.md`(PRD_000069 무선책자·셋트 분해형·evaluate_set_price·면별 ProductSide·이중합산0).
> **외형 권위** = `docs/design/11가지상품옵션/product-stationery-option/Configurator.jsx`(181줄·사이즈·내지·종이·제본옵션[50장/100장 1권]·링컬러[블랙/그레이/화이트]·제작수량·구간할인 Slider·개별포장·★PDF+에디터 CTA).
> **데이터 권위** = 라이브 스냅샷(`_foundation/live-snapshot/latest/`, 2026-07-01) + §29 readiness scorecard.
> **가격 권위** = 서버 `pricing.py`(셋트=`evaluate_set_price`:844 / 단일=`evaluate_price`:394) 불투명 결과. PRICE=0=결함·이중합산0.
> **계약 목표** = 위젯 가시 계약 변경 0 — 면별=ProductSide·color-chip(링)·Slider=summary 흡수. 어댑터 흡수.
> **라이브 대표(셋트)** = **PRD_000097 떡메모지** (문구군 유일 라이브 셋트·t_prd_product_sets 부모·member 098 내지·bdl_qty 50/100=design 제본옵션 직대응·evaluate_set_price).
> **보조(단일·design 외형 최근접)** = PRD_000178 스프링수첩(L4·single evaluate_price·PRICE≠0).

---

## ① 동형 판정 (C5 book 대비) — ★중요 정정

**판정: △ 준동형이나 셋트 가격모델이 book과 다르다 + design 외형이 라이브 단일상품에 더 가까운 이중 갭. C5 셋트조립 클래스는 유지하되 "고정가-셋트(fixed-price set)" 하위변종으로 분리.**

> ★[정정·divergence 명시] 사용자 directive는 "stationery=C5 셋트조립-제본·evaluate_set_price 이중합산"을 전제하나, **라이브 실측은 이를 부분만 충족**한다:
> - **design JSX 문구폼**(스프링/링 제본노트·제본옵션 50장/100장 1권·링컬러)은 라이브 **PRD_000178 스프링수첩·PRD_000177 스프링노트·PRD_000181 중철노트**에 대응하는데, **이들은 셋트가 아니라 단일상품**(`evaluate_price` + 단일 component `COMP_STN_*`·고정 단가·NOT in t_prd_product_sets). → design 외형의 직접 대응은 **단일상품**.
> - 문구군에서 **유일한 라이브 셋트**는 **PRD_000097 떡메모지**(부모 097 ⋈ member 098 내지·`evaluate_set_price`). 떡메모지는 design 문구폼과 외형은 다르나(메모지) **셋트조립-제본 구조**를 만족.
> - 따라서 본 전파는 evaluate_set_price 요건(directive) 충족을 위해 **떡메모지 097을 셋트 대표**로, design 외형 정합을 위해 **스프링수첩 178을 보조 단일 대표**로 둔다(둘 다 라이브·PRICE≠0). 날조 없이 양면 표기.

| 동형 축 | C5 book(PRD_000069) | stationery 셋트(PRD_000097 떡메모지) | 동형? |
|---------|---------------------|--------------------------------------|:--:|
| 셋트 구조 | 부모(제본비) ⋈ 표지290+내지289 member | 부모 097 ⋈ member 098(내지) — **member 1개**(표지 없음) | △ 준동형(member 수 적음) |
| **부모공식** | PRF_BIND_MUSEON = **제본비 단일비목**(member가 표지/내지가) | **PRF_TTEOKME_FIXED = 완제품 고정가**(사이즈·권당장수·수량 단가표·부모가 전체가) | ❌ **다름** — book=제본비만/떡메=완제품 전체가 |
| **이중합산0** | 부모=제본만·표지/내지=member → 무중복 | member 098 **own formula 부재**(contribution=0)·부모 고정가가 전체 → **이중합산 0 자명** | ✅ (다른 메커니즘으로 0 보장) |
| 면별(ProductSide) | 표지/내지 2면(default/inner) | 단면 메모지(내지 member만)·면별 분해 약함 | △ |
| color-chip(링) | 링=트윈링 071 전용(069 부재) | 떡메=링 없음·**스프링노트(178)는 링 보유**(design 링컬러) | △ 단일상품 측에 존재 |
| 가격 PRICE≠0 | evaluate_set_price 138,688 | **evaluate_set_price**(부모 고정가 3,000~3,200·member 0) PRICE≠0 ✅ | ✅ |

| 동형 축 | C5 book | stationery 단일(PRD_000178 스프링수첩) | 동형? |
|---------|---------|----------------------------------------|:--:|
| 가격모델 | evaluate_set_price(셋트) | **evaluate_price(단일·COMP_STN_SPRINGNOTEBK 고정단가 3,000)** | ❌ 셋트 아님 |
| design 외형 정합 | (책자) | **제본옵션 50/100장·링컬러·구간할인 = design 문구폼 직대응** | ✅ 외형 |
| 위젯 클래스 | W-SET | **W-CASCADE**(§29)·L4 100% | — |

→ **결론:** stationery는 **두 라이브 실체로 갈라진다** — (가) design 외형 직대응 = 단일상품(178/177/181·evaluate_price·C1 고정가by-siz에 더 가까움) / (나) directive의 셋트조립 요건 = 떡메모지 097(evaluate_set_price·고정가-셋트). **C5 book의 "분해형+면별+제본비 부모" 정석과는 메커니즘이 다르다**(book=제본비 부모/stationery 셋트=완제품 고정가 부모). 동형 클래스는 유지(셋트조립)하되 **"고정가-셋트" 하위변종**으로 분리하고, design 문구폼은 단일상품 매핑(C1 accessories 규칙 일부 전파)으로 처리해야 함을 명시.

---

## ② 그룹 델타 (stationery 고유 — book 대비)

book-form-spec와 **다른 항목만** 기재(공통 componentType 사상·주문가능 정의는 상속).

| 델타 | stationery 값 | book 대비 | 분류 |
|------|--------------|----------|------|
| **셋트 member 수** | 떡메모지=member 1개(내지 098)·표지 member 없음 | book=표지+내지 2 member | (A) member 라우팅(1개) |
| **부모공식 의미** | PRF_TTEOKME_FIXED=완제품 고정가(siz_cd·bdl_qty·min_qty 단가표) | book 부모=제본비 단일비목 | (A) priceSchemeKey echo(불투명·위젯 무지) |
| **제본옵션 bind**(50장/100장 1권) | 라이브 떡메 **bdl_qty 50/100**(t_prd_product_bundle_qtys)·design `bind` 직대응 | book 제본=OPT_000020 택1(무선) | (A) bdl_qty→counter/select 차원 |
| **장수 차원** | 떡메 단가표 min_qty(장수 6/12 밴드)·design "권당 장수" | book 내지페이지=page_rules(24~300/+2·page-counter-input) | (A) min_qty 밴드(★page-counter 아님) |
| **링컬러** ColorChip 블랙/그레이/화이트 | 떡메=링 없음 / **스프링노트(177·단일) 링 보유**·colorHex 부재 | book 링=071 전용(069 부재) | (C) colorHex+CPQ(단일상품 측) |
| **내지** 무지내지(단일 enum) | design 단일값·라이브 098 내지(member) | book 내지=종이/인쇄/페이지 다축 | (A) 단순화(enum 1값) |
| **구간할인 Slider** | design DiscountSlider(1/10/50/100/500/1000+·6%off) | book 미노출 | (A) **입력축 아님**·summary/price-slider read-only(서버 qty 자동할인·SYNTHESIS §2) |
| **CTA** | design=**PDF + 에디터 양쪽**(에디터로 디자인하기 버튼) | book 069=PDF only(editor_yn=N) | (C) editor_yn 정합(178 editor_yn 실측 필요·design은 에디터 노출) |
| **사이즈** | 178=SIZ_000377(90x145)·097=SIZ_000119(90x90)/SIZ_000266(70x120) | book A4/A5 | (A) 직매핑 |

**델타 핵심:** stationery의 차별점은 ① **셋트가 "고정가 부모"**(book의 "제본비 부모"와 다름·이중합산0은 member contribution=0으로 자명) ② **제본옵션=bdl_qty 차원**(book의 제본 택1과 다름) ③ **장수=min_qty 밴드**(book의 page-counter와 다름) ④ **구간할인 Slider=입력축 아님**(서버 qty 자동할인·read-only summary). **신규 위젯 슬롯 0**(counter/select/color-chip/summary 기보유).

---

## ③ 라이브 대표 상품 (셋트=PRD_000097 떡메모지 + 보조 PRD_000178 스프링수첩)

### 셋트 대표 PRD_000097 떡메모지 (evaluate_set_price)
| 속성 | 라이브 실측값 |
|------|--------------|
| 셋트 | t_prd_product_sets: 부모 097 ⋈ **member PRD_000098 내지(백모조120)**·sub_prd_qty=1·disp_seq=1 |
| 부모공식 | PRF_TTEOKME_FIXED = COMP_TTEOKME(PRC_COMPONENT_TYPE.06·고정단가형·use_dims=[siz_cd,bdl_qty,min_qty]) |
| member 098 | 가격공식 **부재**(own formula 0행) → evaluate_set_price contribution 0 → **이중합산0 자명** |
| 사이즈 | SIZ_000119(90x90)·SIZ_000266(70x120) |
| bdl_qty | 50·100 (권당 장수·design 제본옵션 50/100장 직대응) |
| min_qty 밴드 | 6·12 (장수 밴드·단가표) |
| 수량 | min3·max1000·incr3·QTY_UNIT.03(권) |
| §29 등급 | **L3·87.5%**·위젯클래스=W-SET·`calc=PRICED-완제품가·frm=PRF_TTEOKME_FIXED·pfm=BOUND_OK` |

### 보조 단일 대표 PRD_000178 스프링수첩 (design 외형 직대응·evaluate_price)
| 속성 | 라이브 실측값 |
|------|--------------|
| prd_typ | PRD_TYPE.01 완제품(셋트 아님) |
| 공식 | PRF_STN_SPRINGNOTEBK = COMP_STN_SPRINGNOTEBK(고정단가·use_dims=[siz_cd,min_qty]·단가 3,000@SIZ_000377) |
| §29 등급 | **L4·100%**·W-CASCADE·`calc=OK·pfm=DESIGNED_NOT_LOADED` |
| 형제 | 177 스프링노트(PRF_STN_SPRINGNOTE·4,500@A5)·181 중철노트(PRF_STN_JUNGCHEOL·2,500@A6) |

---

## ④ 가격 골든 (evaluate_set_price·이중합산0) — ✅ PRICE≠0

### 셋트 골든 (PRD_000097 떡메모지·evaluate_set_price)
```
NormalizedPriceRequest { productCode:PRD_000097, priceSchemeKey:PRF_TTEOKME_FIXED(echo·부모),
  dimensions:[{side:inner, 90x90=SIZ_000119}], bundleQty:50(권당장수), quantity:12(권), ... }
   │ 어댑터 createHuniAdapter (셋트 arm·book 동형):
   │   · member 098(내지)로 라우팅(sub_prd_qty=1)·member own formula 없음(contribution 0)
   │   · bdl_qty=50·min_qty 밴드=12 → 부모 고정가 단가표 조회
   ▼
evaluate_set_price(set_prd_cd=PRD_000097, members=[{098:내지sel, qty}],
   set_selections={siz=SIZ_000119, bdl_qty=50}, copies=12)   [pricing.py:844]
   │  → set_eval: PRF_TTEOKME_FIXED 단가표(90x90·50장1권·장수12밴드) = 2,300원/권
   │  → member 098 contribution = 0 (own formula 부재)
   ▼
NormalizedPriceBreakdown { ok, finalPrice, lines:[{COMP_TTEOKME 완제품가}] }
```

| 케이스 | siz·bdl·장수밴드 | copies | unit | 출처(라이브 component_prices) |
|--------|-----------------|:--:|:--:|------|
| A | 90x90·50장1권·장수6↑ | — | **3,000** | row 3909 COMP_TTEOKME |
| B | 90x90·100장1권·장수6↑ | — | **3,200** | row 3910 |
| C | 90x90·50장1권·장수12↑ | — | **2,300** | row 3913 |
| D | 70x120·100장1권·장수12↑ | — | **2,500** | row 3916 |

> ★**이중합산0 [HARD]**: member 098(내지)은 own 가격공식이 **부재** → evaluate_set_price member contribution=0 → final = 부모 고정가(완제품가) 1회뿐. book(069)은 "부모=제본만·표지/내지=member"로 무중복, 떡메는 "부모=완제품 전체·member=0"으로 무중복 — **메커니즘은 다르나 둘 다 이중합산0**. ✅
> 라이브 시뮬레이터 직호출은 인증세션(CSRF) 필요 — 본 골든은 라이브 component_prices 단가행(verbatim 3,000/3,200/2,300/2,500) 권위 재사용. 날조 0.

### 단일 골든 (PRD_000178 스프링수첩·evaluate_price)
| 케이스 | siz·min_qty | unit | 출처 |
|--------|------------|:--:|------|
| 178 스프링수첩 | SIZ_000377(90x145)·min_qty1 | **3,000** | row 40380 COMP_STN_SPRINGNOTEBK |
| 177 스프링노트 | SIZ_000170(A5)·min_qty1 | **4,500** | row 40379 |
| 181 중철노트 | SIZ_000196(A6)·min_qty1 | **2,500** | row 40383 |

✅ **PRICE≠0 게이트 통과**(셋트 떡메 2,300~3,200·이중합산0 / 단일 스프링 2,500~4,500 전부 >0).

---

## ⑤ 갭 (A)/(B)/(C) + 주문가능 4조건

### 갭 분류
- **(A) 어댑터 흡수 — 계약/위젯 무변경**: A1 셋트 member 라우팅(098 내지·1 member)·A2 부모 priceSchemeKey echo(고정가/제본 무관·불투명)·A3 bdl_qty→차원(제본옵션 50/100)·A4 min_qty 밴드→차원(장수)·A5 이중합산 가드(member contribution 0)·A6 구간할인 Slider=summary read-only(입력축 아님)·A7 사이즈 직매핑·A8 수량 DB 권위(권 단위)·A9 PRICE=0 진단. (book A1~A15 + accessories C1 고정가by-siz 규칙 일부 전파)
- **(B) 계약 변경 필요 = 0~1**: ProductSide·color-chip(링)·counter/select·summary 기보유 → **계약 변경 0**. 단 design 문구폼이 **단일상품(178)인데 셋트 요건(directive)과 갈림** → 위젯이 단일/셋트 어느 폼을 쓸지는 hw-architect 결정(잠재 (B)는 아니고 어댑터 arm 선택·SYNTHESIS §5 제본방식 멀티상품 폼과 유사).
- **(C) DB 작성·교정 — §7/§23 인간 승인**:
  - C-링컬러 colorHex: 스프링노트류(177) 링컬러 colorHex+CPQ(design 링컬러 3종·라이브 미적재·book C-colorHex 동형).
  - C-CPQ 옵션그룹: 097/178 **option_groups 0행** — 사이즈/내지/종이/제본옵션/링/장수 CPQ 미생성(§7).
  - C-제본옵션 노출: bdl_qty(50/100)는 라이브 차원 존재하나 CPQ 옵션그룹으로 손님 선택수단 미표면화.
  - C-editor_yn 정합: design 문구폼=PDF+에디터 양쪽 노출 vs 라이브 editor_yn 실측(178)·불일치 시 교정 또는 위젯 숨김.
  - C-떡메 판형 D7: §29 097 D7=WARN(판형/CPQ 적재)→L4 승급.

### 주문가능 4조건 (PRD_000097 떡메모지 셋트 현재)
| 조건 | 충족도 | 근거 |
|------|:--:|------|
| ⓐ 옵션 라이브 DB 구동 | △ **부분** | 사이즈·bdl_qty·min_qty 차원행 존재·단가표 완비 ✅ / option_groups 0행(손님 선택수단 CPQ 미생성) ❌ |
| ⓑ 제약 6종 데이터 강제 | △ **부분** | 수량(권·incr3)·사이즈 강제 ✅ / constraints 0행·제본/장수 CPQ 미적재 ⚠ |
| ⓒ PRICE≠0 | ✅ **충족** | evaluate_set_price 2,300~3,200 >0·**이중합산0(member contribution 0)** ✅ |
| ⓓ 유효 페이로드 | ✅ **충족** | NormalizedCartHandoff 조립 가능·priceSnapshot 유효 |

**판정: 부분 주문가능(PARTIAL) — 가격은 동작(PRICE≠0·이중합산0), CPQ 옵션 미적재가 병목.** 떡메모지 셋트(097)는 evaluate_set_price로 PRICE≠0·이중합산0이 라이브 동작(book 069와 동급 가격 성숙)하나, **option_groups 0행**이라 손님이 사이즈/제본옵션/장수를 고를 CPQ 수단이 없음(C). 단일상품 측(178 스프링수첩)은 L4·100%·evaluate_price PRICE≠0로 **가격은 가장 성숙**하나 역시 CPQ 0. **병목 = CPQ 옵션그룹 적재(C·§7)** — 가격 자체는 book·calendar와 달리 라이브 동작.

**다음 권고:** ① **directive 정정 확인** — stationery 셋트 요건(evaluate_set_price)은 떡메모지 097로 충족(✅), design 문구폼(스프링노트)은 라이브 단일상품(178/177/181·evaluate_price)임을 hw-architect에 통지(단일/셋트 폼 arm 결정) → ② §7에 CPQ 옵션그룹 적재(097 사이즈/제본옵션/장수·178 사이즈/제본옵션/링컬러) → ③ 적재 후 어댑터 셋트 arm(book 동형·member 1개·고정가 부모·이중합산 가드) + 단일 arm(accessories C1 고정가by-siz 동형) 전파 → PRICE≠0 재검증 → ④ 형제 177/181/179(메모패드) 전파. 코드 구현은 CPQ 적재 후.

---

## 부록: 동형 전파 노트 (stationery 형제)
| 형제 | 가격모델 | 동형 |
|------|----------|:--:|
| PRD_000178 스프링수첩 | 단일 evaluate_price·L4·3,000 | 단일 arm(C1 고정가by-siz·design 외형 직대응) |
| PRD_000177 스프링노트 | 단일·4,500·링 보유 | 단일 arm + 링컬러 color-chip |
| PRD_000181 중철노트 | 단일·2,500 | 단일 arm |
| PRD_000179 메모패드 | (실측 필요) | (점검) |
| PRD_000097 떡메모지 | **셋트 evaluate_set_price·고정가 부모·member 0** | 셋트 arm(book 준동형·고정가-셋트 변종) |
**전파 원칙:** 문구군은 **두 arm으로 갈라짐** — (가) 단일상품(스프링/중철노트)=evaluate_price·고정가by-siz(accessories C1 규칙) (나) 셋트(떡메모지)=evaluate_set_price·고정가 부모(book C5 준동형, member contribution 0으로 이중합산0). design 문구폼은 (가)에 외형 직대응. **book의 "제본비 부모+면별 2 member" 정석은 stationery에 직접 전파 불가**(부모 의미 다름) — 매핑 규칙만 선택 전파.
