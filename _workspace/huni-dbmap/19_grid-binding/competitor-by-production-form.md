# 생산형태별 경쟁사 옵션 모델링 — 갭헌팅 (완제품·반제품 확장)

> **작성** 2026-06-13 · round-15 `production-form-grid-matrix.md §2` 보강. `17_correctness/_crosscut/accessory-option-research.md`(기성상품 6그릇 매핑)의 **완제품·반제품 생산형태 확장.**
> **문제 정의:** round-15가 생산형태(완제품/반제품/기성상품)를 1차 렌즈로 삼았으므로, 경쟁사도 **생산형태별로** "선택→견적" 옵션 모델링을 어떻게 하는지 갭헌팅해 후니 §2 그릇 배정 원칙을 보강한다.
> **권위 순서 [HARD]:** 0. 후니 정체(huniprinting.com) > 1. 엑셀 L1 > 2. webadmin 적재 > 3. 스키마 설계의도 > 4. 도메인 > 5. **경쟁사(갭헌팅용·답습 금지)**.
> **추정 0** — 미지는 가설+출처+컨펌ID. 표준 충돌 시 후니 권위. 모든 URL은 WebFetch/WebSearch 검증(§Sources).
> **언어:** 서술 한국어, 식별자/컬럼/코드/t_*/SQL = English.

---

## 0. 결론 선언 (먼저)

생산형태를 1차 렌즈로 경쟁사를 보면 **§2 매트릭스의 완제품·반제품 열이 경쟁사 표현력을 전부 흡수**한다.

1. **완제품(굿즈·인쇄물):** 표면 색입힘·각인·후가공을 경쟁사(Vistaprint·MOO·Gotprint·Printful·마플)는 ① **인쇄/디자인 표면**(에디터로 디자인)과 ② **special finish 선택옵션**(박/엠보싱/각인/코팅 = checkbox-style add-on)으로 가른다. 새 차원축을 만들지 않고 finish=**선택옵션(가격 가산)**으로 둔다 = 후니 §2 완제품 6 "후가공=`processes`+param" + 판매축 option과 정확히 일치. **흡수.**
2. **반제품(포토북·책자):** 표지타입(하드/소프트/레더/레이플랫)을 경쟁사(Blurb·Mixbook·Shutterfly·Snapfish)는 **별 상품이 아니라 "내지를 다 만든 뒤 마지막에 고르는 단일 선택"**으로 모델링한다(Mixbook "at the end of the project you pick from the three main cover categories"). 표지+내지는 **한 결합 단위**(후니 `sub_prd`/`t_prd_product_sets`와 동형). 가격은 **base price + per-page**(Blurb 하드커버 $46 base + $0.45/page)로, 후니 가격공식 4종 중 **고정가형(완제품가 포함) + page 변수**에 해당. **흡수.**
3. **신규 GAP = 0건(생산형태 측).** accessory 리서치가 이미 발견한 **GAP-1(line item property=각인 텍스트)**·**GAP-2(공정 param 보존)** 외에 완제품·반제품에서 새로 발견된 구조 GAP은 없다. 단 **반제품에서 "표지타입별 page_rule 차등"의 모델링 정밀도**가 후니 라이브에 미반영(F-PB-1)인 것이 경쟁사 대비 약점 = **GAP 아닌 적재 정밀도 결함**(기존 진단 재확인).

---

## 1. 생산형태별 경쟁사 옵션 모델링 비교표

### 1.1 완제품 커스텀 굿즈 (디지털인쇄·실사·아크릴·굿즈·스티커 대응)

