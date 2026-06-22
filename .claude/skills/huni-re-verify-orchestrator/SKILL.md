---
name: huni-re-verify-orchestrator
description: 후니 RE-Verify 하네스(Huni-RE-Verify) 오케스트레이터. RedPrinting 위젯/SDK를 두 역공학 리포트(docs/reversing) + 최신 베스트프랙티스(차등/동등성 테스트·골든 마스터 record-replay·메타모픽)로 재검증하되, ★역공학한 코드가 실제로 동작/재현되는지를 라이브 RedPrinting을 기준 오라클로 한 차등 테스트로 입증하고, codex-cli high 독립 2차 교차검증(서브시스템별 reconcile)으로 환각을 가드한다. §6 huni-widget 재구성·05_qa 동등성게이트·raw/widget_monitor 테스트베드를 80% 재사용(역공학·테스트베드 재구축 금지). 7 에이전트(hrev-asset-curator 기준점 → hrev-golden-recorder 캡처 → hrev-price-equivalence·hrev-widget-behavior·hrev-editor-bridge 검사 팬아웃 → hrev-codex-verifier codex high 2차 → hrev-verify-gate K게이트 검증). 하이브리드(기준점→런타임 캡처→검사 병렬→codex 2차→독립 게이트)·생성≠검증·codex 주장=가설·라이브 읽기전용(주문/결제/폼submit 금지)·DB 미접속·검증+교정명세까지(실 수정은 §6 위임·인간 승인). 파일럿=가격계산 API. 트리거: '역공학 재검증', '역공학 코드 동작 검증', 'RedPrinting 위젯 동등성 검증', '역공학 런타임 검증', '골든 마스터 검증', '차등 테스트', 'codex high 교차검증', 'price-calc 동등성', 'RE-verify 하네스 실행/재실행/업데이트/보완', '특정 서브시스템만 검증'. 단순 질문은 직접 응답. 위젯 구현은 §6 huni-widget, 플로우 문서화는 §19, edicus 코드맵은 §20.
---

# Huni-RE-Verify 오케스트레이터

RedPrinting 위젯/SDK 역공학을 **다시 하지 않고**, 기존 역공학·재구성 위에 *런타임 동등성 검증 레이어*를 얹어 **"역공학한 코드가 실제로 동작/재현되는가"** 를 입증한다. 기준 기법은 **라이브 RedPrinting을 reference oracle로 한 차등/동등성 테스트**(골든 마스터 record-replay + Playwright strict POST 매칭 + 조합 fuzz/메타모픽), codex-cli high 독립 2차로 환각 가드.

근거 권위: `_workspace/huni-re-verify/_meta/re-methodology-research.md`(방법론·게이트·함정)와 `_meta/codex-high-spec.md`(codex high 운영). 시작 전 둘 다 읽어라.

## 핵심 불변식 [HARD]
- **생성 ≠ 검증** — 재구성/검사를 만든 패스는 자기 승인 금지. `hrev-verify-gate`가 라이브 재실측으로 독립 판정.
- **오라클 = 라이브** — 재구성이 라이브와 다르면 라이브가 옳다. Red 가격산식 내부 재유도에 재구성을 맞추지 마라(분석용·이식 금지).
- **codex 주장 = 가설** — 라이브/캡처 확증 전엔 사실 아님. codex 미가용 시 "Claude 단독" 명시 폴백(pending 금지).
- **무날조** — 모든 코드/동작 주장은 디옵 `파일:라인`·캡처 응답·라이브 런타임 인용. 못 하면 NO-GO.
- **PRICE=0 = 결함 신호** — Red는 PRICE=0 정당 반환 안 함. 0은 항상 우리측 결함(세션/필드/spec).
- **라이브 읽기전용** — 주문/결제/장바구니 COMMIT/폼submit/에디터 저장 0. DB 미접속. 비밀값은 `.env.local`에만, 골든/로그/스크린샷에서 `[REDACTED]`.
- **재사용 우선** — §6 `huni-widget/04_build`·`05_qa`·`07_parity`, `raw/widget_monitor/local` 재사용. 이미 입증된 차원은 재검증 금지(reuse-map에 근거).

## Phase 0 — 컨텍스트 확인
1. `_workspace/huni-re-verify/` 존재 여부 확인.
   - 미존재 → 초기 실행(Phase 1부터).
   - 존재 + 부분 수정 요청 → 해당 서브시스템/에이전트만 재호출.
   - 존재 + 새 입력(새 리포트·§6 갱신) → 기존을 `_prev/`로 보존 후 재실행.
