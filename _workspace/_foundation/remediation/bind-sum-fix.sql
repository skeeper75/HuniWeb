-- =====================================================================
-- bind-sum-fix.sql  —  PRF_BIND_SUM 제본 다종-1배선 교정 (A안: 제본방식별 공식 분리)
-- 결함: A2 C4-D01 (codex CONFIRMED) — 4책자 공유공식에 중철 comp만 배선
--       → 무선/PUR/트윈링 제본비 0원 누락(silent drop).
-- 권위[HARD]: 가격표 260527 제본비 표 B01 — 단가행은 이미 verbatim 정확(교정 0).
--             교정 대상 = 공식/배선/바인딩만. component_prices·단가값 불변. DDL 0.
-- 멱등: 공식·배선 = ON CONFLICT DO NOTHING / 바인딩 = 조건부 UPDATE(재실행 0행).
-- search-before-mint: comp 전부 기존 재사용. 신규 엔티티 타입 0.
-- 안전: 단일 트랜잭션 래핑. 실 COMMIT은 인간 승인 후. (검증은 bind-sum-dryrun.sql)
-- =====================================================================
BEGIN;

-- ── 사전 가드: 대상 4상품 바인딩이 기대 상태(전부 PRF_BIND_SUM)인지 확인용 출력 ──
--   (드리프트 적발 시 운영자가 중단할 수 있게 적용 전 상태를 남긴다)
\echo '== BEFORE: product->formula bindings (068~071) =='
SELECT prd_cd, frm_cd, apply_bgn_ymd
  FROM t_prd_product_price_formulas
 WHERE prd_cd IN ('PRD_000068','PRD_000069','PRD_000070','PRD_000071')
 ORDER BY prd_cd;

-- ─────────────────────────────────────────────────────────────────────
-- ① 공식 신설(3) — 무선·PUR·트윈링 제본공식. 그릇 기존(frm_cd/frm_nm/note/use_yn).
--    reg_dt = now() default. 멱등: frm_cd PK 충돌 시 무시.
-- ─────────────────────────────────────────────────────────────────────
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, note, use_yn)
VALUES
  ('PRF_BIND_MUSEON',  '제본 합산형(무선)',   '무선책자 제본비. 수량구간×무선제본 단가를 상위 공식에 더함.',   'Y'),
  ('PRF_BIND_PUR',     '제본 합산형(PUR)',    'PUR책자 제본비. 수량구간×PUR제본 단가를 상위 공식에 더함.',     'Y'),
  ('PRF_BIND_TWINRING','제본 합산형(트윈링)', '트윈링책자 제본비. 수량구간×트윈링제본 단가를 상위 공식에 더함.','Y')
ON CONFLICT (frm_cd) DO NOTHING;

-- ① 보조: 기존 PRF_BIND_SUM 의미 명확화(중철 전용임을 명시). 멱등(같은 값 재설정).
UPDATE t_prc_price_formulas
   SET frm_nm = '제본 합산형(중철)',
       note   = '중철책자 제본비. 수량구간×중철제본 단가를 상위 공식에 더함.',
       upd_dt = now()
 WHERE frm_cd = 'PRF_BIND_SUM'
   AND (frm_nm IS DISTINCT FROM '제본 합산형(중철)'
        OR note   IS DISTINCT FROM '중철책자 제본비. 수량구간×중철제본 단가를 상위 공식에 더함.');

-- ─────────────────────────────────────────────────────────────────────
-- ② 배선(3) — 각 신공식에 자기 제본 comp 1행. 동시매칭 0(공식당 comp 1개).
--    PK=(frm_cd,comp_cd). 멱등: 충돌 시 무시.
-- ─────────────────────────────────────────────────────────────────────
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES
  ('PRF_BIND_MUSEON',   'COMP_BIND_MUSEON',   1, 'Y'),
  ('PRF_BIND_PUR',      'COMP_BIND_PUR',      1, 'Y'),
  ('PRF_BIND_TWINRING', 'COMP_BIND_TWINRING', 1, 'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;

-- ─────────────────────────────────────────────────────────────────────
-- ③ 바인딩 교정(UPDATE) — 069/070/071을 자기 제본공식으로 재배선.
--    068(중철)은 PRF_BIND_SUM 유지(불변). PK=(prd_cd,apply_bgn_ymd) 보존(행 교체 아님).
--    멱등: WHERE frm_cd='PRF_BIND_SUM' 조건부 → 재실행 시 이미 교체돼 0행.
-- ─────────────────────────────────────────────────────────────────────
UPDATE t_prd_product_price_formulas
   SET frm_cd = 'PRF_BIND_MUSEON', upd_dt = now()
 WHERE prd_cd = 'PRD_000069' AND frm_cd = 'PRF_BIND_SUM';

UPDATE t_prd_product_price_formulas
   SET frm_cd = 'PRF_BIND_PUR', upd_dt = now()
 WHERE prd_cd = 'PRD_000070' AND frm_cd = 'PRF_BIND_SUM';

UPDATE t_prd_product_price_formulas
   SET frm_cd = 'PRF_BIND_TWINRING', upd_dt = now()
 WHERE prd_cd = 'PRD_000071' AND frm_cd = 'PRF_BIND_SUM';

-- ── 사후 확인 출력 ──
\echo '== AFTER: product->formula bindings (068~071) =='
SELECT prd_cd, frm_cd, apply_bgn_ymd
  FROM t_prd_product_price_formulas
 WHERE prd_cd IN ('PRD_000068','PRD_000069','PRD_000070','PRD_000071')
 ORDER BY prd_cd;

\echo '== AFTER: formula_components per bind formula (각 공식 1행 기대) =='
SELECT fc.frm_cd, fc.comp_cd
  FROM t_prc_formula_components fc
 WHERE fc.frm_cd IN ('PRF_BIND_SUM','PRF_BIND_MUSEON','PRF_BIND_PUR','PRF_BIND_TWINRING')
 ORDER BY fc.frm_cd, fc.comp_cd;

COMMIT;
-- ↑ 실 적용 시에만 COMMIT. 검증/리허설은 bind-sum-dryrun.sql(ROLLBACK)을 쓸 것.
