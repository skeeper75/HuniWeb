"""가격구성요소 정리 P1(폐기세대 참조 교정) + P2(축 이전 완료분 분리).

지니 지시(2026-08-27): 「가격구성요소에 들어가 있는 직접단가 관련 부분을 정리해서
가격구성요소·가격공식·가격뷰어를 확실하게 정리」 → M1-1K §E 의 P1+P2 배치.

P1 — 단가행 opt_cd 와 use_dims 의 opt_grp 를 실무진 등록 현행 세대로 재배선.
P2 — 추가상품 템플릿으로 이전 완료된 구성요소를 공식에서 분리(물리 DELETE).
     t_prc_formula_components 에는 del_yn 컬럼이 없어 논리삭제가 불가하다.
     구성요소(t_prc_price_components) 자체는 남으므로 복구는 INSERT 로 가능.

기본 모드는 DRY-RUN(강제 롤백). 적재는 --commit + 인간 승인.

실행: raw/webadmin/.venv/bin/python _workspace/huni-widget-wiring/bin/fix_comp_cleanup_p1p2.py
"""
import os
import sys
from decimal import Decimal

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", ".."))
sys.path.insert(0, os.path.join(ROOT, "raw", "webadmin", "webadmin"))
os.environ.setdefault("DJANGO_SETTINGS_MODULE", "config.settings")

from dotenv import load_dotenv  # noqa: E402
load_dotenv(os.path.join(ROOT, "raw", "webadmin", ".env"))

import django  # noqa: E402
django.setup()

from django.db import transaction  # noqa: E402
from catalog import models as M  # noqa: E402
from catalog import pricing as P  # noqa: E402

COMMIT = "--commit" in sys.argv

# ── P1: 폐기 세대 참조 교정 ──────────────────────────────────────────────────
P1 = {
    "COMP_ACRYL_CLIP": {
        "prd": "PRD_000149", "grp_old": "OPT_000076", "grp_new": "OPT_000297",
        "opt": {"OPV_000468": ("OPV_001023", "투명집게(일반형)",
                               "권위 아크릴 B68/C68 투명집게 700")},
        "bind": None,
    },
    "COMP_ACRYL_SMARTTOK": {
        "prd": "PRD_000150", "grp_old": "OPT_000077", "grp_new": "OPT_000270",
        "opt": {"OPV_000469": ("OPV_000966", "화이트", "권위 아크릴 B71/C71 화이트바디 2,600"),
                "OPV_000470": ("OPV_000967", "투명", "권위 아크릴 B72/C72 투명바디 3,000")},
        "bind": ("PRF_CLR_ACRYL", "PRF_ACRYL_SMARTTOK"),
    },
}

# ── P2: 축 이전 완료분을 공식에서 분리 ──────────────────────────────────────
P2 = [
    ("PRF_POSTER_JOKJA", "COMP_POSTEROPT_JOKJA_CEILHOOK",
     "천정고리는 PRD_000135 의 추가상품(t_prd_product_addons → TMPL-000096)이며 "
     "직접단가 6,500 이 M1-1H 에서 등록 완료. 가격구성요소 축과 중복이므로 분리."),
]

HELD = {
    "COMP_PCB (PRD_000094 엽서북)": "옵션그룹 9개 전멸(페이지수·사이즈·내지·표지·제본·"
                                    "셋트구성) — 재배선 대상이 아니라 실무진 옵션 재등록 사안",
    "OPV_001024 투명집게(자석형)": "권위 아크릴 시트에 「자석형」 문자열 부재. 단가 근거 없음",
    "PRD_000024 포토카드": "opt_cd 차원 제거 건(M1-1F §C) — 성격이 달라 별도 배치",
}


def live_opts(prd_cd):
    grps = set(M.TPrdProductOptionGroups.objects.filter(prd_cd=prd_cd)
               .exclude(del_yn="Y").values_list("opt_grp_cd", flat=True))
    return [(o["opt_cd"], o["opt_nm"]) for o in M.TPrdProductOptions.objects
            .filter(prd_cd=prd_cd, opt_grp_cd__in=grps).exclude(del_yn="Y")
            .order_by("opt_grp_cd", "disp_seq").values("opt_cd", "opt_nm")]


