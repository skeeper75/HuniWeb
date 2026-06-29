-- 디지털 흑백(1도) 단면 단가 적재 — 인쇄옵션 POPT_000008(단면1도·앞면도수 CLR_000002)
-- 권위=인쇄상품 가격표 디지털인쇄비 시트(흑백 단면 col B) verbatim · 칼라(POPT_000001) 구조 미러
-- comp=COMP_PRINT_DIGITAL_S1 · proc=PROC_000004 · clr_cd=NULL(도수는 print_opt가 보유) · 칼라 212행 무변경
-- [HARD] 인간 승인 전 COMMIT 금지
BEGIN;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000077','POPT_000008',1,3500,'디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 1장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000077','POPT_000008',2,2500,'디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 2장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000077','POPT_000008',3,2000,'디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 3장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000077','POPT_000008',4,1800,'디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 4장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000077','POPT_000008',5,1200,'디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 5장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000077','POPT_000008',6,900,'디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 6장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000077','POPT_000008',7,800,'디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 7장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000077','POPT_000008',8,700,'디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 8장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000077','POPT_000008',9,600,'디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 9장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000077','POPT_000008',10,500,'디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 10장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000077','POPT_000008',15,610,'디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 15장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000077','POPT_000008',20,540,'디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 20장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000077','POPT_000008',25,470,'디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 25장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000077','POPT_000008',30,410,'디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 30장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000077','POPT_000008',35,380,'디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 35장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000077','POPT_000008',40,340,'디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 40장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000077','POPT_000008',45,340,'디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 45장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000077','POPT_000008',50,340,'디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 50장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000077','POPT_000008',60,270,'디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 60장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000077','POPT_000008',70,270,'디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 70장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000077','POPT_000008',80,270,'디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 80장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000077','POPT_000008',90,270,'디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 90장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000077','POPT_000008',100,270,'디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 100장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000077','POPT_000008',150,190,'디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 150장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000077','POPT_000008',200,180,'디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 200장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000077','POPT_000008',250,160,'디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 250장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000077','POPT_000008',300,150,'디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 300장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000077','POPT_000008',350,140,'디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 350장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000077','POPT_000008',400,120,'디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 400장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000077','POPT_000008',450,110,'디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 450장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000077','POPT_000008',500,95,'디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 500장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000077','POPT_000008',600,95,'디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 600장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000077','POPT_000008',700,95,'디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 700장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000077','POPT_000008',800,95,'디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 800장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000077','POPT_000008',900,95,'디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 900장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000077','POPT_000008',1000,95,'디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 1000장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000077','POPT_000008',1200,95,'디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 1200장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000077','POPT_000008',1400,88,'디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 1400장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000077','POPT_000008',1600,88,'디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 1600장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000077','POPT_000008',1800,81,'디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 1800장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000077','POPT_000008',2000,81,'디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 2000장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000077','POPT_000008',2500,75,'디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 2500장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000077','POPT_000008',3000,75,'디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 3000장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000077','POPT_000008',3500,68,'디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 3500장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000077','POPT_000008',4000,68,'디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 4000장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000077','POPT_000008',4500,61,'디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 4500장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000077','POPT_000008',5000,61,'디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 5000장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000077','POPT_000008',6000,54,'디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 6000장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000077','POPT_000008',7000,54,'디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 7000장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000077','POPT_000008',8000,54,'디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 8000장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000077','POPT_000008',9000,54,'디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 9000장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000077','POPT_000008',10000,54,'디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 10000장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000077','POPT_000008',1000000,54,'디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수 1000000장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000499','POPT_000008',1,3000,'디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 1장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000499','POPT_000008',2,2000,'디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 2장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000499','POPT_000008',3,1600,'디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 3장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000499','POPT_000008',4,1400,'디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 4장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000499','POPT_000008',5,1200,'디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 5장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000499','POPT_000008',6,900,'디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 6장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000499','POPT_000008',7,800,'디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 7장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000499','POPT_000008',8,700,'디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 8장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000499','POPT_000008',9,600,'디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 9장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000499','POPT_000008',10,500,'디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 10장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000499','POPT_000008',15,450,'디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 15장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000499','POPT_000008',20,400,'디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 20장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000499','POPT_000008',25,350,'디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 25장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000499','POPT_000008',30,300,'디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 30장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000499','POPT_000008',35,280,'디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 35장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000499','POPT_000008',40,250,'디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 40장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000499','POPT_000008',45,250,'디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 45장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000499','POPT_000008',50,250,'디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 50장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000499','POPT_000008',60,200,'디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 60장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000499','POPT_000008',70,200,'디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 70장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000499','POPT_000008',80,200,'디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 80장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000499','POPT_000008',90,200,'디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 90장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000499','POPT_000008',100,200,'디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 100장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000499','POPT_000008',150,140,'디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 150장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000499','POPT_000008',200,130,'디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 200장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000499','POPT_000008',250,120,'디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 250장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000499','POPT_000008',300,110,'디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 300장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000499','POPT_000008',350,100,'디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 350장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000499','POPT_000008',400,90,'디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 400장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000499','POPT_000008',450,80,'디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 450장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000499','POPT_000008',500,70,'디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 500장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000499','POPT_000008',600,70,'디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 600장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000499','POPT_000008',700,70,'디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 700장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000499','POPT_000008',800,70,'디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 800장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000499','POPT_000008',900,70,'디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 900장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000499','POPT_000008',1000,70,'디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 1000장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000499','POPT_000008',1200,70,'디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 1200장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000499','POPT_000008',1400,65,'디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 1400장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000499','POPT_000008',1600,65,'디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 1600장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000499','POPT_000008',1800,60,'디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 1800장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000499','POPT_000008',2000,60,'디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 2000장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000499','POPT_000008',2500,55,'디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 2500장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000499','POPT_000008',3000,55,'디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 3000장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000499','POPT_000008',3500,50,'디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 3500장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000499','POPT_000008',4000,50,'디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 4000장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000499','POPT_000008',4500,45,'디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 4500장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000499','POPT_000008',5000,45,'디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 5000장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000499','POPT_000008',6000,40,'디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 6000장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000499','POPT_000008',7000,40,'디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 7000장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000499','POPT_000008',8000,40,'디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 8000장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000499','POPT_000008',9000,40,'디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 9000장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000499','POPT_000008',10000,40,'디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 10000장 이상',now())
  ON CONFLICT DO NOTHING;
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, unit_price, note, reg_dt) VALUES ('COMP_PRINT_DIGITAL_S1','2026-06-01','PROC_000004','SIZ_000499','POPT_000008',1000000,40,'디지털인쇄 출력비(국4절)/흑백(1도)/단면 출력매수 1000000장 이상',now())
  ON CONFLICT DO NOTHING;
SELECT count(*) AS inserted FROM t_prc_component_prices WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND print_opt_cd='POPT_000008';
ROLLBACK;
