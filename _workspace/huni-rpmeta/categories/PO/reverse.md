# RP 옵션 원자 추출 — PO(포맥스·폼보드·등신대·피켓) 카테고리

> 후니 RP-Meta 하네스 파이프라인 ① 산출물 (rpm-reverse-engineer). PO = 13번째 카테고리(★선별 모드 프로브).
> RedPrinting PO 카테고리(7상품) 대표 5상품 원자추출 + 전 7상품 횡단 태깅을 **base-data 관리 렌즈**로 역공학.
> 목적 = 메타모델 아키텍트가 "RedPrinting이 **경질 기재(포맥스/폼보드×두께×검정 variant)·제작방식(합지 vs 직접출력)·컷아웃 형상(모양재단)·자립 구조(등신대 거치대/피켓 손잡이)·걸이(와이어)·타일링(대형 분할출력)** 을 어떤 관리 축으로 분리·정규화하는가"를 추상화할 원재료.
> RedPrinting은 사용자 본인 설계 시스템(검증된 참조 모델 — 답습 아님).
> **★PO directive 최대 관전 = ① 마운팅/제작방식(합지=종이 출력물을 보드에 합지 vs 직접출력=보드에 직접 인쇄)이 distinct #18 "기재마운팅" 관리축인가 ② 자립 구조(등신대 자립 컷아웃·피켓 손잡이)가 distinct #18 "자립구조" 관리축인가, 아니면 기존 17축(자재#1 기재·공정#2 합지/코팅·형상#17 모양재단·부속물#8 거치대·완제SKU)에 무왜곡 흡수되는가.**
> **★결론 선요약(1차 예측): distinct #18 = NO(흡수 우세).** ① **제작방식(합지/직접출력) = pdtCode 분기 + paper 옵션값 분기**(합지=검정 포맥스/폼보드 variant 추가·직접출력=기본만) = **자재#1(기재 variant) + 공정#2(합지 라미 공정)로 분해 흡수**. ② **자립 구조 = `CUT_ZUN_ZDFRM` 모양재단(형상#17 SHAPE) + `CDL_DFT` 등신대거치대 부자재(부속물#8 add-on) + `WIR` 와이어 걸이(부속물#8)** — PH 거치(탁상용/벽걸이)가 옵션 캐스케이드로 흡수·distinct #18 부결된 것과 동형. **PO 특유 = 옵션 select/icon으로 명시 실측(PH는 client-render·AC는 SSR-negative였음) → distinct 부결이 "관측 기반"으로 격상.** ★유일한 약한 후보 = "기재 마운팅(합지)을 공정#2로 볼지 별 제작방식 축으로 볼지" → Ambiguous PO-1 회부.

