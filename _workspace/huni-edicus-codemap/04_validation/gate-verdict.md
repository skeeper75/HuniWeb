# Huni-Edicus-Codemap — 독립 검증 게이트 판정 (hec-validator) · v2 재검증

> 생성≠검증. 본 판정은 생성자 주장을 신뢰하지 않고 원본(Edicus PDF·`docs/reversing/.../deob_editor_sdk.js`·`docs/edicus.man/src/**`·`.env.local` 키)을 직접 재실측한 결과다.
> **v2 = 역공학(RedEditorSDK·KOI-Passive) 양면 보강분 재검증.** v1(첫 산출)은 `gate-verdict-v1.md`로 보존.
> 검증 대상(재실행 산출): `01_api/rededitor-sdk-catalog.md`(신규)·`passive-mode-events.md`(양면 갱신) · `02_codemap/passive-channel-binding.md`(신규)·`hooks-and-edicus-wiring.md`·`code-facts.csv` · `03_flow/03_passive-layers.md`(신규)·`01_flows`·`02_code-api-wiring`·`README`.
> 재실측 도구: `sed`/`grep`(deob_editor_sdk.js file:line) · `grep -rn`(from-edicus / From-KOI-Passive in src, import 전수) · Read(PDF) · env 누출 스크립트(값 비출력).

---

## 종합 판정: **GO**

재실행의 핵심 두 주장 — ① 역공학 근거(`deob_editor_sdk.js:라인`)의 실재성, ② "후니=공식 from-edicus / KOI-Passive=잔재"의 코드 실증 — **둘 다 직접 재실측으로 확정**됐다. 표본 재실측에서 날조 0건. 라인 인용은 ±1~4 미세 오프셋이 있으나(아래 C1) 가리키는 코드 사실은 전건 정확. 비치명 어드바이저리 1건(C6 공개 호스트)뿐.

| 게이트 | 판정 | 한줄 근거 |
|---|---|---|
| C1 API 계약 충실성(역공학 근거 실재) | **PASS** | KOI-Passive 리스너 `q`·4 type·`fromKOIPassive`·`hideToolbar→passive`·`run_mode` 전 인용 verbatim 확인. 라인은 listener `q`가 `:10455`(switch `:10458`)로 카탈로그와 정합 |
| C2 코드맵 정확성 | **PASS** | `passive-channel-binding.md`의 huni src file:line 표본(huni-editor-sdk.ts:129/138/278/288, EdicusEditor:89, MobileEditor:90, VdpEditor:85) 전건 일치 |
| C3 코드↔API 배선 정합[핵심] | **PASS** | from-edicus=huni 자체코드 사용·From-KOI-Passive=`lib/red-editor/analyzed/`에만(런타임 import 0건) — "잔재" 결론 코드로 실증. 14→4 N:1 매핑 정합(추정분은 정직 표기) |
| C4 다이어그램 렌더가능성 | **PASS** | `03_passive-layers.md` mermaid 4/4 펜스 균형·전 노드 ASCII id·라벨 quote·`%% 잔재` 주석 정상. 전 파일 펜스 균형 |
| C5 완전성 | **PASS** | 양면 passive(공식14·KOI4)·RedEditorSDK 45메서드 카탈로그·후니 채택 결론·트리거 체인·라우트→훅→채널 매핑 전부 반영 |
| C6 비밀값 비노출[HARD] | **PASS (advisory)** | 진짜 시크릿(API_KEY·FIREBASE_API_KEY·MANAGER_PW·MANAGER_ID) 노출 **0**. 노출분은 PDF/배포가이드가 이미 공개한 PaaS 호스트/Firebase 도메인뿐 |

---

## C1 — API 계약 충실성 (역공학 근거 실재) : PASS

`rededitor-sdk-catalog.md`·`passive-mode-events.md`의 역공학 `deob_editor_sdk.js:라인` 인용을 `sed`/`grep`으로 직접 대조. 전건 verbatim 확인:

| 카탈로그 주장 | 재실측 결과 | 비고 |
|---|---|---|
| KOI-Passive 리스너 `q` `:10455-10472`, switch `:10458` | `q = function(t)` = **L10455**, `switch (e.type)` = **L10458** | 정합 |
| 4 type 핸들러 load/save/error/close `:10459-10470` | `case "load": A=!1, D("projectId", e.info.info.project_id), f(e.info)` L10459-10461 / save `h` L10462-10463 / error `H` L10465-10466 / close `d` L10468-10469 | **verbatim 일치** |
| `fromKOIPassive` `:10513` | `K.fromKOIPassive = t.fromKOIPassive, K.mode = "standard", K.deviceTarget = "pc"` = **L10513** | 정합 |
| `hideToolbar→K.mode="passive"` create `:10666`/open `:10860`/reform `:11044` | 3곳 모두 `n.hideToolbar && (...K.mode = "passive")` 확인 | 정합(3 분기 전부) |
| iframe `run_mode: hideToolbar ? "passive":"standard"` `:10762/10955/11059/11129` | 4곳 모두 확인 | 정합 |
| URL 빌더 `&run_mode=` `:2642` | `(e.run_mode ? "&run_mode=" + e.run_mode : "")` = **L2642** | 정합 |
| `(KOI-Passive)` 로그 라벨 `:11356/11387/11404/11433` | 4곳 모두 `K.fromKOIPassive ? "(KOI-Passive)" : ""` 확인 | 정합 |
| 역방향 토큰갱신 `{target:"KOI-SDK",action:"refreshToken"}` `:10522-10529` | 생성자 `autoRefreshToken` 콜백 내 동일 객체 확인 | 정합 |

