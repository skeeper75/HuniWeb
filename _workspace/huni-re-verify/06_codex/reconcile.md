# reconcile.md — codex high 독립 2차 교차검증 (신규 14필드 차원 · Phase 4)

> codex: gpt-5.5 · model_reasoning_effort=high · -s read-only · 가용(RC=0, 108,186 tokens).
> workdir = HuniWeb repo root(deob+adapter+계약 동시 읽기). 프롬프트=`newfields-prompt.txt`(Claude 판정 비노출=독립성).
> verdict=`newfields-verdict.txt`. 4월 baseline reconcile=`_prev/260623-april-baseline/06_codex/reconcile.md`.
> [HARD] codex 주장=가설. 아래 모든 codex 인용 라인은 Claude가 deob 원본 grep/sed 재확인(환각 0 입증).

---

## 0. codex 가용 + VM-2 입력

codex 가용(gpt-5.5 high). VM-2 = "codex 입력 있음". pending 없음.

---

## 1. 쟁점별 reconcile (서브시스템 = 가격 신규필드)

### 쟁점 1 — N1 ADD_CLR_YN 심각도 → **합의 + codex가 HIGH 상향 입증**
- **codex 판정: HIGH.** ① 빌더 L13982 `ADD_CLR_YN: T.dosuInfo?.ADD_CLR_YN`는 non-book2025 ORD_INFO에 **항상** emit(조건부 아님). ② 소비코드 Dosu 컴포넌트 L15749/15758/15764/15773: 현재 MTRL_CD가 `addClrMtrlList`에서 `ADD_CLR_YN==="Y"`이면 사용자 토글 시 **PRN_CLR_CNT를 6(SID_S)/12(SID_D)로 재작성**하고 ADD_CLR_YN=Y emit. ③ 서버 default 여부는 deob만으로 undetermined, omission을 inert로 볼 근거 not found.
- **Claude 재확인(grep):** L15764 `m.value !== "Y" ? null : i.value === "SID_S" ? 6 : "SID_D" ? 12` + L15771-15773 `PRN_CLR_CNT:g, ADD_CLR_YN: C==="Y"?"Y":"N"` — **실재 확인**. ADD_CLR_YN="Y"는 PRN_CLR_CNT(=도수 색수, 가격축)와 커플링됨.
- **reconcile = 합의(고신뢰).** Phase 3는 N1을 HIGH로 잡되 돈영향 "미확정(현 inert·발현상품 노출 시 잠복)"으로 기록. codex가 **발현 메커니즘을 source로 실증** — ADD_CLR_YN=Y → PRN_CLR_CNT 6/12 상향 = 추가색 상품선에서 색수 증가 = 가격 증가 경로 존재. **N1 = HIGH 확정**(잠복 아닌 실재 발현경로). 단 재구성이 emit하는 PRN_CLR_CNT는 별도 도수선택에서 오므로, ADD_CLR 자재선택 상품을 재구성에 노출하면 ADD_CLR_YN 슬롯 부재로 색수 상향이 안 일어남 = **저청구**. 라이브 POST 실측은 Phase 5(read-only 차등).

### 쟁점 2 — N2 REAM_CNT 연단위 대체모드 → **합의(MED 유지·승격 안 함)**
- **codex 판정: LOW.** REAM_CNT는 `REAM_YN==="Y"`일 때만(L22609/22614) `reamCnt = REAM_CNT/PRN_CNT` 비율 또는 `Math.round(PRN_CNT*ratio)` 표시값 생성. emit quantityInfo=`{ordCnt,prnCnt,reamCnt}`(L22647)지만 **가격 빌더는 ordCnt/prnCnt만 읽음**(L13978). UI select 라벨에만 `(NR)` 붙음(L22722). PRN_CNT 대체경로 **not found**.
- **Claude 재확인(sed):** L22609-22616 reamYn 게이트·비율계산, L22644-22647 emit shape, L13977-13978 빌더는 `PRN_CNT: ...quantityInfo?.prnCnt`만 — **실재 확인**. REAM_CNT는 파생 표시값(연→매수 비율의 역방향 라벨), 수량권위 아님.
- **reconcile = 합의.** Phase 3는 N2 MED + "연단위 대체모드 상품 시 HIGH 승격 여지"로 조건부 열어둠. codex가 source로 **대체모드 부재**를 실증 → 승격 근거 not found. **N2 = MED 유지**(reqBody byte 누락은 확정·현 가격무영향). 단 N2를 LOW로 강등할지는 Phase 5 판단(codex는 LOW 주장·Claude Phase3는 MED). **심각도 LOW↔MED는 미확정**(돈영향 0 합의·라벨 차이뿐).

