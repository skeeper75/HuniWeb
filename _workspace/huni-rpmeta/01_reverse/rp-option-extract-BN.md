# RP 옵션 원자 추출 — BN(현수막류) 카테고리

> 후니 RP-Meta 하네스 파이프라인 ① 산출물 (rpm-reverse-engineer).
> RedPrinting BN 카테고리 대표 6상품을 **base-data 관리 렌즈**로 역공학한 원자 옵션 레코드.
> 목적 = 메타모델 아키텍트가 "RedPrinting이 옵션을 어떤 관리 축으로 분리·정규화하는가"를 추상화할 원재료.
> RedPrinting은 사용자 본인 설계 시스템(검증된 참조 모델 — 답습 아님).

## 출처 표기 규칙
- `[reuse:Vue-BFF]` = huni-widget s3 캡처(`_workspace/huni-widget/01_reverse/s3_raw_captures/s3_*.json`)의 `get_digital_product_info` 실응답(신규 Vue3 위젯 BFF).
- `[live:SSR]` = 2026-06-17 라이브 읽기전용 GET `redprinting.co.kr/ko/product/item/BN/{code}` HTML 내 SSR `<select>` 마크업(레거시 jQuery 위젯). 주문/폼제출 없음.
- `unobserved` = 미관측(날조 금지).

## base_data_tag 7버킷 (가설 — 아키텍트가 최종 확정)
자재(material) / 공정(process) / 옵션(option) / 템플릿(template/SKU) / 제약(constraint) / 기초코드(base-code/enum) / 카테고리(category)

---

## 0. BN 카테고리 위젯 이중 구조 (핵심 발견)

RedPrinting BN 23종은 **두 가지 위젯 런타임**으로 갈린다 — 그러나 **동일한 서버 base-data 모델**(`pdt_mtrl_info`/`pdt_size_info`/`pdt_dosu_info`/`pdt_pcs_info`)을 공유한다:

| 런타임 | 대표 | 옵션 소스 | 추출 경로 |
|--------|------|-----------|-----------|
| 신규 Vue3 위젯 | BNBNFBL, BNPTPET | BFF `get_digital_product_info` JSON | `[reuse:Vue-BFF]` 풀 캡처 |
| 레거시 jQuery | BNSTDFT·BNBNSOD·BNRLSLV·BNPTMAS·BNTNHVY | SSR `<select data-type={...}>` | `[live:SSR]` HTML |

**메타모델 시사점:** UI 런타임이 둘이어도 base-data 스키마는 하나다. 후니가 흡수할 대상은 UI가 아니라 이 **공통 관리 축**이다.

전 BN 상품 공통 계약 (전 6샘플 일치):
- `item_gbn = real_item`, `price_gbn = real_price` (대형 실사/배너 = 면적 기반 SizeMatrix2D 가격모델). `[reuse:Vue-BFF]` `[live:SSR]`
- 사이즈 = **규격프리셋 + 사이즈직접입력(USER/SIZE_0)** 이중 모드. 작업사이즈 = 재단사이즈 + CUT_MRG(4mm) 자동. `[reuse:Vue-BFF]`
- 입력수단 = PDF 업로드 전용(에디터 없음, `useKoiEditor=N useRPEditor=N`). `[reuse:Vue-BFF]`
- 도수 = SID_S(단면) 중심, PRN_CLR_CNT=4(4색). `[reuse:Vue-BFF]`

---

## 1. BNBNFBL — 현수막 (기본/대표) `[reuse:Vue-BFF]`
source: `huni-widget/01_reverse/s3_raw_captures/s3_BNBNFBL.json` (productInfo[0].respBody.result.product_data) + `s3_BNBNFBL.json` domScan + priceCalls

