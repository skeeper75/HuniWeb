#!/usr/bin/env python3
"""
S5-plan · 오픈 계획서 엑셀(D2) 생성기 — R5 `build_xlsx_v4.py` 확장 복제 (2026-09-17 · 카드 t47)

[확장 내용] 기존 9시트(원장 654행 포함)는 그대로 두고 두 시트를 더한다:
    09_구간상태판   — status-28.csv(28구간 상태판)
    10_트랙체크리스트 — plan-rows.csv(최상위 + detail · D1 체크리스트 행과 같은 집합) + api-path 축
입력은 메인 체크아웃 절대경로에서 읽기만 한다. 출력은 워크트리 docs/huni/.
재실행: python3 -B build_xlsx_v4_plan.py

── 이하 원본 docstring ──
R5 · 엑셀 9시트 생성기 (D-20 재기준선 · 2026-09-16)

원장 v4 CSV(654행 · 28열) → `docs/huni/후니프린팅_통합IA_일정_역할분담_260916.xlsx`.

- `L6/build_xlsx.py` 의 디자인 토큰·서식 도우미를 옮겨 왔다(원본은 수정하지 않는다).
- 260902 · 260616 xlsx 는 읽기만 한다. 스키마는 의도적으로 바뀌었으므로 구조 대조는 하지 않는다.
- R3 산출(`gates-d20.md` · `weekly-plan.csv`)이 아직 없으면 대체 경로로 내려간다:
    · gates-d20.md 없음  → `L5/Q1/gates-v2.md` 로 대체하고 00 시트에 경고를 적는다.
    · weekly-plan.csv 없음 → 원장만으로 임시 배치를 만든다(05 시트에 「임시 배치」 표기).

재실행:
    python3 R/R5/build_xlsx_v4.py
    python3 R/R5/build_xlsx_v4.py --plan R/R3/weekly-plan.csv --gates R/R3/gates-d20.md
"""
import argparse
import collections
import csv
import datetime as _dt
import os
import re
import sys

import openpyxl
from openpyxl.styles import Alignment, Border, Font, PatternFill, Side
from openpyxl.utils import get_column_letter

# ── 후니 디자인 토큰 (huni-design-system v5 · L6 와 동일) ─────────────────
C_PRIMARY = "5538B6"
C_DARK = "351D87"
C_BORDER = "CACACA"
C_HEAD_BG = "EEEAF8"
C_ZEBRA = "F7F5FC"
C_RED_BG = "FDE2E2"
C_GREEN_BG = "E2F5E6"
C_GREY = "666666"

HERE = os.path.dirname(os.path.abspath(__file__))     # 워크트리 S/S5-plan
WT = os.path.abspath(os.path.join(HERE, *([".."] * 5)))
REPO = "/Users/innojini/Dev/HuniWeb"                  # 입력 원천(메인 체크아웃 · 읽기 전용)
REBASE = os.path.join(REPO, "_workspace", "huni-launch-runway", "07_rebaseline")
R_DIR = os.path.join(REBASE, "R")

DEF_LEDGER = os.path.join(R_DIR, "R2", "unified-ledger-v4.csv")
DEF_GATES = os.path.join(R_DIR, "R3", "gates-d20.md")
FALLBACK_GATES = os.path.join(REBASE, "L5", "Q1", "gates-v2.md")
DEF_PLAN = os.path.join(R_DIR, "R3", "weekly-plan.csv")
DEF_TRACE = os.path.join(R_DIR, "R1c", "meeting-trace.csv")
DEF_SCENARIOS = os.path.join(R_DIR, "R1d", "scenario-v2.csv")
DEF_OUT = os.path.join(WT, "docs", "huni", "후니프린팅_오픈계획서_260917.xlsx")
D1_HTML = os.path.join(WT, "docs", "huni", "후니프린팅_오픈계획서_260917.html")
STATUS28 = os.path.join(HERE, "status-28.csv")
PLAN_ROWS = os.path.join(HERE, "plan-rows.csv")
REF_260902 = os.path.join(REPO, "docs", "huni", "후니프린팅_통합IA_일정_역할분담_260902.xlsx")

SHEETS = ["00_읽는법", "01_역할정의", "02_IA마스터", "03_페이즈일정", "04_진행현황",
          "05_주차별실행판", "06_회의결정추적", "07_체크리스트", "08_변경이력",
          "09_구간상태판", "10_트랙체크리스트"]

UNJUDGED = "미판정"
OPEN_FREE = "오픈 무관"
BLOCKED = "차단(외부)"
BLOCK_ORDER = [BLOCKED, "작업 항목", OPEN_FREE, UNJUDGED]

STATUS_KO = {"done": "완료", "partial": "진행중", "todo": "미착수", "new": "신규발견", UNJUDGED: UNJUDGED}
STATUS_ORDER = ["완료", "진행중", "미착수", "신규발견", UNJUDGED]

ROLES = ["PM", "인쇄개발", "쇼핑개발", "실무운영", "외부"]
ROLE_ORDER = ROLES + [UNJUDGED]
ROLE_NAMES = {
    "PM": "신우진 (대표 결정 채훈희 대표)",
    "인쇄개발": "서희항 대표",
    "쇼핑개발": "김동학 대표",
    "실무운영": "최숙진 실장·김용기 부장",
    "외부": "외부 벤더(샵바이·이니시스·토스·NHN·MES 등)",
}
ROLE_DESC = {
    "PM": ("기획·조율", "일정·우선순위, 운영정책 확정, 외부 계약(PG·알림톡·NHN·EDICUS), 검수",
           "결정·확인 대기(이슈)가 주 분류 · 회의 미결 항목의 시한 관리"),
    "인쇄개발": ("webadmin·위젯·가격엔진·DB", "상품·사이즈·소재·용지·가격 관리 + 옵션 위젯 + 가격엔진 + 생산·공정",
                "가격 결함 교정과 2차 가격 테스트 검증이 오픈 전 핵심"),
    "쇼핑개발": ("스킨·페이지빌더·주문/결제 화면", "스토어프론트, 상세페이지 빌더, 파일업로드, 장바구니·결제·마이페이지",
                "order/register·웹훅 배선과 마이페이지 이관 메뉴가 오픈 전 핵심"),
    "실무운영": ("상품·콘텐츠·가격 세팅·검수·CS", "셀러어드민·webadmin 화면에서 값 넣기, 템플릿·알림톡·SMS, 상품 검수, CS 준비",
                "설정·검증 분류가 대부분 — 화면에서 확인한 것만 완료로 친다"),
    "외부": ("상대 회신", "샵바이·이니시스·토스·NHN·MES 벤더의 심사·회신·계약·승인",
            "우리 손으로 못 닫는 것 — 차단(외부) 등급의 주인"),
}

DAYS = {"반일": 0.5, "1일": 1.0, "2-3일": 2.5, "1주+": 5.0, UNJUDGED: 0.0}
DIFF_ORDER = {"상": 0, "중": 1, "하": 2, UNJUDGED: 3}

WEEKS = ["W38", "W39", "W40", "W41", "오픈후"]
WEEK_LABEL = {"W38": "W38 9/16-18", "W39": "W39 9/21-23", "W40": "W40 9/29-10/2",
              "W41": "W41 10/6", "오픈후": "오픈후"}
CAPACITY = {"W38": 3, "W39": 3, "W40": 4, "W41": 1}

# 대분류 → 「시스템」 (L6 SYSTEM_RULES 그대로)
SYSTEM_RULES = [("생산·공정", "생산·MES"), ("운영자·", "관리자"), ("정산·통계", "관리자"),
                ("시스템·플랫폼", "시스템·플랫폼")]
SYSTEM_DEFAULT = "쇼핑몰"

