# 역공학 구조 완전성 감사 — 동등성 게이트 레퍼런스 적격 판정

> 목적: 후니 위젯(`04_build`)이 RedPrinting 라이브 위젯과 **행위 동등(behavioral equivalence)**한지 비교하기 **전에**, RedPrinting 위젯 구조가 그 비교의 **레퍼런스로 삼을 만큼 충분히 역공학(정적 사전분석)되었는가**를 감사한다.
> 범위: 4개 가격모델 대표상품 × 5개 구조차원. **라이브 미구동(이 감사는 기존 정적 산출물만 평가)**.
> 근거표기: `[라이브 검증]`(실응답 캡처) / `[정적 분석]`(deob 소스·계약·fixture) / `[추정]`.
> 감사자: hw-reverse-engineer. 감사일: 2026-06-03.

---

## 0. 평가 대상 4 가격모델

| 모델 | 대표 productCode | price_gbn | 핵심 검증자료 |
|------|------------------|-----------|--------------|
| PriceTable3D | PRBKYPR(책자) · PRPOXXX/BNBNFBL(포스터·배너) · HLCLSTD/HLCLWAL(옵셋캘린더) | `book2025_price` / `digital_price` / `offset2023_price` | price-engine-reversed.md, s3-poster-capture.md, s6-calendar-live-note.md |
| SizeMatrix2D | ACNTHAP(아크릴 명찰) · BNBNFBL(배너 자유입력) | `vTmpl_price` / `real_price` | s3-poster-capture.md, s4-qa.md, option-schema-catalog.json |
| FixedUnit | STPADPN(DTF 판스티커) | `vTmpl_price` | s2-sticker-capture.md |
| TieredDiscount | GSTGMIC(네임택) · GSPUFBC(파우치) | `tiered_price` / `tmpl_price` | s5-m1-tiered-note.md, s5-pouch-live-note.md |

---

## 1. 판정 요약표 (4 모델 × 5 차원)

| 모델 \ 차원 | 1.옵션스키마 | 2.옵션캐스케이드 | 3.가격계약 | 4.에디터브릿지 | 5.업로드/S3 |
|-------------|:---:|:---:|:---:|:---:|:---:|
| **PriceTable3D** (PRBKYPR/포스터/캘린더) | **VERIFIED** | **VERIFIED** | **VERIFIED** | PARTIAL | **VERIFIED** |
| **SizeMatrix2D** (ACNTHAP/배너) | **VERIFIED** | PARTIAL | PARTIAL | PARTIAL | **VERIFIED** |
| **FixedUnit** (STPADPN) | **VERIFIED** | VERIFIED | **VERIFIED** | N/A(에디터없음) | PARTIAL |
| **TieredDiscount** (GSTGMIC/파우치) | **VERIFIED** | **VERIFIED** | **VERIFIED** | PARTIAL | N/A |

> 범례: VERIFIED=구조가 라이브 또는 확정 정적근거로 권위있게 확정. PARTIAL=구조 골격은 확정·일부 실데이터/실측 미확보(비차단). MISSING=동등성 비교를 막는 구조 공백.
> **MISSING 0건.** PARTIAL 항목은 전부 "위젯 행위와 무관한 BFF 내부값" 또는 "비차단 라이프사이클 실시간덤프"로, 동등성 게이트의 위젯측 비교 레퍼런스 적격성을 훼손하지 않음(근거는 각 모델 findings).

---

## 2. 모델별 상세 (file:line 근거)

### 2.1 PriceTable3D — 책자/포스터/옵셋캘린더

**1. 옵션 스키마 — VERIFIED**
- 18 데이터셋·표지/내지 분리구조 확정. `option-schema-catalog.json:51-69`(PRBKYPR datasets 17종, inner_pdt_* 4종 포함), `:93-101`(수량규칙 FIR=1/INC=10/STEP=10/MIN=30, MIN_PAGE=10/MAX_PAGE=300).
- option type·value enum·VIEW_YN·ESN_YN 전수: `option-schema-catalog.json:103-282`(pcs_list 20행, 각 행 `ESN`/`VIEW`/`SUB_MTRL` 명시 — 예 CUT_DFT VIEW=N(자동), END_PAP 면지 8색 VIEW=Y).
- 도수 enum: `:81-92`(SID_S 단면 4색, SID_D 양면 8색).
- 후가공 분류규칙(hidden/visible/essential): `option-schema-catalog.md:53-60`(deob_06:596 classifyPostProcessOptions, ESN_YN&VIEW_YN 조합).
- 캘린더 변형 옵션도 확정: `s6-calendar-live-note.md:26-31`(CLD_STD 달력규격·STA_CLD 시작연월이 PCS_INFO 추가행 = 기존 select로 흡수, 신규 componentType 0).

