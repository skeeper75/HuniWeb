# RP 옵션 원자 추출 — CL(의류·티셔츠·앞치마·가방류) 카테고리

> 후니 RP-Meta 하네스 파이프라인 ① 산출물 (rpm-reverse-engineer).
> RedPrinting CL 카테고리(30상품)를 **base-data 관리 렌즈**로 역공학한 원자 옵션 레코드.
> 목적 = 메타모델 아키텍트가 "RedPrinting이 의류 옵션을 어떤 관리 축으로 분리·정규화하는가"를 추상화할 원재료.
> RedPrinting은 사용자 본인 설계 시스템(검증된 참조 모델 — 답습 아님).
> **핵심 directive: 기존 17축에서 미발굴된 distinct 축 발굴 — 특히 의류 variant(사이즈 grid·색상·원단 oz)·인쇄위치(앞/뒤/소매)·인쇄방식(DTF/실크/직접)·완제SKU vs 단체. ★최대 관전 포인트: 의류 variant가 distinct 신규 축 #18인가, GS variant 축의 facet인가.**

## 출처 표기 규칙
- `[reuse:productInfo]` = huni-widget 05_qa 캡처(`major_apparel_CLSTSHS.json`·`major_apparel_CLTMSHS.json`)의 `rawProductData.result`(product_data + ★`apparel_info` 전용 구조) 실측. **신규 Vue3 위젯 `get_*_product_info` 풀 응답**.
- `[reuse:price-capture]` = huni-widget 05_qa `clstshs_price.json`의 가격요청 reqBody(ORD_INFO/PCS_INFO)·respBody(result/result_sum/query) 실측. 가격 API `WSP_ACPT_ORDER_TMPL_PCS_PRICE` + `price_gbn="clothes2025_price"`.
- `[live:SSR]` = 2026-06-17 라이브 읽기전용 GET `/ko/product/item/CL/{code}` 결과 — **레거시 jQuery 상품(CLAPDFT)** SSR `<select>`·radio chip 실측 추출 성공.
- `[live:SSR-negative]` = 2026-06-17 라이브 GET 결과 — 신규 Vue 상품(CLDFSHS 등)은 옵션 client-render(SSR엔 전역 `km1_size`만), 옵션 트리 라이브 추출 불가.
- `[live:catalog]` = `raw/widget_monitor/redprinting_catalog.json` 상품명·URL (2026-06-17 확인).
- `unobserved` = 미관측(날조 금지). 의류 도메인 일반지식(S/M/L 등)으로 옵션을 날조하지 않음 — 실측분만 기록.

## base_data_tag 7버킷 (가설 — 아키텍트가 최종 확정)
자재(material) / 공정(process) / 옵션(option) / 템플릿(template/SKU) / 제약(constraint) / 기초코드(base-code/enum) / 카테고리(category)

## 모집단 정의 (catalog category=CL 30상품)
catalog `category=="CL"` 30상품 전부 `/ko/product/item/CL/` URL(코드접두=CL≠카테고리 누수 없음). 3그룹: **자체의류 CLST\*** 18종 + **브랜드완제 CLDF\*** 8종 + **단체티 CLTM\*** 3종 + **앞치마 CLAPDFT** 1종. §14 횡단 분류 참조.

---

## 0. CL 카테고리 핵심 발견 (BN/GS/TP/PR/ST과의 구조적 차이 — 메타모델 신축 후보)

CL은 **두 개의 별도 모델로 분기**한다 — 같은 카테고리 안에서 본체 정체에 따라 가격/옵션 패러다임이 다르다:

### 0.1 ★두 의류 모델 (★최대 발견 — 카테고리 내부 분기)
| 모델 | item_gbn / price_gbn | 대표상품 | 본체 인코딩 | 옵션 출처 |
|------|----------------------|---------|------------|----------|
| **clothes2025(전용 의류 모델)** | `clothes2025_item` / `clothes2025_price` | CLSTSHS(자체)·CLTMSHS(단체) | DIR_MTR(size×color SKU)·전용 `apparel_info` 구조 | ★`apparel_info`(print_type/area/color/size_color) — 범용 옵션 skin 미사용 |
| **굿즈형(완제 SKU 모델)** | `tmpl_price` | CLAPDFT(앞치마) | DIR_MTR(완제 SKU)·범용 `<select>`(paper/size/sodu) | 범용 옵션 skin(GS 굿즈 동형) |
출처: CLSTSHS/CLTMSHS `product_option.option.item_gbn`+`price_gbn` `[reuse:productInfo]`; CLAPDFT SSR `price_gbn=tmpl_price` `[live:SSR]`.
**메타모델 시사점:** 의류는 단일 모델이 아니다. **티셔츠類(자체·단체)는 전용 `clothes2025` 모델**(size×color grid + 인쇄위치 + 인쇄방식 = 의류 전용 차원)을 쓰고, **앞치마/가방류는 GS 굿즈 tmpl_price 모델**(완제 SKU + 범용 select)을 쓴다. ★의류 variant는 GS variant의 facet이 아니라 **별도 item_gbn(`clothes2025`)으로 그릇이 분리** — distinct 축 가설 강화(§15).

