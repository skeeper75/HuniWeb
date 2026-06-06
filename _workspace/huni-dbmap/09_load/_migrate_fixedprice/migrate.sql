-- =====================================================================
-- 고정가형 15상품 정정 마이그레이션 (migrate.sql)
-- round-2 면적-좌표 오모델 정정. GO 커밋 후 COMMITTED 데이터 마이그레이션.
-- 생성: gen_migrate_sql.py (입력 CSV verbatim, 손으로 수정 금지)
-- 단일 트랜잭션. 로더(apply.sh)가 기본 ROLLBACK 주입(DRY-RUN), --commit=인간 승인.
-- =====================================================================
\set ON_ERROR_STOP on
\timing on
BEGIN;

-- 마이그레이션 전 가드: 15상품이 PRF_POSTER_FIXED에 바인딩되어 있는지 확인
DO $$
DECLARE n int;
BEGIN
  SELECT count(*) INTO n FROM t_prd_product_price_formulas
   WHERE prd_cd IN ('PRD_000129', 'PRD_000130', 'PRD_000131', 'PRD_000132', 'PRD_000133', 'PRD_000134', 'PRD_000135', 'PRD_000136', 'PRD_000137', 'PRD_000140', 'PRD_000141', 'PRD_000142', 'PRD_000143', 'PRD_000144', 'PRD_000145') AND frm_cd='PRF_POSTER_FIXED';
  IF n <> 15 THEN
    RAISE EXCEPTION '가드 실패: PRF_POSTER_FIXED 바인딩이 15가 아님 (실제 %). 마이그레이션 중단.', n;
  END IF;
END $$;

-- ---------------------------------------------------------------------
-- STEP 1: 고정가형 공식 추가 (t_prc_price_formulas) — 신규, 멱등
-- ---------------------------------------------------------------------
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, frm_typ_cd, note, use_yn, reg_dt) VALUES ('PRF_FOAMBOARD_FIXED', '폼보드 고정가형(규격×색상 룩업)', 'FRM_TYPE.02', '고정가형(단순형). 판매가 = component_prices 룩업 by (siz=규격, min_qty=수량)[+색상 comp_cd]. PRF_POSTER_FIXED 면적-좌표 오바인딩 대체. 수량스케일/할인=외부(round-1)', 'Y', now()) ON CONFLICT (frm_cd) DO NOTHING;
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, frm_typ_cd, note, use_yn, reg_dt) VALUES ('PRF_FOMEXBOARD_FIXED', '포맥스보드 고정가형(규격×색상 룩업)', 'FRM_TYPE.02', '고정가형(단순형). 색상 화이트/검정 = per-색상 comp_cd', 'Y', now()) ON CONFLICT (frm_cd) DO NOTHING;
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, frm_typ_cd, note, use_yn, reg_dt) VALUES ('PRF_FRAMELESS_WOOD_FIXED', '프레임리스우드액자 고정가형(규격 룩업)', 'FRM_TYPE.02', '고정가형(단순형). 판매가 = component_prices 룩업 by (siz=규격, min_qty=1)', 'Y', now()) ON CONFLICT (frm_cd) DO NOTHING;
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, frm_typ_cd, note, use_yn, reg_dt) VALUES ('PRF_LEATHER_FRAME_FIXED', '레더아트액자 고정가형(규격 룩업)', 'FRM_TYPE.02', '고정가형(단순형)', 'Y', now()) ON CONFLICT (frm_cd) DO NOTHING;
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, frm_typ_cd, note, use_yn, reg_dt) VALUES ('PRF_CANVAS_HANGING_FIXED', '캔버스행잉포스터 고정가형(규격 룩업)', 'FRM_TYPE.02', '고정가형(단순형)', 'Y', now()) ON CONFLICT (frm_cd) DO NOTHING;
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, frm_typ_cd, note, use_yn, reg_dt) VALUES ('PRF_LINEN_WOODBONG_FIXED', '린넨우드봉족자 고정가형(규격 룩업)', 'FRM_TYPE.02', '고정가형(단순형)', 'Y', now()) ON CONFLICT (frm_cd) DO NOTHING;
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, frm_typ_cd, note, use_yn, reg_dt) VALUES ('PRF_JOKJA_FIXED', '족자포스터 고정가형(규격 룩업)', 'FRM_TYPE.02', '고정가형(단순형)', 'Y', now()) ON CONFLICT (frm_cd) DO NOTHING;
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, frm_typ_cd, note, use_yn, reg_dt) VALUES ('PRF_PET_BANNER_FIXED', 'PET배너 고정가형(규격 룩업)', 'FRM_TYPE.02', '고정가형(단순형)', 'Y', now()) ON CONFLICT (frm_cd) DO NOTHING;
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, frm_typ_cd, note, use_yn, reg_dt) VALUES ('PRF_MESH_BANNER_FIXED', '메쉬배너 고정가형(규격 룩업)', 'FRM_TYPE.02', '고정가형(단순형)', 'Y', now()) ON CONFLICT (frm_cd) DO NOTHING;
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, frm_typ_cd, note, use_yn, reg_dt) VALUES ('PRF_SHEETCUT_MATTE_FIXED', '무광시트커팅 고정가형(규격 룩업)', 'FRM_TYPE.02', '고정가형(단순형). 색상 화이트/블랙 동일가→단일 comp', 'Y', now()) ON CONFLICT (frm_cd) DO NOTHING;
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, frm_typ_cd, note, use_yn, reg_dt) VALUES ('PRF_SHEETCUT_HOLO_FIXED', '홀로그램 시트커팅 고정가형(규격 룩업)', 'FRM_TYPE.02', '고정가형(단순형)', 'Y', now()) ON CONFLICT (frm_cd) DO NOTHING;
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, frm_typ_cd, note, use_yn, reg_dt) VALUES ('PRF_ACRYLSTK_GLOSS_FIXED', '유광아크릴스티커 고정가형(규격 룩업)', 'FRM_TYPE.02', '고정가형(단순형). 색상 화이트/블랙 동일가→단일 comp', 'Y', now()) ON CONFLICT (frm_cd) DO NOTHING;
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, frm_typ_cd, note, use_yn, reg_dt) VALUES ('PRF_ACRYLSTK_MIRROR_FIXED', '미러아크릴스티커 고정가형(규격 룩업)', 'FRM_TYPE.02', '고정가형(단순형). 색상 골드/실버 동일가→단일 comp', 'Y', now()) ON CONFLICT (frm_cd) DO NOTHING;
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, frm_typ_cd, note, use_yn, reg_dt) VALUES ('PRF_MINI_STANDBOARD_FIXED', '미니보드스탠딩 고정가형(규격×수량구간 룩업)', 'FRM_TYPE.02', '고정가형(단순형). 5단 수량구간(4/19/49/99/10000)=min_qty 차원, 외부 곱셈/할인 없음', 'Y', now()) ON CONFLICT (frm_cd) DO NOTHING;
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, frm_typ_cd, note, use_yn, reg_dt) VALUES ('PRF_MINI_BANNER_FIXED', '미니배너 고정가형(규격×수량구간 룩업)', 'FRM_TYPE.02', '고정가형(단순형). 5단 수량구간(4/19/49/99/10000)=min_qty 차원', 'Y', now()) ON CONFLICT (frm_cd) DO NOTHING;

