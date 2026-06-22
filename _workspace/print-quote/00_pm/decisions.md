# Print-Quote 의사결정 로그

후니프린팅 리뉴얼 프로젝트의 모든 주요 의사결정을 ADR 경량 포맷으로 기록.

---

## D-001 — buysangsang 정체

**Date:** 2026-05-27
**Status:** Decided

**Context:** buysangsang.com의 site.name이 "후니프린팅"으로 노출됨. 본인 사이트인지 확인 필요.

**Decision:** **본인 사이트.** 후니프린팅 자체 운영 WordPress + WooCommerce + Elementor 사이트. 분석 권한 = 관리자 풀 접근.

**Consequences:** "경쟁사 분석" 프레임 폐기 → "As-Is 시스템 감사" 프레임으로 전환.

---

## D-002 — 리뉴얼 방향: 자체 웹빌더 구축

**Date:** 2026-05-27
**Status:** Decided

**Context:** 사용자가 자체 웹빌더(Elementor 류)를 작업 중이며, buysangsang 현행 구성을 자체 빌더로 재현하려 함.

**Decision:** **자체 웹빌더 구축**으로 확정. 분석 KPI = "buysangsang의 N개 페이지를 우리 빌더로 100% 재현 가능한가(buildability)". Big-Bang 컷오버 + 완전 신규 빌드.

**Consequences:** 분석 프레임이 "As-Is 빌더 패턴 7축 역공학"으로 재정의 (widget/layout/template/interaction/form/token/plugin). pq-researcher·pq-architect 책임 변경.

---

## D-003 — Edicus SDK 외부 의존 유지

**Date:** 2026-05-27
**Status:** Decided

**Context:** `docs/edicus.man/`가 Next.js 15 + 외부 Edicus SDK(edicusbase.firebaseapp.com) 기반 후니 전용 통합 셸로 식별됨. partner="hunip" 하드코딩, Huni Design System v6.0 적용, 12K LOC, 흡수 가능.

**Decision:** edicus.man을 **베이스라인으로 채택**, Edicus SDK 외부 의존 유지(자체 재구현 X). 디자인 에디터 영역은 외부 SDK 활용, 나머지(견적·카탈로그·옵션·가격·관리자·결제·공정)는 자체 구축.

**Consequences:** Edicus SDK 장애 시 fallback 정책 필요 (ADR-002 Open). 산출물 데이터가 Firebase에 분산 → 동기화 전략 필요.

---

## D-004 — To-Be 프론트엔드 아키텍처: 옵션 C (자체 빌더 100%)

**Date:** 2026-05-27
**Status:** Accepted
**Linked:** `_workspace/print-quote/03_architecture/adr/ADR-001-frontend-architecture-options.md`

**Context:** Shopby Aurora React Skin 채택 여부 결정 필요. 후니가 이미 huniprinting48.shopby.co.kr (mall_no=81683)로 Aurora 운영 중이나 견적 도메인 fit이 의심됨.

**Decision Matrix** (가중합 8차원):
| 옵션 | 점수 | 결정 |
|------|-----|----|
| A — Aurora Full | 21.7 / 100 | 폐기 |
| B — Hybrid | 65 / 100 | Fallback 보조 |
| **C — 자체 빌더 100%** | **80 / 100** | **채택 ✅** |

**Decision:** **옵션 C 채택.** Next.js 15 + edicus.man 베이스라인 + Shopby Server API 일부 활용. Aurora Skin 미사용.

**Deal-breaker (옵션 A 폐기 근거):**
> Shopby가 어드민 상품 가격을 단일 진실로 재계산하므로 **외부 산출 동적 견적가 결제 불가능 → 가격 무결성 위반**.

**Aurora 결정적 한계 3가지** (Aurora 분석 보고서 인용):
1. 가격 무결성 (외부 동적 단가 push 미지원)
2. 옵션 모델 강성 (SKU-variation 강제, 인쇄 사양×수량구간×옵션가산 표현 불가)
3. 공정 워크플로 부재 (생산 배치·SLA·검수 표준 없음)

**Aurora 구조적 한계:**
- 확장성 4/18 (22%) — slot/theming/i18n/plugin 메커니즘 부재, fork+수정만 가능
- 인쇄 도메인 fit 13/30 (43%)
- private npm registry 의존 → 업데이트 흐름 외부 종속

**Consequences:**
- huniprinting48.shopby.co.kr 폐기 (Big-Bang 컷오버 대상에 포함)
- buysangsang.com 폐기 (동일)
- Shopby Server API는 **회원·주문·결제 BFF**로 부분 활용 (가격·옵션·견적·에디터는 자체)
- pq-architect: 빌더 도메인 모델 + Shopby BFF 인터페이스 설계 즉시 착수
- 검증 항목 V1·V2·V3 (Aurora 분석 보고서 인용)를 추후 실시간 검증으로 확정

---

## D-005 — Shopby 위임 범위 재검토 (옵션 C 하위 분기)

**Date:** 2026-05-27
**Status:** **Conditional Accepted (V-001만 남음)** — V-002 해소(ecount 확정), V-003 별도 SPEC, V-001 검증 후 v2 Accepted
**Linked:** `_workspace/print-quote/03_architecture/adr/ADR-004-shopby-delegation-scope.md`
**Supersedes (partially):** O-001 (Shopby 위임 범위 — 본 결정으로 분리·구체화)

**Context:** 사용자가 "Shopby를 쓰면 Shopby Admin·API·동기화 부담이 추가되는데, 인쇄 도메인 자체 구축 부담은 그대로 남는다. 정말 가치가 있는가?"라고 재검토 요청. D-004(옵션 C)는 유지하되, 그 안의 Shopby 위임 범위를 정량 평가.

**사용자 사업 특성 입력 (2026-05-27):**
- B2B 비중: **30~50% 혼합**
- 본인인증(CI/DI): **불필요** (휴대폰 인증 수준 충분)
- 휴면계정·약관: 정보통신망법 표준 — 자체 구현 가능

**3개 하위 분기 정량 비교 (가중합 100점, ADR-004 §3 매트릭스):**
| 옵션 | 점수 | 결정 |
|------|-----|-----|
| C-current (회원·결제·정산 위임) | 62.4 | 비추 |
| **C-minimal (PG channel만)** | **70.0** | **잠정 1순위** ⭐ |
| C-extreme (Shopby 완전 미사용) | 67.5 | 2순위 (PG 다중 직계약 부담) |

**Provisional Decision:** **Option C-minimal** — PG channel만 Shopby 활용, 회원·인증·휴면·약관·정산은 자체.

**핵심 변경 (C-current → C-minimal):**
| 영역 | C-current (D-004 + bff-integration.md §4) | C-minimal (잠정) |
|------|---|---|
| 회원·인증 | Shopby Server API (SSO 토큰) | **NextAuth v5** (edicus.man Firebase Auth 마이그레이션 흐름) |
| 본인인증 | Shopby CI/DI 위탁 | **휴대폰 인증** (SaaS 또는 KCB/NICE 직계약) |
| 휴면계정 | Shopby `POST /dormant` | 자체 cron + `members_dormant` 분리 |
| 약관 이력 | Shopby `GET /agreements/history` | 자체 `agreement_logs` 테이블 |
| 결제 PG | Shopby PG channel | **Shopby PG channel 유지** (한국 다중 PG 통합 가치) |
| 정산·세금계산서 | Shopby `GET /settlements` | 자체 + 회계 솔루션 연동 |
| Shopby Admin 콘솔 | 회원·주문·정산 운영 | **결제 모니터링만** |

**검증 필요 (확정 전):**
- **V-001 (Open)**: Shopby PG channel을 회원 없이 게스트 결제로 사용 가능한가? (Shopby Server API IP 등록 후 확인)
- **V-002 ✅ Closed (2026-05-27)**: **ecount(이카운트) 확정** — 후니프린팅 이미 사용 중. ecount Open API로 매출·세금계산서·국세청 연동 자동화. ADR-004 §8 신설.
- **V-003 (별도 SPEC)**: 휴대폰 인증 SaaS vs KCB/NICE 직계약 비교 — 결정 영향 없음, 구현 SPEC에서 결정

**Consequences (C-minimal 채택 확정 시):**
- `bff-integration.md` §1/§4/§7.6/§9 갱신 (회원·정산 행 → 자체, SSO 토큰 흐름 → NextAuth)
- `schema.sql` `members.shopby_*` 컬럼 제거 또는 nullable로
- Shopby 위임 도메인: 2개 → 1개 (결제 진입만)
- 운영비 모델: Shopby Enterprise 월정액 비용 → PG channel 수수료만으로 축소 가능성
- D-005 확정 후 D-PM-* 회원·정산 관련 결정 항목 영향 분석 필요

---

## 🟡 Open Decisions (미결)

### O-001 — Shopby Server API 활용 범위 (Closed by D-005)

**Status:** Closed (2026-05-27) — superseded by D-005 / ADR-004

원 질문: "회원·주문·결제 중 어디까지 Shopby에 위임할 것인가?"

