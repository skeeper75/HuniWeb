# Huni-Launch-Scope (§29) — 1차 런칭 개발범위·Shopby 갭·개발방안

## 목적
프로젝트일정관리 통합IA(162기능) × `docs/shopby` → Shopby 해결/부분/미해결 분류 + 미해결분 개발방안 + 회원/프린트머니 마이그레이션 설계. 1차 런칭(상품리스트·회원/프린트머니·마이페이지 P0)은 라이브 전수 분석으로 세부까지, 2·3차는 안정·확장 로드맵.

## 디렉토리
- `00_live/` — 라이브 사이트맵·마이페이지 전수·As-Is 인벤토리·마이그레이션 화면 단서 (hls-live-cartographer)
- `01_foundation/` — IA 162 Phase정본 + Shopby capability 맵 (hls-foundation-curator·§10/§24 재사용)
- `02_gap/` — fit-gap 매트릭스·개발방안 (hls-gap-analyst)
- `03_migration/` — 회원/프린트머니 마이그레이션 설계 (hls-migration-designer)
- `04_codex/` — codex 독립 2차 reconcile (hls-codex-verifier)
- `05_gate/` — L1~L7 게이트 + **최종 문서**(`후니프린팅_1차런칭_개발범위_Shopby갭_개발방안.md`) (hls-scope-gate)

## 핵심 결정 (2026-06-30 초기 구성)
1. 새 하네스(§24 Shopby·§10 IA와 별개·재사용)·런칭 스코핑 전용.
2. 마이그레이션=설계·명세 중심(원천 구 DB 미접근·라이브 화면+Shopby 모델 기준)·실 이관 인간 승인 후.
3. 문서 깊이=Phase 1(런칭) 세부 / 2차 안정·3차 확장 보완 로드맵.
4. 생성≠검증·codex 주장=가설·라이브 읽기전용(주문/결제/회원변경 금지)·DB/코드 미수정.

## 권위
- IA: `docs/huni/후니프린팅_프로젝트일정관리_통합IA_260616.xlsx`(02_IA마스터 162·03_페이즈일정).
- Shopby: `docs/shopby/`(OpenAPI 24종·enterprise·admin-analysis·aurora) + §24 `_workspace/huni-shopby/`.
- 라이브: huniprinting.com(`.env.local` HUNIPRINTING_SITE_ID/PW·HUNI_LIVE_*).

## 실행
오케스트레이터 스킬 `huni-launch-scope-orchestrator`. Phase A 병렬 → B → C.
