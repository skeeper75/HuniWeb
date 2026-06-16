# 모호 fragment — 버킷 분류 미확정 (아키텍트 해소)

> rpm-reverse-engineer가 base-data 7버킷(자재/공정/옵션/템플릿/제약/기초코드/카테고리)으로 깔끔히 분류 못한 fragment.
> 강제 분류 금지(SKILL.md §5) — 아키텍트가 메타모델 추상화 시 확정. 각 항목 출처·후보버킷·쟁점 명시.

## A-1. CDL_DFT 거치대 — 템플릿/SKU vs 옵션 vs 부속물
- 출처: BNSTDFT/BNRLSLV `[live:SSR]` CDL_DFT_SELECT.
- 관측: 거치대(롤업거치대600/850/1000, 실내/실외 8종)가 PCS_COD(후가공) 그룹으로 묶이지만, 실제로는 **인쇄 본체와 별개 완제품**.
- 쟁점: ① 후가공 공정인가(본체에 가하는 작업 아님) ② 완제 SKU/부속물인가(독립 상품) ③ 옵션(택1)인가.
- 후보버킷: 템플릿/SKU(우세) — 본체+거치대 = 번들 주문. 후니 `templates`/`addons` 대조 필요.
- 쟁점2: BNRLSLV에서 거치대 폭(600/850/1000)이 size 프리셋과 1:1 → **부속물↔사이즈 캐스케이드 제약** 동반. SKU+제약 복합.

## A-2. number4_sel "N배" — 디자인 수(건수)? 수량 배수?
- 출처: BNSTDFT/BNBNSOD/BNRLSLV/BNPTMAS/BNTNHVY `[live:SSR]`.
- 관측: number1_sel(1~10) + number4_sel("1배"~"10배") 이중 수량 select. Vue측 skinInfo는 ORD_CNT="디자인 수(건수)" + PRN_CNT="수량".
- 쟁점: "N배"가 디자인 종류 수(건수)인지, 동일디자인 수량 배수인지 SSR 라벨만으론 불명확. 가격기여 방식(건수=세팅비? 배수=선형?) 미관측.
- 후보버킷: 옵션(수량) — 단, **수량 축이 2개(건수×수량)**라는 구조가 단일 qty 모델과 충돌. 메타모델에 이중 수량축 필요 여부 판단.

## A-3. 어깨띠 자재명 "부직포어깨띠" — 소재+형상 융합
- 출처: BNBNSOD `[live:SSR]` paper=PXVGP001 "부직포어깨띠".
- 관측: 자재명에 소재(부직포)와 상품형상(어깨띠)이 한 라벨로 융합. MTRL_CD=PXVGP001(PTT=VGP).
- 쟁점: PTT 코드가 소재인가 상품형상인가. 다른 BN은 PTT=소재(BFC현수막/MAS매쉬/TFC텐트천)인데 현수막/매쉬/텐트천도 "소재 겸 상품군명". 즉 RedPrinting의 PTT = 소재≈상품정체 혼재.
- 후보버킷: 자재(PTT축) — 단 후니 매핑 시 "소재 vs 상품형상" 분리 여부 결정. (메모리 `dbmap-material-option-normalization`: 형상=자재 오염 주의).

## A-4. 인쇄방식(수성/라텍스) — 자재 분기 vs 별도 공정축
- 출처: BNRLSLV(PXBOPXXX 수성용 vs PXBOPTEX 라텍스용), BNTNHVY(PXTFCXXX 수성 vs PXTFLXXX 라텍스).
- 관측: 동일 소재(블락아웃PET/텐트천)가 인쇄방식(수성잉크/라텍스잉크)별로 **다른 MTRL_CD**로 분기.
- 쟁점: 인쇄방식이 ① 자재의 일부(현 RedPrinting 표현) ② 별도 print-method 옵션축 ③ 도수의 하위.
- 후보버킷: 자재(현 표현) 또는 옵션(print-method). 메모리 `dbmap-print-method-not-absolute-axis`(인쇄방식 절대축 아님) 참조 — 강제 분리 금지.

