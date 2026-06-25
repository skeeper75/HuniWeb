# Huni-Recode 기법 플레이북 — 축약 JS → 가독 JS (동작 보존)

> 본 하네스의 **[HARD] 제약: 결과 코드는 실행 가능 동등 코드여야 한다.**
> 따라서 "LLM이 줄별로 다시 쓰기"는 사실상 금지다. 권고 파이프라인은
> **LLM 이름 추론 → AST 코드모드(scope.rename) 일괄 적용 → AST 구조 diff로 동작 보존 증명**.
>
> 산출 권위 순서: ① 1차 도구 공식 문서 > ② 정평난 OSS 리포 > ③ 블로그.
> 본 문서의 도구 동작 서술은 설치본(`_tooling/node_modules`, @babel 7.29.7 · prettier 2.8.8)
> 실측 + Babel/prettier 공식 문서 기준. 웹 미접속 환경에서는 내장 지식 + 설치본 실측으로
> 작성했으며, 각 절에 무엇을 보장/불보장하는지 명시한다.

---

## 0. 현 디옵 수준 진단 (2026-06-25 실측)

`03_deobfuscated/`의 4개 산출물을 babel parser(7.29.7)·grep으로 실측한 결과:

| 파일 | 줄수 | 잔여 단/2문자 바인딩 | 한국어 주석줄 | **구문 유효** | 디옵 등급 |
|---|---|---|---|---|---|
| `deob_05_app_api.js` | 1,507 | ~0 | 19 | **OK** | 양호 (의미 리네임+JSDoc) |
| `deob_06_app_widget_sdk.js` | 1,392 | ~0 | 26 | **OK** | 양호 |
| `deob_07_app_components.js` | 2,607 | ~0 | 0 (블록주석 위주) | **FAIL @ 105:10** | ⚠ **구문 파손** |
| `deob_editor_sdk.js` | 12,629 | ~1,084 | 58 | **OK** | 혼재 (앱 로직 리네임 / Sentry·polyfill 미처리) |

핵심 발견 (플레이북 근거):

1. **`deob_07`은 파싱 실패 = 실행 불가.** line 105가 orphan `}),` 로, 컴포넌트 본문이
   잘못 절단·접합됐다. 이는 직전 작업이 **LLM 줄단위 재작성/수기 편집**으로 진행되어
   본 하네스의 [HARD] 동작 보존 제약을 이미 위반했음을 입증한다. → **이 파일은 AST 등동성
   증명 자체가 불가하므로, 원본(`01_source` 또는 `02_beautified`)에서 AST 코드모드로 재생성**해야 한다.
2. `deob_05`/`06`은 단문자 잔여가 거의 0 — 의미 리네임이 잘 됐으나, **리네임이 텍스트가
   아니라 scope-safe AST로 적용됐는지 증거(구조 diff)는 없다.** 본 하네스는 그 증거를 만든다.
3. `deob_editor_sdk`의 잔여 단문자 ~1,084건 대부분은 **Sentry(lines 67–2534)+Babel polyfill
   /regenerator(2888–9527) = 서드파티.** 이는 리네임 대상이 아니라 **식별+분리+한 줄 요약** 대상.
   앱 로직(EditorBridge·ApiClient·DDP builder·RedEditorSDK·CustomTabManager)만 리네임한다.

---

## 1. 권고 파이프라인 (4 단계)

