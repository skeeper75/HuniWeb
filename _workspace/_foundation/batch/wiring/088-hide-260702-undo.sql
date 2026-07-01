-- UNDO: 088 레더링바인더 숨김 되돌리기(가격 구성 완료 후 재노출 시).
UPDATE t_prd_products SET use_yn='Y', upd_dt=now() WHERE prd_cd='PRD_000088';
