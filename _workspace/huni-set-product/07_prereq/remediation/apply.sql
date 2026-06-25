-- apply.sql — 자재 기초데이터 교정(셋트 가격 적재 선행)
-- 범위: 즉시 실행 = 자재 10행 del_yn 'Y'→'N' 부활 (재배선·논리삭제·mint 0)
--   P2-A: MAT_000246 전용지 부활 (권위 booklet "표지종이=전용지")
--   P3-A: 출력소재 종이 root 9개 부활 (활성 자식 41건 계층 복구)
-- 멱등[HARD]: WHERE del_yn != 'N' 가드 → 재실행 시 delta 0.
-- 비파괴[HARD]: 부활(UPDATE)만. 물리 DELETE 0·DDL 0·mint 0.
-- ★BEGIN/COMMIT 미내장 — 실행자가 트랜잭션으로 감싼다(인간 승인 후 dbm-load-execution).
-- 자재 트리거 trg_t_mat_materials_upd_dt(BEFORE UPDATE)가 upd_dt 자동 갱신.
-- CONFIRM 보류분(P1 재배선·P2 포토북·P3 비종이/NO_ROOT)은 포함하지 않음 — confirm-queue.csv 참조.

-- ── P2-A: 전용지 부활 (셋트 072·082 표지 FK_DEAD 해소) ──
UPDATE t_mat_materials
   SET del_yn = 'N', del_dt = NULL
 WHERE mat_cd = 'MAT_000246'
   AND del_yn IS DISTINCT FROM 'N';   -- 멱등 가드

-- ── P3-A: 출력소재 종이 root 9개 부활 (활성 자식 계층 복구) ──
UPDATE t_mat_materials
   SET del_yn = 'N', del_dt = NULL
 WHERE mat_cd IN (
        'MAT_000071',  -- 백모조 (자식3)
        'MAT_000075',  -- 아트 (자식8)
        'MAT_000085',  -- 스노우 (자식8)
        'MAT_000094',  -- 앙상블 (자식5)
        'MAT_000100',  -- 랑데뷰 (자식2)
        'MAT_000103',  -- 몽블랑 (자식9)
        'MAT_000122',  -- 띤또 (자식2)
        'MAT_000143',  -- 투명 (자식2)
        'MAT_000146'   -- 반투명 (자식2)
       )
   AND del_yn IS DISTINCT FROM 'N';   -- 멱등 가드

-- 검증(실행자 참고·트랜잭션 내 SELECT):
--   SELECT mat_cd, mat_nm, del_yn FROM t_mat_materials
--    WHERE mat_cd IN ('MAT_000246','MAT_000071','MAT_000075','MAT_000085','MAT_000094',
--                     'MAT_000100','MAT_000103','MAT_000122','MAT_000143','MAT_000146');
--   기대: 전 10행 del_yn='N'.
--   FK 고아 0 검증: SELECT count(*) FROM t_mat_materials c JOIN t_mat_materials p
--     ON c.upr_mat_cd=p.mat_cd WHERE c.del_yn='N' AND p.del_yn='Y';
--   기대: 64 → 23 감소(9 root의 자식 41건 정합). 잔여 23 = 비종이 root(P3-B·CONFIRM) 자식.
</content>
