---
name: huni-multibrand-ontology-orchestrator
description: 후니 다중 브랜드 인쇄 온톨로지 하네스(§35·Huni-Multibrand-Ontology) 오케스트레이터. 경쟁사(와우프레스·레드) 상품을 정밀 분석해 후니(§33 KB)와 교차 연관짓고, 국제 인쇄표준(CIP4/XJDF·schema.org·구성 온톨로지) 기반 브랜드-중립 상위 온톨로지를 설계한다 — 목표는 자연어 질의→상품 추천→가격→주문 형태 확장. 5인 팀(mbo-standards-researcher ∥ mbo-catalog-analyst 기준점 팬아웃 → mbo-crossbrand-mapper 차이 지도 → mbo-ontology-architect 상위 온톨로지 설계 → mbo-verify-gate MB1~MB7 게이트+아키텍처 권고). ★아키텍처 결정(§33 확장 vs 독립 §35 KB 후 연합)은 분석·표준 산출 뒤 게이트+인간 승인으로 지연 결정. 와우 앵커 네임스페이스(catalog/api/pdf)로 지어내기 차단 유지·가격값 권위=브랜드별 엔진/API·§33 골든 재사용·무손상·생성≠검증·라이브 읽기전용. '다중 브랜드 온톨로지', '와우프레스 온톨로지', '와우프레스 상품 분석', '상위 온톨로지 설계', 'CIP4 인쇄표준', '브랜드 차이 지도', '교차 브랜드 매핑', '레드 와우 후니 대조', 'MB 게이트 실행', '아키텍처 결정', '§35 하네스 실행/재실행/업데이트/보완', '특정 상품군만 다중브랜드', '다중브랜드 다시' 작업 시 반드시 이 스킬을 사용. 단순 질문(산출물 조회)은 _workspace/huni-multibrand-ontology/ 직접. 후니 단독 온톨로지 구축은 §33 huni-ontology-kb-orchestrator.
---

# Huni-Multibrand-Ontology 오케스트레이터 (§35)

**목표:** 경쟁사 상품(와우프레스 우선·레드 확장)을 정밀 분석해 후니(§33 KB)와 **교차 연관**짓고, 국제 인쇄표준 기반 **브랜드-중립 상위 온톨로지**를 설계해 "자연어 질의 → 브랜드 무관 상품 추천 → 가격 → 주문" 형태로 확장한다.

**핵심 결정 (사용자 확정 · relitigate 금지):**
1. **아키텍처 커밋 지연** — "§33 확장(다중브랜드 진화) vs 독립 §35 KB 후 연합"은 **분석·표준 산출 뒤** 게이트(MB7)+인간 승인으로 결정. 산출물은 어느 쪽이든 재사용 가능(architecture-neutral).
2. **상위 온톨로지·표준 먼저** — 상품 대량 수집 전, CIP4/XJDF·schema.org 기반 브랜드-중립 상위 온톨로지 + 와우 정밀분석이 1차 주력 산출.

**핵심 규칙 [HARD]** (상세 = `.claude/rules/harness/huni-multibrand-ontology.md`):
- 와우 앵커 네임스페이스(`catalog:`·`wowpress-api:`·`wowpress-pdf:`)로 **지어내기 차단 유지**(모든 노드 실 앵커 or GAP). 값=스크립트 전사(LLM 손전사 금지).
- 가격 경계 동형(§33 D-18): 값 권위=브랜드별 엔진(후니 evaluate_price·와우 가격조회 API). KB는 축·연결까지.
- §33 재사용·무손상: 후니 데이터=`_workspace/huni-ontology-kb/03_kb/` 읽기 재사용. §33 골든 자산 수정 금지(아키텍처 결정 전).
- catalog 노후(2025-10-14) 경계: 의심분만 devshop 라이브(gstack 읽기전용) 재확인. 생성≠검증·search-before-mint.

---

## Phase 0: 컨텍스트 확인 (초기/후속/부분 재실행)

`_workspace/huni-multibrand-ontology/` 산출 존재로 실행 모드 판별:
- **미존재** → 초기 실행(Phase 1부터).
- **존재 + 부분 수정 요청**(예: "와우 분석만 다시", "표준만 보강") → 해당 에이전트만 재호출(Phase 선택).
- **존재 + 새 브랜드/상품군**(예: 레드 추가) → 델타 실행(기존 열 유지·신규 append). 큰 새 입력이면 기존을 `_prev/`로 이동 후 재빌드.
- **아키텍처 결정 요청** → Phase 4 게이트 산출(`architecture-recommendation.md`) 기반 인간 승인 진행.