# 게이트 이탈 조건 → 담당 키워드 (L6 규칙 + 실무운영·외부 확장). 순서가 우선순위다.
GATE_OWNER_RULES = [
    ("외부", ["심사", "회신", "계약", "PG 승인", "NHN", "MID 신청", "승인 후"]),
    ("실무운영", ["설정", "템플릿", "알림톡", "SMS", "캡처", "계좌", "점검", "확인함", "정정본", "문구"]),
    ("인쇄개발", ["가격", "시뮬레이터", "권위값", "판형", "위젯", "옵션", "상품", "제본", "아크릴", "단가"]),
    ("쇼핑개발", ["order/register", "웹훅", "webhook", "주문", "장바구니", "결제 단계", "샵바이",
                  "optionInputs", "orderCnt", "종단", "스토어프론트", "시나리오"]),
]
GATE_OWNER_DEFAULT = "PM"
GATE_COLS = ["인쇄개발", "쇼핑개발", "실무운영", "PM", "외부"]

IA_HEADERS = ["No", "시스템", "영역", "기능", "우선순위", "분류", "난이도", "작업량", "담당역할", "담당실명",
              "진행상태", "주차", "선행의존", "체크방법", "확인처", "근거", "실측일시", "변경사유", "std_id", "비고"]


# ── 입력 ────────────────────────────────────────────────────────────────
def read_csv(path):
    with open(path, encoding="utf-8-sig", newline="") as fh:
        return list(csv.DictReader(fh))


def cell(row, key):
    return (row.get(key) or "").strip()


def block_of(row):
    return cell(row, "오픈차단여부") or UNJUDGED


def status_ko(row):
    s = cell(row, "상태")
    return STATUS_KO.get(s, s or UNJUDGED)


def role_of(row):
    return cell(row, "담당역할") or UNJUDGED


def is_remaining(row):
    """남은 일 = 상태≠done 그리고 오픈차단여부≠오픈 무관."""
    return cell(row, "상태") != "done" and block_of(row) != OPEN_FREE


def days_of(row):
    return DAYS.get(cell(row, "작업량구간") or UNJUDGED, 0.0)


def system_of(major):
    for needle, name in SYSTEM_RULES:
        if major.startswith(needle) or needle == major:
            return name
    return SYSTEM_DEFAULT


def evidence_of(row):
    return cell(row, "상태근거") or cell(row, "근거") or UNJUDGED


def is_new_row(row):
    return cell(row, "매핑legacy_id").startswith("NEW-")


def sort_ledger(ledger):
    majors = []
    for r in ledger:
        if cell(r, "대분류") not in majors:
            majors.append(cell(r, "대분류"))
    return sorted(ledger, key=lambda r: (block_of(r) == OPEN_FREE, majors.index(cell(r, "대분류")), cell(r, "std_id")))


def parse_gates(path):
    """gates-d20.md(### G# — 제목 (YYYY-MM-DD …)) 와 gates-v2.md(## n. G# — 제목 (M/D 요일)) 를 모두 읽는다."""
    if not os.path.exists(path):
        return []
    text = open(path, encoding="utf-8").read()
    goals = {}
    for m in re.finditer(r"^(G\d)\s+\S+\s+(.*?)\s*─\s*(.+)$", text, flags=re.M):
        goals[m.group(1)] = m.group(3).strip()
    blocks = re.split(r"^#{2,3} (?:\d+\.\s+)?(G\d) — ", text, flags=re.M)
    gates = []
    for i in range(1, len(blocks), 2):
        gid, body = blocks[i], blocks[i + 1]
        head = body.splitlines()[0]
        m = re.search(r"\((\d{4}-\d{2}-\d{2})", head)
        if m:
            date = m.group(1)
        else:
            m = re.search(r"\((\d{1,2})/(\d{1,2})", head)
            date = f"2026-{int(m.group(1)):02d}-{int(m.group(2)):02d}" if m else ""
        title = re.sub(r"\s*\(.*", "", head).replace("★", "").replace("**", "").strip()
        exits = []
        tail = re.split(r"(?:\*\*이탈 조건[^*\n]*\*\*|^### 이탈 조건.*$)", body, maxsplit=1, flags=re.M)
        if len(tail) == 2:
            for line in tail[1].splitlines():
                if line.startswith(("### ", "## ")):
                    break
                if re.match(r"^\d+\.\s", line.strip()):
                    one = re.sub(r"^\d+\.\s*", "", line.strip()).replace("`", "")
                    one = re.sub(r"\*\*|\*|★", "", one).strip(" .·—")
                    one = re.split(r"\s+—\s+", one)[0]
                    one = re.split(r"\s\[확인처\]", one)[0].strip(" .·—")
                    if one:
                        exits.append(one[:90])
        gates.append({"id": gid, "title": title, "date": date, "goal": goals.get(gid, "—"), "exits": exits})
    return gates


def owner_of_exit(text):
    for owner, keys in GATE_OWNER_RULES:
        if any(k in text for k in keys):
            return owner
    return GATE_OWNER_DEFAULT


def build_id_index(ledger):
    """std_id 와 매핑legacy_id(NEW-… 포함) → 원장 행."""
    idx = {}
    for r in ledger:
        idx.setdefault(cell(r, "std_id"), r)
        for lg in cell(r, "매핑legacy_id").split(";"):
            lg = lg.strip()
            if lg:
                idx.setdefault(lg, r)
    return idx


# ── 주차 배치 ────────────────────────────────────────────────────────────
def load_plan(path):
    if not os.path.exists(path):
        return None
    rows = read_csv(path)
    return {cell(r, "std_id"): r for r in rows}


def provisional_plan(ledger):
    """R3 확정 전 임시 배치. 대상 = 상태≠done. 오픈 무관→오픈후 · 차단(외부)→W38 외부 대기 · 나머지는 역할 레인 용량 채움."""
    plan = {}
    for role in ROLE_ORDER:
        mine = [r for r in ledger if role_of(r) == role and cell(r, "상태") != "done"]
        used = {w: 0.0 for w in CAPACITY}
        ordered = sorted(mine, key=lambda r: (
            -(1 if cell(r, "돈여부") == "Y" else 0) - (1 if cell(r, "주문여부") == "Y" else 0),
            DIFF_ORDER.get(cell(r, "난이도") or UNJUDGED, 3), cell(r, "std_id")))
        for r in ordered:
            sid = cell(r, "std_id")
            if block_of(r) == OPEN_FREE:
                plan[sid] = {"주차": "오픈후", "레인": role, "비고": "오픈 무관"}
                continue
            if block_of(r) == BLOCKED:
                plan[sid] = {"주차": "W38", "레인": role, "비고": "외부 대기"}
                continue
            d = days_of(r)
            placed = None
            for w in CAPACITY:
                if used[w] < CAPACITY[w]:
                    placed = w
                    used[w] += d
                    break
            if placed is None:
                plan[sid] = {"주차": "오픈후", "레인": role, "비고": "용량 초과(오픈 전 소화 불가 추정)"}
            else:
                plan[sid] = {"주차": placed, "레인": role, "비고": ""}
    return plan


# ── 서식 ────────────────────────────────────────────────────────────────
THIN = Side(style="thin", color=C_BORDER)
BOX = Border(left=THIN, right=THIN, top=THIN, bottom=THIN)


def style_header(ws, row, ncol, c0=1):
    for c in range(c0, c0 + ncol):
        x = ws.cell(row=row, column=c)
        x.font = Font(name="Noto Sans", bold=True, color="FFFFFF", size=10)
        x.fill = PatternFill("solid", fgColor=C_PRIMARY)
        x.alignment = Alignment(horizontal="center", vertical="center", wrap_text=True)
        x.border = BOX


def style_title(ws, addr, size=13):
    ws[addr].font = Font(name="Noto Sans", bold=True, size=size, color=C_DARK)


def style_note(ws, addr):
    ws[addr].font = Font(name="Noto Sans", size=9, color=C_GREY)


def body_font(ws, r0, r1, ncol, zebra=False, c0=1):
    for r in range(r0, r1 + 1):
        for c in range(c0, c0 + ncol):
            x = ws.cell(row=r, column=c)
            x.font = Font(name="Noto Sans", size=9)
            x.alignment = Alignment(vertical="top", wrap_text=True)
            x.border = BOX
            if zebra and r % 2 == 0:
                x.fill = PatternFill("solid", fgColor=C_ZEBRA)


