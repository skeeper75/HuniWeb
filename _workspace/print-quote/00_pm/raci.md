# RACI Matrix — Print-Quote 책임 매트릭스

**작성:** 2026-05-27 (pq-pm)
**범위:** M1~M5 전 산출물 + 결정 + 검증 작업.

## 표기

| 표기 | 의미 |
|------|------|
| **R** | Responsible — 실제 작업 수행자 (복수 가능) |
| **A** | Accountable — 최종 승인 권한자 (단일) |
| **C** | Consulted — 의사 결정 전 자문 (양방향) |
| **I** | Informed — 결과 통보 수신 (일방향) |

## 역할 정의

| 역할 | 코드 | 책임 영역 |
|------|------|------|
| pq-researcher | RES | As-Is 시스템 정찰, 외부 자료 분석, 빌더 패턴 7축 역공학 |
| pq-business-analyst | BA | 비즈니스 도메인 정형화 (xlsx 파싱, EARS 요구사항, 정책) |
| pq-architect | ARC | To-Be 시스템 설계 (도메인 모델, schema, 가격 엔진, BFF) |
| pq-designer | DES | 화면 설계 (와이어프레임, IA, 디자인 토큰) |
| pq-pm | PM | 계획·조율·검증·통합 |
| 사용자 (지니) | USR | 모든 D-PM 결정·승인, 마일스톤 종결 |

---

## M1 — As-Is 분석 + 옵션 C 확정

| 산출물 | RES | BA | ARC | DES | PM | USR |
|------|:-:|:-:|:-:|:-:|:-:|:-:|
| `01_research/crawl-evidence/` (buysangsang 라이브 분석) | **R/A** | I | C | I | I | I |
| `01_research/edicus-analysis/` (5건) | **R/A** | I | C | I | I | I |
| `01_research/shopby-aurora-analysis/` (5건) | **R/A** | I | C | I | I | I |
| `01_research/shopby/SHOPBY_FINDINGS.md` | **R/A** | I | C | I | I | I |
| `03_architecture/adr/ADR-001` (Frontend Options) | C | C | **R/A** | I | I | **승인 ✅** |
| `03_architecture/adr/ADR-002` (Edicus 통합) | C | I | **R/A** | I | I | I |
| `03_architecture/adr/ADR-003` (Data Layer) | I | C | **R/A** | I | I | I |
| D-001~D-004 결정 | C | I | C | I | **R/A** | **승인 ✅** |

---

## M2 — 빌더 도메인 모델 + huni 실데이터

### 02_business/ (pq-business-analyst R/A)

| 산출물 | RES | BA | ARC | DES | PM | USR |
|------|:-:|:-:|:-:|:-:|:-:|:-:|
| `product-master.md` (xlsx 240 SKU) | C | **R/A** | C | I | I | I |
| `cross-mapping.md` (삼각 매핑) | C | **R/A** | C | I | I | I |
| `pricing-rules.md` (가격표 19시트) | I | **R/A** | C | I | I | I |
| `process-flow.md` (공정 라우트) | I | **R/A** | C | I | I | I |
| `order-flow.md` (PDF 8 페이지) | I | **R/A** | C | I | I | I |
| `policy-checklist.md` (113 IA + 25 운영정책) | I | **R/A** | I | C | C | C |
| `glossary.md` (UI 라벨 정책) | I | **R/A** | I | C | C | C |
| `requirements-ears.md` (REQ-PQ-001~120) | I | **R/A** | C | C | C | C |

### 03_architecture/builder-engine/ (pq-architect R/A)

| 산출물 | RES | BA | ARC | DES | PM | USR |
|------|:-:|:-:|:-:|:-:|:-:|:-:|
| `domain-model.md` (5 도메인 48 엔티티) | I | C | **R/A** | I | I | I |
| `schema.sql` (baseline + 신규 통합) | I | C | **R/A** | I | C | I |
| `block-schema.md` (14 V1 위젯) | C | I | **R/A** | C | I | I |
| `widget-coverage-matrix.md` | C | I | **R/A** | C | I | I |
| `form-builder.md` (옵션 폼 8축) | I | C | **R/A** | C | I | I |
| `pricing-engine.md` (6 단계 산식) | I | C | **R/A** | I | C | I |
| `render-pipeline.md` | C | I | **R/A** | C | I | I |
| `bff-integration.md` | C | C | **R/A** | I | I | I |

### D-PM 결정 (35건)

| 결정군 | RES | BA | ARC | DES | PM | USR |
|------|:-:|:-:|:-:|:-:|:-:|:-:|
| D-PM-01~03 (상품마스터) | I | **R** | C | I | C | **A** |
| D-PM-04~09 (카테고리·SKU 체계) | C | **R** | C | I | C | **A** |
| D-PM-10~16 (가격 엔진) | I | **R** | C | I | C | **A** |
| D-PM-17~20 (공정 흐름) | I | **R** | C | I | C | **A** |
| D-PM-21~29 (주문 라이프사이클) | I | **R** | C | I | C | **A** |
| D-PM-30~34 (운영 정책) | I | **R** | I | C | C | **A** |
| D-PM-35 (UI 라벨) | I | **R** | I | C | C | **A** |

---

## M3 — 화면 설계 (예정)

