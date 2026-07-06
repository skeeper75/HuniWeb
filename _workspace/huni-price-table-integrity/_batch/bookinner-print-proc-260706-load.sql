-- 책자 내지 5종 디지털인쇄 공정 미배선 교정 (저청구·돈 크리티컬)
-- 발견: dim-editor-audit/DISCOUNT-CONFORMANCE-FINDINGS-260706.md 결함3
-- 기전: COMP_PRINT_DIGITAL_S1 단가행은 전부 PROC_000004(디지털인쇄)에만 충전(625행).
--   책자 내지 5종은 t_prd_product_processes 배선이 없어 인쇄방식 드롭다운이 옵셋·디지털·실크 3개
--   전부 노출 → 고객이 옵셋(PROC_000003)/실크(PROC_000005) 선택 시 인쇄비=0 저청구.
--   형제 하드커버내지(PRD_000284)는 PROC_000004 배선(mand Y·seq -1)이라 디지털만 노출·인쇄비 정상.
-- 교정 = 5종에 PROC_000004(mand Y·seq -1) 배선 → 드롭다운 디지털 제약·0원 경로 차단.
-- 실측 확증(qty100·SIZ_000170·MAT_000072): 미배선 옵셋선택 final=768(인쇄비0) vs 디지털 final=20,768(인쇄비 20,000).
-- 멱등: PK=(prd_cd, proc_cd). ON CONFLICT DO UPDATE. base 단가 무변경(공정 배선만).
-- [HARD] COMMIT은 인간 승인 + 각 상품 webadmin 실화면(인쇄방식 디지털 제약·인쇄비 정상) 재확인 후에만.

BEGIN;

INSERT INTO t_prd_product_processes (prd_cd, proc_cd, mand_proc_yn, disp_seq, del_yn)
VALUES
  ('PRD_000285', 'PROC_000004', 'Y', -1, 'N'),  -- 레더 하드커버책자-내지
  ('PRD_000286', 'PROC_000004', 'Y', -1, 'N'),  -- 하드커버 링책자-내지
  ('PRD_000287', 'PROC_000004', 'Y', -1, 'N'),  -- 중철책자-내지
  ('PRD_000289', 'PROC_000004', 'Y', -1, 'N'),  -- 무선책자-내지
  ('PRD_000291', 'PROC_000004', 'Y', -1, 'N')   -- PUR책자-내지
ON CONFLICT (prd_cd, proc_cd)
DO UPDATE SET mand_proc_yn = EXCLUDED.mand_proc_yn, disp_seq = EXCLUDED.disp_seq,
              del_yn = 'N', upd_dt = now();

-- 사후 검증(트랜잭션 내)
SELECT prd_cd, proc_cd, mand_proc_yn, disp_seq
FROM t_prd_product_processes
WHERE prd_cd IN ('PRD_000285','PRD_000286','PRD_000287','PRD_000289','PRD_000291')
ORDER BY prd_cd;

COMMIT;
