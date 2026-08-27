"""결함 S 드라이런 (SPEC-PRICEWIRE-001 M1 1-A) — 라이브 읽기전용·롤백격리.

교정 전(PRF_CLR_ACRYL) vs 교정 후(PRF_ACRYL_*) 최종가를 같은 evaluate_price 경로로
비교해, 차액이 부속 단가와 일치하는지 확인한다(progress.md §G'.3 절차 3).

바인딩 교체는 transaction.atomic + 강제 롤백으로 격리 — DB 에 아무것도 남지 않는다.
선례: raw/webadmin/tools/test_simulate_tiers.py("라이브 DB 읽기전용, 롤백격리").

실행: 프로젝트 루트에서
    raw/webadmin/.venv/bin/python _workspace/huni-widget-wiring/bin/dryrun_defect_s.py
"""
import os
import sys
from decimal import Decimal

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", ".."))
WEBADMIN = os.path.join(ROOT, "raw", "webadmin", "webadmin")
sys.path.insert(0, WEBADMIN)
os.environ.setdefault("DJANGO_SETTINGS_MODULE", "config.settings")

from dotenv import load_dotenv  # noqa: E402
load_dotenv(os.path.join(ROOT, "raw", "webadmin", ".env"))

import django  # noqa: E402
django.setup()

from django.db import transaction  # noqa: E402
from catalog import models as M  # noqa: E402
from catalog import pricing as P  # noqa: E402

# (상품, 현재공식, 교정후공식|None=대조군, 부속 구성요소)
# 대조군(CONTROL): M0-8 이 「정상」으로 판정한 형제 — 부속이 실제로 청구되는지 재검한다.
CASES = [
    ("PRD_000148", "PRF_CLR_ACRYL", "PRF_ACRYL_BADGE", "COMP_ACRYL_BADGE"),
    ("PRD_000150", "PRF_CLR_ACRYL", "PRF_ACRYL_SMARTTOK", "COMP_ACRYL_SMARTTOK"),
    ("PRD_000152", "PRF_CLR_ACRYL", "PRF_ACRYL_NAMETAG", "COMP_ACRYL_NAMETAG_PIN"),
    ("PRD_000147", "PRF_ACRYL_MAGNET", None, "COMP_ACRYL_MAGNET"),
    ("PRD_000149", "PRF_ACRYL_CLIP", None, "COMP_ACRYL_CLIP"),
    ("PRD_000154", "PRF_ACRYL_HAIRBAND", None, "COMP_ACRYL_BLACK_HAIR_BAND"),
    ("PRD_000146", "PRF_ACRYL_KEYRING", None, "COMP_ACRYL_KEYRING"),
]
QTYS = [100]


def comp_meta(comp_cd):
    return M.TPrcPriceComponents.objects.filter(comp_cd=comp_cd).values(
        "comp_nm", "prc_typ_cd", "use_dims").first() or {}


def acc_prices(comp_cd):
    return sorted(M.TPrcComponentPrices.objects.filter(comp_cd=comp_cd)
                  .values_list("unit_price", flat=True))


def live_options(prd_cd):
    """상품이 현재 제공하는(미삭제) 옵션값 — (opt_grp_cd, opt_cd, opt_nm)."""
    grps = {g for g in M.TPrdProductOptionGroups.objects
            .filter(prd_cd=prd_cd).exclude(del_yn="Y")
            .values_list("opt_grp_cd", flat=True)}
    return [(o["opt_grp_cd"], o["opt_cd"], o["opt_nm"])
            for o in M.TPrdProductOptions.objects
            .filter(prd_cd=prd_cd, opt_grp_cd__in=grps).exclude(del_yn="Y")
            .order_by("opt_grp_cd", "disp_seq")
            .values("opt_grp_cd", "opt_cd", "opt_nm")]


