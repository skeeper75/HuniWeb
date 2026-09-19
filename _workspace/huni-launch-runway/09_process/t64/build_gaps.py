#!/usr/bin/env python3
"""gaps.csv 를 processes/*.md §5 에서 파생한다.

§5(가/나/다/라 소절)가 **유일한 기준**이다. 여기서 뽑은 항목 수가 곧 빠진 곳 수이고,
verdict.md 본문의 종류별 수도 이 수와 같아야 한다(verify.py V9).

260919 정정 ①: 이전 gaps.csv(65행)는 §5 항목을 규칙 없이 묶은 것이었다. 묶는 규칙이 없으니
재현이 안 되고 본문 수와도 어긋났다(리드 t66 적발). 이제 1:1 파생(169행)으로 고정한다.

260919 정정 ②(이 파일): 169행 중 105행의 `제안_담당` 이 비어 있었다. 옛 65행의 curated 담당을
내용 토큰이 겹치는 행으로만 승계했기 때문이다(64행만 승계). 그 공란이 t66 decisions.md 의
「미정」 29건 · quick-wins.md 의 「미정」 77건으로 그대로 흘러갔다(리드 지시 260919).

**새로 판단하지 않는다 — 이미 판정된 곳에서 옮긴다.** 승계 규칙 세 갈래를 고정하고,
어느 갈래로 채웠는지 `담당_근거` 열에 남긴다:

  ① 원장(t56/rejudge.csv) `owner_proposed` — 항목이 가리키는 row_id 가 있을 때. 가장 강한 근거.
  ② 이미 판정된 담당 표기에서 옮긴다 — row_id 가 없을 때. 강한 순서대로:
     ②본문        §5 항목 셀 자체가 담당을 적고 있다(대개 「라」 소절의 「누가」 열)
     ②단계표      §4 단계표에서 내용이 가장 많이 겹치는 단계의 「담당자」
     ②채우는방법  §6 「채우는 방법」 표에서 내용이 가장 많이 겹치는 줄의 「누가」
     ②교차       같은 결정·같은 공백이 다른 프로세스에서 ① 로 판정돼 있으면 그것을 옮긴다
                  (「MES 실제 상태 코드」·「부분취소 지원 여부」처럼 여러 프로세스에 겹쳐 나온다)
     ②옛65행      옛 curated 65행에 내용이 겹치는 항목이 있으면 그 담당
  ③ 미정 — 위 어느 것도 근거가 없을 때. 비우지 않고 「미정」 + 사유 한 줄을 적는다.
     **프로세스의 최빈 담당자로 메우지 않는다** — 그건 옮긴 것이 아니라 새로 판단한 것이다.

  t59 csj-todo · t60 cto-todo · t61 mall-todo 의 축별 담당은 축 배정이 **row_id 를 키로** 되어
  있다(`axis-rows.csv`). row_id 가 없는 항목에는 붙일 키가 없으므로 ② 는 프로세스 문서 안에서만
  찾는다 — 원장 행이 있는 항목은 어차피 ① 이 같은 판정을 가져온다.

선행(`선행` 열)은 종전대로 옛 65행에서 내용이 겹치는 항목으로 승계한다(담당과 달리 새 규칙 없음).
"""
import collections, csv, glob, os, re, sys

HERE = os.path.dirname(os.path.abspath(__file__))
RUNWAY = os.path.abspath(os.path.join(HERE, "..", ".."))
PROCDIR = os.path.join(HERE, "processes")
OUT = os.path.join(HERE, "gaps.csv")
LEGACY = os.path.join(HERE, "gaps-legacy-65.csv")   # 선행 승계 원본(있으면)
LEDGER = os.path.join(RUNWAY, "08_system-screen", "t56", "rejudge.csv")

KIND = {
    "가": "가 원장에 행 없음",
    "나": "나 행은 있는데 코드 0",
    "다": "다 코드는 있는데 연결 안 됨",
    "라": "라 결정 미정",
}
RID = re.compile(r"`(STD-[A-Z]{3}-\d{3}(?:~\d{3})?|T[0-9]-[0-9]+|BLK-S[0-9]-[0-9]+)`")
OWNER_HINT = re.compile(r"(서희항|최숙진|김동학|신우진|채훈희|지니|대표|외부\([^)]+\)|MES 담당)")
TOK = re.compile(r"[가-힣A-Za-z_]{3,}")


def clean(s):
    s = re.sub(r"\*\*(.+?)\*\*", r"\1", s)          # 굵게 제거
    s = re.sub(r"[ \t]+", " ", s).strip()
    return s


