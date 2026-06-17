-- U8_readability.sql — 실무진 가독성 정비 (§3 round-17 기준: comp_nm 코드 노출 제거·한국어 식별)
-- 멱등: 조건부 UPDATE(이미 정비값이면 WHERE 불일치 0행). 비-가격(comp_nm/note만). use_yn 무변.

UPDATE t_prc_price_components SET comp_nm='중철 제본비',           note='책자를 가운데 철심으로 묶는 제본', upd_dt=now() WHERE comp_cd='COMP_BIND_JUNGCHEOL'   AND comp_nm<>'중철 제본비';
UPDATE t_prc_price_components SET comp_nm='무선 제본비',           note='책등을 풀로 붙이는 제본(실/철심 없음)', upd_dt=now() WHERE comp_cd='COMP_BIND_MUSEON'      AND comp_nm<>'무선 제본비';
UPDATE t_prc_price_components SET comp_nm='PUR 제본비',            note='강력 접착제(PUR) 무선제본', upd_dt=now() WHERE comp_cd='COMP_BIND_PUR'         AND comp_nm<>'PUR 제본비';
UPDATE t_prc_price_components SET comp_nm='트윈링 제본비',         note='이중 링으로 묶는 제본', upd_dt=now() WHERE comp_cd='COMP_BIND_TWINRING'    AND comp_nm<>'트윈링 제본비';
UPDATE t_prc_price_components SET comp_nm='하드커버 무선 제본비',   note='양장 표지 + 무선제본', upd_dt=now() WHERE comp_cd='COMP_BIND_HC_MUSEON'   AND comp_nm<>'하드커버 무선 제본비';
UPDATE t_prc_price_components SET comp_nm='하드커버 트윈링 제본비', note='양장 표지 + 트윈링', upd_dt=now() WHERE comp_cd='COMP_BIND_HC_TWINRING' AND comp_nm<>'하드커버 트윈링 제본비';
UPDATE t_prc_price_components SET comp_nm='하드커버(싸바리) 제본비', note='합지 표지 양장제본', upd_dt=now() WHERE comp_cd='COMP_BIND_SSABARI'     AND comp_nm<>'하드커버(싸바리) 제본비';
UPDATE t_prc_price_components SET comp_nm='탁상달력 제본비(130)',  note='탁상용 캘린더 스프링 제본(130)', upd_dt=now() WHERE comp_cd='COMP_BIND_CAL_DESK130'  AND comp_nm<>'탁상달력 제본비(130)';
UPDATE t_prc_price_components SET comp_nm='탁상달력 제본비(220)',  note='탁상용 캘린더 스프링 제본(220)', upd_dt=now() WHERE comp_cd='COMP_BIND_CAL_DESK220'  AND comp_nm<>'탁상달력 제본비(220)';
UPDATE t_prc_price_components SET comp_nm='탁상달력 제본비(미니)', note='탁상용 캘린더 스프링 제본(미니)', upd_dt=now() WHERE comp_cd='COMP_BIND_CAL_DESKMINI' AND comp_nm<>'탁상달력 제본비(미니)';
UPDATE t_prc_price_components SET comp_nm='벽걸이달력 제본비',     note='벽걸이 캘린더 제본', upd_dt=now() WHERE comp_cd='COMP_BIND_CAL_WALL'    AND comp_nm<>'벽걸이달력 제본비';
UPDATE t_prc_price_components SET comp_nm='귀돌이(둥근 모서리)',   note='모서리를 둥글게 깎는 가공(주문수량 구간별 작업 1건 고정 금액)', upd_dt=now() WHERE comp_cd='COMP_PP_CORNER_ROUND'  AND comp_nm<>'귀돌이(둥근 모서리)';
UPDATE t_prc_price_components SET comp_nm='직각 모서리(귀돌이 없음)', note='모서리 가공 안 함(직각)', upd_dt=now() WHERE comp_cd='COMP_PP_CORNER_RIGHT' AND comp_nm<>'직각 모서리(귀돌이 없음)';
UPDATE t_prc_price_components SET comp_nm='오시(접는 줄)',         note='접기 쉽게 누름선(줄수=dim_vals.줄수)', upd_dt=now() WHERE comp_cd='COMP_PP_CREASE_1L'    AND comp_nm<>'오시(접는 줄)';
UPDATE t_prc_price_components SET comp_nm='미싱(점선 절취)',       note='떼어내기 쉬운 점선(줄수=dim_vals.줄수)', upd_dt=now() WHERE comp_cd='COMP_PP_PERF_1L'      AND comp_nm<>'미싱(점선 절취)';
