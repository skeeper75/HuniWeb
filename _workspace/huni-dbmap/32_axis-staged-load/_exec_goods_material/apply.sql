-- =====================================================================
-- GPM-1/2 굿즈/파우치 본체 자재 link 멱등 적재본 (round-22 · 자재축 ④)
-- 생성: dbm-correctness-auditor 2026-06-16
-- 대상: t_prd_product_materials — 명확분 41상품 본체 소재 link 신규 INSERT
-- 권위: 상품마스터 굿즈파우치 시트(goods-pouch-l1.csv) + 상품명 도메인. v03 배제.
-- search-before-mint: 기존 자재행 재사용(MAT_000008/183/184/185), 신규 mint 0.
-- 멱등: PK=(prd_cd,mat_cd,usage_cd), ON CONFLICT DO NOTHING. reg_dt/del_yn=DEFAULT.
-- usage_cd=USAGE.07(공통=본체 슬롯), dflt_yn='Y', disp_seq=1 (라이브 컨벤션 실측).
-- [HARD] 비파괴: 기존 .09/.08 오염 link는 건드리지 않음(후속 GPM-4가 제거).
-- [HARD] 실 COMMIT은 인간 승인. 아래는 BEGIN...ROLLBACK DRY-RUN 래핑.
-- =====================================================================

BEGIN;

-- ---- 가드 0: 재사용 자재행 4종 실재(use_yn='Y') 사전 확인 ------------
DO $$
DECLARE n int;
BEGIN
  SELECT count(*) INTO n FROM t_mat_materials
   WHERE mat_cd IN ('MAT_000008','MAT_000183','MAT_000184','MAT_000185')
     AND use_yn='Y';
  IF n <> 4 THEN
    RAISE EXCEPTION 'GUARD0 FAIL: 재사용 자재행 4종 미충족 (found=%）', n;
  END IF;
END $$;

-- ---- INSERT: 명확분 41 본체 소재 link --------------------------------
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dflt_yn, disp_seq)
VALUES
  -- GPM-2 레더 .06 MAT_000008 (23)
  ('PRD_000254','MAT_000008','USAGE.07','Y',1), -- 레더 볼륨 미니파우치
  ('PRD_000233','MAT_000008','USAGE.07','Y',1), -- 레더 볼륨 파우치
  ('PRD_000259','MAT_000008','USAGE.07','Y',1), -- 레더 볼륨 필통
  ('PRD_000253','MAT_000008','USAGE.07','Y',1), -- 레더 삼각 미니파우치
  ('PRD_000237','MAT_000008','USAGE.07','Y',1), -- 레더 삼각 클러치
  ('PRD_000232','MAT_000008','USAGE.07','Y',1), -- 레더 삼각 파우치
  ('PRD_000258','MAT_000008','USAGE.07','Y',1), -- 레더 삼각 필통
  ('PRD_000235','MAT_000008','USAGE.07','Y',1), -- 레더 스트링 원형파우치
  ('PRD_000234','MAT_000008','USAGE.07','Y',1), -- 레더 스트링 파우치
  ('PRD_000252','MAT_000008','USAGE.07','Y',1), -- 레더 슬림 미니파우치
  ('PRD_000231','MAT_000008','USAGE.07','Y',1), -- 레더 슬림 파우치
  ('PRD_000257','MAT_000008','USAGE.07','Y',1), -- 레더 슬림 필통
  ('PRD_000238','MAT_000008','USAGE.07','Y',1), -- 레더 아이패드/노트북 파우치
  ('PRD_000255','MAT_000008','USAGE.07','Y',1), -- 레더 원형 미니파우치
  ('PRD_000260','MAT_000008','USAGE.07','Y',1), -- 레더 원형 필통
  ('PRD_000251','MAT_000008','USAGE.07','Y',1), -- 레더 플랫 미니파우치
  ('PRD_000236','MAT_000008','USAGE.07','Y',1), -- 레더 플랫 클러치
  ('PRD_000230','MAT_000008','USAGE.07','Y',1), -- 레더 플랫 파우치
  ('PRD_000256','MAT_000008','USAGE.07','Y',1), -- 레더 플랫 필통
  ('PRD_000264','MAT_000008','USAGE.07','Y',1), -- 레더숄더백
  ('PRD_000196','MAT_000008','USAGE.07','Y',1), -- 레더여권케이스
  ('PRD_000188','MAT_000008','USAGE.07','Y',1), -- 레더코스터
  ('PRD_000263','MAT_000008','USAGE.07','Y',1), -- 레더토트백
  -- GPM-1 캔버스 .05 MAT_000185 (9)
  ('PRD_000240','MAT_000185','USAGE.07','Y',1), -- 캔버스 삼각 파우치
  ('PRD_000262','MAT_000185','USAGE.07','Y',1), -- 캔버스 삼각 필통
  ('PRD_000272','MAT_000185','USAGE.07','Y',1), -- 캔버스 포켓숄더백
  ('PRD_000269','MAT_000185','USAGE.07','Y',1), -- 캔버스 포켓심플백
  ('PRD_000239','MAT_000185','USAGE.07','Y',1), -- 캔버스 플랫 파우치
  ('PRD_000261','MAT_000185','USAGE.07','Y',1), -- 캔버스 플랫 필통
  ('PRD_000271','MAT_000185','USAGE.07','Y',1), -- 캔버스숄더백
  ('PRD_000268','MAT_000185','USAGE.07','Y',1), -- 캔버스심플백
  ('PRD_000270','MAT_000185','USAGE.07','Y',1), -- 캔버스에코백
  -- GPM-1 린넨 .05 MAT_000184 (5)
  ('PRD_000265','MAT_000184','USAGE.07','Y',1), -- 린넨 미니에코백
  ('PRD_000243','MAT_000184','USAGE.07','Y',1), -- 린넨 스트링 파우치
  ('PRD_000267','MAT_000184','USAGE.07','Y',1), -- 린넨 에코백
  ('PRD_000266','MAT_000184','USAGE.07','Y',1), -- 린넨 토트백
  ('PRD_000191','MAT_000184','USAGE.07','Y',1), -- 린넨패브릭코스터
  -- GPM-1 메쉬 .05 MAT_000183 (4)
  ('PRD_000279','MAT_000183','USAGE.07','Y',1), -- 메쉬 에코백
  ('PRD_000278','MAT_000183','USAGE.07','Y',1), -- 메쉬 토트백
  ('PRD_000250','MAT_000183','USAGE.07','Y',1), -- 메쉬볼륨파우치
  ('PRD_000249','MAT_000183','USAGE.07','Y',1)  -- 메쉬슬림파우치
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;

