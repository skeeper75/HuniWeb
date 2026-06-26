# deob_07(full.js) → 타 언어 포팅·별도 이용을 위한 의미부여 실현가능성·방법론

> 대상: `03_deobfuscated/deob_07_app_components.full.js` (5,580줄 / 186KB, RedPrinting 위젯 **앱 컴포넌트 슬라이스** — Vue 3 SFC 38컴포넌트 컴파일 번들)
> 목적: minified 식별자에 의미를 부여해 **다른 언어로 포팅하거나 별도 이용**할 수 있게 만드는 것의 방법론적 실현가능성·한계 타진.
> 권위: 실측 우선(grep/AST 스크립트). 추정은 "추정"으로 명시. 작성 시점 라이브 미접속 불요(읽기전용 분석).

---

## 0. 한 줄 결론

**포팅용 "의미 전달" 실현가능성 = 중(中).** setup 로직(상태·computed·이벤트·도메인 계약)은 의미부여로 포팅 충분 수준까지 복원 가능하나, **파일의 ~21% 토큰을 차지하는 Vue 컴파일 render 함수는 원소스(template)가 아닌 생성물이라 의미명을 줘도 "복원"이 아니며 포팅 시 재작성이 정답**. 핵심 한계 두 가지: ① 컴파일 render = 비가역(template 미복원) ② 변수명만으로는 부족 — 타입/시그니처/외부 의존(Vue 런타임·청크 Module·API 계약)이 함께 가야 포팅이 성립.

---

## 1. 실측 베이스라인 (이 판단의 자[尺])

`@babel/parser`+`traverse`로 full.js와 그 복원본(recovered.js)을 직접 AST 측정한 수치:

| 지표 | full.js (절단·errorRecovery 파싱) | recovered.js (브래킷 복원·리네임 완료본) |
|---|---:|---:|
| 총 라인 | 5,580 | 2,636 |
| Identifier 노드 총수(키 포함) | **13,543** | — |
| 고유 Identifier 이름(키 포함) | **874** | — |
| 선언∪참조 고유 식별자 | **418** (선언 319 + 참조 386) | 선언 371 / 참조 498 |
| 1글자 선언 식별자 | 33 | **0** |
| 1~2글자(minified-like) 선언 | **319 (전부)** | **0** |
| **Vue render 헬퍼 호출 (`g/V/M/S/j/T/K` 등)** | **1,267회** | **0** (모두 풀네임화: openBlock/createElementVNode…) |
| hoisted static 캐시 패턴 `n[i]\|\|(n[i]=…)` | 118 | 52 |
| `defineComponent __name` (= 컴포넌트 수) | 58 | 20 |
| setup() 함수 | 58 | 20 |

부가 실측:
- **render 헬퍼 호출 1,267회**는 참조 occurrence 6,065회의 **약 21%**. 즉 본문 식별자 등장의 1/5이 "원 소스가 아닌 컴파일 산출물"이다(임무 3의 정량 근거).
- rename-map(`01_cartography/deob_07_full/rename-map.json`) = **468 키**, 전부 confidence=1. source 분포 = **stats 90 / inferred 235 / free-ref 143**. preserve(불변) **399 / 실제 리네임(to≠key) 69**.
- 전 모듈 rename-map 키 합 = **800** (05=37, 06=32, 07=172, 07_full=468, editor_sdk=91). 임무가 명시한 "1421 식별자"는 단일 산출물 키 합과 정확히 일치하지 않음 → **본 문서는 실측치(full.js 고유 식별자 874 / 선언∪참조 418 / rename-map 468)로 보정**하되, 규모감은 "수백~천 단위 식별자"로 동일하게 성립.

> 모든 수치 재현: `RCD_NM=<…>/_tooling/node_modules node <측정스크립트> <파일>` (절대경로, 읽기전용). 측정 스크립트는 `_probe.cjs` 패턴 동일.