- **공식 PDF 측**: `passive-mode-events.md` PART A의 14 action·info 페이로드(var-* = `itemPath{item_id,page_id,page_index}`·`varInfo{type,id,title,group_id,extra}`·`data{text}`)를 SDK PDF로 대조 — PDF의 itemPath/varInfo/var-changed 테이블과 **구조 일치**. (PDF 인쇄 페이지번호 ≠ 파일 물리 페이지 오프셋. v1에서 p.3-6,15-16 이미 정확 확인.)
- **미세 오프셋**: 카탈로그 본문이 listener를 `:10455-10472`로, 일부 서술이 switch를 `:10458`로 표기 — 실제와 정합(listener 시작 10455, switch 10458). `f/h/H/d` minified 핸들러 emit 대상은 카탈로그가 정직하게 "모름(code-cartographer)"으로 표기 — 환각 아님.

판정: **PASS**. 역공학 근거 전부 실재. 날조 0.

## C2 — 코드맵 정확성 : PASS

`passive-channel-binding.md`의 huni `src` file:line 표본 재실측:
- `huni-editor-sdk.ts:129-131` `if (this._isPassiveMode) { projectParams.run_mode = 'passive'; }` ✓
- `huni-editor-sdk.ts:138-139` `const eventType = (data...).type ?? (data...).action;` ✓
- `huni-editor-sdk.ts:278` `if (!event.origin.includes(TRUSTED_ORIGIN)) return;` ✓ / `:288` `data.action ?? data.type` ✓ / `_mapToHuniEvent` ready·close·doc-changed·ready-to-listen·save-complete·error ✓
- `EdicusEditor.tsx:89` `const action = data.action ?? data.type;` ✓ (request-user-token·close·goto-cart)
- `MobileEditor.tsx:90` `const action = data.action ?? data.type;` ✓ / `:161` `extraParams.run_mode = 'passive';` ✓
- `VdpEditor.tsx:85` `const action = data.action ?? data.type;` ✓
- `types/edicus.ts:70-72` `// from-edicus-* 타입 메시지` + `type: string` ✓ / `:111` `run_mode?: string  // .. / passive` ✓

판정: **PASS**. 표본 전건 일치.

## C3 — 코드↔API 배선 정합 [핵심] : PASS

재실행의 중심 결론을 grep 전수로 독립 재실측.

**"후니 코드가 from-edicus를 보는가"** — YES:
- `grep -rn from-edicus src --include=*.ts(x) | grep -v /analyzed/` → huni 자체코드 매칭 2건(`types/edicus.ts:71` 계약 정의, `red-editor-sdk.d.ts:243` 타입 doc). 런타임 핸들러는 일관되게 `data.action ?? data.type`로 from-edicus 이벤트(request-user-token·close·goto-cart·doc-changed·ready-to-listen·save-complete·error) 분기 — KOI 4종(load/save/error/close)과 **명칭·의미 불일치** 확인.

**"From-KOI-Passive가 런타임 0건·잔재인가"** — YES(실증):
- `grep -rn "From-KOI-Passive\|fromKOIPassive" src --include=*.ts(x) | grep -v /analyzed/` → **0건**(exit 1). 전 매칭이 `src/lib/red-editor/analyzed/`(es6-converted.js:14003, formatted.js:14415) 내부 = 벤더링된 RedEditorSDK 난독화 해제본.
- `lib/red-editor/` **외부 importer 전수 grep = 0건**. 유일 매칭은 `types/edicus.ts:347` 주석 1건(타입 출처 설명)뿐. → 어떤 라우트/컴포넌트도 RedEditorWrapper/window.RedEditorSDK를 `new`/import하지 않음. "잔재" 결론 코드로 확정.

**양면 매핑(14→4 N:1)**: PART C 매핑표(load←load-project-report/project-id-created/doc-changed, save←save-doc-report, error←error-report/change-*error, close←close)는 `:10459-10469` 코드 + PDF action으로 정합. 게이트웨이(별 코드, 미보유) 의존분은 점선·"부분 추정"으로 정직 표기 — 환각 위장 아님.