→ D-005(ADR-004)에서 3개 하위 분기로 분리·구체화. 잠정 답: **C-minimal (PG channel만)**.
   확정은 V-001/V-002/V-003 검증 완료 후.


### O-002 — Edicus SDK 장애 시 Fallback

**Question:** 외부 Edicus 서비스 장애 시 디자인 에디터 영역의 정책 (오프라인 모드? 파일 업로드만 허용?)

### O-003 — 마이그레이션 컷오버 시점

**Question:** Big-Bang 일자, 데이터 마이그레이션 범위(상품·회원·주문 이력), URL 보존 정책.

### O-004 — 빌더 위젯 카탈로그 1차 범위

**Question:** As-Is의 어떤 위젯을 V1에 포함할지? Elementor Pro 전체 흡수는 비현실적.

### O-005 — huni xlsx 정합성

**Question:** 상품마스터·가격표 xlsx와 buysangsang 카탈로그·Shopby mall 카탈로그의 일치도. pq-business-analyst 분석 후 확정.

---

---

# Part 2 — D-PM-* 결정 (02_business 통합 등록, 2026-05-27)

본 섹션은 pq-business-analyst가 02_business/ 산출물 작성 중 식별한 35건의 결정을 PM 로그로 일괄 등록한다.
모든 항목은 **Status: Open** (사용자 결정 대기). "Provisional Answer" 행은 분석가가 제시한 권장 잠정안.
사용자 결정이 회신되면 `Status: Decided` + `Decided On: YYYY-MM-DD`로 갱신, 잠정안과 다른 경우 SUPERSEDED 표기.

⚠ **V1 critical path** 표기: 오픈 전(Big-Bang 컷오버) 반드시 결정되어야 하는 항목 ─ **D-PM-01·03·04·08·10·14·15·17·19·20·21·22·24·28·29·31·32·33·34** (총 19건).

---

## 상품마스터 도메인 (D-PM-01 ~ 03)

### D-PM-01 — 010(라이프)·011(에코백) MES ITEM_CD 미부여 처리

**Status:** **Decided (2026-05-28)** | **Priority:** HIGH | **V1 critical path:** ✅
**Context:** xlsx 상품마스터에 라이프(010)·에코백(011) 카테고리 약 100+ 상품이 `MES ITEM_CD` 컬럼 NULL 상태로 운영 중.
**~~Provisional Answer:~~** ~~신규 시스템 최초 등록 시 카테고리 prefix(`010-NNNN`/`011-NNNN`) + 4자리 일련번호 자동 발급.~~ (취소 — 사용자 결정으로 대체)
**Decision:** `mes_item_cd`는 **외부 MES 시스템과의 연동을 통해 별도 부여**된다. 신규 빌더 시스템은 자동발급하지 않으며, MES 동기화 전에는 NULL 허용. MES에서 코드 부여 작업이 이루어지면 동기화 메커니즘으로 채워진다.
**Rationale:** MES가 단일 진실원(SoT)이며, 신규 빌더가 발급권을 가지면 이중 발급 위험 발생.
**Consequences:**
- Schema `products.mes_item_cd VARCHAR(8) NULL` 유지 + MES 동기화 상태 추적 컬럼(`mes_sync_status`, `mes_synced_at`) 추가
- 가격 엔진 lookup은 internal `product_id`(primary) + `mes_item_cd`(secondary) 양쪽 지원
- 010·011 100+ 상품은 MES 코드 부여 후 동기화로 반영
**Source:** `02_business/product-master.md` §3, §6 PM-MISS-01
**Linked REQ:** REQ-PQ-005, REQ-PQ-019
**Linked INC:** INC-001 / INC-002 (Resolved 2026-05-28)

### D-PM-02 — huni vs buysangsang 카테고리 코드 체계 충돌

**Status:** Open | **Priority:** MED
**Context:** huni xlsx `001-0001` 체계와 buysangsang `1000~2100` 체계가 별개. 직접 매핑 불가.
**Provisional Answer:** 두 체계를 통합하지 않고 **huni MES 체계만 신규 빌더의 정식 SKU로 채택**. buysangsang `product_cat`는 마이그레이션 레퍼런스로만 보존(`legacy_buysangsang_cat`).
**Source:** `02_business/product-master.md` §3, `02_business/cross-mapping.md` §1.1

### D-PM-03 — 상품마스터 무결성 결함(중복 CD 4건) 일괄 보정 시점

**Status:** Open | **Priority:** HIGH | **V1 critical path:** ✅
**Context:** xlsx에 PM-DUP-01~04 (`001-0014`·`002-0002`·`002-0015` 등) MES CD 중복. 마이그레이션 시점 결정 필요.
**Provisional Answer:** **마이그레이션 전 xlsx 측에서 일괄 보정** + 신규 코드 부여 매핑표 작성. (대안: 신규 빌더에서 부여 시 정리)
**Source:** `02_business/product-master.md` §5 (228, 250행 무결성 결함)
**Linked GAP:** GAP-001

---

## 카테고리·SKU 체계 (D-PM-04 ~ 09, from cross-mapping.md)

### D-PM-04 — 정식 SKU 코드 체계 채택

**Status:** Open | **Priority:** HIGH | **V1 critical path:** ✅
**Context:** huni 3자리 prefix(`NNN-NNNN`) vs buysangsang 4자리(`1000~2100`) 중 신규 시스템 정식 코드 결정.
**Provisional Answer:** **huni MES `NNN-NNNN` 유지** ─ buysangsang 코드는 URL slug 표시용으로만 활용.
**Source:** `02_business/cross-mapping.md` §1.1 (line 43)
**Linked REQ:** REQ-PQ-001

### D-PM-05 — buysangsang `accessories` 카테고리 보존

**Status:** Open | **Priority:** LOW
**Context:** buysangsang에 `accessories` 단일 카테고리가 분류 외 잡종 grouping으로 존재. huni 매핑 불명.
**Provisional Answer:** **폐기 후 재배치** ─ 상품을 `12 포장` 또는 해당 라이프 sub-카테고리로 이전.
**Source:** `02_business/cross-mapping.md` §1.2 (line 49)
**Linked GAP:** GAP-004

### D-PM-06 — 라이브 미노출 xlsx 상품 60건 V1 포함 여부

**Status:** Open | **Priority:** MED
**Context:** xlsx에 정의되어 있으나 buysangsang sitemap에는 없는 상품군 약 60건(책자·아크릴 신규·캘린더 디자인 등).
**Provisional Answer:** **V1 = 라이브 225건 + xlsx 검증분 15~20건**, 나머지는 Phase 2.
**Source:** `02_business/cross-mapping.md` §2.2 (line 81)
**Linked GAP:** GAP-003, GAP-007

### D-PM-07 — buysangsang 운영 잔재 cleanup

**Status:** Open | **Priority:** HIGH | **V1 critical path:** ✅
**Context:** buysangsang에 `결제테스트` 등 운영 잔재 1~3건 + Yoast Duplicate Post `~/copy/` URL 추정.
**Provisional Answer:** **마이그레이션 전 일괄 정리**.
**Source:** `02_business/cross-mapping.md` §2.3 (line 90)
**Linked GAP:** GAP-004

### D-PM-08 — 가격 모델 표현 통일안

**Status:** Open | **Priority:** HIGH | **V1 critical path:** ✅
**Context:** As-Is 가격 모델이 3D 단가표(디지털인쇄) vs 1D 할인율 매트릭스(굿즈/아크릴) 양립.
**Provisional Answer:** **2종 공존** ─ `PriceTable3D`(디지털인쇄·코팅·명함·포스터·아크릴 사이즈매트릭스) + `BasePrice + TierDiscount`(굿즈·파우치·문구·아크릴 수량구간).
**Source:** `02_business/cross-mapping.md` §3.3 (line 127), `02_business/pricing-rules.md` §16
**Linked REQ:** REQ-PQ-020~023
**Linked Architecture:** `03_architecture/builder-engine/pricing-engine.md` §1, §3 (PricingCatalog)

### D-PM-09 — Shopby huniprinting48 회원·주문 마이그레이션

**Status:** Open | **Priority:** MED | **Depends on:** O-001, O-003
**Context:** huniprinting48.shopby.co.kr의 회원·주문 데이터를 자체 빌더로 이전할지.
**Provisional Answer:** **O-001/O-003 확정 후 별도 결정**. 잠정: 회원만 이전(주문 이력은 read-only 보존).
**Source:** `02_business/cross-mapping.md` §5 (line 169)

---

## 가격 엔진 (D-PM-10 ~ 16, from pricing-rules.md)

### D-PM-10 — 단가표 보간 정책

**Status:** Open | **Priority:** HIGH | **V1 critical path:** ✅
**Context:** 수량 12장(구간 10과 15 사이) 입력 시 ─ 보수적(10) vs 선형 보간 vs 고객 유리(15).
**Provisional Answer:** **다음 큰 구간 단가(15) 사용** ─ RedPrinting·WOWPress 관행, 고객 추가 구매 유도.
**Source:** `02_business/pricing-rules.md` §3.3 (line 81)
**Linked REQ:** REQ-PQ-023

