"""통합 결함보드(L3) — 전 Diagnoser 결함을 Defect 하나로 병합 → CSV + HTML + 전역 verdict.

설계 §2 L3·§4: 파편 출력(wiring-status.json / *-defects.csv / …)을 통일 보드로.
정렬 = 돈영향(저/과청구 상단) → 심각도 → 차원 → 상품. 전역 verdict = Σ stop_predicate(AND).

[HARD] 읽기전용 산출(진단 보드). 교정은 P3·재실측은 P4·적재는 인간 게이트.
"""
from __future__ import annotations
import csv
import html
import pathlib
from dataclasses import dataclass

from ..foundation import Snapshot, Defect

_HERE = pathlib.Path(__file__).resolve().parent
OUT_DIR = _HERE

SEV_RANK = {"critical": 0, "high": 1, "medium": 2, "low": 3}
# 돈영향 우선: 저/과청구(돈샘) 상단 → unknown → none
MONEY_RANK = {"undercharge": 0, "overcharge": 0, "unknown": 1, "none": 2}
MONEY_LABEL = {"undercharge": "저청구", "overcharge": "과청구",
               "unknown": "미상", "none": "무관"}
SEV_LABEL = {"critical": "치명", "high": "높음", "medium": "중간", "low": "낮음"}


@dataclass
class BoardResult:
    defects: list          # 전 차원 Defect(정렬됨)
    per_dim: dict          # dimension → list[Defect]
    verdicts: dict         # dimension → bool(stop_predicate)
    titles: dict           # dimension → 한글 라벨
    global_go: bool
    snap_name: str


def _sort_key(d: Defect):
    return (MONEY_RANK.get(d.money_impact, 3), SEV_RANK.get(d.severity, 9),
            d.dimension, d.prd_cd or "", d.comp_cd or "")


def run(diagnosers, snap: Snapshot) -> BoardResult:
    """전 Diagnoser 진단 → 병합·정렬·전역 verdict."""
    per_dim, all_defects, titles = {}, [], {}
    for dx in diagnosers:
        ds = dx.scan(snap)
        per_dim[dx.dimension] = ds
        titles[dx.dimension] = dx.title or dx.dimension
        all_defects.extend(ds)
    verdicts = {dx.dimension: dx.stop_predicate(all_defects) for dx in diagnosers}
    all_defects.sort(key=_sort_key)
    return BoardResult(
        defects=all_defects, per_dim=per_dim, verdicts=verdicts, titles=titles,
        global_go=all(verdicts.values()), snap_name=snap.dir.name,
    )


# ── CSV ──────────────────────────────────────────────────────────────
_COLS = ["dimension", "money_impact", "severity", "prd_cd", "comp_cd", "frm_cd",
         "summary", "suggested_fix", "authority_ref", "evidence"]


def write_csv(res: BoardResult, path: pathlib.Path | None = None) -> pathlib.Path:
    path = path or (OUT_DIR / "defect-board.csv")
    with path.open("w", encoding="utf-8", newline="") as f:
        w = csv.writer(f)
        w.writerow(_COLS)
        for d in res.defects:
            w.writerow([d.dimension, d.money_impact, d.severity, d.prd_cd or "",
                        d.comp_cd or "", d.frm_cd or "", d.summary, d.suggested_fix,
                        d.authority_ref, _compact(d.evidence)])
    return path


def _compact(ev: dict) -> str:
    if not ev:
        return ""
    parts = []
    for k, v in ev.items():
        if isinstance(v, (list, tuple)):
            v = ",".join(str(x) for x in v)[:120]
        parts.append(f"{k}={v}")
    return " | ".join(parts)[:300]


# ── HTML(실무진 열람) ─────────────────────────────────────────────────
def write_html(res: BoardResult, path: pathlib.Path | None = None) -> pathlib.Path:
    path = path or (OUT_DIR / "defect-board.html")

    # 차원별 요약 배지
    badges = []
    for dim, ok in res.verdicts.items():
        n = len(res.per_dim.get(dim, []))
        cls = "ok" if ok else "ng"
        mark = "GO" if ok else f"NO-GO({n})"
        badges.append(
            f'<span class="badge {cls}">{html.escape(res.titles.get(dim, dim))}: {mark}</span>')

    gclass = "ok" if res.global_go else "ng"
    gmark = "GO — 전 차원 결함 해소" if res.global_go else "NO-GO — 결함 잔존"

    # 돈영향 카운트
    money_n = sum(1 for d in res.defects if d.money_impact in ("undercharge", "overcharge"))
    crit_n = sum(1 for d in res.defects if d.severity == "critical")

    rows_html = []
    for d in res.defects:
        m = d.money_impact
        rowcls = "money" if m in ("undercharge", "overcharge") else ""
        rows_html.append(
            "<tr class='{rc}' data-dim='{dim}' data-money='{m}' data-sev='{sev}'>"
            "<td>{dim}</td>"
            "<td class='m-{m}'>{ml}</td>"
            "<td class='s-{sev}'>{sl}</td>"
            "<td>{prd}</td><td>{comp}</td>"
            "<td>{summ}</td><td class='fix'>{fix}</td><td class='ev'>{ev}</td></tr>".format(
                rc=rowcls, dim=html.escape(d.dimension), m=m,
                ml=MONEY_LABEL.get(m, m), sev=d.severity, sl=SEV_LABEL.get(d.severity, d.severity),
                prd=html.escape(d.prd_cd or ""), comp=html.escape(d.comp_cd or ""),
                summ=html.escape(d.summary), fix=html.escape(d.suggested_fix),
                ev=html.escape(_compact(d.evidence))))

    doc = _TEMPLATE.format(
        snap=html.escape(res.snap_name),
        gclass=gclass, gmark=html.escape(gmark),
        total=len(res.defects), money_n=money_n, crit_n=crit_n,
        badges="\n".join(badges),
        rows="\n".join(rows_html) or "<tr><td colspan='8'>결함 없음 — 전 차원 GO</td></tr>",
    )
    path.write_text(doc, encoding="utf-8")
    return path