### 0.2 ★`apparel_info` 전용 구조 (★BN/GS/TP/PR/ST 전무 — 의류 전용 데이터 그릇)
`clothes2025` 상품(CLSTSHS·CLTMSHS)의 `product_data.apparel_info`는 6개 하위 키로 의류 옵션을 **범용 옵션 트리와 직교하게** 담는다(`skinInfo`에서 paper/size/dosu = `view_yn:N` 숨김, subjectGroup+quantityGroup만 노출):
| 키 | CLSTSHS | CLTMSHS | 의미 | base_data_tag |
|----|---------|---------|------|---------------|
| `print_type` | 3종(DTF열전사/직접인쇄/날염실크) | 3종(동일) | ★인쇄방식 enum(USE_YN·order) | 기초코드(인쇄방식) + 공정 |
| `print_area` | 6종(좌측가슴/앞면/좌측팔/우측팔/뒷목/뒷면) | 6종(동일) | ★인쇄위치 enum + `KOI_NME`(에디터 매핑 leftchest/front…) | 기초코드(위치) + 공정(PDT_WRK) |
| `apparel_color` | 54색(HEX·DEFAULT·HIDE_YN) | 6색 | ★색상 스와치 라이브러리 | 기초코드(색 enum) + 옵션 |
| `size_info` | 7(XS~3XL·GBN=adult) | 9(S~2XL adult + 120~150 child) | ★사이즈 grid(GBN=성인/아동) | 기초코드(사이즈) |
| `size_color_info` | 227행 | 54행 | ★사이즈×색 매트릭스 — **각 셀→MTRL_COD**(HIDE_YN/QUICK_ORD_YN/HIDE_RSN 셀별) | 자재(SKU 해소) + 제약(셀 가용성) |
| `pantone_color` | 1124(PANTONE C 라이브러리) | 1124(동일) | ★별색 지정 라이브러리(실크인쇄 spot color) | 기초코드(별색 도메인) |
출처: `apparel_info` 전체 키·카운트 실측 `[reuse:productInfo]`.
**메타모델 시사점:** 의류 옵션은 **DB 차원행/옵션 트리가 아니라 전용 `apparel_info` 구조**로 관리된다. ① 인쇄방식·인쇄위치·색상·사이즈가 각각 1급 enum(기초코드) ② **사이즈×색 = MTRL_COD 매트릭스**(227셀, 셀별 가용성 HIDE_YN) ③ Pantone 1124 별색 라이브러리(ST/PR 별색과 다른 규모). 후니 어느 그릇에도 직접 안 들어감 → **vessel-gap 후보 정점**.

### 0.3 ★사이즈×색 = MTRL_COD 매트릭스 (★variant 4번째 인코딩 — GS 3채널 초과)
GS는 variant를 ① DTL코드 ② ATTB ③ CUT 사이즈 3채널로 인코딩했다. CL은 **사이즈×색 2축 매트릭스 → 단일 MTRL_COD 해소**라는 4번째 인코딩을 추가한다:
- `size_color_info`: COD="1"(S)×CLR_COD="03"(블랙) → `MTRL_COD="SXSRT103"`. COD="1"(S)×CLR_COD="26"(화이트) → `SXSRT126`. 색코드(03/26/58…)가 MTRL_COD 끝 2자리.
- 가격 캡처에서도 입증: sizeM(SI030) → `MTRL_CD=SXSRT226`, L(SI014) → `SXSRT326` — **사이즈 첫자리도 MTRL_CD에 인코딩**(SXSRT**1**03=S, **2**26=M, **3**26=L 추정 패턴). `pdt_mtrl_info` 584행 = 사이즈×색 SKU 폭발.
- DIR_MTR PCS_DTL_NME = "(5942) 6.2oz 프리미엄 티셔츠 화이트 **L**" — **본체 SKU 라벨에 원단(6.2oz)+색(화이트)+사이즈(L) 융합**(GS DTL_NME 융합 동형, 단 차원이 2축).
출처: `size_color_info` MTRL_COD 매핑 + 가격캡처 reqBody MTRL_CD `[reuse:productInfo]`+`[reuse:price-capture]`.
**메타모델 시사점:** 의류 본체 SKU = **(원단/제품타입 PTT) × 색(CLR) × 사이즈(WGT 자리)** 합성코드. 후니 굿즈 본체소재 부재(메모리 round22 GPM)와 동형이나 **차원이 size×color 2D 매트릭스** — 후니 자재모델에 "사이즈×색 SKU 해소" 그릇 필요.

### 0.4 인쇄위치(PDT_WRK) = 위치별 가격 공정 (★PR 다면·GS PDT_WRK 확장)
`pdt_pcs_info` 591행 분포: **DIR_MTR 584**(size×color 본체 SKU) + **PDT_WRK 6**(인쇄위치) + **PAK_POL 1**(폴리백 포장).
- PDT_WRK 6행 = print_area 6종과 1:1(CL011 좌측가슴·CL001 앞면·CL009 좌측팔·CL010 우측팔·CL004 뒷목인쇄·CL002 뒷면).
- ★가격 주체: 가격캡처에서 `PDT_WRK/CL011`(좌측가슴) PRICE=**3700**(개당단가)·`DIR_MTR/SI014`(본체) PRICE=**16200** → result_sum=19900. **인쇄위치마다 인쇄비가 PDT_WRK 항목으로 가산**.
출처: `pdt_pcs_info` PCS_COD 분포 + 가격캡처 result `[reuse:productInfo]`+`[reuse:price-capture]`.
**메타모델 시사점:** 인쇄위치 = **선택 가능한 다중 위치 공정**(앞면+뒷면+소매 동시 가능 추정·각자 PDT_WRK 가산). PR 다면(면분할)·GS PDT_WRK(본체조립)와 다른 의미 — **"인쇄 적용 위치" 다중선택 공정축**. KOI_NME(leftchest/front)로 에디터 캔버스 영역과 매핑(TP 에디터 채널 합류).

### 0.5 인쇄방식(PRINT_TYPE)이 ORD_INFO에 (★ST/PR 인쇄방식 분기와 다른 인코딩)
ST/PR은 인쇄방식을 **pdtCode prefix로 상품분기**(UV/DTF/윤전/토너)했다. CL은 **한 상품 안 옵션**으로 인쇄방식을 둔다:
- 가격캡처 ORD_INFO에 `PRINT_TYPE: "PTP_DTF"`(init) → `"PTP_DIR"`(method 변경) — **인쇄방식이 ORD_INFO 필드**(MTRL_CD/CUT/DOSU와 동급 차원).
- `apparel_info.print_type` = PTP_DTF(DTF 열전사)·PTP_DIR(직접인쇄)·PTP_SLK(날염/실크인쇄) 3종 enum.
출처: 가격캡처 reqBody `PRINT_TYPE` + apparel_info.print_type `[reuse:price-capture]`+`[reuse:productInfo]`.
**메타모델 시사점:** 인쇄방식이 ST/PR(상품분기)과 달리 **CL은 상품내 옵션(ORD_INFO 차원)**. 같은 티셔츠에 DTF/직접/실크 택1 → 인쇄방식 인코딩이 카테고리마다 다름(상품분기 vs 옵션차원) — 메타모델 "인쇄방식 축"이 2가지 표현을 가짐(§15 합류).

