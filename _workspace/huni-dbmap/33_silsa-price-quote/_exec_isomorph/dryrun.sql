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
-- dryrun.sql — 롤백전용 라이브 DRY-RUN (COMMIT 0 실증)
-- 적용 전후 검증 ①배선 정본 ②레거시 use_yn=N ③comp_nm 갱신 ④골든 재현 ⑤고아/동시매칭 0 ⑥2-pass 멱등
\set ON_ERROR_STOP on
\echo '=== [BEFORE] formula_components 배선 (레거시 PRF disp_seq=1) ==='
SELECT frm_cd, comp_cd FROM t_prc_formula_components WHERE frm_cd IN ('PRF_POSTER_LEATHER_AP','PRF_POSTER_MESH','PRF_POSTER_TYVEK','PRF_POSTER_ADH_WP','PRF_POSTER_ARTFABRIC','PRF_POSTER_WATERPROOF') AND disp_seq=1 ORDER BY frm_cd;
\echo '=== [BEFORE] 레거시 6 use_yn ==='
SELECT comp_cd, use_yn FROM t_prc_price_components WHERE comp_cd IN ('COMP_POSTER_LEATHER_ARTPRINT','COMP_POSTER_MESH_PRINT','COMP_POSTER_TYVEK_PRINT','COMP_POSTER_ADH_WATERPROOF_PVC','COMP_POSTER_ARTFABRIC_GRAPHIC','COMP_POSTER_WATERPROOF_PET') ORDER BY comp_cd;
\echo '=== [BEFORE] 골든: 레거시 각 소재 600x1800 단가 (결합 전 기준값) ==='
SELECT comp_cd, unit_price FROM t_prc_component_prices WHERE comp_cd IN ('COMP_POSTER_LEATHER_ARTPRINT','COMP_POSTER_MESH_PRINT','COMP_POSTER_TYVEK_PRINT','COMP_POSTER_ADH_WATERPROOF_PVC','COMP_POSTER_ARTFABRIC_GRAPHIC','COMP_POSTER_WATERPROOF_PET') AND siz_width=600 AND siz_height=1800 ORDER BY comp_cd;

BEGIN;
\echo '=== [APPLY 1차] ==='
-- STEP 1: formula_components 배선 재지정 — 그룹 A (3건)
-- PRF_POSTER_LEATHER_AP: disp_seq=1 본체 COMP_POSTER_LEATHER_ARTPRINT → COMP_POSTER_CANVAS_FABRIC (소재: 레더아트프린트)
UPDATE t_prc_formula_components fc
   SET comp_cd = 'COMP_POSTER_CANVAS_FABRIC'
 WHERE fc.frm_cd = 'PRF_POSTER_LEATHER_AP'
   AND fc.comp_cd = 'COMP_POSTER_LEATHER_ARTPRINT'
   AND fc.disp_seq = 1
   AND NOT EXISTS (SELECT 1 FROM t_prc_formula_components x
                    WHERE x.frm_cd = 'PRF_POSTER_LEATHER_AP' AND x.comp_cd = 'COMP_POSTER_CANVAS_FABRIC');

-- PRF_POSTER_MESH: disp_seq=1 본체 COMP_POSTER_MESH_PRINT → COMP_POSTER_CANVAS_FABRIC (소재: 메쉬프린트)
UPDATE t_prc_formula_components fc
   SET comp_cd = 'COMP_POSTER_CANVAS_FABRIC'
 WHERE fc.frm_cd = 'PRF_POSTER_MESH'
   AND fc.comp_cd = 'COMP_POSTER_MESH_PRINT'
   AND fc.disp_seq = 1
   AND NOT EXISTS (SELECT 1 FROM t_prc_formula_components x
                    WHERE x.frm_cd = 'PRF_POSTER_MESH' AND x.comp_cd = 'COMP_POSTER_CANVAS_FABRIC');

