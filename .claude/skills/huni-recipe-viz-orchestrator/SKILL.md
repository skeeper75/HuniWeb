---
name: huni-recipe-viz-orchestrator
description: >
  후니프린팅 상품 레시피·구성요소 시각화 하네스 오케스트레이터(codex 중심). 상품마스터 각 시트 각 상품의
  구성요소(자재·공정·옵션·사이즈·도수)를 한눈에 보는 시각화로 만들고, 구성요소 누락 시 견적 결과값이 안 나오는
  문제를 codex-cli(레시피 생성·연결 검증)+codex-imgage(mermaid→이미지 2단계)로 산출해, 상품 구성요소 연결·가격
  공식의 가격구성요소 설계 정합을 확인한다. 작업지시서/생산지시서형 레시피=인쇄자동견적 전 요소. ★[HARD] 산출
  본문은 codex(사용자 directive)·생성=codex/검증=Claude·codex 주장=가설. 트리거: 상품 구성요소 시각화, 레시피
  시각화, 구성요소 연결 확인, 가격구성요소 설계 확인, 작업지시서 레시피, 생산지시서, codex 레시피 시각화, 특정
  시트만 레시피, 시각화 다시, 연결검증 다시. 단일 상품 가격계산 검증은 §15 huni-quote-verify, 상품군 위키 집필은
  §9 print-kb가 담당.
---

# huni-recipe-viz-orchestrator — 상품 레시피·구성요소 시각화 하네스 (codex 중심)

상품마스터 각 시트의 상품 구성요소를 codex로 레시피화·시각화하고, 구성요소 연결·가격공식 설계 정합을 확인한다.

## 정체성·경계

- **목표**: 작업지시서/생산지시서형 **레시피**(견적에 필요한 전 요소) → 구성요소→가격 연결 **시각화**(한눈에) → 구성요소 연결·가격공식↔가격구성요소 설계 **정합 확인**(누락=견적 결과값 안 나옴 적발).
- **★codex 중심 [HARD·사용자]**: 산출 본문(레시피·시각화·연결진단)은 Claude가 아니라 **codex**(codex-cli `codex exec`·codex-imgage)가 만든다. Claude는 권위 입력 큐레이션·codex 호출·검증 게이트만.
- **★생성=codex / 검증=Claude**: codex 산출은 가설(환각 경계) → hrv-validator(Claude)가 라이브/권위 재실측으로 R1~R6 게이트.
- **경계**: §15 huni-quote-verify(단일 상품 가격계산 되는지·Claude+Codex 병행)·§9 print-kb(Claude 집필 레시피 위키)·§13 huni-price-quote(대표군 냉철 게이트)와 구별 — 본 트랙은 **전 상품·codex 산출·시각화 중심·레시피→연결**.

## 실행 모드: 하이브리드 (codex 생성 파이프라인 → Claude 검증)

- 생성 3 에이전트(recipe-builder·component-visualizer·connection-auditor)는 **codex를 호출**하는 Claude 에이전트(서브). 모두 `model: "opus"`.
- 검증 1 에이전트(hrv-validator)는 Claude general-purpose 독립 게이트.
- 시트/상품 단위 파이프라인. 신규 hrv-* 에이전트가 레지스트리 미로드면 general-purpose로 정의파일 읽혀 실행.

## Phase 0: 컨텍스트 확인

`_workspace/huni-recipe-viz/<sheet>/` 존재로 모드 판별:
- 미존재 = 초기 실행 / 존재+부분요청 = 부분 재실행(해당 에이전트만) / 존재+새 입력 = 새 실행(기존 `_prev`로 이동).
- codex 가용성 선판정: `codex-preflight.sh`(rpm-visualize/scripts) — AVAILABLE/AUTH_STALE/DEADLOCK. 미가용 시 각 에이전트가 명시 폴백(레시피·연결=Claude 최소·시각화=mermaid 단독·pending 금지). 사용자 directive가 codex 우선이므로 폴백은 명시·최소.

