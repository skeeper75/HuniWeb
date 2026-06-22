# Task Graph — Print-Quote 작업 의존성 그래프

**작성:** 2026-05-27 (pq-pm)
**범위:** M1~M5 산출물 간 의존 관계 + 병렬화 가능 구간 표시.

본 그래프는 산출물 단위 의존성을 보여준다. 작업 시작 시 본 그래프에서 unblocked 항목을 확인.

---

## 전체 의존성 그래프

```mermaid
graph TD
    %% M1 — As-Is 분석 + 옵션 C 확정 ✅
    M1A[M1: buysangsang 라이브 분석<br/>crawl-evidence/]:::done
    M1B[M1: edicus.man 코드 분석<br/>edicus-analysis/]:::done
    M1C[M1: Shopby Aurora 8차원 평가<br/>shopby-aurora-analysis/]:::done
    M1D[M1: Shopby Server API 정찰<br/>shopby/SHOPBY_FINDINGS.md]:::done
    M1E[M1: ADR-001 Frontend Options<br/>D-004 옵션 C 채택]:::done
    M1F[M1: ADR-002 Edicus 통합<br/>D1~D9 + Open Q]:::done
    M1G[M1: ADR-003 Data Layer<br/>잠정 A1~A7]:::done

    M1A --> M1E
    M1B --> M1F
    M1C --> M1E
    M1D --> M1G
    M1E --> M1F
    M1F --> M1G

    %% M2 — 빌더 도메인 모델 + huni 실데이터 ✅
    M2BA1[M2: product-master.md<br/>huni xlsx 240 SKU]:::done
    M2BA2[M2: cross-mapping.md<br/>삼각 매핑]:::done
    M2BA3[M2: pricing-rules.md<br/>가격표 19시트 + 8 모델]:::done
    M2BA4[M2: process-flow.md<br/>공정 라우트]:::done
    M2BA5[M2: order-flow.md<br/>PDF 8 페이지 정형]:::done
    M2BA6[M2: policy-checklist.md<br/>113 IA + 25 운영정책]:::done
    M2BA7[M2: glossary.md<br/>UI 라벨 정책]:::done
    M2BA8[M2: requirements-ears.md<br/>REQ-PQ-001~120]:::done

    M2AR1[M2: domain-model.md<br/>5 도메인 48 엔티티]:::done
    M2AR2[M2: schema.sql<br/>baseline 38 + 신규 10]:::done
    M2AR3[M2: block-schema.md<br/>14 V1 위젯]:::done
    M2AR4[M2: widget-coverage-matrix.md]:::done
    M2AR5[M2: form-builder.md<br/>옵션 폼 8축]:::done
    M2AR6[M2: pricing-engine.md<br/>6 단계 산식]:::done
    M2AR7[M2: render-pipeline.md]:::done
    M2AR8[M2: bff-integration.md]:::done

    M1E --> M2BA1
    M1G --> M2AR1
    M1B --> M2AR3
    M2BA1 --> M2BA2
    M2BA1 --> M2BA3
    M2BA1 --> M2BA8
    M2BA3 --> M2BA8
    M2BA4 --> M2BA5
    M2BA5 --> M2BA8
    M2BA6 --> M2BA8

    M2BA1 --> M2AR1
    M2BA3 --> M2AR6
    M2BA5 --> M2AR1
    M2BA2 --> M2AR2
    M2AR1 --> M2AR2
    M2AR3 --> M2AR4
    M2AR3 --> M2AR5
    M2AR6 --> M2AR8

    %% PM 산출물 (M2 종결 + 결정 통합)
    PM1[PM: decisions.md 통합<br/>D-PM-01~35 등록]:::done
    PM2[PM: consistency-report.md<br/>10 INC 식별]:::done
    PM3[PM: milestones.md M1~M5]:::done
    PM4[PM: task-graph.md]:::done
    PM5[PM: raci.md]:::done
    PM6[PM: status.md]:::done

    M2BA8 --> PM1
    M2BA6 --> PM1
    M2BA5 --> PM1
    M2AR2 --> PM2
    PM1 --> PM2
    PM2 --> PM3
    PM3 --> PM4

    %% ⭐ BLOCKERS (M3 시작 전 해결 필수)
    B1[🔴 INC-006 해결<br/>Order 7↔17 매핑표]:::blocker
    B2[🔴 INC-001 해결<br/>D-PM-01 회신 후 schema 확정]:::blocker
    B3[🟡 INC-005 권고<br/>pricing-engine pricing_model 명시]:::blocker
    B4[🟡 D-PM-35 회신<br/>UI 라벨 정책]:::blocker

    PM2 --> B1
    PM2 --> B2
    PM2 --> B3
    PM1 --> B4

    %% M3 — 화면 설계 (YOU ARE HERE → 시작점)
    M3A[M3: sitemap.md + IA<br/>113 기능 정렬]:::pending
    M3B[M3: user-journeys.md<br/>5 페르소나]:::pending
    M3C[M3: screen-inventory.md<br/>V1 67 + V2 38]:::pending
    M3D[M3: design-tokens/<br/>Huni v6.0 + CssPreset]:::pending
    M3E[M3: 핵심 와이어프레임 25건<br/>wireframes/*.pen]:::pending
    M3F[M3: 옵션 폼 마법사<br/>option-wizard.pen]:::pending
    M3G[M3: 가격 결과 컴포넌트<br/>price-result.md]:::pending
    M3H[M3: 어드민 가격관리<br/>8 팝업 와이어]:::pending
    M3I[M3: 빌더 에디터 UI<br/>builder-editor.pen]:::pending
    M3J[M3: design-decisions.md<br/>D-DS-NN]:::pending

    B1 --> M3A
    B2 --> M3A
    B1 --> M3E
    B2 --> M3E
    B4 --> M3A
    B4 --> M3E
    M2BA6 --> M3A
    M2BA8 --> M3B
    M2BA5 --> M3B
    M3A --> M3C
    M3B --> M3C
    M2AR1 --> M3D
    M3C --> M3D
    M3D --> M3E
    M2AR5 --> M3F
    M2AR6 --> M3G
    B3 --> M3G
    M2BA3 --> M3H
    M2AR3 --> M3I
    M2AR4 --> M3I
    M3E --> M3J
    M3F --> M3J
    M3G --> M3J

    %% M4 — 통합 설계서
    M4A[M4: design-spec.md<br/>전 산출물 종합]:::pending
    M4B[M4: executive-summary.md<br/>1~2 페이지]:::pending
    M4C[M4: handoff-to-build.md<br/>SPEC 분할 권고]:::pending

    M3J --> M4A
    M3E --> M4A
    M3F --> M4A
    M3G --> M4A
    M3H --> M4A
    M3I --> M4A
    M2AR2 --> M4A
    M2BA8 --> M4A
    PM1 --> M4A
    M4A --> M4B
    M4A --> M4C

    %% M5 — SPEC 분할·구현 핸드오프
    M5A[M5: SPEC 인덱스<br/>분할 권고]:::pending
    M5B[M5: 각 SPEC 초안<br/>SPEC-PQ-* x N]:::pending
    M5C[M5: 위험 등록부<br/>risk-register.md]:::pending
    M5D[M5: 컷오버 계획<br/>cutover-plan.md]:::pending
    M5E[O-003 회신<br/>컷오버 시점 확정]:::userdecide

    M4C --> M5A
    M5A --> M5B
    M4C --> M5C
    M5E --> M5D
    M5A --> M5D

    %% 사용자 결정 입력
    UD1[사용자 결정 회신<br/>D-PM-01~35 일괄]:::userdecide
    UD2[사용자 결정 회신<br/>D-PM-31 배송비 ⭐]:::userdecide
    UD3[사용자 결정 회신<br/>D-PM-04/08 V1 critical]:::userdecide

    PM1 --> UD1
    UD1 --> B2
    UD1 --> B4
    UD2 --> M3G
    UD3 --> M3A

    %% 스타일
    classDef done fill:#c6f6d5,stroke:#22543d,stroke-width:2px,color:#000
    classDef pending fill:#fff5b1,stroke:#744210,stroke-width:2px,color:#000
    classDef blocker fill:#fed7d7,stroke:#c53030,stroke-width:3px,color:#000
    classDef userdecide fill:#bee3f8,stroke:#2c5282,stroke-width:2px,color:#000
```

