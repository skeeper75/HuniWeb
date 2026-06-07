-- =====================================================================
-- 01_plate_correction_guk4.sql
--   국4절(316x467) 31상품 plate 교정: 작업사이즈 중복행 DELETE → SIZ_000499 1행 INSERT
--   PRD_000016(프리미엄엽서)=SIZ_000499 1행 이미 정답 → KEEP (작업사이즈 목록에 없어 DELETE 대상 외)
--   생성: gen_migrate_sql.py (손편집 금지). 권위=plate-load-products.csv + 라이브 검증.
-- =====================================================================

-- [G-6 반영] DELETE = prd_cd IN(31교정) AND siz_cd IN(작업사이즈 70종) 동시 한정.
--   prd_cd 한정 누락 시 비교정(non-corr) 제품의 PRESERVE siz plate 손실 위험 → 반드시 양조건.
--   작업사이즈 siz 목록 = 31상품이 참조하던 SIZ_000499 외 전 siz(70 distinct, 101행).
--   SIZ_000499 는 작업사이즈 목록에 없으므로 PRD_000016 KEEP 행 자동 보존.

DELETE FROM t_prd_product_plate_sizes
WHERE prd_cd IN ('PRD_000017','PRD_000018','PRD_000020','PRD_000021','PRD_000022','PRD_000023','PRD_000024','PRD_000026','PRD_000027','PRD_000028','PRD_000029','PRD_000031','PRD_000032','PRD_000033','PRD_000034','PRD_000035','PRD_000036','PRD_000038','PRD_000040','PRD_000041','PRD_000042','PRD_000043','PRD_000044','PRD_000045','PRD_000046','PRD_000047','PRD_000048','PRD_000108','PRD_000109','PRD_000110','PRD_000111')
  AND siz_cd <> 'SIZ_000499'   -- 작업사이즈(중복판형)행만. 출력용지규격 SIZ_000499 보존
  AND del_yn = 'N';

-- [F-4 반영] dflt_plt_yn='Y' 명시 (NOT NULL·DEFAULT 없음).
-- [F-5/H-5 반영] output_paper_typ_cd='OUTPUT_PAPER_TYPE.01'(국전계열) 부여 = 기존 NULL/.03 의미 정정.
--   reg_dt NOT NULL DEFAULT now() → 컬럼 생략(DEFAULT 발화). del_yn DEFAULT 'N' → 생략.
INSERT INTO t_prd_product_plate_sizes (prd_cd, siz_cd, dflt_plt_yn, output_paper_typ_cd)
VALUES
  ('PRD_000017', 'SIZ_000499', 'Y', 'OUTPUT_PAPER_TYPE.01'),   -- 코팅엽서
  ('PRD_000018', 'SIZ_000499', 'Y', 'OUTPUT_PAPER_TYPE.01'),   -- 스탠다드엽서
  ('PRD_000020', 'SIZ_000499', 'Y', 'OUTPUT_PAPER_TYPE.01'),   -- 화이트인쇄엽서
  ('PRD_000021', 'SIZ_000499', 'Y', 'OUTPUT_PAPER_TYPE.01'),   -- 핑크별색엽서
  ('PRD_000022', 'SIZ_000499', 'Y', 'OUTPUT_PAPER_TYPE.01'),   -- 금은별색엽서
  ('PRD_000023', 'SIZ_000499', 'Y', 'OUTPUT_PAPER_TYPE.01'),   -- 모양엽서
  ('PRD_000024', 'SIZ_000499', 'Y', 'OUTPUT_PAPER_TYPE.01'),   -- 포토카드
  ('PRD_000026', 'SIZ_000499', 'Y', 'OUTPUT_PAPER_TYPE.01'),   -- 종이슬로건
  ('PRD_000027', 'SIZ_000499', 'Y', 'OUTPUT_PAPER_TYPE.01'),   -- 2단접지카드
  ('PRD_000028', 'SIZ_000499', 'Y', 'OUTPUT_PAPER_TYPE.01'),   -- 미니접지카드
  ('PRD_000029', 'SIZ_000499', 'Y', 'OUTPUT_PAPER_TYPE.01'),   -- 3단접지카드
  ('PRD_000031', 'SIZ_000499', 'Y', 'OUTPUT_PAPER_TYPE.01'),   -- 프리미엄명함
  ('PRD_000032', 'SIZ_000499', 'Y', 'OUTPUT_PAPER_TYPE.01'),   -- 코팅명함
  ('PRD_000033', 'SIZ_000499', 'Y', 'OUTPUT_PAPER_TYPE.01'),   -- 스탠다드명함
  ('PRD_000034', 'SIZ_000499', 'Y', 'OUTPUT_PAPER_TYPE.01'),   -- 펄명함
  ('PRD_000035', 'SIZ_000499', 'Y', 'OUTPUT_PAPER_TYPE.01'),   -- 모양명함
  ('PRD_000036', 'SIZ_000499', 'Y', 'OUTPUT_PAPER_TYPE.01'),   -- 미니모양명함
  ('PRD_000038', 'SIZ_000499', 'Y', 'OUTPUT_PAPER_TYPE.01'),   -- 형압명함
  ('PRD_000040', 'SIZ_000499', 'Y', 'OUTPUT_PAPER_TYPE.01'),   -- 화이트인쇄명함
  ('PRD_000041', 'SIZ_000499', 'Y', 'OUTPUT_PAPER_TYPE.01'),   -- 스탠다드 쿠폰/상품권
  ('PRD_000042', 'SIZ_000499', 'Y', 'OUTPUT_PAPER_TYPE.01'),   -- 프리미엄 쿠폰/상품권
  ('PRD_000043', 'SIZ_000499', 'Y', 'OUTPUT_PAPER_TYPE.01'),   -- 인쇄배경지(OPP봉투타입)
  ('PRD_000044', 'SIZ_000499', 'Y', 'OUTPUT_PAPER_TYPE.01'),   -- 인쇄배경지(투명케이스타입)
  ('PRD_000045', 'SIZ_000499', 'Y', 'OUTPUT_PAPER_TYPE.01'),   -- 인쇄헤더택
  ('PRD_000046', 'SIZ_000499', 'Y', 'OUTPUT_PAPER_TYPE.01'),   -- 라벨/택
  ('PRD_000047', 'SIZ_000499', 'Y', 'OUTPUT_PAPER_TYPE.01'),   -- 소량전단지
  ('PRD_000048', 'SIZ_000499', 'Y', 'OUTPUT_PAPER_TYPE.01'),   -- 접지리플렛
  ('PRD_000108', 'SIZ_000499', 'Y', 'OUTPUT_PAPER_TYPE.01'),   -- 탁상형캘린더
  ('PRD_000109', 'SIZ_000499', 'Y', 'OUTPUT_PAPER_TYPE.01'),   -- 미니탁상형캘린더
  ('PRD_000110', 'SIZ_000499', 'Y', 'OUTPUT_PAPER_TYPE.01'),   -- 엽서캘린더
  ('PRD_000111', 'SIZ_000499', 'Y', 'OUTPUT_PAPER_TYPE.01')   -- 벽걸이캘린더
ON CONFLICT (prd_cd, siz_cd) DO NOTHING;   -- [R1] 멱등: 2회차 0행(PK NOT NULL → 정상 발화)

