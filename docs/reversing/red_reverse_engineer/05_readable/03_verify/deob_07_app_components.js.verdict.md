# verdict — deob_07_app_components.js (독립 검증 게이트 · attempt 2)

**판정: GO** (G1·G2·G3·G4·G5·G6 전부 GO · 단일 FAIL=NO-GO 기준 통과)

검증 레인은 engineer 로그를 **신뢰하지 않고** 아래 스크립트를 모두 절대경로 + `RCD_NM` prefix로 **직접 재실측**했다(G6). 추가로 babel 파서로 가독본을 **독립 AST 스캔**해 G4를 교차 확증, recovered.js 안에 원본 본문이 verbatim 존재하는지 직접 대조해 G2 기준점의 정당성을 검증했다.

## G1~G6 게이트 표

| 게이트 | 결과 | 근거 (직접 재실측) |
|--------|------|-------------------|
| G1 구문 유효 | **GO** | `parse-check.cjs 02_readable/deob_07_app_components.js` → `OK` (exit 0). |
| G2 구조동등(동작보존) | **GO** | `ast-structural-diff.cjs --a *.recovered.js --b 02_readable/...js` → `pass=true struct=true props=true literals=true` (exit 0). structSigLen A==B=`427581`, propertyNameDiff=null, literalDiff=null. ★`--a`는 절단 raw 원본이 아니라 cartographer 공급 `*.recovered.js`(아래 근본원인·정당성 참조). |
| G3 서드파티 | **GO (N/A)** | `thirdparty-ranges.json = []` (위젯 파일·서드파티 없음). 이동/분리 블록 0건 → 무손실 대상 없음 → in-place 유지(자동 충족). |
| G4 가독성 | **GO** | `readability-metrics.cjs` → `residualBindings=0 shortCallees=0 pass=true`. **독립 교차확증**: 별도 babel AST 스캔(관례 loop/temp 이름 제외) → short bindings 0 distinct·short callees 0 distinct. 스크립트 residual=0은 false-negative 아님. |
| G5 preserve 불변 | **GO** | rename-map 172개 `preserve:true` 식별자 전부 verbatim 존재(word-boundary grep, present 172/172·missing 0). PDT_CD·MTRL_CD·PRICE·COD·COD_NME·KOI_NME·PCS_CD·Vue 런타임 헬퍼(createVNode/computed/ref…) 전부 잔존. |
| G6 독립성 | **GO** | engineer 로그를 근거로 쓰지 않고 parse-check·ast-structural-diff·readability-metrics를 직접 실행 + 독립 babel 스캔 + recovered.js verbatim 대조를 추가 수행. 모든 판정에 스크립트 출력/파일·라인 근거. |

**잔여 축약 바인딩 수(metrics): 0** (residualShortBindings=0·shortCalleeOccurrences=0, 독립 스캔으로 교차확증).

## G2 기준점의 근본원인 + 정당성 (verifier 독립 검증)

### 사실: raw 원본은 파싱 불가(절단 번들 슬라이스)
`03_deobfuscated/deob_07_app_components.js`는 앞부분이 잘린 번들 슬라이스다. 첫 실 코드행(105)이 orphan `}),`로 시작하고 매칭 여는 토큰이 파일 안에 없어 브래킷 불균형 → 어떤 파서도 유효 AST를 만들 수 없다.

```bash
RCD_NM=/Users/innojini/Dev/HuniWeb/docs/reversing/red_reverse_engineer/05_readable/_tooling/node_modules \
  node /Users/innojini/Dev/HuniWeb/.claude/skills/rcd-equivalence-verify/scripts/parse-check.cjs \
  /Users/innojini/Dev/HuniWeb/docs/reversing/red_reverse_engineer/03_deobfuscated/deob_07_app_components.js
# => FAIL ... node=...:105 | babel=Unexpected token (105:10)  (exit 1)
```

