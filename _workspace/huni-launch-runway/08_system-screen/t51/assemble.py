#!/usr/bin/env python3
"""t51 통합 조립기 — 세 레인(t48/t49/t50) screens.csv 를 하나의 원장으로 합친다.

결정론 파서다. 숫자를 사람(LLM)이 옮겨 적지 않는다.
- scope 파생: evidence 가 "[오픈분모밖] " 로 시작하면 out, 아니면 in (CONTRACT 보충 1 개정)
- 중복 병합: evidence 의 첫 path:line 을 키로, 레인이 다른 integrate 행만 합친다 (보충 3 명확화)
- 산출: merged.csv (원장) · stats.json (집계) — 표준출력에 검산 리포트

실행: python3 assemble.py
"""
import csv
import json
import re
import collections
from pathlib import Path

BASE = Path(__file__).resolve().parent.parent
OUT_DIR = Path(__file__).resolve().parent
OUT_PREFIX = "[오픈분모밖] "
CARDS = ("t48", "t49", "t50")

# evidence 안의 첫 path:line — 확장자를 가진 경로 뒤에 :숫자(또는 :숫자-숫자)
PATH_LINE = re.compile(r"[A-Za-z0-9_./\-]+\.[A-Za-z0-9]+:\d+(?:-\d+)?")

FIELDS = [
    "system", "group", "screen_id", "screen_name", "role", "function",
    "work_type", "counterpart", "direction", "owner_side", "plan_row_id",
    "status", "evidence",
]
OUT_FIELDS = ["row_uid", "card", "scope", "dup_key", "merged_from"] + FIELDS


def load_rows():
    rows = []
    for card in CARDS:
        path = BASE / card / "screens.csv"
        with path.open(encoding="utf-8") as f:
            reader = csv.DictReader(f)
            missing = [c for c in FIELDS if c not in reader.fieldnames]
            if missing:
                raise SystemExit(f"{path}: 필수열 누락 {missing}")
            for i, r in enumerate(reader, start=2):
                ev = (r.get("evidence") or "").strip()
                scope = "out" if ev.startswith(OUT_PREFIX) else "in"
                body = ev[len(OUT_PREFIX):] if scope == "out" else ev
                m = PATH_LINE.search(body)
                row = {k: (r.get(k) or "").strip() for k in FIELDS}
                row.update(
                    row_uid=f"{card}:{i}",
                    card=card,
                    scope=scope,
                    dup_key=m.group(0) if m else "",
                    merged_from="",
                )
                rows.append(row)
    return rows


def merge_cross_lane(rows):
    """레인이 다른 integrate 행 중 「같은 이음매의 같은 근거」인 것을 한 행으로 합친다.

    키 = (evidence 첫 path:line, {system, counterpart} 무순 쌍).

    path:line 만으로 키를 잡으면 안 된다 — 한 라우트 줄(urls.py:249)에 서로 다른
    기능이 걸릴 수 있고, 실제로 그렇게 걸린 두 쌍이 잘못 합쳐진 것을 verify.py V5 가
    잡아냈다(260919). 이음매가 같아야 같은 사실이다.
    """
    groups = collections.defaultdict(list)
    for r in rows:
        if r["dup_key"] and r["work_type"] == "integrate":
            edge = tuple(sorted({r["system"], r["counterpart"]} - {""}))
            groups[(r["dup_key"], edge)].append(r)

    merged_out, dropped = [], set()
    merge_log, near_miss = [], []
    # 키는 같은데 이음매가 달라 합치지 않은 쌍 — 사람이 확인하라고 남긴다
    by_path = collections.defaultdict(set)
    for (path, edge), grp in groups.items():
        by_path[path].add((edge, tuple(sorted({g["card"] for g in grp}))))
    for path, variants in by_path.items():
        if len(variants) > 1:
            near_miss.append({"dup_key": path,
                              "edges": [list(v[0]) for v in sorted(variants)]})

    for (key, edge), grp in groups.items():
        if len({g["card"] for g in grp}) < 2:
            continue
        # owner_side 가 채워진 행을 대표로, 없으면 첫 행
        grp_sorted = sorted(grp, key=lambda g: (g["owner_side"] == "", g["card"]))
        keep, rest = grp_sorted[0], grp_sorted[1:]
        keep["merged_from"] = ";".join(g["row_uid"] for g in rest)
        for g in rest:
            dropped.add(g["row_uid"])
        merge_log.append({
            "dup_key": key,
            "edge": list(edge),
            "kept": keep["row_uid"],
            "dropped": [g["row_uid"] for g in rest],
            "systems": sorted({g["system"] for g in grp} | {g["counterpart"] for g in grp if g["counterpart"]}),
        })
    merged_out = [r for r in rows if r["row_uid"] not in dropped]
    return merged_out, merge_log, near_miss


