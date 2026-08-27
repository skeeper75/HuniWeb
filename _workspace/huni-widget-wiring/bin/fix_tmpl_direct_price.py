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

# ── 2차 배치 (지니 지시: 인쇄상품 가격표 전 시트를 확인해 값을 넣을 것) ──────
# 1차 배치 15종(트레싱지봉투 8·천정고리·우드봉 3·우드행거 3)은 M1-1H 에서 적재 완료.
# 중복 INSERT 를 막기 위해 SPEC 에서 제외한다.
# tmpl_cd: (단가, 권위 근거)
SPEC = {
    # 린넨우드봉족자 — 가격표 poster-sign B20/B21 (본체 「출력+가공(봉미싱) 포함가」
    # + 「추가옵션(우드봉+면끈) 추가가격」). 템플릿명이 "우드봉+면끈 포함" = 완제품가.
    "TMPL-000097": (13000, "가격표 poster-sign B225 A4 본체 6,000 + M226-K 우드봉+면끈 7,000"),
    "TMPL-000098": (18000, "가격표 poster-sign C225 A3 본체 8,200 + L226 우드봉+면끈 9,800"),
    "TMPL-000099": (28000, "가격표 poster-sign D225 A2 본체 16,000 + M226 우드봉+면끈 12,000"),
    # 워터북보틀 — 상품마스터 굿즈 시트(가격표에 굿즈 단가 시트가 없다)
    "TMPL-000100": (9300,  "상품마스터 goods-pouch row24 워터북보틀 500ml 9,300"),
    "TMPL-000101": (9000,  "상품마스터 goods-pouch row23 워터북보틀 350ml 9,000"),
    # 규조토코스터 — 폴백이 이미 5,000 을 내지만 권위와 일치. 직접단가로 고정한다.
    "TMPL-000102": (5000,  "상품마스터 goods-pouch row19 규조토코스터 사각 100mm 5,000"),
    "TMPL-000103": (5000,  "상품마스터 goods-pouch row18 규조토코스터 원형 102mm 5,000"),
    # 폼보드 — 가격표 poster-sign A188~D191 「출력+코팅+가공 포함가」
    "TMPL-000104": (12000, "가격표 poster-sign C190 폼보드 A2 화이트보드 12,000"),
    "TMPL-000105": (14000, "가격표 poster-sign C191 폼보드 A2 블랙보드 14,000"),
    "TMPL-000106": (7000,  "가격표 poster-sign B190 폼보드 A3 화이트보드 7,000"),
    "TMPL-000107": (8500,  "가격표 poster-sign B191 폼보드 A3 블랙보드 8,500"),
}

# 부류 C — 권위 전 시트를 뒤져도 단가 근거가 없다(추정 금지).
HELD = {
    "TMPL-000010/011": "카드봉투(화이트/블랙) 165x115mm **50장** — 권위 전 시트 검색 결과 "
                       "「카드봉투(화이트/블랙) 165x115 mm **10장**」(1,000/1,500)만 존재. "
                       "50장 단가 근거 없음. base PRD_000281/282 도 공식 0·자재 0",
    "TMPL-000092": "아크릴거치대 — 권위 상품악세사리에 「**우드**거치대 4,000」만 있고 "
                   "아크릴거치대 항목 없음. 자재 MAT_000616 단가행도 0, "
                   "base PRD_000309 공식 0 ⇒ 권위·라이브 어디에도 단가 없음",
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