---

## 2. 포팅에 필요한 것의 본질 — "변수명만 의미화" ≠ 포팅 충분

**[판정] 변수명 의미화는 필요조건이지 충분조건이 아니다.** 실측 근거로 (a)~(d)가 함께 가야 "의미 전달"이 성립한다.

### (a) 타입/시그니처 — 필수
JS는 동적 타입이라 minified 본문에 타입 정보가 없다. recovered.js 실측 샘플:
```
setup(props, { emit }) { … }
totalQuantity = computed(() => Object.values(sizeQuantities).reduce((s, q) => s + q, 0))
quickOrderDisabledNames = computed(() => componentProps.options.filter(o => o.QUICK_ORD_YN === "N")…)
```
포팅 대상 언어(예: TS/Kotlin/Swift)에서 `props.options`가 `Array<{COD, COD_NME, QUICK_ORD_YN}>`임은 **이름만으론 안 나오고 사용처에서 역추론**해야 한다. → 의미부여 산출물에 **추론 타입/시그니처(JSDoc @param/@returns 또는 .d.ts)**가 동반돼야 포팅 가능.

### (b) 동작 의도 주석 — 필수
도메인 규칙이 코드에 매직값으로 박혀 있다. 예: `o.COD === "CL011" || … && restrictedAreaNames.push(…)`(특정 인쇄영역 코드만 제한). 이름만으론 "왜 그 코드인지" 전달 안 됨. 본 하네스는 이미 **comment-map.json(JSDoc/section-banner)**로 이걸 채우고 있음 — 포팅에 그 의도 주석이 변수명보다 더 결정적.

### (c) 데이터 구조 — 필수
도메인 계약 객체의 shape가 곧 포팅 대상의 DTO/모델이 된다. 실측: rename-map의 **source="stats" 90개가 도메인/API 계약 코드**로 `preserve:true`(리네임 절대 금지) — `PDT_CD MTRL_CD PRN_CNT CUT_WDT CUT_HGH WRK_WDT WRK_HGH PRICE PRICE_MALL COD COD_NME DIV_SEQ ESN_YN VIEW_YN PTT_CD CLR_CD MTRL_TYPE …`. 이들은 **서버 API 필드명이라 포팅해도 그대로 유지**돼야 한다(이름을 "개선"하면 계약 파손). → 의미부여의 핵심 산출은 "이 식별자는 외부 계약이라 건들면 안 됨"의 **경계 표시**이기도 하다.

### (d) 외부 의존 — 필수
full.js는 자기완결이 아니다. 실측 free-ref(선언 없는 참조 = 외부 의존) **143개** 중:
- **Vue 런타임 헬퍼**: render 헬퍼 22종(g=openBlock, M=createElementVNode, j=toDisplayString …) — 다른 언어엔 등가물 없음 → 포팅 시 그 언어의 UI 프레임워크로 **치환/재작성**.
- **다른 번들 청크(Module)** 10개: `PaperModule BookModule AccModule BON_PAP_Module CLD_STD_Module BID_SIL_Module ADC_PVC_Module BIND_DIRECTION_Module BON_SHT_Module BookQtyModule` — 이 파일 밖(다른 deob 산출/번들)에 정의. 포팅하려면 그 청크까지 같이 와야 함.
- **자식 컴포넌트** 다수(`OptionRow IconCheckbox RadioGroup BasicSelect ColorChipSelector SizeSelector Skeleton FileUpload …`) — 컴포넌트 트리 의존.
- **내장 전역**: Boolean/Map/Math/Object/Symbol/Fragment.

**"의미 전달"의 실질 기준(포팅 성립 정의):** 한 setup 함수를 읽고, 외부 도움 없이 ① 입력(props/주입)과 그 타입 ② 출력(emit 이벤트·반환 render 트리) ③ 내부 상태와 도메인 규칙(매직값의 의미) ④ 외부 의존(어느 청크/컴포넌트/런타임을 부르는지)을 알아 **다른 언어의 동등 컴포넌트로 옮길 수 있으면** 의미 전달 성공. 변수명은 이 중 ①③의 가독성만 올린다.

