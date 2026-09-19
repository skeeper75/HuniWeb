#!/usr/bin/env python3
"""gaps.csv 를 processes/*.md §5 에서 파생한다.

§5(가/나/다/라 소절)가 **유일한 기준**이다. 여기서 뽑은 항목 수가 곧 빠진 곳 수이고,
verdict.md 본문의 종류별 수도 이 수와 같아야 한다(verify.py V9).

260919 정정: 이전 gaps.csv(65행)는 §5 항목을 규칙 없이 묶은 것이었다. 묶는 규칙이 없으니
재현이 안 되고 본문 수와도 어긋났다(리드 t66 적발). 이제 1:1 파생으로 고정한다.
기존 65행의 curated 제안_담당·선행은 내용이 겹치는 항목으로 승계한다.
"""
import csv, glob, os, re, sys

HERE = os.path.dirname(os.path.abspath(__file__))
PROCDIR = os.path.join(HERE, "processes")
OUT = os.path.join(HERE, "gaps.csv")
LEGACY = os.path.join(HERE, "gaps-legacy-65.csv")   # 승계 원본(있으면)

KIND = {
    "가": "가 원장에 행 없음",
    "나": "나 행은 있는데 코드 0",
    "다": "다 코드는 있는데 연결 안 됨",
    "라": "라 결정 미정",
}
RID = re.compile(r"`(STD-[A-Z]{3}-\d{3}(?:~\d{3})?|T[0-9]-[0-9]+|BLK-S[0-9]-[0-9]+)`")
OWNER_HINT = re.compile(r"(서희항|최숙진|김동학|신우진|채훈희|지니|대표|외부\([^)]+\)|MES 담당)")


def clean(s):
    s = re.sub(r"\*\*(.+?)\*\*", r"\1", s)          # 굵게 제거
    s = re.sub(r"[ \t]+", " ", s).strip()
    return s


def parse_section5(body):
    """§5 → [(종류, 제목셀, 설명셀, 원문)] — 표면 1행 = 항목 1개, 산문 덩어리 = 항목 1개."""
    m = re.search(r"^## 5\. .*?\n(.*?)^## 6\. ", body, re.S | re.M)
    if not m:
        return []
    parts = re.split(r"^### ([가나다라])\. ", m.group(1), flags=re.M)
    out = []
    for i in range(1, len(parts), 2):
        k, blk = parts[i], parts[i + 1]
        # 소제목 꼬리("원장에 행 없음" 등)는 블록 첫 줄이다 — 본문에서 떼어낸다
        blk = blk.split("\n", 1)[1] if "\n" in blk else ""
        if "**없음.**" in blk:
            continue
        rows = [l for l in blk.splitlines() if l.startswith("|")]
        rows = [l for l in rows if not re.match(r"^\|[\s:|-]+\|$", l)]
        if len(rows) >= 2:                           # 헤더 + 데이터
            hdr = [c.strip() for c in rows[0].strip("|").split("|")]
            for r in rows[1:]:
                cells = [clean(c) for c in r.strip("|").split("|")]
                title = cells[0] if cells else ""
                rest = " · ".join(f"{hdr[j]}: {cells[j]}" if hdr[j] not in ("왜 필요한가", "실태", "무엇이 0인가") else cells[j]
                                  for j in range(1, min(len(cells), len(hdr))) if cells[j])
                out.append((k, title, rest, r))
        else:                                        # 산문 한 덩어리(대개 「나」의 묶음 서술)
            txt = clean(" ".join(l for l in blk.splitlines() if l.strip() and not l.startswith("#")))
            if txt:
                out.append((k, txt, "", txt))
    return out


def legacy_index():
    """기존 curated 행 → 내용 토큰 집합. 제안_담당·선행 승계용."""
    src = LEGACY if os.path.exists(LEGACY) else None
    if not src:
        return []
    rows = list(csv.DictReader(open(src, encoding="utf-8")))
    idx = []
    for r in rows:
        toks = set(re.findall(r"[가-힣A-Za-z_]{3,}", r["내용"]))
        idx.append((r["프로세스"], r["종류"][0], toks, r))
    return idx


def inherit(pid, kind, text, idx):
    """내용이 가장 많이 겹치는 legacy 행에서 담당·선행을 승계."""
    toks = set(re.findall(r"[가-힣A-Za-z_]{3,}", text))
    best, score = None, 0
    for lp, lk, ltoks, r in idx:
        if lp != pid or lk != kind:
            continue
        s = len(toks & ltoks)
        if s > score:
            best, score = r, s
    if best and score >= 3:
        return best["제안_담당"], best["선행"]
    return "", ""


def main():
    idx = legacy_index()
    out, n = [], 0
    for f in sorted(glob.glob(os.path.join(PROCDIR, "P*.md"))):
        pid = os.path.basename(f).split("-")[0]
        body = open(f, encoding="utf-8").read()
        for kind, title, rest, raw in parse_section5(body):
            n += 1
            owner, prereq = inherit(pid, kind, title + " " + rest, idx)
            if not owner:                            # 라 소절의 「누가」 열에서 직접
                m = OWNER_HINT.search(rest)
                if m and kind == "라":
                    owner = m.group(1)
            rids = ";".join(dict.fromkeys(RID.findall(raw))) or "—"
            body_txt = f"{title} — {rest}" if rest and rest != title else title
            out.append({
                "gap_id": f"G-{n:03d}",
                "프로세스": pid,
                "종류": KIND[kind],
                "내용": body_txt[:400],
                "제안_담당": owner,
                "선행": prereq,
                "관련_row_id": rids,
            })

    cols = ["gap_id", "프로세스", "종류", "내용", "제안_담당", "선행", "관련_row_id"]
    with open(OUT, "w", encoding="utf-8", newline="") as fh:
        w = csv.DictWriter(fh, fieldnames=cols, lineterminator="\n")
        w.writeheader()
        w.writerows(out)

    import collections
    c = collections.Counter(r["종류"][0] for r in out)
    print(f"gaps.csv — {len(out)}건 " + " · ".join(f"{k} {c[k]}" for k in "가나다라"))
    print(f"담당 승계 {sum(1 for r in out if r['제안_담당'])} · 선행 승계 {sum(1 for r in out if r['선행'])}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
