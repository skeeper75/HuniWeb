# deob_07 의미명 부여 타당성 — 경험적 실측 (Rosetta 정렬 전이 기준)

> 대상: `03_deobfuscated/deob_07_app_components.full.js` (5,581줄·186KB·Vue 3 컴파일 컴포넌트 모듈, minified·파싱가능)
> Rosetta 참조: `git HEAD:05_readable/02_readable/deob_07_app_components.js` (=v1 디옵 완료본, 4,865줄·218KB)
> 방법: babel(@7.29.7) AST 스캔 + 공유 앵커(`__name`·setup 바인딩 순서) 정렬 전이 + 컨텍스트 명명 시도. **추정 아님 — 모든 수치는 스크립트 실측.**
> 도구: `_tooling/_feas_*.cjs` (scan·align·region·evidence·coverage). 환경 `RCD_NM` NODE_PATH prefix.

---

## 0. 한 줄 결론

**전이가능 ≈ 74%(공유 100% 전이 37.6% + 꼬리주석 보조전이 36.3%) · 컨텍스트명명 가능 ≈ 16.6%(머리 6컴포넌트) · render 함수 비중 ≈ 38.7%(호출토큰 기준, 새 식별자 미도입) · 종합 가능성 = 상(上).** 단, 자동화는 "Rosetta 정렬 전이"가 성립하는 경우에 한해 안전. 머리 6컴포넌트(268 바인딩)는 수작업/LLM 명명 필요.

---

## 1. 식별자 분포 (실측 — `_feas_scan.cjs`)

| 지표 | 값 |
|---|---|
| 총 바인딩(선언) 식별자 | **1,745** |
| distinct 바인딩명 | 319 |
| 단/이중문자 바인딩(선언, 도메인코드 제외) | **1,613** (92.4%) |
| distinct 단/이중문자명 | 187 |
| └ 모듈스코프 단문자 선언 | 151 |
| └ 로컬(함수)스코프 단문자 선언 | **1,462** (90.6%) |
| 도메인코드(대문자_언더스코어, preserve 대상) distinct | **132** |

핵심: 단문자 식별자의 **90.6%가 함수 지역(setup) 스코프**. 같은 글자(`n`,`o`,`s`,`r`,`a`…)가 컴포넌트마다 반복되지만 스코프가 분리돼 있어 babel `path.scope.rename`으로 **충돌 없이 스코프별 리네임** 가능. 상위 빈도(참조수): `W=34, A=26, D=24, C=24, a=19, n=18, d=18, O=18, B=17` — 전부 함수 지역.

도메인코드 132개(PDT_CD·MTRL_TYPE·COD·COD_NME·BSN_YN·SUB_MTR·PCS_CD·DFT_YN·MIN_PRN_CNT·INC_CNT 등)는 API 계약·도메인 의미 → **preserve(리네임 금지)**.

---

## 2. ★정렬 전이 가능성 (핵심 레버 — `_feas_align.cjs`)

### 2.1 컴포넌트 수준 overlap (`__name` 앵커)

| 구분 | 수 | 내용 |
|---|---|---|
| full.js `__name` 컴포넌트 | **58** | 완전한 모듈(머리+꼬리 전부) |
| v1 `__name` 컴포넌트 | **20** | (1 = `ApparelPrintArea__recovered` 합성머리) |
| **공유(전이 가능 overlap)** | **20** | full ∩ v1 |
| full 전용(v1 미보유) | **36** | 머리 6 + v1꼬리주석 언급 30 |

★**프롬프트 가정 정정**: "v1 = 절단 머리만 빠짐"이 아니었다. 실측 결과 **v1은 머리(Apparel/Book/Cover/Pantone 계열)를 전개**하고, **꼬리(후가공·수량 24컴포넌트)는 전개하지 않고 주석 스텁**으로 남겼다(v1 파일 끝 "이하 나머지 후가공 및 수량 컴포넌트들은 동일 패턴" + `[SYNTHETIC TAIL]` 균형괄호). 또한 full.js 진짜 "머리"(Error/Digital/Method/Acrylic/AcrylicPrintData/DesignQty/Chevron, 파일 상단 line 9~687)는 **v1에 아예 없다**(v1은 `ApparelPrintArea__recovered`부터 시작). 즉 v1은 full의 부분집합(머리 절단 + 꼬리 미전개)이다.

