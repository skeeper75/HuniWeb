-- 썬캡 3절 판형(330x540) 신규 등록 — 2026-07-01
-- 사용자 결정: 썬캡(미출시) 권위 판형 = 3절 330x540(판걸이수시트·판수1). 라이브 미등록이라 신설.
-- 근거: 완제품 313x400(SIZ_000195)이 국4절(316x467)엔 여백 제하면 미달→판수0→견적0.
--       330x540 신 판형에선 기하 판수=1(DRY-RUN 실증) → 판걸이수 lookup 불요.
-- [주의] 이 판형 등록만으로 썬캡이 가격계산되진 않음 — 썬캡 용지/커팅/인쇄 단가행을
--        plt_siz_cd=SIZ_000535 로 세워야 함(3절 단가는 별도 확인·§18/§7). 판형은 additive·안전.
-- 멱등: NOT EXISTS 가드.
BEGIN;
INSERT INTO t_siz_sizes
  (siz_cd,siz_nm,work_width,work_height,cut_width,cut_height,
   margin_top,margin_bot,margin_lft,margin_rgt,impos_yn,use_yn,del_yn,note,tags,reg_dt)
SELECT 'SIZ_000535','330x540',330,540,320,530,5,5,5,5,'Y','Y','N',
       '3절 전지 - 썬캡 판형(권위 판걸이수시트 330x540 판수1) 260701','["3절"]',now()
WHERE NOT EXISTS (SELECT 1 FROM t_siz_sizes WHERE siz_cd='SIZ_000535');
COMMIT;
