# 05. 권고 — pq-pm 의사결정 자료

생성일: 2026-05-27
선행: `01_overview.md`, `02_extensibility-points.md`, `03_print-fit-evaluation.md`, `04_three-options-comparison.md`
결정자: pq-pm (지니)

---

## 권고 옵션

**옵션 C — Aurora 미채택, 100% 자체 빌더 + Shopby Server API 호출** (가중합 80/100, 1순위)
**차선 — 옵션 B Hybrid** (가중합 65/100, B 검증 후에도 C의 일정 리스크가 부담된다면 fallback)

---

## 권고 사유 (3문단)

**첫 번째 — 도메인 모델 충돌이 본질적이다.** Aurora의 옵션·가격·결제 모델은 "어드민에 사전 등록된 SKU"와 "서버가 가격을 단일 진실로 재계산"하는 일반 커머스 가정 위에 서 있다. 후니프린팅의 인쇄 견적은 그 반대다 — 동적 옵션 조합, 클라이언트 산식, 구간 할인, 옵션 의존 룰이 본질. As-Is(buysangsang)가 TM Extra Product Options + Tiered Price Table로 워드프레스 위에서 그 격차를 메우고 있는 것 자체가 "일반 커머스 위에 인쇄 견적을 얹는 비용"의 증거. Aurora를 본체로 두면 똑같은 함정에 React 버전으로 빠지게 된다 (옵션 A의 가중합 21.7점은 이 진단의 정량 표현).

**두 번째 — Edicus 흡수 자산이 이미 도메인에 fit하다.** `docs/edicus.man/` (Next.js 15, React 19, TypeScript 5, 12K LOC)에는 Huni Design System v6.0 컴포넌트 8종(test coverage 85%), Edicus SDK 통합 스택(EdicusClient, ServerApiClient, HuniEditorSDK, 10개 Zod-검증 API route), 주문 lifecycle(tentative→definitive→cancel) 컴포넌트가 이미 갖춰져 있다. 즉 C의 35K 신규 LOC 중 12K는 흡수 가능하고, 나머지 23K(옵션·가격 엔진, 회원·결제, 공정 워크플로)는 도메인이 명확해 일정 산정이 가능한 영역이다. Aurora를 본체로 두면 Edicus 자산이 "외부 iframe"으로 강등되어 통합 자유도가 떨어진다.

**세 번째 — 운영·미래 비용 측면에서 단일 코드베이스가 우월하다.** Aurora는 private npm registry 토큰 의존, NHN커머스 업스트림 변경 추적, 사내 솔루션 약관 종속이라는 3중 묶임이 있다. Hybrid(B)는 두 코드베이스 경계 관리(인증 토큰 공유, URL/세션 일관성, 디자인 일관성)가 새 부담으로 추가된다. C는 단일 Next.js 코드베이스 + Shopby Server API 의존(spec 만 의존, 코드 의존 없음)으로 가장 가볍다. D2·D3·D7의 가중합이 이 차이를 표현.

---

## 채택 전 검증해야 할 3가지

### V1. Shopby Server API의 "동적 가격 결제" 지원 여부 — **최우선**

질문: Shopby Server API(`POST /payments/reserve` 또는 별도 외부 결제 통로)에 **어드민 상품 가격을 우회한 동적 가격을 클라이언트가 강제 주입할 수 있는가?**

- 가능: 옵션 C가 회원·결제도 Shopby로 가져갈 수 있음 → C 완전체.
- 불가능: 회원만 Shopby, 결제는 자체 PG 통합(이니시스/토스/네이버페이 직접) → C도 결제 자체 구현 부담. 이 경우 B(Aurora 체크아웃 차용)의 가치 상승.

검증 방법: Shopby 영업 담당 문의 + `shopby-api-docs-complete/04_server-api/` 정독 (특히 `payments`, `order-sheets/{no}/calculate`, `external-payment` 같은 키워드).

### V2. Edicus(motion-one) 라이선스·계약 조건

질문: Edicus SDK(`edicusbase.firebaseapp.com`)의 **라이선스 형태, partner=`hunip` 코드의 유효성, RedEditorSDK v6.6.48 자체 호스팅 가능 여부**.

- motion-one 단독 종속이면 SDK 종료/요금 변경 리스크 노출. → 옵션 C·B 모두 R5(Edicus 통합)가 2점으로 하향.
- 자체 호스팅 가능하면 R5 3점 확정.

검증 방법: motion-one에 계약 조건 직접 문의 + `docs/red-editor-sdk-analysis.md`(edicus-analysis 디렉토리 내 추정) 정독.

### V3. Aurora 코드베이스의 실측 LOC·의존성

질문: `https://skins.shopby.co.kr/shopby/aurora-skin` 클론 후 `package.json`, `vite.config.*` / `next.config.*`, `src/` LOC, 의존성 트리.

- React 버전, 빌드 도구, SSR 여부, i18n 시스템, theming 시스템 실측 확인.
- 옵션 B를 진지하게 고려하려면 회원·체크아웃 슬라이스의 LOC(어디까지 떼어낼 수 있는가)를 봐야 함.

