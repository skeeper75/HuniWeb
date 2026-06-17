-- BK6a · A4 반칼 전용 siz 채번 (search-before-mint) — t_siz_sizes INSERT
-- 출처: bankal-058-064-deepcheck §2.3/§5.1 (SIZ_172=B02 낱장완칼 4000 점유·B01 반칼 A4=5000/6000 별개)
-- SIZ_000520 = A4(210x297) 반칼 전용. max siz=SIZ_000519 → 520 무충돌(search-before-mint).
-- impos_yn='N'(SIZ_172 A4 패턴 따름)·판수 2판=note. FK 위상: BK6c 단가행보다 선행.
INSERT INTO t_siz_sizes (siz_cd, siz_nm, impos_yn, use_yn, note, reg_dt)
SELECT 'SIZ_000520','A4(210x297mm) 반칼','N','Y','판걸이=2.0 / 적용=반칼스티커(058~061) / B02 낱장 SIZ_172와 분리(반칼 전용가)',now()
WHERE NOT EXISTS (SELECT 1 FROM t_siz_sizes s WHERE s.siz_cd='SIZ_000520');
