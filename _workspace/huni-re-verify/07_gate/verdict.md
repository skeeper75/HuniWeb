# verdict.md — Phase 5 독립 검증 게이트 최종 판정 (V-PRICE 신규 14필드 + 메타게이트)

> ⚠️ **정정(corrigendum, remediation-verify.md 재실측):** 본 문서의 "538,000 / 1,140,000 / 3,010,000" 및
> "ladder qty 20/30/50"은 **ORD_CNT(주문건수) sweep** 값이다(ORD_CNT=20 × 단가 26,900 = 538,000). PRN_CNT
> 래더 자체 가격은 PRN_CNT 20/30/…/110 → 26,900/38,000/…/123,700(단조). **측정 차원 라벨(ORD_CNT↔PRN_CNT)만
> 정정**이며, N3 결함(교정 전 모델A 미구현=견적불가)·HIGH 판정·CLOSED 결론은 라이브 재현으로 유효. 원본 기록은 감사추적상 보존.

> 판정자: hrev-verify-gate. **생성자(인스펙터)·codex 주장 비신뢰 — 직접 재실측으로 재판정**(생성≠검증).
> 오라클 = 라이브 RedPrinting(via `raw/widget_monitor/local/server.js` :3001, 읽기전용 get_ajax_price_vTmpl).
> 재실측 일시: 2026-06-23 (KST). 세션 신선(NCCDDFT baseline=12700 sanity 통과).
> 입력: `03_price/`(vprice-board·cells·divergence) · `06_codex/reconcile.md`·newfields-verdict.txt · `02_golden/captures/new-fields-260623/` · `01_inventory/`.
> 4월 베이스라인 게이트(D1/D2/D3 ATTB·책자필드)는 `_prev/260623-april-baseline/07_gate/`에 보존. 본 파일은 6월 신규 14필드 차원 전용.

---

## 0. 최종 판정

| 게이트 | 판정 | 근거(재실측) |
|--------|------|--------------|
| **V-PRICE (신규필드)** | **NO-GO** | VP-1·VP-6 FAIL(신규필드 미전송 직접 재현 — vitest 34 FAIL 동일 재현). 단일 FAIL=NO-GO. ★N3(모델A) 라이브 돈영향 직접 비준 = 견적불가 확정 결함. |
| **VM-1 생성≠검증** | **PASS** | 본 게이트가 인스펙터 셀 복붙 없이 vitest 차등 **직접 재실행**(70P/34F 재현)·라이브 read-only 차등 **직접 POST**(R2 baseline·N1·N3)·deob 인용 라인 **직접 grep**(8+N6)·골든 PRICE python 직접 대조. 재구성 작성자(§6 hw-builder)·생성 인스펙터(hrev-price-equivalence)·codex 와 검증자(hrev-verify-gate) 3중 분리. |
| **VM-2 codex reconcile** | **PASS** | codex high AVAILABLE(gpt-5.5, RC=0, 108k tok). 합의 4/6(N1·N3·VM-3·R2) + 미확정 2(N2 심각도·N5 omit안전성) 정리됨. codex가 독립으로 N1·N3 상향 입증(생성≠검증 가치). 신규발굴 3건(N6 ATTB×10·PACK_PRN_CNT PRT_SID 게이트·계약 REAM 과장) 게이트가 deob 직접 grep으로 확증. 미가용 아님(pending 아님). |
| **VM-3 무날조** | **PASS** | codex/인스펙터 인용 deob 8라인 + N6(L13950·L14110-14124) **게이트가 직접 sed/grep 재확인 — 전수 실재(환각 0)**. §6 어댑터 교정 위치(price.ts:24·red-types.ts:166·red-adapter.ts:279/299/569/580/650) 전수 실재. crossverify-round2 G-1 날조 선례 재발 없음. |

**→ V-PRICE(신규필드) = NO-GO** (VP-1·VP-6 FAIL). **확정 결함 6(N1~N6): HIGH 2(N1·N3) / MED 1(N2) / LOW 2(N4·N5) / 신규 1(N6 조사필요)**.
**N3 HIGH는 라이브 가격 차등으로 직접 비준**(538,000→1,140,000→3,010,000). **N1 HIGH는 deob 소스 메커니즘 확정·라이브 돈영향은 미확정(발현 자재상품 미식별)**.

---

## 1. VP-1~6 재판정 (재실측 — 생성자 셀 복붙 아님)