### 0.6 이중 수량 (디자인수 × 수량) — BN/GS 동형 유지
`skinInfo.quantityGroup.title` = {orderCnt: "디자인 수 (건수)", printCnt: "수량"}. 가격캡처 ORD_CNT(주문건수=디자인수) + PRN_CNT(인쇄수량). PRICE_LOG="개당단가×인쇄수량×주문건수". BN/GS 이중수량 패턴 유지(신규 아님).

---

## 1. CLSTSHS — 5.6oz 하이퀄리티 티셔츠 (★자체 의류 본체 SKU 정수) `[reuse:productInfo]` `[reuse:price-capture]`
source: `major_apparel_CLSTSHS.json` rawProductData.result(line 1~·apparel_info) + `clstshs_price.json` rawPriceCalls[0-3] (line 79·185)

```
product: CLSTSHS 5.6oz 하이퀄리티 티셔츠 (CL)
  item_gbn: clothes2025_item   price_gbn: clothes2025_price
  ★skinInfo: paper/size/dosu view_yn=N(숨김), subjectGroup+quantityGroup만 노출 — 의류 옵션은 apparel_info에서.
base(가격캡처): MTRL_CD=SXSRT326(L)/SXSRT226(M)  CUT 100×100  DOSU_COD=SID_S PRN_CLR_CNT=4  PRINT_TYPE=PTP_DTF/PTP_DIR
axes:
  - axis: 인쇄방식        # ORD_INFO.PRINT_TYPE / apparel_info.print_type
    choices: [PTP_DTF "DTF 열전사"(order1·기본), PTP_DIR "직접인쇄"(order2), PTP_SLK "날염(실크인쇄)"(order3)]
    cascade: 인쇄방식 변경(DTF→DIR)이 ORD_INFO만 바꿈 — 가격캡처 init(DTF)→method(DIR) 동일 19900(이 조합 가격동일)
    base_data_tag: 기초코드(인쇄방식 enum) + 공정(인쇄)
    note: ★ST/PR은 인쇄방식=상품분기였으나 CL은 상품내 ORD_INFO 차원(§0.5). USE_YN·order 관리.
  - axis: 본체(원단×색×사이즈 SKU)        # PCS_COD=DIR_MTR (584행)
    choices: [SI001~ "5.6oz 하이퀄리티 티셔츠 블랙 S" … SI014 "(5942)6.2oz 프리미엄 화이트 L" … SI030 "…화이트 M"]
    cascade: ★사이즈×색 선택 → 단일 MTRL_COD 해소(size_color_info 227셀: S×블랙03→SXSRT103). DTL코드(SI014=L·SI030=M)가 본체 SKU 키.
    price_flag: ★PRICE 주체 — DIR_MTR PRICE=16200(개당단가). result_sum=19900(본체16200+인쇄3700).
    base_data_tag: 자재(원단 본체·PTT 제품타입+WGT 평량) + 템플릿/SKU + 옵션(색·사이즈 variant)
    note: ★PCS_DTL_NME에 원단(6.2oz)+색(화이트)+사이즈(L) 융합. pdt_mtrl_info 584행=size×color 폭발(§0.3). SUB_MTRL_YN=Y.
  - axis: 사이즈 grid        # apparel_info.size_info (7종)
    choices: [XS(X), S(1), M(2), L(3), XL(4), 2XL(5), 3XL(6)]   # COD·ORD·GBN=adult
    cascade: 사이즈 선택 → size_color_info에서 (사이즈,색)→MTRL_COD. 사이즈가 MTRL_CD 첫자리 인코딩(1xx=S·2xx=M·3xx=L).
    base_data_tag: 기초코드(사이즈 enum·GBN 성인/아동 구분)
    note: ★의류 전용 사이즈 grid 축(BN 면적·GS CUT프리셋과 다른 표준 의류 사이즈). GBN=adult만(아동 없음).
  - axis: 색상        # apparel_info.apparel_color (54색)
    choices: [26 화이트(#FFFFFF·DEFAULT=Y), 03 블랙, 65 애쉬, 58 멜란지그레이, 66 챠콜, 72 골드, 74 민트그린 … 54색 HEX]
    cascade: 색 선택 → size_color_info에서 (사이즈,색)→MTRL_COD. HIDE_YN=N만 노출. DEFAULT=화이트.
    base_data_tag: 기초코드(색 enum·HEX) + 옵션 + 제약(size_color_info HIDE_YN 셀별 가용성)
    note: ★54색 스와치 라이브러리. 색이 MTRL_COD 끝2자리 인코딩(03=블랙→…103). GS 색=DTL코드(단일축)와 달리 CL은 사이즈와 2D 매트릭스.
  - axis: 인쇄위치        # PCS_COD=PDT_WRK (6행) / apparel_info.print_area
    choices: [CL011 좌측가슴(leftchest), CL001 앞면(front), CL009 좌측팔(leftsleeve), CL010 우측팔(rightsleeve), CL004 뒷목인쇄(neck), CL002 뒷면(back)]
    cascade: 위치 선택(다중 추정) → 각 위치 PDT_WRK 항목 가산. KOI_NME로 에디터 캔버스 영역 매핑.
    price_flag: ★가격 가산 — PDT_WRK/CL011(좌측가슴) PRICE=3700(개당단가). 위치마다 인쇄비.
    base_data_tag: 기초코드(위치 enum) + 공정(위치별 인쇄)
    note: ★인쇄위치 다중선택 공정축(§0.4). KOI_NME=에디터 매핑(TP 에디터 합류). PR 다면·GS 본체조립 PDT_WRK와 의미 다름.
  - axis: 별색(Pantone)        # apparel_info.pantone_color (1124)
    choices: [PANTONE 100 C … 1124종 (실크인쇄 spot color 라이브러리)]
    base_data_tag: 기초코드(별색 도메인) — 실크(PTP_SLK) 인쇄 시 별색 지정
    note: ★1124 Pantone 라이브러리. PTP_SLK(날염/실크) 인쇄방식에서 별색 매칭. ST/PR 별색보다 규모 큼(전체 Pantone C).
  - axis: 포장        # PCS_COD=PAK_POL (1행)
    choices: [폴리백 개별포장]
    base_data_tag: 공정(포장) 또는 옵션
    note: GS PAK_POL 동형. 의류 개별 폴리백.
  - axis: 수량(이중)
    choices: ORD_CNT(디자인 수=건수) + PRN_CNT(수량)
    base_data_tag: 옵션(수량)
    note: BN/GS 이중수량 동형(§0.6). 개당단가×수량×건수.
disable: pdt_disable_pcs_info=0행(이 캡처). size_color_info HIDE_YN이 실질 가용성 제약(셀단위).
```

