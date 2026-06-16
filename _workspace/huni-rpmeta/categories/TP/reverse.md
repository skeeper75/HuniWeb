# RP 옵션 원자 추출 — TP(디자인템플릿) 카테고리

> 후니 RP-Meta 하네스 파이프라인 ① 산출물 (rpm-reverse-engineer).
> RedPrinting TP 카테고리(23상품) 대표 3상품 원자추출 + 20상품 그룹 횡단 태깅을 **base-data 관리 렌즈**로 역공학.
> 목적 = 메타모델 아키텍트가 "RedPrinting이 **디자인 입력(템플릿/에디터)** 을 어떤 관리 축으로 분리·정규화하는가"를 추상화할 원재료.
> RedPrinting은 사용자 본인 설계 시스템(검증된 참조 모델 — 답습 아님).
> **★TP 카테고리의 본질 = 템플릿/에디터 축. BN(면적·SSR옵션)·GS(완제SKU·variant)에서 미발굴된 "디자인 입력 방식" 축이 TP를 가른다.**

## 출처 표기 규칙
- `[reuse:productInfo]` = huni-widget s6 캘린더 캡처(`_workspace/huni-widget/01_reverse/s3_raw_captures/s6_cal_TP*.json`)의 infoCall 풀 응답(`product_option.option` + `product_data` 전체). TPCLWLB·TPCLECO 보유.
- `[reuse:price-capture]` = 동 캡처 priceCall reqBody/result/query 실측(가격 API `WSP_ACPT_ORDER_TMPL_PCS_PRICE`).
- `[live:SSR]` = 2026-06-17 라이브 읽기전용 GET `/ko/product/item/TP/{code}`. **레거시 jQuery 상품(TPTKDFT)** 은 SSR `<select data-type>` + 인라인 에디터 플래그(`useKoiEditor` 등) 노출 → 추출 성공. **신규 Vue 상품(TPBCDFT·TPCLSTD)** 은 client-render(인라인 플래그/옵션 미노출).
- `[live:catalog]` = `raw/widget_monitor/redprinting_catalog.json` 상품명·URL (2026-06-17 확인).
- `unobserved` = 미관측(날조 금지).

## base_data_tag 7버킷 (가설 — 아키텍트가 최종 확정)
자재(material) / 공정(process) / 옵션(option) / 템플릿(template/SKU) / 제약(constraint) / 기초코드(base-code/enum) / 카테고리(category)

---

## 0. TP 카테고리 핵심 발견 — 디자인 입력(에디터/템플릿) 축이 1급 분리축

TP 상품은 BN·GS와 동일한 서버 base-data 스키마(`pdt_mtrl_info`/`pdt_size_info`/`pdt_pcs_info`/`pdt_dosu_info`)를 그대로 쓴다. **차이는 옵션 트리가 아니라 `product_option.option`의 에디터/템플릿 플래그 묶음**이다. 즉 RedPrinting에서 "디자인 명함"이 "일반 명함"과 다른 건 자재·후가공이 아니라 **디자인을 어떻게 입력받는가(에디터 채널 + 템플릿 자산)** 다.

### 0.1 ★에디터 채널 = 별도 관리축 (TP의 본질 — BN/GS 미발굴)
한 상품의 디자인 입력 방식은 `product_option.option`의 플래그 묶음으로 결정된다:

| 플래그 | 의미 | 값 도메인 |
|--------|------|----------|
| `item_gbn` | 상품 처리 타입(에디터 채널 결정의 상위) | `vDigital_item`(KOI계열)·`edicus_item`(Edicus SDK)·`offset2023_item`(에디터 없음·옵셋) |
| `useKoiEditor` | KOI 웹에디터 사용 | Y/N |
| `useRPEditor` | RedEditor(자체) 사용 | Y/N |
| `useTemplateDownload` | 기성 템플릿 다운로드 제공 | Y/N |
| `usePDF` | PDF 직접 업로드 허용 | Y/N |
| `usePDFordCnt` / `useEditorOrdCnt` | 디자인수(건수) 산정 출처가 PDF/에디터 | Y/N |
| `koi_template_resource_id` / `koiOption[]` | KOI 템플릿 리소스 ID + 템플릿 옵션 배열 | id / 배열(관측분 빈배열) |

**실측 대조 (★ TP vs 비-TP 동종 — 직접 증거):**
| 상품 | item_gbn | useKoiEditor | useRPEditor | useTemplateDownload | usePDF | 채널 해석 | 출처 |
|------|----------|-------------|------------|---------------------|--------|----------|------|
| **TPCLWLB** 큰달력(효도) | vDigital_item | **Y** | N | **Y** | N | KOI에디터 + 기성템플릿(업로드 불가) | `[reuse:productInfo]` |
| **TPCLECO** 에코캘린더 | vDigital_item | **Y** | N | **Y** | **Y** | KOI에디터 + 템플릿 + PDF 병행 | `[reuse:productInfo]` |
| **TPTKDFT** 티켓(디자인) | vDigital_item | **Y** | N | unobs | **Y** | KOI에디터 + PDF (price_gbn=digital_price) | `[live:SSR]` |
| **TPBCDFT** 디자인명함 | unobs(Vue) | unobs | unobs | unobs | unobs | edicus 마커 노출→Edicus SDK 추정 | `[live:SSR]` partial |
| GSCLMGN 마그넷캘린더(비-TP 참조) | **edicus_item** | Y | N | Y | N | ★Edicus SDK 채널 | `[reuse:productInfo]` |
| **HLCLSTD** 옵셋 탁상캘린더(★TPCLSTD의 비-TP 트윈) | **offset2023_item** | **N** | N | **N** | Y | ★에디터 0·템플릿 0·**PDF 업로드 전용** | `[reuse:productInfo]` |
| **HLCLWAL** 옵셋 벽걸이캘린더 | offset2023_item | N | N | N | Y | 에디터 0·PDF 전용 | `[reuse:productInfo]` |

