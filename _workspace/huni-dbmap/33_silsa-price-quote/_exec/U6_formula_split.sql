-- U6_formula_split.sql — 가격사슬 부분단절 해소: 유형별 공식 분리 + 자기 comp 배선 + 바인딩 교체
-- ★현 단절: 28상품(PRD_000118~145) 전건 PRF_POSTER_FIXED 단일 바인딩 + 배선 1 comp(ARTPRINT_PHOTO만)
--   → 인화지 외 27상품 엔진 조회불가. 해소 = 상품별 공식 1:1 + 자기 소재 comp 배선 + 바인딩 교체.
-- frm_typ_cd 라이브 부재(round-17) → price_formulas는 frm_cd/frm_nm/note/use_yn만.
-- ★PK 정정(라이브 실측): t_prd_product_price_formulas PK=(prd_cd, apply_bgn_ymd) — DDL 문서 (prd_cd,frm_cd)는 stale.
--   ∴ 한 상품은 apply_bgn_ymd당 공식 1개 → 바인딩 교체 = DELETE(FIXED) 선행 후 INSERT(신규) (동일 apply_bgn_ymd '2026-06-01' 재사용·이중계상 방지).
-- 멱등: 공식/배선 INSERT NOT EXISTS · 바인딩 DELETE→INSERT(PK NOT EXISTS 가드) → 2pass delta 0.
-- 단가행 재적재 0(배선만). 본체 단가(면적매트릭스 셀)는 U2(GAP·BLOCKED)에서 별도 적재.

-- (1) 유형별 공식 28개 신규 (frm_cd 멱등)
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, note, use_yn, reg_dt)
SELECT v.frm_cd, v.frm_nm, v.note, 'Y', now()
FROM (VALUES
  ('PRF_POSTER_ARTPRINT','아트프린트포스터 완제품가(면적/규격 단가)','포스터사인 아트프린트포스터 소재/사이즈/수량별 완제품 통가격'),
  ('PRF_POSTER_ARTPAPER','아트페이퍼포스터 완제품가(면적/규격 단가)','포스터사인 아트페이퍼포스터 소재/사이즈/수량별 완제품 통가격'),
  ('PRF_POSTER_WATERPROOF','방수포스터 완제품가(면적/규격 단가)','포스터사인 방수포스터 소재/사이즈/수량별 완제품 통가격'),
  ('PRF_POSTER_ADH_WP','접착방수포스터 완제품가(면적/규격 단가)','포스터사인 접착방수포스터 소재/사이즈/수량별 완제품 통가격'),
  ('PRF_POSTER_ADH_CLEAR','접착투명포스터 완제품가(면적/규격 단가)','포스터사인 접착투명포스터 소재/사이즈/수량별 완제품 통가격'),
  ('PRF_POSTER_ARTFABRIC','아트패브릭포스터 완제품가(면적/규격 단가)','포스터사인 아트패브릭포스터 소재/사이즈/수량별 완제품 통가격'),
  ('PRF_POSTER_LINEN','린넨패브릭포스터 완제품가(면적/규격 단가)','포스터사인 린넨패브릭포스터 소재/사이즈/수량별 완제품 통가격'),
  ('PRF_POSTER_CANVAS','캔버스패브릭포스터 완제품가(면적/규격 단가)','포스터사인 캔버스패브릭포스터 소재/사이즈/수량별 완제품 통가격'),
  ('PRF_POSTER_LEATHER_AP','레더아트프린트 완제품가(면적/규격 단가)','포스터사인 레더아트프린트 소재/사이즈/수량별 완제품 통가격'),
  ('PRF_POSTER_TYVEK','타이벡프린트 완제품가(면적/규격 단가)','포스터사인 타이벡프린트 소재/사이즈/수량별 완제품 통가격'),
  ('PRF_POSTER_MESH','메쉬프린트 완제품가(면적/규격 단가)','포스터사인 메쉬프린트 소재/사이즈/수량별 완제품 통가격'),
  ('PRF_POSTER_FOAMBOARD','폼보드 완제품가(면적/규격 단가)','포스터사인 폼보드 소재/사이즈/수량별 완제품 통가격'),
  ('PRF_POSTER_FOMEXBOARD','포맥스보드 완제품가(면적/규격 단가)','포스터사인 포맥스보드 소재/사이즈/수량별 완제품 통가격'),
  ('PRF_POSTER_FRAMELESS','프레임리스우드액자 완제품가(면적/규격 단가)','포스터사인 프레임리스우드액자 소재/사이즈/수량별 완제품 통가격'),
  ('PRF_POSTER_LEATHER_FRAME','레더아트액자 완제품가(면적/규격 단가)','포스터사인 레더아트액자 소재/사이즈/수량별 완제품 통가격'),
  ('PRF_POSTER_CANVAS_HANGING','캔버스 행잉포스터 완제품가(면적/규격 단가)','포스터사인 캔버스 행잉포스터 소재/사이즈/수량별 완제품 통가격'),
  ('PRF_POSTER_LINEN_WOODBONG','린넨 우드봉 족자 완제품가(면적/규격 단가)','포스터사인 린넨 우드봉 족자 소재/사이즈/수량별 완제품 통가격'),
  ('PRF_POSTER_JOKJA','족자포스터 완제품가(면적/규격 단가)','포스터사인 족자포스터 소재/사이즈/수량별 완제품 통가격'),
  ('PRF_POSTER_PET_BANNER','PET배너 완제품가(면적/규격 단가)','포스터사인 PET배너 소재/사이즈/수량별 완제품 통가격'),
  ('PRF_POSTER_MESH_BANNER','메쉬배너 완제품가(면적/규격 단가)','포스터사인 메쉬배너 소재/사이즈/수량별 완제품 통가격'),
  ('PRF_POSTER_BANNER_N','일반현수막 완제품가(면적/규격 단가)','포스터사인 일반현수막 소재/사이즈/수량별 완제품 통가격'),
  ('PRF_POSTER_BANNER_M','메쉬현수막 완제품가(면적/규격 단가)','포스터사인 메쉬현수막 소재/사이즈/수량별 완제품 통가격'),
  ('PRF_POSTER_SHEETCUT_MATTE','무광시트커팅 완제품가(면적/규격 단가)','포스터사인 무광시트커팅 소재/사이즈/수량별 완제품 통가격'),
  ('PRF_POSTER_SHEETCUT_HOLO','홀로그램 시트커팅 완제품가(면적/규격 단가)','포스터사인 홀로그램 시트커팅 소재/사이즈/수량별 완제품 통가격'),
  ('PRF_POSTER_ACRYLSTK_GLOSS','유광아크릴스티커 완제품가(면적/규격 단가)','포스터사인 유광아크릴스티커 소재/사이즈/수량별 완제품 통가격'),
  ('PRF_POSTER_ACRYLSTK_MIRROR','미러아크릴스티커 완제품가(면적/규격 단가)','포스터사인 미러아크릴스티커 소재/사이즈/수량별 완제품 통가격'),
  ('PRF_POSTER_MINI_STANDBOARD','미니보드스탠딩 완제품가(면적/규격 단가)','포스터사인 미니보드스탠딩 소재/사이즈/수량별 완제품 통가격'),
  ('PRF_POSTER_MINI_BANNER','미니배너 완제품가(면적/규격 단가)','포스터사인 미니배너 소재/사이즈/수량별 완제품 통가격')
) AS v(frm_cd, frm_nm, note)
WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_formulas f WHERE f.frm_cd = v.frm_cd);

