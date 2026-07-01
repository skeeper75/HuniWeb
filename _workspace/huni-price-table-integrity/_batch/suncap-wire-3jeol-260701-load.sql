-- 썬캡(PRD_000051·미출시) 3절 판형 연결 + 단가행 이관 — 2026-07-01
-- 사용자 결정: 썬캡을 3절 330x540(SIZ_000535)로 옮김(기존 국4절 단가 그대로 carry).
-- ★[돈-주의] 용지 아이보리(153.00)는 국4절(316x467) 단가 — 3절(330x540)은 면적 ~20%↑라
--   정확값보다 ~20% 저평가. shop 3절 용지단가 확보 시 재적재 필요(미출시라 라이브 영향 없음).
-- 인쇄(SIZ_000077 300x625)·커팅(판형독립)은 carry 타당. comp_price_id=IDENTITY 자동채번.
-- 멱등: NOT EXISTS 가드.
BEGIN;
-- 1) 상품↔판형 연결: 3절 추가 + 국4절(판수0 오연결) 논리삭제
INSERT INTO t_prd_product_plate_sizes (prd_cd,siz_cd,dflt_plt_yn,output_paper_typ_cd,output_file_typ,note,reg_dt,del_yn)
SELECT 'PRD_000051','SIZ_000535','Y',output_paper_typ_cd,output_file_typ,'3절 330x540 연결 260701',now(),'N'
  FROM t_prd_product_plate_sizes WHERE prd_cd='PRD_000051' AND siz_cd='SIZ_000499'
  AND NOT EXISTS (SELECT 1 FROM t_prd_product_plate_sizes WHERE prd_cd='PRD_000051' AND siz_cd='SIZ_000535');
UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now()
 WHERE prd_cd='PRD_000051' AND siz_cd='SIZ_000499' AND del_yn='N';

-- 2) 단가행 3절 복사(plt_siz_cd만 SIZ_000535로 교체) — 용지 아이보리1·인쇄 POPT_000001·완칼
INSERT INTO t_prc_component_prices
  (comp_cd,apply_ymd,siz_cd,clr_cd,mat_cd,coat_side_cnt,bdl_qty,min_qty,unit_price,note,reg_dt,proc_cd,opt_cd,dim_vals,print_opt_cd,plt_siz_cd,siz_width,siz_height)
SELECT comp_cd,apply_ymd,siz_cd,clr_cd,mat_cd,coat_side_cnt,bdl_qty,min_qty,unit_price,
       COALESCE(note,'')||' [3절복사260701]',now(),proc_cd,opt_cd,dim_vals,print_opt_cd,'SIZ_000535',siz_width,siz_height
  FROM t_prc_component_prices
 WHERE ((comp_cd='COMP_PAPER' AND plt_siz_cd='SIZ_000499' AND mat_cd='MAT_000149')
    OR (comp_cd='COMP_PRINT_DIGITAL_S1' AND plt_siz_cd='SIZ_000077' AND print_opt_cd='POPT_000001')
    OR (comp_cd='COMP_CUT_FULL_DIECUT' AND plt_siz_cd='SIZ_000499'))
   AND NOT EXISTS (SELECT 1 FROM t_prc_component_prices x WHERE x.plt_siz_cd='SIZ_000535');
COMMIT;

-- 3) [후속] 썬캡 디지털인쇄 base 공정(PROC_000004) 필수 바인딩 — 공정 전무라 인쇄비 미매칭이었음.
--    직전 18건 base-proc fix와 동형(mand_proc_yn='Y', disp_seq='-1'). 없어서 재적재분.
BEGIN;
INSERT INTO t_prd_product_processes (prd_cd,proc_cd,mand_proc_yn,disp_seq,reg_dt,del_yn)
SELECT 'PRD_000051','PROC_000004','Y','-1',now(),'N'
 WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_processes WHERE prd_cd='PRD_000051' AND proc_cd='PROC_000004');
COMMIT;
