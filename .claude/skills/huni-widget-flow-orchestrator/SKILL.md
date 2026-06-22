---
name: huni-widget-flow-orchestrator
description: 후니 위젯 구조·플로우 문서화 하네스(Huni-Widget-Flow) 오케스트레이터. docs/reversing 역공학 자료 + raw/widget_monitor 캡처를 근거로, ① 개발자용 mermaid 위젯 구조·플로우 문서(전체 아키텍처+초기화/가격/주문 시퀀스+에디쿠스 라이프사이클+26 상품군별 파일업로드 vs 에디쿠스 연결 flowchart)와 ② 비전문가용 codex-imgage 인포그래픽(제품군 구성·전체 여정·두 경로 대비)을 산출한다. 하이브리드 실행(팬아웃 큐레이션 → mermaid·codex 병렬 생성 → F1~F6 독립검증). 4 에이전트(hwf-flow-curator·hwf-mermaid-author·hwf-flow-visualizer·hwf-validator)·생성≠검증·근거 충실·미상 정직·읽기전용. 트리거: '위젯 구조 문서', '위젯 플로우 문서화', '위젯 mermaid', '파일업로드 에디쿠스 연결', '제품군 플로우 시각화', '위젯 플로우 하네스 실행/재실행/업데이트/보완', '특정 상품군만 플로우'. 위젯 구현은 huni-widget(§6), 가격 레시피 시각화는 huni-recipe-viz(§16)가 담당. 단순 질문은 직접 응답.
---

# Huni-Widget-Flow 오케스트레이터

## 목표
RedPrinting 위젯 역공학 자료를 근거로, **개발자가 보는 mermaid 기술 문서**와 **비전문가가 보는 codex-image 인포그래픽**을 동시에 산출한다. 중심 축은 "26개 상품군 각각이 파일 업로드와 에디쿠스(편집기)를 어떻게 연결하는가".

## 실행 모드: 하이브리드
- **Phase 1 큐레이션**: 단일 에이전트(서브) — 증거 추출.
- **Phase 2 생성**: mermaid-author + flow-visualizer **병렬**(서브, run_in_background) — 같은 팩, 다른 청중.
- **Phase 3 검증**: validator 단독(서브) — 독립 재실측.

생성≠검증: 생성 에이전트는 절대 자기 산출을 승인하지 않는다.

## Phase 0: 컨텍스트 확인
`_workspace/huni-widget-flow/` 존재 여부로 실행 모드 결정:
- 미존재 → **초기 실행**(Phase 1부터).
- 존재 + 부분 수정 요청(특정 상품군·특정 산출) → **부분 재실행**(해당 에이전트만, 해당 산출만 갱신).
- 존재 + 새 입력/전면 재작성 → 기존 `_workspace`를 보존하고 갱신(필요 시 `_prev`로 이동).

## Phase 1: 큐레이션 (서브)
`hwf-flow-curator`(model=opus) 호출 → `hwf-flow-curation` 스킬.
- 산출: `01_curation/`(widget-architecture.md·path-branch-spec.md·product-path-matrix.csv·unknowns-board.md).
- 게이트: 26 카테고리 매트릭스 행이 채워졌고, 핵심 분기(uploadType·item_gbn) 근거가 있는가. 미달이면 보강 후 진행.

## Phase 2: 생성 (병렬 서브)
같은 `01_curation/` 팩을 입력으로 **동시 호출**(run_in_background=true):
- `hwf-mermaid-author`(opus) → `hwf-mermaid-authoring` → `02_mermaid/`(개발자용 mermaid 문서).
- `hwf-flow-visualizer`(opus) → `hwf-flow-visualize` → `codex-imgage` 호출 → `03_visual/`(비전문가 인포그래픽 + manifest).

두 산출은 분기 사실을 동일하게 유지해야 한다(청중·추상도만 다름).

## Phase 3: 검증 (서브)
`hwf-validator`(opus) → `hwf-flow-validation` → F1~F6 게이트 → `04_validation/gate-verdict.md`.
- **NO-GO/CONDITIONAL** → 수정 라우팅(F1/F6=curator, F2/F3=mermaid-author, F5=visualizer)대로 해당 에이전트 재호출 후 재검증.
- **GO** → 최종 통합·사용자 보고.

## 데이터 전달
파일 기반(`_workspace/huni-widget-flow/<phase>/`) + 반환값(요약). 파일명 컨벤션 `<phase>_<artifact>`. 최종 mermaid 통합본은 사용자 확인 후 `docs/reversing/widget-flow/`로 모을 수 있음(중간 산출은 `_workspace`에 보존).

## 에러 핸들링
- 에이전트 1회 재시도 후 재실패 → 해당 산출 없이 진행하고 verdict에 누락 명시.
- codex-imgage 미가용 → visualizer 폴백(명시적 미생성 + 임시 mermaid), pending 위장 금지.
- 역공학 근거 상충 → 삭제 말고 출처 병기, validator가 판정.

## 산출물 루트
`_workspace/huni-widget-flow/` (01_curation·02_mermaid·03_visual·04_validation)

## 테스트 시나리오
- **정상 흐름**: "역공학 자료 읽고 위젯 구조·플로우 mermaid 문서 + 비전문가 시각화" → Phase 1 큐레이션 → Phase 2 mermaid+codex 병렬 → Phase 3 F1~F6 GO → 통합 보고.
- **에러 흐름**: codex-imgage 데드락 → visualizer가 미생성 명시 + mermaid 임시 도해 → validator F5는 "이미지 미생성"으로 CONDITIONAL → 사용자에게 codex 재시도 여부 확인.
- **부분 재실행**: "책자 상품군 플로우만 다시" → curator가 PRBK* 행만 갱신 → mermaid-author가 해당 페이지만 → validator F3/F4 표본 재검증.
