# parity-matrix-S2-product-coverage.md — 전 상품 분기 커버리지 맵 (479/26 × 갭)

> **STAGE S2**. 사용자 핵심 요구 "샘플이 아니라 역공학 코드의 **전 상품**에 대해 검증" 실행. 479 상품 / 26 카테고리를 itemGroup·컴포넌트조합으로 분류하고, **어느 상품이 어느 갭에 걸리는지** 매핑해 S3 보정 우선순위를 상품수 기준으로 재정렬한다.
> **판정 기준(불변)**: 책임/로직/분기 재현 동등성. **검증만 — 코드 수정 없음.**
> **권위**: `redprinting_catalog.json`(479/26, raw/widget_monitor) + `red-code-map-05-api.md`(itemGroup 권위) + `parity-gap-map.md`(BLOCKER 2/MAJOR 9) + 자작 P1/D4.

---

## 0. 분류 방법론 + 정직한 한계

### 0-A. 카탈로그가 주는 것 / 안 주는 것
`redprinting_catalog.json` 항목 shape = `{category, pdtCode, name, url}` **단 4필드**. **itemGroup·PCS_CD·componentType·옵션조합 정보 0**. 따라서 상품별 정밀 PCS 매핑은 **불가능** — 정직하게 명시한다.

> ⚠ **brief의 "catalog.json(479/26)"은 `raw/widget_monitor/local/catalog.json`(174/3)이 아니라 `raw/widget_monitor/redprinting_catalog.json`(479/26)**임을 확인. 본 맵은 후자(전 universe) 기준. 전자는 dev 하네스용 축소본.

### 0-B. 분류 방법 (3중 근거, confidence 표기)
1. **category(2자) = pdtCode prefix**: 검증결과 479개 전부 일치(category==pdtCode.slice(0,2)). → 카테고리 분류는 **확정(high)**.
2. **category → itemGroup**: `red-code-map-05-api.md` 권위 4종 — `book2025_item`(책자, 표지/내지 분리·deob_06:1046), `clothes2025_item`(의류, SLK/팬톤·deob_06:1194), `ACC`(부자재, AccWidgetInstance·deob_06), `vDigital`(그 외 디지털, 단일면). 카테고리명+상품명+캡처한 대표상품의 실데이터로 추정 — **medium**(카테고리 내 혼재 가능, 예 PR에 책자+포스터 혼재).
3. **itemGroup → 갭 노출**: 갭은 itemGroup·후가공조합에 걸림. 카탈로그가 PCS_CD를 안 주므로 **"이 itemGroup이 쓸 수 있는 후가공"을 코드 분기(red-code-map-07)로 상한 추정** — **low~medium**. "해당 갭이 걸릴 수 있는 상품군"이지 "정확히 N개 상품이 ROU_DFT를 쓴다"가 아님.

### 0-C. 한계 선언
- 상품별 정확한 후가공 보유 여부는 **각 상품 get_digital_product_info 호출 없이 불가** (479회 호출 안 함 — 트래픽가드·범위). 따라서 L-3(ROU_DFT)·L-4(END_PAP) 같은 **후가공 특정 갭의 정확 상품수는 추정범위로만** 제시.
- 가격직결 갭(L-1 ATTB, L-2 COT_DFT, D-L3 침묵0)은 **후가공/가격을 쓰는 거의 모든 상품**에 잠재 → itemGroup 무관 광범위. 이건 상품수보다 "실 BFF 배선 시 전수 전제".

---

## 1. 479 상품 itemGroup 분류 (카테고리 단위)