-- ---------------------------------------------------------------------
-- STEP 2a: 가격구성요소 추가 (t_prc_price_components) — 색상 variant 포함, 멱등
--   17 comp_cd 전부 emit (라이브 13종 기존존재→skip, FOAM/FOMEX 4종 신규)
-- ---------------------------------------------------------------------
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, use_yn, reg_dt) VALUES ('COMP_FOAMBOARD_WHITE', '포스터 완제품가(포함항목 통가격) [COMP_FOAMBOARD_WHITE]', 'PRC_COMPONENT_TYPE.06', 'Y', now()) ON CONFLICT (comp_cd) DO NOTHING;
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, use_yn, reg_dt) VALUES ('COMP_FOAMBOARD_BLACK', '포스터 완제품가(포함항목 통가격) [COMP_FOAMBOARD_BLACK]', 'PRC_COMPONENT_TYPE.06', 'Y', now()) ON CONFLICT (comp_cd) DO NOTHING;
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, use_yn, reg_dt) VALUES ('COMP_FOMEXBOARD_WHITE', '포스터 완제품가(포함항목 통가격) [COMP_FOMEXBOARD_WHITE]', 'PRC_COMPONENT_TYPE.06', 'Y', now()) ON CONFLICT (comp_cd) DO NOTHING;
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, use_yn, reg_dt) VALUES ('COMP_FOMEXBOARD_BLACK', '포스터 완제품가(포함항목 통가격) [COMP_FOMEXBOARD_BLACK]', 'PRC_COMPONENT_TYPE.06', 'Y', now()) ON CONFLICT (comp_cd) DO NOTHING;
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, use_yn, reg_dt) VALUES ('COMP_POSTER_FRAMELESS_WOOD', '포스터 완제품가(포함항목 통가격) [COMP_POSTER_FRAMELESS_WOOD]', 'PRC_COMPONENT_TYPE.06', 'Y', now()) ON CONFLICT (comp_cd) DO NOTHING;
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, use_yn, reg_dt) VALUES ('COMP_POSTER_LEATHER_FRAME', '포스터 완제품가(포함항목 통가격) [COMP_POSTER_LEATHER_FRAME]', 'PRC_COMPONENT_TYPE.06', 'Y', now()) ON CONFLICT (comp_cd) DO NOTHING;
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, use_yn, reg_dt) VALUES ('COMP_POSTER_CANVAS_HANGING', '포스터 완제품가(포함항목 통가격) [COMP_POSTER_CANVAS_HANGING]', 'PRC_COMPONENT_TYPE.06', 'Y', now()) ON CONFLICT (comp_cd) DO NOTHING;
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, use_yn, reg_dt) VALUES ('COMP_POSTER_LINEN_WOODBONG', '포스터 완제품가(포함항목 통가격) [COMP_POSTER_LINEN_WOODBONG]', 'PRC_COMPONENT_TYPE.06', 'Y', now()) ON CONFLICT (comp_cd) DO NOTHING;
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, use_yn, reg_dt) VALUES ('COMP_POSTER_JOKJA', '포스터 완제품가(포함항목 통가격) [COMP_POSTER_JOKJA]', 'PRC_COMPONENT_TYPE.06', 'Y', now()) ON CONFLICT (comp_cd) DO NOTHING;
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, use_yn, reg_dt) VALUES ('COMP_POSTER_PET_BANNER', '포스터 완제품가(포함항목 통가격) [COMP_POSTER_PET_BANNER]', 'PRC_COMPONENT_TYPE.06', 'Y', now()) ON CONFLICT (comp_cd) DO NOTHING;
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, use_yn, reg_dt) VALUES ('COMP_POSTER_MESH_BANNER', '포스터 완제품가(포함항목 통가격) [COMP_POSTER_MESH_BANNER]', 'PRC_COMPONENT_TYPE.06', 'Y', now()) ON CONFLICT (comp_cd) DO NOTHING;
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, use_yn, reg_dt) VALUES ('COMP_POSTER_SHEETCUT_MATTE', '포스터 완제품가(포함항목 통가격) [COMP_POSTER_SHEETCUT_MATTE]', 'PRC_COMPONENT_TYPE.06', 'Y', now()) ON CONFLICT (comp_cd) DO NOTHING;
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, use_yn, reg_dt) VALUES ('COMP_POSTER_SHEETCUT_HOLO', '포스터 완제품가(포함항목 통가격) [COMP_POSTER_SHEETCUT_HOLO]', 'PRC_COMPONENT_TYPE.06', 'Y', now()) ON CONFLICT (comp_cd) DO NOTHING;
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, use_yn, reg_dt) VALUES ('COMP_POSTER_ACRYLSTK_GLOSS', '포스터 완제품가(포함항목 통가격) [COMP_POSTER_ACRYLSTK_GLOSS]', 'PRC_COMPONENT_TYPE.06', 'Y', now()) ON CONFLICT (comp_cd) DO NOTHING;
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, use_yn, reg_dt) VALUES ('COMP_POSTER_ACRYLSTK_MIRROR', '포스터 완제품가(포함항목 통가격) [COMP_POSTER_ACRYLSTK_MIRROR]', 'PRC_COMPONENT_TYPE.06', 'Y', now()) ON CONFLICT (comp_cd) DO NOTHING;
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, use_yn, reg_dt) VALUES ('COMP_POSTER_MINI_STANDBOARD', '포스터 완제품가(포함항목 통가격) [COMP_POSTER_MINI_STANDBOARD]', 'PRC_COMPONENT_TYPE.06', 'Y', now()) ON CONFLICT (comp_cd) DO NOTHING;
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, use_yn, reg_dt) VALUES ('COMP_POSTER_MINI_BANNER', '포스터 완제품가(포함항목 통가격) [COMP_POSTER_MINI_BANNER]', 'PRC_COMPONENT_TYPE.06', 'Y', now()) ON CONFLICT (comp_cd) DO NOTHING;

-- ---------------------------------------------------------------------
-- STEP 2b: 공식↔구성 와이어링 (t_prc_formula_components) — 신규, 멱등
-- ---------------------------------------------------------------------
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt) VALUES ('PRF_FOAMBOARD_FIXED', 'COMP_FOAMBOARD_WHITE', 1, 'N', now()) ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt) VALUES ('PRF_FOAMBOARD_FIXED', 'COMP_FOAMBOARD_BLACK', 2, 'N', now()) ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt) VALUES ('PRF_FOMEXBOARD_FIXED', 'COMP_FOMEXBOARD_WHITE', 1, 'N', now()) ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt) VALUES ('PRF_FOMEXBOARD_FIXED', 'COMP_FOMEXBOARD_BLACK', 2, 'N', now()) ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt) VALUES ('PRF_FRAMELESS_WOOD_FIXED', 'COMP_POSTER_FRAMELESS_WOOD', 1, 'N', now()) ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt) VALUES ('PRF_LEATHER_FRAME_FIXED', 'COMP_POSTER_LEATHER_FRAME', 1, 'N', now()) ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt) VALUES ('PRF_CANVAS_HANGING_FIXED', 'COMP_POSTER_CANVAS_HANGING', 1, 'N', now()) ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt) VALUES ('PRF_LINEN_WOODBONG_FIXED', 'COMP_POSTER_LINEN_WOODBONG', 1, 'N', now()) ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt) VALUES ('PRF_JOKJA_FIXED', 'COMP_POSTER_JOKJA', 1, 'N', now()) ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt) VALUES ('PRF_PET_BANNER_FIXED', 'COMP_POSTER_PET_BANNER', 1, 'N', now()) ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt) VALUES ('PRF_MESH_BANNER_FIXED', 'COMP_POSTER_MESH_BANNER', 1, 'N', now()) ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt) VALUES ('PRF_SHEETCUT_MATTE_FIXED', 'COMP_POSTER_SHEETCUT_MATTE', 1, 'N', now()) ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt) VALUES ('PRF_SHEETCUT_HOLO_FIXED', 'COMP_POSTER_SHEETCUT_HOLO', 1, 'N', now()) ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt) VALUES ('PRF_ACRYLSTK_GLOSS_FIXED', 'COMP_POSTER_ACRYLSTK_GLOSS', 1, 'N', now()) ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt) VALUES ('PRF_ACRYLSTK_MIRROR_FIXED', 'COMP_POSTER_ACRYLSTK_MIRROR', 1, 'N', now()) ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt) VALUES ('PRF_MINI_STANDBOARD_FIXED', 'COMP_POSTER_MINI_STANDBOARD', 1, 'N', now()) ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt) VALUES ('PRF_MINI_BANNER_FIXED', 'COMP_POSTER_MINI_BANNER', 1, 'N', now()) ON CONFLICT (frm_cd, comp_cd) DO NOTHING;

