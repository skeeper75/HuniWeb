"""교정 플랜 조립·산출(L4 종합) — Fix 병합(근본원인 dedup) → worklist(md/csv) + auto_data SQL 트리플.

[HARD] auto_data 라도 자동 COMMIT 금지: dryrun 우선·게이트·P4 재실측·인간 승인 후에만 fix 실행.
worklist 계열(needs_*/blocked_human/review)은 값 날조 금지 원칙에 따라 SQL 없이 실무진/권위/설계로 라우팅.
"""
from __future__ import annotations
import csv
import pathlib
import re
from dataclasses import dataclass

from ..foundation import Snapshot, Fix

_HERE = pathlib.Path(__file__).resolve().parent
SQL_DIR = _HERE / "sql"

CLASS_ORDER = ["auto_data", "blocked_human", "needs_authority", "needs_design",
               "needs_engine", "review"]
CLASS_LABEL = {
    "auto_data": "AUTO (값 날조 없는 결정론 교정·SQL 생성·P4+인간 승인 후 적재)",
    "blocked_human": "실무진 입력 대기 (placeholder 단가·구성)",
    "needs_authority": "권위값 확보 필요 (엑셀/실무진 단가)",
    "needs_design": "가격설계 필요 (§18)",
    "needs_engine": "엔진 코드변경 (C트랙)",
    "review": "수동 검토 (저신뢰·정리)",
}


@dataclass
class PlanResult:
    fixes: list          # 병합·정렬된 Fix
    by_class: dict       # class → list[Fix]
    snap_name: str


def _merge_root(fixes: list[Fix]) -> list[Fix]:
    """근본원인 dedup: 같은 (class, root_comps) worklist Fix 를 하나로 병합(차원 교차 근본원인)."""
    merged: dict[tuple, Fix] = {}
    passthrough: list[Fix] = []
    for f in fixes:
        # auto_data(SQL 보유)·root_comps 없는 건 병합 안 함
        if f.is_auto or not f.root_comps:
            passthrough.append(f)
            continue
        key = (f.remediation_class, frozenset(f.root_comps))
        if key in merged:
            m = merged[key]
            m.defects.extend(f.defects)
            # 차원 교차 표기·note 결합
            if f.dimension not in m.dimension:
                m.dimension = f"{m.dimension}+{f.dimension}"
            m.worklist_note += f"  |  ({f.dimension}) {f.worklist_note}"
        else:
            merged[key] = Fix(
                dimension=f.dimension, remediation_class=f.remediation_class,
                title=f.title, defects=list(f.defects), root_comps=list(f.root_comps),
                worklist_note=f.worklist_note, gates=list(f.gates),
            )
    return passthrough + list(merged.values())


def run(remediators, defects, snap: Snapshot) -> PlanResult:
    all_fixes: list[Fix] = []
    for r in remediators:
        all_fixes.extend(r.generate(defects, snap))
    fixes = _merge_root(all_fixes)
    fixes.sort(key=lambda f: (CLASS_ORDER.index(f.remediation_class)
                              if f.remediation_class in CLASS_ORDER else 9,
                              -len(f.defects)))
    by_class: dict[str, list[Fix]] = {}
    for f in fixes:
        by_class.setdefault(f.remediation_class, []).append(f)
    return PlanResult(fixes=fixes, by_class=by_class, snap_name=snap.dir.name)


def _slug(s: str) -> str:
    return re.sub(r"[^a-zA-Z0-9]+", "-", s).strip("-").lower()[:60]


def write_sql(res: PlanResult) -> list[pathlib.Path]:
    """auto_data Fix 의 dryrun/fix/undo SQL 트리플을 sql/ 에 기록."""
    SQL_DIR.mkdir(parents=True, exist_ok=True)
    # 기존 생성물 정리(멱등)
    for p in SQL_DIR.glob("*.sql"):
        p.unlink()
    written = []
    for i, f in enumerate(res.by_class.get("auto_data", []), 1):
        if not f.fix_sql:
            continue  # 가이드형(SQL 미재료화·병합 등) → 건너뜀
        base = f"{i:02d}-{f.dimension}-{_slug(f.title)}"
        for kind, sql in (("dryrun", f.dryrun_sql), ("fix", f.fix_sql), ("undo", f.undo_sql)):
            if sql:
                p = SQL_DIR / f"{base}.{kind}.sql"
                p.write_text(sql, encoding="utf-8")
                written.append(p)
    return written


def write_plan(res: PlanResult, path: pathlib.Path | None = None) -> pathlib.Path:
    path = path or (_HERE / "remediation-plan.md")
    L = []
    L.append(f"# hdx 교정 플랜 (P3) — {res.snap_name}\n")
    L.append("> [HARD] 자동은 교정본 생성까지. 적재 COMMIT·webadmin 실화면은 **인간 게이트**. "
             "값 날조 금지 — 단가값은 권위(엑셀/실무진)에서만.\n")
    # 요약
    L.append("## 요약\n")
    L.append("| 분류 | 건수 | 닫는 결함 | 의미 |")
    L.append("|---|---|---|---|")
    for c in CLASS_ORDER:
        fs = res.by_class.get(c, [])
        if not fs:
            continue
        ndef = sum(len(f.defects) for f in fs)
        L.append(f"| `{c}` | {len(fs)} | {ndef} | {CLASS_LABEL[c]} |")
    L.append("")
    # 분류별 상세
    for c in CLASS_ORDER:
        fs = res.by_class.get(c, [])
        if not fs:
            continue
        L.append(f"## {CLASS_LABEL[c]}  (`{c}`)\n")
        for f in fs:
            L.append(f"### {f.title}")
            L.append(f"- 차원: `{f.dimension}` · 닫는 결함 {len(f.defects)}건"
                     + (f" · 근본 comp: {', '.join(f.root_comps)}" if f.root_comps else ""))
            if f.worklist_note:
                L.append(f"- 지시: {f.worklist_note}")
            if f.gates:
                L.append("- 게이트: " + " · ".join(f.gates))
            if f.is_auto and f.fix_sql:
                L.append(f"- SQL: `remediate/sql/*-{_slug(f.title)}.{{dryrun,fix,undo}}.sql` "
                         f"(★dryrun→P4 재실측→인간 승인 후 fix)")
            elif f.is_auto:
                L.append("- SQL: 검증된 생성기로 재료화(component_merge=gen_commit_sql 승계)")
            L.append("")
    path.write_text("\n".join(L), encoding="utf-8")
    return path


def write_csv(res: PlanResult, path: pathlib.Path | None = None) -> pathlib.Path:
    path = path or (_HERE / "remediation-plan.csv")
    with path.open("w", encoding="utf-8", newline="") as fp:
        w = csv.writer(fp)
        w.writerow(["remediation_class", "dimension", "title", "n_defects",
                    "root_comps", "has_sql", "worklist_note"])
        for f in res.fixes:
            w.writerow([f.remediation_class, f.dimension, f.title, len(f.defects),
                        ";".join(f.root_comps), "Y" if (f.is_auto and f.fix_sql) else "",
                        f.worklist_note[:300]])
    return path
