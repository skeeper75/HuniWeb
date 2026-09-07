---
id: SPEC-STAFFBRIEF-001
doc: acceptance
version: "0.1.1"
updated: 2026-09-08
status: in-progress
tier: M
---

# 인수 기준 — SPEC-STAFFBRIEF-001

> 형식: `AC-SB-NNN` — Given / When / Then. 전 항목 **이진 판정 가능**.
> 말미의 `(REQ-SB-NNN)` 은 대응 요구사항. 전체 매핑은 §F 가 정본.
> [HARD 차단] 표기 항목은 1건 위반으로 전체 FAIL.

## §A 렌더 계약 (주축 1)

**AC-SB-001** — Given 렌더된 `.html` 이 카드 증거 디렉터리에 존재할 때, When `verdict.md` 의 실행 기록을 조회하면, Then `mode=status` · `audience=basic` 이 명시되어 있고 렌더에 사용한 스킬 판독 경로(메인 체크아웃 절대경로 또는 Skill() 로딩)가 기록되어 있다. (REQ-SB-012)

**AC-SB-002** — Given 산출 `.html` 을 텍스트 편집기로 열었을 때, When 외부 리소스 참조를 검사하면, Then 외부 JS/CSS 참조가 0건이다(허용 예외: 폰트 CDN · mermaid CDN + noscript 폴백). 파일 하나로 자립 동작한다. (REQ-SB-013)

**AC-SB-003** — Given 산출 `.html` 의 파일 크기, When 바이트 수를 측정하면(`ls -l`), Then **≤ 122,880 바이트**(=120KB, 1024 진법 · plan D-6). (REQ-SB-014)

**AC-SB-004** — Given 산출 `.html` 의 CSS 변수 · 폰트 선언, When 검사하면, Then `:root` primary 계열이 `#5538B6` 이고 폰트 스택이 Noto Sans KR 로 오버라이드되어 있다. `#553886` 계열 색상이 0건이다. (REQ-SB-015)

**AC-SB-005** — Given mermaid 블록에 담긴 정보 각각에 대해, When 오프라인(noscript 폴백만) 상태를 가정하고 동일 정보를 찾으면, Then 인라인 SVG 또는 산문에서 동일 정보가 발견된다 — mermaid 배타 정보 0건. (REQ-SB-016)

**AC-SB-006** — Given md twin 파일, When html 본문과 대조하면, Then 핵심 수치 · 결론이 전부 존재하고, basic 티어 부풀림(비유 · worked example 산문)이 md 에 재수록되어 있지 않다. [HARD 차단] (REQ-SB-017)

## §B 수치 소급·입력 사실 (주축 2)

**AC-SB-007** — Given 리포트 본문의 수치 주장 전체, When 각 수치의 근거를 역추적하면, Then research.md 근거(`파일:라인` · SELECT) 또는 렌더일 SELECT 실측 기록 둘 중 하나로 소급된다 — 근거 없는 수치 0건. [HARD 차단] (REQ-SB-001)

**AC-SB-008** — Given 스냅샷 수치 인용부(8/22 감사 · 8/27 재진단 수치) 전체, When 검사하면, Then 전부 측정 시점 라벨을 동반한다 — 라벨 없는 스냅샷 수치 0건. (REQ-SB-003)

**AC-SB-009** — Given 본문의 「현재값」 지표 4종(운영 활성 상품 · 게시 위젯 · 공식 바인딩 상품 · 주문 수), When 값을 재실측 기록과 대조하면, Then 렌더일 재실측값과 일치하고 as-of 라벨이 렌더일로 명시되어 있다(재실측 불가 폴백 시 9/7 값 + 시점 라벨 + 머리 고지). (REQ-SB-004, REQ-SB-005)

**AC-SB-010** — Given 매뉴얼 인용부 전체, When 권위본을 검사하면, Then 2026-09-06 재생성본 기준이고, `260824-baseline` 을 현재 상태로 제시한 문장이 0건이다. (REQ-SB-002)

## §C 정직한 서술 — 과대포장 금지 7종 (주축 3)

**AC-SB-011** — Given 게시 위젯 서술부, When 검사하면, Then 「게시됨 ≠ 주문 가능」 명시와 8/22 감사 맥락(98개 막힘) · 재현율 65%(2026-08-27 재진단에서 확인)이 함께 있고, "전부 주문 가능"형 서술이 0건이다. (REQ-SB-006)

**AC-SB-012** — Given 위젯 소개부, When 어휘를 검사하면, Then 라이브 위젯은 Web Component · 바닐라 JS 로 서술되어 있고, 라이브 문맥에 React/shadcn/Zustand 어휘가 0건이며, React 재구현 트랙은 별개 트랙으로 라벨되어 있다. (REQ-SB-007)

**AC-SB-013** — Given 상품 뷰어 소개부, When 검사하면, Then **2026-06-10 스냅샷 기준** 라벨이 명시되어 있다. (REQ-SB-008)

