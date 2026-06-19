# RP 옵션 원자 추출 — FS(패브릭·봉제 완제 직물 굿즈) 카테고리

> 후니 RP-Meta 하네스 파이프라인 ① 산출물 (rpm-reverse-engineer).
> RedPrinting FS 카테고리(**21상품**)를 **base-data 관리 렌즈**로 역공학한 원자 옵션 레코드.
> 목적 = 메타모델 아키텍트가 "RedPrinting이 **패브릭(직물) 인쇄 + 봉제 완제 굿즈**의 ① 직물 자재(면사 수) ② 타일링(반복 패턴) ③ 마감봉제 ④ 패브릭 전용 가공(라벨/끈/포켓/봉/고리) 을 어떤 관리 축으로 분리·정규화하는가"를 추상화할 원재료.
> RedPrinting은 사용자 본인 설계 시스템(검증된 참조 모델 — 답습 아님).
> **★FS 카테고리 정체 = 면직물(패브릭)에 풀프린팅한 뒤 재단·봉제·마감하여 완성하는 직물 굿즈** (코스터·포스터(현수막형)·쿠션·파우치·에코백·테이블보·스카프·스크런치).
> **★directive 1순위 모드: "신규 축 가능성 높은 것만 선별" — distinct #18 후보 = ① 타일링(반복패턴) ② 마감봉제 구조 ③ 직물 물성(면사 수). 1차 예측 = 흡수(facet)** 우세, 단 **타일링은 PR/ST/CL 어디에도 없던 신규 fragment**라 아키텍트 주목 표시(아래 §0.3·Ambiguous FS-1).

## 출처 표기 규칙 (BN/GS/TP/PR/ST/CL/AC/PD/PH 계승)
- `[live:SSR]` = 2026-06-19 라이브 읽기전용 GET `/ko/product/item/FS/{code}` (HTTP 200·345~400KB). **레거시 jQuery `productOrder` 위젯**(Vue 신상품 아님 — 5상품 전수 vueMarkers=0·legacySelects 44~61 실측). SSR `<select>`(paper/sodu/size)·라디오(clr_info/TILL/SEW/PAPER_WH)·체크박스(SID_FBR/SEW_FBR/CUT_ZUN/LAB_FBR/LIN_PRT/POC_FBR/WRK_MTR/PDT_WRK/SUB_MTR/PAK_POL)가 서버 렌더된 **실관측**. (PCS 상세 enum·가격은 infoCall AJAX 후행 — 1차 옵션 슬롯·라디오/체크박스 값만 확보, 일부 단가 `unobserved`.)
- `[live:SSR-marketing]` = 라이브 상세 페이지 마케팅 카피(detail alt·TIP). **옵션 아님** — 직물/봉제 물리 특성 서술. 옵션과 엄격 구분(날조 방지).
- `[live:catalog]` = `raw/widget_monitor/redprinting_catalog.json` 상품명·URL·category (2026-06-19 확인, FS 21상품 전부 category=FS·URL=/item/FS/).
- `[reuse:*]` = **FS는 재사용 캡처 0** — huni-widget에 FS 캡처 부재. 라이브 SSR이 1차.
- `[xref:CL/PD/GS]` = CL 의류 본체색/사이즈(`categories/CL/reverse.md`)·PD 봉제 구조물/SEW_LTR/PDT_WRK(`categories/PD/reverse.md`)·GS 본체소재 facet·완제SKU(`categories/GS/reverse.md`) 대조 표기.
- `unobserved` = 미관측(날조 금지). 직물 도메인 일반지식으로 옵션 날조 금지.

## base_data_tag 7버킷 (가설 — 아키텍트가 최종 확정)
자재(material) / 공정(process) / 옵션(option) / 템플릿(template/SKU) / 제약(constraint) / 기초코드(base-code/enum) / 카테고리(category)

---

## 0. FS 카테고리 핵심 발견 — 패브릭 인쇄+봉제는 BN 현수막 가공 + PD 봉제 + 신규 "타일링"의 합성

FS 5 대표상품 전수가 **레거시 `productOrder` 위젯 + paper/sodu/size 동형 슬롯 + FBR-접미 PCS 그룹**을 쓴다(`[live:SSR]` 5상품 실측). **★PD와 달리 `price_gbn`이 `tmpl_price`가 아니라 `real_price`(포스터)/`real_calc_price`(나머지 4)** — FS는 완제 SKU 단가표가 아니라 **면적/실계산 가격모델**(BN 현수막·실사 동형). 이것이 FS를 PD(완제 구조물·tmpl) 와 구분하는 정체 신호.

### 0.1 ★출력자재 = 면사 수(綿絲, cotton count) 직물 라이브러리 (PD 원단·CL 평량(oz) 동형, 단위 다름)
`paper` select = 면직물 본체이며 **면사 굵기("수")로 분기**(`[live:SSR]` 실측):

| 상품 | paper 값(면사 수) | MTRL_CD | base_data_tag |
|------|------------------|---------|---------------|
| FSSQPST 패브릭 포스터 | 면10수·면20수·면40수·면60수 화이트 | PXFBW010/020/040/060 | 자재(직물·면사 수) |
| FSCUDFT 패브릭 쿠션 | 면10수·면20수 화이트 | PXFBW010/020 | 자재 |
| FSBGECO 에코백 | 면10수·면20수 화이트 | PXFBW010/020 | 자재 |
| FSPUSTR 스트링 파우치 | 면20수·면40수 화이트 | PXFBW020/040 | 자재 |
| FSBDSCR 스크런치 | 면60수 화이트(1종) | PXFBW060 | 자재 |

