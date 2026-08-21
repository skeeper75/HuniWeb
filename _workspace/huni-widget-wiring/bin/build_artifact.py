#!/usr/bin/env python3
"""build_artifact.py — 자족 단일 HTML 아티팩트 생성 (SPEC-WIDGET-WIRING-001 M5).

입력: out/wiring-health/*.json + out/wiring-health-index.json → out/wiring-explorer.html
[HARD] 데이터 인라인 임베드(외부 fetch 0)·라이트/다크 명시 색·후니 DS 톤(진단 도구 기능 우선).
"""
from __future__ import annotations
import json
import pathlib

HERE = pathlib.Path(__file__).resolve()
WS = HERE.parent.parent
OUT = WS / "out"

EDGE_LABELS = {
    "W1": "상품→옵션그룹", "W2": "그룹→옵션", "W3": "옵션→항목", "W4": "항목→차원해소",
    "W5": "dtl_opt→단가행", "C1": "제약↔코드", "E1": "상품→공식", "E2": "공식→구성요소",
    "E3": "use_dims↔등록차원", "E4": "선택값→단가행", "SIM_META_ERROR": "sim-meta 생성",
}


def main() -> int:
    index = json.loads((OUT / "wiring-health-index.json").read_text(encoding="utf-8"))
    details = {}
    wh = OUT / "wiring-health"
    for p in sorted(wh.glob("PRD_*.json")):
        d = json.loads(p.read_text(encoding="utf-8"))
        # payload 절약(R-3): dtl_opt 원문·빈 defects 필드 제거
        def slim_g(g):
            return {"opt_grp_cd": g["opt_grp_cd"], "opt_grp_nm": g["opt_grp_nm"],
                    "mand_yn": g.get("mand_yn"),
                    "defects": g.get("defects") or None,
                    "options": [{"opt_cd": o["opt_cd"], "opt_nm": o["opt_nm"], "dflt": o["dflt"],
                                 "items": [{"item_seq": i["item_seq"], "ref_dim_cd": i["ref_dim_cd"],
                                            "ref_key1": i["ref_key1"], "resolved": i["resolved"],
                                            "defects": i.get("defects") or None}
                                           for i in o["items"]]}
                                for o in g["options"]]}
        d["widget"]["opt_groups"] = [slim_g(g) for g in d["widget"].get("opt_groups", [])]
        details[d["prd_cd"]] = d
    data = {"index": index, "details": details,
            "edgeLabels": EDGE_LABELS}
    html = TEMPLATE.replace("__DATA__", json.dumps(data, ensure_ascii=False))
    path = OUT / "wiring-explorer.html"
    path.write_text(html, encoding="utf-8")
    print(f"{path} ({path.stat().st_size/1024:.0f} KB · {len(details)}상품)")
    return 0