-- PRF_POSTER_TYVEK: disp_seq=1 본체 COMP_POSTER_TYVEK_PRINT → COMP_POSTER_CANVAS_FABRIC (소재: 타이벡프린트)
UPDATE t_prc_formula_components fc
   SET comp_cd = 'COMP_POSTER_CANVAS_FABRIC'
 WHERE fc.frm_cd = 'PRF_POSTER_TYVEK'
   AND fc.comp_cd = 'COMP_POSTER_TYVEK_PRINT'
   AND fc.disp_seq = 1
   AND NOT EXISTS (SELECT 1 FROM t_prc_formula_components x
                    WHERE x.frm_cd = 'PRF_POSTER_TYVEK' AND x.comp_cd = 'COMP_POSTER_CANVAS_FABRIC');

-- STEP 2: formula_components 배선 재지정 — 그룹 B (3건)
-- PRF_POSTER_ADH_WP: disp_seq=1 본체 COMP_POSTER_ADH_WATERPROOF_PVC → COMP_POSTER_ARTPRINT_PHOTO (소재: 접착방수포스터)
UPDATE t_prc_formula_components fc
   SET comp_cd = 'COMP_POSTER_ARTPRINT_PHOTO'
 WHERE fc.frm_cd = 'PRF_POSTER_ADH_WP'
   AND fc.comp_cd = 'COMP_POSTER_ADH_WATERPROOF_PVC'
   AND fc.disp_seq = 1
   AND NOT EXISTS (SELECT 1 FROM t_prc_formula_components x
                    WHERE x.frm_cd = 'PRF_POSTER_ADH_WP' AND x.comp_cd = 'COMP_POSTER_ARTPRINT_PHOTO');

-- PRF_POSTER_ARTFABRIC: disp_seq=1 본체 COMP_POSTER_ARTFABRIC_GRAPHIC → COMP_POSTER_ARTPRINT_PHOTO (소재: 아트패브릭포스터)
UPDATE t_prc_formula_components fc
   SET comp_cd = 'COMP_POSTER_ARTPRINT_PHOTO'
 WHERE fc.frm_cd = 'PRF_POSTER_ARTFABRIC'
   AND fc.comp_cd = 'COMP_POSTER_ARTFABRIC_GRAPHIC'
   AND fc.disp_seq = 1
   AND NOT EXISTS (SELECT 1 FROM t_prc_formula_components x
                    WHERE x.frm_cd = 'PRF_POSTER_ARTFABRIC' AND x.comp_cd = 'COMP_POSTER_ARTPRINT_PHOTO');

-- PRF_POSTER_WATERPROOF: disp_seq=1 본체 COMP_POSTER_WATERPROOF_PET → COMP_POSTER_ARTPRINT_PHOTO (소재: 방수포스터)
UPDATE t_prc_formula_components fc
   SET comp_cd = 'COMP_POSTER_ARTPRINT_PHOTO'
 WHERE fc.frm_cd = 'PRF_POSTER_WATERPROOF'
   AND fc.comp_cd = 'COMP_POSTER_WATERPROOF_PET'
   AND fc.disp_seq = 1
   AND NOT EXISTS (SELECT 1 FROM t_prc_formula_components x
                    WHERE x.frm_cd = 'PRF_POSTER_WATERPROOF' AND x.comp_cd = 'COMP_POSTER_ARTPRINT_PHOTO');

-- STEP 3: price_components use_yn='N' — 레거시 6 comp
-- 그룹 A 레거시:
UPDATE t_prc_price_components
   SET use_yn = 'N'
 WHERE comp_cd = 'COMP_POSTER_LEATHER_ARTPRINT' AND use_yn IS DISTINCT FROM 'N';

UPDATE t_prc_price_components
   SET use_yn = 'N'
 WHERE comp_cd = 'COMP_POSTER_MESH_PRINT' AND use_yn IS DISTINCT FROM 'N';

UPDATE t_prc_price_components
   SET use_yn = 'N'
 WHERE comp_cd = 'COMP_POSTER_TYVEK_PRINT' AND use_yn IS DISTINCT FROM 'N';

-- 그룹 B 레거시:
UPDATE t_prc_price_components
   SET use_yn = 'N'
 WHERE comp_cd = 'COMP_POSTER_ADH_WATERPROOF_PVC' AND use_yn IS DISTINCT FROM 'N';

UPDATE t_prc_price_components
   SET use_yn = 'N'
 WHERE comp_cd = 'COMP_POSTER_ARTFABRIC_GRAPHIC' AND use_yn IS DISTINCT FROM 'N';