**★핵심 결론 (directive ④ — TP가 추가하는 레이어):** 같은 "탁상 세로 캘린더"라도 **TP(TPCLSTD)** = KOI/RP 에디터 + 기성 템플릿 갤러리(`useTemplateDownload=Y`), **HL(HLCLSTD)** = 에디터·템플릿 전무·PDF 업로드만(`offset2023_item`). 즉 **TP 카테고리가 추가하는 것 = 디자인 입력 레이어(에디터 채널 + 템플릿 자산)이지 자재/후가공/가격구조가 아니다.** 자재·사이즈·후가공·가격은 동종 옵셋/디지털 상품과 공유.

### 0.2 ★에디터 채널 3종 (item_gbn으로 분기)
1. **KOI 에디터** (`vDigital_item` + `useKoiEditor=Y`): TPCL*(달력 디자인류)·TPTKDFT(티켓). 자체 웹에디터. `koi_template_resource_id`로 템플릿 리소스 바인딩, `koiOption[]`이 템플릿 옵션 배열.
2. **Edicus SDK** (`edicus_item`): GSCLMGN(비-TP)·TPBCDFT(디자인명함, 마커 추정). huni-widget 역공학(`seed-redprinting-sdk-analysis.md`)의 RedEditorSDK 45메서드(setCurrentTemplate/getTemplateList/changeTemplate/editTemplate/openVdpViewer/setVariableData) = **VDP(가변데이터인쇄) 템플릿** 지원. 명함류 디자인에 적합.
3. **에디터 없음** (`offset2023_item`, `useKoiEditor=N`·`usePDF=Y`): HL 옵셋 캘린더류. PDF 업로드 전용. ★TP가 아닌 상품.
출처: `[reuse:productInfo]` item_gbn 실측 + `[live:SSR]` 마커 + huni-widget SDK 역공학 `[reuse:price-capture/SDK]`.

### 0.3 ★템플릿 = 옵션도 SKU도 아닌 "별도 디자인 자산" (directive ②)
관측된 템플릿 신호는 **옵션 트리(pdt_pcs_info)에 들어가지 않는다**:
- `useTemplateDownload=Y` = 기성 템플릿 갤러리 제공 플래그(불리언) — 옵션값 아님.
- `koi_template_resource_id` / `koiOption[]` = 에디터가 로드하는 템플릿 리소스 포인터(관측분 null/빈배열 — 비로그인·미선택 상태).
- RedEditorSDK `getTemplateList`/`setCurrentTemplate`/`changeTemplate` = 런타임에 에디터가 템플릿을 **별도 카탈로그에서 선택**(가격·자재·후가공 트리와 독립).
→ **템플릿은 (a)자재처럼 MTRL_CD도 (b)완제처럼 PCS_DTL도 아닌, 에디터에 바인딩되는 별도 자산 레이어.** 가격은 템플릿이 아니라 자재/사이즈/후가공/수량으로 산정(§아래 가격 실측). base_data_tag = **템플릿/SKU**(별도 자산 — 후니에 대응 그릇 부재 가설).

### 0.4 페이지 계층 축 — 캘린더/북류 특유 (★BN/GS 단일면 vs TP 다면)
TPCLECO(에코캘린더) `pdt_prn_cnt_info`: `MIN_INN_PAGE=2, MAX_INN_PAGE=200, STEP_INN_PAGE=1` — 내지 페이지수 입력. TPCLWLB는 `MIN/MAX_INN_PAGE=1`(단면 효도달력). 사진북(TPPHSET)·엽서북(TPCASET)·스케줄러(TPCLWEK)도 동형 페이지 계층 추정. **달력=월별 페이지(12~13면)·북=대수 페이지가 INN_PAGE로 표현.** base_data_tag = 옵션(페이지수) + 제약(min/max/step). 출처 `[reuse:productInfo]` TPCLECO.

---

## 1. TPBCDFT — 디자인 명함 (★템플릿/에디터 축 기본 대표) `[live:SSR]` partial · `[live:catalog]`
source: `redprinting_catalog.json` + 라이브 GET `/ko/product/item/TP/TPBCDFT` (Vue client-render, edicus 마커 4회 노출·인라인 옵션/플래그 미노출).

```
product: TPBCDFT 디자인 명함 (TP)   ★"디자인 명함" = 일반 명함(BC)에 디자인 입력 레이어 추가
디자인 입력 방식 (★핵심 관찰):
  - axis: 에디터 채널        # product_option.option (Vue·인라인 미노출)
    choices: [Edicus SDK 추정]   # edicus 마커 노출. GSCLMGN edicus_item 동형 추정
    cascade: 디자인명함 선택 → 에디터에서 템플릿 선택 or 디자인 입력 (파일 업로드 병행 추정)
    base_data_tag: 템플릿/SKU (에디터 채널 = 디자인 입력 자산)
    note: ★TPBCDFT vs BC(일반 명함) 차이 = "디자인 입력 방식". BC=완성 파일(PDF) 업로드, TPBCDFT=에디터+기성 템플릿 갤러리로 디자인 생성. 자재(용지)·후가공·사이즈는 BC와 공유 추정(unobserved). 명함=VDP 가변데이터(이름/직함) 가능 → Edicus openVdpViewer/setVariableData 적합.
  - axis: 용지(자재) / 후가공 / 사이즈 / 도수 / 수량
    choices: unobserved (Vue client-render·BFF 익명불가)
    base_data_tag: 자재·공정·기초코드 (BC 일반명함 구조 추정 — 명함 90×50 표준)
    note: §0 패턴(pdt_mtrl_info 용지 + pdt_pcs_info 후가공). 실측 아님.
```
**메타모델 시사점:** "디자인 X" 상품(TPBCDFT·TPBCCPN 디자인쿠폰·TPWTDFT 디자인손목띠·TPPOCHR 디자인슬로건·TPCL*디자인캘린더) = **비-디자인 동종(BC/WT/PO/...) + 에디터/템플릿 레이어**. 옵션 트리는 거의 동일, 차이는 `item_gbn`/`useKoiEditor`/`useTemplateDownload`. ★`_ambiguous-fragments.md` T-1(에디터 채널의 관리 그릇) 등재.

