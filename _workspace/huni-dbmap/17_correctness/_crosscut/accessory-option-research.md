# 주문제조 인쇄/굿즈 상품 "복합 옵션" 그릇 배정 — 경쟁사 갭헌팅 + 도메인 리서치

> **작성** 2026-06-13 · round-13 횡단 결함 종합(crosscut-synthesis)의 후속. 사용자 지니 directive 응답.
> **문제 정의:** 인쇄상품은 "주문제조 + 표면에 색/그림을 입히는" 방식이라 [자재]/[공정] 2축만으로는 정리가 안 된다.
> 색·사이즈·각인·부속·표면처리·묶음을 [자재 / 공정 / 선택옵션 / variant SKU / 별도상품 / 세트] 중 무엇으로 가를지가 미정.
> **권위 순서 [HARD]:** 0. 상품 정체(huniprinting.com) > 1. 엑셀 L1 > 2. webadmin 적재 > 3. 스키마 설계의도 > 4. 도메인 > 5. 라이브(피고).
> **경쟁사 = 갭헌팅용(답습 금지)** — 후니 8그릇이 경쟁사 표현력을 흡수/능가하는지 확인하고 부족분만 채운다.
> **추정 0** — 미지는 가설 + 출처 + 컨펌ID. 표준 충돌 시 후니 권위.
>
> **언어:** 서술 한국어, 식별자/컬럼/코드/t_*/SQL = English.

---

## 0. 핵심 통찰 — 왜 2축으로 정리가 안 되는가 (사용자 통찰 정형화)

후니 8그릇은 사실 **두 개의 직교 질문**에 답한다. 이것을 분리하지 않아서 정리가 안 됐다.

1. **"이 속성은 무엇의 변형인가" (생산 BOM 축)** — 자재(`t_mat_materials`)냐 공정(`t_proc_processes`)이냐. 물리적으로 *무엇을 사서/만들어* 표면에 색·그림을 입히는가.
2. **"고객은 이 변형을 어떻게 만나는가" (판매·선택 축)** — 고정 속성이냐, 선택옵션(`option_items`)이냐, 별도 SKU(variant=다른 차원행)냐, 별도 상품(`prd_typ`)이냐, 세트(`t_prd_product_sets`)냐, 추가상품(`t_prd_templates`)이냐.

> **결론 선언:** 한 속성(예: "빨간 볼펜에 각인")은 **두 축에서 각각 답이 있다**. "빨강"=① 자재의 본체색(BOM축) + ② 선택옵션 또는 별 variant(판매축). "각인"=① 공정(BOM축) + ② 선택옵션(판매축). **"자재냐 옵션이냐"는 잘못된 양자택일** — 자재(BOM)이면서 동시에 옵션(판매)일 수 있고, 후니 스키마의 `option_items.ref_dim_cd` polymorphic 포인터가 정확히 이 이중성을 위해 설계됐다(자재행을 가리키는 옵션). 이것이 사용자가 마련해 둔 "여러 그릇"의 정체다.

이 분리는 경쟁사 패턴과 완전히 일치한다(§1). 표준 e-commerce는 이를 **Product / Variant / Attribute / Option / LineItemProperty / Bundle** 6개 그릇으로 부르고, 후니 8그릇이 이를 모두 흡수한다(§6).

---

## 1. 경쟁사별 옵션 모델링 패턴 비교표

