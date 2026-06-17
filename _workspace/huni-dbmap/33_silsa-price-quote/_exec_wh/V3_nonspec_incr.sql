-- V3_nonspec_incr.sql — off-grid 증가단위 백필 (nonspec_width_incr/height_incr)
-- 근거: 13 면적매트릭스 상품은 라이브 nonspec_yn='Y'·width/height min/max 보유, incr만 NULL(백필 대기).
-- incr = 매트릭스 그리드 최소 스텝(포스터 200·현수막 100, GAP 시트 임계 간격에서 도출·날조 아님).
-- 역할: 비규격 가로/세로 입력 step 정규화(앱). 가격은 siz_width/height '이하' 구간 매칭(엔진).
-- 멱등: incr IS NULL 인 행만 백필 → 2-pass 0행.
UPDATE t_prd_products SET nonspec_width_incr=200, nonspec_height_incr=200, upd_dt=now() WHERE prd_cd='PRD_000118' AND nonspec_width_incr IS NULL;
UPDATE t_prd_products SET nonspec_width_incr=200, nonspec_height_incr=200, upd_dt=now() WHERE prd_cd='PRD_000119' AND nonspec_width_incr IS NULL;
UPDATE t_prd_products SET nonspec_width_incr=200, nonspec_height_incr=200, upd_dt=now() WHERE prd_cd='PRD_000120' AND nonspec_width_incr IS NULL;
UPDATE t_prd_products SET nonspec_width_incr=200, nonspec_height_incr=200, upd_dt=now() WHERE prd_cd='PRD_000121' AND nonspec_width_incr IS NULL;
UPDATE t_prd_products SET nonspec_width_incr=200, nonspec_height_incr=200, upd_dt=now() WHERE prd_cd='PRD_000122' AND nonspec_width_incr IS NULL;
UPDATE t_prd_products SET nonspec_width_incr=200, nonspec_height_incr=200, upd_dt=now() WHERE prd_cd='PRD_000123' AND nonspec_width_incr IS NULL;
UPDATE t_prd_products SET nonspec_width_incr=200, nonspec_height_incr=200, upd_dt=now() WHERE prd_cd='PRD_000124' AND nonspec_width_incr IS NULL;
UPDATE t_prd_products SET nonspec_width_incr=200, nonspec_height_incr=200, upd_dt=now() WHERE prd_cd='PRD_000125' AND nonspec_width_incr IS NULL;
UPDATE t_prd_products SET nonspec_width_incr=200, nonspec_height_incr=200, upd_dt=now() WHERE prd_cd='PRD_000126' AND nonspec_width_incr IS NULL;
UPDATE t_prd_products SET nonspec_width_incr=200, nonspec_height_incr=200, upd_dt=now() WHERE prd_cd='PRD_000127' AND nonspec_width_incr IS NULL;
UPDATE t_prd_products SET nonspec_width_incr=200, nonspec_height_incr=200, upd_dt=now() WHERE prd_cd='PRD_000128' AND nonspec_width_incr IS NULL;
UPDATE t_prd_products SET nonspec_width_incr=100, nonspec_height_incr=100, upd_dt=now() WHERE prd_cd='PRD_000138' AND nonspec_width_incr IS NULL;
UPDATE t_prd_products SET nonspec_width_incr=100, nonspec_height_incr=100, upd_dt=now() WHERE prd_cd='PRD_000139' AND nonspec_width_incr IS NULL;
