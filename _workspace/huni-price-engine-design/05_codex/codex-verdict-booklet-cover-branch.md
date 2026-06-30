# codex-verdict-booklet-cover-branch.md — Codex 독립 2차 판정 (Phase 5.5)

> **hpe-codex-validate 방법론.** Codex(gpt-5.5·read-only·effort=high)가 책자 표지 펼침/개별 분기 설계를
> **hpe-validator 판정 비노출** 상태로 독립 재판정. 이 문서는 codex 원문 + 각 주장 `미검증` 분류.
> ★codex 주장 = **외부 의견·가설**. 라이브 후니 스키마·권위 엑셀·엔진계약 재실측 전엔 사실로 채택 금지(환각 경계).
> 실행: `codex exec -m gpt-5.5 -s read-only -C 03_design root -c model_reasoning_effort=high` · session 019f18a8 · 토큰 31,323 · exit 0.
> 프롬프트: `05_codex/_codex-prompt-booklet-cover-branch.md`(설계 사실+엔진계약+골든만·우리 E1~E7 판정 미포함).

---

## 0. codex 가용성

- **AVAILABLE · model=gpt-5.5 · sandbox=read-only · reasoning effort=high** (정상 호출·exit 0).
- 폴백 불요(gpt-5.5 1차 성공). Codex 미가용 아님.

## 1. codex 종합 결론 (원문)

> **결론: FAIL. 최종 판정 NO-GO.**
> "현재 설계는 '표지 펼침/개별' 개념 자체는 타당할 수 있지만, 제시된 현행 엔진 계약으로는 그대로 가격계산
> 가능하지 않다. 핵심 결함은 `evaluate_price`가 공식 1개에 대해 **단일 qty만 받는데**, 설계는 같은 부모공식
> 안에서 표지비는 `cover_sheets`, 제본비는 `copies`라는 **서로 다른 qty**를 요구한다는 점."
> "설계를 살리려면 부모공식 안에서 component별 effective qty를 지원하도록 엔진 계약을 확장하거나,
> 표지/제본/내지를 서로 다른 `evaluate_price` 호출 단위로 분리해야 한다. 현재 C2 그대로는 가격계산 가능 설계가 아니다."

## 2. 항목별 codex 판정 (원문 요약 + `미검증` 분류)

### Q1. 상품별 가격계산 가능 여부

| 상품 | codex 판정 | codex 근거 | 분류 |
|------|:----------:|------------|------|
| 068 중철 | **FAIL** | 부모공식 제본비 1개뿐·표지/내지/용지 누락·제본비만 청구 | 라이브 실측 정합(미검증→검증가 E2 확정) |
| 069 무선 | **FAIL** | 동일 | 동 |
| 070 PUR | **FAIL** | 동일 | 동 |
| 071 트윈링 | **FAIL** | 제본비만 + proc_cd 미주입 시 4종 silent 합산 위험 | 동 |
| 072 하드커버 | **PARTIAL/UNSURE** | COVERBIND+내지284 구성원 있어 0원 아닐 가능성·단 COVERBIND 표지포함이면 표지 별도배선 double-count | `미검증 가설`(COVERBIND 내장범위 권위 미확인) |
| 077 레더HC | **FAIL** | 부모공식 0행·내지보다 **표지/제본 부모가격 자체가 0이 더 선행** | 라이브 실측 정합 |
| 082 하드커버링 | **FAIL** | 부모공식 0행·내지 누락보다 표지/제본 전체 미바인딩이 더 치명 | 동 |
| 094 엽서북 | **PASS 가능** | PCB 완제품가 통째 내장이면 계산 가능·단 구성원 별도과금 시 double-count 확인 | `미검증 가설` |
| 100 포토북 | **PASS 가능/검증필요** | base24+per2p+내지공식 있으면 가능·부모fixed vs 구성원내지 중복과금 확인 | `미검증 가설` |

### Q2. cover_mult ×2 모델 ↔ 엔진계약 — **FAIL** (codex 핵심 적발)
- cover_mult 아이디어(트윈링 앞뒤 2장→×2)는 물리적으로 그럴듯. 단 **구현안 C2가 깨짐**.
- 부모공식 안에 표지인쇄/코팅/용지=`qty=cover_sheets`·제본비=`qty=copies`가 **함께** 들어가는데
  `evaluate_price(prd_cd, selections, qty)`는 공식 전체에 **qty 하나만** 준다.
- 따라서:
  - 부모공식 qty=`copies=50` → **트윈링 표지 3비목 절반 저청구**(89,665 의도가 절반 수준으로).
  - 부모공식 qty=`cover_sheets=100` → **제본비 2배 과청구**(1,500×100=150,000·정답 75,000 대비 +75,000).
- "현행 엔진에 component별 qty override가 없다면 C2는 실제 구현 불가."
- 분류: **엔진계약 위반 적발 — 검증가 E4(D-CB-3)와 독립 합치**(아래 reconcile §A1).

### Q3. cover_sheets ↔ min_qty TIER — **FAIL / 돈크리티컬** (codex 적발)
- cover_sheets를 qty로 넣으면 "매수만 2배 곱"이 아니라 **min_qty tier 조회도 바뀐다**.
- G-071: copies=50인데 표지 component를 cover_sheets=100으로 평가하면 표지 인쇄/코팅/용지 단가가 **100매 tier**로 선택됨.
- "이게 맞는지는 가격표 권위가 필요. 출력소 관점 표지 100장이면 100매 tier 맞을 수 있으나, 주문부수 기준 tier라면 50 tier가 맞다."
- ★"설계자가 말한 '×2만 한다'가 아니라 **tier 자체가 변한다**. 수량↑→단가↓ 구조라면 cover_sheets=100 적용이 표지 단가를 낮춰 **저청구**할 수 있다."
- 분류: **검증가 E4 보정#2와 독립 합치**(미검증→권위 표지단가 tier 기준 대조 필요).

