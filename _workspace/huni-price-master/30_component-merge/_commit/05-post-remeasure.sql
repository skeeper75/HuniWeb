-- ============================================================
-- 05  사후 재실측 (COMMIT 후 실행 · READ-ONLY 조회)
--   목적: 병합 무손상 확인 — ① 정본 행수 ② 멤버 tombstone ③ 재배선 정합
--         ④ FK 고아 0 ⑤ 혼재 0 ⑥ 골든 등가(백업 대비 unit_price 0오차)
--   ★골든 "재계산 0오차"의 엔진레벨 확정은 webadmin 시뮬레이터(06 체크리스트)에서.
--     여기 SQL 은 행수준 등가(값 verbatim 보존)를 결정론 실측.
-- ============================================================
\pset footer off

-- ① 정본 9종 존재·use_yn=Y·단가행수 (기대 28/36/4/10/4/8/2/2/468)
SELECT '① 정본 현황' info, c.comp_cd, c.use_yn, c.prc_typ_cd,
       (SELECT COUNT(*) FROM t_prc_component_prices p WHERE p.comp_cd=c.comp_cd) price_rows
FROM t_prc_price_components c
WHERE c.comp_cd IN ('COMP_PCB','COMP_NAMECARD_PREMIUM','COMP_NAMECARD_FOIL','COMP_NAMECARD_WHITE',
  'COMP_NAMECARD_STD','COMP_NAMECARD_COAT','COMP_NAMECARD_PEARL','COMP_NAMECARD_SHAPE','COMP_NAMECARD_MINISHAPE')
ORDER BY c.comp_cd;

-- ② 멤버 26종 tombstone(use_yn=N·del_yn=Y) + 잔존 단가행 0 (명함), PCB 고아3=중복본 물리보존·S1_20P=0
SELECT '② 멤버 tombstone' info, comp_cd, use_yn, del_yn,
       (SELECT COUNT(*) FROM t_prc_component_prices p WHERE p.comp_cd=m.comp_cd) resid_price_rows
FROM t_prc_price_components m
WHERE comp_cd IN (
 'COMP_NAMECARD_PREMIUM_S1_MGA','COMP_NAMECARD_PREMIUM_S1_MGB','COMP_NAMECARD_PREMIUM_S2_MGA','COMP_NAMECARD_PREMIUM_S2_MGB',
 'COMP_NAMECARD_FOIL_S1_STD','COMP_NAMECARD_FOIL_S1_HOLO','COMP_NAMECARD_FOIL_S2_STD','COMP_NAMECARD_FOIL_S2_HOLO',
 'COMP_NAMECARD_WHITE_S1W_CL','COMP_NAMECARD_WHITE_S1W_NOCL','COMP_NAMECARD_WHITE_S2W_CL','COMP_NAMECARD_WHITE_S2W_NOCL',
 'COMP_NAMECARD_STD_S1','COMP_NAMECARD_STD_S2','COMP_NAMECARD_COAT_S1','COMP_NAMECARD_COAT_S2',
 'COMP_NAMECARD_PEARL_S1','COMP_NAMECARD_PEARL_S2','COMP_NAMECARD_SHAPE_S1','COMP_NAMECARD_SHAPE_S2',
 'COMP_NAMECARD_MINISHAPE_S1','COMP_NAMECARD_MINISHAPE_S2',
 'COMP_PCB_S1_20P','COMP_PCB_S1_30P','COMP_PCB_S2_20P','COMP_PCB_S2_30P')
ORDER BY comp_cd;

-- ③ 12 PRF 재배선: 정본 seq1 + bystander. 멤버 잔존 배선 0.
SELECT '③ 공식별 배선(정본seq1)' info, frm_cd, string_agg(comp_cd||':'||disp_seq, ', ' ORDER BY disp_seq) wiring
FROM t_prc_formula_components
WHERE frm_cd IN ('PRF_PCB_FIXED','PRF_NAMECARD_PREMIUM','PRF_NAMECARD_PREMIUM_FOIL','PRF_NAMECARD_FOIL',
 'PRF_NAMECARD_WHITE','PRF_NAMECARD_FIXED','PRF_NAMECARD_FIXED_FOIL','PRF_NAMECARD_COAT',
 'PRF_NAMECARD_PEARL','PRF_NAMECARD_PEARL_FOIL','PRF_NAMECARD_SHAPE','PRF_NAMECARD_MINISHAPE')
GROUP BY frm_cd ORDER BY frm_cd;