| 출처 | 표면 색입힘(인쇄) | 각인(engraving) | 후가공(박/엠보싱/코팅) | 면적형 가격(배너/실사) UX | variant vs 옵션 판별 |
|------|---|---|---|---|---|
| **Vistaprint**(해외) | 에디터 디자인(이미지/텍스트) | **engraving = 선택 finish**(150+ style 옵션) | **special finish = 디자인 과정 중 선택**(gold/silver/glitter foil, embossed gloss 75%까지, embossed foil) = 가격 가산 add-on | (배너는 사이즈 옵션) | finish=option(별 SKU 아님·디자인에 얹음) |
| **MOO**(해외, finish 강함) | 디자인 업로드/템플릿 | (각인 미제공·foil 위주) | spot gloss·foil·letterpress = **paper/finish 선택**(별 라인이 아닌 옵션 가산) | — | finish=선택옵션 |
| **Gotprint**(해외, 인쇄소형) | 인쇄(도수·양면) | (없음) | **coating 4종 라디오**(High Gloss UV/Matte/Soft-Touch/none) + raised UV·foil·rounded corner = **add-on(가격 가산)** | — | paper×coating=가격키, finish=가산옵션 |
| **Printful**(해외 POD) | 디자인(이미지) | (별도 앱) | (제품 내장 — 자수/DTG는 method) | — | **size×color = variant(각각 own SKU)** |
| **마플**(국내 커스텀 굿즈) | 에디터 디자인(이미지) | (이미지 인쇄 위주) | (제품별 내장) | — | 사이즈·색상=개별 선택옵션 |
| **레드프린팅**(사용자 본인 설계) | 인쇄옵션(도수) | (에디터 업로드) | 코팅·후가공=캐스케이드 옵션(저평량지→disable) | 포스터/배너=사이즈 옵션 | MTRL_CD×SIZ×도수=가격·캐스케이드 키 |
| **배너 전문**(Printastic·BestOfSigns 등) | 인쇄(풀컬러 양면) | — | 헤밍·그로멧=옵션 | **면적당 단가(sq ft) × 사이즈 입력 + 수량할인(100sqft~)** | 사이즈=연속입력(가격=면적×단가) |

**완제품 핵심 패턴 3:**
- **표면 색입힘 = 디자인(에디터) + 인쇄도수.** 새 옵션축이 아니라 상품에 내장된 인쇄 표면. 후니=`print_options`(도수)+에디터(`editor_yn`).
- **후가공(박/엠보싱/코팅/각인) = special finish 선택옵션(가격 가산 add-on).** 별 SKU/variant가 아님(Vistaprint·MOO·Gotprint 만장일치). 후니=`processes`+param, 판매축=`option_items`.
- **면적형(배너/실사) = 사이즈 연속입력 + 면적단가.** 가격=⌈가로×세로⌉×sq ft 단가 + 수량할인. 후니=면적매트릭스형(포스터사인 이산 격자 + off-grid ceiling, OM-3 입력UX≠가격격자).

### 1.2 반제품 세트상품 (책자·포토북 대응)

| 출처 | 표지타입(하드/소프트/레더/레이플랫) | 표지+내지 결합 | 내지 page 모델링 | 제본방식 | base+per-page 가격 |
|------|---|---|---|---|---|
| **Blurb**(해외) | **paperback/imagewrap HC/dust jacket HC = 사이즈 카테고리 내 가격 변수**(별 상품 아님) | 한 책 = 표지+내지 결합 단위 | base price는 일정 page 포함(예 20p), **초과분 $0.45~0.70/page** | 제본=cover style에 내장 | **base(HC $46) + per-page($0.45)** + paper grade + 수량할인(10~19=20%) |
| **Mixbook**(해외) | **softcover/hardcover/layflat = 내지 완성 후 마지막에 단일 선택**("at the end of the project you pick from the three main cover categories") | 결합 단위(표지 선택이 다른 feature에 의존=캐스케이드) | per-page $0.99~4.99(사이즈·품질별) | cover category에 내장(layflat=특수제본) | base(HC $19.99~) + per-page |
| **Shutterfly**(해외) | hardcover/softcover/layflat 옵션 | 결합 단위 | page 추가 가산 | cover에 내장 | base + per-page |
| **Snapfish**(해외) | hardcover/softcover 옵션 | 결합 단위 | page 추가 가산 | cover에 내장 | base + per-page |

**반제품 핵심 패턴 3:**
- **표지타입 ≠ 별 상품.** 전원 **"한 책 안에서 마지막에 고르는 단일 선택"**(Mixbook 명시·Blurb "사이즈 카테고리 내 가격 변수"). → 후니가 **표지타입을 별 PRD로 분리하지 않고** `sub_prd`/`sets`로 결합하는 것이 정합(book family BK-CAT 전용 잎노드 모델과 일치).
- **표지+내지 = 한 결합 판매단위.** 경쟁사는 표지를 별도 장바구니 항목으로 두지 않음 = 후니 `t_prd_product_sets`(표지 sub_prd 결합·자재 권위=parent+usage_cd)와 동형. **sub_prd/세트/번들 중 = "세트(결합 단위)"가 정답**(번들=조성동일+수량은 아님).
- **가격 = base + per-page.** base에 일정 page 포함, 초과 page만 per-page 가산. 후니 가격공식 4종 중 **고정가형(완제품가 포함)** + page 변수. **page는 견적 변수**(떡제본·낱장의 page=잡음과 구분, intent-map L358).