### Q4. 077/082 미바인딩 실제 누락 — **FAIL**
- 설계자는 "내지 누락" 강조했으나 **더 선행 결함 = 부모공식 0행**(표지/제본/내지/부모공식 전부 없음).
- "G-077의 COVERBIND ×100=796,900은 현재 재현 불가. COVERBIND 가정일 뿐 라이브 바인딩 없으니 엔진에서 부모 기여=0."
- "내지 누락은 맞지만 **2차 결함**. 1차 결함은 상품 자체가 가격공식 미바인딩."
- 분류: **검증가 E6 보정·D-CB-2(Critical)와 독립 합치**(077/082 견적 0원).

### Q5. 이중계상/silent 합산
1. 표지 ×2: "단가 출력 1매 기준 권위가 맞다면 이중계상 아님. 그러나 통합형 COVERBIND가 이미 표지 포함이면 표지인쇄/코팅/용지 추가배선 순간 **double-count**." → 조건부(분해형=OK·통합형 혼용=위험)
2. COMP_PAPER 표지/내지 양쪽: "combo_key/component instance 분리돼야. 같은 공식 안 같은 COMP_PAPER 두 용도+선택축 충돌 시 silent 합산 또는 한쪽 누락 위험." → ★codex는 frm_cd 분리를 못 봐서 위험으로 봄(검증가는 frm_cd 분리 실측으로 PASS)
3. proc_cd 미주입: "TWINRING 4 proc_cd×8 tier·미주입 시 4행 매칭·엔진이 다중행 합산하면 071에서 중철+무선+PUR+트윈링 제본비 전부 붙는 **silent overcharge**. C6 고정주입 필수." → 검증가 D-CB-4와 합치

### Q6. 068~071 현재 상태 — **FAIL**
- 제본비 1개 component만 → 068=중철제본비만·069=무선만·070=PUR만·071=트윈링만.
- "표지 인쇄/코팅/용지·내지 인쇄/용지 전부 빠짐. 견적 0원은 아니어도 실가격 큰 부분 누락 저청구."
- 분류: **검증가 D-CB-1(High)과 독립 합치**.

### Q7. 추가 돈크리티컬 경로 (codex 발굴)
- **부모공식 단일 qty 충돌** — "가장 큰 결함"(Q2 재강조).
- **tier 기준 혼동** — copies tier vs cover_sheets tier 권위 없으면 표지 단가 오선택.
- **통합형+분해형 혼용** — COVERBIND 표지포함인데 표지 component 추가 시 double-count.
- **미바인딩 상품** — 077/082 내지 이전에 표지/제본 전체 0원.
- **구성원 공식 0행** — sub_prd_qty 아무리 넣어도 구성원 공식 없으면 가격에 안 닿음.
- **다중매칭 silent 합산** — proc_cd/print_opt_cd/plt_siz_cd/min_qty 하나라도 미주입 시 다중행 합산.

---

## 3. ★codex 주장 신뢰도 분류 [HARD]

| codex 주장 | 분류 | 사유 |
|------------|------|------|
| 부모공식 단일 qty 충돌(표지 cover_sheets vs 제본 copies) | **고신뢰(엔진계약 정합)** | 검증가 E4가 라이브 pricing.py:193 `up*q` 단일 qty 실측 독립 확인·codex 독립 재도달 |
| cover_sheets가 tier 조회 변경 → 저청구 위험 | **고신뢰(돈크리티컬)** | 검증가 E4 보정#2 독립 합치·tier 의미 양 모델 독립 도달 |
| 077/082 부모공식 0행이 내지보다 선행 결함(견적 0원) | **고신뢰** | 검증가 E6·D-CB-2 독립 합치 |
| 068~071 제본비만=저청구 | **고신뢰** | 검증가 E2 라이브 실측 합치 |
| proc_cd 미주입 다중매칭 silent 합산 | **고신뢰** | 검증가 D-CB-4 실측(32행) 합치 |
| COMP_PAPER 표지/내지 충돌 위험 | **미검증 가설(반박됨)** | codex는 frm_cd 분리를 모름·검증가 E5 라이브 실측=PRF_BIND_*_SET vs PRF_DGP_INNER 분리로 **충돌 없음** 확정 → codex 위험은 라이브 사실에 반박됨 |
| 072 double-count 가능성(COVERBIND+표지 별도배선) | **미검증 가설** | COVERBIND 내장범위 권위 대조 전 보류·검증가 D-CB-6/Q-CB-082와 동류 |
| 094/100 구성원 별도과금 double-count | **미검증 가설** | codex가 PCB/PHOTOBOOK 완제품가 내장구조 미확인 추정·본 설계 범위 밖(별 검증 트랙) |

## 4. codex 신규 적발(설계자/검증가 대비 추가 각도)

- **C2의 "구현 불가" 단정** — 검증가는 D-CB-3을 "C트랙 or 표지 member 재설계"로 라우팅(해결 가능 전제)했으나,
  codex는 한발 더 나가 **"부모공식 직배선 C2는 그 자체로 실제 구현 불가"**라고 단정하고 두 해법(엔진계약 확장 /
  표지·제본·내지를 별 evaluate_price 호출 단위로 분리)을 제시. → 검증가의 "표지 member 재설계" 권고를 강화.
- **종합 NO-GO** — 검증가는 "조건부 GO(단일 FAIL 없음)"·codex는 "NO-GO". 결론 라벨 divergence(reconcile §C).
