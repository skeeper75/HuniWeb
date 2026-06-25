# Verdict — deob_05_app_api.js (RCD 동등성·가독성 게이트)

- **파일:** `05_readable/02_readable/deob_05_app_api.js`
- **원본:** `03_deobfuscated/deob_05_app_api.js`
- **검증 레인:** rcd-equivalence-verifier (생성자 주장 비신뢰 · 스크립트 직접 재실측)
- **시도:** attempt=1
- **종합 판정: GO**

## 게이트 표 (G1~G6)

| 게이트 | 결과 | 근거 (직접 재실측) |
|--------|------|--------------------|
| G1 구문 유효 | **GO** | `parse-check.cjs` → `OK ...deob_05_app_api.js` (exit 0) |
| G2 AST 구조 동등 | **GO** | `ast-structural-diff.cjs` → `pass=true struct=true props=true literals=true`. structdiff.json: structSigLenA=structSigLenB=143725(바이트 동일)·propertyNameDiff=null·literalDiff=null. = 리네임/주석/포매팅만 변경(동작 보존) |
| G3 서드파티 무손실 | **GO (N/A)** | `thirdparty-ranges.json`=`[]` (서드파티 분리 블록 없음 — in-place 유지). 프롬프트 지시대로 N/A→GO |
| G4 가독성 지표 | **GO** | `readability-metrics.cjs` → `residualBindings=0 shortCallees=0 pass=true`. 단일문자 callee 잔여 스캔(`\b[a-zA-Z]\(`)=0건 |
| G5 preserve 불변 | **GO** | 워드바운더리 대조: rename-map의 preserve 식별자 37개 중 **원본에 실재하는 9개 전부 readable에 보존**(아래 표). 위반(렌네임)=0 |
| G6 독립성 | **GO** | engineer-log 미참조. 위 4 스크립트를 절대경로·RCD_NM prefix로 직접 실행·report JSON 직접 Read·preserve를 직접 grep 대조 |

## G2 상세 (structdiff.json)
```
pass=true  structEqual=true  propsEqual=true  litsEqual=true
structSigLenA=143725  structSigLenB=143725  (동일)
propertyNameDiff=null  literalDiff=null
```
구조 시그니처 바이트 동일 → 노드 추가/삭제/재배열 없음. 프로퍼티명 멀티셋·리터럴 멀티셋(한국어 라벨·경로·상수) 불변. 라인 수 1507→1695(+188)는 **순수 추가 주석(헤더 배너 등) + 포매팅**으로 설명되며 AST 시그니처 불변과 정합.

## G5 상세 — preserve 식별자 워드바운더리 재실측
원본에 **실재하는** preserve 식별자(9개) 전수 보존 확인(read 카운트가 orig 이상인 것은 cartographer가 추가한 필드명 참조 주석 때문 — 렌네임 아님):

| 식별자 | orig | read | 판정 |
|--------|------|------|------|
| mb_cust_cod | 1 | 2 | PRESERVED-OK |
| price_gbn | 1 | 2 | PRESERVED-OK |
| retCode | 2 | 4 | PRESERVED-OK |
| pdt_cod | 5 | 6 | PRESERVED-OK |
| ptt_cod | 1 | 2 | PRESERVED-OK |
| PDT_COD | 2 | 3 | PRESERVED-OK |
| PTT_COD | 3 | 4 | PRESERVED-OK |
| ORD_INFO | 1 | 2 | PRESERVED-OK |
| PCS_INFO | 1 | 2 | PRESERVED-OK |

위반(orig>0 & read=0)=**0건**.

## 결함 보드 (NO-GO 사유) — 없음
종합 GO. 동작 보존(G2 바이트 동일 시그니처)·가독화(G4 잔여 0)·preserve 불변(G5 위반 0) 전부 입증.

## 비차단 관측 — cartography 맵 위생 (routing → cartographer)
rename-map.json의 preserve 식별자 37개 중 **28개**(PDT_CD·MTRL_CD·PRN_CNT·CUT_WDT·CUT_HGH·WRK_WDT·WRK_HGH·CVR_MTRL_CD·INN_MTRL_CD·PCS_COD·PCS_DTL_COD·PRICE·PRICE_VAT·PRICE_MALL·ORG_PRICE·COD·COD_NME·DIV_SEQ·DIV_NM·DFT_YN·ESN_YN·VIEW_YN·PTT_CD·PTT_NM·WGT_CD·CLR_CD·MTRL_NM·MTRL_TYPE)는 **이 파일 원본에 실재하지 않음**(orig 워드바운더리 카운트=0). 프로젝트 전역 API 필드 사전을 preserve-list로 선적재한 것으로 보임 — 이 모듈은 그 부분집합만 사용. 실재하지 않는 식별자는 "렌네임으로 사라질 수 없으므로" G5 위반이 아니며 판정에 영향 없음. 다만 **cartographer가 파일별 preserve-list를 실사용 토큰으로 좁히면** G5 grep 노이즈가 사라짐(맵 정밀화 권고, 비차단).

## 재현 명령 (RCD_NM·절대경로)
```bash
NM=/Users/innojini/Dev/HuniWeb/docs/reversing/red_reverse_engineer/05_readable/_tooling/node_modules
S=/Users/innojini/Dev/HuniWeb/.claude/skills/rcd-equivalence-verify/scripts
R=/Users/innojini/Dev/HuniWeb/docs/reversing/red_reverse_engineer/05_readable

# G1
RCD_NM=$NM node $S/parse-check.cjs $R/02_readable/deob_05_app_api.js
# G2
RCD_NM=$NM node $S/ast-structural-diff.cjs \
  --a /Users/innojini/Dev/HuniWeb/docs/reversing/red_reverse_engineer/03_deobfuscated/deob_05_app_api.js \
  --b $R/02_readable/deob_05_app_api.js \
  --report $R/03_verify/deob_05_app_api.js.structdiff.json
# G4
RCD_NM=$NM node $S/readability-metrics.cjs --in $R/02_readable/deob_05_app_api.js \
  --preserve $R/01_cartography/deob_05_app_api.js/rename-map.json \
  --thirdparty $R/01_cartography/deob_05_app_api.js/thirdparty-ranges.json \
  --report $R/03_verify/deob_05_app_api.js.metrics.json
# G5 (워드바운더리 preserve 대조)
for id in mb_cust_cod price_gbn retCode pdt_cod ptt_cod PDT_COD PTT_COD ORD_INFO PCS_INFO; do
  echo "$id orig=$(grep -o "\b$id\b" $R/../03_deobfuscated/deob_05_app_api.js|wc -l) read=$(grep -o "\b$id\b" $R/02_readable/deob_05_app_api.js|wc -l)"
done
```