TEMPLATE = r"""<!doctype html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>위젯 배선 헬스 탐색기 — SPEC-WIDGET-WIRING-001</title>
<style>
:root { --bg:#fafaf9; --panel:#fff; --ink:#1c1917; --mut:#78716c; --line:#e7e5e4;
  --acc:#0f62fe; --bad:#b42318; --badbg:#fee4e2; --warn:#b54708; --warnbg:#fef0c7;
  --ok:#067647; --okbg:#d1fadf; --chip:#f3f4f6; }
:root[data-theme="dark"] { --bg:#141414; --panel:#1d1d1d; --ink:#f5f5f4; --mut:#a8a29e;
  --line:#333; --acc:#6ea8ff; --bad:#f97066; --badbg:#4c1e1b; --warn:#f5a623; --warnbg:#4a3310;
  --ok:#30a46c; --okbg:#123f2c; --chip:#2a2a2a; }
* { box-sizing:border-box; }
body { margin:0; font:13px/1.5 -apple-system,"Apple SD Gothic Neo","Malgun Gothic",sans-serif;
  background:var(--bg); color:var(--ink); }
header { padding:10px 16px; border-bottom:1px solid var(--line); background:var(--panel);
  display:flex; flex-wrap:wrap; gap:14px; align-items:center; }
header h1 { font-size:15px; margin:0; }
.badge { padding:1px 8px; border-radius:10px; font-size:12px; font-weight:600; }
.v-BROKEN { background:var(--badbg); color:var(--bad); }
.v-WARN { background:var(--warnbg); color:var(--warn); }
.v-OK { background:var(--okbg); color:var(--ok); }
.v-NOT_EVALUATED { background:var(--chip); color:var(--mut); border:1px dashed var(--mut); }
#main { display:grid; grid-template-columns:340px 1fr; height:calc(100vh - 58px); }
#list { border-right:1px solid var(--line); overflow-y:auto; background:var(--panel); }
#list .tools { padding:8px; position:sticky; top:0; background:var(--panel);
  border-bottom:1px solid var(--line); display:flex; flex-direction:column; gap:6px; }
#list .tools input, #list .tools select { padding:5px 7px; border:1px solid var(--line);
  border-radius:6px; background:var(--bg); color:var(--ink); }
.prd { padding:7px 10px; border-bottom:1px solid var(--line); cursor:pointer; }
.prd:hover { background:var(--chip); }
.prd.sel { background:var(--chip); box-shadow:inset 3px 0 0 var(--acc); }
.prd .nm { font-weight:600; }
.prd .sub { color:var(--mut); font-size:12px; }
#detail { overflow-y:auto; padding:14px 18px; }
#detail h2 { margin:2px 0 8px; font-size:16px; }
table.meta { border-collapse:collapse; margin:6px 0 14px; }
table.meta td { border:1px solid var(--line); padding:3px 9px; }
.node { margin:2px 0 2px 0; }
.optgrp > .lbl, .opt > .lbl, .item > .lbl { padding:2px 6px; border-radius:5px; display:inline-block; }
.defect { color:var(--bad); font-weight:600; margin-left:6px; cursor:help;
  border-bottom:1px dotted var(--bad); }
.unresolved { color:var(--warn); }
#evidence { position:fixed; right:14px; bottom:14px; max-width:520px; max-height:40vh;
  overflow:auto; background:var(--panel); border:1px solid var(--bad); border-radius:8px;
  padding:10px 12px; display:none; box-shadow:0 4px 18px rgba(0,0,0,.25); white-space:pre-wrap; }
.chain { margin:4px 0 14px; }
.chain .step { display:inline-block; padding:3px 10px; border:1px solid var(--line);
  border-radius:7px; margin:2px 3px 2px 0; background:var(--panel); }
.chain .step.broken { border-color:var(--bad); border-style:dashed; color:var(--bad); font-weight:700; }
.heat { display:flex; flex-wrap:wrap; gap:4px; font-size:11px; }
.heat span { padding:1px 7px; border-radius:8px; background:var(--chip); }
</style>
</head>
<body>
<header>
  <h1>🔌 위젯 배선 헬스 탐색기</h1>
  <span id="hdr-snap" class="sub"></span>
  <span id="hdr-denom" class="sub"></span>
  <span id="hdr-verdict"></span>
  <div class="heat" id="hdr-heat"></div>
  <span style="flex:1"></span>
  <button id="theme" style="padding:4px 10px;cursor:pointer">🌙/☀️</button>
</header>
<div id="main">
  <div id="list">
    <div class="tools">
      <input id="q" placeholder="상품코드·이름 검색">
      <div style="display:flex;gap:6px">
        <select id="f-verdict"><option value="">전체 판정</option><option>BROKEN</option><option>WARN</option><option>OK</option><option>NOT_EVALUATED</option></select>
        <select id="f-edge"><option value="">전체 엣지</option></select>
      </div>
    </div>
    <div id="rows"></div>
  </div>
  <div id="detail"><p style="color:var(--mut)">좌측에서 상품을 선택하세요.</p></div>
</div>
<div id="evidence"></div>
<script>
const DATA = __DATA__;
const EDGES = ["W1","W2","W3","W4","W5","C1","E1","E2","E3","E4"];
let sel = null;

const $ = s => document.querySelector(s);
const hdr = () => $("#hdr-heat");

function init() {
  const idx = DATA.index;
  $("#hdr-snap").textContent = "스냅샷 " + idx.snapshot;
  $("#hdr-denom").textContent = "분모 " + idx.denominator + "상품";
  const vc = idx.verdict_counts || {};
  $("#hdr-verdict").innerHTML =
    `BROKEN <b style="color:var(--bad)">${vc.BROKEN||0}</b> · WARN ${vc.WARN||0} · OK ${vc.OK||0} · 전역 ` +
    (idx.broken ? `<span class="badge v-BROKEN">NO-GO</span>` : `<span class="badge v-OK">GO</span>`);
  const edgeCnt = {};
  for (const p of idx.products) for (const e of (p.broken_edges||[])) edgeCnt[e]=(edgeCnt[e]||0)+1;
  hdr().innerHTML = EDGES.map(e =>
    `<span>${e} ${DATA.edgeLabels[e]||""} <b>${edgeCnt[e]||0}</b></span>`).join("");
  const fe = $("#f-edge");
  EDGES.forEach(e => fe.insertAdjacentHTML("beforeend", `<option>${e}</option>`));
  $("#q").oninput = render; $("#f-verdict").onchange = render; $("#f-edge").onchange = render;
  $("#theme").onclick = () => {
    const r = document.documentElement;
    r.dataset.theme = r.dataset.theme === "dark" ? "" : "dark";
  };
  render();
}

function render() {
  const q = $("#q").value.trim().toLowerCase();
  const fv = $("#f-verdict").value, fe = $("#f-edge").value;
  const rows = DATA.index.products.filter(p =>
    (!fv || p.verdict === fv) &&
    (!fe || (p.broken_edges||[]).includes(fe)) &&
    (!q || p.prd_cd.toLowerCase().includes(q) || (p.prd_nm||"").toLowerCase().includes(q)));
  $("#rows").innerHTML = rows.map(p =>
    `<div class="prd ${sel===p.prd_cd?"sel":""}" data-p="${p.prd_cd}">
      <div class="nm"><span class="badge v-${p.verdict}">${p.verdict}</span> ${p.prd_cd}</div>
      <div class="sub">${p.prd_nm||""} · 결함 ${p.n_defects} · ${p.broken_edges.join(",")||"-"}</div>
    </div>`).join("") || `<p style="padding:10px;color:var(--mut)">해당 없음</p>`;
  document.querySelectorAll(".prd").forEach(el =>
    el.onclick = () => { sel = el.dataset.p; render(); showDetail(sel); });
}

function showDefects(list) {
  return (list||[]).map(d =>
    ` <span class="defect" data-ev="${esc(JSON.stringify(d))}">⚠${d.code}·${d.edge}</span>`).join("");
}
function esc(s){ return s.replace(/"/g,"&quot;"); }

function showDetail(pc) {
  const d = DATA.details[pc]; if (!d) return;
  const t = $("#detail");
  let h = `<h2><span class="badge v-${d.verdict}">${d.verdict}</span> ${pc} ${d.prd_nm||""}</h2>
    <table class="meta"><tr><td>유형</td><td>${d.prd_typ_cd}</td><td>가격소스</td><td>${(d.widget.source_hint||"?")}</td>
    <td>공식</td><td>${d.binding.frm_cd||"-"} (${d.binding.apply_bgn_ymd||"-"})</td>
    <td>커버리지</td><td>${d.price.reachable_ratio ?? "-"}</td></tr></table>`;
  // 가격축 체인
  const e1 = (d.binding.defects||[]).length, e2 = (d.formula.defects||[]).length;
  const e34 = (d.price.defects||[]).filter(x=>x.edge==="E3").length,
        e4 = (d.price.defects||[]).filter(x=>x.edge==="E4").length;
  h += `<div class="chain">가격축:
    <span class="step ${e1?"broken":""}">E1 공식 ${d.binding.frm_cd||"없음"}${e1?" ⚠"+e1:""}</span>→
    <span class="step ${e2?"broken":""}">E2 구성요소 ${d.formula.components.length}개${e2?" ⚠"+e2:""}</span>→
    <span class="step ${e34?"broken":""}">E3 use_dims↔등록${e34?" ⚠"+e34:""}</span>→
    <span class="step ${e4?"broken":""}">E4 단가행${e4?" ⚠"+e4:""}</span></div>`;
  // 위젯 계층 W1→W4
  h += `<h3>위젯 옵션 계층</h3><div class="tree">`;
  for (const g of (d.widget.opt_groups||[])) {
    h += `<div class="node optgrp"><span class="lbl">📁 ${g.opt_grp_nm||g.opt_grp_cd}${g.mand_yn==="Y"?" *":""}</span>${showDefects(g.defects)}</div>`;
    for (const o of g.options) {
      h += `<div class="node opt" style="margin-left:16px"><span class="lbl">🅾 ${o.opt_nm||o.opt_cd}${o.dflt?" (기본)":""}</span></div>`;
      for (const it of o.items) {
        const unres = it.resolved === false;
        h += `<div class="node item" style="margin-left:32px"><span class="lbl ${unres?"unresolved":""}">· #${it.item_seq} ${it.ref_dim_cd}=${it.ref_key1}${unres?" ✗해소실패":(it.resolved?" ✓":"")}</span>${showDefects(it.defects)}</div>`;
      }
    }
  }
  if (!(d.widget.opt_groups||[]).length) h += `<p style="color:var(--mut)">옵션그룹 없음</p>`;
  h += `</div>`;
  // 구성요소
  h += `<h3>가격 구성요소 (E2)</h3>`;
  h += (d.formula.components||[]).map(c =>
    `<div class="node">· ${c.comp_cd} — 단가행 ${c.price_rows} · use_dims [${(c.use_dims||[]).join(",")}]${showDefects(c.defects)}</div>`).join("")
    || `<p style="color:var(--mut)">없음</p>`;
  // E3/E4 + C1 결함 목록
  const allD = [];
  for (const x of (d.price.defects||[])) allD.push(x);
  for (const c of (d.widget.constraints||[])) for (const x of (c.defects||[])) allD.push({...x, rule:c.rule_cd});
  h += `<h3>결함 (E3·E4·C1 등)</h3>` + (allD.length ? allD.map(x =>
    `<div class="node">⚠ <b>${x.code}</b> [${x.edge}] ${x.rule||""} ${x.dim||""} ${x.value||""}</div>`).join("")
    : `<p style="color:var(--mut)">없음</p>`);
  // 교정 라우팅
  h += `<h3>교정 라우팅</h3>` + (d.remediation||[]).map(r =>
    `<div class="node">· [${r.edge}] <b>${r.class}</b> — ${r.note}</div>`).join("")
    || `<p style="color:var(--mut)">없음</p>`;
  t.innerHTML = h;
  t.querySelectorAll(".defect").forEach(el => {
    el.onclick = ev => { ev.stopPropagation();
      const ev$ = $("#evidence"); ev$.style.display = "block";
      ev$.textContent = el.dataset.ev.replace(/&quot;/g, '"');
    };
  });
}

$("#evidence").onclick = () => { $("#evidence").style.display = "none"; };
init();
</script>
</body>
</html>
"""

if __name__ == "__main__":
    raise SystemExit(main())
