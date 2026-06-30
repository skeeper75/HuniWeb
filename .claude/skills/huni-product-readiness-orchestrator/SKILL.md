---
name: huni-product-readiness-orchestrator
description: 후니프린팅 상품별 가격계산 준비도 평가 + 위젯/제약 개발일정 하네스 오케스트레이터(§29). 이전사이트(huniprinting.com) 상품리스트를 분모로, 라이브 DB에 적재된 상품+가격이 실제 가격계산 가능한 수준으로 연결됐는지 상품별로 세부 평가하고(구성요소 요건·가격공식/구성요소 계산가능성·기초마스터/옵션/추가상품템플릿/제약 적재·판형 매핑), 베스트프랙티스 루브릭(D1~D11·등급 L0~L4)으로 진척도 점수표·체크리스트·특정 리스트(구성요소 누락·오매핑·판형 재처리·가격계산 0)를 내고, 위젯+제약조건 개발 부분만 준비도 등급별 묶음 일정으로 분리한다. 6 에이전트(hpr-catalog-spine∥hpr-rubric-curator 팬아웃 → hpr-readiness-evaluator → hpr-widget-scheduler → hpr-codex-verifier → hpr-scorecard-gate Q1~Q7). 기존 스코어링/RTM/§21/§26/§13 재사용(중복 채점 금지)·생성≠검증·codex 주장=가설·라이브 읽기전용·평가/계획까지(실 교정·적재는 인간 승인). ★판형은 종이류에만 유효(미/오매핑=재처리). 트리거: '상품 준비도 평가', '상품별 진척도', '구현 진척도 평가', '가격계산 준비도', '상품 준비도 점수표', '위젯 개발일정 분리', '제약조건 일정', '구성요소 누락 점검', '오매핑 점검', '판형 매핑 점검', '준비도 하네스 실행/재실행/업데이트/보완', '특정 상품군만 준비도'. 1차 런칭 개발범위 fit-gap은 §28, 전 상품 정합은 §21, 가격테이블 무결성은 §26, 가격 종단 수렴실행은 §27, 위젯 구현은 §6. 단순 질문은 직접 응답.
---

# Huni-Product-Readiness 오케스트레이터 (§29)

## 목표
이전사이트 상품리스트(분모) 대비 **각 상품이 실제 가격계산이 되는 수준까지 적재·연결됐는지**를 상품별 세부 평가하고(진척도), **위젯+제약조건 개발 부분만** 준비도 등급별 묶음 일정으로 분리한다. 목적=현재 구현 수준 전반 확인 + 프로젝트 일정 체크.

## ★핵심 규칙
- **기존 자산 재사용 [HARD]** — 새 분석 엔진 금지. `_workspace/_foundation/`(SCORING-FRAMEWORK·product-scoreboard·RTM·batch)·§21 conformance-checklist·§26 무결성·§13 engine-contract·§28 00_live를 증거로 몰아 평가만.
- **판형 [HARD]** — 판형(plate_sizes)은 종이류 출력소재에만 유효. 종이류인데 판형 미/오매핑이면 "재처리 대상"으로 특정(사용자 지시). 비종이=N/A.
- **생성≠검증·codex 주장=가설·라이브 읽기전용·평가/계획까지**(실 교정·적재·COMMIT은 인간 승인 후 §7 dbmap·§18·§6 위임).

## 실행 모드 — 하이브리드
- Phase A(기준점): 서브에이전트 병렬 — catalog-spine ∥ rubric-curator.
- Phase B(생성): 순차 — readiness-evaluator → widget-scheduler.
- Phase C(검증): 순차 — codex-verifier → scorecard-gate.
- 데이터=파일 기반(`_workspace/huni-product-readiness/`). 전 Agent `model: "opus"`.

## Phase 0: 컨텍스트 확인
- `_workspace/huni-product-readiness/` 존재 + 부분 수정 → 부분 재실행. 새 입력 → `_prev/` 이동 후 새 실행. 미존재 → 초기. 자격증명 점검(`.env.local` RAILWAY_DB_*·HUNI_ADMIN_*·HUNIPRINTING_*·HUNI_LIVE_*).

## Phase A — 기준점 팬아웃 (병렬)
1. **hpr-catalog-spine** (`hpr-catalog-spine`) — 이전사이트×엑셀(260610)×라이브 3자 교차 → `00_spine/`(product-spine·종이류 판정·coverage-gaps).
2. **hpr-rubric-curator** (`hpr-rubric-curation`) — D1~D11·L0~L4·위젯 클래스 + 재사용 증거 맵 → `01_rubric/`.

## Phase B — 생성 (순차)
3. **hpr-readiness-evaluator** (`hpr-readiness-evaluation`) — 척추×루브릭 전수 평가(라이브 evaluate_price 실측·기존 채점 재사용) → `02_readiness/`(scorecard + 4 리스트 + other-checks).
4. **hpr-widget-scheduler** (`hpr-widget-schedule`) — 등급별 묶음 위젯/제약 일정 → `03_schedule/`.

## Phase C — 검증 (순차)
5. **hpr-codex-verifier** (`hqv-codex-cross-verify` 재사용) — codex 독립 2차(과대평가·판형 오판·환각) → `04_codex/`.
6. **hpr-scorecard-gate** (`hpr-scorecard-gate-validation`) — Q1~Q7 독립 재실측(판형 종이류 [HARD] 재실측·evaluate_price 표본 재계산) → `05_gate/`(verdict + 최종 점수표 문서; xlsx 요청 시 시트 빌드). NO-GO 영역은 해당 생성 에이전트 루프.
7. **hpr-dashboard-builder** (`hpr-dashboard-build`) — GO분으로 **인터랙티브 웹 대시보드** 빌드(기존 webadmin product_viewer UX 재사용·Cytoscape.js 구성요소↔가격 플로우 그래프) → `05_gate/dashboard/`(standalone dashboard.html + webadmin 드롭인 Django 패키지). ★raw/webadmin 미수정. 기본 산출물(사용자 요청).

## 데이터 흐름
```
00_spine ─┐
01_rubric ─┴→ 02_readiness → 03_schedule → 04_codex → 05_gate(verdict + 점수표/일정) → dashboard(웹페이지)
```

## 에러 핸들링
- 에이전트 1회 재시도 후 누락 명시 진행. 사이트 접근 실패 시 §28 캐시+엑셀로 척추 + 명시. evaluate_price 불가 시 기존 채점 추정 + "라이브 미실측" 플래그. codex 미가용 시 "Claude 단독" 명시. 상충 데이터 출처 병기.

## 경계 (재병합 금지)
- 1차 런칭 fit-gap=§28 · 전 상품 12축 정합=§21 · 가격테이블 셀 무결성=§26 · 가격 종단 수렴실행=§27 · 위젯 구현=§6. 본 하네스는 **상품별 준비도 평가(진척도) + 위젯/제약 일정 분리** 전용.

## 테스트 시나리오
- **정상**: "상품 준비도 점수표 만들어줘" → Phase A 병렬 → B → C → 분모 누락0, 등급 분포·계산가능 비율, 4 리스트, 위젯 등급별 wave 일정 GO.
- **에러**: 이전사이트 접근 실패 → spine이 §28 캐시+엑셀로 구성 + "사이트 미접근" 명시 → evaluator는 라이브 DB+엑셀로 평가, 사이트-only 구멍은 "확인 필요"로 → gate Q1에서 분모 한계 기록.
