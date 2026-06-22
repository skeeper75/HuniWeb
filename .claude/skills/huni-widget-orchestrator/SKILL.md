---
name: huni-widget-orchestrator
description: >
  후니프린팅 인쇄 자동견적 위젯 구현 하네스 오케스트레이터. RedPrinting 위젯 역공학 보강(widget_monitor 테스트베드)
  →동작 분석+베스트프랙티스 리서치→상세 명세→React-in-Shadow-DOM 구현→경계면 교차 QA→후니 시각재현 정합까지
  7인 에이전트(reverse-engineer/runtime-analyst/researcher/architect/builder/qa/design-fidelity) 파이프라인.
  트리거: 후니 위젯 구현, 인쇄 자동견적 위젯, huni-widget, 역공학 보강, 위젯 동작 분석, 위젯 명세, 위젯 빌드, 위젯 QA, 시각재현/디자인 정합, 상품 확대, 위젯 하네스 재실행, 특정 단계만 재실행. 단순 질문은 직접 응답.
license: Apache-2.0
allowed-tools: Read, Write, Edit, Grep, Glob, Bash, Agent, AskUserQuestion, TodoWrite
metadata:
  version: "1.3.0"
  category: "domain"
  status: "active"
  updated: "2026-06-03"
  tags: "huni, widget, redprinting, shadow-dom, edicus, pipeline, agent-team, reverse-engineering, code-parity, independent-verification, team-crossverify"
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
| ⑥ 시각재현 | hw-design-fidelity | 순차(빌드 후) | 04_build + 02_analysis(Red구조) + huni-design-system/DESIGN.md(후니스킨) → `06_fidelity/` |

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
06_fidelity/   시각재현 정합 (fidelity-report, skin-mapping, conflicts, captures/before·after)
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

### Phase 6 — 시각재현 정합 (빌드 후)

`Agent`로 hw-design-fidelity 호출(model opus, general-purpose, 메인 트리). huni-widget-design-fidelity 스킬 사용. 이미 빌드된 `04_build` 위젯의 외형을 후니 디자인에 정합한다. **권위 분리 불변 규칙:** 배치·옵션 캐스케이드·인터랙션 흐름은 Red 구조(`02_analysis/`) 보존, 색·폰트·간격·외형만 후니 스킨(huni-design-system 스펙 + DESIGN.md)으로 입힘. 베이스라인 측정 → 후니 기준 대조 → 외형 스킨 정합 → 회귀 가드 → 스크린샷 diff + 수치 재대조. 산출 `06_fidelity/`.

게이트: 구조 무변경 증명(`git diff` 에서 캐스케이드·상태관리·핸들러·배치 0줄, 외형 토큰/스타일만). 후니 8 Critical Rules·토큰 일치. 충돌은 `conflicts.md`에 출처 병기. 후니 스펙 갭은 임의 디자인 없이 보고. hw-qa 경계면 매트릭스가 정합 전후 동일.

## 확대 스테이지 루프 (S1~Sn — 실제 주 작업)

초기 6-Phase 구축이 끝나면 위젯은 **상품 확대 루프**로 진화한다. 신규 상품/카테고리(디지털인쇄·스티커·포스터·아크릴·굿즈·캘린더…)를 정규화 계약에만 의존시키고 **어댑터+fixture만 추가**해 흡수한다. 핵심 불변식: **위젯 코어 0변경**(`git diff src/widget/ src/contract/` = 0줄). 로드맵·불변식 상세는 `03_spec/expansion-strategy.md` 참조.

각 스테이지는 4단계 루프(서브 에이전트 순차, model opus):

