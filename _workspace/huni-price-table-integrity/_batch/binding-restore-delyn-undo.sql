-- UNDO: 제본비 comp 3종 del_yn=N→Y 되돌리기 (적재 전 상태=del_yn='Y'였음).
BEGIN;
UPDATE t_prc_price_components SET del_yn='Y', upd_dt=now()
 WHERE comp_cd IN ('COMP_BIND_JUNGCHEOL','COMP_BIND_MUSEON','COMP_BIND_PUR');
COMMIT;