| 출처 | Product(별 상품) | Variant(별 SKU) | Option/Attribute(선택) | 개인화(각인·텍스트) | 묶음(Bundle) | 무효조합 | 색·형상 귀속 |
|------|---|---|---|---|---|---|---|
| **WowPress**(국내, 326상품 실캡처) | 거의 안 씀 — 한 prodno에 다축 | sizeno/paperno/colorno 조합 = 가격키(서버 동적견적) | 7 고정 의미축(ordqty·size·paper·color·prsjob·awkjob·option), 새 축 안 만들고 **흡수** | `optioninfo.optname`(각인=기타 가공옵션 flat) | `optioninfo`(쉬링크/수축포장 등 radio) | **행 인라인 `req_*`/`rst_*` 교차참조 + 최종판정=가격조회 실패** | **본체색=재질(paperinfo) · 형상=규격(sizeinfo)에 융합 · 인쇄면=도수(colorinfo)** |
| **RedPrinting**(사용자 본인 설계, 역공학) | 머그컵 종류(유광/무광/비어캔/변색)를 **별 상품으로 분리** | MTRL_CD×SIZ×도수 = 가격·캐스케이드 키 | 6 캐스케이드 제약(material→pcs disable, dosu↔bnc, size, essential/hidden, base) | 에디터 업로드(이미지) — 각인 별도옵션 미제공 | 명시 묶음옵션 없음 | **material→pcs disable rule**(저평량지 선택→코팅/후가공 일괄 비활성) | 종류=별 상품, 소재=MTRL_CD(자재), 도수=인쇄옵션 |
| **마플/마플샵**(국내 커스텀 굿즈) | 굿즈 종류별 상품(키링/폰케이스/텀블러…) | 사이즈·색상별 개별 옵션 설정 | 사이즈·색상 옵션, 1개부터 제작 | 에디터 디자인(이미지) | 단체티 5개+ 할인(수량구간, 묶음 아님) | (명시 없음) | 색상=선택옵션 |
| **Printful**(해외 POD) | Product=타입·모델·제조사 | **Variant ID = 정확한 size/color blank**(주문키, Product ID와 절대 혼동 금지) | 카탈로그 사전정의 variant만(자유생성 불가) | 별도 앱 필요(네이티브 미지원) | quantity만 다르면 variant | 카탈로그가 유효조합만 보유 | **색·사이즈=variant(각각 own SKU)** |
| **commercetools**(해외 CPQ 표준) | ProductType 기반 추상 부모(직접판매 불가) | **Variant=distinct SKU(sellable)** | Attribute는 ProductType 레벨 정의(size/color) | (excerpt 범위 밖) | (excerpt 범위 밖) | **100 variant/product 한계 → 초과 시 한 축을 별 Product로** | 색·사이즈=variant attribute, 차원 폭증 시 split |
| **Lasso / Webflow / commercetools 표준 룰** | 다른 구매의도·다른 가격로직·셀렉터 폭증 시 split | size·color·pack·material·flavor = variant(own SKU/price/inv) | "구매결정 바꾸는 속성만 selectable" | (variant 아님) | **조성 동일+수량만=variant / 조성 변경=별 listing** | **무효조합=rule로 인코딩(ghost SKU 금지)** | 비구매 속성(인증·내부코드)=metadata |
| **Shopify(개인화 표준)** | — | 재고 추적 필요 시 variant | 옵션앱(SKU 폭증 회피) | **각인·모노그램 텍스트 = line item property**(재고 무관, SKU 안 만듦) | 옵션값 조합 자동 variant 또는 bundle 앱 | conditional logic(앱) | 색=variant 또는 옵션 |

### 1.1 경쟁사 패턴의 단일 결론 4가지 (갭헌팅 추출)

1. **"별 SKU/가격/재고를 갖는가"가 variant vs option/attribute의 판별선이다.** (Lasso·commercetools·Printful 일치) — 색×사이즈가 각각 다른 가격·재고면 variant(own SKU), 아니면 단순 선택옵션.
2. **"본체색·형상은 새 축이 아니라 기존 물리축에 흡수한다."** (WowPress 핵심) — 본체색→재질행 합성, 형상→규격에 융합. **색을 무조건 color 옵션으로 떼면 WowPress보다 더 잘게 쪼개는 과분할.**
3. **"각인·커스텀 텍스트처럼 재고를 만들지 않는 개인화는 SKU/variant가 아니라 별도 그릇(line item property / optioninfo)으로 둔다."** (Shopify·WowPress 일치) — 각인은 공정(생산)이면서, 판매 측은 "재고 없는 옵션".
4. **"무효조합은 enumerate하지 않고 rule + 가격엔진 판정으로 닫는다."** (전원 일치) — WowPress=req_/rst_ 인라인+가격조회 실패, RedPrinting=disable rule, commercetools/Lasso=rule 인코딩, Shopify=conditional logic.

---

## 2. 역량질문 1~6 답변

### Q1. 색·사이즈·각인·부속·표면처리를 무엇으로 가를 판별 기준은?

**두 축을 따로 묻는 것이 답이다(§0).** 경쟁사 공통 판별 트리:

```
[축 A · BOM] 이 속성은 물리적으로 무엇인가?
  └ 사서/입고하는 블랭크·지종·부속 → 자재(t_mat_materials, usage_cd 슬롯)
  └ 표면에 가하는 가공(인쇄·코팅·박·각인·타공·제본) → 공정(t_proc_processes)
  └ 둘 다(아일렛=금속링+박는 타공) → 자재행 + 공정행 BUNDLE (후니 directive: 옵션=자재+공정 묶음)

[축 B · 판매] 고객은 이 변형을 어떻게 만나는가?
  └ 항상 고정(분기 없음) → 상품 속성(차원행 1개)
  └ 고객이 고르되 별 가격·재고 없음 → 선택옵션 (option_items → 차원행 포인터)
  └ 고객이 고르고 가격·재고·생산이 조합마다 다름 → variant SKU (별 차원행/조합)
  └ 재고를 만들지 않는 1회성 입력(각인 텍스트) → line item property 성격 (후니 GAP, §6)
  └ 별도 생산·포장·배송되는 독립 물건 → 별도 상품/추가상품(t_prd_templates) 또는 세트(t_prd_product_sets)
```

**판별 기준 우선순위(경쟁사 합의):** ① 별 가격/재고/생산 단위인가(→variant) ② 별도 배송 독립물건인가(→product/template) ③ 재고 만드는가(→variant) vs 안 만드는가(→option/property) ④ 구매결정을 바꾸는가(→selectable) vs 부수정보인가(→metadata).

### Q2. 복합 SKU(반팔티 "화이트M", 머그 "투명")를 격자분해 vs 단일유지 기준은?

**기준 = "그 조합 셀이 독립적으로 가격·재고·생산을 갖는가"** (Lasso·commercetools·Printful 만장일치).

- **반팔티 "화이트M"** = 색×사이즈 격자의 한 셀. 각 셀이 own SKU(재고·가격 다름)이면 **variant SKU로 유지**(격자로 분해해도 각 셀이 독립). 후니에서는 색=자재(본체색 재질행 합성, WowPress 패턴) × 사이즈=`t_prd_product_sizes`. 단 **"화이트M"을 한 덩어리 선택으로 파는** 후니 패턴이면, 이는 색·사이즈를 **두 독립 축으로 기계 분해하지 말고**(과분할), color×size **조합을 option_item 한 행**(또는 variant 1행)으로 합성해야 한다. → 후니 OM-2(굿즈파우치 size→option 재분류)와 동형: 옵션성 조합은 size 행 폭증 금지, 조합=option.
- **머그 "투명/반투명/화이트"** = RedPrinting 실증으로 **종류가 별 상품**(유광/무광/비어캔/변색 = 별 PRD). 인쇄가능영역·가격이 종류마다 달라 별 상품이 자연스럽다. 단 후니가 한 상품으로 보유하면 **소재=자재(본체색·재질 합성행)** 로 두고 옵션으로 노출. → "소재(자재)냐 선택옵션이냐"의 답: **둘 다 — 자재(BOM)로 등록하고 option_items로 선택 노출**(`ref_dim_cd=OPT_REF_DIM.03` 자재 포인터).

> **핵심:** 재고/가격/생산이 SKU 단위로 다르면 variant, 같으면 단일 상품+옵션. 후니는 variant를 **차원행 조합 + option_item 포인터**로 표현하지(별 PRD 폭증 회피), commercetools처럼 100 variant 한계로 split할 필요가 없다 — 후니의 차원행 모델이 더 능가.

### Q3. 각인/표면 색입힘처럼 자재·공정 경계가 모호한 것은 어디에?

**경쟁사 합의 = 공정(가공)이되, 개인화 입력(텍스트)은 재고 없는 별도 그릇.**

- **표면 색입힘(인쇄·별색·UV)** = 명백히 **공정**(`t_proc_processes`). WowPress=colorinfo(인쇄도수)+prsjobinfo(인쇄방식), RedPrinting=인쇄옵션. 본체색(블랭크 색)만 자재. → 후니 OM-5 정합: 별색=PROC_000007(clr_cd=NULL), UV=PROC_000002. **잉크색(인쇄)≠본체색(자재)** 분리가 핵심.
- **각인(engraving)** = ① BOM축: **공정**(`t_proc_processes` 신규 자식 — 레이저각인/형압). WowPress는 `optioninfo`(각인=기타가공 flat)에 둠. ② 판매축: **재고를 만들지 않는 선택옵션**(있음/없음) + **각인 텍스트는 line item property 성격**(Shopify 표준). → 각인 "여부/방식"=공정 option, 각인 "내용(텍스트)"=주문라인 메타(후니 GAP, §6 GAP-2).

