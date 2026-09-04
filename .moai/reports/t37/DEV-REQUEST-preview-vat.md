# DEV-REQUEST — 빌더 미리보기 부가세 미포함 (표시 오류 · 전 상품)

> 카드: t37 · 원본 실측: `.moai/reports/price-defects-260904/FINDINGS.md` §결함2 (리드 세션 260904 실측, 재조사 없이 그대로 인용)
> 이 결함은 전부 코드(가격뷰어/빌더/렌더러) 수정 사항 — 가격구성요소로는 해결 불가. 실무진 전달 문서만.

> **상태**: 운영 260904 14:53 실측 재현 안 됨 — 사용자 캡처(그 이전) 이후 배포 반영 추정. 로컬 코드 사본(raw/webadmin) 기준 분석이라 운영본과 차이 가능. 우선순위 Medium→Low(모니터링).
> 근거: 운영 실측(2026-09-04 14:53, 위젯빌더 WGT_000437 나란히·가격진단) — 미리보기·진단 모두 「공급가 50,400 / 부가세(10%) 5,040 / 부가세 포함 55,440」 3단 정상 표시. 캡처 = `reports/sticker-defect-260904/img/06-widget-preview-A6-1000.png` · `07-widget-price-diag-A6-1000.png`.

## 요약
위젯 빌더 미리보기 가격 요약이 공급가를 "부가세 포함 N원"으로 표기하지만, 실제로는 공급가/부가세(10%) 분해가 이뤄지지 않은 채 그대로 노출된다. 상품별 과세 여부와 무관하게 **빌더 미리보기 전 상품**에 영향.

## 증상
위젯 빌더 미리보기 가격 요약이 공급가를 "부가세 포함 N원" 으로 표기. 공급가/부가세(10%) 분해행 없음.

## 코드 근거
- 임베드(고객) 경로: `widget_api.py:2122` `_filter_single` → `_settle(charged)` → `supply/vat/total_with_vat` **✅ 정상**
- 빌더 미리보기 경로: `price_views.py:3740` `price_simulate` / `price_views.py:3867` `price_simulate_set` → **VAT 필드 없음** (grand_total=공급가까지)
- 어댑터 `widget_builder.html:4059` `builderPrice` 반환에 `supply/vat` 키 없음(단일·셋트 두 분기 모두)
- 렌더러 `widget_renderer.js:5321` `norm.vat != null` 일 때만 분해행 표시 · `widget_renderer.js:5341` 캡션 `부가세 포함` 은 **무조건** 출력
- 부가세 정산 함수는 `pricing.py:108` `settle_with_vat` 에 **이미 존재** — 재사용 가능, 신규 계산 로직 불필요
- 상품별 과세 플래그(vat_yn/tax_free) 없음 → 스티커 전용이 아니라 **빌더 미리보기 전 상품**에 해당하는 표시 오류

## 정량 영향
표시 오류(계산 오류 아님) — 공급가를 부가세 포함가인 것처럼 보여주므로, 고객이 실제 청구 총액보다 낮은 금액을 보게 될 가능성. 실제 임베드(고객 주문) 화면은 정상(`widget_api.py:2122` 경로) — 영향은 **운영자/빌더 미리보기 화면**으로 한정.

## 제안 수정안
① `price_simulate` / `price_simulate_set` (price_views.py:3740, 3867) 응답에 `settle_with_vat`(pricing.py:108) 결과 추가
② `builderPrice` 어댑터(widget_builder.html:4059, 단일·셋트 두 분기)가 supply/vat 값을 그대로 전달하도록 수정
③ 렌더러 캡션(widget_renderer.js:5341) 조건부 처리 — `norm.vat` 없을 때 "부가세 별도" 등으로 폴백, 무조건 "부가세 포함" 출력 금지

## 우선순위 / 긴급도
**Medium** — 실제 청구/결제 금액에는 영향 없음(고객 임베드 경로는 정상). 다만 운영자가 빌더 미리보기에서 오인할 수 있어 운영 신뢰도 문제.

## 비고
- 미검증: 실제 임베드 화면 실측은 하지 않음(코드 리딩상 정상 판단, 리드 세션 원문 기재). 착수 전 webadmin 실화면 재확인 권장.
- 가격구성요소(t_prc_price_components / t_prc_component_prices) 레인이 처리할 수 있는 부분 없음 — 전체가 코드 수정 대상.