---

## 2. CLTMSHS — 단체티-반팔 (Printstar 086) (★단체티 분기·아동사이즈) `[reuse:productInfo]`
source: `major_apparel_CLTMSHS.json` rawProductData.result(apparel_info)

```
product: CLTMSHS 단체티-반팔 (Printstar 086) (CL)
  item_gbn: clothes2025_item   price_gbn: clothes2025_price   ★CLSTSHS와 동일 모델
  skinInfo: quantityGroup {디자인 수(건수)·수량} 동일.
axes (CLSTSHS와 동형 — 차이만 명시):
  - axis: 인쇄방식 [print_type 3종 PTP_DTF/PTP_DIR/PTP_SLK — CLSTSHS와 100% 동일]   base_data_tag: 기초코드+공정
  - axis: 본체(브랜드 완제 SKU)        # PCS_COD=DIR_MTR (55행)
    choices: [WF077 "Printstar 00086-DMT 블랙 S" …]   # ★브랜드 제품번호(Printstar 086) 융합
    cascade: size_color_info 54셀 → MTRL_COD(SXZSB103=S블랙·SXZSB162=S라이트핑크). WEB_PCS_DTL_GRP_NM="반팔의류".
    base_data_tag: 자재(브랜드 완제 원단) + 템플릿/SKU
    note: ★자체(CLST=SXSRT/SXSHT 자체원단)와 달리 단체티=브랜드 완제(Printstar SXZSB). pdt_pcs_info 62행(CLSTSHS 591보다 작음=색/사이즈 적음).
  - axis: 사이즈 grid        # apparel_info.size_info (9종)
    choices: [S/M/L/XL/2XL (GBN=adult) + 120/130/140/150 (GBN=child)]   # ★★아동 사이즈 추가
    base_data_tag: 기초코드(사이즈·GBN 성인/아동)
    note: ★★CLSTSHS는 adult만, CLTMSHS(단체티)는 child(120~150) 추가 — GBN 축이 단체티에서 활성. 단체 주문=아동 포함.
  - axis: 색상 [apparel_color 6색]   base_data_tag: 기초코드(색)
    note: ★자체(54색)보다 적은 6색 — 브랜드 완제는 재고색 제한.
  - axis: 인쇄위치 [print_area 6종 좌측가슴/앞면/좌측팔/우측팔/뒷목/뒷면 — CLSTSHS 동일]   base_data_tag: 기초코드+공정
  - axis: 별색 [pantone_color 1124 — CLSTSHS 동일]   base_data_tag: 기초코드(별색)
  - axis: 수량(이중)   base_data_tag: 옵션
note: ★★CLST(자체)·CLTM(단체)는 같은 clothes2025 모델·같은 apparel_info 6키 구조. 차이 = ① 원단(자체 SXSRT vs 브랜드 SXZSB) ② 색수(54 vs 6) ③ GBN child 활성(단체티) ④ SKU 폭발 규모(591 vs 62). **정규화: 자체·단체는 동일 메타모델, 인스턴스(원단 라이브러리·색/사이즈 모집단)만 다름.**
```

---

## 3. CLAPDFT — 앞치마 (★굿즈형 분기·레거시 SSR·완제 SKU) `[live:SSR]`
source: 라이브 GET `/ko/product/item/CL/CLAPDFT` (2026-06-17·HTTP 200·385KB) SSR `<select>`·radio chip 실측

```
product: CLAPDFT 앞치마 (CL)   ★레거시 jQuery 상품(productOrder.check_CLAPDFT) — clothes2025 아님!
  price_gbn: tmpl_price   ★굿즈 완제 SKU 모델(CLST/CLTM의 clothes2025와 다른 그릇)
  PCS 마커: DIR_MTR(76참조)·PDT_WRK(48참조)·PAK 추정 — GS 굿즈 동형
axes:
  - axis: 본체(앞치마 완제 SKU + 용도×색 융합)        # <select id="paper"> 8옵션 (value=MTRL_CD)
    choices: [SXPWAX49 "작업/공방용 카멜", SXPWAX46 "작업/공방용 올리브", SXPWAX54 "작업/공방용 블루", SXPWAX03 "작업/공방용 블랙",
              SXPSAX57 "가게용 브라운", SXPSAX03 "가게용 블랙", SXPGAX19 "손님용 레드", SXPGAX32 "손님용 네이비"]
    cascade: 본체 선택 = MTRL_CD 고정. ★용도(작업/공방/가게/손님)+색이 SKU 라벨에 융합(MTRL_CD: PW=작업·PS=가게·PG=손님).
    base_data_tag: 자재(앞치마 본체 소재) + 템플릿/SKU + 옵션(용도·색 — SKU 융합)
    note: ★CLST/CLTM과 달리 ① apparel_info 없음 ② 색=별 스와치 아님(SKU 라벨 융합) ③ 사이즈=용도별 영역(아래). 색 8종(자체 티셔츠 54색과 대조).
  - axis: 사이즈(=인쇄 영역·용도별)        # <select id="size"> 5옵션
    choices: [작업/공방용(가슴)(150×50), 작업/공방용(상단포켓)(90×100), 작업/공방용(하단포켓 위), 가게용(180×260), 손님용(220×300)]
    cascade: 본체 용도와 연동(작업/공방용 본체→가슴/포켓 영역). ★사이즈=인쇄영역+치수 융합.
    base_data_tag: 기초코드(영역 프리셋·치수) + 제약(본체↔영역 캐스케이드)
    note: ★앞치마 "사이즈"=인쇄 가능 영역(가슴/포켓)+mm 치수 융합 — 티셔츠 size grid(S/M/L)와 의미 다름. 본체-영역 종속.
  - axis: 인쇄위치        # radio name="print_area" (chip) — CL005=가슴 등 6 print_area 마커
    choices: [CL005 "가슴" (icon chip) … 6위치 마커]   # apron_area1=가슴 등
    base_data_tag: 기초코드(위치) + 공정(PDT_WRK)
    note: ★레거시 앞치마도 인쇄위치 radio chip(아이콘 이미지). PDT_WRK 48참조. 티셔츠 print_area와 동류(앞치마 영역).
  - axis: 도수        # <select id="sodu"> 2옵션
    choices: [data-type=4 "단면", data-type=0 "인쇄없음"]
    base_data_tag: 기초코드(도수 enum)
    note: ★GS 텀블러 SID_X(무인쇄) 동형 — 도수 enum에 "인쇄없음(0)" 존재. 단면(4)/없음(0).
  - axis: 용지(보조)        # <select id="paper_sub_select"> 1빈옵션
    choices: [unobserved (빈)]   base_data_tag: unobserved
    note: paper_sub_select 1빈옵션 — 본체 종속 보조선택(비활성 추정).
  - axis: 수량 [number1_sel·number2_sel·이중]   base_data_tag: 옵션(수량)
disable: <select id="size" disabled> — 초기 비활성(본체 선택 후 활성 캐스케이드).
note: ★★CLAPDFT = GS 굿즈형 모델(tmpl_price·완제 SKU·apparel_info 없음). 같은 CL 카테고리지만 티셔츠類와 다른 그릇. 앞치마=완제품에 인쇄 부가(GS 텀블러 동형).
```

