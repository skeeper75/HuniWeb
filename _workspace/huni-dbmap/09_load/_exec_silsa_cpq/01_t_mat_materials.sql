-- =====================================================================
-- step 01 — t_mat_materials (마스터 mint 4: 큐방·각목900이하·각목900초과·봉제사)
-- 멱등 가드 = mat_nm (이름기반 NOT EXISTS). 코드=라이브 MAX(MAT_000336)+1 리터럴 부여.
--   재실행: 이름 일치 행 존재 → INSERT 0행(코드 재발급 없음). PK=mat_cd.
-- MAT_TYPE.07=부속. use_yn='Y'. reg_dt 생략→DEFAULT now(). DDL 아님(master-data INSERT).
-- search-before-mint: 2026-06-09 live 0행 재확인(큐방/각목/봉제사 부재). 손편집 금지.
-- =====================================================================
INSERT INTO t_mat_materials (mat_cd, mat_nm, mat_typ_cd, use_yn, note)
SELECT 'MAT_000337', '큐방', 'MAT_TYPE.07', 'Y', 'silsa 큐방(4개)추가 옵션 자재. 금속 부속. search-before-mint 부재 재확인(2026-06-09 live 0행). MAT_TYPE.07 부속.'
WHERE NOT EXISTS (SELECT 1 FROM t_mat_materials WHERE mat_nm = '큐방' AND mat_typ_cd = 'MAT_TYPE.07' AND del_yn = 'N');
INSERT INTO t_mat_materials (mat_cd, mat_nm, mat_typ_cd, use_yn, note)
SELECT 'MAT_000338', '각목(900이하)', 'MAT_TYPE.07', 'Y', 'silsa 각목(900이하)+끈 옵션 자재. 사각단면 목재(우드봉 차용 배제·D③). 900이하 규격. 2규격 별 mat_cd 모델(D-2 적용결정).'
WHERE NOT EXISTS (SELECT 1 FROM t_mat_materials WHERE mat_nm = '각목(900이하)' AND mat_typ_cd = 'MAT_TYPE.07' AND del_yn = 'N');
INSERT INTO t_mat_materials (mat_cd, mat_nm, mat_typ_cd, use_yn, note)
SELECT 'MAT_000339', '각목(900초과)', 'MAT_TYPE.07', 'Y', 'silsa 각목(900초과)+끈 옵션 자재. 사각단면 목재. 900초과 규격. 2규격 별 mat_cd 모델(D-2 적용결정).'
WHERE NOT EXISTS (SELECT 1 FROM t_mat_materials WHERE mat_nm = '각목(900초과)' AND mat_typ_cd = 'MAT_TYPE.07' AND del_yn = 'N');
INSERT INTO t_mat_materials (mat_cd, mat_nm, mat_typ_cd, use_yn, note)
SELECT 'MAT_000340', '봉제사', 'MAT_TYPE.07', 'Y', 'silsa 봉미싱 옵션 자재. 봉제용 실(D② 실=자재 확정·소모성 미등록 후보 철회). search-before-mint 부재 재확인(2026-06-09 live 0행). MAT_TYPE.07 부속.'
WHERE NOT EXISTS (SELECT 1 FROM t_mat_materials WHERE mat_nm = '봉제사' AND mat_typ_cd = 'MAT_TYPE.07' AND del_yn = 'N');