### 쟁점 3 — N3 수량모델 A 실재 가격경로 → **합의 + codex가 HIGH 상향 입증**
- **codex 판정: HIGH(real wired, dead code 아님).** `AddOptionSize`(B0)가 `MIN_ORD_PRN_CNT+ADD_ORD_PRN_CNT*h` ladder 생성(L15432-15445). `pdt_add_option_info?.length`일 때 렌더(L19664), TPBLMEO/TPBLPST override(L19667). ladder→quantity options(L19729 `le.value`)→선택된 prnCnt→ORD_INFO.PRN_CNT→가격.
- **Claude 재확인(sed):** L19664 `te.data.pdt_add_option_info?.length ? (...V(B0...))`, L19729-19730 QuantityGroup options=`pdt_add_option_info?.length && le.value.length ? le.value : me.value`, L15439-15445 ladder push `{PRN_CNT: u+c*h, ...}` — **실재 확인**. 모델 A는 떡메(메모지)·PDT_VER_SIZE형 굿즈의 실 가격수량 경로.
- **reconcile = 합의.** Phase 3는 N3 MED + "노출상품 미가용(acceptance only)·미검증"으로 보수적. codex가 **렌더 게이트+가격배선을 source로 실증** → 모델 A는 실 상품(pdt_add_option_info 보유 굿즈)에서 작동하는 라이브 경로. 재구성 미구현(red-adapter buildQuantityRule=모델B만) = **그 굿즈 상품군 수량/견적 불가**. **N3 = HIGH 상향 권고**(MED→HIGH). 단 "어느 라이브 상품이 pdt_add_option_info를 갖는지" 실측은 Phase 5.

### 쟁점 4 — VM-3 인용 실재성 + R2 6,350,000 스케일 → **합의(인용 실재) + 미확정(스케일)**
- **codex 판정:** L13955-13999(ORD_INFO 빌더·ADD_CLR_YN·PACK_PRN_CNT·PRINT_TYPE·TMPL_IDX)·L19733(MAX_PRN_CNT)·L22611(REAM_CNT)·L15432-15445(모델A) **전부 실재, 인용 심볼 present**. R2 `6,350,000`은 **undetermined from source** — deob는 원격 `get_ajax_price_vTmpl`로 POST(L12324/12330/12333), 로컬 가격공식 없음 → 스케일/전사오류 판정 불가.
- **Claude 재확인(grep):** L13982 ADD_CLR_YN·L13984 PACK_PRN_CNT·L13987 PRINT_TYPE·L13990 TMPL_IDX·L19733 MAX_PRN_CNT·L22611 REAM_CNT·L15432 MIN_ORD_PRN_CNT·L15433 ADD_ORD_PRN_CNT — **8개 인용 전부 실재(환각 0)**. crossverify-round2 G-1(날조 라인) 선례 재발 없음.
- **reconcile:** 인용 실재성 = **합의(VM-3 PASS)**. R2 6,350,000 = **미확정**. codex도 source만으로 판정 불가 확인. Phase 3가 이미 R2 수치앵커 미채택(보강골든 단일권위, 라이브 baseline 12,700·6,350,000≒12,700×500 scale 의심)한 결정과 일치 — **R2 6,350,000 vs 라이브 12,700은 스케일 아티팩트일 개연성 높으나 source로 확증 불가**. 어느 쪽도 사실 승격 금지. Phase 5가 라이브 read-only 단발 재캡처로 baseline PRICE 실측 권고(R2 표는 인용 금지·보강골든만 권위).

