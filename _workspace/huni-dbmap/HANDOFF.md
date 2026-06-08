# Huni-DBMap — HANDOFF (다음 세션 재시작 포인터)

> 작성 2026-06-08(최신). 권위 = 본 문서 + `docs/goal-2026-06-08-01.md`(round-7) + 메모리 `dbmap-coverage-matrix-roundup`·`dbmap-live-admin-product-viewer`·`dbmap-l2-requires-l1-price-table`·`dbmap-option-material-process-bundle`. 본 문서 + 메모리를 읽으면 재발견 0으로 재개. 이전 트랙(round-2 가격·round-4/5 적재·plate·디지털인쇄·CPQ·round-6 현수막) 상세는 `CHANGELOG.md`·메모리에 보존.

## 한 줄 현황
**round-7 입체 커버리지 검증 트랙 신설 — 하네스 골격 구축 완료, 실행 미시작(사용자 정리 요청으로 중단).** 사용자 피드백("시트별 종단에 집중하니 전체 조망이 빠짐")을 반영해 **전 상품군(11시트) × 라이브 t_* 엔티티 3차원 매트릭스** 조망 트랙을 신설. 신규 에이전트 `dbm-coverage-auditor` + 신규 스킬 `dbm-coverage-matrix` + goal 문서 + 오케스트레이터 round-7(8인 팀) **완성**. 실제 검증 실행(B~D)·독립 평가는 다음 세션.

## 이번 세션 핵심 결정·발견 (재논의 금지)
- **[설계] 입체 검증 = 시트×엔티티 매트릭스(너비)** — round-1~6은 시트별 종단(깊이)이라 "전 상품군에 걸쳐 무엇이 빠졌나"를 한 판에서 보는 축이 부재. round-7은 행=상품군 11, 열=t_* 엔티티, 셀=필요여부(엑셀 권위)+적재상태(라이브 실측)+정합(3원 대조). 깊이가 못 보는 것을 너비가 본다.
- **[사용자 확정] 범위·진화·검증 깊이 3결정** — ① 범위=전 상품군 전수 + 미적재 동시(한 판에 적재+미적재) ② 진화=신규 조망 트랙 신설(에이전트+스킬) ③ 라이브=대표상품+미적재 의심분 집중(전수 아님).
- **[권위] 검증 권위 3단** — 엑셀 명시값=필요요소 정답 / 라이브 DB(읽기전용 psql)=적재 사실 / 라이브 admin product-viewer=t_* 역할 UI ground-truth. 추출본은 권위 아님(stale).
- **[완료기준] C1~C8** — 매트릭스 완전성·필요요소 정확성·적재 실측·3원 대조·관계 무결성·갭 보드 정직성·생성검증 독립성·재현성. `evaluator-active`(fresh context)가 독립 채점. 권위 `docs/goal-2026-06-08-01.md`.

## 다음 시작점 (정확한 다음 행동 — 택1)
1. **[권장·실행] round-7 검증 실행** — "입체 커버리지" 또는 "전 상품군 조망"으로 트리거 → `huni-dbmap-orchestrator` → `dbm-coverage-auditor`(foreground, Write 있으므로 background 금지) 스폰. 산출: `_workspace/huni-dbmap/12_coverage/`(coverage-matrix.md·coverage-cells.csv·gap-board.md·relationship-integrity.md·scripts/·admin-captures/). 절차 = `dbm-coverage-matrix` 스킬 §1~10. **admin 자격증명 먼저 확인**(미해결 참조).
2. **[검증 후] 독립 평가** — `evaluator-active`(fresh context)로 C1~C8 채점 → `03_validation/coverage-matrix-gate.md`. C7(독립성): 작성자≠평가자, 실결함 ≥1 적발이 정상.
3. **[이월·인간 승인] round-6 일반현수막 실 적재** — GO 적재본 `09_load/_exec_silsa_banner/`(v2). siz 77 등록·자재 mint 4·자재 링크·열재단 PROC_000084·실 COMMIT(전부 인간 승인). 상세 = CHANGELOG 2026-06-08 행.

## 미해결 / 블로커
- **admin product-viewer 자격증명 확인 필요** — `.env.local`에 admin 전용 키가 명시적으로 없음(`HUNIPRINTING_SITE_ID`/`PW`는 있음). URL=`https://huni-admin-production.up.railway.app/admin/product-viewer/`. 메모리 `dbmap-live-admin-product-viewer`에 admin 계정 단서 있음. round-7 실행 시 gstack browse 로그인 전에 자격증명 확정(추측 로그인 금지, 막히면 사용자에 질의).
- **round-7 실행 자체가 미착수** — 골격만 완성. 매트릭스·갭 보드·관계 무결성·평가 게이트 전부 미생성.
- **이전 트랙 잔존**(CHANGELOG): round-6 일반현수막 실 적재(인간 승인)·디지털인쇄 잔존 차단(3절/투명/박/048/019·030·049 plate교정)·excl_group 마이그(GAP-2)·미해결 설계결정(잉크색·머그용량·면지/바인더링·보드종류·각목 2규격).

## 건드리지 말 것 (확정·검증 완료)
- `docs/goal-2026-06-08-01.md` — round-7 권위(C1~C8). 이번 세션 작성.
- `.claude/agents/huni-dbmap/dbm-coverage-auditor.md` — 신규 에이전트(model: opus). 이번 세션 작성.
- `.claude/skills/dbm-coverage-matrix/SKILL.md` — 신규 방법론 스킬. 이번 세션 작성.
- `.claude/skills/huni-dbmap-orchestrator/SKILL.md` — round-7(8인 팀) 반영. 이번 세션 수정.
- 이전 GO·라이브 COMMIT분(디지털인쇄 308행·상품마스터·가격·round-6 현수막 적재본 등 CHANGELOG 보존).
