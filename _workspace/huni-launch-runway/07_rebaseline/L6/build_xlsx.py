#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
L6 · 엑셀 5시트 생성기
원장 CSV(504행) → 260616 양식 5시트 xlsx.

원본 `docs/huni/후니프린팅_통합IA_일정_역할분담_260616.xlsx` 는 읽기만 한다(수정 금지).
산출 기본값 `docs/huni/후니프린팅_통합IA_일정_역할분담_260902.xlsx`.

재실행: 원장 경로만 바꾸면 된다.
    python3 L6/build_xlsx.py --ledger L5/P1/unified-ledger-v2.csv
"""
import argparse
import csv
import datetime as _dt
import os
import re
import sys

import openpyxl
from openpyxl.styles import Alignment, Border, Font, PatternFill, Side
from openpyxl.utils import get_column_letter

# ── 후니 디자인 토큰 (huni-design-system v5) ────────────────────────────
C_PRIMARY = "5538B6"
C_DARK = "351D87"
C_BORDER = "CACACA"
C_HEAD_BG = "EEEAF8"
C_ZEBRA = "F7F5FC"

HERE = os.path.dirname(os.path.abspath(__file__))
REBASE = os.path.dirname(HERE)                      # 07_rebaseline
REPO = os.path.abspath(os.path.join(REBASE, "..", "..", ".."))

DEF_LEDGER = os.path.join(REBASE, "L5", "unified-ledger-assigned.csv")
DEF_GATES = os.path.join(REBASE, "L5", "O2", "gates.md")
DEF_TEMPLATE = os.path.join(REPO, "docs", "huni", "후니프린팅_통합IA_일정_역할분담_260616.xlsx")
DEF_OUT = os.path.join(REPO, "docs", "huni", "후니프린팅_통합IA_일정_역할분담_260902.xlsx")

SHEETS = ["00_읽는법", "01_역할정의", "02_IA마스터", "03_페이즈일정", "04_진행현황"]

IA_HEADERS = ["No", "시스템", "영역", "기능", "우선순위", "담당",
              "개발규모", "진행상태", "Phase", "확인·결정 필요사항 (선행조건)", "비고"]

UNJUDGED = "미판정"

# 오픈차단 등급 표시 순서 (원장 값 그대로 · 지어내지 않는다)
BLOCK_ORDER = ["차단(외부)", "작업 항목", "오픈 무관", UNJUDGED]


def block_of(row):
    """원장 「오픈차단여부」. v1 원장(열 없음)은 미판정."""
    return (row.get("오픈차단여부") or "").strip() or UNJUDGED

# 상태 코드 → 260616 「진행상태」 어휘
STATUS_KO = {
    "done": "완료",
    "partial": "진행중",
    "todo": "미착수",
    "new": "신규발견",
    "미판정": UNJUDGED,
}

# 대분류 → 260616 「시스템」 (그룹핑 규칙 · 이 표가 유일한 근거)
SYSTEM_RULES = [
    ("생산·공정", "생산·MES"),
    ("운영자·", "관리자"),
    ("정산·통계", "관리자"),
    ("시스템·플랫폼", "시스템·플랫폼"),
]
SYSTEM_DEFAULT = "쇼핑몰"

# 게이트 이탈 조건 → 담당 배정 키워드 규칙 (03_페이즈일정 C·D·E 열)
GATE_OWNER_RULES = [
    ("인쇄개발", ["가격", "시뮬레이터", "권위값", "판형", "위젯", "옵션", "상품", "제본", "아크릴", "단가"]),
    ("쇼핑개발", ["order/register", "웹훅", "webhook", "주문", "장바구니", "결제 단계", "샵바이",
                  "optionInputs", "orderCnt", "종단", "스토어프론트", "알림"]),
]
GATE_OWNER_DEFAULT = "PM"


def load_ledger(path):
    with open(path, encoding="utf-8-sig", newline="") as fh:
        rows = list(csv.DictReader(fh))
    if not rows:
        sys.exit(f"[FAIL] 원장이 비어 있다: {path}")
    return rows


def system_of(major):
    for needle, name in SYSTEM_RULES:
        if major.startswith(needle) or needle == major:
            return name
    return SYSTEM_DEFAULT


def cell(row, key):
    return (row.get(key) or "").strip()


def parse_gates(path):
    """gates.md → [{id, title, date, goal, exits:[한 줄, ...]}]. 손으로 옮겨 적지 않는다."""
    if not os.path.exists(path):
        return []
    text = open(path, encoding="utf-8").read()

    # 「2. 게이트 한눈에」 블록에서 게이트별 한 줄 목표를 뽑는다.
    goals = {}
    for m in re.finditer(r"^(G\d)\s+\S+\s+(.*?)\s*─\s*(.+)$", text, flags=re.M):
        goals[m.group(1)] = m.group(3).strip()

    blocks = re.split(r"^### (G\d) — ", text, flags=re.M)
    gates = []
    for i in range(1, len(blocks), 2):
        gid, body = blocks[i], blocks[i + 1]
        head = body.splitlines()[0]
        m = re.search(r"\((\d{4}-\d{2}-\d{2})[^)]*\)", head)
        date = m.group(1) if m else ""
        title = re.sub(r"\s*\(.*", "", head).replace("★", "").strip()
        exits = []
        tail = re.split(r"\*\*이탈 조건[^*]*\*\*", body, maxsplit=1)
        if len(tail) == 2:
            for line in tail[1].splitlines():
                if line.startswith(("### ", "## ")):
                    break
                if re.match(r"^\d+\.\s", line.strip()):
                    one = re.sub(r"^\d+\.\s*", "", line.strip())
                    one = one.replace("`", "")          # 백틱은 벗기되 안 내용은 남긴다
                    one = re.sub(r"\*\*|\*", "", one).strip(" .·—")
                    one = re.split(r"\s+—\s+", one)[0]
                    one = re.split(r"\s\[확인처\]", one)[0].strip(" .·—")
                    if one:
                        exits.append(one[:90])
        gates.append({"id": gid, "title": title, "date": date,
                      "goal": goals.get(gid, "—"), "exits": exits})
    return gates


def owner_of_exit(text):
    for owner, keys in GATE_OWNER_RULES:
        if any(k in text for k in keys):
            return owner
    return GATE_OWNER_DEFAULT


# ── 서식 ────────────────────────────────────────────────────────────────
THIN = Side(style="thin", color=C_BORDER)
BOX = Border(left=THIN, right=THIN, top=THIN, bottom=THIN)


def style_header(ws, row, ncol):
    for c in range(1, ncol + 1):
        x = ws.cell(row=row, column=c)
        x.font = Font(name="Noto Sans", bold=True, color="FFFFFF", size=10)
        x.fill = PatternFill("solid", fgColor=C_PRIMARY)
        x.alignment = Alignment(horizontal="center", vertical="center", wrap_text=True)
        x.border = BOX


def style_title(ws, addr, size=13):
    ws[addr].font = Font(name="Noto Sans", bold=True, size=size, color=C_DARK)


def body_font(ws, r0, r1, ncol, zebra=False):
    for r in range(r0, r1 + 1):
        for c in range(1, ncol + 1):
            x = ws.cell(row=r, column=c)
            x.font = Font(name="Noto Sans", size=9)
            x.alignment = Alignment(vertical="top", wrap_text=True)
            x.border = BOX
            if zebra and r % 2 == 0:
                x.fill = PatternFill("solid", fgColor=C_ZEBRA)


def widths(ws, spec):
    for i, w in enumerate(spec, 1):
        ws.column_dimensions[get_column_letter(i)].width = w


# ── 시트별 ──────────────────────────────────────────────────────────────
def sheet_00(wb, ledger_path, stamp):
    ws = wb.create_sheet(SHEETS[0])
    ws["A1"] = "이 표 읽는 법 (실무진 안내)"
    style_title(ws, "A1")
    rows = [
        ("컬럼", "뜻", "값 설명"),
        ("No", "행 번호", "원장 정렬 순서 그대로. 원장의 std_id 는 「비고」 끝에 그대로 실려 있다"),
        ("시스템", "어느 시스템 일인가", "쇼핑몰 · 관리자 · 생산·MES · 시스템·플랫폼 (원장 「대분류」를 규칙표로 묶은 값)"),
        ("영역", "그 안 어디인가", "원장 「중분류」 그대로"),
        ("기능", "무엇을 만드나", "원장 「기능」 그대로"),
        ("우선순위", "오픈을 막느냐", "원장 「오픈차단여부」를 그대로 싣는다 — "
                                     "차단(외부)=우리 손으로 못 닫는다(상대 회신·심사 대기) · 작업 항목=짜면 닫힌다 · "
                                     "오픈 무관=10/6 에 없어도 문 연다 · 미판정. "
                                     "260616 의 P0/P1/P2 축은 원장에 없어 이 축으로 대체했다"),
        ("담당", "누가 만드나", "PM=기획·정책·계약 · 인쇄개발=상품·가격·옵션 · 쇼핑개발=쇼핑몰화면·주문·페이지빌더"),
        ("개발규모", "작업량 가늠", f"{UNJUDGED} — 원장에 규모 축이 없다. 지어내지 않는다"),
        ("진행상태", "지금 상태", "완료(done) · 진행중(partial) · 미착수(todo) · 신규발견(new) · 미판정"),
        ("Phase", "단계", f"{UNJUDGED} — 이 판에서 일정 축은 게이트다. 「03_페이즈일정」 시트의 G0~G5 를 보라"),
        ("확인·결정 필요사항 (선행조건)", "무엇이 되면 닫히나", "원장 「done_criteria(완료조건)」를 싣는다. 비었으면 미판정 (P1 이 504행 전건을 채운다)"),
        ("비고", "꼬리표", "신규발견 / 돈 / 주문 / 하위트랙 / std_id / legacy_id 를 「·」로 이어 붙인 것"),
        ("", "", ""),
        ("※ 260616 원본과 다른 점", "", "① 「우선순위」는 P0/P1/P2 가 아니라 원장의 「오픈차단여부」다. "
                                        "「개발규모·Phase」 2열은 원장에 축이 없어 미판정이다. "
                                        "② 「04_진행현황」의 첫 집계 축을 우선순위 대신 진행상태로 바꿨다(같은 이유). "
                                        "③ 「03_페이즈일정」은 Phase 1~3 대신 게이트 G0~G5 다."),
        (f"※ 원장: {os.path.relpath(ledger_path, REPO)}", "", f"※ 생성: {stamp} · 생성기 L6/build_xlsx.py"),
    ]
    for i, r in enumerate(rows, 3):
        for j, v in enumerate(r, 1):
            ws.cell(row=i, column=j, value=v)
    body_font(ws, 4, 3 + len(rows) - 1, 3)
    style_header(ws, 3, 3)
    widths(ws, [28, 20, 96])
    return ws


def sheet_01(wb, ledger, stamp):
    ws = wb.create_sheet(SHEETS[1])
    ws["A1"] = "후니프린팅 통합 IA — 역할 분담 & 진행현황 (D-34 재기준선)"
    style_title(ws, "A1")
    ws["A2"] = f"3인 체제 · PM / 인쇄개발 / 쇼핑개발 · 원장 {len(ledger)}행 · {stamp}"
    ws["A2"].font = Font(name="Noto Sans", size=9, color="666666")

    hdr = ["역할", "트랙", "핵심 책임범위", "담당 IA 영역", "현재 진행상황", "주요 산출물"]
    ws.append([])
    for j, v in enumerate(hdr, 1):
        ws.cell(row=4, column=j, value=v)

    roles = [
        ("PM", "기획·조율", "일정/우선순위, 운영정책 확정, 외부계약(PG·알림톡·NHN·EDICUS), 검수",
         "전 영역 의사결정·정책·계약", "결제수단 범위·PM 결정 6건이 G0 의 이탈 조건", "정책 확정서·계약 접수 근거·PM 결정 6건"),
        ("인쇄개발", "상품·가격·위젯", "상품·사이즈·소재·용지·가격 관리 + 옵션위젯 + 가격엔진",
         "운영자·상품가격 · 옵션·견적 · 생산·공정", "가격 결함 5건이 G2 의 이탈 조건", "권위값과 일치하는 가격·옵션위젯"),
        ("쇼핑개발", "페이지빌더·쇼핑", "상세페이지 빌더, 파일업로드, 주문전환, 장바구니·결제·주문운영",
         "상품·카탈로그 · 장바구니·주문 · 결제 · 배송 · 회원", "order/register·웹훅 소비자가 G2 의 이탈 조건", "스토어프론트·주문/결제 플로우"),
    ]
    counts = {}
    for r in ledger:
        counts.setdefault(cell(r, "담당"), []).append(r)

    def stat(owner):
        mine = [r for k, v in counts.items() if k.startswith(owner) for r in v]
        done = sum(1 for r in mine if cell(r, "상태") == "done")
        unj = sum(1 for r in mine if cell(r, "상태") == UNJUDGED)
        return f"{len(mine)}행 · 완료 {done} · 미판정 {unj}"

    for i, r in enumerate(roles, 5):
        for j, v in enumerate(r, 1):
            ws.cell(row=i, column=j, value=v)
        ws.cell(row=i, column=5, value=f"{stat(r[0])} — {r[4]}")

    body_font(ws, 5, 4 + len(roles), 6)
    style_header(ws, 4, 6)
    widths(ws, [12, 16, 40, 32, 40, 36])
    ws.cell(row=9, column=1, value="※ 「현재 진행상황」의 건수는 원장에서 기계 집계한 값이다(사람이 적은 값이 아니다).")
    return ws


def sheet_02(wb, ledger):
    ws = wb.create_sheet(SHEETS[2])
    for j, v in enumerate(IA_HEADERS, 1):
        ws.cell(row=1, column=j, value=v)
    for i, r in enumerate(ledger, 2):
        marks = []
        if cell(r, "상태") == "new":
            marks.append("신규발견")
        if cell(r, "돈여부") == "Y":
            marks.append("돈")
        if cell(r, "주문여부") == "Y":
            marks.append("주문")
        st = cell(r, "sub_track")
        if st and st != "-":
            marks.append(f"트랙:{st}")
        note = cell(r, "비고")
        if note:
            marks.append(note)
        marks.append(cell(r, "std_id"))
        lg = cell(r, "매핑legacy_id")
        if lg:
            marks.append(lg)
        dc = cell(r, "done_criteria") or UNJUDGED
        ws.append([
            i - 1,
            system_of(cell(r, "대분류")),
            cell(r, "중분류"),
            cell(r, "기능"),
            block_of(r),                     # 우선순위 ← 오픈차단여부 (L6b)
            cell(r, "담당"),
            UNJUDGED,
            STATUS_KO.get(cell(r, "상태"), cell(r, "상태")),
            UNJUDGED,
            dc,
            " · ".join(marks),
        ])
    body_font(ws, 2, len(ledger) + 1, 11, zebra=True)
    style_header(ws, 1, 11)
    widths(ws, [6, 14, 18, 46, 10, 12, 10, 12, 10, 52, 52])
    ws.freeze_panes = "A2"
    ws.auto_filter.ref = f"A1:K{len(ledger) + 1}"
    return ws


def sheet_03(wb, gates):
    ws = wb.create_sheet(SHEETS[3])
    ws["A1"] = "게이트별 진행 계획 (G0~G5 · 10/6 오픈 역산)"
    style_title(ws, "A1")
    ws["A2"] = "근거 = L5/O2/gates.md 를 기계 파싱. 이탈 조건 문장을 키워드 규칙표로 담당에 배정했다."
    ws["A2"].font = Font(name="Noto Sans", size=9, color="666666")

    hdr = ["Phase", "목표", "인쇄개발 범위", "쇼핑개발 범위", "PM 선행/조율"]
    for j, v in enumerate(hdr, 1):
        ws.cell(row=4, column=j, value=v)

    row = 5
    for g in gates:
        buckets = {"인쇄개발": [], "쇼핑개발": [], "PM": []}
        for e in g["exits"]:
            buckets[owner_of_exit(e)].append(e)
        ws.cell(row=row, column=1, value=f"{g['id']}\n{g['date']}\n{g['title']}")
        ws.cell(row=row, column=2, value=g["goal"] or "—")
        for j, owner in enumerate(["인쇄개발", "쇼핑개발", "PM"], 3):
            items = buckets[owner]
            ws.cell(row=row, column=j, value=("\n".join(f"· {t}" for t in items) if items else "—"))
        row += 1

    body_font(ws, 5, row - 1, 5)
    style_header(ws, 4, 5)
    widths(ws, [22, 40, 46, 46, 46])
    ws.cell(row=row + 1, column=1,
            value=f"※ 게이트 {len(gates)}개 · 이탈 조건 합계 {sum(len(g['exits']) for g in gates)}개. "
                  "조건 원문과 「확인처」는 L5/O2/gates.md 를 보라(요약은 첫 문장만).")
    return ws


def sheet_04(wb, ledger, gates):
    ws = wb.create_sheet(SHEETS[4])
    owners, states = [], []
    for r in ledger:
        o, s = cell(r, "담당"), STATUS_KO.get(cell(r, "상태"), cell(r, "상태"))
        if o not in owners:
            owners.append(o)
        if s not in states:
            states.append(s)
    order = ["완료", "진행중", "미착수", "신규발견", UNJUDGED]
    states = [s for s in order if s in states] + [s for s in states if s not in order]

    ws["A1"] = "① 담당 × 진행상태 (건수)"
    style_title(ws, "A1", 11)
    ws.cell(row=3, column=1, value="담당 \\ 진행상태")
    for j, s in enumerate(states, 2):
        ws.cell(row=3, column=j, value=s)
    ws.cell(row=3, column=len(states) + 2, value="합계")
    r0 = 4
    for i, o in enumerate(sorted(owners)):
        rr = r0 + i
        ws.cell(row=rr, column=1, value=o)
        for j, s in enumerate(states, 2):
            n = sum(1 for x in ledger
                    if cell(x, "담당") == o and STATUS_KO.get(cell(x, "상태"), cell(x, "상태")) == s)
            ws.cell(row=rr, column=j, value=n)
        ws.cell(row=rr, column=len(states) + 2, value=len([x for x in ledger if cell(x, "담당") == o]))
    rr = r0 + len(owners)
    ws.cell(row=rr, column=1, value="합계")
    for j, s in enumerate(states, 2):
        ws.cell(row=rr, column=j,
                value=sum(1 for x in ledger if STATUS_KO.get(cell(x, "상태"), cell(x, "상태")) == s))
    ws.cell(row=rr, column=len(states) + 2, value=len(ledger))
    style_header(ws, 3, len(states) + 2)
    body_font(ws, 4, rr, len(states) + 2)

    base = rr + 2
    ws.cell(row=base, column=1, value="② 대분류 × 진행상태 (건수)")
    style_title(ws, f"A{base}", 11)
    ws.cell(row=base + 2, column=1, value="대분류")
    for j, s in enumerate(states, 2):
        ws.cell(row=base + 2, column=j, value=s)
    ws.cell(row=base + 2, column=len(states) + 2, value="합계")
    majors = []
    for r in ledger:
        if cell(r, "대분류") not in majors:
            majors.append(cell(r, "대분류"))
    for i, mj in enumerate(majors):
        rr2 = base + 3 + i
        ws.cell(row=rr2, column=1, value=mj)
        for j, s in enumerate(states, 2):
            ws.cell(row=rr2, column=j,
                    value=sum(1 for x in ledger if cell(x, "대분류") == mj
                              and STATUS_KO.get(cell(x, "상태"), cell(x, "상태")) == s))
        ws.cell(row=rr2, column=len(states) + 2,
                value=len([x for x in ledger if cell(x, "대분류") == mj]))
    last = base + 2 + len(majors)
    style_header(ws, base + 2, len(states) + 2)
    body_font(ws, base + 3, last, len(states) + 2)

    b2 = last + 2
    ws.cell(row=b2, column=1, value="③ 돈·주문 플래그 (건수)")
    style_title(ws, f"A{b2}", 11)
    flags = [
        ("돈여부 Y (값이 틀리면 손해)", sum(1 for r in ledger if cell(r, "돈여부") == "Y")),
        ("주문여부 Y (주문 흐름에 닿음)", sum(1 for r in ledger if cell(r, "주문여부") == "Y")),
        ("돈·주문 둘 다 Y", sum(1 for r in ledger if cell(r, "돈여부") == "Y" and cell(r, "주문여부") == "Y")),
        ("done_criteria 빈칸", sum(1 for r in ledger if not cell(r, "done_criteria"))),
        ("상태 미판정", sum(1 for r in ledger if cell(r, "상태") == UNJUDGED)),
    ]
    for i, (k, v) in enumerate(flags):
        ws.cell(row=b2 + 2 + i, column=1, value=k)
        ws.cell(row=b2 + 2 + i, column=2, value=v)
    body_font(ws, b2 + 2, b2 + 1 + len(flags), 2)

    b3 = b2 + 3 + len(flags)
    ws.cell(row=b3, column=1, value="④ 게이트 이탈 조건 수")
    style_title(ws, f"A{b3}", 11)
    for i, g in enumerate(gates):
        ws.cell(row=b3 + 2 + i, column=1, value=f"{g['id']} {g['date']} {g['title']}")
        ws.cell(row=b3 + 2 + i, column=2, value=len(g["exits"]))
    body_font(ws, b3 + 2, b3 + 1 + len(gates), 2)

    b4 = b3 + 3 + len(gates)
    ws.cell(row=b4, column=1, value="⑤ 오픈차단여부 × 담당 (건수)")
    style_title(ws, f"A{b4}", 11)
    blocks = [b for b in BLOCK_ORDER if any(block_of(r) == b for r in ledger)]
    ws.cell(row=b4 + 2, column=1, value="담당 \\ 오픈차단여부")
    for j, b in enumerate(blocks, 2):
        ws.cell(row=b4 + 2, column=j, value=b)
    ws.cell(row=b4 + 2, column=len(blocks) + 2, value="합계")
    for i, o in enumerate(sorted(owners)):
        rr3 = b4 + 3 + i
        ws.cell(row=rr3, column=1, value=o)
        for j, b in enumerate(blocks, 2):
            ws.cell(row=rr3, column=j,
                    value=sum(1 for x in ledger if cell(x, "담당") == o and block_of(x) == b))
        ws.cell(row=rr3, column=len(blocks) + 2,
                value=len([x for x in ledger if cell(x, "담당") == o]))
    rr3 = b4 + 3 + len(owners)
    ws.cell(row=rr3, column=1, value="합계")
    for j, b in enumerate(blocks, 2):
        ws.cell(row=rr3, column=j, value=sum(1 for x in ledger if block_of(x) == b))
    ws.cell(row=rr3, column=len(blocks) + 2, value=len(ledger))
    style_header(ws, b4 + 2, len(blocks) + 2)
    body_font(ws, b4 + 3, rr3, len(blocks) + 2)

    b5 = rr3 + 2
    ws.cell(row=b5, column=1, value="⑥ 차단(외부) 전건 — 우리 손으로 못 닫는 것")
    style_title(ws, f"A{b5}", 11)
    for j, h in enumerate(["std_id", "기능", "담당", "돈·주문"], 1):
        ws.cell(row=b5 + 2, column=j, value=h)
    blocked = [r for r in ledger if block_of(r) == "차단(외부)"]
    for i, r in enumerate(blocked):
        rr4 = b5 + 3 + i
        ws.cell(row=rr4, column=1, value=cell(r, "std_id"))
        ws.cell(row=rr4, column=2, value=cell(r, "기능"))
        ws.cell(row=rr4, column=3, value=cell(r, "담당"))
        flags = [t for t, k in (("돈", "돈여부"), ("주문", "주문여부")) if cell(r, k) == "Y"]
        ws.cell(row=rr4, column=4, value="·".join(flags) or "—")
    style_header(ws, b5 + 2, 4)
    body_font(ws, b5 + 3, b5 + 2 + len(blocked), 4)

    widths(ws, [34] + [14] * max(len(states) + 1, len(blocks) + 1))
    ws.cell(row=b5 + 4 + len(blocked), column=1,
            value="※ 전부 원장에서 기계 집계. 260616 원본의 첫 집계 축은 「우선순위(P0/P1/P2)」였으나 "
                  "원장에 그 축이 없어 「진행상태」로 바꿨고, 오픈을 막는 축은 ⑤·⑥ 의 「오픈차단여부」가 대신한다.")
    return ws


def verify_against_template(out_path, template_path):
    """완료조건 ① — 시트명·02_IA마스터 열 구조를 260616 과 기계 대조."""
    ok = True
    tw = openpyxl.load_workbook(template_path)
    ow = openpyxl.load_workbook(out_path)
    print("\n[검산 ①] 시트명·열 구조 260616 대조")
    print(f"  260616 시트: {tw.sheetnames}")
    print(f"  260902 시트: {ow.sheetnames}")
    if tw.sheetnames != ow.sheetnames:
        ok = False
        print("  ✗ 시트명 불일치")
    else:
        print("  ✓ 시트명 5종 일치")
    th = [c.value for c in tw["02_IA마스터"][1]]
    oh = [c.value for c in ow["02_IA마스터"][1]]
    if th != oh:
        ok = False
        print(f"  ✗ 02_IA마스터 헤더 불일치\n    260616 {th}\n    260902 {oh}")
    else:
        print(f"  ✓ 02_IA마스터 11열 일치: {oh}")
    for name, ncol in [("00_읽는법", 3), ("01_역할정의", 6), ("03_페이즈일정", 5)]:
        t = tw[name].max_column
        o = ow[name].max_column
        mark = "✓" if o == ncol else "✗"
        if o != ncol:
            ok = False
        print(f"  {mark} {name} 열 수 260616={t} · 260902={o} (기대 {ncol})")
    return ok


def verify_no_invention(out_path, ledger):
    """완료조건 ⑥ — 02_IA마스터 행 수 = 원장 행 수, 기능 문자열 전건 원장 유래."""
    ow = openpyxl.load_workbook(out_path)
    ws = ow["02_IA마스터"]
    n = ws.max_row - 1
    print("\n[검산 ⑥] 원장에 없는 항목 창작 0")
    print(f"  02_IA마스터 데이터행 {n} · 원장 {len(ledger)} → {'✓ 일치' if n == len(ledger) else '✗ 불일치'}")
    src = {cell(r, "기능") for r in ledger}
    bad = [ws.cell(row=i, column=4).value for i in range(2, ws.max_row + 1)
           if ws.cell(row=i, column=4).value not in src]
    print(f"  원장에 없는 「기능」 문자열 {len(bad)}건 → {'✓' if not bad else '✗ ' + str(bad[:3])}")
    print("\n[검산 L6b] 우선순위 ← 오픈차단여부")
    pri = [ws.cell(row=i, column=5).value for i in range(2, ws.max_row + 1)]
    empty = sum(1 for v in pri if not (v or "").strip())
    want = [block_of(r) for r in ledger]
    print(f"  우선순위 빈칸 {empty}건 → {'✓' if not empty else '✗'}")
    print(f"  원장 오픈차단여부와 전건 일치 → {'✓' if pri == want else '✗'}")
    import collections as _c
    print(f"  분포 {dict(_c.Counter(pri))}")
    ok_b = (empty == 0 and pri == want)

    ids = {cell(r, "std_id") for r in ledger}
    missing = [i for i in range(2, ws.max_row + 1)
               if not any(t in (ws.cell(row=i, column=11).value or "") for t in ids)]
    print(f"  비고에 std_id 없는 행 {len(missing)}건 → {'✓' if not missing else '✗'}")
    return n == len(ledger) and not bad and not missing and ok_b


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--ledger", default=DEF_LEDGER, help="원장 CSV 경로 (P1 v2 오면 여기만 바꾼다)")
    ap.add_argument("--gates", default=DEF_GATES)
    ap.add_argument("--template", default=DEF_TEMPLATE)
    ap.add_argument("--out", default=DEF_OUT)
    a = ap.parse_args()

    ledger = load_ledger(a.ledger)
    gates = parse_gates(a.gates)
    stamp = _dt.datetime.now().strftime("%Y-%m-%d %H:%M")

    wb = openpyxl.Workbook()
    wb.remove(wb.active)
    sheet_00(wb, a.ledger, stamp)
    sheet_01(wb, ledger, stamp)
    sheet_02(wb, ledger)
    sheet_03(wb, gates)
    sheet_04(wb, ledger, gates)
    wb.save(a.out)

    print(f"[OK] {a.out}")
    print(f"  원장 {len(ledger)}행 · 게이트 {len(gates)}개 · 시트 {wb.sheetnames}")
    ok1 = verify_against_template(a.out, a.template)
    ok6 = verify_no_invention(a.out, ledger)
    tmpl_mtime = _dt.datetime.fromtimestamp(os.path.getmtime(a.template)).strftime("%Y-%m-%d %H:%M")
    print(f"\n[원본 무수정] 260616 mtime = {tmpl_mtime} (읽기만 했다)")
    sys.exit(0 if (ok1 and ok6) else 1)


if __name__ == "__main__":
    main()
