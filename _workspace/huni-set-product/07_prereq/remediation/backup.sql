-- backup.sql — 교정 대상 10행 사전 백업(상태 스냅샷)
-- 실행 시점(인간 승인 후 COMMIT 직전)에 대상 행의 현재 del_yn/del_dt/upd_dt를 캡처.
-- 복원은 undo.sql 사용. 이 파일은 "교정 전 상태 증거" 기록용.
-- 읽기전용 SELECT — 라이브 변경 없음.

-- 백업 테이블(임시) 생성 — 실행자 스키마에 보관(예: public 또는 _backup 스키마)
-- DROP 후 재생성으로 멱등.
DROP TABLE IF EXISTS _bak_mat_materials_remediation_260624;
CREATE TABLE _bak_mat_materials_remediation_260624 AS
SELECT mat_cd, mat_nm, mat_typ_cd, upr_mat_cd, sel_typ_cd,
       use_yn, del_yn, del_dt, upd_dt, now() AS backup_dt
  FROM t_mat_materials
 WHERE mat_cd IN (
        'MAT_000246',  -- P2-A 전용지
        'MAT_000071','MAT_000075','MAT_000085','MAT_000094','MAT_000100',
        'MAT_000103','MAT_000122','MAT_000143','MAT_000146'  -- P3-A 종이 root 9
       );

-- 백업 확인:
SELECT mat_cd, mat_nm, del_yn, del_dt FROM _bak_mat_materials_remediation_260624 ORDER BY mat_cd;
-- 기대: 10행, 전부 del_yn='Y'(교정 전 상태).
</content>