def widths(ws, spec):
    for i, w in enumerate(spec, 1):
        ws.column_dimensions[get_column_letter(i)].width = w


def put_row(ws, row, values, c0=1):
    for j, v in enumerate(values, c0):
        ws.cell(row=row, column=j, value=v)


def put_table(ws, top, header, rows, zebra=False):
    """header 행 + rows. 마지막 행 번호를 돌려준다."""
    put_row(ws, top, header)
    for i, r in enumerate(rows, top + 1):
        put_row(ws, i, r)
    last = top + len(rows)
    style_header(ws, top, len(header))
    if rows:
        body_font(ws, top + 1, last, len(header), zebra=zebra)
    return last


def crosstab(ws, top, title, row_keys, col_keys, fn, row_label):
    """fn(rk, ck) → 건수. 합계 행·열 포함. 다음 빈 행 번호를 돌려준다."""
    ws.cell(row=top, column=1, value=title)
    style_title(ws, f"A{top}", 11)
    header = [row_label] + col_keys + ["합계"]
    rows = []
    for rk in row_keys:
        vals = [fn(rk, ck) for ck in col_keys]
        rows.append([rk] + vals + [sum(vals)])
    tot = [fn(rk, ck) for ck in col_keys for rk in row_keys]
    col_tot = [sum(fn(rk, ck) for rk in row_keys) for ck in col_keys]
    rows.append(["합계"] + col_tot + [sum(tot)])
    last = put_table(ws, top + 2, header, rows)
    return last + 2


# ── 시트 ────────────────────────────────────────────────────────────────
def sheet_00(wb, ctx):
    ws = wb.create_sheet(SHEETS[0])
    ws["A1"] = "이 표 읽는 법 (실무진 안내 · D-20 재기준선 2026-09-16 · 오픈 10/6 초점)"
    style_title(ws, "A1")
    ws["A2"] = f"생성 {ctx['stamp']} · 생성기 R/R5/build_xlsx_v4.py · 원장 {ctx['rel_ledger']} ({len(ctx['ledger'])}행)"
    style_note(ws, "A2")
    row = 4
    if ctx["warnings"]:
        ws.cell(row=row, column=1, value="※ 대체 입력 경고")
        style_title(ws, f"A{row}", 11)
        for w in ctx["warnings"]:
            row += 1
            ws.cell(row=row, column=1, value=w)
            ws.cell(row=row, column=1).fill = PatternFill("solid", fgColor=C_RED_BG)
            ws.merge_cells(start_row=row, start_column=1, end_row=row, end_column=3)
        row += 2

    common = [
        ("공통", "std_id", "행의 고유 번호. 9/2 판과 같은 행은 번호가 같다. 새로 발견한 행은 R2 병합에서 STD-* 로 발급했고 「비고」에 원래 NEW 번호가 남아 있다"),
        ("공통", "우선순위 (=오픈차단여부)", "차단(외부)=우리 손으로 못 닫는다(상대 회신·심사·승인 대기) · 작업 항목=우리가 하면 닫힌다 · 오픈 무관=10/6 에 없어도 문을 연다 · 미판정"),
        ("공통", "분류 (5종)", "개발=새로 만드는 것 · 수정=있는 기능의 결함 교정(가격 결함 등) · 이슈=결정·확인·외부 회신 대기(코드 아님) · 설정=셀러어드민·webadmin 화면에서 값만 넣으면 끝 · 검증=테스트·실측·대조"),
        ("공통", "난이도 (3종)", "상=새 시스템·외부 연동·설계 필요 · 중=있는 틀 안에서 만들기·교정 · 하=설정·문구·확인. 9/9 실무진 안내문에 매긴 값이 있으면 그 값을 우선했다"),
        ("공통", "작업량 (구간)", "반일 · 1일 · 2-3일 · 1주+ · 미판정 — 조율용 추정치이며 약속이 아니다. 합산할 때는 반일=0.5 · 1일=1 · 2-3일=2.5 · 1주+=5 · 미판정=0 으로 환산한다"),
        ("공통", "담당역할 · 담당실명", "역할 5종(PM · 인쇄개발 · 쇼핑개발 · 실무운영 · 외부) + 실명. 문서에 실명이 없어 기본값을 넣은 행은 「(기본배정)」이 붙어 있다"),
        ("공통", "진행상태", "완료(done · 화면에서 동작 확인) · 진행중(partial · 일부 동작) · 미착수(todo) · 신규발견(new) · 미판정"),
        ("공통", "남은 일", "상태가 완료가 아니고 우선순위가 「오픈 무관」이 아닌 행. 01·04·05·07 시트의 집계 분모다"),
        ("공통", "체크방법", "실무진이 그대로 따라 할 수 있는 한 문장 — 어느 화면(URL·메뉴)에서 무엇을 눌러 무엇이 보이면 완료"),
        ("공통", "확인처", "화면 · 파일 · API · 셀러어드민 · DB · 회의록 중 확인하는 장소"),
        ("공통", "근거", "파일:줄 또는 화면 URL @ 실측 시각(KST). 상태근거가 있으면 그것을, 없으면 원장 근거를 실었다"),
        ("공통", "주차", "근무일 기준. W38=9/16~18(3일) · W39=9/21~23(3일) · 추석 9/24~28 휴무 · W40=9/29~10/2(4일) · W41=10/6 오픈 당일(1일) · 오픈후"),
        ("01_역할정의", "총행 / 남은 일 / 분류별 / 난이도별 / 남은 작업량", "전부 원장에서 기계 집계. 「남은 작업량」은 위 환산으로 더한 조율용 추정(일)"),
        ("02_IA마스터", "시스템 · 영역 · 기능", "시스템=대분류를 4묶음(쇼핑몰·관리자·생산·MES·시스템·플랫폼)으로 접은 값 · 영역=중분류 · 기능=원장 그대로"),
        ("02_IA마스터", "정렬 · 색", "오픈 무관 행은 맨 아래. 그 위는 대분류 순서 → std_id. 차단(외부) 행은 연한 붉은색, 완료 행은 연한 녹색, 난이도 「상」은 굵게"),
        ("02_IA마스터", "주차", "R3 weekly-plan.csv 가 있을 때만 채운다. 없으면 빈칸(05 시트의 임시 배치를 보라)"),
        ("03_페이즈일정", "게이트 G0~G5 × 역할 5열", "이탈 조건 문장을 키워드 규칙으로 역할에 배정했다(외부 → 실무운영 → 인쇄개발 → 쇼핑개발 → 나머지 PM 순)"),
        ("04_진행현황", "크로스탭", "담당역할×진행상태 · 담당역할×분류 · 담당역할×난이도 · 대분류×진행상태 · 우선순위×담당역할 · 돈·주문 플래그 · 차단(외부) 전건 · 남은 일 총량"),
        ("05_주차별실행판", "레인 × 주차", "칸마다 「std_id 기능(작업량)」. R3 weekly-plan.csv 가 없으면 원장만으로 만든 임시 배치다 — 돈·주문 Y 먼저, 난이도 상→하 순으로 레인 용량(3/3/4/1일)을 채웠다"),
        ("06_회의결정추적", "9/15 회의 항목 89건", "회의 항목마다 원장 std_id 와 지금 상태·담당실명을 붙였다. 확정/미결 건수는 머리에"),
        ("07_체크리스트", "☐ 열", "인쇄해서 체크하는 칸. 1블록=남은 일 전건(std_id·기능·담당·주차·체크방법·확인처) · 2블록=시나리오 48건(등급·게이트·PG승인전가능·확인문장)"),
        ("08_변경이력", "9/2 판 대비", "변경사유가 적힌 행 + 갱신카드가 v3만이 아닌 행 + 새로 발견한 행(NEW-*). 「9/2 상태」는 v3 원장에서 읽었다"),
    ]
    ws.cell(row=row, column=1, value="열 뜻")
    style_title(ws, f"A{row}", 11)
    last = put_table(ws, row + 1, ["시트", "열", "뜻 · 값 설명"], [list(x) for x in common], zebra=True)

    row = last + 2
    ws.cell(row=row, column=1, value="9/2 판(260902)과 달라진 점 — 원장에서 계산한 숫자")
    style_title(ws, f"A{row}", 11)
    d = ctx["diff"]
    diff_rows = [
        ["행 수", f"{d['v3_rows']} → {d['total']}", "9/2 원장 v3 → 이번 원장 v4"],
        ["새로 발견한 행", str(d["new_rows"]), "매핑legacy_id 가 NEW-* 로 시작하는 행(R1a~R1e 카드가 발견 · R2 가 STD-* 발급)"],
        ["카드로 갱신된 기존 행", str(d["updated_rows"]), "갱신카드 ≠ v3만 인 기존 행"],
        ["미갱신(v3 그대로) 행", str(d["unchanged_rows"]), "갱신카드 = v3만"],
        ["변경사유가 적힌 행", str(d["reason_rows"]), "9/2 판과 다르게 적은 이유가 있는 행"],
        ["9/2 상태와 달라진 행", str(d["status_changed"]), "v3 상태 ≠ v4 상태 (기존 행만)"],
        ["담당 열", "3역할 1열 → 역할 5종 + 실명 2열", "PM · 인쇄개발 · 쇼핑개발 → + 실무운영 · 외부"],
        ["분류·난이도·작업량", "없음 → 5종 · 3종 · 구간", "9/2 판의 「개발규모·Phase」 미판정 2열을 대체"],
        ["일정 축", "게이트만 → 게이트 + 주차(근무일)", "05 시트 신설. 추석·대체휴일 반영"],
        ["시트", "5 → 9", "05 주차별실행판 · 06 회의결정추적 · 07 체크리스트 · 08 변경이력 신설"],
    ]
    last = put_table(ws, row + 1, ["항목", "값", "설명"], diff_rows)

    row = last + 2
    ws.cell(row=row, column=1, value="입력 원본")
    style_title(ws, f"A{row}", 11)
    src_rows = [[k, v, ""] for k, v in ctx["sources"]]
    put_table(ws, row + 1, ["입력", "경로(저장소 기준)", ""], src_rows)
    widths(ws, [22, 34, 100])
    return ws


