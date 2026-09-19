#!/usr/bin/env python3
# t57 — t51 merged.csv 에서 이음매(integrate) 센서스를 뜬다. 읽기전용.
import csv, collections, json, os, sys

BASE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
rows = list(csv.DictReader(open(os.path.join(BASE, "t51", "merged.csv"), encoding="utf-8")))

seam = collections.Counter()
st = collections.defaultdict(collections.Counter)
own = collections.defaultdict(collections.Counter)
scope = collections.defaultdict(collections.Counter)
samples = collections.defaultdict(list)

for x in rows:
    if x["work_type"] != "integrate":
        continue
    k = tuple(sorted([x["system"], x["counterpart"] or "(공란)"]))
    seam[k] += 1
    st[k][x["status"]] += 1
    own[k][x["owner_side"] or "(공란)"] += 1
    scope[k][x.get("scope", "")] += 1
    if len(samples[k]) < 3:
        samples[k].append((x["screen_id"], x["function"][:60], x["evidence"][:80]))

out = []
for k, c in seam.most_common():
    out.append({
        "seam": f"{k[0]} <-> {k[1]}",
        "n": c,
        "status": dict(st[k]),
        "owner_side": dict(own[k]),
        "scope": dict(scope[k]),
        "samples": samples[k],
    })
    print(f"{k[0]} <-> {k[1]}  n={c}  scope={dict(scope[k])}  status={dict(st[k])}  owner={dict(own[k])}")

print()
print("=== 시스템별 status 분포 (전 행)")
bysys = collections.defaultdict(collections.Counter)
for x in rows:
    bysys[x["system"]][x["status"]] += 1
for s in sorted(bysys):
    print(f"  {s}: {dict(bysys[s])}")

json.dump(out, open(os.path.join(BASE, "t57", "seams.json"), "w", encoding="utf-8"),
          ensure_ascii=False, indent=1)
