# verdict.md — Phase 5 독립 검증 게이트 최종 판정 (V-PRICE + 메타게이트)

> 판정자: hrev-verify-gate. **생성자(인스펙터)·codex 주장 비신뢰 — 직접 재실측으로 재판정**(생성≠검증).
> 오라클 = 라이브 RedPrinting(via `raw/widget_monitor/local/server.js` :3001, 읽기전용 get_ajax_price_vTmpl).
> 재실측 일시: 2026-06-23 (KST). 세션 신선(AIPPCUT=3300 sanity 통과).
> 입력: `03_price/`(vprice-board·cells·divergence) · `06_codex/reconcile.md`·price-verdict.txt · `02_golden/` · `01_inventory/`.

---

## 0. 최종 판정

| 게이트 | 판정 | 근거(재실측) |
|--------|------|--------------|
| **V-PRICE** | **NO-GO** | VP-1 FAIL(직렬화 shape 발산 20셀 직접 재현). 단일 FAIL=NO-GO 컨벤션. VP-2~6 전부 GO. |
| **VM-1 생성≠검증** | **PASS** | 본 게이트가 인스펙터 셀 복붙 없이 차등 테스트 직접 재실행·라이브 strict 재생·골든 타입 python 직접 검증·인용 라인 직접 grep. 재구성 작성자(§6 hw-builder)와 검증자(hrev-verify-gate) 분리. |
| **VM-2 codex reconcile** | **PASS** | codex high AVAILABLE(gpt-5.5, RC=0, 79k tok). 핵심 3쟁점 합의 + 신규발굴(ATTB 타입 다형) Claude 재실측으로 확증. 불일치(D1 live 타입 단일서술)는 조사 완료(codex 승·보드 정밀화 항목, 결함 무효 아님). pending 아님. |
| **VM-3 무날조** | **PASS** | 어댑터 동작 라인(615/588/589/151) 실재 직접 확인. 자기인용 부존재(mod_07:2467/2586/2598≠ATTB)는 어댑터 주석 607이 정직 적시(G-1 날조 선례와 다름). 실재 deob 인용(1008/2162/2387/deob_06:1250) 전수 실재. |

**→ V-PRICE = NO-GO** (VP-1 직렬화 결함 확정). 단 **돈 영향(가격값) 발산은 0**(VP-2 라이브 재실측 8/8 PASS) — NO-GO 사유는 reqBody byte shape 한정.

---

## 1. VP-1~6 재판정 (재실측 — 생성자 셀 복붙 아님)

| 게이트 | 인스펙터 주장 | 재실측 방법 | 재실측 결과 | 일치? |
|--------|--------------|------------|-------------|:----:|
| **VP-1** 골든 strict 재생(직렬화 정합) | FAIL(20셀) | verify-gate가 `vprice.config.mts` 차등 테스트 **직접 실행** | **20 FAIL / 114 PASS** (동일) — 예: `expected "100" to be undefined`(ATTB 타입), `expected 4 to be undefined`(PRN_CLR_CNT) | ✅ 재현 |
| **VP-2** 라이브 차등(result_sum.PRICE) | PASS(27셀) | verify-gate가 `07_gate/scripts/vp2-live-replay.cjs`로 **골든과 무관하게 8 대표 케이스 라이브 재요청** | **8 PASS / 0 FAIL** — AIPPCUT 3300·GSTGMIC 13600/631800·GSNTSPR 6300/63000·PRBKYPR 6100/8300 전부 골든 권위 일치 | ✅ 재현 |
| **VP-3** PRICE≠0 sanity + 가드 | PASS | `mapPriceResponse` 워터폴 **직접 실행**: PRICE=6300→ok:true / PRICE=0→ok:false | ok 게이트 재현(finalPrice>0 조건 red-adapter.ts:674) | ✅ 재현 |
| **VP-4** result_sum 권위(per-line 0 무시) | PASS | GSNTSPR 라이브 응답 **직접 캡처**: perLine=PRT_DFT만 6300, 나머지 8개 PCS=0 → result_sum.PRICE=6300 | mapPriceResponse가 result_sum만 읽음 직접 재현 | ✅ 재현 |
| **VP-5** 조합/메타모픽 | PASS | GSTGMIC PRN 2→100 라이브 재요청: 13600<631800 단조증가. GSNTSPR ORD1→10: 6300→63000 선형. RIN_GLD 변경→6300 불변 | 단조·선형·ATTB불변 라이브 직접 재현 | ✅ 재현 |
| **VP-6** 필드사전 정합 | PASS(주의) | 차등 테스트 키 발명 검사로 흡수(VP-1 D2/D3로 분류) | 책자 단일면필드 부재 어서션 FAIL = D2/D3와 동일 | ✅ 재현 |

**결론: 인스펙터 셀과 재실측 100% 일치**(불일치 0). VP-1 FAIL 확정.

---

## 2. 결함 재판정 (D1/D2/D3 — 직접 재현)

