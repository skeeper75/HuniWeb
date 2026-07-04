"""반자동 라운드 러너(L6) — scan→board→remediate→verify 를 한 라운드로 묶고 인간 게이트서 정지.

설계 §2 L6·§5. **[HARD] 완전 무인 금지**: 러너는 진단·교정생성·재실측·종합보고까지(6단계)만.
적재 COMMIT·webadmin 실화면 확인(7·8)은 **인간 게이트** — 러너는 여기서 멈춘다. 인간이 승인·적재·
스냅샷 재생성 후 재실행하면 다음 라운드(N+1)가 돈다("돌린다→검토→승인→재실행"이 한 라운드).

산출:
  loop/round-report.md   인간 게이트용 종합(전역 verdict·차원별·적재 후보[P4 GO]·인간 입력 대기·다음 액션)
  loop/loop-rounds.csv   수렴 추이(append-only): round·결함·분류별·auto GO/NO-GO·verdict
전역 정지 = board.global_go(전 차원 stop_predicate·전 상품 PRICE≠0). 코드가 계산·정지 판단은 인간.
"""
from __future__ import annotations
import csv
import pathlib
from dataclasses import dataclass, field

from ..remediate import plan

_HERE = pathlib.Path(__file__).resolve().parent


@dataclass
class RoundResult:
    round_no: str
    snap_name: str
    global_go: bool
    dim_counts: dict                 # dimension → 결함수
    class_counts: dict               # remediation_class → (Fix수, 결함수)
    actionable: list = field(default_factory=list)   # (Fix, Verdict) — P4 GO auto_data(적재 후보)
    auto_nogo: list = field(default_factory=list)     # (Fix, Verdict) — 재실측 NO-GO(재조사)
    auto_skip: list = field(default_factory=list)     # (Fix, Verdict) — verifiable=False
    report_path: pathlib.Path | None = None


def run_round(board_res, plan_res, fix_verdicts, round_no="", note="") -> RoundResult:
    """이미 계산된 board/plan/verify 결과를 종합해 라운드 산출물 생성.

    fix_verdicts = [(Fix, Verdict), ...]  (auto_data Fix 별 P4 재실측 결과)
    """
    dim_counts = {dim: len(ds) for dim, ds in board_res.per_dim.items()}
    class_counts = {c: (len(fs), sum(len(f.defects) for f in fs))
                    for c, fs in plan_res.by_class.items()}
    actionable = [(f, v) for f, v in fix_verdicts if v.verifiable and v.go]
    auto_nogo = [(f, v) for f, v in fix_verdicts if v.verifiable and not v.go]
    auto_skip = [(f, v) for f, v in fix_verdicts if not v.verifiable]

    res = RoundResult(
        round_no=str(round_no), snap_name=board_res.snap_name,
        global_go=board_res.global_go, dim_counts=dim_counts, class_counts=class_counts,
        actionable=actionable, auto_nogo=auto_nogo, auto_skip=auto_skip,
    )
    res.report_path = _write_report(res, board_res, plan_res)
    _append_rounds(res, note)
    return res


def _write_report(res: RoundResult, board_res, plan_res) -> pathlib.Path:
    L = [f"# hdx 라운드 {res.round_no or '-'} — 종합 상태 (인간 게이트)\n",
         f"스냅샷 `{res.snap_name}` · 전역 판정: "
         f"**{'GO — 전 차원 결함 해소·수렴' if res.global_go else 'NO-GO — 결함 잔존'}**\n",
         "> [HARD] 러너는 진단·교정생성·재실측·종합까지. **적재 COMMIT·webadmin 실화면은 인간**. "
         "아래 '적재 후보'만 승인 대상.\n"]

    # 차원별 결함
    L.append("## 차원별 결함")
    L.append("| 차원 | 결함수 |")
    L.append("|---|---|")
    for dim, n in res.dim_counts.items():
        L.append(f"| {board_res.titles.get(dim, dim)} | {n} |")
    L.append("")

    # 적재 후보(P4 GO auto_data) — 인간 승인 대상
    L.append("## ✅ 이번 라운드 적재 후보 (P4 재실측 GO · 인간 승인 대상)\n")
    if res.actionable:
        for f, v in res.actionable:
            L.append(f"### {f.title}")
            L.append(f"- 재실측: {v.notes}")
            L.append(f"- SQL: `remediate/sql/*.{{dryrun,fix,undo}}.sql` "
                     f"(dryrun→검토→**인간 승인 후 fix 실행**→백업 보유)")
            L.append("")
    else:
        L.append("(P4 GO auto_data 교정 없음 — 이번 라운드 자동 적재 후보 0)\n")

    # 재실측 NO-GO
    if res.auto_nogo:
        L.append("## ⚠️ 재실측 NO-GO (예상과 다름·재조사·적재 금지)\n")
        for f, v in res.auto_nogo:
            L.append(f"- {f.title} — {v.notes}")
        L.append("")

    # 인간 입력 대기(worklist)
    L.append("## ⏳ 인간 입력 대기 (자동 교정 불가 · 값 날조 금지)\n")
    for c in ("blocked_human", "needs_authority", "needs_design", "review"):
        fs = plan_res.by_class.get(c, [])
        if not fs:
            continue
        ndef = sum(len(f.defects) for f in fs)
        L.append(f"- **{plan.CLASS_LABEL[c]}**: {len(fs)}건 / {ndef} 결함")
        for f in fs[:6]:
            L.append(f"    - {f.title}")
    L.append("")

    # 다음 액션
    L.append("## 다음 액션 (인간 게이트)\n")
    if res.global_go:
        L.append("전역 GO — 파일럿 도메인 수렴. 다음 도메인(판형·수량·옵션CPQ) 전파 또는 종료.")
    else:
        steps = []
        if res.actionable:
            steps.append("1. **적재 후보 검토·승인** → dryrun SQL 재실측 확인 → 인간 승인 → fix SQL 실행(백업 후)")
            steps.append("2. **webadmin 실화면 확인**(제외 0·PRICE≠0·판형·분기)")
            steps.append("3. **스냅샷 재생성** `bash _workspace/_foundation/live-snapshot/snapshot.sh`")
            steps.append("4. **재실행** `--scope <scope> --loop --round <N+1>` → 결함 감소·수렴 확인")
        else:
            steps.append("1. **인간 입력 대기** 항목을 실무진/권위(엑셀)/설계(§18)로 라우팅해 값·구성 확보")
            steps.append("2. 확보분 §7 dbmap 적재 → 스냅샷 재생성 → 재실행(다음 라운드)")
        L.extend(steps)
    L.append("")

    p = _HERE / "round-report.md"
    p.write_text("\n".join(L), encoding="utf-8")
    return p


def _append_rounds(res: RoundResult, note: str):
    rounds = _HERE / "loop-rounds.csv"
    new = not rounds.exists()
    total = sum(res.dim_counts.values())
    cc = res.class_counts
    with rounds.open("a", encoding="utf-8", newline="") as f:
        w = csv.writer(f)
        if new:
            w.writerow(["round", "snap", "total_defects", "auto_go", "auto_nogo",
                        "blocked_human", "needs_authority", "needs_design", "review",
                        "global_verdict", "note"])
        w.writerow([
            res.round_no, res.snap_name, total, len(res.actionable), len(res.auto_nogo),
            cc.get("blocked_human", (0, 0))[1], cc.get("needs_authority", (0, 0))[1],
            cc.get("needs_design", (0, 0))[1], cc.get("review", (0, 0))[1],
            "GO" if res.global_go else "NO-GO", note,
        ])