```
[입력: 축약/디옵 JS]
   │
   ├─ (A) Cartography — AST 인벤토리
   │      @babel/parser → AST, traverse 로 식별자/스코프/서드파티 경계 수집
   │      → 의미 리네임 맵(rename-map.json): { binding uid → newName, reason, confidence }
   │
   ├─ (B) LLM 의미 추론 (이름만)  ← LLM은 "이름 제안"만, 코드 본문에 손대지 않음
   │      API 엔드포인트/한국어 라벨/Pinia·Vue 컴포넌트명/기존 분석 리포트를 앵커로
   │      newName 을 채운다. 충돌·예약어·중복은 cartographer가 정규화.
   │
   ├─ (C) Codemod 적용 (AST, scope-safe)
   │      @babel/traverse 의 path.scope.rename(old, new) 으로 일괄 적용
   │      (binding + 모든 referencePaths 동시 갱신, shadowing 자동 회피)
   │      → @babel/generator 로 출력 → prettier 재포매팅
   │
   └─ (D) Verify — 동작 보존 증명
          G1 구문 유효 · G2 AST 구조 동등 · G3 가독성 · G4 서드파티 무변경 · G5 런타임 스모크 · G6 리네임 단사성
```

**왜 이 분업인가:** 이름의 *의미*는 LLM이 잘 추론하지만, 이름의 *적용*은 스코프를 무시하면
코드를 파손한다(§4). 그래서 "추론=LLM / 적용=AST" 로 가른다. 이는 humanify·wakaru·webcrack
계열 도구가 공통으로 채택한 패턴이다(§3).

---

## 2. 1차 도구 — 본 하네스 도구셋

설치 실측: `@babel/parser` `@babel/traverse` `@babel/generator` `@babel/types` 모두 **7.29.7**,
`prettier` **2.8.8**. (`@babel/core`·`recast` 미설치 — 아래 대안 참조.) 상세는 `toolset.json`.

### 2.1 @babel/parser — 소스 → AST
- `parse(code, { sourceType, plugins })`. 본 하네스 권고: `sourceType:"unambiguous"`(자동 판별).
  필요 시 `plugins:["jsx"]`. 본 산출물은 Vue **렌더 함수**(`createVNode` 등)라 **JSX 아님** →
  plain JS 파서로 충분(07 파일도 JSX가 원인이 아니라 절단 파손이 원인이었음, §0).
- 보장: ECMAScript 문법 파싱. 불보장: 의미·런타임 동등(파서는 구조만 본다).

### 2.2 @babel/traverse — 스코프 안전 변환의 핵심
- `path.scope.rename(oldName, newName)` — **이것이 텍스트 치환의 안전한 대체물.**
  바인딩과 그 모든 참조(referencePaths)를 한 번에 갱신하고, 충돌 시 shadowing을 피한다.
- `scope.getBinding(name)` 으로 바인딩 종류(var/let/const/param/import/function) 확인 후
  리네임 정책 분기(§4의 import/전역 가드).
- 보장: 단일 스코프 내 바인딩-참조 일관성. 불보장: 문자열/`eval`/계산 프로퍼티 안의 이름(§4).

### 2.3 @babel/generator — AST → 코드
- `generate(ast, { comments:true, retainLines:false })`. 주석 보존.
- **포매팅은 보존하지 않는다**(recast와의 차이). 그래서 prettier로 일괄 재포매팅하는 게 더
  결정적·재현 가능. (recast 미설치 = 원본 포매팅 보존은 포기, prettier 정규화로 대체 — 본
  하네스 목적은 "포매팅 최소 변경"이 아니라 "가독화"이므로 정규화가 더 적합.)

### 2.4 @babel/types — AST 노드 빌더/판별
- `t.isIdentifier`, `t.isImportSpecifier` 등으로 노드 안전 판별. 구조 diff(G2) 정규화에 사용.

### 2.5 prettier 2.8.8 — 결정적 재포매팅
- `prettier.format(code, { parser:"babel" })`. 동일 입력 → 동일 출력(결정적)이라 G2 구조 diff의
  잡음(공백/줄바꿈)을 제거한다.
- ⚠ 버전 고정: prettier는 **메이저별 포매팅이 다르다.** 2.8.8 로 고정(설치본)해야 재현된다.

### 2.6 미설치 도구에 대한 결정
- **@babel/core**: 미설치. parser+traverse+generator 직접 조합으로 충분(core는 프리셋/플러그인
  파이프라인용). 코드모드에 불필요 → 설치 안 함.