판정: **PASS**. 배선 역전·환각 0. 핵심 결론 실증.

## C4 — 다이어그램 렌더가능성 : PASS

- 펜스 균형: `00_architecture`(2/2)·`01_flows`(3/3)·`02_code-api-wiring`(4/4)·`03_passive-layers`(4/4) — 전부 open-mermaid = close-fence. js 코드블록 포함 비-mermaid 펜스도 짝수.
- `03_passive-layers.md` 문법: 노드 id 전부 ASCII(a1-a12·t1-t4·he/ee/me/ve/pc/ec·start/flag/opt 등), 라벨·엣지라벨 전부 quote 처리, `<br/>` 사용 정상, `%% 잔재…` 주석 유효, subgraph id ASCII+title quote. **비ASCII id 함정 없음.** classDef/class 구문 정상.

판정: **PASS**.

## C5 — 완전성 : PASS

재실행 보강 요소 빠짐없이 반영:
- 양면 passive: 공식 14 action(PART A·payload 포함) + KOI 4 type(PART B·트리거 체인) + 양면 매핑(PART C).
- RedEditorSDK 45메서드 카탈로그(템플릿5·프로젝트7·UI5·VDP3·라이프5·인증5·이벤트2·조회9·주문1·데이터2·기타1) + on() 22 이벤트.
- 후니 채택 결론: 라우트→훅→실런타임 lib→채널 매핑표(`passive-channel-binding.md §4`), flow C(후니=공식·KOI=잔재) 도해.
- "기타(1)"·게이트웨이 변형분·minified 핸들러 emit·ready-to-listen info 등 미상은 정직하게 "모름" 표기.

판정: **PASS**.

## C6 — 비밀값 비노출 [HARD] : PASS (advisory)

값 비출력 스크립트로 `.env.local` ↔ 산출 대조:
- **진짜 시크릿 전건 clean**: `EDICUS_API_KEY`·`EDICUS_FIREBASE_API_KEY`·`EDICUS_MANAGER_PW`·`EDICUS_MANAGER_ID` → 어느 산출에도 값 미출현(0건).
- 매칭된 7건은 전부 **host/domain/id 류**(API_HOST·RESOURCE_HOST·ASSET_HOST·EDITOR_HOST·FIREBASE_AUTH_DOMAIN·PROJECT_ID·STORAGE_BUCKET). 이 중 firebase 도메인(`edicusbase.firebaseapp.com`)은 **deob RE 소스(3회)·huni 자체코드(1회)에 하드코딩된 공개 엔드포인트**이며, env-mapping.md는 기본값을 PDF/`deployment-guide.md` 권위로 인용(`.env.local` 값 미열람 명시).
- `env-mapping.md` 모두 "값은 절대 출력하지 않는다 — 키 이름과 역할만" 선언 준수.

→ 시크릿/비밀번호 노출 0 = **HARD 통과**. 어드바이저리: 공개 PaaS 호스트 기본값이 본문에 보임(보안 위험 아님·PDF 기공개) — 원하면 env-cartographer가 호스트 기본값도 키명만으로 축약 가능.

판정: **PASS (advisory)**.

---

## 후니 passive 채널 결론 — 실증 여부

**실증됨(GO).** 핵심 결론 "후니 edicus.man 런타임 = 공식 Edicus `from-edicus`(14 action) 채널만 사용 / RedEditorSDK `From-KOI-Passive`(4 type)는 `src/lib/red-editor/analyzed/`에만 존재하는 역공학 잔재(런타임 import 0건)"는 grep 전수·import 전수·핸들러 식별키(`data.action ?? data.type`) 재실측으로 코드 실증됨. passive 진입은 공식 `run_mode='passive'` URL 파라미터(huni-editor-sdk.ts:129-131·MobileEditor.tsx:161)이며 후니는 `hideToolbar`(KOI 트리거)를 런타임에서 쓰지 않음.

## 발견 결함

- **치명(NO-GO): 없음.**
- **비치명/어드바이저리**:
  1. (C6) 공개 PaaS 호스트/Firebase 도메인 기본값이 env-mapping.md·rededitor-sdk-catalog.md에 표기 — 시크릿 아님(PDF/배포가이드 기공개). 라우팅: 선택적 축약 가능, 필수 아님.
  2. (C1) 라인 인용에 ±1~4 미세 오프셋 표기(예 listener "10455-10472" vs switch "10458") — 가리키는 코드는 정확. 라우팅: 불요(허용 범위).
- 부분 추정·미상은 산출이 이미 정직 표기(14→4 게이트웨이 묶음·minified emit·ready-to-listen info) — dodge 아님.

## 수정 라우팅
- C6 어드바이저리(선택): `hec-api-cartographer` — 공개 호스트 기본값도 키명/역할만으로 축약(원할 경우).
- 그 외: 수정 불요. **GO.**
