#!/usr/bin/env python3
# round-24 2단계 · ✅격상 186 junction 적재본 빌더 (green2)
# 입력: _reclassify/upgraded-green.csv(186 prd_cd) + product-cat.csv(263행 귀속 명세)
# 제외: 08_load-green/product-cat-green.csv(✅36 — 이미 라이브 COMMIT, 중복 금지)
# 산출: product-cat-green2.csv (본체 main='Y' + 별칭 main='N')
import csv, os

BASE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(BASE)


def read_csv(path):
    with open(path, newline="", encoding="utf-8-sig") as f:
        return list(csv.DictReader(f))


# 1) 186 격상 대상 prd_cd 집합
upg = read_csv(os.path.join(ROOT, "_reclassify", "upgraded-green.csv"))
upg_set = set(r["prd_cd"].strip() for r in upg if r["prd_cd"].strip())

# 2) 이미 적재된 ✅36 (중복 금지)
g1 = read_csv(os.path.join(ROOT, "08_load-green", "product-cat-green.csv"))
g1_set = set(r["prd_cd"].strip() for r in g1)

# 3) 전체 매핑 명세 product-cat.csv 에서 186 prd_cd 의 junction 행 추출
pc = read_csv(os.path.join(ROOT, "product-cat.csv"))

rows = []
for r in pc:
    prd = (r.get("prd_cd") or "").strip()
    if not prd:
        continue  # RED placeholder(prd_cd 공란) 제외
    if prd not in upg_set:
        continue
    rows.append(r)

# 4) 본체(main='Y')와 별칭(main='N') 분리·정합 검증
by_prd = {}
for r in rows:
    by_prd.setdefault(r["prd_cd"].strip(), []).append(r)

errors = []
body_rows = []   # main='Y'
alias_rows = []  # main='N'(ALIAS)
for prd, rs in by_prd.items():
    mains = [r for r in rs if (r.get("main_cat_yn") or "").strip() == "Y"]
    aliases = [r for r in rs if (r.get("main_cat_yn") or "").strip() == "N"]
    if len(mains) != 1:
        errors.append(f"{prd}: main='Y' 행이 {len(mains)}개(1이어야 함)")
        continue
    body_rows.append(mains[0])
    alias_rows.extend(aliases)

# 5) 중복 검증: upg_set ∩ g1_set 가 0인지
dup = upg_set & g1_set
if dup:
    errors.append(f"08_load-green 36과 중복 prd_cd {len(dup)}개: {sorted(dup)}")

# 186 누락 검증: upgraded 목록 중 product-cat.csv 에 없는 prd_cd
covered = set(by_prd.keys())
missing = upg_set - covered
if missing:
    errors.append(f"product-cat.csv 미수록 prd_cd {len(missing)}개: {sorted(missing)}")

# 6) 출력 CSV: 본체 먼저(main='Y'), 그 다음 별칭(main='N')
out_path = os.path.join(BASE, "product-cat-green2.csv")
field = ["prd_cd", "prd_nm", "map_category", "status", "cat_cd", "cat_nm",
         "main_cat_yn", "match_level", "live_opt_n", "live_priced", "multi_class", "note"]
all_out = sorted(body_rows, key=lambda r: r["prd_cd"]) + \
          sorted(alias_rows, key=lambda r: (r["prd_cd"], r["cat_cd"]))
with open(out_path, "w", newline="", encoding="utf-8") as f:
    w = csv.DictWriter(f, fieldnames=field)
    w.writeheader()
    for r in all_out:
        w.writerow({k: r.get(k, "") for k in field})

# 7) 요약 출력
print(f"upgraded 목록 prd_cd            : {len(upg_set)}")
print(f"product-cat.csv 에서 매칭 prd_cd: {len(covered)}")
print(f"본체 junction (main='Y')        : {len(body_rows)}")
print(f"별칭 junction (main='N',ALIAS)  : {len(alias_rows)}")
print(f"총 junction 행                  : {len(all_out)}")
print(f"08_load-green 36 중복           : {len(dup)}")
# 가변깊이(L2/L3) deeper 귀속 본체 집계
deeper = [r for r in body_rows if "L2" in (r.get("match_level") or "") or "L3" in (r.get("match_level") or "")]
print(f"가변깊이 deeper 귀속 본체(L2/L3): {len(deeper)}")
for r in deeper:
    print(f"   {r['prd_cd']} {r['prd_nm']} -> {r['cat_cd']} {r['cat_nm']} [{r['match_level']}]")
# 본체 타깃 cat_cd 분포
from collections import Counter
dist = Counter(r["cat_cd"] for r in body_rows)
print("본체 타깃 cat_cd 분포:")
for cc, n in sorted(dist.items()):
    nm = next(r["cat_nm"] for r in body_rows if r["cat_cd"] == cc)
    print(f"   {cc} {nm}: {n}")
# 별칭 타깃 cat_cd 분포
adist = Counter(r["cat_cd"] for r in alias_rows)
print("별칭 타깃 cat_cd 분포:")
for cc, n in sorted(adist.items()):
    print(f"   {cc}: {n}")

if errors:
    print("\n!!! ERRORS:")
    for e in errors:
        print("  -", e)
else:
    print("\nOK: 정합 검증 통과(main 단일성·중복0·누락0)")