1. **캡처 선행 (fixture 미보유 시 임계경로)** — Red fixture가 없으면 라이브 캡처를 먼저 한다(추측 fixture 생성 금지 = baseline 오염). huni-widget-live-capture 스킬 + `scripts/capture-scaffold.cjs`(전체출력 redact 내장)로 신규 SKU의 `ORD_INFO`/옵션스키마/`price_gbn`/실가를 확보. 캡처 노트를 `05_qa/`에 남긴다.
2. **hw-architect 어댑터 명세** — 캡처를 기존 가격모델(PriceTable3D/SizeMatrix2D/FixedUnit/TieredDiscount) 중 어디에 매핑할지 필드 단위 대조. **신규 componentType "불요"가 디폴트 가설**(NC 변형 우선 — DS 카탈로그에 가격델타 전용 컴포넌트 부재가 S4·S5·S6에서 실증). 진짜 갭일 때만 NC dispatcher case 추가. 계약 변경 0 목표. 산출 `03_spec/{stage}-spec.md`.
3. **hw-builder 구현** — fixture 적재 + 어댑터 라우팅/분기만. `src/widget/**`·`src/contract/**` 0줄 diff가 GO 전제(INV-3). 빌드 게이트(tsc/vitest/build) 통과 증거. **버그 수정은 정당한 예외**(코어 캐시키 핫픽스 등). 확대 스테이지는 단일 빌더·병렬 없음이라 worktree 불요 — git diff 증명을 메인 트리에서 수행.
4. **hw-qa 비교 QA** — 경계면 교차 비교(캡처↔구현 round-trip, 어댑터↔계약, INV-3 git 증명, 가드). GO/NO-GO 판정. 정직성: 미검증·생략 항목은 은폐 말고 명시.

매 스테이지 후 산출물은 커밋 병행하고 `HANDOFF.md`·CLAUDE.md 변경이력을 갱신한다. **커밋 전 비밀값 스캔**: `grep -rlE 'eyJ...\.eyJ...\.' _workspace/huni-widget/` 0건 확인(캡처 respBody JWT 누출 방지).

## 코드 레벨 구조 정합 검증축 (S0~S3 — 캡처 표본을 넘어선 권위)

캡처 표본(라이브) 동등성은 필요조건이나 충분치 않다. 표본이 단순 케이스만 쓰면 구조 결함을 못 본다. 역공학 소스코드(`docs/reversing/red_reverse_engineer/03_deobfuscated/` 4모듈: app_api/widget_sdk/components/editor_sdk)를 **권위 명세**로 삼아 신규 구현과 책임·로직·분기 재현 동등(라인 답습 아님)을 전수 대조한다. "전 상품"은 캡처 표본이 아니라 **코드가 분기하는 모든 경로**.

| 단계 | 내용 | 산출 |
|------|------|------|
| S0 | 역공학 4모듈 구조 전수 지도(책임·상품분기 인벤토리) | `07_parity/red-code-map-*`, `red-code-structure-map` |
| S1 | 도메인별 대응 매트릭스 → 갭 전체지도(완전재현/부분/누락/상이) | `parity-matrix-*`, `parity-gap-map` |
| S2 | 전 상품 분기 커버리지(itemGroup×컴포넌트 vs 우리 커버) | `parity-matrix-S2` |
| S3 | 갭 보정(리스크 오름차순 웨이브) + 독립 재검증 | 보정 + `*-verification` |

### 독립 재검증 게이트 [HARD]
모든 보정 라운드: builder 보정 → **hw-qa 독립 재검증(직접 재실행·캡처 field-for-field 대조·vite-node probe·실렌더) → GO**. builder 자기보고는 GO 근거로 불충분. (실증: 자기테스트가 통과시킨 F-2 직렬화 shape·C-A/C-B 잠복부채·G-1 ATTB 누락을 독립검증이 적발.)

### 검증 메타 원칙 (팀 교차검증 도출) [HARD]
1. **분기 도달 증명**: "RESOLVED" 선언 전, 그 분기를 실제 traverse하는 fixture/probe 존재를 명시. 없으면 "PARTIAL-stub(미도달)"로 재분류. (주석+타입+테스트통과만으론 타우톨로지.)
2. **field-for-field 직렬화 대조**: 어댑터 출력 reqBody를 라이브 캡처와 값 단위 단언(componentType/groupId 단언만으론 불충분 — fixture가 HTTP 우회 시 shape 결함 침묵).
3. **왕복·전이 양방향**: disable 단방향이 아닌 disable→re-enable 복원까지.
4. **상품별 분기 vs PCS전역**: Red의 product-keyed 규칙(MATERIAL_PCS_CODE_MAP·roundingConfigMap·accFilterConfigMap)을 어댑터가 PCS전역으로 평면화하지 않았는지.

