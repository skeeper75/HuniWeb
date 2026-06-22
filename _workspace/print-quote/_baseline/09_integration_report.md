# 스키마 통합 보고서

작성: schema-integrator
작성일: 2026-05-07
입력: `02_product_schema.sql`, `03_pricing_schema.sql`, `04_order_schema.sql`, `05_widget_schema.sql`, `06_production_schema.sql`
출력: `07_integrated_schema.sql`, `08_erd.md`

---

## 요약

| 지표 | 값 |
|------|-----|
| 총 테이블 수 | **38** |
| 총 도메인 수 | **6** (공통 + 제품/가격/주문/위젯/생산) |
| 크로스 도메인 FK 수 | **15** |
| 트리거 함수 | 1 (`set_updated_at`) — 도메인 파일에서 5회 중복 → 1회로 통합 |
| 확장 (extension) | 1 (`pgcrypto`) — 도메인 파일에서 3회 중복 → 1회로 통합 |
| 수정된 컬럼 타입 | 1 (`extra_cost_modifier` NUMERIC(4,4)→(6,4)) |
| 통합된 중복 테이블 | 2 (`users`, `system_configs`) |

---

## 수정 사항

| 대상 | 수정 내용 | 사유 |
|------|----------|------|
| `product_spec_options.extra_cost_modifier` | `NUMERIC(4,4)` → `NUMERIC(6,4)` | NUMERIC(4,4)는 max 0.9999 — DEFAULT 1.0000 또는 1.0500/1.1500 같은 사용 중인 값을 저장 불가능 (런타임 오류 발생). 6,4로 확장하여 99.9999까지 허용 |
| `users` 테이블 | `04_order_schema.sql`과 `06_production_schema.sql`에 동일하게 정의된 테이블을 SECTION 2에 단일 정의 | order/payment/file/production/QC FK가 모두 동일한 `users.id` 참조 — 두 번 CREATE 시 중복 충돌 |
| `system_configs` 테이블 | `03_pricing_schema.sql`에서 SECTION 2 (공통)으로 이동 | VAT_RATE/CURRENCY는 가격뿐 아니라 주문/생산이 잠재 소비자. 공통 위치가 의미상 정확 |
| `set_updated_at()` 함수 | 5개 도메인 파일 모두에 `CREATE OR REPLACE`로 중복 → SECTION 1에 1회 정의 | 단일 책임 원칙. 함수 본체 일관성 보장 |
| `CREATE EXTENSION pgcrypto` | 3개 파일에서 중복 → SECTION 0에 1회 | idempotent하지만 가독성 |
| 크로스 도메인 FK | 도메인 파일 내부 FK 선언을 SECTION 8로 일부 이전 (price_tables → products, spec_option_surcharges → product_spec_options) | CREATE 순서 의존성 분리 + 향후 도메인 분리 마이그레이션 용이 |

---

## 도메인 간 FK 관계 맵

```
┌──────────────┐
│   common     │  users, system_configs
└──────┬───────┘
       │
       ├──→ orders.user_id, quotes.user_id, order_status_history.changed_by
       ├──→ artwork_files.reviewer_id
       ├──→ payments (via orders)
       ├──→ production_jobs.operator_id
       ├──→ job_stage_status.operator_id
       ├──→ qc_checkpoints.inspector_id
       └──→ material_usage_log.operator_id

┌──────────────┐
│   product    │  products, product_categories, specifications, options, rules, templates
└──────┬───────┘
       ├──→ pricing.price_tables.product_id
       ├──→ pricing.spec_option_surcharges.spec_option_id
       ├──→ order.quotes.product_id
       ├──→ order.order_items.product_id (스냅샷 navigation)
       ├──→ widget.widget_configs.product_id (1:1)
       ├──→ widget.widget_step_fields.spec_id
       └──→ production.production_specs.product_id (1:1)

┌──────────────┐
│   order      │  quotes, orders, items, status_history, artwork, payments, shipping
└──────┬───────┘
       └──→ production.production_job_items.order_item_id (N:M gang)
```

---

## 성능 최적화 권고사항 (Top 5)

1. **`idx_orders_status_created` (partial, deleted_at IS NULL)** — 관리자 대시보드 "상태별 주문 목록" 쿼리. soft-delete 행을 미리 제외하여 인덱스 크기 축소.
2. **`idx_order_items_spec_gin` (GIN on spec_snapshot)** — 생산 도메인의 gang printing 후보 조회 ("paper × coating × method 동일 라인 묶기"). JSONB 경로 검색을 인덱스로 흡수.
3. **`idx_quantity_price_breaks_table_range`** — 위젯 실시간 견적의 핵심 룩업 (price_table_id + qty 범위). 200~400ms debounce 후 매번 호출되는 hot path.
4. **`idx_artwork_files_status_queue` (partial: pending/reviewing)** — 프리프레스 검수 큐 대시보드. 대부분의 행이 approved/rejected 상태이므로 partial 인덱스로 비용 절감.
5. **`idx_widget_analytics_widget_occurred` (DESC)** — 깔때기(funnel) 분석 시간 범위 스캔. append-only 테이블이므로 BRIN도 후속 검토 가능.

