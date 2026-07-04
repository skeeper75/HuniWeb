-- ============================================================
-- MC-02  병합 DRY-RUN (ROLLBACK 전용 · COMMIT 아님 · 멱등 실증)
-- 정본 COMP_NAMECARD_PREMIUM ← 4 멤버.  단가행 이관 28 · 영향공식 ['PRF_NAMECARD_PREMIUM', 'PRF_NAMECARD_PREMIUM_FOIL']
-- 실 적용은 인간 승인 후 별도 단계(ROLLBACK 을 COMMIT 으로 교체).
-- ============================================================
BEGIN;

-- [가드0] 이관 전 정본 nat_key 충돌 사전검증 (0 이어야 안전):
--   멤버 단가행을 정본으로 옮겼을 때 ux_t_prc_comp_prices_nat_key(15열) 중복이 없음을 예측 확인.
WITH moved AS (
  SELECT apply_ymd,siz_cd,plt_siz_cd,clr_cd,mat_cd,proc_cd,opt_cd,print_opt_cd,
         coat_side_cnt,bdl_qty,siz_width,siz_height,min_qty,COALESCE(dim_vals,'{}'::jsonb) dv
  FROM t_prc_component_prices WHERE comp_cd IN ('COMP_NAMECARD_PREMIUM_S1_MGA', 'COMP_NAMECARD_PREMIUM_S1_MGB', 'COMP_NAMECARD_PREMIUM_S2_MGA', 'COMP_NAMECARD_PREMIUM_S2_MGB'))
SELECT '가드0 nat_key 충돌수(0 기대)' lbl, COUNT(*)-COUNT(DISTINCT (apply_ymd,siz_cd,plt_siz_cd,clr_cd,mat_cd,proc_cd,opt_cd,print_opt_cd,coat_side_cnt,bdl_qty,siz_width,siz_height,min_qty,dv::text)) AS collisions FROM moved;

-- [1] 정본 comp 카탈로그 확정 (멱등 upsert)
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn, prc_typ_cd, use_dims, del_yn, reg_dt)
VALUES ('COMP_NAMECARD_PREMIUM', '프리미엄명함A 완제품가 단면(용지포함)', 'PRC_COMPONENT_TYPE.06', '명함 완제품가(용지 포함). 소재·인쇄면·수량을 합산한 1건당 단가표. [차원통합] 통합축=print_opt_cd(면)·mat_cd(종이등급 A/B)', 'Y', 'PRICE_TYPE.02', '["mat_cd", "print_opt_cd", "min_qty"]', 'N', now())
ON CONFLICT (comp_cd) DO UPDATE SET comp_nm=EXCLUDED.comp_nm, comp_typ_cd=EXCLUDED.comp_typ_cd,
  note=EXCLUDED.note, use_yn='Y', prc_typ_cd=EXCLUDED.prc_typ_cd, use_dims=EXCLUDED.use_dims, del_yn='N', upd_dt=now();

-- [2] 단가행 이관: 멤버 comp_cd → 정본 (분리축 print_opt_cd/opt_cd/mat_cd 값은 행에 이미 충전됨·verbatim 불변)
UPDATE t_prc_component_prices SET comp_cd='COMP_NAMECARD_PREMIUM', upd_dt=now()
 WHERE comp_cd IN ('COMP_NAMECARD_PREMIUM_S1_MGA', 'COMP_NAMECARD_PREMIUM_S1_MGB', 'COMP_NAMECARD_PREMIUM_S2_MGA', 'COMP_NAMECARD_PREMIUM_S2_MGB');
--   기대 이관 건수 = 28 (재실행 시 0 = 멱등)

-- [3] formula_components 재배선: 멤버 배선행 DELETE + 정본 1행 UPSERT (공식별)
DELETE FROM t_prc_formula_components WHERE comp_cd IN ('COMP_NAMECARD_PREMIUM_S1_MGA', 'COMP_NAMECARD_PREMIUM_S1_MGB', 'COMP_NAMECARD_PREMIUM_S2_MGA', 'COMP_NAMECARD_PREMIUM_S2_MGB');
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt) VALUES
  ('PRF_NAMECARD_PREMIUM', 'COMP_NAMECARD_PREMIUM', 1, 'Y', now()),
  ('PRF_NAMECARD_PREMIUM_FOIL', 'COMP_NAMECARD_PREMIUM', 1, 'Y', now())
ON CONFLICT (frm_cd, comp_cd) DO UPDATE SET disp_seq=EXCLUDED.disp_seq, addtn_yn=EXCLUDED.addtn_yn, upd_dt=now();

