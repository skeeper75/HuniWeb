# RP 옵션 원자 추출 — ST(스티커) 카테고리

> 후니 RP-Meta 하네스 파이프라인 ① 산출물 (rpm-reverse-engineer).
> RedPrinting ST 카테고리(36상품) 대표 3상품 원자추출 + 33상품 그룹 횡단 태깅을 **base-data 관리 렌즈**로 역공학.
> 목적 = 메타모델 아키텍트가 "RedPrinting이 **형상(shape)·칼선(반칼/완칼/도무송/조각)·점착 종류·인쇄방식(UV/DTF/후지)** 을 어떤 관리 축으로 분리·정규화하는가"를 추상화할 원재료.
> RedPrinting은 사용자 본인 설계 시스템(검증된 참조 모델 — 답습 아님).
> **★ST 카테고리의 본질 = 형상×칼선×점착소재×인쇄방식 4축 교차. BN(면적)·GS(완제SKU·variant)·TP(디자인입력채널)·PR(다면/제본/접지)에서 미발굴된 "형상 enum + 칼선 방식(THO_DFT 프리셋 vs THO_GRA 자유형) + 재단 입자(묶음/개별재단=반칼/낱장) + 점착소재 분기 + 인쇄방식 분기(UV/DTF/후지)" 가 ST를 가른다.**

## 출처 표기 규칙 (BN/GS/TP/PR 계승)
- `[reuse:productInfo]` = huni-widget s2 캡처(`_workspace/huni-widget/01_reverse/s2_raw_captures/prod_*.json`)의 infoCall 풀 응답(`product_option.option` + `product_data` 전체 = `pdt_mtrl_info`/`pdt_size_info`/`pdt_dosu_info`/`pdt_prn_cnt_info`/`pdt_pcs_info`/`pdt_add_pcs_info`/`pdt_disable_pcs_info`/`option_info.shape_info`). STTHUSR·STCUXXX·STPADPN·STTHCIC·STTHSQU·STDCFBR·STPADIY·STPADNM 보유.
- `[reuse:price-capture]` = 동 캡처(`s2_*.json`) priceCall reqBody/result/query 실측(가격 API `WSP_ACPT_ORDER_TMPL_PCS_PRICE`). STCUXXX·STPADPN·STTHCIC 보유.
- `[live:SSR-negative]` = 2026-06-17 라이브 읽기전용 GET `/ko/product/item/ST/{code}` = HTTP 200·~306KB이나 **신규 Vue client-render** — 옵션 select 미노출(전역 `km1_size` 샘플 + footer family_site만, 반칼/모양/자유형 텍스트는 정적 마케팅 카피). STTHCIC 확인.
- `[live:catalog]` = `raw/widget_monitor/redprinting_catalog.json` 상품명·URL·category (2026-06-17 확인, ST 36상품 전부 category=ST·URL=/item/ST/).
- `unobserved` = 미관측(날조 금지).

## base_data_tag 7버킷 (가설 — 아키텍트가 최종 확정)
자재(material) / 공정(process) / 옵션(option) / 템플릿(template/SKU) / 제약(constraint) / 기초코드(base-code/enum) / 카테고리(category)

---

## 0. ST 카테고리 핵심 발견 — 형상·칼선·재단입자·점착소재·인쇄방식이 1급 분리축

ST 상품은 BN·GS·TP·PR과 동일한 서버 base-data 스키마(`pdt_mtrl_info`/`pdt_size_info`/`pdt_dosu_info`/`pdt_prn_cnt_info`/`pdt_pcs_info`)를 그대로 쓴다. **ST 고유는 ① `option_info.shape_info`(형상 enum: SQ/CL/EL/RC/FR) ② 모양커팅이 두 메커니즘으로 분기(`THO_DFT` 프리셋 칼선 + `THO_GRA` 자유형 칼선) ③ `CUT_DFT` 재단 입자(묶음재단=반칼시트 / 개별재단=낱장) ④ 점착소재가 자재·상품 분기로 인코딩 ⑤ 인쇄방식(일반/UV/DTF/후지)이 pdtCode prefix + 가격엔진 분기로 인코딩**.

### 0.1 ★형상(shape) = 1급 enum 축 (ST 본질 — BN/GS/TP/PR 미발굴)
`option_info.shape_info`가 형상 코드를 별도 슬롯으로 보유(`[reuse:productInfo]`):

| shape COD | shape 이름 | 보유 상품(대표) | 동반 칼선 |
|-----------|-----------|----------------|----------|
| **FR** | 자유형 | STTHUSR(자유형) | THO_GRA/FRXXX(자유형 모양커팅) |
| **SQ** | 사각형 | STCUXXX(사각반칼) | THO_DFT/SQ*(사각 프리셋) |
| **CL** | 원형 | STTHCIC(원형) | THO_DFT/CL001~010(원형 10X10~100X100) + CLFRE(자유원형) |
| **EL** | 타원형 | STTHELP(타원형) | THO_DFT/EL*(추정) |
| **RC** | 사각라운드형 | STTHSQU(사각라운드) | THO_DFT/RC001~025(40X20~100X100) + RCFRE(자유사각라운드) |

★`STDCFBR`(패브릭 데코)는 **shape_info에 5형상(SQ/CL/EL/RC/FR) 전부**를 한 상품에 담음 = shape enum의 superset 원천. 즉 형상은 ① 상품 분기(원형=STTHCIC·타원=STTHELP)로도, ② 한 상품 내 옵션(STDCFBR 5형상 선택)으로도 인코딩됨. base_data_tag = 기초코드(shape enum) + (인코딩에 따라) 카테고리 or 옵션. **★directive #1 핵심 — 후니 미발굴 "형상" 1급 축.**

### 0.2 ★칼선(cutting) = 두 메커니즘 분기 (THO_DFT 프리셋 vs THO_GRA 자유형 — ST 정수)
모양커팅이 두 개의 distinct PCS 그룹으로 갈린다(`[reuse:productInfo]`):
- **`THO_GRA`(자유형 모양커팅)** = `FRXXX`(자유형) — 디자인 칼선을 따라 자른다(도무송/조각 칼선). STTHUSR/STPADIY/STDCFBR. ESN_YN=Y·VIEW_YN=N(형상이 FR이면 자동 강제).
- **`THO_DFT`(프리셋 모양커팅)** = 형상별 사이즈 프리셋 enum. STCUXXX(SQXXX 사각), STTHCIC(CL001~010 + CLFRE), STTHSQU(RC001~025 + RCFRE). 즉 정형 형상은 **사이즈 고정 프리셋 칼틀** + 형상별 "자유OOO"(CLFRE/RCFRE) 변형.

→ 칼선 메커니즘 = ① 자유 칼선(디자인 따라·THO_GRA) ② 프리셋 칼틀(고정 사이즈·THO_DFT). 가격 reqBody는 `PCS_COD=THO_DFT, PCS_DTL_COD=SQXXX` 형태로 칼틀을 전달(`[reuse:price-capture]` STCUXXX). base_data_tag = 공정(모양커팅) + 기초코드(칼틀/형상 enum). **★directive #1 핵심 — "칼선 방식(자유 vs 프리셋칼틀)" 후니 미발굴. PR THO_GRA(포스터 모양커팅 1종)보다 ST가 칼틀 enum(CL/RC 수십종)으로 깊다.**

