# RP 옵션 원자 추출 — PD(스툴·슬리퍼·강아지계단 = 구조물/3D 조립 완제품) 카테고리

> 후니 RP-Meta 하네스 파이프라인 ① 산출물 (rpm-reverse-engineer).
> RedPrinting PD 카테고리(**3상품 전수** — 스툴 PDCHSTL·슬리퍼 PDWRSLP·강아지계단 PDSRPPY) 원자추출을 **base-data 관리 렌즈**로 역공학.
> 목적 = 메타모델 아키텍트가 "RedPrinting이 **구조물/입체 조립 완제품(스툴·슬리퍼·반려동물 계단)의 조립(assembly)·구조/하중(structure)·3D 폼·부품 구성**을 어떤 관리 축으로 분리·정규화하는가"를 추상화할 원재료.
> RedPrinting은 사용자 본인 설계 시스템(검증된 참조 모델 — 답습 아님).
> **★PD 카테고리의 본질 = 인쇄 그래픽이 입혀진 봉제/조립 완제 구조물.** 본체 구조물(다리·받침·바닥재·솜충전·지퍼·논슬립)은 **RP가 제조·조립하는 고정 사양**이며 **주문 옵션으로 노출되지 않는다** — 고객은 ① 출력원단(자재) ② 사이즈(형상/치수/단수) ③ 도수(단면 고정) ④ 봉제/제품가공/모양커팅/추가부자재(공정 PCS) 만 선택.
> **★directive 최대 관전: PD가 distinct 신규 축 #18을 만드는가(조립·구조·3D폼·부품) — 1차 판정 = 부결(facet).** 근거 §0·§5·Ambiguous PD-1/PD-2/PD-3. **17축 안정성 시험 결과 = 재포화(distinct 0·8번째 카테고리)** 1차 예측.

