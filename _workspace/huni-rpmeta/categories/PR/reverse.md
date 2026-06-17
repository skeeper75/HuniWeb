# RP 옵션 원자 추출 — PR(인쇄물·리플렛·전단·포스터·책자) 카테고리

> 후니 RP-Meta 하네스 파이프라인 ① 산출물 (rpm-reverse-engineer).
> RedPrinting PR 카테고리(56상품) 대표 3상품 원자추출 + 53상품 그룹 횡단 태깅을 **base-data 관리 렌즈**로 역공학.
> 목적 = 메타모델 아키텍트가 "RedPrinting이 **접지(folding)·면(page)·제본(binding)·표지/내지 분리·인쇄방식(윤전/토너/인디고)** 를 어떤 관리 축으로 분리·정규화하는가"를 추상화할 원재료.
> RedPrinting은 사용자 본인 설계 시스템(검증된 참조 모델 — 답습 아님).
> **★PR 카테고리의 본질 = 다면·제본·접지 축. BN(면적·규격 단면)·GS(완제SKU·variant)·TP(디자인입력채널)에서 미발굴된 "다면/제본 레이어"와 "인쇄방식 분기 축"이 PR을 가른다.**

## 출처 표기 규칙 (BN/GS/TP 계승)
- `[reuse:productInfo]` = huni-widget s3 캡처(`_workspace/huni-widget/01_reverse/captures/product_PRBKYPR.json`·`s3_raw_captures/s3_PRPOXXX.json`)의 infoCall 풀 응답(`product_option.option` + `product_data` 전체). PRBKYPR·PRPOXXX 보유.
- `[reuse:price-capture]` = 동 캡처 priceCall reqBody/result/query 실측 + `01_reverse/price-engine-reversed.md` 8조합 매트릭스(가격 API `WSP_ACPT_ORDER_TMPL_PCS_PRICE`).
- `[reuse:catalog-md]` = `01_reverse/option-schema-catalog.md`(PRBKYPR 책자 §2/§3 정리분).
- `[live:SSR]` = 2026-06-17 라이브 읽기전용 GET `/ko/product/item/PR/{code}`.
- `[live:SSR-negative]` = 라이브 GET은 200이나 **신규 Vue client-render** — 인라인 옵션/플래그 미노출(상품명 텍스트만). PRLFXXX 확인.
- `[live:catalog]` = `raw/widget_monitor/redprinting_catalog.json` 상품명·URL (2026-06-17 확인).
- `unobserved` = 미관측(날조 금지).

## base_data_tag 7버킷 (가설 — 아키텍트가 최종 확정)
자재(material) / 공정(process) / 옵션(option) / 템플릿(template/SKU) / 제약(constraint) / 기초코드(base-code/enum) / 카테고리(category)

---

## 0. PR 카테고리 핵심 발견 — 다면(페이지)·제본·접지가 1급 분리축, 인쇄방식이 상품 분기축

PR 상품은 BN·GS·TP와 동일한 서버 base-data 스키마(`pdt_mtrl_info`/`pdt_size_info`/`pdt_dosu_info`/`pdt_pcs_info`/`pdt_prn_cnt_info`)를 그대로 쓴다. **차이는 ① 내지 전용 스키마 슬롯(`inner_pdt_*`)이 추가되어 표지/내지가 분리되고, ② `pdt_pcs_info`에 접지(FLD_DFT)·제본(PER_DFT)·제본방향(BIND_DIRECTION)·면지(END_PAP) 같은 다면 가공 그룹이 들어오며, ③ 같은 책자가 인쇄방식(윤전/토너/인디고)별로 별도 pdtCode로 분기**한다.

### 0.1 ★표지/내지 분리 = 이중 자재·이중 도수 스키마 (PR의 본질 — BN/GS/TP 미발굴)
책자(PRBKYPR)는 자재/도수 스키마가 **표지용과 내지용으로 이원화**된다. 출처 `[reuse:productInfo]` PRBKYPR.

| 슬롯 | 표지(cover) | 내지(inner) |
|------|------------|------------|
| 자재 | `pdt_mtrl_info` (RXART300 아트지300g …) | `inner_pdt_mtrl_info` (RXYWM080 윤전전용백색모조80g·RXPLW080 에스플러스백색 …) |
| 도수 | `pdt_dosu_info` (SID_S 단면4색·SID_D 양면8색) | `inner_pdt_dosu_info` (SID_D 양면 — `BNC_GB=BNC_COL`, NOTE="책자 내지 인쇄색도") |
| 평량 제약 | `COV_MIN_WGT=150` (표지 최소평량) | `INN_MAX_WGT=130` (내지 최대평량) |
| 가격 단가축 | F_CVR_MTRL_AMT·G_CVR_PRINT_AMT | K_INN_MTRL_AMT·L_INN_PRINT_AMT |

가격 reqBody는 `CVR_MTRL_CD`/`INN_MTRL_CD`·`CVR_CLR_CNT`/`INN_CLR_CNT`로 표지·내지를 **독립 입력**받는다(`[reuse:price-capture]`). → **표지·내지 = 같은 "자재/도수" 축이지만 두 인스턴스(role=cover vs inner)**. base_data_tag = 자재(2-role) + 기초코드(도수, 2-role). **★BN/GS/TP는 단일 본체 자재 — PR이 처음으로 "역할별 자재 슬롯"을 도입.**

### 0.2 ★페이지수(INN_PAGE) = 수량과 직교한 별도 수량성 차원 (책자 핵심)
`pdt_prn_cnt_info`: 책자 PRBKYPR `MIN_INN_PAGE=10, MAX_INN_PAGE=300, STEP_INN_PAGE=1` + `MIN_PRN_CNT=30, FIR_CNT=1, INC_CNT=10, INC_STEP=10`. 즉 **내지 페이지수(10~300)** 와 **부수(권수, 30~)** 가 둘 다 수량성 입력. skinInfo `quantityGroup.title={"orderCnt":"수량","printCnt":"내지장수"}` (★책자는 orderCnt=수량/printCnt=내지장수로 라벨 스왑 — 포스터·TP의 "디자인수×수량"과 다른 의미축). 가격 = (수량 볼륨디스카운트 곡선) × (페이지 선형가산) — `[reuse:price-capture]` 8조합 실측: 페이지 10→20 시 인쇄비 44,400→55,600(Δ1,120/page), 부가공정(코팅)은 불변. base_data_tag = 옵션(페이지) + 제약(min/max/step) + 옵션(부수). **★TP 캘린더 INN_PAGE(월수)와 동일 필드, 다른 의미(책자=대수 페이지·달력=월수).**