| 카테고리 | 상품수 | 추정 itemGroup | 근거(대표상품/캡처) | confidence |
|----------|--------|----------------|---------------------|------------|
| GS 굿즈 | 136 | **vDigital** (단일면 굿즈) | GSTGMIC/GSPUFBC/GSBGRDY 캡처(S5) — 단일면, 디자인수×수량 | high(캡처됨) |
| PR 책자/리플렛 | 56 | **혼재**: book2025(책자·화보) + vDigital(리플렛·포스터) | PRBKYPR 캡처(S1·책자, 표지/내지). PR 리플렛/포스터는 단일면 | medium |
| ST 스티커 | 36 | **vDigital** | STCUXXX/STPADPN/STTHCIC 캡처(S2) — 자유형/도무송 | high(캡처됨) |
| PH 포토 | 30 | **혼재**: book2025(포토북) + vDigital(보드/판스티커) | "포토북"=책자, "포토 보드"=단일면 | medium |
| CL 의류 | 30 | **clothes2025_item** | 앞치마·티셔츠·탱크탑 — Apparel 컴포넌트 경로 | high(itemGroup명확) |
| TP 명함류 | 23 | **vDigital** | 디자인명함·쿠폰·떡메 — 단일면 | medium |
| BN 배너 | 23 | **vDigital** (real_price 실사) | X배너·매쉬배너 — real_price(BNBNFBL/BNPTPET 캡처 S3) | high(캡처됨) |
| FS 패브릭 | 21 | **vDigital** | 코스터·포스터·쿠션 | medium |
| AC 아크릴 | 20 | **vDigital** (ACC 가능성) | ACNTHAP/AIPPCUT 캡처(S4) — 단일면. (AC=아크릴, ACC 부자재와 별개) | high(캡처됨) |
| AI 에코백 | 14 | **vDigital** (직접인쇄/플록) | 에코백 — 인쇄방식 옵션 | medium |
| BT 버튼 | 12 | **vDigital** | 핀/자석/거울 버튼 | low |
| AH 점착 | 10 | **vDigital** | 점착 스티커류 | low |
| BC 명함 | 9 | **vDigital** | BCSPDFT 캡처(S1) — 일반명함. 화이트인쇄·스코딕스·박/형압(후가공 多) | high(캡처됨) |
| NC 옵셋명함 | 9 | **vDigital** (tiered/폐쇄래더) | 옵셋 일반/고급/2·3단 — 폐쇄 수량래더(HLCLSTD형) | medium |
| FB 패브릭굿즈 | 8 | **vDigital** | 마우스패드·안경닦이·파우치 | low |
| OT 패키지 | 7 | **vDigital** | 상자류 | low |
| EN 봉투 | 7 | **vDigital** | 봉투류 | low |
| HL 옵셋전단 | 7 | **vDigital** (폐쇄래더) | HLCLSTD/HLCLWAL 캡처(S6) — 옵셋 폐쇄 인쇄수량 enum | high(캡처됨) |
| PO 포맥스 | 7 | **vDigital** (real_price 실사 가능) | 합지·직접출력 — 실사류 | medium |
| LF 전단 | 3 | **vDigital** | 일반전단·문어발 | low |
| PD 반려 | 3 | **vDigital** | 스툴·슬리퍼·계단 | low |
| ET 기타 | 2 | **vDigital** | 손목띠·모양택 | low |
| PM 화보 | 2 | **혼재**: book2025(책자) + vDigital(낱장) | "화보 포트폴리오_책자"=book, "_낱장"=단일 | medium |
| SK 옵셋스티커 | 2 | **vDigital** (폐쇄래더) | 옵셋 도무송/사각재단 | medium |
| PV PVC | 1 | **vDigital** | 사원증/PVC카드 | low |
| ME 각대봉투 | 1 | **vDigital** | 크라프트 봉투 | low |

### itemGroup 집계 (추정)
| itemGroup | 상품수(추정) | 카테고리 | 캡처 커버 |
|-----------|-------------|----------|-----------|
| **vDigital** (단일면 디지털) | **~390** (81%) | GS136 + ST36 + TP23 + BN23 + FS21 + AC20 + AI14 + BT12 + AH10 + BC9 + NC9 + FB8 + OT7 + EN7 + HL7 + PO7 + 기타~16 + PR/PH/PM 단일면 일부 | **다수 캡처됨** (BC/ST/BN/AC/GS/HL) |
| **book2025_item** (책자) | **~30** (6%) | PR 책자 일부(~20) + PH 포토북(~8) + PM 책자(1) | PRBKYPR 캡처 |
| **clothes2025_item** (의류) | **30** (6%) | CL 30 | **0 캡처 — 전 미커버** |
| **ACC** (부자재) | **~0~소수** | (AC=아크릴은 vDigital. 진성 ACC 부자재는 별 카테고리 없거나 옵션레벨) | **0 캡처** |

> ⚠ ACC 주의: 카탈로그 카테고리에 명시적 "부자재" 없음. ACC(AccWidgetInstance)는 **상품이 아니라 다른 상품의 옵션 안에서 호출되는 부자재 선택**일 가능성(deob_07 Acc = accFilterConfigMap[pdtCode]). 즉 ACC는 **카테고리가 아니라 특정 상품의 부자재 옵션 모드** → 상품수로 카운트 어려움. **honest: ACC 정확 노출 상품 미상**.

---

## 2. 갭-노출 매트릭스 (itemGroup × 갭)

> 발현 = 현 fixture가 실제로 그 갭 경로를 탐. 무증상 = 코드엔 있으나 우리 미지원·캡처 없어 안 보임.

