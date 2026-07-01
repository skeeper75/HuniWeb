-- 030/049 자재 3절 정렬 -- 2026-07-01
-- 근본원인: webadmin 실화면 검증에서 두 상품 모두 "계산 불가(구성요소 0)" -- t_prd_product_materials가
-- 여전히 국4절 비-3절 자재코드(105/078/091/107/109)를 참조 중이라, 이번에 적재한 3절 단가행
-- (mat_cd=083/093/110/111/112, plt_siz_cd=SIZ_000475)과 매칭이 안 돼 COMP_PAPER 컴포넌트가 전혀 해소되지 않음.
-- 교정: 기존 국4절 자재링크 논리삭제 + 정확히 대응하는 3절 자재코드로 신규 링크(코드 삭제 금지·del_yn 논리삭제만).
-- 매핑(mat_nm 대조로 확정): 105 몽블랑130g→110(3절) · 078 아트150g→083(3절) · 091 스노우250g→093(3절)
--                          · 107 몽블랑190g→111(3절) · 109 몽블랑240g→112(3절)
BEGIN;

-- 1) 기존 국4절 자재링크 논리삭제
UPDATE t_prd_product_materials SET del_yn='Y', del_dt=now()
 WHERE prd_cd='PRD_000030' AND mat_cd='MAT_000105' AND del_yn='N';
UPDATE t_prd_product_materials SET del_yn='Y', del_dt=now()
 WHERE prd_cd='PRD_000049' AND mat_cd IN ('MAT_000078','MAT_000091','MAT_000105','MAT_000107','MAT_000109') AND del_yn='N';

-- 2) 3절 자재로 신규 링크(원본 usage_cd/dflt_yn/disp_seq carry)
INSERT INTO t_prd_product_materials (prd_cd,mat_cd,usage_cd,dflt_yn,disp_seq,reg_dt,del_yn)
SELECT prd_cd,'MAT_000110',usage_cd,dflt_yn,disp_seq,now(),'N'
  FROM t_prd_product_materials WHERE prd_cd='PRD_000030' AND mat_cd='MAT_000105'
  AND NOT EXISTS (SELECT 1 FROM t_prd_product_materials WHERE prd_cd='PRD_000030' AND mat_cd='MAT_000110' AND del_yn='N');

INSERT INTO t_prd_product_materials (prd_cd,mat_cd,usage_cd,dflt_yn,disp_seq,reg_dt,del_yn)
SELECT prd_cd,
       CASE mat_cd
         WHEN 'MAT_000078' THEN 'MAT_000083'
         WHEN 'MAT_000091' THEN 'MAT_000093'
         WHEN 'MAT_000105' THEN 'MAT_000110'
         WHEN 'MAT_000107' THEN 'MAT_000111'
         WHEN 'MAT_000109' THEN 'MAT_000112'
       END AS new_mat_cd,
       usage_cd,dflt_yn,disp_seq,now(),'N'
  FROM t_prd_product_materials
 WHERE prd_cd='PRD_000049' AND mat_cd IN ('MAT_000078','MAT_000091','MAT_000105','MAT_000107','MAT_000109')
   AND NOT EXISTS (
     SELECT 1 FROM t_prd_product_materials y
      WHERE y.prd_cd='PRD_000049' AND y.del_yn='N' AND y.mat_cd = CASE t_prd_product_materials.mat_cd
         WHEN 'MAT_000078' THEN 'MAT_000083'
         WHEN 'MAT_000091' THEN 'MAT_000093'
         WHEN 'MAT_000105' THEN 'MAT_000110'
         WHEN 'MAT_000107' THEN 'MAT_000111'
         WHEN 'MAT_000109' THEN 'MAT_000112'
       END
   );
COMMIT;
