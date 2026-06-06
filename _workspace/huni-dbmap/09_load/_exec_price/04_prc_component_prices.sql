-- 04_prc_component_prices.sql
-- 단계04 단가 — 충돌키=PK comp_price_id(CSV 명시값). 자연키 idx NULLS DISTINCT 라 PK 채택.
-- 생성: gen_load_sql.py (손편집 금지). 멱등: ON CONFLICT 가드.
-- BEGIN/COMMIT 미포함 — apply.sql 가 트랜잭션 래핑.

-- src: 04_prc_component_prices.csv:row2 comp_price_id=1139
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1139, 'COMP_ACRYL_CLEAR3T', '2026-06-01', 'SIZ_000336', NULL, NULL, NULL, NULL, NULL, 2500, '투명아크릴3T 가로20mm×세로20mm 면적단가 (라이브 siz SIZ_000336 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row3 comp_price_id=1143
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1143, 'COMP_ACRYL_CLEAR3T', '2026-06-01', 'SIZ_000346', NULL, NULL, NULL, NULL, NULL, 3400, '투명아크릴3T 가로60mm×세로20mm 면적단가 (라이브 siz SIZ_000346 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row4 comp_price_id=1153
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1153, 'COMP_ACRYL_CLEAR3T', '2026-06-01', 'SIZ_000329', NULL, NULL, NULL, NULL, NULL, 2700, '투명아크릴3T 가로20mm×세로30mm 면적단가 (라이브 siz SIZ_000329 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row5 comp_price_id=1154
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1154, 'COMP_ACRYL_CLEAR3T', '2026-06-01', 'SIZ_000330', NULL, NULL, NULL, NULL, NULL, 3100, '투명아크릴3T 가로30mm×세로30mm 면적단가 (라이브 siz SIZ_000330 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row6 comp_price_id=1156
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1156, 'COMP_ACRYL_CLEAR3T', '2026-06-01', 'SIZ_000493', NULL, NULL, NULL, NULL, NULL, 3800, '투명아크릴3T 가로50mm×세로30mm 면적단가 (라이브 siz SIZ_000493 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row7 comp_price_id=1159
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1159, 'COMP_ACRYL_CLEAR3T', '2026-06-01', 'SIZ_000350', NULL, NULL, NULL, NULL, NULL, 4700, '투명아크릴3T 가로80mm×세로30mm 면적단가 (라이브 siz SIZ_000350 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row8 comp_price_id=1168
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1168, 'COMP_ACRYL_CLEAR3T', '2026-06-01', 'SIZ_000331', NULL, NULL, NULL, NULL, NULL, 3400, '투명아크릴3T 가로30mm×세로40mm 면적단가 (라이브 siz SIZ_000331 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row9 comp_price_id=1169
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1169, 'COMP_ACRYL_CLEAR3T', '2026-06-01', 'SIZ_000333', NULL, NULL, NULL, NULL, NULL, 3800, '투명아크릴3T 가로40mm×세로40mm 면적단가 (라이브 siz SIZ_000333 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row10 comp_price_id=1171
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1171, 'COMP_ACRYL_CLEAR3T', '2026-06-01', 'SIZ_000495', NULL, NULL, NULL, NULL, NULL, 4700, '투명아크릴3T 가로60mm×세로40mm 면적단가 (라이브 siz SIZ_000495 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row11 comp_price_id=1175
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1175, 'COMP_ACRYL_CLEAR3T', '2026-06-01', 'SIZ_000449', NULL, NULL, NULL, NULL, NULL, 6400, '투명아크릴3T 가로100mm×세로40mm 면적단가 (라이브 siz SIZ_000449 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row12 comp_price_id=1183
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1183, 'COMP_ACRYL_CLEAR3T', '2026-06-01', 'SIZ_000334', NULL, NULL, NULL, NULL, NULL, 4200, '투명아크릴3T 가로40mm×세로50mm 면적단가 (라이브 siz SIZ_000334 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row13 comp_price_id=1184
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1184, 'COMP_ACRYL_CLEAR3T', '2026-06-01', 'SIZ_000011', NULL, NULL, NULL, NULL, NULL, 4800, '투명아크릴3T 가로50mm×세로50mm 면적단가 (라이브 siz SIZ_000011 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row14 comp_price_id=1186
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1186, 'COMP_ACRYL_CLEAR3T', '2026-06-01', 'SIZ_000062', NULL, NULL, NULL, NULL, NULL, 5800, '투명아크릴3T 가로70mm×세로50mm 면적단가 (라이브 siz SIZ_000062 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row15 comp_price_id=1187
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1187, 'COMP_ACRYL_CLEAR3T', '2026-06-01', 'SIZ_000497', NULL, NULL, NULL, NULL, NULL, 6400, '투명아크릴3T 가로80mm×세로50mm 면적단가 (라이브 siz SIZ_000497 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row16 comp_price_id=1188
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1188, 'COMP_ACRYL_CLEAR3T', '2026-06-01', 'SIZ_000008', NULL, NULL, NULL, NULL, NULL, 6900, '투명아크릴3T 가로90mm×세로50mm 면적단가 (라이브 siz SIZ_000008 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row17 comp_price_id=1189
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1189, 'COMP_ACRYL_CLEAR3T', '2026-06-01', 'SIZ_000243', NULL, NULL, NULL, NULL, NULL, 7400, '투명아크릴3T 가로100mm×세로50mm 면적단가 (라이브 siz SIZ_000243 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row18 comp_price_id=1190
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1190, 'COMP_ACRYL_CLEAR3T', '2026-06-01', 'SIZ_000365', NULL, NULL, NULL, NULL, NULL, 8400, '투명아크릴3T 가로120mm×세로50mm 면적단가 (라이브 siz SIZ_000365 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row19 comp_price_id=1197
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1197, 'COMP_ACRYL_CLEAR3T', '2026-06-01', 'SIZ_000335', NULL, NULL, NULL, NULL, NULL, 4700, '투명아크릴3T 가로40mm×세로60mm 면적단가 (라이브 siz SIZ_000335 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row20 comp_price_id=1199
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1199, 'COMP_ACRYL_CLEAR3T', '2026-06-01', 'SIZ_000148', NULL, NULL, NULL, NULL, NULL, 5900, '투명아크릴3T 가로60mm×세로60mm 면적단가 (라이브 siz SIZ_000148 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row21 comp_price_id=1200
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1200, 'COMP_ACRYL_CLEAR3T', '2026-06-01', 'SIZ_000344', NULL, NULL, NULL, NULL, NULL, 6600, '투명아크릴3T 가로70mm×세로60mm 면적단가 (라이브 siz SIZ_000344 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row22 comp_price_id=1203
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1203, 'COMP_ACRYL_CLEAR3T', '2026-06-01', 'SIZ_000147', NULL, NULL, NULL, NULL, NULL, 8500, '투명아크릴3T 가로100mm×세로60mm 면적단가 (라이브 siz SIZ_000147 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row23 comp_price_id=1204
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1204, 'COMP_ACRYL_CLEAR3T', '2026-06-01', 'SIZ_000357', NULL, NULL, NULL, NULL, NULL, 9900, '투명아크릴3T 가로120mm×세로60mm 면적단가 (라이브 siz SIZ_000357 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row24 comp_price_id=1210
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1210, 'COMP_ACRYL_CLEAR3T', '2026-06-01', 'SIZ_000332', NULL, NULL, NULL, NULL, NULL, 4300, '투명아크릴3T 가로30mm×세로70mm 면적단가 (라이브 siz SIZ_000332 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row25 comp_price_id=1212
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1212, 'COMP_ACRYL_CLEAR3T', '2026-06-01', 'SIZ_000061', NULL, NULL, NULL, NULL, NULL, 5800, '투명아크릴3T 가로50mm×세로70mm 면적단가 (라이브 siz SIZ_000061 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row26 comp_price_id=1213
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1213, 'COMP_ACRYL_CLEAR3T', '2026-06-01', 'SIZ_000370', NULL, NULL, NULL, NULL, NULL, 6600, '투명아크릴3T 가로60mm×세로70mm 면적단가 (라이브 siz SIZ_000370 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row27 comp_price_id=1214
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1214, 'COMP_ACRYL_CLEAR3T', '2026-06-01', 'SIZ_000211', NULL, NULL, NULL, NULL, NULL, 7300, '투명아크릴3T 가로70mm×세로70mm 면적단가 (라이브 siz SIZ_000211 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row28 comp_price_id=1217
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1217, 'COMP_ACRYL_CLEAR3T', '2026-06-01', 'SIZ_000246', NULL, NULL, NULL, NULL, NULL, 9500, '투명아크릴3T 가로100mm×세로70mm 면적단가 (라이브 siz SIZ_000246 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row29 comp_price_id=1225
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1225, 'COMP_ACRYL_CLEAR3T', '2026-06-01', 'SIZ_000047', NULL, NULL, NULL, NULL, NULL, 5500, '투명아크릴3T 가로40mm×세로80mm 면적단가 (라이브 siz SIZ_000047 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row30 comp_price_id=1227
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1227, 'COMP_ACRYL_CLEAR3T', '2026-06-01', 'SIZ_000371', NULL, NULL, NULL, NULL, NULL, 7200, '투명아크릴3T 가로60mm×세로80mm 면적단가 (라이브 siz SIZ_000371 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row31 comp_price_id=1229
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1229, 'COMP_ACRYL_CLEAR3T', '2026-06-01', 'SIZ_000043', NULL, NULL, NULL, NULL, NULL, 8900, '투명아크릴3T 가로80mm×세로80mm 면적단가 (라이브 siz SIZ_000043 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row32 comp_price_id=1231
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1231, 'COMP_ACRYL_CLEAR3T', '2026-06-01', 'SIZ_000248', NULL, NULL, NULL, NULL, NULL, 10600, '투명아크릴3T 가로100mm×세로80mm 면적단가 (라이브 siz SIZ_000248 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row33 comp_price_id=1233
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1233, 'COMP_ACRYL_CLEAR3T', '2026-06-01', 'SIZ_000045', NULL, NULL, NULL, NULL, NULL, 13800, '투명아크릴3T 가로140mm×세로80mm 면적단가 (라이브 siz SIZ_000045 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row34 comp_price_id=1234
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1234, 'COMP_ACRYL_CLEAR3T', '2026-06-01', 'SIZ_000046', NULL, NULL, NULL, NULL, NULL, 15400, '투명아크릴3T 가로160mm×세로80mm 면적단가 (라이브 siz SIZ_000046 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row35 comp_price_id=1240
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1240, 'COMP_ACRYL_CLEAR3T', '2026-06-01', 'SIZ_000132', NULL, NULL, NULL, NULL, NULL, 6900, '투명아크릴3T 가로50mm×세로90mm 면적단가 (라이브 siz SIZ_000132 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row36 comp_price_id=1241
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1241, 'COMP_ACRYL_CLEAR3T', '2026-06-01', 'SIZ_000372', NULL, NULL, NULL, NULL, NULL, 7800, '투명아크릴3T 가로60mm×세로90mm 면적단가 (라이브 siz SIZ_000372 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row37 comp_price_id=1244
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1244, 'COMP_ACRYL_CLEAR3T', '2026-06-01', 'SIZ_000119', NULL, NULL, NULL, NULL, NULL, 10700, '투명아크릴3T 가로90mm×세로90mm 면적단가 (라이브 siz SIZ_000119 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row38 comp_price_id=1245
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1245, 'COMP_ACRYL_CLEAR3T', '2026-06-01', 'SIZ_000017', NULL, NULL, NULL, NULL, NULL, 11700, '투명아크릴3T 가로100mm×세로90mm 면적단가 (라이브 siz SIZ_000017 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row39 comp_price_id=1246
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1246, 'COMP_ACRYL_CLEAR3T', '2026-06-01', 'SIZ_000358', NULL, NULL, NULL, NULL, NULL, 13700, '투명아크릴3T 가로120mm×세로90mm 면적단가 (라이브 siz SIZ_000358 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row40 comp_price_id=1255
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1255, 'COMP_ACRYL_CLEAR3T', '2026-06-01', 'SIZ_000373', NULL, NULL, NULL, NULL, NULL, 8500, '투명아크릴3T 가로60mm×세로100mm 면적단가 (라이브 siz SIZ_000373 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row41 comp_price_id=1256
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1256, 'COMP_ACRYL_CLEAR3T', '2026-06-01', 'SIZ_000448', NULL, NULL, NULL, NULL, NULL, 9500, '투명아크릴3T 가로70mm×세로100mm 면적단가 (라이브 siz SIZ_000448 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row42 comp_price_id=1258
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1258, 'COMP_ACRYL_CLEAR3T', '2026-06-01', 'SIZ_000018', NULL, NULL, NULL, NULL, NULL, 11700, '투명아크릴3T 가로90mm×세로100mm 면적단가 (라이브 siz SIZ_000018 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row43 comp_price_id=1259
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1259, 'COMP_ACRYL_CLEAR3T', '2026-06-01', 'SIZ_000113', NULL, NULL, NULL, NULL, NULL, 12700, '투명아크릴3T 가로100mm×세로100mm 면적단가 (라이브 siz SIZ_000113 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row44 comp_price_id=1261
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1261, 'COMP_ACRYL_CLEAR3T', '2026-06-01', 'SIZ_000067', NULL, NULL, NULL, NULL, NULL, 16700, '투명아크릴3T 가로140mm×세로100mm 면적단가 (라이브 siz SIZ_000067 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row45 comp_price_id=1270
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1270, 'COMP_ACRYL_CLEAR3T', '2026-06-01', 'SIZ_000266', NULL, NULL, NULL, NULL, NULL, 10900, '투명아크릴3T 가로70mm×세로120mm 면적단가 (라이브 siz SIZ_000266 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row46 comp_price_id=1274
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1274, 'COMP_ACRYL_CLEAR3T', '2026-06-01', 'SIZ_000359', NULL, NULL, NULL, NULL, NULL, 16700, '투명아크릴3T 가로120mm×세로120mm 면적단가 (라이브 siz SIZ_000359 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row47 comp_price_id=1287
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1287, 'COMP_ACRYL_CLEAR3T', '2026-06-01', 'SIZ_000058', NULL, NULL, NULL, NULL, NULL, 16700, '투명아크릴3T 가로100mm×세로140mm 면적단가 (라이브 siz SIZ_000058 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row48 comp_price_id=1316
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1316, 'COMP_ACRYL_CLEAR3T', '2026-06-01', 'SIZ_000361', NULL, NULL, NULL, NULL, NULL, 22700, '투명아크릴3T 가로120mm×세로180mm 면적단가 (라이브 siz SIZ_000361 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row49 comp_price_id=1335
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1335, 'COMP_ACRYL_CLEAR15T', '2026-06-01', 'SIZ_000336', NULL, NULL, NULL, NULL, NULL, 2000, '투명아크릴1.5T 가로20mm×세로20mm 면적단가 (라이브 siz SIZ_000336 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row50 comp_price_id=1339
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1339, 'COMP_ACRYL_CLEAR15T', '2026-06-01', 'SIZ_000346', NULL, NULL, NULL, NULL, NULL, 2720, '투명아크릴1.5T 가로60mm×세로20mm 면적단가 (라이브 siz SIZ_000346 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row51 comp_price_id=1344
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1344, 'COMP_ACRYL_CLEAR15T', '2026-06-01', 'SIZ_000329', NULL, NULL, NULL, NULL, NULL, 2160, '투명아크릴1.5T 가로20mm×세로30mm 면적단가 (라이브 siz SIZ_000329 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row52 comp_price_id=1345
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1345, 'COMP_ACRYL_CLEAR15T', '2026-06-01', 'SIZ_000330', NULL, NULL, NULL, NULL, NULL, 2480, '투명아크릴1.5T 가로30mm×세로30mm 면적단가 (라이브 siz SIZ_000330 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row53 comp_price_id=1347
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1347, 'COMP_ACRYL_CLEAR15T', '2026-06-01', 'SIZ_000493', NULL, NULL, NULL, NULL, NULL, 3040, '투명아크릴1.5T 가로50mm×세로30mm 면적단가 (라이브 siz SIZ_000493 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row54 comp_price_id=1350
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1350, 'COMP_ACRYL_CLEAR15T', '2026-06-01', 'SIZ_000350', NULL, NULL, NULL, NULL, NULL, 3760, '투명아크릴1.5T 가로80mm×세로30mm 면적단가 (라이브 siz SIZ_000350 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row55 comp_price_id=1354
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1354, 'COMP_ACRYL_CLEAR15T', '2026-06-01', 'SIZ_000331', NULL, NULL, NULL, NULL, NULL, 2720, '투명아크릴1.5T 가로30mm×세로40mm 면적단가 (라이브 siz SIZ_000331 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row56 comp_price_id=1355
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1355, 'COMP_ACRYL_CLEAR15T', '2026-06-01', 'SIZ_000333', NULL, NULL, NULL, NULL, NULL, 3040, '투명아크릴1.5T 가로40mm×세로40mm 면적단가 (라이브 siz SIZ_000333 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row57 comp_price_id=1357
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1357, 'COMP_ACRYL_CLEAR15T', '2026-06-01', 'SIZ_000495', NULL, NULL, NULL, NULL, NULL, 3760, '투명아크릴1.5T 가로60mm×세로40mm 면적단가 (라이브 siz SIZ_000495 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row58 comp_price_id=1361
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1361, 'COMP_ACRYL_CLEAR15T', '2026-06-01', 'SIZ_000449', NULL, NULL, NULL, NULL, NULL, 5120, '투명아크릴1.5T 가로100mm×세로40mm 면적단가 (라이브 siz SIZ_000449 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row59 comp_price_id=1364
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1364, 'COMP_ACRYL_CLEAR15T', '2026-06-01', 'SIZ_000334', NULL, NULL, NULL, NULL, NULL, 3360, '투명아크릴1.5T 가로40mm×세로50mm 면적단가 (라이브 siz SIZ_000334 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row60 comp_price_id=1365
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1365, 'COMP_ACRYL_CLEAR15T', '2026-06-01', 'SIZ_000011', NULL, NULL, NULL, NULL, NULL, 3840, '투명아크릴1.5T 가로50mm×세로50mm 면적단가 (라이브 siz SIZ_000011 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row61 comp_price_id=1367
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1367, 'COMP_ACRYL_CLEAR15T', '2026-06-01', 'SIZ_000062', NULL, NULL, NULL, NULL, NULL, 4640, '투명아크릴1.5T 가로70mm×세로50mm 면적단가 (라이브 siz SIZ_000062 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row62 comp_price_id=1368
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1368, 'COMP_ACRYL_CLEAR15T', '2026-06-01', 'SIZ_000497', NULL, NULL, NULL, NULL, NULL, 5120, '투명아크릴1.5T 가로80mm×세로50mm 면적단가 (라이브 siz SIZ_000497 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row63 comp_price_id=1369
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1369, 'COMP_ACRYL_CLEAR15T', '2026-06-01', 'SIZ_000008', NULL, NULL, NULL, NULL, NULL, 5520, '투명아크릴1.5T 가로90mm×세로50mm 면적단가 (라이브 siz SIZ_000008 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row64 comp_price_id=1370
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1370, 'COMP_ACRYL_CLEAR15T', '2026-06-01', 'SIZ_000243', NULL, NULL, NULL, NULL, NULL, 5920, '투명아크릴1.5T 가로100mm×세로50mm 면적단가 (라이브 siz SIZ_000243 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row65 comp_price_id=1373
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1373, 'COMP_ACRYL_CLEAR15T', '2026-06-01', 'SIZ_000335', NULL, NULL, NULL, NULL, NULL, 3760, '투명아크릴1.5T 가로40mm×세로60mm 면적단가 (라이브 siz SIZ_000335 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row66 comp_price_id=1375
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1375, 'COMP_ACRYL_CLEAR15T', '2026-06-01', 'SIZ_000148', NULL, NULL, NULL, NULL, NULL, 4720, '투명아크릴1.5T 가로60mm×세로60mm 면적단가 (라이브 siz SIZ_000148 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row67 comp_price_id=1376
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1376, 'COMP_ACRYL_CLEAR15T', '2026-06-01', 'SIZ_000344', NULL, NULL, NULL, NULL, NULL, 5280, '투명아크릴1.5T 가로70mm×세로60mm 면적단가 (라이브 siz SIZ_000344 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row68 comp_price_id=1379
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1379, 'COMP_ACRYL_CLEAR15T', '2026-06-01', 'SIZ_000147', NULL, NULL, NULL, NULL, NULL, 6800, '투명아크릴1.5T 가로100mm×세로60mm 면적단가 (라이브 siz SIZ_000147 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row69 comp_price_id=1381
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1381, 'COMP_ACRYL_CLEAR15T', '2026-06-01', 'SIZ_000332', NULL, NULL, NULL, NULL, NULL, 3440, '투명아크릴1.5T 가로30mm×세로70mm 면적단가 (라이브 siz SIZ_000332 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row70 comp_price_id=1383
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1383, 'COMP_ACRYL_CLEAR15T', '2026-06-01', 'SIZ_000061', NULL, NULL, NULL, NULL, NULL, 4640, '투명아크릴1.5T 가로50mm×세로70mm 면적단가 (라이브 siz SIZ_000061 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row71 comp_price_id=1384
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1384, 'COMP_ACRYL_CLEAR15T', '2026-06-01', 'SIZ_000370', NULL, NULL, NULL, NULL, NULL, 5280, '투명아크릴1.5T 가로60mm×세로70mm 면적단가 (라이브 siz SIZ_000370 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row72 comp_price_id=1385
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1385, 'COMP_ACRYL_CLEAR15T', '2026-06-01', 'SIZ_000211', NULL, NULL, NULL, NULL, NULL, 5840, '투명아크릴1.5T 가로70mm×세로70mm 면적단가 (라이브 siz SIZ_000211 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row73 comp_price_id=1388
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1388, 'COMP_ACRYL_CLEAR15T', '2026-06-01', 'SIZ_000246', NULL, NULL, NULL, NULL, NULL, 7600, '투명아크릴1.5T 가로100mm×세로70mm 면적단가 (라이브 siz SIZ_000246 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row74 comp_price_id=1391
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1391, 'COMP_ACRYL_CLEAR15T', '2026-06-01', 'SIZ_000047', NULL, NULL, NULL, NULL, NULL, 4400, '투명아크릴1.5T 가로40mm×세로80mm 면적단가 (라이브 siz SIZ_000047 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row75 comp_price_id=1393
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1393, 'COMP_ACRYL_CLEAR15T', '2026-06-01', 'SIZ_000371', NULL, NULL, NULL, NULL, NULL, 5760, '투명아크릴1.5T 가로60mm×세로80mm 면적단가 (라이브 siz SIZ_000371 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row76 comp_price_id=1395
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1395, 'COMP_ACRYL_CLEAR15T', '2026-06-01', 'SIZ_000043', NULL, NULL, NULL, NULL, NULL, 7120, '투명아크릴1.5T 가로80mm×세로80mm 면적단가 (라이브 siz SIZ_000043 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row77 comp_price_id=1397
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1397, 'COMP_ACRYL_CLEAR15T', '2026-06-01', 'SIZ_000248', NULL, NULL, NULL, NULL, NULL, 8480, '투명아크릴1.5T 가로100mm×세로80mm 면적단가 (라이브 siz SIZ_000248 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row78 comp_price_id=1401
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1401, 'COMP_ACRYL_CLEAR15T', '2026-06-01', 'SIZ_000132', NULL, NULL, NULL, NULL, NULL, 5520, '투명아크릴1.5T 가로50mm×세로90mm 면적단가 (라이브 siz SIZ_000132 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row79 comp_price_id=1402
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1402, 'COMP_ACRYL_CLEAR15T', '2026-06-01', 'SIZ_000372', NULL, NULL, NULL, NULL, NULL, 6240, '투명아크릴1.5T 가로60mm×세로90mm 면적단가 (라이브 siz SIZ_000372 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row80 comp_price_id=1405
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1405, 'COMP_ACRYL_CLEAR15T', '2026-06-01', 'SIZ_000119', NULL, NULL, NULL, NULL, NULL, 8560, '투명아크릴1.5T 가로90mm×세로90mm 면적단가 (라이브 siz SIZ_000119 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row81 comp_price_id=1406
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1406, 'COMP_ACRYL_CLEAR15T', '2026-06-01', 'SIZ_000017', NULL, NULL, NULL, NULL, NULL, 9360, '투명아크릴1.5T 가로100mm×세로90mm 면적단가 (라이브 siz SIZ_000017 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row82 comp_price_id=1411
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1411, 'COMP_ACRYL_CLEAR15T', '2026-06-01', 'SIZ_000373', NULL, NULL, NULL, NULL, NULL, 6800, '투명아크릴1.5T 가로60mm×세로100mm 면적단가 (라이브 siz SIZ_000373 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row83 comp_price_id=1412
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1412, 'COMP_ACRYL_CLEAR15T', '2026-06-01', 'SIZ_000448', NULL, NULL, NULL, NULL, NULL, 7600, '투명아크릴1.5T 가로70mm×세로100mm 면적단가 (라이브 siz SIZ_000448 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row84 comp_price_id=1414
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1414, 'COMP_ACRYL_CLEAR15T', '2026-06-01', 'SIZ_000018', NULL, NULL, NULL, NULL, NULL, 9360, '투명아크릴1.5T 가로90mm×세로100mm 면적단가 (라이브 siz SIZ_000018 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row85 comp_price_id=1415
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1415, 'COMP_ACRYL_CLEAR15T', '2026-06-01', 'SIZ_000113', NULL, NULL, NULL, NULL, NULL, 10160, '투명아크릴1.5T 가로100mm×세로100mm 면적단가 (라이브 siz SIZ_000113 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row86 comp_price_id=1416
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1416, 'COMP_ACRYL_MIRROR3T', '2026-06-01', 'SIZ_000336', NULL, NULL, NULL, NULL, NULL, 5000, '미러아크릴3T(투명3T×2 파생) 가로20mm×세로20mm 면적단가 (라이브 siz SIZ_000336 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row87 comp_price_id=1420
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1420, 'COMP_ACRYL_MIRROR3T', '2026-06-01', 'SIZ_000346', NULL, NULL, NULL, NULL, NULL, 6800, '미러아크릴3T(투명3T×2 파생) 가로60mm×세로20mm 면적단가 (라이브 siz SIZ_000346 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row88 comp_price_id=1425
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1425, 'COMP_ACRYL_MIRROR3T', '2026-06-01', 'SIZ_000329', NULL, NULL, NULL, NULL, NULL, 5400, '미러아크릴3T(투명3T×2 파생) 가로20mm×세로30mm 면적단가 (라이브 siz SIZ_000329 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row89 comp_price_id=1426
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1426, 'COMP_ACRYL_MIRROR3T', '2026-06-01', 'SIZ_000330', NULL, NULL, NULL, NULL, NULL, 6200, '미러아크릴3T(투명3T×2 파생) 가로30mm×세로30mm 면적단가 (라이브 siz SIZ_000330 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row90 comp_price_id=1428
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1428, 'COMP_ACRYL_MIRROR3T', '2026-06-01', 'SIZ_000493', NULL, NULL, NULL, NULL, NULL, 7600, '미러아크릴3T(투명3T×2 파생) 가로50mm×세로30mm 면적단가 (라이브 siz SIZ_000493 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row91 comp_price_id=1431
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1431, 'COMP_ACRYL_MIRROR3T', '2026-06-01', 'SIZ_000350', NULL, NULL, NULL, NULL, NULL, 9400, '미러아크릴3T(투명3T×2 파생) 가로80mm×세로30mm 면적단가 (라이브 siz SIZ_000350 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row92 comp_price_id=1435
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1435, 'COMP_ACRYL_MIRROR3T', '2026-06-01', 'SIZ_000331', NULL, NULL, NULL, NULL, NULL, 6800, '미러아크릴3T(투명3T×2 파생) 가로30mm×세로40mm 면적단가 (라이브 siz SIZ_000331 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row93 comp_price_id=1436
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1436, 'COMP_ACRYL_MIRROR3T', '2026-06-01', 'SIZ_000333', NULL, NULL, NULL, NULL, NULL, 7600, '미러아크릴3T(투명3T×2 파생) 가로40mm×세로40mm 면적단가 (라이브 siz SIZ_000333 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row94 comp_price_id=1438
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1438, 'COMP_ACRYL_MIRROR3T', '2026-06-01', 'SIZ_000495', NULL, NULL, NULL, NULL, NULL, 9400, '미러아크릴3T(투명3T×2 파생) 가로60mm×세로40mm 면적단가 (라이브 siz SIZ_000495 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row95 comp_price_id=1442
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1442, 'COMP_ACRYL_MIRROR3T', '2026-06-01', 'SIZ_000449', NULL, NULL, NULL, NULL, NULL, 12800, '미러아크릴3T(투명3T×2 파생) 가로100mm×세로40mm 면적단가 (라이브 siz SIZ_000449 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row96 comp_price_id=1445
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1445, 'COMP_ACRYL_MIRROR3T', '2026-06-01', 'SIZ_000334', NULL, NULL, NULL, NULL, NULL, 8400, '미러아크릴3T(투명3T×2 파생) 가로40mm×세로50mm 면적단가 (라이브 siz SIZ_000334 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row97 comp_price_id=1446
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1446, 'COMP_ACRYL_MIRROR3T', '2026-06-01', 'SIZ_000011', NULL, NULL, NULL, NULL, NULL, 9600, '미러아크릴3T(투명3T×2 파생) 가로50mm×세로50mm 면적단가 (라이브 siz SIZ_000011 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row98 comp_price_id=1448
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1448, 'COMP_ACRYL_MIRROR3T', '2026-06-01', 'SIZ_000062', NULL, NULL, NULL, NULL, NULL, 11600, '미러아크릴3T(투명3T×2 파생) 가로70mm×세로50mm 면적단가 (라이브 siz SIZ_000062 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row99 comp_price_id=1449
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1449, 'COMP_ACRYL_MIRROR3T', '2026-06-01', 'SIZ_000497', NULL, NULL, NULL, NULL, NULL, 12800, '미러아크릴3T(투명3T×2 파생) 가로80mm×세로50mm 면적단가 (라이브 siz SIZ_000497 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row100 comp_price_id=1450
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1450, 'COMP_ACRYL_MIRROR3T', '2026-06-01', 'SIZ_000008', NULL, NULL, NULL, NULL, NULL, 13800, '미러아크릴3T(투명3T×2 파생) 가로90mm×세로50mm 면적단가 (라이브 siz SIZ_000008 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row101 comp_price_id=1451
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1451, 'COMP_ACRYL_MIRROR3T', '2026-06-01', 'SIZ_000243', NULL, NULL, NULL, NULL, NULL, 14800, '미러아크릴3T(투명3T×2 파생) 가로100mm×세로50mm 면적단가 (라이브 siz SIZ_000243 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row102 comp_price_id=1454
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1454, 'COMP_ACRYL_MIRROR3T', '2026-06-01', 'SIZ_000335', NULL, NULL, NULL, NULL, NULL, 9400, '미러아크릴3T(투명3T×2 파생) 가로40mm×세로60mm 면적단가 (라이브 siz SIZ_000335 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row103 comp_price_id=1456
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1456, 'COMP_ACRYL_MIRROR3T', '2026-06-01', 'SIZ_000148', NULL, NULL, NULL, NULL, NULL, 11800, '미러아크릴3T(투명3T×2 파생) 가로60mm×세로60mm 면적단가 (라이브 siz SIZ_000148 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row104 comp_price_id=1457
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1457, 'COMP_ACRYL_MIRROR3T', '2026-06-01', 'SIZ_000344', NULL, NULL, NULL, NULL, NULL, 13200, '미러아크릴3T(투명3T×2 파생) 가로70mm×세로60mm 면적단가 (라이브 siz SIZ_000344 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row105 comp_price_id=1460
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1460, 'COMP_ACRYL_MIRROR3T', '2026-06-01', 'SIZ_000147', NULL, NULL, NULL, NULL, NULL, 17000, '미러아크릴3T(투명3T×2 파생) 가로100mm×세로60mm 면적단가 (라이브 siz SIZ_000147 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row106 comp_price_id=1462
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1462, 'COMP_ACRYL_MIRROR3T', '2026-06-01', 'SIZ_000332', NULL, NULL, NULL, NULL, NULL, 8600, '미러아크릴3T(투명3T×2 파생) 가로30mm×세로70mm 면적단가 (라이브 siz SIZ_000332 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row107 comp_price_id=1464
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1464, 'COMP_ACRYL_MIRROR3T', '2026-06-01', 'SIZ_000061', NULL, NULL, NULL, NULL, NULL, 11600, '미러아크릴3T(투명3T×2 파생) 가로50mm×세로70mm 면적단가 (라이브 siz SIZ_000061 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row108 comp_price_id=1465
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1465, 'COMP_ACRYL_MIRROR3T', '2026-06-01', 'SIZ_000370', NULL, NULL, NULL, NULL, NULL, 13200, '미러아크릴3T(투명3T×2 파생) 가로60mm×세로70mm 면적단가 (라이브 siz SIZ_000370 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row109 comp_price_id=1466
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1466, 'COMP_ACRYL_MIRROR3T', '2026-06-01', 'SIZ_000211', NULL, NULL, NULL, NULL, NULL, 14600, '미러아크릴3T(투명3T×2 파생) 가로70mm×세로70mm 면적단가 (라이브 siz SIZ_000211 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row110 comp_price_id=1469
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1469, 'COMP_ACRYL_MIRROR3T', '2026-06-01', 'SIZ_000246', NULL, NULL, NULL, NULL, NULL, 19000, '미러아크릴3T(투명3T×2 파생) 가로100mm×세로70mm 면적단가 (라이브 siz SIZ_000246 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row111 comp_price_id=1472
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1472, 'COMP_ACRYL_MIRROR3T', '2026-06-01', 'SIZ_000047', NULL, NULL, NULL, NULL, NULL, 11000, '미러아크릴3T(투명3T×2 파생) 가로40mm×세로80mm 면적단가 (라이브 siz SIZ_000047 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row112 comp_price_id=1474
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1474, 'COMP_ACRYL_MIRROR3T', '2026-06-01', 'SIZ_000371', NULL, NULL, NULL, NULL, NULL, 14400, '미러아크릴3T(투명3T×2 파생) 가로60mm×세로80mm 면적단가 (라이브 siz SIZ_000371 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row113 comp_price_id=1476
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1476, 'COMP_ACRYL_MIRROR3T', '2026-06-01', 'SIZ_000043', NULL, NULL, NULL, NULL, NULL, 17800, '미러아크릴3T(투명3T×2 파생) 가로80mm×세로80mm 면적단가 (라이브 siz SIZ_000043 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row114 comp_price_id=1478
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1478, 'COMP_ACRYL_MIRROR3T', '2026-06-01', 'SIZ_000248', NULL, NULL, NULL, NULL, NULL, 21200, '미러아크릴3T(투명3T×2 파생) 가로100mm×세로80mm 면적단가 (라이브 siz SIZ_000248 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row115 comp_price_id=1482
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1482, 'COMP_ACRYL_MIRROR3T', '2026-06-01', 'SIZ_000132', NULL, NULL, NULL, NULL, NULL, 13800, '미러아크릴3T(투명3T×2 파생) 가로50mm×세로90mm 면적단가 (라이브 siz SIZ_000132 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row116 comp_price_id=1483
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1483, 'COMP_ACRYL_MIRROR3T', '2026-06-01', 'SIZ_000372', NULL, NULL, NULL, NULL, NULL, 15600, '미러아크릴3T(투명3T×2 파생) 가로60mm×세로90mm 면적단가 (라이브 siz SIZ_000372 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row117 comp_price_id=1486
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1486, 'COMP_ACRYL_MIRROR3T', '2026-06-01', 'SIZ_000119', NULL, NULL, NULL, NULL, NULL, 21400, '미러아크릴3T(투명3T×2 파생) 가로90mm×세로90mm 면적단가 (라이브 siz SIZ_000119 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row118 comp_price_id=1487
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1487, 'COMP_ACRYL_MIRROR3T', '2026-06-01', 'SIZ_000017', NULL, NULL, NULL, NULL, NULL, 23400, '미러아크릴3T(투명3T×2 파생) 가로100mm×세로90mm 면적단가 (라이브 siz SIZ_000017 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row119 comp_price_id=1492
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1492, 'COMP_ACRYL_MIRROR3T', '2026-06-01', 'SIZ_000373', NULL, NULL, NULL, NULL, NULL, 17000, '미러아크릴3T(투명3T×2 파생) 가로60mm×세로100mm 면적단가 (라이브 siz SIZ_000373 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row120 comp_price_id=1493
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1493, 'COMP_ACRYL_MIRROR3T', '2026-06-01', 'SIZ_000448', NULL, NULL, NULL, NULL, NULL, 19000, '미러아크릴3T(투명3T×2 파생) 가로70mm×세로100mm 면적단가 (라이브 siz SIZ_000448 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row121 comp_price_id=1495
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1495, 'COMP_ACRYL_MIRROR3T', '2026-06-01', 'SIZ_000018', NULL, NULL, NULL, NULL, NULL, 23400, '미러아크릴3T(투명3T×2 파생) 가로90mm×세로100mm 면적단가 (라이브 siz SIZ_000018 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row122 comp_price_id=1496
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1496, 'COMP_ACRYL_MIRROR3T', '2026-06-01', 'SIZ_000113', NULL, NULL, NULL, NULL, NULL, 25400, '미러아크릴3T(투명3T×2 파생) 가로100mm×세로100mm 면적단가 (라이브 siz SIZ_000113 실코드, M-1정정 DIRECT매칭)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row123 comp_price_id=1497
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1497, 'COMP_PP_CORNER_RIGHT', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1, 0, '모서리/직각모서리 제작수량≥1 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row124 comp_price_id=1498
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1498, 'COMP_PP_CORNER_ROUND', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1, 2000, '모서리/둥근모서리 제작수량≥1 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row125 comp_price_id=1499
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1499, 'COMP_PP_CORNER_RIGHT', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 100, 0, '모서리/직각모서리 제작수량≥100 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row126 comp_price_id=1500
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1500, 'COMP_PP_CORNER_ROUND', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 100, 2000, '모서리/둥근모서리 제작수량≥100 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row127 comp_price_id=1501
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1501, 'COMP_PP_CORNER_RIGHT', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 300, 0, '모서리/직각모서리 제작수량≥300 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row128 comp_price_id=1502
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1502, 'COMP_PP_CORNER_ROUND', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 300, 4000, '모서리/둥근모서리 제작수량≥300 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row129 comp_price_id=1503
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1503, 'COMP_PP_CORNER_RIGHT', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 500, 0, '모서리/직각모서리 제작수량≥500 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row130 comp_price_id=1504
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1504, 'COMP_PP_CORNER_ROUND', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 500, 6000, '모서리/둥근모서리 제작수량≥500 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row131 comp_price_id=1505
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1505, 'COMP_PP_CORNER_RIGHT', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1000, 0, '모서리/직각모서리 제작수량≥1000 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row132 comp_price_id=1506
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1506, 'COMP_PP_CORNER_ROUND', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1000, 11000, '모서리/둥근모서리 제작수량≥1000 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row133 comp_price_id=1507
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1507, 'COMP_PP_CORNER_RIGHT', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 2000, 0, '모서리/직각모서리 제작수량≥2000 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row134 comp_price_id=1508
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1508, 'COMP_PP_CORNER_ROUND', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 2000, 21000, '모서리/둥근모서리 제작수량≥2000 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row135 comp_price_id=1509
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1509, 'COMP_PP_CORNER_RIGHT', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 3000, 0, '모서리/직각모서리 제작수량≥3000 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row136 comp_price_id=1510
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1510, 'COMP_PP_CORNER_ROUND', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 3000, 31000, '모서리/둥근모서리 제작수량≥3000 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row137 comp_price_id=1511
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1511, 'COMP_PP_CORNER_RIGHT', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 4000, 0, '모서리/직각모서리 제작수량≥4000 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row138 comp_price_id=1512
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1512, 'COMP_PP_CORNER_ROUND', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 4000, 41000, '모서리/둥근모서리 제작수량≥4000 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row139 comp_price_id=1513
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1513, 'COMP_PP_CORNER_RIGHT', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 5000, 0, '모서리/직각모서리 제작수량≥5000 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row140 comp_price_id=1514
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1514, 'COMP_PP_CORNER_ROUND', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 5000, 51000, '모서리/둥근모서리 제작수량≥5000 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row141 comp_price_id=1515
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1515, 'COMP_PP_CREASE_1L', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1, 5000, '오시/1줄 제작수량≥1 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row142 comp_price_id=1516
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1516, 'COMP_PP_CREASE_2L', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1, 6000, '오시/2줄 제작수량≥1 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row143 comp_price_id=1517
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1517, 'COMP_PP_CREASE_3L', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1, 7000, '오시/3줄 제작수량≥1 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row144 comp_price_id=1518
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1518, 'COMP_PP_PERF_1L', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1, 5000, '미싱/1줄 제작수량≥1 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row145 comp_price_id=1519
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1519, 'COMP_PP_PERF_2L', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1, 6000, '미싱/2줄 제작수량≥1 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row146 comp_price_id=1520
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1520, 'COMP_PP_PERF_3L', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1, 7000, '미싱/3줄 제작수량≥1 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row147 comp_price_id=1521
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1521, 'COMP_PP_CREASE_1L', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 50, 5000, '오시/1줄 제작수량≥50 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row148 comp_price_id=1522
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1522, 'COMP_PP_CREASE_2L', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 50, 6000, '오시/2줄 제작수량≥50 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row149 comp_price_id=1523
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1523, 'COMP_PP_CREASE_3L', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 50, 7000, '오시/3줄 제작수량≥50 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row150 comp_price_id=1524
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1524, 'COMP_PP_PERF_1L', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 50, 5000, '미싱/1줄 제작수량≥50 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row151 comp_price_id=1525
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1525, 'COMP_PP_PERF_2L', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 50, 6000, '미싱/2줄 제작수량≥50 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row152 comp_price_id=1526
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1526, 'COMP_PP_PERF_3L', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 50, 7000, '미싱/3줄 제작수량≥50 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row153 comp_price_id=1527
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1527, 'COMP_PP_CREASE_1L', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 100, 10000, '오시/1줄 제작수량≥100 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row154 comp_price_id=1528
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1528, 'COMP_PP_CREASE_2L', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 100, 12000, '오시/2줄 제작수량≥100 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row155 comp_price_id=1529
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1529, 'COMP_PP_CREASE_3L', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 100, 14000, '오시/3줄 제작수량≥100 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row156 comp_price_id=1530
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1530, 'COMP_PP_PERF_1L', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 100, 10000, '미싱/1줄 제작수량≥100 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row157 comp_price_id=1531
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1531, 'COMP_PP_PERF_2L', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 100, 12000, '미싱/2줄 제작수량≥100 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row158 comp_price_id=1532
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1532, 'COMP_PP_PERF_3L', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 100, 14000, '미싱/3줄 제작수량≥100 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row159 comp_price_id=1533
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1533, 'COMP_PP_CREASE_1L', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 300, 15000, '오시/1줄 제작수량≥300 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row160 comp_price_id=1534
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1534, 'COMP_PP_CREASE_2L', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 300, 17000, '오시/2줄 제작수량≥300 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row161 comp_price_id=1535
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1535, 'COMP_PP_CREASE_3L', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 300, 19000, '오시/3줄 제작수량≥300 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row162 comp_price_id=1536
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1536, 'COMP_PP_PERF_1L', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 300, 15000, '미싱/1줄 제작수량≥300 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row163 comp_price_id=1537
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1537, 'COMP_PP_PERF_2L', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 300, 17000, '미싱/2줄 제작수량≥300 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row164 comp_price_id=1538
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1538, 'COMP_PP_PERF_3L', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 300, 19000, '미싱/3줄 제작수량≥300 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row165 comp_price_id=1539
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1539, 'COMP_PP_CREASE_1L', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 500, 17000, '오시/1줄 제작수량≥500 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row166 comp_price_id=1540
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1540, 'COMP_PP_CREASE_2L', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 500, 19000, '오시/2줄 제작수량≥500 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row167 comp_price_id=1541
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1541, 'COMP_PP_CREASE_3L', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 500, 21000, '오시/3줄 제작수량≥500 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row168 comp_price_id=1542
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1542, 'COMP_PP_PERF_1L', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 500, 17000, '미싱/1줄 제작수량≥500 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row169 comp_price_id=1543
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1543, 'COMP_PP_PERF_2L', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 500, 19000, '미싱/2줄 제작수량≥500 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row170 comp_price_id=1544
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1544, 'COMP_PP_PERF_3L', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 500, 21000, '미싱/3줄 제작수량≥500 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row171 comp_price_id=1545
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1545, 'COMP_PP_CREASE_1L', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1000, 25000, '오시/1줄 제작수량≥1000 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row172 comp_price_id=1546
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1546, 'COMP_PP_CREASE_2L', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1000, 29000, '오시/2줄 제작수량≥1000 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row173 comp_price_id=1547
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1547, 'COMP_PP_CREASE_3L', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1000, 33000, '오시/3줄 제작수량≥1000 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row174 comp_price_id=1548
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1548, 'COMP_PP_PERF_1L', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1000, 25000, '미싱/1줄 제작수량≥1000 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row175 comp_price_id=1549
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1549, 'COMP_PP_PERF_2L', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1000, 29000, '미싱/2줄 제작수량≥1000 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row176 comp_price_id=1550
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1550, 'COMP_PP_PERF_3L', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1000, 33000, '미싱/3줄 제작수량≥1000 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row177 comp_price_id=1551
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1551, 'COMP_PP_CREASE_1L', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 2000, 45000, '오시/1줄 제작수량≥2000 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row178 comp_price_id=1552
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1552, 'COMP_PP_CREASE_2L', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 2000, 49000, '오시/2줄 제작수량≥2000 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row179 comp_price_id=1553
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1553, 'COMP_PP_CREASE_3L', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 2000, 53000, '오시/3줄 제작수량≥2000 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row180 comp_price_id=1554
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1554, 'COMP_PP_PERF_1L', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 2000, 45000, '미싱/1줄 제작수량≥2000 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row181 comp_price_id=1555
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1555, 'COMP_PP_PERF_2L', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 2000, 49000, '미싱/2줄 제작수량≥2000 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row182 comp_price_id=1556
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1556, 'COMP_PP_PERF_3L', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 2000, 53000, '미싱/3줄 제작수량≥2000 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row183 comp_price_id=1557
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1557, 'COMP_PP_CREASE_1L', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 3000, 65000, '오시/1줄 제작수량≥3000 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row184 comp_price_id=1558
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1558, 'COMP_PP_CREASE_2L', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 3000, 69000, '오시/2줄 제작수량≥3000 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row185 comp_price_id=1559
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1559, 'COMP_PP_CREASE_3L', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 3000, 73000, '오시/3줄 제작수량≥3000 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row186 comp_price_id=1560
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1560, 'COMP_PP_PERF_1L', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 3000, 65000, '미싱/1줄 제작수량≥3000 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row187 comp_price_id=1561
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1561, 'COMP_PP_PERF_2L', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 3000, 69000, '미싱/2줄 제작수량≥3000 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row188 comp_price_id=1562
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1562, 'COMP_PP_PERF_3L', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 3000, 73000, '미싱/3줄 제작수량≥3000 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row189 comp_price_id=1563
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1563, 'COMP_PP_CREASE_1L', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 4000, 85000, '오시/1줄 제작수량≥4000 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row190 comp_price_id=1564
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1564, 'COMP_PP_CREASE_2L', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 4000, 89000, '오시/2줄 제작수량≥4000 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row191 comp_price_id=1565
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1565, 'COMP_PP_CREASE_3L', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 4000, 93000, '오시/3줄 제작수량≥4000 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row192 comp_price_id=1566
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1566, 'COMP_PP_PERF_1L', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 4000, 85000, '미싱/1줄 제작수량≥4000 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row193 comp_price_id=1567
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1567, 'COMP_PP_PERF_2L', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 4000, 89000, '미싱/2줄 제작수량≥4000 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row194 comp_price_id=1568
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1568, 'COMP_PP_PERF_3L', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 4000, 93000, '미싱/3줄 제작수량≥4000 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row195 comp_price_id=1569
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1569, 'COMP_PP_CREASE_1L', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 5000, 105000, '오시/1줄 제작수량≥5000 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row196 comp_price_id=1570
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1570, 'COMP_PP_CREASE_2L', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 5000, 109000, '오시/2줄 제작수량≥5000 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row197 comp_price_id=1571
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1571, 'COMP_PP_CREASE_3L', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 5000, 103000, '오시/3줄 제작수량≥5000 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row198 comp_price_id=1572
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1572, 'COMP_PP_PERF_1L', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 5000, 105000, '미싱/1줄 제작수량≥5000 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row199 comp_price_id=1573
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1573, 'COMP_PP_PERF_2L', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 5000, 109000, '미싱/2줄 제작수량≥5000 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row200 comp_price_id=1574
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1574, 'COMP_PP_PERF_3L', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 5000, 103000, '미싱/3줄 제작수량≥5000 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row201 comp_price_id=1575
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1575, 'COMP_PP_VARTEXT_1EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1, 15000, '가변(텍스트)/1개 제작수량≥1 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row202 comp_price_id=1576
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1576, 'COMP_PP_VARTEXT_2EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1, 20000, '가변(텍스트)/2개 제작수량≥1 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row203 comp_price_id=1577
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1577, 'COMP_PP_VARTEXT_3EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1, 25000, '가변(텍스트)/3개 제작수량≥1 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row204 comp_price_id=1578
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1578, 'COMP_PP_VARIMG_1EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1, 15000, '가변(이미지)/1개 제작수량≥1 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row205 comp_price_id=1579
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1579, 'COMP_PP_VARIMG_2EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1, 20000, '가변(이미지)/2개 제작수량≥1 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row206 comp_price_id=1580
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1580, 'COMP_PP_VARIMG_3EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1, 25000, '가변(이미지)/3개 제작수량≥1 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row207 comp_price_id=1581
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1581, 'COMP_PP_VARTEXT_1EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 100, 15000, '가변(텍스트)/1개 제작수량≥100 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row208 comp_price_id=1582
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1582, 'COMP_PP_VARTEXT_2EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 100, 25000, '가변(텍스트)/2개 제작수량≥100 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row209 comp_price_id=1583
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1583, 'COMP_PP_VARTEXT_3EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 100, 30000, '가변(텍스트)/3개 제작수량≥100 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row210 comp_price_id=1584
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1584, 'COMP_PP_VARIMG_1EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 100, 15000, '가변(이미지)/1개 제작수량≥100 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row211 comp_price_id=1585
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1585, 'COMP_PP_VARIMG_2EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 100, 25000, '가변(이미지)/2개 제작수량≥100 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row212 comp_price_id=1586
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1586, 'COMP_PP_VARIMG_3EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 100, 30000, '가변(이미지)/3개 제작수량≥100 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row213 comp_price_id=1587
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1587, 'COMP_PP_VARTEXT_1EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 400, 15000, '가변(텍스트)/1개 제작수량≥400 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row214 comp_price_id=1588
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1588, 'COMP_PP_VARTEXT_2EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 400, 25000, '가변(텍스트)/2개 제작수량≥400 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row215 comp_price_id=1589
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1589, 'COMP_PP_VARTEXT_3EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 400, 30000, '가변(텍스트)/3개 제작수량≥400 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row216 comp_price_id=1590
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1590, 'COMP_PP_VARIMG_1EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 400, 15000, '가변(이미지)/1개 제작수량≥400 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row217 comp_price_id=1591
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1591, 'COMP_PP_VARIMG_2EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 400, 25000, '가변(이미지)/2개 제작수량≥400 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row218 comp_price_id=1592
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1592, 'COMP_PP_VARIMG_3EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 400, 30000, '가변(이미지)/3개 제작수량≥400 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row219 comp_price_id=1593
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1593, 'COMP_PP_VARTEXT_1EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 600, 20000, '가변(텍스트)/1개 제작수량≥600 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row220 comp_price_id=1594
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1594, 'COMP_PP_VARTEXT_2EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 600, 30000, '가변(텍스트)/2개 제작수량≥600 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row221 comp_price_id=1595
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1595, 'COMP_PP_VARTEXT_3EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 600, 40000, '가변(텍스트)/3개 제작수량≥600 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row222 comp_price_id=1596
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1596, 'COMP_PP_VARIMG_1EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 600, 20000, '가변(이미지)/1개 제작수량≥600 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row223 comp_price_id=1597
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1597, 'COMP_PP_VARIMG_2EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 600, 30000, '가변(이미지)/2개 제작수량≥600 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row224 comp_price_id=1598
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1598, 'COMP_PP_VARIMG_3EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 600, 40000, '가변(이미지)/3개 제작수량≥600 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row225 comp_price_id=1599
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1599, 'COMP_PP_VARTEXT_1EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 800, 20000, '가변(텍스트)/1개 제작수량≥800 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row226 comp_price_id=1600
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1600, 'COMP_PP_VARTEXT_2EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 800, 30000, '가변(텍스트)/2개 제작수량≥800 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row227 comp_price_id=1601
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1601, 'COMP_PP_VARTEXT_3EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 800, 40000, '가변(텍스트)/3개 제작수량≥800 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row228 comp_price_id=1602
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1602, 'COMP_PP_VARIMG_1EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 800, 20000, '가변(이미지)/1개 제작수량≥800 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row229 comp_price_id=1603
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1603, 'COMP_PP_VARIMG_2EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 800, 30000, '가변(이미지)/2개 제작수량≥800 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row230 comp_price_id=1604
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1604, 'COMP_PP_VARIMG_3EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 800, 40000, '가변(이미지)/3개 제작수량≥800 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row231 comp_price_id=1605
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1605, 'COMP_PP_VARTEXT_1EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1000, 25000, '가변(텍스트)/1개 제작수량≥1000 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row232 comp_price_id=1606
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1606, 'COMP_PP_VARTEXT_2EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1000, 35000, '가변(텍스트)/2개 제작수량≥1000 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row233 comp_price_id=1607
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1607, 'COMP_PP_VARTEXT_3EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1000, 45000, '가변(텍스트)/3개 제작수량≥1000 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row234 comp_price_id=1608
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1608, 'COMP_PP_VARIMG_1EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1000, 25000, '가변(이미지)/1개 제작수량≥1000 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row235 comp_price_id=1609
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1609, 'COMP_PP_VARIMG_2EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1000, 35000, '가변(이미지)/2개 제작수량≥1000 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row236 comp_price_id=1610
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1610, 'COMP_PP_VARIMG_3EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1000, 45000, '가변(이미지)/3개 제작수량≥1000 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row237 comp_price_id=1611
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1611, 'COMP_PP_VARTEXT_1EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1500, 30000, '가변(텍스트)/1개 제작수량≥1500 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row238 comp_price_id=1612
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1612, 'COMP_PP_VARTEXT_2EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1500, 45000, '가변(텍스트)/2개 제작수량≥1500 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row239 comp_price_id=1613
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1613, 'COMP_PP_VARTEXT_3EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1500, 51000, '가변(텍스트)/3개 제작수량≥1500 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row240 comp_price_id=1614
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1614, 'COMP_PP_VARIMG_1EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1500, 30000, '가변(이미지)/1개 제작수량≥1500 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row241 comp_price_id=1615
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1615, 'COMP_PP_VARIMG_2EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1500, 45000, '가변(이미지)/2개 제작수량≥1500 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row242 comp_price_id=1616
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1616, 'COMP_PP_VARIMG_3EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1500, 51000, '가변(이미지)/3개 제작수량≥1500 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row243 comp_price_id=1617
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1617, 'COMP_PP_VARTEXT_1EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 2000, 40000, '가변(텍스트)/1개 제작수량≥2000 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row244 comp_price_id=1618
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1618, 'COMP_PP_VARTEXT_2EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 2000, 60000, '가변(텍스트)/2개 제작수량≥2000 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row245 comp_price_id=1619
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1619, 'COMP_PP_VARTEXT_3EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 2000, 68000, '가변(텍스트)/3개 제작수량≥2000 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row246 comp_price_id=1620
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1620, 'COMP_PP_VARIMG_1EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 2000, 40000, '가변(이미지)/1개 제작수량≥2000 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row247 comp_price_id=1621
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1621, 'COMP_PP_VARIMG_2EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 2000, 60000, '가변(이미지)/2개 제작수량≥2000 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row248 comp_price_id=1622
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1622, 'COMP_PP_VARIMG_3EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 2000, 68000, '가변(이미지)/3개 제작수량≥2000 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row249 comp_price_id=1623
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1623, 'COMP_PP_VARTEXT_1EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 2500, 48000, '가변(텍스트)/1개 제작수량≥2500 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row250 comp_price_id=1624
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1624, 'COMP_PP_VARTEXT_2EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 2500, 72000, '가변(텍스트)/2개 제작수량≥2500 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row251 comp_price_id=1625
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1625, 'COMP_PP_VARTEXT_3EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 2500, 81600, '가변(텍스트)/3개 제작수량≥2500 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row252 comp_price_id=1626
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1626, 'COMP_PP_VARIMG_1EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 2500, 48000, '가변(이미지)/1개 제작수량≥2500 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row253 comp_price_id=1627
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1627, 'COMP_PP_VARIMG_2EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 2500, 72000, '가변(이미지)/2개 제작수량≥2500 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row254 comp_price_id=1628
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1628, 'COMP_PP_VARIMG_3EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 2500, 81600, '가변(이미지)/3개 제작수량≥2500 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row255 comp_price_id=1629
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1629, 'COMP_PP_VARTEXT_1EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 3000, 56000, '가변(텍스트)/1개 제작수량≥3000 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row256 comp_price_id=1630
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1630, 'COMP_PP_VARTEXT_2EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 3000, 84000, '가변(텍스트)/2개 제작수량≥3000 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row257 comp_price_id=1631
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1631, 'COMP_PP_VARTEXT_3EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 3000, 95200, '가변(텍스트)/3개 제작수량≥3000 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row258 comp_price_id=1632
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1632, 'COMP_PP_VARIMG_1EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 3000, 56000, '가변(이미지)/1개 제작수량≥3000 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row259 comp_price_id=1633
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1633, 'COMP_PP_VARIMG_2EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 3000, 84000, '가변(이미지)/2개 제작수량≥3000 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row260 comp_price_id=1634
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1634, 'COMP_PP_VARIMG_3EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 3000, 95200, '가변(이미지)/3개 제작수량≥3000 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row261 comp_price_id=1635
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1635, 'COMP_PP_VARTEXT_1EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 3500, 64000, '가변(텍스트)/1개 제작수량≥3500 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row262 comp_price_id=1636
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1636, 'COMP_PP_VARTEXT_2EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 3500, 96000, '가변(텍스트)/2개 제작수량≥3500 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row263 comp_price_id=1637
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1637, 'COMP_PP_VARTEXT_3EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 3500, 108800, '가변(텍스트)/3개 제작수량≥3500 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row264 comp_price_id=1638
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1638, 'COMP_PP_VARIMG_1EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 3500, 64000, '가변(이미지)/1개 제작수량≥3500 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row265 comp_price_id=1639
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1639, 'COMP_PP_VARIMG_2EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 3500, 96000, '가변(이미지)/2개 제작수량≥3500 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row266 comp_price_id=1640
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1640, 'COMP_PP_VARIMG_3EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 3500, 108800, '가변(이미지)/3개 제작수량≥3500 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row267 comp_price_id=1641
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1641, 'COMP_PP_VARTEXT_1EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 4000, 72000, '가변(텍스트)/1개 제작수량≥4000 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row268 comp_price_id=1642
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1642, 'COMP_PP_VARTEXT_2EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 4000, 108000, '가변(텍스트)/2개 제작수량≥4000 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row269 comp_price_id=1643
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1643, 'COMP_PP_VARTEXT_3EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 4000, 122400, '가변(텍스트)/3개 제작수량≥4000 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row270 comp_price_id=1644
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1644, 'COMP_PP_VARIMG_1EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 4000, 72000, '가변(이미지)/1개 제작수량≥4000 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row271 comp_price_id=1645
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1645, 'COMP_PP_VARIMG_2EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 4000, 108000, '가변(이미지)/2개 제작수량≥4000 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row272 comp_price_id=1646
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1646, 'COMP_PP_VARIMG_3EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 4000, 122400, '가변(이미지)/3개 제작수량≥4000 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row273 comp_price_id=1647
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1647, 'COMP_PP_VARTEXT_1EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 4500, 80000, '가변(텍스트)/1개 제작수량≥4500 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row274 comp_price_id=1648
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1648, 'COMP_PP_VARTEXT_2EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 4500, 120000, '가변(텍스트)/2개 제작수량≥4500 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row275 comp_price_id=1649
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1649, 'COMP_PP_VARTEXT_3EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 4500, 136000, '가변(텍스트)/3개 제작수량≥4500 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row276 comp_price_id=1650
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1650, 'COMP_PP_VARIMG_1EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 4500, 80000, '가변(이미지)/1개 제작수량≥4500 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row277 comp_price_id=1651
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1651, 'COMP_PP_VARIMG_2EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 4500, 120000, '가변(이미지)/2개 제작수량≥4500 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row278 comp_price_id=1652
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1652, 'COMP_PP_VARIMG_3EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 4500, 136000, '가변(이미지)/3개 제작수량≥4500 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row279 comp_price_id=1653
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1653, 'COMP_PP_VARTEXT_1EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 5000, 88000, '가변(텍스트)/1개 제작수량≥5000 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row280 comp_price_id=1654
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1654, 'COMP_PP_VARTEXT_2EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 5000, 132000, '가변(텍스트)/2개 제작수량≥5000 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row281 comp_price_id=1655
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1655, 'COMP_PP_VARTEXT_3EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 5000, 149600, '가변(텍스트)/3개 제작수량≥5000 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row282 comp_price_id=1656
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1656, 'COMP_PP_VARIMG_1EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 5000, 88000, '가변(이미지)/1개 제작수량≥5000 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row283 comp_price_id=1657
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1657, 'COMP_PP_VARIMG_2EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 5000, 132000, '가변(이미지)/2개 제작수량≥5000 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row284 comp_price_id=1658
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1658, 'COMP_PP_VARIMG_3EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 5000, 149600, '가변(이미지)/3개 제작수량≥5000 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row285 comp_price_id=1659
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1659, 'COMP_PP_VARTEXT_1EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 5500, 96000, '가변(텍스트)/1개 제작수량≥5500 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row286 comp_price_id=1660
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1660, 'COMP_PP_VARTEXT_2EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 5500, 144000, '가변(텍스트)/2개 제작수량≥5500 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row287 comp_price_id=1661
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1661, 'COMP_PP_VARTEXT_3EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 5500, 163200, '가변(텍스트)/3개 제작수량≥5500 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row288 comp_price_id=1662
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1662, 'COMP_PP_VARIMG_1EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 5500, 96000, '가변(이미지)/1개 제작수량≥5500 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row289 comp_price_id=1663
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1663, 'COMP_PP_VARIMG_2EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 5500, 144000, '가변(이미지)/2개 제작수량≥5500 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row290 comp_price_id=1664
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1664, 'COMP_PP_VARIMG_3EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 5500, 163200, '가변(이미지)/3개 제작수량≥5500 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row291 comp_price_id=1665
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1665, 'COMP_PP_VARTEXT_1EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 6000, 104000, '가변(텍스트)/1개 제작수량≥6000 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row292 comp_price_id=1666
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1666, 'COMP_PP_VARTEXT_2EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 6000, 156000, '가변(텍스트)/2개 제작수량≥6000 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row293 comp_price_id=1667
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1667, 'COMP_PP_VARTEXT_3EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 6000, 176800, '가변(텍스트)/3개 제작수량≥6000 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row294 comp_price_id=1668
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1668, 'COMP_PP_VARIMG_1EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 6000, 104000, '가변(이미지)/1개 제작수량≥6000 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row295 comp_price_id=1669
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1669, 'COMP_PP_VARIMG_2EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 6000, 156000, '가변(이미지)/2개 제작수량≥6000 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row296 comp_price_id=1670
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1670, 'COMP_PP_VARIMG_3EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 6000, 176800, '가변(이미지)/3개 제작수량≥6000 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row297 comp_price_id=1671
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1671, 'COMP_PP_VARTEXT_1EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 6500, 112000, '가변(텍스트)/1개 제작수량≥6500 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row298 comp_price_id=1672
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1672, 'COMP_PP_VARTEXT_2EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 6500, 168000, '가변(텍스트)/2개 제작수량≥6500 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row299 comp_price_id=1673
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1673, 'COMP_PP_VARTEXT_3EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 6500, 190400, '가변(텍스트)/3개 제작수량≥6500 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row300 comp_price_id=1674
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1674, 'COMP_PP_VARIMG_1EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 6500, 112000, '가변(이미지)/1개 제작수량≥6500 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row301 comp_price_id=1675
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1675, 'COMP_PP_VARIMG_2EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 6500, 168000, '가변(이미지)/2개 제작수량≥6500 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row302 comp_price_id=1676
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1676, 'COMP_PP_VARIMG_3EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 6500, 190400, '가변(이미지)/3개 제작수량≥6500 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row303 comp_price_id=1677
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1677, 'COMP_PP_VARTEXT_1EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 7000, 120000, '가변(텍스트)/1개 제작수량≥7000 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row304 comp_price_id=1678
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1678, 'COMP_PP_VARTEXT_2EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 7000, 180000, '가변(텍스트)/2개 제작수량≥7000 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row305 comp_price_id=1679
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1679, 'COMP_PP_VARTEXT_3EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 7000, 204000, '가변(텍스트)/3개 제작수량≥7000 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row306 comp_price_id=1680
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1680, 'COMP_PP_VARIMG_1EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 7000, 120000, '가변(이미지)/1개 제작수량≥7000 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row307 comp_price_id=1681
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1681, 'COMP_PP_VARIMG_2EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 7000, 180000, '가변(이미지)/2개 제작수량≥7000 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row308 comp_price_id=1682
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1682, 'COMP_PP_VARIMG_3EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 7000, 204000, '가변(이미지)/3개 제작수량≥7000 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row309 comp_price_id=1683
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1683, 'COMP_PP_VARTEXT_1EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 7500, 128000, '가변(텍스트)/1개 제작수량≥7500 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row310 comp_price_id=1684
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1684, 'COMP_PP_VARTEXT_2EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 7500, 192000, '가변(텍스트)/2개 제작수량≥7500 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row311 comp_price_id=1685
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1685, 'COMP_PP_VARTEXT_3EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 7500, 217600, '가변(텍스트)/3개 제작수량≥7500 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row312 comp_price_id=1686
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1686, 'COMP_PP_VARIMG_1EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 7500, 128000, '가변(이미지)/1개 제작수량≥7500 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row313 comp_price_id=1687
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1687, 'COMP_PP_VARIMG_2EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 7500, 192000, '가변(이미지)/2개 제작수량≥7500 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row314 comp_price_id=1688
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1688, 'COMP_PP_VARIMG_3EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 7500, 217600, '가변(이미지)/3개 제작수량≥7500 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row315 comp_price_id=1689
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1689, 'COMP_PP_VARTEXT_1EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 8000, 136000, '가변(텍스트)/1개 제작수량≥8000 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row316 comp_price_id=1690
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1690, 'COMP_PP_VARTEXT_2EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 8000, 204000, '가변(텍스트)/2개 제작수량≥8000 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row317 comp_price_id=1691
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1691, 'COMP_PP_VARTEXT_3EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 8000, 231200, '가변(텍스트)/3개 제작수량≥8000 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row318 comp_price_id=1692
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1692, 'COMP_PP_VARIMG_1EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 8000, 136000, '가변(이미지)/1개 제작수량≥8000 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row319 comp_price_id=1693
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1693, 'COMP_PP_VARIMG_2EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 8000, 204000, '가변(이미지)/2개 제작수량≥8000 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row320 comp_price_id=1694
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1694, 'COMP_PP_VARIMG_3EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 8000, 231200, '가변(이미지)/3개 제작수량≥8000 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row321 comp_price_id=1695
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1695, 'COMP_PP_VARTEXT_1EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 8500, 144000, '가변(텍스트)/1개 제작수량≥8500 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row322 comp_price_id=1696
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1696, 'COMP_PP_VARTEXT_2EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 8500, 216000, '가변(텍스트)/2개 제작수량≥8500 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row323 comp_price_id=1697
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1697, 'COMP_PP_VARTEXT_3EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 8500, 244800, '가변(텍스트)/3개 제작수량≥8500 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row324 comp_price_id=1698
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1698, 'COMP_PP_VARIMG_1EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 8500, 144000, '가변(이미지)/1개 제작수량≥8500 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row325 comp_price_id=1699
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1699, 'COMP_PP_VARIMG_2EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 8500, 216000, '가변(이미지)/2개 제작수량≥8500 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row326 comp_price_id=1700
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1700, 'COMP_PP_VARIMG_3EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 8500, 244800, '가변(이미지)/3개 제작수량≥8500 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row327 comp_price_id=1701
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1701, 'COMP_PP_VARTEXT_1EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 9000, 152000, '가변(텍스트)/1개 제작수량≥9000 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row328 comp_price_id=1702
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1702, 'COMP_PP_VARTEXT_2EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 9000, 228000, '가변(텍스트)/2개 제작수량≥9000 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row329 comp_price_id=1703
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1703, 'COMP_PP_VARTEXT_3EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 9000, 258400, '가변(텍스트)/3개 제작수량≥9000 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row330 comp_price_id=1704
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1704, 'COMP_PP_VARIMG_1EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 9000, 152000, '가변(이미지)/1개 제작수량≥9000 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row331 comp_price_id=1705
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1705, 'COMP_PP_VARIMG_2EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 9000, 228000, '가변(이미지)/2개 제작수량≥9000 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row332 comp_price_id=1706
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1706, 'COMP_PP_VARIMG_3EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 9000, 258400, '가변(이미지)/3개 제작수량≥9000 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row333 comp_price_id=1707
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1707, 'COMP_PP_VARTEXT_1EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 9500, 160000, '가변(텍스트)/1개 제작수량≥9500 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row334 comp_price_id=1708
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1708, 'COMP_PP_VARTEXT_2EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 9500, 240000, '가변(텍스트)/2개 제작수량≥9500 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row335 comp_price_id=1709
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1709, 'COMP_PP_VARTEXT_3EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 9500, 272000, '가변(텍스트)/3개 제작수량≥9500 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row336 comp_price_id=1710
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1710, 'COMP_PP_VARIMG_1EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 9500, 160000, '가변(이미지)/1개 제작수량≥9500 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row337 comp_price_id=1711
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1711, 'COMP_PP_VARIMG_2EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 9500, 240000, '가변(이미지)/2개 제작수량≥9500 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row338 comp_price_id=1712
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1712, 'COMP_PP_VARIMG_3EA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 9500, 272000, '가변(이미지)/3개 제작수량≥9500 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row339 comp_price_id=1753
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1753, 'COMP_FOLD_CARD_2H', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1, 5000, '카드접지/2단 제작수량≥1 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 2단가로접지 / 2단세로접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row340 comp_price_id=1754
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1754, 'COMP_FOLD_CARD_3H', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1, 6000, '카드접지/3단 제작수량≥1 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 3단가로접지 / 3단세로접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row341 comp_price_id=1755
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1755, 'COMP_FOLD_CARD_6CR', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1, 6000, '카드접지/6단 제작수량≥1 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 6단오시접지 / 6단미싱접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row342 comp_price_id=1756
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1756, 'COMP_FOLD_CARD_2H', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 2, 3000, '카드접지/2단 제작수량≥2 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 2단가로접지 / 2단세로접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row343 comp_price_id=1757
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1757, 'COMP_FOLD_CARD_3H', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 2, 4000, '카드접지/3단 제작수량≥2 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 3단가로접지 / 3단세로접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row344 comp_price_id=1758
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1758, 'COMP_FOLD_CARD_6CR', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 2, 5600, '카드접지/6단 제작수량≥2 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 6단오시접지 / 6단미싱접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row345 comp_price_id=1759
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1759, 'COMP_FOLD_CARD_2H', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 3, 2000, '카드접지/2단 제작수량≥3 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 2단가로접지 / 2단세로접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row346 comp_price_id=1760
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1760, 'COMP_FOLD_CARD_3H', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 3, 3000, '카드접지/3단 제작수량≥3 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 3단가로접지 / 3단세로접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row347 comp_price_id=1761
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1761, 'COMP_FOLD_CARD_6CR', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 3, 5100, '카드접지/6단 제작수량≥3 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 6단오시접지 / 6단미싱접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row348 comp_price_id=1762
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1762, 'COMP_FOLD_CARD_2H', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 4, 1500, '카드접지/2단 제작수량≥4 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 2단가로접지 / 2단세로접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row349 comp_price_id=1763
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1763, 'COMP_FOLD_CARD_3H', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 4, 2000, '카드접지/3단 제작수량≥4 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 3단가로접지 / 3단세로접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row350 comp_price_id=1764
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1764, 'COMP_FOLD_CARD_6CR', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 4, 4600, '카드접지/6단 제작수량≥4 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 6단오시접지 / 6단미싱접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row351 comp_price_id=1765
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1765, 'COMP_FOLD_CARD_2H', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 5, 1000, '카드접지/2단 제작수량≥5 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 2단가로접지 / 2단세로접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row352 comp_price_id=1766
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1766, 'COMP_FOLD_CARD_3H', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 5, 1500, '카드접지/3단 제작수량≥5 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 3단가로접지 / 3단세로접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row353 comp_price_id=1767
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1767, 'COMP_FOLD_CARD_6CR', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 5, 4000, '카드접지/6단 제작수량≥5 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 6단오시접지 / 6단미싱접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row354 comp_price_id=1768
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1768, 'COMP_FOLD_CARD_2H', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 6, 900, '카드접지/2단 제작수량≥6 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 2단가로접지 / 2단세로접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row355 comp_price_id=1769
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1769, 'COMP_FOLD_CARD_3H', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 6, 1400, '카드접지/3단 제작수량≥6 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 3단가로접지 / 3단세로접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row356 comp_price_id=1770
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1770, 'COMP_FOLD_CARD_6CR', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 6, 3500, '카드접지/6단 제작수량≥6 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 6단오시접지 / 6단미싱접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row357 comp_price_id=1771
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1771, 'COMP_FOLD_CARD_2H', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 7, 900, '카드접지/2단 제작수량≥7 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 2단가로접지 / 2단세로접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row358 comp_price_id=1772
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1772, 'COMP_FOLD_CARD_3H', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 7, 1300, '카드접지/3단 제작수량≥7 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 3단가로접지 / 3단세로접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row359 comp_price_id=1773
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1773, 'COMP_FOLD_CARD_6CR', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 7, 3000, '카드접지/6단 제작수량≥7 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 6단오시접지 / 6단미싱접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row360 comp_price_id=1774
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1774, 'COMP_FOLD_CARD_2H', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 8, 800, '카드접지/2단 제작수량≥8 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 2단가로접지 / 2단세로접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row361 comp_price_id=1775
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1775, 'COMP_FOLD_CARD_3H', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 8, 1100, '카드접지/3단 제작수량≥8 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 3단가로접지 / 3단세로접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row362 comp_price_id=1776
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1776, 'COMP_FOLD_CARD_6CR', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 8, 2500, '카드접지/6단 제작수량≥8 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 6단오시접지 / 6단미싱접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row363 comp_price_id=1777
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1777, 'COMP_FOLD_CARD_2H', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 9, 800, '카드접지/2단 제작수량≥9 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 2단가로접지 / 2단세로접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row364 comp_price_id=1778
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1778, 'COMP_FOLD_CARD_3H', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 9, 1000, '카드접지/3단 제작수량≥9 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 3단가로접지 / 3단세로접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row365 comp_price_id=1779
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1779, 'COMP_FOLD_CARD_6CR', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 9, 2000, '카드접지/6단 제작수량≥9 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 6단오시접지 / 6단미싱접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row366 comp_price_id=1780
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1780, 'COMP_FOLD_CARD_2H', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 10, 700, '카드접지/2단 제작수량≥10 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 2단가로접지 / 2단세로접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row367 comp_price_id=1781
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1781, 'COMP_FOLD_CARD_3H', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 10, 800, '카드접지/3단 제작수량≥10 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 3단가로접지 / 3단세로접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row368 comp_price_id=1782
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1782, 'COMP_FOLD_CARD_6CR', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 10, 1500, '카드접지/6단 제작수량≥10 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 6단오시접지 / 6단미싱접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row369 comp_price_id=1783
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1783, 'COMP_FOLD_CARD_2H', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 15, 650, '카드접지/2단 제작수량≥15 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 2단가로접지 / 2단세로접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row370 comp_price_id=1784
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1784, 'COMP_FOLD_CARD_3H', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 15, 750, '카드접지/3단 제작수량≥15 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 3단가로접지 / 3단세로접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row371 comp_price_id=1785
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1785, 'COMP_FOLD_CARD_6CR', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 15, 1375, '카드접지/6단 제작수량≥15 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 6단오시접지 / 6단미싱접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row372 comp_price_id=1786
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1786, 'COMP_FOLD_CARD_2H', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 20, 600, '카드접지/2단 제작수량≥20 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 2단가로접지 / 2단세로접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row373 comp_price_id=1787
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1787, 'COMP_FOLD_CARD_3H', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 20, 700, '카드접지/3단 제작수량≥20 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 3단가로접지 / 3단세로접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row374 comp_price_id=1788
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1788, 'COMP_FOLD_CARD_6CR', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 20, 1250, '카드접지/6단 제작수량≥20 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 6단오시접지 / 6단미싱접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row375 comp_price_id=1789
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1789, 'COMP_FOLD_CARD_2H', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 25, 550, '카드접지/2단 제작수량≥25 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 2단가로접지 / 2단세로접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row376 comp_price_id=1790
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1790, 'COMP_FOLD_CARD_3H', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 25, 650, '카드접지/3단 제작수량≥25 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 3단가로접지 / 3단세로접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row377 comp_price_id=1791
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1791, 'COMP_FOLD_CARD_6CR', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 25, 1125, '카드접지/6단 제작수량≥25 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 6단오시접지 / 6단미싱접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row378 comp_price_id=1792
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1792, 'COMP_FOLD_CARD_2H', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 30, 500, '카드접지/2단 제작수량≥30 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 2단가로접지 / 2단세로접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row379 comp_price_id=1793
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1793, 'COMP_FOLD_CARD_3H', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 30, 600, '카드접지/3단 제작수량≥30 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 3단가로접지 / 3단세로접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row380 comp_price_id=1794
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1794, 'COMP_FOLD_CARD_6CR', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 30, 1000, '카드접지/6단 제작수량≥30 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 6단오시접지 / 6단미싱접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row381 comp_price_id=1795
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1795, 'COMP_FOLD_CARD_2H', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 35, 480, '카드접지/2단 제작수량≥35 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 2단가로접지 / 2단세로접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row382 comp_price_id=1796
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1796, 'COMP_FOLD_CARD_3H', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 35, 570, '카드접지/3단 제작수량≥35 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 3단가로접지 / 3단세로접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row383 comp_price_id=1797
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1797, 'COMP_FOLD_CARD_6CR', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 35, 875, '카드접지/6단 제작수량≥35 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 6단오시접지 / 6단미싱접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row384 comp_price_id=1798
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1798, 'COMP_FOLD_CARD_2H', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 40, 460, '카드접지/2단 제작수량≥40 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 2단가로접지 / 2단세로접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row385 comp_price_id=1799
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1799, 'COMP_FOLD_CARD_3H', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 40, 540, '카드접지/3단 제작수량≥40 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 3단가로접지 / 3단세로접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row386 comp_price_id=1800
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1800, 'COMP_FOLD_CARD_6CR', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 40, 750, '카드접지/6단 제작수량≥40 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 6단오시접지 / 6단미싱접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row387 comp_price_id=1801
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1801, 'COMP_FOLD_CARD_2H', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 45, 440, '카드접지/2단 제작수량≥45 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 2단가로접지 / 2단세로접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row388 comp_price_id=1802
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1802, 'COMP_FOLD_CARD_3H', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 45, 510, '카드접지/3단 제작수량≥45 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 3단가로접지 / 3단세로접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row389 comp_price_id=1803
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1803, 'COMP_FOLD_CARD_6CR', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 45, 625, '카드접지/6단 제작수량≥45 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 6단오시접지 / 6단미싱접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row390 comp_price_id=1804
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1804, 'COMP_FOLD_CARD_2H', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 50, 420, '카드접지/2단 제작수량≥50 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 2단가로접지 / 2단세로접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row391 comp_price_id=1805
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1805, 'COMP_FOLD_CARD_3H', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 50, 480, '카드접지/3단 제작수량≥50 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 3단가로접지 / 3단세로접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row392 comp_price_id=1806
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1806, 'COMP_FOLD_CARD_6CR', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 50, 500, '카드접지/6단 제작수량≥50 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 6단오시접지 / 6단미싱접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row393 comp_price_id=1807
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1807, 'COMP_FOLD_CARD_2H', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 60, 390, '카드접지/2단 제작수량≥60 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 2단가로접지 / 2단세로접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row394 comp_price_id=1808
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1808, 'COMP_FOLD_CARD_3H', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 60, 450, '카드접지/3단 제작수량≥60 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 3단가로접지 / 3단세로접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row395 comp_price_id=1809
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1809, 'COMP_FOLD_CARD_6CR', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 60, 460, '카드접지/6단 제작수량≥60 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 6단오시접지 / 6단미싱접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row396 comp_price_id=1810
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1810, 'COMP_FOLD_CARD_2H', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 70, 360, '카드접지/2단 제작수량≥70 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 2단가로접지 / 2단세로접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row397 comp_price_id=1811
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1811, 'COMP_FOLD_CARD_3H', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 70, 420, '카드접지/3단 제작수량≥70 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 3단가로접지 / 3단세로접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row398 comp_price_id=1812
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1812, 'COMP_FOLD_CARD_6CR', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 70, 420, '카드접지/6단 제작수량≥70 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 6단오시접지 / 6단미싱접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row399 comp_price_id=1813
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1813, 'COMP_FOLD_CARD_2H', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 80, 330, '카드접지/2단 제작수량≥80 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 2단가로접지 / 2단세로접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row400 comp_price_id=1814
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1814, 'COMP_FOLD_CARD_3H', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 80, 390, '카드접지/3단 제작수량≥80 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 3단가로접지 / 3단세로접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row401 comp_price_id=1815
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1815, 'COMP_FOLD_CARD_6CR', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 80, 380, '카드접지/6단 제작수량≥80 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 6단오시접지 / 6단미싱접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row402 comp_price_id=1816
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1816, 'COMP_FOLD_CARD_2H', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 90, 300, '카드접지/2단 제작수량≥90 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 2단가로접지 / 2단세로접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row403 comp_price_id=1817
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1817, 'COMP_FOLD_CARD_3H', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 90, 360, '카드접지/3단 제작수량≥90 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 3단가로접지 / 3단세로접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row404 comp_price_id=1818
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1818, 'COMP_FOLD_CARD_6CR', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 90, 340, '카드접지/6단 제작수량≥90 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 6단오시접지 / 6단미싱접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row405 comp_price_id=1819
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1819, 'COMP_FOLD_CARD_2H', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 100, 270, '카드접지/2단 제작수량≥100 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 2단가로접지 / 2단세로접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row406 comp_price_id=1820
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1820, 'COMP_FOLD_CARD_3H', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 100, 330, '카드접지/3단 제작수량≥100 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 3단가로접지 / 3단세로접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row407 comp_price_id=1821
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1821, 'COMP_FOLD_CARD_6CR', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 100, 300, '카드접지/6단 제작수량≥100 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 6단오시접지 / 6단미싱접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row408 comp_price_id=1822
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1822, 'COMP_FOLD_CARD_2H', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 150, 240, '카드접지/2단 제작수량≥150 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 2단가로접지 / 2단세로접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row409 comp_price_id=1823
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1823, 'COMP_FOLD_CARD_3H', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 150, 300, '카드접지/3단 제작수량≥150 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 3단가로접지 / 3단세로접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row410 comp_price_id=1824
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1824, 'COMP_FOLD_CARD_6CR', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 150, 281, '카드접지/6단 제작수량≥150 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 6단오시접지 / 6단미싱접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row411 comp_price_id=1825
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1825, 'COMP_FOLD_CARD_2H', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 200, 210, '카드접지/2단 제작수량≥200 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 2단가로접지 / 2단세로접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row412 comp_price_id=1826
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1826, 'COMP_FOLD_CARD_3H', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 200, 270, '카드접지/3단 제작수량≥200 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 3단가로접지 / 3단세로접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row413 comp_price_id=1827
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1827, 'COMP_FOLD_CARD_6CR', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 200, 262, '카드접지/6단 제작수량≥200 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 6단오시접지 / 6단미싱접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row414 comp_price_id=1828
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1828, 'COMP_FOLD_CARD_2H', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 250, 180, '카드접지/2단 제작수량≥250 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 2단가로접지 / 2단세로접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row415 comp_price_id=1829
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1829, 'COMP_FOLD_CARD_3H', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 250, 240, '카드접지/3단 제작수량≥250 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 3단가로접지 / 3단세로접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row416 comp_price_id=1830
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1830, 'COMP_FOLD_CARD_6CR', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 250, 243, '카드접지/6단 제작수량≥250 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 6단오시접지 / 6단미싱접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row417 comp_price_id=1831
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1831, 'COMP_FOLD_CARD_2H', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 300, 150, '카드접지/2단 제작수량≥300 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 2단가로접지 / 2단세로접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row418 comp_price_id=1832
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1832, 'COMP_FOLD_CARD_3H', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 300, 210, '카드접지/3단 제작수량≥300 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 3단가로접지 / 3단세로접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row419 comp_price_id=1833
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1833, 'COMP_FOLD_CARD_6CR', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 300, 224, '카드접지/6단 제작수량≥300 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 6단오시접지 / 6단미싱접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row420 comp_price_id=1834
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1834, 'COMP_FOLD_CARD_2H', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 350, 120, '카드접지/2단 제작수량≥350 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 2단가로접지 / 2단세로접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row421 comp_price_id=1835
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1835, 'COMP_FOLD_CARD_3H', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 350, 190, '카드접지/3단 제작수량≥350 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 3단가로접지 / 3단세로접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row422 comp_price_id=1836
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1836, 'COMP_FOLD_CARD_6CR', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 350, 205, '카드접지/6단 제작수량≥350 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 6단오시접지 / 6단미싱접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row423 comp_price_id=1837
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1837, 'COMP_FOLD_CARD_2H', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 400, 100, '카드접지/2단 제작수량≥400 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 2단가로접지 / 2단세로접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row424 comp_price_id=1838
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1838, 'COMP_FOLD_CARD_3H', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 400, 170, '카드접지/3단 제작수량≥400 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 3단가로접지 / 3단세로접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row425 comp_price_id=1839
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1839, 'COMP_FOLD_CARD_6CR', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 400, 186, '카드접지/6단 제작수량≥400 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 6단오시접지 / 6단미싱접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row426 comp_price_id=1840
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1840, 'COMP_FOLD_CARD_2H', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 450, 90, '카드접지/2단 제작수량≥450 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 2단가로접지 / 2단세로접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row427 comp_price_id=1841
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1841, 'COMP_FOLD_CARD_3H', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 450, 160, '카드접지/3단 제작수량≥450 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 3단가로접지 / 3단세로접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row428 comp_price_id=1842
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1842, 'COMP_FOLD_CARD_6CR', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 450, 167, '카드접지/6단 제작수량≥450 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 6단오시접지 / 6단미싱접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row429 comp_price_id=1843
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1843, 'COMP_FOLD_CARD_2H', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 500, 80, '카드접지/2단 제작수량≥500 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 2단가로접지 / 2단세로접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row430 comp_price_id=1844
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1844, 'COMP_FOLD_CARD_3H', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 500, 150, '카드접지/3단 제작수량≥500 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 3단가로접지 / 3단세로접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row431 comp_price_id=1845
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1845, 'COMP_FOLD_CARD_6CR', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 500, 150, '카드접지/6단 제작수량≥500 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 6단오시접지 / 6단미싱접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row432 comp_price_id=1846
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1846, 'COMP_FOLD_CARD_2H', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 600, 75, '카드접지/2단 제작수량≥600 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 2단가로접지 / 2단세로접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row433 comp_price_id=1847
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1847, 'COMP_FOLD_CARD_3H', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 600, 140, '카드접지/3단 제작수량≥600 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 3단가로접지 / 3단세로접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row434 comp_price_id=1848
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1848, 'COMP_FOLD_CARD_6CR', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 600, 139, '카드접지/6단 제작수량≥600 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 6단오시접지 / 6단미싱접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row435 comp_price_id=1849
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1849, 'COMP_FOLD_CARD_2H', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 700, 70, '카드접지/2단 제작수량≥700 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 2단가로접지 / 2단세로접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row436 comp_price_id=1850
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1850, 'COMP_FOLD_CARD_3H', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 700, 130, '카드접지/3단 제작수량≥700 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 3단가로접지 / 3단세로접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row437 comp_price_id=1851
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1851, 'COMP_FOLD_CARD_6CR', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 700, 128, '카드접지/6단 제작수량≥700 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 6단오시접지 / 6단미싱접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row438 comp_price_id=1852
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1852, 'COMP_FOLD_CARD_2H', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 800, 65, '카드접지/2단 제작수량≥800 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 2단가로접지 / 2단세로접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row439 comp_price_id=1853
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1853, 'COMP_FOLD_CARD_3H', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 800, 120, '카드접지/3단 제작수량≥800 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 3단가로접지 / 3단세로접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row440 comp_price_id=1854
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1854, 'COMP_FOLD_CARD_6CR', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 800, 117, '카드접지/6단 제작수량≥800 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 6단오시접지 / 6단미싱접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row441 comp_price_id=1855
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1855, 'COMP_FOLD_CARD_2H', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 900, 60, '카드접지/2단 제작수량≥900 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 2단가로접지 / 2단세로접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row442 comp_price_id=1856
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1856, 'COMP_FOLD_CARD_3H', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 900, 110, '카드접지/3단 제작수량≥900 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 3단가로접지 / 3단세로접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row443 comp_price_id=1857
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1857, 'COMP_FOLD_CARD_6CR', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 900, 106, '카드접지/6단 제작수량≥900 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 6단오시접지 / 6단미싱접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row444 comp_price_id=1858
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1858, 'COMP_FOLD_CARD_2H', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1000, 60, '카드접지/2단 제작수량≥1000 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 2단가로접지 / 2단세로접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row445 comp_price_id=1859
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1859, 'COMP_FOLD_CARD_3H', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1000, 100, '카드접지/3단 제작수량≥1000 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 3단가로접지 / 3단세로접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row446 comp_price_id=1860
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1860, 'COMP_FOLD_CARD_6CR', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1000, 95, '카드접지/6단 제작수량≥1000 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 6단오시접지 / 6단미싱접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row447 comp_price_id=1861
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1861, 'COMP_FOLD_CARD_2H', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1200, 58, '카드접지/2단 제작수량≥1200 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 2단가로접지 / 2단세로접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row448 comp_price_id=1862
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1862, 'COMP_FOLD_CARD_3H', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1200, 95, '카드접지/3단 제작수량≥1200 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 3단가로접지 / 3단세로접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row449 comp_price_id=1863
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1863, 'COMP_FOLD_CARD_6CR', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1200, 93, '카드접지/6단 제작수량≥1200 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 6단오시접지 / 6단미싱접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row450 comp_price_id=1864
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1864, 'COMP_FOLD_CARD_2H', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1400, 56, '카드접지/2단 제작수량≥1400 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 2단가로접지 / 2단세로접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row451 comp_price_id=1865
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1865, 'COMP_FOLD_CARD_3H', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1400, 90, '카드접지/3단 제작수량≥1400 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 3단가로접지 / 3단세로접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row452 comp_price_id=1866
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1866, 'COMP_FOLD_CARD_6CR', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1400, 91, '카드접지/6단 제작수량≥1400 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 6단오시접지 / 6단미싱접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row453 comp_price_id=1867
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1867, 'COMP_FOLD_CARD_2H', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1600, 54, '카드접지/2단 제작수량≥1600 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 2단가로접지 / 2단세로접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row454 comp_price_id=1868
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1868, 'COMP_FOLD_CARD_3H', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1600, 85, '카드접지/3단 제작수량≥1600 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 3단가로접지 / 3단세로접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row455 comp_price_id=1869
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1869, 'COMP_FOLD_CARD_6CR', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1600, 89, '카드접지/6단 제작수량≥1600 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 6단오시접지 / 6단미싱접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row456 comp_price_id=1870
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1870, 'COMP_FOLD_CARD_2H', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1800, 52, '카드접지/2단 제작수량≥1800 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 2단가로접지 / 2단세로접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row457 comp_price_id=1871
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1871, 'COMP_FOLD_CARD_3H', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1800, 80, '카드접지/3단 제작수량≥1800 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 3단가로접지 / 3단세로접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row458 comp_price_id=1872
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1872, 'COMP_FOLD_CARD_6CR', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1800, 87, '카드접지/6단 제작수량≥1800 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 6단오시접지 / 6단미싱접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row459 comp_price_id=1873
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1873, 'COMP_FOLD_CARD_2H', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 2000, 50, '카드접지/2단 제작수량≥2000 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 2단가로접지 / 2단세로접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row460 comp_price_id=1874
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1874, 'COMP_FOLD_CARD_3H', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 2000, 75, '카드접지/3단 제작수량≥2000 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 3단가로접지 / 3단세로접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row461 comp_price_id=1875
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1875, 'COMP_FOLD_CARD_6CR', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 2000, 85, '카드접지/6단 제작수량≥2000 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 6단오시접지 / 6단미싱접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row462 comp_price_id=1876
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1876, 'COMP_FOLD_CARD_2H', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 2500, 48, '카드접지/2단 제작수량≥2500 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 2단가로접지 / 2단세로접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row463 comp_price_id=1877
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1877, 'COMP_FOLD_CARD_3H', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 2500, 70, '카드접지/3단 제작수량≥2500 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 3단가로접지 / 3단세로접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row464 comp_price_id=1878
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1878, 'COMP_FOLD_CARD_6CR', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 2500, 79, '카드접지/6단 제작수량≥2500 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 6단오시접지 / 6단미싱접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row465 comp_price_id=1879
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1879, 'COMP_FOLD_CARD_2H', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 3000, 46, '카드접지/2단 제작수량≥3000 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 2단가로접지 / 2단세로접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row466 comp_price_id=1880
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1880, 'COMP_FOLD_CARD_3H', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 3000, 65, '카드접지/3단 제작수량≥3000 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 3단가로접지 / 3단세로접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row467 comp_price_id=1881
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1881, 'COMP_FOLD_CARD_6CR', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 3000, 73, '카드접지/6단 제작수량≥3000 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 6단오시접지 / 6단미싱접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row468 comp_price_id=1882
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1882, 'COMP_FOLD_CARD_2H', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 3500, 44, '카드접지/2단 제작수량≥3500 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 2단가로접지 / 2단세로접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row469 comp_price_id=1883
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1883, 'COMP_FOLD_CARD_3H', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 3500, 60, '카드접지/3단 제작수량≥3500 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 3단가로접지 / 3단세로접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row470 comp_price_id=1884
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1884, 'COMP_FOLD_CARD_6CR', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 3500, 67, '카드접지/6단 제작수량≥3500 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 6단오시접지 / 6단미싱접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row471 comp_price_id=1885
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1885, 'COMP_FOLD_CARD_2H', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 4000, 42, '카드접지/2단 제작수량≥4000 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 2단가로접지 / 2단세로접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row472 comp_price_id=1886
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1886, 'COMP_FOLD_CARD_3H', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 4000, 55, '카드접지/3단 제작수량≥4000 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 3단가로접지 / 3단세로접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row473 comp_price_id=1887
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1887, 'COMP_FOLD_CARD_6CR', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 4000, 61, '카드접지/6단 제작수량≥4000 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 6단오시접지 / 6단미싱접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row474 comp_price_id=1888
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1888, 'COMP_FOLD_CARD_2H', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 4500, 41, '카드접지/2단 제작수량≥4500 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 2단가로접지 / 2단세로접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row475 comp_price_id=1889
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1889, 'COMP_FOLD_CARD_3H', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 4500, 50, '카드접지/3단 제작수량≥4500 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 3단가로접지 / 3단세로접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row476 comp_price_id=1890
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1890, 'COMP_FOLD_CARD_6CR', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 4500, 56, '카드접지/6단 제작수량≥4500 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 6단오시접지 / 6단미싱접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row477 comp_price_id=1891
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1891, 'COMP_FOLD_CARD_2H', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 5000, 40, '카드접지/2단 제작수량≥5000 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 2단가로접지 / 2단세로접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row478 comp_price_id=1892
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1892, 'COMP_FOLD_CARD_3H', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 5000, 50, '카드접지/3단 제작수량≥5000 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 3단가로접지 / 3단세로접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row479 comp_price_id=1893
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1893, 'COMP_FOLD_CARD_6CR', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 5000, 50, '카드접지/6단 제작수량≥5000 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 6단오시접지 / 6단미싱접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row480 comp_price_id=1894
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1894, 'COMP_FOLD_CARD_2H', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 100000, 40, '카드접지/2단 제작수량≥100000 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 2단가로접지 / 2단세로접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row481 comp_price_id=1895
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1895, 'COMP_FOLD_CARD_3H', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 100000, 50, '카드접지/3단 제작수량≥100000 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 3단가로접지 / 3단세로접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row482 comp_price_id=1896
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1896, 'COMP_FOLD_CARD_6CR', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 100000, 50, '카드접지/6단 제작수량≥100000 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 6단오시접지 / 6단미싱접지]')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row483 comp_price_id=1897
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1897, 'COMP_FOLD_LEAF_HALF', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1, 5000, '리플렛접지/반접지 제작수량≥1 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row484 comp_price_id=1898
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1898, 'COMP_FOLD_LEAF_3FOLD', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1, 6000, '리플렛접지/3단접지 제작수량≥1 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row485 comp_price_id=1899
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1899, 'COMP_FOLD_LEAF_4ACC', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1, 7000, '리플렛접지/4단병풍접지 제작수량≥1 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row486 comp_price_id=1900
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1900, 'COMP_FOLD_LEAF_4GATE', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1, 7000, '리플렛접지/4단대문접지 제작수량≥1 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row487 comp_price_id=1901
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1901, 'COMP_FOLD_LEAF_HALF', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 2, 3000, '리플렛접지/반접지 제작수량≥2 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row488 comp_price_id=1902
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1902, 'COMP_FOLD_LEAF_3FOLD', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 2, 4000, '리플렛접지/3단접지 제작수량≥2 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row489 comp_price_id=1903
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1903, 'COMP_FOLD_LEAF_4ACC', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 2, 5000, '리플렛접지/4단병풍접지 제작수량≥2 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row490 comp_price_id=1904
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1904, 'COMP_FOLD_LEAF_4GATE', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 2, 5000, '리플렛접지/4단대문접지 제작수량≥2 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row491 comp_price_id=1905
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1905, 'COMP_FOLD_LEAF_HALF', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 3, 2000, '리플렛접지/반접지 제작수량≥3 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row492 comp_price_id=1906
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1906, 'COMP_FOLD_LEAF_3FOLD', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 3, 3000, '리플렛접지/3단접지 제작수량≥3 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row493 comp_price_id=1907
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1907, 'COMP_FOLD_LEAF_4ACC', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 3, 4000, '리플렛접지/4단병풍접지 제작수량≥3 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row494 comp_price_id=1908
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1908, 'COMP_FOLD_LEAF_4GATE', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 3, 4000, '리플렛접지/4단대문접지 제작수량≥3 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row495 comp_price_id=1909
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1909, 'COMP_FOLD_LEAF_HALF', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 4, 1500, '리플렛접지/반접지 제작수량≥4 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row496 comp_price_id=1910
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1910, 'COMP_FOLD_LEAF_3FOLD', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 4, 2000, '리플렛접지/3단접지 제작수량≥4 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row497 comp_price_id=1911
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1911, 'COMP_FOLD_LEAF_4ACC', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 4, 3000, '리플렛접지/4단병풍접지 제작수량≥4 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row498 comp_price_id=1912
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1912, 'COMP_FOLD_LEAF_4GATE', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 4, 3000, '리플렛접지/4단대문접지 제작수량≥4 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row499 comp_price_id=1913
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1913, 'COMP_FOLD_LEAF_HALF', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 5, 1000, '리플렛접지/반접지 제작수량≥5 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row500 comp_price_id=1914
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1914, 'COMP_FOLD_LEAF_3FOLD', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 5, 1500, '리플렛접지/3단접지 제작수량≥5 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row501 comp_price_id=1915
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1915, 'COMP_FOLD_LEAF_4ACC', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 5, 2000, '리플렛접지/4단병풍접지 제작수량≥5 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row502 comp_price_id=1916
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1916, 'COMP_FOLD_LEAF_4GATE', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 5, 2000, '리플렛접지/4단대문접지 제작수량≥5 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row503 comp_price_id=1917
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1917, 'COMP_FOLD_LEAF_HALF', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 6, 900, '리플렛접지/반접지 제작수량≥6 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row504 comp_price_id=1918
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1918, 'COMP_FOLD_LEAF_3FOLD', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 6, 1400, '리플렛접지/3단접지 제작수량≥6 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row505 comp_price_id=1919
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1919, 'COMP_FOLD_LEAF_4ACC', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 6, 1900, '리플렛접지/4단병풍접지 제작수량≥6 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row506 comp_price_id=1920
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1920, 'COMP_FOLD_LEAF_4GATE', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 6, 1900, '리플렛접지/4단대문접지 제작수량≥6 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row507 comp_price_id=1921
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1921, 'COMP_FOLD_LEAF_HALF', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 7, 900, '리플렛접지/반접지 제작수량≥7 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row508 comp_price_id=1922
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1922, 'COMP_FOLD_LEAF_3FOLD', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 7, 1300, '리플렛접지/3단접지 제작수량≥7 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row509 comp_price_id=1923
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1923, 'COMP_FOLD_LEAF_4ACC', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 7, 1700, '리플렛접지/4단병풍접지 제작수량≥7 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row510 comp_price_id=1924
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1924, 'COMP_FOLD_LEAF_4GATE', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 7, 1700, '리플렛접지/4단대문접지 제작수량≥7 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row511 comp_price_id=1925
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1925, 'COMP_FOLD_LEAF_HALF', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 8, 800, '리플렛접지/반접지 제작수량≥8 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row512 comp_price_id=1926
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1926, 'COMP_FOLD_LEAF_3FOLD', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 8, 1100, '리플렛접지/3단접지 제작수량≥8 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row513 comp_price_id=1927
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1927, 'COMP_FOLD_LEAF_4ACC', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 8, 1500, '리플렛접지/4단병풍접지 제작수량≥8 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row514 comp_price_id=1928
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1928, 'COMP_FOLD_LEAF_4GATE', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 8, 1500, '리플렛접지/4단대문접지 제작수량≥8 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row515 comp_price_id=1929
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1929, 'COMP_FOLD_LEAF_HALF', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 9, 800, '리플렛접지/반접지 제작수량≥9 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row516 comp_price_id=1930
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1930, 'COMP_FOLD_LEAF_3FOLD', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 9, 1000, '리플렛접지/3단접지 제작수량≥9 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row517 comp_price_id=1931
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1931, 'COMP_FOLD_LEAF_4ACC', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 9, 1300, '리플렛접지/4단병풍접지 제작수량≥9 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row518 comp_price_id=1932
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1932, 'COMP_FOLD_LEAF_4GATE', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 9, 1300, '리플렛접지/4단대문접지 제작수량≥9 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row519 comp_price_id=1933
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1933, 'COMP_FOLD_LEAF_HALF', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 10, 700, '리플렛접지/반접지 제작수량≥10 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row520 comp_price_id=1934
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1934, 'COMP_FOLD_LEAF_3FOLD', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 10, 800, '리플렛접지/3단접지 제작수량≥10 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row521 comp_price_id=1935
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1935, 'COMP_FOLD_LEAF_4ACC', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 10, 1100, '리플렛접지/4단병풍접지 제작수량≥10 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row522 comp_price_id=1936
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1936, 'COMP_FOLD_LEAF_4GATE', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 10, 1100, '리플렛접지/4단대문접지 제작수량≥10 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row523 comp_price_id=1937
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1937, 'COMP_FOLD_LEAF_HALF', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 15, 650, '리플렛접지/반접지 제작수량≥15 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row524 comp_price_id=1938
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1938, 'COMP_FOLD_LEAF_3FOLD', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 15, 750, '리플렛접지/3단접지 제작수량≥15 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row525 comp_price_id=1939
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1939, 'COMP_FOLD_LEAF_4ACC', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 15, 1000, '리플렛접지/4단병풍접지 제작수량≥15 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row526 comp_price_id=1940
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1940, 'COMP_FOLD_LEAF_4GATE', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 15, 1000, '리플렛접지/4단대문접지 제작수량≥15 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row527 comp_price_id=1941
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1941, 'COMP_FOLD_LEAF_HALF', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 20, 600, '리플렛접지/반접지 제작수량≥20 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row528 comp_price_id=1942
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1942, 'COMP_FOLD_LEAF_3FOLD', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 20, 700, '리플렛접지/3단접지 제작수량≥20 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row529 comp_price_id=1943
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1943, 'COMP_FOLD_LEAF_4ACC', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 20, 900, '리플렛접지/4단병풍접지 제작수량≥20 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row530 comp_price_id=1944
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1944, 'COMP_FOLD_LEAF_4GATE', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 20, 900, '리플렛접지/4단대문접지 제작수량≥20 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row531 comp_price_id=1945
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1945, 'COMP_FOLD_LEAF_HALF', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 25, 550, '리플렛접지/반접지 제작수량≥25 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row532 comp_price_id=1946
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1946, 'COMP_FOLD_LEAF_3FOLD', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 25, 650, '리플렛접지/3단접지 제작수량≥25 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row533 comp_price_id=1947
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1947, 'COMP_FOLD_LEAF_4ACC', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 25, 800, '리플렛접지/4단병풍접지 제작수량≥25 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row534 comp_price_id=1948
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1948, 'COMP_FOLD_LEAF_4GATE', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 25, 800, '리플렛접지/4단대문접지 제작수량≥25 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row535 comp_price_id=1949
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1949, 'COMP_FOLD_LEAF_HALF', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 30, 500, '리플렛접지/반접지 제작수량≥30 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row536 comp_price_id=1950
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1950, 'COMP_FOLD_LEAF_3FOLD', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 30, 600, '리플렛접지/3단접지 제작수량≥30 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row537 comp_price_id=1951
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1951, 'COMP_FOLD_LEAF_4ACC', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 30, 700, '리플렛접지/4단병풍접지 제작수량≥30 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row538 comp_price_id=1952
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1952, 'COMP_FOLD_LEAF_4GATE', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 30, 700, '리플렛접지/4단대문접지 제작수량≥30 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row539 comp_price_id=1953
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1953, 'COMP_FOLD_LEAF_HALF', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 35, 480, '리플렛접지/반접지 제작수량≥35 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row540 comp_price_id=1954
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1954, 'COMP_FOLD_LEAF_3FOLD', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 35, 570, '리플렛접지/3단접지 제작수량≥35 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row541 comp_price_id=1955
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1955, 'COMP_FOLD_LEAF_4ACC', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 35, 670, '리플렛접지/4단병풍접지 제작수량≥35 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row542 comp_price_id=1956
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1956, 'COMP_FOLD_LEAF_4GATE', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 35, 670, '리플렛접지/4단대문접지 제작수량≥35 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row543 comp_price_id=1957
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1957, 'COMP_FOLD_LEAF_HALF', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 40, 460, '리플렛접지/반접지 제작수량≥40 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row544 comp_price_id=1958
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1958, 'COMP_FOLD_LEAF_3FOLD', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 40, 540, '리플렛접지/3단접지 제작수량≥40 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row545 comp_price_id=1959
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1959, 'COMP_FOLD_LEAF_4ACC', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 40, 640, '리플렛접지/4단병풍접지 제작수량≥40 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row546 comp_price_id=1960
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1960, 'COMP_FOLD_LEAF_4GATE', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 40, 640, '리플렛접지/4단대문접지 제작수량≥40 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row547 comp_price_id=1961
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1961, 'COMP_FOLD_LEAF_HALF', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 45, 440, '리플렛접지/반접지 제작수량≥45 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row548 comp_price_id=1962
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1962, 'COMP_FOLD_LEAF_3FOLD', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 45, 510, '리플렛접지/3단접지 제작수량≥45 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row549 comp_price_id=1963
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1963, 'COMP_FOLD_LEAF_4ACC', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 45, 610, '리플렛접지/4단병풍접지 제작수량≥45 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row550 comp_price_id=1964
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1964, 'COMP_FOLD_LEAF_4GATE', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 45, 610, '리플렛접지/4단대문접지 제작수량≥45 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row551 comp_price_id=1965
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1965, 'COMP_FOLD_LEAF_HALF', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 50, 420, '리플렛접지/반접지 제작수량≥50 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row552 comp_price_id=1966
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1966, 'COMP_FOLD_LEAF_3FOLD', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 50, 480, '리플렛접지/3단접지 제작수량≥50 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row553 comp_price_id=1967
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1967, 'COMP_FOLD_LEAF_4ACC', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 50, 580, '리플렛접지/4단병풍접지 제작수량≥50 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row554 comp_price_id=1968
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1968, 'COMP_FOLD_LEAF_4GATE', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 50, 580, '리플렛접지/4단대문접지 제작수량≥50 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row555 comp_price_id=1969
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1969, 'COMP_FOLD_LEAF_HALF', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 60, 390, '리플렛접지/반접지 제작수량≥60 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row556 comp_price_id=1970
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1970, 'COMP_FOLD_LEAF_3FOLD', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 60, 450, '리플렛접지/3단접지 제작수량≥60 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row557 comp_price_id=1971
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1971, 'COMP_FOLD_LEAF_4ACC', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 60, 550, '리플렛접지/4단병풍접지 제작수량≥60 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row558 comp_price_id=1972
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1972, 'COMP_FOLD_LEAF_4GATE', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 60, 550, '리플렛접지/4단대문접지 제작수량≥60 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row559 comp_price_id=1973
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1973, 'COMP_FOLD_LEAF_HALF', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 70, 360, '리플렛접지/반접지 제작수량≥70 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row560 comp_price_id=1974
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1974, 'COMP_FOLD_LEAF_3FOLD', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 70, 420, '리플렛접지/3단접지 제작수량≥70 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row561 comp_price_id=1975
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1975, 'COMP_FOLD_LEAF_4ACC', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 70, 520, '리플렛접지/4단병풍접지 제작수량≥70 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row562 comp_price_id=1976
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1976, 'COMP_FOLD_LEAF_4GATE', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 70, 520, '리플렛접지/4단대문접지 제작수량≥70 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row563 comp_price_id=1977
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1977, 'COMP_FOLD_LEAF_HALF', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 80, 330, '리플렛접지/반접지 제작수량≥80 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row564 comp_price_id=1978
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1978, 'COMP_FOLD_LEAF_3FOLD', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 80, 390, '리플렛접지/3단접지 제작수량≥80 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row565 comp_price_id=1979
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1979, 'COMP_FOLD_LEAF_4ACC', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 80, 490, '리플렛접지/4단병풍접지 제작수량≥80 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row566 comp_price_id=1980
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1980, 'COMP_FOLD_LEAF_4GATE', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 80, 490, '리플렛접지/4단대문접지 제작수량≥80 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row567 comp_price_id=1981
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1981, 'COMP_FOLD_LEAF_HALF', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 90, 300, '리플렛접지/반접지 제작수량≥90 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row568 comp_price_id=1982
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1982, 'COMP_FOLD_LEAF_3FOLD', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 90, 360, '리플렛접지/3단접지 제작수량≥90 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row569 comp_price_id=1983
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1983, 'COMP_FOLD_LEAF_4ACC', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 90, 460, '리플렛접지/4단병풍접지 제작수량≥90 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row570 comp_price_id=1984
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1984, 'COMP_FOLD_LEAF_4GATE', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 90, 460, '리플렛접지/4단대문접지 제작수량≥90 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row571 comp_price_id=1985
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1985, 'COMP_FOLD_LEAF_HALF', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 100, 270, '리플렛접지/반접지 제작수량≥100 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row572 comp_price_id=1986
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1986, 'COMP_FOLD_LEAF_3FOLD', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 100, 330, '리플렛접지/3단접지 제작수량≥100 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row573 comp_price_id=1987
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1987, 'COMP_FOLD_LEAF_4ACC', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 100, 430, '리플렛접지/4단병풍접지 제작수량≥100 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row574 comp_price_id=1988
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1988, 'COMP_FOLD_LEAF_4GATE', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 100, 430, '리플렛접지/4단대문접지 제작수량≥100 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row575 comp_price_id=1989
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1989, 'COMP_FOLD_LEAF_HALF', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 150, 240, '리플렛접지/반접지 제작수량≥150 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row576 comp_price_id=1990
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1990, 'COMP_FOLD_LEAF_3FOLD', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 150, 300, '리플렛접지/3단접지 제작수량≥150 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row577 comp_price_id=1991
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1991, 'COMP_FOLD_LEAF_4ACC', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 150, 370, '리플렛접지/4단병풍접지 제작수량≥150 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row578 comp_price_id=1992
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1992, 'COMP_FOLD_LEAF_4GATE', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 150, 370, '리플렛접지/4단대문접지 제작수량≥150 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row579 comp_price_id=1993
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1993, 'COMP_FOLD_LEAF_HALF', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 200, 210, '리플렛접지/반접지 제작수량≥200 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row580 comp_price_id=1994
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1994, 'COMP_FOLD_LEAF_3FOLD', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 200, 270, '리플렛접지/3단접지 제작수량≥200 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row581 comp_price_id=1995
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1995, 'COMP_FOLD_LEAF_4ACC', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 200, 340, '리플렛접지/4단병풍접지 제작수량≥200 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row582 comp_price_id=1996
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1996, 'COMP_FOLD_LEAF_4GATE', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 200, 340, '리플렛접지/4단대문접지 제작수량≥200 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row583 comp_price_id=1997
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1997, 'COMP_FOLD_LEAF_HALF', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 250, 180, '리플렛접지/반접지 제작수량≥250 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row584 comp_price_id=1998
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1998, 'COMP_FOLD_LEAF_3FOLD', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 250, 240, '리플렛접지/3단접지 제작수량≥250 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row585 comp_price_id=1999
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (1999, 'COMP_FOLD_LEAF_4ACC', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 250, 310, '리플렛접지/4단병풍접지 제작수량≥250 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row586 comp_price_id=2000
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2000, 'COMP_FOLD_LEAF_4GATE', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 250, 310, '리플렛접지/4단대문접지 제작수량≥250 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row587 comp_price_id=2001
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2001, 'COMP_FOLD_LEAF_HALF', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 300, 150, '리플렛접지/반접지 제작수량≥300 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row588 comp_price_id=2002
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2002, 'COMP_FOLD_LEAF_3FOLD', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 300, 210, '리플렛접지/3단접지 제작수량≥300 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row589 comp_price_id=2003
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2003, 'COMP_FOLD_LEAF_4ACC', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 300, 280, '리플렛접지/4단병풍접지 제작수량≥300 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row590 comp_price_id=2004
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2004, 'COMP_FOLD_LEAF_4GATE', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 300, 280, '리플렛접지/4단대문접지 제작수량≥300 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row591 comp_price_id=2005
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2005, 'COMP_FOLD_LEAF_HALF', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 350, 120, '리플렛접지/반접지 제작수량≥350 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row592 comp_price_id=2006
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2006, 'COMP_FOLD_LEAF_3FOLD', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 350, 190, '리플렛접지/3단접지 제작수량≥350 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row593 comp_price_id=2007
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2007, 'COMP_FOLD_LEAF_4ACC', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 350, 260, '리플렛접지/4단병풍접지 제작수량≥350 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row594 comp_price_id=2008
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2008, 'COMP_FOLD_LEAF_4GATE', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 350, 260, '리플렛접지/4단대문접지 제작수량≥350 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row595 comp_price_id=2009
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2009, 'COMP_FOLD_LEAF_HALF', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 400, 100, '리플렛접지/반접지 제작수량≥400 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row596 comp_price_id=2010
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2010, 'COMP_FOLD_LEAF_3FOLD', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 400, 170, '리플렛접지/3단접지 제작수량≥400 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row597 comp_price_id=2011
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2011, 'COMP_FOLD_LEAF_4ACC', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 400, 240, '리플렛접지/4단병풍접지 제작수량≥400 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row598 comp_price_id=2012
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2012, 'COMP_FOLD_LEAF_4GATE', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 400, 240, '리플렛접지/4단대문접지 제작수량≥400 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row599 comp_price_id=2013
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2013, 'COMP_FOLD_LEAF_HALF', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 450, 90, '리플렛접지/반접지 제작수량≥450 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row600 comp_price_id=2014
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2014, 'COMP_FOLD_LEAF_3FOLD', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 450, 160, '리플렛접지/3단접지 제작수량≥450 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row601 comp_price_id=2015
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2015, 'COMP_FOLD_LEAF_4ACC', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 450, 220, '리플렛접지/4단병풍접지 제작수량≥450 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row602 comp_price_id=2016
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2016, 'COMP_FOLD_LEAF_4GATE', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 450, 220, '리플렛접지/4단대문접지 제작수량≥450 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row603 comp_price_id=2017
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2017, 'COMP_FOLD_LEAF_HALF', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 500, 80, '리플렛접지/반접지 제작수량≥500 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row604 comp_price_id=2018
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2018, 'COMP_FOLD_LEAF_3FOLD', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 500, 150, '리플렛접지/3단접지 제작수량≥500 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row605 comp_price_id=2019
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2019, 'COMP_FOLD_LEAF_4ACC', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 500, 200, '리플렛접지/4단병풍접지 제작수량≥500 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row606 comp_price_id=2020
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2020, 'COMP_FOLD_LEAF_4GATE', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 500, 200, '리플렛접지/4단대문접지 제작수량≥500 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row607 comp_price_id=2021
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2021, 'COMP_FOLD_LEAF_HALF', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 600, 75, '리플렛접지/반접지 제작수량≥600 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row608 comp_price_id=2022
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2022, 'COMP_FOLD_LEAF_3FOLD', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 600, 140, '리플렛접지/3단접지 제작수량≥600 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row609 comp_price_id=2023
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2023, 'COMP_FOLD_LEAF_4ACC', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 600, 190, '리플렛접지/4단병풍접지 제작수량≥600 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row610 comp_price_id=2024
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2024, 'COMP_FOLD_LEAF_4GATE', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 600, 190, '리플렛접지/4단대문접지 제작수량≥600 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row611 comp_price_id=2025
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2025, 'COMP_FOLD_LEAF_HALF', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 700, 70, '리플렛접지/반접지 제작수량≥700 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row612 comp_price_id=2026
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2026, 'COMP_FOLD_LEAF_3FOLD', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 700, 130, '리플렛접지/3단접지 제작수량≥700 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row613 comp_price_id=2027
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2027, 'COMP_FOLD_LEAF_4ACC', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 700, 180, '리플렛접지/4단병풍접지 제작수량≥700 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row614 comp_price_id=2028
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2028, 'COMP_FOLD_LEAF_4GATE', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 700, 180, '리플렛접지/4단대문접지 제작수량≥700 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row615 comp_price_id=2029
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2029, 'COMP_FOLD_LEAF_HALF', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 800, 65, '리플렛접지/반접지 제작수량≥800 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row616 comp_price_id=2030
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2030, 'COMP_FOLD_LEAF_3FOLD', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 800, 120, '리플렛접지/3단접지 제작수량≥800 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row617 comp_price_id=2031
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2031, 'COMP_FOLD_LEAF_4ACC', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 800, 170, '리플렛접지/4단병풍접지 제작수량≥800 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row618 comp_price_id=2032
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2032, 'COMP_FOLD_LEAF_4GATE', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 800, 170, '리플렛접지/4단대문접지 제작수량≥800 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row619 comp_price_id=2033
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2033, 'COMP_FOLD_LEAF_HALF', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 900, 60, '리플렛접지/반접지 제작수량≥900 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row620 comp_price_id=2034
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2034, 'COMP_FOLD_LEAF_3FOLD', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 900, 110, '리플렛접지/3단접지 제작수량≥900 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row621 comp_price_id=2035
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2035, 'COMP_FOLD_LEAF_4ACC', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 900, 160, '리플렛접지/4단병풍접지 제작수량≥900 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row622 comp_price_id=2036
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2036, 'COMP_FOLD_LEAF_4GATE', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 900, 160, '리플렛접지/4단대문접지 제작수량≥900 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row623 comp_price_id=2037
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2037, 'COMP_FOLD_LEAF_HALF', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1000, 60, '리플렛접지/반접지 제작수량≥1000 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row624 comp_price_id=2038
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2038, 'COMP_FOLD_LEAF_3FOLD', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1000, 100, '리플렛접지/3단접지 제작수량≥1000 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row625 comp_price_id=2039
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2039, 'COMP_FOLD_LEAF_4ACC', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1000, 150, '리플렛접지/4단병풍접지 제작수량≥1000 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row626 comp_price_id=2040
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2040, 'COMP_FOLD_LEAF_4GATE', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1000, 150, '리플렛접지/4단대문접지 제작수량≥1000 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row627 comp_price_id=2041
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2041, 'COMP_FOLD_LEAF_HALF', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1200, 58, '리플렛접지/반접지 제작수량≥1200 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row628 comp_price_id=2042
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2042, 'COMP_FOLD_LEAF_3FOLD', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1200, 95, '리플렛접지/3단접지 제작수량≥1200 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row629 comp_price_id=2043
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2043, 'COMP_FOLD_LEAF_4ACC', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1200, 140, '리플렛접지/4단병풍접지 제작수량≥1200 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row630 comp_price_id=2044
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2044, 'COMP_FOLD_LEAF_4GATE', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1200, 140, '리플렛접지/4단대문접지 제작수량≥1200 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row631 comp_price_id=2045
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2045, 'COMP_FOLD_LEAF_HALF', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1400, 56, '리플렛접지/반접지 제작수량≥1400 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row632 comp_price_id=2046
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2046, 'COMP_FOLD_LEAF_3FOLD', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1400, 90, '리플렛접지/3단접지 제작수량≥1400 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row633 comp_price_id=2047
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2047, 'COMP_FOLD_LEAF_4ACC', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1400, 130, '리플렛접지/4단병풍접지 제작수량≥1400 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row634 comp_price_id=2048
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2048, 'COMP_FOLD_LEAF_4GATE', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1400, 130, '리플렛접지/4단대문접지 제작수량≥1400 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row635 comp_price_id=2049
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2049, 'COMP_FOLD_LEAF_HALF', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1600, 54, '리플렛접지/반접지 제작수량≥1600 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row636 comp_price_id=2050
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2050, 'COMP_FOLD_LEAF_3FOLD', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1600, 85, '리플렛접지/3단접지 제작수량≥1600 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row637 comp_price_id=2051
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2051, 'COMP_FOLD_LEAF_4ACC', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1600, 120, '리플렛접지/4단병풍접지 제작수량≥1600 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row638 comp_price_id=2052
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2052, 'COMP_FOLD_LEAF_4GATE', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1600, 120, '리플렛접지/4단대문접지 제작수량≥1600 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row639 comp_price_id=2053
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2053, 'COMP_FOLD_LEAF_HALF', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1800, 52, '리플렛접지/반접지 제작수량≥1800 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row640 comp_price_id=2054
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2054, 'COMP_FOLD_LEAF_3FOLD', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1800, 80, '리플렛접지/3단접지 제작수량≥1800 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row641 comp_price_id=2055
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2055, 'COMP_FOLD_LEAF_4ACC', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1800, 110, '리플렛접지/4단병풍접지 제작수량≥1800 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row642 comp_price_id=2056
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2056, 'COMP_FOLD_LEAF_4GATE', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1800, 110, '리플렛접지/4단대문접지 제작수량≥1800 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row643 comp_price_id=2057
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2057, 'COMP_FOLD_LEAF_HALF', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 2000, 50, '리플렛접지/반접지 제작수량≥2000 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row644 comp_price_id=2058
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2058, 'COMP_FOLD_LEAF_3FOLD', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 2000, 75, '리플렛접지/3단접지 제작수량≥2000 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row645 comp_price_id=2059
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2059, 'COMP_FOLD_LEAF_4ACC', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 2000, 105, '리플렛접지/4단병풍접지 제작수량≥2000 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row646 comp_price_id=2060
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2060, 'COMP_FOLD_LEAF_4GATE', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 2000, 105, '리플렛접지/4단대문접지 제작수량≥2000 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row647 comp_price_id=2061
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2061, 'COMP_FOLD_LEAF_HALF', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 2500, 48, '리플렛접지/반접지 제작수량≥2500 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row648 comp_price_id=2062
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2062, 'COMP_FOLD_LEAF_3FOLD', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 2500, 70, '리플렛접지/3단접지 제작수량≥2500 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row649 comp_price_id=2063
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2063, 'COMP_FOLD_LEAF_4ACC', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 2500, 100, '리플렛접지/4단병풍접지 제작수량≥2500 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row650 comp_price_id=2064
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2064, 'COMP_FOLD_LEAF_4GATE', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 2500, 100, '리플렛접지/4단대문접지 제작수량≥2500 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row651 comp_price_id=2065
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2065, 'COMP_FOLD_LEAF_HALF', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 3000, 46, '리플렛접지/반접지 제작수량≥3000 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row652 comp_price_id=2066
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2066, 'COMP_FOLD_LEAF_3FOLD', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 3000, 65, '리플렛접지/3단접지 제작수량≥3000 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row653 comp_price_id=2067
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2067, 'COMP_FOLD_LEAF_4ACC', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 3000, 95, '리플렛접지/4단병풍접지 제작수량≥3000 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row654 comp_price_id=2068
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2068, 'COMP_FOLD_LEAF_4GATE', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 3000, 95, '리플렛접지/4단대문접지 제작수량≥3000 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row655 comp_price_id=2069
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2069, 'COMP_FOLD_LEAF_HALF', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 3500, 44, '리플렛접지/반접지 제작수량≥3500 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row656 comp_price_id=2070
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2070, 'COMP_FOLD_LEAF_3FOLD', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 3500, 60, '리플렛접지/3단접지 제작수량≥3500 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row657 comp_price_id=2071
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2071, 'COMP_FOLD_LEAF_4ACC', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 3500, 90, '리플렛접지/4단병풍접지 제작수량≥3500 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row658 comp_price_id=2072
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2072, 'COMP_FOLD_LEAF_4GATE', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 3500, 90, '리플렛접지/4단대문접지 제작수량≥3500 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row659 comp_price_id=2073
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2073, 'COMP_FOLD_LEAF_HALF', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 4000, 42, '리플렛접지/반접지 제작수량≥4000 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row660 comp_price_id=2074
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2074, 'COMP_FOLD_LEAF_3FOLD', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 4000, 55, '리플렛접지/3단접지 제작수량≥4000 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row661 comp_price_id=2075
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2075, 'COMP_FOLD_LEAF_4ACC', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 4000, 85, '리플렛접지/4단병풍접지 제작수량≥4000 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row662 comp_price_id=2076
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2076, 'COMP_FOLD_LEAF_4GATE', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 4000, 85, '리플렛접지/4단대문접지 제작수량≥4000 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row663 comp_price_id=2077
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2077, 'COMP_FOLD_LEAF_HALF', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 4500, 41, '리플렛접지/반접지 제작수량≥4500 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row664 comp_price_id=2078
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2078, 'COMP_FOLD_LEAF_3FOLD', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 4500, 50, '리플렛접지/3단접지 제작수량≥4500 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row665 comp_price_id=2079
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2079, 'COMP_FOLD_LEAF_4ACC', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 4500, 80, '리플렛접지/4단병풍접지 제작수량≥4500 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row666 comp_price_id=2080
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2080, 'COMP_FOLD_LEAF_4GATE', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 4500, 80, '리플렛접지/4단대문접지 제작수량≥4500 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row667 comp_price_id=2081
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2081, 'COMP_FOLD_LEAF_HALF', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 5000, 40, '리플렛접지/반접지 제작수량≥5000 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row668 comp_price_id=2082
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2082, 'COMP_FOLD_LEAF_3FOLD', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 5000, 50, '리플렛접지/3단접지 제작수량≥5000 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row669 comp_price_id=2083
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2083, 'COMP_FOLD_LEAF_4ACC', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 5000, 70, '리플렛접지/4단병풍접지 제작수량≥5000 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row670 comp_price_id=2084
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2084, 'COMP_FOLD_LEAF_4GATE', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 5000, 70, '리플렛접지/4단대문접지 제작수량≥5000 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row671 comp_price_id=2085
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2085, 'COMP_FOLD_LEAF_HALF', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 100000, 40, '리플렛접지/반접지 제작수량≥100000 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row672 comp_price_id=2086
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2086, 'COMP_FOLD_LEAF_3FOLD', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 100000, 50, '리플렛접지/3단접지 제작수량≥100000 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row673 comp_price_id=2087
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2087, 'COMP_FOLD_LEAF_4ACC', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 100000, 65, '리플렛접지/4단병풍접지 제작수량≥100000 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row674 comp_price_id=2088
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2088, 'COMP_FOLD_LEAF_4GATE', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 100000, 65, '리플렛접지/4단대문접지 제작수량≥100000 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row675 comp_price_id=2089
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2089, 'COMP_BIND_JUNGCHEOL', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1, 3000, '제본비/중철제본 수량≥1 (제본비, comp_typ=.04 후가공, 제본종류=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row676 comp_price_id=2090
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2090, 'COMP_BIND_MUSEON', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1, 3000, '제본비/무선제본 수량≥1 (제본비, comp_typ=.04 후가공, 제본종류=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row677 comp_price_id=2091
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2091, 'COMP_BIND_TWINRING', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1, 4000, '제본비/트윈링제본 수량≥1 (제본비, comp_typ=.04 후가공, 제본종류=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row678 comp_price_id=2092
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2092, 'COMP_BIND_PUR', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1, 5000, '제본비/PUR제본 수량≥1 (제본비, comp_typ=.04 후가공, 제본종류=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row679 comp_price_id=2093
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2093, 'COMP_BIND_JUNGCHEOL', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 4, 2000, '제본비/중철제본 수량≥4 (제본비, comp_typ=.04 후가공, 제본종류=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row680 comp_price_id=2094
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2094, 'COMP_BIND_MUSEON', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 4, 2000, '제본비/무선제본 수량≥4 (제본비, comp_typ=.04 후가공, 제본종류=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row681 comp_price_id=2095
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2095, 'COMP_BIND_TWINRING', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 4, 3000, '제본비/트윈링제본 수량≥4 (제본비, comp_typ=.04 후가공, 제본종류=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row682 comp_price_id=2096
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2096, 'COMP_BIND_PUR', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 4, 5000, '제본비/PUR제본 수량≥4 (제본비, comp_typ=.04 후가공, 제본종류=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row683 comp_price_id=2097
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2097, 'COMP_BIND_JUNGCHEOL', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 10, 1500, '제본비/중철제본 수량≥10 (제본비, comp_typ=.04 후가공, 제본종류=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row684 comp_price_id=2098
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2098, 'COMP_BIND_MUSEON', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 10, 1000, '제본비/무선제본 수량≥10 (제본비, comp_typ=.04 후가공, 제본종류=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row685 comp_price_id=2099
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2099, 'COMP_BIND_TWINRING', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 10, 2000, '제본비/트윈링제본 수량≥10 (제본비, comp_typ=.04 후가공, 제본종류=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row686 comp_price_id=2100
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2100, 'COMP_BIND_PUR', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 10, 5000, '제본비/PUR제본 수량≥10 (제본비, comp_typ=.04 후가공, 제본종류=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row687 comp_price_id=2101
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2101, 'COMP_BIND_JUNGCHEOL', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 30, 1000, '제본비/중철제본 수량≥30 (제본비, comp_typ=.04 후가공, 제본종류=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row688 comp_price_id=2102
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2102, 'COMP_BIND_MUSEON', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 30, 700, '제본비/무선제본 수량≥30 (제본비, comp_typ=.04 후가공, 제본종류=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row689 comp_price_id=2103
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2103, 'COMP_BIND_TWINRING', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 30, 1500, '제본비/트윈링제본 수량≥30 (제본비, comp_typ=.04 후가공, 제본종류=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row690 comp_price_id=2104
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2104, 'COMP_BIND_PUR', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 30, 4000, '제본비/PUR제본 수량≥30 (제본비, comp_typ=.04 후가공, 제본종류=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row691 comp_price_id=2105
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2105, 'COMP_BIND_JUNGCHEOL', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 50, 1000, '제본비/중철제본 수량≥50 (제본비, comp_typ=.04 후가공, 제본종류=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row692 comp_price_id=2106
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2106, 'COMP_BIND_MUSEON', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 50, 700, '제본비/무선제본 수량≥50 (제본비, comp_typ=.04 후가공, 제본종류=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row693 comp_price_id=2107
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2107, 'COMP_BIND_TWINRING', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 50, 1500, '제본비/트윈링제본 수량≥50 (제본비, comp_typ=.04 후가공, 제본종류=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row694 comp_price_id=2108
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2108, 'COMP_BIND_PUR', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 50, 3000, '제본비/PUR제본 수량≥50 (제본비, comp_typ=.04 후가공, 제본종류=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row695 comp_price_id=2109
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2109, 'COMP_BIND_JUNGCHEOL', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 70, 700, '제본비/중철제본 수량≥70 (제본비, comp_typ=.04 후가공, 제본종류=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row696 comp_price_id=2110
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2110, 'COMP_BIND_MUSEON', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 70, 500, '제본비/무선제본 수량≥70 (제본비, comp_typ=.04 후가공, 제본종류=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row697 comp_price_id=2111
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2111, 'COMP_BIND_TWINRING', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 70, 1300, '제본비/트윈링제본 수량≥70 (제본비, comp_typ=.04 후가공, 제본종류=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row698 comp_price_id=2112
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2112, 'COMP_BIND_PUR', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 70, 2500, '제본비/PUR제본 수량≥70 (제본비, comp_typ=.04 후가공, 제본종류=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row699 comp_price_id=2113
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2113, 'COMP_BIND_JUNGCHEOL', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 100, 700, '제본비/중철제본 수량≥100 (제본비, comp_typ=.04 후가공, 제본종류=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row700 comp_price_id=2114
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2114, 'COMP_BIND_MUSEON', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 100, 500, '제본비/무선제본 수량≥100 (제본비, comp_typ=.04 후가공, 제본종류=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row701 comp_price_id=2115
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2115, 'COMP_BIND_TWINRING', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 100, 1300, '제본비/트윈링제본 수량≥100 (제본비, comp_typ=.04 후가공, 제본종류=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row702 comp_price_id=2116
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2116, 'COMP_BIND_PUR', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 100, 2000, '제본비/PUR제본 수량≥100 (제본비, comp_typ=.04 후가공, 제본종류=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row703 comp_price_id=2117
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2117, 'COMP_BIND_JUNGCHEOL', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1000, 500, '제본비/중철제본 수량≥1000 (제본비, comp_typ=.04 후가공, 제본종류=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row704 comp_price_id=2118
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2118, 'COMP_BIND_MUSEON', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1000, 500, '제본비/무선제본 수량≥1000 (제본비, comp_typ=.04 후가공, 제본종류=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row705 comp_price_id=2119
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2119, 'COMP_BIND_TWINRING', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1000, 1000, '제본비/트윈링제본 수량≥1000 (제본비, comp_typ=.04 후가공, 제본종류=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row706 comp_price_id=2120
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2120, 'COMP_BIND_PUR', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1000, 1500, '제본비/PUR제본 수량≥1000 (제본비, comp_typ=.04 후가공, 제본종류=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row707 comp_price_id=2121
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2121, 'COMP_BIND_HC_MUSEON', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1, 30000, '하드커버 제본비/하드커버무선 수량≥1 (제본비, comp_typ=.04 후가공, 제본종류=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row708 comp_price_id=2122
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2122, 'COMP_BIND_HC_TWINRING', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1, 30000, '하드커버 제본비/하드커버트윈링 수량≥1 (제본비, comp_typ=.04 후가공, 제본종류=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row709 comp_price_id=2123
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2123, 'COMP_BIND_SSABARI', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1, 30000, '하드커버 제본비/싸바리바인더 수량≥1 (제본비, comp_typ=.04 후가공, 제본종류=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row710 comp_price_id=2124
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2124, 'COMP_BIND_HC_MUSEON', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 4, 20000, '하드커버 제본비/하드커버무선 수량≥4 (제본비, comp_typ=.04 후가공, 제본종류=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row711 comp_price_id=2125
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2125, 'COMP_BIND_HC_TWINRING', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 4, 20000, '하드커버 제본비/하드커버트윈링 수량≥4 (제본비, comp_typ=.04 후가공, 제본종류=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row712 comp_price_id=2126
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2126, 'COMP_BIND_SSABARI', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 4, 25000, '하드커버 제본비/싸바리바인더 수량≥4 (제본비, comp_typ=.04 후가공, 제본종류=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row713 comp_price_id=2127
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2127, 'COMP_BIND_HC_MUSEON', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 10, 14000, '하드커버 제본비/하드커버무선 수량≥10 (제본비, comp_typ=.04 후가공, 제본종류=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row714 comp_price_id=2128
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2128, 'COMP_BIND_HC_TWINRING', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 10, 15000, '하드커버 제본비/하드커버트윈링 수량≥10 (제본비, comp_typ=.04 후가공, 제본종류=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row715 comp_price_id=2129
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2129, 'COMP_BIND_SSABARI', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 10, 20000, '하드커버 제본비/싸바리바인더 수량≥10 (제본비, comp_typ=.04 후가공, 제본종류=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row716 comp_price_id=2130
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2130, 'COMP_BIND_HC_MUSEON', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 50, 9000, '하드커버 제본비/하드커버무선 수량≥50 (제본비, comp_typ=.04 후가공, 제본종류=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row717 comp_price_id=2131
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2131, 'COMP_BIND_HC_TWINRING', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 50, 10000, '하드커버 제본비/하드커버트윈링 수량≥50 (제본비, comp_typ=.04 후가공, 제본종류=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row718 comp_price_id=2132
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2132, 'COMP_BIND_SSABARI', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 50, 15000, '하드커버 제본비/싸바리바인더 수량≥50 (제본비, comp_typ=.04 후가공, 제본종류=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row719 comp_price_id=2133
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2133, 'COMP_BIND_HC_MUSEON', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 100, 7000, '하드커버 제본비/하드커버무선 수량≥100 (제본비, comp_typ=.04 후가공, 제본종류=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row720 comp_price_id=2134
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2134, 'COMP_BIND_HC_TWINRING', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 100, 8000, '하드커버 제본비/하드커버트윈링 수량≥100 (제본비, comp_typ=.04 후가공, 제본종류=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row721 comp_price_id=2135
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2135, 'COMP_BIND_SSABARI', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 100, 9000, '하드커버 제본비/싸바리바인더 수량≥100 (제본비, comp_typ=.04 후가공, 제본종류=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row722 comp_price_id=2136
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2136, 'COMP_BIND_HC_MUSEON', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1000, 6000, '하드커버 제본비/하드커버무선 수량≥1000 (제본비, comp_typ=.04 후가공, 제본종류=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row723 comp_price_id=2137
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2137, 'COMP_BIND_HC_TWINRING', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1000, 7000, '하드커버 제본비/하드커버트윈링 수량≥1000 (제본비, comp_typ=.04 후가공, 제본종류=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row724 comp_price_id=2138
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2138, 'COMP_BIND_SSABARI', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1000, 7000, '하드커버 제본비/싸바리바인더 수량≥1000 (제본비, comp_typ=.04 후가공, 제본종류=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row725 comp_price_id=2139
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2139, 'COMP_BIND_CAL_WALL', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1, 5000, '캘린더 제본비/벽걸이캘린더제본 수량≥1 (제본비, comp_typ=.04 후가공, 제본종류=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row726 comp_price_id=2140
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2140, 'COMP_BIND_CAL_DESK220', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1, 5000, '캘린더 제본비/탁상형캘린더제본(220) 수량≥1 (제본비, comp_typ=.04 후가공, 제본종류=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row727 comp_price_id=2141
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2141, 'COMP_BIND_CAL_DESK130', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1, 5000, '캘린더 제본비/탁상형캘린더제본(130) 수량≥1 (제본비, comp_typ=.04 후가공, 제본종류=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row728 comp_price_id=2142
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2142, 'COMP_BIND_CAL_DESKMINI', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1, 4500, '캘린더 제본비/탁상형캘린더제본(미니) 수량≥1 (제본비, comp_typ=.04 후가공, 제본종류=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row729 comp_price_id=2143
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2143, 'COMP_BIND_CAL_WALL', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 4, 4000, '캘린더 제본비/벽걸이캘린더제본 수량≥4 (제본비, comp_typ=.04 후가공, 제본종류=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row730 comp_price_id=2144
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2144, 'COMP_BIND_CAL_DESK220', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 4, 4000, '캘린더 제본비/탁상형캘린더제본(220) 수량≥4 (제본비, comp_typ=.04 후가공, 제본종류=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row731 comp_price_id=2145
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2145, 'COMP_BIND_CAL_DESK130', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 4, 4000, '캘린더 제본비/탁상형캘린더제본(130) 수량≥4 (제본비, comp_typ=.04 후가공, 제본종류=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row732 comp_price_id=2146
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2146, 'COMP_BIND_CAL_DESKMINI', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 4, 3500, '캘린더 제본비/탁상형캘린더제본(미니) 수량≥4 (제본비, comp_typ=.04 후가공, 제본종류=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row733 comp_price_id=2147
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2147, 'COMP_BIND_CAL_WALL', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 10, 3000, '캘린더 제본비/벽걸이캘린더제본 수량≥10 (제본비, comp_typ=.04 후가공, 제본종류=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row734 comp_price_id=2148
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2148, 'COMP_BIND_CAL_DESK220', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 10, 3000, '캘린더 제본비/탁상형캘린더제본(220) 수량≥10 (제본비, comp_typ=.04 후가공, 제본종류=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row735 comp_price_id=2149
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2149, 'COMP_BIND_CAL_DESK130', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 10, 3000, '캘린더 제본비/탁상형캘린더제본(130) 수량≥10 (제본비, comp_typ=.04 후가공, 제본종류=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row736 comp_price_id=2150
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2150, 'COMP_BIND_CAL_DESKMINI', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 10, 2500, '캘린더 제본비/탁상형캘린더제본(미니) 수량≥10 (제본비, comp_typ=.04 후가공, 제본종류=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row737 comp_price_id=2151
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2151, 'COMP_BIND_CAL_WALL', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 50, 2500, '캘린더 제본비/벽걸이캘린더제본 수량≥50 (제본비, comp_typ=.04 후가공, 제본종류=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row738 comp_price_id=2152
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2152, 'COMP_BIND_CAL_DESK220', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 50, 2500, '캘린더 제본비/탁상형캘린더제본(220) 수량≥50 (제본비, comp_typ=.04 후가공, 제본종류=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row739 comp_price_id=2153
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2153, 'COMP_BIND_CAL_DESK130', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 50, 2500, '캘린더 제본비/탁상형캘린더제본(130) 수량≥50 (제본비, comp_typ=.04 후가공, 제본종류=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row740 comp_price_id=2154
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2154, 'COMP_BIND_CAL_DESKMINI', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 50, 2000, '캘린더 제본비/탁상형캘린더제본(미니) 수량≥50 (제본비, comp_typ=.04 후가공, 제본종류=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row741 comp_price_id=2155
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2155, 'COMP_BIND_CAL_WALL', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 100, 2000, '캘린더 제본비/벽걸이캘린더제본 수량≥100 (제본비, comp_typ=.04 후가공, 제본종류=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row742 comp_price_id=2156
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2156, 'COMP_BIND_CAL_DESK220', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 100, 2300, '캘린더 제본비/탁상형캘린더제본(220) 수량≥100 (제본비, comp_typ=.04 후가공, 제본종류=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row743 comp_price_id=2157
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2157, 'COMP_BIND_CAL_DESK130', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 100, 2300, '캘린더 제본비/탁상형캘린더제본(130) 수량≥100 (제본비, comp_typ=.04 후가공, 제본종류=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row744 comp_price_id=2158
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2158, 'COMP_BIND_CAL_DESKMINI', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 100, 1800, '캘린더 제본비/탁상형캘린더제본(미니) 수량≥100 (제본비, comp_typ=.04 후가공, 제본종류=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row745 comp_price_id=2159
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2159, 'COMP_BIND_CAL_WALL', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1000, 2000, '캘린더 제본비/벽걸이캘린더제본 수량≥1000 (제본비, comp_typ=.04 후가공, 제본종류=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row746 comp_price_id=2160
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2160, 'COMP_BIND_CAL_DESK220', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1000, 2000, '캘린더 제본비/탁상형캘린더제본(220) 수량≥1000 (제본비, comp_typ=.04 후가공, 제본종류=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row747 comp_price_id=2161
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2161, 'COMP_BIND_CAL_DESK130', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1000, 2000, '캘린더 제본비/탁상형캘린더제본(130) 수량≥1000 (제본비, comp_typ=.04 후가공, 제본종류=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row748 comp_price_id=2162
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2162, 'COMP_BIND_CAL_DESKMINI', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1000, 1600, '캘린더 제본비/탁상형캘린더제본(미니) 수량≥1000 (제본비, comp_typ=.04 후가공, 제본종류=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row749 comp_price_id=2163
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2163, 'COMP_CUT_PERF_1H6', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1, 0, '타공(단가)/1구(6mm) 출력매수≥1 (comp_typ=.04 후가공, 구수=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row750 comp_price_id=2164
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2164, 'COMP_CUT_PERF_1H6', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 100, 0, '타공(단가)/1구(6mm) 출력매수≥100 (comp_typ=.04 후가공, 구수=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row751 comp_price_id=2165
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2165, 'COMP_CUT_PERF_1H6', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 200, 0, '타공(단가)/1구(6mm) 출력매수≥200 (comp_typ=.04 후가공, 구수=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row752 comp_price_id=2166
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2166, 'COMP_CUT_PERF_1H6', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 300, 0, '타공(단가)/1구(6mm) 출력매수≥300 (comp_typ=.04 후가공, 구수=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row753 comp_price_id=2167
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2167, 'COMP_CUT_PERF_1H6', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 400, 0, '타공(단가)/1구(6mm) 출력매수≥400 (comp_typ=.04 후가공, 구수=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row754 comp_price_id=2168
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2168, 'COMP_CUT_PERF_1H6', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 500, 0, '타공(단가)/1구(6mm) 출력매수≥500 (comp_typ=.04 후가공, 구수=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row755 comp_price_id=2169
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2169, 'COMP_CUT_PERF_1H6', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 600, 0, '타공(단가)/1구(6mm) 출력매수≥600 (comp_typ=.04 후가공, 구수=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row756 comp_price_id=2170
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2170, 'COMP_CUT_PERF_1H6', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 700, 0, '타공(단가)/1구(6mm) 출력매수≥700 (comp_typ=.04 후가공, 구수=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row757 comp_price_id=2171
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2171, 'COMP_CUT_PERF_1H6', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 800, 0, '타공(단가)/1구(6mm) 출력매수≥800 (comp_typ=.04 후가공, 구수=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row758 comp_price_id=2172
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2172, 'COMP_CUT_PERF_1H6', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 900, 0, '타공(단가)/1구(6mm) 출력매수≥900 (comp_typ=.04 후가공, 구수=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row759 comp_price_id=2173
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2173, 'COMP_CUT_PERF_1H6', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1000, 0, '타공(단가)/1구(6mm) 출력매수≥1000 (comp_typ=.04 후가공, 구수=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row760 comp_price_id=2174
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2174, 'COMP_CUT_PERF_1H6', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1500, 0, '타공(단가)/1구(6mm) 출력매수≥1500 (comp_typ=.04 후가공, 구수=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row761 comp_price_id=2175
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2175, 'COMP_CUT_PERF_1H6', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 2000, 0, '타공(단가)/1구(6mm) 출력매수≥2000 (comp_typ=.04 후가공, 구수=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row762 comp_price_id=2176
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2176, 'COMP_CUT_PERF_1H6', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 2500, 0, '타공(단가)/1구(6mm) 출력매수≥2500 (comp_typ=.04 후가공, 구수=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row763 comp_price_id=2177
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2177, 'COMP_CUT_PERF_1H6', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 3000, 0, '타공(단가)/1구(6mm) 출력매수≥3000 (comp_typ=.04 후가공, 구수=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row764 comp_price_id=2178
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2178, 'COMP_CUT_PERF_1H6', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 3500, 0, '타공(단가)/1구(6mm) 출력매수≥3500 (comp_typ=.04 후가공, 구수=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row765 comp_price_id=2179
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2179, 'COMP_CUT_PERF_1H6', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 4000, 0, '타공(단가)/1구(6mm) 출력매수≥4000 (comp_typ=.04 후가공, 구수=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row766 comp_price_id=2180
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2180, 'COMP_CUT_PERF_1H6', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 4500, 0, '타공(단가)/1구(6mm) 출력매수≥4500 (comp_typ=.04 후가공, 구수=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row767 comp_price_id=2181
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2181, 'COMP_CUT_PERF_1H6', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 5000, 0, '타공(단가)/1구(6mm) 출력매수≥5000 (comp_typ=.04 후가공, 구수=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row768 comp_price_id=2182
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2182, 'COMP_CUT_PERF_1H6', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 6000, 0, '타공(단가)/1구(6mm) 출력매수≥6000 (comp_typ=.04 후가공, 구수=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row769 comp_price_id=2183
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2183, 'COMP_CUT_PERF_1H6', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 7000, 0, '타공(단가)/1구(6mm) 출력매수≥7000 (comp_typ=.04 후가공, 구수=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row770 comp_price_id=2184
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2184, 'COMP_CUT_PERF_1H6', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 8000, 0, '타공(단가)/1구(6mm) 출력매수≥8000 (comp_typ=.04 후가공, 구수=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row771 comp_price_id=2185
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2185, 'COMP_CUT_PERF_1H6', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 9000, 0, '타공(단가)/1구(6mm) 출력매수≥9000 (comp_typ=.04 후가공, 구수=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row772 comp_price_id=2222
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2222, 'COMP_CUT_FULL_PERF_1H6', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1, 2000, '타공(합가) 1구(6mm) 출력매수≥1 (규칙④ 합가, 수량변동→차원, 헤더택/벽걸이캘린더)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row773 comp_price_id=2223
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2223, 'COMP_CUT_FULL_PERF_2H6', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1, 4000, '타공(합가) 2구(6mm) 출력매수≥1 (규칙④ 합가, 수량변동→차원, 헤더택/벽걸이캘린더)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row774 comp_price_id=2224
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2224, 'COMP_CUT_FULL_PERF_1H6', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 100, 2000, '타공(합가) 1구(6mm) 출력매수≥100 (규칙④ 합가, 수량변동→차원, 헤더택/벽걸이캘린더)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row775 comp_price_id=2225
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2225, 'COMP_CUT_FULL_PERF_2H6', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 100, 4000, '타공(합가) 2구(6mm) 출력매수≥100 (규칙④ 합가, 수량변동→차원, 헤더택/벽걸이캘린더)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row776 comp_price_id=2226
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2226, 'COMP_CUT_FULL_PERF_1H6', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 200, 4000, '타공(합가) 1구(6mm) 출력매수≥200 (규칙④ 합가, 수량변동→차원, 헤더택/벽걸이캘린더)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row777 comp_price_id=2227
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2227, 'COMP_CUT_FULL_PERF_2H6', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 200, 8000, '타공(합가) 2구(6mm) 출력매수≥200 (규칙④ 합가, 수량변동→차원, 헤더택/벽걸이캘린더)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row778 comp_price_id=2228
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2228, 'COMP_CUT_FULL_PERF_1H6', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 300, 6000, '타공(합가) 1구(6mm) 출력매수≥300 (규칙④ 합가, 수량변동→차원, 헤더택/벽걸이캘린더)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row779 comp_price_id=2229
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2229, 'COMP_CUT_FULL_PERF_2H6', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 300, 12000, '타공(합가) 2구(6mm) 출력매수≥300 (규칙④ 합가, 수량변동→차원, 헤더택/벽걸이캘린더)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row780 comp_price_id=2230
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2230, 'COMP_CUT_FULL_PERF_1H6', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 400, 11000, '타공(합가) 1구(6mm) 출력매수≥400 (규칙④ 합가, 수량변동→차원, 헤더택/벽걸이캘린더)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row781 comp_price_id=2231
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2231, 'COMP_CUT_FULL_PERF_2H6', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 400, 22000, '타공(합가) 2구(6mm) 출력매수≥400 (규칙④ 합가, 수량변동→차원, 헤더택/벽걸이캘린더)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row782 comp_price_id=2232
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2232, 'COMP_CUT_FULL_PERF_1H6', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 500, 21000, '타공(합가) 1구(6mm) 출력매수≥500 (규칙④ 합가, 수량변동→차원, 헤더택/벽걸이캘린더)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row783 comp_price_id=2233
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2233, 'COMP_CUT_FULL_PERF_2H6', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 500, 42000, '타공(합가) 2구(6mm) 출력매수≥500 (규칙④ 합가, 수량변동→차원, 헤더택/벽걸이캘린더)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row784 comp_price_id=2234
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2234, 'COMP_CUT_FULL_PERF_1H6', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 600, 31000, '타공(합가) 1구(6mm) 출력매수≥600 (규칙④ 합가, 수량변동→차원, 헤더택/벽걸이캘린더)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row785 comp_price_id=2235
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2235, 'COMP_CUT_FULL_PERF_2H6', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 600, 62000, '타공(합가) 2구(6mm) 출력매수≥600 (규칙④ 합가, 수량변동→차원, 헤더택/벽걸이캘린더)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row786 comp_price_id=2236
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2236, 'COMP_CUT_FULL_PERF_1H6', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 700, 41000, '타공(합가) 1구(6mm) 출력매수≥700 (규칙④ 합가, 수량변동→차원, 헤더택/벽걸이캘린더)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row787 comp_price_id=2237
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2237, 'COMP_CUT_FULL_PERF_2H6', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 700, 82000, '타공(합가) 2구(6mm) 출력매수≥700 (규칙④ 합가, 수량변동→차원, 헤더택/벽걸이캘린더)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row788 comp_price_id=2238
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2238, 'COMP_CUT_FULL_PERF_1H6', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 800, 51000, '타공(합가) 1구(6mm) 출력매수≥800 (규칙④ 합가, 수량변동→차원, 헤더택/벽걸이캘린더)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row789 comp_price_id=2239
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2239, 'COMP_CUT_FULL_PERF_2H6', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 800, 102000, '타공(합가) 2구(6mm) 출력매수≥800 (규칙④ 합가, 수량변동→차원, 헤더택/벽걸이캘린더)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row790 comp_price_id=2240
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2240, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000153', NULL, NULL, 1, 6000, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/유포/비코팅/미색 출력매수≥1 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row791 comp_price_id=2241
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2241, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000155', NULL, NULL, 1, 7000, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/무광코팅/유광코팅 출력매수≥1 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row792 comp_price_id=2242
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2242, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000170', NULL, NULL, 1, 7000, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/투명/홀로그램 출력매수≥1 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row793 comp_price_id=2249
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2249, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000153', NULL, NULL, 1, 6000, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/유포/비코팅/미색 출력매수≥1 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row794 comp_price_id=2250
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2250, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000155', NULL, NULL, 1, 7000, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/무광코팅/유광코팅 출력매수≥1 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row795 comp_price_id=2251
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2251, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000170', NULL, NULL, 1, 7000, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/투명/홀로그램 출력매수≥1 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row796 comp_price_id=2258
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2258, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000153', NULL, NULL, 2, 6000, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/유포/비코팅/미색 출력매수≥2 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row797 comp_price_id=2259
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2259, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000155', NULL, NULL, 2, 7000, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/무광코팅/유광코팅 출력매수≥2 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row798 comp_price_id=2260
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2260, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000170', NULL, NULL, 2, 7000, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/투명/홀로그램 출력매수≥2 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row799 comp_price_id=2267
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2267, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000153', NULL, NULL, 2, 6000, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/유포/비코팅/미색 출력매수≥2 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row800 comp_price_id=2268
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2268, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000155', NULL, NULL, 2, 7000, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/무광코팅/유광코팅 출력매수≥2 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row801 comp_price_id=2269
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2269, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000170', NULL, NULL, 2, 7000, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/투명/홀로그램 출력매수≥2 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row802 comp_price_id=2276
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2276, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000153', NULL, NULL, 3, 5900, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/유포/비코팅/미색 출력매수≥3 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row803 comp_price_id=2277
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2277, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000155', NULL, NULL, 3, 6900, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/무광코팅/유광코팅 출력매수≥3 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row804 comp_price_id=2278
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2278, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000170', NULL, NULL, 3, 6900, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/투명/홀로그램 출력매수≥3 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row805 comp_price_id=2285
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2285, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000153', NULL, NULL, 3, 5800, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/유포/비코팅/미색 출력매수≥3 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row806 comp_price_id=2286
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2286, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000155', NULL, NULL, 3, 6800, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/무광코팅/유광코팅 출력매수≥3 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row807 comp_price_id=2287
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2287, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000170', NULL, NULL, 3, 6800, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/투명/홀로그램 출력매수≥3 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row808 comp_price_id=2294
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2294, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000153', NULL, NULL, 4, 5800, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/유포/비코팅/미색 출력매수≥4 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row809 comp_price_id=2295
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2295, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000155', NULL, NULL, 4, 6800, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/무광코팅/유광코팅 출력매수≥4 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row810 comp_price_id=2296
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2296, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000170', NULL, NULL, 4, 6800, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/투명/홀로그램 출력매수≥4 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row811 comp_price_id=2303
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2303, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000153', NULL, NULL, 4, 5800, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/유포/비코팅/미색 출력매수≥4 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row812 comp_price_id=2304
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2304, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000155', NULL, NULL, 4, 6800, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/무광코팅/유광코팅 출력매수≥4 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row813 comp_price_id=2305
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2305, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000170', NULL, NULL, 4, 6800, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/투명/홀로그램 출력매수≥4 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row814 comp_price_id=2312
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2312, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000153', NULL, NULL, 5, 5800, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/유포/비코팅/미색 출력매수≥5 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row815 comp_price_id=2313
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2313, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000155', NULL, NULL, 5, 6800, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/무광코팅/유광코팅 출력매수≥5 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row816 comp_price_id=2314
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2314, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000170', NULL, NULL, 5, 6800, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/투명/홀로그램 출력매수≥5 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row817 comp_price_id=2321
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2321, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000153', NULL, NULL, 5, 5800, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/유포/비코팅/미색 출력매수≥5 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row818 comp_price_id=2322
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2322, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000155', NULL, NULL, 5, 6800, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/무광코팅/유광코팅 출력매수≥5 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row819 comp_price_id=2323
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2323, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000170', NULL, NULL, 5, 6800, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/투명/홀로그램 출력매수≥5 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row820 comp_price_id=2330
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2330, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000153', NULL, NULL, 6, 5700, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/유포/비코팅/미색 출력매수≥6 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row821 comp_price_id=2331
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2331, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000155', NULL, NULL, 6, 6700, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/무광코팅/유광코팅 출력매수≥6 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row822 comp_price_id=2332
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2332, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000170', NULL, NULL, 6, 6700, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/투명/홀로그램 출력매수≥6 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row823 comp_price_id=2339
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2339, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000153', NULL, NULL, 6, 5800, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/유포/비코팅/미색 출력매수≥6 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row824 comp_price_id=2340
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2340, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000155', NULL, NULL, 6, 6800, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/무광코팅/유광코팅 출력매수≥6 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row825 comp_price_id=2341
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2341, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000170', NULL, NULL, 6, 6800, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/투명/홀로그램 출력매수≥6 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row826 comp_price_id=2348
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2348, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000153', NULL, NULL, 8, 5700, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/유포/비코팅/미색 출력매수≥8 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row827 comp_price_id=2349
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2349, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000155', NULL, NULL, 8, 6700, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/무광코팅/유광코팅 출력매수≥8 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row828 comp_price_id=2350
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2350, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000170', NULL, NULL, 8, 6700, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/투명/홀로그램 출력매수≥8 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row829 comp_price_id=2357
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2357, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000153', NULL, NULL, 8, 5800, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/유포/비코팅/미색 출력매수≥8 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row830 comp_price_id=2358
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2358, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000155', NULL, NULL, 8, 6800, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/무광코팅/유광코팅 출력매수≥8 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row831 comp_price_id=2359
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2359, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000170', NULL, NULL, 8, 6800, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/투명/홀로그램 출력매수≥8 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row832 comp_price_id=2366
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2366, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000153', NULL, NULL, 10, 5700, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/유포/비코팅/미색 출력매수≥10 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row833 comp_price_id=2367
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2367, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000155', NULL, NULL, 10, 6700, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/무광코팅/유광코팅 출력매수≥10 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row834 comp_price_id=2368
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2368, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000170', NULL, NULL, 10, 6700, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/투명/홀로그램 출력매수≥10 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row835 comp_price_id=2375
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2375, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000153', NULL, NULL, 10, 5700, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/유포/비코팅/미색 출력매수≥10 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row836 comp_price_id=2376
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2376, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000155', NULL, NULL, 10, 6700, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/무광코팅/유광코팅 출력매수≥10 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row837 comp_price_id=2377
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2377, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000170', NULL, NULL, 10, 6700, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/투명/홀로그램 출력매수≥10 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row838 comp_price_id=2384
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2384, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000153', NULL, NULL, 15, 5600, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/유포/비코팅/미색 출력매수≥15 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row839 comp_price_id=2385
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2385, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000155', NULL, NULL, 15, 6600, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/무광코팅/유광코팅 출력매수≥15 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row840 comp_price_id=2386
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2386, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000170', NULL, NULL, 15, 6600, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/투명/홀로그램 출력매수≥15 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row841 comp_price_id=2393
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2393, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000153', NULL, NULL, 15, 5600, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/유포/비코팅/미색 출력매수≥15 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row842 comp_price_id=2394
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2394, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000155', NULL, NULL, 15, 6600, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/무광코팅/유광코팅 출력매수≥15 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row843 comp_price_id=2395
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2395, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000170', NULL, NULL, 15, 6600, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/투명/홀로그램 출력매수≥15 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row844 comp_price_id=2402
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2402, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000153', NULL, NULL, 20, 5500, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/유포/비코팅/미색 출력매수≥20 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row845 comp_price_id=2403
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2403, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000155', NULL, NULL, 20, 6500, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/무광코팅/유광코팅 출력매수≥20 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row846 comp_price_id=2404
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2404, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000170', NULL, NULL, 20, 6500, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/투명/홀로그램 출력매수≥20 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row847 comp_price_id=2411
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2411, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000153', NULL, NULL, 20, 5600, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/유포/비코팅/미색 출력매수≥20 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row848 comp_price_id=2412
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2412, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000155', NULL, NULL, 20, 6600, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/무광코팅/유광코팅 출력매수≥20 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row849 comp_price_id=2413
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2413, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000170', NULL, NULL, 20, 6600, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/투명/홀로그램 출력매수≥20 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row850 comp_price_id=2420
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2420, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000153', NULL, NULL, 25, 5500, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/유포/비코팅/미색 출력매수≥25 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row851 comp_price_id=2421
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2421, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000155', NULL, NULL, 25, 6500, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/무광코팅/유광코팅 출력매수≥25 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row852 comp_price_id=2422
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2422, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000170', NULL, NULL, 25, 6500, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/투명/홀로그램 출력매수≥25 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row853 comp_price_id=2429
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2429, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000153', NULL, NULL, 25, 5500, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/유포/비코팅/미색 출력매수≥25 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row854 comp_price_id=2430
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2430, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000155', NULL, NULL, 25, 6500, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/무광코팅/유광코팅 출력매수≥25 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row855 comp_price_id=2431
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2431, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000170', NULL, NULL, 25, 6500, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/투명/홀로그램 출력매수≥25 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row856 comp_price_id=2438
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2438, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000153', NULL, NULL, 30, 5400, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/유포/비코팅/미색 출력매수≥30 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row857 comp_price_id=2439
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2439, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000155', NULL, NULL, 30, 6400, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/무광코팅/유광코팅 출력매수≥30 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row858 comp_price_id=2440
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2440, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000170', NULL, NULL, 30, 6400, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/투명/홀로그램 출력매수≥30 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row859 comp_price_id=2447
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2447, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000153', NULL, NULL, 30, 5500, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/유포/비코팅/미색 출력매수≥30 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row860 comp_price_id=2448
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2448, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000155', NULL, NULL, 30, 6500, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/무광코팅/유광코팅 출력매수≥30 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row861 comp_price_id=2449
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2449, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000170', NULL, NULL, 30, 6500, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/투명/홀로그램 출력매수≥30 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row862 comp_price_id=2456
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2456, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000153', NULL, NULL, 38, 5400, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/유포/비코팅/미색 출력매수≥38 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row863 comp_price_id=2457
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2457, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000155', NULL, NULL, 38, 6400, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/무광코팅/유광코팅 출력매수≥38 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row864 comp_price_id=2458
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2458, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000170', NULL, NULL, 38, 6400, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/투명/홀로그램 출력매수≥38 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row865 comp_price_id=2465
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2465, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000153', NULL, NULL, 38, 5400, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/유포/비코팅/미색 출력매수≥38 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row866 comp_price_id=2466
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2466, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000155', NULL, NULL, 38, 6400, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/무광코팅/유광코팅 출력매수≥38 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row867 comp_price_id=2467
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2467, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000170', NULL, NULL, 38, 6400, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/투명/홀로그램 출력매수≥38 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row868 comp_price_id=2474
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2474, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000153', NULL, NULL, 40, 5300, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/유포/비코팅/미색 출력매수≥40 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row869 comp_price_id=2475
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2475, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000155', NULL, NULL, 40, 6300, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/무광코팅/유광코팅 출력매수≥40 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row870 comp_price_id=2476
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2476, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000170', NULL, NULL, 40, 6300, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/투명/홀로그램 출력매수≥40 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row871 comp_price_id=2483
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2483, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000153', NULL, NULL, 40, 5400, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/유포/비코팅/미색 출력매수≥40 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row872 comp_price_id=2484
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2484, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000155', NULL, NULL, 40, 6400, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/무광코팅/유광코팅 출력매수≥40 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row873 comp_price_id=2485
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2485, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000170', NULL, NULL, 40, 6400, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/투명/홀로그램 출력매수≥40 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row874 comp_price_id=2492
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2492, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000153', NULL, NULL, 50, 5300, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/유포/비코팅/미색 출력매수≥50 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row875 comp_price_id=2493
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2493, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000155', NULL, NULL, 50, 6300, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/무광코팅/유광코팅 출력매수≥50 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row876 comp_price_id=2494
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2494, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000170', NULL, NULL, 50, 6300, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/투명/홀로그램 출력매수≥50 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row877 comp_price_id=2501
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2501, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000153', NULL, NULL, 50, 5300, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/유포/비코팅/미색 출력매수≥50 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row878 comp_price_id=2502
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2502, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000155', NULL, NULL, 50, 6300, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/무광코팅/유광코팅 출력매수≥50 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row879 comp_price_id=2503
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2503, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000170', NULL, NULL, 50, 6300, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/투명/홀로그램 출력매수≥50 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row880 comp_price_id=2510
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2510, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000153', NULL, NULL, 60, 5200, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/유포/비코팅/미색 출력매수≥60 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row881 comp_price_id=2511
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2511, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000155', NULL, NULL, 60, 6200, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/무광코팅/유광코팅 출력매수≥60 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row882 comp_price_id=2512
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2512, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000170', NULL, NULL, 60, 6200, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/투명/홀로그램 출력매수≥60 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row883 comp_price_id=2519
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2519, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000153', NULL, NULL, 60, 5300, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/유포/비코팅/미색 출력매수≥60 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row884 comp_price_id=2520
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2520, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000155', NULL, NULL, 60, 6300, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/무광코팅/유광코팅 출력매수≥60 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row885 comp_price_id=2521
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2521, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000170', NULL, NULL, 60, 6300, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/투명/홀로그램 출력매수≥60 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row886 comp_price_id=2528
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2528, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000153', NULL, NULL, 70, 5200, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/유포/비코팅/미색 출력매수≥70 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row887 comp_price_id=2529
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2529, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000155', NULL, NULL, 70, 6200, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/무광코팅/유광코팅 출력매수≥70 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row888 comp_price_id=2530
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2530, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000170', NULL, NULL, 70, 6200, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/투명/홀로그램 출력매수≥70 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row889 comp_price_id=2537
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2537, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000153', NULL, NULL, 70, 5300, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/유포/비코팅/미색 출력매수≥70 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row890 comp_price_id=2538
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2538, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000155', NULL, NULL, 70, 6300, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/무광코팅/유광코팅 출력매수≥70 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row891 comp_price_id=2539
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2539, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000170', NULL, NULL, 70, 6300, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/투명/홀로그램 출력매수≥70 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row892 comp_price_id=2546
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2546, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000153', NULL, NULL, 75, 5200, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/유포/비코팅/미색 출력매수≥75 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row893 comp_price_id=2547
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2547, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000155', NULL, NULL, 75, 6200, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/무광코팅/유광코팅 출력매수≥75 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row894 comp_price_id=2548
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2548, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000170', NULL, NULL, 75, 6200, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/투명/홀로그램 출력매수≥75 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row895 comp_price_id=2555
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2555, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000153', NULL, NULL, 75, 5200, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/유포/비코팅/미색 출력매수≥75 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row896 comp_price_id=2556
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2556, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000155', NULL, NULL, 75, 6200, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/무광코팅/유광코팅 출력매수≥75 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row897 comp_price_id=2557
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2557, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000170', NULL, NULL, 75, 6200, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/투명/홀로그램 출력매수≥75 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row898 comp_price_id=2564
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2564, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000153', NULL, NULL, 80, 5200, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/유포/비코팅/미색 출력매수≥80 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row899 comp_price_id=2565
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2565, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000155', NULL, NULL, 80, 6200, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/무광코팅/유광코팅 출력매수≥80 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row900 comp_price_id=2566
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2566, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000170', NULL, NULL, 80, 6200, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/투명/홀로그램 출력매수≥80 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row901 comp_price_id=2573
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2573, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000153', NULL, NULL, 80, 5200, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/유포/비코팅/미색 출력매수≥80 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row902 comp_price_id=2574
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2574, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000155', NULL, NULL, 80, 6200, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/무광코팅/유광코팅 출력매수≥80 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row903 comp_price_id=2575
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2575, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000170', NULL, NULL, 80, 6200, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/투명/홀로그램 출력매수≥80 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row904 comp_price_id=2582
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2582, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000153', NULL, NULL, 90, 5200, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/유포/비코팅/미색 출력매수≥90 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row905 comp_price_id=2583
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2583, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000155', NULL, NULL, 90, 6200, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/무광코팅/유광코팅 출력매수≥90 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row906 comp_price_id=2584
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2584, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000170', NULL, NULL, 90, 6200, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/투명/홀로그램 출력매수≥90 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row907 comp_price_id=2591
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2591, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000153', NULL, NULL, 90, 5200, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/유포/비코팅/미색 출력매수≥90 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row908 comp_price_id=2592
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2592, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000155', NULL, NULL, 90, 6200, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/무광코팅/유광코팅 출력매수≥90 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row909 comp_price_id=2593
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2593, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000170', NULL, NULL, 90, 6200, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/투명/홀로그램 출력매수≥90 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row910 comp_price_id=2600
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2600, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000153', NULL, NULL, 100, 5200, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/유포/비코팅/미색 출력매수≥100 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row911 comp_price_id=2601
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2601, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000155', NULL, NULL, 100, 6200, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/무광코팅/유광코팅 출력매수≥100 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row912 comp_price_id=2602
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2602, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000170', NULL, NULL, 100, 6200, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/투명/홀로그램 출력매수≥100 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row913 comp_price_id=2609
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2609, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000153', NULL, NULL, 100, 5200, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/유포/비코팅/미색 출력매수≥100 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row914 comp_price_id=2610
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2610, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000155', NULL, NULL, 100, 6200, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/무광코팅/유광코팅 출력매수≥100 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row915 comp_price_id=2611
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2611, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000170', NULL, NULL, 100, 6200, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/투명/홀로그램 출력매수≥100 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row916 comp_price_id=2618
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2618, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000153', NULL, NULL, 120, 5100, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/유포/비코팅/미색 출력매수≥120 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row917 comp_price_id=2619
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2619, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000155', NULL, NULL, 120, 6100, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/무광코팅/유광코팅 출력매수≥120 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row918 comp_price_id=2620
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2620, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000170', NULL, NULL, 120, 6100, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/투명/홀로그램 출력매수≥120 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row919 comp_price_id=2627
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2627, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000153', NULL, NULL, 120, 5200, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/유포/비코팅/미색 출력매수≥120 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row920 comp_price_id=2628
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2628, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000155', NULL, NULL, 120, 6200, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/무광코팅/유광코팅 출력매수≥120 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row921 comp_price_id=2629
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2629, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000170', NULL, NULL, 120, 6200, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/투명/홀로그램 출력매수≥120 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row922 comp_price_id=2636
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2636, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000153', NULL, NULL, 125, 5100, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/유포/비코팅/미색 출력매수≥125 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row923 comp_price_id=2637
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2637, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000155', NULL, NULL, 125, 6100, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/무광코팅/유광코팅 출력매수≥125 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row924 comp_price_id=2638
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2638, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000170', NULL, NULL, 125, 6100, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/투명/홀로그램 출력매수≥125 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row925 comp_price_id=2645
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2645, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000153', NULL, NULL, 125, 5000, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/유포/비코팅/미색 출력매수≥125 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row926 comp_price_id=2646
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2646, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000155', NULL, NULL, 125, 6000, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/무광코팅/유광코팅 출력매수≥125 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row927 comp_price_id=2647
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2647, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000170', NULL, NULL, 125, 6000, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/투명/홀로그램 출력매수≥125 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row928 comp_price_id=2654
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2654, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000153', NULL, NULL, 140, 5000, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/유포/비코팅/미색 출력매수≥140 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row929 comp_price_id=2655
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2655, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000155', NULL, NULL, 140, 6000, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/무광코팅/유광코팅 출력매수≥140 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row930 comp_price_id=2656
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2656, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000170', NULL, NULL, 140, 6000, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/투명/홀로그램 출력매수≥140 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row931 comp_price_id=2663
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2663, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000153', NULL, NULL, 140, 5000, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/유포/비코팅/미색 출력매수≥140 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row932 comp_price_id=2664
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2664, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000155', NULL, NULL, 140, 6000, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/무광코팅/유광코팅 출력매수≥140 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row933 comp_price_id=2665
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2665, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000170', NULL, NULL, 140, 6000, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/투명/홀로그램 출력매수≥140 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row934 comp_price_id=2672
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2672, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000153', NULL, NULL, 150, 5000, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/유포/비코팅/미색 출력매수≥150 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row935 comp_price_id=2673
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2673, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000155', NULL, NULL, 150, 6000, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/무광코팅/유광코팅 출력매수≥150 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row936 comp_price_id=2674
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2674, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000170', NULL, NULL, 150, 6000, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/투명/홀로그램 출력매수≥150 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row937 comp_price_id=2681
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2681, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000153', NULL, NULL, 150, 5000, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/유포/비코팅/미색 출력매수≥150 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row938 comp_price_id=2682
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2682, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000155', NULL, NULL, 150, 6000, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/무광코팅/유광코팅 출력매수≥150 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row939 comp_price_id=2683
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2683, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000170', NULL, NULL, 150, 6000, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/투명/홀로그램 출력매수≥150 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row940 comp_price_id=2690
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2690, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000153', NULL, NULL, 160, 4800, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/유포/비코팅/미색 출력매수≥160 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row941 comp_price_id=2691
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2691, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000155', NULL, NULL, 160, 5800, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/무광코팅/유광코팅 출력매수≥160 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row942 comp_price_id=2692
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2692, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000170', NULL, NULL, 160, 5800, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/투명/홀로그램 출력매수≥160 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row943 comp_price_id=2699
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2699, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000153', NULL, NULL, 160, 4800, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/유포/비코팅/미색 출력매수≥160 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row944 comp_price_id=2700
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2700, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000155', NULL, NULL, 160, 5800, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/무광코팅/유광코팅 출력매수≥160 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row945 comp_price_id=2701
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2701, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000170', NULL, NULL, 160, 5800, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/투명/홀로그램 출력매수≥160 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row946 comp_price_id=2708
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2708, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000153', NULL, NULL, 175, 4800, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/유포/비코팅/미색 출력매수≥175 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row947 comp_price_id=2709
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2709, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000155', NULL, NULL, 175, 5800, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/무광코팅/유광코팅 출력매수≥175 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row948 comp_price_id=2710
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2710, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000170', NULL, NULL, 175, 5800, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/투명/홀로그램 출력매수≥175 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row949 comp_price_id=2717
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2717, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000153', NULL, NULL, 175, 4800, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/유포/비코팅/미색 출력매수≥175 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row950 comp_price_id=2718
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2718, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000155', NULL, NULL, 175, 5800, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/무광코팅/유광코팅 출력매수≥175 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row951 comp_price_id=2719
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2719, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000170', NULL, NULL, 175, 5800, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/투명/홀로그램 출력매수≥175 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row952 comp_price_id=2726
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2726, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000153', NULL, NULL, 180, 4800, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/유포/비코팅/미색 출력매수≥180 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row953 comp_price_id=2727
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2727, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000155', NULL, NULL, 180, 5800, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/무광코팅/유광코팅 출력매수≥180 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row954 comp_price_id=2728
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2728, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000170', NULL, NULL, 180, 5800, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/투명/홀로그램 출력매수≥180 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row955 comp_price_id=2735
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2735, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000153', NULL, NULL, 180, 4800, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/유포/비코팅/미색 출력매수≥180 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row956 comp_price_id=2736
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2736, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000155', NULL, NULL, 180, 5800, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/무광코팅/유광코팅 출력매수≥180 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row957 comp_price_id=2737
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2737, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000170', NULL, NULL, 180, 5800, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/투명/홀로그램 출력매수≥180 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row958 comp_price_id=2744
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2744, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000153', NULL, NULL, 200, 4800, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/유포/비코팅/미색 출력매수≥200 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row959 comp_price_id=2745
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2745, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000155', NULL, NULL, 200, 5800, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/무광코팅/유광코팅 출력매수≥200 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row960 comp_price_id=2746
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2746, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000170', NULL, NULL, 200, 5800, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/투명/홀로그램 출력매수≥200 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row961 comp_price_id=2753
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2753, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000153', NULL, NULL, 200, 4800, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/유포/비코팅/미색 출력매수≥200 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row962 comp_price_id=2754
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2754, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000155', NULL, NULL, 200, 5800, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/무광코팅/유광코팅 출력매수≥200 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row963 comp_price_id=2755
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2755, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000170', NULL, NULL, 200, 5800, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/투명/홀로그램 출력매수≥200 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row964 comp_price_id=2762
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2762, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000153', NULL, NULL, 250, 4600, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/유포/비코팅/미색 출력매수≥250 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row965 comp_price_id=2763
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2763, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000155', NULL, NULL, 250, 5600, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/무광코팅/유광코팅 출력매수≥250 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row966 comp_price_id=2764
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2764, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000170', NULL, NULL, 250, 5600, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/투명/홀로그램 출력매수≥250 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row967 comp_price_id=2771
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2771, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000153', NULL, NULL, 250, 4600, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/유포/비코팅/미색 출력매수≥250 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row968 comp_price_id=2772
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2772, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000155', NULL, NULL, 250, 5600, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/무광코팅/유광코팅 출력매수≥250 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row969 comp_price_id=2773
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2773, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000170', NULL, NULL, 250, 5600, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/투명/홀로그램 출력매수≥250 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row970 comp_price_id=2780
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2780, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000153', NULL, NULL, 300, 4400, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/유포/비코팅/미색 출력매수≥300 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row971 comp_price_id=2781
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2781, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000155', NULL, NULL, 300, 5400, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/무광코팅/유광코팅 출력매수≥300 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row972 comp_price_id=2782
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2782, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000170', NULL, NULL, 300, 5400, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/투명/홀로그램 출력매수≥300 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row973 comp_price_id=2789
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2789, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000153', NULL, NULL, 300, 4400, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/유포/비코팅/미색 출력매수≥300 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row974 comp_price_id=2790
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2790, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000155', NULL, NULL, 300, 5400, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/무광코팅/유광코팅 출력매수≥300 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row975 comp_price_id=2791
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2791, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000170', NULL, NULL, 300, 5400, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/투명/홀로그램 출력매수≥300 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row976 comp_price_id=2798
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2798, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000153', NULL, NULL, 350, 4200, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/유포/비코팅/미색 출력매수≥350 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row977 comp_price_id=2799
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2799, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000155', NULL, NULL, 350, 5200, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/무광코팅/유광코팅 출력매수≥350 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row978 comp_price_id=2800
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2800, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000170', NULL, NULL, 350, 5200, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/투명/홀로그램 출력매수≥350 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row979 comp_price_id=2807
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2807, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000153', NULL, NULL, 350, 4200, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/유포/비코팅/미색 출력매수≥350 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row980 comp_price_id=2808
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2808, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000155', NULL, NULL, 350, 5200, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/무광코팅/유광코팅 출력매수≥350 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row981 comp_price_id=2809
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2809, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000170', NULL, NULL, 350, 5200, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/투명/홀로그램 출력매수≥350 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row982 comp_price_id=2816
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2816, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000153', NULL, NULL, 400, 4000, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/유포/비코팅/미색 출력매수≥400 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row983 comp_price_id=2817
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2817, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000155', NULL, NULL, 400, 5000, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/무광코팅/유광코팅 출력매수≥400 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row984 comp_price_id=2818
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2818, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000170', NULL, NULL, 400, 5000, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/투명/홀로그램 출력매수≥400 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row985 comp_price_id=2825
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2825, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000153', NULL, NULL, 400, 4000, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/유포/비코팅/미색 출력매수≥400 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row986 comp_price_id=2826
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2826, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000155', NULL, NULL, 400, 5000, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/무광코팅/유광코팅 출력매수≥400 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row987 comp_price_id=2827
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2827, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000170', NULL, NULL, 400, 5000, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/투명/홀로그램 출력매수≥400 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row988 comp_price_id=2834
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2834, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000153', NULL, NULL, 450, 4000, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/유포/비코팅/미색 출력매수≥450 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row989 comp_price_id=2835
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2835, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000155', NULL, NULL, 450, 5000, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/무광코팅/유광코팅 출력매수≥450 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row990 comp_price_id=2836
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2836, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000170', NULL, NULL, 450, 5000, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/투명/홀로그램 출력매수≥450 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row991 comp_price_id=2843
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2843, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000153', NULL, NULL, 450, 4000, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/유포/비코팅/미색 출력매수≥450 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row992 comp_price_id=2844
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2844, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000155', NULL, NULL, 450, 5000, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/무광코팅/유광코팅 출력매수≥450 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row993 comp_price_id=2845
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2845, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000170', NULL, NULL, 450, 5000, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/투명/홀로그램 출력매수≥450 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row994 comp_price_id=2852
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2852, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000153', NULL, NULL, 500, 4000, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/유포/비코팅/미색 출력매수≥500 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row995 comp_price_id=2853
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2853, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000155', NULL, NULL, 500, 5000, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/무광코팅/유광코팅 출력매수≥500 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row996 comp_price_id=2854
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2854, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000170', NULL, NULL, 500, 5000, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/투명/홀로그램 출력매수≥500 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row997 comp_price_id=2861
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2861, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000153', NULL, NULL, 500, 4000, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/유포/비코팅/미색 출력매수≥500 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row998 comp_price_id=2862
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2862, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000155', NULL, NULL, 500, 5000, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/무광코팅/유광코팅 출력매수≥500 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row999 comp_price_id=2863
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2863, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000170', NULL, NULL, 500, 5000, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/투명/홀로그램 출력매수≥500 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1000 comp_price_id=2870
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2870, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000153', NULL, NULL, 100000, 4000, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/유포/비코팅/미색 출력매수≥100000 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1001 comp_price_id=2871
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2871, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000155', NULL, NULL, 100000, 5000, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/무광코팅/유광코팅 출력매수≥100000 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1002 comp_price_id=2872
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2872, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000059', NULL, 'MAT_000170', NULL, NULL, 100000, 5000, '반칼 자유형/규격 스티커 (국4절)/A5(4판) / 124 x186 mm (4판)/투명/홀로그램 출력매수≥100000 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1003 comp_price_id=2879
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2879, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000153', NULL, NULL, 100000, 4000, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/유포/비코팅/미색 출력매수≥100000 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1004 comp_price_id=2880
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2880, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000155', NULL, NULL, 100000, 5000, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/무광코팅/유광코팅 출력매수≥100000 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1005 comp_price_id=2881
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2881, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000060', NULL, 'MAT_000170', NULL, NULL, 100000, 5000, '반칼 자유형/규격 스티커 (국4절)/90*190(6판)/투명/홀로그램 출력매수≥100000 (소재묶음=대표mat+note)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1006 comp_price_id=2888
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2888, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000172', NULL, 'MAT_000153', NULL, NULL, 1, 4000, '낱장(완칼) 자유형 스티커/A4 제작수량≥1 (완칼 규격단독, 소재=유포(일반 완칼) 상품구분축)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1007 comp_price_id=2890
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2890, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000174', NULL, 'MAT_000153', NULL, NULL, 1, 8000, '낱장(완칼) 자유형 스티커/A3 제작수량≥1 (완칼 규격단독, 소재=유포(일반 완칼) 상품구분축)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1008 comp_price_id=2892
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2892, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000197', NULL, 'MAT_000153', NULL, NULL, 1, 16000, '낱장(완칼) 자유형 스티커/A2 제작수량≥1 (완칼 규격단독, 소재=유포(일반 완칼) 상품구분축)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1009 comp_price_id=2893
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2893, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000172', NULL, 'MAT_000153', NULL, NULL, 20, 3880, '낱장(완칼) 자유형 스티커/A4 제작수량≥20 (완칼 규격단독, 소재=유포(일반 완칼) 상품구분축)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1010 comp_price_id=2895
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2895, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000174', NULL, 'MAT_000153', NULL, NULL, 20, 7760, '낱장(완칼) 자유형 스티커/A3 제작수량≥20 (완칼 규격단독, 소재=유포(일반 완칼) 상품구분축)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1011 comp_price_id=2897
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2897, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000197', NULL, 'MAT_000153', NULL, NULL, 20, 15520, '낱장(완칼) 자유형 스티커/A2 제작수량≥20 (완칼 규격단독, 소재=유포(일반 완칼) 상품구분축)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1012 comp_price_id=2898
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2898, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000172', NULL, 'MAT_000153', NULL, NULL, 50, 3800, '낱장(완칼) 자유형 스티커/A4 제작수량≥50 (완칼 규격단독, 소재=유포(일반 완칼) 상품구분축)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1013 comp_price_id=2900
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2900, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000174', NULL, 'MAT_000153', NULL, NULL, 50, 7600, '낱장(완칼) 자유형 스티커/A3 제작수량≥50 (완칼 규격단독, 소재=유포(일반 완칼) 상품구분축)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1014 comp_price_id=2902
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2902, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000197', NULL, 'MAT_000153', NULL, NULL, 50, 15200, '낱장(완칼) 자유형 스티커/A2 제작수량≥50 (완칼 규격단독, 소재=유포(일반 완칼) 상품구분축)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1015 comp_price_id=2903
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2903, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000172', NULL, 'MAT_000153', NULL, NULL, 100, 3600, '낱장(완칼) 자유형 스티커/A4 제작수량≥100 (완칼 규격단독, 소재=유포(일반 완칼) 상품구분축)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1016 comp_price_id=2905
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2905, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000174', NULL, 'MAT_000153', NULL, NULL, 100, 7200, '낱장(완칼) 자유형 스티커/A3 제작수량≥100 (완칼 규격단독, 소재=유포(일반 완칼) 상품구분축)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1017 comp_price_id=2907
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2907, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000197', NULL, 'MAT_000153', NULL, NULL, 100, 14400, '낱장(완칼) 자유형 스티커/A2 제작수량≥100 (완칼 규격단독, 소재=유포(일반 완칼) 상품구분축)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1018 comp_price_id=2908
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2908, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000172', NULL, 'MAT_000153', NULL, NULL, 200, 3400, '낱장(완칼) 자유형 스티커/A4 제작수량≥200 (완칼 규격단독, 소재=유포(일반 완칼) 상품구분축)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1019 comp_price_id=2910
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2910, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000174', NULL, 'MAT_000153', NULL, NULL, 200, 6800, '낱장(완칼) 자유형 스티커/A3 제작수량≥200 (완칼 규격단독, 소재=유포(일반 완칼) 상품구분축)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1020 comp_price_id=2912
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2912, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000197', NULL, 'MAT_000153', NULL, NULL, 200, 13600, '낱장(완칼) 자유형 스티커/A2 제작수량≥200 (완칼 규격단독, 소재=유포(일반 완칼) 상품구분축)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1021 comp_price_id=2913
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2913, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000172', NULL, 'MAT_000153', NULL, NULL, 300, 3200, '낱장(완칼) 자유형 스티커/A4 제작수량≥300 (완칼 규격단독, 소재=유포(일반 완칼) 상품구분축)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1022 comp_price_id=2915
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2915, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000174', NULL, 'MAT_000153', NULL, NULL, 300, 6400, '낱장(완칼) 자유형 스티커/A3 제작수량≥300 (완칼 규격단독, 소재=유포(일반 완칼) 상품구분축)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1023 comp_price_id=2917
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2917, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000197', NULL, 'MAT_000153', NULL, NULL, 300, 12800, '낱장(완칼) 자유형 스티커/A2 제작수량≥300 (완칼 규격단독, 소재=유포(일반 완칼) 상품구분축)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1024 comp_price_id=2918
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2918, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000172', NULL, 'MAT_000170', NULL, NULL, 1, 7000, '낱장(완칼) 자유형 투명스티커/A4 제작수량≥1 (완칼 규격단독, 소재=투명데드롱(투명 완칼) 상품구분축)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1025 comp_price_id=2920
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2920, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000174', NULL, 'MAT_000170', NULL, NULL, 1, 14000, '낱장(완칼) 자유형 투명스티커/A3 제작수량≥1 (완칼 규격단독, 소재=투명데드롱(투명 완칼) 상품구분축)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1026 comp_price_id=2922
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2922, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000197', NULL, 'MAT_000170', NULL, NULL, 1, 28000, '낱장(완칼) 자유형 투명스티커/A2 제작수량≥1 (완칼 규격단독, 소재=투명데드롱(투명 완칼) 상품구분축)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1027 comp_price_id=2923
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2923, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000172', NULL, 'MAT_000170', NULL, NULL, 20, 6790, '낱장(완칼) 자유형 투명스티커/A4 제작수량≥20 (완칼 규격단독, 소재=투명데드롱(투명 완칼) 상품구분축)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1028 comp_price_id=2925
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2925, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000174', NULL, 'MAT_000170', NULL, NULL, 20, 13580, '낱장(완칼) 자유형 투명스티커/A3 제작수량≥20 (완칼 규격단독, 소재=투명데드롱(투명 완칼) 상품구분축)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1029 comp_price_id=2927
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2927, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000197', NULL, 'MAT_000170', NULL, NULL, 20, 27160, '낱장(완칼) 자유형 투명스티커/A2 제작수량≥20 (완칼 규격단독, 소재=투명데드롱(투명 완칼) 상품구분축)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1030 comp_price_id=2928
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2928, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000172', NULL, 'MAT_000170', NULL, NULL, 50, 6650, '낱장(완칼) 자유형 투명스티커/A4 제작수량≥50 (완칼 규격단독, 소재=투명데드롱(투명 완칼) 상품구분축)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1031 comp_price_id=2930
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2930, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000174', NULL, 'MAT_000170', NULL, NULL, 50, 13300, '낱장(완칼) 자유형 투명스티커/A3 제작수량≥50 (완칼 규격단독, 소재=투명데드롱(투명 완칼) 상품구분축)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1032 comp_price_id=2932
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2932, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000197', NULL, 'MAT_000170', NULL, NULL, 50, 26600, '낱장(완칼) 자유형 투명스티커/A2 제작수량≥50 (완칼 규격단독, 소재=투명데드롱(투명 완칼) 상품구분축)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1033 comp_price_id=2933
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2933, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000172', NULL, 'MAT_000170', NULL, NULL, 100, 6300, '낱장(완칼) 자유형 투명스티커/A4 제작수량≥100 (완칼 규격단독, 소재=투명데드롱(투명 완칼) 상품구분축)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1034 comp_price_id=2935
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2935, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000174', NULL, 'MAT_000170', NULL, NULL, 100, 12600, '낱장(완칼) 자유형 투명스티커/A3 제작수량≥100 (완칼 규격단독, 소재=투명데드롱(투명 완칼) 상품구분축)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1035 comp_price_id=2937
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2937, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000197', NULL, 'MAT_000170', NULL, NULL, 100, 25200, '낱장(완칼) 자유형 투명스티커/A2 제작수량≥100 (완칼 규격단독, 소재=투명데드롱(투명 완칼) 상품구분축)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1036 comp_price_id=2938
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2938, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000172', NULL, 'MAT_000170', NULL, NULL, 200, 5950, '낱장(완칼) 자유형 투명스티커/A4 제작수량≥200 (완칼 규격단독, 소재=투명데드롱(투명 완칼) 상품구분축)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1037 comp_price_id=2940
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2940, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000174', NULL, 'MAT_000170', NULL, NULL, 200, 11900, '낱장(완칼) 자유형 투명스티커/A3 제작수량≥200 (완칼 규격단독, 소재=투명데드롱(투명 완칼) 상품구분축)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1038 comp_price_id=2942
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2942, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000197', NULL, 'MAT_000170', NULL, NULL, 200, 23800, '낱장(완칼) 자유형 투명스티커/A2 제작수량≥200 (완칼 규격단독, 소재=투명데드롱(투명 완칼) 상품구분축)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1039 comp_price_id=2943
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2943, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000172', NULL, 'MAT_000170', NULL, NULL, 300, 5600, '낱장(완칼) 자유형 투명스티커/A4 제작수량≥300 (완칼 규격단독, 소재=투명데드롱(투명 완칼) 상품구분축)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1040 comp_price_id=2945
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2945, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000174', NULL, 'MAT_000170', NULL, NULL, 300, 11200, '낱장(완칼) 자유형 투명스티커/A3 제작수량≥300 (완칼 규격단독, 소재=투명데드롱(투명 완칼) 상품구분축)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1041 comp_price_id=2947
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2947, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000197', NULL, 'MAT_000170', NULL, NULL, 300, 22400, '낱장(완칼) 자유형 투명스티커/A2 제작수량≥300 (완칼 규격단독, 소재=투명데드롱(투명 완칼) 상품구분축)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1042 comp_price_id=2948
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2948, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000199', NULL, 'MAT_000153', NULL, NULL, 1, 16000, '대형(완칼) 자유형 스티커/400x600 제작수량≥1 (완칼 규격단독, 소재=유포(대형 완칼) 상품구분축)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1043 comp_price_id=2949
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2949, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000199', NULL, 'MAT_000153', NULL, NULL, 20, 15520, '대형(완칼) 자유형 스티커/400x600 제작수량≥20 (완칼 규격단독, 소재=유포(대형 완칼) 상품구분축)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1044 comp_price_id=2950
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2950, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000199', NULL, 'MAT_000153', NULL, NULL, 50, 15200, '대형(완칼) 자유형 스티커/400x600 제작수량≥50 (완칼 규격단독, 소재=유포(대형 완칼) 상품구분축)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1045 comp_price_id=2951
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2951, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000199', NULL, 'MAT_000153', NULL, NULL, 100, 14400, '대형(완칼) 자유형 스티커/400x600 제작수량≥100 (완칼 규격단독, 소재=유포(대형 완칼) 상품구분축)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1046 comp_price_id=2952
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2952, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000199', NULL, 'MAT_000153', NULL, NULL, 200, 13600, '대형(완칼) 자유형 스티커/400x600 제작수량≥200 (완칼 규격단독, 소재=유포(대형 완칼) 상품구분축)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1047 comp_price_id=2953
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2953, 'COMP_STK_PRINT', '2026-06-01', 'SIZ_000199', NULL, 'MAT_000153', NULL, NULL, 300, 12800, '대형(완칼) 자유형 스티커/400x600 제작수량≥300 (완칼 규격단독, 소재=유포(대형 완칼) 상품구분축)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1048 comp_price_id=2954
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2954, 'COMP_STK_PACK', '2026-06-01', 'SIZ_000068', NULL, NULL, NULL, NULL, 1, 4000, '스티커팩(54장1세트)/75x110 수량≥1 (세트단위, 1세트=54장)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1049 comp_price_id=2955
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (2955, 'COMP_STK_PACK', '2026-06-01', 'SIZ_000068', NULL, NULL, NULL, NULL, 1000, 4000, '스티커팩(54장1세트)/75x110 수량≥1000 (세트단위, 1세트=54장)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1050 comp_price_id=3066
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3066, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000212', NULL, 'MAT_000084', NULL, NULL, 1000, 20000, '정사각 10 x 10mm/비코팅/무광코팅/유광코팅 제작수량≥1000 (라이브 siz SIZ_000212 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1051 comp_price_id=3067
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3067, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000212', NULL, 'MAT_000153', NULL, NULL, 1000, 26100, '정사각 10 x 10mm/유포/투명데드롱/은데드롱 제작수량≥1000 (라이브 siz SIZ_000212 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1052 comp_price_id=3068
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3068, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000213', NULL, 'MAT_000084', NULL, NULL, 1000, 20600, '정사각 15 x 15mm/비코팅/무광코팅/유광코팅 제작수량≥1000 (라이브 siz SIZ_000213 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1053 comp_price_id=3069
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3069, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000213', NULL, 'MAT_000153', NULL, NULL, 1000, 27200, '정사각 15 x 15mm/유포/투명데드롱/은데드롱 제작수량≥1000 (라이브 siz SIZ_000213 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1054 comp_price_id=3070
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3070, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000214', NULL, 'MAT_000084', NULL, NULL, 1000, 21500, '정사각 20 x 20mm/비코팅/무광코팅/유광코팅 제작수량≥1000 (라이브 siz SIZ_000214 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1055 comp_price_id=3071
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3071, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000214', NULL, 'MAT_000153', NULL, NULL, 1000, 28500, '정사각 20 x 20mm/유포/투명데드롱/은데드롱 제작수량≥1000 (라이브 siz SIZ_000214 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1056 comp_price_id=3072
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3072, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000215', NULL, 'MAT_000084', NULL, NULL, 1000, 20000, '정사각 25 x 25mm/비코팅/무광코팅/유광코팅 제작수량≥1000 (라이브 siz SIZ_000215 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1057 comp_price_id=3073
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3073, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000215', NULL, 'MAT_000153', NULL, NULL, 1000, 26100, '정사각 25 x 25mm/유포/투명데드롱/은데드롱 제작수량≥1000 (라이브 siz SIZ_000215 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1058 comp_price_id=3074
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3074, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000216', NULL, 'MAT_000084', NULL, NULL, 1000, 20000, '정사각 30 x 30mm/비코팅/무광코팅/유광코팅 제작수량≥1000 (라이브 siz SIZ_000216 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1059 comp_price_id=3075
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3075, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000216', NULL, 'MAT_000153', NULL, NULL, 1000, 26100, '정사각 30 x 30mm/유포/투명데드롱/은데드롱 제작수량≥1000 (라이브 siz SIZ_000216 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1060 comp_price_id=3076
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3076, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000217', NULL, 'MAT_000084', NULL, NULL, 1000, 20600, '정사각 35 x 35mm/비코팅/무광코팅/유광코팅 제작수량≥1000 (라이브 siz SIZ_000217 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1061 comp_price_id=3077
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3077, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000217', NULL, 'MAT_000153', NULL, NULL, 1000, 27200, '정사각 35 x 35mm/유포/투명데드롱/은데드롱 제작수량≥1000 (라이브 siz SIZ_000217 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1062 comp_price_id=3078
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3078, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000218', NULL, 'MAT_000084', NULL, NULL, 1000, 24000, '정사각 40 x 40mm/비코팅/무광코팅/유광코팅 제작수량≥1000 (라이브 siz SIZ_000218 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1063 comp_price_id=3079
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3079, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000218', NULL, 'MAT_000153', NULL, NULL, 1000, 33300, '정사각 40 x 40mm/유포/투명데드롱/은데드롱 제작수량≥1000 (라이브 siz SIZ_000218 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1064 comp_price_id=3080
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3080, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000219', NULL, 'MAT_000084', NULL, NULL, 1000, 18500, '정사각 45 x 45mm/비코팅/무광코팅/유광코팅 제작수량≥1000 (라이브 siz SIZ_000219 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1065 comp_price_id=3081
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3081, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000219', NULL, 'MAT_000153', NULL, NULL, 1000, 23500, '정사각 45 x 45mm/유포/투명데드롱/은데드롱 제작수량≥1000 (라이브 siz SIZ_000219 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1066 comp_price_id=3082
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3082, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000220', NULL, 'MAT_000084', NULL, NULL, 1000, 20300, '정사각 50 x 50mm/비코팅/무광코팅/유광코팅 제작수량≥1000 (라이브 siz SIZ_000220 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1067 comp_price_id=3083
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3083, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000220', NULL, 'MAT_000153', NULL, NULL, 1000, 26700, '정사각 50 x 50mm/유포/투명데드롱/은데드롱 제작수량≥1000 (라이브 siz SIZ_000220 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1068 comp_price_id=3084
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3084, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000221', NULL, 'MAT_000084', NULL, NULL, 1000, 22000, '정사각 55 x 55mm/비코팅/무광코팅/유광코팅 제작수량≥1000 (라이브 siz SIZ_000221 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1069 comp_price_id=3085
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3085, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000221', NULL, 'MAT_000153', NULL, NULL, 1000, 29500, '정사각 55 x 55mm/유포/투명데드롱/은데드롱 제작수량≥1000 (라이브 siz SIZ_000221 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1070 comp_price_id=3086
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3086, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000222', NULL, 'MAT_000084', NULL, NULL, 1000, 24000, '정사각 60 x 60mm/비코팅/무광코팅/유광코팅 제작수량≥1000 (라이브 siz SIZ_000222 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1071 comp_price_id=3087
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3087, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000222', NULL, 'MAT_000153', NULL, NULL, 1000, 33300, '정사각 60 x 60mm/유포/투명데드롱/은데드롱 제작수량≥1000 (라이브 siz SIZ_000222 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1072 comp_price_id=3088
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3088, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000223', NULL, 'MAT_000084', NULL, NULL, 1000, 35000, '정사각 90 x 90mm/비코팅/무광코팅/유광코팅 제작수량≥1000 (라이브 siz SIZ_000223 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1073 comp_price_id=3089
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3089, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000223', NULL, 'MAT_000153', NULL, NULL, 1000, 52200, '정사각 90 x 90mm/유포/투명데드롱/은데드롱 제작수량≥1000 (라이브 siz SIZ_000223 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1074 comp_price_id=3090
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3090, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000212', NULL, 'MAT_000084', NULL, NULL, 2000, 30000, '정사각 10 x 10mm/비코팅/무광코팅/유광코팅 제작수량≥2000 (라이브 siz SIZ_000212 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1075 comp_price_id=3091
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3091, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000212', NULL, 'MAT_000153', NULL, NULL, 2000, 39200, '정사각 10 x 10mm/유포/투명데드롱/은데드롱 제작수량≥2000 (라이브 siz SIZ_000212 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1076 comp_price_id=3092
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3092, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000213', NULL, 'MAT_000084', NULL, NULL, 2000, 30900, '정사각 15 x 15mm/비코팅/무광코팅/유광코팅 제작수량≥2000 (라이브 siz SIZ_000213 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1077 comp_price_id=3093
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3093, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000213', NULL, 'MAT_000153', NULL, NULL, 2000, 41500, '정사각 15 x 15mm/유포/투명데드롱/은데드롱 제작수량≥2000 (라이브 siz SIZ_000213 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1078 comp_price_id=3094
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3094, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000214', NULL, 'MAT_000084', NULL, NULL, 2000, 32500, '정사각 20 x 20mm/비코팅/무광코팅/유광코팅 제작수량≥2000 (라이브 siz SIZ_000214 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1079 comp_price_id=3095
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3095, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000214', NULL, 'MAT_000153', NULL, NULL, 2000, 46300, '정사각 20 x 20mm/유포/투명데드롱/은데드롱 제작수량≥2000 (라이브 siz SIZ_000214 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1080 comp_price_id=3096
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3096, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000215', NULL, 'MAT_000084', NULL, NULL, 2000, 30000, '정사각 25 x 25mm/비코팅/무광코팅/유광코팅 제작수량≥2000 (라이브 siz SIZ_000215 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1081 comp_price_id=3097
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3097, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000215', NULL, 'MAT_000153', NULL, NULL, 2000, 39200, '정사각 25 x 25mm/유포/투명데드롱/은데드롱 제작수량≥2000 (라이브 siz SIZ_000215 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1082 comp_price_id=3098
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3098, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000216', NULL, 'MAT_000084', NULL, NULL, 2000, 30000, '정사각 30 x 30mm/비코팅/무광코팅/유광코팅 제작수량≥2000 (라이브 siz SIZ_000216 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1083 comp_price_id=3099
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3099, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000216', NULL, 'MAT_000153', NULL, NULL, 2000, 39200, '정사각 30 x 30mm/유포/투명데드롱/은데드롱 제작수량≥2000 (라이브 siz SIZ_000216 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1084 comp_price_id=3100
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3100, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000217', NULL, 'MAT_000084', NULL, NULL, 2000, 30900, '정사각 35 x 35mm/비코팅/무광코팅/유광코팅 제작수량≥2000 (라이브 siz SIZ_000217 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1085 comp_price_id=3101
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3101, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000217', NULL, 'MAT_000153', NULL, NULL, 2000, 41500, '정사각 35 x 35mm/유포/투명데드롱/은데드롱 제작수량≥2000 (라이브 siz SIZ_000217 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1086 comp_price_id=3102
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3102, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000218', NULL, 'MAT_000084', NULL, NULL, 2000, 36000, '정사각 40 x 40mm/비코팅/무광코팅/유광코팅 제작수량≥2000 (라이브 siz SIZ_000218 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1087 comp_price_id=3103
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3103, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000218', NULL, 'MAT_000153', NULL, NULL, 2000, 54600, '정사각 40 x 40mm/유포/투명데드롱/은데드롱 제작수량≥2000 (라이브 siz SIZ_000218 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1088 comp_price_id=3104
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3104, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000219', NULL, 'MAT_000084', NULL, NULL, 2000, 28000, '정사각 45 x 45mm/비코팅/무광코팅/유광코팅 제작수량≥2000 (라이브 siz SIZ_000219 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1089 comp_price_id=3105
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3105, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000219', NULL, 'MAT_000153', NULL, NULL, 2000, 35600, '정사각 45 x 45mm/유포/투명데드롱/은데드롱 제작수량≥2000 (라이브 siz SIZ_000219 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1090 comp_price_id=3106
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3106, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000220', NULL, 'MAT_000084', NULL, NULL, 2000, 30500, '정사각 50 x 50mm/비코팅/무광코팅/유광코팅 제작수량≥2000 (라이브 siz SIZ_000220 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1091 comp_price_id=3107
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3107, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000220', NULL, 'MAT_000153', NULL, NULL, 2000, 39800, '정사각 50 x 50mm/유포/투명데드롱/은데드롱 제작수량≥2000 (라이브 siz SIZ_000220 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1092 comp_price_id=3108
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3108, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000221', NULL, 'MAT_000084', NULL, NULL, 2000, 33000, '정사각 55 x 55mm/비코팅/무광코팅/유광코팅 제작수량≥2000 (라이브 siz SIZ_000221 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1093 comp_price_id=3109
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3109, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000221', NULL, 'MAT_000153', NULL, NULL, 2000, 46300, '정사각 55 x 55mm/유포/투명데드롱/은데드롱 제작수량≥2000 (라이브 siz SIZ_000221 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1094 comp_price_id=3110
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3110, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000222', NULL, 'MAT_000084', NULL, NULL, 2000, 36000, '정사각 60 x 60mm/비코팅/무광코팅/유광코팅 제작수량≥2000 (라이브 siz SIZ_000222 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1095 comp_price_id=3111
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3111, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000222', NULL, 'MAT_000153', NULL, NULL, 2000, 54600, '정사각 60 x 60mm/유포/투명데드롱/은데드롱 제작수량≥2000 (라이브 siz SIZ_000222 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1096 comp_price_id=3112
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3112, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000223', NULL, 'MAT_000084', NULL, NULL, 2000, 70000, '정사각 90 x 90mm/비코팅/무광코팅/유광코팅 제작수량≥2000 (라이브 siz SIZ_000223 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1097 comp_price_id=3113
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3113, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000223', NULL, 'MAT_000153', NULL, NULL, 2000, 80700, '정사각 90 x 90mm/유포/투명데드롱/은데드롱 제작수량≥2000 (라이브 siz SIZ_000223 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1098 comp_price_id=3114
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3114, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000212', NULL, 'MAT_000084', NULL, NULL, 3000, 40000, '정사각 10 x 10mm/비코팅/무광코팅/유광코팅 제작수량≥3000 (라이브 siz SIZ_000212 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1099 comp_price_id=3115
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3115, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000212', NULL, 'MAT_000153', NULL, NULL, 3000, 52200, '정사각 10 x 10mm/유포/투명데드롱/은데드롱 제작수량≥3000 (라이브 siz SIZ_000212 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1100 comp_price_id=3116
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3116, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000213', NULL, 'MAT_000084', NULL, NULL, 3000, 41500, '정사각 15 x 15mm/비코팅/무광코팅/유광코팅 제작수량≥3000 (라이브 siz SIZ_000213 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1101 comp_price_id=3117
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3117, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000213', NULL, 'MAT_000153', NULL, NULL, 3000, 55600, '정사각 15 x 15mm/유포/투명데드롱/은데드롱 제작수량≥3000 (라이브 siz SIZ_000213 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1102 comp_price_id=3118
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3118, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000214', NULL, 'MAT_000084', NULL, NULL, 3000, 43000, '정사각 20 x 20mm/비코팅/무광코팅/유광코팅 제작수량≥3000 (라이브 siz SIZ_000214 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1103 comp_price_id=3119
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3119, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000214', NULL, 'MAT_000153', NULL, NULL, 3000, 62700, '정사각 20 x 20mm/유포/투명데드롱/은데드롱 제작수량≥3000 (라이브 siz SIZ_000214 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1104 comp_price_id=3120
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3120, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000215', NULL, 'MAT_000084', NULL, NULL, 3000, 40000, '정사각 25 x 25mm/비코팅/무광코팅/유광코팅 제작수량≥3000 (라이브 siz SIZ_000215 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1105 comp_price_id=3121
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3121, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000215', NULL, 'MAT_000153', NULL, NULL, 3000, 52200, '정사각 25 x 25mm/유포/투명데드롱/은데드롱 제작수량≥3000 (라이브 siz SIZ_000215 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1106 comp_price_id=3122
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3122, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000216', NULL, 'MAT_000084', NULL, NULL, 3000, 40000, '정사각 30 x 30mm/비코팅/무광코팅/유광코팅 제작수량≥3000 (라이브 siz SIZ_000216 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1107 comp_price_id=3123
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3123, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000216', NULL, 'MAT_000153', NULL, NULL, 3000, 52200, '정사각 30 x 30mm/유포/투명데드롱/은데드롱 제작수량≥3000 (라이브 siz SIZ_000216 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1108 comp_price_id=3124
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3124, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000217', NULL, 'MAT_000084', NULL, NULL, 3000, 41500, '정사각 35 x 35mm/비코팅/무광코팅/유광코팅 제작수량≥3000 (라이브 siz SIZ_000217 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1109 comp_price_id=3125
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3125, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000217', NULL, 'MAT_000153', NULL, NULL, 3000, 55600, '정사각 35 x 35mm/유포/투명데드롱/은데드롱 제작수량≥3000 (라이브 siz SIZ_000217 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1110 comp_price_id=3126
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3126, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000218', NULL, 'MAT_000084', NULL, NULL, 3000, 49000, '정사각 40 x 40mm/비코팅/무광코팅/유광코팅 제작수량≥3000 (라이브 siz SIZ_000218 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1111 comp_price_id=3127
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3127, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000218', NULL, 'MAT_000153', NULL, NULL, 3000, 75700, '정사각 40 x 40mm/유포/투명데드롱/은데드롱 제작수량≥3000 (라이브 siz SIZ_000218 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1112 comp_price_id=3128
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3128, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000219', NULL, 'MAT_000084', NULL, NULL, 3000, 37000, '정사각 45 x 45mm/비코팅/무광코팅/유광코팅 제작수량≥3000 (라이브 siz SIZ_000219 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1113 comp_price_id=3129
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3129, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000219', NULL, 'MAT_000153', NULL, NULL, 3000, 47300, '정사각 45 x 45mm/유포/투명데드롱/은데드롱 제작수량≥3000 (라이브 siz SIZ_000219 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1114 comp_price_id=3130
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3130, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000220', NULL, 'MAT_000084', NULL, NULL, 3000, 40600, '정사각 50 x 50mm/비코팅/무광코팅/유광코팅 제작수량≥3000 (라이브 siz SIZ_000220 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1115 comp_price_id=3131
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3131, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000220', NULL, 'MAT_000153', NULL, NULL, 3000, 52800, '정사각 50 x 50mm/유포/투명데드롱/은데드롱 제작수량≥3000 (라이브 siz SIZ_000220 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1116 comp_price_id=3132
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3132, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000221', NULL, 'MAT_000084', NULL, NULL, 3000, 44000, '정사각 55 x 55mm/비코팅/무광코팅/유광코팅 제작수량≥3000 (라이브 siz SIZ_000221 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1117 comp_price_id=3133
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3133, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000221', NULL, 'MAT_000153', NULL, NULL, 3000, 62700, '정사각 55 x 55mm/유포/투명데드롱/은데드롱 제작수량≥3000 (라이브 siz SIZ_000221 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1118 comp_price_id=3134
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3134, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000222', NULL, 'MAT_000084', NULL, NULL, 3000, 48000, '정사각 60 x 60mm/비코팅/무광코팅/유광코팅 제작수량≥3000 (라이브 siz SIZ_000222 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1119 comp_price_id=3135
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3135, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000222', NULL, 'MAT_000153', NULL, NULL, 3000, 75700, '정사각 60 x 60mm/유포/투명데드롱/은데드롱 제작수량≥3000 (라이브 siz SIZ_000222 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1120 comp_price_id=3136
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3136, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000223', NULL, 'MAT_000084', NULL, NULL, 3000, 95000, '정사각 90 x 90mm/비코팅/무광코팅/유광코팅 제작수량≥3000 (라이브 siz SIZ_000223 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1121 comp_price_id=3137
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3137, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000223', NULL, 'MAT_000153', NULL, NULL, 3000, 120800, '정사각 90 x 90mm/유포/투명데드롱/은데드롱 제작수량≥3000 (라이브 siz SIZ_000223 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1122 comp_price_id=3138
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3138, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000212', NULL, 'MAT_000084', NULL, NULL, 4000, 50000, '정사각 10 x 10mm/비코팅/무광코팅/유광코팅 제작수량≥4000 (라이브 siz SIZ_000212 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1123 comp_price_id=3139
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3139, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000212', NULL, 'MAT_000153', NULL, NULL, 4000, 65300, '정사각 10 x 10mm/유포/투명데드롱/은데드롱 제작수량≥4000 (라이브 siz SIZ_000212 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1124 comp_price_id=3140
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3140, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000213', NULL, 'MAT_000084', NULL, NULL, 4000, 51500, '정사각 15 x 15mm/비코팅/무광코팅/유광코팅 제작수량≥4000 (라이브 siz SIZ_000213 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1125 comp_price_id=3141
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3141, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000213', NULL, 'MAT_000153', NULL, NULL, 4000, 69900, '정사각 15 x 15mm/유포/투명데드롱/은데드롱 제작수량≥4000 (라이브 siz SIZ_000213 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1126 comp_price_id=3142
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3142, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000214', NULL, 'MAT_000084', NULL, NULL, 4000, 54000, '정사각 20 x 20mm/비코팅/무광코팅/유광코팅 제작수량≥4000 (라이브 siz SIZ_000214 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1127 comp_price_id=3143
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3143, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000214', NULL, 'MAT_000153', NULL, NULL, 4000, 79400, '정사각 20 x 20mm/유포/투명데드롱/은데드롱 제작수량≥4000 (라이브 siz SIZ_000214 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1128 comp_price_id=3144
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3144, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000215', NULL, 'MAT_000084', NULL, NULL, 4000, 50000, '정사각 25 x 25mm/비코팅/무광코팅/유광코팅 제작수량≥4000 (라이브 siz SIZ_000215 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1129 comp_price_id=3145
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3145, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000215', NULL, 'MAT_000153', NULL, NULL, 4000, 65300, '정사각 25 x 25mm/유포/투명데드롱/은데드롱 제작수량≥4000 (라이브 siz SIZ_000215 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1130 comp_price_id=3146
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3146, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000216', NULL, 'MAT_000084', NULL, NULL, 4000, 50000, '정사각 30 x 30mm/비코팅/무광코팅/유광코팅 제작수량≥4000 (라이브 siz SIZ_000216 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1131 comp_price_id=3147
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3147, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000216', NULL, 'MAT_000153', NULL, NULL, 4000, 65300, '정사각 30 x 30mm/유포/투명데드롱/은데드롱 제작수량≥4000 (라이브 siz SIZ_000216 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1132 comp_price_id=3148
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3148, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000217', NULL, 'MAT_000084', NULL, NULL, 4000, 51500, '정사각 35 x 35mm/비코팅/무광코팅/유광코팅 제작수량≥4000 (라이브 siz SIZ_000217 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1133 comp_price_id=3149
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3149, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000217', NULL, 'MAT_000153', NULL, NULL, 4000, 69900, '정사각 35 x 35mm/유포/투명데드롱/은데드롱 제작수량≥4000 (라이브 siz SIZ_000217 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1134 comp_price_id=3150
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3150, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000218', NULL, 'MAT_000084', NULL, NULL, 4000, 62000, '정사각 40 x 40mm/비코팅/무광코팅/유광코팅 제작수량≥4000 (라이브 siz SIZ_000218 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1135 comp_price_id=3151
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3151, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000218', NULL, 'MAT_000153', NULL, NULL, 4000, 97200, '정사각 40 x 40mm/유포/투명데드롱/은데드롱 제작수량≥4000 (라이브 siz SIZ_000218 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1136 comp_price_id=3152
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3152, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000219', NULL, 'MAT_000084', NULL, NULL, 4000, 46500, '정사각 45 x 45mm/비코팅/무광코팅/유광코팅 제작수량≥4000 (라이브 siz SIZ_000219 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1137 comp_price_id=3153
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3153, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000219', NULL, 'MAT_000153', NULL, NULL, 4000, 59400, '정사각 45 x 45mm/유포/투명데드롱/은데드롱 제작수량≥4000 (라이브 siz SIZ_000219 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1138 comp_price_id=3154
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3154, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000220', NULL, 'MAT_000084', NULL, NULL, 4000, 51000, '정사각 50 x 50mm/비코팅/무광코팅/유광코팅 제작수량≥4000 (라이브 siz SIZ_000220 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1139 comp_price_id=3155
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3155, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000220', NULL, 'MAT_000153', NULL, NULL, 4000, 65900, '정사각 50 x 50mm/유포/투명데드롱/은데드롱 제작수량≥4000 (라이브 siz SIZ_000220 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1140 comp_price_id=3156
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3156, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000221', NULL, 'MAT_000084', NULL, NULL, 4000, 55000, '정사각 55 x 55mm/비코팅/무광코팅/유광코팅 제작수량≥4000 (라이브 siz SIZ_000221 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1141 comp_price_id=3157
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3157, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000221', NULL, 'MAT_000153', NULL, NULL, 4000, 79400, '정사각 55 x 55mm/유포/투명데드롱/은데드롱 제작수량≥4000 (라이브 siz SIZ_000221 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1142 comp_price_id=3158
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3158, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000222', NULL, 'MAT_000084', NULL, NULL, 4000, 60000, '정사각 60 x 60mm/비코팅/무광코팅/유광코팅 제작수량≥4000 (라이브 siz SIZ_000222 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1143 comp_price_id=3159
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3159, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000222', NULL, 'MAT_000153', NULL, NULL, 4000, 97200, '정사각 60 x 60mm/유포/투명데드롱/은데드롱 제작수량≥4000 (라이브 siz SIZ_000222 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1144 comp_price_id=3160
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3160, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000223', NULL, 'MAT_000084', NULL, NULL, 4000, 120000, '정사각 90 x 90mm/비코팅/무광코팅/유광코팅 제작수량≥4000 (라이브 siz SIZ_000223 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1145 comp_price_id=3161
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3161, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000223', NULL, 'MAT_000153', NULL, NULL, 4000, 155300, '정사각 90 x 90mm/유포/투명데드롱/은데드롱 제작수량≥4000 (라이브 siz SIZ_000223 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1146 comp_price_id=3162
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3162, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000212', NULL, 'MAT_000084', NULL, NULL, 5000, 60000, '정사각 10 x 10mm/비코팅/무광코팅/유광코팅 제작수량≥5000 (라이브 siz SIZ_000212 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1147 comp_price_id=3163
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3163, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000212', NULL, 'MAT_000153', NULL, NULL, 5000, 78300, '정사각 10 x 10mm/유포/투명데드롱/은데드롱 제작수량≥5000 (라이브 siz SIZ_000212 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1148 comp_price_id=3164
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3164, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000213', NULL, 'MAT_000084', NULL, NULL, 5000, 62000, '정사각 15 x 15mm/비코팅/무광코팅/유광코팅 제작수량≥5000 (라이브 siz SIZ_000213 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1149 comp_price_id=3165
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3165, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000213', NULL, 'MAT_000153', NULL, NULL, 5000, 84100, '정사각 15 x 15mm/유포/투명데드롱/은데드롱 제작수량≥5000 (라이브 siz SIZ_000213 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1150 comp_price_id=3166
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3166, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000214', NULL, 'MAT_000084', NULL, NULL, 5000, 64500, '정사각 20 x 20mm/비코팅/무광코팅/유광코팅 제작수량≥5000 (라이브 siz SIZ_000214 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1151 comp_price_id=3167
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3167, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000214', NULL, 'MAT_000153', NULL, NULL, 5000, 96000, '정사각 20 x 20mm/유포/투명데드롱/은데드롱 제작수량≥5000 (라이브 siz SIZ_000214 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1152 comp_price_id=3168
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3168, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000215', NULL, 'MAT_000084', NULL, NULL, 5000, 60000, '정사각 25 x 25mm/비코팅/무광코팅/유광코팅 제작수량≥5000 (라이브 siz SIZ_000215 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1153 comp_price_id=3169
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3169, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000215', NULL, 'MAT_000153', NULL, NULL, 5000, 78300, '정사각 25 x 25mm/유포/투명데드롱/은데드롱 제작수량≥5000 (라이브 siz SIZ_000215 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1154 comp_price_id=3170
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3170, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000216', NULL, 'MAT_000084', NULL, NULL, 5000, 60000, '정사각 30 x 30mm/비코팅/무광코팅/유광코팅 제작수량≥5000 (라이브 siz SIZ_000216 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1155 comp_price_id=3171
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3171, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000216', NULL, 'MAT_000153', NULL, NULL, 5000, 78300, '정사각 30 x 30mm/유포/투명데드롱/은데드롱 제작수량≥5000 (라이브 siz SIZ_000216 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1156 comp_price_id=3172
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3172, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000217', NULL, 'MAT_000084', NULL, NULL, 5000, 62000, '정사각 35 x 35mm/비코팅/무광코팅/유광코팅 제작수량≥5000 (라이브 siz SIZ_000217 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1157 comp_price_id=3173
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3173, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000217', NULL, 'MAT_000153', NULL, NULL, 5000, 84100, '정사각 35 x 35mm/유포/투명데드롱/은데드롱 제작수량≥5000 (라이브 siz SIZ_000217 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1158 comp_price_id=3174
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3174, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000218', NULL, 'MAT_000084', NULL, NULL, 5000, 76000, '정사각 40 x 40mm/비코팅/무광코팅/유광코팅 제작수량≥5000 (라이브 siz SIZ_000218 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1159 comp_price_id=3175
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3175, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000218', NULL, 'MAT_000153', NULL, NULL, 5000, 118500, '정사각 40 x 40mm/유포/투명데드롱/은데드롱 제작수량≥5000 (라이브 siz SIZ_000218 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1160 comp_price_id=3176
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3176, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000219', NULL, 'MAT_000084', NULL, NULL, 5000, 55500, '정사각 45 x 45mm/비코팅/무광코팅/유광코팅 제작수량≥5000 (라이브 siz SIZ_000219 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1161 comp_price_id=3177
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3177, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000219', NULL, 'MAT_000153', NULL, NULL, 5000, 71100, '정사각 45 x 45mm/유포/투명데드롱/은데드롱 제작수량≥5000 (라이브 siz SIZ_000219 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1162 comp_price_id=3178
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3178, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000220', NULL, 'MAT_000084', NULL, NULL, 5000, 61000, '정사각 50 x 50mm/비코팅/무광코팅/유광코팅 제작수량≥5000 (라이브 siz SIZ_000220 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1163 comp_price_id=3179
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3179, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000220', NULL, 'MAT_000153', NULL, NULL, 5000, 78900, '정사각 50 x 50mm/유포/투명데드롱/은데드롱 제작수량≥5000 (라이브 siz SIZ_000220 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1164 comp_price_id=3180
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3180, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000221', NULL, 'MAT_000084', NULL, NULL, 5000, 66000, '정사각 55 x 55mm/비코팅/무광코팅/유광코팅 제작수량≥5000 (라이브 siz SIZ_000221 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1165 comp_price_id=3181
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3181, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000221', NULL, 'MAT_000153', NULL, NULL, 5000, 96000, '정사각 55 x 55mm/유포/투명데드롱/은데드롱 제작수량≥5000 (라이브 siz SIZ_000221 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1166 comp_price_id=3182
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3182, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000222', NULL, 'MAT_000084', NULL, NULL, 5000, 72000, '정사각 60 x 60mm/비코팅/무광코팅/유광코팅 제작수량≥5000 (라이브 siz SIZ_000222 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1167 comp_price_id=3183
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3183, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000222', NULL, 'MAT_000153', NULL, NULL, 5000, 118500, '정사각 60 x 60mm/유포/투명데드롱/은데드롱 제작수량≥5000 (라이브 siz SIZ_000222 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1168 comp_price_id=3184
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3184, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000223', NULL, 'MAT_000084', NULL, NULL, 5000, 150000, '정사각 90 x 90mm/비코팅/무광코팅/유광코팅 제작수량≥5000 (라이브 siz SIZ_000223 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1169 comp_price_id=3185
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3185, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000223', NULL, 'MAT_000153', NULL, NULL, 5000, 189900, '정사각 90 x 90mm/유포/투명데드롱/은데드롱 제작수량≥5000 (라이브 siz SIZ_000223 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1170 comp_price_id=3186
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3186, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000224', NULL, 'MAT_000084', NULL, NULL, 1000, 18000, '직사각 35 x 25mm/비코팅/무광코팅/유광코팅 제작수량≥1000 (라이브 siz SIZ_000224 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1171 comp_price_id=3187
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3187, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000224', NULL, 'MAT_000153', NULL, NULL, 1000, 22500, '직사각 35 x 25mm/유포/투명데드롱/은데드롱 제작수량≥1000 (라이브 siz SIZ_000224 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1172 comp_price_id=3188
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3188, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000226', NULL, 'MAT_000084', NULL, NULL, 1000, 22000, '직사각 40 x 30mm/비코팅/무광코팅/유광코팅 제작수량≥1000 (라이브 siz SIZ_000226 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1173 comp_price_id=3189
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3189, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000226', NULL, 'MAT_000153', NULL, NULL, 1000, 29500, '직사각 40 x 30mm/유포/투명데드롱/은데드롱 제작수량≥1000 (라이브 siz SIZ_000226 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1174 comp_price_id=3190
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3190, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000228', NULL, 'MAT_000084', NULL, NULL, 1000, 18000, '직사각 42 x 20mm/비코팅/무광코팅/유광코팅 제작수량≥1000 (라이브 siz SIZ_000228 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1175 comp_price_id=3191
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3191, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000228', NULL, 'MAT_000153', NULL, NULL, 1000, 22500, '직사각 42 x 20mm/유포/투명데드롱/은데드롱 제작수량≥1000 (라이브 siz SIZ_000228 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1176 comp_price_id=3192
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3192, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000230', NULL, 'MAT_000084', NULL, NULL, 1000, 20000, '직사각 50 x 20mm/비코팅/무광코팅/유광코팅 제작수량≥1000 (라이브 siz SIZ_000230 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1177 comp_price_id=3193
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3193, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000230', NULL, 'MAT_000153', NULL, NULL, 1000, 26100, '직사각 50 x 20mm/유포/투명데드롱/은데드롱 제작수량≥1000 (라이브 siz SIZ_000230 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1178 comp_price_id=3194
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3194, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000232', NULL, 'MAT_000084', NULL, NULL, 1000, 22000, '직사각 50 x 30mm/비코팅/무광코팅/유광코팅 제작수량≥1000 (라이브 siz SIZ_000232 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1179 comp_price_id=3195
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3195, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000232', NULL, 'MAT_000153', NULL, NULL, 1000, 29500, '직사각 50 x 30mm/유포/투명데드롱/은데드롱 제작수량≥1000 (라이브 siz SIZ_000232 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1180 comp_price_id=3196
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3196, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000234', NULL, 'MAT_000084', NULL, NULL, 1000, 18000, '직사각 55 x 15mm/비코팅/무광코팅/유광코팅 제작수량≥1000 (라이브 siz SIZ_000234 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1181 comp_price_id=3197
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3197, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000234', NULL, 'MAT_000153', NULL, NULL, 1000, 22500, '직사각 55 x 15mm/유포/투명데드롱/은데드롱 제작수량≥1000 (라이브 siz SIZ_000234 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1182 comp_price_id=3198
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3198, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000236', NULL, 'MAT_000084', NULL, NULL, 1000, 20300, '직사각 55 x 20mm/비코팅/무광코팅/유광코팅 제작수량≥1000 (라이브 siz SIZ_000236 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1183 comp_price_id=3199
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3199, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000236', NULL, 'MAT_000153', NULL, NULL, 1000, 26700, '직사각 55 x 20mm/유포/투명데드롱/은데드롱 제작수량≥1000 (라이브 siz SIZ_000236 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1184 comp_price_id=3200
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3200, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000238', NULL, 'MAT_000084', NULL, NULL, 1000, 22000, '직사각 55 x 24mm/비코팅/무광코팅/유광코팅 제작수량≥1000 (라이브 siz SIZ_000238 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1185 comp_price_id=3201
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3201, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000238', NULL, 'MAT_000153', NULL, NULL, 1000, 29500, '직사각 55 x 24mm/유포/투명데드롱/은데드롱 제작수량≥1000 (라이브 siz SIZ_000238 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1186 comp_price_id=3202
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3202, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000240', NULL, 'MAT_000084', NULL, NULL, 1000, 22000, '직사각 55 x 33mm/비코팅/무광코팅/유광코팅 제작수량≥1000 (라이브 siz SIZ_000240 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1187 comp_price_id=3203
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3203, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000240', NULL, 'MAT_000153', NULL, NULL, 1000, 29500, '직사각 55 x 33mm/유포/투명데드롱/은데드롱 제작수량≥1000 (라이브 siz SIZ_000240 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1188 comp_price_id=3204
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3204, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000242', NULL, 'MAT_000084', NULL, NULL, 1000, 21500, '직사각 90 x 40mm/비코팅/무광코팅/유광코팅 제작수량≥1000 (라이브 siz SIZ_000242 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1189 comp_price_id=3205
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3205, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000242', NULL, 'MAT_000153', NULL, NULL, 1000, 28500, '직사각 90 x 40mm/유포/투명데드롱/은데드롱 제작수량≥1000 (라이브 siz SIZ_000242 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1190 comp_price_id=3206
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3206, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000244', NULL, 'MAT_000084', NULL, NULL, 1000, 24000, '직사각 90 x 50mm/비코팅/무광코팅/유광코팅 제작수량≥1000 (라이브 siz SIZ_000244 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1191 comp_price_id=3207
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3207, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000244', NULL, 'MAT_000153', NULL, NULL, 1000, 33300, '직사각 90 x 50mm/유포/투명데드롱/은데드롱 제작수량≥1000 (라이브 siz SIZ_000244 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1192 comp_price_id=3208
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3208, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000245', NULL, 'MAT_000084', NULL, NULL, 1000, 27000, '직사각 90 x 60mm/비코팅/무광코팅/유광코팅 제작수량≥1000 (라이브 siz SIZ_000245 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1193 comp_price_id=3209
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3209, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000245', NULL, 'MAT_000153', NULL, NULL, 1000, 37900, '직사각 90 x 60mm/유포/투명데드롱/은데드롱 제작수량≥1000 (라이브 siz SIZ_000245 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1194 comp_price_id=3210
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3210, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000247', NULL, 'MAT_000084', NULL, NULL, 1000, 29500, '직사각 90 x 70mm/비코팅/무광코팅/유광코팅 제작수량≥1000 (라이브 siz SIZ_000247 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1195 comp_price_id=3211
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3211, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000247', NULL, 'MAT_000153', NULL, NULL, 1000, 42500, '직사각 90 x 70mm/유포/투명데드롱/은데드롱 제작수량≥1000 (라이브 siz SIZ_000247 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1196 comp_price_id=3212
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3212, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000249', NULL, 'MAT_000084', NULL, NULL, 1000, 32000, '직사각 90 x 80mm/비코팅/무광코팅/유광코팅 제작수량≥1000 (라이브 siz SIZ_000249 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1197 comp_price_id=3213
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3213, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000249', NULL, 'MAT_000153', NULL, NULL, 1000, 47300, '직사각 90 x 80mm/유포/투명데드롱/은데드롱 제작수량≥1000 (라이브 siz SIZ_000249 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1198 comp_price_id=3214
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3214, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000224', NULL, 'MAT_000084', NULL, NULL, 2000, 27000, '직사각 35 x 25mm/비코팅/무광코팅/유광코팅 제작수량≥2000 (라이브 siz SIZ_000224 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1199 comp_price_id=3215
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3215, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000224', NULL, 'MAT_000153', NULL, NULL, 2000, 34300, '직사각 35 x 25mm/유포/투명데드롱/은데드롱 제작수량≥2000 (라이브 siz SIZ_000224 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1200 comp_price_id=3216
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3216, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000226', NULL, 'MAT_000084', NULL, NULL, 2000, 33000, '직사각 40 x 30mm/비코팅/무광코팅/유광코팅 제작수량≥2000 (라이브 siz SIZ_000226 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1201 comp_price_id=3217
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3217, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000226', NULL, 'MAT_000153', NULL, NULL, 2000, 46300, '직사각 40 x 30mm/유포/투명데드롱/은데드롱 제작수량≥2000 (라이브 siz SIZ_000226 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1202 comp_price_id=3218
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3218, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000228', NULL, 'MAT_000084', NULL, NULL, 2000, 27000, '직사각 42 x 20mm/비코팅/무광코팅/유광코팅 제작수량≥2000 (라이브 siz SIZ_000228 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1203 comp_price_id=3219
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3219, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000228', NULL, 'MAT_000153', NULL, NULL, 2000, 34300, '직사각 42 x 20mm/유포/투명데드롱/은데드롱 제작수량≥2000 (라이브 siz SIZ_000228 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1204 comp_price_id=3220
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3220, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000230', NULL, 'MAT_000084', NULL, NULL, 2000, 30000, '직사각 50 x 20mm/비코팅/무광코팅/유광코팅 제작수량≥2000 (라이브 siz SIZ_000230 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1205 comp_price_id=3221
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3221, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000230', NULL, 'MAT_000153', NULL, NULL, 2000, 39200, '직사각 50 x 20mm/유포/투명데드롱/은데드롱 제작수량≥2000 (라이브 siz SIZ_000230 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1206 comp_price_id=3222
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3222, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000232', NULL, 'MAT_000084', NULL, NULL, 2000, 33000, '직사각 50 x 30mm/비코팅/무광코팅/유광코팅 제작수량≥2000 (라이브 siz SIZ_000232 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1207 comp_price_id=3223
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3223, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000232', NULL, 'MAT_000153', NULL, NULL, 2000, 46300, '직사각 50 x 30mm/유포/투명데드롱/은데드롱 제작수량≥2000 (라이브 siz SIZ_000232 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1208 comp_price_id=3224
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3224, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000234', NULL, 'MAT_000084', NULL, NULL, 2000, 27000, '직사각 55 x 15mm/비코팅/무광코팅/유광코팅 제작수량≥2000 (라이브 siz SIZ_000234 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1209 comp_price_id=3225
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3225, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000234', NULL, 'MAT_000153', NULL, NULL, 2000, 34300, '직사각 55 x 15mm/유포/투명데드롱/은데드롱 제작수량≥2000 (라이브 siz SIZ_000234 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1210 comp_price_id=3226
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3226, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000236', NULL, 'MAT_000084', NULL, NULL, 2000, 30500, '직사각 55 x 20mm/비코팅/무광코팅/유광코팅 제작수량≥2000 (라이브 siz SIZ_000236 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1211 comp_price_id=3227
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3227, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000236', NULL, 'MAT_000153', NULL, NULL, 2000, 39800, '직사각 55 x 20mm/유포/투명데드롱/은데드롱 제작수량≥2000 (라이브 siz SIZ_000236 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1212 comp_price_id=3228
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3228, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000238', NULL, 'MAT_000084', NULL, NULL, 2000, 33000, '직사각 55 x 24mm/비코팅/무광코팅/유광코팅 제작수량≥2000 (라이브 siz SIZ_000238 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1213 comp_price_id=3229
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3229, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000238', NULL, 'MAT_000153', NULL, NULL, 2000, 46300, '직사각 55 x 24mm/유포/투명데드롱/은데드롱 제작수량≥2000 (라이브 siz SIZ_000238 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1214 comp_price_id=3230
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3230, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000240', NULL, 'MAT_000084', NULL, NULL, 2000, 33000, '직사각 55 x 33mm/비코팅/무광코팅/유광코팅 제작수량≥2000 (라이브 siz SIZ_000240 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1215 comp_price_id=3231
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3231, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000240', NULL, 'MAT_000153', NULL, NULL, 2000, 46300, '직사각 55 x 33mm/유포/투명데드롱/은데드롱 제작수량≥2000 (라이브 siz SIZ_000240 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1216 comp_price_id=3232
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3232, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000242', NULL, 'MAT_000084', NULL, NULL, 2000, 43000, '직사각 90 x 40mm/비코팅/무광코팅/유광코팅 제작수량≥2000 (라이브 siz SIZ_000242 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1217 comp_price_id=3233
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3233, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000242', NULL, 'MAT_000153', NULL, NULL, 2000, 56900, '직사각 90 x 40mm/유포/투명데드롱/은데드롱 제작수량≥2000 (라이브 siz SIZ_000242 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1218 comp_price_id=3234
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3234, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000244', NULL, 'MAT_000084', NULL, NULL, 2000, 48000, '직사각 90 x 50mm/비코팅/무광코팅/유광코팅 제작수량≥2000 (라이브 siz SIZ_000244 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1219 comp_price_id=3235
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3235, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000244', NULL, 'MAT_000153', NULL, NULL, 2000, 62700, '직사각 90 x 50mm/유포/투명데드롱/은데드롱 제작수량≥2000 (라이브 siz SIZ_000244 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1220 comp_price_id=3236
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3236, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000245', NULL, 'MAT_000084', NULL, NULL, 2000, 54000, '직사각 90 x 60mm/비코팅/무광코팅/유광코팅 제작수량≥2000 (라이브 siz SIZ_000245 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1221 comp_price_id=3237
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3237, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000245', NULL, 'MAT_000153', NULL, NULL, 2000, 68600, '직사각 90 x 60mm/유포/투명데드롱/은데드롱 제작수량≥2000 (라이브 siz SIZ_000245 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1222 comp_price_id=3238
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3238, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000247', NULL, 'MAT_000084', NULL, NULL, 2000, 59000, '직사각 90 x 70mm/비코팅/무광코팅/유광코팅 제작수량≥2000 (라이브 siz SIZ_000247 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1223 comp_price_id=3239
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3239, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000247', NULL, 'MAT_000153', NULL, NULL, 2000, 74700, '직사각 90 x 70mm/유포/투명데드롱/은데드롱 제작수량≥2000 (라이브 siz SIZ_000247 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1224 comp_price_id=3240
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3240, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000249', NULL, 'MAT_000084', NULL, NULL, 2000, 64000, '직사각 90 x 80mm/비코팅/무광코팅/유광코팅 제작수량≥2000 (라이브 siz SIZ_000249 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1225 comp_price_id=3241
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3241, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000249', NULL, 'MAT_000153', NULL, NULL, 2000, 80700, '직사각 90 x 80mm/유포/투명데드롱/은데드롱 제작수량≥2000 (라이브 siz SIZ_000249 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1226 comp_price_id=3242
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3242, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000224', NULL, 'MAT_000084', NULL, NULL, 3000, 36000, '직사각 35 x 25mm/비코팅/무광코팅/유광코팅 제작수량≥3000 (라이브 siz SIZ_000224 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1227 comp_price_id=3243
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3243, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000224', NULL, 'MAT_000153', NULL, NULL, 3000, 46300, '직사각 35 x 25mm/유포/투명데드롱/은데드롱 제작수량≥3000 (라이브 siz SIZ_000224 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1228 comp_price_id=3244
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3244, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000226', NULL, 'MAT_000084', NULL, NULL, 3000, 44000, '직사각 40 x 30mm/비코팅/무광코팅/유광코팅 제작수량≥3000 (라이브 siz SIZ_000226 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1229 comp_price_id=3245
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3245, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000226', NULL, 'MAT_000153', NULL, NULL, 3000, 62700, '직사각 40 x 30mm/유포/투명데드롱/은데드롱 제작수량≥3000 (라이브 siz SIZ_000226 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1230 comp_price_id=3246
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3246, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000228', NULL, 'MAT_000084', NULL, NULL, 3000, 36000, '직사각 42 x 20mm/비코팅/무광코팅/유광코팅 제작수량≥3000 (라이브 siz SIZ_000228 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1231 comp_price_id=3247
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3247, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000228', NULL, 'MAT_000153', NULL, NULL, 3000, 46300, '직사각 42 x 20mm/유포/투명데드롱/은데드롱 제작수량≥3000 (라이브 siz SIZ_000228 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1232 comp_price_id=3248
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3248, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000230', NULL, 'MAT_000084', NULL, NULL, 3000, 40000, '직사각 50 x 20mm/비코팅/무광코팅/유광코팅 제작수량≥3000 (라이브 siz SIZ_000230 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1233 comp_price_id=3249
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3249, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000230', NULL, 'MAT_000153', NULL, NULL, 3000, 52200, '직사각 50 x 20mm/유포/투명데드롱/은데드롱 제작수량≥3000 (라이브 siz SIZ_000230 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1234 comp_price_id=3250
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3250, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000232', NULL, 'MAT_000084', NULL, NULL, 3000, 44000, '직사각 50 x 30mm/비코팅/무광코팅/유광코팅 제작수량≥3000 (라이브 siz SIZ_000232 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1235 comp_price_id=3251
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3251, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000232', NULL, 'MAT_000153', NULL, NULL, 3000, 62700, '직사각 50 x 30mm/유포/투명데드롱/은데드롱 제작수량≥3000 (라이브 siz SIZ_000232 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1236 comp_price_id=3252
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3252, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000234', NULL, 'MAT_000084', NULL, NULL, 3000, 36000, '직사각 55 x 15mm/비코팅/무광코팅/유광코팅 제작수량≥3000 (라이브 siz SIZ_000234 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1237 comp_price_id=3253
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3253, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000234', NULL, 'MAT_000153', NULL, NULL, 3000, 46300, '직사각 55 x 15mm/유포/투명데드롱/은데드롱 제작수량≥3000 (라이브 siz SIZ_000234 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1238 comp_price_id=3254
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3254, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000236', NULL, 'MAT_000084', NULL, NULL, 3000, 40600, '직사각 55 x 20mm/비코팅/무광코팅/유광코팅 제작수량≥3000 (라이브 siz SIZ_000236 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1239 comp_price_id=3255
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3255, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000236', NULL, 'MAT_000153', NULL, NULL, 3000, 52800, '직사각 55 x 20mm/유포/투명데드롱/은데드롱 제작수량≥3000 (라이브 siz SIZ_000236 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1240 comp_price_id=3256
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3256, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000238', NULL, 'MAT_000084', NULL, NULL, 3000, 44000, '직사각 55 x 24mm/비코팅/무광코팅/유광코팅 제작수량≥3000 (라이브 siz SIZ_000238 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1241 comp_price_id=3257
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3257, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000238', NULL, 'MAT_000153', NULL, NULL, 3000, 62700, '직사각 55 x 24mm/유포/투명데드롱/은데드롱 제작수량≥3000 (라이브 siz SIZ_000238 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1242 comp_price_id=3258
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3258, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000240', NULL, 'MAT_000084', NULL, NULL, 3000, 44000, '직사각 55 x 33mm/비코팅/무광코팅/유광코팅 제작수량≥3000 (라이브 siz SIZ_000240 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1243 comp_price_id=3259
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3259, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000240', NULL, 'MAT_000153', NULL, NULL, 3000, 62700, '직사각 55 x 33mm/유포/투명데드롱/은데드롱 제작수량≥3000 (라이브 siz SIZ_000240 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1244 comp_price_id=3260
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3260, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000242', NULL, 'MAT_000084', NULL, NULL, 3000, 64500, '직사각 90 x 40mm/비코팅/무광코팅/유광코팅 제작수량≥3000 (라이브 siz SIZ_000242 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1245 comp_price_id=3261
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3261, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000242', NULL, 'MAT_000153', NULL, NULL, 3000, 85500, '직사각 90 x 40mm/유포/투명데드롱/은데드롱 제작수량≥3000 (라이브 siz SIZ_000242 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1246 comp_price_id=3262
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3262, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000244', NULL, 'MAT_000084', NULL, NULL, 3000, 72000, '직사각 90 x 50mm/비코팅/무광코팅/유광코팅 제작수량≥3000 (라이브 siz SIZ_000244 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1247 comp_price_id=3263
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3263, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000244', NULL, 'MAT_000153', NULL, NULL, 3000, 92400, '직사각 90 x 50mm/유포/투명데드롱/은데드롱 제작수량≥3000 (라이브 siz SIZ_000244 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1248 comp_price_id=3264
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3264, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000245', NULL, 'MAT_000084', NULL, NULL, 3000, 76000, '직사각 90 x 60mm/비코팅/무광코팅/유광코팅 제작수량≥3000 (라이브 siz SIZ_000245 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1249 comp_price_id=3265
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3265, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000245', NULL, 'MAT_000153', NULL, NULL, 3000, 99500, '직사각 90 x 60mm/유포/투명데드롱/은데드롱 제작수량≥3000 (라이브 siz SIZ_000245 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1250 comp_price_id=3266
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3266, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000247', NULL, 'MAT_000084', NULL, NULL, 3000, 84000, '직사각 90 x 70mm/비코팅/무광코팅/유광코팅 제작수량≥3000 (라이브 siz SIZ_000247 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1251 comp_price_id=3267
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3267, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000247', NULL, 'MAT_000153', NULL, NULL, 3000, 106800, '직사각 90 x 70mm/유포/투명데드롱/은데드롱 제작수량≥3000 (라이브 siz SIZ_000247 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1252 comp_price_id=3268
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3268, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000249', NULL, 'MAT_000084', NULL, NULL, 3000, 90000, '직사각 90 x 80mm/비코팅/무광코팅/유광코팅 제작수량≥3000 (라이브 siz SIZ_000249 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1253 comp_price_id=3269
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3269, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000249', NULL, 'MAT_000153', NULL, NULL, 3000, 113900, '직사각 90 x 80mm/유포/투명데드롱/은데드롱 제작수량≥3000 (라이브 siz SIZ_000249 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1254 comp_price_id=3270
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3270, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000224', NULL, 'MAT_000084', NULL, NULL, 4000, 45000, '직사각 35 x 25mm/비코팅/무광코팅/유광코팅 제작수량≥4000 (라이브 siz SIZ_000224 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1255 comp_price_id=3271
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3271, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000224', NULL, 'MAT_000153', NULL, NULL, 4000, 58000, '직사각 35 x 25mm/유포/투명데드롱/은데드롱 제작수량≥4000 (라이브 siz SIZ_000224 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1256 comp_price_id=3272
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3272, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000226', NULL, 'MAT_000084', NULL, NULL, 4000, 55000, '직사각 40 x 30mm/비코팅/무광코팅/유광코팅 제작수량≥4000 (라이브 siz SIZ_000226 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1257 comp_price_id=3273
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3273, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000226', NULL, 'MAT_000153', NULL, NULL, 4000, 79400, '직사각 40 x 30mm/유포/투명데드롱/은데드롱 제작수량≥4000 (라이브 siz SIZ_000226 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1258 comp_price_id=3274
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3274, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000228', NULL, 'MAT_000084', NULL, NULL, 4000, 45000, '직사각 42 x 20mm/비코팅/무광코팅/유광코팅 제작수량≥4000 (라이브 siz SIZ_000228 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1259 comp_price_id=3275
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3275, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000228', NULL, 'MAT_000153', NULL, NULL, 4000, 58000, '직사각 42 x 20mm/유포/투명데드롱/은데드롱 제작수량≥4000 (라이브 siz SIZ_000228 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1260 comp_price_id=3276
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3276, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000230', NULL, 'MAT_000084', NULL, NULL, 4000, 50000, '직사각 50 x 20mm/비코팅/무광코팅/유광코팅 제작수량≥4000 (라이브 siz SIZ_000230 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1261 comp_price_id=3277
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3277, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000230', NULL, 'MAT_000153', NULL, NULL, 4000, 65300, '직사각 50 x 20mm/유포/투명데드롱/은데드롱 제작수량≥4000 (라이브 siz SIZ_000230 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1262 comp_price_id=3278
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3278, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000232', NULL, 'MAT_000084', NULL, NULL, 4000, 55000, '직사각 50 x 30mm/비코팅/무광코팅/유광코팅 제작수량≥4000 (라이브 siz SIZ_000232 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1263 comp_price_id=3279
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3279, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000232', NULL, 'MAT_000153', NULL, NULL, 4000, 79400, '직사각 50 x 30mm/유포/투명데드롱/은데드롱 제작수량≥4000 (라이브 siz SIZ_000232 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1264 comp_price_id=3280
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3280, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000234', NULL, 'MAT_000084', NULL, NULL, 4000, 45000, '직사각 55 x 15mm/비코팅/무광코팅/유광코팅 제작수량≥4000 (라이브 siz SIZ_000234 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1265 comp_price_id=3281
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3281, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000234', NULL, 'MAT_000153', NULL, NULL, 4000, 58000, '직사각 55 x 15mm/유포/투명데드롱/은데드롱 제작수량≥4000 (라이브 siz SIZ_000234 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1266 comp_price_id=3282
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3282, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000236', NULL, 'MAT_000084', NULL, NULL, 4000, 51000, '직사각 55 x 20mm/비코팅/무광코팅/유광코팅 제작수량≥4000 (라이브 siz SIZ_000236 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1267 comp_price_id=3283
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3283, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000236', NULL, 'MAT_000153', NULL, NULL, 4000, 65900, '직사각 55 x 20mm/유포/투명데드롱/은데드롱 제작수량≥4000 (라이브 siz SIZ_000236 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1268 comp_price_id=3284
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3284, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000238', NULL, 'MAT_000084', NULL, NULL, 4000, 55000, '직사각 55 x 24mm/비코팅/무광코팅/유광코팅 제작수량≥4000 (라이브 siz SIZ_000238 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1269 comp_price_id=3285
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3285, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000238', NULL, 'MAT_000153', NULL, NULL, 4000, 79400, '직사각 55 x 24mm/유포/투명데드롱/은데드롱 제작수량≥4000 (라이브 siz SIZ_000238 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1270 comp_price_id=3286
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3286, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000240', NULL, 'MAT_000084', NULL, NULL, 4000, 55000, '직사각 55 x 33mm/비코팅/무광코팅/유광코팅 제작수량≥4000 (라이브 siz SIZ_000240 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1271 comp_price_id=3287
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3287, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000240', NULL, 'MAT_000153', NULL, NULL, 4000, 79400, '직사각 55 x 33mm/유포/투명데드롱/은데드롱 제작수량≥4000 (라이브 siz SIZ_000240 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1272 comp_price_id=3288
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3288, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000242', NULL, 'MAT_000084', NULL, NULL, 4000, 86000, '직사각 90 x 40mm/비코팅/무광코팅/유광코팅 제작수량≥4000 (라이브 siz SIZ_000242 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1273 comp_price_id=3289
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3289, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000242', NULL, 'MAT_000153', NULL, NULL, 4000, 113900, '직사각 90 x 40mm/유포/투명데드롱/은데드롱 제작수량≥4000 (라이브 siz SIZ_000242 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1274 comp_price_id=3290
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3290, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000244', NULL, 'MAT_000084', NULL, NULL, 4000, 95000, '직사각 90 x 50mm/비코팅/무광코팅/유광코팅 제작수량≥4000 (라이브 siz SIZ_000244 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1275 comp_price_id=3291
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3291, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000244', NULL, 'MAT_000153', NULL, NULL, 4000, 122100, '직사각 90 x 50mm/유포/투명데드롱/은데드롱 제작수량≥4000 (라이브 siz SIZ_000244 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1276 comp_price_id=3292
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3292, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000245', NULL, 'MAT_000084', NULL, NULL, 4000, 100000, '직사각 90 x 60mm/비코팅/무광코팅/유광코팅 제작수량≥4000 (라이브 siz SIZ_000245 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1277 comp_price_id=3293
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3293, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000245', NULL, 'MAT_000153', NULL, NULL, 4000, 130500, '직사각 90 x 60mm/유포/투명데드롱/은데드롱 제작수량≥4000 (라이브 siz SIZ_000245 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1278 comp_price_id=3294
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3294, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000247', NULL, 'MAT_000084', NULL, NULL, 4000, 110000, '직사각 90 x 70mm/비코팅/무광코팅/유광코팅 제작수량≥4000 (라이브 siz SIZ_000247 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1279 comp_price_id=3295
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3295, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000247', NULL, 'MAT_000153', NULL, NULL, 4000, 138700, '직사각 90 x 70mm/유포/투명데드롱/은데드롱 제작수량≥4000 (라이브 siz SIZ_000247 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1280 comp_price_id=3296
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3296, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000249', NULL, 'MAT_000084', NULL, NULL, 4000, 115000, '직사각 90 x 80mm/비코팅/무광코팅/유광코팅 제작수량≥4000 (라이브 siz SIZ_000249 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1281 comp_price_id=3297
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3297, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000249', NULL, 'MAT_000153', NULL, NULL, 4000, 146900, '직사각 90 x 80mm/유포/투명데드롱/은데드롱 제작수량≥4000 (라이브 siz SIZ_000249 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1282 comp_price_id=3298
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3298, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000224', NULL, 'MAT_000084', NULL, NULL, 5000, 54000, '직사각 35 x 25mm/비코팅/무광코팅/유광코팅 제작수량≥5000 (라이브 siz SIZ_000224 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1283 comp_price_id=3299
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3299, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000224', NULL, 'MAT_000153', NULL, NULL, 5000, 69900, '직사각 35 x 25mm/유포/투명데드롱/은데드롱 제작수량≥5000 (라이브 siz SIZ_000224 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1284 comp_price_id=3300
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3300, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000226', NULL, 'MAT_000084', NULL, NULL, 5000, 66000, '직사각 40 x 30mm/비코팅/무광코팅/유광코팅 제작수량≥5000 (라이브 siz SIZ_000226 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1285 comp_price_id=3301
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3301, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000226', NULL, 'MAT_000153', NULL, NULL, 5000, 96000, '직사각 40 x 30mm/유포/투명데드롱/은데드롱 제작수량≥5000 (라이브 siz SIZ_000226 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1286 comp_price_id=3302
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3302, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000228', NULL, 'MAT_000084', NULL, NULL, 5000, 54000, '직사각 42 x 20mm/비코팅/무광코팅/유광코팅 제작수량≥5000 (라이브 siz SIZ_000228 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1287 comp_price_id=3303
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3303, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000228', NULL, 'MAT_000153', NULL, NULL, 5000, 69900, '직사각 42 x 20mm/유포/투명데드롱/은데드롱 제작수량≥5000 (라이브 siz SIZ_000228 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1288 comp_price_id=3304
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3304, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000230', NULL, 'MAT_000084', NULL, NULL, 5000, 60000, '직사각 50 x 20mm/비코팅/무광코팅/유광코팅 제작수량≥5000 (라이브 siz SIZ_000230 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1289 comp_price_id=3305
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3305, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000230', NULL, 'MAT_000153', NULL, NULL, 5000, 78300, '직사각 50 x 20mm/유포/투명데드롱/은데드롱 제작수량≥5000 (라이브 siz SIZ_000230 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1290 comp_price_id=3306
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3306, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000232', NULL, 'MAT_000084', NULL, NULL, 5000, 66000, '직사각 50 x 30mm/비코팅/무광코팅/유광코팅 제작수량≥5000 (라이브 siz SIZ_000232 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1291 comp_price_id=3307
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3307, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000232', NULL, 'MAT_000153', NULL, NULL, 5000, 96000, '직사각 50 x 30mm/유포/투명데드롱/은데드롱 제작수량≥5000 (라이브 siz SIZ_000232 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1292 comp_price_id=3308
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3308, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000234', NULL, 'MAT_000084', NULL, NULL, 5000, 54000, '직사각 55 x 15mm/비코팅/무광코팅/유광코팅 제작수량≥5000 (라이브 siz SIZ_000234 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1293 comp_price_id=3309
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3309, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000234', NULL, 'MAT_000153', NULL, NULL, 5000, 69900, '직사각 55 x 15mm/유포/투명데드롱/은데드롱 제작수량≥5000 (라이브 siz SIZ_000234 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1294 comp_price_id=3310
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3310, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000236', NULL, 'MAT_000084', NULL, NULL, 5000, 61000, '직사각 55 x 20mm/비코팅/무광코팅/유광코팅 제작수량≥5000 (라이브 siz SIZ_000236 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1295 comp_price_id=3311
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3311, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000236', NULL, 'MAT_000153', NULL, NULL, 5000, 78900, '직사각 55 x 20mm/유포/투명데드롱/은데드롱 제작수량≥5000 (라이브 siz SIZ_000236 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1296 comp_price_id=3312
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3312, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000238', NULL, 'MAT_000084', NULL, NULL, 5000, 66000, '직사각 55 x 24mm/비코팅/무광코팅/유광코팅 제작수량≥5000 (라이브 siz SIZ_000238 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1297 comp_price_id=3313
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3313, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000238', NULL, 'MAT_000153', NULL, NULL, 5000, 96000, '직사각 55 x 24mm/유포/투명데드롱/은데드롱 제작수량≥5000 (라이브 siz SIZ_000238 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1298 comp_price_id=3314
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3314, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000240', NULL, 'MAT_000084', NULL, NULL, 5000, 66000, '직사각 55 x 33mm/비코팅/무광코팅/유광코팅 제작수량≥5000 (라이브 siz SIZ_000240 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1299 comp_price_id=3315
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3315, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000240', NULL, 'MAT_000153', NULL, NULL, 5000, 96000, '직사각 55 x 33mm/유포/투명데드롱/은데드롱 제작수량≥5000 (라이브 siz SIZ_000240 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1300 comp_price_id=3316
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3316, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000242', NULL, 'MAT_000084', NULL, NULL, 5000, 107500, '직사각 90 x 40mm/비코팅/무광코팅/유광코팅 제작수량≥5000 (라이브 siz SIZ_000242 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1301 comp_price_id=3317
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3317, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000242', NULL, 'MAT_000153', NULL, NULL, 5000, 142300, '직사각 90 x 40mm/유포/투명데드롱/은데드롱 제작수량≥5000 (라이브 siz SIZ_000242 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1302 comp_price_id=3318
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3318, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000244', NULL, 'MAT_000084', NULL, NULL, 5000, 120000, '직사각 90 x 50mm/비코팅/무광코팅/유광코팅 제작수량≥5000 (라이브 siz SIZ_000244 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1303 comp_price_id=3319
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3319, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000244', NULL, 'MAT_000153', NULL, NULL, 5000, 151700, '직사각 90 x 50mm/유포/투명데드롱/은데드롱 제작수량≥5000 (라이브 siz SIZ_000244 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1304 comp_price_id=3320
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3320, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000245', NULL, 'MAT_000084', NULL, NULL, 5000, 125000, '직사각 90 x 60mm/비코팅/무광코팅/유광코팅 제작수량≥5000 (라이브 siz SIZ_000245 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1305 comp_price_id=3321
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3321, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000245', NULL, 'MAT_000153', NULL, NULL, 5000, 161300, '직사각 90 x 60mm/유포/투명데드롱/은데드롱 제작수량≥5000 (라이브 siz SIZ_000245 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1306 comp_price_id=3322
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3322, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000247', NULL, 'MAT_000084', NULL, NULL, 5000, 135000, '직사각 90 x 70mm/비코팅/무광코팅/유광코팅 제작수량≥5000 (라이브 siz SIZ_000247 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1307 comp_price_id=3323
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3323, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000247', NULL, 'MAT_000153', NULL, NULL, 5000, 170700, '직사각 90 x 70mm/유포/투명데드롱/은데드롱 제작수량≥5000 (라이브 siz SIZ_000247 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1308 comp_price_id=3324
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3324, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000249', NULL, 'MAT_000084', NULL, NULL, 5000, 140000, '직사각 90 x 80mm/비코팅/무광코팅/유광코팅 제작수량≥5000 (라이브 siz SIZ_000249 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1309 comp_price_id=3325
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3325, 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000249', NULL, 'MAT_000153', NULL, NULL, 5000, 180100, '직사각 90 x 80mm/유포/투명데드롱/은데드롱 제작수량≥5000 (라이브 siz SIZ_000249 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1310 comp_price_id=3326
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3326, 'COMP_NAMECARD_STD_S1', '2026-06-01', NULL, NULL, 'MAT_000074', NULL, NULL, 100, 3500, '스탠다드명함/단면/백모조220 / 아트250 / 스노우250 제작수량≥100 (용지포함 단품가 행39, 명함종+면=comp흡수, 소재군=대표mat/흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1311 comp_price_id=3327
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3327, 'COMP_NAMECARD_STD_S1', '2026-06-01', NULL, NULL, 'MAT_000082', NULL, NULL, 100, 3800, '스탠다드명함/단면/아트300 / 스노우300 제작수량≥100 (용지포함 단품가 행39, 명함종+면=comp흡수, 소재군=대표mat/흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1312 comp_price_id=3328
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3328, 'COMP_NAMECARD_STD_S2', '2026-06-01', NULL, NULL, 'MAT_000074', NULL, NULL, 100, 4500, '스탠다드명함/양면/백모조220 / 아트250 / 스노우250 제작수량≥100 (용지포함 단품가 행39, 명함종+면=comp흡수, 소재군=대표mat/흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1313 comp_price_id=3329
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3329, 'COMP_NAMECARD_STD_S2', '2026-06-01', NULL, NULL, 'MAT_000082', NULL, NULL, 100, 4800, '스탠다드명함/양면/아트300 / 스노우300 제작수량≥100 (용지포함 단품가 행39, 명함종+면=comp흡수, 소재군=대표mat/흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1314 comp_price_id=3330
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3330, 'COMP_NAMECARD_PREMIUM_S1_MGA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 100, 4500, '프리미엄명함/단면/A 제작수량≥100 (용지포함 단품가 행39, 명함종+면=comp흡수, 소재군=대표mat/흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1315 comp_price_id=3331
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3331, 'COMP_NAMECARD_PREMIUM_S1_MGB', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 100, 5000, '프리미엄명함/단면/B 제작수량≥100 (용지포함 단품가 행39, 명함종+면=comp흡수, 소재군=대표mat/흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1316 comp_price_id=3332
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3332, 'COMP_NAMECARD_PREMIUM_S2_MGA', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 100, 5500, '프리미엄명함/양면/A 제작수량≥100 (용지포함 단품가 행39, 명함종+면=comp흡수, 소재군=대표mat/흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1317 comp_price_id=3333
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3333, 'COMP_NAMECARD_PREMIUM_S2_MGB', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 100, 6500, '프리미엄명함/양면/B 제작수량≥100 (용지포함 단품가 행39, 명함종+면=comp흡수, 소재군=대표mat/흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1318 comp_price_id=3334
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3334, 'COMP_NAMECARD_COAT_S1', '2026-06-01', NULL, NULL, 'MAT_000081', NULL, NULL, 100, 5500, '코팅명함/단면/아트250 제작수량≥100 (용지포함 단품가 행39, 명함종+면=comp흡수, 소재군=대표mat/흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1319 comp_price_id=3335
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3335, 'COMP_NAMECARD_COAT_S1', '2026-06-01', NULL, NULL, 'MAT_000082', NULL, NULL, 100, 5800, '코팅명함/단면/아트300 제작수량≥100 (용지포함 단품가 행39, 명함종+면=comp흡수, 소재군=대표mat/흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1320 comp_price_id=3336
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3336, 'COMP_NAMECARD_COAT_S2', '2026-06-01', NULL, NULL, 'MAT_000081', NULL, NULL, 100, 6500, '코팅명함/양면/아트250 제작수량≥100 (용지포함 단품가 행39, 명함종+면=comp흡수, 소재군=대표mat/흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1321 comp_price_id=3337
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3337, 'COMP_NAMECARD_COAT_S2', '2026-06-01', NULL, NULL, 'MAT_000082', NULL, NULL, 100, 6800, '코팅명함/양면/아트300 제작수량≥100 (용지포함 단품가 행39, 명함종+면=comp흡수, 소재군=대표mat/흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1322 comp_price_id=3338
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3338, 'COMP_NAMECARD_PEARL_S1', '2026-06-01', NULL, NULL, 'MAT_000127', NULL, NULL, 100, 9000, '펄명함 (스타드림)/단면/다이아 240 / 실버 240 / 골드 240 제작수량≥100 (용지포함 단품가 행39, 명함종+면=comp흡수, 소재군=대표mat/흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1323 comp_price_id=3339
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3339, 'COMP_NAMECARD_PEARL_S1', '2026-06-01', NULL, NULL, 'MAT_000130', NULL, NULL, 100, 10000, '펄명함 (스타드림)/단면/로츠쿼츠 240 제작수량≥100 (용지포함 단품가 행39, 명함종+면=comp흡수, 소재군=대표mat/흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1324 comp_price_id=3340
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3340, 'COMP_NAMECARD_PEARL_S2', '2026-06-01', NULL, NULL, 'MAT_000127', NULL, NULL, 100, 10000, '펄명함 (스타드림)/양면/다이아 240 / 실버 240 / 골드 240 제작수량≥100 (용지포함 단품가 행39, 명함종+면=comp흡수, 소재군=대표mat/흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1325 comp_price_id=3341
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3341, 'COMP_NAMECARD_PEARL_S2', '2026-06-01', NULL, NULL, 'MAT_000130', NULL, NULL, 100, 11000, '펄명함 (스타드림)/양면/로츠쿼츠 240 제작수량≥100 (용지포함 단품가 행39, 명함종+면=comp흡수, 소재군=대표mat/흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1326 comp_price_id=3342
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3342, 'COMP_NAMECARD_CLEAR_S1', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 100, 13500, '투명명함/단면/투명PET 260 / 반투명PET 260 제작수량≥100 (용지포함 단품가 행39, 명함종+면=comp흡수, 소재군=대표mat/흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1327 comp_price_id=3343
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3343, 'COMP_NAMECARD_WHITE_S1W_NOCL', '2026-06-01', NULL, NULL, 'MAT_000137', NULL, NULL, 100, 14500, '화이트인쇄명함 (큐리어스스킨)/화이트(단면)/화이트(단면)+클리어(없음) 제작수량≥100 (용지포함 단품가 행39, 명함종+면=comp흡수, 소재군=대표mat/흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1328 comp_price_id=3344
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3344, 'COMP_NAMECARD_WHITE_S1W_CL', '2026-06-01', NULL, NULL, 'MAT_000137', NULL, NULL, 100, 16000, '화이트인쇄명함 (큐리어스스킨)/화이트(단면)/화이트(단면)+클리어(단면) 제작수량≥100 (용지포함 단품가 행39, 명함종+면=comp흡수, 소재군=대표mat/흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1329 comp_price_id=3345
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3345, 'COMP_NAMECARD_WHITE_S2W_NOCL', '2026-06-01', NULL, NULL, 'MAT_000137', NULL, NULL, 100, 16000, '화이트인쇄명함 (큐리어스스킨)/화이트(양면)/화이트(양면)+클리어(없음) 제작수량≥100 (용지포함 단품가 행39, 명함종+면=comp흡수, 소재군=대표mat/흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1330 comp_price_id=3346
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3346, 'COMP_NAMECARD_WHITE_S2W_CL', '2026-06-01', NULL, NULL, 'MAT_000137', NULL, NULL, 100, 19000, '화이트인쇄명함 (큐리어스스킨)/화이트(양면)/화이트(양면)+클리어(양면) 제작수량≥100 (용지포함 단품가 행39, 명함종+면=comp흡수, 소재군=대표mat/흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1331 comp_price_id=3347
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3347, 'COMP_NAMECARD_SHAPE_S1', '2026-06-01', 'SIZ_000008', NULL, NULL, NULL, NULL, 100, 18000, '모양명함 (90x50)/단면/몽블랑240 제작수량≥100 (용지포함 단품가 행39, 명함종+면=comp흡수, 소재군=대표mat/흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1332 comp_price_id=3348
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3348, 'COMP_NAMECARD_SHAPE_S2', '2026-06-01', 'SIZ_000008', NULL, NULL, NULL, NULL, 100, 19000, '모양명함 (90x50)/양면/몽블랑240 제작수량≥100 (용지포함 단품가 행39, 명함종+면=comp흡수, 소재군=대표mat/흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1333 comp_price_id=3349
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3349, 'COMP_NAMECARD_MINISHAPE_S1', '2026-06-01', 'SIZ_000011', NULL, NULL, NULL, NULL, 100, 16000, '미니모양명함 (50x50)/단면/몽블랑240 제작수량≥100 (용지포함 단품가 행39, 명함종+면=comp흡수, 소재군=대표mat/흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1334 comp_price_id=3350
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3350, 'COMP_NAMECARD_MINISHAPE_S2', '2026-06-01', 'SIZ_000011', NULL, NULL, NULL, NULL, 100, 17000, '미니모양명함 (50x50)/양면/몽블랑240 제작수량≥100 (용지포함 단품가 행39, 명함종+면=comp흡수, 소재군=대표mat/흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1335 comp_price_id=3351
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3351, 'COMP_NAMECARD_FOIL_SETUP_S1_STD', '2026-06-01', NULL, NULL, NULL, NULL, NULL, NULL, 5000, '오리지널박명함 기본가(아연판=동판셋업비) 단면/금유광, 은유광, 먹유광, 청박, 적박, 동박 (수량무관 셋업, 규칙④ 합가구성)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1336 comp_price_id=3352
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3352, 'COMP_NAMECARD_FOIL_SETUP_S2_STD', '2026-06-01', NULL, NULL, NULL, NULL, NULL, NULL, 5000, '오리지널박명함 기본가(아연판=동판셋업비) 양면/금유광, 은유광, 먹유광, 청박, 적박, 동박 (수량무관 셋업, 규칙④ 합가구성)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1337 comp_price_id=3353
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3353, 'COMP_NAMECARD_FOIL_S1_STD', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 200, 19200, '오리지널박명함 종이+동판+박가공비 합가 단면/금유광, 은유광, 먹유광, 청박, 적박, 동박 제작수량≥200 (규칙④ 합가)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1338 comp_price_id=3354
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3354, 'COMP_NAMECARD_FOIL_S1_HOLO', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 200, 24800, '오리지널박명함 종이+동판+박가공비 합가 단면/홀로그램 / 트윙클 제작수량≥200 (규칙④ 합가)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1339 comp_price_id=3355
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3355, 'COMP_NAMECARD_FOIL_S2_STD', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 200, 19200, '오리지널박명함 종이+동판+박가공비 합가 양면/금유광, 은유광, 먹유광, 청박, 적박, 동박 제작수량≥200 (규칙④ 합가)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1340 comp_price_id=3356
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3356, 'COMP_NAMECARD_FOIL_S2_HOLO', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 200, 24800, '오리지널박명함 종이+동판+박가공비 합가 양면/홀로그램 / 트윙클 제작수량≥200 (규칙④ 합가)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1341 comp_price_id=3357
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3357, 'COMP_NAMECARD_FOIL_S1_STD', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 300, 24800, '오리지널박명함 종이+동판+박가공비 합가 단면/금유광, 은유광, 먹유광, 청박, 적박, 동박 제작수량≥300 (규칙④ 합가)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1342 comp_price_id=3358
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3358, 'COMP_NAMECARD_FOIL_S1_HOLO', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 300, 33200, '오리지널박명함 종이+동판+박가공비 합가 단면/홀로그램 / 트윙클 제작수량≥300 (규칙④ 합가)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1343 comp_price_id=3359
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3359, 'COMP_NAMECARD_FOIL_S2_STD', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 300, 24800, '오리지널박명함 종이+동판+박가공비 합가 양면/금유광, 은유광, 먹유광, 청박, 적박, 동박 제작수량≥300 (규칙④ 합가)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1344 comp_price_id=3360
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3360, 'COMP_NAMECARD_FOIL_S2_HOLO', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 300, 33200, '오리지널박명함 종이+동판+박가공비 합가 양면/홀로그램 / 트윙클 제작수량≥300 (규칙④ 합가)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1345 comp_price_id=3361
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3361, 'COMP_NAMECARD_FOIL_S1_STD', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 400, 30400, '오리지널박명함 종이+동판+박가공비 합가 단면/금유광, 은유광, 먹유광, 청박, 적박, 동박 제작수량≥400 (규칙④ 합가)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1346 comp_price_id=3362
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3362, 'COMP_NAMECARD_FOIL_S1_HOLO', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 400, 41600, '오리지널박명함 종이+동판+박가공비 합가 단면/홀로그램 / 트윙클 제작수량≥400 (규칙④ 합가)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1347 comp_price_id=3363
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3363, 'COMP_NAMECARD_FOIL_S2_STD', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 400, 30400, '오리지널박명함 종이+동판+박가공비 합가 양면/금유광, 은유광, 먹유광, 청박, 적박, 동박 제작수량≥400 (규칙④ 합가)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1348 comp_price_id=3364
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3364, 'COMP_NAMECARD_FOIL_S2_HOLO', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 400, 41600, '오리지널박명함 종이+동판+박가공비 합가 양면/홀로그램 / 트윙클 제작수량≥400 (규칙④ 합가)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1349 comp_price_id=3365
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3365, 'COMP_NAMECARD_FOIL_S1_STD', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 500, 36000, '오리지널박명함 종이+동판+박가공비 합가 단면/금유광, 은유광, 먹유광, 청박, 적박, 동박 제작수량≥500 (규칙④ 합가)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1350 comp_price_id=3366
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3366, 'COMP_NAMECARD_FOIL_S1_HOLO', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 500, 50000, '오리지널박명함 종이+동판+박가공비 합가 단면/홀로그램 / 트윙클 제작수량≥500 (규칙④ 합가)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1351 comp_price_id=3367
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3367, 'COMP_NAMECARD_FOIL_S2_STD', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 500, 36000, '오리지널박명함 종이+동판+박가공비 합가 양면/금유광, 은유광, 먹유광, 청박, 적박, 동박 제작수량≥500 (규칙④ 합가)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1352 comp_price_id=3368
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3368, 'COMP_NAMECARD_FOIL_S2_HOLO', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 500, 50000, '오리지널박명함 종이+동판+박가공비 합가 양면/홀로그램 / 트윙클 제작수량≥500 (규칙④ 합가)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1353 comp_price_id=3369
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3369, 'COMP_NAMECARD_FOIL_S1_STD', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 600, 41600, '오리지널박명함 종이+동판+박가공비 합가 단면/금유광, 은유광, 먹유광, 청박, 적박, 동박 제작수량≥600 (규칙④ 합가)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1354 comp_price_id=3370
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3370, 'COMP_NAMECARD_FOIL_S1_HOLO', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 600, 54400, '오리지널박명함 종이+동판+박가공비 합가 단면/홀로그램 / 트윙클 제작수량≥600 (규칙④ 합가)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1355 comp_price_id=3371
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3371, 'COMP_NAMECARD_FOIL_S2_STD', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 600, 41600, '오리지널박명함 종이+동판+박가공비 합가 양면/금유광, 은유광, 먹유광, 청박, 적박, 동박 제작수량≥600 (규칙④ 합가)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1356 comp_price_id=3372
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3372, 'COMP_NAMECARD_FOIL_S2_HOLO', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 600, 54400, '오리지널박명함 종이+동판+박가공비 합가 양면/홀로그램 / 트윙클 제작수량≥600 (규칙④ 합가)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1357 comp_price_id=3373
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3373, 'COMP_NAMECARD_FOIL_S1_STD', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 700, 47200, '오리지널박명함 종이+동판+박가공비 합가 단면/금유광, 은유광, 먹유광, 청박, 적박, 동박 제작수량≥700 (규칙④ 합가)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1358 comp_price_id=3374
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3374, 'COMP_NAMECARD_FOIL_S1_HOLO', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 700, 66800, '오리지널박명함 종이+동판+박가공비 합가 단면/홀로그램 / 트윙클 제작수량≥700 (규칙④ 합가)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1359 comp_price_id=3375
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3375, 'COMP_NAMECARD_FOIL_S2_STD', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 700, 47200, '오리지널박명함 종이+동판+박가공비 합가 양면/금유광, 은유광, 먹유광, 청박, 적박, 동박 제작수량≥700 (규칙④ 합가)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1360 comp_price_id=3376
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3376, 'COMP_NAMECARD_FOIL_S2_HOLO', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 700, 66800, '오리지널박명함 종이+동판+박가공비 합가 양면/홀로그램 / 트윙클 제작수량≥700 (규칙④ 합가)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1361 comp_price_id=3377
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3377, 'COMP_NAMECARD_FOIL_S1_STD', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 800, 52800, '오리지널박명함 종이+동판+박가공비 합가 단면/금유광, 은유광, 먹유광, 청박, 적박, 동박 제작수량≥800 (규칙④ 합가)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1362 comp_price_id=3378
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3378, 'COMP_NAMECARD_FOIL_S1_HOLO', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 800, 75200, '오리지널박명함 종이+동판+박가공비 합가 단면/홀로그램 / 트윙클 제작수량≥800 (규칙④ 합가)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1363 comp_price_id=3379
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3379, 'COMP_NAMECARD_FOIL_S2_STD', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 800, 52800, '오리지널박명함 종이+동판+박가공비 합가 양면/금유광, 은유광, 먹유광, 청박, 적박, 동박 제작수량≥800 (규칙④ 합가)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1364 comp_price_id=3380
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3380, 'COMP_NAMECARD_FOIL_S2_HOLO', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 800, 75200, '오리지널박명함 종이+동판+박가공비 합가 양면/홀로그램 / 트윙클 제작수량≥800 (규칙④ 합가)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1365 comp_price_id=3381
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3381, 'COMP_NAMECARD_FOIL_S1_STD', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 900, 58400, '오리지널박명함 종이+동판+박가공비 합가 단면/금유광, 은유광, 먹유광, 청박, 적박, 동박 제작수량≥900 (규칙④ 합가)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1366 comp_price_id=3382
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3382, 'COMP_NAMECARD_FOIL_S1_HOLO', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 900, 83600, '오리지널박명함 종이+동판+박가공비 합가 단면/홀로그램 / 트윙클 제작수량≥900 (규칙④ 합가)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1367 comp_price_id=3383
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3383, 'COMP_NAMECARD_FOIL_S2_STD', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 900, 58400, '오리지널박명함 종이+동판+박가공비 합가 양면/금유광, 은유광, 먹유광, 청박, 적박, 동박 제작수량≥900 (규칙④ 합가)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1368 comp_price_id=3384
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3384, 'COMP_NAMECARD_FOIL_S2_HOLO', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 900, 83600, '오리지널박명함 종이+동판+박가공비 합가 양면/홀로그램 / 트윙클 제작수량≥900 (규칙④ 합가)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1369 comp_price_id=3385
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3385, 'COMP_NAMECARD_FOIL_S1_STD', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1000, 63000, '오리지널박명함 종이+동판+박가공비 합가 단면/금유광, 은유광, 먹유광, 청박, 적박, 동박 제작수량≥1000 (규칙④ 합가)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1370 comp_price_id=3386
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3386, 'COMP_NAMECARD_FOIL_S1_HOLO', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1000, 92000, '오리지널박명함 종이+동판+박가공비 합가 단면/홀로그램 / 트윙클 제작수량≥1000 (규칙④ 합가)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1371 comp_price_id=3387
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3387, 'COMP_NAMECARD_FOIL_S2_STD', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1000, 63000, '오리지널박명함 종이+동판+박가공비 합가 양면/금유광, 은유광, 먹유광, 청박, 적박, 동박 제작수량≥1000 (규칙④ 합가)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1372 comp_price_id=3388
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3388, 'COMP_NAMECARD_FOIL_S2_HOLO', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1000, 92000, '오리지널박명함 종이+동판+박가공비 합가 양면/홀로그램 / 트윙클 제작수량≥1000 (규칙④ 합가)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1373 comp_price_id=3389
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3389, 'COMP_PHOTOCARD_BULK', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 20, 5000, '포토카드(대량제작) 총제작수량≥20 단순가')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1374 comp_price_id=3390
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3390, 'COMP_PHOTOCARD_BULK', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 40, 6000, '포토카드(대량제작) 총제작수량≥40 단순가')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1375 comp_price_id=3391
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3391, 'COMP_PHOTOCARD_BULK', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 60, 7000, '포토카드(대량제작) 총제작수량≥60 단순가')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1376 comp_price_id=3392
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3392, 'COMP_PHOTOCARD_BULK', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 80, 8000, '포토카드(대량제작) 총제작수량≥80 단순가')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1377 comp_price_id=3393
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3393, 'COMP_PHOTOCARD_BULK', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 100, 9500, '포토카드(대량제작) 총제작수량≥100 단순가')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1378 comp_price_id=3394
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3394, 'COMP_PHOTOCARD_BULK', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 120, 10200, '포토카드(대량제작) 총제작수량≥120 단순가')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1379 comp_price_id=3395
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3395, 'COMP_PHOTOCARD_BULK', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 140, 10800, '포토카드(대량제작) 총제작수량≥140 단순가')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1380 comp_price_id=3396
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3396, 'COMP_PHOTOCARD_BULK', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 160, 11400, '포토카드(대량제작) 총제작수량≥160 단순가')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1381 comp_price_id=3397
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3397, 'COMP_PHOTOCARD_BULK', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 180, 11900, '포토카드(대량제작) 총제작수량≥180 단순가')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1382 comp_price_id=3398
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3398, 'COMP_PHOTOCARD_BULK', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 200, 12300, '포토카드(대량제작) 총제작수량≥200 단순가')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1383 comp_price_id=3399
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3399, 'COMP_PHOTOCARD_BULK', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 220, 13900, '포토카드(대량제작) 총제작수량≥220 단순가')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1384 comp_price_id=3400
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3400, 'COMP_PHOTOCARD_BULK', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 240, 14400, '포토카드(대량제작) 총제작수량≥240 단순가')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1385 comp_price_id=3401
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3401, 'COMP_PHOTOCARD_BULK', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 260, 15000, '포토카드(대량제작) 총제작수량≥260 단순가')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1386 comp_price_id=3402
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3402, 'COMP_PHOTOCARD_BULK', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 280, 15500, '포토카드(대량제작) 총제작수량≥280 단순가')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1387 comp_price_id=3403
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3403, 'COMP_PHOTOCARD_BULK', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 300, 13500, '포토카드(대량제작) 총제작수량≥300 단순가')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1388 comp_price_id=3404
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3404, 'COMP_PHOTOCARD_BULK', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 320, 17600, '포토카드(대량제작) 총제작수량≥320 단순가')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1389 comp_price_id=3405
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3405, 'COMP_PHOTOCARD_BULK', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 340, 18200, '포토카드(대량제작) 총제작수량≥340 단순가')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1390 comp_price_id=3406
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3406, 'COMP_PHOTOCARD_BULK', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 360, 19300, '포토카드(대량제작) 총제작수량≥360 단순가')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1391 comp_price_id=3407
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3407, 'COMP_PHOTOCARD_BULK', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 380, 20400, '포토카드(대량제작) 총제작수량≥380 단순가')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1392 comp_price_id=3408
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3408, 'COMP_PHOTOCARD_BULK', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 400, 21200, '포토카드(대량제작) 총제작수량≥400 단순가')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1393 comp_price_id=3409
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3409, 'COMP_PHOTOCARD_BULK', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 420, 22100, '포토카드(대량제작) 총제작수량≥420 단순가')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1394 comp_price_id=3410
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3410, 'COMP_PHOTOCARD_BULK', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 440, 22700, '포토카드(대량제작) 총제작수량≥440 단순가')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1395 comp_price_id=3411
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3411, 'COMP_PHOTOCARD_BULK', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 460, 23300, '포토카드(대량제작) 총제작수량≥460 단순가')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1396 comp_price_id=3412
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3412, 'COMP_PHOTOCARD_BULK', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 480, 23800, '포토카드(대량제작) 총제작수량≥480 단순가')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1397 comp_price_id=3413
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3413, 'COMP_PHOTOCARD_BULK', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 500, 24600, '포토카드(대량제작) 총제작수량≥500 단순가')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1398 comp_price_id=3414
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3414, 'COMP_PHOTOCARD_BULK', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 600, 28800, '포토카드(대량제작) 총제작수량≥600 단순가')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1399 comp_price_id=3415
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3415, 'COMP_PHOTOCARD_BULK', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 700, 32500, '포토카드(대량제작) 총제작수량≥700 단순가')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1400 comp_price_id=3416
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3416, 'COMP_PHOTOCARD_BULK', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 800, 36800, '포토카드(대량제작) 총제작수량≥800 단순가')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1401 comp_price_id=3417
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3417, 'COMP_PHOTOCARD_BULK', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 900, 41000, '포토카드(대량제작) 총제작수량≥900 단순가')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1402 comp_price_id=3418
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3418, 'COMP_PHOTOCARD_BULK', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1000, 45000, '포토카드(대량제작) 총제작수량≥1000 단순가')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1403 comp_price_id=3419
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3419, 'COMP_PHOTOCARD_BULK', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1100, 49000, '포토카드(대량제작) 총제작수량≥1100 단순가')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1404 comp_price_id=3420
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3420, 'COMP_PHOTOCARD_BULK', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1200, 52800, '포토카드(대량제작) 총제작수량≥1200 단순가')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1405 comp_price_id=3421
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3421, 'COMP_PHOTOCARD_BULK', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1300, 56600, '포토카드(대량제작) 총제작수량≥1300 단순가')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1406 comp_price_id=3422
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3422, 'COMP_PHOTOCARD_BULK', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1400, 60500, '포토카드(대량제작) 총제작수량≥1400 단순가')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1407 comp_price_id=3423
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3423, 'COMP_PHOTOCARD_BULK', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1500, 60200, '포토카드(대량제작) 총제작수량≥1500 단순가')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1408 comp_price_id=3424
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3424, 'COMP_PHOTOCARD_BULK', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1600, 68800, '포토카드(대량제작) 총제작수량≥1600 단순가')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1409 comp_price_id=3425
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3425, 'COMP_PHOTOCARD_BULK', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1700, 73100, '포토카드(대량제작) 총제작수량≥1700 단순가')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1410 comp_price_id=3426
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3426, 'COMP_PHOTOCARD_BULK', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1800, 77400, '포토카드(대량제작) 총제작수량≥1800 단순가')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1411 comp_price_id=3427
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3427, 'COMP_PHOTOCARD_BULK', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 1900, 80700, '포토카드(대량제작) 총제작수량≥1900 단순가')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1412 comp_price_id=3428
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3428, 'COMP_PHOTOCARD_BULK', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 2000, 85000, '포토카드(대량제작) 총제작수량≥2000 단순가')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1413 comp_price_id=3429
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3429, 'COMP_PHOTOCARD_BULK', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 2100, 89300, '포토카드(대량제작) 총제작수량≥2100 단순가')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1414 comp_price_id=3430
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3430, 'COMP_PHOTOCARD_BULK', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 2200, 93500, '포토카드(대량제작) 총제작수량≥2200 단순가')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1415 comp_price_id=3431
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3431, 'COMP_PHOTOCARD_BULK', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 2300, 97800, '포토카드(대량제작) 총제작수량≥2300 단순가')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1416 comp_price_id=3432
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3432, 'COMP_PHOTOCARD_BULK', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 2400, 102000, '포토카드(대량제작) 총제작수량≥2400 단순가')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1417 comp_price_id=3433
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3433, 'COMP_PHOTOCARD_BULK', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 2500, 106300, '포토카드(대량제작) 총제작수량≥2500 단순가')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1418 comp_price_id=3434
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3434, 'COMP_PHOTOCARD_BULK', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 2600, 109200, '포토카드(대량제작) 총제작수량≥2600 단순가')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1419 comp_price_id=3435
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3435, 'COMP_PHOTOCARD_BULK', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 2700, 113400, '포토카드(대량제작) 총제작수량≥2700 단순가')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1420 comp_price_id=3436
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3436, 'COMP_PHOTOCARD_BULK', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 2800, 117600, '포토카드(대량제작) 총제작수량≥2800 단순가')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1421 comp_price_id=3437
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3437, 'COMP_PHOTOCARD_BULK', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 2900, 121800, '포토카드(대량제작) 총제작수량≥2900 단순가')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1422 comp_price_id=3438
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3438, 'COMP_PHOTOCARD_BULK', '2026-06-01', NULL, NULL, NULL, NULL, NULL, 3000, 126000, '포토카드(대량제작) 총제작수량≥3000 단순가')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1423 comp_price_id=3439
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3439, 'COMP_PHOTOCARD_SET', '2026-06-01', 'SIZ_000012', NULL, NULL, NULL, 20, 1, 6000, '포토카드(20장1세트) 세트단가 (1세트=20장→bdl_qty=20, 55x86=SIZ_000012, 세트단위)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1424 comp_price_id=3440
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3440, 'COMP_PHOTOCARD_CLEAR_SET', '2026-06-01', 'SIZ_000012', NULL, NULL, NULL, 20, 1, 8500, '투명포토카드(20장1세트) 세트단가 (1세트=20장→bdl_qty=20, 55x86=SIZ_000012, 세트단위)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1425 comp_price_id=3441
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3441, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 2, 11000, '엽서북/100*150/단면/20P 수량≥2 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1426 comp_price_id=3442
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3442, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 2, 11500, '엽서북/100*150/단면/30P 수량≥2 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1427 comp_price_id=3443
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3443, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 2, 11500, '엽서북/100*150/양면/20P 수량≥2 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1428 comp_price_id=3444
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3444, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 2, 12500, '엽서북/100*150/양면/30P 수량≥2 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1429 comp_price_id=3445
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3445, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 2, 11000, '엽서북/150*100/단면/20P 수량≥2 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1430 comp_price_id=3446
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3446, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 2, 11500, '엽서북/150*100/단면/30P 수량≥2 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1431 comp_price_id=3447
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3447, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 2, 11500, '엽서북/150*100/양면/20P 수량≥2 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1432 comp_price_id=3448
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3448, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 2, 12500, '엽서북/150*100/양면/30P 수량≥2 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1433 comp_price_id=3449
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3449, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 2, 12000, '엽서북/135*135/단면/20P 수량≥2 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1434 comp_price_id=3450
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3450, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 2, 12500, '엽서북/135*135/단면/30P 수량≥2 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1435 comp_price_id=3451
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3451, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 2, 12500, '엽서북/135*135/양면/20P 수량≥2 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1436 comp_price_id=3452
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3452, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 2, 13500, '엽서북/135*135/양면/30P 수량≥2 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1437 comp_price_id=3453
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3453, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 4, 9100, '엽서북/100*150/단면/20P 수량≥4 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1438 comp_price_id=3454
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3454, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 4, 9900, '엽서북/100*150/단면/30P 수량≥4 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1439 comp_price_id=3455
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3455, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 4, 9200, '엽서북/100*150/양면/20P 수량≥4 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1440 comp_price_id=3456
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3456, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 4, 10000, '엽서북/100*150/양면/30P 수량≥4 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1441 comp_price_id=3457
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3457, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 4, 9100, '엽서북/150*100/단면/20P 수량≥4 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1442 comp_price_id=3458
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3458, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 4, 9900, '엽서북/150*100/단면/30P 수량≥4 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1443 comp_price_id=3459
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3459, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 4, 9200, '엽서북/150*100/양면/20P 수량≥4 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1444 comp_price_id=3460
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3460, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 4, 10000, '엽서북/150*100/양면/30P 수량≥4 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1445 comp_price_id=3461
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3461, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 4, 9800, '엽서북/135*135/단면/20P 수량≥4 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1446 comp_price_id=3462
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3462, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 4, 10500, '엽서북/135*135/단면/30P 수량≥4 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1447 comp_price_id=3463
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3463, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 4, 10100, '엽서북/135*135/양면/20P 수량≥4 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1448 comp_price_id=3464
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3464, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 4, 10800, '엽서북/135*135/양면/30P 수량≥4 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1449 comp_price_id=3465
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3465, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 6, 7300, '엽서북/100*150/단면/20P 수량≥6 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1450 comp_price_id=3466
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3466, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 6, 8100, '엽서북/100*150/단면/30P 수량≥6 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1451 comp_price_id=3467
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3467, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 6, 7500, '엽서북/100*150/양면/20P 수량≥6 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1452 comp_price_id=3468
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3468, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 6, 8300, '엽서북/100*150/양면/30P 수량≥6 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1453 comp_price_id=3469
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3469, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 6, 7300, '엽서북/150*100/단면/20P 수량≥6 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1454 comp_price_id=3470
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3470, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 6, 8100, '엽서북/150*100/단면/30P 수량≥6 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1455 comp_price_id=3471
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3471, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 6, 7500, '엽서북/150*100/양면/20P 수량≥6 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1456 comp_price_id=3472
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3472, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 6, 8300, '엽서북/150*100/양면/30P 수량≥6 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1457 comp_price_id=3473
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3473, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 6, 8000, '엽서북/135*135/단면/20P 수량≥6 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1458 comp_price_id=3474
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3474, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 6, 8600, '엽서북/135*135/단면/30P 수량≥6 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1459 comp_price_id=3475
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3475, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 6, 8300, '엽서북/135*135/양면/20P 수량≥6 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1460 comp_price_id=3476
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3476, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 6, 8900, '엽서북/135*135/양면/30P 수량≥6 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1461 comp_price_id=3477
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3477, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 8, 7100, '엽서북/100*150/단면/20P 수량≥8 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1462 comp_price_id=3478
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3478, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 8, 7900, '엽서북/100*150/단면/30P 수량≥8 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1463 comp_price_id=3479
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3479, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 8, 7300, '엽서북/100*150/양면/20P 수량≥8 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1464 comp_price_id=3480
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3480, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 8, 8100, '엽서북/100*150/양면/30P 수량≥8 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1465 comp_price_id=3481
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3481, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 8, 7100, '엽서북/150*100/단면/20P 수량≥8 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1466 comp_price_id=3482
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3482, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 8, 7900, '엽서북/150*100/단면/30P 수량≥8 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1467 comp_price_id=3483
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3483, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 8, 7300, '엽서북/150*100/양면/20P 수량≥8 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1468 comp_price_id=3484
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3484, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 8, 8100, '엽서북/150*100/양면/30P 수량≥8 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1469 comp_price_id=3485
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3485, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 8, 7800, '엽서북/135*135/단면/20P 수량≥8 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1470 comp_price_id=3486
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3486, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 8, 8400, '엽서북/135*135/단면/30P 수량≥8 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1471 comp_price_id=3487
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3487, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 8, 8100, '엽서북/135*135/양면/20P 수량≥8 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1472 comp_price_id=3488
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3488, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 8, 8700, '엽서북/135*135/양면/30P 수량≥8 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1473 comp_price_id=3489
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3489, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 10, 6900, '엽서북/100*150/단면/20P 수량≥10 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1474 comp_price_id=3490
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3490, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 10, 7700, '엽서북/100*150/단면/30P 수량≥10 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1475 comp_price_id=3491
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3491, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 10, 7100, '엽서북/100*150/양면/20P 수량≥10 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1476 comp_price_id=3492
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3492, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 10, 7900, '엽서북/100*150/양면/30P 수량≥10 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1477 comp_price_id=3493
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3493, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 10, 6900, '엽서북/150*100/단면/20P 수량≥10 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1478 comp_price_id=3494
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3494, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 10, 7700, '엽서북/150*100/단면/30P 수량≥10 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1479 comp_price_id=3495
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3495, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 10, 7100, '엽서북/150*100/양면/20P 수량≥10 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1480 comp_price_id=3496
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3496, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 10, 7900, '엽서북/150*100/양면/30P 수량≥10 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1481 comp_price_id=3497
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3497, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 10, 7600, '엽서북/135*135/단면/20P 수량≥10 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1482 comp_price_id=3498
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3498, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 10, 8200, '엽서북/135*135/단면/30P 수량≥10 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1483 comp_price_id=3499
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3499, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 10, 7900, '엽서북/135*135/양면/20P 수량≥10 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1484 comp_price_id=3500
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3500, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 10, 8500, '엽서북/135*135/양면/30P 수량≥10 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1485 comp_price_id=3501
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3501, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 20, 5200, '엽서북/100*150/단면/20P 수량≥20 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1486 comp_price_id=3502
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3502, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 20, 6000, '엽서북/100*150/단면/30P 수량≥20 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1487 comp_price_id=3503
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3503, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 20, 5400, '엽서북/100*150/양면/20P 수량≥20 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1488 comp_price_id=3504
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3504, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 20, 6200, '엽서북/100*150/양면/30P 수량≥20 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1489 comp_price_id=3505
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3505, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 20, 5200, '엽서북/150*100/단면/20P 수량≥20 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1490 comp_price_id=3506
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3506, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 20, 6000, '엽서북/150*100/단면/30P 수량≥20 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1491 comp_price_id=3507
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3507, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 20, 5400, '엽서북/150*100/양면/20P 수량≥20 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1492 comp_price_id=3508
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3508, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 20, 6200, '엽서북/150*100/양면/30P 수량≥20 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1493 comp_price_id=3509
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3509, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 20, 5900, '엽서북/135*135/단면/20P 수량≥20 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1494 comp_price_id=3510
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3510, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 20, 6500, '엽서북/135*135/단면/30P 수량≥20 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1495 comp_price_id=3511
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3511, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 20, 6200, '엽서북/135*135/양면/20P 수량≥20 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1496 comp_price_id=3512
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3512, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 20, 6800, '엽서북/135*135/양면/30P 수량≥20 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1497 comp_price_id=3513
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3513, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 30, 5030, '엽서북/100*150/단면/20P 수량≥30 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1498 comp_price_id=3514
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3514, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 30, 5800, '엽서북/100*150/단면/30P 수량≥30 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1499 comp_price_id=3515
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3515, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 30, 5230, '엽서북/100*150/양면/20P 수량≥30 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1500 comp_price_id=3516
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3516, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 30, 6000, '엽서북/100*150/양면/30P 수량≥30 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1501 comp_price_id=3517
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3517, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 30, 5030, '엽서북/150*100/단면/20P 수량≥30 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1502 comp_price_id=3518
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3518, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 30, 5800, '엽서북/150*100/단면/30P 수량≥30 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1503 comp_price_id=3519
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3519, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 30, 5230, '엽서북/150*100/양면/20P 수량≥30 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1504 comp_price_id=3520
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3520, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 30, 6000, '엽서북/150*100/양면/30P 수량≥30 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1505 comp_price_id=3521
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3521, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 30, 5750, '엽서북/135*135/단면/20P 수량≥30 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1506 comp_price_id=3522
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3522, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 30, 6350, '엽서북/135*135/단면/30P 수량≥30 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1507 comp_price_id=3523
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3523, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 30, 6050, '엽서북/135*135/양면/20P 수량≥30 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1508 comp_price_id=3524
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3524, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 30, 6650, '엽서북/135*135/양면/30P 수량≥30 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1509 comp_price_id=3525
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3525, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 40, 4870, '엽서북/100*150/단면/20P 수량≥40 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1510 comp_price_id=3526
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3526, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 40, 5600, '엽서북/100*150/단면/30P 수량≥40 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1511 comp_price_id=3527
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3527, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 40, 5070, '엽서북/100*150/양면/20P 수량≥40 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1512 comp_price_id=3528
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3528, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 40, 5800, '엽서북/100*150/양면/30P 수량≥40 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1513 comp_price_id=3529
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3529, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 40, 4870, '엽서북/150*100/단면/20P 수량≥40 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1514 comp_price_id=3530
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3530, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 40, 5600, '엽서북/150*100/단면/30P 수량≥40 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1515 comp_price_id=3531
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3531, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 40, 5070, '엽서북/150*100/양면/20P 수량≥40 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1516 comp_price_id=3532
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3532, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 40, 5800, '엽서북/150*100/양면/30P 수량≥40 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1517 comp_price_id=3533
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3533, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 40, 5600, '엽서북/135*135/단면/20P 수량≥40 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1518 comp_price_id=3534
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3534, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 40, 6200, '엽서북/135*135/단면/30P 수량≥40 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1519 comp_price_id=3535
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3535, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 40, 5900, '엽서북/135*135/양면/20P 수량≥40 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1520 comp_price_id=3536
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3536, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 40, 6500, '엽서북/135*135/양면/30P 수량≥40 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1521 comp_price_id=3537
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3537, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 50, 4700, '엽서북/100*150/단면/20P 수량≥50 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1522 comp_price_id=3538
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3538, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 50, 5400, '엽서북/100*150/단면/30P 수량≥50 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1523 comp_price_id=3539
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3539, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 50, 4900, '엽서북/100*150/양면/20P 수량≥50 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1524 comp_price_id=3540
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3540, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 50, 5600, '엽서북/100*150/양면/30P 수량≥50 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1525 comp_price_id=3541
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3541, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 50, 4700, '엽서북/150*100/단면/20P 수량≥50 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1526 comp_price_id=3542
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3542, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 50, 5400, '엽서북/150*100/단면/30P 수량≥50 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1527 comp_price_id=3543
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3543, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 50, 4900, '엽서북/150*100/양면/20P 수량≥50 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1528 comp_price_id=3544
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3544, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 50, 5600, '엽서북/150*100/양면/30P 수량≥50 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1529 comp_price_id=3545
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3545, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 50, 5450, '엽서북/135*135/단면/20P 수량≥50 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1530 comp_price_id=3546
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3546, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 50, 6050, '엽서북/135*135/단면/30P 수량≥50 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1531 comp_price_id=3547
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3547, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 50, 5750, '엽서북/135*135/양면/20P 수량≥50 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1532 comp_price_id=3548
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3548, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 50, 6350, '엽서북/135*135/양면/30P 수량≥50 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1533 comp_price_id=3549
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3549, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 60, 4660, '엽서북/100*150/단면/20P 수량≥60 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1534 comp_price_id=3550
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3550, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 60, 5340, '엽서북/100*150/단면/30P 수량≥60 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1535 comp_price_id=3551
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3551, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 60, 4820, '엽서북/100*150/양면/20P 수량≥60 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1536 comp_price_id=3552
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3552, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 60, 5540, '엽서북/100*150/양면/30P 수량≥60 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1537 comp_price_id=3553
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3553, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 60, 4660, '엽서북/150*100/단면/20P 수량≥60 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1538 comp_price_id=3554
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3554, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 60, 5340, '엽서북/150*100/단면/30P 수량≥60 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1539 comp_price_id=3555
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3555, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 60, 4820, '엽서북/150*100/양면/20P 수량≥60 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1540 comp_price_id=3556
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3556, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 60, 5540, '엽서북/150*100/양면/30P 수량≥60 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1541 comp_price_id=3557
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3557, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 60, 5380, '엽서북/135*135/단면/20P 수량≥60 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1542 comp_price_id=3558
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3558, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 60, 5980, '엽서북/135*135/단면/30P 수량≥60 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1543 comp_price_id=3559
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3559, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 60, 5680, '엽서북/135*135/양면/20P 수량≥60 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1544 comp_price_id=3560
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3560, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 60, 6280, '엽서북/135*135/양면/30P 수량≥60 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1545 comp_price_id=3561
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3561, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 70, 4620, '엽서북/100*150/단면/20P 수량≥70 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1546 comp_price_id=3562
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3562, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 70, 5280, '엽서북/100*150/단면/30P 수량≥70 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1547 comp_price_id=3563
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3563, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 70, 4740, '엽서북/100*150/양면/20P 수량≥70 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1548 comp_price_id=3564
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3564, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 70, 5480, '엽서북/100*150/양면/30P 수량≥70 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1549 comp_price_id=3565
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3565, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 70, 4620, '엽서북/150*100/단면/20P 수량≥70 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1550 comp_price_id=3566
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3566, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 70, 5280, '엽서북/150*100/단면/30P 수량≥70 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1551 comp_price_id=3567
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3567, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 70, 4740, '엽서북/150*100/양면/20P 수량≥70 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1552 comp_price_id=3568
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3568, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 70, 5480, '엽서북/150*100/양면/30P 수량≥70 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1553 comp_price_id=3569
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3569, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 70, 5310, '엽서북/135*135/단면/20P 수량≥70 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1554 comp_price_id=3570
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3570, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 70, 5910, '엽서북/135*135/단면/30P 수량≥70 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1555 comp_price_id=3571
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3571, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 70, 5610, '엽서북/135*135/양면/20P 수량≥70 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1556 comp_price_id=3572
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3572, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 70, 6210, '엽서북/135*135/양면/30P 수량≥70 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1557 comp_price_id=3573
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3573, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 80, 4580, '엽서북/100*150/단면/20P 수량≥80 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1558 comp_price_id=3574
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3574, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 80, 5220, '엽서북/100*150/단면/30P 수량≥80 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1559 comp_price_id=3575
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3575, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 80, 4660, '엽서북/100*150/양면/20P 수량≥80 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1560 comp_price_id=3576
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3576, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 80, 5420, '엽서북/100*150/양면/30P 수량≥80 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1561 comp_price_id=3577
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3577, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 80, 4580, '엽서북/150*100/단면/20P 수량≥80 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1562 comp_price_id=3578
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3578, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 80, 5220, '엽서북/150*100/단면/30P 수량≥80 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1563 comp_price_id=3579
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3579, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 80, 4660, '엽서북/150*100/양면/20P 수량≥80 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1564 comp_price_id=3580
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3580, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 80, 5420, '엽서북/150*100/양면/30P 수량≥80 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1565 comp_price_id=3581
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3581, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 80, 5240, '엽서북/135*135/단면/20P 수량≥80 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1566 comp_price_id=3582
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3582, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 80, 5840, '엽서북/135*135/단면/30P 수량≥80 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1567 comp_price_id=3583
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3583, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 80, 5540, '엽서북/135*135/양면/20P 수량≥80 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1568 comp_price_id=3584
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3584, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 80, 6140, '엽서북/135*135/양면/30P 수량≥80 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1569 comp_price_id=3585
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3585, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 90, 4540, '엽서북/100*150/단면/20P 수량≥90 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1570 comp_price_id=3586
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3586, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 90, 5160, '엽서북/100*150/단면/30P 수량≥90 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1571 comp_price_id=3587
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3587, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 90, 4580, '엽서북/100*150/양면/20P 수량≥90 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1572 comp_price_id=3588
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3588, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 90, 5360, '엽서북/100*150/양면/30P 수량≥90 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1573 comp_price_id=3589
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3589, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 90, 4540, '엽서북/150*100/단면/20P 수량≥90 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1574 comp_price_id=3590
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3590, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 90, 5160, '엽서북/150*100/단면/30P 수량≥90 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1575 comp_price_id=3591
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3591, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 90, 4580, '엽서북/150*100/양면/20P 수량≥90 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1576 comp_price_id=3592
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3592, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 90, 5360, '엽서북/150*100/양면/30P 수량≥90 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1577 comp_price_id=3593
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3593, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 90, 5170, '엽서북/135*135/단면/20P 수량≥90 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1578 comp_price_id=3594
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3594, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 90, 5770, '엽서북/135*135/단면/30P 수량≥90 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1579 comp_price_id=3595
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3595, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 90, 5470, '엽서북/135*135/양면/20P 수량≥90 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1580 comp_price_id=3596
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3596, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 90, 6070, '엽서북/135*135/양면/30P 수량≥90 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1581 comp_price_id=3597
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3597, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 100, 4500, '엽서북/100*150/단면/20P 수량≥100 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1582 comp_price_id=3598
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3598, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 100, 5100, '엽서북/100*150/단면/30P 수량≥100 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1583 comp_price_id=3599
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3599, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 100, 4500, '엽서북/100*150/양면/20P 수량≥100 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1584 comp_price_id=3600
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3600, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 100, 5300, '엽서북/100*150/양면/30P 수량≥100 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1585 comp_price_id=3601
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3601, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 100, 4500, '엽서북/150*100/단면/20P 수량≥100 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1586 comp_price_id=3602
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3602, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 100, 5100, '엽서북/150*100/단면/30P 수량≥100 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1587 comp_price_id=3603
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3603, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 100, 4500, '엽서북/150*100/양면/20P 수량≥100 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1588 comp_price_id=3604
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3604, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 100, 5300, '엽서북/150*100/양면/30P 수량≥100 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1589 comp_price_id=3605
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3605, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 100, 5100, '엽서북/135*135/단면/20P 수량≥100 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1590 comp_price_id=3606
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3606, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 100, 5700, '엽서북/135*135/단면/30P 수량≥100 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1591 comp_price_id=3607
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3607, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 100, 5400, '엽서북/135*135/양면/20P 수량≥100 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1592 comp_price_id=3608
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3608, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 100, 6000, '엽서북/135*135/양면/30P 수량≥100 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1593 comp_price_id=3609
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3609, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 120, 4340, '엽서북/100*150/단면/20P 수량≥120 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1594 comp_price_id=3610
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3610, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 120, 4980, '엽서북/100*150/단면/30P 수량≥120 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1595 comp_price_id=3611
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3611, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 120, 4380, '엽서북/100*150/양면/20P 수량≥120 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1596 comp_price_id=3612
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3612, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 120, 5180, '엽서북/100*150/양면/30P 수량≥120 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1597 comp_price_id=3613
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3613, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 120, 4340, '엽서북/150*100/단면/20P 수량≥120 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1598 comp_price_id=3614
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3614, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 120, 4980, '엽서북/150*100/단면/30P 수량≥120 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1599 comp_price_id=3615
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3615, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 120, 4380, '엽서북/150*100/양면/20P 수량≥120 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1600 comp_price_id=3616
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3616, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 120, 5180, '엽서북/150*100/양면/30P 수량≥120 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1601 comp_price_id=3617
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3617, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 120, 4960, '엽서북/135*135/단면/20P 수량≥120 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1602 comp_price_id=3618
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3618, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 120, 5540, '엽서북/135*135/단면/30P 수량≥120 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1603 comp_price_id=3619
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3619, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 120, 5260, '엽서북/135*135/양면/20P 수량≥120 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1604 comp_price_id=3620
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3620, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 120, 5840, '엽서북/135*135/양면/30P 수량≥120 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1605 comp_price_id=3621
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3621, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 140, 4180, '엽서북/100*150/단면/20P 수량≥140 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1606 comp_price_id=3622
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3622, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 140, 4860, '엽서북/100*150/단면/30P 수량≥140 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1607 comp_price_id=3623
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3623, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 140, 4260, '엽서북/100*150/양면/20P 수량≥140 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1608 comp_price_id=3624
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3624, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 140, 5060, '엽서북/100*150/양면/30P 수량≥140 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1609 comp_price_id=3625
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3625, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 140, 4180, '엽서북/150*100/단면/20P 수량≥140 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1610 comp_price_id=3626
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3626, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 140, 4860, '엽서북/150*100/단면/30P 수량≥140 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1611 comp_price_id=3627
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3627, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 140, 4260, '엽서북/150*100/양면/20P 수량≥140 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1612 comp_price_id=3628
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3628, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 140, 5060, '엽서북/150*100/양면/30P 수량≥140 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1613 comp_price_id=3629
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3629, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 140, 4820, '엽서북/135*135/단면/20P 수량≥140 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1614 comp_price_id=3630
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3630, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 140, 5380, '엽서북/135*135/단면/30P 수량≥140 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1615 comp_price_id=3631
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3631, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 140, 5120, '엽서북/135*135/양면/20P 수량≥140 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1616 comp_price_id=3632
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3632, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 140, 5680, '엽서북/135*135/양면/30P 수량≥140 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1617 comp_price_id=3633
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3633, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 160, 4020, '엽서북/100*150/단면/20P 수량≥160 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1618 comp_price_id=3634
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3634, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 160, 4740, '엽서북/100*150/단면/30P 수량≥160 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1619 comp_price_id=3635
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3635, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 160, 4140, '엽서북/100*150/양면/20P 수량≥160 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1620 comp_price_id=3636
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3636, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 160, 4940, '엽서북/100*150/양면/30P 수량≥160 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1621 comp_price_id=3637
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3637, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 160, 4020, '엽서북/150*100/단면/20P 수량≥160 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1622 comp_price_id=3638
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3638, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 160, 4740, '엽서북/150*100/단면/30P 수량≥160 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1623 comp_price_id=3639
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3639, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 160, 4140, '엽서북/150*100/양면/20P 수량≥160 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1624 comp_price_id=3640
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3640, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 160, 4940, '엽서북/150*100/양면/30P 수량≥160 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1625 comp_price_id=3641
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3641, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 160, 4680, '엽서북/135*135/단면/20P 수량≥160 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1626 comp_price_id=3642
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3642, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 160, 5220, '엽서북/135*135/단면/30P 수량≥160 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1627 comp_price_id=3643
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3643, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 160, 4980, '엽서북/135*135/양면/20P 수량≥160 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1628 comp_price_id=3644
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3644, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 160, 5520, '엽서북/135*135/양면/30P 수량≥160 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1629 comp_price_id=3645
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3645, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 180, 3860, '엽서북/100*150/단면/20P 수량≥180 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1630 comp_price_id=3646
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3646, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 180, 4620, '엽서북/100*150/단면/30P 수량≥180 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1631 comp_price_id=3647
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3647, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 180, 4020, '엽서북/100*150/양면/20P 수량≥180 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1632 comp_price_id=3648
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3648, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 180, 4820, '엽서북/100*150/양면/30P 수량≥180 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1633 comp_price_id=3649
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3649, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 180, 3860, '엽서북/150*100/단면/20P 수량≥180 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1634 comp_price_id=3650
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3650, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 180, 4620, '엽서북/150*100/단면/30P 수량≥180 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1635 comp_price_id=3651
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3651, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 180, 4020, '엽서북/150*100/양면/20P 수량≥180 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1636 comp_price_id=3652
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3652, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 180, 4820, '엽서북/150*100/양면/30P 수량≥180 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1637 comp_price_id=3653
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3653, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 180, 4540, '엽서북/135*135/단면/20P 수량≥180 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1638 comp_price_id=3654
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3654, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 180, 5060, '엽서북/135*135/단면/30P 수량≥180 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1639 comp_price_id=3655
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3655, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 180, 4840, '엽서북/135*135/양면/20P 수량≥180 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1640 comp_price_id=3656
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3656, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 180, 5360, '엽서북/135*135/양면/30P 수량≥180 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1641 comp_price_id=3657
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3657, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 200, 3700, '엽서북/100*150/단면/20P 수량≥200 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1642 comp_price_id=3658
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3658, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 200, 4500, '엽서북/100*150/단면/30P 수량≥200 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1643 comp_price_id=3659
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3659, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 200, 3900, '엽서북/100*150/양면/20P 수량≥200 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1644 comp_price_id=3660
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3660, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 200, 4700, '엽서북/100*150/양면/30P 수량≥200 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1645 comp_price_id=3661
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3661, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 200, 3700, '엽서북/150*100/단면/20P 수량≥200 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1646 comp_price_id=3662
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3662, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 200, 4500, '엽서북/150*100/단면/30P 수량≥200 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1647 comp_price_id=3663
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3663, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 200, 3900, '엽서북/150*100/양면/20P 수량≥200 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1648 comp_price_id=3664
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3664, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 200, 4700, '엽서북/150*100/양면/30P 수량≥200 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1649 comp_price_id=3665
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3665, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 200, 4400, '엽서북/135*135/단면/20P 수량≥200 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1650 comp_price_id=3666
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3666, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 200, 4900, '엽서북/135*135/단면/30P 수량≥200 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1651 comp_price_id=3667
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3667, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 200, 4700, '엽서북/135*135/양면/20P 수량≥200 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1652 comp_price_id=3668
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3668, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 200, 5200, '엽서북/135*135/양면/30P 수량≥200 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1653 comp_price_id=3669
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3669, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 250, 3570, '엽서북/100*150/단면/20P 수량≥250 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1654 comp_price_id=3670
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3670, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 250, 4400, '엽서북/100*150/단면/30P 수량≥250 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1655 comp_price_id=3671
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3671, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 250, 3770, '엽서북/100*150/양면/20P 수량≥250 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1656 comp_price_id=3672
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3672, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 250, 4600, '엽서북/100*150/양면/30P 수량≥250 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1657 comp_price_id=3673
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3673, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 250, 3570, '엽서북/150*100/단면/20P 수량≥250 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1658 comp_price_id=3674
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3674, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 250, 4400, '엽서북/150*100/단면/30P 수량≥250 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1659 comp_price_id=3675
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3675, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 250, 3770, '엽서북/150*100/양면/20P 수량≥250 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1660 comp_price_id=3676
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3676, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 250, 4600, '엽서북/150*100/양면/30P 수량≥250 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1661 comp_price_id=3677
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3677, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 250, 4350, '엽서북/135*135/단면/20P 수량≥250 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1662 comp_price_id=3678
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3678, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 250, 4850, '엽서북/135*135/단면/30P 수량≥250 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1663 comp_price_id=3679
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3679, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 250, 4650, '엽서북/135*135/양면/20P 수량≥250 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1664 comp_price_id=3680
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3680, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 250, 5150, '엽서북/135*135/양면/30P 수량≥250 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1665 comp_price_id=3681
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3681, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 300, 3450, '엽서북/100*150/단면/20P 수량≥300 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1666 comp_price_id=3682
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3682, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 300, 4300, '엽서북/100*150/단면/30P 수량≥300 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1667 comp_price_id=3683
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3683, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 300, 3650, '엽서북/100*150/양면/20P 수량≥300 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1668 comp_price_id=3684
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3684, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 300, 4500, '엽서북/100*150/양면/30P 수량≥300 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1669 comp_price_id=3685
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3685, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 300, 3450, '엽서북/150*100/단면/20P 수량≥300 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1670 comp_price_id=3686
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3686, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 300, 4300, '엽서북/150*100/단면/30P 수량≥300 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1671 comp_price_id=3687
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3687, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 300, 3650, '엽서북/150*100/양면/20P 수량≥300 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1672 comp_price_id=3688
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3688, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 300, 4500, '엽서북/150*100/양면/30P 수량≥300 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1673 comp_price_id=3689
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3689, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 300, 4300, '엽서북/135*135/단면/20P 수량≥300 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1674 comp_price_id=3690
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3690, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 300, 4800, '엽서북/135*135/단면/30P 수량≥300 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1675 comp_price_id=3691
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3691, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 300, 4600, '엽서북/135*135/양면/20P 수량≥300 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1676 comp_price_id=3692
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3692, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 300, 5100, '엽서북/135*135/양면/30P 수량≥300 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1677 comp_price_id=3693
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3693, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 350, 3300, '엽서북/100*150/단면/20P 수량≥350 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1678 comp_price_id=3694
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3694, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 350, 4150, '엽서북/100*150/단면/30P 수량≥350 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1679 comp_price_id=3695
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3695, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 350, 3500, '엽서북/100*150/양면/20P 수량≥350 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1680 comp_price_id=3696
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3696, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 350, 4350, '엽서북/100*150/양면/30P 수량≥350 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1681 comp_price_id=3697
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3697, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 350, 3300, '엽서북/150*100/단면/20P 수량≥350 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1682 comp_price_id=3698
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3698, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 350, 4150, '엽서북/150*100/단면/30P 수량≥350 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1683 comp_price_id=3699
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3699, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 350, 3500, '엽서북/150*100/양면/20P 수량≥350 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1684 comp_price_id=3700
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3700, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 350, 4350, '엽서북/150*100/양면/30P 수량≥350 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1685 comp_price_id=3701
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3701, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 350, 4200, '엽서북/135*135/단면/20P 수량≥350 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1686 comp_price_id=3702
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3702, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 350, 4700, '엽서북/135*135/단면/30P 수량≥350 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1687 comp_price_id=3703
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3703, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 350, 4500, '엽서북/135*135/양면/20P 수량≥350 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1688 comp_price_id=3704
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3704, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 350, 5000, '엽서북/135*135/양면/30P 수량≥350 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1689 comp_price_id=3705
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3705, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 400, 3150, '엽서북/100*150/단면/20P 수량≥400 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1690 comp_price_id=3706
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3706, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 400, 4000, '엽서북/100*150/단면/30P 수량≥400 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1691 comp_price_id=3707
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3707, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 400, 3350, '엽서북/100*150/양면/20P 수량≥400 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1692 comp_price_id=3708
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3708, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 400, 4200, '엽서북/100*150/양면/30P 수량≥400 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1693 comp_price_id=3709
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3709, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 400, 3150, '엽서북/150*100/단면/20P 수량≥400 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1694 comp_price_id=3710
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3710, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 400, 4000, '엽서북/150*100/단면/30P 수량≥400 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1695 comp_price_id=3711
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3711, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 400, 3350, '엽서북/150*100/양면/20P 수량≥400 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1696 comp_price_id=3712
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3712, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 400, 4200, '엽서북/150*100/양면/30P 수량≥400 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1697 comp_price_id=3713
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3713, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 400, 4100, '엽서북/135*135/단면/20P 수량≥400 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1698 comp_price_id=3714
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3714, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 400, 4600, '엽서북/135*135/단면/30P 수량≥400 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1699 comp_price_id=3715
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3715, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 400, 4400, '엽서북/135*135/양면/20P 수량≥400 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1700 comp_price_id=3716
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3716, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 400, 4900, '엽서북/135*135/양면/30P 수량≥400 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1701 comp_price_id=3717
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3717, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 450, 3130, '엽서북/100*150/단면/20P 수량≥450 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1702 comp_price_id=3718
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3718, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 450, 3910, '엽서북/100*150/단면/30P 수량≥450 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1703 comp_price_id=3719
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3719, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 450, 3280, '엽서북/100*150/양면/20P 수량≥450 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1704 comp_price_id=3720
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3720, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 450, 4090, '엽서북/100*150/양면/30P 수량≥450 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1705 comp_price_id=3721
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3721, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 450, 3130, '엽서북/150*100/단면/20P 수량≥450 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1706 comp_price_id=3722
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3722, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 450, 3910, '엽서북/150*100/단면/30P 수량≥450 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1707 comp_price_id=3723
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3723, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 450, 3280, '엽서북/150*100/양면/20P 수량≥450 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1708 comp_price_id=3724
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3724, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 450, 4090, '엽서북/150*100/양면/30P 수량≥450 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1709 comp_price_id=3725
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3725, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 450, 3950, '엽서북/135*135/단면/20P 수량≥450 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1710 comp_price_id=3726
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3726, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 450, 4500, '엽서북/135*135/단면/30P 수량≥450 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1711 comp_price_id=3727
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3727, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 450, 4200, '엽서북/135*135/양면/20P 수량≥450 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1712 comp_price_id=3728
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3728, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 450, 4800, '엽서북/135*135/양면/30P 수량≥450 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1713 comp_price_id=3729
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3729, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 500, 3090, '엽서북/100*150/단면/20P 수량≥500 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1714 comp_price_id=3730
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3730, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 500, 3820, '엽서북/100*150/단면/30P 수량≥500 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1715 comp_price_id=3731
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3731, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 500, 3200, '엽서북/100*150/양면/20P 수량≥500 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1716 comp_price_id=3732
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3732, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 500, 3970, '엽서북/100*150/양면/30P 수량≥500 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1717 comp_price_id=3733
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3733, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 500, 3090, '엽서북/150*100/단면/20P 수량≥500 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1718 comp_price_id=3734
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3734, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 500, 3820, '엽서북/150*100/단면/30P 수량≥500 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1719 comp_price_id=3735
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3735, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 500, 3200, '엽서북/150*100/양면/20P 수량≥500 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1720 comp_price_id=3736
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3736, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 500, 3970, '엽서북/150*100/양면/30P 수량≥500 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1721 comp_price_id=3737
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3737, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 500, 3800, '엽서북/135*135/단면/20P 수량≥500 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1722 comp_price_id=3738
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3738, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 500, 4400, '엽서북/135*135/단면/30P 수량≥500 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1723 comp_price_id=3739
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3739, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 500, 4000, '엽서북/135*135/양면/20P 수량≥500 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1724 comp_price_id=3740
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3740, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 500, 4700, '엽서북/135*135/양면/30P 수량≥500 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1725 comp_price_id=3741
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3741, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 550, 3010, '엽서북/100*150/단면/20P 수량≥550 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1726 comp_price_id=3742
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3742, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 550, 3740, '엽서북/100*150/단면/30P 수량≥550 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1727 comp_price_id=3743
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3743, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 550, 3120, '엽서북/100*150/양면/20P 수량≥550 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1728 comp_price_id=3744
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3744, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 550, 3890, '엽서북/100*150/양면/30P 수량≥550 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1729 comp_price_id=3745
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3745, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 550, 3010, '엽서북/150*100/단면/20P 수량≥550 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1730 comp_price_id=3746
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3746, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 550, 3740, '엽서북/150*100/단면/30P 수량≥550 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1731 comp_price_id=3747
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3747, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 550, 3120, '엽서북/150*100/양면/20P 수량≥550 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1732 comp_price_id=3748
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3748, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 550, 3890, '엽서북/150*100/양면/30P 수량≥550 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1733 comp_price_id=3749
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3749, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 550, 3720, '엽서북/135*135/단면/20P 수량≥550 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1734 comp_price_id=3750
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3750, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 550, 4320, '엽서북/135*135/단면/30P 수량≥550 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1735 comp_price_id=3751
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3751, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 550, 3910, '엽서북/135*135/양면/20P 수량≥550 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1736 comp_price_id=3752
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3752, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 550, 4610, '엽서북/135*135/양면/30P 수량≥550 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1737 comp_price_id=3753
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3753, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 600, 2930, '엽서북/100*150/단면/20P 수량≥600 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1738 comp_price_id=3754
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3754, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 600, 3660, '엽서북/100*150/단면/30P 수량≥600 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1739 comp_price_id=3755
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3755, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 600, 3040, '엽서북/100*150/양면/20P 수량≥600 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1740 comp_price_id=3756
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3756, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 600, 3810, '엽서북/100*150/양면/30P 수량≥600 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1741 comp_price_id=3757
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3757, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 600, 2930, '엽서북/150*100/단면/20P 수량≥600 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1742 comp_price_id=3758
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3758, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 600, 3660, '엽서북/150*100/단면/30P 수량≥600 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1743 comp_price_id=3759
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3759, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 600, 3040, '엽서북/150*100/양면/20P 수량≥600 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1744 comp_price_id=3760
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3760, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 600, 3810, '엽서북/150*100/양면/30P 수량≥600 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1745 comp_price_id=3761
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3761, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 600, 3640, '엽서북/135*135/단면/20P 수량≥600 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1746 comp_price_id=3762
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3762, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 600, 4340, '엽서북/135*135/단면/30P 수량≥600 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1747 comp_price_id=3763
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3763, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 600, 3820, '엽서북/135*135/양면/20P 수량≥600 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1748 comp_price_id=3764
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3764, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 600, 4520, '엽서북/135*135/양면/30P 수량≥600 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1749 comp_price_id=3765
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3765, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 650, 2850, '엽서북/100*150/단면/20P 수량≥650 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1750 comp_price_id=3766
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3766, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 650, 3580, '엽서북/100*150/단면/30P 수량≥650 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1751 comp_price_id=3767
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3767, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 650, 2960, '엽서북/100*150/양면/20P 수량≥650 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1752 comp_price_id=3768
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3768, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 650, 3730, '엽서북/100*150/양면/30P 수량≥650 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1753 comp_price_id=3769
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3769, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 650, 2850, '엽서북/150*100/단면/20P 수량≥650 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1754 comp_price_id=3770
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3770, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 650, 3580, '엽서북/150*100/단면/30P 수량≥650 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1755 comp_price_id=3771
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3771, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 650, 2960, '엽서북/150*100/양면/20P 수량≥650 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1756 comp_price_id=3772
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3772, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 650, 3730, '엽서북/150*100/양면/30P 수량≥650 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1757 comp_price_id=3773
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3773, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 650, 3560, '엽서북/135*135/단면/20P 수량≥650 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1758 comp_price_id=3774
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3774, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 650, 4160, '엽서북/135*135/단면/30P 수량≥650 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1759 comp_price_id=3775
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3775, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 650, 3730, '엽서북/135*135/양면/20P 수량≥650 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1760 comp_price_id=3776
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3776, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 650, 4430, '엽서북/135*135/양면/30P 수량≥650 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1761 comp_price_id=3777
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3777, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 700, 2770, '엽서북/100*150/단면/20P 수량≥700 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1762 comp_price_id=3778
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3778, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 700, 3500, '엽서북/100*150/단면/30P 수량≥700 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1763 comp_price_id=3779
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3779, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 700, 2880, '엽서북/100*150/양면/20P 수량≥700 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1764 comp_price_id=3780
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3780, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 700, 3650, '엽서북/100*150/양면/30P 수량≥700 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1765 comp_price_id=3781
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3781, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 700, 2770, '엽서북/150*100/단면/20P 수량≥700 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1766 comp_price_id=3782
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3782, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 700, 3500, '엽서북/150*100/단면/30P 수량≥700 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1767 comp_price_id=3783
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3783, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 700, 2880, '엽서북/150*100/양면/20P 수량≥700 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1768 comp_price_id=3784
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3784, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 700, 3650, '엽서북/150*100/양면/30P 수량≥700 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1769 comp_price_id=3785
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3785, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 700, 3480, '엽서북/135*135/단면/20P 수량≥700 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1770 comp_price_id=3786
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3786, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 700, 4080, '엽서북/135*135/단면/30P 수량≥700 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1771 comp_price_id=3787
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3787, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 700, 3640, '엽서북/135*135/양면/20P 수량≥700 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1772 comp_price_id=3788
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3788, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 700, 4340, '엽서북/135*135/양면/30P 수량≥700 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1773 comp_price_id=3789
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3789, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 750, 2690, '엽서북/100*150/단면/20P 수량≥750 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1774 comp_price_id=3790
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3790, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 750, 3420, '엽서북/100*150/단면/30P 수량≥750 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1775 comp_price_id=3791
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3791, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 750, 2800, '엽서북/100*150/양면/20P 수량≥750 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1776 comp_price_id=3792
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3792, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 750, 3570, '엽서북/100*150/양면/30P 수량≥750 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1777 comp_price_id=3793
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3793, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 750, 2690, '엽서북/150*100/단면/20P 수량≥750 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1778 comp_price_id=3794
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3794, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 750, 3420, '엽서북/150*100/단면/30P 수량≥750 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1779 comp_price_id=3795
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3795, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 750, 2800, '엽서북/150*100/양면/20P 수량≥750 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1780 comp_price_id=3796
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3796, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 750, 3570, '엽서북/150*100/양면/30P 수량≥750 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1781 comp_price_id=3797
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3797, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 750, 3400, '엽서북/135*135/단면/20P 수량≥750 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1782 comp_price_id=3798
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3798, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 750, 4000, '엽서북/135*135/단면/30P 수량≥750 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1783 comp_price_id=3799
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3799, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 750, 3550, '엽서북/135*135/양면/20P 수량≥750 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1784 comp_price_id=3800
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3800, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 750, 4250, '엽서북/135*135/양면/30P 수량≥750 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1785 comp_price_id=3801
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3801, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 800, 2610, '엽서북/100*150/단면/20P 수량≥800 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1786 comp_price_id=3802
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3802, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 800, 3340, '엽서북/100*150/단면/30P 수량≥800 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1787 comp_price_id=3803
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3803, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 800, 2720, '엽서북/100*150/양면/20P 수량≥800 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1788 comp_price_id=3804
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3804, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 800, 3490, '엽서북/100*150/양면/30P 수량≥800 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1789 comp_price_id=3805
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3805, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 800, 2610, '엽서북/150*100/단면/20P 수량≥800 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1790 comp_price_id=3806
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3806, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 800, 3340, '엽서북/150*100/단면/30P 수량≥800 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1791 comp_price_id=3807
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3807, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 800, 2720, '엽서북/150*100/양면/20P 수량≥800 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1792 comp_price_id=3808
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3808, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 800, 3490, '엽서북/150*100/양면/30P 수량≥800 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1793 comp_price_id=3809
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3809, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 800, 3320, '엽서북/135*135/단면/20P 수량≥800 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1794 comp_price_id=3810
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3810, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 800, 3920, '엽서북/135*135/단면/30P 수량≥800 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1795 comp_price_id=3811
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3811, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 800, 3460, '엽서북/135*135/양면/20P 수량≥800 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1796 comp_price_id=3812
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3812, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 800, 4160, '엽서북/135*135/양면/30P 수량≥800 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1797 comp_price_id=3813
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3813, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 850, 2530, '엽서북/100*150/단면/20P 수량≥850 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1798 comp_price_id=3814
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3814, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 850, 3260, '엽서북/100*150/단면/30P 수량≥850 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1799 comp_price_id=3815
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3815, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 850, 2640, '엽서북/100*150/양면/20P 수량≥850 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1800 comp_price_id=3816
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3816, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 850, 3410, '엽서북/100*150/양면/30P 수량≥850 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1801 comp_price_id=3817
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3817, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 850, 2530, '엽서북/150*100/단면/20P 수량≥850 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1802 comp_price_id=3818
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3818, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 850, 3180, '엽서북/150*100/단면/30P 수량≥850 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1803 comp_price_id=3819
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3819, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 850, 2640, '엽서북/150*100/양면/20P 수량≥850 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1804 comp_price_id=3820
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3820, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 850, 3410, '엽서북/150*100/양면/30P 수량≥850 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1805 comp_price_id=3821
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3821, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 850, 3240, '엽서북/135*135/단면/20P 수량≥850 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1806 comp_price_id=3822
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3822, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 850, 3840, '엽서북/135*135/단면/30P 수량≥850 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1807 comp_price_id=3823
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3823, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 850, 3370, '엽서북/135*135/양면/20P 수량≥850 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1808 comp_price_id=3824
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3824, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 850, 4070, '엽서북/135*135/양면/30P 수량≥850 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1809 comp_price_id=3825
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3825, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 900, 2450, '엽서북/100*150/단면/20P 수량≥900 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1810 comp_price_id=3826
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3826, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 900, 3180, '엽서북/100*150/단면/30P 수량≥900 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1811 comp_price_id=3827
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3827, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 900, 2560, '엽서북/100*150/양면/20P 수량≥900 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1812 comp_price_id=3828
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3828, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 900, 3330, '엽서북/100*150/양면/30P 수량≥900 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1813 comp_price_id=3829
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3829, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 900, 2450, '엽서북/150*100/단면/20P 수량≥900 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1814 comp_price_id=3830
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3830, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 900, 3100, '엽서북/150*100/단면/30P 수량≥900 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1815 comp_price_id=3831
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3831, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 900, 2560, '엽서북/150*100/양면/20P 수량≥900 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1816 comp_price_id=3832
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3832, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 900, 3330, '엽서북/150*100/양면/30P 수량≥900 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1817 comp_price_id=3833
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3833, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 900, 3160, '엽서북/135*135/단면/20P 수량≥900 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1818 comp_price_id=3834
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3834, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 900, 3760, '엽서북/135*135/단면/30P 수량≥900 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1819 comp_price_id=3835
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3835, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 900, 3280, '엽서북/135*135/양면/20P 수량≥900 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1820 comp_price_id=3836
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3836, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 900, 3980, '엽서북/135*135/양면/30P 수량≥900 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1821 comp_price_id=3837
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3837, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 950, 2370, '엽서북/100*150/단면/20P 수량≥950 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1822 comp_price_id=3838
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3838, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 950, 3100, '엽서북/100*150/단면/30P 수량≥950 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1823 comp_price_id=3839
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3839, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 950, 2480, '엽서북/100*150/양면/20P 수량≥950 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1824 comp_price_id=3840
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3840, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 950, 3280, '엽서북/100*150/양면/30P 수량≥950 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1825 comp_price_id=3841
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3841, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 950, 2370, '엽서북/150*100/단면/20P 수량≥950 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1826 comp_price_id=3842
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3842, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 950, 3020, '엽서북/150*100/단면/30P 수량≥950 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1827 comp_price_id=3843
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3843, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 950, 2480, '엽서북/150*100/양면/20P 수량≥950 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1828 comp_price_id=3844
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3844, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 950, 3250, '엽서북/150*100/양면/30P 수량≥950 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1829 comp_price_id=3845
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3845, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 950, 3080, '엽서북/135*135/단면/20P 수량≥950 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1830 comp_price_id=3846
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3846, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 950, 3680, '엽서북/135*135/단면/30P 수량≥950 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1831 comp_price_id=3847
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3847, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 950, 3190, '엽서북/135*135/양면/20P 수량≥950 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1832 comp_price_id=3848
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3848, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 950, 3890, '엽서북/135*135/양면/30P 수량≥950 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1833 comp_price_id=3849
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3849, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 1000, 2290, '엽서북/100*150/단면/20P 수량≥1000 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1834 comp_price_id=3850
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3850, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 1000, 3020, '엽서북/100*150/단면/30P 수량≥1000 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1835 comp_price_id=3851
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3851, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 1000, 2400, '엽서북/100*150/양면/20P 수량≥1000 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1836 comp_price_id=3852
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3852, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 1000, 3200, '엽서북/100*150/양면/30P 수량≥1000 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1837 comp_price_id=3853
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3853, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 1000, 2290, '엽서북/150*100/단면/20P 수량≥1000 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1838 comp_price_id=3854
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3854, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 1000, 3020, '엽서북/150*100/단면/30P 수량≥1000 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1839 comp_price_id=3855
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3855, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 1000, 2400, '엽서북/150*100/양면/20P 수량≥1000 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1840 comp_price_id=3856
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3856, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 1000, 3170, '엽서북/150*100/양면/30P 수량≥1000 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1841 comp_price_id=3857
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3857, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 1000, 3000, '엽서북/135*135/단면/20P 수량≥1000 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1842 comp_price_id=3858
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3858, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 1000, 3600, '엽서북/135*135/단면/30P 수량≥1000 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1843 comp_price_id=3859
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3859, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 1000, 3100, '엽서북/135*135/양면/20P 수량≥1000 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1844 comp_price_id=3860
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3860, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 1000, 3800, '엽서북/135*135/양면/30P 수량≥1000 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1845 comp_price_id=3861
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3861, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 1500, 2270, '엽서북/100*150/단면/20P 수량≥1500 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1846 comp_price_id=3862
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3862, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 1500, 2990, '엽서북/100*150/단면/30P 수량≥1500 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1847 comp_price_id=3863
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3863, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 1500, 2380, '엽서북/100*150/양면/20P 수량≥1500 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1848 comp_price_id=3864
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3864, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 1500, 3180, '엽서북/100*150/양면/30P 수량≥1500 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1849 comp_price_id=3865
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3865, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 1500, 2270, '엽서북/150*100/단면/20P 수량≥1500 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1850 comp_price_id=3866
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3866, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 1500, 2990, '엽서북/150*100/단면/30P 수량≥1500 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1851 comp_price_id=3867
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3867, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 1500, 2380, '엽서북/150*100/양면/20P 수량≥1500 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1852 comp_price_id=3868
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3868, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 1500, 3180, '엽서북/150*100/양면/30P 수량≥1500 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1853 comp_price_id=3869
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3869, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 1500, 2950, '엽서북/135*135/단면/20P 수량≥1500 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1854 comp_price_id=3870
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3870, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 1500, 3550, '엽서북/135*135/단면/30P 수량≥1500 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1855 comp_price_id=3871
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3871, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 1500, 3050, '엽서북/135*135/양면/20P 수량≥1500 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1856 comp_price_id=3872
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3872, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 1500, 3750, '엽서북/135*135/양면/30P 수량≥1500 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1857 comp_price_id=3873
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3873, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 2000, 2250, '엽서북/100*150/단면/20P 수량≥2000 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1858 comp_price_id=3874
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3874, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 2000, 2960, '엽서북/100*150/단면/30P 수량≥2000 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1859 comp_price_id=3875
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3875, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 2000, 2360, '엽서북/100*150/양면/20P 수량≥2000 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1860 comp_price_id=3876
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3876, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 2000, 3160, '엽서북/100*150/양면/30P 수량≥2000 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1861 comp_price_id=3877
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3877, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 2000, 2250, '엽서북/150*100/단면/20P 수량≥2000 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1862 comp_price_id=3878
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3878, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 2000, 2960, '엽서북/150*100/단면/30P 수량≥2000 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1863 comp_price_id=3879
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3879, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 2000, 2360, '엽서북/150*100/양면/20P 수량≥2000 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1864 comp_price_id=3880
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3880, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 2000, 3160, '엽서북/150*100/양면/30P 수량≥2000 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1865 comp_price_id=3881
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3881, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 2000, 2900, '엽서북/135*135/단면/20P 수량≥2000 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1866 comp_price_id=3882
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3882, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 2000, 3500, '엽서북/135*135/단면/30P 수량≥2000 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1867 comp_price_id=3883
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3883, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 2000, 3000, '엽서북/135*135/양면/20P 수량≥2000 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1868 comp_price_id=3884
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3884, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 2000, 3700, '엽서북/135*135/양면/30P 수량≥2000 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1869 comp_price_id=3885
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3885, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 2500, 2230, '엽서북/100*150/단면/20P 수량≥2500 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1870 comp_price_id=3886
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3886, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 2500, 2930, '엽서북/100*150/단면/30P 수량≥2500 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1871 comp_price_id=3887
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3887, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 2500, 2330, '엽서북/100*150/양면/20P 수량≥2500 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1872 comp_price_id=3888
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3888, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 2500, 3130, '엽서북/100*150/양면/30P 수량≥2500 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1873 comp_price_id=3889
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3889, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 2500, 2230, '엽서북/150*100/단면/20P 수량≥2500 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1874 comp_price_id=3890
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3890, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 2500, 2930, '엽서북/150*100/단면/30P 수량≥2500 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1875 comp_price_id=3891
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3891, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 2500, 2330, '엽서북/150*100/양면/20P 수량≥2500 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1876 comp_price_id=3892
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3892, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 2500, 3130, '엽서북/150*100/양면/30P 수량≥2500 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1877 comp_price_id=3893
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3893, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 2500, 2850, '엽서북/135*135/단면/20P 수량≥2500 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1878 comp_price_id=3894
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3894, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 2500, 3450, '엽서북/135*135/단면/30P 수량≥2500 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1879 comp_price_id=3895
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3895, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 2500, 2950, '엽서북/135*135/양면/20P 수량≥2500 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1880 comp_price_id=3896
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3896, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 2500, 3650, '엽서북/135*135/양면/30P 수량≥2500 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1881 comp_price_id=3897
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3897, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 3000, 2200, '엽서북/100*150/단면/20P 수량≥3000 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1882 comp_price_id=3898
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3898, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 3000, 2900, '엽서북/100*150/단면/30P 수량≥3000 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1883 comp_price_id=3899
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3899, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 3000, 2300, '엽서북/100*150/양면/20P 수량≥3000 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1884 comp_price_id=3900
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3900, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000003', NULL, NULL, NULL, NULL, 3000, 3100, '엽서북/100*150/양면/30P 수량≥3000 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1885 comp_price_id=3901
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3901, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 3000, 2200, '엽서북/150*100/단면/20P 수량≥3000 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1886 comp_price_id=3902
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3902, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 3000, 2900, '엽서북/150*100/단면/30P 수량≥3000 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1887 comp_price_id=3903
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3903, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 3000, 2300, '엽서북/150*100/양면/20P 수량≥3000 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1888 comp_price_id=3904
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3904, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000124', NULL, NULL, NULL, NULL, 3000, 3100, '엽서북/150*100/양면/30P 수량≥3000 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1889 comp_price_id=3905
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3905, 'COMP_PCB_S1_20P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 3000, 2800, '엽서북/135*135/단면/20P 수량≥3000 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1890 comp_price_id=3906
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3906, 'COMP_PCB_S1_30P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 3000, 3400, '엽서북/135*135/단면/30P 수량≥3000 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1891 comp_price_id=3907
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3907, 'COMP_PCB_S2_20P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 3000, 2900, '엽서북/135*135/양면/20P 수량≥3000 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1892 comp_price_id=3908
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3908, 'COMP_PCB_S2_30P', '2026-06-01', 'SIZ_000004', NULL, NULL, NULL, NULL, 3000, 3600, '엽서북/135*135/양면/30P 수량≥3000 (페이지=comp흡수 차원부재, 면=comp흡수)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1893 comp_price_id=3909
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3909, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000119', NULL, NULL, NULL, 50, 6, 3000, '떡메모지/90x90mm/50장1권 장수≥6 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1894 comp_price_id=3910
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3910, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000119', NULL, NULL, NULL, 100, 6, 3200, '떡메모지/90x90mm/100장1권 장수≥6 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1895 comp_price_id=3911
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3911, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000266', NULL, NULL, NULL, 50, 6, 3000, '떡메모지/70x120mm/50장1권 장수≥6 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1896 comp_price_id=3912
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3912, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000266', NULL, NULL, NULL, 100, 6, 3200, '떡메모지/70x120mm/100장1권 장수≥6 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1897 comp_price_id=3913
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3913, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000119', NULL, NULL, NULL, 50, 12, 2300, '떡메모지/90x90mm/50장1권 장수≥12 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1898 comp_price_id=3914
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3914, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000119', NULL, NULL, NULL, 100, 12, 2500, '떡메모지/90x90mm/100장1권 장수≥12 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1899 comp_price_id=3915
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3915, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000266', NULL, NULL, NULL, 50, 12, 2300, '떡메모지/70x120mm/50장1권 장수≥12 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1900 comp_price_id=3916
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3916, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000266', NULL, NULL, NULL, 100, 12, 2500, '떡메모지/70x120mm/100장1권 장수≥12 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1901 comp_price_id=3917
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3917, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000119', NULL, NULL, NULL, 50, 18, 2200, '떡메모지/90x90mm/50장1권 장수≥18 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1902 comp_price_id=3918
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3918, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000119', NULL, NULL, NULL, 100, 18, 2400, '떡메모지/90x90mm/100장1권 장수≥18 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1903 comp_price_id=3919
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3919, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000266', NULL, NULL, NULL, 50, 18, 2200, '떡메모지/70x120mm/50장1권 장수≥18 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1904 comp_price_id=3920
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3920, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000266', NULL, NULL, NULL, 100, 18, 2400, '떡메모지/70x120mm/100장1권 장수≥18 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1905 comp_price_id=3921
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3921, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000119', NULL, NULL, NULL, 50, 24, 2100, '떡메모지/90x90mm/50장1권 장수≥24 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1906 comp_price_id=3922
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3922, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000119', NULL, NULL, NULL, 100, 24, 2300, '떡메모지/90x90mm/100장1권 장수≥24 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1907 comp_price_id=3923
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3923, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000266', NULL, NULL, NULL, 50, 24, 2100, '떡메모지/70x120mm/50장1권 장수≥24 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1908 comp_price_id=3924
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3924, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000266', NULL, NULL, NULL, 100, 24, 2300, '떡메모지/70x120mm/100장1권 장수≥24 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1909 comp_price_id=3925
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3925, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000119', NULL, NULL, NULL, 50, 30, 2000, '떡메모지/90x90mm/50장1권 장수≥30 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1910 comp_price_id=3926
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3926, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000119', NULL, NULL, NULL, 100, 30, 2200, '떡메모지/90x90mm/100장1권 장수≥30 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1911 comp_price_id=3927
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3927, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000266', NULL, NULL, NULL, 50, 30, 2000, '떡메모지/70x120mm/50장1권 장수≥30 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1912 comp_price_id=3928
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3928, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000266', NULL, NULL, NULL, 100, 30, 2200, '떡메모지/70x120mm/100장1권 장수≥30 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1913 comp_price_id=3929
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3929, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000119', NULL, NULL, NULL, 50, 36, 1900, '떡메모지/90x90mm/50장1권 장수≥36 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1914 comp_price_id=3930
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3930, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000119', NULL, NULL, NULL, 100, 36, 2100, '떡메모지/90x90mm/100장1권 장수≥36 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1915 comp_price_id=3931
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3931, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000266', NULL, NULL, NULL, 50, 36, 1900, '떡메모지/70x120mm/50장1권 장수≥36 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1916 comp_price_id=3932
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3932, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000266', NULL, NULL, NULL, 100, 36, 2100, '떡메모지/70x120mm/100장1권 장수≥36 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1917 comp_price_id=3933
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3933, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000119', NULL, NULL, NULL, 50, 42, 1800, '떡메모지/90x90mm/50장1권 장수≥42 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1918 comp_price_id=3934
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3934, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000119', NULL, NULL, NULL, 100, 42, 2000, '떡메모지/90x90mm/100장1권 장수≥42 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1919 comp_price_id=3935
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3935, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000266', NULL, NULL, NULL, 50, 42, 1800, '떡메모지/70x120mm/50장1권 장수≥42 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1920 comp_price_id=3936
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3936, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000266', NULL, NULL, NULL, 100, 42, 2000, '떡메모지/70x120mm/100장1권 장수≥42 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1921 comp_price_id=3937
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3937, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000119', NULL, NULL, NULL, 50, 48, 1700, '떡메모지/90x90mm/50장1권 장수≥48 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1922 comp_price_id=3938
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3938, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000119', NULL, NULL, NULL, 100, 48, 1900, '떡메모지/90x90mm/100장1권 장수≥48 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1923 comp_price_id=3939
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3939, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000266', NULL, NULL, NULL, 50, 48, 1700, '떡메모지/70x120mm/50장1권 장수≥48 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1924 comp_price_id=3940
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3940, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000266', NULL, NULL, NULL, 100, 48, 1900, '떡메모지/70x120mm/100장1권 장수≥48 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1925 comp_price_id=3941
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3941, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000119', NULL, NULL, NULL, 50, 54, 1600, '떡메모지/90x90mm/50장1권 장수≥54 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1926 comp_price_id=3942
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3942, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000119', NULL, NULL, NULL, 100, 54, 1800, '떡메모지/90x90mm/100장1권 장수≥54 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1927 comp_price_id=3943
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3943, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000266', NULL, NULL, NULL, 50, 54, 1600, '떡메모지/70x120mm/50장1권 장수≥54 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1928 comp_price_id=3944
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3944, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000266', NULL, NULL, NULL, 100, 54, 1800, '떡메모지/70x120mm/100장1권 장수≥54 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1929 comp_price_id=3945
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3945, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000119', NULL, NULL, NULL, 50, 60, 1500, '떡메모지/90x90mm/50장1권 장수≥60 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1930 comp_price_id=3946
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3946, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000119', NULL, NULL, NULL, 100, 60, 1700, '떡메모지/90x90mm/100장1권 장수≥60 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1931 comp_price_id=3947
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3947, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000266', NULL, NULL, NULL, 50, 60, 1500, '떡메모지/70x120mm/50장1권 장수≥60 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1932 comp_price_id=3948
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3948, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000266', NULL, NULL, NULL, 100, 60, 1700, '떡메모지/70x120mm/100장1권 장수≥60 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1933 comp_price_id=3949
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3949, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000119', NULL, NULL, NULL, 50, 66, 1400, '떡메모지/90x90mm/50장1권 장수≥66 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1934 comp_price_id=3950
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3950, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000119', NULL, NULL, NULL, 100, 66, 1600, '떡메모지/90x90mm/100장1권 장수≥66 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1935 comp_price_id=3951
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3951, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000266', NULL, NULL, NULL, 50, 66, 1400, '떡메모지/70x120mm/50장1권 장수≥66 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1936 comp_price_id=3952
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3952, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000266', NULL, NULL, NULL, 100, 66, 1600, '떡메모지/70x120mm/100장1권 장수≥66 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1937 comp_price_id=3953
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3953, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000119', NULL, NULL, NULL, 50, 84, 1350, '떡메모지/90x90mm/50장1권 장수≥84 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1938 comp_price_id=3954
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3954, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000119', NULL, NULL, NULL, 100, 84, 1550, '떡메모지/90x90mm/100장1권 장수≥84 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1939 comp_price_id=3955
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3955, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000266', NULL, NULL, NULL, 50, 84, 1350, '떡메모지/70x120mm/50장1권 장수≥84 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1940 comp_price_id=3956
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3956, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000266', NULL, NULL, NULL, 100, 84, 1550, '떡메모지/70x120mm/100장1권 장수≥84 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1941 comp_price_id=3957
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3957, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000119', NULL, NULL, NULL, 50, 108, 1300, '떡메모지/90x90mm/50장1권 장수≥108 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1942 comp_price_id=3958
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3958, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000119', NULL, NULL, NULL, 100, 108, 1500, '떡메모지/90x90mm/100장1권 장수≥108 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1943 comp_price_id=3959
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3959, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000266', NULL, NULL, NULL, 50, 108, 1300, '떡메모지/70x120mm/50장1권 장수≥108 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1944 comp_price_id=3960
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3960, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000266', NULL, NULL, NULL, 100, 108, 1500, '떡메모지/70x120mm/100장1권 장수≥108 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1945 comp_price_id=3961
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3961, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000119', NULL, NULL, NULL, 50, 120, 1250, '떡메모지/90x90mm/50장1권 장수≥120 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1946 comp_price_id=3962
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3962, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000119', NULL, NULL, NULL, 100, 120, 1450, '떡메모지/90x90mm/100장1권 장수≥120 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1947 comp_price_id=3963
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3963, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000266', NULL, NULL, NULL, 50, 120, 1250, '떡메모지/70x120mm/50장1권 장수≥120 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1948 comp_price_id=3964
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3964, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000266', NULL, NULL, NULL, 100, 120, 1450, '떡메모지/70x120mm/100장1권 장수≥120 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1949 comp_price_id=3965
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3965, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000119', NULL, NULL, NULL, 50, 156, 1200, '떡메모지/90x90mm/50장1권 장수≥156 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1950 comp_price_id=3966
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3966, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000119', NULL, NULL, NULL, 100, 156, 1400, '떡메모지/90x90mm/100장1권 장수≥156 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1951 comp_price_id=3967
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3967, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000266', NULL, NULL, NULL, 50, 156, 1200, '떡메모지/70x120mm/50장1권 장수≥156 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1952 comp_price_id=3968
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3968, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000266', NULL, NULL, NULL, 100, 156, 1400, '떡메모지/70x120mm/100장1권 장수≥156 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1953 comp_price_id=3969
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3969, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000119', NULL, NULL, NULL, 50, 180, 1150, '떡메모지/90x90mm/50장1권 장수≥180 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1954 comp_price_id=3970
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3970, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000119', NULL, NULL, NULL, 100, 180, 1350, '떡메모지/90x90mm/100장1권 장수≥180 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1955 comp_price_id=3971
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3971, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000266', NULL, NULL, NULL, 50, 180, 1150, '떡메모지/70x120mm/50장1권 장수≥180 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1956 comp_price_id=3972
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3972, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000266', NULL, NULL, NULL, 100, 180, 1350, '떡메모지/70x120mm/100장1권 장수≥180 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1957 comp_price_id=3973
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3973, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000119', NULL, NULL, NULL, 50, 204, 1100, '떡메모지/90x90mm/50장1권 장수≥204 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1958 comp_price_id=3974
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3974, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000119', NULL, NULL, NULL, 100, 204, 1300, '떡메모지/90x90mm/100장1권 장수≥204 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1959 comp_price_id=3975
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3975, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000266', NULL, NULL, NULL, 50, 204, 1100, '떡메모지/70x120mm/50장1권 장수≥204 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1960 comp_price_id=3976
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3976, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000266', NULL, NULL, NULL, 100, 204, 1300, '떡메모지/70x120mm/100장1권 장수≥204 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1961 comp_price_id=3977
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3977, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000119', NULL, NULL, NULL, 50, 240, 1100, '떡메모지/90x90mm/50장1권 장수≥240 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1962 comp_price_id=3978
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3978, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000119', NULL, NULL, NULL, 100, 240, 1300, '떡메모지/90x90mm/100장1권 장수≥240 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1963 comp_price_id=3979
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3979, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000266', NULL, NULL, NULL, 50, 240, 1100, '떡메모지/70x120mm/50장1권 장수≥240 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1964 comp_price_id=3980
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3980, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000266', NULL, NULL, NULL, 100, 240, 1300, '떡메모지/70x120mm/100장1권 장수≥240 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1965 comp_price_id=3981
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3981, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000119', NULL, NULL, NULL, 50, 264, 1100, '떡메모지/90x90mm/50장1권 장수≥264 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1966 comp_price_id=3982
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3982, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000119', NULL, NULL, NULL, 100, 264, 1300, '떡메모지/90x90mm/100장1권 장수≥264 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1967 comp_price_id=3983
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3983, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000266', NULL, NULL, NULL, 50, 264, 1100, '떡메모지/70x120mm/50장1권 장수≥264 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1968 comp_price_id=3984
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3984, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000266', NULL, NULL, NULL, 100, 264, 1300, '떡메모지/70x120mm/100장1권 장수≥264 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1969 comp_price_id=3985
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3985, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000119', NULL, NULL, NULL, 50, 300, 1050, '떡메모지/90x90mm/50장1권 장수≥300 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1970 comp_price_id=3986
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3986, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000119', NULL, NULL, NULL, 100, 300, 1250, '떡메모지/90x90mm/100장1권 장수≥300 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1971 comp_price_id=3987
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3987, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000266', NULL, NULL, NULL, 50, 300, 1050, '떡메모지/70x120mm/50장1권 장수≥300 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1972 comp_price_id=3988
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3988, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000266', NULL, NULL, NULL, 100, 300, 1250, '떡메모지/70x120mm/100장1권 장수≥300 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1973 comp_price_id=3989
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3989, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000119', NULL, NULL, NULL, 50, 324, 1000, '떡메모지/90x90mm/50장1권 장수≥324 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1974 comp_price_id=3990
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3990, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000119', NULL, NULL, NULL, 100, 324, 1200, '떡메모지/90x90mm/100장1권 장수≥324 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1975 comp_price_id=3991
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3991, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000266', NULL, NULL, NULL, 50, 324, 1000, '떡메모지/70x120mm/50장1권 장수≥324 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1976 comp_price_id=3992
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3992, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000266', NULL, NULL, NULL, 100, 324, 1200, '떡메모지/70x120mm/100장1권 장수≥324 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1977 comp_price_id=3993
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3993, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000119', NULL, NULL, NULL, 50, 360, 1000, '떡메모지/90x90mm/50장1권 장수≥360 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1978 comp_price_id=3994
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3994, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000119', NULL, NULL, NULL, 100, 360, 1200, '떡메모지/90x90mm/100장1권 장수≥360 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1979 comp_price_id=3995
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3995, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000266', NULL, NULL, NULL, 50, 360, 1000, '떡메모지/70x120mm/50장1권 장수≥360 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1980 comp_price_id=3996
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3996, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000266', NULL, NULL, NULL, 100, 360, 1200, '떡메모지/70x120mm/100장1권 장수≥360 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1981 comp_price_id=3997
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3997, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000119', NULL, NULL, NULL, 50, 396, 1000, '떡메모지/90x90mm/50장1권 장수≥396 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1982 comp_price_id=3998
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3998, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000119', NULL, NULL, NULL, 100, 396, 1200, '떡메모지/90x90mm/100장1권 장수≥396 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1983 comp_price_id=3999
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (3999, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000266', NULL, NULL, NULL, 50, 396, 1000, '떡메모지/70x120mm/50장1권 장수≥396 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1984 comp_price_id=4000
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4000, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000266', NULL, NULL, NULL, 100, 396, 1200, '떡메모지/70x120mm/100장1권 장수≥396 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1985 comp_price_id=4001
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4001, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000119', NULL, NULL, NULL, 50, 420, 950, '떡메모지/90x90mm/50장1권 장수≥420 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1986 comp_price_id=4002
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4002, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000119', NULL, NULL, NULL, 100, 420, 1150, '떡메모지/90x90mm/100장1권 장수≥420 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1987 comp_price_id=4003
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4003, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000266', NULL, NULL, NULL, 50, 420, 950, '떡메모지/70x120mm/50장1권 장수≥420 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1988 comp_price_id=4004
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4004, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000266', NULL, NULL, NULL, 100, 420, 1150, '떡메모지/70x120mm/100장1권 장수≥420 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1989 comp_price_id=4005
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4005, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000119', NULL, NULL, NULL, 50, 456, 950, '떡메모지/90x90mm/50장1권 장수≥456 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1990 comp_price_id=4006
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4006, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000119', NULL, NULL, NULL, 100, 456, 1150, '떡메모지/90x90mm/100장1권 장수≥456 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1991 comp_price_id=4007
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4007, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000266', NULL, NULL, NULL, 50, 456, 950, '떡메모지/70x120mm/50장1권 장수≥456 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1992 comp_price_id=4008
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4008, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000266', NULL, NULL, NULL, 100, 456, 1150, '떡메모지/70x120mm/100장1권 장수≥456 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1993 comp_price_id=4009
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4009, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000119', NULL, NULL, NULL, 50, 504, 900, '떡메모지/90x90mm/50장1권 장수≥504 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1994 comp_price_id=4010
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4010, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000119', NULL, NULL, NULL, 100, 504, 1100, '떡메모지/90x90mm/100장1권 장수≥504 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1995 comp_price_id=4011
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4011, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000266', NULL, NULL, NULL, 50, 504, 900, '떡메모지/70x120mm/50장1권 장수≥504 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1996 comp_price_id=4012
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4012, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000266', NULL, NULL, NULL, 100, 504, 1100, '떡메모지/70x120mm/100장1권 장수≥504 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1997 comp_price_id=4013
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4013, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000119', NULL, NULL, NULL, 50, 540, 900, '떡메모지/90x90mm/50장1권 장수≥540 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1998 comp_price_id=4014
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4014, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000119', NULL, NULL, NULL, 100, 540, 1100, '떡메모지/90x90mm/100장1권 장수≥540 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row1999 comp_price_id=4015
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4015, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000266', NULL, NULL, NULL, 50, 540, 900, '떡메모지/70x120mm/50장1권 장수≥540 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2000 comp_price_id=4016
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4016, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000266', NULL, NULL, NULL, 100, 540, 1100, '떡메모지/70x120mm/100장1권 장수≥540 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2001 comp_price_id=4017
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4017, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000119', NULL, NULL, NULL, 50, 600, 850, '떡메모지/90x90mm/50장1권 장수≥600 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2002 comp_price_id=4018
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4018, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000119', NULL, NULL, NULL, 100, 600, 1050, '떡메모지/90x90mm/100장1권 장수≥600 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2003 comp_price_id=4019
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4019, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000266', NULL, NULL, NULL, 50, 600, 850, '떡메모지/70x120mm/50장1권 장수≥600 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2004 comp_price_id=4020
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4020, 'COMP_TTEOKME', '2026-06-01', 'SIZ_000266', NULL, NULL, NULL, 100, 600, 1050, '떡메모지/70x120mm/100장1권 장수≥600 (권당장수=bdl_qty, 장수=min_qty, PRD_000097)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2005 comp_price_id=4045
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4045, 'COMP_POSTER_ARTPRINT_PHOTO', '2026-06-01', 'SIZ_000321', NULL, NULL, NULL, NULL, NULL, 21600, '아트프린트포스터(인화지) 가로600mm×세로1800mm 완제품가[코팅포함가] (라이브 siz SIZ_000321 실코드, 완제품비.06)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2006 comp_price_id=4084
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4084, 'COMP_POSTER_ARTPAPER_MATTE', '2026-06-01', 'SIZ_000320', NULL, NULL, NULL, NULL, NULL, 21600, '아트페이퍼포스터(매트지) 가로900mm×세로1200mm 완제품가[출력가] (라이브 siz SIZ_000320 실코드, 완제품비.06)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2007 comp_price_id=4091
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4091, 'COMP_POSTER_ARTPAPER_MATTE', '2026-06-01', 'SIZ_000321', NULL, NULL, NULL, NULL, NULL, 21600, '아트페이퍼포스터(매트지) 가로600mm×세로1800mm 완제품가[출력가] (라이브 siz SIZ_000321 실코드, 완제품비.06)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2008 comp_price_id=4136
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4136, 'COMP_POSTER_WATERPROOF_PET', '2026-06-01', 'SIZ_000321', NULL, NULL, NULL, NULL, NULL, 21600, '방수포스터(PET) 가로600mm×세로1800mm 완제품가[코팅포함가] (라이브 siz SIZ_000321 실코드, 완제품비.06)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2009 comp_price_id=4188
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4188, 'COMP_POSTER_ADH_WATERPROOF_PVC', '2026-06-01', 'SIZ_000321', NULL, NULL, NULL, NULL, NULL, 21600, '접착방수포스터(PVC) 가로600mm×세로1800mm 완제품가[코팅포함가] (라이브 siz SIZ_000321 실코드, 완제품비.06)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2010 comp_price_id=4240
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4240, 'COMP_POSTER_ADH_CLEAR_PVC', '2026-06-01', 'SIZ_000321', NULL, NULL, NULL, NULL, NULL, 59400, '접착투명포스터(투명PVC) 가로600mm×세로1800mm 완제품가[출력가] (라이브 siz SIZ_000321 실코드, 완제품비.06)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2011 comp_price_id=4292
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4292, 'COMP_POSTER_ARTFABRIC_GRAPHIC', '2026-06-01', 'SIZ_000321', NULL, NULL, NULL, NULL, NULL, 21600, '아트패브릭포스터(그래픽천) 가로600mm×세로1800mm 완제품가[출력가] (라이브 siz SIZ_000321 실코드, 완제품비.06)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2012 comp_price_id=4344
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4344, 'COMP_POSTER_LINEN_FABRIC', '2026-06-01', 'SIZ_000321', NULL, NULL, NULL, NULL, NULL, 32400, '린넨패브릭포스터 가로600mm×세로1800mm 완제품가[린넨후가공 포함] (라이브 siz SIZ_000321 실코드, 완제품비.06)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2013 comp_price_id=4396
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4396, 'COMP_POSTER_CANVAS_FABRIC', '2026-06-01', 'SIZ_000321', NULL, NULL, NULL, NULL, NULL, 37800, '캔버스패브릭포스터 가로600mm×세로1800mm 완제품가[출력가] (라이브 siz SIZ_000321 실코드, 완제품비.06)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2014 comp_price_id=4448
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4448, 'COMP_POSTER_LEATHER_ARTPRINT', '2026-06-01', 'SIZ_000321', NULL, NULL, NULL, NULL, NULL, 37800, '레더아트프린트 가로600mm×세로1800mm 완제품가[출력가] (라이브 siz SIZ_000321 실코드, 완제품비.06)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2015 comp_price_id=4500
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4500, 'COMP_POSTER_TYVEK_PRINT', '2026-06-01', 'SIZ_000321', NULL, NULL, NULL, NULL, NULL, 37800, '타이벡프린트(하드/소프트) 가로600mm×세로1800mm 완제품가[출력가] (라이브 siz SIZ_000321 실코드, 완제품비.06)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2016 comp_price_id=4552
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4552, 'COMP_POSTER_MESH_PRINT', '2026-06-01', 'SIZ_000321', NULL, NULL, NULL, NULL, NULL, 37800, '메쉬프린트 가로600mm×세로1800mm 완제품가[출력+코팅+가공 포함가] (라이브 siz SIZ_000321 실코드, 완제품비.06)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2017 comp_price_id=4580
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4580, 'COMP_POSTER_FRAMELESS_WOOD', '2026-06-01', 'SIZ_000315', NULL, NULL, NULL, NULL, 1, 16000, '프레임리스우드액자 A3 수량≥1 완제품가[출력+코팅+가공 포함가] (라이브 siz SIZ_000315 실코드, 완제품비.06)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2018 comp_price_id=4581
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4581, 'COMP_POSTER_FRAMELESS_WOOD', '2026-06-01', 'SIZ_000317', NULL, NULL, NULL, NULL, 1, 23000, '프레임리스우드액자 A2 수량≥1 완제품가[출력+코팅+가공 포함가] (라이브 siz SIZ_000317 실코드, 완제품비.06)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2019 comp_price_id=4587
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4587, 'COMP_POSTER_LEATHER_FRAME', '2026-06-01', 'SIZ_000258', NULL, NULL, NULL, NULL, 1, 16000, '레더아트액자 A4 수량≥1 완제품가[출력+가공 포함가] (라이브 siz SIZ_000258 실코드, 완제품비.06)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2020 comp_price_id=4588
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4588, 'COMP_POSTER_LEATHER_FRAME', '2026-06-01', 'SIZ_000315', NULL, NULL, NULL, NULL, 1, 21000, '레더아트액자 A3 수량≥1 완제품가[출력+가공 포함가] (라이브 siz SIZ_000315 실코드, 완제품비.06)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2021 comp_price_id=4589
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4589, 'COMP_POSTER_JOKJA', '2026-06-01', 'SIZ_000315', NULL, NULL, NULL, NULL, 1, 13000, '족자포스터 A3 수량≥1 완제품가[출력+코팅+가공(사각족자/원형족자) 포함가] (라이브 siz SIZ_000315 실코드, 완제품비.06)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2022 comp_price_id=4590
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4590, 'COMP_POSTER_JOKJA', '2026-06-01', 'SIZ_000317', NULL, NULL, NULL, NULL, 1, 15000, '족자포스터 A2 수량≥1 완제품가[출력+코팅+가공(사각족자/원형족자) 포함가] (라이브 siz SIZ_000317 실코드, 완제품비.06)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2023 comp_price_id=4592
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4592, 'COMP_POSTER_JOKJA', '2026-06-01', 'SIZ_000319', NULL, NULL, NULL, NULL, 1, 15000, '족자포스터 300*600 수량≥1 완제품가[출력+코팅+가공(사각족자/원형족자) 포함가] (라이브 siz SIZ_000319 실코드, 완제품비.06)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2024 comp_price_id=4593
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4593, 'COMP_POSTER_JOKJA', '2026-06-01', 'SIZ_000320', NULL, NULL, NULL, NULL, 1, 32000, '족자포스터 900*1200 수량≥1 완제품가[출력+코팅+가공(사각족자/원형족자) 포함가] (라이브 siz SIZ_000320 실코드, 완제품비.06)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2025 comp_price_id=4594
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4594, 'COMP_POSTEROPT_JOKJA_CEILHOOK', '2026-06-01', NULL, NULL, NULL, NULL, 2, NULL, 6500, '족자포스터 추가옵션 천정형고리 포함 추가가격 (별도 add-on, *2개 1세트=bdl_qty 2)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2026 comp_price_id=4595
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4595, 'COMP_POSTER_CANVAS_HANGING', '2026-06-01', 'SIZ_000258', NULL, NULL, NULL, NULL, 1, 6000, '캔버스행잉포스터 A4 수량≥1 완제품가[출력+가공(오버로크) 포함가] (라이브 siz SIZ_000258 실코드, 완제품비.06)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2027 comp_price_id=4596
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4596, 'COMP_POSTER_CANVAS_HANGING', '2026-06-01', 'SIZ_000315', NULL, NULL, NULL, NULL, 1, 10500, '캔버스행잉포스터 A3 수량≥1 완제품가[출력+가공(오버로크) 포함가] (라이브 siz SIZ_000315 실코드, 완제품비.06)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2028 comp_price_id=4597
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4597, 'COMP_POSTER_CANVAS_HANGING', '2026-06-01', 'SIZ_000317', NULL, NULL, NULL, NULL, 1, 20000, '캔버스행잉포스터 A2 수량≥1 완제품가[출력+가공(오버로크) 포함가] (라이브 siz SIZ_000317 실코드, 완제품비.06)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2029 comp_price_id=4598
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4598, 'COMP_POSTEROPT_CANVAS_HANGING_WOODHANGER', '2026-06-01', 'SIZ_000258', NULL, NULL, NULL, NULL, NULL, 16000, '캔버스행잉포스터 추가옵션 우드행거+면끈/A4 추가가격 (별도 add-on, 라이브 siz SIZ_000258 실코드)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2030 comp_price_id=4599
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4599, 'COMP_POSTEROPT_CANVAS_HANGING_WOODHANGER', '2026-06-01', 'SIZ_000315', NULL, NULL, NULL, NULL, NULL, 18000, '캔버스행잉포스터 추가옵션 우드행거+면끈/A3 추가가격 (별도 add-on, 라이브 siz SIZ_000315 실코드)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2031 comp_price_id=4600
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4600, 'COMP_POSTEROPT_CANVAS_HANGING_WOODHANGER', '2026-06-01', 'SIZ_000317', NULL, NULL, NULL, NULL, NULL, 20000, '캔버스행잉포스터 추가옵션 우드행거+면끈/A2 추가가격 (별도 add-on, 라이브 siz SIZ_000317 실코드)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2032 comp_price_id=4601
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4601, 'COMP_POSTER_LINEN_WOODBONG', '2026-06-01', 'SIZ_000258', NULL, NULL, NULL, NULL, 1, 6000, '린넨우드봉족자 A4 수량≥1 완제품가[출력+가공(봉미싱) 포함가] (라이브 siz SIZ_000258 실코드, 완제품비.06)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2033 comp_price_id=4602
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4602, 'COMP_POSTER_LINEN_WOODBONG', '2026-06-01', 'SIZ_000315', NULL, NULL, NULL, NULL, 1, 8200, '린넨우드봉족자 A3 수량≥1 완제품가[출력+가공(봉미싱) 포함가] (라이브 siz SIZ_000315 실코드, 완제품비.06)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2034 comp_price_id=4603
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4603, 'COMP_POSTER_LINEN_WOODBONG', '2026-06-01', 'SIZ_000317', NULL, NULL, NULL, NULL, 1, 16000, '린넨우드봉족자 A2 수량≥1 완제품가[출력+가공(봉미싱) 포함가] (라이브 siz SIZ_000317 실코드, 완제품비.06)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2035 comp_price_id=4604
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4604, 'COMP_POSTEROPT_LINEN_WOODBONG_WOODBONG', '2026-06-01', 'SIZ_000258', NULL, NULL, NULL, NULL, NULL, 7000, '린넨우드봉족자 추가옵션 우드봉+면끈/A4 추가가격 (별도 add-on, 라이브 siz SIZ_000258 실코드)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2036 comp_price_id=4605
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4605, 'COMP_POSTEROPT_LINEN_WOODBONG_WOODBONG', '2026-06-01', 'SIZ_000315', NULL, NULL, NULL, NULL, NULL, 9800, '린넨우드봉족자 추가옵션 우드봉+면끈/A3 추가가격 (별도 add-on, 라이브 siz SIZ_000315 실코드)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2037 comp_price_id=4606
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4606, 'COMP_POSTEROPT_LINEN_WOODBONG_WOODBONG', '2026-06-01', 'SIZ_000317', NULL, NULL, NULL, NULL, NULL, 12000, '린넨우드봉족자 추가옵션 우드봉+면끈/A2 추가가격 (별도 add-on, 라이브 siz SIZ_000317 실코드)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2038 comp_price_id=4607
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4607, 'COMP_POSTER_PET_BANNER', '2026-06-01', 'SIZ_000321', NULL, NULL, NULL, NULL, 1, 22000, 'PET배너 600x1800 mm 수량≥1 완제품가[출력+코팅+가공(4구아일렛) 포함가] (라이브 siz SIZ_000321 실코드, 완제품비.06)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2039 comp_price_id=4608
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4608, 'COMP_POSTEROPT_PET_BANNER_STAND_IN', '2026-06-01', NULL, NULL, NULL, NULL, NULL, NULL, 7000, 'PET배너 추가옵션 실내용배너거치대 추가가격 (별도 add-on)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2040 comp_price_id=4609
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4609, 'COMP_POSTEROPT_PET_BANNER_STAND_OUT_S1', '2026-06-01', NULL, NULL, NULL, NULL, NULL, NULL, 23000, 'PET배너 추가옵션 실외용배너거치대(단면용) 추가가격 (별도 add-on)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2041 comp_price_id=4610
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4610, 'COMP_POSTEROPT_PET_BANNER_STAND_OUT_S2', '2026-06-01', NULL, NULL, NULL, NULL, NULL, NULL, 25000, 'PET배너 추가옵션 실외용배너거치대(양면용) 추가가격 (별도 add-on)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2042 comp_price_id=4611
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4611, 'COMP_POSTER_MESH_BANNER', '2026-06-01', 'SIZ_000321', NULL, NULL, NULL, NULL, 1, 38000, '메쉬배너 600x1800 mm 수량≥1 완제품가[출력+코팅+가공(4구아일렛) 포함가] (라이브 siz SIZ_000321 실코드, 완제품비.06)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2043 comp_price_id=4612
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4612, 'COMP_POSTER_BANNER_NORMAL', '2026-06-01', 'SIZ_000323', NULL, NULL, NULL, NULL, NULL, 8000, '일반현수막 가로900mm×세로900mm 완제품가[출력가] (라이브 siz SIZ_000323 실코드, 완제품비.06)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2044 comp_price_id=4620
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4620, 'COMP_POSTER_BANNER_NORMAL', '2026-06-01', 'SIZ_000403', NULL, NULL, NULL, NULL, NULL, 12000, '일반현수막 가로1500mm×세로1000mm 완제품가[출력가] (라이브 siz SIZ_000403 실코드, 완제품비.06)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2045 comp_price_id=4622
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4622, 'COMP_POSTER_BANNER_NORMAL', '2026-06-01', 'SIZ_000320', NULL, NULL, NULL, NULL, NULL, 8640, '일반현수막 가로900mm×세로1200mm 완제품가[출력가] (라이브 siz SIZ_000320 실코드, 완제품비.06)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2046 comp_price_id=4692
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4692, 'COMP_POSTEROPT_BANNER_NORMAL_PROC_CUTEDGE', '2026-06-01', NULL, NULL, NULL, NULL, NULL, NULL, 3000, '일반현수막 가공옵션 열재단 추가가격 (별도 add-on, 모든사이즈 공통)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2047 comp_price_id=4693
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4693, 'COMP_POSTEROPT_BANNER_NORMAL_PROC_PUNCH_4', '2026-06-01', NULL, NULL, NULL, NULL, NULL, NULL, 3000, '일반현수막 가공옵션 타공(4개) 추가가격 (별도 add-on, 모든사이즈 공통)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2048 comp_price_id=4694
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4694, 'COMP_POSTEROPT_BANNER_NORMAL_ADD_QBANG_4', '2026-06-01', NULL, NULL, NULL, NULL, NULL, NULL, 3000, '일반현수막 추가옵션 큐방(4개) 추가 추가가격 (별도 add-on)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2049 comp_price_id=4695
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4695, 'COMP_POSTEROPT_BANNER_NORMAL_PROC_PUNCH_6', '2026-06-01', NULL, NULL, NULL, NULL, NULL, NULL, 4000, '일반현수막 가공옵션 타공(6개) 추가가격 (별도 add-on, 모든사이즈 공통)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2050 comp_price_id=4696
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4696, 'COMP_POSTEROPT_BANNER_NORMAL_ADD_STRING_4', '2026-06-01', NULL, NULL, NULL, NULL, NULL, NULL, 4000, '일반현수막 추가옵션 끈(4개) 추가 추가가격 (별도 add-on)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2051 comp_price_id=4697
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4697, 'COMP_POSTEROPT_BANNER_NORMAL_PROC_PUNCH_8', '2026-06-01', NULL, NULL, NULL, NULL, NULL, NULL, 5000, '일반현수막 가공옵션 타공(8개) 추가가격 (별도 add-on, 모든사이즈 공통)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2052 comp_price_id=4698
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4698, 'COMP_POPT_BNR_GAKMOK_STR_900_4_LE', '2026-06-01', NULL, NULL, NULL, NULL, NULL, NULL, 4000, '일반현수막 추가옵션 각목(900mm이하)+끈(4개) 추가 추가가격 (별도 add-on)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2053 comp_price_id=4699
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4699, 'COMP_POSTEROPT_BANNER_NORMAL_PROC_DTAPE', '2026-06-01', NULL, NULL, NULL, NULL, NULL, NULL, 3000, '일반현수막 가공옵션 양면테잎 추가가격 (별도 add-on, 모든사이즈 공통)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2054 comp_price_id=4700
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4700, 'COMP_POPT_BNR_GAKMOK_STR_900_4_GT', '2026-06-01', NULL, NULL, NULL, NULL, NULL, NULL, 8000, '일반현수막 추가옵션 각목(900mm 초과)+끈(4개) 추가 추가가격 (별도 add-on)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2055 comp_price_id=4701
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4701, 'COMP_POSTEROPT_BANNER_NORMAL_PROC_BONGSEW', '2026-06-01', NULL, NULL, NULL, NULL, NULL, NULL, 4000, '일반현수막 가공옵션 봉미싱 추가가격 (별도 add-on, 모든사이즈 공통)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2056 comp_price_id=4702
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4702, 'COMP_POSTER_BANNER_MESH', '2026-06-01', 'SIZ_000323', NULL, NULL, NULL, NULL, NULL, 20000, '메쉬현수막 가로900mm×세로900mm 완제품가[출력가] (라이브 siz SIZ_000323 실코드, 완제품비.06)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2057 comp_price_id=4708
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4708, 'COMP_POSTER_BANNER_MESH', '2026-06-01', 'SIZ_000320', NULL, NULL, NULL, NULL, NULL, 21600, '메쉬현수막 가로900mm×세로1200mm 완제품가[출력가] (라이브 siz SIZ_000320 실코드, 완제품비.06)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2058 comp_price_id=4750
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4750, 'COMP_POSTEROPT_BANNER_MESH_PROC_PUNCH_4', '2026-06-01', NULL, NULL, NULL, NULL, NULL, NULL, 3000, '메쉬현수막 가공옵션 타공(4개) 추가가격 (별도 add-on, 모든사이즈 공통)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2059 comp_price_id=4751
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4751, 'COMP_POSTEROPT_BANNER_MESH_ADD_QBANG_4', '2026-06-01', NULL, NULL, NULL, NULL, NULL, NULL, 3000, '메쉬현수막 추가옵션 큐방(4개) 추가 추가가격 (별도 add-on)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2060 comp_price_id=4752
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4752, 'COMP_POSTEROPT_BANNER_MESH_PROC_PUNCH_6', '2026-06-01', NULL, NULL, NULL, NULL, NULL, NULL, 4000, '메쉬현수막 가공옵션 타공(6개) 추가가격 (별도 add-on, 모든사이즈 공통)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2061 comp_price_id=4753
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4753, 'COMP_POSTEROPT_BANNER_MESH_ADD_STRING_4', '2026-06-01', NULL, NULL, NULL, NULL, NULL, NULL, 4000, '메쉬현수막 추가옵션 끈(4개) 추가 추가가격 (별도 add-on)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2062 comp_price_id=4754
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4754, 'COMP_POSTEROPT_BANNER_MESH_PROC_PUNCH_8', '2026-06-01', NULL, NULL, NULL, NULL, NULL, NULL, 5000, '메쉬현수막 가공옵션 타공(8개) 추가가격 (별도 add-on, 모든사이즈 공통)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2063 comp_price_id=4755
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4755, 'COMP_POSTER_MINI_STANDBOARD', '2026-06-01', 'SIZ_000426', NULL, NULL, NULL, NULL, 4, 3500, '미니스탠딩보드 A5 수량≥4 완제품가[출력+코팅+가공(보드접착+거치대) 포함가] (라이브 siz SIZ_000426 실코드, 완제품비.06)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2064 comp_price_id=4756
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4756, 'COMP_POSTER_MINI_STANDBOARD', '2026-06-01', 'SIZ_000258', NULL, NULL, NULL, NULL, 4, 4500, '미니스탠딩보드 A4 수량≥4 완제품가[출력+코팅+가공(보드접착+거치대) 포함가] (라이브 siz SIZ_000258 실코드, 완제품비.06)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2065 comp_price_id=4757
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4757, 'COMP_POSTER_MINI_STANDBOARD', '2026-06-01', 'SIZ_000315', NULL, NULL, NULL, NULL, 4, 6500, '미니스탠딩보드 A3 수량≥4 완제품가[출력+코팅+가공(보드접착+거치대) 포함가] (라이브 siz SIZ_000315 실코드, 완제품비.06)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2066 comp_price_id=4758
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4758, 'COMP_POSTER_MINI_STANDBOARD', '2026-06-01', 'SIZ_000426', NULL, NULL, NULL, NULL, 19, 3400, '미니스탠딩보드 A5 수량≥19 완제품가[출력+코팅+가공(보드접착+거치대) 포함가] (라이브 siz SIZ_000426 실코드, 완제품비.06)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2067 comp_price_id=4759
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4759, 'COMP_POSTER_MINI_STANDBOARD', '2026-06-01', 'SIZ_000258', NULL, NULL, NULL, NULL, 19, 4300, '미니스탠딩보드 A4 수량≥19 완제품가[출력+코팅+가공(보드접착+거치대) 포함가] (라이브 siz SIZ_000258 실코드, 완제품비.06)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2068 comp_price_id=4760
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4760, 'COMP_POSTER_MINI_STANDBOARD', '2026-06-01', 'SIZ_000315', NULL, NULL, NULL, NULL, 19, 6200, '미니스탠딩보드 A3 수량≥19 완제품가[출력+코팅+가공(보드접착+거치대) 포함가] (라이브 siz SIZ_000315 실코드, 완제품비.06)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2069 comp_price_id=4761
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4761, 'COMP_POSTER_MINI_STANDBOARD', '2026-06-01', 'SIZ_000426', NULL, NULL, NULL, NULL, 49, 3300, '미니스탠딩보드 A5 수량≥49 완제품가[출력+코팅+가공(보드접착+거치대) 포함가] (라이브 siz SIZ_000426 실코드, 완제품비.06)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2070 comp_price_id=4762
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4762, 'COMP_POSTER_MINI_STANDBOARD', '2026-06-01', 'SIZ_000258', NULL, NULL, NULL, NULL, 49, 4200, '미니스탠딩보드 A4 수량≥49 완제품가[출력+코팅+가공(보드접착+거치대) 포함가] (라이브 siz SIZ_000258 실코드, 완제품비.06)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2071 comp_price_id=4763
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4763, 'COMP_POSTER_MINI_STANDBOARD', '2026-06-01', 'SIZ_000315', NULL, NULL, NULL, NULL, 49, 6100, '미니스탠딩보드 A3 수량≥49 완제품가[출력+코팅+가공(보드접착+거치대) 포함가] (라이브 siz SIZ_000315 실코드, 완제품비.06)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2072 comp_price_id=4764
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4764, 'COMP_POSTER_MINI_STANDBOARD', '2026-06-01', 'SIZ_000426', NULL, NULL, NULL, NULL, 99, 3100, '미니스탠딩보드 A5 수량≥99 완제품가[출력+코팅+가공(보드접착+거치대) 포함가] (라이브 siz SIZ_000426 실코드, 완제품비.06)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2073 comp_price_id=4765
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4765, 'COMP_POSTER_MINI_STANDBOARD', '2026-06-01', 'SIZ_000258', NULL, NULL, NULL, NULL, 99, 4000, '미니스탠딩보드 A4 수량≥99 완제품가[출력+코팅+가공(보드접착+거치대) 포함가] (라이브 siz SIZ_000258 실코드, 완제품비.06)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2074 comp_price_id=4766
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4766, 'COMP_POSTER_MINI_STANDBOARD', '2026-06-01', 'SIZ_000315', NULL, NULL, NULL, NULL, 99, 5900, '미니스탠딩보드 A3 수량≥99 완제품가[출력+코팅+가공(보드접착+거치대) 포함가] (라이브 siz SIZ_000315 실코드, 완제품비.06)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2075 comp_price_id=4767
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4767, 'COMP_POSTER_MINI_STANDBOARD', '2026-06-01', 'SIZ_000426', NULL, NULL, NULL, NULL, 10000, 2900, '미니스탠딩보드 A5 수량≥10000 완제품가[출력+코팅+가공(보드접착+거치대) 포함가] (라이브 siz SIZ_000426 실코드, 완제품비.06)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2076 comp_price_id=4768
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4768, 'COMP_POSTER_MINI_STANDBOARD', '2026-06-01', 'SIZ_000258', NULL, NULL, NULL, NULL, 10000, 3800, '미니스탠딩보드 A4 수량≥10000 완제품가[출력+코팅+가공(보드접착+거치대) 포함가] (라이브 siz SIZ_000258 실코드, 완제품비.06)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2077 comp_price_id=4769
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4769, 'COMP_POSTER_MINI_STANDBOARD', '2026-06-01', 'SIZ_000315', NULL, NULL, NULL, NULL, 10000, 5500, '미니스탠딩보드 A3 수량≥10000 완제품가[출력+코팅+가공(보드접착+거치대) 포함가] (라이브 siz SIZ_000315 실코드, 완제품비.06)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2078 comp_price_id=4770
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4770, 'COMP_POSTER_MINI_BANNER', '2026-06-01', 'SIZ_000028', NULL, NULL, NULL, NULL, 4, 6500, '미니배너 150x300 mm 수량≥4 완제품가[출력+코팅+거치대 포함가] (라이브 siz SIZ_000028 실코드, 완제품비.06)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2079 comp_price_id=4771
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4771, 'COMP_POSTER_MINI_BANNER', '2026-06-01', 'SIZ_000328', NULL, NULL, NULL, NULL, 4, 6500, '미니배너 180x420 mm 수량≥4 완제품가[출력+코팅+거치대 포함가] (라이브 siz SIZ_000328 실코드, 완제품비.06)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2080 comp_price_id=4772
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4772, 'COMP_POSTER_MINI_BANNER', '2026-06-01', 'SIZ_000028', NULL, NULL, NULL, NULL, 19, 4900, '미니배너 150x300 mm 수량≥19 완제품가[출력+코팅+거치대 포함가] (라이브 siz SIZ_000028 실코드, 완제품비.06)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2081 comp_price_id=4773
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4773, 'COMP_POSTER_MINI_BANNER', '2026-06-01', 'SIZ_000328', NULL, NULL, NULL, NULL, 19, 4900, '미니배너 180x420 mm 수량≥19 완제품가[출력+코팅+거치대 포함가] (라이브 siz SIZ_000328 실코드, 완제품비.06)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2082 comp_price_id=4774
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4774, 'COMP_POSTER_MINI_BANNER', '2026-06-01', 'SIZ_000028', NULL, NULL, NULL, NULL, 49, 4200, '미니배너 150x300 mm 수량≥49 완제품가[출력+코팅+거치대 포함가] (라이브 siz SIZ_000028 실코드, 완제품비.06)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2083 comp_price_id=4775
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4775, 'COMP_POSTER_MINI_BANNER', '2026-06-01', 'SIZ_000328', NULL, NULL, NULL, NULL, 49, 4200, '미니배너 180x420 mm 수량≥49 완제품가[출력+코팅+거치대 포함가] (라이브 siz SIZ_000328 실코드, 완제품비.06)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2084 comp_price_id=4776
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4776, 'COMP_POSTER_MINI_BANNER', '2026-06-01', 'SIZ_000028', NULL, NULL, NULL, NULL, 99, 3500, '미니배너 150x300 mm 수량≥99 완제품가[출력+코팅+거치대 포함가] (라이브 siz SIZ_000028 실코드, 완제품비.06)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2085 comp_price_id=4777
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4777, 'COMP_POSTER_MINI_BANNER', '2026-06-01', 'SIZ_000328', NULL, NULL, NULL, NULL, 99, 3500, '미니배너 180x420 mm 수량≥99 완제품가[출력+코팅+거치대 포함가] (라이브 siz SIZ_000328 실코드, 완제품비.06)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2086 comp_price_id=4778
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4778, 'COMP_POSTER_MINI_BANNER', '2026-06-01', 'SIZ_000028', NULL, NULL, NULL, NULL, 10000, 2800, '미니배너 150x300 mm 수량≥10000 완제품가[출력+코팅+거치대 포함가] (라이브 siz SIZ_000028 실코드, 완제품비.06)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2087 comp_price_id=4779
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4779, 'COMP_POSTER_MINI_BANNER', '2026-06-01', 'SIZ_000328', NULL, NULL, NULL, NULL, 10000, 2800, '미니배너 180x420 mm 수량≥10000 완제품가[출력+코팅+거치대 포함가] (라이브 siz SIZ_000328 실코드, 완제품비.06)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2088 comp_price_id=4780
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4780, 'COMP_POSTER_FOAMBOARD_WHITE', '2026-06-01', 'SIZ_000315', NULL, NULL, NULL, NULL, NULL, 7000, '폼보드/화이트보드/A3 완제품가[출력+코팅+가공 포함가] (중첩서브제품 추출결함보정, 라이브 siz SIZ_000315 실코드, 완제품비.06, PRD_000129)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2089 comp_price_id=4781
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4781, 'COMP_POSTER_FOAMBOARD_WHITE', '2026-06-01', 'SIZ_000317', NULL, NULL, NULL, NULL, NULL, 12000, '폼보드/화이트보드/A2 완제품가[출력+코팅+가공 포함가] (중첩서브제품 추출결함보정, 라이브 siz SIZ_000317 실코드, 완제품비.06, PRD_000129)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2090 comp_price_id=4783
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4783, 'COMP_POSTER_FOAMBOARD_BLACK', '2026-06-01', 'SIZ_000315', NULL, NULL, NULL, NULL, NULL, 8500, '폼보드/블랙보드/A3 완제품가[출력+코팅+가공 포함가] (중첩서브제품 추출결함보정, 라이브 siz SIZ_000315 실코드, 완제품비.06, PRD_000129)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2091 comp_price_id=4784
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4784, 'COMP_POSTER_FOAMBOARD_BLACK', '2026-06-01', 'SIZ_000317', NULL, NULL, NULL, NULL, NULL, 14000, '폼보드/블랙보드/A2 완제품가[출력+코팅+가공 포함가] (중첩서브제품 추출결함보정, 라이브 siz SIZ_000317 실코드, 완제품비.06, PRD_000129)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2092 comp_price_id=4786
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4786, 'COMP_POSTER_FOMEXBOARD_WHITE3MM', '2026-06-01', 'SIZ_000315', NULL, NULL, NULL, NULL, NULL, 8500, '포맥스보드/화이트포맥스(3mm)/A3 완제품가[출력+코팅+가공 포함가] (중첩서브제품 추출결함보정, 라이브 siz SIZ_000315 실코드, 완제품비.06, PRD_000130)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2093 comp_price_id=4787
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4787, 'COMP_POSTER_FOMEXBOARD_WHITE3MM', '2026-06-01', 'SIZ_000317', NULL, NULL, NULL, NULL, NULL, 13000, '포맥스보드/화이트포맥스(3mm)/A2 완제품가[출력+코팅+가공 포함가] (중첩서브제품 추출결함보정, 라이브 siz SIZ_000317 실코드, 완제품비.06, PRD_000130)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2094 comp_price_id=4789
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4789, 'COMP_POSTER_FOMEXBOARD_WHITE5MM', '2026-06-01', 'SIZ_000315', NULL, NULL, NULL, NULL, NULL, 10000, '포맥스보드/화이트포맥스(5mm)/A3 완제품가[출력+코팅+가공 포함가] (중첩서브제품 추출결함보정, 라이브 siz SIZ_000315 실코드, 완제품비.06, PRD_000130)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2095 comp_price_id=4790
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4790, 'COMP_POSTER_FOMEXBOARD_WHITE5MM', '2026-06-01', 'SIZ_000317', NULL, NULL, NULL, NULL, NULL, 16000, '포맥스보드/화이트포맥스(5mm)/A2 완제품가[출력+코팅+가공 포함가] (중첩서브제품 추출결함보정, 라이브 siz SIZ_000317 실코드, 완제품비.06, PRD_000130)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2096 comp_price_id=4792
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4792, 'COMP_POSTER_ACRYLSTK_GLOSS', '2026-06-01', 'SIZ_000324', NULL, NULL, NULL, NULL, NULL, 9000, '아크릴스티커(유광/미러)/유광 (화이트 / 블랙)/290 x 90 mm 완제품가[유광/미러] (중첩서브제품 추출결함보정, 라이브 siz SIZ_000324 실코드, 완제품비.06, PRD_000142,PRD_000143)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2097 comp_price_id=4793
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4793, 'COMP_POSTER_ACRYLSTK_GLOSS', '2026-06-01', 'SIZ_000325', NULL, NULL, NULL, NULL, NULL, 14000, '아크릴스티커(유광/미러)/유광 (화이트 / 블랙)/290 x 190 mm 완제품가[유광/미러] (중첩서브제품 추출결함보정, 라이브 siz SIZ_000325 실코드, 완제품비.06, PRD_000142,PRD_000143)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2098 comp_price_id=4794
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4794, 'COMP_POSTER_ACRYLSTK_GLOSS', '2026-06-01', 'SIZ_000326', NULL, NULL, NULL, NULL, NULL, 32000, '아크릴스티커(유광/미러)/유광 (화이트 / 블랙)/390 x 290 mm 완제품가[유광/미러] (중첩서브제품 추출결함보정, 라이브 siz SIZ_000326 실코드, 완제품비.06, PRD_000142,PRD_000143)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2099 comp_price_id=4795
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4795, 'COMP_POSTER_ACRYLSTK_GLOSS', '2026-06-01', 'SIZ_000327', NULL, NULL, NULL, NULL, NULL, 37000, '아크릴스티커(유광/미러)/유광 (화이트 / 블랙)/590 x 390 mm 완제품가[유광/미러] (중첩서브제품 추출결함보정, 라이브 siz SIZ_000327 실코드, 완제품비.06, PRD_000142,PRD_000143)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2100 comp_price_id=4796
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4796, 'COMP_POSTER_ACRYLSTK_MIRROR', '2026-06-01', 'SIZ_000324', NULL, NULL, NULL, NULL, NULL, 11000, '아크릴스티커(유광/미러)/미러 (골드/실버)/290 x 90 mm 완제품가[유광/미러] (중첩서브제품 추출결함보정, 라이브 siz SIZ_000324 실코드, 완제품비.06, PRD_000142,PRD_000143)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2101 comp_price_id=4797
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4797, 'COMP_POSTER_ACRYLSTK_MIRROR', '2026-06-01', 'SIZ_000325', NULL, NULL, NULL, NULL, NULL, 18000, '아크릴스티커(유광/미러)/미러 (골드/실버)/290 x 190 mm 완제품가[유광/미러] (중첩서브제품 추출결함보정, 라이브 siz SIZ_000325 실코드, 완제품비.06, PRD_000142,PRD_000143)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2102 comp_price_id=4798
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4798, 'COMP_POSTER_ACRYLSTK_MIRROR', '2026-06-01', 'SIZ_000326', NULL, NULL, NULL, NULL, NULL, 29000, '아크릴스티커(유광/미러)/미러 (골드/실버)/390 x 290 mm 완제품가[유광/미러] (중첩서브제품 추출결함보정, 라이브 siz SIZ_000326 실코드, 완제품비.06, PRD_000142,PRD_000143)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2103 comp_price_id=4799
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4799, 'COMP_POSTER_ACRYLSTK_MIRROR', '2026-06-01', 'SIZ_000327', NULL, NULL, NULL, NULL, NULL, 50000, '아크릴스티커(유광/미러)/미러 (골드/실버)/590 x 390 mm 완제품가[유광/미러] (중첩서브제품 추출결함보정, 라이브 siz SIZ_000327 실코드, 완제품비.06, PRD_000142,PRD_000143)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2104 comp_price_id=4800
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4800, 'COMP_POSTER_SHEETCUT_MATTE', '2026-06-01', 'SIZ_000258', NULL, NULL, NULL, NULL, NULL, 6000, '시트커팅(무광/홀로그램)/무광(화이트/블랙)/A4 완제품가[시트커팅] (중첩서브제품 추출결함보정, 라이브 siz SIZ_000258 실코드, 완제품비.06, PRD_000140,PRD_000141)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2105 comp_price_id=4801
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4801, 'COMP_POSTER_SHEETCUT_MATTE', '2026-06-01', 'SIZ_000315', NULL, NULL, NULL, NULL, NULL, 11000, '시트커팅(무광/홀로그램)/무광(화이트/블랙)/A3 완제품가[시트커팅] (중첩서브제품 추출결함보정, 라이브 siz SIZ_000315 실코드, 완제품비.06, PRD_000140,PRD_000141)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2106 comp_price_id=4802
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4802, 'COMP_POSTER_SHEETCUT_MATTE', '2026-06-01', 'SIZ_000317', NULL, NULL, NULL, NULL, NULL, 32000, '시트커팅(무광/홀로그램)/무광(화이트/블랙)/A2 완제품가[시트커팅] (중첩서브제품 추출결함보정, 라이브 siz SIZ_000317 실코드, 완제품비.06, PRD_000140,PRD_000141)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2107 comp_price_id=4803
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4803, 'COMP_POSTER_SHEETCUT_HOLO', '2026-06-01', 'SIZ_000258', NULL, NULL, NULL, NULL, NULL, 8000, '시트커팅(무광/홀로그램)/홀로그램/A4 완제품가[시트커팅] (중첩서브제품 추출결함보정, 라이브 siz SIZ_000258 실코드, 완제품비.06, PRD_000140,PRD_000141)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2108 comp_price_id=4804
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4804, 'COMP_POSTER_SHEETCUT_HOLO', '2026-06-01', 'SIZ_000315', NULL, NULL, NULL, NULL, NULL, 16000, '시트커팅(무광/홀로그램)/홀로그램/A3 완제품가[시트커팅] (중첩서브제품 추출결함보정, 라이브 siz SIZ_000315 실코드, 완제품비.06, PRD_000140,PRD_000141)')
ON CONFLICT (comp_price_id) DO NOTHING;
-- src: 04_prc_component_prices.csv:row2109 comp_price_id=4805
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
VALUES (4805, 'COMP_POSTER_SHEETCUT_HOLO', '2026-06-01', 'SIZ_000317', NULL, NULL, NULL, NULL, NULL, 32000, '시트커팅(무광/홀로그램)/홀로그램/A2 완제품가[시트커팅] (중첩서브제품 추출결함보정, 라이브 siz SIZ_000317 실코드, 완제품비.06, PRD_000140,PRD_000141)')
ON CONFLICT (comp_price_id) DO NOTHING;
