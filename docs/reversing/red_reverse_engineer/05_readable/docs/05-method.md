# 05 — 적용 기법 · 동작 보존 증명

> 이 가독 소스가 **어떻게** 만들어졌고(가독화 파이프라인), **동작이 보존됐음을 어떻게 증명했는지**
> (G1~G6 게이트 결과)를 정리한다. 근거 = `_meta/technique-playbook.md`·`03_verify/*.verdict.md`·
> `*.metrics.json`·`*.structdiff.json`·engineer-log·work-units.

---

## 1. 핵심 원칙 ([HARD] 동작 보존)

> **이름은 LLM이 추론하고, 적용은 Babel `scope.rename`이 하며, 동작 보존은 AST 구조 diff가 증명한다.
> 텍스트 치환·프로퍼티명·서드파티는 건드리지 않는다.** (플레이북 §7)

결과 코드는 **실행 가능 동등 코드**여야 한다. 따라서 "LLM이 줄별로 다시 쓰기"는 금지다(그렇게 한 흔적이
바로 deob_07의 입력 절단 파손이었다 — 플레이북 §0). 변경은 **① 식별자 리네임 ② 주석 주입 ③ prettier
포매팅** 세 가지로만 제한된다.

> ★재실측 갱신(attempt 2): deob_07의 입력은 더 이상 합성 HEAD/TAIL recovered.js가 아니라 **비절단
> `03_deobfuscated/deob_07_app_components.full.js`**(186,128 byte·실파싱 OK)다. 그 결과 G2 동작 보존이 합성
> 래퍼 없는 진짜 비절단 원본 대비로 증명됐다(§7). 다만 deob_07은 rename-map 본문 적용이 거의 안 돼 **G4
> 가독화가 미달**(종합 NO-GO) — "동등성 증명"과 "가독화 완료"는 별개 게이트임을 보여준다(아래 §4·§5).

---

## 2. 파이프라인 (4단계, 플레이북 §1)

```
[입력: 축약/디옵 JS]
  ├ (A) Cartography — @babel/parser→AST, traverse로 식별자/스코프/서드파티 경계 수집
  │      → rename-map.json(binding→newName·reason)·comment-map.json·thirdparty-ranges.json
  ├ (B) LLM 의미 추론(이름만) — API 엔드포인트·한국어 라벨·Pinia/Vue 컴포넌트명을 앵커로 newName
  ├ (C) Codemod 적용(AST·scope-safe) — path.scope.rename(old,new) 일괄 → generator → prettier
  └ (D) Verify — G1~G6 동작 보존 증명(생성≠검증 분리)
```

도구(설치본 실측): `@babel/parser`·`traverse`·`generator`·`types` **7.29.7**, `prettier` **2.8.8**(버전
고정 — 포매팅 재현성). recast·@babel/core는 미설치(파이프라인에 불필요·플레이북 §2.6).

**왜 분업인가:** 이름의 *의미*는 LLM이 잘 추론하지만, 이름의 *적용*은 스코프를 무시하면 코드를
파손한다. 그래서 "추론=LLM / 적용=AST"로 가른다(humanify 계열 패턴 차용·플레이북 §3).

---

## 3. 함정 회피 (플레이북 §4 — 실제 적용분)

| 함정 | 회피 (본 산출에 적용된 사실) |
|------|------------------------------|
| F1 텍스트 치환 | 전 파일 텍스트 치환 0 — `scope.rename`만(engineer-log applied 카운트 + verdict G2) |
| F4 프로퍼티명=데이터 계약 | `PDT_CD`·`COD`·`PRICE`·`PCS_CD` 등 API 필드 동결(각 verdict G5 preserve 보존) |
| F8 서드파티 경계 | editor_sdk의 Sentry·Babel polyfill을 fold·exclude로 분리(thirdparty-ranges 3건) |
| F9 prettier 드리프트 | 2.8.8 고정 |
| F2 자유 참조 | minifier 관례 임시명(loop/temp)은 리네임 불가 → free-ref 정직 기록(아래 §6) |

