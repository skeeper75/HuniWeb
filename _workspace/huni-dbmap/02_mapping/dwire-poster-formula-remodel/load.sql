-- load.sql — D-WIRE 포스터/실사 가격공식 상품별 재모델 (per-product re-model)
-- 생성: dbm-mapping-designer (dbm-price-formula 스킬) · 2026-06-07
--
-- 라이브 railway DB에 대한 멱등 단일 트랜잭션. BEGIN/COMMIT 미포함 — apply.sh 가 모드별 주입(09_load/_exec 패턴).
-- 기본 = DRY-RUN(ROLLBACK). 실제 COMMIT 은 인간 승인 시에만. 본 하네스는 COMMIT 미호출.
--
-- 범위: t_prc_price_formulas(28 신규) + t_prc_formula_components(30 신규) + t_prd_product_price_formulas(재바인딩 28 DELETE+28 INSERT) + PRF_POSTER_FIXED 은퇴(use_yn='N').
-- component_prices 미적재(단가 본체 = Slice A/C3 별도 트랙). IDENTITY 시퀀스 무관(본 트랙 surrogate id 미생성).
--
-- 멱등성(R1): 전 INSERT 'WHERE NOT EXISTS' 가드. 재바인딩 DELETE 는 멱등(없으면 0행). 2-pass 행변경 0.
-- 원자성(R2): ON_ERROR_STOP=1 + 단일 tx → 임의 문 실패 시 전체 롤백.
-- reg_dt(NOT NULL DEFAULT now()): INSERT 컬럼목록에서 omit → DEFAULT 발화(round-5 '명시 NULL=DEFAULT 미발화' 함정 회피).
SET client_min_messages = warning;

-- ============================================================
-- [단계 0] FK 부모 선존재 검증 (read-only assert — 미충족 시 즉시 abort)
-- ============================================================
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM t_cod_base_codes WHERE cod_cd='FRM_TYPE.02') THEN
    RAISE EXCEPTION 'FK MISSING: FRM_TYPE.02 부재'; END IF;
  IF (SELECT count(*) FROM t_prd_products WHERE prd_cd BETWEEN 'PRD_000118' AND 'PRD_000145') <> 28 THEN
    RAISE EXCEPTION 'FK MISSING: 28 포스터 상품 일부 부재'; END IF;
END $$;