---

## 4. CLDFSHS — 76000 반팔 티셔츠 (브랜드 완제·신규 Vue) `[live:SSR-negative]` `[live:catalog]`
source: 라이브 GET `/ko/product/item/CL/CLDFSHS` (2026-06-17·HTTP 200·301KB) — 옵션 SSR 미노출(전역 km1_size만)

```
product: CLDFSHS 76000 반팔 티셔츠 (CL)   ★브랜드 완제(제품번호 76000) — 신규 Vue client-render
axes (라이브 추출 불가·CLST/CLTM clothes2025 동형 추정):
  - axis: 인쇄방식/본체(76000 SKU)/사이즈/색상/인쇄위치/별색/수량
    choices: unobserved (Vue client-render·BFF 익명불가)
    base_data_tag: (CLSTSHS 동형 추정 — clothes2025 모델)
    note: ★CLDF*(브랜드 완제 8종)은 신규 Vue. item_gbn 미확인. CLTMSHS(단체·브랜드 완제)가 clothes2025라 CLDFSHS도 동형 추정이나 실측 아님. 제품번호 76000=브랜드 원단 SKU.
```
**메타모델 시사점:** CLDF\*(브랜드 완제·76000/88000/Printstar 등) = 단체티(CLTM)와 같은 "브랜드 완제 원단" 계열. clothes2025 동형 강한 추정이나 라이브 미확정 → `unobserved`. 캡처(CLSTSHS 자체·CLTMSHS 단체) 2종으로 모델은 확정, CLDF 인스턴스만 미관측.

---

## 5. CLST 의류類 스펙트럼 (스웻·후드·맨투맨·가방류 — 자체 의류 횡단) `[live:catalog]` + `[reuse:productInfo]` 동형
source: catalog 상품명 + CLSTSHS/CLTMSHS apparel_info 모델 동형 유추(옵션 상세 unobserved)

```
★자체 의류 CLST* 18종은 모두 clothes2025 모델 추정(CLSTSHS 실측 동형). 본체 원단(oz)·형태만 다름:
| pdtCode | 상품명 | 형태 | 원단 평량(oz) | apparel_info 추정 |
| CLSTSHS | 5.6oz 하이퀄리티 티셔츠 | 반팔티 | 5.6oz(자체 SXSHT/SXSRT) | ★실측(54색·7사이즈·6위치) |
| CLSTDLD | 4.01oz 드라이 루즈핏 티셔츠 | 반팔(드라이) | 4.01oz | 동형 추정 |
| CLSTBST | 5.6oz 빅 실루엣 티셔츠 | 반팔(빅실루엣) | 5.6oz | 동형 추정 |
| CLSTLSD/CLSTLOS/CLSTBLS | 5.6oz 롱슬리브(리브 1.6/1.8인치) | 긴팔 | 5.6oz | 동형(리브 차이=원단) |
| CLSTBSA | 4.1oz 드라이 베이스볼 셔츠 | 베이스볼 | 4.1oz | 동형 추정 |
| CLSTDLB | 4.01oz 드라이 루즈핏 바스켓볼 탱크탑 | 탱크탑 | 4.01oz | 동형 추정 |
| CLSTSWT | 10.0oz 스웻 셔츠 (쭈리) | 스웻 | 10.0oz(쭈리) | 동형 추정 |
| CLSTSPK | 10.0oz 후드 (쭈리) | 후드 | 10.0oz | 동형 추정 |
| CLSTBSN | 10.0oz 빅실루엣 맨투맨 (쭈리) | 맨투맨 | 10.0oz | 동형 추정 |
| CLSTSHD | 10.0oz 후드 집업 (쭈리) | 후드집업 | 10.0oz | 동형(집업=지퍼 추정·미관측) |
| CLSTBSH | 10.0oz 빅실루엣 후드티 (쭈리) | 후드 | 10.0oz | 동형 추정 |
| CLSTSAP | 워싱 캔버스 & 트윌 에이프런 | 앞치마(자체) | 캔버스/트윌 | ★앞치마형(CLAPDFT 굿즈모델 vs clothes2025? unobserved) |
| CLSTTOB | 레귤러 캔버스 토트백 | 가방 | 캔버스 | ★가방류(굿즈형 추정·apparel_info 부재 가능) |
| CLSTLUB | 헤비 캔버스 런치백 | 가방 | 캔버스 | 가방류 동류 |
| CLSTCAP | 코튼 트윌 로우 캡 | 모자 | 코튼트윌 | ★모자(굿즈형 추정·기종 단일) |

axes(자체 티셔츠/스웻/후드 공통 — apparel_info 동형 추정·옵션값 unobserved):
  - 인쇄방식(PTP_DTF/DIR/SLK)·사이즈grid·색상·인쇄위치·별색·이중수량
    note: 원단 평량(4.01~10.0oz)이 본체 SKU 차이. 형태(반팔/긴팔/후드/맨투맨/탱크탑)=별 pdtCode. 캔버스 가방/모자/에이프런(CLSTSAP/TOB/LUB/CAP)은 의류 아님 → 굿즈형(tmpl_price·apparel_info 부재) 추정(미관측·CLAPDFT 동류).
```
**메타모델 시사점:** ★원단 평량(oz)+형태가 자체 의류 pdtCode 분기축. 같은 clothes2025 모델 위 원단 라이브러리만 다름(코스터 6소재 분리 동형·단 의류는 평량/형태). **가방/모자/에이프런(캔버스류)은 의류가 아니라 굿즈형 분기** — CL 카테고리 내부 "의류(clothes2025) vs 굿즈(tmpl)" 2모델 확증.

