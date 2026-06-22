---
name: hwf-flow-validation
description: 후니 위젯 구조·플로우 문서화 하네스(Huni-Widget-Flow)의 독립 검증 게이트 방법론(생성≠검증). curator 큐레이션·mermaid 문서·codex 이미지를 역공학 원본으로 독립 재실측해 F1~F6(근거 실재성·구조 정확성·경로 분기 정합·26 상품군 커버리지·이미지↔사실 정합·미상 정직성)로 GO/NO-GO를 낸다. 생성자 주장 비신뢰·직접 원본 대조·근거 못 찾으면 NO-GO·읽기전용. 트리거: 플로우 검증, F1 F6 게이트, 근거 실재성 검증, 커버리지 검증, mermaid 정합 검증, 이미지 정합 검증, 검증 다시. 생성(큐레이션·mermaid·이미지)은 각 생성 스킬 담당.
---

# hwf-flow-validation — F1~F6 독립 검증 게이트

## 목적
생성 산출이 역공학 사실에 충실한지 **독립 재실측**으로 판정. 생성자의 "근거 있음"을 믿지 않고 원본(docs/reversing·raw/widget_monitor)을 직접 열어 대조한다.

## F-게이트 (전부 PASS여야 GO)
- **F1 근거 실재성** — matrix·spec의 `파일:라인` 인용을 표본 추출해 원본 대조. 날조/과장 0.
- **F2 구조 정확성** — mermaid 아키텍처·시퀀스가 3계층·스토어·API·postMessage를 원본과 일치 표현. 잘못된 화살표·없는 노드 적발.
- **F3 경로 분기 정합[핵심]** — 업로드/에디쿠스 분기 요인(uploadType·item_gbn)·각 경로 시퀀스 정확성. 분기 역전·결정요인 오류=즉시 NO-GO.
- **F4 26 상품군 커버리지** — redprinting_catalog.json 26 카테고리가 패턴 그룹핑 포함 빠짐없이 커버. 누락 목록화.
- **F5 이미지↔사실 정합** — codex 이미지의 단계·분류가 팩 사실과 일치(환각 단계·오분류·한글 텍스트 깨짐 적발) + 비전문가 가독성 평가.
- **F6 미상 정직성** — curator가 `모름`이라 한 항목을 mermaid/이미지가 확정 사실로 위장하지 않았는가.

## 절차
1. 표본 선정 — 핵심 분기 사실 + 무작위 인용 표본.
2. 직접 재실측 — Grep/Read로 원본 위치 확인.
3. 게이트별 PASS/FAIL + 근거 기록.
4. 종합 판정 — GO / NO-GO / CONDITIONAL(결함 항목·수정 라우팅 명시).

## 핵심 규칙
- **직접 재실측[HARD]**: 생성 산출만 읽고 판정 금지.
- **dodge-hunt**: 누락·얼버무림·"대체로 맞음" 적발. 핵심은 F3(분기)·F4(커버리지).
- **수정 라우팅**: FAIL → curator(증거)/mermaid-author(도해)/visualizer(이미지) 중 어디로 보낼지 명시.

## 검증 스크립트 활용
- redprinting_catalog.json category distinct 추출 → matrix 커버리지 자동 대조.
- mermaid 코드블록 펜스/노드 문법 린트(렌더 가능성).

## 산출
`_workspace/huni-widget-flow/04_validation/`: `gate-verdict.md` + `coverage-check.csv`.