---

## 범례

| 색상 | 의미 |
|------|------|
| 🟢 Green | Done (M1 + M2 + PM 산출물 완료) |
| 🟡 Yellow | Pending (M3 ~ M5 진행 예정) |
| 🔴 Red | BLOCKER (M3 시작 전 반드시 해결) |
| 🔵 Blue | 사용자 결정 회신 필요 |

---

## YOU ARE HERE → M3 시작점

M2 완료 직후, M3(화면 설계) 진입 직전 위치.

### M3 진입 조건 (4건 모두 충족 필요)

1. **[BLOCKER]** INC-006 해결 (Order 7↔17 매핑표 작성)
2. **[BLOCKER]** INC-001 해결 (D-PM-01 사용자 회신 후 schema.sql 확정)
3. **권고** INC-005 해결 (pricing-engine.md `pricing_model` 열거형 명시)
4. **권고** D-PM-35 사용자 회신 (UI 라벨 외부 브랜드명 노출 정책)

### 병행 가능 작업 (M3 진입 전에도 가능)

- pq-pm: 사용자에게 V1 critical path D-PM 19건 결정 회신 요청 (AskUserQuestion 경유)
- pq-architect: INC-005, INC-007 자체 해결 (사용자 결정 불요)
- pq-researcher: GAP-006 해결 (Shopby IP 화이트리스트 등록 후 raw 재수집)