### D-PM-11 — 포토카드 세트 vs 대량 전환점

**Status:** Open | **Priority:** MED
**Context:** xlsx에 20장 세트(6,000원) vs 20장 대량(5,000원) 동시 정의 → 고객 혼란.
**Provisional Answer:** **20장 = 세트만, 21장+ = 대량 전환**.
**Source:** `02_business/pricing-rules.md` §5 (line 136)
**Linked REQ:** REQ-PQ-031

### D-PM-12 — 박 동판비 정책

**Status:** Open | **Priority:** MED
**Context:** 명함 박가공 동판비 ─ 아연판 5,000원 균일 vs 디자인 복잡도 차등.
**Provisional Answer:** **디자인 인쇄 면적 비례 슬라이딩** (소: 5,000 / 중: 8,000 / 대: 12,000).
**Source:** `02_business/pricing-rules.md` §10 (line 353)

### D-PM-13 — 종이 200종 노출 정책

**Status:** Open | **Priority:** MED
**Context:** 종이 200종 전체 노출 vs 인기 50종만 + "더보기" 필터.
**Provisional Answer:** **인기 50종 + "더보기"** ─ UX 일관성 우선.
**Source:** `02_business/pricing-rules.md` §13 (line 401)
**Linked REQ:** REQ-PQ-033

### D-PM-14 — 최소 주문 단위 일관성

**Status:** Open | **Priority:** HIGH | **V1 critical path:** ✅
**Context:** 명함=100장, 박명함=200장 등 상품별 다른 step. 신규 시스템에서 정책 명시 위치.
**Provisional Answer:** **product master에 `min_qty`, `qty_step` 컬럼 신설**해 명시.
**Source:** `02_business/pricing-rules.md` §14 (line 424)
**Linked REQ:** REQ-PQ-030

### D-PM-15 — VAT 포함/별도 표시 정책

**Status:** Open | **Priority:** HIGH | **V1 critical path:** ✅
**Context:** xlsx 단가가 VAT 포함/별도 명시 없음. 표시 정책 결정.
**Provisional Answer:** **VAT 포함 표시** (소비자보호법 준수) + 세금계산서 발행 시 별도 분리.
**Source:** `02_business/pricing-rules.md` §15 (line 434), `02_business/pricing-rules.md` PRC-008
**Linked REQ:** REQ-PQ-027

### D-PM-16 — 배송비 정책 일괄 확정(중복 항목)

**Status:** Open | **Priority:** HIGH | **Note:** D-PM-31과 동일 항목. **D-PM-31에 통합**.
**Provisional Answer:** D-PM-31 참조.
**Source:** `02_business/pricing-rules.md` §17 (line 446) → policy-checklist.md 위임
**SUPERSEDED by D-PM-31**

---

## 공정 흐름 (D-PM-17 ~ 20, from process-flow.md)

### D-PM-17 — 공정 선행 종속성 강제 정책

**Status:** Open | **Priority:** HIGH | **V1 critical path:** ✅
**Context:** 앞 공정 미완료 시 다음 공정 진행 ─ 강한 차단 vs 경고 후 우회.
**Provisional Answer:** **강한 차단 + 운영자 권한자만 우회 가능** ─ 데이터 무결성 우선.
**Source:** `02_business/process-flow.md` §5.1 (line 145)
**Linked REQ:** REQ-PQ-082

### D-PM-18 — 공정별 SLA 목표 확정

**Status:** Deferred | **Priority:** LOW | **Depends on:** V1 런칭 후 실 측정
**Context:** 공정별 SLA 정량 목표 (예: 검수 24h / 제작 48h).
**Provisional Answer:** **V1 런칭 후 실 측정치로 갱신**. V1에는 측정 인프라만 구비.
**Source:** `02_business/process-flow.md` §6 (line 167)

### D-PM-19 — 상품 ↔ 공정 라우트 매핑 보유 위치

**Status:** Open | **Priority:** HIGH | **V1 critical path:** ✅
**Context:** product master 컬럼 vs 별도 `process_route` 테이블.
**Provisional Answer:** **별도 `process_route` 테이블 + 상품 FK** ─ 다중 라우트 보유 가능.
**Source:** `02_business/process-flow.md` §6 (line 203)
**Linked REQ:** REQ-PQ-003, REQ-PQ-079
**Linked Architecture:** baseline `production_specs`·`production_stage_types` 활용 가능 (schema.sql §1)

### D-PM-20 — 검수 게이트 4단계 도입 여부

**Status:** Open | **Priority:** HIGH | **V1 critical path:** ✅
**Context:** G1·G2·G3·G4 검수 게이트 V1 도입 범위.
**Provisional Answer:** **V1에서 G1·G3·G4 필수**, G2는 V2.
**Source:** `02_business/process-flow.md` §7.1 (line 220)
**Linked REQ:** REQ-PQ-088

---

## 주문 라이프사이클 (D-PM-21 ~ 29, from order-flow.md)

### D-PM-21 — 가상계좌 미입금 자동취소 시점

**Status:** Open | **Priority:** HIGH | **V1 critical path:** ✅
**Context:** 현 PDF "미정 ??일". 자동취소 시한 결정.
**Provisional Answer:** **3일** (1일전 알림 → 익일 자동취소).
**Source:** `02_business/order-flow.md` §2.1 (line 131)
**Linked REQ:** REQ-PQ-045

### D-PM-22 — 알림톡/SMS 우선순위 fallback

**Status:** Open | **Priority:** HIGH | **V1 critical path:** ✅
**Context:** 알림 채널 우선순위.
**Provisional Answer:** **알림톡 우선 + 실패 시 SMS** (Kakao Business 사전 동의 회원만 알림톡).
**Source:** `02_business/order-flow.md` §3 (line 133)
**Linked REQ:** REQ-PQ-049

### D-PM-23 — 오프라인 주문 통합 정책

**Status:** Open | **Priority:** MED
**Context:** 오프라인 주문을 자체 빌더 order 엔티티에 통합 vs 별도 ERP 트랙.
**Provisional Answer:** **동일 `order` 엔티티 + `channel='offline'` 플래그** ─ 통계·정산 통합 유리.
**Source:** `02_business/order-flow.md` §5.2 (line 195)
**Linked REQ:** REQ-PQ-109

### D-PM-24 — 파일명 RENAME 자동화 범위

**Status:** Open | **Priority:** HIGH | **V1 critical path:** ✅
**Context:** Pain point #5.1 핵심. RENAME 자동화 범위.
**Provisional Answer:** **빌더에서 주문 생성 시 100% 자동 RENAME** ─ Pain point 완전 해결.
**Source:** `02_business/order-flow.md` §7 (line 322)
**Linked REQ:** REQ-PQ-066

### D-PM-25 — 4/5도 별색 파일명 표기

**Status:** Open | **Priority:** MED
**Context:** 아크릴 등 4도/5도 + 칼선 양단면 파일명 구분.
**Provisional Answer:** **옵션1 슬롯에 `5도CYMK+W` 형태로 명시** ─ 별색 슬롯 추가.
**Source:** `02_business/order-flow.md` §7 (line 324), PDF p.6 메모
**Linked REQ:** REQ-PQ-067

### D-PM-26 — 부분환불 처리 정책

**Status:** Open | **Priority:** MED
**Context:** PDF 명기: "부분환불 → 취소처리 안함(매출과 맞지 않음)" 회계상 매출 무결성.
**Provisional Answer:** **메모필드만 활용** ─ 매출은 원금 유지, 환불액은 별도 계정 처리.
**Source:** `02_business/order-flow.md` §8 (line 345)
**Linked REQ:** REQ-PQ-056

### D-PM-27 — 세금계산서 자동화 V1/V2 분리

**Status:** Open | **Priority:** MED
**Context:** V1 수동 발행 vs V2 팝빌 자동 연동.
**Provisional Answer:** **V1 = 정보 수집만**, V2 = 팝빌 자동 발행.
**Source:** `02_business/order-flow.md` §9 (line 354)

### D-PM-28 — 파일 포맷 강제 검증

**Status:** Open | **Priority:** HIGH | **V1 critical path:** ✅
**Context:** 인쇄타입별 PDF/JPG/AI 포맷 강제 검증.
**Provisional Answer:** **V1부터 강제 검증** ─ 이외 파일 거부.
**Source:** `02_business/order-flow.md` §10.1 (line 383)
**Linked REQ:** REQ-PQ-064, REQ-PQ-065

### D-PM-29 — To-Be 파일 인프라 결정

**Status:** Open | **Priority:** HIGH | **V1 critical path:** ✅ | **Linked ADR:** ADR-002, ADR-003
**Context:** 현 As-Is: AWS S3 + 자체 NAS + 호스팅 서버 분산. Big-Bang 컷오버 핵심.
**Provisional Answer:** **AWS S3 단일 통합 + CloudFront CDN**.
**Source:** `02_business/order-flow.md` §13 (line 491)
**Linked REQ:** REQ-PQ-115

---

## 운영 정책 (D-PM-30 ~ 35, from policy-checklist.md + glossary.md)

### D-PM-30 — 수작(SUJAK) 브랜드 존치 여부