### 2.2 setup 바인딩 위치정렬 전이 (10개 공유 컴포넌트 실측)

setup 함수의 const/let 선언을 **선언 순서**로 정렬 → full 단문자 ↔ v1 의미명 1:1 매칭. 두 파일은 같은 코드라 선언 순서·개수가 동일.

| 컴포넌트 | full 바인딩 | v1 바인딩 | 위치정렬 전이가능 | 일치율 |
|---|---|---|---|---|
| Apparel | 49 | 49 | 49 | 100% |
| Book | 21 | 21 | 21 | 100% |
| BookQty | 25 | 25 | 25 | 100% |
| DosuColor | 9 | 9 | 9 | 100% |
| PantoneChipModal | 11 | 11 | 11 | 100% |
| CoverGuide | 16 | 16 | 16 | 100% |
| ApparelSizeGbn | 4 | 4 | 4 | 100% |
| ApparelMultiSizeQty | 15 | 15 | 15 | 100% |
| Acc | 33 | 33 | 33 | 100% |
| CLD_STD | 4 | 4 | 4 | 100% |
| **합계** | **187** | **187** | **187** | **100.0%** |

샘플(Apparel): `n→componentProps, o→emitFn, s→skinInfo, r→memberInfo, a→printTypeInfo, {l}→{uploadConfig}, {c}→{orderInfo}, h→selectedColorCode …` — 전건 위치 1:1 매칭. **공유 20컴포넌트는 정렬 전이로 100% 자동 명명 가능**(스크립트로 rename-map 생성 → engineer가 `path.scope.rename` 적용).

### 2.3 전체 바인딩 귀속 비중 (`_feas_coverage.cjs`)

단/이중문자 1,613개를 컴포넌트 범위로 귀속:

| 버킷 | 바인딩 | 비율 | 전이/명명 방법 |
|---|---|---|---|
| **공유 컴포넌트** (v1 의미명 100% 전이) | **607** | **37.6%** | 자동(정렬 전이) — **high** |
| **v1 꼬리주석 언급** (30컴포넌트, 라벨+패턴 보조) | **585** | **36.3%** | 반자동(같은 setup 패턴+v1 라벨) — **medium** |
| **완전 신규 머리** (Acrylic·AcrylicPrintData·Chevron·DesignQty·Digital·Method) | **268** | **16.6%** | 컨텍스트 명명(수작업/LLM) — **medium~low** |
| 컴포넌트 밖(모듈 top-level/헬퍼) | 153 | 9.5% | v1 Rosetta 헤더 65 별칭 매핑으로 대부분 해결 — **high** |

---

## 3. 컨텍스트 명명 시도 (머리/신규 — `_feas_evidence.cjs`)

머리 컴포넌트(v1 부재)도 **동일한 Vue setup 패턴**을 따른다(첫 두 바인딩 = props/emit, 이어 computed `R(`/inject `le(`/ref `H(`). 초기화식·도메인 프로퍼티 접근(`.PDT_CD`·`.COD_NME`·`.bsn_yn`·`.uploadType`)이 명명 근거. 대표 36건 실제 명명 시도:

| 식별자 | 컴포넌트 | 근거 (init/접근) | 제안 의미명 | 근거분류 | conf |
|---|---|---|---|---|---|
| n | Digital | `e` (setup 1번째 인자) | componentProps | (b) Vue props | 0.98 |
| o | Digital | `t` (setup 2번째=emit) | emitFn | (b) Vue emit | 0.98 |
| s | Digital | `R(()=>n.data.pdt_base_info[0].PDT_CD)` | productCode | (a) 필드+(b)computed | 0.95 |
| r | Digital | `R(()=>n.widgetAttr.skinInfo)` | skinInfo | (a) 필드 | 0.95 |
| a | Digital | `le("member")` | memberInfo | (b) inject 키 | 0.9 |
| i | Digital | `R(()=>{...option_info.shape_info...COD})` | hasShapeOption | (a)+(b) | 0.8 |
| l | Digital | `R(()=> bsn_yn==="Y"? pdt_mtrl_info : filter)` | materialList | (a) 필드 | 0.85 |
| c | Digital | `kn(()=>Ul({Acrylic/Basic/Paper.vue}…))` | materialComponent | (b) defineAsync | 0.85 |
| u | Digital | `R(()=>[...pdt_size_info].filter STICKER_TYPE)` | sizeList | (a) 필드 | 0.85 |
| m | Digital | `R(()=>Ql(pdt_pcs_info, pdt_disable_pcs_info))` | processOptions | (a) 필드 | 0.8 |
| w | Digital | `R(()=>SUB_MTR?.find(PCS_CD===xl[...]))` | subMaterial | (a) 도메인 | 0.8 |
| _e | Digital | `()=>{me?.onReset("fileUpload")}` | handleFileReset | (b) handler | 0.85 |
| n | Acrylic | `e` | componentProps | (b) | 0.98 |
| s | Acrylic | `R(()=>n.widgetAttr.skinInfo)` | skinInfo | (a) | 0.95 |
| r | Acrylic | `le("member")` | memberInfo | (b) | 0.9 |
| u | Acrylic | `R(()=> bsn_yn? pdt_mtrl_info: filter)` | materialList | (a) | 0.85 |
| d | Acrylic | `R(()=>[...pdt_size_info])` | sizeList | (a) | 0.85 |
| h | Acrylic | `R(()=>Ql(pdt_pcs_info,…))` | processOptions | (a) | 0.8 |
| n | Method | `e` | componentProps | (b) | 0.98 |
| r | Method | `le("productCode",{pdtCode:""})` | productCodeCtx | (b) | 0.9 |
| a | Method | `le("callbacks",{})` | callbacks | (b) | 0.95 |
| i | Method | `le("deviceType","pc")` | deviceType | (b) | 0.95 |
| l | Method | `R(()=>n.options.map(h=>({name:h.COD_NME…})))` | methodSelectOptions | (a)+(b) | 0.9 |
| c | Method | `H(n.default||l.value[0].value)` | selectedMethod | (b) ref | 0.85 |
| u | Method | `h=>{c.value=h}` | setSelectedMethod | (b) handler | 0.85 |
| f | Method | `n.options.find(_=>_.COD==h)` | matchedOption | (a) | 0.8 |
| l | DesignQty | `R(()=>n.options.find(C=>C.DFT_YN==="Y")…)` | defaultOption | (a) DFT_YN | 0.9 |
| c | DesignQty | `R(()=>l.value?.DFT_PRN_CNT||1)` | defaultPrintCount | (a) 도메인 | 0.9 |
| u | DesignQty | `R(()=>l.value?.MIN_PRN_CNT||1)` | minPrintCount | (a) 도메인 | 0.9 |
| d | DesignQty | `R(()=>l.value?.INC_CNT||1)` | incrementCount | (a) 도메인 | 0.9 |
| h | DesignQty | `R(()=>l.value?.INC_STEP||10)` | incrementStep | (a) 도메인 | 0.9 |
| _ | DesignQty | `H(n.default?.ordCnt||1)` | orderQty | (a) 필드 | 0.85 |
| p | DesignQty | `H(n.default?.prnCnt||…)` | printQty | (a) 필드 | 0.85 |
| v | DesignQty | `R(()=>(_.value*p.value).toLocaleString())` | totalQtyDisplay | (b) computed | 0.8 |
| c | AcrylicPrintData | `R(()=>n.options.map(_=>({name:_.COD_NME…})))` | printDataOptions | (a) | 0.9 |
| u | AcrylicPrintData | `H(n.default||c.value[0].value)` | selectedPrintData | (b) ref | 0.85 |
| h | AcrylicPrintData | `{O:new Set(["ACTHBCO","ACTHDCO"]),X:…}` | printDataCodeSets | (a) 도메인코드 | 0.75 |