---

## 2. TPTKDFT — 티켓(M형/I형/보딩) (★형태 variant + 티켓 특화 + KOI에디터 실측) `[live:SSR]`
source: 라이브 GET `/ko/product/item/TP/TPTKDFT` (레거시 jQuery·SSR select + 인라인 플래그 노출). `[live:catalog]` 상품명.

```
product: TPTKDFT 티켓(M형/I형/보딩) (TP)   price_gbn: digital_price  item_gbn: vDigital_item
디자인 입력 (실측 인라인 플래그):
  useKoiEditor=Y  useRPEditor=N  usePDF=Y   # ★KOI 에디터 + PDF 업로드 병행
axes:
  - axis: 형태 variant (M형/I형/보딩)        # 상품명 "(M형/I형/보딩)"
    choices: [M형, I형, 보딩]   # 티켓 형태 = 형상/레이아웃 variant
    cascade: 형태 선택 → 사이즈/칼틀 동반 (GS THO_CUT 형상 동형 추정)
    base_data_tag: 기초코드(형태 enum) + 공정(칼틀)
    note: 보딩=보딩패스형(긴 직사각+절취선). M/I=세로/가로 레이아웃 추정. SSR엔 형태 select 미노출(JS)·상품명으로 확정.
  - axis: 용지(자재)        # SSR data-type="paper" 실측 11종
    choices: [ART 아트지, SNO 스노우, MAR 매쉬멜로우White, MMW 마제스틱마블화이트, KRB 크라프트보드,
              HNO 반누보화이트, TTR 띤또레또, WMO 백색모조, RAN 랑데뷰내츄럴, ETP 얼스팩]
    base_data_tag: 자재(용지)
    note: 11종 고급지 — 티켓=고급 소량인쇄. BC 명함류 용지군과 공유 추정.
  - axis: 완칼/칼틀        # SSR data-type="THO_EXC" (옵션값 JS렌더)
    choices: unobserved (THO_EXC = 완칼/도무송 칼틀 — 형태별 칼틀 추정)
    base_data_tag: 공정(완칼) + 기초코드(칼틀 형상)
    note: THO_EXC 그룹 존재 확정. 상세 칼틀값 미노출.
  - axis: 코팅        # SSR data-type="COT_DFT"
    choices: unobserved   base_data_tag: 공정(코팅)
  - axis: 부자재        # SSR data-type="SUB_MTR"
    choices: unobserved   base_data_tag: 자재(부자재) + 공정 (GS SUB_MTRL_YN bundle 동형)
    note: ★티켓 부자재 = 넘버링용 잉크/홀더/끈 추정. 티켓 일련번호(넘버링) 가능성.
  - axis: 인쇄 특수(은박/금박 PRT_MAG · 화이트인쇄 PRT_WHT)   # SSR data-type 실측
    choices: unobserved (PRT_MAG=별색/박마그넷? PRT_WHT=화이트언더베이스)
    base_data_tag: 공정(특수인쇄)
    note: PRT_WHT=화이트 인쇄(투명/크라프트 위 흰바탕). PRT_MAG=마그네틱/메탈릭 인쇄 추정.
  - axis: 재단 [CUT_DFT]   base_data_tag: 공정(재단)
  - axis: 수량        # SSR number1_sel
    choices: [USER 직접입력, 1, 2, 3 ...]   base_data_tag: 옵션(수량)
    note: 미싱(절취선)·일련번호(넘버링) = 티켓 특화. SSR에 "미싱" 텍스트 존재 — 미싱 옵션 별도 그룹 추정(unobserved 상세).
티켓 특화 신호 (SSR 텍스트): 미싱·보딩·M형·I형 키워드 확인. 넘버링/일련번호 상세는 unobserved.
```
**메타모델 시사점:** 티켓 = **형태 variant(M/I/보딩) + 티켓 특화 공정(미싱 절취·넘버링) + KOI에디터/PDF 병행**. 형태가 칼틀(THO_EXC)·사이즈 캐스케이드. 미싱·넘버링 = 후니 미발굴 "순차/절취" 공정축 가설(`_ambiguous-fragments.md` T-3).

---

## 3. TPCLSTD — 디자인_탁상 세로 캘린더 (★캘린더 템플릿 축·HL 옵셋 트윈 대조) `[live:catalog]` `[reuse:productInfo]` (자매상품 TPCLWLB/TPCLECO 실측으로 구조 확정)
source: TPCLSTD 라이브 GET = 47바이트 빈응답(client-render·`unobserved`). 구조는 **동일 TPCL* 군 자매(TPCLWLB·TPCLECO) infoCall 실측 + HLCLSTD 비-TP 트윈 대조**로 확정.