### 쟁점 5 — false-positive (N5 DOSU_COD omit 돈영향 0) → **불일치 → 미확정**
- **codex 판정: UNDETERMINED.** 가격이 원격(L12324/12330/12333)이라 source만으로 DOSU_COD money-impact 0 증명 **not found**. 게다가 DOSU_COD(=`dosuInfo.COD`)는 **다른 곳에서 거동상 유의** — TPBLMEO/TPBLPST에서 PDT_CD를 재작성(`Hh()` L13544-13546)하고 PRT_SID를 게이트(L19784/19786).
- **Claude 재확인(sed):** L13540-13546 `xP={TPBLMEO:"GSRMMSD",...}; Hh(e,t){...t.dosuInfo?.COD !== "SID_X" ? e : ...}` — **실재 확인**. DOSU_COD=SID_X가 PDT_CD 분기에 관여.
- **reconcile = 불일치 → 미확정.** Phase 3는 N5 = "돈영향 없음(PRN_CLR_CNT가 도수 가격의미 운반·4월 VP-2 가격동일 입증)"로 단정. codex는 **source만으로는 0 증명 불가 + DOSU_COD가 PDT_CD 재작성/PRT_SID 게이트에 쓰임**을 지적(정당한 false-positive 가드). ★단 codex가 든 PDT_CD 재작성은 **TPBLMEO/TPBLPST(트래블택류)** 전용이고, N5 omit 판정 대상은 GSTGMIC/NCCDDFT(offset2023). 또 재구성은 PDT_CD를 직접 산출(DOSU_COD 경유 안 함)하므로 그 분기는 재구성에 해당 안 될 수 있음. **그러나 DOSU_COD omit 자체의 라이브 가격동일성은 4월 fixture-주입 VP-2로만 입증(실 라이브 차등 아님)** → codex 지적이 정당: omit 안전성은 **미확정**. Phase 5가 ① TPBLMEO/TPBLPST를 재구성이 다루는지 ② DOSU_COD omit 라이브 read-only 차등으로 재실측해야 N5 LOW 확정 가능.

---

## 2. codex 신규 발굴 (Phase 3가 놓친 것)

1. **GSELGLV는 PRN_CNT×10만이 아니라 PCS_INFO.ATTB도 ×10 재작성**(L14110-14124: `prnCnt*10` + `DIR_MTR` selectedOptions `ATTB: L`). 계약/Phase3은 PRN_CNT×10만 기록 → **ATTB 스케일 누락**. 재구성이 GSELGLV를 다룬다면 ATTB도 동반 스케일해야 함(미반영 시 후가공 수량 저청구 가능). **신규 결함 후보 N6(GSELGLV ATTB ×10 미반영) — Phase 5 조사.**
2. **PACK_PRN_CNT는 단순 request echo 아님** — PRT_SID(개별인쇄)를 disable/force하는 UI 강제로직 키(L19784 `PACK_PRN_CNT===100 ? ["PRT_SID"]`·L19786 `!==100 && dosuInfo.COD==="SID_X"`). Phase3 N4는 "미전송·라이브 PRICE 보존"으로 LOW. codex: PACK_PRN_CNT가 후가공 가용성(PRT_SID)을 좌우 → **후가공 선택지 자체가 달라질 수 있음**(간접 가격영향). N4 LOW 유지하되 "PRT_SID 게이트 부작용" 비고 추가 권고.
3. **계약 REAM_CNT=수량모델 B 표기는 deob 기준 과장** — REAM_CNT는 표시 파생값, 요청은 PRN_CNT 사용(쟁점 2와 일치). 계약 price-engine-additions.md §1 "REAM_CNT ... 수량모델 B" 문구는 "REAM_CNT=표시파생(REAM_YN 게이트), 수량권위=PRN_CNT"로 정정 권고.

---