---

## 6. CLDF 브랜드 완제 + CLTM 단체티 (브랜드 완제 원단 계열 — 횡단) `[live:catalog]`
source: catalog 상품명 (옵션 상세 unobserved·CLTMSHS 실측 동형)

```
★브랜드 완제 원단(제품번호) 계열 — CLDF*(8) + CLTM*(3). CLTMSHS만 실측(child 사이즈·6색·SXZSB):
| pdtCode | 상품명 | 브랜드/제품번호 | 형태 |
| CLDFSHS | 76000 반팔 티셔츠 | 76000 | 반팔 |
| CLDFMHS | 88000 맨투맨 | 88000 | 맨투맨 |
| CLDFDRR | 300-ACT 드라이 라운드티셔츠 | 300-ACT | 드라이라운드 |
| CLDFDRP | 302-ADP 드라이 폴로셔츠 | 302-ADP | 폴로 |
| CLDFDRK | 330-AVP 드라이 폴로셔츠(포켓) | 330-AVP | 폴로(포켓) |
| CLDFALP | 335-ALP 드라이 긴팔 폴로셔츠(포켓) | 335-ALP | 긴팔폴로 |
| CLDFALT | 304-ALT 드라이 라운드 긴팔 티셔츠 | 304-ALT | 긴팔라운드 |
| CLDFLOS | 00102-CVL 긴팔 티셔츠 | 00102-CVL | 긴팔 |
| CLTMSHS | 단체티-반팔 (Printstar 086) | Printstar 086 | ★실측(clothes2025·child) |
| CLTMMTS | 단체티-맨투맨 (Printstar 219) | Printstar 219 | 맨투맨 |
| CLTMHDS | 단체티-후드 (Printstar 216) | Printstar 216 | 후드 |
| CLDFNCP | 내추럴 코튼백 | (코튼백) | ★가방(굿즈형 추정) |

note: ★CLDF(브랜드 완제·낱장구매 가능)와 CLTM(단체티·대량/아동) 모두 브랜드 원단(Printstar/제품번호). CLTMSHS 실측=clothes2025·SXZSB·6색·child 활성. CLDFNCP(코튼백)=가방=굿즈형 분기.
```
**메타모델 시사점:** ★CLST(자체)·CLDF(브랜드 완제)·CLTM(단체) 3분기 = **원단 출처(자체 제작 vs 브랜드 완제)**의 차이이지 옵션 모델의 차이가 아님(CLST·CLTM 둘 다 clothes2025 실측). 3분기는 **원단 라이브러리/모집단 분리**(자체 SXSRT/SXSHT · 브랜드 SXZSB) + 색/사이즈 가용성 차이. 정규화: 단일 clothes2025 메타모델, 원단 카탈로그만 3계열.

---

## 14. CL 30상품 그룹 횡단 분류 (모집단 명문·대표3 superset 검증)

| 그룹 | pdtCode | 모델(item_gbn) | 본체 인코딩 | 대표 superset 포함? |
|------|---------|---------------|------------|---------------------|
| **자체의류 CLST(15 의류)** | CLSTSHS★·CLSTDLD·CLSTBST·CLSTLSD·CLSTLOS·CLSTBLS·CLSTBSA·CLSTDLB·CLSTSWT·CLSTSPK·CLSTBSN·CLSTSHD·CLSTBSH | clothes2025(추정·CLSTSHS 실측) | 자체원단×색×사이즈 | ✅ CLSTSHS가 superset(54색·7사이즈·6위치·3인쇄방식) |
| **자체 가방/모자/에이프런 CLST(3)** | CLSTSAP·CLSTTOB·CLSTLUB·CLSTCAP | tmpl(굿즈형 추정·unobs) | 완제 SKU(캔버스) | △ CLAPDFT 굿즈모델로 부분 커버(앞치마/가방 동류) |
| **브랜드 완제 CLDF(7 의류+1백)** | CLDFSHS·CLDFMHS·CLDFDRR·CLDFDRP·CLDFDRK·CLDFALP·CLDFALT·CLDFLOS·CLDFNCP | clothes2025(추정)·CLDFNCP=tmpl | 브랜드 원단×색×사이즈 | ✅ CLTMSHS(브랜드 완제·실측)가 동형 |
| **단체티 CLTM(3)** | CLTMSHS★·CLTMMTS·CLTMHDS | clothes2025(CLTMSHS 실측) | 브랜드 원단(child 포함) | ✅ CLTMSHS가 superset(child 사이즈) |
| **앞치마 CLAPDFT(1)** | CLAPDFT★ | tmpl(SSR 실측) | 완제 앞치마(용도×색 SKU) | ✅ 굿즈형 대표 실측 |

**대표3+보조2 커버리지:** CLSTSHS(자체 clothes2025 superset 풀실측)·CLTMSHS(단체·브랜드완제·child 풀실측)·CLAPDFT(굿즈형 tmpl SSR 실측) + CLDFSHS(브랜드 신규Vue·unobs). **누락 축:** ① CLST 가방/모자(CLSTTOB/CAP)의 굿즈형 확정 여부(apparel_info 부재 추정·미관측) ② 후드집업(CLSTSHD) 지퍼 옵션 ③ CLDF 낱장구매 가격(개당 vs 단체 구간) — 전부 unobserved 정직. **구조 다양성(2모델·size×color 매트릭스·3인쇄방식·6위치·자체/브랜드/단체 3분기·아동사이즈·Pantone)은 대표3+CLTM/CLDF로 커버.**