### 0.3 ★접지(FLD_DFT) = 평면 인쇄물의 면(face) 가공 축 (리플렛/포스터 — directive #1 핵심)
포스터 PRPOXXX `pdt_pcs_info`에 **접지 그룹(FLD_DFT "접지")이 7종**으로 실측됨(`[reuse:productInfo]`):
`[2단접지, 3단접지, 4단접지, 대문접지, 반대문접지, 4단 병풍접지, N모양 3단접지]`
→ 한 장의 종이를 어떻게 접느냐 = **면(page) 분할 가공**. 접지 방식이 곧 리플렛의 정체(2단=4면·3단=6면·대문=4면대칭 등). base_data_tag = 공정(접지) + 기초코드(접지방식 enum). **★리플렛(PRLFXXX)은 신규 Vue로 SSR-negative지만, 포스터 캡처가 접지 7종을 superset으로 담고 있어 접지 축 = 포스터/리플렛 공유 가공임이 직접 증명됨.** 후니 미발굴 "접지/면분할" 공정축 1순위 가설.

### 0.4 ★인쇄방식(윤전/토너/인디고) = 상품 분기축 (pdtCode prefix로 인코딩)
같은 "무선 책자(컬러)"가 인쇄방식별로 별도 상품으로 존재(`[live:catalog]`):
| pdtCode | 인쇄방식 | item_gbn / 신호 | 비고 |
|---------|---------|----------------|------|
| **PRBKYPR** | 윤전(offset rotary) | `book2025_item`·`book2025_price` | 대량·합리가. 내지 윤전전용지(RXYWM·RXPLW) | `[reuse:productInfo]` |
| **PRBKOPR** | 토너(toner) | unobs(추정 동형) | 소량·즉납 | `[live:catalog]` |
| **PRBKORD/PRBKOCD** | 토너 특가 | unobs | 트윈링/스프링 특가 | `[live:catalog]` |
| **PRIDPRT** | 인디고(indigo 디지털) | unobs(낱장출력) | 낱장 디지털·제본없음 | `[live:catalog]` |

→ 인쇄방식이 **자재(내지 윤전전용지 PTT=YWM)·최소수량·가격모델을 동반 결정**. RedPrinting은 인쇄방식을 옵션이 아닌 **상품(pdtCode) 분기**로 인코딩(굿즈 코스터 6소재 분리·TP "디자인X" 분리와 동형 의사결정). base_data_tag = 카테고리/기초코드(인쇄방식) + 자재(방식종속 용지). **★BN/GS/TP 미발굴 — "공정방식이 상품을 가른다"는 분기축.**

### 0.5 ★규격 인쇄물 vs 면적 산정물 경계 (directive #3 — 포스터 vs 현수막)
포스터 PRPOXXX: `price_gbn=digital_price`·`item_gbn=digital_item`·`NO_STD_ABL_YN=N`(비규격 가능)·`사이즈직접입력`(MIN 100×150~MAX 500×730). 가격 query는 `<CUT_WDT>420</CUT_WDT><CUT_HGH>594</CUT_HGH>` 좌표 전달이나 **digital_price 엔진**(BN의 `vTmpl/면적매트릭스`가 아님). 즉 포스터 = **자유사이즈 디지털 인쇄(규격 프리셋 A2/A3/A4/B3/B4 + 직접입력)**, BN 현수막 = **면적매트릭스(세로×가로 룩업)**. base_data_tag = 사이즈(프리셋+자유범위) + (가격)digital_price. → **directive #3 결론: PR 포스터는 "규격/자유사이즈 디지털 인쇄"(좌표→digital_price), BN은 "면적 산정물"(좌표→면적매트릭스). 같은 좌표 입력, 다른 가격엔진.**

---

## 1. PRLFXXX — 리플렛 (★접지/면 분할 대표) `[live:SSR-negative]` · `[reuse:productInfo]`(포스터 접지 superset) · `[live:catalog]`
source: 라이브 GET `/ko/product/item/PR/PRLFXXX` = HTTP 200·305KB이나 **신규 Vue client-render**(select 2개 전부 비옵션·data-type 옵션 미노출·"리플렛"/"접지" 텍스트만). 옵션 상세는 `[live:SSR-negative]`. **접지 축 구조는 동형 평면지류 포스터(PRPOXXX) FLD_DFT 7종 실측으로 확정**(리플렛=포스터 + 접지 강제).

```
product: PRLFXXX 리플렛 (PR)   item_gbn: digital_item(추정·포스터 동형)  price_gbn: digital_price(추정)
★리플렛 = 평면 종이(포스터/전단) + 접지(FLD_DFT) 가공이 핵심·통상 필수
axes:
  - axis: 접지 방식 (folding)        # pdt_pcs_info FLD_DFT (포스터 PRPOXXX 실측 7종)
    choices: [2단접지, 3단접지, 4단접지, 대문접지, 반대문접지, 4단 병풍접지, N모양 3단접지]
    cascade: 접지방식 → 면(page) 수·접는 위치(오시 동반) 결정. 일부 자재(모조80g 등) FLD 비활성(disable_pcs)
    base_data_tag: 공정(접지) + 기초코드(접지방식 enum)
    note: ★directive #1 핵심 축. 2단=4면·3단=6면·대문=4면대칭·병풍=아코디언. 접지=면 분할의 물리적 인코딩.
          리플렛은 접지가 통상 필수(포스터는 선택). 리플렛 자체 SSR 미노출이라 강제여부 unobserved.
  - axis: 용지(자재)        # pdt_mtrl_info (포스터 동형 45종 추정)
    choices: [아트지100~300g, 스노우, 몽블랑/랑데뷰/매쉬멜로우 등 평량 variant]   # 포스터 실측 superset
    base_data_tag: 자재(용지·평량)   note: 리플렛=중량지(접지 가능 평량) 중심 추정. 실측 아님.
  - axis: 사이즈        # pdt_size_info (포스터 프리셋 A2/A3/A4/B3/B4 + 직접입력 동형 추정)
    choices: unobserved (접지 전 펼친 크기 = A4/A3급 추정)   base_data_tag: 사이즈(규격+자유)
  - axis: 도수        # pdt_dosu_info SID_S 단면4 / SID_D 양면8
    choices: [SID_S 단면, SID_D 양면]   base_data_tag: 기초코드(도수)
    note: ★리플렛은 접지물이라 양면(SID_D) 통상 사용(안/밖). 포스터=단면 중심.
  - axis: 코팅·오시·미싱 등 후가공        # pdt_pcs_info COT_DFT/OSI_DFT/MIS_DFT (포스터 실측)
    choices: [무광/유광 코팅, 오시(접는선 누름), 미싱(절취선)]
    base_data_tag: 공정(코팅/오시/미싱)
    note: ★오시(OSI_DFT) = 접지선 누름가공 — 접지와 동반(두꺼운 용지 접을 때 필수). 접지↔오시 캐스케이드 추정.
  - axis: 수량 (디자인 수 × 수량)        # skinInfo quantityGroup (포스터 동형)
    choices: [ORD_CNT 디자인 수(건수) × PRN_CNT 수량]   base_data_tag: 옵션(이중수량)
```
**메타모델 시사점:** 리플렛 = **평면 종이 + 접지(면 분할) + 오시(접는선) 캐스케이드**. 접지방식 enum이 면 수를 결정(2단=4면…). 후니 미발굴 "접지/면분할" 공정축. ★`_ambiguous-fragments.md` P-1(접지방식의 면 인코딩) 등재. 리플렛 자체는 SSR-negative이나 동종 포스터 FLD_DFT 7종이 접지축을 직접 입증.

