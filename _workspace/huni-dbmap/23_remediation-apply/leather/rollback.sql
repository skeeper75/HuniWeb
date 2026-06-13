-- 레더 교정 롤백(적용 전 원문 복원). 인간 실행용.
UPDATE t_mat_materials SET mat_typ_cd='MAT_TYPE.08' WHERE mat_cd='MAT_000186';
UPDATE t_mat_materials SET mat_typ_cd='MAT_TYPE.01' WHERE mat_cd='MAT_000006';
