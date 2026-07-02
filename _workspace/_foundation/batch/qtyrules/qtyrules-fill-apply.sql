-- ============================================================
-- 제작수량(필수) 규칙 채움 — 사이즈 레벨 빈곳 UPDATE
-- 대상: t_prd_product_sizes (min_qty/max_qty/qty_incr)
-- 권위: 상품마스터 260702(제작수량 컬럼 260610과 동일) + 가격표 최소구간 가드
-- 멱등: 현재 3값 모두 NULL인 사이즈행만 채움(재실행 안전·기존값 미변경)
-- 라이브 쓰기는 인간 승인 후. dflt_qty는 mint 금지(비움).
-- ============================================================
-- ★ 실 COMMIT — 인간 승인 후에만 실행. webadmin 가격시뮬레이터 실화면 확인 후.
BEGIN;

-- 사이즈 빈곳 채움 (FILL 49건)
UPDATE t_prd_product_sizes SET min_qty=8, max_qty=10000, qty_incr=8 WHERE prd_cd='PRD_000016' AND siz_cd='SIZ_000003' AND del_yn='N' AND min_qty IS NULL AND max_qty IS NULL AND qty_incr IS NULL;  -- 프리미엄엽서 [100 x 150 mm]
UPDATE t_prd_product_sizes SET min_qty=6, max_qty=10000, qty_incr=6 WHERE prd_cd='PRD_000016' AND siz_cd='SIZ_000004' AND del_yn='N' AND min_qty IS NULL AND max_qty IS NULL AND qty_incr IS NULL;  -- 프리미엄엽서 [135 x 135 mm]
UPDATE t_prd_product_sizes SET min_qty=6, max_qty=10000, qty_incr=6 WHERE prd_cd='PRD_000016' AND siz_cd='SIZ_000005' AND del_yn='N' AND min_qty IS NULL AND max_qty IS NULL AND qty_incr IS NULL;  -- 프리미엄엽서 [95 x 210 mm]
UPDATE t_prd_product_sizes SET min_qty=4, max_qty=10000, qty_incr=4 WHERE prd_cd='PRD_000016' AND siz_cd='SIZ_000006' AND del_yn='N' AND min_qty IS NULL AND max_qty IS NULL AND qty_incr IS NULL;  -- 프리미엄엽서 [110 x 170 mm]
UPDATE t_prd_product_sizes SET min_qty=4, max_qty=10000, qty_incr=4 WHERE prd_cd='PRD_000016' AND siz_cd='SIZ_000007' AND del_yn='N' AND min_qty IS NULL AND max_qty IS NULL AND qty_incr IS NULL;  -- 프리미엄엽서 [148 x 210 mm]
UPDATE t_prd_product_sizes SET min_qty=12, max_qty=10000, qty_incr=12 WHERE prd_cd='PRD_000017' AND siz_cd='SIZ_000002' AND del_yn='N' AND min_qty IS NULL AND max_qty IS NULL AND qty_incr IS NULL;  -- 코팅엽서 [98 x 98 mm]
UPDATE t_prd_product_sizes SET min_qty=8, max_qty=10000, qty_incr=8 WHERE prd_cd='PRD_000017' AND siz_cd='SIZ_000003' AND del_yn='N' AND min_qty IS NULL AND max_qty IS NULL AND qty_incr IS NULL;  -- 코팅엽서 [100 x 150 mm]
UPDATE t_prd_product_sizes SET min_qty=6, max_qty=10000, qty_incr=6 WHERE prd_cd='PRD_000017' AND siz_cd='SIZ_000004' AND del_yn='N' AND min_qty IS NULL AND max_qty IS NULL AND qty_incr IS NULL;  -- 코팅엽서 [135 x 135 mm]
UPDATE t_prd_product_sizes SET min_qty=6, max_qty=10000, qty_incr=6 WHERE prd_cd='PRD_000017' AND siz_cd='SIZ_000005' AND del_yn='N' AND min_qty IS NULL AND max_qty IS NULL AND qty_incr IS NULL;  -- 코팅엽서 [95 x 210 mm]
UPDATE t_prd_product_sizes SET min_qty=4, max_qty=10000, qty_incr=4 WHERE prd_cd='PRD_000017' AND siz_cd='SIZ_000006' AND del_yn='N' AND min_qty IS NULL AND max_qty IS NULL AND qty_incr IS NULL;  -- 코팅엽서 [110 x 170 mm]
UPDATE t_prd_product_sizes SET min_qty=4, max_qty=10000, qty_incr=4 WHERE prd_cd='PRD_000017' AND siz_cd='SIZ_000007' AND del_yn='N' AND min_qty IS NULL AND max_qty IS NULL AND qty_incr IS NULL;  -- 코팅엽서 [148 x 210 mm]
UPDATE t_prd_product_sizes SET min_qty=12, max_qty=10000, qty_incr=12 WHERE prd_cd='PRD_000018' AND siz_cd='SIZ_000002' AND del_yn='N' AND min_qty IS NULL AND max_qty IS NULL AND qty_incr IS NULL;  -- 스탠다드엽서 [98 x 98 mm]
UPDATE t_prd_product_sizes SET min_qty=8, max_qty=10000, qty_incr=8 WHERE prd_cd='PRD_000018' AND siz_cd='SIZ_000003' AND del_yn='N' AND min_qty IS NULL AND max_qty IS NULL AND qty_incr IS NULL;  -- 스탠다드엽서 [100 x 150 mm]
UPDATE t_prd_product_sizes SET min_qty=6, max_qty=10000, qty_incr=6 WHERE prd_cd='PRD_000018' AND siz_cd='SIZ_000004' AND del_yn='N' AND min_qty IS NULL AND max_qty IS NULL AND qty_incr IS NULL;  -- 스탠다드엽서 [135 x 135 mm]
UPDATE t_prd_product_sizes SET min_qty=4, max_qty=10000, qty_incr=4 WHERE prd_cd='PRD_000018' AND siz_cd='SIZ_000007' AND del_yn='N' AND min_qty IS NULL AND max_qty IS NULL AND qty_incr IS NULL;  -- 스탠다드엽서 [148 x 210 mm]
UPDATE t_prd_product_sizes SET min_qty=8, max_qty=10000, qty_incr=8 WHERE prd_cd='PRD_000019' AND siz_cd='SIZ_000003' AND del_yn='N' AND min_qty IS NULL AND max_qty IS NULL AND qty_incr IS NULL;  -- 투명엽서 [100 x 150 mm]
UPDATE t_prd_product_sizes SET min_qty=6, max_qty=10000, qty_incr=6 WHERE prd_cd='PRD_000019' AND siz_cd='SIZ_000004' AND del_yn='N' AND min_qty IS NULL AND max_qty IS NULL AND qty_incr IS NULL;  -- 투명엽서 [135 x 135 mm]
UPDATE t_prd_product_sizes SET min_qty=4, max_qty=10000, qty_incr=4 WHERE prd_cd='PRD_000019' AND siz_cd='SIZ_000007' AND del_yn='N' AND min_qty IS NULL AND max_qty IS NULL AND qty_incr IS NULL;  -- 투명엽서 [148 x 210 mm]
UPDATE t_prd_product_sizes SET min_qty=8, max_qty=10000, qty_incr=8 WHERE prd_cd='PRD_000020' AND siz_cd='SIZ_000003' AND del_yn='N' AND min_qty IS NULL AND max_qty IS NULL AND qty_incr IS NULL;  -- 화이트인쇄엽서 [100 x 150 mm]
UPDATE t_prd_product_sizes SET min_qty=6, max_qty=10000, qty_incr=6 WHERE prd_cd='PRD_000020' AND siz_cd='SIZ_000004' AND del_yn='N' AND min_qty IS NULL AND max_qty IS NULL AND qty_incr IS NULL;  -- 화이트인쇄엽서 [135 x 135 mm]
UPDATE t_prd_product_sizes SET min_qty=4, max_qty=10000, qty_incr=4 WHERE prd_cd='PRD_000020' AND siz_cd='SIZ_000007' AND del_yn='N' AND min_qty IS NULL AND max_qty IS NULL AND qty_incr IS NULL;  -- 화이트인쇄엽서 [148 x 210 mm]
UPDATE t_prd_product_sizes SET min_qty=8, max_qty=10000, qty_incr=8 WHERE prd_cd='PRD_000021' AND siz_cd='SIZ_000003' AND del_yn='N' AND min_qty IS NULL AND max_qty IS NULL AND qty_incr IS NULL;  -- 핑크별색엽서 [100 x 150 mm]
UPDATE t_prd_product_sizes SET min_qty=6, max_qty=10000, qty_incr=6 WHERE prd_cd='PRD_000021' AND siz_cd='SIZ_000004' AND del_yn='N' AND min_qty IS NULL AND max_qty IS NULL AND qty_incr IS NULL;  -- 핑크별색엽서 [135 x 135 mm]
UPDATE t_prd_product_sizes SET min_qty=4, max_qty=10000, qty_incr=4 WHERE prd_cd='PRD_000021' AND siz_cd='SIZ_000007' AND del_yn='N' AND min_qty IS NULL AND max_qty IS NULL AND qty_incr IS NULL;  -- 핑크별색엽서 [148 x 210 mm]
UPDATE t_prd_product_sizes SET min_qty=8, max_qty=10000, qty_incr=8 WHERE prd_cd='PRD_000022' AND siz_cd='SIZ_000003' AND del_yn='N' AND min_qty IS NULL AND max_qty IS NULL AND qty_incr IS NULL;  -- 금은별색엽서 [100 x 150 mm]
UPDATE t_prd_product_sizes SET min_qty=6, max_qty=10000, qty_incr=6 WHERE prd_cd='PRD_000022' AND siz_cd='SIZ_000004' AND del_yn='N' AND min_qty IS NULL AND max_qty IS NULL AND qty_incr IS NULL;  -- 금은별색엽서 [135 x 135 mm]
UPDATE t_prd_product_sizes SET min_qty=4, max_qty=10000, qty_incr=4 WHERE prd_cd='PRD_000022' AND siz_cd='SIZ_000007' AND del_yn='N' AND min_qty IS NULL AND max_qty IS NULL AND qty_incr IS NULL;  -- 금은별색엽서 [148 x 210 mm]
UPDATE t_prd_product_sizes SET min_qty=2, max_qty=10000, qty_incr=2 WHERE prd_cd='PRD_000026' AND siz_cd='SIZ_000016' AND del_yn='N' AND min_qty IS NULL AND max_qty IS NULL AND qty_incr IS NULL;  -- 종이슬로건 [400 x 145 mm]
UPDATE t_prd_product_sizes SET min_qty=10, max_qty=10000, qty_incr=10 WHERE prd_cd='PRD_000041' AND siz_cd='SIZ_000014' AND del_yn='N' AND min_qty IS NULL AND max_qty IS NULL AND qty_incr IS NULL;  -- 스탠다드 쿠폰/상품권 [148 x 75 mm]
UPDATE t_prd_product_sizes SET min_qty=10, max_qty=10000, qty_incr=10 WHERE prd_cd='PRD_000042' AND siz_cd='SIZ_000014' AND del_yn='N' AND min_qty IS NULL AND max_qty IS NULL AND qty_incr IS NULL;  -- 프리미엄 쿠폰/상품권 [148 x 75 mm]
UPDATE t_prd_product_sizes SET min_qty=4, max_qty=10000, qty_incr=4 WHERE prd_cd='PRD_000052' AND siz_cd='SIZ_000170' AND del_yn='N' AND min_qty IS NULL AND max_qty IS NULL AND qty_incr IS NULL;  -- 반칼 자유형 스티커 [A5 (148 x 210 mm)]
UPDATE t_prd_product_sizes SET min_qty=2, max_qty=10000, qty_incr=2 WHERE prd_cd='PRD_000052' AND siz_cd='SIZ_000520' AND del_yn='N' AND min_qty IS NULL AND max_qty IS NULL AND qty_incr IS NULL;  -- 반칼 자유형 스티커 [A4 (210 x 297 mm)]
UPDATE t_prd_product_sizes SET min_qty=4, max_qty=10000, qty_incr=4 WHERE prd_cd='PRD_000053' AND siz_cd='SIZ_000170' AND del_yn='N' AND min_qty IS NULL AND max_qty IS NULL AND qty_incr IS NULL;  -- 반칼 자유형 투명스티커 [A5 (148 x 210 mm)]
UPDATE t_prd_product_sizes SET min_qty=2, max_qty=10000, qty_incr=2 WHERE prd_cd='PRD_000053' AND siz_cd='SIZ_000520' AND del_yn='N' AND min_qty IS NULL AND max_qty IS NULL AND qty_incr IS NULL;  -- 반칼 자유형 투명스티커 [A4 (210 x 297 mm)]
UPDATE t_prd_product_sizes SET min_qty=4, max_qty=10000, qty_incr=4 WHERE prd_cd='PRD_000054' AND siz_cd='SIZ_000170' AND del_yn='N' AND min_qty IS NULL AND max_qty IS NULL AND qty_incr IS NULL;  -- 반칼 자유형 홀로그램스티커 [A5 (148 x 210 mm)]
UPDATE t_prd_product_sizes SET min_qty=2, max_qty=10000, qty_incr=2 WHERE prd_cd='PRD_000054' AND siz_cd='SIZ_000520' AND del_yn='N' AND min_qty IS NULL AND max_qty IS NULL AND qty_incr IS NULL;  -- 반칼 자유형 홀로그램스티커 [A4 (210 x 297 mm)]
UPDATE t_prd_product_sizes SET min_qty=2, max_qty=10000, qty_incr=2 WHERE prd_cd='PRD_000058' AND siz_cd='SIZ_000520' AND del_yn='N' AND min_qty IS NULL AND max_qty IS NULL AND qty_incr IS NULL;  -- 반칼원형스티커 [A4 (210 x 297 mm)]
UPDATE t_prd_product_sizes SET min_qty=2, max_qty=10000, qty_incr=2 WHERE prd_cd='PRD_000059' AND siz_cd='SIZ_000520' AND del_yn='N' AND min_qty IS NULL AND max_qty IS NULL AND qty_incr IS NULL;  -- 반칼정사각스티커 [A4 (210 x 297 mm)]
UPDATE t_prd_product_sizes SET min_qty=2, max_qty=10000, qty_incr=2 WHERE prd_cd='PRD_000060' AND siz_cd='SIZ_000520' AND del_yn='N' AND min_qty IS NULL AND max_qty IS NULL AND qty_incr IS NULL;  -- 반칼직사각스티커 [A4 (210 x 297 mm)]
UPDATE t_prd_product_sizes SET min_qty=2, max_qty=10000, qty_incr=2 WHERE prd_cd='PRD_000061' AND siz_cd='SIZ_000520' AND del_yn='N' AND min_qty IS NULL AND max_qty IS NULL AND qty_incr IS NULL;  -- 반칼띠지스티커 [A4 (210 x 297 mm)]
UPDATE t_prd_product_sizes SET min_qty=4, max_qty=10000, qty_incr=4 WHERE prd_cd='PRD_000062' AND siz_cd='SIZ_000059' AND del_yn='N' AND min_qty IS NULL AND max_qty IS NULL AND qty_incr IS NULL;  -- 반칼팬시스티커 [124 x186 mm]
UPDATE t_prd_product_sizes SET min_qty=6, max_qty=10000, qty_incr=6 WHERE prd_cd='PRD_000062' AND siz_cd='SIZ_000060' AND del_yn='N' AND min_qty IS NULL AND max_qty IS NULL AND qty_incr IS NULL;  -- 반칼팬시스티커 [90 x 190 mm]
UPDATE t_prd_product_sizes SET min_qty=4, max_qty=10000, qty_incr=4 WHERE prd_cd='PRD_000063' AND siz_cd='SIZ_000059' AND del_yn='N' AND min_qty IS NULL AND max_qty IS NULL AND qty_incr IS NULL;  -- 반칼팬시투명스티커 [124 x186 mm]
UPDATE t_prd_product_sizes SET min_qty=6, max_qty=10000, qty_incr=6 WHERE prd_cd='PRD_000063' AND siz_cd='SIZ_000060' AND del_yn='N' AND min_qty IS NULL AND max_qty IS NULL AND qty_incr IS NULL;  -- 반칼팬시투명스티커 [90 x 190 mm]
UPDATE t_prd_product_sizes SET min_qty=24, max_qty=1000, qty_incr=24 WHERE prd_cd='PRD_000064' AND siz_cd='SIZ_000063' AND del_yn='N' AND min_qty IS NULL AND max_qty IS NULL AND qty_incr IS NULL;  -- 소량자유형스티커 [50 x 94 mm]
UPDATE t_prd_product_sizes SET min_qty=24, max_qty=1000, qty_incr=24 WHERE prd_cd='PRD_000064' AND siz_cd='SIZ_000064' AND del_yn='N' AND min_qty IS NULL AND max_qty IS NULL AND qty_incr IS NULL;  -- 소량자유형스티커 [94 x 50 mm]
UPDATE t_prd_product_sizes SET min_qty=24, max_qty=1000, qty_incr=24 WHERE prd_cd='PRD_000064' AND siz_cd='SIZ_000065' AND del_yn='N' AND min_qty IS NULL AND max_qty IS NULL AND qty_incr IS NULL;  -- 소량자유형스티커 [65 x 65 mm]
UPDATE t_prd_product_sizes SET min_qty=15, max_qty=1000, qty_incr=15 WHERE prd_cd='PRD_000064' AND siz_cd='SIZ_000043' AND del_yn='N' AND min_qty IS NULL AND max_qty IS NULL AND qty_incr IS NULL;  -- 소량자유형스티커 [80 x 80 mm]
UPDATE t_prd_product_sizes SET min_qty=12, max_qty=1000, qty_incr=12 WHERE prd_cd='PRD_000064' AND siz_cd='SIZ_000036' AND del_yn='N' AND min_qty IS NULL AND max_qty IS NULL AND qty_incr IS NULL;  -- 소량자유형스티커 [94 x 94 mm]

COMMIT;