---

## 2. PRBKYPR — [윤전] 무선 책자 (컬러) (★제본·표지/내지 분리·페이지수 정점 대표) `[reuse:productInfo]` 풀 · `[reuse:price-capture]` 8조합
source: `_workspace/huni-widget/01_reverse/captures/product_PRBKYPR.json` 풀 infoCall + `price-engine-reversed.md` 가격 8조합 라이브 실측.

```
product: PRBKYPR 무선 책자 (컬러) (PR)   item_gbn: book2025_item  price_gbn: book2025_price  PDT_UNIT: 권
디자인 입력 (실측 플래그): useKoiEditor=Y · useRPEditor=N · usePDF=Y · useTemplateDownload=Y · usePDFordCnt=Y
axes:
  - axis: 제본방식 (binding)        # ★pdtCode 분기 + PCS 동반
    choices(상품분기): [무선PER_DFT, 스프링, 트윈링, 스테플러(중철), 실제본]   # PRBKY{PR/CO/RN/ST/SL}
    cascade: 제본방식 = pdtCode로 분기(PRBKYPR=무선). 무선(PER_DFT 좌철) PCS는 ESN_YN=Y(필수·VIEW_YN=N 자동)
    base_data_tag: 공정(제본) + 카테고리/기초코드(제본방식 enum, pdtCode 분기)
    note: ★무선=PER_DFT(좌철 BPLFT). 스프링/트윈링/스테플러/실제본은 별 pdtCode. RedPrinting은 제본방식을
          상품 분기로 인코딩(인쇄방식과 동형). 제본방식↔표지/면지/날개커버 가용성 캐스케이드.
  - axis: 제본방향 (BIND_DIRECTION)        # pdt_pcs_info 실측 2종
    choices: [BPLFT 좌철, BPTOP 상철]   ESN_YN=Y(필수)
    base_data_tag: 기초코드(제본방향 enum) + 제약(필수)
    note: 좌철(왼쪽 묶기)·상철(위쪽 묶기). 책 펼침 방향 결정. ★BN/GS/TP 미발굴 방향축.
  - axis: 표지 자재 (cover material)        # pdt_mtrl_info
    choices: [RXART300 아트지300g … (COV_MIN_WGT=150 이상)]
    base_data_tag: 자재(표지 role)   note: §0.1 이중자재. 표지=두꺼운 용지(150g+).
  - axis: 내지 자재 (inner material)        # ★inner_pdt_mtrl_info (PR 전용 슬롯)
    choices: [RXYWM080 윤전전용백색모조80g, RXYWM100, RXPLW080/100 에스플러스백색, …]
    base_data_tag: 자재(내지 role)   note: ★윤전전용지(PTT=YWM) = 인쇄방식(윤전) 종속 자재. INN_MAX_WGT=130 이하.
  - axis: 표지 도수 / 내지 도수        # pdt_dosu_info / inner_pdt_dosu_info (분리)
    choices(표지): [SID_S 단면4, SID_D 양면8] / choices(내지): [SID_D 양면 — 책자 내지 색도]
    base_data_tag: 기초코드(도수, 2-role)
    note: ★표지·내지 도수 독립. 가격 reqBody CVR_CLR_CNT/INN_CLR_CNT 별도. 내지 흑백(컬러분기=PRBKYPB 별상품).
  - axis: 규격 (size)        # pdt_size_info 5종 + 직접입력
    choices: [A4세로형(210×297·기본), B5세로형(182×257), A5세로형(148×210), 크라운판(176×248), 신국판(152×225)]
    cascade: 직접입력 MIN_CUT 100×150 ~ MAX_CUT 500×730. WRK=CUT+도련10mm(CUT_MRG)
    base_data_tag: 사이즈(규격 프리셋 + 자유범위)
    note: ★출판 표준 판형(크라운판·신국판) = 책자 특화 규격 enum. BN/GS/TP 미발굴.
  - axis: 페이지수 (inner pages)        # pdt_prn_cnt_info INN_PAGE
    choices: [MIN_INN_PAGE 10 ~ MAX_INN_PAGE 300 · STEP 1 · DFT 30]
    base_data_tag: 옵션(페이지) + 제약(min/max/step)   note: §0.2 내지장수. 가격 선형가산(Δ1,120/page 실측).
  - axis: 수량 (부수)        # pdt_prn_cnt_info PRN
    choices: [MIN_PRN 30 · FIR 1 · INC 10 · STEP 10]   base_data_tag: 옵션(부수)
    note: ★quantityGroup.title={"orderCnt":"수량","printCnt":"내지장수"} — 라벨 스왑(타 상품과 의미축 다름).
  - axis: 코팅 (COT_DFT)        # pdt_pcs_info 실측 3종
    choices: [TCMAS 무광코팅단면, TCGLS 유광코팅단면, TCEBS 엠보코팅단면]   ESN_YN=Y(표지 코팅·필수성)
    base_data_tag: 공정(코팅)   note: 가격 N_COT_AMT 별도 단가축(q30 11,600 실측).
  - axis: 면지 (END_PAP)        # ★pdt_pcs_info 실측 10색
    choices: [CLYEL 노랑, CLMIN 민트, CLWHT 화이트, CLPPL 보라, CLPIN 분홍, CLAPR 살구, CLGRN 연두, CLBLU 파랑, CLSKY 하늘, CLGRY 회색]
    base_data_tag: 자재(면지) + 공정(면지삽입) BUNDLE
    note: ★면지 = "내지 시작 전/후 선택 컬러로 양면 인쇄된 면지 삽입"(NOTICE). 색=자재(컬러지)·삽입=공정.
          ★GS 제본 bundle(링=자재+꿰기=공정) 동형. 책자 특화 BUNDLE 케이스.
  - axis: 날개 커버 (CVR_SWN)        # pdt_pcs_info 실측
    choices: [DFPRT 날개소프트커버]   base_data_tag: 공정(커버가공) + 자재(날개부)
    note: 책날개(flap) 가공. CVR_SFT(소프트커버 ESN 필수)와 구별.
  - axis: 커버 종류 (CVR_SFT)        # pdt_pcs_info 실측
    choices: [DFXXX 소프트커버]   ESN_YN=Y(필수·VIEW_YN=N 자동)   base_data_tag: 공정(제본형태)
    note: 무선책자=소프트커버 자동. 하드커버는 별 상품/옵션 추정(unobserved).
  - axis: 부분UV (SCO_DFT)        # pdt_pcs_info 실측
    choices: [DFXXS 부분UV 단면]   base_data_tag: 공정(부분UV)
    note: NOTICE "투명 잉크 부분 PDF 별도 + 에디터 주문 불가" → 디자인입력채널 제약(usePDF 전용).
  - axis: 재단 (CUT_DFT)        # 기본·VIEW_YN=N
    choices: [DFXXX 재단]   base_data_tag: 공정(재단)
캐스케이드 제약 (★pdt_disable_pcs_info 24건 실측):
  - RXOMO080(미색모조80g) → COT_DFT/FLD_DFT/MIS_DFT/PRT_MAG/SCO_DFT/SCO_GLD/SCO_SLV 비활성 (7건)
  - RXOMO100(미색모조100g) → COT/FLD/LAM/MIS/OSI/PRT_MAG/SCO_DFT/SCO_GLD/SCO_SLV 비활성 (9건)
  - RXPLM080/100·RXPLW080/100 → COT_DFT/MIS_DFT 비활성 (각 2건)
  base_data_tag: 제약(자재→후가공 disable)
  note: ★규칙=내지/표지 자재(MTRL_CD) 선택 시 특정 후가공(PCS_CD) UI disable. PCS_DTL_CD=null이면 그룹 전체.
        모조지/에스플러스(저평량·코팅부적합) → 코팅/접지/미싱 비활성. 후니 disable 룰엔진 동형.
가격 모델 (book2025_price · ★표지/내지 분리 + 페이지×수량 매트릭스) [reuse:price-capture]:
  reqBody: CVR_MTRL_CD·INN_MTRL_CD·CVR_CLR_CNT·INN_CLR_CNT·PAGE_CNT·PRN_CNT 독립입력
  단가축 12종(result_log[3]): CVR_PRINT_AMT·CVR_MTRL_AMT·INN_PRINT_AMT·INN_MTRL_AMT·BIND_AMT·COT_AMT·SCO_AMT·HAP_AMT·CVR_ADD_AMT
  실측: q30_p10=56,000(인쇄44,400+부가11,600) · q300_p10=420,900 · q30_p40=89,500(페이지선형) · q30_p10_c1(표지단색)=43,900
  규칙: 수량=볼륨디스카운트 곡선(단가 1,866→1,403/권) · 페이지=선형가산(Δ1,120/page) · 표지/내지 도수 독립가산
```
**메타모델 시사점:** 책자 = **표지/내지 이중자재·이중도수 + 페이지수 차원 + 제본(방식 pdtCode분기·방향·면지·날개) + 출판판형 규격**. 가격엔진(book2025)이 cover/inner를 분리 산정. ★PR이 추가하는 핵심 = "역할별 자재 슬롯(cover/inner)" + "페이지 차원" + "제본 가공군". `_ambiguous-fragments.md` P-2~P-5 등재.

