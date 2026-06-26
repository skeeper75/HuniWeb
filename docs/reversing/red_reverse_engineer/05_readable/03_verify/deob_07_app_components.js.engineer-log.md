# deob_07_app_components.js — engineer-log (재시도 #2)

생성: 2026-06-26 · rcd-readability-engineer (생성 레인) · AST scope.rename only · 동작 보존

## 1. 입출력
- 입력(클린 full, 합성 래퍼 없음): `03_deobfuscated/deob_07_app_components.full.js` (5,580행 / 186,128B)
- 맵: `01_cartography/deob_07_full/rename-map.json` (468 keys) · `comment-map.json` (26) · `thirdparty-ranges.json` (빈 `[]` → fold 불필요)
- 산출: `05_readable/02_readable/deob_07_app_components.js` (9,911행 / 344,243B)
- 도구: `_tooling/node_modules` (@babel·recast·prettier 설치 확인)

## 2. apply-rename-map 실행 결과
```
[apply-rename-map] applied=69 skipped=0 comments=13/26
```
- **applied=69 / skipped=0** — rename-map의 비-preserve 엔트리 전수(69개)가 빠짐없이 적용됨. 거짓 skip 0.
- **node --check: PASS** (PARSE OK).
- **comments=13/26** — 미해결 13건은 전부 `__name`/식별자 anchor 매칭 실패(아래 §4-3).

## 3. 동작 보존 인증 (structural parity)
입력↔출력 AST 통계 완전 일치 — 리네임/주석/포매팅만, 시맨틱 불변:

| 지표 | 입력(클린 full) | 출력(가독) | 일치 |
|---|---|---|---|
| top-level stmts | 3 | 3 | ✓ |
| 총 node | 33,476 | 33,476 | ✓ |
| CallExpression | 2,515 | 2,515 | ✓ |
| Function | 897 | 897 | ✓ |
| StringLiteral | 2,246 | 2,246 | ✓ |

→ 텍스트 치환 0 · scope.rename(바인딩 단위)만 · 문자열 리터럴/프로퍼티/연산자 불변.

## 4. ★ G4 가독성 NO-GO 근본원인 = rename-map(cartographer) 미완 — 엔지니어/스크립트 결함 아님

재실행해도 직전과 동일(applied=69)인 이유를 AST로 규명:

### 4-1. rename-map 구성 (468 keys)
- `preserve:true` 399 (PDT_CD·MTRL_CD·PRICE·COD 등 도메인/API 계약 — 리네임 금지·정상)
- 비-preserve 69 = **전부 `scope:"module"`** · **전부 적용 완료**
  - 내용: Vue 런타임 helper(openBlock·createVNode·withCtx…) + 모듈 톱레벨 컴포넌트/컴포저블 바인딩(SizeSelector·useOrderStore·CDN_BASE_URL…). 번들이 모듈 최상위에서 구조분해 할당하므로 진짜 module 바인딩 → 69/69 적용.
- **non-module(function:/class:/iife:) 엔트리 = 0 · 배열(다중 스코프) 엔트리 = 0**

### 4-2. 잔여 단문자 = 맵에 없음(적용할 대상 자체가 부재)
출력 재실측(readability 스캔):
- **distinct short binding names = 166** (n·i·t·a·f·u·p·s·c·l·d·r·m·h·v…), occurrence ≈ 4,193
- **shortCalleeOccurrences ≈ 157** (top `o()`=65, `t()`=30 …)

이 166개는 **컴포넌트 setup/헬퍼 함수 내부의 파라미터·로컬 바인딩**이다. rename-map에 **키로 존재하지 않는다**(매핑 대상 부재). 엔지니어는:
- 맵에 없는 식별자를 리네임할 수 없음(적용할 엔트리가 없음).
- 이름 추론(신규 의미 리네임)은 cartographer의 의미 판단 영역 — [HARD] "추측 리네임 금지". 엔지니어가 임의 생성 불가.

verifier가 인용한 의미 타깃(ApparelColorSelector·accCounterClass·bookQtyFlexRowClass 등 ~77)은 맵에 `.to` 값으로는 존재하나(418 distinct .to), 그에 대응하는 **orig 단문자 키 + 정확한 function:/class:/iife: scope 엔트리가 비어 있어** 본문에 반영될 수 없다. ★맵이 module 스코프 69개만 채워져 있고 함수/클래스 로컬 스코프 리네임이 통째로 누락된 것이 G4 NO-GO의 단일 근본원인이다.

### 4-3. 미해결 주석 13건도 cartographer anchor 오류
unresolved 13(CheckmarkIcon·PAK_POL_SimpleModule·ApparelModule·BookQtyModule·PaperModule·BookModule·AccModule·ADC_PVC_Module·BID_SIL_Module·BIND_DIRECTION_Module·BON_PAP_Module·BON_SHT_Module·CLD_STD_Module): 소스에 **식별자로도 `__name` 문자열로도 존재하지 않음**(literalInSrc=false, origAs__name=false). 실재하지 않는 컴포넌트명을 anchor로 지정 → 주석 주입 로직은 정상이나 부착 대상 AST 노드가 없다. comment-injection 스크립트 결함 아님.

## 5. 스크립트 보강 검토 결과 — 보강 불요
apply-rename-map.cjs는 module/function:/class:/iife:/free-ref 5종 스코프를 이미 처리한다. 맵에 function:/class:/iife: 엔트리가 0건이라 "스크립트가 못 잡는 엣지케이스"가 존재하지 않는다. 스크립트를 고쳐도 적용할 데이터가 없으므로 결과 불변. (게이트 통과 목적의 결과 파일 손편집·임의 리네임은 [HARD] 금지 — 하지 않음.)

## 6. 재실행 경로 (루프 라우팅)
G4 GO를 위해 필요한 것은 **cartographer의 rename-map 보강**:
1. 166 단문자 로컬 바인딩에 대해 **function:/class:/iife: scope를 정확히 지정한** rename 엔트리 추가(동명이 여러 스코프면 배열 다중 엔트리 — 스크립트 `entriesFor` 이미 지원).
2. 잔여 short callee(`o`·`t`…)도 동일.
3. comment-map의 실재하지 않는 13 anchor를 실제 소스 식별자/`__name`/`line:N`으로 정정.
보강 후 본 apply 명령 재실행 시 동일 스크립트로 결정적 반영됨.
