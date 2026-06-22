# reuse-map.md — 재검증 금지(이미 입증) vs 신규 검증(이번에 닫을 갭)

> 원칙: **이미 입증된 차원은 다시 하지 않는다.** §6에서 통과한 것 vs 이 하네스가 새로 닫을 갭.
> 근거 없는 "이미 됨" 금지 — 각 항목 출처 인용.

---

## 1. 재검증 금지 (§6에서 이미 입증·재사용)

| # | 이미 입증된 차원 | 입증 근거 | 재검증 안 하는 이유 |
|---|------------------|-----------|---------------------|
| R-1 | 응답 3단 워터폴(PRICE_MALL→PRICE→ORG_PRICE) 소비 | gate-report §2(b) / parity-D1-price D1-11(완전재현, deob mod_06:1284 정합) | 코드정합·실렌더 PASS. 단 VP-2 라이브차등에서 result_sum 값 일치는 재확인(저비용 부산물) |
| R-2 | dataJson 래퍼 + mb_cust_cod fallback `10000000` | parity-D1-price D1-1/D1-2(deob mod_05:1138·mod_06:2522) / serialize-shape.test | 코드 권위로 hold. **단 fixture 경로 한정** — 실 HTTP byte 정합은 VP-1로 신규(아래 N-1) |
| R-3 | ORD_CNT/PRN_CNT 분리 + 침묵0 가드(isPriceRequestQuotable) | parity-D1-price D1-5/D1-10(강화재현) / s6-calendar.test / s5-pouch-live-note | 가드 로직 PASS. VP-3는 가드가 라이브 incomplete에서 작동하는지만 확인 |
| R-4 | price_gbn 불투명 echo(클라 분기 0) | parity-D1-price D1-8(완전재현, 분기 0) | echo만이므로 재구현 검증 불요. VP-6에서 값 사전 정합만 |
| R-5 | 책자 분리필드(CVR_/INN_*/PAGE_CNT) 직렬화 | serialize-shape.test:208-237 / red-adapter.ts:591-598 | fixture round-trip PASS. 단 **실 HTTP 책자 분리가격 산정**은 VP-1/VP-2 S-BK로 신규(fixture가 분리가격 미반영 위험, gate-report §2 PriceTable3D note) |
| R-6 | 4모델×4차원 위젯 코어 행위 동등(캐스케이드/상태전이/인터랙션) | gate-equivalence-report §6 **GO**(2026-06-03, vitest 84/150) | 위젯 코어 동등 입증됨. **단 가격 차원은 fixture 기준** — 라이브 HTTP 차등은 미커버(N-2) |
| R-7 | 라이브 테스트베드(server.js 프록시·capture 스크립트) 동작 | §6 HANDOFF / api-log/body-log(2026-06-22 동작) | 프록시·캡처 인프라 재구축 금지. 그대로 오라클 생산에 재사용 |

---

## 2. ★신규 검증 (이번에 닫을 갭 — §6가 안 한 것)

| # | 신규 검증 갭 | 왜 §6가 못 닫았나 | 게이트 |
|---|--------------|-------------------|--------|
| **N-1** | **실 HTTP 경로 reqBody byte 정합**(serialize→실 전송 body가 라이브와 strict 일치) | §6 fixture 경로가 HTTP 우회(fixture-source.ts:76-132 reqBody 무시) → serialize-shape.test도 serialize 출력만 대조, **실 BffClient 전송 body 미검증**. 함정 #1(fixture masks shape) | VP-1 (routeFromHAR strict POST) |
| **N-2** | **라이브 차등**(동일 옵션 → 라이브엔진 result_sum ↔ 재구성 일치) | §6 게이트는 fixture canned 응답 기준 — 라이브 가격엔진 직접 차등 미수행 | VP-2 |
| **N-3** | **ATTB 단가영향 라이브 입증**(D-L1 BLOCKER) | §6: ATTB 전손실 BLOCKER 미해소(SelectedFinish에 attb 슬롯 추가됐으나 라이브 단가차 미입증·G-1 날조 적발) | VP-6 + manifest §D |
| **N-4** | **itemGroup 휴리스틱 오분기**(D-L2 MAJOR) | §6: inner-형상 추론이 현 fixture에서 우연 정확, 명시 item_gbn 미참조 | manifest §D |
| **N-5** | **PRICE=0 ok:false 차단 라이브 입증**(D-L3 MAJOR) | §6: 어댑터가 retCode만 검사하던 것 → finalPrice>0 추가됐으나 라이브 0응답 차단 미입증 | VP-3 + manifest §D |
| **N-6** | **조합 발산/메타모픽 fuzz**(VP-5) | §6: 소수 fixture만 — 옵션튜플 조합 fuzz·메타모픽(수량↑⇒가격↑) 형식화 안 됨 | VP-5 |
| **N-7** | **인용 실재성 회귀가드**(VM-3) | §6: G-1이 deob 부존재 라인(2954/3572) 인용 날조 — 인용 라인 실재성 게이트 부재였음 | VM-3 (codex high 교차) |

---

## 3. 재사용 비율 (방법론 리서치 §(a) 정합)
- 인프라(테스트베드·프록시·캡처 스크립트·deob·리포트) = 100% 재사용.
- 재구성 코드(어댑터·계약·직렬화) = 검증 대상으로 재사용(수정 금지, §6 위임).
- 신규 = 동등성 검증 레이어(N-1~N-7) = ~20% 신규 작업.
