# engineer-log — deob_06_app_widget_sdk.js (생성/변환 레인)

## 입력
- source: `03_deobfuscated/deob_06_app_widget_sdk.js` (1392줄, 53,970 bytes)
- rename-map: `01_cartography/deob_06_app_widget_sdk.js/rename-map.json` (preserve-only · 도메인/API 계약 가드 30종)
- comment-map: `01_cartography/deob_06_app_widget_sdk.js/comment-map.json`
- thirdparty-ranges: 해당 없음 (위젯 파일 — 서드파티 fold 불필요, fold-thirdparty 미실행)

## 적용 요약 (apply-rename-map.cjs · AST 스코프 안전 · 텍스트 치환 0)
- **applied = 0 · skipped = 0**
  - rename-map은 cartographer 판정상 `renamable_bindings_remaining: 0`의 **preserve-only 맵** —
    본문 164개 바인딩이 이미 의미식별자이고, 잔여 단문자 리네임 대상이 본문에 미존재(이미 적용/free-ref).
  - 30종 preserve 식별자(PDT_CD·MTRL_CD·PRICE·COD·CLR_CD·WGT_CD 등 도메인/API 계약)는 자동 제외 → 불변.
- **주석 주입**: comment-map의 anchor 매칭분 leadingComment 주입(jsdoc/section-banner).
- **prettier 재포매팅**: printWidth=100·singleQuote=false 적용 → 인라인 삼항·콤마체인 해소.
  - 결과 1751줄 (입력 1392줄 대비 +359줄, 포매팅 펼침 — 동작 무영향).

## 자가 점검
- `node --check 02_readable/deob_06_app_widget_sdk.js` → **OK** (파싱 성공).
- skipped.json: `{ "applied": 0, "skipped": [] }` — scope-mismatch 0건 (cartographer scope 보강 불요).

## 산출
- `05_readable/02_readable/deob_06_app_widget_sdk.js` (가독 .js · 실행 가능)
- `05_readable/03_verify/deob_06_app_widget_sdk.js.skipped.json`
- `.thirdparty.js`: 없음 (서드파티 범위 없음)

## 비고
- 맵이 preserve-only라 식별자 변환은 0건이나, prettier 포매팅·주석 주입은 정상 적용됨.
- 동작 보존: AST 바인딩 단위만 사용, 텍스트 치환 0, 문자열 리터럴/프로퍼티명/연산자 불변.
