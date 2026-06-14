-- =====================================================================
-- step 07 — t_prd_product_option_items (스티커 4상품 · 21행 INSERTABLE)
-- 트리거 fn_chk_opt_item_ref 가 행단위 차원행 EXISTS 검사:
--   .03 자재 → t_prd_product_materials(mat_cd=ref_key1, usage_cd=ref_key2) · .06 도수 → print_options(opt_id::int=ref_key1) · .04 공정 → processes(proc_cd=ref_key1).
-- 전 차원행 라이브 적재 실측(2026-06-14) → BLOCKED 0.
-- 멱등 가드 = (prd_cd, opt_cd resolve, item_seq) NOT EXISTS. opt_cd=opt_nm+opt_grp_nm resolve(06 선행, 같은 트랜잭션).
-- ref_key1 NOT NULL. reg_dt 생략→DEFAULT now(). 화이트없음 센티넬=item 0행. 손편집 금지.
-- =====================================================================

-- ===== PRD_000052 종이5(.03)·인쇄1(.06)·커팅1(.04) = 7 =====
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000052',(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000052' AND opt_nm='유포스티커' AND del_yn='N' ORDER BY opt_cd LIMIT 1),1,'OPT_REF_DIM.03','MAT_000153','USAGE.07',1,'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_items WHERE prd_cd='PRD_000052' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000052' AND opt_nm='유포스티커' AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000052',(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000052' AND opt_nm='비코팅스티커' AND del_yn='N' ORDER BY opt_cd LIMIT 1),1,'OPT_REF_DIM.03','MAT_000084','USAGE.07',1,'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_items WHERE prd_cd='PRD_000052' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000052' AND opt_nm='비코팅스티커' AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000052',(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000052' AND opt_nm='무광코팅스티커' AND del_yn='N' ORDER BY opt_cd LIMIT 1),1,'OPT_REF_DIM.03','MAT_000155','USAGE.07',1,'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_items WHERE prd_cd='PRD_000052' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000052' AND opt_nm='무광코팅스티커' AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000052',(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000052' AND opt_nm='유광코팅스티커' AND del_yn='N' ORDER BY opt_cd LIMIT 1),1,'OPT_REF_DIM.03','MAT_000156','USAGE.07',1,'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_items WHERE prd_cd='PRD_000052' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000052' AND opt_nm='유광코팅스티커' AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000052',(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000052' AND opt_nm='미색스티커' AND del_yn='N' ORDER BY opt_cd LIMIT 1),1,'OPT_REF_DIM.03','MAT_000242','USAGE.07',1,'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_items WHERE prd_cd='PRD_000052' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000052' AND opt_nm='미색스티커' AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000052',(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000052' AND opt_nm='단면' AND del_yn='N' ORDER BY opt_cd LIMIT 1),1,'OPT_REF_DIM.06','1',NULL,1,'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_items WHERE prd_cd='PRD_000052' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000052' AND opt_nm='단면' AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000052',(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000052' AND opt_nm='반칼(자유형)' AND del_yn='N' ORDER BY opt_cd LIMIT 1),1,'OPT_REF_DIM.04','PROC_000054',NULL,1,'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_items WHERE prd_cd='PRD_000052' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000052' AND opt_nm='반칼(자유형)' AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);

-- ===== PRD_000053 종이1(.03)·인쇄1(.06)·화이트인쇄1(.04)·커팅1(.04) = 4 (화이트없음 센티넬=0) =====
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000053',(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000053' AND opt_nm='투명스티커' AND del_yn='N' ORDER BY opt_cd LIMIT 1),1,'OPT_REF_DIM.03','MAT_000162','USAGE.07',1,'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_items WHERE prd_cd='PRD_000053' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000053' AND opt_nm='투명스티커' AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000053',(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000053' AND opt_nm='단면' AND del_yn='N' ORDER BY opt_cd LIMIT 1),1,'OPT_REF_DIM.06','1',NULL,1,'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_items WHERE prd_cd='PRD_000053' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000053' AND opt_nm='단면' AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000053',(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000053' AND opt_nm='화이트인쇄' AND del_yn='N' ORDER BY opt_cd LIMIT 1),1,'OPT_REF_DIM.04','PROC_000008',NULL,1,'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_items WHERE prd_cd='PRD_000053' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000053' AND opt_nm='화이트인쇄' AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000053',(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000053' AND opt_nm='반칼(자유형)' AND del_yn='N' ORDER BY opt_cd LIMIT 1),1,'OPT_REF_DIM.04','PROC_000054',NULL,1,'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_items WHERE prd_cd='PRD_000053' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000053' AND opt_nm='반칼(자유형)' AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);

