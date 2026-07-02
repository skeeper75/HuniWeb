---
name: huni-load-governance-orchestrator
description: 후니프린팅 적재 거버넌스 하네스(Huni-Load-Governance) 오케스트레이터. webadmin의 기준정보(마스터)·상품·가격관리에 실무진이 사람 판단으로 넣은 데이터를 "올바른 그릇 규범"으로 다스린다 — ① 상품유형(일반 완제품/셋트 완제품/반제품)×그릇(기준정보·옵션·템플릿·제약규칙·가격공식/구성요소) 적재 규범 정본 ② ★옵션 3용도 원칙(혼재 자재·공정 묶음/기준정보 밖 손님 선택/생산 전달)으로 옵션 전수 판정·기준정보 중복 적발·처분 명세(유지/정리/이관/확장) ③ codex 적대적 교차검증 ④ 코드 결함은 재현 가능한 개발자 전달 문서(DEV-REQUEST) ⑤ 최종 검증=가격이 제대로 나오는지(evaluate_price 골든). 5인 팀(hlg-vessel-norm-curator 기준점 → hlg-option-usage-auditor 생성 → hlg-codex-verifier 적대 교차 → hlg-dev-doc-writer C트랙 문서 → hlg-governance-gate LG1~LG7). 파일럿(일반 1+셋트 1) 완주→동형 전파·생성≠검증·권위=상품마스터·인쇄상품 가격표 260702·라이브 읽기전용·DB 미적재(실 COMMIT은 인간 승인 후 §7 dbmap/§31 registrar 위임). '적재 거버넌스', '옵션 정리', '옵션 쓰임새 판정', '옵션 중복 진단', '기준정보 옵션 중복', '그릇 규범', '어디에 적재해야', '옵션 오남용 정리', '적재 규범표', '개발자 전달 문서 작성', '적재하며 진단', '거버넌스 하네스 실행/재실행/업데이트/보완', '특정 상품군만 거버넌스', '옵션 진단 다시' 작업 시 반드시 이 스킬을 사용. 제약규칙 등록 자체는 §31, 정합 검증만은 §21, 가격테이블 셀 무결성은 §26, 셋트 구성 설계·적재는 §23, 실 적재 실행은 §7 위임. 단순 질문은 직접 응답.
---

# Huni-Load-Governance 오케스트레이터

## 목표
사람 판단으로 잘못 들어가거나 용도에 맞지 않게 매핑된 데이터를, "무엇이 어느 그릇에 있어야 하는가"의 규범으로 진단·정리 명세화하고, 코드가 문제면 개발자 문서로, 데이터가 문제면 기존 적재 트랙으로 라우팅한다. 최종 잣대는 가격이 제대로 나오는지다.

## 핵심 원칙 [HARD]
- **규범 먼저** — 규범 정본(vessel-norm) 없이 옵션 판정 금지. 판정 기준이 사람마다 달라지는 문제를 재생산하지 않는다.
- **옵션 3용도** — 옵션이 정당한 경우는 U-1(2개 이상 혼재 자재·공정 묶음)/U-2(기준정보에 없는 손님 선택)/U-3(생산 전달)뿐. 옵션은 개방적이어서 많이 쓰면 독(사용자 directive).
- **오차단 0** — 정당한 옵션을 정리하면 손님 선택지·매출이 사라진다. LG3가 최우선 게이트.
- **가격이 최종 검증** — 처분 후에도 evaluate_price PRICE≠0·권위 골든 오차 0. 셋트는 evaluate_set_price.
- **생성≠검증** — 판정·처분은 게이트가 독립 재실측. codex 적대 교차(주장=가설).
- **권위 = 260702** — 상품마스터·인쇄상품 가격표 최신버전(구 260610/260527 대체). 역공학·경쟁사는 갭헌팅 보강만.
- **DB 미적재** — 이 하네스는 명세까지. 실 COMMIT은 인간 승인 후 기존 트랙(§7 dbmap 적재·§31 hcr-ui-registrar·§17 hbd-load-executor) 위임. COMMIT 전 webadmin 실화면 확인 [HARD]은 위임 트랙 의무로 인계서에 명기.
- **기존 하네스 재사용·재병합 금지** — 오적재 진단(§21·§26)·제약 발굴(§31)·셋트 구조(§23)·배선(§27)은 그 산출물을 입력으로 재사용. 같은 조사를 반복하지 않는다.

## 실행 모드
**서브 에이전트** (Agent 도구·`model: "opus"` 명시). 팀 통신 불필요 — 파일 기반 전달(`_workspace/huni-load-governance/`)로 충분. 단계 간 순차 의존이 강해 파이프라인으로 진행.