| 게이트 | 인스펙터 주장 | 재실측 방법 | 재실측 결과 | 일치? |
|--------|--------------|------------|-------------|:----:|
| **VP-1** 신규필드 골든 strict 재생(직렬화 정합) | FAIL(33셀) | verify-gate가 `vprice-newfields.config.mts` 차등 **직접 실행** | **34 FAIL / 70 PASS**(33 VP-1/VP-6 reqBody 발산 + 1 VP-5 MR-5) — 예: `재구성 미전송 신규 ORD_INFO 필드: [{"field":"DOSU_COD","golden":"SID_S"}]` / ADD_CLR_YN·REAM_CNT omit | ✅ 재현 |
| **VP-2** 라이브 차등(result_sum.PRICE) | PASS(주의·응답측 fixture) | verify-gate가 라이브 read-only **직접 POST**(R2 baseline·N1 3케이스·N3 ladder 3케이스) | baseline 12700 재현 / N1 inert 재현 / **N3 ladder 538k→1.14M→3.01M 직접 차등** | ✅ + N3 강화 |
| **VP-3** PRICE≠0 sanity | PASS | 골든 8 시나리오 priceZeroCount 직접 확인 + 라이브 baseline 직접 POST | 정상경로 전부 >0(globalSanity priceZeroCount=0 일치). N3 ladder >0 직접 확인 | ✅ 재현 |
| **VP-4** result_sum 권위(per-line 0 무시) | PASS | NF-ORDCNT 골든 perLine[0].PRICE=0 + red-adapter.ts:650 직접 Read | mapPriceResponse가 result_sum만 읽음 직접 확인(`const sum = res.result_sum`) | ✅ 재현 |
| **VP-5** 메타모픽 | PASS(MR-5 제외) | metamorphic-relations.json 직접 Read + vitest MR-5 재현 | MR-1~4·6~8 성립. **MR-5 FAIL 재현(16200<16800)** = 서로 다른 후가공 종류 → 단조 부적용 = **검사식 정의오류**(재구성 결함 아님) | ✅ 재현 |
| **VP-6** 필드사전 정합(미지원 명시) | FAIL(미지원) | red-types.ts:166-184·price.ts:24-41 직접 Read(신규필드 슬롯 부재 확인) | 발명 0(emit 전부 사전 ∈) + ADD_CLR_YN/REAM_CNT/PACK/MAX/모델A 슬롯 부재 = 미지원 조항 발동 | ✅ 재현 |

**결론: 인스펙터 셀과 재실측 100% 일치**(불일치 0, vitest 34 FAIL byte 단위 동일). VP-1·VP-6 FAIL 확정.

---

## 2. 결함 재판정 (N1~N6 — 직접 재현)