---

## 3. PRPOXXX — 종이 포스터 (★규격 인쇄물 기준선·BN 면적축 대조 대표) `[reuse:productInfo]` 풀 · `[reuse:price-capture]`
source: `s3_raw_captures/s3_PRPOXXX.json` 풀 productInfo + `s3_rp_PRPOXXX.json` priceCall 3조합.

```
product: PRPOXXX 종이 포스터 (PR)   item_gbn: digital_item  price_gbn: digital_price  PDT_UNIT: 장
디자인 입력 (실측 플래그): useKoiEditor=N · useRPEditor=N · usePDF=Y · useTemplateDownload=N · usePDFordCnt=Y
★= 에디터 0 · PDF 업로드 전용 (TP 캘린더와 대조 — 포스터는 디자인입력 레이어 없음)
axes:
  - axis: 사이즈 (규격 + 자유사이즈)        # pdt_size_info 6종 실측
    choices: [사이즈직접입력(100×150~), A2(420×594·기본), A3(297×420), A4(210×297), B3/4절(364×515), B4/8절(257×364)]
    cascade: 직접입력 MIN_CUT 100×150 ~ MAX_CUT 500×730 (NO_STD_ABL_YN=N 비규격 허용)
    base_data_tag: 사이즈(규격 프리셋 enum + 자유범위)
    note: ★directive #3 — 포스터=A판/B판 규격 프리셋 + 자유입력. 가격은 좌표→digital_price(BN 면적매트릭스 아님).
  - axis: 용지 (자재)        # pdt_mtrl_info 45종 실측
    choices: [아트지100~300g(7평량), 앙상블130/160/190, 인바이런먼트크라프트216, 반누보화이트250,
              매쉬멜로우262, 몽블랑화이트130~240, 미색모조100/120, 랑데뷰내츄럴130 … 총45]
    base_data_tag: 자재(용지·평량 variant)
    note: ★평량 variant 정점(아트지만 7평량). PTT(지종)×WGT(평량) = MTRL_CD 합성코드(BN MTRL 동형).
  - axis: 도수        # pdt_dosu_info
    choices: [SID_S 단면4, SID_D 양면8]   base_data_tag: 기초코드(도수)
  - axis: 접지 (FLD_DFT)        # ★pdt_pcs_info 실측 7종 (리플렛 §1과 공유)
    choices: [2단접지, 3단접지, 4단접지, 대문접지, 반대문접지, 4단 병풍접지, N모양 3단접지]
    base_data_tag: 공정(접지) + 기초코드(접지방식 enum)
    note: ★포스터가 접지 7종 보유 = 리플렛과 접지축 공유 증명(§0.3). 포스터는 접지 선택적·리플렛은 통상 필수.
  - axis: 코팅 (COT_DFT)        # 실측 4종
    choices: [무광코팅단면, 무광코팅양면, 유광코팅단면, 유광코팅양면]   base_data_tag: 공정(코팅)
  - axis: 타공 (HOL_DFT)        choices: [타공]   base_data_tag: 공정(타공)   note: 포스터 걸이용 구멍.
  - axis: 책받침코팅 (LAM_DFT)  choices: [책받침코팅]   base_data_tag: 공정(라미네이팅)   note: 두꺼운 라미.
  - axis: 미싱 (MIS_DFT)        choices: [미싱]   base_data_tag: 공정(절취선)
  - axis: 오시 (OSI_DFT)        choices: [오시]   base_data_tag: 공정(접는선 누름)   note: 접지 동반.
  - axis: 부분UV (SCO_DFT)      choices: [부분UV 단면, 부분UV 양면]   base_data_tag: 공정(부분UV)
  - axis: 모양커팅 (THO_GRA)    choices: [모양커팅]   base_data_tag: 공정(모양재단)
  - axis: 재단 (CUT_DFT)        choices: [재단]   base_data_tag: 공정(재단·기본)
  - axis: 수량 (디자인 수 × 수량)        # skinInfo quantityGroup
    choices: [ORD_CNT "디자인 수(건수)" × PRN_CNT "수량"]   base_data_tag: 옵션(이중수량)
    note: ★포스터=디자인수×부수 (TP/리플렛 동형). 책자(§2)는 라벨 스왑(수량×내지장수)으로 의미 다름.
가격 모델 (digital_price) [reuse:price-capture]:
  reqBody: MTRL_CD·CUT_WDT/HGH·WRK_WDT/HGH·DOSU_COD·PRN_CLR_CNT·PRN_CNT·ORD_CNT
  query: WSP_ACPT_ORDER_TMPL_PCS_PRICE — 좌표(CUT_WDT/HGH) 전달이나 digital_price 엔진(면적매트릭스 아님)
  실측: 비로그인 PRICE=0(세션결함·구조 무관). 좌표 입력 = A2 420×594 / 자유 100×150 등.
```
**메타모델 시사점:** 포스터 = **규격/자유사이즈 + 평량 자재 정점 + 접지(리플렛 공유) + 풍부한 후가공(distinct PCS_CD 9그룹: 재단/코팅/접지/타공/책받침코팅/미싱/오시/부분UV/모양커팅)**. ★directive #3 결론: 포스터(digital_price·좌표→자유사이즈)와 BN 현수막(면적매트릭스·좌표→룩업)은 같은 좌표 입력·다른 가격엔진. 평면 인쇄물 = "규격/자유 디지털"(PR) vs "면적 산정"(BN) 2계열. `_ambiguous-fragments.md` P-6 등재.