### 실행 모드: 팀 vs 서브 [HARD]
- **에이전트 팀(`TeamCreate`)**: 다중 렌즈 분석·교차 재검증 — 발견 공유·상충 토론·누락 보완·자가 오탐 정정이 품질을 높이는 단계. 예: 코드정합 교차검증 3렌즈(authority/integration/assumption, `SendMessage` 자체조율). 단 `.claude` 파일 수정은 untracked라 worktree 불가 → 직접/foreground.
- **서브 에이전트**: 단일 회의적 독립 검증(hw-qa), 단일 테스트베드 공유 순차 캡처, 같은 트리 write+test 반복 보정(worktree node_modules/머지 비용 회피).
- 도구를 작업 성격에 맞춘다: **발견=팀, 단일 독립검증·순차 보정=서브.**

### HARD 도메인·불변
- **RedPrinting PRICE=0 불가**: 위젯이 PRICE=0 받으면 항상 우리측 결함 신호(세션/필드/규격/엔드포인트)이지 Red 정상반환 아님. 0=격리 대상이 아니라 진단·수정 신호. `mapPriceResponse`는 0 시 `ok:false` + 명시 진단 사유(`priceUnavailableReason`; throw는 미캡처 fixture 보존 위해 회피). 가격 동등성은 **PRICE>0 실측 기준선으로만** 검증.
- **INV 완화 조건**: 위젯 코어 0줄은 확대에 적용. 버그·구조결함 보정은 정당 예외 — 코어 최소 + 계약 additive-optional + `git diff --stat` 전수 명시·1줄 정당화.
- **신규 leaf 사전정당**: 신규 컨트롤은 사전 정당화(왜 기존 14종으로 불가) 없이 금지. 플래그 분기(`group.multiple`) 우선, 신규 dispatcher case 회피.
- **커밋 완결성**: 커밋 후 HEAD 상태에서 게이트(tsc/vitest/build) 재확인. 워킹트리 통과 ≠ 커밋트리 통과(예: isReadyToOrder BFF 배선 누락).

## 실행 지침 (사용자용)

**트리거 표현**: "위젯 하네스 실행", "코드 정합/구조 정합", "전 상품 정합", "팀으로 재검증", "독립 재검증", "보정 웨이브", "확대 스테이지", "시각재현" 등(description 키워드). 단순 질문은 직접 응답.

**입력 자산(read-only)**: `docs/reversing/red_reverse_engineer/`(역공학 4모듈), `raw/widget_monitor/local/`(라이브 테스트베드, `node server.js`→:3001), `_workspace/huni-widget/04_build`(구현), `07_parity/`(정합 산출), `.env.local`(RP/Edicus 자격).

**단계별 지시 예시 (사용자가 이렇게 말하면 됨)**:
- 동등성 검증: "후니 위젯이 Red와 같이 동작하는지 검증" → 캡처 게이트 + 코드정합 S0~S3
- 코드 정합: "역공학 코드 기준 전 상품 정합 확인" → S0 지도부터 단계별
- 보정: "발견된 갭 보정" → 리스크 오름차순 웨이브, 각 웨이브 후 독립 재검증
- 팀 교차검증: "팀으로 재검증해서 놓친 것 찾아" → `TeamCreate` 다중 렌즈
- 확대: "캘린더/스티커 확대" → 확대 스테이지 루프(캡처 선행 판단)
- 부분: "S3 보정만" / "특정 단계만 재실행" → Phase 0 부분 재실행 판정

**검증 게이트 호출**: 보정/구현 후 "독립 재검증" 명시 요청 → hw-qa가 자기보고 불신·직접 재실행으로 GO/NO-GO. 기준: tsc 0 / vitest green / build OK / `git diff` 코어 최소 / 캡처 field 대조 / 왕복 복원.

**실행 모드 선택**: 다중 렌즈 분석·교차검증은 "팀으로", 단일 검증·순차 보정은 기본(서브). 강제 시 명시. 팀 모델은 `workflow.yaml` default_model: opus(추론집약 하네스). **하네스 전체 팀 모드 실행 절차·제약은 `_workspace/huni-widget/TEAM-MODE-GUIDE.md` 참조**(전제 확인·트리거·팀/서브 매핑·TeamCreate 워크플로우·하이브리드 예시).

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
