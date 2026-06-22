# Consistency Report — Print-Quote 1차 교차검증

**작성:** 2026-05-27 (pq-pm)
**범위:** M1(As-Is 분석) + M2(빌더 도메인 모델 + huni 실데이터) 완료 시점.
**대상 산출물:** `01_research/*` + `02_business/*` (8건) + `03_architecture/adr/*` (3건) + `03_architecture/builder-engine/*` (8건 + schema.sql).
**제외:** M3(`04_design/*`) 미작성 → 화면↔API 매핑 축은 N/A.

본 문서는 5축 교차검증 결과를 정리한다. 불일치는 `INC-NNN` 식별자로 라벨링하며 우선순위(P0/P1/P2) 및 Resolution(해결 방안)을 명시한다.

---

## 검증 5축 개요

| 축 | 범위 | 상태 | 발견 INC 수 |
|---|------|------|--:|
| (a) 상품 모델 일관성 | product-master.md ↔ domain-model.md ↔ schema.sql | ✅ 1차 완료 | 3 (INC-001~003) |
| (b) 가격 산식 일관성 | pricing-rules.md ↔ pricing-engine.md ↔ schema.sql | ✅ 1차 완료 | 2 (INC-004~005) |
| (c) 상태 머신 일관성 | order-flow.md ↔ domain-model.md `Order` ↔ schema.sql `orders.status` | 🔴 불일치 | 3 (INC-006~008) |
| (d) 화면↔API 매핑 | 04_design 미작성 | ⏸ N/A | (M3 진행 후 재검증) |
| (e) EARS 요구사항 추적성 | requirements-ears.md REQ-PQ-001~120 ↔ 엔티티/화면/테스트 | 🟡 부분 완료 | 2 (INC-009~010) |

**합계:** 10건 식별. P0(Block M3) = 1건, P1(Block M4) = 4건, P2(Open) = 5건.
**2026-05-28 갱신:** INC-005·INC-007 해결 + **INC-001·INC-002 해결 (D-PM-01 Decided)** → 잔여 P0=0건, P1 open=3건 (INC-004, INC-008, INC-010).

---

## 축 (a) — 상품 모델 일관성

### INC-001 — `products.mes_item_cd` 컬럼 NULLABLE 모순 ⭐ P0 ✅ **Resolved (2026-05-28)**

**Severity:** P0 (BLOCKER) — **Resolved via D-PM-01 Decision (MES 외부 부여 + NULL 허용 + 동기화 추적 컬럼 추가)**
**Sources:**
- `03_architecture/builder-engine/schema.sql:339`: `ADD COLUMN mes_item_cd VARCHAR(8)` (NULL 허용)
- `02_business/product-master.md` §3: "MES ITEM_CD = 상품 코드 — 카테고리 prefix + 일련번호" (사실상 필수 식별자로 운영)
- `02_business/product-master.md` §6 PM-MISS-01: 010·011 카테고리 100+ 상품이 미부여 상태

**Inconsistency:** schema.sql은 `mes_item_cd` NULL 허용으로 정의(D-PM-01의 잠정 답 "신규 등록 시 자동 발급"을 미반영). 그러나 product-master.md는 이를 **상품의 정식 식별자**로 가정.

**Impact:** M3 화면 설계 시 "상품 등록 폼"에서 mes_item_cd 입력 필수/선택 여부 결정 모호. 가격 엔진의 PricingCatalog가 mes_item_cd로 lookup하는데 NULL 상품에 대한 fallback 미정.

**Resolution (권고):**
- (1) D-PM-01 결정 회신 이후 schema.sql 수정 ─ 자동 발급 정책 채택 시 `mes_item_cd VARCHAR(8) NOT NULL` + DEFAULT 함수(`gen_mes_item_cd(category_no)`) 추가.
- (2) 또는 partial unique index만 유지하고 `legacy_id` 컬럼 추가 (D-PM-01 잠정안 그대로).

**Linked Decisions:** D-PM-01, D-PM-03, D-PM-04
**Owner:** pq-architect (schema 수정), pq-business-analyst (정책 확정)
**Blocks:** M3 (상품 관리 화면 설계)

---

### INC-002 — `chk_products_mes_item_cd_format` 정규식 vs 미부여 상품 모순 ✅ **Resolved (2026-05-28)**