UPDATE t_prc_price_components
   SET use_yn = 'N'
 WHERE comp_cd = 'COMP_POSTER_WATERPROOF_PET' AND use_yn IS DISTINCT FROM 'N';

-- STEP 4: price_components comp_nm/note — 정본 2 comp
UPDATE t_prc_price_components
   SET comp_nm = '실사 완제품가 (캔버스패브릭포스터·레더아트프린트·메쉬프린트·타이벡프린트)', note = '[동형결합] 가격표 동일 4소재 통합 · 결합소재: 캔버스패브릭포스터, 레더아트프린트, 메쉬프린트, 타이벡프린트 · 가격축: 가로×세로 구간(52셀) · 골든 600×1800=37,800원 · 정본 COMP_POSTER_CANVAS_FABRIC(레거시 3종 LEATHER_ARTPRINT/MESH_PRINT/TYVEK_PRINT use_yn=N)'
 WHERE comp_cd = 'COMP_POSTER_CANVAS_FABRIC'
   AND (comp_nm IS DISTINCT FROM '실사 완제품가 (캔버스패브릭포스터·레더아트프린트·메쉬프린트·타이벡프린트)' OR note IS DISTINCT FROM '[동형결합] 가격표 동일 4소재 통합 · 결합소재: 캔버스패브릭포스터, 레더아트프린트, 메쉬프린트, 타이벡프린트 · 가격축: 가로×세로 구간(52셀) · 골든 600×1800=37,800원 · 정본 COMP_POSTER_CANVAS_FABRIC(레거시 3종 LEATHER_ARTPRINT/MESH_PRINT/TYVEK_PRINT use_yn=N)');

UPDATE t_prc_price_components
   SET comp_nm = '실사 완제품가 (아트프린트포스터·접착방수포스터·아트패브릭포스터·방수포스터)', note = '[동형결합] 가격표 동일 4소재 통합 · 결합소재: 아트프린트포스터, 접착방수포스터, 아트패브릭포스터, 방수포스터 · 가격축: 가로×세로 구간(52셀) · 골든 600×1800=21,600원 · 정본 COMP_POSTER_ARTPRINT_PHOTO(레거시 3종 ADH_WATERPROOF_PVC/ARTFABRIC_GRAPHIC/WATERPROOF_PET use_yn=N) · PRF_POSTER_FIXED 범용배선 보유(정본이라 무변경 보존)'
 WHERE comp_cd = 'COMP_POSTER_ARTPRINT_PHOTO'
   AND (comp_nm IS DISTINCT FROM '실사 완제품가 (아트프린트포스터·접착방수포스터·아트패브릭포스터·방수포스터)' OR note IS DISTINCT FROM '[동형결합] 가격표 동일 4소재 통합 · 결합소재: 아트프린트포스터, 접착방수포스터, 아트패브릭포스터, 방수포스터 · 가격축: 가로×세로 구간(52셀) · 골든 600×1800=21,600원 · 정본 COMP_POSTER_ARTPRINT_PHOTO(레거시 3종 ADH_WATERPROOF_PVC/ARTFABRIC_GRAPHIC/WATERPROOF_PET use_yn=N) · PRF_POSTER_FIXED 범용배선 보유(정본이라 무변경 보존)');

-- STEP 5: price_components comp_nm/note — 단독 5 comp (결합 0·정비만)
-- 단독: 아트페이퍼포스터
UPDATE t_prc_price_components
   SET comp_nm = '실사 완제품가 (아트페이퍼포스터)', note = '[단독] 동형 없음 · 가격축: 가로×세로 구간(39셀)'
 WHERE comp_cd = 'COMP_POSTER_ARTPAPER_MATTE'
   AND (comp_nm IS DISTINCT FROM '실사 완제품가 (아트페이퍼포스터)' OR note IS DISTINCT FROM '[단독] 동형 없음 · 가격축: 가로×세로 구간(39셀)');

-- 단독: 메쉬현수막
UPDATE t_prc_price_components
   SET comp_nm = '실사 완제품가 (메쉬현수막)', note = '[단독] 동형 없음 · 가격축: 가로×세로 구간(46셀)'
 WHERE comp_cd = 'COMP_POSTER_BANNER_MESH'
   AND (comp_nm IS DISTINCT FROM '실사 완제품가 (메쉬현수막)' OR note IS DISTINCT FROM '[단독] 동형 없음 · 가격축: 가로×세로 구간(46셀)');

