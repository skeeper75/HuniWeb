"""추가상품 템플릿 직접단가 등록 — 드라이런 증명 + (승인 시) 적재.

구조(지니 설명 2026-08-27):
  · 가격구성요소(t_prc_price_components) = 그 상품의 추가상품이 **아닌** 것 = 본체 구성
  · 추가상품 템플릿(t_prd_templates)      = 각 상품에 **끼워파는** 것 = 상품 간 공유
    → 가격은 가격뷰어 「추가상품 템플릿 직접단가」(t_prd_template_prices)에 등록한다.
      화면 문구: "템플릿 전용 — 상품 가격소스와 별개, 추가상품 템플릿 계산 시 최우선"
      미등록이면 "없음 → 상품 가격소스로 계산"인데, base 상품에 공식/고정가가 없으면
      계산할 소스가 없어 0원이 된다 = 돈 손실.

기본 모드는 DRY-RUN(강제 롤백). 적재는 --commit + 인간 승인.

실행: raw/webadmin/.venv/bin/python _workspace/huni-widget-wiring/bin/fix_tmpl_direct_price.py
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
APPLY_YMD = "2026-08-27"

# tmpl_cd: (단가, 권위 근거)
SPEC = {
    "TMPL-000096": (6500,  "권위 상품악세사리 row48 천정고리 「2개1세트」 6,500"),
    "TMPL-000009": (6000,  "권위 상품악세사리 row25 트래싱지 카드봉투 160x110mm(20장) 6,000"),
    "TMPL-000032": (28000, "권위 상품악세사리 row27 트래싱지 카드봉투 160x110mm(100장) 28,000"),
    "TMPL-000033": (3600,  "권위 상품악세사리 row31 트래싱지 카드봉투 70x100mm(30장) 3,600"),
    "TMPL-000034": (10000, "권위 상품악세사리 row32 트래싱지 카드봉투 70x100mm(100장) 10,000"),
}
HELD = {
    "TMPL-000092": "아크릴거치대 — 권위 상품악세사리에 「우드거치대 4,000」만 있고 "
                   "아크릴거치대 항목이 없다. 단가 근거 없음(추정 금지).",
}


def tmpl_price(tmpl_cd, qty=1):
    r = P.evaluate_price({"tmpl_cd": tmpl_cd}, {}, qty, mode="lenient")
    return r.get("final_price"), (r.get("errors") or [])[:1], (r.get("warnings") or [])[:1]


def info(tmpl_cd):
    t = M.TPrdTemplates.objects.filter(tmpl_cd=tmpl_cd).values(
        "tmpl_nm", "base_prd_cd", "dflt_qty").first() or {}
    base = t.get("base_prd_cd")
    b = M.TPrdProducts.objects.filter(prd_cd=base).values("prd_nm", "use_yn").first() or {}
    nfrm = M.TPrdProductPriceFormulas.objects.filter(prd_cd=base).count() if base else 0
    users = list(M.TPrdProductAddons.objects.filter(tmpl_cd=tmpl_cd)
                 .values_list("prd_cd", flat=True))
    return t, base, b, nfrm, users


print("=" * 88)
print(f"추가상품 템플릿 직접단가 — {'★ COMMIT 모드 ★' if COMMIT else 'DRY-RUN (강제 롤백)'}")
print("=" * 88)

before = {t: tmpl_price(t) for t in SPEC}

after = {}
sqls = []
try:
    with transaction.atomic():
        for tmpl_cd, (price, why) in SPEC.items():
            M.TPrdTemplatePrices.objects.create(
                tmpl_cd_id=tmpl_cd, apply_ymd=APPLY_YMD, unit_price=Decimal(price),
                note="권위 상품악세사리 시트 기준 직접단가 등록")
            sqls.append(
                f"INSERT INTO t_prd_template_prices(tmpl_cd,apply_ymd,unit_price,note) "
                f"VALUES('{tmpl_cd}','{APPLY_YMD}',{price},"
                f"'권위 상품악세사리 시트 기준 직접단가 등록');  -- {why}")
        after = {t: tmpl_price(t) for t in SPEC}
        if not COMMIT:
            raise RuntimeError("__ROLLBACK__")
except RuntimeError as e:
    if str(e) != "__ROLLBACK__":
        raise

for tmpl_cd, (price, why) in SPEC.items():
    t, base, b, nfrm, users = info(tmpl_cd)
    fb, eb, wb = before[tmpl_cd]
    fa, ea, wa = after.get(tmpl_cd, (None, [], []))
    print(f"\n## {tmpl_cd} {t.get('tmpl_nm')}")
    print(f"   base={base} {b.get('prd_nm')} use_yn={b.get('use_yn')} 공식={nfrm}개 "
          f"· 쓰는 상품 {users}")
    print(f"   전={fb}  →  후={fa}   (등록 단가 {price:,})")
    print(f"   근거: {why}")
    if eb:
        print(f"        전 errors: {eb}")
    if wb:
        print(f"        전 warn: {wb}")

print("\n" + "=" * 88)
print("적재 SQL")
for s in sqls:
    print("  " + s)

print("\n" + "=" * 88)
print("보류 (권위 근거 부족 — 추정 금지)")
for k, v in HELD.items():
    print(f"  · {k}: {v}")

print("\n" + "=" * 88)
if COMMIT:
    print("★ COMMIT 완료 — 가격뷰어 실화면 확인이 남았다.")
else:
    n = M.TPrdTemplatePrices.objects.filter(tmpl_cd__in=list(SPEC)).count()
    print(f"DRY-RUN 종료 — 라이브 무변경. 롤백 검증: 대상 템플릿 직접단가 행수 = {n} "
          f"({'PASS' if n == 0 else '*** 잔존 ***'})")