★FS 자재 = **면직물(cotton), 면사 수(10/20/40/60수)가 평량 차원**. MTRL_CD 인코딩 `PXFBW0NN`(FB=fabric·W=white·NN=수). CL 의류 평량(oz)·PD 원단(면10수/슬리퍼/PU)과 **동형 — 비종이 직물 자재**(`[xref:CL/PD]`). 색은 화이트 1종(인쇄로 컬러 구현·CL 54색 스와치와 대조). base_data_tag = 자재#1(직물·면사 수 평량). (FS-3)

### 0.2 ★도수 = 상품별 단면/양면 분기 (쿠션만 양면 — 물리적 양면 봉제)
`sodu` select(`[live:SSR]` 실측): 포스터·에코백·파우치·스크런치 = **단면(SID_S)**, 쿠션(FSCUDFT) = **양면(SID_D)**. ★쿠션은 앞뒤 두 면을 봉제해 양면 인쇄 = 도수가 *봉제 구조(양면)*를 반영. base_data_tag = 기초코드(도수). + 별색 `SID_FBR`(아래 §0.5).

### 0.3 ★★타일링(TILL_WH_GBN) = FS 신규 fragment (반복패턴 인코딩 — 17축 어디에도 없던 것)
**5상품 전수에 `TILL_WH_GBN` 라디오 존재**(`[live:SSR]` 실측): `TIL_NON`(타일링없음)·`TIL_HGH`(세로타일링)·`TIL_WDT`(가로타일링).

- **의미:** 큰 패브릭 면(포스터/테이블보)에 디자인을 **세로/가로로 반복(타일) 배치**하거나 반복 안 함. icon_txt 라벨 "타일링없음/세로타일링/가로타일링"(`[live:SSR]`).
- **★이것은 BN/GS/TP/PR/ST/CL/AC/PD 전 카테고리 어디에도 없던 슬롯** — 직물 풀프린팅 특유의 "패턴 반복 배치" 차원.
- **1차 예측(흡수 vs 후보):** 타일링은 ① 가격에 영향(반복 배치 = 인쇄 면적/방식 변화·가격플래그 추정 `unknown`) ② 디자인 입력/에디터 배치 방식 = **공정(인쇄 배치)** 또는 **옵션(레이아웃)** 으로 흡수될 가능성 우세. **단 어느 기존 17축(자재/사이즈/도수/공정/별색/위치/에디터채널…)에도 "패턴 반복(tiling/repeat)" 의미가 명시적으로 없음** → distinct #18 후보로 **아키텍트에 명시 라우팅**(Ambiguous FS-1). ST 형상#17·CL 인쇄위치 승격 기준(전용 슬롯 라이브 실재 + 후니 KB 결함 둘 다)과 대조 필요. base_data_tag = 공정(인쇄 배치) **또는** 신규 옵션축(미확정).

### 0.4 ★방향(PAPER_WH) = 가로(W)/세로(H) 본체 방향 (포스터에서 관측)
FSSQPST `PAPER_WH` 라디오 = `W`(가로)·`H`(세로)(`[live:SSR]`). 본체 직물의 방향(가로/세로). 사이즈 직접입력 시 가로/세로 치수 입력(icon_txt "가로"·"세로"). base_data_tag = 사이즈#13(방향 facet) 또는 옵션(레이아웃). (FS-2 일부)

### 0.5 ★별색(SID_FBR) = 패브릭 전용 별색 슬롯 (6색 × 농도 3단)
FSSQPST `clr_info_SID_FBR` 라디오 = **6색(BLK/WHT/RED/YEL/SKY/GRE) × DF001/DF002/DF003 농도** = 18조합, `SID_FBR_SUB_RADIO`(DF001/002/003)(`[live:SSR]` 실측). icon_txt 라벨 없으나 코드명이 별색(spot color) 패브릭 인쇄. ★CL Pantone 1124·ST/PR 별색과 달리 **FS는 6 기본색 × 3 농도 제한 도메인**(직물 날염 한계). base_data_tag = 공정(별색·round-22 경계 별색=공정) + 기초코드(색 enum). (FS-4)

### 0.6 ★마감봉제(SEW_FBR_SUB_RADIO) = 직물 가장자리 마감 4종 (PD 봉제 확장)
FSSQPST `SEW_FBR_SUB_RADIO` = `RNDFT`(기본/오버로크)·`RNRIN`(리본/말아박기)·`RNSML`(작은마감)·`RNVEL`(벨크로)(`[live:SSR]`). icon_txt "얇은 오버로크(2mm)/두꺼운 오버로크(4mm)/말아박기(1cm)" 노출. ★PD `SEW_LTR`(레더재봉)·CL 봉제와 동형 **봉제 공정#2 family** — 단 FS는 *가장자리 마감(edge finish: 오버로크/말아박기/벨크로)* 이라는 직물 특화 봉제. base_data_tag = 공정(마감봉제·family 멤버). (FS-5)

### 0.7 ★현수막형 행잉/봉 가공 (포스터=패브릭 현수막) — BN 동형
FSSQPST icon_txt: "행잉가공·테두리가공·봉-일반형·봉-고리형·작은고리·벨크로·hooker_selectall"(`[live:SSR]`). ★패브릭 포스터 = **천 현수막** → BN 현수막 행잉/봉/고리/거치 가공과 **완전 동형**(`[xref:BN]` 후가공그룹). base_data_tag = 공정(현수막 마감·BN family) + 부속물#8(봉/고리). 즉 "패브릭 포스터"는 FS이면서 BN 현수막 가공축을 그대로 상속.