### 0.3 ★재단 입자(CUT_DFT) = 반칼(half-cut) vs 낱장 = directive #2 핵심
`CUT_DFT`(재단)이 2종으로 갈리며 NOTICE에 반칼/낱장이 명문화됨(`[reuse:productInfo]` STTHUSR·STCUXXX 동일 NOTICE):
- **`DFXXX` 묶음재단** = "기본 A5~A4 묶음재단 : **반칼로 떼어 쓸 수 있도록** 제작" → 시트에 여러 스티커를 배치하고 **반칼(half-cut/kiss-cut)** 로 떼어 쓰는 형태. ESN_YN=Y(기본).
- **`DFITM` 개별재단** = "낱개 스티커를 원하실 경우 개별재단" → **완칼(full-cut)** 로 낱장 분리.

→ 즉 "반칼 vs 완칼"은 별도 옵션이 아니라 **재단 입자(묶음=반칼시트 / 개별=완칼낱장)** 로 인코딩. ★ST 카테고리명 "사각반칼 스티커"(STCUXXX)의 "반칼"은 곧 묶음재단(DFXXX) 기본값. base_data_tag = 공정(재단) + 기초코드(재단입자 enum). **★directive #2 핵심 — "재단 입자(반칼/완칼/낱장)" 후니 미발굴 축. GS 완칼(THO_CUT)·중철 등과 합류 검토.**

### 0.4 ★점착·소재 종류 = 자재 분기 + 상품 분기 (directive #3 점착)
스티커 자재(`pdt_mtrl_info`)는 지종(PTT)×평량(WGT)×점착성으로 합성되며, **점착/내후성 특성이 자재 variant + 별도 상품으로 동시 인코딩**(`[reuse:productInfo]` STCUXXX 19소재):

| 소재 계열 | 대표 자재(MTRL_CD/PTT_NM) | 특성 | 상품 분기 |
|----------|--------------------------|------|----------|
| 일반 라벨 | RXATL090 아트지라벨90g·모조80g·크라프트57g | 실내용 | STTHUSR/STCUXXX 본체 |
| 초강접 | RPATA090 아트지라벨 초강접 | 강접착 | (자재 variant) |
| PET 투명/은무/금광 | RXSPT050 은무PET·RXTPT050 투명PET·금광/은광PET | 방수·투명 | STCDTRA류 |
| **리무버블** | 유포 리무버블100g·고투명PET 리무버블·시냅스PET 리무버블135g | 재부착(떼고 다시) | **STRMDFT(리무버블 스티커)** |
| 유포(합성지) | RXYUP080 유포·유포매트 투명후지 | 옥외·방수 | **STOTDFT(옥외용)** |
| 금/은/동 라벨 | 금/은/동 라벨지 | 메탈릭 | **STEWDFT(메탈)** |
| 한지/인견 | 한지류 인견라벨80g | 질감 | **STKPDFT(한지)** |
| 자석 | unobserved | 자석 점착 | **STMADFT(통자석)** |
| 저온 | unobserved | 냉장/냉동 접착 | **STLTDFT(냉장/냉동)** |

→ 점착 종류(강접/리무버블/옥외/저온/자석)는 ① 한 상품 내 소재 옵션(STCUXXX 19소재에 리무버블·옥외 포함)으로도, ② 점착 특화 상품(STRMDFT·STOTDFT·STMADFT·STLTDFT)으로도 인코딩. base_data_tag = 자재(점착소재 variant) + (특화 시) 카테고리(점착특화 상품). **★directive #3 — "점착 종류" = 자재 속성. 본체 자재모델에 점착성/내후성 차원 필요.**

### 0.5 ★인쇄방식(일반/UV/DTF/후지) = pdtCode prefix + 가격엔진 분기 (directive #3 인쇄방식·PR §0.4 동형)
같은 "판/자유/네임 스티커"가 인쇄방식별로 별도 pdtCode + **다른 가격엔진**으로 분기(`[reuse:productInfo]`·`[live:catalog]`):

| 인쇄방식 | pdtCode prefix | item_gbn / price_gbn | 자재 | 도수 | 화이트인쇄 |
|---------|---------------|---------------------|------|------|-----------|
| **일반(디지털)** | STTH*·STCU* | `digital_item` / `digital_price` | 종이/PET 라벨 다종 | SID_S 단면(택1) | PRT_WHT 선택 |
| **UV** | **STPAU*** (STPAUDY/PN/NM) | unobs(추정 vDigital/vTmpl) | unobserved | unobs | unobs |
| **DTF 열전사** | **STPAD*** (STPADDY/NM/PN) | `vDigital_item` / **`vTmpl_price`** | **DTF 전용 필름(단일)** | SID_S(고정·dosuView=N) | **PRT_WHT 강제(ESN=Y)** |
| **후지** | **STBPDFT**·"투명후지"자재 | unobs | 투명후지 계열 | unobs | unobs |

→ ★인쇄방식이 **자재(DTF=DTF전용필름)·도수노출(DTF=dosu 숨김)·화이트인쇄 강제·가격엔진(vTmpl_price)** 을 동반 결정. RedPrinting은 인쇄방식을 옵션이 아닌 **상품(pdtCode prefix) 분기**로 인코딩 — **PR 책자 윤전/토너/인디고(§0.4) 동형 의사결정**. base_data_tag = 카테고리/기초코드(인쇄방식) + 자재(방식종속) + 제약(방식→화이트강제). **★directive #3 — PR과 합류하는 "인쇄방식이 상품을 가른다" 분기축. ST는 일반/UV/DTF/후지 4계열.**

### 0.6 ★판(板) 스티커 = 완제SKU형 sheet 단위 (가격엔진 distinct)
판스티커(STPADPN DTF판·STPAUPN UV판)는 die-cut 스티커와 구조가 다름(`[reuse:productInfo]`·`[reuse:price-capture]`):
- 사이즈 = **고정 판 규격**(140X200·A4 — `STICKER_TYPE` 무·DFT_YN으로 기본판) — 자유사이즈 아님
- 도수 = dosuSelect view_yn=N(인쇄도수 선택 숨김·고정 4색)
- 모양커팅 없음(THO 그룹 부재) — 판 전체 단위
- 가격 = `vTmpl_price`(판 규격 템플릿 가격) — `digital_price`(면적·칼틀 산정) 아님
- PRN_CNT = FIR 1·INC 1(장 단위), PDT_UNIT="장"

→ 판스티커 = "정해진 판 사이즈에 디자인 채워 장 단위 판매" = **완제SKU에 가까운 sheet형**(GS tmpl_price 동형). base_data_tag = 템플릿/SKU(판 규격) + 자재(필름) + (가격)vTmpl_price. **★die-cut(자유사이즈·칼틀·digital_price) vs 판(고정규격·장단위·vTmpl_price) 2계열로 갈림.**

---

## 1. STTHUSR — 자유형 스티커 (★형상·자유칼선 대표) `[reuse:productInfo]` 풀
source: `_workspace/huni-widget/01_reverse/s2_raw_captures/prod_STTHUSR.json` 풀 infoCall.

