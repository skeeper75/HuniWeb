---
name: hec-api-cartography
description: 후니 Edicus 코드맵 하네스(Huni-Edicus-Codemap)의 Edicus API 계약 추출 방법론. 공식 PDF(Edicus JS SDK 38p·Edicus Server API 43p)와 .env.local EDICUS_* 환경변수를 읽어 SDK 메서드 계약·Server API 엔드포인트·패시브모드 이벤트·토큰 흐름·환경변수 역할 매핑을 API 계약 카탈로그로 산출한다. PDF=1차 권위·페이지 근거(PDF p.N) 강제·비밀값 비노출(키 이름만)·읽기전용. 트리거: API 계약 추출, Edicus SDK 메서드, Server API 엔드포인트, 패시브모드 이벤트, 환경변수 매핑, 토큰 흐름, API 카탈로그 다시. 코드맵은 hec-code-cartography, mermaid 집필은 hec-flow-authoring, 검증은 hec-flow-validation.
---

# hec-api-cartography — Edicus API 계약 추출 방법론

## 목적
개발팀이 의존할 Edicus **API 계약 카탈로그**를 공식 문서에서 정확히 추출한다.

## 권위
1. `docs/edicus.man/docs/Edicus JS SDK.pdf`(38p)·`Edicus Server API.pdf`(43p) — 1차 권위.
2. `docs/edicus.man/docs/red-editor-sdk-analysis.md`·`ref/RedEditorSDK.js`·`docs/reversing` — 보조(버전 대조용, PDF 미덮어쓰기).
3. `.env.local` — 키 이름·역할만(값 비노출).

## PDF 읽기 규칙
PDF는 크므로 Read의 `pages` 파라미터로 분할 읽기(한 요청 최대 20p). 목차(p.1~2)로 구조 파악 후 섹션별로 전수 읽는다. JS SDK 목차: init·destroy·create_project·open_project·close·edit_template·change_project·change_template·post_to_editor(itemPath·varInfo)·패시브모드(info@*)·TnView·Preview·프로젝트 재활용.

## 추출 단위
- **SDK 메서드**: {시그니처, config/파라미터 키·타입·기본값, 반환, 콜백/이벤트, 호출 시점, `PDF p.N`}.
- **Server API**: {엔드포인트, HTTP 메서드, 요청/응답 스키마, 인증, `PDF p.N`}.
- **패시브 이벤트**: `info@load-project-report`·`change-template-report`·`project-id-created`·`error-report`·`doc-changed`·`save-doc-report`(start/end·일반상품/사진인화)·`page-changed`·`state-history`·`var-added/deleted/changed` — postMessage payload 포함.
- **토큰 흐름**: access token 발급(고객사 서버→edicus server→client) 시퀀스.

## 환경변수 매핑[HARD 비밀]
`.env.local`의 EDICUS_*(PARTNER_CODE·API_KEY·API_HOST·RESOURCE_HOST·FIREBASE_*·ASSET_HOST·BASE_HOST·EDITOR_HOST·RENDER_DPI·MANAGER_*)를 SDK config/호스트/토큰 역할에 매핑. **값은 절대 출력 금지 — 키 이름과 역할만**. grep으로 값을 보지 말고 키 라인만 확인.

## 핵심 규칙
- 모든 계약에 `PDF p.N` 근거.
- 메서드/이벤트 식별자는 코드에서 grep 가능하도록 정확히(코드맵과 동일 표기).
- 미상·PDF 불명확은 "모름(PDF 미기재)"로 정직 표기.

## 산출
`_workspace/huni-edicus-codemap/01_api/`: sdk-method-catalog.md·server-api-catalog.md·passive-mode-events.md·env-mapping.md