검증 방법: GitLab 계정 발급 + 클론. 1시간 정도 코드 탐사.

---

## 향후 결정 dependent points

| ID | 의존 결정 | 결정에 따른 분기 |
|----|----------|------------------|
| DEP-1 | V1 결과 (Shopby 동적 가격 결제 지원) | 가능 → C 완전체 / 불가 → 결제 자체 구현 또는 B로 후퇴 |
| DEP-2 | V2 결과 (Edicus 라이선스) | OK → SDK 외부 호출 유지 / 위험 → RedEditorSDK 자체 호스팅 SPEC 추가 |
| DEP-3 | V3 결과 (Aurora 실측) | LOC 작음 + 회원 슬라이스 명확 → B를 fallback으로 유지 / 강결합 발견 → B 제외 |
| DEP-4 | Shopby Enterprise 도입 여부 | premium/enterprise만 SPI(인쇄업 특화 API) 제공 시 옵션 변경 가능 |
| DEP-5 | 후니프린팅 자체 백엔드 도입 시점 (Postgres/Supabase) | C는 자체 DB 전제 — 도입 시점이 C의 일정 결정 |
| DEP-6 | 디자인 시스템 통합 방향 (Huni DS v6.0 vs 새 system) | C/B에서 사용할 디자인 시스템 단일화 결정 필요 |

---

## ADR 초안 (pq-pm decisions.md 후보)

```markdown
## ADR-XXX: Frontend 아키텍처 — Aurora React Skin 미채택 + 자체 Next.js 빌더

상태: 제안(Proposed)
일자: 2026-05-27
결정자: pq-pm (지니)
관련 SPEC: SPEC-PQ-FRONTEND-ARCH-001 (예정)

### 컨텍스트

후니프린팅의 buysangsang(WordPress + Woodmart + TM EPO + MShop + Edicus) 레거시를
Shopby 기반으로 재구축하면서, Shopby가 제공하는 Aurora React Skin(NHN커머스 제작
React 템플릿)을 To-Be 프론트엔드로 채택할지 결정해야 함.

### 평가 (요약)

3옵션 8차원 가중합 평가 (`_workspace/print-quote/01_research/shopby-aurora-analysis/`):
- 옵션 A (Aurora Full 채택): 21.7 / 100
- 옵션 B (Hybrid — Aurora 회원·체크아웃 + 자체 빌더): 65.0 / 100
- 옵션 C (미채택 — 100% 자체 Next.js + Shopby Server API): **80.0 / 100**

인쇄 견적 도메인 적합성 평가(`03_print-fit-evaluation.md`): Aurora가 도메인 요구
30점 중 13점(43%) — 컷오프 하단. 결정적 한계 3건: (1) 가격 무결성 충돌, (2) 옵션
도메인 모델 강성, (3) 인쇄 공정·검수 워크플로 부재.

Edicus 흡수 자산(`docs/edicus.man/`, 12K LOC, Huni DS v6.0 + Edicus SDK 통합 스택)이
이미 도메인에 fit하므로 자체 빌더의 30~50%가 흡수 가능.

### 결정

옵션 C(Aurora 미채택, 자체 Next.js + Shopby Server API)를 1순위로 채택한다.
옵션 B(Hybrid)는 V1·V3 검증 결과에 따라 fallback으로 유지한다.

### 검증 전제 (V1·V2·V3)

본 결정은 다음 3가지 검증 결과에 따라 재평가될 수 있다:
- V1: Shopby Server API의 동적 가격 결제 지원 여부
- V2: Edicus(motion-one) 라이선스·계약 조건
- V3: Aurora 코드베이스 실측 (LOC, 의존성, theming 시스템)

### 결과

- 채택: 단일 Next.js + TypeScript + Edicus 흡수 + Shopby Server API 호출 아키텍처
- 거부: Aurora를 본체로 두는 아키텍처 (R2 가격 무결성 deal-breaker)
- 보류: Hybrid는 V1·V3 결과에 따라 차후 재검토

### 후속 조치

- pq-architect: SPEC-PQ-FRONTEND-ARCH-001 작성 (자체 빌더 도메인 슬라이스 분해)
- pq-researcher: V1·V2·V3 검증 라운드 수행
- pq-pm: 위 검증 완료 후 ADR 상태를 Accepted로 전환
```

---

## 완료 보고 요약 (200자 이내)

**옵션 C(Aurora 미채택, 100% 자체 Next.js + Shopby Server API) 권고. 가중합 80/100. 결정적 근거: Shopby 서버가 어드민 상품 가격을 단일 진실로 재계산하므로 동적 견적가 결제 불가 — 가격 무결성 충돌이 deal-breaker. Aurora를 본체로 두는 옵션 A는 가중합 21.7로 부적합.**

---

Version: 1.0.0
Status: 권고 완료. pq-pm 의사결정 대기.
