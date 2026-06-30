# recompute-log-booklet-cover-branch.md — 골든 독립 재계산 로그

> hpe-validator · 2026-06-30 · 라이브 t_prc_component_prices verbatim 단가(designer dict 미사용)로 손계산.
> evaluate_price 의미(component_subtotal: 단가형 unit_price×qty·min_qty tier 조회) 동치 재구현.

## 단가 출처 (라이브 SELECT 실측 = 권위 엑셀 260527 byte 일치 확인)
- COMP_BIND_JUNGCHEOL PROC_000018: m=1→3000, m=100→700, m=1000→500 (제본!중철열)
- COMP_BIND_TWINRING PROC_000021: m=50→1500 (제본!트윈링열·단 동 comp에 PROC_018/019/020도 보유=다중행)
- COMP_PRINT_DIGITAL_S1 SIZ_000499(국4절=316x467) POPT_000001(칼라단면): m=50→550, m=100→350
- 동 POPT_000002(칼라양면): m=100→700
- COMP_COAT_MATTE SIZ_000499 coat_side=1: m=50→700, m=100→500 / side=2: m=100→1000
- COMP_PAPER SIZ_000499: MAT_000073(백모120)→36.88, MAT_000078(아트150)→46.65
- COMP_HC_MUSEON_COVERBIND: m=1→34100, m=100→7969 (가산형 통합단가)

## G-CB-068A (중철·단면 백모120 무광·100부·cover_mult=1)
- 표지인쇄 350 × 100 = 35,000
- 표지코팅 500 × 100 = 50,000
- 표지용지 36.88 × 100 = 3,688
- 제본 JUNGCHEOL 700 × 100 = 70,000
- **부모소계 = 158,688.00** ≡ designer 158,688 → **PASS (오차 0)**

## G-CB-068B (068A 표지만 양면)
- 표지인쇄 양면 700 × 100 = 70,000 / 코팅 양면 1000 × 100 = 100,000
- **부모소계 B = 243,688** / Δ = 243,688 − 158,688 = **+85,000** ≡ designer → **PASS**
- 갈린 구성요소: 없음(양면 단가가 POPT_000002·coat_side=2로 정상 흐름).

## G-CB-071 (트윈링·단면 아트150 무광·50부·cover_mult=2)
- cover_sheets = 50 × 2 = 100 → tier=100매 조회
- 표지인쇄 350 × 100 = 35,000 / 코팅 500 × 100 = 50,000 / 용지 46.65 × 100 = 4,665
- 제본 TWINRING PROC_000021 m=50 → 1500 × 50부 = 75,000
- **부모소계 = 164,665.00** ≡ designer 164,665 → **PASS (주값 오차 0)**
- ★갈린 지점(designer 비교주석 오류): designer "×1이면 50×350=17,500"은 단가 350 고정 가정.
  실제 엔진은 cover_sheets=50이면 tier=50매=**550** → 50×550=**27,500**(코팅도 700→35,000).
  → designer cover_mult 모델이 tier 조회에까지 영향을 줌을 간과. 주값(×2=100매)은 정확하나
  비교 설명이 부정확. E6 보정·D-CB-5.

## G-CB-077 (레더HC·내지 mint 후 가정)
- designer 가정: PRF_HC_MUSEON_SET COVERBIND m=100=7969 × 100 = 796,900 (표지+제본 통합)
- **라이브 재현 불가**: `SELECT frm_cd FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000077'` = **0행**.
  077은 COVERBIND 공식이 바인딩돼 있지 않음 → 표지+제본 전액 미산정(견적 0원).
- 갈린 지점: 골든 전제(부모공식 존재)가 라이브와 불일치. 077 현행 = 0원(전 비목 누락).
  → "현행 0 vs 정답(COVERBIND+내지)" 양면 표기 정정. D-CB-2 Critical.

## G-CB-082 (하드커버링·내지 mint·COVERBIND ×2 결판)
- **라이브 재현 불가**: 082 공식 0행·표지083 공식 0행. 표지/제본/내지 전액 미산정.
- Q-CB-082(COVERBIND 1면 vs 2면)는 082에 COVERBIND가 바인딩된 후에야 결판 가능 — 현재 미바인딩.
- 갈린 지점: D-CB-2 Critical(077 동형).

## 종합
- 068A/068B/071 주값 = 허용오차 0 재현 PASS (verbatim 일치).
- 077/082 = 골든 전제가 라이브 미바인딩과 불일치 → 골든 정정 필요(결함 자체는 실재·더 심각).
- designer 단가 전건 라이브/권위 byte 일치(날조 0)·도수 칼라/흑백 라벨만 보정.
