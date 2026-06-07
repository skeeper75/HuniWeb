-- 00_resync_sequence.sql  — comp_price_id IDENTITY 시퀀스 재동기화 (모든 INSERT 전)
-- 라이브 DRY-RUN 적발 결함: 시퀀스 stale(last_value=2) vs MAX(comp_price_id)=4805.
--   2026-06-06 적재가 명시 ID 로 넣고 시퀀스를 전진시키지 않아 auto-IDENTITY 가 1,2,…발급→충돌.
-- setval 로 시퀀스를 현재 MAX 로 동기화 → 04 의 auto-IDENTITY 49행은 4806~ 발급(충돌 0).
-- COALESCE(MAX,0): 빈 테이블 대비. true: is_called=true → 다음 nextval=MAX+1.
-- idempotent: 재실행해도 동일 MAX 로 재설정(harmless). DDL 아님(시퀀스 값 조정).
SELECT setval('public.t_prc_component_prices_comp_price_id_seq',
              (SELECT COALESCE(MAX(comp_price_id), 0) FROM t_prc_component_prices), true);
