-- =====================================================================
-- 봉투제작(ENV) component_prices 적재 (migrate.sql)
-- 생성: gen_load_sql.py (입력 CSV verbatim, 손편집 금지)
-- 단일 트랜잭션. 로더(apply.sh)가 ROLLBACK 주입(기본 DRY-RUN), --commit=인간 승인.
-- 1단계: 01 ENV 가격(40행). FK 부모(siz/comp/mat) 전건 라이브 선존재 → 등록 단계 없음(가격행 ONLY).
-- ENV = round-5 가장 단순 GO 트랙: siz 등록 0 · 바인딩 INSERT 0 · 코드행 0.
-- =====================================================================
\set ON_ERROR_STOP on
\timing on
BEGIN;

-- 가드 0: siz EXACT 재사용 불변식 — SIZ_000191~194 적재 전 라이브 존재(4)여야 정상(mint 아님).
--         <4 이면 작업사이즈 siz 부재 → STOP(발명 금지). 게이트 EXACT 매칭과 모순이므로 예외.
DO $$
DECLARE pre int;
BEGIN
  SELECT count(*) INTO pre FROM t_siz_sizes WHERE siz_cd IN ('SIZ_000191', 'SIZ_000192', 'SIZ_000193', 'SIZ_000194') AND del_yn = 'N';
  RAISE NOTICE '[guard0] ENV 작업사이즈 siz(191~194) 라이브 존재(4=PASS, EXACT 재사용·mint 0): %', pre;
  IF pre <> 4 THEN
    RAISE EXCEPTION 'ENV siz SIZ_000191~194 중 % 종만 라이브 존재 — EXACT 재사용 전제 위반. 중단(no invention).', pre;
  END IF;
END $$;

\i 01_component_prices.sql

-- 적재 후 어서션 (롤백 전 검증용 — DRY-RUN/검증에서 사용)
-- 1) FK 고아(siz): 본 적재 40 ENV 가격행의 siz_cd 전건 t_siz_sizes 존재 (0=PASS).
DO $$
DECLARE orphan int;
BEGIN
  SELECT count(*) INTO orphan FROM t_prc_component_prices cp
   LEFT JOIN t_siz_sizes s ON s.siz_cd = cp.siz_cd
   WHERE cp.comp_price_id IN (1713, 1714, 1715, 1716, 1717, 1718, 1719, 1720, 1721, 1722, 1723, 1724, 1725, 1726, 1727, 1728, 1729, 1730, 1731, 1732, 1733, 1734, 1735, 1736, 1737, 1738, 1739, 1740, 1741, 1742, 1743, 1744, 1745, 1746, 1747, 1748, 1749, 1750, 1751, 1752) AND s.siz_cd IS NULL;
  RAISE NOTICE '[assert] ENV 가격 40행 FK 고아(siz 미해소, 0=PASS): %', orphan;
  IF orphan <> 0 THEN
    RAISE EXCEPTION 'ENV 가격행 FK 고아(siz) % 건. 중단.', orphan;
  END IF;
END $$;

-- 2) FK(comp_cd): COMP_ENV_MAKING 가 t_prc_price_components 에 존재해야 (라이브 선존재).
DO $$
DECLARE n int;
BEGIN
  SELECT count(*) INTO n FROM t_prc_price_components WHERE comp_cd = 'COMP_ENV_MAKING';
  RAISE NOTICE '[assert] comp_cd COMP_ENV_MAKING 라이브 존재(1=PASS): %', n;
  IF n = 0 THEN
    RAISE EXCEPTION 'comp_cd COMP_ENV_MAKING 부재 — FK fk_prc_comp_prices_comp_cd 위반. 중단.';
  END IF;
END $$;

-- 3) FK(mat_cd): MAT_000159/168 이 t_mat_materials 에 존재해야 (라이브 선존재).
DO $$
DECLARE mat_orphan int;
BEGIN
  SELECT count(*) INTO mat_orphan FROM t_prc_component_prices cp
   LEFT JOIN t_mat_materials m ON m.mat_cd = cp.mat_cd
   WHERE cp.comp_price_id IN (1713, 1714, 1715, 1716, 1717, 1718, 1719, 1720, 1721, 1722, 1723, 1724, 1725, 1726, 1727, 1728, 1729, 1730, 1731, 1732, 1733, 1734, 1735, 1736, 1737, 1738, 1739, 1740, 1741, 1742, 1743, 1744, 1745, 1746, 1747, 1748, 1749, 1750, 1751, 1752) AND cp.mat_cd IS NOT NULL AND m.mat_cd IS NULL;
  RAISE NOTICE '[assert] ENV 가격 40행 FK 고아(mat 미해소, 0=PASS): %', mat_orphan;
  IF mat_orphan <> 0 THEN
    RAISE EXCEPTION 'ENV 가격행 FK 고아(mat) % 건 — MAT_000159/168 미존재. 중단.', mat_orphan;
  END IF;
END $$;

-- 4) 멱등성 카운트(검증 참고): 본 적재 comp_price_id 중 이미 라이브 존재분(DO NOTHING 대상).
DO $$
DECLARE existing int;
BEGIN
  SELECT count(*) INTO existing FROM t_prc_component_prices WHERE comp_price_id IN (1713, 1714, 1715, 1716, 1717, 1718, 1719, 1720, 1721, 1722, 1723, 1724, 1725, 1726, 1727, 1728, 1729, 1730, 1731, 1732, 1733, 1734, 1735, 1736, 1737, 1738, 1739, 1740, 1741, 1742, 1743, 1744, 1745, 1746, 1747, 1748, 1749, 1750, 1751, 1752);
  RAISE NOTICE '[assert] 본 적재 comp_price_id 라이브 선존재 수(1회차=0 기대, 2회차=40 기대): %', existing;
END $$;

COMMIT;