def sheet_01(wb, ctx):
    ledger = ctx["ledger"]
    ws = wb.create_sheet(SHEETS[1])
    ws["A1"] = "역할 정의 · 역할별 남은 일 (D-20 재기준선 · 오픈 10/6)"
    style_title(ws, "A1")
    ws["A2"] = f"역할 5종 + 실명 · 원장 {len(ledger)}행 · {ctx['stamp']} · 건수·일수는 전부 원장에서 기계 집계"
    style_note(ws, "A2")
    cats = ["개발", "수정", "이슈", "설정", "검증", UNJUDGED]
    diffs = ["상", "중", "하", UNJUDGED]
    hdr = (["역할", "실명", "트랙", "핵심 책임범위", "이번 판에서 보는 것", "총행", "남은 일"]
           + [f"남은·{c}" for c in cats] + [f"남은·난이도{d}" for d in diffs] + ["남은 작업량(일·추정)"])
    rows = []
    for role in ROLE_ORDER:
        mine = [r for r in ledger if role_of(r) == role]
        if not mine:
            continue
        rem = [r for r in mine if is_remaining(r)]
        track, scope, focus = ROLE_DESC.get(role, ("—", "—", "담당역할이 정해지지 않은 행"))
        rows.append([role, ROLE_NAMES.get(role, "—"), track, scope, focus, len(mine), len(rem)]
                    + [sum(1 for r in rem if (cell(r, "분류") or UNJUDGED) == c) for c in cats]
                    + [sum(1 for r in rem if (cell(r, "난이도") or UNJUDGED) == d) for d in diffs]
                    + [round(sum(days_of(r) for r in rem), 1)])
    rem_all = [r for r in ledger if is_remaining(r)]
    rows.append(["합계", "", "", "", "", len(ledger), len(rem_all)]
                + [sum(1 for r in rem_all if (cell(r, "분류") or UNJUDGED) == c) for c in cats]
                + [sum(1 for r in rem_all if (cell(r, "난이도") or UNJUDGED) == d) for d in diffs]
                + [round(sum(days_of(r) for r in rem_all), 1)])
    last = put_table(ws, 4, hdr, rows)
    notes = [
        "※ 남은 일 = 상태≠완료 그리고 우선순위≠오픈 무관.",
        "※ 남은 작업량 환산: 반일=0.5 · 1일=1 · 2-3일=2.5 · 1주+=5 · 미판정=0 (일). 조율용 추정치이며 약속이 아니다.",
        "※ 실명 기본값(9/15 회의록·9/9 안내문): 쇼핑개발=김동학 대표 · 기술총괄(인쇄개발)=서희항 대표 · 실무운영=최숙진 실장·김용기 부장 · 대표 결정=채훈희 대표 · PM 실무=신우진. "
        "행별 실명은 02 시트 「담당실명」이 정본이다.",
    ]
    for i, n in enumerate(notes):
        ws.cell(row=last + 2 + i, column=1, value=n)
    widths(ws, [10, 30, 22, 44, 44, 7, 8] + [8] * (len(cats) + len(diffs)) + [12])
    ws.freeze_panes = "C5"
    return ws


def sheet_02(wb, ctx):
    ledger = ctx["sorted"]
    plan = ctx["plan"]
    ws = wb.create_sheet(SHEETS[2])
    put_row(ws, 1, IA_HEADERS)
    for i, r in enumerate(ledger, 2):
        marks = []
        if cell(r, "sub_track") not in ("", "-"):
            marks.append(f"트랙:{cell(r, 'sub_track')}")
        if cell(r, "돈여부") == "Y":
            marks.append("돈")
        if cell(r, "주문여부") == "Y":
            marks.append("주문")
        if cell(r, "비고"):
            marks.append(cell(r, "비고"))
        lg = cell(r, "매핑legacy_id")
        if lg:
            marks.append(f"legacy:{lg}")
        week = cell(plan.get(cell(r, "std_id"), {}), "주차") if plan is not None else ""
        put_row(ws, i, [
            i - 1, system_of(cell(r, "대분류")), cell(r, "중분류"), cell(r, "기능"), block_of(r),
            cell(r, "분류") or UNJUDGED, cell(r, "난이도") or UNJUDGED, cell(r, "작업량구간") or UNJUDGED,
            role_of(r), cell(r, "담당실명"), status_ko(r), week, cell(r, "선행의존"), cell(r, "체크방법"),
            cell(r, "확인처"), evidence_of(r), cell(r, "실측일시"), cell(r, "변경사유"), cell(r, "std_id"),
            " · ".join(marks),
        ])
    n = len(IA_HEADERS)
    body_font(ws, 2, len(ledger) + 1, n, zebra=True)
    for i, r in enumerate(ledger, 2):
        fill = None
        if block_of(r) == BLOCKED:
            fill = PatternFill("solid", fgColor=C_RED_BG)
        elif cell(r, "상태") == "done":
            fill = PatternFill("solid", fgColor=C_GREEN_BG)
        for c in range(1, n + 1):
            x = ws.cell(row=i, column=c)
            if fill is not None:
                x.fill = fill
            if cell(r, "난이도") == "상":
                x.font = Font(name="Noto Sans", size=9, bold=True)
    style_header(ws, 1, n)
    widths(ws, [5, 11, 14, 40, 10, 7, 7, 8, 9, 18, 9, 7, 18, 52, 12, 40, 14, 40, 13, 30])
    ws.freeze_panes = "E2"
    ws.auto_filter.ref = f"A1:{get_column_letter(n)}{len(ledger) + 1}"
    return ws


