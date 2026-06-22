# Milestones — Print-Quote 후니프린팅 리뉴얼

**작성:** 2026-05-27 (pq-pm)
**범위:** M1(As-Is 분석) ~ M5(SPEC 분할·구현 핸드오프) 5개 마일스톤.
**원칙:** 각 마일스톤은 명확한 DoD(Definition of Done)와 검증 조건을 가진다. 마일스톤 종결 권한은 사용자에게 있음.

---

## 개관

```
M1 ━━━━━━━━━━━━━ 100% ✅  As-Is 분석 + 옵션 C 확정
M2 ━━━━━━━━━━━━━ 100% ✅  빌더 도메인 모델 + huni 실데이터 (현재 위치)
M3 ━━━━━━━━━━━━━   0% ⏸  화면 설계 (YOU ARE HERE → 시작점)
M4 ━━━━━━━━━━━━━   0% ⏸  통합 설계서
M5 ━━━━━━━━━━━━━   0% ⏸  SPEC 분할·구현 핸드오프
```

---

## M1 — As-Is 분석 + 옵션 C 확정 ✅ 100%

**기간:** 2026-05-27 (Day 1)
**Lead:** pq-researcher
**상태:** ✅ Closed
**연결 결정:** D-001, D-002, D-003, D-004

### 산출물

| 산출물 | 위치 | 완료 |
|------|------|:--:|
| As-Is 빌더 패턴 7축 역공학(widget/layout/template/interaction/form/token/plugin) | `01_research/crawl-evidence/2026-05-27_buysangsang/` | ✅ |
| buysangsang WP+Woo+Elementor 분석 (저트래픽 read-only) | `01_research/crawl-evidence/2026-05-27_buysangsang/` | ✅ |
| edicus.man Next.js 15 + Edicus SDK 분석 (5개 보고서) | `01_research/edicus-analysis/` | ✅ |
| Shopby Aurora 8차원 가중합 평가 (3옵션 비교) | `01_research/shopby-aurora-analysis/` | ✅ |
| Shopby Server API 정찰 (S1~S4, Sa_*) | `01_research/shopby/SHOPBY_FINDINGS.md` | ✅ |
| ADR-001 Frontend Architecture (옵션 A/B/C) | `03_architecture/adr/ADR-001-frontend-architecture-options.md` | ✅ |
| ADR-002 Edicus 통합 전략 D1~D9 | `03_architecture/adr/ADR-002-edicus-integration-strategy.md` | ✅ |
| ADR-003 Data Layer 전략 (master ownership) | `03_architecture/adr/ADR-003-data-layer-strategy.md` | ✅ |
| 의사결정 로그 D-001~D-004 + O-001~O-005 | `00_pm/decisions.md` (Part 1) | ✅ |

### DoD (Definition of Done)

- [x] 후니프린팅 As-Is 운영 시스템 4채널 식별 (buysangsang WP / huniprinting48 Shopby / edicus.man / huni MES xlsx)
- [x] To-Be 프론트엔드 아키텍처 옵션 3개 가중합 평가 완료
- [x] 옵션 C 채택 결정 + Aurora 결정적 한계 3가지 문서화
- [x] Edicus SDK 외부 의존 유지 결정
- [x] 빌더 패턴 7축 역공학 결과 widget-coverage-matrix.md로 정리 가능

### 검증

- ✅ buysangsang 라이브 분석 시 트래픽 가드(200req/20MB) 준수
- ✅ 자격증명 `.env.local` 저장 + `.gitignore` 보호
- ✅ Aurora 분석 보고서의 V1·V2·V3 검증 항목 식별

---

## M2 — 빌더 도메인 모델 + huni 실데이터 ✅ 100%

**기간:** 2026-05-27 (Day 1)
**Lead:** pq-business-analyst + pq-architect (병렬)
**상태:** ✅ Closed
**연결 결정:** D-PM-01 ~ D-PM-35 (35건 신규 등록)

### 산출물

#### 02_business/ (pq-business-analyst, 8건)

| 산출물 | LOC | 완료 |
|------|--:|:--:|
| `product-master.md` — huni xlsx 상품마스터 전수 파싱 | 25 KB | ✅ |
| `cross-mapping.md` — huni xlsx ↔ buysangsang ↔ Shopby 삼각 매핑 | 15 KB | ✅ |
| `pricing-rules.md` — 가격표 19시트 + 8개 가격관리 팝업 모델 | 28 KB | ✅ |
| `process-flow.md` — 공정 라우트 + 4-game 검수 게이트 | 13 KB | ✅ |
| `order-flow.md` — 주문 라이프사이클 PDF 8 페이지 정형화 | 29 KB | ✅ |
| `policy-checklist.md` — 113 IA 기능 + 9 CUSTOM + 25 운영정책 | 15 KB | ✅ |
| `glossary.md` — 도메인 용어 + UI 라벨 정책 | 19 KB | ✅ |
| `requirements-ears.md` — REQ-PQ-001~120 (120건 EARS) | 27 KB | ✅ |

