#!/usr/bin/env python3
# t57 검산기 — C1·C2·C3·C3b·C4~C8 총 9게이트. 읽기전용(대상 저장소·원장 모두 열기만 한다).
#   $ python3 t57/verify.py      (08_system-screen 에서 실행)
import csv, collections, os, re, sys

HERE = os.path.dirname(os.path.abspath(__file__))
BASE = os.path.dirname(HERE)                       # 08_system-screen
MD = os.path.join(HERE, "connect-design.md")
HTML = os.path.join(HERE, "connect-design.html")

# 인용 경로를 해소할 루트들(전부 읽기전용).
ROOTS = {
    "yeolim": "/Users/innojini/Dev/CRT.DigitalEdit.V2",
    "huni-mes": "/Users/innojini/Dev/TS.BackOffice.Huni",
    "skin": "/Users/innojini/Dev/huni-skin-shopby",
    "webadmin": "/Users/innojini/Dev/HuniWeb",          # raw/webadmin/**
    "workspace": os.path.dirname(os.path.dirname(BASE)),  # _workspace/**
}

fails = []


def gate(ok, name, msg):
    print(("PASS " if ok else "FAIL ") + name + " — " + msg)
    if not ok:
        fails.append(name)


md = open(MD, encoding="utf-8").read()
html = open(HTML, encoding="utf-8").read()

# ── C1 네 층 구조 ────────────────────────────────────────────────
layers_md = [l for l in ("# L0 ", "# L1 ", "# L2 ", "# L3 ") if l in md]
layers_html = [l for l in ('id="l0"', 'id="l1"', 'id="l2"', 'id="l3"') if l in html]
gate(len(layers_md) == 4 and len(layers_html) == 4, "C1 네 층 구조",
     f"md {len(layers_md)}/4 · html {len(layers_html)}/4")

# ── C2 이음매 10개 전수 · 상태값 4값 ─────────────────────────────
MARKS = "①②③④⑤⑥⑦⑧⑨⑩"
missing_md = [m for m in MARKS if m not in md]
missing_html = [m for m in MARKS if m not in html]
bad_state = [s for s in re.findall(r'class="pill p-(\w+)"', html)
             if s not in ("ok", "part", "new", "unk")]
gate(not missing_md and not missing_html and not bad_state, "C2 이음매 10 전수",
     f"md 누락 {missing_md or 0} · html 누락 {missing_html or 0} · 상태값 이탈 {bad_state or 0}")

# ── C3 path:line 인용 실재 ──────────────────────────────────────
CITE = re.compile(r'([A-Za-z0-9_./\-]+\.(?:cs|py|js|ts|config|csproj|sln|yaml|md|html|csv))'
                  r':(\d+)(?:-(\d+))?')


SKIPDIRS = {".git", "obj", "bin", "node_modules", ".next", "packages", "venv", ".venv"}
_index = None


def build_index():
    """루트별 파일 색인. 인용을 '경로 꼬리'로 유일 해소하기 위한 것."""
    idx = collections.defaultdict(list)
    for r in ROOTS.values():
        for dirpath, dirnames, filenames in os.walk(r):
            dirnames[:] = [d for d in dirnames if d not in SKIPDIRS and not d.startswith(".")]
            for fn in filenames:
                idx[fn].append(os.path.join(dirpath, fn))
    return idx


def resolve(path):
    """전체경로 또는 '경로 꼬리'로 **유일** 해소되면 절대경로.
    둘 이상에 걸리거나 파일명만 적힌 인용은 None = 축약·검산 대상 밖
    (t54 교훈: 추정 해소는 없는 결함을 만들어 낸다)."""
    global _index
    if path.startswith("/"):
        return path if os.path.isfile(path) else None
    for r in ROOTS.values():                          # 루트 기준 상대경로
        cand = os.path.join(r, path)
        if os.path.isfile(cand):
            return cand
    if "/" not in path:
        return None                                   # 파일명만 = 축약
    if _index is None:
        _index = build_index()
    tail = "/" + path
    hits = [p for p in _index.get(os.path.basename(path), []) if p.endswith(tail)]
    return hits[0] if len(hits) == 1 else None


checked = skipped = 0
bad = []
seen = set()
for src, text in (("md", md), ("html", html)):
    for path, a, b in CITE.findall(text):
        key = (path, a, b)
        if key in seen:
            continue
        seen.add(key)
        full = resolve(path)
        if full is None:
            skipped += 1
            continue
        n = sum(1 for _ in open(full, encoding="utf-8", errors="replace"))
        hi = int(b or a)
        checked += 1
        if hi > n or int(a) < 1:
            bad.append(f"{path}:{a}-{b or a} (파일 {n}줄)")
