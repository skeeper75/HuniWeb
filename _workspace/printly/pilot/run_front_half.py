#!/usr/bin/env python
"""프린틀리 전반부 종단 데모 — 업종 → (추천 층 순회) → 홍보물 → 실엔진 견적.

원칙: ①추천 층=선언 데이터(recommendation-layer.json)·로직=순회 ③견적=evaluate_price(엔진)
      ④근거=node_id 경로 병기 · 순위=dominance/fit 결정론(최종 순위=엔진·recommendation_function 보류).

실행(webadmin venv 필요):
    raw/.venv/bin/python _workspace/printly/pilot/run_front_half.py <업종> [수량] [기능]
    예: raw/.venv/bin/python _workspace/printly/pilot/run_front_half.py 미용실 100
        raw/.venv/bin/python _workspace/printly/pilot/run_front_half.py 카페 300 INTENT_FN_RETAIN
"""
import os
import sys
import json
import urllib.parse as _u

HERE = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.abspath(os.path.join(HERE, "..", "..", ".."))
WEBADMIN = os.path.join(REPO, "raw", "webadmin", "webadmin")
LAYER = os.path.join(HERE, "recommendation-layer.json")


def _load_env_db():
    """.env.local 의 RAILWAY_DB_* → DATABASE_URL(없을 때만). 비밀값 출력 안 함."""
    if os.environ.get("DATABASE_URL"):
        return
    env = {}
    try:
        with open(os.path.join(REPO, ".env.local"), encoding="utf-8") as f:
            for line in f:
                line = line.strip()
                if line.startswith("RAILWAY_DB_") and "=" in line:
                    k, v = line.split("=", 1)
                    env[k.strip()] = v.strip().strip('"').strip("'")
    except OSError:
        return
    need = ("RAILWAY_DB_USER", "RAILWAY_DB_PASSWORD", "RAILWAY_DB_HOST", "RAILWAY_DB_PORT", "RAILWAY_DB_NAME")
    if all(k in env for k in need):
        os.environ["DATABASE_URL"] = "postgresql://%s:%s@%s:%s/%s" % (
            env["RAILWAY_DB_USER"], _u.quote(env["RAILWAY_DB_PASSWORD"], safe=""),
            env["RAILWAY_DB_HOST"], env["RAILWAY_DB_PORT"], env["RAILWAY_DB_NAME"])


_load_env_db()
sys.path.insert(0, WEBADMIN)
os.environ.setdefault("DJANGO_SETTINGS_MODULE", "config.settings")
import django  # noqa: E402
django.setup()
from catalog import models as M, pricing as P  # noqa: E402
from django.db import connection  # noqa: E402

DOM_ORDER = {"primary": 0, "secondary": 1, "tertiary": 2}


def show_options(prd_cd):
    """상품의 CPQ 옵션 타입(그룹) + 항목수 — '옵션 타입별 추천'(3단계)의 데이터."""
    with connection.cursor() as c:
        c.execute(
            """SELECT COALESCE(NULLIF(g.usr_def_nm,''), g.opt_grp_nm), g.sel_typ_cd, g.mand_yn
               FROM t_prd_product_option_groups g
               WHERE g.prd_cd=%s AND COALESCE(g.del_yn,'N')='N' AND COALESCE(g.use_yn,'Y')='Y'
               ORDER BY g.disp_seq""", [prd_cd])
        return c.fetchall()


def find_product(layer, name):
    for pid, p in layer["products"].items():
        if name == p["name"] or name in p["name"] or name == p["prd_cd"]:
            return pid, p
    return None, None


def pick_and_quote(prd_cd, qty):
    """상품 대표 사양 자동 선택 → evaluate_price(엔진) 실견적."""
    if not M.TPrdProducts.objects.filter(pk=prd_cd).exists():
        return None
    plt = M.TPrdProductPlateSizes.objects.filter(prd_cd=prd_cd).values_list("siz_cd", flat=True).first()
    siz = M.TPrdProductSizes.objects.filter(prd_cd=prd_cd).values_list("siz_cd", flat=True).first()
    mat = M.TPrdProductMaterials.objects.filter(prd_cd=prd_cd).values_list("mat_cd", flat=True).first()
    popt = (M.TPrdProductPrintOptions.objects.filter(prd_cd=prd_cd)
            .exclude(print_opt_cd__isnull=True).values_list("print_opt_cd", flat=True).first())
    mand = list(M.TPrdProductProcesses.objects.filter(prd_cd=prd_cd, mand_proc_yn="Y")
                .values_list("proc_cd", flat=True))
    sel = {k: v for k, v in {"plt_siz_cd": plt, "siz_cd": siz, "mat_cd": mat,
                             "print_opt_cd": popt}.items() if v}
    proc_sels = [{"proc_cd": p} for p in mand] or None
    res = P.evaluate_price({"prd_cd": prd_cd}, sel, qty, mode="lenient", proc_sels=proc_sels)
    return res