---

## 15. base-data 축 횡단 종합 (메타모델 아키텍트 입력 — CL 추가분, 17축 표와 병합)

| 관리 축 | RedPrinting 표현(CL) | base_data_tag | 메타모델 흡수 단위 | 17축 대비 신규? |
|---------|---------------------|---------------|-------------------|----------------|
| **의류 본체 SKU(size×color 매트릭스)** | `size_color_info` 227셀 → MTRL_COD. DIR_MTR 584행. PTT×CLR×WGT 합성 | 자재 + 템플릿/SKU + 옵션 | ★사이즈×색 2D 매트릭스 SKU 해소(GS 단일DTL·BN 단일MTRL 초과) | ★신규(variant 4번째 인코딩) |
| **사이즈 grid(GBN 성인/아동)** | `apparel_info.size_info` XS~3XL·120~150 child | 기초코드(사이즈) | 표준 의류 사이즈 enum + 연령 GBN | ★신규(BN면적·GS CUT프리셋·ST형상과 다름) |
| **색상 스와치 라이브러리** | `apparel_color` 54색(HEX·DEFAULT·HIDE_YN) | 기초코드(색) + 옵션 + 제약 | HEX 색 enum + 셀별 가용성. 자체54 vs 브랜드6 | ★신규(GS 색=DTL단일·CL=2D매트릭스축) |
| **인쇄위치(다중)** | `print_area` 6종(PDT_WRK 6행) + KOI_NME 에디터매핑 | 기초코드(위치) + 공정(위치별 인쇄) | 다중선택 위치·위치별 가산 | ★신규(PR다면·GS본체조립 PDT_WRK와 의미 다름) |
| **인쇄방식(상품내 옵션)** | `print_type` PTP_DTF/DIR/SLK (ORD_INFO.PRINT_TYPE) | 기초코드(방식) + 공정 | 상품내 인쇄방식 차원 | (ST/PR 상품분기와 다른 인코딩·합류) |
| **별색 Pantone 라이브러리** | `pantone_color` 1124(PANTONE C) | 기초코드(별색 도메인) | 실크인쇄 spot color 전체 Pantone | (ST/PR 별색 확장·규모 정점) |
| **원단 출처 3분기** | 자체(CLST·SXSRT)·브랜드완제(CLDF·CLTM·SXZSB) | 자재(원단 카탈로그 계열) + 카테고리 | 원단 라이브러리 3계열(옵션모델은 동일) | ★신규(GS 코스터 소재분리 동형·의류판) |
| **카테고리 내 2모델** | clothes2025(티셔츠)·tmpl(앞치마/가방/모자) | (item_gbn 분기) | 같은 카테고리 다른 그릇 | ★신규(TP 트윈과 다른 "내부 모델 분기") |
| 인쇄위치 에디터 매핑 | `KOI_NME`(leftchest/front/back) | (에디터 채널) | TP 에디터 채널 #16 합류 | (TP 디자인입력 합류) |
| 이중 수량 | ORD_CNT(디자인수)+PRN_CNT | 옵션 | BN/GS 동형 | (기존 유지) |
| 도수 | SID_S(단면)·"인쇄없음"(0) | 기초코드 | GS SID_X 동형 | (기존 유지) |

### 핵심 패턴 (RedPrinting의 의류 정규화 방식 — 17축과의 관계)
1. **★전용 `apparel_info` 그릇** — 의류 옵션(인쇄방식/위치/색/사이즈/size×color매트릭스/Pantone)이 범용 옵션 트리·차원행이 아니라 **전용 6키 구조**로 관리. BN/GS/TP/PR/ST 전무. 후니 어느 그릇에도 직접 안 들어감 = vessel-gap 정점.
2. **★size×color = MTRL_COD 매트릭스** — variant 4번째 인코딩(GS 3채널 초과). 227셀(자체)/54셀(단체) 각자 MTRL_COD+셀별 HIDE_YN. 후니 굿즈 본체소재 부재 동형이나 2D 차원.
3. **★카테고리 내부 2모델** — 티셔츠類=clothes2025(전용 의류), 앞치마/가방/모자=tmpl(굿즈형). 같은 CL 카테고리가 본체 정체에 따라 그릇 분기. item_gbn이 모델 결정.
4. **★자체/브랜드/단체 3분기 = 원단 카탈로그 차이** — 옵션 메타모델은 동일(CLST·CLTM 둘 다 clothes2025 실측). 원단 라이브러리(자체 SXSRT vs 브랜드 SXZSB) + 색/사이즈 모집단(54색 vs 6색·adult vs child) 차이뿐. 정규화: 단일 모델 + 원단 3계열.
5. **인쇄방식 인코딩 카테고리 의존** — CL=상품내 옵션(ORD_INFO), ST/PR=상품분기(pdtCode). 메타모델 "인쇄방식 축"이 2표현 가짐.
6. **인쇄위치 다중선택 공정** — print_area 6위치, 위치마다 PDT_WRK 가산, KOI_NME로 에디터 캔버스 매핑(TP 합류).

---

## Ambiguous fragments (CL — 아키텍트가 관리 버킷 확정)

