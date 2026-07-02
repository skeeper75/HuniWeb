# wave-3 등록 로그 (PRD_000047 소량전단지 · CN-3 코팅×종이두께)

> §31 Huni-Constraint-Rules · Phase 5 · hcr-ui-registrar · 2026-07-02
> 선행: gate-report.md verdict=GO(wave-3 1규칙 · W0) + 인간 승인(2026-07-02 AskUserQuestion "승인 — 등록 진행")

## 1. 대상
- PRD_000047 소량전단지
- 규칙: `R_EXCL_COATING_THIN_PAPER` (RULE_TYPE.02 금지) 신규 mint 1건
- 원천: `03_rules/wave3-dgp/apply-fix.sql` (INSERT 1)
- search-before-mint: 047 기존 제약 0건(라이브 확인) → 순수 신규 mint

## 2. 백업 (pre-COMMIT dump)
- 경로: `04_register/wave3/backup-20260702-172125.sql`
- 내용: 047 기존 제약 행 dump = **0건**(증빙 파일 생성). 신규 mint 이므로 복원 대상 없음.
- 복원 필요 시: `undo.sql`(신규 규칙 논리삭제) 로 대칭 처리.

## 3. DRY-RUN
- `apply-dryrun.sql` (BEGIN…ROLLBACK) 실행 exit=0.
- 결과: INSERT 0 1 → 트랜잭션 내 활성 1건 · logic_type=object · ROLLBACK 후 DB 무변경(0행 유지).
- 멱등 재실증(fix 본문 2회 in 롤백 tx): active=1 · total=1 · 중복 0(ON CONFLICT DO UPDATE).
- 제약위반 0 · JSONB 캐스팅 정상 · 500 위험 0.

## 4. COMMIT
- `apply-fix.sql` 실행 exit=0. BEGIN → INSERT 0 1 → COMMIT.
- 사후 즉시 재SELECT: 활성(use_yn=Y·del_yn=N) 1건 · rule_typ_cd=RULE_TYPE.02 · logic_type=object.
- t_prd_product_constraints 외 테이블 쓰기 0.

## 5. undo 경로
- `03_rules/wave3-dgp/undo.sql` — 신규 규칙 논리삭제(use_yn=N·del_yn=Y). 047 은 이전 제약 없어 복원 대상 없음(대칭 정합).
- 전 컬럼 원상복구(0건 상태) 참고: `04_register/wave3/backup-20260702-172125.sql`.

## 6. 다음
- UI 실화면 4항 판정 → `ui-verify.md`(전 PASS). 사후검증 → `postverify.md`(active=1·validate 200). wave-3 완료.
- 동형 확장(048·049)은 옵션그룹 선적재 후(BLOCKED-UI) — 본 wave 범위 밖.