def sheet_03(wb, ctx):
    gates = ctx["gates"]
    ws = wb.create_sheet(SHEETS[3])
    ws["A1"] = "게이트별 진행 계획 (G0~G5 · 10/6 오픈 역산)"
    style_title(ws, "A1")
    ws["A2"] = (f"근거 = {ctx['rel_gates']} 를 기계 파싱. 이탈 조건 문장을 키워드 규칙표로 역할에 배정했다"
                "(외부 → 실무운영 → 인쇄개발 → 쇼핑개발 → 나머지 PM).")
    style_note(ws, "A2")
    hdr = ["게이트", "목표"] + [f"{c} 범위" if c != "PM" else "PM 선행/조율" for c in GATE_COLS]
    rows = []
    for g in gates:
        buckets = {c: [] for c in GATE_COLS}
        for e in g["exits"]:
            buckets[owner_of_exit(e)].append(e)
        rows.append([f"{g['id']}\n{g['date']}\n{g['title']}", g["goal"] or "—"]
                    + ["\n".join(f"· {t}" for t in buckets[c]) or "—" for c in GATE_COLS])
    last = put_table(ws, 4, hdr, rows)
    ws.cell(row=last + 2, column=1,
            value=f"※ 게이트 {len(gates)}개 · 이탈 조건 합계 {sum(len(g['exits']) for g in gates)}개. "
                  f"조건 원문과 「확인처」는 {ctx['rel_gates']} 를 보라(요약은 첫 문장만).")
    if ctx["gates_fallback"]:
        ws.cell(row=last + 3, column=1,
                value="※ 주의: R3 gates-d20.md 가 아직 없어 9/2 게이트 v2 의 날짜(9/4·9/11·9/18·9/22·9/30·10/6)를 그대로 실었다. "
                      "R3 가 D-20 기준으로 다시 놓으면 이 시트는 재생성된다.")
        ws.cell(row=last + 3, column=1).fill = PatternFill("solid", fgColor=C_RED_BG)
    widths(ws, [20, 34, 42, 42, 42, 42, 42])
    ws.freeze_panes = "B5"
    return ws


def sheet_04(wb, ctx):
    ledger = ctx["ledger"]
    ws = wb.create_sheet(SHEETS[4])
    roles = [r for r in ROLE_ORDER if any(role_of(x) == r for x in ledger)]
    states = [s for s in STATUS_ORDER if any(status_ko(x) == s for x in ledger)]
    cats = [c for c in ["개발", "수정", "이슈", "설정", "검증", UNJUDGED] if any((cell(x, "분류") or UNJUDGED) == c for x in ledger)]
    diffs = [d for d in ["상", "중", "하", UNJUDGED] if any((cell(x, "난이도") or UNJUDGED) == d for x in ledger)]
    blocks = [b for b in BLOCK_ORDER if any(block_of(x) == b for x in ledger)]
    majors = []
    for r in ledger:
        if cell(r, "대분류") not in majors:
            majors.append(cell(r, "대분류"))

    def cnt(pred):
        return sum(1 for x in ledger if pred(x))

    row = 1
    row = crosstab(ws, row, "① 담당역할 × 진행상태 (건수)", roles, states,
                   lambda r, s: cnt(lambda x: role_of(x) == r and status_ko(x) == s), "담당역할 \\ 진행상태")
    row = crosstab(ws, row, "② 담당역할 × 분류 (건수)", roles, cats,
                   lambda r, c: cnt(lambda x: role_of(x) == r and (cell(x, "분류") or UNJUDGED) == c), "담당역할 \\ 분류")
    row = crosstab(ws, row, "③ 담당역할 × 난이도 (건수)", roles, diffs,
                   lambda r, d: cnt(lambda x: role_of(x) == r and (cell(x, "난이도") or UNJUDGED) == d), "담당역할 \\ 난이도")
    row = crosstab(ws, row, "④ 대분류 × 진행상태 (건수)", majors, states,
                   lambda m, s: cnt(lambda x: cell(x, "대분류") == m and status_ko(x) == s), "대분류 \\ 진행상태")
    row = crosstab(ws, row, "⑤ 우선순위(오픈차단여부) × 담당역할 (건수)", blocks, roles,
                   lambda b, r: cnt(lambda x: block_of(x) == b and role_of(x) == r), "우선순위 \\ 담당역할")

    ws.cell(row=row, column=1, value="⑥ 돈·주문 플래그 (건수)")
    style_title(ws, f"A{row}", 11)
    flags = [
        ["돈여부 Y (값이 틀리면 손해)", cnt(lambda x: cell(x, "돈여부") == "Y")],
        ["주문여부 Y (주문 흐름에 닿음)", cnt(lambda x: cell(x, "주문여부") == "Y")],
        ["돈·주문 둘 다 Y", cnt(lambda x: cell(x, "돈여부") == "Y" and cell(x, "주문여부") == "Y")],
        ["돈 Y 이면서 남은 일", cnt(lambda x: cell(x, "돈여부") == "Y" and is_remaining(x))],
        ["주문 Y 이면서 남은 일", cnt(lambda x: cell(x, "주문여부") == "Y" and is_remaining(x))],
        ["상태 미판정", cnt(lambda x: cell(x, "상태") == UNJUDGED)],
        ["체크방법 빈칸", cnt(lambda x: not cell(x, "체크방법"))],
    ]
    last = put_table(ws, row + 2, ["항목", "건수"], flags)
    row = last + 2

    ws.cell(row=row, column=1, value="⑦ 차단(외부) 전건 — 우리 손으로 못 닫는 것")
    style_title(ws, f"A{row}", 11)
    blocked = [x for x in ledger if block_of(x) == BLOCKED]
    brows = [[cell(x, "std_id"), cell(x, "기능"), role_of(x), cell(x, "담당실명"), status_ko(x),
              "·".join(t for t, k in (("돈", "돈여부"), ("주문", "주문여부")) if cell(x, k) == "Y") or "—",
              cell(x, "선행의존"), cell(x, "체크방법")] for x in blocked]
    last = put_table(ws, row + 2, ["std_id", "기능", "담당역할", "담당실명", "진행상태", "돈·주문", "선행의존", "체크방법"], brows)
    row = last + 2

    ws.cell(row=row, column=1, value="⑧ 남은 일 총량 — 역할별 행 수와 추정 일수")
    style_title(ws, f"A{row}", 11)
    trows = []
    for r in roles:
        rem = [x for x in ledger if role_of(x) == r and is_remaining(x)]
        trows.append([r, len(rem), round(sum(days_of(x) for x in rem), 1),
                      sum(1 for x in rem if block_of(x) == BLOCKED),
                      sum(1 for x in rem if cell(x, "돈여부") == "Y" or cell(x, "주문여부") == "Y"),
                      sum(1 for x in rem if cell(x, "난이도") == "상")])
    rem_all = [x for x in ledger if is_remaining(x)]
    trows.append(["합계", len(rem_all), round(sum(days_of(x) for x in rem_all), 1),
                  sum(1 for x in rem_all if block_of(x) == BLOCKED),
                  sum(1 for x in rem_all if cell(x, "돈여부") == "Y" or cell(x, "주문여부") == "Y"),
                  sum(1 for x in rem_all if cell(x, "난이도") == "상")])
    last = put_table(ws, row + 2, ["담당역할", "남은 행", "추정 일수(환산)", "그중 차단(외부)", "그중 돈·주문 Y", "그중 난이도 상"], trows)
    ws.cell(row=last + 2, column=1,
            value="※ 전부 원장에서 기계 집계. 추정 일수 환산: 반일=0.5 · 1일=1 · 2-3일=2.5 · 1주+=5 · 미판정=0 — 조율용이며 약속이 아니다. "
                  "오픈 전 실근무일은 10일 + 오픈 당일 1일(R3 calendar.md).")
    widths(ws, [30, 40, 14, 20, 12, 12, 26, 52])
    return ws


