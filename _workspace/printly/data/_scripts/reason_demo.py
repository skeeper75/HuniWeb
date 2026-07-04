#!/usr/bin/env python
"""추천 이유 데모 — 07_recommendation-basis 설계 실증.

"카페 오픈, 뭘 만들까?" → 업종→원자기능→홍보물 순회하며 **출처+신뢰등급 박힌 이유**를 출력.
지니 확정 기준(출처+등급 표기로 충분): verified=단정 어조 / candidate=완충 어조 / gap=약함 명시.
값(가격)=엔진(evaluate_price 실호출·선택). 이유=근거 사슬 그대로(원칙4·지어내기 차단).

실행:
    raw/.venv/bin/python _workspace/printly/data/_scripts/reason_demo.py [업종=카페] [수량=500]
    (수량 주면 대표 홍보물에 evaluate_price 실견적 병기)
"""
import os, sys, json, urllib.parse as _u

HERE = os.path.dirname(os.path.abspath(__file__))
PILOT = os.path.abspath(os.path.join(HERE, "..", "..", "pilot"))
REPO = os.path.abspath(os.path.join(HERE, "..", "..", "..", ".."))
WEBADMIN = os.path.join(REPO, "raw", "webadmin", "webadmin")
LAYER = os.path.join(PILOT, "recommendation-layer.json")
DOM = {"primary": 0, "secondary": 1, "tertiary": 2}

# 등급별 어조 (지니 확정 = 출처+등급 표기)
TONE = {
    "verified":  ("추천", "많이 씁니다"),
    "candidate": ("참고", "쓴다고 알려져 있습니다"),
    "gap":       ("주의", "일 수 있으나 근거가 약합니다"),
}


def resolve_industry(layer, arg):
    for iid, node in layer["industries"].items():
        if arg == iid or arg == node["label"] or arg in node["label"]:
            return iid, node
    return None, None


def _load_env_db():
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


_PRICING = None
def huni_price(prd_cd, qty):
    """대표 사양 evaluate_price 실견적(엔진). 실패 시 None."""
    global _PRICING
    if _PRICING is None:
        _load_env_db()
        sys.path.insert(0, WEBADMIN)
        os.environ.setdefault("DJANGO_SETTINGS_MODULE", "config.settings")
        import django; django.setup()
        from catalog import models as M, pricing as P
        _PRICING = (M, P)
    M, P = _PRICING
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
        res = P.evaluate_price({"prd_cd": prd_cd}, sel, qty, mode="lenient",
                               proc_sels=[{"proc_cd": p} for p in mand] or None)
        return res.get("final_price")
    except Exception:
        return None


def main():
    ind_arg = sys.argv[1] if len(sys.argv) > 1 else "카페"
    qty = int(sys.argv[2]) if len(sys.argv) > 2 else None
    layer = json.load(open(LAYER, encoding="utf-8"))
    iid, ind = resolve_industry(layer, ind_arg)
    if not ind:
        print("업종 없음. 가능:", ", ".join(n["label"] for n in layer["industries"].values())); return 1

    ev = layer.get("evidence", {}).get(iid)
    print("=" * 70)
    print(f'질의: "{ind["label"]} — 뭘 만들까?"   [업종 {iid}]')
    if ev:
        print(f'업종 근거: [{ev["grade"]}] {ev["why"]}')
    else:
        print("업종 근거: (evidence 미배선 — 동형 전파 대기)")
    print("=" * 70)

    fns = sorted(ind["functions"].items(), key=lambda kv: DOM.get(kv[1], 9))
    for fn, dom in fns:
        fnode = layer["functions"].get(fn, {})
        fev = (ev or {}).get("functions", {}).get(fn) if ev else None
        grade = (fev or {}).get("grade", "candidate")
        label_tag, verb = TONE.get(grade, TONE["candidate"])
        # 대표 홍보물(primary 우선)
        prods = sorted(fnode.get("products", {}).items(), key=lambda kv: DOM.get(kv[1], 9))
        top = prods[0][0] if prods else None
        pinfo = layer["products"].get(top, {}) if top else {}
        pname = pinfo.get("name", "-"); group = pinfo.get("group", "-")

        print(f'\n▶ [{label_tag}·{grade}] {fnode.get("label","")}   (진열대: {group})')
        if fev:
            print(f'    이유: {fev["reason"]} — 이런 이유로 {verb}.')
            print(f'    출처: {" · ".join(fev.get("sources", []))}')
            if fev.get("gap"):
                print(f'    ⚠ {fev["gap"]}')
        else:
            print(f'    이유: (근거 미배선) {fnode.get("label","")} 계열 — {verb}.')
        # 대표 홍보물 + 실견적
        if top:
            line = f'    → 대표: {pname}'
            if qty:
                p = huni_price(pinfo.get("prd_cd"), qty)
                line += f'  ({qty}개 견적 {p:,}원·엔진)' if p else f'  ({qty}개 견적 불가·미배선)'
            print(line)

    print("\n" + "-" * 70)
    print("이유 = 출처+등급 사슬(원칙4) · 등급 어조: verified=단정·candidate=완충·gap=약함명시")
    print("견적 = evaluate_price(엔진·값 지어내기 없음) · 최종 순위 = 엔진(recommendation_function 보류)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
