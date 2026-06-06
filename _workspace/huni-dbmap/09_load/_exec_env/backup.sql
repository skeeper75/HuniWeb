-- =====================================================================
-- backup.sql — 읽기전용 백업 스냅샷 (undo 권위본)
--   ENV = INSERT-only 가격 적재 → backup = COMP_ENV_MAKING component_prices 라이브=0 확증
--   (빈 슬롯 입증) + 본 적재 comp_price_id(1713..1752) 부재 확증. DB 쓰기 없음(\copy out 만).
-- =====================================================================
\set ON_ERROR_STOP on
-- 1) COMP_ENV_MAKING 기존 component_prices 스냅샷 (적재 전 = 0행 기대, 빈 슬롯 입증).
\copy (SELECT comp_price_id, comp_cd, apply_ymd, siz_cd, mat_cd, min_qty, unit_price FROM t_prc_component_prices WHERE comp_cd = 'COMP_ENV_MAKING' ORDER BY comp_price_id) TO 'backup_env_component_prices_before.csv' CSV HEADER

-- 2) 본 적재 comp_price_id 충돌 확증 (0행이어야 정상 — 1713..1752 라이브 부재).
\copy (SELECT comp_price_id FROM t_prc_component_prices WHERE comp_price_id IN (1713, 1714, 1715, 1716, 1717, 1718, 1719, 1720, 1721, 1722, 1723, 1724, 1725, 1726, 1727, 1728, 1729, 1730, 1731, 1732, 1733, 1734, 1735, 1736, 1737, 1738, 1739, 1740, 1741, 1742, 1743, 1744, 1745, 1746, 1747, 1748, 1749, 1750, 1751, 1752) ORDER BY comp_price_id) TO 'backup_env_id_collisions.csv' CSV HEADER  -- 0행=정상(충돌 없음)

-- 3) 재사용 마스터 선존재 확증 (siz 191~194 — undo 시 절대 제거 안 함).
\copy (SELECT siz_cd, siz_nm, work_width, work_height FROM t_siz_sizes WHERE siz_cd IN ('SIZ_000191', 'SIZ_000192', 'SIZ_000193', 'SIZ_000194') ORDER BY siz_cd) TO 'backup_env_reuse_siz.csv' CSV HEADER
