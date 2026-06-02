# S6 캘린더 — 라이브 캡처 노트

**작성:** 2026-06-03 | **캡처 스크립트:** `raw/widget_monitor/local/s6-calendar-capture.cjs`
**산출 fixture(분석용):** `05_qa/captures/s6_cal_{HLCLSTD,HLCLWAL,TPCLWLB,GSCLMGN,TPCLECO}.json` + RAW 미러

---

## 1. 한 줄 결론

캘린더 SKU 5종을 widget_monitor 라이브 테스트베드로 캡처. **옵셋 캘린더(HLCLSTD·HLCLWAL)는 책자 PriceTable3D 변형이 라이브로 확정** — `ORD_INFO[0]` 구조가 책자/포스터와 **완전 동일**(PDT_CD/MTRL_CD/CUT·WRK_WDT·HGH/PRN_CNT/ORD_CNT/DOSU_COD/PRN_CLR_CNT). 캘린더 전용 옵션(시작연월·달력규격)은 **PCS_INFO 추가 행 = 기존 `select` componentType**로 흡수 → **신규 componentType 불요(NC 패턴 S4·S5 연속)**, **위젯 코어 0변경 예상**.

## 2. 캡처 결과 (5종)

| SKU | 이름 | 마운트 | price_gbn | PRICE(라이브) | 가격모델 판정 |
|-----|------|--------|-----------|---------------|--------------|
| **HLCLSTD** | [옵셋] 탁상용 캘린더 | 🟢 | `offset2023_price` | **778,500** | **PriceTable3D**(책자 변형) |
| **HLCLWAL** | [옵셋] 벽걸이 캘린더 | 🟢 | `offset2023_price` | **2,368,500** | **PriceTable3D**(책자 변형) |
| **TPCLWLB** | 큰 달력(효도 달력) | 🟢 | `vTmpl_price` | **11,900** | 템플릿가(S5 파우치 tmpl 계열) |
| GSCLMGN | 자석캘린더 | 🟢 | tiered_price | 0(미선택) | 굿즈 tiered(고정규격 347×470 + 디자인수 수량래더) — S5 굿즈 계열 |
| TPCLECO | 에코 캘린더 | 🟡 | — | — | **캡처 불가** — Red 상품 자체 미설정("달력 사이즈 설정이 필요합니다") |

## 3. 옵션 구조 (라이브 Shadow DOM 스키마)

**공통(책자형):** `paper / weight / dosu / sizes / PRN_CNT` select + `w·h-재단사이즈 / w·h-작업사이즈 / ORD_CNT` number — 책자/포스터와 동형.

**캘린더 전용(PCS_INFO 추가 행, select로 렌더):**
- HLCLSTD: `CLD_STD`(달력규격, PCS_DTL_COD=BK001) — select 6번째 항목
- TPCLWLB: `starting-year` / `starting-month` select → PCS `STA_CLD`(시작 연/월) + `PAK_POL`(포장) 매핑
- HLCLWAL: `RIN_CUT`(링컷)·`HOL_DFT`(타공) 등 후가공 PCS — 기존 후가공 select로 흡수

→ 캘린더 전용 옵션은 **전부 PCS_INFO 행**이며 위젯은 이를 `select` componentType로 렌더. **신규 leaf/dispatcher case 불요.**

## 4. 가격모델 검증 (ORD_INFO 정합)

```
HLCLSTD ORD_INFO[0]: {PDT_CD, MTRL_CD:RXRAU240, CUT_WDT:90, CUT_HGH:180,
                      WRK_WDT:94, WRK_HGH:184, PRN_CNT:500, ORD_CNT:1,
                      DOSU_COD:SID_D, PRN_CLR_CNT:8}   ← 책자/포스터 ORD_INFO와 필드 동일
```

- **신규 ORD_INFO 필드 0개** — 정규화 계약(`src/contract/`) 변경 불요.
- `price_gbn`(offset2023_price/vTmpl_price)은 어댑터에서 **불투명 echo(INV-1)** — 위젯은 값에 분기하지 않음(`red-adapter.ts:73 priceSchemeKey: opt.price_gbn`). 따라서 `offset2023_price`가 신규 문자열이어도 **위젯 코어 무관**. vTmpl_price는 S2/S5에서 기처리.
- 서버(쿠키 세션) 권위 가격 — 위젯 opaque 유지(불변식 1).

## 5. 미해결·주의 (은폐 금지)

- **GSCLMGN PRICE=0**: 자석캘린더는 고정규격(1개) + 디자인수 수량래더(16/116/216…) tiered. 스윕 스크립트가 수량래더 미선택 → 침묵 PRICE=0(기지 결함 재현). 굿즈 tiered는 S5에서 모델 확립됨 → S6 PriceTable3D 임계경로 아님. 필요 시 수량래더 선택 재캡처로 PRICE>0 확보 가능.
- **TPCLECO 캡처 불가**: Red 상품 마스터가 "달력 사이즈 설정" 미완(주문위젯 생성 실패). 우리 측 캡처 결함 아님 — Red 상품 config 공백. **미검증**으로 명시.
- **로그인 실가 정합**: 본 캡처는 쿠키 세션 로그인 실가(extract-cookies 갱신). 후니 비교 시 후니 PriceTable3D 실가와 대조 필요(현재는 Red baseline).

## 6. 다음 단계 (S4/S5 전례 파이프라인)

1. **hw-architect** — 어댑터 명세: 옵셋 캘린더(offset2023_price) fixture 추가 + CLD_STD/STA_CLD PCS 매핑 확인. 신규 componentType 불요 가설 검증. **위젯 코어 0변경 목표.**
2. **hw-builder** — fixture 적재(HLCLSTD/HLCLWAL product+price) + 어댑터 PCS 라우팅(필요 시), `src/widget/**` git diff 0줄 실증.
3. **hw-qa** — 비교 QA: 캡처 데이터 ↔ 구현 렌더 정합, INV-3(코어 불변) git diff 증명, 가격 round-trip.

> **임계경로 해소:** 핸드오프 §3-1의 "Red fixture 미보유" 차단 요인 제거됨 — 옵셋 캘린더 2종 PRICE>0 라이브 fixture 확보. S6 구현 무차단.