```
product: BNBNFBL 현수막 (BN)
item_gbn: real_item   price_gbn: real_price   editor: PDF only
base_info: WDT_HGH_GBN_YN=N  NO_STD_ABL_YN=N  MIN_CUT=0  MAX_CUT_WDT=5000  MAX_CUT_HGH=5000  CUT_MRG=4mm
axes:
  - axis: 용지(자재)        # skinInfo.paperSelect "용지"
    choices: [PXBFCXXX "현수막"]   # 단일자재
    mtrl_decomposition: {MTRL_TYPE:P, PTT_CD:BFC "현수막"(판형/소재), CLR_CD:X "기본"(색), WGT_CD:XXX(무게)}
    cascade: 자재변경 → pdt_disable_pcs_info 룩업(현 상품 0건)
    price_flag: MTRL_CD → 가격요청 ORD_INFO.MTRL_CD (면적단가 분기키)
    base_data_tag: 자재
    note: MTRL_CD가 4축 합성코드(TYPE+PTT+CLR+WGT). 본체색=CLR 분해축, 소재정체=PTT.
  - axis: 규격(mm)(사이즈)
    choices: [사이즈직접입력(SIZE_0 cut 0x0), 5000X900, 900X900, 900X5000, 1800X1780]   # DIV_NM
    cascade: 프리셋선택→CUT_WDT/HGH 룩업; 직접입력→USER 수치 직접전달(룩업불가, cutW/cutH=0 폴백)
    price_flag: CUT_WDT/CUT_HGH 수치 직접 → 가격요청 (SizeMatrix2D 면적단가)
    base_data_tag: 기초코드(프리셋) + 제약(자유입력 MIN/MAX_CUT 범위)
    note: nonspec 자유입력 범위 = base_info MIN/MAX_CUT_WDT/HGH(0~5000). 작업=재단+4mm.
  - axis: 인쇄 도수
    choices: [SID_S "단면" (PRN_CLR_CNT=4)]
    base_data_tag: 기초코드(도수 enum)
    note: 단면 단일. DOSU_COD → 가격요청.
  - axis: 수량 (디자인 수/수량)
    choices: ORD_CNT(디자인 수=건수, min1) + PRN_CNT(수량)   # quantityGroup 이중 라벨
    base_data_tag: 옵션(수량)
    note: skinInfo.quantityGroup = {orderCnt:"디자인 수(건수)", printCnt:"수량"} 이중 수량축.
  - axis: 후가공(pdt_pcs_info, 14항목 7그룹)
    groups:
      - CUT_ZUN 재단(필수ESN_Y): [ZDINC 정사이즈재단, ZDWND 방풍커팅, ZDFRM 모양재단]   # 택1 필수
      - ILT_DFT 아일렛(선택): [RCDFT 사각귀퉁이, RCALL 사각테두리]
      - LUM_DFT 각목(선택,SUB_MTRL_Y): [DFLTG 각목_타공포함]
      - QBG_DFT 큐방(선택,SUB_MTRL_Y): [DFXXX 큐방]
      - ROP_DFT 로프(선택,SUB_MTRL_Y): [DM003 3mm, DM005 5mm]
      - SEW_DFT 봉제(선택): [DNFLD 접어꿰매기, DNLMI 줄미싱, DNLUM 봉미싱]
      - SEW_RIN 고리(선택): [DNARN 사방고리]
      - SUB_MTR 추가부자재(선택,SUB_MTRL_Y,QTY_INPUT_Y): [CT001 큐브 양면 젤리테이프]
    price_flag: 선택 후가공 → 가격요청 PCS_INFO[{PCS_COD,PCS_DTL_COD,ATTB}]
    base_data_tag: 공정(CUT_ZUN/SEW_DFT/SEW_RIN) + 자재+공정 bundle(ILT/LUM/QBG/ROP/SUB_MTR=SUB_MTRL_Y) + 제약(ESN_YN 필수)
    note: ★SUB_MTRL_YN=Y인 항목(아일렛/각목/큐방/로프/추가부자재)은 "부자재 소비 + 부착 공정" 묶음. QTY_INPUT_YN=Y(SUB_MTR)는 수량입력 동반.
pdt_disable_pcs_info: 0건 (자재 단일이라 캐스케이드 없음)
price_observed: PRICE=0 (비로그인 캡처 — RedPrinting은 PRICE≠0가 정상[메모리], 0은 세션 결함 신호. 옵션구조 추출엔 무관)
```

---

## 2. BNPTPET — PET 배너 `[reuse:Vue-BFF]`
source: `huni-widget/01_reverse/s3_raw_captures/s3_BNPTPET.json`

