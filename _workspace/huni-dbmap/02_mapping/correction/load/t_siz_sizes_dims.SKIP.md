# t_siz_sizes 치수 정정 — 적재 불요 (NO-LOAD)

> [BLOCKER 해소] validator 라이브 DB read-only 검증 결과, `t_siz_sizes`의 work/cut 치수(`numeric(8,2)`)는 **이미 77/77 채워져 있다(NOT NULL)**. 따라서 치수 정정 CSV는 **적재 대상에서 제외**한다.

## 왜 적재하지 않는가 (라이브 DB 권위)

- **75행 무의미**: 라이브 치수가 이미 우리 파싱값과 동일 → 적재해도 무변경.
- **cm 2건 회귀 위험**: SIZ_000399/402(피크닉매트)는 라이브가 mm 환산값(1000/700·1000/1500)을 이미 보유. 우리 CSV의 원본 cm 보존값(100/70·100/150)을 적재하면 라이브 정확값을 **틀린 값으로 회귀**시킴 → 절대 적재 금지.
- 근거: `03_validation/product-viewer/correction-validation-report.md` §3·§4 포인트4·§5.

## stale 경고

1단계에서 본 `00_schema/ref-sizes.csv`(2026-06-04 17:13 추출)의 "work/cut 전부 NULL"은 **stale 스냅샷**이었다. 직전 D-C에서 후니가 치수를 등록한 것이 라이브에 반영됐으나 추출본만 옛 상태. **권위 = 라이브 DB > 추출 시트.**

## 추적용 파일

파싱 분리값은 `t_siz_sizes_dims.reference.csv`에 보존(삭제 금지, 적재 아님). 81건 명칭→치수 분해 과정 추적용. 그 파일 상단 주석에 cm 2건 회귀 경고 명기.

## 결론

- 치수축 정정: **불요**(라이브 기존 반영).
- 실제 정정 성과 = **묶음수 18행 분리**(`t_prd_product_bundle_qtys.csv`, GO).
- cm 표기 사이즈명 정돈은 후니 영역(`huni-source-fix-request.md` 참조).
