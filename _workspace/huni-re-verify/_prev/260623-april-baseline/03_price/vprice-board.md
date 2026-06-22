# vprice-board.md — V-PRICE 가격 동등성 게이트 판정 보드 (Phase 3 · 생성측)

> 검사자: hrev-price-equivalence. 오라클 = 라이브 RedPrinting 골든(`02_golden/captures/golden_*.json`).
> 검증 대상 = §6 재구성 가격 어댑터(`_workspace/huni-widget/04_build/src/adapters/red/red-adapter.ts`).
> 방법 = 차등 테스트(differential). 골든 reqBody(라이브 실측)로 NormalizedPriceRequest 를 역구성 →
>   `serializeRedPriceRequest` emit reqBody 를 골든 reqBody 와 직접 대조(fixture 우회 금지, N-1 함정 차단).
>   `mapPriceResponse` 출력을 골든 result_sum 과 대조.
> 하네스: `03_price/scripts/vprice-differential.test.ts` (+ `vprice.config.mts`).
> 실행: `cd _workspace/huni-widget/04_build && ./node_modules/.bin/vitest run --config ../../huni-re-verify/03_price/scripts/vprice.config.mts`
> 결과: **114 PASS / 20 FAIL** (전부 VP-1 직렬화 shape 발산). [HARD] 생성측 자가승인 금지 — verify-gate(Phase 5)·codex(Phase 4) 재판정.

---

## 0. 종합 판정

| 게이트 | 판정 | 핵심 근거 |
|--------|------|-----------|
| **VP-1** 골든 strict 재생(reqBody 직렬화 정합) | **FAIL** | 20셀 발산 — ATTB 타입(string vs number) 18셀 + 책자 단일면필드 발명(PRN_CLR_CNT/MTRL_CD) 6어서션. 아래 §2 발산 D1/D2/D3 |
| **VP-2** 라이브 차등(result_sum.PRICE/PRICE_VAT) | **PASS** | 전 정상경로 27셀 `mapPriceResponse.finalPrice == golden.result_sum.PRICE` 정합(3,300/4,000/8,000/13,600~631,800/2,850,000/6,100~8,300/6,300~63,000) |
| **VP-3** PRICE≠0 sanity + incomplete 가드 | **PASS** | 정상경로 전셀 finalPrice>0 & ok:true. incomplete(ORD/PRN 부재 → 라이브 0) 2셀 → 어댑터 ok:false + priceUnavailableReason. 가드 wiring 확인(red-adapter.ts:724) |
| **VP-4** result_sum 권위(per-line 0 무시) | **PASS** | GSTGMIC per-line PRT_DFT 외 전 0 → finalPrice=result_sum.PRICE=13,600. mapPriceResponse 가 result_sum 만 읽음(red-adapter.ts:650) |
| **VP-5** 조합 발산/메타모픽 | **PASS** | PRN_CNT↑⇒단조증가(GSTGMIC)·ORD_CNT 정확 선형 ×N(GSPUFBC)·PAGE_CNT↑⇒증가(PRBKYPR)·size↑⇒증가(STPADPN)·동일입력⇒동일출력(결정성, 전셀) |
| **VP-6** 필드사전 정합(발명 필드 0) | **PASS(주의)** | emit 키 전부 re-contract-price 사전 ∈. ★단 책자 PRN_CLR_CNT/MTRL_CD 는 "사전엔 있으나 책자 라이브 reqBody엔 부재" → 사전레벨 PASS·실 캡처 대비 FAIL(VP-1 D2/D3 으로 분류) |

**게이트 규칙(단일 FAIL=NO-GO)** → **VP-PRICE = NO-GO** (VP-1 FAIL).

---

## 1. 시나리오 × 게이트 매트릭스