**AC-SB-014** — Given 계획 기능(파트너 포털 · 다국어 · StepTab · 가격표 모달 · 출고예정일/배송비/예상무게) 언급부 전체, When 검사하면, Then 전부 「계획」 라벨을 동반한다 — 구현된 것처럼 서술한 곳 0건. (REQ-SB-009)

**AC-SB-015** — Given 미바인딩 90 언급부, When 검사하면, Then 시작가 · 템플릿가 병존 설명이 동반되고 「가격 없는 상품」 단정이 0건이다. (REQ-SB-010)

**AC-SB-016** — Given Edicus 소개부, When 검사하면, Then 실동작 서술(`/editor/resolve` · 토큰 대리 발급 · prjid)이고 "설계뿐" 감평 서술이 0건이다. (REQ-SB-011)

## §D 산출물·증거·안전·마감 (주축 4)

**AC-SB-017** — Given 카드 증거 디렉터리(`.moai/reports/t45/`), When 리드가 목록을 판독하면, Then 브리핑 md 원고 · 렌더 html · md twin · `verdict.md` · 재실측 쿼리/출력 기록이 전부 존재한다. (REQ-SB-020, REQ-SB-021)

**AC-SB-018** — Given run-phase 의 DB 접근 기록(증거의 쿼리 로그)과 git 변경분, When 검사하면, Then `SELECT` 외 쿼리가 0건이고 `raw/webadmin/**` 파일 수정이 0건이다. [HARD 차단] (REQ-SB-018, REQ-SB-019)

**AC-SB-019** — Given 발표일 2026-09-09, When 카드 완료 커밋 시각을 확인하면, Then 리포트 · 증거 완성이 **2026-09-08 이내**에 체결되어 있다. (plan §B — 마감)

**AC-SB-020** — Given 카드 브랜치의 카드 커밋, When 커밋 내용물을 검사하면, Then 증거 디렉터리 산출물이 포함되어 있고, 메인 체크아웃 미트래킹 자산(스킬 본체 · report.yaml)의 복사가 0건이다. (REQ-SB-022)

**AC-SB-021** — Given 본문의 전문용어 첫 등장 지점 전체(차원 · 단가유형 · 옵션 3층 · 게시/버전 · 제약규칙 등), When 각 지점을 검사하면, Then 인라인 평어 정의가 그 자리에 존재한다 — 정의 없는 첫 등장 0건. (REQ-SB-023)

**AC-SB-022** — Given 리포트 목차, When research §6 권장 뼈대와 대조하면, Then 메트릭 4장 · §1 한눈에 보기 ~ §5 직접 확인해 볼 것 · 리스크/계획 골격이 확인되고(status 모드 구조 계약과 충돌 0건), 리스크 섹션에 인지 리스크 2건(옵션코드 재번호→위젯 참조 파손 가능 · 회귀 테스트의 데이터 오염 탐지 한계)이 포함되어 있다. (REQ-SB-024)

**AC-SB-023** — Given 오프라인 발표 가능성, When 백업 자산을 확인하면, Then 렌더 결과의 PDF 또는 전체 페이지 스크린샷이 카드 증거 디렉터리에 존재한다. (REQ-SB-025)

## §E 종료 조건

1. §A~§D 의 AC-SB-001~023 전부 PASS(단일 FAIL 이면 종료 불가 — [HARD 차단] 항목은 특히).
2. `verdict.md` 가 판정 정본으로 작성되어 있고(§D-8 결정), 리드가 이를 판독했다.
3. 카드 커밋이 증거 산출물을 포함해 체결되어 있다(AC-SB-020).

## §F REQ ↔ AC 매핑 (정본)

| REQ | AC | REQ | AC |
|---|---|---|---|
| REQ-SB-001 | AC-SB-007 | REQ-SB-014 | AC-SB-003 |
| REQ-SB-002 | AC-SB-010 | REQ-SB-015 | AC-SB-004 |
| REQ-SB-003 | AC-SB-008 | REQ-SB-016 | AC-SB-005 |
| REQ-SB-004 | AC-SB-009 | REQ-SB-017 | AC-SB-006 |
| REQ-SB-005 | AC-SB-009 | REQ-SB-018 | AC-SB-018 |
| REQ-SB-006 | AC-SB-011 | REQ-SB-019 | AC-SB-018 |
| REQ-SB-007 | AC-SB-012 | REQ-SB-020 | AC-SB-017 |
| REQ-SB-008 | AC-SB-013 | REQ-SB-021 | AC-SB-017 |
| REQ-SB-009 | AC-SB-014 | REQ-SB-022 | AC-SB-020 |
| REQ-SB-010 | AC-SB-015 | REQ-SB-023 | AC-SB-021 |
| REQ-SB-011 | AC-SB-016 | REQ-SB-024 | AC-SB-022 |
| REQ-SB-012 | AC-SB-001 | REQ-SB-025 | AC-SB-023 |
| REQ-SB-013 | AC-SB-002 | 제약 C-2 · plan §B(마감) | AC-SB-019 |