-- ---------------------------------------------------------------------
-- STEP 3: 단가 정정 (t_prc_component_prices)
--   선행 broken-partial 적재(55행, min_qty NULL/1 불일치 포함)를 DELETE 후
--   권위 CSV 73행을 INSERT. → 라이브 = 정확히 73행 (중복/stale NULL-qty 제거)
--   comp_price_id = MAX(현재)+행번호 (시퀀스 없음, 명시 채번)
-- ---------------------------------------------------------------------
DELETE FROM t_prc_component_prices WHERE comp_cd IN ('COMP_FOAMBOARD_BLACK', 'COMP_FOAMBOARD_WHITE', 'COMP_FOMEXBOARD_BLACK', 'COMP_FOMEXBOARD_WHITE', 'COMP_POSTER_ACRYLSTK_GLOSS', 'COMP_POSTER_ACRYLSTK_MIRROR', 'COMP_POSTER_CANVAS_HANGING', 'COMP_POSTER_FRAMELESS_WOOD', 'COMP_POSTER_JOKJA', 'COMP_POSTER_LEATHER_FRAME', 'COMP_POSTER_LINEN_WOODBONG', 'COMP_POSTER_MESH_BANNER', 'COMP_POSTER_MINI_BANNER', 'COMP_POSTER_MINI_STANDBOARD', 'COMP_POSTER_PET_BANNER', 'COMP_POSTER_SHEETCUT_HOLO', 'COMP_POSTER_SHEETCUT_MATTE');

-- 채번 기준 캡처 (DELETE 후 MAX, 충돌 회피)
DO $$
DECLARE base bigint;
BEGIN
  SELECT coalesce(max(comp_price_id),0) INTO base FROM t_prc_component_prices;
  CREATE TEMP TABLE _mig_base (b bigint) ON COMMIT DROP;
  INSERT INTO _mig_base VALUES (base);
END $$;

INSERT INTO t_prc_component_prices
  (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt)
SELECT (SELECT b FROM _mig_base) + v.rn,
       v.comp_cd, v.apply_ymd, v.siz_cd, v.clr_cd, v.mat_cd, v.coat_side_cnt, v.bdl_qty, v.min_qty, v.unit_price, v.note, now()
