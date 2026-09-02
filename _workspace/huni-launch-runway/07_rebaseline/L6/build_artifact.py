#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
L6 · 인터랙티브 아티팩트 생성기
원장 + 게이트 + 시나리오 + X·P 트랙 + 의존 그래프 → 단일 HTML(runway-dashboard.html).

재실행: 원장 경로만 바꾸면 된다.
    python3 L6/build_artifact.py --ledger L5/P1/unified-ledger-v2.csv
"""
import argparse
import csv
import datetime as _dt
import json
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
REBASE = os.path.dirname(HERE)
REPO = os.path.abspath(os.path.join(REBASE, "..", "..", ".."))

DEF_LEDGER = os.path.join(REBASE, "L5", "unified-ledger-assigned.csv")
DEF_GATES = os.path.join(REBASE, "L5", "O2", "gates.md")
DEF_DEP = os.path.join(REBASE, "L5", "O2", "dep-graph.json")
DEF_SCEN = os.path.join(REBASE, "L5", "O1", "scenario-matrix.csv")
DEF_XP = os.path.join(REBASE, "L5", "O3", "xp-track.csv")
DEF_CLOSE = os.path.join(REBASE, "L5", "O3", "close-pack")
DEF_OUT = os.path.join(HERE, "runway-dashboard.html")

OPEN_DAY = _dt.date(2026, 10, 6)
MERMAID_CDN = "https://cdnjs.cloudflare.com/ajax/libs/mermaid/10.9.1/mermaid.min.js"

STATUS_KO = {"done": "완료", "partial": "진행중", "todo": "미착수",
             "new": "신규발견", "미판정": "미판정"}


def rd(path):
    with open(path, encoding="utf-8-sig", newline="") as fh:
        return list(csv.DictReader(fh))


def g(row, key, limit=None):
    v = (row.get(key) or "").strip()
    return v[:limit] if limit else v


# ── 게이트 파싱 (build_xlsx.py 와 같은 규칙) ────────────────────────────
def parse_gates(path):
    if not os.path.exists(path):
        return []
    text = open(path, encoding="utf-8").read()
    goals = {}
    for m in re.finditer(r"^(G\d)\s+\S+\s+(.*?)\s*─\s*(.+)$", text, flags=re.M):
        goals[m.group(1)] = m.group(3).strip()

    def clean(line):
        one = re.sub(r"^\d+\.\s*", "", line.strip()).replace("`", "")
        one = re.sub(r"\*\*|\*", "", one).strip(" .·—")
        return one

    blocks = re.split(r"^### (G\d) — ", text, flags=re.M)
    out = []
    for i in range(1, len(blocks), 2):
        gid, body = blocks[i], blocks[i + 1]
        head = body.splitlines()[0]
        m = re.search(r"\((\d{4}-\d{2}-\d{2})[^)]*\)", head)
        date = m.group(1) if m else ""
        title = re.sub(r"\s*\(.*", "", head).replace("★", "").strip()

        def grab(marker):
            parts = re.split(marker, body, maxsplit=1)
            if len(parts) < 2:
                return []
            items = []
            for line in parts[1].splitlines():
                if line.startswith(("### ", "## ")) or re.match(r"^\*\*(진입|이탈)", line):
                    break
                if re.match(r"^\d+\.\s", line.strip()):
                    c = clean(line)
                    if c:
                        items.append(c)
            return items

        out.append({
            "id": gid, "title": title, "date": date, "goal": goals.get(gid, "—"),
            "entries": grab(r"\*\*진입 조건\*\*"),
            "exits": grab(r"\*\*이탈 조건[^*]*\*\*"),
        })
    return out


# ── mermaid ────────────────────────────────────────────────────────────
def esc_label(text):
    """mermaid 노드 라벨 이스케이프 — 줄바꿈은 반드시 <br/> 형태."""
    t = text.replace('"', "'").replace("\n", "<br/>")
    t = re.sub(r"<br\s*>", "<br/>", t)
    t = re.sub(r"<br\s*/\s*>", "<br/>", t)
    return t


def build_mermaid(dep, gates):
    nodes = {n["id"]: n for n in dep.get("nodes", [])}
    cp = dep.get("critical_path_to_G5", [])
    lines = ["flowchart LR"]
    blockers = ["EXT-PG", "EXT-MES", "EXT-NHN", "EXT-EDICUS", "EXT-OLDDB"]
    lines.append("  subgraph EXT[\"외부 의존 — 우리 손으로 못 닫는 것\"]")
    for b in blockers:
        n = nodes.get(b)
        if not n:
            continue
        lab = esc_label(n["label"].split(" (")[0] + "<br/>" + (n.get("grade") or ""))
        lines.append(f'    {b.replace("-", "_")}["{lab}"]')
    lines.append("  end")
    gate_map = {x["id"]: x for x in gates}
    for gd in gates:
        lab = esc_label(f"{gd['id']} {gd['date']}<br/>{gd['title']}<br/>이탈 {len(gd['exits'])}건")
        lines.append(f'  {gd["id"]}["{lab}"]')
    for a, b in zip(gates, gates[1:]):
        lines.append(f"  {a['id']} --> {b['id']}")
    # 임계경로: 외부 → 게이트
    hook = {"EXT-PG": "G0", "EXT-NHN": "G2", "EXT-MES": "G4",
            "EXT-EDICUS": "G1", "EXT-OLDDB": "G2"}
    for b, tgt in hook.items():
        if b in nodes and tgt in gate_map:
            lines.append(f'  {b.replace("-", "_")} -.차단.-> {tgt}')
    if cp:
        lines.append(f'  %% critical_path_to_G5 = {" > ".join(cp)}')
    lines.append("  classDef ext fill:#FDECEC,stroke:#C0392B,color:#7B241C;")
    lines.append("  classDef gate fill:#EEEAF8,stroke:#5538B6,color:#351D87;")
    lines.append("  class " + ",".join(b.replace("-", "_") for b in blockers if b in nodes) + " ext;")
    lines.append("  class " + ",".join(x["id"] for x in gates) + " gate;")
    return "\n".join(lines)


def html_escape_mermaid(src):
    """[HARD] <pre class=mermaid> 안에서는 &lt;br/&gt; 로 넣어야 한다.
    날것 <br/> 를 넣으면 HTML 파서가 진짜 BR 태그로 먹어 textContent 에서 사라지고,
    노드 라벨이 줄바꿈 없이 붙어 버린다(2026-09-02 실측)."""
    return src.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")


def check_mermaid(src):
    """완료조건 ⑤ — <br/> 이스케이프 검증."""
    bad = re.findall(r"<br(?!/>)[^>]*>", src)
    raw_amp = re.findall(r"&(?!amp;|lt;|gt;|quot;|#)", src)
    print("\n[검산 ⑤] mermaid <br/> 이스케이프")
    print(f"  <br/> 사용 {src.count('<br/>')}회 · 비정규 <br...> {len(bad)}건 → {'✓' if not bad else '✗ ' + str(bad[:3])}")
    print(f"  미이스케이프 & {len(raw_amp)}건 → {'✓' if not raw_amp else '✗'}")
    ok_q = '"' in src and not re.search(r'\["[^"]*"[^"]*"\]', src)
    print(f"  노드 라벨 따옴표 균형 → {'✓' if ok_q else '✗'}")
    return not bad and not raw_amp and ok_q


# ── HTML ───────────────────────────────────────────────────────────────
TPL = r"""<!doctype html>
<html lang="ko" data-theme="auto">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>후니 10/6 오픈 런웨이 — D-__DDAY__</title>
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap">
<style>
:root{
  --pri:#5538B6; --pri-d:#351D87; --pri-soft:#EEEAF8;
  --bg:#FFFFFF; --panel:#FBFAFE; --ink:#1B1633; --muted:#6B6580; --line:#CACACA;
  --ok:#177245; --ok-bg:#E8F5EE; --warn:#8A5A00; --warn-bg:#FDF3E0;
  --bad:#A32020; --bad-bg:#FBEAEA; --neu:#4A4A6A; --neu-bg:#EFEFF5;
}
:root:not([data-theme="light"]) { }
@media (prefers-color-scheme: dark){
  :root:not([data-theme="light"]){
    --bg:#141221; --panel:#1D1930; --ink:#ECEAF6; --muted:#9E98B8; --line:#3A3454;
    --pri:#9B85F0; --pri-d:#C3B4FF; --pri-soft:#26204A;
    --ok:#7BD6A4; --ok-bg:#173225; --warn:#E8BE72; --warn-bg:#332714;
    --bad:#F09A9A; --bad-bg:#3A1E1E; --neu:#B8B3CC; --neu-bg:#2A2540;
  }
}
:root[data-theme="dark"]{
  --bg:#141221; --panel:#1D1930; --ink:#ECEAF6; --muted:#9E98B8; --line:#3A3454;
  --pri:#9B85F0; --pri-d:#C3B4FF; --pri-soft:#26204A;
  --ok:#7BD6A4; --ok-bg:#173225; --warn:#E8BE72; --warn-bg:#332714;
  --bad:#F09A9A; --bad-bg:#3A1E1E; --neu:#B8B3CC; --neu-bg:#2A2540;
}
*{box-sizing:border-box}
body{margin:0;background:var(--bg);color:var(--ink);
  font-family:'Noto Sans KR',system-ui,-apple-system,'Malgun Gothic',sans-serif;font-size:13px;line-height:1.55}
