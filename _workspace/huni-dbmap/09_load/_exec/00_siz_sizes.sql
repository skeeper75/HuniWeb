-- 00_siz_sizes.sql
-- 단계00b 코드행 선적재 — sticker 원형 신설 10(SIZ_000501~510). REUSE 제외: SIZ_000422 (라이브 실재). PK pk_t_siz_sizes(siz_cd).
-- 생성: gen_load_sql.py (손편집 금지). BEGIN/COMMIT 미포함 — apply.sql 가 래핑.

-- src: 00_siz_sticker_circle.csv:row2 siz_cd=SIZ_000501
INSERT INTO t_siz_sizes (siz_cd, siz_nm, cut_width, cut_height, impos_yn, use_yn, note)
VALUES ('SIZ_000501', '원형10x10', 10.00, 10.00, 'N', 'Y', '합판도무송 원형 옵션(원형 10mm (8EA)). 판당 8EA는 bundle_qty 차원(size 아님).')
ON CONFLICT (siz_cd) DO NOTHING;
-- src: 00_siz_sticker_circle.csv:row3 siz_cd=SIZ_000502
INSERT INTO t_siz_sizes (siz_cd, siz_nm, cut_width, cut_height, impos_yn, use_yn, note)
VALUES ('SIZ_000502', '원형15x15', 15.00, 15.00, 'N', 'Y', '합판도무송 원형 옵션(원형 15mm (8EA)). 판당 8EA는 bundle_qty 차원(size 아님).')
ON CONFLICT (siz_cd) DO NOTHING;
-- src: 00_siz_sticker_circle.csv:row4 siz_cd=SIZ_000503
INSERT INTO t_siz_sizes (siz_cd, siz_nm, cut_width, cut_height, impos_yn, use_yn, note)
VALUES ('SIZ_000503', '원형20x20', 20.00, 20.00, 'N', 'Y', '합판도무송 원형 옵션(원형 20mm (6EA)). 판당 6EA는 bundle_qty 차원(size 아님).')
ON CONFLICT (siz_cd) DO NOTHING;
-- src: 00_siz_sticker_circle.csv:row5 siz_cd=SIZ_000504
INSERT INTO t_siz_sizes (siz_cd, siz_nm, cut_width, cut_height, impos_yn, use_yn, note)
VALUES ('SIZ_000504', '원형25x25', 25.00, 25.00, 'N', 'Y', '합판도무송 원형 옵션(원형 25mm (3EA)). 판당 3EA는 bundle_qty 차원(size 아님).')
ON CONFLICT (siz_cd) DO NOTHING;
-- src: 00_siz_sticker_circle.csv:row6 siz_cd=SIZ_000505
INSERT INTO t_siz_sizes (siz_cd, siz_nm, cut_width, cut_height, impos_yn, use_yn, note)
VALUES ('SIZ_000505', '원형30x30', 30.00, 30.00, 'N', 'Y', '합판도무송 원형 옵션(원형 30mm (2EA)). 판당 2EA는 bundle_qty 차원(size 아님).')
ON CONFLICT (siz_cd) DO NOTHING;
-- src: 00_siz_sticker_circle.csv:row8 siz_cd=SIZ_000506
INSERT INTO t_siz_sizes (siz_cd, siz_nm, cut_width, cut_height, impos_yn, use_yn, note)
VALUES ('SIZ_000506', '원형40x40', 40.00, 40.00, 'N', 'Y', '합판도무송 원형 옵션(원형 40mm (2EA)). 판당 2EA는 bundle_qty 차원(size 아님).')
ON CONFLICT (siz_cd) DO NOTHING;
-- src: 00_siz_sticker_circle.csv:row9 siz_cd=SIZ_000507
INSERT INTO t_siz_sizes (siz_cd, siz_nm, cut_width, cut_height, impos_yn, use_yn, note)
VALUES ('SIZ_000507', '원형45x45', 45.00, 45.00, 'N', 'Y', '합판도무송 원형 옵션(원형 45mm (1EA)). 판당 1EA는 bundle_qty 차원(size 아님).')
ON CONFLICT (siz_cd) DO NOTHING;
-- src: 00_siz_sticker_circle.csv:row10 siz_cd=SIZ_000508
INSERT INTO t_siz_sizes (siz_cd, siz_nm, cut_width, cut_height, impos_yn, use_yn, note)
VALUES ('SIZ_000508', '원형50x50', 50.00, 50.00, 'N', 'Y', '합판도무송 원형 옵션(원형 50mm (1EA)). 판당 1EA는 bundle_qty 차원(size 아님).')
ON CONFLICT (siz_cd) DO NOTHING;
-- src: 00_siz_sticker_circle.csv:row11 siz_cd=SIZ_000509
INSERT INTO t_siz_sizes (siz_cd, siz_nm, cut_width, cut_height, impos_yn, use_yn, note)
VALUES ('SIZ_000509', '원형55x55', 55.00, 55.00, 'N', 'Y', '합판도무송 원형 옵션(원형 55mm (1EA)). 판당 1EA는 bundle_qty 차원(size 아님).')
ON CONFLICT (siz_cd) DO NOTHING;
-- src: 00_siz_sticker_circle.csv:row12 siz_cd=SIZ_000510
INSERT INTO t_siz_sizes (siz_cd, siz_nm, cut_width, cut_height, impos_yn, use_yn, note)
VALUES ('SIZ_000510', '원형60x60', 60.00, 60.00, 'N', 'Y', '합판도무송 원형 옵션(원형 60mm (1EA)). 판당 1EA는 bundle_qty 차원(size 아님).')
ON CONFLICT (siz_cd) DO NOTHING;