### 0.8 ★패브릭 전용 PCS 그룹 = FBR-접미 공정 family (제품별 봉제 완제 가공)
체크박스 PCS 슬롯(`[live:SSR]` 5상품 실측·icon_txt 라벨):

| 상품 | PCS 슬롯 | icon_txt 라벨 | 공정 의미 | base_data_tag |
|------|---------|--------------|----------|---------------|
| 전 5상품 | `CUT_ZUN_CHK` | 재단/정사이즈재단/규격모양재단 | 직물 재단 | 공정(재단)+사이즈 cascade |
| FSSQPST | `SID_FBR_CHK` | (별색) | 패브릭 별색 | 공정(별색)→§0.5 |
| FSSQPST | `SEW_FBR_CHK` | 봉-일반/고리·오버로크·말아박기·벨크로 | 마감봉제 | 공정(봉제)→§0.6 |
| FSCUDFT 쿠션 | `SUB_MTR_CHK`(SUB_MTR_SUB_SELECT TN001 사각쿠션솜) | 쿠션가공·추가부자재 | 솜 충전 부자재 | 자재(솜)+부자재#8 |
| FSCUDFT/BGECO/PUSTR/BDSCR | `PDT_WRK_CHK` | 제품가공/쿠션가공/에코백가공/스트링파우치가공/스크런치가공 | ★제품별 봉제 완제 가공 | 공정(제품가공·family) |
| FSBGECO/PUSTR/CUDFT | `LAB_FBR_CHK` | 라벨가공·라벨커스텀 | 라벨 부착 | 공정(라벨)+자재(라벨) |
| FSBGECO | `LIN_PRT_CHK` | 끈·끈커스텀 | 에코백 끈 | 자재(끈)+공정 |
| FSBGECO | `POC_FBR_CHK` | 포켓가공·내부포켓 | 내부 포켓 | 공정(포켓봉제)+자재 |
| FSBGECO | `WRK_MTR_CHK` | 부자재작업·자석부착 | 부자재(자석) 작업 | 자재(자석)+부자재#8 |
| FSCUDFT/BDSCR | `PAK_POL_CHK` | 폴리백 개별포장 | 포장 | 공정(포장) |

★핵심: `PDT_WRK`(제품가공)의 icon_txt가 **상품마다 다른 완제 가공명**(쿠션가공/에코백가공/스트링파우치가공/스크런치가공) = **각 직물 굿즈의 봉제 완성 공정이 동일 PDT_WRK 슬롯에 인코딩**(PD `PDT_WRK` 제품가공·CL PDT_WRK 인쇄위치와 같은 슬롯·다른 의미). `LAB_FBR/LIN_PRT/POC_FBR/WRK_MTR` = 라벨/끈/포켓/부자재 **FBR-접미 패브릭 전용 슬롯**이지만 의미상 **자재(라벨/끈/자석 부자재) + 공정(부착봉제)** = AC/ST/PD SUB_MTR BUNDLE 동형(`[xref:AC/ST/PD]`). 새 "조립축" 없음 — 전부 공정#2 + 부속물#8 family로 흡수. (FS-5·FS-6)

### 0.9 수량 모델 = number1_sel(수량) (전 카테고리 동형·일부 number2 부재)
`number1_sel`(수량 직접입력)(`[live:SSR]` 5상품). number2_sel(건수)은 일부 상품 부재(포스터/쿠션은 단일수량·BN 현수막형). base_data_tag = 수량모델#10. 가격 결합 `unobserved`(infoCall 후행).

---

## 1. FSSQPST — 패브릭 포스터 (★패브릭 현수막·real_price·BN+타일링 합성) [live:SSR]