#### 03_architecture/builder-engine/ (pq-architect, 8건 + schema)

| 산출물 | 완료 |
|------|:--:|
| `domain-model.md` — 5 도메인 48 엔티티 1차 도메인 모델 | ✅ |
| `block-schema.md` — 14 V1 위젯 블록 스키마 | ✅ |
| `widget-coverage-matrix.md` — As-Is 위젯 ↔ V1 위젯 매핑 매트릭스 | ✅ |
| `form-builder.md` — 옵션 폼 빌더 (8축 입력 슬롯) | ✅ |
| `pricing-engine.md` — 6단계 가격 산출 엔진 + 10 테스트 시나리오 | ✅ |
| `render-pipeline.md` — 페이지·섹션·블록 렌더링 파이프라인 | ✅ |
| `bff-integration.md` — Shopby BFF 위임 범위 | ✅ |
| `schema.sql` — PostgreSQL 14+ 통합 스키마 (baseline 38 + 신규 +10) | ✅ |

### DoD

- [x] huni 상품마스터 xlsx 240 SKU 전수 정형화
- [x] 가격관리 8 모델(DP02/DP04/DP06/GD01/GD02/PK01/PR01/PR02) 매핑
- [x] 25개 운영정책 일괄 검토 (D-PM-31~34)
- [x] 113 IA 기능 정책 분류
- [x] REQ-PQ-001~120 EARS 5 유형 분류 (U/EV/UN/OP/CP)
- [x] 5 도메인 48 엔티티 ERD 작성
- [x] schema.sql baseline 38 + 신규 10 테이블 = 48 테이블 통합
- [x] 가격 엔진 6단계 산식 정의 + 10 단위 테스트 시나리오

### 검증 (consistency-report.md §INC-001~INC-010)

- ✅ 88/120 REQ가 도메인 엔티티 추적 가능
- 🟡 INC-006 발견: Order 7-state vs 17-state 모순 (M3 진입 전 해결 필요)
- 🟡 INC-001 발견: `products.mes_item_cd` NULLABLE 정책 모호
- 🟡 INC-004 발견: 가격 엔진 Step 6 배송비 미정 (D-PM-31 종속)

---

## M3 — 화면 설계 ⏸ 0% (YOU ARE HERE → 시작점)

**Lead:** pq-designer
**상태:** 준비 단계
**의존:** M2 산출물 + INC-001/006 해결 + D-PM 결정 회신 일부
**연결 결정:** D-PM-30·35 (UI 라벨), 모든 V1 critical path D-PM

### 산출물 (예정)

| 산출물 | 위치 | 비고 |
|------|------|------|
| 사이트맵 + IA (113 기능 정렬) | `04_design/sitemap.md` | policy-checklist.md §2 기반 |
| 사용자 여정 맵 (5 페르소나 × V1 critical flow) | `04_design/user-journeys.md` | order-flow.md §1.2 5 결제 케이스 분기 |
| 화면 목록 + 우선순위 매트릭스 | `04_design/screen-inventory.md` | V1=67건 / V2=38건 |
| 디자인 토큰 (Huni v6.0 + edicus.man CssPreset 흡수) | `04_design/design-tokens/` | schema.sql §2.1 매핑 |
| 핵심 화면 와이어프레임 .pen 파일 ─ V1 67건 중 핵심 25건 | `04_design/wireframes/*.pen` | Pencil MCP 활용 |
| 옵션 폼 마법사 와이어프레임 (8축 입력) | `04_design/wireframes/option-wizard.pen` | form-builder.md 매핑 |
| 가격 산출 결과 표시 컴포넌트 | `04_design/components/price-result.md` | pricing-engine.md `calculateQuote` 출력 |
| 어드민 가격관리 8 팝업 와이어프레임 | `04_design/wireframes/admin-pricing/` | pricing-rules.md §3 |
| 빌더 에디터 UI (위젯 14종 toolbar) | `04_design/wireframes/builder-editor.pen` | block-schema.md §2 |
| 디자인 의사결정 노트 (D-DS-NN) | `04_design/design-decisions.md` | 새 결정 ID 체계 |

### DoD

- [ ] V1 화면 67건 중 최소 핵심 30건(상품·견적·옵션·결제·주문관리·가격관리·로그인·회원가입)의 와이어프레임 작성
- [ ] 모든 화면이 적어도 1개의 REQ-PQ-NNN을 충족 (역추적 가능)
- [ ] 디자인 토큰이 `design_tokens` 테이블 스키마와 1:1 호환
- [ ] 옵션 폼 화면이 form-builder.md 8축 입력 슬롯과 일치
- [ ] 가격 결과 표시 컴포넌트가 pricing-engine.md `calculateQuote` 출력 스키마와 일치
- [ ] consistency-report.md 축 (d) "화면↔API 매핑" 모든 화면에 대해 검증 완료 (INC 0건)