-- [3b] 잔여(bystander) 구성요소 disp_seq 재정렬 (정본=1 뒤로 밀기)
UPDATE t_prc_formula_components SET disp_seq=2, upd_dt=now() WHERE frm_cd='PRF_NAMECARD_PREMIUM' AND comp_cd='COMP_PP_VARTEXT_1EA';
UPDATE t_prc_formula_components SET disp_seq=3, upd_dt=now() WHERE frm_cd='PRF_NAMECARD_PREMIUM' AND comp_cd='COMP_PP_VARIMG_1EA';
UPDATE t_prc_formula_components SET disp_seq=4, upd_dt=now() WHERE frm_cd='PRF_NAMECARD_PREMIUM' AND comp_cd='COMP_PP_CORNER_RIGHT';
UPDATE t_prc_formula_components SET disp_seq=2, upd_dt=now() WHERE frm_cd='PRF_NAMECARD_PREMIUM_FOIL' AND comp_cd='COMP_FOIL_SETUP_SMALL';
UPDATE t_prc_formula_components SET disp_seq=3, upd_dt=now() WHERE frm_cd='PRF_NAMECARD_PREMIUM_FOIL' AND comp_cd='COMP_FOIL_PROC_SMALL_STD';
UPDATE t_prc_formula_components SET disp_seq=4, upd_dt=now() WHERE frm_cd='PRF_NAMECARD_PREMIUM_FOIL' AND comp_cd='COMP_FOIL_PROC_SMALL_SPECIAL';
UPDATE t_prc_formula_components SET disp_seq=5, upd_dt=now() WHERE frm_cd='PRF_NAMECARD_PREMIUM_FOIL' AND comp_cd='COMP_PP_VARTEXT_1EA';
UPDATE t_prc_formula_components SET disp_seq=6, upd_dt=now() WHERE frm_cd='PRF_NAMECARD_PREMIUM_FOIL' AND comp_cd='COMP_PP_VARIMG_1EA';
UPDATE t_prc_formula_components SET disp_seq=7, upd_dt=now() WHERE frm_cd='PRF_NAMECARD_PREMIUM_FOIL' AND comp_cd='COMP_PP_CORNER_RIGHT';

-- [4] 멤버 comp 논리삭제 (hard-delete 금지 · 기초코드 삭제금지 준수)
UPDATE t_prc_price_components SET use_yn='N', del_yn='Y', del_dt=now(),
  note='[차원통합→COMP_NAMECARD_PREMIUM]', upd_dt=now() WHERE comp_cd IN ('COMP_NAMECARD_PREMIUM_S1_MGA', 'COMP_NAMECARD_PREMIUM_S1_MGB', 'COMP_NAMECARD_PREMIUM_S2_MGA', 'COMP_NAMECARD_PREMIUM_S2_MGB');

-- [검증] 오염가드: 정본 1개만 각 공식에 배선·멤버 잔존 배선 0·정본 단가행수 확인
SELECT 'PRF_NAMECARD_PREMIUM 배선 comp수' lbl, string_agg(comp_cd||':'||disp_seq, ', ' ORDER BY disp_seq) FROM t_prc_formula_components WHERE frm_cd='PRF_NAMECARD_PREMIUM';
SELECT 'PRF_NAMECARD_PREMIUM_FOIL 배선 comp수' lbl, string_agg(comp_cd||':'||disp_seq, ', ' ORDER BY disp_seq) FROM t_prc_formula_components WHERE frm_cd='PRF_NAMECARD_PREMIUM_FOIL';
SELECT '멤버 잔존배선(0기대)' lbl, COUNT(*) FROM t_prc_formula_components WHERE comp_cd IN ('COMP_NAMECARD_PREMIUM_S1_MGA', 'COMP_NAMECARD_PREMIUM_S1_MGB', 'COMP_NAMECARD_PREMIUM_S2_MGA', 'COMP_NAMECARD_PREMIUM_S2_MGB');
SELECT '정본 단가행수(28기대)' lbl, COUNT(*) FROM t_prc_component_prices WHERE comp_cd='COMP_NAMECARD_PREMIUM';
SELECT '멤버 잔존 단가행(0기대)' lbl, COUNT(*) FROM t_prc_component_prices WHERE comp_cd IN ('COMP_NAMECARD_PREMIUM_S1_MGA', 'COMP_NAMECARD_PREMIUM_S1_MGB', 'COMP_NAMECARD_PREMIUM_S2_MGA', 'COMP_NAMECARD_PREMIUM_S2_MGB');

ROLLBACK;  -- DRY-RUN: 영속화 없음. 실 적용은 인간 승인 후 COMMIT 으로 교체.
