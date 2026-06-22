-- backup 20260623_015051 — V1 과대청구 교정 대상 현재값 스냅샷 (read-only SELECT)
-- 대상 comp: COMP_NAMECARD_STD_S1/S2 (031/032/033), COMP_PCB_S1_20P/S2_20P (094)
-- verbatim 기준선: 명함 S1=2행/7300 S2=2행/9300 · PCB S1=117행/505980 S2=117행/526540 · GRAND 238행/1049120

-- ===== price_components.use_dims (현재값 = 원복 기준) =====
PC|COMP_NAMECARD_STD_S1|["mat_cd", "min_qty"]
PC|COMP_NAMECARD_STD_S2|["mat_cd", "min_qty"]
PC|COMP_PCB_S1_20P|["siz_cd", "min_qty"]
PC|COMP_PCB_S2_20P|["siz_cd", "min_qty"]

-- ===== component_prices.print_opt_cd (현재값 전 행 NULL) =====
CP|COMP_NAMECARD_STD_S1|print_opt_cd=NULL|rows=2|sum=7300.00
CP|COMP_NAMECARD_STD_S2|print_opt_cd=NULL|rows=2|sum=9300.00
CP|COMP_PCB_S1_20P|print_opt_cd=NULL|rows=117|sum=505980.00
CP|COMP_PCB_S2_20P|print_opt_cd=NULL|rows=117|sum=526540.00
