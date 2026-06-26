-- ============================================================================
-- [제안·미실행] 072 내지 승격 — 영향행 백업 스냅샷 (적재 전 선행·인간 승인)
-- 백업 대상: ① 신규 충돌 가능 prd_cd(284) ② 072 sets 기존 4구성원(disp_seq 재배열 대상)
-- 멱등: CREATE TABLE IF NOT EXISTS bak_* · INSERT … WHERE NOT EXISTS(이미 스냅샷)
-- 복원: undo.sql 이 bak_* 기준으로 disp_seq 원복 + 신규행 삭제
-- ============================================================================

-- bak: 072 sets 현 상태(재배열 전 disp_seq 보존 — undo 의 원복 기준)
CREATE TABLE IF NOT EXISTS bak_inner_promo_072_sets (
  prd_cd varchar, sub_prd_cd varchar, sub_prd_qty int, disp_seq int,
  note varchar, min_cnt int, max_cnt int, cnt_incr int, del_yn char(1),
  snap_dt timestamp DEFAULT now()
);
INSERT INTO bak_inner_promo_072_sets
  (prd_cd, sub_prd_cd, sub_prd_qty, disp_seq, note, min_cnt, max_cnt, cnt_incr, del_yn)
SELECT prd_cd, sub_prd_cd, sub_prd_qty, disp_seq, note, min_cnt, max_cnt, cnt_incr, del_yn
FROM t_prd_product_sets
WHERE prd_cd='PRD_000072'
  AND NOT EXISTS (SELECT 1 FROM bak_inner_promo_072_sets b
                  WHERE b.prd_cd='PRD_000072' AND b.sub_prd_cd=t_prd_product_sets.sub_prd_cd);

-- bak: PRD_000284 사전상태(존재하면 안 됨·search-before-mint 증거 보존)
CREATE TABLE IF NOT EXISTS bak_inner_promo_284_pre (
  found_prd_cd varchar, snap_dt timestamp DEFAULT now()
);
INSERT INTO bak_inner_promo_284_pre (found_prd_cd)
SELECT prd_cd FROM t_prd_products WHERE prd_cd='PRD_000284'
  AND NOT EXISTS (SELECT 1 FROM bak_inner_promo_284_pre);
-- (정상 = 0행 스냅샷 = 신규 mint 정당)
