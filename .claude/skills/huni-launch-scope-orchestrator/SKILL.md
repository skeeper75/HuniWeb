---
name: huni-launch-scope-orchestrator
description: 후니프린팅 1차 런칭 개발범위·Shopby 갭·개발방안 하네스 오케스트레이터(§29). 프로젝트일정관리 통합IA(162기능)를 읽고 docs/shopby를 적용할 때 기능 수정·보완 필요분을 찾아, Shopby로 해결되는 것과 안 되는 것을 분류하고 미해결분을 어떻게 개발할지 새 문서로 산출한다. 1차 런칭 범위(main.asp 상품리스트·회원/프린트머니 마이그레이션)는 라이브 사이트 로그인→마이페이지→전체 사이트맵 전수 분석으로 세부 기능목록까지, 2·3차는 안정·확장 로드맵으로 정리. 6 에이전트(hls-live-cartographer∥hls-foundation-curator 팬아웃 → hls-gap-analyst → hls-migration-designer → hls-codex-verifier → hls-scope-gate). §10 hpp·§24 hsb 산출 재사용·생성≠검증·codex 주장=가설·라이브 읽기전용·설계/명세까지(실 구현·이관은 인간 승인). 트리거: '1차 런칭 개발범위', '런칭 스코핑', 'Shopby 갭 분석', 'Shopby 해결 미해결', '기능 수정 보완 도출', '회원 프린트머니 마이그레이션', '라이브 사이트맵 마이페이지 분석', '개발방안 문서', '런칭 범위 하네스 실행/재실행/업데이트/보완', '특정 영역만 갭/개발방안'. 가격→장바구니→주문 통합 설계는 §24, 일정 IA 엑셀 산출은 §10, 위젯 구현은 §6. 단순 질문은 직접 응답.
---

# Huni-Launch-Scope 오케스트레이터 (§29)

## 목표
프로젝트일정관리 통합IA(162기능) × `docs/shopby` → **Shopby로 해결되는 것 / 부분 / 미해결**을 분류하고, 미해결·부분분의 **개발방안**을 설계해 새 문서로 산출. **1차 런칭 범위**(상품리스트·회원/프린트머니 마이그레이션·마이페이지 P0)는 라이브 사이트 전수 분석으로 세부 기능목록까지, 2차(안정)·3차(확장)는 보완 로드맵으로.

## 실행 모드 — 하이브리드
- **Phase A(기준점)**: 서브에이전트 병렬(`run_in_background`) — live-cartographer ∥ foundation-curator.
- **Phase B(생성)**: 순차 — gap-analyst → migration-designer.
- **Phase C(검증)**: 순차 — codex-verifier → scope-gate.
- 데이터 전달: 파일 기반(`_workspace/huni-launch-scope/` 하위). 모든 Agent 호출은 `model: "opus"`.

## Phase 0: 컨텍스트 확인
- `_workspace/huni-launch-scope/` 존재 + 부분 수정 요청 → 부분 재실행(해당 에이전트만).
- 존재 + 새 입력(IA 새 버전 등) → 기존을 `_workspace_prev/`로 이동 후 새 실행.
- 미존재 → 초기 실행. 자격증명 점검: `.env.local` HUNIPRINTING_SITE_ID/PW·SHOPBY_*·HUNI_LIVE_*.

## Phase A — 기준점 팬아웃 (병렬)
1. **hls-live-cartographer** (`hls-live-cartography`) — 라이브 huniprinting.com 로그인→사이트맵·마이페이지 전수 → `00_live/`(As-Is 인벤토리·1차 범위 세부·마이그레이션 화면 단서).
2. **hls-foundation-curator** (`hls-foundation-curation`) — IA 162 Phase정본 + Shopby capability 맵(§10·§24 재사용) → `01_foundation/`.

## Phase B — 생성 (순차)
3. **hls-gap-analyst** (`hls-gap-analysis`) — IA×Shopby×As-Is → fit-gap 매트릭스(SOLVED/PARTIAL/CUSTOM) + 미해결 개발방안. 1차=세부, 2·3차=로드맵 → `02_gap/`.
4. **hls-migration-designer** (`hls-migration-design`) — 회원/프린트머니 마이그레이션 설계·명세 → `03_migration/`.

## Phase C — 검증 (순차)
5. **hls-codex-verifier** (`hqv-codex-cross-verify` 재사용) — codex 독립 2차 → `04_codex/` reconcile.
6. **hls-scope-gate** (`hls-scope-gate-validation`) — L1~L7 독립 재실측 → `05_gate/gate-verdict.md` + 최종 문서 `후니프린팅_1차런칭_개발범위_Shopby갭_개발방안.md`. NO-GO 영역은 해당 생성 에이전트로 루프.

## 데이터 흐름
```
00_live ─┐
01_foundation ─┴→ 02_gap → 03_migration → 04_codex → 05_gate(verdict + 최종문서)
```

## 에러 핸들링
- 에이전트 1회 재시도 후 재실패 시 그 산출 없이 진행 + 문서에 누락 명시. 라이브 로그인 실패 시 비로그인분만 + 명시(pending 금지). codex 미가용 시 "Claude 단독" 명시. 상충 데이터는 삭제 말고 출처 병기.

## 경계 (재병합 금지)
- 가격→장바구니→주문 종단 통합 설계=§24 Huni-Shopby. 일정 IA 엑셀 산출=§10. 위젯 구현=§6. 본 하네스는 **런칭 스코핑·fit-gap·개발방안·마이그레이션 설계** 전용. 실 구현·데이터 이관·COMMIT은 인간 승인 후 위 트랙 위임.

## 테스트 시나리오
- **정상**: "1차 런칭 개발범위 문서 만들어줘" → Phase A 병렬 → B → C → 최종 문서 GO. 1차 범위 세부 + 2·3차 로드맵 + 마이그레이션 설계 포함, IA 162 누락 0.
- **에러**: 라이브 로그인 실패 → cartographer가 비로그인 사이트맵만 산출 + "마이페이지 미접근" 명시 → gap-analyst가 마이페이지 기능은 IA·Shopby 기준으로만 판정하고 "라이브 미검증" 플래그 → scope-gate L5에서 한계 기록.
