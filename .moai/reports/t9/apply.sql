-- t9 R2 실적용 — 중철책자-표지(PRD_000288) 사이즈 권위 정합 재배선
--
-- 승인: 지니 260904 (lead-peta [8748b7] 경유) — R2·R3 위생 교정 COMMIT 승인
-- 범위: R2 만. R3(SIZ_000181 재단·여백 채움)은 DRY-RUN 미포함이라 명세로만 남긴다.
--       R1·R4·R5·R6 는 손대지 않는다.
--
-- 무엇을: 레거시 SIZ_000251(300x214 · 재단/여백 NULL) → SIZ_000631(재단 296x210 ·
--         작업 302x216 · 여백 3mm, 권위 「판걸이수」 r60 = 재단 + 2×블리드 정합)
-- 가격영향: 0원. fn_calc_pansu('SIZ_000499', ·) 가 251·631 둘 다 2 (pre_live.txt)
-- 되돌리기: rollback.sql
--
-- [HARD] 기초마스터 코드 물리삭제 금지 — 레거시는 del_yn='Y' 논리삭제만.

\set ON_ERROR_STOP 1

BEGIN;

\echo '=== 사전 가드 — 대상 상태가 기대와 같은지 확인 ==='
-- SIZ_000251 이 살아있는 dflt 행이어야 하고, SIZ_000631 은 아직 미연결이어야 한다.
DO $$
DECLARE n_legacy int; n_new int; n_pansu_old int; n_pansu_new int;
BEGIN
  SELECT count(*) INTO n_legacy FROM t_prd_product_sizes
   WHERE prd_cd='PRD_000288' AND siz_cd='SIZ_000251' AND del_yn='N';
  SELECT count(*) INTO n_new FROM t_prd_product_sizes
   WHERE prd_cd='PRD_000288' AND siz_cd='SIZ_000631' AND del_yn='N';
  SELECT fn_calc_pansu('SIZ_000499','SIZ_000251') INTO n_pansu_old;
  SELECT fn_calc_pansu('SIZ_000499','SIZ_000631') INTO n_pansu_new;
  IF n_legacy <> 1 THEN
    RAISE EXCEPTION '가드 실패: SIZ_000251 살아있는 행 = % (기대 1)', n_legacy;
  END IF;
  IF n_new <> 0 THEN
    RAISE EXCEPTION '가드 실패: SIZ_000631 이미 연결됨 = % (기대 0)', n_new;
  END IF;
  IF n_pansu_old <> n_pansu_new THEN
    RAISE EXCEPTION '가드 실패: 판걸이 불일치 251=% 631=% — 가격영향 0 전제 붕괴',
                    n_pansu_old, n_pansu_new;
  END IF;
  RAISE NOTICE '가드 통과 — 레거시 1행 · 신규 미연결 · 판걸이 %=% 동일',
               n_pansu_old, n_pansu_new;
END $$;

-- ① 권위 정합 사이즈 연결(멱등 UPSERT)
INSERT INTO t_prd_product_sizes (prd_cd, siz_cd, dflt_yn, disp_seq, reg_dt, del_yn)
VALUES ('PRD_000288', 'SIZ_000631', 'Y', 1, now(), 'N')
ON CONFLICT (prd_cd, siz_cd) DO UPDATE
   SET dflt_yn = 'Y', disp_seq = 1, del_yn = 'N', del_dt = NULL, upd_dt = now();

-- ② 레거시 사이즈 논리삭제
UPDATE t_prd_product_sizes
   SET del_yn = 'Y', del_dt = now(), upd_dt = now(), dflt_yn = 'N'
 WHERE prd_cd = 'PRD_000288' AND siz_cd = 'SIZ_000251' AND del_yn = 'N';

\echo '=== 사후 가드 — 살아있는 행 2건(631 dflt Y + 181) ==='
DO $$
DECLARE n_live int; n_dflt int;
BEGIN
  SELECT count(*) INTO n_live FROM t_prd_product_sizes
   WHERE prd_cd='PRD_000288' AND del_yn='N';
  SELECT count(*) INTO n_dflt FROM t_prd_product_sizes
   WHERE prd_cd='PRD_000288' AND del_yn='N' AND dflt_yn='Y';
  IF n_live <> 2 THEN RAISE EXCEPTION '사후 가드 실패: 살아있는 행 % (기대 2)', n_live; END IF;
  IF n_dflt <> 1 THEN RAISE EXCEPTION '사후 가드 실패: 기본 행 % (기대 1)', n_dflt; END IF;
  RAISE NOTICE '사후 가드 통과 — 살아있는 행 2 · 기본 1';
END $$;

\echo '=== AFTER ==='
SELECT s.siz_cd, z.siz_nm, z.cut_width, z.cut_height, z.work_width, z.work_height,
       z.margin_top, z.margin_lft, s.dflt_yn, s.disp_seq,
       fn_calc_pansu('SIZ_000499', s.siz_cd) AS pansu
FROM t_prd_product_sizes s JOIN t_siz_sizes z ON z.siz_cd = s.siz_cd
WHERE s.prd_cd = 'PRD_000288' AND s.del_yn = 'N'
ORDER BY s.disp_seq;

COMMIT;