```
product: STTHUSR 자유형 스티커 (ST)   item_gbn: digital_item   price_gbn: digital_price   PDT_UNIT: (장)
디자인 입력 (실측 플래그): useKoiEditor=Y · useRPEditor=N · usePDF=Y · useTemplateDownload=Y · usePDFordCnt=Y · cut_guide_yn=N
axes:
  - axis: 형상 (shape)        # ★option_info.shape_info 실측
    choices: [FR 자유형]   base_data_tag: 기초코드(shape enum)
    note: ★자유형 단일. shape=FR → 칼선이 THO_GRA(자유형 모양커팅)로 자동 강제(VIEW_YN=N).
          디자인 칼선(도무송)을 따라 자른다. STDCFBR가 SQ/CL/EL/RC/FR 5형상 superset 보유.
  - axis: 칼선/모양커팅 (THO_GRA)        # ★pdt_pcs_info 실측
    choices: [FRXXX 자유형]   ESN_YN=Y · VIEW_YN=N(자동·숨김)   base_data_tag: 공정(모양커팅) + 기초코드(칼틀 enum)
    note: ★자유형 = 디자인 외곽선 = 칼선(도무송/조각). 프리셋 칼틀(THO_DFT)과 distinct 메커니즘.
  - axis: 재단 입자 (CUT_DFT)        # ★pdt_pcs_info 실측 2종
    choices: [DFXXX 묶음재단(반칼시트·기본·ESN=Y), DFITM 개별재단(낱장·완칼)]
    base_data_tag: 공정(재단) + 기초코드(재단입자 enum)
    note: ★directive #2. NOTICE="기본 A5~A4 묶음재단:반칼로 떼어 쓸 수 있도록 / 낱개=개별재단".
  - axis: 용지(자재)        # pdt_mtrl_info 26종 실측
    choices: [아트지라벨90g(RXATL090·기본), 아트지라벨초강접90g, 크라프트라벨57g, 모조지라벨80g, 얼스팩라벨70g,
              은무PET50g, 투명PET50g, 유포스티커80g, 고투명PET_투명후지50g, 금광/은광PET50g,
              유포리무버블100g, 고투명PET리무버블50g, 시냅스PET리무버블135g, 금/은/동라벨지, 한지인견라벨80g …(26)]
    base_data_tag: 자재(지종 PTT × 평량 WGT × 점착/투명 합성 — MTRL_CD=RX/RP/RG/RS + PTT_CD + WGT_CD)
    note: ★점착소재 정점 — 일반/초강접/PET투명/리무버블/유포(옥외)/메탈/한지가 한 상품 소재 enum에 공존(§0.4).
          MTRL_TYPE=R · CLR_CD/CLR_NM(소재색 X=기본) · PTT_CD(ATL=아트지라벨) · WGT_CD(090).
  - axis: 사이즈 (size)        # pdt_size_info — 사이즈직접입력
    choices: [사이즈직접입력 — DFT WRK 4×4mm 시작]   base_data_tag: 사이즈(자유입력)
    note: ★자유형은 자유사이즈(디자인 외곽 기준). 정형(원/사각라운드)은 프리셋 칼틀(THO_DFT)이 사이즈 겸함.
  - axis: 도수 (dosu)        # pdt_dosu_info
    choices: [SID_S 단면4색]   base_data_tag: 기초코드(도수)   note: 스티커=단면 고정(붙이는 면 무인쇄).
  - axis: 코팅 (COT_DFT)        # pdt_pcs_info 실측
    choices: [TCMAS 무광코팅단면, TCGLS 유광코팅단면]   ESN_YN=N   base_data_tag: 공정(코팅)
  - axis: 화이트인쇄 (PRT_WHT)        # pdt_add_pcs_info 실측
    choices: [DFXXX 화이트인쇄]   base_data_tag: 공정(화이트언더베이스)
    note: 투명/유색 PET 위 화이트 베이스. 자재(투명PET) 선택 시 동반(추정 캐스케이드).
  - axis: 넘버링 (NUM_DFT)        choices: [DFXXX 넘버링]   base_data_tag: 공정(넘버링)   note: 일련번호 인쇄.
  - axis: 부분UV (SCO_DFT)        choices: [DFXXS 부분UV 단면]   base_data_tag: 공정(부분UV)
  - axis: 폴리백 개별포장 (PAK_POL)        # ★pdt_pcs_info 6규격
    choices: [ST001 90X150, ST002 90X200, ST003 60X200, ST004 112X160, ST007 160X230, ST006 220X297]
    base_data_tag: 공정(포장) + 부자재(폴리백) BUNDLE + 기초코드(봉투규격 enum)
    note: ★개별 비닐포장 옵션. 봉투 규격 enum. 포장=공정·폴리백=부자재 묶음(PR 면지 BUNDLE 동형).
캐스케이드 제약 (★pdt_disable_pcs_info 227건 실측):
  - 형식: {MTRL_CD, PCS_CD, PCS_DTL_CD(null=그룹전체), NOTE} — 자재 선택 시 특정 후가공 UI disable
  - disable 대상 PCS 10종: [MIS_DFT 미싱, SCO_DFT 부분UV, SCO_GLD 금부분UV, SCO_SLV 은부분UV, FLD_DFT 접지,
                            LAM_DFT 책받침코팅, OSI_DFT 오시, COT_DFT 코팅, EMB_DFT 형압, FOI_DFT 박]
  - 예: RGEGP050·RSESP050(특수소재) → MIS_DFT(미싱) 비활성
  base_data_tag: 제약(자재→후가공 disable)
  note: ★227건 = 26소재 × 후가공 조합. 특수소재(PET/금속/한지)는 코팅/박/형압/미싱 등 비활성. PR disable(24건)보다 깊다.
가격 모델 (digital_price): reqBody MTRL_CD·CUT/WRK_WDT/HGH·DOSU_COD·PRN_CLR_CNT + PCS_INFO[THO_GRA·CUT_DFT…]
  query: WSP_ACPT_ORDER_TMPL_PCS_PRICE — 좌표(CUT_WDT/HGH)+칼틀 PCS 전달. 비로그인 PRICE=0(세션결함).
수량: skinInfo quantityGroup={"orderCnt":"디자인 수 (건수)","printCnt":"수량"} · prn_cnt FIR 100·INC 100·MIN 1
  base_data_tag: 옵션(이중수량 — 디자인수×수량)   note: PR 포스터 동형(디자인수×부수).
```
**메타모델 시사점:** 자유형 스티커 = **shape=FR + 자유칼선(THO_GRA) + 재단입자(반칼/낱장) + 점착소재 정점(26종) + 자유사이즈 + 풍부 후가공(코팅/화이트/넘버링/부분UV/포장) + 227 disable 룰**. ★ST가 추가하는 핵심 = "형상 enum + 칼선 메커니즘 2분기(자유 THO_GRA vs 프리셋 THO_DFT) + 재단입자(반칼/완칼)". `_ambiguous-fragments.md` S-1~S-4 등재.

---

## 2. STCUXXX — 사각반칼 스티커 (★반칼/완칼·프리셋칼틀 대표) `[reuse:productInfo]` 풀 · `[reuse:price-capture]`
source: `prod_STCUXXX.json` 풀 infoCall + `s2_STCUXXX.json` priceCall 3조합.

