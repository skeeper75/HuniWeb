"""PET배너·메쉬배너 — 상품뷰어 가격구조 전량 덤프 (읽기전용).

지니 지시: 「PET배너와 매쉬배너가 처리되었으니 상품뷰어를 통해 어떻게 구성요소가
만들어졌는지 상세하게 파악해서 가격을 확인할 수 있도록 해줘」.

[HARD] 이 스크립트는 SELECT 만 한다. DB 를 바꾸지 않는다.

★핵심 설계 — 화면 재구현이 아니라 **화면 함수 그대로 호출**이다.
  - `price_views.price_product_detail()` → 가격뷰어 상세 패널(JSON)과 **동일 데이터**
  - `price_views.price_diagram()`        → 「가격 구조 보기」 화면 컨텍스트와 **동일 데이터**
                                            (render 를 가로채 ctx 만 회수 · HTML 미생성)
  - `pricing.evaluate_price()`           → 위젯/시뮬레이터가 부르는 그 엔진 그대로
  ⇒ 여기 출력과 실화면이 어긋날 수 없다(같은 코드 경로).

측정 항목
  0) 게시 분모 재실측(값 + 일시 원장 · [HARD] 1)
  1) 상품뷰어 상세 — 가격소스 / 현재공식 / 구성요소 / 템플릿 / 할인
  2) 가격구조 — 구성요소별 단가표 전량(컬럼 라벨 + 셀)
  3) 고객이 고르는 옵션 축 — 사이즈·자재·공정·옵션그룹
  4) 가격엔진 실호출(strict) — 최종가 + 단계별 내역
  5) 권위 대조 — 가격표 260822_1 「포스터사인」 r229 PET 22,000 / r238 메쉬 38,000

실행:
  raw/webadmin/.venv/bin/python _workspace/huni-widget-wiring/bin/dump_banner_price_structure.py
"""
import json
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
from django.test import RequestFactory  # noqa: E402

from catalog import price_views as PV  # noqa: E402
from catalog import pricing  # noqa: E402

# 권위 — 인쇄상품 가격표 260822_1 「포스터사인」 (progress.md §I' 에서 셀 단위 확인)
TARGETS = [
    {"prd_cd": "PRD_000136", "nm": "PET배너", "authority": 22000, "cell": "r229~231 600x1800mm 수량1"},
    {"prd_cd": "PRD_000137", "nm": "메쉬배너", "authority": 38000, "cell": "r238~240 600x1800mm 수량1"},
]
SIZ = "SIZ_000321"   # 600x1800 mm — §I' 실호출과 동일 축
QTY = 1


def q(sql, params=None):
    c = connection.cursor()
    c.execute(sql, params or [])
    cols = [d[0] for d in c.description]
    return [dict(zip(cols, r)) for r in c.fetchall()]


def hr(title, ch="="):
    print("\n" + ch * 78)
    print(title)
    print(ch * 78)


# ---------------------------------------------------------------- 0) 분모
def publish_denominator():
    row = q("""
        SELECT COUNT(*) AS widgets, COUNT(DISTINCT prd_cd) AS products
          FROM t_wgt_widgets
         WHERE sts_typ_cd = 'WGT_STS_TYPE.02'
           AND COALESCE(del_yn,'N') = 'N'
           AND use_yn = 'Y'
    """)[0]
    stamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    print(f"게시 분모 재실측  {stamp} | 위젯 {row['widgets']} | 상품 {row['products']}")
    return row


# ------------------------------------------- 1) 상품뷰어 상세 (화면 함수 호출)
def viewer_detail(prd_cd):
    req = RequestFactory().get(f"/admin/price-product/{prd_cd}/")
    resp = PV.price_product_detail(req, prd_cd)
    return json.loads(resp.content.decode("utf-8"))


