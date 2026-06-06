-- undo-after-load.sql — 상품마스터 적재를 무손실 되돌리는 언두 데이터 연산 (round-5)
-- 생성: gen_safety_sql.py (손편집 금지).
--
-- 본 파일은 BEGIN/CREATE TEMP/\copy FROM 을 포함하지 않는다 — undo.sh 가 리터럴 경로로
-- 임시테이블(_undo_keys/_bi_products/_bi_materials)을 선적재한 뒤 이 파일을 \i 한다.
-- (psql v18 의 \copy 는 :'var' 경로 보간 미지원 → 셸이 리터럴 경로 주입.)
-- COMMIT/ROLLBACK 도 undo.sh 가 주입. 기본 = DRY-RUN(ROLLBACK).
--
-- (A) INSERT 언두 = 로그된 신규 PK 만 DELETE(선존행 불가침).
-- (B) UPDATE-set 언두 = before-image 로 복원.

-- ── (A) INSERT 언두 — 로그된 신규 PK 키만 DELETE (_undo_keys 선적재 전제) ──
\echo '>> undo DELETE t_prd_product_bundle_qtys (logged new keys only)'
DELETE FROM t_prd_product_bundle_qtys USING _undo_keys
 WHERE _undo_keys.tbl = 't_prd_product_bundle_qtys'
   AND t_prd_product_bundle_qtys.prd_cd::text = split_part(_undo_keys.pk_vals, '|', 1)
   AND t_prd_product_bundle_qtys.bdl_qty::text = split_part(_undo_keys.pk_vals, '|', 2);

\echo '>> undo DELETE t_prd_product_processes (logged new keys only)'
DELETE FROM t_prd_product_processes USING _undo_keys
 WHERE _undo_keys.tbl = 't_prd_product_processes'
   AND t_prd_product_processes.prd_cd::text = split_part(_undo_keys.pk_vals, '|', 1)
   AND t_prd_product_processes.proc_cd::text = split_part(_undo_keys.pk_vals, '|', 2);

\echo '>> undo DELETE t_prd_product_materials (logged new keys only)'
DELETE FROM t_prd_product_materials USING _undo_keys
 WHERE _undo_keys.tbl = 't_prd_product_materials'
   AND t_prd_product_materials.prd_cd::text = split_part(_undo_keys.pk_vals, '|', 1)
   AND t_prd_product_materials.mat_cd::text = split_part(_undo_keys.pk_vals, '|', 2)
   AND t_prd_product_materials.usage_cd::text = split_part(_undo_keys.pk_vals, '|', 3);

\echo '>> undo DELETE t_siz_sizes (logged new keys only)'
DELETE FROM t_siz_sizes USING _undo_keys
 WHERE _undo_keys.tbl = 't_siz_sizes'
   AND t_siz_sizes.siz_cd::text = split_part(_undo_keys.pk_vals, '|', 1);

\echo '>> undo DELETE t_proc_processes (logged new keys only)'
DELETE FROM t_proc_processes USING _undo_keys
 WHERE _undo_keys.tbl = 't_proc_processes'
   AND t_proc_processes.proc_cd::text = split_part(_undo_keys.pk_vals, '|', 1);

-- ── (B) UPDATE-set 언두 — before-image 로 복원 (_bi_* 선적재 전제) ──
-- (B-1) t_prd_products: qty_unit_typ_cd + nonspec 5컬럼을 백업값으로 되돌림.
\echo '>> undo RESTORE t_prd_products (before-image)'
UPDATE t_prd_products p SET
  qty_unit_typ_cd  = b.qty_unit_typ_cd,
  nonspec_yn       = b.nonspec_yn,
  nonspec_width_min  = b.nonspec_width_min,
  nonspec_width_max  = b.nonspec_width_max,
  nonspec_height_min = b.nonspec_height_min,
  nonspec_height_max = b.nonspec_height_max,
  upd_dt = now()
FROM _bi_products b
WHERE p.prd_cd = b.prd_cd
  AND (p.qty_unit_typ_cd IS DISTINCT FROM b.qty_unit_typ_cd
    OR p.nonspec_yn IS DISTINCT FROM b.nonspec_yn
    OR p.nonspec_width_min IS DISTINCT FROM b.nonspec_width_min
    OR p.nonspec_width_max IS DISTINCT FROM b.nonspec_width_max
    OR p.nonspec_height_min IS DISTINCT FROM b.nonspec_height_min
    OR p.nonspec_height_max IS DISTINCT FROM b.nonspec_height_max);

