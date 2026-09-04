"""apply.sql 본문을 재사용해 dryrun.sql 을 만든다(2회 실행 + 사후 셀대조 + ROLLBACK)."""
import os
import re

HERE = os.path.dirname(os.path.abspath(__file__))
apply_sql = open(f'{HERE}/apply.sql').read()
# BEGIN 과 COMMIT 사이의 INSERT 문만 떼어낸다
m = re.search(r'\nBEGIN;\n(.*?)\n-- 검산:', apply_sql, re.S)
insert = m.group(1).strip()

rollback_sql = open(f'{HERE}/rollback.sql').read()
m2 = re.search(r'\nBEGIN;\n\n(DELETE FROM.*?);\n', rollback_sql, re.S)
delete = m2.group(1).strip() + ';'

COUNTS = ("SELECT siz_cd, count(*) AS rows FROM t_prc_component_prices\n"
          " WHERE comp_cd='STK_KISSCUT_PRINT'\n"
          " GROUP BY 1 ORDER BY 1;")
TOTAL = ("SELECT count(*) AS total_rows FROM t_prc_component_prices\n"
         " WHERE comp_cd='STK_KISSCUT_PRINT';")

parts = [
    "-- t40 DRY-RUN — apply 를 2회 돌려 멱등을 실증하고 마지막에 ROLLBACK 한다.",
    "-- 라이브에는 아무것도 남지 않는다.",
    "",
    r"\echo '=== 0. 적용 전 사이즈별 행수 ==='",
    COUNTS, TOTAL,
    "",
    "BEGIN;",
    "",
    r"\echo '=== 1. apply 1회 — INSERT 648 기대 ==='",
    insert,
    "",
    r"\echo '=== 2. apply 2회(멱등) — INSERT 0 기대 ==='",
    insert,
    "",
    r"\echo '=== 3. 적용 후 사이즈별 행수 — 057=8자재 288 · 058=288 · 067=288 기대 ==='",
    COUNTS, TOTAL,
    "",
    r"\echo '=== 4. 사후 셀대조용 — 넣은 행의 자재/수량 축이 형제와 같은지 ==='",
    ("SELECT siz_cd, count(DISTINCT mat_cd) AS mats, count(DISTINCT min_qty) AS qtys\n"
     "  FROM t_prc_component_prices WHERE comp_cd='STK_KISSCUT_PRINT'\n"
     " GROUP BY 1 ORDER BY 1;"),
    "",
    r"\echo '=== 5. 다른 구성요소/사이즈 무변경 확인 — 고아 518·519 는 576행 그대로 ==='",
    ("SELECT siz_cd, count(*) FROM t_prc_component_prices\n"
     " WHERE comp_cd='STK_KISSCUT_PRINT' AND siz_cd IN ('SIZ_000518','SIZ_000519')\n"
     " GROUP BY 1 ORDER BY 1;"),
    "",
    r"\echo '=== 6. rollback 문 검증 — DELETE 648 기대 ==='",
    delete,
    "",
    r"\echo '=== 7. 되돌린 뒤 행수 — 0번과 같아야 한다 ==='",
    COUNTS, TOTAL,
    "",
    r"\echo '=== 8. ROLLBACK ==='",
    "ROLLBACK;",
    "",
    r"\echo '=== 9. 트랜잭션 밖 재확인 — 라이브 원래대로여야 한다 ==='",
    COUNTS, TOTAL,
    "",
]
with open(f'{HERE}/dryrun.sql', 'w') as f:
    f.write('\n'.join(parts))
print('dryrun.sql 생성')