```
product: FSSQPST 패브릭 포스터 (FS)
source: [live:SSR] /ko/product/item/FS/FSSQPST (HTTP 200, 400KB, 2026-06-19) · [live:catalog]
price_gbn: real_price (★면적/실계산 — BN 현수막·실사 동형, PD tmpl_price 아님)
axes:
  - axis: 출력자재(paper)
    choices: [면10수화이트(PXFBW010), 면20수(PXFBW020), 면40수(PXFBW040), 면60수(PXFBW060)]
    cascade: 면사 수→직물 질감/가격 추정(unobserved)
    price_flag: unknown(infoCall 후행)
    base_data_tag: 자재#1(직물·면사 수 평량)
    note: [live:SSR] 면사 수=평량 차원. CL oz·PD 원단 동형.
  - axis: 방향(PAPER_WH)
    choices: [W(가로), H(세로)]
    base_data_tag: 사이즈#13(방향 facet) 또는 옵션
    note: [live:SSR] icon_txt "가로/세로". 본체 방향.
  - axis: 도수(sodu)
    choices: [단면(SID_S)]
    base_data_tag: 기초코드(도수)
  - axis: ★타일링(TILL_WH_GBN)
    choices: [타일링없음(TIL_NON), 세로타일링(TIL_HGH), 가로타일링(TIL_WDT)]
    cascade: 반복 패턴 배치→인쇄 면적/레이아웃 변화(unobserved)
    price_flag: unknown(반복 배치 가격영향 추정)
    base_data_tag: 공정(인쇄 배치) 또는 신규 옵션축(★FS-1 distinct #18 후보)
    note: [live:SSR] ★17축 어디에도 없던 fragment. 직물 풀프린팅 패턴 반복.
  - axis: 별색(clr_info_SID_FBR / SID_FBR_CHK)
    choices: [6색(BLK/WHT/RED/YEL/SKY/GRE) × DF001/DF002/DF003 농도 = 18조합]
    cascade: SID_FBR_SUB_RADIO(DF001/002/003) 농도
    price_flag: unknown(별색 가산 추정)
    base_data_tag: 공정(별색·round-22) + 기초코드(색 enum)
    note: [live:SSR] CL Pantone 1124와 달리 6색×3농도 제한 도메인(직물 날염).
  - axis: 사이즈(size)
    choices: [700X1000(740x1040), 750X750(790x790), 800X1400, 900X1200, 1000X1300, USER(직접입력)]
    cascade: 사이즈→재단/봉 가공 cascade
    price_flag: ★면적 기반(real_price)
    base_data_tag: 사이즈#13(프리셋4+자유·면적)
    note: [live:SSR] BN 현수막 사이즈모델 동형(프리셋+USER 직접입력). 괄호=재단여백 포함 실치수.
  - axis: 마감봉제(SEW_FBR_CHK / SEW_FBR_SUB_RADIO)
    choices: [기본/오버로크(RNDFT), 리본/말아박기(RNRIN), 작은마감(RNSML), 벨크로(RNVEL)]
    cascade: 가장자리 마감 봉제
    price_flag: unknown
    base_data_tag: 공정(마감봉제·family 멤버)
    note: [live:SSR] icon_txt "얇은오버로크(2mm)/두꺼운오버로크(4mm)/말아박기(1cm)". PD SEW_LTR 동형.
  - axis: 현수막 행잉/봉 가공(icon_txt)
    choices: [행잉가공, 테두리가공, 봉-일반형, 봉-고리형, 작은고리, 벨크로, hooker_selectall]
    cascade: 거치/걸이 부속
    base_data_tag: 공정(현수막 마감·BN family) + 부속물#8(봉/고리)
    note: [live:SSR] ★패브릭 포스터=천 현수막 → BN 후가공축 상속(xref:BN).
  - axis: 재단(CUT_ZUN_CHK)
    choices: [재단, 정사이즈재단]
    base_data_tag: 공정(재단) + 사이즈 cascade
  - axis: 수량(number1_sel)
    choices: [수량 직접입력]
    base_data_tag: 옵션/수량모델#10
non-axes: "패브릭 현수막 천소재" 등 = [live:SSR-marketing] 카피.
```

---

## 2. FSCUDFT — 패브릭 쿠션 (★양면 봉제·솜 충전 부자재·real_calc_price) [live:SSR]

```
product: FSCUDFT 패브릭 쿠션 (FS)
source: [live:SSR] /ko/product/item/FS/FSCUDFT (HTTP 200, 355KB, 2026-06-19) · [live:catalog]
price_gbn: real_calc_price (실계산)
axes:
  - axis: 출력자재(paper)
    choices: [면10수화이트(PXFBW010), 면20수(PXFBW020)]
    base_data_tag: 자재#1(직물·면사 수)
  - axis: 도수(sodu)
    choices: [양면(SID_D)]
    base_data_tag: 기초코드(도수·★양면=앞뒤 봉제 구조 반영)
    note: [live:SSR] FS 유일 양면(쿠션 앞뒤 두 면 봉제).
  - axis: ★타일링(TILL_WH_GBN)
    choices: [타일링없음, 세로타일링, 가로타일링]
    base_data_tag: 공정(인쇄 배치) 또는 신규축(FS-1)
    note: [live:SSR]
  - axis: 사이즈(size)
    choices: [일반(440x440)]
    cascade: none(1프리셋)
    base_data_tag: 사이즈#13(고정 프리셋)
    note: [live:SSR] 쿠션 단일 규격.
  - axis: 솜 충전(SUB_MTR_CHK / SUB_MTR_SUB_SELECT)
    choices: [사각쿠션솜(TN001), 선택안함]
    cascade: 솜 추가→완제 쿠션
    price_flag: unknown(솜 가산 추정)
    base_data_tag: 자재(솜·충전재) + 부자재#8
    note: [live:SSR] ★솜=완제 부자재(쿠션 충전). icon_txt "쿠션가공". 선택적(커버만 vs 완제).
  - axis: 제품가공(PDT_WRK_CHK)
    choices: [Y] (icon_txt "쿠션가공/제품가공")
    base_data_tag: 공정(제품가공·family)
    note: [live:SSR] 봉제 완성 공정.
  - axis: 라벨가공(LAB_FBR_CHK)
    choices: [Y] (icon_txt "라벨가공/라벨커스텀")
    base_data_tag: 공정(라벨 부착) + 자재(라벨)
    note: [live:SSR]
  - axis: 재단(CUT_ZUN_CHK) / 포장(PAK_POL_CHK)
    choices: [재단/규격모양재단, 폴리백 개별포장]
    base_data_tag: 공정(재단/포장)
  - axis: 수량(number1_sel)
    base_data_tag: 옵션/수량모델#10
non-axes: "솜과 커버 분리" 등 = [live:SSR-marketing].
```

---

