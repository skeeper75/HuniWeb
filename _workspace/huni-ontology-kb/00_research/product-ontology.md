# 렌즈 1 — 제품/커머스 온톨로지 표준 리서치

> 작성: 2026-07-03 · 작성자: okb-methodology-researcher (렌즈 1 담당)
> 목적: "자연어 질의 → 상품 추천 → 가격 제시"를 위한 후니 온톨로지를 설계할 때, 이미 검증된 국제 표준(제품/커머스 온톨로지 · CPQ 지식 모델 · 제조 BOM · 인쇄 버티컬 CIP4)에서 무엇을 빌려오고 무엇을 버릴지 결정한 문서.
> 선행 입력(레포 1차 증거): `docs/kb/01~04`(260702 통화 정리) · `_workspace/excel-to-db/_meta/best-practices-playbook.md` · `_workspace/huni-dbmap/00_schema/schema-overview.md`·`cpq-schema.md`
>
> **용어 안내(비전문가용)**: "온톨로지(ontology)"란 어떤 분야의 개념(상품·자재·공정 등)과 개념 사이 관계를 컴퓨터가 이해할 수 있게 정리한 "개념 사전 + 관계 지도"다. "어휘(vocabulary)"는 그 사전에서 쓰기로 약속한 표준 낱말 목록이다.

---

## ① 핵심 발견 (실존 출처 포함)

### 1-1. GoodRelations / schema.org — 웹 커머스 어휘의 사실상 표준