## 3. 종합 reconcile (가격 서브시스템)

| 쟁점 | codex | Phase3(Claude) | reconcile | 결론 |
|------|-------|----------------|-----------|------|
| N1 ADD_CLR_YN | HIGH(발현경로 실증) | HIGH(돈영향 미확정) | **합의** | **HIGH 확정** — Y→PRN_CLR_CNT 6/12 상향 = 추가색 상품 저청구 경로. 라이브 POST 실측 Phase5 |
| N2 REAM_CNT | LOW(대체모드 부재) | MED(승격 여지) | 합의(돈영향0)·심각도 미확정 | **MED 유지·돈영향 0** — 대체모드 not found, 승격 근거 없음 |
| N3 모델A | HIGH(real wired) | MED(미검증) | **합의** | **HIGH 상향 권고** — 떡메/굿즈 실 가격경로, 재구성 미구현=견적불가. 바인딩 상품 실측 Phase5 |
| VM-3 인용 | 전부 실재 | (검증대상) | **합의** | **VM-3 PASS**(8인용 실재·환각0) |
| R2 6,350,000 | undetermined | 미채택(보강골든권위) | 합의(미확정) | **스케일 아티팩트 개연 높으나 source 확증 불가** — R2 표 인용금지, baseline 라이브 재캡처 Phase5 |
| N5 DOSU_COD omit | undetermined(0증명불가+PDT_CD재작성) | LOW(돈영향0 단정) | **불일치→미확정** | omit 안전성 라이브 차등 미입증 — Phase5 read-only 재실측 |

**합의율: 4/6 합의(N1·N3·VM-3·R2) · 1 심각도 미확정(N2) · 1 불일치→미확정(N5).**
**codex가 독립으로 N1·N3를 Phase3 대비 상향 입증**(생성≠검증 가치). **신규 발굴 3건(N6 ATTB·PACK_PRN_CNT PRT_SID게이트·계약 REAM 과장).**

---

## 4. Phase 5(verify-gate)가 독립 재실측할 핵심 [HARD]

1. **N1 라이브 차등(read-only)** — ADD_CLR_YN 발현 상품(addClrMtrlList에 ADD_CLR_YN=Y 자재 보유)을 찾아, 재구성 reqBody(ADD_CLR_YN 슬롯부재·PRN_CLR_CNT 미상향)와 라이브(Y→6/12) PRICE 차등 실측. 저청구 확정 여부 = N1 HIGH 최종 비준.
2. **N3 바인딩 상품 실측** — `pdt_add_option_info`를 보유한 실 라이브 상품(떡메 PDT_VER_SIZE형)을 식별, 모델 A ladder PRN_CNT가 라이브 가격 차등을 내는지 확인. 그렇다면 재구성 모델A 미구현 = 그 상품군 견적불가 = HIGH 비준.
3. **R2 baseline 재캡처** — NCCDDFT offset2023 PRN500 baseline을 라이브 read-only 단발 캡처해 PRICE 실값 확인(6,350,000 vs 12,700 스케일 진위). R2 표는 인용 금지·보강골든이 단일권위.
4. **N5 DOSU_COD omit 안전성** — ① 재구성이 TPBLMEO/TPBLPST(트래블택)를 처리하는지 확인(처리하면 DOSU_COD→PDT_CD 재작성 누락 위험) ② GSTGMIC/NCCDDFT에서 DOSU_COD omit 라이브 read-only 차등으로 4월 fixture-주입이 아닌 실 차등 재실측. 둘 다 무영향이어야 N5 LOW 확정.
5. **N6 GSELGLV ATTB ×10**(codex 신규) — 재구성이 GSELGLV를 다루면 PCS_INFO.ATTB도 ×10 스케일하는지 점검. 미반영 시 후가공 저청구.

**메타게이트:** VM-2 = codex reconcile 완료(합의 4/6·미확정 2). VM-3 = 인용 실재성 PASS(환각 0). 어느 codex 주장도 라이브 확증 전 사실 승격 안 함.
