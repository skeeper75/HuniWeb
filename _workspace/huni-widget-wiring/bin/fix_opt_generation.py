"""세대 어긋남 재배선 — 교정 명세 생성 + 롤백격리 증명 + (승인 시) 적재.

결함: 가격구성요소 단가행의 opt_cd 와 use_dims 의 opt_grp: 가 폐기된 옵션 세대를
가리켜, 상품이 제공하는 현행 옵션과 영구 no-match → 해당 금액이 청구되지 않는다.

교정: 단가행 opt_cd 와 구성요소 use_dims 의 opt_grp: 를 현행 세대로 재배선한다.
단가 **값**은 건드리지 않는다(권위와 이미 일치 — progress.md §E.2 M1-1B B).

기본 모드는 DRY-RUN(트랜잭션 강제 롤백). 실제 적재는 --commit 명시 + 인간 승인.

실행:
  드라이런: raw/webadmin/.venv/bin/python _workspace/huni-widget-wiring/bin/fix_opt_generation.py
  적재:     … fix_opt_generation.py --commit
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

# ── 교정 명세 ───────────────────────────────────────────────────────────────
# comp_cd: {
#   "prd": 대상 상품, "grp_old" -> "grp_new": use_dims 의 opt_grp: 갱신,
#   "opt": {구세대 opt_cd: (현행 opt_cd, 옵션명, 권위근거)},
#   "bind": (기존 공식, 교정 공식) — S-1 유형만. None 이면 바인딩 변경 없음.
# }
SPEC = {
    "COMP_ACRYL_MAGNET": {
        "prd": "PRD_000147", "grp_old": "OPT_000074", "grp_new": "OPT_000295",
        "opt": {"OPV_000465": ("OPV_001020", "네오디움자석", "권위 B67/C67 네오디움자석(12mm) 800")},
        "bind": None,
    },
    "COMP_ACRYL_BADGE": {
        "prd": "PRD_000148", "grp_old": "OPT_000075", "grp_new": "OPT_000296",
        "opt": {"OPV_000466": ("OPV_001021", "원형핀", "권위 B65/C65 원형핀(20mm) 600"),
                "OPV_000467": ("OPV_001022", "1구자석", "권위 B66/C66 1구자석 1000")},
        "bind": ("PRF_CLR_ACRYL", "PRF_ACRYL_BADGE"),
    },
    "COMP_ACRYL_NAMETAG_PIN": {
        "prd": "PRD_000152", "grp_old": "OPT_000078", "grp_new": "OPT_000298",
        "opt": {"OPV_000471": ("OPV_001025", "일자핀", "권위 B69/C69 일자핀 700"),
                "OPV_000472": ("OPV_001026", "2구자석", "권위 B70/C70 2구자석 1700")},
        "bind": ("PRF_CLR_ACRYL", "PRF_ACRYL_NAMETAG"),
    },
    "COMP_ACRYL_ZIBITZ": {
        "prd": "PRD_000156", "grp_old": "OPT_000083", "grp_new": "OPT_000300",
        "opt": {"OPV_000493": ("OPV_001029", "투명", "권위 B73/C73 투명 200"),
                "OPV_000494": ("OPV_001030", "스핀", "권위 B74/C74 스핀 600")},
        "bind": None,
    },
    "COMP_POSTEROPT_CANVAS_HANGING_WOODHANGER": {
        "prd": "PRD_000133", "grp_old": "OPT_000012", "grp_new": "OPT_000283",
        "opt": {"OPV_000429": ("OPV_000995", "우드행거+면끈 포함",
                               "권위 포스터사인 '우드행거+면끈) 추가가격'")},
        "bind": None,
    },
    "COMP_POSTEROPT_LINEN_WOODBONG_WOODBONG": {
        "prd": "PRD_000134", "grp_old": "OPT_000014", "grp_new": "OPT_000266",
        "opt": {"OPV_000430": ("OPV_000953", "우드봉+면끈 포함",
                               "권위 포스터사인 '우드봉족자 추가옵션(우드봉+면끈) 추가가격'")},
        "bind": None,
    },
}

# 보류 (추정 금지 — 권위 근거 부족)
HELD = {
    "PRD_000135": "천장고리(COMP_POSTEROPT_JOKJA_CEILHOOK 6,500)에 대응하는 현행 옵션그룹이 "
                  "없음 — 현행 OPT_000268 은 사각/원형족자(형상)이라 축이 다르다",
    "PRD_000150": "COMP_ACRYL_SMARTTOK 2,600/3,000 ↔ 현행 OPT_000270 화이트/투명은 색상 계열. "
                  "권위는 화이트바디/투명바디(가공 계열) — 같은 축인지 미확정",
    "PRD_000149": "COMP_ACRYL_CLIP 700 1행 ↔ 현행 옵션 2개(일반형/자석형). 권위에 '자석형' "
                  "부재 — 일반형만 배선할지, 자석형 단가를 신설할지 미확정",
    "PRD_000024": "옵션그룹 6개 전멸 + 본체 단가가 opt_cd 요구 → 재배선이 아니라 옵션 복원 필요",
    "PRD_000094": "옵션그룹 9개 전멸 — 위와 동일",
}


def opts_of(comp_cd):
    return list(M.TPrcComponentPrices.objects.filter(comp_cd=comp_cd)
                .values("comp_price_id", "opt_cd", "unit_price", "siz_cd"))


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
    return sel


def comp_amount(res, comp_cd):
    for c in ((res or {}).get("base") or {}).get("components") or []:
        if c.get("comp_cd") == comp_cd:
            return c.get("amount"), (c.get("error") or c.get("note"))
    return None, None


def measure(comp_cd, plan, qty=100):
    """상품의 현행 옵션 각각으로 견적 → (옵션, final, comp금액, 사유)."""
    prd = plan["prd"]
    sel0 = base_sel(prd)
    out = []
    for ocd, onm in live_opts(prd):
        s = dict(sel0)
        s["opt_cd"] = ocd
        r = P.evaluate_price({"prd_cd": prd}, s, qty, mode="lenient")
        amt, err = comp_amount(r, comp_cd)
        out.append((ocd, onm, r.get("final_price"), amt, err))
    return out


def apply_spec():
    """교정 적용 — 호출자가 트랜잭션을 관리한다. 반환: 실행된 SQL 서술 목록."""
    done = []
    for comp_cd, plan in SPEC.items():
        # 1) 단가행 opt_cd 재배선
        for old, (new, nm, _why) in plan["opt"].items():
            n = M.TPrcComponentPrices.objects.filter(comp_cd=comp_cd, opt_cd=old) \
                .update(opt_cd=new)
            done.append(f"UPDATE t_prc_component_prices SET opt_cd='{new}' "
                        f"WHERE comp_cd='{comp_cd}' AND opt_cd='{old}';  -- {nm}, {n}행")
        # 2) use_dims 의 opt_grp: 갱신
        pc = M.TPrcPriceComponents.objects.filter(comp_cd=comp_cd).first()
        if pc and pc.use_dims:
            ud = [f"opt_grp:{plan['grp_new']}" if str(d) == f"opt_grp:{plan['grp_old']}" else d
                  for d in pc.use_dims]
            if ud != pc.use_dims:
                pc.use_dims = ud
                pc.save(update_fields=["use_dims"])
                done.append(f"UPDATE t_prc_price_components SET use_dims='{ud}' "
                            f"WHERE comp_cd='{comp_cd}';")
        # 3) 공식 바인딩 교체 (S-1 유형)
        if plan["bind"]:
            old_frm, new_frm = plan["bind"]
            prd = plan["prd"]
            row = M.TPrdProductPriceFormulas.objects.filter(prd_cd=prd, frm_cd=old_frm).first()
            ymd = row.apply_bgn_ymd if row else "2026-06-28"
            M.TPrdProductPriceFormulas.objects.filter(prd_cd=prd).delete()
            M.TPrdProductPriceFormulas.objects.create(
                prd_cd_id=prd, frm_cd_id=new_frm, apply_bgn_ymd=ymd,
                note="부속 포함 공식 (세대 재배선 교정)")
            done.append(f"DELETE FROM t_prd_product_price_formulas WHERE prd_cd='{prd}';\n"
                        f"INSERT INTO t_prd_product_price_formulas"
                        f"(prd_cd,frm_cd,apply_bgn_ymd,note) VALUES"
                        f"('{prd}','{new_frm}','{ymd}','부속 포함 공식 (세대 재배선 교정)');")
    return done


print("=" * 78)
print(f"세대 어긋남 재배선 — {'★ COMMIT 모드 ★' if COMMIT else 'DRY-RUN (강제 롤백)'}")
print("=" * 78)

before = {c: measure(c, p) for c, p in SPEC.items()}

sql_log = []
after = {}
try:
    with transaction.atomic():
        sql_log = apply_spec()
        after = {c: measure(c, p) for c, p in SPEC.items()}
        if not COMMIT:
            raise RuntimeError("__ROLLBACK__")
except RuntimeError as e:
    if str(e) != "__ROLLBACK__":
        raise

total_gain = Decimal(0)
for comp_cd, plan in SPEC.items():
    prd = plan["prd"]
    nm = M.TPrdProducts.objects.filter(prd_cd=prd).values_list("prd_nm", flat=True).first()
    print(f"\n## {prd} {nm} / {comp_cd}")
    if plan["bind"]:
        print(f"   바인딩 교체: {plan['bind'][0]} → {plan['bind'][1]}")
    bmap = {o: (f, a, e) for o, _n, f, a, e in before[comp_cd]}
    for ocd, onm, f_a, a_a, e_a in after.get(comp_cd, []):
        f_b, a_b, e_b = bmap.get(ocd, (None, None, None))
        gain = (Decimal(str(f_a)) - Decimal(str(f_b))) if (f_a is not None and f_b is not None) else None
        if gain:
            total_gain += gain
        mark = "청구됨" if a_a not in (None, 0) else f"여전히 미청구({e_a})"
        print(f"   [{ocd} {onm}] 전={f_b} → 후={f_a}  (+{gain})  부속={a_a}  {mark}")

print("\n" + "=" * 78)
print("교정 SQL (권위 근거 포함)")
for s in sql_log:
    print("  " + s.replace("\n", "\n  "))

print("\n" + "=" * 78)
print("보류 — 권위 근거 부족으로 이번 교정에서 제외 (추정 금지)")
for k, v in HELD.items():
    print(f"  · {k}: {v}")

print("\n" + "=" * 78)
if COMMIT:
    print("★ COMMIT 완료 — 라이브에 적재됐다. webadmin 실화면 확인이 남았다.")
else:
    print("DRY-RUN 종료 — 라이브 무변경. 롤백 검증:")
    ok = True
    for comp_cd, plan in SPEC.items():
        for old, (new, nm, _w) in plan["opt"].items():
            n_old = M.TPrcComponentPrices.objects.filter(comp_cd=comp_cd, opt_cd=old).count()
            n_new = M.TPrcComponentPrices.objects.filter(comp_cd=comp_cd, opt_cd=new).count()
            good = n_old > 0 and n_new == 0
            ok = ok and good
            print(f"  {comp_cd} {old}={n_old} {new}={n_new} {'OK' if good else '*** 미복구 ***'}")
    print("ROLLBACK_VERIFY:", "PASS" if ok else "FAIL")
