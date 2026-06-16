# RP 옵션 원자 추출 — GS(굿즈/잡화) 카테고리

> 후니 RP-Meta 하네스 파이프라인 ① 산출물 (rpm-reverse-engineer).
> RedPrinting GS 카테고리(136상품·최대 카테고리) 대표 12상품을 **base-data 관리 렌즈**로 역공학한 원자 옵션 레코드.
> 목적 = 메타모델 아키텍트가 "RedPrinting이 굿즈 옵션을 어떤 관리 축으로 분리·정규화하는가"를 추상화할 원재료.
> RedPrinting은 사용자 본인 설계 시스템(검증된 참조 모델 — 답습 아님).
> **GS는 후니 최대 결함영역(굿즈 본체자재·variant·자재오염). BN에서 미발굴된 축(완제 SKU·variant·자재 usage 다중슬롯·본체 소재)에 집중.**

## 출처 표기 규칙
- `[reuse:price-capture]` = huni-widget s3 캡처(`_workspace/huni-widget/01_reverse/s3_raw_captures/s3_rp_GS*.json`)의 가격요청 reqBody(ORD_INFO/PCS_INFO)·respBody(result/result_sum/query) 실측. **신규 Vue3 위젯의 가격 API `WSP_ACPT_ORDER_TMPL_PCS_PRICE` 계열 호출**.
- `[live:catalog]` = `raw/widget_monitor/redprinting_catalog.json` 상품명·URL (2026-06-17 확인).
- `[live:SSR-negative]` = 2026-06-17 라이브 읽기전용 GET `/ko/product/item/GS/{code}` 결과 — GS 신규 Vue 상품은 옵션이 client-render(SSR 미노출), BFF 익명 호출은 error page. **옵션 트리 라이브 추출 불가 확정**(BN 신규 Vue와 동일).
- `unobserved` = 미관측(날조 금지).

## base_data_tag 7버킷 (가설 — 아키텍트가 최종 확정)
자재(material) / 공정(process) / 옵션(option) / 템플릿(template/SKU) / 제약(constraint) / 기초코드(base-code/enum) / 카테고리(category)

---

## 0. GS 카테고리 핵심 발견 (BN과의 구조적 차이 — 메타모델 신축 후보)

GS는 BN(면적기반 실사/배너)과 **다른 가격·옵션 패러다임**이다. 동일 서버 base-data 스키마(`pdt_mtrl_info`/`pdt_pcs_info`)를 쓰지만, **상품 정체가 "완제 굿즈 SKU"**라서 다음 축이 새로 등장한다:

### 0.1 가격 모델 3종 (★BN은 real_price 단일 — GS는 3종)
| price_gbn | 가격 API(query SP) | 대표상품 | 의미 |
|-----------|--------------------|---------|------|
| `tmpl_price` | `WSP_ACPT_ORDER_TMPL_PCS_PRICE` | GSTBMWM·GSMLSLC·GSNTSPR·GSNTSTA·GSDRSKS·GSPUFBC | 템플릿(완제 SKU) 기준 가격. PRICE_LOG=개당단가+인쇄수량+주문건수. |
| `vTmpl_price` | `WSP_ACPT_ORDER_TMPL_PCS_PRICE` | GSPDLNG | variant 템플릿 가격(v 접두). tmpl과 동일 SP, 변형 SKU 분기 추정. |
| `tiered_price` | `WSP_ACPT_ORDER_TMPL_PCS_TIERED_PRICE` | GSTGMIC | 구간(tier) 가격 — PRICE_LOG에 **자재단가** 필드 추가(tmpl엔 없음). 수량구간 할인 동반 추정. |
출처: 각 캡처 reqBody `price_gbn` + query SP명 `[reuse:price-capture]`.
**메타모델 시사점:** 후니 가격엔진은 면적형 외에 **완제 SKU 템플릿 가격(개당단가) + 구간(tiered) 가격**을 같은 옵션 모델 위에서 분기시켜야 한다(메모리 `dbmap-price-formula-types-authority` 고정가형과 정합).

### 0.2 본체(완제품)가 PCS_INFO의 한 항목 — DIR_MTR / WRK_MTR (★BN엔 없던 패턴)
BN에서 본체=`ORD_INFO.MTRL_CD`(자재 1개)였고 PCS_INFO는 후가공뿐. **GS는 본체 굿즈 자체가 PCS_INFO의 첫 항목**으로 들어가며 그게 가격의 주체다:
- `DIR_MTR` (부자재직접인쇄): GSTBMWM/GSMLSLC/GSPDLNG/GSDRSKS — `PCS_DTL_NME`가 완제품명("미르 와이드마우스 보틀 화이트 20oz"·"핑크"·"장패드 4T"). **이 한 항목이 result의 PRICE 주체**(텀블러 45000·장패드 10000·마스크끈 2800).
- `WRK_MTR` (부자재작업): GSTGMIC — `PCS_DTL_NME`="삼각 마이크텍 스펀지 S/L". 부자재(스펀지) 소비 작업.
출처: 각 캡처 result `PCS_COD=DIR_MTR/WRK_MTR` + `PCS_DTL_NME` + `PRICE` `[reuse:price-capture]`.
**메타모델 시사점:** RedPrinting은 "완제 굿즈 본체"를 **자재(MTRL_CD)가 아니라 공정성 항목(DIR_MTR=직접인쇄 부자재)**으로 모델링한다. 즉 본체 소재/색/용량이 `PCS_DTL_NME`(완제 SKU 라벨)에 융합 — 후니 "굿즈 본체 소재 컬럼 부재·소재가 상품명에만"(메모리 `dbmap-axis-staged-load-round22` GPM 진단)과 **정확히 동형**. ★자재 오염의 RedPrinting판.