### Q4. 묶음 판매(볼체인 색상 n개1팩)는 옵션인가 별 SKU인가 bundle인가?

**경쟁사 기준 = "조성이 같고 수량만 다르면 variant, 조성이 다르면 별 listing"**(Lasso). 볼체인은 **색×팩수량이 한 묶음 단위로 판매**되므로:

- **볼체인 "오렌지 3개1팩"** = 색상(본체색)이 곧 판매단위. 라이브는 이를 `t_mat_materials` MAT_TYPE.10 8색행으로 적재(F-PA-3, 색=자재 오염 판정). **정답 그릇:** WowPress 패턴이면 **본체색=재질행 합성**이 자연스럽다(과분할 아님 — 색이 물리 블랭크의 일부). 묶음수(3개1팩)는 `t_prd_product_bundle_qtys`. 즉 **볼체인은 (본체색=자재행) + (3개1팩=bundle_qty) + (8색 선택=option_items로 자재행 포인터)**. → **별 SKU도 bundle도 아닌, 자재행+묶음수+옵션 포인터의 결합**. 라이브의 "8색을 자재로 적재"는 **부분적으로 맞다**(자재행은 정당) — 다만 **묶음수가 siz_nm/mat_nm에 인코딩**(F-PA-3 "3개1팩"이 mat_nm에 융합)된 것은 OM-1형 오모델(묶음수→`bundle_qtys`로 분리해야).

> **컨펌 필요(Q-ACC-4):** 볼체인 8색이 각각 다른 가격·재고면 8 variant(자재행 유지 정당), 동일 가격이면 1 자재 + 색=option만으로 충분. 라이브 가격 미적재(PA-03)라 판정 불가 → 가격표 확인 후 결정.

### Q5. 기성품+추가상품 이중성격(카드봉투)을 한 상품 vs 두 레코드?

**경쟁사 기준 = "다른 구매의도·다른 판매맥락이면 split"**(Lasso). 카드봉투는 ① 단독 구매(기성상품) ② 다른 상품(엽서·캘린더)에 동봉되는 add-on, **두 구매맥락**이 실재한다.

- **경쟁사 패턴:** 동일 물건이 단독판매 + add-on이면, 표준은 **하나의 물리 SKU(블랭크)를 두 판매경로가 참조**한다(SKU는 1, 판매 listing은 2). commercetools=ProductType 1+ 여러 Product, Shopify=product+bundle 참조.
- **후니 라이브 실증(F-PA-1):** 카드봉투가 **두 번 등록** — PRD_000004(기성 PRD_TYPE.03) + PRD_000281/282/283(추가 PRD_TYPE.05, template base 겸). 그리고 `09_delete_dup_products.sql`이 281/282/283을 **삭제 제외 = 의도적 보존**.
- **판정:** 이중등록은 **의도(결함 아님)**이나, 경쟁사 best practice 대비 **물리 SKU 중복**(004와 281/282가 같은 봉투를 두 레코드로)이라 정합성 위험. **권고:** 봉투 자체는 **1 base 상품**(004) + **add-on은 `t_prd_templates`로 참조**(281/282를 별 PRD가 아닌 template SKU로). 색상(화이트/블랙)은 004에서 **option 또는 variant**로 통일(현재 004=siz 합성[OM-1 오모델] vs 281/282=별 PRD 불일치 해소). → **Q-ACC-5 컨펌:** 색상 분기 일원화 + 281/282를 template로 흡수할지(별 PRD 폐기) 여부.

### Q6. 위 답을 후니 8그릇 중 어디에 배정? GAP은?

