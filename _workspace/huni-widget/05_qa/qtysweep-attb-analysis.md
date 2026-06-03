# Mission 1+2 — material-PCS ATTB scaling 분리 (D-1/W2-b) + 의류 PRICE>0 (G-5)

라이브 캡처 분석. testbed `localhost:3001`, RP 세션 신선(token-status ok). 전 산출물 redact 검증(JWT 0건).
모든 수치는 `get_ajax_price_vTmpl` reqBody/respBody **라이브 캡처**가 근거. `[라이브 검증]`.

---

## 핵심 발견 — respBody 가격 권위 정정 (HARD: PRICE=0 진단)

가격 응답 구조: `{retCode, result:[{PCS_CD, PRICE, PRICE_LOG, ...}], result_sum:{PRICE, PRICE_VAT, ...}}`

- **권위 가격 = `result_sum.PRICE`** (단일 출처). per-PCS `result[].PRICE`는 자재/코팅 등 번들 구성요소에서 0이 정상(예: GSTGMIC의 WRK_MTR/COT_DFT/PDT_WRK 라인은 모두 0, 실가격은 `PRT_DFT=66200` 라인 + `result_sum.PRICE=66200`).
- per-line PRICE를 읽으면 **거짓 PRICE=0**이 발생한다. 초기 추출기가 이 함정에 빠져 GSTGMIC를 PRICE=0으로 오판 → `result_sum.PRICE`로 교정 후 13,600/66,200원 정상 확인. **이것이 HARD 규칙(Red는 PRICE=0 불가)이 경고하던 바로 그 침묵 결함 벡터다.**

---

## 미션 1 — material-PCS ATTB scaling 판정 [라이브 검증]

### 판정: material-PCS(WRK_MTR/DIR_MTR) ATTB = **PRN_CNT(디자인 수/건수) echo**, ORD_CNT 아님

4개 상품 전수에서 동일 패턴. ORD_CNT는 상수 1로 고정, ATTB는 PRN_CNT 셀렉트(디자인 수/건수)를 그대로 따라간다. 가격은 ATTB(=건수)에 선형 비례.

| 상품 | PCS | size | PRN_CNT | ORD_CNT echo | material ATTB | result_sum.PRICE |
|------|-----|------|---------|--------------|---------------|------------------|
| GSTGMIC | WRK_MTR | 삼각마이크네임택L | 2 | 1 | **2** | 13,600 |
| GSTGMIC | WRK_MTR | 〃 | 10 | 1 | **10** | 66,200 |
| ACNTHAP | WRK_MTR | 중 75X25 | 2 | 1 | **2** | 6,600 |
| ACNTHAP | WRK_MTR | 〃 | 10 | 1 | **10** | 33,000 |
| GSPDLNG | DIR_MTR | (단일) | 2 | 1 | **2** | 32,000 |
| GSPDLNG | DIR_MTR | 〃 | 10 | 1 | **10** | 159,500 |
| GSTBMWM | DIR_MTR | (단일) | 2 | 1 | **2** | 90,000 |
| GSTBMWM | DIR_MTR | 〃 | 10 | 1 | **10** | 450,000 |

판정 근거:
- ATTB가 {2,10}로 PRN_CNT를 따라 **변한다** → 상수 아님. (상수였다면 1 고정이었을 것.)
- 단, 변하는 축은 **PRN_CNT(건수)**이며 **ORD_CNT는 1로 불변**. 굿즈/명함류 위젯의 "수량" UI는 ORD_CNT 숫자입력이 아니라 PRN_CNT 셀렉트(디자인 수/건수)로 구동된다. ORD_CNT 숫자입력은 존재해도 hidden(직접입력 모드)이라 기본 경로에서 변하지 않는다.
- PRICE는 ATTB 선형: GSTGMIC 2→10 = 13,600→66,200 (≈5배, 건수 5배), GSPDLNG 32,000→159,500, GSTBMWM 90,000→450,000(정확히 5배). 자재단가 × 건수 구조.

### 어댑터 보정 권고 (D-1/W2-b)

현 어댑터 `ATTB = String(req.quantity)`의 정당성은 **"quantity"가 무엇으로 매핑되는가**에 달려 있다.

- material-PCS(WRK_MTR/DIR_MTR)의 ATTB는 **건수(PRN_CNT/디자인 수)** 를 echo해야 한다. 사용자가 위젯에서 조작하는 "수량"이 이 굿즈류에서 PRN_CNT라면 → `req.quantity`가 PRN_CNT를 담고 있어야 정당하다.
- **검증 포인트:** 어댑터의 `req.quantity`가 (a) 위젯 ORD_CNT 입력값인지 (b) PRN_CNT 셀렉트값인지 확인하라. material-PCS 상품군에서는 (b)여야 한다. 만약 어댑터가 ORD_CNT(항상 1)를 ATTB에 넣고 있으면 **건수 가격이 항상 1건 단가로 고정되는 침묵 결함**이 된다 — 이 경우 보정 필수.
- ORD_INFO.ORD_CNT는 별도로 1 고정 echo(굿즈는 총 주문수량 1개 표기). ATTB와 분리 관리할 것.
- 권고: 어댑터에서 material-PCS ATTB ← 위젯의 건수/디자인수 상태(PRN_CNT), ORD_INFO.ORD_CNT ← 별도 주문수량(굿즈는 1). 두 축을 혼동하지 말 것. 이후 builder가 widget-store의 quantity 의미를 PRN_CNT로 정렬했는지 코드 대조 필요.

