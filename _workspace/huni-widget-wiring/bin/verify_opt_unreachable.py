"""SQL 스캔이 지목한 opt_cd 도달불가 후보를 가격엔진으로 확증 (읽기전용).

SQL 패턴 추론은 가설이다(verification-claim-integrity §1.1 surface 3). 도메인 전용
도구(evaluate_price)로 각 후보 상품의 실제 견적을 뽑아, 지목된 구성요소가 정말
금액을 못 받는지 확인한다. DB 쓰기 없음.

실행: raw/webadmin/.venv/bin/python _workspace/huni-widget-wiring/bin/verify_opt_unreachable.py
"""
import os
import sys

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", ".."))
sys.path.insert(0, os.path.join(ROOT, "raw", "webadmin", "webadmin"))
os.environ.setdefault("DJANGO_SETTINGS_MODULE", "config.settings")

from dotenv import load_dotenv  # noqa: E402
load_dotenv(os.path.join(ROOT, "raw", "webadmin", ".env"))

import django  # noqa: E402
django.setup()

from catalog import models as M  # noqa: E402
from catalog import pricing as P  # noqa: E402

# SQL 스캔 결과 DEFECT 후보 (prd_cd, comp_cd)
CANDIDATES = [
    ("PRD_000024", "COMP_PHOTOCARD_BULK"),
    ("PRD_000024", "COMP_PHOTOCARD_SET"),
    ("PRD_000037", "COMP_NAMECARD_FOIL"),
    ("PRD_000094", "COMP_PCB"),
    ("PRD_000133", "COMP_POSTEROPT_CANVAS_HANGING_WOODHANGER"),
    ("PRD_000134", "COMP_POSTEROPT_LINEN_WOODBONG_WOODBONG"),
    ("PRD_000135", "COMP_POSTEROPT_JOKJA_CEILHOOK"),
    ("PRD_000147", "COMP_ACRYL_MAGNET"),
    ("PRD_000149", "COMP_ACRYL_CLIP"),
    ("PRD_000156", "COMP_ACRYL_ZIBITZ"),
]
QTY = 100


def live_options(prd_cd):
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
    return sel


def comp_entry(res, comp_cd):
    for c in ((res or {}).get("base") or {}).get("components") or []:
        if c.get("comp_cd") == comp_cd:
            return c
    return None


print("=" * 78)
print("opt_cd 도달불가 후보 — 가격엔진 확증 (읽기전용, qty=%d)" % QTY)
print("=" * 78)

verdicts = []
for prd_cd, comp_cd in CANDIDATES:
    nm = M.TPrdProducts.objects.filter(prd_cd=prd_cd).values_list("prd_nm", flat=True).first()
    sel0 = base_sel(prd_cd)
    opts = live_options(prd_cd)
    print(f"\n## {prd_cd} {nm} / {comp_cd}")
    print(f"   기본 선택값={sel0}  라이브 옵션 {len(opts)}개")

    charged = False
    detail = []
    trials = [("(옵션없음)", dict(sel0))]
    for ocd, onm in opts:
        s = dict(sel0)
        s["opt_cd"] = ocd
        trials.append((f"{ocd} {onm}", s))

    for label, s in trials:
        res = P.evaluate_price({"prd_cd": prd_cd}, dict(s), QTY, mode="lenient")
        ce = comp_entry(res, comp_cd)
        amt = ce.get("amount") if ce else None
        err = (ce or {}).get("error") or (ce or {}).get("note")
        if amt not in (None, 0, "0"):
            charged = True
        detail.append((label, res.get("final_price"), amt, err))

    for label, fp, amt, err in detail[:6]:
        print(f"   [{label}] final={fp} / {comp_cd}={amt}"
              + (f" [{err}]" if err else ""))
    if len(detail) > 6:
        print(f"   … 외 {len(detail)-6}개 옵션 동일 패턴")

    v = "REFUTED(청구됨)" if charged else "CONFIRMED(미청구)"
    verdicts.append((prd_cd, nm, comp_cd, v))
    print(f"   >>> {v}")

print("\n" + "=" * 78)
print("판정 종합")
for prd_cd, nm, comp_cd, v in verdicts:
    print(f"  {v:<20} {prd_cd} {nm} / {comp_cd}")
n_c = sum(1 for *_x, v in verdicts if v.startswith("CONFIRMED"))
print(f"\nCONFIRMED={n_c} / REFUTED={len(verdicts)-n_c} / TOTAL={len(verdicts)}")
