"""고아 추가상품 템플릿 분류 — 「정상(다른 경로로 청구)」 vs 「진짜 미연결」 (읽기전용).

지니 지시(2026-08-27): 고아 템플릿 35건 분류.

배경 — widget_api.py:1601 이 t_prd_product_addons 를 화이트리스트로 쓴다.
  상품에 연결되지 않은 tmpl_cd 는 위젯에서 skip 된다 ⇒ 고객이 고를 수 없다.
  다만 M1-1K §A 경계 규칙상 **같은 물건이 두 경로에 있는 것 자체는 정상**이므로,
  「팔 수 없다」를 결함이라 부르기 전에 그 기능이 가격구성요소 경로로 이미 청구되는지
  확인해야 한다([HARD] 3 — 「비어 있음」을 결함이라 부르기 전에 부모를 확인하라).

판정 방법 (기계적 · 텍스트 추론 아님)
  ① 템플릿의 selections 에서 자재 코드 집합을 뽑는다
  ② 그 자재를 단가 차원으로 쓰는 가격구성요소(t_prc_component_prices.mat_cd)를 찾는다
  ③ 그 구성요소가 공식에 연결되고 그 공식이 상품에 바인딩됐는지 본다
  ④ 그 상품이 게시중인지 본다
  ⇒ ②③ 이 성립하면 「comp 경로로 청구 중(정상)」, 아니면 「미연결 후보」

이 스크립트는 SELECT 만 한다. DB 를 바꾸지 않는다.

실행: raw/webadmin/.venv/bin/python _workspace/huni-widget-wiring/bin/audit_orphan_templates.py
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


def q(sql, params=None):
    c = connection.cursor()
    c.execute(sql, params or [])
    cols = [d[0] for d in c.description]
    return [dict(zip(cols, r)) for r in c.fetchall()]


def one(sql, params=None):
    c = connection.cursor()
    c.execute(sql, params or [])
    return c.fetchone()


def main():
    stamp = one("SELECT to_char(now() AT TIME ZONE 'Asia/Seoul','YYYY-MM-DD HH24:MI:SS')")[0]
    wgt, prd = one("""SELECT COUNT(*), COUNT(DISTINCT prd_cd) FROM t_wgt_widgets
                      WHERE sts_typ_cd='WGT_STS_TYPE.02' AND COALESCE(del_yn,'N')='N'""")
    print("=" * 78)
    print(f"[0] 게시 분모 재실측  verbatim: {stamp}|{wgt}|{prd}")

    orphans = q("""SELECT t.tmpl_cd, t.tmpl_nm, t.base_prd_cd, bp.prd_nm AS base_nm,
                          bp.prd_typ_cd AS base_typ,
                          (SELECT MAX(unit_price) FROM t_prd_template_prices tp
                            WHERE tp.tmpl_cd=t.tmpl_cd) AS price
                     FROM t_prd_templates t
                     LEFT JOIN t_prd_products bp ON bp.prd_cd=t.base_prd_cd
                    WHERE COALESCE(t.del_yn,'N')='N'
                      AND NOT EXISTS (SELECT 1 FROM t_prd_product_addons a
                                       WHERE a.tmpl_cd=t.tmpl_cd)
                    ORDER BY t.base_prd_cd, t.tmpl_cd""")
    print("=" * 78)
    print(f"[1] 고아 템플릿 {len(orphans)}건 — 자재별 comp 경로 대조")

    covered, uncovered, nomat = [], [], []

    for o in orphans:
        mats = [r["ref_key1"] for r in q(
            """SELECT ref_key1 FROM t_prd_template_selections
                WHERE tmpl_cd=%s AND COALESCE(del_yn,'N')='N'
                  AND ref_dim_cd='OPT_REF_DIM.03' AND ref_key1 IS NOT NULL""",
            [o["tmpl_cd"]])]
        if not mats:
            nomat.append((o, [], []))
            continue

        # 그 자재를 파는 상품을 찾고(자재 등록 축), 그 상품의 공식이 실제로 그 선택에
        # 값을 매기는지 본다. 단가행의 차원은 mat_cd 일 수도 opt_cd 일 수도 있으므로
        # (M1-1E 세대 재배선은 opt_cd 축이었다) **두 축을 모두** 본다.
        # mat_cd 만 보는 프로브는 opt_cd 청구를 놓쳐 거짓 「미연결」을 만든다.
        hosts = q("""WITH host AS (
                       SELECT DISTINCT pm.prd_cd
                         FROM t_prd_product_materials pm
                        WHERE pm.mat_cd = ANY(%s) AND COALESCE(pm.del_yn,'N')='N'
                     ), opt AS (
                       -- 그 자재로 해소되는 옵션값(opt_cd) — opt_cd 축 단가행 대조용
                       SELECT DISTINCT oi.prd_cd, oi.opt_cd
                         FROM t_prd_product_option_items oi
                        WHERE oi.ref_key1 = ANY(%s) AND COALESCE(oi.del_yn,'N')='N'
                     )
                     SELECT DISTINCT h.prd_cd, p.prd_nm, cp.comp_cd,
                            CASE WHEN cp.mat_cd IS NOT NULL THEN 'mat_cd'
                                 ELSE 'opt_cd' END AS axis,
                            (SELECT COUNT(*) FROM t_wgt_widgets w
                              WHERE w.prd_cd=h.prd_cd AND w.sts_typ_cd='WGT_STS_TYPE.02'
                                AND COALESCE(w.del_yn,'N')='N') AS pub
                       FROM host h
                       JOIN t_prd_product_price_formulas pf ON pf.prd_cd=h.prd_cd
                       JOIN t_prc_formula_components fc ON fc.frm_cd=pf.frm_cd
                       JOIN t_prc_price_components pc ON pc.comp_cd=fc.comp_cd
                                                     AND COALESCE(pc.del_yn,'N')='N'
                       JOIN t_prc_component_prices cp ON cp.comp_cd=fc.comp_cd
                       LEFT JOIN t_prd_products p ON p.prd_cd=h.prd_cd
                      WHERE cp.mat_cd = ANY(%s)
                         OR cp.opt_cd IN (SELECT o.opt_cd FROM opt o WHERE o.prd_cd=h.prd_cd)
                      ORDER BY h.prd_cd""", [mats, mats, mats])
        if hosts:
            covered.append((o, mats, hosts))
        else:
            uncovered.append((o, mats, []))

    def show(title, bucket, note):
        print("\n" + "-" * 78)
        print(f"{title} — {len(bucket)}건")
        print(f"  {note}")
        for o, mats, hosts in bucket:
            price = f"{o['price']:,.0f}" if o["price"] is not None else "단가없음"
            print(f"\n  ▸ {o['tmpl_cd']} {o['tmpl_nm']}")
            print(f"      base={o['base_prd_cd']} {o['base_nm']} ({o['base_typ']}) · 직접단가 {price}")
            print(f"      자재 {mats or '없음'}")
            for h in hosts[:6]:
                mark = " ★게시중" if h["pub"] else ""
                print(f"      └ comp 청구: {h['prd_cd']} {h['prd_nm']}{mark}  "
                      f"via {h['comp_cd']} [{h['axis']}]")
            if len(hosts) > 6:
                print(f"      └ … 외 {len(hosts) - 6}건")

    show("[A] 정상 — 가격구성요소 경로로 이미 청구 중", covered,
         "두 경로 병존은 M1-1K §A 상 정상. 위젯 미노출이 의도인지만 실무진 확인 대상.")
    show("[B] 미연결 후보 — 어느 경로로도 청구 근거를 찾지 못함", uncovered,
         "★진짜 매출 유실 후보. 상품 단위로 「이걸 끼워팔아야 하는 상품이 있나」 확인 필요.")
    show("[C] 판정 불가 — 자재 선택값이 없어 대조 불능", nomat,
         "템플릿 구성이 자재 축이 아니다(공정·옵션 등). 개별 확인 필요.")

    print("\n" + "=" * 78)
    print(f"[2] 요약  정상 {len(covered)} · 미연결 후보 {len(uncovered)} · 판정불가 {len(nomat)}")
    print(f"완료 {datetime.now():%Y-%m-%d %H:%M:%S}")


if __name__ == "__main__":
    main()
