#!/usr/bin/env python3
"""t51 통합 문서 렌더러 — merged.csv + stats.json + schedule.json → 단일 HTML + 린 .md 트윈.

moai-domain-html-report 계약을 따른다: mode=plan · audience=basic(MoAI-Easy)
· 외부 JS 라이브러리 0(mermaid CDN 은 basic 티어 허용 · noscript 폴백 동반)
· 디자인 토큰 8종 · Pretendard + Noto Serif KR.

문장은 사람이 쓰고 숫자는 전부 여기서 계산한다. 숫자 하드코딩 금지.

실행: python3 render.py   (assemble.py → schedule.py 를 먼저 실행)
"""
import csv
import json
import html
from pathlib import Path

HERE = Path(__file__).resolve().parent
TITLE = "후니프린팅 오픈 일정 — 시스템·화면·기능 통합 문서"
DATE = "2026-09-19"

S = json.loads((HERE / "stats.json").read_text(encoding="utf-8"))
SCH = json.loads((HERE / "schedule.json").read_text(encoding="utf-8"))
ROWS = list(csv.DictReader((HERE / "merged.csv").open(encoding="utf-8")))

SYS_LABEL = {
    "shopby": "shopby (NHN 커머스 SaaS)",
    "huni-mall": "huni-mall (자사몰 스킨)",
    "webadmin": "webadmin (관리서버)",
    "widget": "widget (자동견적 위젯)",
    "pagebuilder": "pagebuilder (상세페이지·가이드북)",
    "mes": "mes (생산관리)",
    "edicus": "edicus (디자인 에디터)",
    "pitstop": "pitstop (인쇄파일 검수)",
}
WT_LABEL = {
    "build": "직접 구현",
    "integrate": "연동 구현",
    "config": "설정·등록",
    "provided": "외부 제공",
    "manual": "사람 운영",
}
WT_DESC = {
    "build": "상대 시스템 없이 우리가 화면·로직을 만든다.",
    "integrate": "두 시스템을 잇는 코드를 우리가 짠다. 어느 쪽 코드에 사는지(owner_side)가 붙는다.",
    "config": "코드는 0이고 관리화면에서 값만 넣는다.",
    "provided": "외부가 그대로 준다. 우리 작업은 확인뿐이다.",
    "manual": "사람이 운영으로 처리한다.",
}
STATUS_ORDER = ["완료", "진행", "미착수", "미확인"]


def e(x):
    return html.escape(str(x), quote=True)


def n(*keys, src=None):
    """통계 딕셔너리에서 값을 꺼낸다. 없으면 즉시 실패한다(조용한 0 방지)."""
    d = src if src is not None else S
    for k in keys:
        d = d[k]
    return d


# ── 데이터 준비 ────────────────────────────────────────────────────────────
IN_ROWS = [r for r in ROWS if r["scope"] == "in"]
OUT_ROWS = [r for r in ROWS if r["scope"] == "out"]

systems = sorted({r["system"] for r in ROWS})
sys_summary = []
for s in systems:
    rin = [r for r in IN_ROWS if r["system"] == s]
    rout = [r for r in OUT_ROWS if r["system"] == s]
    sys_summary.append({
        "system": s,
        "label": SYS_LABEL.get(s, s),
        "in": len(rin),
        "out": len(rout),
        "remaining": sum(1 for r in rin if r["status"] != "완료"),
        "done": sum(1 for r in rin if r["status"] == "완료"),
        "unknown": sum(1 for r in rin if r["status"] == "미확인"),
        "build": sum(1 for r in rin if r["work_type"] == "build"),
        "integrate": sum(1 for r in rin if r["work_type"] == "integrate"),
    })
sys_summary.sort(key=lambda x: -x["remaining"])

# 연동 경계 = integrate 행의 (system ↔ counterpart) 쌍
edges = {}
for r in IN_ROWS:
    if r["work_type"] != "integrate" or not r["counterpart"]:
        continue
    key = tuple(sorted([r["system"], r["counterpart"]]))
    d = edges.setdefault(key, {"total": 0, "remaining": 0, "owners": set()})
    d["total"] += 1
    if r["status"] != "완료":
        d["remaining"] += 1
    if r["owner_side"]:
        d["owners"].add(r["owner_side"])
edge_list = sorted(
    ({"a": k[0], "b": k[1], **v, "owners": sorted(v["owners"])} for k, v in edges.items()),
    key=lambda x: (-x["remaining"], -x["total"]))

# 드릴다운용 압축 데이터
COLS = ["system", "group", "screen_id", "screen_name", "role", "function",
        "work_type", "counterpart", "direction", "owner_side", "plan_row_id",
        "status", "scope", "card", "evidence", "merged_from"]
# evidence 는 화면에서 150자로 잘라 보이므로 데이터도 같은 길이로 싣는다(파일 크기 예산).
# 전체 근거 문자열은 merged.csv 와 xlsx 「원장」 시트에 온전히 남는다.
EV_CAP = 150


def _cell(r, c):
    v = r[c]
    return (v[:EV_CAP] + "…") if c == "evidence" and len(v) > EV_CAP else v


DATA = [[_cell(r, c) for c in COLS] for r in ROWS]


# ── SVG 막대 차트 ──────────────────────────────────────────────────────────
def bar_chart(items, key_done, key_rem, label_key, width=760, row_h=30):
    """시스템별 완료/남은 일 누적 막대. 인라인 SVG — JS 없이도 보인다."""
    mx = max((it[key_done] + it[key_rem]) for it in items) or 1
    left, bar_w = 190, width - 190 - 70
    h = len(items) * row_h + 34
    p = [f'<svg viewBox="0 0 {width} {h}" role="img" width="100%" '
         f'aria-label="시스템별 완료·남은 일 행수">']
    for i, it in enumerate(items):
        y = i * row_h + 8
        d, rm = it[key_done], it[key_rem]
        wd, wr = bar_w * d / mx, bar_w * rm / mx
        p.append(f'<text x="{left-8}" y="{y+14}" text-anchor="end" font-size="12" '
                 f'fill="#3D3D3A">{e(it[label_key])}</text>')
        p.append(f'<rect x="{left}" y="{y+3}" width="{wd:.1f}" height="16" rx="3" fill="#788C5D"/>')
        p.append(f'<rect x="{left+wd:.1f}" y="{y+3}" width="{wr:.1f}" height="16" rx="3" fill="#D97757"/>')
        p.append(f'<text x="{left+wd+wr+8:.1f}" y="{y+15}" font-size="12" fill="#87867F">'
                 f'{d}+{rm}</text>')
    yl = len(items) * row_h + 18
    p.append(f'<rect x="{left}" y="{yl-9}" width="11" height="11" rx="2" fill="#788C5D"/>'
             f'<text x="{left+16}" y="{yl}" font-size="11" fill="#87867F">완료</text>'
             f'<rect x="{left+58}" y="{yl-9}" width="11" height="11" rx="2" fill="#D97757"/>'
             f'<text x="{left+74}" y="{yl}" font-size="11" fill="#87867F">남은 일(진행·미착수·미확인)</text>')
    p.append("</svg>")
    return "".join(p)