### 0.3 variant 인코딩 3방식 (★BN엔 색/형상이 자재명 융합뿐 — GS는 3채널)
1. **DTL 코드 = variant 키**: GSMLSLC `DIR_MTR/MLS01`→PCS_DTL_NME="핑크"(색 variant), GSTBMWM `DIR_MTR/TM039`→"화이트 20oz"(색+용량), GSTGMIC `WRK_MTR/TG001 vs TG003`→"S vs L"(사이즈 variant, 동시에 THO_CUT 칼틀·MTRL도 분기).
2. **ATTB = variant 파라미터**: GSNTSPR `RIN_DFT/BPLFT ATTB="RIN_BLK"`(트윈링 색=검정), GSNTSPR `ROU_DFT ATTB="4"`(귀돌이 라운드 반경 4mm).
3. **CUT_WDT/HGH = 사이즈 variant**: GSNTSPR 182×257(Medium)/132×182, GSNTSTA 132×132(여권형)/88×125 — 같은 MTRL_CD(RIBVW350)에 사이즈만 바뀜.
출처: 각 캡처 reqBody/result `[reuse:price-capture]`.
**메타모델 시사점:** variant가 ① 별도 SKU 코드(DTL) ② 옵션 ATTB 파라미터 ③ 사이즈 차원으로 3중 표현. 후니 CPQ는 이 셋을 구분해야(메모리 `dbmap-cpq-option-layer-mapping` polymorphic ref).

### 0.4 자재 usage 다중슬롯 — 한 굿즈에 본체+속지+부자재 동시 (★BN 단일 MTRL)
GSNTSPR(스프링노트): `MTRL_CD=RIBVW350`(표지 자재) + `INN_DFT`(내지=무지노트, 별도 자재성 항목) + `RIN_DFT`(트윈링=금속 부자재) 동시. GSTGMIC: `MTRL_CD=RXBVW300`(인쇄지) + `WRK_MTR`(스펀지 부자재). 즉 **한 주문에 자재가 여러 usage 슬롯**(본체지/내지/링/스펀지)으로 분산.
**메타모델 시사점:** 후니 자재모델 `usage_cd`(메모리 `dbmap-option-material-process-bundle`: 옵션=자재+공정 BUNDLE, usage 슬롯)와 동형. RedPrinting INN_DFT/RIN_DFT/WRK_MTR = usage별 자재 소비.

---

## 1. GSTBMWM — 미르 와이드 마우스 텀블러 `[reuse:price-capture]`
source: `s3_rp_GSTBMWM.json` priceCalls[0-1] reqBody/result/query (line 20·66·73)

```
product: GSTBMWM 미르 와이드 마우스 텀블러 (GS)   price_gbn: tmpl_price (개당단가 45000)
base: MTRL_CD=SXMIRW06  CUT 60×120 WRK 60×120  DOSU_COD=SID_X(인쇄없음) PRN_CLR_CNT=0
axes:
  - axis: 본체(완제 텀블러 SKU)        # PCS_COD=DIR_MTR
    choices: [TM039 "미르 와이드마우스 보틀 화이트 20oz"]   # PCS_DTL_NME=브랜드+색+용량 융합
    cascade: 본체 선택 → MTRL_CD(SXMIRW06) 고정 (자재=완제 텀블러 본체)
    price_flag: ★PRICE 주체 — DIR_MTR PRICE=45000 (개당단가). result_sum.PRICE=45000.
    base_data_tag: 자재 + 템플릿/SKU (본체=완제품. 브랜드[미르]/색[화이트]/용량[20oz]이 DTL_NME에 융합)
    note: ★굿즈 본체가 "부자재직접인쇄(DIR_MTR)" 공정 항목으로 표현 — 후니 본체소재 부재 동형(§0.2).
  - axis: 인쇄 도수
    choices: [SID_X "인쇄없음" PRN_CLR_CNT=0]   # ★텀블러=인쇄 안함(곡면 직접인쇄 별도)
    base_data_tag: 기초코드(도수)
    note: BN은 SID_S(단면)였으나 텀블러는 SID_X(무인쇄). DOSU enum에 X(없음) 존재.
  - axis: 포장        # PCS_COD=PAK_ETC
    choices: [PK012 "텀블러 패키징"]   # PRICE=0(개당단가 0)
    base_data_tag: 공정(포장) 또는 옵션
    note: 완제 굿즈 전용 패키징. 가격기여 0(이 캡처). BN PKG_GB(강제)와 달리 PAK_ETC.
  - axis: 사이즈(CUT_WDT/HGH)
    choices: [60×120 고정]   # 완제 텀블러라 사이즈 변동 없음(인쇄영역?)
    base_data_tag: 기초코드 또는 제약
    note: 완제품이라 CUT 고정. 면적 변동 가격 아님(개당단가).
  - axis: 수량 (ORD_CNT 주문건수 + PRN_CNT 인쇄수량)
    choices: ORD_CNT(주문건수) + PRN_CNT(인쇄수량)   # PRICE_LOG "주문건수:1, 인쇄수량:1"
    base_data_tag: 옵션(수량)
    note: BN 이중수량(디자인수×수량)과 동일 패턴. 개당단가×수량.
```