§6 결정표 참조. **요지:** 후니 8그릇 = 경쟁사 6 표준 그릇(Product/Variant/Attribute/Option/LineItemProperty/Bundle)을 **전부 흡수하고 능가**한다(차원행+polymorphic option_item 포인터가 variant·attribute·option을 통합). **유일한 실 GAP 2건:**
- **GAP-1 (line item property = 각인 텍스트·주문 메모)** — 후니에 "재고 무관 1회성 주문입력값(각인 내용)" 그릇이 없다. 각인 *방식/여부*는 공정 option으로 되나, *텍스트 내용*은 주문라인 메타가 필요(현행 미보유).
- **GAP-2 (공정 param 보존 = OM-7/`ref_param_json`)** — 각인 위치·글자수·구수 같은 공정 파라미터 보존 메커니즘 미구현(기존 진단 재확인, 신규 아님).

---

## 3. 후니 그릇 배정 결정표 (속성유형 × 권고 그릇 × 근거 × GAP)

| 속성유형 | BOM축 그릇 | 판매축 그릇 | 근거(경쟁사·후니) | 후니 GAP |
|---|---|---|---|---|
| **본체색**(머그 투명·파우치 블랙·볼체인 오렌지) | `t_mat_materials`(재질행 합성, MAT_TYPE 본체) | `option_items` ref_dim_cd=03(자재 포인터) 또는 variant | WowPress 본체색=재질 / 사용자 "파우치는 이미 정답" | 없음(흡수) |
| **잉크색/인쇄색**(별색·UV·도수) | `t_proc_processes`(별색 PROC_000007 clr_cd=NULL) / `print_options`(도수) | `option_items` ref_dim_cd=04(공정) 또는 06(도수) | WowPress colorinfo/prsjobinfo · OM-5 | 없음 |
| **사이즈/형상**(반팔티 M·도무송 하트) | `t_siz_sizes`(치수형) / 칼틀 1:1(Q7) | `t_prd_product_sizes` + `option_items` ref_dim_cd=01 | WowPress 형상=규격융합 · OM-1 칼틀 | 없음 |
| **각인 방식·여부** | `t_proc_processes`(신규 자식: 레이저각인/형압) | `option_items` ref_dim_cd=04(있음/없음) | WowPress optioninfo · Shopify | 없음 |
| **각인 텍스트(내용)** | — (생산지시) | **line item property**(재고 무관 입력) | Shopify line item property | **GAP-1 (미보유)** |
| **부속**(아일렛 금속링·끈·거치대) | 붙는 자재=`t_mat_materials` + 박는 공정=`t_proc_processes` BUNDLE / 별물건=`t_prd_templates` | option_items(BUNDLE) 또는 addon | 사용자 directive 옵션=자재+공정 / option-vs-template 가이드 | 없음 |
| **표면처리**(코팅·라미·박) | `t_proc_processes`(Q2 박·Q9 코팅=공정) | `option_items` ref_dim_cd=04 | 실무진 Q2/Q9 확정 · WowPress awkjob | 없음 |
| **묶음판매**(볼체인 3개1팩·투명케이스 10개) | (자재행 + 수량) | `t_prd_product_bundle_qtys`(bdl_qty) | Lasso 조성동일+수량=variant / OM-1 묶음수 분리 | 없음(묶음수가 mat_nm에 융합된 오모델만 교정) |
| **복합 SKU**(화이트M 한덩어리) | 색=자재 × 사이즈=siz | **조합=option_item 1행**(축 분해 후 곱집합 금지) | commercetools variant / OM-2 size→option | 없음(흡수, variant=차원행 조합) |
| **기성+추가 이중**(카드봉투) | 봉투=1 자재/상품 | base PRD + `t_prd_templates`(addon 참조) | Lasso split기준 · F-PA-1 | 정합위험(중복 SKU) |
| **공정 파라미터**(각인 위치·타공 구수·오시 줄수) | `t_proc_processes` + param | 공정 1행 + `ref_param_json` | OM-7 · cpq-schema 🔴8 | **GAP-2(미구현)** |

---

## 4. 구체 케이스 권고