## A-5. PKG_GB 포장 "말아서 포장 필수" — 제약 vs 공정
- 출처: BNTNHVY `[live:SSR]` PKG_GB=[PKG_RUP 말아서 포장 필수] (단일 강제값).
- 관측: 두꺼운 소재(텐트천)가 강제하는 포장방식. 선택 불가(필수 단일).
- 쟁점: ① 가격기여 공정(포장비)인가 ② 단순 제약(소재→포장 고정 규칙, 무가격)인가.
- 후보버킷: 제약(소재→포장 강제) 우세. 가격기여 미관측(PRICE=0). 공정-포장 이중성.

## A-6. SUB_MTR "추가부자재"(QTY_INPUT_YN=Y) — 자재공정bundle + 수량 3중
- 출처: 전 BN `[reuse:Vue-BFF]`/`[live:SSR]` SUB_MTR=[CT001 큐브 양면 젤리테이프].
- 관측: SUB_MTRL_YN=Y(부자재) + QTY_INPUT_YN=Y(수량입력) + PCS_COD(후가공그룹). 세 플래그 동시.
- 쟁점: 부자재(자재) + 부착(공정) + 수량(옵션) 3축 결합을 단일 옵션으로 볼지 분해할지.
- 후보버킷: 자재공정bundle(메모리 `dbmap-option-material-process-bundle` 동형) + 수량 슬롯. 아일렛(금속링+타공)과 같은 패턴이나 수량입력 추가.

## A-7. number_sel_ROP_DFT — 후가공 종속 수량 슬롯
- 출처: BNTNHVY `[live:SSR]` 로프(ROP_DFT)에 종속된 number_sel(USER/1~10).
- 관측: 후가공(로프)이 자체 수량입력 select 보유 = QTY_INPUT_YN=Y의 SSR 렌더.
- 쟁점: 수량이 상품수량(PRN_CNT)이 아니라 **특정 공정에 종속된 파라미터 수량**. 메타모델에서 공정 파라미터(param) 슬롯 필요.
- 후보버킷: 옵션(공정 param 수량). 공정에 매개변수가 붙는 구조 — 후니 ref_param_json/공정 param 대조.

---

# GS(굿즈/잡화) 추가 모호 fragment

## G-1. DIR_MTR / WRK_MTR "부자재직접인쇄/부자재작업" — 자재 vs 공정 vs 템플릿/SKU
- 출처: GSTBMWM·GSMLSLC·GSPDLNG·GSDRSKS `DIR_MTR`(PCS_DTL_NME=완제품명·PRICE 주체), GSTGMIC `WRK_MTR`(스펀지) `[reuse:price-capture]`.
- 관측: 굿즈 본체(텀블러/실리콘끈/장패드/스펀지)가 **PCS_INFO(후가공) 항목**으로 들어가지만 실제론 완제 본체 자체이고 result의 PRICE 주체(텀블러 45000 등).
- 쟁점: ① 자재(본체 소재)인가 ② 공정("직접인쇄"라는 작업)인가 ③ 템플릿/완제 SKU인가. RedPrinting은 셋을 한 PCS_COD에 융합.
- 후보버킷: 자재+템플릿/SKU 복합(우세). 후니 "굿즈 본체소재 컬럼 부재·소재가 상품명에만"(메모리 `dbmap-axis-staged-load-round22` GPM) 정확히 동형 → 아키텍트가 본체를 별도 엔티티(완제 SKU)로 분리할지 결정.
- 쟁점2: PCS_DTL_NME에 소재·색·용량·두께·브랜드가 융합("미르 와이드마우스 보틀 화이트 20oz") — 후니 자재오염(색/형상/용량이 자재행)과 동근. 분해축 정의 필요.