# --------------------------------------- 2) 가격구조 (render 가로채 ctx 회수)
def viewer_diagram(prd_cd):
    captured = {}

    def fake_render(request, template, ctx=None, **kw):
        captured.update(ctx or {})
        class _R:  # render 반환 자리만 채운다 — 사용하지 않는다
            status_code = 200
        return _R()

    req = RequestFactory().get(f"/admin/price-diagram/{prd_cd}/")
    real_render = PV.render
    real_ctx = PV.admin.site.each_context
    PV.render = fake_render
    PV.admin.site.each_context = lambda r: {}   # 인증 컨텍스트 우회(읽기전용)
    try:
        PV.price_diagram(req, prd_cd)
    finally:
        PV.render = real_render
        PV.admin.site.each_context = real_ctx
    return captured


# ------------------------------------------------- 3) 고객이 고르는 옵션 축
def option_axes(prd_cd):
    return {
        "사이즈": q("""SELECT s.siz_cd, s.siz_nm FROM t_prd_product_sizes ps
                         JOIN t_siz_sizes s ON s.siz_cd = ps.siz_cd
                        WHERE ps.prd_cd = %s AND COALESCE(ps.del_yn,'N')='N'
                        ORDER BY s.siz_cd""", [prd_cd]),
        "자재": q("""SELECT m.mat_cd, m.mat_nm FROM t_prd_product_materials pm
                        JOIN t_mat_materials m ON m.mat_cd = pm.mat_cd
                       WHERE pm.prd_cd = %s AND COALESCE(pm.del_yn,'N')='N'
                       ORDER BY m.mat_cd""", [prd_cd]),
        "공정": q("""SELECT p.proc_cd, p.proc_nm FROM t_prd_product_processes pp
                        JOIN t_proc_processes p ON p.proc_cd = pp.proc_cd
                       WHERE pp.prd_cd = %s AND COALESCE(pp.del_yn,'N')='N'
                       ORDER BY p.proc_cd""", [prd_cd]),
    }


def option_tree(prd_cd):
    """고객 화면의 옵션그룹 → 옵션 → 항목(참조차원) 3층. 거치대가 사는 층이다."""
    grps = q("""SELECT opt_grp_cd, COALESCE(usr_def_nm, opt_grp_nm) AS nm,
                       mand_yn, disp_seq
                  FROM t_prd_product_option_groups
                 WHERE prd_cd = %s AND COALESCE(del_yn,'N')='N'
                 ORDER BY COALESCE(disp_seq, 9999), opt_grp_cd""", [prd_cd])
    for g in grps:
        g["options"] = q("""
            SELECT o.opt_cd, COALESCE(o.usr_def_nm, o.opt_nm) AS nm,
                   o.dflt_yn, o.disp_seq
              FROM t_prd_product_options o
             WHERE o.prd_cd = %s AND o.opt_grp_cd = %s
               AND COALESCE(o.del_yn,'N')='N'
             ORDER BY COALESCE(o.disp_seq, 9999), o.opt_cd""",
                         [prd_cd, g["opt_grp_cd"]])
        for o in g["options"]:
            o["items"] = q("""
                SELECT item_seq, ref_dim_cd, ref_key1, ref_key2
                  FROM t_prd_product_option_items
                 WHERE prd_cd = %s AND opt_cd = %s
                   AND COALESCE(del_yn,'N')='N'
                 ORDER BY item_seq""", [prd_cd, o["opt_cd"]])
    return grps


# ----------------------------------------------------- 4) 가격엔진 실호출
def engine_call(prd_cd):
    return pricing.evaluate_price(
        {"prd_cd": prd_cd}, {"siz_cd": SIZ}, QTY, mode="strict")


