-- ============================================================
-- REVIEW 안전분 부속 addon 링크 추가 · 03 FIX (실 COMMIT)
--   부속이 오모델 아님(자재 정상)·단지 addon 링크 누락 → 순수 INSERT(자재/템플릿 변경 0).
--   대상: 포카키링(158)=칼라볼체인8 · 엽서캘린더(110)=우드거치대 · 탁상형캘린더(108)=캘린더봉투2.
--   부속 템플릿 전부 활성·template_prices 권위값 보유(볼체인1000·우드거치대4000·봉투2500/2400).
--   라이브 sim 검증: 각 addon 정상 가산 확인.
--   백업: 01-backup.sql(z_bak_acrev_addons). undo: 04-undo.sql.
-- ============================================================
BEGIN;
SET LOCAL statement_timeout = '60s';

DO $chk$ DECLARE n int; BEGIN
  SELECT count(*) INTO n FROM information_schema.tables WHERE table_name='z_bak_acrev_addons';
  IF n<>1 THEN RAISE EXCEPTION '중단: 백업 없음. 01-backup 선행.'; END IF;
END $chk$;

-- 사전게이트: 대상 3상품 현재 addon 링크 0(중복 방지)
DO $pre$ DECLARE n int; BEGIN
  SELECT count(*) INTO n FROM t_prd_product_addons WHERE prd_cd IN ('PRD_000158','PRD_000110','PRD_000108');
  IF n<>0 THEN RAISE EXCEPTION '사전게이트: 기존 addon 링크 %개(0 기대·중복 위험)', n; END IF;
END $pre$;

-- 포카키링 → 칼라볼체인 8색(아크릴키링 미러)
INSERT INTO t_prd_product_addons (prd_cd, disp_seq, note, reg_dt, tmpl_cd) VALUES
 ('PRD_000158', 1, 'addon 볼체인 링크(등록점검표 REVIEW·가격표)', now(), 'TMPL-000056'),
 ('PRD_000158', 2, 'addon 볼체인 링크', now(), 'TMPL-000057'),
 ('PRD_000158', 3, 'addon 볼체인 링크', now(), 'TMPL-000058'),
 ('PRD_000158', 4, 'addon 볼체인 링크', now(), 'TMPL-000059'),
 ('PRD_000158', 5, 'addon 볼체인 링크', now(), 'TMPL-000060'),
 ('PRD_000158', 6, 'addon 볼체인 링크', now(), 'TMPL-000061'),
 ('PRD_000158', 7, 'addon 볼체인 링크', now(), 'TMPL-000062'),
 ('PRD_000158', 8, 'addon 볼체인 링크', now(), 'TMPL-000063'),
-- 엽서캘린더 → 우드거치대
 ('PRD_000110', 1, 'addon 우드거치대 링크(등록점검표 REVIEW·가격표 4000)', now(), 'TMPL-000045'),
-- 탁상형캘린더 → 캘린더봉투 2종
 ('PRD_000108', 1, 'addon 캘린더봉투 링크(등록점검표 REVIEW·가격표 2500)', now(), 'TMPL-000040'),
 ('PRD_000108', 2, 'addon 캘린더봉투 링크(등록점검표 REVIEW·가격표 2400)', now(), 'TMPL-000041');

DO $post$ DECLARE n158 int; n110 int; n108 int; BEGIN
  SELECT count(*) INTO n158 FROM t_prd_product_addons WHERE prd_cd='PRD_000158';
  SELECT count(*) INTO n110 FROM t_prd_product_addons WHERE prd_cd='PRD_000110';
  SELECT count(*) INTO n108 FROM t_prd_product_addons WHERE prd_cd='PRD_000108';
  IF n158<>8 OR n110<>1 OR n108<>2 THEN
    RAISE EXCEPTION '사후게이트: 링크수 158=%(8) 110=%(1) 108=%(2)', n158, n110, n108;
  END IF;
  RAISE NOTICE 'FIX 게이트 통과: 포카키링8·엽서캘린더1·탁상형캘린더2 링크.';
END $post$;

COMMIT;