- **recast**: 미설치. "원본 포매팅 보존"이 목적이면 필요하나, 본 하네스는 prettier 정규화 채택 →
  불필요. (G2 구조 diff는 어차피 포매팅을 무시하므로 recast 없이도 동등성 증명 가능.)

---

## 3. LLM 보조 도구 계열 (참고·차용 패턴, 직접 의존 안 함)

본 하네스는 외부 LLM 도구를 런타임 의존하지 않고 **그 분업 패턴만 차용**한다(오프라인·재현성).

- **humanify** (jehna/humanify) — minified JS에 LLM으로 *이름*을 입히되, 적용은 Babel AST 변환으로
  한다. 차용점: "LLM=이름 제안 / Babel=scope-safe 적용". 본 하네스 (B)→(C) 와 동형.
- **wakaru** — webpack/rollup 번들 언번들 + 가독화. 차용점: 모듈 경계·서드파티 분리 사고.
- **webcrack** — 번들 해체 + 난독 해제(문자열 배열 복원 등). 차용점: 서드파티(폴리필/벤더) 식별
  분리. 본 산출물에는 문자열-배열 난독은 없으나(이미 beautified) 서드파티 경계 판정에 사고가 유용.
- (출처 확인 주의) 위 3종 도구의 *현재 버전·API*는 웹 미접속으로 미확인 — **본 하네스는 이들을
  설치/호출하지 않으므로** 버전 의존 위험 없음. 차용하는 것은 "추론/적용 분업" 개념뿐이다.

---

## 4. 함정 카탈로그 (동작 파손 원인 — [HARD] 회피)

| # | 함정 | 왜 파손되나 | 회피 |
|---|---|---|---|
| F1 | **텍스트 치환**(sed/정규식 리네임) | 스코프 무시 → 다른 스코프 동명 식별자·부분일치 오염. **07 파일 파손이 이 계열(수기 편집)의 결과** | `scope.rename`만 사용. 텍스트 치환 절대 금지 |
| F2 | **자유 참조 헬퍼/전역 바인딩** | 모듈 밖에서 정의된 전역(`window`, Vue 런타임 `createVNode` 등)을 리네임하면 참조가 깨진다 | `scope.getBinding(name)`이 **존재하고 local**일 때만 리네임. 전역/미선언은 제외 |
| F3 | **import/export 바인딩** | named import를 리네임하면 모듈 계약이 깨진다 | importSpecifier의 `imported` 이름은 불변; local alias만, 그것도 신중히 |
| F4 | **프로퍼티명 ≠ 변수명** | `obj.COD`, `{ COD_NME }` 의 키는 식별자가 아니라 **데이터 계약**(서버 API 필드) | 프로퍼티 키 리네임 금지. `preserved_identifiers`(PDT_CD·MTRL_CD·COD·PRICE…)는 동결 |
| F5 | **계산 프로퍼티·문자열 키** | `obj[name]`, `obj["COD"]`, JSON 키는 AST 리네임이 닿지 않음(닿으면 안 됨) | 동결. 리네임 맵에 절대 포함 금지 |
| F6 | **`eval`/동적 접근** | 문자열 안 식별자는 정적 분석 밖 | 발견 시 해당 스코프 리네임 보류·플래그 |
| F7 | **getter/setter·shorthand 메서드명** | 메서드 이름은 객체 계약 | 클래스/객체 메서드명 동결(외부 호출 계약) |
| F8 | **서드파티 경계 오판** | Sentry(67–2534)·polyfill(2888–9527)을 리네임하면 잡음·파손 위험 | 섹션 라인 경계로 서드파티 식별 → 리네임 제외, 한 줄 요약만 |
| F9 | **prettier 버전 드리프트** | 다른 prettier 버전 = 다른 포매팅 = G2 잡음 | 2.8.8 고정(toolset.json) |
| F10 | **리네임 비단사(중복 newName)** | 두 바인딩 → 한 이름 = 충돌/그림자 | 적용 전 newName 유일성 검사(G6) |

---

