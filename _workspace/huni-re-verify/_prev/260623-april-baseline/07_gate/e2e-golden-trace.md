# e2e-golden-trace.md — 종단 골든 추적 (옵션선택→reqBody→라이브응답→재구성)

> 대표 1건: **GSNTSPR(스프링노트) ORD1·PRN1** (G-ATTB, tmpl_price). ATTB 타입 다형이 드러나는 케이스라 선정.
> 오라클 = 라이브 RedPrinting(get_ajax_price_vTmpl, 읽기전용). verify-gate가 직접 재요청·재구성 함수 직접 실행.

---

## ① 옵션 선택 (사용자 의도)
스프링노트 / 자재 RIBVW350 / 재단 182×257 / 도수 SID_S(4도) / 링색 RIN_BLK / 반경 4귀(rou4) / 주문1·인쇄1.

## ② reqBody 조립 (재구성 serializeRedPriceRequest 출력 ↔ 골든 라이브)

| 필드 | 재구성 emit | 라이브 골든 | 정합 |
|------|-------------|-------------|:----:|
| ORD_INFO[0] PDT_CD/CUT/WRK/PRN_CNT/ORD_CNT/DOSU/PRN_CLR_CNT | 동일 | 동일 | ✅ |
| PCS INN_DFT.ATTB (quantity-echo) | **"1" (string)** | **1 (number)** | ❌ **D1 발산** |
| PCS RIN_DFT.ATTB (링색 속성칩) | "RIN_BLK" (string) | "RIN_BLK" (string) | ✅ |
| PCS ROU_DFT.ATTB ×4 (반경 속성칩) | "4" (string) | "4" (string) | ✅ |
| PCS COT_DFT/CUT_DFT.ATTB (미echo) | "" | "" | ✅ |
| price_gbn / mb_cust_cod | tmpl_price / 10000000 | 동일 | ✅ |

**발산 지점:** INN_DFT(quantity-echo) ATTB만 타입 불일치(string vs number) — D1. 속성칩(RIN/ROU)은 string이 정상이라 정합. **이것이 codex 신규발굴(타입 다형)의 실증** — 어댑터는 수량형을 String()으로 잘못 직렬화, 속성칩은 옳게 보존.

## ③ 라이브 응답 (verify-gate 직접 재요청, 2026-06-23)
```
retCode 200
result_sum {"PRICE":6300,"PRICE_VAT":630,"PRICE_MALL":6300,"PRICE_MALL_VAT":630,"ORG_PRICE":6300,"ORG_PRICE_VAT":630}
perLine [COT_DFT:0, CUT_DFT:0, INN_DFT:0, RIN_DFT:0, ROU_DFT:0×4, PRT_DFT:6300]
```
ATTB-운반 PCS는 per-line PRICE=0(가격 미운반), 가격은 **PRT_DFT 6300 = result_sum.PRICE 권위**. → D-L1 입증(ATTB=echo 전용·가격 불변) 라이브 직접 재현.

## ④ 재구성 응답 (mapPriceResponse 직접 실행)
```
입력 result_sum(위 ③) → 워터폴: PRICE_MALL===PRICE && ORG_PRICE===PRICE → finalPrice=ORG_PRICE=6300
출력 {"ok":true,"finalPrice":6300,"vat":630}
```

## 종단 결론
- **가격값(돈) 종단 정합:** 라이브 result_sum.PRICE 6300 == 재구성 finalPrice 6300. ✅ (VP-2/VP-4 종단 GO)
- **reqBody shape 발산:** ②의 INN_DFT.ATTB 타입(string≠number) 1건 — D1. ❌ (VP-1 NO-GO 사유)
- **정합/발산 지점 명시:** 가격 결과는 완전 정합, **직렬화 byte shape의 quantity-echo ATTB 타입에서만 발산**. 돈 영향은 미확정(echo 전용·단가 불변 입증)이나 byte 발산 확정 → V-PRICE NO-GO.

> 추가 라이브 strict 재생 8케이스(AIPPCUT 3300·GSTGMIC 13600/631800·GSNTSPR 6300/63000·PRBKYPR 6100/8300, ATTB불변 RIN_GLD→6300) 전부 골든 권위 일치 — `07_gate/scripts/vp2-live-replay.cjs`.