---

## 2. GSMLSLC — 마스크 스트랩(실리콘) `[reuse:price-capture]`
source: `s3_rp_GSMLSLC.json` priceCalls[0] reqBody/result (line 20·42·66)

```
product: GSMLSLC 마스크 스트랩(실리콘) (GS)   price_gbn: tmpl_price (개당단가 2800)
base: MTRL_CD=SXSML001  CUT 15.5×15.5  DOSU_COD=SID_S PRN_CLR_CNT=4
axes:
  - axis: 본체(실리콘 끈 SKU + 색 variant)   # PCS_COD=DIR_MTR
    choices: [MLS01 "핑크"]   # ★PCS_DTL_NME=색상(핑크) — DTL코드가 색 variant 키
    cascade: 색 선택(MLS01..) → MTRL_CD=SXSML001(실리콘) 동일, DTL만 색 분기
    price_flag: ★PRICE 주체 DIR_MTR=2800. result_sum=2800.
    base_data_tag: 자재(실리콘 소재) + 옵션(색 variant via DTL)
    note: ★소재(실리콘)는 MTRL_CD에, 색(핑크)은 DIR_MTR DTL코드에 분리 인코딩 — §0.3 방식①.
           "마스크 스트랩(실리콘)" 상품명에 소재 융합 + 색은 옵션화. 끈=본체 자체.
  - axis: 인쇄        # PCS_COD=PRT_DFT
    choices: [DFXXS "인쇄단면"]   # PRICE=0
    base_data_tag: 공정(인쇄)
    note: SID_S 4색이나 인쇄 PCS는 가격 0(개당단가에 포함). PRT_DFT=인쇄 공정 마커.
  - axis: 사이즈
    choices: [15.5×15.5 고정]
    base_data_tag: 제약(완제 고정)
```

---

## 3. GSPDLNG — 장패드 (대형 패브릭) `[reuse:price-capture]`
source: `s3_rp_GSPDLNG.json` priceCalls[0-1] reqBody/result (line 20·86)

```
product: GSPDLNG 장패드 (GS)   price_gbn: vTmpl_price (개당단가 10000, 본체 + 포장 1000 + 인쇄 5000 = 16000)
base: MTRL_CD=SXLPD001  CUT 800×300 WRK 860×360  DOSU_COD=SID_S PRN_CLR_CNT=4
axes:
  - axis: 본체(장패드 SKU + 두께)   # PCS_COD=DIR_MTR
    choices: [LD001 "장패드 4T"]   # PCS_DTL_NME=장패드+두께(4T)
    price_flag: ★PRICE 주체 DIR_MTR=10000.
    base_data_tag: 자재(패브릭 소재 + 두께 4T) + 템플릿/SKU
    note: 두께(4T)가 DTL_NME에 융합 — 후니 "두께=자재"(메모리 round22 경계규칙) 동형. 본체=대형 패브릭+고무.
  - axis: 포장        # PCS_COD=PAK_ETC
    choices: [DFXXX "개별포장"]   # ★rel2853 PRICE=0 → rel3131 PRICE=1000 (수량 1 적용 시 과금)
    price_flag: ★개별포장 = 가격기여 옵션(1000원). BN PAK와 달리 GS는 포장 유료.
    base_data_tag: 옵션(유료 포장) 또는 공정
    note: ★수량 0→PRICE 0, 수량 1→PRICE 1000. 포장이 개당 과금되는 선택옵션.
  - axis: 인쇄        # PCS_COD=PRT_DFT
    choices: [DFXXS "인쇄단면"]   # ★rel3131 PRICE=5000 (수량 1)
    price_flag: ★인쇄 = 가격기여(5000원, 대형 면적 인쇄비). BN/타굿즈는 인쇄 PCS 0.
    base_data_tag: 공정(인쇄, 유료)
    note: ★장패드는 본체(10000)+인쇄(5000)+포장(1000) 3항목 합산. PRT_DFT가 0이 아닌 유일 굿즈 샘플 — 대형 인쇄비.
  - axis: 사이즈
    choices: [800×300 고정 (WRK 860×360 = CUT+여백 30mm 양쪽)]
    base_data_tag: 제약(완제) + 기초코드
    note: WRK=CUT+60(가로)/+60(세로) 작업여백. BN CUT_MRG(4mm)보다 큼(대형 굿즈).
```

---

## 4. GSNTSPR — 스프링노트 삼총사 (제본 계층·자재 다중슬롯) `[reuse:price-capture]`
source: `s3_rp_GSNTSPR.json` priceCalls[0-2] reqBody/result (line 20·57·73·89·154). step1.sizePicked="Medium"