**Severity:** P1 — **Resolved via D-PM-01 Decision** (NULL 허용 정책 확정으로 함께 해결. CHECK 제약 `IS NULL OR ~ '^[0-9]{3}-[0-9]{4}$'` 유지가 정식 정책으로 승격됨. `mes_sync_status` 컬럼으로 동기화 진행 상태 추적.)
**Sources:**
- `schema.sql:345-346`: `CHECK (mes_item_cd IS NULL OR mes_item_cd ~ '^[0-9]{3}-[0-9]{4}$')`
- `02_business/product-master.md` §6: 010·011 카테고리에 별도 ID(5자리)만 보유, MES CD 없음

**Inconsistency:** schema의 CHECK 제약은 NULL 허용을 통해 010·011 케이스를 수용. 그러나 D-PM-01 잠정안 "신규 등록 시 자동 발급"이 채택되면 010·011도 `010-NNNN`/`011-NNNN` 형식이 되어야 함. 이 경우 NULL 허용은 마이그레이션 임시 상태 외에는 의미 없음.

**Resolution:** D-PM-01 회신 후 schema.sql 재정렬.
**Linked Decisions:** D-PM-01
**Owner:** pq-architect

---

### INC-003 — buysangsang `legacy_buysangsang_cat` 컬럼 미존재

**Severity:** P2
**Sources:**
- D-PM-02 잠정안: "buysangsang `product_cat`는 마이그레이션 레퍼런스로만 보존(`legacy_buysangsang_cat`)"
- `schema.sql:339-342`: products 확장 컬럼에 해당 컬럼 미존재 (`mes_item_cd`, `editor_mode`, `ps_code`, `shopby_product_no`만)

**Inconsistency:** D-PM-02 잠정안 채택 시 `legacy_buysangsang_cat VARCHAR(8)` 컬럼이 schema에 추가되어야 마이그레이션 추적 가능.

**Resolution:** D-PM-02 결정 회신 후 ALTER 추가.
**Linked Decisions:** D-PM-02
**Owner:** pq-architect

---

## 축 (b) — 가격 산식 일관성

### INC-004 — 배송비 정책 미반영(pricing-engine Step 6 placeholder)

**Severity:** P1 (Block M4)
**Sources:**
- `03_architecture/builder-engine/pricing-engine.md` §1 Step 6: `배송비 = ShippingFeeRule(지역, 중량)`
- `03_architecture/builder-engine/pricing-engine.md` §11: "O-PE-4 — 라인 단위 vs 카트 단위 가격(다건 견적 시 배송비 통합 기준)" Open
- `02_business/policy-checklist.md` §5.1: 배송비 6개 항목 미결정 (D-PM-31)
- `schema.sql`: baseline `shipping_fee_rules` 테이블 존재 (변경 없음)

**Inconsistency:** 가격 엔진 산식 Step 6은 추상화된 `ShippingFeeRule()` 호출만 명시, 6개 정책(무료 기준/기본가/혼합주문/제주/도서산간 4구간)의 구체 값이 산식에 missing. D-PM-31이 V1 critical path에서 가장 큰 미결정 항목.

**Impact:** 가격 엔진 통합 테스트 T-09 (쿠폰+적립금+무료배송)가 무료배송 임계 결정 없이 작성 불가. M4 통합 설계서의 "결제 총액 산식" 절 채울 수 없음.

**Resolution:** D-PM-31 결정 회신 → pricing-engine.md §1 Step 6에 구체값 삽입 → `shipping_fee_rules` seed 데이터 작성.
**Linked Decisions:** D-PM-31 (V1 CRITICAL PATH), O-PE-4
**Owner:** pq-architect (산식 갱신), pq-business-analyst (seed 데이터)
**Blocks:** M3 (배송지/결제 화면), M4 (통합 설계서 결제 절)

---

### INC-005 — 가격 모델 통일안 D-PM-08 미반영(PricingCatalog 단일 표현) ✅ **Resolved (2026-05-28)**

**Severity:** P1
**Resolution 산출물:** `03_architecture/builder-engine/pricing-engine.md` §3 (PricingModel enum) + §3.1 (8 팝업 코드 매핑표) + §3.2 (디스크리미네이터 분기).
**Sources:**
- `02_business/cross-mapping.md` §3.3 (D-PM-08): "2종 공존 — `PriceTable3D` + `BasePrice + TierDiscount`"
- `03_architecture/builder-engine/pricing-engine.md` §3 PricingCatalog: 단일 표현 (PriceTable + QuantityBreak로 추상화)
- `02_business/pricing-rules.md` §3: 8개 가격관리 팝업 코드(DP02/DP04/DP06/GD01/GD02/PK01/PR01/PR02) 별 모델 상이

