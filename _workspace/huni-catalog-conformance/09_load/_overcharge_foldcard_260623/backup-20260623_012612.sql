-- ============================================================
-- backup-20260623_012612.sql — §21 접지카드 과대청구 교정 사전 물리 백업
-- 변경 대상 행 현재값 SELECT 스냅샷 (라이브 read-only)
-- 생성: 20260623_012612 (KST 환경시각)
-- 복원 근거: 사후검증 실패 시 undo.sql + 본 스냅샷 대조
-- ============================================================

-- [A] t_proc_processes — 신규 등록 대상 코드(106/107) 사전 부재 증명 + 부모/재사용 코드 현재값
-- (106/107 부재 = INSERT 대상·아래 0행이면 신규 정당)
-- A.1 신규 대상 사전 부재 (PROC_000106/107 — 0행 기대)
-- EXISTS_106_107: (none — 부재 확인)
-- A.2 부모·재사용 코드 현재값 (INSERT/생성용 복원 참조)
-- PROC_000056 | 접지 | upr=NULL | seq=15 | use=Y | del=N
-- PROC_000060 | 3단접지 | upr=PROC_000056 | seq=4 | use=Y | del=N
-- PROC_000071 | 병풍접지 | upr=PROC_000056 | seq=15 | use=Y | del=N

-- [B] t_prc_price_components — 4 comp use_dims 현재값 (UPDATE 대상·복원용)
UPDATE t_prc_price_components SET use_dims='["min_qty"]'::jsonb WHERE comp_cd='COMP_FOLD_LEAF_3FOLD';  -- 복원
UPDATE t_prc_price_components SET use_dims='["min_qty"]'::jsonb WHERE comp_cd='COMP_FOLD_LEAF_4ACC';  -- 복원
UPDATE t_prc_price_components SET use_dims='["min_qty"]'::jsonb WHERE comp_cd='COMP_FOLD_LEAF_4GATE';  -- 복원
UPDATE t_prc_price_components SET use_dims='["min_qty"]'::jsonb WHERE comp_cd='COMP_FOLD_LEAF_HALF';  -- 복원

-- [C] t_prc_component_prices — 4 comp proc_cd 현재값 집계 (UPDATE 대상·복원=NULL)
-- COMP_FOLD_LEAF_3FOLD | rows=48 | proc_cd_distinct=NULL | sum_price=31965.00
-- COMP_FOLD_LEAF_4ACC | rows=48 | proc_cd_distinct=NULL | sum_price=41110.00
-- COMP_FOLD_LEAF_4GATE | rows=48 | proc_cd_distinct=NULL | sum_price=41110.00
-- COMP_FOLD_LEAF_HALF | rows=48 | proc_cd_distinct=NULL | sum_price=24421.00

-- [C.2] verbatim 기준선 (적재 전후 동일성 검증용)
-- VERBATIM_BASELINE total_rows=192 total_sum=138606.00