## G-2. 코스터 6소재 = 6 pdtCode — 본체 소재를 상품 분리 vs 옵션화
- 출처: GSTTDTM/GSPLCST/GSTTCRK/GSTTPAP/GSTTACR/GSTTREZ `[live:catalog]`.
- 관측: 동일 기능(코스터)이 본체 소재(규조토/펠트/코르크/종이/아크릴/레더)별로 **6개 별도 pdtCode**. RedPrinting은 소재를 옵션이 아닌 상품정체로 분리.
- 쟁점: 메타모델에서 "같은 기능·다른 소재"를 ① 별도 상품(RedPrinting 방식·카테고리는 같음) ② 한 상품의 소재 옵션(자재 차원) 중 어디로? 후니는 굿즈 본체소재 컬럼 부재라 현재 상품명에만 존재.
- 후보버킷: 자재(본체 소재) + 카테고리(코스터=공통 기능 그룹). 핵심 결정 — 소재 옵션화하면 카탈로그 6→1 축소·variant로, 상품 유지하면 RedPrinting 답습. 아키텍트가 후니 관리용이성 기준 판정.
- 쟁점2: GSTTACR(아크릴 코스터 "모양")만 도무송 형상 동반 — 소재에 따라 옵션 축이 달라짐(아크릴=형상 추가). 소재가 후속 옵션을 캐스케이드.

## G-3. 폰케이스 기종(device model) enum — 기초코드 vs 제약 캐스케이드 규모
- 출처: GSCAPHN "폰케이스(일반/터프)" `[live:catalog]` (옵션 상세 unobserved).
- 관측: 폰케이스는 기종(갤럭시/아이폰 수십종)별 칼틀·사이즈 분기 추정. 후니 미등록 신영역.
- 쟁점: 기종이 ① 단순 기초코드(enum) ② 기종→사이즈/칼틀 캐스케이드 제약 ③ 기종별 별도 템플릿(SKU)인가. enum 규모(수십~수백)가 다른 축과 질적으로 다름.
- 후보버킷: 기초코드(기종 enum) + 제약(기종↔칼틀 캐스케이드). 대규모 enum을 메타모델이 차원으로 둘지 SKU 분리할지(코스터 G-2와 같은 질문의 변형) — 단 기종은 옵션화 우세(소재와 달리 기능 동일).
- 쟁점2: "일반/터프"(케이스 구조 강도)는 기종과 직교하는 별도 variant — 기종×타입 2축 복합. 미관측이라 규모·캐스케이드 방향 확정 불가(`unobserved`).

## G-4. variant 3채널(DTL코드 / ATTB / CUT) — 단일 variant 모델로 통합 가능?
- 출처: GSMLSLC DTL=색, GSTGMIC DTL=S/L(사이즈+자재+칼틀 합일), GSNTSPR ATTB=링색/반경, GSNTSTA CUT+THO_CUT=형상 `[reuse:price-capture]`.
- 관측: 같은 "variant" 개념이 ① DTL코드(별도 SKU성) ② ATTB(옵션 파라미터) ③ CUT_WDT/HGH(차원) 세 채널로 분산 인코딩. GSTGMIC TG001/3은 한 DTL이 사이즈·자재·칼틀·가격 동시 결정(강결합).
- 쟁점: 메타모델이 variant를 단일 추상(예: option_item + ref_param)으로 통합할지, 아니면 ① SKU variant ② param variant ③ 차원 variant 3종을 명시 구분할지.
- 후보버킷: 옵션(다채널) — 후니 CPQ polymorphic ref_dim_cd(메모리 `dbmap-cpq-option-layer-mapping`)와 대조. ★GSTGMIC 같은 "1코드 다속성 합일"이 정규화 난점(한 선택이 자재+사이즈+칼틀+가격 동시 변경).

