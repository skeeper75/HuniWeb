#!/usr/bin/env python3
# R3-mechanical-scan Part A — extract ALL `file:line` citations from the 3 SPEC docs
# and verify: (1) file exists, (2) line range exists, (3) claim-token content match.
# Deterministic: fixed regexes, fixed base-dir priority, fixed token rules.
# READ-ONLY on raw/webadmin, SPEC docs, live DB. Writes only under _scripts/out/.
import glob
import json
import os
import re
from collections import Counter, defaultdict

ROOT = "/Users/innojini/Dev/HuniWeb"
SPEC_DIR = os.path.join(ROOT, ".moai/specs/SPEC-WORLDMODEL-001")
OUT_DIR = os.path.join(ROOT, "_workspace/huni-worldmodel/07_reverify/_scripts/out")
os.makedirs(OUT_DIR, exist_ok=True)
DOCS = ["spec.md", "plan.md", "acceptance.md"]

WM = os.path.join(ROOT, "_workspace/huni-worldmodel")
WM_PRIO = ["01_research", "02_diagnosis", "03_problem", "04_design",
           "05_gate", "06_artifact", "00_meta"]
wm_subs = sorted(glob.glob(os.path.join(WM, "*/")))
APP_DIRS = sorted(glob.glob(os.path.join(ROOT, "raw/webadmin/webadmin/*/")))
CATALOG = os.path.join(ROOT, "raw/webadmin/webadmin/catalog")
SQL_DIR = os.path.join(ROOT, "raw/webadmin/sql")


def candidate_bases(frag):
    """Ordered candidate base dirs for a cited path fragment (first hit wins)."""
    if frag.startswith(("raw/", "_workspace/", ".moai/")):
        return [ROOT]
    if frag.startswith("sql/"):
        return [os.path.join(ROOT, "raw/webadmin")]
    ext = frag.rsplit(".", 1)[-1].lower()
    bases = []
    if ext == "py":
        bases.append(CATALOG)
        bases.append(os.path.join(ROOT, "raw/webadmin/webadmin"))  # config/urls.py 등
        bases += [d for d in APP_DIRS if d != CATALOG]
        bases.append(os.path.join(ROOT, "raw/webadmin"))
    elif ext == "sql":
        bases.append(SQL_DIR)
    elif ext in ("md", "txt", "csv", "json", "yaml", "yml", "html", "js"):
        for p in WM_PRIO:
            d = os.path.join(WM, p)
            if os.path.isdir(d):
                bases.append(d)
        bases += [d for d in wm_subs
                  if os.path.basename(d.rstrip("/")) not in WM_PRIO]
        bases.append(SPEC_DIR)                    # sibling SPEC docs (plan.md 등)
        bases.append(os.path.join(ROOT, "_workspace/_foundation"))
        bases.append(os.path.join(ROOT, "_workspace"))
        bases.append(WM)
    bases.append(ROOT)
    return bases


def resolve(frag):
    """Resolve fragment → (resolved_abs_or_None, all_hits)."""
    hits = []
    for b in candidate_bases(frag):
        cand = os.path.join(b, frag)
        if os.path.isfile(cand) and cand not in hits:
            hits.append(cand)
    return (hits[0] if hits else None), hits


# file part + line spec `:N` / `:N-M` / `:N,N` / `:N,N-M` / `:N-M,N-M`
FILE_RE = re.compile(
    r"((?:[\w.-]+/)*[\w.-]+\.(?:py|md|sql|json|yaml|yml|txt|csv|js|html))"
    r"(?::(\d+)(?:-(\d+))?(?:,(\d+)(?:-(\d+))?)?)?"
)
BARE_RE = re.compile(r"`:(\d+)(?:-(\d+))?`")
CODEISH = re.compile(r"[A-Za-z_][A-Za-z0-9_.\[\]\"]{2,}")


def parse_specs(m):
    """[(s,e),...] line specs from FILE_RE match (group 2..5)."""
    specs = []
    if m.group(2):
        specs.append((int(m.group(2)), int(m.group(3) or m.group(2))))
        if m.group(4):
            specs.append((int(m.group(4)), int(m.group(5) or m.group(4))))
    return specs


