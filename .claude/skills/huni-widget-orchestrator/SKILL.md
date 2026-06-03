---
name: huni-widget-orchestrator
description: >
  후니프린팅 인쇄 자동견적 위젯 구현 하네스 오케스트레이터. RedPrinting 위젯 역공학 보강(widget_monitor 라이브 테스트베드 활용) → 동작 구조 분석 + 국내외 베스트프랙티스 리서치 → 위젯 개발 요소 상세 명세 → React-in-Shadow-DOM 위젯 구현 → 경계면 교차 QA 까지 6인 에이전트(reverse-engineer/runtime-analyst/researcher/architect/builder/qa) 파이프라인으로 수행한다.
  '후니 위젯 구현', '인쇄 자동견적 위젯', '위젯 하네스 실행', 'huni-widget', '역공학 보강', '위젯 동작 분석', '위젯 명세 작성', '위젯 빌드', '위젯 QA', '위젯 다시 구현', '위젯 하네스 재실행', '위젯 업데이트', '특정 단계만 재실행', '상품 확대', '신규 상품 추가', '캘린더/스티커/굿즈 확대', '확대 스테이지', '라이브 캡처 선행' 요청 시 반드시 사용. 단순 질문은 직접 응답.
license: Apache-2.0
allowed-tools: Read, Write, Edit, Grep, Glob, Bash, Agent, AskUserQuestion, TodoWrite
metadata:
  version: "1.1.0"
  category: "domain"
  status: "active"
  updated: "2026-06-03"
  tags: "huni, widget, redprinting, shadow-dom, edicus, pipeline, agent-team, reverse-engineering"
---

# Huni Widget — 구현 하네스 오케스트레이터

후니 인쇄 자동견적 위젯을 **역공학 보강 → 구현** end-to-end로 산출하는 하이브리드 파이프라인. 핵심 출발점: `raw/widget_monitor/local` 은 동작 검증된 라이브 위젯 테스트베드(Shadow DOM + Edicus 연동 + postMessage 데이터 처리)이며, 추측이 아닌 라이브 런타임 관찰을 근거로 한다.

## 실행 모드: 하이브리드 파이프라인 (서브 에이전트)

기본은 서브 에이전트 파이프라인(`Agent` 직접 호출). Phase 2는 병렬, 나머지는 순차. 모든 Agent 호출에 `model: "opus"` 명시. **hw-builder는 메인 트리에서 실행**(단일 빌더·병렬 없음 + `git diff src/widget` INV-3 증명을 메인 트리에서 수행해야 하므로 worktree 미사용 — S1~S6 전례).

| Phase | 에이전트 | 실행 | 입력 → 산출 |
|-------|---------|------|------------|
| ① 역공학 보강 | hw-reverse-engineer | 순차 | 역공학자료+widget_monitor → `01_reverse/` |
| ② 동작분석 + 리서치 | hw-runtime-analyst, hw-researcher | **병렬** | 01_reverse → `02_analysis/`, `02_research/` |
| ③ 위젯 명세 | hw-architect | 순차 | 01·02 + DESIGN.md → `03_spec/` |
| ④ 구현 | hw-builder (메인 트리) | 순차 | 03_spec → `04_build/` |
| ⑤ QA | hw-qa | 점진적 | 04_build vs 03_spec/캡처/DESIGN → `05_qa/` |

## Phase 0: 컨텍스트 확인

워크플로우 시작 전 기존 산출물·입력 자산 확인:

```bash
ls _workspace/huni-widget/ 2>/dev/null
ls docs/reversing/red_reverse_engineer/ raw/widget_monitor/local/ 2>/dev/null
test -f .env.local && echo ".env.local OK" || echo ".env.local MISSING"
```

분기 규칙:
- `_workspace/huni-widget/` **없음** → **초기 실행** (Phase 1부터 전체)
- 존재 + 사용자가 **특정 단계만** 재요청 → **부분 재실행** (해당 에이전트만, 산출물 읽어 개선)
- 존재 + **신규 상품/카테고리 확대** 요청(예: "캘린더 확대", "스티커 추가") → **확대 스테이지 루프** 진입(아래 전용 섹션). `expansion-strategy.md` 로드맵 확인 후 캡처 선행 판단.
- 존재 + **새 입력/전면 재작업** → 기존을 `_workspace/huni-widget_prev/`로 이동 후 초기 실행
- 입력 자산(역공학/widget_monitor/.env.local/DESIGN.md) 누락 시 → 사용자에게 AskUserQuestion으로 확인 후 진행