**Status:** **Decided (2026-05-30)** | **Priority:** MED | **Owner:** 지니
**Context:** As-Is buysangsang에 별도 노출. To-Be 존치/통합/폐지.
**~~Provisional Answer:~~** ~~존치 ─ 차별화된 브랜드 자산.~~ (1차 권장안 — 존치 판단은 유지하되 V1 범위 결정으로 구체화)
**Decision (2026-05-30):** **V1 제외 → V2 재평가로 이연 (폐기 아님).** "존치 권장" 판단은 **V2 재평가 시점으로 carry**한다. 수작 브랜드 자산·상품 데이터는 **보존**(삭제 금지)하며, glossary·IA에서 **V2 항목으로 유지**한다.
- SM-M-07 / SC-M-07 (수작 상품 메인) → **V2**
- SM-A-21 / SC-A-21 (수작 상품등록) → **V2**
- V1 GNB 카테고리·관리자 LNB에서 수작은 **비노출**(V2 진입점).
**Rationale:** 차별화 자산 가치는 인정하나 V1 런칭 필수성·구현 우선순위에서 후순위. 자산 보존 상태로 V2 재평가에서 노출 방식·통합 여부 재결정.
**Consequences:**
- sitemap.md·ia.md·screen-inventory.md 수작 행 V2 갱신 (2026-05-30 반영 완료)
- glossary.md / IA에 SUJAK는 V2 항목으로 존치(다음 갱신 시 표기 확인 권고 — 본 라운드 범위 외, 잔여 정합 항목)
**Source:** `02_business/policy-checklist.md` §3.4 (line 109)
**Linked:** D-DS-33 (사이트맵 범위 확정)

### D-PM-31 — 배송비 정책 6개 항목 일괄 확정 ⭐ V1 CRITICAL PATH ⭐

**Status:** Open | **Priority:** HIGH | **V1 critical path:** ✅ **(BLOCKER)**
**Context:** policy-checklist.md §5.1 운영정책 #1~#6 일괄 결정 필요. 가격 엔진의 Step 6(Tax & Shipping) 완성도가 본 결정에 종속.
**Provisional Answer (권장 통합안):**
- (1) 무료배송 기준: **10만원 이상**
- (2) 기본 배송비: **3,000원**
- (3) 배너상품 무료배송 제외: **제외**
- (4) 혼합주문 배송비: **최고값 1건 적용**
- (5) 제주 추가: **+5,000원**
- (6) 도서산간 4구간:
  - 울릉도/제주외 도서 +3,000
  - 중간 거리 도서 +5,000
  - 원거리 도서 +7,000
  - 극원거리(독도 등) +10,000

**Source:** `02_business/policy-checklist.md` §5.1 (line 170)
**Linked REQ:** REQ-PQ-053, REQ-PQ-054, REQ-PQ-055
**Linked Architecture:** `03_architecture/builder-engine/pricing-engine.md` §1 Step 6, schema.sql `shipping_fee_rules`
**Blocking:** 가격 엔진 통합 테스트 T-09, M3 화면(주문서 배송지 입력 UI), 결제 UI 총액 표시

### D-PM-32 — PG 정책 일괄 확정

**Status:** Open | **Priority:** HIGH | **V1 critical path:** ✅
**Context:** policy-checklist.md §5.2 운영정책 #7~#11 일괄.
**Provisional Answer:** **이니시스 유지** + 네이버페이 1차 + 카카오페이/토스페이 2차.
**Source:** `02_business/policy-checklist.md` §5.2 (line 182)
**Linked REQ:** REQ-PQ-050

### D-PM-33 — 쿠폰 정책 10건 일괄 확정

**Status:** Open | **Priority:** HIGH | **V1 critical path:** ✅
**Context:** policy-checklist.md §5.3 #12~#21 일괄.
**Provisional Answer:** **권장값 일괄 채택** ─ 회원 분리(신규/VIP/리뷰) 자동화.
- 신규회원 10,000 (최소 50,000 주문 / 30일 유효)
- 리뷰유도 5,000 (배송완료 14일)
- 재구매 20,000 (월 200,000 기준)
- VIP 30,000 (연 1,000,000 기준)
- 동시사용 최대 3개

**Source:** `02_business/policy-checklist.md` §5.3 (line 199)
**Linked REQ:** REQ-PQ-101, REQ-PQ-102, REQ-PQ-103

### D-PM-34 — 리뷰 정책 4건 일괄 확정

**Status:** Open | **Priority:** HIGH | **V1 critical path:** ✅
**Context:** policy-checklist.md §5.4 #22~#25.
**Provisional Answer:** **권장값 일괄 채택**.
- 등록 방식: 즉시
- 작성 보상: 5,000원 쿠폰
- 삭제 시 쿠폰 회수: 자동 회수
- 사진 리뷰 가산: +1,000원

**Source:** `02_business/policy-checklist.md` §5.4 (line 210)
**Linked REQ:** REQ-PQ-105, REQ-PQ-106

### D-PM-35 — UI 라벨 외부 브랜드명 노출 정책

**Status:** **Decided (2026-05-28)** | **Priority:** MED
**Context:** Edicus, Aurora, MShop, Shopby 등 외부 브랜드명 사용자 노출 여부.
**Decision:** **잠정안 A 채택 — 노출 금지.** 모든 외부 브랜드명을 후니 자체 브랜드 라벨로 변환.

**라벨 변환표:**

| 외부 브랜드 | 사용자 노출 라벨 | 내부 문서 표기 |
|---|---|---|
| Edicus | "에디터" 또는 "디자인 에디터" | Edicus |
| Aurora | "쇼핑몰 운영" (내부 노출 시) | Aurora |
| MShop | "모바일 쇼핑몰" | MShop |
| Shopby | (사용자 노출 없음, 백엔드 전용) | Shopby |

**Source:** `02_business/glossary.md` §11
**Linked REQ:** REQ-PQ-117

---

### D-PM-36 — 전건 선결제 / 후불·여신 미운영 (B2B 정산 모델 확정)

**Date:** 2026-05-31
**Status:** **Decided** | **Owner:** 지니 | **Priority:** HIGH (결제·커머스·B2B 화면 범위 파급 결정)
**Label:** 전건 선결제 / 후불·여신 미운영

**Context:** Wowpress 회원영역 로그인 크롤(mypage-benchmark v1.2)에서 B2B 후불·여신 정산 기능군 4건(미납금결제 `upay`·전용계좌관리 `vant`·거래원장/입출금 `deal`·`deal/amt`·작업자(다중담당자)관리 `worker`)이 식별됨. 이들은 단일 핵심 결정 "후니가 후불/여신 거래처를 운영하는가?"에 운명이 종속(benchmark §3-16). 추측 금지로 owner 결정 대기 중이었음.

**Decision (owner 지니, 2026-05-31):** 후니는 **모든 주문을 선결제**(카드/가상계좌/프린팅머니 선충전)로 운영하며, **B2B 후불/여신/월정산을 운영하지 않음.** As-Is 프린팅머니(선충전) 모델과 일관.

**귀결 — Wowpress B2B 후불 4건 V1·V2 전부 제외(설계 안 함):**

| # | 항목 | Wowpress 경로 | 제외 사유 | 대체 |
|---|---|---|---|---|
| 1 | 미납금 결제 | `upay/list` | 후불 미납분 일괄정산 = 여신 거래 핵심 UI. 선결제 모델에 불필요 | 전건 선결제로 미납 개념 부재 |
| 2 | 전용계좌 관리 | `vant/form` | 거래처 고정 전용 가상계좌(후불 입금식별). 일반 PG 가상계좌(주문별 1회성)로 충분 | 이니시스 가상계좌(SM-Q-12.2) |
| 3 | 거래원장·입출금내역 | `deal/list`·`deal/amt` | 거래처 단위 매출/입금/잔액 원장 = 여신 회계. 선결제는 주문조회+증빙으로 충분 | SM-MY-01 주문조회 + SM-MY-12 증빙서류(거래명세서 SM-MY-12.4 포함) |
| 4 | 작업자(다중담당자) 관리 | `worker/list` | 기업 1계정 멀티유저·권한분리. 멀티유저 미지원(1계정 1사용자) | 거래처별 단일 계정 |

**Rationale:** 4건 제외는 "전건 선결제" 정책의 **논리적 귀결**(단순 누락·생략 아님). 후불·여신이 없으므로 미납·전용계좌·여신원장·멀티유저 발주 워크플로우 자체가 성립하지 않음. 증빙·조회 요구는 SM-MY-01(주문조회)·SM-MY-12(증빙, 거래명세서/세금계산서/현금영수증)로 선결제 모델 내에서 충족.