| ID | 심각도(게이트 확정) | 재실측 증거 | 인스펙터/codex 대비 |
|----|---------------------|-------------|---------------------|
| **D1** ATTB 타입(string vs number) | **HIGH** | python 직접 검증: quantity-echo(SUB_MTR/WRK_MTR/INN_DFT)=`int`, 속성칩(RIN_DFT/ROU_DFT)=`str`. 어댑터 615 `String(req.quantity)`→string. byte 발산 확정. | codex 신규발굴(타입 다형) 게이트가 python으로 독립 확증 — quantity-echo만 number 권위. |
| **D2** 책자 PRN_CLR_CNT 발명 | **MED** | 차등 테스트 `expected 4 to be undefined` 직접 재현. 골든 ORD_INFO(json:33-36)에 PRN_CLR_CNT 부재 확인. 어댑터 588 무조건 set. | codex Red소스(mod_05:1859-1881) book split-only 합의·게이트 재확인. |
| **D3** 책자 MTRL_CD 발명 | **MED** | 골든 ORD_INFO에 top-level MTRL_CD 부재(CVR_/INN_MTRL_CD만). 어댑터 589 무조건 set(591 isBook 분기 이전). | 상동 합의. |

**합계: HIGH 1 / MED 2 (영향셀 24). result_sum(가격값) 발산 0.**

### 2.1 ATTB 타입 다형 — 게이트 직접 재현 (D1 정밀화)
```
golden_GSNTSPR_attb.json: INN_DFT ATTB=1(int) · RIN_DFT='RIN_BLK'(str) · ROU_DFT='4'/'8'/'0'(str)
```
★ROU_DFT의 `"4"`는 숫자처럼 보이나 **string**(python type:str 확인). 즉 어댑터 교정 시 `String(req.quantity)`→`req.quantity`(number)는 **quantity-echo 분기에만** 적용하고, `f.attb`(속성칩 string) 경로는 불변이어야 함 — codex 발굴이 교정 범위를 정밀화(remediation-spec §D1).

---

## 3. 미확정 항목 (무날조 — 사유 명시, GO/FAIL 위장 안 함)

| 항목 | 사유 | 시도 여부 |
|------|------|----------|
| **D1 string ATTB 라이브 관용도** | 변형 reqBody(string `"2"` ATTB)를 라이브 POST하면 Red 거부/오가격/무시를 알 수 있으나, **능동 변형 POST = 읽기전용 불변식 위반** → 미수행. Red 클라소스에 ATTB parseInt/Number 강제 부재(codex+게이트 양측 확인). 서버 PHP 미보유. byte 발산은 확정. | 의도적 미수행(불변식). |
| **D2/D3 책자 잉여필드 라이브 관용 vs 오염** | PRN_CLR_CNT/MTRL_CD를 book2025_price 핸들러가 무시하는가/표지색 오염하는가 — 코드(클라)로 판정 불가, 서버 핸들러 거동 필요. **오염시 책자 표지색 돈크리티컬**. 능동 변형 POST 불가 → 미확정 정직 기록(추정 금지). | 의도적 미수행(불변식). |
| **실 HTTP transport(BffClient impl)** | 04_build에 실 HTTP transport 부재(인터페이스). serialize 출력=전송 body 가정으로 검증(N-1 핵심=fixture 우회 없는 실 직렬화 대조이며 충족). | 강등(대체 충족). |
| **itemGroup 경계·clothes2025·BCSPDFT** | Phase 2 미캡처. 파일럿(가격 API) 범위 밖 → V-WIDGET 권장. | 파일럿 외. |

---

## 4. 재실측 증거 인덱스

- 차등 테스트 직접 실행: `cd _workspace/huni-widget/04_build && ./node_modules/.bin/vitest run --config ../../huni-re-verify/03_price/scripts/vprice.config.mts` → 20 FAIL/114 PASS.
- VP-2 라이브 strict 재생: `07_gate/scripts/vp2-live-replay.cjs`(골든 미수정 별도 산출) → 8 PASS/0 FAIL.
- 골든 ATTB 타입 검증: python json type 추출(quantity-echo=int·속성칩=str).
- VM-3 인용 실재성: `red-adapter.ts:615/588/589/151` 실재 + `mod_07:2467/2586/2598`≠ATTB(부존재 자기인용 = 어댑터 607이 정직 적시) + 실재 deob(1008/2162/2387/deob_06:1250) 전수 확인.
- 종단 e2e: `07_gate/e2e-golden-trace.md`(GSNTSPR 라이브 응답→mapPriceResponse 직접 실행).

---

## 5. 라우팅 (NO-GO 항목 재작업)

- **VP-1(D1/D2/D3)** → 교정 명세 `07_gate/remediation-spec.md`. 실 수정은 **§6 huni-widget 트랙(red-adapter.ts)·인간 승인**. 이 게이트는 검증+명세까지.
- **보드 서술 정밀화** → 인스펙터 hrev-price-equivalence: D1 서술에 "live=number는 quantity-echo 한정, 속성칩 ATTB=string 정상" 1줄 보강(divergence-cases.md/vprice-board.md). 결함 무효화 아님.
- **다음 단계**: 가격 파일럿 NO-GO 확정(돈영향 0·shape 결함). D1 교정(돈영향 미확정이나 byte 정합·회귀가드 우선)·D2/D3 교정(오염시 돈크리티컬 가능성→우선순위) 후 §6 동등성게이트 재실행 권장. widget(V-WIDGET)·editor(V-EDITOR) 서브시스템 확대는 가격 파일럿 교정·재검증 후 착수 권장(파일럿 우선 원칙).