```
product: STCUXXX 사각반칼 스티커 (ST)   item_gbn: digital_item   price_gbn: digital_price
디자인 입력 (실측 플래그): useKoiEditor=N · useRPEditor=Y · usePDF=Y · useTemplateDownload=Y · cut_guide_yn=N
★= 자유형(STTHUSR KOI)과 에디터 채널 다름(STCUXXX=RP에디터). TP 디자인입력채널 축(#16)이 ST에도 갈림.
axes:
  - axis: 형상 (shape)        # ★option_info.shape_info 실측
    choices: [SQ 사각형]   base_data_tag: 기초코드(shape enum)
    note: ★사각형 고정 → 칼선이 THO_DFT(프리셋 사각 칼틀)로 강제. size_info STICKER_TYPE=SQ.
  - axis: 칼선/모양커팅 (THO_DFT)        # ★pdt_pcs_info — 프리셋 칼틀
    choices: [SQXXX 사각형(프리셋)]   ESN_YN=Y · VIEW_YN=N   base_data_tag: 공정(모양커팅) + 기초코드(칼틀)
    note: ★자유형(THO_GRA/FRXXX)과 distinct PCS 그룹. 사각=프리셋 칼틀. 가격 reqBody PCS_COD=THO_DFT/SQXXX 실측.
  - axis: 재단 입자 (CUT_DFT)        # ★pdt_pcs_info 2종
    choices: [DFXXX 묶음재단(★반칼시트·기본), DFITM 개별재단(낱장·완칼)]
    base_data_tag: 공정(재단) + 기초코드(재단입자)
    note: ★directive #2 정수 — 상품명 "사각반칼"의 "반칼"=묶음재단(DFXXX). 가격 reqBody CUT_DFT/DFXXX 실측.
  - axis: 용지(자재)        # pdt_mtrl_info 19종 실측
    choices: [아트지라벨90g(기본)·초강접90g, 크라프트57g, 모조80g, 얼스팩70g, 은무/투명PET50g, 유포80g,
              고투명PET_투명후지50g, 금광/은광PET50g, 유포리무버블100g, 고투명PET리무버블50g,
              유포매트_투명후지80g, 시냅스PET리무버블135g, 금/은/동라벨지, 한지인견라벨80g]
    base_data_tag: 자재(지종×평량×점착 합성)
    note: ★STTHUSR 26종의 서브셋(19). 리무버블·옥외(유포)·메탈·한지·투명후지 점착 spectrum 공존(§0.4).
  - axis: 사이즈        # pdt_size_info — 사이즈직접입력(STICKER_TYPE=SQ)
    choices: [사이즈직접입력]   base_data_tag: 사이즈(자유입력·사각비율)
  - axis: 도수        choices: [SID_S 단면]   base_data_tag: 기초코드(도수)
  - axis: 코팅 (COT_DFT)        choices: [TCMAS 무광, TCGLS 유광]   base_data_tag: 공정(코팅)
  - axis: 화이트인쇄 (PRT_WHT)  choices: [DFXXX 화이트인쇄]   base_data_tag: 공정(화이트언더베이스)
  - axis: 넘버링 (NUM_DFT)      choices: [넘버링]   base_data_tag: 공정(넘버링)
  - axis: 부분UV (SCO_DFT)      choices: [부분UV 단면]   base_data_tag: 공정(부분UV)
수량: quantityGroup={"orderCnt":"디자인 수 (건수)","printCnt":"수량"}   base_data_tag: 옵션(이중수량)
가격 모델 (digital_price) [reuse:price-capture]:
  reqBody: ORD_INFO[MTRL_CD=RXATL090·CUT/WRK_WDT/HGH·DOSU_COD=SID_S·PRN_CLR_CNT=4] +
           PCS_INFO[{THO_DFT/SQXXX}, {CUT_DFT/DFXXX}]
  query: WSP_ACPT_ORDER_TMPL_PCS_PRICE '0101','LNG_KO','STCUXXX',<PARAMS>…<PCS>THO_DFT/SQXXX</PCS><PCS>CUT_DFT/DFXXX</PCS>
  실측: 비로그인 retCode=999·PRICE=0(세션결함·구조 무관). 칼틀(THO_DFT)·재단(CUT_DFT)이 가격 PCS로 전달 확정.
```
**메타모델 시사점:** 사각반칼 = **shape=SQ + 프리셋칼틀(THO_DFT/SQXXX) + 반칼재단(CUT_DFT/DFXXX) + 점착소재 19종 + 후가공(코팅/화이트/넘버링/부분UV)**. ★STTHUSR(자유칼선 THO_GRA)과 칼선 메커니즘이 distinct함을 두 캡처로 직접 증명. 반칼(묶음재단)=ST 카테고리 정체. `_ambiguous-fragments.md` S-2(칼선 2메커니즘)·S-3(재단입자) 등재.

---

## 3. STPADPN — DTF 열전사 판스티커 (★인쇄방식 분기·판단위 대표) `[reuse:productInfo]` 풀 · `[reuse:price-capture]`
source: `prod_STPADPN.json` 풀 infoCall + `s2_STPADPN.json` priceCall.

```
product: STPADPN DTF 열전사 판스티커 (ST)   item_gbn: vDigital_item   price_gbn: vTmpl_price   PDT_UNIT: 장
디자인 입력 (실측 플래그): useKoiEditor=Y · useRPEditor=N · usePDF=N · useTemplateDownload=Y · usePDFordCnt=Y · useEditorOrdCnt=Y
★= PDF 업로드 없음(usePDF=N)·에디터 전용. 판스티커는 에디터로 판 채움.
axes:
  - axis: 인쇄방식 (printing method)        # ★pdtCode prefix STPAD* = DTF
    choices(상품분기): [DTF 열전사]   base_data_tag: 카테고리/기초코드(인쇄방식 DTF) + 자재(DTF필름) + 제약(화이트강제)
    note: ★STPAU*(UV)·STBPDFT(후지)·STTH*(일반)와 pdtCode·가격엔진 분기(§0.5). DTF=열전사로 천/의류에 부착.
  - axis: 사이즈 (판 규격)        # ★pdt_size_info — 고정 판 2종
    choices: [140X200(기본·WRK 144X204), A4(210X297·WRK 214X301)]
    base_data_tag: 템플릿/SKU(판 규격 enum) + 사이즈(고정)
    note: ★자유사이즈 아님 — 고정 판. base_info MIN_CUT 100X150~MAX_CUT 500X730·CUT_MRG 4 보유하나 size_info는 2판 프리셋.
  - axis: 용지(자재)        # ★pdt_mtrl_info 단일
    choices: [PXPUF003 DTF 전용 필름]   base_data_tag: 자재(DTF전용필름·인쇄방식 종속)
    note: ★단일 소재 — DTF 방식이 자재를 강제(§0.5·PR 윤전전용지 P-7 동형 인쇄방식종속 자재).
  - axis: 도수 (dosu)        # ★pdt_dosu_info — 숨김
    choices: [SID_S 단면 — dosuSelect view_yn=N(고정·미노출)]   base_data_tag: 기초코드(도수·고정)
    note: ★DTF=4색 단면 고정·도수 선택 숨김(die-cut STTHUSR는 SID_S 노출).
  - axis: 재단 (CUT_DFT)        # ★ESN=Y·VIEW=N
    choices: [DFXXX 재단]   base_data_tag: 공정(재단·판단위)   note: 판 전체 재단·모양커팅 없음(THO 그룹 부재).
  - axis: 화이트인쇄 (PRT_WHT)        # ★ESN=Y·VIEW=N(강제)
    choices: [DFXXX 화이트인쇄]   base_data_tag: 공정(화이트언더베이스) + 제약(필수)
    note: ★DTF는 화이트 베이스 필수(ESN_YN=Y) — 천/유색 위 전사라 흰 바탕 강제. 가격 reqBody PRT_WHT 전달 실측.
  - axis: 폴리백 개별포장 (PAK_POL)        choices: [폴리백 개별포장]   base_data_tag: 공정(포장) + 부자재
수량: quantityGroup={"orderCnt":"디자인 수 (건수)","printCnt":"수량"} · prn_cnt FIR 1·INC 1(장 단위)
  base_data_tag: 옵션(이중수량·장)
가격 모델 (vTmpl_price) [reuse:price-capture]:
  reqBody: ORD_INFO[MTRL_CD=PXPUF003·CUT_WDT=140·CUT_HGH=200·WRK 144X204·DOSU_COD=SID_S·PRN_CLR_CNT=4] +
           PCS_INFO[{CUT_DFT/DFXXX}, {PRT_WHT/DFXXX}]
  query: WSP_ACPT_ORDER_TMPL_PCS_PRICE …STPADPN…<MTRL_COD>PXPUF003</MTRL_COD><CUT_WDT>140</CUT_WDT>…<PCS>CUT_DFT/DFXXX</PCS><PCS>PRT_WHT/DFXXX</PCS>
  실측: optionMutation label="A4"(판규격 선택). vTmpl_price = 판 규격 템플릿 가격(die-cut digital_price와 distinct 엔진).
```
**메타모델 시사점:** DTF 판스티커 = **인쇄방식 분기(DTF·pdtCode) + 단일 종속자재(DTF필름) + 고정 판규격(완제SKU형) + 도수 숨김 + 화이트강제 + vTmpl_price(판 템플릿가)**. ★ST가 die-cut 계열(자유사이즈·칼틀·digital_price)과 판 계열(고정규격·장단위·vTmpl_price)로 갈림을 증명. 인쇄방식이 자재·도수노출·화이트강제·가격엔진 동반결정(PR §0.4·P-7 동형). `_ambiguous-fragments.md` S-5(인쇄방식 분기)·S-6(판 vs die-cut 가격엔진) 등재.

