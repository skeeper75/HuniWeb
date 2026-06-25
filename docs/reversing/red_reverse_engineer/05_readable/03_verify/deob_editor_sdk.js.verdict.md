# deob_editor_sdk.js — 동등성·가독성 검증 판정 (verdict)

- 대상 가독본: `05_readable/02_readable/deob_editor_sdk.js` (658,568 B, in-place fold)
- 원본 디옵: `03_deobfuscated/deob_editor_sdk.js` (438,941 B)
- 카토그래피: `05_readable/01_cartography/deob_editor_sdk.js/{rename-map.json,thirdparty-ranges.json}`
- 검증 레인(생성≠검증) — engineer 로그 비참조, 스크립트 **직접** 재실측. **attempt=2** (attempt-1=NO-GO@G4, 재집필분 재실측).
- **종합 판정: GO** (G1~G6 전부 GO)

## 게이트 표

| 게이트 | 결과 | 근거 (직접 실행) |
|--------|------|------------------|
| G1 구문 | **GO** | `parse-check.cjs` → `OK ...deob_editor_sdk.js` EXIT=0 |
| G2 구조동등(동작보존) | **GO** | `ast-structural-diff.cjs` → `pass=true struct=true props=true literals=true` EXIT=0 (스크립트 보강 후·아래 결함 분석 참조) |
| G3 서드파티 무손실 | **GO** | in-place fold — Sentry/Babel polyfill 앵커 본문 잔존(`captureException`=7/7·`Promise.all requires an array as input.`=1/1) + G2 litsEqual=true/propsEqual=true가 전 토큰 동일 입증 |
| G4 가독성 | **GO** | `readability-metrics.cjs` → `residualBindings=0 shortCallees=0 pass=true` (metrics.json `residualShortBindings:0`) |
| G5 preserve 불변 | **GO** | free-ref 4종(Q=24·Z=8·_e=4·_t=21) 본문 잔존·미리네임 / non_applicable 31종 설계상 부재(공허충족·grep 0) |
| G6 독립성 | **GO** | 아래 모든 명령 본 세션에서 직접 실행 — engineer 산출(structdiff.json·metrics.json) 덮어씀 |

`residual_short_bindings = 0`.

## G2 결함 분석 — 보강 전 4건 발견 → 전부 "동작 보존 포매팅"으로 확정

보강 전 `ast-structural-diff.cjs`는 `struct=false`(시그니처 len A=2,523,740 / B=2,523,786, Δ46)로 NO-GO를 냈다. props/literals는 동일. 재귀 하강으로 **전 분기점 4개**를 좌표·종류까지 특정해 동작 변경 여부를 1건씩 판정했다.

| # | 종류 | 원본 라인 | 가독본 라인 | 정체 | 동작 |
|---|------|-----------|-------------|------|------|
| 1 | IfStatement→BlockStatement | 555 | 761 | `if(Array.isArray(t)) if(...)...else...` → prettier가 외부 if consequent를 `{}`로 래핑 (Promise.all 폴리필·Sentry 번들) | **보존** — dangling-else 바인딩 불변(else는 항상 최근접 if·블록 래핑이 바인딩을 안 바꿈) |
| 2 | IfStatement→BlockStatement | 2070 | 3009 | 동일 패턴(중괄호 추가) | **보존** |
| 3 | BinaryExpression→LogicalExpression (alternate.left) | 11515 | 17297 | proprietary ddp 콜백: `A && (B && C)` 잉여 괄호 제거 → `A && B && C` | **보존** — `&&` 결합법칙(평가순서·단락·결과 동일) |
| 4 | LogicalExpression→CallExpression (alternate.right) | 11515 | 17297 | #3과 동일 식의 우측 노드 — 같은 괄호 제거의 반대편 | **보존** — #3과 한 쌍 |

결론: 4건 모두 **prettier의 의미-불변 정규화**(단일문 중괄호 래핑 2건 + 동일연산자 잉여괄호 제거 1건=노드 2개로 표시). 노드 추가/삭제/재배열·연산자 변경·리터럴/프로퍼티 변동 **없음**.

