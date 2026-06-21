# 경쟁사 캘린더(달력) 가격계산 모델 분석 — 종단 보강 (9번째 종단)

> `hpe-benchmark-analyst` 캘린더 종단. **§18 directive의 "경쟁사 가격계산 방식 흡수"를 캘린더 상품군 맥락으로 좁힌다.**
> 기존 분석(`competitor-pricing-models.md` §7 제본물·§8 굿즈·`set-pricing-patterns.md` P-6)은 **보존**(재유도 0)·본 파일은 캘린더 전용 보강.
> **흡수 vs 답습[HARD]**: 메커니즘·표현력만 흡수 · naming/codes(offset2023_price/book2025/vTmpl/tmpl_price/tiered_price/CLD_STD/RIN_DFT/STA_CLD/INN_PAGE/PRN_CNT) **후니 유입 금지** · 권위 엑셀(상품마스터260610·가격표260527) **절대권위·덮어쓰기 금지** · 경쟁사=갭헌팅 보강.
> **경쟁사 주장=가설**(권위 검증 전 채택 금지). 라이브 읽기전용·DB 미적재.

## 출처 (확신도 표기)

- `[red:cal-cap]` = `_workspace/huni-widget/05_qa/captures/s6_cal_{HLCLSTD,HLCLWAL,TPCLECO,TPCLWLB,GSCLMGN}.json` (RedPrinting 캘린더 5 SKU 라이브 위젯 캡처·2026-06-02·읽기전용·get_ajax_price_vTmpl reqBody/respBody 실측·삼각대/링제본 PCS_AMT 분해 포함). **확신도: 높음**(가격 분해·result_log 실측).
- `[red:cap-src]` = `raw/widget_monitor/local/s6-calendar-capture.cjs` (캡처 스크립트·읽기전용·주문/결제 0).
- `[red:TP]` = `_workspace/huni-rpmeta/categories/TP/reverse.md` (캘린더/북/티켓/떡메 23상품 메타모델·이중수량·INN_PAGE). **확신도: 중**(메타모델·재유도 0).
- `[wow:booklet]` = `raw/widget_monitor/wow_capture/fresh_booklet_capture.json` (와우 제본물 `jobqty0`/`jobcost0`·`paperno` 다단). **확신도: 중**(직접 캘린더 캡처 부재·제본물 인접 추론).
- `[huni:cal]` = `_workspace/huni-dbmap/06_extract/calendar-l1.csv` (상품마스터 캘린더 시트·6 distinct 상품·캘린더가공·추가가격). **권위·확신도: 높음**.
- `[huni:bind]` = `_workspace/huni-dbmap/06_extract/price-binding-l1.csv` B03 캘린더 제본비(제본/수량 매트릭스·삼각대 포함). **권위·확신도: 높음**.
- `[huni:prior]` = `02_benchmark/competitor-pricing-models.md` §7/§8 · `absorption-candidates-booklet.md` (재사용·중복 재유도 0).

---

## 0. 캘린더 가격계산 한눈 — 4 경쟁사 엔진 × 후니 권위 대조

★**핵심 발견(라이브 실측)**: RedPrinting은 **하나의 "캘린더"가 아니라 SKU별로 완전히 다른 가격엔진 4종**으로 분기한다. 후니 권위는 이를 **하나의 디지털인쇄 SUM 공식 + 캘린더가공 inline 고정가 add-on**으로 통합한다 — 후니가 더 단순·통합적.

| RedPrinting SKU | 상품명 | `item_gbn` | `price_gbn`(엔진) | 계산방식 | 후니 대응 권위 |
|-----------------|--------|-----------|-------------------|----------|----------------|
| **HLCLSTD** | [옵셋] 탁상용 캘린더 | offset2023_item | **`offset2023_price`** | **PCS 구성요소 합산**(인쇄+제본+삼각대+재단 각각 PRICE→Σ) | 디지털 SUM + 캘린더가공 고정가 |
| **HLCLWAL** | [옵셋] 벽걸이 캘린더 | offset2023_item | **`offset2023_price`** | PCS 합산(인쇄+노치컷링제본+타공+재단) | 동상 |
| **TPCLWLB** | 큰 달력(효도) | vDigital_item | **`vTmpl_price`** | **개당단가 × 인쇄수량 × 주문건수**(템플릿 단가) | 디지털 SUM(개당단가형) |
| **TPCLECO** | 에코 캘린더 | vDigital_item | **`tiered_price`** | 수량구간 단가표 룩업(price_table_yn:Y) | 디지털 SUM + 수량구간할인 |
| **GSCLMGN** | 자석캘린더 | edicus_item | **`tmpl_price`** | 완제 SKU 템플릿 개당단가(edicus 에디터) | 굿즈 GP-1 고정가형 |