2. `_meta/` 리서치 2종을 읽어 게이트·codex 운영을 로드.
3. 파일럿 범위 확인(기본=가격계산 API). 사용자가 다른 서브시스템/전체를 지정하면 반영.

## 실행 모드 — 하이브리드
| Phase | 모드 | 에이전트 |
|------|------|----------|
| 1 기준점 | 서브 | hrev-asset-curator |
| 2 골든 캡처 | 서브(런타임) | hrev-golden-recorder |
| 3 검사 팬아웃 | 서브 병렬 | hrev-price-equivalence ∥ hrev-widget-behavior ∥ hrev-editor-bridge |
| 4 codex 2차 | 서브 | hrev-codex-verifier (서브시스템별 reconcile) |
| 5 독립 게이트 | 서브 | hrev-verify-gate |

모든 Agent 호출에 `model: "opus"`. 병렬은 단일 메시지 다중 호출.

**파일럿 우선[기본]**: 첫 실행은 **가격계산 API만** 종단 완주(Phase 1→2(가격 골든)→3(price만)→4(price reconcile)→5(price 게이트)). GO 후 widget·editor로 동형 확대. 사용자가 "셋 다"면 Phase 3을 3-병렬로.

## Phase 1 — 기준점 (hrev-asset-curator)
자산 인벤토리 + 역공학 계약 추출 + 검증대상 매니페스트 + 골든 캡처 계획 + 재사용 맵. 산출 `01_inventory/`.

## Phase 2 — 골든 캡처 (hrev-golden-recorder)
widget_monitor 테스트베드 구동, 세션 fresh, 계획대로 골든 마스터 캡처(시나리오당 1 HAR), oracle sanity(PRICE≠0). 산출 `02_golden/`. **라이브 미가용 시** "골든 재생만" 신호로 인스펙터 라이브 차등을 강등(스킵을 PASS 위장 금지).

## Phase 3 — 검사 팬아웃 (3 인스펙터)
각 인스펙터가 자기 게이트(V-PRICE/V-WIDGET/V-EDITOR)로 §6 재구성 vs 라이브/골든 동등성 검사 → 결함 보드 + 검증셀. 산출 `03_price/`·`04_widget/`·`05_editor/`.

## Phase 4 — codex high 2차 (hrev-codex-verifier)
각 보드를 `codex-review.sh <prompt> gpt-5.5 <workdir> high`로 독립 2nd opinion → 서브시스템별 + 최종 reconcile. 산출 `06_codex/`. **미가용 시 Claude 단독 명시**.

## Phase 5 — 독립 게이트 (hrev-verify-gate)
보드·셀·reconcile를 라이브 재실측으로 독립 재판정 → V게이트 + 메타게이트(VM-1/2/3) GO/NO-GO + 교정 명세 + 종단 골든 추적. 산출 `07_gate/`.

## 데이터 전달 프로토콜
- 파일 기반(`_workspace/huni-re-verify/<NN_>/`)이 주 채널 + 반환값(서브 결과 수집).
- 파일명: `{phase}_{artifact}` 컨벤션. 중간 산출 보존(감사 추적).
- 비밀값은 어떤 파일에도 금지([REDACTED]).

## 에러 핸들링
- 에이전트 실패 → 1회 재시도, 재실패 시 해당 산출 없이 진행하되 verdict에 "누락" 명시(침묵 금지).
- 라이브 미가용 → 라이브 차등 게이트를 "미검증(라이브 필요)"로 강등, 골든 재생 게이트만 판정.
- codex 미가용 → VM-2를 "codex 입력 없음 — Claude 단독"으로 기록하고 진행(pending 금지).
- 상충 데이터 → 삭제 말고 출처 병기, verify-gate 재실측으로 판정.

## 테스트 시나리오
- **정상 흐름**: "프린트엽서/무선책자 가격계산 역공학 동작 검증" → Phase 1~5 가격 파일럿 → V-PRICE GO/NO-GO + 교정 명세 + codex reconcile.
- **에러 흐름**: 라이브 세션 만료 → golden-recorder가 extract-cookies 재실행 1회 → 실패 시 "골든 재생만" → verify-gate가 라이브 차등 항목을 "미검증"으로 명시 GO/NO-GO.

## 범위 밖 (다른 하네스)
- 위젯 **구현/빌드** → §6 huni-widget. 플로우 **문서화** → §19 huni-widget-flow. edicus.man **코드맵** → §20. 가격 **데이터 적재/교정** → §7 dbmap. 이 하네스는 *역공학 정확성 + 런타임 동등성 검증*까지(실 수정은 위임·인간 승인).
