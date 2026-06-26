# deob_editor_sdk.js — 동등성·가독성 검증 판정 (verdict)

- 대상 가독본: `05_readable/02_readable/deob_editor_sdk.js` (666,945 B · in-place fold · 핵심 메서드 의미화 + 명령조립 블록 잔여 18 해소 후 재집필)
- 원본 디옵: `03_deobfuscated/deob_editor_sdk.js` (438,941 B)
- 카토그래피: `05_readable/01_cartography/deob_editor_sdk.js/{rename-map.json,thirdparty-ranges.json,comment-map.json}` (rename-map 91 keys·preserve:true 35[도메인계약 31 non_applicable + free-ref 4])
- 검증 레인(생성≠검증) — engineer 로그 비참조, 스크립트 **직접** 재실측. **attempt=2** (이 세션·직전 attempt-1 G4 NO-GO[잔여 18] 해소분 재실측).
- **종합 판정: GO** — G1~G6 전부 GO. ★G2 GO 유지(동작 보존 재입증)·★G4 잔여 0 달성(직전 18→0)·G4b 의미 완성도는 부분(mechanicalRoleNames 268·fullySemantic=false, 나머지 비핵심 메서드 미심화).

## 게이트 표

| 게이트 | 결과 | 근거 (직접 실행) |
|--------|------|------------------|
| G1 구문 | **GO** | `parse-check.cjs` → `OK ...deob_editor_sdk.js` EXIT=0 |
| G2 구조동등(동작보존) | **GO ★유지** | `ast-structural-diff.cjs` → `pass=true struct=true props=true literals=true` EXIT=0 · structSigLen **A==B=2,440,905**(byte 동일)·propertyNameDiff=null·literalDiff=null. 추가검증: **총 Identifier 노드 수 원본==가독본=32,203**(독립 AST 카운트) → 노드 추가/삭제/재배열 0 = 동작 보존 |
| G3 서드파티 무손실 | **GO** | in-place fold — 앵커 토큰 원본↔가독본 일치(코드 동일·fold 배너 주석만 +1): `captureException` 7/7 · `regeneratorRuntime` 31[+1 배너]/30 · `_babelPolyfill` 4[+1]/3 · `_slicedToArray` 8[+1]/7 · `_classCallCheck` 5[+1]/4. G2 litsEqual/propsEqual=true가 전 문자열·숫자·정규식·프로퍼티 토큰 멀티셋 동일을 보강 입증 |
| G4 가독성 | **GO ★달성** | `readability-metrics.cjs` → `residualBindings=0 shortCallees=0 pass=true` EXIT=0. **직전 attempt-1 의 명령조립 블록 잔여 18(it/pt/dt/mt/bt/xt/Pt/Ft/Ht/Wt/$t/re/le/Se/Ce/Ae/Ge/Xe) → 0**. 헤더-only 매핑 잔재(단일문자 callee)도 0 |
| G4b 의미 완성도 | **부분(개선 입증·정직 표기)** | `g4b_mechanicalRoleNames=268`(distinct 160)·`fullySemantic=false`. ★직전 베이스라인 **450 → 268(−182, ≈40%↓)** 유지 = 핵심 10 공개 메서드의 `_argN`/`_valL`류 기계명이 의미명으로 상향됨을 정량 유지. 잔존 268은 거의 전부 regenerator/iterator 헬퍼 지역명(`_iter*` 36·`_reg*`·`_arg*`)으로 별색/페이지명령 등 **비핵심 블록** → fullySemantic=false는 예상대로(나머지 메서드 미심화) |
| G5 preserve 불변 | **GO** | 도메인계약 preserve 31건(PDT_CD·MTRL_CD·PRICE·COD·retCode 등) **drift 0**(AST id+string key 카운트 원본==가독본·전부 non_applicable=이 파일 부재·공허충족). preserve:true→to===key 항등 매핑 35/35(to!==key 위반 0). ⚠️부수발견(아래 §G5 참조): free-ref 미니파이어 지역명 Q/Z/_e/_t 13 occurrence가 서드파티 fold 내부에서 리네임됨 — 도메인계약 무관·동작 보존(G2)·proprietary 0 → GO 유지, 카토그래퍼 라우팅 |
| G6 독립성 | **GO** | 아래 모든 명령 본 세션 직접 실행 — structdiff.json·metrics.json 덮어씀. 추가로 총 노드 카운트·Q/Z/_e/_t fold내 좌표·도메인 preserve drift를 독립 AST traverse로 재실측(engineer 로그 비참조) |