def suffix(m):
    if not m.group(2):
        return ""
    s = ":" + m.group(2)
    if m.group(3):
        s += "-" + m.group(3)
    if m.group(4):
        s += "," + m.group(4)
        if m.group(5):
            s += "-" + m.group(5)
    return s


FILEISH = re.compile(r"^[\w./-]+\.(?:py|md|sql|json|yaml|yml|txt|csv|js|html)"
                     r"(?::[\d,\-]+)?(?::\S+)?$")


def tokens_near(line, pos, cite_file):
    """Claim tokens from backtick spans + FIX/R/CS2/P/N tokens within ±150 chars
    of the citation position. Spans are extracted from the FULL line (never a
    windowed slice — windowing mid-span flips backtick parity) then filtered by
    distance. File-citation spans and pure numbers excluded; closest first, top 4."""
    lo, hi = max(0, pos - 150), min(len(line), pos + 150)
    scored = []

    def consider(tok, dist):
        tok = tok.strip()
        mm = re.match(r"^(?:" + "|".join(MODULE_MAP) + r")\.(.+)$", tok)
        if mm:
            consider(mm.group(1).rstrip("(\" "), dist + 1)
        if not tok or tok == cite_file or FILEISH.match(tok):
            return
        if re.fullmatch(r":?[\d,\-]+", tok):
            return
        if not CODEISH.search(tok):
            return
        if not (lo - 40 <= dist <= hi + 40):
            return
        scored.append((dist, tok))

    for m in re.finditer(r"`([^`\n]{2,120})`", line):
        c = (m.start() + m.end()) // 2
        consider(m.group(1), c)
    for m in re.finditer(r"\b((?:FIX|R|CS2?|P|N)-\d{1,3}[a-z]?)\b", line):
        consider(m.group(1), m.start())
    # Korean phrase tokens (prose-claim anchors for .md targets): runs ≥ 8 chars,
    # kept in a separate list — they only ADD OK/LINE_DRIFT evidence, never MISMATCH.
    win = line[lo:hi]
    kr = [p.strip() for p in re.findall(r"[가-힣][가-힣 ]{7,}", win)]
    kr.sort(key=len, reverse=True)
    r_seen, kr_out = set(), []
    for p in kr:
        if p not in r_seen and len(kr_out) < 3:
            r_seen.add(p)
            kr_out.append(p)
    scored.sort(key=lambda x: abs(x[0] - pos))
    seen, out = set(), []
    for _, t in scored:
        if t not in seen:
            seen.add(t)
            out.append(t)
        if len(out) >= 4:
            break
    return out, kr_out


def read_lines(p):
    with open(p, encoding="utf-8", errors="replace") as f:
        return f.read().splitlines()


