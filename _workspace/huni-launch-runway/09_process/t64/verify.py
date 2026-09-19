#!/usr/bin/env python3
"""t64 검증 — 게이트 V1~V8.

생성(assign.py·build_tree.py·processes/*.md)과 분리된 검증기다.
원장·정본을 다시 읽어 독립적으로 센다. 실패 시 exit 1.
"""
import collections, csv, os, re, sys

HERE = os.path.dirname(os.path.abspath(__file__))
RUNWAY = os.path.abspath(os.path.join(HERE, "..", ".."))
LEDGER = os.path.join(RUNWAY, "08_system-screen", "t56", "rejudge.csv")
CANON = os.path.join(RUNWAY, "07_rebaseline", "L1", "standard-feature-canon.csv")
TREE = os.path.join(HERE, "process-tree.csv")
GAPS = os.path.join(HERE, "gaps.csv")
PROCDIR = os.path.join(HERE, "processes")

FAILS, NOTES = [], []


def check(gate, ok, msg):
    (NOTES if ok else FAILS).append(f"{'PASS' if ok else 'FAIL'} {gate} — {msg}")


def scope_ids(ledger):
    """분모의 독립 정의 — build_tree.in_scope 를 import 하지 않고 여기서 다시 쓴다."""
    out = set()
    for r in ledger:
        rid = r["row_id"]
        if rid.startswith(("STD-MFG-", "STD-ADO-")):
            out.add(rid)
        elif rid.startswith("STD-ART-") and r["step"] in ("C4", "C5"):
            out.add(rid)
        elif rid in ("T4-2", "T4-3", "T4-4", "T4-5", "BLK-S2-2", "BLK-S2-3", "BLK-S2-4"):
            out.add(rid)
    return out