| 케이스 | 라이브 현황 | 경쟁사 렌즈 | 후니 권고 그릇 | 컨펌ID |
|---|---|---|---|---|
| **볼체인**(8색·3개1팩) | MAT_000202~209 8색행 MAT_TYPE.10 + "3개1팩"이 mat_nm에 융합 | WowPress 본체색=재질(정당) / Lasso 묶음=수량축 | **자재행 8색 유지**(본체색=재질 정당) + **묶음수 3개1팩 → `bundle_qtys`로 분리**(mat_nm에서 제거) + 8색 선택=`option_items`(ref_dim_cd=03) | Q-ACC-4 |
| **반팔티 "화이트M"** | (악세사리 시트엔 없음·굿즈파우치/어패럴 사례) | commercetools variant·100한계 split / Printful variant=color×size | 색=자재(본체색 합성) × 사이즈=siz, **조합=option_item 1행**(축 곱집합 폭증 금지·OM-2 교훈). variant 가격差=가격표 셀 | Q-ACC-2 |
| **머그컵 투명/반투명/화이트** | (굿즈파우치 GP-C-16 머그 ROOT 직결 변종) | RedPrinting=종류 별 상품 / WowPress=재질행 | 한 상품이면 **소재=자재(본체색·재질 합성행)** + option_items 노출. 가격·인쇄영역 크게 다르면 RedPrinting식 별 상품도 정당 | Q-ACC-2 |
| **빨간 볼펜 각인** | (악세사리 시트엔 직접 없음·도메인 사례) | Shopify=각인텍스트 line item property·각인여부 option | "빨강"=자재 본체색 / "각인 여부·방식"=**공정 option**(레이저각인 신규 PROC) / "각인 내용"=**line item property(GAP-1)** | Q-ACC-1 |
| **카드봉투 이중등록** | PRD_000004(기성) + 281/282/283(추가+template base), 삭제 제외=의도 | Lasso=구매맥락 split이되 물리SKU 1 / Shopify=product+bundle 참조 | 봉투 **1 base(004)** + add-on은 **`t_prd_templates`**로 참조(281/282 별 PRD 폐기 검토). 색상 분기 **004에서 일원화**(siz 합성[OM-1] 폐기→option/variant) | Q-ACC-5 |

---

## 5. 미해소 / 추가 컨펌 필요 항목

| ID | 컨펌 질문(비전문가용) | 막힌 이유 | 가설(출처) |
|---|---|---|---|
| **Q-ACC-1** | 볼펜·텀블러 등에 "각인 내용(이름·문구)"을 고객이 직접 입력받아야 하나요? 받는다면 그 텍스트는 어디에 저장하나요? | 후니에 "재고 없는 1회성 주문입력값" 그릇 부재(GAP-1) | 각인 여부/방식=공정 option, 텍스트=line item property 신규 필요(Shopify 표준) |
| **Q-ACC-2** | "화이트M 티셔츠", "투명 머그"처럼 색×사이즈(또는 종류)가 각각 **다른 가격·재고**를 갖나요, 아니면 같은가요? | 다르면 variant(차원행 조합), 같으면 단순 선택옵션 — 라이브 가격 미적재로 판정 불가 | 다르면 색=자재×사이즈=siz 조합=option_item, 같으면 1상품+옵션 |
| **Q-ACC-4** | 볼체인 8색이 색마다 **가격이 다른가요**? 묶음 "3개1팩"은 고정인가요, 고객이 개수를 고르나요? | 가격差·묶음 가변성에 따라 자재행/옵션/bundle 분기 | 8색 자재행 유지 + 묶음수=bundle_qty 분리(현재 mat_nm 융합 오모델) |
| **Q-ACC-5** | 카드봉투를 **하나의 상품**으로 관리하고 봉투가 필요한 다른 상품(엽서·캘린더)이 그걸 "추가상품"으로 부르게 할까요, 지금처럼 봉투를 여러 번 등록할까요? | 라이브 이중등록(의도)이나 물리 SKU 중복=정합 위험 | base 1 + template 참조(중복 제거)·색상 일원화 |
| **Q-ACC-6**(기존 재확인) | 복합 SKU가 **기성품 외에도** 존재하나요? (사용자 직접 질문) | 악세사리 시트는 부자재라 복합 SKU 없음 — 어패럴/굿즈파우치 시트가 후보 | 굿즈파우치 OM-2 폰기종×등급, 어패럴 색×사이즈가 복합 SKU 후보 |
| **GAP-1** | (구조) line item property 그릇 신설 — 각인 텍스트·주문 메모용 t_* 또는 주문 측 필드 | 후니 미보유(주문 측 스키마는 본 하네스 범위 밖) | 주문라인 메타 컬럼(dbm-ddl-proposer 또는 주문 스키마) |
| **GAP-2**(기존 OM-7) | (구조) `ref_param_json` 공정 파라미터 보존 — 각인 위치·타공 구수·오시 줄수 | 컬럼 미구현 | dbm-ddl-proposer(컬럼 추가 vs qty 재사용) |