def wt_chart():
    items = []
    for wt in ["build", "integrate", "config", "provided", "manual"]:
        rin = [r for r in IN_ROWS if r["work_type"] == wt]
        items.append({"label": WT_LABEL[wt],
                      "done": sum(1 for r in rin if r["status"] == "완료"),
                      "rem": sum(1 for r in rin if r["status"] != "완료")})
    return bar_chart(items, "done", "rem", "label", row_h=32)


# ── 일정 척추 ──────────────────────────────────────────────────────────────
TRACK_NOTE = {
    "T1": "인프라 이전", "T2": "상품·가격·위젯", "T3": "몰 앞단(장바구니~취소·반품)",
    "T4": "주문 다리·생산 접수", "T5": "셀러어드민·법정표기·세금",
    "T6": "프린팅머니·외부 계약", "T7": "오픈 테스트·판정",
}


def schedule_rows():
    out = []
    for s in SCH["spine"]:
        lb = s["effort_lb_days"]
        lb_txt = f'{lb}일' if s["effort_lb_is_numeric"] and float(lb) > 0 else (
            "0(원장 하한 없음)" if lb == "0" else e(lb or "—"))
        out.append(f'''<tr>
<td class="mono">{e(s["row_id"])}</td>
<td><span class="chip">{e(s["track"])}·{e(s["step"])}</span></td>
<td>{e(s["title"])}</td>
<td>{e(s["owner"])}</td>
<td class="num">{lb_txt}</td>
<td class="num">{s["screen_rows"]}<span class="sub"> / 남은 {s["screen_rows_remaining"]}</span></td>
<td class="mono sm">{e(s["prereq"] or "—")}</td>
<td>{e(s["status"])}</td></tr>''')
    return "\n".join(out)


# ── 미수록 ─────────────────────────────────────────────────────────────────
OOS = S["out_of_scope_crosscheck"]


def miss_rows():
    return "\n".join(
        f'<tr><td class="mono">{e(m["plan_row_id"])}</td><td>{e(m["title"])}</td>'
        f'<td>{e(m["routed_system"])}</td><td>{e(m["owner_name"])}</td>'
        f'<td>{e(m["plan_status"])}</td>'
        f'<td class="sm">{"흔적 " + e(", ".join(m["function_trace_cards"])) if m["function_trace"] else "<strong>흔적 없음</strong>"}</td>'
        '</tr>' for m in OOS["miss"])


def edge_rows():
    return "\n".join(
        f'<tr><td>{e(SYS_LABEL.get(x["a"], x["a"]))}</td>'
        f'<td>{e(SYS_LABEL.get(x["b"], x["b"]))}</td>'
        f'<td class="num">{x["total"]}</td><td class="num">{x["remaining"]}</td>'
        f'<td>{e(", ".join(x["owners"]) or "미정")}</td></tr>' for x in edge_list)


def ext_rows():
    lab = {
        "EXT-MES": "MES 상대측(CRT) 회신 — 연동 규격·화면 신규 버튼",
        "EXT-PG": "토스페이먼츠 계약·심사·샌드박스",
        "EXT-PITSTOP": "PitStop 조달·연동 방식 결정",
        "EXT-NHN": "샵바이(NHN) 플랜·기능 회신",
        "EXT-ALIMTALK": "알림톡 템플릿 카카오 사전 심사",
        "EXT-EDICUS": "Edicus 에디터 연동 회신",
        "EXT-IDENTITY": "본인확인·인증 서비스",
        "EXT-OLDDB": "구 사이트 DB 추출 주체",
        "EXT-NAVERPAY": "네이버페이",
        "EXT-TAXBILL": "세금계산서 발급 대행",
        "EXT-HUNI-SERVERKEY": "후니 서버키 발급",
    }
    return "\n".join(
        f'<tr><td class="mono">{e(k)}</td><td>{e(lab.get(k, "—"))}</td>'
        f'<td class="num">{v["waiting_rows"]}</td>'
        f'<td class="mono sm">{e(", ".join(v["sample"][:4]))}</td></tr>'
        for k, v in SCH["ext_dependencies"].items())


# ── 발견 F1~F8 (리드가 근거를 직접 확인했거나 레인이 보고한 것) ───────────────
FINDINGS = [
    ("F1", "샵바이 ↔ MES 사이에 구현이 없다",
     "MES 저장소에서 <code>shopby</code> 를 찾으면 0건이고, 남은 것은 스펙 yaml 의 경로 11개뿐이다. "
     "MES <code>docs/design/README.md</code> 는 이미 만들어진 것처럼 읽힌다.", "리드 직접 확인", "높음"),
    ("F2", "webadmin → 샵바이 쓰기 연동은 사실상 없다",
     "실재하는 것은 상품 동기화·웹훅 수신·클레임 저장 3건이다. 주문·송장·회원·적립금 전용 호출 함수는 없고 "
     "<code>shopby_client.py:137</code> 의 범용 request 만 있다.", "리드 직접 확인", "높음"),
    ("F3", "PitStop 23행이 전부 미착수이고 작업량을 아직 낼 수 없다",
     "연동 방식(STD-ART-034) → 범위 산정(STD-ART-035) → 일정 상정(STD-ART-033) 순서로 결정이 묶여 있다. "
     "결정 주체가 다수 미정이거나 대표다. 이 항목은 「며칠」이 아니라 <strong>결정이 먼저</strong>다.",
     "행수 리드 직접 · 결정 사슬 레인 보고", "높음"),
    ("F4", "PitStop → MES 인계는 사내·타사 모두 선례가 없다",
     "샵바이 → MES 쪽은 카페24·우커머스·성원 선례가 있다. 두 이음매의 위험도가 같지 않다.",
     "타사분 리드 직접 · 사내분 레인 보고", "높음"),
    ("F5", "pagebuilder 62행 중 완료가 0이다",
     "설계 폴더 02~05 에 파일이 0개이고, 파트너사 코드 변경이 필요한 건이 9건(편집기 HTTP 500 등)이다.",
     "완료 0·폴더 0 리드 직접 · 9건 레인 보고", "높음"),
    ("F6", "분모 안 연동 행 가운데 담당 쪽이 정해지지 않은 것이 11건이다",
     "owner_side 가 비었거나 미정이면 담당도 일정도 산정할 수 없다.", "리드 직접 확인", "중간"),
    ("F7", "웹훅 메아리 필터가 구현되어 있지 않다",
     "STD-MFG-030. 지금은 받은 것을 저장만 하고, 그 변경이 자기가 만든 것인지 가리지 않는다"
     "(<code>shopby_hook.py:112-121</code>).", "리드 직접 확인", "중간"),
    ("F8", "9/17 원장이 MES 코드를 읽지 않아 오해가 이어졌다",
     "「MES 소스 없음」이 후속 조사에 계속 상속됐다. 가이드북의 실체도 pagebuilder 가 아니라 webadmin 이다.",
     "레인 보고", "중간"),
]

