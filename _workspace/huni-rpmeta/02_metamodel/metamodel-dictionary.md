# RedPrinting 옵션 관리 메타모델 사전 (metamodel-dictionary)

> rpm-metamodel-architect. RedPrinting 역공학(`01_reverse/`)에서 추상화한 **옵션 관리 메타모델**.
> **인스턴스 아님 — 패턴이다**(SKILL §"instance vs metamodel"). "현수막=타포린"은 인스턴스, "자재는 usage 역할과 합성 규칙을 가진다"가 메타모델.
> 인쇄 도메인 정초 = `07_domain/{entity-semantic-model(L3 9속성·C-9 생산방식),process-recipe-tree(L2 레시피)}`. **도메인 사실 준수: 별색=공정, 본체색=자재 CLR, 판걸이수=앱계산(DB 미저장).**
> RedPrinting은 검증된 참조 — 모델을 *있는 그대로* 포착(개선/후니 갭은 갭분석가 영역).
>
> **── 버전 ──**
> - **v1.0 (BN 파일럿):** 현수막류(BN) 6상품. 13축(7 정적 + 4 관계/동역학 + 2 횡단).
> - **v2.0 (GS 통합):** + 굿즈/잡화(GS) 12상품. BN(평면 배너)·GS(완제/입체 굿즈) **2 상품군 증거**. GS 신축 2종 distinct(D-9 생산형태·D-10 본체 형태가공). 총 **15축**.
> - **v3.0 (TP 통합):** + 디자인템플릿(TP) 대표3+20횡단. BN(면적)·GS(완제/입체)·TP(디자인입력) **3 상품군 증거**로 검증. TP 신축 1종 distinct 추가(D-11 디자인 입력 채널 #16), 템플릿#4 이중의미 분리(완제SKU vs 에디터 디자인 자산). 총 **16축**.
> - **v4.0 (PR 통합):** + 인쇄물·책자·리플렛·포스터(PR) 대표3+53횡단. BN(면적 단면)·GS(완제/입체)·TP(디자인입력)·PR(다면/제본/접지) **4 상품군 증거**로 검증. **★PR distinct 신축 0종 — 9 fragment(P-1~P-9) 전부 기존 16축 facet/family/cascade/정책으로 흡수 = 16축 포화(saturation) 입증.** 총 **16축 유지**. PR은 새 *축*이 아니라 기존 축 *강화*: 공정#2 접지 family · 자재#1 usage_cd 역할 전파 · page_rule 엔티티(#10) · 인쇄방식#12 자재풀 게이팅 · 가격#11 digital_price 라우팅.
> - **★v5.0 (ST 통합):** + 스티커(ST) 대표3+33횡단. BN·GS·TP·PR·ST **5 상품군 증거**로 검증. **★ST distinct 신축 1종(#17 형상) = 16축 포화 붕괴.** 4 distinct 후보 적대 판정: **형상=distinct(#17)·칼선=공정#2 facet·재단입자=공정#2 facet·점착=자재#1 facet.** 형상(shape)이 사이즈축(#13)을 *1:1 칼틀로 흡수*해온 전제를 깸 — ST `option_info.shape_info` 전용 슬롯·형상↔사이즈 1:多(CL→CL001~100)·5형상 superset·후니 KB G-SK-2 "형상 어느 축에도 없음" 확증. 나머지 9 fragment(S-2~S-10)는 facet(칼선/재단=공정#2 family·KB PROC_053/054/055 결정적·점착=자재 합성·인쇄방식=#12 PR합류·disable 227=#5 정점). 총 **17축**. PR 포화 입증(distinct 0)도 유효 — PR은 형상 1:1로 흡수 정당, ST가 1:多 분리를 명시 슬롯으로 드러내 차이.
> - **★v7.0 (AC 통합·현재):** + 아크릴·키링·코롯토·명찰·등신대(AC) 대표3+17횡단. BN·GS·TP·PR·ST·CL·AC **7 상품군 증거**로 검증. **★AC distinct 신축 0종 — 17축 재포화(PR·CL 패턴 반복·신규 강후보 A-8 부결).** AC reverse가 "가공방식 그룹핑 슬롯(GRP_OPTION_CD/production_method)=distinct #18 강후보"를 강하게 제기했으나 **9 fragment(A-1~A-9) 전부 기존 17축 facet/family/cascade/정책으로 무손실 흡수.** ★directive 4 관전 적대 판정: **① 두께(3T/5T/8T)=자재#1 WGT facet**(WGT 슬롯 다의성 평량/두께·[huni-ref] 후니가 투명3T/1.5T를 mat_cd 차원 통합 1.5T=3T×0.8 동형) **② 소재variant(글리터/거울/자개/홀로그램/렌티큘러/파스텔/유색)=자재#1 surface-finish 합성 facet**(ST S-4 점착/내후 동형·거울 별공식=#11 라우팅 not 자재분류) **③ 입체/스탠드=분산 facet**(받침=부속물#8 평면본체 유지=생산형태#15 아님·본체생성 아님=형태가공#14 아님·코롯토 두께블록=자재#1·양면=옵션#3·입체조형=공정#2) **④ ★가공방식 그룹핑(일반/라미)=공정#2(라미)+자재#1 합성(라미 결과)+옵션#3 cascade(가공방식→자재 subset 게이팅) facet·#18 부결.** ★A-8이 ST 형상(#17)과 정반대로 부결된 결정적 근거 = **형상은 후니 KB G-SK-2 "형상 어느 축에도 없음" 결함이 distinct 강제, 가공방식은 기존 축이 왜곡 없이 담음**(라미=공정 멤버 이미 수용·KB 결함 없음). 나머지 A-4(부착물=부속물#8+공정#2 부착·고리 KR/CN/CR ST 공유=단일 부자재 마스터)·A-5(인쇄면+화이트=옵션#3+공정#2+제약#5·ST S-7)·A-6(3 가격엔진=가격#11 acrylic2025 라우팅)·A-7(명찰 PET+합지=자재#1+공정#2·G-1/CL 라벨 융합)·A-9(ACTPKEY=#16 TemplateAsset·T-A 이중의미). 총 **17축 유지**. 7번째 카테고리(아크릴 두께/입체/가공방식)가 distinct 0 = 가장 강한 새 후보 A-8조차 무손실 흡수.
> - **v6.0 (CL 통합):** + 의류·티셔츠·앞치마·가방류(CL) 대표3+27횡단. BN·GS·TP·PR·ST·CL **6 상품군 증거**로 검증. **★CL distinct 신축 0종 — 17축 재포화(PR 패턴 반복).** CL reverse가 "의류 variant=distinct #18"를 강하게 제기(item_gbn=clothes2025 별 분기·apparel_info 전용 그릇·size×color 2D 매트릭스·Pantone 1124·인쇄위치 6·인쇄방식 3)했으나 **9 fragment(C-1~C-9) 전부 기존 17축 facet/matrix/family/정책으로 무손실 흡수.** ★의류 variant=#18 부결: ① item_gbn=구현 discriminator(PR P-4·ST S-5·GS G-1 정책패턴 동형·축 아님) ② apparel_info=구현 컨테이너 뷰(여러 축 담음·D-8 동형) ③ size×color matrix=사이즈#13×색상(자재 CLR #1) Cartesian + 셀가용성=제약#5(ST disable 227=S-8 정점의 2D판) ④ Pantone=별색 공정#2(round-22 경계). **의류 variant = GS variant 축(G-4)의 2D 일반화 facet 클러스터**(자재#1 SKU matrix·사이즈#13·색상자재CLR·제약#5)·주 귀속=자재#1(G-1 본체 SKU 동형·★[HARD] {fabric/PTT,color/CLR,size/WGT} 분해). 총 **17축 유지**. ST(5번째·형상 1종)가 PR 포화를 깼으나 CL(6번째·distinct 0)이 **모델 안정성 재확인** — 의류처럼 전용 그릇·전용 모델 가진 가장 이질적 카테고리조차 17축 무손실 흡수.
>
> 축 총 **17개 = 7 정적 축(자재·공정·옵션·템플릿·제약·기초코드·카테고리) + 4 관계/동역학 축(부속물·공정파라미터·수량모델·제약논리) + 2 횡단 축(가격기여역할·인쇄방식레시피) + GS 신축 2(생산형태·본체 형태가공) + TP 신축 1(디자인 입력 채널) + ST 신축 1(형상 #17)**. 발굴 근거=`discovered-axes.md`. **PR distinct 0(4군 포화)→ST distinct 1(형상·5군 포화 붕괴)→CL distinct 0(6군 재포화)→AC distinct 0(7군 재포화·신규 강후보 A-8 가공방식 그룹핑 무손실 흡수)=모델은 카테고리 증거에 정직(포화·진화·재포화 전부 증거 강제).**
>
> **GS 통합 원칙(과잉 일반화 경계, SKILL §5):** 2 상품군(BN 평면·GS 완제/입체)을 *둘 다* 견디는 패턴만 메타모델 축으로 승격. 한 군만의 특이(폰케이스 기종 enum 규모·코스터 6 pdtCode 분리)는 facet으로 강등(distinct 거부). BN 본체=`ORD_INFO.MTRL_CD`(자재) vs GS 본체=`DIR_MTR/WRK_MTR`(PCS 항목)는 **같은 자재축의 두 표현 facet**(아래 #1·#4 명시).
>
> **TP 통합 원칙(v3.0):** 3 상품군(BN·GS·TP)을 *셋 다* 견디는 패턴만 승격. TP 발굴 6종 중 **D-11 디자인 입력 채널만 distinct**(비-TP 트윈 직접 대조 + huni-widget RedEditorSDK 계약 권위). 나머지 5종(템플릿 자산·VDP·페이지계층·형태variant·특수인쇄)은 facet 강등. **★템플릿 이중의미 [HARD]:** 메타모델 #4 "템플릿/SKU"는 *완제 주문 단위*(봉투결합 엽서·OTC·후니 `t_prd_templates`), TP "템플릿 자산"은 *에디터 디자인 시안*(가격0·D-11#16 종속) — **같은 단어 다른 의미·별 엔티티 분리**(아래 #4·#16 명시).
>
> **PR 통합 원칙(v4.0):** 4 상품군(BN·GS·TP·PR)을 *넷 다* 견디는 패턴만 승격. **PR 발굴 9종(P-1~P-9) distinct 승격 0** — 전부 기존 축 facet/family/cascade/정책. 이는 *오버피팅 회피의 정직한 결과이자 16축 포화 입증*(4번째 카테고리=새 축 0). PR이 더한 강화: **(P-1) 공정#2 "접지(folding)" family + 접지↔오시 cascade**(평면 종이 면가공·면수=파생값 축 아님) · **(P-2) 자재#1 usage_cd "역할 전파"**(★침묵선택 거부: 표지/내지 role이 자재→도수→가격→평량 전파되나 별 "역할 축" 아닌 usage_cd 전파·`inner_pdt_*`=usage 슬롯 물리구현) · **(P-3) page_rule 엔티티**(INN_PAGE=수량#10 슬롯+후니 `_page_rules`·TP T-C 합류) · **(P-4) 공정방식=상품분기 정책**(GS G-2·TP T-4 동류·인쇄방식#12·공정#2·도수#6 분배) · **(P-5) 면지=자재+공정 bundle**(D-2) · **(P-6) 가격#11 digital_price 라우팅**(pricing_model 5종) · **(P-7) 인쇄방식#12 자재풀 게이팅 간선** · **(P-8) 용도=카테고리#7 태그** · **(P-9) 공정#2 멤버**(스코딕스 입체UV·레이저커팅·합지). 도메인 정초=`entity-semantic-model.md`(usage_cd 7종·page_rule 엔티티)+reverse 실측, domain-researcher 신규호출 불요.
>
> **★CL 통합 원칙(v6.0·재포화):** 6 상품군(BN·GS·TP·PR·ST·CL)을 *여섯 다* 견디는 패턴만 승격. CL 발굴 9 fragment(C-1~C-9) **distinct 승급 0** — ★최대 directive 질문 "의류 variant=#18"를 적대 판정 후 **facet 부결.** 의류가 가장 distinct로 *보이는* 이유(전용 `clothes2025` 모델·전용 `apparel_info` 그릇·size×color 2D 매트릭스)가 전부 *구현 표현*이지 *관리 축*이 아님 — item_gbn=discriminator(정책패턴·축 아님)·apparel_info=컨테이너(여러 축 담는 뷰)·size×color=두 기존 축(사이즈#13×색상자재CLR)의 Cartesian + 셀가용성(제약#5 2D 정점). **★[HARD] 의류 variant↔GS variant 관계:** CL은 GS variant 인코딩(G-4 DTL/ATTB/CUT 1D-per-channel)의 **2D 일반화**(size×color→단일 MTRL_COD) — 둘 다 같은 기존 축으로 분해되는 facet, CL이 더한 것은 2D cardinality + 셀가용성 정점(새 축 아님). MTRL_COD는 G-1 본체 SKU와 동형(라벨 융합)이므로 동일 [HARD] 분해 처방(`{body_fabric/PTT, body_color/CLR, size/WGT}`). 인쇄방식(실크/전사/DTF/나염)=#12(상품내 옵션 인코딩 추가·ST/PR 상품분기와 삼면 표현)·인쇄위치(print_area 6)=공정#2 멀티슬롯(GS 귀돌이 4슬롯 동형)·Pantone 1124=별색 공정#2(round-22 경계)·GBN(adult/child)=사이즈#13/기초코드#6 하위속성.
>
> **★ST 통합 원칙(v5.0·포화 붕괴):** 5 상품군(BN·GS·TP·PR·ST)을 *다섯 다* 견디는 패턴만 승격. ST 발굴 4 distinct 후보 중 **D-12 형상(#17)만 distinct** — 사이즈축(#13)이 형상을 *1:1 칼틀로 흡수*해온 전제(BN 어깨띠·GS THO_CUT·TP 티켓·PR 카드형 전부 1:1)가 ST에서 *1:多로 깨짐*(전용 `shape_info` 슬롯·CL 형상↔CL001~100 칼틀 span·STDCFBR 5형상 superset). **★[HARD] 형상축 적용 경계:** 형상이 사이즈와 1:1이면 사이즈 프리셋에 흡수 표현(BN/GS/TP/PR 유지·형상축 강제 금지=오모델 회피)·1:多 분리가 명시 슬롯으로 드러나면 별 분류축(#17). 나머지 9종(칼선·재단입자·점착·인쇄방식·가격엔진·화이트강제·disable·넘버링·완제SKU)은 facet — **칼선(THO_GRA/THO_DFT)·재단입자(반칼/완칼)는 공정#2 family**(후니 KB 결정적: 반칼=PROC_000054·완칼=PROC_000053·스티커완칼=PROC_000055·도무송=칼선 자유모형 컷팅 전부 공정 멤버), **점착/내후는 자재#1 합성 차원**(색상→material·두께→material 동형), **인쇄방식(UV/DTF/후지)은 #12 PR 윤전/토너/인디고 합류**, **disable 227건은 #5 정점**.
>
> 각 축 포맷: **identity**(관리 대상) · **entities(그릇 shape)**(추상 레코드, 후니 비종속) · **attributes** · **relationships**(FK/polymorphic/composition) · **constraint & cascade**.
> 확정도: ✅양군+도메인 권위 · 🟡부분+도메인 추론 · 🔴미관측(도메인 KB로 보강).

---

## I. 정적 축 (무엇을 등록하나)

### 1. 자재 축 (Material) ✅ — D-2 심화

- **identity:** 인쇄 본체를 구성하는 substrate/소재와 그 *합성 규칙*. (단순 enum이 아니라 다축 합성 + usage 슬롯 + 공정결합 메타규칙.)
- **entities(그릇):**
  - `Material` — 합성 자재 레코드.
  - `MaterialAxis` — 합성 분해축(TYPE/PTT/CLR/WGT/인쇄방식)의 코드 도메인.
- **attributes(Material):**
  - `mtrl_cd`(합성 PK, RP=MTRL_CD) — *분해 가능*해야 함.
  - `mtrl_type`(P 등 대분류), `ptt_cd`(소재/판형 — BFC현수막·MAS매쉬·TFC텐트천·VGP부직포), `clr_cd`(본체색 — X기본), `wgt_cd`(무게/두께), `print_method_enc`(수성C/라텍스L — 자재코드 인코딩, D-7).
  - `usage_cd`(슬롯 역할 — .01내지/.02표지/.03면지/.07공통, BN=substrate 단일 → **★GS 확인 ✅: usage 다중슬롯 실관측**). GS 스프링노트(GSNTSPR): `MTRL_CD=RIBVW350`(표지) + `INN_DFT`(내지=무지노트) + `RIN_DFT`(트윈링=금속부자재) 동시. GSTGMIC: `MTRL_CD=RXBVW300`(인쇄지) + `WRK_MTR`(스펀지). 즉 **한 주문에 자재가 여러 usage 슬롯**(표지/내지/링/스펀지)으로 분산 — entity-semantic §2 usage_cd 7종과 동형, BN 단일 substrate 한계 해소. 후니 "옵션=자재+공정 BUNDLE"(메모리 `dbmap-option-material-process-bundle`)의 RP 증거.
  - `sub_mtrl_yn`(부자재 여부 — 공정이 소비하는 자재인가).
  - `price_flag`(면적단가 분기키 — D-6).
- **relationships:**
  - Material → Product(belongs-to, 본체 구성).
  - Material.clr_cd → 본체색 variant(색상=자재 분기, *별색 아님*).
  - Process(sub_mtrl_yn=Y) → Material(**consumes**, FK — 아일렛=금속링, A-6).
  - Material → Process(**force**, 제약 — PET→코팅필수, D-3).
  - Material → Process(**disable**, 제약 — `pdt_disable_pcs_info`, D-3).
- **constraint & cascade:**
  - 합성코드 분해 규칙(평면 문자열 금지 — CLR/PTT/WGT/방식 분리 표현). entity-semantic §1-1 "자재축에 공정 섞임" 결함 회피.
  - 자재 선택 → 후가공 disable 룩업(BN 0건, 책자 24건).
  - **도메인 경계(HARD):** 별색≠자재(별색=공정 PROC_000007), 형상≠자재(형상→사이즈/카테고리/완칼, A-3), 두께=자재 식별자(아크릴 mm).

- **★GS 확장 — 완제 본체의 두 표현 facet (v2.0):**
  - **본체 표현이 상품군에 따라 두 가지:** (a) **BN형 = `ORD_INFO.MTRL_CD`** — 본체가 substrate 자재 1행(현수막=타포린). (b) **GS형 = `DIR_MTR`(부자재직접인쇄)/`WRK_MTR`(부자재작업) PCS 항목** — 완제 굿즈 본체(텀블러·실리콘끈·장패드·스펀지)가 PCS_INFO 첫 항목으로 들어가고 그게 result PRICE 주체(텀블러 45000·장패드 10000·마스크끈 2800). **두 표현은 같은 자재축의 facet**(둘 다 "본체 소재를 가리키는 자재 참조") — distinct 신축 아님. GS형에서 본체는 *완제 SKU 라벨*(PCS_DTL_NME="미르 와이드마우스 보틀 화이트 20oz")로 등장(템플릿 #4와 결합).
  - **본체 소재 = pdtCode 분리 패턴:** 같은 기능(코스터)이 본체 소재(규조토/펠트/코르크/종이/아크릴/레더)별로 **6개 별도 pdtCode**(GSTTDTM/GSPLCST/GSTTCRK/GSTTPAP/GSTTACR/GSTTREZ). RedPrinting은 소재를 *옵션이 아닌 상품정체*로 분리(소재≠variant, 소재=pdtCode). **도메인 정합:** entity-semantic §2 "색상 variant→material 자재 분기"·§4 "C 완제품: 굿즈"는 소재를 자재축으로 본다 → 코스터 6 pdtCode는 **자재축 + 카테고리(코스터=공통 기능 그룹) 복합의 RP 표현 선택**(아래 G-2 양면 트레이드오프). 한 군만의 카탈로그 정책이므로 facet(자재축에 흡수).
  - **★자재 오염의 RedPrinting판 (후니 갭 정합):** PCS_DTL_NME에 소재·색·용량·두께·브랜드가 융합("미르 와이드마우스 보틀 화이트 20oz") — 후니 "굿즈 본체소재 컬럼 부재·소재가 상품명에만"(메모리 `dbmap-axis-staged-load-round22` GPM 진단)과 **정확히 동형**. 즉 RP도 완제 본체에서 합성코드 분해(#1 (a))를 *못 하고* 라벨 융합으로 둠 → 메타모델 정답 = 완제 본체도 `{body_material, body_color, capacity, thickness, brand}` 분해축을 가져야 함(평면 라벨 금지).
  - **두께=자재 (GS 정합):** 장패드 "4T"(두께)가 DTL_NME 융합 — round-22 경계규칙 "두께=자재" 동형. 분해 시 wgt_cd로.

- **★PR 확장 — usage_cd 역할 전파(role propagation) (v4.0·P-2):**
  - **표지/내지 = usage_cd 슬롯 두 인스턴스(별 축 아님):** 책자(PRBKYPR)는 자재 스키마가 *표지용 `pdt_mtrl_info`(usage.02) + 내지용 `inner_pdt_mtrl_info`(usage.01)*로 평행 이원화. RedPrinting `inner_pdt_*` 평행 스키마 = **usage_cd 슬롯의 물리 구현**(BN substrate 단일·GS 다중슬롯 태그에서 PR이 *별 평행 스키마*로 격상). 후니 도메인 권위(`entity-semantic-model.md:23` USAGE 7종·.01내지/.02표지/.03면지/.07공통)가 이미 슬롯으로 모델링 → distinct 신축 거부(usage_cd 차원의 값).
  - **★role이 자재 너머로 *전파*된다:** PR이 입증한 핵심 = usage_cd가 자재뿐 아니라 **도수(`pdt_dosu_info` vs `inner_pdt_dosu_info`·CVR_CLR_CNT/INN_CLR_CNT, #6)·가격(F_CVR_MTRL_AMT vs K_INN_MTRL_AMT, #11)·평량제약(COV_MIN_WGT=150 vs INN_MAX_WGT=130, #5/#13)** 으로 전파됨. 즉 usage_cd = "태그"가 아니라 *자재→도수→가격→평량을 role-paired로 흐르게 하는 간선*. **★침묵선택 거부:** 별 "역할(role) 차원" 축 신설(pricing-role#11처럼 횡단 전파)을 검토했으나 거부 — role=usage_cd 값(신축 시 1:1 중복), 도수/가격 role-paired=usage_cd 전파(별 축 아님). 메타모델 정답 = usage_cd 슬롯이 #6/#11/#13으로 전파됨을 명시(역할 전파 격상).
  - **면지(END_PAP) = usage.03 면지 + 삽입 공정 bundle(P-5):** 면지 10색 "선택 컬러 양면인쇄 면지 삽입" = 컬러지(자재·usage_cd .03면지) + 삽입(공정#2) bundle — D-2 자재공정 bundle(아일렛·GS 링·TP STA_CLD 쫄대) 동형.

- **★ST 확장 — 점착/내후 합성 차원(adhesion/weatherability) (v5.0·S-4):**
  - **점착·내후성 = 자재 합성의 또 다른 차원(별 축 아님):** 스티커 자재(`pdt_mtrl_info` 19~26종)가 지종(PTT)×평량(WGT)×색(CLR) 외에 **점착강도·내후성**으로도 분기 — 일반/초강접(RPATA090)·리무버블(유포/PET 재부착)·옥외 유포(방수)·저온(냉장/냉동)·자석(자성시트)·메탈(금/은/동라벨지)·한지(인견). STTHUSR 26소재 enum에 이 spectrum이 *한 상품 안에 공존*(self-contained variant)이며 동시에 점착특화 상품(STRMDFT 리무버블·STOTDFT 옥외·STMADFT 자석·STLTDFT 저온)으로도 분리.
  - **★distinct 거부 근거:** 점착/내후는 *새 관리 대상이 아니라 자재 합성코드의 추가 분해축*. `entity-semantic-model.md:51-53` "색상 variant→material·두께 variant→material(별도 mat_cd)" 원칙과 동형 — 점착강도/내후등급도 **material 합성축(adhesion_grade·weather_grade)**으로 분해(별 자재계열 신설 금지). 자석=자성시트(소재)·메탈=금속라벨지(소재)는 PTT 슬롯, 점착성은 별 합성 차원 컬럼. RP가 점착특화 상품(STRMDFT)으로 *분리*한 것은 GS 코스터 6 pdtCode(G-2)·PR 인쇄방식 분리(P-4)와 동류 **카탈로그 정책**(상품분기 vs variant — 후니 정책 결정). 메타모델 정답 = 자재 합성코드에 `{ptt, wgt, clr, adhesion_grade, weather_grade}` 분해축 추가(평면 라벨 금지).
  - **도메인 정합:** 후니 자재모델(`entity-semantic-model.md:22` material = 종이/소재/부속 + usage_cd + 두께)에는 *점착/내후 차원 부재* → ST가 드러낸 자재 합성 갭(갭분석가 주목). GS 본체소재·PR 방수/점착포스터 자재분기와 합류.
  - **★경계(HARD):** 점착=자재 속성(소재의 접착면 특성)이지 공정 아님. 단 스크래치층(STSKDFT 은박 긁는층)·박색(STFODFT FOI)은 *공정#2*(소재 위 후공정 — 자재 아님). 자석/메탈 본체는 자재(PTT), 점착성은 자재 합성 차원, 표면 추가층은 공정 — 3자 구분.

- **★CL 확장 — 의류 본체 size×color 2D SKU 매트릭스 facet (v6.0·C-2/C-3) ★의류 variant #18 부결의 주 귀속:**
  - **★의류 본체 = (원단 PTT × 색 CLR × 사이즈 WGT) 합성 SKU·2D 매트릭스 해소(별 축 아님):** 의류(CLSTSHS 자체·CLTMSHS 단체)는 `size_color_info`가 사이즈×색 셀(227셀 자체/54셀 단체)을 *단일 MTRL_COD*로 해소(S×블랙03→`SXSRT103`·M화이트26→`SXSRT226`). DIR_MTR 584행 = size×color SKU 폭발. **이는 GS variant 인코딩(G-4 DTL/ATTB/CUT 1D-per-channel)의 *2D 일반화*** — GS는 채널별 1D, CL은 size×color 2D 매트릭스→단일 코드. **둘 다 같은 자재축 facet**(별 "의류 variant 축 #18" 거부): 사이즈→#13·색→색상(자재 CLR·D-2 "본체색=자재 CLR")·셀→단일 MTRL_COD(G-1 완제 본체 SKU 라벨 융합 동형). 2D-ness=cardinality 속성이지 새 관리 관심사 아님.
  - **★[HARD] G-1 동형 분해 요구:** PCS_DTL_NME("(5942) 6.2oz 프리미엄 티셔츠 화이트 L")·MTRL_COD(SXSRT326)를 `{body_fabric/PTT(6.2oz 프리미엄), body_color/CLR(화이트=26), size/WGT(L=3)}`로 분해(평면 SKU 라벨=의미축 drop). G-1 완제 굿즈 본체(텀블러 "미르 화이트 20oz")와 동일 처방 — 후니 굿즈/의류 본체소재 부재 결함(round-22 GPM)의 의류판 정답. 사이즈가 MTRL_CD 첫자리(1xx=S·2xx=M·3xx=L)·색이 끝2자리(03블랙·26화이트) 인코딩 = 합성코드 분해 규칙(D-2·#1 합성).
  - **★셀별 가용성 = 제약#5(2D 정점·아래 #5 참조):** size_color_info 셀별 HIDE_YN/QUICK_ORD_YN/HIDE_RSN = (사이즈,색) 조합 가용성 = 제약#5 match/exclude의 2D subject(자재 합성에 부착되나 가용성 판정은 #5). ST disable 227건(S-8 정점)과 동일 규모·패턴, 단 2D axis-pair.
  - **자체/브랜드/단체 3분기 = 원단 라이브러리 계열(카탈로그 정책):** 자체(CLST·SXSRT/SXSHT)·브랜드완제(CLDF·CLTM·SXZSB) = *원단 출처* 차이이지 옵션 모델 차이 아님(CLST·CLTM 둘 다 clothes2025 실측). 원단 카탈로그 3계열 + 색/사이즈 모집단 차이(54색 vs 6색·adult vs child). GS 코스터 6 pdtCode(G-2)·PR 인쇄방식 분리(P-4) 동류 카탈로그 정책(상품분기 vs variant)·메타모델은 자재축으로 흡수.
  - **도메인 정합:** `entity-semantic-model.md` "색상 variant→material·사이즈 variant→size" 분리 원칙 = CL이 그 분리를 size×color 2D 매트릭스로 *합일*해 둠 → 분해 표현력 필수(평면 매트릭스 코드 금지). GS 본체소재(#1 v2.0)·PR usage 역할전파(#1 v4.0)와 합류한 자재 본체 모델링 갭(갭분석가).

- **★AC 확장 — surface-finish 합성 차원 + WGT 슬롯 다의성(두께) + 라미 합성 + PET 본체 (v7.0·A-1/A-2/A-7/A-8):**
  - **★surface-finish/광학효과 = 자재 합성의 또 다른 차원(ST S-4 동형·별 축 아님):** 아크릴 표면효과(투명/홀로그램[깨진유리·격자]/글리터/거울/자개/렌티큘러/파스텔/유색)가 ① 자재행 PTT/라미 인코딩(ACTHDKY 6소재 enum) ② 소재특화 pdtCode(ACTH*KY 9상품) 양면. = 자재 합성코드 `surface_finish` 분해축(ST 점착/내후 `adhesion_grade`/`weather_grade`와 동근). **★거울 별공식 주의:** 거울(MIRROR3T)이 [huni-ref] **별 가격공식 `PRF_MIRROR_ACRYL`**(전면5도)을 가지나 = 가격기여역할#11 라우팅(소재계열별 가격엔진·A-6)이지 *자재 분류*가 아님 — 거울 본체 자체는 자재#1(미러 PTT·surface=mirror), 가격 분기는 #11. 메타모델 정답 = `{ptt, wgt, clr, surface_finish}` 합성 분해축(평면 라벨 금지).
  - **★WGT 슬롯 다의성(평량 vs 두께):** AC는 두께(3T=D01·5T=D02·라미 L01~04)를 MTRL_CD의 WGT_CD 슬롯에 인코딩 — WGT 슬롯이 평량(종이 g·BN/PR/GS-paper)과 두께(아크릴 mm·AC)를 *같은 슬롯·도메인별 의미*로 다의 사용(GS 장패드 4T 동형). **★[huni-ref] 후니 동형 결정적:** `acrylic-chain-design.md:14·63·149` 후니가 **투명3T/1.5T를 한 comp(COMP_ACRYL_CLEAR3T)의 mat_cd 차원으로 통합**(1.5T=MAT_000042·3T=MAT_000043·단가 1.5T=3T×0.8 정합) = AC WGT 슬롯과 정확히 동형(두께=자재 차원·별 두께축 아님). 자재 합성코드 WGT 차원의 정당한 다형성 — 단 후니 WGT 슬롯에 `measure_type`(평량/두께/용량) 구분 필요여부는 vessel 검토(갭분석가).
  - **★라미(MTG_LAM) 결과 = 자재 합성 (A-8 핵심):** 라미네이션은 공정#2(합지·아래 #2)이고 그 *결과인 라미된 자재행*(PXAATL01 3T투명 라미 2T+1T·PXAATL03 홀로그램 라미)은 자재#1 *합성*(D-2 "MTRL_CD 다축 합성") — 두께 합성(3T→2T+1T)=WGT 차원·홀로그램 부여=surface-finish. 즉 라미는 *합성 자재행을 만드는 공정*이고 GRP_OPTION_CD(production_method)가 그 자재 subset을 게이팅(옵션#3 cascade·#3 AC 확장). 가공방식 그룹핑은 공정#2+자재#1합성+옵션#3 cascade로 분해(별 #18 축 거부).
  - **★PET 본체 + 합지(명찰 A-7) = G-1/CL 라벨 융합 동형:** "아크릴 명찰"(ACNTHAP) 본체 자재=고투명 PET 리무버블(RXIGC075)이고 아크릴감은 BON_PAP/ACXXS 아크릴합지(공정#2)로 부여 — 상품명 "아크릴"≠본체 자재(=PET). G-1 완제 굿즈 본체(텀블러 라벨 융합)·CL C-2 의류 MTRL_COD 융합과 동일 [HARD] 분해 처방(본체 자재 vs 합지소재 vs 상품명 분리). 합지(BON_PAP)=공정#2 멤버(자재 시트 consumes bundle·D-2)이지 별 자재슬롯 아님.
  - **도메인 정합:** entity-semantic-model "두께 variant→material(별도 mat_cd)·색상 variant→material" 원칙 = AC 두께/surface-finish가 그 합성축. 후니 자재모델에 surface-finish(광학효과) 차원 부재 = AC가 드러낸 자재 합성 갭(ST 점착/내후·GS 본체소재·PR 방수와 합류·갭분석가). 부속물(고리/받침)은 부속물#8(아래·자재#1의 sub_mtrl).

### 2. 공정 축 (Process) ✅ — D-2/D-4 확장

- **identity:** 본체에 가하는 작업(재단·코팅·봉제·타공·박·형압·완칼·아크릴가공·제본…). 순수공정 vs 자재소비공정 구분.
- **entities(그릇):**
  - `ProcessGroup` — 후가공 그룹(RP=PCS_COD: CUT_ZUN재단·COT_DFT코팅·ILT_DFT아일렛·SEW_DFT봉제·SEW_RIN고리·LUM_DFT각목·QBG_DFT큐방·ROP_DFT로프·SUB_MTR부자재·PKG_GB포장·CDL_DFT거치대[→부속물 D-1]).
  - `ProcessMember` — 그룹 내 상세 선택(RP=PCS_DTL_COD: ZDINC정사이즈재단·ZDFRM모양재단·TCMAS무광코팅·RCDFT사각귀퉁이…).
- **attributes(ProcessMember):**
  - `pcs_cod`(그룹), `pcs_dtl_cod`(멤버 leaf).
  - `esn_yn`(필수 여부 — CUT_ZUN/COT_DFT=Y, A-5).
  - `sub_mtrl_yn`(자재소비 — Y면 Material FK, D-2).
  - `qty_input_yn`(파라미터 수량 슬롯 보유 — D-4).
  - `seq`(공정 순서 — 출력→코팅→재단→후가공→포장, process-recipe §2).
  - `price_flag`(후가공가 — PCS_INFO[], D-6).
- **relationships:**
  - ProcessMember → ProcessGroup(belongs-to).
  - ProcessMember(sub_mtrl_yn=Y) → Material(consumes, D-2).
  - ProcessMember → ProcessParameter(has, 조건부 — D-4).
  - ProcessMember → ProcessMember(**precedes**, 순서 의존 — 오시→접지, 출력→코팅→재단, UV→레이저커팅, process-recipe §2-3).
  - ProcessGroup → 제약(excl_group 택1·essential — D-3).
- **constraint & cascade:**
  - 그룹 내 택1(SEL_TYPE.01 exclude) / 필수(ESN_YN essential).
  - 선행 공정 완료 후 후행(PDF "앞공정 안 찍으면 다음 못 찍힘" — process-recipe §2-1).
  - **도메인 경계(HARD):** 별색=공정(PROC_000007 family, 화이트/클리어/금/은 후공정), UV 변형=공정 파라미터(PROC_000002, print_side 오적재 금지), 줄수/조각수=공정 신호(옵션값 아님).

- **★GS 확장 — 제본 그룹 + 형태가공 분기 (v2.0):**
  - **제본방식 = 방식별 PCS_COD + 상호배타 택1 그룹:** `RIN_DFT`(트윈링)·`RIN_COL`(코일)·`STA_DFT`(중철). RedPrinting은 *그룹 메타 없이 코드만 다름* — 한 상품은 한 방식만(택1). 좌철/상철(`BPLFT`/`BPTOP`)=제본 방향 variant. 제본=공정+자재(링/코일=금속부자재 consumes #1) bundle. **도메인 정합:** entity-semantic §4 하드커버=표지/면지 반제품, process-recipe 제본 레시피.
  - **형태가공(완제 굿즈 조립)은 별도 distinct 신축으로 분리 → #14 참조.** `PDT_WRK`(파우치가공·마이크텍조립)·`FLX_ZIP`(지퍼)는 평면→입체 본체 조립 공정으로, 일반 후가공(본체에 작업 가함)과 lifecycle이 다름(본체 *형태 자체를 생성*). BN(평면 배너)엔 전무 → GS distinct(D-10).
  - **공정 멤버의 DTL코드가 variant 합일 키:** `THO_CUT`(완칼도무송) DTL = 칼틀 형상(NT001 하트/NT002 여권), GSTGMIC에선 `THO_CUT` DTL(TG001/3) = `WRK_MTR` DTL과 동일 키 → **한 DTL코드가 부자재·칼틀·사이즈·가격 동시 결정**(강결합 SKU variant). variant 3채널 ① DTL 방식(아래 #3 옵션축·G-4).
  - **포장 방식별 PCS_COD + 유료/무료 혼재:** `PAK_ETC`(텀블러·장패드)·`PAK_POL`(폴리백) 방식별 분기. 같은 PAK_ETC라도 텀블러=무료(0)·장패드=유료(1000) → 단가행이 상품×포장 조합. BN PKG_GB(강제 제약·A-5)와 달리 GS는 선택+개당과금 경향(공정-옵션 이중성, 가격기여 #11로 분기).

- **★PR 확장 — 접지(folding) family + 제본 방식 + 특수후가공 멤버 (v4.0·P-1/P-4/P-5/P-9):**
  - **★접지(FLD_DFT) = 평면 종이 면가공 family (P-1·directive #1·BN/GS/TP 미발굴):** `pdt_pcs_info` FLD_DFT 7종(2단/3단/4단/대문/반대문/병풍/N모양) = 평면 종이를 N면으로 분할하는 공정 family. **접지방식 enum = 공정 파라미터(#9)**(오시 줄수·접지 16종이 공정파라미터인 것과 동형). **면 수(2단=4면)는 접지방식에서 *계산되는 파생값*이지 독립 차원 아님** — "면 분할 축" 신설 거부(파생값을 축으로 승격 금지·판걸이수=앱계산 동형). 리플렛 정체=접지방식(접지가 통상 필수). 포스터=접지 선택적·리플렛=강제 추정(SSR-negative·unobserved).
  - **★접지↔오시 cascade (P-1·새 cascade 패턴):** 오시(OSI_DFT 접는선 누름)는 접지 동반 공정(두꺼운 용지 접을 때 필수) = 제약#5 force/match(접지방식→오시). process-recipe-tree §2-3 "오시 줄수=캐스케이드 입력값" 정합. BN/GS/TP 미발굴 동반 cascade.
  - **제본방식 = 공정 멤버 + 상품분기 (P-4):** 무선(PER_DFT 좌철)·스프링·트윈링(RIN_DFT)·스테플러(중철 STA_DFT)·실제본 — RedPrinting은 pdtCode로 분기(PRBKYPR=무선·PRBKYCO=스프링…). 무선=소프트커버(CVR_SFT ESN_YN=Y 자동). 제본방식↔표지/면지/날개커버 가용성 cascade. **상품분기 vs 옵션화는 후니 정책**(GS G-2·TP T-4 동류·discovered-axes P-4). GS 제본 그룹(RIN/STA)에 PR 무선(PER_DFT)·실제본 합류.
  - **제본방향(BIND_DIRECTION) = 기초코드 enum + 필수제약:** BPLFT 좌철/BPTOP 상철(ESN_YN=Y) — 책 펼침 방향. 기초코드#6 enum + 제약#5(필수).
  - **PR 특수후가공 멤버 (P-9):** 스코딕스(Scodix 입체 UV 엠보·PRCASCO)=특수인쇄 UV family(#9 UV param·PROC_000002)·레이저커팅(THO_LAS·PRCACUT)=특수재단 + 칼틀 형상=사이즈#13(도무송 형상=칼틀 1:1)·합지(BON_PAP)=접합 + 자재 2종 bundle(P-5 동형)·화이트인쇄(PRT_WHT)=별색 family(TP T-E 동형·도수/자재 오적재 금지). 전부 *새 멤버*이지 새 *축* 아님.
  - **부분UV(SCO_DFT)·날개커버(CVR_SWN)·책받침코팅(LAM_DFT)·타공(HOL_DFT)·모양커팅(THO_GRA)·미싱(MIS_DFT):** 포스터/책자 후가공 멤버(공정#2). NOTICE "투명 잉크 부분 PDF 별도·에디터 주문 불가"(SCO_DFT) = 입력채널#16 제약(usePDF 전용).
  - **disable 제약 (책자 24건·P-1):** `pdt_disable_pcs_info` — 저평량지(미색모조80g·에스플러스) → 코팅/접지(FLD)/미싱 비활성. 자재→공정 disable(D-3·BN force의 역방향). PCS_DTL_CD=null이면 그룹 전체 disable.

- **★ST 확장 — 칼선 2메커니즘 + 재단입자 family (v5.0·S-2/S-3) ★directive #1/#2 — facet 확정:**
  - **★칼선(모양커팅) = 공정#2의 두 모드 family (S-2·신축 거부):** 모양커팅이 `THO_GRA`(자유칼선=디자인 외곽 도무송)와 `THO_DFT`(형상별 프리셋 칼틀 enum: 원형 CL001~010·라운드 RC001~025) 두 메커니즘으로 갈림(reverse §0.2 실측). **후니 KB 결정적(`pdf-domain-knowledge.md:113-115`):** 완칼(PROC_000053 종이+후지)·반칼(PROC_000054 종이만 `모양`)·스티커완칼(PROC_000055 `조각수`)·도무송("칼선 자유모형 컷팅·완칼/반칼 계열")이 *전부 공정 멤버*. → THO_GRA/THO_DFT = 모양커팅 공정의 두 모드(family)이지 별 축 아님. **프리셋칼틀(THO_DFT)이 사이즈를 겸함** = 공정#2(칼선) + 사이즈#13(칼틀=프리셋) cascade(형상#17이 어느 칼틀 enum인지 게이팅). PR THO_GRA(1종)·GS THO_CUT·레이저커팅(P-9) 합류 — ST가 칼틀 enum(원형 11·라운드 25)으로 가장 깊으나 *깊이는 멤버 수이지 새 축 아님*.
  - **★재단 입자(반칼/완칼/낱장) = 공정#2 멤버 + 배치 facet (S-3·신축 거부):** `CUT_DFT`가 DFXXX 묶음재단(반칼시트=시트에 배치 후 kiss-cut으로 떼어씀)·DFITM 개별재단(낱장 완칼 분리) 2종(reverse §0.3 NOTICE 실측). **후니 KB 결정적(`pdf-domain-knowledge.md:71` Case2 스티커 레시피):** "디지털출력 → (코팅) → **반칼커팅/완칼커팅** → 재단 → 포장" = 반칼/완칼이 *재단 공정의 분기 멤버*. 상품명 "사각반칼"의 "반칼"=묶음재단(DFXXX) 기본값. → 재단입자 = 공정#2(재단) 멤버(반칼=PROC_054·완칼=PROC_053) + (시트 배치는 임포지션 facet). GS 완칼 THO_CUT과 같은 "재단/분리 입자" 공정 family로 통합. **★별 축 거부:** 반칼/완칼이 *별 분류축*이 아니라 후니가 이미 PROC_053/054/055로 1급 공정 멤버화 — 신축은 공정 멤버 중복.
  - **★화이트강제(PRT_WHT) = 공정#2 + 제약#5 (S-7):** 화이트언더베이스(투명/유색/천 위 발색)가 일반 스티커=선택(ESN_YN=N)·DTF=강제(ESN_YN=Y·천 위 전사라 흰바탕 필수). 공정#2 별색 family(TP T-E·`entity-semantic-model.md:88` PROC_000008 화이트=투명/홀로그램/메탈 베이스) + 자재(투명PET)/인쇄방식(DTF)→화이트 force cascade(#5). **별색=공정 경계(HARD)** — 화이트를 도수/자재로 오적재 금지.
  - **★넘버링(NUM_DFT) = 공정#2 (+가변이면 VDP#16) (S-9):** 일련번호 가변 인쇄가 ① 단순 공정(인쇄 후 넘버링기) ② VDP(가변데이터·`db-domain-structure-live.md:133` "가변텍스트/가변이미지" 공정 멤버 실재). TP T-3 티켓 넘버링·#16 입력채널 데이터바인딩 합류. 절취선(미싱 MIS_DFT)=공정#2 확정·순차번호=VDP/공정 분배. 가변 증분 규칙 unobserved → gap/validation.
  - **★특수후가공 멤버 (S-4 경계):** 스크래치층(STSKDFT 은박)=공정#2(소재 위 후공정)·박/형압(STFODFT FOI·STEMDFT EMB)=공정#2(PR P-9·TP T-E 동형). 자재 아님(점착=자재 합성·표면층=공정 분리·#1 ST 경계 참조).
  - **★disable_pcs 정점(227건) (S-8):** ST `pdt_disable_pcs_info` 227건(26소재 × 후가공 — 특수소재[PET/금속/한지]→코팅/박/형압/미싱/부분UV/접지 비활성). BN 강제(0건)·책자(24건)의 **정점 케이스** — 제약#5 disable 룰엔진 일반화 검증(JSONLogic vs 자재-후가공 호환매트릭스 그릇). 자재→공정 disable(D-3·force의 역방향).

- **★CL 확장 — 인쇄위치 멀티슬롯 + Pantone 별색 family (v6.0·C-4/C-7):**
  - **★인쇄위치(print_area) = 공정#2 멀티슬롯 facet (C-4·신축 거부):** `apparel_info.print_area` 6종(좌측가슴/앞면/좌측팔/우측팔/뒷목/뒷면)이 `pdt_pcs_info`의 `PDT_WRK` 6행(CL011 좌측가슴·CL001 앞면…)과 1:1. **위치별 인쇄가 PDT_WRK 항목으로 가산**(가격캡처: PDT_WRK/CL011 좌측가슴 PRICE=3700·DIR_MTR/SI014 본체 16200→result_sum 19900). 다중선택(앞면+뒷면+소매 동시 추정·각자 가산). **= 공정#2 위치별 인쇄 멤버의 멀티슬롯 facet** — GS 귀돌이(ROU_DFT 좌상/우상/좌하/우하 4슬롯·"한 공정이 위치별 N PCS 항목으로 분리")·ROP 동형. 위치별 가격=#11·KOI_NME(leftchest/front)→입력채널#16 에디터 캔버스 매핑(TP 합류). 별 "인쇄위치 축" 거부 — 공정#2 멀티슬롯 + #11 + #16의 결합.
  - **★Pantone 1124 별색 = 공정#2 별색 family (C-7·신축 거부):** `apparel_info.pantone_color` 1124(PANTONE C 전체) = 실크인쇄(PTP_SLK) spot color 라이브러리. **별색=공정(round-22 경계규칙·`entity-semantic-model.md` PROC_000007 family·HARD)** — ST/PR 별색·후니 별색과 같은 공정#2 그릇. 규모(1124)는 기초코드#6 도메인 거버넌스 관점(별색 도메인 enum 규모 정점)이나 *축은 공정#2*. 의류 전용 별색 도메인 아님(전체 Pantone C). **별색을 도수/자재로 오적재 금지(HARD).**

- **★AC 확장 — 라미네이션/합지 + 완칼(자유레이저) + 화이트 + 입체조형 + 부착 멤버 (v7.0·A-3/A-4/A-5/A-7/A-8):**
  - **★라미네이션(MTG_LAM)/합지(BON_PAP) = 공정#2 합지 family (A-8·A-7):** 라미(MTG_LAM)=홀로그램/투명 위 라미네이션 합지(2T+1T 두께 합성)·합지(BON_PAP/ACXXS)=PET에 아크릴 시트 합지(명찰 아크릴화). 둘 다 *합지 후가공 공정 멤버*(PR BON_PAP·TP T-6 STA_CLD·GS 동형). 합지/라미가 자재 2종(본체+합지시트) consumes bundle(D-2)·결과는 합성 자재행(#1 AC 확장). **★가공방식(production_method 일반/라미)은 별 #18 축 아니라 공정#2(라미)·라미 결과는 자재#1·그룹핑은 옵션#3 cascade로 분해**(A-8 부결).
  - **★완칼/자유형 레이저(LAS_DFT/FRXXX) = 공정#2 모양커팅 (A-4):** 아크릴 키링/등신대=디자인 외곽 자유형 레이저 절단(FRXXX·STICKER_TYPE=FR)·명찰=레이저 재단(DFXXX). ST THO_GRA(자유 도무송·S-2)·완칼 PROC_000053(`pdf-domain-knowledge`)와 동일 "자유칼선 모양커팅" 공정 family — 아크릴 절단=완칼(자유레이저) 일원. 정형 칼틀(THO_DFT) 아닌 자유칼선.
  - **★화이트인쇄(PRT_WHT) = 공정#2 별색 family (A-5·ST S-7 동형):** 투명/유색 아크릴 위 색 표현 화이트 언더베이스(불투명 명찰엔 없음). PROC_000008 화이트(투명/홀로그램/메탈 베이스)·ST S-7·TP T-E 동형 — 투명소재→화이트 가용 cascade(제약#5). **별색=공정 경계(HARD)·화이트를 도수/자재로 오적재 금지.**
  - **★입체조형(코롯토 FCO) = 공정#2 (A-3):** 입체 아크릴 코롯토(ACTHFCO)의 다층/곡면 입체조형=공정#2(특수가공·unobs). 양면(BCO)=옵션#3 인쇄면(아래)·두께블록(DCO 8T)=자재#1 두께. 즉 입체/스탠드는 분산 facet(distinct 3D축 거부).
  - **★부착 공정(고리/받침/자석/핀 부착·조립) = 공정#2 + 부속물#8 consumes bundle (A-4):** 고리 부착(O링 조립)·받침 거치·자석/핀 부착·뒷면 옷핀/마그넷(WRK_MTR)·통자석 합지(ACPDAMG)가 부속물#8(고리/받침)을 consumes하는 부착 공정(D-2 bundle·메모리 "옵션=자재+공정 BUNDLE"). 부속물 자체=#8(아래)·부착=공정#2.

### 3. 옵션 축 (Option) ✅

- **identity:** 본체의 *독립 선택* 속성으로, 다른 축(자재·공정·사이즈·수량·파라미터)에 귀속되지 않는 순수 선택. (BN에서는 대부분 다른 축으로 분화 — 수량→D-5, 파라미터→D-4.)
- **entities(그릇):** `OptionGroup`(택1/택N) → `Option` → `OptionItem`(polymorphic 참조 — 후니 ref_dim_cd).
- **attributes:** `opt_group_cd`, `sel_type`(택1/택N), `opt_cd`, `ref_dim_cd`(polymorphic — 어느 차원 행을 가리키나: size/material/process/print/bundle), `disp_seq`(표시순서=컬럼순서, 메모리 `dbmap-load-column-order-staged`).
- **relationships:** Option → 차원 행(polymorphic ref — 후니 OPT_REF_DIM 7종), Option → 제약(D-3).
- **constraint & cascade:** 택1/택N, polymorphic 참조 무결성(후니 fn_chk_opt_item_ref). **BN 시사:** 옵션 축은 "분류되지 않은 잔여"가 아니라 *명시적으로* 수량/파라미터/부속물을 분리한 뒤 남는 순수 선택만 담음.

- **★GS 확장 — variant 3채널 인코딩 (v2.0·G-4):** 같은 "variant" 개념이 RedPrinting에서 *세 채널*로 분산 인코딩됨. 메타모델은 셋을 명시 구분(단일 평면화 금지):
  - **① DTL코드 채널 (SKU성 variant):** PCS_DTL_COD가 variant 키. GSMLSLC `DIR_MTR/MLS01`=색(핑크), GSTBMWM `TM039`=색+용량(화이트 20oz), GSTGMIC `TG001/TG003`=S/L(★사이즈+자재+칼틀+가격 동시 결정 강결합). → option_item이 *복수 차원을 동시 게이팅*하는 경우(G-4 정규화 난점). **도메인 정합:** entity-semantic §2 색상 variant→material, 사이즈 variant→size 2차원 분리 원칙 — RP DTL은 이 분리를 *코드 하나에 합일*해 둠 → 메타모델 정답 = DTL→{material, size, process, price} 다중 참조로 분해.
  - **② ATTB 채널 (옵션 파라미터 variant):** 옵션값이 ATTB 파라미터. GSNTSPR 트윈링 `ATTB="RIN_BLK"`(링색), 귀돌이 `ATTB="4"`(라운드 반경 4mm). → 공정 파라미터(#9)와 동근(ATTB=공정종속 매개변수). 링색·반경은 #9로 귀속.
  - **③ CUT 차원 채널 (사이즈 variant):** CUT_WDT/HGH가 variant. GSNTSPR 182×257(Medium)/132×182, GSNTSTA 132×132(여권형)/88×125 — 같은 MTRL_CD에 사이즈 프리셋만 변동 → 사이즈축(#13) 프리셋. THO_CUT 형상과 캐스케이드(형상↔사이즈 1:1).
  - **판정:** 3채널은 *기존 축들(옵션·공정파라미터·사이즈)로 분배*되므로 별도 "variant 축" distinct 신설 거부(facet). 단 ① DTL의 다차원 합일은 polymorphic option_item(후니 ref_dim_cd 다중)으로 명시 표현 필요.

- **★AC 확장 — 가공방식(production_method) cascade + 인쇄면 (v7.0·A-8/A-5):**
  - **★가공방식(일반/라미)→자재 subset 게이팅 = 옵션#3 polymorphic cascade (A-8 핵심·#18 부결):** `option_info.production_method`(MTG_DFT 일반/MTG_LAM 라미)가 GRP_OPTION_CD로 자재행을 가공방식 그룹으로 묶고, 옵션 선택(일반/라미)이 호환 MTRL_CD subset을 게이팅(MTG_DFT→PXAATD01/D02·MTG_LAM→PXAATL01~04). = **G-4 "한 DTL/옵션코드가 자재 subset 결정" 동형·CL size×color 매트릭스가 자재 SKU 게이팅과 동근**(옵션#3 polymorphic ref가 자재#1 subset 게이팅·제약#5 match). "자재를 가공방식으로 그룹핑하는 슬롯"=옵션#3 cascade 관계 간선이지 별 관리 축 아님(라미 자체=공정#2·라미 결과=자재#1 합성·#1/#2 AC 확장). **★ST 형상(#17)과 결정적 차이:** 형상은 사이즈축이 *왜곡 없이 못 담음*(KB G-SK-2 결함)이라 distinct, 가공방식은 옵션#3 cascade가 *왜곡 없이 담음*(라미=공정 멤버 이미 수용·KB 결함 없음)이라 facet.
  - **★인쇄면(print_data 앞뒤같음/다름) = 옵션#3 (투명소재 종속·A-5):** 투명 아크릴 양면 시야 → 앞뒤 데이터 동일(O)/상이(X) 택1(키링/등신대)·불투명 명찰엔 없음(null). 옵션#3(앞뒤 택1) + 투명소재→가용 제약#5 cascade. "양면"이 도수(SID_D)·인쇄면(print_data)·코롯토(BCO 자립) 3축 분산 — 각자 다른 의미(인쇄면=앞뒤 디자인 데이터). 단 인쇄면이 옵션#3인지 도수#6 차원인지 라이브 확인 필요(앞뒤다름=별 2면 디자인).

### 4. 템플릿/SKU 축 (Template/Bundle) 🟡 — BN 약관측

- **identity:** 완제 주문 단위(SKU) 묶음 — 본체 + 부속물 + 선택 조합을 하나의 주문 가능 단위로. (BN: "현수막+거치대 1세트" 번들. 후니: 봉투결합 엽서·OTC.)
- **entities(그릇):** `Template`(SKU) → `TemplateSelection`(구성 선택 묶음).
- **attributes:** `tmpl_cd`, `prd_typ`(완제품/반제품/디자인/기성 — entity-semantic §4, BN=완제품 단일 🔴), 구성 selection 목록.
- **relationships:** Template → Product(본체), Template → Addon(부속물 D-1 포함, 번들), Template → 차원 선택 묶음.
- **constraint & cascade:** 번들 내 구성 일관성(거치대 size ↔ 본체 size match, D-3). **BN 한계:** prd_typ 다양성(반제품/디자인/기성)·완제 SKU 계층은 책자/굿즈 샘플 필요(discovered-axes 갭).

- **★GS 확장 — 완제 본체가 템플릿 항목 (v2.0·G-1):** GS 굿즈 본체(`DIR_MTR/WRK_MTR`)는 *완제 SKU 라벨*(PCS_DTL_NME)로 등장 — 자재(#1 본체 facet)이면서 동시에 *주문 가능 완제 단위*(템플릿/SKU). 즉 완제 굿즈에서 **본체 = 자재참조 + 템플릿 항목 복합**. RP는 이 복합을 한 PCS_COD(DIR_MTR)에 융합. **G-1 핵심 의사결정(양면 트레이드오프) → discovered-axes.md G-1.** 메타모델 정답 = 본체를 (a) 자재참조(소재 분해)와 (b) SKU 식별(개당단가 주체)로 *두 역할 분리*하되 한 엔티티가 둘 다 carry(완제 SKU = body_material_ref + sku_price_role). 생산형태(#15)가 이 분기를 governing(C 완제품 → 본체=완제 SKU 항목, A/B 통합·셋트 → 본체=자재행).

- **★TP 이중의미 분리 — 템플릿#4 ≠ 에디터 템플릿 자산 (v3.0·T-A) [HARD]:** 본 축(#4 템플릿/SKU)은 **완제 주문 단위**(본체+부속 번들·봉투결합 엽서·OTC·후니 `t_prd_templates`)다. TP에서 관측된 "템플릿"(`useTemplateDownload=Y`·`koi_template_resource_id`·SDK `getTemplateList`)은 **에디터가 로드하는 디자인 시안**(가격 0·런타임 카탈로그·D-11#16 입력채널 종속)으로 — *같은 단어 다른 의미*다. 메타모델은 둘을 **별 엔티티로 분리**: `Template`(#4 완제SKU 번들·주문단위) vs `TemplateAsset`(#16 종속 디자인 자산·입력 리소스). RedPrinting `koi_template_resource_id`=후자, `t_prd_templates`=전자. **후니 매핑 시 혼동 금지** — TP 디자인 시안을 `t_prd_templates`(완제SKU)에 적재하면 의미 오염(가격0 디자인 리소스를 주문단위로 오모델). 갭/vessel 단계에서 입력채널 리소스 그릇 별도 설계(T-A 판정).

### 5. 제약 축 (Constraint) ✅ — D-3 유형화

- **identity:** 축 간 *관계 규칙* — disable/force/require/match/exclude/essential/min-max의 유형화된 논리 어휘. (메타모델의 관계 엔진.)
- **entities(그릇):** `Constraint`(logic-typed) — `{type, subject_axis, subject_ref, object_axis, object_ref, op}`.
- **attributes:** `constraint_type`(6유형, 아래), `logic`(JSONLogic, 후니 constraints.logic NOT NULL), `direction`(force=+ / disable=−).
- **6 논리유형(D-3):** disable(자재→공정−), force/require(자재→공정+, PET→코팅·텐트천→포장), essential(그룹내 필수 ESN_YN), match(사이즈↔부속물 1:1), exclude(그룹내 택1 SEL_TYPE.01), min-max(nonspec 범위 0~5000).
- **relationships:** *모든 축을 잇는 간선* — Material↔Process(disable/force), Size↔Addon(match), ProcessGroup-internal(exclude/essential), value-range(min-max).
- **constraint & cascade:** force = disable의 역방향(대칭 쌍). 캐스케이드 = match(선행 선택이 후행 선택지를 게이팅). 후니 round-6 캐스케이드 6종 → JSONLogic.
- **★CL 확장 — 2D 셀가용성 매트릭스 정점 (v6.0·C-3):** 의류 `size_color_info` 셀별 가용성(227셀 자체/54셀 단체·셀마다 HIDE_YN/QUICK_ORD_YN/HIDE_RSN)이 **(사이즈축 × 색상축) 2D 조합의 가용성 제약**. ST disable 227건(S-8·1D 자재→공정 정점)과 동일 규모이나 **2D axis-pair subject**(사이즈×색 = match/exclude의 2축 곱). 셀=실질 가용성 게이트(특정 사이즈×색 조합 품절/미생산 시 HIDE_YN=N). 메타모델은 이를 별 매트릭스 그릇이 아니라 *제약#5 match/exclude의 2D subject*(JSONLogic `{size, color} → available`)로 표현 — 제약 룰엔진의 2D 일반화 검증. ST disable(1D)·BN force·CL 셀가용성(2D)이 제약#5 동일 어휘의 차원 확장.

### 6. 기초코드 축 (Base-Code / Enum) ✅

- **identity:** enum 도메인 거버넌스 — 사이즈 프리셋, 도수 enum, 코드값 그룹의 권위.
- **entities(그릇):** `EnumGroup`(코드 그룹) → `EnumValue`(코드값) — 후니 BASE_CODE_GROUP.
- **attributes:** `group_cd`, `code`, `label`, `seq`. 사이즈 프리셋(DIV_NM: 5000X900·900X900…), 도수(SID_S 단면·PRN_CLR_CNT=4), usage/qty_unit/mat_type 등.
- **relationships:** EnumValue ← 자재/사이즈/도수/공정 축(코드 도메인 제공).
- **constraint & cascade:** 채번 규칙(surrogate PK + 이름기반 멱등, 메모리 `dbmap-code-identifier-strategy`), separator 통일. **사이즈 = 프리셋 enum + nonspec 범위제약**(기초코드 + 제약 복합, BN 전 상품 — A-2/sizes).
- **★PR 확장 (v4.0):** ① **도수 enum이 usage_cd role-paired (P-2):** 표지 도수(`pdt_dosu_info` SID_S 단면4/SID_D 양면8) vs 내지 도수(`inner_pdt_dosu_info` SID_D·INN_CLR=1 흑백) 독립 — 도수 enum이 표지/내지 역할별 분리(자재#1 usage_cd 전파). ② **출판판형 enum (P-4 책자):** 크라운판(176×248)·신국판(152×225)·A4/B5/A5세로형 = 책자 특화 사이즈 프리셋 enum(출판도메인). ③ **제본방향 enum (P-4):** BPLFT 좌철/BPTOP 상철. ④ **접지방식 enum (P-1):** FLD_DFT 7종(공정파라미터#9 값 도메인). ⑤ **인쇄방식 enum (P-4):** 윤전/토너/인디고/리소.
- **★CL 확장 — GBN(연령) + 색상 스와치 + 인쇄방식/위치 enum (v6.0·C-8):** ① **★GBN(adult/child) = 사이즈 enum 하위 속성 (C-8):** `apparel_info.size_info`가 사이즈 코드(XS~3XL·120~150)에 `GBN`(성인 adult/아동 child) 연령 분류 부착 — CLSTSHS(자체)=adult만·CLTMSHS(단체티)=adult+child(120~150) 활성. GBN은 **사이즈 enum의 하위 속성(연령 분류)**이지 별 분류축 아님(사이즈#13/기초코드#6 하위). 상품별 child 가용은 제약#5(단체티만 child 활성). ② **색상 스와치 라이브러리:** `apparel_color`(자체 54색 HEX·DEFAULT·HIDE_YN / 단체 6색) = 색 enum(자재 CLR #1 값 도메인) + HIDE_YN 가용성(#5). 자체54 vs 브랜드6 = 원단별 재고색 모집단 차이. ③ **인쇄방식 enum(PTP_DTF/DIR/SLK)·인쇄위치 enum(print_area 6)** = 각각 #12·#2 값 도메인(USE_YN·order 관리).

### 7. 카테고리 축 (Category) 🔴 — BN 미발굴

- **identity:** 상품군 트리 + 다중분류 + 생산형태(완제품/반제품/디자인/기성, entity-semantic §4와 직교).
- **entities(그릇):** `Category`(트리 노드, parent FK) — 상품 다중 소속 가능.
- **attributes:** `cat_cd`, `parent_cat_cd`, `main_yn`(잎노드), `생산형태`(prd_typ, 직교 분류).
- **relationships:** Product → Category(multi, 한 상품 여러 트리), Category → Category(트리 parent-child).
- **constraint & cascade:** 트리 무결성(고아 금지 — 메모리 round-22 고아 14노드 113상품 교훈). **BN 한계 해소(GS):** BN 전부 단일/완제품 C형이었으나 GS가 **공통 기능 그룹화**(코스터 6 pdtCode = 1 "코스터" 카테고리, 노트류 = 제본형 그룹)를 드러냄 → 카테고리 = 소재/형태 다른 다수 pdtCode를 한 기능 노드로 묶는 트리. **생산형태(완제품/반제품/디자인/기성)는 카테고리와 직교 → 별도 distinct 신축 #15로 분리**(GS가 C 완제품 다수 노출로 입증). 코스터 G-2 = 소재를 카테고리(공통기능)로 묶되 pdtCode 분리 vs 소재 옵션화 결정(discovered-axes G-2).
- **★PR 확장 — 용도별 책자 = 카테고리 태그 (v4.0·P-8):** PRBKPSN(독립출판)·PRBKCTL(브로셔)·PRBKPRP(보고서)·PRBKTXB(교재)·PRBKZIN(잡지)·PRBKPOL(작품집)이 §2 책자 본체 동일·용도 라벨만 차이. 용도=카테고리 노드/태그(기능 분류) 또는 마케팅 표시 라벨(note/tags 쉬운 한국어·메모리 round-15). 본체 모델(생산형태/자재/공정/페이지) 불변 → distinct 아님. RP=별 pdtCode(마케팅 진입점). 상품분리vs태그 선택 = 후니 정책(P-4·GS G-2·TP T-4 동류). 또 **인쇄방식/제본방식 매트릭스(책자 19상품)를 한 "책자" 카테고리 노드로 묶는 트리**(코스터 6 pdtCode=1노드 동형).

---

## II. 관계/동역학 축 (객체들이 어떻게 결합·게이팅·매개변수화되나) — 발굴

### 8. 부속물 축 (Addon) ✅ — distinct D-1

- **identity:** 본체와 *분리된 완제 부속 부품*(거치대·우드봉·볼체인·이젤).
- **entities(그릇):** `Addon`(독립 SKU) — 후니 `t_prd_product_addons`.
- **attributes:** `addon_cd`(독립 코드 — PT001~005·RLU01~03·PTODF…), `label`(실내/실외 + 종류), `size_variant`(롤업거치대 600/850/1000), 자체 재고/가격.
- **relationships:** Addon → Product(belongs-to, 번들 — D-1≠템플릿: 부속물=부품, 템플릿=번들단위), Addon ↔ Size(**match** 제약 — 롤업 size↔거치대 1:1, D-3).
- **constraint & cascade:** 부속물↔사이즈 캐스케이드(size 선택 → 호환 거치대만). 본체와 별개 lifecycle(독립 SKU). **공정 아님**(본체 변형 아님), **옵션 아님**(외부 객체).

- **★AC 확장 — 받침/고리/자석/핀 부속물 + 단일 부자재 마스터 (v7.0·A-3/A-4):**
  - **★등신대 받침(AB 12 SKU) = 부속물#8 (A-3 입체/스탠드 핵심):** 등신대(ACPDSTD) 본체=평면 3T 투명 아크릴 + **받침대 SUB_MTR 12종**(형상 원/타원/사각/육각 × 크기 S/M/L·MTRL_CD=SXAPR005~016·ESN_YN=Y 필수·QTY_INPUT_YN=Y). 받침=*평면 본체를 세우는 별 완제 부속*(자체 자재코드·WRK/CUT 사이즈 보유) = BN 거치대(D-1)·우드봉·이젤·롤업 size variant 동형. **★입체/스탠드(3D)=받침 부속물#8이지 distinct 3D축 아님** — 받침은 본체(평면 아크릴)를 *생성하지 않음*(형태가공#14 아님)·본체는 평면 자재행 유지(생산형태#15 아님). 받침=필수(ESN=Y)·고리=선택(ESN=N) = 부속물 필수성 차원(제약#5).
  - **★고리/구슬줄/와이어링(SUB_MTR 80+) = 부속물#8 + 공정#2 부착 bundle (A-4 정점):** 아크릴 키링(ACTHDKY) 고리 80+ 항목(카라비너 BN001·열쇠고리 KR001~040 자물쇠/하트/별/달/고양이·컬러구슬줄 CN009~030·컬러와이어링 CR015~029) = 부속물#8(고리/끈 enum) + 부착 공정#2(O링 조립). **★고리 코드(KR/CN/CR)가 ST SUB_MTR_KR/CN/CR과 동일 코드체계 공유** = 굿즈/스티커/아크릴 횡단 **단일 부자재 마스터 시사**(후니 부자재 카탈로그 단일화·갭분석가 1순위). 명찰 뒷면(WRK_MTR·옷핀 SXANB001/마그넷 SXANB002)·자석/핀(ACPDMGN/PIN)·그립톡(ACPDJOY)·펜토퍼(ACTHPEN)=부속물#8 + 부착 공정#2. 통자석(ACPDAMG)=자성시트 합지(자재#1 PTT + 공정#2 합지·ST STMADFT 동형). AC가 부속물 카탈로그 정점(키링 80+).

### 9. 공정 파라미터 축 (Process Parameter) ✅ — distinct D-4

- **identity:** 공정 멤버에 종속된 *조건부 매개변수* 슬롯(공정 선택 시만 활성).
- **entities(그릇):** `ProcessParameter` — `{owner_process, param_type, value_domain}`. 후니 prcs_dtl_opt / ref_param_json.
- **attributes:** `owner_pcs_dtl_cod`(부모 공정), `param_type`(수량/줄수/단수/mm/색/조각수), `value_domain`(로프 USER/1~10, 오시 0~3, 접지 16종, 책등 mm, 링컬러, 조각수).
- **relationships:** Parameter → ProcessMember(belongs-to, 조건부), Parameter → 가격(공정과 결합 기여, D-6), Parameter ↔ Parameter(캐스케이드 — 오시 줄수→접지 단수, D-3 match).
- **constraint & cascade:** 부모 공정 미선택 시 비존재(조건부 활성). **도메인 경계(HARD):** 판걸이수(impos)는 *앱 계산*(DB 미저장) — 파라미터에 넣지 말 것. 파라미터=*입력* 매개변수만(메모리 `dbmap-compute-in-app-db-stores-lookup`).

### 10. 수량 모델 축 (Quantity Model) ✅ — distinct D-5

- **identity:** 단일 스칼라가 아닌 *다중 의미적 수량 슬롯*(주문 건수 × 인쇄 수량 + 공정종속 수량).
- **entities(그릇):** `QuantitySlot` — `{slot_type, value_domain, price_role}`.
- **attributes:** `slot_type`(ORD_CNT 디자인건수 / PRN_CNT 인쇄수량 / 공정종속 D-4 교차 / bundle_qty 묶음수), `price_role`(건수=세팅곱수 / 수량=선형, D-6).
- **relationships:** QuantitySlot → Product(상품마다 노출 슬롯 다름), QuantitySlot → 가격기여역할(D-6), 공정종속 슬롯 → ProcessParameter(D-4 교차).
- **constraint & cascade:** min(건수 1). **도메인 구별:** ORD_CNT(디자인 건수)≠PRN_CNT(인쇄 수량)≠bundle_qty(묶음 권/세트, entity-semantic #7)≠page_rule(내지). 평면화 금지.

- **★PR 확장 — page_rule 엔티티(INN_PAGE) 정밀 (v4.0·P-3·TP T-C 합류):** 책자 내지 페이지수(`pdt_prn_cnt_info` MIN_INN_PAGE 10~MAX 300·STEP 1·DFT 30)가 부수(PRN_CNT)와 직교한 *또 다른 수량성 슬롯*. **후니 도메인 정확 매핑:** `entity-semantic-model.md:29` "**page_rule**(`_page_rules`) 페이지 규칙(내지 min/max/증가)·책자·노트 내지 전용·떡제본/낱장엔 무의미". → INN_PAGE = 수량모델#10 슬롯이자 **후니 별 엔티티 page_rule(page_min/max/incr)**로 구현. TP 캘린더 INN_PAGE(월수)와 *같은 필드·다른 의미*(책자=대수 페이지·달력=월수) 합류 — 둘 다 page_rule. 가격: 책자는 페이지 선형가산(Δ1,120/page 실측·book2025), 캘린더 tiered_price 결합은 unobserved. **★quantityGroup 라벨 스왑 주의:** 책자=`{orderCnt:"수량", printCnt:"내지장수"}` — 포스터/TP의 "디자인수×수량"과 라벨 의미가 다름(슬롯 의미축은 상품마다 다름·평면화 금지 재확인).

---

## III. 횡단 축 (모든 축에 부착/게이팅) — 발굴

### 11. 가격기여 역할 축 (Pricing Role) ✅ — distinct(횡단) D-6

- **identity:** 각 선택축이 가격에 *어떻게* 기여하는가의 역할 태그(면적/곱수/고정/단가매트릭스).
- **entities(그릇):** 독립 테이블이 아닌 *각 축 엔티티에 부착되는 태그* + `PricingModel`(상품 단위 — SizeMatrix2D 등).
- **attributes:** `price_flag`/`price_role`(자재→면적단가키, size→면적, dosu→도수가, pcs→후가공가, ord_cnt→세팅곱수, prn_cnt→선형), `pricing_model`(real_price=면적 SizeMatrix2D, 고정가형, 합가형 — 메모리 `dbmap-price-formula-types-authority`).
- **relationships:** PricingRole → 모든 선택축(부착), PricingModel → Product(바인딩). 후니 t_prc_* 4단(prc_typ_cd 단가/합가).
- **constraint & cascade:** 면적기반 상품은 size→면적 매트릭스 + ceiling(off-grid). **경계:** 본 하네스는 *역할 분류*까지 — 실제 값/공식은 dbmap 가격 트랙. PRICE=0(비로그인)은 구조 추출에 무관.

- **★GS 확장 — 가격모델 3종 라우팅 (v2.0·G-7):** BN은 `real_price`(면적 SizeMatrix2D) 단일이었으나, GS는 완제 SKU 위 **3 가격모델**이 같은 옵션 모델에서 분기:
  | price_gbn | 가격 SP | 의미 | 가격 주체 |
  |---|---|---|---|
  | `tmpl_price` | `WSP_..._TMPL_PCS_PRICE` | 템플릿(완제 SKU) 개당단가. PRICE_LOG=개당단가+인쇄수량+주문건수 | DIR_MTR(완제 본체) |
  | `vTmpl_price` | `WSP_..._TMPL_PCS_PRICE` | variant 템플릿(v접두). tmpl과 동일 SP·변형 SKU 분기 | DIR_MTR + 가산항(장패드: 본체10000+인쇄5000+포장1000) |
  | `tiered_price` | `WSP_..._TMPL_PCS_TIERED_PRICE` | 구간(tier)가. PRICE_LOG에 **자재단가** 필드 추가(tmpl엔 없음). 수량구간 할인 동반 | PRT_DFT(인쇄, 완제본체 없는 굿즈) |
  - **시사:** `pricing_model` enum이 **면적형(BN real_price)·완제SKU개당가(tmpl)·variant템플릿(vTmpl)·구간가(tiered)** 4종으로 확장. 메모리 `dbmap-price-formula-types-authority`(면적매트릭스형 vs 고정가형) 정합 — tmpl/vTmpl=고정가형 분기, tiered=구간할인(round-1 t_dsc_* 동형). **라우팅 키:** price_gbn = 상품 속성(가격모델 선택)이며, 완제본체 유무(DIR_MTR 있음=tmpl/vTmpl, 없음=tiered가 PRT_DFT 주체)가 분기 단서. **vTmpl vs tmpl 차이(variant 유무)는 옵션 구조에 재영향** → 가격모델↔옵션 양방향. 가격 SP 내부 로직은 `unobserved`(PRICE_LOG 외, 갭분석가·dbmap 가격 트랙 영역).

- **★PR 확장 — digital_price 라우팅 + book2025 표지/내지 분리 (v4.0·P-6/P-2):**
  - **★digital_price = 같은 좌표·다른 엔진 (P-6·directive #3):** 포스터(`price_gbn=digital_price`)와 BN 현수막(`real_price` 면적매트릭스)이 *같은 좌표(CUT_WDT/HGH) 입력·다른 가격엔진* — 포스터=규격/자유사이즈 디지털 원자합산(A2/A3/A4 프리셋+자유 100×150~500×730), BN=면적 룩업 매트릭스. **사이즈 차원(#13)은 동일(좌표)이나 price_gbn이 가격엔진을 라우팅.** `pricing_model` enum **5종으로 확장**: 면적매트릭스(BN real_price)·digital원자합산(PR digital_price)·완제SKU개당가(tmpl)·variant템플릿(vTmpl)·구간가(tiered). 메모리 `dbmap-digitalprint-atomic-formula-unbuilt`(digital 원자합산형) 정합.
  - **★book2025 = 표지/내지 role-paired 가격 (P-2):** 책자 `book2025_price`가 표지·내지를 *독립 산정*(reqBody CVR_MTRL_CD/INN_MTRL_CD·CVR_CLR_CNT/INN_CLR_CNT·PAGE_CNT·PRN_CNT). 단가축 분리: F_CVR_MTRL_AMT vs K_INN_MTRL_AMT·G_CVR_PRINT vs L_INN_PRINT. = usage_cd role(#1 P-2)이 *가격기여역할로 전파*된 증거(표지가/내지가 별 price_role). 규칙: 수량=볼륨디스카운트 곡선·페이지=선형가산(Δ1,120/page)·표지/내지 도수 독립가산. pricing_model=book2025(cover/inner 분리+페이지선형+수량볼륨)로 6번째 라우팅.

- **★ST 확장 — die-cut/판/정가 3가격엔진 라우팅 (v5.0·S-6):** 같은 ST 안에서 가격엔진이 형태별 3종으로 분기(reverse §0.6·§3 실측): ① **die-cut**(자유사이즈·칼틀·`digital_price` 산정형 — 좌표+THO 칼틀 PCS 전달, BN 면적매트릭스와 별·PR digital 합류) ② **판(板)**(고정 판규격 140X200/A4·장단위·`vTmpl_price` 템플릿형 — 완제SKU에 가까움·GS tmpl/vTmpl 합류·STPADPN 실측) ③ **정가**(STPADIY `tmpl_price` 고정). pricing_model enum이 기존 6종(면적/digital/tmpl/vTmpl/tiered/book2025)으로 ST 3종 전부 흡수 — **신축 불요**(라우팅 키=price_gbn·형태가 분기). die-cut↔판 차이는 사이즈 모드(#13 자유/고정)와 연동.

- **★AC 확장 — acrylic2025 전용 가격엔진 + 소재/형태별 공식 라우팅 (v7.0·A-6/A-2):** AC 한 카테고리에 3엔진 공존(reverse §0.6 실측): 명찰(vTmpl_price·프리셋 템플릿가)·키링(**acrylic2025_price**·아크릴 전용 면적·두께·소재 산정)·등신대(tmpl_price·완제 템플릿가). **★acrylic2025=[huni-ref] `acrylic-chain-design.md:48·172` PRF_CLR_ACRYL 투명아크릴 공식·면적매트릭스·두께 mat_cd 분기 정합** — 소재/형태별 가격엔진 라우팅: 투명=`PRF_CLR_ACRYL`·미러=`PRF_MIRROR_ACRYL`(거울 별공식·A-2)·코롯토=`PRF_COROTTO_ACRYL`(면적매트릭스·A-3)·카라비너=`PRF_CARABINER_ACRYL`(고정가·접합완제). pricing_model enum이 기존 6종에 **acrylic2025(아크릴 전용 면적·두께·소재 산정)** 추가 = ST die-cut/판/정가(S-6)·GS tmpl/vTmpl/tiered(G-7)·PR digital(P-6)와 같은 "형태/소재별 전용 가격엔진(2025세대)" 패턴 — **신축 불요**(라우팅 키=price_gbn). **검증 필요분: acrylic2025 산정식·prc_typ .02 정합([huni-ref] Q-ACR-7 미해소·면적 개당단가는 단가형 .01 원칙) → dbmap 가격 트랙.**

### 12. 인쇄방식/생산 레시피 축 (Print-Method Recipe) ✅ — distinct(조건부) D-7

- **identity:** 인쇄방식(디지털/실사/UV/옵셋/실크)이 *가능 공정·파일포맷·생산팀·기초데이터를 게이팅*하는 최상위 레시피 축.
- **entities(그릇):** `PrintMethod`(레시피) — 후니 PROC_000002~6. (RP는 자재코드에 인코딩, 후니는 1급 트리.)
- **attributes:** `method_cd`(디지털/실사/UV/옵셋/실크), `allowed_processes`(가능 공정 부분집합), `file_formats`(PDF/JPG/PDF+커팅AI), `team`(생산팀).
- **relationships:** PrintMethod → ProcessMember(**gates** 가능집합), → 파일포맷, → 생산팀, → 자재(RP 인코딩 중첩 — 수성/라텍스 자재 facet, D-7 양면 표현), → **Material pool(gates 가능 자재 부분집합 — PR P-7 신규 간선)**.
- **constraint & cascade:** 1상품=1인쇄방식(process-recipe §1) → 가능 공정 게이팅. UV→레이저커팅→아크릴가공 시퀀스. **양면 표현(HARD):** 인쇄방식은 (a) 자재 facet 인코딩(RP) 또는 (b) 1급 게이팅 축(후니) — 강제 분리 금지(메모리 `dbmap-print-method-not-absolute-axis`).

- **★PR 확장 — 인쇄방식 분기 + 자재풀 게이팅 (v4.0·P-4/P-7):**
  - **★자재풀 게이팅 (P-7·새 관계 간선):** 윤전 책자(PRBKYPR) 내지는 *윤전전용 백색모조*(PTT=YWM·RXYWM080)만 사용 — 인쇄방식이 자재코드에 *인코딩*될 뿐 아니라 **가능 자재 부분집합을 게이팅**(윤전→YWM pool·토너/인디고→다른 pool 추정). process-recipe §1 "1상품=1인쇄방식이 가능 공정 부분집합 결정"의 *자재판*. D-7 "자재 facet 인코딩"을 *gates-material-pool* 관계로 강화. 토너/인디고/리소 자재풀 차이는 unobserved → gap/validation.
  - **인쇄방식 = pdtCode 분기 (P-4):** 같은 책자가 윤전(PRBKYPR `book2025`)·토너(PRBKO* 소량즉납)·인디고(PRIDPRT 낱장)·리소(PRPORSO 별색)별 별 pdtCode. 인쇄방식이 자재풀·최소수량·가격모델 동반결정 → 단순 옵션화 위험(P-4 정책 권고: 인쇄방식=별 pdtCode). RP는 인쇄방식을 옵션 아닌 상품으로 정규화(GS 코스터 소재분리·TP 디자인X분리 동형). 후니 도메인 인쇄방식 5종(PROC_000002~6)에 윤전/토너/인디고/리소 매핑은 갭분석가.

- **★ST 확장 — 인쇄방식 4계열 횡단 합류 (v5.0·S-5·PR P-4/P-7 동형):** ST가 인쇄방식을 **일반(디지털 STTH*/STCU*)·UV(STPAU*)·DTF 열전사(STPAD*)·후지(STBP*)** 4계열로 pdtCode prefix 분기(reverse §0.5·§3 실측). 인쇄방식이 **자재(DTF=DTF전용필름 단일 PXPUF003)·도수노출(DTF=dosuView=N 숨김)·화이트강제(DTF PRT_WHT ESN_YN=Y)·가격엔진(DTF=vTmpl_price)** 을 동반결정 = PR 윤전→YWM 자재풀 게이팅(P-7)의 ST판. **★PR과 합류·신축 아님:** "인쇄방식=상품분기 + 자재/도수/가격 게이팅"은 PR(P-4)·ST(S-5) 두 카테고리 횡단 패턴 — #12 인쇄방식레시피 축이 이미 담음(가능 자재풀·공정·파일·팀 게이팅). 후니 PROC_000002 UV(`db-domain-structure-live.md:159` `변형` enum)·DTF/후지는 도메인 인쇄방식 enum 확장(갭분석가). ST는 UV가 별 인쇄방식(STPAU*)이자 PROC_000002 변형 — 후니 인쇄방식 트리 매핑 검토.

- **★CL 확장 — 인쇄방식 "상품내 옵션" 인코딩(삼면 표현) (v6.0·C-6):** ST/PR은 인쇄방식을 *상품분기*(pdtCode prefix·S-5/P-4), BN은 *자재 facet*(수성/라텍스 MTRL_CD 인코딩·A-4)으로 표현했으나, **CL은 인쇄방식을 *한 상품 안 옵션 차원*으로 인코딩** — 가격캡처 `ORD_INFO.PRINT_TYPE`(PTP_DTF 초기→PTP_DIR 변경)가 MTRL_CD/CUT/DOSU와 동급 차원. `apparel_info.print_type` 3종(PTP_DTF DTF열전사·PTP_DIR 직접인쇄·PTP_SLK 날염/실크) 택1. **즉 #12 인쇄방식레시피 축이 (a) 자재 facet 인코딩(BN 수성/라텍스) (b) 상품분기 pdtCode(ST/PR 윤전/UV/DTF) (c) 상품내 옵션 차원(CL DTF/직접/실크) 세 표현을 가짐**(양면→삼면 표현 확정). 의류 인쇄방식(전사/실크/나염/DTF)은 도메인상 공정#2 별색/특수인쇄 family와도 연결(실크=별색 spot color·DTF=화이트언더베이스 동반·S-7 동형). 후니 인쇄방식 5종 트리(PROC_000002~6)에 의류 DTF/전사/실크 매핑은 갭분석가. **메타모델 정합:** 인쇄방식이 *가능 자재풀*(DTF→DTF전용·실크→Pantone 별색 활성)·*가격*(이 캡처는 DTF=DIR 동일 19900)을 게이팅 — #12 게이팅 lifecycle 유지(인코딩 위치만 카테고리별 상이).

### 13. 사이즈 축 (Size) ✅ — 기초코드+제약 복합(명시)

> A-2/A-3/A-5에서 횡단 참조되어 별도 명시(기초코드 #6 + 제약 #5의 복합이나 1급 취급).

- **identity:** 재단치수(고객 선택 완성품 치수) — 프리셋 enum + nonspec 자유입력 범위.
- **entities(그릇):** `SizePreset`(enum) + `NonspecRange`(범위 제약).
- **attributes:** `div_nm`(프리셋 — 5000X900·900X900), `cut_wdt/hgh`(재단), `work_size`(=재단+CUT_MRG 4mm 자동), `nonspec_min/max`(0~5000), `user_input`(SIZE_0 자유).
- **relationships:** Size → 가격(면적 SizeMatrix2D, D-6), Size ↔ Addon(match — 롤업, D-3), Size = 형상 흡수(어깨띠 폭좁고 김 — 별도 shape축 없음, A-3).
- **constraint & cascade:** 프리셋 선택→cut 룩업 / 직접입력→USER 수치(min/max 범위). 작업=재단+4mm. **도메인 경계:** size=재단치수 ≠ plate(작업/전지 판형, entity-semantic #1/#6 별개 축). 형상은 size 프리셋으로 흡수(shape 1급화=오버피팅 거부).
- **★GS 확장:** 사이즈 프리셋이 *복합 차원*일 수 있음 — 파우치 "13인치 가로형/세로형"(기종 × 방향), 노트 "여권형/Medium"(형상 캐스케이드). THO_CUT 형상↔사이즈 1:1(메모리 round-3 K컨펌 "도무송 형상=size 칼틀 1:1" 동형). 폰케이스 기종 enum(GSCAPHN, unobserved)은 사이즈 프리셋의 *대규모 enum* — 별도 "기종 축" distinct 거부(facet, G-3): 기종=사이즈/칼틀 프리셋의 대규모 인스턴스일 뿐 고유 lifecycle 없음.
- **★PR 확장 (v4.0·P-6/P-9):** ① **같은 좌표·다른 가격엔진 (P-6):** 포스터(A2/A3/A4/B3/B4 프리셋 + MIN/MAX_CUT 자유 100×150~500×730·NO_STD_ABL_YN=N)와 BN 현수막이 같은 사이즈 차원(좌표)이나 가격엔진만 분기(digital_price vs 면적매트릭스·#11). 사이즈 입력 구조는 동일·가격기여역할(#11)에서 라우팅. ② **출판판형 프리셋 (P-4):** 크라운판/신국판/A4·B5·A5세로형 = 책자 특화 사이즈 프리셋. ③ **레이저커팅 칼틀 (P-9):** THO_LAS 칼틀 형상 = 사이즈 프리셋(형상↔칼틀 1:1·GS THO_CUT 동형). 칼틀값 unobserved.
- **★ST 확장 — 형상축(#17)과의 분리 + 칼틀이 사이즈를 겸함 (v5.0·S-1/S-2/S-6):**
  - **★형상↔사이즈 분리(#17 distinct의 사이즈측 함의):** BN/GS/TP/PR에선 형상이 *사이즈 프리셋과 1:1*(어깨띠·하트·티켓)이라 사이즈축이 형상을 흡수했으나, ST는 **한 형상이 다수 칼틀/사이즈를 span**(CL 원형 → THO_DFT/CL001~CL010 + CLFRE 자유원형). 즉 사이즈축은 형상의 *하위*(형상이 어느 사이즈 프리셋 집합인지 게이팅) — 형상은 별 분류축(#17)으로 분리. **★[HARD] 사이즈축은 형상 자체를 담지 않음(원형이라는 사실을 매 사이즈에 중복 인코딩 금지)** — 형상=상위 분류(#17)·사이즈=치수 프리셋(#13)·칼틀=형상별 사이즈 프리셋(THO_DFT 공정#2). `entity-semantic-model.md:39` G-SK-2 "size축에 형상 enum drop·어느 축에도 없음"이 분리 필요를 결함으로 확증.
  - **★칼틀이 사이즈를 겸함:** 정형 형상(SQ/CL/RC)은 `THO_DFT` 프리셋 칼틀이 사이즈를 고정(CL001=10X10·RC001=40X20). 자유형(FR)은 자유사이즈(nonspec·디자인 외곽 기준). 즉 형상#17이 *사이즈 입력 모드*(프리셋 칼틀 vs 자유)를 게이팅. 사이즈 차원은 동일(좌표)이나 입력 게이트가 형상에 종속.
  - **die-cut vs 판 사이즈 모드 (S-6):** die-cut(자유사이즈+칼틀·digital_price)·판(고정 판규격 140X200/A4·vTmpl_price) — 사이즈 차원이 자유범위(die-cut)/고정프리셋(판)으로 갈리고 가격엔진(#11)이 라우팅. PR P-6(규격 vs 면적)·GS 완제SKU 동형.

---

- **★CL 확장 — 표준 의류 사이즈 grid + GBN + size×color 매트릭스축 (v6.0·C-2/C-8):** ① **표준 의류 사이즈 grid:** `apparel_info.size_info`(XS~3XL·120~150 child) = 표준 의류 사이즈 enum 프리셋(BN 면적·GS CUT프리셋·ST 형상칼틀과 다른 *표준 의류 치수 grid*). 의류 사이즈가 MTRL_CD 첫자리 인코딩(1xx=S·2xx=M·3xx=L)·size_color_info에서 (사이즈,색)→단일 MTRL_COD. ② **★사이즈는 색상과 2D 매트릭스축(의류 variant 핵심):** GS는 사이즈가 단일 차원(CUT 프리셋·G-4 ③)이었으나 CL은 *사이즈×색 2D 매트릭스*의 한 축 — 셀가용성(#5)·셀→MTRL_COD(자재#1). 사이즈축 자체는 #13(치수 프리셋)이며 색과의 2D 조합은 자재#1 SKU matrix + 제약#5(별 "의류 variant 축" 거부·#1 CL 확장 참조). ③ **GBN(adult/child):** 사이즈 enum의 연령 분류 속성(#6·단체티만 child 활성). **형상축(#17)과 무관** — 의류는 형상 enum 부재(정형 의류 실루엣은 원단/형태 pdtCode 분기·shape_info 없음). 사이즈축이 의류 표준 grid를 깔끔히 담음(distinct 신축 불요).

## II-b. GS 신축 (완제/입체 굿즈가 드러낸 distinct 축) — 발굴 v2.0

### 14. 본체 형태가공 축 (Body Form-Assembly) ✅ — distinct D-10 (GS 신축)

- **identity:** 평면 인쇄물을 *입체 완제 굿즈로 조립/봉제/형성*하는 공정 — 본체 형태 자체를 생성. 일반 후가공(기존 본체에 작업 가함, #2)과 lifecycle 구별: 형태가공이 없으면 본체가 *존재하지 않음*(파우치 = 가공 없으면 평면지).
- **entities(그릇):** `FormAssembly` — `{assembly_cd, assembly_type, consumes_material, direction_variant}`. RP=PCS_COD `PDT_WRK`(제품가공)·`FLX_ZIP`(지퍼가공).
- **attributes:**
  - `assembly_cd`(RP=PDT_WRK PUBOK 파우치가공·PKT01 마이크텍조립 / FLX_ZIP ZPH01 지퍼).
  - `assembly_type`(봉제/조립/지퍼/접합).
  - `consumes_material`(지퍼=부자재 지퍼 소비 — #1 consumes FK).
  - `direction_variant`(지퍼 세로형/가로형 — DTL variant).
- **relationships:**
  - FormAssembly → Product(belongs-to, 완제 굿즈 본체 형성).
  - FormAssembly(지퍼) → Material(**consumes** — 지퍼=부자재, #1·#2 동형 아일렛 패턴).
  - FormAssembly → 생산형태(#15, C 완제품/입체에서만 활성).
  - FormAssembly → ProcessMember(seq — 인쇄→재단→형태가공 순서).
- **constraint & cascade:** 본체 정체와 결합된 *필수* 공정(파우치는 PDT_WRK 없으면 미완성). 방향 variant(세로/가로)는 옵션. **distinctness 근거:** BN(평면 배너) 전무·GS(파우치·마이크텍) 다수 → 단일상품 아님(GSPUFBC·GSTGMIC 2상품 + 효자손/폰케이스 추정). 일반 후가공이 "본체에 작업"인 반면 형태가공은 "본체를 *생성*" → #2가 왜곡 없이 못 담음(distinct 정당). 후니 굿즈 BOM "평면→입체 조립 단계" 동형(메모리 round-22 본체 자재 BOM).

### 15. 생산형태 축 (Production Type) ✅ — distinct D-9 (GS 신축, 카테고리와 직교)

- **identity:** 상품의 *생산 구조 분류* — 완제품 / 반제품(셋트) / 통합 / 기성 / 디자인. 카테고리(기능 트리)와 **직교**하며, 본체 모델링 방식(#1·#4)·형태가공(#14)·자재 usage(#1)를 *governing*하는 상위 분류축.
- **entities(그릇):** `ProductionType` — `{prd_typ, body_model, set_structure}`. 도메인 권위 = entity-semantic §4 C-9 3구조.
- **attributes:**
  - `prd_typ`(A 통합 / B 셋트·반제품 / C 완제품·단일 / 기성 / 디자인).
  - `body_model`(A·B = 본체=자재행 parent+usage_cd / C = 본체=완제 SKU 항목 DIR_MTR).
  - `set_structure`(B = 표지/면지 sub_prd 빈껍데기 + sets 연결 / A·C = sets 0).
- **relationships:**
  - ProductionType → Product(classifies — 1상품 1생산형태).
  - ProductionType → 본체 모델링(governs #1/#4 — C 완제품→DIR_MTR SKU, A/B→자재행).
  - ProductionType → FormAssembly(#14 — C 입체 굿즈에서 형태가공 활성).
  - ProductionType → 자재 usage(#1 — B 셋트=표지/면지 다중 usage, A 통합=단일 캐스케이드).
  - ProductionType ⊥ Category(직교 — 같은 "노트" 카테고리에 통합책자[A]·하드커버[B] 공존).
- **constraint & cascade:**
  - C 완제품(굿즈·낱장·대형): 내지/표지 개념 없음, 본체=완제 SKU(GS DIR_MTR), 형태가공 가능.
  - B 셋트(하드커버·포토북): 표지/면지=반제품 sub_prd, sets 연결, 자재 권위=parent+usage_cd(sub_prd 9속성 0행=정상).
  - A 통합(일반 책자·노트): 내지/표지 단일행 캐스케이드.
  - **distinctness 근거:** 도메인 권위(entity-semantic §4 "C-9 해결 — 생산방식 3구조 A/B/C 확정·11군 매핑")가 1급 축으로 확정. GS가 C 완제품(텀블러/코스터/효자손)·A 통합(노트)을 다수 노출해 **카테고리와 직교**임을 입증(같은 카테고리에 A·C 공존). 메모리 `dbmap-grid-binding-round15` "생산형태 3분류 × 그릇 binding"·"라이브 prd_typ_cd≠생산형태(오모델)" 정합 — 카테고리/템플릿이 왜곡 없이 못 담음(생산형태는 그 둘을 *governing*). distinct 정당.
  - **★후니 갭 경고:** 메모리 round-15 "라이브 prd_typ_cd가 생산형태와 불일치(굿즈/문구=.03기성·디지털/실사/아크릴=.04디자인 오귀속)" — 후니 라이브가 이 축을 *오모델링* 중. GS가 RP 정합 모델 제공.

---

## II-c. TP 신축 (디자인템플릿이 드러낸 distinct 축) — 발굴 v3.0

### 16. 디자인 입력 채널 축 (Design-Input Channel) ✅ — distinct D-11 (TP 신축, 본체 옵션과 직교) ★directive 핵심

- **identity:** 상품의 디자인을 *어떻게 입력받는가*(에디터 채널 + 입력방식). 본체(자재·공정·사이즈·수량)와 **직교**하며 가격 0 — 본체 옵션 트리(`pdt_pcs_info`)를 오염시키지 않고 `item_gbn` + `product_option.option` 플래그 묶음으로 인코딩. 입력채널이 *디자인수 산정·템플릿 자산 노출·VDP 가능여부*를 게이팅하는 lifecycle 보유.
- **entities(그릇):**
  - `DesignInputChannel` — `{channel, editor_flags, ord_cnt_source}`. RP=`product_option.option`.
  - `TemplateAsset`(종속 — T-A) — 에디터가 로드하는 디자인 시안 카탈로그. **★#4 완제SKU 템플릿과 별 엔티티**(가격0·디자인 리소스). RP=`koi_template_resource_id`/`koiOption[]`.
- **attributes(DesignInputChannel):**
  - `channel`(item_gbn — `vDigital_item` KOI / `edicus_item` Edicus SDK·VDP / `offset2023_item` 없음·PDF).
  - `use_koi_editor`·`use_rp_editor`(자체 에디터 사용 Y/N).
  - `use_template_download`(기성 디자인 시안 갤러리 제공 — TemplateAsset 노출 게이트).
  - `use_pdf`(PDF 직접 업로드 허용).
  - `ord_cnt_source`(`usePDFordCnt`/`useEditorOrdCnt` — 디자인수(건수) 산정 출처 = PDF/에디터, 수량모델#10 ORD_CNT 게이팅).
  - `vdp_capable`(Edicus openVdpViewer/setVariableData 능력 — T-B facet).
- **attributes(TemplateAsset):** `template_resource_id`(RP koi_template_resource_id), `asset_options`(koiOption[]), `price=0`(디자인 입력 무료).
- **relationships:**
  - DesignInputChannel → Product(classifies — 1상품 1입력구성).
  - DesignInputChannel → TemplateAsset(provides — 에디터 디자인 시안, T-A. **≠ #4 완제SKU**).
  - DesignInputChannel → QuantitySlot(#10, **gates** — ord_cnt_source가 ORD_CNT "디자인 수(건수)" 출처 결정).
  - DesignInputChannel ↔ PrintMethod(#12, **상관** — offset2023↔에디터0·PDF전용 동반 경향이나 결정 아님: vDigital이라도 KOI/PDF 갈림).
  - DesignInputChannel ⊥ 본체 옵션(자재#1·공정#2·사이즈#13·옵션#3 — 직교·가격 0).
- **constraint & cascade:**
  - 입력채널 구성이 TemplateAsset 노출(use_template_download)·VDP(channel=edicus)·디자인수 산정(ord_cnt_source)을 게이팅.
  - **distinctness 근거:** ★비-TP 트윈 직접 대조 — 같은 캘린더가 TPCLSTD(TP)=KOI+템플릿 / HLCLSTD(비-TP)=PDF전용, **자재/사이즈/후가공/가격 완전 동일·입력채널만 차이**(reverse §0.1). 가격 0(TPCLWLB PRICE 주체=PRT_DFT 인쇄·에디터/템플릿 PCS=0, reverse §3). huni-widget RedEditorSDK 45메서드 + Edicus 브릿지(`sdkOpenEditor`/`fnKoiEditor`/`fnRpEditor`·cmd create-design-project) = 후니 위젯도 동일 에디터 채널 1급 통합 계약 보유(`seed-redprinting-sdk-analysis.md`·`editor-bridge-protocol.md`). 옵션#3=본체속성·공정#2=본체작업·템플릿#4=완제번들 어느 것도 "디자인 입력 메커니즘"을 왜곡 없이 못 담음 → distinct 정당. 오버피팅 검토: TP 단일이나 비-TP 트윈 대조 + 전 카테고리(BN PDF·GS edicus_item)가 입력채널 값 보유 + 후니 위젯 동형 → 단일상품 아님.
  - **★후니 갭(vessel 단계):** 후니 t_*에 "디자인 입력 채널" 그릇 **부재 가설**(vessel-gap 1순위). 후니 위젯이 Edicus 어댑터를 *코드 계약*으로만 가지므로(huni-widget) 입력채널 메타(에디터 타입·템플릿 리소스 ID·VDP 변수 스키마·디자인수 산정 출처)를 담을 DB 그릇 설계가 vessel 과제. 갭분석가가 라이브 information_schema에서 대응 컬럼 유무 확인.
  - **도메인 경계(HARD):** 입력채널 ≠ 인쇄방식(#12) — 입력은 *주문측 디자인 UX*, 인쇄방식은 *생산측 공정 게이팅*. 상관하나 동일 아님. TemplateAsset(디자인 시안·가격0) ≠ 템플릿#4(완제SKU·주문단위) — 같은 단어 다른 의미(T-A).
- **★AC 확장 — ACTPKEY 키링 템플릿 = TemplateAsset (v7.0·A-9·T-A 동형):** "아크릴 키링 템플릿"(ACTPKEY)이 AC 카테고리에 속하나 *에디터 디자인 자산형*(키링 디자인 프리셋·useTemplateDownload·koi_template_resource) = **#16 TemplateAsset**(디자인 시안·가격0)이지 #4 완제SKU 아님. AC 카테고리 소속(카테고리#7·다중분류 가능)은 자산 유형과 직교 — T-A "템플릿 이중의미 분리"[HARD] 동형. **후니 매핑 시 ACTPKEY를 `t_prd_templates`(완제SKU)에 적재 금지**(가격0 디자인 리소스를 주문단위로 오모델). 검증 필요분: 자산 카탈로그·VDP unobserved → gap/validation.

---

## II-d. ST 신축 (스티커가 드러낸 distinct 축) — 발굴 v5.0 ★16축 포화 붕괴

### 17. 형상 축 (Shape) ✅ — distinct D-12 (ST 신축, 사이즈와 분리·#13 게이팅) ★directive #1·포화 최초 붕괴

- **identity:** 인쇄물의 *외곽 형상*(사각 SQ / 원형 CL / 타원 EL / 사각라운드 RC / 자유형 FR)을 *사이즈와 분리된 전용 enum 슬롯*으로 관리하는 분류축. 형상이 ① 칼틀(THO_DFT) enum의 부분집합과 사이즈 입력모드(프리셋 vs 자유)를 게이팅 ② 자유형(FR)이면 자유칼선(THO_GRA)을 강제 ③ 상품 분기(원형=STTHCIC)와 한상품 옵션(STDCFBR 5형상)을 모두 인코딩. **사이즈(#13 치수)의 상위 분류** — 형상이 1:多로 칼틀/사이즈를 span(기존 BN/GS/TP/PR의 형상=사이즈 1:1 흡수 전제를 깸).
- **entities(그릇):**
  - `Shape` — `{shape_cd, shape_name, cutting_mode_gate, size_mode}`. RP=`option_info.shape_info` 전용 슬롯.
- **attributes(Shape):**
  - `shape_cd`(SQ 사각/CL 원형/EL 타원/RC 사각라운드/FR 자유형 — RP shape_info COD).
  - `cutting_mode_gate`(FR→THO_GRA 자유칼선·SQ/CL/RC→THO_DFT 프리셋칼틀 — 형상이 칼선 메커니즘 게이팅).
  - `size_mode`(정형→프리셋 칼틀 enum(사이즈 고정)·자유형→nonspec 자유사이즈 — 형상이 사이즈 입력모드 게이팅).
  - `encoding`(상품분기 1:1 STTHCIC원형 / 한상품 N형상 옵션 STDCFBR 5형상 — 인코딩 유연).
- **relationships:**
  - Shape → Product(**classifies** — 상품분기 1:1 또는 한상품 N형상 옵션).
  - Shape → SizePreset(#13, **gates** — 형상별 칼틀/사이즈 프리셋 부분집합: CL→CL001~CL010·RC→RC001~RC025).
  - Shape → ProcessMember(#2 칼선, **gates** — FR→THO_GRA(자유 도무송)·정형→THO_DFT(프리셋 칼틀)).
  - Shape ⊂ EnumValue(#6 기초코드, 값 도메인 공급).
- **constraint & cascade:**
  - 형상 선택 → 칼선 메커니즘(THO_GRA/THO_DFT) 강제 + 사이즈 입력모드(프리셋/자유) 게이팅.
  - **distinctness 근거(적대 판정):** ★사이즈축(#13)이 형상을 *1:1 칼틀로 흡수*해온 전제(BN 어깨띠·GS THO_CUT·TP M/I·PR 카드형 전부 형상=사이즈 프리셋 1개)가 ST에서 **1:多로 깨짐** — 전용 `shape_info` 슬롯·CL 형상 1개 ↔ CL001~CL100 칼틀 10+종 span·STDCFBR 5형상 superset(reverse §0.1·§0.2). 사이즈축으로 형상 표현 시 "원형이라는 사실"을 매 사이즈 프리셋에 중복 인코딩(정규화 붕괴). **★후니 KB 결정적**(`entity-semantic-model.md:39` "size축에 형상 enum drop(G-SK-2): 도형/치수 enum(원형 25~90mm)이 어느 축에도 없음") = 사이즈축이 형상을 *왜곡 없이 못 담음*을 후니 자신이 결함으로 명시 → distinct 정당.
  - **★[HARD] 형상축 적용 경계(오모델 회피):** 형상이 사이즈와 *1:1*이면 사이즈 프리셋에 흡수 표현(BN/GS/TP/PR 유지·형상축 강제 적용 금지)·1:多 분리가 명시 슬롯으로 드러나면 별 분류축(#17 ST·도무송 자유형·칼틀 enum 깊은 상품). 형상축을 모든 상품에 강제하면 1:1 흡수 카테고리에 불필요한 분류 레이어 오모델.
  - **★후니 갭(갭분석가 주목):** 후니 t_*에 "형상" 그릇 *부재 확정*(KB G-SK-2 "어느 축에도 없음"). 도형/치수 enum(원형 25~90mm)이 size축에 drop = vessel-gap. 갭분석가가 라이브 information_schema에서 shape 컬럼/테이블 유무 + 형상↔칼틀(완칼 PROC_053 `모양`·반칼 PROC_054 `모양`) 게이팅 그릇 확인. **단 1:1 흡수 카테고리는 size 프리셋 유지.**

---

## 메타모델 핵심 명제 (RedPrinting 정규화 방식 요약)

1. **자재는 합성된다** — MTRL_CD 하나가 소재·색·무게·인쇄방식 4~5축 인코딩(D-2). 분해 표현력 필수(평면화=의미축 drop).
2. **공정은 자재를 소비할 수 있다** — SUB_MTRL_YN 플래그로 순수공정(재단) vs 자재소비공정(아일렛=금속링+타공) 분리(D-2). 후니 [HARD] "옵션=자재+공정 BUNDLE"과 동형.
3. **공정은 파라미터를 갖는다** — 공정 종속 매개변수(줄수·mm·색·수량)는 별도 축(D-4). 옵션·수량과 혼동 금지.
4. **수량은 다중 슬롯이다** — 디자인 건수×인쇄 수량(D-5), 가격기여 메커니즘 다름.
5. **부속물은 본체와 분리된다** — 거치대=독립 SKU(D-1). 템플릿(번들)·옵션과 별개.
6. **제약은 유형화된 어휘다** — disable/force/match/exclude/essential/min-max 6유형(D-3). force=disable의 역방향. 메타모델의 관계 엔진.
7. **가격기여는 횡단 역할이다** — 모든 선택축이 면적/곱수/고정/단가 역할을 가짐(D-6).
8. **인쇄방식이 레시피를 게이팅한다** — 가능 공정·파일·팀 결정(D-7). RP=자재 facet / 후니=1급 축 양면 표현.
9. **UI 런타임은 중립이다** — Vue/jQuery 두 런타임이 단일 base-data 공유(D-8 facet). 메타모델은 표현 독립.
10. **★생산형태가 본체 모델링을 governing한다 (GS·D-9)** — C 완제품(굿즈)→본체=완제 SKU 항목(DIR_MTR), A 통합/B 셋트→본체=자재행. 카테고리(기능 트리)와 직교. BN(평면)·GS(완제) 두 패러다임을 한 메타모델에 통일하는 *governing 축*.
11. **★완제 본체는 자재참조 + SKU 항목 복합이다 (GS·G-1)** — 굿즈 본체(DIR_MTR)가 PCS 항목이자 PRICE 주체. 소재/색/용량/두께가 SKU 라벨에 융합(후니 본체소재 부재 동형) → 분해축 필수(평면 라벨 금지). BN 본체=자재행과 *같은 자재축의 두 facet*(distinct 신축 아님).
12. **★평면→입체 형태가공은 별도 공정 lifecycle이다 (GS·D-10)** — PDT_WRK/FLX_ZIP가 본체를 *생성*(일반 후가공=본체에 작업). 굿즈 특유 distinct 축.
13. **★variant는 3채널로 분산 인코딩된다 (GS·G-4)** — DTL코드(SKU성·다차원 합일)·ATTB(공정 파라미터)·CUT(사이즈 차원). 단일 평면화 금지·기존 축으로 분배. 한 DTL이 자재+사이즈+칼틀+가격 동시 결정(강결합)은 polymorphic option_item 다중 참조로.
14. **★가격모델은 옵션 모델 위에서 라우팅된다 (GS·G-7)** — 면적형(BN)·완제SKU개당가(tmpl)·variant템플릿(vTmpl)·구간가(tiered) 4종. price_gbn=상품 속성, 완제본체 유무가 분기 단서.
15. **★디자인 입력은 본체와 직교한 별 축이다 (TP·D-11)** — 에디터 채널(KOI/Edicus/PDF)이 `item_gbn`+플래그로 인코딩, 본체 옵션 트리와 직교·가격 0. 같은 상품이 TP면 에디터+템플릿, 비-TP면 PDF업로드, 본체/가격 동일(HLCLSTD 트윈). 입력채널이 디자인수·템플릿자산·VDP를 게이팅.
16. **★템플릿은 두 의미다 (TP·T-A) [HARD]** — 완제SKU 번들(#4 주문단위·`t_prd_templates`) vs 에디터 디자인 시안(#16 종속 TemplateAsset·가격0·`koi_template_resource_id`). 같은 단어 다른 의미 → 별 엔티티 분리. 후니 매핑 시 디자인 시안을 완제SKU에 적재 금지.
17. **★usage_cd는 전파되는 역할이다 (PR·P-2)** — 표지/내지(usage.02/.01)가 자재(#1)뿐 아니라 도수(#6)·가격(#11 F_CVR/K_INN)·평량제약(#5 COV_MIN/INN_MAX)으로 role-paired 전파. RP `inner_pdt_*` 평행 스키마=usage 슬롯 물리구현. *별 "역할 축" 아닌* usage_cd 차원의 전파(침묵선택 거부 후 facet 격상).
18. **★접지는 평면 종이의 면가공 family다 (PR·P-1)** — FLD_DFT 7종이 종이를 N면 분할(2단=4면), 면수=파생값(축 아님). 공정#2 family + 접지방식 파라미터(#9) + 접지↔오시 동반 cascade(#5). BN/GS/TP 미발굴 공정 family.
19. **★공정방식이 상품을 가른다 (PR·P-4)** — 인쇄방식(윤전/토너/인디고/리소)·제본방식(무선/스프링/트윈링/스테플러/실제본)·도수(컬러/흑백)를 RP는 개별 pdtCode로 펼침(책자 19상품). 상품분기 vs 옵션화=후니 정책(GS G-2·TP T-4 동류). 인쇄방식이 자재풀(#12 P-7)·가격엔진 게이팅→단순 옵션화 위험.
20. **★PR distinct 신축 0 = 16축 포화 (PR·v4.0)** — 4번째 카테고리(다면/제본/접지)가 새 관리축 0개 도입. 9 fragment 전부 기존 축 facet/family/cascade. 모델이 RedPrinting 카탈로그 shape를 견딤(오버피팅 회피의 정직한 결과·강한 검증 신호).
21. **★형상은 사이즈와 분리된 분류축이다 (ST·D-12·#17·포화 붕괴)** — `shape_info` 전용 슬롯(SQ/CL/EL/RC/FR)이 사이즈를 1:1 흡수해온 전제를 깸(CL 형상↔CL001~100 칼틀 1:多·STDCFBR 5형상 superset). 형상=사이즈 상위 분류·칼선/사이즈모드 게이팅. **단 1:1 흡수 카테고리(BN/GS/TP/PR)는 사이즈 프리셋 유지(형상축 강제 금지)** — 후니 KB G-SK-2 "형상 어느 축에도 없음" 확증.
22. **★ST 칼선/재단입자는 공정 family·점착은 자재 합성이다 (ST·v5.0)** — 칼선(THO_GRA/THO_DFT)·반칼/완칼(CUT_DFT)은 후니 KB(PROC_053/054/055·도무송)로 공정#2 멤버 확정(신축 거부)·점착/내후(강접/리무버블/옥외/저온/자석/메탈/한지)는 자재#1 합성 차원(색상/두께→material 동형). 인쇄방식(UV/DTF/후지)은 #12 PR 윤전/토너 합류. **5번째 카테고리가 distinct 1종(형상)만 추가 = 모델은 카테고리 증거에 정직(포화도 진화도 증거 강제).**
23. **★의류 variant는 GS variant의 2D 일반화 facet이다 (CL·v6.0·#18 부결·재포화)** — 의류 본체 size×color 2D 매트릭스(→단일 MTRL_COD)는 GS variant(G-4 1D-per-channel)의 2D 일반화·자재#1 SKU matrix(G-1 본체 SKU 동형)·셀가용성=제약#5(ST disable 227=S-8 정점의 2D판). item_gbn=clothes2025=구현 discriminator(정책패턴·축 아님)·apparel_info=구현 컨테이너 뷰(여러 축 담음·D-8 동형). 인쇄방식=#12(상품내 옵션 인코딩=삼면 표현)·인쇄위치=공정#2 멀티슬롯·Pantone=별색 공정#2·GBN=사이즈#13/#6 하위. **6번째 카테고리가 distinct 0 = 17축 재포화(PR 패턴 반복)** — 의류처럼 전용 그릇·전용 모델 가진 가장 이질적 카테고리조차 17축 무손실 흡수(모델 안정성 재확인). ★[HARD] MTRL_COD를 {fabric/PTT, color/CLR, size/WGT}로 분해(G-1 동일 처방·평면 SKU 라벨 금지).
24. **★가공방식 그룹핑은 공정+자재합성+옵션cascade의 bundle facet이다 (AC·v7.0·A-8·#18 부결·재포화)** — `option_info.production_method`(일반 MTG_DFT/라미 MTG_LAM)·GRP_OPTION_CD가 자재행을 가공방식 그룹으로 묶으나 세 기존 축으로 무손실 분해: ① 라미네이션=공정#2(합지 family) ② 라미 결과(라미된 자재행)=자재#1 합성(D-2·두께 3T→2T+1T·홀로그램 surface-finish) ③ 그룹핑(production_method→호환 MTRL_CD subset 게이팅)=옵션#3 polymorphic cascade(G-4 채널·CL 매트릭스 동형). **★ST 형상(#17)과 정반대로 부결** — 형상은 후니 KB G-SK-2 "어느 축에도 없음" 결함이 *기존 축이 왜곡 없이 못 담음*을 강제(distinct), 가공방식은 기존 축(공정#2·자재#1·옵션#3)이 *왜곡 없이 담음*(라미=공정 멤버 이미 수용·KB 결함 없음)이라 facet. **7번째 카테고리가 distinct 0 = 17축 재포화(PR·CL 패턴 반복)** — 가장 강한 새 후보 A-8조차 무손실 흡수. 두께(3T/5T)=자재#1 WGT facet([huni-ref] mat_cd 통합 동형)·소재variant(글리터/거울/자개)=자재#1 surface-finish facet(ST S-4 동형)·입체/스탠드=분산 facet(받침=부속물#8·두께=자재·양면=옵션·조형=공정·생산형태#15/형태가공#14 둘 다 아님)·받침/고리(KR/CN/CR ST 공유)=부속물#8(단일 부자재 마스터 시사)·acrylic2025=가격#11 라우팅(소재/형태별 공식)·명찰 PET+합지=자재#1+공정#2(G-1/CL 라벨 융합)·ACTPKEY=#16 TemplateAsset(T-A 이중의미).

> **도메인 사실 준수 체크(HARD):** 별색=공정(D-2/#2) · 본체색=자재 CLR(D-2) · 판걸이수=앱계산 DB미저장(D-4) · UV변형=공정파라미터 not print_side(#2) · size≠plate(#13) · **형상=별 분류축(#17 ST 1:多)·1:1이면 사이즈 흡수(BN/GS/TP/PR)** · **생산형태⊥카테고리(#15)** · **완제 본체=자재 facet not 신축(#1)** · **두께=자재(#1 GS 장패드 4T)** · **디자인 입력채널⊥본체옵션(#16·가격0)** · **PRT_WHT=공정 not 도수/자재(#2·T-E·S-7)** · **템플릿 자산≠완제SKU(#4/#16 분리·T-A)** · **표지/내지=usage_cd 슬롯 not 신축(#1·P-2)** · **접지 면수=파생값 not 차원(#2·P-1)** · **page_rule=내지 페이지(수량#10 슬롯+별 엔티티·P-3)** · **digital_price≠면적매트릭스(같은 좌표·다른 엔진·#11·P-6)** · **반칼=PROC_054/완칼=PROC_053/스티커완칼=PROC_055=공정 멤버 not 별 재단입자 축(#2·S-3)** · **점착/내후=자재 합성 차원 not 별 자재계열(#1·S-4)** · **의류 본체색=자재 CLR not 별색(#1·C-2)** · **의류 size×color matrix=사이즈#13×색상 Cartesian+셀가용성#5 not 별 의류variant축(#1/#5·C-2/C-3·#18 부결)** · **item_gbn=구현 discriminator not 관리축(정책패턴·C-2/C-5)** · **의류 Pantone=별색 공정 not 자재/도수(#2·C-7)** · **인쇄위치=공정 멀티슬롯 not 별 축(#2·C-4)** · **GBN=사이즈 하위속성 not 별 분류축(#13/#6·C-8)** · **두께=자재 WGT 차원 not 별 두께축([huni-ref] mat_cd 통합·#1·A-1)** · **소재 surface-finish(글리터/거울/자개)=자재 합성 차원 not 별 자재계열(#1·A-2·ST S-4 동형)** · **입체/스탠드=분산 facet[받침=부속물#8·두께=자재·양면=옵션·조형=공정] not 별 3D축·생산형태#15/형태가공#14 아님(A-3)** · **가공방식 그룹핑(일반/라미)=공정#2(라미)+자재#1 합성+옵션#3 cascade not 별 그룹핑 슬롯 축(#18 부결·A-8)** · **거울 별 가격공식=#11 라우팅 not 자재분류(A-2/A-6)** · **명찰 본체=PET 자재 not 상품명 아크릴·합지=공정(#1/#2·A-7·G-1 동형)** · **ACTPKEY=#16 TemplateAsset not 완제SKU#4(A-9·T-A)**. 전부 entity-semantic-model L3(C-9 생산방식·usage_cd 7종·page_rule·G-SK-2 형상갭·variant 분해)·process-recipe-tree L2(접지/제본/인쇄방식 레시피)·pdf-domain-knowledge(반칼/완칼/도무송 공정·Case2 스티커 레시피) 정합.

> **GS 통합 과잉일반화 거부 기록:** ① "완제 본체 SKU" = 자재축 facet(distinct 거부 — BN/GS 같은 자재참조). ② "본체 소재 pdtCode 분리" = 자재+카테고리 복합 facet(distinct 거부 — RP 카탈로그 정책일 뿐). ③ "variant 3채널" = 기존 옵션/공정파라미터/사이즈로 분배(distinct 거부). ④ "기종 enum"(폰케이스) = 사이즈 프리셋 대규모 인스턴스(distinct 거부). **distinct 승격 = 생산형태(#15)·본체 형태가공(#14) 2종만**(BN·GS 둘 다 견디는 governing/lifecycle 보유).

> **TP 통합 과잉일반화 거부 기록:** ⑤ "템플릿 자산" = D-11 입력채널 리소스 facet(distinct 거부 — D-11 종속·단 템플릿#4와 이중의미 분리). ⑥ "VDP" = 입력채널 데이터바인딩 facet × 수량#10(distinct 거부). ⑦ "페이지계층 INN_PAGE" = 수량모델#10 슬롯 + 제약#5(distinct 거부). ⑧ "형태 variant"(M/I/보딩·탁상/벽걸이) = 사이즈#13+칼틀#2(distinct 거부 — GS THO_CUT 동형). ⑨ "특수인쇄 PRT_WHT/PRT_MAG·미싱/넘버링" = 공정#2(+넘버링은 VDP 가능·distinct 거부). **distinct 승격 = 디자인 입력 채널(#16) 1종만**(BN·GS·TP 세 군 견디는 게이팅 lifecycle + 비-TP 트윈 직접 대조).

> **PR 통합 과잉일반화 거부 기록 (v4.0·distinct 0):** ⑩ "접지/면분할 축"(P-1) = 공정#2 접지 family + 파라미터#9 + 오시 cascade#5(면수=파생값·축 아님). ⑪ "표지/내지 역할 차원 축"(P-2) = 자재#1 usage_cd 슬롯 전파(★침묵선택 거부 — 별 역할축 아님). ⑫ "페이지 차원 축"(P-3) = 수량#10 슬롯 + page_rule 엔티티(TP T-C 합류). ⑬ "공정방식 분기 축"(P-4) = 인쇄방식#12·공정#2·도수#6 분배 + 정책(GS G-2 동류). ⑭ "면지 bundle 축"(P-5) = 자재#1 usage.03 + 공정#2(D-2 동형). ⑮ "규격/면적 사이즈 축"(P-6) = 가격#11 라우팅 + 사이즈#13(같은 좌표·다른 엔진). ⑯ "인쇄방식종속 자재 축"(P-7) = 인쇄방식#12 자재풀 게이팅 간선. ⑰ "용도 분류 축"(P-8) = 카테고리#7 태그/마케팅 라벨. ⑱ "스코딕스/레이저커팅 축"(P-9) = 공정#2 멤버 + 칼틀 사이즈#13. **distinct 승격 0종 — 9 fragment 전부 facet/family/cascade/정책. 16축 포화 입증(4번째 카테고리=새 축 0).**

> **★ST 통합 과잉일반화 거부 기록 (v5.0·distinct 1·포화 붕괴):** ⑲ "형상 축"(S-1) = **★distinct 승격(#17)** — 사이즈축 1:1 흡수 전제가 ST 전용 슬롯·1:多로 깨짐(유일한 승격). ⑳ "칼선 메커니즘 축"(S-2) = 공정#2 family(THO_GRA/THO_DFT 두 모드·도무송=공정 멤버·KB 결정적) + 프리셋칼틀=사이즈#13. ㉑ "재단 입자 축"(S-3) = 공정#2 멤버(반칼=PROC_054·완칼=PROC_053·스티커완칼=PROC_055·KB 결정적·별 축 거부). ㉒ "점착/내후 자재계열 축"(S-4) = 자재#1 합성 차원(adhesion/weather·색상/두께→material 동형·★침묵선택 거부 후 facet). ㉓ "인쇄방식 분기 축"(S-5) = 인쇄방식레시피#12(PR P-4/P-7 합류·자재/도수/가격 게이팅). ㉔ "가격엔진 분기 축"(S-6) = 가격#11 라우팅(die-cut/판/정가·PR P-6·GS G-7 합류). ㉕ "화이트강제 축"(S-7) = 공정#2 + 제약#5 cascade. ㉖ "disable 룰엔진 축"(S-8) = 제약#5 정점 케이스(227건). ㉗ "넘버링 VDP 축"(S-9) = 공정#2(+가변=VDP#16·TP T-3 합류). ㉘ "완제SKU 스티커 축"(S-10) = 템플릿#4 + 생산형태#15(GS tmpl 합류). **distinct 승격 1종(형상 #17) — 9 fragment facet. 5번째 카테고리가 distinct 1 도입 = 16축 포화 붕괴(오버피팅 아님·증거 강제). ★S-4는 침묵선택 거부하고 "별 점착자재계열 vs 자재 합성 차원" 트레이드오프 펼친 뒤 facet.**

> **★CL 통합 과잉일반화 거부 기록 (v6.0·distinct 0·재포화·★의류 variant #18 부결):** ㉙ "의류 variant 축(#18)"(C-2) = **★distinct 부결 — facet 클러스터**(자재#1 size×color SKU matrix + 사이즈#13 + 색상자재CLR + 제약#5 셀가용성). GS variant 축(G-4)의 2D 일반화. ㉚ "apparel_info 전용 그릇 축"(C-1) = 구현 컨테이너 뷰(6키가 #12/#2/#1/#13/#5/#2별색으로 분해·D-8 동형·축 아님). ㉛ "size×color 매트릭스 축"(C-3) = 자재#1 SKU matrix(G-1 본체 SKU 동형) + 제약#5(2D 셀가용성 정점·★[HARD] MTRL_COD 분해). ㉜ "인쇄위치 축"(C-4) = 공정#2 멀티슬롯(GS 귀돌이 4슬롯 동형) + #11 + #16 KOI매핑. ㉝ "카테고리 내부 2모델 축"(C-5) = 생산형태#15 + item_gbn 구현 discriminator(정책). ㉞ "의류 인쇄방식 축"(C-6) = 인쇄방식레시피#12(상품내 옵션 인코딩=삼면 표현·PR/ST 합류). ㉟ "Pantone 별색 축"(C-7) = 공정#2 별색 family(round-22 경계·#6 도메인 규모). ㊱ "GBN 연령 축"(C-8) = 사이즈#13/기초코드#6 하위 속성. ㊲ "원단출처/비의류 분기 축"(C-9) = 자재#1 원단 라이브러리 계열(카탈로그 정책) + 생산형태#15 + 카테고리#7 경계. **distinct 승격 0종 — 9 fragment 전부 facet/matrix/family/정책. 6번째 카테고리가 distinct 0 = 17축 재포화(PR 패턴 반복·모델 안정성 재확인). ★C-2(의류 variant #18)·C-3(size×color matrix)·C-4(인쇄위치)는 침묵선택 거부하고 "distinct vs GS variant 2D 일반화 facet" 트레이드오프 펼친 뒤 facet. 역방향 오류(distinct를 facet으로 숨김) 점검: size×color 셀가용성이 유일 잔여 후보였으나 ST S-8(disable 227=#5 정점)과 동일 패턴으로 제약#5 무손실 흡수(2D subject)·숨김 아님.**

> **★AC 통합 과잉일반화 거부 기록 (v7.0·distinct 0·재포화·★가공방식 그룹핑 A-8 #18 부결):** ㉳ "가공방식 그룹핑 슬롯 축(#18)"(A-8) = **★distinct 부결 — facet 클러스터**(공정#2 라미 + 자재#1 합성[라미 결과] + 옵션#3 cascade[production_method→자재 subset 게이팅]). GRP_OPTION_CD=옵션#3 polymorphic 게이팅(G-4 채널·CL 매트릭스 동형). ㉴ "두께 축"(A-1) = 자재#1 WGT 차원(WGT 슬롯 다의성 평량/두께·[huni-ref] mat_cd 통합 1.5T=3T×0.8 동형). ㉵ "소재 variant 축"(A-2) = 자재#1 surface-finish 합성 차원(ST S-4 점착/내후 동형·거울 별공식=#11 라우팅 not 자재분류). ㉶ "입체/스탠드 3D 축"(A-3) = 분산 facet(받침=부속물#8·코롯토 두께블록=자재#1·양면=옵션#3·입체조형=공정#2·생산형태#15/형태가공#14 둘 다 아님). ㉷ "부착물 축"(A-4) = 부속물#8 + 공정#2 부착 bundle(고리 KR/CN/CR ST 공유=단일 부자재 마스터). ㉸ "인쇄면/화이트 축"(A-5) = 옵션#3 + 공정#2(화이트) + 제약#5(투명종속·ST S-7 동형). ㉹ "가격엔진 축"(A-6) = 가격#11 acrylic2025 라우팅(ST S-6·GS G-7·PR P-6 합류). ㉺ "상품명 소재 축"(A-7) = 자재#1(PET) + 공정#2(합지)(G-1·CL C-2 라벨 융합). ㉻ "템플릿 자산 축"(A-9) = #16 TemplateAsset + 카테고리#7(T-A 이중의미). **distinct 승급 0종 — 9 fragment 전부 facet/family/cascade/정책. 7번째 카테고리가 distinct 0 = 17축 재포화(PR·CL 패턴 반복). ★A-8(가공방식 그룹핑·신규 강후보)·A-1(두께)·A-2(소재variant)·A-3(입체)는 침묵선택 거부하고 "distinct #18 vs 기존 축 분해 facet" 트레이드오프 펼친 뒤 facet. 역방향 오류(distinct를 facet으로 숨김) 점검: GRP_OPTION_CD 그룹핑 슬롯이 유일 잔여 후보였으나 옵션#3 polymorphic 게이팅(G-4/CL 매트릭스 동형)으로 무손실 흡수·★ST 형상#17과 정반대(형상=KB G-SK-2 결함이 distinct 강제·가공방식=기존 축이 왜곡 없이 담음[라미=공정 멤버 이미 수용])·숨김 아님.**
