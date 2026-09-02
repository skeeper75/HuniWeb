# -*- coding: utf-8 -*-
"""judged-143.md 생성 — 행별 판정 근거표."""
import csv, os, sys, collections
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
from judgments import J

src = os.path.join(HERE, "unified-ledger-v2.csv")
rows = {r["std_id"]: r for r in csv.DictReader(open(src, encoding="utf-8"))}
order = [r["std_id"] for r in csv.DictReader(open(src, encoding="utf-8"))]

cnt = collections.Counter(v[0] for v in J.values())
groups = collections.OrderedDict()
for sid in order:
    if sid not in J:
        continue
    r = rows[sid]
    groups.setdefault((r["대분류"], r["중분류"]), []).append(sid)

out = []
w = out.append
w("# P1 — 미판정 143행 판정 (행별 근거)\n")
w("> 2026-09-02 · lane `run-huniweb` · 카드 `L0/CARDS-P.md §P1` 할 일 1\n")
w("> **권위 순서**: ① `raw/webadmin/docs/order-to-mes-process.md §11` 구현 체크리스트(`[x]`/`[ ]`) → "
  "② 코드 실측(webadmin·huni-skin-shopby 저장소 grep) → ③ `L0/M3/auto-vs-human.md` 분계표(주문프로세스 PDF 색 범례).\n")
w("> **`done` 은 전건 `file:line` 을 달았다.** 「코드 경로 존재」= `done` 이고 **「운영 성공」이 아니다** — 비고에 그대로 적었다.\n")
w("> 판정 못 한 행은 추정하지 않고 **`미판정` + 사유**로 남겼다(9건, §3).\n")

w("\n## 0. 판정 결과\n")
w("| 상태 | 건수 | 뜻 |")
w("|---|---:|---|")
for st, mean in [("done", "코드 경로가 실재한다(운영 성공 아님)"),
                 ("partial", "일부만 되고, 안 되는 부분이 특정된다"),
                 ("todo", "안 했다 — 그릇(테이블·모듈·화면)은 있다"),
                 ("new", "그릇부터 만들어야 한다"),
                 ("미판정", "판정 근거가 없다 — 사유를 적었다")]:
    w(f"| `{st}` | {cnt[st]} | {mean} |")
w(f"| **계** | **{sum(cnt.values())}** | |")

w("\n**대분류별**\n")
bycat = collections.Counter()
for sid in J:
    bycat[(rows[sid]["대분류"], J[sid][0])] += 1
cats = sorted({k[0] for k in bycat})
w("| 대분류 | done | partial | todo | new | 미판정 | 계 |")
w("|---|---:|---:|---:|---:|---:|---:|")
for c in cats:
    cells = [bycat[(c, s)] for s in ["done", "partial", "todo", "new", "미판정"]]
    w(f"| {c} | " + " | ".join(str(x) if x else "·" for x in cells) + f" | {sum(cells)} |")

w("\n---\n\n## 1. 행별 판정\n")
w("`비고 추가` 열은 원장 v2 의 `비고` 칸에 이어붙인 문구다.\n")
for (cat, mid), sids in groups.items():
    w(f"\n### {cat} · {mid} ({len(sids)}건)\n")
    w("| std_id | 기능 | 판정 | 판정 근거 (실측 2026-09-02) | 비고 추가 |")
    w("|---|---|---|---|---|")
    for sid in sids:
        st, ev, extra = J[sid]
        fn = rows[sid]["기능"].replace("|", "／")
        ev = ev.replace("|", "／")
        ex = (extra or "—").replace("|", "／")
        w(f"| `{sid}` | {fn} | **{st}** | {ev} | {ex} |")

w("\n---\n\n## 2. 「수동 대체」로 표기한 것 — 10/6 범위 밖\n")
man = [s for s in J if "수동 대체" in (J[s][2] or "")]
w(f"**{len(man)}건.** `auto-vs-human.md §2` 분계표에서 🧑(관리자·작업자) 경로이고 「지금」 칸이 ✅(현행 운영)인 행이다.\n")
w("신규 시스템으로 옮기지 않아도 **현행 MES·수기 경로가 그 일을 하고 있으므로 오픈을 막지 않는다** → `오픈차단여부 = 오픈 무관`.\n")
w("판정 상태는 신규 시스템 기준이라 `todo` 로 남는다 — 「안 했다」와 「일이 안 돌아간다」는 다르다.\n")
w("\n| 중분류 | 건수 | std_id |")
w("|---|---:|---|")
g = collections.OrderedDict()
for s in man:
    g.setdefault(rows[s]["중분류"], []).append(s)
for k, v in g.items():
    w(f"| {k} | {len(v)} | " + " · ".join(f"`{x}`" for x in v) + " |")

w("\n---\n\n## 3. 판정 못 한 9건 — 전건 사유\n")
w("추정으로 채우지 않았다. 사유는 셋 중 하나다.\n")
w("\n| std_id | 기능 | 사유 | 무엇을 보면 닫히나 |")
w("|---|---|---|---|")
CLOSE = {
 "STD-MFG-059": "MES 소스 접근(품목관리 「디자인파일여부」 처리 로직)",
 "STD-MFG-060": "주문프로세스 PDF p.1 랜더링 화살표 색 재판독 또는 Edicus 담당 회신",
 "STD-MFG-061": "`auto-vs-human.md` A-3 — 「server」가 MES 인지 신규 시스템인지 실무진 확인",
 "STD-MFG-090": "`auto-vs-human.md` A-5 — MES 가 interlock 을 이미 구현했는지 MES 담당 회신",
 "STD-MFG-133": "`auto-vs-human.md` A-6 — 오프라인 주문이 신규 범위인지 **PM 결정**",
 "STD-CAT-024": "셀러어드민 카테고리 화면(포장재 상품군이 흡수됐는지)",
 "STD-CAT-026": "셀러어드민 상품 목록(수작 상품 등록 여부)",
 "STD-ADP-034": "셀러어드민 상품 등록 화면",
 "STD-ADP-035": "셀러어드민 상품 등록 화면",
}
for sid in order:
    if sid in J and J[sid][0] == "미판정":
        why = (J[sid][2] or "").replace("판정 불가 사유 — ", "")
        w(f"| `{sid}` | {rows[sid]['기능']} | {why} | {CLOSE.get(sid,'—')} |")
w("\n**4건(`STD-CAT-024`·`STD-CAT-026`·`STD-ADP-034`·`STD-ADP-035`)은 셀러어드민 접속 보류가 원인이다** — "
  "계정 보호 상태가 풀리면 한 번의 화면 확인으로 같이 닫힌다(닫기팩 A 17건과 같은 자리).\n")
w("**5건은 MES·PDF 쪽 미확인**이라 `auto-vs-human.md §5` A-3·A-4·A-5·A-6 을 그대로 승계했다. 새로 만든 미확인이 아니다.\n")

path = os.path.join(HERE, "judged-143.md")
open(path, "w", encoding="utf-8").write("\n".join(out) + "\n")
print("wrote", path, len(out), "lines")