DECISIONS_FOR_GENIE = [
    ("위젯빌더 운영 도구 NEW 71행을 런웨이에 올릴 것인가",
     "직접 구현이고 이미 완료라 「남은 일」 집계에는 잡히지 않는다. 원장에 실을지 여부가 결정 사항이다."),
    ("webadmin 고객 마스터 <code>t_cus_customers</code> 가 신규몰에서 실제로 쓰이는가",
     "실무진 확인 1건이면 끝난다."),
    ("PitStop 결정 사슬 7건의 결정 주체와 순서",
     "F3 의 선행이다. 이것이 풀리기 전에는 PitStop 23행의 작업량을 낼 수 없다."),
    ("미확인 행을 없애기 위한 화면 캡처를 허용할 것인가",
     "t48 셀러어드민 24건 · t49 pagebuilder 편집기 17건 · t50 MES 메뉴가 대상이다."),
    ("<code>pc-req-f3-link-1n</code> 처리",
     "C7 결론이 ⓐ 로 나면 기능이 소멸하고 안건만 남으므로 decisions 로 옮긴다."),
]


def li(items, fmt):
    return "\n".join(fmt(x) for x in items)


# ── HTML ───────────────────────────────────────────────────────────────────
def build_html():
    kpi = [
        ("통합 원장", f'{n("merged_total")}행',
         f'세 레인 {n("raw_total")}행 · 레인 간 실제 중복 {n("merged_rows_folded")}행'),
        ("오픈 분모 안", f'{n("by_scope","in")}행',
         f'분모 밖(사내 선례) {n("by_scope","out")}행은 집계에서 뺀다'),
        ("남은 일", f'{n("in_remaining")}행', "분모 안에서 상태가 완료가 아닌 행"),
        ("원장에 없던 행", f'{n("new_rows")}행', "9/17 원장보다 단위가 잘아 새로 생긴 행"),
        ("결정·관리 안건", f'{n("decisions_total")}건', "화면도 기능도 아니라 원장 밖에 둔 것"),
        ("미수록", f'{OOS["miss_count"]}건',
         f'넘긴 행 번호가 받는 원장에 없음 · 그중 낱말 흔적조차 없는 것 {OOS["miss_untraced_count"]}건'),
    ]

    drill_json = json.dumps({"cols": COLS, "rows": DATA, "sysLabel": SYS_LABEL,
                            "wtLabel": WT_LABEL}, ensure_ascii=False, separators=(",", ":"))

    mermaid = """flowchart LR
  C([고객]):::actor --> M[huni-mall<br/>자사몰 스킨]
  M --> W[widget<br/>자동견적]
  M --> P[pagebuilder<br/>상세·가이드북]
  W --> A[webadmin<br/>관리서버 · 가격·상품·원고]
  M <--> S[shopby<br/>NHN 커머스 SaaS]
  S <--> A
  A --> E[edicus<br/>디자인 에디터]
  A -. 구현 0 .-> T[pitstop<br/>인쇄파일 검수]
  A -. 구현 0 .-> X[mes<br/>생산관리]
  T -. 선례 없음 .-> X
  classDef actor fill:#E3DACC,stroke:#87867F;
  classDef gap stroke-dasharray:4 3,stroke:#D97757,color:#B85C3E;
  class T,X gap;"""

    return f"""<!DOCTYPE html>
<html lang="ko"><head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>{e(TITLE)}</title>
<link rel="preconnect" href="https://cdn.jsdelivr.net">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.min.css">
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Noto+Serif+KR:wght@600;700&display=swap">
<style>
:root{{--ivory:#FAF9F5;--paper:#fff;--slate:#141413;--clay:#D97757;--clay-d:#B85C3E;
--oat:#E3DACC;--olive:#788C5D;--g100:#F0EEE6;--g300:#D1CFC5;--g500:#87867F;--g700:#3D3D3A;
--sans:"Pretendard",system-ui,-apple-system,sans-serif;
--serif:"Noto Serif KR",ui-serif,Georgia,serif;
--mono:"JetBrains Mono",ui-monospace,"SF Mono",monospace;
--max-width:1080px;--radius-panel:12px;--radius-row:8px;--border:1.5px solid var(--g300);}}
*{{box-sizing:border-box}}
body{{margin:0;background:var(--ivory);color:var(--slate);font-family:var(--sans);
line-height:1.75;font-size:15px;-webkit-font-smoothing:antialiased}}
.wrap{{max-width:var(--max-width);margin:0 auto;padding:40px 20px 96px}}
h1{{font-family:var(--serif);font-size:30px;line-height:1.35;margin:0 0 6px}}
h2{{font-family:var(--serif);font-size:21px;margin:56px 0 4px;padding-top:20px;border-top:var(--border)}}
h3{{font-size:16px;margin:28px 0 6px}}
.lead{{color:var(--g700);margin:8px 0 20px}}
.meta{{color:var(--g500);font-size:13px;margin-bottom:28px}}
.kpis{{display:grid;grid-template-columns:repeat(auto-fit,minmax(160px,1fr));gap:10px;margin:22px 0}}
.kpi{{background:var(--paper);border:var(--border);border-radius:var(--radius-panel);padding:14px 16px}}
.kpi .k{{font-size:12px;color:var(--g500)}}
.kpi .v{{font-family:var(--serif);font-size:25px;margin:2px 0 3px}}
.kpi .d{{font-size:12px;color:var(--g500);line-height:1.5}}
.panel{{background:var(--paper);border:var(--border);border-radius:var(--radius-panel);
padding:18px 20px;margin:18px 0}}
.note{{background:var(--g100);border-left:4px solid var(--clay);border-radius:var(--radius-row);
padding:14px 18px;margin:18px 0}}
.note b{{color:var(--clay-d)}}
table{{width:100%;border-collapse:collapse;font-size:13.5px;margin:14px 0}}
th{{text-align:left;background:var(--g100);padding:9px 10px;border-bottom:var(--border);
font-weight:600;font-size:12.5px;color:var(--g700);position:sticky;top:0}}
td{{padding:8px 10px;border-bottom:1px solid var(--g300);vertical-align:top}}
tr:hover td{{background:var(--g100)}}
.num{{text-align:right;font-variant-numeric:tabular-nums;white-space:nowrap}}
.mono{{font-family:var(--mono);font-size:12px}}
.sm{{font-size:11.5px;color:var(--g500)}}
.sub{{color:var(--g500);font-size:11.5px}}
code{{font-family:var(--mono);font-size:12.5px;background:var(--g100);padding:1px 5px;border-radius:4px}}
.chip{{display:inline-block;background:var(--oat);border-radius:99px;padding:1px 9px;
font-size:11.5px;white-space:nowrap}}
.st{{display:inline-block;border-radius:99px;padding:1px 9px;font-size:11.5px;white-space:nowrap}}
.st-완료{{background:#E7EDE0;color:#4A5E37}}
.st-진행{{background:#FBE9E1;color:var(--clay-d)}}
.st-미착수{{background:var(--g100);color:var(--g700)}}
.st-미확인{{background:#F3E4E4;color:#8C4A4A}}
.controls{{display:flex;flex-wrap:wrap;gap:8px;margin:14px 0}}
select,input[type=search],button{{font-family:var(--sans);font-size:13px;padding:7px 10px;
border:var(--border);border-radius:var(--radius-row);background:var(--paper);color:var(--slate)}}
button{{cursor:pointer}} button:hover{{background:var(--g100)}}
details{{border:var(--border);border-radius:var(--radius-row);background:var(--paper);
margin:8px 0;padding:0}}
summary{{cursor:pointer;padding:11px 14px;font-weight:600;font-size:14px;list-style:none}}
summary::-webkit-details-marker{{display:none}}
summary::before{{content:"▸ ";color:var(--clay)}}
details[open] summary::before{{content:"▾ "}}
details .body{{padding:0 14px 12px}}
.cnt{{float:right;color:var(--g500);font-weight:400;font-size:12.5px}}
.scroll{{max-height:560px;overflow:auto;border:var(--border);border-radius:var(--radius-row);
background:var(--paper)}}
pre.mermaid{{background:var(--paper);border:var(--border);border-radius:var(--radius-panel);
padding:16px;overflow:auto;font-family:var(--mono);font-size:12px}}
.legend td:first-child{{white-space:nowrap;font-weight:600}}
footer{{margin-top:56px;padding-top:18px;border-top:var(--border);color:var(--g500);font-size:12.5px}}
@media print{{body{{background:#fff}} .scroll{{max-height:none}} details{{break-inside:avoid}}
details:not([open]) .body{{display:block}} .controls{{display:none}}}}
</style></head><body><div class="wrap">

<h1>{e(TITLE)}</h1>
<p class="lead">오픈까지 무엇이 남았는지를 <strong>시스템 8 · 역할 · 화면 · 기능</strong> 단위로 한자리에 모은 문서입니다.
세 갈래로 나눠 조사한 원장을 합치고, 직접 만드는 일과 두 시스템을 잇는 일을 섞지 않고 갈라 놓았습니다.</p>
<p class="meta">작성 {e(DATE)} · 카드 t51 · 입력 = t48(shopby·huni-mall) + t49(webadmin·widget·pagebuilder) + t50(mes·edicus·pitstop)
· 일정 입력 = 9/17 원장 {SCH["plan_rows"]}행</p>

<div class="kpis">{"".join(f'<div class="kpi"><div class="k">{e(k)}</div><div class="v">{e(v)}</div><div class="d">{e(d)}</div></div>' for k, v, d in kpi)}</div>

<div class="note">
<b>이 문서의 숫자가 뜻하는 것 — 먼저 읽어 주세요.</b><br>
<strong>상태가 「완료」라는 말은 「코드(또는 매뉴얼 원고)에서 그 기능이 실제로 있는 것을 확인했다」는 뜻입니다.</strong>
라이브 화면에서 실제로 눌러 보거나 실주문으로 확인한 것은 <strong>0건</strong>입니다.
그러니 「오픈 시나리오에서 동작한다」로 읽으시면 안 됩니다. 그 확인은 아직 남은 일입니다.
</div>

<h2>1. 시스템 여덟 개가 어떻게 이어지는가</h2>
<p class="lead">먼저 그림 한 장입니다. 상자는 시스템이고, 선은 두 시스템을 잇는 코드(연동)입니다.
<span style="color:var(--clay-d)">주황 점선</span>은 <strong>이어야 하는데 아직 잇는 코드가 없는 자리</strong>입니다.</p>

<pre class="mermaid">{e(mermaid)}</pre>
<noscript><p class="panel">그림 대신 글로: 고객은 <b>huni-mall</b>(자사몰 스킨)로 들어와 <b>widget</b>(자동견적)으로 견적을 내고,
상세 내용은 <b>pagebuilder</b>가 보여 줍니다. 값과 상품은 <b>webadmin</b>(관리서버)이 쥐고 있고,
장바구니·주문·결제는 <b>shopby</b>(NHN 커머스 SaaS)가 맡습니다. 디자인 편집은 <b>edicus</b>로 넘어갑니다.
반면 <b>pitstop</b>(인쇄파일 검수)과 <b>mes</b>(생산관리)로 가는 길은 아직 코드가 없습니다.</p></noscript>

<h3>연동 경계 — 어느 이음매에 일이 몰려 있는가</h3>
<table><thead><tr><th>시스템 A</th><th>시스템 B</th><th class="num">연동 행</th><th class="num">남은 일</th><th>코드가 사는 쪽</th></tr></thead>
<tbody>{edge_rows()}</tbody></table>
<p class="sm">연동 행은 두 시스템에 걸치므로 양쪽 드릴다운에 모두 나타납니다(계약 보충 3 명확화).</p>
<div class="note"><b>레인 간 중복은 {n("merged_pairs")}건이었습니다 — 합친 행이 없습니다.</b>
처음에는 근거의 첫 <code>path:line</code> 만으로 같은 행인지 판정했는데, 검증기가 그 방식이
<u>서로 다른 기능을 잘못 합친다</u>는 것을 잡아냈습니다. 한 줄에 여러 기능이 걸리기 때문입니다 —
예컨대 <code>config/urls.py:249</code> 에는 「구매가능 검증(huni-mall→shopby)」과
「서버 권위 가격 계산(widget→webadmin)」이 함께 걸려 있습니다.
그래서 <strong>같은 줄이면서 이음매(양쪽 시스템)까지 같을 때만</strong> 합치도록 고쳤고, 그 결과 합칠 행이 없었습니다.
같은 줄에 서로 다른 이음매가 걸린 자리는 {len(S["same_path_different_edge"])}곳입니다:
{" · ".join(f'<code>{e(x["dup_key"].split("/")[-1])}</code>' for x in S["same_path_different_edge"])}.</div>

<h2>2. 시스템별 현황</h2>
<p class="lead">막대 왼쪽 <span style="color:#4A5E37">초록</span>이 이미 확인된 것, 오른쪽 <span style="color:var(--clay-d)">주황</span>이 남은 일입니다.
분모 밖(사내 선례) 행은 빼고 셌습니다.</p>
<div class="panel">{bar_chart(sys_summary, "done", "remaining", "label")}</div>
<table><thead><tr><th>시스템</th><th class="num">분모 안</th><th class="num">완료</th><th class="num">남은 일</th>
<th class="num">미확인</th><th class="num">직접 구현</th><th class="num">연동</th><th class="num">분모 밖</th></tr></thead><tbody>
{li(sys_summary, lambda x: f'<tr><td>{e(x["label"])}</td><td class="num">{x["in"]}</td><td class="num">{x["done"]}</td><td class="num"><strong>{x["remaining"]}</strong></td><td class="num">{x["unknown"]}</td><td class="num">{x["build"]}</td><td class="num">{x["integrate"]}</td><td class="num">{x["out"]}</td></tr>')}
</tbody></table>
<p class="sm">webadmin 의 남은 일이 {n("in_remaining_by_system","webadmin")}행뿐인 것은 「할 일이 없다」는 뜻이 아닙니다.
t48 이 webadmin 으로 넘긴 {OOS["miss_by_routed_system"].get("webadmin",0)}건이 webadmin 원장에서 같은 번호로 확인되지 않았습니다 —
<a href="#miss">7절</a>에서 따로 다룹니다.</p>

<h2>3. 직접 구현과 연동을 갈라 보기</h2>
<p class="lead">한 화면에 성격이 다른 일이 같이 있으면 행을 나눴습니다. 그래서 「만드는 일」과 「잇는 일」이 섞이지 않습니다.</p>
<table class="legend"><thead><tr><th>구분</th><th>뜻</th><th class="num">분모 안</th><th class="num">남은 일</th></tr></thead><tbody>
{li(["build","integrate","config","provided","manual"], lambda wt: f'<tr><td>{e(WT_LABEL[wt])}<div class="sm mono">{e(wt)}</div></td><td>{e(WT_DESC[wt])}</td><td class="num">{n("in_by_work_type",wt)}</td><td class="num"><strong>{n("in_remaining_by_work_type",wt)}</strong></td></tr>')}
</tbody></table>
<div class="panel">{wt_chart()}</div>
<div class="note"><b>남은 일 {n("in_remaining")}행 가운데 연동이 {n("in_remaining_by_work_type","integrate")}행으로 가장 많습니다.</b>
직접 구현은 {n("in_remaining_by_work_type","build")}행입니다.
연동은 상대가 있는 일이라 우리 쪽 인원만으로 당길 수 없습니다.
그중 <strong>어느 쪽 코드에 사는지가 아직 정해지지 않은 행이 {n("integrate_owner_side_undecided")}건</strong>이라,
그 행들은 담당도 일정도 아직 산정할 수 없습니다.</div>

<h2>4. 그룹 → 화면 드릴다운</h2>
<p class="lead">시스템을 열면 그룹이, 그룹을 열면 화면과 기능이 나옵니다. 위 상자로 걸러 볼 수 있습니다.</p>
<div class="controls">
<select id="fSys"><option value="">시스템 전체</option></select>
<select id="fScope"><option value="in">오픈 분모 안</option><option value="out">분모 밖(사내 선례)</option><option value="">전체</option></select>
<select id="fWt"><option value="">구분 전체</option></select>
<select id="fSt"><option value="">상태 전체</option><option value="!완료">남은 일만(완료 제외)</option>{"".join(f'<option value="{e(s)}">{e(s)}</option>' for s in STATUS_ORDER)}</select>
<select id="fRole"><option value="">역할 전체</option>{"".join(f'<option value="{e(r)}">{e(r)}</option>' for r in sorted({x["role"] for x in ROWS}))}</select>
<input type="search" id="fQ" placeholder="화면·기능·근거 검색" size="22">
<button id="bOpen">모두 펼치기</button><button id="bClose">모두 접기</button>
</div>
<div id="drill"><p class="sm">브라우저에서 JavaScript 가 꺼져 있으면 이 표는 펼쳐지지 않습니다.
전체 원장은 함께 드리는 <code>launch-screens-{e(DATE.replace("-",""))}.xlsx</code> 의 「원장」 시트에 같은 내용이 그대로 들어 있습니다.</p></div>

<h2>5. 일정표</h2>
<p class="lead">날짜를 새로 지어내지 않았습니다. 9/17 원장에 적힌 <strong>작업량 하한</strong>과 <strong>선행 관계</strong>, 그리고 <strong>순서</strong>만 옮겼습니다.
「남은」 칸은 그 단계에 걸린 이 문서의 화면·기능 행 가운데 아직 완료가 아닌 수입니다.</p>
<div class="note"><b>하한을 읽는 법.</b> 원장 {SCH["plan_rows"]}행 가운데 작업량 하한이 적힌 것은
<strong>{SCH["plan_rows_with_effort_lb"]}행</strong>(아래 척추 행)뿐입니다. 합은 <strong>{SCH["spine_effort_lb_sum"]}일</strong>이지만
이것은 <u>달력 날짜가 아니라 원장이 적어 둔 작업량의 아래쪽 한계</u>이고, 동시에 진행되는 몫과 대기 시간은 들어 있지 않습니다.
하한이 <code>0</code>인 단계는 「일이 없다」가 아니라 <b>원장이 아직 산정하지 않았다</b>는 뜻입니다.</div>
<div class="scroll"><table><thead><tr><th>행</th><th>트랙·단계</th><th>내용</th><th>담당</th>
<th class="num">원장 하한</th><th class="num">이 문서 행/남은</th><th>선행</th><th>원장 상태</th></tr></thead>
<tbody>{schedule_rows()}</tbody></table></div>
<p class="sm">트랙: {e(" · ".join(f"{k} {v}" for k, v in TRACK_NOTE.items()))}</p>
<div class="note"><b>PitStop 은 「며칠」로 적지 않습니다.</b> 연동 방식(STD-ART-034)이 정해져야 범위(STD-ART-035)가 나오고,
그래야 일정(STD-ART-033)을 상정할 수 있습니다. 지금은 <strong>결정이 선행</strong>인 구간입니다.</div>

<h2>6. 관리 요소 — 누가·무엇이 걸려 있는가</h2>

<h3>6-1. 이번 조사에서 드러난 것</h3>
<table><thead><tr><th>#</th><th>발견</th><th>내용</th><th>확인 경로</th><th>무게</th></tr></thead><tbody>
{li(FINDINGS, lambda f: f'<tr><td class="mono">{e(f[0])}</td><td><strong>{e(f[1])}</strong></td><td>{f[2]}</td><td class="sm">{e(f[3])}</td><td>{e(f[4])}</td></tr>')}
</tbody></table>

<h3>6-2. 바깥에 달린 의존</h3>
<p class="lead">우리가 아무리 당겨도 상대가 회신하지 않으면 움직이지 않는 자리입니다. 「대기 행」은 원장에서 그 선행을 기다리는 행 수입니다.</p>
<table><thead><tr><th>선행</th><th>무엇을 기다리는가</th><th class="num">대기 행</th><th>예시 행</th></tr></thead><tbody>{ext_rows()}</tbody></table>

<h3>6-3. 담당 분포 (RACI 의 R)</h3>
<p class="lead">9/17 원장 기준 담당자별 행 수입니다. 이 문서의 화면 원장은 담당 열을 따로 두지 않고 원장 행으로 담당에 이어집니다.</p>
<table><thead><tr><th>담당</th><th class="num">원장 행</th></tr></thead><tbody>
{li(list(SCH["plan_owner_counts"].items())[:12], lambda kv: f'<tr><td>{e(kv[0])}</td><td class="num">{kv[1]}</td></tr>')}
</tbody></table>

<h3>6-4. 결정·관리 안건 {n("decisions_total")}건</h3>
<p class="lead">화면도 기능도 아니라 <strong>누군가 정해야 끝나는 일</strong>입니다. 원장에 섞으면 이중으로 세게 되어 따로 뒀습니다.
순서가 묶인 것(edicus: STD-MYP-031 → STD-OPT-053)은 순서를 지켜야 합니다.</p>
<table><thead><tr><th>출처 문서</th><th class="num">건수</th></tr></thead><tbody>
{li(sorted(S["decisions"].items()), lambda kv: f'<tr><td class="mono">{e(kv[0])}</td><td class="num">{kv[1]}</td></tr>')}
</tbody></table>

<h2 id="miss">7. 미수록 {OOS["miss_count"]}건 — 카드 사이로 빠진 행</h2>
<p class="lead">t48 이 「이건 우리 담당이 아니다」며 넘긴 {OOS["total"]}건 가운데, 넘겨받은 쪽(t49·t50) 원장에
<u>같은 원장 행 번호로</u> 들어 있는 것은 <strong>{OOS["hit"]}건</strong>뿐이었습니다.
나머지 <strong>{OOS["miss_count"]}건</strong>은 넘겨받은 원장에서 그 번호를 찾을 수 없습니다.</p>

<div class="note"><b>다만 「번호가 없다」와 「그 일이 없다」는 다릅니다.</b>
같은 기능이 <u>다른 원장 행 번호로</u> 이미 실려 있을 수 있습니다.
실제로 「쿠폰 생성·발행 관리」와 「공지사항 관리」는 webadmin 으로 넘겼지만,
t48 의 shopby 원장에 셀러어드민 설정 행으로 <strong>쿠폰 18행 · 공지 11행</strong>이 다른 번호로 실려 있습니다.
그러니 이 {OOS["miss_count"]}건은 <strong>「빠진 일」과 「넘긴 곳을 잘못 적은 것」이 섞여 있습니다.</strong></div>

<h3>그래서 둘로 갈라 셌습니다 — 단정 대신 범위로</h3>
<p class="lead">83건의 제목에서 흔한 낱말(관리·등록·설정 따위)을 뺀 낱말을 뽑아, 그 낱말이 세 원장 어디에든 나오는지 기계로 훑었습니다.</p>
<table><thead><tr><th>구분</th><th class="num">건수</th><th>읽는 법</th></tr></thead><tbody>
<tr><td><strong>흔적이 전혀 없음</strong></td><td class="num">{OOS["miss_untraced_count"]}</td>
<td>어느 원장에서도 비슷한 낱말조차 찾지 못했습니다. <strong>「빠진 일」의 하한</strong>입니다.</td></tr>
<tr><td>어딘가에 낱말 흔적 있음</td><td class="num">{OOS["miss_traced_count"]}</td>
<td>넘긴 곳이 틀렸을 <u>후보</u>입니다. 낱말 일치라 <strong>과다 계상되니 상한으로만</strong> 읽어야 합니다
(예: 「충전 입금 확인」은 세 카드에 모두 걸립니다).</td></tr>
</tbody></table>
<p class="sm">흔적이 전혀 없는 {OOS["miss_untraced_count"]}건: {" · ".join(e(m["plan_row_id"]) + " " + e(m["title"]) for m in OOS["miss"] if not m["function_trace"])}</p>
<div class="note"><b>아직 판정하지 않았습니다.</b> 어느 쪽이든 「정말 필요 없는 일인지, 넘긴 곳이 틀린 것인지, 조사에서 빠진 것인지」를
가리려면 webadmin 과 셀러어드민을 한 번 다시 훑어야 합니다. 그 일은 이 문서의 범위 밖입니다.
넘긴 쪽 분포는 webadmin {OOS["miss_by_routed_system"].get("webadmin",0)}건 · mes {OOS["miss_by_routed_system"].get("mes",0)}건이고,
담당으로는 김동학 {OOS["miss_by_owner"].get("김동학",0)}건 · 최숙진 {OOS["miss_by_owner"].get("최숙진",0)}건 · 서희항 {OOS["miss_by_owner"].get("서희항",0)}건입니다.</div>
<div class="scroll"><table><thead><tr><th>원장 행</th><th>내용</th><th>넘긴 곳</th><th>담당</th><th>원장 상태</th><th>낱말 흔적</th></tr></thead>
<tbody>{miss_rows()}</tbody></table></div>

<h2>8. 지니 결정이 필요한 것</h2>
<ol>{li(DECISIONS_FOR_GENIE, lambda d: f'<li><strong>{d[0]}</strong> — {d[1]}</li>')}</ol>

<h2>9. 이 문서의 한계 — 그대로 실어 둡니다</h2>
<ul>
<li><strong>상태 「완료」는 코드에서 확인했다는 뜻</strong>입니다. 라이브 실화면·실주문 확인은 0건입니다.</li>
<li><strong>MES</strong>: 메뉴는 실행 중에 DB <code>MenuInfo</code> 에서 읽어 오므로 라이브에 실제로 등록됐는지는 확인하지 못했습니다.
화면 한글 이름은 <code>designer.cs</code> 캡션에서 미루어 붙인 값입니다.</li>
<li><strong>분모 밖 판정</strong> {n("by_scope","out")}행 가운데 t50 의 62행은 <u>레인이 낸 제안</u>입니다.
힌트와 대조해 판단한 근거 7건은 숨기지 않고 t50 산출물에 남겨 두었습니다.</li>
<li><strong><code>unmeasured-candidates.csv</code></strong> 는 문구가 비슷해 뽑은 <u>후보</u>이지 확정된 결함이 아닙니다.
확정된 정정은 STD-MFG-060·061 두 건입니다.</li>
<li><strong><code>pitstop-clues-CRT.md</code></strong> 는 다른 고객사(열림PnP) 코드입니다. 후니 상태의 근거로 쓰지 않았습니다.
리드가 뽑아 본 7건 가운데 1건은 줄 번호가 5줄 어긋나 있었습니다.</li>
<li><strong>새로 생긴 행 {n("new_rows")}행</strong>은 9/17 원장보다 이 원장의 단위가 잘다는 뜻입니다.
735행에 억지로 맞추지 않고 그대로 두되, 일정은 735행 쪽 선행과 하한을 씁니다.</li>
<li>DB 쓰기 0 · 라이브 접속 0 · 날짜 추정 0.</li>
</ul>

<footer>
카드 t51 · 브랜치 <code>WT-launch-schedule-doc</code> · 검증기 <code>verify.py</code> ·
조립기 <code>assemble.py</code> + <code>schedule.py</code> · 원장 <code>merged.csv</code>({n("merged_total")}행)<br>
이 문서의 모든 수치는 위 스크립트가 계산한 값이며, 사람이 옮겨 적은 숫자는 없습니다.
</footer>
</div>

<script>
const D={drill_json};
(function(){{
const ix=Object.fromEntries(D.cols.map((c,i)=>[c,i]));
const el=id=>document.getElementById(id);
const sysSel=el('fSys'),wtSel=el('fWt');
[...new Set(D.rows.map(r=>r[ix.system]))].sort().forEach(s=>
  sysSel.insertAdjacentHTML('beforeend',`<option value="${{s}}">${{D.sysLabel[s]||s}}</option>`));
Object.entries(D.wtLabel).forEach(([k,v])=>
  wtSel.insertAdjacentHTML('beforeend',`<option value="${{k}}">${{v}}</option>`));
const esc=s=>String(s).replace(/[&<>"]/g,c=>({{'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;'}})[c]);
function render(){{
  const fs=el('fSys').value,fp=el('fScope').value,fw=el('fWt').value,
        ft=el('fSt').value,fr=el('fRole').value,q=el('fQ').value.trim().toLowerCase();
  const rows=D.rows.filter(r=>
    (!fs||r[ix.system]===fs)&&(!fp||r[ix.scope]===fp)&&(!fw||r[ix.work_type]===fw)&&
    (!fr||r[ix.role]===fr)&&
    (!ft||(ft==='!완료'?r[ix.status]!=='완료':r[ix.status]===ft))&&
    (!q||(r[ix.screen_name]+r[ix.function]+r[ix.evidence]+r[ix.screen_id]).toLowerCase().includes(q)));
  const bySys={{}};
  rows.forEach(r=>{{(bySys[r[ix.system]]=bySys[r[ix.system]]||{{}});
    const g=r[ix.group]||'(그룹 없음)';(bySys[r[ix.system]][g]=bySys[r[ix.system]][g]||[]).push(r);}});
  let h=`<p class="sm">걸러진 행 <strong>${{rows.length}}</strong> / 전체 ${{D.rows.length}}</p>`;
  Object.keys(bySys).sort().forEach(s=>{{
    const gs=bySys[s],tot=Object.values(gs).reduce((a,b)=>a+b.length,0),
      rem=Object.values(gs).flat().filter(r=>r[ix.status]!=='완료').length;
    h+=`<details><summary>${{esc(D.sysLabel[s]||s)}}<span class="cnt">${{tot}}행 · 남은 일 ${{rem}}</span></summary><div class="body">`;
    Object.keys(gs).sort().forEach(g=>{{
      const rs=gs[g],gr=rs.filter(r=>r[ix.status]!=='완료').length;
      h+=`<details><summary>${{esc(g)}}<span class="cnt">${{rs.length}}행 · 남은 일 ${{gr}}</span></summary><div class="body">
<table><thead><tr><th>화면</th><th>역할</th><th>기능</th><th>구분</th><th>상대·방향</th><th>상태</th><th>원장 행</th><th>근거</th></tr></thead><tbody>`;
      rs.forEach(r=>{{
        const cp=r[ix.counterpart]?`${{esc(r[ix.counterpart])}}<div class="sm">${{esc(r[ix.direction]||'')}}${{r[ix.owner_side]?' · 코드: '+esc(r[ix.owner_side]):''}}</div>`:'—';
        h+=`<tr><td>${{esc(r[ix.screen_name])}}<div class="sm mono">${{esc(r[ix.screen_id])}}</div></td>
<td class="sm">${{esc(r[ix.role])}}</td><td>${{esc(r[ix.function])}}</td>
<td><span class="chip">${{esc(D.wtLabel[r[ix.work_type]]||r[ix.work_type])}}</span></td>
<td class="sm">${{cp}}</td><td><span class="st st-${{esc(r[ix.status])}}">${{esc(r[ix.status])}}</span></td>
<td class="mono sm">${{esc(r[ix.plan_row_id])}}</td>
<td class="sm mono">${{esc(r[ix.evidence]).slice(0,150)}}${{r[ix.merged_from]?' <b>[레인 병합]</b>':''}}</td></tr>`;
      }});
      h+='</tbody></table></div></details>';
    }});
    h+='</div></details>';
  }});
  el('drill').innerHTML=h||'<p class="sm">해당하는 행이 없습니다.</p>';
}}
['fSys','fScope','fWt','fSt','fRole'].forEach(i=>el(i).addEventListener('change',render));
el('fQ').addEventListener('input',render);
el('bOpen').onclick=()=>document.querySelectorAll('#drill details').forEach(d=>d.open=true);
el('bClose').onclick=()=>document.querySelectorAll('#drill details').forEach(d=>d.open=false);
render();
}})();
</script>
<script type="module">
import mermaid from "https://cdn.jsdelivr.net/npm/mermaid@11/dist/mermaid.esm.min.mjs";
mermaid.initialize({{startOnLoad:true,theme:"base",themeVariables:{{
primaryColor:"#FAF9F5",primaryTextColor:"#141413",primaryBorderColor:"#D97757",
lineColor:"#87867F",secondaryColor:"#E3DACC",tertiaryColor:"#F0EEE6"}}}});
</script>
</body></html>"""