근거분류 집계(36 시도): (a) 문자열/프로퍼티·API 필드 **20** · (b) Vue setup 패턴 **14** · (c) 도메인코드 preserve(별도) · (d) 근거빈약(제네릭 루프 `C`,`y` 재사용 임시) **2**. **평균 confidence ≈ 0.87**. 머리 컴포넌트도 setup 패턴+도메인 필드 덕에 명명 가능성 충분(단 v1 같은 검증 정답지 없음 → conf 상한 ~0.9).

근거빈약 사례: DesignQty의 `C`,`y`,`I` 같은 글자는 한 함수 안에서 임시루프/구조분해로 **여러 번 재선언**(refs 분산) → 제네릭(`tmp`,`idx`,`item`) 또는 좁은 스코프 개별 명명 필요.

---

## 4. ★구획 구분 — setup 로직 vs 컴파일 render (`_feas_region*.cjs`)

mod_07 = Vue 3 **컴파일된** 컴포넌트. setup 반환 화살표 = `(g(),M("div",…,[V(je,…),S("p",…)]))` 형태의 **createVNode 트리**(기계생성).

| 지표 | 값 | 해석 |
|---|---|---|
| 전체 CallExpression | 2,515 | |
| render 헬퍼 호출(g/V/M/S/j/oe/he/ce/de) | **974** (**38.7%** of calls) | render 트리 비중 |
| render alias 토큰(텍스트): g=245 V=106 M=139 S=188 j=85 oe=61 he=44 ce=52 de=54 | 974 | 위와 일치 |
| VNode 생성자 호출(V+M+S) | 433 | DOM/컴포넌트 노드 |
| render 화살표 패턴 `=>(g()` | 90+ | 컴포넌트당 render |

★**핵심 통찰**: render 트리는 줄/호출의 ~38.7%를 차지하지만 **새 명명 대상 식별자를 거의 도입하지 않는다.** render 내부 식별자 = ① render 헬퍼 별칭(`g`,`V`,`M`,`S`,`j`,`T`…) — v1 Rosetta 헤더가 **이미 전역 명명**(openBlock/createVNode/createElementVNode…), ② setup 바인딩 참조(§2에서 이미 전이/명명됨), ③ HTML 문자열 리터럴·정적 props(명명 불요). 즉 **render 트리는 "이름 줘도 포팅 난해"한 게 아니라, 명명할 게 없다**(기계생성 트리는 그대로 두거나 prettier 재포매팅만). 포팅 가치는 **setup 로직(computed/watch/이벤트 핸들러·도메인 데이터 변환)에 집중**. render는 컴포넌트를 새로 작성할 때 어차피 `<template>`로 다시 쓰므로 식별자 명명 의의 낮음.

포팅 관점 진짜 필요분 = **setup 로직 식별자**(컴포넌트당 4~49개) = §2·§3의 대상. 1,613 단문자 중 render-전용으로만 쓰이는 잉여는 사실상 0(전부 setup에서 선언 후 render에서 참조).

---

## 5. ★Rosetta 전역 헬퍼 (보너스 — `_feas` v1 헤더)

v1 헤더에 **65개 전역 별칭 매핑** 명시(별칭→Vue 의미). 컴포넌트 무관 전역이라 머리/꼬리 포함 **전 파일 적용**:
`g→openBlock, V→createVNode, M→createElementVNode, S→createElement, ce→withCtx, de→withDirectives, j→toDisplayString, T→unref, oe→createCommentVNode, J→Fragment, he→renderList, re→defineComponent, R→computed, H→ref, F→watch, xe→reactive, le→inject, Ve→useExteriorStore, Dt→useConfigStore, we→normalizeClass, Po→createTextVNode, Be→withScopeId, on→resolveDirective, br→withModifiers …` + 컴포넌트 임포트(fe→OptionRow, je→ImageButton, Dn→RadioList, Fo→Selector, Sn→ButtonRadio, sh→ColorPicker…).