```
product: GSNTSPR 스프링노트 삼총사 (GS)   price_gbn: tmpl_price (전 PCS PRICE=0 — 비로그인 캡처)
base: MTRL_CD=RIBVW350(표지지)  CUT 182×257(Medium)/132×182  DOSU_COD=SID_S PRN_CLR_CNT=4
axes:
  - axis: 표지 자재        # ORD_INFO.MTRL_CD
    choices: [RIBVW350]   # 표지 본문지
    base_data_tag: 자재
  - axis: 코팅        # PCS_COD=COT_DFT
    choices: [TCGLS "유광코팅단면"]
    base_data_tag: 공정(코팅)
  - axis: 재단        # PCS_COD=CUT_DFT
    choices: [DFXXX "재단"]
    base_data_tag: 공정(재단)
  - axis: 내지(속지)        # PCS_COD=INN_DFT   ★자재 다중슬롯
    choices: [INNON "무지노트" ATTB=1]   # ATTB=장수/매수 추정
    cascade: 내지 선택 → 별도 자재(속지) 소비. 본체지(RIBVW350)와 다른 usage.
    base_data_tag: 자재(내지 usage) + 옵션
    note: ★표지(MTRL_CD)와 내지(INN_DFT)가 자재 2슬롯. ATTB=1 = 내지 수량/타입 파라미터(§0.4·§0.3②).
  - axis: 제본(트윈링)        # PCS_COD=RIN_DFT   ★제본 공정 + 링색 variant
    choices: [BPLFT "좌철" ATTB="RIN_BLK"(링색=검정)]
    cascade: 제본방식(트윈링/코일/중철) 택1. 링색은 ATTB로 분기.
    base_data_tag: 공정(제본) + 자재(링=금속부자재) + 옵션(링색 ATTB)
    note: ★RIN_DFT=트윈링제본. ATTB="RIN_BLK"가 링 색상 variant(§0.3②). 제본=자재(링)+공정(꿰기) bundle.
  - axis: 귀돌이(라운드 4모서리)        # PCS_COD=ROU_DFT ×4   ★위치별 4슬롯
    choices: [DFXLT 좌상 ATTB=4, DFXRT 우상 ATTB=4, DFXLB 좌하 ATTB=4, DFXRB 우하 ATTB=4]
    cascade: 모서리별(좌상/우상/좌하/우하) 개별 선택. ATTB=4 = 라운드 반경 4mm.
    base_data_tag: 공정(라운딩) + 옵션(위치 4슬롯 + 반경 ATTB)
    note: ★한 공정(ROU_DFT)이 위치별 4개 PCS 항목으로 분리 + 각자 ATTB=반경(§0.3②). 모서리=위치 슬롯.
  - axis: 인쇄        # PCS_COD=PRT_DFT
    choices: [DFXXS "인쇄단면"]
    base_data_tag: 공정(인쇄)
  - axis: 사이즈(템플릿 프리셋)
    choices: [Medium 182×257, 132×182]   # step1.sizePicked="Medium" / rel7961 작은사이즈
    base_data_tag: 기초코드(사이즈 프리셋)
    note: 같은 MTRL_CD에 사이즈 프리셋만 변동(§0.3③). "삼총사"=사이즈 3종 추정(2종 관측).
```

---

## 5. GSNTSTA — 내 마음의 중철노트 (중철제본·완칼도무송 형상) `[reuse:price-capture]`
source: `s3_rp_GSNTSTA.json` priceCalls[0-2] reqBody/result (line 20·42·58·121). step1.sizePicked="여권형"

```
product: GSNTSTA 내 마음의 중철노트 (GS)   price_gbn: tmpl_price (전 PCS PRICE=0)
base: MTRL_CD=RIBVW350  CUT 132×132(여권형)/88×125  DOSU_COD=SID_S PRN_CLR_CNT=4
axes:
  - axis: 코팅 [COT_DFT TCGLS 유광코팅단면]    base_data_tag: 공정(코팅)
  - axis: 제본(중철)        # PCS_COD=STA_DFT
    choices: [BPLFT "좌철"]
    base_data_tag: 공정(중철제본)
    note: GSNTSPR=RIN_DFT(트윈링), 여기=STA_DFT(중철) — 제본 방식별 다른 PCS_COD. 제본=상호배타 그룹.
  - axis: 완칼도무송(형상/칼틀)        # PCS_COD=THO_CUT   ★형상 variant
    choices: [NT001 "하트형", NT002 "여권형"]   # DTL코드=칼틀 형상
    cascade: 형상 선택(NT001 하트/NT002 여권) → CUT 사이즈 동반 변동(132×132 vs 88×125)
    base_data_tag: 공정(도무송 컷팅) + 기초코드(칼틀 형상) — 형상=칼틀 1:1
    note: ★완칼도무송 형상이 DTL코드 variant(§0.3①). 후니 "도무송 형상=size 칼틀 1:1"(메모리 round-3 K컨펌) 동형. step1.sizePicked="여권형"=THO_CUT NT002와 연동.
  - axis: 내지 [INN_DFT INNON 무지노트 ATTB=1]   base_data_tag: 자재(내지) + 옵션
  - axis: 인쇄 [PRT_DFT DFXXS 인쇄단면]    base_data_tag: 공정(인쇄)
  - axis: 사이즈
    choices: [여권형 132×132, 88×125]
    base_data_tag: 기초코드
    note: 사이즈가 THO_CUT 형상과 캐스케이드(형상↔사이즈 1:1).
```

---

## 6. GSDRSKS — 스케치북 학생용 (코일제본·내지 등급) `[reuse:price-capture]`
source: `s3_rp_GSDRSKS.json` priceCalls[0] reqBody/result (line 20·42·73)