## 출처 표기 규칙 (BN/GS/TP/PR/ST/CL/AC 계승)
- `[live:SSR]` = 2026-06-17 라이브 읽기전용 GET `/ko/product/item/PD/{code}` (HTTP 200·370~400KB). **레거시 jQuery `productOrder` 위젯 페이지**(Vue 신상품 아님) — SSR `<select>`·PCS 체크박스가 실값 렌더. paper/sodu/size select·six_clr/SEW_LTR/THO_CUT/SUB_MTR/PDT_WRK 체크박스·icon_txt 라벨이 서버 렌더된 **실관측**. (옵션 상세 enum·가격은 infoCall AJAX 후행 — `[live:SSR]` 1차 옵션만 확보, 상세 그룹 enum 일부 `unobserved`.)
- `[live:SSR-marketing]` = 라이브 상세 페이지의 **마케팅 설명 카피**(detail 이미지 alt·TIP 텍스트). **옵션 아님** — 구조물 물리 특성을 서술. 옵션과 엄격 구분(날조 방지).
- `[live:catalog]` = `raw/widget_monitor/redprinting_catalog.json` 상품명·URL·category (2026-06-17 확인, PD 3상품 전부 category=PD·URL=/item/PD/).
- `[reuse:*]` = **PD는 재사용 캡처 0** — 라이브 보강이 1차(huni-widget에 PD 캡처 부재 확인).
- `[xref:AC/GS/ST]` = AC 입체/부속물(`categories/AC/reverse.md` §0.3·§0.4)·GS 완제SKU/variant(`categories/GS/reverse.md`)·ST 형상(#17) 대조 표기.
- `unobserved` = 미관측(날조 금지). 구조물 도메인 일반지식(조립 등)으로 옵션 날조 금지.

## base_data_tag 7버킷 (가설 — 아키텍트가 최종 확정)
자재(material) / 공정(process) / 옵션(option) / 템플릿(template/SKU) / 제약(constraint) / 기초코드(base-code/enum) / 카테고리(category)

---

## 0. PD 카테고리 핵심 발견 — 구조물 조립은 고정 사양(옵션 미노출), 선택축은 BN/GS/AC와 동형

PD 3상품은 BN·GS·TP·PR·ST·AC와 **동일한 레거시 `productOrder` 위젯 + 동일 PCS 슬롯 스키마**(paper/sodu/size + six_clr/SEW_LTR/THO_CUT/SUB_MTR/PDT_WRK)를 그대로 쓴다(`[live:SSR]` 3상품 selects·checkboxes 실측). `price_gbn="tmpl_price"`(3상품 공통·하드코딩) = 완제 템플릿 가격 모델.

### 0.1 ★구조물/조립/3D 폼 = 고정 제조 사양 (옵션 미노출 — directive 최대 관전 1차 판정)
PD의 "구조물성"(다리·받침·바닥재·솜·지퍼·논슬립·봉제 구조)은 전부 **마케팅 설명 카피**에만 등장하고 **주문 옵션 슬롯에는 없다**(`[live:SSR-marketing]` 실측):

| 구조 요소 | 상품 | 출처 | 옵션 슬롯? |
|----------|------|------|-----------|
| "튼튼한 원목다리(소나무 원목)" | PDCHSTL 스툴 | `[live:SSR-marketing]` detail_cushionStool alt | **아니오**(고정 사양) |
| "발받침대로 사용", "미끄럼 방지 패드 다리 밑부분" | PDCHSTL | `[live:SSR-marketing]` | **아니오** |
| "커버에 지퍼처리·솜과 커버 분리 세탁" | PDSRPPY 강아지계단 | `[live:SSR-marketing]` | **아니오** |
| "바닥면 네이비 논슬립(실리콘 미끄럼방지 원단)" | PDSRPPY | `[live:SSR-marketing]` | **아니오** |
| "발판과 옆면 모두 이미지 적용" | PDSRPPY | `[live:SSR-marketing]` | **아니오**(디자인 영역 설명) |

→ **고객은 스툴의 다리 종류·받침 구조·솜 충전량·지퍼 유무를 선택하지 않는다.** RP가 입체 구조물을 **완성 제조**하고, 고객은 그 위에 입힐 **그래픽(인쇄)·원단(자재)·외형 사이즈·봉제/가공(공정)**만 고른다. 즉 "조립/구조/3D폼"은 **base-data 관리 대상이 아니라 상품 정체(카테고리#7)에 내재된 제조 레시피**.
**★directive 최대 관전 1차 판정: 조립·구조·3D폼·부품 = distinct #18 아님.** RedPrinting은 입체 구조를 *옵션 축으로 인코딩하지 않고 완제품 정체에 흡수* → **GS 완제SKU(완제품)·AC 코롯토 입체블록(자재 두께 facet)과 동형**. 관리축은 여전히 자재/사이즈/도수/공정/옵션. (PD-1 등재)

### 0.2 출력원단(자재) = `paper` 슬롯 (BN substrate·AC 소재 동형)
`paper` select가 본체 출력원단(자재) 1종 고정값(`[live:SSR]` 실측):

| 상품 | paper(자재) 값 | base_data_tag |
|------|---------------|---------------|
| PDCHSTL 스툴 | **면10수화이트** (면직물) | 자재(원단 PTT) |
| PDWRSLP 슬리퍼 | **슬리퍼원단** | 자재(원단 PTT) |
| PDSRPPY 강아지계단 | **PU(폴리우레탄)-코끼리원단** | 자재(원단 PTT) |

★PD 자재 = **직물/원단**(종이 아님) — 면10수·슬리퍼원단·PU폴리우레탄. AC 아크릴 소재·CL 의류 원단(fabric PTT)과 동형(`[xref:AC/CL]` 자재 PTT 차원). `paper_sub_select`(하위소재)는 3상품 전부 빈 select(상위 1종이라 하위 분기 없음·`unobserved` 상세). base_data_tag = 자재(원단). (PD-2 일부)

### 0.3 사이즈 = 형상/치수/단수가 한 슬롯에 혼재 (3상품 3패턴 — ST 형상#17 대조)
`size` select가 상품마다 **이질적 사이즈 의미**를 담음(`[live:SSR]` 실측):

| 상품 | size 옵션 | 사이즈 의미 | base_data_tag |
|------|----------|------------|---------------|
| PDCHSTL 스툴 | 미니사각(292×292)·미니원형(305×305)·원형(305×305)·긴사각(580×290) | **형상+치수 융합**(사각/원형 형상 × 치수 프리셋) | 사이즈(형상=칼틀 1:1) |
| PDWRSLP 슬리퍼 | 230·240·250·260·270·280mm | **신발 치수**(발 사이즈) | 사이즈(치수 프리셋) |
| PDSRPPY 강아지계단 | 2단(495×320)·3단(717×382) | **단수(층수)+외형치수 융합** | 사이즈(단수=구조 프리셋) |

★주목: PDCHSTL "미니사각/미니원형/원형"은 ST 형상(#17)처럼 보이나 **형상↔사이즈 1:1**(원형=305×305 치수 프리셋 1개와 동치) → **ST 1:多(원형↔CL001~100 칼틀 span)와 다름** → 사이즈축이 형상을 흡수(ST 형상축 분리 전제 미충족). PDSRPPY "2단/3단"은 **계단 구조의 층수**지만 옵션이 아니라 *사이즈 프리셋*으로 인코딩(2단=495×320 1:1) → 구조(단수)가 사이즈에 흡수됨 = **구조=distinct 아님의 강증거**. base_data_tag = 사이즈(형상/단수=프리셋). (PD-2 일부·PD-3 등재)

### 0.4 도수(sodu) = 단면 고정 (단순 facet)
`sodu` select가 3상품 전부 **단면** 1값 고정(`[live:SSR]` 실측). 양면 없음(완제 구조물은 외면 1면 인쇄). PDCHSTL `six_clr`(별색) 체크박스 존재(`[live:SSR]`) — 단면+별색 옵션. base_data_tag = 도수(기초코드, 단면 고정) + (six_clr) 공정(별색).

### 0.5 ★공정 PCS 그룹 = 봉제/제품가공/모양커팅/추가부자재 (구조물 특유 공정이 PCS 슬롯에 흡수)
체크박스 PCS 그룹이 BN/AC/ST 동형 슬롯에 **구조물 제조 공정**을 담음(`[live:SSR]` icon_txt 라벨 실측·라벨은 체크박스 직후 출현):

| 상품 | PCS 슬롯 | icon_txt 라벨 | 공정 의미 | base_data_tag |
|------|---------|--------------|----------|---------------|
| PDCHSTL 스툴 | SEW_LTR_CHK | **레더재봉** | 가죽/원단 재봉(봉제 조립) | 공정(봉제) |
| PDCHSTL | THO_CUT_CHK | **모양커팅** | 외형 모양 컷팅 | 공정(컷팅·사이즈 cascade) |
| PDCHSTL | SUB_MTR_CHK | **추가부자재** | 추가 부자재 BUNDLE | 부자재#8 + 공정 |
| PDWRSLP 슬리퍼 | SUB_MTR sub-radio (SLB01~06/SLW01~06) | **검정/흰색 밑창** | 밑창(sole) 색×사이즈 12-variant(MTRL_COD SBSLP230~280/SWSLP230~280) | 자재(본체색=밑창)·SUB_MTR 부자재#8 |
| PDWRSLP | THO_CUT_CHK | **모양커팅** | 외형 컷팅 | 공정(컷팅) |
| PDWRSLP | PDT_WRK_CHK | **제품가공** | 제품 가공(조립 마감) | 공정(제품가공) |
| PDWRSLP | SUB_MTR_CHK | **추가부자재**(밑창색 매트릭스 담음) | 추가 부자재 — SLB*/SLW* 밑창색 sub-radio 인코딩 | 부자재#8 + 자재(본체색) |
| PDSRPPY 강아지계단 | SEW_LTR_CHK | **레더재봉** | 원단 재봉(봉제 조립) | 공정(봉제) |
| PDSRPPY | THO_CUT_CHK | **모양커팅** | 외형 컷팅 | 공정(컷팅) |
| PDSRPPY | SUB_MTR_CHK | **추가부자재** | 추가 부자재 | 부자재#8 + 공정 |

★핵심: **`SEW_LTR`(레더재봉)·`PDT_WRK`(제품가공)** = PD 구조물의 *봉제/조립 공정*이지만 **새 슬롯이 아니라 기존 PCS 그룹 슬롯에 인코딩**(AC `WRK_MTR` 부자재작업·ST `PDT_WRK`와 동형 슬롯). 즉 RedPrinting은 "봉제 조립" 같은 구조물 공정도 **공정#2의 멤버(family)로 흡수** — 별 "조립 축" 없음. `모양커팅`(THO_CUT)은 ST/GS 동형(공정#2 + 사이즈 cascade). `추가부자재`(SUB_MTR)는 AC/ST 부자재 BUNDLE 동형(`[xref:AC/ST]`). base_data_tag = 공정(봉제/가공/컷팅) + 부자재#8. (PD-1·PD-4 등재)

### 0.6 수량 모델 = number1(부수)·number2(건수) 2슬롯 (전 카테고리 동형)
`number1_sel`(수량 직접입력·1~10) + `number2_sel`(건수직접입력·1~11) = 인쇄수량(PRN_CNT) + 디자인건수(ORD_CNT) 2슬롯(`[live:SSR]` 실측·BN/GS/TP/PR 동형). base_data_tag = 수량모델#10(2슬롯). 가격 결합 `unobserved`(infoCall 후행).

---

## 1. PDCHSTL — 스툴 (PD·완제 봉제 스툴) [live:SSR]

```
product: PDCHSTL 스툴 (PD)
source: [live:SSR] /ko/product/item/PD/PDCHSTL (HTTP 200, 392KB, 2026-06-17) · [live:catalog]
price_gbn: tmpl_price (완제 템플릿 가격)
axes:
  - axis: 출력원단(paper)
    choices: [면10수화이트]
    cascade: none(1종 고정)
    price_flag: unknown(infoCall 후행)
    base_data_tag: 자재(원단 PTT)
    note: 면직물 본체. paper_sub_select 빈값(하위분기 없음).
  - axis: 도수(sodu)
    choices: [단면]
    cascade: none
    price_flag: unknown
    base_data_tag: 기초코드(도수, 단면 고정)
    note: [live:SSR]
  - axis: 별색(six_clr)
    choices: [Y(별색 적용 체크)]
    cascade: 별색 인쇄 추가
    price_flag: unknown(별색 가산 추정)
    base_data_tag: 공정(별색)
    note: [live:SSR] checkbox six_clr=Y. round-22 경계: 별색=공정.
  - axis: 사이즈(size)
    choices: [미니사각(292×292), 미니원형(305×305), 원형(305×305), 긴사각(580×290)]
    cascade: 사이즈→모양커팅 칼틀 연동 추정(unobserved)
    price_flag: unknown
    base_data_tag: 사이즈(형상=칼틀 1:1 프리셋)
    note: [live:SSR] 형상(사각/원형)↔치수 1:1 융합. ST 형상#17과 달리 1:多 아님→사이즈 흡수.
  - axis: 레더재봉(SEW_LTR_CHK)
    choices: [Y]
    cascade: 봉제 공정 추가
    price_flag: unknown
    base_data_tag: 공정(봉제 조립)
    note: [live:SSR] icon_txt="레더재봉". 구조물 봉제=공정#2 멤버(별 조립축 아님).
  - axis: 모양커팅(THO_CUT_CHK)
    choices: [Y] (THO_CUT_SUB_SELECT 상세 enum = unobserved·infoCall 후행)
    cascade: 사이즈/형상↔칼틀 연동
    price_flag: unknown
    base_data_tag: 공정(컷팅) + 사이즈 cascade
    note: [live:SSR] ST/GS THO_CUT 동형.
  - axis: 추가부자재(SUB_MTR_CHK)
    choices: [Y] (부자재 enum = unobserved)
    cascade: 부자재 추가
    price_flag: unknown
    base_data_tag: 부자재#8 + 공정(부착)
    note: [live:SSR] AC/ST SUB_MTR 부자재 BUNDLE 동형.
  - axis: 수량(number1_sel)
    choices: [수량 직접입력, 1..10]
    base_data_tag: 옵션/수량모델#10(PRN_CNT)
    note: [live:SSR]
  - axis: 건수(number2_sel)
    choices: [건수직접입력, 1..11]
    base_data_tag: 옵션/수량모델#10(ORD_CNT 디자인건수)
    note: [live:SSR]
non-axes (구조물=고정사양, 옵션 아님):
  - "튼튼한 원목다리(소나무 원목)", "발받침대로 사용", "미끄럼 방지 패드" = [live:SSR-marketing] 설명 카피. 선택 불가.
```

---

## 2. PDWRSLP — 슬리퍼 (PD·완제 봉제 슬리퍼) [live:SSR]

```
product: PDWRSLP 슬리퍼 (PD)
source: [live:SSR] /ko/product/item/PD/PDWRSLP (HTTP 200, 399KB, 2026-06-17) · [live:catalog]
price_gbn: tmpl_price
axes:
  - axis: 출력원단(paper)
    choices: [슬리퍼원단]
    base_data_tag: 자재(원단 PTT)
    note: [live:SSR] 1종 고정.
  - axis: 도수(sodu)
    choices: [단면]
    base_data_tag: 기초코드(도수)
  - axis: 별색(six_clr)
    choices: [Y]
    cascade: 별색(6색) 인쇄 추가
    price_flag: unknown
    base_data_tag: 공정(별색)
    note: [live:SSR] icon_txt="6색인쇄"(검정/흰색 값 미부착). round-22 경계=별색=공정. 3상품 공통 spot-color 슬롯(스툴/계단과 동일). ★D-PD-1 정정: 종전 밑창색을 six_clr에 오귀속했으나 별색이 맞음.
  - axis: 밑창색×사이즈(SUB_MTR sub-radio SLB*/SLW*)
    choices: [검정 230~280mm(SLB01~06·MTRL_COD SBSLP230~280), 흰색 230~280mm(SLW01~06·SWSLP230~280)]
    cascade: 밑창색×발사이즈 12-variant 매트릭스(추가부자재 sub-radio로 인코딩) · "검정 밑창 1켤레씩 주문 가능"(TIP·최소수량 분기)
    price_flag: unknown
    base_data_tag: 자재(본체색=밑창 sole) · SUB_MTR 부자재#8
    note: [live:SSR] ★D-PD-1 정정 — 밑창색 검정/흰색은 six_clr이 아니라 SUB_MTR(추가부자재) sub-radio에 인코딩(SLB01~06=검정·SLW01~06=흰색·MTRL_COD SBSLP/SWSLP230~280). 색×사이즈 12셀 매트릭스. GS 본체색·AC 본체색·CL size×color MTRL_COD 매트릭스 동형(자재 합성 차원). 검정=1켤레 가능 제약 동반.
  - axis: 사이즈(size)
    choices: [230mm, 240mm, 250mm, 260mm, 270mm, 280mm]
    cascade: none(치수만)
    price_flag: unknown
    base_data_tag: 사이즈(신발 치수 프리셋)
    note: [live:SSR] 발 사이즈. 치수 6프리셋(형상 없음).
  - axis: 모양커팅(THO_CUT_CHK)
    choices: [Y]
    base_data_tag: 공정(컷팅)
    note: [live:SSR] (THO_CUT_SUB_SELECT "모양컷팅 을 선택해주세요" 플레이스홀더만 SSR·상세 enum unobserved.)
  - axis: 제품가공(PDT_WRK_CHK)
    choices: [Y] (가공 enum = unobserved)
    cascade: 제품 가공(조립 마감) 추가
    price_flag: unknown
    base_data_tag: 공정(제품가공)
    note: [live:SSR] icon_txt="제품가공". PD에서만 등장한 PCS 슬롯 라벨(스툴/계단은 SEW_LTR). 슬리퍼 조립 마감 공정.
  - axis: 추가부자재(SUB_MTR_CHK)
    choices: [Y]
    base_data_tag: 부자재#8 + 공정
    note: [live:SSR]
  - axis: 수량(number1_sel) / 건수(number2_sel)
    choices: [수량/건수 직접입력, 1..10 / 1..11]
    base_data_tag: 옵션/수량모델#10
    note: [live:SSR] "켤레" 단위(슬리퍼). 1켤레 주문 가능(검정).
non-axes (구조물=고정사양):
  - "미끄럼 주의" = [live:SSR-marketing] 카피.
```

---

## 3. PDSRPPY — 강아지 계단 (PD·완제 봉제 반려동물 계단) [live:SSR]

```
product: PDSRPPY 강아지 계단 (PD)
source: [live:SSR] /ko/product/item/PD/PDSRPPY (HTTP 200, 369KB, 2026-06-17) · [live:catalog]
price_gbn: tmpl_price
axes:
  - axis: 출력원단(paper)
    choices: [PU(폴리우레탄)-코끼리원단]
    base_data_tag: 자재(원단 PTT)
    note: [live:SSR] PU 폴리우레탄. "아이보리 색 원단에 인쇄" 안내(흰색 인쇄물과 상이) = [live:SSR-marketing].
  - axis: 도수(sodu)
    choices: [단면]
    base_data_tag: 기초코드(도수)
  - axis: 별색(six_clr)
    choices: [Y]
    base_data_tag: 공정(별색)
    note: [live:SSR]
  - axis: 사이즈(size)
    choices: [2단(495×320), 3단(717×382)]
    cascade: 단수→외형치수 1:1
    price_flag: unknown
    base_data_tag: 사이즈(단수=구조 프리셋)
    note: [live:SSR] icon_txt "2단형 강아지계단"·"3단형 강아지계단". ★계단 단수(층수)=구조 요소지만 사이즈 프리셋으로 인코딩(2단=495×320 1:1)→구조가 사이즈에 흡수=구조 distinct 아님 강증거.
  - axis: 레더재봉(SEW_LTR_CHK)
    choices: [Y]
    base_data_tag: 공정(봉제 조립)
    note: [live:SSR]
  - axis: 모양커팅(THO_CUT_CHK)
    choices: [Y]
    base_data_tag: 공정(컷팅)
    note: [live:SSR]
  - axis: 추가부자재(SUB_MTR_CHK)
    choices: [Y]
    base_data_tag: 부자재#8 + 공정
    note: [live:SSR]
  - axis: 수량(number1_sel) / 건수(number2_sel)
    choices: [수량/건수 직접입력, 1..10 / 1..11]
    base_data_tag: 옵션/수량모델#10
non-axes (구조물=고정사양):
  - "지퍼처리·솜과 커버 분리 세탁", "바닥면 네이비 논슬립(실리콘 미끄럼방지 원단)", "발판과 옆면 모두 이미지 적용" = [live:SSR-marketing] 카피. 선택 불가(RP 제조 고정 사양).
```

---

## 4. 횡단 태깅 요약 (PD 3상품)

| 축 | 슬롯/필드 | base_data_tag | 메타모델 매핑 | 기존 축 |
|----|----------|---------------|--------------|---------|
| 출력원단 | paper | 자재(원단 PTT) | 자재#1 (직물/PU·종이 아님) | #1 (AC 아크릴·CL 원단 동형) |
| 도수 | sodu(단면 고정) | 기초코드(도수) | 도수#6 | 기존 |
| 별색 | six_clr | 공정(별색) | 공정#2(별색 family) | 기존 (round-22 경계) |
| 본체/밑창색 | SUB_MTR sub-radio SLB*/SLW*(PDWRSLP·★six_clr 아님) | 자재(본체색 합성) + SUB_MTR 부자재#8 | 자재#1 surface variant(색×사이즈 12-variant 매트릭스) | #1 (GS/AC 본체색·CL size×color MTRL_COD 매트릭스) |
| 사이즈/형상/단수 | size | 사이즈(형상=칼틀 1:1·단수=프리셋) | 사이즈#13(형상 1:1 흡수) | #13 (ST 형상#17 미충족) |
| 봉제/제품가공 | SEW_LTR/PDT_WRK | 공정(봉제·조립 마감) | 공정#2(family 멤버) | 기존 (AC WRK_MTR·ST PDT_WRK 동형) |
| 모양커팅 | THO_CUT | 공정(컷팅)+사이즈 cascade | 공정#2 + #13 | 기존 (ST/GS THO_CUT) |
| 추가부자재 | SUB_MTR | 부자재#8 + 공정 | 부속물#8 BUNDLE | 기존 (AC/ST SUB_MTR) |
| 수량·건수 | number1/number2 | 옵션/수량모델 | 수량모델#10(2슬롯) | 기존 |
| 가격모델 | price_gbn=tmpl_price | 가격#11(완제 템플릿) | 가격#11 라우팅 | 기존 (GS tmpl 동형) |
| **구조/조립/3D폼** | **(슬롯 없음)** | **카테고리#7 내재 제조레시피** | **옵션 미노출 — 완제품 정체** | **distinct 아님** |

**★1차 판정(directive 최대 관전): PD distinct 신축 = 0종. 조립·구조·3D폼·부품 = #18 부결.**
- **조립/봉제** = 공정#2(SEW_LTR 레더재봉·PDT_WRK 제품가공이 *기존 PCS 슬롯*에 인코딩·새 슬롯 없음·AC WRK_MTR 동형).
- **구조(다리/받침/바닥재/솜/지퍼)** = **옵션 아님** — RP 고정 제조 사양(카테고리#7 정체에 내재). base-data 관리 대상 자체가 아님.
- **3D 폼(입체 완제품)** = GS 완제SKU(tmpl_price)·AC 코롯토 입체블록 동형 — 완제품성은 가격#11(tmpl)·카테고리#7가 담음(생산형태#15 "완제품"). **AC §0.3 "입체/스탠드 = distinct #19 아님" 판정과 일관**.
- **단수(2단/3단)** = 구조 요소지만 **사이즈#13 프리셋으로 흡수**(1:1)→구조 distinct 부결의 결정적 증거.
- **부품 구성** = 추가부자재(SUB_MTR#8)·밑창색(자재#1) — 기존 부속물/자재 축.

**17축 안정성 = 재포화(distinct 0·8번째 카테고리).** PD는 PR(0)·CL(0)·AC(0) 패턴 반복 — 가장 이질적인 "봉제 구조물 완제품"조차 17축으로 무손실 흡수. 단 **두 가지 격상 명시**(아래 PD-1·PD-4): ① 공정#2가 "봉제(sewing)/제품가공(assembly-finish)" family 멤버를 추가로 수용함을 PD가 입증 ② 완제 구조물의 *내재 제조레시피*(옵션 미노출 구조)는 카테고리#7/생산형태#15가 담는다는 경계 재확인.

---

## 5. 샘플 충분성·모집단 정의

**catalog category=PD 모집단 = 3상품 전수**: PDCHSTL(스툴)·PDWRSLP(슬리퍼)·PDSRPPY(강아지계단) — `[live:catalog]` 2026-06-17 확인. **3상품 전수 역공학 완료**(census에 가까우나 구조 다양성 렌즈: 봉제스툴/신발류/반려동물 구조물 3이질형). 추가 표본 없음(모집단 소진).

**구조 다양성 커버리지**: ① 형상융합 사이즈(스툴 사각/원형) ② 치수 사이즈(슬리퍼 발 mm) ③ 단수/구조 사이즈(계단 2/3단) — 사이즈 슬롯의 3 이질 의미 전부 관측. ④ 봉제(SEW_LTR)·제품가공(PDT_WRK) 2 조립공정 슬롯 관측. ⑤ 본체색(밑창) variant 관측. 메타모델 검증 시 갭 발견되면 재진입.

---

## Ambiguous fragments (아키텍트 버킷 확정 대상 — PD 번호)

> ST discovered-axes D-넘버와 혼동 피해 **PD-1, PD-2…**로 부여.

### PD-1. 구조물 봉제/제품가공(SEW_LTR·PDT_WRK) — 공정#2 멤버 vs 조립 distinct #18?
- **증거:** `[live:SSR]` PDCHSTL/PDSRPPY `SEW_LTR_CHK`(레더재봉), PDWRSLP `PDT_WRK_CHK`(제품가공). 봉제/조립 마감이 **기존 PCS 슬롯**에 인코딩.
- **1차 가설:** 공정#2 family 멤버(새 슬롯 없음·AC WRK_MTR 부자재작업·ST PDT_WRK와 동형 슬롯·인쇄도메인 봉제=후가공 공정). **조립 distinct #18 부결 예상.**
- **반론 검토 여지(아키텍트):** "레더재봉/제품가공"은 인쇄 후가공(코팅/박)과 질적으로 다른 *조립/봉제 생산공정*(섬유/구조물 제조). 후니 공정모델(`t_proc_processes`)이 인쇄 후가공 위주라면 봉제/조립 공정을 담을 *공정 카테고리(공정유형)*가 필요할 수 있음. **단 이는 새 축이 아니라 공정#2의 공정유형 enum 확장**(facet)일 가능성 우세. → 아키텍트가 공정#2 family 확장으로 비준 또는 "조립공정 유형" 하위분류 권고.

### PD-2. PD 자재 = 직물/PU 원단(종이 아님) — 자재#1 PTT 차원 확장?
- **증거:** `[live:SSR]` 면10수화이트·슬리퍼원단·PU폴리우레탄. 종이 substrate가 아닌 **직물/합성수지 원단**.
- **1차 가설:** 자재#1 PTT(소재계열) 차원의 값 확장(AC 아크릴·CL 의류원단과 동형 — 비종이 자재는 이미 다 카테고리에서 관측). distinct 아님.
- **모호 지점:** 후니 자재모델(지종×평량)이 직물(면10수=면사 굵기·평량 대신 "수"단위)·PU 같은 비종이 원단의 *물성 차원*(원단 종류·두께·신축성)을 담는가 = 갭 단계 재확인 필요(round-22 굿즈 본체소재 부재 결함과 연결). → 갭분석가.

### PD-3. 계단 단수(2단/3단)·스툴 형상 = 사이즈#13 흡수 vs 구조/형상 distinct?
- **증거:** `[live:SSR]` PDSRPPY size=2단/3단(층수+치수), PDCHSTL size=미니사각/미니원형/원형/긴사각(형상+치수).
- **1차 가설:** 사이즈#13 프리셋 흡수(단수=2단 1:1 치수, 형상=원형 1:1 치수 — ST 형상#17의 1:多 아님). **구조/형상 distinct 부결.**
- **모호 지점:** "단수"는 구조적 의미(층수=하중/구조)를 가지나 RP는 사이즈 프리셋으로만 노출 → 메타모델은 사이즈로 충분하나, *생산 BOM 관점*(2단 vs 3단 자재량·공정량 차이)에서 사이즈가 생산정보를 게이팅하는지 `unobserved`(infoCall 가격 후행). → 갭/가격 단계.

### PD-4. 완제 구조물의 "옵션 미노출 제조레시피" — 어느 버킷이 담는가?
- **증거:** `[live:SSR-marketing]` 다리·받침·바닥재·솜·지퍼·논슬립 = 전부 마케팅 카피(옵션 슬롯 없음). RP가 고정 제조.
- **1차 가설:** 카테고리#7(상품 정체)·생산형태#15(완제품)·가격#11(tmpl_price 완제 단가)가 분담. base-data 관리 대상 아님(BOM은 생산 측 고정 레시피).
- **모호 지점(directive 핵심):** 후니가 이런 완제 구조물(스툴/슬리퍼/반려동물용품)을 취급하려면 *고정 제조 BOM*(다리 종류·솜 충전·논슬립 원단)을 **어딘가 관리해야** — 옵션으로는 안 띄우되 생산정보로는 보유. 이것이 후니 `t_prd_product_addons`(완제 부속)·생산BOM 그릇에 들어가는가, 아니면 별 "완제 구조물 BOM" 그릇이 필요한가 = **vessel-gap 후보**. AC 받침 부속물(#8)·GS 완제SKU와 합류해 아키텍트/갭분석가가 "완제품 고정BOM 관리 그릇" 판정. → **아키텍트 주목(PD가 던지는 진짜 질문은 새 옵션축이 아니라 "완제품 내재BOM을 옵션과 분리해 어디에 두는가").**

### PD-5. 모양커팅 상세 enum·추가부자재 enum·가격 결합 = unobserved
- **증거:** `[live:SSR]` THO_CUT_SUB_SELECT 플레이스홀더만("모양컷팅 을 선택해주세요")·SUB_MTR 상세 enum·price_gbn=tmpl_price 단가 = infoCall AJAX 후행이라 SSR 미노출.
- **상태:** `unobserved` — 라이브 infoCall 캡처(node monitor) 또는 widget 재현으로 보강 가능(이번 세션 미수행·날조 금지). 메타모델 핵심 판정(distinct 0)은 SSR 슬롯만으로 확정되므로 보강은 갭/가격 단계 선택.