def check(doc, ln, cite, resolved, hits, specs, toks, raw_line, kr=None):
    kr = kr or []
    r = {"doc": doc, "line": ln, "cite": cite, "tokens": toks[:6]}
    if not resolved:
        r.update(class_="MISSING", note="FILE_NOT_FOUND — base dirs 모두에서 미발견",
                 file="", excerpt="")
        return r
    r["file"] = os.path.relpath(resolved, ROOT)
    r["alt_hits"] = [os.path.relpath(h, ROOT) for h in hits[1:]]
    fl = read_lines(resolved)
    n = len(fl)
    s, e = specs[0]
    if e > n or s < 1:
        r.update(class_="MISSING",
                 note=f"LINE_BEYOND_EOF — 인용 {s}-{e}, 파일 {n}행",
                 excerpt="")
        return r
    seg = "\n".join(fl[s - 1:e])
    if len(specs) > 1 and specs[1][1] <= n:
        seg += "\n" + "\n".join(fl[specs[1][0] - 1:specs[1][1]])
    r["excerpt"] = seg.replace("|", "｜")[:110]
    hit_toks = [t for t in toks if t in seg]
    hit_kr = [p for p in kr if p in seg]
    if hit_toks or hit_kr:
        ev = []
        if hit_toks:
            ev.append("토큰: " + ", ".join(hit_toks[:2]))
        if hit_kr:
            ev.append("문구: " + hit_kr[0][:24])
        r.update(class_="OK", note="; ".join(ev))
        return r
    # drift search — identifier tokens first, then Korean phrases
    found = {}
    for t in toks:
        locs = [k + 1 for k, x in enumerate(fl) if t in x]
        if locs:
            found[t] = locs[:4]
    kr_found = {}
    for p in kr:
        locs = [k + 1 for k, x in enumerate(fl) if p in x]
        if locs:
            kr_found[p[:20]] = locs[:4]
    if found or kr_found:
        r["class_"] = "LINE_DRIFT"
        parts = [f"{t}→{v}" for t, v in list(found.items())[:2]]
        parts += [f"문구[{t}]→{v}" for t, v in list(kr_found.items())[:2]]
        r["note"] = "인용 줄에 근거 없음; 파일 내 위치: " + "; ".join(parts)
        allv = list(found.values()) + list(kr_found.values())
        r["drift_cand"] = allv[0]
        return r
    secs = re.findall(r"§\s?([\d.]+)", raw_line)
    if secs:
        pat = re.compile(r"^#{1,6}\s*" + re.escape(secs[0].rstrip(".")) + r"\b")
        locs = [k + 1 for k, x in enumerate(fl) if pat.match(x)]
        if locs:
            r.update(class_="LINE_DRIFT",
                     note=f"§{secs[0]} 헤딩 위치 {locs[:3]}",
                     drift_cand=locs[:3])
            return r
    if toks:
        r.update(class_="MISMATCH",
                 note="토큰이 spec 맥락엔 있으나 대상 파일 전체에 부재")
        return r
    r.update(class_="OK_COORD",
             note="좌표 실재 · 내용대조 불가(토큰/문구 부재)")
    return r


MODULE_MAP = {"price_views": "price_views.py", "pricing": "pricing.py",
              "widget_api": "widget_api.py", "tmpl_combo": "tmpl_combo.py",
              "views": "views.py", "models": "models.py",
              "assistant_tools": "assistant_tools.py", "cfg_utils": "cfg_utils.py",
              "admin": "admin.py", "basecodes": "basecodes.py"}
QUALSYM_RE = re.compile(r"`((?:" + "|".join(MODULE_MAP) + r")\.[A-Za-z_][\w.]*)\s*\(?")
RDOC_RE = re.compile(r"\bR([1-7]):(\d+)(?:-(\d+))?\b")


def rdoc_file(n):
    g = glob.glob(os.path.join(WM, "01_research", f"R{n}-*.md"))
    return os.path.basename(g[0]) if g else None


def anchors_on(line):
    """All attribution anchors on a line: (pos, kind, payload).
    kind: file | modsym | rdoc — payload = fragment / module / R-number."""
    out = []
    for m in FILE_RE.finditer(line):
        if not re.fullmatch(r"v?\d[\w.-]*", m.group(1)):
            out.append((m.start(), "file", m.group(1)))
    for m in QUALSYM_RE.finditer(line):
        out.append((m.start(), "modsym", m.group(1).split(".")[0]))
    for m in RDOC_RE.finditer(line):
        out.append((m.start(), "rdoc", m.group(1)))
    out.sort()
    return out


def attribute(bm, i, line, lines, fms):
    """Attribute a bare `:N` cite. Anchor chain: all anchors before it on this
    line (nearest first), then last anchor of each of the previous 10 lines.
    Returns list of (frag, how) candidates in priority order."""
    chain = []
    anc = sorted([a for a in anchors_on(line) if a[0] < bm.start()],
                 reverse=True)
    chain += [("sameline", a) for a in anc]
    for j in range(i - 1, max(0, i - 11), -1):
        prev = anchors_on(lines[j - 1])
        if prev:
            chain.append(("lookback", prev[-1]))
    out = []
    for how, (_, kind, payload) in chain:
        if kind == "file":
            frag = payload
        elif kind == "modsym":
            frag = MODULE_MAP[payload]
        else:
            frag = rdoc_file(payload)
        if frag and (frag, how) not in out:
            out.append((frag, how))
    return out


