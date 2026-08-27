"""일반현수막 완제품가 중복 단가행 삭제 (물리 DELETE 1행).

지니 지시(2026-08-27): 「일반 현수막 완제품가 중복행을 삭제해줘. 이것은 라이브DB에서
확인하고 삭제해줘.」

실측 — `COMP_POSTER_BANNER_NORMAL` 81행 중 중복 1건:
    siz_width=1500 · siz_height=1000 · apply_ymd=2026-06-01 · min_qty=1
      id 38147  12,000  note 동일  reg_dt 06-19 06:23:06.765281  upd_dt 08-27 22:43:53
      id 38158  12,000  note 동일  reg_dt 06-19 06:23:06.789684  upd_dt 없음
    81행 − 1 = 80 = 고유 (가로,세로) 조합 수

권위 대조: 「포스터사인」 r247(세로 1000mm) × E열(가로 1500mm) = 12,000 — 두 행 모두 일치.

남길 행 = **38147**. 근거 셋:
  ① reg_dt 가 24µs 빠르다 — 같은 배치의 첫 삽입이고 38158 이 중복 삽입분이다
  ② 38147 만 upd_dt 가 있다(오늘 22:43:53) — 이후 관리 대상이 된 행이다
  ③ 값·note·차원이 완전히 같아 어느 쪽을 남겨도 가격 결과는 동일하다

★ 물리 DELETE 다. 라이브 관례상 논리삭제(`del_yn`)를 쓰지만
  `t_prc_component_prices` 에는 `del_yn` 컬럼이 **없다**(실측). 그래서 물리 삭제만
  가능하며, 백업에 **복원 INSERT SQL 전체 컬럼**을 남긴다.

[HARD] 8 순서: 드라이런(강제 롤백) → 백업 → 승인 → COMMIT → psql 재실측 → 실화면

실행:
  드라이런  raw/webadmin/.venv/bin/python .../fix_banner_normal_dup_row.py
  실적재    raw/webadmin/.venv/bin/python .../fix_banner_normal_dup_row.py --commit
"""
import os
import sys
from datetime import datetime

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", ".."))
sys.path.insert(0, os.path.join(ROOT, "raw", "webadmin", "webadmin"))
os.environ.setdefault("DJANGO_SETTINGS_MODULE", "config.settings")

from dotenv import load_dotenv  # noqa: E402
load_dotenv(os.path.join(ROOT, "raw", "webadmin", ".env"))

import django  # noqa: E402
django.setup()

from django.db import connection, transaction  # noqa: E402

COMP = "COMP_POSTER_BANNER_NORMAL"
KEEP_ID = 38147
DROP_ID = 38158
AUTHORITY = 12000  # 「포스터사인」 r247 x E열

BACKUP = os.path.join(ROOT, "_workspace", "huni-widget-wiring", "out", "backup",
                      "pre-banner-normal-dup-row-260827.txt")


class Rollback(Exception):
    """드라이런 강제 롤백 신호."""


def q(sql, params=None):
    c = connection.cursor()
    c.execute(sql, params or [])
    cols = [d[0] for d in c.description]
    return [dict(zip(cols, r)) for r in c.fetchall()]


def one(sql, params=None):
    c = connection.cursor()
    c.execute(sql, params or [])
    return c.fetchone()


def report(tag):
    stamp = one("SELECT to_char(now() AT TIME ZONE 'Asia/Seoul','YYYY-MM-DD HH24:MI:SS')")[0]
    rows, wh = one("""SELECT COUNT(*), COUNT(DISTINCT (siz_width, siz_height))
                        FROM t_prc_component_prices WHERE comp_cd=%s""", [COMP])
    dups = q("""SELECT siz_width, siz_height, COUNT(*) n
                  FROM t_prc_component_prices WHERE comp_cd=%s
                 GROUP BY 1,2 HAVING COUNT(*)>1""", [COMP])
    wgt, prd = one("""SELECT COUNT(*), COUNT(DISTINCT prd_cd) FROM t_wgt_widgets
                      WHERE sts_typ_cd='WGT_STS_TYPE.02' AND COALESCE(del_yn,'N')='N'""")
    print(f"  [{tag}] {stamp} KST · 게시 {wgt}|{prd}")
    print(f"      단가행 {rows} · 고유(가로,세로) {wh} · 중복 그룹 {len(dups)}")
    for d in dups:
        print(f"        ⚠️ {d['siz_width']}x{d['siz_height']} — {d['n']}행")
    live = q("""SELECT comp_price_id, unit_price FROM t_prc_component_prices
                 WHERE comp_cd=%s AND siz_width=1500 AND siz_height=1000
                 ORDER BY comp_price_id""", [COMP])
    print(f"      1500x1000 행: {[(r['comp_price_id'], int(r['unit_price'])) for r in live]}")
    return rows, wh, len(dups)


