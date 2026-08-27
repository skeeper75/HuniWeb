"""추가상품 템플릿 축 전수 감사 — PET/메쉬 배너 거치대 + 다른 상품들 (읽기전용).

지니 지시(2026-08-27): 「PET배너와 메쉬배너는 추가상품으로 등록하고 추가상품템플릿으로 해서
가격뷰어에서 처리하는 것으로 실무진과 이야기했다. 되고 하자 다른 상품들.. 확인해줘」

⇒ 거치대는 가격구성요소(t_prc_*) 경로가 아니라 추가상품 템플릿(t_prd_*) 경로로 처리한다.
이 스크립트는 SELECT 만 한다. DB 를 바꾸지 않는다.

지니 확정 값(가격표 260822_1 「포스터사인」 K232·K233 우선):
    실내용배너거치대 =  7,000
    실외용배너거치대 = 23,000
  (양면용 25,000 은 이번 범위 밖 — 구성요소는 이미 포함된 것으로 보고 가격만 점검)

축 구조
    t_prd_product_addons   (prd_cd ─ tmpl_cd)   그 상품이 끼워파는 추가상품
    t_prd_templates        (tmpl_cd, base_prd_cd)  추가상품 정의
    t_prd_template_selections (tmpl_cd ─ ref_dim_cd/ref_key1)  무엇으로 구성되는가
    t_prd_template_prices  (tmpl_cd, unit_price)   ★직접단가 — 계산 시 최우선(§M1-1H)

측정 항목
  0) 게시 분모 재실측(값 + 일시 원장 · [HARD] 1)
  1) PET배너/메쉬배너의 추가상품 연결 현황
  2) 거치대 관련 템플릿 전수 — 구성·단가·연결 상품
  3) ★전 상품 추가상품 축 건강도 — 「연결됐는데 단가 없음」(무료 유출) 전수
  4) ★고아 템플릿 — 단가는 있는데 어느 상품에도 안 걸린 것

실행: raw/webadmin/.venv/bin/python _workspace/huni-widget-wiring/bin/audit_addon_template_axis.py
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

PET = "PRD_000136"
MESH = "PRD_000137"
AUTHORITY = {"실내용": 7000, "실외용": 23000}


def q(sql, params=None):
    c = connection.cursor()
    c.execute(sql, params or [])
    cols = [d[0] for d in c.description]
    return [dict(zip(cols, r)) for r in c.fetchall()]


def one(sql, params=None):
    c = connection.cursor()
    c.execute(sql, params or [])
    return c.fetchone()


def hr(title):
    print("=" * 78)
    print(title)


def tmpl_detail(tmpl_cd, indent="        "):
    """템플릿 하나의 구성(selections) + 직접단가 + 연결 상품."""
    sels = q("""SELECT ts.sel_seq, ts.ref_dim_cd, ts.ref_key1, ts.ref_key2, ts.opt_cd,
                       ts.sel_val, ts.qty, COALESCE(ts.del_yn,'N') AS del_yn,
                       m.mat_nm
                  FROM t_prd_template_selections ts
                  LEFT JOIN t_mat_materials m ON m.mat_cd = ts.ref_key1
                 WHERE ts.tmpl_cd=%s ORDER BY ts.sel_seq""", [tmpl_cd])
    live = [s for s in sels if s["del_yn"] == "N"]
    print(f"{indent}구성(selections) 살아있음 {len(live)}/{len(sels)}:")
    for s in live:
        nm = f" ({s['mat_nm']})" if s["mat_nm"] else ""
        print(f"{indent}  seq{s['sel_seq']} dim={s['ref_dim_cd']} key1={s['ref_key1']}{nm} "
              f"key2={s['ref_key2']} opt={s['opt_cd']} qty={s['qty']}")

    prices = q("""SELECT apply_ymd, unit_price, note FROM t_prd_template_prices
                   WHERE tmpl_cd=%s ORDER BY apply_ymd DESC""", [tmpl_cd])
    if prices:
        for p in prices:
            print(f"{indent}★직접단가 {p['unit_price']} (적용 {p['apply_ymd']}) {p['note'] or ''}")
    else:
        print(f"{indent}⚠️ 직접단가 없음 — 계산 시 0원(무료)")

    hosts = q("""SELECT a.prd_cd, p.prd_nm, a.disp_seq, a.note,
                        (SELECT COUNT(*) FROM t_wgt_widgets w
                          WHERE w.prd_cd=a.prd_cd AND w.sts_typ_cd='WGT_STS_TYPE.02'
                            AND COALESCE(w.del_yn,'N')='N') AS pub
                   FROM t_prd_product_addons a
                   LEFT JOIN t_prd_products p ON p.prd_cd=a.prd_cd
                  WHERE a.tmpl_cd=%s ORDER BY a.prd_cd""", [tmpl_cd])
    if hosts:
        for h in hosts:
            mark = " ★게시중" if h["pub"] else ""
            print(f"{indent}연결 상품: {h['prd_cd']} {h['prd_nm']}{mark}")
    else:
        print(f"{indent}⚠️ 연결 상품 없음 — 고아 템플릿")
    return prices, hosts


def main():
    stamp = one("SELECT to_char(now() AT TIME ZONE 'Asia/Seoul','YYYY-MM-DD HH24:MI:SS')")[0]

    # ── 0. 게시 분모 재실측 ────────────────────────────────────────────────
    wgt, prd = one("""SELECT COUNT(*), COUNT(DISTINCT prd_cd) FROM t_wgt_widgets
                      WHERE sts_typ_cd='WGT_STS_TYPE.02' AND COALESCE(del_yn,'N')='N'""")
    hr(f"[0] 게시 분모 재실측  {stamp} KST")
    print(f"    verbatim: {stamp}|{wgt}|{prd}")

    # ── 1. PET / 메쉬의 추가상품 연결 ─────────────────────────────────────
    hr("[1] PET배너 · 메쉬배너 — 추가상품(t_prd_product_addons) 연결 현황")
    for cd, label in ((PET, "PET배너"), (MESH, "메쉬배너")):
        addons = q("""SELECT a.tmpl_cd, a.disp_seq, a.note, t.tmpl_nm, t.base_prd_cd,
                             COALESCE(t.use_yn,'?') AS use_yn, COALESCE(t.del_yn,'N') AS del_yn
                        FROM t_prd_product_addons a
                        LEFT JOIN t_prd_templates t ON t.tmpl_cd=a.tmpl_cd
                       WHERE a.prd_cd=%s ORDER BY a.disp_seq""", [cd])
        print(f"\n  ▸ {cd} {label} — 추가상품 {len(addons)}건")
        if not addons:
            print("      ⚠️ 추가상품 연결 0건 — 거치대를 템플릿 경로로 팔 그릇이 없다")
        for a in addons:
            print(f"      {a['tmpl_cd']} | {a['tmpl_nm']} | use={a['use_yn']} "
                  f"del={a['del_yn']} | base={a['base_prd_cd']}")
            tmpl_detail(a["tmpl_cd"])

    # ── 2. 거치대 관련 템플릿 전수 ────────────────────────────────────────
    hr("[2] 거치대 관련 템플릿 전수 (tmpl_nm/usr_def_nm 에 '거치대')")
    tmpls = q("""SELECT tmpl_cd, tmpl_nm, base_prd_cd, dflt_qty,
                        COALESCE(use_yn,'?') AS use_yn, COALESCE(del_yn,'N') AS del_yn,
                        note, usr_def_nm
                   FROM t_prd_templates
                  WHERE tmpl_nm LIKE '%%거치대%%' OR COALESCE(usr_def_nm,'') LIKE '%%거치대%%'
                     OR tmpl_nm LIKE '%%배너%%'
                  ORDER BY COALESCE(del_yn,'N'), tmpl_cd""")
    print(f"    건수 {len(tmpls)}")
    for t in tmpls:
        print(f"\n  ▸ {t['tmpl_cd']} | {t['tmpl_nm']} | use={t['use_yn']} del={t['del_yn']} "
              f"| base={t['base_prd_cd']} | dflt_qty={t['dflt_qty']}")
        tmpl_detail(t["tmpl_cd"])
    print(f"\n    ▸ 지니 확정 권위 값: 실내용 {AUTHORITY['실내용']:,} · "
          f"실외용 {AUTHORITY['실외용']:,}")

    # ── 3. 전 상품 추가상품 축 건강도 ─────────────────────────────────────
    hr("[3] ★전 상품 — 추가상품이 걸렸는데 직접단가가 없다(무료 유출 후보)")
    gap = q("""SELECT a.prd_cd, p.prd_nm, a.tmpl_cd, t.tmpl_nm,
                      COALESCE(t.del_yn,'N') AS tdel,
                      (SELECT COUNT(*) FROM t_wgt_widgets w
                        WHERE w.prd_cd=a.prd_cd AND w.sts_typ_cd='WGT_STS_TYPE.02'
                          AND COALESCE(w.del_yn,'N')='N') AS pub
                 FROM t_prd_product_addons a
                 LEFT JOIN t_prd_templates t ON t.tmpl_cd=a.tmpl_cd
                 LEFT JOIN t_prd_products p ON p.prd_cd=a.prd_cd
                WHERE COALESCE(t.del_yn,'N')='N'
                  AND NOT EXISTS (SELECT 1 FROM t_prd_template_prices tp
                                   WHERE tp.tmpl_cd=a.tmpl_cd)
                ORDER BY pub DESC, a.prd_cd""")
    print(f"    건수 {len(gap)}  (게시중 {sum(1 for g in gap if g['pub'])})")
    for g in gap:
        mark = "★게시중" if g["pub"] else "미게시  "
        print(f"    {mark} {g['prd_cd']} {g['prd_nm']:22} ← {g['tmpl_cd']} {g['tmpl_nm']}")

    # ── 4. 고아 템플릿 ────────────────────────────────────────────────────
    hr("[4] 고아 템플릿 — 살아있는데 어느 상품에도 연결되지 않음")
    orph = q("""SELECT t.tmpl_cd, t.tmpl_nm, t.base_prd_cd,
                       (SELECT COUNT(*) FROM t_prd_template_prices tp
                         WHERE tp.tmpl_cd=t.tmpl_cd) AS prc
                  FROM t_prd_templates t
                 WHERE COALESCE(t.del_yn,'N')='N'
                   AND NOT EXISTS (SELECT 1 FROM t_prd_product_addons a
                                    WHERE a.tmpl_cd=t.tmpl_cd)
                 ORDER BY t.tmpl_cd""")
    print(f"    건수 {len(orph)}")
    for o in orph:
        print(f"    {o['tmpl_cd']} {o['tmpl_nm']:34} base={o['base_prd_cd']} 단가행={o['prc']}")

    # ── 5. 요약 ───────────────────────────────────────────────────────────
    tot_t = one("SELECT COUNT(*) FROM t_prd_templates WHERE COALESCE(del_yn,'N')='N'")[0]
    tot_p = one("SELECT COUNT(DISTINCT tmpl_cd) FROM t_prd_template_prices")[0]
    tot_a = one("SELECT COUNT(*) FROM t_prd_product_addons")[0]
    hr("[5] 요약")
    print(f"    미삭제 템플릿 {tot_t} · 직접단가 보유 템플릿 {tot_p} · 상품-추가상품 연결 {tot_a}")
    print(f"    무료 유출 후보 {len(gap)} · 고아 템플릿 {len(orph)}")
    print(f"완료 {datetime.now():%Y-%m-%d %H:%M:%S}")


if __name__ == "__main__":
    main()
