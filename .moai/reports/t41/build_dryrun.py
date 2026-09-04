"""t41 dryrun.sql 생성 — apply 2회(멱등) + 검산 + rollback + ROLLBACK."""
import os

HERE = os.path.dirname(os.path.abspath(__file__))
body = open(f'{HERE}/apply.sql').read().split('\nBEGIN;\n', 1)[1].rsplit('COMMIT;', 1)[0]
# 검산 SELECT 3개는 따로 쓰므로 본문에서 뗀다
core = body.split('-- 검산 A:', 1)[0].rstrip()
rb = open(f'{HERE}/rollback.sql').read().split('\nBEGIN;\n', 1)[1].rsplit('COMMIT;', 1)[0].rstrip()

STATE = """SELECT 'plate' AS what, ps.siz_cd AS val, count(*) AS rows
  FROM t_prd_product_plate_sizes ps
 WHERE COALESCE(ps.del_yn,'N')='N'
   AND ps.prd_cd IN ('PRD_000052','PRD_000053','PRD_000054','PRD_000058','PRD_000059',
                     'PRD_000060','PRD_000061','PRD_000062','PRD_000063','PRD_000064',
                     'PRD_000065')
 GROUP BY 2
UNION ALL
SELECT 'use_dims', use_dims::text, 1 FROM t_prc_price_components
 WHERE comp_cd='STK_KISSCUT_PRINT'
UNION ALL
SELECT 'price_rows', 'total', count(*) FROM t_prc_component_prices
 WHERE comp_cd='STK_KISSCUT_PRINT'
 ORDER BY 1, 2;"""

parts = [
    "-- t41 DRY-RUN — apply 를 2회 돌려 멱등을 실증하고 rollback 까지 검증한 뒤 ROLLBACK 한다.",
    "-- 라이브에는 아무것도 남지 않는다.",
    "",
    r"\echo '=== 0. 적용 전 상태 ==='",
    STATE,
    "",
    "BEGIN;",
    "",
    r"\echo '=== 1. apply 1회 — UPDATE 10 / UPDATE 1 / INSERT 648 기대 ==='",
    core,
    "",
    r"\echo '=== 2. apply 2회(멱등) — UPDATE 0 / UPDATE 0 / INSERT 0 기대 ==='",
    core,
    "",
    r"\echo '=== 3. 적용 후 상태 — 판형 498x10 + 521x1(스티커팩) · use_dims 4축 · 단가행 2592 ==='",
    STATE,
    "",
    r"\echo '=== 4. 판수 실측 — 시트 판걸이와 같아야 한다(A6 8 · A5 4 · A4 2 · 100x140 8 · 124x186 4 · 90x190 6) ==='",
    ("SELECT s.siz_nm, fn_calc_pansu('SIZ_000498', s.siz_cd) AS pansu\n"
     "  FROM t_siz_sizes s\n"
     " WHERE s.siz_cd IN ('SIZ_000057','SIZ_000426','SIZ_000258','SIZ_000058',\n"
     "                    'SIZ_000059','SIZ_000060','SIZ_000067')\n"
     " ORDER BY 1;"),
    "",
    r"\echo '=== 5. rollback 검증 — DELETE 648 / UPDATE 1 / UPDATE 10 기대 ==='",
    rb,
    "",
    r"\echo '=== 6. 되돌린 뒤 상태 — 0번과 같아야 한다 ==='",
    STATE,
    "",
    r"\echo '=== 7. ROLLBACK ==='",
    "ROLLBACK;",
    "",
    r"\echo '=== 8. 트랜잭션 밖 재확인 — 라이브 원래대로여야 한다 ==='",
    STATE,
    "",
]
with open(f'{HERE}/dryrun.sql', 'w') as f:
    f.write('\n'.join(parts))
print('dryrun.sql 생성')