| itemGroup / 상품군 | 대표상품 | 걸리는 갭 | 현 발현 여부 | 상품수/비중 |
|--------------------|----------|-----------|--------------|-------------|
| **vDigital 단일면** (대부분) | BCSPDFT·STCUXXX·GSTGMIC·BNBNFBL | **L-1 ATTB**(후가공 ATTB 보유 상품), **L-2 COT_DFT**(코팅 보유=책자/일부), **D-L3 침묵0**(전 상품), **C-2 disable폴백**(자재→pcs disable 상품), **P4 VIEW_YN**(동적옵션) | **발현**(BC 후가공·BN real_price·ST 캡처됨). L-2는 vDigital 코팅상품만 | ~390 (81%) |
| **book2025 책자** | PRBKYPR | **L-1**(면지 END_PAP·링색 RIN_DFT), **L-2 COT_DFT**(책자코팅 PRBK 맵·mod_07:2250), **L-3 ROU_DFT**(귀처리), **L-4 END_PAP**(면지색칩), **C-1 size→반경**, **D-L2 isBook**(휴리스틱 대체 중), **에디터 표지/내지** | **부분발현**(PRBKYPR 캡처 — 표지/내지·후가공). L-3/L-4는 면지·귀 보유 책자만 | ~30 (6%) |
| **clothes2025 의류** | (CL 30 전부) | **D-L2 clothes 분기 없음**(BLOCKER급 — PRINT_TYPE 분기 0), **C-3 인쇄영역→PDT_WRK**, **C-4 자재→DIR_MTR**, **C-5 PRT_WHT 자동**, **C-6 DosuColor BNC**, **L-11 멀티사이즈수량**, 팬톤 color-chip | **무증상(전 미지원)** — 어댑터에 apparel_info 경로 0 | **30 (6%) 전체 사각** |
| **ACC 부자재** | (옵션모드) | **L-12 ACC 인스턴스/캐스케이드 전무**, accFilterConfigMap CASCADE/MULTI | **무증상(미지원)** | 미상(옵션레벨) |
| **폐쇄래더** (HL/NC/SK 옵셋) | HLCLSTD·HLCLWAL | (해소됨) PRN_CNT select enum 분기 RA:304~321 | **발현·정상**(S6 캡처, 갭 아님) | ~18 |
| **real_price 실사** (BN/PO) | BNBNFBL·BNPTPET | (해소됨) dimension-matrix NC-1 RA:176~211 | **발현·정상**(S3 캡처, 갭 아님) | ~30 |

---

## 3. 커버리지 사각지대 정량화 (핵심 질문)

> "현 fixture 무증상"이라 안 보이지만 코드엔 분기가 살아있는 **전체 미지원 상품군**.

### 사각 ① clothes2025 의류 — **30 상품 전체 미지원 (가장 큰 단일 사각)**
- **CL 카테고리 30개 전부** 어댑터 미지원. `red-adapter.ts`에 `apparel_info` 참조 0건(P1 L-13 확정).
- 걸리는 갭: D-L2(clothes PRINT_TYPE 분기 부재), C-3/C-4/C-5/C-6(의류 내부 캐스케이드 전손실), L-11(멀티사이즈 수량), 팬톤 color-chip.
- **정량: 30 상품 (전 universe의 6.3%) — 단일 itemGroup 최대 사각.** 의류 컨버전 = 신규 어댑터 분기 + 의류 컴포넌트 다수.

### 사각 ② ACC 부자재 캐스케이드 — **상품수 미상(옵션레벨), 구조적 사각**
- AccWidgetInstance + accFilterConfigMap(CASCADE/MULTI) 전무(L-12). 카탈로그에 독립 카테고리 없어 정확 상품수 산출 불가.
- **honest 정량 불가** — "어느 상품이 부자재 옵션을 쓰는가"는 상품별 get_digital_product_info 필요. 추정: 굿즈/패키지 일부가 부자재 옵션 보유 가능.

### 사각 ③ book2025 후가공 심화 — **~30 책자 중 면지/귀/링 보유분**
- L-3(ROU_DFT 귀)·L-4(END_PAP 면지색칩)·L-1(RIN_DFT 링색)은 **책자 중 해당 후가공 보유분만**. PRBKYPR는 표지/내지·일부 후가공 캡처했으나 면지색칩·귀처리 전체 검증 안 됨.
- **정량: ~30 책자의 부분집합**(정확수 미상 — PCS_CD 카탈로그 부재).

### 사각 합계
- **명확 미지원: 의류 30 (6.3%)** + **ACC 미상**.
- **부분지원(캡처 일부): 책자 ~30** — 후가공 심화 미검증.
- **지원·발현: vDigital ~390 (81%)** 중 폐쇄래더·real_price는 해소, 후가공 ATTB/복합/색칩 보유분은 잠재 갭.

---

## 4. S3 보정 우선순위 재정렬 (갭 × 상품수)

> gap-map의 심각도순을 **"몇 상품/어느 itemGroup을 푸는가"**로 재가중.