-- (B-2) t_prd_product_materials thickness: mat_cd(=PK) 변경을 되돌림.
-- 적재가 (prd,OLD_mat,usage) → mat_cd=NEW 로 바꿨으므로, 언두는 백업의
-- (prd, OLD_mat, usage) 가 사라지고 (prd, NEW_mat, usage) 가 생겼다.
-- before-image(_bi_materials, undo.sh 선적재)에는 OLD 행 전체가 있다. 복원 = 현재
-- NEW PK 행을 OLD 로 되돌리되, 적재 매핑(OLD→NEW)을 thickness_update 에서 읽어 짝지운다.
-- OLD→NEW 매핑(적재 SQL 권위에서 그대로 추출, 손편집 0).
CREATE TEMP TABLE _thk_map (prd_cd text, old_mat text, usage_cd text, new_mat text) ON COMMIT DROP;
INSERT INTO _thk_map VALUES ('PRD_000146', 'MAT_000192', 'USAGE.07', 'MAT_000043');
INSERT INTO _thk_map VALUES ('PRD_000147', 'MAT_000192', 'USAGE.07', 'MAT_000043');
INSERT INTO _thk_map VALUES ('PRD_000148', 'MAT_000192', 'USAGE.07', 'MAT_000043');
INSERT INTO _thk_map VALUES ('PRD_000149', 'MAT_000192', 'USAGE.07', 'MAT_000043');
INSERT INTO _thk_map VALUES ('PRD_000150', 'MAT_000192', 'USAGE.07', 'MAT_000043');
INSERT INTO _thk_map VALUES ('PRD_000151', 'MAT_000192', 'USAGE.07', 'MAT_000043');
INSERT INTO _thk_map VALUES ('PRD_000152', 'MAT_000192', 'USAGE.07', 'MAT_000043');
INSERT INTO _thk_map VALUES ('PRD_000154', 'MAT_000192', 'USAGE.07', 'MAT_000043');
INSERT INTO _thk_map VALUES ('PRD_000155', 'MAT_000192', 'USAGE.07', 'MAT_000043');
INSERT INTO _thk_map VALUES ('PRD_000156', 'MAT_000192', 'USAGE.07', 'MAT_000043');
INSERT INTO _thk_map VALUES ('PRD_000157', 'MAT_000192', 'USAGE.07', 'MAT_000043');
INSERT INTO _thk_map VALUES ('PRD_000158', 'MAT_000192', 'USAGE.07', 'MAT_000043');
INSERT INTO _thk_map VALUES ('PRD_000159', 'MAT_000192', 'USAGE.07', 'MAT_000043');
INSERT INTO _thk_map VALUES ('PRD_000160', 'MAT_000192', 'USAGE.07', 'MAT_000043');
INSERT INTO _thk_map VALUES ('PRD_000161', 'MAT_000192', 'USAGE.07', 'MAT_000043');
INSERT INTO _thk_map VALUES ('PRD_000162', 'MAT_000192', 'USAGE.07', 'MAT_000043');
INSERT INTO _thk_map VALUES ('PRD_000163', 'MAT_000192', 'USAGE.07', 'MAT_000042');
INSERT INTO _thk_map VALUES ('PRD_000164', 'MAT_000192', 'USAGE.07', 'MAT_000044');
INSERT INTO _thk_map VALUES ('PRD_000165', 'MAT_000192', 'USAGE.07', 'MAT_000044');
INSERT INTO _thk_map VALUES ('PRD_000166', 'MAT_000192', 'USAGE.07', 'MAT_000043');
\echo '>> undo RESTORE t_prd_product_materials thickness (mat_cd PK revert)'
UPDATE t_prd_product_materials m SET mat_cd = t.old_mat, upd_dt = now()
FROM _thk_map t
WHERE m.prd_cd = t.prd_cd AND m.usage_cd = t.usage_cd AND m.mat_cd = t.new_mat
  -- 안전: before-image 에 OLD 행이 실제 존재했던 경우만 복원(임의 행 생성 방지).
  AND EXISTS (SELECT 1 FROM _bi_materials bi
             WHERE bi.prd_cd = t.prd_cd AND bi.usage_cd = t.usage_cd AND bi.mat_cd = t.old_mat);

DROP TABLE IF EXISTS _thk_map;
-- (BEGIN/COMMIT/ROLLBACK·_undo_keys/_bi_* 선적재는 undo.sh 가 리터럴 경로로 래핑.)
