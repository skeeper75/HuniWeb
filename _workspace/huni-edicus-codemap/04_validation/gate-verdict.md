# Huni-Edicus-Codemap — 독립 검증 게이트 판정 (hec-validator)

> 생성≠검증. 본 판정은 생성자 주장을 신뢰하지 않고 원본(Edicus PDF·`docs/edicus.man/src/**`·`.env.local` 키)을 직접 재실측한 결과다.
> 검증 대상: `01_api/` · `02_codemap/` · `03_flow/`.
> 재실측 도구: Read(PDF pages 3-6, 15-16) · Grep/sed(소스 file:line) · env 누출 스크립트(값 비출력).

---

## 종합 판정: **GO** (어드바이저리 2건 — NO-GO 아님)

핵심 게이트 C3(코드↔API 배선)·C6(비밀 비노출) 모두 PASS. 표본 재실측에서 날조 0건. 발견된 흠은 모두 비치명적(라인 번호 ±1 오프셋, 공개 호스트 값 노출 어드바이저리)으로 수정 라우팅만 첨부한다.

| 게이트 | 판정 | 한줄 근거 |
|---|---|---|
| C1 API 계약 충실성 | **PASS** | PDF p.3/p.5 표본 직접 대조 — init config·create_project params·change_template 샘플(`90x50@NC`/`4201.json`) 정확. 날조 0 |
| C2 코드맵 정확성 | **PASS (nit)** | file:line 표본 전건 일치. 단 huni-editor-sdk redo `:199`→실제 `:200`(±1) |
| C3 코드↔API 배선 정합[핵심] | **PASS** | 10개 불일치 중 표본(#1·#2·#3·#4·#8) 전부 실재 확인. 배선 역전·환각 0 |
| C4 다이어그램 렌더가능성 | **PASS** | mermaid 펜스 균형(2/2·3/3·3/3). 노드/엣지 문법 정상 |
| C5 아키텍처 완전성 | **PASS** | 4 hook·10 route·3 클라lib·미들웨어·Edicus 핵심 메서드/이벤트/토큰·Firebase 전부 반영 |
| C6 비밀값 비노출[HARD] | **PASS (advisory)** | 진짜 시크릿(API_KEY·MANAGER_PW·FIREBASE_API_KEY) 노출 0. 노출분은 PDF가 이미 공개한 PaaS 호스트/도메인뿐 |

---

## C1 — API 계약 충실성: PASS

직접 재실측(Read PDF pages):
- **SDK p.3 `init`**: PDF 표 = `base_url / string / (default) / 에디쿠스 편집기 base url`. 샘플 `let editor = window.edicusSDK.init({});`. → catalog §1 정확 일치.
- **SDK p.4 `destroy`**: `parent_element / HTMLDomElement`. → catalog §2 일치.
- **SDK p.5 `create_project`**: PDF params 표(parent_element·partner·token·mobile=false·div=host·lang=ko·ui_locale·ps_code·template_uri·title·run_mode='standard'·edit_mode='standard'·num_page·max_page·min_page) → catalog §3 표와 전건 일치(키·타입·default·설명).
- **SDK `change_project`/`change_template`**: 샘플 `editor.change_template({ ps_code:"90x50@NC", template_uri:"gcs://.../4201.json" })` → catalog §8 verbatim 일치.
- **Server API p.3 호스트**: `api-dot-edicusbase.appspot.com`(p.3)·`resource-dot-edicusbase.appspot.com`(p.36) → server-api-catalog 정확.

**PDF p.N 라벨 주의(흠 아님)**: PDF 내부 페이지 라벨과 뷰어 물리 페이지가 1~2p 오프셋(표지/목차 때문). catalog는 PDF가 인쇄한 섹션 라벨을 인용 — 내용은 정확하므로 날조 아님. 향후 독자 혼선 방지용으로 "물리 p" 병기는 선택 개선.

정직 표기 양호: init/destroy/close 반환값 "모름(PDF 미기재)", request-feature enum 일부 "모름" 명시.

## C2 — 코드맵 정확성: PASS (nit 1건)

재실측 일치(`sed -n`):
- `useEdicus.ts` :90 `.init()` / :105 `destroy` / :130 `createProject` / :152 `openProject` / :167 `close` / :172 `postToEditor` — 전건 일치.
- `client.ts` :158 `window.edicusSDK.init({base_url})` / :185 `create_project` / :199 `open_project` / :212 `close` / :222 `destroy` / :236 `post_to_editor` — 전건 일치.
- `huni-editor-sdk.ts` :17 `TRUSTED_ORIGIN` / :208-210 `save-doc` / :263 body-less fetch / :278 origin 검증 — 일치.

**nit**: hooks-and-edicus-wiring.md:47 + code-facts.csv:9가 redo를 `huni-editor-sdk.ts:192`(undo와 동일 라인)로, 02_code-api-wiring은 redo `:199`로 표기 — 실제 redo는 **:200**(undo=:192). 1~8라인 오프셋, 심볼·동작은 정확. → **C2 통과(수정 권고)**.

## C3 — 코드↔API 배선 정합[핵심]: PASS

생성자 주장 10건 중 표본 5건 독립 재확인 — **전부 실재**:
- **#1 zustand/react-query 미사용**: `grep` src 전체 사용 0건, 단 package.json deps에는 존재(`@tanstack/react-query`·`zustand`) → 주장 정확.
- **#2 토큰 발급 body 불일치**: `auth/route.ts` = `uid` Zod 필수(`uid: z.string().min(1)`); EdicusEditor.tsx:35-37·MobileEditor.tsx:35·VdpEditor.tsx:41·huni-editor-sdk.ts:263 모두 `fetch('/api/edicus/auth',{method:'POST'})` **body 없음**; `useAuth`만 `{uid}` 전달 → 400 위험 주장 정확.
- **#3 useOrder 서브경로 부재**: useOrder가 `/orders/tentative|definitive|cancel` POST하나 `app/api/edicus/orders/`에는 `route.ts` 단일 파일뿐(서브경로 핸들러 0) → 주장 정확.
- **#4 RedEditorWrapper 미배선**: `red-editor/wrapper`·`RedEditorWrapper` import 0건 → 주장 정확.
- **#8 VDP `set-variable-data`**: VdpEditor.tsx:123 `postToEditor('set-variable-data',{variableData})` 실재. SDK PDF post_to_editor action 표(p.15)에 미열거 → "PDF 미기재 action(모름)" 정직 표기 정확.

추가 확인: middleware matcher = `/admin` + `/editor`만(`middleware.ts:10-11`), `/vdp`·`/mobile` 비보호 — 00_architecture 도해와 일치. 배선 역전·없는 화살표 창작·코드에 없는 호출 그림 = **0건**.

## C4 — 다이어그램 렌더가능성: PASS

- 펜스 균형: 00_architecture 2/2, 01_flows 3/3, 02_code-api-wiring 3/3, README 0/0 — 전부 균형.
- 다이어그램 종류: flowchart(TB/TD/LR)·sequenceDiagram·stateDiagram-v2. subgraph 닫힘·classDef·rect/note 블록 문법 정상. `%% 불일치` 주석은 mermaid 주석 문법 준수.

## C5 — 아키텍처 완전성: PASS

레이어 커버리지: 라우트(공개5·편집기2·모바일2·admin14·API route10)·hooks 4종(useEdicus·useHuniEditor·useAuth·useOrder)·클라lib(EdicusClient·HuniEditorSDK)·서버lib(server-api·resource-api·env·custom-css·mobile-config)·미들웨어·외부 경계(Edicus SDK iframe·Server/Resource API·Firebase Auth·S3 boundary)·types — 빠짐없이 반영. Edicus 핵심 메서드(init·create/open_project·post_to_editor·close/destroy)·패시브 이벤트(ready-to-listen·load-project-report·doc-changed·save-doc-report·request-user-token·close)·토큰 흐름 모두 도해. S3/presigned는 코드 경계 밖 점선 boundary로 정직 표기.

## C6 — 비밀값 비노출[HARD]: PASS (advisory)

누출 스크립트(.env.local 값 vs 산출물, 값 비출력) 결과:
- **진짜 시크릿 전부 CLEAN(노출 0)**: `EDICUS_API_KEY`·`EDICUS_MANAGER_PW`·`EDICUS_MANAGER_ID`·`EDICUS_FIREBASE_API_KEY`·`EDICUS_FIREBASE_MESSAGING_SENDER_ID`·`EDICUS_FIREBASE_DATABASE_URL`.
- 스크립트가 일치로 플래그한 7개 키는 모두 **비밀이 아닌 공개 인프라 식별자**:
  - `EDICUS_API_HOST`(`api-dot-edicusbase.appspot.com`)·`EDICUS_RESOURCE_HOST`(`resource-dot-edicusbase.appspot.com`) — **Edicus PDF가 p.3/p.36/p.40에 직접 인쇄한 공개 base URL**. catalog가 PDF 인용으로 적은 것.
  - `EDICUS_EDITOR_HOST`·`EDICUS_ASSET_HOST`·`EDICUS_FIREBASE_AUTH_DOMAIN`·`EDICUS_FIREBASE_STORAGE_BUCKET`·`EDICUS_FIREBASE_PROJECT_ID` — 공개 PaaS 호스트/Firebase web config 식별자(Firebase 설계상 클라 노출 가능·비밀 아님). env-mapping.md가 "기본값/공개 가능"으로 정직 라벨.

**판정**: [HARD] 위반(시크릿 노출)은 없음 → C6 PASS. 다만 운영 호스트가 깃 추적 `_workspace/`에 평문으로 박힌 것은 정보위생상 바람직하지 않으므로 어드바이저리로 표기(노출 자체는 PDF/공개 정보라 위험도 낮음).

---

## 발견 결함 & 수정 라우팅

| # | 게이트 | 결함 | 심각도 | 라우팅 |
|---|---|---|---|---|
| F1 | C2 | redo 라인 `:199`/`:192` 표기 ≠ 실제 `:200` (undo=:192) | 낮음(nit) | code-cartographer + flow-author — code-facts.csv:9·hooks-and-edicus-wiring.md:47·02_code-api-wiring.md:88 redo 라인 `:200`으로 정정 |
| A1 | C6 | 공개 PaaS 호스트 값이 git 추적 산출물에 평문(시크릿 아님) | 어드바이저리 | api-cartographer — 선택: env-mapping에서 실제 host 문자열을 `{HOST}` 플레이스홀더로 치환(PDF 공개 default만 표기 유지). 강제 아님 |
| N1 | C1 | PDF p.N = 섹션 라벨(물리 페이지와 1~2p 오프셋) | 정보 | api-cartographer — 선택: "물리 p" 병기로 독자 점프 편의 개선 |

본 3건 모두 GO를 막지 않는다(배선 역전·시크릿 노출 없음).

## 비밀 노출 여부 (요약)
**노출 없음.** 진짜 시크릿 6종 전수 clean. 플래그된 7종은 PDF/공개 인프라 식별자(비밀 아님). 값은 본 판정서 어디에도 출력하지 않음(키 이름만).
