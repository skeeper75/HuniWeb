-- ============================================================
-- WIRE 통합 배선 — step 03: 명함 033 MATGROUP 대표가 복제 (t_prc_component_prices)
-- 권위 = phase-c-wire-remediation §2 (Phase A GO·명함포토카드 B01 헤더 동일가 묶음 명시).
-- mat_cd 귀속 라이브 실측 확정(§2-1·round-13 불요): 074=백모조220·081=아트250·082=아트300·091=스노우250·092=스노우300.
-- 동일가 묶음: 3,500군=074/081/091(STD S1 3500·S2 4500) · 3,800군=082/092(STD S1 3800·S2 4800).
--
-- [HARD·돈-크리티컬] unit_price 절대 불변 — 새 값 생성 0. 기존 074/082 행을 verbatim 복제(값 동일).
-- 복제 = 동일가 묶음이라 새 가격 안 만듦. 단가값은 SELECT로 원본에서 그대로 가져옴(하드코딩 0).
--
-- 멱등 = 변형 C (INSERT … WHERE NOT EXISTS). 이유: t_prc_component_prices PK=comp_price_id(IDENTITY
--        BY DEFAULT)·자연키 UNIQUE 없음 → ON CONFLICT 타겟 불가. comp_cd+mat_cd+min_qty 매칭으로 가드.
-- comp_price_id = omit (IDENTITY 자동채번). 전 차원 컬럼은 원본 행에서 verbatim 복제(siz/clr/coat/bdl/proc/opt 등).
-- 라이브 실측(2026-06-15): 081/091/092 STD 단가행 0행(복제 대상 확정).
-- ============================================================

-- 3,500군: STD 074(S1=3500·S2=4500) 단가행 → 081(아트250)·091(스노우250) verbatim 복제
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, proc_cd, opt_cd)
SELECT cp.comp_cd, cp.apply_ymd, cp.siz_cd, cp.clr_cd, v.tgt_mat, cp.coat_side_cnt, cp.bdl_qty, cp.min_qty,
       cp.unit_price,           -- ★ 값 verbatim (하드코딩 0)
       cp.note, cp.proc_cd, cp.opt_cd
FROM t_prc_component_prices cp
CROSS JOIN (VALUES ('MAT_000081'),('MAT_000091')) AS v(tgt_mat)
WHERE cp.comp_cd IN ('COMP_NAMECARD_STD_S1','COMP_NAMECARD_STD_S2')
  AND cp.mat_cd = 'MAT_000074'   -- 3,500군 대표 원본
  AND NOT EXISTS (
    SELECT 1 FROM t_prc_component_prices x
    WHERE x.comp_cd = cp.comp_cd
      AND x.mat_cd  = v.tgt_mat
      AND x.min_qty IS NOT DISTINCT FROM cp.min_qty
      AND x.siz_cd  IS NOT DISTINCT FROM cp.siz_cd
  );

-- 3,800군: STD 082(S1=3800·S2=4800) 단가행 → 092(스노우300) verbatim 복제
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, proc_cd, opt_cd)
SELECT cp.comp_cd, cp.apply_ymd, cp.siz_cd, cp.clr_cd, 'MAT_000092', cp.coat_side_cnt, cp.bdl_qty, cp.min_qty,
       cp.unit_price,           -- ★ 값 verbatim (하드코딩 0)
       cp.note, cp.proc_cd, cp.opt_cd
FROM t_prc_component_prices cp
WHERE cp.comp_cd IN ('COMP_NAMECARD_STD_S1','COMP_NAMECARD_STD_S2')
  AND cp.mat_cd = 'MAT_000082'   -- 3,800군 대표 원본
  AND NOT EXISTS (
    SELECT 1 FROM t_prc_component_prices x
    WHERE x.comp_cd = cp.comp_cd
      AND x.mat_cd  = 'MAT_000092'
      AND x.min_qty IS NOT DISTINCT FROM cp.min_qty
      AND x.siz_cd  IS NOT DISTINCT FROM cp.siz_cd
  );
