"""정리 P3 — 고아 가격구성요소 17종 정리 전 「대체 comp 실효 확인」 (읽기전용).

지니 지시(M1-1K §E · §G''.4 큐 1번): P3 는 대체 comp 실효 확인이 선행 필수다.
「통합 comp 가 그 기능을 실제로 수행하는가」를 확인해야 삭제 가능(M1-1K §F Gaps).

이 스크립트는 SELECT 만 한다. DB 를 바꾸지 않는다.

측정 항목
  0) 게시 분모 재실측(값 + 일시 원장 · AC-PW-016)
  1) 고아 17종 실재 재확인 — 정말 공식 미연결인가(t_prc_formula_components 부재)
  2) 대체 comp 실효 — 고아가 덮던 차원 키를 대체 comp 가 실제로 덮는가
  3) 대체 comp 의 공식 연결 + 그 공식이 게시 상품에 바인딩돼 있는가

실행: raw/webadmin/.venv/bin/python _workspace/huni-widget-wiring/bin/audit_orphan_p3.py
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

from django.db import connection  # noqa: E402

# M1-1K §C 표 + §G''.3(CEILHOOK 편입) → P3 대상 17종과 각 대체 comp
P3 = [
    # (comp_cd, 부류, 대체 comp 후보 리스트)
    ("COMP_POSTER_ADH_WATERPROOF_PVC", "[레거시]",
     ["COMP_POSTER_ARTPRINT_PHOTO", "COMP_POSTER_CANVAS_FABRIC"]),
    ("COMP_POSTER_ARTFABRIC_GRAPHIC", "[레거시]",
     ["COMP_POSTER_ARTPRINT_PHOTO", "COMP_POSTER_CANVAS_FABRIC"]),
    ("COMP_POSTER_LEATHER_ARTPRINT", "[레거시]",
     ["COMP_POSTER_ARTPRINT_PHOTO", "COMP_POSTER_CANVAS_FABRIC"]),
    ("COMP_POSTER_MESH_PRINT", "[레거시]",
     ["COMP_POSTER_ARTPRINT_PHOTO", "COMP_POSTER_CANVAS_FABRIC"]),
    ("COMP_POSTER_TYVEK_PRINT", "[레거시]",
     ["COMP_POSTER_ARTPRINT_PHOTO", "COMP_POSTER_CANVAS_FABRIC"]),
    ("COMP_POSTER_WATERPROOF_PET", "[레거시]",
     ["COMP_POSTER_ARTPRINT_PHOTO", "COMP_POSTER_CANVAS_FABRIC"]),
    ("COMP_POSTER_FOAMBOARD_BLACK", "보드류", ["COMP_POSTER_FOAMBOARD_BOARD"]),
    ("COMP_POSTER_FOAMBOARD_WHITE", "보드류", ["COMP_POSTER_FOAMBOARD_BOARD"]),
    ("COMP_POSTER_FOMEXBOARD_WHITE3MM", "보드류", ["COMP_POSTER_FOMEXBOARD_BOARD"]),
    ("COMP_POSTER_FOMEXBOARD_WHITE5MM", "보드류", ["COMP_POSTER_FOMEXBOARD_BOARD"]),
    ("COMP_POSTEROPT_PET_BANNER_STAND_IN", "PET거치대",
     ["COMP_POSTEROPT_PET_BANNER_STAND_SEL"]),
    ("COMP_POSTEROPT_PET_BANNER_STAND_OUT_S1", "PET거치대",
     ["COMP_POSTEROPT_PET_BANNER_STAND_SEL"]),
    ("COMP_POSTEROPT_PET_BANNER_STAND_OUT_S2", "PET거치대",
     ["COMP_POSTEROPT_PET_BANNER_STAND_SEL"]),
    ("COMP_POPT_BNR_GAKMOK_STR_900_4", "빈껍데기", []),
    ("COMP_POSTEROPT_BANNER_MESH_PROC_OPT", "빈껍데기", []),
    # 접두사 없는 코드다. COMP_CUT_FULL_DIECUT(살아있음·단가행 72)과 별개.
    ("CUT_FULL_DIECUT", "빈껍데기", []),
    ("COMP_POSTEROPT_JOKJA_CEILHOOK", "축이전완료(P2)", []),
]

DIM_COLS = ["siz_cd", "clr_cd", "mat_cd", "proc_cd", "opt_cd", "print_opt_cd",
            "plt_siz_cd", "coat_side_cnt", "spot_side_cnt", "bdl_qty",
            "siz_width", "siz_height", "min_qty"]


def q(sql, params=None):
    c = connection.cursor()
    c.execute(sql, params or [])
    cols = [d[0] for d in c.description]
    return [dict(zip(cols, r)) for r in c.fetchall()]


def one(sql, params=None):
    c = connection.cursor()
    c.execute(sql, params or [])
    return c.fetchone()


def resolve(prefix_cd):
    """comp_cd 를 정확 일치 → 접미 일치 순으로 해소(명칭 축약 표기 흡수)."""
    r = one("SELECT comp_cd FROM t_prc_price_components WHERE comp_cd=%s", [prefix_cd])
    if r:
        return r[0]
    rows = q("SELECT comp_cd FROM t_prc_price_components WHERE comp_cd LIKE %s",
             ["%" + prefix_cd.replace("COMP_", "")])
    return rows[0]["comp_cd"] if len(rows) == 1 else None


def dim_keys(comp_cd):
    """그 comp 의 단가행이 실제로 채운 차원 키 집합."""
    rows = q(f"SELECT {', '.join(DIM_COLS)} FROM t_prc_component_prices WHERE comp_cd=%s",
             [comp_cd])
    used = {c for c in DIM_COLS if any(r[c] not in (None, "", 0) for r in rows)}
    keys = set()
    for r in rows:
        keys.add(tuple(str(r[c]) for c in sorted(used)))
    return rows, sorted(used), keys


def main():
    stamp = one("SELECT to_char(now() AT TIME ZONE 'Asia/Seoul','YYYY-MM-DD HH24:MI:SS')")[0]

    # ── 0. 게시 분모 재실측 ────────────────────────────────────────────────
    wgt, prd = one("""SELECT COUNT(*), COUNT(DISTINCT prd_cd) FROM t_wgt_widgets
                      WHERE sts_typ_cd='WGT_STS_TYPE.02' AND COALESCE(del_yn,'N')='N'""")
    print("=" * 78)
    print(f"[0] 게시 분모 재실측  {stamp} KST")
    print(f"    게시 위젯 {wgt} · 게시 상품(DISTINCT prd_cd) {prd}")
    print(f"    verbatim: {stamp}|{wgt}|{prd}")

    # ── 1. 고아 실재 재확인 ────────────────────────────────────────────────
    print("=" * 78)
    print("[1] P3 대상 17종 — 실재 · 고아 여부 · 단가행 수")
    print(f"{'comp_cd':46} {'부류':12} {'실재':4} {'공식':4} {'단가행':>5}")
    resolved = {}
    for cd, kind, _alts in P3:
        real = resolve(cd)
        resolved[cd] = real
        if not real:
            print(f"{cd:46} {kind:12} {'없음':4} {'-':4} {'-':>5}")
            continue
        frm = one("SELECT COUNT(*) FROM t_prc_formula_components WHERE comp_cd=%s", [real])[0]
        rows = one("SELECT COUNT(*) FROM t_prc_component_prices WHERE comp_cd=%s", [real])[0]
        delyn = one("SELECT COALESCE(del_yn,'N') FROM t_prc_price_components WHERE comp_cd=%s",
                    [real])[0]
        mark = "고아" if frm == 0 else f"연결{frm}"
        print(f"{real:46} {kind:12} {'Y('+delyn+')':4} {mark:4} {rows:>5}")

    # ── 2. 대체 comp 실효 ──────────────────────────────────────────────────
    print("=" * 78)
    print("[2] 대체 comp 실효 — 고아가 덮던 차원 키를 대체가 덮는가")
    for cd, kind, alts in P3:
        real = resolved.get(cd)
        if not real:
            continue
        if not alts:
            print(f"\n▸ {real}  [{kind}] — 대체 확인 불요(빈껍데기/축이전)")
            o_rows, o_dims, o_keys = dim_keys(real)
            print(f"    단가행 {len(o_rows)} · 채운 차원 {o_dims or '없음'}")
            continue
        o_rows, o_dims, o_keys = dim_keys(real)
        print(f"\n▸ {real}  [{kind}]  단가행 {len(o_rows)} · 차원 {o_dims}")
        covered = set()
        for a in alts:
            areal = resolve(a)
            if not areal:
                print(f"    ✗ 대체 {a} — 실재하지 않음")
                continue
            a_rows, a_dims, a_keys = dim_keys(areal)
            afrm = q("""SELECT fc.frm_cd, COUNT(DISTINCT pf.prd_cd) AS prds
                        FROM t_prc_formula_components fc
                        LEFT JOIN t_prd_product_price_formulas pf ON pf.frm_cd=fc.frm_cd
                        WHERE fc.comp_cd=%s GROUP BY fc.frm_cd ORDER BY 1""", [areal])
            print(f"    · {areal}: 단가행 {len(a_rows)} · 차원 {a_dims} · "
                  f"공식 {len(afrm)}({', '.join(f['frm_cd'] for f in afrm)})")
            # 같은 차원축이면 키 대조, 아니면 자재 축만 대조
            if set(o_dims) & set(a_dims):
                common = sorted(set(o_dims) & set(a_dims))
                ok = {tuple(str(r[c]) for c in common) for r in o_rows}
                ak = {tuple(str(r[c]) for c in common) for r in a_rows}
                covered |= (ok & ak)
                print(f"      공통축 {common}: 고아 {len(ok)} 키 중 대체가 덮는 것 {len(ok & ak)}")
        if o_dims:
            print(f"    ⇒ 고아 차원키 {len(o_keys)} · 대체 커버 {len(covered)}")

    print("=" * 78)
    print(f"완료 {datetime.now():%Y-%m-%d %H:%M:%S}")


if __name__ == "__main__":
    main()