---

## 병렬화 가능 구간

### M3 내부 (병렬 실행 가능)

```
M3 진입 후 다음 3 작업 트랙이 병렬 가능:

  ┌── Track A: 정보 구조 ────────────┐
  │ M3A → M3B → M3C                 │
  └─────────────────────────────────┘
                                    
  ┌── Track B: 디자인 토큰 + 위젯 ───┐
  │ M3D → M3E (와이어프레임)         │
  │      → M3I (빌더 에디터)         │
  └─────────────────────────────────┘
                                    
  ┌── Track C: 가격 관련 화면 ───────┐
  │ M3F (옵션 폼) → M3G (가격 결과)  │
  │ M3H (어드민 가격관리 8 팝업)     │
  └─────────────────────────────────┘
       │
       └─→ M3J (design-decisions.md, 통합)
```

### M4 내부 (순차 실행 권고)

M4는 모든 M3 산출물의 인용·통합이라 순차 실행이 안전. 단 M4B(executive-summary)와 M4C(handoff)는 M4A 작성 후 병렬 가능.

### M5 내부 (병렬 실행 가능)

M5A 완료 후 M5B(SPEC 초안)와 M5C(위험 등록부)는 병렬 작성 가능.

---

## 중요 의존성 흐름 (요약)

### Critical Path (가장 긴 의존 체인)

```
M1 As-Is 분석
  → M2 product-master.md
    → M2 cross-mapping.md
      → M2 schema.sql
        → PM consistency-report.md
          → [BLOCKER] INC-006 해결
            → M3 sitemap.md
              → M3 wireframes
                → M3 design-decisions.md
                  → M4 design-spec.md
                    → M4 handoff-to-build.md
                      → M5 SPEC 인덱스
                        → M5 SPEC 초안
```

길이: 13 단계. 본 체인 단축 = 전체 프로젝트 단축.

### 결정-차단 흐름 (사용자 결정이 진행을 막는 경로)

```
D-PM-01 미회신
  → INC-001 미해결
    → schema.sql 미확정
      → M3 상품관리 화면 미정
        → M4 통합 설계서 상품 절 미정
          → M5 SPEC-PQ-CATALOG 미정

D-PM-31 미회신 (배송비)
  → INC-004 미해결
    → 가격 엔진 Step 6 미정
      → M3 결제 화면 총액 표시 미정
        → M4 통합 설계서 결제 절 미정
          → M5 SPEC-PQ-PRICING/ORDER 미정
```

→ 사용자 결정 회신이 critical path를 직접 지배. pq-pm은 결정 요청을 우선 처리.

---

## 변경 이력

| 버전 | 날짜 | 변경 | 작성자 |
|------|------|------|--------|
| 1.0 | 2026-05-27 | M1+M2 완료 시점 1차 작성, YOU ARE HERE 마커 = M3 시작점 | pq-pm |

다음 갱신: M3 진행 중 (Track A/B/C 각각 완료 시).
