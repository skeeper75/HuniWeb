# Huni-RE-Verify (§22) CHANGELOG

> 역공학 정확성 + 런타임 동등성 검증 하네스. 라이브 RedPrinting을 기준 오라클로 한 차등/동등성 테스트.
> 최신 항목이 위. 상세 게이트·결함·교정 명세는 `07_gate/`, 재역공학 산출은 `huni-widget/01_reverse/redo-260623/`.

---

## 2026-06-23 — 첫 종단 실행 + 역공학 최신화(4월→6월) + 신규필드 재검증 + N3/N1 교정

### 1) 가격 파일럿 첫 검증 (4월 baseline) — V-PRICE NO-GO
- Phase 1~5 종단(asset-curator→golden-recorder→price-equivalence→codex high→verify-gate).
- 가격값(result_sum)은 라이브와 완전 일치(VP-2~6 GO)하나 **요청 본문 shape 발산 3건**으로 VP-1 FAIL → NO-GO.
  - **D1 HIGH** ATTB 타입(`"2"` string vs `2` number, red-adapter.ts:615)
  - **D2/D3 MED** 책자 reqBody에 `PRN_CLR_CNT`·`MTRL_CD` 발명(라이브 부재)
- codex high 합의 9/10·환각 0·VM-3 PASS. §6 fixture가 ATTB 값/타입·단일면 필드 부재 미검사로 침묵 통과(함정 #1 실증).
- 보존: `_prev/260623-april-baseline/`.

### 2) 역공학 원천 최신화 + 재역공학 강화 (R0~R3)
- **드리프트 진단**: 역공학 디옵 기반 widget.js(4월·450KB) vs 라이브(6월·587KB) **+137KB MAJOR**. RedEditorSDK MINOR(6.6.48·`sizing.type` 1필드), widget.css +17KB. sourcemap 전무·Vite IIFE → AST 디옵 폴백. BLOCKER 0(superset 확장). 산출 `01_reverse/drift-audit/`·최신 자산 `01_reverse/_latest/`.
- **R0~R3**(`redo-260623/`): Babel AST 등가보존 디옵(27,728줄) → widget_monitor 런타임 추출 → 신규 계약 정밀화 → execution-validate 16/18 + codex high 합의 9/10.
  - 신규 기능 라이브 검증: **Garage 업로더**(presigned e2e 200), **신규 14 가격필드**(라이브 수용+메타모픽), **신규 옵션군**(postPcs 29→49·접지/타공/귀돌이/글꼴/걸이), item_gbn offset2023/edicus/digital.
  - 갱신 계약 3종: `s3-upload-flow.UPDATED.md`·`price-engine-additions.md`·`option-schema-additions.json`(4월 원본 비파괴).

### 3) 가격 파일럿 재검증 (신규 14필드) — V-PRICE NO-GO
- 신규 14필드 전용 라이브 골든 8 보강(`02_golden/captures/new-fields-260623/`).
- **핵심 발견**: §6 재구성(4월 기반)이 신규필드를 **계약 진입점부터 미수신**(emit 0) → VP-1·VP-6 FAIL.
  - **N3 HIGH** 수량모델 A 래더 미구현 = 떡메/굿즈 **견적불가**(라이브 직접 비준)
  - **N1 HIGH** ADD_CLR_YN 미전송 = 색수 미상향 **저청구**(소스 메커니즘 확정, 라이브 발현상품 미식별)
  - N2 MED·N4 LOW·N5 LOW·**N6 신규**(codex 발굴 GSELGLV ATTB×10)
- codex high: N1 HIGH 확정·N3 HIGH 상향 입증(생성≠검증 가치). **R2 메타모픽 수치=스케일 아티팩트 확정**(6,350,000 = 12,700×500).

### 4) N3·N1 교정 (§6 04_build) + 독립 검증
- hw-builder 3층 교정(`contract/price.ts`·`product.ts`·`adapters/red/red-types.ts`·`red-adapter.ts`·`widget/stores`): `RedAddOptionInfo`+`buildModelALadder`(deob 15438-15444 verbatim)·ADD_CLR_YN 색수상향(SID_S→6/SID_D→12). vitest 159 green·tsc clean·모델B 회귀 0·INV-1 누출 0.
- verify-gate 독립 재판정: **N3 CLOSED**(라이브 TPBLMEO `pdt_add_option_info` MIN=20/ADD=10 직접 fetch→래더 생성+가격도달 비준), **N1 부분**(단위봉인 CLOSED·라이브 발현 보류).
- 정정: 기존 verdict/e2e-trace의 "538k/1.14M/3.01M"은 **ORD_CNT sweep**(PRN_CNT 래더 아님) — 측정차원 라벨만 정정, 결함·결론 유효.

### 5) 비밀 위생
- R2 캡처에서 라이브 토큰 노출 적발·전량 마스킹: `koiAccessToken` JWT 3건 + presigned URL 2건 → `[REDACTED]`. 워크스페이스 전수 재스캔 잔존 0.

### 잔여 (다음 세션)
- N1 발현 자재상품(ADD_CLR_YN="Y") 식별 → 라이브 저청구 비준 → N1 CLOSED.
- N6(GSELGLV/TPTKDFT ×10) 교정, N2/N4/N5 byte 정합(돈영향 0/LOW).
- N3·N1 교정의 §6 동등성게이트(05_qa) 재실행 → V-WIDGET·V-EDITOR 확대.