- **C-1. `apparel_info` 전체 구조의 버킷** — print_type/area/color/size_info는 기초코드(enum)로 보이나, size_color_info(227셀→MTRL_COD)는 자재(SKU 해소)+제약(셀 가용성)이 융합. apparel_info가 ① 새 1급 관리 그릇(의류 전용 테이블군) ② 기존 기초코드+자재+제약의 조합 뷰 중 무엇인가? ★vessel-gap 1순위 — 후니 어느 그릇에도 직접 안 들어감.
- **C-2. 의류 variant = distinct #18인가 GS variant facet인가** — ★최대 directive 질문. 증거: ① item_gbn이 `clothes2025`로 GS(tmpl/vTmpl/tiered)와 별도 분기 ② apparel_info 전용 구조 ③ size×color 2D 매트릭스(GS 단일 DTL 초과) ④ Pantone 1124·인쇄위치 6·인쇄방식 3 = 의류 전용 차원군. **1차 예측: distinct 신규 축 #18(의류 variant·apparel_info 그릇)**. GS variant(완제SKU·3채널)의 facet로 보기엔 그릇(item_gbn)·차원(size×color·위치·방식·Pantone) 모두 별도. 단 "본체=DIR_MTR PCS 항목·PRICE 주체·SKU 라벨 융합"은 GS와 공유 = variant 상위개념의 의류 특화. 아키텍트 최종 판정 필요(§15 #1~4 근거).
- **C-3. size×color 매트릭스 = 어느 그릇** — 사이즈×색 → MTRL_COD가 ① 자재행 폭발(584 MTRL) ② 별 매트릭스 테이블(size_color_info) ③ 차원 조합 옵션 중 무엇으로 후니에 흡수? 후니 자재모델은 1D(지종×평량)·CL은 2D(size×color)→1 MTRL. round-22 굿즈 본체소재 부재와 연결.
- **C-4. 인쇄위치(print_area) = 기초코드 vs 공정 vs 차원** — PDT_WRK 항목으로 가격 가산(공정)이나 enum(기초코드)이고 KOI_NME로 에디터 영역(에디터 채널). 다중선택. 후니 어느 축? PR 다면·GS PDT_WRK·TP 에디터와 경계 모호.
- **C-5. 카테고리 내부 2모델(clothes2025 vs tmpl)** — 같은 CL 카테고리에서 티셔츠=clothes2025·앞치마/가방=tmpl. item_gbn이 카테고리가 아니라 본체 정체로 결정 → 후니 "카테고리" 버킷과 "모델/생산형태" 버킷 분리 필요? TP HL트윈(다른 카테고리)과 다른 "동일 카테고리 내 모델 분기".
- **C-6. 원단 출처 3분기(자체/브랜드/단체) = 카테고리 vs 자재 라이브러리** — CLST/CLDF/CLTM이 카테고리 하위분류인가, 원단 카탈로그 계열(자재)인가, 판매단위(낱장/단체) 차이인가? 옵션모델 동일·원단/색/사이즈 모집단만 다름 → "자재 라이브러리 계열" 가설이나 pdtCode prefix 분리(카테고리성)도 병존.
- **C-7. Pantone 1124 별색 라이브러리 vs ST/PR 별색** — CL Pantone(실크인쇄·전체 PANTONE C 1124)이 ST/PR 별색(공정 PROC)·후니 별색=공정(round-22)과 같은 그릇인가, 의류 전용 별색 도메인인가? 규모(1124)가 기초코드 도메인 거버넌스 관점 제기.
- **C-8. GBN(adult/child) 축** — 사이즈에 연령 GBN(성인/아동). 단체티에서만 child 활성. GBN이 ① 사이즈 enum의 하위속성 ② 별 분류축 ③ 제약(상품별 child 가용) 중 무엇? 후니 미발굴.
- **C-9. CLST 가방/모자/에이프런(CLSTSAP/TOB/LUB/CAP) 모델** — 의류(clothes2025) vs 굿즈(tmpl) 어느 쪽? 캔버스 본체+인쇄=CLAPDFT 굿즈형 추정이나 apparel_info 부재 미관측. 카테고리(CL=의류) 안에 비의류(가방) 포함 = 카테고리 경계 모호.

---

## 라이브 접속 결과 (정직 기록)
- **CLAPDFT(앞치마)**: ★`[live:SSR]` 성공 — 레거시 jQuery 상품(`productOrder.check_CLAPDFT`). SSR HTML에 실 `<select>`(paper 8옵션·size 5옵션·sodu 2옵션) + radio chip(print_area CL005 가슴 등) 정적 추출 성공. price_gbn=tmpl_price 확인. CL 카테고리 유일 SSR-positive 라이브 추출.
- **CLDFSHS(76000 반팔)**: `[live:SSR-negative]` — 신규 Vue client-render(HTTP 200·301KB·전역 km1_size만). 옵션 트리 라이브 추출 불가. clothes2025 동형 추정이나 미확정→unobserved.
- **CLSTSHS·CLTMSHS**: ★`[reuse:productInfo]` 풀 실측 — huni-widget 05_qa `major_apparel_*.json`의 rawProductData.result에 ★`apparel_info` 전용 구조(6키)+pdt_pcs_info(591/62행)+pdt_mtrl_info(584/×행) 완전 포착. CLSTSHS는 `clstshs_price.json`로 가격(본체16200+위치3700·DTF/DIR·size M/L) 추가 실측. **BN/GS SSR보다 깊은 의류 전용 데이터** 확보(가격캡처가 옵션 조합·인쇄위치 가산 입증).
- **chrome MCP**: 이 실행 컨텍스트 미주입. BFF 익명 호출 불가(세션토큰). 신규 Vue CL 상품 옵션은 huni-widget 캡처(CLSTSHS/CLTMSHS) 의존.

## CL 미관측(unobserved) 요약
- **CLDF\* 브랜드 완제 8종(76000/88000/300-ACT 등) 옵션 상세 + item_gbn** — Vue client-render. CLTMSHS(브랜드 완제·실측)로 clothes2025 동형 강한 추정이나 CLDF 인스턴스 미확정.
- **CLST 가방/모자/에이프런(CLSTSAP/TOB/LUB/CAP) 모델 확정** — 굿즈형(tmpl·apparel_info 부재) 추정·미관측. CL 카테고리 내 비의류 경계.
- **후드 집업(CLSTSHD) 지퍼·맨투맨/후드 부속 옵션** — clothes2025 동형 추정·형태별 추가 옵션(지퍼 등) 미관측.
- **인쇄위치 다중선택 가격 합산 규칙** — 좌측가슴 단일(3700) 실측. 앞면+뒷면+소매 동시 선택 시 합산 규칙·위치별 단가 차이 미관측.
- **인쇄방식별 가격 차이** — DTF/DIR 동일(19900) 실측. 실크(SLK)·위치/방식 조합 가격 미관측.
- **CL 전반 PRICE>0 실가** — CLSTSHS 19900(본체16200+위치3700) 실측. CLTMSHS·CLAPDFT 가격 미캡처(구조는 확정).
- **size_color_info HIDE_YN 셀별 가용성 동작** — 셀 단위 HIDE_YN/HIDE_RSN/QUICK_ORD_YN 데이터는 실측, 실제 UI 비활성 캐스케이드 동작 미관측.