## 3. FSBGECO — 에코백(풀프린팅) (★완제 가방·끈/포켓/자석 부자재·real_calc_price) [live:SSR]

```
product: FSBGECO 에코백(풀프린팅) (FS)
source: [live:SSR] /ko/product/item/FS/FSBGECO (HTTP 200, 358KB, 2026-06-19) · [live:catalog]
price_gbn: real_calc_price
axes:
  - axis: 출력자재(paper)
    choices: [면10수(PXFBW010), 면20수(PXFBW020)]
    base_data_tag: 자재#1(직물·면사 수)
  - axis: 도수(sodu)
    choices: [단면(SID_S)]
    base_data_tag: 기초코드(도수)
  - axis: ★타일링(TILL_WH_GBN)
    choices: [타일링없음, 세로타일링, 가로타일링]
    base_data_tag: 공정(인쇄 배치) 또는 신규축(FS-1)
  - axis: 사이즈(size)
    choices: [세로형(440x850), 가로형(490x770)]
    cascade: 형태(세로/가로)↔치수 1:1
    base_data_tag: 사이즈#13(형태=프리셋·PD 형상 흡수 동형)
    note: [live:SSR] 가방 형태(세로/가로)=사이즈 프리셋(ST 형상#17 1:多 아님).
  - axis: 끈(LIN_PRT_CHK)
    choices: [Y] (icon_txt "끈/끈커스텀")
    cascade: 끈 자재/길이 커스텀
    base_data_tag: 자재(끈) + 공정(부착봉제)
    note: [live:SSR] ★에코백 손잡이 끈=부자재.
  - axis: 내부포켓(POC_FBR_CHK)
    choices: [Y] (icon_txt "포켓가공/내부포켓")
    base_data_tag: 공정(포켓봉제) + 자재
    note: [live:SSR]
  - axis: 부자재작업/자석(WRK_MTR_CHK)
    choices: [Y] (icon_txt "부자재작업/자석부착")
    base_data_tag: 자재(자석) + 부자재#8
    note: [live:SSR] ★자석 잠금 부자재. AC WRK_MTR 동형.
  - axis: 라벨가공(LAB_FBR_CHK)
    choices: [Y] (icon_txt "라벨가공")
    base_data_tag: 공정(라벨)+자재(라벨)
  - axis: 제품가공(PDT_WRK_CHK)
    choices: [Y] (icon_txt "에코백 가공/제품가공")
    base_data_tag: 공정(제품가공·family)
    note: [live:SSR] ★icon_txt "에코백 가공"=상품별 완제 봉제명.
  - axis: 재단(CUT_ZUN_CHK)
    choices: [재단/규격모양재단]
    base_data_tag: 공정(재단)
  - axis: 수량(number1_sel)
    base_data_tag: 옵션/수량모델#10
note: FSBGTOT(토트에코백)·FSBGSTB(스트링백팩)·FSBGPCA(필통) 동형(가방류·끈/포켓/자석 부자재 조합만 상이). §9 횡단.
```

---

## 4. FSPUSTR — 스트링 파우치 (★파우치 완제·real_calc_price) [live:SSR]

```
product: FSPUSTR 스트링 파우치 (FS)
source: [live:SSR] /ko/product/item/FS/FSPUSTR (HTTP 200, 361KB, 2026-06-19) · [live:catalog]
price_gbn: real_calc_price
axes:
  - axis: 출력자재(paper)        choices: [면20수(PXFBW020), 면40수(PXFBW040)]   base_data_tag: 자재#1
  - axis: 도수(sodu)             choices: [단면(SID_S)]                          base_data_tag: 기초코드
  - axis: ★타일링(TILL_WH_GBN)   choices: [없음/세로/가로]                       base_data_tag: 공정(배치) 또는 신규축(FS-1)
  - axis: 사이즈(size)           choices: [소(140x460), 중(180x360), 대(275x640)]  base_data_tag: 사이즈#13(치수 프리셋)
  - axis: 제품가공(PDT_WRK_CHK)  choices: [Y] (icon_txt "스트링 파우치 가공")     base_data_tag: 공정(제품가공·family)
  - axis: 라벨가공(LAB_FBR_CHK)  choices: [Y] (icon_txt "라벨가공")              base_data_tag: 공정(라벨)+자재
  - axis: 재단(CUT_ZUN_CHK)      choices: [재단/규격모양재단]                    base_data_tag: 공정(재단)
  - axis: 수량(number1_sel)      base_data_tag: 옵션/수량모델#10
note: FSPUHOT(핫팩파우치)·FSPULUB(도시락파우치) 동형(파우치류). §9 횡단.
```

---

## 5. FSBDSCR — 스크런치(곱창머리끈) (★소형 봉제 variant·real_calc_price) [live:SSR]