**Consequences:**
- `04_design/sitemap.md §1`·`screen-inventory.md §4.1.2`: 4건 제외를 "정책 귀결"로 명시 기록(게이트). 채번 미부여
- **결제 설계 연결(반영 링크 메모):** `00_pm/payment-launch-readiness.md` — 선결제 PG(이니시스 카드/가상계좌)·프린팅머니 선충전 외 후불 게이트웨이 불요
- **커머스 백엔드 연결(반영 링크 메모):** `02_business/commerce-backend-scenario.md` B-2 — 주문·결제 상태머신에 후불(미수/여신) 상태 미포함, 회원 엔티티 멀티유저 미설계
- KPI(xlsx V1 85/V2 27/V1? 0) 불변 — 벤치마크 외 항목 제외이므로 카운트 변화 없음
- B2B 멤버십 등급(D-DS-39 보류)은 본 결정과 별개(혜택채널은 쿠폰·프린팅머니·회원할인율로 유지)

**Source:** `04_design/mypage-benchmark.md` §3-11/§3-14/§3-15/§3-16, §4-C2
**Linked:** D-DS-40(같은 라운드 화면 결정), `payment-launch-readiness.md`, `commerce-backend-scenario.md` B-2, D-PM-32(PG 정책)

---

### D-PM-37 — Open-Core 범위 확정 + V1→Open-Core / V1.1 시점 분할

**Date:** 2026-05-31
**Status:** **Decided** | **Owner:** 지니 | **Priority:** HIGH (3개월 오픈 범위·M3 화면 우선순위 파급)
**Label:** Open-Core 범위 확정 (Edicus 포함 · 게스트 허용 · 상품군 순차 오픈) + V1.1 시점 분할
**Linked:** `00_pm/open-core-scope.md`(단일 기준), D-003(Edicus SDK), D-005/ADR-004(V-001), D-PM-32(PG), D-PM-35(브랜드 라벨), D-PM-36(전건 선결제), D-DS-33/36/38/40

**Context:** 오너(지니)가 "3개월 내 오픈"을 위해 V1을 "Open-Core"(견적→주문→결제 핵심 플로우 + 최소 관리자)로 압축하기로 결정(open-core-scope.md). 그 과정에서 owner 판별이 필요했던 3건(Edicus 에디터 필수 여부 / 게스트결제 허용 V-001 / 취급 상품군 범위)이 차단 의존성으로 남아 있었음. 2026-05-31 오너가 3건을 확정.

**Decision (owner 지니, 2026-05-31) — 3건 확정:**

1. **Edicus 디자인 에디터 = Open-Core 포함.** 고객 디자인 파일 준비 경로로 **파일업로드 + 편집기 둘 다 필수.** Open-Core 고객 화면에 디자인 에디터 진입(Edicus iframe+SSO 최소 연동, partner="hunip", D-003 외부 SDK 유지) + 파일업로드 둘 다 포함. 편집기 전용 상품군도 Open-Core에서 주문 완주 가능해야 함. (저장디자인 라이브러리·디자인의뢰 풀 워크플로우는 V1.1.)
2. **비회원(게스트) 주문 허용 (V-001 = 게스트결제 허용).** 이니시스 표준결제(카드/가상계좌)로 비회원 주문 가능. Open-Core에 비회원 주문조회(주문번호+연락처) 경로 포함. 회원가입은 선택. **간편결제**: 네이버페이/토스페이 등은 필수 아님 — 이니시스 **통합형(허브형)**으로 별도계약 없이 추가하는 "있으면 좋은" 옵션. 네이버페이 주문형 등 직접계약형은 V1.1.
3. **취급 상품군 = 대표 상품군 우선 + 순차 오픈.** 오픈 시 전체 상품 아닌 우선 상품군부터. **구체적 우선 상품군 선정은 실무진 협의 항목**(추측 금지 — "실무진 협의 대기"). Open-Core 화면/프로토타입은 **상품군 비종속(상품 마스터 데이터 구동)**으로 설계해 어떤 상품군이 와도 동작하도록.

**V1 → Open-Core / V1.1 시점 분할 (철회 아님):**

D-DS-33(B2B 상담 3종 V1)·D-DS-36(찜/저장디자인 V1)·D-DS-38(증빙/주소록/내견적함 V1)·D-DS-40(재작업신청 V1)의 V1 확정분 중 **고객 주문 완주에 비필수인 항목은 V1.1 시점으로 이연**한다. 이는 해당 V1 결정의 **철회가 아니라 오픈 시점 분할**(Open-Core 우선 오픈 vs V1.1 후속 오픈)이며, 그 작업·결정은 **V1.1 범위로 유효**하다.

**Rationale:** 디자인 에디터는 후니 인쇄 주문의 핵심 차별 경험이자 편집기 전용 상품군 완주 필수 경로이므로 최소 연동이라도 Open-Core 포함이 타당. 게스트 허용은 전환 마찰 최소화(회원 강제 제거). 상품군 순차 오픈은 3개월 일정 내 카탈로그 세팅 부하 통제 — 단 화면을 상품 마스터로 구동(상품군 비종속)하면 우선 상품군 미확정이 화면 설계를 차단하지 않음.

**Consequences:**
- `00_pm/open-core-scope.md` 갱신: 상품군 비종속 설계 원칙(상단), OC-C-05.1 Edicus 에디터 진입 신설, OC-C-08 간편결제 통합형 옵션·게스트 명기, OC-C-11 게스트 주문조회 필수 확정, §4 구 순위 3·4 해소 + 우선 상품군(실무진 협의) 신규, §5 고객 17→18행·총 33→34행
- **Open-Core 화면 수:** 고객 17→**18행**(Edicus 에디터 진입 OC-C-05.1 +1), 관리자 16행, **총 34행**(압축률 약 35%)
- **차단 의존성:** 구 ③Edicus 필수 여부·④게스트결제 허용 **해소**. 신규 ③ = 우선 상품군 선정(실무진 협의 대기)이나 상품군 비종속 설계로 화면 비차단
- 아키텍처 결정(D-004 옵션 C·B-2·D-003 Edicus·이니시스) 불변 — 범위·우선순위만 조정
- V-001(D-005/ADR-004 잔여 검증항목)은 본 결정으로 정책 확정 — Shopby 미경유 자체 결제 흐름으로 게스트 허용
- KPI(xlsx V1 85/V2 27/V1? 0) 불변 — Open-Core는 V1의 부분집합 분류이며 카운트 체계 변경 아님

**실무진 협의 대기 (HARD — 추측 금지):**
- **Open-Core 우선 상품군 선정** — 대표 상품군 우선·순차 오픈. 구체 상품군은 실무진 협의. 화면 설계는 비차단(상품 마스터 구동), 카탈로그 시드 채움 시점에만 협의 결과 필요.

**Source:** `00_pm/open-core-scope.md`(전면), 오너 결정(2026-05-31)

---

# Part 2b — D-DS-* 화면설계 결정 (04_design 통합 등록)

pq-designer가 04_design/ 산출물에 인라인으로 표기한 잠정 결정(D-DS-20~32)은 sitemap.md §5 / ia.md §7 / screen-inventory.md §6에서 참조한다. 본 섹션은 그중 **사용자 확정이 필요했던 범위 결정**을 정식 등록한다.

### D-DS-33 — V1? 범위 9건 확정 (B2B 상담 / 부가 화면 / 수작)

**Date:** 2026-05-30
**Status:** **Decided** | **Owner:** 지니 | **Priority:** HIGH (M3 화면 범위 확정)
**Context:** sitemap v2.0에서 모호 항목 9건을 `V1?`(담당자 협의)로 마킹. M3 화면 설계·M5 SPEC 분할 전 V1/V2 확정 필요. (실제 기능행 기준 V1? 10행 — 관리자 §4.1 표가 V1?=4로 1건 누락 기재되어 있었음, 본 결정에서 정정.)

**Decision (owner 지니, 2026-05-30):**

| 항목 | 화면 | 결정 |
|---|---|---|
| B2B 대량주문 견적문의 | SM-CS-04 / SC-CS-04 + 답변 SM-A-32 / SC-A-32 | **V1** |
| B2B 기업인쇄상담 | SM-CS-05 / SC-CS-05 + 답변 SM-A-33 / SC-A-33 | **V1** |
| B2B 디자인상담 | SM-CS-06 / SC-CS-06 + 답변 SM-A-34 / SC-A-34 | **V1** (V2→V1 승격) |
| 현금영수증 정보 | SM-MY-12.3 / SC-MY-12.3 | **V1** |
| 이용후기 메인 | SM-M-05 / SC-M-05 | **V1** |
| 수작 상품 메인 | SM-M-07 / SC-M-07 | **V2** (D-PM-30 참조) |
| 수작 상품등록 | SM-A-21 / SC-A-21 | **V2** (D-PM-30 참조) |
| 원장 계좌관리 | SM-A-04 / SC-A-04 | **V2** |
| 굿즈 발주·정산 | SM-A-55 / SC-A-55 | **V2** |

**⚠ 복잡도 캐비엇 (디자인상담):** SM-CS-06/SC-CS-06 및 답변 SM-A-34/SC-A-34는 **단순 게시판 폼이 아님.** `Inquiry + DesignProject` 이중 엔티티 + 외부 디자인 편집기(Edicus, `editor_slot` iframe) 결합 → 높은 구현 복잡도. 백엔드 종속 = `자체+에디터`. **SPEC 분할 시 B2B 게시판(SC-CS-04/05)과 별도 SPEC으로 분리하고 우선순위를 ME로 격리** 권고. (위치: `screen-inventory.md §1.3` 캐비엇 박스, `sitemap.md` SM-CS-06/SM-A-34 행 비고.)

