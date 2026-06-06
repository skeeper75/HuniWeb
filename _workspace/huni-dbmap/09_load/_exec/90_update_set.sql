-- 90_update_set.sql
-- 단계90 update-set(실행가능 3종) — qtyunit 244·nonspec 25·thickness 20. 멱등 UPDATE(IS DISTINCT FROM/PK 키변경 무매치). INSERT 단계 이후 적용.
-- 생성: gen_load_sql.py (손편집 금지). BEGIN/COMMIT 미포함 — apply.sql 가 래핑.

-- src: qtyunit_update.csv:row2 PRD_000016→QTY_UNIT.02
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.02', upd_dt = now()
WHERE prd_cd = 'PRD_000016' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.02';
-- src: qtyunit_update.csv:row3 PRD_000017→QTY_UNIT.02
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.02', upd_dt = now()
WHERE prd_cd = 'PRD_000017' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.02';
-- src: qtyunit_update.csv:row4 PRD_000018→QTY_UNIT.02
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.02', upd_dt = now()
WHERE prd_cd = 'PRD_000018' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.02';
-- src: qtyunit_update.csv:row5 PRD_000019→QTY_UNIT.02
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.02', upd_dt = now()
WHERE prd_cd = 'PRD_000019' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.02';
-- src: qtyunit_update.csv:row6 PRD_000020→QTY_UNIT.02
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.02', upd_dt = now()
WHERE prd_cd = 'PRD_000020' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.02';
-- src: qtyunit_update.csv:row7 PRD_000021→QTY_UNIT.02
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.02', upd_dt = now()
WHERE prd_cd = 'PRD_000021' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.02';
-- src: qtyunit_update.csv:row8 PRD_000022→QTY_UNIT.02
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.02', upd_dt = now()
WHERE prd_cd = 'PRD_000022' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.02';
-- src: qtyunit_update.csv:row9 PRD_000023→QTY_UNIT.02
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.02', upd_dt = now()
WHERE prd_cd = 'PRD_000023' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.02';
-- src: qtyunit_update.csv:row10 PRD_000024→QTY_UNIT.02
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.02', upd_dt = now()
WHERE prd_cd = 'PRD_000024' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.02';
-- src: qtyunit_update.csv:row11 PRD_000025→QTY_UNIT.02
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.02', upd_dt = now()
WHERE prd_cd = 'PRD_000025' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.02';
-- src: qtyunit_update.csv:row12 PRD_000026→QTY_UNIT.02
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.02', upd_dt = now()
WHERE prd_cd = 'PRD_000026' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.02';
-- src: qtyunit_update.csv:row13 PRD_000027→QTY_UNIT.02
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.02', upd_dt = now()
WHERE prd_cd = 'PRD_000027' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.02';
-- src: qtyunit_update.csv:row14 PRD_000028→QTY_UNIT.02
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.02', upd_dt = now()
WHERE prd_cd = 'PRD_000028' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.02';
-- src: qtyunit_update.csv:row15 PRD_000029→QTY_UNIT.02
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.02', upd_dt = now()
WHERE prd_cd = 'PRD_000029' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.02';
-- src: qtyunit_update.csv:row16 PRD_000030→QTY_UNIT.02
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.02', upd_dt = now()
WHERE prd_cd = 'PRD_000030' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.02';
-- src: qtyunit_update.csv:row17 PRD_000031→QTY_UNIT.02
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.02', upd_dt = now()
WHERE prd_cd = 'PRD_000031' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.02';
-- src: qtyunit_update.csv:row18 PRD_000032→QTY_UNIT.02
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.02', upd_dt = now()
WHERE prd_cd = 'PRD_000032' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.02';
-- src: qtyunit_update.csv:row19 PRD_000033→QTY_UNIT.02
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.02', upd_dt = now()
WHERE prd_cd = 'PRD_000033' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.02';
-- src: qtyunit_update.csv:row20 PRD_000034→QTY_UNIT.02
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.02', upd_dt = now()
WHERE prd_cd = 'PRD_000034' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.02';
-- src: qtyunit_update.csv:row21 PRD_000035→QTY_UNIT.02
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.02', upd_dt = now()
WHERE prd_cd = 'PRD_000035' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.02';
-- src: qtyunit_update.csv:row22 PRD_000036→QTY_UNIT.02
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.02', upd_dt = now()
WHERE prd_cd = 'PRD_000036' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.02';
-- src: qtyunit_update.csv:row23 PRD_000037→QTY_UNIT.02
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.02', upd_dt = now()
WHERE prd_cd = 'PRD_000037' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.02';
-- src: qtyunit_update.csv:row24 PRD_000038→QTY_UNIT.02
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.02', upd_dt = now()
WHERE prd_cd = 'PRD_000038' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.02';
-- src: qtyunit_update.csv:row25 PRD_000039→QTY_UNIT.02
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.02', upd_dt = now()
WHERE prd_cd = 'PRD_000039' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.02';
-- src: qtyunit_update.csv:row26 PRD_000040→QTY_UNIT.02
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.02', upd_dt = now()
WHERE prd_cd = 'PRD_000040' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.02';
-- src: qtyunit_update.csv:row27 PRD_000041→QTY_UNIT.02
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.02', upd_dt = now()
WHERE prd_cd = 'PRD_000041' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.02';
-- src: qtyunit_update.csv:row28 PRD_000042→QTY_UNIT.02
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.02', upd_dt = now()
WHERE prd_cd = 'PRD_000042' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.02';
-- src: qtyunit_update.csv:row29 PRD_000043→QTY_UNIT.02
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.02', upd_dt = now()
WHERE prd_cd = 'PRD_000043' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.02';
-- src: qtyunit_update.csv:row30 PRD_000044→QTY_UNIT.02
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.02', upd_dt = now()
WHERE prd_cd = 'PRD_000044' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.02';
-- src: qtyunit_update.csv:row31 PRD_000045→QTY_UNIT.02
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.02', upd_dt = now()
WHERE prd_cd = 'PRD_000045' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.02';
-- src: qtyunit_update.csv:row32 PRD_000046→QTY_UNIT.02
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.02', upd_dt = now()
WHERE prd_cd = 'PRD_000046' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.02';
-- src: qtyunit_update.csv:row33 PRD_000047→QTY_UNIT.02
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.02', upd_dt = now()
WHERE prd_cd = 'PRD_000047' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.02';
-- src: qtyunit_update.csv:row34 PRD_000048→QTY_UNIT.02
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.02', upd_dt = now()
WHERE prd_cd = 'PRD_000048' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.02';
-- src: qtyunit_update.csv:row35 PRD_000049→QTY_UNIT.02
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.02', upd_dt = now()
WHERE prd_cd = 'PRD_000049' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.02';
-- src: qtyunit_update.csv:row36 PRD_000050→QTY_UNIT.02
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.02', upd_dt = now()
WHERE prd_cd = 'PRD_000050' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.02';
-- src: qtyunit_update.csv:row37 PRD_000051→QTY_UNIT.02
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.02', upd_dt = now()
WHERE prd_cd = 'PRD_000051' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.02';
-- src: qtyunit_update.csv:row38 PRD_000068→QTY_UNIT.03
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.03', upd_dt = now()
WHERE prd_cd = 'PRD_000068' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.03';
-- src: qtyunit_update.csv:row39 PRD_000069→QTY_UNIT.03
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.03', upd_dt = now()
WHERE prd_cd = 'PRD_000069' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.03';
-- src: qtyunit_update.csv:row40 PRD_000070→QTY_UNIT.03
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.03', upd_dt = now()
WHERE prd_cd = 'PRD_000070' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.03';
-- src: qtyunit_update.csv:row41 PRD_000071→QTY_UNIT.03
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.03', upd_dt = now()
WHERE prd_cd = 'PRD_000071' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.03';
-- src: qtyunit_update.csv:row42 PRD_000072→QTY_UNIT.03
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.03', upd_dt = now()
WHERE prd_cd = 'PRD_000072' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.03';
-- src: qtyunit_update.csv:row43 PRD_000077→QTY_UNIT.03
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.03', upd_dt = now()
WHERE prd_cd = 'PRD_000077' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.03';
-- src: qtyunit_update.csv:row44 PRD_000082→QTY_UNIT.03
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.03', upd_dt = now()
WHERE prd_cd = 'PRD_000082' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.03';
-- src: qtyunit_update.csv:row45 PRD_000088→QTY_UNIT.03
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.03', upd_dt = now()
WHERE prd_cd = 'PRD_000088' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.03';
-- src: qtyunit_update.csv:row46 PRD_000094→QTY_UNIT.03
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.03', upd_dt = now()
WHERE prd_cd = 'PRD_000094' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.03';
-- src: qtyunit_update.csv:row47 PRD_000097→QTY_UNIT.03
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.03', upd_dt = now()
WHERE prd_cd = 'PRD_000097' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.03';
-- src: qtyunit_update.csv:row48 PRD_000100→QTY_UNIT.03
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.03', upd_dt = now()
WHERE prd_cd = 'PRD_000100' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.03';
-- src: qtyunit_update.csv:row49 PRD_000172→QTY_UNIT.03
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.03', upd_dt = now()
WHERE prd_cd = 'PRD_000172' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.03';
-- src: qtyunit_update.csv:row50 PRD_000173→QTY_UNIT.03
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.03', upd_dt = now()
WHERE prd_cd = 'PRD_000173' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.03';
-- src: qtyunit_update.csv:row51 PRD_000174→QTY_UNIT.03
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.03', upd_dt = now()
WHERE prd_cd = 'PRD_000174' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.03';
-- src: qtyunit_update.csv:row52 PRD_000175→QTY_UNIT.03
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.03', upd_dt = now()
WHERE prd_cd = 'PRD_000175' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.03';
-- src: qtyunit_update.csv:row53 PRD_000176→QTY_UNIT.03
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.03', upd_dt = now()
WHERE prd_cd = 'PRD_000176' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.03';
-- src: qtyunit_update.csv:row54 PRD_000177→QTY_UNIT.03
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.03', upd_dt = now()
WHERE prd_cd = 'PRD_000177' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.03';
-- src: qtyunit_update.csv:row55 PRD_000178→QTY_UNIT.03
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.03', upd_dt = now()
WHERE prd_cd = 'PRD_000178' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.03';
-- src: qtyunit_update.csv:row56 PRD_000179→QTY_UNIT.03
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.03', upd_dt = now()
WHERE prd_cd = 'PRD_000179' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.03';
-- src: qtyunit_update.csv:row57 PRD_000180→QTY_UNIT.03
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.03', upd_dt = now()
WHERE prd_cd = 'PRD_000180' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.03';
-- src: qtyunit_update.csv:row58 PRD_000181→QTY_UNIT.03
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.03', upd_dt = now()
WHERE prd_cd = 'PRD_000181' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.03';
-- src: qtyunit_update.csv:row59 PRD_000097→QTY_UNIT.03
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.03', upd_dt = now()
WHERE prd_cd = 'PRD_000097' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.03';
-- src: qtyunit_update.csv:row60 PRD_000052→QTY_UNIT.02
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.02', upd_dt = now()
WHERE prd_cd = 'PRD_000052' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.02';
-- src: qtyunit_update.csv:row61 PRD_000053→QTY_UNIT.02
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.02', upd_dt = now()
WHERE prd_cd = 'PRD_000053' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.02';
-- src: qtyunit_update.csv:row62 PRD_000054→QTY_UNIT.02
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.02', upd_dt = now()
WHERE prd_cd = 'PRD_000054' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.02';
-- src: qtyunit_update.csv:row63 PRD_000055→QTY_UNIT.02
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.02', upd_dt = now()
WHERE prd_cd = 'PRD_000055' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.02';
-- src: qtyunit_update.csv:row64 PRD_000056→QTY_UNIT.02
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.02', upd_dt = now()
WHERE prd_cd = 'PRD_000056' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.02';
-- src: qtyunit_update.csv:row65 PRD_000057→QTY_UNIT.02
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.02', upd_dt = now()
WHERE prd_cd = 'PRD_000057' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.02';
-- src: qtyunit_update.csv:row66 PRD_000058→QTY_UNIT.02
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.02', upd_dt = now()
WHERE prd_cd = 'PRD_000058' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.02';
-- src: qtyunit_update.csv:row67 PRD_000059→QTY_UNIT.02
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.02', upd_dt = now()
WHERE prd_cd = 'PRD_000059' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.02';
-- src: qtyunit_update.csv:row68 PRD_000060→QTY_UNIT.02
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.02', upd_dt = now()
WHERE prd_cd = 'PRD_000060' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.02';
-- src: qtyunit_update.csv:row69 PRD_000061→QTY_UNIT.02
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.02', upd_dt = now()
WHERE prd_cd = 'PRD_000061' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.02';
-- src: qtyunit_update.csv:row70 PRD_000062→QTY_UNIT.02
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.02', upd_dt = now()
WHERE prd_cd = 'PRD_000062' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.02';
-- src: qtyunit_update.csv:row71 PRD_000063→QTY_UNIT.02
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.02', upd_dt = now()
WHERE prd_cd = 'PRD_000063' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.02';
-- src: qtyunit_update.csv:row72 PRD_000064→QTY_UNIT.02
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.02', upd_dt = now()
WHERE prd_cd = 'PRD_000064' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.02';
-- src: qtyunit_update.csv:row73 PRD_000065→QTY_UNIT.02
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.02', upd_dt = now()
WHERE prd_cd = 'PRD_000065' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.02';
-- src: qtyunit_update.csv:row74 PRD_000066→QTY_UNIT.02
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.02', upd_dt = now()
WHERE prd_cd = 'PRD_000066' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.02';
-- src: qtyunit_update.csv:row75 PRD_000067→QTY_UNIT.02
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.02', upd_dt = now()
WHERE prd_cd = 'PRD_000067' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.02';
-- src: qtyunit_update.csv:row76 PRD_000108→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000108' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row77 PRD_000109→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000109' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row78 PRD_000110→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000110' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row79 PRD_000111→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000111' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row80 PRD_000112→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000112' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row81 PRD_000146→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000146' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row82 PRD_000147→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000147' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row83 PRD_000148→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000148' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row84 PRD_000149→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000149' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row85 PRD_000150→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000150' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row86 PRD_000151→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000151' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row87 PRD_000152→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000152' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row88 PRD_000153→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000153' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row89 PRD_000154→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000154' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row90 PRD_000155→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000155' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row91 PRD_000156→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000156' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row92 PRD_000157→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000157' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row93 PRD_000158→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000158' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row94 PRD_000159→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000159' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row95 PRD_000160→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000160' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row96 PRD_000161→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000161' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row97 PRD_000162→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000162' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row98 PRD_000163→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000163' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row99 PRD_000164→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000164' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row100 PRD_000165→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000165' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row101 PRD_000166→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000166' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row102 PRD_000168→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000168' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row103 PRD_000169→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000169' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row104 PRD_000118→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000118' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row105 PRD_000119→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000119' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row106 PRD_000120→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000120' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row107 PRD_000121→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000121' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row108 PRD_000122→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000122' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row109 PRD_000123→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000123' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row110 PRD_000124→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000124' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row111 PRD_000125→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000125' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row112 PRD_000126→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000126' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row113 PRD_000127→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000127' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row114 PRD_000128→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000128' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row115 PRD_000129→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000129' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row116 PRD_000130→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000130' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row117 PRD_000131→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000131' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row118 PRD_000132→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000132' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row119 PRD_000133→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000133' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row120 PRD_000134→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000134' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row121 PRD_000135→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000135' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row122 PRD_000136→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000136' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row123 PRD_000137→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000137' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row124 PRD_000138→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000138' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row125 PRD_000139→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000139' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row126 PRD_000140→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000140' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row127 PRD_000141→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000141' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row128 PRD_000142→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000142' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row129 PRD_000143→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000143' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row130 PRD_000144→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000144' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row131 PRD_000145→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000145' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row132 PRD_000100→QTY_UNIT.03
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.03', upd_dt = now()
WHERE prd_cd = 'PRD_000100' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.03';
-- src: qtyunit_update.csv:row133 PRD_000001→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000001' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row134 PRD_000002→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000002' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row135 PRD_000003→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000003' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row136 PRD_000004→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000004' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row137 PRD_000005→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000005' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row138 PRD_000006→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000006' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row139 PRD_000007→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000007' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row140 PRD_000008→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000008' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row141 PRD_000009→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000009' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row142 PRD_000010→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000010' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row143 PRD_000011→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000011' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row144 PRD_000012→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000012' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row145 PRD_000013→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000013' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row146 PRD_000014→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000014' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row147 PRD_000015→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000015' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row148 PRD_000183→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000183' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row149 PRD_000184→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000184' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row150 PRD_000185→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000185' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row151 PRD_000186→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000186' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row152 PRD_000187→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000187' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row153 PRD_000188→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000188' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row154 PRD_000189→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000189' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row155 PRD_000190→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000190' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row156 PRD_000191→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000191' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row157 PRD_000192→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000192' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row158 PRD_000193→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000193' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row159 PRD_000194→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000194' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row160 PRD_000195→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000195' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row161 PRD_000196→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000196' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row162 PRD_000197→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000197' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row163 PRD_000198→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000198' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row164 PRD_000199→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000199' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row165 PRD_000200→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000200' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row166 PRD_000201→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000201' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row167 PRD_000202→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000202' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row168 PRD_000203→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000203' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row169 PRD_000204→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000204' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row170 PRD_000205→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000205' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row171 PRD_000206→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000206' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row172 PRD_000207→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000207' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row173 PRD_000208→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000208' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row174 PRD_000209→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000209' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row175 PRD_000210→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000210' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row176 PRD_000211→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000211' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row177 PRD_000212→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000212' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row178 PRD_000213→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000213' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row179 PRD_000214→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000214' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row180 PRD_000215→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000215' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row181 PRD_000216→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000216' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row182 PRD_000217→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000217' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row183 PRD_000218→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000218' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row184 PRD_000219→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000219' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row185 PRD_000220→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000220' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row186 PRD_000221→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000221' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row187 PRD_000222→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000222' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row188 PRD_000223→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000223' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row189 PRD_000224→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000224' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row190 PRD_000225→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000225' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row191 PRD_000226→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000226' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row192 PRD_000227→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000227' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row193 PRD_000228→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000228' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row194 PRD_000229→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000229' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row195 PRD_000230→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000230' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row196 PRD_000231→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000231' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row197 PRD_000232→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000232' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row198 PRD_000233→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000233' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row199 PRD_000234→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000234' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row200 PRD_000235→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000235' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row201 PRD_000236→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000236' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row202 PRD_000237→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000237' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row203 PRD_000238→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000238' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row204 PRD_000239→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000239' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row205 PRD_000240→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000240' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row206 PRD_000241→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000241' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row207 PRD_000242→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000242' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row208 PRD_000243→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000243' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row209 PRD_000244→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000244' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row210 PRD_000245→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000245' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row211 PRD_000246→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000246' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row212 PRD_000247→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000247' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row213 PRD_000248→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000248' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row214 PRD_000249→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000249' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row215 PRD_000250→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000250' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row216 PRD_000251→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000251' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row217 PRD_000252→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000252' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row218 PRD_000253→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000253' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row219 PRD_000254→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000254' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row220 PRD_000255→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000255' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row221 PRD_000256→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000256' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row222 PRD_000257→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000257' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row223 PRD_000258→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000258' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row224 PRD_000259→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000259' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row225 PRD_000260→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000260' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row226 PRD_000261→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000261' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row227 PRD_000262→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000262' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row228 PRD_000263→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000263' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row229 PRD_000264→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000264' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row230 PRD_000265→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000265' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row231 PRD_000266→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000266' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row232 PRD_000267→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000267' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row233 PRD_000268→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000268' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row234 PRD_000269→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000269' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row235 PRD_000270→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000270' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row236 PRD_000271→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000271' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row237 PRD_000272→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000272' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row238 PRD_000273→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000273' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row239 PRD_000274→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000274' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row240 PRD_000275→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000275' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row241 PRD_000276→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000276' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row242 PRD_000277→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000277' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row243 PRD_000278→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000278' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row244 PRD_000279→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000279' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: qtyunit_update.csv:row245 PRD_000280→QTY_UNIT.01
UPDATE t_prd_products SET qty_unit_typ_cd = 'QTY_UNIT.01', upd_dt = now()
WHERE prd_cd = 'PRD_000280' AND qty_unit_typ_cd IS DISTINCT FROM 'QTY_UNIT.01';
-- src: nonspec_update.csv:row2 PRD_000146→Y
UPDATE t_prd_products SET nonspec_yn = 'Y', nonspec_width_min = 20.00, nonspec_width_max = 100.00, nonspec_height_min = 20.00, nonspec_height_max = 100.00, upd_dt = now()
WHERE prd_cd = 'PRD_000146' AND (nonspec_yn IS DISTINCT FROM 'Y' OR nonspec_width_min IS DISTINCT FROM 20.00 OR nonspec_width_max IS DISTINCT FROM 100.00 OR nonspec_height_min IS DISTINCT FROM 20.00 OR nonspec_height_max IS DISTINCT FROM 100.00);
-- src: nonspec_update.csv:row3 PRD_000147→Y
UPDATE t_prd_products SET nonspec_yn = 'Y', nonspec_width_min = 20.00, nonspec_width_max = 80.00, nonspec_height_min = 20.00, nonspec_height_max = 80.00, upd_dt = now()
WHERE prd_cd = 'PRD_000147' AND (nonspec_yn IS DISTINCT FROM 'Y' OR nonspec_width_min IS DISTINCT FROM 20.00 OR nonspec_width_max IS DISTINCT FROM 80.00 OR nonspec_height_min IS DISTINCT FROM 20.00 OR nonspec_height_max IS DISTINCT FROM 80.00);
-- src: nonspec_update.csv:row4 PRD_000148→Y
UPDATE t_prd_products SET nonspec_yn = 'Y', nonspec_width_min = 30.00, nonspec_width_max = 80.00, nonspec_height_min = 30.00, nonspec_height_max = 80.00, upd_dt = now()
WHERE prd_cd = 'PRD_000148' AND (nonspec_yn IS DISTINCT FROM 'Y' OR nonspec_width_min IS DISTINCT FROM 30.00 OR nonspec_width_max IS DISTINCT FROM 80.00 OR nonspec_height_min IS DISTINCT FROM 30.00 OR nonspec_height_max IS DISTINCT FROM 80.00);
-- src: nonspec_update.csv:row5 PRD_000149→Y
UPDATE t_prd_products SET nonspec_yn = 'Y', nonspec_width_min = 30.00, nonspec_width_max = 60.00, nonspec_height_min = 30.00, nonspec_height_max = 60.00, upd_dt = now()
WHERE prd_cd = 'PRD_000149' AND (nonspec_yn IS DISTINCT FROM 'Y' OR nonspec_width_min IS DISTINCT FROM 30.00 OR nonspec_width_max IS DISTINCT FROM 60.00 OR nonspec_height_min IS DISTINCT FROM 30.00 OR nonspec_height_max IS DISTINCT FROM 60.00);
-- src: nonspec_update.csv:row6 PRD_000150→Y
UPDATE t_prd_products SET nonspec_yn = 'Y', nonspec_width_min = 50.00, nonspec_width_max = 80.00, nonspec_height_min = 50.00, nonspec_height_max = 80.00, upd_dt = now()
WHERE prd_cd = 'PRD_000150' AND (nonspec_yn IS DISTINCT FROM 'Y' OR nonspec_width_min IS DISTINCT FROM 50.00 OR nonspec_width_max IS DISTINCT FROM 80.00 OR nonspec_height_min IS DISTINCT FROM 50.00 OR nonspec_height_max IS DISTINCT FROM 80.00);
-- src: nonspec_update.csv:row7 PRD_000151→Y
UPDATE t_prd_products SET nonspec_yn = 'Y', nonspec_width_min = 50.00, nonspec_width_max = 80.00, nonspec_height_min = 50.00, nonspec_height_max = 80.00, upd_dt = now()
WHERE prd_cd = 'PRD_000151' AND (nonspec_yn IS DISTINCT FROM 'Y' OR nonspec_width_min IS DISTINCT FROM 50.00 OR nonspec_width_max IS DISTINCT FROM 80.00 OR nonspec_height_min IS DISTINCT FROM 50.00 OR nonspec_height_max IS DISTINCT FROM 80.00);
-- src: nonspec_update.csv:row8 PRD_000152→Y
UPDATE t_prd_products SET nonspec_yn = 'Y', nonspec_width_min = 60.00, nonspec_width_max = 80.00, nonspec_height_min = 20.00, nonspec_height_max = 50.00, upd_dt = now()
WHERE prd_cd = 'PRD_000152' AND (nonspec_yn IS DISTINCT FROM 'Y' OR nonspec_width_min IS DISTINCT FROM 60.00 OR nonspec_width_max IS DISTINCT FROM 80.00 OR nonspec_height_min IS DISTINCT FROM 20.00 OR nonspec_height_max IS DISTINCT FROM 50.00);
-- src: nonspec_update.csv:row9 PRD_000153→Y
UPDATE t_prd_products SET nonspec_yn = 'Y', nonspec_width_min = 60.00, nonspec_width_max = 80.00, nonspec_height_min = 20.00, nonspec_height_max = 50.00, upd_dt = now()
WHERE prd_cd = 'PRD_000153' AND (nonspec_yn IS DISTINCT FROM 'Y' OR nonspec_width_min IS DISTINCT FROM 60.00 OR nonspec_width_max IS DISTINCT FROM 80.00 OR nonspec_height_min IS DISTINCT FROM 20.00 OR nonspec_height_max IS DISTINCT FROM 50.00);
-- src: nonspec_update.csv:row10 PRD_000154→Y
UPDATE t_prd_products SET nonspec_yn = 'Y', nonspec_width_min = 20.00, nonspec_width_max = 40.00, nonspec_height_min = 20.00, nonspec_height_max = 40.00, upd_dt = now()
WHERE prd_cd = 'PRD_000154' AND (nonspec_yn IS DISTINCT FROM 'Y' OR nonspec_width_min IS DISTINCT FROM 20.00 OR nonspec_width_max IS DISTINCT FROM 40.00 OR nonspec_height_min IS DISTINCT FROM 20.00 OR nonspec_height_max IS DISTINCT FROM 40.00);
-- src: nonspec_update.csv:row11 PRD_000155→Y
UPDATE t_prd_products SET nonspec_yn = 'Y', nonspec_width_min = 20.00, nonspec_width_max = 40.00, nonspec_height_min = 20.00, nonspec_height_max = 40.00, upd_dt = now()
WHERE prd_cd = 'PRD_000155' AND (nonspec_yn IS DISTINCT FROM 'Y' OR nonspec_width_min IS DISTINCT FROM 20.00 OR nonspec_width_max IS DISTINCT FROM 40.00 OR nonspec_height_min IS DISTINCT FROM 20.00 OR nonspec_height_max IS DISTINCT FROM 40.00);
-- src: nonspec_update.csv:row12 PRD_000156→Y
UPDATE t_prd_products SET nonspec_yn = 'Y', nonspec_width_min = 15.00, nonspec_width_max = 35.00, nonspec_height_min = 15.00, nonspec_height_max = 35.00, upd_dt = now()
WHERE prd_cd = 'PRD_000156' AND (nonspec_yn IS DISTINCT FROM 'Y' OR nonspec_width_min IS DISTINCT FROM 15.00 OR nonspec_width_max IS DISTINCT FROM 35.00 OR nonspec_height_min IS DISTINCT FROM 15.00 OR nonspec_height_max IS DISTINCT FROM 35.00);
-- src: nonspec_update.csv:row13 PRD_000164→Y
UPDATE t_prd_products SET nonspec_yn = 'Y', nonspec_width_min = 30.00, nonspec_width_max = 80.00, nonspec_height_min = 30.00, nonspec_height_max = 80.00, upd_dt = now()
WHERE prd_cd = 'PRD_000164' AND (nonspec_yn IS DISTINCT FROM 'Y' OR nonspec_width_min IS DISTINCT FROM 30.00 OR nonspec_width_max IS DISTINCT FROM 80.00 OR nonspec_height_min IS DISTINCT FROM 30.00 OR nonspec_height_max IS DISTINCT FROM 80.00);
-- src: nonspec_update.csv:row14 PRD_000118→Y
UPDATE t_prd_products SET nonspec_yn = 'Y', nonspec_width_min = 200.00, nonspec_width_max = 1200.00, nonspec_height_min = 200.00, nonspec_height_max = 3000.00, upd_dt = now()
WHERE prd_cd = 'PRD_000118' AND (nonspec_yn IS DISTINCT FROM 'Y' OR nonspec_width_min IS DISTINCT FROM 200.00 OR nonspec_width_max IS DISTINCT FROM 1200.00 OR nonspec_height_min IS DISTINCT FROM 200.00 OR nonspec_height_max IS DISTINCT FROM 3000.00);
-- src: nonspec_update.csv:row15 PRD_000119→Y
UPDATE t_prd_products SET nonspec_yn = 'Y', nonspec_width_min = 200.00, nonspec_width_max = 900.00, nonspec_height_min = 200.00, nonspec_height_max = 3000.00, upd_dt = now()
WHERE prd_cd = 'PRD_000119' AND (nonspec_yn IS DISTINCT FROM 'Y' OR nonspec_width_min IS DISTINCT FROM 200.00 OR nonspec_width_max IS DISTINCT FROM 900.00 OR nonspec_height_min IS DISTINCT FROM 200.00 OR nonspec_height_max IS DISTINCT FROM 3000.00);
-- src: nonspec_update.csv:row16 PRD_000120→Y
UPDATE t_prd_products SET nonspec_yn = 'Y', nonspec_width_min = 200.00, nonspec_width_max = 1200.00, nonspec_height_min = 200.00, nonspec_height_max = 3000.00, upd_dt = now()
WHERE prd_cd = 'PRD_000120' AND (nonspec_yn IS DISTINCT FROM 'Y' OR nonspec_width_min IS DISTINCT FROM 200.00 OR nonspec_width_max IS DISTINCT FROM 1200.00 OR nonspec_height_min IS DISTINCT FROM 200.00 OR nonspec_height_max IS DISTINCT FROM 3000.00);
-- src: nonspec_update.csv:row17 PRD_000121→Y
UPDATE t_prd_products SET nonspec_yn = 'Y', nonspec_width_min = 200.00, nonspec_width_max = 1200.00, nonspec_height_min = 200.00, nonspec_height_max = 3000.00, upd_dt = now()
WHERE prd_cd = 'PRD_000121' AND (nonspec_yn IS DISTINCT FROM 'Y' OR nonspec_width_min IS DISTINCT FROM 200.00 OR nonspec_width_max IS DISTINCT FROM 1200.00 OR nonspec_height_min IS DISTINCT FROM 200.00 OR nonspec_height_max IS DISTINCT FROM 3000.00);
-- src: nonspec_update.csv:row18 PRD_000122→Y
UPDATE t_prd_products SET nonspec_yn = 'Y', nonspec_width_min = 200.00, nonspec_width_max = 1200.00, nonspec_height_min = 200.00, nonspec_height_max = 3000.00, upd_dt = now()
WHERE prd_cd = 'PRD_000122' AND (nonspec_yn IS DISTINCT FROM 'Y' OR nonspec_width_min IS DISTINCT FROM 200.00 OR nonspec_width_max IS DISTINCT FROM 1200.00 OR nonspec_height_min IS DISTINCT FROM 200.00 OR nonspec_height_max IS DISTINCT FROM 3000.00);
-- src: nonspec_update.csv:row19 PRD_000123→Y
UPDATE t_prd_products SET nonspec_yn = 'Y', nonspec_width_min = 200.00, nonspec_width_max = 1200.00, nonspec_height_min = 200.00, nonspec_height_max = 3000.00, upd_dt = now()
WHERE prd_cd = 'PRD_000123' AND (nonspec_yn IS DISTINCT FROM 'Y' OR nonspec_width_min IS DISTINCT FROM 200.00 OR nonspec_width_max IS DISTINCT FROM 1200.00 OR nonspec_height_min IS DISTINCT FROM 200.00 OR nonspec_height_max IS DISTINCT FROM 3000.00);
-- src: nonspec_update.csv:row20 PRD_000124→Y
UPDATE t_prd_products SET nonspec_yn = 'Y', nonspec_width_min = 200.00, nonspec_width_max = 1200.00, nonspec_height_min = 200.00, nonspec_height_max = 3000.00, upd_dt = now()
WHERE prd_cd = 'PRD_000124' AND (nonspec_yn IS DISTINCT FROM 'Y' OR nonspec_width_min IS DISTINCT FROM 200.00 OR nonspec_width_max IS DISTINCT FROM 1200.00 OR nonspec_height_min IS DISTINCT FROM 200.00 OR nonspec_height_max IS DISTINCT FROM 3000.00);
-- src: nonspec_update.csv:row21 PRD_000125→Y
UPDATE t_prd_products SET nonspec_yn = 'Y', nonspec_width_min = 200.00, nonspec_width_max = 1200.00, nonspec_height_min = 200.00, nonspec_height_max = 3000.00, upd_dt = now()
WHERE prd_cd = 'PRD_000125' AND (nonspec_yn IS DISTINCT FROM 'Y' OR nonspec_width_min IS DISTINCT FROM 200.00 OR nonspec_width_max IS DISTINCT FROM 1200.00 OR nonspec_height_min IS DISTINCT FROM 200.00 OR nonspec_height_max IS DISTINCT FROM 3000.00);
-- src: nonspec_update.csv:row22 PRD_000126→Y
UPDATE t_prd_products SET nonspec_yn = 'Y', nonspec_width_min = 200.00, nonspec_width_max = 600.00, nonspec_height_min = 200.00, nonspec_height_max = 3000.00, upd_dt = now()
WHERE prd_cd = 'PRD_000126' AND (nonspec_yn IS DISTINCT FROM 'Y' OR nonspec_width_min IS DISTINCT FROM 200.00 OR nonspec_width_max IS DISTINCT FROM 600.00 OR nonspec_height_min IS DISTINCT FROM 200.00 OR nonspec_height_max IS DISTINCT FROM 3000.00);
-- src: nonspec_update.csv:row23 PRD_000127→Y
UPDATE t_prd_products SET nonspec_yn = 'Y', nonspec_width_min = 200.00, nonspec_width_max = 1200.00, nonspec_height_min = 200.00, nonspec_height_max = 3000.00, upd_dt = now()
WHERE prd_cd = 'PRD_000127' AND (nonspec_yn IS DISTINCT FROM 'Y' OR nonspec_width_min IS DISTINCT FROM 200.00 OR nonspec_width_max IS DISTINCT FROM 1200.00 OR nonspec_height_min IS DISTINCT FROM 200.00 OR nonspec_height_max IS DISTINCT FROM 3000.00);
-- src: nonspec_update.csv:row24 PRD_000128→Y
UPDATE t_prd_products SET nonspec_yn = 'Y', nonspec_width_min = 200.00, nonspec_width_max = 600.00, nonspec_height_min = 200.00, nonspec_height_max = 3000.00, upd_dt = now()
WHERE prd_cd = 'PRD_000128' AND (nonspec_yn IS DISTINCT FROM 'Y' OR nonspec_width_min IS DISTINCT FROM 200.00 OR nonspec_width_max IS DISTINCT FROM 600.00 OR nonspec_height_min IS DISTINCT FROM 200.00 OR nonspec_height_max IS DISTINCT FROM 3000.00);
-- src: nonspec_update.csv:row25 PRD_000138→Y
UPDATE t_prd_products SET nonspec_yn = 'Y', nonspec_width_min = 500.00, nonspec_width_max = 1750.00, nonspec_height_min = 500.00, nonspec_height_max = 5000.00, upd_dt = now()
WHERE prd_cd = 'PRD_000138' AND (nonspec_yn IS DISTINCT FROM 'Y' OR nonspec_width_min IS DISTINCT FROM 500.00 OR nonspec_width_max IS DISTINCT FROM 1750.00 OR nonspec_height_min IS DISTINCT FROM 500.00 OR nonspec_height_max IS DISTINCT FROM 5000.00);
-- src: nonspec_update.csv:row26 PRD_000139→Y
UPDATE t_prd_products SET nonspec_yn = 'Y', nonspec_width_min = 500.00, nonspec_width_max = 900.00, nonspec_height_min = 500.00, nonspec_height_max = 3000.00, upd_dt = now()
WHERE prd_cd = 'PRD_000139' AND (nonspec_yn IS DISTINCT FROM 'Y' OR nonspec_width_min IS DISTINCT FROM 500.00 OR nonspec_width_max IS DISTINCT FROM 900.00 OR nonspec_height_min IS DISTINCT FROM 500.00 OR nonspec_height_max IS DISTINCT FROM 3000.00);
-- src: thickness_update.csv:row2 PRD_000146 MAT_000192→MAT_000043
UPDATE t_prd_product_materials SET mat_cd = 'MAT_000043', upd_dt = now()
WHERE prd_cd = 'PRD_000146' AND mat_cd = 'MAT_000192' AND usage_cd = 'USAGE.07';
-- src: thickness_update.csv:row3 PRD_000147 MAT_000192→MAT_000043
UPDATE t_prd_product_materials SET mat_cd = 'MAT_000043', upd_dt = now()
WHERE prd_cd = 'PRD_000147' AND mat_cd = 'MAT_000192' AND usage_cd = 'USAGE.07';
-- src: thickness_update.csv:row4 PRD_000148 MAT_000192→MAT_000043
UPDATE t_prd_product_materials SET mat_cd = 'MAT_000043', upd_dt = now()
WHERE prd_cd = 'PRD_000148' AND mat_cd = 'MAT_000192' AND usage_cd = 'USAGE.07';
-- src: thickness_update.csv:row5 PRD_000149 MAT_000192→MAT_000043
UPDATE t_prd_product_materials SET mat_cd = 'MAT_000043', upd_dt = now()
WHERE prd_cd = 'PRD_000149' AND mat_cd = 'MAT_000192' AND usage_cd = 'USAGE.07';
-- src: thickness_update.csv:row6 PRD_000150 MAT_000192→MAT_000043
UPDATE t_prd_product_materials SET mat_cd = 'MAT_000043', upd_dt = now()
WHERE prd_cd = 'PRD_000150' AND mat_cd = 'MAT_000192' AND usage_cd = 'USAGE.07';
-- src: thickness_update.csv:row7 PRD_000151 MAT_000192→MAT_000043
UPDATE t_prd_product_materials SET mat_cd = 'MAT_000043', upd_dt = now()
WHERE prd_cd = 'PRD_000151' AND mat_cd = 'MAT_000192' AND usage_cd = 'USAGE.07';
-- src: thickness_update.csv:row8 PRD_000152 MAT_000192→MAT_000043
UPDATE t_prd_product_materials SET mat_cd = 'MAT_000043', upd_dt = now()
WHERE prd_cd = 'PRD_000152' AND mat_cd = 'MAT_000192' AND usage_cd = 'USAGE.07';
-- src: thickness_update.csv:row9 PRD_000154 MAT_000192→MAT_000043
UPDATE t_prd_product_materials SET mat_cd = 'MAT_000043', upd_dt = now()
WHERE prd_cd = 'PRD_000154' AND mat_cd = 'MAT_000192' AND usage_cd = 'USAGE.07';
-- src: thickness_update.csv:row10 PRD_000155 MAT_000192→MAT_000043
UPDATE t_prd_product_materials SET mat_cd = 'MAT_000043', upd_dt = now()
WHERE prd_cd = 'PRD_000155' AND mat_cd = 'MAT_000192' AND usage_cd = 'USAGE.07';
-- src: thickness_update.csv:row11 PRD_000156 MAT_000192→MAT_000043
UPDATE t_prd_product_materials SET mat_cd = 'MAT_000043', upd_dt = now()
WHERE prd_cd = 'PRD_000156' AND mat_cd = 'MAT_000192' AND usage_cd = 'USAGE.07';
-- src: thickness_update.csv:row12 PRD_000157 MAT_000192→MAT_000043
UPDATE t_prd_product_materials SET mat_cd = 'MAT_000043', upd_dt = now()
WHERE prd_cd = 'PRD_000157' AND mat_cd = 'MAT_000192' AND usage_cd = 'USAGE.07';
-- src: thickness_update.csv:row13 PRD_000158 MAT_000192→MAT_000043
UPDATE t_prd_product_materials SET mat_cd = 'MAT_000043', upd_dt = now()
WHERE prd_cd = 'PRD_000158' AND mat_cd = 'MAT_000192' AND usage_cd = 'USAGE.07';
-- src: thickness_update.csv:row14 PRD_000159 MAT_000192→MAT_000043
UPDATE t_prd_product_materials SET mat_cd = 'MAT_000043', upd_dt = now()
WHERE prd_cd = 'PRD_000159' AND mat_cd = 'MAT_000192' AND usage_cd = 'USAGE.07';
-- src: thickness_update.csv:row15 PRD_000160 MAT_000192→MAT_000043
UPDATE t_prd_product_materials SET mat_cd = 'MAT_000043', upd_dt = now()
WHERE prd_cd = 'PRD_000160' AND mat_cd = 'MAT_000192' AND usage_cd = 'USAGE.07';
-- src: thickness_update.csv:row16 PRD_000161 MAT_000192→MAT_000043
UPDATE t_prd_product_materials SET mat_cd = 'MAT_000043', upd_dt = now()
WHERE prd_cd = 'PRD_000161' AND mat_cd = 'MAT_000192' AND usage_cd = 'USAGE.07';
-- src: thickness_update.csv:row17 PRD_000162 MAT_000192→MAT_000043
UPDATE t_prd_product_materials SET mat_cd = 'MAT_000043', upd_dt = now()
WHERE prd_cd = 'PRD_000162' AND mat_cd = 'MAT_000192' AND usage_cd = 'USAGE.07';
-- src: thickness_update.csv:row18 PRD_000163 MAT_000192→MAT_000042
UPDATE t_prd_product_materials SET mat_cd = 'MAT_000042', upd_dt = now()
WHERE prd_cd = 'PRD_000163' AND mat_cd = 'MAT_000192' AND usage_cd = 'USAGE.07';
-- src: thickness_update.csv:row19 PRD_000164 MAT_000192→MAT_000044
UPDATE t_prd_product_materials SET mat_cd = 'MAT_000044', upd_dt = now()
WHERE prd_cd = 'PRD_000164' AND mat_cd = 'MAT_000192' AND usage_cd = 'USAGE.07';
-- src: thickness_update.csv:row20 PRD_000165 MAT_000192→MAT_000044
UPDATE t_prd_product_materials SET mat_cd = 'MAT_000044', upd_dt = now()
WHERE prd_cd = 'PRD_000165' AND mat_cd = 'MAT_000192' AND usage_cd = 'USAGE.07';
-- src: thickness_update.csv:row21 PRD_000166 MAT_000192→MAT_000043
UPDATE t_prd_product_materials SET mat_cd = 'MAT_000043', upd_dt = now()
WHERE prd_cd = 'PRD_000166' AND mat_cd = 'MAT_000192' AND usage_cd = 'USAGE.07';
