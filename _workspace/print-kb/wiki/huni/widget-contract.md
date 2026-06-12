# 위젯 계약 (Widget Contract) — 횡단 축

> huni 레이어(분석대상). 위젯 계약 필드·어댑터 경계를 원자 항목으로 분리해 레시피가 `mapped-to`로 조립한다.
> **[HARD] 위젯은 DB가 아닌 정규화 계약에 의존한다.** RedPrinting 역공학값은 tier D 후보 — 후니 가격과 정합·이식 금지. 위젯 PRICE=0은 불가(우리측 결함 신호).
> 앵커: DB 외 — `huni-widget/03_spec/` 정규화 계약(어댑터 경계에서 t_*로 매핑). DB 외 앵커임을 명시.
> 큐레이션 팩: `_curation/axis-widget-contract.md`.

---

## 1. 계약·어댑터 경계

### [WID-001] 정규화 데이터 계약 (위젯은 DB 아닌 계약에 의존)  {⚪ 명세}
- 내용: 위젯은 후니 DB 스키마에 직접 의존하지 않고 **정규화 데이터 계약**(상품·옵션·가격의 안정 shape)에 의존한다. 후니 DB가 미정이어도 위젯은 계약으로 구현·검증 가능. DB 확정 시 어댑터만 교체([WID-002]) → 위젯 코드 불변(무손실 컨버전).
- 앵커: DB 외 — `huni-widget/03_spec/data-contract.md`·`api-contract.md`
- 출처: `huni-widget/03_spec/data-contract.md`·`api-contract.md` + 메모리 `huni-widget-conversion-strategy` {tier D, FRESH}
- 연결: [[#WID-002]] (mapped-to — 어댑터 경계) · [[../base/...]] _(보편 없음 — 후니 구현 명세)_
- 사용처: [[recipes/booklet#BK-WID-001]] (책자 정규화 계약 일반형·전용 스펙 부재) · [[recipes/digital-print#DGP-WID-001]] (mapped-to — 디지털인쇄 일반형·전용 스펙 부재) · [[recipes/sticker#STK-WID-001]] (mapped-to — 스티커 정규화 계약 일반형) · [[recipes/photobook#PB-WID-001]] (mapped-to — 포토북 정규화 계약 일반형·에디터 중심) · [[recipes/acrylic#AC-WID-001]] (mapped-to — 정규화 계약) · [[recipes/calendar#CAL-WID-001]] (mapped-to — 캘린더 family 전용 스펙·2채널) · [[recipes/stationery#ST-WID-001]] (mapped-to — 문구 정규화 계약 일반형·전용 스펙 부재) · [[recipes/product-accessory#PA-WID-001]] (mapped-to — 상품악세사리 정규화 계약 일반형·부자재 addon 노출) · [[recipes/goods-pouch#GP-WID-001]] (mapped-to — 정규화 계약) · [[recipes/silsa#SL-WID-001]] (mapped-to — 정규화 계약·면적 입력UX≠가격격자)
- answers_cq: CQ-PROD-05 (옵션 축 — 위젯 계약 shape)
- tags: #위젯 #정규화계약 #DB독립

### [WID-002] 후니 어댑터 (무손실 컨버전 경계)  {⚪ 명세}
- 내용: 정규화 계약 ↔ 후니 t_* 사이의 **어댑터 레이어**가 매핑을 담당한다. RedPrinting 어댑터로 구현·검증 후 후니 어댑터로 교체하면 위젯 코어 불변. **단, `huni-db-mapping.md`/`data-adapter.md`의 후니 t_* 매핑은 PARTIAL-STALE** — 라이브 스키마 변경(I-1·I-4·I-5·I-6) 미반영 가능, 인용 시 라이브 스키마 대조.
- 앵커: DB 경계 — `huni-widget/03_spec/data-adapter.md`·`huni-db-mapping.md`
- 출처: `huni-widget/03_spec/data-adapter.md`·`huni-db-mapping.md` {tier D, PARTIAL-STALE}
- 연결: [[#WID-001]] · [[load-path#LP-002]] (t_* FK 위상) · [[cpq-options#CPQ-STALE]]
- 사용처: [[recipes/sticker#STK-WID-001]] (mapped-to — 스티커 어댑터 경계) · [[recipes/acrylic#AC-WID-001]] (mapped-to — 어댑터) · [[recipes/goods-pouch#GP-WID-001]] (mapped-to — 후니 어댑터) · [[recipes/product-accessory#PA-WID-001]] (위젯은 정규화 계약 의존 (DB 독립·family 전용 스펙 부재)) · [[recipes/silsa#SL-WID-001]] (위젯은 정규화 계약 의존 (DB 독립·면적 입력UX≠가격격자))
- tags: #위젯 #어댑터 #무손실컨버전 #PARTIAL-STALE

---

## 2. 컴포넌트·상태·연동

### [WID-003] 14 componentType ↔ shadcn 매핑  {⚪ 명세}
- 내용: 위젯 옵션 UI는 **14 componentType**(DESIGN.md)을 shadcn 컴포넌트로 매핑한다. admin product-viewer가 componentType ↔ `t_prd_product_*` UI ground-truth(12탭=12 t_prd_product_*). CPQ 속성→componentType은 [[cpq-options#CPQ-004]] 매핑 지도와 연결.
- 앵커: `huni-widget/03_spec/componenttype-mapping-matrix.md` + admin product-viewer(12탭)
- 출처: `huni-widget/03_spec/componenttype-mapping-matrix.md`·`component-tree.md` + `print-quote/04_design/DESIGN.md` + 메모리 `dbmap-live-admin-product-viewer` {tier D/A, FRESH}
- 연결: [[cpq-options#CPQ-004]] (mapped-to — 속성→componentType) · huni-design-system 스킬(Figma 14 컴포넌트)
- 사용처: [[recipes/digital-print#DGP-WID-001]] (mapped-to — 디지털인쇄 옵션 UI componentType) · [[recipes/sticker#STK-WID-001]] (mapped-to — 스티커 옵션 UI componentType) · [[recipes/photobook#PB-WID-001]] (mapped-to — 포토북 size/표지타입/page componentType) · [[recipes/acrylic#AC-WID-001]] (mapped-to — componentType) · [[recipes/calendar#CAL-WID-001]] (mapped-to — 캘린더 장수/가공택1/2채널 componentType) · [[recipes/stationery#ST-WID-001]] (mapped-to — 문구 page_rule/묶음수/커버타입 componentType) · [[recipes/goods-pouch#GP-WID-001]] (mapped-to — componentType) · [[recipes/silsa#SL-WID-001]] (mapped-to — 소재/size/코팅/후가공/부속 componentType) · [[recipes/booklet#BK-WID-001]] (책자 위젯 = 정규화 계약 일반형 (전용 스펙 부재)) · [[recipes/product-accessory#PA-WID-001]] (위젯은 정규화 계약 의존 (DB 독립·family 전용 스펙 부재))
- answers_cq: CQ-PROD-08 (상품-카테고리 UI 노출 구조) · CQ-TERM-06 (UI 표시 라벨)
- tags: #위젯 #componentType #shadcn #14컴포넌트

### [WID-004] 옵션 캐스케이드 (Zustand) + Edicus 브리지  {⚪ 명세}
- 내용: 옵션 선택 캐스케이드는 Zustand 상태로 관리(제약은 [[cpq-options#CPQ-007]] constraints.logic을 계약화). 에디터 연동은 Edicus postMessage 브리지(17함수). 이벤트 계약=event-contract.
- 앵커: `huni-widget/03_spec/state-management.md`·`editor-integration.md`
- 출처: `huni-widget/03_spec/state-management.md`·`editor-integration.md` + `02_analysis/event-contract.md` {tier D, FRESH}
- 연결: [[cpq-options#CPQ-007]] (mapped-to — constraints.logic 계약화) · [[#WID-005]]
- 사용처: [[recipes/acrylic#AC-WID-001]] (mapped-to — 캐스케이드·Edicus) · [[recipes/calendar#CAL-WID-001]] (uses — 링칼라 캐스케이드·디자인캘린더 Edicus 에디터) · [[recipes/goods-pouch#GP-WID-001]] (mapped-to — 옵션 캐스케이드·Edicus 브리지) · [[recipes/silsa#SL-WID-001]] (위젯은 정규화 계약 의존 (DB 독립·면적 입력UX≠가격격자))
- tags: #위젯 #캐스케이드 #Zustand #Edicus #postMessage

### [WID-005] 가격 권위 = 서버 (PRICE=0 불가 신호)  {⚪ 명세}
- 내용: 위젯 가격은 **서버 권위 + 클라 캐싱**. RedPrinting은 PRICE=0을 절대 반환하지 않는다(HARD) — **0은 항상 우리측 요청/세션 결함 신호**. 후니 가격은 axis-price-engine 권위([[price-engine#PE-001]]); Red 역산값은 분석용만, 후니 정합·이식 금지.
- 앵커: DB 외 — 서버 가격 API(후니 가격=t_prc_*)
- 출처: `huni-widget/03_spec/price-engine.md`·`01_reverse/price-engine-reversed.md` + 메모리 `huni-widget-price-strategy`·`huni-widget-red-price-never-zero` {tier D, FRESH(후보)}
- 연결: [[price-engine#PE-001]] (priced-by — 후니 가격 권위) · [[#WID-STALE]]
- 사용처: [[recipes/digital-print#DGP-WID-002]] (priced-by — 디지털인쇄 서버 가격권위·PRICE=0 불가) · [[recipes/sticker#STK-WID-002]] (priced-by — 스티커 서버 가격권위) · [[recipes/photobook#PB-WID-001]] (priced-by — 포토북 서버 가격권위·가격 적재 선행 필요) · [[recipes/acrylic#AC-WID-002]] (priced-by — 서버 가격권위) · [[recipes/calendar#CAL-WID-001]] (priced-by — 캘린더 서버 가격권위·가격 적재 선행 필요) · [[recipes/stationery#ST-WID-001]] (priced-by — 문구 서버 가격권위·가격 적재 선행) · [[recipes/product-accessory#PA-WID-002]] (priced-by — 상품악세사리 서버 가격권위·가격 적재 선행) · [[recipes/goods-pouch#GP-WID-002]] (priced-by — 서버 가격권위) · [[recipes/silsa#SL-WID-002]] (priced-by — 서버 면적매트릭스 가격권위·PRICE=0 불가) · [[recipes/booklet#BK-WID-001]] (책자 위젯 = 정규화 계약 일반형 (전용 스펙 부재))
- answers_cq: CQ-PRICE-01 (가격 권위 = 서버 공식 계산)
- tags: #위젯 #가격권위 #서버 #PRICE0불가

---

## 3. STALE 함정

### [WID-STALE] Red 역공학 가격값 후니 인용 금지 · ATTB 날조 전례  {🔴 주의}
- 내용: ① **Red 역공학 가격값을 후니 사실로 인용 금지**(분석용만 — 후니 가격은 axis-price-engine 권위). ② **`huni-db-mapping.md`/`data-adapter.md` 후니 t_* 매핑 PARTIAL-STALE**(라이브 스키마 변경 미반영). ③ **ATTB 권위 날조 전례**(G-1: ATTB=orderQty 권위 날조 적발 — 인용 소스라인 실재성 확인 필수).
- 출처: 메모리 `huni-widget-price-strategy`·`huni-widget-code-parity-done`(G-1) + impact-diagnosis I-1·I-4·I-5·I-6 {tier D/A}
- 연결: [[#WID-002]] · [[#WID-005]] · [[price-engine#PE-001]]
- 사용처: [[recipes/acrylic#AC-WID-002]] (가격 권위 = 서버 (PRICE=0 불가 신호)) · [[recipes/goods-pouch#GP-WID-002]] (가격 권위 = 서버 (PRICE=0 불가 신호)) · [[recipes/product-accessory#PA-WID-002]] (가격 권위 = 서버 (PRICE=0 불가 신호)) · [[recipes/silsa#SL-WID-002]] (가격 권위 = 서버 면적매트릭스 (PRICE=0 불가 신호)) · [[recipes/sticker#STK-WID-002]] (가격 권위 = 서버 (PRICE=0 불가 신호))
- tags: #STALE #Red역공학 #ATTB날조 #인용금지

---

## 4. GAP (미모델링·미결)

### [WID-GAP-1] 후니 DB 미정 → 어댑터 교체 시점 미확정  {🔴}
- 내용: 정규화 계약 의존으로 회피하나 어댑터 교체 시점 미확정.
- 출처: `_curation/axis-widget-contract.md` GAP-WID-1 {tier D}
- 연결: [[#WID-002]]
- tags: #GAP #어댑터교체

### [WID-GAP-2] 장바구니/주문 = Shopby 제외 (정규화 계약 경계)  {🔴}
- 내용: 장바구니/주문은 Shopby 통합 제외, 정규화 계약 경계 + 백엔드 미정.
- 출처: `_curation/axis-widget-contract.md` GAP-WID-2 + 메모리 `shopby-excluded-from-scope` {tier D}
- 연결: [[#WID-001]]
- tags: #GAP #Shopby제외 #장바구니

### [WID-GAP-3] 위젯 전체상품 확대 (7-stage) 중 일부 family만 스펙 존재  {🔴}
- 내용: 아크릴·굿즈파우치·캘린더만 family 위젯 스펙 존재. 나머지 family는 데이터계약 일반형 + DB매핑으로 도출(위젯코어 불변).
- 출처: `_curation/axis-widget-contract.md` GAP-WID-3 + 메모리 `huni-widget-expansion-strategy` {tier D}
- 연결: [[#WID-001]]
- 사용처: [[recipes/calendar#CAL-WID-001]] (캘린더 family 전용 스펙 s6-calendar-spec.md 존재분) · [[recipes/booklet#BK-WID-001]] (책자 위젯 = 정규화 계약 일반형 (전용 스펙 부재)) · [[recipes/digital-print#DGP-WID-001]] (디지털인쇄 위젯 = 정규화 계약 일반형 (전용 스펙 부재)) · [[recipes/photobook#PB-WID-001]] (포토북 위젯 = 정규화 계약 일반형 (전용 스펙 부재)) · [[recipes/product-accessory#PA-WID-001]] (위젯은 정규화 계약 의존 (DB 독립·family 전용 스펙 부재)) · [[recipes/stationery#ST-WID-001]] (문구 위젯 = 정규화 계약 일반형 (전용 스펙 부재))
- tags: #GAP #7stage확대 #family스펙
- 비고: family 위젯 스펙 존재분 → `huni-widget/03_spec/{s4-acryl,s5-goods-pouch,s6-calendar}-spec.md`.

---

## Sources
- 큐레이션 팩: `_curation/axis-widget-contract.md`
- 정답: `huni-widget/03_spec/data-contract.md`·`api-contract.md`·`data-adapter.md`·`huni-db-mapping.md`·`componenttype-mapping-matrix.md`·`component-tree.md`·`price-engine.md`·`state-management.md`·`editor-integration.md`·`{s4-acryl,s5-goods-pouch,s6-calendar}-spec.md`; `01_reverse/price-engine-reversed.md`; `02_analysis/event-contract.md`; `07_parity/parity-matrix-*.md`; `10_configurator/live-admin-groundtruth.md`; `print-quote/04_design/DESIGN.md`·`screen-inventory.md`.
- 보조: huni-design-system 스킬(Figma 14 컴포넌트·26 섹션).
- 메모리: `huni-widget-conversion-strategy`·`huni-widget-price-strategy`·`huni-widget-red-price-never-zero`·`huni-widget-equivalence-gate-go`·`huni-widget-expansion-strategy`·`huni-widget-code-parity-done`·`dbmap-live-admin-product-viewer`·`shopby-excluded-from-scope`.
- **STALE(인용 금지/주의):** Red 역공학 가격값 후니 인용; `huni-db-mapping.md`/`data-adapter.md` 후니 t_* 매핑(라이브 스키마 변경 미반영 — 대조 필요); ATTB 권위 날조 전례(G-1).