→ **4 엔진 = 기존 종단에서 전부 관측된 패턴의 캘린더 인스턴스**(새 계산방식 0):
- `offset2023_price` PCS 합산 ↔ 후니 **합산형 디지털 SUM**(§7 제본·디지털 종단)
- `vTmpl_price` 개당단가×수량×건수 ↔ 후니 **개당단가형 PRODUCT/FORMULA**(§8 굿즈 GP-1)
- `tiered_price` 수량구간 ↔ 후니 **수량구간할인 t_dsc_***(굿즈/문구 종단)
- `tmpl_price`(edicus) ↔ 후니 **고정가형 완제 SKU**(굿즈 GP-1·디자인캘린더 inline)

★**rpmeta 정합**: TP 종단(`[red:TP]`)이 캘린더=제본물(TP)에서 distinct 가격축 0으로 종결됐고, 인쇄방식(옵셋 vs 디지털)은 #12 생산레시피축(엔진 라우팅 enum)이지 새 가격축 아님 — **캘린더도 동일**. price_gbn 4분기는 **공식 라우팅(frm_cd 바인딩)** 으로 흡수, 새 t_prc_* 축 신설 불요.

---

## 1. RedPrinting 옵셋 캘린더 = `offset2023_price` PCS 구성요소 합산 ★ `[red:cal-cap]`

### 1.1 가격 분해 — 실측 (HLCLSTD 탁상용·세로형·500부·트윈링·삼각대블랙)

라이브 capture `priceCalls[1]`(reqBody PRN_CNT=500·ORD_CNT=1) result_log 실측:

| PCS_CD | PCS_NM | 의미 | PCS_AMT(원) | PRT_AMT_YN |
|--------|--------|------|------------|-----------|
| PRT_DFT | 인쇄 | 본판 인쇄비 | **578,900** | Y(인쇄비) |
| RIN_DFT(BPTOP) | 트윈링제본(상철) | 제본비 | **316,800** | N |
| CLD_STD(BK001) | 삼각대(블랙) | 거치대 가공 | **297,000** | N |
| CUT_DFT | 재단 | 재단 | 0 | N |
| | | **`result_sum.PRICE`** | **1,192,700** | (= PRI 578,900 + ETC 613,800) |

→ **계산식 = Σ 구성요소 PRICE**. `result_sum`이 `PCS_PRI_PRICE`(인쇄비)와 `PCS_ETC_PRICE`(제본+삼각대+재단)를 분리 합산. **각 PCS가 자기 차원으로 단가 산정 후 합산** = **합산형(원자합산)**.

### 1.2 ★핵심 관측 — 삼각대/제본이 **사이즈에 종속**(개당 고정가 아님)

같은 HLCLSTD를 사이즈만 바꿔(세로형 94×184 vs 세로형의 다른 캡처) 재호출:

| 사이즈 | 인쇄(PRT) | 트윈링제본(RIN) | 삼각대(CLD) | 합계 |
|--------|-----------|----------------|-------------|------|
| 세로형(214×154 작업) | 578,900 | 316,800 | 297,000 | 1,192,700 |
| 세로형(94×184 narrow) | 362,700 | 217,800 | 198,000 | 778,500 |

→ **삼각대·제본 가격이 사이즈에 비례**(297,000 → 198,000). 즉 RedPrinting은 **거치대/제본을 "사이즈별 단가표"로 룩업**(고정 개당가 아님). 그러나 **수량(PRN_CNT=500 고정)으로 나누면 부당가**가 나옴 — 500부 기준 삼각대 297,000/500 = 594원/부.

### 1.3 HLCLWAL 벽걸이 = 노치컷링제본 + 타공 합산 `[red:cal-cap]`

