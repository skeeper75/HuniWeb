# reverse-price-contracts.md — 역공학 가격계약 추출 (후보·갭헌팅)

> 역공학 자료가 *어떤 구성요소 축으로* 가격을 짜는지의 증거. **흡수 후보·갭헌팅용**[HARD].
> 권위 엑셀(상품마스터·가격표)이 절대 권위 — 역공학은 후보(naming/codes 후니 유입 금지).
> 산출자: hpe-formula-cartographer · 라이브 읽기전용 · 디지털인쇄 한정.

---

## 1. widget_monitor PRICE 계약 (RedPrinting 라이브)

| 항목 | 실측 | 확신도 |
|------|------|--------|
| 명함류 캡처 | `raw/widget_monitor/BCSPDFT_capture.json` (BCSPDFT=명함) | — |
| `networkApiCalls` | **빈 배열 [0]** — 가격 전용 서버 API 호출 없음 | 높음(실측) |
| 함의 | RedPrinting은 **가격을 클라이언트(위젯)에서 계산** 또는 옵션선택 시 일괄 응답에 포함. 디지털인쇄 캡처에 독립 PRICE 엔드포인트 미관측 | 중 |
| 후니 대조 | 후니는 서버 권위 `evaluate_price`(pricing.py:247) — RedPrinting 클라계산과 아키텍처 상이([[huni-widget-price-strategy]] 서버권위 결정) | 높음 |

**결론**: widget_monitor는 디지털인쇄 가격 *수식* 증거를 직접 주지 않음(서버 API 0). 구성요소 *축* 후보는 rpmeta 메타모델이 더 유용.

---

## 2. rpmeta 옵션 관리 메타모델 — 가격기여 축 (D-6 Pricing Role)

`_workspace/huni-rpmeta/02_metamodel/discovered-axes.md` 발굴:

| 축 | 의미 | 디지털인쇄 후니 대조 |
|----|------|----------------------|
| **D-6 가격기여 역할(Pricing Role)** distinct 횡단 | 각 선택이 가격에 *어떻게* 기여하는가 = **면적 / 곱수 / 고정 / 단가** | 후니 calc-draft의 계산방식(원자합산=단가합·고정가=룩업)과 정합. RP는 `price_flag`로 전 축에 부착 |
| **D-5 수량 모델** distinct | 건수×수량 다중 수량 슬롯 + 공정종속 수량 | 후니 `제작수량(건수/최소/최대/증가)` + 출력매수=수량/판걸이수 와 동형 |
| **D-4 공정 파라미터** distinct | 공정 멤버 종속 매개변수(줄수·mm·색·수량) | 후니 후가공 comp(오시 줄수·미싱)·별색(색×면)의 proc_cd/print_opt_cd 차원과 동형 |

**흡수 판정**: 후니 t_prc_* 차원 모델(use_dims)이 RP의 D-4/D-5/D-6를 **이미 표현** — 신규 그릇 불요. RP는 가격기여를 `price_flag` 단일 부착으로, 후니는 comp별 prc_typ_cd(단가/합가) + use_dims로 분리. 후니가 더 정규화됨.

---

## 3. 경쟁사 구성요소 축 후보 (디지털인쇄 갭헌팅)

| RP/경쟁사 축 | 후니 흡수 위치 | 갭? |
|--------------|---------------|-----|
| 인쇄방식(옵셋 vs 디지털) | 후니=디지털인쇄 전용 시트(옵셋 별 가격엔진) — 후니 디지털인쇄에 옵셋 없음 | GAP 아님(범위 외) |
| 별색(spot color) family | COMP_PRINT_SPOT_WHITE_S1 단일 comp + 색×면 차원 | 흡수 완료 |
| 접지(folding) family | COMP_FOLD_* (카드/리플렛 타입별) | 흡수 완료 |
| 면적별 박(동판비+면적군 합가) | 후니 calc-draft 요구하나 라이브 미배선 | **GAP**(gap-board G-1) |
| 완제품 통합단가(용지포함) | COMP_NAMECARD_*·PHOTOCARD_* | 흡수 완료(단가행 결손 의심) |
| 수량구간 할인(tier) | t_dsc_* 할인테이블 (디지털인쇄는 원자합산이라 구간할인 약함·문구/굿즈가 주 사용) | 디지털인쇄 범위 약함 |