---

## 3. 스케일 도구 — 수백~천 식별자에 의미명을 붙이는 현실 파이프라인

### 3.1 분업 원칙(업계 합의): "이름은 LLM, 적용은 AST"
최신 OSS 합의는 일관됨 — **LLM은 후보 이름만 제안하고, 실제 리네임은 AST 코드모드가 스코프 안전하게(scope.rename) 결정론적으로 적용**해 참조·렉시컬 스코프를 보존한다. (humanify: LLM 제안 → oxc AST가 구조 동일하게 적용·예약어/충돌 회피 정규화; webcrack/wakaru: 스코프 안전 리네임 + 번들/트랜스파일 아티팩트 제거). 텍스트 치환은 금지(스코프 무시 → 동명이인 변수 파손).

### 3.2 본 하네스에 맞는 현실 파이프라인
1. **추출**: AST로 선언 식별자 인벤토리 + 사용처 컨텍스트 수집(이미 `_probe.cjs`/rename-map 패턴 보유).
2. **분류(소스 태깅)**: 실측대로 3계열로 나눠 처리(rename-map source가 이미 이 구조):
   - `stats`(90) = 도메인/API 계약 → **preserve**(리네임 금지, 의미 주석만).
   - `inferred`(235) = 본 로직 로컬 → **LLM 의미명 후보 + AST 적용** 대상(가성비 최고 구간).
   - `free-ref`(143) = 외부 의존 → 리네임 대상 아님, **의존 카탈로그**로 분리 기록.
3. **v1 정렬 전이(transfer)**: 이미 의미명을 붙인 산출(deob_07_app_components.js 172키·editor_sdk 91키)에서 **동일 패턴 식별자명을 신규 슬라이스로 전이**(예: 같은 setup shape → 같은 명명) → LLM 호출 절감.
4. **배치 LLM 명명**: 남은 inferred만 함수 단위 배치로 이름 제안(humanify류). 컨텍스트는 "함수 본문 + 호출처 + 인접 도메인 코드".
5. **AST 적용 + 검증**: `traverse`로 `binding.scope.rename(old,new)` 일괄 → **AST 구조 diff(structdiff.json)로 리네임/주석/포매팅만 변경됐음 증명** + 구문 유효 + (선택) 런타임 스모크. 본 하네스 verifier가 이미 structdiff/metrics/verdict 게이트 운영 중.

### 3.3 자동화 한계(실측 기반)
- **자유참조(free-ref 143)**: 이 파일에 선언이 없어 `scope.rename`이 손댈 수 없음. 안전한 리네임은 **선언 지점이 있는 청크에서만** 가능 → 슬라이스 단독으론 외부 의존 이름 통일 불가.
- **컴파일 render(헬퍼 1,267콜)**: 아래 §4. 리네임은 가능하나 **의미 회복 효과가 거의 없음**(임시 VNode·magic flag 숫자).
- **제네릭 임시변수**: render 트리·reduce 콜백의 `s,q,o,t,n` 등은 의미를 부여해도 한 줄 쓰임이라 ROI 낮음(33개 1글자 선언 다수가 여기 해당).
- **errorRecovery 의존**: full.js는 번들 슬라이스라 line 105가 orphan `}),`로 시작(브래킷 불균형, comment-map에 기록됨). 정식 파싱 불가 → engineer는 합성 HEAD/TAIL로 균형 맞춘 **recovered.js**를 입력으로 써야 함(실측: recovered.js는 minified-like 0·render헬퍼 0으로 깨끗하게 파싱·리네임됨). **절단된 원본 직접 리네임은 비권장**.

---

