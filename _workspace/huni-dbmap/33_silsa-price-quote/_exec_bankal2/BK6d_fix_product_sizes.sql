-- BK6d · 058~061 A4 등록 siz 교정 (SIZ_172 B02낱장 → SIZ_000520 반칼전용) — t_prd_product_sizes
-- 출처: bankal-058-064-deepcheck §5.2 (058~061 A4가 SIZ_172=B02 낱장 4000 점유 → 반칼 전용가 SIZ_520로 정합)
-- ★058~061 한정(완칼 낱장 055/056 SIZ_172 무접촉). PK=(prd_cd,siz_cd).
-- 멱등: SIZ_172→520 UPDATE는 1회만(이미 520이면 매칭 0). 단 (prd,520) 선존재 시 PK 충돌 회피(NOT EXISTS).
UPDATE t_prd_product_sizes ps
   SET siz_cd='SIZ_000520', upd_dt=now()
 WHERE ps.prd_cd IN ('PRD_000058','PRD_000059','PRD_000060','PRD_000061')
   AND ps.siz_cd='SIZ_000172'
   AND NOT EXISTS (
     SELECT 1 FROM t_prd_product_sizes d
      WHERE d.prd_cd=ps.prd_cd AND d.siz_cd='SIZ_000520'
   );
