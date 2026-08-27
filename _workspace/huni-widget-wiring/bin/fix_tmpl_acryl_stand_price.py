"""TMPL-000092 아크릴거치대 추가상품 템플릿 직접단가 적재.

지니 지시(2026-08-27): 「아크릴 거치대 1400원으로 넣어줘」

배경 — §G'''.6 실무진 확인 4번 항목의 해소.
  PRD_000226 아크릴쉐이커코롯토(★게시중)에 TMPL-000092 아크릴거치대가 추가상품으로
  연결돼 있으나 t_prd_template_prices 에 단가행이 없어 계산 시 0원(무료)으로 나간다.
  권위 가격표 260822_1 · 상품마스터 260822_1 어디에도 이 단가가 없어 [HARD] 7(추정 금지)에
  걸려 있었고, 지니가 1,400 을 직접 확정했다. 값의 권위 = 지니 구두 확정(원장 기재).

[HARD] 8 순서: 드라이런(강제 롤백) → 백업 → 승인 → COMMIT → psql 재실측 → 실화면

멱등성: PK = (tmpl_cd, apply_ymd). 이미 있으면 값이 같을 때 건너뛰고, 다를 때는
        중단한다(덮어쓰지 않는다 — 남이 넣은 값을 조용히 지우지 않기 위해).

실행:
  드라이런  raw/webadmin/.venv/bin/python .../fix_tmpl_acryl_stand_price.py
  실적재    raw/webadmin/.venv/bin/python .../fix_tmpl_acryl_stand_price.py --commit
"""
import os
import sys
from datetime import datetime
from decimal import Decimal

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", ".."))
sys.path.insert(0, os.path.join(ROOT, "raw", "webadmin", "webadmin"))
os.environ.setdefault("DJANGO_SETTINGS_MODULE", "config.settings")

from dotenv import load_dotenv  # noqa: E402
load_dotenv(os.path.join(ROOT, "raw", "webadmin", ".env"))

import django  # noqa: E402
django.setup()

from django.db import connection, transaction  # noqa: E402

TMPL = "TMPL-000092"
APPLY_YMD = "2026-08-27"
UNIT_PRICE = Decimal("1400.00")
NOTE = "아크릴거치대 직접단가 — 지니 확정 260827(권위 가격표·상품마스터 미기재분)"

BACKUP = os.path.join(ROOT, "_workspace", "huni-widget-wiring", "out", "backup",
                      "pre-tmpl-acryl-stand-260827.txt")


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


def snapshot(tag):
    stamp = one("SELECT to_char(now() AT TIME ZONE 'Asia/Seoul','YYYY-MM-DD HH24:MI:SS')")[0]
    wgt, prd = one("""SELECT COUNT(*), COUNT(DISTINCT prd_cd) FROM t_wgt_widgets
                      WHERE sts_typ_cd='WGT_STS_TYPE.02' AND COALESCE(del_yn,'N')='N'""")
    rows = q("""SELECT tmpl_cd, apply_ymd, unit_price, note
                  FROM t_prd_template_prices WHERE tmpl_cd=%s ORDER BY apply_ymd""", [TMPL])
    free = one("""SELECT COUNT(*) FROM t_prd_product_addons a
                    JOIN t_prd_templates t ON t.tmpl_cd=a.tmpl_cd
                                          AND COALESCE(t.del_yn,'N')='N'
                   WHERE NOT EXISTS (SELECT 1 FROM t_prd_template_prices tp
                                      WHERE tp.tmpl_cd=a.tmpl_cd)""")[0]
    print(f"  [{tag}] {stamp} KST · 게시 {wgt}|{prd} · {TMPL} 단가행 {len(rows)} · "
          f"무료유출 후보 {free}")
    for r in rows:
        print(f"        {r['apply_ymd']} {r['unit_price']} — {r['note']}")
    return stamp, wgt, prd, rows, free


