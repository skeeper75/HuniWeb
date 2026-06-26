-- ============================================================================
-- namecard-mat-fix.sql — 명함 자재 결손(견적불가) 교정 (A2 결함 D-C1-04)
-- ----------------------------------------------------------------------------
-- 권위[HARD]: 인쇄상품 가격표 260527 명함포토카드 시트 B01(스탠다드명함).
--   가격표 열 헤더가 종이를 2개 동일가 그룹으로 묶음:
--     그룹1(단면 3500 / 양면 4500): 백모조220 · 아트250 · 스노우250
--     그룹2(단면 3800 / 양면 4800): 아트300 · 스노우300
--
-- 결함: COMP_NAMECARD_STD_S1/S2 가 묶음 그룹의 대표 mat_cd 1종만 적재(각 2행)
--   → 스탠다드명함 제공 종이 5종 중 3종(아트250/스노우250/스노우300) 단가행 0 = 견적불가.
--   ★단가값(3500/3800/4500/4800)은 권위 verbatim 정합. 결함은 자재 차원 collapse.
--
-- 교정 구조 = (b) 종이별 단가행 전개 (NULL 와일드카드 (a) 아님 — 5종이 동일가 아니라
--   2그룹이라 NULL 은 그룹2 를 그룹1가로 저청구·두 NULL 공존 시 ERR_AMBIGUOUS).
--   누락 4종 mat_cd 행을 각 그룹가로 추가(6행). 기존 4행 단가 verbatim 보존.
--   use_dims=[mat_cd,min_qty,print_opt_cd] 와 정합. clr/siz/coat/bdl/proc/opt/plt=NULL.
--
-- 멱등: PK=surrogate(comp_price_id), 자연키 unique 제약 없음 →
--   자연키(comp_cd, mat_cd, print_opt_cd, min_qty) DELETE 후 INSERT(digital-clr 패턴).
--   재실행 안전(중복 0). search-before-mint: 신규 comp/mat/공식 mint 0(단가행만).
-- 비고: 실 COMMIT 전 namecard-mat-fix.dryrun 으로 ROLLBACK 검증 후 인간 승인.
--   동형 결함(PEARL collapse 등)은 본 SQL 스코프 밖 — 별도 전파 교정.
-- ============================================================================

BEGIN;

-- 1) 자연키 기준 기존 STD 명함 단가행 제거(멱등). 교정 대상 8행(기존2+추가6 의 키 6종)을
--    안전하게 재구성하기 위해 STD_S1/S2 의 mat 전개 키를 통째 삭제 후 재삽입.
DELETE FROM t_prc_component_prices
 WHERE comp_cd IN ('COMP_NAMECARD_STD_S1','COMP_NAMECARD_STD_S2')
   AND print_opt_cd IN ('POPT_000001','POPT_000002')
   AND min_qty = 100
   AND mat_cd IN ('MAT_000074','MAT_000081','MAT_000082','MAT_000091','MAT_000092');