def toks(s):
    return set(TOK.findall(s))


def table_rows(block):
    """마크다운 표 블록 → [헤더, 셀리스트...]. 구분줄 제거."""
    rows = [l for l in block.splitlines() if l.strip().startswith("|")]
    rows = [l for l in rows if not re.match(r"^\|[\s:|-]+\|$", l.strip())]
    return [[clean(c) for c in l.strip().strip("|").split("|")] for l in rows]


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


def parse_section4(body):
    """§4 단계표 → ([(토큰집합, 담당자)], [그 표에 적힌 원장 row_id 전체])."""
    m = re.search(r"^## 4\. .*?\n(.*?)^## 5\. ", body, re.S | re.M)
    if not m:
        return [], []
    rows = table_rows(m.group(1))
    if not rows:
        return [], []
    hdr = rows[0]
    try:
        i_step, i_own = hdr.index("단계"), hdr.index("담당자")
    except ValueError:
        return [], []
    i_basis = hdr.index("근거") if "근거" in hdr else None
    i_rid = hdr.index("원장 row_id") if "원장 row_id" in hdr else None
    idx, rids = [], []
    for c in rows[1:]:
        if len(c) <= max(i_step, i_own):
            continue
        if i_rid is not None and len(c) > i_rid:
            for r in RID.findall(c[i_rid]):
                if r not in rids:
                    rids.append(r)
        own = c[i_own].strip()
        if not own or own == "—":
            continue
        text = c[i_step] + " " + (c[i_basis] if i_basis is not None and len(c) > i_basis else "")
        idx.append((toks(text), own))
    return idx, rids


def parse_section6(body):
    """§6 채우는 방법 → [(토큰집합, 누가)]."""
    m = re.search(r"^## 6\. .*?\n(.*?)^## 7\. ", body, re.S | re.M)
    if not m:
        return []
    rows = table_rows(m.group(1))
    if not rows:
        return []
    hdr = rows[0]
    if "누가" not in hdr or "무엇을" not in hdr:
        return []
    i_who, i_what = hdr.index("누가"), hdr.index("무엇을")
    out = []
    for c in rows[1:]:
        if len(c) <= max(i_who, i_what):
            continue
        who = c[i_who].strip()
        if who and who != "—":
            out.append((toks(c[i_what]), who))
    return out


def best_match(text, idx, floor=2):
    """토큰이 가장 많이 겹치는 항목의 담당. floor 미만이면 없음."""
    t = toks(text)
    best, score = "", 0
    for itoks, own in idx:
        s = len(t & itoks)
        if s > score:
            best, score = own, s
    return best if score >= floor else ""


def ledger_owners():
    rows = csv.DictReader(open(LEDGER, encoding="utf-8"))
    return {r["row_id"]: r["owner_proposed"].strip() for r in rows}


def legacy_index():
    """옛 65행 → 내용 토큰 집합. 선행 승계용."""
    if not os.path.exists(LEGACY):
        return []
    return [(r["프로세스"], r["종류"][0], toks(r["내용"]), r)
            for r in csv.DictReader(open(LEGACY, encoding="utf-8"))]


def legacy_match(pid, kind, text, idx, col, floor=3):
    t = toks(text)
    best, score = None, 0
    for lp, lk, ltoks, r in idx:
        if lp != pid or lk != kind:
            continue
        s = len(t & ltoks)
        if s > score:
            best, score = r, s
    return best[col] if best and score >= floor else ""


def owner_from_ledger(rids, led):
    names = []
    for rid in rids:
        if "~" in rid:
            continue
        o = led.get(rid, "")
        if o and o not in names:
            names.append(o)
    return " ; ".join(names)


