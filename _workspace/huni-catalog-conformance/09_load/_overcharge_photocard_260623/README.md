# _overcharge_photocard_260623 — 포토카드 과대청구(V3) 교정 적재본

> §21 카탈로그 정합 · 2026-06-23 · **라이브 COMMIT 완료**(인간 승인·momentum).
> 권위: `06_gate/overcharge-remediation-spec.md` V3 + `04_price_engine/overcharge-scan-catalog.md` OC-07/08.

## 결함 → 교정

- **결함**: PRD_000024(포토카드)·PRD_000025(투명포토카드)가 같은 `PRF_PHOTOCARD_FIXED`에 바인딩되고
  판별축 전무 → evaluate_price가 일반 comp(6,000)+투명 comp(8,500) **둘 다 silent 합산 = 14,500 과대**.
- **교정(권고① 상품별 공식분리)**: `PRF_PHOTOCARD_NORMAL`(024·SET만)·`PRF_PHOTOCARD_CLEAR`(025·CLEAR_SET만)
  신설 + 바인딩 재배선 + 고아 `PRF_PHOTOCARD_FIXED` use_yn=N. comp/단가행 기존 재사용(verbatim).
- **결과**: 024=**6,000**·025=**8,500** (silent 합산 해소). 단가값 0변경.

## 파일

| 파일 | 내용 |
|------|------|
| `backup-20260623_013932.sql` | 물리 백업(변경 전 공식·바인딩·FC·단가행 기준선) |
| `photocard-mapping.csv` | 교정 매핑(액션·before/after·단가변경 0) |
| `apply.sql` | 멱등 적재 SQL(FK 위상 A→B→C→D·G-1/G-2 가드·기본 ROLLBACK) |
| `dryrun_evaluate.sql` | evaluate_price 로직 SQL 재현 DRY-RUN(14,500→6,000/8,500 실증) |
| `dryrun_evaluate.py` | (참고) Django evaluate_price 실호출본 — venv 부재로 미실행, SQL 재현으로 대체 |
| `dryrun-result.md` | DRY-RUN 결과(SBM·실증·verbatim·멱등·위상) |
| `verbatim-guard.md` | 단가값 불변 증명(단가행 미접촉·SET 0) |
| `commit-log.md` | 라이브 COMMIT 기록·되돌리지 말 것 |
| `post-verify.md` | COMMIT 후 사후검증(별도 연결 영속·PV-1~6 PASS) |
| `undo.sql` | 되돌리기(위상 역순·기본 ROLLBACK) |

## 재실행/되돌리기

- 재실행: `apply.sql`은 멱등(ON CONFLICT·IS DISTINCT) — DRY-RUN은 그대로, COMMIT은 마지막 ROLLBACK→COMMIT.
- 되돌리기: `undo.sql`(BIND→FIXED 원복 → 신규공식 use_yn=N). 단가행 미변경이라 단가 복원 불요.

## 안전 제약 (전부 준수)

단가값 verbatim 불변 · 기초코드/공유 마스터(comp·단가행) 직접수정 0 · webadmin 코드 무수정 ·
라이브 읽기전용+롤백전용 DRY-RUN 후 승인된 COMMIT만 · 비밀값 비노출(.env.local만).