-- ============================================================
-- [단계 1] 공식 헤더 28 (FRM_TYPE.02 단순형). reg_dt=DEFAULT(omit)
-- ============================================================
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, frm_typ_cd, note, use_yn)
SELECT 'PRF_POSTER_ARTPRINT_PHOTO', '포스터/실사 상품별 완제품가 단순형 [아트프린트포스터]', 'FRM_TYPE.02', 'D-WIRE 재모델: PRD_000118 아트프린트포스터 전용 공식(PRF_POSTER_FIXED 분리)', 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_POSTER_ARTPRINT_PHOTO');
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, frm_typ_cd, note, use_yn)
SELECT 'PRF_POSTER_ARTPAPER_MATTE', '포스터/실사 상품별 완제품가 단순형 [아트페이퍼포스터]', 'FRM_TYPE.02', 'D-WIRE 재모델: PRD_000119 아트페이퍼포스터 전용 공식(PRF_POSTER_FIXED 분리)', 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_POSTER_ARTPAPER_MATTE');
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, frm_typ_cd, note, use_yn)
SELECT 'PRF_POSTER_WATERPROOF_PET', '포스터/실사 상품별 완제품가 단순형 [방수포스터]', 'FRM_TYPE.02', 'D-WIRE 재모델: PRD_000120 방수포스터 전용 공식(PRF_POSTER_FIXED 분리)', 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_POSTER_WATERPROOF_PET');
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, frm_typ_cd, note, use_yn)
SELECT 'PRF_POSTER_ADH_WATERPROOF_PVC', '포스터/실사 상품별 완제품가 단순형 [접착방수포스터]', 'FRM_TYPE.02', 'D-WIRE 재모델: PRD_000121 접착방수포스터 전용 공식(PRF_POSTER_FIXED 분리)', 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_POSTER_ADH_WATERPROOF_PVC');
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, frm_typ_cd, note, use_yn)
SELECT 'PRF_POSTER_ADH_CLEAR_PVC', '포스터/실사 상품별 완제품가 단순형 [접착투명포스터]', 'FRM_TYPE.02', 'D-WIRE 재모델: PRD_000122 접착투명포스터 전용 공식(PRF_POSTER_FIXED 분리)', 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_POSTER_ADH_CLEAR_PVC');
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, frm_typ_cd, note, use_yn)
SELECT 'PRF_POSTER_ARTFABRIC_GRAPHIC', '포스터/실사 상품별 완제품가 단순형 [아트패브릭포스터]', 'FRM_TYPE.02', 'D-WIRE 재모델: PRD_000123 아트패브릭포스터 전용 공식(PRF_POSTER_FIXED 분리)', 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_POSTER_ARTFABRIC_GRAPHIC');
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, frm_typ_cd, note, use_yn)
SELECT 'PRF_POSTER_LINEN_FABRIC', '포스터/실사 상품별 완제품가 단순형 [린넨패브릭포스터]', 'FRM_TYPE.02', 'D-WIRE 재모델: PRD_000124 린넨패브릭포스터 전용 공식(PRF_POSTER_FIXED 분리)', 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_POSTER_LINEN_FABRIC');
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, frm_typ_cd, note, use_yn)
SELECT 'PRF_POSTER_CANVAS_FABRIC', '포스터/실사 상품별 완제품가 단순형 [캔버스패브릭포스터]', 'FRM_TYPE.02', 'D-WIRE 재모델: PRD_000125 캔버스패브릭포스터 전용 공식(PRF_POSTER_FIXED 분리)', 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_POSTER_CANVAS_FABRIC');
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, frm_typ_cd, note, use_yn)
SELECT 'PRF_POSTER_LEATHER_ARTPRINT', '포스터/실사 상품별 완제품가 단순형 [레더아트프린트]', 'FRM_TYPE.02', 'D-WIRE 재모델: PRD_000126 레더아트프린트 전용 공식(PRF_POSTER_FIXED 분리)', 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_POSTER_LEATHER_ARTPRINT');
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, frm_typ_cd, note, use_yn)
SELECT 'PRF_POSTER_TYVEK_PRINT', '포스터/실사 상품별 완제품가 단순형 [타이벡프린트]', 'FRM_TYPE.02', 'D-WIRE 재모델: PRD_000127 타이벡프린트 전용 공식(PRF_POSTER_FIXED 분리)', 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_POSTER_TYVEK_PRINT');
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, frm_typ_cd, note, use_yn)
SELECT 'PRF_POSTER_MESH_PRINT', '포스터/실사 상품별 완제품가 단순형 [메쉬프린트]', 'FRM_TYPE.02', 'D-WIRE 재모델: PRD_000128 메쉬프린트 전용 공식(PRF_POSTER_FIXED 분리)', 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_POSTER_MESH_PRINT');
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, frm_typ_cd, note, use_yn)
SELECT 'PRF_POSTER_FOAMBOARD', '포스터/실사 상품별 완제품가 단순형 [폼보드]', 'FRM_TYPE.02', 'D-WIRE 재모델: PRD_000129 폼보드 전용 공식(PRF_POSTER_FIXED 분리)', 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_POSTER_FOAMBOARD');
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, frm_typ_cd, note, use_yn)
SELECT 'PRF_POSTER_FOMEXBOARD', '포스터/실사 상품별 완제품가 단순형 [포맥스보드]', 'FRM_TYPE.02', 'D-WIRE 재모델: PRD_000130 포맥스보드 전용 공식(PRF_POSTER_FIXED 분리)', 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_POSTER_FOMEXBOARD');
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, frm_typ_cd, note, use_yn)
SELECT 'PRF_POSTER_FRAMELESS_WOOD', '포스터/실사 상품별 완제품가 단순형 [프레임리스우드액자]', 'FRM_TYPE.02', 'D-WIRE 재모델: PRD_000131 프레임리스우드액자 전용 공식(PRF_POSTER_FIXED 분리)', 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_POSTER_FRAMELESS_WOOD');
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, frm_typ_cd, note, use_yn)
SELECT 'PRF_POSTER_LEATHER_FRAME', '포스터/실사 상품별 완제품가 단순형 [레더아트액자]', 'FRM_TYPE.02', 'D-WIRE 재모델: PRD_000132 레더아트액자 전용 공식(PRF_POSTER_FIXED 분리)', 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_POSTER_LEATHER_FRAME');
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, frm_typ_cd, note, use_yn)
SELECT 'PRF_POSTER_CANVAS_HANGING', '포스터/실사 상품별 완제품가 단순형 [캔버스 행잉포스터]', 'FRM_TYPE.02', 'D-WIRE 재모델: PRD_000133 캔버스 행잉포스터 전용 공식(PRF_POSTER_FIXED 분리)', 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_POSTER_CANVAS_HANGING');
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, frm_typ_cd, note, use_yn)
SELECT 'PRF_POSTER_LINEN_WOODBONG', '포스터/실사 상품별 완제품가 단순형 [린넨 우드봉 족자]', 'FRM_TYPE.02', 'D-WIRE 재모델: PRD_000134 린넨 우드봉 족자 전용 공식(PRF_POSTER_FIXED 분리)', 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_POSTER_LINEN_WOODBONG');
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, frm_typ_cd, note, use_yn)
SELECT 'PRF_POSTER_JOKJA', '포스터/실사 상품별 완제품가 단순형 [족자포스터]', 'FRM_TYPE.02', 'D-WIRE 재모델: PRD_000135 족자포스터 전용 공식(PRF_POSTER_FIXED 분리)', 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_POSTER_JOKJA');
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, frm_typ_cd, note, use_yn)
SELECT 'PRF_POSTER_PET_BANNER', '포스터/실사 상품별 완제품가 단순형 [PET배너]', 'FRM_TYPE.02', 'D-WIRE 재모델: PRD_000136 PET배너 전용 공식(PRF_POSTER_FIXED 분리)', 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_POSTER_PET_BANNER');
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, frm_typ_cd, note, use_yn)
SELECT 'PRF_POSTER_MESH_BANNER', '포스터/실사 상품별 완제품가 단순형 [메쉬배너]', 'FRM_TYPE.02', 'D-WIRE 재모델: PRD_000137 메쉬배너 전용 공식(PRF_POSTER_FIXED 분리)', 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_POSTER_MESH_BANNER');
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, frm_typ_cd, note, use_yn)
SELECT 'PRF_POSTER_BANNER_NORMAL', '포스터/실사 상품별 완제품가 단순형 [일반현수막]', 'FRM_TYPE.02', 'D-WIRE 재모델: PRD_000138 일반현수막 전용 공식(PRF_POSTER_FIXED 분리)', 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_POSTER_BANNER_NORMAL');
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, frm_typ_cd, note, use_yn)
SELECT 'PRF_POSTER_BANNER_MESH', '포스터/실사 상품별 완제품가 단순형 [메쉬현수막]', 'FRM_TYPE.02', 'D-WIRE 재모델: PRD_000139 메쉬현수막 전용 공식(PRF_POSTER_FIXED 분리)', 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_POSTER_BANNER_MESH');
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, frm_typ_cd, note, use_yn)
SELECT 'PRF_POSTER_SHEETCUT_MATTE', '포스터/실사 상품별 완제품가 단순형 [무광시트커팅]', 'FRM_TYPE.02', 'D-WIRE 재모델: PRD_000140 무광시트커팅 전용 공식(PRF_POSTER_FIXED 분리)', 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_POSTER_SHEETCUT_MATTE');
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, frm_typ_cd, note, use_yn)
SELECT 'PRF_POSTER_SHEETCUT_HOLO', '포스터/실사 상품별 완제품가 단순형 [홀로그램 시트커팅]', 'FRM_TYPE.02', 'D-WIRE 재모델: PRD_000141 홀로그램 시트커팅 전용 공식(PRF_POSTER_FIXED 분리)', 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_POSTER_SHEETCUT_HOLO');
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, frm_typ_cd, note, use_yn)
SELECT 'PRF_POSTER_ACRYLSTK_GLOSS', '포스터/실사 상품별 완제품가 단순형 [유광아크릴스티커]', 'FRM_TYPE.02', 'D-WIRE 재모델: PRD_000142 유광아크릴스티커 전용 공식(PRF_POSTER_FIXED 분리)', 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_POSTER_ACRYLSTK_GLOSS');
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, frm_typ_cd, note, use_yn)
SELECT 'PRF_POSTER_ACRYLSTK_MIRROR', '포스터/실사 상품별 완제품가 단순형 [미러아크릴스티커]', 'FRM_TYPE.02', 'D-WIRE 재모델: PRD_000143 미러아크릴스티커 전용 공식(PRF_POSTER_FIXED 분리)', 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_POSTER_ACRYLSTK_MIRROR');
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, frm_typ_cd, note, use_yn)
SELECT 'PRF_POSTER_MINI_STANDBOARD', '포스터/실사 상품별 완제품가 단순형 [미니보드스탠딩]', 'FRM_TYPE.02', 'D-WIRE 재모델: PRD_000144 미니보드스탠딩 전용 공식(PRF_POSTER_FIXED 분리)', 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_POSTER_MINI_STANDBOARD');
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, frm_typ_cd, note, use_yn)
SELECT 'PRF_POSTER_MINI_BANNER', '포스터/실사 상품별 완제품가 단순형 [미니배너]', 'FRM_TYPE.02', 'D-WIRE 재모델: PRD_000145 미니배너 전용 공식(PRF_POSTER_FIXED 분리)', 'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_POSTER_MINI_BANNER');

