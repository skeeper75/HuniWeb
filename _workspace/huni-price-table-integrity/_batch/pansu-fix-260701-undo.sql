-- UNDO — 판걸이수 lookup-first 교정 원복 (2026-07-01)
-- fn_calc_pansu 를 원본(순수 기하)으로 복원하고 t_siz_pansu 제거.
BEGIN;

CREATE OR REPLACE FUNCTION fn_calc_pansu(p_plate_siz_cd varchar, p_item_siz_cd varchar)
RETURNS integer
LANGUAGE plpgsql
STABLE
AS $$
DECLARE
    pw numeric; ph numeric;
    iw numeric; ih numeric;
    n_normal integer;
    n_rotate integer;
BEGIN
    SELECT work_width  - COALESCE(margin_lft, 0) - COALESCE(margin_rgt, 0),
           work_height - COALESCE(margin_top, 0) - COALESCE(margin_bot, 0)
      INTO pw, ph FROM t_siz_sizes WHERE siz_cd = p_plate_siz_cd;
    SELECT work_width, work_height
      INTO iw, ih FROM t_siz_sizes WHERE siz_cd = p_item_siz_cd;
    IF pw IS NULL OR ph IS NULL OR iw IS NULL OR ih IS NULL
       OR pw <= 0 OR ph <= 0 OR iw <= 0 OR ih <= 0 THEN
        RETURN NULL;
    END IF;
    n_normal := floor(pw / iw)::int * floor(ph / ih)::int;
    n_rotate := floor(pw / ih)::int * floor(ph / iw)::int;
    RETURN GREATEST(n_normal, n_rotate);
END;
$$;
COMMENT ON FUNCTION fn_calc_pansu(varchar, varchar) IS
'판걸이수 산출: 판형 실제영역(작업-여백)에 아이템 작업사이즈(여분포함)를 회전 포함 최대 몇 장 앉히는지. 실무 엑셀(여분포함 배치)과 검증 일치.';

DROP TABLE IF EXISTS t_siz_pansu;

COMMIT;
