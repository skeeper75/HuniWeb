"""PET배너 거치대 옵션차원 분리 — 가격구성요소를 완제품가만 남긴다.

지니 지시(2026-08-27): 「추가상품 / 추가상품 템플릿을 만들면 그때 가격을 넣자.
가격은 인쇄상품가격표에 있는 것으로 할거야. PET배너와 메쉬배너에 있는 옵션차원을
빼고 가격구성요소를 완성하자」

거치대는 추가상품 템플릿 경로가 담당한다(실무진 합의). 따라서 가격구성요소에서는
거치대 옵션차원을 분리하고, 완제품가만 남긴 구조로 완성한다.

권위 대조(가격표 260822_1 「포스터사인」) — 완제품가는 이미 일치한다:
  r229~231  PET배너  600x1800 mm 수량 1 = 22,000  ← 라이브 COMP_POSTER_PET_BANNER  22,000
  r238~240  메쉬배너 600x1800 mm 수량 1 = 38,000  ← 라이브 COMP_POSTER_MESH_BANNER 38,000
  두 상품 모두 사이즈 1종뿐이라 미적재 셀이 없다. 「완성」 = 옵션차원 제거 그 자체.

변경 대상 (1행):
  DELETE t_prc_formula_components
    frm_cd  = PRF_POSTER_PET_BANNER
    comp_cd = COMP_POSTEROPT_PET_BANNER_STAND_SEL   (use_dims=["mat_cd"] · 단가행 2)
  메쉬배너 PRF_POSTER_MESH_BANNER 는 이미 완제품가 1개뿐 — 변경 없음.

★ 알고 있는 대가: 분리 후 PET배너 거치대는 추가상품 템플릿이 생길 때까지 무료다
  (메쉬배너의 현재 상태와 같아진다). 지니가 이 순서를 지시했다. STAND_SEL 자체와
  그 단가행 2행(10,000·23,000)은 삭제하지 않고 고아로 남긴다 — 되돌리기가 INSERT
  1행으로 끝나고, 향후 정리 라운드(P 계열)에서 함께 판정한다.

[HARD] 8 순서: 드라이런(강제 롤백) → 백업 → 승인 → COMMIT → psql 재실측 → 실화면

실행:
  드라이런  raw/webadmin/.venv/bin/python .../fix_banner_stand_optdim_split.py
  실적재    raw/webadmin/.venv/bin/python .../fix_banner_stand_optdim_split.py --commit
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

PET, MESH = "PRD_000136", "PRD_000137"
FRM_PET = "PRF_POSTER_PET_BANNER"
FRM_MESH = "PRF_POSTER_MESH_BANNER"
COMP_STAND = "COMP_POSTEROPT_PET_BANNER_STAND_SEL"

# 권위 완제품가 (가격표 260822_1 「포스터사인」 r231 · r240)
AUTHORITY_BASE = {"COMP_POSTER_PET_BANNER": 22000, "COMP_POSTER_MESH_BANNER": 38000}

BACKUP = os.path.join(ROOT, "_workspace", "huni-widget-wiring", "out", "backup",
                      "pre-banner-stand-optdim-split-260827.txt")


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


def structure(tag):
    """두 상품의 가격구성요소 구조를 나란히 찍는다 — 같아지는지가 완료 판정이다."""
    stamp = one("SELECT to_char(now() AT TIME ZONE 'Asia/Seoul','YYYY-MM-DD HH24:MI:SS')")[0]
    wgt, prd = one("""SELECT COUNT(*), COUNT(DISTINCT prd_cd) FROM t_wgt_widgets
                      WHERE sts_typ_cd='WGT_STS_TYPE.02' AND COALESCE(del_yn,'N')='N'""")
    print(f"  [{tag}] {stamp} KST · 게시 {wgt}|{prd}")
    shapes = {}
    for prd_cd, frm, label in ((PET, FRM_PET, "PET배너"), (MESH, FRM_MESH, "메쉬배너")):
        rows = q("""SELECT fc.comp_cd, pc.comp_nm, pc.use_dims,
                           (SELECT COUNT(*) FROM t_prc_component_prices cp
                             WHERE cp.comp_cd=fc.comp_cd) AS prc_rows
                      FROM t_prc_formula_components fc
                      LEFT JOIN t_prc_price_components pc ON pc.comp_cd=fc.comp_cd
                     WHERE fc.frm_cd=%s ORDER BY fc.disp_seq""", [frm])
        shapes[prd_cd] = tuple(sorted(r["use_dims"] or "" for r in rows))
        print(f"      {prd_cd} {label} — 구성요소 {len(rows)}")
        for r in rows:
            print(f"        - {r['comp_cd']:44} dims={r['use_dims']} 단가행={r['prc_rows']}")
    same = shapes[PET] == shapes[MESH]
    print(f"      ⇒ 두 상품 구조 동일: {'YES' if same else 'NO'}")
    return same


def check_authority():
    """완제품가가 권위와 일치하는지 — 분리 전에 토대를 확인한다."""
    print("\n[권위 대조 — 완제품가]")
    ok = True
    for comp_cd, expect in AUTHORITY_BASE.items():
        rows = q("""SELECT siz_cd, min_qty, unit_price FROM t_prc_component_prices
                     WHERE comp_cd=%s ORDER BY siz_cd""", [comp_cd])
        for r in rows:
            match = int(r["unit_price"]) == expect
            ok = ok and match
            print(f"  {comp_cd:28} {r['siz_cd']} qty>={r['min_qty']} "
                  f"{int(r['unit_price']):,} vs 권위 {expect:,} {'✓' if match else '⚠️ 불일치'}")
        if len(rows) != 1:
            print(f"  ⚠️ {comp_cd} 단가행 {len(rows)}행 — 권위는 사이즈 1종이다")
            ok = False
    return ok


def write_backup(rows_before):
    os.makedirs(os.path.dirname(BACKUP), exist_ok=True)
    stamp = one("SELECT to_char(now() AT TIME ZONE 'Asia/Seoul','YYYY-MM-DD HH24:MI:SS')")[0]
    with open(BACKUP, "w", encoding="utf-8") as f:
        f.write("# 적재 직전 백업 — PET배너 거치대 옵션차원 분리\n")
        f.write(f"# 생성 {stamp} KST\n\n")
        f.write("## 삭제 대상 (t_prc_formula_components)\n")
        for r in rows_before:
            f.write(f"#   frm={r['frm_cd']} comp={r['comp_cd']} disp_seq={r['disp_seq']} "
                    f"addtn_yn={r['addtn_yn']}\n")
        f.write("\n## 되돌리기 SQL\n")
        for r in rows_before:
            f.write(f"INSERT INTO t_prc_formula_components "
                    f"(frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt) VALUES "
                    f"('{r['frm_cd']}', '{r['comp_cd']}', {r['disp_seq']}, "
                    f"'{r['addtn_yn']}', now());\n")
        f.write("\n## 남겨두는 것 (삭제하지 않음)\n")
        f.write(f"#   {COMP_STAND} 구성요소 자체 + 단가행 2행(MAT_000409=10000 · "
                f"MAT_000410=23000) — 고아로 남긴다\n")
    print(f"  백업 기록: {BACKUP}")


def apply_change():
    c = connection.cursor()
    c.execute("""DELETE FROM t_prc_formula_components
                  WHERE frm_cd=%s AND comp_cd=%s""", [FRM_PET, COMP_STAND])
    print(f"  DELETE {c.rowcount}행 — {FRM_PET} ← {COMP_STAND}")
    return c.rowcount


def main():
    commit = "--commit" in sys.argv
    mode = "COMMIT(실적재)" if commit else "DRY-RUN(강제 롤백)"
    print("=" * 78)
    print(f"PET배너 거치대 옵션차원 분리 — {mode}")
    print("=" * 78)

    if not check_authority():
        raise SystemExit("중단: 완제품가가 권위와 어긋난다. 토대를 먼저 맞춰야 한다.")

    rows_before = q("""SELECT frm_cd, comp_cd, disp_seq, addtn_yn
                         FROM t_prc_formula_components
                        WHERE frm_cd=%s AND comp_cd=%s""", [FRM_PET, COMP_STAND])
    if not rows_before:
        print(f"\n  멱등 건너뜀 — {COMP_STAND} 는 이미 {FRM_PET} 에서 분리돼 있다.")
        print("\n[현재 구조]")
        structure("current")
        return

    print("\n[분리 전]")
    structure("before")

    if commit:
        write_backup(rows_before)

    try:
        with transaction.atomic():
            print("\n[적재]")
            apply_change()
            print("\n[분리 후]")
            same = structure("after")
            if not same:
                raise SystemExit("중단: 분리 후에도 두 상품 구조가 다르다. 사람이 확인해야 한다.")
            if not commit:
                raise Rollback
    except Rollback:
        print("\n  ⇒ DRY-RUN — 전체 롤백했다. DB 는 그대로다.")
        print("\n[롤백 확인]")
        structure("rolled-back")
        print("\n  실적재하려면 --commit 을 붙여 다시 실행한다.")
        return

    print("\n  ⇒ COMMIT 완료.")
    print("\n[독립 재실측]")
    structure("verify")
    print("\n  ★ PET배너 거치대는 추가상품 템플릿이 생길 때까지 무료다(지니 지시 순서).")
    print(f"완료 {datetime.now():%Y-%m-%d %H:%M:%S}")


if __name__ == "__main__":
    main()
