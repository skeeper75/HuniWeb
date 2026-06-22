-- backup-20260623_013932.sql — §21 포토카드 V3 교정 물리 백업 (변경 대상 현재값 스냅샷)
-- 2026-06-23 · 라이브 읽기전용 SELECT 캡처. 복원은 undo.sql 참조.
-- ========================================================================

-- [B1] 현재 PRF_PHOTOCARD_* 공식 (신규 2개 미실재 기준선)
       frm_cd        |        frm_nm        | use_yn |           reg_dt           
---------------------+----------------------+--------+----------------------------
 PRF_PHOTOCARD_FIXED | 포토카드 세트 고정가 | Y      | 2026-06-06 11:30:40.467045
(1 row)


-- [B2] 현재 024/025 바인딩 (교정 전 frm_cd=PRF_PHOTOCARD_FIXED)
   prd_cd   |       frm_cd        | apply_bgn_ymd |                      note                       |           reg_dt           
------------+---------------------+---------------+-------------------------------------------------+----------------------------
 PRD_000024 | PRF_PHOTOCARD_FIXED | 2026-06-01    | 포토카드(20장1세트)→세트고정가 (wave-2 B-2)     | 2026-06-06 11:30:40.467045
 PRD_000025 | PRF_PHOTOCARD_FIXED | 2026-06-01    | 투명포토카드(20장1세트)→세트고정가 (wave-2 B-2) | 2026-06-06 11:30:40.467045
(2 rows)


-- [B3] PRF_PHOTOCARD_FIXED formula_components (교정 전 SET+CLEAR_SET 둘 다 배선)
       frm_cd        |         comp_cd          | disp_seq | addtn_yn |           reg_dt           
---------------------+--------------------------+----------+----------+----------------------------
 PRF_PHOTOCARD_FIXED | COMP_PHOTOCARD_CLEAR_SET |        2 | Y        | 2026-06-06 11:30:40.467045
 PRF_PHOTOCARD_FIXED | COMP_PHOTOCARD_SET       |        1 | Y        | 2026-06-06 11:30:40.467045
(2 rows)


-- [B4] 단가행 verbatim 기준선 (SET=6000·CLEAR_SET=8500·불변 대상)
         comp_cd          |   siz_cd   | bdl_qty | min_qty | unit_price | proc_cd 
--------------------------+------------+---------+---------+------------+---------
 COMP_PHOTOCARD_CLEAR_SET | SIZ_000012 |      20 |       1 |    8500.00 | <NULL>
 COMP_PHOTOCARD_SET       | SIZ_000012 |      20 |       1 |    6000.00 | <NULL>
(2 rows)


-- [B5] 두 comp use_dims (불변 대상)
         comp_cd          |             use_dims             
--------------------------+----------------------------------
 COMP_PHOTOCARD_CLEAR_SET | ["siz_cd", "bdl_qty", "min_qty"]
 COMP_PHOTOCARD_SET       | ["siz_cd", "bdl_qty", "min_qty"]
(2 rows)

