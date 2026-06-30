\set ON_ERROR_STOP on
BEGIN;
-- PRD_000025 투명포토카드: 라이브['SIZ_000120', 'SIZ_000522']→권위['SIZ_000522']
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000025' AND siz_cd='SIZ_000120' AND del_yn='N';
-- PRD_000039 투명명함: 라이브['SIZ_000144', 'SIZ_000522']→권위['SIZ_000522']
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000039' AND siz_cd='SIZ_000144' AND del_yn='N';
-- PRD_000052 반칼 자유형 스티커: 라이브['SIZ_000007', 'SIZ_000050', 'SIZ_000057', 'SIZ_000521']→권위['SIZ_000521']
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000052' AND siz_cd='SIZ_000007' AND del_yn='N';
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000052' AND siz_cd='SIZ_000050' AND del_yn='N';
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000052' AND siz_cd='SIZ_000057' AND del_yn='N';
-- PRD_000053 반칼 자유형 투명스티커: 라이브['SIZ_000007', 'SIZ_000050', 'SIZ_000057', 'SIZ_000521']→권위['SIZ_000521']
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000053' AND siz_cd='SIZ_000007' AND del_yn='N';
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000053' AND siz_cd='SIZ_000050' AND del_yn='N';
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000053' AND siz_cd='SIZ_000057' AND del_yn='N';
-- PRD_000054 반칼 자유형 홀로그램스티커: 라이브['SIZ_000007', 'SIZ_000050', 'SIZ_000057', 'SIZ_000521']→권위['SIZ_000521']
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000054' AND siz_cd='SIZ_000007' AND del_yn='N';
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000054' AND siz_cd='SIZ_000050' AND del_yn='N';
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000054' AND siz_cd='SIZ_000057' AND del_yn='N';
-- PRD_000058 반칼원형스티커: 라이브['SIZ_000007', 'SIZ_000050', 'SIZ_000521']→권위['SIZ_000521']
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000058' AND siz_cd='SIZ_000007' AND del_yn='N';
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000058' AND siz_cd='SIZ_000050' AND del_yn='N';
-- PRD_000059 반칼정사각스티커: 라이브['SIZ_000007', 'SIZ_000050', 'SIZ_000521']→권위['SIZ_000521']
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000059' AND siz_cd='SIZ_000007' AND del_yn='N';
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000059' AND siz_cd='SIZ_000050' AND del_yn='N';
-- PRD_000060 반칼직사각스티커: 라이브['SIZ_000007', 'SIZ_000050', 'SIZ_000521']→권위['SIZ_000521']
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000060' AND siz_cd='SIZ_000007' AND del_yn='N';
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000060' AND siz_cd='SIZ_000050' AND del_yn='N';
-- PRD_000061 반칼띠지스티커: 라이브['SIZ_000007', 'SIZ_000050', 'SIZ_000521']→권위['SIZ_000521']
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000061' AND siz_cd='SIZ_000007' AND del_yn='N';
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000061' AND siz_cd='SIZ_000050' AND del_yn='N';
-- PRD_000062 반칼팬시스티커: 라이브['SIZ_000200', 'SIZ_000201', 'SIZ_000202', 'SIZ_000521']→권위['SIZ_000521']
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000062' AND siz_cd='SIZ_000200' AND del_yn='N';
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000062' AND siz_cd='SIZ_000201' AND del_yn='N';
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000062' AND siz_cd='SIZ_000202' AND del_yn='N';
-- PRD_000063 반칼팬시투명스티커: 라이브['SIZ_000200', 'SIZ_000201', 'SIZ_000202', 'SIZ_000521']→권위['SIZ_000521']
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000063' AND siz_cd='SIZ_000200' AND del_yn='N';
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000063' AND siz_cd='SIZ_000201' AND del_yn='N';
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000063' AND siz_cd='SIZ_000202' AND del_yn='N';
-- PRD_000064 소량자유형스티커: 라이브['SIZ_000036', 'SIZ_000043', 'SIZ_000061', 'SIZ_000062', 'SIZ_000063', 'SIZ_000064', 'SIZ_000065', 'SIZ_000521']→권위['SIZ_000521']
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000064' AND siz_cd='SIZ_000036' AND del_yn='N';
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000064' AND siz_cd='SIZ_000043' AND del_yn='N';
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000064' AND siz_cd='SIZ_000061' AND del_yn='N';
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000064' AND siz_cd='SIZ_000062' AND del_yn='N';
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000064' AND siz_cd='SIZ_000063' AND del_yn='N';
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000064' AND siz_cd='SIZ_000064' AND del_yn='N';
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000064' AND siz_cd='SIZ_000065' AND del_yn='N';
-- PRD_000065 스티커팩: 라이브['SIZ_000068', 'SIZ_000521']→권위['SIZ_000521']
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000065' AND siz_cd='SIZ_000068' AND del_yn='N';
-- PRD_000030 지그재그엽서: 라이브['SIZ_000142', 'SIZ_000143']→권위['SIZ_000475']
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000030' AND siz_cd='SIZ_000142' AND del_yn='N';
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000030' AND siz_cd='SIZ_000143' AND del_yn='N';
INSERT INTO t_prd_product_plate_sizes(prd_cd,siz_cd,dflt_plt_yn,output_paper_typ_cd,reg_dt,del_yn) VALUES('PRD_000030','SIZ_000475','Y','OUTPUT_PAPER_TYPE.03',now(),'N') ON CONFLICT DO NOTHING;
-- PRD_000049 와이드 접지리플렛: 라이브['SIZ_000186', 'SIZ_000188', 'SIZ_000190']→권위['SIZ_000475']
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000049' AND siz_cd='SIZ_000186' AND del_yn='N';
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000049' AND siz_cd='SIZ_000188' AND del_yn='N';
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000049' AND siz_cd='SIZ_000190' AND del_yn='N';
INSERT INTO t_prd_product_plate_sizes(prd_cd,siz_cd,dflt_plt_yn,output_paper_typ_cd,reg_dt,del_yn) VALUES('PRD_000049','SIZ_000475','Y','OUTPUT_PAPER_TYPE.03',now(),'N') ON CONFLICT DO NOTHING;
-- PRD_000067 타투스티커: 라이브['SIZ_000060']→권위['SIZ_000050']
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000067' AND siz_cd='SIZ_000060' AND del_yn='N';
INSERT INTO t_prd_product_plate_sizes(prd_cd,siz_cd,dflt_plt_yn,output_paper_typ_cd,reg_dt,del_yn) VALUES('PRD_000067','SIZ_000050','Y','OUTPUT_PAPER_TYPE.03',now(),'N') ON CONFLICT DO NOTHING;
-- PRD_000112 와이드벽걸이캘린더: 라이브['SIZ_000292']→권위['SIZ_000475']
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000112' AND siz_cd='SIZ_000292' AND del_yn='N';
INSERT INTO t_prd_product_plate_sizes(prd_cd,siz_cd,dflt_plt_yn,output_paper_typ_cd,reg_dt,del_yn) VALUES('PRD_000112','SIZ_000475','Y','OUTPUT_PAPER_TYPE.03',now(),'N') ON CONFLICT DO NOTHING;
SELECT prd_cd, siz_cd, dflt_plt_yn, del_yn FROM t_prd_product_plate_sizes WHERE prd_cd IN ('PRD_000025','PRD_000039','PRD_000052','PRD_000053','PRD_000054','PRD_000058','PRD_000059','PRD_000060','PRD_000061','PRD_000062','PRD_000063','PRD_000064','PRD_000065','PRD_000030','PRD_000049','PRD_000067','PRD_000112') ORDER BY prd_cd, del_yn, siz_cd;
ROLLBACK;