```
product: BNPTPET PET 배너 (BN)
item_gbn: real_item   price_gbn: real_price   editor: PDF only
base_info: MAX_CUT_WDT=1000  MAX_CUT_HGH=1000  CUT_MRG=4mm
axes:
  - axis: 용지(자재)
    choices: [PXPETXXX(PET), PXBOPXXX(블락아웃PET-수성용)]   # 2자재 (BNBNFBL은 1)
    base_data_tag: 자재
    note: ★자재 2종 = 옵션화된 자재(소재 선택축). 4축 합성코드 동일 패턴.
  - axis: 규격(mm)
    choices: [사이즈직접입력(0x0), 1000X1000]
    base_data_tag: 기초코드 + 제약(MIN/MAX 0~1000)
  - axis: 인쇄 도수
    choices: [SID_S 단면 4색]
    base_data_tag: 기초코드(도수)
  - axis: 후가공(pdt_pcs_info, 8항목 5그룹)
    groups:
      - COT_DFT 코팅(필수ESN_Y): [TCMAS 무광코팅단면, TCGLS 유광코팅단면]   # ★현수막엔 없던 코팅 그룹
      - CUT_ZUN 재단(필수): [ZDINC 정사이즈재단, ZDFRM 모양재단]
      - ILT_DFT 아일렛: [RCDFT 사각귀퉁이, RCALL 사각테두리]
      - QBG_DFT 큐방(SUB_MTRL_Y): [DFXXX 큐방]
      - SUB_MTR 추가부자재(SUB_MTRL_Y,QTY_INPUT_Y): [CT001 큐브 양면 젤리테이프]
    base_data_tag: 공정(COT/CUT) + 자재공정bundle(QBG/SUB_MTR) + 제약(ESN)
    note: ★COT_DFT(코팅)는 ESN_YN=Y 필수 — PET소재 특유. 소재(PET)→필수공정(코팅) 묵시 의존.
pdt_disable_pcs_info: 0건
```

---

## 3. BNSTDFT — X배너(스탠드 배너) `[live:SSR]`
source: live GET `/ko/product/item/BN/BNSTDFT` SSR `<select>` (2026-06-17)

```
product: BNSTDFT X배너(스탠드 배너) (BN)   runtime: 레거시 jQuery (SSR select)
price_gbn: real_price (hidden input pdt_cod_price)
axes:
  - axis: paper(자재)
    choices: [PXPETXXX(PET), PXBOPXXX(블락아웃PET-수성용)]
    base_data_tag: 자재
  - axis: size(규격)
    choices: [600X1800(604x1804), 500X1600(504x1604), USER 사이즈직접입력]   # data-type에 WRK/CUT_WDT/HGH 내장
    base_data_tag: 기초코드(프리셋) + 제약(USER 자유입력)
    note: SSR option data-type JSON = {WRK_WDT,WRK_HGH,CUT_WDT,CUT_HGH,FIR_CNT,INC_CNT,INC_STEP}. 거치형이라 세로>가로 프리셋.
  - axis: CDL_DFT_SELECT (거치대)   # ★완제 부속 SKU 선택
    choices: [PTIDF 실내/뉴포인트배너, PT005 실내/L거치대, PT004 실내/W거치대, PT003 실내/NP거치대,
              PTODF 실외/에코배너 단면, PTODD 실외/에코배너 양면, PT002 실외/복플러스 배너 양면, PT001 실외/K 배너 양면]
    base_data_tag: 템플릿/SKU (또는 옵션화된 완제 부속물)
    note: ★거치대 = 본체(인쇄물)와 별개 완제품 부속. 실내/실외 + 거치대종류 2축 복합 라벨. 메타모델: 부속물/번들 축.
  - axis: PCS groups present (HTML PCS_COD 토큰)
    observed: [CUT_ZUN 재단, ILT_DFT 아일렛, QBG_DFT 큐방, COT_DFT 코팅, CDL_DFT 거치대, SUB_MTR 추가부자재]
    base_data_tag: 공정 + bundle
    note: 상세 PCS_DTL 옵션값은 SSR select로 완전 노출되지 않음(JS 렌더). 그룹 존재만 확정, 상세=부분관측.
  - axis: 수량
    choices: number1_sel[1..10], number4_sel[1배..10배]
    base_data_tag: 옵션(수량)
    note: number4_sel "N배" = 디자인 수(건수) 배수. number1_sel = 기본 수량.
```

---

## 4. BNBNSOD — 어깨띠 (형상 특이형) `[live:SSR]`
source: live GET `/ko/product/item/BN/BNBNSOD` SSR (2026-06-17)

```
product: BNBNSOD 어깨띠 (BN)   runtime: 레거시 jQuery
price_gbn: real_price
axes:
  - axis: paper(자재)
    choices: [PXVGP001 "부직포어깨띠"]   # 단일 전용 자재
    base_data_tag: 자재
    note: ★자재명="부직포어깨띠" — 소재(부직포)+상품형상(어깨띠)이 자재명에 융합. PTT 분해 필요(아키텍트 모호 항목).
  - axis: size(규격)
    choices: [100X1800(104x1804), 150X1800(154x1804), USER 직접입력]
    base_data_tag: 기초코드 + 제약
    note: 폭 좁고 길이 김(어깨띠 형상). 형상이 사이즈 프리셋으로 표현됨(별도 shape축 아님).
  - axis: PCS groups present
    observed: [CUT_ZUN 재단, SUB_MTR 추가부자재]   # 최소 후가공
    base_data_tag: 공정 + bundle
    note: 어깨띠는 봉제/아일렛 미노출(부직포 단순재단+부자재). 후가공 폭이 현수막보다 좁음.
  - axis: 수량
    choices: number1_sel[1..10], number4_sel[1배..10배]
    base_data_tag: 옵션(수량)
```

