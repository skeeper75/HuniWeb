-- 판형사이즈 누락분 등록 + 상품 매핑 (멱등·롤백전용 DRY-RUN 호환)
-- 권위: 상품마스터260610 출력용지규격 + 가격표 판걸이수/출력소재(IMPORT)
-- search-before-mint 통과: 330x470·315x467 라이브 부재 확인(2026-06-22)
-- 마진 5mm = SIZ_000499(316x467 plate급) 하우스 컨벤션 계승

-- [1] 신규 전지 siz 2종 등록 (siz 먼저 — FK RESTRICT)
INSERT INTO t_siz_sizes
  (siz_cd, siz_nm, work_width, work_height, cut_width, cut_height,
   margin_top, margin_bot, margin_lft, margin_rgt, impos_yn, use_yn, note, del_yn, tags)
VALUES
  ('SIZ_000521','330x470',330,470,320,460,5,5,5,5,'Y','Y',
   '전지(46계열)·반칼 스티커 표준전지 / 출처: 상품마스터260610·출력소재IMPORT','N','["46전지"]'::jsonb),
  ('SIZ_000522','315x467',315,467,305,457,5,5,5,5,'Y','Y',
   '전지(국전계열)·투명소재 전지 / 출처: 상품마스터260610','N','["국전계열"]'::jsonb)
ON CONFLICT (siz_cd) DO NOTHING;

-- [2] 상품↔판형 매핑 (11×330x470 + 3×315x467) 멱등
INSERT INTO t_prd_product_plate_sizes (prd_cd, siz_cd, dflt_plt_yn, output_paper_typ_cd, del_yn)
VALUES
  -- 330x470 (46계열) 반칼 스티커 11종
  ('PRD_000052','SIZ_000521','Y','OUTPUT_PAPER_TYPE.02','N'),
  ('PRD_000053','SIZ_000521','Y','OUTPUT_PAPER_TYPE.02','N'),
  ('PRD_000054','SIZ_000521','Y','OUTPUT_PAPER_TYPE.02','N'),
  ('PRD_000058','SIZ_000521','Y','OUTPUT_PAPER_TYPE.02','N'),
  ('PRD_000059','SIZ_000521','Y','OUTPUT_PAPER_TYPE.02','N'),
  ('PRD_000060','SIZ_000521','Y','OUTPUT_PAPER_TYPE.02','N'),
  ('PRD_000061','SIZ_000521','Y','OUTPUT_PAPER_TYPE.02','N'),
  ('PRD_000062','SIZ_000521','Y','OUTPUT_PAPER_TYPE.02','N'),
  ('PRD_000063','SIZ_000521','Y','OUTPUT_PAPER_TYPE.02','N'),
  ('PRD_000064','SIZ_000521','Y','OUTPUT_PAPER_TYPE.02','N'),
  ('PRD_000065','SIZ_000521','Y','OUTPUT_PAPER_TYPE.02','N'),
  -- 315x467 (국전계열) 투명소재 3종
  ('PRD_000019','SIZ_000522','Y','OUTPUT_PAPER_TYPE.01','N'),
  ('PRD_000025','SIZ_000522','Y','OUTPUT_PAPER_TYPE.01','N'),
  ('PRD_000039','SIZ_000522','Y','OUTPUT_PAPER_TYPE.01','N')
ON CONFLICT (prd_cd, siz_cd) DO NOTHING;
