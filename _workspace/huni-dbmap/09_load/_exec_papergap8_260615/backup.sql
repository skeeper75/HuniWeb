-- =====================================================================
-- backup.sql — 디지털 국4절 종이 GAP 적재 전 스냅샷 백업
--   영향 테이블 = t_prc_component_prices (단일).
--   슈퍼유저(postgres) 권한으로 DB 내부 스냅샷 테이블 생성.
--   ★ 이 스크립트는 실 COMMIT 직전(인간 승인) 단계에서만 실행.
--      DRY-RUN/검증 단계에서는 실행하지 않는다(쓰기이므로).
--   재실행 안전: IF NOT EXISTS 가드(이미 있으면 보존).
-- =====================================================================
\set ON_ERROR_STOP on

-- 1) 라이브 스냅샷(영향 테이블 전체) — undo 안전망
CREATE TABLE IF NOT EXISTS bak_papergap8_260615 AS
SELECT * FROM t_prc_component_prices;

-- 2) 백업 검증 — 원본과 행수 일치 확인
SELECT 'bak_papergap8_260615' AS bak_table,
       (SELECT count(*) FROM bak_papergap8_260615) AS bak_rows,
       (SELECT count(*) FROM t_prc_component_prices) AS live_rows,
       (SELECT count(*) FROM bak_papergap8_260615) = (SELECT count(*) FROM t_prc_component_prices) AS rows_match;