## 데이터 흐름 (파일 기반)

작업 루트 `_workspace/huni-widget/`:

```
01_reverse/    역공학 보강 명세 (widget-runtime-spec, price-engine-reversed, editor-bridge-protocol, s3-upload-flow, option-schema-catalog, gaps-resolved)
02_analysis/   동작 구조 (runtime-behavior, sequence-diagrams, state-machine, cascade-rules, event-contract)
02_research/   베스트프랙티스 (bp-embed-widget, bp-react-shadow-dom, bp-pricing-ux, bp-editor-integration, research-summary)
03_spec/       구현 명세 (architecture, component-tree, state-management, price-engine, shadow-dom-strategy, editor-integration, api-contract, bundle-strategy, build-plan)
04_build/      위젯 구현 코드 (build-plan 지정 트리)
05_qa/         검증 (qa-report, boundary-matrix, regression-checklist)
```

규칙: 중간 산출물은 보존(감사 추적). 라이브 캡처 raw는 01_reverse/ 하위 captures/에. 비밀값은 산출물에 평문 금지.

## 실행 절차

### Phase 1 — 역공학 보강

`Agent`로 hw-reverse-engineer 호출(model opus). 프롬프트에 포함: 입력 경로(docs/reversing, raw/widget_monitor), .env.local RP 자격증명 사용, widget_monitor 라이브 구동으로 미검증 3대(S3 presigned·가격 rule·postMessage 라이프사이클) 보강, 산출 `_workspace/huni-widget/01_reverse/`. huni-widget-live-capture 스킬 사용 지시.

게이트: 01_reverse/gaps-resolved.md 에 보강 결과·잔존 미검증이 명시되었는가.

### Phase 2 — 동작 분석 + 베스트프랙티스 (병렬)

단일 메시지에서 `Agent` 2개 병렬 호출(model opus):
- hw-runtime-analyst → 02_analysis/ (라이브 동작 관찰, 시퀀스 다이어그램)
- hw-researcher → 02_research/ (BP 리서치, 출처 검증)

게이트: 시퀀스 다이어그램·캐스케이드 규칙이 구현 가능 수준인가 / 리서치에 Sources 있는가.

### Phase 3 — 위젯 명세

`Agent`로 hw-architect 호출(model opus). 입력 01·02 + DESIGN.md + .env.local. huni-widget-spec 스킬 사용. 산출 03_spec/ (특히 build-plan.md 우선순위).

게이트: 14 componentType↔shadcn 매핑·가격엔진·Shadow DOM 전략·**정규화 계약(data-contract)+어댑터(data-adapter)**·API 계약·build-plan 완비. 후니 DB 미정 → 위젯은 정규화 계약에만 의존하고 어댑터가 Red/후니 차이를 흡수하는 구조가 명세에 못박혔는가. 과설계 없는가.

### Phase 4 — 구현

`Agent`로 hw-builder 호출(model opus, **메인 트리 — worktree 미사용**: 단일 빌더이고 `git diff src/widget`/`src/contract` 0줄 INV-3 증명과 빌드 게이트를 메인 트리에서 수행해야 한다). huni-widget-build 스킬 사용. build-plan 우선순위 순서로 구현.

게이트: 빌드/타입체크 통과 증거. DESIGN.md 8 Critical Rules 준수.

### Phase 5 — QA (점진적)

`Agent`로 hw-qa 호출(model opus, general-purpose). huni-widget-qa 스킬. 경계면 교차 비교 + widget_monitor 레퍼런스 대비 동작 검증. 산출 05_qa/.

게이트: 경계면 매트릭스 PASS / DESIGN 규칙 체크 / 결함은 파일:라인·재현법 포함.

## 확대 스테이지 루프 (S1~Sn — 실제 주 작업)

초기 6-Phase 구축이 끝나면 위젯은 **상품 확대 루프**로 진화한다. 신규 상품/카테고리(디지털인쇄·스티커·포스터·아크릴·굿즈·캘린더…)를 정규화 계약에만 의존시키고 **어댑터+fixture만 추가**해 흡수한다. 핵심 불변식: **위젯 코어 0변경**(`git diff src/widget/ src/contract/` = 0줄). 로드맵·불변식 상세는 `03_spec/expansion-strategy.md` 참조.