def main():
    ledger = list(csv.DictReader(open(LEDGER, encoding="utf-8")))
    canon = list(csv.DictReader(open(CANON, encoding="utf-8")))
    tree = list(csv.DictReader(open(TREE, encoding="utf-8")))
    gaps = list(csv.DictReader(open(GAPS, encoding="utf-8")))
    ledger_ids = {r["row_id"] for r in ledger}

    # V1 입력 정본이 카드가 말한 크기인가
    check("V1", len(ledger) == 735, f"원장 735행 (실측 {len(ledger)})")
    check("V1", len(canon) == 353, f"기능목록 정본 353행 (실측 {len(canon)})")

    # V2 미귀속 0 — 담당 범위 행이 전부 1개 이상 프로세스에 들어갔는가
    scope = scope_ids(ledger)
    owned = {r["L4_단계_row_id"] for r in tree if r["귀속"] == "담당"}
    check("V2", scope == owned,
          f"담당 범위 {len(scope)}행 = 귀속 {len(owned)}행 · 미귀속 {sorted(scope - owned)} · 범위밖 {sorted(owned - scope)}")

    # V3 tree 의 모든 row_id 가 원장에 실재하는가(원장 밖 신규 행을 섞지 않았는가)
    ghosts = sorted({r["L4_단계_row_id"] for r in tree} - ledger_ids)
    check("V3", not ghosts, f"원장 밖 row_id 0건 (발견 {ghosts})")

    # V4 원장 735행을 고치지 않았는가 — 이 카드는 원장 파일을 쓰지 않는다
    import subprocess
    p = subprocess.run(["git", "status", "--porcelain", "--", LEDGER],
                       capture_output=True, text=True, cwd=RUNWAY)
    check("V4", not p.stdout.strip(), f"t56/rejudge.csv 미변경 (git: {p.stdout.strip() or 'clean'})")

    # V5 프로세스 파일이 전부 있고 고정 7절을 갖췄는가
    procs = sorted({r["L3_프로세스"] for r in tree})
    missing, badsec = [], []
    sec_pat = [r"^## 1\. ", r"^## 2\. ", r"^## 3\. ", r"^## 4\. ", r"^## 5\. ", r"^## 6\. ", r"^## 7\. "]
    for pid in procs:
        path = os.path.join(PROCDIR, f"{pid}.md")
        if not os.path.exists(path):
            missing.append(pid)
            continue
        body = open(path, encoding="utf-8").read()
        for pat in sec_pat:
            if not re.search(pat, body, re.M):
                badsec.append(f"{pid}:{pat}")
    check("V5", not missing and not badsec,
          f"프로세스 문서 {len(procs)}개 · 누락 {missing} · 7절 결손 {badsec}")

    # V6 프로세스마다 mermaid 2종(sequenceDiagram + flowchart)이 있는가
    nodiag = []
    for pid in procs:
        body = open(os.path.join(PROCDIR, f"{pid}.md"), encoding="utf-8").read()
        if "sequenceDiagram" not in body or "flowchart" not in body:
            nodiag.append(pid)
    check("V6", not nodiag, f"mermaid 2종 구비 · 결손 {nodiag}")

    # V7 빠진 곳 4종 분류가 gaps.csv 에서 유효한가 · 프로세스 id 가 실재하는가
    kinds = {"가 원장에 행 없음", "나 행은 있는데 코드 0", "다 코드는 있는데 연결 안 됨", "라 결정 미정"}
    badkind = sorted({g["종류"] for g in gaps} - kinds)
    pids = {p.split("-")[0] for p in procs}
    badpid = sorted({g["프로세스"] for g in gaps} - pids)
    check("V7", not badkind and not badpid,
          f"gaps {len(gaps)}건 · 분류 오류 {badkind} · 프로세스 오류 {badpid}")

    # V9 gaps.csv 종류별 수 = processes/*.md §5 소절의 실제 항목 수
    #    (260919 리드 t66 적발 — 본문 수와 CSV 수가 어긋났다. §5 를 기준으로 고정한다)
    sys.path.insert(0, HERE)
    from count_gaps import per_process  # noqa: E402
    per = per_process(PROCDIR)
    s5 = collections.Counter()
    for d in per.values():
        for k, n in d.items():
            s5[k] += n
    gc = collections.Counter(g["종류"][0] for g in gaps)
    diff = {k: (s5[k], gc[k]) for k in "가나다라" if s5[k] != gc[k]}
    check("V9", not diff, f"§5 항목 수 = gaps.csv 수 · 종류별 {[f'{k}{s5[k]}' for k in '가나다라']} · 불일치 {diff}")

    # V10 verdict.md 본문에 적힌 종류별 수 = gaps.csv 수 (본문이 CSV 를 앞지르지 못하게)
    vd = open(os.path.join(HERE, "verdict.md"), encoding="utf-8").read()
    pat = re.compile(r"빠진 곳 (\d+)건\*\* — 가\(원장에 행 없음\) \*\*(\d+)\*\* · "
                     r"나\(행은 있는데 코드 0\) \*\*(\d+)\*\* · 다\(코드는 있는데 연결 안 됨\) \*\*(\d+)\*\* · "
                     r"라\(결정 미정\) \*\*(\d+)\*\*")
    hits = pat.findall(vd)
    want = (str(len(gaps)), str(gc["가"]), str(gc["나"]), str(gc["다"]), str(gc["라"]))
    bad = [h for h in hits if tuple(h) != want]
    check("V10", hits and not bad,
          f"verdict 본문 집계 {len(hits)}곳 = gaps.csv {want} · 어긋남 {bad}")

    # V8 gaps 가 참조한 row_id 가 원장에 실재하는가(범위 표기 · — 제외)
    bad_ref = []
    for g in gaps:
        for rid in (g["관련_row_id"] or "").split(";"):
            rid = rid.strip()
            if not rid or rid == "—" or "~" in rid:
                continue
            if rid not in ledger_ids:
                bad_ref.append(f"{g['gap_id']}:{rid}")
    check("V8", not bad_ref, f"gaps 참조 row_id 실재 · 오류 {bad_ref}")

    # V11 제안_담당 공란 0 · 담당_근거가 ①/②/③ 중 하나로 표기됐는가
    #     (260919 리드 지시 — 공란 105건이 t66 의 「미정」으로 그대로 흘러갔다)
    blank = [g["gap_id"] for g in gaps if not (g.get("제안_담당") or "").strip()]
    nobasis = [g["gap_id"] for g in gaps if not (g.get("담당_근거") or "").strip()]
    badbasis = [g["gap_id"] for g in gaps if (g.get("담당_근거") or "")[:1] not in ("①", "②", "③")]
    rulec = collections.Counter((g.get("담당_근거") or "?")[0] for g in gaps)
    check("V11", not blank and not nobasis and not badbasis,
          f"제안_담당 공란 {len(blank)}{blank} · 담당_근거 공란 {len(nobasis)}{nobasis} · "
          f"근거표기 오류 {badbasis} · 규칙별 " + " · ".join(f"{k}{rulec[k]}" for k in "①②③")
          + f" · 남은 「미정」 {sum(1 for g in gaps if g['제안_담당'] == '미정')}")

    # V12 ① 로 채운 행의 담당이 원장 owner_proposed 와 실제로 같은가(생성기를 믿지 않고 다시 조인)
    lowner = {r["row_id"]: r["owner_proposed"].strip() for r in ledger}
    mism = []
    for g in gaps:
        if not (g.get("담당_근거") or "").startswith("① "):
            continue
        want = []
        for rid in g["관련_row_id"].split(";"):
            rid = rid.strip()
            if not rid or rid == "—" or "~" in rid:
                continue
            o = lowner.get(rid, "")
            if o and o not in want:
                want.append(o)
        if " ; ".join(want) != g["제안_담당"]:
            mism.append(f"{g['gap_id']}({g['제안_담당']}≠{' ; '.join(want)})")
    check("V12", not mism, f"① 승계 담당 = 원장 owner_proposed 재조인 · 불일치 {mism}")

    for line in NOTES + FAILS:
        print(line)
    print(f"\n담당 범위 {len(scope)}행 · 프로세스 {len(procs)} · tree {len(tree)}행 · gaps {len(gaps)}건")
    print(f"게이트 {len(NOTES)}통과 / {len(FAILS)}실패")
    return 1 if FAILS else 0


if __name__ == "__main__":
    sys.exit(main())