-- 단독: 접착투명포스터
UPDATE t_prc_price_components
   SET comp_nm = '실사 완제품가 (접착투명포스터)', note = '[단독] 동형 없음 · 가격축: 가로×세로 구간(52셀) · 골든 600×1800=59,400원'
 WHERE comp_cd = 'COMP_POSTER_ADH_CLEAR_PVC'
   AND (comp_nm IS DISTINCT FROM '실사 완제품가 (접착투명포스터)' OR note IS DISTINCT FROM '[단독] 동형 없음 · 가격축: 가로×세로 구간(52셀) · 골든 600×1800=59,400원');

-- 단독: 린넨패브릭포스터
UPDATE t_prc_price_components
   SET comp_nm = '실사 완제품가 (린넨패브릭포스터)', note = '[단독] 동형 없음 · 가격축: 가로×세로 구간(52셀) · 골든 600×1800=32,400원'
 WHERE comp_cd = 'COMP_POSTER_LINEN_FABRIC'
   AND (comp_nm IS DISTINCT FROM '실사 완제품가 (린넨패브릭포스터)' OR note IS DISTINCT FROM '[단독] 동형 없음 · 가격축: 가로×세로 구간(52셀) · 골든 600×1800=32,400원');

-- 단독: 일반현수막
UPDATE t_prc_price_components
   SET comp_nm = '실사 완제품가 (일반현수막)', note = '[단독] 동형 없음 · 가격축: 가로×세로 구간(79셀)'
 WHERE comp_cd = 'COMP_POSTER_BANNER_NORMAL'
   AND (comp_nm IS DISTINCT FROM '실사 완제품가 (일반현수막)' OR note IS DISTINCT FROM '[단독] 동형 없음 · 가격축: 가로×세로 구간(79셀)');

\echo '=== [AFTER] formula_components 배선 → 정본 가리킴 확인 ==='
SELECT frm_cd, comp_cd FROM t_prc_formula_components WHERE frm_cd IN ('PRF_POSTER_LEATHER_AP','PRF_POSTER_MESH','PRF_POSTER_TYVEK','PRF_POSTER_ADH_WP','PRF_POSTER_ARTFABRIC','PRF_POSTER_WATERPROOF') AND disp_seq=1 ORDER BY frm_cd;
\echo '=== [AFTER] 레거시 6 use_yn=N · 정본2/단독5 use_yn=Y 확인 ==='
SELECT comp_cd, use_yn FROM t_prc_price_components WHERE comp_cd IN ('COMP_POSTER_LEATHER_ARTPRINT','COMP_POSTER_MESH_PRINT','COMP_POSTER_TYVEK_PRINT','COMP_POSTER_ADH_WATERPROOF_PVC','COMP_POSTER_ARTFABRIC_GRAPHIC','COMP_POSTER_WATERPROOF_PET','COMP_POSTER_CANVAS_FABRIC','COMP_POSTER_ARTPRINT_PHOTO','COMP_POSTER_ARTPAPER_MATTE','COMP_POSTER_BANNER_MESH','COMP_POSTER_ADH_CLEAR_PVC','COMP_POSTER_LINEN_FABRIC','COMP_POSTER_BANNER_NORMAL') ORDER BY use_yn, comp_cd;
\echo '=== [AFTER] 정본2 + 단독5 comp_nm/note 갱신 확인 ==='
SELECT comp_cd, comp_nm, note FROM t_prc_price_components WHERE comp_cd IN ('COMP_POSTER_CANVAS_FABRIC','COMP_POSTER_ARTPRINT_PHOTO','COMP_POSTER_ARTPAPER_MATTE','COMP_POSTER_BANNER_MESH','COMP_POSTER_ADH_CLEAR_PVC','COMP_POSTER_LINEN_FABRIC','COMP_POSTER_BANNER_NORMAL') ORDER BY comp_cd;
\echo '=== [GOLDEN] 정본 단가표 600x1800 = 결합 전 레거시 단가와 동일해야 (셀 diff 0 근거) ==='
SELECT 'COMP_POSTER_CANVAS_FABRIC' AS canonical, unit_price FROM t_prc_component_prices WHERE comp_cd='COMP_POSTER_CANVAS_FABRIC' AND siz_width=600 AND siz_height=1800
UNION ALL SELECT 'COMP_POSTER_ARTPRINT_PHOTO', unit_price FROM t_prc_component_prices WHERE comp_cd='COMP_POSTER_ARTPRINT_PHOTO' AND siz_width=600 AND siz_height=1800;
-- 기대: CANVAS_FABRIC=37800 (레거시 LEATHER/MESH/TYVEK 동일) · ARTPRINT_PHOTO=21600 (레거시 ADH_WP/ARTFABRIC/WATERPROOF 동일)
\echo '=== [고아 0] 재지정 후 모든 대상 PRF disp_seq=1 본체가 use_yn=Y comp 가리킴 ==='
SELECT fc.frm_cd, fc.comp_cd, pc.use_yn FROM t_prc_formula_components fc
  JOIN t_prc_price_components pc ON pc.comp_cd=fc.comp_cd
  WHERE fc.frm_cd IN ('PRF_POSTER_LEATHER_AP','PRF_POSTER_MESH','PRF_POSTER_TYVEK','PRF_POSTER_ADH_WP','PRF_POSTER_ARTFABRIC','PRF_POSTER_WATERPROOF','PRF_POSTER_CANVAS','PRF_POSTER_ARTPRINT','PRF_POSTER_FIXED') AND fc.disp_seq=1 AND pc.use_yn<>'Y' ;