```
product: TPCLSTD 디자인_탁상 세로 캘린더 (TP)   item_gbn: vDigital_item(추정·TPCL*군 공통)
디자인 입력 (★HL 옵셋 트윈과 직접 대조 — directive ④):
  TPCLSTD(TP)     → useKoiEditor=Y · useTemplateDownload=Y (KOI에디터+기성템플릿)  [TPCL*군 실측 동형]
  HLCLSTD(비-TP)  → useKoiEditor=N · useTemplateDownload=N · usePDF=Y (에디터0·PDF전용)  [reuse:productInfo 실측]
  ★= TPCLSTD가 HLCLSTD에 추가하는 단 하나 = "디자인 입력 레이어". 자재/사이즈/후가공/가격은 옵셋 캘린더와 공유.
axes (TPCLWLB/TPCLECO 실측 기반·TPCLSTD 직접관측은 unobserved):
  - axis: 에디터 채널 + 템플릿
    choices: [KOI에디터, 기성 디자인 템플릿 갤러리]   # useKoiEditor=Y + useTemplateDownload=Y
    base_data_tag: 템플릿/SKU (디자인 자산 레이어)
    note: ★"디자인_탁상" 접두 = 디자인 템플릿 제공 신호. HL은 디자인 직접 입력(PDF).
  - axis: 용지(자재)        # pdt_mtrl_info (TPCLECO 실측 4종)
    choices: [RXART180 아트지180g, RXSNO180 스노우180g, RXRAU190/210 랑데뷰울트라화이트]
    base_data_tag: 자재(용지·평량)   note: 캘린더 내지 고급지. 평량(180/190/210) variant.
  - axis: 월별 페이지 계층        # pdt_prn_cnt_info INN_PAGE
    choices: [MIN_INN_PAGE~MAX_INN_PAGE]   # TPCLECO: 2~200·STEP1 (탁상=12~13면 추정)
    cascade: 페이지수 = 월수(1~12월+표지). 디자인 수(건수)와 별개.
    base_data_tag: 옵션(페이지/월수) + 제약(min/max/step)
    note: ★캘린더 특유 페이지 계층(§0.4). 시작월/연도는 에디터(KOI 템플릿) 내부 처리 추정(옵션 트리 미노출).
  - axis: 제본        # pdt_pcs_info RIN_DFT/STA_CLD
    choices: [RIN_DFT 링제본(TPCLECO 상철) / STA_CLD 중철 (TPCLWLB 효도달력쫄대)]
    base_data_tag: 공정(제본) + 자재(링/쫄대)
    note: 탁상=링/스프링 제본 추정. 효도달력(TPCLWLB)=중철+쫄대(STA_CLD). 벽걸이=타공/걸이.
  - axis: 포장 [PAK_ETC OPP포장 / PAK_POL 폴리백]   base_data_tag: 공정(포장)
  - axis: 인쇄 [PRT_DFT 단면]        # ★가격 주체 (TPCLWLB PRICE=11900)
    base_data_tag: 공정(인쇄)
  - axis: 수량 (디자인수 ORD_CNT "디자인 수(건수)" + PRN_CNT "수량")   # skinInfo quantityGroup
    base_data_tag: 옵션(이중수량)
    note: ★ORD_CNT="디자인 수(건수)" = PDF/에디터 디자인 종수(usePDFordCnt=Y). PRN_CNT=부수. GS 이중수량 동형.
가격 실측 (TPCLWLB `[reuse:price-capture]` price_gbn=vTmpl_price):
  CUT_DFT 0 + STA_CLD(쫄대) 0 + PAK_POL 0 + PRT_DFT(인쇄) 11900 → result_sum.PRICE=11900 (개당단가, ORD_CNT=13)
  ★가격 주체 = PRT_DFT(인쇄). 템플릿/에디터는 가격 0 (디자인 입력은 무료, 가격은 인쇄/자재/후가공).
```
**메타모델 시사점:** 캘린더 = **에디터+템플릿 레이어(TP) + 페이지 계층(월) + 제본 + 이중수량(디자인수×부수)**. 비-TP 옵셋 트윈(HL)과 옵션·가격 구조 동일, 차이는 디자인 입력 채널뿐. ★directive ④ 직접 증거: 템플릿 레이어 = `useKoiEditor`+`useTemplateDownload` 플래그 2개로 인코딩, 나머지 전부 공유.

---

## 4. TP 20상품 그룹 횡단 태깅 (템플릿 축 렌즈 — 답습 회피, 동형 묶음)

> 대표 3상품(§1~3)으로 추출한 축을 나머지 20상품에 렌즈 적용. 소재/형태만 다른 동형은 그룹으로 묶음. 에디터 채널·템플릿 플래그는 `[reuse:productInfo]` 실측분(TPCLECO/TPCLWLB) 외 전부 `unobserved`(상품명·동형 추정).

### 그룹 A — "디자인 X" 명함/판촉류 (에디터+템플릿 레이어가 본질)
| pdtCode | 상품명 | 비-TP 동종 | 추가 레이어 | base_data_tag | 출처 |
|---------|--------|-----------|------------|---------------|------|
| TPBCDFT | 디자인 명함 | BC 일반명함 | Edicus(추정)+템플릿+VDP | 템플릿/SKU + 자재 + 공정 | `[live:SSR]` partial |
| TPBCCPN | 디자인 쿠폰 | (쿠폰/명함류) | 에디터+템플릿 | 템플릿/SKU + 자재 | `[live:catalog]` unobs |
| TPWTDFT | 디자인 손목띠 | WT 손목띠 | 에디터+템플릿 | 템플릿/SKU + 자재(밴드) + 공정 | `[live:catalog]` unobs |
| TPPOCHR | 디자인 슬로건 | 슬로건/응원 | 에디터+템플릿 | 템플릿/SKU + 자재 + 공정 | `[live:catalog]` unobs |
> 공통: "디자인" 접두 = 동종 상품 + 디자인 입력 레이어. 옵션 트리는 동종과 공유, 차이는 `item_gbn`/에디터 플래그/템플릿. ★메타모델: 에디터 레이어를 옵션 트리와 직교(orthogonal) 축으로.