---

## 4. PR 53상품 그룹 횡단 태깅 (다면/제본/접지/인쇄방식 렌즈 — 답습 회피, 동형 묶음)

> 대표 3상품(§1~3)으로 추출한 축을 나머지 53상품에 렌즈 적용. 소재/규격/제본방식만 다른 동형은 그룹으로 묶음. 옵션 상세는 `[reuse:*]` 실측분(PRBKYPR/PRPOXXX) 외 전부 `[live:catalog]` 상품명 + 동형 추정(unobserved).

### 그룹 A — 포스터군 (11상품·규격/자유 디지털·§3 동형)
| pdtCode | 상품명 | 추가/차이축 | base_data_tag | 출처 |
|---------|--------|------------|---------------|------|
| PRPOXXX | 종이 포스터 | 기준선(45용지·접지7·후가공11) | §3 풀 | `[reuse:productInfo]` |
| PRPODAY | [오늘 출발] 종이 포스터 | PRPOXXX + 당일생산(DAY_PRDC) 제약 | §3 + 제약(납기) | `[live:catalog]` unobs |
| PRPOBIG | 대형 종이포스터(A1) | 대형 사이즈(A1 594×841↑) | 사이즈(대형) + §3 | `[live:catalog]` unobs |
| PRPORSO | 리소 포스터 | ★리소(risograph) 인쇄방식 분기·별색 | 카테고리(인쇄방식 리소) + 공정(별색) | `[live:catalog]` unobs |
| PRPOXSP | 특가포스터 | 가격특가(자재/사이즈 제한) | 사이즈·자재 제약 + §3 | `[live:catalog]` unobs |
| PRPOXPO | 특가 규격 포스터 | 규격 고정(자유입력 제거) 특가 | 사이즈(고정 enum) | `[live:catalog]` unobs |
| PRPOSTK | 고투명 점착 포스터 | ★점착(adhesive) 자재 + 투명 | 자재(점착필름) + 공정 | `[live:catalog]` unobs |
| PRPOWTT | 방수 포스터 | ★방수 자재(PET/합성지) | 자재(방수) + §3 | `[live:catalog]` unobs |
| PRPOWHT | 화이트 인쇄 포스터 | ★화이트언더베이스(PRT_WHT) 투명/유색 위 | 공정(화이트인쇄) + 자재(투명) | `[live:catalog]` unobs |
| PRPOBLT | 백릿 포스터 | ★백릿(backlit) 투과 필름 + 양면 | 자재(백릿필름) + 도수(양면) | `[live:catalog]` unobs |
> 포스터군 = 규격/자유 사이즈 + 자재 분기(점착/방수/백릿/투명) + 인쇄방식 분기(리소·화이트). ★자재특화가 상품 분기(코스터 소재분리·책자 인쇄방식분리 동형). 접지/후가공 §3 공유 추정.

### 그룹 B — 카드/엽서군 (다수·소형 규격·박/형압/특수 후가공)
| pdtCode | 상품명 | 핵심축 | base_data_tag | 출처 |
|---------|--------|--------|---------------|------|
| PRCAXXX | 일반 카드 | 카드 기준(고급지·소형) | 자재 + §3축소 | `[live:catalog]` unobs |
| PRCAXPO/PRCAPPO | 특가 엽서/모양엽서 | 모양엽서=THO_GRA 모양커팅 | 공정(모양커팅) + 자재 | `[live:catalog]` unobs |
| PRCASPO/PRCASCO | 특가/엠보 스코딕스 카드 | ★스코딕스(Scodix·입체UV 엠보) | 공정(스코딕스 입체) | `[live:catalog]` unobs |
| PRCAFPO/PRCAFOI | 특가 금은박/박·형압 카드 | ★박(FOI)·형압(emboss) | 공정(박·형압) + 자재(박색) | `[live:catalog]` unobs |
| PRCACUT | 레이저커팅 카드 | ★레이저커팅(THO_LAS) 형상 | 공정(레이저커팅) + 기초코드(칼틀) | `[live:catalog]` unobs |
| PRCDTRA | 투명카드 | ★투명 PET 자재 + 화이트인쇄 | 자재(투명) + 공정(화이트) | `[live:catalog]` unobs |
| PRKCHIG/PRKCHVY | 고급지/두꺼운 고급지 카드(수) | 고평량 고급지 variant | 자재(고급지·평량) | `[live:catalog]` unobs |
| PRKCSND | 샌드위치 엽서(목) | ★합지(BON_PAP 2겹 샌드위치) | 공정(합지) + 자재(2종) | `[live:catalog]` unobs |
| PRCAFIL | 내 파일로 만드는 포토카드 | PDF 업로드 포토카드 | 자재 + 옵션(수량) | `[live:catalog]` unobs |
| PRCABMK | 북마크 | 소형·타공(끈) variant | 자재 + 공정(타공) + 부자재(끈) | `[live:catalog]` unobs |
| PRCATCK | 티켓 꽂이 | 거치형 종이 굿즈 | 자재 + 공정(완칼/조립) | `[live:catalog]` unobs |
> 카드/엽서군 = 소형 규격 + 고급 후가공(박·형압·스코딕스·레이저커팅·합지). ★특수 후가공이 상품을 가름(TP 박티켓 동형). PR이 박/형압/스코딕스 공정군 보유.

### 그룹 C — 책자군 (19상품·★제본방식 × 인쇄방식 × 도수 매트릭스·§2 동형)
| pdtCode | 인쇄방식 | 제본방식 | 도수 | base_data_tag | 출처 |
|---------|---------|---------|------|---------------|------|
| **PRBKYPR** | 윤전 | 무선(PER_DFT) | 컬러 | §2 풀 | `[reuse:productInfo]` |
| PRBKYCO·PRBKYRN·PRBKYST·PRBKYSL | 윤전 | 스프링·트윈링·스테플러·실제본 | 컬러 | 공정(제본방식) + §2 | `[live:catalog]` unobs |
| PRBKYPB·PRBKYCB·PRBKYRB | 윤전 | 무선·스프링·트윈링 | ★흑백 | 도수(흑백 INN_CLR=1) + §2 | `[live:catalog]` unobs |
| PRBKOPR·PRBKOCO·PRBKORN·PRBKOST·PRBKOSL | ★토너 | 무선·스프링·트윈링·스테플러·실제본 | 컬러 | 카테고리(인쇄방식 토너) + §2 | `[live:catalog]` unobs |
| PRBKORD·PRBKOCD | 토너 특가 | 트윈링·스프링 | 컬러 | 인쇄방식 + 제약(특가) | `[live:catalog]` unobs |
| PRBKOPB·PRBKOCB·PRBKORB | 토너 | 무선·스프링·트윈링 | 흑백 | 인쇄방식 + 도수(흑백) | `[live:catalog]` unobs |
| TPRNBND | (제본전용) | 링바인더 | - | 공정(링바인딩) + 자재(바인더) | `[live:catalog]` unobs ★코드=TP접두 |
> 책자군 = **3축 매트릭스 = 인쇄방식{윤전Y/토너O} × 제본방식{무선/스프링/트윈링/스테플러/실제본} × 도수{컬러/흑백}**. RedPrinting은 이 3축 조합을 **개별 pdtCode**로 펼침(19상품). ★directive 핵심: 제본방식·인쇄방식·도수가 옵션이 아닌 상품 분기. 후니 메타모델은 이 매트릭스를 옵션화할지 상품분리할지 결정 필요.

