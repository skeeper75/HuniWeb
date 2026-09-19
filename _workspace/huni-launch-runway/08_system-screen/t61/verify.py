#!/usr/bin/env python3
"""t61 자기검산 — 문서가 주장한 숫자를 다시 센다.

G1 분모       : rejudge.csv 에서 김동학·남은 일이 189행인가
G2 보존       : axis-rows.csv 의 원장 행이 189행이고 row_id 집합이 G1 과 같은가
G3 축 분포    : 5축 합이 원장 189 + 신규 16 = 205 인가
G4 근거 필수  : 모든 행에 evidence 가 있는가(빈 칸 0)
G5 축 누락    : 리드 5축 초안이 든 접두 10개가 전부 어느 축엔가 들어갔는가
G6 명세 diff  : 최신 샵바이 명세에서 삭제 3경로 · promotion-shop 삭제 2경로가 맞는가
G7 호출 0건   : 문서가 「0건」이라고 쓴 huni-mall grep 패턴이 실제로 0건인가
"""
import csv
import collections
import os
import re
import subprocess
import sys

BASE = os.path.dirname(os.path.abspath(__file__))
SS = os.path.dirname(BASE)
MALL = "/Users/innojini/Dev/huni-skin-shopby"
LOCAL_SPEC = "/Users/innojini/Dev/HuniWeb/docs/shopby/shopby-api"

fail = []


def check(tag, ok, msg):
    print(f"{'PASS' if ok else 'FAIL'} {tag} — {msg}")
    if not ok:
        fail.append(tag)


# ── G1
src = list(csv.DictReader(open(os.path.join(SS, "t56", "rejudge.csv"), encoding="utf-8")))
kd = [r for r in src if "김동학" in (r["owner_proposed"] or "") and r["remaining"] == "Y"]
check("G1", len(src) == 735 and len(kd) == 189,
      f"rejudge.csv {len(src)}행 / 김동학·남은일 {len(kd)}행")

# ── G2
ax = list(csv.DictReader(open(os.path.join(BASE, "axis-rows.csv"), encoding="utf-8")))
led = [r for r in ax if r["kind"] == "원장"]
new = [r for r in ax if r["kind"] == "신규제안"]
check("G2", {r["row_id"] for r in led} == {r["row_id"] for r in kd},
      f"원장 {len(led)}행 · row_id 집합 일치")

# ── G3
c = collections.Counter(r["axis"] for r in ax)
check("G3", len(ax) == 205 and len(c) == 5 and len(new) == 16,
      f"전체 {len(ax)}행 = 원장 {len(led)} + 신규 {len(new)} · 축 {len(c)}개 " +
      " ".join(f"{k.split('.')[0]}:{v}" for k, v in sorted(c.items())))

# ── G4
blank = [r["row_id"] for r in ax if not (r["evidence"] or "").strip()]
check("G4", not blank, f"evidence 빈 행 {len(blank)}건")

# ── G5
want = ["STD-CAT", "STD-ORD", "STD-PAY", "STD-MYP", "STD-CLM",
        "STD-MEM", "STD-INF", "STD-ADC", "STD-SYS", "F4"]
seen = {r["row_id"].rsplit("-", 1)[0] for r in led}
miss = [p for p in want if p not in seen]
check("G5", not miss, f"리드 초안 접두 10개 중 미포함 {miss}")

# ── G6
def paths(p):
    s = open(p, encoding="utf-8", errors="replace").read()
    m = re.search(r"\npaths:\n", s)
    out = set()
    if not m:
        return out
    for line in s[m.end():].split("\n"):
        if re.match(r"^  /", line):
            out.add(line.strip().rstrip(":").rstrip("/"))
        elif line and not line.startswith(" "):
            break
    return out


spec_dir = os.path.join(BASE, "spec-latest")
if os.path.isdir(spec_dir):
    removed = {}
    for f in sorted(os.listdir(spec_dir)):
        if not f.endswith(".yml"):
            continue
        r = paths(os.path.join(LOCAL_SPEC, f)) - paths(os.path.join(spec_dir, f))
        if r:
            removed[f] = sorted(r)
    flat = sorted(x for v in removed.values() for x in v)
    check("G6", flat == ["/coupons/products/download",
                         "/coupons/products/issuable/coupons",
                         "/products/{mallProductNo}"],
          f"4월본 대비 삭제 경로 {len(flat)}건 {removed}")
else:
    check("G6", False, "spec-latest 디렉터리 없음 — 재실행 전 다운로드 필요")

# ── G7
zero = ["coupons/products/download", "coupons/products/issuable",
        "orders/coupons/available", "orders/coupons/calculate", "hold-delivery",
        "app-card", "option-management-code", "members/external/id",
        "marketing-privacy", "promotion-configs/coupon",
        "order/register", "X-Huni-Server-Key", "posts/previews"]
bad = []
for p in zero:
    n = subprocess.run(["grep", "-rIF", p, "src/"], cwd=MALL,
                       capture_output=True, text=True).stdout.strip()
    if n:
        bad.append((p, len(n.splitlines())))
check("G7", not bad, f"「0건」 주장 {len(zero)}패턴 중 실제 히트 {bad}")

print()
print("결과:", "전부 PASS" if not fail else f"FAIL {fail}")
sys.exit(1 if fail else 0)