def base_sel(prd_cd):
    sel = {}
    sizes = sorted({s for s in M.TPrdProductSizes.objects.filter(prd_cd=prd_cd)
                    .exclude(del_yn="Y").values_list("siz_cd", flat=True) if s})
    if sizes:
        sel["siz_cd"] = sizes[0]
    mats = sorted({m for m in M.TPrdProductMaterials.objects.filter(prd_cd=prd_cd)
                   .exclude(del_yn="Y").values_list("mat_cd", flat=True) if m})
    if mats:
        sel["mat_cd"] = mats[0]
    rows = list(M.TPrcComponentPrices.objects.filter(comp_cd="COMP_ACRYL_CLEAR3T")
                .values("mat_cd", "siz_width", "siz_height"))
    cand = [r for r in rows if (not mats or r["mat_cd"] in mats)] or rows
    if cand:
        cand.sort(key=lambda r: (r["siz_width"] or 0) * (r["siz_height"] or 0))
        pick = cand[len(cand) // 2]
        sel.update(mat_cd=pick["mat_cd"], siz_width=pick["siz_width"],
                   siz_height=pick["siz_height"])
    return sel


def measure(prd_cd, qty=100):
    sel0 = base_sel(prd_cd)
    out = []
    for ocd, onm in live_opts(prd_cd):
        s = dict(sel0)
        s["opt_cd"] = ocd
        r = P.evaluate_price({"prd_cd": prd_cd}, s, qty, mode="lenient")
        out.append((ocd, onm, r.get("final_price")))
    return out


def apply_all():
    log = []
    for comp_cd, plan in P1.items():
        for old, (new, nm, why) in plan["opt"].items():
            n = M.TPrcComponentPrices.objects.filter(comp_cd=comp_cd, opt_cd=old) \
                .update(opt_cd=new)
            log.append(f"[P1] UPDATE t_prc_component_prices SET opt_cd='{new}' "
                       f"WHERE comp_cd='{comp_cd}' AND opt_cd='{old}';  -- {nm}, {n}행 · {why}")
        pc = M.TPrcPriceComponents.objects.filter(comp_cd=comp_cd).first()
        if pc and pc.use_dims:
            ud = [f"opt_grp:{plan['grp_new']}" if str(d) == f"opt_grp:{plan['grp_old']}" else d
                  for d in pc.use_dims]
            if ud != pc.use_dims:
                pc.use_dims = ud
                pc.save(update_fields=["use_dims"])
                log.append(f"[P1] UPDATE t_prc_price_components SET use_dims='{ud}' "
                           f"WHERE comp_cd='{comp_cd}';")
        if plan["bind"]:
            old_frm, new_frm = plan["bind"]
            prd = plan["prd"]
            row = M.TPrdProductPriceFormulas.objects.filter(prd_cd=prd, frm_cd=old_frm).first()
            ymd = row.apply_bgn_ymd if row else "2026-06-28"
            M.TPrdProductPriceFormulas.objects.filter(prd_cd=prd).delete()
            M.TPrdProductPriceFormulas.objects.create(
                prd_cd_id=prd, frm_cd_id=new_frm, apply_bgn_ymd=ymd,
                note="부속 포함 공식 (세대 재배선 교정)")
            log.append(f"[P1] 바인딩 교체 {prd}: {old_frm} → {new_frm} (apply_bgn_ymd={ymd})")
    for frm_cd, comp_cd, why in P2:
        n, _ = M.TPrcFormulaComponents.objects.filter(frm_cd=frm_cd, comp_cd=comp_cd).delete()
        log.append(f"[P2] DELETE FROM t_prc_formula_components "
                   f"WHERE frm_cd='{frm_cd}' AND comp_cd='{comp_cd}';  -- {n}행 · {why}")
    return log


print("=" * 88)
print(f"가격구성요소 정리 P1+P2 — {'★ COMMIT 모드 ★' if COMMIT else 'DRY-RUN (강제 롤백)'}")
print("=" * 88)

targets = sorted({p["prd"] for p in P1.values()} | {"PRD_000135"})
before = {p: measure(p) for p in targets}

log = []
after = {}
try:
    with transaction.atomic():
        log = apply_all()
        after = {p: measure(p) for p in targets}
        if not COMMIT:
            raise RuntimeError("__ROLLBACK__")
except RuntimeError as e:
    if str(e) != "__ROLLBACK__":
        raise

for prd in targets:
    nm = M.TPrdProducts.objects.filter(prd_cd=prd).values_list("prd_nm", flat=True).first()
    print(f"\n## {prd} {nm}  (qty=100)")
    bmap = {o: f for o, _n, f in before[prd]}
    for ocd, onm, fa in after.get(prd, []):
        fb = bmap.get(ocd)
        d = (Decimal(str(fa)) - Decimal(str(fb))) if (fa is not None and fb is not None) else None
        mark = "  ← 변화" if d else ""
        print(f"   [{ocd} {onm}] 전={fb} → 후={fa}  (차액 {d}){mark}")

print("\n" + "=" * 88)
print("실행 내역")
for s in log:
    print("  " + s)

print("\n" + "=" * 88)
print("보류 (이번 배치 제외)")
for k, v in HELD.items():
    print(f"  · {k}: {v}")

print("\n" + "=" * 88)
if COMMIT:
    print("★ COMMIT 완료 — 가격시뮬레이터 실화면 확인이 남았다.")
else:
    ok = True
    for comp_cd, plan in P1.items():
        for old, (new, _nm, _w) in plan["opt"].items():
            a = M.TPrcComponentPrices.objects.filter(comp_cd=comp_cd, opt_cd=old).count()
            b = M.TPrcComponentPrices.objects.filter(comp_cd=comp_cd, opt_cd=new).count()
            good = a > 0 and b == 0
            ok = ok and good
            print(f"  {comp_cd} {old}={a} {new}={b} {'OK' if good else '*** 미복구 ***'}")
    n = M.TPrcFormulaComponents.objects.filter(
        frm_cd="PRF_POSTER_JOKJA", comp_cd="COMP_POSTEROPT_JOKJA_CEILHOOK").count()
    print(f"  PRF_POSTER_JOKJA×CEILHOOK 잔존={n} {'OK' if n == 1 else '*** 미복구 ***'}")
    ok = ok and n == 1
    print("ROLLBACK_VERIFY:", "PASS" if ok else "FAIL")