### 1.3 기성상품 (악세사리) — 기존 리서치 인용 (재수행 금지)

`accessory-option-research.md` §1·§6 결론 그대로: 기성상품(봉투·볼체인·케이스·우드거치대)은 **본체색=variant/자재행, 묶음=bundle_qtys, 인쇄·공정 BOM 거의 없음, 추가상품으로 host가 `t_prd_templates` 참조.** 후니 8그릇 = 경쟁사 6 표준 그릇(Product/Variant/Attribute/Option/LineItemProperty/Bundle) 전부 흡수·능가. 실 GAP = GAP-1(line item property)·GAP-2(공정 param)뿐. **본 문서에서 재판정하지 않음.**

---

## 2. 역량질문 1~4 답변

### Q1. 완제품에서 "표면 색입힘·각인·후가공"을 경쟁사는 선택옵션/공정/variant 중 무엇으로? (후니 §2 완제품 열 대조)

**경쟁사 합의 = 선택옵션(special finish, 가격 가산) + (생산상) 공정. variant 아님.**

- **표면 색입힘(인쇄)** = 에디터 디자인 + 인쇄도수. 상품 내장(별 옵션 아님). 후니 §2 완제품 4 "`print_options`(도수)+`processes`(UV/실사)" 정합. **흡수.**
- **각인** = Vistaprint **engraving 선택옵션(150+ style)**. 판매축=option, 생산축=공정(레이저각인). 후니 §2 완제품 6 후가공 + accessory §3 정합. 단 **각인 텍스트 내용은 line item property(GAP-1)** — 완제품에서도 동일. **흡수(텍스트 GAP 제외).**
- **후가공(박/엠보싱/코팅)** = Gotprint **coating 라디오 + raised UV/foil add-on**, Vistaprint **embossed gloss/foil add-on**, MOO **spot gloss/foil 선택**. 전원 **선택옵션(가격 가산)이되 생산은 공정.** 후니 §2 완제품 6 "`processes`(코팅·커팅·박/형압)+param" + 판매축 `option_items` (실무진 Q2 박=공정·Q9 코팅=공정 확정). **흡수.**

> **판정:** 후니 §2 완제품 열이 경쟁사 finish 모델을 **흡수**한다. 후니는 "BOM축=공정(`processes`) + 판매축=옵션(`option_items`)"의 2축 분리로, 경쟁사의 "finish=가격 가산 옵션"을 **공정 BOM까지 보존하며** 표현(경쟁사는 finish의 생산 BOM을 숨김 → 후니가 더 정밀). **신규 GAP 0.**

### Q2. 반제품에서 "표지+내지 결합·제본"을 경쟁사는 sub_prd/세트/번들 중 무엇으로? (후니 §2 반제품 열·`t_prd_product_sets` 대조)

**경쟁사 합의 = "세트(결합 단위)". sub_prd/번들 중 = 세트.**

- **표지+내지 결합** = 경쟁사는 표지를 **별 상품/별 장바구니 항목으로 두지 않고** "한 책 = 표지타입 선택 + 내지 page"의 단일 결합 단위로 판매(Blurb·Mixbook·Shutterfly·Snapfish 만장일치). 표지타입은 **내지 완성 후 마지막 단일 선택**(Mixbook 명시). → 후니 `t_prd_product_sets`(표지 sub_prd 결합·PRD_TYPE.02) + 자재 권위=parent+usage_cd(표지.02/내지.01/면지.03)와 **정확히 동형**. **흡수.**
- **번들(bundle) 아님** = 번들은 "조성동일+수량"(볼체인 3개1팩, Lasso 기준). 표지+내지는 조성이 다른 부분품 결합이라 번들이 아니라 **세트(set)**. 후니가 `bundle_qtys`(권/세트 수량)와 `sets`(부분품 결합)를 분리한 것이 정합.
- **제본방식** = cover style에 내장(layflat=특수제본). 후니 §2 반제품 7 "`processes` PROC_000017 + GRP-BOOK-제본 택일그룹" + book family 상품명=제본 1:1(BK-9, 한 상품이 한 제본). 경쟁사는 cover-binding을 묶어 노출하나 후니는 제본을 공정으로 분리(생산 정밀). **흡수.**

> **판정:** 후니 §2 반제품 열이 경쟁사 표지+내지 결합을 **흡수**한다. **핵심 정합점:** 경쟁사가 "표지타입=별 상품 금지·마지막 단일선택"으로 모델링하는 것은 후니 book family의 "표지=sub_prd, 제본=공정, BK-CAT 전용 잎노드" 구조를 **외부에서 검증**한다(별 PRD 폭증 금지). **신규 GAP 0.**