```
product: GSDRSKS 스케치북 학생용 (GS)   price_gbn: tmpl_price (전 PCS PRICE=0)
base: MTRL_CD=RIBVW350  CUT 342×250  DOSU_COD=SID_S PRN_CLR_CNT=4
axes:
  - axis: 코팅 [COT_DFT TCGLS 유광코팅단면]   base_data_tag: 공정(코팅)
  - axis: 내지(속지 등급)        # PCS_COD=INN_DFT
    choices: [SKSTU "학생용속지"]   # ★내지 등급/종류 variant
    base_data_tag: 자재(내지) + 옵션(등급)
    note: GSNTSPR 내지=INNON(무지노트), 여기=SKSTU(학생용속지) — 내지 종류가 DTL variant. 스케치북=두꺼운 속지.
  - axis: 재단 [CUT_DFT DFXXX 재단]   base_data_tag: 공정(재단)
  - axis: 제본(코일링)        # PCS_COD=RIN_COL
    choices: [BPTOP "상철"]   # ★상철(위 제본) — GSNTSPR은 좌철
    base_data_tag: 공정(코일제본) + 자재(코일)
    note: ★RIN_COL(코일링) ≠ RIN_DFT(트윈링) ≠ STA_DFT(중철) — 제본 PCS_COD가 방식별 3종. 상철/좌철=제본 방향 variant.
  - axis: 인쇄 [PRT_DFT DFXXS 인쇄단면]   base_data_tag: 공정(인쇄)
```

---

## 7. GSPUFBC — 노트북/태블릿 파우치-패브릭 코튼 (제품가공·지퍼) `[reuse:price-capture]`
source: `s3_rp_GSPUFBC.json` priceCalls[0,2] reqBody/result (line 20·42·57). step1.sizePicked="13인치 - 가로형"

```
product: GSPUFBC 노트북/태블릿 파우치-패브릭 코튼 (GS)   price_gbn: tmpl_price (전 PCS PRICE=0)
base: MTRL_CD=PXFBW010(패브릭 코튼)  CUT 230×288(13인치 세로)/330×250(가로)  DOSU_COD=SID_S PRN_CLR_CNT=4
axes:
  - axis: 본체 자재(패브릭 코튼)        # ORD_INFO.MTRL_CD
    choices: [PXFBW010]   # PTT=FBW(패브릭/코튼 추정), MTRL_TYPE=P
    base_data_tag: 자재(패브릭 코튼 소재)
    note: ★상품명 "패브릭 코튼"이 소재. PXFBW... 합성코드(BN MTRL 4축 패턴). 파우치 6소재(코튼/레더/네오프렌 등) 중 코튼.
  - axis: 재단 [CUT_DFT DFXXX 재단]   base_data_tag: 공정(재단)
  - axis: 제품가공(파우치 봉제/조립)        # PCS_COD=PDT_WRK   ★완제 굿즈 조립 공정
    choices: [PUBOK "노트북-태블릿 파우치가공"]
    base_data_tag: 공정(제품가공/봉제조립)
    note: ★PDT_WRK = 평면 인쇄물 → 입체 파우치로 봉제/조립하는 공정. BN엔 없던 "본체 형태 가공" 축. 후니 본체조립 BOM 동형.
  - axis: 지퍼가공        # PCS_COD=FLX_ZIP
    choices: [ZPH01 "지퍼가공 세로형"]   # 방향 variant(세로형)
    base_data_tag: 공정(지퍼부착) + 자재(지퍼=부자재) + 옵션(방향)
    note: ★지퍼=부자재(지퍼)+부착공정 bundle. 세로형/가로형 방향이 DTL variant. 파우치 특유 축.
  - axis: 인쇄 [PRT_DFT DFXXS 인쇄단면]   base_data_tag: 공정(인쇄)
  - axis: 사이즈(기종/방향 프리셋)
    choices: [13인치 가로형 230×288, 가로 330×250]   # step1="13인치 - 가로형"
    base_data_tag: 기초코드(기종 프리셋) + 제약
    note: ★기종(13인치/15인치) × 방향(가로/세로) 복합 사이즈 프리셋. 폰케이스 "기종 variant"의 파우치판.
```

---

## 8. GSTGMIC — 마이크 네임택 (★tiered_price·부자재작업·S/L 합일 variant) `[reuse:price-capture]`
source: `s3_rp_GSTGMIC.json` priceCalls[0-2] reqBody/result (line 20·26·104·137). step1.sizePicked="삼각 마이크 네임택L". ★유일 tiered_price 샘플