---

## 4. designer를 위한 역공학 권고

1. **widget PRICE 수식은 역공학 불가**(서버 API 0) — 가격 *수식* 권위는 calc-formula-draft, 역공학은 *축* 후보만.
2. **rpmeta D-6(면적/곱수/고정/단가)가 후니 계산방식 분류를 외부 검증** — 후니 원자합산형=단가합·고정가형=룩업이 RP price_flag 패턴과 정합. 신규 계산방식 도입 불요.
3. **naming/codes 유입 금지** — RP의 `price_flag`·`item_gbn` 등을 후니 comp_cd/prc_typ_cd로 번역 금지. 후니 컨벤션 유지.
4. 디지털인쇄에서 역공학이 새로 던지는 갭은 **면적별 박(대형/소형)** 뿐 — 나머지는 후니 t_prc_* 가 이미 표현.

---

## 5. 아크릴 절 — 역공학 가격계약 (면적매트릭스형)

### 5-1. widget_monitor / RedPrinting 아크릴

| 항목 | 실측 | 확신도 |
|------|------|--------|
| RP 아크릴 가격모델 | rpmeta AC 카테고리(아크릴20상품) 종단 — distinct 0 재포화(`huni-rpmeta/categories/AC/`) | 중 |
| 가격기여 축 | RP도 아크릴=**면적(width×height)** 단가 + 두께/소재 facet — 후니 면적매트릭스(siz_width/siz_height)+mat_cd와 동형 | 중 |
| 함의 | RP 아크릴이 면적축으로 가격 짜는 것이 후니 calc-draft `[면적매트릭스형]`을 외부 검증. 신규 계산방식 도입 불요 |

### 5-2. rpmeta 메타모델 — 아크릴 가격축 흡수 판정

| RP/경쟁사 축 | 후니 흡수 위치 | 갭? |
|--------------|---------------|-----|
| 면적(가로×세로) 단가 | COMP_ACRYL_CLEAR3T use_dims=[siz_width,siz_height]·엔진 TIER off-grid | 흡수 완료 |
| 두께(thickness) | mat_cd 직교차원(MAT_000043 3mm·MAT_000042 1.5mm) | 흡수 완료 |
| 소재(투명/미러) | 투명=CLEAR3T·미러=MIRROR3T(별 comp) — ★소재 택1 CPQ 미구현 | **GAP**(G-A5·미러 바인딩 G-A2 선결) |
| 형상(shape) — rpmeta #17 distinct 축 | 카라비너=opt_cd(형상)·완칼은 단가통합 | 카라비너 opt_cd 채번 GAP(G-A4) |
| 후가공(고리/자석/바디·조각수) | 상품마스터 `가공(옵션)`·`조각수(옵션)` → CPQ option(미적재) | **GAP**(G-A5) |
| 외주 완제품 고정가(코롯토/카라비너) | COROTTO=면적매트릭스·CARABINER=opt_cd 고정가 | COROTTO 흡수·CARABINER 미설계 |

**흡수 판정**: 후니 t_prc_* 면적매트릭스(siz_width/siz_height numeric + 엔진 TIER ceiling)가 RP 아크릴 면적가격을 **이미 표현**·두께=mat_cd로 정규화. 신규 그릇 불요. **갭은 전부 배선/바인딩/CPQ 옵션레이어**(가격축 신규 아님).

### 5-3. designer 권고 (아크릴)

