# engineer-log — deob_05_app_api.js (생성/변환 레인)

엔지니어: rcd-readability-engineer · 변환 방법: rcd-ast-deobfuscate (AST 바인딩 단위, 텍스트 치환 0)

## 1. 실행 요약

| 항목 | 값 |
|---|---|
| 입력 | `03_deobfuscated/deob_05_app_api.js` (54,431 B) |
| 산출 | `05_readable/02_readable/deob_05_app_api.js` (58,562 B) |
| rename applied | **0** |
| rename skipped | **0** (scope-mismatch 0건) |
| 서드파티 fold | **미실행** (thirdparty-ranges.json = `[]` — 위젯 파일·서드파티 블록 없음) |
| 자가 점검 (`node --check`) | **OK** |
| 자가 점검 (`parse-check.cjs`) | **OK** (exit 0) |

## 2. applied=0 / skipped=0 의 의미 — 결함 아님

- rename-map.json의 **36개 엔트리가 전부 `preserve:true`** 이며 `to === orig`(identity)다. 도메인/API 계약 식별자(PDT_CD·MTRL_CD·PRICE·COD·ORD_INFO·PCS_INFO·retCode·price_gbn 등)로, [HARD] 불변 대상.
- 스크립트가 `preserve:true`(line 94)와 `to===orig`(line 95)를 정상적으로 건너뜀 → applied=0은 **올바른 동작**.
- skipped 0건 = scope-mismatch로 누락된 식별자 없음. **cartographer scope 보강 불필요.**
- 즉 이 파일의 변환 가치는 **리네임이 아니라 ① 주석(JSDoc/배너) 주입 ② prettier 재포매팅**에 있다.

## 3. 주석 주입 결과 (comment-map 15 anchor)

식별자명 anchor(JSDoc 13건)는 디옵 산출물이 **이미 사람이 읽는 함수명**(extractDefaultExport·getNative·fetchProductInfo·fetchPriceCalculation 등)을 갖고 있어 declarator-name 매칭으로 전부 착지:

- ✅ JSDoc 13/13 착지: extractDefaultExport·getIsObject·getRootObject·getBaseGetTag·getNative·initDebounce·initIsEmpty·fetchProductInfo·fetchPriceCalculation·fetchS3FileInfo·fetchAvailableMaterials·downloadTemplate·downloadCoverTemplatePdf.
- ✅ section-banner `line:1`(파일 헤더) 착지 (원본 헤더와 정합).
- ✅ section-banner `line:1295` TRANSLATIONS_EN 착지.
- ⚠️ section-banner `line:1498` TRANSLATIONS_KO **미착지(0)** — comment-map 본문이 명시하듯 KO 사전은 디옵 산출물에서 생략(TODO)되어 미포함. 매칭 대상 식별자/라인 없음 → **정상**(결함 아님).

### 스크립트 한계 1건 (cartographer/스크립트 참고)
- `apply-rename-map.cjs`의 주석 주입기는 **식별자명 anchor(function/class/var-declarator)만** 매칭한다. `line:N` 형식 anchor는 매칭 경로가 없다. 이번엔 `line:1`/`line:1295`가 우연히 동일 위치의 식별자/기존 주석과 정합해 결과적으로 모두 반영됐고 `line:1498`만 원천 부재로 빠졌으므로 **실손실 0**. 다만 향후 `line:N` 배너를 확정 착지시키려면 스크립트에 line-anchor 주입 분기 추가가 필요(현 세션 산출엔 영향 없어 미보강).

## 4. 동작 보존 확인
- 텍스트 치환 0 · AST scope.rename 0회(리네임 대상 자체가 preserve-only) · 문자열 리터럴(한국어 라벨·API 경로) 불변 · 프로퍼티명 불변.
- 변경분은 주석 + prettier 포매팅(공백/줄바꿈)뿐 → 실행 동등 유지.

## 5. verifier 인계
- 산출 `.js` parse OK. 구조/동등성 게이트(ast-structural-diff·readability-metrics)는 verifier 레인에서.
- 맵 재작업 불요(scope-mismatch 0). `line:N` 배너 정밀 착지를 게이트가 요구하면 스크립트 line-anchor 분기 보강으로 대응.
