#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""준비도 대시보드 빌더 — product_viewer UX 재사용 + Cytoscape.js 플로우 그래프.

입력(권위): 05_gate/product-details-final.json (283항목·dims[D1~D11]·골든·widget_eligible·golden_status)
산출:
  - dashboard.html                          (standalone·데이터 임베드·브라우저로 바로 열림)
  - django_app/templates/catalog/readiness_viewer.html  (webadmin 드롭인 템플릿)
  - django_app/readiness_viewer.py          (읽기전용 뷰·이 빌더가 생성하진 않음·별도 파일)

★데이터(json)만 갱신해 다시 빌드하면 레이아웃 보존(이전 산출물 있을 때).
재실행: python3 build_dashboard.py
"""
import json
import pathlib

HERE = pathlib.Path(__file__).resolve().parent
GATE = HERE.parent  # 05_gate/
SRC = GATE / "product-details-final.json"
# ★배선 진척 보드 소스(있으면 임베드) — wiring_scan.py 산출(formula_components 배선 결함 스캔).
#   _workspace/_foundation/batch/wiring/wiring-status.json (없으면 보드는 details 폴백으로 근사).
WIRING_SRC = GATE.parents[1] / "_foundation" / "batch" / "wiring" / "wiring-status.json"

# ── 공통 CSS (product_viewer.html 룩앤필 계승: #pv-app flex, Unfold 색/타이포) ──
CSS = r"""
:root{ --pass:#16a34a; --warn:#d97706; --fail:#dc2626; --na:#9ca3af; --ink:#1f2937; }
*{ box-sizing:border-box; }
body{ margin:0; font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,"Helvetica Neue",Arial,"Apple SD Gothic Neo","Malgun Gothic",sans-serif; color:var(--ink); background:#f9fafb; }
#rv-summary{ padding:12px 16px; background:#fff; border-bottom:1px solid #e5e7eb; display:flex; flex-wrap:wrap; gap:18px; align-items:center; font-size:12.5px; }
#rv-summary .s-title{ font-size:15px; font-weight:700; margin-right:6px; }
#rv-summary .s-kpi{ display:flex; flex-direction:column; line-height:1.25; }
#rv-summary .s-kpi b{ font-size:16px; }
#rv-summary .s-kpi span{ color:#6b7280; font-size:11px; }
#rv-summary .s-grades{ display:flex; gap:4px; align-items:center; }
.gchip{ font-size:11px; padding:2px 7px; border-radius:9px; font-weight:700; color:#fff; }
.s-note{ color:#9ca3af; font-size:11px; font-style:italic; max-width:340px; }

#rv-app{ display:flex; gap:0; border-top:1px solid #e5e7eb; height:calc(100vh - 64px); min-height:480px; }
#rv-list{ width:320px; border-right:1px solid #e5e7eb; display:flex; flex-direction:column; background:#fafafa; }
#rv-list .rv-search{ padding:10px; border-bottom:1px solid #eee; }
#rv-list input[type=search]{ width:100%; padding:7px 9px; border:1px solid #d1d5db; border-radius:7px; font-size:13px; }
#rv-filters{ padding:7px 10px; border-bottom:1px solid #eee; display:flex; flex-wrap:wrap; gap:5px; font-size:11px; }
#rv-filters select,#rv-filters label{ font-size:11px; }
#rv-filters label{ display:inline-flex; align-items:center; gap:3px; color:#4b5563; cursor:pointer; }
#rv-items{ overflow-y:auto; flex:1; }
.rv-cat{ font-size:11px; color:#6b7280; padding:9px 12px 3px; font-weight:700; background:#fafafa; position:sticky; top:0; }
.rv-cat .c-n{ color:#9ca3af; font-weight:400; }
.rv-item{ padding:5px 12px; border-bottom:1px solid #f0f0f0; cursor:pointer; display:flex; align-items:center; gap:8px; }
.rv-item:hover{ background:#eef4ff; }
.rv-item.active{ background:#dbe9ff; }
.rv-item .rv-nm{ flex:1; min-width:0; overflow:hidden; text-overflow:ellipsis; white-space:nowrap; font-size:13px; }
.rv-item.active .rv-nm{ font-weight:600; }
.rv-item .rv-cd{ flex-shrink:0; color:#9ca3af; font-size:10.5px; }
.gbadge{ flex-shrink:0; font-size:10px; width:34px; text-align:center; padding:1px 0; border-radius:8px; font-weight:700; color:#fff; }
.flag{ flex-shrink:0; font-size:9px; padding:0 4px; border-radius:7px; font-weight:700; }
.flag-w{ background:#dcfce7; color:#15803d; } .flag-p0{ background:#fee2e2; color:#b91c1c; }
.flag-pre{ background:#f3f4f6; color:#6b7280; }

#rv-detail{ flex:1; overflow-y:auto; padding:16px 22px; }
.rv-hint{ color:#9ca3af; padding:24px; }
.dhead{ display:flex; align-items:center; flex-wrap:wrap; gap:10px; margin-bottom:4px; }
.dhead h2{ margin:0; font-size:19px; }
.dhead .cd{ color:#9ca3af; font-size:12px; }
.dmeta{ display:flex; flex-wrap:wrap; gap:6px; margin-bottom:12px; font-size:11.5px; }
.pill{ padding:2px 9px; border-radius:10px; background:#f3f4f6; color:#374151; font-weight:600; }
.pill.grade{ color:#fff; }
.pill.we-y{ background:#dcfce7; color:#15803d; } .pill.we-n{ background:#f3f4f6; color:#6b7280; }
details.sec{ margin-bottom:10px; border:1px solid #e5e7eb; border-radius:8px; overflow:hidden; }
details.sec>summary{ font-size:13px; font-weight:600; padding:8px 12px; cursor:pointer; background:#f9fafb; list-style:none; display:flex; align-items:center; gap:8px; }
details.sec>summary::-webkit-details-marker{ display:none; }
details.sec>summary::before{ content:"▸"; color:#6b7280; font-size:11px; }
details.sec[open]>summary::before{ content:"▾"; }
.sec-body{ padding:10px 12px; }
.cy-wrap{ position:relative; }
#cy{ width:100%; height:300px; background:#fff; border:1px solid #eee; border-radius:8px; }
.cy-legend{ font-size:10.5px; color:#6b7280; padding:6px 2px 0; display:flex; flex-wrap:wrap; gap:10px; }
.cy-legend i{ display:inline-block; width:10px; height:10px; border-radius:50%; margin-right:3px; vertical-align:-1px; }
table.dim{ border-collapse:collapse; width:100%; font-size:12px; }
table.dim th,table.dim td{ border:1px solid #e5e7eb; padding:4px 8px; text-align:left; vertical-align:top; }
table.dim th{ background:#f3f4f6; }
table.dim td.st{ font-weight:700; text-align:center; white-space:nowrap; }
.st-PASS{ color:var(--pass); } .st-WARN{ color:var(--warn); } .st-FAIL{ color:var(--fail); } .st-NA{ color:var(--na); }
tr.r-FAIL{ background:#fef2f2; } tr.r-WARN{ background:#fffbeb; }
.golden td b{ color:#111827; }
.nextstep{ background:#eff6ff; border:1px solid #bfdbfe; border-radius:8px; padding:10px 12px; font-size:13px; }
.nextstep .lbl{ font-size:11px; color:#2563eb; font-weight:700; display:block; margin-bottom:3px; }
.gnote{ color:#92400e; background:#fffbeb; border:1px solid #fde68a; border-radius:6px; padding:6px 9px; font-size:11.5px; margin-top:8px; }

/* ── BOM(구성요소·가격구성요소) 항목 단위 표 ── */
details.bom{ margin-bottom:7px; border:1px solid #e5e7eb; border-radius:7px; overflow:hidden; }
details.bom>summary{ font-size:12px; font-weight:600; padding:6px 10px; cursor:pointer; background:#fcfcfd; list-style:none; display:flex; align-items:center; gap:7px; }
details.bom>summary::-webkit-details-marker{ display:none; }
details.bom>summary::before{ content:"▸"; color:#9ca3af; font-size:10px; }
details.bom[open]>summary::before{ content:"▾"; }
details.bom>summary .ax-cnt{ color:#9ca3af; font-weight:400; font-size:11px; }
.bom-body{ padding:6px 8px; overflow-x:auto; }
table.bom{ border-collapse:collapse; width:100%; font-size:11.5px; }
table.bom th,table.bom td{ border:1px solid #eef0f2; padding:3px 7px; text-align:left; vertical-align:top; }
table.bom th{ background:#f6f7f8; font-weight:600; }
table.bom td.code{ font-family:ui-monospace,SFMono-Regular,Menlo,monospace; color:#6b7280; font-size:10.5px; white-space:nowrap; }
table.bom td.cst{ text-align:center; white-space:nowrap; }
tr.it-missing{ background:#fef2f2; } tr.it-missing td:first-child{ font-weight:600; }
tr.it-price_gap{ background:#fffbeb; } tr.it-차원_미스매치{ background:#fffbeb; } tr.it-단가행_전무{ background:#fef2f2; }
.chip{ display:inline-block; font-size:10px; padding:1px 7px; border-radius:9px; font-weight:700; color:#fff; }
.chip-present{ background:#16a34a; } .chip-missing{ background:#dc2626; }
.chip-price_gap{ background:#d97706; } .chip-차원_미스매치{ background:#d97706; } .chip-단가행_전무{ background:#dc2626; }
.chip-direct_price{ background:#0891b2; } .chip-na{ background:#9ca3af; } .chip-extra{ background:#7c3aed; } .chip-mismatch{ background:#d97706; }
.q0box{ background:#fef2f2; border:1px solid #fecaca; border-radius:7px; padding:8px 10px; margin-bottom:9px; font-size:12px; color:#b91c1c; }
.q0box .q0-lbl{ font-weight:700; display:block; margin-bottom:3px; }
.q0box ul{ margin:3px 0 0; padding-left:18px; } .q0box li{ margin:2px 0; }
.cellgrid{ font-family:ui-monospace,Menlo,monospace; font-size:10.5px; }
.cellgrid .empty{ color:#dc2626; font-weight:700; }
.bom-note{ color:#9ca3af; font-size:10.5px; margin-top:1px; }
.bom-empty{ color:#9ca3af; font-size:11.5px; padding:4px 2px; font-style:italic; }

/* ── 탭 바 (준비도 ↔ 배선 진척 보드) ── */
#rv-tabs{ display:flex; gap:2px; padding:0 16px; background:#fff; border-bottom:1px solid #e5e7eb; }
#rv-tabs button{ border:none; background:transparent; padding:9px 16px; font-size:13px; font-weight:600;
  color:#6b7280; cursor:pointer; border-bottom:2px solid transparent; }
#rv-tabs button.active{ color:#1d4ed8; border-bottom-color:#1d4ed8; }
.tab-pane{ display:none; } .tab-pane.active{ display:block; }

/* ── 배선 진척 보드 ── */
#wb-app{ padding:16px 22px; overflow-y:auto; height:calc(100vh - 96px); min-height:460px; }
.wb-kpis{ display:flex; flex-wrap:wrap; gap:14px; margin-bottom:8px; }
.wb-kpi{ background:#fff; border:1px solid #e5e7eb; border-radius:10px; padding:10px 16px; min-width:118px; }
.wb-kpi b{ font-size:22px; display:block; line-height:1.1; }
.wb-kpi span{ font-size:11px; color:#6b7280; }
.wb-kpi.bad b{ color:#dc2626; } .wb-kpi.warn b{ color:#d97706; } .wb-kpi.ok b{ color:#16a34a; }
.wb-prog{ height:14px; border-radius:8px; background:#fee2e2; overflow:hidden; margin:6px 0 14px; max-width:520px; }
.wb-prog i{ display:block; height:100%; background:linear-gradient(90deg,#84cc16,#16a34a); }
.wb-verdict{ font-size:12.5px; font-weight:700; padding:3px 10px; border-radius:9px; display:inline-block; margin-bottom:10px; }
.wb-verdict.go{ background:#dcfce7; color:#15803d; } .wb-verdict.nogo{ background:#fee2e2; color:#b91c1c; }
.wb-note{ font-size:11.5px; color:#6b7280; margin:2px 0 14px; max-width:760px; line-height:1.5; }
.wb-sec{ margin-bottom:16px; }
.wb-sec h3{ font-size:14px; margin:0 0 6px; display:flex; align-items:center; gap:8px; }
.wb-sec h3 .cnt{ font-size:12px; color:#6b7280; font-weight:400; }
table.wb{ border-collapse:collapse; width:100%; font-size:12px; }
table.wb th,table.wb td{ border:1px solid #e5e7eb; padding:4px 8px; text-align:left; vertical-align:top; }
table.wb th{ background:#f3f4f6; position:sticky; top:0; }
table.wb td.code{ font-family:ui-monospace,Menlo,monospace; font-size:10.5px; color:#6b7280; white-space:nowrap; }
table.wb tr:hover{ background:#f9fafb; }
.wb-empty{ color:#16a34a; font-size:12px; padding:6px 2px; font-weight:600; }
.wb-pill{ font-size:10px; padding:1px 7px; border-radius:8px; font-weight:700; color:#fff; }
.wb-link{ color:#1d4ed8; cursor:pointer; text-decoration:underline; }
.wb-rounds{ font-size:11.5px; }
.wb-rounds td,.wb-rounds th{ padding:3px 8px; }
"""

# ── 공통 JS (standalone·django 동일: 데이터는 id="rv-data" json_script 에서 읽음) ──
JS = r"""
const RV = JSON.parse(document.getElementById("rv-data").textContent);
const PRODUCTS = RV.products, SUMMARY = RV.summary;
let curCd = null, cyInst = null;
const esc = s => (s==null?"":String(s)).replace(/[&<>"]/g, c=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;'}[c]));

// 등급 → 색 (L0 빨강 → L4 초록). 괄호 변형(L1(기성)·L2(반제품))은 베이스 등급 색.
function gradeBase(g){ const m=String(g||"").match(/L(\d)/); return m?("L"+m[1]):"L0"; }
const GRADE_COLOR = { L0:"#dc2626", L1:"#f97316", L2:"#eab308", L3:"#84cc16", L4:"#16a34a" };
function gradeColor(g){ let b=gradeBase(g); if(String(g).includes("+")) return "#a3e635"; return GRADE_COLOR[b]||"#9ca3af"; }
function compColor(p){ if(p>=90) return "#16a34a"; if(p>=70) return "#84cc16"; if(p>=50) return "#eab308"; if(p>=30) return "#f97316"; return "#dc2626"; }
const stCls = s => s==="N/A" ? "NA" : s;

// ── 상단 요약 ──
function renderSummary(){
  const s = SUMMARY;
  const gOrder = ["L0","L1","L1(기성)","L2","L2(반제품)","L2+","L3","L4"];
  let chips = "";
  for(const g of gOrder){ if(!s.grades[g]) continue;
    chips += `<span class="gchip" style="background:${gradeColor(g)}" title="${esc(g)}">${esc(g)} ${s.grades[g]}</span>`; }
  document.getElementById("rv-summary").innerHTML =
    `<span class="s-title">상품 준비도 대시보드</span>`
   +`<div class="s-kpi"><b>${s.total}</b><span>전체 상품(분모)</span></div>`
   +`<div class="s-kpi"><b>${s.avg_completion}%</b><span>평균 완성률</span></div>`
   +`<div class="s-kpi"><b>${s.calc_ok} <small style="font-size:11px;color:#6b7280">(${s.calc_pct}%)</small></b><span>계산 가능(PRICE≠0)</span></div>`
   +`<div class="s-kpi"><b>${s.widget_y}</b><span>위젯 대상(eligible=Y)</span></div>`
   +`<div class="s-kpi"><b style="color:#dc2626">${s.bom_price0??'-'}</b><span>견적 0(가격사슬 끊김)</span></div>`
   +`<div class="s-kpi"><b style="color:#dc2626">${s.bom_axis_missing??'-'}</b><span>구성요소 빠짐(축 결손)</span></div>`
   +`<div class="s-grades"><span style="color:#6b7280">등급 분포</span>${chips}</div>`
   +`<div class="s-note">★ 구성요소·가격구성요소 BOM 을 항목 단위로 대조 — 상세 패널에서 "어느 구성요소가 빠졌나/어디서 견적이 끊겼나"를 직접 확인. PRICE≠0=계산 성립 신호일 뿐(골든 전수 일치는 후속).</div>`;
}

// ── 사이드바 트리(상품군 그룹) ──
function passFilter(p){
  const q = (document.getElementById("rv-q").value||"").trim().toLowerCase();
  if(q && !(p.상품명||"").toLowerCase().includes(q) && !(p.prd_cd||"").toLowerCase().includes(q)) return false;
  const fg = document.getElementById("f-grade").value;
  if(fg && gradeBase(p.등급)!==fg) return false;
  const fp = document.getElementById("f-paper").value;
  if(fp && (p.종이류||"")!==fp) return false;
  if(document.getElementById("f-widget").checked && p.widget_eligible!=="Y") return false;
  if(document.getElementById("f-p0").checked && !p._priced0) return false;
  return true;
}
function itemHTML(p){
  const gb = `<span class="gbadge" style="background:${gradeColor(p.등급)}" title="등급 ${esc(p.등급)}">${esc(p.등급)}</span>`;
  let flags = "";
  if(p.widget_eligible==="Y") flags += `<span class="flag flag-w" title="위젯 대상">W</span>`;
  if(p._priced0) flags += `<span class="flag flag-p0" title="PRICED-0(견적 0)">0</span>`;
  if(p._preverify) flags += `<span class="flag flag-pre" title="검증 전(L3 미만·골든 미대조)">검</span>`;
  return `<div class="rv-item${curCd===p.prd_cd?' active':''}" onclick="selectProd('${p.prd_cd}')">`
    +`${gb}<span class="rv-nm" title="완성률 ${p.완성률}%">${esc(p.상품명)}</span>${flags}`
    +`<span class="rv-cd">${esc(p.prd_cd)}</span></div>`;
}
function renderList(){
  const groups = {};
  for(const p of PRODUCTS){ if(!passFilter(p)) continue; (groups[p.상품군]=groups[p.상품군]||[]).push(p); }
  let html = "";
  for(const cat of RV.cat_order){ const ps = groups[cat]; if(!ps||!ps.length) continue;
    html += `<div class="rv-cat">${esc(cat)} <span class="c-n">(${ps.length})</span></div>`;
    for(const p of ps) html += itemHTML(p);
  }
  document.getElementById("rv-items").innerHTML = html || '<p class="rv-hint">조건에 맞는 상품 없음</p>';
}

// ── Cytoscape 플로우 그래프 (★실제 BOM 항목 노드) ──
// 좌→우: 상품 → 구성요소 항목(자재·공정·사이즈·도수·옵션 — component_bom 실항목) →
//          가격공식 → 가격구성요소 항목(price_bom) → 단가행 → 계산가능/견적0.
// 노드 색 = 항목 status(있음 초록 / 빠짐·단가행없음 빨강 / 단가공백·차원불일치 주황 / 비대상 회색 점선).
// 끊긴 엣지(빨강 점선) = 견적 0 원인 지점. ★항목 다수 축은 (축+상태)로 집계(읽기성)·소수(≤5)는 항목별.
// React Flow 미채택(React 빌드 필요). 교체 시 동일 노드/엣지 모델을 React Flow nodes/edges 로 이식 가능.
const STATUS_FILL = { present:"#16a34a", missing:"#dc2626", price_gap:"#d97706",
  "차원_미스매치":"#d97706", "단가행_전무":"#dc2626", direct_price:"#0891b2",
  "n/a":"#9ca3af", "N/A":"#9ca3af", "":"#9ca3af" };
const STATUS_LABEL = { present:"있음", missing:"빠짐", price_gap:"단가공백",
  "차원_미스매치":"차원불일치", "단가행_전무":"단가행없음", direct_price:"직접단가", "n/a":"비대상" };
function stColor(s){ return STATUS_FILL[s]||"#9ca3af"; }
function stLabel(s){ return STATUS_LABEL[s]||s||"-"; }

// 한 축의 항목을 status 로 묶어 그래프 노드화(소수=항목별·다수=집계).
function axisNodes(ax){
  const groups = {}; for(const it of (ax.items||[])){ (groups[it.status]=groups[it.status]||[]).push(it); }
  const out = [];
  for(const st in groups){
    const arr = groups[st];
    const real = arr.filter(i=>i.code||i.name);
    if(real.length===0){ out.push({ label:`${ax.axis} 결손`, status:st }); continue; }
    if(real.length<=5){ for(const it of real) out.push({ label:(it.name||it.code), status:st }); }
    else { out.push({ label:`${ax.axis} ${stLabel(st)} ×${real.length}`, status:st }); }
  }
  return out;
}
function buildGraph(p){
  const cb = p.component_bom||[], pb = p.price_bom||{};
  const fm = pb.formula||{}, pcs = pb.price_components||[];
  const cols = {0:[],1:[],2:[],3:[],4:[]};
  // col0 상품(등급 색)
  cols[0].push({ id:"P", label:p.상품명, fill:gradeColor(p.등급), cls:"node-p" });
  // col1 구성요소 항목
  let ci=0;
  for(const ax of cb){ for(const nd of axisNodes(ax)){
    const dashed = (nd.status==='missing'||nd.status==='n/a');
    cols[1].push({ id:"C"+(ci++), label:nd.label, fill:stColor(nd.status), status:nd.status, dashed });
  }}
  if(!cols[1].length) cols[1].push({ id:"C0", label:"구성요소 없음", fill:"#9ca3af", dashed:true });
  // col2 가격공식
  const fmFillSt = fm.status==='present'?'present':(fm.status==='direct_price'?'direct_price':(fm.status==='n/a'?'n/a':'missing'));
  cols[2].push({ id:"F",
    label: fm.frm_cd ? fm.frm_cd : ("가격공식 "+stLabel(fm.status)),
    fill: stColor(fmFillSt), dashed:(fm.status==='missing'||fm.status==='n/a') });
  // col3 가격구성요소 항목(단가행 셀 요약 포함)
  let pi=0;
  for(const pc of pcs){
    const cells = (pc.전역셀수!=null) ? ` [${pc.단가행_적재셀수}/${pc.전역셀수}셀]` : "";
    cols[3].push({ id:"PC"+(pi++), label:(pc.name||pc.comp_cd)+cells, fill:stColor(pc.status),
      status:pc.status, dashed:(pc.status==='단가행_전무') });
  }
  if(fm.status==='direct_price') cols[3].push({ id:"PCd", label:"직접단가(가격포함)", fill:stColor('direct_price') });
  if(!cols[3].length && fm.status!=='direct_price') cols[3].push({ id:"PC0", label:"가격구성요소 없음", fill:"#9ca3af", dashed:true });
  // col4 종착(견적0/계산가능)
  const q0 = (pb.견적0원인||[]).length>0;
  cols[4].push({ id:"PRICE", label:(q0?"견적 0(끊김)":"계산 가능"), fill:(q0?"#dc2626":"#16a34a"), dashed:q0 });
  // 좌표(컬럼 X·행 중앙 정렬). fit:true 가 재스케일하므로 상대좌표만 정확하면 됨.
  const COLX=[30,210,400,560,760], ROWH=56, CY=200;
  const els=[];
  for(const c in cols){ const arr=cols[c], h=(arr.length-1)*ROWH;
    arr.forEach((nd,i)=>els.push({ data:{ id:nd.id, label:nd.label, fill:nd.fill, status:nd.status||"" },
      position:{ x:COLX[c], y: i*ROWH - h/2 + CY },
      classes:(nd.cls||"")+(nd.dashed?" node-na":"") })); }
  // 엣지(끊긴 곳 빨강 점선)
  const e=(s,t,cls)=>els.push({ data:{ id:s+"_"+t, source:s, target:t }, classes:cls||"e-pass" });
  const fmBroken = (fm.status==='missing');
  for(const n of cols[1]) e("P", n.id, n.dashed?"e-fail":"e-pass");
  for(const n of cols[1]) e(n.id, "F", fmBroken?"e-fail":"e-pass");
  for(const n of cols[3]) e("F", n.id, n.dashed?"e-fail":"e-pass");
  for(const n of cols[3]) e(n.id, "PRICE", (n.dashed||q0)?"e-fail":"e-pass");
  return els;
}
function renderGraph(p){
  if(cyInst){ cyInst.destroy(); cyInst=null; }
  if(typeof cytoscape==="undefined"){
    document.getElementById("cy").innerHTML='<p class="rv-hint" style="padding:12px">Cytoscape 로드 실패(오프라인). 인터넷 연결 시 그래프 표시 — 또는 README 의 vendored 안내 참고.</p>';
    return;
  }
  cyInst = cytoscape({
    container: document.getElementById("cy"),
    elements: buildGraph(p),
    layout: { name:"preset", fit:true, padding:18 },
    style: [
      { selector:"node", style:{ "background-color":"data(fill)", "label":"data(label)", "font-size":"9.5px",
        "text-valign":"center","text-halign":"center","color":"#fff","text-wrap":"wrap","text-max-width":"118px",
        "width":"128px","height":"38px","shape":"roundrectangle","border-width":1,"border-color":"#e5e7eb","padding":"2px" } },
      { selector:"node.node-p", style:{ "shape":"round-tag","width":"104px","font-weight":"bold","font-size":"11px" } },
      { selector:"node.node-na", style:{ "border-width":2,"border-style":"dashed","border-color":"#9ca3af","color":"#374151" } },
      { selector:"edge", style:{ "width":2,"curve-style":"bezier","target-arrow-shape":"triangle",
        "line-color":"#cbd5e1","target-arrow-color":"#cbd5e1" } },
      { selector:"edge.e-warn", style:{ "line-color":"#d97706","target-arrow-color":"#d97706","line-style":"dashed" } },
      { selector:"edge.e-fail", style:{ "line-color":"#dc2626","target-arrow-color":"#dc2626","line-style":"dashed","width":3 } },
      { selector:"edge.e-na", style:{ "line-color":"#d1d5db","target-arrow-color":"#d1d5db","line-style":"dotted" } },
    ],
  });
  cyInst.userZoomingEnabled(false);
}

// ── BOM 표 렌더러(항목 단위) ──
function chip(st){ return `<span class="chip chip-${st||'na'}">${esc(stLabel(st))}</span>`; }
// ★구성요소 BOM: 축별 접이식 + 항목 한 줄씩(코드·이름 vs 라이브 실제 + 상태칩). 빠짐 빨강.
function compBomHTML(p){
  const cb = p.component_bom||[];
  if(!cb.length) return '<p class="bom-empty">구성요소 BOM 데이터 없음</p>';
  let html="";
  for(const ax of cb){
    const items = ax.items||[];
    const miss = items.filter(i=>i.status==='missing').length;
    const gap  = items.filter(i=>i.status==='price_gap').length;
    const pres = items.filter(i=>i.status==='present').length;
    const worst = miss?'missing':(gap?'price_gap':'present');
    const open = (miss||gap)?' open':'';
    let rows="";
    if(!items.length){
      rows = `<tr class="it-missing"><td colspan="3" class="bom-empty">권위 기대 — 라이브 미적재(항목 0)</td></tr>`;
    } else {
      for(const it of items){
        const named = it.code||it.name;
        const expected = named
          ? `<span class="code">${esc(it.code||'')}</span> ${esc(it.name||'')}`
          : `<span style="color:#9ca3af">(권위 기대 항목)</span>`;
        let actual;
        if(it.status==='missing') actual = `<span style="color:#dc2626">라이브 미적재</span>`;
        else if(it.status==='price_gap') actual = `적재됨 · <span style="color:#d97706">단가행 공백</span>`;
        else actual = `적재됨`;
        const ex=[];
        if(it.dflt==='Y') ex.push('기본값');
        if(it.side) ex.push(esc(it.side)+(it.front?` ${esc(it.front)}/${esc(it.back||'')}`:''));
        if(it.grp) ex.push('그룹 '+esc(it.grp));
        const exHtml = ex.length?`<div class="bom-note">${ex.join(' · ')}</div>`:'';
        const noteHtml = it.근거?`<div class="bom-note">${esc(it.근거)}</div>`:'';
        rows += `<tr class="it-${esc(it.status)}"><td>${expected}${exHtml}</td><td>${actual}${noteHtml}</td><td class="cst">${chip(it.status)}</td></tr>`;
      }
    }
    const cntTxt = `있음 ${pres}`+(gap?` · 단가공백 ${gap}`:'')+(miss?` · 빠짐 ${miss}`:'');
    html += `<details class="bom"${open}><summary>${chip(worst)} ${esc(ax.axis)} <span class="ax-cnt">(${esc(cntTxt)} · 필요 ${esc(ax.needed||'-')})</span></summary>`
      +`<div class="bom-body"><table class="bom"><thead><tr><th style="width:48%">예상 항목(코드·이름)</th><th>라이브 실제</th><th style="width:62px">상태</th></tr></thead><tbody>${rows}</tbody></table></div></details>`;
  }
  return html;
}
// ★가격구성요소 BOM: 공식→formula_components→price_components→단가행 항목 한 줄씩 + 견적0원인 최상단.
function priceBomHTML(p){
  const pb = p.price_bom||{};
  const fm = pb.formula||{}, fcs = pb.formula_components||[], pcs = pb.price_components||[];
  const q0 = pb.견적0원인||[], extra = pb.추가공식||[];
  let html="";
  if(q0.length){
    html += `<div class="q0box"><span class="q0-lbl">★ 견적 0 원인(견적이 끊기는 지점)</span><ul>`
      + q0.map(c=>`<li>${esc(c)}</li>`).join("") + `</ul></div>`;
  }
  const fmFillSt = fm.status==='present'?'present':(fm.status==='direct_price'?'direct_price':(fm.status==='n/a'?'n/a':'missing'));
  html += `<table class="bom" style="margin-bottom:7px"><tbody>`
    + `<tr><th style="width:120px">가격공식</th><td>${fm.frm_cd?`<span class="code">${esc(fm.frm_cd)}</span> `:''}${esc(fm.name||'')} ${chip(fmFillSt)}`
    + (fm.실제?`<div class="bom-note">${esc(fm.실제)}</div>`:'') + `</td></tr></tbody></table>`;
  if(fcs.length){
    html += `<div class="bom-note" style="margin:4px 0 2px">formula_components (공식이 합산하는 가격구성요소)</div>`
      + `<table class="bom"><thead><tr><th style="width:160px">코드</th><th>이름</th><th style="width:42px">가산</th><th style="width:58px">상태</th></tr></thead><tbody>`
      + fcs.map(fc=>`<tr class="it-${esc(fc.status)}"><td class="code">${esc(fc.comp_cd)}</td><td>${esc(fc.name||'')}</td><td class="cst">${esc(fc.addtn||'-')}</td><td class="cst">${chip(fc.status)}</td></tr>`).join("")
      + `</tbody></table>`;
  }
  html += `<div class="bom-note" style="margin:7px 0 2px">price_components → 단가행(component_prices) — 셀이 비면 견적 0</div>`;
  if(pcs.length){
    html += `<table class="bom"><thead><tr><th>가격구성요소</th><th style="width:50px">유형</th><th>차원(use_dims)</th><th style="width:96px">단가행(적재/전역)</th><th style="width:74px">상태</th></tr></thead><tbody>`;
    for(const pc of pcs){
      const loaded=pc.단가행_적재셀수, total=pc.전역셀수;
      const empty=(total!=null)?(total-(loaded||0)):null;
      let cellHtml;
      if(total!=null) cellHtml = `<span class="cellgrid">${loaded}/${total}`+(empty>0?` <span class="empty">(빈칸 ${empty})</span>`:` ✓`)+`</span>`;
      else cellHtml = '<span style="color:#9ca3af">-</span>';
      const dims=(pc.use_dims||[]).join(', ');
      html += `<tr class="it-${esc(pc.status)}"><td>${pc.comp_cd?`<span class="code">${esc(pc.comp_cd)}</span> `:''}${esc(pc.name||'')}${pc.근거?`<div class="bom-note">${esc(pc.근거)}</div>`:''}</td>`
        + `<td class="cst">${esc((pc.prc_typ||'').replace('PRICE_TYPE.','.'))}</td><td>${esc(dims)}</td><td class="cst">${cellHtml}</td><td class="cst">${chip(pc.status)}</td></tr>`;
    }
    html += `</tbody></table>`;
  } else if(fm.status==='direct_price'){
    html += `<p class="bom-empty">직접단가 모델(가격포함) — 공식/가격구성요소 없이 단일 단가만 적재.</p>`;
  } else if(fm.status==='n/a'){
    html += `<p class="bom-empty">공식 비대상(기성/inline 고정가) — 가격구성요소 없음.</p>`;
  } else {
    html += `<p class="bom-empty">가격구성요소 없음(라이브 미적재) — 견적 불가.</p>`;
  }
  if(extra.length){
    html += `<div class="bom-note" style="margin:7px 0 2px">추가공식</div><table class="bom"><tbody>`
      + extra.map(x=>`<tr><td>${esc(typeof x==='string'?x:JSON.stringify(x))}</td></tr>`).join("") + `</tbody></table>`;
  }
  return html;
}

// ── 상세 패널 ──
const NA = "N/A";
function dimRow(d){
  const cls = stCls(d.status);
  const stHtml = `<td class="st st-${cls}">${esc(d.status)}</td>`;
  const noteHtml = d.note ? `<div style="color:#9ca3af;font-size:11px;margin-top:2px">${esc(d.note)}</div>` : "";
  return `<tr class="r-${cls}"><td><b>${esc(d.code)}</b> ${esc(d.name)}<br><span style="color:#9ca3af;font-size:10.5px">가중 ${esc(d.가중)}</span></td>`
    +`<td>${esc(d.예상)}</td><td>${esc(d.실제)}${noteHtml}</td>${stHtml}</tr>`;
}
function selectProd(cd){
  curCd = cd; renderList();
  const p = PRODUCTS.find(x=>x.prd_cd===cd);
  if(!p){ return; }
  const g = p.골든 || {};
  const det = document.getElementById("rv-detail");
  det.innerHTML =
    `<div class="dhead"><h2>${esc(p.상품명)}</h2><span class="cd">${esc(p.prd_cd)}</span></div>`
   +`<div class="dmeta">`
     +`<span class="pill grade" style="background:${gradeColor(p.등급)}">등급 ${esc(p.등급)}</span>`
     +`<span class="pill">완성률 ${esc(p.완성률)}%</span>`
     +`<span class="pill">상품군 ${esc(p.상품군)}</span>`
     +`<span class="pill">위젯클래스 ${esc(p.위젯클래스)}</span>`
     +`<span class="pill ${p.widget_eligible==='Y'?'we-y':'we-n'}">위젯대상 ${esc(p.widget_eligible)}</span>`
     +(p._priced0?`<span class="pill" style="background:#fee2e2;color:#b91c1c">PRICED-0(견적 0)</span>`:"")
     +(p._preverify?`<span class="pill" style="background:#f3f4f6;color:#6b7280">검증 전</span>`:"")
   +`</div>`
   +`<div style="font-size:11.5px;color:#6b7280;margin-bottom:10px">골든 상태: <b style="color:#374151">${esc(p.golden_status||'-')}</b></div>`
   +`<details class="sec" open><summary>구성요소↔가격 플로우 그래프 (실항목 노드 · 어디서 끊겼나)</summary><div class="sec-body">`
     +`<div class="cy-wrap"><div id="cy"></div></div>`
     +`<div class="cy-legend">`
       +`<span><i style="background:#16a34a"></i>있음(적재)</span><span><i style="background:#d97706"></i>단가공백·차원불일치</span>`
       +`<span><i style="background:#dc2626"></i>빠짐·단가행없음</span><span><i style="background:#9ca3af"></i>비대상(점선)</span>`
       +`<span style="color:#dc2626">━ 빨강 점선 = 끊긴 연결(견적 0 원인)</span>`
     +`</div></div></details>`
   +`<details class="sec" open><summary>★ 구성요소 BOM — 어느 구성요소가 빠졌나 (자재·공정·사이즈·도수·옵션)</summary><div class="sec-body">`
     +compBomHTML(p)
     +`</div></details>`
   +`<details class="sec" open><summary>★ 가격구성요소 BOM — 견적이 만들어지는 사슬 (공식→구성요소→단가행)</summary><div class="sec-body">`
     +priceBomHTML(p)
     +`</div></details>`
   +`<details class="sec"><summary>차원 D1~D11 요약 — 예상(권위) vs 실제(라이브 적재)</summary><div class="sec-body">`
     +`<table class="dim"><thead><tr><th style="width:150px">차원</th><th>예상(권위 기준)</th><th>실제(라이브 적재)</th><th style="width:54px">판정</th></tr></thead><tbody>`
     +p.dims.map(dimRow).join("")
     +`</tbody></table></div></details>`
   +`<details class="sec" open><summary>골든 케이스 (계산 검증)</summary><div class="sec-body">`
     +`<table class="dim golden"><tbody>`
       +`<tr><th style="width:120px">입력</th><td>${esc(g.입력||'-')}</td></tr>`
       +`<tr><th>기대가(예전사이트)</th><td><b>${esc(g.기대가||'-')}</b></td></tr>`
       +`<tr><th>실제가(라이브 엔진)</th><td><b>${esc(g.실제가||'-')}</b></td></tr>`
       +`<tr><th>판정</th><td class="st st-${stCls(g.판정==='OK'?'PASS':(g.판정==='-'?'NA':'WARN'))}">${esc(g.판정||'-')}</td></tr>`
     +`</tbody></table></div></details>`
   +`<div class="nextstep"><span class="lbl">다음 한 걸음</span>${esc(p.다음한걸음||'-')}`
     +(p.gate_note?`<div class="gnote">게이트 메모: ${esc(p.gate_note)}</div>`:"")
     +`<div style="color:#9ca3af;font-size:10.5px;margin-top:6px">근거: ${esc(p.근거||'')}</div>`
   +`</div>`;
  renderGraph(p);
}

// ── 탭 전환 (준비도 ↔ 배선 진척 보드) ──
function showTab(t){
  for(const k of ["rv","wb"]){
    document.getElementById("pane-"+k).classList.toggle("active", k===t);
    document.getElementById("tab-"+k).classList.toggle("active", k===t);
  }
}
// 배선 보드에서 상품 클릭 → 준비도 탭으로 이동 + 그 상품 선택(그래프에서 끊긴 지점 확인).
function gotoProduct(cd){ showTab("rv"); selectProd(cd); document.getElementById("rv-detail").scrollTop=0; }

// ── 배선 진척 보드 ──
// 목적: "전 상품의 가격에 영향 주는 구성요소가 가격공식(formula_components)에 배선됐나"를
//        한 화면에서 추적. 결함 4종을 직접 보여주고, 루프(§27 배선 서브트랙)의 진척판으로.
//   고아(ORPHAN)        = 단가행 적재됐는데 어느 공식에도 미배선 → 엔진이 못 봄(견적0/저청구)
//   빈배선(DEAD_WIRE)   = 배선됐는데 단가행 0 (다수 *_TBD = 실무진 확인 BLOCKED·배선 대상 아님)
//   깨진 사슬(BROKEN)   = 상품 견적0원인/단가행전무/차원불일치 (price_bom 파생)
//   미배선 공식(NO_FORMULA) = 상품에 공식 바인딩 0 (배선 이전 단계)
// 종료 척도(§27): 배선 결함 0 + PRICE≠0. 이 보드는 결함을 0으로 모는 진척을 보여준다.
function isTbd(cd){ return /(_TBD|_PENDING|PENDING)/i.test(cd||""); }
function renderWiringBoard(){
  const wb = RV.wiring || {};
  const scan = wb.scan || {}, hasScan = wb.has_scan;
  const orphans = wb.orphans||[], dead = wb.dead_wires||[], deleted = wb.deleted_wires||[];
  const broken = wb.broken_products||[], noFm = wb.no_formula_products||[];
  // 실 배선 대상 결함(고아 + 비-TBD 빈배선 + 삭제오염). *_TBD 빈배선은 실무진 BLOCKED 로 분리.
  const deadReal = dead.filter(d=>!isTbd(d.comp_cd)), deadTbd = dead.filter(d=>isTbd(d.comp_cd));
  const wireDefects = (hasScan? orphans.length + deadReal.length + deleted.length : "?");
  const totalDefects = scan.total_wiring_defects;
  const goNoGo = hasScan && (orphans.length+deadReal.length+deleted.length)===0 && broken.length===0;

  let h = "";
  // ── KPI ──
  h += `<div class="wb-kpis">`
    + kpi(wb.completion+"%", "배선 완성도", "WIRED_OK / 배선대상 "+wb.applicable, wb.completion>=90?"ok":(wb.completion>=60?"warn":"bad"))
    + kpi(hasScan?orphans.length:"—", "고아 구성요소", "단가행有·공식 미배선", orphans.length?"bad":"ok")
    + kpi(hasScan?deadReal.length:"—", "빈 배선(교정)", "배선됐으나 단가행0(비-TBD)", deadReal.length?"warn":"ok")
    + kpi(broken.length, "깨진 사슬", "견적0·단가행전무·차원불일치", broken.length?"bad":"ok")
    + kpi(noFm.length, "미배선 공식", "상품에 가격공식 바인딩 0", noFm.length?"warn":"ok")
    + kpi(hasScan?deadTbd.length:"—", "실무진 BLOCKED", "*_TBD 빈배선(배선 대상 아님)", "")
    + `</div>`;
  h += `<div class="wb-prog"><i style="width:${wb.completion}%"></i></div>`;
  h += `<span class="wb-verdict ${goNoGo?'go':'nogo'}">배선 정합: ${goNoGo?'GO(결함 0)':'NO-GO'}</span>`;
  if(hasScan) h += ` <span style="font-size:11.5px;color:#6b7280">스캐너(${esc(scan.snap||'')}): 공식 ${scan.formulas} · 배선링크 ${scan.wired_links} · 단가행보유 ${scan.components_with_price} · 배선된 ${scan.components_wired} · 배선결함 ${totalDefects}</span>`;
  h += `<p class="wb-note">★ 종료 척도(§27 배선 서브트랙): <b>배선 결함 0 + PRICE≠0</b>. 고아=단가행은 적재됐는데 가격공식에 안 묶여 엔진이 합산 못 함(견적0/저청구 — 명함 박/화이트 클래스가 실증). 실 교정 COMMIT 은 인간 승인 후 §7 dbmap 위임(DB 미적재). ${hasScan?'':'<b style="color:#d97706">스냅샷 스캔본 없음 — 고아/빈배선은 wiring_scan.py 실행 후 표시(현재 details 폴백).</b>'}</p>`;

  // ── 라운드 추적(수렴 추이) ──
  if((wb.rounds||[]).length){
    h += `<div class="wb-sec"><h3>루프 라운드 추적 <span class="cnt">(수렴 추이)</span></h3>`
      + `<table class="wb wb-rounds"><thead><tr><th>R</th><th>스냅샷</th><th>고아</th><th>빈배선</th><th>삭제오염</th><th>총결함</th><th>판정</th><th>메모</th></tr></thead><tbody>`
      + wb.rounds.map(r=>`<tr><td>${esc(r.round)}</td><td class="code">${esc(r.snap||'')}</td><td>${esc(r.orphan)}</td><td>${esc(r.dead_wire)}</td><td>${esc(r.deleted_wire)}</td><td><b>${esc(r.total_defects)}</b></td><td>${esc(r.verdict||'')}</td><td>${esc(r.note||'')}</td></tr>`).join("")
      + `</tbody></table></div>`;
  }

  // ── 고아 구성요소 (핵심 배선 누락) + §13 분류 오버레이 ──
  const CLS_COLOR = { REAL_GAP:"#16a34a", NEEDS_FORMULA:"#d97706", BLOCKED:"#dc2626", LEGIT_UNUSED:"#6b7280" };
  const CLS_LABEL = { REAL_GAP:"즉시배선", NEEDS_FORMULA:"설계선행", BLOCKED:"실무진", LEGIT_UNUSED:"정당미배선" };
  const ocs = wb.orphan_class_summary, ods = wb.orphan_design_summary;
  const DES_COLOR = { COMMITTED:"#0e7490", GO:"#16a34a", "GO*":"#65a30d", DATA_GO_HOLD:"#0891b2", FLAT_RECTIFY:"#7c3aed", GO_CONFIRM:"#16a34a", FIXED_PENDING:"#0891b2", NEEDS_FIX:"#d97706", BLOCKED:"#dc2626" };
  const DES_LABEL = { COMMITTED:"COMMIT완료", GO:"검증 GO", "GO*":"GO(의존)", DATA_GO_HOLD:"데이터GO·보류", FLAT_RECTIFY:"별색재바인딩", GO_CONFIRM:"GO·CONFIRM대기", FIXED_PENDING:"보정완료", NEEDS_FIX:"보정필요", BLOCKED:"BLOCKED강등" };
  h += `<div class="wb-sec"><h3><span class="wb-pill" style="background:#dc2626">고아</span> 단가행 있으나 공식 미배선 <span class="cnt">(${hasScan?orphans.length:'스냅샷 필요'})</span></h3>`;
  if(ocs){
    h += `<div class="wb-note" style="margin:0 0 4px"><b>§13 분류(R1·고아 23 기준):</b> `
      + Object.keys(CLS_LABEL).map(k=>`<span class="wb-pill" style="background:${CLS_COLOR[k]};margin-right:4px">${CLS_LABEL[k]} ${ocs[k]??0}</span>`).join("")
      + ` &nbsp;— ${esc(wb.orphan_class_note||'')}</div>`;
  }
  if(ods){
    const DK = [["COMMITTED","#0e7490"],["GO","#16a34a"],["DATA_GO_HOLD","#0891b2"],["FLAT_RECTIFY","#7c3aed"],["GO_CONFIRM","#16a34a"],["FIXED_PENDING_REVERIFY","#0891b2"],["NEEDS_FIX","#d97706"],["BLOCKED_down","#dc2626"]];
    const DKL = { COMMITTED:"COMMIT완료", GO:"검증 GO", DATA_GO_HOLD:"데이터GO·보류", FLAT_RECTIFY:"별색재바인딩", GO_CONFIRM:"GO·CONFIRM대기", FIXED_PENDING_REVERIFY:"보정완료", NEEDS_FIX:"보정필요", BLOCKED_down:"BLOCKED강등" };
    h += `<div class="wb-note" style="margin:0 0 8px"><b>§18 설계·검증·적재(R2~R3):</b> `
      + DK.filter(([k])=>ods[k]!=null).map(([k,c])=>`<span class="wb-pill" style="background:${c};margin-right:4px">${DKL[k]} ${ods[k]}</span>`).join("")
      + ` &nbsp;골든 verbatim·Claude+codex divergence 0·★박명함 라이브 COMMIT(양면홀로 저청구 회복·고아 23→19)·실 COMMIT 인간 승인 후 §7</div>`;
  }
  if(!hasScan) h += `<p class="wb-note">wiring_scan.py 실행 시 표시.</p>`;
  else if(!orphans.length) h += `<p class="wb-empty">✓ 고아 구성요소 없음</p>`;
  else h += `<table class="wb"><thead><tr><th style="width:78px">§13 분류</th><th style="width:78px">§18 검증</th><th>구성요소 코드</th><th>이름</th><th style="width:46px">단가행</th><th>처방(근거)</th></tr></thead><tbody>`
      + orphans.map(o=>{ const cl=o._class||"", clc=CLS_COLOR[cl]||"#9ca3af", cll=CLS_LABEL[cl]||"미분류";
          const dv=o._design||"", dvc=DES_COLOR[dv]||"#e5e7eb", dvl=DES_LABEL[dv]||"";
          const dchip = dv ? `<span class="wb-pill" style="background:${dvc}">${esc(dvl)}</span>` : `<span style="color:#9ca3af;font-size:10px">-</span>`;
          return `<tr><td><span class="wb-pill" style="background:${clc}">${esc(cll)}</span></td><td>${dchip}</td>`
          + `<td class="code">${esc(o.comp_cd)}<div style="color:#9ca3af">${esc(o.use_dims)}</div></td>`
          + `<td>${esc(o.comp_nm)}</td><td>${esc(o.price_rows)}행</td>`
          + `<td style="font-size:11px">${esc(o._class_note||'')}</td></tr>`; }).join("")
      + `</tbody></table>`;
  h += `</div>`;

  // ── 깨진 사슬(상품) ──
  h += `<div class="wb-sec"><h3><span class="wb-pill" style="background:#dc2626">깨짐</span> 깨진 사슬 — 견적 0/단가행전무 상품 <span class="cnt">(${broken.length})</span></h3>`;
  if(!broken.length) h += `<p class="wb-empty">✓ 깨진 사슬 없음</p>`;
  else h += `<table class="wb"><thead><tr><th style="width:90px">코드</th><th>상품명</th><th style="width:110px">상품군</th><th style="width:48px">등급</th><th>견적0 원인(요약)</th></tr></thead><tbody>`
      + broken.map(b=>`<tr><td class="code wb-link" onclick="gotoProduct('${b.prd_cd}')">${esc(b.prd_cd)}</td><td class="wb-link" onclick="gotoProduct('${b.prd_cd}')">${esc(b.상품명)}</td><td>${esc(b.상품군)}</td><td>${esc(b.등급)}</td><td style="font-size:11px">${(b.견적0원인||[]).map(esc).join('<br>')||'-'}</td></tr>`).join("")
      + `</tbody></table>`;
  h += `</div>`;

  // ── 미배선 공식 (상품) ──
  if(noFm.length){
    h += `<div class="wb-sec"><h3><span class="wb-pill" style="background:#d97706">미배선</span> 공식 미바인딩 상품 <span class="cnt">(${noFm.length})</span></h3>`
      + `<table class="wb"><thead><tr><th style="width:90px">코드</th><th>상품명</th><th style="width:120px">상품군</th><th style="width:48px">등급</th></tr></thead><tbody>`
      + noFm.map(b=>`<tr><td class="code wb-link" onclick="gotoProduct('${b.prd_cd}')">${esc(b.prd_cd)}</td><td class="wb-link" onclick="gotoProduct('${b.prd_cd}')">${esc(b.상품명)}</td><td>${esc(b.상품군)}</td><td>${esc(b.등급)}</td></tr>`).join("")
      + `</tbody></table></div>`;
  }

  // ── 빈 배선 / 삭제오염 ──
  if(hasScan && (deadReal.length||deadTbd.length||deleted.length)){
    h += `<div class="wb-sec"><h3><span class="wb-pill" style="background:#d97706">빈배선</span> 배선됐으나 단가행 0 <span class="cnt">(교정 ${deadReal.length} · 실무진BLOCKED ${deadTbd.length} · 삭제오염 ${deleted.length})</span></h3>`
      + `<table class="wb"><thead><tr><th>가격공식(frm_cd)</th><th>구성요소(comp_cd)</th><th>이름</th><th style="width:90px">분류</th></tr></thead><tbody>`
      + dead.map(d=>`<tr><td class="code">${esc(d.frm_cd)}</td><td class="code">${esc(d.comp_cd)}</td><td>${esc(d.comp_nm)}</td><td>${isTbd(d.comp_cd)?'<span class="wb-pill" style="background:#6b7280">실무진BLOCKED</span>':'<span class="wb-pill" style="background:#d97706">교정</span>'}</td></tr>`).join("")
      + deleted.map(d=>`<tr><td class="code">${esc(d.frm_cd)}</td><td class="code">${esc(d.comp_cd)}</td><td>${esc(d.comp_nm||'')}</td><td><span class="wb-pill" style="background:#dc2626">삭제오염</span></td></tr>`).join("")
      + `</tbody></table></div>`;
  }
  document.getElementById("wb-app").innerHTML = h;
}
function kpi(val,label,sub,cls){
  return `<div class="wb-kpi ${cls||''}"><b>${esc(val)}</b><span>${esc(label)}</span>`
    + `<div style="font-size:10px;color:#9ca3af;margin-top:1px">${esc(sub)}</div></div>`;
}

// ── 부트스트랩 ──
function boot(){
  renderSummary(); renderList(); renderWiringBoard();
  ["f-grade","f-paper"].forEach(id=>document.getElementById(id).addEventListener("change",renderList));
  ["f-widget","f-p0"].forEach(id=>document.getElementById(id).addEventListener("change",renderList));
  document.getElementById("rv-q").addEventListener("input",renderList);
  // ?prd=<코드> 진입 시 자동 선택
  const ip = new URLSearchParams(location.search).get("prd");
  if(ip) selectProd(ip);
}
boot();
"""

# ── 본문 마크업 (standalone·django 공통) ──
BODY = """
<div id="rv-tabs">
  <button id="tab-rv" class="active" onclick="showTab('rv')">상품 준비도</button>
  <button id="tab-wb" onclick="showTab('wb')">배선 진척 보드</button>
</div>

<div id="pane-rv" class="tab-pane active">
<div id="rv-summary"></div>
<div id="rv-app">
  <div id="rv-list">
    <div class="rv-search"><input id="rv-q" type="search" placeholder="상품명/코드 검색…"></div>
    <div id="rv-filters">
      <select id="f-grade"><option value="">등급 전체</option><option value="L0">L0</option><option value="L1">L1</option><option value="L2">L2</option><option value="L3">L3</option><option value="L4">L4</option></select>
      <select id="f-paper"><option value="">종이류 전체</option><option value="Y">종이 Y</option><option value="N">종이 N</option></select>
      <label><input type="checkbox" id="f-widget">위젯대상만</label>
      <label><input type="checkbox" id="f-p0">PRICED-0만</label>
    </div>
    <div id="rv-items"></div>
  </div>
  <div id="rv-detail"><p class="rv-hint">좌측에서 상품을 선택하세요. 상단 요약·필터로 빠르게 좁힐 수 있습니다.</p></div>
</div>
</div>

<div id="pane-wb" class="tab-pane">
  <div id="wb-app"></div>
</div>
"""

CYTO_CDN = "https://unpkg.com/cytoscape@3.30.2/dist/cytoscape.min.js"


def _wiring_status_of(p):
    """상품 price_bom → 배선 건강도 판정(보드 색·집계용).
    WIRED_OK(배선 정상) / BROKEN(견적0·단가행전무·차원불일치) / NO_FORMULA(공식 미바인딩=미배선)
    / DIRECT(직접단가=배선 무관) / NA(공식 비대상)."""
    pb = p.get("price_bom") or {}
    fm = pb.get("formula") or {}
    pcs = pb.get("price_components") or []
    fst = fm.get("status")
    if fst == "direct_price":
        return "DIRECT"
    if fst == "n/a" or (not fm and not pcs):
        return "NA"
    if fst == "missing":
        return "NO_FORMULA"
    bad = [pc for pc in pcs if pc.get("status") in ("단가행_전무", "차원_미스매치")]
    if pb.get("견적0원인") or bad:
        return "BROKEN"
    return "WIRED_OK"


def build_wiring_board(products, wiring):
    """배선 진척 보드 페이로드 — 스캐너(고아·빈배선) + details(상품별 깨진 사슬) 종합.
    스캐너(wiring-status.json) 있으면 고아/빈배선/삭제오염 전역 리스트를 싣고,
    상품별 깨진 사슬/미배선 공식은 details price_bom 에서 파생(스냅샷 없어도 동작)."""
    import collections
    by_status = collections.Counter()
    broken, no_formula = [], []
    for p in products:
        st = _wiring_status_of(p)
        p["_wiring"] = st
        by_status[st] += 1
        if st == "BROKEN":
            pb = p.get("price_bom") or {}
            broken.append({"prd_cd": p.get("prd_cd"), "상품명": p.get("상품명"),
                           "상품군": p.get("상품군"), "등급": p.get("등급"),
                           "견적0원인": (pb.get("견적0원인") or [])[:3]})
        elif st == "NO_FORMULA":
            no_formula.append({"prd_cd": p.get("prd_cd"), "상품명": p.get("상품명"),
                               "상품군": p.get("상품군"), "등급": p.get("등급")})
    applicable = sum(by_status[k] for k in ("WIRED_OK", "BROKEN", "NO_FORMULA"))
    completion = round(by_status["WIRED_OK"] / applicable * 100) if applicable else 0
    scan = (wiring or {}).get("summary") or {}
    # 고아 분류(§13) 오버레이 — 각 고아에 class/target/note 부착 + 분류 집계.
    oc = (wiring or {}).get("orphan_class") or {}
    oc_classes = oc.get("classes") or {}
    oc_meta = oc.get("_meta") or {}
    orphans = (wiring or {}).get("orphans") or []
    for o in orphans:
        c = oc_classes.get(o.get("comp_cd"))
        if c:
            o["_class"] = c.get("class"); o["_target"] = c.get("target"); o["_class_note"] = c.get("note")
            o["_design"] = c.get("design")             # §18 검증 판정(GO/GO*/NEEDS_FIX/BLOCKED)
    board = {
        "scan": scan,                                   # 스캐너 KPI(고아·dead·deleted·verdict)
        "orphans": orphans,                             # 단가행有·공식미배선 = 핵심 배선 누락(분류 오버레이)
        "orphan_class_summary": oc_meta.get("summary"),  # {REAL_GAP,NEEDS_FORMULA,BLOCKED,LEGIT_UNUSED}
        "orphan_design_summary": oc_meta.get("design_summary"),  # {GO,NEEDS_FIX,BLOCKED_down}
        "orphan_class_note": oc_meta.get("note"),
        "dead_wires": (wiring or {}).get("dead_wires") or [],   # 배선됐으나 단가행0(다수 *_TBD=실무진 BLOCKED)
        "deleted_wires": (wiring or {}).get("deleted_wires") or [],
        "rounds": (wiring or {}).get("rounds") or [],
        "by_status": dict(by_status),
        "completion": completion,                       # WIRED_OK / (배선 대상) %
        "applicable": applicable,
        "broken_products": broken,                      # 깨진 사슬(견적0·단가행전무)
        "no_formula_products": no_formula,              # 공식 미바인딩(미배선 전 단계)
        "has_scan": bool(scan),
    }
    return board


def build_payload(products, wiring=None):
    """JS 가 먹을 페이로드(products + 요약 + 카테고리 순서 + 배선 보드) 조립. 파생 플래그 추가."""
    import collections
    cat_order, seen = [], set()
    grades = collections.Counter()
    calc_ok = widget_y = l3plus = 0
    bom_axis_missing = bom_price0 = 0
    comp_sum = 0.0
    for p in products:
        cat = p.get("상품군", "기타")
        if cat not in seen:
            seen.add(cat); cat_order.append(cat)
        grades[p.get("등급", "?")] += 1
        comp_sum += float(p.get("완성률", 0) or 0)
        ev = p.get("근거", "") or ""
        # ── BOM 파생 집계(항목 단위) ──
        cb = p.get("component_bom") or []
        if any(it.get("status") == "missing" for ax in cb for it in (ax.get("items") or [])):
            bom_axis_missing += 1
        pb = p.get("price_bom") or {}
        p["_bom_priced0"] = bool(pb.get("견적0원인"))
        if p["_bom_priced0"]:
            bom_price0 += 1
        # 파생 플래그
        p["_priced0"] = ("PRICED-0" in ev) or p["_bom_priced0"]
        base = p.get("등급", "")
        p["_preverify"] = (base in ("L0", "L1", "L1(기성)", "L2", "L2(반제품)")) and ("골든 미대조" not in (p.get("golden_status") or "") and "PRICE>0" not in (p.get("golden_status") or ""))
        if "calc=OK" in ev or "PRICED" in ev:
            # 계산 성립(PRICE≠0) 판정: calc=OK 또는 PRICED-* (단 PRICED-0 제외)
            if "PRICED-0" not in ev:
                calc_ok += 1
        if p.get("widget_eligible") == "Y":
            widget_y += 1
        if base.startswith("L3") or base.startswith("L4"):
            l3plus += 1
    total = len(products)
    summary = {
        "total": total,
        "avg_completion": round(comp_sum / total, 1) if total else 0,
        "grades": dict(grades),
        "calc_ok": calc_ok,
        "calc_pct": round(calc_ok / total * 100) if total else 0,
        "widget_y": widget_y,
        "l3plus": l3plus,
        "bom_axis_missing": bom_axis_missing,
        "bom_price0": bom_price0,
    }
    wiring_board = build_wiring_board(products, wiring)
    return {"products": products, "summary": summary, "cat_order": cat_order,
            "wiring": wiring_board}


def _load_wiring():
    """배선 스캐너 산출(wiring-status.json + wiring-rounds.csv) 로드(없으면 None=폴백)."""
    if not WIRING_SRC.exists():
        return None
    w = json.loads(WIRING_SRC.read_text(encoding="utf-8"))
    rounds_csv = WIRING_SRC.parent / "wiring-rounds.csv"
    if rounds_csv.exists():
        import csv as _csv
        with rounds_csv.open(encoding="utf-8", newline="") as f:
            w["rounds"] = list(_csv.DictReader(f))
    # 고아 분류(§13 탐지·분류 산출) 오버레이 — 있으면 보드가 분류 칩·집계 표시.
    oc = WIRING_SRC.parent / "orphan-classification.json"
    if oc.exists():
        w["orphan_class"] = json.loads(oc.read_text(encoding="utf-8"))
    return w


def main():
    products = json.loads(SRC.read_text(encoding="utf-8"))
    wiring = _load_wiring()
    payload = build_payload(products, wiring)
    data_json = json.dumps(payload, ensure_ascii=False, separators=(",", ":"))

    # ── ① standalone dashboard.html ──
    standalone = f"""<!doctype html>
<html lang="ko"><head><meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>후니 상품 준비도 대시보드</title>
<!-- Cytoscape: CDN(unpkg). 오프라인/사내망이면 README-integration.md 의 vendored 안내 참고. -->
<script src="{CYTO_CDN}"></script>
<style>{CSS}</style>
</head><body>
{BODY}
<script type="application/json" id="rv-data">{data_json}</script>
<script>{JS}</script>
</body></html>
"""
    (HERE / "dashboard.html").write_text(standalone, encoding="utf-8")

    # ── ② django 드롭인 템플릿 (json_script 임베드·base_site 확장·읽기전용) ──
    dj_dir = HERE / "django_app" / "templates" / "catalog"
    dj_dir.mkdir(parents=True, exist_ok=True)
    django_tpl = (
        '{% extends "admin/base_site.html" %}\n'
        "{% load static %}\n\n"
        "{% block extrahead %}{{ block.super }}\n"
        f'  <script src="{CYTO_CDN}"></script>\n'
        "  {# 오프라인/사내망: cytoscape.min.js 를 static 에 vendoring 후 위 줄을 {% static %} 로 교체(README 참고) #}\n"
        "{% endblock %}\n\n"
        "{% block content %}\n"
        f"<style>{CSS}</style>\n"
        "{% if load_error %}<div style=\"padding:12px 16px;background:#fef2f2;color:#b91c1c;"
        "border:1px solid #fecaca;border-radius:8px;margin:10px;white-space:pre-line;font-size:12.5px\">"
        "{{ load_error }}</div>{% endif %}\n"
        '{{ data|json_script:"rv-data" }}\n'
        f"{BODY}\n"
        f"<script>{JS}</script>\n"
        "{% endblock %}\n"
    )
    (dj_dir / "readiness_viewer.html").write_text(django_tpl, encoding="utf-8")

    wb = payload["wiring"]
    print(f"OK products={payload['summary']['total']} avg={payload['summary']['avg_completion']}% "
          f"calc_ok={payload['summary']['calc_ok']} widget_y={payload['summary']['widget_y']} "
          f"l3plus={payload['summary']['l3plus']}")
    print(f"  배선보드: 완성도 {wb['completion']}% (대상 {wb['applicable']}) "
          f"고아 {wb['scan'].get('orphan_comps','-')} dead {wb['scan'].get('dead_wires','-')} "
          f"깨진사슬 {len(wb['broken_products'])} 미배선공식 {len(wb['no_formula_products'])} "
          f"scan={'Y' if wb['has_scan'] else 'N(폴백)'}")
    print("  ->", HERE / "dashboard.html")
    print("  ->", dj_dir / "readiness_viewer.html")


if __name__ == "__main__":
    main()