---

## 4. 동작 보존 증명 — G2 AST 구조 diff (핵심)

G2는 "식별자명·주석·공백을 정규화한 뒤 두 AST의 노드 종류·중첩 구조·리터럴·연산자가 완전 일치"를
검사한다. 일치하면 = **리네임/주석/포매팅 외에 아무것도 안 바뀌었다**는 구조적 증명이다.

### G2 결과 (structdiff.json·각 GO)

| 파일 | structSigLen A=B | propsEqual | litsEqual | 판정 |
|------|-------------------|------------|-----------|------|
| `deob_05_app_api.js` | 143,725 = 143,725 | true | true | **GO** |
| `deob_06_app_widget_sdk.js` | 115,781 = 115,781 | true | true | **GO** |
| `deob_07_app_components.js` | 1,051,111 = 1,051,111 | true | true | **GO**(★비절단 `full.js` 기준·재실측) |
| `deob_editor_sdk.js` | 2,440,905 = 2,440,905 | true | true | **GO**(총 Identifier 노드 32,203==32,203 보강) |

구조 시그니처 바이트가 동일 = 노드 추가/삭제/재배열 없음. 프로퍼티명 멀티셋·리터럴 멀티셋(한국어
라벨·경로·상수)도 불변. 라인 수 증가(예 05: 1507→1695)는 **추가 주석 + prettier 포매팅**으로
설명되며 AST 시그니처 불변과 정합(verdict).

> ★**deob_07 재실측(attempt 2):** G2의 `--a`(원본 측)를 합성 recovered.js → **비절단 `full.js`**로 교체.
> `propertyNameDiff=null`·`literalDiff=null`로 완전 일치 — 직전 세션의 "합성 recovered.js 의혹"이 해소됐다.
> 단 deob_07은 G4가 NO-GO라 **종합 NO-GO**(§5)이며, 위 G2 GO는 "동작 보존"만 입증한다.
> editor_sdk는 attempt 2에서 G2 byte 일치에 더해 **총 Identifier 노드 카운트(32,203==32,203)** 독립 재실측으로
> 노드 추가/삭제/재배열 0을 보강 입증했다.

### editor_sdk의 G2 보강 (verdict 인용)

editor_sdk는 보강 전 시그니처 Δ+46(struct=false)였으나, 재귀 하강으로 분기점 4개를 좌표까지 특정해
전부 **prettier의 의미-불변 정규화**로 확정했다(verdict 표):
1. 단일문 `if` consequent를 `{}`로 래핑 2건(dangling-else 바인딩 불변),
2. `A && (B && C)` 잉여 괄호 제거 1건(`&&` 결합법칙·평가순서·결과 동일, 노드 2개로 표시).

이에 `ast-structural-diff.cjs`에 동작-보존 정규화 2종(`unwrapSingleBlock`·`flattenLogical`)을 추가했고,
**적대 검증으로 보수성 입증**: 기검증 파일 회귀 통과, mutant1(`&&`→`||` 연산자 변경)·mutant2(프로퍼티
1개 추가) 둘 다 **적발**(NO-GO). 즉 보강은 동작-보존 포매팅만 동등 취급하고 진짜 동작 변경은 그대로
검출한다 → 최종 G2 = pass(시그니처 동일).

---

## 5. 게이트 종합 (G1~G6 + G4b)

위젯 앞 2파일(05·06)은 G1~G6 전부 GO. editor_sdk는 재실측 attempt 2에서 종합 **GO**. deob_07은 재실측
attempt 2에서 G2(동작 보존)는 **정식 GO**이나 **G4(가독화) NO-GO → 종합 NO-GO**.