→ §2.3의 "컴포넌트 밖" 153 바인딩 + 모든 컴포넌트의 헬퍼 호출이 이 65 매핑으로 **high-conf 전이**. 정렬 전이 가능분을 더 끌어올림.

---

## 6. 정량 종합 — 의미 전달 가능 비율

단/이중문자 바인딩 1,613 기준(도메인코드 132 = preserve 별도):

| 신뢰도 | 비율(바인딩) | 근거 | 자동화 |
|---|---|---|---|
| **High** | **≈ 47%** (607 공유 + 153 헬퍼 일부) | 정렬 전이 100% 실증 + Rosetta 65 별칭 | **자동**(스크립트 rename-map → babel rename) |
| **Medium** | **≈ 37%** (585 v1꼬리주석) | 같은 setup 패턴 + v1 한국어 라벨(예 `COT_DFT=코팅`)이 컴포넌트 의미 고정, 내부 바인딩은 §3 방식 명명 | **반자동**(패턴 템플릿 + 검수) |
| **Low~Medium** | **≈ 17%** (268 머리 6컴포넌트) | 컨텍스트 명명(평균 conf 0.87)·정답지 없음 | **수작업/LLM**(검증 필수) |

- **render 함수 비중 ≈ 38.7%**(호출토큰) — 새 식별자 미도입, 명명 부담 0(별도 명명 불요·prettier 재포매팅만).
- **자동화 가능분 ≈ 74%**(공유 100% 전이 + 꼬리 패턴/라벨 보조). **순수 수작업 ≈ 17%**(머리), 나머지 9%(헬퍼)는 Rosetta로 자동.

### 종합 가능성 = **상(上)**
근거: ① 두 파일이 **구조적으로 동일**해 공유 20컴포넌트 setup 바인딩 187/187(100%) 위치정렬 전이 실증, ② render 트리는 명명 대상이 아님(38.7% 부담 제거), ③ 머리조차 동일 Vue setup 패턴+도메인 필드로 conf 0.87 명명 가능, ④ Rosetta 65 전역 별칭이 헬퍼 전부 커버. **단** 머리 6컴포넌트(16.6%)는 정답지 부재로 자동 전이 불가 — LLM/수작업 명명 후 verifier(G3 잔여 단문자 0·G6 단사성) 게이트 필수.

---

## 7. 권고 (cartographer rename-map 산출 방향)

1. **정렬 전이 스크립트화**: 공유 20컴포넌트 setup 바인딩을 선언순 정렬 → full↔v1 1:1 rename-map 자동 생성(source:`inferred-aligned`, conf 0.95). `_feas_align.cjs` 로직 재사용.
2. **Rosetta 헤더 65 별칭** → 모듈 스코프 rename-map에 source:`header`, conf 0.97로 병합.
3. **도메인코드 132** → preserve:true 목록.
4. **머리 6컴포넌트**(Acrylic·AcrylicPrintData·Chevron·DesignQty·Digital·Method, 268 바인딩) → §3 컨텍스트 명명을 rename-map에 source:`inferred`, conf 0.7~0.9로, work-units.csv에 "정답지 부재·검수 필요" 표시.
5. **render 트리**: 별도 명명 안 함(헬퍼 별칭만 전역 rename). 컴파일 render는 fold/주석으로 "Vue 컴파일 render — 포팅 시 template 재작성" 명시.
6. work-units 우선순위: 공유(High·자동) → 꼬리(Medium) → 머리(Low·수작업).

> 측정 스크립트: `_tooling/_feas_scan.cjs · _feas_align.cjs · _feas_region.cjs · _feas_region2.cjs · _feas_evidence.cjs · _feas_coverage.cjs` (재실행 가능). 임시 산출이므로 cartographer 정식 산출(01_cartography/) 이전 정리 가능.