### 그룹 B — 티켓/박 특수 (형태 variant + 특수인쇄/박)
| pdtCode | 상품명 | 추가축 | base_data_tag | 출처 |
|---------|--------|--------|---------------|------|
| TPTKDFT | 티켓(M/I/보딩) | 형태variant·미싱·넘버링·PRT_WHT/MAG | §2 풀 | `[live:SSR]` |
| TPTKFOI | 박티켓(M/I/보딩) | TPTKDFT + 박(FOI 호일) 공정 | 공정(박) + §2 | `[live:catalog]` unobs |
> TPTKFOI = TPTKDFT + 박(금/은박) 후가공. 박색 variant 추정(GS·아크릴 박 동형). 형태 variant 공유.

### 그룹 C — 캘린더류 (페이지 계층 + 제본 + 에디터/템플릿) — §3 동형
| pdtCode | 상품명 | 제본/형태 | item_gbn(실측) | 페이지 | 출처 |
|---------|--------|----------|---------------|--------|------|
| TPCLSTD | 디자인_탁상 세로 | 링/스프링 | vDigital(추정) | 12~13월 | §3 (자매 실측) |
| TPCLHOL | 디자인_벽걸이 타공형 | 타공+걸이 | 추정 | 12~13월 | `[live:catalog]` unobs |
| TPCLWAL | 디자인_벽걸이 걸이형 | 걸이(쫄대) | 추정 | 12~13월 | `[live:catalog]` unobs |
| TPCLECO | 에코 캘린더 | RIN_DFT 상철·OPP포장 | **vDigital_item** | **2~200면** | `[reuse:productInfo]` ★실측 |
| TPCLWLB | 큰달력(효도) | STA_CLD 중철·쫄대 | **vDigital_item** | 1면 | `[reuse:productInfo]` ★실측 |
| TPCLWEK | 스케줄러 | 데일리(노트형 제본) | 추정 | 다면(주/일) | `[live:catalog]` unobs |
> 캘린더 = 페이지(월/일) 계층 + 제본방식(링/중철/타공/걸이) variant + 에디터/템플릿. 가격 주체=PRT_DFT 인쇄(TPCLWLB 11900 실측). ★HL 옵셋 캘린더(비-TP)와 옵션 동일·에디터만 추가(§0.1).

### 그룹 D — 북류(다면 제본 + 페이지 계층) — §0.4 동형
| pdtCode | 상품명 | 구조 | base_data_tag | 출처 |
|---------|--------|------|---------------|------|
| TPCASET | 엽서북 | 엽서 다매 + 제본(세트/북) | 옵션(페이지) + 공정(제본) + 자재 | `[live:productInfo]` ★실측(§H-8) edicus_item·tmpl_price·수량모델#10 |
| TPPHSET | 사진북 | 사진 다면 + 제본 + 에디터 | 옵션(페이지/대수) + 템플릿 + 공정 | `[live:productInfo]` ★실측(§H-8) edicus_item·tmpl_price·수량모델#10 |
| TPCAPTW | 포토카드-화이트 | 카드 + 화이트(PRT_WHT) + 세트(20장)판매단위 | 자재 + 공정(화이트인쇄) + 수량모델#10 | `[live:productInfo]` ★실측(§H-8) edicus_item·tmpl_price·PDT_UNIT=세트 |
> 북류 = INN_PAGE 페이지 계층 + 제본 + (사진북) 에디터 템플릿. 포토카드=화이트언더베이스 인쇄(투명/펄 위). **세 상품 모두 수량모델#10(ORD_CNT×PRN_CNT) 실측·"세트=서로 다른 N장 assortment" 구조 부재(H-8 REFUTED)**. 판매단위(세트/묶음)는 사이즈별 NOTICE 자유텍스트.

### 그룹 E — 평면 판촉/지류 (에디터+템플릿, 단면/소량)
| pdtCode | 상품명 | base_data_tag | 출처 |
|---------|--------|---------------|------|
| TPWBDFT | 와블러 | 자재 + 공정(완칼/접지) + 템플릿 | `[live:catalog]` unobs |
| TPBLMEO | 프리미엄 떡메 | 자재 + 공정(제본/풀) + 템플릿 | `[live:catalog]` unobs |
| TPBLPST | 프리미엄 점메 | 자재 + 공정(풀제본·점착) + 템플릿 | `[live:catalog]` unobs |
| TPLFSET | 테이블 세팅지 | 자재(지류) + 공정(재단) + 템플릿 | `[live:catalog]` unobs |
| TPSTNME | 네임스티커 | 자재(점착지) + 공정(도무송) + 템플릿 | `[live:catalog]` unobs |
| TPSTPKG | 패키지스티커 | 자재 + 공정(도무송) + 템플릿 | `[live:catalog]` unobs |
| TPDCPST | 데코 페이퍼 | 자재(지류) + 공정 + 템플릿 | `[live:catalog]` unobs |
| TPPOAWD | 상장 | 자재(고급지) + 공정 + 템플릿(상장 양식) | `[live:catalog]` unobs |
> 평면 지류 = 동종 스티커/지류 + 디자인 템플릿. 떡메/점메=메모지 풀제본(BL* 떡메모 동형). 상장=양식 템플릿 강한 후보(VDP 이름 채움).

---

## 5. base-data 축 횡단 종합 (메타모델 아키텍트 입력 — TP 추가분, BN·GS 표와 병합)