-- 2) 5종 종이 × 단면/양면 단가행 재삽입 (기존2 verbatim + 누락4 전개).
--    note 는 단일 종이로 정정(collapse 흔적 제거; 가격 무영향).
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, mat_cd, print_opt_cd, min_qty, unit_price, note)
VALUES
-- ── STD_S1 단면 (POPT_000001) ──────────────────────────────── 그룹1=3500, 그룹2=3800
('COMP_NAMECARD_STD_S1','2026-06-01','MAT_000074','POPT_000001',100,3500.00,'스탠다드명함/단면/백모조220 제작수량 100 이상'),
('COMP_NAMECARD_STD_S1','2026-06-01','MAT_000081','POPT_000001',100,3500.00,'스탠다드명함/단면/아트250 제작수량 100 이상'),
('COMP_NAMECARD_STD_S1','2026-06-01','MAT_000091','POPT_000001',100,3500.00,'스탠다드명함/단면/스노우250 제작수량 100 이상'),
('COMP_NAMECARD_STD_S1','2026-06-01','MAT_000082','POPT_000001',100,3800.00,'스탠다드명함/단면/아트300 제작수량 100 이상'),
('COMP_NAMECARD_STD_S1','2026-06-01','MAT_000092','POPT_000001',100,3800.00,'스탠다드명함/단면/스노우300 제작수량 100 이상'),
-- ── STD_S2 양면 (POPT_000002) ──────────────────────────────── 그룹1=4500, 그룹2=4800
('COMP_NAMECARD_STD_S2','2026-06-01','MAT_000074','POPT_000002',100,4500.00,'스탠다드명함/양면/백모조220 제작수량 100 이상'),
('COMP_NAMECARD_STD_S2','2026-06-01','MAT_000081','POPT_000002',100,4500.00,'스탠다드명함/양면/아트250 제작수량 100 이상'),
('COMP_NAMECARD_STD_S2','2026-06-01','MAT_000091','POPT_000002',100,4500.00,'스탠다드명함/양면/스노우250 제작수량 100 이상'),
('COMP_NAMECARD_STD_S2','2026-06-01','MAT_000082','POPT_000002',100,4800.00,'스탠다드명함/양면/아트300 제작수량 100 이상'),
('COMP_NAMECARD_STD_S2','2026-06-01','MAT_000092','POPT_000002',100,4800.00,'스탠다드명함/양면/스노우300 제작수량 100 이상');

-- 3) 사후검증(트랜잭션 내) — 5종 전부 정확히 1행·동시매칭 0·권위가 일치.
DO $$
DECLARE
  v_papers text[] := ARRAY['MAT_000074','MAT_000081','MAT_000082','MAT_000091','MAT_000092'];
  v_mat text; v_cnt int; v_amb int;
  v_g1_s1 numeric; v_g2_s1 numeric;
BEGIN
  -- 견적가능: 단면 5종 각 1행
  FOREACH v_mat IN ARRAY v_papers LOOP
    SELECT COUNT(*) INTO v_cnt FROM t_prc_component_prices
     WHERE comp_cd='COMP_NAMECARD_STD_S1' AND print_opt_cd='POPT_000001'
       AND min_qty=100 AND mat_cd=v_mat;
    IF v_cnt <> 1 THEN
      RAISE EXCEPTION '교정 검증 실패: 단면 % 매칭행수=% (기대 1·견적불가 미해소)', v_mat, v_cnt;
    END IF;
  END LOOP;
  -- 동시매칭 가드: (comp,print_opt,mat,min_qty) 조합당 행 >1 이면 ERR_AMBIGUOUS 위험
  SELECT COUNT(*) INTO v_amb FROM (
    SELECT 1 FROM t_prc_component_prices
     WHERE comp_cd IN ('COMP_NAMECARD_STD_S1','COMP_NAMECARD_STD_S2')
     GROUP BY comp_cd, print_opt_cd, mat_cd, min_qty HAVING COUNT(*)>1) t;
  IF v_amb > 0 THEN
    RAISE EXCEPTION '교정 검증 실패: 동시매칭 위험 조합 %건', v_amb;
  END IF;
  -- 권위 verbatim: 그룹1 단면=3500, 그룹2 단면=3800
  SELECT unit_price INTO v_g1_s1 FROM t_prc_component_prices
   WHERE comp_cd='COMP_NAMECARD_STD_S1' AND mat_cd='MAT_000081' AND print_opt_cd='POPT_000001' AND min_qty=100;
  SELECT unit_price INTO v_g2_s1 FROM t_prc_component_prices
   WHERE comp_cd='COMP_NAMECARD_STD_S1' AND mat_cd='MAT_000092' AND print_opt_cd='POPT_000001' AND min_qty=100;
  IF v_g1_s1 <> 3500 OR v_g2_s1 <> 3800 THEN
    RAISE EXCEPTION '교정 검증 실패: 그룹가 단면 아트250=% 스노우300=% (기대 3500/3800)', v_g1_s1, v_g2_s1;
  END IF;
  RAISE NOTICE '교정 검증 OK: 단면 5종 견적가능·동시매칭 0·그룹1=3500/그룹2=3800';
END $$;

COMMIT;
