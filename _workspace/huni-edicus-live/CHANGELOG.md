# huni-edicus-live — 변경 이력

(최신이 위)

## 2026-08-19 · private_css 를 색 전용으로 재정립 + 레드프린팅 2상품 실측

- **경계 확정**: `RedEditorSDK.min.js` 를 받아 뜯어 private_css 가 SDK deferred param 5개 중
  하나이고 CSS 문자열 하나만 전달됨을 확인. 순정 `theme-*` 86개 중 70개가 색 속성만 정의.
- **빌더에 경계 검사 도입**: `build-theme.py` 가 순정에 없는 속성을 쓰면 빌드 실패(exit 1).
  검사가 실제로 무는지 시험 — `letter-spacing`·`border-radius`·`display`·`padding` 전부 차단 확인.
- **되돌린 것**: 자간 5건, 모서리 6건 (레이아웃을 미는 속성).
- **제거한 것**: 로고 주입. `.theme-header-logo` 는 실측 DOM 에 노드가 0개인 미렌더 슬롯이었다.
  인라인 base64 4,204자 × 3파일(≈12.6KB) 제거 → 허용 예외 0건.
- **토큰 교체**: 스킬 문서 표 → 실제 DS 패키지
  (`docs/design/11가지상품옵션/_ds/huni-printing-design-system-…/tokens/`).
  이름도 DS 것 그대로(`--color-brand` 등). primary `#5538B6` 확정, `--color-error #E60012` 신규 반영.
- **커버리지**: 덮어쓴 theme-* 25개 → **A안 56개 / B안 27개**. 모달·다이얼로그·셀렉트박스 신규 매핑
  (안 하면 편집 중 팝업만 파랗게 뜬다). A안용 흰글씨 뒤집기 12건 추가.
- **캡처**: `capture-rp.py` 신설(scrapling 0.4.14, 읽기전용). ACTHPEN·CLSTDLD 실측 →
  두 상품의 Edicus 플래그가 동일함을 확인(= 화면 차이는 Edicus 쪽 파라미터 소관).
- **미리보기**: 지어낸 편집기 목업 2장 폐기 → 실측 근거 시트 2장(색 매핑 / 경계)으로 교체.

## 2026-08-18 · RedPrinting 라이브 캡처

- `FINDINGS.md`(320줄) 작성. run_mode passive 오설정(G0) 발견 외 12개 갭 정리.
- `raw/` 원자료 수집, `edicus-huni-theme.css` 초안, `theme-compare/` A·B안.
