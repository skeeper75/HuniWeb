#!/usr/bin/env python3
"""t64 — index.html 생성(단일 파일 · L0→L3 나무 + 프로세스별 그림 + 빠진 곳 배지)."""
import csv, json, os, re, sys

HERE = os.path.dirname(os.path.abspath(__file__))
TREE = os.path.join(HERE, "process-tree.csv")
GAPS = os.path.join(HERE, "gaps.csv")
PROCDIR = os.path.join(HERE, "processes")

sys.path.insert(0, HERE)
from assign import PROCESSES  # noqa: E402
PMETA = {x[0]: x for x in PROCESSES}

tree = list(csv.DictReader(open(TREE, encoding="utf-8")))
gaps = list(csv.DictReader(open(GAPS, encoding="utf-8")))

procs = {}
for r in tree:
    pid_full = r["L3_프로세스"]
    pid = pid_full.split("-")[0]
    p = procs.setdefault(pid, {
        "id": pid, "full": pid_full, "name": pid_full.split("-", 1)[1],
        "l1": PMETA[pid][2], "l2": PMETA[pid][3], "steps": [], "cross": PMETA[pid][5],
    })
    p["steps"].append({
        "row_id": r["L4_단계_row_id"], "title": r["기능"], "status": r["status"],
        "owner": r["owner_proposed"], "step": r["step"], "own": r["귀속"],
        "cross": r["cross"] if r["귀속"] == "cross" else "",
        "src": r["원장출처"],
    })

for pid, p in procs.items():
    g = [x for x in gaps if x["프로세스"] == pid]
    p["gaps"] = [{"id": x["gap_id"], "kind": x["종류"], "text": x["내용"],
                  "owner": x["제안_담당"], "prereq": x["선행"]} for x in g]
    path = os.path.join(PROCDIR, f"{p['full']}.md")
    body = open(path, encoding="utf-8").read() if os.path.exists(path) else ""
    # 1절의 한 줄 정의
    m = re.search(r"\*\*한 줄 정의\.\*\*\s*(.+)", body)
    p["oneline"] = re.sub(r"\*\*(.+?)\*\*", r"\1", m.group(1)).strip() if m else ""
    # mermaid 블록 2개(시퀀스·플로우)
    p["diagrams"] = re.findall(r"```mermaid\n(.*?)```", body, re.S)[:2]
    p["doc"] = f"processes/{p['full']}.md"

order = sorted(procs.values(), key=lambda x: x["id"])
DATA = json.dumps(order, ensure_ascii=False)

