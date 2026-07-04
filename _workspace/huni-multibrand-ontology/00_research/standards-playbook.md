# 표준 어휘 플레이북 — 국제 인쇄표준·상위 온톨로지 어휘 사전 (§35 Phase 1)

> 작성: 2026-07-04 · mbo-standards-researcher (Phase 1 기준점 — 표준 어휘 1차 산출)
> 상위 원칙: `mbo-standards-research` 스킬(어휘만 차용·기술스택 미도입·§33 승계 우선·1차 출처 앵커).
> **[HARD] 이 문서는 §33을 원천 재사용·확장한다.** §33이 이미 도출한 표준 이름표를 원천으로 삼고(search-before-mint), 다중브랜드(와우 6+2축·quoted 가격)를 담기 위해 **부족한 상위 개념만** 보강한다. 신규 어휘는 표준 근거가 있을 때만.
> 아키텍처 중립: "§33 확장 vs 독립 §35 KB" 어느 쪽이든 재사용 가능하게 작성(결정=Phase 4 게이트 후).
>
> **읽는 법(비전문가용):** 후니·와우·레드 세 인쇄 브랜드를 한 우산에 묶으려면, 세 브랜드 위에 있는 "브랜드-중립 공통 개념"이 필요하다. 그 공통 개념을 아무렇게나 지어내면 편향되므로, 이미 30년간 검증된 국제 인쇄표준(CIP4/XJDF)·웹 커머스 표준(schema.org)·구성 지식 표준(구성 온톨로지)에서 **개념의 이름만** 빌려온다. 이 문서는 그 표준 개념들의 사전이다.

---

## 0. 승계 선언 — §33이 이미 확정한 것 (search-before-mint)

§33 `00_research/product-ontology.md`(렌즈 1)와 `02_ontology/ontology-schema.md`(§1 "표준 이름표" 열)가 **이미 도출·채택**한 표준 어휘를 이 문서의 기준선으로 승계한다. **재조사·재발명 금지.** 아래는 §33 채택 결과 요약(원천 = §33 product-ontology ② 판정표 A1~A12):

| 표준 | §33 판정 | 채택 범위 |
|---|---|---|
| **CIP4 XJDF Product Intent vs Process 2뷰 분리** | ✅ 채택(A1) | 최상위 축 = 고객 의도(옵션 레이어) / 생산 공정(공정 레이어) |
| **XJDF Intent 어휘**(MediaIntent·ColorIntent·LayoutIntent·BindingIntent·FoldingIntent·Imposition) | ✅ 채택(A2) | 영문 canonical 앵커(용어집 표준 표기) |
| **schema.org** Product·Offer·ProductGroup·variesBy·PriceSpecification | ✅ 채택(A3) | KB 명명 앵커 |
| **구성 온톨로지**(Soininen/Felfernig 6개념: component·attribute·resource·port·function·constraint) | ✅ 채택(A4) | CPQ 문서화 상위 프레임 |
| **EBOM/MBOM** | ✅ 채택(A5) | 셋트·반제품 구조 명명(무엇으로 vs 어떻게) |
| **PrintTalk**(RFQ→Quote→PO) | ⏸ 보류(A11) | 주문 체결 어휘 — §24 위임(다중브랜드 주문 확장 시 재소환) |
| JDF/XJDF XML 실구현·RDF/OWL·IOF/BFO·GoodRelations 원본 | ❌ 기각(A6~A9) | 어휘만, 기술 스택 미도입(§33 D-2 승계) |

**§35의 추가 임무** = 위 표준 어휘가 **세 브랜드**(특히 와우 6+2축·quoted 가격 메커니즘)를 담는지 점검하고, 담기 부족한 **상위 개념만** 보강(§3 델타).

---

## 1. 표준 개념 사전 — 1차 출처 앵커

