select pdt.comp_cd, pdt.prd_cd, pdt.dsc_tbl_cd, dt.dsc_tbl_nm
from t_prd_product_discount_tables pdt
left join t_dsc_discount_tables dt on dt.dsc_tbl_cd = pdt.dsc_tbl_cd
where pdt.comp_cd in (
 'COMP_PRINT_DIGITAL_S1','COMP_PRINT_DIGITAL_S2','COMP_PRINT_SPOT_WHITE_S1',
 'COMP_COAT_GLOSSY','COMP_COAT_MATTE',
 'COMP_FOLD_CARD_2H','COMP_FOLD_CARD_3H','COMP_FOLD_CARD_6CR',
 'COMP_FOLD_LEAF_3FOLD','COMP_FOLD_LEAF_4ACC','COMP_FOLD_LEAF_4GATE','COMP_FOLD_LEAF_HALF',
 'COMP_CUT_FULL_DIECUT','COMP_CUT_FULL_PERF_1H6','COMP_CUT_FULL_PERF_2H6','COMP_CUT_PERF_1H6','COMP_CUT_PERF_CAL'
)
order by pdt.comp_cd, pdt.prd_cd;
