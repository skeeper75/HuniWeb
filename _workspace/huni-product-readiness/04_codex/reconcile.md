# Reconcile — Claude vs Codex (hpr-codex-verifier)

> Claude 1차 독립 점검(scorecard 집계 재현)과 Codex 2차 독립 가설을 대조.
> 분류는 **합의=고신뢰 / 불일치=조사**로만(채택은 scorecard-gate). codex 주장=가설(라이브/권위 검증 전 사실 아님).
> 평가일 2026-06-30. codex 가용(gpt-5.5·high).

---

## A. 합의 (양측 독립 도달 = 고신뢰)

| # | 합의 사항 | Claude 근거 | Codex 근거 | 위상 |
|---|-----------|-------------|------------|------|
| A1 | **D5=PASS 골든 미대조 — L3+ 83건 전부 과대평가 후보** | 근거 컬럼 grep: PR=/money_delta = **0/83**, calc=OK만 80, calc=PRICED 3 | 동일 재집계 0/83·L2/L2+ cap 권고 | ★최중대·돈크리티컬 |
| A2 | **silent-merge 7 FAIL 중 현재 과청구 닿는 건 = 020·042·047(calc=OK·bound)** | 셋 다 calc=OK·D11=FAIL·L3 확인 | 동일 3건 지목 | 돈크리티컬 |
| A3 | **나머지 4 FAIL(034·037·040·048)=미과금(바인딩/축 미해소 시 잠재)** | 034/037/048=UNSCORED·040=UNBOUND | 동일 | 잠재 |
| A4 | **PRICED-0/BLOCKED 6건 위젯 wave 누수 없음** | 051/132/135=L2·077/082/088=L1 → W미진입 | 동일 | 정상 |
| A5 | **WARN-12 자기부품(050·071·108/109/111/112·153·174/175)=오염 아닐 가능성 큼(FP 가드 적절)** | 재질/제본부품/봉투용지 | codex 동의 | false-positive 회피 정상 |
| A6 | **반제품(30)/기성(20) 100%·L1/L2 — 위젯 누수 없음(정상 구멍)** | 등급이 L1/L2로 자동 차단 | codex 동의 | 정상 |

## B. 불일치 / 조사 대상 (라이브·권위 확정 필요)

| # | 조사 대상 | 생성측(평가/스케줄) | Codex 가설 | 조사 방법 |
|---|-----------|---------------------|------------|-----------|
| B1 | **W2 돈크리티컬 누수 020·042·047** | 스케줄러 주장: "돈크리티컬 silent 합산은 전부 L2 이하로 자동 차단됨"(widget-constraint-schedule.md:15) | **반증** — 셋 다 L3/W-CASCADE라 W2(L3 19) 포함. D5만 게이트라 D11=FAIL이 등급 미cap | scorecard 등급 게이트에 D11=FAIL→위젯 차단 규칙 추가 여부 결정(gate) |
| B2 | **WARN-12 재승격 후보 3(136·138·139·calc=OK)** | 평가자: FP가드 WARN(설치/마감 부속·자기부품 가능) | codex: calc=OK라 현재 과청구 가능·"본체포함 vs addon" 권위 확인 | 상품 공식 전수 펼침 + §21 RC-2 현수막 큐방/끈 addon 처리 재확인(메모리상 일부 해소) |
| B3 | **LIVE_UNBOUND/DESIGNED_NOT_LOADED ∧ L4 100%(147~152 아크릴·문구 다이어리류)** | D5=PASS·L4·100% | codex: "미바인딩/미적재" 표식과 L4 PASS 모순=환각 PASS 후보 | 라이브 evaluate_price 실호출(아크릴은 메모리상 일부 COMMIT됨 — pfm 플래그 stale일 수 있음) |
| B4 | **23 WARN 판형 "공식 바인딩 후 보류" 느슨함** | 스케줄러: 공식 미바인딩과 겹쳐 보류 | codex: 상당수 UNSCORED-축미탑재(공식 이미 보임)·지금 simulate로 best-plate=0 확인 필요 | 명함031~034·책자068~071·봉투050 밴드/사이즈 직접 simulate |
| B5 | **종이류 플래그 의심** | 066 종이류=Y·D10 WARN / 019·025·039 종이류=N·D10 N/A | codex: 066 스티커 고정가면 판형 FP / 투명소재 생산상 판형 쓰면 missed D10 | 라이브 plate_sizes·생산 메타 확인 |

## C. codex 반박 (생성측 주장 직접 부정) — gate 필수 검토

- **C1 [B1과 동일]**: 스케줄러의 핵심 안전 보증 "돈크리티컬 silent 합산·×qty 과대청구 의심은 위젯 wave에 절대 포함 금지 … 전부 L2 이하로 떨어져 자동 차단됨"(widget-constraint-schedule.md:15)은 **020·042·047에 대해 거짓**. 이 3건은 D11=FAIL이지만 D5=PASS라 L3로 남아 W2에 산입됨. 등급 게이트가 D5만 보고 D11(돈크리티컬)을 cap하지 않는 **구조적 누수**. → gate가 (a) D11=FAIL이면 위젯 wave 제외 플래그를 강제하거나 (b) 등급 사다리에 D11 cap을 추가할지 결정해야 함.

## D. false-positive 정리 (codex가 평가자 FP 가드를 지지 / 또는 codex가 FP를 지적)

- **평가자 FP 가드가 적절(codex 지지)**: WARN-12 자기부품 8건(A5) — 오염으로 단정 안 한 것이 옳음.
- **codex가 지적한 잠재 FP(평가자측)**: 066 합판도무송스티커 판형 요구(스티커 고정가면 판형 불요) → B5에서 조사.

---

## 집계
- **합의(고신뢰) 6** (A1~A6) — D5 과대평가·silent-merge 분류·PRICED-0 무누수·FP 가드 적절 등 핵심 골격 일치.
- **불일치/조사 5** (B1~B5).
- **codex 반박 1** (C1·B1 = 위젯 누수, gate 필수).
- **false-positive 정리**: 평가자 FP 가드 지지 1(자기부품 8건)·codex 지적 잠재 FP 1(066 판형).

## 한계
- codex·Claude 모두 **파일 근거만**(라이브 evaluate_price 미실호출). A1(골든 미대조)·B3(LIVE_UNBOUND 모순)은 **라이브 simulate로만 사실 확정** — scorecard-gate의 D5 실측이 결정.
- 독립성 위해 codex에 Claude 판정 비노출. 본 reconcile은 두 독립 산출의 사후 대조.