-- (2) 각 공식 → 자기 본체 comp 배선 (disp_seq=1·addtn_yn='Y')
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt)
SELECT v.frm_cd, v.comp_cd, 1, 'Y', now()
FROM (VALUES
  ('PRF_POSTER_ARTPRINT','COMP_POSTER_ARTPRINT_PHOTO'),
  ('PRF_POSTER_ARTPAPER','COMP_POSTER_ARTPAPER_MATTE'),
  ('PRF_POSTER_WATERPROOF','COMP_POSTER_WATERPROOF_PET'),
  ('PRF_POSTER_ADH_WP','COMP_POSTER_ADH_WATERPROOF_PVC'),
  ('PRF_POSTER_ADH_CLEAR','COMP_POSTER_ADH_CLEAR_PVC'),
  ('PRF_POSTER_ARTFABRIC','COMP_POSTER_ARTFABRIC_GRAPHIC'),
  ('PRF_POSTER_LINEN','COMP_POSTER_LINEN_FABRIC'),
  ('PRF_POSTER_CANVAS','COMP_POSTER_CANVAS_FABRIC'),
  ('PRF_POSTER_LEATHER_AP','COMP_POSTER_LEATHER_ARTPRINT'),
  ('PRF_POSTER_TYVEK','COMP_POSTER_TYVEK_PRINT'),
  ('PRF_POSTER_MESH','COMP_POSTER_MESH_PRINT'),
  ('PRF_POSTER_FOAMBOARD','COMP_POSTER_FOAMBOARD_WHITE'),
  ('PRF_POSTER_FOMEXBOARD','COMP_POSTER_FOMEXBOARD_WHITE3MM'),
  ('PRF_POSTER_FRAMELESS','COMP_POSTER_FRAMELESS_WOOD'),
  ('PRF_POSTER_LEATHER_FRAME','COMP_POSTER_LEATHER_FRAME'),
  ('PRF_POSTER_CANVAS_HANGING','COMP_POSTER_CANVAS_HANGING'),
  ('PRF_POSTER_LINEN_WOODBONG','COMP_POSTER_LINEN_WOODBONG'),
  ('PRF_POSTER_JOKJA','COMP_POSTER_JOKJA'),
  ('PRF_POSTER_PET_BANNER','COMP_POSTER_PET_BANNER'),
  ('PRF_POSTER_MESH_BANNER','COMP_POSTER_MESH_BANNER'),
  ('PRF_POSTER_BANNER_N','COMP_POSTER_BANNER_NORMAL'),
  ('PRF_POSTER_BANNER_M','COMP_POSTER_BANNER_MESH'),
  ('PRF_POSTER_SHEETCUT_MATTE','COMP_POSTER_SHEETCUT_MATTE'),
  ('PRF_POSTER_SHEETCUT_HOLO','COMP_POSTER_SHEETCUT_HOLO'),
  ('PRF_POSTER_ACRYLSTK_GLOSS','COMP_POSTER_ACRYLSTK_GLOSS'),
  ('PRF_POSTER_ACRYLSTK_MIRROR','COMP_POSTER_ACRYLSTK_MIRROR'),
  ('PRF_POSTER_MINI_STANDBOARD','COMP_POSTER_MINI_STANDBOARD'),
  ('PRF_POSTER_MINI_BANNER','COMP_POSTER_MINI_BANNER')
) AS v(frm_cd, comp_cd)
WHERE NOT EXISTS (SELECT 1 FROM t_prc_formula_components x WHERE x.frm_cd=v.frm_cd AND x.comp_cd=v.comp_cd);