먼저 HANDOFF.md·CHANGELOG.md를 읽어 다음 시작점·미해결을 확인한다.

## Phase 1: 기준점 팬아웃 (병렬 · 사용자 우선순위)

**실행 모드: 서브 에이전트 병렬**(`run_in_background`). 두 산출은 독립 → 동시 수집.
- `mbo-standards-researcher` → `00_research/`(표준 어휘·상위 온톨로지 후보 어휘).
- `mbo-catalog-analyst` → `01_analysis/`(와우 구조·카탈로그 맵·가격 메커니즘·`_cache/` CSV).

두 산출이 이번 하네스의 1차 주력(사용자 결정 2). 완료 후 수집.

## Phase 2: 교차 브랜드 차이 지도 (파이프라인)

`mbo-crossbrand-mapper` → `02_crossbrand/`. 입력=§33 KB(`03_kb/` 읽기 재사용) + Phase 1 산출. 후니↔와우 상품군 정렬 + 3축(구성요소/가격공식/가격구성요소) 차이 매트릭스 + 교차엣지 후보.

## Phase 3: 브랜드-중립 상위 온톨로지 설계 (파이프라인 · 주력 산출)

`mbo-ontology-architect` → `03_upper_ontology/`. 입력=Phase 1~2 전량. 상위 온톨로지 스키마 + 와우 앵커 스펙 + 교차관계 폐쇄목록 + NL 질의 경로 + **아키텍처 결정 브리프**(§33 확장 vs 독립 두 경로·마이그레이션 노트).

## Phase 4: 독립 검증 게이트 + 아키텍처 권고 (검증)

`mbo-verify-gate` → `04_verification/`. MB1~MB7 GO/NO-GO(단일 FAIL=NO-GO) + 결함 보드 + **아키텍처 권고**. NO-GO면 해당 에이전트로 교정 루프(1회 재시도 후 재실패 = 결함 명시 진행). 고위험 판정은 codex 독립 교차(미가용 시 "Claude 단독" 명시).

## Phase 5: 인간 승인 게이트 (아키텍처 결정)

게이트 GO + `architecture-recommendation.md`를 사용자에게 제시 → **§33 확장 vs 독립 §35 KB** 결정을 AskUserQuestion으로 확정. 결정 후에야 지식 본문 대량 구축(확장이면 §33 builder·독립이면 신규 builder 하네스)으로 진행 — 이 오케스트레이터 범위 밖(후속 세션).

---

## 데이터 전달 프로토콜

- **파일 기반**(주): 각 Phase 산출을 `_workspace/huni-multibrand-ontology/<NN>_*/`에 기록. 최종만 사용자 보고, 중간 산출 보존(감사).
- **반환값 기반**: 서브 에이전트 결과를 오케스트레이터가 수집·종합.
- 파일명: `<phase>_<agent>_<artifact>.md` 계열(디렉토리 번호로 대체 가능).

## 에러 핸들링

- 에이전트 1회 재시도 후 재실패 → 해당 산출 없이 진행, 보고서에 누락 명시.
- 상충 데이터(후니 vs 와우, 표준 vs 라이브)는 삭제 금지 — 출처 병기·양면/GAP 노드로 보존(§33 승계).
- catalog 노후 의심 → devshop 라이브 재확인·`captured_at` 갱신. 웹/codex 미가용 → "Claude 단독" 명시 폴백.

## 테스트 시나리오

- **정상 흐름:** "와우프레스 온톨로지 만들자" → Phase 1 병렬(표준∥와우분석) → 차이 지도 → 상위 온톨로지 설계 → MB 게이트 GO → 아키텍처 권고 → 인간 결정.
- **에러 흐름:** catalog 특정 상품 가격 불명확 → catalog-analyst가 devshop 라이브 재확인 실패 → 해당 상품 GAP 노드(anchor=none·사유)로 정직 기록·게이트 통과(지어내기 금지).
- **부분 재실행:** "표준만 CIP4 보강" → standards-researcher만 재호출 → 델타 → 게이트 MB2만 재확인.

## 경계

- 이 하네스는 **분석·표준·상위 온톨로지 설계 + 아키텍처 결정 준비**까지. 후니 단독 KB 구축·확장은 §33. 지식 본문 대량 구축은 아키텍처 결정 후 별도.
- 라이브/사이트 읽기전용·DB 미적재. 실 병합/구축은 인간 승인 후.
