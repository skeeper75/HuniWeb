# Print-Quote 하네스 변경 이력

> 이 파일은 `CLAUDE.md`의 하네스 포인터에서 분리된 **전체 변경 이력**이다.
> CLAUDE.md에는 최근 3개 항목만 유지하고, 전체 이력은 여기서 관리한다.
> 새 변경 발생 시: ① 이 테이블 상단/하단에 추가 ② CLAUDE.md의 최근 3개 갱신.

| 날짜 | 변경 내용 | 대상 | 사유 |
|------|----------|------|------|
| 2026-05-27 | 초기 구성 (5인 팀 + 오케스트레이터 + 라이브크롤 스킬 + dbtest 베이스라인 이관) | 전체 | 자동견적 사이트 기획·설계 하네스 신규 구축 |
| 2026-05-27 | 라이브크롤 스킬 WP+Woo+Elementor 특화 + 저트래픽·읽기전용 안전 모드 (Phase A 무비용 정찰 우선, 트래픽 가드 200req/20MB, 캐시·조건부 GET, 리소스 차단) | print-quote-live-crawl, pq-researcher | buysangsang 분석 시 상대 서비스 영향·트래픽 비용 0 보장 사용자 요구 |
| 2026-05-27 | 분석 프레임 재정의: "경쟁사 분석" → **"As-Is 빌더 패턴 역공학(7축: widget/layout/template/interaction/form/token/plugin)"**. 후니프린팅이 자체 웹빌더(Elementor 류) 구축 중이며 buysangsang은 본인 사이트(리뉴얼 대상). 신규 산출물: `01_research/asis-buysangsang/`, `03_architecture/builder-engine/`, KPI=buildability coverage. pq-researcher·pq-architect 책임 재정의 | pq-researcher, pq-architect | 사용자 컨텍스트 확정 — 자체 빌더 구축 + Big-Bang 컷오버 |
| 2026-05-27 | **To-Be 아키텍처 결정**: edicus.man (Next.js 15 + Edicus SDK + Huni Design System v6.0)을 베이스라인으로 채택. Edicus SDK 외부 의존(edicusbase.firebaseapp.com) 유지. 견적·카탈로그·옵션 폼·가격 엔진·관리자·결제·인쇄 검수는 자체 신규 구축. 통합 대상 7개(Shopby Enterprise/Edicus/Wowpress/Neon PG/Figma/RedPrinting/buysangsang WP) 자격증명 `.env.local` 저장 (chmod 600, .gitignore 보호) | 전체 (pq-architect 영향 大) | 사용자 결정 + edicus.man 코드 분석 완료 결과 |
