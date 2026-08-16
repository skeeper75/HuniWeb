#!/usr/bin/env python3
# R3-mechanical-scan Part B — independent recount of spec.md §3 requirements
# vs acceptance.md §H coverage table, against the SPEC's own claimed numbers.
import json
import os
import re
from collections import Counter

ROOT = "/Users/innojini/Dev/HuniWeb"
SPEC = os.path.join(ROOT, ".moai/specs/SPEC-WORLDMODEL-001")
OUT = os.path.join(ROOT, "_workspace/huni-worldmodel/07_reverify/_scripts/out")
os.makedirs(OUT, exist_ok=True)

spec = open(os.path.join(SPEC, "spec.md"), encoding="utf-8").read().splitlines()
acc = open(os.path.join(SPEC, "acceptance.md"), encoding="utf-8").read().splitlines()


def section(lines, start_pat, end_pat):
    s = e = None
    for i, l in enumerate(lines):
        if s is None and re.match(start_pat, l):
            s = i
        elif s is not None and re.match(end_pat, l):
            e = i
            break
    return lines[s:e] if s is not None else []


# --- 1. §3 요구사항 정의행 추출 ---
sec3 = section(spec, r"^## 3\.", r"^## 4\.")
DEF_RE = re.compile(r"^\s*-\s+\*\*([UXEOS])-(\d{3})\.(\d+)\b")
defined = []
for idx, ln in enumerate(sec3, start=1):
    m = DEF_RE.match(ln)
    if m:
        defined.append((f"{m.group(1)}-{m.group(2)}.{m.group(3)}", idx, ln))
# 중복 ID 검사
dupes = [k for k, c in Counter(d[0] for d in defined).items() if c > 1]
pref = Counter(d[0].split("-")[0] for d in defined)

# --- 2. spec.md 전체 참조 ID ↔ 정의 대조 (유령 ID 검출, §H.4④ 재검증) ---
all_ids = set()
for ln in spec:
    for m in re.finditer(r"\b([UXEOS])-(\d{3})\.(\d+)\b", ln):
        all_ids.add(f"{m.group(1)}-{m.group(2)}.{m.group(3)}")
defset = {d[0] for d in defined}
phantom = sorted(all_ids - defset)          # 참조됐으나 정의행 없음

# --- 3. acceptance §H.1 표 파싱 ---
h1 = section(acc, r"^### H\.1", r"^### H\.2")
rows = []
for ln in h1:
    m = re.match(r"^\|\s*([UXEOS])-(\d{3})\.(\d+)\s*\|", ln)
    if m:
        rid = f"{m.group(1)}-{m.group(2)}.{m.group(3)}"
        cols = [c.strip() for c in ln.split("|")]
        grade = cols[4] if len(cols) > 4 else ""
        g = ("미커버" if "미커버" in grade else
             "간접" if "간접" in grade else
             "직접" if "직접" in grade else "???")
        rows.append((rid, g, grade))

grade_counts = Counter(g for _, g, _ in rows)
row_ids = [r[0] for r in rows]
row_dupes = [k for k, c in Counter(row_ids).items() if c > 1]

# --- 4. §H.2 문서 주장 숫자 추출 (직접 51 / 간접 9 / 미커버 4 등) ---
h2_text = "\n".join(section(acc, r"^### H\.2", r"^### H\.3"))
claimed_post = re.findall(r"^\|\s*\*{0,2}(직접|간접|미커버|총계)\*{0,2}\s*\|\s*\*{0,2}(\d+)\*{0,2}\s*\|", h2_text, re.M)
claimed_asfound = claimed_post[:4]
claimed_current = claimed_post[4:8]

# --- 5. 집계 출력 ---
result = {
    "spec_claim": {"total": 64, "U": 44, "X": 11, "E": 7, "O": 1, "S": 1,
                   "direct": 51, "indirect": 9, "uncovered": 4,
                   "uncovered_pct": "6.3%"},
    "measured_spec3": {"total": len(defined),
                       "prefix": dict(pref),
                       "dup_defines": dupes},
    "measured_H1_table": {"rows": len(rows), "grades": dict(grade_counts),
                          "dup_rows": row_dupes},
    "set_diff": {
        "defined_not_in_H1": sorted(defset - set(row_ids)),
        "in_H1_not_defined": sorted(set(row_ids) - defset),
    },
    "phantom_ids_referenced_not_defined": phantom,
    "H2_claimed_asfound": claimed_asfound,
    "H2_claimed_current": claimed_current,
    "defined_detail": [(d[0], d[1]) for d in defined],
}
with open(os.path.join(OUT, "b_traceability.json"), "w", encoding="utf-8") as f:
    json.dump(result, f, ensure_ascii=False, indent=1)
print(json.dumps({k: v for k, v in result.items() if k != "defined_detail"},
                 ensure_ascii=False, indent=1))