---

## 미션 1 — INN_DFT 미해결 (정직성: PRICE=0 = 우리측 결함신호) [미검증]

GSNTSPR(INNON 무지/줄노트), GSDRSKS(SKSTU)는 **판정 불가**. 사유:

- 이 노트류는 `gbn=tmpl_price`이며 ORD_INFO에 **ORD_CNT/PRN_CNT 필드 자체가 없다**(굿즈의 tiered_price와 다른 요청 shape).
- PRN_CNT 셀렉트는 존재하나 값이 비연속(1,6,11,16,...46) = **페이지 수(노트 장수)**, 주문수량 아님. `qty`는 별도 INPUT(주문수량).
- size/PRN_CNT/qty를 조작해도 **result_sum.PRICE=0**으로 회귀, INN_DFT.ATTB=1 또는 공백 고정. 기존 s3_rp_GSNTSPR 캡처도 동일하게 SUM=0이었다(과거에도 미해결).
- **HARD 정직성:** SUM=0은 Red 정상값이 아니라 **우리측 요청 shape/필수필드 결함 신호**다. INN_DFT의 ATTB가 상수인지 scaling인지 **0-가격 응답으로는 판정 불가** — 이 캡처를 근거로 INN_DFT를 상수로 단정하지 말 것.
- **잔존 진단 과제:** tmpl_price 노트류의 정확한 요청 필드(페이지수 매핑·필수 hidden essential·INN_DFT.PCS_DTL_COD 매칭)를 역공학 소스(editor_sdk/components)에서 확인 후 재캡처 필요. 현재 어댑터가 이 노트류를 어떻게 직렬화하는지 별도 검증 권고. **INN_DFT scaling은 미검증으로 유지.**

---

## 미션 2 — 의류 CLSTSHS PRICE>0 + G-5 [라이브 검증]

### 판정: 의류 가격 경로는 DIR_MTR을 **유지한다**(드롭하지 않음). PRICE>0 확보.

| mark | gbn | allPcs | hasDIR_MTR | DIR_MTR.PCS_DTL_COD | ATTB | result_sum.PRICE |
|------|-----|--------|-----------|---------------------|------|------------------|
| init | clothes2025_price | [PDT_WRK, DIR_MTR] | ✔ | SI014 | 1 | **19,900** |
| 직접인쇄 | clothes2025_price | [PDT_WRK, DIR_MTR] | ✔ | SI014 | 1 | 19,900 |
| size M | clothes2025_price | [PDT_WRK, DIR_MTR] | ✔ | **SI030** | 1 | 19,900 |

결론:
- **G-5 답변: 의류(apparel) clothes2025_price 경로는 pdt_pcs_info의 DIR_MTR을 PCS_INFO에 유지한다.** 드롭하지 않음. allPcs=`[PDT_WRK, DIR_MTR]`로 DIR_MTR 상시 포함.
- 사이즈 버튼(M) 선택 시 DIR_MTR.PCS_DTL_COD가 SI014→SI030로 변경 = **size-linked 자재 변형**이 정상 작동(사이즈별 원단/단가 매핑).
- 의류 가격 동등성 기준선 확보: CLSTSHS = **19,900원** (직접인쇄, M, clothes2025_price gbn).

### 의류 잔여 [미검증]
- 의류 ATTB=1 고정으로 관찰됐으나, 의류 수량은 **사이즈별 수량 그리드(스테퍼)** 로 입력되며 표준 number/text 입력 매칭으로는 구동 실패(`order-subject`만 매칭). 따라서 의류에서 ATTB가 수량을 echo하는지는 **이번 캡처로 미확정** — 사이즈별 수량 그리드 조작 후 재캡처 필요. 단, G-5(DIR_MTR 유지)와 PRICE>0 기준선은 확정.

---

## 산출 파일

- `05_qa/captures/qtysweep_GSTGMIC.json` (WRK_MTR, PRICE 13,600/66,200)
- `05_qa/captures/qtysweep_ACNTHAP.json` (WRK_MTR 아크릴, 6,600/33,000)
- `05_qa/captures/qtysweep_GSPDLNG.json` (DIR_MTR, 32,000/159,500)
- `05_qa/captures/qtysweep_GSTBMWM.json` (DIR_MTR, 90,000/450,000)
- `05_qa/captures/qtysweep_GSNTSPR.json` (INN_DFT, SUM=0 미해결·진단)
- `05_qa/captures/qtysweep_GSDRSKS.json` (INN_DFT, SUM=0 미해결·진단)
- `05_qa/captures/clstshs_price.json` (의류 G-5, 19,900·DIR_MTR 유지)

모두 직렬화 출력 전체 redact 적용(respBody Edicus JWT echo 방지). 커밋 전 JWT grep 0건 확인.

## 정직성 요약 (은폐 없음)
- 확정: WRK_MTR·DIR_MTR ATTB = 건수(PRN_CNT) echo, ORD_CNT 불변, PRICE 선형 (4상품).
- 확정: 의류 DIR_MTR 유지 + PRICE 19,900원.
- 미해결: INN_DFT 노트류(GSNTSPR/GSDRSKS) — tmpl_price SUM=0(우리측 요청 shape 결함 의심), scaling 판정 불가.
- 미확정: 의류 ATTB↔수량 관계(사이즈별 수량 그리드 미조작).
