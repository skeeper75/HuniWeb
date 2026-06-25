-- zr1-backup.sql (zombie-wiring-92 _exec) — rev2 REVIVE 9건 물리 백업 (COMMIT 직전 실행)
-- 대상: disposition-rev2.csv 의 disposition_rev2='REVIVE' 9행 (t_mat_materials del_yn 'Y'->'N' 부활)
-- 부활 사유: 활성 option_items(ref_dim_cd='OPT_REF_DIM.03')가 이 자재를 ref_key1로 직접 참조 중인데
--            자재만 삭제됨 = 옵션 참조 무결성 깨짐 복구. (262는 정본부재·본질소재 사유)
-- 백업 = 교정 전 상태 스냅샷. 복원은 zr1-undo.sql. 멱등(DROP IF EXISTS 후 재생성).
-- 라이브 변경 없음(CREATE TABLE AS SELECT). 자격증명은 .env.local에서만.
-- 타임스탬프 = 20260625_055716

DROP TABLE IF EXISTS bak_t_mat_materials_zr1revive_20260625_055716;
CREATE TABLE bak_t_mat_materials_zr1revive_20260625_055716 AS
SELECT mat_cd, mat_nm, mat_typ_cd, upr_mat_cd,
       use_yn, del_yn, del_dt, upd_dt, now() AS backup_dt
  FROM t_mat_materials
 WHERE mat_cd IN (
        'MAT_000069',  -- 양면테입 (.07, opt ref OPV_000010)
        'MAT_000070',  -- 끈 (.07, opt ref OPV_000014/015/016)
        'MAT_000337',  -- 큐방 (.07, opt ref OPV_000013)
        'MAT_000338',  -- 각목 (.07, opt ref OPV_000015/016)
        'MAT_000340',  -- 봉제사 (.07, opt ref OPV_000011)
        'MAT_000244',  -- 투명커버 유광투명커버 (.02, opt ref)
        'MAT_000245',  -- 투명커버 무광투명커버 (.02, opt ref)
        'MAT_000154',  -- 유포지 (.11, opt ref)
        'MAT_000262'   -- 무광 75mm (.12, 정본부재·본질소재)
       );

-- 백업 행수 확인:
SELECT 'bak_zr1revive' AS tbl, count(*) AS rows FROM bak_t_mat_materials_zr1revive_20260625_055716;
-- 기대: 9행(전부 del_yn='Y').
