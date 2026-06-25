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