def write_backup(row):
    os.makedirs(os.path.dirname(BACKUP), exist_ok=True)
    stamp = one("SELECT to_char(now() AT TIME ZONE 'Asia/Seoul','YYYY-MM-DD HH24:MI:SS')")[0]
    cols = [k for k in row.keys()]
    vals = []
    for k in cols:
        v = row[k]
        vals.append("NULL" if v is None else
                    (str(v) if isinstance(v, (int, float)) or k == "comp_price_id"
                     else "'" + str(v).replace("'", "''") + "'"))
    with open(BACKUP, "w", encoding="utf-8") as f:
        f.write("# 적재 직전 백업 — 일반현수막 완제품가 중복행 물리 삭제\n")
        f.write(f"# 생성 {stamp} KST\n")
        f.write(f"# 삭제 대상 comp_price_id={DROP_ID} · 유지 comp_price_id={KEEP_ID}\n\n")
        f.write("## 삭제 행 전체 값\n")
        for k in cols:
            f.write(f"#   {k} = {row[k]!r}\n")
        f.write("\n## 되돌리기 SQL (comp_price_id 를 그대로 복원한다)\n")
        f.write(f"INSERT INTO t_prc_component_prices ({', '.join(cols)})\n"
                f"VALUES ({', '.join(vals)});\n")
    print(f"  백업 기록: {BACKUP}")


def main():
    commit = "--commit" in sys.argv
    print("=" * 78)
    print(f"일반현수막 완제품가 중복행 삭제 — "
          f"{'COMMIT(실삭제)' if commit else 'DRY-RUN(강제 롤백)'}")
    print("=" * 78)

    # 선행 확인 — 두 행이 정말 같은가, 권위와 맞는가
    pair = q("""SELECT * FROM t_prc_component_prices
                 WHERE comp_price_id IN (%s, %s) ORDER BY comp_price_id""",
             [KEEP_ID, DROP_ID])
    if len(pair) != 2:
        print(f"\n  멱등 건너뜀 — 대상 2행이 아니다(현재 {len(pair)}행). 이미 정리됐을 수 있다.")
        print("\n[현재 상태]")
        report("current")
        return
    a, b = pair
    same = all(a[k] == b[k] for k in ("comp_cd", "apply_ymd", "min_qty", "unit_price",
                                      "note", "siz_width", "siz_height"))
    if not same:
        raise SystemExit("중단: 두 행이 동일하지 않다. 중복이 아니므로 삭제하면 안 된다.")
    if int(a["unit_price"]) != AUTHORITY:
        raise SystemExit(f"중단: 단가 {a['unit_price']} 가 권위 {AUTHORITY} 와 다르다.")
    print(f"\n  동일성 확인: 두 행의 차원·단가·note 일치 · 단가 {int(a['unit_price']):,} = 권위 {AUTHORITY:,}")
    print(f"  유지 {KEEP_ID} (upd_dt={a['upd_dt']}) · 삭제 {DROP_ID} (upd_dt={b['upd_dt']})")

    print("\n[삭제 전]")
    rows0, wh0, dup0 = report("before")

    if commit:
        write_backup(b)

    try:
        with transaction.atomic():
            print("\n[삭제]")
            c = connection.cursor()
            c.execute("DELETE FROM t_prc_component_prices WHERE comp_price_id=%s", [DROP_ID])
            print(f"  DELETE {c.rowcount}행 — comp_price_id={DROP_ID}")

            print("\n[삭제 후]")
            rows1, wh1, dup1 = report("after")
            if rows1 != rows0 - 1 or wh1 != wh0 or dup1 != 0:
                raise SystemExit(
                    f"중단: 기대와 다르다 (행 {rows0}→{rows1}, 고유 {wh0}→{wh1}, 중복 {dup1}).")
            print(f"\n  ✓ 행 {rows0} → {rows1} · 고유 조합 {wh1} 불변 · 중복 0")
            if not commit:
                raise Rollback
    except Rollback:
        print("\n  ⇒ DRY-RUN — 전체 롤백했다. DB 는 그대로다.")
        print("\n[롤백 확인]")
        report("rolled-back")
        print("\n  실삭제하려면 --commit 을 붙여 다시 실행한다.")
        return

    print("\n  ⇒ COMMIT 완료.")
    print("\n[독립 재실측]")
    report("verify")
    print(f"완료 {datetime.now():%Y-%m-%d %H:%M:%S}")


if __name__ == "__main__":
    main()