-- 기대: 0행 (고아 없음)
\echo '=== [중복 배선 0] 한 PRF에 disp_seq=1 본체 2건 안 생김 ==='
SELECT frm_cd, count(*) FROM t_prc_formula_components WHERE frm_cd IN ('PRF_POSTER_LEATHER_AP','PRF_POSTER_MESH','PRF_POSTER_TYVEK','PRF_POSTER_ADH_WP','PRF_POSTER_ARTFABRIC','PRF_POSTER_WATERPROOF') AND disp_seq=1 GROUP BY frm_cd HAVING count(*)<>1;
-- 기대: 0행
\echo '=== [동시매칭 0] 정본 comp 단가표 한 좌표 1행 ==='
SELECT comp_cd, siz_width, siz_height, min_qty, count(*) FROM t_prc_component_prices WHERE comp_cd IN ('COMP_POSTER_CANVAS_FABRIC','COMP_POSTER_ARTPRINT_PHOTO') GROUP BY comp_cd,siz_width,siz_height,min_qty HAVING count(*)>1;
-- 기대: 0행
\echo '=== [단가행 보존] component_prices 무변경 — 13 comp 행수 (변동 없어야) ==='
SELECT count(*) AS rows_13comp FROM t_prc_component_prices WHERE comp_cd IN ('COMP_POSTER_LEATHER_ARTPRINT','COMP_POSTER_MESH_PRINT','COMP_POSTER_TYVEK_PRINT','COMP_POSTER_ADH_WATERPROOF_PVC','COMP_POSTER_ARTFABRIC_GRAPHIC','COMP_POSTER_WATERPROOF_PET','COMP_POSTER_CANVAS_FABRIC','COMP_POSTER_ARTPRINT_PHOTO','COMP_POSTER_ARTPAPER_MATTE','COMP_POSTER_BANNER_MESH','COMP_POSTER_ADH_CLEAR_PVC','COMP_POSTER_LINEN_FABRIC','COMP_POSTER_BANNER_NORMAL');

\echo '=== [APPLY 2차] 멱등 — delta 0이어야 (UPDATE 0 rows) ==='
-- STEP 1: formula_components 배선 재지정 — 그룹 A (3건)
-- PRF_POSTER_LEATHER_AP: disp_seq=1 본체 COMP_POSTER_LEATHER_ARTPRINT → COMP_POSTER_CANVAS_FABRIC (소재: 레더아트프린트)
UPDATE t_prc_formula_components fc
   SET comp_cd = 'COMP_POSTER_CANVAS_FABRIC'
 WHERE fc.frm_cd = 'PRF_POSTER_LEATHER_AP'
   AND fc.comp_cd = 'COMP_POSTER_LEATHER_ARTPRINT'
   AND fc.disp_seq = 1
   AND NOT EXISTS (SELECT 1 FROM t_prc_formula_components x
                    WHERE x.frm_cd = 'PRF_POSTER_LEATHER_AP' AND x.comp_cd = 'COMP_POSTER_CANVAS_FABRIC');