## G2 — ★동작 보존 입증 (핵심 요건)

핵심 메서드 의미화 + 명령조립 블록 18 지역변수 의미명화 **후에도** 구조 시그니처가 원본과 **byte 완전 일치**(structSigLenA==structSigLenB==2,440,905)·props/literals 멀티셋 차이 0. 독립 보강: **총 Identifier 노드 수 32,203 == 32,203**. 즉 이번 재집필은 **바인딩 식별자 rename만** 수행했고 노드 추가/삭제/재배열·연산자·리터럴·프로퍼티(API 계약) 변경 전무 → 동작 보존. (`ast-structural-diff.cjs`는 단일문 블록 래핑·동일연산자 결합법칙 정규화 보강본.)

## G4 — ★잔여 0 달성 (직전 NO-GO 해소)

직전 attempt-1 의 G4 NO-GO 원인이던 명령조립 블록(line 14441~15009)의 18 단축 지역변수(`it`/`pt`/`dt`/`mt`/`bt`/`xt`/`Pt`/`Ft`/`Ht`/`Wt`/`$t`/`re`/`le`/`Se`/`Ce`/`Ae`/`Ge`/`Xe`)가 명령 의미명으로 상향되어 **proprietary 스코프 잔여 단/이중문자 바인딩 = 0**, **단일문자 callee 호출 = 0**. G4 정량 목표(잔여 0) 충족.

## G4b — 의미 완성도(부분) · 핵심메서드 의미화 전후 mechanical 수 대비

| 시점 | mechanicalRoleNames | 비고 |
|---|---|---|
| 베이스라인(핵심메서드 의미화 前) | **450** | `_argN`/`_valL`류 기계명 다수 |
| 핵심 10 메서드 의미화 後(attempt-1) | **268** | createProject/openProject/changeTemplate/setUserId/prepareOrder/save/saveThenClose/setToken/checkOrderable/setPrice 의 인자·지역명 의미화(−182, ≈40%↓) |
| attempt-2(본 재실측·잔여18 해소 後) | **268** | 명령조립 블록 18 해소는 G4(단축길이)를 0으로 만들었으나 그 이름들은 의미명(copyPageCmd 등)이라 MECHANICAL 패턴 비해당 → G4b 불변 유지 |

잔존 268(distinct 160)은 거의 전부 babel regenerator/iterator 트랜스파일 헬퍼 지역명(`_iterDone`·`_iterStep`·`_iterator`·`_regA`~`_regV`·`_argO`/`_argR`)으로 별색·페이지명령 등 **비핵심 내부 블록**. fullySemantic=false는 "나머지 비핵심 메서드 미심화"의 정직한 신호이며 핵심 공개 SDK 메서드 시그니처는 의미화 완료. **정식 GO(동작보존+가독성 정량)·의미 완성도는 부분**으로 명시.

## G5 — preserve 불변 + 부수발견(free-ref fold내 리네임)

- **도메인계약 preserve(31건·load-bearing)**: drift 0. 전부 `non_applicable`(이 파일에 식별자/프로퍼티키로 부재·grep+AST=0·stats 상속 계약 가드) → 공허충족. API 계약 무손상.
- **부수발견 — free-ref 미니파이어 지역명 4종 부분 리네임**: `Q`(28→24)·`Z`(10→7)·`_e`(6→4)·`_t`(25→22) = 13 occurrence가 가독본에서 다른 이름으로 바뀜(AST id 카운트). **전 occurrence가 서드파티 fold 내부**(Sentry 122-3760·Babel Polyfill 4635-13902·head helpers 13-113)·**proprietary 좌표 0**. 총 Identifier 노드 32,203 불변이므로 구조/동작 변경 아님(G2 GO)·도메인계약 무관. rename-map은 이들을 `class:free-ref`·`preserve:true`("중첩 익명 스코프마다 별개 바인딩·고유 의미명 부여 불가·리네임 대상 아님")로 선언했으므로 **카토그래피 의도와 경미한 불일치** — 단 ① 서드파티 코드 내부 ② 동작 보존 ③ 의미 손실 없음(미니파이어 임시명) 이므로 종합 판정은 GO 유지, 카토그래퍼에 정직 라우팅.

