---
name: hwf-mermaid-authoring
description: 후니 위젯 구조·플로우 문서화 하네스(Huni-Widget-Flow)의 개발자용 mermaid 기술 문서 집필 방법론. flow-curator 플로우 팩을 입력으로 위젯 전체 구조(3계층·Pinia)·공통 시퀀스(초기화/가격/주문)·에디쿠스 라이프사이클·26 상품군별 파일업로드 vs 에디쿠스 연결 flowchart를 렌더 가능한 mermaid로 작성한다. 청중=개발자(정확·완전)·근거 팩 밖 창작 금지·미상은 점선/주석 표기. 트리거: mermaid 문서, 위젯 플로우 문서, mermaid flowchart, 시퀀스 다이어그램 집필, 개발자 문서, mermaid 다시. 비전문가 인포그래픽은 hwf-flow-visualize, 검증은 hwf-flow-validation 담당.
---

# hwf-mermaid-authoring — 개발자용 mermaid 집필 방법론

## 목적
flow-curator의 검증된 플로우 팩을 **개발자가 위젯 구조와 플로우를 확인할 수 있는 mermaid 기술 문서**로 집필한다.

## 입력
`_workspace/huni-widget-flow/01_curation/`(특히 `path-branch-spec.md`, `product-path-matrix.csv`).

## 다이어그램 매핑
| 대상 | mermaid 유형 |
|------|------|
| 전체 아키텍처(3계층·Shadow DOM·CDN/서버) | `flowchart LR/TD` (subgraph로 계층 구분) |
| 초기화·가격계산·주문 | `sequenceDiagram` (participant: Browser, WidgetJS, Server, EditorSDK) |
| 에디쿠스 라이프사이클 | `stateDiagram-v2` |
| 상품군별 경로 분기 | `flowchart TD` (옵션 → uploadType 분기 → 업로드/에디쿠스 → 주문) |

## 집필 규칙
1. **근거 팩 충실[HARD]**: 팩에 있는 노드·화살표·조건만. 팩이 `모름`이라 한 부분은 점선 엣지 + `%% 역공학 미확인` 주석.
2. **렌더 가능성**: 모든 블록은 ```` ```mermaid ```` 펜스. 노드 id는 영숫자, 특수문자 라벨은 `["..."]`로 감싸기. 큰 그래프는 분할.
3. **분기 1급화**: 상품군 페이지마다 업로드/에디쿠스 두 갈래를 명시하고 분기 결정 노드(uploadType/item_gbn) 표기.
4. **다이어그램 + 산문**: 각 도해에 API 엔드포인트·postMessage 이벤트·스토어 변화 설명을 곁들여 개발자가 추적 가능하게.
5. **중복 억제**: 26 상품군이 동일 분기 패턴을 공유하면 "패턴 N(예: 에디터 전용 / 업로드+에디터)" + 소속 상품군 목록으로 묶되, 모든 카테고리가 어느 패턴에 속하는지 빠짐없이 명시(커버리지=26).

## mermaid 작성 팁
- sequenceDiagram에서 조건 분기는 `alt uploadType=editor / else uploadType=pdf`.
- flowchart 분기는 마름모 노드 `{"uploadType?"}`.
- 색/스타일은 과하지 않게, 출처 구분(CDN vs 자체서버)에 `classDef` 활용 가능.

## 산출 위치
`_workspace/huni-widget-flow/02_mermaid/` — `00_architecture.md` + 상품군 플로우(패턴별 또는 카테고리별). 최종 통합본은 오케스트레이터 안내에 따라 `docs/reversing/widget-flow/`로 모을 수 있음.
