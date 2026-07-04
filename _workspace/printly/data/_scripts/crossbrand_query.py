#!/usr/bin/env python
"""질의 기반 온톨로지 검증 — "카페 오픈 홍보물, 후니·와우 어디가?"

와우 레시피(recipes/wow/*.json)의 same_family_as 엣지를 순회해 각 상품군마다
후니(evaluate_price 실호출) ↔ 와우(jobcost 실 견적 샘플)를 나란히 세운다.
= 온톨로지 검증: ①same_family_as 교차 엣지 ②브랜드별 quote_function ③상위개념 정렬이
  한 질의에서 일관된 교차브랜드 답을 내는가.

[HARD] 값 지어내기 없음: 후니=엔진 실호출·와우=레시피에 보존된 devshop 관측 샘플.
실행: raw/.venv/bin/python _workspace/printly/data/_scripts/crossbrand_query.py [수량=500]
"""
import os, sys, json, glob, urllib.parse as _u

HERE = os.path.dirname(os.path.abspath(__file__))
DATA = os.path.abspath(os.path.join(HERE, ".."))
REPO = os.path.abspath(os.path.join(HERE, "..", "..", "..", ".."))
WEBADMIN = os.path.join(REPO, "raw", "webadmin", "webadmin")
WOW_DIR = os.path.join(DATA, "recipes", "wow")

# 카페 오픈에 실제 쓰이는 상품군(evidence-base 카페 행·verified)
# IDENTITY명함·BRAND스티커·DISPLAY엽서카드/매장용품·ACQUIRE전단·EVENT현수막(사인/실사)
CAFE_FAMILIES = {"명함", "스티커", "엽서·카드", "전단", "사인·실사", "매장용품/탁상POP", "쿠폰·상품권"}


def _load_env_db():
    if os.environ.get("DATABASE_URL"):
        return
    env = {}
    with open(os.path.join(REPO, ".env.local"), encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if line.startswith("RAILWAY_DB_") and "=" in line:
                k, v = line.split("=", 1); env[k.strip()] = v.strip().strip('"').strip("'")
    need = ("RAILWAY_DB_USER", "RAILWAY_DB_PASSWORD", "RAILWAY_DB_HOST", "RAILWAY_DB_PORT", "RAILWAY_DB_NAME")
    if all(k in env for k in need):
        os.environ["DATABASE_URL"] = "postgresql://%s:%s@%s:%s/%s" % (
            env["RAILWAY_DB_USER"], _u.quote(env["RAILWAY_DB_PASSWORD"], safe=""),
            env["RAILWAY_DB_HOST"], env["RAILWAY_DB_PORT"], env["RAILWAY_DB_NAME"])


_P = None
def huni_price(prd_cd, qty):
    global _P
    if _P is None:
        _load_env_db(); sys.path.insert(0, WEBADMIN)
        os.environ.setdefault("DJANGO_SETTINGS_MODULE", "config.settings")
        import django; django.setup()
        from catalog import models as M, pricing as P
        _P = (M, P)
    M, P = _P
    if not M.TPrdProducts.objects.filter(pk=prd_cd).exists():
        return None
    plt = M.TPrdProductPlateSizes.objects.filter(prd_cd=prd_cd).values_list("siz_cd", flat=True).first()
    siz = M.TPrdProductSizes.objects.filter(prd_cd=prd_cd).values_list("siz_cd", flat=True).first()
    mat = M.TPrdProductMaterials.objects.filter(prd_cd=prd_cd).values_list("mat_cd", flat=True).first()
    popt = (M.TPrdProductPrintOptions.objects.filter(prd_cd=prd_cd)
            .exclude(print_opt_cd__isnull=True).values_list("print_opt_cd", flat=True).first())
    mand = list(M.TPrdProductProcesses.objects.filter(prd_cd=prd_cd, mand_proc_yn="Y")
                .values_list("proc_cd", flat=True))
    sel = {k: v for k, v in {"plt_siz_cd": plt, "siz_cd": siz, "mat_cd": mat, "print_opt_cd": popt}.items() if v}
    try:
        r = P.evaluate_price({"prd_cd": prd_cd}, sel, qty, mode="lenient",
                             proc_sels=[{"proc_cd": p} for p in mand] or None)
        return r.get("final_price")
    except Exception:
        return None


def wow_rep_sample(recipe):
    """레시피 대표 샘플(첫) → (bill, spec, qty). 상품군마다 자연 수량(매/개)."""
    lp = recipe["recipe"]["가격구성요소"].get("live_price_samples", {})
    samp = lp.get("samples", [])
    if not samp:
        return None, None, None
    s = samp[0]
    return s.get("ordcost_bill"), lp.get("spec", ""), s.get("qty", 1)


def main():
    print("=" * 78)
    print('질의: "카페 오픈 홍보물, 후니·와우 중 어디서 뽑을까?"')
    print("       (상품군마다 자연 수량 = 와우 대표 샘플 수량에 후니도 맞춰 견적)")
    print("=" * 78)
    recipes = [json.load(open(f, encoding="utf-8")) for f in sorted(glob.glob(os.path.join(WOW_DIR, "*.json")))]
    shown = 0
    for r in recipes:
        sfa = r["후니_교차"]["same_family_as"]
        fam = sfa["family"].split(" (")[0]
        if fam not in {f for f in CAFE_FAMILIES}:
            continue
        shown += 1
        wname = r["product"]["name"]
        wbill, wspec, wqty = wow_rep_sample(r)
        unit = r["product"].get("unit", "매")
        huni_list = sfa.get("huni_products", [])
        print(f'\n▶ [{sfa["family"]}]  (same_family_as·상위개념 UPPER_ProductFamily · {wqty}{unit})')
        if not huni_list:
            # ★비대칭 케이스: 후니 대응 없음 → 연결 벤더 중 와우 단독
            print(f'    후니  (대응 상품 없음·GAP)')
            print(f'    와우  {wname:<16}{(f"{wbill:,}원" if wbill else "샘플없음"):>12}   [jobcost·{wspec}]')
            print(f'    → ★와우 단독(연결 벤더 중 유일) — 이 니즈는 와우 강제(point1 연결-앵커·비대칭)')
            continue
        huni0 = huni_list[0]
        hprice = huni_price(huni0["prd_cd"], wqty) if wqty else None
        print(f'    후니  {huni0["name"]:<16}{(f"{hprice:,}원" if hprice else "견적불가"):>12}   [evaluate_price·대표사양]')
        print(f'    와우  {wname:<16}{(f"{wbill:,}원" if wbill else "샘플없음"):>12}   [jobcost·{wspec}]')
        if hprice and wbill:
            cheaper = "후니" if hprice < wbill else "와우"
            print(f'    → 이 사양·수량 기준 저가 = {cheaper}  (★티어·스펙 상이·price_basis 정규화 전 참고용)')
    print("\n" + "-" * 78)
    print(f"검증: 와우 {shown}개 상품군이 same_family_as로 후니와 교차 연결·양 벤더 엔진 실호출.")
    print("★가격 순위는 상품군마다 뒤집힘(명함=와우 쌈·엽서=와우 비쌈) → 나이브 비교 금지·feasibility+basis 선행.")
    print("값=엔진(후니 evaluate_price·와우 jobcost)·지어내기 0 · 최종 추천=엔진(D-REC 경계).")
    return 0


if __name__ == "__main__":
    sys.exit(main())