**Inconsistency:** D-PM-08 잠정안은 명시적 2모델 공존. pricing-engine.md의 PricingCatalog 구조는 둘을 융합한 추상 구조로 표현됨 ─ 모델 구분이 코드 외에 명시되지 않아 가격관리 어드민 UI에서 모델 선택 불가.

**Resolution:** pricing-engine.md §3에 `pricing_model: 'PriceTable3D' | 'BasePriceTier'` 열거형 명시 + 8 상품군별 매핑 표 추가.
**Linked Decisions:** D-PM-08
**Owner:** pq-architect
**Blocks:** M3 (가격관리 어드민 화면), M4

---

## 축 (c) — 상태 머신 일관성 🔴 가장 큰 일관성 위반

### INC-006 — Order 상태 노드 수 모순(7-state vs 17-state) ⭐ P0 ✅ **Resolved (2026-05-27)**

**Severity:** P0 (가장 큰 일관성 위반)
**Sources:**
- `02_business/order-flow.md` §1.1: **7개 정식 상태** (`unpaid` / `paid` / `preparing` / `producing` / `done` / `shipped` / `cancelled`) — PDF 출처
- `03_architecture/builder-engine/domain-model.md` §3.4: "Order [_baseline:orders 17-state + ADR-002 매핑]"
- `03_architecture/builder-engine/domain-model.md` §3.6: "OrderStatusHistory ... 17-state 이력"

**Inconsistency:** 비즈니스 분석가는 PDF 출처로 **7 상태** 모델 채택. 아키텍트는 baseline `orders` 테이블의 **17 상태** 모델을 그대로 계승. **두 모델의 매핑이 명시되지 않음**.

**Impact:**
- baseline 17-state 중 어느 것이 PDF 7-state의 어디에 해당하는지 불명 → 상태 전이 트리거(8건, order-flow.md §2.1) 구현 불가.
- M3 주문관리 화면 설계 시 상태 필터 옵션 ─ 7개 노출 vs 17개 노출 결정 불가.
- ADR-002 D5 "이중 상태 머신(Project / Order)" 결정이 이 모순 위에 쌓임 → ADR-002 자체가 흔들림.

**Resolution (제안):**
- (1) baseline 17-state 정의를 schema.sql 코멘트로 명시 (현재는 `_baseline/07_integrated_schema.sql`에 있을 것으로 추정 ─ 확인 필요).
- (2) order-flow.md §1.1의 7-state를 baseline 17-state의 **superstate(상위 상태)**로 정의하는 매핑표 신설.
- (3) UI는 superstate 7개로 표시, 내부 트랜잭션은 17-state 그대로 유지.

**Action Items:**
- pq-business-analyst: baseline `_baseline/07_integrated_schema.sql`에서 17-state 정의 추출.
- pq-architect: 7↔17 매핑표를 `03_architecture/builder-engine/order-state-mapping.md` 신규 작성.
- pq-pm: D-PM-30B 신규 결정 등록 ─ "Order 상태 노출 정책(7 superstate UI / 17 internal)".

**Linked:** D5 ADR-002, ADR-003 Q-Master-3
**Owner:** pq-architect + pq-business-analyst 협업
**Blocks:** M3 (주문관리 UI), M4 (통합 설계서 상태머신 절), 모든 REQ-PQ-040~062

---

### INC-007 — 파일 상태 머신 vs Order 상태 머신 동시성 명세 부재 ✅ **Resolved (2026-05-28)**

**Severity:** P1
**Resolution 산출물:** `03_architecture/builder-engine/domain-model.md` §5.7a `ArtworkFileStatus` 엔티티 + §5.7b 상품 타입별 enum + §5.7c Order↔File 동기화 가드 + ProofCycle 구분 표.
**Sources:**
- `02_business/order-flow.md` §1.3: 파일 흐름 부속 상태 머신(파일번호 단위)
- `02_business/order-flow.md` §1.4 코멘트: "주문 상태가 `producing` 일 때 파일 상태가 `포장완료` 가 되어야 주문 상태가 `done` 으로 전이"
- `03_architecture/builder-engine/domain-model.md`: 파일 상태 머신 엔티티 미정의 (proof_cycles만 존재, schema.sql §2.4)

