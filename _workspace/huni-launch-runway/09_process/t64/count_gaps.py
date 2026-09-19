#!/usr/bin/env python3
"""processes/*.md §5 의 빠진 곳 항목을 종류별로 센다 — gaps.csv·verdict 본문의 기준."""
import collections, csv, glob, os, re

KINDS = "가나다라"


def count_section(blk):
    """소절 하나의 항목 수. 표면 데이터행 수, '없음.' 이면 0, 산문이면 1."""
    if "**없음.**" in blk:
        return 0
    rows = [l for l in blk.splitlines() if l.startswith("|")]
    rows = [l for l in rows if not re.match(r"^\|[\s:|-]+\|$", l)]
    if rows:
        return max(0, len(rows) - 1)          # 헤더 제외
    return 1 if blk.strip() else 0


def per_process(base="processes"):
    out = {}
    for f in sorted(glob.glob(os.path.join(base, "P*.md"))):
        pid = os.path.basename(f).split("-")[0]
        body = open(f, encoding="utf-8").read()
        sec = re.search(r"^## 5\. 빠진 곳\n(.*?)^## 6\. ", body, re.S | re.M).group(1)
        parts = re.split(r"^### ([가나다라])\. ", sec, flags=re.M)
        d = {}
        for i in range(1, len(parts), 2):
            d[parts[i]] = count_section(parts[i + 1])
        out[pid] = d
    return out


def main():
    per = per_process()
    tot = collections.Counter()
    print("프로세스별 (가/나/다/라):")
    for p, d in per.items():
        v = [d.get(k, 0) for k in KINDS]
        for k in KINDS:
            tot[k] += d.get(k, 0)
        print(f"  {p} {v}  합 {sum(v)}")
    print()
    print("§5 합계 :", {k: tot[k] for k in KINDS}, "=", sum(tot.values()))
    g = list(csv.DictReader(open("gaps.csv", encoding="utf-8")))
    c = collections.Counter(x["종류"][0] for x in g)
    print("gaps.csv:", {k: c[k] for k in KINDS}, "=", len(g))
    print("차이     :", {k: tot[k] - c[k] for k in KINDS})
    print()
    pc = collections.Counter(x["프로세스"] for x in g)
    print("프로세스별 csv 대비 §5:")
    for p, d in per.items():
        s5, cs = sum(d.values()), pc[p]
        mark = "" if s5 == cs else "   ← 다르다"
        print(f"  {p} §5 {s5:>2} / csv {cs:>2}{mark}")


if __name__ == "__main__":
    main()