---

## 5. BNRLSLV — 롤업배너-블락아웃PET (롤업형) `[live:SSR]`
source: live GET `/ko/product/item/BN/BNRLSLV` SSR (2026-06-17)

```
product: BNRLSLV 롤업배너-블락아웃PET (BN)   runtime: 레거시 jQuery
price_gbn: real_price
axes:
  - axis: paper(자재)
    choices: [PXBOPTEX "블락아웃PET-라텍스용"]   # 단일 (수성용 BNSTDFT와 코드 다름: BOP vs BOPTEX)
    base_data_tag: 자재
    note: ★동일 "블락아웃PET"이 인쇄방식(수성/라텍스)별 MTRL_CD 분기(PXBOPXXX vs PXBOPTEX). 자재=소재×인쇄방식 합성.
  - axis: size(규격)
    choices: [600X1800, 850X1800, 1000X1800, USER 직접입력]   # 롤업 거치대 폭에 맞춘 3프리셋
    base_data_tag: 기초코드 + 제약
  - axis: CDL_DFT_SELECT (롤업 거치대)
    choices: [RLU01 롤업거치대 600, RLU02 롤업거치대 850, RLU03 롤업거치대 1000]
    base_data_tag: 템플릿/SKU (완제 부속물)
    note: ★거치대 폭(600/850/1000)이 size 프리셋과 1:1 대응. 부속물↔사이즈 의존 캐스케이드 가능성(아키텍트 검토).
  - axis: PCS groups present
    observed: [CUT_ZUN 재단, CDL_DFT 거치대, SUB_MTR 추가부자재]
    base_data_tag: 공정 + SKU + bundle
  - axis: 수량
    choices: number1_sel[1..10], number4_sel[1배..10배]
    base_data_tag: 옵션(수량)
```

---

## 6. BNPTMAS — 매쉬배너 (매쉬 소재축) `[live:SSR]`
source: live GET `/ko/product/item/BN/BNPTMAS` SSR (2026-06-17)

```
product: BNPTMAS 매쉬배너 (BN)   runtime: 레거시 jQuery
price_gbn: real_price
axes:
  - axis: paper(자재)
    choices: [PXMASXXX "매쉬"]   # 매쉬 전용 소재
    base_data_tag: 자재
    note: PTT_CD=MAS(매쉬) — 통풍 소재. 소재 정체가 자재축으로 깔끔히 분리.
  - axis: size(규격)
    choices: [1000X1000, USER 직접입력]
    base_data_tag: 기초코드 + 제약
  - axis: PCS groups present
    observed: [COT_DFT 코팅, CUT_ZUN 재단, ILT_DFT 아일렛, QBG_DFT 큐방, SUB_MTR 추가부자재]
    base_data_tag: 공정 + bundle
  - axis: 수량
    choices: number1_sel[1..10], number4_sel[1배..10배]
    base_data_tag: 옵션(수량)
```

---

## 7. BNTNHVY — 텐트천 두꺼운 현수막 (텐트천 소재축, 최대 후가공) `[live:SSR]`
source: live GET `/ko/product/item/BN/BNTNHVY` SSR (2026-06-17)

