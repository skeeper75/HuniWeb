-- zr1-apply.sql (zombie-wiring-92 _exec) — rev2 REVIVE 9건 라이브 COMMIT 래핑본
-- t_mat_materials del_yn 'Y'->'N' 부활 9행. 비파괴: UPDATE만(물리 DELETE 0·DDL 0·mint 0).
-- 멱등[HARD]: WHERE del_yn IS DISTINCT FROM 'N' (2차 실행 시 0행).
-- 단일 트랜잭션(BEGIN…COMMIT) — 부분커밋 경로 없음. 트리거 trg_t_mat_materials_upd_dt가 upd_dt 갱신.
-- ★실행 전 zr1-backup.sql 선행 필수(undo 가역). 자격증명 .env.local.
-- 목록 권위 = disposition-rev2.csv disposition_rev2='REVIVE' 9행.

BEGIN;

UPDATE t_mat_materials SET del_yn='N', del_dt=NULL
 WHERE mat_cd IN (
        'MAT_000069','MAT_000070','MAT_000337','MAT_000338','MAT_000340',
        'MAT_000244','MAT_000245','MAT_000154','MAT_000262'
       )
   AND del_yn IS DISTINCT FROM 'N';

COMMIT;
