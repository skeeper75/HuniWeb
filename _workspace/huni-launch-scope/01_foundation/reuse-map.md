# reuse-map.md — 기준점 큐레이션 재사용 출처 + freshness

> 산출자: hls-foundation-curator. 작성: 2026-06-30.
> 두 기준점(IA 정본·Shopby capability 맵)이 어떤 기존 산출물을 재사용했고, 각 출처의
> 신선도(freshness)는 어떤지 기록. ★STALE 출처는 인용 시 경고 표기.

---

## 1. IA 정본 (`ia-feature-canon.csv`)

| 출처 | 경로 | 권위 | 날짜 | freshness | 비고 |
|------|------|------|------|-----------|------|
| **IA 마스터 엑셀** | `docs/huni/후니프린팅_프로젝트일정관리_통합IA_260616.xlsx` `02_IA마스터`(162행)·`03_페이즈일정` | ★절대 권위 | 2026-06-16 | **FRESH**(14일) | 정본의 단일 진실 소스. openpyxl 파싱 |
| §10 huni-project-plan 산출 | `_workspace/huni-project-plan/03_build`·`04_qa` | 참조만 | 2026-06-16 | FRESH | 엑셀이 권위·산출은 교차 참조용(별도 재가공 안 함) |

**정규화 규칙**
- 헤더=4행, 데이터=5~166행(162건). 컬럼: No·시스템·영역·기능·우선순위·담당·담당자·규모·진행상태·Phase/주차·구분·확인·결정 필요사항(선행조건)·비고.
- Phase 정규화: `1차(런칭)`/`2차(안정)`/`3차(확장)` 3버킷. 원본 주차범위는 phase 셀에 보존(예 `1차(W3-5)`·`2차(W11-20)`·`3차(W21~)`)하여 무손실+필터가능(앞 2글자 startswith).
- ★실측: Phase ↔ 우선순위가 **1:1 정합** — 1차=P0(64) / 2차=P1(73) / 3차=P2(25). (분석·판정은 gap-analyst 몫·여기선 사실만)
- `launch_flag=LAUNCH` 기준(스킬 §15): 회원계열 영역(로그인·회원가입·마이페이지·회원·회원관리) ∪ 프린트머니(머니/적립금 키워드) ∪ 상품리스트(No153 전시 카테고리 트리·No154 상품 검색·필터 엔진). = 43건.

---

## 2. Shopby capability 맵 (`shopby-capability-map.csv`)

### 2.1 재사용 우선 [HARD] — §24 Huni-Shopby 산출물 (1차)

| 출처 | 경로 | 다룬 영역 | 날짜 | freshness |
|------|------|----------|------|-----------|
| commerce-flow-contract | `_workspace/huni-shopby/01_research/commerce-flow-contract.md` | 장바구니·주문서·결제·쿠폰·돈확정 지점(operationId 근거) | 2026-06-25 | **FRESH**(5일) |
| auth-session-model | `_workspace/huni-shopby/01_research/auth-session-model.md` | 회원/인증·소셜로그인·게스트 세션 | 2026-06-25 | FRESH |
| shopby-product-model | `_workspace/huni-shopby/02_bridge/shopby-product-model.md` | 상품/옵션 모델·옵션 제약·심사 | 2026-06-25 | FRESH |
| product-price-bridge-spec | `_workspace/huni-shopby/02_bridge/product-price-bridge-spec.md` | 동적 계산가 주입 경로(P-A~P-D)·라인 매핑 | 2026-06-25 | FRESH |
| open-questions(research/bridge) | `_workspace/huni-shopby/01_research·02_bridge/open-questions.md` | 미확인 항목 출처(Q-AUTH-1·Q-PAY-1·OQ-1~7) | 2026-06-25 | FRESH |

### 2.2 보강 — `docs/shopby/` 원문 (빠진 영역만)

| 출처 | 경로 | 보강 영역 | 날짜 | freshness | 경고 |
|------|------|----------|------|-----------|------|
| OpenAPI 스펙(member-shop) | `docs/shopby/shopby-api/member-shop-public.yml` | 회원 프로필·찾기·등급·휴면·탈퇴 operationId | (스펙 동기 4/1) | OK | 스펙=권위 |
| OpenAPI 스펙(promotion-shop) | `docs/shopby/shopby-api/promotion-shop-public.yml` | 쿠폰 발급/조회·적립금 storefront | (4/1) | OK | 스펙=권위 |
| OpenAPI 스펙(order-shop) | `docs/shopby/shopby-api/order-shop-public.yml` | 마이페이지 주문조회·배송지·적립금 사용 | (4/1) | OK | §24가 이미 인용·교차확인 |
| enterprise option.mdx | `docs/shopby/shopby_enterprise_docs` (§24 인용) | 옵션 5축 제한·수량할인 모델 | (4/1) | OK | §24 경유 |
| ⚠ admin-analysis/feature-matrix | `docs/shopby/admin-analysis/feature-matrix.md` | 어드민 NATIVE 분류(주문관리·정산·배송·회원관리·프로모션·통계) | **2026-03-18** | **AGED(~3.5개월)** | ★인용 시 경고: 생성 3.5개월 경과. Shopby 어드민 기능 분류는 안정적이나 최신 라이브 재확인 권장. 43기능 중 NATIVE 38·SKIN 2·CUSTOM 3 |

### 2.3 capability 맵 집계

- 49개 capability 행 / 10영역. 제공수준: **표준제공 39 · 부분 1 · 미제공 5 · 미확인 4**.
- ★핵심 미제공(가격): 카트 라인에 후니 동적 계산가(final_price) 직접 주입 = **스펙상 불가**(가격 입력 필드 0·재산출 모델). 옵션 동기화(P-A/P-B)로만 생존. 후니↔Shopby 매칭/전략 판정은 **gap-analyst/migration-designer 몫**(여기선 capability 사실만).

---

## 3. 한계·주의

- **추정 0 원칙**: 근거 없는 capability는 "미확인"(4건)으로 분리. 인증서비스(auth-shop) raw yml이 레포에 없어 토큰 발급 body shape는 미확인(Q-AUTH-1).
- **admin-analysis AGED**: 어드민 NATIVE 분류만 3.5개월 경과 출처에 의존. storefront(Shop API) 근거는 전부 FRESH §24 + 스펙 직접 grep으로 교차 보강.
- **적립금 vs 프린팅머니**: Shopby 적립금(accumulation)=구매적립형. 후니 "프린팅머니"=충전식 선불 잔액 — Shopby 전용 모델 미발견 → "부분(설정·BFF)"으로 분류. legacy 머니 마이그레이션은 migration-designer 영역.
- **본 산출은 두 자(尺)만 제작**(판정 없음). 후니 IA ↔ Shopby capability 대조·갭 판정은 hls-gap-analyst, 회원/머니 마이그레이션 설계는 hls-migration-designer가 수행.