각 표준 개념: 정의 → 상품/옵션/가격/구성요소/공정 중 어느 층 → 브랜드-중립 상위 개념 후보 → 1차 출처. badge: ✅=1차 스펙/공식 확인 · 🟡=2차 자료·candidate(정밀 열거 미확인) · ⚪=GAP.

### 1.1 CIP4 / XJDF — 인쇄 버티컬 표준 (가장 중요)

CIP4 = 인쇄 산업 공정 자동화 표준 단체. XJDF 2.x = 인쇄 작업(선행공정~후가공)을 기술하는 현대판 XML 표준. **핵심 = Product Intent(고객이 원하는 것·공정 중립) vs Process(공장이 하는 일) 2뷰 분리** — 온라인 인쇄(web-to-print)의 표준 접점은 Product Intent.

- 출처: [CIP4 공식](https://www.cip4.org/) · [XJDF Specification 2.2 PDF](https://www.cip4.org/files/cip4/documents/XJDF%20Specification%202.2.pdf) · [XJDF Specification 2.1 PDF](https://www.cip4.org/files/cip4-2022/Documents/Specifications/XJDF%20Specification%202.1.pdf) · [CIP4 JDF-Specification GitHub](https://github.com/cip4/JDF-Specification) (캡처 2026-07-04) · badge ✅(2뷰·Intent 자원명) / 🟡(하위 열거값 §1.1.x)

| Intent 자원 | 층 | 정의 | 상위 개념 후보 | 하위 열거값(확인 수준) |
|---|---|---|---|---|
| **MediaIntent** | 자재 | 용지/소재 의도(평량·재질·표면) | `MediaClass` | MediaType 등(정밀 미확인 🟡) |
| **ColorIntent** | 도수 | 색/도수 의도(NumColors 4/0·4/4, 별색) | `ColorSpec` | NumColors·양단면(§33 E5 대응) 🟡 |
| **LayoutIntent / FinishedDimensions** | 사이즈 | 접지·재단·제본 후 완성 치수·두께 | `DimensionSpec` | FinishedDimensions(재단)=작업 Dimensions와 구분 ✅ |
| **BindingIntent / @BindingType** | 공정(제본) | 제본 방식 의도 | `BindingType`(하위 유형 집합) | §1.1.1 열거값 🟡 |
| **FoldingIntent / FoldCatalog** | 공정(접지) | 접지 패턴 의도 | `FoldScheme` | §1.1.2 Fn-m 명명 🟡 |
| **(Finishing)Intent** 계열: HoleMakingIntent·LaminatingIntent 등 | 공정(후가공) | 타공·코팅 등 개별 후가공 의도 | `FinishingOp` | 개별 Intent 자원 다수 🟡 |
| **Imposition / number-up** | 공정(조판) | 한 판에 몇 개 앉히나(판걸이) | `ImpositionStrategy` | number-up·gang(§3 델타 핵심) 🟡 |

#### 1.1.1 BindingIntent BindingType 열거값 (🟡 candidate — 2차 교차확인)
JDF/XJDF `BindingIntent/@BindingType`이 취하는 값(2차 출처 = [PWG SM-JDFMap Best Practices PDF](https://ftp.pwg.org/pub/pwg/informational/bp-smjdfmap10-20170828-5199.6.pdf) 매핑표 교차확인, 1차 정밀 열거는 CIP4 스펙 PDF 직독 필요 = GAP-STD-1):
- `SaddleStitch`(중철) · `Perfect`(무선/떡제본 — SoftCover가 Perfect로 매핑) · `WireComb`(트윈링/스프링) · `Sewn`/`SideSewn`(사철) · `SideStitch`/`CornerStitch`(측면·모서리 철) · `HardCover`(양장) 등.
- **후니 제본 대응**(§33 docs/kb/01 §6): 무선=Perfect · 중철=SaddleStitch · 트윈링/스프링=WireComb · PUR=Perfect(PUR 변형) · 싸바리/양장=HardCover · D링=(바인더 — XJDF 표준 직대응 약함 🟡).
- **와우 제본 대응**(catalog 책자 awkjobinfo `제본` 그룹): 무선책자(40196)·중철책자(40198)·특가책자(스프링)(40433)·PVC커버노트(40525) → 각 BindingType에 매핑.

#### 1.1.2 FoldingIntent FoldCatalog 명명 규칙 (🟡 candidate)
`CIP4_FoldCatalog` = 접지 패턴을 표준 카탈로그명으로 지정. 명명 = **`F<페이지수>-<변형번호>`**(예 `F6-1`·`F6-2`·`F6-3`·`F8-2`·`F18-5`). 출처 = [PPM Application Note (PDF Association)](https://pdfa.org/wp-content/uploads/2024/05/PPM-ApplicationNote.pdf) · [XJDF for Developers (SlideShare)](https://www.slideshare.net/stefanmeissner/xjdf-for-developers-71324789) (캡처 2026-07-04). 후니 리플렛/접지(오시+접지 분해)·와우 접지류가 이 스킴의 상위 개념 `FoldScheme`로 정렬.

#### 1.1.3 Product View vs Process View (✅ 2뷰)
같은 인쇄물을 **Product Intent**(고객 의도·공정 중립)와 **Process**(공정 파라미터)로 나눠 기술. 출처 = [XJDF for Developers (CIP4 공식, Stefan Meissner)](https://www.slideshare.net/stefanmeissner/xjdf-for-developers-71324789) · [XJDF and Online Print](https://www.slideshare.net/slideshow/xjdf-in-the-online-print-business/86758857). **와우·후니 모두 "1옵션 ≠ 1공정"이 실증됨**(§3.3): 와우 `prsjob`(인쇄방식)·`awkjobinfo`(후가공 2단 중첩) = Process 성격이 고객 선택 축으로 노출.

### 1.2 schema.org — 웹 커머스 어휘 (LLM 공용어)

GoodRelations가 2012년 schema.org에 통합 → 오늘날 실무 기준. **Product(제품) vs Offer(가격 제안) 분리** = 후니 t_prd_* vs t_prc_* 분리와 동형.

- 출처: [schema.org/Product](https://schema.org/Product) · [schema.org/Offer](https://schema.org/Offer) · [schema.org/ProductGroup](https://schema.org/ProductGroup) · [schema.org/PriceSpecification](https://schema.org/PriceSpecification) · [schema.org/PropertyValue](https://schema.org/PropertyValue) (캡처 2026-07-04) · badge ✅(어휘 실재)

| schema.org 어휘 | 층 | 상위 개념 후보 | 다중브랜드 적합성 |
|---|---|---|---|
| **Product** | 상품 | `ProductConcept` | 후니 prd_cd · 와우 prodno 공통 그릇 ✅ |
| **ProductGroup / isVariantOf / variesBy** | 상품/축 | `VariantAxis` | "달라지는 축" 선언 = 후니 use_dims · 와우 6축 공통 ✅ |
| **Offer** | 가격 | `PriceOffer` | 정적 가격만 표현 — 동적 계산 불가(§1.4 한계) |
| **PriceSpecification / CompoundPriceSpecification / UnitPriceSpecification** | 가격 | `PriceSpec`(개념) | 합성 가격·수량 단가 개념 대응(실무 호환 아님·이름표용) |
| **additionalProperty (PropertyValue)** | 옵션/속성 | `AttributeValue` | 임의 옵션값 표현 — 와우 optioninfo/prodadd 흡수 후보 ✅ |
| **eligibleQuantity (QuantitativeValue)** | 수량 | `QuantityRule` | 후니 min/max/incr · 와우 ordqty min/max/interval 공통 ✅ |
| **category** | 분류 | `CategoryNode` | 후니 t_cat · 와우 category.path 공통 ✅ |
| **isAccessoryOrSparePartFor** | 부자재 | `AccessoryLink` | 후니 addon · 와우 prodaddinfo 공통 ✅ |

### 1.3 구성 온톨로지 (Soininen/Felfernig 6개념) — CPQ 지식 공용어

지식 기반 구성(knowledge-based configuration)의 학술 표준 개념 집합. 표현 형식은 여러 개나 **개념 집합은 하나**(학계 결론).

- 출처: [Towards a general ontology of configuration (ACM DL)](https://dl.acm.org/doi/abs/10.1017/S0890060498124083) · [Wikipedia — Knowledge-based configuration](https://en.wikipedia.org/wiki/Knowledge-based_configuration) · [Wikipedia — Configure, price and quote](https://en.wikipedia.org/wiki/Configure,_price_and_quote) (캡처 2026-07-04) · badge 🟡(6개념 2차 교차확인·원논문 유료 — §33 ④ 승계)

| 구성 온톨로지 개념 | 층 | 상위 개념 후보 | 후니/와우 대응 |
|---|---|---|---|
| **component (type)** | 상품 | `ProductConcept` | 후니 product · 와우 prodno |
| **attribute** | 옵션/축 | `VariantAxis` | 후니 option_group·print_option · 와우 size/color/paper 축 |
| **resource** | 자재/자원 | `MediaClass`·`ImpositionStrategy` | 후니 material·plate_size · 와우 paper·판걸이 |
| **port / connection** | 옵션값 참조 | `AxisValueRef` | 후니 option_item polymorphic ref · 와우 req_/rst_ 참조 |
| **function** | 용도/기능 | `IntentPurpose` | 후니 intent 축 · 와우 용도(경쟁분석 코퍼스) |
| **constraint** | 제약 | `CrossAxisConstraint` | 후니 constraint(CN-1~6) · 와우 인라인 req_/rst_ |

### 1.4 표준 한계 — 동적 가격은 브랜드-중립으로 "표준 없음" (핵심)

**두 브랜드 모두 가격을 불투명 서버 함수로 계산**한다(후니 `evaluate_price` · 와우 `POST /std/prod/jobcost` → `ordcost_bill`). schema.org Offer는 **정적 가격만** 표현 가능(AggregateOffer=범위 제시 한계). CPQ 상용 제품들도 가격 계산 엔진은 각사 고유(표준화 안 됨).
→ **상위 개념 `QuoteFunction`(동적 가격 계산 경계)은 표준 어휘가 없다** = 브랜드-중립적으로 확인된 표준 공백. 온톨로지는 가격 **축·구성요소 연결까지만** 담고 값 계산은 서버 권위(§33 D-18 = 와우 가격 메커니즘에서도 동형 확인). 출처: [schema.org/AggregateOffer](https://schema.org/AggregateOffer) · §35 `01_analysis/wowpress-price-mechanism.md` §1~6.

---

## 2. 인쇄 도메인 표준 개념 사전 (횡단 축)

세 브랜드 공통 인쇄 도메인 개념 = 표준 어휘 앵커(§33 axis KB 승계 + 와우 6축 대조):

| 도메인 축 | 표준 앵커 | 후니(§33 axis) | 와우(6+2축) |
|---|---|---|---|
| 사이즈/재단 | XJDF FinishedDimensions | `sizes.md`(작업 vs 재단) | `sizeinfo.sizelist`(sizeno·비규격 width/height) |
| 자재/용지 | XJDF MediaIntent | `materials.md`(mat_typ·usage) | `paperinfo.paperlist`(paperno·papergroup·pgram) |
| 도수/색 | XJDF ColorIntent | `print-options.md`(단/양면·도수) | `colorinfo.colorlist`(colorno·colornoadd 별색) |
| 인쇄방식 | XJDF Process View(Intent 아님·§3.1) | (§33 print_option에 접힘·"비절대축") | `prsjobinfo`(jobno·jobpresetno — **1급 축**) |
| 후가공 | XJDF Finishing Intent 계열 | `processes.md`(mand/base) | `awkjobinfo`(2단: jobgroup→awkjob) |
| 조판/판걸이 | XJDF Imposition/number-up | `plate-sizes.md`+fn_calc_pansu | `pjoin`(합판9/독판0/별도1) |
| 수량/건수 | schema.org eligibleQuantity | `quantities.md`(min/max/incr) | `ordqty`(select/input)·`coverinfo.pagecnt` |
| 제본 | XJDF BindingIntent(§1.1.1) | `processes.md` 제본류 | awkjobinfo `제본` 그룹 |
| 접지 | XJDF FoldingIntent(§1.1.2) | 리플렛(오시+접지 분해) | 접지류 awkjob |
| 분류 | schema.org category | `categories.md`(3단 트리) | category.path(47·1상품 1소속) |

---

## 3. 다중브랜드가 드러낸 표준 어휘 델타 (§33 대비 보강 필요분)

와우 증거가 §33 상위 개념으로 **흡수되는지** 점검한 결과 — 대부분 흡수되나(=§33 표준 채택이 브랜드-중립적으로 타당함을 재확인), 아래 6개는 상위 개념 보강이 필요.

### DELTA-1 [핵심] PrintMethod를 1급 상위 축으로 승격 필요
와우는 `prsjob`(인쇄방식: 합판/독판, 옵셋/디지털/UV/INDIGO/윤전 16종·`_cache/wow_domain_prsjob.csv`)을 **고객 선택·가격 결정·교차제약(req_color·rst_paper/awkjob) 보유 1급 축**으로 노출. §33은 인쇄방식을 E5 print_option에 접거나("도수·인쇄방식") "비절대축"으로 취급. 브랜드-중립 상위 개념 **`PrintMethodIntent`(= XJDF Process View 성격이나 web-to-print에서 고객 축으로 노출)** 신설 후보. → `upper-ontology-vocabulary.md` U-4.

### DELTA-2 합판/독판(gang-run vs dedicated)을 상위 개념으로 명시
와우 `pjoin`(0=독판·9=합판·1=별도)은 가격 경제(판 공유)를 결정하는 명시 축. §33은 판형/판걸이수(fn_calc_pansu)로 암묵 처리. 상위 개념 **`ImpositionStrategy`(XJDF Imposition/number-up·gang)** 로 양 브랜드 명시. → U-6.

### DELTA-3 교차축 인라인 제약(req_/rst_)의 세분성
와우는 각 옵션 항목에 `req_*`(필수조건)·`rst_*`(제약조건)을 인라인 부착(후가공은 rst_ 6종). §33 constraint(E12·CN-1~6)가 흡수하나, **세분 단위가 option-item**이라는 점 명시 필요. 상위 개념 `CrossAxisConstraint`(config-ontology constraint) 재사용 — 신설 아님, 세분성만 주석. → U-7.

### DELTA-4 동적 가격 = 단일 메커니즘(브랜드-중립 확인)
와우 catalog는 정적 가격표 0(전 326상품 requires-configuration)·"templated 6"도 실은 payload 템플릿(에러 상태). → **양 브랜드 공통 = 동적 API 계산 단일 메커니즘.** §33 D-18 경계가 브랜드-중립적으로 타당함을 재확인. 상위 개념 `QuoteFunction`(표준 어휘 없음·§1.4). → U-8.

### DELTA-5 부자재 2채널(prodaddinfo vs optioninfo)
와우는 부속을 `prodaddinfo`(다른 상품 참조·87상품)와 `optioninfo`(34상품) 2필드로. §33 has_addon(product→product)이 흡수하나 경계 불명확(GAP-STRUCT-2). 상위 개념 `AccessoryComponent`(schema.org isAccessoryOrSparePartFor·config-ontology optional component). → U-5.

### DELTA-6 상품 구성가능성 유형(configurability class)
와우 `selType`(M=구성형 311·S=단순 12)·후니 prd_typ(.01~.05). 양 브랜드 공통으로 "옵션 있는 구성상품 vs 단순 완제품"을 구분. 상위 개념 `ConfigurabilityClass`(config-ontology configurable vs non-configurable). → U-2 속성.

---

## GAP (정직 기록)

- **GAP-STD-1**: XJDF BindingIntent/@BindingType·FoldingIntent FoldCatalog **정밀 전체 열거값**은 CIP4 스펙 PDF(2.2, >10MB)를 WebFetch로 직독 실패 → 2차 자료(PWG 매핑·PPM 노트) 교차확인만(🟡 candidate). 정밀 매핑(무선=Perfect vs PUR 변형, D링 대응) 확정 시 스펙 PDF 직접 내려받아 대조 필요. §33 ④와 동일 GAP 승계.
- **GAP-STD-2**: PrintMethod(합판/독판·옵셋/UV/INDIGO)의 XJDF 정확한 자원 위치 미확정 — Process View의 어느 자원(DigitalPrinting·ConventionalPrinting Params)인지 1차 확인 안 됨. 상위 개념 `PrintMethodIntent`는 후보(🟡)로 두고 architect가 확정.
- **GAP-STD-3**: 레드프린팅 증거 미포함(이번 Phase 1 병렬 산출=와우만). 레드 3번째 브랜드는 §33 03_kb/03_레드프린팅_경쟁분석 코퍼스·향후 rpm 하네스 산출로 보강. 현 상위 어휘는 후니+와우 2브랜드 검증 = 상위 개념이 3브랜드로 무리 없이 확장되게 설계(architecture-neutral).
- **GAP-STD-4**: productontology.org 가동 여부·GS1 GPC/eCl@ss 인쇄 카테고리 코드 미조사(§33 ④ 승계) — 카테고리 외부 식별자 병기 필요 시 조사.

## Sources
- §33 `_workspace/huni-ontology-kb/00_research/product-ontology.md`(② 판정표 A1~A12·②-5 매핑표 — **1차 승계 원천**)
- §33 `_workspace/huni-ontology-kb/02_ontology/ontology-schema.md`(§1 표준 이름표 열·§6·D-19)
- §35 `_workspace/huni-multibrand-ontology/01_analysis/wowpress-structure.md`·`wowpress-price-mechanism.md`·`wowpress-catalog-map.md`(와우 6+2축·quoted 가격)
- [CIP4 XJDF Specification 2.2](https://www.cip4.org/files/cip4/documents/XJDF%20Specification%202.2.pdf) · [2.1](https://www.cip4.org/files/cip4-2022/Documents/Specifications/XJDF%20Specification%202.1.pdf) · [CIP4](https://www.cip4.org/) · [JDF-Specification GitHub](https://github.com/cip4/JDF-Specification) (캡처 2026-07-04)
- [PWG SM-JDFMap Best Practices](https://ftp.pwg.org/pub/pwg/informational/bp-smjdfmap10-20170828-5199.6.pdf) · [PPM Application Note](https://pdfa.org/wp-content/uploads/2024/05/PPM-ApplicationNote.pdf) · [XJDF for Developers](https://www.slideshare.net/stefanmeissner/xjdf-for-developers-71324789) (BindingType·FoldCatalog 2차 확인)
- [schema.org/Product](https://schema.org/Product)·[Offer](https://schema.org/Offer)·[ProductGroup](https://schema.org/ProductGroup)·[PriceSpecification](https://schema.org/PriceSpecification)·[PropertyValue](https://schema.org/PropertyValue) (캡처 2026-07-04)
- [Towards a general ontology of configuration (ACM DL)](https://dl.acm.org/doi/abs/10.1017/S0890060498124083)·[Knowledge-based configuration (Wikipedia)](https://en.wikipedia.org/wiki/Knowledge-based_configuration)