_TEMPLATE = """<!doctype html>
<html lang="ko"><head><meta charset="utf-8">
<title>hdx 통합 결함보드 — {snap}</title>
<style>
 body{{font:14px/1.5 -apple-system,BlinkMacSystemFont,"Apple SD Gothic Neo",sans-serif;margin:24px;color:#1a1a1a}}
 h1{{font-size:20px;margin:0 0 4px}}
 .sub{{color:#666;margin-bottom:16px}}
 .verdict{{display:inline-block;padding:6px 14px;border-radius:6px;font-weight:700;font-size:16px}}
 .verdict.ok{{background:#e6f4ea;color:#137333}} .verdict.ng{{background:#fce8e6;color:#c5221f}}
 .badges{{margin:12px 0}}
 .badge{{display:inline-block;padding:3px 9px;margin:2px;border-radius:4px;font-size:12px}}
 .badge.ok{{background:#e6f4ea;color:#137333}} .badge.ng{{background:#fce8e6;color:#c5221f}}
 .kpi{{margin:12px 0;color:#444}}
 .kpi b{{color:#c5221f}}
 .filters{{margin:12px 0}} .filters button{{margin-right:6px;padding:4px 10px;cursor:pointer;border:1px solid #ccc;background:#fff;border-radius:4px}}
 .filters button.active{{background:#1a73e8;color:#fff;border-color:#1a73e8}}
 table{{border-collapse:collapse;width:100%;font-size:13px}}
 th,td{{border:1px solid #e0e0e0;padding:6px 8px;text-align:left;vertical-align:top}}
 th{{background:#f5f5f5;position:sticky;top:0;cursor:pointer}}
 tr.money{{background:#fff8e1}}
 .m-undercharge,.m-overcharge{{color:#c5221f;font-weight:700}}
 .s-critical{{color:#c5221f;font-weight:700}} .s-high{{color:#e8710a;font-weight:600}}
 td.ev{{color:#666;font-size:11px;max-width:320px;word-break:break-all}}
 td.fix{{color:#137333;font-size:12px;max-width:260px}}
</style></head><body>
<h1>hdx 통합 진단·교정 배치 — 결함보드</h1>
<div class="sub">스냅샷 {snap} · 가격 도메인 파일럿(5 Diagnoser) · 읽기전용 진단(교정=P3·재실측=P4·적재=인간)</div>
<div class="verdict {gclass}">전역 판정: {gmark}</div>
<div class="badges">{badges}</div>
<div class="kpi">총 결함 <b>{total}</b>건 · 돈영향(저/과청구) <b>{money_n}</b>건 · 치명 <b>{crit_n}</b>건</div>
<div class="filters">
 <button data-f="all" class="active">전체</button>
 <button data-f="money">돈영향만</button>
 <button data-f="critical">치명만</button>
</div>
<table id="t"><thead><tr>
 <th>차원</th><th>돈영향</th><th>심각도</th><th>상품(prd_cd)</th><th>구성요소(comp_cd)</th>
 <th>결함</th><th>제안 교정</th><th>증거</th>
</tr></thead><tbody>
{rows}
</tbody></table>
<script>
 const tb=document.querySelector('#t tbody');
 document.querySelectorAll('.filters button').forEach(b=>b.onclick=()=>{{
   document.querySelectorAll('.filters button').forEach(x=>x.classList.remove('active'));
   b.classList.add('active');const f=b.dataset.f;
   tb.querySelectorAll('tr').forEach(tr=>{{
     let show=true;
     if(f==='money') show=tr.classList.contains('money');
     if(f==='critical') show=tr.dataset.sev==='critical';
     tr.style.display=show?'':'none';
   }});
 }});
 // 컬럼 클릭 정렬
 document.querySelectorAll('#t th').forEach((th,i)=>th.onclick=()=>{{
   const rows=[...tb.querySelectorAll('tr')];
   const asc=th._asc=!th._asc;
   rows.sort((a,b)=>{{const x=a.cells[i].innerText,y=b.cells[i].innerText;
     return asc?x.localeCompare(y):y.localeCompare(x);}});
   rows.forEach(r=>tb.appendChild(r));
 }});
</script>
</body></html>"""
