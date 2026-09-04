# t37 — 가격결함 3건 실무진 전달 문서 (DEV-REQUEST 3종)

> Class B (코드·DB 쓰기 0) · 입력: `.moai/reports/price-defects-260904/FINDINGS.md` (리드 세션 260904 실측, 재조사 없이 그대로 인용)
> 브랜치: `WT-price-dev-requests` (워크트리 t37)

## 문서 목록

| 결함 | 문서 | 유형 | 정량 영향 | 우선순위 |
|---|---|---|---|---|
| 1. 스티커 판형환산 누락 | [DEV-REQUEST-sticker-plate.md](DEV-REQUEST-sticker-plate.md) | 실무진 등록 작업(판형/사이즈 정비) + 가격구성요소(use_dims) | 과다청구 최대 6.3배 | High |
| 2. 빌더 미리보기 부가세 미포함 | [DEV-REQUEST-preview-vat.md](DEV-REQUEST-preview-vat.md) | 코드 수정(price_views.py/widget_builder.html/widget_renderer.js) | 표시 오류(전 상품, 청구액 영향 없음) | Medium |
| 3. 현수막 부자재 미청구 | [DEV-REQUEST-placard-optgrp.md](DEV-REQUEST-placard-optgrp.md) | 코드 수정(widget_renderer.js/pricing.py/widget_api.py) | 과소청구 3,000~8,000원/건 | High |

## 공통 제약
- 가격구성요소(`t_prc_price_components` / `t_prc_component_prices`)만 수정 가능한 레인이 작성 — 코드/DB 스키마 변경이 필요한 항목은 위 문서로 실무진에 전달.
- 결함1은 순서 의존성 있음(판형 등록 선행 필수 — 문서 내 ⚠ 참조).
- 결함3은 기존 카드 **t35**(opt_grp 다중 스코프)와 별건(문서 내 명시) — 단, 동일 파일을 건드리므로 착수 순서 조율 권장.