## Phase 1: 레시피 생성 (codex-cli)
- `hrv-recipe-builder` → `01_recipe/`: 상품별 작업지시서형 레시피(구성요소·자재·공정·옵션·사이즈·도수·가격공식·가격구성요소 = 견적 전 요소). codex 산출 본문 + 권위 출처 + GAP 보드.

## Phase 2: 시각화 + 연결검증 (병렬·codex)
- `hrv-component-visualizer` → `02_viz/`: **mermaid 먼저(진실 소스) → codex-imgage 이미지(검증 가능하게)**. 노드/엣지 인벤토리 + 누락 강조.
- `hrv-connection-auditor` → `03_audit/`: 레시피↔라이브 대조로 구성요소 연결·가격공식 설계 정합 검증(누락·오연결·차원 미스매치). codex 독립 판정.
- 두 에이전트 병렬(서로 독립 — 시각화는 레시피 기반·연결검증은 레시피+라이브). 단, 시각화 강조에 연결검증 산출을 쓰려면 audit 먼저 후 viz 순차도 가능(오케스트레이터 판단).

## Phase 3: 독립 검증 (Claude·생성≠검증)
- `hrv-validator` → `04_validation/`: R1~R6(레시피 권위충실·mermaid 정확·이미지↔mermaid 정합·연결진단 실재·codex 환각 적발·견적 완전성). GO/NO-GO + 발견 결함.
- NO-GO 시 해당 생성 에이전트 재호출(보정 폐루프).

## Phase 4: 종합
- 메인이 시트 산출 종합: 시각화(mermaid+이미지)·레시피·연결진단·검증 게이트. 누락(견적 결과값 안 나옴) 보드 + 인간 승인 큐(실 교정은 dbmap/§15 위임).

## 데이터 전달 프로토콜
- 파일 기반: `_workspace/huni-recipe-viz/<sheet>/{01_recipe,02_viz,03_audit,04_validation}/`. 파일명 `{phase}_{artifact}`.
- 반환값 기반: 서브 결과 메인 수집. 각 산출에 출처·확신도·codex 가용성.

## 권위·안전 규칙 [HARD]
- 권위 = 상품마스터260610 + 인쇄상품 가격표260527 절대. round-11 BOM·라이브 t_*는 보강. v03/STALE 금지.
- 라이브 `.env.local RAILWAY_DB_*` 읽기전용 SELECT만. codex `-s read-only`. 비밀값(_workspace·stdout·codex 프롬프트·이미지) 비노출.
- 생성≠검증: codex 생성 ↔ Claude 검증 독립. codex 주장=가설(라이브/권위 검증 전 채택 금지).
- DB 미적재: 시각화·레시피·검증 전용. 실 교정/COMMIT은 인간 승인 후 dbmap(dbm-load-execution 등)·§15 위임.

## 기존 자산 재사용
- codex 헬퍼: `rpm-visualize/scripts/codex-preflight.sh`·`hqv-codex-cross-verify/scripts/codex-review.sh`.
- 스킬: `codex-cli`·`codex-imgage`(글로벌)·`dbm-schema-extract`(읽기전용 psql). 입력: round-11 상품BOM·print-kb 레시피·§15 프리미엄엽서 발견(축 충돌 패턴).

## 테스트 시나리오
- **정상**: "디지털인쇄 시트 구성요소 시각화" → Phase1 레시피(codex) → Phase2 mermaid→이미지 ∥ 연결검증(codex) → Phase3 R1~R6(Claude) → 종합. 산출 `_workspace/huni-recipe-viz/디지털인쇄/`.
- **에러**: codex 데드락 → preflight 재판정 → 레시피/연결=Claude 명시 폴백·시각화=mermaid 단독(이미지 미생성 명시)·pending 금지. 또는 권위 엑셀 부재 → 블로커 보고 후 컨펌큐.