## 4. 컴파일 코드 리스크 — render 함수·번들 헬퍼는 "원 소스"가 아니다 (정직한 경계)

full.js head 실측이 곧 증거:
```js
setup(e) {
  return (g(), M("div", CS, [ n[0] || (n[0] = S("p", null, "주문 위젯을 생성할 수 없습니다 😱", -1)),
    t.message ? (g(), M("p", TS, j(t.message), 1)) : oe("", !0) ]))
}
```
- `g()/M()/S()/j()/oe()` = `openBlock/createElementVNode/createElement/toDisplayString/createCommentVNode`의 minified 별칭(stats.vueRenderFunctionMapping 권위). 이건 **개발자가 쓴 코드가 아니라 `<template>`을 Vue 컴파일러가 변환한 산출물**이다.
- 끝의 `-1, 1, 8, 128, 512` 같은 숫자 = **PatchFlag/SlotFlag 비트마스크**(런타임 최적화 힌트), `n[0]||(n[0]=…)` = **hoisted static VNode 캐시**(실측 118회). 둘 다 컴파일러 생성물.
- **[HARD 한계] template → render는 단방향(비가역).** render 함수에 의미명을 붙여도 원 `<template>` SFC가 복원되는 게 아니다. Vue는 "컴파일된 template **또는** render 함수"만 있으면 렌더하며(원소스 없이도 동작), **render에서 template을 되돌리는 공식 경로는 없다**(소스맵이 있을 때만 식별자 일부 회복 — 본 번들엔 없음).

**[포팅 권고]** render/번들 헬퍼 영역은 **의미명 부여 대상이 아니라 "재작성(re-author) 대상"**이다. 포팅 시:
- render 트리는 무시하고 **setup의 상태·computed·watch·도메인 규칙만 의미 모델로 추출** → 대상 언어/프레임워크의 뷰 레이어로 **새로 작성**.
- render는 "이 컴포넌트가 어떤 DOM/자식컴포넌트/디렉티브를 그리는지"의 **명세 입력**으로만 읽음(역설계 자료), 코드로 옮기지 않음.
- 이게 humanify/webcrack 류가 "resemble original source as much as possible"이라 말하면서도 **컴파일 산출물 완전복원을 보장하지 않는** 이유와 동일.

---

## 5. 권고 접근 — 순서·수준·가성비

### 5.1 가치 우선순위(ROI 순)
1. **[High] setup 로직 의미화 + 타입/의도 주석 (inferred 235 + 도메인 주석)**
   - 가장 비용 대비 실효적. 상태·computed·이벤트·도메인 규칙이 포팅의 본체.
   - 산출: 의미 변수명(AST 적용) + JSDoc 시그니처 + 매직값 의미 주석(comment-map 확장).
2. **[High] 도메인/API 계약 카탈로그 (stats 90, preserve)**
   - 리네임 금지·그대로 보존하되 "이 필드의 의미/타입/서버계약" 사전화 → 포팅 대상 DTO/모델로 직결. 이미 가장 신뢰도 높은 구간(confidence 1, 본문 존재 확인됨).
3. **[Medium] 외부 의존 카탈로그 (free-ref 143: Module 10 + 컴포넌트 + Vue 런타임 22)**
   - 리네임 대상 아님. "포팅하려면 어느 청크/컴포넌트가 더 와야 하는가"의 **의존 그래프**로 산출 → 포팅 범위 산정에 필수.
4. **[Low] render 트리 식별자 (헬퍼 1,267콜·hoist 118·1글자 임시변수 다수)**
   - 의미부여 ROI 최저. **명세로만 읽고 재작성** — 변수명 붙이는 데 LLM 토큰 쓰지 말 것.

### 5.2 수준 권고: "전 식별자"가 아니라 "setup 우선"
- **전 식별자 일괄 명명은 비권장**(렌더 영역 1/5이 가치 없음 + free-ref는 안전 리네임 불가). 
- **setup 스코프 한정 명명**이 정답: 본 하네스 게이트의 "본 로직 스코프 잔여 단문자 식별자 0"을 **setup 스코프에만 적용**, render 콜백 임시변수는 면제.

