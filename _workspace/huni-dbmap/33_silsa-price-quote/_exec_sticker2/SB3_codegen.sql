-- SB3(채번) · 100x148·90x110 siz 코드행 선적재 (search-before-mint) — t_siz_sizes INSERT
-- 출처: sticker-blocked-resolution §5.2 (라이브 max siz_cd=SIZ_000517·exact 부재 확정)
-- SIZ_000518=100x148(판걸이8)·SIZ_000519=90x110(판걸이12). 판걸이=앱 임포지션(가격 미저장·note 보존).
-- impos_yn='Y'(국4절 인쇄=판걸이 유효). 치수=완제규격(작업/재단=미지정 NULL·앱 산출).
-- 멱등: siz_cd PK NOT EXISTS. FK 위상: SB3_b01_prices(단가행) 보다 선행(component_prices.siz_cd→t_siz_sizes).
INSERT INTO t_siz_sizes (siz_cd, siz_nm, impos_yn, use_yn, note, reg_dt)
SELECT v.siz_cd, v.siz_nm, 'Y', 'Y', v.note, now()
FROM (VALUES
  ('SIZ_000518','100x148','판걸이=8.0 / 적용=반칼스티커'),
  ('SIZ_000519','90x110','판걸이=12.0 / 적용=반칼스티커')
) AS v(siz_cd, siz_nm, note)
WHERE NOT EXISTS (SELECT 1 FROM t_siz_sizes s WHERE s.siz_cd=v.siz_cd);
