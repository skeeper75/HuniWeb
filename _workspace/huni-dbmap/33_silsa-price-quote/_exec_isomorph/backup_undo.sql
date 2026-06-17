-- ============================================================================
-- 실사(포스터/사인) 동형 가격구성요소 결합 — round-23
-- 생성기: gen_load_sql.py (손편집 금지·재현성 R3/G8)
-- 권위: silsa-isomorph-merge-design.md (byte-identical 단가매트릭스 재입증)
-- 작업: UPDATE 19행 (formula_components 배선 6 · price_components use_yn=N 6 · comp_nm/note 7)
-- INSERT 0 · DELETE 0 · component_prices(단가행) 무변경
-- 한글 소재명 = 라이브 frm_nm/prd_nm 대조 확정(Q-IM1):
--   캔버스패브릭포스터/레더아트프린트/메쉬프린트/타이벡프린트 (그룹A)
--   아트프린트포스터/접착방수포스터/아트패브릭포스터/방수포스터 (그룹B)
--   단독: 아트페이퍼포스터·메쉬현수막·접착투명포스터·린넨패브릭포스터·일반현수막
--   ※ 설계 약식명(아트지무광/메쉬배너/투명점착PVC/일반배너)은 라이브 정식명으로 정정
-- 멱등: 모든 UPDATE는 목표값/조건 가드 → 2회차 0행 변경
-- ============================================================================

-- backup_undo.sql — 결합 되돌리기 (적용 후 undo용)
-- (1) 현재값 백업 SELECT — 적용 직전 실행해 결과를 보관
\echo '--- BACKUP: formula_components 배선 (적용 직전 값) ---'
SELECT frm_cd, comp_cd, disp_seq FROM t_prc_formula_components WHERE frm_cd IN ('PRF_POSTER_LEATHER_AP','PRF_POSTER_MESH','PRF_POSTER_TYVEK','PRF_POSTER_ADH_WP','PRF_POSTER_ARTFABRIC','PRF_POSTER_WATERPROOF') AND disp_seq=1 ORDER BY frm_cd;
\echo '--- BACKUP: price_components comp_nm/note/use_yn ---'
SELECT comp_cd, comp_nm, note, use_yn FROM t_prc_price_components WHERE comp_cd IN ('COMP_POSTER_LEATHER_ARTPRINT','COMP_POSTER_MESH_PRINT','COMP_POSTER_TYVEK_PRINT','COMP_POSTER_ADH_WATERPROOF_PVC','COMP_POSTER_ARTFABRIC_GRAPHIC','COMP_POSTER_WATERPROOF_PET','COMP_POSTER_CANVAS_FABRIC','COMP_POSTER_ARTPRINT_PHOTO','COMP_POSTER_ARTPAPER_MATTE','COMP_POSTER_BANNER_MESH','COMP_POSTER_ADH_CLEAR_PVC','COMP_POSTER_LINEN_FABRIC','COMP_POSTER_BANNER_NORMAL') ORDER BY comp_cd;

-- (2) UNDO UPDATE — 결합을 원복 (배선 레거시 복귀 · use_yn=Y · comp_nm/note 원본 복귀)
-- ※ comp_nm/note 원본은 위 BACKUP 값으로 채워 실행. 아래는 배선·use_yn 원복(결정적).
\set ON_ERROR_STOP on
BEGIN;
-- 배선 원복: 정본 → 레거시 (각 PRF disp_seq=1)
UPDATE t_prc_formula_components SET comp_cd='COMP_POSTER_LEATHER_ARTPRINT' WHERE frm_cd='PRF_POSTER_LEATHER_AP' AND comp_cd='COMP_POSTER_CANVAS_FABRIC' AND disp_seq=1;
UPDATE t_prc_formula_components SET comp_cd='COMP_POSTER_MESH_PRINT' WHERE frm_cd='PRF_POSTER_MESH' AND comp_cd='COMP_POSTER_CANVAS_FABRIC' AND disp_seq=1;
UPDATE t_prc_formula_components SET comp_cd='COMP_POSTER_TYVEK_PRINT' WHERE frm_cd='PRF_POSTER_TYVEK' AND comp_cd='COMP_POSTER_CANVAS_FABRIC' AND disp_seq=1;
UPDATE t_prc_formula_components SET comp_cd='COMP_POSTER_ADH_WATERPROOF_PVC' WHERE frm_cd='PRF_POSTER_ADH_WP' AND comp_cd='COMP_POSTER_ARTPRINT_PHOTO' AND disp_seq=1;
UPDATE t_prc_formula_components SET comp_cd='COMP_POSTER_ARTFABRIC_GRAPHIC' WHERE frm_cd='PRF_POSTER_ARTFABRIC' AND comp_cd='COMP_POSTER_ARTPRINT_PHOTO' AND disp_seq=1;
UPDATE t_prc_formula_components SET comp_cd='COMP_POSTER_WATERPROOF_PET' WHERE frm_cd='PRF_POSTER_WATERPROOF' AND comp_cd='COMP_POSTER_ARTPRINT_PHOTO' AND disp_seq=1;
-- 레거시 6 use_yn 복귀 Y
UPDATE t_prc_price_components SET use_yn='Y' WHERE comp_cd='COMP_POSTER_LEATHER_ARTPRINT';
UPDATE t_prc_price_components SET use_yn='Y' WHERE comp_cd='COMP_POSTER_MESH_PRINT';
UPDATE t_prc_price_components SET use_yn='Y' WHERE comp_cd='COMP_POSTER_TYVEK_PRINT';
UPDATE t_prc_price_components SET use_yn='Y' WHERE comp_cd='COMP_POSTER_ADH_WATERPROOF_PVC';
UPDATE t_prc_price_components SET use_yn='Y' WHERE comp_cd='COMP_POSTER_ARTFABRIC_GRAPHIC';
UPDATE t_prc_price_components SET use_yn='Y' WHERE comp_cd='COMP_POSTER_WATERPROOF_PET';
-- comp_nm/note 원본 복귀: 적용 직전 BACKUP 값으로 채워 실행 (아래 placeholder)
--   UPDATE t_prc_price_components SET comp_nm=<백업값>, note=<백업값> WHERE comp_cd=<comp>;
ROLLBACK;  -- undo도 기본 ROLLBACK. 실 원복은 COMMIT으로 (인간 승인)
