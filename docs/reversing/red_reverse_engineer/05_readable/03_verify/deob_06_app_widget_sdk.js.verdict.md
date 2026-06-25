# verdict — deob_06_app_widget_sdk.js (검증 레인 · 독립 재실측)

- **대상**: `05_readable/02_readable/deob_06_app_widget_sdk.js` (1751줄, 62,022 bytes)
- **원본**: `03_deobfuscated/deob_06_app_widget_sdk.js` (1392줄, 53,970 bytes)
- **판정**: **GO** (G1~G6 전부 GO)
- **검증 레인 원칙**: engineer-log 비신뢰 — 아래 스크립트를 검증자가 직접 재실행해 판정. attempt=1.

## 게이트 표

| 게이트 | 결과 | 근거 (직접 재실측) |
|--------|------|------|
| G1 구문 유효 | **GO** | `parse-check.cjs` → `OK` EXIT=0 (node --check/babel 파싱 성공) |
| G2 AST 구조 동등 (동작 보존) | **GO** | `ast-structural-diff.cjs` → `pass=true struct=true props=true literals=true`. structSigLen A==B==115781, propertyNameDiff=null, literalDiff=null. 구조·프로퍼티명·리터럴 멀티셋 전부 일치 = 리네임/주석/포매팅만 변경(동작 보존). |
| G3 서드파티 무손실 | **N/A → GO** | `thirdparty-ranges.json` = `[]`. 위젯 파일 — 서드파티 블록 없음(fold 미실행). 이동 블록 부재 = 손실 위험 없음. |
| G4 가독성 지표 | **GO** | `readability-metrics.cjs` → `residualBindings=0 shortCallees=0 pass=true`. 본 로직 스코프 잔여 축약 바인딩 0·단문자 callee 0. (cartographer `_meta`: 본문 164 바인딩 이미 의미식별자·renamable_bindings_remaining=0.) |
| G5 preserve 불변 | **GO** | 30종 preserve 식별자 검사. **존재 23종**: 원본↔결과 occurrence 카운트 0 mismatch(예 PRICE 19=19·COD 31=31·MTRL_NM 3=3) — 리네임/가감 없음. **부재 8종**(PDT_CD·PRN_CNT·CVR_MTRL_CD·INN_MTRL_CD·price_gbn·DFT_YN·PTT_CD·CLR_CD): 원본 substr=0·결과 substr=0 — 이 파일에 애초 미존재(stats 출처 cross-file 어휘 가드)이므로 "리네임 소거" 불가. 원본 상태==결과 상태. G2 litsEqual=true가 리터럴 불변을 추가 보증. |
| G6 독립성 | **GO** | engineer-log를 근거로 쓰지 않고 G1·G2·G4 스크립트 직접 실행(EXIT=0)·structdiff.json/metrics.json 리포트 직접 판독·G5 preserve grep 직접 수행(원본·결과 양측). |

## 잔여 / 결함
- **잔여 축약 바인딩**: 0 (metrics.json `residualShortBindings`).
- **결함**: 없음. NO-GO 사유 0건.
- free-ref(리네임 불가) 미해소 헬퍼: 없음 — cartographer 맵이 preserve-only(renamable=0)라 G4 잔여 0과 정합.

## 재현 명령
```bash
NM=/Users/innojini/Dev/HuniWeb/docs/reversing/red_reverse_engineer/05_readable/_tooling/node_modules
SK=/Users/innojini/Dev/HuniWeb/.claude/skills/rcd-equivalence-verify/scripts
R=/Users/innojini/Dev/HuniWeb/docs/reversing/red_reverse_engineer/05_readable
# G1
RCD_NM=$NM node $SK/parse-check.cjs $R/02_readable/deob_06_app_widget_sdk.js
# G2
RCD_NM=$NM node $SK/ast-structural-diff.cjs --a $R/../03_deobfuscated/deob_06_app_widget_sdk.js --b $R/02_readable/deob_06_app_widget_sdk.js --report $R/03_verify/deob_06_app_widget_sdk.js.structdiff.json
# G4
RCD_NM=$NM node $SK/readability-metrics.cjs --in $R/02_readable/deob_06_app_widget_sdk.js --preserve $R/01_cartography/deob_06_app_widget_sdk.js/rename-map.json --thirdparty $R/01_cartography/deob_06_app_widget_sdk.js/thirdparty-ranges.json --report $R/03_verify/deob_06_app_widget_sdk.js.metrics.json
# G5 (preserve 카운트 원본 vs 결과)
for id in PRICE COD MTRL_NM ...; do echo "$id src=$(grep -o $id $R/../03_deobfuscated/deob_06_app_widget_sdk.js|wc -l) out=$(grep -o $id $R/02_readable/deob_06_app_widget_sdk.js|wc -l)"; done
```

## routing
- **결함 없음 → 라우팅 불요.** doc-author로 GO 파일 전달 가능.
- (참고·비결함) cartographer 맵이 preserve-only(8종은 이 파일에 미존재하는 cross-file 어휘 가드). 향후 맵 정밀화 시 파일별 실재 preserve만 등재하면 G5 grep 노이즈 감소 — 단 현 판정에는 영향 없음(엄밀히는 cartographer 맵 보강 영역).