| 관리 축 | RedPrinting 표현(TP) | base_data_tag | 메타모델 흡수 단위 | BN/GS 대비 신규? |
|---------|---------------------|---------------|-------------------|------------------|
| **★에디터 채널** | `item_gbn`(vDigital_item/edicus_item/offset2023_item) + `useKoiEditor`/`useRPEditor`/`usePDF`/`useEditorOrdCnt` 플래그 묶음 | 템플릿/SKU (또는 신축 "디자인입력축") | ★상품별 디자인 입력 방식. 옵션 트리와 직교 | ★★신규(TP 본질·BN/GS 미발굴) |
| **★템플릿 자산** | `useTemplateDownload=Y` + `koi_template_resource_id`/`koiOption[]` + SDK getTemplateList/setCurrentTemplate | 템플릿/SKU (별도 자산 레이어) | ★옵션도 SKU도 아닌 에디터 바인딩 자산. 가격 0 | ★★신규 |
| **VDP(가변데이터)** | RedEditorSDK openVdpViewer/setVariableData/getCurrentTemplateVdpList | 템플릿 + 옵션(변수데이터) | 명함/상장 이름·직함 가변 인쇄 | ★신규(명함/상장) |
| **페이지 계층** | `pdt_prn_cnt_info` MIN/MAX/STEP_INN_PAGE (TPCLECO 2~200) | 옵션(페이지) + 제약 | 달력=월/일, 북=대수 페이지수 | ★신규(BN/GS 단면) |
| **형태 variant** | 티켓 M형/I형/보딩, 캘린더 탁상/벽걸이타공/벽걸이걸이 | 기초코드(형태 enum) + 공정(칼틀) | 형태 enum → 사이즈/제본/칼틀 캐스케이드 | (GS THO_CUT 확장) |
| **제본(다면)** | RIN_DFT(링)·STA_CLD(중철쫄대)·타공/걸이 | 공정 + 자재(링/쫄대) | 캘린더/북 제본방식 그룹 | (GS 제본 확장·달력특화 쫄대) |
| **특수인쇄** | PRT_WHT(화이트언더베이스)·PRT_MAG·박(TPTKFOI FOI) | 공정(특수인쇄/박) | 화이트·메탈릭·박 | (GS/AC 박 확장) |
| **티켓 특화** | 미싱(절취선)·넘버링/일련번호(추정 unobs) | 공정(절취/순차) | 절취선·순차번호 | ★신규 가설(unobserved) |
| **이중수량** | ORD_CNT "디자인 수(건수)" × PRN_CNT "수량" (usePDFordCnt) | 옵션(이중수량) | 디자인 종수 × 부수 (디자인입력 연동) | (GS 이중수량 = 디자인수 연동) |
| 자재(용지) | `pdt_mtrl_info` 고급지 11종(TPTKDFT)·평량 variant(TPCLECO 4종) | 자재 | 평량/지종 — 동종 디지털/옵셋 공유 | (공유·신규 아님) |
| 가격 모델 | `vTmpl_price`(TPCLWLB)·`tiered_price`(TPCLECO)·`digital_price`(TPTKDFT) | (가격 엔진) | GS 가격모델 + digital_price. **★템플릿/에디터는 가격 0** | (GS 가격모델 공유) |

### 핵심 패턴 (RedPrinting의 TP 정규화 방식 — "디자인 입력은 직교 레이어")
1. **★에디터 채널 = 옵션 트리와 직교한 별도 관리축** — 같은 상품(캘린더)이 TP면 에디터+템플릿, 비-TP(HL)면 PDF업로드. 옵션/자재/후가공/가격은 동일. RedPrinting은 디자인 입력을 `item_gbn`+플래그 6개로 인코딩, 옵션 트리(pdt_pcs_info)를 오염시키지 않음.
2. **★템플릿 = 가격·옵션 비결합 자산** — `useTemplateDownload`/`koi_template_resource_id`는 불리언/포인터. 가격은 인쇄/자재/후가공(PRT_DFT 등)이 100% 주체, 템플릿/에디터 PCS는 PRICE=0(TPCLWLB 실측). 템플릿은 에디터 SDK가 별도 카탈로그에서 로드.
3. **에디터 3채널** — KOI(vDigital)·Edicus(edicus_item·VDP)·없음(offset2023). 후니 위젯 역공학(huni-widget)이 이미 Edicus SDK 45메서드 계약 확보 → TP 메타모델은 그 계약 재사용.
4. **페이지 계층 + 형태 + 제본** — 캘린더/북류 특유. INN_PAGE(월/일/대수) + 형태 enum(탁상/벽걸이/M/I/보딩) + 제본(링/중철/쫄대/타공). BN/GS 단면 모델 확장.
5. **이중수량이 디자인 입력과 연동** — ORD_CNT="디자인 수(건수)"가 PDF/에디터 디자인 종수(usePDFordCnt). 디자인 입력 채널이 수량축에 직접 영향.

## 라이브 접속 결과 (정직 기록)
- **TPTKDFT (티켓)**: ★레거시 jQuery 상품 — `[live:SSR]` GET 성공. 인라인 에디터 플래그(useKoiEditor=Y/useRPEditor=N/usePDF=Y/price_gbn=digital_price) + 용지 select 11종 + PCS data-type 6종(THO_EXC/CUT_DFT/COT_DFT/SUB_MTR/PRT_MAG/PRT_WHT) + 미싱/보딩/M형/I형 텍스트 추출. PCS 상세 옵션값은 JS렌더(unobserved).
- **TPBCDFT (디자인명함)·TPCLSTD (탁상캘린더)**: 신규 Vue client-render — 인라인 플래그/옵션 미노출. TPBCDFT는 edicus 마커만(채널 추정). TPCLSTD는 47바이트 빈응답. 구조는 동형 자매(TPCLWLB/TPCLECO `[reuse:productInfo]` 실측)로 확정.
- **TPCLWLB·TPCLECO**: ★huni-widget s6 캘린더 캡처에 **풀 infoCall(productInfo) 보유** — `product_option.option` 에디터 플래그 전체 + `product_data`(자재/사이즈/도수/페이지/PCS) + TPCLWLB priceCall 실측(PRICE=11900). TP 에디터/템플릿 축의 1차 증거원.
- **BFF API**: 익명 호출 불가(BN/GS와 동일·세션인증 BFF 뒤).
- **에디터 채널 상세(KOI/Edicus 내부 템플릿 카탈로그·VDP 변수)**: huni-widget 역공학 `seed-redprinting-sdk-analysis.md`의 RedEditorSDK 45메서드 계약으로 추정 — TP별 실제 템플릿 자산 목록은 로그인 에디터 세션 필요(`unobserved`).