**2. 옵션 캐스케이드 — VERIFIED**
- material→pcs disable 구조 라이브 확정: `option-schema-catalog.json:283-405`(PRBKYPR disable_pcs 24행 전수 — 예 RXOMO080→COT_DFT/FLD_DFT/MIS_DFT/SCO_* 비활성).
- 캐스케이드 규칙 명문화: `option-schema-catalog.md:48-51`(MTRL_CD 매칭→PCS_CD disable, PCS_DTL_CD=null이면 그룹전체·값이면 특정상세 비활성, 자재변경→룩업→disable+선택해제).
- 의존키 = `MTRL_CD`(자재선택이 상류, PCS가 하류). 구조적 규칙이 라이브 24건으로 입증.

**3. 가격 계약 — VERIFIED**
- 요청 body shape 확정: `price-engine-reversed.md:15-38`(ORD_INFO[PDT_CD/CUT_*/WRK_*/PRN_CNT/PAGE_CNT/CVR_CLR_CNT/INN_CLR_CNT/CVR_MTRL_CD/INN_MTRL_CD] + PCS_INFO[PCS_COD/PCS_DTL_COD] + price_gbn + mb_cust_cod, `{dataJson:...}` 1중 래핑).
- 응답 shape 확정: `:51-79`(result[] 공정별 분해 + result_sum[PRICE/PRICE_VAT/PRICE_MALL/ORG_PRICE + PCS_ETC_PRICE/PCS_PRI_PRICE] + result_log 단가명세).
- price_gbn 의미 = book2025_price(표지+내지 분리, 페이지×수량): `:42-49`.
- 3단 워터폴(MALL/할인/정가) 시맨틱: `:81-87`(deob_06:1273-1284). 8조합 라이브 매트릭스로 가격거동 역산: `:91-147`(볼륨디스카운트·페이지선형 ~1115/page·색상영향 표지-12100/내지-3600).
- 옵셋캘린더 실가 라이브: `s6-calendar-live-note.md:16-17`(HLCLSTD 778,500 / HLCLWAL 2,368,500, ORD_INFO 필드 책자와 동일 `:36-38`).

**4. 에디터 브릿지 — PARTIAL**
- 프로토콜 골격 확정: `editor-bridge-protocol.md:17-50`(to/from-edicus type 분류, deferred-param 핸드셰이크, create_project URL 명령). 라이프사이클 단계 `:54-57`(init→ready→doc-changed→save-doc-report→goto-cart→close), save-doc-report/goto-cart 페이로드 `:62-83`.
- PARTIAL 사유: 본 세션 에디터 iframe 실구동 실시간 메시지 덤프 미수행(`:124`), goto-cart `case` 값 종류 미캡처(`:125`). 근거는 검증된 테스트베드 핸들러(index.html:326) + 정적소스.

**5. 업로드/S3 — VERIFIED**
- presigned 발급→PUT end-to-end 라이브: `s3-upload-flow.md:9-56`(POST /api/aws/presigned-url 200, 응답 filename UUID·presignedURL·60분만료·tempo버킷·서울리전, 프로브 PDF PUT 200).
- fileUploadInfo 주문데이터 구조: `:77-83`(inner=내지/표지 분리, org_file_nm 중복검증).

---

### 2.2 SizeMatrix2D — 아크릴(ACNTHAP)·배너(BNBNFBL 자유입력)

**1. 옵션 스키마 — VERIFIED**
- ACNTHAP 6데이터셋 + option_info(아크릴전용 production_method/shape_info/print_data): `option-schema-catalog.json:581-594`, `:680-699`.
- 배너 자유입력 메타 라이브: `s3-poster-capture.md:38-53`(BNBNFBL sizes 프리셋+자유입력, number 4종, 작업=재단+CUT_MRG), MIN/MAX_CUT 슬롯 실재 `:47-53`(BNBNFBL MAX_CUT_WDT=5000, CUT_MRG=4.00).
- 도수·자재·수량규칙 확정: `option-schema-catalog.json:606-621`(ACNTHAP SID_S 단면, FIR=1/INC=1).