```
product: FSBDSCR 스크런치(곱창머리끈) (FS)
source: [live:SSR] /ko/product/item/FS/FSBDSCR (HTTP 200, 346KB, 2026-06-19) · [live:catalog]
price_gbn: real_calc_price
axes:
  - axis: 출력자재(paper)        choices: [면60수(PXFBW060) 1종]                base_data_tag: 자재#1
  - axis: 도수(sodu)             choices: [단면(SID_S)]                          base_data_tag: 기초코드
  - axis: ★타일링(TILL_WH_GBN)   choices: [없음/세로/가로]                       base_data_tag: 공정(배치) 또는 신규축(FS-1)
  - axis: 사이즈(size)           choices: [M(720x120), L(720x170)]               base_data_tag: 사이즈#13(M/L 치수 프리셋)
    note: ★사이즈가 "M/L" variant처럼 보이나 720x120/720x170 치수 1:1=사이즈 흡수(CL size grid 아님·PD 단수 동형).
  - axis: 제품가공(PDT_WRK_CHK)  choices: [Y] (icon_txt "스크런치가공")          base_data_tag: 공정(제품가공·family)
  - axis: 재단(CUT_ZUN_CHK)      choices: [재단/정사이즈재단]                    base_data_tag: 공정(재단)
  - axis: 포장(PAK_POL_CHK)      choices: [폴리백 개별포장]                      base_data_tag: 공정(포장)
  - axis: 수량(number1_sel)      base_data_tag: 옵션/수량모델#10
note: FSSCHUM(스카프)·FSSCANI(반려동물 스카프)=직물 액세서리 동류(타일링+마감봉제). §9 횡단.
```

---

## 6. 횡단 태깅 요약 (FS 5대표상품)

| 축 | 슬롯/필드 | base_data_tag | 메타모델 매핑 | 기존 축 / 신규 |
|----|----------|---------------|--------------|---------------|
| 출력자재 | paper(PXFBW0NN 면사 수) | 자재#1(직물·면사 수 평량) | 자재#1 | 기존(CL oz·PD 원단 동형) |
| 방향 | PAPER_WH(W/H) | 사이즈#13(방향) 또는 옵션 | #13 facet | 기존 |
| 도수 | sodu(단면/양면) | 기초코드(도수) | #6 | 기존(쿠션 양면=봉제 구조) |
| ★타일링 | TILL_WH_GBN(없음/세로/가로) | 공정(인쇄 배치) 또는 신규축 | ★#18 후보 또는 공정#2 facet | ★신규 fragment(FS-1) |
| 별색 | SID_FBR(6색×3농도) | 공정(별색)+기초코드(색) | 공정#2(별색 family) | 기존(round-22·CL Pantone 축소판) |
| 사이즈 | size(프리셋+USER/형태/M·L) | 사이즈#13 | #13(BN 면적·PD 형상 흡수) | 기존 |
| 마감봉제 | SEW_FBR(오버로크/말아박기/벨크로) | 공정(마감봉제·family) | 공정#2 | 기존(PD SEW_LTR 동형) |
| 현수막 행잉/봉 | icon_txt(행잉/봉/고리/벨크로) | 공정(현수막 마감)+부속물#8 | 공정#2+#8 | 기존(BN family 상속) |
| 제품가공 | PDT_WRK(쿠션/에코백/파우치/스크런치 가공) | 공정(제품가공·family) | 공정#2 | 기존(PD/CL PDT_WRK 슬롯·다른 의미) |
| 라벨/끈/포켓/자석 | LAB_FBR/LIN_PRT/POC_FBR/WRK_MTR | 자재(라벨/끈/자석)+공정(부착) | 부속물#8 BUNDLE+공정#2 | 기존(AC/ST/PD SUB_MTR 동형) |
| 솜 충전 | SUB_MTR_SUB_SELECT(TN001 쿠션솜) | 자재(충전재)+부자재#8 | #8 | 기존 |
| 재단/포장 | CUT_ZUN/PAK_POL | 공정(재단/포장) | 공정#2 | 기존 |
| 수량 | number1_sel | 옵션/수량모델#10 | #10 | 기존 |
| 가격모델 | price_gbn=real_price/real_calc_price | 가격#11(면적/실계산) | #11 라우팅 | 기존(★PD tmpl 아님·BN/실사 동형) |
| **봉제 완제 구조** | (옵션 미노출 일부·고정 제조) | 카테고리#7 내재 제조레시피 | 완제품 정체 | distinct 아님(PD 동형) |

**★1차 판정(directive 1순위 — 신규 축 선별 모드):**
- **distinct #18 후보 = ① 타일링(TILL_WH_GBN) 단 1건.** 17축 어디에도 "패턴 반복/타일 배치" 의미가 명시적으로 없음 → **유일하게 "흡수로 무왜곡인가" 적대 검증 필요한 fragment**(FS-1). 1차 예측은 **공정#2(인쇄 배치) facet 흡수 우세**(반복 배치=인쇄 공정 파라미터)이나, 후니 KB에 "인쇄 레이아웃/반복" 슬롯이 없으면 vessel-gap 가능 → 아키텍트/갭분석가 라우팅.
- **나머지 전부 흡수(distinct 0):** 직물 자재(면사 수)=자재#1(CL oz·PD 원단 동형)·마감봉제=공정#2(PD SEW_LTR)·라벨/끈/포켓/자석=부속물#8 BUNDLE(AC/ST/PD SUB_MTR)·솜=자재(충전재)·제품가공=공정#2·현수막 가공=BN family 상속·별색=공정#2(CL Pantone 축소)·방향=사이즈#13·가방 형태=사이즈 프리셋(PD 형상 흡수).
- **봉제 구조 distinct 부결 재확인:** PD(스툴/슬리퍼/계단)에서 "조립·구조·3D폼" #18 부결한 판정과 일관 — FS 봉제 완제(쿠션/에코백/파우치)도 봉제=공정#2·완제 구조=카테고리#7/생산형태#15. 봉제는 PD에서 이미 공정 family 멤버로 수용 입증.