### 그룹 D — 용도별 책자(편집기획 상품·5상품·§2 본체 동형·용도 라벨)
| pdtCode | 상품명 | 용도 | base_data_tag | 출처 |
|---------|--------|------|---------------|------|
| PRBKPSN | 독립출판/개인 책자 | 개인출판 | (§2 책자 동형·용도 카테고리) | `[live:catalog]` unobs |
| PRBKCTL | 브로셔/카탈로그 | 상업홍보 | §2 동형 | `[live:catalog]` unobs |
| PRBKPRP | 제안서/보고서/학술서 | 업무문서 | §2 동형 | `[live:catalog]` unobs |
| PRBKTXB | 학습교재/교과서 | 교육 | §2 동형 | `[live:catalog]` unobs |
| PRBKZIN | 잡지/간행물 | 정기간행 | §2 동형 | `[live:catalog]` unobs |
| PRBKPOL | 작품집/도록/포트폴리오 | 작품집 | §2 동형 | `[live:catalog]` unobs |
> ★용도별 책자 = §2 책자 본체(제본/표지내지/페이지) 동일, 차이는 **용도 라벨(마케팅 분류)**. 옵션 트리는 그룹C와 공유 추정. ★메타모델: "용도"가 별도 상품인가 카테고리 태그인가 (T-4 "디자인X" 동류 모호성). base_data_tag = 카테고리(용도) + §2 공유.

### 그룹 E — 평면 POP/접지/배너류 (8상품·접지·거치·미니배너)
| pdtCode | 상품명 | 핵심축 | base_data_tag | 출처 |
|---------|--------|--------|---------------|------|
| **PRLFXXX** | 리플렛 | 접지(FLD_DFT 7종) | §1 풀(접지축) | `[live:SSR-negative]`+`[reuse:productInfo]`접지 |
| PRCPDFT | 썬캡 | ★종이 모자(완칼+조립) | 자재 + 공정(완칼/조립) | `[live:catalog]` unobs |
| PRTTXXX | 테이블텐트 | ★접지+세움(텐트형 오시/접지) | 공정(접지/오시) + 형상 | `[live:catalog]` unobs |
| PRBNXXX | 미니배너 | 소형 거치 배너 | 자재 + 부속(거치대) | `[live:catalog]` unobs |
| PRBNDGN | 디자인 미니배너 | PRBNXXX + 에디터/템플릿 | 템플릿/SKU + 자재 | `[live:catalog]` unobs |
| PRIDPRT | 인디고 낱장출력 | ★인디고 디지털·제본없음·낱장 | 카테고리(인쇄방식 인디고) + 자재 | `[live:catalog]` unobs |
> 평면 POP = 접지(리플렛/테이블텐트) + 완칼조립(썬캡) + 거치(미니배너) + 인디고 낱장. ★인디고(PRIDPRT)=인쇄방식 분기 3번째(윤전/토너/인디고). 디자인 미니배너=에디터 레이어(TP 동형).

### 그룹 F — 범위 외(scope-excluded) — 전수 정직 종결용 1상품
| pdtCode | 상품명 | 분류 | 비고 | 출처 |
|---------|--------|------|------|------|
| PRSHTAG | 다양한 모양택 | ★메타모델 범위 외 | code는 PR-prefix이나 **catalog category=ET**·URL=`/item/ET/PRSHTAG` → ET(기타) 카테고리 소속. PR 56 전수 정직 종결용으로만 기재, 옵션 미추출 | `[live:catalog]` |
> ★전수 정직 기록(D-7): catalog의 PR-prefix 56 코드 중 PRSHTAG는 **catalog category=ET**(URL도 /item/ET/)이라 PR 카테고리(category=PR 필드 기준)의 일원이 아님 → 메타모델 범위 외. 반대로 TPRNBND(링바인더)는 code가 TP-prefix이나 **URL=`/item/PR/TPRNBND`**·category=PR이라 PR 책자군(§4-C)에 정당 편입. 즉 "코드 접두 ≠ 카테고리 소속"이며, 본 reverse.md의 PR 추출 모집단은 **catalog `category=PR` 56상품**(PRSHTAG 제외·TPRNBND 포함)으로 정의한다.

---

## 5. base-data 축 횡단 종합 (메타모델 아키텍트 입력 — PR 추가분, BN·GS·TP 표와 병합)