---

## 4. ST 33상품 그룹 횡단 태깅 (형상/반칼군·점착변형군·특수후가공소재군·인쇄방식분기군 렌즈 — 답습 회피)

> 대표 3상품(§1~3)으로 추출한 축을 나머지 33상품에 렌즈 적용. catalog 모집단 = **category=ST 36상품**(전부 /item/ST/·PR D-7식 코드접두≠카테고리 누수 없음). 옵션 상세는 `[reuse:productInfo]` 실측분(STTHUSR/STCUXXX/STPADPN/STTHCIC/STTHSQU/STDCFBR/STPADIY/STPADNM) 외 전부 `[live:catalog]` 상품명 + 동형 추정(unobserved).

### 그룹 A — 형상/칼선군 (8상품·shape×칼선 매트릭스·§1·§2 동형)
| pdtCode | 상품명 | shape / 칼선 | 가격엔진 | base_data_tag | 출처 |
|---------|--------|-------------|---------|---------------|------|
| **STTHUSR** | 자유형 스티커 | FR / THO_GRA(자유칼선) | digital | §1 풀 | `[reuse:productInfo]` |
| STPADIY | 자유형 스티커_정가 | (shape 무) / THO_GRA | **tmpl_price** | 자유형 + 정가(tmpl) | `[reuse:productInfo]` |
| **STCUXXX** | 사각반칼 스티커 | SQ / THO_DFT(프리셋칼틀) | digital | §2 풀 | `[reuse:productInfo]`+`[reuse:price]` |
| STCUNXT | [내일 출발] 사각반칼스티커 | SQ / THO_DFT | digital | §2 + 제약(납기) | `[live:catalog]` unobs |
| **STTHCIC** | 원형 스티커 | CL / THO_DFT(CL001~010+CLFRE) | digital | 기초코드(원형칼틀 11종) + §2 | `[reuse:productInfo]` |
| STTHELP | 타원형 스티커 | EL / THO_DFT(EL*) | digital | 기초코드(타원칼틀) + §2 | `[live:catalog]` unobs(EL 프리셋 추정) |
| **STTHSQU** | 사각라운드형 스티커 | RC / THO_DFT(RC001~025+RCFRE) | digital | 기초코드(라운드칼틀 25종) + §2 | `[reuse:productInfo]` |
| STCUUSR | 조각스티커 | (개별 조각칼선) / THO_GRA류 | digital | 공정(조각칼선) + §2 | `[live:catalog]` unobs |
> ★형상/칼선군 = shape{FR/SQ/CL/EL/RC} × 칼선{자유 THO_GRA / 프리셋 THO_DFT(형상별 사이즈 enum 수십종)}. STTHCIC(원형 11칼틀)·STTHSQU(라운드 25칼틀) 실측이 프리셋칼틀 enum 정점. 조각스티커(STCUUSR)=개별 조각 자유칼선(낱장 완칼). STPADIY=자유형 정가버전(tmpl_price 분기).

### 그룹 B — 다양한 모양/패브릭군 (4상품·5형상 superset·소재특화)
| pdtCode | 상품명 | shape | 소재 | base_data_tag | 출처 |
|---------|--------|-------|------|---------------|------|
| **STDCFBR** | 패브릭 데코 스티커 | **SQ/CL/EL/RC/FR 5형상 전부** | 애니웨어 패브릭 스티커 S(단일) | 기초코드(shape superset) + 자재(패브릭) | `[reuse:productInfo]` |
| STSHDFT | 다양한 모양 스티커 | 5형상(추정 STDCFBR 동형) | 다종 | 기초코드(shape) + 자재 | `[live:catalog]` unobs |
| STRMSHP | 다양한 모양 스티커_무지 | 5형상 / **무지(인쇄없음)** | 다종 | 기초코드(shape) + 옵션(무지) | `[live:catalog]` unobs |
| STFBDFT | 천 스티커 | unobs | 천(패브릭) | 자재(천) + §1 | `[live:catalog]` unobs |
> ★"다양한 모양"군 = 한 상품에 5형상(THO_DFT+THO_GRA) 모두 노출 = §0.1 shape superset 인코딩. STDCFBR가 5형상 보유 실측으로 증명. 무지(STRMSHP)=인쇄 없는 점착 시트(라벨용지만). 패브릭/천=소재특화 자재.

### 그룹 C — 점착/내후성 특화군 (7상품·§0.4 점착소재 분기)
| pdtCode | 상품명 | 점착/소재 특성 | base_data_tag | 출처 |
|---------|--------|---------------|---------------|------|
| STRMDFT | 리무버블 스티커 | ★재부착(유포/PET 리무버블) | 자재(리무버블 점착) | `[live:catalog]` unobs(STCUXXX 소재 enum에 실재) |
| STOTDFT | 옥외용 스티커 | ★옥외 내후(유포/방수) | 자재(옥외 합성지) | `[live:catalog]` unobs |
| STLTDFT | 냉장/냉동(저온) 스티커 | ★저온 점착 | 자재(저온 점착) | `[live:catalog]` unobs |
| STMADFT | 통자석 스티커 | ★자석(자성 시트) | 자재(자석) + 공정(완칼) | `[live:catalog]` unobs |
| STBKDFT | 오토바이 스티커 | ★고내후·강접(차량용) | 자재(차량용 PVC) | `[live:catalog]` unobs |
| STASDFT | 가맹점 스티커 | 실내외 범용(용도라벨) | 자재 + 카테고리(용도) | `[live:catalog]` unobs |
| STSKDFT | 스크래치 스티커 | ★스크래치 은박(긁는 복권형) | 공정(스크래치층) + 자재 | `[live:catalog]` unobs |
> ★점착/내후성 = 자재 속성이 상품을 가름(§0.4). 리무버블/옥외/저온은 STCUXXX 소재 enum에 이미 실재(자재 variant) ↔ 동시에 특화 상품으로도 분리. 자석(STMADFT)·스크래치(STSKDFT)=특수 소재/공정층 추가.

