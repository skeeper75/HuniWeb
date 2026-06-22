---
name: hec-flow-authoring
description: 후니 Edicus 코드맵 하네스(Huni-Edicus-Codemap)의 개발팀용 mermaid 통합 집필 방법론. api-cartography 계약 + code-cartography 코드맵을 종합해 시스템 아키텍처·라우트맵·인증→편집→주문 시퀀스·Edicus 패시브모드 라이프사이클·주문 상태머신·코드↔API 배선도를 렌더 가능한 mermaid 기술 문서로 작성한다. 청중=개발팀·두 팩 밖 창작 금지·코드↔계약 불일치는 명시·파일:라인/PDF p.N/env 키 병기. 트리거: mermaid 통합 문서, 아키텍처 다이어그램, 전체 플로우 집필, 코드 API 배선도, 시퀀스 다이어그램, mermaid 다시. API 추출은 hec-api-cartography, 코드맵은 hec-code-cartography, 검증은 hec-flow-validation.
---

# hec-flow-authoring — 개발팀용 mermaid 통합 집필 방법론

## 목적
API 계약(`01_api/`)과 코드맵(`02_codemap/`)을 **하나의 개발팀용 mermaid 문서**로 통합한다. 핵심 가치는 코드와 API를 잇는 **배선**.

## 입력
`_workspace/huni-edicus-codemap/01_api/` + `02_codemap/` 전체.

## 다이어그램 매핑
| 대상 | mermaid |
|------|---------|
| 시스템 아키텍처(Next.js 앱·Edicus SDK/서버·Firebase·S3·BFF) | `flowchart` (subgraph 내부/외부, classDef) |
| 라우트 맵(App Router) | `flowchart TD` |
| 인증→상품→편집→주문 end-to-end | `sequenceDiagram` (User·NextApp·useEdicus·EdicusSDK·EdicusServer·Firebase) |
| Edicus 패시브모드 라이프사이클 | `stateDiagram-v2` |
| 주문 상태머신 | `stateDiagram-v2` |
| 코드↔API 배선도 | `flowchart LR` (hook/component → SDK 메서드/Server API; env 키 주석) |

## 집필 규칙
1. **두 팩 충실[HARD]**: 팩에 있는 사실만. 코드↔계약 불일치(코드 호출이 PDF에 없음 등)는 `%% 불일치: ...` 주석.
2. **렌더 가능성**: ```mermaid 펜스, 노드 id 영숫자, 특수문자 라벨 `["..."]`, 큰 그래프 분할.
3. **추적 가능성**: 각 다이어그램에 관련 `파일:라인`·SDK 메서드·`PDF p.N`·env 키를 산문으로 곁들여 개발자가 코드/문서로 점프 가능하게.
4. **비밀 비노출**: env는 키 이름만(값 금지).

## 산출
`_workspace/huni-edicus-codemap/03_flow/`: 00_architecture.md·01_flows.md·02_code-api-wiring.md·README.md(목차+링크). 최종본은 오케스트레이터 안내로 `docs/edicus.man/docs/codemap/`에 모을 수 있음.