**17축 안정성 = 거의 재포화(10번째 카테고리·distinct 0~1).** FS는 가장 이질적인 "직물 풀프린팅+봉제 완제 굿즈"이지만 **타일링 1건을 제외하면 17축 무손실 흡수.** ★FS의 진짜 기여 = ① 자재#1에 "면직물·면사 수(綿絲 count)" 평량 단위 추가 입증(지종×평량 외 직물 차원) ② 공정#2에 "마감봉제(edge finish: 오버로크/말아박기/벨크로)" family 멤버 추가 ③ 가격#11 라우팅이 완제 봉제 굿즈도 `real_calc_price`(면적/실계산)로 처리(PD tmpl과 분기) ④ ★타일링이라는 **반복-배치 차원**을 metamodel/validator가 흡수 vs 신축 판정하도록 던짐.

---

## 7. 샘플 충분성·모집단 정의

**catalog category=FS 모집단 = 21상품**: 평면 인쇄형(FSSHCOS 코스터·FSSQPST 포스터·FSSQPOC 엽서·FSSQLCT 노렌·FSSQTBC/TBR/TBM 테이블보류) · 봉제 완제형(FSCUSHP/CUDFT 쿠션·FSCVPIL 베개커버·FSSTCVR 방석커버) · 파우치류(FSPUHOT/STR/LUB·FSBGPCA 필통) · 가방류(FSBGECO/TOT/STB) · 직물 액세서리(FSBDSCR 스크런치·FSSCANI/HUM 스카프). `[live:catalog]` 2026-06-19 확인.

**대표 5 = 구조 다양성 superset:** ① 패브릭 현수막형(FSSQPST·real_price·BN 행잉/봉+타일링+별색+마감봉제 풀슬롯) ② 양면 봉제+솜 충전(FSCUDFT·쿠션) ③ 완제 가방·끈/포켓/자석 부자재(FSBGECO) ④ 파우치 완제(FSPUSTR) ⑤ 소형 봉제 variant(FSBDSCR). FS 신규축 후보(타일링·마감봉제·면사 수·완제 봉제 가공) 전부 5대표로 실측. **나머지 16상품 = 소재(면사 수)·형태·부자재 조합만 다른 동형**(타일링+마감봉제+PDT_WRK 공통 — 답습 전수수집 회피, §9 묶음 기록).

### §9. FS 16 횡단(소재/형태/부자재만 다른 동형)
| 군 | pdtCode | 대표 동형 | 차이 |
|----|---------|----------|------|
| 코스터/엽서/노렌/테이블류 | FSSHCOS·FSSQPOC·FSSQLCT·FSSQTBC·FSSQTBR·FSSQTBM | FSSQPST 평면형 | 사이즈/마감봉제 조합·테이블러너=긴형 |
| 쿠션/커버류 | FSCUSHP·FSCVPIL·FSSTCVR | FSCUDFT 양면+솜 | 모양쿠션=형상·베개/방석=커버(솜 없음 추정·unobserved) |
| 파우치/필통 | FSPUHOT·FSPULUB·FSBGPCA | FSPUSTR 파우치 | 핫팩/도시락=용도·필통=가방류 끈 |
| 가방류 | FSBGTOT·FSBGSTB | FSBGECO 가방 | 토트/스트링백팩=끈/형태 |
| 직물 액세서리 | FSSCANI·FSSCHUM | FSBDSCR 스크런치 | 스카프=대형·반려동물=형상 |

추가 표본 필요 시(소재 물성·부자재 단가·타일링 가격영향) 재진입. 메타모델 핵심 판정(distinct 0~1)은 5대표 SSR 슬롯으로 확정.

---

## Ambiguous fragments (아키텍트 버킷 확정 대상 — FS 번호)

> 메타모델 아키텍트로 라우팅. ST D-넘버·PD-넘버와 혼동 피해 **FS-1, FS-2…**.

