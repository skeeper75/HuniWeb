#!/usr/bin/env python
"""질의 기반 온톨로지 검증 — "카페 오픈 홍보물, 후니·와우 어디가?"

와우 레시피(recipes/wow/*.json)의 same_family_as 엣지를 순회해 각 상품군마다
후니(evaluate_price 실호출) ↔ 와우(jobcost 실 견적 샘플)를 나란히 세운다.
= 온톨로지 검증: ①same_family_as 교차 엣지 ②브랜드별 quote_function ③상위개념 정렬이
  한 질의에서 일관된 교차브랜드 답을 내는가.

[HARD] 값 지어내기 없음: 후니=엔진 실호출·와우=레시피에 보존된 devshop 관측 샘플.
실행: raw/.venv/bin/python _workspace/printly/data/_scripts/crossbrand_query.py [수량=500]
"""
import os, sys, json, glob, re, urllib.parse as _u

HERE = os.path.dirname(os.path.abspath(__file__))
DATA = os.path.abspath(os.path.join(HERE, ".."))
REPO = os.path.abspath(os.path.join(HERE, "..", "..", "..", ".."))
WEBADMIN = os.path.join(REPO, "raw", "webadmin", "webadmin")
WOW_DIR = os.path.join(DATA, "recipes", "wow")
SHOPS_DIR = os.path.join(DATA, "printshops")
VERDICTS_PATH = os.path.join(
    REPO, "_workspace", "huni-multibrand-ontology", "02_crossbrand", "family-verdicts.json")


def _load_verdicts():
    """same_family_as 독립 검증 게이트(§35 G-FAM) 판정 로드(A-5). 파이프라인이 소비:
    NO_GO=크로스벤더 추천 제외·DOWNGRADE=사양 상이 경고 강제·GO=정상."""
    try:
        return json.load(open(VERDICTS_PATH, encoding="utf-8")).get("verdicts", {})
    except Exception:
        return {}


VERDICTS = _load_verdicts()


def family_verdict(family_str):
    """recipe의 sfa['family'](예 '쿠폰·상품권 (A-13 · partial)')에서 쌍ID 파싱 → 게이트 판정."""
    m = re.search(r"\b(A-\d+)\b", family_str or "")
    return VERDICTS.get(m.group(1), {}) if m else {}


def _load_basis(brand):
    """printshops/<brand>.json의 price_basis(가격 값의 의미 경계·A-1)."""
    try:
        j = json.load(open(os.path.join(SHOPS_DIR, f"{brand}.json"), encoding="utf-8"))
        return j.get("price_basis", {})
    except Exception:
        return {}


HUNI_BASIS = _load_basis("huni")
WOW_BASIS = _load_basis("wow")


def basis_comparable(a, b):
    """두 벤더 price_basis가 순위 비교 가능한가(A-1). 채널·부가세가 정합해야 순위 판정.
    ★도매→소매 환산계수 발명 금지(원칙3) — 정합 안 하면 기권. 반환 (comparable, reason)."""
    diffs = []
    if a.get("channel") != b.get("channel"):
        diffs.append(f"채널 상이({a.get('channel')} vs {b.get('channel')})")
    av, bv = a.get("vat_included"), b.get("vat_included")
    if not isinstance(av, bool) or not isinstance(bv, bool):
        diffs.append(f"부가세 미확정({av} vs {bv})")
    elif av != bv:
        diffs.append(f"부가세 포함여부 상이({av} vs {bv})")
    return (not diffs, "·".join(diffs))

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
        verdict = family_verdict(sfa["family"])          # A-5 게이트 판정
        v = verdict.get("verdict", "GO")
        wname = r["product"]["name"]
        wbill, wspec, wqty = wow_rep_sample(r)
        unit = r["product"].get("unit", "매")
        huni_list = sfa.get("huni_products", [])
        vtag = f' · A-5={v}' if v != "GO" else ''
        print(f'\n▶ [{sfa["family"]}]  (same_family_as·상위개념 UPPER_ProductFamily · {wqty}{unit}{vtag})')
        if not huni_list:
            # ★비대칭 케이스: 후니 대응 없음 → 연결 벤더 중 와우 단독
            print(f'    후니  (대응 상품 없음·GAP)')
            print(f'    와우  {wname:<16}{(f"{wbill:,}원" if wbill else "샘플없음"):>12}   [jobcost·{WOW_BASIS.get("channel","?")}·VAT={WOW_BASIS.get("vat_included","?")}·{wspec}]')
            print(f'    → ★와우 단독(연결 벤더 중 유일) — 이 니즈는 와우 강제(point1 연결-앵커·비대칭)')
            continue
        huni0 = huni_list[0]
        hprice = huni_price(huni0["prd_cd"], wqty) if wqty else None
        print(f'    후니  {huni0["name"]:<16}{(f"{hprice:,}원" if hprice else "견적불가"):>12}   [evaluate_price·{HUNI_BASIS.get("channel","?")}·VAT={HUNI_BASIS.get("vat_included","?")}]')
        print(f'    와우  {wname:<16}{(f"{wbill:,}원" if wbill else "샘플없음"):>12}   [jobcost·{WOW_BASIS.get("channel","?")}·VAT={WOW_BASIS.get("vat_included","?")}·{wspec}]')
        if v == "NO_GO":
            # A-5 게이트: 앵커 결함 → 크로스벤더 추천 제외(가격 비교 금지)
            print(f'    → ★A-5 NO-GO: {verdict.get("warn", "same_family_as 앵커 결함")}')
        elif hprice and wbill:
            if v == "DOWNGRADE":
                # A-5 게이트: 사양 상이 → 가격은 나란히 보이되 비교 경고 강제
                print(f'    → ★A-5 DOWNGRADE(사양 상이): {verdict.get("warn", "대표상품 구성 비대칭")}')
            ok, reason = basis_comparable(HUNI_BASIS, WOW_BASIS)
            if ok and v != "DOWNGRADE":
                cheaper = "후니" if hprice < wbill else "와우"
                print(f'    → 이 사양·수량 기준 저가 = {cheaper}  (basis 정합·A-5 GO)')
            elif not ok:
                print(f'    → ★순위 기권(A-1): basis 상이({reason}). 두 값은 서로 다른 기준 → 나이브 비교 금지.')
    print("\n" + "-" * 78)
    print(f"검증: 와우 {shown}개 상품군이 same_family_as로 후니와 교차 연결·양 벤더 엔진 실호출.")
    b_ok, b_reason = basis_comparable(HUNI_BASIS, WOW_BASIS)
    if b_ok:
        print("★basis 정합 → 순위 판정 활성(A-1).")
    else:
        print(f"★A-1 basis 상이({b_reason}) → 크로스벤더 순위 전면 기권. 채널·부가세 정합 데이터 확보 전엔 나란히만.")
        print("  해소 경로: 와우 ordcost_sup(VAT-excl) 재캡처 + 후니 VAT 확정(GAP-BASIS-1~3) → 부가세축 정합. 채널(도매/소매)은 동일채널 데이터 필요.")
    print("값=엔진(후니 evaluate_price·와우 jobcost)·지어내기 0 · 최종 추천=엔진(D-REC 경계).")
    return 0


if __name__ == "__main__":
    sys.exit(main())