**Rationale:** B2B(30~50% 비중, D-005)는 견적·상담 진입이 런칭 필수. 후기·현금영수증은 전환·증빙 코어. 수작·원장계좌·굿즈정산은 V1 필수성 낮아 V2.

**Consequences:**
- sitemap.md §1 카운트 갱신: xlsx 112 → **V1 85 / V2 27 / V1? 0** (관리자 V1?=5 정정)
- ia.md GNB에 디자인상담 V1 추가, 수작 GNB 진입 V2 비노출, 관리자 LNB 마커 갱신
- screen-inventory.md 10행 V 갱신 + 디자인상담 캐비엇 + 우선순위 LO→ME 2건
- 아키텍처 결정(B-2, 에디터, 이니시스) 불변 — 범위만 조정
**Source:** `04_design/sitemap.md` §2.3/§2.6/§3, `screen-inventory.md` §1.3/§4.1
**Linked:** D-PM-30(수작), D-005(B2B 비중), REQ-PQ-030/062/099/105
**Linked INC:** 없음 (해당 화면 관련 INC 미존재 — consistency-report §축(d) M3 신규 검증 대상)

### D-DS-34 — 생산·출고 운영 별도트랙 최소형 V1 확정

**Date:** 2026-05-30
**Status:** **Decided** | **Owner:** 지니 | **Priority:** HIGH
**Context:** sitemap §4 별도트랙(공정관리 PDF·D-PM 파생)의 V1 최소형 필요 여부를 `V1?`로 마킹. 단일 관리자 V1 운영에 필요한 최소 화면 확정 필요.

**Decision (owner 지니, 2026-05-30):**
- **V1 (최소형):** TR-SYS(알림/배송비/PG 설정·감사로그), TR-CLAIM(클레임 최소형), TR-PROC-1(상품-공정 매핑 최소), TR-PROC-4 중 송장·명세서. 단일 관리자 V1은 주문서출력(SM-A-63)·상태변경(SM-A-64/67)으로 생산운영 최소 대체.
- **V2:** TR-PROC-2(발주 워크큐 분리), TR-PROC-3(바코드 워크큐), 조직/세분권한 분리, TR-IMP(OEM IMPORT, 기존 V2).
- **미확정:** TR-BLD(빌더 7종) — O-004 종속, V1? 유지.

**Rationale:** 결제·배송·알림 동작 전제 설정(TR-SYS)과 환불 인접 클레임(TR-CLAIM)은 런칭 운영 필수. 바코드·발주 워크큐 분리는 세분권한(V2)과 함께 이연하여 V1 범위·일정 통제.

**Consequences:**
- sitemap.md §4 별도트랙 표 V column 갱신, ia.md 관리자 LNB 별도트랙 라인 갱신, screen-inventory.md §3 갱신 (2026-05-30 반영 완료)
- M5 SPEC 분할 시 "생산운영 최소형" SPEC을 워크큐 SPEC(V2)과 분리
**Source:** `04_design/sitemap.md` §4, `screen-inventory.md` §3
**Linked:** D-PM-31(배송비), D-PM-32(PG), D-PM-22(알림), O-004(빌더)

---

### D-DS-36 — 디자인 자산 3중구조 분리 + As-Is 완전성 검증 반영

**Date:** 2026-05-30
**Status:** **Decided** | **Owner:** 지니 | **Priority:** MED (M3 화면 완전성)
**Context:** As-Is 역공학(로그인 크롤 2026-05-30, `01_research/asis-huniprinting/ia-sitemap.md` §3/§4)에서 master(112건)가 놓친 실운영 회원영역 화면이 발견됨. 오너(지니)가 이를 인벤토리·사이트맵에 반영하기로 결정. 특히 master가 "옵션보관함 1건"으로 압축한 디자인 자산이 실제로는 **별개 도메인 3+1종**임을 확인.

**핵심 통찰 — 디자인 자산 3중구조:** 관심상품(`save`)·저장디자인(`save_design`)·디자인의뢰(`sangsang`)는 각기 다른 도메인 엔티티를 가진 별개 자산이며, 인쇄옵션보관함과도 구분된다. 재주문·디자인 재사용 UX의 핵심.

**Decision (owner 지니, 2026-05-30):**

1. **디자인 자산 도메인 분리** (master "옵션보관함 1건" 압축 교정):

| 자산 | As-Is 경로 | 도메인 엔티티 | 화면 ID | V |
|---|---|---|---|:-:|
| 저장된 인쇄옵션(옵션보관함, 의미 한정) | (옵션보관함) | Quote/QuoteLine | SM-MY-02/SC-MY-02 (기존) | V1 |
| 관심상품(찜) | `mypage/save` | Wishlist/Product | SM-MY-13/SC-MY-13 (신규) | V1 |
| 저장된 디자인 | `mypage/save_design` | DesignProject/ArtworkFile | SM-MY-14/SC-MY-14 (신규) | V1 |
| 디자인의뢰 내역 | `mypage/sangsang` | Inquiry+DesignProject | SM-MY-15/SC-MY-15 (신규) | V2 |

2. **As-Is 누락 화면 V1/V2 잠정 분류** (표준 커머스/CS=V1, 부가=V2, 용도미상=확인대기):

| 화면 | ID | 분류 | 근거 |
|---|---|:-:|---|
| 관심상품(찜) | SM-MY-13/SC-MY-13 | **V1** | 표준 커머스 |
| 저장된 디자인 | SM-MY-14/SC-MY-14 | **V1** | 재주문 UX 핵심 |
| 운영 안내 팝업 4종 (도장·업로드·웹하드·디자인안내) | SM-M-13/SC-M-13 | **V1** | 인쇄 커머스 고객 안내 자산 |
| 디자인의뢰 내역 | SM-MY-15/SC-MY-15 | **V2** | 의뢰 자체(SM-Q-14) V2 연동 |
| 통합 게시판(내 게시글) | SM-MY-16/SC-MY-16 | **V2** | 개별 게시판 V1 커버, 통합 뷰는 부가 |
| (용도미상 thm) | SM-MY-17/SC-MY-17 | **확인대기** | **추측 금지(HARD) — 라벨 미확인** |

3. **master 정합 확인분 (추가 불필요):** 프린팅머니(`money`)=IA-11 존재, 상품문의(`pqna`)=IA-12 존재(1:1문의와 별도 게시판 유지 권고).

**Rationale:** 찜·운영안내·저장디자인은 실운영 표준 자산으로 V1 필수. 디자인 자산 분리는 재주문/재사용 UX 강점이므로 도메인 모델 분리 필수. thm은 용도 불명이므로 임의 기능 부여 시 인벤토리 무결성 손상 — 확인대기 보류.

**Consequences:**
- `huni-ia-master.md §F` 신설, 카운트 112→116 (IA-A1·A2·A3·A5; thm=IA-A4는 카운트 제외)
- `sitemap.md §2.2.1/§2.5/§5/§6` 갱신, `screen-inventory.md §1.2/§1.5/§4.1.1/§6/§7` 갱신
- 보강분(화면 5 + 확인대기 1)은 **xlsx 112 외 별도 집계** — status.md KPI(V1 85/V2 27/V1? 0)는 불변, 보강 라인 별도 추가
- 도메인 모델(pq-architect)에 Wishlist 엔티티 신설 + DesignProject 저장본 모델 검토 필요 (consistency-report 후속 축 — INC 신규 후보)
**Source:** `01_research/asis-huniprinting/ia-sitemap.md` §3/§4, `02_business/huni-ia-master.md §F`
**Linked:** D-DS-37(답습 금지 게이트), D-PM-08(가격모델), IA-9/IA-32

### D-DS-37 — As-Is 기술구조·나쁜 IA 패턴 답습 금지 게이트

**Date:** 2026-05-30
**Status:** **Decided** | **Owner:** 지니 | **Priority:** HIGH (아키텍처 불변 보호)
**Context:** As-Is 완전성 검증 반영(D-DS-36) 시 As-Is의 나쁜 IA 패턴까지 따라가는 것을 방지하는 게이트 필요. As-Is는 상품 유형별로 5종의 물리적 URL 분기(`product/list`·`product/goods`·`goods/view`·`package/view`·`design/sangsang`)를 운영한다(ia-sitemap §1.1).

**Decision:** As-Is 반영은 **완전성 검증 + 숨은 로직 발굴 목적에 한한다.** As-Is의 기술구조·나쁜 IA 패턴은 답습하지 않는다.
- **상품 5경로 물리분기 → 답습 금지.** To-Be는 Next.js `productType` 판별 기반 **단일 상세 라우트 + 유형별 옵션/주문 위젯 슬롯**으로 통합(D-004 옵션 C, sitemap SM-Q-01~04 기존 결정과 정합).
- 회원영역 LNB·정보 팝업 등 **기능 완전성**은 반영하되, 그 구현 방식(레거시 ASP 경로 구조)은 반영하지 않는다.