def sheet_05(wb, ctx):
    ledger = ctx["ledger"]
    plan = ctx["plan"] if ctx["plan"] is not None else ctx["provisional"]
    provisional = ctx["plan"] is None
    by_id = {cell(r, "std_id"): r for r in ledger}
    ws = wb.create_sheet(SHEETS[5])
    ws["A1"] = "주차별 실행판 — 레인 × 주차 (근무일 기준 · 추석 9/24~28 · 대체휴일 10/5 제외)"
    style_title(ws, "A1")
    if provisional:
        ws["A2"] = ("임시 배치(R3 확정 전) — R3 weekly-plan.csv 가 아직 없어 원장만으로 만든 배치다. "
                    "대상=상태≠완료. 오픈 무관→오픈후 · 차단(외부)→W38「외부 대기」 · 나머지는 담당역할 레인에서 돈·주문 Y 먼저, 난이도 상→하 순으로 "
                    "레인 용량 W38 3일 / W39 3일 / W40 4일 / W41 1일을 채웠다. 넘치면 「오픈후(용량 초과)」.")
        ws["A2"].fill = PatternFill("solid", fgColor=C_RED_BG)
    else:
        ws["A2"] = f"근거 = {ctx['rel_plan']} (R3 확정). 칸 = 「std_id 기능(작업량)」."
    style_note(ws, "A2")

    weeks = list(WEEKS)
    for p in plan.values():
        w = cell(p, "주차")
        if w and w not in weeks:
            weeks.append(w)
    lanes = []
    for sid, p in plan.items():
        lane = cell(p, "레인") or role_of(by_id.get(sid, {}))
        if lane not in lanes:
            lanes.append(lane)
    lanes = [x for x in ROLE_ORDER if x in lanes] + [x for x in lanes if x not in ROLE_ORDER]

    grid = collections.defaultdict(list)
    for sid, p in plan.items():
        r = by_id.get(sid)
        if r is None:
            continue
        lane = cell(p, "레인") or role_of(r)
        w = cell(p, "주차") or "오픈후"
        mark = f" ⟨{cell(p, '비고')}⟩" if cell(p, "비고") in ("외부 대기", "오픈 무관") or cell(p, "비고").startswith("용량 초과") else ""
        grid[(lane, w)].append((sid, f"{sid} {cell(r, '기능')}({cell(r, '작업량구간') or UNJUDGED}){mark}"))

    hdr = ["레인"] + [WEEK_LABEL.get(w, w) for w in weeks] + ["레인 합계(행 · 추정일)"]
    rows = []
    for lane in lanes:
        vals = []
        for w in weeks:
            items = sorted(grid[(lane, w)])
            d = round(sum(days_of(by_id[s]) for s, _ in items), 1)
            head = f"[{len(items)}건 · {d}일]" if items else "—"
            vals.append(head + ("\n" + "\n".join(t for _, t in items) if items else ""))
        all_items = [s for w in weeks for s, _ in grid[(lane, w)]]
        rows.append([lane] + vals + [f"{len(all_items)}행 · {round(sum(days_of(by_id[s]) for s in all_items), 1)}일"])
    last = put_table(ws, 4, hdr, rows)
    for r in range(5, last + 1):
        ws.row_dimensions[r].height = None
    widths(ws, [12] + [46] * len(weeks) + [18])
    ws.freeze_panes = "B5"

    row = last + 3
    ws.cell(row=row, column=1, value="평면 목록 (필터용)")
    style_title(ws, f"A{row}", 11)
    flat_hdr = ["std_id", "기능", "레인", "주차", "담당역할", "담당실명", "우선순위", "분류", "난이도", "작업량", "돈·주문", "선행의존", "배치 비고"]
    flat = []
    for sid, p in plan.items():
        r = by_id.get(sid)
        if r is None:
            continue
        w = cell(p, "주차") or "오픈후"
        flat.append([sid, cell(r, "기능"), cell(p, "레인") or role_of(r), w, role_of(r), cell(p, "담당실명") or cell(r, "담당실명"),
                     block_of(r), cell(r, "분류") or UNJUDGED, cell(r, "난이도") or UNJUDGED, cell(r, "작업량구간") or UNJUDGED,
                     "·".join(t for t, k in (("돈", "돈여부"), ("주문", "주문여부")) if cell(r, k) == "Y") or "—",
                     cell(p, "선행의존") or cell(r, "선행의존"), cell(p, "비고")])
    flat.sort(key=lambda x: (weeks.index(x[3]) if x[3] in weeks else 99, ROLE_ORDER.index(x[2]) if x[2] in ROLE_ORDER else 99, x[0]))
    last = put_table(ws, row + 1, flat_hdr, flat, zebra=True)
    ws.auto_filter.ref = f"A{row + 1}:{get_column_letter(len(flat_hdr))}{last}"
    return ws


def sheet_06(wb, ctx):
    trace = ctx["trace"]
    idx = ctx["idx"]
    ws = wb.create_sheet(SHEETS[6])
    ws["A1"] = "9/15 정기미팅 결정 추적 — 회의 항목 ↔ 원장 행"
    style_title(ws, "A1")
    n_fix = sum(1 for t in trace if cell(t, "확정/미결") == "확정")
    n_open = sum(1 for t in trace if cell(t, "확정/미결") == "미결")
    ws["A2"] = (f"회의 항목 {len(trace)}건 · 확정 {n_fix} · 미결 {n_open} · 근거 {ctx['rel_trace']} · "
                "「원장 상태·담당실명」은 이번 원장 v4 에서 std_id 로 붙였다(NEW 번호는 R2 가 발급한 STD 로 해소)")
    style_note(ws, "A2")
    hdr = ["mtg_id", "주제", "확정/미결", "회의후여부", "내용", "담당실명(회의)", "시한", "std_id(원장)", "원장 진행상태", "원장 담당실명", "원장 우선순위", "매핑근거"]
    rows = []
    for t in trace:
        ids = [x.strip() for x in cell(t, "std_id_매핑").split(";") if x.strip()]
        resolved, states, names, blocks = [], [], [], []
        for i in ids:
            r = idx.get(i)
            if r is None:
                resolved.append(f"{i}(원장에 없음)")
                continue
            resolved.append(cell(r, "std_id") if cell(r, "std_id") == i else f"{cell(r, 'std_id')}(←{i})")
            states.append(status_ko(r))
            names.append(cell(r, "담당실명"))
            blocks.append(block_of(r))
        rows.append([cell(t, "mtg_id"), cell(t, "주제"), cell(t, "확정/미결"), cell(t, "회의후여부"), cell(t, "내용"),
                     cell(t, "담당실명"), cell(t, "시한"), "; ".join(resolved), "; ".join(states), "; ".join(names),
                     "; ".join(blocks), cell(t, "매핑근거")])
    last = put_table(ws, 4, hdr, rows, zebra=True)
    for i, t in enumerate(trace, 5):
        if cell(t, "확정/미결") == "미결":
            ws.cell(row=i, column=3).font = Font(name="Noto Sans", size=9, bold=True, color="B00020")
    widths(ws, [14, 16, 8, 8, 50, 18, 10, 24, 12, 22, 12, 44])
    ws.freeze_panes = "C5"
    ws.auto_filter.ref = f"A4:{get_column_letter(len(hdr))}{last}"
    return ws