## Phase 0: 컨텍스트 확인
- `_workspace/huni-load-governance/` 부재 → 초기 실행(전체).
- 존재 + 부분 요청(예: "옵션 진단만 다시", "특정 상품군만", "게이트만") → 해당 에이전트만 재호출.
- 존재 + 권위 엑셀 갱신 등 새 입력 → 기존을 `_workspace_prev/`로 이동 후 새 실행.
- 파일럿 상품군 미확정이면 AskUserQuestion으로 확정: 권장=일반 1(옵션이 많은 상품군: 스티커류 또는 디지털인쇄)+셋트 1(동작 검증된 책자류 072/068 계열).

## Phase 1: 규범 정본 (기준점)
- `hlg-vessel-norm-curator` → `01_norm/`(vessel-norm.md·option-usage-criteria.md).
- 규범의 SOT 충돌 발견 시 사용자 컨펌 후 다음 Phase 진행.

## Phase 2: 옵션 쓰임새 전수 판정 (생성)
- `hlg-option-usage-auditor` → `02_audit/<상품군>/`(option-usage-board.csv·disposition-spec.md).
- 입력으로 §21 `03_cpq_link/`·§17 표시중복·§27 wiring·live-snapshot 재사용을 프롬프트에 명시.

## Phase 3: codex 적대적 교차검증
- `hlg-codex-verifier` → `04_codex/<상품군>/`(codex-verdict.md·reconcile.md). 헬퍼=`hqv-codex-cross-verify/scripts/codex-review.sh`. 미가용 시 "Claude 단독" 명시 폴백.

## Phase 4: 개발자 전달 문서 (C트랙 분리)
- Phase 2~3에서 "데이터로 못 닫는 결함"(코드 개선/보완/수정/확장 필요)이 나오면 `hlg-dev-doc-writer` → `03_devdoc/DEV-REQUEST-*.md`. 없으면 NO-OP(빈 문서 생산 금지).

## Phase 5: 게이트
- `hlg-governance-gate` → `05_gate/<상품군>/`(gate-report.md LG1~LG7·handoff-spec.md). NO-GO → 해당 Phase 라우팅 루프(항목 단위).

## Phase 6: 인간 승인 → 위임 인계
- GO분 요약(처분 건수·이관 목적지·BLOCKED·undo 방향)을 AskUserQuestion으로 승인 요청.
- 승인분을 인계: 옵션 정리·기준정보 이관 → §7 dbmap 적재 트랙 / 제약 이관 → §31(CN-6 큐) / 템플릿 이관 → §7 CPQ 트랙 / 개발자 문서 → 사용자 전달.
- 파일럿 완주(가격 골든 확인까지) 후에만 다음 상품군 전파(동형 wave).

## Phase 7: 종합·진화
- 진척판(상품군×판정 커버리지×처분 상태) 갱신·CHANGELOG PREPEND·CLAUDE.md §34 변경이력 포인터 갱신. 실행 후 피드백 수집(에이전트/스킬 갱신).

## 데이터 전달
파일 기반: `01_norm` → `02_audit` → `04_codex` → (`03_devdoc`) → `05_gate` 순 의존. 중간 산출물 보존(감사 추적). 재사용 입력(§21·§17·§26·§27·§23·live-snapshot)은 각 에이전트 프롬프트에 경로 명시.

## 에러 핸들링
- 에이전트 실패=1회 재시도 후 해당 산출 없이 진행(보고서에 누락 명시). 라이브 접속 실패=UNVERIFIED 명시(PASS 위장 금지). 상충 데이터=출처 병기(삭제 금지). codex 미가용="Claude 단독" 명시(pending 금지). 판정 모호(AMBIG)=사용자 컨펌 큐(임의 확정 금지).

## 테스트 시나리오
- **정상**: "스티커 상품군 옵션 정리해줘" → Phase 0(파일럿 확정)→1(규범)→2(전수 판정: 기준정보 중복 N건·OVER M건)→3(codex 합의)→5(LG GO)→6(승인→§7 인계)→7.
- **에러 1(오판)**: codex가 RETIRE 대상 1건을 "U-2 정당(권위 시트에 손님 선택 축 실재)"으로 반박 → reconcile 조사 → 권위 재확인 결과 codex 옳음 → KEEP으로 정정 후 재게이트.
- **에러 2(가격 파손)**: LG4 시뮬레이션에서 옵션 정리 후 PRICE=0 발생 → 해당 옵션 가격종속 누락 판정 → BLOCKED 재분류·auditor 반송 → 재게이트 GO.

## 산출물 루트
`_workspace/huni-load-governance/` (01_norm·02_audit·03_devdoc·04_codex·05_gate·_meta). 자격증명: `.env.local` `RAILWAY_DB_*`(읽기전용 SELECT)·`HUNI_ADMIN_*`(위임 트랙의 실화면 확인용, 이 하네스는 읽기 탐색만).