| 관리 축 | RedPrinting 표현(PR) | base_data_tag | 메타모델 흡수 단위 | 기존 카테고리 대비 신규? |
|---------|---------------------|---------------|-------------------|------------------------|
| **★표지/내지 역할 자재** | `pdt_mtrl_info`(표지) vs `inner_pdt_mtrl_info`(내지) + COV_MIN_WGT/INN_MAX_WGT | 자재(role=cover/inner 2슬롯) | ★한 상품에 역할별 자재 슬롯. cover/inner 분리 | ★★신규(PR 본질·BN/GS/TP 단일본체) |
| **★표지/내지 역할 도수** | `pdt_dosu_info` vs `inner_pdt_dosu_info` + CVR_CLR_CNT/INN_CLR_CNT | 기초코드(도수, 2-role) | 역할별 도수(표지 양면4·내지 흑백 등) | ★★신규 |
| **★페이지수(다면)** | `pdt_prn_cnt_info` MIN/MAX/STEP_INN_PAGE (책자 10~300) | 옵션(페이지) + 제약 | 책자=대수 페이지, 수량과 직교 차원 | ★신규(TP INN_PAGE=월수와 같은 필드·다른 의미) |
| **★접지(면 분할)** | `pdt_pcs_info` FLD_DFT 7종(2단/3단/4단/대문/반대문/병풍/N모양) | 공정(접지) + 기초코드(접지방식 enum) | 평면 종이 면 분할(리플렛/포스터/테이블텐트) | ★★신규(directive #1·BN/GS/TP 미발굴) |
| **★제본방식** | pdtCode 분기(무선PER/스프링/트윈링/스테플러STA/실제본) + PCS 동반 | 공정(제본) + 카테고리(제본방식 enum) | 책자 묶음 방식. 상품분기 vs 옵션 결정필요 | ★★신규 |
| **★제본방향** | `pdt_pcs_info` BIND_DIRECTION (BPLFT 좌철/BPTOP 상철) ESN=Y | 기초코드(방향 enum) + 제약(필수) | 책 펼침 방향 | ★신규 |
| **★면지(BUNDLE)** | `pdt_pcs_info` END_PAP 10색(컬러지+양면인쇄삽입) | 자재(컬러지) + 공정(삽입) BUNDLE | 책자 시작/끝 컬러지 | ★신규(GS 제본 bundle 동형) |
| **★날개/소프트커버** | CVR_SWN(날개)·CVR_SFT(소프트) | 공정(커버형태) + 자재(날개부) | 커버 형태 | ★신규 |
| **★인쇄방식 분기** | pdtCode prefix(윤전Y/토너O/인디고ID/리소RSO) + 방식종속 자재(YWM 윤전전용지) | 카테고리/기초코드(인쇄방식) + 자재(방식종속) | 인쇄방식이 자재·최소수량·가격모델 동반결정 | ★★신규(BN/GS/TP 미발굴) |
| **★출판 판형 규격** | `pdt_size_info` 크라운판·신국판·A4/B5/A5세로형 + 자유입력 | 사이즈(출판판형 enum + 자유) | 책자 표준 판형 | ★신규(출판도메인) |
| **규격/자유 디지털 사이즈** | 포스터 A2/A3/A4/B3/B4 프리셋 + MIN/MAX_CUT 자유(digital_price) | 사이즈(규격+자유범위) | 규격 인쇄물(BN 면적매트릭스와 대조) | (BN 사이즈 확장·다른 가격엔진) |
| 특수 후가공(박/형압/스코딕스/레이저커팅/합지) | FOI(박)·형압·Scodix(입체UV)·THO_LAS(레이저)·BON_PAP(합지) | 공정(특수후가공) | 카드/엽서 고급가공 | (TP 박·GS/AC 박 확장·스코딕스 신규) |
| 화이트인쇄/방수/점착/백릿 자재 | PRT_WHT·방수지·점착필름·백릿필름(pdtCode 분기) | 자재(특수) + 공정(화이트) | 포스터 자재 분기 | (TP PRT_WHT 확장) |
| 자재(용지) | `pdt_mtrl_info` 45종(아트지7평량·앙상블·몽블랑 등) PTT×WGT 합성 | 자재(평량 variant) | 평량 variant 정점 | (BN/공유·신규 아님) |
| disable 제약 | `pdt_disable_pcs_info` 24건(자재→후가공 disable) | 제약(disable) | 저평량지→코팅/접지/미싱 비활성 | (BN 소재→강제옵션 역방향·동형) |
| 가격 모델 | book2025_price(표지/내지·페이지×수량)·digital_price(좌표) | (가격 엔진) | ★책자=cover/inner분리+페이지선형+수량볼륨 | ★신규(book2025) |
| 이중수량 | 포스터 ORD_CNT"디자인수"×PRN_CNT"수량" / 책자 라벨스왑(수량×내지장수) | 옵션(이중수량) | 디자인수×부수 (책자는 의미축 다름) | (TP/GS 이중수량 확장·라벨 의미 분기) |

### 핵심 패턴 (RedPrinting의 PR 정규화 방식)
1. **★역할별 자재/도수 슬롯** — 책자가 처음으로 "표지 자재 + 내지 자재"를 분리 스키마(`pdt_mtrl_info` vs `inner_pdt_mtrl_info`)로 인코딩. 가격도 cover/inner 단가축 분리(F_CVR_MTRL vs K_INN_MTRL). BN/GS/TP는 단일 본체 → PR이 "역할(role) 차원"을 추가.
2. **★페이지(다면) = 수량과 직교한 차원** — INN_PAGE(10~300)가 부수(PRN_CNT)와 독립. 가격 선형가산. TP 캘린더 INN_PAGE(월수)와 같은 필드·다른 의미(대수 vs 월).
3. **★접지 = 면 분할의 물리 인코딩** — FLD_DFT 7종이 평면 종이를 N면으로 분할(2단=4면…). 리플렛 정체 = 접지방식. 오시(OSI_DFT) 동반. directive #1 핵심 발굴 축.
4. **★인쇄방식·제본방식·도수 = 상품(pdtCode) 분기** — 책자 19상품 = 윤전/토너 × 무선/스프링/트윈링/스테플러/실제본 × 컬러/흑백 매트릭스를 개별 pdtCode로 펼침. 인디고/리소 추가. RedPrinting은 "공정 방식"을 옵션이 아닌 상품으로 정규화(코스터 소재분리·TP 디자인X분리 동형).
5. **★특수 후가공 공정군** — 박(FOI)·형압·스코딕스(입체UV)·레이저커팅·합지(BON_PAP) — 카드/엽서가 보유. TP 박·GS/AC 박과 합류하나 스코딕스·레이저커팅은 PR 신규.
6. **disable 제약(자재→후가공)** — `pdt_disable_pcs_info` 24건: 저평량지(모조80g) → 코팅/접지/미싱 비활성. BN 소재→강제옵션(force)의 역방향(disable). 같은 룰엔진 형식.

## 라이브 접속 결과 (정직 기록)
- **PRPOXXX (포스터)**: ★`[reuse:productInfo]` 풀 — s3 캡처에 productInfo 전체(45용지·접지7·도수·후가공 distinct PCS_CD 9그룹·사이즈6·skinInfo) + priceCall 3조합. 접지 7종·후가공 9그룹이 리플렛/POP 축의 superset 원천.
- **PRBKYPR (윤전 무선책자)**: ★`[reuse:productInfo]` 풀 — captures/product_PRBKYPR.json에 표지/내지 분리 스키마(inner_pdt_*)·면지10색·제본방향·날개커버·disable 24건 + `[reuse:price-capture]` 8조합(book2025 cover/inner·페이지×수량 단가축 12종) 전부 실측. PR 제본/다면 축 1차 증거원.
- **PRLFXXX (리플렛)**: 신규 Vue client-render — `[live:SSR-negative]`(HTTP 200·305KB이나 옵션/플래그 미노출·"리플렛"/"접지" 텍스트만·select 2개 비옵션). 접지축은 동형 포스터 FLD_DFT 7종 실측으로 확정.
- **BFF API**: 익명 호출 불가(BN/GS/TP 동일·세션인증 BFF 뒤·캡처 토큰 만료).
- **인쇄방식 분기(토너 PRBKO*·인디고 PRIDPRT·리소 PRPORSO)**: catalog 상품명으로 분기축 확정, 옵션 상세는 `[live:catalog]` unobs(동형 추정).

## 미관측(unobserved) 요약 — PR
- **리플렛(PRLFXXX) 옵션 상세 + 접지 강제 여부** — Vue client-render. 접지 7종은 포스터 실측, 리플렛의 접지필수/면수↔접지 캐스케이드는 unobserved.
- **토너/인디고/리소 책자(PRBKO*·PRIDPRT·PRPORSO) 옵션** — catalog 상품명만. 토너 책자가 윤전과 자재(YWM 윤전전용지 미사용)·최소수량·페이지범위 어떻게 다른지 unobserved.
- **제본방식별(스프링/트윈링/스테플러/실제본) PCS·자재** — PRBKYPR(무선 PER_DFT)만 실측. 스프링 링색·트윈링·스테플러(중철) 제본 옵션 구조 unobserved(GS 노트류 RIN_DFT 동형 추정).
- **카드/엽서 특수후가공 상세** — 박색(FOI)·형압 깊이·스코딕스 패턴·레이저커팅 칼틀값 unobserved(상품명만).
- **포스터 자재분기(점착/방수/백릿/투명) 자재코드·옵션** — pdtCode 분리 확정, 자재별 옵션/가격 unobserved.
- **PR 전반 PRICE>0 실가** — 비로그인 캡처(포스터 PRICE=0). 책자(PRBKYPR)만 8조합 실가 확보(56,000~420,900). PRICE=0은 세션결함(메모리)·옵션구조엔 무관.
- **PR 도수 다양성** — 책자(SID_S/SID_D 표지·SID_D 내지)·포스터(SID_S/SID_D) 실측. 흑백책자(INN_CLR=1)는 가격조합으로만 확인.

## PR 미샘플 상품 (56종 중 대표 3 원자추출·53 그룹 횡단 — 답습 회피)
포스터군 10(PRPODAY~PRPOBLT)·카드엽서군 16(PRCA*/PRKC*/PRCABMK/PRCATCK)·책자군 18(PRBKY*/PRBKO*/TPRNBND)·용도별책자 6(PRBKPSN~POL)·평면POP 5(PRCPDFT~PRIDPRT·PRBNDGN) — 구조 다양성(접지7방식·제본5방식·인쇄3방식·표지내지분리·페이지차원·박/형압/스코딕스/레이저커팅·자재분기)은 대표 3(리플렛·윤전책자·포스터) + 풀 실측 2(PRBKYPR/PRPOXXX)로 커버. 메타모델 검증 시 갭(토너↔윤전 차이·제본방식별 PCS·스코딕스 패턴·인디고 낱장구조) 발견되면 로그인 캡처로 추가.

---

## Ambiguous fragments (메타모델 단계로 이관 — 아키텍트가 버킷 확정)

- **P-1 접지방식의 면(page) 인코딩** [§1·§3 실측] — FLD_DFT 7종(2단/3단/4단/대문/반대문/병풍/N모양)이 ① 공정(접는 작업) ② 기초코드(접지방식 enum) ③ 면 수를 결정하는 차원(2단=4면) 중 무엇? 접지방식↔펼친사이즈↔면수↔오시(접는선) 캐스케이드가 어떻게 묶이나. 후니 미발굴 "접지/면분할" 축 1순위(BN/GS/TP 전무).
- **P-2 표지/내지 역할 자재 슬롯의 그릇** [§0.1·§2 실측] — `pdt_mtrl_info`(표지) vs `inner_pdt_mtrl_info`(내지)가 ① 한 자재 테이블의 role 컬럼(cover/inner) ② 별도 슬롯 테이블 중 무엇? 가격도 cover/inner 단가 분리. 후니 단일 본체 자재모델에 "역할(role)" 차원 추가 필요(BN/GS/TP 단일본체). 캘린더(TP)·파우치(GS 표지+내지)와 합류 검토.
- **P-3 페이지수(INN_PAGE)가 옵션인가 차원인가** [§0.2 실측] — 책자 내지장수(10~300 STEP1)가 ① 옵션(택1) ② 수량성 차원(가격 선형가산) ③ 사이즈 차원 중 무엇? 부수(PRN_CNT)와 직교하며 가격이 둘의 곱+선형. TP INN_PAGE(월수)와 같은 필드 다른 의미 → 통합 "다면 페이지 차원" 추상화 가능? (TP T-7과 합류).
- **P-4 제본방식·인쇄방식·도수의 상품분기 vs 옵션화** [§0.4·§4-C 실측] — 책자 19상품 = 윤전/토너 × 무선/스프링/트윈링/스테플러/실제본 × 컬러/흑백 매트릭스가 RedPrinting에선 개별 pdtCode. 후니 메타모델은 이를 ① 그대로 상품분리 ② 제본방식/인쇄방식을 옵션으로 흡수 중 무엇? 인쇄방식이 자재(YWM)·최소수량·가격모델 동반결정 → 단순 옵션화 위험. (TP "디자인X"·GS 코스터 소재분리 T-4와 동류 의사결정).
- **P-5 면지(END_PAP)의 자재+공정 BUNDLE** [§2 실측] — 면지 10색이 "선택 컬러로 양면인쇄된 면지 삽입"(NOTICE). 색=자재(컬러지)·삽입=공정. GS 제본 bundle(링=자재+꿰기=공정)·아일렛(금속+타공) 동형. 한 옵션 = 자재+공정 묶음 케이스 추가.
- **P-6 규격 인쇄물 vs 면적 산정물 경계** [§0.5·§3 실측] — 포스터(digital_price·좌표→자유사이즈)와 BN 현수막(면적매트릭스·좌표→룩업)이 같은 좌표(CUT_WDT/HGH) 입력·다른 가격엔진. 사이즈 차원이 ① 규격 enum + 자유범위(포스터) ② 면적 룩업 그리드(BN) 중 어느 모델로 통합? 후니 가격엔진 분기 기준(상품군별 price_gbn)과 정합 필요. (BN 면적축·digital_price 합류).
- **P-7 인쇄방식 종속 자재(윤전전용지)의 모델링** [§2 실측] — 내지 윤전전용 백색모조(PTT=YWM·RXYWM080)는 인쇄방식(윤전)에서만 쓰는 자재. 자재가 ① 단순 PTT(지종) variant ② 인쇄방식 종속 자재(방식 변경 시 자재풀 교체) 중 무엇? 토너/인디고 책자는 다른 내지 자재풀 추정(unobserved) → 자재↔인쇄방식 종속관계 그릇 필요.
- **P-8 용도별 책자의 분류 단위** [§4-D] — PRBKPSN(독립출판)·PRBKCTL(브로셔)·PRBKPRP(보고서)·PRBKTXB(교재)·PRBKZIN(잡지)·PRBKPOL(작품집)이 §2 책자 본체 동일·용도 라벨만 다름. 용도가 ① 별도 상품(pdtCode) ② 카테고리 태그 ③ 마케팅 표시값 중 무엇? RedPrinting=별도 상품. 후니=상품 vs 카테고리 결정(P-4·TP T-4 동류). 옵션 트리는 그룹C와 공유 추정.
- **P-9 스코딕스(Scodix)·레이저커팅 특수 후가공의 버킷** [§4-B] — 스코딕스(입체 UV 엠보·PRCASCO)·레이저커팅(PRCACUT)이 ① 공정(특수가공) ② 자재(잉크/장비종속) 중 무엇? TP 박·GS/AC 박과 합류하나 스코딕스(입체 두께)·레이저커팅(칼틀 형상)은 PR 신규 공정. 후니 미발굴 가설.