**Rationale:** D-004(자체 빌더 100%)·D-DS-20~24의 단일 라우트 아키텍처를 보호. As-Is 크롤은 "무엇을 운영하는가(완전성)"의 출처이지 "어떻게 구현하는가(구조)"의 출처가 아니다.

**Consequences:**
- sitemap/screen-inventory 보강 화면은 To-Be ID 체계(SM-/SC-)로만 등록, As-Is 경로는 출처 주석으로만 보존
- 상품 카탈로그 라우팅은 기존 단일 라우트 결정 불변
**Source:** `01_research/asis-huniprinting/ia-sitemap.md` §1.1 시사점
**Linked:** D-004(옵션 C), D-DS-36

### D-DS-38 — 경쟁사 마이페이지 벤치마크 V1 반영 (배송주소록·거래명세서/견적서 출력·내견적함·미입금필터)

**Date:** 2026-05-30
**Status:** **Decided** | **Owner:** 지니 | **Priority:** HIGH (M3 화면 완전성·B2B 필수)
**Context:** 경쟁사 마이페이지 벤치마크(2026-05-30, `04_design/mypage-benchmark.md` §3/§4 — RedPrinting 로그인 크롤 성공·Wowpress 메뉴 골격)에서 우리 SM-MY IA가 놓친 **B2B 필수 기능 4건**이 발견됨. 3원칙 게이트(완전성 검증·숨은 로직)로 판별한 결과 "표준 누락"으로 확정되어 오너(지니)가 V1 반영 결정. (게이트 통과 사유: 배송주소록·거래명세서·견적서는 한국 인쇄 B2B 상거래 표준 서류/기능으로 "멋진 기능 답습"이 아닌 "필요한 표준의 누락".)

**Decision (owner 지니, 2026-05-30) — V1 누락 4건 반영:**

| # | 항목 | 화면 ID | 종류 | V | 핵심 |
|---|---|---|---|:-:|---|
| 1 | 배송주소록 관리 | SM-MY-18 / SC-MY-18 | **신설** | V1 | 다중 배송지 저장/관리. 인쇄 B2B(반복 지점/현장 배송) 필수. **엔티티 `Address`(domain-model §3.2 기존) 연결** — 신규 엔티티 아님 |
| 2a | 거래명세서 출력 | SM-MY-12.4 / SC-MY-12.4 | **신설** | V1 | 주문번호 선택→거래명세서 PDF. 세금계산서(12.2)와 별개 납품 첨부 서류. 기존 증빙(SM-MY-12)에 추가 |
| 2b | 견적서 출력 | SM-MY-12.5 / SC-MY-12.5 | **신설** | V1 | 주문번호 선택→견적서 PDF. 구매 품의·내부 결재용. 내 견적함(SM-MY-02)에서도 출력 진입 연계 |
| 3 | 옵션보관함 → "내 견적함" 격상 | SM-MY-02 / SC-MY-02 | **보강** | V1 | 단순 옵션저장 → 재주문 진입점 + 견적서 출력(12.5) 연계 + 가격 재계산. 인쇄옵션(Quote/QuoteLine) 의미한정 유지(디자인자산 3중구조, D-DS-36 정합) |
| 4 | 미입금 주문 필터 보강 | SM-MY-01 / SC-MY-01 | **보강** | V1 | 무통장 입금대기 상태 필터·강조 배너(가상계좌·마감시한). **별도 화면 신설 금지** — 단일 주문조회+필터 유지 |

**채번 검증:** 기존 SM-MY는 01~17 사용(SM-MY-12 하위 12.1~12.3 포함). 신규 **SM-MY-18·SM-MY-12.4·SM-MY-12.5**는 중복 없음(HARD 제약 충족). 출처 라벨 `BENCH` 신설(sitemap §0).

**Rationale:** 배송주소록은 B2B 반복배송 마찰 제거 필수(다중 배송지). 거래명세서·견적서 PDF는 B2B 구매·납품 서류로 명백한 누락(증빙 SM-MY-12가 현금영수증·세금계산서만 커버). 내 견적함은 견적서비스 본질(재주문·견적산출 진입점). 미입금 필터는 입금대기 소멸 방지(별도화면은 과함 → 필터로 경량화).

**Consequences:**
- `sitemap.md §0/§1/§2.2/§2.2.1/§5/§6` 갱신 (신설 3 + 보강 2, BENCH 라벨, 벤치마크 보강 집계 라인)
- `screen-inventory.md §1.2/§4.1.2/§6/§7` 갱신 (신설 3행 + 보강 2행, SC-MY-01 엔티티 Payment 추가)
- 신설 3건(SM-MY-18/12.4/12.5)은 **xlsx 112 외 별도 집계** → status.md KPI(V1 85/V2 27/V1? 0) **불변**. 보강 2건은 기존 행이므로 카운트 불변
- **도메인 모델 후속 정합(MED):** SM-MY-18은 기존 `Address`(§3.2) 재사용 — 신규 엔티티 불요. 단 거래명세서/견적서 PDF는 출력 산출물이므로 신규 엔티티 없이 Order/Quote 조회로 충분. (consistency-report 후속 축 — 신규 엔티티 미발생 확인)
- 아키텍처 결정(D-004 옵션 C·B-2·에디터·이니시스) 불변 — 화면 범위만 추가
**Source:** `04_design/mypage-benchmark.md` §3-1/§3-2/§3-3/§3-6, §4-A
**Linked:** D-DS-36(디자인자산 3중구조·옵션보관함 의미한정), D-DS-39(제외 게이트), domain-model §3.2 Address, REQ-PQ-054/055/062
**Linked INC:** 없음 (신규 엔티티 미발생 — Address 재사용)

### D-DS-39 — i.토큰류 답습 제외 게이트 + 보류 항목 미확정 보존

**Date:** 2026-05-30
**Status:** **Decided** | **Owner:** 지니 | **Priority:** HIGH (답습 방지 게이트·아키텍처 모델 보호)
**Context:** 마이페이지 벤치마크에서 RedPrinting의 i.토큰(`order_token`)·상품상태별 분리화면 등 "경쟁사 고유 기능"이 발견됨. 3원칙 게이트(D-DS-37 계열)상 "멋진 기능 답습"과 "표준 누락"을 분별해야 함. 오너(지니)가 답습 위험 항목을 명시 제외로 확정.

**Decision (owner 지니, 2026-05-30):**

**제외 (답습 위험 — 게이트 적용):**
1. **i.토큰 (주문 재판매/공동구매 중개)** → **V1·V2 모두 제외(설계 안 함).** 한 유저가 사양을 토큰화→타인이 재주문·발행자 포인트 지급하는 준-재판매/공동구매 중개 모델. RedPrinting 도매·리셀러 생태계 특화로 **후니 직접제작 모델에 부적합.** 토큰 발행/만료/포인트 정산 등 부속 운영규칙도 V1 범위와 충돌. "경쟁사에 있는 멋진 기능"이지 "우리가 놓친 표준"이 아님.
   - **약한 대체(메모만):** "견적 공유 URL"(토큰 정산·재판매 로직 배제, 동일사양 재주문 링크 공유 수준)은 **V2 검토 여지만 메모** — 이번 라운드 설계 안 함.
