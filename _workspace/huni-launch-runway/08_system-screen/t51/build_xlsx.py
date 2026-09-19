#!/usr/bin/env python3
"""t51 통합 원장 xlsx — 실무진이 직접 거르고 정렬해 쓰는 작업본.

시트: 원장 / 시스템요약 / 구분요약 / 일정 / 외부의존 / 미수록 / 결정안건 / 읽는법
숫자는 전부 stats.json · schedule.json · merged.csv 에서 읽는다(하드코딩 0).

실행: python3 build_xlsx.py
"""
import csv
import json
from pathlib import Path

from openpyxl import Workbook
from openpyxl.styles import Font, PatternFill, Alignment, Border, Side
from openpyxl.utils import get_column_letter

HERE = Path(__file__).resolve().parent
DATE = "2026-09-19"
OUT = HERE / "reports" / f"launch-screens-{DATE.replace('-', '')}.xlsx"

S = json.loads((HERE / "stats.json").read_text(encoding="utf-8"))
SCH = json.loads((HERE / "schedule.json").read_text(encoding="utf-8"))
ROWS = list(csv.DictReader((HERE / "merged.csv").open(encoding="utf-8")))
OOS = S["out_of_scope_crosscheck"]

HDR_FILL = PatternFill("solid", fgColor="E3DACC")
TITLE_FONT = Font(bold=True, size=13)
HDR_FONT = Font(bold=True, size=10)
THIN = Side(style="thin", color="D1CFC5")
BORDER = Border(bottom=THIN)


def sheet(wb, name, headers, rows, widths=None, freeze="A2", wrap_cols=()):
    ws = wb.create_sheet(name)
    ws.append(headers)
    for c in range(1, len(headers) + 1):
        cell = ws.cell(row=1, column=c)
        cell.fill, cell.font, cell.border = HDR_FILL, HDR_FONT, BORDER
        cell.alignment = Alignment(vertical="center")
    for r in rows:
        ws.append(list(r))
    ws.freeze_panes = freeze
    ws.auto_filter.ref = f"A1:{get_column_letter(len(headers))}{ws.max_row}"
    for i, w in enumerate(widths or [], start=1):
        ws.column_dimensions[get_column_letter(i)].width = w
    for ci in wrap_cols:
        for row in ws.iter_rows(min_row=2, min_col=ci, max_col=ci):
            row[0].alignment = Alignment(wrap_text=True, vertical="top")
    return ws