-- PRF_POSTER_MESH: disp_seq=1 본체 COMP_POSTER_MESH_PRINT → COMP_POSTER_CANVAS_FABRIC (소재: 메쉬프린트)
UPDATE t_prc_formula_components fc
   SET comp_cd = 'COMP_POSTER_CANVAS_FABRIC'
 WHERE fc.frm_cd = 'PRF_POSTER_MESH'
   AND fc.comp_cd = 'COMP_POSTER_MESH_PRINT'
   AND fc.disp_seq = 1
   AND NOT EXISTS (SELECT 1 FROM t_prc_formula_components x
                    WHERE x.frm_cd = 'PRF_POSTER_MESH' AND x.comp_cd = 'COMP_POSTER_CANVAS_FABRIC');

-- PRF_POSTER_TYVEK: disp_seq=1 본체 COMP_POSTER_TYVEK_PRINT → COMP_POSTER_CANVAS_FABRIC (소재: 타이벡프린트)
UPDATE t_prc_formula_components fc
   SET comp_cd = 'COMP_POSTER_CANVAS_FABRIC'
 WHERE fc.frm_cd = 'PRF_POSTER_TYVEK'
   AND fc.comp_cd = 'COMP_POSTER_TYVEK_PRINT'
   AND fc.disp_seq = 1
   AND NOT EXISTS (SELECT 1 FROM t_prc_formula_components x
                    WHERE x.frm_cd = 'PRF_POSTER_TYVEK' AND x.comp_cd = 'COMP_POSTER_CANVAS_FABRIC');

-- STEP 2: formula_components 배선 재지정 — 그룹 B (3건)
-- PRF_POSTER_ADH_WP: disp_seq=1 본체 COMP_POSTER_ADH_WATERPROOF_PVC → COMP_POSTER_ARTPRINT_PHOTO (소재: 접착방수포스터)
UPDATE t_prc_formula_components fc
   SET comp_cd = 'COMP_POSTER_ARTPRINT_PHOTO'
 WHERE fc.frm_cd = 'PRF_POSTER_ADH_WP'
   AND fc.comp_cd = 'COMP_POSTER_ADH_WATERPROOF_PVC'
   AND fc.disp_seq = 1
   AND NOT EXISTS (SELECT 1 FROM t_prc_formula_components x
                    WHERE x.frm_cd = 'PRF_POSTER_ADH_WP' AND x.comp_cd = 'COMP_POSTER_ARTPRINT_PHOTO');

-- PRF_POSTER_ARTFABRIC: disp_seq=1 본체 COMP_POSTER_ARTFABRIC_GRAPHIC → COMP_POSTER_ARTPRINT_PHOTO (소재: 아트패브릭포스터)
UPDATE t_prc_formula_components fc
   SET comp_cd = 'COMP_POSTER_ARTPRINT_PHOTO'
 WHERE fc.frm_cd = 'PRF_POSTER_ARTFABRIC'
   AND fc.comp_cd = 'COMP_POSTER_ARTFABRIC_GRAPHIC'
   AND fc.disp_seq = 1
   AND NOT EXISTS (SELECT 1 FROM t_prc_formula_components x
                    WHERE x.frm_cd = 'PRF_POSTER_ARTFABRIC' AND x.comp_cd = 'COMP_POSTER_ARTPRINT_PHOTO');

-- PRF_POSTER_WATERPROOF: disp_seq=1 본체 COMP_POSTER_WATERPROOF_PET → COMP_POSTER_ARTPRINT_PHOTO (소재: 방수포스터)
UPDATE t_prc_formula_components fc
   SET comp_cd = 'COMP_POSTER_ARTPRINT_PHOTO'
 WHERE fc.frm_cd = 'PRF_POSTER_WATERPROOF'
   AND fc.comp_cd = 'COMP_POSTER_WATERPROOF_PET'
   AND fc.disp_seq = 1
   AND NOT EXISTS (SELECT 1 FROM t_prc_formula_components x
                    WHERE x.frm_cd = 'PRF_POSTER_WATERPROOF' AND x.comp_cd = 'COMP_POSTER_ARTPRINT_PHOTO');