## 출처 표기 규칙 (BN/GS/TP/PR/ST/CL/AC/PH 계승)
- `[live:SSR-legacy]` = 2026-06-20 라이브 읽기전용 GET `https://www.redprinting.co.kr/ko/product/item/PO/{code}` = HTTP 200(~300KB). **PO 7상품 전부 레거시 jQuery SSR 렌더**(`real_item`/`real_price` = 대형실사출력 모델) — 인라인 `product_option` JS 객체 + 렌더된 `<select><option>` + 옵션아이콘(`ordericon/real/*.png`) + `opt_use_yn` 부자재 토글 **전부 SSR 노출**. **★PO는 PH(Vue client-render·SSR-negative)·AC(SSR-negative)와 달리 옵션이 SSR로 완전 노출 → distinct 판정이 관측 기반(추정 아님).** 옵션 select·skin_view 플래그·price_gbn/pdt_gbn/cate·옵션아이콘·부자재 토글 실측. 캡처 파일=`/tmp/po_{code}.html`(휘발·재현 가능).
- `[live:catalog]` = `raw/widget_monitor/redprinting_catalog.json`(2026-06-20 확인, PO 7상품 전부 category=PO·URL=/item/PO/).
- `[xref:PH]`/`[xref:AC]`/`[xref:ST]` = `categories/{PH,AC,ST}/reverse.md` 동형 대조(PH 거치 캐스케이드 부결·AC 두께/소재variant·ST 형상#17 SHAPE).
- `unobserved` = 미관측(날조 금지). PO는 SSR 완전노출이라 unobserved 거의 없음.

## base_data_tag 7버킷 (가설 — 아키텍트가 최종 확정)
자재(material) / 공정(process) / 옵션(option) / 템플릿(template/SKU) / 제약(constraint) / 기초코드(base-code/enum) / 카테고리(category)

---

## 0. PO 카테고리 핵심 발견 — 경질 기재 인쇄물, 제작방식·자립구조가 전부 기존 옵션 슬롯에 실측 흡수

PO = **사진/그래픽을 경질 기재(포맥스/폼보드)에 출력한 홍보용 POP**. cate = `대형실사출력 > 홍보용POP > 포맥스/폼보드`(POMXPRT 실측 `cate1=대형 실사출력·cate2=홍보용POP·cate3=포맥스/폼보드`). price_gbn=`real_price`·pdt_gbn=`real_item` = **BN 현수막·대형실사와 동일 가격모델**(면적 기반).

### 0.1 ★제작방식(합지 vs 직접출력) = pdtCode 분기 + paper 옵션값 분기 (별 select 아님) — directive 관전 1
제작방식은 **상품을 가르는 pdtCode 분기**이며, 동시에 **paper(기재) select 값 차이**로 인코딩(`[live:SSR-legacy]` paper select 실측):

| pdtCode | 상품명 | 제작방식 | paper(기재) 옵션값 | 핵심 차이 |
|---------|--------|----------|---------------------|-----------|
| POMXPRT | 포맥스 직접출력 | 직접출력 | 포맥스 3T/5T/8T/10T (4) | 기본 포맥스만 |
| POMXHAP | 포맥스 합지(파인아트) | 합지 | 포맥스 3T/5T/8T/10T + **검정포맥스 3T/5T/8T** (7) | 검정 기재 variant 추가 |
| POFMPRT | 폼보드 직접출력 | 직접출력 | 폼보드 3T/5T/10T (3) | 기본 폼보드만 |
| POFMHAP | 폼보드 합지(파인아트) | 합지 | 폼보드 3T/5T/10T + **검정폼보드 3T/5T/10T** (6) | 검정 기재 variant 추가 |
| POFMPCK | 폼보드 피켓 | 직접출력 | 폼보드 5T (1) | 단일 기재(피켓 전용) |
| POSTPRT | 등신대(포/폼) 직접출력 | 직접출력 | 포맥스 3T/5T/8T/10T + 폼보드 3T/5T/10T (7) | 포맥스+폼보드 둘 다 |
| POSTHAP | 등신대(포/폼) 합지 | 합지 | 포맥스 4 + 검정포맥스 3 + 폼보드 3 + 검정폼보드 3 (13) | 둘 다 + 검정 variant |

→ **제작방식(합지/직접출력)이 상품을 가르되**, 한 상품 내 "제작방식 select"는 **없음**(별 옵션축 아님). 합지 상품의 차이 = ① **검정 기재 variant 추가**(검정포맥스/검정폼보드 = 자재#1 색/면 variant) ② "파인아트" 마감(상품명) = **합지 = 종이에 인쇄 후 보드에 라미네이트하는 별 공정**. base_data_tag = **자재#1(기재=포맥스/폼보드×두께×검정) + 공정#2(합지 라미네이트)**. **★AC 소재variant(투명/거울 = pdtCode 분기)·ST 점착소재 spectrum·PH 프레임재질 분기와 완전 동형 — "제작방식"은 자재 variant + 공정으로 분해 흡수(distinct 아님). 단 "합지"가 별 제작방식 축인지 공정#2 facet인지 경계 → PO-1 회부.**

### 0.2 ★기재(포맥스/폼보드) × 두께(3T/5T/8T/10T) × 검정 = paper select 한 슬롯에 합성 (자재#1 facet)
paper select 한 값 = `포맥스 5T` / `검정폼보드 3T` 처럼 **기재종류 × 두께 × 색을 한 리터럴에 합성**(`[live:SSR-legacy]`). 별 "두께 select"·별 "기재 select" 없음.
- 기재종류: 포맥스 / 폼보드 (등신대는 둘 다 한 paper에 합성)
- 두께: 3T / 5T / 8T / 10T (포맥스 4단·폼보드 3단[8T 없음])
- 색: (기본 흰색) / 검정 (합지 상품만)
- 보조: `paper_sub_select`(주문가능용지) = paper 선택 후 종속 필터(캐스케이드)

→ base_data_tag = **자재#1(기재 = 포맥스/폼보드, 두께·색 facet)**. **★AC 두께(3T/5T = mat_cd 직교)·ST 점착소재 동형 — 두께는 자재의 facet, distinct 축 아님.** `[xref:AC]` 두께 = mat_cd 직교 패턴 재확인.

### 0.3 ★자립 구조 = 모양재단(형상#17) + 거치대 부자재(부속물#8) + 와이어(부속물#8) — directive 관전 2, PH 거치 부결 동형
PO의 자립/걸이는 **3개 기존 슬롯**으로 분해 실측(`[live:SSR-legacy]` 옵션아이콘 `ordericon/real/*.png` + 부자재 토글):

| 자립/걸이 요소 | 인코딩 | 위젯 | 값 | base_data_tag | 동형 |
|----------------|--------|------|-----|---------------|------|
| **컷아웃 형상**(등신대 인물형/피켓 형태) | `CUT_ZUN`(재단) 옵션아이콘 | 라디오 | 정사이즈재단(`CUT_ZUN_ZDINC`) / **모양재단(`CUT_ZUN_ZDFRM`)** | **형상#17 SHAPE + 공정#2(컷팅)** | `[xref:ST]` 형상#17·완칼 |
| **등신대 거치대** | `CDL_DFT` 부자재 토글 | 체크박스+select | 700mm / 1200mm / 1500mm | **부속물#8(add-on) + 옵션** | `[xref:PH]` 거치 캐스케이드 |
| **와이어 걸이** | `WIR_DFT`/`WIR_MTR` 부자재 | 체크박스 | 와이어 세트 / 레일용(`DFRAL`) / 피스용(`DFSRW`) | **부속물#8(add-on) + 옵션** | BN 현수막 고리·아일렛 |

- **`CDL_DFT` = `opt_use_yn('CDL_DFT')` 선택형 부자재 토글**(부자재 섹션 `sub_opt2_tr`·`<th>부자재</th>`) — 켜면 거치대 사이즈 select 노출. **등신대거치대는 별 상품으로도 존재**(`GS/GSSBMTL/detail/54` = 굿즈 부자재). 즉 거치대 = 본 상품에 add-on 결합되는 독립 부자재 SKU.
- **★피켓(POFMPCK)은 거치대(CDL)·와이어 없음**(실측 `cdl거치대=False·와이어=False`) — 손잡이 보드라 자립/걸이 부자재 불필요. 모양재단만 있음(피켓 형태 컷). → **자립방식이 상품을 가르되(등신대=거치대 add-on·피켓=내재 손잡이), 전부 기존 슬롯(형상#17 + 부속물#8)으로 분해.**
- **★PH 거치(탁상용/벽걸이) = 옵션 캐스케이드 상위차원으로 흡수·distinct #18 부결**된 것과 동형. PO 거치대는 한술 더 떠 **명시 부자재 SKU add-on**(GS/GSSBMTL)으로 분리관리 → distinct "자립구조 축" 불필요(부속물#8이 무왜곡 흡수). base_data_tag = **부속물#8 + 옵션(add-on 가산)**.

### 0.4 ★타일링(TIL) = 대형 분할출력 공정 — 대형실사 고유 (BN 동형)
옵션아이콘 `TIL_NON`(타일링없음)·`TIL_HGH`(세로타일링)·`TIL_WDT`(가로타일링) = 대형 인쇄물을 여러 장으로 분할출력(`[live:SSR-legacy]`, 전 PO 공통 `타일링=True`). base_data_tag = **공정#2(분할출력)** 또는 **옵션(생산방식 택1)**. BN 현수막 대형출력 동형 — 대형실사(real_item) 카테고리 고유 생산옵션. distinct 아님.

### 0.5 PO 공통 축 전수 (옵션 select·아이콘 실측)
| 축 | 슬롯 | 값 | base_data_tag |
|----|------|-----|---------------|
| 기재(paper) | `paper`+`paper_sub_select` | 포맥스/폼보드×두께×검정 | 자재#1 |
| 인쇄면(sodu) | `sodu` | 단면 / 양면 (등신대=단면 고정) | 도수#3 또는 공정#2(인쇄면) |
| 사이즈(size) | `size`+`CUT_WDT_SEL`/`CUT_HGH_SEL` | 1000X1000 고정 + **사이즈 직접입력**(가로/세로 직접) | 사이즈#5(비규격 직접입력=면적) |
| 코팅(COT_DFT) | 옵션아이콘 | 무광(`_MA`)/유광(`_GL`) — **합지 상품만**(HAP=True·PRT=False) | 공정#2(후가공) |
| 타일링(TIL) | 옵션아이콘 | 없음/세로/가로 | 공정#2 §0.4 |
| 재단(CUT_ZUN) | 옵션아이콘 | 정사이즈재단/모양재단 | 형상#17+공정#2 §0.3 |
| 부자재(CDL/WIR) | 부자재 토글 | 거치대/와이어 | 부속물#8 §0.3 |
| 수량 | `number1_sel`(디자인 수/건수) + `number4_sel`(1배~10배=면적배수) | 1~10 / 1배~10배 | 옵션(수량/가격) |

→ **★코팅이 합지(HAP) 상품에만 활성**(직접출력 PRT=비활성) = 합지 = 종이출력+라미+코팅 가능, 직접출력 = 보드 직접인쇄(코팅 불가). **제작방식(§0.1)이 후가공 가용성(코팅)에 캐스케이드** — 제작방식 = 자재+공정 묶음의 실증.

---

## 1~5. 대표 5상품 원자 추출

### POMXPRT 포맥스 직접출력 `[live:SSR-legacy]`
```
product: POMXPRT 포맥스 직접출력 (PO) — real_item/real_price, cate=대형실사출력>홍보용POP>포맥스/폼보드
axes:
  - axis: 기재(paper)            choices: [포맥스 3T, 5T, 8T, 10T]   cascade: paper_sub_select 종속필터   price_flag: 면적단가 차등   tag: 자재
  - axis: 인쇄면(sodu)           choices: [단면, 양면]               cascade: none   price_flag: 양면 가산   tag: 도수/공정
  - axis: 사이즈(size)           choices: [1000X1000, 사이즈 직접입력] cascade: 직접입력→CUT_WDT/HGH 노출   price_flag: 면적×number4_sel(배수)   tag: 사이즈
  - axis: 재단(CUT_ZUN)          choices: [정사이즈재단, 모양재단]    cascade: none   price_flag: 모양재단 가산   tag: 형상(#17)+공정
  - axis: 타일링(TIL)            choices: [없음, 세로, 가로]          cascade: none   price_flag: 분할 가산   tag: 공정
  - axis: 거치대(CDL_DFT)        choices: [700, 1200, 1500mm]         cascade: opt_use_yn 토글ON→select   price_flag: add-on 가산   tag: 부속물(#8)+옵션
  - axis: 와이어(WIR)            choices: [세트, 레일용, 피스용]      cascade: opt_use_yn 토글   price_flag: add-on 가산   tag: 부속물(#8)
  - axis: 수량                   choices: [디자인수 1~10, 1배~10배]    cascade: none   price_flag: 수량×면적배수   tag: 옵션/가격
  - note: 코팅 비활성(직접출력=보드 직접인쇄). 제작방식이 후가공 가용성에 캐스케이드.
```

### POMXHAP 포맥스 합지(파인아트) `[live:SSR-legacy]`
```
product: POMXHAP 포맥스 합지(파인아트) (PO)
axes: (POMXPRT와 동일) + 차이:
  - axis: 기재(paper)            choices: [포맥스 3T/5T/8T/10T, 검정포맥스 3T/5T/8T] (7)   tag: 자재 — ★검정 variant 추가(합지 고유)
  - axis: 코팅(COT_DFT)          choices: [무광, 유광]                cascade: none   price_flag: 가산   tag: 공정 — ★합지 상품만 활성
  - note: 합지 = 종이 인쇄→보드 라미네이트(파인아트). 제작방식=자재variant+공정.
```

### POFMPRT 폼보드 직접출력 `[live:SSR-legacy]` (기재 대비)
```
product: POFMPRT 폼보드 직접출력 (PO)
axes: (POMXPRT 동형) + 차이:
  - axis: 기재(paper)            choices: [폼보드 3T, 5T, 10T] (3·8T 없음)   tag: 자재 — ★기재만 폼보드로 분기(포맥스 vs 폼보드 = paper 옵션값 차이)
  - note: 포맥스/폼보드 = 같은 옵션 스키마·paper 값만 다름. 기재 = 자재 facet(별 카테고리 아님).
```

### POFMPCK 폼보드 피켓 `[live:SSR-legacy]` (자립=손잡이 내재)
```
product: POFMPCK 폼보드 피켓 (PO)
axes:
  - axis: 기재(paper)            choices: [폼보드 5T] (1 고정)        tag: 자재 — 피켓 전용 단일 기재
  - axis: 사이즈(size)           choices: [사이즈 직접입력] (고정값 없음) tag: 사이즈 — 피켓은 직접입력만
  - axis: 재단(CUT_ZUN)          choices: [정사이즈, 모양재단]        tag: 형상(#17) — 피켓 형태 컷
  - axis: 코팅/타일링/수량        (POMXPRT 동형)
  - ★없음: 거치대(CDL)·와이어(WIR) 부자재 — 피켓은 손잡이 보드(자립/걸이 add-on 불필요)
  - note: ★자립방식 차이(피켓=내재 손잡이 vs 등신대=거치대 add-on)가 부자재 슬롯 유무로 인코딩. distinct "자립구조 축" 불필요 — 부속물#8 add-on 유무로 흡수.
```

### POSTPRT 등신대(포/폼) 직접출력 `[live:SSR-legacy]` (자립=거치대 add-on)
```
product: POSTPRT 등신대(포/폼) 직접출력 (PO)
axes:
  - axis: 기재(paper)            choices: [포맥스 3T/5T/8T/10T, 폼보드 3T/5T/10T] (7)   tag: 자재 — ★포맥스+폼보드 둘 다(등신대=기재 선택폭)
  - axis: 인쇄면(sodu)           choices: [단면] (양면 없음)          tag: 도수/공정 — 등신대=단면 고정(뒷면 거치)
  - axis: 재단(CUT_ZUN)          choices: [정사이즈, 모양재단]        tag: 형상(#17) — ★등신대 인물형 컷아웃=모양재단
  - axis: 거치대(CDL_DFT)        choices: [700, 1200, 1500mm]         cascade: opt_use_yn 토글   price_flag: add-on 가산   tag: 부속물(#8) — ★자립=거치대 부자재 SKU(GS/GSSBMTL 독립상품)
  - axis: 와이어(WIR)            choices: [세트/레일용/피스용]        tag: 부속물(#8)
  - note: ★등신대 자립 = 모양재단(형상#17, 컷아웃) + 거치대(부속물#8, add-on). 둘 다 기존 슬롯. PH 거치 부결 동형·관측 기반 격상.
```

---

## 6. directive 최대 관전 1차 판정 — 기재마운팅/자립구조 = distinct #18인가 흡수인가

| 후보 축 | 인코딩 위치 | 동형 기존 축 | 1차 예측 | 근거 |
|---------|-------------|--------------|----------|------|
| **제작방식(합지/직접출력)** | pdtCode 분기 + paper 옵션값(검정 variant) + 코팅 캐스케이드 | 자재#1 variant + 공정#2(라미) | **흡수 (자재#1+공정#2)** | §0.1 — AC/ST/PH 재질 분기 동형·합지=라미 공정 실증(코팅 가용성 캐스케이드) |
| **기재(포맥스/폼보드×두께)** | paper select 합성값 | 자재#1(두께=facet) | **흡수 (자재#1)** | §0.2 — AC 두께 mat_cd 직교 동형 |
| **컷아웃 형상(모양재단)** | `CUT_ZUN_ZDFRM` 옵션아이콘 | 형상#17 SHAPE(ST 기원) | **흡수 (형상#17)** | §0.3 — ST 완칼/형상 동형·전 PO 공통 |
| **자립 구조(등신대 거치대/피켓 손잡이)** | `CDL_DFT` 부자재 토글(있음/없음) | 부속물#8 add-on(BN 고리·AC 받침) | **흡수 (부속물#8)** | §0.3 — 거치대=GS/GSSBMTL 독립 SKU add-on·피켓=내재(부자재 무) |
| **걸이(와이어)** | `WIR_DFT/MTR` 부자재 | 부속물#8 | **흡수 (부속물#8)** | §0.3 |
| **타일링(분할출력)** | `TIL` 옵션아이콘 | 공정#2(BN 대형출력) | **흡수 (공정#2)** | §0.4 |

**★1차 예측: distinct 신규 축 #18 = NO(전부 17축 흡수, 관측 기반).**
- **기재마운팅(합지/직접출력) = 자재#1 variant + 공정#2(라미)로 분해** — 합지가 별 제작방식 축이 아니라 검정 기재 variant 추가 + 라미 공정 + 코팅 가용성으로 인코딩. **PH 프레임재질·AC 소재variant 분기 동형.**
- **자립구조(등신대/피켓) = 형상#17(모양재단 컷아웃) + 부속물#8(거치대 add-on SKU)로 분해** — 별 "자립구조 축" 불필요. **PH 거치(탁상용/벽걸이)가 옵션 캐스케이드로 흡수·distinct #18 부결된 것과 완전 동형.** ★PO 우월점 = PH(client-render)·AC(SSR-negative)와 달리 옵션이 **SSR 완전노출**·거치대가 **명시 부자재 SKU(GS/GSSBMTL)** → distinct 부결이 "판정불가/추정"이 아니라 **관측 기반 부결**(ST 형상#17 승격·PD/AC/PR 재포화와 같은 결정 기준).
- **17축 안정성 = PO의 모든 관측 옵션이 기존 17축으로 무왜곡 흡수 → 안정(13번째 카테고리 재포화).** distinct #18 후보 0 — PH 거치 부결 + ST 형상 승격 이후 일관된 승격/부결 기준(전용 슬롯 라이브 실재 + KB 결함 둘 다 충족해야 승격) 적용 시, 자립/마운팅은 **전용 슬롯이 기존 부속물#8/형상#17으로 충분히 표현됨(왜곡 없음) → 부결**.

---

## Ambiguous fragments (아키텍트 회부)

> PO 카테고리 모호 fragment. PO-넘버 사용.

### PO-1 — "합지(제작방식)"가 공정#2(라미네이트) facet인가 별 "제작방식" 관리축인가
- 합지(HAP) vs 직접출력(PRT)은 **pdtCode 분기**이며, 차이는 ① 검정 기재 variant 추가(자재#1) ② "파인아트" 라미 마감(공정#2) ③ 코팅 가용성 캐스케이드(직접출력=코팅 불가)로 인코딩. 한 상품 내 "제작방식 select"는 없음.
- 회부 = ① 공정#2 facet(합지 = 라미네이트 공정)으로 흡수(현재 1차 예측) ② "제작방식(직접출력/합지/UV직접)"이 후니에서 별 enum 차원(기초코드#)으로 필요한가. 동형 = BN 현수막 인쇄방식·ST 인쇄방식(UV/DTF/후지) 분기 — RP는 pdtCode로 가르나 후니 그릇에 "제작방식" 명시 차원이 있는지는 **gap 분석 대상**. 1차 예측 = 공정#2 흡수.

### PO-2 — 등신대 거치대(CDL_DFT)가 PO 옵션 add-on인가 GS 독립 부자재 SKU인가 (다중 귀속)
- 거치대는 `CDL_DFT` 부자재 토글(PO 상품에 add-on)이면서 동시에 `GS/GSSBMTL`(굿즈 부자재 독립상품)으로 카탈로그 존재. = **한 부자재가 두 경로(본상품 add-on + 독립 SKU)로 관리.**
- 회부 = 부속물#8 add-on이 **독립 부자재 SKU를 참조**하는 구조인가(template#/완제SKU 결합), 아니면 옵션값 복제인가. BN 아일렛·AC 받침 add-on과 동형 — 부속물 = 자재/공정 BUNDLE + add-on 가산. distinct 아님이나 "add-on이 독립 SKU 참조" 정규화는 아키텍트 판정.

### PO-3 — number4_sel(1배~10배 면적배수)가 수량인가 가격 면적계수인가
- `number1_sel`(디자인 수/건수)와 별도로 `number4_sel`(1배~10배). 대형실사(real_price) = 면적 기반 가격 → "배수"는 출력 면적 배수(가격계수)일 가능성. BN 현수막 동형(면적×배수).
- 회부 = 수량(옵션) vs 면적 가격계수(가격축) 경계. real_price 가격엔진 실측 필요(이번 미확보=가격엔진 역공학은 huni-widget 영역). 1차 = 가격/옵션 경계 표기.

### PO-4 — "사이즈 직접입력"(비규격 면적)이 사이즈#5 enum인가 면적 연속차원인가
- size select = `1000X1000` 1개 고정 + `사이즈 직접입력`(CUT_WDT_SEL/CUT_HGH_SEL 가로세로 직접). = 사실상 **비규격 면적 연속차원**(이산 규격 거의 없음). BN 현수막·실사 동형(면적매트릭스).
- 회부 = 사이즈#5(이산 enum)이 아니라 **면적 연속차원**(가로×세로 구간) — `[xref]` dbmap 면적매트릭스(siz_width/siz_height 구간). PO 사이즈 = 이산 siz_cd 아님, 면적축. distinct 아님(BN과 동형). 정규화 = 면적매트릭스 그릇.

---

## 라이브 보강 여부
- **라이브 보강 = YES(SSR-legacy 7상품 전부 GET 200·옵션 SSR 완전노출).** PH(client-render 재캡처 필요)·AC(SSR-negative)와 달리 **PO는 추가 client-render 불요** — `<select>`·옵션아이콘·부자재 토글·캐스케이드 전부 SSR 1회 GET으로 실측. distinct 판정 = 관측 기반(추정/판정불가 0).
- 미관측(정직 표기): real_price 가격엔진 실제 계산(number4 배수 의미·면적단가) = huni-widget 가격역공학 영역, 이번 미확보. 옵션 미관측 0(PO 특유 슬롯 전부 확보).