```
product: BNTNHVY 텐트천 – 두꺼운 현수막 (BN)   runtime: 레거시 jQuery
price_gbn: real_price
axes:
  - axis: paper(자재)
    choices: [PXTFCXXX 텐트천-수성용, PXTFLXXX 텐트천-라텍스용]   # 소재×인쇄방식 2종
    base_data_tag: 자재
    note: PTT=TFC/TFL. 동일소재(텐트천) 인쇄방식(수성 C / 라텍스 L)별 분기 — BNRLSLV와 동형 패턴.
  - axis: size(규격)
    choices: [900X900, 900X5000, 1750X1750, 5000X900, USER 직접입력]   # 현수막류 최대 5000
    base_data_tag: 기초코드 + 제약
  - axis: PCS groups present (★BN 최대 7그룹 — 두꺼운 소재라 가공 풍부)
    observed: [CUT_ZUN 재단, ILT_DFT 아일렛, LUM_DFT 각목, QBG_DFT 큐방, ROP_DFT 로프, SEW_DFT 봉제, SEW_RIN 고리, PKG_GB 포장, SUB_MTR 추가부자재]
    base_data_tag: 공정 + 자재공정bundle + 제약(PKG)
  - axis: number_sel_ROP_DFT (로프 수량입력)
    choices: [USER 사용자직접입력, 1..10]
    base_data_tag: 옵션(부자재 수량) — ROP_DFT 공정에 종속된 수량 슬롯
    note: ★후가공(로프)이 자체 수량입력 select 보유 = QTY_INPUT_YN=Y의 SSR 구현. 공정+수량 결합.
  - axis: PKG_GB (포장)
    choices: [PKG_RUP "말아서 포장 필수"]   # 강제(필수) 단일값
    base_data_tag: 제약 (또는 공정-포장)
    note: ★PKG_GB = 소재특성(두꺼움)이 강제하는 포장 제약. 선택 아닌 고정. 메타모델: 소재→포장 강제 규칙.
  - axis: 수량
    choices: number1_sel[1..10], number4_sel[1배..10배]
    base_data_tag: 옵션(수량)
```

---

## 8. base-data 축 횡단 종합 (메타모델 아키텍트 입력)

| 관리 축 | RedPrinting 표현 | base_data_tag | 메타모델 흡수 단위 |
|---------|-----------------|---------------|-------------------|
| 소재 | `pdt_mtrl_info` MTRL_CD = TYPE+PTT+CLR+WGT 4축 합성 | 자재 | 소재(PTT) + 본체색(CLR) + 무게(WGT) 분해, 인쇄방식(수성/라텍스)도 MTRL_CD 분기 |
| 규격 | `pdt_size_info` DIV_NM 프리셋 + USER 자유입력 | 기초코드 + 제약 | 사이즈 프리셋 enum + nonspec MIN/MAX 범위제약. 형상(어깨띠)도 size로 표현 |
| 도수 | `pdt_dosu_info` SID_S + PRN_CLR_CNT | 기초코드 | 도수 enum (단면/4색) |
| 후가공 | `pdt_pcs_info` PCS_COD(그룹)+PCS_DTL_COD(상세) | 공정 / 자재공정bundle | 순수공정(재단/봉제) vs SUB_MTRL_YN=Y bundle(아일렛/각목/큐방/로프/부자재) 구분 |
| 부속물 | `CDL_DFT` 거치대(X배너/롤업) | 템플릿/SKU | 본체 별개 완제 부속물(거치대). 사이즈와 캐스케이드 |
| 수량 | ORD_CNT(디자인수/건수) + PRN_CNT(수량) + 공정별 QTY_INPUT | 옵션 | 이중 수량축 + 공정 종속 수량 슬롯 |
| 캐스케이드 | `pdt_disable_pcs_info` (자재→공정 disable) | 제약 | 자재선택→후가공 disable 룩업 (BN 샘플은 0건, 책자는 24건) |
| 강제규칙 | `PKG_GB` 포장 필수, `ESN_YN=Y` 필수공정 | 제약 | 소재특성→강제 옵션(포장/코팅) |

### 핵심 패턴 (RedPrinting의 정규화 방식)
1. **소재 합성코드** — MTRL_CD 하나가 소재·색·무게·인쇄방식 4~5축을 인코딩. 후니 5축 자재모델과 대조 필요(메모리 `dbmap-material-option-normalization`: 후니는 색/형상이 자재행 오염).
2. **공정 vs 자재공정bundle 분리** — SUB_MTRL_YN 플래그로 "순수 공정(재단)"과 "부자재 소비+부착(아일렛=금속링+타공)"을 구분. 후니 [HARD] "옵션=자재+공정 BUNDLE"(메모리 `dbmap-option-material-process-bundle`)과 정확히 동형.
3. **사이즈 = 프리셋 enum + nonspec 범위제약** — 면적기반 SizeMatrix2D 가격. 형상(어깨띠/거치형)도 별도 shape축이 아니라 size 프리셋으로 흡수.
4. **부속물(거치대) = 별개 SKU 축** — 인쇄 본체와 분리. size와 캐스케이드(롤업 600↔거치대600).
5. **소재→강제옵션 규칙** — PET→코팅필수, 텐트천→포장필수. 자재가 공정을 강제(disable의 역방향).