```
product: GSTGMIC 마이크 네임택 (GS)   price_gbn: tiered_price (인쇄 S=6000 / L=7000)
base: MTRL_CD=RXBVW300(인쇄지)  CUT 351×241(S)/351×291(L)  DOSU_COD=SID_S PRN_CLR_CNT=4
axes:
  - axis: 부자재작업(스펀지 + S/L 사이즈)   # PCS_COD=WRK_MTR   ★사이즈·자재·칼틀 합일 variant
    choices: [TG001 "삼각 마이크텍 스펀지 S", TG003 "삼각 마이크텍 스펀지 L"]
    cascade: ★DTL코드(TG001/TG003)가 동시 분기 — WRK_MTR 스펀지 S/L + THO_CUT 칼틀 S/L + CUT 사이즈(241/291) + 인쇄가(6000/7000)
    base_data_tag: 자재(스펀지 부자재) + 기초코드(사이즈 S/L) + 옵션
    note: ★한 DTL코드(TG001=S, TG003=L)가 사이즈·부자재·칼틀·가격을 동시 결정 — 가장 강한 variant 합일(§0.3①). 후니 SKU variant 모델 핵심 케이스.
  - axis: 코팅 [COT_DFT TCGLS 유광코팅단면]   base_data_tag: 공정(코팅)
  - axis: 제품가공(조립)        # PCS_COD=PDT_WRK
    choices: [PKT01 "마이크텍 조립"]
    base_data_tag: 공정(제품가공/조립)
    note: GSPUFBC PDT_WRK와 동일 축(본체 조립). 마이크텍=인쇄물+스펀지 조립.
  - axis: 폴리백 개별포장        # PCS_COD=PAK_POL
    choices: [DFXXX "폴리백 개별포장"]   # PRICE=0
    base_data_tag: 공정(포장) 또는 옵션
    note: GSTBMWM=PAK_ETC, 여기=PAK_POL(폴리백) — 포장방식별 다른 PCS_COD.
  - axis: 완칼도무송(칼틀 S/L)        # PCS_COD=THO_CUT
    choices: [TG001 "삼각 마이크텍 S", TG003 "삼각 마이크텍 L"]   # ★WRK_MTR과 같은 DTL코드
    base_data_tag: 공정(도무송) + 기초코드(칼틀)
    note: ★THO_CUT DTL = WRK_MTR DTL과 동일(TG001/TG003) — 부자재·칼틀이 같은 variant 키 공유.
  - axis: 인쇄(가격 주체)        # PCS_COD=PRT_DFT
    choices: [DFXXS "인쇄단면"]   # ★PRICE=6000(S)/7000(L) — tiered_price 주체
    price_flag: ★tiered_price에선 PRT_DFT(인쇄)가 PRICE 주체. PRICE_LOG에 "자재단가" 필드 추가.
    base_data_tag: 공정(인쇄, 유료·구간가)
    note: ★DIR_MTR(완제본체) 없는 굿즈 = 인쇄(PRT_DFT)가 가격 주체. tiered = 수량구간 단가(메모리 구간할인 동형).
```

---

## 9. GSTTDTM·GSPLCST·GSTTCRK·GSTTPAP·GSTTACR·GSTTREZ — 코스터 6소재 군 (★자재 축 정점) `[live:catalog]` `[live:SSR-negative]`
source: `redprinting_catalog.json` 상품명·URL (2026-06-17 확인). 옵션 트리 = 신규 Vue client-render → **라이브 추출 불가**(`[live:SSR-negative]`).

```
★ 같은 "코스터" 상품정체가 본체 소재별로 6개 별도 pdtCode로 분기 — RedPrinting 자재 관리축의 정점.
| pdtCode | 상품명 | 본체 소재(추정 PTT축) | base_data_tag |
| GSTTDTM | 규조토 코스터 | 규조토(diatomite) | 자재(본체 소재) + 카테고리(코스터) |
| GSPLCST | 펠트 코스터 | 펠트(felt) | 자재 + 카테고리 |
| GSTTCRK | 코르크 코스터 | 코르크(cork) | 자재 + 카테고리 |
| GSTTPAP | 종이 코스터 | 종이(paper) | 자재 + 카테고리 |
| GSTTACR | 아크릴 코스터(모양) | 아크릴(acrylic) + 모양(형상) | 자재 + 공정(도무송 형상) + 카테고리 |
| GSTTREZ | 레더 코스터 | 레더(leather) | 자재 + 카테고리 |

axes (소재별 공통 — 옵션 트리는 unobserved, 패턴은 §0·타굿즈 캡처에서 유추):
  - axis: 본체 소재        # ★상품정체="코스터", 소재가 pdtCode 분기축
    choices: [규조토/펠트/코르크/종이/아크릴/레더]   # ★6소재 = 6 pdtCode (자재가 상품을 가름)
    cascade: 소재 선택 = 상품(pdtCode) 선택 — RedPrinting은 소재를 옵션이 아닌 별도 상품으로 분리
    price_flag: 소재별 다른 MTRL_CD → 다른 개당단가 (unobserved, tmpl_price 추정)
    base_data_tag: 자재(본체 소재 — RedPrinting은 pdtCode 레벨 분리) ★vs 후니: 소재 옵션화 검토 대상
    note: ★메타모델 핵심 질문 — "같은 기능(코스터)·다른 소재"를 ① 별도 상품(RedPrinting 방식) ② 한 상품의 소재 옵션(후니 잠재) 중 어디로 관리? RedPrinting=상품 분리(소재가 본체정체). 모호 fragment 등재.
  - axis: 완칼도무송(아크릴 코스터만 "모양")   # GSTTACR
    choices: unobserved (도무송 형상 칼틀 추정 — GSNTSTA THO_CUT 동형)
    base_data_tag: 공정 + 기초코드(형상)
    note: 아크릴 코스터만 "(모양)" — 형상 선택 동반. 타 소재는 정형(원/사각).
  - axis: 인쇄/사이즈/수량
    choices: unobserved (라이브 client-render·BFF 익명불가)
    note: §0 굿즈 공통 패턴(DIR_MTR 본체 + PRT_DFT 인쇄 + tmpl_price) 추정. 실측 아님.
```
**메타모델 시사점:** RedPrinting은 **본체 소재를 pdtCode 레벨로 분리**(소재≠옵션, 소재=상품정체). 후니는 굿즈 본체 소재 컬럼 부재(메모리 round22)라 이 6소재가 상품명에만 존재 → 정합 위해 "소재=상품 분리" vs "소재=옵션" 결정 필요. ★`_ambiguous-fragments.md` G-2 등재.

---

## 10. GSCAPHN — 폰케이스 (일반/터프) `[live:catalog]` `[live:SSR-negative]`
source: `redprinting_catalog.json` GSCAPHN "폰케이스 (일반/터프)". 옵션 트리 라이브 추출 불가.