gate(not bad, "C3 인용 실재",
     f"유일해소·통과 {checked} / 축약(승격표로 회수) {skipped} / 초과·부존재 {len(bad)}"
     + (" :: " + "; ".join(bad) if bad else ""))

# ── C3b 인용 승격표 — 축약을 전체경로로 회수한다 ─────────────────
# md 의 승격표에서 전체경로를 걷는다: | `축약` | `/절대/경로` |
PROMO = re.compile(r"^\|[^|\n]*\|\s*`(/[^`]+)`\s*\|", re.M)
promoted = PROMO.findall(md)
missing_file = [p for p in promoted if not os.path.isfile(p)]
# 본문 축약 전건이 승격표로 회수되는가
uncovered = []
for path, a, b in sorted(set(CITE.findall(md + html))):
    if resolve(path) is not None:
        continue                                      # 이미 유일해소됨
    bn = os.path.basename(path)
    if not any(p.endswith("/" + path) or os.path.basename(p) == bn for p in promoted):
        uncovered.append(path)
gate(promoted and not missing_file and not uncovered, "C3b 인용 승격표",
     f"승격 {len(promoted)}건 · 실재하지 않는 경로 {missing_file or 0} · 회수 못 한 축약 {uncovered or 0}")

# ── C4 원장 수치 재계산 대조 ────────────────────────────────────
rows = list(csv.DictReader(open(os.path.join(BASE, "t51", "merged.csv"), encoding="utf-8")))
bysys = collections.defaultdict(collections.Counter)
for x in rows:
    bysys[x["system"]][x["status"]] += 1
DOC = {   # 문서가 적은 값 (system: 완료·진행·미착수·미확인·계)
    "webadmin": (146, 0, 0, 1, 147), "widget": (128, 2, 0, 3, 133),
    "mes": (77, 0, 11, 0, 88), "huni-mall": (31, 50, 94, 2, 177),
    "shopby": (9, 8, 55, 22, 94), "edicus": (13, 3, 4, 3, 23),
    "pagebuilder": (0, 1, 44, 17, 62), "pitstop": (0, 0, 23, 0, 23),
}
mism = []
for s, (c, p, m, u, tot) in DOC.items():
    got = bysys[s]
    real = (got["완료"], got["진행"], got["미착수"], got["미확인"], sum(got.values()))
    if real != (c, p, m, u, tot):
        mism.append(f"{s} 문서{(c,p,m,u,tot)} != 실제{real}")
wt = collections.Counter(x["work_type"] for x in rows)
sc = collections.Counter(x.get("scope", "") for x in rows)
if len(rows) != 747:
    mism.append(f"총행수 문서747 != 실제{len(rows)}")
for k, v in (("build", 378), ("integrate", 229), ("config", 99), ("provided", 35), ("manual", 6)):
    if wt[k] != v:
        mism.append(f"work_type {k} 문서{v} != 실제{wt[k]}")
for k, v in (("in", 683), ("out", 64)):
    if sc[k] != v:
        mism.append(f"scope {k} 문서{v} != 실제{sc[k]}")
gate(not mism, "C4 원장 수치",
     f"행 {len(rows)} · 시스템 {len(DOC)}개 대조" + (" :: " + "; ".join(mism) if mism else " 전건 일치"))

# ── C5 담당 열 정합 ────────────────────────────────────────────
# [게이트 교체 260919] 초판 C5 = 「담당 배정 문구 0」(t56 대기 중이라 배정 자체를 금지).
# t56(5bb97cfd) 이 닫혀 담당 열이 들어왔으므로 그대로 두면 이 게이트가 FAIL 한다.
# 새 C5 = ① 이음매 10행 전건에 담당 값이 있는가 ② 값이 지니 확정 4경계 + 허용 상태어 안인가
#         ③ t56 이 실제로 그 값을 판정했는가(문서가 지어내지 않았는가).
BOUNDARY = {"서희항", "김동학", "최숙진", "신우진"}          # 지니 확정 260919
STATE_OK = {"미정", "외부(상대측 회신 대기)", "대표(구매)"}   # 사람이 아니라 상태 — 그대로 둔다
c5 = []