### 정당성: recovered.js를 G2 `--a`로 쓰는 것이 옳다(verifier가 직접 확인)
cartographer가 절단부를 **합성 HEAD(`const __recoveredApparelPrintAreaSetup = defineComponent({ setup(){ … computed(() => {`)+합성 TAIL(`))))))`)** 로 복원한 `*.recovered.js`(2636행)를 공급했고, 가독본은 이 recovered.js에서 파생되므로 합성 scaffold를 그대로 포함한다. verifier가 직접 확인:
- **원본 본문(line 105~)이 recovered.js 안에 verbatim 존재** — anchor `directPrintAreaNames = computed(() => {` 기준 4000자 윈도우 `rec.includes(win)=true`, 실 동작 로직 `areaOption.COD === "CL011"` 등 verbatim. 즉 recovery는 **실 코드를 변경하지 않고** 선두/말미에 명시-표식된(`SYNTHETIC TRUNCATION-RECOVERY WRAPPER`) scaffold만 추가.
- 동일 scaffold가 가독본 말미(line 4859~4865 `SYNTHETIC TAIL` 주석 + 닫힘 괄호)·선두(`__recoveredApparelPrintAreaSetup`)에 그대로 보존 → recovered.js↔가독본 비교 시 scaffold가 양쪽에 동일하게 존재 → **rename/comment/format만이 유일한 delta**로 격리됨 = 복원 가능한 본문의 동작 보존이 증명됨.
- raw 원본을 `--a`로 쓰면 (i) 파싱 불가 (ii) scaffold 부재로 거짓 불일치 → recovered.js 기준이 정당.

```bash
RCD_NM=.../_tooling/node_modules node .../ast-structural-diff.cjs \
  --a .../03_deobfuscated/deob_07_app_components.recovered.js \
  --b .../05_readable/02_readable/deob_07_app_components.js \
  --report .../05_readable/03_verify/deob_07_app_components.js.structdiff.json
# => pass=true struct=true props=true literals=true (exit 0)
```

## 잔여/문서화 대상 (결함 아님 — routing)
- **rename 0건은 정상.** rename-map 172개 엔트리가 전부 `preserve:true` self-map(to===from)이다 — 이 슬라이스의 식별자는 이미 의미 보존된 도메인/API 계약 코드(PDT_CD·COD·KOI_NME 등)이거나 deob_06 canonical 컴포넌트명이라 리네임 대상이 없다. 가독성 향상은 ① 주석/JSDoc 주입 26건 ② prettier 포매팅(콤마체인·삼항 해소, 2607→4865행)에서 나온다. G4 free-ref 잔여 0이므로 "조건부 GO"가 아니라 **정식 GO**.
- **입력 truncation은 cartographer 트랙의 입력-provenance 문서화 대상**(engineer/map 결함 아님). 가독본 선두 컴포넌트(ApparelPrintArea)의 setup 머리는 합성 복원본이며 **RedPrinting 원본 코드가 아니다**. 다운스트림(doc-author)은 `__recoveredApparelPrintAreaSetup` 블록을 "절단 복원 scaffold(원본 아님)"로 명시 취급해야 한다 — 이 블록의 본문 식별자/구조는 무의미하며 동작 무관.

## routing
- **cartographer (맵/입력 provenance)**: recovered.js 합성 scaffold의 출처·범위가 comment-map(anchor `line:97`)·recovered.js 주석에 표식됨 — 유지. 향후 full-bundle 재추출로 비절단 deob를 확보하면 raw 원본 기준 G2 재실행 권장(현재는 recovered.js 기준이 최선이자 정당). 절단된 첫 컴포넌트는 "복원 scaffold" 라벨을 doc-author로 전달.
- **engineer (스크립트/적용)**: 추가 조치 불요. applied=0(전부 preserve)·주석26·prettier만. 스크립트/맵 수정 불요.
- **doc-author**: 본 파일 GO → 문서화 대상. 단 합성 scaffold(`__recoveredApparelPrintAreaSetup`)는 원본 아님으로 명시.

## 재현 명령 전체
```bash
NM=/Users/innojini/Dev/HuniWeb/docs/reversing/red_reverse_engineer/05_readable/_tooling/node_modules
SK=/Users/innojini/Dev/HuniWeb/.claude/skills/rcd-equivalence-verify/scripts
BASE=/Users/innojini/Dev/HuniWeb/docs/reversing/red_reverse_engineer
B=$BASE/05_readable/02_readable/deob_07_app_components.js
AREC=$BASE/03_deobfuscated/deob_07_app_components.recovered.js
CART=$BASE/05_readable/01_cartography/deob_07_app_components.js
V=$BASE/05_readable/03_verify
# G1
RCD_NM=$NM node $SK/parse-check.cjs $B
# G2
RCD_NM=$NM node $SK/ast-structural-diff.cjs --a $AREC --b $B --report $V/deob_07_app_components.js.structdiff.json
# G4
RCD_NM=$NM node $SK/readability-metrics.cjs --in $B --preserve $CART/rename-map.json --thirdparty $CART/thirdparty-ranges.json --report $V/deob_07_app_components.js.metrics.json
# G5 (preserve verbatim grep) / G4 독립 교차 (NODE_PATH=$NM node babel scan) — 본문 참조
```