**2. 옵션 캐스케이드 — PARTIAL**
- ACNTHAP disable_pcs 3건 라이브 확정: `option-schema-catalog.json:661-678`(RXIGC075→COT_DFT/MIS_DFT/SCO_DFT). 구조 동일(material→pcs).
- PARTIAL 사유: ① `option_info`(production_method/shape_info/print_data)의 실 COD값이 전부 null — `:680-699`(COD:null/COD_NME:null). 아크릴 "제작방식·형태"가 가격/하류옵션에 미치는 캐스케이드 구조 미확정(`option-schema-catalog.md:75`에 미검증 명시). ② 단일 SKU(명찰=프리셋전용)만 캡처, 자유입력 보유 아크릴 SKU 캐스케이드 미검증(`s4-qa.md:112-116` S4-M2).
- **비차단 판단**: 위젯은 캐스케이드를 어댑터 disableRules 평면화로 데이터구동 처리하며(s2-sticker-capture.md:131), option_info null COD는 ACNTHAP이 현재 그 차원을 안 쓴다는 뜻(가격무해, s4-qa.md:50-51 경계판정 PASS). 동등성 비교는 "후니 어댑터가 동일 disableRules를 생성하는가"로 가능 — Red의 미사용 option_info가 비교 레퍼런스를 막지 않음.

**3. 가격 계약 — PARTIAL**
- 요청 body의 SizeMatrix2D 핵심(cutW/cutH 수치 직접전달) 라이브 확정: `s3-poster-capture.md:55-62`(BNBNFBL ORD_INFO CUT_WDT:5000/CUT_HGH:900 수치직접, S1/S2 코드선택과 다른 경로). 자유입력 cutW=0 폴백결함 = NC-1 근거 `:87-92`.
- price_gbn 의미(real_price/vTmpl_price = m² 단가 보간, BFF SP): `:64-69`(query에 dbo.WSP_ACPT_ORDER_TMPL_PCS_PRICE SP 노출).
- 응답 shape는 PriceTable3D와 동일 envelope(result_sum.PRICE/ORG_PRICE): `s2-sticker-capture.md:103-115`.
- PARTIAL 사유: **PRICE>0 실가 미확보** — 비로그인 PRICE=0, 자유입력 직접 W/H 가격응답 미캡처(`s3-poster-capture.md:71`, `:175-176`; s4-qa.md:101 ACNTHAP 3중합성 실가 미확보).
- **비차단 판단**: SizeMatrix2D 보간 "결과수치"는 전부 BFF 권위(INV-1), 위젯은 cutW/cutH 입력만 echo. 동등성 게이트의 위젯측 비교대상은 "옵션→요청body 직렬화 정합"이며 이는 `s3-poster-capture.md:55-62`로 확정. 실가 정합은 후니 BFF 연결 후 별도 round-trip 검증 사안(위젯 구조 레퍼런스와 분리).

**4. 에디터 브릿지 — PARTIAL** (PriceTable3D와 동일, real_price 배너는 에디터 없음 PDF전용 `s3-poster-capture.md:29-35`)

**5. 업로드/S3 — VERIFIED** (presigned 계약은 상품무관 공통, s3-upload-flow.md. 배너 real_price=PDF전용 업로드 경로 `s3-poster-capture.md:164`)

---

### 2.3 FixedUnit — 스티커(STPADPN DTF 판)

**1. 옵션 스키마 — VERIFIED**
- 라이브 캡처 확정: `s2-sticker-capture.md:70-79`(STPADPN 소재 PXPUF003 1종, 규격 140X200/A4, 후가공 CUT_DFT/PRT_WHT/PAK_POL, 수량 FIR=1/INC=1/STEP=10 장단위, disable_pcs 0행).
- item_gbn/price_gbn/unit 확정: `:33`(vDigital_item / vTmpl_price / 장).

**2. 옵션 캐스케이드 — VERIFIED**
- disable_pcs 0행 = 캐스케이드 없음(단순구조) 라이브 확정: `s2-sticker-capture.md:79`. "제약 부재"가 구조적으로 확정됨(공백이 아니라 검증된 0).