def crosscheck_out_of_scope(rows):
    """t48 out-of-scope.csv 의 라우팅 대상이 실제로 t49·t50 원장에 있는지 교차검산."""
    oos_path = BASE / "t48" / "out-of-scope.csv"
    if not oos_path.exists():
        return {"total": 0, "hit": 0, "miss": []}
    plan_ids = collections.defaultdict(set)
    for r in rows:
        for pid in re.split(r"[;,\s]+", r["plan_row_id"]):
            if pid and pid != "NEW":
                plan_ids[pid].add(r["card"])
    total, hit, miss = 0, 0, []
    hit_rows = []
    with oos_path.open(encoding="utf-8") as f:
        for r in csv.DictReader(f):
            total += 1
            pid = (r.get("plan_row_id") or "").strip()
            cards = plan_ids.get(pid, set()) - {"t48"}
            if cards:
                hit += 1
                hit_rows.append({"plan_row_id": pid, "cards": sorted(cards)})
            else:
                miss.append({
                    "plan_row_id": pid,
                    "title": (r.get("title") or "").strip(),
                    "routed_system": (r.get("routed_system") or "").strip(),
                    "owner_name": (r.get("owner_name") or "").strip(),
                    "plan_status": (r.get("plan_status") or "").strip(),
                })
    # 미수록 = plan_row_id 기준 판정이다. 같은 기능이 다른 plan_row_id 로 어느 원장에
    # 실려 있을 수 있다(리드 lane-1 표본 지적 260919: 「쿠폰 생성·발행 관리」는 webadmin 으로
    # 넘겼지만 t48 shopby 원장에 쿠폰 행이 있다). 그래서 기능 흔적을 전 원장에서 다시 찾는다.
    # 결과는 「라우팅 대상이 틀렸을 후보」이지 확정이 아니다.
    GENERIC = {
        "관리", "등록", "설정", "처리", "조회", "발행", "화면", "연동", "확인", "자동", "수동",
        "목록", "내역", "데이터", "기능", "사용", "주문", "상품", "회원", "생성", "수정", "삭제",
        "별도", "경로", "직접", "입력", "출력", "방안", "여부", "기준", "단위", "구현", "관리자",
        "시스템", "서비스", "요청", "접수", "전송", "수신", "통합", "전체", "일부",
    }
    haystacks = collections.defaultdict(list)
    for r in rows:
        haystacks[r["card"]].append(
            f'{r["group"]} {r["screen_name"]} {r["function"]}')
    all_hay = [(c, h) for c, hs in haystacks.items() for h in hs]

    def trace(title):
        toks = {t for t in re.split(r"[^\w가-힣]+", title)
                if len(t) >= 2 and t not in GENERIC and not t.isdigit()}
        hits = collections.Counter()
        for tok in toks:
            for card, hay in all_hay:
                if tok in hay:
                    hits[card] += 1
        return sorted(hits), toks

    for m in miss:
        cards, toks = trace(m["title"])
        m["function_trace_cards"] = cards
        m["function_trace"] = bool(cards)

    by_routed = collections.Counter(m["routed_system"] for m in miss)
    by_owner = collections.Counter(m["owner_name"] for m in miss)
    return {
        "total": total, "hit": hit, "hit_rows": hit_rows,
        "miss_count": len(miss),
        # 미수록 중 기능 흔적이 다른 원장에 있는 것(= 라우팅 대상 오류 후보) / 없는 것
        "miss_traced_count": sum(1 for m in miss if m["function_trace"]),
        "miss_untraced_count": sum(1 for m in miss if not m["function_trace"]),
        "miss_traced_by_card": dict(collections.Counter(
            c for m in miss for c in m["function_trace_cards"]).most_common()),
        "miss_by_routed_system": dict(by_routed.most_common()),
        "miss_by_owner": dict(by_owner.most_common()),
        "miss": miss,
    }