HTML = """<!DOCTYPE html>
<html lang="ko"><head><meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>주문 이후 생산·출고 프로세스</title>
<script src="https://cdn.jsdelivr.net/npm/mermaid@10.9.1/dist/mermaid.min.js"></script>
<style>
:root{--bg:#f7f7f5;--fg:#1c1b19;--mut:#6b6864;--line:#e0ddd8;--card:#fff;
--a:#8b5cf6;--bad:#ef4444;--warn:#f59e0b;--ok:#10b981;--acc:#2563eb}
:root:not([data-theme="light"]){}
@media(prefers-color-scheme:dark){:root:not([data-theme="light"]){--bg:#17161a;--fg:#ecebe8;
--mut:#9b9792;--line:#302e33;--card:#1f1e23}}
:root[data-theme="dark"]{--bg:#17161a;--fg:#ecebe8;--mut:#9b9792;--line:#302e33;--card:#1f1e23}
*{box-sizing:border-box}
body{margin:0;background:var(--bg);color:var(--fg);
font:15px/1.65 -apple-system,BlinkMacSystemFont,"Pretendard","Apple SD Gothic Neo",sans-serif}
.wrap{max-width:1180px;margin:0 auto;padding:32px 16px 96px}
h1{font-size:26px;margin:0 0 6px;letter-spacing:-.01em}
.sub{color:var(--mut);font-size:13px;margin-bottom:24px}
.stats{display:flex;flex-wrap:wrap;gap:8px;margin-bottom:28px}
.stat{background:var(--card);border:1px solid var(--line);border-radius:10px;padding:10px 14px}
.stat b{font-size:20px;display:block;line-height:1.2}
.stat span{font-size:11px;color:var(--mut)}
.tree{background:var(--card);border:1px solid var(--line);border-radius:12px;padding:18px;margin-bottom:28px}
.tree h2{font-size:14px;margin:0 0 12px;color:var(--mut);font-weight:600}
.l1{margin:10px 0 4px;font-weight:600;font-size:14px}
.l2{margin-left:14px;color:var(--mut);font-size:13px}
.l3s{margin:4px 0 0 28px;display:flex;flex-wrap:wrap;gap:6px}
.chip{border:1px solid var(--line);background:transparent;color:var(--fg);border-radius:999px;
padding:4px 11px;font-size:12px;cursor:pointer;font-family:inherit}
.chip:hover{border-color:var(--a)}
.chip.on{background:var(--a);border-color:var(--a);color:#fff}
.badge{display:inline-block;min-width:18px;text-align:center;border-radius:999px;
padding:1px 6px;font-size:10px;margin-left:5px;background:var(--bad);color:#fff}
.card{background:var(--card);border:1px solid var(--line);border-radius:12px;padding:20px;margin-bottom:16px}
.card h3{margin:0 0 4px;font-size:17px}
.one{color:var(--mut);font-size:13px;margin:0 0 14px}
.meta{font-size:11px;color:var(--mut);margin-bottom:12px}
.tag{border:1px solid var(--line);border-radius:5px;padding:1px 6px;margin-right:5px}
.tw{overflow-x:auto;-webkit-overflow-scrolling:touch}
.diag{background:var(--bg);border:1px solid var(--line);border-radius:8px;padding:10px;margin:10px 0;overflow-x:auto}
table{width:100%;border-collapse:collapse;font-size:12px;margin-top:8px}
th,td{text-align:left;padding:6px 8px;border-bottom:1px solid var(--line);vertical-align:top}
th{color:var(--mut);font-weight:600;font-size:11px}
td.rid{font-family:ui-monospace,SFMono-Regular,Menlo,monospace;font-size:11px;white-space:nowrap}
.s{border-radius:4px;padding:1px 6px;font-size:10px;white-space:nowrap}
.s-작동{background:var(--ok);color:#fff}
.s-부분{background:var(--warn);color:#17161a}
.s-미착수{background:var(--line);color:var(--mut)}
.s-미실측{background:var(--bad);color:#fff}
.s-없음{background:var(--bad);color:#fff}
.xr{opacity:.62}
.gp{margin-top:14px;border-top:1px solid var(--line);padding-top:12px}
.gp h4{margin:0 0 8px;font-size:12px;color:var(--mut)}
.g{font-size:12px;margin-bottom:7px;padding-left:10px;border-left:2px solid var(--line)}
.g .k{font-size:10px;border-radius:4px;padding:1px 5px;margin-right:6px}
.k가{background:#8b5cf6;color:#fff}.k나{background:var(--bad);color:#fff}
.k다{background:var(--warn);color:#17161a}.k라{background:var(--acc);color:#fff}
.g .w{color:var(--mut);font-size:11px}
a.doc{font-size:11px;color:var(--acc);text-decoration:none}
.hidden{display:none}
@media(max-width:640px){.wrap{padding:20px 16px 72px}h1{font-size:21px}table{font-size:11px}}
</style></head><body><div class="wrap">
<h1>주문 이후 생산·출고 프로세스</h1>
<p class="sub">t64 · 결제 → 접수 → 검판 → MES → 공정 → 출고 → 배송추적 · L0 후니 몰 전체 › L1 대분류 › L2 중분류 › L3 프로세스 › L4 단계=기능 행</p>
<div class="stats" id="stats"></div>
<div class="tree" id="tree"><h2>L0 후니 몰 전체 (huni-mall 독립몰 + 샵바이 + webadmin/위젯 + MES + Edicus + PitStop)</h2><div id="treeb"></div></div>
<div id="cards"></div>
</div>
<script>
const D = __DATA__;
const KIND = s => s.slice(0,1);
const esc = s => (s||"").replace(/[&<>]/g,c=>({"&":"&amp;","<":"&lt;",">":"&gt;"}[c]));

const own = D.flatMap(p=>p.steps.filter(s=>s.own==="담당").map(s=>s.row_id));
const uniq = [...new Set(own)];
const gapN = D.reduce((a,p)=>a+p.gaps.length,0);
document.getElementById("stats").innerHTML = [
  [uniq.length,"담당 기능 행"],[D.length,"프로세스"],[0,"미귀속"],[gapN,"빠진 곳"],
  [uniq.filter(r=>D.some(p=>p.steps.some(s=>s.row_id===r&&["미착수","없음","미실측"].includes(s.status)))).length,"미착수·없음·미실측"]
].map(([b,s])=>`<div class="stat"><b>${b}</b><span>${s}</span></div>`).join("");

const tb = {};
D.forEach(p=>{ (tb[p.l1] ||= {})[p.l2] ||= []; tb[p.l1][p.l2].push(p); });
document.getElementById("treeb").innerHTML = Object.entries(tb).map(([l1,l2s])=>
  `<div class="l1">${esc(l1)}</div>` + Object.entries(l2s).map(([l2,ps])=>
    `<div class="l2">${esc(l2)}</div><div class="l3s">` + ps.map(p=>
      `<button class="chip" data-p="${p.id}">${p.id} ${esc(p.name)}${p.gaps.length?`<span class="badge">${p.gaps.length}</span>`:""}</button>`
    ).join("") + `</div>`).join("")).join("");

document.getElementById("cards").innerHTML = D.map(p=>`
<div class="card" id="c-${p.id}">
  <h3>${p.id} · ${esc(p.name)}</h3>
  <p class="one">${esc(p.oneline)}</p>
  <div class="meta"><span class="tag">${esc(p.l1)}</span><span class="tag">${esc(p.l2)}</span>
    ${p.cross?`<span class="tag">cross ${esc(p.cross)}</span>`:""}
    <a class="doc" href="${p.doc}">문서 열기 →</a></div>
  ${p.diagrams.map(d=>`<div class="diag"><pre class="mermaid">${esc(d)}</pre></div>`).join("")}
  <div class="tw"><table><thead><tr><th>row_id</th><th>기능</th><th>상태</th><th>담당</th><th>step</th></tr></thead>
  <tbody>${p.steps.map(s=>`<tr class="${s.own==='cross'?'xr':''}">
    <td class="rid">${esc(s.row_id)}${s.cross?` <span class="tag">${esc(s.cross)}</span>`:""}</td>
    <td>${esc(s.title)}</td>
    <td><span class="s s-${esc(s.status||"미착수")}">${esc(s.status||"—")}</span></td>
    <td>${esc(s.owner)}</td><td>${esc(s.step)}</td></tr>`).join("")}</tbody></table></div>
  ${p.gaps.length?`<div class="gp"><h4>빠진 곳 ${p.gaps.length}건</h4>${p.gaps.map(g=>
    `<div class="g"><span class="k k${KIND(g.kind)}">${esc(g.kind)}</span>${esc(g.text)}
     <div class="w">${esc(g.id)} · 제안 담당 ${esc(g.owner)} · 선행 ${esc(g.prereq)}</div></div>`).join("")}</div>`:""}
</div>`).join("");

let sel = null;
document.getElementById("treeb").addEventListener("click", e=>{
  const b = e.target.closest(".chip"); if(!b) return;
  const id = b.dataset.p;
  document.querySelectorAll(".chip").forEach(c=>c.classList.toggle("on", c===b && sel!==id));
  sel = sel===id ? null : id;
  D.forEach(p=>document.getElementById("c-"+p.id).classList.toggle("hidden", !!sel && sel!==p.id));
  if(sel) document.getElementById("c-"+sel).scrollIntoView({behavior:"smooth",block:"start"});
});

const dark = matchMedia("(prefers-color-scheme: dark)").matches;
mermaid.initialize({startOnLoad:true, theme: dark?"dark":"neutral", securityLevel:"loose"});
</script></body></html>
"""

open(os.path.join(HERE, "index.html"), "w", encoding="utf-8").write(HTML.replace("__DATA__", DATA))
print(f"index.html — 프로세스 {len(order)} · 단계 {sum(len(p['steps']) for p in order)} · 빠진곳 {len(gaps)}")