-- ============================================================
-- [단계 2] 공식↔구성요소 배선 30 (단일=disp1/Y, 변형=disp1·2/N 택일). comp FK 선존재 가드.
-- ============================================================
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
SELECT 'PRF_POSTER_ARTPRINT_PHOTO', 'COMP_POSTER_ARTPRINT_PHOTO', 1, 'Y'
WHERE EXISTS (SELECT 1 FROM t_prc_price_components WHERE comp_cd='COMP_POSTER_ARTPRINT_PHOTO')
  AND NOT EXISTS (SELECT 1 FROM t_prc_formula_components WHERE frm_cd='PRF_POSTER_ARTPRINT_PHOTO' AND comp_cd='COMP_POSTER_ARTPRINT_PHOTO');
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
SELECT 'PRF_POSTER_ARTPAPER_MATTE', 'COMP_POSTER_ARTPAPER_MATTE', 1, 'Y'
WHERE EXISTS (SELECT 1 FROM t_prc_price_components WHERE comp_cd='COMP_POSTER_ARTPAPER_MATTE')
  AND NOT EXISTS (SELECT 1 FROM t_prc_formula_components WHERE frm_cd='PRF_POSTER_ARTPAPER_MATTE' AND comp_cd='COMP_POSTER_ARTPAPER_MATTE');
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
SELECT 'PRF_POSTER_WATERPROOF_PET', 'COMP_POSTER_WATERPROOF_PET', 1, 'Y'
WHERE EXISTS (SELECT 1 FROM t_prc_price_components WHERE comp_cd='COMP_POSTER_WATERPROOF_PET')
  AND NOT EXISTS (SELECT 1 FROM t_prc_formula_components WHERE frm_cd='PRF_POSTER_WATERPROOF_PET' AND comp_cd='COMP_POSTER_WATERPROOF_PET');
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
SELECT 'PRF_POSTER_ADH_WATERPROOF_PVC', 'COMP_POSTER_ADH_WATERPROOF_PVC', 1, 'Y'
WHERE EXISTS (SELECT 1 FROM t_prc_price_components WHERE comp_cd='COMP_POSTER_ADH_WATERPROOF_PVC')
  AND NOT EXISTS (SELECT 1 FROM t_prc_formula_components WHERE frm_cd='PRF_POSTER_ADH_WATERPROOF_PVC' AND comp_cd='COMP_POSTER_ADH_WATERPROOF_PVC');
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
SELECT 'PRF_POSTER_ADH_CLEAR_PVC', 'COMP_POSTER_ADH_CLEAR_PVC', 1, 'Y'
WHERE EXISTS (SELECT 1 FROM t_prc_price_components WHERE comp_cd='COMP_POSTER_ADH_CLEAR_PVC')
  AND NOT EXISTS (SELECT 1 FROM t_prc_formula_components WHERE frm_cd='PRF_POSTER_ADH_CLEAR_PVC' AND comp_cd='COMP_POSTER_ADH_CLEAR_PVC');
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
SELECT 'PRF_POSTER_ARTFABRIC_GRAPHIC', 'COMP_POSTER_ARTFABRIC_GRAPHIC', 1, 'Y'
WHERE EXISTS (SELECT 1 FROM t_prc_price_components WHERE comp_cd='COMP_POSTER_ARTFABRIC_GRAPHIC')
  AND NOT EXISTS (SELECT 1 FROM t_prc_formula_components WHERE frm_cd='PRF_POSTER_ARTFABRIC_GRAPHIC' AND comp_cd='COMP_POSTER_ARTFABRIC_GRAPHIC');
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
SELECT 'PRF_POSTER_LINEN_FABRIC', 'COMP_POSTER_LINEN_FABRIC', 1, 'Y'
WHERE EXISTS (SELECT 1 FROM t_prc_price_components WHERE comp_cd='COMP_POSTER_LINEN_FABRIC')
  AND NOT EXISTS (SELECT 1 FROM t_prc_formula_components WHERE frm_cd='PRF_POSTER_LINEN_FABRIC' AND comp_cd='COMP_POSTER_LINEN_FABRIC');
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
SELECT 'PRF_POSTER_CANVAS_FABRIC', 'COMP_POSTER_CANVAS_FABRIC', 1, 'Y'
WHERE EXISTS (SELECT 1 FROM t_prc_price_components WHERE comp_cd='COMP_POSTER_CANVAS_FABRIC')
  AND NOT EXISTS (SELECT 1 FROM t_prc_formula_components WHERE frm_cd='PRF_POSTER_CANVAS_FABRIC' AND comp_cd='COMP_POSTER_CANVAS_FABRIC');
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
SELECT 'PRF_POSTER_LEATHER_ARTPRINT', 'COMP_POSTER_LEATHER_ARTPRINT', 1, 'Y'
WHERE EXISTS (SELECT 1 FROM t_prc_price_components WHERE comp_cd='COMP_POSTER_LEATHER_ARTPRINT')
  AND NOT EXISTS (SELECT 1 FROM t_prc_formula_components WHERE frm_cd='PRF_POSTER_LEATHER_ARTPRINT' AND comp_cd='COMP_POSTER_LEATHER_ARTPRINT');
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
SELECT 'PRF_POSTER_TYVEK_PRINT', 'COMP_POSTER_TYVEK_PRINT', 1, 'Y'
WHERE EXISTS (SELECT 1 FROM t_prc_price_components WHERE comp_cd='COMP_POSTER_TYVEK_PRINT')
  AND NOT EXISTS (SELECT 1 FROM t_prc_formula_components WHERE frm_cd='PRF_POSTER_TYVEK_PRINT' AND comp_cd='COMP_POSTER_TYVEK_PRINT');
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
SELECT 'PRF_POSTER_MESH_PRINT', 'COMP_POSTER_MESH_PRINT', 1, 'Y'
WHERE EXISTS (SELECT 1 FROM t_prc_price_components WHERE comp_cd='COMP_POSTER_MESH_PRINT')
  AND NOT EXISTS (SELECT 1 FROM t_prc_formula_components WHERE frm_cd='PRF_POSTER_MESH_PRINT' AND comp_cd='COMP_POSTER_MESH_PRINT');
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
SELECT 'PRF_POSTER_FOAMBOARD', 'COMP_POSTER_FOAMBOARD_WHITE', 1, 'N'
WHERE EXISTS (SELECT 1 FROM t_prc_price_components WHERE comp_cd='COMP_POSTER_FOAMBOARD_WHITE')
  AND NOT EXISTS (SELECT 1 FROM t_prc_formula_components WHERE frm_cd='PRF_POSTER_FOAMBOARD' AND comp_cd='COMP_POSTER_FOAMBOARD_WHITE');
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
SELECT 'PRF_POSTER_FOAMBOARD', 'COMP_POSTER_FOAMBOARD_BLACK', 2, 'N'
WHERE EXISTS (SELECT 1 FROM t_prc_price_components WHERE comp_cd='COMP_POSTER_FOAMBOARD_BLACK')
  AND NOT EXISTS (SELECT 1 FROM t_prc_formula_components WHERE frm_cd='PRF_POSTER_FOAMBOARD' AND comp_cd='COMP_POSTER_FOAMBOARD_BLACK');
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
SELECT 'PRF_POSTER_FOMEXBOARD', 'COMP_POSTER_FOMEXBOARD_WHITE3MM', 1, 'N'
WHERE EXISTS (SELECT 1 FROM t_prc_price_components WHERE comp_cd='COMP_POSTER_FOMEXBOARD_WHITE3MM')
  AND NOT EXISTS (SELECT 1 FROM t_prc_formula_components WHERE frm_cd='PRF_POSTER_FOMEXBOARD' AND comp_cd='COMP_POSTER_FOMEXBOARD_WHITE3MM');
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
SELECT 'PRF_POSTER_FOMEXBOARD', 'COMP_POSTER_FOMEXBOARD_WHITE5MM', 2, 'N'
WHERE EXISTS (SELECT 1 FROM t_prc_price_components WHERE comp_cd='COMP_POSTER_FOMEXBOARD_WHITE5MM')
  AND NOT EXISTS (SELECT 1 FROM t_prc_formula_components WHERE frm_cd='PRF_POSTER_FOMEXBOARD' AND comp_cd='COMP_POSTER_FOMEXBOARD_WHITE5MM');
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
SELECT 'PRF_POSTER_FRAMELESS_WOOD', 'COMP_POSTER_FRAMELESS_WOOD', 1, 'Y'
WHERE EXISTS (SELECT 1 FROM t_prc_price_components WHERE comp_cd='COMP_POSTER_FRAMELESS_WOOD')
  AND NOT EXISTS (SELECT 1 FROM t_prc_formula_components WHERE frm_cd='PRF_POSTER_FRAMELESS_WOOD' AND comp_cd='COMP_POSTER_FRAMELESS_WOOD');
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
SELECT 'PRF_POSTER_LEATHER_FRAME', 'COMP_POSTER_LEATHER_FRAME', 1, 'Y'
WHERE EXISTS (SELECT 1 FROM t_prc_price_components WHERE comp_cd='COMP_POSTER_LEATHER_FRAME')
  AND NOT EXISTS (SELECT 1 FROM t_prc_formula_components WHERE frm_cd='PRF_POSTER_LEATHER_FRAME' AND comp_cd='COMP_POSTER_LEATHER_FRAME');
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
SELECT 'PRF_POSTER_CANVAS_HANGING', 'COMP_POSTER_CANVAS_HANGING', 1, 'Y'
WHERE EXISTS (SELECT 1 FROM t_prc_price_components WHERE comp_cd='COMP_POSTER_CANVAS_HANGING')
  AND NOT EXISTS (SELECT 1 FROM t_prc_formula_components WHERE frm_cd='PRF_POSTER_CANVAS_HANGING' AND comp_cd='COMP_POSTER_CANVAS_HANGING');
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
SELECT 'PRF_POSTER_LINEN_WOODBONG', 'COMP_POSTER_LINEN_WOODBONG', 1, 'Y'
WHERE EXISTS (SELECT 1 FROM t_prc_price_components WHERE comp_cd='COMP_POSTER_LINEN_WOODBONG')
  AND NOT EXISTS (SELECT 1 FROM t_prc_formula_components WHERE frm_cd='PRF_POSTER_LINEN_WOODBONG' AND comp_cd='COMP_POSTER_LINEN_WOODBONG');
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
SELECT 'PRF_POSTER_JOKJA', 'COMP_POSTER_JOKJA', 1, 'Y'
WHERE EXISTS (SELECT 1 FROM t_prc_price_components WHERE comp_cd='COMP_POSTER_JOKJA')
  AND NOT EXISTS (SELECT 1 FROM t_prc_formula_components WHERE frm_cd='PRF_POSTER_JOKJA' AND comp_cd='COMP_POSTER_JOKJA');
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
SELECT 'PRF_POSTER_PET_BANNER', 'COMP_POSTER_PET_BANNER', 1, 'Y'
WHERE EXISTS (SELECT 1 FROM t_prc_price_components WHERE comp_cd='COMP_POSTER_PET_BANNER')
  AND NOT EXISTS (SELECT 1 FROM t_prc_formula_components WHERE frm_cd='PRF_POSTER_PET_BANNER' AND comp_cd='COMP_POSTER_PET_BANNER');
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
SELECT 'PRF_POSTER_MESH_BANNER', 'COMP_POSTER_MESH_BANNER', 1, 'Y'
WHERE EXISTS (SELECT 1 FROM t_prc_price_components WHERE comp_cd='COMP_POSTER_MESH_BANNER')
  AND NOT EXISTS (SELECT 1 FROM t_prc_formula_components WHERE frm_cd='PRF_POSTER_MESH_BANNER' AND comp_cd='COMP_POSTER_MESH_BANNER');
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
SELECT 'PRF_POSTER_BANNER_NORMAL', 'COMP_POSTER_BANNER_NORMAL', 1, 'Y'
WHERE EXISTS (SELECT 1 FROM t_prc_price_components WHERE comp_cd='COMP_POSTER_BANNER_NORMAL')
  AND NOT EXISTS (SELECT 1 FROM t_prc_formula_components WHERE frm_cd='PRF_POSTER_BANNER_NORMAL' AND comp_cd='COMP_POSTER_BANNER_NORMAL');
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
SELECT 'PRF_POSTER_BANNER_MESH', 'COMP_POSTER_BANNER_MESH', 1, 'Y'
WHERE EXISTS (SELECT 1 FROM t_prc_price_components WHERE comp_cd='COMP_POSTER_BANNER_MESH')
  AND NOT EXISTS (SELECT 1 FROM t_prc_formula_components WHERE frm_cd='PRF_POSTER_BANNER_MESH' AND comp_cd='COMP_POSTER_BANNER_MESH');
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
SELECT 'PRF_POSTER_SHEETCUT_MATTE', 'COMP_POSTER_SHEETCUT_MATTE', 1, 'Y'
WHERE EXISTS (SELECT 1 FROM t_prc_price_components WHERE comp_cd='COMP_POSTER_SHEETCUT_MATTE')
  AND NOT EXISTS (SELECT 1 FROM t_prc_formula_components WHERE frm_cd='PRF_POSTER_SHEETCUT_MATTE' AND comp_cd='COMP_POSTER_SHEETCUT_MATTE');
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
SELECT 'PRF_POSTER_SHEETCUT_HOLO', 'COMP_POSTER_SHEETCUT_HOLO', 1, 'Y'
WHERE EXISTS (SELECT 1 FROM t_prc_price_components WHERE comp_cd='COMP_POSTER_SHEETCUT_HOLO')
  AND NOT EXISTS (SELECT 1 FROM t_prc_formula_components WHERE frm_cd='PRF_POSTER_SHEETCUT_HOLO' AND comp_cd='COMP_POSTER_SHEETCUT_HOLO');
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
SELECT 'PRF_POSTER_ACRYLSTK_GLOSS', 'COMP_POSTER_ACRYLSTK_GLOSS', 1, 'Y'
WHERE EXISTS (SELECT 1 FROM t_prc_price_components WHERE comp_cd='COMP_POSTER_ACRYLSTK_GLOSS')
  AND NOT EXISTS (SELECT 1 FROM t_prc_formula_components WHERE frm_cd='PRF_POSTER_ACRYLSTK_GLOSS' AND comp_cd='COMP_POSTER_ACRYLSTK_GLOSS');
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
SELECT 'PRF_POSTER_ACRYLSTK_MIRROR', 'COMP_POSTER_ACRYLSTK_MIRROR', 1, 'Y'
WHERE EXISTS (SELECT 1 FROM t_prc_price_components WHERE comp_cd='COMP_POSTER_ACRYLSTK_MIRROR')
  AND NOT EXISTS (SELECT 1 FROM t_prc_formula_components WHERE frm_cd='PRF_POSTER_ACRYLSTK_MIRROR' AND comp_cd='COMP_POSTER_ACRYLSTK_MIRROR');
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
SELECT 'PRF_POSTER_MINI_STANDBOARD', 'COMP_POSTER_MINI_STANDBOARD', 1, 'Y'
WHERE EXISTS (SELECT 1 FROM t_prc_price_components WHERE comp_cd='COMP_POSTER_MINI_STANDBOARD')
  AND NOT EXISTS (SELECT 1 FROM t_prc_formula_components WHERE frm_cd='PRF_POSTER_MINI_STANDBOARD' AND comp_cd='COMP_POSTER_MINI_STANDBOARD');
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
SELECT 'PRF_POSTER_MINI_BANNER', 'COMP_POSTER_MINI_BANNER', 1, 'Y'
WHERE EXISTS (SELECT 1 FROM t_prc_price_components WHERE comp_cd='COMP_POSTER_MINI_BANNER')
  AND NOT EXISTS (SELECT 1 FROM t_prc_formula_components WHERE frm_cd='PRF_POSTER_MINI_BANNER' AND comp_cd='COMP_POSTER_MINI_BANNER');