| 게이트 | 의미 | 05 | 06 | 07 | editor |
|--------|------|----|----|----|--------|
| G1 구문 유효 | `parse-check.cjs` 파싱 성공(단독 FAIL=NO-GO) | GO | GO | **GO**(가독본·full.js 둘 다) | GO |
| G2 AST 구조 동등 | 동작 보존(§4) | GO | GO | **GO**(비절단 full.js 기준) | GO |
| G3 서드파티 무손실 | 위젯 3파일=N/A(물리분리 0), editor_sdk=in-place fold·토큰 잔존 | GO | GO | GO(N/A) | GO |
| G4 가독성 | 본 로직 스코프 잔여 단문자 0(`residualBindings=0 shortCallees=0`) | GO | GO | **NO-GO**(잔여 1,421·callee 126) | **GO**(18→0) |
| G5 preserve 불변 | 도메인/API 계약 식별자 verbatim 보존 | GO | GO | GO | GO |
| G6 독립성 | 검증자가 engineer-log 비신뢰·스크립트 직접 재실측 | GO | GO | GO | GO |
| **종합** | 단일 FAIL=NO-GO | **GO** | **GO** | **NO-GO**(G4) | **GO** |

### ★ G4b — 의미 완성도 게이트(신설·참고)

G4(잔여 1~2자 길이=0)는 "단축명이 없다"만 본다. 그래서 **이름이 길어졌지만 의미가 아닌 역할 라벨**
(`_argN`·`_iterStep`·`_reg*` 등 babel 트랜스파일 헬퍼 기계명)을 잡지 못한다. 이를 정직하게 드러내려고
재실측에서 **G4b(역할-범주 기계명 수 `g4b_mechanicalRoleNames`·`fullySemantic`)**를 metrics에 추가했다.

| 파일 | G4 잔여 | G4b mechanical | fullySemantic | 해석 |
|------|---------|-----------------|----------------|------|
| `deob_07` | 1,421 | 0(distinct 0) | true | ★**공허한 0** — 리네임 자체가 거의 미적용이라 "기계명조차 안 생김". 가독화 미달 신호 |
| `deob_editor_sdk` | 0 | 268(distinct 160) | false | 핵심 10 메서드 의미화로 베이스라인 **450→268(≈40%↓)**. 잔존은 거의 전부 regenerator/iterator 헬퍼(비핵심) |

즉 G4b=0이 항상 좋은 게 아니다(07의 0은 미적용). editor는 G4=0이면서 G4b가 잔존 268로 "의미화는 부분"
임을 정직하게 보여준다. **핵심 공개 SDK 메서드(createProject 등)는 의미화 완료, 나머지 비핵심 헬퍼·메서드는
미심화**(04-editor-sdk §4.1·§10).

**생성≠검증:** engineer(생성)와 verifier(검증)는 분리됐고, verifier는 engineer-log를 근거로 쓰지 않고
모든 스크립트를 절대경로·`RCD_NM` prefix로 직접 재실행해 판정했다(각 verdict G6). 재현 명령은 각 verdict
하단에 기록.

---

## 6. free-ref 한계 (명시 — 미상 정직 기록)

일부 식별자는 **리네임이 불가능**해 원형 그대로 남았다. 이는 결함이 아니라 정직한 한계 기록이다.

| 종류 | 사례 | 왜 리네임 불가 |
|------|------|-----------------|
| Vue 3 런타임 헬퍼 | `createVNode`·`computed`·`ref`·`defineComponent` 등 | 모듈 밖 전역/번들 자유참조 — 로컬 바인딩 아님(F2). 이미 풀네임 |
| minifier 관례 임시명 | editor_sdk의 `n`·`o`·`r`·`Q`·`Z` 등 | 중첩 익명 스코프마다 별개의 loop-index/temp/param. 의미명 부여 시 추측이 됨 |
| regenerator scratch register | `_reg<X>`·`_arg<X>` 라벨 | 한 변수가 여러 case에서 다른 값 보유 → 단일 의미명 불가. **역할 라벨**로만 표기 |
| 서드파티 내부 식별자 | Sentry `At/Bt/Dt`·polyfill 내부 | F8 동결 대상(리네임 제외) |