1. **가격 수식 권위 = 가격표 [가로×세로] 매트릭스 + calc-draft `면적매트릭스형`** — 역공학은 면적축을 외부검증할 뿐 수식 권위 아님.
2. **naming/codes 유입 금지** — RP의 형상/두께 라벨을 후니 mat_cd/opt_cd로 직역 금지. 후니 컨벤션(COMP_ACRYL_*·MAT_000043) 유지.
3. 아크릴에서 역공학이 던지는 새 갭은 **소재선택(투명/미러) CPQ·형상 opt_cd(카라비너)** — 가격축은 후니가 이미 표현(면적매트릭스).

---

## 6. 실사·현수막 역공학 가격계약 (rpmeta 배너/실사 + widget_monitor)

> 역공학은 후보(갭헌팅)·권위 아님. 가격축 권위 = calc-draft `[면적매트릭스형:실사,현수막]` + 가격표 [가로×세로].

| 역공학 구성요소 축 | 후니 t_prc_* 대응(라이브) | 흡수 판정 |
|--------------------|--------------------------|----------|
| 면적 가격(가로×세로 입력→대형 m 단위) | 면적매트릭스 siz_width/siz_height 구간 + 엔진 TIER ceiling | **이미 표현**(아크릴 동형·신안 라이브 COMMIT) |
| 소재 선택(실사 방수/아트패브릭/레더/메쉬·현수막 일반/메쉬/린넨) | 소재별 PRF_POSTER_<MAT>·동형결합 정본(byte-identical만) | **이미 표현**(13→7 정본·결합 COMMIT) |
| 비규격 증가단위(임의 가로/세로·rpmeta TILL_WH_GBN 발상) | nonspec_yn·width/height_min/max/incr(현수막 100mm·포스터 200mm) | **이미 표현**(라이브 백필 완료·아크릴은 incr GAP였음) |
| 현수막 후가공(타공/아일렛·봉미싱·큐방·끈·열재단·D테이프) | COMP_POSTEROPT_BANNER_*(라이브 실재) | comp 실재·**배선 GAP**(G-S1) |
| 거치/스탠드(PET배너·미니류·캔버스행잉·족자·우드봉) | COMP_POSTEROPT_*_STAND/WOODHANGER/WOODBONG/CEILHOOK | comp 실재·**배선 GAP**(G-S1)·세트 아닌 add-on |
| 수량 볼륨할인(현수막 다량 주문 개당가↓) | 미니류 min_qty tier(수량구간형) + t_dsc 구간할인(본체) | **이미 표현**(미니 단가밴드·면적은 t_dsc) |

**흡수 판정**: 후니 t_prc_*(면적매트릭스 siz_width/height + 엔진 TIER ceiling + nonspec_incr + 동형결합 + 미니 수량밴드)가 RP/widget 실사·현수막 가격축을 **이미 표현**. 신규 그릇 불요. **갭은 전부 후가공/거치 배선(G-S1)**(가격축 신규 아님·comp는 실재).

### 6-1. designer 권고 (실사·현수막)

1. **가격축 권위 = 가격표 [가로×세로] 포스터사인 매트릭스 + calc-draft `면적매트릭스형:실사,현수막`** ([[dbmap-silsa-price-via-poster-sign]]·실사 inline price 아님). 역공학은 면적/후가공 축을 외부검증할 뿐 수식 권위 아님.
2. **naming/codes 유입 금지** — RP 배너 라벨(TILL_WH_GBN 등)을 후니 comp/proc/opt_cd로 직역 금지. 후니 컨벤션(COMP_POSTER_*·COMP_POSTEROPT_*) 유지.
3. 역공학이 던지는 실 갭은 **후가공/거치 add-on 배선(G-S1)**(타공/봉미싱/큐방/끈/거치)·가격축은 후니가 이미 표현. 아크릴(G-A1 본체 미바인딩)과 달리 실사·현수막은 본체 완성·후가공만 단절.