def main():
    led = ledger_owners()
    legacy = legacy_index()

    # --- 1차: §5 항목 수집 + ① 원장 판정 --------------------------------------
    items = []
    for f in sorted(glob.glob(os.path.join(PROCDIR, "P*.md"))):
        pid = os.path.basename(f).split("-")[0]
        body = open(f, encoding="utf-8").read()
        s4, s4_rids = parse_section4(body)
        s6 = parse_section6(body)
        for kind, title, rest, raw in parse_section5(body):
            text = f"{title} {rest}".strip()
            rids = list(dict.fromkeys(RID.findall(raw)))
            owner = owner_from_ledger(rids, led)
            basis = (f"① 원장 owner_proposed({'·'.join(r for r in rids if r in led)})"
                     if owner else "")
            # ①표 — 「(이 프로세스의) N행 전부」처럼 항목이 원장 행을 통째로 가리키는 경우:
            #        §4 단계표에 적힌 row_id 전체의 owner_proposed 를 옮긴다.
            if not owner and re.fullmatch(r"[^.·]{0,30}(전부|전건)\.?", text) and s4_rids:
                owner = owner_from_ledger(s4_rids, led)
                if owner:
                    rids = list(s4_rids)
                    basis = f"①표 §4 단계표 row_id {len(s4_rids)}개의 원장 owner_proposed(항목이 「전부」)"
            items.append(dict(pid=pid, kind=kind, title=title, rest=rest, text=text,
                              rids=rids, owner=owner, basis=basis, s4=s4, s6=s6))

    # --- 2차: ② 프로세스 문서 안의 담당 표기 ----------------------------------
    for it in items:
        if it["owner"]:
            continue
        m = OWNER_HINT.search(it["text"])
        if m:
            it["owner"], it["basis"] = m.group(1), "②본문 §5 항목 셀의 담당 표기"
            continue
        o = best_match(it["text"], it["s4"])
        if o:
            it["owner"], it["basis"] = o, "②단계표 §4 최근접 단계의 담당자"
            continue
        o = best_match(it["text"], it["s6"])
        if o:
            it["owner"], it["basis"] = o, "②채우는방법 §6 최근접 줄의 누가"

    # --- 3차: ②교차 — 같은 결정·같은 공백이 다른 프로세스에서 이미 판정됐는가 ----
    #     원천은 ①·② 로 확정된 항목뿐이다(교차에서 교차로 이어붙이지 않는다).
    resolved = [(toks(it["text"]), it["kind"], it["owner"], it["pid"], it["basis"][0])
                for it in items if it["owner"]]
    for it in items:
        if it["owner"]:
            continue
        t, best, score, src, sb = toks(it["text"]), "", 0, "", ""
        for rtoks, rkind, rowner, rpid, rb in resolved:
            if rkind != it["kind"]:
                continue
            s = len(t & rtoks)
            if s > score:
                best, score, src, sb = rowner, s, rpid, rb
        if score >= 3:
            it["owner"] = best
            it["basis"] = f"②교차 {src} 의 동일 항목({sb} 판정)에서 승계"

    # --- 4차: ②옛65행 → ③ 미정 -----------------------------------------------
    for it in items:
        if it["owner"]:
            continue
        o = legacy_match(it["pid"], it["kind"], it["text"], legacy, "제안_담당")
        if o:
            it["owner"], it["basis"] = o, "②옛65행 curated 담당 승계"
            continue
        it["owner"] = "미정"
        it["basis"] = ("③ 근거 없음 — 원장 행이 없고 §4 단계표·§6 채우는 방법·다른 프로세스의 "
                       "동일 항목·옛 65행 어디에도 이 항목의 담당 표기가 없다")

    out = []
    for n, it in enumerate(items, 1):
        body_txt = f"{it['title']} — {it['rest']}" if it["rest"] and it["rest"] != it["title"] else it["title"]
        out.append({
            "gap_id": f"G-{n:03d}",
            "프로세스": it["pid"],
            "종류": KIND[it["kind"]],
            "내용": body_txt[:400],
            "제안_담당": it["owner"],
            "담당_근거": it["basis"],
            "선행": legacy_match(it["pid"], it["kind"], it["text"], legacy, "선행"),
            "관련_row_id": ";".join(it["rids"]) or "—",
        })

    cols = ["gap_id", "프로세스", "종류", "내용", "제안_담당", "담당_근거", "선행", "관련_row_id"]
    with open(OUT, "w", encoding="utf-8", newline="") as fh:
        w = csv.DictWriter(fh, fieldnames=cols, lineterminator="\n")
        w.writeheader()
        w.writerows(out)

    c = collections.Counter(r["종류"][0] for r in out)
    rule = collections.Counter(r["담당_근거"][0] for r in out)
    sub = collections.Counter(r["담당_근거"].split(" ")[0] for r in out)
    print(f"gaps.csv — {len(out)}건 " + " · ".join(f"{k} {c[k]}" for k in "가나다라"))
    print("담당 규칙별 — " + " · ".join(f"{k} {rule[k]}" for k in "①②③"))
    print("  세부 — " + " · ".join(f"{k} {v}" for k, v in sorted(sub.items())))
    print(f"공란 {sum(1 for r in out if not r['제안_담당'].strip())} · "
          f"미정 {sum(1 for r in out if r['제안_담당'] == '미정')} · "
          f"선행 승계 {sum(1 for r in out if r['선행'])}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