-- ============================================================
-- [단계 3] 상품 재바인딩 — DELETE (prd, PRF_POSTER_FIXED) 28 + INSERT (prd, PRF_POSTER_<X>) 28
-- FK 안전: 단계1 공식 헤더 선존재 후 INSERT. DELETE 는 멱등(없으면 0행).
-- ============================================================
DELETE FROM t_prd_product_price_formulas
WHERE frm_cd='PRF_POSTER_FIXED' AND prd_cd IN ('PRD_000118','PRD_000119','PRD_000120','PRD_000121','PRD_000122','PRD_000123','PRD_000124','PRD_000125','PRD_000126','PRD_000127','PRD_000128','PRD_000129','PRD_000130','PRD_000131','PRD_000132','PRD_000133','PRD_000134','PRD_000135','PRD_000136','PRD_000137','PRD_000138','PRD_000139','PRD_000140','PRD_000141','PRD_000142','PRD_000143','PRD_000144','PRD_000145');
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
SELECT 'PRD_000118', 'PRF_POSTER_ARTPRINT_PHOTO', '2026-06-01', 'D-WIRE 재바인딩: PRF_POSTER_FIXED→PRF_POSTER_ARTPRINT_PHOTO (아트프린트포스터)'
WHERE EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_POSTER_ARTPRINT_PHOTO')
  AND NOT EXISTS (SELECT 1 FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000118' AND frm_cd='PRF_POSTER_ARTPRINT_PHOTO');
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
SELECT 'PRD_000119', 'PRF_POSTER_ARTPAPER_MATTE', '2026-06-01', 'D-WIRE 재바인딩: PRF_POSTER_FIXED→PRF_POSTER_ARTPAPER_MATTE (아트페이퍼포스터)'
WHERE EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_POSTER_ARTPAPER_MATTE')
  AND NOT EXISTS (SELECT 1 FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000119' AND frm_cd='PRF_POSTER_ARTPAPER_MATTE');
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
SELECT 'PRD_000120', 'PRF_POSTER_WATERPROOF_PET', '2026-06-01', 'D-WIRE 재바인딩: PRF_POSTER_FIXED→PRF_POSTER_WATERPROOF_PET (방수포스터)'
WHERE EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_POSTER_WATERPROOF_PET')
  AND NOT EXISTS (SELECT 1 FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000120' AND frm_cd='PRF_POSTER_WATERPROOF_PET');
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
SELECT 'PRD_000121', 'PRF_POSTER_ADH_WATERPROOF_PVC', '2026-06-01', 'D-WIRE 재바인딩: PRF_POSTER_FIXED→PRF_POSTER_ADH_WATERPROOF_PVC (접착방수포스터)'
WHERE EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_POSTER_ADH_WATERPROOF_PVC')
  AND NOT EXISTS (SELECT 1 FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000121' AND frm_cd='PRF_POSTER_ADH_WATERPROOF_PVC');
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
SELECT 'PRD_000122', 'PRF_POSTER_ADH_CLEAR_PVC', '2026-06-01', 'D-WIRE 재바인딩: PRF_POSTER_FIXED→PRF_POSTER_ADH_CLEAR_PVC (접착투명포스터)'
WHERE EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_POSTER_ADH_CLEAR_PVC')
  AND NOT EXISTS (SELECT 1 FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000122' AND frm_cd='PRF_POSTER_ADH_CLEAR_PVC');
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
SELECT 'PRD_000123', 'PRF_POSTER_ARTFABRIC_GRAPHIC', '2026-06-01', 'D-WIRE 재바인딩: PRF_POSTER_FIXED→PRF_POSTER_ARTFABRIC_GRAPHIC (아트패브릭포스터)'
WHERE EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_POSTER_ARTFABRIC_GRAPHIC')
  AND NOT EXISTS (SELECT 1 FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000123' AND frm_cd='PRF_POSTER_ARTFABRIC_GRAPHIC');
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
SELECT 'PRD_000124', 'PRF_POSTER_LINEN_FABRIC', '2026-06-01', 'D-WIRE 재바인딩: PRF_POSTER_FIXED→PRF_POSTER_LINEN_FABRIC (린넨패브릭포스터)'
WHERE EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_POSTER_LINEN_FABRIC')
  AND NOT EXISTS (SELECT 1 FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000124' AND frm_cd='PRF_POSTER_LINEN_FABRIC');
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
SELECT 'PRD_000125', 'PRF_POSTER_CANVAS_FABRIC', '2026-06-01', 'D-WIRE 재바인딩: PRF_POSTER_FIXED→PRF_POSTER_CANVAS_FABRIC (캔버스패브릭포스터)'
WHERE EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_POSTER_CANVAS_FABRIC')
  AND NOT EXISTS (SELECT 1 FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000125' AND frm_cd='PRF_POSTER_CANVAS_FABRIC');
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
SELECT 'PRD_000126', 'PRF_POSTER_LEATHER_ARTPRINT', '2026-06-01', 'D-WIRE 재바인딩: PRF_POSTER_FIXED→PRF_POSTER_LEATHER_ARTPRINT (레더아트프린트)'
WHERE EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_POSTER_LEATHER_ARTPRINT')
  AND NOT EXISTS (SELECT 1 FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000126' AND frm_cd='PRF_POSTER_LEATHER_ARTPRINT');
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
SELECT 'PRD_000127', 'PRF_POSTER_TYVEK_PRINT', '2026-06-01', 'D-WIRE 재바인딩: PRF_POSTER_FIXED→PRF_POSTER_TYVEK_PRINT (타이벡프린트)'
WHERE EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_POSTER_TYVEK_PRINT')
  AND NOT EXISTS (SELECT 1 FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000127' AND frm_cd='PRF_POSTER_TYVEK_PRINT');
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
SELECT 'PRD_000128', 'PRF_POSTER_MESH_PRINT', '2026-06-01', 'D-WIRE 재바인딩: PRF_POSTER_FIXED→PRF_POSTER_MESH_PRINT (메쉬프린트)'
WHERE EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_POSTER_MESH_PRINT')
  AND NOT EXISTS (SELECT 1 FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000128' AND frm_cd='PRF_POSTER_MESH_PRINT');
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
SELECT 'PRD_000129', 'PRF_POSTER_FOAMBOARD', '2026-06-01', 'D-WIRE 재바인딩: PRF_POSTER_FIXED→PRF_POSTER_FOAMBOARD (폼보드)'
WHERE EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_POSTER_FOAMBOARD')
  AND NOT EXISTS (SELECT 1 FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000129' AND frm_cd='PRF_POSTER_FOAMBOARD');
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
SELECT 'PRD_000130', 'PRF_POSTER_FOMEXBOARD', '2026-06-01', 'D-WIRE 재바인딩: PRF_POSTER_FIXED→PRF_POSTER_FOMEXBOARD (포맥스보드)'
WHERE EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_POSTER_FOMEXBOARD')
  AND NOT EXISTS (SELECT 1 FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000130' AND frm_cd='PRF_POSTER_FOMEXBOARD');
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
SELECT 'PRD_000131', 'PRF_POSTER_FRAMELESS_WOOD', '2026-06-01', 'D-WIRE 재바인딩: PRF_POSTER_FIXED→PRF_POSTER_FRAMELESS_WOOD (프레임리스우드액자)'
WHERE EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_POSTER_FRAMELESS_WOOD')
  AND NOT EXISTS (SELECT 1 FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000131' AND frm_cd='PRF_POSTER_FRAMELESS_WOOD');
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
SELECT 'PRD_000132', 'PRF_POSTER_LEATHER_FRAME', '2026-06-01', 'D-WIRE 재바인딩: PRF_POSTER_FIXED→PRF_POSTER_LEATHER_FRAME (레더아트액자)'
WHERE EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_POSTER_LEATHER_FRAME')
  AND NOT EXISTS (SELECT 1 FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000132' AND frm_cd='PRF_POSTER_LEATHER_FRAME');
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
SELECT 'PRD_000133', 'PRF_POSTER_CANVAS_HANGING', '2026-06-01', 'D-WIRE 재바인딩: PRF_POSTER_FIXED→PRF_POSTER_CANVAS_HANGING (캔버스 행잉포스터)'
WHERE EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_POSTER_CANVAS_HANGING')
  AND NOT EXISTS (SELECT 1 FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000133' AND frm_cd='PRF_POSTER_CANVAS_HANGING');
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
SELECT 'PRD_000134', 'PRF_POSTER_LINEN_WOODBONG', '2026-06-01', 'D-WIRE 재바인딩: PRF_POSTER_FIXED→PRF_POSTER_LINEN_WOODBONG (린넨 우드봉 족자)'
WHERE EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_POSTER_LINEN_WOODBONG')
  AND NOT EXISTS (SELECT 1 FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000134' AND frm_cd='PRF_POSTER_LINEN_WOODBONG');
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
SELECT 'PRD_000135', 'PRF_POSTER_JOKJA', '2026-06-01', 'D-WIRE 재바인딩: PRF_POSTER_FIXED→PRF_POSTER_JOKJA (족자포스터)'
WHERE EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_POSTER_JOKJA')
  AND NOT EXISTS (SELECT 1 FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000135' AND frm_cd='PRF_POSTER_JOKJA');
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
SELECT 'PRD_000136', 'PRF_POSTER_PET_BANNER', '2026-06-01', 'D-WIRE 재바인딩: PRF_POSTER_FIXED→PRF_POSTER_PET_BANNER (PET배너)'
WHERE EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_POSTER_PET_BANNER')
  AND NOT EXISTS (SELECT 1 FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000136' AND frm_cd='PRF_POSTER_PET_BANNER');
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
SELECT 'PRD_000137', 'PRF_POSTER_MESH_BANNER', '2026-06-01', 'D-WIRE 재바인딩: PRF_POSTER_FIXED→PRF_POSTER_MESH_BANNER (메쉬배너)'
WHERE EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_POSTER_MESH_BANNER')
  AND NOT EXISTS (SELECT 1 FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000137' AND frm_cd='PRF_POSTER_MESH_BANNER');
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
SELECT 'PRD_000138', 'PRF_POSTER_BANNER_NORMAL', '2026-06-01', 'D-WIRE 재바인딩: PRF_POSTER_FIXED→PRF_POSTER_BANNER_NORMAL (일반현수막)'
WHERE EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_POSTER_BANNER_NORMAL')
  AND NOT EXISTS (SELECT 1 FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000138' AND frm_cd='PRF_POSTER_BANNER_NORMAL');
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
SELECT 'PRD_000139', 'PRF_POSTER_BANNER_MESH', '2026-06-01', 'D-WIRE 재바인딩: PRF_POSTER_FIXED→PRF_POSTER_BANNER_MESH (메쉬현수막)'
WHERE EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_POSTER_BANNER_MESH')
  AND NOT EXISTS (SELECT 1 FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000139' AND frm_cd='PRF_POSTER_BANNER_MESH');
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
SELECT 'PRD_000140', 'PRF_POSTER_SHEETCUT_MATTE', '2026-06-01', 'D-WIRE 재바인딩: PRF_POSTER_FIXED→PRF_POSTER_SHEETCUT_MATTE (무광시트커팅)'
WHERE EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_POSTER_SHEETCUT_MATTE')
  AND NOT EXISTS (SELECT 1 FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000140' AND frm_cd='PRF_POSTER_SHEETCUT_MATTE');
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
SELECT 'PRD_000141', 'PRF_POSTER_SHEETCUT_HOLO', '2026-06-01', 'D-WIRE 재바인딩: PRF_POSTER_FIXED→PRF_POSTER_SHEETCUT_HOLO (홀로그램 시트커팅)'
WHERE EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_POSTER_SHEETCUT_HOLO')
  AND NOT EXISTS (SELECT 1 FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000141' AND frm_cd='PRF_POSTER_SHEETCUT_HOLO');
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
SELECT 'PRD_000142', 'PRF_POSTER_ACRYLSTK_GLOSS', '2026-06-01', 'D-WIRE 재바인딩: PRF_POSTER_FIXED→PRF_POSTER_ACRYLSTK_GLOSS (유광아크릴스티커)'
WHERE EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_POSTER_ACRYLSTK_GLOSS')
  AND NOT EXISTS (SELECT 1 FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000142' AND frm_cd='PRF_POSTER_ACRYLSTK_GLOSS');
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
SELECT 'PRD_000143', 'PRF_POSTER_ACRYLSTK_MIRROR', '2026-06-01', 'D-WIRE 재바인딩: PRF_POSTER_FIXED→PRF_POSTER_ACRYLSTK_MIRROR (미러아크릴스티커)'
WHERE EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_POSTER_ACRYLSTK_MIRROR')
  AND NOT EXISTS (SELECT 1 FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000143' AND frm_cd='PRF_POSTER_ACRYLSTK_MIRROR');
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
SELECT 'PRD_000144', 'PRF_POSTER_MINI_STANDBOARD', '2026-06-01', 'D-WIRE 재바인딩: PRF_POSTER_FIXED→PRF_POSTER_MINI_STANDBOARD (미니보드스탠딩)'
WHERE EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_POSTER_MINI_STANDBOARD')
  AND NOT EXISTS (SELECT 1 FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000144' AND frm_cd='PRF_POSTER_MINI_STANDBOARD');
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
SELECT 'PRD_000145', 'PRF_POSTER_MINI_BANNER', '2026-06-01', 'D-WIRE 재바인딩: PRF_POSTER_FIXED→PRF_POSTER_MINI_BANNER (미니배너)'
WHERE EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_POSTER_MINI_BANNER')
  AND NOT EXISTS (SELECT 1 FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000145' AND frm_cd='PRF_POSTER_MINI_BANNER');

-- ============================================================
-- [단계 4] PRF_POSTER_FIXED 은퇴 (0상품 도달 후 비활성). 멱등(IS DISTINCT FROM).
--   삭제(DELETE)는 ARTPRINT 배선 FK RESTRICT·운영파괴 → 본 트랙 미수행(인간승인 별건).
-- ============================================================
UPDATE t_prc_price_formulas SET use_yn='N', upd_dt=now()
WHERE frm_cd='PRF_POSTER_FIXED' AND use_yn IS DISTINCT FROM 'N';

-- ============================================================
-- [검증] 적재 후 사슬 무결성 (같은 tx 내 — ROLLBACK 시 무영향)
-- ============================================================
DO $$
DECLARE v_unwired int; v_fixed_bind int;
BEGIN
  -- 28상품 전부 새 공식에 바인딩 + 그 공식에 자기 comp 배선됐는가
  SELECT count(*) INTO v_unwired
  FROM t_prd_product_price_formulas b
  WHERE b.prd_cd BETWEEN 'PRD_000118' AND 'PRD_000145'
    AND b.frm_cd LIKE 'PRF\_POSTER\_%' ESCAPE '\' AND b.frm_cd <> 'PRF_POSTER_FIXED'
    AND NOT EXISTS (SELECT 1 FROM t_prc_formula_components fc WHERE fc.frm_cd=b.frm_cd);
  IF v_unwired <> 0 THEN RAISE EXCEPTION 'CHAIN BROKEN: % 상품 공식 미배선', v_unwired; END IF;
  -- PRF_POSTER_FIXED 잔존 바인딩 0
  SELECT count(*) INTO v_fixed_bind FROM t_prd_product_price_formulas WHERE frm_cd='PRF_POSTER_FIXED';
  IF v_fixed_bind <> 0 THEN RAISE EXCEPTION 'PRF_POSTER_FIXED 잔존 바인딩 %', v_fixed_bind; END IF;
  RAISE NOTICE 'D-WIRE 사슬 검증 PASS: 28상품 재바인딩+배선 완료, PRF_POSTER_FIXED 0상품';
END $$;