**Inconsistency:** order-flow.md는 이중 상태 머신을 명시. domain-model.md는 `artwork_files` 테이블만 언급 ─ 파일 단위 상태 전이 규칙 불명. proof_cycles는 교정 사이클이며 파일 흐름과 별개.

**Resolution:** domain-model.md에 `ArtworkFileStatus` 명시 + Order ↔ ArtworkFile 동기화 규칙 추가.
**Linked REQ:** REQ-PQ-063~078 (파일 업로드·검수)
**Owner:** pq-architect
**Blocks:** M3 파일 업로드/검수 화면, M4

---

### INC-008 — `DesignProject` 3-state(editing/ordering/ordered) vs Order 상태 매핑 모호

**Severity:** P1
**Sources:**
- `03_architecture/builder-engine/domain-model.md` §4.1 (line 365): `DesignProject.status` = `editing` / `ordering` / `ordered` (FROZEN, edicus.ts:97)
- `03_architecture/builder-engine/domain-model.md` §4.5 (line 417~419):
  - `editing` → Order 없음
  - `ordering` → `Order.status='draft' or 'quote_confirmed'`
  - `ordered` → `Order.status >= 'payment_done'`
- 그러나 `quote_confirmed`, `payment_done`은 PDF 7-state(`unpaid`/`paid`/...)에 없음 → baseline 17-state의 일부로 추정.

**Inconsistency:** DesignProject ↔ Order 매핑이 PDF 7-state 어휘와 baseline 17-state 어휘를 섞어 사용. 어떤 모델이 정식인지 불명 → INC-006에 종속.

**Resolution:** INC-006 해결 후 본 매핑을 단일 어휘로 재작성.
**Linked Decisions:** INC-006, ADR-002 D5
**Owner:** pq-architect
**Blocks:** ADR-002 후속 결정 (D9 Fallback 등)

---

## 축 (d) — 화면↔API 매핑

**현 단계 상태:** `_workspace/print-quote/04_design/` 미작성 → **N/A**.

**M3 시작 후 재검증 항목** (사전 합의):
- 모든 V1 화면에 대해 source API/엔티티 매핑이 존재하는가
- 빌더 위젯(14종, block-schema.md §2) 각각의 데이터 바인딩 표현식이 widget-coverage-matrix.md와 일치하는가
- 옵션 폼(form-builder.md) 입력 필드가 `product_spec_options` 카탈로그와 1:1 매핑되는가
- 결제 화면 총액 표시 컴포넌트가 pricing-engine.md `calculateQuote` 출력 스키마와 일치하는가

→ M3 산출물 작성 후 본 보고서를 갱신.

---

## 축 (e) — EARS 요구사항 추적성

### 검증 매트릭스 (요약)

| 카테고리 | REQ 범위 | (1) 도메인 엔티티 추적 | (2) 화면 추적 | (3) 테스트 시나리오 |
|---------|--------|:---:|:---:|:---:|
| 1. 상품 카탈로그 | REQ-PQ-001~019 | ✅ 19/19 (domain-model.md §2) | ⏸ M3 대기 | ⏸ M3 대기 |
| 2. 가격 엔진 | REQ-PQ-020~039 | ✅ 20/20 (pricing-engine.md) | ⏸ M3 대기 | 🟡 10/20 (pricing-engine.md §8 T-01~T-10) |
| 3. 주문·결제 | REQ-PQ-040~062 | 🟡 부분 (INC-006으로 인해 11건 모호) | ⏸ M3 대기 | ⏸ M3 대기 |
| 4. 파일 업로드·검수 | REQ-PQ-063~078 | 🟡 부분 (INC-007로 인해 7건 모호) | ⏸ M3 대기 | ⏸ M3 대기 |
| 5. 공정 추적 | REQ-PQ-079~093 | ✅ baseline production_* 활용 | ⏸ M3 대기 | ⏸ M3 대기 |
| 6. 회원·정책 | REQ-PQ-094~110 | 🟡 부분 (쿠폰·적립금 엔티티 D-PM-33 종속) | ⏸ M3 대기 | ⏸ M3 대기 |
| 7. 시스템·인프라 | REQ-PQ-111~120 | 🟡 ADR-002·003 잠정 | ⏸ M3 대기 | ⏸ M3 대기 |
| **합계** | **120** | **88 ✅ / 32 🟡** | **0 / 120** | **10 / 120** |