def write_backup(stamp, rows_before):
    os.makedirs(os.path.dirname(BACKUP), exist_ok=True)
    with open(BACKUP, "w", encoding="utf-8") as f:
        f.write(f"# 적재 직전 백업 — {TMPL} 아크릴거치대 직접단가\n")
        f.write(f"# 생성 {stamp} KST · 지니 확정값 {UNIT_PRICE}\n\n")
        f.write("## 적재 직전 상태 (t_prd_template_prices)\n")
        if rows_before:
            for r in rows_before:
                f.write(f"#   {r['apply_ymd']} | {r['unit_price']} | {r['note']}\n")
        else:
            f.write("#   (행 없음)\n")
        f.write("\n## 되돌리기 SQL\n")
        f.write(f"DELETE FROM t_prd_template_prices "
                f"WHERE tmpl_cd='{TMPL}' AND apply_ymd='{APPLY_YMD}';\n")
    print(f"  백업 기록: {BACKUP}")


def apply_change():
    """UPSERT 아님 — 있으면 검사만, 없으면 INSERT. 남의 값을 덮어쓰지 않는다."""
    cur = one("""SELECT unit_price FROM t_prd_template_prices
                  WHERE tmpl_cd=%s AND apply_ymd=%s""", [TMPL, APPLY_YMD])
    if cur:
        if Decimal(cur[0]) == UNIT_PRICE:
            print(f"  멱등 건너뜀 — 이미 {UNIT_PRICE} 로 존재")
            return 0
        raise SystemExit(f"중단: 같은 키에 다른 값 {cur[0]} 이 있다. 사람이 확인해야 한다.")
    c = connection.cursor()
    c.execute("""INSERT INTO t_prd_template_prices (tmpl_cd, apply_ymd, unit_price, note, reg_dt)
                 VALUES (%s, %s, %s, %s, now())""",
              [TMPL, APPLY_YMD, UNIT_PRICE, NOTE])
    print(f"  INSERT 1행 — {TMPL} {APPLY_YMD} {UNIT_PRICE}")
    return 1


def main():
    commit = "--commit" in sys.argv
    mode = "COMMIT(실적재)" if commit else "DRY-RUN(강제 롤백)"
    print("=" * 78)
    print(f"{TMPL} 아크릴거치대 직접단가 {UNIT_PRICE} — {mode}")
    print("=" * 78)

    # 선행 확인 — 템플릿 실재 + 연결 상품 게시 여부
    t = q("""SELECT t.tmpl_cd, t.tmpl_nm, t.base_prd_cd, COALESCE(t.del_yn,'N') AS del_yn
               FROM t_prd_templates t WHERE t.tmpl_cd=%s""", [TMPL])
    if not t or t[0]["del_yn"] != "N":
        raise SystemExit(f"중단: {TMPL} 이 없거나 논리삭제 상태다.")
    print(f"  대상: {t[0]['tmpl_nm']} (base={t[0]['base_prd_cd']})")
    for h in q("""SELECT a.prd_cd, p.prd_nm,
                         (SELECT COUNT(*) FROM t_wgt_widgets w
                           WHERE w.prd_cd=a.prd_cd AND w.sts_typ_cd='WGT_STS_TYPE.02'
                             AND COALESCE(w.del_yn,'N')='N') AS pub
                    FROM t_prd_product_addons a
                    LEFT JOIN t_prd_products p ON p.prd_cd=a.prd_cd
                   WHERE a.tmpl_cd=%s""", [TMPL]):
        print(f"  연결 상품: {h['prd_cd']} {h['prd_nm']}"
              f"{' ★게시중 — 고객 가격이 즉시 바뀐다' if h['pub'] else ''}")

    print("\n[적재 전]")
    stamp, _, _, rows_before, _ = snapshot("before")

    if commit:
        write_backup(stamp, rows_before)

    try:
        with transaction.atomic():
            print("\n[적재]")
            apply_change()
            print("\n[적재 후]")
            snapshot("after")
            if not commit:
                raise Rollback
    except Rollback:
        print("\n  ⇒ DRY-RUN — 전체 롤백했다. DB 는 그대로다.")
        print("\n[롤백 확인]")
        snapshot("rolled-back")
        print("\n  실적재하려면 --commit 을 붙여 다시 실행한다.")
        return

    print("\n  ⇒ COMMIT 완료.")
    print("\n[독립 재실측]")
    snapshot("verify")
    print(f"\n완료 {datetime.now():%Y-%m-%d %H:%M:%S}")


if __name__ == "__main__":
    main()