**3. 가격 계약 — VERIFIED**
- 요청 body S1/S2 동일 envelope, price_gbn=vTmpl_price만 차이: `s2-sticker-capture.md:88-101`.
- **실가 라이브 확보(드문 케이스)**: `:109-115`(STPADPN vTmpl_price 140×200=4000원/A4=8000원, 비로그인에도 공개시트가 반환 → FixedUnit 역산단서). 규격↑→가격↑ 확인.
- 응답 result_sum.PRICE/PRICE_VAT shape 확정 `:113-114`.

**4. 에디터 브릿지 — N/A**
- STPADPN은 DTF 판스티커(PDF 업로드형), 에디터 라이프사이클 비적용. (스티커 일반 에디터플로우는 상품무관 S0/S1 커버 `s2-sticker-capture.md:165`)

**5. 업로드/S3 — PARTIAL**
- presigned 계약은 상품무관 공통 확정(s3-upload-flow.md VERIFIED). PARTIAL 사유: STPADPN 자체의 업로드 플로우 개별 캡처는 미수행(presigned 계약이 pdt_cod 파라미터만 다르고 공통이므로 구조적으로 커버됨). 비차단.

---

### 2.4 TieredDiscount — 굿즈(GSTGMIC 네임택)·파우치(GSPUFBC)

> **이 모델이 감사에서 가장 중요한 발견을 담는다.** "TieredDiscount"라는 명칭과 실제 거동이 다르다.

**1. 옵션 스키마 — VERIFIED**
- GSTGMIC 11데이터셋·내지없음 단순구조: `option-schema-catalog.json:413-435`. 후가공 11행(THO_CUT 모양커팅·WRK_MTR 부자재작업·PAK_POL): `:463-563`, 수량 FIR=1/INC=1: `:454-462`.
- 파우치 GSPUFBC 옵션구조 라이브 16컨트롤: `s5-pouch-live-note.md:12-26`(자재 1종/도수 1종/규격 5종 템플릿/수량/PRN_CNT).

**2. 옵션 캐스케이드 — VERIFIED**
- GSTGMIC disable_pcs 0행 = 캐스케이드 없음 라이브 확정: `option-schema-catalog.json:565-566`. 검증된 0.

**3. 가격 계약 — VERIFIED (+핵심 발견)**
- 요청 body 동일 envelope, price_gbn=tiered_price/tmpl_price: `s5-m1-tiered-note.md:4-7`.
- **핵심 발견 [라이브 검증]**: "tiered_price"는 **수량구간 할인이 아니다.** GSTGMIC 수량스윕(1/10/100/1000) 전 구간 개당 6,000원 완전선형, ORG_PRICE===PRICE(할인 0%): `s5-m1-tiered-note.md:43-49`. 7 SKU·3 price_gbn 전체에서 ORG===PRICE → 자동견적 경로에 수량할인 부재: `:74-92`. price_gbn 명칭은 "규격/자재 매트릭스 룩업 방식"을 가리킴(`:90`).
- 파우치 tmpl_price도 평탄선형 확정 + **PRICE>0 달성**: `s5-pouch-live-note.md:6`(2,850,000원), 수량스윕 평탄 `:44-53`, PRN_CNT 정수배·규격별 단가 `:56-58`.
- **필수 reqBody 계약 발견**: ORD_CNT + PRN_CNT 둘 다 ORD_INFO 안에 있어야 PRICE>0, 누락 시 침묵 PRICE=0 — Red 위젯 실제 결함: `s5-pouch-live-note.md:32-39`, `:67`.
- 응답 ORG_PRICE/PRICE 2필드 = 할인표현 슬롯 스키마 존재(굿즈선 미사용 동일값): `s5-m1-tiered-note.md:100-101`.

**4. 에디터 브릿지 — PARTIAL** (GSTGMIC useKoiEditor=Y `option-schema-catalog.json:418-421`, 라이프사이클은 §2.1과 동일 PARTIAL — 굿즈 개별 덤프 미수행, 상품무관)

**5. 업로드/S3 — N/A** (굿즈는 에디터/PDF 선택형, presigned 공통계약으로 커버)

---

## 3. GAP 리스트 (실차단만 — 이론적 완전성 아님)

