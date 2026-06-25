# engineer-log — deob_07_app_components.js (재시도 #2 / attempt 2)

생성(변환) 레인: AST 바인딩 단위 rename만·텍스트 치환 금지·동작 보존.

## 결과 요약
- **applied=0, skipped=0** — rename-map 172개 엔트리 **전부 `preserve:true` self-map**(to===orig)이라
  스코프 안전 리네임 대상이 0건. codemod는 **주석 주입(26건: section-banner 3·jsdoc 23) + prettier 포매팅**만 수행.
- 산출: `02_readable/deob_07_app_components.js` (4865 lines — 디옵 슬라이스 2607행을 prettier가
  인라인 삼항·콤마체인 해소로 확장).
- **자가 점검 전부 PASS** (G1·G2·G4·G5 상응 스크립트 직접 실행).

## 입력 = recovered.js (★절단 복원본 — cartographer 공급)
직전 attempt 1 NO-GO 근본원인 = **입력 truncation**: `03_deobfuscated/deob_07_app_components.js`는
번들 슬라이스라 첫 실 코드행(line 105)이 orphan `}),` (매칭 여는 토큰이 파일 안에 없음 → 브래킷 불균형
→ babel `Unexpected token (105:10)`, errorRecovery로도 복구 불가). attempt 1 게이트가 이를 정확히 FAIL로 보고.

cartographer가 라우팅대로 **선두 절단부를 합성 HEAD/TAIL로 복원**한
`03_deobfuscated/deob_07_app_components.recovered.js` (2635 lines)를 공급했고, comment-map의
section-banner(anchor `line:97`)에 "engineer 는 recovered.js 를 `--in` 으로 사용할 것" 명시.
→ 본 attempt는 그 directive대로 **recovered.js를 `--in`** 으로 사용.

- 합성 HEAD (recovered line 104~125): `const __recoveredApparelPrintAreaSetup = defineComponent({ setup(props,{emit}){ const ... = computed(() => {` — 잘린 앞 컴포넌트 setup 머리를 SCAFFOLD로 복원(원본 코드 아님·동작 무관·리네임/검증 대상 아님).
- 합성 TAIL (recovered line 2633~2635): 슬라이스 끝 트레일링 미닫힘 괄호 6개를 `))))))`로 균형
  (engineer 독립 babel 검증으로 6개 정확 확인 — cartographer 산출과 일치).
- 합성 래퍼는 명시 주석(`SYNTHETIC TRUNCATION-RECOVERY WRAPPER`)으로 표식 — 가독본에도 그대로 보존.

### ★ verifier 유의 (G2 비교 대상)
가독본은 recovered.js에서 파생되므로 합성 HEAD/TAIL을 **그대로 포함**한다.
따라서 **G2 ast-structural-diff 의 `--a` 는 raw 절단 원본이 아니라 `*.recovered.js` 여야** 한다
(raw 원본은 파싱 불가 + 구조에 합성 래퍼 없음 → 거짓 불일치). 자가 점검도 recovered.js 기준 PASS.

## 자가 점검 (engineer 직접 실행)
| 게이트 | 스크립트 | 결과 |
|---|---|---|
| G1 | `parse-check.cjs 02_readable/deob_07_app_components.js` | **OK** (exit 0) |
| G2 | `ast-structural-diff --a recovered.js --b 02_readable/...js` | **pass=true** (struct=true·props=true·literals=true) |
| G4 | `readability-metrics --in 02_readable/...js` | **pass=true** (residualBindings=0·shortCallees=0) |
| G5 | preserve 식별자 verbatim 존재 확인 | **OK** (PDT_CD·MTRL_CD·PRN_CNT·CUT_WDT·PCS_CD·PCS_DTL_CD·COD·COD_NME·KOI_NME 등 전부 잔존) |

- G2 PASS = **동작 보존 증명**: 식별자명/주석/공백 무시 AST 구조 + 비계산 프로퍼티명 멀티셋 + 문자열/숫자/정규식 리터럴 멀티셋이 입력과 동일 → 리네임 0·주석/포매팅만 변경.

## skipped 분석
- skipped=0. scope-mismatch 없음(리네임 자체가 0건이므로). cartographer scope 보강 불요.
- rename-map이 전부 preserve self-map인 점은 정상 — 이 슬라이스의 가독성 향상은
  ① 주석/JSDoc 주입 ② prettier 포매팅(콤마체인/삼항 해소)에서 나온다(식별자는 이미 의미 보존된 도메인 코드라 rename 불필요).

## 적용 명령 (재현용)
```
RCD_NM=.../_tooling/node_modules node .../apply-rename-map.cjs \
  --in    .../03_deobfuscated/deob_07_app_components.recovered.js \
  --out   .../05_readable/02_readable/deob_07_app_components.js \
  --rename   .../01_cartography/deob_07_app_components.js/rename-map.json \
  --comments .../01_cartography/deob_07_app_components.js/comment-map.json \
  --skipped  .../05_readable/03_verify/deob_07_app_components.js.skipped.json
```

## 위젯 파일 — 서드파티 fold 불필요
thirdparty-ranges.json = `[]` (Sentry/Babel 폴리필 등 서드파티 블록 없음). fold 단계 생략(`.thirdparty.js` 없음).

## 스크립트 수정 없음
apply-rename-map.cjs / parse-check.cjs 등 스크립트는 attempt 1에서 이미 errorRecovery 등 보강됨.
본 attempt는 균형 입력(recovered.js)만 수령해 재실행 — 스크립트/맵 추가 수정 불요(부재·파싱불가를 정확히 FAIL로 보고하는 동작 유지).
