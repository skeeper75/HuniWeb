-- apply.sql (_exec) — 부1 종이 계층 부활 라이브 COMMIT 래핑본
-- 부1만 COMMIT (자재 10행 del_yn 'Y'→'N'). 부2=CONFIRM 분리(COMMIT 제외).
-- 멱등[HARD]: WHERE del_yn IS DISTINCT FROM 'N'. 비파괴: UPDATE만(물리 DELETE 0·DDL 0·mint 0).
-- 단일 트랜잭션(BEGIN…COMMIT) — 부분커밋 경로 없음. 트리거 trg_t_mat_materials_upd_dt가 upd_dt 갱신.
-- ★실행 전 backup.sql 선행 필수(undo 가역). 자격증명 .env.local.

BEGIN;

-- P2-A: 전용지 부활 (셋트 072·082 표지 FK_DEAD 해소)
UPDATE t_mat_materials SET del_yn='N', del_dt=NULL
 WHERE mat_cd='MAT_000246' AND del_yn IS DISTINCT FROM 'N';

-- P3-A: 출력소재 종이 root 9 부활 (활성 자식 41 계층 복구)
UPDATE t_mat_materials SET del_yn='N', del_dt=NULL
 WHERE mat_cd IN ('MAT_000071','MAT_000075','MAT_000085','MAT_000094','MAT_000100','MAT_000103','MAT_000122','MAT_000143','MAT_000146')
   AND del_yn IS DISTINCT FROM 'N';

COMMIT;