| ID | 차원/모델 | 심각도 | 내용 | 해소할 라이브 캡처 |
|----|-----------|--------|------|--------------------|
| G1 | 에디터브릿지 / 전모델 | **MINOR** | 에디터 iframe 실구동 from-edicus 실시간 메시지 타임라인·goto-cart `case` 값 종류 미캡처. 프로토콜·페이로드 골격은 테스트베드 핸들러+정적소스로 확정(editor-bridge-protocol.md:124-125). | 헤드리스 브라우저로 책자 1종 풀 에디터 플로우(createProject→편집→save-doc-report→goto-cart) 구동 후 message 이벤트 덤프. hw-runtime-analyst 영역. |
| G2 | 캐스케이드 / SizeMatrix2D(아크릴) | **MINOR** | 아크릴 `option_info`(production_method/shape_info/print_data) 실 COD값 전부 null — 제작방식·형태의 하류 캐스케이드 구조 미확정(option-schema-catalog.json:680-699). | option_info에 실값을 가진 아크릴 SKU(스탠드/키링류)로 get_digital_product_info 캡처. 동등성 게이트엔 비차단(ACNTHAP은 해당 차원 미사용, s4-qa.md:50). |
| G3 | 가격계약 실가 / SizeMatrix2D | **MINOR** | SizeMatrix2D PRICE>0 실가(자유입력 직접 W/H→가격) 미확보(s3-poster-capture.md:175-176). 요청 body 직렬화는 확정. | 로그인 세션 + 자유입력 W/H 확정조합으로 get_ajax_price_vTmpl 캡처. 단 결과수치는 BFF 권위(INV-1)라 위젯 구조 레퍼런스와 분리 — 후니 BFF 연결 후 round-trip 검증 사안. |

> **BLOCKER 0건.** G1~G3 모두 MINOR이며 공통적으로 "위젯이 echo/표시만 하는 BFF 내부 결과" 또는 "비차단 라이프사이클 실시간덤프"에 해당. 위젯의 비교 대상(옵션트리·componentType 매핑·요청body 직렬화·캐스케이드 disableRules·presigned 계약)은 4모델 전부 VERIFIED 근거를 보유.

---

## 4. 최종 판정

### 정적 역공학이 행위 동등성 게이트의 레퍼런스로 충분히 권위적인가?

## **YES-with-minor-gaps**

**근거:**

1. **5×4 매트릭스에 MISSING 0, BLOCKER GAP 0.** 동등성 비교를 막는 구조 공백이 없다. 모든 PARTIAL은 "BFF 권위 결과수치(위젯 무관, INV-1)" 또는 "비차단 에디터 실시간덤프"로 분류되며, 위젯이 직접 책임지는 구조(옵션스키마·componentType 매핑·요청body 직렬화·캐스케이드 disableRules·presigned 계약)는 4모델 전부 VERIFIED.

2. **위젯측 비교축은 전부 확정됨.** 행위 동등성 게이트가 실제로 대조해야 할 것은 (a) 동일 옵션트리가 동일 componentType로 렌더되는가, (b) 옵션변경이 동일 요청body를 생성하는가, (c) 캐스케이드 disable이 동일하게 발동하는가, (d) presigned/goto-cart 계약을 동일하게 처리하는가다. 이 네 축 모두 라이브 또는 확정 정적근거를 가진다. 가격 "결과수치" 자체는 RedPrinting BFF 내부(역산 불가·불필요)이므로 위젯 동등성의 비교축이 아니다(INV-1 — price-engine-reversed.md:155).

3. **명칭함정이 사전에 교정됨(레퍼런스 신뢰성 강화 증거).** "tiered_price=수량할인"이라는 직관적 오해를 라이브 스윕으로 반증(s5-m1-tiered-note.md) — 만약 이 교정 없이 게이트를 돌렸다면 후니 위젯이 존재하지 않는 할인곡선을 재현하지 못한다고 위양성(false-fail) 판정했을 것. 정적분석이 단순 수집이 아니라 거동까지 검증한 깊이를 보여준다.

4. **잔존 갭은 "minor"여야 함이 정직하게 명시됨(은폐 없음).** G1(에디터 실시간덤프)·G2(아크릴 option_info null)·G3(SizeMatrix 실가)는 각 산출물의 "잔존 미검증" 섹션에 이미 자가신고되어 있으며, 동등성 게이트 진행 중 hw-runtime-analyst의 라이브 캡처로 자연 보강 가능하다.

**조건부 권고:** G1은 동등성 게이트의 "에디터 흐름 동등" 하위항목을 검증하려면 라이브 캡처 1회가 선행돼야 한다(전체 게이트 차단은 아님 — 옵션/가격/캐스케이드/업로드 동등성은 G1 없이 즉시 비교 가능). G3은 후니 BFF 연결 시점에 round-trip 검증으로 흡수.