-- STEP 3: price_components use_yn='N' — 레거시 6 comp
-- 그룹 A 레거시:
UPDATE t_prc_price_components
   SET use_yn = 'N'
 WHERE comp_cd = 'COMP_POSTER_LEATHER_ARTPRINT' AND use_yn IS DISTINCT FROM 'N';

UPDATE t_prc_price_components
   SET use_yn = 'N'
 WHERE comp_cd = 'COMP_POSTER_MESH_PRINT' AND use_yn IS DISTINCT FROM 'N';

UPDATE t_prc_price_components
   SET use_yn = 'N'
 WHERE comp_cd = 'COMP_POSTER_TYVEK_PRINT' AND use_yn IS DISTINCT FROM 'N';

-- 그룹 B 레거시:
UPDATE t_prc_price_components
   SET use_yn = 'N'
 WHERE comp_cd = 'COMP_POSTER_ADH_WATERPROOF_PVC' AND use_yn IS DISTINCT FROM 'N';

UPDATE t_prc_price_components
   SET use_yn = 'N'
 WHERE comp_cd = 'COMP_POSTER_ARTFABRIC_GRAPHIC' AND use_yn IS DISTINCT FROM 'N';

UPDATE t_prc_price_components
   SET use_yn = 'N'
 WHERE comp_cd = 'COMP_POSTER_WATERPROOF_PET' AND use_yn IS DISTINCT FROM 'N';

-- STEP 4: price_components comp_nm/note — 정본 2 comp
UPDATE t_prc_price_components
   SET comp_nm = '실사 완제품가 (캔버스패브릭포스터·레더아트프린트·메쉬프린트·타이벡프린트)', note = '[동형결합] 가격표 동일 4소재 통합 · 결합소재: 캔버스패브릭포스터, 레더아트프린트, 메쉬프린트, 타이벡프린트 · 가격축: 가로×세로 구간(52셀) · 골든 600×1800=37,800원 · 정본 COMP_POSTER_CANVAS_FABRIC(레거시 3종 LEATHER_ARTPRINT/MESH_PRINT/TYVEK_PRINT use_yn=N)'
 WHERE comp_cd = 'COMP_POSTER_CANVAS_FABRIC'
   AND (comp_nm IS DISTINCT FROM '실사 완제품가 (캔버스패브릭포스터·레더아트프린트·메쉬프린트·타이벡프린트)' OR note IS DISTINCT FROM '[동형결합] 가격표 동일 4소재 통합 · 결합소재: 캔버스패브릭포스터, 레더아트프린트, 메쉬프린트, 타이벡프린트 · 가격축: 가로×세로 구간(52셀) · 골든 600×1800=37,800원 · 정본 COMP_POSTER_CANVAS_FABRIC(레거시 3종 LEATHER_ARTPRINT/MESH_PRINT/TYVEK_PRINT use_yn=N)');

UPDATE t_prc_price_components
   SET comp_nm = '실사 완제품가 (아트프린트포스터·접착방수포스터·아트패브릭포스터·방수포스터)', note = '[동형결합] 가격표 동일 4소재 통합 · 결합소재: 아트프린트포스터, 접착방수포스터, 아트패브릭포스터, 방수포스터 · 가격축: 가로×세로 구간(52셀) · 골든 600×1800=21,600원 · 정본 COMP_POSTER_ARTPRINT_PHOTO(레거시 3종 ADH_WATERPROOF_PVC/ARTFABRIC_GRAPHIC/WATERPROOF_PET use_yn=N) · PRF_POSTER_FIXED 범용배선 보유(정본이라 무변경 보존)'
 WHERE comp_cd = 'COMP_POSTER_ARTPRINT_PHOTO'
   AND (comp_nm IS DISTINCT FROM '실사 완제품가 (아트프린트포스터·접착방수포스터·아트패브릭포스터·방수포스터)' OR note IS DISTINCT FROM '[동형결합] 가격표 동일 4소재 통합 · 결합소재: 아트프린트포스터, 접착방수포스터, 아트패브릭포스터, 방수포스터 · 가격축: 가로×세로 구간(52셀) · 골든 600×1800=21,600원 · 정본 COMP_POSTER_ARTPRINT_PHOTO(레거시 3종 ADH_WATERPROOF_PVC/ARTFABRIC_GRAPHIC/WATERPROOF_PET use_yn=N) · PRF_POSTER_FIXED 범용배선 보유(정본이라 무변경 보존)');