FROM (VALUES
  (1::int, 'COMP_FOAMBOARD_WHITE', '2026-06-01'::varchar, 'SIZ_000315', NULL::text, NULL::text, NULL::int, NULL::int, 1::int, 7000::numeric, '폼보드 A3/화이트 완제품가[출력+코팅+가공 포함] (PRD_000129, 색상=화이트 per-색상 comp_cd, 라이브 siz A3=SIZ_000315 재사용, 완제품비.06, src B11-concat r49)'),
  (2::int, 'COMP_FOAMBOARD_WHITE', '2026-06-01'::varchar, 'SIZ_000317', NULL::text, NULL::text, NULL::int, NULL::int, 1::int, 12000::numeric, '폼보드 A2/화이트 완제품가[출력+코팅+가공 포함] (PRD_000129, 색상=화이트, 라이브 siz A2=SIZ_000317 재사용, 완제품비.06, src B11-concat r51)'),
  (3::int, 'COMP_FOAMBOARD_WHITE', '2026-06-01'::varchar, 'SIZ_000293', NULL::text, NULL::text, NULL::int, NULL::int, 1::int, 20000::numeric, '폼보드 A1/화이트 완제품가[출력+코팅+가공 포함] (PRD_000129, 색상=화이트, 라이브 siz A1=SIZ_000293 재사용[SIZ_PENDING_POSTER_A1 폐기], 완제품비.06, src B11-concat r53)'),
  (4::int, 'COMP_FOAMBOARD_BLACK', '2026-06-01'::varchar, 'SIZ_000315', NULL::text, NULL::text, NULL::int, NULL::int, 1::int, 8500::numeric, '폼보드 A3/검정(추가) 완제품가[출력+코팅+가공 포함] (PRD_000129, 색상=검정, 라이브 siz A3=SIZ_000315 재사용, 완제품비.06, src B11-concat r50)'),
  (5::int, 'COMP_FOAMBOARD_BLACK', '2026-06-01'::varchar, 'SIZ_000317', NULL::text, NULL::text, NULL::int, NULL::int, 1::int, 14000::numeric, '폼보드 A2/검정(추가) 완제품가[출력+코팅+가공 포함] (PRD_000129, 색상=검정, 라이브 siz A2=SIZ_000317 재사용, 완제품비.06, src B11-concat r52)'),
  (6::int, 'COMP_FOAMBOARD_BLACK', '2026-06-01'::varchar, 'SIZ_000293', NULL::text, NULL::text, NULL::int, NULL::int, 1::int, 24000::numeric, '폼보드 A1/검정(추가) 완제품가[출력+코팅+가공 포함] (PRD_000129, 색상=검정, 라이브 siz A1=SIZ_000293 재사용[SIZ_PENDING_POSTER_A1 폐기], 완제품비.06, src B11-concat r54)'),
  (7::int, 'COMP_FOMEXBOARD_WHITE', '2026-06-01'::varchar, 'SIZ_000315', NULL::text, NULL::text, NULL::int, NULL::int, 1::int, 8500::numeric, '포맥스보드 A3/화이트 완제품가[출력+코팅+가공 포함] (PRD_000130, 색상=화이트, 라이브 siz A3=SIZ_000315 재사용, 완제품비.06, src B11-concat r55. 구CSV FOMEXBOARD_WHITE3MM 두께표기 오류 정정→색상축)'),
  (8::int, 'COMP_FOMEXBOARD_WHITE', '2026-06-01'::varchar, 'SIZ_000317', NULL::text, NULL::text, NULL::int, NULL::int, 1::int, 13000::numeric, '포맥스보드 A2/화이트 완제품가[출력+코팅+가공 포함] (PRD_000130, 색상=화이트, 라이브 siz A2=SIZ_000317 재사용, 완제품비.06, src B11-concat r57)'),
  (9::int, 'COMP_FOMEXBOARD_WHITE', '2026-06-01'::varchar, 'SIZ_000293', NULL::text, NULL::text, NULL::int, NULL::int, 1::int, 23000::numeric, '포맥스보드 A1/화이트 완제품가[출력+코팅+가공 포함] (PRD_000130, 색상=화이트, 라이브 siz A1=SIZ_000293 재사용[SIZ_PENDING_POSTER_A1 폐기], 완제품비.06, src B11-concat r59)'),
  (10::int, 'COMP_FOMEXBOARD_BLACK', '2026-06-01'::varchar, 'SIZ_000315', NULL::text, NULL::text, NULL::int, NULL::int, 1::int, 10000::numeric, '포맥스보드 A3/검정(추가) 완제품가[출력+코팅+가공 포함] (PRD_000130, 색상=검정, 라이브 siz A3=SIZ_000315 재사용, 완제품비.06, src B11-concat r56. 구CSV FOMEXBOARD_WHITE5MM 오라벨 정정→검정 색상축)'),
  (11::int, 'COMP_FOMEXBOARD_BLACK', '2026-06-01'::varchar, 'SIZ_000317', NULL::text, NULL::text, NULL::int, NULL::int, 1::int, 16000::numeric, '포맥스보드 A2/검정(추가) 완제품가[출력+코팅+가공 포함] (PRD_000130, 색상=검정, 라이브 siz A2=SIZ_000317 재사용, 완제품비.06, src B11-concat r58)'),
  (12::int, 'COMP_FOMEXBOARD_BLACK', '2026-06-01'::varchar, 'SIZ_000293', NULL::text, NULL::text, NULL::int, NULL::int, 1::int, 30000::numeric, '포맥스보드 A1/검정(추가) 완제품가[출력+코팅+가공 포함] (PRD_000130, 색상=검정, 라이브 siz A1=SIZ_000293 재사용[SIZ_PENDING_POSTER_A1 폐기], 완제품비.06, src B11-concat r60)'),
  (13::int, 'COMP_POSTER_FRAMELESS_WOOD', '2026-06-01'::varchar, 'SIZ_000315', NULL::text, NULL::text, NULL::int, NULL::int, 1::int, 16000::numeric, '프레임리스우드액자 A3 완제품가[출력+코팅+가공 포함가] (PRD_000131, 라이브 siz A3=SIZ_000315 재사용, 완제품비.06, src B13)'),
  (14::int, 'COMP_POSTER_FRAMELESS_WOOD', '2026-06-01'::varchar, 'SIZ_000317', NULL::text, NULL::text, NULL::int, NULL::int, 1::int, 23000::numeric, '프레임리스우드액자 A2 완제품가[출력+코팅+가공 포함가] (PRD_000131, 라이브 siz A2=SIZ_000317 재사용, 완제품비.06, src B13)'),
  (15::int, 'COMP_POSTER_FRAMELESS_WOOD', '2026-06-01'::varchar, 'SIZ_000293', NULL::text, NULL::text, NULL::int, NULL::int, 1::int, 35000::numeric, '프레임리스우드액자 A1 완제품가[출력+코팅+가공 포함가] (PRD_000131, 라이브 siz A1=SIZ_000293 재사용[SIZ_PENDING_POSTER_A1 폐기], 완제품비.06, src B13)'),
  (16::int, 'COMP_POSTER_LEATHER_FRAME', '2026-06-01'::varchar, 'SIZ_000304', NULL::text, NULL::text, NULL::int, NULL::int, 1::int, 9000::numeric, '레더아트액자 5x5 완제품가[출력+가공 포함가] (PRD_000132, 라이브 siz 5x5=SIZ_000304 재사용[SIZ_PENDING_POSTER_5x5 폐기], 완제품비.06, src B15)'),
  (17::int, 'COMP_POSTER_LEATHER_FRAME', '2026-06-01'::varchar, 'SIZ_000306', NULL::text, NULL::text, NULL::int, NULL::int, 1::int, 10000::numeric, '레더아트액자 5x7 완제품가[출력+가공 포함가] (PRD_000132, 라이브 siz 5x7=SIZ_000306 재사용[SIZ_PENDING_POSTER_5x7 폐기], 완제품비.06, src B15)'),
  (18::int, 'COMP_POSTER_LEATHER_FRAME', '2026-06-01'::varchar, 'SIZ_000308', NULL::text, NULL::text, NULL::int, NULL::int, 1::int, 11000::numeric, '레더아트액자 8x8 완제품가[출력+가공 포함가] (PRD_000132, 라이브 siz 8x8=SIZ_000308 재사용[SIZ_PENDING_POSTER_8x8 폐기], 완제품비.06, src B15)'),
  (19::int, 'COMP_POSTER_LEATHER_FRAME', '2026-06-01'::varchar, 'SIZ_000310', NULL::text, NULL::text, NULL::int, NULL::int, 1::int, 13000::numeric, '레더아트액자 8x10 완제품가[출력+가공 포함가] (PRD_000132, 라이브 siz 8x10=SIZ_000310 재사용[SIZ_PENDING_POSTER_8x10 폐기], 완제품비.06, src B15)'),
  (20::int, 'COMP_POSTER_LEATHER_FRAME', '2026-06-01'::varchar, 'SIZ_000258', NULL::text, NULL::text, NULL::int, NULL::int, 1::int, 16000::numeric, '레더아트액자 A4 완제품가[출력+가공 포함가] (PRD_000132, 라이브 siz A4=SIZ_000258 재사용, 완제품비.06, src B15)'),
  (21::int, 'COMP_POSTER_LEATHER_FRAME', '2026-06-01'::varchar, 'SIZ_000315', NULL::text, NULL::text, NULL::int, NULL::int, 1::int, 21000::numeric, '레더아트액자 A3 완제품가[출력+가공 포함가] (PRD_000132, 라이브 siz A3=SIZ_000315 재사용, 완제품비.06, src B15)'),
  (22::int, 'COMP_POSTER_CANVAS_HANGING', '2026-06-01'::varchar, 'SIZ_000258', NULL::text, NULL::text, NULL::int, NULL::int, 1::int, 6000::numeric, '캔버스행잉포스터 A4 완제품가[출력+가공(오버로크) 포함가] (PRD_000133, 라이브 siz A4=SIZ_000258 재사용, 완제품비.06, src B19)'),
  (23::int, 'COMP_POSTER_CANVAS_HANGING', '2026-06-01'::varchar, 'SIZ_000315', NULL::text, NULL::text, NULL::int, NULL::int, 1::int, 10500::numeric, '캔버스행잉포스터 A3 완제품가[출력+가공(오버로크) 포함가] (PRD_000133, 라이브 siz A3=SIZ_000315 재사용, 완제품비.06, src B19)'),
  (24::int, 'COMP_POSTER_CANVAS_HANGING', '2026-06-01'::varchar, 'SIZ_000317', NULL::text, NULL::text, NULL::int, NULL::int, 1::int, 20000::numeric, '캔버스행잉포스터 A2 완제품가[출력+가공(오버로크) 포함가] (PRD_000133, 라이브 siz A2=SIZ_000317 재사용, 완제품비.06, src B19)'),
  (25::int, 'COMP_POSTER_LINEN_WOODBONG', '2026-06-01'::varchar, 'SIZ_000258', NULL::text, NULL::text, NULL::int, NULL::int, 1::int, 6000::numeric, '린넨우드봉족자 A4 완제품가[출력+가공(봉미싱) 포함가] (PRD_000134, 라이브 siz A4=SIZ_000258 재사용, 완제품비.06, src B21)'),
  (26::int, 'COMP_POSTER_LINEN_WOODBONG', '2026-06-01'::varchar, 'SIZ_000315', NULL::text, NULL::text, NULL::int, NULL::int, 1::int, 8200::numeric, '린넨우드봉족자 A3 완제품가[출력+가공(봉미싱) 포함가] (PRD_000134, 라이브 siz A3=SIZ_000315 재사용, 완제품비.06, src B21)'),
  (27::int, 'COMP_POSTER_LINEN_WOODBONG', '2026-06-01'::varchar, 'SIZ_000317', NULL::text, NULL::text, NULL::int, NULL::int, 1::int, 16000::numeric, '린넨우드봉족자 A2 완제품가[출력+가공(봉미싱) 포함가] (PRD_000134, 라이브 siz A2=SIZ_000317 재사용, 완제품비.06, src B21)'),
  (28::int, 'COMP_POSTER_JOKJA', '2026-06-01'::varchar, 'SIZ_000315', NULL::text, NULL::text, NULL::int, NULL::int, 1::int, 13000::numeric, '족자포스터 A3 완제품가[출력+코팅+가공(사각/원형족자) 포함가] (PRD_000135, 라이브 siz A3=SIZ_000315 재사용, 완제품비.06, src B17)'),
  (29::int, 'COMP_POSTER_JOKJA', '2026-06-01'::varchar, 'SIZ_000317', NULL::text, NULL::text, NULL::int, NULL::int, 1::int, 15000::numeric, '족자포스터 A2 완제품가[출력+코팅+가공(사각/원형족자) 포함가] (PRD_000135, 라이브 siz A2=SIZ_000317 재사용, 완제품비.06, src B17)'),
  (30::int, 'COMP_POSTER_JOKJA', '2026-06-01'::varchar, 'SIZ_000293', NULL::text, NULL::text, NULL::int, NULL::int, 1::int, 22000::numeric, '족자포스터 A1 완제품가[출력+코팅+가공(사각/원형족자) 포함가] (PRD_000135, 라이브 siz A1=SIZ_000293 재사용[SIZ_PENDING_POSTER_A1 폐기], 완제품비.06, src B17)'),
  (31::int, 'COMP_POSTER_JOKJA', '2026-06-01'::varchar, 'SIZ_000319', NULL::text, NULL::text, NULL::int, NULL::int, 1::int, 15000::numeric, '족자포스터 300*600 완제품가[출력+코팅+가공(사각/원형족자) 포함가] (PRD_000135, 라이브 siz 300x600=SIZ_000319 재사용, 완제품비.06, src B17)'),
  (32::int, 'COMP_POSTER_JOKJA', '2026-06-01'::varchar, 'SIZ_000320', NULL::text, NULL::text, NULL::int, NULL::int, 1::int, 32000::numeric, '족자포스터 900*1200 완제품가[출력+코팅+가공(사각/원형족자) 포함가] (PRD_000135, 라이브 siz 900x1200=SIZ_000320 재사용, 완제품비.06, src B17)'),
  (33::int, 'COMP_POSTER_PET_BANNER', '2026-06-01'::varchar, 'SIZ_000321', NULL::text, NULL::text, NULL::int, NULL::int, 1::int, 22000::numeric, 'PET배너 600x1800 mm 완제품가[출력+코팅+가공(4구아일렛) 포함가] (PRD_000136, 라이브 siz 600x1800=SIZ_000321 재사용, 완제품비.06, src B23)'),
  (34::int, 'COMP_POSTER_MESH_BANNER', '2026-06-01'::varchar, 'SIZ_000321', NULL::text, NULL::text, NULL::int, NULL::int, 1::int, 38000::numeric, '메쉬배너 600x1800 mm 완제품가[출력+코팅+가공(4구아일렛) 포함가] (PRD_000137, 라이브 siz 600x1800=SIZ_000321 재사용, 완제품비.06, src B25)'),
  (35::int, 'COMP_POSTER_SHEETCUT_MATTE', '2026-06-01'::varchar, 'SIZ_000258', NULL::text, NULL::text, NULL::int, NULL::int, 1::int, 6000::numeric, '무광시트커팅 A4 완제품가[시트커팅] (PRD_000140, 색상 화이트/블랙 동일가→단일행 mat 무관, 라이브 siz A4=SIZ_000258 재사용, 완제품비.06, src B27 r288)'),
  (36::int, 'COMP_POSTER_SHEETCUT_MATTE', '2026-06-01'::varchar, 'SIZ_000315', NULL::text, NULL::text, NULL::int, NULL::int, 1::int, 11000::numeric, '무광시트커팅 A3 완제품가[시트커팅] (PRD_000140, 색상 화이트/블랙 동일가→단일행, 라이브 siz A3=SIZ_000315 재사용, 완제품비.06, src B27 r288)'),
  (37::int, 'COMP_POSTER_SHEETCUT_MATTE', '2026-06-01'::varchar, 'SIZ_000317', NULL::text, NULL::text, NULL::int, NULL::int, 1::int, 32000::numeric, '무광시트커팅 A2 완제품가[시트커팅] (PRD_000140, 색상 화이트/블랙 동일가→단일행, 라이브 siz A2=SIZ_000317 재사용, 완제품비.06, src B27 r288)'),
  (38::int, 'COMP_POSTER_SHEETCUT_HOLO', '2026-06-01'::varchar, 'SIZ_000258', NULL::text, NULL::text, NULL::int, NULL::int, 1::int, 8000::numeric, '홀로그램 시트커팅 A4 완제품가[시트커팅] (PRD_000141, 단일색상, 라이브 siz A4=SIZ_000258 재사용, 완제품비.06, src B27 r289)'),
  (39::int, 'COMP_POSTER_SHEETCUT_HOLO', '2026-06-01'::varchar, 'SIZ_000315', NULL::text, NULL::text, NULL::int, NULL::int, 1::int, 16000::numeric, '홀로그램 시트커팅 A3 완제품가[시트커팅] (PRD_000141, 단일색상, 라이브 siz A3=SIZ_000315 재사용, 완제품비.06, src B27 r289)'),
  (40::int, 'COMP_POSTER_SHEETCUT_HOLO', '2026-06-01'::varchar, 'SIZ_000317', NULL::text, NULL::text, NULL::int, NULL::int, 1::int, 32000::numeric, '홀로그램 시트커팅 A2 완제품가[시트커팅] (PRD_000141, 단일색상, 라이브 siz A2=SIZ_000317 재사용, 완제품비.06, src B27 r289)'),
  (41::int, 'COMP_POSTER_ACRYLSTK_GLOSS', '2026-06-01'::varchar, 'SIZ_000324', NULL::text, NULL::text, NULL::int, NULL::int, 1::int, 9000::numeric, '유광아크릴스티커 290x90 mm 완제품가 (PRD_000142, 색상 화이트/블랙 동일가→단일행 mat 무관, 라이브 siz 290x90=SIZ_000324 재사용, 완제품비.06, src B27 r295)'),
  (42::int, 'COMP_POSTER_ACRYLSTK_GLOSS', '2026-06-01'::varchar, 'SIZ_000325', NULL::text, NULL::text, NULL::int, NULL::int, 1::int, 14000::numeric, '유광아크릴스티커 290x190 mm 완제품가 (PRD_000142, 색상 화이트/블랙 동일가→단일행, 라이브 siz 290x190=SIZ_000325 재사용, 완제품비.06, src B27 r295)'),
  (43::int, 'COMP_POSTER_ACRYLSTK_GLOSS', '2026-06-01'::varchar, 'SIZ_000326', NULL::text, NULL::text, NULL::int, NULL::int, 1::int, 32000::numeric, '유광아크릴스티커 390x290 mm 완제품가 (PRD_000142, 색상 화이트/블랙 동일가→단일행, 라이브 siz 390x290=SIZ_000326 재사용, 완제품비.06, src B27 r295)'),
  (44::int, 'COMP_POSTER_ACRYLSTK_GLOSS', '2026-06-01'::varchar, 'SIZ_000327', NULL::text, NULL::text, NULL::int, NULL::int, 1::int, 37000::numeric, '유광아크릴스티커 590x390 mm 완제품가 (PRD_000142, 색상 화이트/블랙 동일가→단일행, 라이브 siz 590x390=SIZ_000327 재사용, 완제품비.06, src B27 r295)'),
  (45::int, 'COMP_POSTER_ACRYLSTK_MIRROR', '2026-06-01'::varchar, 'SIZ_000324', NULL::text, NULL::text, NULL::int, NULL::int, 1::int, 11000::numeric, '미러아크릴스티커 290x90 mm 완제품가 (PRD_000143, 색상 골드/실버 동일가→단일행 mat 무관, 라이브 siz 290x90=SIZ_000324 재사용, 완제품비.06, src B27 r296)'),
  (46::int, 'COMP_POSTER_ACRYLSTK_MIRROR', '2026-06-01'::varchar, 'SIZ_000325', NULL::text, NULL::text, NULL::int, NULL::int, 1::int, 18000::numeric, '미러아크릴스티커 290x190 mm 완제품가 (PRD_000143, 색상 골드/실버 동일가→단일행, 라이브 siz 290x190=SIZ_000325 재사용, 완제품비.06, src B27 r296)'),
  (47::int, 'COMP_POSTER_ACRYLSTK_MIRROR', '2026-06-01'::varchar, 'SIZ_000326', NULL::text, NULL::text, NULL::int, NULL::int, 1::int, 29000::numeric, '미러아크릴스티커 390x290 mm 완제품가 (PRD_000143, 색상 골드/실버 동일가→단일행, 라이브 siz 390x290=SIZ_000326 재사용, 완제품비.06, src B27 r296)'),
  (48::int, 'COMP_POSTER_ACRYLSTK_MIRROR', '2026-06-01'::varchar, 'SIZ_000327', NULL::text, NULL::text, NULL::int, NULL::int, 1::int, 50000::numeric, '미러아크릴스티커 590x390 mm 완제품가 (PRD_000143, 색상 골드/실버 동일가→단일행, 라이브 siz 590x390=SIZ_000327 재사용, 완제품비.06, src B27 r296)'),
  (49::int, 'COMP_POSTER_MINI_STANDBOARD', '2026-06-01'::varchar, 'SIZ_000426', NULL::text, NULL::text, NULL::int, NULL::int, 4::int, 3500::numeric, '미니보드스탠딩 A5 수량≥4 완제품가[출력+코팅+가공(보드접착+거치대) 포함가] (PRD_000144, 라이브 siz A5=SIZ_000426 재사용, 완제품비.06, src B29)'),
  (50::int, 'COMP_POSTER_MINI_STANDBOARD', '2026-06-01'::varchar, 'SIZ_000258', NULL::text, NULL::text, NULL::int, NULL::int, 4::int, 4500::numeric, '미니보드스탠딩 A4 수량≥4 완제품가[출력+코팅+가공(보드접착+거치대) 포함가] (PRD_000144, 라이브 siz A4=SIZ_000258 재사용, 완제품비.06, src B29)'),
  (51::int, 'COMP_POSTER_MINI_STANDBOARD', '2026-06-01'::varchar, 'SIZ_000315', NULL::text, NULL::text, NULL::int, NULL::int, 4::int, 6500::numeric, '미니보드스탠딩 A3 수량≥4 완제품가[출력+코팅+가공(보드접착+거치대) 포함가] (PRD_000144, 라이브 siz A3=SIZ_000315 재사용, 완제품비.06, src B29)'),
  (52::int, 'COMP_POSTER_MINI_STANDBOARD', '2026-06-01'::varchar, 'SIZ_000426', NULL::text, NULL::text, NULL::int, NULL::int, 19::int, 3400::numeric, '미니보드스탠딩 A5 수량≥19 완제품가[보드접착+거치대 포함] (PRD_000144, 라이브 siz A5=SIZ_000426 재사용, 완제품비.06, src B29)'),
  (53::int, 'COMP_POSTER_MINI_STANDBOARD', '2026-06-01'::varchar, 'SIZ_000258', NULL::text, NULL::text, NULL::int, NULL::int, 19::int, 4300::numeric, '미니보드스탠딩 A4 수량≥19 완제품가[보드접착+거치대 포함] (PRD_000144, 라이브 siz A4=SIZ_000258 재사용, 완제품비.06, src B29)'),
  (54::int, 'COMP_POSTER_MINI_STANDBOARD', '2026-06-01'::varchar, 'SIZ_000315', NULL::text, NULL::text, NULL::int, NULL::int, 19::int, 6200::numeric, '미니보드스탠딩 A3 수량≥19 완제품가[보드접착+거치대 포함] (PRD_000144, 라이브 siz A3=SIZ_000315 재사용, 완제품비.06, src B29)'),
  (55::int, 'COMP_POSTER_MINI_STANDBOARD', '2026-06-01'::varchar, 'SIZ_000426', NULL::text, NULL::text, NULL::int, NULL::int, 49::int, 3300::numeric, '미니보드스탠딩 A5 수량≥49 완제품가[보드접착+거치대 포함] (PRD_000144, 라이브 siz A5=SIZ_000426 재사용, 완제품비.06, src B29)'),
  (56::int, 'COMP_POSTER_MINI_STANDBOARD', '2026-06-01'::varchar, 'SIZ_000258', NULL::text, NULL::text, NULL::int, NULL::int, 49::int, 4200::numeric, '미니보드스탠딩 A4 수량≥49 완제품가[보드접착+거치대 포함] (PRD_000144, 라이브 siz A4=SIZ_000258 재사용, 완제품비.06, src B29)'),
  (57::int, 'COMP_POSTER_MINI_STANDBOARD', '2026-06-01'::varchar, 'SIZ_000315', NULL::text, NULL::text, NULL::int, NULL::int, 49::int, 6100::numeric, '미니보드스탠딩 A3 수량≥49 완제품가[보드접착+거치대 포함] (PRD_000144, 라이브 siz A3=SIZ_000315 재사용, 완제품비.06, src B29)'),
  (58::int, 'COMP_POSTER_MINI_STANDBOARD', '2026-06-01'::varchar, 'SIZ_000426', NULL::text, NULL::text, NULL::int, NULL::int, 99::int, 3100::numeric, '미니보드스탠딩 A5 수량≥99 완제품가[보드접착+거치대 포함] (PRD_000144, 라이브 siz A5=SIZ_000426 재사용, 완제품비.06, src B29)'),
  (59::int, 'COMP_POSTER_MINI_STANDBOARD', '2026-06-01'::varchar, 'SIZ_000258', NULL::text, NULL::text, NULL::int, NULL::int, 99::int, 4000::numeric, '미니보드스탠딩 A4 수량≥99 완제품가[보드접착+거치대 포함] (PRD_000144, 라이브 siz A4=SIZ_000258 재사용, 완제품비.06, src B29)'),
  (60::int, 'COMP_POSTER_MINI_STANDBOARD', '2026-06-01'::varchar, 'SIZ_000315', NULL::text, NULL::text, NULL::int, NULL::int, 99::int, 5900::numeric, '미니보드스탠딩 A3 수량≥99 완제품가[보드접착+거치대 포함] (PRD_000144, 라이브 siz A3=SIZ_000315 재사용, 완제품비.06, src B29)'),
  (61::int, 'COMP_POSTER_MINI_STANDBOARD', '2026-06-01'::varchar, 'SIZ_000426', NULL::text, NULL::text, NULL::int, NULL::int, 10000::int, 2900::numeric, '미니보드스탠딩 A5 수량≥10000 완제품가[보드접착+거치대 포함] (PRD_000144, 라이브 siz A5=SIZ_000426 재사용, 완제품비.06, src B29)'),
  (62::int, 'COMP_POSTER_MINI_STANDBOARD', '2026-06-01'::varchar, 'SIZ_000258', NULL::text, NULL::text, NULL::int, NULL::int, 10000::int, 3800::numeric, '미니보드스탠딩 A4 수량≥10000 완제품가[보드접착+거치대 포함] (PRD_000144, 라이브 siz A4=SIZ_000258 재사용, 완제품비.06, src B29)'),
  (63::int, 'COMP_POSTER_MINI_STANDBOARD', '2026-06-01'::varchar, 'SIZ_000315', NULL::text, NULL::text, NULL::int, NULL::int, 10000::int, 5500::numeric, '미니보드스탠딩 A3 수량≥10000 완제품가[보드접착+거치대 포함] (PRD_000144, 라이브 siz A3=SIZ_000315 재사용, 완제품비.06, src B29)'),
  (64::int, 'COMP_POSTER_MINI_BANNER', '2026-06-01'::varchar, 'SIZ_000028', NULL::text, NULL::text, NULL::int, NULL::int, 4::int, 6500::numeric, '미니배너 150x300 mm 수량≥4 완제품가[출력+코팅+거치대 포함가] (PRD_000145, 라이브 siz 150x300=SIZ_000028 재사용, 완제품비.06, src B31)'),
  (65::int, 'COMP_POSTER_MINI_BANNER', '2026-06-01'::varchar, 'SIZ_000328', NULL::text, NULL::text, NULL::int, NULL::int, 4::int, 6500::numeric, '미니배너 180x420 mm 수량≥4 완제품가[출력+코팅+거치대 포함가] (PRD_000145, 라이브 siz 180x420=SIZ_000328 재사용, 완제품비.06, src B31)'),
  (66::int, 'COMP_POSTER_MINI_BANNER', '2026-06-01'::varchar, 'SIZ_000028', NULL::text, NULL::text, NULL::int, NULL::int, 19::int, 4900::numeric, '미니배너 150x300 mm 수량≥19 완제품가[출력+코팅+거치대 포함가] (PRD_000145, 라이브 siz 150x300=SIZ_000028 재사용, 완제품비.06, src B31)'),
  (67::int, 'COMP_POSTER_MINI_BANNER', '2026-06-01'::varchar, 'SIZ_000328', NULL::text, NULL::text, NULL::int, NULL::int, 19::int, 4900::numeric, '미니배너 180x420 mm 수량≥19 완제품가[출력+코팅+거치대 포함가] (PRD_000145, 라이브 siz 180x420=SIZ_000328 재사용, 완제품비.06, src B31)'),
  (68::int, 'COMP_POSTER_MINI_BANNER', '2026-06-01'::varchar, 'SIZ_000028', NULL::text, NULL::text, NULL::int, NULL::int, 49::int, 4200::numeric, '미니배너 150x300 mm 수량≥49 완제품가[출력+코팅+거치대 포함가] (PRD_000145, 라이브 siz 150x300=SIZ_000028 재사용, 완제품비.06, src B31)'),
  (69::int, 'COMP_POSTER_MINI_BANNER', '2026-06-01'::varchar, 'SIZ_000328', NULL::text, NULL::text, NULL::int, NULL::int, 49::int, 4200::numeric, '미니배너 180x420 mm 수량≥49 완제품가[출력+코팅+거치대 포함가] (PRD_000145, 라이브 siz 180x420=SIZ_000328 재사용, 완제품비.06, src B31)'),
  (70::int, 'COMP_POSTER_MINI_BANNER', '2026-06-01'::varchar, 'SIZ_000028', NULL::text, NULL::text, NULL::int, NULL::int, 99::int, 3500::numeric, '미니배너 150x300 mm 수량≥99 완제품가[출력+코팅+거치대 포함가] (PRD_000145, 라이브 siz 150x300=SIZ_000028 재사용, 완제품비.06, src B31)'),
  (71::int, 'COMP_POSTER_MINI_BANNER', '2026-06-01'::varchar, 'SIZ_000328', NULL::text, NULL::text, NULL::int, NULL::int, 99::int, 3500::numeric, '미니배너 180x420 mm 수량≥99 완제품가[출력+코팅+거치대 포함가] (PRD_000145, 라이브 siz 180x420=SIZ_000328 재사용, 완제품비.06, src B31)'),
  (72::int, 'COMP_POSTER_MINI_BANNER', '2026-06-01'::varchar, 'SIZ_000028', NULL::text, NULL::text, NULL::int, NULL::int, 10000::int, 2800::numeric, '미니배너 150x300 mm 수량≥10000 완제품가[출력+코팅+거치대 포함가] (PRD_000145, 라이브 siz 150x300=SIZ_000028 재사용, 완제품비.06, src B31)'),
  (73::int, 'COMP_POSTER_MINI_BANNER', '2026-06-01'::varchar, 'SIZ_000328', NULL::text, NULL::text, NULL::int, NULL::int, 10000::int, 2800::numeric, '미니배너 180x420 mm 수량≥10000 완제품가[출력+코팅+거치대 포함가] (PRD_000145, 라이브 siz 180x420=SIZ_000328 재사용, 완제품비.06, src B31)')
) AS v(rn, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
ON CONFLICT (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty) DO NOTHING;

-- ---------------------------------------------------------------------
-- STEP 4 (정정 핵심): 15상품 재바인딩
--   PRF_POSTER_FIXED(오바인딩) DELETE → 상품별 고정가형 바인딩 INSERT.
--   면적형 13상품은 PRF_POSTER_FIXED 유지 — 본 마이그레이션 미포함.
-- ---------------------------------------------------------------------
DELETE FROM t_prd_product_price_formulas WHERE prd_cd IN ('PRD_000129', 'PRD_000130', 'PRD_000131', 'PRD_000132', 'PRD_000133', 'PRD_000134', 'PRD_000135', 'PRD_000136', 'PRD_000137', 'PRD_000140', 'PRD_000141', 'PRD_000142', 'PRD_000143', 'PRD_000144', 'PRD_000145') AND frm_cd='PRF_POSTER_FIXED';

INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note, reg_dt) VALUES ('PRD_000129', 'PRF_FOAMBOARD_FIXED', '2026-06-01', '폼보드→고정가형 바인딩. PRF_POSTER_FIXED 오바인딩 대체(apply_bgn_ymd=2026-06-01 메모)', now()) ON CONFLICT (prd_cd, frm_cd) DO NOTHING;
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note, reg_dt) VALUES ('PRD_000130', 'PRF_FOMEXBOARD_FIXED', '2026-06-01', '포맥스보드→고정가형 바인딩. PRF_POSTER_FIXED 오바인딩 대체', now()) ON CONFLICT (prd_cd, frm_cd) DO NOTHING;
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note, reg_dt) VALUES ('PRD_000131', 'PRF_FRAMELESS_WOOD_FIXED', '2026-06-01', '프레임리스우드액자→고정가형 바인딩', now()) ON CONFLICT (prd_cd, frm_cd) DO NOTHING;
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note, reg_dt) VALUES ('PRD_000132', 'PRF_LEATHER_FRAME_FIXED', '2026-06-01', '레더아트액자→고정가형 바인딩', now()) ON CONFLICT (prd_cd, frm_cd) DO NOTHING;
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note, reg_dt) VALUES ('PRD_000133', 'PRF_CANVAS_HANGING_FIXED', '2026-06-01', '캔버스행잉포스터→고정가형 바인딩', now()) ON CONFLICT (prd_cd, frm_cd) DO NOTHING;
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note, reg_dt) VALUES ('PRD_000134', 'PRF_LINEN_WOODBONG_FIXED', '2026-06-01', '린넨우드봉족자→고정가형 바인딩', now()) ON CONFLICT (prd_cd, frm_cd) DO NOTHING;
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note, reg_dt) VALUES ('PRD_000135', 'PRF_JOKJA_FIXED', '2026-06-01', '족자포스터→고정가형 바인딩', now()) ON CONFLICT (prd_cd, frm_cd) DO NOTHING;
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note, reg_dt) VALUES ('PRD_000136', 'PRF_PET_BANNER_FIXED', '2026-06-01', 'PET배너→고정가형 바인딩', now()) ON CONFLICT (prd_cd, frm_cd) DO NOTHING;
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note, reg_dt) VALUES ('PRD_000137', 'PRF_MESH_BANNER_FIXED', '2026-06-01', '메쉬배너→고정가형 바인딩', now()) ON CONFLICT (prd_cd, frm_cd) DO NOTHING;
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note, reg_dt) VALUES ('PRD_000140', 'PRF_SHEETCUT_MATTE_FIXED', '2026-06-01', '무광시트커팅→고정가형 바인딩', now()) ON CONFLICT (prd_cd, frm_cd) DO NOTHING;
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note, reg_dt) VALUES ('PRD_000141', 'PRF_SHEETCUT_HOLO_FIXED', '2026-06-01', '홀로그램 시트커팅→고정가형 바인딩', now()) ON CONFLICT (prd_cd, frm_cd) DO NOTHING;
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note, reg_dt) VALUES ('PRD_000142', 'PRF_ACRYLSTK_GLOSS_FIXED', '2026-06-01', '유광아크릴스티커→고정가형 바인딩', now()) ON CONFLICT (prd_cd, frm_cd) DO NOTHING;
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note, reg_dt) VALUES ('PRD_000143', 'PRF_ACRYLSTK_MIRROR_FIXED', '2026-06-01', '미러아크릴스티커→고정가형 바인딩', now()) ON CONFLICT (prd_cd, frm_cd) DO NOTHING;
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note, reg_dt) VALUES ('PRD_000144', 'PRF_MINI_STANDBOARD_FIXED', '2026-06-01', '미니보드스탠딩→고정가형 바인딩', now()) ON CONFLICT (prd_cd, frm_cd) DO NOTHING;
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note, reg_dt) VALUES ('PRD_000145', 'PRF_MINI_BANNER_FIXED', '2026-06-01', '미니배너→고정가형 바인딩', now()) ON CONFLICT (prd_cd, frm_cd) DO NOTHING;

