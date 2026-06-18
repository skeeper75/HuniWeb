-- round-24 2단계 · 롤백전용 DRY-RUN (dryrun-green.sql)
-- BEGIN … ROLLBACK — 실 변경 없이 INSERT/UPDATE 건수·제약위반 0·FK 고아 0 실측.
-- 사용: psql -f dryrun-green.sql (NOTICE로 집계 출력 후 전부 ROLLBACK).

BEGIN;

-- 적재 전 영향행 수
CREATE TEMP TABLE _before AS
  SELECT prd_cd, cat_cd, main_cat_yn FROM t_prd_product_categories
  WHERE prd_cd IN ('PRD_000016', 'PRD_000017', 'PRD_000018', 'PRD_000024', 'PRD_000025', 'PRD_000026', 'PRD_000027', 'PRD_000029', 'PRD_000031', 'PRD_000032', 'PRD_000033', 'PRD_000041', 'PRD_000042', 'PRD_000047', 'PRD_000052', 'PRD_000053', 'PRD_000055', 'PRD_000066', 'PRD_000068', 'PRD_000069', 'PRD_000071', 'PRD_000094', 'PRD_000118', 'PRD_000120', 'PRD_000121', 'PRD_000122', 'PRD_000124', 'PRD_000125', 'PRD_000133', 'PRD_000134', 'PRD_000135', 'PRD_000136', 'PRD_000137', 'PRD_000138', 'PRD_000139', 'PRD_000145');

-- [재배선 A] 본 적재 36 prd_cd 중, 비활성(del='Y') 노드를 가리키는 기존 junction 행 정리
--           (del_yn 권위: 논리삭제 노드 귀속은 조회 차단·orphan → 제거)
DELETE FROM t_prd_product_categories pc
USING t_cat_categories c
WHERE pc.cat_cd = c.cat_cd AND c.del_yn <> 'N'
  AND pc.prd_cd IN ('PRD_000016', 'PRD_000017', 'PRD_000018', 'PRD_000024', 'PRD_000025', 'PRD_000026', 'PRD_000027', 'PRD_000029', 'PRD_000031', 'PRD_000032', 'PRD_000033', 'PRD_000041', 'PRD_000042', 'PRD_000047', 'PRD_000052', 'PRD_000053', 'PRD_000055', 'PRD_000066', 'PRD_000068', 'PRD_000069', 'PRD_000071', 'PRD_000094', 'PRD_000118', 'PRD_000120', 'PRD_000121', 'PRD_000122', 'PRD_000124', 'PRD_000125', 'PRD_000133', 'PRD_000134', 'PRD_000135', 'PRD_000136', 'PRD_000137', 'PRD_000138', 'PRD_000139', 'PRD_000145');

-- [재배선 B] 본 적재 대표 cat_cd가 아닌 활성 노드 기존 행은 main='N'으로 강등
--           (대표는 가변깊이 적재 노드 1행만 main='Y' — 단일성 보장)
UPDATE t_prd_product_categories pc SET main_cat_yn='N', upd_dt=now()
FROM (VALUES
  ('PRD_000016', 'CAT_000307'),
  ('PRD_000017', 'CAT_000307'),
  ('PRD_000018', 'CAT_000307'),
  ('PRD_000024', 'CAT_000001'),
  ('PRD_000025', 'CAT_000001'),
  ('PRD_000026', 'CAT_000001'),
  ('PRD_000027', 'CAT_000021'),
  ('PRD_000029', 'CAT_000021'),
  ('PRD_000031', 'CAT_000003'),
  ('PRD_000032', 'CAT_000003'),
  ('PRD_000033', 'CAT_000003'),
  ('PRD_000041', 'CAT_000062'),
  ('PRD_000042', 'CAT_000062'),
  ('PRD_000047', 'CAT_000058'),
  ('PRD_000052', 'CAT_000002'),
  ('PRD_000053', 'CAT_000002'),
  ('PRD_000055', 'CAT_000002'),
  ('PRD_000066', 'CAT_000002'),
  ('PRD_000068', 'CAT_000006'),
  ('PRD_000069', 'CAT_000006'),
  ('PRD_000071', 'CAT_000006'),
  ('PRD_000094', 'CAT_000308'),
  ('PRD_000118', 'CAT_000076'),
  ('PRD_000120', 'CAT_000004'),
  ('PRD_000121', 'CAT_000004'),
  ('PRD_000122', 'CAT_000004'),
  ('PRD_000124', 'CAT_000072'),
  ('PRD_000125', 'CAT_000072'),
  ('PRD_000133', 'CAT_000004'),
  ('PRD_000134', 'CAT_000004'),
  ('PRD_000135', 'CAT_000004'),
  ('PRD_000136', 'CAT_000005'),
  ('PRD_000137', 'CAT_000005'),
  ('PRD_000138', 'CAT_000005'),
  ('PRD_000139', 'CAT_000005'),
  ('PRD_000145', 'CAT_000005')
) AS t(prd_cd, tgt_cat) 
WHERE pc.prd_cd = t.prd_cd AND pc.cat_cd <> t.tgt_cat AND pc.main_cat_yn='Y';