### FS-1. ★타일링(TILL_WH_GBN) = 공정#2(인쇄 배치) facet vs distinct #18(반복-배치 차원)? — directive 1순위 후보
- **증거:** `[live:SSR]` 5상품 전수 `TILL_WH_GBN` 라디오 = TIL_NON/TIL_HGH(세로)/TIL_WDT(가로). icon_txt "타일링없음/세로타일링/가로타일링". **BN/GS/TP/PR/ST/CL/AC/PD/PH 전 9 카테고리 어디에도 없던 슬롯.**
- **1차 가설:** 직물 풀프린팅의 "디자인 패턴 세로/가로 반복(tiling/repeat) 배치" = **인쇄 공정 파라미터(공정#2 facet)** 흡수 우세. 가격영향 `unknown`(반복=인쇄 면적/방식 변화 추정).
- **반론 검토 여지(아키텍트·★승격 기준 적용):** ① 전용 슬롯 라이브 실재 = **충족**(TILL_WH_GBN 명시 슬롯·5상품). ② 후니 KB 결함 = **미확정** — 후니 공정모델/옵션모델에 "인쇄 레이아웃 반복/타일" 슬롯이 있으면 흡수, 없으면 vessel-gap. ST 형상#17·CL 인쇄위치 승격(둘 다 충족)과 대조해 갭분석가가 후니 `t_proc_processes`/옵션 그릇에 tiling 흡수처 실재 여부 재실측 필요. → **distinct #18 판정 보류·아키텍트+갭분석가 결정**. (PD 봉제처럼 facet 부결 우세이나 "전 카테고리 부재 + 명시 슬롯"이라 판정불가→관측기반 검증 대상.)

### FS-2. 방향(PAPER_WH W/H) = 사이즈#13 facet vs 별 레이아웃 옵션?
- **증거:** `[live:SSR]` FSSQPST PAPER_WH=W(가로)/H(세로). 본체 직물 방향. 타일링(세로/가로)과 의미 겹침 가능.
- **1차 가설:** 사이즈#13의 방향 facet(가로/세로 치수 매핑) 흡수. 단 타일링 방향(TILL_WH_GBN)과 분리 슬롯 = 방향(본체)≠타일방향(패턴)인지 아키텍트 분별 필요. → 사이즈축 vs 레이아웃 옵션 경계.

### FS-3. 면직물 자재(면사 수 綿絲 count) = 자재#1 PTT 차원 확장 적정?
- **증거:** `[live:SSR]` PXFBW010/020/040/060(면10~60수). 종이 지종×평량이 아닌 **면사 굵기(수)** 단위.
- **1차 가설:** 자재#1 PTT(직물 계열)+평량(수) 확장(CL oz·PD 원단·GS 코스터 소재 동형). distinct 아님. **모호 지점:** 후니 자재모델(지종×평량 g/m²)이 직물(면사 수·신축성·짜임)의 *물성 차원*을 담는가 = round-22 굿즈 본체소재 부재 결함과 연결. → 갭분석가.

### FS-4. 별색(SID_FBR 6색×3농도) = CL Pantone과 같은 별색 도메인 vs 직물 전용 축소 별색?
- **증거:** `[live:SSR]` clr_info_SID_FBR 6색(BLK/WHT/RED/YEL/SKY/GRE)×DF001/002/003. CL Pantone 1124와 규모/구조 상이(6×3 제한 enum).
- **1차 가설:** 공정#2(별색 family·round-22 별색=공정). 단 색 enum이 **직물 날염 6 기본색 도메인**으로 ST/PR/CL 별색과 다른 모집단 → 기초코드(색) 도메인 거버넌스 관점 제기(별색 라이브러리가 매체별 다름). → 아키텍트(별색 색 도메인 분기).

### FS-5. 마감봉제(SEW_FBR)·제품가공(PDT_WRK 상품별 명칭)·FBR-접미 슬롯 = 공정#2 family 확장 적정?
- **증거:** `[live:SSR]` SEW_FBR(오버로크/말아박기/벨크로)·PDT_WRK(쿠션가공/에코백가공/파우치가공/스크런치가공)·LAB_FBR/LIN_PRT/POC_FBR/WRK_MTR.
- **1차 가설:** 공정#2 family 멤버(PD SEW_LTR·CL PDT_WRK 동형 슬롯)+부속물#8(라벨/끈/자석=자재 BUNDLE). distinct 아님. **모호 지점:** PDT_WRK가 상품마다 다른 icon_txt(쿠션가공≠에코백가공)인데 **DB상 동일 PCS_COD인가, 상품별 별 공정코드인가** = 후니 공정모델이 "동일 슬롯·상품별 공정 인스턴스"를 어떻게 관리하는지(공정 유형 enum vs 공정 인스턴스) 아키텍트 분별. PD-1과 합류.

### FS-6. 솜 충전(SUB_MTR_SUB_SELECT TN001)·끈·자석 = 완제 부자재 = 옵션 노출 vs 생산BOM?
- **증거:** `[live:SSR]` 쿠션 솜(TN001 사각쿠션솜·선택안함)·에코백 끈(LIN_PRT)·자석(WRK_MTR). 고객 선택 가능(옵션 노출)이나 완제 구조 부품.
- **1차 가설:** 자재(충전재/끈/자석)+부자재#8. **모호 지점(directive 핵심·PD-4 합류):** FS 완제 봉제 굿즈의 부자재(솜/끈/자석)는 PD(스툴 다리·논슬립=옵션 미노출 고정BOM)와 달리 **일부가 옵션으로 노출**(솜 선택안함 가능) → "완제 부자재가 옵션이냐 고정BOM이냐"가 상품별 분기. 후니 `t_prd_product_addons`(완제 부속)·옵션 노출 경계를 아키텍트가 "선택형 부자재 vs 고정 부자재" 그릇으로 분별. → 아키텍트+갭분석가(PD-4 vessel-gap 합류).

### FS-7. 가격모델 분기(real_price 포스터 vs real_calc_price 봉제완제) = 가격#11 라우팅 의미?
- **증거:** `[live:SSR]` FSSQPST=real_price·나머지4=real_calc_price. PD(tmpl_price)와 다른 면적/실계산.
- **1차 가설:** 가격#11이 매체/생산형태로 라우팅(현수막형=면적 real_price·봉제완제=공식 real_calc_price). distinct 아님(가격모델 다양성=도메인 현실). 단 real_price↔real_calc_price 차이 = infoCall 후행 `unobserved` → 가격 단계 보강(가산 규칙·면적 함수). → 가격검증/갭.

### FS-8. PCS 상세 enum·단가·infoCall 가격 결합 = unobserved
- **증거:** `[live:SSR]` PDT_WRK/SUB_MTR/SEW_FBR/타일링 상세 enum·단가는 infoCall AJAX 후행이라 SSR 미노출.
- **상태:** `unobserved` — 라이브 infoCall 캡처(node monitor)로 보강 가능(이번 세션 미수행·날조 금지). 메타모델 핵심 판정(distinct 0~1)은 SSR 슬롯/라디오/체크박스만으로 확정.