| 순위 | 갭 | 심각도 | 노출 상품수(추정) | itemGroup | 재정렬 근거 |
|------|----|--------|-------------------|-----------|-------------|
| **1** | **D-L3 침묵 PRICE=0 차단** | BLOCKER | **~479 (전 상품)** | 전체 | 가격은 모든 상품 공통(단일 E2 엔드포인트, api-map). 침묵0 미차단은 **전 universe 위험**. 상품수 1위 |
| **2** | **L-1 ATTB 전손실** | BLOCKER | **후가공 ATTB 보유 전 상품**(책자+굿즈+의류 다수, 수백) | 전 itemGroup | 링색·반경·속성 단가차. 후가공 쓰는 상품 광범위 — 실 BFF 배선 시 가격왜곡 광역 |
| **3** | **L-2 COT_DFT/SCO_DFT 복합** | BLOCKER | **코팅 보유 상품**(책자 ~30 + vDigital 코팅분) | book2025+vDigital | 합성 PCS_DTL_COD 왜곡 = 가격오류. 책자 전반 + 코팅 굿즈 |
| **4** | **D-L2 itemGroup echo (특히 clothes 분기)** | MAJOR | **의류 30 + 책자 30 분기정확성** | clothes2025+book2025 | clothes PRINT_TYPE 분기 부재는 의류 30 전체 차단의 근원. itemGroup echo가 전제 |
| **5** | **L-4 END_PAP color-chip** | MAJOR | **면지색칩 책자**(책자 ~30 부분) | book2025 | 면지 보유 책자. 시각+선택의미. "산출0" 오판 정정으로 baseline 실재 확인 |
| **6** | **L-3 ROU_DFT 멀티+반경** | MAJOR | **귀처리 상품**(책자·일부 굿즈) | book2025+vDigital | 4귀 다중·반경. 해당 후가공 보유분 한정 |
| **7** | **P4 VIEW_YN 동적토글** | MAJOR | **동적옵션 상품**(미상, 후가공 런타임 토글) | 전반 | 정확 상품수 미상이나 가격재계산 연동 — 발현 시 광역 |
| **8** | **의류 전경로 (C-3~C-6, L-11)** | MAJOR(컨버전) | **30 (의류 전체)** | clothes2025 | 단일 itemGroup 최대 사각. 단 컨버전 단계(현 미지원이라 day-1 비차단) |
| **9** | **L-12 ACC 부자재** | MAJOR(컨버전) | 미상(옵션레벨) | ACC | 컨버전 단계. 정확수 미상 |
| **10** | 에디터 EDIT분기·3액션 | MAJOR | 에디터 보유 상품(책자+편집상품) | 전반 | 재편집 흐름 |

### 핵심 재정렬 통찰
- **상품수 1·2·3위(BLOCKER)는 itemGroup 무관 광역** — 가격(전 479) > ATTB(후가공 수백) > COT_DFT(코팅 ~수십). gap-map의 "가격직결 우선"이 **상품수로도 정당화됨**.
- **의류 30**은 단일 itemGroup 최대 사각이나 **day-1 비차단**(현 미지원). itemGroup echo(#4)가 의류 컨버전의 게이트 — 의류 보정 전 itemGroup 분기부터.
- **L-3/L-4(ROU/END_PAP)는 book2025 후가공 보유분 한정** — 상품수는 BLOCKER보다 작음(~수십). 단 현 PRBKYPR로 발현 가능해 검증 즉시 가능.

---

## 5. 검증 메타 (회의적 점검)

- **정밀도 솔직 선언**: 카탈로그 4필드만으로 "정확히 N개 상품이 ROU_DFT를 쓴다"는 **산출 불가**. 본 맵은 **itemGroup 단위 노출 + 캡처 대표상품 검증 + 코드 분기 상한**의 3중 추정. "후가공별 정확 상품수"는 fabricate 안 함 — 추정범위/미상으로 표기.
- **vDigital 81% 집중**: universe의 압도다수가 단일면 디지털 — 우리가 캡처한 6 itemGroup(BC/ST/BN/AC/GS/HL)이 vDigital 핵심패턴(후가공·real_price·폐쇄래더)을 실제로 커버. **vDigital은 구조적으로 검증됨**. 잔여 갭은 후가공 부가의미(L-1/L-2)에 국한.
- **의류 6.3%·ACC 미상이 진짜 미지원** — gap-map의 "무증상"을 정량화하면 **의류 30이 명확한 최대 사각**, ACC는 정량 불가능한 구조적 사각.
- **BLOCKER가 상품수로도 1~3위** — S3는 itemGroup별 보정보다 **가격직결(전 상품 공통) 먼저**가 상품수 근거로도 옳음. gap-map §S3 우선순위와 **일치 확인**(상품수 재가중해도 순서 불변) → S3 우선순위 확정.
- **이 맵으로 못 푸는 것**: 상품별 정확 PCS 보유. 필요 시 S3 착수 전 의류 1개(CL*)·면지책자 1개 get_digital_product_info 추가 캡처로 의류·END_PAP baseline 확보 권고(트래픽가드 내 2회).