# ------------------------------------------------------------------ main
def main():
    hr("0) 게시 분모 재실측 · [HARD] 1")
    publish_denominator()

    for t in TARGETS:
        prd_cd, nm = t["prd_cd"], t["nm"]
        hr(f"{nm}  {prd_cd}")

        d = viewer_detail(prd_cd)
        print(f"\n[1] 상품뷰어 상세 — 가격소스 = {d.get('current_source')}"
              f" · 상품유형 = {d.get('prd_typ')}")
        if d.get("cur_frm"):
            f = d["cur_frm"]
            print(f"    현재 공식 : {f['frm_cd__frm_nm']} ({f['frm_cd']})"
                  f" · 적용 {f['apply_bgn_ymd']}~")
        if d.get("cur_price"):
            print(f"    직접단가  : {d['cur_price']['unit_price']}"
                  f" · 적용 {d['cur_price']['apply_ymd']}~")
        print(f"    공식 이력 {len(d.get('formulas') or [])}건"
              f" · 직접단가 이력 {len(d.get('prices') or [])}건")
        print(f"    템플릿(추가상품 직접단가) : "
              f"{len(d.get('templates') or []) or '없음 — 실무진 등록 대기'}")
        dsc = d.get("discount") or {}
        print(f"    할인 연결 : 총액 {'있음' if dsc.get('current') else '없음'}"
              f" · 구성요소 스코프 {len(dsc.get('scoped') or [])}건"
              f" · 주카테고리 {dsc.get('main_cat') or '—'}")

        print("\n    구성요소 (disp_seq 순 · 상품뷰어 표기 그대로)")
        for c in d.get("components") or []:
            print(f"      #{c['disp_seq']}  {c['comp_nm']}  [{c['comp_cd']}]")
            print(f"            유형={c['prc_typ']} · 차원={c['dims'] or ['(없음)']}"
                  f" · 단가행 {c['row_count']}행")

        g = viewer_diagram(prd_cd)
        print("\n[2] 가격 구조 — 구성요소별 단가표 전량")
        for c in g.get("components") or []:
            mark = "⊕가산" if c["addtn"] else "기준"
            print(f"\n    ▸ {c['comp_nm']} [{c['comp_cd']}] · {c['prc_typ']} · {mark}"
                  f" · {c['row_count']}행")
            print(f"      컬럼: {' | '.join(c['columns'])} | {c['price_label']}")
            for r in c["rows"]:
                print(f"        {' | '.join(r['cells'])} | {r['price']}")
        if not (g.get("components") or []):
            print("    (현재 공식에 구성요소 없음)")

        print("\n[3] 고객이 고르는 옵션 축")
        for axis, rows in option_axes(prd_cd).items():
            if not rows:
                print(f"    {axis}: 없음")
                continue
            print(f"    {axis} {len(rows)}종")
            for r in rows:
                vals = list(r.values())
                print(f"      - {vals[0]}  {vals[1]}")

        print("\n[3-b] 옵션그룹 → 옵션 → 참조차원 (고객 화면 3층)")
        tree = option_tree(prd_cd)
        if not tree:
            print("    옵션그룹 없음")
        for g in tree:
            print(f"    ▸ {g['nm']} [{g['opt_grp_cd']}]"
                  f" · 필수={g['mand_yn']} · 옵션 {len(g['options'])}개")
            for o in g["options"]:
                refs = ", ".join(
                    f"{i['ref_dim_cd']}→{i['ref_key1']}"
                    + (f"/{i['ref_key2']}" if i["ref_key2"] else "")
                    for i in o["items"]) or "참조 없음"
                dflt = " (기본값)" if o["dflt_yn"] == "Y" else ""
                print(f"        - {o['nm']} [{o['opt_cd']}]{dflt}  ⇒ {refs}")

        print("\n[4] 가격엔진 실호출 (strict · siz_cd=%s · qty=%d)" % (SIZ, QTY))
        res = engine_call(prd_cd)
        base = res.get("base") or {}
        print(f"    ok={res.get('ok')} · source={base.get('source')}"
              f" · base={base.get('amount')}")
        for comp in base.get("components") or []:
            print(f"      + {comp.get('comp_nm') or comp.get('comp_cd')}"
                  f" = {comp.get('amount')}  {comp.get('detail') or ''}")
        print(f"    할인 {res.get('discounts')}")
        print(f"    final_price = {res.get('final_price')}")
        if res.get("warnings"):
            print(f"    warnings: {res['warnings']}")
        if res.get("errors"):
            print(f"    errors  : {res['errors']}")

        print(f"\n[5] 권위 대조 — 가격표 260822_1 「포스터사인」 {t['cell']}")
        fp = res.get("final_price")
        ok = (fp is not None and int(fp) == t["authority"])
        print(f"    권위 {t['authority']:,} · 라이브 {fp} · "
              f"{'일치 ✓' if ok else '불일치 ✗'}")

    hr("완료 — DB 변경 0 (SELECT only)")


if __name__ == "__main__":
    main()
