# 하네스 전수 감사 — 마스터 정리 계획

> 2026-06-18 · /harness:harness 운영/유지보수 · 2 감사관(inventory-auditor + price-cluster-auditor) 병렬 + 메인 검증
> 현황: 후니 하네스 **12개** · 에이전트 90(후니 68 + moai 22) · 스킬 118(후니 ~67 + 프레임워크 ~51)

## ★ 핵심 결론: 통합할 게 거의 없다

가격 클러스터(§7 dbmap·§13 hpq·§14 hped·§15 hqv)는 **중복이 아니라 의도적 상보 레이어** — 이해(§14) → 냉철 게이트(§13) → 단일상품 온디맨드+Codex(§15) → 적재/심의(§7). 오케스트레이터들이 서로를 명시 참조하며 경계 선언. 생성≠검증 분리 때문에 **통합하면 오히려 품질 저하**. dbm-price-arbiter를 §13·§15가 공유 호출하는 건 중복이 아니라 모범.

→ 실제 할 일 = **STALE 정정 + 드리프트 정리 + 경계 명문화** (대규모 통합 아님). 전부 문서/배선 수정 — 코드·라이브 DB·에이전트 삭제 없음.

## Wave A — STALE 정정 (🔴 HIGH·안전·고효과)

| ID | 대상 | 현재(STALE) | 정정 |
|----|------|------------|------|
| A-1 | dbm-price-engine-verifier(에이전트)·dbm-price-engine-verify(스킬)·huni-dbmap-orchestrator round-18·dbm-option-mapper | "라이브 evaluate_price 미구현·pricing.py 부재·호출할 엔진 없음" | 엔진 실재(pricing.py @247·§13/§15 실호출 확인). 이 트랙=**사슬 완전성 전수 실측 전용**, 재계산은 §13/§15에 양보. prcx01 인용 STALE 가드 추가 |
| A-2 | dbm-schema-analyst | "29개 테이블" | "44 (t_* 34 + Django 10)" |

**보류(섣부른 정정 금지)**: frm_typ_cd/clr_cd를 라이브 권위로 단정하는 dbm-price-import-prep·dbm-price-formula → dbm-price-formula-audit의 라이브 결판 후 반영(컬럼 실재 vs 계약의미 폐기의 미묘한 모순). CPQ "도수=opt_id"는 STALE 아님(별개 축·손대지 말 것).

## Wave B — 드리프트 정리 (🟡 구조 정합)

| ID | 대상 | 조치 |
|----|------|------|
| B-1 | round-24 dbm-category-auditor·dbm-category-mapper + 스킬 dbm-category-audit·dbm-category-mapping | dbm 오케스트레이터 round 테이블에 등재(현재 CLAUDE.md §7 narrative에만 존재·라우팅 미인지) |
| B-2 | dbm 오케스트레이터 유령 토큰 6종(pq-design·pq-schema·pq-option-gaps·pq-option-load·pq-option-mapping·pq-option-validation) | 디스크 부재 옛 명명 → 제거(또는 현 dbm-* 명으로 교정) |
| B-3 | 방법론 스킬 본문 배선 누락(hpq-quote-gate-validation·hpq-price-chain-inspection·hped-binding-validity-mapping·hqv-quote-verification·hbg 5종 등) | **삭제 아님** — 스킬은 스폰 프롬프트로 호출되나 에이전트 .md 본문에 미명시 → durable 배선 위해 각 에이전트 .md에 "방법론=<skill> 사용" 한 줄 추가 |

## Wave C — 경계 명문화 (⚪ 중복 방지·통합 아님)

| ID | 대상 | 조치 |
|----|------|------|
| C-1 | §13 hpq-engine-cartographer ↔ §14 hped-mechanism-researcher (계약 vs 원리·30~50% 중첩) | 각 description에 경계 한 줄 명문화 |
| C-2 | §13 ↔ §15 (동형 커버리지 게이트 vs 온디맨드+Codex) | 경계 한 줄 명문화(이미 일부 존재·보강) |

## 안전
모두 문서/배선 수정. 라이브 DB 쓰기 0·에이전트 삭제 0·코드 0. 가격 클러스터 4 하네스 구조 유지(통합 안 함). 변경 후 CLAUDE.md 변경이력 갱신 + 메모리 STALE 정정 반영.