| ID | 심각도(게이트 확정) | 재실측 증거(직접) | 인스펙터/codex 대비 |
|----|---------------------|-------------------|---------------------|
| **N1** ADD_CLR_YN 미전송 | **HIGH(소스확정·라이브 미확정)** | deob 직접 grep: L15764 `m.value!=="Y"?null:i.value==="SID_S"?6:"SID_D"?12` + L15771-15773 `PRN_CLR_CNT:g; ADD_CLR_YN:C==="Y"?"Y":"N"` + L13982 `ADD_CLR_YN:T.dosuInfo?.ADD_CLR_YN`(non-book 항상 emit). **Y→PRN_CLR_CNT 6/12 상향=색수=가격축**. 라이브 차등 직접 시도(NCCDDFT/RXSNO250 PRN_CLR_CNT 4/6 × Y/N 4케이스 전부 12700 = 이 자재 inert) → 발현 자재상품 미식별 | codex HIGH(발현경로 source 실증)·Phase3 HIGH(돈영향 미확정) **합의**. 게이트: 메커니즘 확정, **라이브 돈영향 미확정**(발현 자재 미식별) |
| **N2** REAM_CNT 미전송 | **MED(돈영향 0)** | deob 직접 sed: L22609-22616 `reamYn!=="Y"→return 0`·비율계산, L13977-13978 빌더는 `PRN_CNT:...quantityInfo?.prnCnt`만(REAM_CNT 안 읽음). 골든 REAM_CNT 0/1/2 전부 PRICE 12700(직접 확인) | codex LOW(대체모드 부재)·Phase3 MED(승격여지) → **돈영향 0 합의, 심각도 라벨 미확정**. 게이트: MED 유지(byte 누락 확정·가격무영향) |
| **N3** 모델A 래더 미구현 | **HIGH(라이브 가격 차등 직접 비준)** | **라이브 read-only 직접 POST(TPBLMEO 80×80 SID_S, ladder qty=20/30/50): PRICE 538,000 / 1,140,000 / 3,010,000 단조증가**. pdt_add_option_info 실재 직접 fetch(TPBLMEO 5행 MIN_ORD/ADD_ORD/PACK_PRN). red-adapter.ts:279 buildQuantityRule=모델B만(MIN_ORD_PRN_CNT/ADD_ORD_PRN_CNT 슬롯 0 직접 Read) | codex HIGH(real wired)·Phase3 MED(미검증) → **게이트가 라이브 가격 차등으로 HIGH 직접 비준**(MED→HIGH 확정). 재구성 미구현=떡메/굿즈 **견적불가** |
| **N4** PACK_PRN_CNT/MAX_PRN_CNT 미전송 | **LOW(PRT_SID 게이트 비고)** | deob 직접: L19784 `PACK_PRN_CNT===100?["PRT_SID"]`(disabled-add-pcs)·L19786 `!==100 && COD==="SID_X"`(forced). 단순 echo 아님=후가공 가용성 좌우(간접). 골든 PACK=100/MAX=10000 PRICE 보존(직접 확인) | codex 신규(PRT_SID 게이트 부작용)·Phase3 LOW → **LOW 유지 + PRT_SID 게이트 비고 추가**(N4 가격함수 sweep 미캡처) |
| **N5** DOSU_COD omit(4월기존) | **LOW(잔존·omit안전성 미확정)** | deob 직접: L13980 `DOSU_COD:T.dosuInfo?.COD`. codex 지적 L13540-13546 `Hh()` PDT_CD 재작성·L19784/19786 PRT_SID 게이트는 **TPBLMEO/TPBLPST(트래블택류) 전용**. N5 omit 대상=GSTGMIC/NCCDDFT(offset2023). 재구성은 PDT_CD 직접 산출(DOSU_COD 경유 안 함) | codex UNDETERMINED(0증명불가+PDT_CD재작성)·Phase3 LOW(돈영향0 단정) → **불일치→미확정**. 게이트: GSTGMIC/NCCDDFT선 무영향이나 라이브 차등 미실측·TPBLMEO 처리 시 위험 = LOW 잔존·omit안전성 미확정 |
| **N6** GSELGLV/TPTKDFT ATTB×10 미반영(codex 신규) | **신규(조사필요)** | deob 직접: L13950 `pdtCode==="GSELGLV" && PCS_CD==="DIR_MTR"?(prnCnt??0)*10:...TPTKDFT...SUB_MTR EN001~4?(ATTB??0)*10` + L13978 PRN_CNT×10 + L14110-14124 quantityInfo.prnCnt×10 동반. 재구성 GSELGLV/TPTKDFT 미처리(grep 0) | codex 신규발굴·게이트 deob 직접 확증. **재구성이 GSELGLV/TPTKDFT 다룰 시 ATTB·PRN_CNT ×10 미반영=후가공/수량 저청구**. 현 재구성 미바인딩=잠복 |

**합계(6월 신규필드 차원): HIGH 2(N1·N3) / MED 1(N2) / LOW 2(N4·N5) / 신규 조사 1(N6).**
**N3는 라이브 가격 차등으로 HIGH 직접 비준(돈크리티컬·견적불가).** N1은 소스 메커니즘 확정·라이브 발현 미확정. 전부 reqBody 직렬화 누락(미전송/미구현) — 응답 평면화(mapPriceResponse) 결함 0.

### 2.1 R2 스케일 아티팩트 진위 (직접 재캡처)
```
라이브 read-only 직접 POST: NCCDDFT offset2023 PRN500 baseline → retCode 200, result_sum.PRICE = 12,700
price-engine-additions.md §3 표: baseline PRN500 = 6,350,000
```
**6,350,000 = 12,700 × 500(=PRN_CNT) = 스케일 아티팩트 확정**(곱셈 전사오류). 골든 baseline 12,700 이 단일 권위. **R2 §3 표 인용 금지**(보강골든·라이브 재캡처가 권위). codex도 "undetermined from source"였으나 **게이트가 라이브 read-only 단발 재캡처로 진위 확정**(스케일 아티팩트).

---

## 3. 미확정 항목 (무날조 — 사유 명시, GO/FAIL 위장 안 함)