2. **RedPrinting 상품상태별 분리화면** → **답습 금지.** 단일 주문조회+필터로 경량화(이미 SM-MY-01 방향과 일치, D-DS-38 #4). UI 구조 답습하지 않음.

**보류 (미확정 — 추측 금지, 임의 V1/V2 확정 금지):**
- **마이페이지 대시보드(SM-MY-00)** → 이번 반영 제외. 추후 결정. 기록만(채번 미부여, 화면 미신설).
- **멤버십 등급** → 이번 반영 제외. 추후 결정(D-PM 마케팅 정책 종속). 기록만. (벤치마크 §3-4는 V2 후보로 권고했으나 본 결정에서는 **확정하지 않고 보류**로 보존 — owner 미결.)

**Rationale:** i.토큰은 비즈니스 모델 구조가 후니와 다르므로 완전성 게이트 통과 실패(숨은 로직이되 모델 부적합). 대시보드·멤버십은 owner 판단 미확정 상태로, 추측 분류 시 인벤토리 무결성 손상 — 보류 보존이 정답.

**Consequences:**
- sitemap/screen-inventory에 제외·보류 항목 **명시 기록**(설계 화면 미신설). 벤치마크 보강 집계 라인에 게이트·보류 주석
- SM-MY-00 채번 **미부여**(보류) — 향후 결정 시 신규 채번
- 멤버십은 D-PM(마케팅) 결정 종속으로 status.md 보류 항목 추적
**Source:** `04_design/mypage-benchmark.md` §3-4/§3-5/§3-7, §4-B/§4-C
**Linked:** D-DS-37(답습 금지 게이트), D-DS-38(반영분), D-PM-33(쿠폰·혜택채널)

### D-DS-40 — Wowpress 회원영역 벤치마크(v1.2) owner 결정 (재작업신청 신설·문의카테고리·답습 제외·부가배송 보류)

**Date:** 2026-05-31
**Status:** **Decided** | **Owner:** 지니 | **Priority:** HIGH (인쇄 CS 품질 화면·게이트)
**Context:** Wowpress 회원영역 로그인 크롤 확정(mypage-benchmark v1.2, 28경로)으로 신규 후보 7건 판별(§3-W). owner(지니)가 화면 반영·제외·보류를 확정. (후불 4건은 D-PM-36 전건 선결제로 별도 처리.)

**Decision (owner 지니, 2026-05-31):**

**반영:**

| # | 항목 | 화면 ID | 종류 | V | 핵심 |
|---|---|---|---|:-:|---|
| 1 | 재작업신청 (인쇄 불량·오류 재제작) | SM-MY-19 / SC-MY-19 | **신설** | V1 | 원주문(SM-MY-01.1) 연결 + 불량유형·불량사진 업로드 + 처리상태 추적 워크플로우. SM-MY-08 1:1문의(자유서술)와 분리한 전용 정형 창구. 엔티티 Order/OrderItem/ArtworkFile, 위젯 form_field·image_upload·상태추적, 백엔드 자체+S3. 환불(`rfds`)·별도트랙 TR-CLAIM과의 통합 여부는 **설계 시 세부화**(이번엔 신설만) |
| 2 | 1:1문의 문의유형 카테고리 보강 | SM-MY-08 / SC-MY-08 | **보강** | V1 | 작성폼에 문의유형(결제/회계·출고/배송·품질·일반) 분류 필드 추가. 화면 신설 아님. business-analyst 카테고리 정의 영역 |

**제외 (답습 차단 게이트):**
1. **견적상담(`ests`) 메뉴 답습 제외** — 우리는 SM-MY-02 내 견적함(셀프 저장견적) + SM-CS-04 B2B견적문의(상담형)로 **2분화**가 Wowpress 단일 상담형 라벨보다 명확. 라벨 답습 금지(전환 링크만 UX 메모).
2. **선거홍보물 문의(`qnas/elctpromo`) 전용화면 제외** — 선거 시즌 특화. SM-MY-08 문의유형 카테고리로 흡수.

**보류 (재검토 — 임의 V1/V2 확정 금지):**
- **부가 배송서비스(안심배송 `pwsv`·배쑝와쑝 `mtdv`·무료직배송 등)** → **"배송옵션 설계 시 재검토" 항목으로 기록.** 지금 화면 신설 금지. 배송옵션 설계 라운드에서 검토(status.md 보류 항목 추적 등록). Wowpress 자체 물류 브랜드/노선 특화이므로 일반 배송옵션으로 흡수 가능성.

**채번 검증:** 기존 SM-MY는 01~18 사용(12 하위 12.1~12.5 포함). 신규 **SM-MY-19**는 중복 없음(HARD 제약 충족). 출처 라벨 `BENCH`.

**Rationale:** 재작업신청은 인쇄(색상·재단·오타 등 결과물 불량이 구조적 발생) CS의 정형 워크플로우(원주문 매핑+증빙사진+상태추적)로, 1:1문의 자유서술로는 약함 → 완전성 검증 정당(UI 답습 아님). 견적상담·선거홍보물은 라벨 답습 위험으로 제외. 부가배송은 배송정책 미확정이므로 추측 금지 보류.

**Consequences:**
- `04_design/sitemap.md §1/§2.2/§5/§6`·`screen-inventory.md §0.1/§1.2/§4.1.2/§6/§7`: SM-MY-19 신설 행 + SM-MY-08 보강 + 위젯범례(image_upload·상태추적) + 벤치마크 신설 V1 누계 4
- 벤치마크 신설 V1 4건(SM-MY-18·12.4·12.5·19)은 xlsx 112 외 별도 집계 → KPI(V1 85/V2 27/V1? 0) 불변
- **후속 정합(MED):** SM-MY-19 ↔ 환불(`rfds`)·TR-CLAIM 통합 범위는 설계 시 세부화(consistency-report 후속 축). 환불 상태머신·재제작 상태 enum 정렬은 architect 영역
- **status.md:** 부가배송 보류 항목 추적 등록(배송옵션 설계 라운드)
- 아키텍처 결정(D-004·B-2·에디터·이니시스) 불변

**Source:** `04_design/mypage-benchmark.md` §3-9/§3-10/§3-12, §4-A2/§4-B/§4-C2
**Linked:** D-PM-36(전건 선결제·후불 4건 제외), D-DS-37(답습 금지 게이트), D-DS-38(직전 벤치마크 반영), TR-CLAIM(별도트랙), REQ-PQ-060/061

---

# Part 3 — Migration Gaps (cross-mapping.md §6)

decisions와 분리, **마이그레이션 작업 항목**으로 분류. 본 갭은 결정이 아니라 보정해야 할 데이터/시스템 차이.

| 갭 ID | 내용 | 우선 | 해결 방안 | Owner | Linked D-PM |
|------|------|:-:|------|------|------|
| GAP-001 | huni xlsx MES CD 4건 중복 (PM-DUP-01~04) | 🔴 HIGH | 신규 코드 부여 + 마이그레이션 매핑표 | pq-business-analyst | D-PM-03 |
| GAP-002 | 010·011 카테고리 100+ 상품 MES CD 미부여 | 🔴 HIGH | 자동 발급 정책 + xlsx 보정 | pq-business-analyst | D-PM-01 |
| GAP-003 | 책자(006) 라이브 격차 (xlsx 7종 vs 라이브 2종) | 🟡 MED | V1 카탈로그 범위 결정 | 사용자 | D-PM-06 |
| GAP-004 | buysangsang `결제테스트` 등 운영 잔재 | 🔴 HIGH | 마이그레이션 전 cleanup | 사용자 | D-PM-07, D-PM-05 |
| GAP-005 | xlsx 가격표 19시트 ↔ TM EPO `tm_meta_cpf` 정합성 미검증 | 🟡 MED | 표본 추가 추적 후 결정 | pq-business-analyst | D-PM-08 |
| GAP-006 | huniprinting48 Shopby 카테고리·상품 raw 수집 실패 (IP 화이트리스트) | 🟢 LOW | Shopby IP 등록 후 1회 정찰 | pq-researcher | O-001 |
| GAP-007 | xlsx 검토중(★) 9종 신규 (아크릴) V1 포함 여부 | 🟡 MED | V1 포함 여부 결정 + 코드 부여 | 사용자 | D-PM-06 |

**Source:** `02_business/cross-mapping.md` §6 (line 173~184)

---

## 결정 인용 가이드

다른 산출물에서 결정을 인용할 때 `D-NNN`, `O-NNN`, `D-PM-NN`, `GAP-NNN` 식별자 사용.
변경이 발생하면 새 ID로 추가하고 이전을 `SUPERSEDED by D-NNN`으로 표기 (덮어쓰기 금지).


---

## D-PM-30B — Order 상태 노출 정책 (UI superstate 7 / Internal substate 18)

**Date:** 2026-05-27
**Status:** **Decided**
**Linked:** `03_architecture/builder-engine/order-state-mapping.md`, INC-006 Resolution
**Source:** INC-006 해결 과정에서 신규 도출

**Context:** BA의 PDF 7-state와 ARC의 baseline 17-state 모순 (INC-006). 두 어휘 모두 정당하므로 단일 폐기가 아닌 매핑·이중 운영이 정답.

**Decision:**
1. DB orders.status는 **18-substate** 저장 (기존 17 + `packing_done` 신규 1)
2. UI/외부 API 노출은 **7-superstate** 기본 (사용자·관리자 일반 화면)
3. 발주팀·생산팀 상세 화면은 18-substate 옵션 노출
4. `order_superstate()` 함수 + `orders.superstate` generated column으로 매핑 자동화
5. 알림은 superstate 전이에만 발송 (substate 전이는 소음 방지)
6. 파일 부속 상태머신은 `artwork_files.file_status` 별도 (이중 상태머신, ADR-002 D5 정합)

**Consequences:**
- `schema.sql` 갱신 필요: `packing_done` substate 추가, `order_superstate()` 함수, `artwork_files.file_status`
- `domain-model.md §3.4/§4.7`·`bff-integration.md §1`·`order-flow.md §1` 표기 갱신 필요
- INC-006/007/009 Resolved
- M3(화면 설계) 진입 차단 해제 ✅
- 후속 SPEC 분할 시 "주문 상태 표시 일관성" 검증 항목 필수 포함

---

## D-PM-* 통계 (2026-05-27 1차 등록 시점)

| 분류 | 건수 | V1 critical path |
|------|--:|--:|
| 상품마스터 | 3 | 2 |
| 카테고리·SKU 체계 | 6 | 2 |
| 가격 엔진 | 7 (D-PM-16은 D-PM-31에 통합) | 5 |
| 공정 흐름 | 4 | 3 |
| 주문 라이프사이클 | 9 | 4 |
| 운영 정책 | 6 | 4 |
| **합계** | **35** (실효 34) | **20** |

⚠ **20건이 Big-Bang 컷오버 전 사용자 결정 필요** (Open 상태). M3 진행 중 병행 결정 권고.