-- ---- 검증 쿼리 (DRY-RUN 로그용) --------------------------------------
-- 적재 후 본체 소재 link 수 (기대 41)
SELECT '본체소재link(.05/.06)' AS chk, count(*) AS n
FROM t_prd_product_materials pm
JOIN t_mat_materials m ON m.mat_cd=pm.mat_cd
WHERE m.mat_typ_cd IN ('MAT_TYPE.05','MAT_TYPE.06')
  AND pm.prd_cd IN ('PRD_000254','PRD_000233','PRD_000259','PRD_000253','PRD_000237',
   'PRD_000232','PRD_000258','PRD_000235','PRD_000234','PRD_000252','PRD_000231',
   'PRD_000257','PRD_000238','PRD_000255','PRD_000260','PRD_000251','PRD_000236',
   'PRD_000230','PRD_000256','PRD_000264','PRD_000196','PRD_000188','PRD_000263',
   'PRD_000240','PRD_000262','PRD_000272','PRD_000269','PRD_000239','PRD_000261',
   'PRD_000271','PRD_000268','PRD_000270','PRD_000265','PRD_000243','PRD_000267',
   'PRD_000266','PRD_000191','PRD_000279','PRD_000278','PRD_000250','PRD_000249');

-- FK 고아 0 검증 (mat/usage/prd 참조)
SELECT 'FK고아' AS chk, count(*) AS n FROM t_prd_product_materials pm
WHERE NOT EXISTS(SELECT 1 FROM t_mat_materials m WHERE m.mat_cd=pm.mat_cd)
   OR NOT EXISTS(SELECT 1 FROM t_cod_base_codes c WHERE c.cod_cd=pm.usage_cd)
   OR NOT EXISTS(SELECT 1 FROM t_prd_products p WHERE p.prd_cd=pm.prd_cd);

-- [HARD] 실 적용 시 ROLLBACK→COMMIT 으로 교체. 본 DRY-RUN은 ROLLBACK.
ROLLBACK;

-- =====================================================================
-- undo (만약 실 COMMIT 후 되돌릴 때 · 인간 승인):
--   DELETE FROM t_prd_product_materials
--    WHERE usage_cd='USAGE.07' AND mat_cd IN ('MAT_000008','MAT_000183','MAT_000184','MAT_000185')
--      AND prd_cd IN (<위 41 prd_cd>);
--   (본체소재 link만 정확히 제거 — 기존 .09/.08 link는 무영향)
-- =====================================================================
