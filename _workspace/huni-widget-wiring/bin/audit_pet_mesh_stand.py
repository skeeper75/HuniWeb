"""결함 P-1·P-2·P-3 — PET/메쉬 배너 거치대 교정 전 라이브 실측 (읽기전용).

지니 지시(§G'''.4 큐 1번): 결함 P-1·P-2·P-3 교정.
이 스크립트는 SELECT 만 한다. DB 를 바꾸지 않는다.

권위(2026-08-27 재확인 · 셀 단위):
  가격표 260822_1 「포스터사인」 J229 = '배너 추가옵션(거치대) 추가가격'
                                  L229 = 'PET배너+메쉬배너 공용'
    J231 거치대없음              K231 =      0
    J232 실내용배너거치대        K232 =  7,000
    J233 실외용배너거치대(단면용) K233 = 23,000
    J234 실외용배너거치대(양면용) K234 = 25,000
  ★전 시트 '거치대' 전수 검색 결과 이 블록이 유일하다(메쉬배너 A238 구역에 별도 블록 없음).

측정 항목
  0) 게시 분모 재실측(값 + 일시 원장 · [HARD] 1)
  1) P-1 — 실내용 거치대 단가행 현행값 vs 권위 7,000
  2) P-2 — '양면용' 자재 코드 실재 여부(거치대 자재 전수)
  3) P-3 — 메쉬배너 PRD_000137 의 공식·구성요소·등록 자재
  4) 참조군 — PET배너 PRD_000136 의 정상 배선 구조(교정 시 모방 대상)

실행: raw/webadmin/.venv/bin/python _workspace/huni-widget-wiring/bin/audit_pet_mesh_stand.py
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

PET = "PRD_000136"      # PET배너 — 참조군(거치대 배선 있음)
MESH = "PRD_000137"     # 메쉬배너 — 결함 P-3(거치대 구성요소 없음)
STAND_SEL = "COMP_POSTEROPT_PET_BANNER_STAND_SEL"

AUTHORITY = {"실내용": 7000, "실외용_단면": 23000, "실외용_양면": 25000}


def q(sql, params=None):
    c = connection.cursor()
    c.execute(sql, params or [])
    cols = [d[0] for d in c.description]
    return [dict(zip(cols, r)) for r in c.fetchall()]


def one(sql, params=None):
    c = connection.cursor()
    c.execute(sql, params or [])
    return c.fetchone()


def cols_of(table):
    return [r["column_name"] for r in q(
        """SELECT column_name FROM information_schema.columns
           WHERE table_schema='public' AND table_name=%s ORDER BY ordinal_position""",
        [table])]


def hr(title):
    print("=" * 78)
    print(title)


def main():
    stamp = one("SELECT to_char(now() AT TIME ZONE 'Asia/Seoul','YYYY-MM-DD HH24:MI:SS')")[0]

    # ── 0. 게시 분모 재실측 ────────────────────────────────────────────────
    wgt, prd = one("""SELECT COUNT(*), COUNT(DISTINCT prd_cd) FROM t_wgt_widgets
                      WHERE sts_typ_cd='WGT_STS_TYPE.02' AND COALESCE(del_yn,'N')='N'""")
    hr(f"[0] 게시 분모 재실측  {stamp} KST")
    print(f"    게시 위젯 {wgt} · 게시 상품(DISTINCT prd_cd) {prd}")
    print(f"    verbatim: {stamp}|{wgt}|{prd}")

    # ── 0'. 대상 두 상품의 게시 여부 ──────────────────────────────────────
    hr("[0'] 대상 상품 게시 여부")
    for cd in (PET, MESH):
        r = q("""SELECT p.prd_cd, p.prd_nm, COALESCE(p.use_yn,'?') AS use_yn,
                        COALESCE(p.del_yn,'N') AS del_yn,
                        (SELECT COUNT(*) FROM t_wgt_widgets w
                          WHERE w.prd_cd=p.prd_cd AND w.sts_typ_cd='WGT_STS_TYPE.02'
                            AND COALESCE(w.del_yn,'N')='N') AS pub_wgt
                   FROM t_prd_products p WHERE p.prd_cd=%s""", [cd])
        for x in r:
            print(f"    {x['prd_cd']} {x['prd_nm']:24} use={x['use_yn']} del={x['del_yn']} "
                  f"게시위젯={x['pub_wgt']}")

    # ── 1. P-1 — 거치대 단가행 현행값 ─────────────────────────────────────
    cp_cols = cols_of("t_prc_component_prices")
    price_col = next((c for c in ("unit_prc", "prc", "price", "amt", "unit_price")
                      if c in cp_cols), None)
    hr(f"[1] P-1 — {STAND_SEL} 단가행 전수  (가격컬럼={price_col})")
    print(f"    t_prc_component_prices 컬럼: {cp_cols}")
    rows = q("""SELECT cp.*, m.mat_nm
                   FROM t_prc_component_prices cp
                   LEFT JOIN t_mat_materials m ON m.mat_cd = cp.mat_cd
                  WHERE cp.comp_cd=%s ORDER BY cp.mat_cd""", [STAND_SEL])
    if not rows:
        print("    ⚠️ 단가행 0")
    for r in rows:
        dims = {k: v for k, v in r.items()
                if k.endswith(("_cd", "_cnt", "_qty", "width", "height"))
                and v not in (None, "", 0) and k != "comp_cd"}
        val = r.get(price_col)
        print(f"    mat={r.get('mat_cd')} ({r.get('mat_nm')})  {price_col}={val}")
        print(f"        차원: {dims}")
    print(f"    ▸ 권위 대조: 실내용 {AUTHORITY['실내용']:,} · "
          f"실외용(단면) {AUTHORITY['실외용_단면']:,} · 실외용(양면) {AUTHORITY['실외용_양면']:,}")

    # ── 2. P-2 — 거치대 자재 전수 ─────────────────────────────────────────
    hr("[2] P-2 — 거치대 자재 전수 (t_mat_materials)")
    mats = q("""SELECT mat_cd, mat_nm, mat_typ_cd, upr_mat_cd, COALESCE(use_yn,'?') AS use_yn,
                       COALESCE(del_yn,'N') AS del_yn, note, usr_def_nm
                  FROM t_mat_materials
                 WHERE mat_nm LIKE '%%거치대%%' OR COALESCE(usr_def_nm,'') LIKE '%%거치대%%'
                 ORDER BY mat_cd""")
    print(f"    건수 {len(mats)}")
    for m in mats:
        print(f"    {m['mat_cd']} | {m['mat_nm']:28} | typ={m['mat_typ_cd']} | "
              f"upr={m['upr_mat_cd']} | use={m['use_yn']} del={m['del_yn']}")
    has_double = [m for m in mats if "양면" in (m["mat_nm"] or "")]
    print(f"    ▸ '양면' 포함 자재: {len(has_double)}건 "
          f"{'⇒ P-2 확증(그릇 없음)' if not has_double else ''}")

    # 부모 그룹 형제 — 신규 등록 시 채번/속성 참조용
    parents = {m["upr_mat_cd"] for m in mats if m["upr_mat_cd"]}
    for p in sorted(parents):
        sib = q("""SELECT mat_cd, mat_nm, COALESCE(use_yn,'?') AS use_yn,
                          COALESCE(del_yn,'N') AS del_yn
                     FROM t_mat_materials WHERE upr_mat_cd=%s ORDER BY mat_cd""", [p])
        pnm = one("SELECT mat_nm FROM t_mat_materials WHERE mat_cd=%s", [p])
        print(f"    · 부모 {p} ({pnm[0] if pnm else '?'}) 형제 {len(sib)}: "
              f"{', '.join(s['mat_cd'] + '/' + (s['mat_nm'] or '') for s in sib)}")

    # ── 3·4. 두 상품의 배선 대조 ──────────────────────────────────────────
    for cd, label in ((PET, "참조군 PET배너"), (MESH, "결함 P-3 메쉬배너")):
        hr(f"[3] {label} {cd} — 배선 실측")
        frms = q("""SELECT pf.frm_cd, f.frm_nm
                      FROM t_prd_product_price_formulas pf
                      LEFT JOIN t_prc_price_formulas f ON f.frm_cd=pf.frm_cd
                     WHERE pf.prd_cd=%s ORDER BY pf.frm_cd""", [cd])
        print(f"    공식 바인딩 {len(frms)}: "
              f"{', '.join((f['frm_cd'] or '') + '(' + (f['frm_nm'] or '') + ')' for f in frms)}")
        for f in frms:
            comps = q("""SELECT fc.comp_cd, pc.comp_nm, COALESCE(pc.del_yn,'N') AS del_yn,
                                (SELECT COUNT(*) FROM t_prc_component_prices cp
                                  WHERE cp.comp_cd=fc.comp_cd) AS prc_rows
                           FROM t_prc_formula_components fc
                           LEFT JOIN t_prc_price_components pc ON pc.comp_cd=fc.comp_cd
                          WHERE fc.frm_cd=%s ORDER BY fc.comp_cd""", [f["frm_cd"]])
            print(f"    ▸ {f['frm_cd']} 구성요소 {len(comps)}")
            for c in comps:
                print(f"        - {c['comp_cd']:44} {c['comp_nm']} "
                      f"(단가행 {c['prc_rows']} · del={c['del_yn']})")

        pm = q("""SELECT pm.mat_cd, m.mat_nm, m.upr_mat_cd, pm.usage_cd, pm.dflt_yn,
                         pm.cust_sel_yn, COALESCE(pm.del_yn,'N') AS del_yn,
                         COALESCE(m.use_yn,'?') AS mat_use_yn
                    FROM t_prd_product_materials pm
                    LEFT JOIN t_mat_materials m ON m.mat_cd=pm.mat_cd
                   WHERE pm.prd_cd=%s ORDER BY pm.disp_seq, pm.mat_cd""", [cd])
        print(f"    등록 자재 {len(pm)}:")
        for m in pm:
            mark = " ★거치대" if "거치대" in (m["mat_nm"] or "") else ""
            print(f"        - {m['mat_cd']} {m['mat_nm']} (usage={m['usage_cd']} "
                  f"dflt={m['dflt_yn']} custsel={m['cust_sel_yn']} "
                  f"del={m['del_yn']} matuse={m['mat_use_yn']}){mark}")

    hr(f"완료 {datetime.now():%Y-%m-%d %H:%M:%S}")


if __name__ == "__main__":
    main()
