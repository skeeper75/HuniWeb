# reconcile.md — Phase 4 codex(high) 독립 2차 교차검증 reconcile (가격 파일럿)

> codex: **AVAILABLE** model=gpt-5.5, model_reasoning_effort=high, sandbox=read-only, RC=0, tokens 79,195.
> workdir=/Users/innojini/Dev/HuniWeb(repo root, Claude 판정 비노출 — vprice-board.md 미지목).
> 입력 codex가 직접 grep/nl: red-adapter.ts·deob_05/06/07·mod_05/06/07·golden_*.json.
> 산출: 06_codex/price-prompt.txt·price-verdict.txt(verbatim)·이 파일.
> [HARD] codex 주장=가설. 아래 모든 codex 인용은 Claude가 원본 grep으로 재확인함(환각 0).

---

## 0. 종합

| 쟁점 | codex 판정 | Claude(Phase 3) | reconcile |
|------|-----------|------------------|-----------|
| **D1 ATTB 타입** | quantity-echo PCS는 number(Red 소스·골든 둘 다), string `"N"` emit은 발산 | HIGH(발산 확정·돈영향 미확정) | **합의(고신뢰) + codex 신규 정밀화**. 심각도=아래 §1 |
| **D2/D3 책자 잉여필드** | Red book 경로는 split-only(CVR_/INN_), PRN_CLR_CNT·MTRL_CD top-level 부재. 잉여시 무시 vs 오염=소스로 판정 불가 | MED(발산 확정·관용 미확정) | **합의**. 관용도는 양쪽 다 미확정(라이브 변형 POST 필요) |
| **VM-3 인용 실재성** | red-adapter.ts:615/588/589/151 전부 REAL. 자기인용 mod_07:2586/2467은 ATTB 아님(부존재 인용) | 보드도 동일 적시(W1-c) | **합의**. 날조 0 — G-1 선례형 결함 없음 |
| **신규 발굴** | ★골든 GSNTSPR 자체가 ATTB **mixed**(INN_DFT=int 1 / ROU_DFT=str "4" / RIN_DFT=str "RIN_BLK") | 보드 미명시(D1을 "live=number" 단일로 서술) | **불일치→Claude 재실측으로 codex 승**(아래 §3) |

---

## 1. D1 — 합의 + codex 정밀화 (심각도 codex 판정: **HIGH 유지**, 단 범위 한정)

**합의 핵심:** quantity-echo PCS(INN_DFT/WRK_MTR/SUB_MTR/DIR_MTR)의 ATTB는 Red 측에서 **수량(number)** 으로 구성된다. codex가 Red 소스에서 독립 적발:
- `deob_06_app_widget_sdk.js:1250` `ATTB: orderData?.quantityInfo.prnCnt` (number)
- `deob_07_app_components.js:1008` `ATTB: materialMap[code].quantity` (number)
- `mod_07:2470` `ATTB: n.relatedData.orderQty`, `mod_07:2597` `ATTB: r.value ? u.value : orderQty` (number)
- `mod_05:2580`/`deob_06:1250` KOI 재계산 경로 `ATTB: prnCnt` (number)
→ **Claude grep 재확인 전부 실재**(price.err·verdict 본문 라인 일치).

**골든 권위(Claude 재실측):** quantity-echo는 number — `golden_GSTGMIC_tiered.json` WRK_MTR ATTB=int `1/2/5/10/30/100`; `golden_GSNTSPR_attb.json` INN_DFT ATTB=int `1`; `golden_AIPPCUT_real.json` SUB_MTR ATTB=int `1`. **어댑터는 `String(req.quantity)` → "1"/"2"… string** (red-adapter.ts:615). 즉 quantity-echo 경로에서 어댑터 emit=string ≠ live=number → **byte 발산 확정**.

**codex의 D1 심각도 입장:** "sending `"2"` vs `2` is undeterminable from Red client code" — Red 소비측에 parseInt/Number/+ATTB 강제 **없음**(codex grep, Claude 재확인: deob/mod 어디에도 ATTB 숫자강제 부재). ATTB의 `===` 비교는 **자기 emit 객체끼리**(mod_07:2473·3575 dedup용)일 뿐 서버 수신 파싱 아님. → **number 강제 관용 근거 없음 = D1을 LOW로 강등할 코드 근거 없음**. 동시에 거부 근거도 코드엔 없음(서버측 PHP 미보유). 

**결론(reconcile):** **D1 = HIGH 유지**. 강등(LOW) 트리거였던 "Red가 number 강제 파싱"은 **codex+Claude 양쪽 다 코드에서 못 찾음** → 강등 불가. byte 발산 확정 + 관용 근거 부재이므로 보수적으로 HIGH 유지가 정당. 단 **돈 영향은 여전히 미확정**(D-L1대로 ATTB는 가격 echo 전용, 단가 불변 입증됨 → 가격 오류 가능성은 낮음). 라우팅: §6 교정(`String(req.quantity)`→`req.quantity`) + Phase 5가 라이브 변형 POST 관용도만 미확정으로 명기.

---

## 2. D2/D3 — 합의 (관용도 양쪽 미확정)

codex가 Red 소스에서 book 분기를 독립 적발: `mod_05:1859-1870` book2025_item 경로는 `CVR_CLR_CNT/INN_CLR_CNT/CVR_MTRL_CD/INN_MTRL_CD`(split-only), `mod_05:1871-1881` 비책자 경로만 `MTRL_CD`+`PRN_CLR_CNT`. deob_06:1046~/1174~도 동형. **Claude 재확인: 일치**. 골든 `golden_PRBKYPR_book.json:23-37` ORD_INFO = split 필드만, PRN_CLR_CNT·top-level MTRL_CD **부재**(codex+Claude 일치).

