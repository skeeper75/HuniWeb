-- t44 판형 적합 판정 — Max Page 표지 펼침(작업사이즈) × 라이브 판형 인벤토리
--
-- 아이템 작업사이즈 = Max Page 펼침(maxpage_spread.py 산출) + 2×블리드
--   블리드는 권위 「판걸이수」 r62/r63 = 3.0mm (표지 행 공통)
-- 판걸이 산식은 fn_calc_pansu 원문 그대로:
--   n_normal = floor(pw/iw) * floor(ph/ih),  n_rotate = floor(pw/ih) * floor(ph/iw)
--   pw,ph = 판형 작업 − 여백(실영역)

WITH item(label, iw, ih, src) AS (
  VALUES
    -- Max Page 계산본(책등 26mm · 블리드 3mm 사방)
    ('A5 펼침@maxpage 322x210 +블리드', 328.0::numeric, 216.0::numeric, 'maxpage'),
    ('A4 펼침@maxpage 446x297 +블리드', 452.0::numeric, 303.0::numeric, 'maxpage'),
    -- 권위 시트 고정 표지치수(블리드 3mm 포함) — 대조군
    ('A5 시트고정 330x210 +블리드 (SIZ_000632)', 336.0::numeric, 216.0::numeric, 'sheet'),
    ('A4 시트고정 454x297 +블리드 (SIZ_000633)', 460.0::numeric, 303.0::numeric, 'sheet'),
    -- 하드커버 케이스 랩(블리드 0) — 대조군
    ('하드커버 A5 케이스 390x268 (SIZ_000634)', 390.0::numeric, 268.0::numeric, 'sheet'),
    ('하드커버 A4 케이스 532x355 (SIZ_000635)', 532.0::numeric, 355.0::numeric, 'sheet')
),
plate AS (
  SELECT siz_cd, siz_nm,
         work_width  - COALESCE(margin_lft,0) - COALESCE(margin_rgt,0) AS pw,
         work_height - COALESCE(margin_top,0) - COALESCE(margin_bot,0) AS ph,
         work_width AS ww, work_height AS wh
    FROM t_siz_sizes
   WHERE siz_cd IN ('SIZ_000499','SIZ_000475','SIZ_000535','SIZ_000640','SIZ_000641')
)
SELECT i.label AS item,
       i.src,
       p.siz_cd AS plate,
       p.siz_nm AS plate_nm,
       (p.pw || 'x' || p.ph) AS 실영역,
       GREATEST(
         floor(p.pw / i.iw)::int * floor(p.ph / i.ih)::int,
         floor(p.pw / i.ih)::int * floor(p.ph / i.iw)::int
       ) AS pansu,
       CASE WHEN GREATEST(
              floor(p.pw / i.iw)::int * floor(p.ph / i.ih)::int,
              floor(p.pw / i.ih)::int * floor(p.ph / i.iw)::int) >= 1
            THEN '들어감' ELSE '불가' END AS 판정
  FROM item i CROSS JOIN plate p
 ORDER BY i.src DESC, i.label, pansu DESC, p.siz_cd;
