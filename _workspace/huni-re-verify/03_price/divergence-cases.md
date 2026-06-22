# divergence-cases.md — 신규 14필드(6월) 발산 최소반례

> 오라클 = 라이브 RedPrinting 신규필드 골든(`02_golden/captures/new-fields-260623/`).
> 발산 = 재구성 `serializeRedPriceRequest` emit reqBody vs 골든 reqBody(라이브 실측). 라이브가 옳다.
> 무날조: 모든 값은 골든 JSON verbatim + 어댑터 파일:라인. 4월 D1/D2/D3(ATTB·책자)는 `_prev/`.

---

## 발산 1 — N1: ADD_CLR_YN 미전송 (HIGH · 28셀)

최소반례 (NF-ORDCNT_NCCDDFT.json:41, ORD_CNT=1 baseline):

```
라이브 golden ORD_INFO[0]:
  { ... "PRN_CNT":500, "ORD_CNT":1, "DOSU_COD":"SID_S",
    "PRN_CLR_CNT":4, "ADD_CLR_YN":"N", "REAM_CNT":0 }

재구성 emit ORD_INFO[0] (serializeRedPriceRequest):
  { PDT_CD, CUT_WDT, CUT_HGH, WRK_WDT, WRK_HGH, ORD_CNT,
    PRN_CNT, PRN_CLR_CNT, MTRL_CD }
  → ADD_CLR_YN: (부재, emit=undefined)
```

근본: 3층 슬롯 부재.
- 계약 `src/contract/price.ts:24` NormalizedPriceRequest 에 ADD_CLR_YN 슬롯 없음.
- `red-types.ts:166` RedPriceReqOrdInfo 에 ADD_CLR_YN 필드 없음.
- `red-adapter.ts:580` serialize 에 ADD_CLR_YN set 없음.

라이브 가격 영향: NF-ADDCLR 골든상 현 자재(RXSNO250)/도수(SID_S 4·SID_D 8) 선에서는 Y/N 가격불변(12700·15900, MR-6 negative) → 현 inert. 단 ADD_CLR 가격발현 상품선이 있으면 누락=오가격 잠복 → codex deob 확인(쟁점 1).

---

## 발산 2 — N2: REAM_CNT 미전송 (MED · 28셀)

최소반례 (NF-REAMCNT_NCCDDFT.json, REAM_CNT 스윕 0/1/2):

```
라이브 golden: ORD_INFO[0].REAM_CNT = 0 / 1 / 2  (PRICE 12700 전부 동일)
재구성 emit  : REAM_CNT 부재(슬롯없음)
```

근본: N1 과 동일 3층 슬롯 부재.
라이브 가격 영향: 현 PRN_CNT 가 수량권위라 REAM_CNT 단독 무영향(MR-7 acceptance). 단 REAM_CNT 가 PRN_CNT 대체(연→매수)모드인 상품이 있으면 그 상품군 수량/가격 전체 누락 → codex 확인(쟁점 2).

---

## 발산 3 — N3: 수량모델 A(래더) 미구현 (MED · 1셀)

최소반례 (NF-ACCEPTANCE_NCCDDFT.json "수량모델A ladder(MIN_ORD/ADD_ORD/INC)"):

```
라이브 golden: ORD_INFO[0] 에 MIN_ORD_PRN_CNT + ADD_ORD_PRN_CNT(+INC) (acceptance — PRICE 12700 보존)
재구성       : 모델 A 산술계열 생성 코드·필드 전무
              (buildQuantityRule/prnCntLadder = 모델 B 행기반만, red-adapter.ts:279-305)
```

근본: 재구성은 모델 B(폐쇄 래더 enum + FIR/INC/STEP counter)만. 모델 A(`PRN_CNT=MIN+ADD×h`, PDT_VER_SIZE 굿즈)는 미구현.
가격 영향: NCCDDFT 는 모델 A 미바인딩·노출상품 미가용(acceptance only) → 가격함수 미검증(보드 §4 미검증 셀).

---

## 발산 4 — N4: PACK_PRN_CNT / MAX_PRN_CNT 미전송 (LOW · 2셀/1셀)

최소반례 (NF-ACCEPTANCE_NCCDDFT.json "PACK_PRN_CNT=100" / "MAX_PRN_CNT=10000"):

```
라이브 golden: ORD_INFO[0].PACK_PRN_CNT=100 / MAX_PRN_CNT=10000  (PRICE 12700 보존)
재구성       : 두 필드 부재(슬롯없음)
```

근본: 계약·types·serialize 슬롯 부재. 라이브 PRICE 보존(NCCDDFT 미바인딩) — full sweep 미캡처(price-engine-additions §5 미확정).

---

## 발산 5 — N5: DOSU_COD 의도 omit (LOW · 4월기존 · 5셀)

최소반례 (NF-TIERED-MODELB_GSTGMIC.json, PRN_CNT 스윕):

```
라이브 golden: ORD_INFO[0].DOSU_COD = "SID_S"
재구성       : DOSU_COD 의도 omit (red-adapter.ts:569 OPEN-1)
```

★신규필드 아님 — 4월 골든 전부 보유(golden_AIPPCUT/GSNTSPR/GSPUFBC/GSTGMIC/STPADPN 전부 DOSU_COD 존재). 4월 검증서 의도 omit 판정 완료(PRN_CLR_CNT 가 도수 가격의미 운반 → 4월 VP-2 가격동일 PASS). 가격영향 없음. 본 신규필드 차원에서는 잔존 기존 항목으로 분류(돈영향 0).

---

## 비-발산 (재구성이 옳게 처리하는 것)

| 항목 | 판정 | 근거 |
|------|------|------|
| result_sum.PRICE/VAT 매핑(VP-2 응답측) | 정합 | 33셀 mapPriceResponse.finalPrice==golden.PRICE. 워터폴 평면화 정확 |
| per-line 0 무시(VP-4) | 정합 | NF-ORDCNT perLine[0].PRICE=0(번들) 무시, result_sum 만 읽음 |
| PRICE!=0 sanity(VP-3) | 정합 | 정상경로 33셀 전부 >0. 어댑터 ok 게이트(finalPrice>0) 유지 |
| 메타모픽 MR-1~4·6~8 | 정합 | 라이브 시퀀스 단조/관계 성립(ORD_CNT 선형·PRN_CNT 단조·FLD_DFT +가격) |
| 수량모델 B UI 그룹 생성 | 부분정합 | 폐쇄 래더 enum + FIR/INC counter 구현. 단 가격요청 REAM_CNT 누락(N2) |

---

## MR-5 메타모픽 정의 노트 (재구성 결함 아님)

`metamorphic-relations.json` MR-5 sequence = HOL_DFT 16800 / ROU_DFT 16200 / MIS_DFT 18200 / OSI_DFT 18200.
이들은 **서로 다른 후가공 종류**라 "수량 단조"가 부적용(16800→16200 역전은 종류차이지 위반 아님).
올바른 관계 = "각 후가공 PRICE > baseline 12700"(전부 성립). 본 발산은 메타모픽 **검사식 정의** 문제 →
Phase 5 게이트가 검사식을 "baseline 초과"로 정정 권장. 재구성/라이브 발산 아님.