SELECT '③ 멤버 잔존배선(0기대)' gate, COUNT(*) member_fc_refs
FROM t_prc_formula_components WHERE comp_cd IN (
 'COMP_NAMECARD_PREMIUM_S1_MGA','COMP_NAMECARD_PREMIUM_S1_MGB','COMP_NAMECARD_PREMIUM_S2_MGA','COMP_NAMECARD_PREMIUM_S2_MGB',
 'COMP_NAMECARD_FOIL_S1_STD','COMP_NAMECARD_FOIL_S1_HOLO','COMP_NAMECARD_FOIL_S2_STD','COMP_NAMECARD_FOIL_S2_HOLO',
 'COMP_NAMECARD_WHITE_S1W_CL','COMP_NAMECARD_WHITE_S1W_NOCL','COMP_NAMECARD_WHITE_S2W_CL','COMP_NAMECARD_WHITE_S2W_NOCL',
 'COMP_NAMECARD_STD_S1','COMP_NAMECARD_STD_S2','COMP_NAMECARD_COAT_S1','COMP_NAMECARD_COAT_S2',
 'COMP_NAMECARD_PEARL_S1','COMP_NAMECARD_PEARL_S2','COMP_NAMECARD_SHAPE_S1','COMP_NAMECARD_SHAPE_S2',
 'COMP_NAMECARD_MINISHAPE_S1','COMP_NAMECARD_MINISHAPE_S2',
 'COMP_PCB_S1_20P','COMP_PCB_S1_30P','COMP_PCB_S2_20P','COMP_PCB_S2_30P');

-- ④ FK 고아 0: formula_components.comp_cd 전부 price_components 실재 (12 PRF 범위)
SELECT '④ FK 고아 comp(0기대)' gate, COUNT(*) orphans
FROM t_prc_formula_components fc
LEFT JOIN t_prc_price_components pc ON fc.comp_cd=pc.comp_cd
WHERE fc.frm_cd IN ('PRF_PCB_FIXED','PRF_NAMECARD_PREMIUM','PRF_NAMECARD_PREMIUM_FOIL','PRF_NAMECARD_FOIL',
 'PRF_NAMECARD_WHITE','PRF_NAMECARD_FIXED','PRF_NAMECARD_FIXED_FOIL','PRF_NAMECARD_COAT',
 'PRF_NAMECARD_PEARL','PRF_NAMECARD_PEARL_FOIL','PRF_NAMECARD_SHAPE','PRF_NAMECARD_MINISHAPE')
  AND pc.comp_cd IS NULL;

-- ⑤ 혼재 0: 정본과 멤버가 동시에 단가행 보유하는 군 (0기대)
SELECT '⑤ 정본/멤버 단가행 혼재(0기대)' gate,
  SUM(CASE WHEN canon_rows>0 AND member_rows>0 THEN 1 ELSE 0 END) mixed_groups
FROM (
  SELECT 'STD' g,
    (SELECT COUNT(*) FROM t_prc_component_prices WHERE comp_cd='COMP_NAMECARD_STD') canon_rows,
    (SELECT COUNT(*) FROM t_prc_component_prices WHERE comp_cd IN ('COMP_NAMECARD_STD_S1','COMP_NAMECARD_STD_S2')) member_rows
  UNION ALL SELECT 'PCB',
    (SELECT COUNT(*) FROM t_prc_component_prices WHERE comp_cd='COMP_PCB'),
    (SELECT COUNT(*) FROM t_prc_component_prices WHERE comp_cd='COMP_PCB_S1_20P')
) x;

-- ⑥ 골든 등가(행수준·백업 대비 unit_price 0오차) — 01-backup 보유 시.
--    병합은 comp_cd 만 재지정·unit_price 불변이어야 함. 변동 1건이라도 나오면 결함.
SELECT '⑥ unit_price 변동(0기대·백업필요)' gate, COUNT(*) changed
FROM t_prc_component_prices p
JOIN z_bak_mcmerge_component_prices b ON p.comp_price_id=b.comp_price_id
WHERE p.unit_price <> b.unit_price;

-- ⑥b 골든 대표 좌표 unit_price (매니페스트 verbatim 대조용·정본 아래 존재 확인)
SELECT '⑥b 골든샘플 STD단면q100' info, unit_price
FROM t_prc_component_prices
WHERE comp_cd='COMP_NAMECARD_STD' AND mat_cd='MAT_000074' AND min_qty=100
  AND print_opt_cd IN (SELECT print_opt_cd FROM t_prc_component_prices WHERE comp_cd='COMP_NAMECARD_STD' AND mat_cd='MAT_000074' AND min_qty=100 ORDER BY print_opt_cd LIMIT 1)
LIMIT 1;  -- 기대 3500(단면) — 매니페스트 골든