| 항목 | 사유 | 시도 여부 |
|------|------|----------|
| **N1 라이브 발현 돈영향(저청구 실측)** | ADD_CLR_YN=Y 발현은 `pdt_mtrl_info`에 ADD_CLR_YN="Y" 자재 보유 상품에서만(L15749/15758). 가용 fixture·body-log(0건)·합리적 probe(NCCDDFT/STSKDFT/STTBDFT/GSTGMIC 전부 ADD_CLR_YN=Y 자재 0) **모두 발현 자재상품 미식별**. 라이브 블라인드 probe로 별색상품 코드 탐색은 read-only 과다호출·비생산적 → 미수행. **메커니즘은 deob 소스로 확정**(Y→PRN_CLR_CNT 6/12 색수상향=가격증가 경로)·라이브 저청구 실측만 미확정 | 의도적 정직 미수행(발현상품 미식별·블라인드 probe 회피) |
| **N5 DOSU_COD omit 라이브 차등** | GSTGMIC/NCCDDFT선 4월 fixture-주입 VP-2로만 입증(실 라이브 차등 아님). 라이브 read-only 차등 추가 가능하나 4월 입증과 동치 추정 → 본 신규필드 패스 범위 밖. TPBLMEO/TPBLPST를 재구성이 다루면 DOSU_COD→PDT_CD 재작성 누락 위험(미검증) | 강등(4월 입증 동치·파일럿 범위) |
| **N4 모델A·PACK·MAX 가격함수 sweep** | 가격함수 full sweep 미캡처(price-engine-additions §5 미확정과 일치). N3 ladder 가격차등은 직접 비준했으나 PACK_PRN_CNT/MAX_PRN_CNT 독립 가격기여는 미sweep | 부분(N3 ladder 비준·PACK/MAX 미sweep) |
| **PDT_SIZE_INFO/PRINT_TYPE(가격경로)/TMPL_IDX** | 신규필드 골든 8 시나리오에 미포함(BT*/의류/트래블택 전용). 재구성 PRINT_TYPE은 apparel.ts OptionGroup만·가격 ORD_INFO 미전송 | 파일럿 외(미캡처) |

---

## 4. 재실측 증거 인덱스 (전부 verify-gate 직접 실행)

- vitest 차등 직접 재실행: `cd _workspace/huni-widget/04_build && ./node_modules/.bin/vitest run --config ../../huni-re-verify/03_price/scripts/vprice-newfields.config.mts` → **34 FAIL / 70 PASS**(인스펙터 주장 동일 재현).
- R2 baseline 라이브 직접 재캡처: NCCDDFT offset2023 PRN500 → **PRICE 12,700**(6,350,000=×500 스케일 아티팩트 확정).
- N3 모델A 라이브 직접 차등: TPBLMEO 80×80 SID_S ladder qty 20/30/50 → **538,000 / 1,140,000 / 3,010,000**(단조·돈크리티컬 비준).
- N3 바인딩 직접 fetch: TPBLMEO `pdt_add_option_info` 5행(MIN_ORD_PRN_CNT/ADD_ORD_PRN_CNT/PACK_PRN_CNT) 실재.
- N1 라이브 시도: NCCDDFT/RXSNO250 PRN_CLR_CNT 4/6 × ADD_CLR_YN Y/N 4케이스 전부 12700(이 자재 inert·발현 자재 미식별).
- VM-3 deob 인용 직접 grep/sed: L13950·L13978·L13982·L15432-15445·L15764·L15771-15773·L19664·L19729·L19733·L22611·L14110-14124 **전수 실재(환각 0)**.
- §6 어댑터 교정 위치 직접 Read: red-adapter.ts:279(모델B only)·:299·:569·:580-590·:650 + red-types.ts:166-184 + price.ts:24-41(신규필드 슬롯 부재) 실재.
- 종단 e2e: `07_gate/e2e-golden-trace.md`(TPBLMEO 모델A ladder 종단 추적).

---

## 5. 라우팅 (NO-GO 항목 재작업)

- **VP-1/VP-6(N1~N6)** → 교정 명세 `07_gate/remediation-spec.md`. 실 수정은 **§6 huni-widget 트랙(price.ts→red-types.ts→red-adapter.ts 3층)·인간 승인**. 이 게이트는 검증+명세까지.
- **우선순위:** **N3(HIGH·견적불가·라이브 비준) → N1(HIGH·돈크리티컬 소스확정) → N6(저청구 잠복) → N2/N4/N5(byte 정합·회귀가드)**.
- **보드 정밀화** → 인스펙터 hrev-price-equivalence: N3을 "MED→HIGH(라이브 538k→3.01M 차등 비준)"로, R2 표는 "인용금지·스케일 아티팩트 확정"으로 1줄 보강. 결함 무효화 아님.
- **검사식 정정** → MR-5 메타모픽 검사식을 "단조 비감소"에서 "각 후가공 > baseline"으로 정정(재구성 결함 아님·정의오류).
- **다음 단계:** 가격 파일럿 NO-GO 확정(N3 돈크리티컬 견적불가·N1 저청구 잠복). N3·N1 교정 후 §6 동등성게이트 재실행 → V-WIDGET·V-EDITOR 서브시스템 확대(파일럿 우선 원칙).