### 사전 처리 (M3 시작 전)

1. **[BLOCKER]** INC-006 해결 → Order 상태 7↔17 매핑표 작성 (pq-architect)
2. **[BLOCKER]** INC-001 해결 → D-PM-01 사용자 회신 후 schema 확정
3. INC-005 해결 권고 → pricing-engine.md §3 pricing_model 열거형 명시 (병행)
4. D-PM-35(UI 라벨 외부 브랜드명 노출 정책) 회신 → 와이어프레임 라벨 일관성

---

## M4 — 통합 설계서 ⏸ 0%

**Lead:** pq-pm (조율 + 통합), 전 팀원 (각자 도메인 인용)
**상태:** 준비 단계
**의존:** M3 완료
**연결 결정:** 모든 D-001 ~ D-PM-35

### 산출물 (예정)

| 산출물 | 위치 | 비고 |
|------|------|------|
| 통합 설계서 (전 산출물 단일 문서로 종합) | `99_integrated/design-spec.md` | 목차·요약·세부, 출처 명시 |
| 의사결정자용 1~2페이지 요약 | `99_integrated/executive-summary.md` | 옵션 C 채택 근거 + 핵심 KPI |
| 구현 핸드오프 문서 | `99_integrated/handoff-to-build.md` | SPEC 분할 권고 + 우선순위 + 위험 |

### DoD

- [ ] 통합 설계서가 5 도메인(Builder/Quote/Member-Order/Design-Asset/Production) 모두를 포괄
- [ ] 모든 REQ-PQ-001~120이 통합 설계서 내 적어도 한 절에서 인용됨
- [ ] 모든 D-PM-* 결정의 최종 상태(Decided/Open/Deferred)가 통합 설계서에 반영
- [ ] consistency-report.md 모든 축에서 INC 0건 (잔존 INC는 V2 deferred로 명시)
- [ ] executive-summary.md가 비기술 의사결정자가 이해 가능한 한국어 prose로 작성됨
- [ ] handoff-to-build.md에 SPEC 분할 권고안 + 우선순위 + 식별된 위험 N건 정리

---

## M5 — SPEC 분할·구현 핸드오프 ⏸ 0%

**Lead:** pq-pm + manager-spec subagent (MoAI workflow)
**상태:** 준비 단계
**의존:** M4 완료 + 사용자 컷오버 시점 확정 (O-003)
**연결 결정:** O-003

### 산출물 (예정)

| 산출물 | 위치 | 비고 |
|------|------|------|
| SPEC 인덱스 (분할 권고) | `_workspace/print-quote/_specs-index.md` | 예: SPEC-PQ-CORE / SPEC-PQ-PRICING / SPEC-PQ-ORDER / SPEC-PQ-BUILDER 등 |
| 각 SPEC 초안 (.moai/specs/SPEC-PQ-*/spec.md) | MoAI 표준 위치 | manager-spec subagent 위임 |
| 위험 등록부 | `00_pm/risk-register.md` | 정량화된 위험(KPI 기반) |
| Big-Bang 컷오버 계획 (O-003 확정 후) | `00_pm/cutover-plan.md` | 데이터 마이그레이션 시퀀스 |

### DoD

- [ ] 모든 V1 critical path D-PM이 Decided 상태로 전환됨
- [ ] SPEC 분할(예: 5~10개 SPEC)이 manager-spec subagent에 의해 ratified됨
- [ ] 각 SPEC이 EARS 요구사항 + 도메인 엔티티 + 화면 와이어프레임을 명시 인용
- [ ] 위험 등록부에 minimum 10건의 정량화 위험 등록
- [ ] handoff 결과로 manager-spec → manager-ddd/manager-tdd subagent가 즉시 `/moai run`을 시작 가능한 상태

---

## 마일스톤 종합 KPI

| 마일스톤 | 산출물 수 | LOC | 결정 수 | INC 수 | 상태 |
|------|--:|--:|--:|--:|:--:|
| M1 | 9 | ~60 KB | 4 D + 5 O | 0 | ✅ |
| M2 | 16 | ~250 KB | 35 D-PM | 10 | ✅ |
| M3 | ~10 | 미정 | 디자인 D-DS-NN 예상 | 0 (목표) | ⏸ |
| M4 | 3 | 미정 | 0 (통합만) | 0 (목표) | ⏸ |
| M5 | ~10 (SPEC) | 미정 | O-003 + 모든 V1 critical path D-PM Decided | — | ⏸ |
| **합계** | **48+** | **>500 KB** | **44+ D + 5 O + N D-DS** | **현재 10** | **40% (M2까지)** |

---

## 변경 이력

| 버전 | 날짜 | 변경 | 작성자 |
|------|------|------|--------|
| 1.0 | 2026-05-27 | M1+M2 완료 시점 1차 작성 | pq-pm |

다음 갱신: M3 산출물 작성 시작 시점.