results = []
for doc in DOCS:
    lines = read_lines(os.path.join(SPEC_DIR, doc))
    for i, line in enumerate(lines, 1):
        fms = list(FILE_RE.finditer(line))
        for m in fms:
            frag = m.group(1)
            if re.fullmatch(r"v?\d[\w.-]*", frag):
                continue
            specs = parse_specs(m)
            if not specs:
                continue                      # 행 번호 없는 인용: A 범위 밖
            resolved, hits = resolve(frag)
            toks, kr = tokens_near(line, m.start(), frag)
            results.append(check(doc, i, frag + suffix(m), resolved, hits,
                                 specs, toks, line, kr))
        # R-doc citations `R4:8` / `R4:8-12`
        for m in RDOC_RE.finditer(line):
            rf = rdoc_file(m.group(1))
            s = int(m.group(2))
            e = int(m.group(3) or m.group(2))
            if rf:
                resolved, hits = resolve(rf)
            else:
                resolved, hits = None, []
            toks, kr = tokens_near(line, m.start(), rf or "")
            results.append(check(doc, i, f"R{m.group(1)}:{m.group(2)}" +
                                 (f"-{m.group(3)}" if m.group(3) else ""),
                                 resolved, hits, [(s, e)], toks, line, kr))
        # bare `:N` continuation — candidate chain with absurd-result recovery
        for bm in BARE_RE.finditer(line):
            cands = attribute(bm, i, line, lines, fms)
            specs = [(int(bm.group(1)), int(bm.group(2) or bm.group(1)))]
            tried, r = [], None
            for frag, how in cands[:3]:
                resolved, hits = resolve(frag)
                toks, kr = tokens_near(line, bm.start(), frag)
                cite = (frag + ":" + bm.group(1) +
                        (f"-{bm.group(2)}" if bm.group(2) else ""))
                cand_r = check(doc, i, cite, resolved, hits, specs, toks,
                               line, kr)
                tried.append(f"{frag}({how})")
                if cand_r["class_"] not in ("MISSING",):
                    cand_r["attr"] = how
                    r = cand_r
                    break
                r = cand_r  # keep last absurd attempt for the record
            if not cands:
                results.append({"doc": doc, "line": i, "cite": f"`:{bm.group(1)}`",
                                "file": "", "excerpt": "",
                                "class_": "UNRESOLVED_IMPLICIT",
                                "note": "bare :N — 10행 창 안에 귀속 앵커 없음"})
                continue
            if r:
                r["attr_tried"] = " → ".join(tried)
                results.append(r)

# ---- aggregate ----
cls = Counter(r["class_"] for r in results)
per_doc = defaultdict(Counter)
per_target = defaultdict(Counter)
for r in results:
    per_doc[r["doc"]][r["class_"]] += 1
    if r.get("file"):
        per_target[r["file"]][r["class_"]] += 1

stats = {
    "total": len(results),
    "class_counts": dict(cls),
    "per_doc": {d: dict(c) for d, c in per_doc.items()},
    "per_target": {k: dict(v) for k, v in sorted(per_target.items())},
}
with open(os.path.join(OUT_DIR, "a_summary.json"), "w", encoding="utf-8") as f:
    json.dump(stats, f, ensure_ascii=False, indent=1)
with open(os.path.join(OUT_DIR, "a_citations.tsv"), "w", encoding="utf-8") as f:
    f.write("doc\tspec_line\tcite\tclass\tnote\tfile\texcerpt\n")
    for r in results:
        f.write("\t".join([r["doc"], str(r["line"]), r["cite"], r["class_"],
                           r.get("note", ""), r.get("file", ""),
                           r.get("excerpt", "")]) + "\n")

print(json.dumps({"total": stats["total"], "class_counts": stats["class_counts"]},
                 ensure_ascii=False, indent=1))
print("\n== design-FINAL.md ==")
for k, v in stats["per_target"].items():
    if "design-FINAL" in k:
        print(k, v)
print("\n== non-OK ==")
for r in results:
    if r["class_"] not in ("OK", "OK_COORD"):
        print(f"[{r['class_']}] {r['doc']}:{r['line']} `{r['cite']}` → {r.get('file') or '?'} | {r.get('note','')}")