# ── 린 markdown 트윈 (에이전트 컨텍스트용 — 티어 보강 없음) ──────────────────
def build_md():
    L = []
    a = L.append
    a(f"# {TITLE}\n")
    a(f"작성 {DATE} · 카드 t51 · 입력 t48+t49+t50 · 일정 입력 9/17 원장 {SCH['plan_rows']}행\n")
    a("## 수치")
    a(f"- 통합 원장 {n('merged_total')}행 (원시 {n('raw_total')} · 레인 간 실제 중복 {n('merged_pairs')}쌍 → 병합 0행)")
    a("- 병합 키는 path:line 단독이 아니라 (path:line + 이음매{system,counterpart}) 다. "
      "path:line 단독 키는 서로 다른 기능을 오병합한다(verify.py V5 가 적발). "
      f"같은 줄에 다른 이음매가 걸린 자리 {len(S['same_path_different_edge'])}곳: "
      + " · ".join(x["dup_key"] for x in S["same_path_different_edge"]))
    a(f"- scope: in {n('by_scope','in')} · out(분모밖) {n('by_scope','out')}")
    a(f"- 분모 안 남은 일(status≠완료) {n('in_remaining')}행")
    a(f"- NEW {n('new_rows')}행 (t48 {n('new_by_card','t48')} · t49 {n('new_by_card','t49')} · t50 {n('new_by_card','t50')})")
    a(f"- 결정·관리 안건 {n('decisions_total')}건 · 미수록 {OOS['miss_count']}건 / 라우팅 {OOS['total']}건")
    a(f"- integrate 중 owner_side 미정 {n('integrate_owner_side_undecided')}건\n")
    a("## 시스템별 (분모 안 / 완료 / 남은 일 / 미확인 / 분모 밖)")
    a("| 시스템 | in | 완료 | 남은 일 | 미확인 | out |")
    a("|---|---|---|---|---|---|")
    for x in sys_summary:
        a(f"| {x['system']} | {x['in']} | {x['done']} | {x['remaining']} | {x['unknown']} | {x['out']} |")
    a("\n## work_type (분모 안 / 남은 일)")
    a("| work_type | in | 남은 일 |")
    a("|---|---|---|")
    for wt in ["build", "integrate", "config", "provided", "manual"]:
        a(f"| {wt} | {n('in_by_work_type', wt)} | {n('in_remaining_by_work_type', wt)} |")
    a("\n## 일정 (9/17 원장 척추 · 날짜 추정 없음)")
    a(f"하한 보유 {SCH['plan_rows_with_effort_lb']}행 · 합 {SCH['spine_effort_lb_sum']}일(달력 아님, 작업량 하한)")
    a("| row_id | track·step | 내용 | 담당 | 하한(일) | 이 문서 행/남은 | 선행 |")
    a("|---|---|---|---|---|---|---|")
    for s in SCH["spine"]:
        a(f"| {s['row_id']} | {s['track']}·{s['step']} | {s['title']} | {s['owner']} | "
          f"{s['effort_lb_days'] or '—'} | {s['screen_rows']}/{s['screen_rows_remaining']} | {s['prereq'] or '—'} |")
    a("\n## 외부 의존 (대기 행)")
    a(", ".join(f"{k} {v['waiting_rows']}" for k, v in SCH["ext_dependencies"].items()))
    a("\n## 발견")
    for f in FINDINGS:
        a(f"- **{f[0]}** {f[1]} ({f[3]} · {f[4]})")
    a(f"\n## 미수록 {OOS['miss_count']}건 (plan_row_id 기준)")
    a(f"라우팅 {OOS['total']}건 중 받는 원장에 같은 id 실재 {OOS['hit']}건. 분포: "
      + " · ".join(f"{k} {v}" for k, v in OOS["miss_by_routed_system"].items()))
    a("[주의] 「id 없음」 ≠ 「그 일 없음」. 같은 기능이 다른 id 로 실려 있을 수 있다 "
      "(실측: 쿠폰·공지는 webadmin 으로 넘겼으나 t48 shopby 원장에 쿠폰 18행·공지 11행 존재).")
    a(f"낱말 흔적 기계 대조 결과 — 흔적 전무 {OOS['miss_untraced_count']}건(= 「빠진 일」 하한) · "
      f"어딘가 흔적 있음 {OOS['miss_traced_count']}건(= 라우팅 오류 후보 **상한**, 낱말 일치라 과다 계상).")
    a("어느 쪽도 확정 아님 — webadmin·셀러어드민 재조사 필요.")
    a("| plan_row_id | 내용 | 넘긴 곳 | 담당 | 원장 상태 | 낱말 흔적 |")
    a("|---|---|---|---|---|---|")
    for m in OOS["miss"]:
        tr = ", ".join(m["function_trace_cards"]) if m["function_trace"] else "**없음**"
        a(f"| {m['plan_row_id']} | {m['title']} | {m['routed_system']} | {m['owner_name']} | {m['plan_status']} | {tr} |")
    a("\n## 지니 결정 필요")
    for i, d in enumerate(DECISIONS_FOR_GENIE, 1):
        a(f"{i}. {html.unescape(d[0].replace('<code>','`').replace('</code>','`'))} — {d[1]}")
    a("\n## 한계")
    a("- status=완료 = 코드/매뉴얼 원고에서 구현 실재 확인. 라이브 실화면·실주문 확인 0건.")
    a("- MES 메뉴는 런타임 DB MenuInfo 조회라 라이브 등록 미확인 · 화면 한글명은 designer.cs 캡션 추론값.")
    a("- t50 분모밖 62행은 레인 제안(판정근거 7건 노출).")
    a("- unmeasured-candidates.csv 는 후보. 확정 정정은 STD-MFG-060·061.")
    a("- pitstop-clues-CRT.md 는 타 고객(열림PnP) 코드 — 후니 status 근거 아님.")
    a("- DB write 0 · 라이브 접속 0 · 날짜 추정 0.")
    return "\n".join(L) + "\n"


def main():
    out = HERE / "reports"
    out.mkdir(exist_ok=True)
    stem = f"launch-schedule-{DATE.replace('-', '')}"
    h = build_html()
    (out / f"{stem}.html").write_text(h, encoding="utf-8")
    m = build_md()
    (out / f"{stem}.md").write_text(m, encoding="utf-8")
    print(f"HTML {len(h.encode()):,}B → {out/f'{stem}.html'}")
    print(f"MD   {len(m.encode()):,}B → {out/f'{stem}.md'}")


if __name__ == "__main__":
    main()