def sheet_07(wb, ctx):
    ledger = ctx["sorted"]
    plan = ctx["plan"] if ctx["plan"] is not None else ctx["provisional"]
    provisional = ctx["plan"] is None
    ws = wb.create_sheet(SHEETS[7])
    ws["A1"] = "체크리스트 ① 남은 일 전건 — 인쇄해서 ☐ 에 표시한다"
    style_title(ws, "A1")
    rem = [r for r in ledger if is_remaining(r)]
    ws["A2"] = (f"남은 일 {len(rem)}행(상태≠완료 · 우선순위≠오픈 무관) · 주차는 "
                + ("임시 배치(R3 확정 전)" if provisional else ctx["rel_plan"]) + " · 체크방법은 원장 문장 그대로")
    style_note(ws, "A2")
    hdr = ["☐", "std_id", "기능", "담당역할", "담당실명", "주차", "우선순위", "체크방법", "확인처"]
    rows = []
    for r in rem:
        w = cell(plan.get(cell(r, "std_id"), {}), "주차")
        if provisional and w:
            w = f"{w}(임시)"
        rows.append(["", cell(r, "std_id"), cell(r, "기능"), role_of(r), cell(r, "담당실명"), w, block_of(r),
                     cell(r, "체크방법") or UNJUDGED, cell(r, "확인처")])
    last = put_table(ws, 4, hdr, rows, zebra=True)
    ws.auto_filter.ref = f"A4:{get_column_letter(len(hdr))}{last}"
    ws.freeze_panes = "D5"

    row = last + 3
    sc = ctx["scenarios"]
    ws.cell(row=row, column=1, value=f"체크리스트 ② 시나리오 {len(sc)}건 — 등급·게이트·PG 승인 전 가능 여부")
    style_title(ws, f"A{row}", 11)
    ws.cell(row=row + 1, column=1, value=f"근거 {ctx['rel_scenarios']} · 「실무진용 확인문장」이 통과 기준")
    style_note(ws, f"A{row + 1}")
    hdr2 = ["☐", "scn_id", "등급", "게이트", "단계", "PG승인전가능_v2", "실무진용 확인문장", "체크방법", "확인처"]
    rows2 = [["", cell(s, "scn_id"), cell(s, "등급"), cell(s, "게이트"), cell(s, "단계"), cell(s, "PG승인전가능_v2"),
              cell(s, "실무진용_확인문장"), cell(s, "체크방법"), cell(s, "확인처")] for s in sc]
    put_table(ws, row + 2, hdr2, rows2, zebra=True)
    widths(ws, [4, 13, 40, 9, 22, 10, 10, 60, 24])
    return ws


def sheet_08(wb, ctx):
    ledger = ctx["sorted"]
    v3 = ctx["v3"]
    ws = wb.create_sheet(SHEETS[8])
    ws["A1"] = "변경 이력 — 9/2 판(v3) 대비 이번 판(v4)"
    style_title(ws, "A1")
    changed = [r for r in ledger if (cell(r, "변경사유") or cell(r, "갱신카드") != "v3만") and not is_new_row(r)]
    new = [r for r in ledger if is_new_row(r)]
    ws["A2"] = (f"갱신된 기존 행 {len(changed)} · 새로 발견한 행 {len(new)} · 「9/2 상태」는 "
                f"{ctx['rel_v3']} 에서 std_id 로 읽었다")
    style_note(ws, "A2")
    hdr = ["std_id", "기능", "9/2 상태", "현재 상태", "상태 변화", "담당역할", "담당실명", "변경사유", "갱신카드", "실측일시"]
    rows = []
    for r in changed:
        old = v3.get(cell(r, "std_id"))
        old_s = STATUS_KO.get(cell(old, "상태"), cell(old, "상태")) if old else "(v3 에 없음)"
        new_s = status_ko(r)
        rows.append([cell(r, "std_id"), cell(r, "기능"), old_s, new_s, "변경" if old_s != new_s else "유지",
                     role_of(r), cell(r, "담당실명"), cell(r, "변경사유"), cell(r, "갱신카드"), cell(r, "실측일시")])
    last = put_table(ws, 4, hdr, rows, zebra=True)
    for i, r in enumerate(rows, 5):
        if r[4] == "변경":
            ws.cell(row=i, column=5).font = Font(name="Noto Sans", size=9, bold=True, color=C_DARK)
    ws.auto_filter.ref = f"A4:{get_column_letter(len(hdr))}{last}"
    ws.freeze_panes = "C5"

    row = last + 3
    ws.cell(row=row, column=1, value=f"새로 발견한 행 {len(new)}건 (매핑legacy_id 가 NEW-* · R2 가 STD 번호 발급)")
    style_title(ws, f"A{row}", 11)
    hdr2 = ["std_id", "원래 NEW 번호", "대분류", "기능", "현재 상태", "우선순위", "분류", "난이도", "담당역할", "담당실명", "근거", "갱신카드"]
    rows2 = [[cell(r, "std_id"), cell(r, "매핑legacy_id"), cell(r, "대분류"), cell(r, "기능"), status_ko(r), block_of(r),
              cell(r, "분류") or UNJUDGED, cell(r, "난이도") or UNJUDGED, role_of(r), cell(r, "담당실명"), evidence_of(r),
              cell(r, "갱신카드")] for r in new]
    put_table(ws, row + 1, hdr2, rows2, zebra=True)
    widths(ws, [13, 40, 12, 40, 10, 10, 10, 8, 10, 20, 44, 12])
    return ws


def sheet_09(wb, ctx):
    rows = read_csv(STATUS28)
    ws = wb.create_sheet(SHEETS[9])
    ws["A1"] = "28구간 상태판 — 구간마다 지금 어디까지 되어 있나"
    style_title(ws, "A1")
    ws["A2"] = f"{len(rows)}행 · 원천 status-28.csv · 상태 = 작동/부분/구현-미검증/없음/미착수 · 「작동」은 화면 근거가 있는 것만"
    style_note(ws, "A2")
    hdr = ["구간", "구간명", "분할", "시스템", "담당", "상태", "10/6 필수여부", "근거", "실측일시", "남은 일"]
    keys = ["구간", "구간명", "분할", "시스템", "담당", "status", "10/6_필수여부", "근거", "실측일시", "남은_일"]
    last = put_table(ws, 4, hdr, [[cell(r, k) for k in keys] for r in rows], zebra=True)
    ws.auto_filter.ref = f"A4:{get_column_letter(len(hdr))}{last}"
    ws.freeze_panes = "C5"
    widths(ws, [6, 30, 5, 34, 14, 11, 12, 60, 18, 60])
    return ws


PLAN_HEADERS = ["row_id", "구분", "트랙", "구간", "할 일", "std_id", "담당", "가장 이른 완료일(하한)", "소요 하한(일)",
                "1주+ 건수", "완료 증거", "체크 방법", "선행", "상태", "소유", "분류", "api-path", "api-evidence",
                "API 있는데 수동", "비고"]
PLAN_KEYS = ["row_id", "data_role", "track", "step", "title", "std_ids", "owner_name", "target_date", "effort_lb_days",
             "week_plus_cnt", "evidence", "check_method", "prereq", "status", "data_owner", "data_work", "api_path",
             "api_evidence", "forced_by_impl", "note"]


def sheet_10(wb, ctx):
    rows = read_csv(PLAN_ROWS)
    ws = wb.create_sheet(SHEETS[10])
    ws["A1"] = "트랙별 체크리스트 — 계획서(HTML) 체크리스트와 같은 행"
    style_title(ws, "A1")
    top = sum(1 for r in rows if cell(r, "data_role") == "top")
    ws["A2"] = (f"{len(rows)}행 = 최상위(top) {top} + 세부(detail) {len(rows) - top} · 소요 하한 = 원장 분류 개발·수정 행만 · "
                "가장 이른 완료일은 선행 관계만으로 계산한 하한 · api-path ∈ server-api / shop-api / admin-manual / none")
    style_note(ws, "A2")
    last = put_table(ws, 4, PLAN_HEADERS, [[cell(r, k) for k in PLAN_KEYS] for r in rows], zebra=True)
    for i, r in enumerate(rows, 5):
        if cell(r, "data_role") == "top":
            for c in range(1, len(PLAN_HEADERS) + 1):
                ws.cell(row=i, column=c).font = Font(name="Noto Sans", size=9, bold=True, color=C_DARK)
    ws.auto_filter.ref = f"A4:{get_column_letter(len(PLAN_HEADERS))}{last}"
    ws.freeze_panes = "F5"
    widths(ws, [12, 7, 5, 5, 44, 22, 12, 16, 9, 7, 36, 44, 20, 10, 6, 7, 11, 36, 7, 30])
    return ws


