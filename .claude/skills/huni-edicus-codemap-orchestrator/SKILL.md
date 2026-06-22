---
name: huni-edicus-codemap-orchestrator
description: 후니 Edicus 코드맵 하네스(Huni-Edicus-Codemap) 오케스트레이터. docs/edicus.man Next.js 15 Web-to-Print 코드베이스 + Edicus 공식 SDK/Server API PDF + EDICUS_* 환경변수를 종합해, 개발팀이 전체 아키텍처·플로우·각 코드·API를 알 수 있는 mermaid 기술 문서를 산출한다 — 시스템 아키텍처·라우트맵·인증→편집→주문 시퀀스·Edicus 패시브모드 라이프사이클·주문 상태머신·코드↔API 배선도. 하이브리드 실행(API계약 ∥ 코드맵 팬아웃 → mermaid 통합 집필 → C1~C6 독립검증). 4 에이전트(hec-api-cartographer·hec-code-cartographer·hec-flow-author·hec-validator)·생성≠검증·PDF=1차권위·코드=권위·비밀값 비노출. 트리거: 'edicus 코드맵', 'edicus.man 분석', 'Edicus SDK API 분석', '코드맵 mermaid', '전체 아키텍처 플로우 문서', '개발팀 아키텍처 문서', 'Edicus 코드맵 하네스 실행/재실행/업데이트/보완', '특정 코드/API만 분석'. 위젯 역공학 플로우는 huni-widget-flow(§19), 위젯 구현은 huni-widget(§6). 단순 질문은 직접 응답.
---

# Huni-Edicus-Codemap 오케스트레이터

## 목표
`docs/edicus.man`(후니 Web-to-Print Next.js 플랫폼) 코드 + Edicus 공식 SDK/Server API PDF + 환경변수를 종합해, **개발팀이 전체 아키텍처·플로우·각 코드·API를 이해하는 mermaid 기술 문서**를 산출한다. 핵심 가치는 코드와 API를 잇는 배선.

## 실행 모드: 하이브리드
- **Phase 1 팬아웃(병렬)**: api-cartographer(공식 PDF+env) ∥ code-cartographer(Next.js 코드) — 서로 독립.
- **Phase 2 통합 집필**: flow-author(서브) — 두 팩을 mermaid로 결합.
- **Phase 3 검증**: validator(서브) — C1~C6 독립 재실측.

생성≠검증: 생성자는 자기 산출을 승인하지 않는다.

## Phase 0: 컨텍스트 확인
`_workspace/huni-edicus-codemap/` 존재 여부:
- 미존재 → **초기 실행**.
- 존재 + 부분 수정(특정 API/코드/다이어그램) → **부분 재실행**(해당 에이전트·산출만).
- 존재 + 새 입력(PDF 갱신·코드 변경) → 갱신(필요 시 `_prev`로 보존).

## Phase 1: 팬아웃 (병렬 서브)
동시 호출(run_in_background=true):
- `hec-api-cartographer`(opus) → `hec-api-cartography` → `01_api/`(SDK 메서드·Server API·패시브 이벤트·env 매핑, `PDF p.N` 근거).
- `hec-code-cartographer`(opus) → `hec-code-cartography` → `02_codemap/`(모듈맵·hooks/Edicus 배선·데이터흐름·code-facts, `파일:라인` 근거).
- 게이트: API 핵심 메서드(init·create/open_project·post_to_editor·패시브·토큰)와 코드 핵심 레이어(라우트·hooks·types)가 채워졌는가.

## Phase 2: 통합 집필 (서브)
`hec-flow-author`(opus) → `hec-flow-authoring` → `03_flow/`(아키텍처·플로우·**코드↔API 배선도**·README 목차). 코드↔계약 불일치는 `%% 불일치` 표기.

## Phase 3: 검증 (서브)
`hec-validator`(opus) → `hec-flow-validation` → C1~C6 → `04_validation/gate-verdict.md`.
- **NO-GO/CONDITIONAL** → 라우팅(C1=api, C2/C3=code·flow, C4=flow, C6=해당자) 재호출 후 재검증.
- **C6 비밀 노출** → 즉시 차단·마스킹.
- **GO** → 최종 보고.

## 데이터 전달
파일 기반(`_workspace/huni-edicus-codemap/<phase>/`) + 반환값(요약). 최종 mermaid 통합본은 사용자 확인 후 `docs/edicus.man/docs/codemap/`로 모을 수 있음.

## 에러 핸들링
- 에이전트 1회 재시도 후 재실패 → 해당 산출 없이 진행·verdict에 누락 명시.
- PDF 페이지 누락/판독불가 → "PDF 미판독 p.N" 명시(추정 금지).
- 코드↔PDF 불일치 → 삭제 말고 양쪽 출처 병기, validator 판정.
- **비밀값[HARD]**: env 값을 산출·반환·stdout에 절대 노출 금지. 키 이름·역할만.

## 산출물 루트
`_workspace/huni-edicus-codemap/` (01_api·02_codemap·03_flow·04_validation)

## 테스트 시나리오
- **정상 흐름**: "edicus.man 코드맵 + Edicus SDK/API mermaid 문서" → Phase1 API∥코드 병렬 → Phase2 통합 집필 → Phase3 C1~C6 GO.
- **에러 흐름**: PDF 일부 판독 불가 → api-cartographer가 "미판독 p.N" 명시 → validator C1 CONDITIONAL → 사용자에게 해당 페이지 재시도 확인.
- **부분 재실행**: "useEdicus 훅 배선만 다시" → code-cartographer가 hooks만 갱신 → flow-author가 배선도만 → validator C2/C3 표본 재검증.