## 미관측(unobserved) 요약 — TP
- **TP 신규 Vue 상품(TPBCDFT·TPCLSTD·TPCLHOL·TPCLWAL·TPCLWEK·디자인 X 군) 옵션 상세 + 에디터 플래그** — client-render·BFF 익명불가. item_gbn/useKoiEditor는 동형 자매(TPCLECO/TPCLWLB) 실측 외 추정.
- **템플릿 자산 카탈로그** — `koi_template_resource_id`/`koiOption[]`이 관측분 null/빈배열(비로그인·미선택). 상품별 실제 템플릿 목록·VDP 변수 스키마 미관측(로그인 에디터 필요).
- **티켓 미싱/넘버링/일련번호 상세** — SSR에 "미싱" 텍스트만, 옵션 구조·번호 규칙 JS렌더(unobserved). 순차번호 공정축은 가설.
- **TPTKDFT PCS 상세 옵션값** — THO_EXC(칼틀)/SUB_MTR(부자재)/PRT_MAG·PRT_WHT 그룹 존재 확정, 상세 DTL값 JS렌더.
- **TP 가격 실가 다양성** — TPCLWLB 11900(vTmpl)만 PRICE>0 실측. TPCLECO(tiered)·TPTKDFT(digital)은 가격모델만 확정, 실가는 비로그인 0/미캡처.

## TP 미샘플 상품 (23종 중 대표 3 원자추출·20 그룹 횡단 — 답습 회피)
디자인 X 명함/판촉 4종(§4 A)·티켓/박 2종(B)·캘린더 6종(C·2종 실측)·북 3종(D)·평면지류 8종(E) — 구조 다양성(에디터 3채널·템플릿 자산·페이지 계층·형태 variant·티켓 특화·이중수량)은 대표 3 + 실측 2(TPCLECO/TPCLWLB)로 커버. 메타모델 검증 시 갭(예: VDP 변수 스키마·티켓 넘버링 규칙·상장 양식 템플릿) 발견되면 로그인 에디터 캡처로 추가.

---

## H-8 검증 — 포토카드 set-composition 그릇 (deepcheck 후보 라이브 실측) — **REFUTED**

> deepcheck H-8(codex 제안·`unverified`): "TPCAPTW 1세트 = 서로 다른 20장(각 장마다 다른 디자인) = set-composition(assortment) 그릇 → 수량모델#10(ORD_CNT×PRN_CNT)로 표현 불가". 라이브 productInfo 실측으로 검증.

**실측 출처:** `https://www.redprinting.co.kr/ko/product/get_digital_product_info?pdt_cod=TPCAPTW` (read-only GET, 공개 상품정보 API — 상품페이지가 view 시 호출하는 그 데이터, 주문/POST 아님) · `retCode:200` · 2026-06-17 · 동일 검증 TPCASET(엽서북)·TPPHSET(사진북) 병행. `[live:productInfo]` ★실측

**실측 결과(TPCAPTW):**
| 필드 | 실측값 | 의미 |
|------|--------|------|
| `product_option.option.skinInfo.quantityGroup.title` | `{"orderCnt":"디자인 수 (건수)","printCnt":"수량"}` | **수량모델#10 그대로** — ORD_CNT(디자인 수)×PRN_CNT(수량). codex 주장 "set-composition" 별도 필드 **부재** |
| `pdt_base_info[0].PDT_UNIT` | `"세트"` | 판매 단위 = 세트 |
| `pdt_base_info[0].SET_CNT` | `1` | 주문단위당 1세트 |
| `pdt_base_info[0].ORD_CNT_YN` | `"Y"` | 디자인 수(ORD_CNT) 입력 활성 |
| `pdt_pcs_info[5~11].NOTICE` | `["57x90(mm) 사이즈 : 1세트(20장) 단위로 구매 가능합니다."]` | **"20장" = 같은 디자인 20매/세트 판매단위 안내(자유텍스트 NOTICE)**. 특정 사이즈(57×90)의 pack-unit 배수 |
| `pdt_pcs_info[4].NOTICE` | `["1묶음 95매입니다."]` | 다른 사이즈의 묶음(95매) 안내 — 동일 패턴(같은 디자인 N매 판매단위) |
| set-composition 신호(`서로 다른`·`20종`·`assortment`·`개별 디자인`·`낱장 매핑`) | **0건** | 데이터 어디에도 "장마다 다른 디자인" 구조 부재 |

**판정: REFUTED (기각).**
- 라이브 진실 = **"같은 디자인 1건(또는 ORD_CNT건) × 세트(20장/95매 동일 인쇄) 판매단위"**. `PDT_UNIT="세트"` + 사이즈별 pack-unit(20장/세트)을 **NOTICE 자유텍스트**로 안내. **"각 장마다 다른 디자인" = codex 환각**(데이터 미존재).
- **수량모델#10으로 완전 표현 가능:** ORD_CNT(디자인 수)×PRN_CNT(수량), 여기에 사이즈별 **판매단위 배수(pack/set multiplier)** 1속성만 부가하면 됨(PRN_CNT에 곱해지는 정수 — 이미 known pattern, 신규 그릇 불요).
- **deepcheck "라이브 인용 보유" 주장도 거짓:** codex는 `--sandbox read-only` + `mcp_servers='{}'`(네트워크/웹 툴 0)로 실행 → 라이브 페이지 fetch 불가. "세트당 20종"의 "20종"은 **confabulation**(우리가 codex에 준 컨텍스트엔 "photocard-white (white-ink layering)"만 있었고 "20종/세트구성"은 codex 자력 창작).

