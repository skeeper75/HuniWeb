# -*- coding: utf-8 -*-
"""linkage.json → 연결 무결성 전수 리포트 HTML(자립·CSP 안전).

재생성: python3 _workspace/_foundation/hdx/board/build_linkage_report.py
입력 linkage.json 재생성은 LinkageDx/LinkageRmd 산출을 덤프(README 참조).
"""
import json, pathlib
HERE = pathlib.Path(__file__).resolve().parent
data = json.load(open(HERE/"linkage.json", encoding="utf-8"))
payload = json.dumps(data, ensure_ascii=False)

HTML = r"""<title>연결 무결성 전수 리포트 — 후니 가격 배선</title>
<style>
  :root{
    --paper:#F4F5F2; --surface:#FEFEFD; --ink:#1A1D1B; --muted:#5A635E; --faint:#8A928D;
    --accent:#1E5F72; --accent-soft:#DCE8EB; --border:#E2E4DF; --border2:#D2D6D0;
    --crit:#A6392E; --high:#BC6B1E; --med:#9A8332; --low:#737C77;
    --crit-bg:#F6E7E4; --high-bg:#F7ECDD; --med-bg:#F3EED9; --low-bg:#ECEEEB;
    --leak:#A6392E;
  }
  *{box-sizing:border-box}
  body{margin:0;background:var(--paper);color:var(--ink);
    font-family:system-ui,-apple-system,"Segoe UI",Roboto,"Helvetica Neue",sans-serif;
    line-height:1.55;-webkit-font-smoothing:antialiased}
  .mono{font-family:ui-monospace,"SF Mono",Menlo,Consolas,monospace}
  .wrap{max-width:1120px;margin:0 auto;padding:0 24px 96px}
  a{color:var(--accent)}
  header{border-bottom:1px solid var(--border2);background:
    linear-gradient(180deg,#EEF1EE 0%,var(--paper) 100%)}
  .head-in{max-width:1120px;margin:0 auto;padding:40px 24px 30px}
  .eyebrow{font-size:12px;letter-spacing:.16em;text-transform:uppercase;color:var(--accent);
    font-weight:600;margin:0 0 10px}
  h1{font-size:clamp(26px,4vw,38px);line-height:1.12;margin:0 0 14px;font-weight:700;
    letter-spacing:-.02em;text-wrap:balance;max-width:20ch}
  .lede{font-size:16px;color:var(--muted);margin:0;max-width:64ch}
  .meta{display:flex;flex-wrap:wrap;gap:10px 22px;margin-top:22px;font-size:13px;color:var(--muted)}
  .meta b{color:var(--ink);font-weight:600}
  .verdict{display:inline-flex;align-items:center;gap:8px;background:#fff;border:1px solid var(--border2);
    border-radius:999px;padding:6px 14px;font-size:13px;font-weight:600}
  .dot{width:9px;height:9px;border-radius:50%;background:var(--high)}
  section{margin-top:44px}
  h2{font-size:13px;letter-spacing:.12em;text-transform:uppercase;color:var(--muted);
    font-weight:600;margin:0 0 16px;padding-bottom:9px;border-bottom:1px solid var(--border)}
  .note{font-size:14.5px;color:var(--muted);margin:0 0 18px;max-width:70ch}
  .note b{color:var(--ink)}
  .chain{background:var(--surface);border:1px solid var(--border);border-radius:12px;
    padding:26px 22px;overflow-x:auto}
  .chain-row{display:flex;align-items:stretch;gap:0;min-width:640px}
  .node{flex:1 1 0;text-align:center;padding:14px 8px;border:1px solid var(--border2);
    border-radius:9px;background:#fff}
  .node .nt{font-weight:700;font-size:14px}
  .node .ns{font-size:11.5px;color:var(--faint);margin-top:3px}
  .link{flex:0 0 118px;display:flex;flex-direction:column;justify-content:center;align-items:center;
    padding:0 6px;position:relative}
  .link .arrows{font-size:13px;color:var(--accent);font-weight:600;line-height:1.3}
  .link .ecode{font-size:10.5px;letter-spacing:.08em;color:var(--faint);margin-top:2px}
  .link .cnt{margin-top:7px;font-size:12px;font-weight:700;padding:3px 9px;border-radius:999px;
    background:var(--accent-soft);color:var(--accent);white-space:nowrap}
  .link .cnt.zero{background:#EAF0EA;color:#5E8A5E}
  .chain-cap{font-size:12.5px;color:var(--faint);margin-top:14px;text-align:center}
  .cards{display:grid;grid-template-columns:repeat(auto-fit,minmax(150px,1fr));gap:12px}
  .card{background:var(--surface);border:1px solid var(--border);border-radius:11px;padding:16px 16px 15px;
    position:relative;overflow:hidden}
  .card::before{content:"";position:absolute;left:0;top:0;bottom:0;width:3px;background:var(--stripe,var(--low))}
  .card .cn{font-size:30px;font-weight:700;letter-spacing:-.02em;font-variant-numeric:tabular-nums}
  .card .cl{font-size:12.5px;color:var(--muted);margin-top:2px}
  .card .cs{font-size:11.5px;color:var(--faint);margin-top:8px}
  .route{display:grid;grid-template-columns:repeat(auto-fit,minmax(220px,1fr));gap:12px}
  .ritem{background:var(--surface);border:1px solid var(--border);border-radius:11px;padding:15px 16px}
  .ritem .rc{display:flex;align-items:center;gap:8px;font-size:12px;font-weight:600;
    text-transform:uppercase;letter-spacing:.05em}
  .ritem .rn{font-size:24px;font-weight:700;margin:8px 0 2px;font-variant-numeric:tabular-nums}
  .ritem .rd{font-size:13px;color:var(--muted)}
  .chip{width:9px;height:9px;border-radius:2px;display:inline-block}
  .filters{display:flex;flex-wrap:wrap;gap:8px;margin:0 0 18px}
  .fbtn{font:inherit;font-size:13px;padding:6px 13px;border-radius:999px;border:1px solid var(--border2);
    background:#fff;color:var(--muted);cursor:pointer;transition:.12s}
  .fbtn:hover{border-color:var(--accent);color:var(--accent)}
  .fbtn[aria-pressed="true"]{background:var(--ink);color:#fff;border-color:var(--ink)}
  .fbtn:focus-visible{outline:2px solid var(--accent);outline-offset:2px}
  .grp{margin-bottom:26px}
  .grp-h{display:flex;align-items:baseline;gap:12px;flex-wrap:wrap;margin:0 0 4px}
  .grp-h .gt{font-size:17px;font-weight:700;letter-spacing:-.01em}
  .grp-h .gdir{font-size:11.5px;letter-spacing:.08em;text-transform:uppercase;font-weight:600;
    padding:2px 9px;border-radius:999px}
  .gdir.fwd{background:var(--accent-soft);color:var(--accent)}
  .gdir.rev{background:#F0E6EC;color:#8E3E68}
  .grp-h .gc{font-size:13px;color:var(--faint);font-variant-numeric:tabular-nums}
  .grp-desc{font-size:13.5px;color:var(--muted);margin:0 0 12px;max-width:74ch}
  table{width:100%;border-collapse:collapse;font-size:13.5px;background:var(--surface);
    border:1px solid var(--border);border-radius:10px;overflow:hidden}
  thead th{text-align:left;font-size:11px;letter-spacing:.06em;text-transform:uppercase;color:var(--faint);
    font-weight:600;padding:9px 13px;border-bottom:1px solid var(--border2);background:#F7F8F6}
  tbody td{padding:10px 13px;border-bottom:1px solid var(--border);vertical-align:top}
  tbody tr:last-child td{border-bottom:none}
  tbody tr:hover{background:#F7F9F7}
  .sev{display:inline-block;font-size:10.5px;font-weight:700;letter-spacing:.04em;text-transform:uppercase;
    padding:2px 8px;border-radius:5px;white-space:nowrap}
  .sev.critical{background:var(--crit-bg);color:var(--crit)}
  .sev.high{background:var(--high-bg);color:var(--high)}
  .sev.medium{background:var(--med-bg);color:var(--med)}
  .sev.low{background:var(--low-bg);color:var(--low)}
  .leak{color:var(--leak);font-weight:600;font-size:11.5px;white-space:nowrap}
  .pname{font-weight:600}
  .code{font-size:11.5px;color:var(--faint)}
  .fix{color:var(--muted);font-size:12.5px}
  .empty{color:var(--faint);font-size:13.5px;padding:18px 4px}
  footer{margin-top:56px;padding-top:20px;border-top:1px solid var(--border);
    font-size:12.5px;color:var(--faint);max-width:74ch}
  @media (max-width:640px){
    thead{display:none}
    tbody td{display:block;padding:5px 13px}
    tbody tr{display:block;padding:8px 0;border-bottom:1px solid var(--border2)}
    tbody td[data-l]::before{content:attr(data-l);display:inline-block;width:76px;color:var(--faint);
      font-size:11px;text-transform:uppercase;letter-spacing:.04em}
  }
</style>

<header>
  <div class="head-in">
    <p class="eyebrow">후니 가격엔진 · 배선 연결 무결성 진단</p>
    <h1>상품 → 공식 → 구성요소 → 가격, 어디서 선이 끊겼나</h1>
    <p class="lede">실무진이 관리자(webadmin)에서 기준정보를 고치거나 이름을 바꾸면 상품·공식·구성요소를
      잇는 연결이 끊겨 가격이 안 나올 수 있습니다. 이 리포트는 그 연결 고리를 <b>정방향과 역방향 양쪽으로</b>
      한 바퀴 훑어, 끊긴 지점을 전수로 정리한 것입니다.</p>
    <div class="meta">
      <span class="verdict"><span class="dot"></span> 전역 NO-GO · <b id="mtotal"></b>건 단절</span>
      <span>스코프 <b>linkage</b> (배선 연결 전용)</span>
      <span>스냅샷 <b>snap_20260704_1554</b> · 라운드 <b>1</b></span>
      <span>실행 <b class="mono">--scope linkage --loop</b></span>
    </div>
  </div>
</header>

<div class="wrap">

  <section>
    <h2>먼저 — 지금은 rename 단절이 없다</h2>
    <p class="note">좋은 소식부터. 지금 이 순간 <b>참조가 깨진 dangling 단절(E2 공식→구성요소 정방향)과
      차원 미선언(E3)은 0건</b>입니다. 즉 실무진 편집으로 <b>지금 당장 끊긴 배선은 없고</b>, 골격은 온전합니다.
      잡힌 <b id="itotal"></b>건은 대부분 ① 아직 안 끝난 아크릴 상품, ② 손님이 고를 수 있는데 단가행이 비어있는
      커버리지 갭, ③ 비활성 상품에 남은 청소 대상입니다. 이 진단기는 앞으로 실무진이 코드를 지웠다 다시
      만들거나 이름을 바꿔 선이 끊기는 순간, <b>역방향에서 즉시 포착</b>하도록 자리를 잡아 둔 것입니다.</p>
  </section>

  <section>
    <h2>연결 체인 — 4개 이음매를 양방향으로</h2>
    <div class="chain">
      <div class="chain-row">
        <div class="node"><div class="nt">상품</div><div class="ns">296개 판매품</div></div>
        <div class="link"><div class="arrows">&rarr; 정 &middot; 역 &larr;</div><div class="ecode">E1</div>
          <div class="cnt" id="c-E1">&middot;</div></div>
        <div class="node"><div class="nt">가격공식</div><div class="ns">110개</div></div>
        <div class="link"><div class="arrows">&rarr; 정 &middot; 역 &larr;</div><div class="ecode">E2</div>
          <div class="cnt" id="c-E2">&middot;</div></div>
        <div class="node"><div class="nt">구성요소</div><div class="ns">197개</div></div>
        <div class="link"><div class="arrows">&rarr; 정 &middot; 역 &larr;</div><div class="ecode">E3&middot;E4</div>
          <div class="cnt" id="c-E34">&middot;</div></div>
        <div class="node"><div class="nt">단가행 &middot; 차원</div><div class="ns">자재&middot;공정&middot;옵션&middot;사이즈</div></div>
      </div>
      <p class="chain-cap">각 이음매(E1~E4)를 <b>정방향</b>(부모가 가리키는 자식이 살아있나)과
        <b>역방향</b>(자식이 유효한 부모에 닿아있나) 양쪽으로 확인. 숫자 = 그 이음매의 단절 건수.</p>
    </div>
  </section>

  <section>
    <h2>이음매별 단절 (양방향)</h2>
    <div class="cards" id="edgecards"></div>
  </section>

  <section>
    <h2>교정 경로 — 누가 무엇을 채우나</h2>
    <p class="note">[HARD] <b>값 날조 금지</b> — 단가&middot;구성 값은 권위 엑셀/실무진에서만 옵니다. 스크립트는
      <b>안전한 재연결만 자동</b>(구성요소 use_dims 정합&middot;가격이 안 바뀌는 순수 정합)하고, 값이 필요하거나
      가격이 바뀌는 교정은 사람 확인 후 적용합니다. 이번 라운드 자동교정 대상 <b>0건</b>(안전 재연결할 끊김이
      현재 없음) — 68건은 모두 사람 손이 필요합니다.</p>
    <div class="route" id="routing"></div>
  </section>

  <section>
    <h2>전수 목록 — 무엇이 어떻게 끊겼나</h2>
    <div class="filters" id="filters"></div>
    <div id="groups"></div>
  </section>

  <footer>
    산출: <span class="mono">hdx --scope linkage</span> (진단기 <span class="mono">LinkageDx</span> &middot;
    교정기 <span class="mono">LinkageRmd</span> &middot; 셀프테스트 6/6 GO). 원자료 =
    <span class="mono">board/defect-board.csv</span> &middot; 라운드 종합 =
    <span class="mono">loop/round-report.md</span>. 라이브 읽기전용 스냅샷 기준 —
    실 교정 COMMIT&middot;webadmin 실화면은 인간 게이트.
  </footer>
</div>

<script>
const DATA = __PAYLOAD__;
const D = DATA.defects, R = DATA.routing;
const SEVRANK = {critical:0, high:1, medium:2, low:3};
const EDGES = [
  {k:"E1F", lbl:"상품 → 공식", dir:"forward",
   desc:"상품이 참조하는 가격공식이 없거나 비활성이면 가격이 안 나옵니다. 비활성 상품에 남은 배선은 청소 대상입니다."},
  {k:"E1R", lbl:"공식 → 상품 (역방향)", dir:"reverse",
   desc:"살아있는 공식인데 어떤 상품도 이 공식을 안 씁니다 — 상품 쪽 연결이 떨어졌거나 미사용 공식. 붙일 상품을 확인하거나 비활성 처리."},
  {k:"E2F", lbl:"공식 → 구성요소", dir:"forward",
   desc:"공식이 없는/삭제된 구성요소를 물고 있으면 배선이 끊긴 것. 삭제후재등록(이름 같은 활성 comp 존재) 흔적이면 재연결 후보."},
  {k:"E2R", lbl:"구성요소 → 공식 (역방향)", dir:"reverse",
   desc:"구성요소가 어떤 공식에도 안 붙었거나(고아), 배선은 됐는데 단가행이 0(빈 배선). 아직 단가·구성 미입력인 placeholder가 여기 잡힙니다."},
  {k:"E3", lbl:"구성요소 → 단가행 차원", dir:"reverse",
   desc:"단가행은 차원(사이즈·자재 등)을 구분하는데 구성요소가 그 차원을 use_dims에 선언 안 함 → 엔진이 무시. 안전 자동 재연결 대상."},
  {k:"E4", lbl:"상품 선택 ↔ 단가행", dir:"forward",
   desc:"손님이 고를 수 있는 값(자재·공정·옵션·사이즈)인데 대응하는 단가행이 없음 → 그 선택은 가격에 안 잡힘(저청구). 권위 단가 확보 후 적재."},
];
const ROUTE_STYLE = {
  auto_data:{c:"#2E7D5B", t:"자동 교정"}, needs_authority:{c:"#BC6B1E", t:"권위값 확보"},
  blocked_human:{c:"#A6392E", t:"실무진 입력"}, needs_design:{c:"#7A5AA6", t:"가격설계"},
  needs_engine:{c:"#405A8A", t:"엔진 변경"}, review:{c:"#737C77", t:"수동 검토"},
};

document.getElementById("mtotal").textContent = D.length;
document.getElementById("itotal").textContent = D.length;

const cnt = k => D.filter(d=>d.edge===k).length;
function setCnt(id, n){ const e=document.getElementById(id); e.textContent=n+"건"; if(n===0) e.classList.add("zero"); }
setCnt("c-E1", cnt("E1F")+cnt("E1R"));
setCnt("c-E2", cnt("E2F")+cnt("E2R"));
setCnt("c-E34", cnt("E3")+cnt("E4"));

const SEVCOL={critical:"var(--crit)",high:"var(--high)",medium:"var(--med)",low:"var(--low)"};
const ec = document.getElementById("edgecards");
EDGES.forEach(e=>{
  const rows = D.filter(d=>d.edge===e.k);
  const n = rows.length;
  const worst = rows.length ? rows.map(r=>r.sev).sort((a,b)=>SEVRANK[a]-SEVRANK[b])[0] : "low";
  const leak = rows.filter(r=>r.money==="undercharge").length;
  const div=document.createElement("div"); div.className="card";
  div.style.setProperty("--stripe", n? SEVCOL[worst] : "var(--low)");
  div.innerHTML = `<div class="cn">${n}</div>
    <div class="cl">${e.k} · ${e.lbl}</div>
    <div class="cs">${n? `최고 심각도 ${worst}${leak?` · 저청구 ${leak}`:""}` : "단절 없음 ✓"}</div>`;
  ec.appendChild(div);
});

const rt = document.getElementById("routing");
const order=["auto_data","blocked_human","needs_authority","needs_design","needs_engine","review"];
const byCls={};
R.forEach(r=>{ byCls[r.cls]=(byCls[r.cls]||0)+r.n; });
if(!("auto_data" in byCls)) byCls["auto_data"]=0;
order.filter(c=>c in byCls).forEach(c=>{
  const st=ROUTE_STYLE[c]; const n=byCls[c];
  const titles=R.filter(r=>r.cls===c).map(r=>r.title).join(" · ") || "안전 재연결(use_dims 정합) 대상 없음";
  const div=document.createElement("div"); div.className="ritem";
  div.innerHTML=`<div class="rc"><span class="chip" style="background:${st.c}"></span>${st.t}</div>
    <div class="rn" style="color:${st.c}">${n}<span style="font-size:13px;color:var(--faint);font-weight:400"> 결함</span></div>
    <div class="rd">${titles}</div>`;
  rt.appendChild(div);
});

const fdefs=[{k:"all",t:"전체"},{k:"sev:high",t:"돈 새는 것 (high↑)"},
  {k:"dir:reverse",t:"역방향만"},{k:"dir:forward",t:"정방향만"},
  ...EDGES.filter(e=>cnt(e.k)>0).map(e=>({k:"edge:"+e.k,t:e.k}))];
let active="all";
const fc=document.getElementById("filters");
fdefs.forEach(f=>{
  const b=document.createElement("button"); b.className="fbtn"; b.textContent=f.t;
  b.setAttribute("aria-pressed", f.k===active); b.dataset.k=f.k;
  b.onclick=()=>{active=f.k; [...fc.children].forEach(x=>x.setAttribute("aria-pressed",x.dataset.k===active)); render();};
  fc.appendChild(b);
});

function pass(d){
  if(active==="all") return true;
  if(active.startsWith("edge:")) return d.edge===active.slice(5);
  if(active.startsWith("dir:")) return d.dir===active.slice(4);
  if(active==="sev:high") return d.sev==="critical"||d.sev==="high";
  return true;
}

const groups=document.getElementById("groups");
function render(){
  groups.innerHTML="";
  let shown=0;
  EDGES.forEach(e=>{
    const rows=D.filter(d=>d.edge===e.k && pass(d))
      .sort((a,b)=>SEVRANK[a.sev]-SEVRANK[b.sev] || (a.nm||"").localeCompare(b.nm||""));
    if(!rows.length) return;
    shown+=rows.length;
    const g=document.createElement("div"); g.className="grp";
    const dircls=e.dir==="reverse"?"rev":"fwd";
    const dirlbl=e.dir==="reverse"?"역방향":"정방향";
    let html=`<div class="grp-h"><span class="gt">${e.k} · ${e.lbl}</span>
      <span class="gdir ${dircls}">${dirlbl}</span><span class="gc">${rows.length}건</span></div>
      <p class="grp-desc">${e.desc}</p>
      <table><thead><tr><th>심각도</th><th>상품 / 대상</th><th>무엇이 끊겼나</th><th>어떻게 잇나</th></tr></thead><tbody>`;
    rows.forEach(d=>{
      const who = d.nm ? `<span class="pname">${esc(d.nm)}</span> <span class="code mono">${esc(d.prd)}</span>`
        : d.frmnm ? `<span class="pname">${esc(d.frmnm)}</span> <span class="code mono">${esc(d.frm)}</span>`
        : d.compnm ? `<span class="pname">${esc(d.compnm)}</span> <span class="code mono">${esc(d.comp)}</span>`
        : `<span class="code mono">${esc(d.comp||d.frm||"—")}</span>`;
      const leak = d.money==="undercharge" ? `<div class="leak">↓ 저청구</div>` : "";
      const sumtxt = esc(d.sum.replace(/^\[[^\]]*\]\s*/,""));
      html+=`<tr>
        <td data-l="심각도"><span class="sev ${d.sev}">${d.sev}</span>${leak}</td>
        <td data-l="대상">${who}</td>
        <td data-l="단절">${sumtxt}</td>
        <td data-l="교정" class="fix">${esc(d.fix)}</td></tr>`;
    });
    html+=`</tbody></table>`;
    g.innerHTML=html; groups.appendChild(g);
  });
  if(!shown) groups.innerHTML='<p class="empty">이 필터에 해당하는 단절이 없습니다.</p>';
}
function esc(s){return (s||"").replace(/[&<>"]/g,c=>({"&":"&amp;","<":"&lt;",">":"&gt;",'"':"&quot;"}[c]));}
render();
</script>
"""

out = HTML.replace("__PAYLOAD__", payload)
(HERE/"linkage-report.html").write_text(out, encoding="utf-8")
print("wrote", HERE/"linkage-report.html", len(out), "bytes")
