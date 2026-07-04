#!/usr/bin/env python
"""완료 판정 데모 — "카페 오픈 명함"을 후니·와우 나란히 견적.

후니 = evaluate_price(라이브 엔진 실호출). 와우 = 레시피에 보존된 jobcost 실 견적 샘플
(devshop 가격조회 콘솔 관측값·지어내기 아님·라이브 재호출은 브라우저 콘솔 경유).

실행: raw/.venv/bin/python _workspace/printly/data/_scripts/compare_namecard.py [수량]
"""
import os, sys, json, urllib.parse as _u

HERE = os.path.dirname(os.path.abspath(__file__))
DATA = os.path.abspath(os.path.join(HERE, ".."))
REPO = os.path.abspath(os.path.join(HERE, "..", "..", "..", ".."))
WEBADMIN = os.path.join(REPO, "raw", "webadmin", "webadmin")
WOW_RECIPE = os.path.join(DATA, "recipes", "wow", "일반명함-40073.json")


def _load_env_db():
    if os.environ.get("DATABASE_URL"):
        return
    env = {}
    with open(os.path.join(REPO, ".env.local"), encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if line.startswith("RAILWAY_DB_") and "=" in line:
                k, v = line.split("=", 1)
                env[k.strip()] = v.strip().strip('"').strip("'")
    need = ("RAILWAY_DB_USER", "RAILWAY_DB_PASSWORD", "RAILWAY_DB_HOST", "RAILWAY_DB_PORT", "RAILWAY_DB_NAME")
    if all(k in env for k in need):
        os.environ["DATABASE_URL"] = "postgresql://%s:%s@%s:%s/%s" % (
            env["RAILWAY_DB_USER"], _u.quote(env["RAILWAY_DB_PASSWORD"], safe=""),
            env["RAILWAY_DB_HOST"], env["RAILWAY_DB_PORT"], env["RAILWAY_DB_NAME"])


def huni_quote(prd_cd, qty):
    _load_env_db()
    sys.path.insert(0, WEBADMIN)
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "config.settings")
    import django
    django.setup()
    from catalog import models as M, pricing as P
    plt = M.TPrdProductPlateSizes.objects.filter(prd_cd=prd_cd).values_list("siz_cd", flat=True).first()
    siz = M.TPrdProductSizes.objects.filter(prd_cd=prd_cd).values_list("siz_cd", flat=True).first()
    mat = M.TPrdProductMaterials.objects.filter(prd_cd=prd_cd).values_list("mat_cd", flat=True).first()
    popt = (M.TPrdProductPrintOptions.objects.filter(prd_cd=prd_cd)
            .exclude(print_opt_cd__isnull=True).values_list("print_opt_cd", flat=True).first())
    mand = list(M.TPrdProductProcesses.objects.filter(prd_cd=prd_cd, mand_proc_yn="Y")
                .values_list("proc_cd", flat=True))
    sel = {k: v for k, v in {"plt_siz_cd": plt, "siz_cd": siz, "mat_cd": mat, "print_opt_cd": popt}.items() if v}
    proc_sels = [{"proc_cd": p} for p in mand] or None
    res = P.evaluate_price({"prd_cd": prd_cd}, sel, qty, mode="lenient", proc_sels=proc_sels)
    return res.get("final_price")


def wow_sample(qty, color="양면 칼라8도"):
    r = json.load(open(WOW_RECIPE, encoding="utf-8"))
    samples = r["recipe"]["가격구성요소"]["live_price_samples"]["samples"]
    for s in samples:
        if s["qty"] == qty and s["color"] == color:
            return s["ordcost_bill"], r["recipe"]["가격구성요소"]["live_price_samples"]["spec"]
    return None, None


def main():
    qty = int(sys.argv[1]) if len(sys.argv) > 1 else 500
    print("=" * 66)
    print(f'질의: "카페 오픈 — 명함 {qty}매, 어디가 좋을까?"   (같은 상품군 A-1·same_family_as)')
    print("=" * 66)
    # 후니
    hp = huni_quote("PRD_000033", qty)
    print(f"\n  후니프린팅  스탠다드명함(PRD_000033)  {hp:>10,}원   [evaluate_price·대표사양·소매]")
    # 와우
    wb, spec = wow_sample(qty)
    if wb:
        print(f"  와우프레스  일반명함(40073)          {wb:>10,}원   [jobcost·{spec}·devshop 도매]")
    else:
        print(f"  와우프레스  일반명함(40073)          (수량 {qty} 샘플 없음 — devshop 콘솔 재조회 필요)")
    print("\n" + "-" * 66)
    print("후니=라이브 엔진 실호출 · 와우=devshop 실 견적 샘플(레시피 보존·지어내기 0)")
    print("★격차=시장 티어 상이(price_model_differs). 스펙 정규화 대조=후속.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
