-- acryl-activate-166-153.sql — 166 카라비너·153 명찰골드실버 활성화 (use_yn=N→Y · 인간 승인)
-- 둘 다 고정가형 by-siz_cd 가격 정상 적재·라이브 작동 확인됨. 활성화=고객 노출.
\set ON_ERROR_STOP on
BEGIN;
UPDATE t_prd_products SET use_yn='Y', upd_dt=now()
WHERE prd_cd IN ('PRD_000166','PRD_000153') AND use_yn='N' AND del_yn='N';
COMMIT;