| PCS_CD | PCS_NM | PCS_AMT(예·price#1) |
|--------|--------|---------------------|
| PRT_DFT | 인쇄 | 977,600 |
| RIN_CUT | 노치컷링제본 | 368,700 |
| HOL_DFT | 타공 | 6,300 |
| CUT_DFT | 재단 | 0 |
| | **PRICE** | **1,352,600** |

→ **벽걸이는 삼각대 대신 "타공(HOL_DFT)" + "노치컷링제본"** 합산. **제본/가공 종류가 캘린더 형태(탁상=삼각대·벽걸이=타공+링)에 따라 다른 PCS 집합** — 그러나 전부 **Σ 구성요소** 동일 계산식.

---

## 2. RedPrinting 디지털 캘린더 3종 — vTmpl / tiered / tmpl `[red:cal-cap]`

### 2.1 TPCLWLB 큰달력(효도) = `vTmpl_price` 개당단가×수량×건수

라이브 capture priceCalls[0] PRICE_LOG 실측:
```
"개당단가 : 0.00원, 인쇄수량DDDDD : 1, 주문건수 : 1"  →  result_sum.PRICE = 11,900
```
- **계산식 = 개당단가 × 인쇄수량(PRN_CNT) × 주문건수(ORD_CNT)** + (재단/거치/포장 PCS=0 합산).
- 옵션 축: paper(아트지)·sizes(500×730 단일)·**starting-year(2026~2028)·starting-month(1~12월)** = 캘린더 시작년/월이 옵션이나 **가격 무영향**(템플릿 단가만). 수량 PRN_CNT(1~10) tier.
- → 후니 **개당단가형**(굿즈 GP-1 동형·디지털 SUM의 product_price×qty).

### 2.2 TPCLECO 에코 캘린더 = `tiered_price` (price_table_yn:Y)

- `item_gbn=vDigital_item`·`price_gbn=tiered_price`·`price_table_yn:Y` → **수량구간 단가표 룩업**.
- 캡처 시 위젯 미마운트("달력 사이즈 설정이 필요합니다") = 가격콜 미발생이나 **엔진 메타(tiered_price)는 명확**. 굿즈 GSTGMIC(`tiered_price` S6000/L7000·`[huni:prior]` §8)과 동일 엔진 = **자재/규격별 기본단가 + 수량구간 tier**.
- → 후니 **고정가/개당단가 + 수량구간할인 t_dsc_***.

### 2.3 GSCLMGN 자석캘린더 = `tmpl_price` (edicus 완제 SKU)

- `item_gbn=edicus_item`·`price_gbn=tmpl_price` = **에디터(edicus) 완제 템플릿 개당단가**. 옵션 축 paper/weight/dosu/sizes 전부 단일(1택) = **완제 SKU 1종 개당단가**.
- → 후니 **고정가형 완제 SKU**(굿즈 GP-1·디자인캘린더 inline 고정가). **edicus=에디터 라우팅이지 가격축 아님**(GSCLMGN ROI 0·rpmeta edicus_item 정합).

---

## 3. WowPress 캘린더 = 직접 캡처 부재·제본물 `jobqty→jobcost` 추론 `[wow:booklet]`

- 와우프레스 캘린더 단독 캡처 **부재**(`raw/widget_monitor/wow_capture/`에 booklet/goods/sticker만). 인접 제본물(`fresh_booklet_capture.json`)로 추론.
- **계산식(제본물)**: 서버 **작업량(`jobqty0`) → 작업비(`jobcost0`) 2단 API**. 용지(`paperno` 다단)·도수(`colorno`+`colorno_add`)·박앞뒤를 작업량(연·도무송)으로 환산 후 비용 산정.
- 캘린더에 적용 시(추론): 페이지수(장수)·제본방식·용지를 작업량으로 환산 → 작업비. **후니 단일 evaluate_price + 앱계산(임포지션) 분리로 이미 표현**(작업량 2단 엔진=과분화·흡수 부결, §7 결론 동형).
- **확신도: 낮음**(캘린더 직접 미관측·추론 명시).

---

## 4. 후니 권위 — 캘린더 = 디지털 SUM + 캘린더가공 inline 고정가 add-on `[huni:cal·bind]`

### 4.1 상품마스터 캘린더 시트 = 6 distinct 상품 (★권위)

| 상품명 | 사이즈 | 인쇄 | 장수(페이지) | 캘린더가공 | 추가가격(원) | 삼각대컬러 | 링칼라 |
|--------|--------|------|-------------|-----------|-------------|-----------|--------|
| 탁상형캘린더 | 220×145 / 130×220 | 양면 | 4(8P)~16(32P) | (삼각대 default) | 0 | 삼각대(그레이) | 블랙 |
| 미니탁상형캘린더 | 90×100 / 148×60 | 양면 | 12(24P)/16(32P) | (삼각대 default) | 0 | 삼각대(블랙) | 블랙 |
| 엽서캘린더 | 145×145 외 6규격 | 단면 | 12~16 | 가공없음(재단만)/**우드거치대**/타공+끈 | 0 / **4000** / 1000 | — | — |
| 벽걸이캘린더 | 210×297 / 210×420 / 300×420 | 단/양면 | 4~15 | **고리형트윈링제본** / 2구타공+끈 | **2000** / 1500 | — | 블랙 |
| 와이드벽걸이캘린더 | 300×625 | 단/양면 | 4~15 | 고리형트윈링제본 / 제본없음 | 2000 / 0 | — | 블랙 |

★**캘린더가공_추가가격 = inline 고정가**(2000원 트윈링·4000원 우드거치대·1000/1500원 타공) — 상품마스터에 명시된 **개당 정액 가산**(수량구간 아님). 본체 인쇄 = **디지털인쇄(종이사양 명시·장수=페이지수)** → 디지털 SUM 공식 계열.

### 4.2 인쇄상품 가격표 B03 캘린더 제본비 = 제본/수량 매트릭스 (삼각대 포함) `[huni:bind]`

| 제본/수량(부당가) | 1부 | 4부 | 10부 | 50부 | 100부 | 1000부 |
|-------------------|-----|-----|------|------|-------|--------|
| 벽걸이캘린더제본 | 5,000 | 4,000 | 3,000 | … | … | … |
| 탁상형캘린더제본(220) | 5,000 | 4,000 | 3,000 | … | … | … |
| 탁상형캘린더제본(130) | 5,000 | 4,000 | 3,000 | … | … | … |
| 탁상형캘린더제본(미니) | 4,500 | 3,500 | … | … | … | … |

★**가격표 B03 = 부당(권당) 제본비·수량↑→단가↓ 볼륨디스카운트·"삼각대 포함"**(F25 메모). **즉 후니 권위에는 캘린더 제본비를 담는 두 그릇이 공존**:
1. **상품마스터 캘린더가공_추가가격**(inline 고정가 2000/4000/1000원·삼각대 기본 포함·디지털 캘린더용)
2. **가격표 B03 캘린더 제본비**(부당×수량 매트릭스·삼각대 포함·옵셋/대량 캘린더용)

→ ★**designer 결정 사안**(컨펌큐): 캘린더 제본/가공 가격을 (1) inline 고정가(상품마스터)로 갈지 (2) B03 부당×수량 매트릭스로 갈지. **RedPrinting 실측은 (2) 방향**(삼각대·제본이 사이즈/수량 종속 단가)·**상품마스터 디자인캘린더 inline은 (1) 방향**. 두 그릇 다 후니 권위에 실재 — 상품별 어느 그릇이 권위인지는 가격표↔상품마스터 대조로 확정(추측 금지).

---

## 5. 한 줄 결론

RedPrinting 캘린더는 **SKU별 4 엔진**(`offset2023_price` PCS합산·`vTmpl_price` 개당단가×수량·`tiered_price` 수량구간·`tmpl_price` edicus 완제)으로 분기하나, **전부 후니가 기존 종단에서 이미 표현 가능한 계산방식**(합산형 디지털 SUM·개당단가형·수량구간할인·고정가 완제 SKU)이다. **새 가격축·새 t_prc_* 그릇 신설 불요**(price_gbn 4분기=공식 라우팅 enum, frm_cd 바인딩으로 흡수). 본 종단의 실질 흡수 후보 = **① 제본/거치대 가격의 "부당×수량 매트릭스" 메커니즘**(RedPrinting 실측·후니 B03 동형 실재·미배선)과 **② 캘린더가공 inline 고정가 add-on의 평탄화 가드**(굿즈 GP-2 선례)다. 상세는 `absorption-candidates-calendar.md`.