추가로 SECTION 9에 `idx_orders_created_recent`, `idx_jobs_equipment_status` 두 개의 크로스 도메인 인덱스 정의.

---

## 미결 사항 (사용자 결정 필요)

| 항목 | 옵션 A | 옵션 B | 권장 |
|------|-------|-------|------|
| **PostgreSQL 스키마 네임스페이스** | 단일 schema (현재 통합 SQL) | `product`, `pricing`, ... 5개 schema 분리 | A — 38개 테이블 규모면 단일 public 충분. 분리는 운영 권한 격리가 필요해질 때 검토 |
| **`order_status_history`의 to_status CHECK 중복** | `orders.status`와 `order_status_history.to_status` 양쪽에 동일 17-state CHECK | ENUM 타입으로 추출 후 양쪽 컬럼이 참조 | A 유지 (현행) — ENUM은 ALTER TYPE 락 비용이 크다. 17-state가 안정될 때 B 고려 |
| **`quotes` ↔ `orders` 1:N 가능성** | 현재 `orders.quote_id`는 nullable FK (1:N 가능) | 1:1로 강제 (UNIQUE) | A 유지 — 동일 견적에서 분할 주문 시나리오 대비 |
| **`production_job_items.order_item_id` UNIQUE** | 현재 UNIQUE (1 라인 = 1 job) | 부분 출고 위해 N:M 허용 | A 유지 — gang printing 표준은 1 라인 1 job. 분할 생산은 추후 SPEC |
| **민감 정보 암호화** | 현재 평문 (email, phone, address) | `pgcrypto` PGP 함수로 컬럼 암호화 | 추후 SPEC — GDPR/개인정보법 대응 시 필수 |

---

## 향후 확장 포인트

리서치 보고서 §6.4 기반:

1. **새 제품 추가** — 현재 데이터 기반 모델이라 (product, specs, options, rules, price_table, widget_config) INSERT만으로 신규 제품 (현수막/스티커/책자 등) 추가 가능. 코드 변경 불필요.

2. **다국어 i18n 확장** — `ui_translations`이 (i18n_key, locale) UNIQUE 구조로 이미 구비. 한국어/영어 외 언어는 INSERT만으로 추가. 단, 제품명/카테고리 다국어는 별도 `product_translations` 테이블 필요 (현재 미구현 — 확장 포인트).

3. **다국가 통화 / 세제** — `system_configs`에 통화/세율을 보관 중. 다국가 진출 시 `(country_code, config_key)` 복합 키로 확장 + 환율 스냅샷 테이블 (`fx_rates`) 추가.

4. **멀티 채널 / 멀티 공장** — `orders`, `production_jobs`에 `channel_id`, `factory_id` 컬럼 추가하여 B2C/B2B/화이트라벨 분리. FK는 `channels`, `factories` 마스터 신설.

5. **시계열 가격 영향 시뮬레이션** — `price_tables`가 이미 `valid_from`/`valid_to` 기반. 별도 분석 DB로 ETL하여 가격 변경 시 영향 시뮬레이션 (배치 작업) 권장.

6. **이벤트 소싱** — `order_status_history`가 사실상 이벤트 로그 역할. 향후 CQRS/이벤트 소싱으로 발전 시 이 테이블이 단일 source of truth가 될 수 있음.

7. **재고/ERP 연계** — `print_materials`/`material_usage_log` 구조가 ERP API와 동기화 가능. `external_sku`, `last_synced_at` 컬럼 추가로 연계 확장.

8. **파일 스토리지 메타** — `artwork_files`가 storage_key만 보관 중. 추후 검수 자동화 (DPI/CMYK/blend 자동 추출)를 위해 별도 `file_metadata` JSONB 컬럼 또는 테이블 분리 가능.

---

## 검증 노트

- 통합 SQL은 도메인 파일 5개를 단순 concatenate한 것이 아니라 **중복 제거 + 의존 순서 재배치 + 타입 수정**을 거친 결과입니다.
- 기존 도메인 파일의 모든 INSERT/시드는 보존하여, 통합 SQL을 fresh DB에 실행 시 일반명함 (CARD_GENERAL_STD) 1건의 완전한 end-to-end 데이터 (제품 → 가격표 → 위젯 → 주문 → 결제 → 배송 → 생산 사양)를 확보할 수 있습니다.
- 모든 cross-domain FK는 `ON DELETE` 정책이 명시되어 있으며, 마스터 데이터 (products, users)는 `RESTRICT` 또는 `SET NULL`이 기본 — 과거 주문 무결성 보호.
- 17-state 주문 상태 머신, gang printing N:M, 영업일 함수(`business_days_from_now`) 모두 통합 SQL에 포함.