editor_sdk에서 재실측 attempt 2 기준 G4 잔여 단축명은 **0**이지만, G4b mechanicalRoleNames **268**(distinct
160)이 남는다 — 거의 전부 babel regenerator/iterator 헬퍼 지역명(`_iter*`·`_reg*`·`_arg*`)으로, 한 변수가
여러 case에서 다른 값을 갖는 scratch register라 단일 의미명 부여가 추측이 된다. 그래서 역할 라벨로만 **정직
라벨**됐고(`fullySemantic=false`), 핵심 10 공개 메서드(createProject 등)만 의미화 완료다. verdict는 "후속
cartographer가 비-헬퍼 proprietary `_arg*`/`_val*`을 의미명화 가능, regenerator/iterator 헬퍼는 트랜스파일
산출물이라 의미명화 가치 낮음"으로 라우팅. 추측 리네임은 금지됐다(work-units free-ref-check).

> 다운스트림 주의: 위 free-ref 식별자의 이름은 "역할"이지 "확정 의미"가 아니다. 의미를 단정하지 말 것.

---

## 7. ★ deob_07 — 합성 복원 폐기 · 비절단 full.js 재추출 (verdict 인용)

**직전 서술 정정.** 이전 버전은 `deob_07`의 입력 raw 번들이 첫 코드행(line 105) orphan `}),`로 파싱 불가라,
cartographer가 합성 HEAD/TAIL(`SYNTHETIC TRUNCATION-RECOVERY WRAPPER`)로 복원한 `*.recovered.js`를 입력으로
쓰고 G2도 그 recovered.js 기준이라고 적었다. 가독본 선두 `__recoveredApparelPrintAreaSetup` 블록은 "원본 아닌
절단 복원 scaffold"라고 명시했었다.

**재실측 attempt 2(사용자 directive):** G2의 `--a`를 합성 recovered.js가 아니라 **비절단
`03_deobfuscated/deob_07_app_components.full.js`**(186,128 byte·`parse-check.cjs` → `OK` exit 0=실제 파싱가능)로
교체했다. 결과:
- 가독본 ↔ 비절단 full.js가 AST 구조·프로퍼티명 멀티셋·리터럴 멀티셋 **완전 일치**
  (`structSigLenA==structSigLenB=1,051,111`·`propertyNameDiff=null`·`literalDiff=null`).
- 즉 합성 scaffold 없이 **진짜 비절단 원본 대비** 동작 보존이 증명됐다 — 직전 세션의 "합성 recovered.js 의혹"은
  **해소**됐다. 이제 G2(동작 보존)는 합성 래퍼 제거·비절단 full.js 기준 **정식 GO**다.

**남은 한계(정직):**
- deob_07은 **G4 가독화가 미달**(rename-map 469 매핑이 본문에 거의 미적용 — 잔여 1~2자 1,421·callee 126).
  종합 NO-GO이며, engineer가 rename-map을 본문 재적용 후 G4 재실행이 필요하다(verdict routing).
- 후가공/수량 후반 컴포넌트군(COT_DFT~WRK_MTR·각종 Qty)의 **현재 가독본 내 정확한 좌표는 미확인(미상)** —
  comment-map은 합성 recovered 시절 기준이었다(03-app-components §4). 정확한 위치는 full.js/가독본에서 직접
  grep 확인 권장.

---

## 8. 한 줄 요지

- 위젯 앞 2파일(05·06) + editor_sdk = **종합 GO**. deob_07 = G2(동작 보존) **정식 GO**(비절단 full.js 기준)이나
  **G4(가독화) NO-GO → 종합 NO-GO**.
- 변경은 리네임 + 주석 + prettier뿐. 텍스트 치환·프로퍼티명·서드파티는 불변 — 모든 파일 G2 동작 보존 입증.
- ★재실측 변화: deob_07 G2를 **합성 recovered.js → 비절단 full.js**로 교체(의혹 해소)·**G4b 의미 완성도 게이트
  신설**·editor_sdk 핵심 메서드 의미화(G4b 450→268)·G4 잔여 18→0.
- free-ref(리네임 불가)·deob_07 가독화 미달·editor 의미화 부분(fullySemantic=false)은 **한계로 명시** —
  미상은 단정하지 않는다.