header{position:sticky;top:0;z-index:20;background:var(--panel);border-bottom:1px solid var(--line);
  padding:10px 16px;display:flex;gap:14px;align-items:center;flex-wrap:wrap}
h1{font-size:15px;margin:0;color:var(--pri-d);font-weight:700}
.dday{background:var(--pri);color:#fff;border-radius:6px;padding:3px 10px;font-weight:700;font-size:13px}
.spacer{flex:1}
button,select,input[type=search]{font-family:inherit;font-size:12px;color:var(--ink);
  background:var(--bg);border:1px solid var(--line);border-radius:6px;padding:5px 10px;cursor:pointer}
button:hover{border-color:var(--pri)}
.kpis{display:grid;grid-template-columns:repeat(auto-fit,minmax(122px,1fr));gap:8px;padding:12px 16px}
.kpi{background:var(--panel);border:1px solid var(--line);border-radius:8px;padding:9px 11px}
.kpi b{display:block;font-size:19px;color:var(--pri-d);line-height:1.2}
.kpi span{color:var(--muted);font-size:11px}
nav{display:flex;gap:4px;padding:0 16px;border-bottom:1px solid var(--line);overflow-x:auto}
nav button{border:0;border-bottom:2px solid transparent;border-radius:0;background:none;padding:9px 13px;font-size:13px;white-space:nowrap}
nav button[aria-selected=true]{color:var(--pri-d);border-bottom-color:var(--pri);font-weight:700}
main{padding:14px 16px 60px}
.bar{display:flex;gap:6px;flex-wrap:wrap;align-items:center;margin-bottom:10px}
.chip{border:1px solid var(--line);border-radius:999px;padding:4px 11px;font-size:12px;background:var(--bg)}
.chip[aria-pressed=true]{background:var(--pri);border-color:var(--pri);color:#fff;font-weight:600}
.tblwrap{overflow-x:auto;border:1px solid var(--line);border-radius:8px}
table{border-collapse:collapse;width:100%;min-width:820px}
th{background:var(--pri-soft);color:var(--pri-d);text-align:left;padding:7px 9px;font-size:11.5px;
  position:sticky;top:0;border-bottom:1px solid var(--line);white-space:nowrap}
td{padding:6px 9px;border-bottom:1px solid var(--line);vertical-align:top}
tbody tr:hover{background:var(--pri-soft)}
.tag{display:inline-block;border-radius:4px;padding:1px 7px;font-size:11px;font-weight:600;white-space:nowrap}
.t-done{background:var(--ok-bg);color:var(--ok)} .t-partial{background:var(--warn-bg);color:var(--warn)}
.t-todo{background:var(--neu-bg);color:var(--neu)} .t-new{background:var(--pri-soft);color:var(--pri-d)}
.t-미판정{background:var(--bad-bg);color:var(--bad)}
.t-block{background:var(--bad-bg);color:var(--bad);border:1px solid var(--bad)}
.t-free{background:var(--neu-bg);color:var(--neu)}
tr.blocked td{background:var(--bad-bg)}
tr.blocked td:first-child{box-shadow:inset 3px 0 0 var(--bad)}
tbody tr.blocked:hover td{background:var(--warn-bg)}
.t-money{background:var(--bad-bg);color:var(--bad)} .t-order{background:var(--warn-bg);color:var(--warn)}
#t-ledger{table-layout:fixed;min-width:1180px}
#t-ledger th:nth-child(1),#t-ledger td:nth-child(1){width:34px}
#t-ledger th:nth-child(2),#t-ledger td:nth-child(2){width:112px}
#t-ledger th:nth-child(3),#t-ledger td:nth-child(3){width:132px}
#t-ledger th:nth-child(4),#t-ledger td:nth-child(4){width:auto}
#t-ledger th:nth-child(5),#t-ledger td:nth-child(5){width:78px}
#t-ledger th:nth-child(6),#t-ledger td:nth-child(6){width:82px}
#t-ledger th:nth-child(7),#t-ledger td:nth-child(7){width:88px}
#t-ledger th:nth-child(8),#t-ledger td:nth-child(8){width:92px}
#t-ledger th:nth-child(9),#t-ledger td:nth-child(9){width:340px}
.mono{font-family:ui-monospace,Menlo,Consolas,monospace;font-size:11px;color:var(--muted);word-break:break-all}
.gcard{border:1px solid var(--line);border-left:4px solid var(--pri);border-radius:8px;background:var(--panel);
  padding:11px 13px;margin-bottom:10px}
.gcard h3{margin:0 0 4px;font-size:14px;color:var(--pri-d)}
.gcard ol{margin:4px 0 0 18px;padding:0}
.gcard li{margin:2px 0}
.two{display:grid;grid-template-columns:1fr 1fr;gap:12px}
@media(max-width:760px){.two{grid-template-columns:1fr}}
.legend{color:var(--muted);font-size:11.5px;margin:6px 0 10px}
pre.mermaid{background:var(--panel);border:1px solid var(--line);border-radius:8px;padding:12px;overflow-x:auto}
.prog{height:8px;background:var(--neu-bg);border-radius:99px;overflow:hidden;margin-top:5px}
.prog>i{display:block;height:100%;background:var(--pri)}
a{color:var(--pri-d)}
.hidden{display:none!important}
.count{color:var(--muted);font-size:11.5px;margin-left:6px}
</style>
</head>
<body>
<header>
  <h1>후니 10/6 오픈 런웨이</h1>
  <span class="dday">D-__DDAY__</span>
  <span class="mono">원장 __N__행 · 생성 __STAMP__</span>
  <span class="spacer"></span>
  <button id="theme">🌗 테마</button>
  <button id="reset">체크 초기화</button>
</header>

<section class="kpis" id="kpis"></section>

<nav id="tabs">
  <button data-tab="ledger" aria-selected="true">원장 __N__</button>
  <button data-tab="gates" aria-selected="false">게이트 G0~G5</button>
  <button data-tab="scen" aria-selected="false">시나리오 __NSCEN__</button>
  <button data-tab="xp" aria-selected="false">X·P 트랙 __NXP__</button>
  <button data-tab="dep" aria-selected="false">의존·임계경로</button>
  <button data-tab="close" aria-selected="false">닫기팩</button>
</nav>

<main>
  <section id="tab-ledger">
    <div class="bar">
      <span class="mono">담당</span><span id="f-owner"></span>
      <span class="mono">상태</span><span id="f-status"></span>
    </div>
    <div class="bar">
      <span class="mono">차단 등급</span><span id="f-block"></span>
    </div>
    <div class="bar">
      <select id="f-major"></select>
      <button class="chip" id="f-money" aria-pressed="false">돈 Y</button>
      <button class="chip" id="f-order" aria-pressed="false">주문 Y</button>
      <button class="chip" id="f-unchecked" aria-pressed="false">안 닫힌 것만</button>
      <button class="chip" id="f-bank" aria-pressed="false" title="비고에 「무통장 선검증 가능」이 적힌 행만">무통장 선검증 가능</button>
      <input type="search" id="f-q" placeholder="기능·std_id·legacy_id 검색" style="min-width:230px">
      <span class="count" id="ledger-count"></span>
    </div>
    <div class="tblwrap"><table id="t-ledger">
      <thead><tr><th style="width:34px">✓</th><th>ID</th><th>영역</th><th>기능</th><th>담당</th><th>상태</th><th>차단</th><th>플래그</th><th>완료조건 / 근거</th></tr></thead>
      <tbody></tbody></table></div>
    <p class="legend">체크는 이 브라우저에만 남는다(localStorage). 키 = legacy_id, 없으면 std_id.</p>
  </section>

  <section id="tab-gates" class="hidden"></section>

  <section id="tab-scen" class="hidden">
    <div class="bar"><span class="mono">등급</span><span id="f-grade"></span>
      <span class="mono">게이트</span><span id="f-sgate"></span>
      <span class="count" id="scen-count"></span></div>
    <div class="tblwrap"><table id="t-scen">
      <thead><tr><th>ID</th><th>등급</th><th>게이트</th><th>단계</th><th>조작</th><th>기대결과</th><th>확인처</th><th>PG전</th></tr></thead>
      <tbody></tbody></table></div>
  </section>

  <section id="tab-xp" class="hidden">
    <div class="bar"><span class="mono">트랙</span><span id="f-track"></span>
      <span class="count" id="xp-count"></span></div>
    <div class="tblwrap"><table id="t-xp">
      <thead><tr><th>ID</th><th>트랙</th><th>성격</th><th>기능서술</th><th>의사결정자</th><th>오픈차단</th><th>플래그</th><th>근거</th></tr></thead>
      <tbody></tbody></table></div>
  </section>

  <section id="tab-dep" class="hidden">
    <pre class="mermaid">__MERMAID__</pre>
    <div class="two">
      <div><h3 style="color:var(--pri-d);font-size:13px">엣지 종류</h3>
        <div class="tblwrap"><table><thead><tr><th>종류</th><th>건수</th></tr></thead><tbody id="t-edge"></tbody></table></div></div>
      <div><h3 style="color:var(--pri-d);font-size:13px">차단 등급 외부 의존 (의존 그래프 노드)</h3>
        <div class="tblwrap"><table><thead><tr><th>ID</th><th>대상</th><th>등급</th></tr></thead><tbody id="t-ext"></tbody></table></div></div>
    </div>
    <p class="legend">임계경로(dep-graph.json critical_path_to_G5) = <span class="mono" id="cp"></span></p>
  </section>

  <section id="tab-close" class="hidden">
    <div class="tblwrap"><table><thead><tr><th>팩</th><th>파일</th><th>크기</th></tr></thead><tbody id="t-close"></tbody></table></div>
    <p class="legend">링크는 이 HTML 위치 기준 상대경로다.</p>
  </section>
</main>

<script src="__MERMAID_CDN__"></script>
<script>
/* mermaid 자동 실행을 먼저 끈다 — 켜져 있으면 숨은 탭의 도식을 그리다 좌표가 NaN 이 된다 */
if (window.mermaid) mermaid.initialize({ startOnLoad: false, flowchart: { htmlLabels: true } });
const DATA = __DATA__;
const LSKEY = 'huni-runway-checks';
let checks = {};
try { checks = JSON.parse(localStorage.getItem(LSKEY) || '{}') || {}; } catch (e) { checks = {}; }
const saveChecks = () => { try { localStorage.setItem(LSKEY, JSON.stringify(checks)); } catch (e) {} };
const keyOf = r => (r.legacy && r.legacy.trim()) ? r.legacy.trim() : r.id;
const esc = s => String(s == null ? '' : s).replace(/[&<>"]/g, c => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;'}[c]));

/* ── 테마 ── */
const themeBtn = document.getElementById('theme');
try { const t = localStorage.getItem('huni-runway-theme'); if (t) document.documentElement.dataset.theme = t; } catch (e) {}
themeBtn.onclick = () => {
  const cur = document.documentElement.dataset.theme;
  const next = cur === 'dark' ? 'light' : 'dark';
  document.documentElement.dataset.theme = next;
  try { localStorage.setItem('huni-runway-theme', next); } catch (e) {}
  renderMermaid(next);
};

/* ── 탭 ── */
document.querySelectorAll('#tabs button').forEach(b => b.onclick = () => {
  document.querySelectorAll('#tabs button').forEach(x => x.setAttribute('aria-selected', x === b));
  document.querySelectorAll('main > section').forEach(s => s.classList.add('hidden'));
  document.getElementById('tab-' + b.dataset.tab).classList.remove('hidden');
  /* mermaid 는 보이는 순간에만 그린다 — 숨은 상태에서 그리면 폭·높이가 0이라 좌표가 NaN 이 된다 */
  if (b.dataset.tab === 'dep') renderMermaid(document.documentElement.dataset.theme);
});

/* ── 필터 상태 ── */
const F = { owner: '전체', status: '전체', block: '전체', major: '전체', money: false, order: false, unchecked: false, bank: false, q: '' };
function chips(host, values, key, onChange) {
  const el = document.getElementById(host);
  el.innerHTML = '';
  values.forEach(v => {
    const b = document.createElement('button');
    b.className = 'chip'; b.textContent = v;
    b.setAttribute('aria-pressed', F[key] === v);
    b.onclick = () => { F[key] = v; chips(host, values, key, onChange); onChange(); };
    el.appendChild(b);
  });
}

/* ── 원장 ── */
const owners = ['전체', ...[...new Set(DATA.ledger.map(r => r.owner))].sort()];
const statuses = ['전체', '완료', '진행중', '미착수', '신규발견', '미판정'];
const majors = ['전체', ...[...new Set(DATA.ledger.map(r => r.major))]];
const selMajor = document.getElementById('f-major');
majors.forEach(m => { const o = document.createElement('option'); o.value = o.textContent = m; selMajor.appendChild(o); });
selMajor.onchange = () => { F.major = selMajor.value; drawLedger(); };
['money', 'order', 'unchecked', 'bank'].forEach(k => {
  const b = document.getElementById('f-' + k);
  b.onclick = () => { F[k] = !F[k]; b.setAttribute('aria-pressed', F[k]); drawLedger(); };
});
document.getElementById('f-q').oninput = e => { F.q = e.target.value.trim().toLowerCase(); drawLedger(); };

function filtered() {
  return DATA.ledger.filter(r => {
    if (F.owner !== '전체' && r.owner !== F.owner) return false;
    if (F.status !== '전체' && r.status !== F.status) return false;
    if (F.block !== '전체' && r.block !== F.block) return false;
    if (F.major !== '전체' && r.major !== F.major) return false;
    if (F.money && !r.money) return false;
    if (F.order && !r.order) return false;
    if (F.unchecked && checks[keyOf(r)]) return false;
    if (F.bank && !(r.note || '').includes('무통장 선검증 가능')) return false;
    if (F.q) {
      const hay = (r.fn + ' ' + r.id + ' ' + (r.legacy || '') + ' ' + r.minor).toLowerCase();
      if (!hay.includes(F.q)) return false;
    }
    return true;
  });
}
function drawLedger() {
  const rows = filtered();
  const tb = document.querySelector('#t-ledger tbody');
  tb.innerHTML = rows.map(r => {
    const k = keyOf(r);
    const flags = [];
    if (r.money) flags.push('<span class="tag t-money">돈</span>');
    if (r.order) flags.push('<span class="tag t-order">주문</span>');
    if (r.track && r.track !== '-') flags.push('<span class="tag t-todo">' + esc(r.track) + '</span>');
    const isBlocked = r.block === '차단(외부)';
    const blockTag = isBlocked ? '<span class="tag t-block">차단</span>'
      : (r.block === '오픈 무관' ? '<span class="tag t-free">무관</span>'
      : (r.block === '미판정' ? '<span class="tag t-미판정">미판정</span>' : '<span class="tag t-todo">작업</span>'));
    return '<tr class="' + (isBlocked ? 'blocked' : '') + '"><td><input type="checkbox" data-k="' + esc(k) + '"' + (checks[k] ? ' checked' : '') + '></td>' +
      '<td class="mono">' + esc(r.id) + (r.legacy ? '<br>' + esc(r.legacy) : '') + '</td>' +
      '<td>' + esc(r.major) + '<br><span class="mono">' + esc(r.minor) + '</span></td>' +
      '<td>' + esc(r.fn) + '</td>' +
      '<td>' + esc(r.owner) + '</td>' +
      '<td><span class="tag t-' + esc(r.statusCode) + '">' + esc(r.status) + '</span></td>' +
      '<td>' + blockTag + '</td>' +
      '<td>' + flags.join(' ') + '</td>' +
      '<td>' + (r.dc ? esc(r.dc) : '<span class="tag t-미판정">완료조건 미기재</span>') +
      '<div class="mono">' + esc(r.ev) + '</div></td></tr>';
  }).join('');
  tb.querySelectorAll('input[type=checkbox]').forEach(cb => cb.onchange = () => {
    checks[cb.dataset.k] = cb.checked;
    if (!cb.checked) delete checks[cb.dataset.k];
    saveChecks(); drawKpis(); if (F.unchecked) drawLedger();
  });
  document.getElementById('ledger-count').textContent = rows.length + ' / ' + DATA.ledger.length + '행';
}
const blockGrades = ['전체', ...['차단(외부)', '작업 항목', '오픈 무관', '미판정']
  .filter(b => DATA.ledger.some(r => r.block === b))];
chips('f-owner', owners, 'owner', drawLedger);
chips('f-status', statuses, 'status', drawLedger);
chips('f-block', blockGrades, 'block', drawLedger);

/* ── KPI ── */
function drawKpis() {
  const L = DATA.ledger;
  const cnt = s => L.filter(r => r.status === s).length;
  const done = L.filter(r => checks[keyOf(r)]).length;
  const pct = Math.round(done / L.length * 100);
  document.getElementById('kpis').innerHTML = [
    ['원장 전체', L.length + '행'],
    ['완료', cnt('완료')], ['진행중', cnt('진행중')], ['미착수', cnt('미착수')],
    ['신규발견', cnt('신규발견')], ['미판정', cnt('미판정')],
    ['돈 Y', L.filter(r => r.money).length], ['주문 Y', L.filter(r => r.order).length],
    ['차단(외부)', L.filter(r => r.block === '차단(외부)').length],
    ['오픈 무관', L.filter(r => r.block === '오픈 무관').length],
  ].map(([k, v]) => '<div class="kpi"><b>' + esc(v) + '</b><span>' + esc(k) + '</span></div>').join('') +
    '<div class="kpi"><b>' + pct + '%</b><span>내가 닫은 것 ' + done + '</span>' +
    '<div class="prog"><i style="width:' + pct + '%"></i></div></div>';
}

/* ── 게이트 ── */
document.getElementById('tab-gates').innerHTML = DATA.gates.map(gd =>
  '<div class="gcard"><h3>' + esc(gd.id) + ' · ' + esc(gd.date) + ' · ' + esc(gd.title) + '</h3>' +
  '<div class="legend">' + esc(gd.goal) + '</div><div class="two">' +
  '<div><b>진입 조건 ' + gd.entries.length + '</b><ol>' + gd.entries.map(x => '<li>' + esc(x) + '</li>').join('') + '</ol></div>' +
  '<div><b>이탈 조건 ' + gd.exits.length + '</b><ol>' + gd.exits.map(x => '<li>' + esc(x) + '</li>').join('') + '</ol></div>' +
  '</div></div>').join('');

/* ── 시나리오 ── */
const SG = { grade: '전체', gate: '전체' };
function drawScen() {
  const rows = DATA.scen.filter(s => (SG.grade === '전체' || s.grade === SG.grade) &&
    (SG.gate === '전체' || s.gate === SG.gate));
  document.querySelector('#t-scen tbody').innerHTML = rows.map(s =>
    '<tr><td class="mono">' + esc(s.id) + '</td><td><span class="tag t-new">' + esc(s.grade) + '</span></td>' +
    '<td>' + esc(s.gate) + '</td><td>' + esc(s.step) + '</td><td>' + esc(s.act) + '</td>' +
    '<td>' + esc(s.expect) + '</td><td class="mono">' + esc(s.where) + '</td>' +
    '<td>' + (s.pre === 'Y' ? '<span class="tag t-done">가능</span>' : '<span class="tag t-미판정">승인 후</span>') + '</td></tr>').join('');
  document.getElementById('scen-count').textContent = rows.length + ' / ' + DATA.scen.length + '건';
}
/* chips() 는 원장 필터 전용(F). 시나리오·X·P 는 자기 상태 객체를 쓰는 chipsFor 로 그린다. */
function chipsFor(host, values, obj, key, onChange) {
  const el = document.getElementById(host); el.innerHTML = '';
  values.forEach(v => {
    const b = document.createElement('button'); b.className = 'chip'; b.textContent = v;
    b.setAttribute('aria-pressed', obj[key] === v);
    b.onclick = () => { obj[key] = v; chipsFor(host, values, obj, key, onChange); onChange(); };
    el.appendChild(b);
  });
}
chipsFor('f-grade', ['전체', 'P0', 'P1', 'P2'], SG, 'grade', drawScen);
chipsFor('f-sgate', ['전체', ...[...new Set(DATA.scen.map(s => s.gate))].sort()], SG, 'gate', drawScen);

/* ── X·P ── */
const XT = { track: '전체' };
function drawXp() {
  const rows = DATA.xp.filter(x => XT.track === '전체' || x.track === XT.track);
  document.querySelector('#t-xp tbody').innerHTML = rows.map(x =>
    '<tr><td class="mono">' + esc(x.id) + '</td><td>' + esc(x.track) + '</td><td>' + esc(x.kind) + '</td>' +
    '<td>' + esc(x.desc) + '</td><td>' + esc(x.owner) + '</td>' +
    '<td>' + (x.block.indexOf('차단') === 0 ? '<span class="tag t-미판정">' + esc(x.block) + '</span>' : '<span class="tag t-todo">' + esc(x.block) + '</span>') + '</td>' +
    '<td>' + (x.money === 'Y' ? '<span class="tag t-money">돈</span> ' : '') + (x.order === 'Y' ? '<span class="tag t-order">주문</span>' : '') + '</td>' +
    '<td class="mono">' + esc(x.ev) + '</td></tr>').join('');
  document.getElementById('xp-count').textContent = rows.length + ' / ' + DATA.xp.length + '건';
}
chipsFor('f-track', ['전체', 'X', 'P'], XT, 'track', drawXp);

/* ── 의존 ── */
document.getElementById('t-edge').innerHTML = Object.entries(DATA.edgeKinds)
  .map(([k, v]) => '<tr><td class="mono">' + esc(k) + '</td><td>' + v + '</td></tr>').join('');
document.getElementById('t-ext').innerHTML = DATA.blockers
  .map(b => '<tr><td class="mono">' + esc(b.id) + '</td><td>' + esc(b.label) + '</td><td><span class="tag t-미판정">' + esc(b.grade) + '</span></td></tr>').join('');
document.getElementById('cp').textContent = DATA.criticalPath.join(' → ');

/* ── 닫기팩 ── */
document.getElementById('t-close').innerHTML = DATA.close
  .map(c => '<tr><td>' + esc(c.name) + '</td><td><a href="' + esc(c.href) + '">' + esc(c.href) + '</a></td><td class="mono">' + esc(c.size) + '</td></tr>').join('');

/* ── mermaid ── */
function renderMermaid(theme) {
  const isDark = theme === 'dark' || (theme !== 'light' &&
    window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches);
  const pre = document.querySelector('pre.mermaid');
  if (!pre || !window.mermaid) return;
  if (!pre.offsetParent) return;   /* 안 보이면 그리지 않는다 */
  if (!pre.dataset.src) pre.dataset.src = pre.textContent;
  pre.removeAttribute('data-processed');
  pre.innerHTML = pre.dataset.src;
  mermaid.initialize({ startOnLoad: false, theme: isDark ? 'dark' : 'default',
    securityLevel: 'loose', flowchart: { htmlLabels: true, nodeSpacing: 45, rankSpacing: 60 } });
  try { mermaid.run({ nodes: [pre] }); } catch (e) { pre.textContent = pre.dataset.src; }
}

document.getElementById('reset').onclick = () => {
  if (!confirm('체크를 전부 지운다. 계속?')) return;
  checks = {}; saveChecks(); drawLedger(); drawKpis();
};

drawKpis(); drawLedger(); drawScen(); drawXp();
</script>
</body>
</html>
"""


LEDGER_MD = """# LEDGER — D-34 재기준선 통합 원장 요약

> 기계 생성. 손으로 고치지 마라 — `L6/build_artifact.py` 를 다시 돌리면 덮어쓴다.
> 원장 원본: `{ledger_rel}` ({n}행)
> 생성: {stamp}

## 이 원장이 무엇인가

10/6 오픈까지 **누가 무엇을 언제까지 닫아야 하는가**를 한 파일에 모은 것이다.
34개 하네스 산출물을 F(기능)/P(상품데이터)/X(횡단) 3분모로 병합해 {n}행으로 정규화했다.

## 담당 × 상태

{owner_table}

## 대분류별 분포

{major_table}

## 오픈차단여부 × 담당

{block_table}

### 차단(외부) 전건 — 우리 손으로 못 닫는 것

{blocked_rows}

## 돈·주문 플래그

{flag_table}

## 게이트 (G0~G5)

{gate_table}

## 차단 등급 외부 의존 — 우리 손으로 못 닫는 것

{blocker_table}

## 열이 무슨 뜻인가

| 열 | 뜻 |
|---|---|
| `std_id` | 표준 항목 ID. **재실행해도 바뀌지 않는다**(대시보드 체크 상태가 이 값에 물린다) |
| `매핑legacy_id` | 병합 전 원본 ID(여럿이면 `;` 로 이어짐). 대시보드 체크 키는 **이 값 우선** |
| `상태` | done / partial / todo / new / 미판정 |
| `오픈차단여부` | **차단(외부)** = 우리 손으로 못 닫는다(상대 회신·심사 대기) · **작업 항목** = 짜면 닫힌다 · **오픈 무관** = 10/6 에 없어도 문 연다 · 미판정 |
| `담당` | PM · 인쇄개발 · 쇼핑개발 |
| `sub_track` | 쇼핑개발 내부 분리 — web / builder |
| `돈여부` `주문여부` | Y 면 값이 틀렸을 때 손해가 나거나 주문 흐름이 끊긴다 |
| `done_criteria` | 무엇이 되면 닫히는가. **현재 {dc_empty}행이 빈칸** — P1 이 전건 채운다 |
| `근거` | 파일:줄. 근거 없는 행은 이 원장에 들어올 수 없다 |

## 파일 경로

| 무엇 | 경로 |
|---|---|
| 원장 CSV (현재) | `{ledger_rel}` |
| 원장 JSON (O3 원본) | `L5/O3/unified-ledger.json` |
| **대시보드 데이터 JSON** | `L6/runway-data.json` (원장+게이트+시나리오+X·P+차단 합본) |
| 인터랙티브 대시보드 | `L6/runway-dashboard.html` |
| 엑셀 5시트 | `docs/huni/후니프린팅_통합IA_일정_역할분담_260902.xlsx` |
| 게이트 조건 원문 | `L5/O2/gates.md` |
| 의존 그래프 | `L5/O2/dep-graph.json` |
| 시나리오 | `L5/O1/scenario-matrix.csv` ({n_scen}건) |
| X·P 트랙 | `L5/O3/xp-track.csv` ({n_xp}건) |
| 닫기팩 | `L5/O3/close-pack/` |

## 다시 만들려면

```bash
cd _workspace/huni-launch-runway/07_rebaseline
python3 L6/build_xlsx.py --ledger <원장.csv> && python3 L6/build_artifact.py --ledger <원장.csv>
```
"""


def md_table(headers, rows):
    out = ["| " + " | ".join(headers) + " |",
           "|" + "|".join("---" for _ in headers) + "|"]
    for r in rows:
        out.append("| " + " | ".join(str(c) for c in r) + " |")
    return "\n".join(out)


def write_ledger_md(path, ledger, L, gates, blockers, S, X, ledger_path, stamp):
    owners = sorted({x["owner"] for x in L})
    states = [s for s in ["완료", "진행중", "미착수", "신규발견", "미판정"]
              if any(x["status"] == s for x in L)]
    orows = []
    for o in owners:
        mine = [x for x in L if x["owner"] == o]
        orows.append([o] + [sum(1 for x in mine if x["status"] == s) for s in states] + [len(mine)])
    orows.append(["**합계**"] + [sum(1 for x in L if x["status"] == s) for s in states] + [len(L)])
    owner_table = md_table(["담당"] + states + ["합계"], orows)

    majors = []
    for x in L:
        if x["major"] not in majors:
            majors.append(x["major"])
    mrows = [[m] + [sum(1 for x in L if x["major"] == m and x["status"] == s) for s in states]
             + [sum(1 for x in L if x["major"] == m)] for m in majors]
    major_table = md_table(["대분류"] + states + ["합계"], mrows)

    grades = [b for b in ["차단(외부)", "작업 항목", "오픈 무관", "미판정"]
              if any(x["block"] == b for x in L)]
    brows = []
    for o in owners:
        mine = [x for x in L if x["owner"] == o]
        brows.append([o] + [sum(1 for x in mine if x["block"] == b) for b in grades] + [len(mine)])
    brows.append(["**합계**"] + [sum(1 for x in L if x["block"] == b) for b in grades] + [len(L)])
    block_table = md_table(["담당"] + grades + ["합계"], brows)
    bl = [x for x in L if x["block"] == "차단(외부)"]
    blocked_rows = md_table(["std_id", "기능", "담당", "돈·주문"],
                            [[x["id"], x["fn"], x["owner"],
                              "·".join([t for t, k in (("돈", "money"), ("주문", "order")) if x[k]]) or "—"]
                             for x in bl]) if bl else "차단(외부) 0건."

    flag_table = md_table(["플래그", "건수", "뜻"], [
        ["돈여부 Y", sum(1 for x in L if x["money"]), "값이 틀리면 손해가 난다"],
        ["주문여부 Y", sum(1 for x in L if x["order"]), "주문 흐름에 닿는다"],
        ["둘 다 Y", sum(1 for x in L if x["money"] and x["order"]), "가장 비싼 구간"],
        ["차단(외부)", sum(1 for x in L if x["block"] == "차단(외부)"), "우리 손으로 못 닫는다 — 상대 회신·심사 대기"],
        ["상태 미판정", sum(1 for x in L if x["status"] == "미판정"), "P1 이 판정한다"],
        ["done_criteria 빈칸", sum(1 for x in L if not x["dc"]), "P1 이 채운다"],
    ])

    gate_table = md_table(["게이트", "날짜", "이름", "진입", "이탈", "목표"],
                          [[gd["id"], gd["date"], gd["title"], len(gd["entries"]),
                            len(gd["exits"]), gd["goal"]] for gd in gates])
    blocker_table = md_table(["ID", "대상"], [[b["id"], b["label"]] for b in blockers])

    open(path, "w", encoding="utf-8").write(LEDGER_MD.format(
        ledger_rel=os.path.relpath(ledger_path, REBASE), n=len(L), stamp=stamp,
        owner_table=owner_table, major_table=major_table, flag_table=flag_table,
        gate_table=gate_table, blocker_table=blocker_table,
        block_table=block_table, blocked_rows=blocked_rows,
        dc_empty=sum(1 for x in L if not x["dc"]), n_scen=len(S), n_xp=len(X)))


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--ledger", default=DEF_LEDGER)
    ap.add_argument("--gates", default=DEF_GATES)
    ap.add_argument("--dep", default=DEF_DEP)
    ap.add_argument("--scen", default=DEF_SCEN)
    ap.add_argument("--xp", default=DEF_XP)
    ap.add_argument("--close", default=DEF_CLOSE)
    ap.add_argument("--out", default=DEF_OUT)
    a = ap.parse_args()

    ledger = rd(a.ledger)
    gates = parse_gates(a.gates)
    dep = json.load(open(a.dep, encoding="utf-8"))
    scen = rd(a.scen)
    xp = rd(a.xp)

    L = []
    for r in ledger:
        code = g(r, "상태")
        L.append({
            "id": g(r, "std_id"), "legacy": g(r, "매핑legacy_id"),
            "major": g(r, "대분류"), "minor": g(r, "중분류"), "fn": g(r, "기능"),
            "owner": g(r, "담당"), "status": STATUS_KO.get(code, code), "statusCode": code,
            "money": g(r, "돈여부") == "Y", "order": g(r, "주문여부") == "Y",
            "track": g(r, "sub_track"), "dc": g(r, "done_criteria", 400),
            "block": g(r, "오픈차단여부") or "미판정",
            "note": g(r, "비고", 300),
            "ev": g(r, "근거", 220),
        })

    S = [{"id": g(s, "scn_id"), "grade": g(s, "등급"), "gate": g(s, "게이트"),
          "step": g(s, "단계"), "act": g(s, "조작", 200), "expect": g(s, "기대결과", 240),
          "where": g(s, "확인처", 120), "pre": g(s, "PG승인전가능")} for s in scen]

    X = [{"id": g(x, "legacy_id"), "track": g(x, "트랙"), "kind": g(x, "성격"),
          "desc": g(x, "기능서술", 200), "owner": g(x, "의사결정자"),
          "block": g(x, "오픈차단여부"), "money": g(x, "돈"), "order": g(x, "주문"),
          "ev": g(x, "근거", 140)} for x in xp]

    blockers = [{"id": n["id"], "label": n["label"], "grade": n.get("grade", "")}
                for n in dep.get("nodes", []) if n["kind"] == "external" and n.get("grade") == "차단"]

    close = []
    if os.path.isdir(a.close):
        for fn in sorted(os.listdir(a.close)):
            if fn.endswith(".md"):
                p = os.path.join(a.close, fn)
                close.append({"name": fn.split("-", 1)[0], "href": os.path.relpath(p, os.path.dirname(a.out)),
                              "size": f"{os.path.getsize(p) // 1024}KB"})

    mer = build_mermaid(dep, gates)
    ok5 = check_mermaid(mer)
    mer_html = html_escape_mermaid(mer)
    src_br_count = mer.count("<br/>")

    data = {"ledger": L, "gates": gates, "scen": S, "xp": X, "blockers": blockers,
            "edgeKinds": dep.get("counts", {}).get("edge_kind", {}),
            "criticalPath": dep.get("critical_path_to_G5", []), "close": close}

    html = (TPL
            .replace("__DDAY__", str((OPEN_DAY - _dt.date.today()).days))
            .replace("__N__", str(len(L)))
            .replace("__NSCEN__", str(len(S)))
            .replace("__NXP__", str(len(X)))
            .replace("__STAMP__", _dt.datetime.now().strftime("%Y-%m-%d %H:%M"))
            .replace("__MERMAID_CDN__", MERMAID_CDN)
            .replace("__MERMAID__", mer_html)
            .replace("__DATA__", json.dumps(data, ensure_ascii=False)))
    open(a.out, "w", encoding="utf-8").write(html)

    json_path = os.path.join(os.path.dirname(a.out), "runway-data.json")
    json.dump(data, open(json_path, "w", encoding="utf-8"), ensure_ascii=False, indent=1)
    stamp = _dt.datetime.now().strftime("%Y-%m-%d %H:%M")
    ledger_md = os.path.join(REBASE, "LEDGER.md")
    write_ledger_md(ledger_md, ledger, L, gates, blockers, S, X, a.ledger, stamp)
    print(f"[OK] {json_path}")
    print(f"[OK] {ledger_md}")

    print(f"\n[OK] {a.out}  ({len(html) // 1024}KB)")
    print("\n[검산 ②] 아티팩트 항목 수 = 원장 행 수")
    n_in_html = len(json.loads(re.search(r"const DATA = (\{.*?\});\n", html, re.S).group(1))["ledger"])
    print(f"  원장 {len(ledger)} · HTML 내 ledger {n_in_html} → {'✓ 일치' if n_in_html == len(ledger) else '✗'}")

    print("\n[검산 L6b] 오픈차단여부 → block 키")
    html_rows = json.loads(re.search(r"const DATA = (\{.*?\});\n", html, re.S).group(1))["ledger"]
    has_block = sum(1 for x in html_rows if x.get("block"))
    import collections as _c
    got = dict(_c.Counter(x["block"] for x in html_rows))
    want = dict(_c.Counter((g(r, "오픈차단여부") or "미판정") for r in ledger))
    print(f"  block 키 보유 {has_block}/{len(html_rows)}행 → {'✓' if has_block == len(ledger) else '✗'}")
    print(f"  분포 원장과 일치 → {'✓' if got == want else '✗'}  {got}")
    ok_b = (has_block == len(ledger) and got == want)

    print("\n[검산 ⑥] 원장에 없는 항목 창작 0")
    src = {g(r, "기능") for r in ledger}
    bad = [x["fn"] for x in L if x["fn"] not in src]
    print(f"  원장 밖 기능 문자열 {len(bad)}건 → {'✓' if not bad else '✗'}")

    pre_body = re.search(r'<pre class="mermaid">(.*?)</pre>', html, re.S).group(1)
    raw_br = re.findall(r"<br\s*/?>", pre_body)
    esc_br = pre_body.count("&lt;br/&gt;")
    print(f"  <pre> 안 이스케이프: &lt;br/&gt; {esc_br}회 · 날것 <br> {len(raw_br)}건 "
          f"→ {'✓' if (esc_br == src_br_count and not raw_br) else '✗'}")
    ok5 = ok5 and esc_br == src_br_count and not raw_br

    print("\n[검산 ·] 외부 CDN 화이트리스트 (cdnjs / jsdelivr / fonts)")
    urls = sorted(set(re.findall(r'https://[^"\')\s]+', html)))
    allow = ("cdnjs.cloudflare.com", "cdn.jsdelivr.net", "fonts.googleapis.com", "fonts.gstatic.com")
    for u in urls:
        mark = "✓" if any(d in u for d in allow) else "✗"
        print(f"  {mark} {u[:90]}")
    bad_urls = [u for u in urls if not any(d in u for d in allow)]

    sys.exit(0 if (ok5 and ok_b and n_in_html == len(ledger) and not bad and not bad_urls) else 1)


if __name__ == "__main__":
    main()