### 그룹 D — 특수 후가공/고급소재군 (5상품·박/형압/메탈·§1 후가공 확장)
| pdtCode | 상품명 | 핵심 후가공/소재 | base_data_tag | 출처 |
|---------|--------|----------------|---------------|------|
| STFODFT | 박/형압 스티커 | ★박(FOI_DFT)·형압(EMB_DFT) | 공정(박·형압) + 자재(박색) | `[live:catalog]` unobs(disable PCS에 FOI/EMB 실재) |
| STEMDFT | 금은동 형압스티커 | ★금/은/동 형압 | 공정(형압) + 기초코드(박색 enum) | `[live:catalog]` unobs |
| STEWDFT | 메탈 스티커(전차스) | ★메탈 라벨지(금/은/동) | 자재(메탈 라벨지) | `[live:catalog]` unobs(STCUXXX 금/은/동라벨지 실재) |
| STGMDFT | 명품 그문드 라벨 | ★그문드(고급 수입지) | 자재(고급 수입지) | `[live:catalog]` unobs |
| STKPDFT | 한지스티커 | ★한지(인견라벨) | 자재(한지) | `[live:catalog]` unobs(STTHUSR 한지인견라벨80g 실재) |
> ★특수 후가공/소재군 = 박(FOI_DFT)·형압(EMB_DFT)은 STTHUSR disable_pcs 대상 PCS에 실재(고급소재선택 시 활성) + 고급지(그문드/한지/메탈)는 자재 enum 실재. PR 카드 박/형압·GS/AC 박과 합류. 후니 박/형압 공정 + 고급지/메탈 자재.

### 그룹 E — 인쇄방식 분기군 (8상품·UV/DTF/후지·§0.5·§3 동형)
| pdtCode | 상품명 | 인쇄방식 | 형태 | 가격엔진 | base_data_tag | 출처 |
|---------|--------|---------|------|---------|---------------|------|
| STPAUDY | UV 자유형 스티커 | ★UV | 자유형(die-cut) | unobs(추정 vDigital) | 인쇄방식(UV) + §1 | `[live:catalog]` unobs |
| STPAUPN | UV 판스티커 | ★UV | 판(고정규격) | unobs(추정 vTmpl) | 인쇄방식(UV) + §3 판 | `[live:catalog]` unobs |
| STPAUNM | UV 네임스티커 | ★UV | 네임(소형 판) | unobs | 인쇄방식(UV) + 옵션 | `[live:catalog]` unobs |
| STPADDY | DTF 열전사 자유형 | ★DTF | 자유형 | unobs(추정 vTmpl) | 인쇄방식(DTF) + §1 | `[live:catalog]` unobs |
| **STPADPN** | DTF 열전사 판스티커 | DTF | 판(140X200/A4) | **vTmpl_price** | §3 풀 | `[reuse:productInfo]`+`[reuse:price]` |
| **STPADNM** | DTF 네임스티커 | DTF | 네임(소형판) | **vTmpl_price** | 인쇄방식(DTF) + §3 | `[reuse:productInfo]`(헤더 실측: vDigital/vTmpl·dosuView=N) |
| STBPDFT | 후지인쇄 스티커 | ★후지(은염사진) | die-cut(추정) | unobs | 인쇄방식(후지) + 자재(투명후지) | `[live:catalog]` unobs |
| STMDDFT | 수정스티커 | ★수정(덮어쓰기·불투명백색) | die-cut | unobs | 인쇄방식/용도(수정) + 자재(불투명백) | `[live:catalog]` unobs |
> ★인쇄방식 분기군 = 일반(STTH*/STCU*)·UV(STPAU*)·DTF(STPAD*)·후지(STBPDFT·"투명후지"자재). pdtCode prefix STPAU=UV·STPAD=DTF 패턴 확정(STPADPN/STPADNM 실측 vTmpl_price·DTF필름·화이트강제·도수숨김). 각 방식이 [자유형/판/네임] 형태 변형을 가짐. ★PR 책자 인쇄방식(윤전/토너/인디고) 분기축과 합류 — RedPrinting 횡단 "인쇄방식=상품분기" 패턴.

### 그룹 F — 기타/특수형태군 (4상품·완제SKU·테이프/밴드형)
| pdtCode | 상품명 | 형태 | base_data_tag | 출처 |
|---------|--------|------|---------------|------|
| STDRCAD | 카드스티커 | 카드+스티커 결합(시트) | 자재 + 템플릿/SKU + 옵션 | `[live:catalog]` unobs |
| STTBDFT | 띠부스티커 | ★캐릭터 떼었다붙이는(시트·반칼) | 공정(반칼시트) + 자재 | `[live:catalog]` unobs |
| STTPMSK | 마스킹테이프 | ★롤 테이프(완제SKU·폭/길이) | 템플릿/SKU(테이프 규격) + 자재 | `[live:catalog]` unobs |
| STTPBND | 일회용밴드 | ★밴드형 완제(인쇄 밴드) | 템플릿/SKU + 자재(밴드) | `[live:catalog]` unobs |
> ★기타/특수형태 = 카드스티커(시트형)·띠부(캐릭터 반칼시트)·마스킹테이프(롤·완제SKU)·일회용밴드(인쇄밴드). 마스킹테이프/밴드 = die-cut도 판도 아닌 완제SKU형(GS tmpl 동형·폭×길이 규격). 띠부=반칼시트의 캐릭터 특화.

---

## 5. base-data 축 횡단 종합 (메타모델 아키텍트 입력 — ST 추가분, BN·GS·TP·PR 표와 병합)