-- ===== PRD_000055 종이1(.03)·인쇄1(.06)·커팅1(.04) = 3 =====
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000055',(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000055' AND opt_nm='유포지' AND del_yn='N' ORDER BY opt_cd LIMIT 1),1,'OPT_REF_DIM.03','MAT_000154','USAGE.07',1,'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_items WHERE prd_cd='PRD_000055' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000055' AND opt_nm='유포지' AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000055',(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000055' AND opt_nm='단면' AND del_yn='N' ORDER BY opt_cd LIMIT 1),1,'OPT_REF_DIM.06','1',NULL,1,'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_items WHERE prd_cd='PRD_000055' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000055' AND opt_nm='단면' AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000055',(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000055' AND opt_nm='완칼(자유형)' AND del_yn='N' ORDER BY opt_cd LIMIT 1),1,'OPT_REF_DIM.04','PROC_000053',NULL,1,'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_items WHERE prd_cd='PRD_000055' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000055' AND opt_nm='완칼(자유형)' AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);

-- ===== PRD_000066 종이6(.03)·인쇄1(.06) = 7 =====
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000066',(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000066' AND opt_nm='유포스티커' AND del_yn='N' ORDER BY opt_cd LIMIT 1),1,'OPT_REF_DIM.03','MAT_000153','USAGE.07',1,'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_items WHERE prd_cd='PRD_000066' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000066' AND opt_nm='유포스티커' AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000066',(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000066' AND opt_nm='비코팅스티커' AND del_yn='N' ORDER BY opt_cd LIMIT 1),1,'OPT_REF_DIM.03','MAT_000084','USAGE.07',1,'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_items WHERE prd_cd='PRD_000066' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000066' AND opt_nm='비코팅스티커' AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000066',(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000066' AND opt_nm='무광코팅스티커' AND del_yn='N' ORDER BY opt_cd LIMIT 1),1,'OPT_REF_DIM.03','MAT_000155','USAGE.07',1,'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_items WHERE prd_cd='PRD_000066' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000066' AND opt_nm='무광코팅스티커' AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000066',(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000066' AND opt_nm='유광코팅스티커' AND del_yn='N' ORDER BY opt_cd LIMIT 1),1,'OPT_REF_DIM.03','MAT_000156','USAGE.07',1,'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_items WHERE prd_cd='PRD_000066' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000066' AND opt_nm='유광코팅스티커' AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000066',(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000066' AND opt_nm='투명데드롱스티커' AND del_yn='N' ORDER BY opt_cd LIMIT 1),1,'OPT_REF_DIM.03','MAT_000170','USAGE.07',1,'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_items WHERE prd_cd='PRD_000066' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000066' AND opt_nm='투명데드롱스티커' AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000066',(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000066' AND opt_nm='은데드롱스티커' AND del_yn='N' ORDER BY opt_cd LIMIT 1),1,'OPT_REF_DIM.03','MAT_000171','USAGE.07',1,'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_items WHERE prd_cd='PRD_000066' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000066' AND opt_nm='은데드롱스티커' AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)
SELECT 'PRD_000066',(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000066' AND opt_nm='단면' AND del_yn='N' ORDER BY opt_cd LIMIT 1),1,'OPT_REF_DIM.06','1',NULL,1,'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_items WHERE prd_cd='PRD_000066' AND opt_cd=(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='PRD_000066' AND opt_nm='단면' AND del_yn='N' ORDER BY opt_cd LIMIT 1) AND item_seq=1);