```
product: GSCAPHN 폰케이스 (일반/터프) (GS)   ★후니 미등록 영역
axes:
  - axis: 케이스 타입(일반/터프)   # 상품명 "(일반/터프)"
    choices: [일반, 터프]   # 케이스 구조/강도 variant (상품명 노출)
    base_data_tag: 자재(케이스 본체 타입) 또는 옵션
    note: 일반(슬림)/터프(범퍼) = 본체 구조 variant. GSCAGB*(글라스 범퍼) 군과 별개.
  - axis: 기종(폰 모델)   # ★폰케이스 특유 — 수십 기종 variant
    choices: unobserved (갤럭시/아이폰 수십 기종 추정 — 기종별 칼틀/사이즈)
    base_data_tag: 기초코드(기종 enum) + 제약(기종↔사이즈/칼틀 캐스케이드)
    note: ★기종 = 대규모 enum variant. 기종 선택 → 사이즈·도무송 칼틀 캐스케이드(GSNTSTA THO_CUT 형상 동형, 규모 큼). 후니 미등록 → 메타모델 "기종 축" 신규 필요.
  - axis: 인쇄/도수/수량
    choices: unobserved (라이브 client-render)
    note: §0 패턴(DIR_MTR 본체케이스 + PRT_DFT) 추정.
```
**메타모델 시사점:** 폰케이스 = **기종(device model) 대규모 enum variant** + 케이스타입(일반/터프). 후니 미등록 신영역. 기종↔칼틀/사이즈 캐스케이드 = 메타모델 신축 후보(`_ambiguous-fragments.md` G-3).

---

## 11. GSNTLTR — 레더 노트 (레더 본체자재·후니 BATCH-4 정합) `[live:catalog]` `[live:SSR-negative]`
source: `redprinting_catalog.json` GSNTLTR "레더 노트". GSNTLTR SSR GET=빈응답(client-render). 옵션 라이브 불가.

```
product: GSNTLTR 레더 노트 (GS)   ★레더 본체자재 — 후니 round-22 BATCH-4(레더 .06) 정합
axes:
  - axis: 본체 자재(레더)        # 상품명 "레더"
    choices: [레더(leather)]   # MTRL_CD 레더 (unobserved, GSDRSKS류 RIBVW 아닌 레더코드 추정)
    base_data_tag: 자재(레더 본체 소재)
    note: ★레더 = 후니 자재모델 BATCH-4(레더 .06·메모리 round22 "명확분 41상품 레더23 COMMIT") 정합. 레더는 후니 등록 소재 — RedPrinting MTRL_CD↔후니 mat_cd 대조 가능 굿즈.
  - axis: 제본/내지/사이즈/인쇄
    choices: unobserved (라이브 client-render)
    note: §4 GSNTSPR(스프링노트) 구조 추정 — 표지(레더)+내지(INN_DFT)+제본(RIN/STA)+귀돌이(ROU). 레더는 표지 자재.
```
**메타모델 시사점:** 레더는 후니 등록 소재(round-22 레더 23상품 라이브 COMMIT) → RedPrinting 레더 굿즈가 **후니 자재모델 정합 검증 굿즈**. 본체소재=레더가 명확히 자재축(코스터 6소재 모호성과 대비 — 레더는 후니 정답 존재).

---

## 12. GSSKHND — 효자손 (순수 완제 굿즈·본체 소재) `[live:catalog]` `[live:SSR-negative]`
source: `redprinting_catalog.json` GSSKHND "효자손". 옵션 라이브 불가(client-render).

```
product: GSSKHND 효자손 (GS)   ★순수 완제 굿즈(인쇄 부가) — 본체 소재 = 굿즈 정체
axes:
  - axis: 본체(효자손 완제품)        # PCS_COD=DIR_MTR 추정
    choices: unobserved (효자손 본체 SKU — 우드/플라스틱 소재 추정)
    base_data_tag: 자재(본체 소재) + 템플릿/SKU
    note: ★효자손 = 인쇄가 부가인 순수 완제 굿즈. 본체 소재(우드/플라스틱)가 상품명에만 — §0.2 후니 본체소재 부재 동형. GSTBMWM(텀블러)처럼 DIR_MTR 본체가 가격 주체 추정.
  - axis: 인쇄(로고/이름)
    choices: unobserved
    note: 효자손 손잡이 인쇄 추정. §0 tmpl_price 개당단가 + PRT_DFT 추정.
```
**메타모델 시사점:** 효자손 = **인쇄가 종속·본체가 주체인 완제 굿즈** 극단 케이스. 본체 소재(우드 등)가 상품명에만 존재(코스터·텀블러 동형). "굿즈 = 완제 본체 + 인쇄 부가" 모델 = 후니 굿즈 결함영역 핵심.

---

## 13. base-data 축 횡단 종합 (메타모델 아키텍트 입력 — GS 추가분, BN 표와 병합)