# ① L1 담당 열 — md 표에서 이음매 10행의 담당 칸을 읽는다
L1ROW = re.compile(r"^\|\s*([①-⑩])\s*\|(?:[^|\n]*\|){4}\s*([^|\n]+?)\s*\|", re.M)
l1 = dict(L1ROW.findall(md))
if len(l1) != 10:
    c5.append(f"L1 담당 칸을 읽은 이음매 {len(l1)}/10")

# ② 이름 토큰이 경계 안인가
names = set()
KNOWN = BOUNDARY | STATE_OK
for mark, cell in l1.items():
    plain = re.sub(r"[*`⚠]", "", cell)
    found = {n for n in KNOWN if n in plain}
    if not found:
        c5.append(f"{mark} 담당 칸에서 경계 안 값을 못 찾음: {cell[:40]!r}")
    names |= found
    # 경계 밖 사람 이름이 섞였는가 — 한글 2~4자 토큰 중 아는 값이 아닌 것
    for tok in re.findall(r"[가-힣]{2,4}", plain):
        if tok in KNOWN or any(tok in n for n in found):
            continue
        if tok.endswith(("항", "학", "진")) and len(tok) == 3:   # 사람 이름 꼴
            c5.append(f"{mark} 경계 밖 사람 이름 의심 {tok!r}")

# ③ t56 이 실제로 판정한 값인가 — rejudge.csv 의 owner 집합에 들어 있어야 한다
T56 = ("/Users/innojini/Dev/HuniWeb/.claude/worktrees/t56/_workspace/"
       "huni-launch-runway/08_system-screen/t56/rejudge.csv")
if os.path.isfile(T56):
    t56owners = set()
    for r in csv.DictReader(open(T56, encoding="utf-8")):
        for k in ("owner_proposed", "owner_now"):
            for part in (r.get(k) or "").split("+"):
                if part.strip():
                    t56owners.add(part.strip())
    unbacked = {n for n in names if n not in t56owners}
    if unbacked:
        c5.append(f"t56 이 판정하지 않은 담당 값 {unbacked}")
else:
    c5.append("t56 rejudge.csv 를 찾지 못했다(담당 근거 대조 불가)")

gate(not c5, "C5 담당 열 정합",
     f"이음매 {len(l1)}/10 · 등장 담당 {sorted(names)}"
     + (" :: " + "; ".join(c5) if c5 else " · 4경계+상태어 이탈 0 · t56 미근거 0"))

# ── C6 날짜·작업량 추정 0 ───────────────────────────────────────
# 실재 근거일(9/8·260919 등)은 허용. 금지 = 소요기간·D-day·인월 추정.
ESTIM = re.compile(r"\d+\s*(?:영업일|인일|인월|man-?day)"
                   r"|\d+\s*[~-]\s*\d+\s*일\s*(?:소요|예상|걸)"
                   r"|약\s*\d+\s*(?:일|주|개월)\s*(?:소요|예상)"
                   # D-day 표기. plan_row_id(STD-ORD-030 등)의 꼬리에 걸리지 않게 앞을 막는다
                   r"|(?<![A-Za-z0-9])D[-+]\d+")
hit6 = ESTIM.findall(md) + ESTIM.findall(html)
gate(not hit6, "C6 날짜·작업량 추정 0", f"추정 표현 {len(hit6)}건 {hit6[:5]}")

# ── C7 자격증명 값 전사 0 ───────────────────────────────────────
SECRET = re.compile(r"AKIA[0-9A-Z]{12,}"                      # AWS 액세스키
                    r"|aws_secret[^\n]{0,4}[:=]\s*\S{16,}"
                    r"|(?<![\w.])\d{12}(?![\w.])"             # AWS 계정번호
                    r"|sqs\.[a-z0-9-]+\.amazonaws\.com/\d+", re.I)
hit7 = SECRET.findall(md) + SECRET.findall(html)
gate(not hit7, "C7 자격증명 전사 0", f"의심 토큰 {len(hit7)}건 (키 이름·파일 위치만 적는다)")

# ── C8 md ↔ html 핵심 수치 일치 ────────────────────────────────
pair_mism = [k for k in ("747", "753", "1,357") if (k in md) != (k in html)]
# 열림 코드가 status 근거가 아니라는 [HARD] 경고가 양쪽에 있어야 한다
for tag in ("열림", "미착수", "판정하지 않는다"):
    if (tag in md) != (tag in html):
        pair_mism.append(tag)
gate(not pair_mism, "C8 md↔html 정합", f"불일치 {pair_mism or 0}")

print()
print(f"총 {9 - len(fails)}/9 게이트 통과" + (f" · FAIL: {fails}" if fails else ""))
sys.exit(1 if fails else 0)