| 관리 축 | RedPrinting 표현(ST) | base_data_tag | 메타모델 흡수 단위 | 기존 카테고리 대비 신규? |
|---------|---------------------|---------------|-------------------|------------------------|
| **★형상(shape)** | `option_info.shape_info` COD enum (SQ/CL/EL/RC/FR) — 상품분기 or 한상품 5형상(STDCFBR) | 기초코드(shape enum) | 스티커 외곽 형상. 상품/옵션 양면 인코딩 | ★★신규(BN/GS/TP/PR 미발굴 — directive #1) |
| **★칼선 메커니즘** | `THO_GRA`(자유칼선/도무송) vs `THO_DFT`(프리셋칼틀·형상별 사이즈 enum 수십종) | 공정(모양커팅) + 기초코드(칼틀 enum) | 자유 칼선 vs 고정 칼틀 2메커니즘 | ★★신규(PR THO_GRA 1종보다 깊은 칼틀 enum) |
| **★재단 입자(반칼/완칼)** | `CUT_DFT` DFXXX 묶음재단(반칼시트) / DFITM 개별재단(낱장완칼) | 공정(재단) + 기초코드(재단입자) | 반칼시트 vs 낱장 완칼 | ★★신규(directive #2 — GS 완칼 THO_CUT 합류) |
| **★점착/내후 소재** | `pdt_mtrl_info` PTT×WGT×점착(일반/초강접/리무버블/유포옥외/저온/자석/메탈/한지) | 자재(점착·내후 variant) | 점착성·내후성 자재 속성 | ★신규(자재에 점착/내후 차원 — directive #3) |
| **★인쇄방식 분기** | pdtCode prefix(일반/STPAU UV/STPAD DTF/STBP 후지) + 방식종속 자재(DTF필름)·도수숨김·화이트강제·가격엔진 | 카테고리/기초코드(인쇄방식) + 자재(방식종속) + 제약 | 인쇄방식이 자재·도수·가격엔진 동반결정 | ★신규(PR 윤전/토너/인디고 §0.4와 합류) |
| **★판 vs die-cut 가격엔진** | die-cut(자유사이즈·칼틀·`digital_price`) vs 판(고정규격·장단위·`vTmpl_price`) vs 정가(`tmpl_price`) | 템플릿/SKU(판) + (가격)엔진분기 | 산정형 vs 템플릿형 가격 | ★신규(GS tmpl_price·PR digital/book2025와 합류) |
| **화이트언더베이스** | `PRT_WHT` (일반=선택·DTF=강제 ESN_YN=Y) | 공정(화이트인쇄) + (DTF)제약(필수) | 투명/유색/천 위 화이트 베이스 | (PR/AC 화이트인쇄 확장) |
| **disable 제약(자재→후가공)** | `pdt_disable_pcs_info` 227건(소재→코팅/박/형압/미싱/부분UV/접지 disable) | 제약(disable) | 특수소재→후가공 비활성 | (PR 24건·BN 강제옵션과 동형·ST 정점 227) |
| **포장 BUNDLE** | `PAK_POL` 폴리백 6규격(개별포장) | 공정(포장) + 부자재(폴리백) + 기초코드(봉투규격) | 개별 비닐포장 | (PR 면지·GS 제본 BUNDLE 동형) |
| **넘버링** | `NUM_DFT` 넘버링(일련번호 인쇄) | 공정(넘버링) | 가변 일련번호 | ★신규(VDP류·TP 디자인입력채널과 검토) |
| **이중수량** | quantityGroup={"orderCnt":"디자인 수(건수)","printCnt":"수량"} | 옵션(이중수량) | 디자인수×수량 | (PR/TP/GS 이중수량 — 라벨 동일) |
| 자재(용지) | `pdt_mtrl_info` 19~26종 PTT(ATL아트지라벨…)×WGT 합성 + CLR(소재색) | 자재(평량 variant) | 라벨 지종×평량 | (BN/PR 공유·신규 아님) |
| 코팅/부분UV | `COT_DFT`(무광/유광)·`SCO_DFT`(부분UV) | 공정(코팅/부분UV) | 표면 후가공 | (PR/BN 공유) |
| 디자인 입력 채널 | useKoiEditor/useRPEditor/usePDF (STTHUSR=KOI·STCUXXX=RP·STPADPN=KOI·usePDF=N) | (TP #16 디자인입력채널) | 에디터 채널 상품별 분기 | (TP #16 축 ST에도 적용·신규 아님) |

### 핵심 패턴 (RedPrinting의 ST 정규화 방식)
1. **★형상 = 독립 슬롯(shape_info) enum** — SQ/CL/EL/RC/FR. 상품 분기(원형=STTHCIC)와 한상품 옵션(STDCFBR 5형상)을 모두 지원. 후니 미발굴 1급 축(directive #1).
2. **★칼선 = 자유(THO_GRA) vs 프리셋칼틀(THO_DFT) 2메커니즘** — 자유형=디자인 외곽 도무송, 정형=형상별 사이즈 칼틀 enum(원형 11·라운드 25). 가격 PCS로 칼틀코드 전달. PR(THO_GRA 1종)보다 ST가 칼틀 enum으로 깊다.
3. **★재단 입자 = 묶음재단(반칼시트) vs 개별재단(완칼낱장)** — "반칼"이 별 옵션 아니라 묶음재단 기본값. directive #2 핵심. NOTICE 명문.
4. **★점착/내후 = 자재 속성** — 강접/리무버블/옥외/저온/자석/메탈/한지가 ① 한 상품 소재 enum(19~26종) ② 점착특화 상품 양면 인코딩. 자재모델에 점착성·내후성 차원 필요.
5. **★인쇄방식 = pdtCode 분기 + 가격엔진 분기** — 일반/UV/DTF/후지. 방식이 자재(DTF필름)·도수노출(숨김)·화이트강제·가격엔진(vTmpl)을 동반결정. PR 윤전/토너/인디고와 합류 — RedPrinting 횡단 "인쇄방식=상품분기" 패턴.
6. **★판 vs die-cut 2계열** — die-cut(자유사이즈·칼틀·digital_price 산정형) vs 판(고정규격·장단위·vTmpl_price 템플릿형) vs 정가(tmpl_price). 가격엔진 분기가 형태를 가름.

## 라이브 접속 결과 (정직 기록)
- **STTHUSR/STCUXXX/STPADPN/STPADNM/STTHCIC/STTHSQU/STDCFBR/STPADIY**: ★`[reuse:productInfo]` 풀 — s2 캡처에 shape_info·THO_GRA/THO_DFT·CUT_DFT(반칼/개별)·소재 19~26·disable 227·PAK_POL·skinInfo 전부 실측. STCUXXX/STPADPN/STTHCIC는 `[reuse:price-capture]` priceCall reqBody/query까지(칼틀·재단·화이트 PCS 전달 확정).
- **STTHCIC 라이브 GET(2026-06-17)**: HTTP 200·306KB·select 2개(전역 km1_size 샘플 750x585 등 + footer family_site)·반칼/모양/자유형 텍스트는 **정적 마케팅 카피**(옵션 select 아님) → 신규 Vue client-render = `[live:SSR-negative]`. data-type=6은 전부 정적속성·실옵션 미노출.
- **BFF API**: 익명 호출 불가(BN/GS/TP/PR 동일·세션인증 BFF 뒤·캡처 토큰 만료).
- **UV/후지/수정 스티커(STPAU*·STBPDFT·STMDDFT) 옵션**: catalog 상품명으로 인쇄방식 분기축 확정, 옵션 상세는 `[live:catalog]` unobs(DTF STPAD* 실측 동형 추정).

## 미관측(unobserved) 요약 — ST
- **UV 스티커(STPAU*) 옵션/가격엔진** — DTF(STPAD*) 실측으로 vDigital/vTmpl 추정하나 UV 자재·도수·화이트강제 여부 unobserved.
- **후지(STBPDFT)·수정(STMDDFT) 인쇄방식 상세** — 후지=은염사진(투명후지 자재 STCUXXX에 실재)·수정=불투명백 추정, 옵션 트리 unobserved.
- **타원형(STTHELP) EL 칼틀 enum** — 원형(CL001~010)·라운드(RC001~025) 실측, EL 프리셋 사이즈 목록 unobserved(동형 추정).
- **점착특화 상품(STRMDFT/STOTDFT/STLTDFT/STMADFT/STBKDFT) 자재코드** — 리무버블/옥외/저온은 STCUXXX 소재 enum에 실재하나 자석/오토바이 PVC 자재코드·옵션 unobserved.
- **박/형압/스크래치(STFODFT/STEMDFT/STSKDFT) 공정 상세** — FOI_DFT/EMB_DFT는 disable_pcs 대상 PCS로 실재(고급소재 활성), 박색 enum·형압 깊이·스크래치층 공정 unobserved.
- **마스킹테이프(STTPMSK)·일회용밴드(STTPBND) 완제SKU 규격** — 롤 폭×길이·밴드 규격 unobserved(완제SKU형 추정).
- **카드스티커(STDRCAD)·띠부(STTBDFT) 결합형 구조** — 카드+스티커·캐릭터 반칼시트 구조 unobserved.
- **ST 전반 PRICE>0 실가** — 비로그인 캡처(STCUXXX/STPADPN retCode=999·PRICE=0=세션결함). 옵션구조·가격엔진 분기엔 무관(RedPrinting PRICE≠0 정상).

## ST 미샘플 상품 (36종 중 대표 3 원자추출·33 그룹 횡단 — 답습 회피)
형상/칼선군 5(STPADIY·STCUNXT·STTHCIC·STTHELP·STTHSQU·STCUUSR)·다양한모양/패브릭 4(STDCFBR·STSHDFT·STRMSHP·STFBDFT)·점착특화 7(STRMDFT~STSKDFT)·특수후가공/소재 5(STFODFT~STKPDFT)·인쇄방식분기 7(STPAU*·STPADDY·STPADNM·STBPDFT·STMDDFT)·기타형태 4(STDRCAD·STTBDFT·STTPMSK·STTPBND) — 구조 다양성(형상5·칼선2메커니즘·재단입자2·점착소재 spectrum·인쇄방식4·판/die-cut/완제 3가격엔진)은 대표 3(자유형·사각반칼·DTF판) + 풀 실측 8 캡처로 커버. 메타모델 검증 시 갭(UV 가격엔진·후지/수정 방식·EL칼틀·자석/메탈 자재·완제SKU 테이프)은 로그인 캡처로 추가.

---

## Ambiguous fragments (메타모델 단계로 이관 — 아키텍트가 버킷 확정)

- **S-1 형상(shape)의 인코딩 단위** [§0.1·§1·§2 실측] — `option_info.shape_info` enum(SQ/CL/EL/RC/FR)이 ① 기초코드(형상 enum) ② 상품 분기(원형=STTHCIC·타원=STTHELP) ③ 한상품 내 옵션(STDCFBR 5형상) 중 무엇? RedPrinting은 양면 인코딩(상품분기 + 옵션). 후니 메타모델은 형상을 1급 기초코드 축으로 두되 상품/옵션 인코딩을 선택 차원으로 분리할지 결정 필요. BN/GS/TP/PR 전무한 신규 1급 축(directive #1).
- **S-2 칼선의 두 메커니즘(THO_GRA vs THO_DFT)** [§0.2·§1·§2 실측] — 자유칼선(`THO_GRA`/FRXXX 디자인외곽 도무송)과 프리셋칼틀(`THO_DFT`/CL001~010·RC001~025 형상별 사이즈 enum)이 ① 같은 "모양커팅" 공정의 2모드 ② 별개 공정 중 무엇? 칼틀 enum(원형 11·라운드 25)이 ② 기초코드(칼틀) ② 사이즈를 겸함(프리셋이 사이즈 고정). 후니 미발굴 "칼선방식+칼틀" 그릇. PR THO_GRA(1종)과 합류하나 ST 칼틀 enum이 훨씬 깊다.
- **S-3 재단 입자(반칼/완칼/낱장)의 버킷** [§0.3 실측] — `CUT_DFT` DFXXX 묶음재단(반칼시트)·DFITM 개별재단(완칼낱장)이 ① 공정(재단) ② 기초코드(재단입자 enum) ③ 배치(시트 면붙임) 차원 중 무엇? 상품명 "반칼"=묶음재단 기본값. GS 완칼(THO_CUT)·중철 등과 같은 "재단/분리 입자" 축으로 통합 가능? directive #2 핵심. 후니 미발굴.
- **S-4 점착/내후성의 자재모델 차원** [§0.4·§1·§2 실측] — 강접/리무버블/유포옥외/저온/자석/메탈/한지가 ① 자재 variant(STCUXXX 19소재 enum에 공존) ② 점착특화 상품(STRMDFT/STOTDFT/STMADFT) 양면 인코딩. 점착성·내후성이 ① 자재의 속성 컬럼(점착강도/내후등급) ② 별 자재계열 중 무엇? 후니 자재모델(지종×평량)에 "점착/내후" 차원 추가 필요. GS 본체소재·PR 자재분기(방수/점착포스터)와 합류. directive #3.
- **S-5 인쇄방식(일반/UV/DTF/후지)의 분기 단위** [§0.5·§3 실측] — pdtCode prefix(STPAU=UV·STPAD=DTF·STBP=후지)가 인쇄방식을 인코딩하며 방식이 자재(DTF전용필름)·도수노출(DTF=숨김)·화이트강제(DTF ESN=Y)·가격엔진(vTmpl)을 동반결정. 후니는 인쇄방식을 ① 상품분리 ② 옵션(인쇄방식 택1)으로 흡수 중 무엇? 인쇄방식↔자재풀 종속(P-7 윤전전용지 동형). PR 윤전/토너/인디고(P-4)와 동류 의사결정 — 횡단 "인쇄방식=상품분기" 패턴 통합 검토.
- **S-6 판(板) vs die-cut 가격엔진 경계** [§0.6·§3 실측] — die-cut(자유사이즈·칼틀·`digital_price` 산정형) vs 판(고정 판규격 140X200/A4·장단위·`vTmpl_price` 템플릿형) vs 정가(STPADIY `tmpl_price`)가 같은 ST 안에서 3가격엔진으로 갈림. 사이즈 차원이 ① 자유범위+칼틀(die-cut) ② 고정 판 프리셋(판) 중 어느 모델로 통합? 판=완제SKU형(GS tmpl_price)·die-cut=산정형(BN digital과 별). 후니 price_gbn 분기 기준과 정합 필요(PR P-6 규격vs면적 경계와 합류).
- **S-7 화이트인쇄(PRT_WHT)의 강제성 분기** [§1·§3 실측] — 화이트언더베이스가 일반 스티커=선택(ESN=N)·DTF=강제(ESN=Y). 같은 PRT_WHT 공정이 ① 선택 옵션 ② 인쇄방식 종속 강제(투명PET/천 위 필수) 중 어느 제약 모델? 자재(투명PET)·인쇄방식(DTF)→화이트강제 캐스케이드 필요. PR/AC 화이트인쇄와 합류.
- **S-8 disable_pcs 227건 룰엔진의 그릇** [§1 실측] — `pdt_disable_pcs_info`(MTRL_CD→PCS_CD disable·PCS_DTL_CD null=그룹전체)가 BN 강제옵션(force)·PR disable(24건)과 같은 룰엔진. 227건(소재26×후가공) = 특수소재→코팅/박/형압/미싱/부분UV/접지 비활성. 후니는 ① JSONLogic constraint ② 자재-후가공 호환 매트릭스 중 어느 그릇? ST가 disable 정점(BN 강제·PR 24보다 깊다) — 룰엔진 일반화 검증 케이스.
- **S-9 넘버링(NUM_DFT)의 VDP 분류** [§1·§2 실측] — 넘버링(일련번호 가변 인쇄)이 ① 단순 공정 ② VDP(가변데이터인쇄·티켓 일련번호와 동류) 중 무엇? TP 티켓 넘버링·디자인입력채널(#16)과 합류 검토. 후니 미발굴 가변데이터 축 가설.
- **S-10 완제SKU형 스티커(테이프/밴드)의 분류** [§4-F] — 마스킹테이프(STTPMSK 롤)·일회용밴드(STTPBND)·카드스티커(STDRCAD)가 die-cut도 판도 아닌 완제SKU형(폭×길이/규격). ① ST 카테고리 정당 일원 ② GS 완제SKU(tmpl_price)로 분류 중 무엇? 코스터(GS 소재분기)·봉투(완제SKU) 동류. 카테고리 소속 vs 가격모델 경계 모호.