| 산출물 | RES | BA | ARC | DES | PM | USR |
|------|:-:|:-:|:-:|:-:|:-:|:-:|
| `04_design/sitemap.md` (IA) | I | C | I | **R/A** | C | I |
| `04_design/user-journeys.md` | I | C | C | **R/A** | C | I |
| `04_design/screen-inventory.md` | I | C | C | **R/A** | C | I |
| `04_design/design-tokens/` | I | I | C | **R/A** | I | I |
| `04_design/wireframes/*.pen` (핵심 25건) | I | C | C | **R/A** | C | C |
| `04_design/wireframes/option-wizard.pen` | I | C | C | **R/A** | I | I |
| `04_design/components/price-result.md` | I | I | C | **R/A** | I | I |
| `04_design/wireframes/admin-pricing/` | I | C | C | **R/A** | I | I |
| `04_design/wireframes/builder-editor.pen` | I | I | C | **R/A** | I | I |
| `04_design/design-decisions.md` (D-DS-NN) | I | I | C | **R** | C | **A** |

---

## M4 — 통합 설계서

| 산출물 | RES | BA | ARC | DES | PM | USR |
|------|:-:|:-:|:-:|:-:|:-:|:-:|
| `99_integrated/design-spec.md` | C | C | C | C | **R/A** | I |
| `99_integrated/executive-summary.md` | I | C | C | I | **R/A** | **승인 필요** |
| `99_integrated/handoff-to-build.md` | I | C | C | C | **R/A** | I |

---

## M5 — SPEC 분할·구현 핸드오프

| 산출물 | RES | BA | ARC | DES | PM | USR |
|------|:-:|:-:|:-:|:-:|:-:|:-:|
| `_specs-index.md` (SPEC 분할 권고) | I | C | C | I | **R/A** | **승인 필요** |
| `.moai/specs/SPEC-PQ-*/spec.md` (각 SPEC 초안) | I | C | C | C | **R** | **A** |
| `00_pm/risk-register.md` | I | C | C | C | **R/A** | I |
| `00_pm/cutover-plan.md` (O-003 후) | C | C | C | C | **R/A** | **승인 필요** |

---

## PM 산출물 (전 단계 공통)

| 산출물 | RES | BA | ARC | DES | PM | USR |
|------|:-:|:-:|:-:|:-:|:-:|:-:|
| `00_pm/decisions.md` (ADR 경량 로그) | C | C | C | C | **R/A** | **A (D-PM 결정)** |
| `00_pm/milestones.md` | I | I | I | I | **R/A** | **A (DoD 승인)** |
| `00_pm/raci.md` | I | I | I | I | **R/A** | I |
| `00_pm/task-graph.md` | I | I | I | I | **R/A** | I |
| `00_pm/status.md` | I | I | I | I | **R/A** | I |
| `00_pm/consistency-report.md` (5축 교차검증) | I | C | C | C | **R/A** | I |
| `00_pm/shopby-ip-whitelist-setup.md` | C | I | C | I | **R/A** | C |

---

## 교차 검증 (consistency-report.md 축별)

| 검증 축 | RES | BA | ARC | DES | PM | USR |
|------|:-:|:-:|:-:|:-:|:-:|:-:|
| (a) 상품 모델 일관성 | I | C | C | I | **R/A** | I |
| (b) 가격 산식 일관성 | I | C | C | I | **R/A** | I |
| (c) 상태 머신 일관성 | I | C | C | I | **R/A** | I |
| (d) 화면↔API 매핑 (M3 후) | I | I | C | C | **R/A** | I |
| (e) EARS 요구사항 추적성 | I | C | C | C | **R/A** | I |

INC 해결 책임 (각 INC 항목 별):

| INC ID | 1차 해결 책임 | 사용자 결정 필요? |
|------|:-:|:-:|
| INC-001 (mes_item_cd NULLABLE) | ARC + BA | ✅ D-PM-01 |
| INC-002 (CHECK 정규식 vs 미부여) | ARC | ✅ D-PM-01 |
| INC-003 (legacy_buysangsang_cat 컬럼) | ARC | ✅ D-PM-02 |
| INC-004 (배송비 정책 placeholder) | ARC + BA | ✅ D-PM-31 |
| INC-005 (pricing_model 열거형) | ARC | ❌ |
| **INC-006 (Order 7-state vs 17-state)** ⭐ | **ARC + BA** | ❌ (협업으로 해결) |
| INC-007 (파일 상태 머신 부재) | ARC | ❌ |
| INC-008 (DesignProject ↔ Order 매핑) | ARC | INC-006 종속 |
| INC-009 (REQ-PQ-040~062 추적) | BA | INC-006 종속 |
| INC-010 (REQ-PQ-063~078 추적) | BA | INC-007 종속 |

---

## 사용자(USR) 핵심 의사결정 시점

| 시점 | 결정 사안 | 영향 |
|------|------|------|
| 직후(M3 진입 전) | D-PM-01, D-PM-04, D-PM-08 (3건 V1 critical path) | M3 상품관리·가격관리 화면 시작 가능 |
| 직후(M3 진입 전) | D-PM-35 (UI 라벨 정책) | M3 와이어프레임 라벨 일관성 |
| M3 진행 중 | D-PM-03, D-PM-07, D-PM-14, D-PM-15, D-PM-17~20, D-PM-21·22·24·28·29·31·32·33·34 (16건) | M3 화면별 정책 채움 + M4 통합 설계서 정확성 |
| M4 진입 전 | M3 산출물 승인 + M4 진입 결정 | M4 시작 가능 |
| M4 종결 시 | executive-summary 승인 | 의사결정자 보고 |
| M5 진입 전 | O-003 (컷오버 시점) | M5 cutover-plan.md 작성 가능 |
| M5 종결 시 | SPEC 분할 권고안 승인 | 구현 단계 진입 |

---

## 변경 이력

| 버전 | 날짜 | 변경 | 작성자 |
|------|------|------|--------|
| 1.0 | 2026-05-27 | M1+M2 완료 시점 1차 작성, M3~M5 예정 항목 포함 | pq-pm |

다음 갱신: M3 진입 시 (D-DS-NN 추가), 각 마일스톤 종결 시.