def main():
    OUT.parent.mkdir(exist_ok=True)
    wb = Workbook()
    wb.remove(wb.active)

    # 읽는 법
    ws = wb.create_sheet("읽는법")
    lines = [
        ("후니프린팅 오픈 일정 — 시스템·화면·기능 통합 원장", True),
        (f"작성 {DATE} · 카드 t51 · 입력 t48(shopby·huni-mall) + t49(webadmin·widget·pagebuilder) + t50(mes·edicus·pitstop)", False),
        ("", False),
        ("[가장 먼저] 상태 「완료」는 코드(또는 매뉴얼 원고)에서 그 기능이 실제로 있는 것을 확인했다는 뜻입니다.", True),
        ("라이브 화면에서 눌러 보거나 실주문으로 확인한 것은 0건입니다. 「오픈 시나리오에서 동작한다」로 읽으면 안 됩니다.", False),
        ("", False),
        ("scope = in  : 이번 오픈의 분모. 작업량·일정 집계는 이 행만 씁니다.", False),
        ("scope = out : 이미 있고 이번 오픈과 인과관계가 없는 사내 선례(예: MES 의 카페24·우커머스 연동). 집계에서 뺍니다.", False),
        ("", False),
        ("work_type — 그 기능이 어떤 방식으로 생기는가 (한 행에 한 값)", True),
        ("  build     직접 구현 — 상대 시스템 없이 우리가 화면·로직을 만든다", False),
        ("  integrate 연동 구현 — 두 시스템을 잇는 코드를 우리가 짠다 (counterpart·direction·owner_side 필수)", False),
        ("  config    설정·등록 — 코드 0, 관리화면에서 값만 넣는다", False),
        ("  provided  외부 제공 — 우리 작업 0, 확인만", False),
        ("  manual    사람 운영 — 검수·응대·수기 전달", False),
        ("", False),
        ("「남은 일」은 work_type 이 아니라 status 로 거릅니다 → status ≠ 완료", True),
        ("", False),
        ("merged_from 에 값이 있는 행 = 두 레인이 같은 path:line 을 가리켜 한 행으로 합친 연동 행입니다.", False),
        ("연동 행은 두 시스템에 걸치므로 system 과 counterpart 양쪽에서 찾을 수 있어야 합니다.", False),
        ("", False),
        ("일정 시트: 날짜를 새로 지어내지 않았습니다. 9/17 원장에 적힌 작업량 하한·선행·순서만 옮겼습니다.", True),
        (f"원장 {SCH['plan_rows']}행 중 하한이 적힌 것은 {SCH['plan_rows_with_effort_lb']}행뿐이고 합은 {SCH['spine_effort_lb_sum']}일입니다 —", False),
        ("달력 날짜가 아니라 작업량의 아래쪽 한계이며, 동시 진행분과 대기 시간은 들어 있지 않습니다.", False),
        ("하한이 0 인 단계는 「일이 없다」가 아니라 원장이 아직 산정하지 않았다는 뜻입니다.", False),
        ("", False),
        (f"미수록 시트: t48 이 넘긴 {OOS['total']}건 중 받는 원장에 같은 행 번호로 실재하는 것은 {OOS['hit']}건뿐이고, {OOS['miss_count']}건은 그 번호를 찾을 수 없습니다.", True),
        ("「행 번호가 없다」와 「그 일이 없다」는 다릅니다 — 같은 기능이 다른 번호로 실려 있을 수 있습니다.", False),
        ("실측: 쿠폰·공지는 webadmin 으로 넘겼지만 t48 의 shopby 원장에 쿠폰 18행·공지 11행이 다른 번호로 있습니다.", False),
        (f"그래서 낱말 흔적으로 갈라 셌습니다 — 흔적 전무 {OOS['miss_untraced_count']}건(「빠진 일」의 하한) · "
         f"어딘가 흔적 있음 {OOS['miss_traced_count']}건(넘긴 곳이 틀렸을 후보의 상한, 낱말 일치라 과다 계상).", False),
        ("어느 쪽도 확정이 아닙니다. 가리려면 webadmin·셀러어드민을 한 번 다시 훑어야 합니다.", False),
        ("", False),
        ("DB 쓰기 0 · 라이브 접속 0 · 날짜 추정 0 · 숫자는 전부 assemble.py / schedule.py 가 계산했습니다.", False),
    ]
    for text, bold in lines:
        ws.append([text])
        if bold:
            ws.cell(row=ws.max_row, column=1).font = TITLE_FONT
    ws.column_dimensions["A"].width = 135

    # 원장
    cols = ["system", "group", "screen_id", "screen_name", "role", "function",
            "work_type", "counterpart", "direction", "owner_side", "plan_row_id",
            "status", "scope", "card", "merged_from", "evidence"]
    ko = ["시스템", "그룹", "화면ID", "화면명", "역할", "기능", "구분", "상대시스템",
          "방향", "코드가사는쪽", "원장행", "상태", "분모", "출처카드", "병합", "근거"]
    sheet(wb, "원장", ko, [[r[c] for c in cols] for r in ROWS],
          widths=[13, 22, 26, 30, 15, 52, 10, 13, 20, 13, 14, 9, 7, 8, 14, 80],
          wrap_cols=(6, 16))

    # 시스템 요약
    systems = sorted({r["system"] for r in ROWS})
    srows = []
    for s in systems:
        rin = [r for r in ROWS if r["system"] == s and r["scope"] == "in"]
        srows.append([s, len(rin),
                      sum(1 for r in rin if r["status"] == "완료"),
                      sum(1 for r in rin if r["status"] != "완료"),
                      sum(1 for r in rin if r["status"] == "미확인"),
                      sum(1 for r in rin if r["work_type"] == "build"),
                      sum(1 for r in rin if r["work_type"] == "integrate"),
                      sum(1 for r in ROWS if r["system"] == s and r["scope"] == "out")])
    srows.sort(key=lambda x: -x[3])
    sheet(wb, "시스템요약",
          ["시스템", "분모안", "완료", "남은일", "미확인", "직접구현", "연동", "분모밖"],
          srows, widths=[16, 10, 8, 10, 10, 11, 8, 10])

    # 구분 요약
    wt_ko = {"build": "직접 구현", "integrate": "연동 구현", "config": "설정·등록",
             "provided": "외부 제공", "manual": "사람 운영"}
    sheet(wb, "구분요약", ["구분", "뜻", "분모안", "남은일"],
          [[wt_ko[w], w, S["in_by_work_type"].get(w, 0), S["in_remaining_by_work_type"].get(w, 0)]
           for w in ["build", "integrate", "config", "provided", "manual"]],
          widths=[14, 14, 10, 10])

    # 일정
    sheet(wb, "일정",
          ["원장행", "트랙", "단계", "내용", "담당", "원장하한(일)", "이문서행", "남은", "선행", "원장상태"],
          [[s["row_id"], s["track"], s["step"], s["title"], s["owner"],
            s["effort_lb_days"] or "", s["screen_rows"], s["screen_rows_remaining"],
            s["prereq"] or "—", s["status"]] for s in SCH["spine"]],
          widths=[10, 8, 8, 70, 12, 13, 11, 8, 34, 12], wrap_cols=(4,))

    # 외부 의존
    sheet(wb, "외부의존", ["선행", "대기행수", "예시 원장행"],
          [[k, v["waiting_rows"], ", ".join(v["sample"])]
           for k, v in SCH["ext_dependencies"].items()],
          widths=[22, 11, 60])

    # 미수록
    sheet(wb, "미수록",
          ["원장행", "내용", "넘긴곳", "담당", "원장상태", "낱말흔적"],
          [[m["plan_row_id"], m["title"], m["routed_system"], m["owner_name"], m["plan_status"],
            ", ".join(m["function_trace_cards"]) if m["function_trace"] else "없음"]
           for m in OOS["miss"]],
          widths=[16, 78, 16, 16, 13, 16], wrap_cols=(2,))

    # 결정 안건 (건수 집계 — 본문은 각 *-decisions.md)
    sheet(wb, "결정안건", ["출처 문서", "건수", "비고"],
          [[k, v, "본문은 해당 마크다운 파일"] for k, v in sorted(S["decisions"].items())]
          + [["합계", S["decisions_total"], "화면·기능이 아니라 누군가 정해야 끝나는 일"]],
          widths=[38, 8, 44])

    wb.save(OUT)
    print(f"xlsx → {OUT}  시트 {len(wb.sheetnames)}종: {', '.join(wb.sheetnames)}")
    print(f"원장 시트 {len(ROWS)}행 · 미수록 {OOS['miss_count']}행 · 일정 {len(SCH['spine'])}행")


if __name__ == "__main__":
    main()
