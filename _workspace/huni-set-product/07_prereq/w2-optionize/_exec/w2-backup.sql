-- =====================================================================
-- w2-backup.sql — W2 CPQ 옵션화 COMMIT 범위(머그컵 제외) 사전 백업
-- =====================================================================
-- 목적: 적재 대상 9상품(PRD_072·077·082·088·140·142·197·198·217)의
--       기존 t_prd_product_option_groups / options / option_items 스냅샷을
--       백업 테이블 3종(bak_*_w2opt_<타임스탬프>)으로 보존.
--       멱등 재적재·undo(백업 복원)에 대비.
-- 안전: SELECT INTO 만 수행(원본 무변경). 트랜잭션 불요(읽기→백업테이블 생성).
-- 실행: 메인이 수행. 본 파일은 빌드 산출물(실 COMMIT 아님).
-- 주: 현 실측상 9상품 기존 option_group=0행(중복 신설 없음) → 백업은 0행이 정상.
--     향후 재적재(2-pass) 시 1-pass 결과를 보존하는 안전망 역할.
-- =====================================================================

\set ON_ERROR_STOP on

-- 타임스탬프 접미사(YYYYMMDDHH24MISS)를 psql 변수로 1회 고정
SELECT to_char(now(),'YYYYMMDDHH24MISS') AS ts \gset

-- ---- option_groups 백업 ----
\set bak_grp 'bak_opt_groups_w2opt_':ts
SELECT format(
  'CREATE TABLE %I AS SELECT * FROM t_prd_product_option_groups
   WHERE prd_cd IN (''PRD_000072'',''PRD_000077'',''PRD_000082'',''PRD_000088'',
                    ''PRD_000140'',''PRD_000142'',''PRD_000197'',''PRD_000198'',''PRD_000217'')',
  :'bak_grp') \gexec

-- ---- options 백업 ----
\set bak_opt 'bak_options_w2opt_':ts
SELECT format(
  'CREATE TABLE %I AS SELECT * FROM t_prd_product_options
   WHERE prd_cd IN (''PRD_000072'',''PRD_000077'',''PRD_000082'',''PRD_000088'',
                    ''PRD_000140'',''PRD_000142'',''PRD_000197'',''PRD_000198'',''PRD_000217'')',
  :'bak_opt') \gexec

-- ---- option_items 백업 ----
\set bak_item 'bak_opt_items_w2opt_':ts
SELECT format(
  'CREATE TABLE %I AS SELECT * FROM t_prd_product_option_items
   WHERE prd_cd IN (''PRD_000072'',''PRD_000077'',''PRD_000082'',''PRD_000088'',
                    ''PRD_000140'',''PRD_000142'',''PRD_000197'',''PRD_000198'',''PRD_000217'')',
  :'bak_item') \gexec

-- ---- 백업 결과 보고 ----
\echo '== 백업 테이블 행수(기대: 신규 적재 전이면 전부 0) =='
SELECT :'bak_grp'  AS tbl, count(*) FROM pg_class WHERE relname = :'bak_grp';
SELECT format('SELECT ''%s'' tbl, count(*) cnt FROM %I', :'bak_grp',  :'bak_grp')  \gexec
SELECT format('SELECT ''%s'' tbl, count(*) cnt FROM %I', :'bak_opt',  :'bak_opt')  \gexec
SELECT format('SELECT ''%s'' tbl, count(*) cnt FROM %I', :'bak_item', :'bak_item') \gexec

\echo '== 백업 완료. 복원이 필요하면 w2-undo.sql 의 복원 블록 참조 =='
