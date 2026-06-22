# divergence-cases.md — VP-1 직렬화 발산 최소반례 (재구성 vs 라이브 골든)

> 오라클 = 라이브(라이브가 옳다). emit = §6 `serializeRedPriceRequest` 출력. live = `02_golden/captures/golden_*.json` reqBody verbatim.
> 추출기: `03_price/scripts/divergence-extract.test.ts` (전 골든 케이스 reqBody emit↔live 키 단위 diff).
> 재현: `cd _workspace/huni-widget/04_build && ./node_modules/.bin/vitest run --config ../../huni-re-verify/03_price/scripts/vprice-diverge.config.mts`

---

## D1 — PCS_INFO ATTB 타입 발산 (string vs number) · HIGH · 18셀

**증상:** quantity-echo PCS(SUB_MTR/WRK_MTR/INN_DFT)의 ATTB 를 어댑터가 **string** 으로, 라이브는 **number** 로 직렬화.

```
[G-RP/AIPPCUT :: base ORD1 PRN1]     PCS[0].ATTB (SUB_MTR): emit="1"(string) live=1(number)
[G-RP/AIPPCUT :: mtrl variant EC002] PCS[0].ATTB (SUB_MTR): emit="1"(string) live=1(number)
[G-TD/GSTGMIC :: PRN_CNT=1]   PCS[0].ATTB (WRK_MTR): emit="1"(string)   live=1(number)
[G-TD/GSTGMIC :: PRN_CNT=2]   PCS[0].ATTB (WRK_MTR): emit="2"(string)   live=2(number)
[G-TD/GSTGMIC :: PRN_CNT=5]   PCS[0].ATTB (WRK_MTR): emit="5"(string)   live=5(number)
[G-TD/GSTGMIC :: PRN_CNT=10]  PCS[0].ATTB (WRK_MTR): emit="10"(string)  live=10(number)
[G-TD/GSTGMIC :: PRN_CNT=30]  PCS[0].ATTB (WRK_MTR): emit="30"(string)  live=30(number)
[G-TD/GSTGMIC :: PRN_CNT=100] PCS[0].ATTB (WRK_MTR): emit="100"(string) live=100(number)
[G-ATTB/GSNTSPR :: (전 10 호출)] PCS[2].ATTB (INN_DFT): emit="1"(string) live=1(number)
```

**라이브 권위 인용(무날조):**
- `golden_AIPPCUT_real.json:42` → `"ATTB": 1` (JSON number)
- `golden_GSTGMIC_tiered.json:120` → `"ATTB": 2` (JSON number)
- ★§6 자체 캡처 `05_qa/captures/b1_AIPPCUT.json` reqBody → SUB_MTR `ATTB` = JSON int `1` (python `json.load` 로 `type:int` 독립 확인)

**근본원인(§6 위치):** `red-adapter.ts:615`
```
ATTB: f.attb ?? (isQuantityEchoPcs ? String(req.quantity) : ''),
```
`String(req.quantity)` 가 number → string 변환. 역구성 경로(f.attb 제공)에서도 `String(p.ATTB)` 운반이지만, **자연 store 경로(f.attb 미보유)에서도 동일하게 string** 출력(어댑터가 항상 String()). 즉 타입 발산은 입력 무관·어댑터 고정 결함.

**JSON 와이어 영향:** `"ATTB":"1"` vs `"ATTB":1` — byte 단위 다름. routeFromHAR strict POST-payload 매칭이면 즉시 FAIL.

**돈 영향:** 미확정. ATTB 값(2,10…)은 정확하고 D-L1 입증대로 ATTB 는 가격에 echo 전용(단가 불변). Red 서버가 string `"2"`를 number 2로 강제 파싱하면 무해(LOW), key 매칭/타입 엄격이면 가격경로 영향(HIGH). **read-only 라 변형 POST 미수행 → 라이브 관용도 미확정**. Phase 4 codex 가 deob ATTB 소비코드(parseInt/Number 여부)로 판정 권장.

**교정 제안(§6 위임 · verify-gate 승인경로):** `String(req.quantity)` → `req.quantity`(number 유지). f.attb echo 도 number 보존 필요(현 SelectedFinish.attb=string 타입이라 계약 시그니처까지 검토 — attb 다형이 number/string 양립).

---

## D2 — 책자 reqBody 에 PRN_CLR_CNT 발명 · MED · 3셀

```
[G-BK/PRBKYPR :: A5 PAGE24 INN_CLR1]  ORD.PRN_CLR_CNT: emit=4(number) live=undefined
[G-BK/PRBKYPR :: A5 PAGE48]           ORD.PRN_CLR_CNT: emit=4(number) live=undefined
[G-BK/PRBKYPR :: A5 PAGE100 INN_CLR4] ORD.PRN_CLR_CNT: emit=4(number) live=undefined
```

**라이브 권위:** `golden_PRBKYPR_book.json:24-37` ORD_INFO 에 PRN_CLR_CNT 부재(책자는 CVR_CLR_CNT/INN_CLR_CNT 만).

**근본원인:** `red-adapter.ts:588` `PRN_CLR_CNT: req.colorCounts.default` 를 `if (isBook)` 분기 **이전** 무조건 set → 책자에도 단일면 색수 누출.

---

## D3 — 책자 reqBody 에 MTRL_CD 발명 · MED · 3셀

```
[G-BK/PRBKYPR :: A5 PAGE24 INN_CLR1]  ORD.MTRL_CD: emit="RXART300"(string) live=undefined
[G-BK/PRBKYPR :: A5 PAGE48]           ORD.MTRL_CD: emit="RXART300"(string) live=undefined
[G-BK/PRBKYPR :: A5 PAGE100 INN_CLR4] ORD.MTRL_CD: emit="RXART300"(string) live=undefined
```

**라이브 권위:** `golden_PRBKYPR_book.json:24-37` ORD_INFO 에 MTRL_CD 부재(책자는 CVR_MTRL_CD/INN_MTRL_CD 만).

**근본원인:** `red-adapter.ts:589` `MTRL_CD: req.materials.default` 를 `if (isBook)` 분기 이전 무조건 set.

**D2/D3 교정 제안(§6 위임):** line 580-590 의 단일면 필드(MTRL_CD/PRN_CLR_CNT)를 `if (!isBook)` 가드 하에만 set(책자는 CVR_/INN_ 만). §6 책자 serialize 테스트에 "단일면 필드 부재" 어서션 추가(현 테스트는 분리필드 존재만 검사).

---

## 발산 없음 확인 (PASS 시나리오)
- **G-FU/STPADPN, G-TM/GSPUFBC**: 전 필드(ORD_INFO 9 + PCS + price_gbn + mb_cust_cod) 정합. ATTB 가 전부 `''`(echo 대상 PCS 부재 — CUT_DFT/PRT_WHT/PDT_WRK/FLX_ZIP)라 D1 미발생.
- 가격값(result_sum) 발산은 **전 시나리오 0**(VP-2 PASS) — 발산은 reqBody shape 한정.

---

## 발산 요약
| 분류 | 셀 | 심각도 | 가격값 영향 | shape 영향 |
|------|----|--------|-------------|-----------|
| D1 ATTB 타입 | 18 | HIGH | 미확정(echo) | 확정(byte) |
| D2 PRN_CLR_CNT 발명 | 3 | MED | 미확정 | 확정 |
| D3 MTRL_CD 발명 | 3 | MED | 미확정 | 확정 |
| **합계 발산** | **24 어서션 / 20 테스트셀** | — | result_sum 발산 0 | reqBody 발산 24 |