**관련 후보 동반 검증:**
- **M-9/M-15/M-16(엽서북·세트구성 계열)과의 관계:** TPCASET(엽서북)·TPPHSET(사진북)도 동일 `quantityGroup.title={"orderCnt":"디자인 수 (건수)","printCnt":"수량"}` 실측 → 북류 역시 수량모델#10 + 페이지계층(INN_PAGE). "세트=서로 다른 N장 assortment" 구조 **세 상품 모두 부재**. M-14(엽서북 절취+제본=assembly)는 별개 사안(이번 검증 범위 아님·여전히 unobserved).

**신규 발굴(부수·실측 정정):** §4 그룹D의 TPCAPTW/TPCASET/TPPHSET `[live:catalog] unobs` → `[live:productInfo]` 실측으로 격상. 세 상품 모두 `item_gbn=edicus_item`·`price_gbn=tmpl_price`·`useKoiEditor=Y`·`usePDF=N` 실측(이전 "VDP/에디터 추정" 확정). 단 **판매단위 배수(PDT_UNIT/SET_CNT/pack NOTICE)는 메타모델 미보유 속성** — 수량모델#10의 minor 속성으로 흡수 권고(신규 축 아님). → `_ambiguous-fragments.md` T-8 등재.

---

## Ambiguous fragments (메타모델 단계로 이관 — 아키텍트가 버킷 확정)

- **T-1 에디터 채널의 관리 그릇** — `item_gbn`/`useKoiEditor`/`useRPEditor`/`usePDF`/`useEditorOrdCnt`가 ① 상품 속성(컬럼) ② 별도 "디자인입력축" 테이블 ③ 템플릿/SKU 레이어 중 어디? 옵션 트리(pdt_pcs_info)와 직교하므로 자재/공정/옵션 7버킷 어디에도 깔끔히 안 들어감. 후니 t_*에 대응 그릇 부재 가설(vessel-gap). → 신축 메타모델 축 후보 1순위.
- **T-2 템플릿 자산의 정체** — `useTemplateDownload`+`koi_template_resource_id`+SDK getTemplateList. 템플릿이 (a)옵션값 (b)완제SKU (c)에디터 종속 별도 자산 중 무엇? 가격 0(인쇄/자재가 가격) → "옵션도 SKU도 아닌 디자인 자산". 후니 `t_prd_templates`(완제SKU용·봉투/OTC)와 의미 충돌 — TP 템플릿은 "디자인 시안"이지 "완제 SKU"가 아님. 같은 단어 다른 의미 → 아키텍트 분리 필요.
- **T-3 티켓 넘버링/미싱(순차·절취) 공정** — SSR "미싱" 텍스트만, 일련번호/넘버링은 unobserved. 순차번호(가변 증분)·절취선이 ① 공정 ② VDP 변수 ③ 옵션 중 무엇? 후니 미발굴 "순차/절취" 축 가설.
- **T-4 "디자인 X" 상품의 모델링 단위** — TPBCDFT(디자인명함) vs BC(일반명함)가 ① 별도 pdtCode(RedPrinting 방식·관측됨) ② 한 상품의 "에디터 사용 여부" 플래그 중 어디로 관리? RedPrinting=별도 상품(코스터 6소재 분리와 동형 의사결정). 후니=상품 분리 vs 옵션화 결정 필요(GS G-2와 동류 모호성).
- **T-5 PRT_WHT/PRT_MAG 특수인쇄의 버킷** — 화이트언더베이스(PRT_WHT)·메탈릭(PRT_MAG)이 공정인가 도수(별색)인가 자재(백색잉크)인가? 후니 "별색=공정·잉크색≠자재"(round-22 경계규칙)과 대조 필요. 박(TPTKFOI FOI)은 공정 확정.
- **T-6 STA_CLD 쫄대(달력 봉)의 자재/공정 이중성** — 효도달력 STA_CLD "쫄대"가 자재(금속/플라스틱 봉)인가 공정(중철+봉부착)인가. GS 제본(링=자재+꿰기=공정) bundle과 동형 — 옵션=자재+공정 BUNDLE 케이스 추가.
- **T-7 페이지 계층(INN_PAGE)이 옵션인가 차원인가** — 캘린더 월수(2~200면 STEP1)가 ① 옵션(택1) ② 수량성 차원 ③ 사이즈/페이지 차원 중 무엇? 가격과 결합방식 미관측(TPCLECO tiered_price와 INN_PAGE 관계 unobserved).
- **T-8 판매단위 배수(pack/set multiplier)의 버킷** [H-8 검증 부산물·실측] — TPCAPTW `PDT_UNIT="세트"`+`SET_CNT=1`+사이즈별 NOTICE "1세트(20장)"/"1묶음 95매"가 ① 사이즈 행 속성(차원) ② 수량모델 minor 속성(PRN_CNT 배수) ③ 기초코드(판매단위 enum) 중 어디? RedPrinting은 **자유텍스트 NOTICE**로 인코딩(구조화 안 됨) → 후니 그릇 설계 시 "사이즈별 판매단위 배수" 정수 컬럼 vs 기초코드 결정 필요. **set-composition(assortment) 신규 그릇은 불요**(H-8 REFUTED). 아키텍트가 수량모델 흡수 vs 사이즈 속성 판정.
