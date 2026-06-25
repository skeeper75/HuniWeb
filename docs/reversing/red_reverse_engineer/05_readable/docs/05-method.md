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
| `deob_07_app_components.js` | 427,581 = 427,581 | true | true | **GO**(recovered.js 기준) |
| `deob_editor_sdk.js` | 2,440,905 = 2,440,905 | true | true | **GO** |

구조 시그니처 바이트가 동일 = 노드 추가/삭제/재배열 없음. 프로퍼티명 멀티셋·리터럴 멀티셋(한국어
라벨·경로·상수)도 불변. 라인 수 증가(예 05: 1507→1695)는 **추가 주석 + prettier 포매팅**으로
설명되며 AST 시그니처 불변과 정합(verdict).

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

## 5. 게이트 종합 (G1~G6, 4파일 전부 GO)

| 게이트 | 의미 | 결과 |
|--------|------|------|
| G1 구문 유효 | `parse-check.cjs` 파싱 성공(단독 FAIL=NO-GO) | 4/4 GO |
| G2 AST 구조 동등 | 동작 보존(§4) | 4/4 GO |
| G3 서드파티 무손실 | 위젯 3파일=N/A(서드파티 없음), editor_sdk=in-place fold·토큰 잔존(`captureException` 7/7) | 4/4 GO |
| G4 가독성 | 본 로직 스코프 잔여 단문자 식별자 0(`residualBindings=0 shortCallees=0`) | 4/4 GO |
| G5 preserve 불변 | 도메인/API 계약 식별자 verbatim 보존(워드바운더리 대조) | 4/4 GO |
| G6 독립성 | 검증자가 engineer-log 비신뢰·스크립트 직접 재실측 | 4/4 GO |

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

editor_sdk에서 잔여 short 170건은 역할 카테고리(`_param`/`_err`/`_tmp`/`_val`)로 **정직 라벨**됐다(1~2자
→ 의미있는 ≥3자). engineer-log·verdict 모두 "후속 cartographer가 도메인 의미명으로 상향 가능"으로
기록 — 즉 현재 이름이 **확정 의미가 아닌 역할 표기**임을 명시한다. 추측 리네임은 금지됐다(work-units
free-ref-check: "추측 리네임 금지").

> 다운스트림 주의: 위 free-ref 식별자의 이름은 "역할"이지 "확정 의미"가 아니다. 의미를 단정하지 말 것.

---

## 7. deob_07 절단 복원의 정당성 (verdict 인용)

`deob_07`의 입력 raw 번들은 첫 코드행(line 105)이 orphan `}),`로 시작해 **파싱 불가**(브래킷 불균형).
cartographer가 선두/말미를 합성 HEAD/TAIL(`SYNTHETIC TRUNCATION-RECOVERY WRAPPER`)로 복원한
`*.recovered.js`를 입력으로 썼다. verifier가 직접 확인한 정당성:
- 원본 본문(line 105~)이 recovered.js 안에 **verbatim 존재**(anchor `directPrintAreaNames = computed(...)` 4000자 윈도우 일치).
- 합성 scaffold가 recovered.js↔가독본 양쪽에 동일하게 존재 → **rename/comment/format만이 유일한 delta**로 격리 → 복원 가능 본문의 동작 보존 증명.
- raw 원본을 기준으로 쓰면 파싱 불가 + scaffold 부재로 거짓 불일치 → recovered.js 기준이 정당.

**한계:** 가독본 선두 `__recoveredApparelPrintAreaSetup` 블록은 원본 코드가 아니다. 절단 경계 이후
컴포넌트(COT_DFT~WRK_MTR·각종 Qty)는 본 단편에 미포함이며, 완전 확보엔 full-bundle 재추출이 필요하다
(verdict routing).

---

## 8. 한 줄 요지

- 4파일 전부 **G1~G6 GO** — 동작 보존(G2 시그니처 동일)·가독화(G4 잔여 0)·계약 보존(G5 위반 0) 입증.
- 변경은 리네임 + 주석 + prettier뿐. 텍스트 치환·프로퍼티명·서드파티는 불변.
- free-ref(리네임 불가)·deob_07 절단 복원은 **한계로 명시** — 미상은 단정하지 않는다.