### INC-009 — REQ-PQ-040~062 (주문·결제) 11건 INC-006 종속 ✅ **Resolved (2026-05-27)**

**Severity:** P1
**Detail:** order-flow 7-state 어휘로 작성된 11개 EARS 요구사항(REQ-PQ-040, 042~048, 057~059)이 baseline 17-state 매핑 부재로 인해 구현 명세 불분명.
**Resolution:** INC-006 해결 후 재작성.

### INC-010 — REQ-PQ-063~078 (파일 업로드) 7건 INC-007 종속

**Severity:** P1
**Detail:** 파일 상태 머신 엔티티 정의 부재로 인해 7건의 파일 검수 요구사항 추적 불가.
**Resolution:** INC-007 해결 후 재작성.

---

## 종합 요약

### Severity 분포 (2026-05-28 갱신)

| 우선순위 | 건수 | INC ID |
|------|--:|------|
| **P0 (Block M3)** | **0 open** | ✓ INC-001 Resolved (D-PM-01 Decided), ✓ INC-006 Resolved |
| P1 (Block M4) | **3 open** / 4 Resolved | open: INC-004, INC-008, INC-010 / Resolved: INC-002, INC-005, INC-007, INC-009 |
| P2 (Open) | 1 | INC-003 |
| **합계** | **10** (7 Resolved / 3 open + 1 P2) | |

### 가장 큰 일관성 위반 1건

**INC-006 — Order 상태 노드 수 모순(7-state vs 17-state)**.
PDF 출처 7-state 모델(pq-business-analyst)과 baseline 17-state 계승(pq-architect)이 매핑 없이 공존. M3·M4 모두를 차단하며 ADR-002 D5("이중 상태 머신")의 기반 자체가 흔들림. **M3 시작 전 반드시 해결 필요**.

### M3(화면 설계) 시작 전 사전 처리 권고 (우선순위順)

1. **[BLOCKER] INC-006 해결** — 7↔17 매핑표 신규 작성 (`03_architecture/builder-engine/order-state-mapping.md`). pq-architect + pq-business-analyst 협업, P0.
2. **[BLOCKER] INC-001 해결** — D-PM-01 결정 회신 후 schema.sql `mes_item_cd` 정책 확정. pq-business-analyst → 사용자, P0.
3. INC-004 해결 — D-PM-31 결정 회신 후 가격 엔진 Step 6 구체값 채움. P1.
4. ~~INC-005 해결~~ ✅ **Resolved 2026-05-28** (pricing-engine.md §3/§3.1/§3.2).
5. ~~INC-007 해결~~ ✅ **Resolved 2026-05-28** (domain-model.md §5.7a/b/c `ArtworkFileStatus`).

→ 1·2 항목은 사용자 결정 회신이 선행되어야 함. 3·4·5는 분석가/아키텍트 자체 처리 가능 (병행 진행 권고).

---

## 변경 이력

| 버전 | 날짜 | 변경 | 작성자 |
|------|------|------|--------|
| 1.0 | 2026-05-27 | M1+M2 완료 시점 1차 교차검증 — 10 INC 식별 | pq-pm |

다음 갱신: M3(화면 설계) 산출물 작성 후 축 (d) 활성화.


---

## ✅ Resolution 진행 상태 (2026-05-27 갱신)

