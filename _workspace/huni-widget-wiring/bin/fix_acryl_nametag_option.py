"""아크릴명찰 가공 옵션그룹 가격배선 — 통합형 가격구성요소 3종 신설 + 공식 배선.

지니 지시(2026-08-27): 「가격구성요소와 가격공식을 기존 것을 확인해서 가격배선이 되도록
개선 및 추가/수정 해달라」 · 「옵션그룹에 있는 것은 코드이기 때문에 여러개 만들지 않고
테이블이기 때문에 하나로 관리해도 되지 않나」.

설계 원칙 — 옵션그룹 1개 = 가격구성요소 1개 = 단가행 N개
  구세대는 옵션 1개마다 구성요소 1개를 만들어 단가행이 1행뿐이었다. `use_dims` 에
  `opt_grp:` 를 선언해놓고 그룹 차원의 이점을 쓰지 못하는 구조다. 옵션이 늘 때마다
  구성요소·단가행·공식연결 3곳을 손대야 하고, 실제로 이번에 일반현수막 부자재 4종이
  공식에서 통째로 끊겼다(연결 지점이 4개라서).
  통합형은 단가행 1행 추가로 끝난다.

정본 모방 대상: `COMP_BANNER_OPTION`(실무진 2026-08-27 22:15 신설, 일반현수막 가공옵션)
  comp_typ_cd=PRC_COMPONENT_TYPE.04 · prc_typ_cd=PRICE_TYPE.01
  use_dims=["opt_cd","min_qty","opt_grp:<그룹>"] · 단가행 = (apply_ymd, min_qty=1, opt_cd, unit_price)

권위: 가격표 260822_1 「포스터사인」
  r246~251 일반 가공  : 열재단3,000 타공4개3,000 타공6개4,000 타공8개5,000 양면테잎3,000 봉미싱4,000
  r246~250 일반 부자재: 추가없음0 큐방3,000 끈4,000 각목900이하4,000 각목900초과8,000
  r267~270 메쉬 가공  : 재단만0 타공4개3,000 타공6개4,000 타공8개5,000
  r267~269 메쉬 부자재: 추가없음0 큐방3,000 끈4,000

구세대 구성요소는 **논리삭제하지 않고 공식 미연결로만 둔다** — 되돌리기가 INSERT 몇 줄로
끝나고, 정리 판정은 P 계열 라운드에서 함께 한다(M1-1O §I' 의 STAND_SEL 과 같은 처리).

[HARD] 8 순서: 드라이런(강제 롤백) → 백업 → 승인 → COMMIT → psql 재실측 → 실화면

실행:
  드라이런  raw/webadmin/.venv/bin/python .../fix_banner_option_groups.py
  실적재    raw/webadmin/.venv/bin/python .../fix_banner_option_groups.py --commit
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

APPLY_YMD = "2026-08-27"

# (comp_cd, comp_nm, comp_typ_cd, opt_grp, frm_cd, prd_cd,
#  [(opt_cd, opt_nm, 단가, 권위셀)], [공식에서 분리할 구세대 comp_cd])
SPECS = [
    ("COMP_ACRYL_NAMETAG_GS_OPTION", "아크릴명찰(골드실버) 가공옵션", "PRC_COMPONENT_TYPE.04",
     "OPT_000299", "PRF_ACRYL_NAMETAG_GS", "PRD_000153",
     [("OPV_001027", "일자핀", 700, "C69"),
      ("OPV_001028", "2구자석", 1700, "C70")],
     []),
]

BACKUP = os.path.join(ROOT, "_workspace", "huni-widget-wiring", "out", "backup",
                      "pre-acryl-nametag-option-260827.txt")


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


def wiring(prd_cd):
    """그 상품의 살아있는 옵션값이 값으로 바뀌는가 — 배선율."""
    keys = set()
    for r in q("""SELECT cp.mat_cd, cp.proc_cd, cp.opt_cd
                    FROM t_prd_product_price_formulas pf
                    JOIN t_prc_formula_components fc ON fc.frm_cd=pf.frm_cd
                    JOIN t_prc_price_components pc ON pc.comp_cd=fc.comp_cd
                                                  AND COALESCE(pc.del_yn,'N')='N'
                    JOIN t_prc_component_prices cp ON cp.comp_cd=fc.comp_cd
                   WHERE pf.prd_cd=%s""", [prd_cd]):
        keys |= {v for v in r.values() if v}
    out = []
    for o in q("""SELECT o.opt_cd, o.opt_nm, g.opt_grp_nm,
                         ARRAY_REMOVE(ARRAY_AGG(i.ref_key1), NULL) AS refs
                    FROM t_prd_product_options o
                    JOIN t_prd_product_option_groups g
                         ON g.prd_cd=o.prd_cd AND g.opt_grp_cd=o.opt_grp_cd
                        AND COALESCE(g.del_yn,'N')='N'
                    LEFT JOIN t_prd_product_option_items i
                         ON i.prd_cd=o.prd_cd AND i.opt_cd=o.opt_cd
                        AND COALESCE(i.del_yn,'N')='N'
                   WHERE o.prd_cd=%s AND COALESCE(o.del_yn,'N')='N'
                   GROUP BY o.opt_cd, o.opt_nm, g.opt_grp_nm, g.disp_seq, o.disp_seq
                   ORDER BY g.disp_seq, o.disp_seq""", [prd_cd]):
        wired = o["opt_cd"] in keys or any(r in keys for r in (o["refs"] or []))
        out.append((wired, o))
    return out


def report(tag):
    stamp = one("SELECT to_char(now() AT TIME ZONE 'Asia/Seoul','YYYY-MM-DD HH24:MI:SS')")[0]
    wgt, prd = one("""SELECT COUNT(*), COUNT(DISTINCT prd_cd) FROM t_wgt_widgets
                      WHERE sts_typ_cd='WGT_STS_TYPE.02' AND COALESCE(del_yn,'N')='N'""")
    print(f"  [{tag}] {stamp} KST · 게시 {wgt}|{prd}")
    allok = True
    for prd_cd, nm in (("PRD_000153", "아크릴명찰(골드실버)"),):
        rows = wiring(prd_cd)
        ok = sum(1 for w, _ in rows if w)
        allok = allok and ok == len(rows)
        print(f"      {prd_cd} {nm} — 배선 {ok}/{len(rows)}")
        for w, o in rows:
            print(f"        {'✅' if w else '❌'} [{o['opt_grp_nm']}] {o['opt_cd']} {o['opt_nm']}")
    return allok


def write_backup():
    os.makedirs(os.path.dirname(BACKUP), exist_ok=True)
    stamp = one("SELECT to_char(now() AT TIME ZONE 'Asia/Seoul','YYYY-MM-DD HH24:MI:SS')")[0]
    with open(BACKUP, "w", encoding="utf-8") as f:
        f.write("# 적재 직전 백업 — 현수막 옵션그룹 통합 가격구성요소 3종\n")
        f.write(f"# 생성 {stamp} KST\n\n## 되돌리기 SQL (역순 실행)\n")
        for comp_cd, _nm, _typ, _grp, frm_cd, _prd, prices, olds in SPECS:
            f.write(f"\n# --- {comp_cd} ---\n")
            f.write(f"DELETE FROM t_prc_formula_components "
                    f"WHERE frm_cd='{frm_cd}' AND comp_cd='{comp_cd}';\n")
            f.write(f"DELETE FROM t_prc_component_prices WHERE comp_cd='{comp_cd}';\n")
            f.write(f"DELETE FROM t_prc_price_components WHERE comp_cd='{comp_cd}';\n")
            for old in olds:
                cur = q("""SELECT frm_cd, comp_cd, disp_seq, addtn_yn
                             FROM t_prc_formula_components
                            WHERE frm_cd=%s AND comp_cd=%s""", [frm_cd, old])
                for r in cur:
                    ds = r["disp_seq"] if r["disp_seq"] is not None else "NULL"
                    ay = f"'{r['addtn_yn']}'" if r["addtn_yn"] else "NULL"
                    f.write(f"INSERT INTO t_prc_formula_components "
                            f"(frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt) VALUES "
                            f"('{r['frm_cd']}', '{r['comp_cd']}', {ds}, {ay}, now());\n")
                if not cur:
                    f.write(f"# (구세대 {old} 는 이미 {frm_cd} 에 미연결 — 되돌릴 것 없음)\n")
    print(f"  백업 기록: {BACKUP}")


def apply_all():
    c = connection.cursor()
    n_comp = n_price = n_link = n_unlink = 0
    for comp_cd, comp_nm, typ, grp, frm_cd, prd_cd, prices, olds in SPECS:
        # 선행 확인 — 옵션이 실재하고 그 그룹 소속인가
        for opt_cd, opt_nm, _v, _cell in prices:
            hit = one("""SELECT opt_nm FROM t_prd_product_options
                          WHERE prd_cd=%s AND opt_cd=%s AND opt_grp_cd=%s
                            AND COALESCE(del_yn,'N')='N'""", [prd_cd, opt_cd, grp])
            if not hit:
                raise SystemExit(f"중단: {prd_cd} {grp} 에 {opt_cd} 가 없다.")
            if hit[0] != opt_nm:
                raise SystemExit(f"중단: {opt_cd} 이름 불일치 — 라이브 '{hit[0]}' vs 명세 '{opt_nm}'")

        if not one("SELECT 1 FROM t_prc_price_components WHERE comp_cd=%s", [comp_cd]):
            c.execute("""INSERT INTO t_prc_price_components
                         (comp_cd, comp_nm, comp_typ_cd, prc_typ_cd, use_dims,
                          use_yn, del_yn, reg_dt)
                         VALUES (%s, %s, %s, 'PRICE_TYPE.01', %s, 'Y', 'N', now())""",
                      [comp_cd, comp_nm, typ,
                       f'["opt_cd", "min_qty", "opt_grp:{grp}"]'])
            n_comp += 1
            print(f"    + 구성요소 {comp_cd} ({comp_nm}) typ={typ} grp={grp}")
        else:
            print(f"    = 구성요소 {comp_cd} 이미 존재 — 건너뜀")

        for opt_cd, opt_nm, val, cell in prices:
            cur = one("""SELECT unit_price FROM t_prc_component_prices
                          WHERE comp_cd=%s AND opt_cd=%s AND apply_ymd=%s""",
                      [comp_cd, opt_cd, APPLY_YMD])
            if cur:
                if Decimal(cur[0]) != Decimal(val):
                    raise SystemExit(f"중단: {comp_cd}/{opt_cd} 에 다른 값 {cur[0]} 존재")
                continue
            c.execute("""INSERT INTO t_prc_component_prices
                         (comp_cd, apply_ymd, opt_cd, min_qty, unit_price, note, reg_dt)
                         VALUES (%s, %s, %s, 1, %s, %s, now())""",
                      [comp_cd, APPLY_YMD, opt_cd, Decimal(val),
                       f"{comp_nm} {opt_nm} · 권위 가격표260822_1[포스터사인] {cell}"])
            n_price += 1
            print(f"      + 단가행 {opt_cd} {opt_nm} = {val:,} (권위 {cell})")

        if not one("""SELECT 1 FROM t_prc_formula_components
                       WHERE frm_cd=%s AND comp_cd=%s""", [frm_cd, comp_cd]):
            c.execute("""INSERT INTO t_prc_formula_components
                         (frm_cd, comp_cd, reg_dt) VALUES (%s, %s, now())""",
                      [frm_cd, comp_cd])
            n_link += 1
            print(f"    + 공식연결 {frm_cd} ← {comp_cd}")

        for old in olds:
            c.execute("""DELETE FROM t_prc_formula_components
                          WHERE frm_cd=%s AND comp_cd=%s""", [frm_cd, old])
            if c.rowcount:
                n_unlink += c.rowcount
                print(f"    - 구세대 분리 {frm_cd} ← {old}")
    print(f"\n  합계: 구성요소 +{n_comp} · 단가행 +{n_price} · 공식연결 +{n_link} · 구세대분리 -{n_unlink}")
    return n_comp + n_price + n_link + n_unlink


def main():
    commit = "--commit" in sys.argv
    print("=" * 78)
    print(f"아크릴명찰 가공 옵션그룹 가격배선 — {'COMMIT(실적재)' if commit else 'DRY-RUN(강제 롤백)'}")
    print("=" * 78)
    print("\n[배선 전]")
    report("before")

    if commit:
        write_backup()

    try:
        with transaction.atomic():
            print("\n[적재]")
            if apply_all() == 0:
                print("  변경 없음 — 멱등 건너뜀")
            print("\n[배선 후]")
            allok = report("after")
            if not allok:
                raise SystemExit("중단: 배선되지 않은 옵션이 남았다. 사람이 확인해야 한다.")
            if not commit:
                raise Rollback
    except Rollback:
        print("\n  ⇒ DRY-RUN — 전체 롤백했다. DB 는 그대로다.")
        print("\n[롤백 확인]")
        report("rolled-back")
        print("\n  실적재하려면 --commit 을 붙여 다시 실행한다.")
        return

    print("\n  ⇒ COMMIT 완료.")
    print("\n[독립 재실측]")
    report("verify")
    print(f"완료 {datetime.now():%Y-%m-%d %H:%M:%S}")


if __name__ == "__main__":
    main()