def count_decisions():
    """*-decisions.md 의 안건 건수.

    문서에 표가 여럿인 경우가 있다(t49 pagebuilder 의 「옮기지 않은 후보」 표).
    안건 표는 첫 열 머리글이 plan_row_id/row_id 인 표뿐이므로 그것만 센다.
    """
    out, detail = {}, {}
    for path in sorted(BASE.glob("t*/*-decisions.md")):
        n, in_agenda_table = 0, False
        for line in path.read_text(encoding="utf-8").splitlines():
            s = line.strip()
            if not (s.startswith("|") and s.endswith("|")):
                in_agenda_table = False
                continue
            cells = [c.strip() for c in s.strip("|").split("|")]
            if set("".join(cells)) <= set("-: "):      # 구분선
                continue
            if cells[0] in ("plan_row_id", "row_id"):   # 안건 표 머리글
                in_agenda_table = True
                continue
            if cells[0] in ("screen_id", "#", "안건"):   # 안건 표가 아닌 표
                in_agenda_table = False
                continue
            if in_agenda_table:
                n += 1
        key = f"{path.parent.name}/{path.name}"
        out[key] = n
        detail[key] = path.name.replace("-decisions.md", "")
    return out


def main():
    rows = load_rows()
    raw_total = len(rows)
    merged, merge_log, near_miss = merge_cross_lane(rows)

    stats = {
        "raw_total": raw_total,
        "merged_total": len(merged),
        "merged_pairs": len(merge_log),
        "merged_rows_folded": raw_total - len(merged),
        # 같은 path:line 이지만 이음매가 달라 합치지 않은 것 — 사람 확인용
        "same_path_different_edge": near_miss,
        "by_card": dict(collections.Counter(r["card"] for r in rows)),
        "by_scope": dict(collections.Counter(r["scope"] for r in merged)),
        "by_scope_card": {f"{c}/{s}": n for (c, s), n in
                          sorted(collections.Counter((r["card"], r["scope"]) for r in merged).items())},
        "by_system": dict(sorted(collections.Counter(r["system"] for r in merged).items())),
        "by_work_type": dict(sorted(collections.Counter(r["work_type"] for r in merged).items())),
        "by_status": dict(sorted(collections.Counter(r["status"] for r in merged).items())),
        "by_role": dict(sorted(collections.Counter(r["role"] for r in merged).items())),
        "in_by_status": dict(sorted(collections.Counter(
            r["status"] for r in merged if r["scope"] == "in").items())),
        "in_by_work_type": dict(sorted(collections.Counter(
            r["work_type"] for r in merged if r["scope"] == "in").items())),
        "new_rows": sum(1 for r in merged if r["plan_row_id"] == "NEW"),
        "new_by_card": dict(sorted(collections.Counter(
            r["card"] for r in merged if r["plan_row_id"] == "NEW").items())),
        "no_dup_key": sum(1 for r in merged if not r["dup_key"]),
        # 남은 일 = status != 완료 (CONTRACT 보충 3) · 집계는 scope=in 만
        "in_remaining": sum(1 for r in merged if r["scope"] == "in" and r["status"] != "완료"),
        "in_remaining_by_system": dict(sorted(collections.Counter(
            r["system"] for r in merged if r["scope"] == "in" and r["status"] != "완료").items())),
        "in_remaining_by_work_type": dict(sorted(collections.Counter(
            r["work_type"] for r in merged if r["scope"] == "in" and r["status"] != "완료").items())),
        "by_system_status": {f"{s}/{st}": n for (s, st), n in sorted(
            collections.Counter((r["system"], r["status"]) for r in merged
                                if r["scope"] == "in").items())},
        "by_system_group": {f"{s}/{g}": n for (s, g), n in sorted(
            collections.Counter((r["system"], r["group"]) for r in merged).items())},
        "integrate_owner_side_undecided": sum(
            1 for r in merged if r["scope"] == "in" and r["work_type"] == "integrate"
            and r["owner_side"] in ("", "미정")),
        "decisions": count_decisions(),
        "out_of_scope_crosscheck": crosscheck_out_of_scope(rows),
    }
    stats["decisions_total"] = sum(stats["decisions"].values())

    with (OUT_DIR / "merged.csv").open("w", encoding="utf-8", newline="") as f:
        w = csv.DictWriter(f, fieldnames=OUT_FIELDS)
        w.writeheader()
        for r in sorted(merged, key=lambda r: (r["system"], r["group"], r["screen_id"], r["row_uid"])):
            w.writerow({k: r[k] for k in OUT_FIELDS})
    (OUT_DIR / "stats.json").write_text(
        json.dumps(stats, ensure_ascii=False, indent=2), encoding="utf-8")
    (OUT_DIR / "merge-log.json").write_text(
        json.dumps(merge_log, ensure_ascii=False, indent=2), encoding="utf-8")

    print(json.dumps(stats, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