## 5. 검증 전략 — G1~G6 게이트 (verifier 권고)

동작 보존 = **"리네임·주석·포매팅만 바뀌고 프로그램 구조는 동일"** 을 증명하는 것.

### G1 — 구문 유효 (필수, 단독 FAIL=NO-GO)
`@babel/parser`로 산출물 파싱 성공. **07 파일은 현재 G1 FAIL** → 재생성 필요.

### G2 — AST 구조 동등 (핵심 동작 보존 증명)
원본 AST와 산출 AST를 **정규화 후 비교**:
1. 모든 Identifier name·주석·공백을 정규화(이름→`$ID`, 주석 제거, prettier 재포매팅).
2. 정규화 후 두 AST의 **노드 종류·중첩 구조·리터럴 값·연산자**가 완전 일치하면 PASS.
3. 불일치 노드를 리포트(어디서 구조가 바뀌었는지 = 동작 변경 후보).
- 보장: 식별자명/주석/포매팅 외 변경 없음을 *구조적으로* 입증. 불보장: 런타임 의미(→ G5 보완).
- 구현 권고: traverse 로 (type, 자식 형태, 리터럴) 시그니처를 직렬화해 diff.

### G3 — 가독성 지표
산출물에서 **본 로직 스코프의 잔여 단문자 식별자 = 0**(서드파티 제외).
05/06은 통과 수준, editor_sdk는 앱 로직 스코프만 측정(Sentry/polyfill 제외).

### G4 — 서드파티 무변경
서드파티 섹션(Sentry·polyfill)은 **바이트 단위 무변경**(또는 라인 범위 해시 동일). 리네임이
서드파티 경계를 넘지 않았음을 증명.

### G5 — 런타임 스모크/차등 (선택, 가능 시)
- 순수 함수(`debounce`·`isEmpty`·`buildQueryString`·`objectToQueryParam` 등)는 원본/산출 양쪽을
  로드해 동일 입력→동일 출력 차등 비교.
- DOM/네트워크 의존부는 스모크 불가 → G2 구조 동등으로 대체.

### G6 — 리네임 맵 단사성/완전성
rename-map의 newName이 스코프 내 유일(F10), 모든 매핑이 실제 바인딩에 적용됐는지 역검.

**게이트 정책:** G1 단독 FAIL = NO-GO. G2 불일치 = 동작 변경 의심 = NO-GO(원인 규명 전 진행 금지).
G3~G6은 등급 판정. 생성자(engineer)와 검증자(verifier)는 분리(생성≠검증).

---

## 6. 파일별 작업 권고

- **deob_05 / deob_06**: 이미 의미 리네임 양호. 본 하네스는 *원본→AST 코드모드 재생성*으로
  G2 구조 동등 **증거를 부여**(현재는 증거 없는 결과물). 잔여 단문자 0 유지.
- **deob_07_app_components**: **G1 FAIL(파손).** LLM 줄단위 편집의 잔해. 원본(`01_source`/
  `02_beautified`)에서 AST 코드모드로 **재생성** 후 G1~G2 통과시킨다. 기존 deob_07의 한국어
  주석·컴포넌트 맵은 *주석 주입 입력*으로만 재사용(코드 본문은 신뢰 불가).
- **deob_editor_sdk**: 서드파티(Sentry 67–2534, polyfill 2888–9527)를 라인 경계로 **분리·동결**,
  앱 로직(EditorBridge·ApiClient·DDP builder·RedEditorSDK·CustomTabManager) 스코프만 리네임.
  ~1,084 잔여 단문자 대부분이 서드파티이므로 G3는 앱 스코프 한정 측정.

---

## 7. 한 줄 요지

> **이름은 LLM이 추론하고, 적용은 Babel `scope.rename`이 하며, 동작 보존은 AST 구조 diff가 증명한다.
> 텍스트 치환·프로퍼티명·서드파티는 건드리지 않는다. 07 파일은 이미 파손(G1 FAIL)되어 재생성 대상이다.**