### Q3. 면적형 가격(실사/배너)·base+per-page(포토북)를 경쟁사 견적 UX는 어떻게? (후니 가격공식 4종 대조)

| 가격유형 | 경쟁사 UX | 후니 가격공식 4종 대응 | 판정 |
|---|---|---|---|
| **면적형(배너/실사)** | 사이즈 **연속입력**(가로/피트) → 가격=⌈가로×세로⌉×sq ft 단가 + 100sqft~ 수량할인 (Printastic·BestOfSigns·NorthCoast $1.40~5/sqft) | **면적매트릭스형**: 포스터사인 `[가로][세로]` 이산 매트릭스 + off-grid ceiling(앱). [[dbmap-silsa-price-via-poster-sign]] | **흡수+능가** — 경쟁사=연속×단가(단순), 후니=이산 매트릭스 셀(사이즈별 차등단가 표현 가능) + ceiling. OM-3 "입력UX(연속)≠가격격자(이산)"가 경쟁사 연속입력 UX와 후니 이산격자 가격을 **분리**해 정합 |
| **base+per-page(포토북)** | base에 일정 page 포함(Blurb 20p) + 초과 $0.45~0.70/page + paper grade + 수량할인(10~19=20%) | **고정가형(완제품가 포함)** + page 변수 + 수량할인(`t_dsc_*`) | **흡수** — 후니 page는 `t_prd_product_page_rules`(min/max/incr) 견적 변수. 단 **표지타입별 page 차등**(HC만 24/150/2, 레더/소프트 공란=F-PB-1)이 라이브 미반영 = 적재 정밀도 결함(GAP 아님) |
| **(완제품 고정가)** | Gotprint 수량×사양 직접단가(50 cards $9.59) | **고정가형**(수량×옵션 직접단가, `t_prd_product_prices`) | 흡수 |
| **(원자합산)** | (경쟁사 인쇄소는 통합단가, 분해 미노출) | **원자합산형**(디지털인쇄 PRF_DGP_A~F + COMP_PAPER) | **능가** — 후니가 인쇄비+용지비+후가공 원자 분해(경쟁사는 통합가만) |

> **판정:** 후니 가격공식 4종이 경쟁사 견적 UX를 **전부 흡수, 면적형·원자합산형은 능가.** 면적형의 핵심은 OM-3(입력UX 연속 ≠ 가격격자 이산) — 경쟁사 연속입력을 후니가 이산 면적매트릭스로 받아도 UX 손실 없음(off-grid ceiling). **신규 GAP 0.**

### Q4. 후니 §2 매트릭스(완제품/반제품 열)가 경쟁사 표현력을 흡수/능가하는가? 신규 GAP은?

**흡수+능가. 생산형태 측 신규 GAP 0.**

| §2 구성요소 | 완제품 열 | 반제품 열 | 경쟁사 흡수/능가 판정 |
|---|---|---|---|
| 3 소재(본체색) | materials 본체색 합성 | parent+usage_cd | **흡수** (WowPress 본체색=재질·경쟁사 paper grade=재질) |
| 4 인쇄/도수 | print_options+processes | 내지 도수 | **흡수** (에디터+도수) |
| 6 후가공 | processes+param | 결합 후가공 | **흡수+능가** (finish=옵션이되 공정 BOM 보존) |
| 7 제본 | (적음) | processes PROC_000017+택일그룹 | **흡수+능가** (cover-binding 묶음을 공정 분리) |
| 8 추가상품성 | 옵션/세트 | **sub_prd 결합** | **흡수** (표지+내지=세트, 별 PRD 금지를 경쟁사가 검증) |
| 10 가격 | 면적/고정/원자합산 | 고정가(완제품가 포함)+per-page | **흡수+능가** (면적매트릭스·원자합산 능가) |

