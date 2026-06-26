# verdict — deob_07_app_components.js (독립 검증 게이트 · attempt 2 재실측)

**판정: NO-GO** (G4 가독성 FAIL · 단일 FAIL=NO-GO)

검증 레인은 engineer 로그·직전 verdict를 **신뢰하지 않고** 아래 스크립트를 모두 절대경로 + `RCD_NM` prefix로 **직접 재실측**했다(G6).

## ★이번 핵심 변경 (사용자 directive)
- G2 `--a`를 **합성 recovered.js가 아니라 비절단 `03_deobfuscated/deob_07_app_components.full.js`(186,128 byte·`parse-check.cjs` → `OK` exit 0=실제 파싱가능)** 로 사용했다. 합성 HEAD/TAIL 래퍼 없는 **진짜 동등성**.
- 그 결과 **G2 = 합성 래퍼 제거·비절단 full.js 기준 정식 GO**.
- 단, 가독본(`02_readable/deob_07_app_components.js`·344,243 byte·mtime Jun26 10:55)은 리네임이 거의 미적용 → **G4 NO-GO**. G2(동작 보존)는 진짜로 통과하나 G4(가독화)는 미달.

## G1~G6 게이트 표 (직접 재실측)

| 게이트 | 결과 | 근거 (직접 재실측) |
|--------|------|-------------------|
| G1 구문 유효 | **GO** | `parse-check.cjs 02_readable/…js` → `OK`(exit 0) · `parse-check.cjs …/full.js` → `OK`(exit 0) |
| G2 구조동등(동작보존) | **GO (정식·합성 래퍼 제거·비절단 full.js 기준)** | `ast-structural-diff.cjs --a …/deob_07_app_components.full.js --b 02_readable/…js` → `pass=true struct=true props=true literals=true`(exit 0). structSigLenA==structSigLenB=**1,051,111**. propertyNameDiff=**null**·literalDiff=**null** |
| G3 서드파티 | **GO (N/A)** | 위젯 파일·서드파티 물리 분리 0건(in-place fold). thirdparty-ranges 비어 있음 → 자동 충족 |
| G4 가독성 | **NO-GO** | `readability-metrics.cjs` → `residualShortBindings=1421 shortCalleeOccurrences=126 pass=false`. 목표=0 |
| G4b 역할-범주 기계명 | (참고) mechanical=0·fullySemantic=true | `g4b_mechanicalRoleNames=0`(distinct 0). 단 리네임 자체가 거의 미적용이라 "기계명조차 안 생김"으로 공허한 0 |
| G5 preserve 불변 | **GO** | 도메인/API 계약 코드 본문 존재·0 missing. grep: PDT_CD=5·MTRL_CD=59·PRN_CNT=23·PRICE=1·DIV_SEQ=8·ESN_YN=11·VIEW_YN=8 |
| G6 독립성 | **GO** | engineer 로그·직전 verdict 미사용·스크립트 직접 재실행. 가독본 mtime(Jun26 10:55)으로 재생성 독립 확인 |

## ★G2 결론 (사용자 핵심 질의)
**합성 래퍼 제거·비절단 full.js 기준 정식 GO.** 가독본은 비절단 원본(`deob_07_app_components.full.js`)과 AST 구조·프로퍼티명 멀티셋·리터럴 멀티셋이 **완전 일치**(structSig 1,051,111 == 1,051,111·propertyNameDiff null·literalDiff null). **동작 보존은 진짜로 증명됨** — 노드 추가/삭제/재배열·프로퍼티명 변경·리터럴(한국어 라벨·경로·코드값) 변경 없음. 리네임/주석/포매팅만이 delta. 직전 세션의 합성 recovered.js 의혹은 비절단 실파싱 파일로 교체되어 해소됨.

## NO-GO 사유 (G4 — 가독화 미달, 동작/계약과는 무관)
가독본은 "디옵 코드 + 주석 일부"일 뿐 **식별자 리네임이 거의 미적용**.
- 잔여 1~2자 바인딩 **1,421개**: `h`(65)·`p`(65)·`a`(63)·`l`(63)·`f`(61)·`u`(59)·`O`(45)·`N`(41)·`ue`/`me`/`_e` 등 난독 원명 잔존.
- 1~2자 callee 호출 **126회**(헤더-only 매핑 잔재 의심): `o()`(65)·`p()`(8)·`u()`(7)·`m()`(6) 등.
- rename-map(469개 매핑·도메인 코드 preserve + `ApparelColorSelector`·`accCounterClass`·`bookQtyFlexRowClass` 등 의미 타깃명 정의됨)은 정상이나 **본문 적용이 누락**됨.

## routing
- **engineer (스크립트/적용)**: 본질 결함. rename-map 매핑을 본문에 **재적용**(현재 거의 미적용)·comment 잔여 적용 후 재생성. cartographer 맵은 정상(타깃명 정의됨)·적용 누락이 문제.
- **cartographer (맵)**: 맵 자체는 GO(도메인 코드 preserve·타깃명 존재). 추가 조치 불요.
- **doc-author**: 본 파일 **NO-GO → 문서화 대상 아님**(G4 재실행 GO 후 재대상).

## 재현 명령
```bash
NM=/Users/innojini/Dev/HuniWeb/docs/reversing/red_reverse_engineer/05_readable/_tooling/node_modules
S=/Users/innojini/Dev/HuniWeb/.claude/skills/rcd-equivalence-verify/scripts
R=/Users/innojini/Dev/HuniWeb/docs/reversing/red_reverse_engineer
B=$R/05_readable/02_readable/deob_07_app_components.js
FULL=$R/03_deobfuscated/deob_07_app_components.full.js
V=$R/05_readable/03_verify
CART=$R/05_readable/01_cartography/deob_07_full

# G1
RCD_NM=$NM node $S/parse-check.cjs $B
RCD_NM=$NM node $S/parse-check.cjs $FULL
# G2 (★ --a = 비절단 full.js)
RCD_NM=$NM node $S/ast-structural-diff.cjs --a $FULL --b $B --report $V/deob_07_app_components.js.structdiff.json
# G4/G4b
RCD_NM=$NM node $S/readability-metrics.cjs --in $B --preserve $CART/rename-map.json --report $V/deob_07_app_components.js.metrics.json
# G5 (도메인 코드 보존)
grep -c '\bPDT_CD\b' $B; grep -c '\bMTRL_CD\b' $B; grep -c '\bPRICE\b' $B
```
