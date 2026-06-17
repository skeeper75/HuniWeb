# 발굴 축 (discovered-axes) — 7버킷 외 관리 메타모델

> rpm-metamodel-architect. 사용자 directive(HARD): **알려진 7버킷(자재/공정/옵션/템플릿/제약/기초코드/카테고리) 외에 더 많은 관리 축이 있는지 심도 발굴.**
> 입력 = BN(현수막류) 6상품 역공학(`01_reverse/`) + 인쇄 도메인 KB(`07_domain/`).
> 판정 기준(SKILL §3 distinctness test): **고유 속성/lifecycle/관계가 있어 기존 축이 왜곡 없이 못 담으면 distinct, 아니면 facet.**
> ⚠️ BN 단일 카테고리 추출 — 오버피팅 경계(SKILL §5): "한 상품만 필요한 축" 거부. distinct 판정은 *횡단 패턴 + 후니 도메인 동형*으로만.

---

## 발굴 결과 한눈에

7버킷은 "정적 객체 버킷"(무엇을 등록하나)에 치우쳐 있다. RedPrinting 역공학이 드러낸 추가 관리 축은 대부분 **관계·동역학 축**(객체들이 *어떻게 결합·게이팅·매개변수화되나*)이다.

| ID | 발굴 축 | distinct/facet | 한 줄 정체 | 7버킷 중 가장 가까운 것 | 왜 그것으로 안 되나 |
|---|---|:---:|---|---|---|
| **D-1** | 부속물(Addon) | **distinct** | 본체와 분리된 완제 부속 부품(거치대) | 템플릿/SKU·옵션 | 템플릿=묶음단위, 옵션=본체속성. 부속물은 독립 SKU·재고·본체 비귀속 |
| **D-2** | 자재 합성 & usage & 공정결합 | **distinct(메타규칙)** | MTRL_CD 다축 합성 + usage 슬롯 + 공정의 자재소비 | 자재 | 단순 자재 enum이 아니라 *합성 규칙*과 *공정↔자재 FK*가 본질 |
| **D-3** | 제약 논리유형(Constraint Logic) | **distinct** | disable/force/require/match/exclude/essential의 *유형화된 어휘* | 제약 | 7버킷 "제약"은 객체일 뿐, *논리 유형 거버넌스*가 누락 |
| **D-4** | 공정 파라미터(Process Parameter) | **distinct** | 공정 멤버에 종속된 매개변수 슬롯(줄수·mm·색·수량) | 옵션·공정 | 옵션=독립선택, 공정=멤버. 파라미터=부모공정 종속 자식 |
| **D-5** | 수량 모델(Quantity Model) | **distinct** | 건수×수량 다중 수량 슬롯 + 공정종속 수량 | 옵션(수량) | 단일 qty 스칼라로 평면화 시 가격 의미 소실 |
| **D-6** | 가격기여 역할(Pricing Role) | **distinct(횡단 메타)** | 각 선택이 가격에 *어떻게* 기여하는가(면적/곱수/고정/단가) | (7버킷 없음) | 7버킷 어디에도 "가격기여 방식" 축 부재 — RP는 price_flag로 전 축에 부착 |
| **D-7** | 인쇄방식/생산 레시피 | **distinct(조건부)** | 인쇄방식이 가능 공정·파일·팀을 게이팅 | 공정·기초코드 | RP는 자재 facet으로, 후니는 1급 레시피 축으로 — 게이팅 lifecycle 보유 |
| **D-8** | UI 런타임/표현 바인딩 | **facet(거부)** | Vue vs jQuery 두 런타임 | (없음) | 동일 base-data 모델 공유 → 관리 축 아님(표현 계층) |
| **D-9** | 생산형태(Production Type) | **distinct (GS v2.0)** | 완제품/반제품/통합/기성/디자인이 본체 모델링을 governing | 카테고리·템플릿 | 카테고리=기능 트리(직교), 템플릿=번들. 생산형태는 그 둘을 *governing*(본체=SKU vs 자재행 결정) |
| **D-10** | 본체 형태가공(Body Form-Assembly) | **distinct (GS v2.0)** | 평면→입체 본체를 *생성*하는 조립/봉제/지퍼 | 공정 | 일반 후가공=본체에 작업, 형태가공=본체 *생성*(없으면 본체 부재). lifecycle 구별 |
| **D-11** | 디자인 입력 채널(Design-Input Channel) | **distinct (TP v3.0)** | 디자인을 *어떻게 입력받나*(KOI/Edicus/PDF) — 본체 옵션 트리와 직교, 가격 0 | 템플릿/SKU·옵션·공정 | 옵션=본체속성·공정=본체작업·템플릿=완제번들. 입력채널은 본체와 무관·동종 비-TP와 옵션/가격 동일·`item_gbn` 게이팅 lifecycle 보유 |
| **D-12** | 형상(Shape) | **distinct (ST v5.0) ★16축 포화 붕괴** | 인쇄물 외곽 형상(SQ/CL/EL/RC/FR)이 *사이즈와 분리된 전용 enum 슬롯*으로 칼틀/사이즈 선택을 게이팅 | 사이즈#13·기초코드#6 | 사이즈#13은 형상을 *1:1 칼틀=사이즈 프리셋*으로만 흡수(어깨띠·GS THO_CUT·TP M/I). ST는 형상↔사이즈 **1:多**(한 형상 CL이 CL001~CL100 칼틀 enum span)·전용 `shape_info` 슬롯·5형상 superset(STDCFBR)·후니 KB가 size축 미수용(G-SK-2) 확증 |