def resolve_industry(layer, arg):
    """한글 라벨 또는 노드 id로 업종 찾기."""
    for iid, node in layer["industries"].items():
        if arg == iid or arg == node["label"]:
            return iid, node
    return None, None


def main():
    if len(sys.argv) < 2:
        print("사용법: run_front_half.py <업종> [수량] [기능node]")
        print("       run_front_half.py opts <상품명> [수량]   (옵션 타입별 보기·3단계)")
        return 1
    layer = json.load(open(LAYER, encoding="utf-8"))

    # 모드: opts <상품명> — 선택한 홍보물의 옵션 타입 + 실견적 (3단계)
    if sys.argv[1] == "opts":
        name = sys.argv[2] if len(sys.argv) > 2 else ""
        qty = int(sys.argv[3]) if len(sys.argv) > 3 else 100
        pid, p = find_product(layer, name)
        if not p:
            print(f"상품 '{name}' 없음."); return 1
        print("=" * 66)
        print(f"선택: {p['name']}  [{pid} · {p['prd_cd']}] · {qty}개")
        print("=" * 66)
        rows = show_options(p["prd_cd"])
        if rows:
            print(f"\n▶ 옵션 타입 {len(rows)}종 (손님이 고르는 축 — 타입별 추천 대상):")
            for nm, sel, mand in rows:
                req = "필수" if mand == "Y" else "선택"
                print(f"    · {nm or '(무명)':<20} [{req}·{sel}]")
        else:
            print("\n▶ 옵션 타입 없음(사양 고정).")
        res = pick_and_quote(p["prd_cd"], qty)
        if res:
            print(f"\n▶ 기본 구성 견적 = {res.get('final_price'):,}원  (src={res.get('base',{}).get('source')})")
        print("\n" + "-" * 66)
        print("옵션 타입 데이터=라이브 실재 · '타입별 3개 추천' 순위=엔진 몫(recommendation_function 보류)")
        return 0

    arg_ind = sys.argv[1]
    qty = int(sys.argv[2]) if len(sys.argv) > 2 else 100
    want_fn = sys.argv[3] if len(sys.argv) > 3 else None
    iid, ind = resolve_industry(layer, arg_ind)
    if not ind:
        print(f"업종 '{arg_ind}' 없음. 가능: " + ", ".join(n["label"] for n in layer["industries"].values()))
        return 1

    print("=" * 66)
    print(f"질의: \"{ind['label']} 홍보물 추천 + {qty}개 견적\"   [업종노드 {iid}]")
    print("=" * 66)

    # H1: 업종 → 기능 (dominance 순)
    fns = sorted(ind["functions"].items(), key=lambda kv: DOM_ORDER.get(kv[1], 9))
    primaries = [f for f, d in fns if d == "primary"]

    # 되묻기 게이트: primary 기능 복수 → 에이전트 되묻기(절차)
    if want_fn is None and len(primaries) > 1:
        print("\n[되묻기] 지배 목적이 둘 이상입니다 — 실제 에이전트라면 먼저 되물어 좁힙니다:")
        for f in primaries:
            print(f"   · {layer['functions'][f]['label']}   ({f})")
        print("   (데모는 아래에서 전 지배 목적을 모두 펼쳐 보입니다.)")

    target_fns = [want_fn] if want_fn else [f for f, d in fns if d in ("primary", "secondary")]

    for fn in target_fns:
        fnode = layer["functions"].get(fn)
        if not fnode:
            print(f"\n기능 '{fn}' 없음."); continue
        dom = ind["functions"].get(fn, "-")
        print(f"\n▶ {fnode['label']}   [{fn} · 업종 지배도={dom}]")
        # H2: 기능 → 홍보물 (fit 순)
        prods = sorted(fnode["products"].items(), key=lambda kv: DOM_ORDER.get(kv[1], 9))
        for pnode_id, fit in prods:
            p = layer["products"][pnode_id]
            res = pick_and_quote(p["prd_cd"], qty)
            if res is None:
                print(f"    · {p['name']:<16} 견적 불가(상품 없음)"); continue
            price = res.get("final_price")
            src = res.get("base", {}).get("source")
            path = f"{iid} → {fn} → {pnode_id}({p['prd_cd']})"
            print(f"    · {p['name']:<16} {price:>10,}원  [fit={fit}·src={src}]")
            print(f"        근거: {path}")

    print("\n" + "-" * 66)
    print("견적 = evaluate_price(엔진 권위·값 지어내기 없음) · 순서 = dominance/fit 결정론")
    print("최종 순위 매기기 = 추천 엔진 몫(recommendation_function 보류·D-REC 경계)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