| 관리 축 | RedPrinting 표현(GS) | base_data_tag | 메타모델 흡수 단위 | BN 대비 신규? |
|---------|---------------------|---------------|-------------------|--------------|
| **완제 본체 SKU** | `DIR_MTR`(부자재직접인쇄)·`WRK_MTR`(부자재작업) PCS 항목 = 굿즈 본체. PCS_DTL_NME=완제품명. PRICE 주체 | 자재 + 템플릿/SKU | ★굿즈 본체=공정성 항목으로 모델. 소재/색/용량/두께가 DTL_NME 융합 | ★신규(BN 본체=ORD_INFO MTRL) |
| **본체 소재(완제)** | 코스터 6소재=6 pdtCode / 레더노트 / 효자손 / 파우치 PXFBW(코튼) | 자재(본체 소재) | ★소재=pdtCode 분리 vs 옵션화 결정. 후니 본체소재 컬럼 부재 정합 | ★신규(GS 핵심 결함) |
| **variant 인코딩** | ① DTL코드(색 MLS01·S/L TG001/3) ② ATTB(링색 RIN_BLK·반경 4) ③ CUT 사이즈 | 옵션 + 기초코드 | 3채널 variant 구분 모델(SKU코드/파라미터/차원) | ★신규(BN 형상=자재명 융합뿐) |
| **자재 usage 다중슬롯** | `MTRL_CD`(표지) + `INN_DFT`(내지) + `RIN_DFT`(링) + `WRK_MTR`(스펀지) 동시 | 자재(usage별) | usage_cd별 자재 소비(후니 BUNDLE 동형) | ★신규(BN 단일 MTRL) |
| **제본** | `RIN_DFT`(트윈링)·`RIN_COL`(코일)·`STA_DFT`(중철) 방식별 PCS_COD + 좌철/상철(방향) | 공정 + 자재(링/코일) bundle | 제본방식=상호배타 그룹, 방향=variant | ★신규 |
| **본체 형태 가공** | `PDT_WRK`(파우치가공·마이크텍조립)·`FLX_ZIP`(지퍼) | 공정(조립/봉제) + 자재(지퍼) | 평면→입체 본체 조립 공정 | ★신규 |
| **완칼도무송 형상** | `THO_CUT`(하트/여권 NT001/2·삼각 S/L TG001/3) DTL=칼틀 | 공정 + 기초코드(형상) | 형상=칼틀 1:1(후니 K컨펌 동형)·사이즈 캐스케이드 | (BN 모양재단 확장) |
| **기종(device)** | 폰케이스 기종 enum(unobserved) | 기초코드(enum) + 제약(기종↔칼틀) | 대규모 기종 variant + 캐스케이드 | ★신규(후니 미등록) |
| **가격 모델** | `tmpl_price`(개당단가)·`vTmpl_price`(variant)·`tiered_price`(구간+자재단가) | (가격 엔진) | 완제 SKU 개당가 + 구간가, 면적형(BN)과 별개 | ★신규(BN=real_price만) |
| 도수 | `SID_X`(텀블러 무인쇄)·SID_S | 기초코드 | 도수 enum에 X(없음) | (BN SID_S 확장) |
| 포장 | `PAK_ETC`(텀블러)·`PAK_POL`(폴리백) 방식별 PCS_COD·유료(장패드 1000) | 옵션/공정 | 포장방식 variant·개당 과금 | (BN PKG_GB 확장) |

### 핵심 패턴 (RedPrinting의 굿즈 정규화 방식 — BN과 다른 패러다임)
1. **굿즈 본체 = 공정성 항목(DIR_MTR/WRK_MTR)** — BN은 본체=자재(ORD_INFO.MTRL_CD), GS는 본체=완제 SKU를 PCS_INFO 항목으로. PRICE 주체. 소재/색/용량/두께가 PCS_DTL_NME에 융합 → 후니 "굿즈 본체소재 상품명에만"(round-22 GPM) 정확히 동형.
2. **본체 소재 = pdtCode 분리** — 코스터 6소재가 6상품. RedPrinting은 소재를 옵션이 아닌 상품정체로. 후니 정합 시 "소재=상품 분리 vs 소재=옵션" 결정(아키텍트 핵심 의사결정).
3. **variant 3채널** — DTL코드(SKU variant)·ATTB(파라미터)·CUT(차원). 한 DTL코드가 사이즈·자재·칼틀·가격 동시 결정(GSTGMIC TG001/3) = 강결합 SKU variant.
4. **자재 usage 다중슬롯** — 표지/내지/링/스펀지가 각 PCS_COD로 분산. 후니 usage_cd BUNDLE 동형.
5. **본체 형태 가공 축(PDT_WRK/FLX_ZIP)** — 평면 인쇄물→입체 굿즈 조립/봉제/지퍼. BN(평면 배너)엔 없던 굿즈 특유 공정.
6. **가격 모델 3종 분기** — tmpl/vTmpl/tiered. 같은 옵션 모델 위 개당단가·구간가. 면적형(BN)과 공존해야.

## 라이브 접속 결과 (정직 기록)
- **GS 신규 Vue 상품 옵션 트리**: 4 live-augment 상품(코스터/폰케이스/레더노트/효자손) 모두 client-render — SSR HTML에 `km1_size`(전역 샘플 select)만 노출, 실제 옵션 미노출. BFF `get_digital_product_info` 익명 호출=error page. → **옵션 상세 라이브 추출 불가**(BN 신규 Vue와 동일 한계). 상품정체·소재축은 catalog 상품명으로 확정, 옵션 상세는 `unobserved` 명시.
- **8 reuse 상품**(텀블러·마스크끈·장패드·스프링노트·중철노트·스케치북·파우치·마이크네임택): huni-widget s3 가격캡처 실측 풀 추출(reqBody/result/query). 가격 API 호출이 옵션 조합을 그대로 담아 BN SSR보다 깊은 PCS 트리 확보.