| 시나리오 | price_gbn | VP-1 | VP-2 | VP-3 | VP-4 | VP-5 | VP-6 |
|----------|-----------|:----:|:----:|:----:|:----:|:----:|:----:|
| G-RP AIPPCUT(에코백) | real_price | **FAIL**(ATTB) | PASS(3,300/4,400) | PASS | — | PASS(자재차등) | PASS |
| G-FU STPADPN(스티커) | vTmpl_price | PASS | PASS(4,000/8,000) | PASS(+incomplete가드) | — | PASS(size↑) | PASS |
| G-TD GSTGMIC(네임택) | tiered_price | **FAIL**(ATTB) | PASS(7,000~631,800) | PASS | PASS(per-line0) | PASS(PRN↑단조) | PASS |
| G-TM GSPUFBC(파우치) | tmpl_price | PASS | PASS(2,850,000) | PASS(+incomplete가드) | — | PASS(ORD×N선형) | PASS |
| G-BK PRBKYPR(책자) | book2025_price | **FAIL**(필드발명) | PASS(6,100~8,300) | PASS | — | PASS(PAGE↑) | PASS(사전)/FAIL(캡처) |
| G-ATTB GSNTSPR(스프링노트) | tmpl_price | **FAIL**(ATTB) | PASS(6,300~63,000) | PASS | — | PASS(ATTB불변·qty운반) | PASS |

---

## 2. 결함 보드 (VP-1 발산 — 심각도별)

> 모든 행: emit(재구성) vs live(골든) 타입·값. 최소반례 전수 = `divergence-cases.md`. 오라클=라이브(라이브가 옳다).

| ID | 심각도 | 발산 | emit(재구성) | live(골든) | 영향 셀 | §6 교정 위치 | 돈 영향 |
|----|--------|------|--------------|------------|---------|--------------|---------|
| **D1** | **HIGH** | PCS_INFO ATTB **타입**(string vs number) | `"1"`,`"2"`,…(string) | `1`,`2`,…(number) | 18 (AIPPCUT×2·GSTGMIC×6·GSNTSPR×10) | red-adapter.ts:615 `ATTB: f.attb ?? (isQuantityEchoPcs ? String(req.quantity) : '')` — `String()` 가 number 를 string 화 | 미확정(라이브 string-ATTB 관용 여부 미입증·read-only). byte 발산 확정 |
| **D2** | **MED** | 책자 reqBody 에 `PRN_CLR_CNT` **발명** | `4`(number) | (부재) | 3 (PRBKYPR 전 호출) | red-adapter.ts:588 `PRN_CLR_CNT: req.colorCounts.default` 를 isBook 분기 전 무조건 set | 미확정(잉여필드 라이브 관용 여부 미입증) |
| **D3** | **MED** | 책자 reqBody 에 `MTRL_CD` **발명** | `"RXART300"` | (부재) | 3 (PRBKYPR 전 호출) | red-adapter.ts:589 `MTRL_CD: req.materials.default` 를 isBook 분기 전 무조건 set(책자는 CVR_/INN_MTRL_CD 만) | 미확정(상동) |

**합계: HIGH 1건 / MED 2건 (영향 셀 24)**. 전부 **직렬화 shape(reqBody) 발산** — result_sum(가격값) 발산은 0(VP-2 전셀 PASS).

### 2.1 D1 근거(무날조 — 라이브 실측 교차)
- 라이브 신규 골든: `golden_AIPPCUT_real.json:42` (`"ATTB": 1` JSON number), `golden_GSTGMIC_tiered.json:42/120/…` (`"ATTB": 2` number 등).
- ★§6 자체 캡처도 동일: `05_qa/captures/b1_AIPPCUT.json` 의 SUB_MTR ATTB = JSON int `1` (python json.load 로 `type:int` 확인). 즉 라이브 권위는 **number**.
- ★§6 어댑터 주석(red-adapter.ts:151)이 "캡처 ATTB=1(=quantity echo)"을 명시 인지하면서도 `String(req.quantity)`로 직렬화 → 타입 불일치를 코드가 자초.
- §6 회귀 가드 누락 이유: `red-adapter-price-serialize-shape.test.ts` 가 PCS_COD **집합**만 대조(line 172-188), ATTB **값·타입**은 미검사 → 함정 #1(fixture masks serialization shape) 잔존.

### 2.2 D2/D3 근거
- 라이브 책자 골든 `golden_PRBKYPR_book.json:24-37` ORD_INFO = `PDT_CD/CUT_*/WRK_*/PRN_CNT/ORD_CNT/PAGE_CNT/CVR_CLR_CNT/INN_CLR_CNT/CVR_MTRL_CD/INN_MTRL_CD` — **PRN_CLR_CNT·MTRL_CD 부재**.
- 어댑터는 단일면 필드(MTRL_CD/PRN_CLR_CNT)를 isBook 분기 이전(line 588-589)에 무조건 set → 책자에도 누출.
- §6 책자 serialize 테스트(serialize-shape.test:208-219)는 책자 분리필드 **존재**만 검사·단일면 필드 **부재**는 미검사 → 갭 잔존.