-- 사후 가드: 15상품이 각각 정확히 1개의 고정가형 바인딩을 갖는지 확인
DO $$
DECLARE n int;
BEGIN
  SELECT count(*) INTO n FROM t_prd_product_price_formulas
   WHERE prd_cd IN ('PRD_000129', 'PRD_000130', 'PRD_000131', 'PRD_000132', 'PRD_000133', 'PRD_000134', 'PRD_000135', 'PRD_000136', 'PRD_000137', 'PRD_000140', 'PRD_000141', 'PRD_000142', 'PRD_000143', 'PRD_000144', 'PRD_000145') AND frm_cd IN ('PRF_FOAMBOARD_FIXED', 'PRF_FOMEXBOARD_FIXED', 'PRF_FRAMELESS_WOOD_FIXED', 'PRF_LEATHER_FRAME_FIXED', 'PRF_CANVAS_HANGING_FIXED', 'PRF_LINEN_WOODBONG_FIXED', 'PRF_JOKJA_FIXED', 'PRF_PET_BANNER_FIXED', 'PRF_MESH_BANNER_FIXED', 'PRF_SHEETCUT_MATTE_FIXED', 'PRF_SHEETCUT_HOLO_FIXED', 'PRF_ACRYLSTK_GLOSS_FIXED', 'PRF_ACRYLSTK_MIRROR_FIXED', 'PRF_MINI_STANDBOARD_FIXED', 'PRF_MINI_BANNER_FIXED');
  IF n <> 15 THEN
    RAISE EXCEPTION '사후 가드 실패: 고정가형 바인딩이 15가 아님 (실제 %).', n;
  END IF;
  SELECT count(*) INTO n FROM t_prd_product_price_formulas
   WHERE prd_cd IN ('PRD_000129', 'PRD_000130', 'PRD_000131', 'PRD_000132', 'PRD_000133', 'PRD_000134', 'PRD_000135', 'PRD_000136', 'PRD_000137', 'PRD_000140', 'PRD_000141', 'PRD_000142', 'PRD_000143', 'PRD_000144', 'PRD_000145') AND frm_cd='PRF_POSTER_FIXED';
  IF n <> 0 THEN
    RAISE EXCEPTION '사후 가드 실패: PRF_POSTER_FIXED 잔존 바인딩 % 건.', n;
  END IF;