# ── 검산 ────────────────────────────────────────────────────────────────
def verify(out_path, ctx):
    ok = True
    ledger = ctx["ledger"]
    wb = openpyxl.load_workbook(out_path)
    print("\n== VERIFY ==")

    def check(cond, msg):
        nonlocal ok
        print(f"  [{'PASS' if cond else 'FAIL'}] {msg}")
        ok = ok and cond

    ws = wb["02_IA마스터"]
    n02 = ws.max_row - 1
    check(n02 == len(ledger), f"02 행 수 {n02} == 원장 {len(ledger)}")
    col = {h: i + 1 for i, h in enumerate(IA_HEADERS)}
    for key in ("분류", "난이도", "담당역할"):
        empty = sum(1 for i in range(2, ws.max_row + 1) if not (ws.cell(row=i, column=col[key]).value or "").strip())
        check(empty == 0, f"02 「{key}」 빈칸 {empty}건 (미판정은 허용)")
    ids02 = [ws.cell(row=i, column=col["std_id"]).value for i in range(2, ws.max_row + 1)]
    check(len(set(ids02)) == len(ids02), "02 std_id 유일")

    ws7 = wb["07_체크리스트"]
    rem_ids = [cell(r, "std_id") for r in ledger if is_remaining(r)]
    block1 = []
    for i in range(5, ws7.max_row + 1):
        v = ws7.cell(row=i, column=2).value
        if v is None or v == "":
            break
        block1.append(v)
    c = collections.Counter(block1)
    dup = [k for k, v in c.items() if v > 1]
    missing = [k for k in rem_ids if k not in c]
    extra = [k for k in c if k not in set(rem_ids)]
    check(not dup and not missing and not extra,
          f"07 ①블록 남은 일 {len(block1)}행 == 원장 남은 일 {len(rem_ids)} · 중복 {len(dup)} · 누락 {len(missing)} · 여분 {len(extra)}")

    ws6 = wb["06_회의결정추적"]
    n06 = sum(1 for i in range(5, ws6.max_row + 1) if ws6.cell(row=i, column=1).value)
    check(n06 == len(ctx["trace"]), f"06 행 수 {n06} == 회의 추적 {len(ctx['trace'])}")
    check(wb.sheetnames == SHEETS, f"시트명 {wb.sheetnames}")

    # [확장 검산] AC-LP-015(c) — 원장 654 · 트랙 체크리스트 행 수 == D1 의 top+detail 행 수
    check(n02 == 654, f"02 원장 시트 데이터 행 {n02} == 654")
    ws10 = wb["10_트랙체크리스트"]
    n10 = sum(1 for i in range(5, ws10.max_row + 1) if ws10.cell(row=i, column=1).value)
    html_text = open(D1_HTML, encoding="utf-8").read()
    d1_rows = html_text.count('data-role="top"') + html_text.count('data-role="detail"')
    check(n10 == d1_rows, f"10 트랙체크리스트 {n10}행 == D1 data-role top+detail {d1_rows}")
    ws9 = wb["09_구간상태판"]
    n09 = sum(1 for i in range(5, ws9.max_row + 1) if ws9.cell(row=i, column=1).value)
    check(n09 == len(read_csv(STATUS28)), f"09 구간상태판 {n09}행 == status-28.csv")

    print("\n== 시트 · 데이터 행 수 ==")
    for name in wb.sheetnames:
        print(f"  {name}: max_row={wb[name].max_row} · max_col={wb[name].max_column}")
    if os.path.exists(REF_260902):
        ref = openpyxl.load_workbook(REF_260902, read_only=True)
        print(f"\n[참조 · 읽기만] 260902 시트: {ref.sheetnames} (스키마가 의도적으로 바뀌어 구조 대조는 하지 않는다)")
        ref.close()
    print(f"\n== RESULT: {'ALL PASS' if ok else 'FAIL'} ==")
    return ok


# ── main ────────────────────────────────────────────────────────────────
def rel(path):
    return os.path.relpath(path, REPO) if path else "—"


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--ledger", default=DEF_LEDGER)
    ap.add_argument("--gates", default=DEF_GATES)
    ap.add_argument("--plan", default=DEF_PLAN)
    ap.add_argument("--trace", default=DEF_TRACE)
    ap.add_argument("--scenarios", default=DEF_SCENARIOS)
    ap.add_argument("--v3", default=os.path.join(REBASE, "L5", "Q1", "unified-ledger-v3.csv"), help="9/2 원장(08 변경이력의 이전 상태)")
    ap.add_argument("--out", default=DEF_OUT)
    a = ap.parse_args()

    ledger = read_csv(a.ledger)
    if not ledger:
        sys.exit(f"[FAIL] 원장이 비어 있다: {a.ledger}")
    warnings = []
    gates_path, gates_fallback = a.gates, False
    if not os.path.exists(gates_path):
        gates_path, gates_fallback = FALLBACK_GATES, True
        warnings.append(f"R3 게이트 파일이 없어 {rel(FALLBACK_GATES)} (9/2 게이트 v2) 로 대체했다: {rel(a.gates)} 없음")
    gates = parse_gates(gates_path)
    plan = load_plan(a.plan)
    if plan is None:
        warnings.append(f"R3 주차 배치가 없어 05·07 시트의 주차는 원장만으로 만든 임시 배치다: {rel(a.plan)} 없음")
    trace = read_csv(a.trace) if os.path.exists(a.trace) else []
    scenarios = read_csv(a.scenarios) if os.path.exists(a.scenarios) else []
    v3 = {cell(r, "std_id"): r for r in read_csv(a.v3)} if os.path.exists(a.v3) else {}
    if not v3:
        warnings.append(f"9/2 원장 v3 가 없어 08 시트의 「9/2 상태」를 채우지 못했다: {rel(a.v3)}")

    stamp = _dt.datetime.fromtimestamp(os.path.getmtime(a.ledger)).strftime("%Y-%m-%d %H:%M") + " (원장 파일 시각)"
    new_rows = sum(1 for r in ledger if is_new_row(r))
    old_rows = [r for r in ledger if not is_new_row(r)]
    diff = {
        "v3_rows": len(v3) if v3 else "—",
        "total": len(ledger),
        "new_rows": new_rows,
        "updated_rows": sum(1 for r in old_rows if cell(r, "갱신카드") != "v3만"),
        "unchanged_rows": sum(1 for r in old_rows if cell(r, "갱신카드") == "v3만"),
        "reason_rows": sum(1 for r in ledger if cell(r, "변경사유")),
        "status_changed": sum(1 for r in old_rows if cell(r, "std_id") in v3 and cell(v3[cell(r, "std_id")], "상태") != cell(r, "상태")),
    }
    ctx = {
        "ledger": ledger, "sorted": sort_ledger(ledger), "idx": build_id_index(ledger), "gates": gates,
        "gates_fallback": gates_fallback, "plan": plan, "provisional": provisional_plan(ledger),
        "trace": trace, "scenarios": scenarios, "v3": v3, "stamp": stamp, "warnings": warnings, "diff": diff,
        "rel_ledger": rel(a.ledger), "rel_gates": rel(gates_path), "rel_plan": rel(a.plan),
        "rel_trace": rel(a.trace), "rel_scenarios": rel(a.scenarios), "rel_v3": rel(a.v3),
        "sources": [("원장 v4", rel(a.ledger)), ("게이트", rel(gates_path) + (" (대체)" if gates_fallback else "")),
                    ("주차 배치", rel(a.plan) + ("" if plan is not None else " (없음 → 임시 배치)")),
                    ("회의 추적", rel(a.trace)), ("시나리오", rel(a.scenarios)), ("9/2 원장 v3", rel(a.v3)),
                    ("달력", rel(os.path.join(R_DIR, "R3", "calendar.md"))),
                    ("카드 명세", rel(os.path.join(R_DIR, "CARDS-R.md")))],
    }

    wb = openpyxl.Workbook()
    wb.remove(wb.active)
    for fn in (sheet_00, sheet_01, sheet_02, sheet_03, sheet_04, sheet_05, sheet_06, sheet_07, sheet_08, sheet_09, sheet_10):
        fn(wb, ctx)
    wb.save(a.out)
    print(f"[OK] {a.out}")
    print(f"  원장 {len(ledger)}행 · 게이트 {len(gates)}개({rel(gates_path)}) · 회의 {len(trace)} · 시나리오 {len(scenarios)} · "
          f"주차 배치 {'R3 확정' if plan is not None else '임시'}")
    for w in warnings:
        print(f"  [WARN] {w}")
    sys.exit(0 if verify(a.out, ctx) else 1)


if __name__ == "__main__":
    main()
