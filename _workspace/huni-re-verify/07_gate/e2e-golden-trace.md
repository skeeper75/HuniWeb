# e2e-golden-trace.md — 종단 골든 추적 (옵션선택→reqBody→라이브응답→재구성)

> ⚠️ **정정(corrigendum, remediation-verify.md 재실측):** 아래 "538,000 / 1.14M / 3.01M" 및 "ladder qty 20/30/50"은
> **ORD_CNT sweep** 값(ORD_CNT=20 × 단가 26,900 = 538,000)이며 PRN_CNT 래더 가격이 아니다. PRN_CNT 래더(20/30/…/110)
> 자체 가격은 26,900/38,000/…/123,700(단조). **측정 차원 라벨만 정정**, N3 결함·견적불가 결론은 라이브 재현으로 유효.

> 대표 1건: **TPBLMEO(떡메/메모블록) 80×80 SID_S — 수량모델 A 래더(N3)**. 신규필드 누락이 라이브 가격을 직접 발산시키는(돈크리티컬·견적불가) 케이스라 선정.
> 오라클 = 라이브 RedPrinting(via server.js :3001 read-only get_ajax_price_vTmpl). verify-gate가 직접 read-only POST·재구성 함수 직접 대조.
> 4월분(GSNTSPR ATTB 추적)은 `_prev/260623-april-baseline/07_gate/e2e-golden-trace.md`.

---

## ① 옵션 선택 (사용자 의도)
떡메 TPBLMEO / 자재 RXWMO080 / 재단 80×80(작업 84×84) / 도수 SID_S(4도) / 사이즈 PDT_VER_SIZE=10.00mm → **수량옵션은 모델A 래더에서 생성**: PRN_CNT = MIN_ORD_PRN_CNT(20) + ADD_ORD_PRN_CNT(10)×h → {20, 30, 40, 50, ...}. 사용자가 래더에서 50매 선택.

## ② reqBody 조립 (재구성 serializeRedPriceRequest vs 라이브)

| 필드 | 라이브 위젯(deob 동형) | 재구성 emit | 정합 |
|------|------------------------|-------------|:----:|
| 수량옵션 생성(모델A 래더) | `pdt_add_option_info`(PDT_VER_SIZE=10, MIN_ORD=20, ADD_ORD=10) → 래더 [20,30,40,50,...] (deob L15432-15445·L19664·L19729) | **부재** — buildQuantityRule(red-adapter.ts:279)은 모델B(`pdt_prn_cnt_info`)만, MIN_ORD_PRN_CNT/ADD_ORD_PRN_CNT 슬롯 0 | ❌ **N3 발산(견적불가)** |
| ORD_INFO[0] PRN_CNT(선택 50) | 50(래더값) | (래더 미생성 → 50을 만들 경로 없음) | ❌ 발산 |
| ORD_INFO[0] PDT_CD/MTRL_CD/CUT/WRK/ORD_CNT/DOSU_COD/PRN_CLR_CNT | TPBLMEO/RXWMO080/80·80/84·84/50/SID_S/4 | (PRN_CNT 외 형상은 어댑터 580-590 산출 가능) | △ 부분 |
| ADD_CLR_YN / REAM_CNT / PACK_PRN_CNT | "N" / 0 / 100 | 슬롯 부재(N1/N2/N4) | ❌ 발산 |

**발산 지점:** ②의 수량옵션 자체 — 재구성은 모델A 래더를 생성할 코드·슬롯이 없어 떡메의 수량옵션(PRN_CNT 후보)을 만들지 못함. 사용자가 선택할 수량이 없음 = **견적 진입 불가**.

## ③ 라이브 응답 (verify-gate 직접 read-only POST, 2026-06-23)
```
TPBLMEO 80×80 SID_S, PCS_INFO=[PRT_SID/PT001], PACK_PRN_CNT=100, price_gbn=tmpl_price:
  ladder qty 20 (h=0) → retCode 200, result_sum.PRICE = 538,000
  ladder qty 30 (h=1) → retCode 200, result_sum.PRICE = 1,140,000
  ladder qty 50 (h=3) → retCode 200, result_sum.PRICE = 3,010,000
```
모델A 래더 수량이 라이브 가격을 **단조 증가**시킴(538k→1.14M→3.01M). 즉 래더 수량은 실 가격경로(get_ajax_price_vTmpl)에 도달하는 돈크리티컬 차원.

## ④ 재구성 응답 (mapPriceResponse는 정상이나 진입 불가)
```
mapPriceResponse(result_sum) 워터폴 평면화 자체는 정상(538000→finalPrice 538000).
그러나 ②에서 래더 수량옵션을 못 만들어 사용자가 50매를 선택할 수 없음 →
이 상품군은 견적 화면 진입/수량선택이 불가(NO-QUOTE).
```

## 종단 결론
- **발산 지점 명시:** 응답 평면화(mapPriceResponse)는 정합. **발산은 reqBody 조립 이전 — 수량모델A 래더 미구현(N3)이 옵션 생성 단계에서 발산**. 재구성은 떡메/PDT_VER_SIZE형 굿즈의 수량옵션을 생성하지 못함.
- **돈 영향:** 라이브 538k~3.01M 차등 직접 비준 = 모델A 수량은 가격을 좌우. 재구성 미구현 = 해당 상품군 **견적불가**(저청구가 아니라 견적 자체 불가).
- **판정:** V-PRICE NO-GO 사유 중 N3가 가장 심각(HIGH·견적불가·라이브 비준). N1(추가색 저청구·소스확정)·N6(×10 저청구 잠복)이 뒤따름.

> 보강 직접 측정: R2 baseline NCCDDFT offset2023 PRN500 → 라이브 12,700(§3 표 6,350,000=×500 스케일 아티팩트 확정·인용금지). N1 라이브 NCCDDFT/RXSNO250 ADD_CLR_YN Y/N × PRN_CLR_CNT 4/6 = 전부 12700(이 자재 inert·발현 자재상품 미식별).
