-- foldcard-fix-dryrun.sql
-- 접지카드(PRD_000027 2단접지카드 / PRD_000029 3단접지카드) 접지 방향 옵션 참조 복구.
-- 권위: 인쇄상품_가격표_260527.xlsx '접지옵션' 시트 = 카드접지 2단==리플렛 반접지(5000..), 3단==리플렛 3단접지(6000..) 컬럼 verbatim 동일(48/48 tier diff 0).
-- 결론: 단가는 이미 정확(FOLD_LEAF_HALF proc065/066, FOLD_LEAF_3FOLD proc067/068). 결함은 옵션->공정 매핑(option_items)뿐.
-- 방식(a): 리플렛 단가 재사용 유지 + 깨진 방향 옵션 item 복구. COMP_FOLD_CARD_2H/3H 는 손대지 않음(미사용 확정·use_yn=N 후보로 별도 표시만).
-- 이중과금 0 증명: proc_cd 065/066/067/068 은 PRF_DGP_E 내 단 하나의 FOLD comp 에만 매칭(HALF=065/066/107, 3FOLD=060/067/068 → disjoint). CARD_2H/3H 는 PRF_DGP_E 에 미배선.
-- 실행 정책: DRYRUN(BEGIN..ROLLBACK). 실 COMMIT 은 인간 승인 후 별도.

BEGIN;

-- (1) 027 기본값 '2단 가로접지'(OPV_000107) item 이 오늘 생성 직후 del_yn=Y 로 논리삭제됨 → 라이브 복원.
UPDATE t_prd_product_option_items
   SET del_yn = 'N'
 WHERE prd_cd = 'PRD_000027' AND opt_cd = 'OPV_000107' AND item_seq = 1;

-- (2) 누락된 방향 옵션 item 추가(멱등). 각 proc_cd 는 해당 상품 t_prd_product_processes 에 이미 등록됨 → fn_chk_opt_item_ref 통과.
--     027: 065(가로)/066(세로) 등록됨.  029: 067(가로)/068(세로) 등록됨.
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, use_yn, del_yn)
VALUES
  ('PRD_000027','OPV_000108',1,'OPT_REF_DIM.04','PROC_000066','Y','N'),  -- 2단 세로접지
  ('PRD_000029','OPV_000135',1,'OPT_REF_DIM.04','PROC_000067','Y','N'),  -- 3단 가로접지(029 default)
  ('PRD_000029','OPV_000136',1,'OPT_REF_DIM.04','PROC_000068','Y','N')   -- 3단 세로접지
ON CONFLICT (prd_cd, opt_cd, item_seq) DO UPDATE
  SET ref_dim_cd = EXCLUDED.ref_dim_cd,
      ref_key1   = EXCLUDED.ref_key1,
      use_yn     = 'Y',
      del_yn     = 'N';

-- 검증: 4개 방향 모두 live·서로 다른 proc_cd(disjoint) 여야 함.
SELECT prd_cd, opt_cd, ref_dim_cd, ref_key1, use_yn, del_yn
  FROM t_prd_product_option_items
 WHERE (prd_cd,opt_cd) IN
       (('PRD_000027','OPV_000107'),('PRD_000027','OPV_000108'),
        ('PRD_000029','OPV_000135'),('PRD_000029','OPV_000136'))
 ORDER BY prd_cd, opt_cd;

COMMIT;  -- DRYRUN: 실제 반영 금지. COMMIT 은 인간 승인 후 이 파일에서 ROLLBACK->COMMIT 로 교체.