**신규 GAP 후보 전수 검토:**
- ❌ **표지타입 차원** — 별 그릇 불요(sets로 흡수). GAP 아님.
- ❌ **per-page 가격** — page_rule + 고정가형으로 흡수. GAP 아님.
- ❌ **special finish 가산** — option_items(가격 가산) + processes(BOM). GAP 아님.
- ⚠️ **각인 텍스트(완제품에도 해당)** = 기존 **GAP-1(line item property)** 재확인. 완제품 굿즈(볼펜·텀블러 각인)에서 accessory와 동일 GAP. **신규 아님(기존 GAP-1 적용 범위 확장).**
- ⚠️ **공정 param(엠보싱 위치·page별 용지 차등)** = 기존 **GAP-2(`ref_param_json` 미구현)** 재확인. **신규 아님.**
- 🟡 **표지타입별 page_rule 차등** = 후니 라이브 F-PB-1(소프트/레더 page 공란) — **GAP 아닌 적재 정밀도 결함**(스키마는 page_rule을 sub_prd별 차등 보유 가능). 경쟁사는 표지타입마다 page 범위가 다른데(layflat은 적은 page), 후니 스키마는 표현 가능하나 라이브 미적재.

> **최종 판정:** 후니 §2 완제품·반제품 열은 경쟁사(Vistaprint·MOO·Gotprint·Printful·마플·Blurb·Mixbook·Shutterfly·Snapfish)의 옵션 모델링을 **전부 흡수하고 후가공·제본·면적/원자합산 가격에서 능가**한다. **생산형태 확장에서 신규 구조 GAP은 발견되지 않았다.** 단 기존 GAP-1(각인 텍스트)이 완제품 굿즈까지 적용 범위 확장되고, F-PB-1(표지타입별 page 차등)은 스키마 표현력은 충분하나 라이브 적재 정밀도 결함으로 재확인된다.

---

## 3. 후니 §2 그릇 배정 보강 (생산형태별 완제품·반제품 강화 규칙)

accessory 리서치의 "2축 도출(BOM축 + 판매축)"을 **생산형태가 1차로 가른다**는 §2 원리에 경쟁사로 보강:

| 구성요소 | 완제품 보강 규칙(경쟁사 근거) | 반제품 보강 규칙(경쟁사 근거) |
|---|---|---|
| **후가공/finish** | special finish = **선택옵션(가격 가산) + 공정 BOM 보존**. 별 SKU 금지(Vistaprint·MOO·Gotprint). 후니=option_items + processes+param | 결합 후 후가공도 동일. 표지/내지 각각 finish 가능 |
| **표지타입** | (해당 없음) | **별 PRD 금지 → sub_prd/sets 결합, 내지 완성 후 마지막 단일선택**(Mixbook 명시·Blurb). 후니 book BK-CAT 모델 정합 |
| **제본** | (적음) | cover style 내장이나 후니는 **공정 분리**(PROC_000017+택일그룹). 한 상품=한 제본(BK-9) |
| **page** | (낱장=page 잡음, 적재 금지) | **base+per-page 견적 변수**(`page_rules`). **표지타입별 차등 적재**(F-PB-1 교정 = layflat/소프트 page 범위 적재) |
| **면적 가격** | **이산 면적매트릭스 + off-grid ceiling**(경쟁사 연속입력 UX 받되 가격은 이산). OM-3 | (해당 없음) |
| **각인 텍스트** | **GAP-1 적용**(볼펜·텀블러 각인 텍스트=line item property, 완제품에도) | (해당 적음) |

---

## 4. 미해소 / 추가 컨펌 (신규)

| ID | 컨펌 질문(비전문가용) | 막힌 이유 | 가설(출처) |
|---|---|---|---|
| **Q-PF-1** | 포토북·책자에서 "하드커버/소프트커버/레더/레이플랫"을 **마지막에 고객이 하나 고르는 옵션**으로 보나요, 아니면 표지종류마다 다른 상품으로 보나요? | 경쟁사는 전원 "마지막 단일선택"(별 상품 아님). 후니 라이브는 표지=sub_prd지만 product-identity 일부 표지타입이 별 PRD로 등록됨 | sets 결합(단일선택)이 정합. 별 PRD면 sets로 흡수 권고 |
| **Q-PF-2** | 표지타입마다 **선택 가능한 page 수가 다른가요**?(레이플랫=적은 page, 하드커버=많은 page) | 경쟁사는 cover별 page 범위 차등. 후니 F-PB-1: 라이브에 하드커버만 page(24/150/2), 소프트/레더 공란 | page_rule을 sub_prd별 차등 적재(스키마 표현 가능) |
| **Q-PF-3** | 완제품 굿즈(텀블러·볼펜)에 **박/엠보싱/각인을 "넣을지 말지" 옵션**으로 팔되, 가격을 얹나요? | finish=가격 가산 옵션(경쟁사 표준)이나 후니 라이브 가격 미적재 | option_items(가격 가산) + processes BOM. 가격표 확인 후 |
| **GAP-1(재확인·범위확장)** | (구조) 각인 텍스트 = **완제품 굿즈에도** line item property 그릇 필요 | accessory에서 발견된 GAP-1이 완제품까지 적용 | 주문라인 메타(주문 스키마·본 하네스 밖) |