각 스테이지는 4단계 루프(서브 에이전트 순차, model opus):

1. **캡처 선행 (fixture 미보유 시 임계경로)** — Red fixture가 없으면 라이브 캡처를 먼저 한다(추측 fixture 생성 금지 = baseline 오염). huni-widget-live-capture 스킬 + `scripts/capture-scaffold.cjs`(전체출력 redact 내장)로 신규 SKU의 `ORD_INFO`/옵션스키마/`price_gbn`/실가를 확보. 캡처 노트를 `05_qa/`에 남긴다.
2. **hw-architect 어댑터 명세** — 캡처를 기존 가격모델(PriceTable3D/SizeMatrix2D/FixedUnit/TieredDiscount) 중 어디에 매핑할지 필드 단위 대조. **신규 componentType "불요"가 디폴트 가설**(NC 변형 우선 — DS 카탈로그에 가격델타 전용 컴포넌트 부재가 S4·S5·S6에서 실증). 진짜 갭일 때만 NC dispatcher case 추가. 계약 변경 0 목표. 산출 `03_spec/{stage}-spec.md`.
3. **hw-builder 구현** — fixture 적재 + 어댑터 라우팅/분기만. `src/widget/**`·`src/contract/**` 0줄 diff가 GO 전제(INV-3). 빌드 게이트(tsc/vitest/build) 통과 증거. **버그 수정은 정당한 예외**(코어 캐시키 핫픽스 등). 확대 스테이지는 단일 빌더·병렬 없음이라 worktree 불요 — git diff 증명을 메인 트리에서 수행.
4. **hw-qa 비교 QA** — 경계면 교차 비교(캡처↔구현 round-trip, 어댑터↔계약, INV-3 git 증명, 가드). GO/NO-GO 판정. 정직성: 미검증·생략 항목은 은폐 말고 명시.

매 스테이지 후 산출물은 커밋 병행하고 `HANDOFF.md`·CLAUDE.md 변경이력을 갱신한다. **커밋 전 비밀값 스캔**: `grep -rlE 'eyJ...\.eyJ...\.' _workspace/huni-widget/` 0건 확인(캡처 respBody JWT 누출 방지).

## 에러 핸들링

| 상황 | 대응 |
|------|------|
| 에이전트 실패 | 1회 재시도(간소화 프롬프트). 재실패 시 해당 산출물 없이 진행하되 보고서에 누락 명시 |
| 라이브 캡처 실패(인증/네트워크) | 기존 캡처 데이터로 폴백, 해당 영역 미검증 표기 (은폐 금지) |
| 명세↔구현 불일치(QA FAIL) | hw-builder에 결함(파일:라인·기대·실제) 회신 → 수정 → 재검증. 최대 3회 |
| 상충 데이터 | 삭제 금지, 출처 병기하여 양쪽 보존 |
| 입력 자산 누락 | AskUserQuestion으로 사용자 확인 (오케스트레이터만 질문 가능) |

## 테스트 시나리오

**정상 흐름:** `_workspace/huni-widget/` 없음 → Phase 0 초기 실행 판정 → Phase 1 역공학 보강(라이브 캡처) → Phase 2 동작분석+리서치 병렬 → Phase 3 명세 → Phase 4 메인 트리 구현 → Phase 5 점진 QA PASS → 통합 보고.

**에러 흐름:** Phase 1에서 RP_EDITOR_TOKEN 만료로 라이브 캡처 실패 → `node extract-cookies.cjs`로 1회 갱신 재시도 → 재실패 시 기존 body-log.json/캡처로 폴백, gaps-resolved.md에 미검증 표기 후 Phase 2 진행.

**부분 재실행:** `_workspace/huni-widget/` 존재 + "컴포넌트 다시 구현" 요청 → Phase 0이 부분 재실행 판정 → hw-builder만 호출(03_spec 읽어 변경 모듈만) → hw-qa 재검증.

## CLAUDE.md 연동

본 하네스는 CLAUDE.md "하네스: Huni-Widget" 포인터로 등록됨. 변경 이력은 CLAUDE.md 테이블에 기록.
