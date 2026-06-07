-- 02_t_prc_price_components.sql  — 신규 component COMP_PAPER (용지비) 1행
-- 멱등: PK comp_cd → ON CONFLICT (comp_cd) DO NOTHING
-- comp_typ_cd=PRC_COMPONENT_TYPE.03 (용지비). reg_dt/upd_dt omit.

-- src: t_prc_price_components_PAPER.csv:2  key=COMP_PAPER
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_PAPER', '용지비(종이별 절가)', 'PRC_COMPONENT_TYPE.03', '신규: 디지털인쇄 용지비. 차원=mat_cd(종이)×siz_cd(출력용지규격). unit_price=종이별 절가(국4절가/3절가). 손지율(+5장)·출력매수곱은 앱 런타임(C-4)', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