def build_selections(prd_cd):
    """CLEAR3T(use_dims=mat_cd·siz_width·siz_height·min_qty)가 매칭되도록 구성."""
    sizes = sorted({r for r in M.TPrdProductSizes.objects
                    .filter(prd_cd=prd_cd).exclude(del_yn="Y")
                    .values_list("siz_cd", flat=True) if r})
    if not sizes:
        return None, "상품 사이즈 옵션 없음"
    mats = sorted({r for r in M.TPrdProductMaterials.objects
                   .filter(prd_cd=prd_cd).exclude(del_yn="Y")
                   .values_list("mat_cd", flat=True) if r})
    # CLEAR3T 단가행에 실재하는 (mat_cd, w, h) 조합 중 상품 사이즈/자재와 교집합인 것 채택
    rows = list(M.TPrcComponentPrices.objects
                .filter(comp_cd="COMP_ACRYL_CLEAR3T")
                .values("mat_cd", "siz_width", "siz_height", "unit_price"))
    cand = [r for r in rows if (not mats or r["mat_cd"] in mats)]
    if not cand:
        cand = rows
    if not cand:
        return None, "CLEAR3T 단가행 없음"
    cand.sort(key=lambda r: (r["siz_width"] or 0) * (r["siz_height"] or 0))
    pick = cand[len(cand) // 2]  # 중간 크기 대표
    sel = {"siz_cd": sizes[0], "mat_cd": pick["mat_cd"],
           "siz_width": pick["siz_width"], "siz_height": pick["siz_height"]}
    return sel, None


def total_of(r):
    if not isinstance(r, dict):
        return None, None
    if r.get("final_price") is not None:
        return Decimal(str(r["final_price"])), "final_price"
    return None, f"keys={sorted(r)[:12]}"


def comp_lines(r):
    if not isinstance(r, dict):
        return []
    comps = (r.get("base") or {}).get("components") or []
    out = []
    for c in comps:
        out.append(f"{c.get('comp_cd')}={c.get('amount')}"
                   + (f" [{c.get('error') or c.get('note')}]"
                      if (c.get('error') or c.get('note')) else ""))
    return out


def all_warnings(r):
    if not isinstance(r, dict):
        return []
    return list((r.get("base") or {}).get("warnings") or []) + list(r.get("warnings") or [])


print("=" * 78)
print("결함 S 드라이런 — 교정 전/후 최종가 (라이브 읽기전용·롤백격리)")
print("=" * 78)

for prd_cd, cur_frm, new_frm, acc_comp in CASES:
    nm = M.TPrdProducts.objects.filter(prd_cd=prd_cd).values_list("prd_nm", flat=True).first()
    meta = comp_meta(acc_comp)
    print(f"\n## {prd_cd} {nm}")
    print(f"   {cur_frm} -> {new_frm}")
    print(f"   부속 {acc_comp} '{meta.get('comp_nm')}' prc_typ={meta.get('prc_typ_cd')} "
          f"use_dims={meta.get('use_dims')} 단가={[str(x) for x in acc_prices(acc_comp)]}")

    base_sel, err = build_selections(prd_cd)
    if err:
        print(f"   [WARN] 선택값 구성 실패: {err}")
        continue

    opts = live_options(prd_cd)
    print(f"   라이브 옵션(미삭제): {[(g, o, n) for g, o, n in opts] or '없음'}")
    # 옵션 미선택 + 옵션값별 각각 평가
    variants = [("(옵션없음)", dict(base_sel))]
    for _g, ocd, onm in opts:
        v = dict(base_sel)
        v["opt_cd"] = ocd
        variants.append((f"{ocd} {onm}", v))

    for label, sel in variants:
        for qty in QTYS:
            before = P.evaluate_price({"prd_cd": prd_cd}, dict(sel), qty, mode="lenient")
            b_tot, bkey = total_of(before)

            after = None
            if new_frm:
                try:
                    with transaction.atomic():
                        M.TPrdProductPriceFormulas.objects.filter(prd_cd=prd_cd).delete()
                        M.TPrdProductPriceFormulas.objects.create(
                            prd_cd_id=prd_cd, frm_cd_id=new_frm,
                            apply_bgn_ymd="2026-06-28", note="[DRYRUN-ROLLBACK]")
                        after = P.evaluate_price({"prd_cd": prd_cd}, dict(sel), qty,
                                                 mode="lenient")
                        raise RuntimeError("__ROLLBACK__")
                except RuntimeError as e:
                    if str(e) != "__ROLLBACK__":
                        raise
            a_tot, _ = total_of(after)
            diff = (a_tot - b_tot) if (a_tot is not None and b_tot is not None) else None
            print(f"   [{label}] qty={qty}  전={b_tot}  후={a_tot}  차액={diff}  ({bkey})")
            print(f"        전 구성: {comp_lines(before)}")
            if after is not None:
                print(f"        후 구성: {comp_lines(after)}")
            for tag, r in (("전", before), ("후", after)):
                if isinstance(r, dict) and r.get("errors"):
                    print(f"        {tag} errors: {r['errors'][:2]}")
                w = all_warnings(r)
                if w:
                    print(f"        {tag} warn: {w[:2]}")

print("\n" + "=" * 78)
print("롤백 검증 — 현재 바인딩이 원래대로인지 (라이브 재조회):")
ok_all = True
for prd_cd, cur_frm, _n, _a in CASES:
    rows = list(M.TPrdProductPriceFormulas.objects.filter(prd_cd=prd_cd)
                .values_list("frm_cd", "apply_bgn_ymd", "note"))
    ok = len(rows) == 1 and rows[0][0] == cur_frm
    ok_all = ok_all and ok
    print(f"  {prd_cd}: {rows}  {'OK' if ok else '*** MISMATCH ***'}")
print("ROLLBACK_VERIFY:", "PASS" if ok_all else "FAIL")