### 5.3 불가/저효율 영역(정직한 경계)
- **불가(보장 못 함)**: render → 원 `<template>` 복원, 번들 청크 경계 밖 free-ref 통일, magic flag/hoist의 "의미" 회복.
- **저효율**: render 트리·일회용 콜백 변수 명명, 절단 원본(full.js) 직접 변환(반드시 recovered.js 경유).

### 5.4 포팅 절차 요약(권고 순서)
1. recovered.js(브래킷 복원본) 입력 확정 → 2. source 3분류(preserve/inferred/free-ref) → 3. v1 명명 전이 → 4. inferred만 LLM 명명 + AST 적용 → 5. structdiff 동등성 게이트 → 6. setup별 **컴포넌트 명세서**(props 타입·emit·상태·computed·도메인 규칙·의존) 작성 → 7. 명세서를 대상 언어로 포팅(render는 그 언어 뷰로 재작성).

---

## 6. 도구·근거(출처)

- **humanify (jehna)** — LLM이 이름 제안, oxc AST가 스코프 안전 적용·예약어/충돌 정규화. 2025 provider 확장(Anthropic/Ollama/OpenRouter). https://github.com/jehna/humanify · https://www.npmjs.com/package/@hikae/humanify
- **webcrack (j4k0xb)** — obfuscator.io 해제·unminify·webpack/browserify 언팩, 스코프/참조 안전, "resemble original source as much as possible"(완전복원 비보장 함의). https://github.com/j4k0xb/webcrack · https://webcrack.netlify.app/docs/concepts/deobfuscate.html
- **wakaru (pionxzh)** — 모던 프론트엔드 디컴파일러, webpack4/5·esbuild·Bun 번들 스플릿 + Terser/Babel/SWC/TS minifier recovery, 3단 rewrite(minimal/standard/aggressive), 소스맵 식별자 회복. https://github.com/pionxzh/wakaru
- **LLM 리버스 명명 방법론** — thejunkland: "Using LLMs to reverse JavaScript variable name minification". https://thejunkland.com/blog/using-llms-to-reverse-javascript-minification.html
- **본 하네스 권위** — 동작 보존(실행 가능 동등)이 [HARD]: `_meta/technique-playbook.md`, `_meta/toolset.json`(@babel/core·parser·traverse·generator·recast·prettier).
- **Vue render 비가역성** — Vue는 컴파일된 template **또는** render 함수만으로 렌더(원소스 불요); render→template 공식 역복원 경로 없음. https://docs.w3cub.com/vue~3/guide/render-function (※ "render에서 template 복원 불가"는 직접 명문 출처 미확보 — 컴파일 단방향성에 기반한 도메인 판단으로 명시).

### 보장/한계 명시
- **보장**: setup 로직·도메인 계약의 의미부여로 포팅 충분 수준 도달 가능(타입/의도 주석 동반 시). AST scope.rename은 참조 무손실.
- **비보장**: render/번들 헬퍼의 원소스 복원, 슬라이스 단독 free-ref 리네임, magic flag 의미 회복. 이 영역은 "재작성"이 정답.

---

## 7. 재현 메모

- 측정: `RCD_NM=<…>/05_readable/_tooling/node_modules` 환경에서 `@babel/parser`+`traverse`로 선언/참조/render헬퍼/hoist 패턴 카운트(절대경로, errorRecovery=true, 읽기전용).
- 입력 권위: full.js(절단·5,580줄), recovered.js(브래킷 복원·2,636줄), `01_cartography/deob_07_full/{rename-map,comment-map}.json`, `03_deobfuscated/deob_07_stats.json`(vueRenderFunctionMapping·identifierRenameStats 권위).
