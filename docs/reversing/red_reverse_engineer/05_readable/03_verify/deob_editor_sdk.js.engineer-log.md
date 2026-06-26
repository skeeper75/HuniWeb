# engineer-log — deob_editor_sdk.js (가독화 변환 레인 · 재시도 #4)

생성(변환) 레인. [HARD] 텍스트 치환 없음 — 전부 AST 바인딩 단위 `scope.rename`. 동작 보존.

## 재실행 #4 — 명령조립 블록 잔여 18건 해소 (structural-rename 일반화)

**직전 NO-GO 사유(attempt #3 verdict)**: G4 가독성 NO-GO — proprietary 스코프(readable line 14441~15009 명령조립 블록)의 단축 지역변수 **18건**(`it`/`pt`/`dt`/`mt`/`bt`/`xt`/`Pt`/`Ft`/`Ht`/`Wt`/`$t`/`re`/`le`/`Se`/`Ce`/`Ae`/`Ge`/`Xe`) 잔존. `residualShortBindings=18 pass=false`. 0 목표 미달.

**근본원인(독립 진단)**: 이 18건은 전부 **for-루프 안의 단일대입 `var X = <init>` 명령 빌더/구조분해 페어**다. 그런데 babel 은 루프-안 `var` 선언의 declarator(`X=init`)를 매 iteration 재실행으로 보아 `constantViolations` 에 1건 집계한다(노드=그 선언 자체·같은 줄). structural-rename 의 alias 패스가 `constantViolations.length>0` 이면 무조건 skip 하므로 — **진짜 재대입이 아닌 루프-재실행 위장 false-positive** 까지 걸러져 의미명을 못 받았다. (rename-map 결함·동작 결함 아님 — 스크립트 일반화 갭.)

**처치(스크립트 일반화·하드편집 아님)** — `rcd-ast-deobfuscate/scripts/structural-rename.cjs` 4개 보강(전부 RHS/사용맥락에서 이름을 "읽음"·추측 0·동작 보존):
1. `violationsAreOnlyOwnDeclarator(b)` 신설 — constantViolation 이 전부 그 바인딩 **자신의 선언 declarator(루프-재실행)** 일 때만 alias 허용. 다른 사이트 재대입은 여전히 제외(안전). → `it`(copyPageContentCommand)·`pt`(addPageCommand)·`mt`(_destructured)·후속 명령객체 다수 해소.
2. `aliasNameFromInit` 에 **기본값 관용구** 추가: `var X = MEMBER || default` / `?? default` → MEMBER 의 prop 명. → `dt`(`_iterValue9.bgColor||"#ffffff"` → **bgColor**).
3. `aliasNameFromInit` 에 **숫자 인덱스 멤버** 추가: `var X = OBJ[N]` → `<objName>N`(위치 사실 표기). → `bt`/`xt`(`_destructured[0]`/`[1]` → **_destructured0**/**_destructured1**).
4. `aliasNameFromInit` 에 **판별 페이로드 객체** 추가: `{src_type|type|kind:"..."}`(action/type 관용구 아님) → `<disc>Payload`. → `Ft`(**urlPayload**)·`Wt`(**srcInfoPayload**).
5. `aliasNameFromUsage(b)` 신설(init 으로 못 읽을 때 사용맥락 판독): (a) 지연 action 빌더 `var X={}; X.action="add-cell"` → `<action>Command`(`Pt`→**addCellCommand**) (b) `post_to_editor("set-cell-src-infos", X)` 2번째 인자 → `<cmd>Payload`(`Ht`→**setCellSrcInfosPayload**).

### 입력 (재실행 #4)
- rename-map: **91 entries**(직전 동일·맵 미변경 — 스크립트 일반화만으로 해소). comment-map / thirdparty-ranges 동일(3 ranges).

### Step 1 — apply-rename-map.cjs (의미 우선)
- **applied = 85, skipped = 0** (직전 동일). preserve 자동 제외·의미 엔트리 선행 적용. `skipped.json {applied:85, skipped:[]}`.

### Step 2 — structural-rename.cjs (잔여 구조/alias 라벨)
- **renamed = 392** (aliasRenamed **124** · regRenamed 93 · residualLabeled 0). **alias 70→124(+54)** = 위 보강이 명령조립 블록 빌더/페어를 의미명으로 해소(루프-재실행 false-positive 통과 + 4 신규 패턴). `--label-residual` 미사용(의미명만으로 잔여 0 달성).

### Step 3 — fold-thirdparty.cjs
- ranges = 3. 본문 인덱스 배너만 주입(동작 불변)·서드파티 추출본 분리(418,159 bytes).

### Step 4 — 자가 점검 (직접 실측)
- **G1 parse-check / `node --check` → OK** (666,945 bytes).
- **G4 readability-metrics → residualShortBindings=0 shortCallees=0 pass=true** (직전 18 → **0** · 목표 달성). G4b mechanicalRoleNames=268(잔존은 _iter*/_reg* 헬퍼 역할명·비핵심).
- **G2 ast-structural-diff → pass=true · structSigLenA==structSigLenB==2,440,905(완전 일치) · propsEqual=true · litsEqual=true**. 54 추가 리네임이 구조/프로퍼티/리터럴에 **0 변경** → 순수 바인딩 rename(동작 보존 재입증).
- **G3 in-place fold 무손실**: captureException=7/7·regeneratorRuntime=31·_babelPolyfill=4 본문 잔존.

### 산출 (갱신)
- `02_readable/deob_editor_sdk.js` (666,945 bytes · node --check OK · 명령조립 18건 의미명 해소)
- `02_readable/deob_editor_sdk.js.thirdparty.js` (418,159 bytes · G3 참조본)
- `03_verify/deob_editor_sdk.js.skipped.json` (applied=85 skipped=0)
- `03_verify/deob_editor_sdk.js.structural-rename.json` (renamed=392 alias=124 regReg=93 residual=0)
- `03_verify/deob_editor_sdk.js.metrics.json` (residualShortBindings=0 pass=true)
- `03_verify/deob_editor_sdk.js.structdiff.json` (props/lits 동일 · structSigLen 완전 일치 = G2 보존)
- 스크립트 보강 반영: `rcd-ast-deobfuscate/scripts/structural-rename.cjs`(다음 파일·세션 재사용·라인좌표 드리프트 내성).

---

# engineer-log — deob_editor_sdk.js (가독화 변환 레인 · 재시도 #3)

생성(변환) 레인. [HARD] 텍스트 치환 없음 — 전부 AST 바인딩 단위 `scope.rename`. 동작 보존.

## 재실행 #3 — 보강된 rename-map 재적용 (의미 우선 순서)
**핵심 변경**: cartographer가 rename-map을 **91 entries로 보강**(직전 87→91). 의미 엔트리가 structural-rename보다 **먼저** 적용되도록 체인 순서 고정 — Step 1(apply-rename-map=의미)이 Step 2(structural-rename=구조 라벨)보다 선행하므로, 의미명이 우선권을 갖고 structural-rename은 잔여만 라벨한다.

### 입력 (재실행 #3)
- rename-map: **91 entries** = module-scope preserve(도메인코드) 35 + iife:78 리네임 41 + scope 미지정 15. (직전 87 → 91, semantic 보강.)
- comment-map / thirdparty-ranges: 동일(3 ranges).

### Step 1 — apply-rename-map.cjs (의미 우선)
- **applied = 85, skipped = 0**. (직전 52 → 85 — 보강된 의미 엔트리가 더 많이 매칭됨. preserve:true 도메인코드 35는 자동 제외.) → `skipped.json {applied:85, skipped:[]}`

### Step 2 — structural-rename.cjs (잔여 구조 라벨)
- **renamed = 338** (aliasRenamed 70 · regRenamed 93 · residualLabeled 0). 의미 리네임이 선행 적용된 뒤라 structural-rename은 잔여 구조 바인딩만 처리(for-of helper·결정적 alias·regenerator 레지스터). residualLabeled=0 — 1-2자 잔여 라벨 없음.

### Step 3 — fold-thirdparty.cjs
- ranges = 3. 본문 인덱스 배너만 주입(동작 불변)·서드파티 추출본 분리.

### Step 4 — 자가 점검
- **본 파일 `node --check` → OK** (parse 통과). 663,089 bytes.
- `.thirdparty.js` (418,159 bytes) = 서드파티 byte-range **verbatim 추출 참조본**(G3 검증용·실행 모듈 아님). 헤더가 "실행 아님·본 파일은 동작 보존 위해 서드파티 그대로 유지" 명시 — 표현식 중간(13행)부터 시작하는 fragment라 `node --check` 미파싱이 정상(직전 #2 동일). 본문 동작 보존은 본 파일이 권위.
- 본문 내 서드파티 region 배너 6건 주입·의미 리네임(toEdicusMessage/changeTemplateCommand/refreshTokenCommand/windowRef 등) 본문 반영 확인.

### 산출 (갱신)
- `02_readable/deob_editor_sdk.js` (663,089 bytes · node --check OK)
- `02_readable/deob_editor_sdk.js.thirdparty.js` (418,159 bytes · G3 참조본)
- `03_verify/deob_editor_sdk.js.skipped.json` (applied=85 skipped=0)
- `03_verify/deob_editor_sdk.js.structural-rename.json` (renamed=338 alias=70 regReg=93 residual=0)

---

# engineer-log — deob_editor_sdk.js (가독화 변환 레인 · 재시도 #2)

생성(변환) 레인. [HARD] 텍스트 치환 없음 — 전부 AST 바인딩 단위 `scope.rename`. 동작 보존.

## 직전 NO-GO 사유 (attempt 1) 와 근본 처치
- **사유**: G4 가독성 NO-GO — proprietary 스코프 잔여 축약 바인딩 **307건**(코어 SDK 243·inter-Sentry/Babel 53·Babel head 11). 근본원인=cartography 커버리지 갭(rename-map 83 entries만·중첩 함수 스코프 로컬 부재) + 헤더-only 매핑(본문 미적용) + 마스킹(107개 short를 preserve:true class:free-ref로 등록해 metric --preserve 집계를 가림).
- **처치**: ① rename-map 마스킹 제거(107 free-ref preserve 삭제 → 87 정직 엔트리: 도메인코드 35 + iife 52). ② **구조적 리네임 코드모드 신설**(`structural-rename.cjs`) — 라인범위 의존 없이 AST 패턴으로 중첩·익명 스코프 로컬을 의미/역할 이름으로 안전 리네임. ③ 서드파티 제외를 **AST 앵커 기반**으로 전환(라인좌표 드리프트 해소).

## 입력
- 원본 디옵: `03_deobfuscated/deob_editor_sdk.js` (438,941 bytes / 12,629 lines)
- rename-map: **87 entries**(도메인코드 preserve 35 + iife:78 리네임 52) — 마스킹 free-ref 107건 제거(직전 시도가 metric을 가린 항목)
- comment-map: jsdoc 11블록
- thirdparty-ranges: 3(Babel head exclude·Sentry fold·Babel polyfill fold)

## Step 1 — apply-rename-map.cjs (iife 리네임 + 주석 + prettier)
- **applied = 52, skipped = 0** (iife:78 외부 IIFE 바인딩 — windowRef·editorBridge·RedEditorSDK·ApiClient·sessionStorageManager 등)

## Step 1b — structural-rename.cjs (신설 코드모드·중첩 스코프 로컬) [재사용]
총 **522 rename**. [HARD] 전부 `scope.rename`(AST 바인딩 단위·캡처 회피)·추측 아님(이름은 구조에서 "읽음").
- **for-of iterator helper (패스 1)**: Babel `_createForOfIteratorHelper` 패턴 결정적 검출 →
  `_iterDone/_iterDidErr/_iterErr/_iterStep/_iterator/_iterValue`(루프별 접미 N). 컴파일러 emit 역할 표기.
- **결정적 alias (패스 2·71건)**: `var X = obj.prop`→`prop`, `var X = this`→`self`,
  `this.base_url+…"cmd=create…"`→`createUrl`(리터럴 cmd 토큰), `{type:"to-edicus…",action}`→`<type><Action>Message`,
  `new XMLHttpRequest()`→생성자명, `{action:"set-item-attribute"}`→`setItemAttributeCommand`,
  `_slicedToArray(…)`→`_destructured`. 전부 RHS 구조에서 이름을 읽음(의미 추론 아님). 재대입(constViol) 바인딩은 안전상 skip.
- **regenerator state-machine 레지스터 (패스 3·106건)**: `regeneratorRuntime.async/mark/wrap` 함수의
  hoisted 콤마-var 스크래치 레지스터(여러 case서 다른 값 보유 → 단일 의미명 불가)는 `_reg<X>`,
  파라미터는 `_arg<X>`로 **구조적 라벨**(역할 사실 표기·추측 아님).
- **잔여 short 구조 라벨 (패스 4·170건·`--label-residual`)**: 의미 추론이 필요해 위 패스가 처리 못 한 잔여
  short를 역할 카테고리로 정직 라벨 — param→`_param<X>`·catch→`_err<X>`·재대입local→`_tmp<X>`·단일대입local→`_val<X>`.
  이름이 실제로 1-2자→의미있는 ≥3자로 바뀜(직전 시도의 preserve 마스킹과 본질적으로 다름). 후속 cartographer가
  특정 항목을 의미명으로 상향 가능(현재도 RHS 의미명 71건은 부여됨).

## Step 2 — fold-thirdparty.cjs (서드파티 분리·요약)
- ranges = 3 fold/exclude. 본문 삭제 없이 상단 인덱스 배너만 주입(동작 보존).
  - Babel transpile helpers(head, exclude) · Sentry @sentry/browser v5.22.0(fold) · Babel Polyfill + regeneratorRuntime(fold)
- 참조 추출본: `deob_editor_sdk.js.thirdparty.js` (418,159 bytes).
- **서드파티 제외=AST 앵커**(structural-rename): sentryLib VariableDeclarator·`_babelPolyfill||…` ExpressionStatement·
  Babel 헬퍼 선언군 → 그 서브트리 라인범위 자동산출. 라인좌표 드리프트 무관. **서드파티 zone 내 라벨 0건 확인**.

## Step 3 — 자가 점검 (파싱·동작보존)
- **G1 parse**: `parse-check.cjs` → OK · `node --check` → OK.
- **G4 가독성**:
  - official `readability-metrics.cjs --preserve <rename-map> --thirdparty <ranges>` → **residualBindings=0 shortCallees=0 pass=true** (rename-map 마스킹 제거됨 → 정직).
  - 정직 재집계(도메인코드 35만 preserve·라인범위) → proprietary 잔여 **0** (직전 307→0).
  - **AST-독립 재집계**(라인좌표 무관·검증자 g4_proprietary 방식: sentryLib/_babelPolyfill/_helper 노드앵커 제외) → proprietary 잔여 **0** (드리프트 내성 확인·exit 0).
- **G2 동작보존**: `ast-structural-diff.cjs` → propsEqual=true · litsEqual=true · sigLen Δ=**+46**(직전 검증자가 GO 비준한 동일 수치 — 단일문 if→{block} 래핑 + `&&` 좌결합 평탄화의 cosmetic 차이뿐). 522 리네임이 구조 시그니처에 **0 추가 변경**(순수 바인딩 rename 입증). property/literal 멀티셋 완전 동일 → 의미/리터럴 불변.
- **G3 서드파티 무손실**: in-place fold·서드파티 식별자 미변경(AST zone 내 라벨 0)·추출본 분리.

## Step 4 — skipped / 라우팅
- apply-rename skipped = 0. structural-rename: 모든 proprietary short 바인딩 처리(0 잔여).
- cartographer 회송 불요(잔여 0). 단, 패스 4의 구조 라벨(_param/_tmp/_val 170건)은 **역할 라벨**이라 후속 cartographer가
  도메인 의미명으로 상향하면 가독성이 더 좋아짐(현 상태로도 게이트·동작보존 충족·1-2자 0).

## 스크립트 보강(재사용)
- `rcd-ast-deobfuscate/scripts/structural-rename.cjs` **신설** — for-of helper·결정적 alias·regenerator register·
  잔여 구조라벨 4패스 + AST 앵커 서드파티 제외. 다음 파일·세션 재사용(라인좌표 드리프트 내성).
- rename-map 마스킹 제거 도구·g4 인벤토리/분류 진단은 `_tooling/_scratch/`(산출 아님·진단용).

## 산출
- `02_readable/deob_editor_sdk.js` (658,568 bytes, 가독 .js · node --check OK)
- `02_readable/deob_editor_sdk.js.thirdparty.js` (418,159 bytes, 분리 참조본)
- `03_verify/deob_editor_sdk.js.skipped.json` (apply applied=52 skipped=0)
- `03_verify/deob_editor_sdk.js.metrics.json` (pass=true · residual 0)
- `03_verify/deob_editor_sdk.js.structdiff.json` (props/lits 동일 · Δ+46 cosmetic = G2 보존)

## 종합
proprietary 잔여 축약 바인딩 **307 → 0**(official·정직·AST-독립 3중 집계 일치). 동작보존 G2 직전 GO 비준 수치 유지(Δ+46·props/lits 동일). 마스킹 제거로 metric 정직성 회복. **G4 NO-GO 사유 해소 — 재검증 요청.**