-- 본 적재(apply-green.sql 본문과 동일한 UPSERT)
INSERT INTO t_prd_product_categories (prd_cd, cat_cd, main_cat_yn, disp_seq, reg_dt)
VALUES
  ('PRD_000024', 'CAT_000001', 'Y', 1, now()),  -- 포토카드 → 엽서/카드
  ('PRD_000025', 'CAT_000001', 'Y', 2, now()),  -- 투명포토카드 → 엽서/카드
  ('PRD_000026', 'CAT_000001', 'Y', 3, now()),  -- 종이슬로건 → 엽서/카드
  ('PRD_000052', 'CAT_000002', 'Y', 1, now()),  -- 반칼 자유형 스티커 → 스티커
  ('PRD_000053', 'CAT_000002', 'Y', 2, now()),  -- 반칼 자유형 투명스티커 → 스티커
  ('PRD_000055', 'CAT_000002', 'Y', 3, now()),  -- 낱장 자유형 스티커 → 스티커
  ('PRD_000066', 'CAT_000002', 'Y', 4, now()),  -- 합판도무송스티커 → 스티커
  ('PRD_000031', 'CAT_000003', 'Y', 1, now()),  -- 프리미엄명함 → 인쇄홍보물
  ('PRD_000032', 'CAT_000003', 'Y', 2, now()),  -- 코팅명함 → 인쇄홍보물
  ('PRD_000033', 'CAT_000003', 'Y', 3, now()),  -- 스탠다드명함 → 인쇄홍보물
  ('PRD_000120', 'CAT_000004', 'Y', 1, now()),  -- 방수포스터 → 포스터
  ('PRD_000121', 'CAT_000004', 'Y', 2, now()),  -- 접착방수포스터 → 포스터
  ('PRD_000122', 'CAT_000004', 'Y', 3, now()),  -- 접착투명포스터 → 포스터
  ('PRD_000133', 'CAT_000004', 'Y', 4, now()),  -- 캔버스행잉포스터 → 포스터
  ('PRD_000134', 'CAT_000004', 'Y', 5, now()),  -- 린넨 우드봉족자 → 포스터
  ('PRD_000135', 'CAT_000004', 'Y', 6, now()),  -- 족자포스터 → 포스터
  ('PRD_000136', 'CAT_000005', 'Y', 1, now()),  -- PET배너 → 사인
  ('PRD_000137', 'CAT_000005', 'Y', 2, now()),  -- 메쉬배너 → 사인
  ('PRD_000138', 'CAT_000005', 'Y', 3, now()),  -- 일반현수막 → 사인
  ('PRD_000139', 'CAT_000005', 'Y', 4, now()),  -- 메쉬현수막 → 사인
  ('PRD_000145', 'CAT_000005', 'Y', 5, now()),  -- 미니배너 → 사인
  ('PRD_000068', 'CAT_000006', 'Y', 1, now()),  -- 중철책자 → 책자
  ('PRD_000069', 'CAT_000006', 'Y', 2, now()),  -- 무선책자 → 책자
  ('PRD_000071', 'CAT_000006', 'Y', 3, now()),  -- 트윈링책자 → 책자
  ('PRD_000027', 'CAT_000021', 'Y', 1, now()),  -- 2단접지카드 → 접지카드
  ('PRD_000029', 'CAT_000021', 'Y', 2, now()),  -- 3단접지카드 → 접지카드
  ('PRD_000047', 'CAT_000058', 'Y', 1, now()),  -- 소량전단지 → 전단지/리플랫
  ('PRD_000041', 'CAT_000062', 'Y', 1, now()),  -- 스탠다드 쿠폰/상품권 → 쿠폰/상품권
  ('PRD_000042', 'CAT_000062', 'Y', 2, now()),  -- 프리미엄 상품권/쿠폰 → 쿠폰/상품권
  ('PRD_000124', 'CAT_000072', 'Y', 1, now()),  -- 린넨패브릭포스터 → 패브릭포스터
  ('PRD_000125', 'CAT_000072', 'Y', 2, now()),  -- 캔버스패브릭포스터 → 패브릭포스터
  ('PRD_000118', 'CAT_000076', 'Y', 1, now()),  -- 아트프린트포스터 → 아트프린트
  ('PRD_000016', 'CAT_000307', 'Y', 1, now()),  -- 프리미엄엽서 → 엽서
  ('PRD_000017', 'CAT_000307', 'Y', 2, now()),  -- 코팅엽서 → 엽서
  ('PRD_000018', 'CAT_000307', 'Y', 3, now()),  -- 스탠다드엽서 → 엽서
  ('PRD_000094', 'CAT_000308', 'Y', 1, now())  -- 엽서북 → 엽서북