---

## 5. 최종 결론 (3~4줄 요약)

- **완제품 흡수 ✅:** 표면 색입힘·각인·후가공을 경쟁사(Vistaprint·MOO·Gotprint·Printful·마플)는 **special finish 선택옵션(가격 가산)**으로 두고, 후니 §2 완제품 열(`processes`+param + 판매축 `option_items`)이 이를 흡수하며 **공정 BOM 보존으로 능가**(경쟁사는 finish의 생산 BOM을 숨김).
- **반제품 흡수 ✅:** 표지타입을 경쟁사(Blurb·Mixbook·Shutterfly·Snapfish)는 **별 상품이 아니라 내지 완성 후 마지막 단일선택**으로, 표지+내지를 **한 결합 단위(세트)**로 모델링 — 후니 `sub_prd`/`t_prd_product_sets`(자재 권위=parent+usage_cd)와 동형. 가격은 **base+per-page**로 후니 고정가형+page_rule이 흡수. 별 PRD 폭증 금지를 경쟁사가 외부 검증.
- **신규 GAP 0건(생산형태 측):** 완제품·반제품 확장에서 새 구조 GAP 없음. 기존 **GAP-1(각인 텍스트=line item property)**이 완제품 굿즈까지 범위 확장, **F-PB-1(표지타입별 page 차등)**은 GAP 아닌 적재 정밀도 결함으로 재확인.
- **DB 미적재** — 조망/원칙 보강 전용.

---

## Sources

- [Blurb Pricing Calculator](https://www.blurb.com/pricing) — 표지타입=사이즈 카테고리 내 가격변수(별 상품 아님), base($46 HC)+per-page($0.45), paper grade, 수량할인(10~19=20%) (WebFetch 검증)
- [Hardcover vs Softcover Photo Books | Mixbook](https://www.mixbook.com/inspiration/hardcover-vs-softcover-photo-books-the-ultimate-guide) — 표지=내지 완성 후 마지막 단일선택·cover별 page 차등 (WebFetch + WebSearch 검증)
- [How Much Do Photo Books Cost | Shutterfly](https://www.shutterfly.com/ideas/how-much-do-photo-books-cost-pricing-guide/) — hardcover/softcover/layflat 옵션·base+per-page
- [Foil Accent / Embossed / Engraving Business Cards | Vistaprint](https://www.vistaprint.com/business-cards/metallic) · [Embossed Foil Postcards](https://www.vistaprint.com/marketing-materials/embossed-foil-postcards) — special finish=디자인 중 선택옵션(foil/embossed gloss/engraving 150+ style) 가격 가산 (WebSearch 검증)
- [Custom Business Card Printing | GotPrint](https://www.gotprint.com/products/business-cards/info.html) · [Print Capabilities | GotPrint](https://www.gotprint.com/company/capabilities.html) — coating 4종 라디오 + raised UV/foil/rounded corner add-on, paper×coating=가격키 (WebSearch 검증)
- [Banner Price Calculator | Printastic 4x20](https://www.printastic.com/vinyl-banners/sizes/4x20/) · [Custom Size Calculator | SignsBannersOnline](https://signsbannersonline.com/qsi/calculator.php) · [Vinyl Banner Price Calculator | NorthCoast](https://northcoastbanners.com/band-banners/vinyl-banner-price-calculator/) — 면적당 단가(sq ft)×사이즈 연속입력 + 100sqft~ 수량할인 ($1.40~5/sqft) (WebSearch 검증)
- [Printful API Docs](https://developers.printful.com/docs/) — size×color=variant(own SKU) (기존 accessory 리서치 재인용)
- **내부 권위(재인용):** `17_correctness/_crosscut/accessory-option-research.md`(기성상품 6그릇·2축 도출·GAP-1/2) · `19_grid-binding/production-form-grid-matrix.md §2`(생산형태×구성요소 매트릭스) · `00_schema/schema-design-intent-map.md ③`(가격공식 4종·삼중바인딩·OM-1~7) · `17_correctness/booklet/`(BK-CAT·sub_prd 자재 권위·제본 공정) · `17_correctness/photobook/`(레더 3-way·F-PB-1 page 차등) · `17_correctness/silsa/`(면적매트릭스·OM-3)