-- (3) 바인딩 교체: PK(prd_cd,apply_bgn_ymd) 충돌 → 구 FIXED 바인딩 DELETE 선행 후 신규 INSERT.
DELETE FROM t_prd_product_price_formulas
 WHERE frm_cd = 'PRF_POSTER_FIXED'
   AND prd_cd BETWEEN 'PRD_000118' AND 'PRD_000145';

INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, reg_dt)
SELECT v.prd_cd, v.frm_cd, '2026-06-01', now()
FROM (VALUES
  ('PRD_000118','PRF_POSTER_ARTPRINT'),
  ('PRD_000119','PRF_POSTER_ARTPAPER'),
  ('PRD_000120','PRF_POSTER_WATERPROOF'),
  ('PRD_000121','PRF_POSTER_ADH_WP'),
  ('PRD_000122','PRF_POSTER_ADH_CLEAR'),
  ('PRD_000123','PRF_POSTER_ARTFABRIC'),
  ('PRD_000124','PRF_POSTER_LINEN'),
  ('PRD_000125','PRF_POSTER_CANVAS'),
  ('PRD_000126','PRF_POSTER_LEATHER_AP'),
  ('PRD_000127','PRF_POSTER_TYVEK'),
  ('PRD_000128','PRF_POSTER_MESH'),
  ('PRD_000129','PRF_POSTER_FOAMBOARD'),
  ('PRD_000130','PRF_POSTER_FOMEXBOARD'),
  ('PRD_000131','PRF_POSTER_FRAMELESS'),
  ('PRD_000132','PRF_POSTER_LEATHER_FRAME'),
  ('PRD_000133','PRF_POSTER_CANVAS_HANGING'),
  ('PRD_000134','PRF_POSTER_LINEN_WOODBONG'),
  ('PRD_000135','PRF_POSTER_JOKJA'),
  ('PRD_000136','PRF_POSTER_PET_BANNER'),
  ('PRD_000137','PRF_POSTER_MESH_BANNER'),
  ('PRD_000138','PRF_POSTER_BANNER_N'),
  ('PRD_000139','PRF_POSTER_BANNER_M'),
  ('PRD_000140','PRF_POSTER_SHEETCUT_MATTE'),
  ('PRD_000141','PRF_POSTER_SHEETCUT_HOLO'),
  ('PRD_000142','PRF_POSTER_ACRYLSTK_GLOSS'),
  ('PRD_000143','PRF_POSTER_ACRYLSTK_MIRROR'),
  ('PRD_000144','PRF_POSTER_MINI_STANDBOARD'),
  ('PRD_000145','PRF_POSTER_MINI_BANNER')
) AS v(prd_cd, frm_cd)
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_price_formulas x WHERE x.prd_cd=v.prd_cd AND x.apply_bgn_ymd='2026-06-01');

-- 주의: PRF_POSTER_FIXED 공식/배선(ARTPRINT_PHOTO)은 보존(비파괴). 바인딩만 이전.