-- STEP 5: price_components comp_nm/note — 단독 5 comp (결합 0·정비만)
-- 단독: 아트페이퍼포스터
UPDATE t_prc_price_components
   SET comp_nm = '실사 완제품가 (아트페이퍼포스터)', note = '[단독] 동형 없음 · 가격축: 가로×세로 구간(39셀)'
 WHERE comp_cd = 'COMP_POSTER_ARTPAPER_MATTE'
   AND (comp_nm IS DISTINCT FROM '실사 완제품가 (아트페이퍼포스터)' OR note IS DISTINCT FROM '[단독] 동형 없음 · 가격축: 가로×세로 구간(39셀)');

-- 단독: 메쉬현수막
UPDATE t_prc_price_components
   SET comp_nm = '실사 완제품가 (메쉬현수막)', note = '[단독] 동형 없음 · 가격축: 가로×세로 구간(46셀)'
 WHERE comp_cd = 'COMP_POSTER_BANNER_MESH'
   AND (comp_nm IS DISTINCT FROM '실사 완제품가 (메쉬현수막)' OR note IS DISTINCT FROM '[단독] 동형 없음 · 가격축: 가로×세로 구간(46셀)');

-- 단독: 접착투명포스터
UPDATE t_prc_price_components
   SET comp_nm = '실사 완제품가 (접착투명포스터)', note = '[단독] 동형 없음 · 가격축: 가로×세로 구간(52셀) · 골든 600×1800=59,400원'
 WHERE comp_cd = 'COMP_POSTER_ADH_CLEAR_PVC'
   AND (comp_nm IS DISTINCT FROM '실사 완제품가 (접착투명포스터)' OR note IS DISTINCT FROM '[단독] 동형 없음 · 가격축: 가로×세로 구간(52셀) · 골든 600×1800=59,400원');

-- 단독: 린넨패브릭포스터
UPDATE t_prc_price_components
   SET comp_nm = '실사 완제품가 (린넨패브릭포스터)', note = '[단독] 동형 없음 · 가격축: 가로×세로 구간(52셀) · 골든 600×1800=32,400원'
 WHERE comp_cd = 'COMP_POSTER_LINEN_FABRIC'
   AND (comp_nm IS DISTINCT FROM '실사 완제품가 (린넨패브릭포스터)' OR note IS DISTINCT FROM '[단독] 동형 없음 · 가격축: 가로×세로 구간(52셀) · 골든 600×1800=32,400원');

-- 단독: 일반현수막
UPDATE t_prc_price_components
   SET comp_nm = '실사 완제품가 (일반현수막)', note = '[단독] 동형 없음 · 가격축: 가로×세로 구간(79셀)'
 WHERE comp_cd = 'COMP_POSTER_BANNER_NORMAL'
   AND (comp_nm IS DISTINCT FROM '실사 완제품가 (일반현수막)' OR note IS DISTINCT FROM '[단독] 동형 없음 · 가격축: 가로×세로 구간(79셀)');

-- 위 2차 UPDATE들의 출력이 모두 'UPDATE 0' 이면 멱등 PASS

ROLLBACK;
\echo '=== [POST-ROLLBACK] 라이브 원복 확인 — 배선 레거시 그대로 ==='
SELECT frm_cd, comp_cd FROM t_prc_formula_components WHERE frm_cd IN ('PRF_POSTER_LEATHER_AP','PRF_POSTER_MESH','PRF_POSTER_TYVEK','PRF_POSTER_ADH_WP','PRF_POSTER_ARTFABRIC','PRF_POSTER_WATERPROOF') AND disp_seq=1 ORDER BY frm_cd;
-- 기대: 레거시 comp_cd로 원복(COMMIT 0 실증)