ON CONFLICT (prd_cd, cat_cd) DO UPDATE SET
  main_cat_yn = EXCLUDED.main_cat_yn,
  disp_seq    = EXCLUDED.disp_seq,
  upd_dt      = now();

-- 집계: 신규 INSERT vs 기존 UPDATE 추정
DO $$
DECLARE total int; pre int; ins int; upd int; orphan_cat int; orphan_prd int; mainviol int;
BEGIN
  SELECT count(*) INTO total FROM t_prd_product_categories
    WHERE prd_cd IN ('PRD_000016', 'PRD_000017', 'PRD_000018', 'PRD_000024', 'PRD_000025', 'PRD_000026', 'PRD_000027', 'PRD_000029', 'PRD_000031', 'PRD_000032', 'PRD_000033', 'PRD_000041', 'PRD_000042', 'PRD_000047', 'PRD_000052', 'PRD_000053', 'PRD_000055', 'PRD_000066', 'PRD_000068', 'PRD_000069', 'PRD_000071', 'PRD_000094', 'PRD_000118', 'PRD_000120', 'PRD_000121', 'PRD_000122', 'PRD_000124', 'PRD_000125', 'PRD_000133', 'PRD_000134', 'PRD_000135', 'PRD_000136', 'PRD_000137', 'PRD_000138', 'PRD_000139', 'PRD_000145')
      AND cat_cd IN ('CAT_000001', 'CAT_000002', 'CAT_000003', 'CAT_000004', 'CAT_000005', 'CAT_000006', 'CAT_000021', 'CAT_000058', 'CAT_000062', 'CAT_000072', 'CAT_000076', 'CAT_000307', 'CAT_000308');
  SELECT count(*) INTO pre FROM _before b
    WHERE (b.prd_cd, b.cat_cd) IN (
      ('PRD_000024', 'CAT_000001'),
      ('PRD_000025', 'CAT_000001'),
      ('PRD_000026', 'CAT_000001'),
      ('PRD_000052', 'CAT_000002'),
      ('PRD_000053', 'CAT_000002'),
      ('PRD_000055', 'CAT_000002'),
      ('PRD_000066', 'CAT_000002'),
      ('PRD_000031', 'CAT_000003'),
      ('PRD_000032', 'CAT_000003'),
      ('PRD_000033', 'CAT_000003'),
      ('PRD_000120', 'CAT_000004'),
      ('PRD_000121', 'CAT_000004'),
      ('PRD_000122', 'CAT_000004'),
      ('PRD_000133', 'CAT_000004'),
      ('PRD_000134', 'CAT_000004'),
      ('PRD_000135', 'CAT_000004'),
      ('PRD_000136', 'CAT_000005'),
      ('PRD_000137', 'CAT_000005'),
      ('PRD_000138', 'CAT_000005'),
      ('PRD_000139', 'CAT_000005'),
      ('PRD_000145', 'CAT_000005'),
      ('PRD_000068', 'CAT_000006'),
      ('PRD_000069', 'CAT_000006'),
      ('PRD_000071', 'CAT_000006'),
      ('PRD_000027', 'CAT_000021'),
      ('PRD_000029', 'CAT_000021'),
      ('PRD_000047', 'CAT_000058'),
      ('PRD_000041', 'CAT_000062'),
      ('PRD_000042', 'CAT_000062'),
      ('PRD_000124', 'CAT_000072'),
      ('PRD_000125', 'CAT_000072'),
      ('PRD_000118', 'CAT_000076'),
      ('PRD_000016', 'CAT_000307'),
      ('PRD_000017', 'CAT_000307'),
      ('PRD_000018', 'CAT_000307'),
      ('PRD_000094', 'CAT_000308')
    );
  ins := 36 - pre;
  upd := pre;
  total := total;  -- noqa (참조용)
  -- FK 고아: 적재된 (prd,cat) 중 노드/상품 미존재
  SELECT count(*) INTO orphan_cat FROM t_prd_product_categories pc
    LEFT JOIN t_cat_categories c ON c.cat_cd=pc.cat_cd
    WHERE pc.cat_cd IN ('CAT_000001', 'CAT_000002', 'CAT_000003', 'CAT_000004', 'CAT_000005', 'CAT_000006', 'CAT_000021', 'CAT_000058', 'CAT_000062', 'CAT_000072', 'CAT_000076', 'CAT_000307', 'CAT_000308') AND c.cat_cd IS NULL;
  SELECT count(*) INTO orphan_prd FROM t_prd_product_categories pc
    LEFT JOIN t_prd_products p ON p.prd_cd=pc.prd_cd
    WHERE pc.prd_cd IN ('PRD_000016', 'PRD_000017', 'PRD_000018', 'PRD_000024', 'PRD_000025', 'PRD_000026', 'PRD_000027', 'PRD_000029', 'PRD_000031', 'PRD_000032', 'PRD_000033', 'PRD_000041', 'PRD_000042', 'PRD_000047', 'PRD_000052', 'PRD_000053', 'PRD_000055', 'PRD_000066', 'PRD_000068', 'PRD_000069', 'PRD_000071', 'PRD_000094', 'PRD_000118', 'PRD_000120', 'PRD_000121', 'PRD_000122', 'PRD_000124', 'PRD_000125', 'PRD_000133', 'PRD_000134', 'PRD_000135', 'PRD_000136', 'PRD_000137', 'PRD_000138', 'PRD_000139', 'PRD_000145') AND p.prd_cd IS NULL;
  -- del='Y' 노드 귀속 0
  SELECT count(*) INTO orphan_cat FROM t_prd_product_categories pc
    JOIN t_cat_categories c ON c.cat_cd=pc.cat_cd
    WHERE pc.prd_cd IN ('PRD_000016', 'PRD_000017', 'PRD_000018', 'PRD_000024', 'PRD_000025', 'PRD_000026', 'PRD_000027', 'PRD_000029', 'PRD_000031', 'PRD_000032', 'PRD_000033', 'PRD_000041', 'PRD_000042', 'PRD_000047', 'PRD_000052', 'PRD_000053', 'PRD_000055', 'PRD_000066', 'PRD_000068', 'PRD_000069', 'PRD_000071', 'PRD_000094', 'PRD_000118', 'PRD_000120', 'PRD_000121', 'PRD_000122', 'PRD_000124', 'PRD_000125', 'PRD_000133', 'PRD_000134', 'PRD_000135', 'PRD_000136', 'PRD_000137', 'PRD_000138', 'PRD_000139', 'PRD_000145')
      AND pc.cat_cd IN ('CAT_000001', 'CAT_000002', 'CAT_000003', 'CAT_000004', 'CAT_000005', 'CAT_000006', 'CAT_000021', 'CAT_000058', 'CAT_000062', 'CAT_000072', 'CAT_000076', 'CAT_000307', 'CAT_000308')
      AND c.del_yn <> 'N';
  SELECT count(*) INTO mainviol FROM (
    SELECT prd_cd FROM t_prd_product_categories
      WHERE prd_cd IN ('PRD_000016', 'PRD_000017', 'PRD_000018', 'PRD_000024', 'PRD_000025', 'PRD_000026', 'PRD_000027', 'PRD_000029', 'PRD_000031', 'PRD_000032', 'PRD_000033', 'PRD_000041', 'PRD_000042', 'PRD_000047', 'PRD_000052', 'PRD_000053', 'PRD_000055', 'PRD_000066', 'PRD_000068', 'PRD_000069', 'PRD_000071', 'PRD_000094', 'PRD_000118', 'PRD_000120', 'PRD_000121', 'PRD_000122', 'PRD_000124', 'PRD_000125', 'PRD_000133', 'PRD_000134', 'PRD_000135', 'PRD_000136', 'PRD_000137', 'PRD_000138', 'PRD_000139', 'PRD_000145') AND main_cat_yn='Y'
      GROUP BY prd_cd HAVING count(*)<>1) v;
  RAISE NOTICE 'DRY-RUN GREEN: 적재대상행 36, 기존존재 %, 추정 INSERT %, 추정 UPDATE %', pre, ins, upd;
  RAISE NOTICE '  FK고아(cat비활성/부재) %, FK고아(prd부재) %, main단일성위반 %', orphan_cat, orphan_prd, mainviol;
END $$;

ROLLBACK;
-- 전부 롤백 — 실 변경 없음. 위 NOTICE 집계로 적재가능성 판정.