## G-5. INN_DFT / RIN_DFT / RIN_COL / STA_DFT — 자재 usage 슬롯 + 제본방식 그룹
- 출처: GSNTSPR(INN_DFT 내지·RIN_DFT 트윈링), GSDRSKS(INN_DFT 학생속지·RIN_COL 코일), GSNTSTA(STA_DFT 중철) `[reuse:price-capture]`.
- 관측: 내지(INN_DFT)는 표지와 다른 자재 usage 슬롯. 제본은 방식별로 PCS_COD가 다름(RIN_DFT 트윈링·RIN_COL 코일·STA_DFT 중철) — 상호배타 택1 그룹인데 코드가 분리.
- 쟁점: ① 내지=자재(별 usage)인가 옵션인가 ② 제본 3방식이 한 "제본 그룹"의 택1 옵션인가, 각자 독립 공정인가(PCS_COD가 다르므로 그룹화 단서 약함).
- 후보버킷: 내지=자재(usage_cd 슬롯), 제본=공정+자재(링/코일) bundle. ★제본방식이 PCS_COD 레벨로 분리됨 = 메타모델이 "제본 그룹(택1)"을 어떻게 묶을지(RedPrinting은 그룹 메타 없이 코드만 다름). 후니 옵션그룹(택1) 대조.

## G-6. PDT_WRK / FLX_ZIP "제품가공/지퍼가공" — 본체 형태 조립 공정의 버킷
- 출처: GSPUFBC(PDT_WRK 파우치가공·FLX_ZIP 지퍼 세로형), GSTGMIC(PDT_WRK 마이크텍 조립) `[reuse:price-capture]`.
- 관측: 평면 인쇄물을 입체 굿즈(파우치/마이크텍)로 봉제·조립하는 공정. BN(평면 배너)엔 전무한 굿즈 특유 축.
- 쟁점: ① 순수 공정(조립 작업)인가 ② 지퍼처럼 부자재(지퍼) 소비 동반 bundle인가 ③ 본체 정체와 묶인 필수 공정(파우치는 가공 없으면 평면지)인가.
- 후보버킷: 공정(본체 조립) — FLX_ZIP은 자재(지퍼)+공정 bundle(아일렛 동형). ★"본체 형태 가공"이 후니 굿즈 BOM(평면→입체 조립 단계)에 필요한 신규 공정 카테고리. 방향(세로/가로)은 variant.

## G-7. 가격모델 3종(tmpl_price/vTmpl_price/tiered_price) — 옵션 모델과의 결합 방식
- 출처: 캡처 reqBody `price_gbn` + query SP명 (`WSP_..._TMPL_PCS_PRICE` vs `..._TIERED_PRICE`) `[reuse:price-capture]`.
- 관측: tmpl(개당단가)·vTmpl(variant 템플릿)·tiered(구간+자재단가 PRICE_LOG). 같은 옵션 모델 위 다른 가격 SP. tiered만 PRICE_LOG에 "자재단가" 필드.
- 쟁점: 가격모델 선택이 ① 상품 속성(price_gbn)인가 ② 옵션 조합 결과인가. vTmpl과 tmpl 차이(variant 유무?)가 옵션 구조에 다시 영향 주는지 미확정.
- 후보버킷: (가격 엔진 — base_data 버킷 외) 단 옵션 모델과 결합하므로 아키텍트가 "옵션→가격모델 라우팅" 정의 필요. 면적형(BN real_price)과 공존. 본 추출은 옵션 구조 중심이라 가격 SP 내부 로직은 `unobserved`(PRICE_LOG 외).

## G-8. 포장 PCS_COD 다중(PAK_ETC/PAK_POL) + 유료/무료 혼재 — 옵션 vs 공정
- 출처: GSTBMWM(PAK_ETC 텀블러패키징 PRICE=0), GSTGMIC(PAK_POL 폴리백 PRICE=0), GSPDLNG(PAK_ETC 개별포장 PRICE=1000 유료) `[reuse:price-capture]`.
- 관측: 포장이 방식별로 다른 PCS_COD(PAK_ETC/PAK_POL)이고, 같은 PAK_ETC라도 상품에 따라 무료(텀블러)/유료(장패드 1000)로 갈림.
- 쟁점: 포장이 ① 선택 옵션(유료 add-on)인가 ② 본체 종속 공정(무료 포함)인가. 같은 코드가 상품별 가격 다름 = 단가행이 상품×포장 조합.
- 후보버킷: 옵션 또는 공정(포장) — BN PKG_GB(강제 제약)와 달리 GS는 선택+개당 과금 경향. 아키텍트가 포장을 옵션(유료)/공정(무료) 통합 모델로 둘지 결정.