### 조치 — 스크립트 보강(SKILL.md 함정 항 지침대로 정규화 누락 보강)
`ast-structural-diff.cjs` `signature()`에 동작-보존 정규화 2종 추가(보강 파일=`.claude/skills/rcd-equivalence-verify/scripts/ast-structural-diff.cjs`):
1. `unwrapSingleBlock` — `BlockStatement{body:[S]}`(directive 없음) ≡ `S`.
2. `flattenLogical` — 동일 연산자 `&&`/`||`/`??` 체인을 좌→우 피연산자로 평탄화(`LogicalChain(...)`)해 괄호 차이 흡수.

보강은 **보수적**임을 적대 검증으로 입증:
- 회귀: 기검증 통과 파일 `deob_05_app_api`·`deob_06_app_widget_sdk` 여전히 `pass=true` (오통과 없음).
- mutant1(실제 `&&`→`||` 연산자 변경): `pass=false struct=false` → **적발**.
- mutant2(객체 프로퍼티 1개 추가=노드 추가): `pass=false props=false literals=false`, `onlyReadable=[["__injected",1]]` → **적발**.

즉 보강은 동작-보존 포매팅만 동등 취급하고 진짜 동작 변경은 그대로 검출한다. 보강 후 본 파일 G2 = `pass=true`.

## 재현 명령 (전부 직접 실행함 · RCD_NM prefix 필수)

```bash
NM=/Users/innojini/Dev/HuniWeb/docs/reversing/red_reverse_engineer/05_readable/_tooling/node_modules
SK=/Users/innojini/Dev/HuniWeb/.claude/skills/rcd-equivalence-verify/scripts
T=/Users/innojini/Dev/HuniWeb/docs/reversing/red_reverse_engineer

# G1
RCD_NM=$NM node $SK/parse-check.cjs $T/05_readable/02_readable/deob_editor_sdk.js
# G2 (보강된 스크립트)
RCD_NM=$NM node $SK/ast-structural-diff.cjs \
  --a $T/03_deobfuscated/deob_editor_sdk.js \
  --b $T/05_readable/02_readable/deob_editor_sdk.js \
  --report $T/05_readable/03_verify/deob_editor_sdk.js.structdiff.json
# G4
RCD_NM=$NM node $SK/readability-metrics.cjs \
  --in $T/05_readable/02_readable/deob_editor_sdk.js \
  --preserve $T/05_readable/01_cartography/deob_editor_sdk.js/rename-map.json \
  --thirdparty $T/05_readable/01_cartography/deob_editor_sdk.js/thirdparty-ranges.json \
  --report $T/05_readable/03_verify/deob_editor_sdk.js.metrics.json
# G3 (토큰 잔존)
grep -F -c "captureException" $T/05_readable/02_readable/deob_editor_sdk.js   # =7 (원본도 7)
# G5 (free-ref 잔존 / non_applicable 부재)
grep -E -c "\bQ\b" $T/05_readable/02_readable/deob_editor_sdk.js              # =24
grep -E -c "\bPDT_CD\b" $T/05_readable/02_readable/deob_editor_sdk.js         # =0
```

## routing
- **결함 없음** — engineer 가독본은 GO. 추가 작업 불요.
- **engineer 산출 정상**: 모든 가독본↔원본 차이가 prettier 동작-보존 포매팅(괄호/중괄호)이며, 리터럴·프로퍼티·식별자(preserve) 무손실.
- **cartographer 맵 정상**: free-ref 4종(Q/Z/_e/_t) 정직 기록 = 리네임 불가 관례 minifier 지역명. G4 잔여 아님 = "문서화 대상"(doc-author). 무리한 의미명 부여 금지가 옳음.
- **도구 보강(다음 세션 재사용)**: `ast-structural-diff.cjs`에 단일문 블록·동일연산자 결합법칙 정규화 추가. 향후 prettier 포매팅된 가독본에 일관 적용(적대 mutant로 보수성 입증).
- doc-author: GO 파일 → 문서화 대상에 포함.
