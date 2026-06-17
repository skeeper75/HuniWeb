-- L1 복합 옵션 등록 (린넨패브릭포스터 PRD_000124·가공 그룹 OPT_000009)
-- ============================================================================
-- ★실측 정정(search-before-mint):
--   · "오버로크+리본끈" = 라이브에 OPV-000024 (하이픈, disp_seq 4) 이미 존재 → 재사용(신규 mint 금지).
--     (spec 의 OPV_000028 신규 가정 기각 — 중복 채번 방지)
--   · "말아박기+면끈"   = 라이브 부재 → 신규 mint. 채번 = 우세 OPV_ (밑줄) 시리즈 MAX+1.
--     라이브 max(OPV_)=OPV_000423 → 신규 OPV_000424. (메모리 dbmap-code-identifier-strategy: 구분자 '_' 통일)
--   · 오버로크/말아박기/봉미싱(7cm) = OPV_000025/26/27 이미 존재 → mint 0.
-- 멱등: (prd_cd,opt_cd) PK NOT EXISTS 가드.
-- ============================================================================

-- 말아박기+면끈 (신규 OPV_000424). 오버로크+리본끈(OPV-000024)은 이미 존재하므로 INSERT 대상 아님(NOT EXISTS 로 자동 skip).
INSERT INTO t_prd_product_options
  (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, del_yn, reg_dt)
SELECT v.prd_cd, v.opt_cd, v.opt_grp_cd, v.opt_nm, v.dflt_yn, v.disp_seq, 'Y', 'N', now()
FROM (VALUES
  ('PRD_000124','OPV_000424','OPT_000009','말아박기+면끈','N',5)
) AS v(prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq)
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_options o
   WHERE o.prd_cd = v.prd_cd AND o.opt_cd = v.opt_cd
);