END $$;

-- 영향 카운트 리포트
SELECT '고정가형 바인딩' AS metric, count(*) AS cnt FROM t_prd_product_price_formulas WHERE frm_cd IN ('PRF_FOAMBOARD_FIXED', 'PRF_FOMEXBOARD_FIXED', 'PRF_FRAMELESS_WOOD_FIXED', 'PRF_LEATHER_FRAME_FIXED', 'PRF_CANVAS_HANGING_FIXED', 'PRF_LINEN_WOODBONG_FIXED', 'PRF_JOKJA_FIXED', 'PRF_PET_BANNER_FIXED', 'PRF_MESH_BANNER_FIXED', 'PRF_SHEETCUT_MATTE_FIXED', 'PRF_SHEETCUT_HOLO_FIXED', 'PRF_ACRYLSTK_GLOSS_FIXED', 'PRF_ACRYLSTK_MIRROR_FIXED', 'PRF_MINI_STANDBOARD_FIXED', 'PRF_MINI_BANNER_FIXED')
UNION ALL SELECT 'component_prices(17 comp)', count(*) FROM t_prc_component_prices WHERE comp_cd IN ('COMP_FOAMBOARD_BLACK', 'COMP_FOAMBOARD_WHITE', 'COMP_FOMEXBOARD_BLACK', 'COMP_FOMEXBOARD_WHITE', 'COMP_POSTER_ACRYLSTK_GLOSS', 'COMP_POSTER_ACRYLSTK_MIRROR', 'COMP_POSTER_CANVAS_HANGING', 'COMP_POSTER_FRAMELESS_WOOD', 'COMP_POSTER_JOKJA', 'COMP_POSTER_LEATHER_FRAME', 'COMP_POSTER_LINEN_WOODBONG', 'COMP_POSTER_MESH_BANNER', 'COMP_POSTER_MINI_BANNER', 'COMP_POSTER_MINI_STANDBOARD', 'COMP_POSTER_PET_BANNER', 'COMP_POSTER_SHEETCUT_HOLO', 'COMP_POSTER_SHEETCUT_MATTE')
UNION ALL SELECT 'price_formulas(신규15)', count(*) FROM t_prc_price_formulas WHERE frm_cd IN ('PRF_FOAMBOARD_FIXED', 'PRF_FOMEXBOARD_FIXED', 'PRF_FRAMELESS_WOOD_FIXED', 'PRF_LEATHER_FRAME_FIXED', 'PRF_CANVAS_HANGING_FIXED', 'PRF_LINEN_WOODBONG_FIXED', 'PRF_JOKJA_FIXED', 'PRF_PET_BANNER_FIXED', 'PRF_MESH_BANNER_FIXED', 'PRF_SHEETCUT_MATTE_FIXED', 'PRF_SHEETCUT_HOLO_FIXED', 'PRF_ACRYLSTK_GLOSS_FIXED', 'PRF_ACRYLSTK_MIRROR_FIXED', 'PRF_MINI_STANDBOARD_FIXED', 'PRF_MINI_BANNER_FIXED');

COMMIT;