어댑터는 PRN_CLR_CNT(:588)·MTRL_CD(:589)를 `if(isBook)` **이전** 무조건 set → 책자에 누출(D2/D3 확정). codex: "ignored vs mis-consumed는 이 파일들로 판정 불가"(서버 핸들러 미보유). → **MED 유지, 관용도 미확정**. 라우팅: §6 교정(`if(!isBook)` 가드) + Phase 5가 잉여필드 라이브 관용/오염 여부만 미확정 명기. (오염시=책자 표지색 돈크리티컬이므로 verify-gate가 우선순위로 표기 권장.)

---

## 3. codex 신규 발굴 (Claude 재실측으로 확증) — D1 서술 정밀화 필요

★codex가 골든 `golden_GSNTSPR_attb.json`에서 ATTB **mixed**를 적발(verdict Q5 + grep L1287-1342). Claude python 재실측 결과 **PCS_COD축으로 타입이 갈림**:
- `INN_DFT`(quantity-echo) → ATTB = int `1`
- `WRK_MTR`(quantity-echo) → ATTB = int `1/2/5/…`
- `RIN_DFT`(링색 속성칩) → ATTB = str `'RIN_BLK'`
- `ROU_DFT`(반경 속성칩) → ATTB = str `'4'` (★숫자처럼 보이나 string)
- echo 대상 아님(COT_DFT/CUT_DFT/PDT_WRK/PAK_POL/THO_CUT) → ATTB = str `''`

**의미:** Phase 3 보드 D1이 "live(골든)=number"로 단일 서술한 것은 **quantity-echo 한정으로 좁혀야 정확**. 라이브 ATTB는 *타입 다형*: 수량형=number, 속성칩=string(숫자형 '4'도 string), 미echo=''. 어댑터의 D1 결함은 정확히 **수량형에서만** number→string 오변환(`f.attb` 분기는 속성칩 string을 보존하므로 그쪽은 정상). 이는 D1을 **무효화하지 않고 오히려 확증**(수량형 number 권위가 골든에 명백). 단 §6 교정 시 `String(req.quantity)`→`req.quantity`(number)는 quantity-echo 분기에만 적용해야 하고 `f.attb`(속성칩) string 경로는 건드리면 안 됨 — codex 발굴이 교정 범위를 정밀화.

**라우팅:** divergence-cases.md/vprice-board.md D1 서술에 "live=number는 quantity-echo PCS 한정, 속성칩 ATTB는 string이 정상" 1줄 보강 권장(인스펙터 hrev-price-equivalence). 교정 시그니처(attb 다형 number|string)는 보드가 이미 인지(D1 교정 제안 L40).

---

## 4. false-positive 검토

codex Q5: 요청 범위 내 추가 shape 불일치 "none found", D1/D2/D3 중 false-positive도 없음. Claude 동의 — 세 결함 모두 골든+Red소스 양면 근거로 실재. VP-2(가격값) 발산 0은 codex 범위 밖(라이브 server.js 독립 차등은 미수행 — codex는 read-only 오프라인 추론자라 라이브 POST 불가, 이는 Phase 5 verify-gate 몫).

---

## 5. VM-2 입력 (verify-gate Phase 5 행)

- **codex 가용**: AVAILABLE gpt-5.5 high (pending 아님).
- **합의율**: 핵심 3쟁점(D1 number-typing·D2/D3 split-only·VM-3 실재성) **전부 합의**. 불일치 1건(D1 live 타입 단일 서술)은 Claude 재실측으로 codex 승(보드 서술 정밀화 항목, 결함 무효 아님).
- **codex 신규 1건**: 골든 ATTB mixed(PCS_COD축 타입 다형) — 확증됨, D1 교정 범위 정밀화.
- **날조 0**: codex 인용 전수 Claude grep 재확인 통과. 자기인용 부존재(mod_07:2586/2467)는 보드가 이미 W1-c로 정직 적시 → 신규 날조 없음.

---

## 6. Phase 5 게이트가 독립 재실측할 핵심 (미확정 잔존)

1. **[돈크리티컬 가능성] D2/D3 책자 잉여필드 라이브 관용 vs 오염** — PRN_CLR_CNT/MTRL_CD를 book2025_price 핸들러가 무시하는가, 아니면 표지색(CVR_CLR_CNT)을 덮는가. 코드(클라)로는 양쪽 다 판정 불가 → 서버 핸들러 거동 필요. 오염시 책자 가격 오류. **read-only 변형 POST 불가**이므로 미확정 명기가 정직한 결말(추정 금지).
2. **D1 라이브 관용도** — string `"2"` ATTB를 Red 서버가 number 2로 강제 파싱하는가/거부하는가/무시하는가. Red 클라 소스엔 강제 없음(합의). 서버 PHP 미보유 → 미확정. byte 발산은 확정.
3. **VP-2 라이브 가격 동일성 재현** — codex 미수행(오프라인). Phase 5가 server.js로 골든 result_sum 독립 재생(strict) 필요.
4. **D1 교정 범위** — `String(req.quantity)`→`req.quantity`는 quantity-echo 분기 한정, `f.attb`(속성칩 string) 경로 불변 보장. 교정 후 회귀 가드(ATTB 값+타입 대조 어서션)가 함정 #1(fixture masks shape) 재발 차단하는지 검증.