**발굴 distinct 축 = 11개**(D-1~D-7 BN + D-9·D-10 GS + D-11 TP + **D-12 ST**), facet 강등 = D-8 + GS facet 4종(G-1/G-2/G-4/G-3) + TP facet 5종(T-A 템플릿자산·T-B VDP·T-C 페이지계층·T-D 형태variant·T-E 특수인쇄) + **PR facet 9종(P-1~P-9 전부·distinct 0)** + **ST facet 9종(S-2 칼선·S-3 재단입자·S-4 점착·S-5 인쇄방식·S-6 가격엔진·S-7 화이트강제·S-8 disable·S-9 넘버링·S-10 완제SKU)** + **CL facet 9종(C-1~C-9 전부·distinct 0·★의류 variant #18 부결)** + **AC facet 9종(A-1~A-9 전부·distinct 0·★가공방식 그룹핑 A-8 #18 부결)** + **PD facet 5종(PD-1~PD-5 전부·distinct 0·★완제 구조물 내재BOM PD-4 #18 부결)**. 7버킷 + 발굴 = **총 18 관리 축**(단 D-2는 자재 버킷 심화, D-6/D-7은 횡단). 메타모델 사전(`metamodel-dictionary.md`)은 **7 정적 축 + 4 관계/동역학 축 + 2 횡단 축 + GS 신축 2(#14·#15) + TP 신축 1(#16) + ST 신축 1(#17 형상) = 17 dictionaried 축**으로 정리(D-8 제외). **8 상품군(BN·GS·TP·PR·ST·CL·AC·PD) 증거로 검증 — PR distinct 0(4군 포화)→ST distinct 1(형상·5군 포화 붕괴)→CL distinct 0(6군 재포화)→AC distinct 0(7군 재포화·신규 강후보 A-8 무손실 흡수)→PD distinct 0(8군 재포화·봉제 구조물 완제품·PD-4 완제 내재BOM 부결)=모델은 카테고리 증거에 정직.**

> **★v8.0 (PD 통합) 핵심 판정 — 17축 재포화(distinct 0·PR·CL·AC 패턴 반복·★완제 구조물 내재BOM PD-4 #18 부결):** PD(스툴·슬리퍼·강아지계단 = 봉제 구조물/3D 조립 완제품) 역공학의 5 fragment(PD-1~PD-5) 적대 판정 — **distinct 승급 0종·전부 facet.** PD reverse가 1차 예측한 "distinct 0(8번째 재포화)"를 비준 — 가장 이질적인 *봉제 구조물 완제품*조차 17축 무손실 흡수. ★directive 최대 관전(조립·구조·3D폼·완제 내재BOM이 distinct #18인가) 적대 판정: **(PD-1 봉제/제품가공=본체 형태가공#14[GS D-10] 봉제 family 신규 멤버**·SEW_LTR=새 멤버·PDWRSLP PDT_WRK=GS 동일 코드·기존 PCS 슬롯 인코딩) · **(PD-2 직물/PU 원단=자재#1 PTT 차원**·AC 아크릴·CL 의류원단 동형·비종이 자재 이미 관측) · **(PD-3 단수/형상=사이즈#13 프리셋 흡수**·계단 2단=495×320 1:1·스툴 원형↔305×305 1개=ST 형상 1:多 미충족=구조 distinct 부결 결정적 증거) · **(★PD-4 완제 구조물 내재BOM[다리/받침/솜/지퍼/논슬립]=부속물#8+생산형태#15+가격#11 분산 facet·#18 부결**) · **(PD-5 모양커팅/추가부자재 enum=공정#2/부속물#8·infoCall unobserved·축 판정 무영향).** ★PD-4가 ST 형상(#17)과 정반대로 부결된 결정적 근거 = **형상은 후니 KB G-SK-2 "형상 어느 축에도 없음" 결함이 distinct 강제, 완제 내재BOM은 후니 KB가 부속물(addl_product #9)·자재 usage·생산방식 A/B/C를 이미 1급 모델링(결함 없음·왜곡 없이 담음).** PD가 던진 진짜 질문(완제품 내재BOM을 옵션과 분리해 어디 두는가)의 답 = **부속물#8(다리/받침/논슬립=고정 ESN=Y 완제 부속·AC 등신대 받침 동형)+자재#1 usage(솜/지퍼)+생산형태#15(C 완제품 governing)+가격#11(tmpl)**. RP가 내재BOM을 마케팅 카피로만 둠 = *data-gap(부속물/생산BOM 그릇 미적재)이지 vessel-gap(축 부재) 아님*. **8번째 카테고리(봉제 구조물 완제품)가 distinct 0 = 모델 재포화 재확인** — directive 최대 관전(조립/구조/3D폼) 무손실 흡수.
>
> **★v7.0 (AC 통합) 핵심 판정 — 17축 재포화(distinct 0·PR·CL 패턴 반복·신규 강후보 A-8 부결):** AC(아크릴·키링·코롯토·명찰·등신대) 역공학의 9 fragment(A-1~A-9) 적대 판정 — **distinct 승급 0종(★가공방식 그룹핑 A-8 #18 부결)·전부 facet.** AC reverse가 "가공방식 그룹핑 슬롯(GRP_OPTION_CD/production_method)=distinct #18 강후보"를 강하게 제기(자재행을 가공방식 그룹으로 묶는 전용 슬롯·라미=두께/표면 능동 변환)했으나 **세 기존 축으로 무손실 분해** — ① 라미네이션=공정#2(합지 family) ② 라미 결과(라미된 자재행)=자재#1 합성(D-2·두께/표면) ③ GRP_OPTION_CD 그룹핑=옵션#3 polymorphic cascade(production_method→자재 subset 게이팅·G-4 채널 동형). **★ST 형상(#17)과 정반대 — 형상은 후니 KB G-SK-2 "어느 축에도 없음" 결함이 distinct 강제, 가공방식은 기존 축이 왜곡 없이 담음(라미=공정 멤버 이미 수용·KB 결함 없음)** = 형상 승격·가공방식 부결의 결정적 분기. directive 4 관전 적대 판정: **(① 두께=자재#1 WGT facet)** WGT 슬롯 다의성(평량/두께)·[huni-ref] 후니가 투명3T/1.5T를 mat_cd 차원 통합(1.5T=3T×0.8) 동형 · **(② 소재variant=자재#1 surface-finish facet)** 글리터/거울/자개/홀로그램이 ST S-4 점착/내후 합성 차원 동형·거울 별공식=#11 라우팅(자재 분류 아님) · **(③ 입체/스탠드=분산 facet)** 받침=부속물#8(평면본체 유지=생산형태#15 아님·본체 생성 아님=형태가공#14 아님)·코롯토 두께블록=자재#1·양면=옵션#3·입체조형=공정#2 · **(④ 가공방식 그룹핑=공정#2+자재#1 합성+옵션#3 cascade·#18 부결).** 나머지 A-4(부착물=부속물#8+공정#2 부착·고리 KR/CN/CR ST 공유=단일 부자재 마스터)·A-5(인쇄면+화이트=옵션#3+공정#2+제약#5·ST S-7 동형)·A-6(3 가격엔진=가격#11 acrylic2025 라우팅)·A-7(명찰 PET+합지=자재#1+공정#2·G-1/CL C-2 라벨 융합)·A-9(ACTPKEY=#16 TemplateAsset·T-A 이중의미). **7번째 카테고리(아크릴 두께/입체/가공방식)가 distinct 0 = 모델 재포화 재확인** — 가장 강한 새 후보 A-8조차 무손실 흡수.

> **★v6.0 (CL 통합) 핵심 판정 — 17축 재포화(distinct 0·PR 패턴 반복):** CL(의류·티셔츠·앞치마·가방류) 역공학의 9 fragment(C-1~C-9) 적대 판정 — **distinct 승급 0종(★의류 variant #18 부결)·전부 facet.** CL reverse가 "의류 variant=distinct #18"를 강하게 제기(item_gbn=clothes2025 별 분기·apparel_info 전용 그릇·size×color 2D 매트릭스·Pantone 1124)했으나 **네 근거 전부 기존 17축으로 무손실 분해** — ① item_gbn=구현 discriminator(PR P-4·ST S-5·GS G-1 정책패턴 동형) ② apparel_info=구현 컨테이너 뷰(여러 축 담음·D-8 동형) ③ size×color matrix=사이즈#13×색상(자재 CLR #1) Cartesian + 셀가용성=제약#5(ST disable 227=S-8 정점의 2D판) ④ Pantone=별색 공정#2(round-22 경계). **의류 variant = GS variant 축(G-4)의 2D 일반화 facet** — GS는 1D-per-channel(DTL/ATTB/CUT), CL은 2D 매트릭스(size×color→단일 MTRL_COD)로 해소·둘 다 같은 기존 축으로 분해. 주 귀속=자재#1 SKU matrix(G-1 본체 SKU 라벨 융합 동형·★[HARD] {fabric/PTT,color/CLR,size/WGT} 분해 요구). ST(5번째·형상 1종)가 PR 포화를 깼으나 CL(6번째·distinct 0)이 **모델 안정성 재확인** — 의류처럼 전용 그릇·전용 모델을 가진 가장 이질적 카테고리조차 17축 무손실 흡수.

> **★v5.0 (ST 통합) 핵심 판정 — 16축 포화 붕괴(distinct 1종):** ST(스티커) 역공학의 4 distinct 후보를 적대 판정 — **distinct 승격 1종(D-12 형상)·facet 강등 3종(칼선·재단입자·점착).** PR이 16축 포화를 입증(4번째 카테고리 distinct 0)했으나 **ST가 그 포화를 정직하게 깨뜨림** — 5번째 카테고리가 *형상(shape)* 1종을 도입. 이는 오버피팅이 아니라 **사이즈축(#13)이 형상을 1:1 칼틀로만 흡수해 온 전제가 ST에서 1:多로 분리됨**을 증거가 강제한 결과. 4 후보 적대 판정: **(① 형상=★distinct #17)** ST `option_info.shape_info`가 사이즈와 분리된 *전용 enum 슬롯*(SQ/CL/EL/RC/FR)·한 형상이 다수 칼틀 span(CL→CL001~100)·STDCFBR 5형상 superset·**후니 KB G-SK-2 "size축에 형상 enum drop·어느 축에도 없음"**(`entity-semantic-model.md:39`)이 size#13 미수용 확증 → 사이즈축이 *왜곡 없이 못 담음* = distinct. **(② 칼선 2메커니즘=facet of 공정#2)** THO_GRA(자유/도무송) vs THO_DFT(프리셋칼틀)는 *모양커팅 공정의 두 모드*(도메인 KB: 도무송=칼선 자유모형 컷팅·완칼/반칼 계열·공정 멤버). 프리셋칼틀이 사이즈를 겸함 = 공정#2 + 사이즈#13 cascade. PR THO_GRA·GS THO_CUT 합류. **(③ 재단 입자 반칼/완칼=facet of 공정#2)** 도메인 KB 결정적: 반칼=PROC_000054(종이만)·완칼=PROC_000053(종이+후지)·스티커완칼=PROC_000055 *전부 공정 멤버*. CUT_DFT 묶음재단(반칼시트)/개별재단(완칼낱장)=공정#2 멤버 + 배치 facet. GS THO_CUT 합류. **(④ 점착/내후 소재=facet of 자재#1)** 강접/리무버블/옥외/저온/자석/메탈/한지=*자재 합성 차원*(색상→material·두께→material 동형·`entity-semantic-model.md:51-53`). 자재모델에 adhesion/weatherability 합성축 추가(자재#1 강화·신축 아님). 양면 트레이드오프 펼침 = D-12 형상(아래)·S-4 점착(`_resolved-fragments.md`).

> **v4.0 (PR 통합) 핵심 판정:** PR(인쇄물·책자·리플렛·포스터) 역공학이 발굴한 새 패턴 9종(P-1~P-9) 중 **distinct 승격 0종.** 전부 기존 16축의 facet/family/cascade/정책으로 흡수. 이것이 *오버피팅 회피의 정직한 결과이자 16축 모델 포화(saturation) 입증* — **4번째 카테고리(BN 면적·GS 완제·TP 디자인입력·PR 다면/제본/접지)가 새 관리축을 0개 도입** = 16축이 RedPrinting 카탈로그 shape를 견디는 강한 검증 신호. PR이 더한 것은 새 *축*이 아니라 기존 축의 *새 facet/family/cascade*: **(P-1) 공정#2 "접지(folding)" family + 접지↔오시 cascade** · **(P-2) 자재#1 usage_cd "역할 전파"**(태그→자재/도수/가격/평량 전파 격상·★침묵선택 거부 트레이드오프) · **(P-3) page_rule 엔티티 정밀**(INN_PAGE=수량#10 슬롯+후니 별 엔티티·TP T-C 합류) · **(P-4) 공정방식=상품분기 정책패턴**(GS G-2·TP T-4 동류) · **(P-5) 면지=자재+공정 bundle**(D-2 동형) · **(P-6) 가격#11 digital_price 라우팅**(pricing_model 5종) · **(P-7) 인쇄방식#12 "자재풀 게이팅" 관계 간선** · **(P-8) 용도=카테고리#7 태그/마케팅 라벨** · **(P-9) 공정#2 멤버**(스코딕스 입체UV·레이저커팅·합지). 판정 근거 = "BN·GS·TP·PR 네 군을 견디며 고유 lifecycle/governing을 가지는가". 양면 트레이드오프 펼침 = P-2/P-4(아래). ★directive 핵심 충족: distinct 신축 강요 0(facet 오분류 금지)·P-2 침묵선택 거부.

> **v2.0 (GS 통합) 핵심 판정:** GS 역공학이 발굴한 새 패턴 6종 중 **distinct 승격은 2종(D-9 생산형태·D-10 형태가공)**뿐. 나머지 4종(완제 본체 SKU·본체소재 pdtCode 분리·variant 3채널·기종 enum)은 **기존 축 facet/확장으로 흡수**(과잉 일반화 거부, SKILL §5). 판정 근거 = "BN(평면)·GS(완제/입체) 두 군을 견디며 고유 lifecycle/governing을 가지는가". 양면 트레이드오프 펼침 = G-1/G-2(아래).

> **v3.0 (TP 통합) 핵심 판정:** TP 역공학이 발굴한 새 패턴 6종 중 **distinct 승격은 1종(D-11 디자인 입력 채널)**뿐. 나머지 5종은 facet/확장으로 흡수: **(a) 템플릿 자산**=D-11 입력채널의 *리소스 facet*(에디터가 로드하는 디자인 시안 — 완제SKU 템플릿#4와 *같은 단어 다른 의미*, 분리 명시) · **(b) VDP**=D-11 입력채널의 *데이터바인딩 facet* × 수량(#10 변수행) · **(c) 페이지 계층 INN_PAGE**=수량모델(#10)/사이즈(#13) 확장 · **(d) 티켓 형태 variant**=사이즈/형상(#13)+칼틀(#2)(GS THO_CUT 동형) · **(e) 특수인쇄 PRT_WHT/PRT_MAG·박**=공정(#2 별색 family). 판정 근거 = "BN(면적)·GS(완제)·TP(디자인입력) 세 군을 견디며 고유 lifecycle/governing을 가지는가". 양면 트레이드오프 펼침 = T-A/T-D(아래). **★directive 핵심 충족: 에디터 채널은 distinct 승격(가장 강한 vessel-gap), 템플릿 자산은 distinct 신축이 아니라 입력채널 facet + 템플릿#4 이중의미 분리.**

---

## D-1. 부속물 축 (Addon) — distinct ✅

**정체:** 인쇄 본체와 *분리된 완제 부속 부품*. 거치대(X배너 8종·롤업 3종), 후니 도메인의 우드봉·볼체인·이젤.

**증거(BN):**
- BNSTDFT CDL_DFT = [PTIDF 뉴포인트, PT005 L거치대, PT004 W거치대, … 8종], BNRLSLV = [RLU01/02/03 롤업거치대].
- PCS_COD(후가공) 그룹으로 묶이지만 **본체에 가하는 작업이 아니다** — 독립 완제품.

**distinctness:**
- vs **템플릿/SKU:** 템플릿 = "본체+부속의 묶음 주문 단위(번들 SKU)". 부속물 = "묶음에 들어가는 부속 부품". 거치대는 부품(D-1), "현수막+거치대 1세트" = 템플릿. 둘 다 필요(서로 못 담음).
- vs **옵션:** 옵션 = 본체 속성 선택. 부속물 = 본체 외부 객체(자체 코드·재고·가격).
- vs **공정:** 공정 = 본체 변형. 부속물 = 비변형 첨부.
- **후니 동형(권위):** entity-semantic-model 9속성 #9 `addl_product`(`t_prd_product_addons`) "완제 부속: 거치대·우드봉·볼체인 — 부착공정과 축 분리". → RP CDL_DFT = 후니 addons의 RP 표현. distinct 확정.

**오버피팅 검토:** BN에서만 거치대가 보였으나, 후니 도메인 KB가 거치대·우드봉·볼체인·이젤을 횡단 부속물로 확증 → 단일상품 아님, distinct 정당.

**관계:** 부속물 → 본체 상품(belongs-to, 번들), 부속물 ↔ 사이즈(match 제약, D-3). 부속물 자체가 size variant 보유(롤업거치대 600/850/1000).

---

## D-2. 자재 합성 & usage & 공정결합 축 (Material Composition) — distinct(메타규칙) ✅

**정체:** "자재"는 단순 enum이 아니라 **(a) 다축 합성코드 + (b) usage 슬롯 + (c) 공정의 자재소비 FK**라는 세 규칙을 가진 메타 구조.

**증거(BN):**
- (a) **합성:** MTRL_CD = MTRL_TYPE(P) + PTT_CD(BFC현수막/MAS매쉬/TFC텐트천) + CLR_CD(X기본) + WGT_CD(XXX) + 인쇄방식(수성C/라텍스L). 하나의 코드가 4~5축 인코딩(BNBNFBL note, A-4).
- (b) **usage:** BN은 substrate 단일 usage이나, 후니 entity-semantic-model #2 usage_cd(.01내지/.02표지/.03면지/.07공통) = 자재가 *어느 슬롯에 쓰이나*.
- (c) **공정결합:** SUB_MTRL_YN=Y(아일렛=금속링, 각목, 로프, 큐방) = 공정이 부자재를 소비(A-6). "순수공정(재단)" vs "자재소비공정(아일렛)"을 플래그로 분리.

**distinctness:**
- 단순 "자재 버킷"(자재 행 등록)은 (a)(b)(c) 규칙을 못 담음. 합성코드를 평면 문자열로 두면 본체색(CLR)·소재(PTT)·인쇄방식 분리 불가 → 위젯 옵션 캐스케이드·가격 분기 붕괴.
- **후니 권위 정합(HARD):** entity-semantic-model §1-1 "자재축에 공정 섞임"(아트250+무광코팅) = 결함. 메모리 `dbmap-material-option-normalization`: 후니 자재 오염(색/형상/구수가 자재행에) — RP 합성코드 분해가 *정답 모델*. 별색=공정·본체색=자재 CLR축(도메인 사실 준수).
- **공정↔자재 FK는 자재 버킷 단독으로 표현 불가** — 공정 엔티티가 `consumes_material`/`material_ref`를 가져야 함. 자재와 공정 양쪽에 걸친 메타규칙 → distinct.

**관계:** 자재(합성) → 본체, 자재 CLR → 본체색(variant), 공정(SUB_MTRL_Y) → 자재(consumes FK), 자재 → 공정(force, PET→코팅필수 D-3).

**경계 준수(도메인 HARD):** 별색≠자재(별색=공정 PROC_000007), 본체색=자재 CLR 분해축, 두께=자재 식별자. RP MTRL_CD의 CLR/WGT는 자재축, 인쇄방식은 자재 facet 또는 D-7로.

---

## D-3. 제약 논리유형 축 (Constraint Logic Typing) — distinct ✅

**정체:** 7버킷 "제약"은 *제약 객체*만 가리킨다. 발굴 핵심 = 제약이 **유형화된 논리 어휘**를 가진다는 것 — disable / force(=require) / match / exclude / essential / min-max.

**증거(BN) — 6 논리유형 실관측:**
| 논리유형 | BN 증거 | 방향 | 후니 동형 |
|---|---|---|---|
| **disable** | `pdt_disable_pcs_info`(자재→공정 비활성, BN 0건·책자 24건) | 자재→공정 (−) | round-6 material→pcs disable |
| **force/require** | PET→코팅 ESN_Y 필수, 텐트천→PKG_RUP 포장 필수(A-5) | 자재→공정 (+) | ESN_YN=Y, force 규칙 |
| **essential(필수)** | CUT_ZUN 재단 ESN_YN=Y(택1 필수), COT_DFT 코팅 ESN_Y | 그룹 내 필수 | excl_group 필수 |
| **match(캐스케이드)** | 롤업 size 600 ↔ 거치대 RLU01 1:1(A-1) | 사이즈↔부속물 | 부속물 size 종속 |
| **exclude(택1)** | 재단 그룹 [정사이즈/방풍/모양] 택1, SEL_TYPE.01 | 그룹 내 배타 | process_excl_group SEL_TYPE.01 |
| **min-max(범위)** | nonspec size MIN/MAX_CUT_WDT/HGH(0~5000) | 값 범위 | nonspec_*_min/max |

**distinctness:**
- 제약을 단일 객체 버킷으로 두면 "어떤 논리인가"를 못 표현 → 위젯 런타임이 캐스케이드를 못 구동. 6유형은 *거버넌스된 어휘*(JSONLogic op 집합)여야 함.
- **후니 권위:** entity-semantic-model #5 process_excl_group(택일), 메모리 `dbmap-cpq-option-mapping` "RedPrinting 캐스케이드 6종 → JSONLogic constraints", `dbmap-live-admin-product-viewer` constraints.logic NOT NULL. → 제약 논리유형이 후니 CPQ의 1급 구조. distinct 확정.
- **force = disable의 역방향**(사용자 directive 명시 후보): RP가 disable(−)과 force(+)를 *대칭 쌍*으로 운영 → 제약 축이 방향성을 가진 그래프임을 입증.

**관계:** 제약은 모든 축을 잇는 *간선(edge)* — 자재→공정(disable/force), 사이즈↔부속물(match), 공정 그룹 내(exclude/essential), 값 범위(min-max). 제약 축 = 메타모델의 관계 엔진.

---

## D-4. 공정 파라미터 축 (Process Parameter) — distinct ✅

**정체:** 공정 *멤버*가 선택됐을 때만 활성되는, 그 공정에 종속된 매개변수 슬롯.

**증거(BN):**
- BNTNHVY number_sel_ROP_DFT: 로프 공정에 종속된 수량 select(USER/1~10) (A-7).
- SUB_MTR QTY_INPUT_YN=Y: 추가부자재 수량 입력.
- (후니 횡단) UV 변형 5종(풀빼다/배면양면 = PROC_000002 param), 오시 줄수 0~3, 접지 16종, 책등 mm, 링컬러/D링 mm, 조각수.

**distinctness:**
- vs **옵션:** 옵션은 독립 선택축. 파라미터는 *부모 공정 종속*(공정 미선택 시 비존재).
- vs **수량:** 수량 슬롯 중 일부(로프 수량)는 파라미터지만, 파라미터는 수량 외 도메인(줄수/mm/색/조각수)도 가짐 → 수량의 상위가 아니라 별개.
- **후니 권위:** entity-semantic-model #4 "prcs_dtl_opt param — 줄수/개수/조각수=공정 신호(옵션값 아님)", process-recipe-tree §2-3 "param이 캐스케이드 입력값", 메모리 `dbmap-cpq-option-mapping` ref_param_json. → distinct 확정.
- **lifecycle:** 조건부 활성(부모 공정 선택 시), 자체 값 도메인, 가격에 공정과 함께 기여. 기존 옵션/공정 어느 쪽도 단독으로 못 담음.

**관계:** 파라미터 → 공정 멤버(belongs-to), 파라미터 → 가격(공정과 결합 기여, D-6), 파라미터 ↔ 캐스케이드(오시 줄수 → 접지 단수, D-3 match).

**도메인 경계 준수:** 판걸이수(impos)는 *앱 계산*(DB 미저장) — 파라미터 축에 넣지 말 것(entity-semantic #6 plate_size note, 메모리 `dbmap-compute-in-app-db-stores-lookup`). 파라미터 = *입력* 매개변수만.

---

## D-5. 수량 모델 축 (Quantity Model) — distinct ✅

**정체:** 단일 qty 스칼라가 아니라 **다중 의미적 수량 슬롯**(주문 건수 × 인쇄 수량 + 공정종속 수량).

**증거(BN):**
- 전 BN: ORD_CNT="디자인 수(건수)" + PRN_CNT="수량" 이중축(quantityGroup, A-2). SSR number1_sel(1~10) + number4_sel("N배").
- 공정종속: ROP_DFT 수량, SUB_MTR 수량(D-4와 교차).

**distinctness:**
- "옵션(수량)"으로 평면화하면 건수(세팅비 곱수)와 수량(선형)의 가격기여 차이 소실 → 가격 모델 붕괴(D-6과 연결).
- vs **bundle_qty(후니):** entity-semantic-model #7 bundle_qty = 묶음수(권/세트), page_rule ≠ bundle. RP ORD_CNT(디자인 건수)는 후니 bundle과 또 다른 의미 → 수량 축은 *복수의 이질적 슬롯*을 갖는 축임이 확증.
- lifecycle: 상품마다 노출 슬롯 다름(건수만/수량만/둘다/공정수량). distinct.

**관계:** 수량 슬롯 → 가격기여 역할(D-6: 건수=곱수, 수량=선형), 공정종속 수량 → 공정 파라미터(D-4 교차).

**오버피팅 검토:** 이중 수량은 BN 전 6상품 + Vue/jQuery 양 런타임 일관 관측 → 단일상품 아님, distinct.

---

## D-6. 가격기여 역할 축 (Pricing Role) — distinct(횡단 메타) ✅

**정체:** 7버킷 어디에도 없는 횡단 축 — **각 선택축이 가격에 *어떻게* 기여하는가**의 역할 태그.

**증거(BN):**
- 전 축에 `price_flag`/`price_gbn=real_price`가 부착: MTRL_CD→면적단가 분기키, CUT_WDT/HGH→SizeMatrix2D 면적, DOSU_COD→도수가, PCS_INFO[]→후가공가, ORD_CNT→세팅곱수.
- item_gbn=real_item·price_gbn=real_price = "대형 실사/배너 = 면적 기반 SizeMatrix2D 가격모델"(BN 공통 계약).

**distinctness:**
- 7버킷은 "무엇을 등록하나"(객체)만 다룬다. "그 선택이 가격에 면적단가인지/곱수인지/고정인지/단가매트릭스인지"는 별도 메타정보 → RP가 모든 축에 price_flag로 부착한 것이 증거.
- **후니 권위 정합:** 메모리 `dbmap-price-formula-types-authority`(면적매트릭스형 vs 고정가형), `dbmap-price-class-benchmark`(가격공식 15클래스), round-2 t_prc_* 4단(price_components.prc_typ_cd 단가/합가). → 후니도 가격기여 *유형*을 1급 데이터로 운영(prc_typ_cd, frm_typ). distinct 확정.
- 횡단성: 자재·사이즈·도수·공정·수량 *모든 축*이 가격기여 역할을 가짐 → 단일 버킷 귀속 불가, 횡단 메타.

**관계:** 가격기여 역할은 각 축 엔티티에 *부착되는 태그*(자재.price_flag, size→면적, qty→곱수/선형) + 면적기반 상품은 SizeMatrix2D 가격모델 바인딩.

**경계:** 본 하네스 산출(메타모델)에서는 *역할 분류*까지만 — 실제 가격 *값/공식*은 dbmap 가격 트랙·갭분석가 영역. PRICE=0 캡처(비로그인)는 가격 *구조* 추출에 무관(BN note).

---

## D-7. 인쇄방식 / 생산 레시피 축 (Print-Method / Production Recipe) — distinct(조건부) ✅

**정체:** 인쇄방식(디지털/실사/UV/옵셋/실크)이 **가능 공정 부분집합·파일포맷·생산팀·기초데이터를 게이팅**하는 최상위 레시피 축.

**증거:**
- (BN/RP) 인쇄방식이 MTRL_CD 끝자리로 인코딩(수성C/라텍스L, A-4) — RP는 *자재 facet*으로 표현.
- (후니 권위) process-recipe-tree §1: 인쇄방식 5종 = 최상위 축, "1상품=1인쇄방식이 가능 공정 부분집합 결정"(레시피 게이팅). §2 PDF 17 Case = 방식별 공정 시퀀스.

**distinctness 판정(조건부):**
- **RP 표현에서는 facet**(자재코드 분기) — BN 단독으로 보면 자재 합성의 일부(A-4 1차 판정).
- **후니/도메인 표현에서는 distinct 1급 축** — 인쇄방식이 공정·파일·팀·기초데이터를 게이팅하는 *lifecycle*을 가짐. 단순 자재 분기가 담을 수 없는 게이팅 관계.
- **메모리 `dbmap-print-method-not-absolute-axis`:** 인쇄방식 절대축 아님(강제 분리 금지) — 그래서 *조건부* distinct: 메타모델은 인쇄방식을 (a) 자재 facet으로 인코딩하거나 (b) 1급 레시피 축으로 게이팅하는 *양면 표현*을 인정해야 함.
- **결론:** distinct 등재하되 "RP=자재 facet / 후니=1급 게이팅 축" 갭을 명기. 메타모델 사전에서는 게이팅 관계를 1급으로 그림(갭분석가가 후니 흡수 위치 결정).

**관계:** 인쇄방식 → 가능 공정 집합(gates), → 파일포맷, → 생산팀, → 기초데이터 요구. 자재와 부분 중첩(RP 인코딩).

---

## D-8. UI 런타임/표현 바인딩 — facet, **축 아님(거부)** ❌

**정체 후보:** Vue3 위젯 vs 레거시 jQuery 두 런타임(BN §0).

**거부 근거:**
- BN §0 핵심 발견: "UI 런타임이 둘이어도 **base-data 스키마는 하나**"(`pdt_mtrl_info`/`pdt_size_info`/`pdt_dosu_info`/`pdt_pcs_info` 공유).
- 후니가 흡수할 대상은 UI가 아니라 공통 관리 축 — 런타임은 *표현 계층*이지 관리 축이 아님.
- distinctness test 실패: 고유 관리 *데이터*가 없음(같은 base-data를 다르게 렌더할 뿐). → facet of presentation, 메타모델 사전에서 제외.

**메타모델 시사:** 메타모델은 런타임 중립이어야 함 — 같은 base-data가 어떤 위젯으로도 렌더되도록(후니 위젯 컨버전 전략 정합, 메모리 `huni-widget-conversion-strategy`).

---

## ═══ GS 통합 발굴 (v2.0) ═══

## D-9. 생산형태 축 (Production Type) — distinct ✅ (GS 신축)

**정체:** 상품의 생산 구조 분류(완제품 C / 반제품·셋트 B / 통합 A / 기성 / 디자인)가 **본체 모델링·자재 usage·형태가공을 governing**하는 상위 직교 축.

**증거(GS + 도메인 권위):**
- GS: 텀블러/코스터/효자손/장패드 = **C 완제품**(본체=DIR_MTR 완제 SKU 항목, 내지/표지 개념 없음), 스프링노트/스케치북 = **A 통합 또는 B 셋트**(표지+내지 usage 다중슬롯). 같은 "노트" 기능군에 통합책자·하드커버 공존.
- 도메인 권위(entity-semantic §4 "C-9 해결"): 생산방식 3구조 **A 통합 / B 셋트·반제품 / C 완제품·단일** 확정·11군 매핑. "B 셋트라도 자재 권위=parent+usage_cd, sub_prd 0행=정상".

**distinctness:**
- vs **카테고리:** 카테고리=기능 트리(코스터·노트). 생산형태는 *직교* — 같은 카테고리에 A·B·C 공존(노트=통합책자[A]+하드커버[B]). 카테고리가 생산형태를 못 담음(다대다 직교).
- vs **템플릿/SKU:** 템플릿=번들 주문 단위. 생산형태는 *본체가 자재행인가 완제 SKU 항목인가*를 결정하는 분류 — 템플릿의 상위.
- **lifecycle/governing:** 생산형태가 #1(본체 모델링)·#14(형태가공 활성)·#1 usage(셋트=다중)를 게이팅. 1상품 1생산형태. 기존 어느 축도 이 governing을 단독으로 못 함 → distinct.
- **오버피팅 검토:** BN(전부 C형 단일)에선 단일값이라 미발굴이었으나, **도메인 권위가 11군 매핑으로 1급 확정** + GS가 A/C 다수 노출 → 단일상품 아님(횡단). distinct 정당.

**관계:** 생산형태 → 상품(classifies 1:1), → 본체 모델링(governs #1/#4), → 형태가공(#14 C 입체 활성), → 자재 usage(#1 B 다중슬롯), ⊥ 카테고리(직교).

**★후니 갭(갭분석가 주목):** 메모리 `dbmap-grid-binding-round15` "라이브 prd_typ_cd ≠ 생산형태(굿즈/문구=.03기성·디지털/실사/아크릴=.04디자인 오귀속)" — 후니 라이브가 이 축을 *오모델링* 중. RP/GS가 정합 참조 제공.

---

## D-10. 본체 형태가공 축 (Body Form-Assembly) — distinct ✅ (GS 신축)

**정체:** 평면 인쇄물을 *입체 완제 굿즈로 조립/봉제/지퍼/형성*하는 공정. 본체 *형태 자체를 생성*(일반 후가공=기존 본체에 작업).

**증거(GS):**
- GSPUFBC: `PDT_WRK`(노트북-태블릿 파우치가공) + `FLX_ZIP`(지퍼가공 세로형). GSTGMIC: `PDT_WRK`(마이크텍 조립). 평면 패브릭/인쇄물 → 입체 파우치/마이크텍.
- BN(평면 배너)엔 *전무* — 굿즈 특유 축.

**distinctness:**
- vs **공정(#2):** 일반 후가공(코팅·재단·아일렛)=기존 본체에 작업 가함. 형태가공=본체 *생성*(파우치는 PDT_WRK 없으면 평면지로 본체 미완성). lifecycle 구별.
- vs **자재소비공정(D-2):** 지퍼(FLX_ZIP)는 부자재 소비 동반(아일렛 패턴)이나, PDT_WRK(봉제/조립)는 순수 형성 — 형태가공은 자재소비공정의 부분집합 아닌 별 카테고리.
- **lifecycle:** 본체 정체와 결합된 필수 공정 + 방향 variant(세로/가로). 생산형태(D-9 C 입체)에서만 활성.
- **오버피팅 검토:** GSPUFBC·GSTGMIC 2상품 + 효자손/폰케이스 추정 → 단일상품 아님. 후니 굿즈 BOM "평면→입체 조립 단계"(메모리 round-22 본체 자재 BOM) 동형. distinct 정당.

**관계:** 형태가공 → 상품(belongs, 본체 형성), → 자재(consumes 지퍼, #1), → 생산형태(D-9 governs), → 공정 seq(인쇄→재단→형태가공).

---

## ═══ GS facet/확장 판정 (distinct 거부 — 양면 트레이드오프) ═══

## G-1. 완제 본체 SKU (DIR_MTR/WRK_MTR) — **자재축 facet (distinct 거부)** ★핵심 의사결정

**정체 후보:** 굿즈 본체(텀블러/실리콘끈/장패드/스펀지)가 `DIR_MTR`(부자재직접인쇄)/`WRK_MTR`(부자재작업) PCS 항목으로 등장하고 result PRICE 주체.

**★양면 트레이드오프(침묵 선택 금지):**
- **(가) 별도 distinct "완제 본체 SKU" 축으로 신설:**
  - 찬성: BN 본체=`ORD_INFO.MTRL_CD`(자재행)와 GS 본체=`DIR_MTR`(PCS 항목)는 *DB 위치가 다름*(ORD vs PCS). PRICE 주체·완제 SKU 라벨이라는 별 성격.
  - 반대: 위치가 달라도 *둘 다 "본체 소재를 가리키는 참조"*라는 같은 의미축. 신축으로 두면 자재축이 BN/GS로 쪼개져 메타모델 일관성 붕괴(같은 개념 2축). PRICE 주체는 가격기여 역할(#11)이 담음·완제 SKU성은 템플릿(#4)·생산형태(#15)가 담음.
- **(나) 자재축(#1)의 두 표현 facet + 템플릿(#4)·생산형태(#15) 결합 [채택]:**
  - 본체 = 자재참조(#1)이며, 생산형태(#15)가 *표현을 governing*: C 완제품→DIR_MTR PCS 항목(완제 SKU 라벨), A/B→ORD_INFO 자재행. 가격 주체성=#11, SKU성=#4.
  - 이점: 자재축 단일 유지·기존 발굴 축(#11/#4/#15)이 나머지 성격 흡수·BN/GS 통일.

**판정: facet (distinct 거부).** 완제 본체는 *기존 축들의 결합*으로 왜곡 없이 표현됨(자재#1 + 가격기여#11 + 템플릿#4 + 생산형태#15). 신축은 자재축 중복. **단 [HARD] 분해 요구:** PCS_DTL_NME 라벨 융합("미르 와이드마우스 보틀 화이트 20oz")을 `{body_material, body_color, capacity, thickness, brand}`로 분해해야(평면 라벨=의미축 drop). 이것이 후니 "굿즈 본체소재 부재" 결함의 RP판 정답.

---

## G-2. 본체 소재 = pdtCode 분리 (코스터 6소재) — **자재+카테고리 복합 facet (distinct 거부)** ★핵심 의사결정

**정체 후보:** 같은 기능(코스터)이 본체 소재(규조토/펠트/코르크/종이/아크릴/레더)별로 6개 별도 pdtCode.

**★양면 트레이드오프(침묵 선택 금지):**
- **(가) RedPrinting 방식 답습 — 소재=상품 분리(pdtCode 6개 유지):**
  - 찬성: RP 검증 모델·소재가 본체정체(다른 소재=다른 생산라인/단가)·아크릴 코스터만 형상 추가처럼 소재가 후속 옵션 캐스케이드.
  - 반대: 카탈로그 6→1 기회 상실·소재 추가 시 신상품 생성 운영부담·후니 "굿즈 본체소재 컬럼 부재"라 현재 상품명에만 → 6 pdtCode 답습 시 결함 고착.
- **(나) 소재=옵션화 — 한 "코스터" 상품 + 소재 차원(자재 variant):**
  - 찬성: 카탈로그 축소·소재=자재축 variant(entity-semantic §2 "색상 variant→material" 동형으로 소재 variant→material)·관리용이.
  - 반대: 소재별 후속 옵션 분기(아크릴=형상, 규조토=흡수 무인쇄?)를 옵션 캐스케이드로 풀어야 — variant×후속옵션 복잡도. 소재별 단가가 매트릭스로.

**판정: facet — 자재축(#1 소재 variant) + 카테고리(#7 코스터=공통 기능 노드) 복합 (distinct 거부).** "본체 소재"는 자재축이 담고(소재=mat_cd 분기), "코스터 공통 기능"은 카테고리가 담음 → 신축 불요. **분리 vs 옵션화는 메타모델 판정이 아닌 후니 카탈로그 *정책 결정*(갭분석가/실무)** — 메타모델은 둘 다 표현 가능(소재=pdtCode면 카테고리 다대일, 소재=옵션이면 자재 variant). RP는 (가) 채택, 후니 관리용이성은 (나) 우세하나 아크릴 코스터 형상 캐스케이드가 (나)의 난점. **권고: 정형 소재(종이/펠트/코르크/규조토/레더)=옵션화, 형상 동반 소재(아크릴)=별 pdtCode** 하이브리드.

---

## G-3. 폰케이스 기종(device) enum — **사이즈 프리셋 facet (distinct 거부)**

**정체 후보:** 폰케이스 기종(갤럭시/아이폰 수십종)별 칼틀·사이즈 분기(GSCAPHN, 옵션 상세 unobserved).

**판정: facet — 사이즈 축(#13) 대규모 프리셋 인스턴스 (distinct 거부).** 기종 = 사이즈/칼틀 프리셋의 *대규모 enum*일 뿐 고유 lifecycle 없음(소재처럼 본체정체를 바꾸지 않음·기능 동일). 기종↔칼틀 캐스케이드 = 제약축(#5 match). "일반/터프"(케이스 구조)는 자재축 본체타입 variant(#1)와 직교. **단 enum 규모(수십~수백)가 질적으로 커 위젯 UX는 검색형 select 필요**(메타모델 데이터 구조는 사이즈 프리셋 동일·표현만 다름). unobserved라 규모/캐스케이드 방향 확정 불가(`unobserved`).

---

## G-4. variant 3채널(DTL/ATTB/CUT) — **기존 축 분배 facet (distinct 거부)**

**정체 후보:** 같은 variant 개념이 DTL코드·ATTB·CUT_WDT/HGH 3채널로 분산.

**판정: facet — 3채널을 기존 축으로 분배 (별 "variant 축" distinct 거부).** ① DTL코드→옵션축(#3) polymorphic option_item(다차원 합일 시 다중 ref_dim_cd), ② ATTB→공정 파라미터(#9, 링색·반경), ③ CUT→사이즈축(#13 프리셋). entity-semantic §2 "variant 분해 원칙(색상→material·사이즈→size·두께→material)"이 이미 채널 분배를 규정 → 신축 불요. **★난점 명기:** GSTGMIC TG001/3처럼 *한 DTL코드가 자재+사이즈+칼틀+가격 동시 결정*(강결합) — 후니 CPQ polymorphic ref가 한 option_item에서 복수 차원을 게이팅하도록 표현(메모리 `dbmap-cpq-option-layer-mapping`). 정규화 난점이지 신축 사유 아님.

---

## G-5/G-6/G-7/G-8 — 기존 축 확장 (요약 판정)

| frag | 정체 | 판정 | 귀속 축 |
|---|---|---|---|
| **G-5** | INN_DFT/RIN_DFT/RIN_COL/STA_DFT (내지 usage + 제본방식) | **facet/확장** | 내지=자재 usage 다중슬롯(#1 GS 확인 ✅), 제본=공정(#2) + 자재(링/코일) bundle + 택1 그룹. 제본방식이 PCS_COD 레벨 분리(그룹 메타 없음) → 후니 옵션그룹(택1)으로 묶을 메타 추가 필요 |
| **G-6** | PDT_WRK/FLX_ZIP (형태 조립) | **distinct → D-10** | 본체 형태가공 신축(위 D-10). FLX_ZIP은 자재소비(지퍼) bundle |
| **G-7** | tmpl/vTmpl/tiered_price (가격모델 3종) | **확장** | 가격기여 역할(#11) — pricing_model enum 4종 확장(면적/tmpl/vTmpl/tiered). 옵션↔가격모델 라우팅 |
| **G-8** | PAK_ETC/PAK_POL (포장 다중 + 유료/무료) | **facet** | 공정(#2 포장) — 방식별 PCS_COD + 가격기여(#11 유료/무료 분기). BN PKG_GB(강제 제약 A-5)와 달리 GS=선택+개당과금 |

---

## ═══ TP 통합 발굴 (v3.0) ═══

## D-11. 디자인 입력 채널 축 (Design-Input Channel) — distinct ✅ (TP 신축) ★directive 핵심

**정체:** 상품의 디자인을 *어떻게 입력받는가*를 결정하는 축 — 에디터 채널(KOI 웹에디터 / Edicus SDK / 없음=PDF 업로드) + 입력방식 플래그(PDF 직접·기성 템플릿 다운로드·디자인수 산정 출처). 본체(자재·공정·사이즈·수량)와 **직교**하며, 본체 옵션 트리(`pdt_pcs_info`)를 오염시키지 않고 `item_gbn` + `product_option.option`의 플래그 묶음으로 인코딩된다.

**증거(TP — ★직접 대조):**
- **같은 base-data 스키마, 옵션 트리 밖 플래그 묶음:** TP 상품은 BN·GS와 동일한 `pdt_mtrl_info`/`pdt_size_info`/`pdt_pcs_info`/`pdt_dosu_info`를 그대로 쓴다(reverse §0). 차이는 옵션 트리가 아니라 `product_option.option`의 `item_gbn`·`useKoiEditor`·`useRPEditor`·`useTemplateDownload`·`usePDF`·`usePDFordCnt`/`useEditorOrdCnt`·`koi_template_resource_id`·`koiOption[]` 플래그 묶음.
- **★비-TP 트윈 직접 증거(reverse §0.1):** 같은 "탁상 세로 캘린더"가 **TPCLSTD(TP)** = `vDigital_item`·`useKoiEditor=Y`·`useTemplateDownload=Y`(KOI에디터+기성템플릿) vs **HLCLSTD(비-TP)** = `offset2023_item`·`useKoiEditor=N`·`useTemplateDownload=N`·`usePDF=Y`(에디터0·PDF전용). **자재·사이즈·후가공·가격은 완전 동일**, TP가 추가하는 단 하나 = 디자인 입력 레이어. → 입력 채널이 본체 옵션과 *완전 분리 가능*(orthogonal)함을 1:1 트윈으로 입증.
- **가격 0(reverse §3 가격 실측):** TPCLWLB priceCall(`vTmpl_price`) — CUT_DFT 0 + STA_CLD 0 + PAK_POL 0 + PRT_DFT(인쇄) 11900 → PRICE=11900. 에디터/템플릿 PCS는 PRICE=0. **디자인 입력은 가격에 기여하지 않음**(가격 주체=인쇄/자재/후가공). → 입력채널이 가격기여역할(#11)을 갖지 않는 별 성격.
- **에디터 3채널 = item_gbn 분기(reverse §0.2):** `vDigital_item`(KOI·TPCL*/TPTKDFT) / `edicus_item`(Edicus SDK·GSCLMGN/TPBCDFT) / `offset2023_item`(없음·HL). KOI는 `koi_template_resource_id`로 템플릿 리소스 바인딩, Edicus는 VDP(가변데이터).

**도메인 정초(huni-widget 역공학 권위 — 신규 리서치 불요, 기존 KB 재사용):**
- `seed-redprinting-sdk-analysis.md:1` 3계층 아키텍처: 브릿지(`productRedWidgetSDK.js`) ↔ 런타임(`widget.js` Vue3) ↔ **에디터(`RedEditorSDK.min.js` 45메서드)**. 브릿지 글로벌 함수에 `sdkOpenEditor`·`fnKoiEditorInit/fnKoiEditor`·`fnRpEditorInit/fnRpEditor`·`sdkEditorCheck` = **에디터 채널이 호스트 통합 API의 1급 계약**(seed §7).
- `editor-bridge-protocol.md`: Edicus iframe URL 명령 `cmd: create | open | edit-template | create-design-project | open-design-project`. 공통 파라미터 `editor_type·parent_type·run_mode·master_mode·edit_mode` = 에디터 채널 메타. **즉 RedPrinting은 에디터 채널·모드를 명시 1급 파라미터로 운영**(브릿지 계약). → D-11이 후니 위젯에도 1급 통합 경계임이 확증(huni-widget 컨버전 전략 정합).

**distinctness(distinctness test §3):**
- vs **템플릿/SKU(#4):** 템플릿#4 = 완제 주문 단위(본체+부속 번들·봉투결합 엽서·OTC). 입력채널 = 디자인을 *생성/입력*하는 방식. 둘 다 필요(서로 못 담음). TP 템플릿 자산(디자인 시안)은 #4의 완제SKU가 아니라 *입력채널의 리소스 facet*(아래 T-A·이중의미 분리).
- vs **옵션(#3):** 옵션 = 본체 속성 선택(자재/공정/사이즈 polymorphic ref). 입력채널 = 본체 *외부*의 입력 메커니즘. `item_gbn`은 어느 차원 행도 가리키지 않음(ref_dim_cd 부재).
- vs **공정(#2):** 공정 = 본체 변형 작업. 디자인 입력 = 본체 *생성 전* 디자인 데이터 확보(인쇄 입력물). PRICE=0(공정은 가격기여). 비변형.
- vs **인쇄방식 레시피(#12):** 인쇄방식(디지털/옵셋)은 *가능 공정·파일포맷·팀*을 게이팅(생산 측). 입력채널은 *고객 디자인 입력 UX*(주문 측). 단 둘은 상관 — `offset2023_item`(옵셋 인쇄방식)이 흔히 에디터0·PDF전용과 동반. **그러나 동일 아님**: `vDigital_item`(디지털 인쇄)이라도 에디터 유무가 갈림(KOI vs PDF), `edicus_item`은 명함 VDP. 인쇄방식이 입력채널을 *제약*하나 결정하진 않음 → 별 축(상관 간선).
- **lifecycle:** 1상품에 입력채널 1구성(item_gbn 1값 + 플래그 묶음). 입력채널이 (a) 디자인수 산정(`usePDFordCnt`/`useEditorOrdCnt` → 수량모델#10 ORD_CNT) (b) 템플릿 자산 노출(`useTemplateDownload`) (c) VDP 가능 여부(Edicus)를 *게이팅* → 다운스트림 영향 보유. 기존 어느 축도 이 게이팅을 단독으로 못 함.

**오버피팅 검토(SKILL §5):** TP 단일 카테고리지만 — ① **비-TP 트윈(HL 캘린더)** 직접 대조로 "본체 동일·입력채널만 추가" 입증(단일상품 아님·횡단 대조) ② 에디터 채널은 GS(`edicus_item` GSCLMGN)·BN(전 상품 PDF 업로드)에도 *값으로* 존재 — TP는 그 축을 *전면화*했을 뿐, BN/GS도 입력채널 값을 가짐(전 카테고리 횡단) ③ **후니 동형 권위:** huni-widget RedEditorSDK 45메서드 + Edicus 브릿지 = 후니 위젯도 동일 에디터 채널 통합 필요(메모리 `huni-widget-conversion-strategy`·`widget-monitor-live-testbed`). → distinct 정당.

**관계:**
- DesignInputChannel → Product(classifies — 1상품 1입력구성).
- DesignInputChannel → TemplateAsset(provides — 에디터가 로드하는 디자인 시안 카탈로그, T-A facet).
- DesignInputChannel → QuantitySlot(#10, gates — `usePDFordCnt`/`useEditorOrdCnt`가 ORD_CNT "디자인 수(건수)" 산정 출처 결정).
- DesignInputChannel ↔ PrintMethod(#12, 상관 — offset2023↔에디터0 동반 경향, 결정 아님).
- DesignInputChannel ⊥ 본체 옵션 트리(자재#1·공정#2·사이즈#13·옵션#3 — 직교, 가격 0).

**★후니 갭(갭분석가 주목):** 후니 t_*에 "디자인 입력 채널" 그릇 **부재 가설(vessel-gap 1순위)**. `item_gbn`/에디터 플래그/템플릿 리소스 ID에 대응할 컬럼·테이블이 라이브에 있는지 갭분석가 확인 필요(huni-widget이 Edicus 통합을 *코드 계약*으로만 가지고 DB 그릇은 미정). 후니 위젯이 Edicus 어댑터를 쓰므로 입력채널 메타(에디터 타입·템플릿 리소스·VDP 변수 스키마)를 담을 그릇 설계가 vessel 단계 과제.

---

## ═══ TP facet 판정 (distinct 거부 — 양면 트레이드오프) ═══

## T-A. 템플릿 자산(에디터 디자인 시안) — **입력채널 리소스 facet + 템플릿#4 이중의미 분리 (distinct 거부)** ★핵심 의사결정

**정체 후보:** `useTemplateDownload=Y` + `koi_template_resource_id`/`koiOption[]` + RedEditorSDK `getTemplateList`/`setCurrentTemplate`/`changeTemplate` = 에디터가 별도 카탈로그에서 로드하는 기성 디자인 시안(가격 0).

**★양면 트레이드오프(침묵 선택 금지):**
- **(가) 별도 distinct "템플릿 자산" 축 신설:**
  - 찬성: 옵션도 SKU도 아닌 별 성격(에디터 종속·가격 0·런타임 카탈로그 로드). reverse T-2가 "1순위 분리 필요" 제기.
  - 반대: 템플릿 자산은 *독립 lifecycle/governing이 없음* — 항상 에디터 채널(D-11)이 있을 때만 존재(`useKoiEditor=N`이면 템플릿 자산도 0). 즉 D-11의 *하위 리소스*이지 동급 축 아님. 신축 시 D-11과 1:1 종속 축 2개로 분열(중복).
- **(나) 입력채널(D-11)의 리소스 facet + 템플릿#4 이중의미 명시 분리 [채택]:**
  - 템플릿 자산 = D-11 에디터 채널이 제공하는 디자인 시안 카탈로그(`TemplateAsset` 그릇·D-11 종속). 가격 0·런타임 SDK 로드.
  - **★[HARD] 템플릿 "이중의미" 분리:** 후니 `t_prd_templates`(완제SKU·봉투결합 엽서·OTC = 메타모델 #4)와 **같은 단어 다른 의미**다. TP 템플릿 자산 = *디자인 시안*(에디터 입력 리소스), #4 템플릿 = *완제 주문 단위*(번들 SKU). 사전(#4)에 이 이중의미를 명시 구분(아래).

**판정: facet — D-11 입력채널의 리소스 facet (distinct 거부). 단 [HARD] 템플릿#4와 의미 분리 명시.** 신축은 D-11과 종속 중복. 단 메타모델 #4 "템플릿/SKU"가 *두 의미*(완제SKU vs 에디터 디자인 자산)를 갖지 않도록 — **#4=완제SKU 번들(주문단위)**, **TemplateAsset=에디터 입력 디자인 시안(D-11 종속·가격0)**로 별 엔티티 분리. RedPrinting `koi_template_resource_id`는 후자, `t_prd_templates`는 전자.

## T-B. VDP(가변데이터 인쇄) — **입력채널 데이터바인딩 facet × 수량 (distinct 거부)**

**정체 후보:** RedEditorSDK `openVdpViewer`/`setVariableData`/`getCurrentTemplateVdpList`(seed §10) + Edicus `data_row`/`data_feed`/`ddp_block` 핸드셰이크(bridge §3~4) = 명함 이름·직함, 상장 수상자명 등 *변수 데이터로 다건 인쇄*.

**판정: facet — D-11 입력채널의 데이터바인딩 능력 facet × 수량모델(#10) (distinct 거부).** VDP = 에디터 채널(특히 Edicus)이 *제공하는 능력*(D-11 facet)이며, 변수 데이터 행수는 *디자인 수(ORD_CNT)/인쇄 수량*으로 이미 수량모델(#10)이 담음. 별 lifecycle 없음(에디터 없으면 VDP 없음). **도메인 정합:** bridge §3 `create-design-project`/`data_feed` = VDP 프로젝트 = 입력채널 모드. 명함(TPBCDFT)·상장(TPPOAWD)이 강한 VDP 후보(reverse §1·§4-E). 미관측(`koiOption[]` 빈배열·VDP 변수 스키마 unobserved) → 갭 단계 확정.

> **★[검증 확정 2026-06-17] facet 판정 옳음(codex H-6 "VDP=독립 1급축" REFUTED).** 실측: VDP = RedEditorSDK **45메서드 중 3개**(`openVdpViewer`/`setVariableData`/`getCurrentTemplateVdpList`·seed §10)이지 독립 엔티티 아님 · `getCurrentTemplateVdpList`="**현재 템플릿의** VDP"=리소스 종속 · `data_feed`/`ddp_block`=Edicus iframe deferred 파라미터(에디터 떠야 흐름·bridge:37) · `edicus_item`에서만 VDP(offset/PDF전용엔 없음)=**#16 ⊃ VDP 포함관계(직교 아님)** · 라이브 VDP 컬럼/테이블/enum 0건이 **#16 GAP에 완전 포함**(분리 흔적 없음). codex가 든 "필드정의·CSV·넘버링·PII"는 base-data가 아니라 *주문 시점 에디터 런타임 데이터* → 1급 관리축화는 오버피팅. **T-B facet 유지 확정.** (판정 상세 = `categories/TP/deepcheck.md` "## 검증 결과 — H-6·H-1".)

## T-C. 페이지 계층(INN_PAGE) — **수량모델(#10)/사이즈(#13) 확장 facet (distinct 거부)**

**정체 후보:** `pdt_prn_cnt_info` MIN/MAX/STEP_INN_PAGE(TPCLECO 2~200·STEP1, TPCLWLB 1) = 캘린더 월수·북 대수 페이지수 입력.

**판정: facet — 수량모델(#10) 다중슬롯 확장 + 제약(#5 min/max/step) (distinct 거부).** INN_PAGE = "내지 페이지수"라는 *수량성 슬롯*으로, ORD_CNT(디자인건수)/PRN_CNT(인쇄수량)/bundle_qty(묶음)과 나란한 **수량모델(#10)의 또 다른 의미 슬롯**(평면화 금지 원칙 동형). 값 범위(min/max/step)는 제약(#5 min-max). **도메인 정합:** seed §3 책자 "내지장수(2~130)" + bridge `num_page·max_page·min_page·unit_page`(에디터 공통 파라미터) = 후니/RP 모두 페이지수를 수량성 입력으로 운영. 가격 결합(TPCLECO tiered_price ↔ INN_PAGE)은 unobserved → 갭 단계. distinct 신축 불요(수량모델이 이미 다중슬롯 축·#10).

## T-D. 티켓 형태 variant(M/I/보딩·캘린더 탁상/벽걸이) — **사이즈/형상(#13) + 칼틀 공정(#2) facet (distinct 거부)**

**정체 후보:** 티켓 M형/I형/보딩, 캘린더 탁상/벽걸이타공/벽걸이걸이 = 형태 variant → 사이즈·칼틀·제본 캐스케이드.

**판정: facet — 사이즈축(#13 형상 흡수) + 칼틀 공정(#2 THO_EXC) + 제본(#2) 캐스케이드 (distinct 거부).** GS THO_CUT 형상 variant(하트/여권 = 사이즈 칼틀 1:1)와 **완전 동형**(reverse §2 note). 형태 = 사이즈 프리셋/칼틀의 enum이지 고유 축 아님(BN 어깨띠 형상=사이즈 흡수 A-3, GS 폰케이스 기종=사이즈 G-3 동일 판정). 형태↔칼틀/사이즈 = 제약(#5 match). 신축은 오버피팅(SKILL §5).

## T-E. 특수인쇄(PRT_WHT/PRT_MAG)·박(TPTKFOI FOI)·미싱/넘버링 — **공정(#2) facet (distinct 거부)**

**판정: facet — 공정 축(#2)의 멤버 (distinct 거부).** ① **PRT_WHT(화이트언더베이스)** = 공정(별색 family·화이트 후공정, 도메인 경계규칙 "별색=공정·잉크색≠자재" 정합·entity-semantic #2). ② **PRT_MAG(메탈릭/마그넷 인쇄)** = 공정(특수인쇄). ③ **박(FOI·TPTKFOI)** = 공정 확정(GS/AC 박 동형). ④ **미싱(절취선)·넘버링(일련번호)** = 공정(#2) + (넘버링이 순차 증분이면 VDP=T-B 데이터바인딩일 수 있음). reverse T-3 "순차/절취 공정축" 가설은 — *절취선*은 공정#2(기존), *순차번호*는 VDP(T-B)/공정#2로 분배되어 **신축 불요**. 단 넘버링 규칙(가변 증분)은 unobserved → 갭 단계 확정(VDP vs 공정 귀속 라이브 확인). **도메인 경계(HARD):** PRT_WHT를 도수(별색)나 자재(백색잉크)로 오적재 금지 — 별색=공정(round-22 경계규칙·메모리 `dbmap-axis-staged-load-round22`).

---

## TP 판정 요약표

| 발굴 | 1차 귀속 | 판정 | distinct/facet | 등재 |
|---|---|---|---|---|
| 에디터 채널(item_gbn+플래그) | **디자인 입력 채널** | 본체와 직교·가격0·비-TP 트윈 대조 | **distinct** ★ | D-11 / #16 |
| 템플릿 자산(koi_template_resource) | D-11 facet + 템플릿#4 이중의미 | 에디터 종속 리소스·#4와 다른의미 | **facet(거부)** ★ | T-A |
| VDP(setVariableData) | D-11 facet × 수량#10 | 에디터 데이터바인딩 | facet(거부) | T-B |
| 페이지계층(INN_PAGE) | 수량#10 + 제약#5 | 수량성 슬롯+범위 | facet(거부) | T-C |
| 형태 variant(M/I/보딩) | 사이즈#13 + 칼틀#2 | 사이즈/형상 흡수 | facet(거부) | T-D |
| 특수인쇄/박/미싱·넘버링 | 공정#2 (+VDP) | 별색=공정 경계 | facet(거부) | T-E |
| 이중수량 ORD_CNT(디자인수) | 수량#10(기존 D-5) | usePDFordCnt 연동 | 기존 흡수 | #10 |
| 제본 쫄대(STA_CLD) | 공정#2+자재#1 bundle | 링/쫄대 consumes | 기존 흡수 | #1·#2 |

**TP 강제 분류 회피(SKILL §3·§5):** distinct 승급 = **D-11 디자인 입력 채널 1종**(BN·GS·TP 세 군 견디는 게이팅 lifecycle + 비-TP 트윈 직접 대조). T-A~T-E는 양면 트레이드오프(특히 T-A 템플릿 자산) 펼친 뒤 facet 강등. 단일 카테고리 전용 축 신설 0건. ★T-A는 침묵 선택 거부하고 "템플릿 이중의미" 명시 분리.

---

## ═══ PR 통합 발굴 (v4.0 — 다면·제본·접지·인쇄방식) ═══

> `categories/PR/reverse.md` P-1~P-9 판정. 4 상품군(BN·GS·TP·PR) 증거. **distinct 승급 0건 — 전부 facet/family/cascade/정책.** 상세 판정 = `_resolved-fragments.md` PR 섹션.
> 도메인 정초 = `07_domain/entity-semantic-model.md`(자재 usage_cd 7종·page_rule 엔티티) + reverse 실측(FLD_DFT 7종·제본 5방식·pdtCode prefix). domain-researcher 신규 호출 불요(추정 0).

| frag | 정체 | 1차 귀속 | 판정 | distinct/facet |
|---|---|---|---|---|
| **P-1** | 접지(FLD_DFT 7종)의 면 인코딩 | 공정#2 family + 파라미터#9 + 제약#5 | 면수=파생값(축 아님)·접지↔오시 cascade·평면 종이 면가공 family | **facet(거부)** |
| **P-2** | 표지/내지 역할 자재 슬롯 | 자재#1 usage_cd 슬롯 | role 전파(자재→도수→가격→평량) 격상·★트레이드오프 | **facet(거부)** ★ |
| **P-3** | 페이지수 INN_PAGE | 수량#10 슬롯 + 제약#5 = page_rule | TP T-C 합류·후니 page_rule 엔티티 정밀 | **facet(거부)** |
| **P-4** | 제본/인쇄방식/도수 분기 | 인쇄방식#12·공정#2·기초코드#6 | 공정방식=상품분기 정책패턴(GS G-2·TP T-4 동류) | **facet/정책** ★ |
| **P-5** | 면지 END_PAP bundle | 자재#1(usage.03)+공정#2 | 컬러지+삽입 bundle(D-2 동형) | **facet(거부)** |
| **P-6** | 규격 vs 면적 경계 | 가격#11 라우팅 + 사이즈#13 | 같은좌표·다른엔진(digital_price/면적) | **facet(거부)** |
| **P-7** | 인쇄방식 종속 자재(YWM) | 인쇄방식#12 → 자재#1 게이팅 | 자재풀 게이팅 관계 간선 강화 | **facet(거부)** |
| **P-8** | 용도별 책자 분류 | 카테고리#7 태그/마케팅 라벨 | 본체 불변·용도 라벨만 | **facet/정책** |
| **P-9** | 스코딕스/레이저커팅 | 공정#2 멤버 (+칼틀 사이즈#13) | 새 멤버 family·축 아님 | **facet(거부)** |

### P-2 양면 트레이드오프 (침묵 선택 거부) ★핵심 의사결정

표지/내지 role(cover/inner)이 자재뿐 아니라 도수·가격·평량제약 *전부를 role-paired*로 전파(`inner_pdt_*` 평행 스키마, F_CVR vs K_INN, COV_MIN_WGT vs INN_MAX_WGT)하는 것을 보고 **별 "역할(role) 차원" 축 신설**(찬성=pricing-role#11처럼 횡단 전파)을 검토했으나 **거부**: role=*새 관리대상이 아니라 기존 usage_cd 차원의 값*(.01내지/.02표지/.03면지)으로, 후니 도메인 권위(`entity-semantic-model.md:23` USAGE 7종)가 이미 슬롯으로 모델링. 도수/가격이 role-paired인 것은 usage_cd가 그 축들로 *전파*된 간선이지 별 축 아님(신축 시 usage_cd와 1:1 중복). **채택=자재#1 usage_cd 슬롯 facet + role 전파 명시 격상**(RP `inner_pdt_*`=usage 슬롯의 물리 구현). PR이 추가한 것 = usage_cd가 "태그"에서 "자재→도수→가격→평량 전파 역할"로 격상됨을 입증(#1·#6·#11·#13 반영).

### P-4 양면 트레이드오프 (정책 라우팅)

책자 19상품(윤전/토너 × 무선/스프링/트윈링/스테플러/실제본 × 컬러/흑백 매트릭스를 개별 pdtCode로 펼침)의 **상품분기 vs 옵션화**는 메타모델 판정 아닌 **후니 카탈로그 정책**(GS G-2·TP T-4 동류). (가) RP 답습(pdtCode 분리·자재풀/가격엔진 다름이 정당화) vs (나) 옵션화(카탈로그 축소·관리용이). 권고 하이브리드: **도수=옵션화(자재풀 동일)·인쇄방식=별 pdtCode(#12 자재풀·가격엔진 게이팅·P-7)·제본방식=캐스케이드 정도 따라**. 메타모델은 양쪽 표현 가능(인쇄방식#12·공정#2·기초코드#6 분배). → gap/실무 정책.

---

## ═══ ST 통합 발굴 (v5.0 — 형상·칼선·재단입자·점착소재·인쇄방식) ═══

> `categories/ST/reverse.md` S-1~S-10 판정. **5 상품군(BN·GS·TP·PR·ST) 증거.** ★**distinct 승급 1종(D-12 형상) = 16축 포화 붕괴 — #17.** 나머지 9 fragment 전부 facet/family/cascade/정책. 상세 판정 = `_resolved-fragments.md` ST 섹션.
> 도메인 정초 = `07_domain/{entity-semantic-model.md(형상 G-SK-2·variant 분해·usage_cd·material 두께),pdf-domain-knowledge.md(반칼 PROC_000054·완칼 053·스티커완칼 055·도무송·Case2 스티커 레시피),db-domain-structure-live.md(공정 멤버 트리)}` 실측 — **domain-researcher 신규 호출 불요**(칼선 반칼/완칼/도무송·인쇄방식 UV/DTF·점착 의미 전부 후니 KB에 확정 존재).

| frag | 정체 | 1차 귀속 | 판정 | distinct/facet |
|---|---|---|---|---|
| **S-1** | 형상(shape_info SQ/CL/EL/RC/FR) | **신규 형상축 #17** | 사이즈와 분리된 전용 enum 슬롯·1:多 칼틀 span·후니 KB G-SK-2 size축 미수용 | **distinct(★#17)** ★ |
| **S-2** | 칼선 2메커니즘(THO_GRA/THO_DFT) | 공정#2 family + 사이즈#13 | 모양커팅 공정의 두 모드·도무송=공정 멤버·프리셋칼틀이 사이즈 겸함 | **facet(거부)** |
| **S-3** | 재단 입자(반칼/완칼/낱장) | 공정#2 멤버 | 반칼=PROC_054·완칼=053·스티커완칼=055 전부 공정 멤버(KB 결정적) | **facet(거부)** |
| **S-4** | 점착/내후 소재(강접/리무버블/옥외/저온/자석/메탈/한지) | 자재#1 합성 차원 | 색상/두께→material 동형·adhesion/weatherability 합성축 추가 | **facet(거부)** ★ |
| **S-5** | 인쇄방식(일반/UV/DTF/후지) | 인쇄방식레시피#12 | PR 윤전/토너/인디고와 합류·pdtCode 분기·자재풀/도수/화이트/가격엔진 게이팅 | **facet(거부·PR P-4/P-7 합류)** |
| **S-6** | 판/die-cut/정가 3가격엔진 | 가격#11 라우팅 | digital_price/vTmpl/tmpl(PR P-6·GS G-7 합류) | **facet(거부)** |
| **S-7** | 화이트강제(PRT_WHT 일반선택/DTF강제) | 공정#2 + 제약#5 | 별색=공정·DTF→화이트 force cascade(TP T-E 합류) | **facet(거부)** |
| **S-8** | disable_pcs 227건 룰엔진 | 제약#5 disable | BN 강제·PR 24건의 정점 케이스·룰엔진 일반화 검증 | **facet(거부·#5 정점)** |
| **S-9** | 넘버링(NUM_DFT 가변 일련번호) | 공정#2 (+VDP#16) | TP T-3/T-E 동형·절취=공정·순차=VDP/공정 | **facet(거부)** |
| **S-10** | 완제SKU형(테이프/밴드/카드스티커) | 템플릿#4 + 생산형태#15 | GS tmpl 완제SKU 합류·die-cut/판도 아닌 규격 완제 | **facet(거부)** |

---

## D-12. 형상 축 (Shape) — distinct ✅ (ST 신축·#17) ★16축 포화 최초 붕괴

**정체:** 인쇄물의 *외곽 형상*(사각/원형/타원/사각라운드/자유형)을 사이즈와 *분리된 전용 enum 슬롯*으로 관리하는 축. 형상이 ① 칼틀(THO_DFT) enum의 *부분집합을 게이팅*하고 ② 자유형(FR)이면 자유칼선(THO_GRA)을 강제하며 ③ 상품 분기(원형=STTHCIC)와 한상품 옵션(STDCFBR 5형상)을 모두 인코딩.

**증거(ST — ★직접 실측):**
- **전용 슬롯:** `option_info.shape_info`가 형상 코드(SQ/CL/EL/RC/FR)를 *옵션 트리 밖 별도 슬롯*으로 보유(reverse §0.1·§1·§2 실측). 자재/사이즈/공정과 다른 인코딩 위치.
- **★형상↔사이즈 1:多 (distinct 핵심):** 한 형상이 *다수 칼틀/사이즈를 span* — CL 원형 → THO_DFT/CL001~CL010(10X10~100X100) + CLFRE(자유원형), RC 사각라운드 → RC001~RC025(40X20~100X100) + RCFRE(reverse §0.2 실측). 즉 형상은 사이즈 프리셋의 *상위 분류자*이지 사이즈 자체가 아님.
- **★5형상 superset 1상품:** STDCFBR(패브릭 데코)가 SQ/CL/EL/RC/FR *5형상 전부*를 한 상품에 담음(reverse §0.1) — 형상이 사이즈와 독립한 *선택 차원*임을 단일 상품으로 입증(형상=사이즈면 한 상품에 5사이즈군이 공존할 수 없음).
- **형상→칼선 게이팅:** shape=FR이면 칼선이 THO_GRA(자유 도무송)로 자동 강제(VIEW_YN=N), shape=SQ/CL/RC면 THO_DFT(형상별 프리셋칼틀)로 강제(reverse §0.1·§0.2). 형상이 칼선 메커니즘을 결정.

**도메인 정초(후니 KB 권위 — ★결정적):**
- `entity-semantic-model.md:39` **"size축에 형상 enum drop(sticker G-SK-2): 도형/치수 enum(원형 25~90mm)이 *어느 축에도 없음*"** — 후니 자신이 형상 enum을 담을 축이 부재함을 결함으로 명시. = 사이즈축(#13)이 형상을 *왜곡 없이 못 담음*의 1급 증거(distinctness test §3 충족).
- `entity-semantic-model.md:22` size = "재단치수(고객 선택 완성품 치수)" — 치수(width×height)이지 *형상(원/사각)*이 아님. 형상은 치수의 상위 분류이며 별 의미축.

**distinctness(distinctness test §3) — 적대 판정:**
- **vs 사이즈축(#13)[핵심 반론 검토]:** 기존 메타모델은 형상을 *사이즈에 흡수*해왔다 — 어깨띠(A-3 "폭좁고 김"=사이즈), GS THO_CUT(하트/여권=칼틀↔사이즈 1:1), TP 티켓 M/I/보딩(T-D=사이즈/칼틀 1:1). **이 흡수의 전제 = "형상=사이즈 프리셋 1:1"**. ST가 이 전제를 깬다: 형상↔사이즈 **1:多**(CL 형상 1개 ↔ CL001~100 칼틀 10+종), 전용 `shape_info` 슬롯, 5형상 superset. 사이즈축으로 형상을 표현하면 "원형이라는 사실"을 매 사이즈 프리셋에 중복 인코딩해야 함(정규화 붕괴) → 형상은 사이즈의 *상위 분류축*이지 흡수 대상 아님. **단 이전 BN/GS/TP/PR 흡수 판정을 번복하지 않음** — 그들은 진짜 1:1(형상이 사이즈 프리셋 1개와 동치)이라 사이즈 흡수가 정당. ST만 1:多 분리가 *명시 슬롯으로* 드러나 distinct 승격. (메타모델 정답: 형상축은 1:1이면 사이즈에 흡수 표현·1:多면 별 분류 슬롯 — ST가 후자를 강제.)
- **vs 기초코드(#6):** 형상 enum 자체는 기초코드 도메인(코드값 거버넌스). 그러나 형상은 *칼선/사이즈/칼틀을 게이팅하는 분류 lifecycle*을 가짐(단순 코드 도메인 아님) → 기초코드는 형상의 *값 도메인 공급자*이지 형상의 게이팅 관계를 못 담음.
- **vs 공정(#2 칼선):** 형상은 칼선을 *게이팅*(FR→THO_GRA, SQ→THO_DFT)하나 칼선 자체는 아님. 형상=분류(무엇을 만드나)·칼선=공정(어떻게 자르나). 별 lifecycle.
- **lifecycle:** 형상이 (a) 칼틀 enum 부분집합(b) 칼선 메커니즘(c) 사이즈 입력 모드(자유형=자유사이즈/정형=프리셋)를 게이팅. 1상품에 형상 1개(상품분기) 또는 N개(STDCFBR 옵션) — 인코딩 유연. 기존 어느 축도 이 게이팅을 단독으로 못 함.

**오버피팅 검토(SKILL §5):** ST 단일 카테고리지만 — ① **STDCFBR 5형상 superset** 단일 상품 내 입증(형상=옵션 차원) ② **전용 `shape_info` 슬롯**(RP가 형상을 사이즈와 분리해 1급 슬롯화) ③ **후니 KB가 형상 enum 미수용을 결함으로 명시**(G-SK-2 — 단일 상품 사유 아닌 도메인 1급 갭) ④ 형상은 BN 어깨띠·GS 하트·TP 티켓·PR 카드형에도 *값으로* 존재(전 카테고리 횡단)이나 ST가 그것을 *사이즈와 분리해 전면화*. → 단일상품 아님, distinct 정당. **단 1:1 흡수 가능 카테고리(BN/GS/TP/PR)는 사이즈 표현 유지** — 형상축은 1:多 분리가 필요한 곳(ST·도무송 자유형·칼틀 enum 깊은 상품)에서만 별 슬롯.

**관계:**
- Shape → Product(classifies — 상품분기 1:1 또는 한상품 N형상 옵션).
- Shape → SizePreset(#13, **gates** — 형상이 칼틀/사이즈 프리셋 부분집합 결정: CL→CL001~100).
- Shape → ProcessMember(#2 칼선, **gates** — FR→THO_GRA 자유칼선·정형→THO_DFT 프리셋칼틀).
- Shape → 사이즈 입력모드(자유형=nonspec 자유사이즈·정형=프리셋 enum).
- Shape ⊂ 기초코드(#6, 값 도메인 공급).

**★후니 갭(갭분석가 주목):** 후니 t_*에 "형상" 그릇 **부재 확정**(KB G-SK-2가 "어느 축에도 없음" 명시). 도형/치수 enum(원형 25~90mm)이 size축에 drop됨 = vessel-gap. 갭분석가가 라이브 information_schema에서 shape 컬럼/테이블 유무 확인 + 형상이 칼틀(완칼 PROC_053 `모양`·반칼 PROC_054 `모양`)과 어떻게 연결되는지(형상→칼틀 게이팅 그릇) 설계 필요. **단 1:1 흡수 카테고리는 size 프리셋 유지(형상축 강제 적용 금지·오모델 회피).**

---

## 종합 — 7버킷 재평가

| 7버킷 | 발굴로 인한 재평가 |
|---|---|
| 자재 | **심화** — 단순 enum이 아닌 합성+usage+공정결합 메타규칙(D-2) |
| 공정 | **확장** — 자재소비 플래그(D-2) + 파라미터 종속(D-4) |
| 옵션 | **분화** — 수량은 별도 다중슬롯 모델(D-5), 파라미터는 공정종속(D-4)로 분리 |
| 템플릿/SKU | **인접 축 분리** — 부속물(D-1)은 별개(템플릿=번들단위, 부속물=부품) |
| 제약 | **유형화** — 객체가 아닌 6 논리유형 거버넌스(D-3) |
| 기초코드 | (유지) — enum 도메인 거버넌스, 사이즈 프리셋·도수 enum. GS: 도수 enum에 SID_X(무인쇄·텀블러) 확인 |
| 카테고리 | **GS 보강** — 공통 기능 그룹화(코스터 6 pdtCode=1 노드) 확인. 생산형태는 직교 distinct로 분리(D-9) |
| 신축(GS) | **생산형태(D-9)·본체 형태가공(D-10)** — 완제/입체 굿즈가 드러낸 distinct 2축 |
| 템플릿/SKU | **TP 이중의미 분리** — #4=완제SKU 번들(주문단위) vs TemplateAsset=에디터 디자인 시안(D-11 종속·가격0). 같은 단어 다른 의미 명시(T-A) |
| 신축(TP) | **디자인 입력 채널(D-11)** — KOI/Edicus/PDF 에디터 채널이 본체 옵션과 직교한 입력 레이어. 가장 강한 vessel-gap |
| 사이즈/기초코드 | **★ST 형상축 분리** — 사이즈#13가 형상을 1:1 칼틀로 흡수해온 전제가 ST에서 1:多로 깨짐(CL→CL001~100). 형상=사이즈 상위 분류축(D-12·#17). 후니 KB G-SK-2 "형상 어느 축에도 없음" 확증 |
| 신축(ST) | **★형상(D-12·#17)** — 전용 shape_info 슬롯·형상↔사이즈 1:多·5형상 superset. **16축 포화 붕괴**(5번째 카테고리가 distinct 1종 도입·오버피팅 아님) |

**TP로 해소/추가된 갭:** ① **디자인 입력 채널 = 1급 distinct 축 확정**(비-TP 트윈 HLCLSTD 직접 대조 + huni-widget RedEditorSDK 계약). ② **템플릿 이중의미 분리**(완제SKU vs 에디터 디자인 자산) — 후니 `t_prd_templates` 매핑 시 혼동 방지. ③ **여전히 미관측(TP):** 템플릿 자산 카탈로그·VDP 변수 스키마(`koiOption[]` 빈배열·로그인 에디터 필요)·티켓 넘버링 규칙(VDP vs 공정 귀속)·INN_PAGE↔가격 결합 → 갭/검증 단계로 라우팅.

**PR로 해소/추가된 것 (v4.0):** ① **16축 포화 입증** — 4번째 카테고리가 distinct 신축 0 → 모델이 RedPrinting 카탈로그 shape를 견딤(강한 검증). ② **공정#2 "접지(folding)" family** — BN/GS/TP 미발굴 평면 종이 면가공(2단=4면…) + 접지↔오시 동반 cascade 신규 등재. ③ **자재#1 usage_cd 역할 전파 격상** — BN substrate 단일·GS 다중슬롯에서 PR이 표지/내지를 *별 평행 스키마(`inner_pdt_*`)*로 구현 + role이 도수/가격/평량으로 전파됨을 입증(usage_cd=태그→전파 역할). ④ **page_rule 엔티티 정밀** — INN_PAGE=수량#10 슬롯이자 후니 `_page_rules`(min/max/incr) 별 엔티티(TP T-C 합류). ⑤ **인쇄방식#12 자재풀 게이팅** — 윤전→YWM pool(가능 공정뿐 아니라 가능 자재 부분집합도 게이팅). ⑥ **가격#11 digital_price 라우팅** — 같은 좌표(CUT_WDT/HGH) 입력이 포스터=digital_price(규격/자유)·BN=면적매트릭스로 분기(pricing_model 5종).

**GS로 해소된 BN 갭:** ① **자재 usage 다중슬롯** — GS 스프링노트(표지+내지+링) 실관측으로 BN substrate 단일 한계 해소(#1 GS 확인 ✅). ② **생산형태** — GS C 완제품 다수 노출로 distinct 확정(D-9·도메인 권위 C-9 정합). ③ **완제 SKU 본체 모델링** — GS DIR_MTR로 패턴 확정(G-1 facet 판정).

**ST로 해소/추가된 것 (v5.0·★포화 붕괴):** ① **16축 포화 붕괴 — 형상축(#17) distinct 승격** — 5번째 카테고리(ST)가 새 관리축 1개 도입. PR(v4.0)이 입증한 16축 포화를 ST가 정직하게 깸. 이는 오버피팅이 아니라 *사이즈축이 형상을 1:1 칼틀로 흡수해온 전제가 ST의 전용 shape_info 슬롯·형상↔사이즈 1:多로 깨진* 증거 강제 결과. **단 PR 포화 입증(distinct 0)도 여전히 유효** — PR은 형상을 1:1로만 가져 흡수가 정당했고, ST가 1:多 분리를 *명시 슬롯으로* 드러내 차이를 만듦(모델 진화는 카테고리 증거에 정직). ② **칼선/재단입자=공정#2 family 확정** — THO_GRA/THO_DFT·반칼/완칼이 후니 KB(PROC_053/054/055·도무송)로 공정 멤버 확정(신축 거부·도메인 권위 결정적). ③ **점착/내후=자재#1 합성 차원 추가** — adhesion/weatherability가 색상/두께처럼 material 합성축(자재#1 강화·신축 아님). ④ **인쇄방식 횡단 통합** — ST 일반/UV/DTF/후지 + PR 윤전/토너/인디고가 #12 "인쇄방식=상품분기" 횡단 패턴 합류(S-5↔P-4/P-7). ⑤ **disable 룰엔진 정점(227건)** — ST disable_pcs가 BN 강제·PR 24건의 정점 케이스로 #5 룰엔진 일반화 검증(S-8).

**여전히 미발굴(2 상품군 한계):** ① **카테고리 트리 깊이/다중분류** — GS도 옵션 트리 라이브 추출 불가(신규 Vue client-render)로 다중분류(한 상품 여러 트리) 직접 미관측. ② **템플릿 template_selections 구조** — 완제 SKU 번들 구성 선택 묶음 상세(봉투결합 엽서·OTC) 미관측. ③ **코드 채번 거버넌스** — pdtCode/PCS_COD/DTL 채번 규칙. → 책자(booklet, A통합+B셋트 명시)·문구(stationery) 샘플로 확대 권고.

---

## ═══ PD 통합 발굴 (v8.0 — 봉제 구조물 완제품·조립·3D폼·단수·완제 내재BOM) ★조립 distinct(#18) 적대 판정·재포화 ═══

> `categories/PD/reverse.md` PD-1~PD-5 판정. **8 상품군(BN·GS·TP·PR·ST·CL·AC·PD) 증거.** ★**distinct 승급 0건 — 17축 재포화(PR 4번째·CL 6번째·AC 7번째 패턴 반복).** PD reverse가 1차 예측한 "distinct 0(8번째 재포화)"를 적대 판정으로 비준 — 가장 이질적인 *봉제 구조물 완제품*(스툴·슬리퍼·강아지계단)조차 17축 무손실 흡수. PD-1~PD-5 전부 기존 17축 facet/family/cascade로 분해. 상세 판정 = `_resolved-fragments.md` PD 섹션.
> 도메인 정초 = `07_domain/entity-semantic-model.md`(addl_product 부속물·생산방식 A/B/C·자재 usage·두께=자재) + AC §0.3(입체/스탠드 분산 facet)·GS(완제 본체 G-1·형태가공 D-10/#14)·ST(형상#17) 직접 대조. **★domain-researcher 신규 호출 불요** — 봉제/제품가공(=공정#2/형태가공#14)·완제 구조물 BOM(=부속물#8+생산형태#15+가격#11)·단수(=사이즈#13 프리셋)가 후니 KB+기존 17축에 확정 존재(추정 0).
> **★PD 핵심 판정 — directive 최대 관전(조립·구조·3D폼·완제 내재BOM): distinct #18 부결(전부 기존 축).** PD가 던진 진짜 질문은 새 옵션축이 아니라 "완제품 내재 제조레시피를 옵션과 분리해 어디에 두는가"(PD-4) — 답=**부속물#8 + 생산형태#15 + 가격#11(tmpl)이 분담**(별 "완제 BOM 축" 불요). 봉제=형태가공#14(GS D-10 이미 distinct, SEW_LTR=새 family 멤버)·단수=사이즈#13 프리셋·3D폼=AC §0.3 분산 facet 동형.

| frag | 정체 | 1차 귀속 | 판정 | distinct/facet |
|---|---|---|---|---|
| **PD-1** | 봉제/제품가공(SEW_LTR·PDT_WRK) | 본체 형태가공#14(GS D-10) + 공정#2 | SEW_LTR=#14 봉제 family 신규 멤버·PDT_WRK=GS 동형·기존 PCS 슬롯 인코딩 | **facet(거부)** ★ |
| **PD-2** | 직물/PU 원단 자재(종이 아님) | 자재#1 PTT 차원 값 확장 | AC 아크릴·CL 의류원단 동형·비종이 자재 이미 다 관측·면10수=수단위 평량 다형성 | **facet(거부)** |
| **PD-3** | 단수(2단/3단)·스툴 형상 | 사이즈#13 프리셋 흡수 | 단수=구조이나 사이즈 프리셋 1:1 인코딩·형상=ST 1:多 미충족(원형↔305×305 1개) | **facet(거부)** ★ |
| **PD-4** | ★완제 구조물 내재 제조BOM(다리/받침/솜/지퍼/논슬립) | 부속물#8 + 생산형태#15 + 가격#11(tmpl) | 옵션 미노출=고정 제조사양·후니 KB "완제 BOM 어느 축에도 없음" 결함 부재(addon/usage/생산형태 담음)·형상#17과 정반대 | **분산 facet(거부·#18 부결)** ★강후보 |
| **PD-5** | 모양커팅 enum·추가부자재 enum·가격 결합 | 공정#2(THO_CUT)·부속물#8(SUB_MTR)·가격#11 | infoCall 후행 unobserved·축 판정 무영향(SSR 슬롯으로 확정) | **facet(거부·unobserved)** |

### PD-4 양면 트레이드오프 (침묵 선택 거부) ★directive 핵심 의사결정 — 완제 구조물 내재BOM

PD reverse가 명시한 directive 핵심: "후니가 완제 구조물(스툴/슬리퍼/반려동물용품)을 취급하려면 *고정 제조 BOM*(다리 종류·솜 충전·논슬립 원단)을 어딘가 관리해야 — 옵션으로는 안 띄우되 생산정보로는 보유. 별 '완제 구조물 BOM' 그릇이 필요한가 = vessel-gap 후보." 적대 판정:

- **(가) distinct "완제 구조물 내재BOM 축 #18" 신설:**
  - 찬성: 봉제 구조물의 고정 부품(다리/받침/솜/지퍼/논슬립)이 옵션 슬롯에 *없으면서도* 생산정보로 존재 — 옵션축(노출)·자재축(본체 substrate)·공정축(작업)이 "옵션 미노출 고정 제조 부품 명세"를 직접 담지 않음. RP가 마케팅 카피로만 둠 = 관리 그릇 부재 신호(ST 형상 shape_info 전용 슬롯처럼 "전용 관리 대상" 가설).
  - 반대: ★세 갈래로 무손실 분해 — distinct가 요구하는 "기존 축이 *왜곡 없이* 못 담는 고유 lifecycle/governing"이 **없음**.
    - **① 완제 부속 부품(다리·받침·논슬립 패드)** = **부속물 축#8**(addl_product). 후니 KB `entity-semantic-model.md:30` "addl_product(`_addons`) 추가상품(완제 부속: 거치대·우드봉·볼체인)·부착공정(process)과 축 분리" — 다리/받침/논슬립도 *본체와 분리된 완제 부속 부품*으로 부속물#8이 왜곡 없이 담음(BN 거치대·AC 등신대 받침 횡단 동형). 옵션 미노출=부속물의 *고정(필수 ESN=Y·고객 미선택)* facet이지 새 축 아님(AC 받침 ESN=Y 동형).
    - **② 솜 충전·지퍼·논슬립 원단** = **자재#1 sub_mtrl(usage_cd 슬롯) + 공정#2(봉제 consumes)**. 솜=충전 자재(usage), 지퍼=FLX_ZIP consumes 부자재(GS D-10 형태가공 #14 자재소비 동형), 논슬립 원단=바닥 자재행. 후니 자재 usage_cd 7종 + 공정 consumes FK(D-2)가 담음.
    - **③ "옵션 미노출 고정 제조" 성격 자체** = **생산형태#15(C 완제품) governing + 가격#11(tmpl_price 완제 단가)**. 완제품(C)은 본체 모델링을 *완제 SKU*로 governing(GS D-9)·내재 BOM은 그 완제품 정체에 묶인 *고정 레시피*. tmpl_price가 "내재 BOM 포함 완제 개당단가"를 담음(BN 면적가와 다른 완제 SKU 가격). 즉 "옵션 미노출"은 생산형태#15가 결정하는 *본체 모델링 결과*(완제품→내재 BOM 고정)이지 별 관리 축이 아님.
- **(나) 부속물#8 + 자재#1/공정#2 + 생산형태#15 + 가격#11 분산 facet [채택]:** 완제 구조물 내재BOM = 네 기존 축의 결합(부속 부품=#8·sub자재/봉제=#1/#2·완제품 governing=#15·완제 단가=#11). PD가 더한 것 = 부속물#8이 "고정(미노출·ESN=Y) 완제 부속"까지 포함함을 입증(AC 받침 ESN=Y 합류)이지 새 *축* 아님.

**★ST 형상(#17)과의 결정적 차이 — 왜 형상은 승격·완제 내재BOM은 부결(역방향 오류 점검):** 형상(#17)은 *사이즈축(#13)이 형상을 1:1 칼틀로 흡수해온 전제가 ST 1:多로 깨져* 기존 축이 *왜곡 없이 못 담음*이었고, **후니 KB G-SK-2 "형상 enum 어느 축에도 없음"이 결함으로 명시**되어 distinct가 강제됐다. 완제 내재BOM은 **정반대** — 후니 KB가 완제 부속(addl_product #9·`:30`)·자재 usage(#2·`:23`)·생산방식 A/B/C(#15·`:113`)를 *이미 1급으로 모델링*하며, "완제품 고정 BOM이 어느 축에도 없음" 같은 결함 명시 **없음**(부속물·usage·생산형태가 왜곡 없이 담음). → 형상=축 부재(distinct)·완제 내재BOM=축 충분(facet). **역방향 오류(distinct를 facet으로 숨김) 점검:** "옵션 미노출 고정 부품 명세"가 유일 잔여 후보였으나, 부속물#8의 *고정(ESN=Y·고객 미선택) 완제 부속* facet(AC 등신대 받침 ESN=Y 동형)으로 무손실 흡수 → facet 정당(숨김 아님·새 관리 관심사 없음). **단 vessel 단계 주목:** RP가 내재BOM을 마케팅 카피로만 두는 것은 *부속물#8/생산 BOM 그릇에 적재해야 할 데이터를 미적재*한 것(관리 축 부재가 아니라 데이터 갭) — 후니가 완제 구조물 취급 시 부속물#8(다리/받침/논슬립·고정 ESN=Y)·자재 usage(솜/지퍼)에 적재 = **data-gap이지 vessel-gap 아님**(갭분석가 주목).

### PD-1 봉제/제품가공 = 본체 형태가공#14(GS D-10) family 멤버

SEW_LTR(레더재봉)·PDT_WRK(제품가공)은 평면 원단/인쇄물을 *봉제·조립해 입체 완제 구조물 본체를 생성* — GS D-10(#14 본체 형태가공·PDT_WRK 파우치가공/FLX_ZIP 지퍼)과 **동일 lifecycle**(본체 형태 자체를 생성·없으면 본체 부재). PD-1 = **#14 형태가공 축의 새 family 멤버(SEW_LTR 봉제)** 추가이지 새 축 아님. PDWRSLP PDT_WRK는 GS PDT_WRK와 *동일 코드*(슬리퍼 조립 마감)·PDCHSTL/PDSRPPY SEW_LTR(레더재봉)은 #14에 "봉제(sewing)" family 멤버 신규 등재. THO_CUT(모양커팅)=공정#2(ST/GS 동형)·SUB_MTR(추가부자재)=부속물#8(AC/ST 동형). PD가 #14를 입증 강화(GS 굿즈 형태가공이 봉제 구조물 완제품으로 횡단 확장).

### PD가 입증한 것 (축 신설 아닌 *강화* + 17축 재포화)

1. **★17축 재포화(PR·CL·AC 패턴 반복)** — 8번째 카테고리(봉제 구조물 완제품)가 distinct 신축 0 도입. PR(4번째 0)→ST(5번째 형상 1)→CL(6번째 0)→AC(7번째 0)→**PD(8번째 0)** = 모델 안정성 재확인. 가장 이질적인 봉제 구조물(스툴/슬리퍼/계단)조차 17축 무손실 흡수.
2. **본체 형태가공#14 봉제 family 확장** — GS PDT_WRK/FLX_ZIP(파우치/지퍼)에 SEW_LTR(레더재봉) 봉제 멤버 추가. #14가 굿즈→봉제 구조물 완제품 횡단 입증.
3. **부속물#8 "고정(미노출·ESN=Y) 완제 부속" facet** — 완제 구조물 내재BOM(다리/받침/논슬립)이 부속물#8의 고정 부속(고객 미선택·AC 등신대 받침 ESN=Y 동형). 옵션 미노출이 부속물의 필수성 차원.
4. **자재#1 비종이 원단 차원 확장** — 면10수/슬리퍼원단/PU폴리우레탄(직물·합성수지) = AC 아크릴·CL 의류원단 합류. 면10수="수(번수)"단위 평량 다형성(AC mm 두께·종이 g 평량 동류 WGT 다의성).
5. **사이즈#13 단수/구조 프리셋 흡수 입증** — 계단 2단/3단(층수=구조 요소)이 사이즈 프리셋 1:1(2단=495×320) 인코딩 → *구조 distinct 부결의 결정적 증거*(형상#17과 달리 1:多 분리 없음).
6. **생산형태#15 + 가격#11(tmpl) 완제품 governing 재확인** — 봉제 구조물=C 완제품(tmpl_price)·내재 BOM 고정·옵션 미노출. GS 완제 굿즈 governing 패턴 합류.

## ═══ CL 통합 발굴 (v6.0 — 의류 variant·인쇄위치·인쇄방식·size×color 매트릭스) ═══

> `categories/CL/reverse.md` C-1~C-9 판정. **6 상품군(BN·GS·TP·PR·ST·CL) 증거.** ★**distinct 승급 0건 — 17축 재포화(PR 패턴 반복).** CL reverse가 강하게 제기한 "의류 variant=#18 후보"는 **facet 클러스터**로 강등(GS variant 축의 2D 일반화). 9 fragment 전부 기존 17축 facet/family/matrix/정책. 상세 판정 = `_resolved-fragments.md` CL 섹션.
> 도메인 정초 = `07_domain/{entity-semantic-model.md(본체색→자재 CLR·variant 분해·material usage·생산방식),pdf-domain-knowledge.md(별색=공정),db-domain-structure-live.md}` + GS reverse(variant 3채널 G-4·완제 본체 G-1) 직접 대조. **★domain-researcher 신규 호출 불요** — 의류 인쇄방식(전사/실크/나염/DTF=공정#2/인쇄방식#12)·size×color SKU(=사이즈#13×색상자재CLR Cartesian)·Pantone(=별색=공정#2·round-22 경계)이 후니 KB+기존 17축에 확정 존재(추정 0).
> **★CL 핵심 판정: 의류 variant = facet (distinct #18 거부).** "clothes2025 별도 분기 + apparel_info 전용 그릇 + size×color 2D 매트릭스 + Pantone 1124 + 인쇄위치 6 + 인쇄방식 3"이라는 의류 차원군 전체가 **기존 축으로 무손실 분해** — item_gbn=구현 discriminator(정책패턴·PR P-4 동형), apparel_info=구현 컨테이너 뷰(여러 기존 축을 담음·D-8 동형), size×color matrix=사이즈#13×색상(자재 CLR #1) Cartesian + 셀가용성=제약#5(ST S-8 disable 227 정점의 2D판). distinct를 강요하면 자재/사이즈/색/공정/제약을 "의류"라는 카테고리 라벨 아래 중복 재포장 = 오버피팅. **단 [HARD] G-1 동형 분해 요구: MTRL_COD를 {fabric/PTT, color/CLR, size/WGT}로 분해(평면 라벨 금지).**

| frag | 정체 | 1차 귀속 | 판정 | distinct/facet |
|---|---|---|---|---|
| **C-1** | apparel_info 전용 구조(6키) | 구현 컨테이너 뷰(여러 축 담음) | print_type→#12·area→#2·color→#1CLR·size→#13·size_color→#1matrix+#5·pantone→#2별색 | **facet(거부·D-8 동형)** |
| **C-2** | ★의류 variant #18 후보 | 자재#1+사이즈#13+색상#1CLR+제약#5 클러스터 | GS variant(G-4)의 2D 일반화·item_gbn=정책·apparel_info=컨테이너 | **facet(거부·#18 부결)** ★ |
| **C-3** | size×color → MTRL_COD 매트릭스 | 자재#1(SKU matrix facet)+사이즈#13×색상+제약#5 | 사이즈×색 Cartesian·셀 MTRL_COD=G-1 본체 SKU 동형·셀가용성=#5 | **facet(거부·HARD 분해)** ★ |
| **C-4** | 인쇄위치(print_area 6·다중) | 공정#2 멀티슬롯 + #11 + #16 KOI매핑 | 위치별 PDT_WRK 가산·GS 귀돌이 4슬롯/ROP 동형 | **facet(거부)** |
| **C-5** | 카테고리 내부 2모델(clothes2025/tmpl) | 생산형태#15 + item_gbn 정책 discriminator | 본체정체가 가격/옵션 패러다임 결정=생산형태·item_gbn=구현 | **facet(거부)** |
| **C-6** | 인쇄방식(실크/전사/DTF/나염) | 인쇄방식레시피#12 (PR P-4/ST S-5 합류) | 상품내 옵션 인코딩(ST/PR=상품분기)·#12 양면표현 | **facet(거부·#12 합류)** |
| **C-7** | Pantone 1124 별색 | 공정#2 별색 family + 기초코드#6 도메인 | 실크인쇄 spot color·별색=공정(round-22)·1124=#6 거버넌스 | **facet(거부)** |
| **C-8** | GBN(adult/child) | 사이즈#13 + 기초코드#6 하위속성 | 사이즈 enum의 연령 분류 속성·단체티만 child 활성 | **facet(거부)** |
| **C-9** | CLST 가방/모자/에이프런 모델 | 생산형태#15 + 카테고리#7(경계) | 비의류=tmpl 굿즈형·CL 카테고리 내 비의류=카테고리 경계 | **facet(거부)** |

### C-2 양면 트레이드오프 (침묵 선택 거부) ★최대 directive 의사결정

CL reverse가 "의류 variant = distinct #18"를 ① item_gbn=clothes2025 별도 분기 ② apparel_info 전용 그릇 ③ size×color 2D 매트릭스(GS 단일 DTL 초과) ④ Pantone 1124·인쇄위치 6·인쇄방식 3 의류 전용 차원군 네 근거로 강하게 제기. 적대 판정:

- **(가) distinct "의류 variant 축 #18" 신설:**
  - 찬성: 그릇(item_gbn=clothes2025)·차원(size×color·위치·방식·Pantone)이 GS variant(tmpl/vTmpl·3채널)와 *별도 분기*로 보임. apparel_info가 BN/GS/TP/PR/ST 전무한 전용 구조. reverse §15 #1~4가 "vessel-gap 정점·distinct 가설 강화" 제기.
  - 반대: ★네 근거 전부 *기존 축의 표현/구현*으로 무손실 분해 — distinct가 요구하는 "기존 축이 왜곡 없이 못 담는 고유 lifecycle/governing"이 **없음**.
    - **① item_gbn=clothes2025** = RedPrinting의 *구현 discriminator*(어느 가격 SP·어느 옵션 skin을 쓸지 선택하는 분기 키)이지 관리 축이 아님. PR "인쇄방식=pdtCode 분기"(P-4)·ST "인쇄방식=상품분기"(S-5)·GS "DIR_MTR vs ORD_INFO 본체 위치"(G-1)와 **정확히 동형인 정책/구현 패턴**(dictionary 명제 #19 "공정방식이 상품을 가른다=정책"). 메타모델 명제 #20(PR distinct 0)이 이미 "분기 discriminator는 축 아님"을 확정.
    - **② apparel_info 전용 그릇** = *구현 컨테이너 뷰*(skinInfo에서 paper/size/dosu를 view_yn=N으로 숨기고 6키로 재담음). 6키는 깔끔히 분해: print_type→#12·print_area→#2(+#16 KOI)·apparel_color→#1 CLR·size_info→#13·size_color_info→#1 SKU matrix+#5·pantone→#2 별색. **컨테이너는 축이 아니다** — D-8(UI 런타임=facet) 판정과 동근(같은 base-data를 다른 구조로 담을 뿐).
    - **③ size×color 2D 매트릭스** = 두 *기존 축*(사이즈#13 × 색상[자재 CLR·D-2 "본체색=자재 CLR"])의 **Cartesian product + 셀별 가용성**. 셀→MTRL_COD 해소는 G-1 "완제 본체 SKU=자재 facet"(PCS_DTL_NME 라벨 융합)의 의류판(2D). 227셀 HIDE_YN/QUICK_ORD_YN 셀가용성 = **제약#5의 2D 정점**(ST disable 227건=#5 정점·S-8과 동일 규모/패턴). 2D-ness는 *cardinality 속성*이지 새 관리 관심사 아님 — GS G-4가 variant 1D-per-channel을 facet 강등했듯 CL은 *2D matrix*이나 동일하게 기존 축으로 분해.
    - **④ Pantone/위치/방식** = 전부 기존 축: Pantone=별색 공정#2(C-7)·위치=공정#2 멀티슬롯(C-4·GS 귀돌이 4슬롯 동형)·방식=인쇄방식#12(C-6·PR/ST 합류).
- **(나) facet 클러스터 — GS variant(G-4) 축의 2D 일반화 + G-1 본체 SKU + #5 셀가용성 정점 [채택]:** 의류 variant = 자재#1(size×color SKU matrix·본체 fabric)·사이즈#13·색상(자재 CLR)·제약#5(셀가용성 227)·인쇄방식#12·공정#2(위치·별색)의 *결합*. GS variant와의 관계 = **CL은 GS variant 인코딩의 2D 일반화** — GS는 variant를 1D-per-channel(DTL/ATTB/CUT·G-4)로 해소, CL은 2D 매트릭스(size×color→단일 MTRL_COD)로 해소. 둘 다 같은 기존 축으로 분해되는 facet이며, CL이 더한 것은 *2D cardinality + 셀별 가용성 정점*(새 축 아님).

**판정: facet — distinct #18 거부.** 의류 variant는 GS variant 축의 facet(2D 일반화)이며, 어느 단일 축의 facet이 아니라 **자재#1 + 사이즈#13 + 색상(자재 CLR) + 제약#5 의 facet 클러스터**(주 귀속=자재#1 SKU matrix·G-1 동형). **★[HARD] G-1 동형 분해 요구:** MTRL_COD(SXSRT326="6.2oz 프리미엄 화이트 L")를 `{body_fabric/PTT, body_color/CLR, size/WGT}`로 분해(평면 SKU 라벨=의미축 drop). 이것이 후니 굿즈 본체소재 부재 결함(round-22 GPM)의 의류판 정답이며 GS G-1과 동일 처방. **역방향 오류 점검:** distinct를 facet으로 숨기는 오류 여부 — size×color 셀가용성 매트릭스가 유일한 잔여 후보였으나 ST S-8(disable 227=#5 정점)과 동일 패턴으로 제약#5에 무손실 흡수(2D subject). 기존 축이 *왜곡 없이* 담음 → facet 정당(숨김 아님).

### CL이 입증한 것 (축 신설 아닌 *강화* + 17축 재포화)

1. **★17축 재포화(PR 패턴 반복)** — 6번째 카테고리(의류)가 distinct 신축 0 도입. PR(4번째·distinct 0)이 입증한 포화를 ST(5번째·형상 1종)가 깼으나, CL(6번째)이 다시 distinct 0으로 **모델 안정성 재확인**. 의류처럼 "전용 그릇(apparel_info)·전용 모델(clothes2025)"을 가진 가장 이질적으로 보이는 카테고리조차 17축으로 무손실 흡수 = 강한 검증 신호.
2. **자재#1 size×color 2D SKU 매트릭스 facet** — GS variant 1D-per-channel(G-4)의 2D 일반화. 셀→단일 MTRL_COD(G-1 본체 SKU 라벨 융합 동형) + 셀별 가용성(#5 정점).
3. **제약#5 2D 셀가용성 정점** — 227셀 size×color HIDE_YN/QUICK_ORD_YN = ST disable 227(S-8)과 동일 규모, 단 2D subject(사이즈×색 axis-pair). 제약#5 룰엔진의 2D 일반화 검증.
4. **인쇄방식#12 "상품내 옵션" 인코딩 추가** — ST/PR(상품분기 pdtCode)와 달리 CL은 한 상품 안 ORD_INFO.PRINT_TYPE 차원(DTF/직접/실크 택1). #12가 (a)자재 facet(BN 수성/라텍스) (b)상품분기(ST/PR) (c)상품내 옵션(CL) 3표현을 가짐을 확정(양면→삼면 표현).
5. **공정#2 인쇄위치 멀티슬롯 facet** — print_area 6위치 다중선택·위치별 PDT_WRK 가산(#11)·KOI_NME→입력채널#16 에디터 매핑. GS 귀돌이 4슬롯·ROP 동형.
6. **카테고리#7 경계 명시** — CL 카테고리 안에 비의류(가방/모자/에이프런=tmpl 굿즈형) 포함 = 카테고리=기능 트리이나 생산형태#15(item_gbn)가 본체 그릇 결정. 카테고리⊥생산형태(#15·D-9) 재확인.

---

## ═══ AC 통합 발굴 (v7.0 — 두께·소재variant·입체/스탠드·가공방식 그룹핑·부착물) ★가공방식 그룹핑(A-8) 적대 판정·재포화 ═══

> `categories/AC/reverse.md` A-1~A-9 판정. **7 상품군(BN·GS·TP·PR·ST·CL·AC) 증거.** ★**distinct 승급 0건 — 17축 재포화(PR 4번째·CL 6번째 패턴 반복).** AC reverse가 강하게 제기한 "가공방식 그룹핑 슬롯(A-8)=distinct #18 강후보"는 **facet 클러스터**로 강등(공정#2 라미 + 자재#1 합성 + 옵션#3 cascade). 9 fragment 전부 기존 17축 facet/family/cascade/정책. 상세 판정 = `_resolved-fragments.md` AC 섹션.
> 도메인 정초 = `07_domain/{entity-semantic-model.md(두께=자재 식별자·variant 분해·합지/별색=공정),pdf-domain-knowledge.md(완칼/도무송·합지),db-domain-structure-live.md}` + **[huni-ref] `31_acrylic-price-link/{acrylic-chain-design,confirms-and-gaps}.md`**(후니 아크릴 두께/소재/가격 모델 직접 대조·동형 확정). **★domain-researcher 신규 호출 불요** — 두께(아크릴 mm=자재 식별자)·라미네이션(=공정#2 합지)·표면효과(글리터/거울=자재 surface-finish·ST S-4 동형)·코롯토 입체(자립 블록=자재 두께)가 후니 KB+[huni-ref]+기존 17축에 확정 존재(추정 0).
> **★AC 핵심 판정 4 관전: 두께=자재#1 WGT facet · 소재variant=자재#1 surface-finish facet · 입체/스탠드=분산 facet(부속물#8+자재#1+옵션#3+공정#2) · 가공방식 그룹핑=공정#2(라미)+자재#1 합성+옵션#3 cascade facet(#18 부결).**

| frag | 정체 | 1차 귀속 | 판정 | distinct/facet |
|---|---|---|---|---|
| **A-1** | 두께(3T/5T/8T·WGT_CD 슬롯) | 자재#1 WGT 차원 | WGT 슬롯 다의성(평량/두께)·[huni-ref] mat_cd 통합 동형·두께=자재 식별자 | **facet(거부)** ★관전1 |
| **A-2** | 소재 variant(글리터/거울/자개/홀로그램/렌티큘러/파스텔/유색) | 자재#1 surface-finish 합성 | ST S-4 점착/내후 동형·거울 별공식=#11 라우팅(자재 분류 아님) | **facet(거부)** ★관전3 |
| **A-3** | 입체/스탠드(3D) | 분산: 부속물#8+자재#1+옵션#3+공정#2 | 받침=부속물(본체 생성 아님=#14 아님·평면본체 유지=#15 아님)·코롯토=자재 두께·양면=인쇄면 | **분산 facet(거부)** ★관전2 |
| **A-4** | 부착물(고리/받침/자석/핀 SUB_MTR/WRK_MTR) | 부속물#8 + 공정#2 부착 bundle | KR/CN/CR ST 공유=단일 부자재 마스터·받침=#8·D-1/D-2 동형 | **facet(거부)** |
| **A-5** | 인쇄면(print_data) + 화이트 | 옵션#3 + 공정#2(화이트) + 제약#5(투명종속) | ST S-7 동형·별색=공정·"양면" 3축(도수/인쇄면/코롯토) 분산 | **facet(거부)** |
| **A-6** | 3 가격엔진(vTmpl/acrylic2025/tmpl) | 가격#11 pricing_model 라우팅 | ST S-6·GS G-7·PR P-6 합류·acrylic2025 추가([huni-ref] PRF_CLR_ACRYL 정합) | **facet(거부)** |
| **A-7** | 상품명 소재≠본체 자재(명찰 PET+합지) | 자재#1(PET) + 공정#2(합지) | G-1·CL C-2 라벨 융합 동형·합지=공정 | **facet(거부)** |
| **A-8** | ★가공방식 그룹핑(production_method 일반/라미·GRP_OPTION_CD) | 공정#2(라미)+자재#1 합성+옵션#3 cascade | GRP_OPTION_CD=옵션 cascade·라미=공정·합성=자재·형상#17과 정반대(축 충분) | **facet(거부·#18 부결)** ★강후보 |
| **A-9** | ACTPKEY 키링 템플릿 | 디자인입력채널#16 TemplateAsset + 카테고리#7 | T-A 이중의미 분리 동형·#4 완제SKU 아님 | **facet(거부)** |

### A-8 양면 트레이드오프 (침묵 선택 거부) ★directive 신규 강후보 의사결정

AC reverse가 "가공방식 그룹핑 슬롯(GRP_OPTION_CD/production_method)=distinct #18 강후보"를 ① 자재행을 가공방식 그룹(MTG_DFT 일반/MTG_LAM 라미)으로 묶는 *전용 명시 슬롯* ② `option_info.production_method` 전용 인코딩 ③ 라미가 두께 합성(3T→2T+1T)+홀로그램 부여라는 *능동 변환*(단순 옵션 초과) 세 근거로 강하게 제기. 적대 판정:

- **(가) distinct "가공방식 그룹핑 슬롯 #18" 신설:**
  - 찬성: GRP_OPTION_CD가 자재를 가공방식으로 *그룹핑*하는 명시 메커니즘·ST 형상(#17)처럼 "전용 슬롯=distinct 신호"·라미=능동 변환(두께/표면 합성).
  - 반대: ★세 근거 전부 기존 축의 *표현/구현*으로 무손실 분해 — distinct가 요구하는 "기존 축이 왜곡 없이 못 담는 고유 lifecycle/governing"이 **없음**.
    - **① 라미네이션 자체** = 공정#2 멤버(라미=합지 후가공·BON_PAP/합지 family·deterministic 공정). 후니 KB가 합지/UV를 이미 공정 멤버로 수용.
    - **② 라미 결과(라미된 자재행 PXAATL01~04)** = 자재#1 *합성*(D-2 "MTRL_CD 다축 합성·두께/표면 분해")·두께 합성=WGT 차원(A-1)·홀로그램=surface-finish(A-2). 라미는 *합성 자재행을 만드는 공정*이고 그 결과는 자재행.
    - **③ GRP_OPTION_CD 그룹핑** = 옵션#3 polymorphic cascade(production_method 선택→호환 MTRL_CD subset 게이팅)·G-4 "한 DTL/옵션코드가 자재 subset 결정" 동형·CL size×color 매트릭스가 자재 SKU 게이팅과 동근(제약#5 match). "자재를 가공방식으로 그룹핑하는 슬롯"=옵션#3이 자재#1 subset을 게이팅하는 *관계 간선*이지 별 관리 축 아님.
- **(나) 공정#2(라미) + 자재#1 합성(라미 결과) + 옵션#3 cascade(가공방식→자재 subset) facet 클러스터 [채택]:** 세 기존 축의 결합. AC가 더한 것=가공방식이 공정(라미)·자재(합성결과)·옵션(cascade) 셋에 걸친 bundle(GS 제본·PR 면지·TP 쫄대 bundle 동류)이지 새 *축* 아님.

**★ST 형상(#17)과의 결정적 차이 — 왜 형상은 승격·가공방식은 부결(역방향 오류 점검):** 형상(#17)은 *사이즈축(#13)이 형상을 1:1 칼틀로 흡수해온 전제가 ST 1:多로 깨져* 기존 축이 *왜곡 없이 못 담음*(후니 KB G-SK-2 "형상 어느 축에도 없음" 결함 확증)이 distinct 강제 근거였다. 가공방식은 **정반대** — 기존 축이 *왜곡 없이 담음*: 라미=공정#2(이미 합지 멤버)·합성결과=자재#1(이미 합성 규칙 D-2)·그룹핑=옵션#3 cascade(이미 G-4 채널). 후니 KB에 "가공방식 어느 축에도 없음" 같은 결함 명시 **없음**(라미네이션=공정 멤버로 이미 수용). → 형상=축 부재(distinct)·가공방식=축 충분(facet). 역방향 오류(distinct를 facet으로 숨김) 점검: GRP_OPTION_CD 그룹핑 슬롯이 유일 잔여 후보였으나 옵션#3 polymorphic 게이팅(G-4/CL 매트릭스 동형)으로 무손실 흡수 → facet 정당(숨김 아님·새 관리 관심사 없음).

### AC가 입증한 것 (축 신설 아닌 *강화* + 17축 재포화)

1. **★17축 재포화(PR·CL 패턴 반복)** — 7번째 카테고리(아크릴)가 distinct 신축 0 도입. PR(4번째·distinct 0)→ST(5번째·형상 1종)→CL(6번째·distinct 0)→**AC(7번째·distinct 0)** = 모델 안정성 재확인. 가장 강한 새 후보(A-8 가공방식 그룹핑)조차 세 기존 축으로 무손실 흡수 = 강한 검증 신호.
2. **자재#1 surface-finish 합성 차원 facet** — 글리터/거울/자개/홀로그램/렌티큘러/파스텔이 ST S-4 점착/내후(adhesion/weather)와 합류한 자재 합성 분해축(`surface_finish`). 거울 별 가격공식(PRF_MIRROR)은 #11 라우팅(자재 분류 아님).
3. **자재#1 WGT 슬롯 다의성 명시** — WGT 슬롯이 평량(종이 g)·두께(아크릴 mm) 다의 사용·[huni-ref]가 두께를 mat_cd 차원으로 통합(1.5T=3T×0.8) 동형 입증. 자재 합성코드 WGT 차원의 정당한 다형성.
4. **부속물#8 횡단 확장** — 등신대 받침(AB 12 SKU·형상×크기·ESN=Y)이 BN 거치대(D-1)·우드봉·이젤 동형 부속물·고리(KR/CN/CR)가 ST SUB_MTR 코드 공유 = **단일 부자재 마스터 시사**(후니 부자재 카탈로그 단일화·갭분석가 주목).
5. **옵션#3 가공방식 cascade** — production_method(일반/라미)→호환 자재 subset 게이팅이 G-4 variant 채널·CL size×color 매트릭스 자재 게이팅과 합류한 polymorphic cascade.
6. **가격#11 pricing_model acrylic2025 라우팅** — 아크릴 전용 면적·두께·소재 산정엔진([huni-ref] PRF_CLR_ACRYL/MIRROR/COROTTO/CARABINER 소재·형태별 공식)이 ST 3엔진·GS G-7·PR P-6와 같은 "2025세대 전용 가격엔진" 패턴.

---

## 갭 — 추가 샘플 필요(과잉 일반화 방지)

1. **카테고리 트리/다중분류:** BN·GS 둘 다 옵션 트리 라이브 추출 불가(신규 Vue) → 한 상품 여러 트리 소속·트리 깊이 미관측. **책자(booklet)·문구(stationery) reuse 캡처 권고.**
2. **템플릿(완제 SKU) 계층:** GS DIR_MTR로 완제 본체는 확인했으나 *번들 구성(template_selections)*은 미관측(봉투결합 엽서·OTC). 완제 SKU + 부속물 묶음 샘플 필요.
3. **vTmpl vs tmpl 가격모델 분기 조건:** GSPDLNG만 vTmpl 단일 샘플 → variant 유무가 가격모델을 어떻게 가르는지 확정 불가. variant 상품 추가 캡처 권고.
4. **생산형태 enum 완전성:** 기성·디자인 형태(D-9)는 도메인 권위로만 확정, RP 직접 관측은 완제품(C)·통합(A)·셋트(B) 위주. 디자인/기성 굿즈 캡처로 보강.
5. **(PR) 인쇄방식별 자재풀·옵션 차이:** 토너(PRBKO*)·인디고(PRIDPRT)·리소(PRPORSO) 책자가 윤전(PRBKYPR)과 내지 자재풀(YWM 미사용 추정)·최소수량·페이지범위·가격모델 어떻게 다른지 unobserved(catalog 상품명만). 로그인 캡처로 P-7 자재풀 게이팅 확정.
6. **(PR) 리플렛 접지 강제여부·면수 cascade:** 리플렛(PRLFXXX) 신규 Vue SSR-negative — 접지 7종은 포스터 실측이나 리플렛의 접지필수/접지방식↔면수↔오시 cascade는 unobserved. P-1 cascade 확정에 필요.
7. **(PR) INN_PAGE↔가격 결합·스코딕스/박 후가공 상세:** 책자 페이지 선형가산은 실측(Δ1,120/page), 캘린더 INN_PAGE↔tiered_price 결합(TP T-7)은 unobserved. 스코딕스 패턴·박색(FOI)·레이저커팅 칼틀값 상품명만(P-9).
