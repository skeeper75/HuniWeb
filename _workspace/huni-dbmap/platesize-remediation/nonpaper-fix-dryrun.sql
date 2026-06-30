\set ON_ERROR_STOP on
SET client_min_messages=warning;
BEGIN;
-- PRD_000088 레더 링바인더: 판형 SIZ_000259(611x374) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000088' AND siz_cd='SIZ_000259' AND del_yn='N';
-- PRD_000088 레더 링바인더: 판형 SIZ_000260(622x374) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000088' AND siz_cd='SIZ_000260' AND del_yn='N';
-- PRD_000088 레더 링바인더: 판형 SIZ_000261(636x374) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000088' AND siz_cd='SIZ_000261' AND del_yn='N';
-- PRD_000120 방수포스터: 판형 SIZ_000052(A3 (297X420)) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000120' AND siz_cd='SIZ_000052' AND del_yn='N';
-- PRD_000120 방수포스터: 판형 SIZ_000198(A2 (420X594)) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000120' AND siz_cd='SIZ_000198' AND del_yn='N';
-- PRD_000120 방수포스터: 판형 SIZ_000294(A1 (594X841)) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000120' AND siz_cd='SIZ_000294' AND del_yn='N';
-- PRD_000121 접착방수포스터: 판형 SIZ_000052(A3 (297X420)) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000121' AND siz_cd='SIZ_000052' AND del_yn='N';
-- PRD_000121 접착방수포스터: 판형 SIZ_000198(A2 (420X594)) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000121' AND siz_cd='SIZ_000198' AND del_yn='N';
-- PRD_000121 접착방수포스터: 판형 SIZ_000294(A1 (594X841)) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000121' AND siz_cd='SIZ_000294' AND del_yn='N';
-- PRD_000122 접착투명포스터: 판형 SIZ_000052(A3 (297X420)) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000122' AND siz_cd='SIZ_000052' AND del_yn='N';
-- PRD_000122 접착투명포스터: 판형 SIZ_000198(A2 (420X594)) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000122' AND siz_cd='SIZ_000198' AND del_yn='N';
-- PRD_000122 접착투명포스터: 판형 SIZ_000294(A1 (594X841)) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000122' AND siz_cd='SIZ_000294' AND del_yn='N';
-- PRD_000123 아트패브릭포스터: 판형 SIZ_000052(A3 (297X420)) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000123' AND siz_cd='SIZ_000052' AND del_yn='N';
-- PRD_000123 아트패브릭포스터: 판형 SIZ_000198(A2 (420X594)) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000123' AND siz_cd='SIZ_000198' AND del_yn='N';
-- PRD_000123 아트패브릭포스터: 판형 SIZ_000294(A1 (594X841)) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000123' AND siz_cd='SIZ_000294' AND del_yn='N';
-- PRD_000124 린넨패브릭포스터: 판형 SIZ_000054(420x297) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000124' AND siz_cd='SIZ_000054' AND del_yn='N';
-- PRD_000124 린넨패브릭포스터: 판형 SIZ_000198(A2 (420X594)) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000124' AND siz_cd='SIZ_000198' AND del_yn='N';
-- PRD_000124 린넨패브릭포스터: 판형 SIZ_000299(594x420) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000124' AND siz_cd='SIZ_000299' AND del_yn='N';
-- PRD_000124 린넨패브릭포스터: 판형 SIZ_000294(A1 (594X841)) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000124' AND siz_cd='SIZ_000294' AND del_yn='N';
-- PRD_000124 린넨패브릭포스터: 판형 SIZ_000302(841x594) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000124' AND siz_cd='SIZ_000302' AND del_yn='N';
-- PRD_000125 캔버스패브릭포스터: 판형 SIZ_000052(A3 (297X420)) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000125' AND siz_cd='SIZ_000052' AND del_yn='N';
-- PRD_000125 캔버스패브릭포스터: 판형 SIZ_000198(A2 (420X594)) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000125' AND siz_cd='SIZ_000198' AND del_yn='N';
-- PRD_000125 캔버스패브릭포스터: 판형 SIZ_000294(A1 (594X841)) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000125' AND siz_cd='SIZ_000294' AND del_yn='N';
-- PRD_000126 레더아트프린트: 판형 SIZ_000052(A3 (297X420)) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000126' AND siz_cd='SIZ_000052' AND del_yn='N';
-- PRD_000126 레더아트프린트: 판형 SIZ_000198(A2 (420X594)) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000126' AND siz_cd='SIZ_000198' AND del_yn='N';
-- PRD_000126 레더아트프린트: 판형 SIZ_000294(A1 (594X841)) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000126' AND siz_cd='SIZ_000294' AND del_yn='N';
-- PRD_000127 타이벡프린트: 판형 SIZ_000052(A3 (297X420)) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000127' AND siz_cd='SIZ_000052' AND del_yn='N';
-- PRD_000127 타이벡프린트: 판형 SIZ_000198(A2 (420X594)) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000127' AND siz_cd='SIZ_000198' AND del_yn='N';
-- PRD_000127 타이벡프린트: 판형 SIZ_000294(A1 (594X841)) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000127' AND siz_cd='SIZ_000294' AND del_yn='N';
-- PRD_000128 메쉬프린트: 판형 SIZ_000052(A3 (297X420)) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000128' AND siz_cd='SIZ_000052' AND del_yn='N';
-- PRD_000128 메쉬프린트: 판형 SIZ_000198(A2 (420X594)) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000128' AND siz_cd='SIZ_000198' AND del_yn='N';
-- PRD_000128 메쉬프린트: 판형 SIZ_000294(A1 (594X841)) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000128' AND siz_cd='SIZ_000294' AND del_yn='N';
-- PRD_000129 폼보드: 판형 SIZ_000052(A3 (297X420)) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000129' AND siz_cd='SIZ_000052' AND del_yn='N';
-- PRD_000129 폼보드: 판형 SIZ_000198(A2 (420X594)) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000129' AND siz_cd='SIZ_000198' AND del_yn='N';
-- PRD_000130 포맥스보드: 판형 SIZ_000175(303x426) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000130' AND siz_cd='SIZ_000175' AND del_yn='N';
-- PRD_000130 포맥스보드: 판형 SIZ_000303(426x600) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000130' AND siz_cd='SIZ_000303' AND del_yn='N';
-- PRD_000131 프레임리스우드액자: 판형 SIZ_000175(303x426) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000131' AND siz_cd='SIZ_000175' AND del_yn='N';
-- PRD_000131 프레임리스우드액자: 판형 SIZ_000303(426x600) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000131' AND siz_cd='SIZ_000303' AND del_yn='N';
-- PRD_000132 레더아트액자: 판형 SIZ_000305(207x207) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000132' AND siz_cd='SIZ_000305' AND del_yn='N';
-- PRD_000132 레더아트액자: 판형 SIZ_000307(207x258) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000132' AND siz_cd='SIZ_000307' AND del_yn='N';
-- PRD_000132 레더아트액자: 판형 SIZ_000309(283x283) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000132' AND siz_cd='SIZ_000309' AND del_yn='N';
-- PRD_000132 레더아트액자: 판형 SIZ_000311(283x334) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000132' AND siz_cd='SIZ_000311' AND del_yn='N';
-- PRD_000132 레더아트액자: 판형 SIZ_000312(290x377) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000132' AND siz_cd='SIZ_000312' AND del_yn='N';
-- PRD_000132 레더아트액자: 판형 SIZ_000313(377x500) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000132' AND siz_cd='SIZ_000313' AND del_yn='N';
-- PRD_000133 캔버스 행잉포스터: 판형 SIZ_000050(A4 (210X297)) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000133' AND siz_cd='SIZ_000050' AND del_yn='N';
-- PRD_000133 캔버스 행잉포스터: 판형 SIZ_000052(A3 (297X420)) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000133' AND siz_cd='SIZ_000052' AND del_yn='N';
-- PRD_000133 캔버스 행잉포스터: 판형 SIZ_000198(A2 (420X594)) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000133' AND siz_cd='SIZ_000198' AND del_yn='N';
-- PRD_000134 린넨 우드봉 족자: 판형 SIZ_000314(210x347) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000134' AND siz_cd='SIZ_000314' AND del_yn='N';
-- PRD_000134 린넨 우드봉 족자: 판형 SIZ_000316(297x470) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000134' AND siz_cd='SIZ_000316' AND del_yn='N';
-- PRD_000134 린넨 우드봉 족자: 판형 SIZ_000318(420x644) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000134' AND siz_cd='SIZ_000318' AND del_yn='N';
-- PRD_000135 족자포스터: 판형 SIZ_000052(A3 (297X420)) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000135' AND siz_cd='SIZ_000052' AND del_yn='N';
-- PRD_000135 족자포스터: 판형 SIZ_000198(A2 (420X594)) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000135' AND siz_cd='SIZ_000198' AND del_yn='N';
-- PRD_000135 족자포스터: 판형 SIZ_000294(A1 (594X841)) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000135' AND siz_cd='SIZ_000294' AND del_yn='N';
-- PRD_000135 족자포스터: 판형 SIZ_000319(300x600) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000135' AND siz_cd='SIZ_000319' AND del_yn='N';
-- PRD_000135 족자포스터: 판형 SIZ_000320(900x1200) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000135' AND siz_cd='SIZ_000320' AND del_yn='N';
-- PRD_000136 PET배너: 판형 SIZ_000321(600x1800) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000136' AND siz_cd='SIZ_000321' AND del_yn='N';
-- PRD_000137 메쉬배너: 판형 SIZ_000321(600x1800) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000137' AND siz_cd='SIZ_000321' AND del_yn='N';
-- PRD_000138 일반현수막: 판형 SIZ_000322(5000x900) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000138' AND siz_cd='SIZ_000322' AND del_yn='N';
-- PRD_000139 메쉬현수막: 판형 SIZ_000323(900x900) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000139' AND siz_cd='SIZ_000323' AND del_yn='N';
-- PRD_000139 메쉬현수막: 판형 SIZ_000320(900x1200) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000139' AND siz_cd='SIZ_000320' AND del_yn='N';
-- PRD_000139 메쉬현수막: 판형 SIZ_000322(5000x900) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000139' AND siz_cd='SIZ_000322' AND del_yn='N';
-- PRD_000140 무광시트커팅: 판형 SIZ_000050(A4 (210X297)) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000140' AND siz_cd='SIZ_000050' AND del_yn='N';
-- PRD_000140 무광시트커팅: 판형 SIZ_000052(A3 (297X420)) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000140' AND siz_cd='SIZ_000052' AND del_yn='N';
-- PRD_000140 무광시트커팅: 판형 SIZ_000198(A2 (420X594)) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000140' AND siz_cd='SIZ_000198' AND del_yn='N';
-- PRD_000141 홀로그램 시트커팅: 판형 SIZ_000050(A4 (210X297)) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000141' AND siz_cd='SIZ_000050' AND del_yn='N';
-- PRD_000141 홀로그램 시트커팅: 판형 SIZ_000052(A3 (297X420)) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000141' AND siz_cd='SIZ_000052' AND del_yn='N';
-- PRD_000141 홀로그램 시트커팅: 판형 SIZ_000198(A2 (420X594)) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000141' AND siz_cd='SIZ_000198' AND del_yn='N';
-- PRD_000142 유광아크릴스티커: 판형 SIZ_000324(290x90) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000142' AND siz_cd='SIZ_000324' AND del_yn='N';
-- PRD_000142 유광아크릴스티커: 판형 SIZ_000325(290x190) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000142' AND siz_cd='SIZ_000325' AND del_yn='N';
-- PRD_000142 유광아크릴스티커: 판형 SIZ_000326(390x290) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000142' AND siz_cd='SIZ_000326' AND del_yn='N';
-- PRD_000142 유광아크릴스티커: 판형 SIZ_000327(590x390) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000142' AND siz_cd='SIZ_000327' AND del_yn='N';
-- PRD_000143 미러아크릴스티커: 판형 SIZ_000324(290x90) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000143' AND siz_cd='SIZ_000324' AND del_yn='N';
-- PRD_000143 미러아크릴스티커: 판형 SIZ_000325(290x190) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000143' AND siz_cd='SIZ_000325' AND del_yn='N';
-- PRD_000143 미러아크릴스티커: 판형 SIZ_000326(390x290) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000143' AND siz_cd='SIZ_000326' AND del_yn='N';
-- PRD_000143 미러아크릴스티커: 판형 SIZ_000327(590x390) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000143' AND siz_cd='SIZ_000327' AND del_yn='N';
-- PRD_000144 미니보드스탠딩: 판형 SIZ_000007(148x210) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000144' AND siz_cd='SIZ_000007' AND del_yn='N';
-- PRD_000144 미니보드스탠딩: 판형 SIZ_000050(A4 (210X297)) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000144' AND siz_cd='SIZ_000050' AND del_yn='N';
-- PRD_000144 미니보드스탠딩: 판형 SIZ_000052(A3 (297X420)) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000144' AND siz_cd='SIZ_000052' AND del_yn='N';
-- PRD_000145 미니배너: 판형 SIZ_000028(150x300) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000145' AND siz_cd='SIZ_000028' AND del_yn='N';
-- PRD_000145 미니배너: 판형 SIZ_000328(180x420) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000145' AND siz_cd='SIZ_000328' AND del_yn='N';
-- PRD_000146 아크릴키링: 판형 SIZ_000329(20x30) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000146' AND siz_cd='SIZ_000329' AND del_yn='N';
-- PRD_000146 아크릴키링: 판형 SIZ_000330(30x30) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000146' AND siz_cd='SIZ_000330' AND del_yn='N';
-- PRD_000146 아크릴키링: 판형 SIZ_000331(30x40) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000146' AND siz_cd='SIZ_000331' AND del_yn='N';
-- PRD_000146 아크릴키링: 판형 SIZ_000332(30x70) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000146' AND siz_cd='SIZ_000332' AND del_yn='N';
-- PRD_000146 아크릴키링: 판형 SIZ_000333(40x40) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000146' AND siz_cd='SIZ_000333' AND del_yn='N';
-- PRD_000146 아크릴키링: 판형 SIZ_000334(40x50) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000146' AND siz_cd='SIZ_000334' AND del_yn='N';
-- PRD_000146 아크릴키링: 판형 SIZ_000335(40x60) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000146' AND siz_cd='SIZ_000335' AND del_yn='N';
-- PRD_000146 아크릴키링: 판형 SIZ_000011(50x50) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000146' AND siz_cd='SIZ_000011' AND del_yn='N';
-- PRD_000147 아크릴마그넷: 판형 SIZ_000337(24x24) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000147' AND siz_cd='SIZ_000337' AND del_yn='N';
-- PRD_000147 아크릴마그넷: 판형 SIZ_000338(34x34) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000147' AND siz_cd='SIZ_000338' AND del_yn='N';
-- PRD_000147 아크릴마그넷: 판형 SIZ_000339(34x44) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000147' AND siz_cd='SIZ_000339' AND del_yn='N';
-- PRD_000147 아크릴마그넷: 판형 SIZ_000340(44x44) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000147' AND siz_cd='SIZ_000340' AND del_yn='N';
-- PRD_000147 아크릴마그넷: 판형 SIZ_000341(44x54) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000147' AND siz_cd='SIZ_000341' AND del_yn='N';
-- PRD_000147 아크릴마그넷: 판형 SIZ_000342(54x54) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000147' AND siz_cd='SIZ_000342' AND del_yn='N';
-- PRD_000147 아크릴마그넷: 판형 SIZ_000343(64x64) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000147' AND siz_cd='SIZ_000343' AND del_yn='N';
-- PRD_000148 아크릴뱃지: 판형 SIZ_000338(34x34) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000148' AND siz_cd='SIZ_000338' AND del_yn='N';
-- PRD_000148 아크릴뱃지: 판형 SIZ_000340(44x44) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000148' AND siz_cd='SIZ_000340' AND del_yn='N';
-- PRD_000148 아크릴뱃지: 판형 SIZ_000342(54x54) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000148' AND siz_cd='SIZ_000342' AND del_yn='N';
-- PRD_000149 아크릴집게: 판형 SIZ_000338(34x34) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000149' AND siz_cd='SIZ_000338' AND del_yn='N';
-- PRD_000149 아크릴집게: 판형 SIZ_000340(44x44) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000149' AND siz_cd='SIZ_000340' AND del_yn='N';
-- PRD_000149 아크릴집게: 판형 SIZ_000342(54x54) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000149' AND siz_cd='SIZ_000342' AND del_yn='N';
-- PRD_000150 아크릴스마트톡: 판형 SIZ_000342(54x54) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000150' AND siz_cd='SIZ_000342' AND del_yn='N';
-- PRD_000150 아크릴스마트톡: 판형 SIZ_000343(64x64) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000150' AND siz_cd='SIZ_000343' AND del_yn='N';
-- PRD_000150 아크릴스마트톡: 판형 SIZ_000345(74x64) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000150' AND siz_cd='SIZ_000345' AND del_yn='N';
-- PRD_000151 맥세이프 스마트톡: 판형 SIZ_000342(54x54) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000151' AND siz_cd='SIZ_000342' AND del_yn='N';
-- PRD_000151 맥세이프 스마트톡: 판형 SIZ_000343(64x64) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000151' AND siz_cd='SIZ_000343' AND del_yn='N';
-- PRD_000151 맥세이프 스마트톡: 판형 SIZ_000345(74x64) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000151' AND siz_cd='SIZ_000345' AND del_yn='N';
-- PRD_000152 아크릴명찰: 판형 SIZ_000347(64x24) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000152' AND siz_cd='SIZ_000347' AND del_yn='N';
-- PRD_000152 아크릴명찰: 판형 SIZ_000349(74x29) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000152' AND siz_cd='SIZ_000349' AND del_yn='N';
-- PRD_000152 아크릴명찰: 판형 SIZ_000351(84x34) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000152' AND siz_cd='SIZ_000351' AND del_yn='N';
-- PRD_000153 아크릴명찰(골드실버): 판형 SIZ_000347(64x24) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000153' AND siz_cd='SIZ_000347' AND del_yn='N';
-- PRD_000153 아크릴명찰(골드실버): 판형 SIZ_000349(74x29) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000153' AND siz_cd='SIZ_000349' AND del_yn='N';
-- PRD_000153 아크릴명찰(골드실버): 판형 SIZ_000351(84x34) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000153' AND siz_cd='SIZ_000351' AND del_yn='N';
-- PRD_000154 아크릴 머리끈: 판형 SIZ_000337(24x24) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000154' AND siz_cd='SIZ_000337' AND del_yn='N';
-- PRD_000154 아크릴 머리끈: 판형 SIZ_000338(34x34) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000154' AND siz_cd='SIZ_000338' AND del_yn='N';
-- PRD_000154 아크릴 머리끈: 판형 SIZ_000340(44x44) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000154' AND siz_cd='SIZ_000340' AND del_yn='N';
-- PRD_000155 아크릴볼펜: 판형 SIZ_000337(24x24) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000155' AND siz_cd='SIZ_000337' AND del_yn='N';
-- PRD_000155 아크릴볼펜: 판형 SIZ_000338(34x34) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000155' AND siz_cd='SIZ_000338' AND del_yn='N';
-- PRD_000155 아크릴볼펜: 판형 SIZ_000340(44x44) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000155' AND siz_cd='SIZ_000340' AND del_yn='N';
-- PRD_000157 아크릴네임택: 판형 SIZ_000148(60x60) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000157' AND siz_cd='SIZ_000148' AND del_yn='N';
-- PRD_000157 아크릴네임택: 판형 SIZ_000012(55x86) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000157' AND siz_cd='SIZ_000012' AND del_yn='N';
-- PRD_000158 아크릴 포카키링: 판형 SIZ_000012(55x86) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000158' AND siz_cd='SIZ_000012' AND del_yn='N';
-- PRD_000159 아크릴 코스터: 판형 SIZ_000157(104x104) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000159' AND siz_cd='SIZ_000157' AND del_yn='N';
-- PRD_000160 아크릴자유형스탠드: 판형 SIZ_000357(120x60) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000160' AND siz_cd='SIZ_000357' AND del_yn='N';
-- PRD_000160 아크릴자유형스탠드: 판형 SIZ_000358(120x90) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000160' AND siz_cd='SIZ_000358' AND del_yn='N';
-- PRD_000160 아크릴자유형스탠드: 판형 SIZ_000359(120x120) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000160' AND siz_cd='SIZ_000359' AND del_yn='N';
-- PRD_000160 아크릴자유형스탠드: 판형 SIZ_000360(120x150) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000160' AND siz_cd='SIZ_000360' AND del_yn='N';
-- PRD_000160 아크릴자유형스탠드: 판형 SIZ_000361(120x180) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000160' AND siz_cd='SIZ_000361' AND del_yn='N';
-- PRD_000161 판아크릴: 판형 SIZ_000362(124x124) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000161' AND siz_cd='SIZ_000362' AND del_yn='N';
-- PRD_000161 판아크릴: 판형 SIZ_000363(124x184) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000161' AND siz_cd='SIZ_000363' AND del_yn='N';
-- PRD_000163 아크릴미니파츠: 판형 SIZ_000365(120x50) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000163' AND siz_cd='SIZ_000365' AND del_yn='N';
-- PRD_000183 틴거울: 판형 SIZ_000017(100x90) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000183' AND siz_cd='SIZ_000017' AND del_yn='N';
-- PRD_000184 컴팩트거울: 판형 SIZ_000017(100x90) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000184' AND siz_cd='SIZ_000017' AND del_yn='N';
-- PRD_000185 카드거울: 판형 SIZ_000383(57x91) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000185' AND siz_cd='SIZ_000383' AND del_yn='N';
-- PRD_000186 사각손거울: 판형 SIZ_000385(85x140) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000186' AND siz_cd='SIZ_000385' AND del_yn='N';
-- PRD_000186 사각손거울: 판형 SIZ_000387(105x176) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000186' AND siz_cd='SIZ_000387' AND del_yn='N';
-- PRD_000186 사각손거울: 판형 SIZ_000389(130x228) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000186' AND siz_cd='SIZ_000389' AND del_yn='N';
-- PRD_000187 블랙사각손거울: 판형 SIZ_000385(85x140) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000187' AND siz_cd='SIZ_000385' AND del_yn='N';
-- PRD_000187 블랙사각손거울: 판형 SIZ_000387(105x176) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000187' AND siz_cd='SIZ_000387' AND del_yn='N';
-- PRD_000187 블랙사각손거울: 판형 SIZ_000389(130x228) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000187' AND siz_cd='SIZ_000389' AND del_yn='N';
-- PRD_000188 레더코스터: 판형 SIZ_000113(100x100) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000188' AND siz_cd='SIZ_000113' AND del_yn='N';
-- PRD_000189 코르크코스터: 판형 SIZ_000113(100x100) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000189' AND siz_cd='SIZ_000113' AND del_yn='N';
-- PRD_000190 우드코스터: 판형 SIZ_000113(100x100) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000190' AND siz_cd='SIZ_000113' AND del_yn='N';
-- PRD_000191 린넨패브릭코스터: 판형 SIZ_000004(135x135) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000191' AND siz_cd='SIZ_000004' AND del_yn='N';
-- PRD_000192 규조토코스터: 판형 SIZ_000390(112x112) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000192' AND siz_cd='SIZ_000390' AND del_yn='N';
-- PRD_000192 규조토코스터: 판형 SIZ_000391(110x110) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000192' AND siz_cd='SIZ_000391' AND del_yn='N';
-- PRD_000194 워터북보틀: 판형 SIZ_000393(94x193) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000194' AND siz_cd='SIZ_000393' AND del_yn='N';
-- PRD_000194 워터북보틀: 판형 SIZ_000394(110x185) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000194' AND siz_cd='SIZ_000394' AND del_yn='N';
-- PRD_000195 벨벳쿠션: 판형 SIZ_000395(290x290) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000195' AND siz_cd='SIZ_000395' AND del_yn='N';
-- PRD_000196 레더여권케이스: 판형 SIZ_000257(210x150) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000196' AND siz_cd='SIZ_000257' AND del_yn='N';
-- PRD_000197 미니매트: 판형 SIZ_000397(450x450) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000197' AND siz_cd='SIZ_000397' AND del_yn='N';
-- PRD_000197 미니매트: 판형 SIZ_000398(280x200) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000197' AND siz_cd='SIZ_000398' AND del_yn='N';
-- PRD_000198 피크닉매트: 판형 SIZ_000400(1000x700) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000198' AND siz_cd='SIZ_000400' AND del_yn='N';
-- PRD_000198 피크닉매트: 판형 SIZ_000401(320x860) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000198' AND siz_cd='SIZ_000401' AND del_yn='N';
-- PRD_000198 피크닉매트: 판형 SIZ_000403(1500x1000) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000198' AND siz_cd='SIZ_000403' AND del_yn='N';
-- PRD_000200 핀버튼: 판형 SIZ_000043(80x80) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000200' AND siz_cd='SIZ_000043' AND del_yn='N';
-- PRD_000201 레더스트랩키링: 판형 SIZ_000404(30x124) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000201' AND siz_cd='SIZ_000404' AND del_yn='N';
-- PRD_000201 레더스트랩키링: 판형 SIZ_000405(30x215) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000201' AND siz_cd='SIZ_000405' AND del_yn='N';
-- PRD_000205 양말: 판형 SIZ_000407(65x100) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000205' AND siz_cd='SIZ_000407' AND del_yn='N';
-- PRD_000206 반팔티셔츠: 판형 SIZ_000408(205x292) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000206' AND siz_cd='SIZ_000408' AND del_yn='N';
-- PRD_000209 후드티셔츠: 판형 SIZ_000408(205x292) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000209' AND siz_cd='SIZ_000408' AND del_yn='N';
-- PRD_000210 초슬림마우스패드: 판형 SIZ_000409(240x182) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000210' AND siz_cd='SIZ_000409' AND del_yn='N';
-- PRD_000211 장패드: 판형 SIZ_000410(715x315) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000211' AND siz_cd='SIZ_000410' AND del_yn='N';
-- PRD_000212 극세사클리너: 판형 SIZ_000411(160x153) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000212' AND siz_cd='SIZ_000411' AND del_yn='N';
-- PRD_000213 틴케이스: 판형 SIZ_000412(81x105) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000213' AND siz_cd='SIZ_000412' AND del_yn='N';
-- PRD_000214 자석북마크: 판형 SIZ_000017(100x90) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000214' AND siz_cd='SIZ_000017' AND del_yn='N';
-- PRD_000215 클립보드: 판형 SIZ_000414(416x274) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000215' AND siz_cd='SIZ_000414' AND del_yn='N';
-- PRD_000215 클립보드: 판형 SIZ_000416(528x364) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000215' AND siz_cd='SIZ_000416' AND del_yn='N';
-- PRD_000216 투명클립보드: 판형 SIZ_000417(160x230) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000216' AND siz_cd='SIZ_000417' AND del_yn='N';
-- PRD_000216 투명클립보드: 판형 SIZ_000418(230x330) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000216' AND siz_cd='SIZ_000418' AND del_yn='N';
-- PRD_000219 밴드톡: 판형 SIZ_000427(45x102) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000219' AND siz_cd='SIZ_000427' AND del_yn='N';
-- PRD_000220 폰스트랩: 판형 SIZ_000428(17x320) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000220' AND siz_cd='SIZ_000428' AND del_yn='N';
-- PRD_000221 말랑키링: 판형 SIZ_000429(56x166) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000221' AND siz_cd='SIZ_000429' AND del_yn='N';
-- PRD_000223 말랑포카홀더: 판형 SIZ_000430(82x128) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000223' AND siz_cd='SIZ_000430' AND del_yn='N';
-- PRD_000224 말랑네임택: 판형 SIZ_000431(74x119) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000224' AND siz_cd='SIZ_000431' AND del_yn='N';
-- PRD_000225 말랑여권케이스: 판형 SIZ_000432(196x140) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000225' AND siz_cd='SIZ_000432' AND del_yn='N';
-- PRD_000230 레더 플랫 파우치: 판형 SIZ_000433(220x300) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000230' AND siz_cd='SIZ_000433' AND del_yn='N';
-- PRD_000230 레더 플랫 파우치: 판형 SIZ_000434(260x340) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000230' AND siz_cd='SIZ_000434' AND del_yn='N';
-- PRD_000231 레더 슬림 파우치: 판형 SIZ_000435(220x294) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000231' AND siz_cd='SIZ_000435' AND del_yn='N';
-- PRD_000231 레더 슬림 파우치: 판형 SIZ_000436(260x374) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000231' AND siz_cd='SIZ_000436' AND del_yn='N';
-- PRD_000232 레더 삼각 파우치: 판형 SIZ_000437(440x160) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000232' AND siz_cd='SIZ_000437' AND del_yn='N';
-- PRD_000232 레더 삼각 파우치: 판형 SIZ_000438(520x200) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000232' AND siz_cd='SIZ_000438' AND del_yn='N';
-- PRD_000233 레더 볼륨 파우치: 판형 SIZ_000439(240x334) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000233' AND siz_cd='SIZ_000439' AND del_yn='N';
-- PRD_000233 레더 볼륨 파우치: 판형 SIZ_000440(290x334) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000233' AND siz_cd='SIZ_000440' AND del_yn='N';
-- PRD_000234 레더 스트링 파우치: 판형 SIZ_000433(220x300) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000234' AND siz_cd='SIZ_000433' AND del_yn='N';
-- PRD_000235 레더 스트링 원형파우치: 판형 SIZ_000441(323x210) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000235' AND siz_cd='SIZ_000441' AND del_yn='N';
-- PRD_000236 레더 플랫 클러치: 판형 SIZ_000442(640x230) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000236' AND siz_cd='SIZ_000442' AND del_yn='N';
-- PRD_000237 레더 삼각 클러치: 판형 SIZ_000443(640x250) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000237' AND siz_cd='SIZ_000443' AND del_yn='N';
-- PRD_000238 레더 아이패드/노트북 파우치: 판형 SIZ_000444(444x287) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000238' AND siz_cd='SIZ_000444' AND del_yn='N';
-- PRD_000238 레더 아이패드/노트북 파우치: 판형 SIZ_000445(368x544) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000238' AND siz_cd='SIZ_000445' AND del_yn='N';
-- PRD_000238 레더 아이패드/노트북 파우치: 판형 SIZ_000446(412x594) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000238' AND siz_cd='SIZ_000446' AND del_yn='N';
-- PRD_000239 캔버스 플랫 파우치: 판형 SIZ_000433(220x300) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000239' AND siz_cd='SIZ_000433' AND del_yn='N';
-- PRD_000239 캔버스 플랫 파우치: 판형 SIZ_000434(260x340) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000239' AND siz_cd='SIZ_000434' AND del_yn='N';
-- PRD_000240 캔버스 삼각 파우치: 판형 SIZ_000433(220x300) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000240' AND siz_cd='SIZ_000433' AND del_yn='N';
-- PRD_000240 캔버스 삼각 파우치: 판형 SIZ_000447(260x380) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000240' AND siz_cd='SIZ_000447' AND del_yn='N';
-- PRD_000241 캔버스 스트랩 라벨파우치: 판형 SIZ_000448(70x100) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000241' AND siz_cd='SIZ_000448' AND del_yn='N';
-- PRD_000242 광목 스트링 라벨파우치: 판형 SIZ_000246(100x70) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000242' AND siz_cd='SIZ_000246' AND del_yn='N';
-- PRD_000242 광목 스트링 라벨파우치: 판형 SIZ_000449(100x40) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000242' AND siz_cd='SIZ_000449' AND del_yn='N';
-- PRD_000243 린넨 스트링 파우치: 판형 SIZ_000450(180x240) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000243' AND siz_cd='SIZ_000450' AND del_yn='N';
-- PRD_000243 린넨 스트링 파우치: 판형 SIZ_000451(220x530) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000243' AND siz_cd='SIZ_000451' AND del_yn='N';
-- PRD_000243 린넨 스트링 파우치: 판형 SIZ_000452(260x630) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000243' AND siz_cd='SIZ_000452' AND del_yn='N';
-- PRD_000244 타이벡 플랫 파우치: 판형 SIZ_000453(444x155) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000244' AND siz_cd='SIZ_000453' AND del_yn='N';
-- PRD_000244 타이벡 플랫 파우치: 판형 SIZ_000454(524x195) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000244' AND siz_cd='SIZ_000454' AND del_yn='N';
-- PRD_000244 타이벡 플랫 파우치: 판형 SIZ_000455(744x285) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000244' AND siz_cd='SIZ_000455' AND del_yn='N';
-- PRD_000245 타이벡 슬림 파우치: 판형 SIZ_000435(220x294) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000245' AND siz_cd='SIZ_000435' AND del_yn='N';
-- PRD_000245 타이벡 슬림 파우치: 판형 SIZ_000436(260x374) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000245' AND siz_cd='SIZ_000436' AND del_yn='N';
-- PRD_000246 타이벡 삼각 파우치: 판형 SIZ_000456(220x330) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000246' AND siz_cd='SIZ_000456' AND del_yn='N';
-- PRD_000246 타이벡 삼각 파우치: 판형 SIZ_000457(260x390) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000246' AND siz_cd='SIZ_000457' AND del_yn='N';
-- PRD_000247 타이벡 스트링 파우치: 판형 SIZ_000458(210x520) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000247' AND siz_cd='SIZ_000458' AND del_yn='N';
-- PRD_000247 타이벡 스트링 파우치: 판형 SIZ_000459(250x620) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000247' AND siz_cd='SIZ_000459' AND del_yn='N';
-- PRD_000247 타이벡 스트링 파우치: 판형 SIZ_000460(320x820) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000247' AND siz_cd='SIZ_000460' AND del_yn='N';
-- PRD_000248 타이벡 플랫 클러치: 판형 SIZ_000442(640x230) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000248' AND siz_cd='SIZ_000442' AND del_yn='N';
-- PRD_000249 메쉬슬림파우치: 판형 SIZ_000435(220x294) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000249' AND siz_cd='SIZ_000435' AND del_yn='N';
-- PRD_000249 메쉬슬림파우치: 판형 SIZ_000436(260x374) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000249' AND siz_cd='SIZ_000436' AND del_yn='N';
-- PRD_000250 메쉬볼륨파우치: 판형 SIZ_000461(380x454) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000250' AND siz_cd='SIZ_000461' AND del_yn='N';
-- PRD_000251 레더 플랫 미니파우치: 판형 SIZ_000462(130x240) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000251' AND siz_cd='SIZ_000462' AND del_yn='N';
-- PRD_000252 레더 슬림 미니파우치: 판형 SIZ_000463(130x194) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000252' AND siz_cd='SIZ_000463' AND del_yn='N';
-- PRD_000252 레더 슬림 미니파우치: 판형 SIZ_000464(140x254) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000252' AND siz_cd='SIZ_000464' AND del_yn='N';
-- PRD_000253 레더 삼각 미니파우치: 판형 SIZ_000465(120x220) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000253' AND siz_cd='SIZ_000465' AND del_yn='N';
-- PRD_000254 레더 볼륨 미니파우치: 판형 SIZ_000466(165x187) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000254' AND siz_cd='SIZ_000466' AND del_yn='N';
-- PRD_000254 레더 볼륨 미니파우치: 판형 SIZ_000467(200x187) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000254' AND siz_cd='SIZ_000467' AND del_yn='N';
-- PRD_000255 레더 원형 미니파우치: 판형 SIZ_000468(220x110) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000255' AND siz_cd='SIZ_000468' AND del_yn='N';
-- PRD_000256 레더 플랫 필통: 판형 SIZ_000469(220x190) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000256' AND siz_cd='SIZ_000469' AND del_yn='N';
-- PRD_000257 레더 슬림 필통: 판형 SIZ_000470(220x194) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000257' AND siz_cd='SIZ_000470' AND del_yn='N';
-- PRD_000258 레더 삼각 필통: 판형 SIZ_000471(220x210) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000258' AND siz_cd='SIZ_000471' AND del_yn='N';
-- PRD_000259 레더 볼륨 필통: 판형 SIZ_000472(270x214) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000259' AND siz_cd='SIZ_000472' AND del_yn='N';
-- PRD_000260 레더 원형 필통: 판형 SIZ_000473(220x234) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000260' AND siz_cd='SIZ_000473' AND del_yn='N';
-- PRD_000261 캔버스 플랫 필통: 판형 SIZ_000469(220x190) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000261' AND siz_cd='SIZ_000469' AND del_yn='N';
-- PRD_000262 캔버스 삼각 필통: 판형 SIZ_000474(240x210) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000262' AND siz_cd='SIZ_000474' AND del_yn='N';
-- PRD_000263 레더토트백: 판형 SIZ_000475(330x660) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000263' AND siz_cd='SIZ_000475' AND del_yn='N';
-- PRD_000264 레더숄더백: 판형 SIZ_000476(760x440) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000264' AND siz_cd='SIZ_000476' AND del_yn='N';
-- PRD_000265 린넨 미니에코백: 판형 SIZ_000477(280x610) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000265' AND siz_cd='SIZ_000477' AND del_yn='N';
-- PRD_000266 린넨 토트백: 판형 SIZ_000478(380x1010) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000266' AND siz_cd='SIZ_000478' AND del_yn='N';
-- PRD_000267 린넨 에코백: 판형 SIZ_000479(390x910) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000267' AND siz_cd='SIZ_000479' AND del_yn='N';
-- PRD_000267 린넨 에코백: 판형 SIZ_000480(430x830) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000267' AND siz_cd='SIZ_000480' AND del_yn='N';
-- PRD_000268 캔버스심플백: 판형 SIZ_000481(340x800) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000268' AND siz_cd='SIZ_000481' AND del_yn='N';
-- PRD_000269 캔버스 포켓심플백: 판형 SIZ_000482(260x300) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000269' AND siz_cd='SIZ_000482' AND del_yn='N';
-- PRD_000270 캔버스에코백: 판형 SIZ_000483(530x900) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000270' AND siz_cd='SIZ_000483' AND del_yn='N';
-- PRD_000271 캔버스숄더백: 판형 SIZ_000476(760x440) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000271' AND siz_cd='SIZ_000476' AND del_yn='N';
-- PRD_000272 캔버스 포켓숄더백: 판형 SIZ_000484(320x300) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000272' AND siz_cd='SIZ_000484' AND del_yn='N';
-- PRD_000273 타이벡 양면 백팩: 판형 SIZ_000401(320x860) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000273' AND siz_cd='SIZ_000401' AND del_yn='N';
-- PRD_000273 타이벡 양면 백팩: 판형 SIZ_000485(400x1040) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000273' AND siz_cd='SIZ_000485' AND del_yn='N';
-- PRD_000274 타이벡보냉보틀백: 판형 SIZ_000486(220x580) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000274' AND siz_cd='SIZ_000486' AND del_yn='N';
-- PRD_000274 타이벡보냉보틀백: 판형 SIZ_000487(220x780) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000274' AND siz_cd='SIZ_000487' AND del_yn='N';
-- PRD_000275 타이벡 보냉 미니백: 판형 SIZ_000488(360x580) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000275' AND siz_cd='SIZ_000488' AND del_yn='N';
-- PRD_000276 타이벡 에코백: 판형 SIZ_000489(380x880) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000276' AND siz_cd='SIZ_000489' AND del_yn='N';
-- PRD_000277 타이벡 보냉에코백: 판형 SIZ_000489(380x880) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000277' AND siz_cd='SIZ_000489' AND del_yn='N';
-- PRD_000278 메쉬 토트백: 판형 SIZ_000490(380x690) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000278' AND siz_cd='SIZ_000490' AND del_yn='N';
-- PRD_000279 메쉬에코백: 판형 SIZ_000491(440x810) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000279' AND siz_cd='SIZ_000491' AND del_yn='N';
-- PRD_000280 레더라벨제작: 판형 SIZ_000493(50x30) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000280' AND siz_cd='SIZ_000493' AND del_yn='N';
-- PRD_000280 레더라벨제작: 판형 SIZ_000495(60x40) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000280' AND siz_cd='SIZ_000495' AND del_yn='N';
-- PRD_000280 레더라벨제작: 판형 SIZ_000497(80x50) 논리삭제(완제품 오적재)
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000280' AND siz_cd='SIZ_000497' AND del_yn='N';
SELECT '잔여 활성판형' AS chk, count(*) FROM t_prd_product_plate_sizes WHERE prd_cd IN ('PRD_000088','PRD_000120','PRD_000121','PRD_000122','PRD_000123','PRD_000124','PRD_000125','PRD_000126','PRD_000127','PRD_000128','PRD_000129','PRD_000130','PRD_000131','PRD_000132','PRD_000133','PRD_000134','PRD_000135','PRD_000136','PRD_000137','PRD_000138','PRD_000139','PRD_000140','PRD_000141','PRD_000142','PRD_000143','PRD_000144','PRD_000145','PRD_000146','PRD_000147','PRD_000148','PRD_000149','PRD_000150','PRD_000151','PRD_000152','PRD_000153','PRD_000154','PRD_000155','PRD_000157','PRD_000158','PRD_000159','PRD_000160','PRD_000161','PRD_000163','PRD_000183','PRD_000184','PRD_000185','PRD_000186','PRD_000187','PRD_000188','PRD_000189','PRD_000190','PRD_000191','PRD_000192','PRD_000194','PRD_000195','PRD_000196','PRD_000197','PRD_000198','PRD_000200','PRD_000201','PRD_000205','PRD_000206','PRD_000209','PRD_000210','PRD_000211','PRD_000212','PRD_000213','PRD_000214','PRD_000215','PRD_000216','PRD_000219','PRD_000220','PRD_000221','PRD_000223','PRD_000224','PRD_000225','PRD_000230','PRD_000231','PRD_000232','PRD_000233','PRD_000234','PRD_000235','PRD_000236','PRD_000237','PRD_000238','PRD_000239','PRD_000240','PRD_000241','PRD_000242','PRD_000243','PRD_000244','PRD_000245','PRD_000246','PRD_000247','PRD_000248','PRD_000249','PRD_000250','PRD_000251','PRD_000252','PRD_000253','PRD_000254','PRD_000255','PRD_000256','PRD_000257','PRD_000258','PRD_000259','PRD_000260','PRD_000261','PRD_000262','PRD_000263','PRD_000264','PRD_000265','PRD_000266','PRD_000267','PRD_000268','PRD_000269','PRD_000270','PRD_000271','PRD_000272','PRD_000273','PRD_000274','PRD_000275','PRD_000276','PRD_000277','PRD_000278','PRD_000279','PRD_000280') AND del_yn='N';
ROLLBACK;
