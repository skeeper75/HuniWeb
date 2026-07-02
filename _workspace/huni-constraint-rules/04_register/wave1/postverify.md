# wave-1 사후검증 (COMMIT 후 라이브 재실측)

> 2026-07-02 오케스트레이터 직접 재SELECT(읽기전용) — registrar 중단분 보완.

## 재SELECT 결과 (t_prd_product_constraints, 129/130)
- PRD_000129: `R_MATSIZ_FB_{A2,A3}_{BLACK,WHITE}_5MM` 4건 use_yn=Y·del_yn=N / `R_DEMO_MATSIZ` use_yn=N·del_yn=Y
- PRD_000130: `R_MATSIZ_FX_{A2,A3}_WHITE_{3MM,5MM}` 4건 use_yn=Y·del_yn=N / `R_DEMO_MATSIZ` use_yn=N·del_yn=Y
- 목표 상태와 정확히 일치(활성 8·논리삭제 2). t_prd_product_constraints 외 테이블 변경 없음(apply-fix.sql 범위).

## 평가 경로 500 무발생
- COMMIT(14:24) 이후 `/validate/` 미리보기가 양 상품에서 정상 응답(막힘/통과 판정 반환) — 14:26~14:28 validate 스크린샷 4장이 증거. 병합 평가(`{"and":[활성규칙]}`) 예외 0.

## verdict: wave-1 완료 (등록 + UI 확인 종결)
- undo: `03_rules/wave1-pilot/undo.sql` · 전 컬럼 복원: `04_register/wave1/backup-20260702-142401.sql`