---

## 6. 결론 — 후니 8그릇 ↔ 경쟁사 6 표준 그릇 매핑 (능가 입증)

| 경쟁사 표준 그릇 | 후니 그릇 | 흡수/능가 판정 |
|---|---|---|
| **Product**(별 상품·구매의도 split) | `t_prd_products.prd_typ_cd`(.03 기성/.05 추가) | 흡수 |
| **Variant**(own SKU=color×size 조합) | **차원행 조합**(sizes·materials·print_options) + `option_items` polymorphic 포인터 | **능가**(별 PRD 폭증·100한계 회피) |
| **Attribute**(ProductType 레벨 속성) | 차원 마스터(`t_siz_sizes`·`t_mat_materials`·`t_proc_processes`) | 흡수 |
| **Option**(selectable 선택) | `option_groups`→`options`→`option_items`(택1/택N, ref_dim_cd 7종) | 흡수 |
| **LineItemProperty**(각인텍스트·재고무관 입력) | **부재** | **GAP-1** |
| **Bundle**(조성동일+수량) | `t_prd_product_bundle_qtys` / 조성변경=`t_prd_product_sets`·`t_prd_templates` | 흡수 |

> **최종 선언:** 사용자가 마련해 둔 "선택(옵션)·상품(옵션)·가공(옵션)·추가(옵션)" 그릇 의도는 경쟁사 표준과 정확히 일치하며 **표현력에서 능가**한다. 부족분은 **line item property(각인 텍스트, GAP-1)** 단 하나의 실 GAP과, 기존 진단된 **공정 param 보존(GAP-2/OM-7)** 뿐이다. 나머지 색·사이즈·각인방식·부속·표면처리·묶음·복합SKU·이중성격은 모두 8그릇 안에 도출 가능하다 — **기계적 매핑이 아니라 "BOM축 1답 + 판매축 1답"의 이중 도출**로.

---

## Sources

- [Product Variant Modeling Rules for Ecommerce | Lasso](https://productlasso.com/en/blog/product-variant-modeling-rules) — variant vs split 판별, 무효조합 rule, 묶음 조성동일+수량 기준 (WebFetch 검증)
- [Products and Product Variants | commercetools](https://docs.commercetools.com/learning-model-your-product-catalog/product-modeling/products) — ProductType/Variant/Attribute 구분, 100 variant 한계→split (WebFetch 검증)
- [API Documentation | Printful](https://developers.printful.com/docs/) · [Printful API](https://www.printful.com/api) — Product vs Variant ID, variant=정확한 size/color blank
- [Navigate SKU Variations | ShipBob](https://www.shipbob.com/blog/sku-variations/) · [Create product options and variants | Webflow](https://help.webflow.com/hc/en-us/articles/33961334531347-Create-product-options-and-variants) — variant=own SKU/price/inventory
- [Adding Line Item Properties for Personalization | Shopify(gist)](https://gist.github.com/CarsonBain/8f206795a23514916405353c0c30e3fb) · [Shopify Variants vs Product Options Apps | Shop Circle](https://shopcircle.co/blogs/news/shopify-variants-vs-product-options-apps) — 각인/모노그램=line item property(SKU 안 만듦)
- [포토 머그컵 | 레드프린팅](https://www.redprinting.co.kr/ko/product/item/PH/PHMGDFT) — 머그 종류=별 상품, 사이즈/용량=하위옵션 (WebFetch 검증)
- [마플 | 커스텀 굿즈](https://apps.apple.com/kr/app/마플-나만의-굿즈를-3분만에-커스텀-해요/id1196659118) — 사이즈·색상 개별옵션, 1개부터, 단체티 수량할인
- **내부 권위(재인용):** `10_configurator/wowpress-option-model.md`(WowPress 6축 흡수·본체색=재질) · `huni-widget/02_analysis/cascade-rules.md`(RedPrinting 6 캐스케이드) · `10_configurator/option-vs-template-guide.md`(option/template 판별) · `17_correctness/product-accessory/product-identity.md`(F-PA-1~4 정체) · `00_schema/schema-design-intent-map.md`(OM-1~7·8그릇 설계의도·삼중바인딩)