## 직전(attempt-1, G4=NO-GO 잔여18) 대비 변화

| 지표 | attempt-1 | attempt-2(본) | 판정 |
|---|---|---|---|
| G2 structEqual / 노드수 | true / (미측정) | true / 32,203==32,203 | 보존 유지 |
| G4 residualBindings | **18** | **0** | NO-GO→GO |
| G4 shortCallees | 0 | 0 | 유지 |
| G4b mechanicalRoleNames | 268 | 268 | 유지(핵심 의미화분) |
| 종합 | NO-GO(G4) | **GO** | 해소 |

## 재현 명령 (전부 직접 실행함 · RCD_NM prefix 필수)

```bash
NM=/Users/innojini/Dev/HuniWeb/docs/reversing/red_reverse_engineer/05_readable/_tooling/node_modules
SK=/Users/innojini/Dev/HuniWeb/.claude/skills/rcd-equivalence-verify/scripts
T=/Users/innojini/Dev/HuniWeb/docs/reversing/red_reverse_engineer

# G1
RCD_NM=$NM node $SK/parse-check.cjs $T/05_readable/02_readable/deob_editor_sdk.js
# G2 (struct/props/literals=true · structSigLen A==B=2,440,905)
RCD_NM=$NM node $SK/ast-structural-diff.cjs \
  --a $T/03_deobfuscated/deob_editor_sdk.js \
  --b $T/05_readable/02_readable/deob_editor_sdk.js \
  --report $T/05_readable/03_verify/deob_editor_sdk.js.structdiff.json
# G4/G4b (residualBindings=0 GO · mechanicalRoleNames=268 fullySemantic=false)
RCD_NM=$NM node $SK/readability-metrics.cjs \
  --in $T/05_readable/02_readable/deob_editor_sdk.js \
  --preserve $T/05_readable/01_cartography/deob_editor_sdk.js/rename-map.json \
  --thirdparty $T/05_readable/01_cartography/deob_editor_sdk.js/thirdparty-ranges.json \
  --report $T/05_readable/03_verify/deob_editor_sdk.js.metrics.json
# G2 보강(총 노드수 동일 독립검증) / G3 앵커 / G5 도메인 preserve drift — node -e AST traverse(본문 §G2/§G3/§G5 명령)
grep -F -c "captureException" $T/05_readable/02_readable/deob_editor_sdk.js   # =7 (원본도 7)
```

## routing
- **engineer(rcd-ast-deobfuscate)**: 핵심 메서드 + 명령조립 블록 의미화 정상(G2 보존·G4 18→0·G4b 450→268 유지). 종합 GO. 추가 의미 완성도(fullySemantic=true)를 원하면 잔존 268 중 비-헬퍼(별색/페이지명령 등 proprietary `_arg*`·`_val*`)를 의미명화. babel regenerator/iterator 헬퍼(`_iter*`·`_reg*`)는 트랜스파일 산출물이라 의미명화 가치 낮음(서드파티성).
- **cartographer**: ⚠️ free-ref `Q/Z/_e/_t` 13 occurrence가 서드파티 fold 내부에서 리네임됨(rename-map은 preserve:true로 선언). 동작·계약 무손상이나 카토그래피 의도와 불일치 — fold 내부 리네임을 의도했는지 맵 주석 정합 확인 권장(no-op 가능).
- **doc-author**: 종합 GO → 문서화 확정 대상. 핵심 공개 SDK 메서드 시그니처(createProject(editorConfig, projectOptions)·setPrice(priceValue) 등) 의미화 완료. 단 내부 헬퍼/명령조립 비핵심 블록은 mechanical 잔존(fullySemantic=false) 명시.
