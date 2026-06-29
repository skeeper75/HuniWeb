-- 출력소재 명확한 견적불가 5건 적재 (디지털인쇄용지 .01·하위 레벨·권위 절가 verbatim)
-- PET 260g 2종(국4절 SIZ_000499) + 3절 용지 3종(SIZ_000077). 단가=인쇄상품 가격표 출력소재 절가.
-- [HARD] 인간 승인 후 COMMIT. apply_ymd·note 기존 COMP_PAPER 패턴 미러.
BEGIN;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, mat_cd, min_qty, unit_price, note, plt_siz_cd, reg_dt) VALUES
 ('COMP_PAPER','2026-06-01','MAT_000144',1,1100,'용지비 투명 PET 260g 국4절(316x467) 절가 — 실제 청구는 출력매수만큼 자동 계산','SIZ_000499',now()),
 ('COMP_PAPER','2026-06-01','MAT_000147',1,1100,'용지비 반투명 PET 260g 국4절(316x467) 절가 — 실제 청구는 출력매수만큼 자동 계산','SIZ_000499',now()),
 ('COMP_PAPER','2026-06-01','MAT_000111',1,216.08,'용지비 몽블랑 190g (3절) 3절(300x625) 절가 — 실제 청구는 출력매수만큼 자동 계산','SIZ_000077',now()),
 ('COMP_PAPER','2026-06-01','MAT_000112',1,272.9466667,'용지비 몽블랑 240g (3절) 3절(300x625) 절가 — 실제 청구는 출력매수만큼 자동 계산','SIZ_000077',now()),
 ('COMP_PAPER','2026-06-01','MAT_000093',1,149.22,'용지비 스노우지 250g (3절) 3절(300x625) 절가 — 실제 청구는 출력매수만큼 자동 계산','SIZ_000077',now())
ON CONFLICT DO NOTHING;
SELECT comp_cd,mat_cd,plt_siz_cd,unit_price FROM t_prc_component_prices WHERE comp_cd='COMP_PAPER' AND mat_cd IN('MAT_000144','MAT_000147','MAT_000111','MAT_000112','MAT_000093') ORDER BY mat_cd;
ROLLBACK;