| INC ID | Status | Resolution | 산출물 |
|---|---|---|---|
| INC-006 | ✅ Resolved (2026-05-27) | 7-superstate / 18-substate(17+packing_done) 매핑 채택 | `03_architecture/builder-engine/order-state-mapping.md` |
| INC-007 | ✅ Resolved (2026-05-28) | `ArtworkFileStatus` 엔티티 + 상품 타입별 flow enum + Order↔File 동기화 가드 | `03_architecture/builder-engine/domain-model.md` §5.7a/b/c |
| INC-009 | ✅ Resolved (2026-05-27) | REQ-PQ-040~062 11건 모호성 해소 (매핑표 §2/§7) | `03_architecture/builder-engine/order-state-mapping.md` |
| INC-005 | ✅ Resolved (2026-05-28) | `pricing_model: 'PriceTable3D' \| 'BasePriceTier'` enum + 8 팝업 코드 매핑표 + Step 1 분기 로직 | `03_architecture/builder-engine/pricing-engine.md` §3 / §3.1 / §3.2 |
| INC-001 | ✅ Resolved (2026-05-28) | D-PM-01 Decided — MES 외부 부여 + NULL 허용 + `mes_sync_status`/`mes_synced_at` 동기화 추적 컬럼 추가 | `schema.sql` §3.1, `pricing-engine.md` §3.0, `decisions.md` D-PM-01 |
| INC-002 | ✅ Resolved (2026-05-28) | D-PM-01 Decided — NULL 허용 정책이 정식으로 승격. CHECK 제약 유지. | `schema.sql` §3.1 |

**남은 INC (M3 진입 후 처리 가능):**
- INC-003 (D-PM-02 사용자 결정 종속, P2)
- INC-004 (D-PM-31 사용자 결정 종속, P1)
- INC-008 (INC-006 어휘로 DesignProject↔Order 매핑 재작성 필요 — pq-architect 자체 처리 가능, P1)
- INC-010 (INC-007 해결로 차단 해제 — REQ-PQ-063~078 추적 가능, P1)

**M3(화면 설계) 진입 가능 여부:** ✅ **차단 항목 0건 — 즉시 착수 가능** (P0 INC-001/006 모두 해결)

---

## 2026-05-30 갱신 — V1? 화면 범위 확정 (D-DS-33/34)

**트리거:** owner 지니 결정 회신으로 `04_design/sitemap.md`·`ia.md`·`screen-inventory.md` 3종 갱신. M3 화면 범위 V1? 9건(실 기능행 10행) 전부 해소.

**기존 INC와의 관계:** INC-001~010 어느 것도 본 9개 화면(SM-CS-04/05/06, SM-A-32/33/34, SM-MY-12.3, SM-M-05/07, SM-A-04/21/55)을 직접 참조하지 않음 → 기존 INC 영향 없음. 본 결정은 신규 범위 확정이며 축(d) 화면↔API 매핑(M3 후 활성화)에서 신규 검증 대상.

**축(d) 신규 검증 항목 추가 (M3 산출물 작성 후):**
- 디자인상담(SC-CS-06/SC-A-34)의 `DesignProject` 엔티티·`editor_slot`(에디터) 바인딩이 domain-model.md `DesignProject`(§4.1) 및 ADR-002 이중 상태머신과 정합하는가.
- B2B 게시판(SC-CS-04/05·SC-A-32/33)의 `Inquiry`/`InquiryQuote` 엔티티가 domain-model.md에 정의되어 있는가 (현 시점 미확인 — M3 매핑 시 검증).
- 별도트랙 최소형 V1(TR-SYS·TR-CLAIM·TR-PROC-1/4)의 화면이 schema.sql 대응 테이블(`shipping_fee_rules`·알림정책·클레임)과 매핑되는가.

### INC-DS-01 — 화면 범위 카운트 정정 (관리자 V1? 누락 기재) ✅ Resolved (2026-05-30)

**Severity:** P2 (문서 정합)
**Sources:**
- `04_design/sitemap.md §1` v2.0: 관리자 V1?=4 / V2=14 (직전 표기)
- `04_design/screen-inventory.md §4.1` v2.0: 동일 표기
- 실제 관리자 V1? 기능행: SM-A-04·SM-A-21·SM-A-32·SM-A-33·SM-A-55 = **5건**

**Inconsistency:** 요약 표가 관리자 V1?를 4로 기재했으나 실 기능행은 5건. V2가 14가 아닌 13이어야 51 합계 정합.
**Resolution:** sitemap §1·screen-inventory §4.1·status.md에 정정 기선(V1?=5/V2=13) 명기 + 본 라운드 결정 반영하여 최종 V1 85 / V2 27 / V1? 0으로 동기화.
**Owner:** pq-pm
**Status:** Resolved (2026-05-30)

**V1? 범위 종합:** 화면 설계 V1? 잔여 **0건**. 별도트랙 TR-BLD만 O-004(빌더 위젯 1차 범위) 종속으로 V1? 유지 — 이는 화면 인벤토리 V1?가 아닌 빌더 트랙 미결로 분리 관리.
