-- 큐리어스스킨 화이트 270g 하위(MAT_000361) COMP_PAPER 절가 880 적재 (1행·verbatim).
-- 근거: 권위 가격표 큐리어스스킨 화이트=880(=부모 MAT_000137 절가). 형제 색상(레드/블루/블랙/바이올렛=1242.5)은 하위 적재 완료, 화이트만 하위 비어있음.
-- 사용자 승인: "하위에도 880 채움(하위통일)". [HARD] 인간 승인 후 COMMIT.
BEGIN;
INSERT INTO t_prc_component_prices (comp_cd,apply_ymd,mat_cd,min_qty,unit_price,note,plt_siz_cd,reg_dt) VALUES ('COMP_PAPER','2026-06-01','MAT_000361',1,880,'용지비 큐리어스스킨 화이트 270g 국4절(316x467) 절가 — 실제 청구는 출력매수만큼 자동 계산','SIZ_000499',now()) ON CONFLICT DO NOTHING;
COMMIT;
