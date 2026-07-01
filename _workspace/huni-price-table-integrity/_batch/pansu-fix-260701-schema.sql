-- 판걸이수 권위 저장소 + fn_calc_pansu lookup-first 교체 — 2026-07-01
-- [HARD] 판수=작업사이즈 기준. t_siz_pansu 는 실무진 imposition 시트(작업기준) 권위.
-- 멱등: CREATE TABLE IF NOT EXISTS / CREATE OR REPLACE. 라이브 직접 적용(웹 배포와 무관·DB 함수).
-- 2인자 시그니처 그대로 유지 → 기존 pricing.py(2인자 호출) 즉시 신로직 사용·오버로드 애매성 0·회귀 안전(폴백).

BEGIN;

CREATE TABLE IF NOT EXISTS t_siz_pansu (
    prd_cd       varchar(20),           -- NULL=사이즈 단위(generic). 자재/상품 종속 override 예약(투명 등·향후 prd_cd 인자 도입 시)
    plt_siz_cd   varchar(20) NOT NULL,  -- 판형(출력용지규격) 사이즈코드
    item_siz_cd  varchar(20) NOT NULL,  -- 아이템(완제품/내지) 사이즈코드
    pansu        integer     NOT NULL,  -- 실무진 판걸이수(작업사이즈 기준 imposition)
    src          varchar(40),           -- 출처
    note         varchar(200),
    reg_dt       timestamp DEFAULT now()
);
CREATE UNIQUE INDEX IF NOT EXISTS ux_t_siz_pansu
    ON t_siz_pansu (plt_siz_cd, item_siz_cd, COALESCE(prd_cd, ''));
COMMENT ON TABLE t_siz_pansu IS
'판걸이수 권위 저장소 — fn_calc_pansu lookup 우선(작업사이즈 기준 실무진 imposition). prd_cd NULL=사이즈단위 generic. 진원=인쇄상품가격표 판걸이수 시트.';

CREATE OR REPLACE FUNCTION fn_calc_pansu(p_plate_siz_cd varchar, p_item_siz_cd varchar)
RETURNS integer
LANGUAGE plpgsql
STABLE
AS $$
DECLARE
    v integer;
    pw numeric; ph numeric;   -- 판 실제영역(작업 − 여백)
    iw numeric; ih numeric;   -- 아이템 작업사이즈(여분포함)
    n_normal integer;
    n_rotate integer;
BEGIN
    -- (신규) 권위 판걸이수 우선 — 실무진 imposition 시트(작업사이즈 기준). generic(prd_cd NULL).
    SELECT pansu INTO v FROM t_siz_pansu
     WHERE plt_siz_cd = p_plate_siz_cd AND item_siz_cd = p_item_siz_cd AND prd_cd IS NULL
     LIMIT 1;
    IF v IS NOT NULL THEN RETURN v; END IF;

    -- (폴백) 기존 순수 기하 계산 — 권위 미등록 사이즈 회귀 방지(원본 로직 그대로).
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
'판걸이수 산출: t_siz_pansu(실무진 imposition 권위·작업사이즈 기준) lookup 우선 → 없으면 기하 폴백(작업-여백 / 아이템 작업, 회전 GREATEST). 2026-07-01 lookup-first 도입.';

COMMIT;
