-- t9 DRY-RUN — 중철책자-표지(PRD_000288) 사이즈 권위 정합 재배선
--
-- 무엇을: 레거시 SIZ_000251(300x214 · cut/여백 NULL) → 신설 SIZ_000631(296x210 재단 ·
--         302x216 작업 · 여백 3mm, 권위 「판걸이수」 r60 정합)로 교체.
-- 왜:     r60 블리드 3.0 → 작업 = 재단 + 2×3 = 302x216. 라이브 251 은 +2 (300x214) 이고
--         cut_width/cut_height/여백이 전부 NULL 이라 재단치수 근거가 화면에 없다.
-- 가격영향: 0원. fn_calc_pansu('SIZ_000499', ·) 가 251·631 둘 다 2 를 준다(pansu_jungchul.txt).
-- [HARD] 이 파일은 스스로 ROLLBACK 한다. 실 적용은 지니 승인 후 별도 apply.sql 로만.

\timing off
\set ON_ERROR_STOP 1

BEGIN;

\echo '=== BEFORE — PRD_000288 살아있는 사이즈 ==='
SELECT s.siz_cd, z.siz_nm, z.cut_width, z.cut_height, z.work_width, z.work_height,
       z.margin_top, z.margin_lft, s.dflt_yn, s.disp_seq, s.del_yn
FROM t_prd_product_sizes s JOIN t_siz_sizes z ON z.siz_cd = s.siz_cd
WHERE s.prd_cd = 'PRD_000288' AND s.del_yn = 'N'
ORDER BY s.disp_seq;

\echo '=== BEFORE — 판걸이 대조(316x467 기준) ==='
SELECT 'SIZ_000251' AS siz, fn_calc_pansu('SIZ_000499', 'SIZ_000251') AS pansu
UNION ALL SELECT 'SIZ_000631', fn_calc_pansu('SIZ_000499', 'SIZ_000631');

-- ① 신설 사이즈 연결(멱등 UPSERT — 이미 있으면 되살리기만)
INSERT INTO t_prd_product_sizes (prd_cd, siz_cd, dflt_yn, disp_seq, reg_dt, del_yn)
VALUES ('PRD_000288', 'SIZ_000631', 'Y', 1, now(), 'N')
ON CONFLICT (prd_cd, siz_cd) DO UPDATE
   SET dflt_yn = 'Y', disp_seq = 1, del_yn = 'N', del_dt = NULL, upd_dt = now();

-- ② 레거시 사이즈 논리삭제(물리삭제 금지 — 기초마스터 코드 삭제금지 원칙)
UPDATE t_prd_product_sizes
   SET del_yn = 'Y', del_dt = now(), upd_dt = now(), dflt_yn = 'N'
 WHERE prd_cd = 'PRD_000288' AND siz_cd = 'SIZ_000251' AND del_yn = 'N';

\echo '=== AFTER — PRD_000288 살아있는 사이즈 ==='
SELECT s.siz_cd, z.siz_nm, z.cut_width, z.cut_height, z.work_width, z.work_height,
       z.margin_top, z.margin_lft, s.dflt_yn, s.disp_seq, s.del_yn
FROM t_prd_product_sizes s JOIN t_siz_sizes z ON z.siz_cd = s.siz_cd
WHERE s.prd_cd = 'PRD_000288' AND s.del_yn = 'N'
ORDER BY s.disp_seq;

\echo '=== AFTER — 영향 행수 검증(살아있는 행 = 2 여야 함: 631 + 181) ==='
SELECT count(*) AS live_rows FROM t_prd_product_sizes
WHERE prd_cd = 'PRD_000288' AND del_yn = 'N';

\echo '=== ROLLBACK — 라이브 무변경 ==='
ROLLBACK;

\echo '=== POST-ROLLBACK 확인 — BEFORE 와 동일해야 한다 ==='
SELECT s.siz_cd, z.siz_nm, s.dflt_yn, s.del_yn
FROM t_prd_product_sizes s JOIN t_siz_sizes z ON z.siz_cd = s.siz_cd
WHERE s.prd_cd = 'PRD_000288' AND s.del_yn = 'N'
ORDER BY s.disp_seq;
