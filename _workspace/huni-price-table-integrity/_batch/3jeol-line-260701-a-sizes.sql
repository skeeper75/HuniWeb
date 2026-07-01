-- =====================================================================
-- 3절 라인 3상품 — 완제품 사이즈 등록 + 자재 3절 교정 — 2026-07-01
-- ★DB 미적재 — DRY-RUN. COMMIT은 인간 승인 + webadmin 실화면 확인 후.
-- 멱등: NOT EXISTS / del_yn 가드. 물리 DELETE 없음(논리삭제).
-- =====================================================================

-- ---------------------------------------------------------------------
-- A. PRD_000049 완제품 사이즈 등록 (상품마스터 미완성분 보완)
--    권위: 판걸이수 시트 행74 "와이드 접지리플렛" 재단 640x297·작업 646x303.
--    ★search-before-mint 성공: SIZ_000055(cut 640x297 / work 646x303)가 이미 존재 → 신규 mint 불요.
--      (SIZ_000190 646x303은 work-only 판형용이라 완제품 사이즈로 부적합.)
-- ---------------------------------------------------------------------
BEGIN;
INSERT INTO t_prd_product_sizes (prd_cd,siz_cd,dflt_yn,disp_seq,reg_dt,del_yn)
SELECT 'PRD_000049','SIZ_000055','Y',1,now(),'N'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_sizes WHERE prd_cd='PRD_000049' AND siz_cd='SIZ_000055');
-- 검증: SELECT * FROM t_prd_product_sizes WHERE prd_cd='PRD_000049' AND del_yn='N';
ROLLBACK;
-- COMMIT;

-- ---------------------------------------------------------------------
-- B. 자재 3절 교정 (030/049) — 비-3절 코드를 3절 전용 코드로 정렬
--    근거: 이 상품은 3절 라인(출력=330x660). 권위 엑셀 용지가 "(3절)"로 명명됨.
--          112는 이미 3절 코드(093/111/112) 사용 → 030/049도 정렬(일관성 + COMP_PAPER 키 매칭).
--          COMP_PAPER는 [plt_siz_cd, mat_cd] 매칭 → product_materials 코드와 단가행 mat_cd 일치 필수.
--    방식: 비-3절 junction 논리삭제(del_yn='Y') + 3절 코드 신규(INSERT). 기초코드 자체는 불변.
--    ★CONFIRM: 고객 화면 자재목록이 "(3절)" 명으로 바뀜(의미 동일·시트만 3절). 사장님 확인 권장.
--    [대안] 교정 없이 단가행을 기존 비-3절 코드(105 등)에 SIZ_000475로 적재해도 매칭은 됨(가격 동일).
--           그러나 112와 불일치 → 본안은 3절 정렬을 권고.
--    매핑: 030 105→110 / 049 078→083·091→093·105→110·107→111·109→112
-- ---------------------------------------------------------------------
BEGIN;
-- 030 지그재그엽서: 몽블랑130 → 몽블랑130(3절)
UPDATE t_prd_product_materials SET del_yn='Y', del_dt=now()
 WHERE prd_cd='PRD_000030' AND mat_cd='MAT_000105' AND del_yn='N';
INSERT INTO t_prd_product_materials (prd_cd,mat_cd,usage_cd,dflt_yn,disp_seq,reg_dt,del_yn)
SELECT 'PRD_000030','MAT_000110','USAGE.07','Y',1,now(),'N'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_materials WHERE prd_cd='PRD_000030' AND mat_cd='MAT_000110' AND del_yn='N');

-- 049 와이드 접지리플렛: 아트150/스노우250/몽블랑130/190/240 → 각 3절 코드
UPDATE t_prd_product_materials SET del_yn='Y', del_dt=now()
 WHERE prd_cd='PRD_000049' AND mat_cd IN ('MAT_000078','MAT_000091','MAT_000105','MAT_000107','MAT_000109') AND del_yn='N';
INSERT INTO t_prd_product_materials (prd_cd,mat_cd,usage_cd,dflt_yn,disp_seq,reg_dt,del_yn)
SELECT 'PRD_000049', v.mat_cd, 'USAGE.07', v.dflt, v.seq::int, now(), 'N'
FROM (VALUES ('MAT_000083','Y','1'),('MAT_000093','N','2'),('MAT_000110','N','3'),('MAT_000111','N','4'),('MAT_000112','N','5')) AS v(mat_cd,dflt,seq)
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_materials x WHERE x.prd_cd='PRD_000049' AND x.mat_cd=v.mat_cd AND x.del_yn='N');

-- 112 와이드벽걸이캘린더: 이미 093/111/112(3절) → 교정 불요. 링블랙(MAT_000253)=부자재(하드웨어) 유지.

-- 검증: SELECT prd_cd,mat_cd,del_yn FROM t_prd_product_materials
--        WHERE prd_cd IN ('PRD_000030','PRD_000049') ORDER BY prd_cd,mat_cd;
ROLLBACK;
-- COMMIT;
