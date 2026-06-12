# Axis Pack — widget-contract (위젯 정규화 계약)

> 핵심 [HARD]: 위젯은 DB가 아닌 **정규화 계약**에 의존(메모리 huni-widget-conversion-strategy). RedPrinting 역공학값은 tier D 후보 — 후니 가격과 정합·이식 금지(메모리 huni-widget-price-strategy). 위젯 PRICE=0 불가(메모리 huni-widget-red-price-never-zero).

## 정답 소스

| 항목 | 정답 소스(file:§) | tier | freshness |
|------|-------------------|------|-----------|
| 정규화 데이터 계약 | `huni-widget/03_spec/data-contract.md`·`api-contract.md` | D | FRESH |
| 후니 어댑터(무손실 컨버전 경계) | `huni-widget/03_spec/data-adapter.md`·`huni-db-mapping.md` | D | PARTIAL-STALE(라이브 스키마 변경 미반영 가능) |
| 14 componentType↔shadcn 매핑 | `huni-widget/03_spec/componenttype-mapping-matrix.md`·`component-tree.md` + `print-quote/04_design/DESIGN.md` | D | FRESH |
| 가격엔진(서버권위+클라캐싱) | `huni-widget/03_spec/price-engine.md`·`01_reverse/price-engine-reversed.md` | D | FRESH(후보·후니 정합 금지) |
| 옵션 캐스케이드(Zustand) | `huni-widget/03_spec/state-management.md`·`02_analysis/event-contract.md` | D | FRESH |
| Edicus postMessage 브리지 | `huni-widget/03_spec/editor-integration.md` | D | FRESH |
| family별 위젯 스펙(아크릴·굿즈파우치·캘린더) | `huni-widget/03_spec/{s4-acryl,s5-goods-pouch,s6-calendar}-spec.md` | D | FRESH |
| 동등성 검증(Red parity) | `huni-widget/07_parity/parity-matrix-*.md` | D | FRESH |
| admin product-viewer UI ground-truth(componentType↔t_prd_product_*) | `10_configurator/live-admin-groundtruth.md` + 메모리 dbmap-live-admin-product-viewer | A | FRESH |

## 보조 소스

- `print-quote/04_design/screen-inventory.md`·`DESIGN.md` — 화면설계·14 컴포넌트. tier D FRESH.
- huni-design-system 스킬(Figma 14 컴포넌트·26 섹션) — 시각 권위. FRESH.
- 메모리 huni-widget-equivalence-gate-go(4차원×4모델 동등 입증)·huni-widget-expansion-strategy(7-stage·위젯코어 불변). FRESH.

## stale 함정

1. **Red 역공학 가격값을 후니 사실로 인용 금지(메모리 huni-widget-price-strategy).** 분석용만. 후니 가격은 axis-price-engine 권위.
2. **`huni-db-mapping.md`/`data-adapter.md`의 후니 t_* 매핑 — PARTIAL-STALE.** 라이브 스키마 변경(I-1·I-4·I-5·I-6) 미반영 가능. 어댑터 매핑 인용 시 라이브 스키마 대조.
3. **위젯 ATTB 권위 날조 이력(메모리 huni-widget-code-parity-done).** G-1 ATTB=orderQty 권위 날조 적발 전례 — 인용 소스라인 실재성 확인.

## 미해결 GAP

- 후니 DB 미정 → 어댑터 교체 시점 미확정(정규화 계약 의존으로 회피). [GAP-WID-1]
- 장바구니/주문 = Shopby 제외, 정규화 계약 경계+백엔드 미정(메모리 shopby-excluded). [GAP-WID-2]
- 위젯 전체상품 확대(7-stage) 중 일부 family만 스펙 존재(아크릴·굿즈파우치·캘린더). 나머지 family 위젯계약은 데이터계약 일반형 + DB매핑으로 도출. [GAP-WID-3]