---

## 3. 핵심 추가가치 갭(D-L1/D-L2/D-L3) 라이브 차등 판정

| 갭 | manifest | 판정 | 근거 |
|----|----------|------|------|
| **D-L1 ATTB 단가영향(BLOCKER)** | §D | **해소(라이브 입증)** | golden_GSNTSPR_attb.json: 링색 RIN_BLK/WHT/GLD/SIL·반경 rou0/4/8 전부 PRICE **불변**(6,300). qty(ORD/PRN)만 가격 운반(5×6,300=31,500 정확). ATTB=echo 전용 확정. **단 echo 의 타입은 number 여야 함(D1)** — 어댑터 echo 값은 맞으나 타입 틀림 |
| **D-L2 itemGroup 오분기(MAJOR)** | §D | **부분 PASS + 신규결함** | itemGroup 명시 권위 경로(red-adapter.ts:574-576)는 책자/비책자 분기 정확. 형상 휴리스틱 fallback 미트리거. ★단 책자 분기 자체가 단일면 필드 누출(D2/D3) — 분기는 맞으나 직렬화가 부정확 |
| **D-L3 PRICE=0 ok:false 차단(MAJOR)** | §D | **해소(라이브 입증)** | incomplete reqBody(ORD/PRN 부재) → 라이브 result_sum.PRICE=0 → mapPriceResponse ok:false + priceUnavailableReason(red-adapter.ts:674,682). 가드도 fetchPrice 이전 차단(line 724). 정상경로 0 발생 0 |

---

## 4. 미검증 셀 (무날조 — 사유 명시)

| 항목 | 사유 |
|------|------|
| **D1/D2/D3 의 라이브 가격 영향(실 POST)** | 변형 reqBody(string ATTB·잉여필드)를 라이브에 POST 하면 Red 가 거부/오가격/무시 중 무엇인지 알 수 있으나, 이는 **능동 변형 요청** = 읽기전용 불변식 위반 → 미수행. byte 발산은 확정, 라이브 관용도는 미확정. Red 가 잉여필드/타입을 silently 무시할 가능성 있음(현 골든은 정상 shape 만 캡처) — codex/verify-gate 가 deob 파서 동작으로 보강 권장 |
| **실 HTTP 전송 레이어(BffClient HTTP impl)** | 04_build 에 실 HTTP transport 구현 부재(BffClient=인터페이스, 라이브는 widget_monitor server.js 프록시). 직렬화(serializeRedPriceRequest) 출력이 곧 전송 body 라는 가정하에 검증. Playwright routeFromHAR strict POST 매칭은 실 위젯 런타임 부재로 강등 — emit 직렬화 직접대조로 대체(동등 효력, N-1 핵심은 fixture 우회 없는 실 직렬화 출력 대조이며 충족) |
| **G-ITEM(itemGroup 경계 케이스)·BCSPDFT(radius)** | Phase 2 미캡처(capture-log §3). 본 파일럿 범위 밖(widget 동작 게이트 V-WIDGET 권장) |
| **clothes2025(의류) PRINT_TYPE/DIR_MTR** | 캡처 부재(re-contract §4·D-L2 누락). 파일럿 외 |

---

## 5. Phase 4 codex(high) 독립검증 핵심 쟁점

1. **D1 타입 발산이 진짜 결함인가** — Red 서버가 ATTB 를 string `"2"`로 받아도 number `2`와 동일 파싱하는가? deob(`03_deobfuscated` mod_06/07) 의 ATTB 소비 코드를 직접 읽어 타입 강제(parseInt/Number) 여부 확인. number 강제면 D1=관용(LOW), 그대로 키매칭이면 D1=실결함(HIGH).
2. **D2/D3 잉여필드 라이브 관용** — Red book2025_price 핸들러가 PRN_CLR_CNT/MTRL_CD 를 무시하는가, 아니면 표지색 오염하는가? (오염 시 책자 가격 돈크리티컬)
3. **VP-2 가격 동일성 재실측** — codex 가 동일 옵션을 라이브 server.js 로 독립 차등(Claude 골든과 무관하게).
4. **VM-3 인용 실재성** — red-adapter.ts:151 의 "캡처 ATTB=1" 주장과 §6 deob 인용 라인 실재(crossverify-round2 G-1 선례: deob 부존재 라인 인용 날조).
