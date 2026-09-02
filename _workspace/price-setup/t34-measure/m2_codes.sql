with codes(comp_cd) as (
  values
   ('COMP_PP_CORNER_RIGHT'),('COMP_PP_CREASE_1L'),('COMP_PP_PERF_1L'),
   ('COMP_PP_VARTEXT_1EA'),('COMP_PP_VARIMG_1EA'),('COMP_CUT_FULL_DIECUT'),('COMP_ENV_MAKING'),
   ('PRINT_SUPERA3_CMYK'),('PRINT_WIDE_CMYK'),('PRINT_SUPERA3_SPOT'),
   ('COAT_SUPERA3_Laminating'),('COAT_WIDE_Laminating'),
   ('FOLD_CARD_processing'),('FOLD_LEAFLLET_processing'),('PUNCHING_processing')
)
select c.comp_cd,
       pc.comp_nm,
       pc.use_dims,
       (select count(*) from t_prc_component_prices cp where cp.comp_cd=c.comp_cd) as price_row_cnt,
       (select count(*) from t_prc_formula_components fc where fc.comp_cd=c.comp_cd) as formula_ref_cnt
from codes c
left join t_prc_price_components pc on pc.comp_cd=c.comp_cd
order by c.comp_cd;