- **GoodRelations**는 상품·가격·판매자·보증·배송을 웹에서 기술하기 위해 만들어진 전자상거래 온톨로지로, 2012년 11월부터 **schema.org에 거의 전부 통합**되어 schema.org의 공식 전자상거래 데이터 모델이 됐다. 즉 오늘날 실무 기준은 "GoodRelations 원본"이 아니라 **schema.org 네임스페이스**다.
  - 출처: [W3C Wiki — GoodRelations](https://www.w3.org/wiki/GoodRelations) · [GoodRelations and schema.org (공식 위키)](http://wiki.goodrelations-vocabulary.org/GoodRelations_and_schema.org) · [GoodRelations Language Reference (Hepp)](http://www.heppnetz.de/ontologies/goodrelations/v1.html)
- 핵심 구분: **Product(제품 그 자체)와 Offer(그 제품을 얼마에 팔겠다는 제안)를 분리**한다. 가격은 제품의 속성이 아니라 "제안"의 속성이다 — 이 분리는 후니의 "상품 정의(t_prd_*) vs 가격(t_prc_*)" 분리와 정확히 같은 사상이다.
  - 출처: [schema.org/Product](https://schema.org/Product) · [schema.org/Offer](https://schema.org/Offer)
- **ProductGroup / isVariantOf / variesBy**: "같은 상품인데 사이즈·색만 다른 변형(variant)들"을 묶는 표준 구조. ProductGroup(원형) ← isVariantOf ← 개별 Product, 그리고 variesBy로 "무엇이 달라지는 축인지"(사이즈·소재 등)를 선언한다. **"달라지는 축(차원)을 1급 개념으로 선언한다"**는 발상이 후니 use_dims(가격 차원 선언)와 동형이다.
  - 출처: [schema.org/ProductGroup](https://schema.org/ProductGroup) · [Google 검색센터 — Product Variant 구조화 데이터](https://developers.google.com/search/docs/appearance/structured-data/product-variants)
- 가격 표현: [schema.org/AggregateOffer](https://schema.org/AggregateOffer)(최저~최고가 범위)와 priceSpecification(수량 조건부 가격 등)이 있으나, **전부 "정적으로 미리 써 둔 값"만 표현 가능**하다. 후니처럼 옵션 선택에 따라 서버가 계산하는 동적 가격(evaluate_price)은 schema.org로 표현할 수 없다(범위 제시용 AggregateOffer 정도가 한계).
- **Product Types Ontology(productontology.org)**: 위키피디아 문서 하나하나를 상품 유형 식별자로 쓰는 보조 서비스. "명함", "스티커" 같은 상품 유형에 전 세계 공용 식별자를 붙일 수 있다.
  - 출처: [productontology.org](http://www.productontology.org/) (운영 상태는 ④ 미확인 참조)

### 1-2. CPQ 지식 모델링 — 학술 표준 개념어가 이미 존재한다

- CPQ(Configure-Price-Quote, 구성-가격-견적)의 뿌리는 1990년대 "지식 기반 구성(knowledge-based configuration)" 연구다. 구성 엔진의 계열은 규칙 기반 → 제약 만족(constraint satisfaction, "이 조합은 안 됨"을 수학적으로 푸는 방식) → 결정 트리 등으로 발전했다.
  - 출처: [Wikipedia — Configure, price and quote](https://en.wikipedia.org/wiki/Configure,_price_and_quote) · [Wikipedia — Knowledge-based configuration](https://en.wikipedia.org/wiki/Knowledge-based_configuration)
- **Soininen & Tiihonen 등의 "구성의 일반 온톨로지"(1998)**: 구성 지식을 표현하는 표준 개념 집합을 제시 — **component(부품)·attribute(속성)·resource(자원)·port(연결점)·function(기능)·constraint(제약)**. 연결 기반·구조 기반·자원 기반·기능 기반 등 모든 구성 접근법을 포괄한다. 이 6개 개념어는 지금도 CPQ 지식 모델의 공용어다.
  - 출처: [Towards a general ontology of configuration (ACM DL)](https://dl.acm.org/doi/abs/10.1017/S0890060498124083) · [Semantic Scholar 항목](https://www.semanticscholar.org/paper/Towards-a-general-ontology-of-configuration-Soininen-Tiihonen/2476879d7e6a3f53fedd2ca104c6f63cda0035f7)
- Felfernig 계열 후속 연구는 이 온톨로지를 weight constraint rule(가중 제약 규칙)로 통일 표현하거나 OWL(웹 온톨로지 언어)로 옮기는 작업을 했다 — 즉 "**표현 형식은 여러 개지만 개념 집합은 하나**"라는 것이 학계의 결론.
  - 출처: [Unified configuration knowledge representation using weight constraint rules](https://www.academia.edu/74593835/Unified_configuration_knowledge_representation_using_weight_constraint_rules) · [Product configuration knowledge modeling using ontology web language (ScienceDirect)](https://www.sciencedirect.com/science/article/abs/pii/S0957417408002418)

### 1-3. 제조 BOM 온톨로지 — EBOM/MBOM 구분과 IOF

- **BOM(Bill of Materials, 자재 명세서)** 업계 표준 구분: **EBOM(설계 BOM: 제품이 무엇으로 이루어졌나) vs MBOM(제조 BOM: 실제로 어떤 순서·공정으로 만드나)**. "같은 제품을 보는 두 개의 시선"을 분리하는 것이 정석이다.
  - 출처: [OpenBOM — Bill of Materials Types, Formats and Examples](https://www.openbom.com/blog/bill-of-materials-types-formats-and-examples)
- **IOF(Industrial Ontologies Foundry, 산업 온톨로지 재단)**: 제조업 전반의 상호운용 온톨로지 묶음을 만드는 컨소시엄. 최상위에 BFO(Basic Formal Ontology)를 두는 계층 구조.
  - 출처: [The IOF Core Ontology (NIST)](https://tsapps.nist.gov/publication/get_pdf.cfm?pub_id=935068) · [IOF 소개 (OntoLearner Docs)](https://ontolearner.readthedocs.io/benchmarking/industry/iof.html) · [MESA 블로그 — Working Towards an Industrial Ontology Foundry](https://blog.mesa.org/2017/03/working-towards-industrial-ontology.html)
- 생산 워크플로우를 온톨로지로 표현하는 최근 연구도 존재하나, 전부 대규모 다공장·다시스템 상호운용이 목적이다.
  - 출처: [Ontology-based knowledge representation of industrial production workflow (ScienceDirect)](https://www.sciencedirect.com/science/article/pii/S1474034623003130)

### 1-4. 인쇄 버티컬 표준 — CIP4 JDF/XJDF/PrintTalk (가장 중요한 발견)

- **CIP4**는 인쇄 산업 공정 자동화 표준 단체. **JDF(Job Definition Format, 작업 정의 형식)**는 XML 기반으로 인쇄 작업 전체(선행공정~후가공)를 기술하는 표준이고, **XJDF 2.x**가 현대판이다.
  - 출처: [CIP4 공식](https://www.cip4.org/) · [CIP4 GitHub](https://github.com/cip4)
- **★핵심 개념 — Product Intent(제품 의도) vs Process(공정)의 2뷰 분리**: XJDF는 같은 인쇄물을 **"고객이 원하는 것"(Product View: 무엇을 만들지 — 공정 중립적)**과 **"공장이 하는 일"(Process View: 어떻게 만들지)**로 나눠 기술한다. 온라인 인쇄(web-to-print)에는 Product View가 표준 접점이다. 이는 docs/kb/01 §5.1의 통화 결론 — **"1옵션 ≠ 1공정, 옵션 레이어(고객)와 공정 레이어(생산)를 분리하라"** — 와 정확히 같은 구조로, 우리가 통화에서 독자적으로 도달한 결론이 국제 표준의 30년 축적과 일치함을 확인해 준다.
  - 출처: [XJDF for Developers (CIP4 공식 자료, Stefan Meissner)](https://www.cip4.org/files/cip4-2022/Documents/Workflow%20Automation/Presentations/XJDF%20for%20Developers.pdf) · [XJDF and Online Print (SlideShare)](https://www.slideshare.net/stefanmeissner/xjdf-in-the-online-print-business)
- Product Intent의 세부 어휘: **MediaIntent(용지/소재 의도), LayoutIntent(마감 치수 — 접지·재단·제본 후의 완성 크기와 두께), BindingIntent(제본 의도), ColorIntent(도수/색 의도)** 등 — 후니 docs/kb 개념(재단사이즈·책등 두께·제본 방식·도수)의 표준 대응어가 전부 존재한다. PDF 안에 인쇄 제품 메타데이터를 심는 PPM(Print Product Metadata) 표준도 같은 어휘를 쓴다.
  - 출처: [PPM Application Note (PDF Association)](https://pdfa.org/wp-content/uploads/2024/05/PPM-ApplicationNote.pdf) · [PDF metadata and its conversion to XJDF (ResearchGate)](https://www.researchgate.net/publication/328672562_PDF_METADATA_AND_ITS_CONVERSION_TO_XJDF)
- **PrintTalk**: JDF를 감싸는 "비즈니스 봉투" — 견적요청(RFQ)·견적(Quote)·주문·주문상태·송장 등 **인쇄 전자상거래의 거래 문서** 표준. "제품 기술은 JDF, 거래는 PrintTalk"이 공식 역할 분담. 무료 공개 스펙.
  - 출처: [CIP4 — What is PrintTalk](https://www.cip4.org/print-automation/print-talk) · [PrintTalk Specification GitHub](https://github.com/cip4/PrintTalk-Specification) · [PrintTalk 1.5 발표 기사 (Printing Impressions)](https://www.piworld.com/article/cip4-releases-printtalk-1-5-specification-print-industry-web-automation/)

### 1-5. 표준들 사이의 자리 배치 (이번 렌즈의 종합 그림)

```
schema.org Product/Offer/ProductGroup   ← 바깥(웹·검색엔진·LLM)에 상품을 알리는 어휘
        │
Soininen/Felfernig 구성 온톨로지 6개념   ← CPQ 지식 구조를 부르는 학술 공용어
(component·attribute·resource·port·function·constraint)
        │
CIP4 XJDF Product Intent / Process      ← 인쇄 도메인 전용 어휘 (옵션↔공정 2뷰)
CIP4 PrintTalk                          ← 견적·주문 거래 문서 어휘
        │
EBOM/MBOM (BOM 업계 표준)               ← "무엇으로 vs 어떻게" 분리 명명
        │
후니 t_* 34테이블 + docs/kb 도메인 사전  ← 실물 (아래 ②-5 매핑 표)
```

---

## ② 후니 적용 권고 (채택/기각/보류 + 이유)

후니 규모 전제: **상품 283개 · t_* 34테이블 · 단일 운영자 · git 레포 파일 기반** — "표준의 개념은 빌리되, 표준의 무거운 기술 스택(XML/RDF/추론기)은 들이지 않는다"가 전 항목의 공통 판단 기준이다.

| # | 항목 | 판정 | 이유 |
|---|------|------|------|
| A1 | **XJDF의 "Product Intent vs Process" 2뷰 분리를 온톨로지 최상위 구분으로 채택** | ✅ 채택 | 통화 결론(1옵션≠1공정, docs/kb/01 §5.1)과 국제 표준이 독립적으로 일치 — 가장 신뢰할 수 있는 설계 축. KB 페이지 뼈대를 "고객 의도(옵션 레이어) / 생산 공정(공정 레이어)" 2단으로 나누고, 옵션→공정 매핑을 1급 관계로 둔다. |
| A2 | **XJDF Intent 어휘를 시드 용어집의 영문 canonical(표준 표기)으로 채택** | ✅ 채택 | docs/kb/03 §4.1 파이프라인의 [Seed 용어집]에 영문 축이 필요하다. 재단사이즈=FinishedDimensions, 제본=BindingIntent, 소재=MediaIntent, 도수=ColorIntent, 조판=Imposition/number-up 등 — 경쟁사 표기 다양성(모서리=귀돌이 등)을 정렬할 때 "이 클러스터의 표준명"으로 쓸 중립 앵커가 생긴다. XML 문서 형식 자체는 쓰지 않는다(A6). |
| A3 | **schema.org Product/Offer/ProductGroup을 KB 페이지의 명명 앵커로 채택** | ✅ 채택 | 비용이 거의 0(이름만 빌림)이고, 미래에 LLM이 KB를 읽을 때 schema.org는 모든 LLM이 학습한 어휘라 자연어 질의 해석에 유리. "상품=Product, 셋트 완제품=Product+hasPart, 가격 제안=Offer, 변형 축=variesBy" 수준의 대응만 문서에 명시한다. |
| A4 | **Soininen/Felfernig 6개념(component·attribute·resource·port·function·constraint)을 CPQ 문서화의 상위 프레임으로 채택** | ✅ 채택 | 우리 CPQ 3계층(option_groups/options/option_items)+제약(constraints)이 학술 표준의 어느 개념인지 이름표를 달면, 외부 자료·논문·경쟁사 분석을 읽을 때 번역이 자동으로 된다. 표(②-5)로 1회 매핑해 두면 유지비 0. |
| A5 | **EBOM/MBOM 명명을 셋트·반제품 구조 설명에 채택** | ✅ 채택 | t_prd_product_sets(무엇으로 구성)=EBOM 시선, t_prd_product_processes+옵션→공정 분해(어떻게 만드나)=MBOM 시선. 이미 존재하는 구조에 업계 표준 이름을 붙이는 것뿐이라 비용 0, MES 논의(§24·일정관리) 때 실무진·개발자와의 공용어가 된다. |
| A6 | **JDF/XJDF XML 실구현(파서·JDF 파일 생성)** | ❌ 기각 | 후니는 CIP4 장비 연동(프리프레스 워크플로·MIS)이 현안이 아니다. XML 스택 도입은 단일 운영자 규모에 과잉. 개념·어휘만 차용(A1·A2). MES 연동이 실제 장비 표준을 요구하는 시점에 재평가. |
| A7 | **RDF/OWL 트리플스토어 + 추론기(reasoner) 도입** | ❌ 기각 | 이 레포의 실증이 우선한다: §9 위키(파일 기반, Karpathy 모델)+관계형 DB(t_*)+결정론 스크립트 조합이 이미 작동 중. 283상품 규모에서 트리플스토어는 운영 부담(서버·질의어 SPARQL 학습)만 추가하고 얻는 것이 없다. 온톨로지는 **markdown 파일 + 구조화 표 + frontmatter**로 표현한다(형식은 설계자 결정 항목 ③-3). |
| A8 | **GoodRelations 원본 어휘 직접 사용** | ❌ 기각 | 공식 문서 스스로 "schema.org 네임스페이스가 실무 기본"이라고 안내([근거](http://wiki.goodrelations-vocabulary.org/GoodRelations_and_schema.org)). schema.org만 참조하면 충분(A3). |
| A9 | **IOF/BFO 정렬(우리 개념을 BFO 최상위 온톨로지에 맞추는 작업)** | ❌ 기각 | BFO 정렬은 다기관 상호운용이 목적인 학술·대기업용 투자. 후니는 상호운용 대상이 자기 자신(라이브 DB·위키·위젯)뿐이다. |
| A10 | **schema.org 마크업 실제 발행(쇼핑몰 페이지에 JSON-LD 삽입)** | ⏸ 보류 | 검색엔진 노출(SEO)에 실익이 있으나 이는 §28 런칭 트랙의 일이지 온톨로지 KB 구축의 일이 아니다. 온톨로지가 schema.org 명명 앵커(A3)를 갖고 있으면 나중에 자동 생성 가능 — 지금은 문서 대응표만. |
| A11 | **PrintTalk 거래 문서 모델(RFQ→Quote→PO)** | ⏸ 보류 | 견적·주문 흐름 어휘의 표준이므로 §24(Shopby 장바구니→주문 통합)의 설계 어휘로 가치가 있으나, 이번 KB의 범위(상품 추천·가격 제시)보다 한 단계 뒤(주문 체결)다. 스펙이 무료 공개이므로 §24 재실행 시 입력으로 넘긴다. |
| A12 | **productontology.org 상품 유형 식별자** | ⏸ 보류 | 상품 유형에 위키피디아 기반 공용 식별자를 붙이는 아이디어는 좋으나 서비스 지속성 미확인(④). 대신 같은 발상 — "**상품군마다 정의 문서(위키 페이지)를 식별자로 삼는다**" — 은 §9 위키가 이미 실현 중이므로 내부 식별자로 충분. |

**레포 실증 우선 원칙 확인**: 외부 표준 중 이 레포에서 반증된 것은 없음. 반대로 XJDF 2뷰 분리·Product/Offer 분리·variesBy 차원 선언은 레포가 이미 실전으로 도달한 구조(옵션↔공정 분리·t_prd/t_prc 분리·use_dims)와 **수렴**한다 — 표준 채택이 아니라 "표준과의 일치 확인 + 명명 정렬"이 이번 작업의 본질이다.

### ②-5. 매핑 표 — 후니 실물 ↔ 표준 개념 대응

(설계자가 KB 페이지 frontmatter/용어집에 그대로 옮겨 쓸 수 있는 형태. 좌측=우리 것, 우측=표준 이름표.)

**(a) 상품·구조 계층 (t_prd_* ↔ schema.org / BOM / 구성 온톨로지)**

| 후니 실물 (테이블/개념) | schema.org | 구성 온톨로지 (Soininen/Felfernig) | BOM/기타 |
|---|---|---|---|
| `t_prd_products` (상품 마스터, prd_cd) | Product | component type | — |
| 완제품(.01) 일반 단일 | Product (판매 가능) | configurable product | — |
| 셋트 완제품(.01, sets 부모) | Product + hasPart | composite component | EBOM 부모 |
| 반제품(.02, 셋트 구성원) | — (단독 Offer 없음) | sub-component | EBOM 자식 |
| 기성상품(.03, 제조 없음) | Product (단순 Offer) | non-configurable | 구매품(Purchased part) |
| 추가상품(.05, addon) | isAccessoryOrSparePartFor(유사) | optional component | — |
| `t_prd_product_sets` (부모↔구성원, sub_prd_qty) | hasPart / isPartOf | part-of structure | **EBOM**(무엇으로 구성) |
| `t_prd_product_sizes`·`t_siz_sizes` | variesBy(size 축) + width/height | attribute (값 영역=사이즈) | XJDF LayoutIntent **FinishedDimensions**(재단=완성 치수) |
| 작업사이즈 vs 재단사이즈 (docs/kb/01) | — | — | XJDF Dimensions(작업) vs FinishedDimensions(재단) |
| `t_prd_product_materials`·`t_mat_materials` | material 속성 / variesBy(material) | resource(소재) | XJDF **MediaIntent** |
| `t_prd_product_print_options`(도수)·`t_clr_color_counts` | — | attribute | XJDF **ColorIntent**(NumColors — 4도=4/0, 양면=4/4) |
| 제본(무선·중철·트윈링·D링·PUR — docs/kb/01 §6) | — | attribute + constraint | XJDF **BindingIntent** |
| 책등 두께=내지 사양의 함수 (docs/kb/01 §6) | — | **derived attribute**(파생 속성 — 표준 개념 실재) | LayoutIntent thickness |
| `t_prd_product_plate_sizes`+`fn_best_plate` (판형 자동선택) | — | resource 선택 규칙 | JDF/인쇄: 출력용지(press sheet) 선택 |
| 판걸이수 `fn_calc_pansu`·`t_siz_pansu` (조판) | — | resource 소요량 계산 | JDF **Imposition / number-up**(한 판에 몇 개) |
| `t_prd_product_processes`·`t_proc_processes` (후가공) | — | function→process 매핑 | XJDF Process View · **MBOM**(어떻게 만드나) · FoldingIntent/HoleMakingIntent 등 개별 Intent |
| 1옵션→N공정 분해 (접지=오시+접지) | — | function(고객 기능)↔process(공정) 분리 | **XJDF 2뷰(Intent vs Process)의 핵심 사례** |

**(b) CPQ 3계층 + 제약 (라이브 CPQ ↔ 구성 온톨로지)**

| 후니 실물 | 구성 온톨로지 표준 개념 | 비고 |
|---|---|---|
| `t_prd_product_option_groups` (sel_typ·min/max_sel·mand_yn) | attribute 정의(선택 축) | schema.org variesBy에 해당하는 "달라지는 축" 선언 |
| `t_prd_product_options` / `t_prd_product_option_items` (ref_dim_cd+ref_key1/2) | attribute의 value domain(허용 값 목록) — 값이 소재/사이즈/공정 실물을 가리키는 polymorphic 참조 | 표준에서도 "값=다른 component/resource 참조"가 정석(port/connection) |
| `t_prd_templates`·`t_prd_template_selections`·`t_prd_product_addons` | 사전 구성(predefined configuration) — 표준의 "패키지/번들" | schema.org로는 별도 Product+Offer |
| `t_prd_product_constraints` (JSONLogic)·`constraint_json` | **constraint** — 제약 만족(CSP) 계열 | §31 CN-1~CN-6 분류는 표준 제약 유형(불가·필수동반·상호배제·범위)과 일치 |
| `t_prd_product_process_excl_groups` (공정 택일) | 상호배제 constraint (exclusive) | — |
| 옵션 4용도·색상 코딩(빨강/주황/회색 — docs/kb/02 §3) | 고객 노출 attribute vs internal attribute | XJDF에도 고객 Intent vs 내부 Process 파라미터 구분이 대응 |

**(c) 가격 계층 (t_prc_*/t_dsc_* ↔ schema.org / CPQ)**

| 후니 실물 | 표준 대응 | 정직한 한계 |
|---|---|---|
| `t_prc_price_formulas`+`evaluate_price` (공식 기반 동적 계산) | — **표준 어휘 없음** | schema.org Offer는 정적 가격만 표현. CPQ 상용 제품들도 가격 계산은 각사 고유 엔진(표준화 안 됨). 온톨로지는 가격의 **차원과 구성**만 기술하고 계산은 evaluate_price 블랙박스로 두는 것이 정합 |
| `t_prc_price_components`·`formula_components` (구성요소·배선) | CompoundPriceSpecification(합성 가격 명세)에 개념적 대응 | 개념 유사할 뿐 실무 호환 아님 — 이름표 용도로만 |
| `t_prc_component_prices`의 use_dims(차원 선언) | variesBy와 동형(가격이 달라지는 축 선언) | 후니 것이 더 정밀(단가행 차원 환원) |
| `t_dsc_discount_tables/details` (수량구간 할인) | Offer의 eligibleQuantity + UnitPriceSpecification(수량 조건 단가) | 구간(tier) 표현은 가능하나 조회 규칙까지는 표준 밖 |
| 아키타입 3종(원자합산/고정가/매트릭스 — docs/kb/02 §2) | — 표준 없음(후니 고유 자산) | `price_origin: negotiated`(협의가) 메타는 표준에도 없는 좋은 관행 — 유지 |
| 견적요청→견적→주문 흐름 | **PrintTalk**(RFQ·Quotation·PurchaseOrder) | §24 위임(A11) |

**(d) 분류 계층**

| 후니 실물 | 표준 대응 |
|---|---|
| `t_cat_categories` (3단 자기참조 트리) | schema.org category 속성 / 표준 분류체계(GS1 GPC·eCl@ss — ④ 미조사) |
| 상품 유형 5분류(.01~.05 — SOT) | 표준에 직접 대응 없음 — 후니 고유(EBOM 관점 주석만 부여, (a) 참조) |
| `t_cod_base_codes` (enum 사전) | 온톨로지의 controlled vocabulary(통제 어휘) 그 자체 |

---

## ③ 설계자(okb-ontology-architect)에게 넘길 결정 항목

1. **최상위 축 확정**: KB 온톨로지의 1층 구분을 XJDF식 2뷰(고객 의도 레이어 / 생산 공정 레이어)로 갈지, 기존 §9 위키 뼈대(정체→차원→BOM→가격사슬→CPQ→위젯→적재→결함 8단)를 유지하고 2뷰를 그 안의 관계 태그로만 둘지. **권고: 후자(§9 뼈대 유지 + 2뷰는 옵션↔공정 관계에 명시 태그)** — 기존 위키 자산 재사용 원칙.
2. **용어집 스키마 확정**: docs/kb/03 §4.2의 용어집(canonical_term/synonyms/definition/process_mapping)에 **영문 표준 앵커 컬럼 2개 추가**(schema_org_term·xjdf_term) 여부. 권고: 추가(비용 낮고 자연어 질의 해석에 직결).
3. **표현 형식**: RDF 기각(A7) 전제에서, markdown + YAML frontmatter(파일 머리의 구조화 메타데이터)로 갈지, frontmatter 없이 표만으로 갈지. 임베딩/그래프 탐색 렌즈(렌즈 3 GraphRAG)와 합의 필요.
4. **가격의 온톨로지 경계**: 가격 계산 로직 자체는 온톨로지 밖(evaluate_price 권위)으로 두고, 온톨로지는 "이 상품의 가격은 어떤 차원으로 달라진다(use_dims)"까지만 기술하는 경계 확정. 이 문서 ②-5(c)가 근거.
5. **매핑 표의 저장 위치**: ②-5 매핑 표를 KB의 횡단 축 페이지(예: `standards-mapping.md`)로 승격할지, 각 상품군 페이지에 분산할지. 권고: 횡단 1페이지(중복 금지).
6. **derived attribute(파생 속성) 관계 타입 신설**: 책등=내지 사양의 함수처럼 "다른 구성요소로부터 계산되는 속성"을 온톨로지 관계 타입으로 1급 등재할지(docs/kb/01 §6이 이미 "의존성 그래프 필요" 결론). 권고: 등재 — 표준(구성 온톨로지)에도 실재하는 개념.

---

## ④ 미확인 / 추가 조사 필요

- **XJDF 2.x 스펙 원문의 Intent 열거값 전수**(BindingIntent의 제본 유형 코드 목록 등)는 이번에 2차 자료(개발자 프레젠테이션·PPM 노트)까지만 확인. 정밀 매핑(무선=?, 싸바리=?)이 필요해지면 [CIP4 GitHub](https://github.com/cip4)/공식 스펙 PDF를 내려받아 대조해야 한다.
- **PrintTalk 1.5 Quote 메시지의 필드 상세** 미확인 — §24 재실행 시 [PrintTalk-Specification 레포](https://github.com/cip4/PrintTalk-Specification)에서 확인.
- **productontology.org 서비스의 현재 가동 여부** 미접속·미확인(검색 결과 존재만 확인).
- **GS1 GPC / eCl@ss에 인쇄물 카테고리 코드가 있는지** 미조사 — t_cat_categories에 외부 분류 코드를 병기할 필요가 생기면 조사.
- Soininen & Tiihonen 1998 논문 원문(전문)은 유료 장벽으로 초록·2차 자료 기반 — 6개념 목록은 복수 출처로 교차 확인됨.
- 국내 인쇄 업계에서 JDF/XJDF 실사용률(에디쿠스·레드프린팅이 내부적으로 쓰는지)은 공개 자료 없음 — 실무진(신우진) 확인 요청 후보.
