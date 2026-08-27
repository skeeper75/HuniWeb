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

# 부류 A — 규격 부속품. 권위 상품악세사리 시트에 개당 단가가 실재한다.
# tmpl_cd: (단가, 권위 근거)
SPEC = {
    # 트레싱지 카드봉투 8종
    "TMPL-000009": (6000,  "권위 상품악세사리 row25 트래싱지 카드봉투 160x110mm(20장) 6,000"),
    "TMPL-000031": (12000, "권위 상품악세사리 row26 트래싱지 카드봉투 160x110mm(40장) 12,000"),
    "TMPL-000032": (28000, "권위 상품악세사리 row27 트래싱지 카드봉투 160x110mm(100장) 28,000"),
    "TMPL-000035": (6800,  "권위 상품악세사리 row28 트래싱지 카드봉투 100x100mm(20장) 6,800"),
    "TMPL-000036": (13600, "권위 상품악세사리 row29 트래싱지 카드봉투 100x100mm(40장) 13,600"),
    "TMPL-000037": (32000, "권위 상품악세사리 row30 트래싱지 카드봉투 100x100mm(100장) 32,000"),
    "TMPL-000033": (3600,  "권위 상품악세사리 row31 트래싱지 카드봉투 70x100mm(30장) 3,600"),
    "TMPL-000034": (10000, "권위 상품악세사리 row32 트래싱지 카드봉투 70x100mm(100장) 10,000"),
    # 천정고리
    "TMPL-000096": (6500,  "권위 상품악세사리 row48 천정고리 「2개1세트」 6,500"),
    # 우드봉 3종 (권위 사이즈 문면 "+ 면끈")
    "TMPL-000108": (7000,  "권위 상품악세사리 row57 우드봉 270mm + 면끈 7,000"),
    "TMPL-000109": (9800,  "권위 상품악세사리 row58 우드봉 360mm + 면끈 9,800"),
    "TMPL-000110": (12000, "권위 상품악세사리 row59 우드봉 480mm + 면끈 12,000"),
    # 우드행거 3종
    "TMPL-000111": (16000, "권위 상품악세사리 row60 우드행거 230mm + 면끈 16,000"),
    "TMPL-000112": (18000, "권위 상품악세사리 row61 우드행거 320mm + 면끈 18,000"),
    "TMPL-000113": (20000, "권위 상품악세사리 row62 우드행거 440mm + 면끈 20,000"),
}

# 부류 B — 상품 자체를 템플릿화한 것. 사이즈별 매트릭스 가격이라 단일 직접단가로
# 환산할 수 없다. 구조상 「상품 가격소스로 계산」이 맞으며, 그 폴백이 실패하는
# 원인 규명이 교정 방향이다(규조토코스터 2종은 같은 구조에서 폴백이 작동한다).
# 부류 C — 권위 근거 자체가 없다.
HELD = {
    "TMPL-000097/098/099": "[B] 린넨우드봉족자 A4/A3/A2 — base=PRD_000134 상품 자체. "
                           "권위는 포스터사인 시트의 면적 매트릭스(사이즈별)라 단일 단가 불가",
    "TMPL-000100/101": "[B] 워터북보틀 500ml/350ml — base=PRD_000194 상품 자체(굿즈 시트)",
    "TMPL-000104~107": "[B] 폼보드 A2/A3 화이트·블랙 — base=PRD_000129 상품 자체. "
                       "권위 price-poster-sign B172~D176 가로×세로 매트릭스",
    "TMPL-000010/011": "[C] 카드봉투(화이트/블랙) 165x115mm **50장** — 권위 row33/34 는 "
                       "**10장** 1,000/1,500 뿐. 50장 단가 근거 없음",
    "TMPL-000092": "[C] 아크릴거치대 — 권위에 「우드거치대 120mm 4,000」만 있고 "
                   "아크릴거치대 항목 없음(추정 금지)",
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
