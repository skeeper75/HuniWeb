# wave-1 등록 로그 (129 폼보드 · 130 포맥스보드)

> §31 Huni-Constraint-Rules · Phase 5 · hcr-ui-registrar · 2026-07-02
> 선행: gate-report.md verdict=GO(wave-1 8규칙) + 인간 승인(2026-07-02 AskUserQuestion "승인 — 등록 진행")

## 1. 대상
- PRD_000129 폼보드 · PRD_000130 포맥스보드
- 규칙: 구 `R_DEMO_MATSIZ` 논리삭제(2행) + `R_MATSIZ_*` 신규 8건(129×4·130×4)
- 원천: `03_rules/wave1-pilot/apply-fix.sql`(UPDATE 2 + INSERT 8)

## 2. 백업 (pre-COMMIT dump)
- 경로: `04_register/wave1/backup-20260702-142401.sql`
- 내용: 129/130 기존 제약 행 전량(12컬럼) — 실행 전 R_DEMO_MATSIZ 2행. `INSERT … ON CONFLICT DO UPDATE`(전 컬럼 복원형).
- ※ 초기 dump(142335)는 컬럼/값 정렬 오류(del_dt 누락)로 폐기, 142401로 재생성.

## 3. DRY-RUN
- `apply-dryrun.sql` (BEGIN…ROLLBACK) 실행 exit=0.
- 결과: UPDATE 2 + INSERT 8 → 트랜잭션 내 활성 8 + 구데모 비활성 2, ROLLBACK 후 DB 무변경(R_DEMO 2행 활성 유지).
- 제약위반 0 · JSONB 캐스팅 정상 · 500 위험 0.

## 4. COMMIT
- `apply-fix.sql` 실행 exit=0. BEGIN → UPDATE 2 → INSERT 0 1 ×8 → COMMIT.
- 사후 즉시 재SELECT: 활성(use_yn=Y·del_yn=N) 8건 · 구 R_DEMO_MATSIZ 양 상품 use_yn=N·del_yn=Y.
- t_prd_product_constraints 외 테이블 쓰기 0.

## 5. undo 경로
- `03_rules/wave1-pilot/undo.sql` — 신규 8규칙 논리삭제(use_yn=N·del_yn=Y) + 구 R_DEMO_MATSIZ 재활성(use_yn=Y·del_yn=N). 대칭 복원.
- 전 컬럼 원상복구 필요 시: `04_register/wave1/backup-20260702-142401.sql`.

## 6. 다음
- UI 실화면 4항 판정 → `ui-verify.md`. 사후검증 → `postverify.md`. 둘 다 PASS → wave 완료.
