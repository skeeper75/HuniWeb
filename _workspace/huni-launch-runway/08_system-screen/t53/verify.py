# -*- coding: utf-8 -*-
"""t53 검산 — 읽기전용. 대상 저장소를 열어 인용이 실재하는지 기계로 다시 센다.
P1 메모 인용 55건이 recheck.csv 에 전수 실림 / P2 판정 3분류(일치·부분·어긋남) 전수 /
P3 인용 파일·행이 실재 / P4 verdict.md 의 CRT 측 path:line 근거가 실재 /
P5 verdict.md 가 주장한 전수 수치(액션 카탈로그·CLI 호출 지점·USP_JOB_*·HotFolder DB 호출)를 재계산해 대조 /
P6 자격증명 값이 산출물에 전사되지 않았다."""
import csv, re, sys, pathlib, subprocess

HERE = pathlib.Path(__file__).resolve().parent
R = pathlib.Path("/Users/innojini/Dev/CRT.DigitalEdit.V2")
LABELS = {"일치", "부분", "어긋남"}
fail = []

rows = list(csv.DictReader(open(HERE / 'recheck.csv', encoding='utf-8')))

# P1
if len(rows) != 55:
    fail.append(f"P1 인용 건수 {len(rows)} != 55")
ids = [r['id'] for r in rows]
if ids != [f"C{i:02d}" for i in range(1, 56)]:
    fail.append("P1 id 연번 불일치")

# P2
bad = [r['id'] for r in rows if r['판정'] not in LABELS]
if bad:
    fail.append(f"P2 미분류 판정: {bad}")

# P3 — 인용 경로·행 실재
def lines_of(rel):
    p = R / rel
    if not p.exists():
        return None
    return p.read_text(encoding='utf-8-sig', errors='replace').splitlines()

checked = 0
for r in rows:
    ls = lines_of(r['인용 경로'])
    if ls is None:
        fail.append(f"P3 파일 부재 {r['id']}: {r['인용 경로']}")
        continue
    a, _, b = r['인용 행'].partition('-')
    hi = int(b) if b else int(a)
    checked += 1
    if hi > len(ls):
        fail.append(f"P3 행 초과 {r['id']}: {r['인용 경로']}:{r['인용 행']} (총 {len(ls)})")

# P4 — verdict.md 안의 CRT 측 path:line 근거
VD = (HERE / 'verdict.md').read_text(encoding='utf-8') if (HERE / 'verdict.md').exists() else ''
# 대상 저장소의 basename 색인 — 짧게 적은 인용도 해석해서 검사한다(유일할 때만).
BASE_IX = {}
for p in R.rglob('*'):
    if p.is_file() and p.suffix in ('.cs', '.config') and '/obj/' not in str(p) and '/bin/' not in str(p):
        BASE_IX.setdefault(p.name, []).append(p.relative_to(R).as_posix())
REF = re.compile(r'`([A-Za-z0-9_.][A-Za-z0-9_./]*\.(?:cs|config)):(\d+)(?:-(\d+))?`')
vchecked, vskip = 0, 0
for m in REF.finditer(VD):
    ref, hi = m.group(1), int(m.group(3) or m.group(2))
    ls = lines_of(ref)
    if ls is None:                      # 짧게 적힌 인용 → basename 으로 해석
        cands = BASE_IX.get(ref.split('/')[-1], [])
        if len(cands) != 1:
            vskip += 1                  # 해석 불가(동명 파일 다수) — 본문에서 전체 경로로 적어야 한다
            fail.append(f"P4 경로가 유일하게 해석되지 않음: {m.group(0)} (후보 {len(cands)})")
            continue
        ls = lines_of(cands[0])
    vchecked += 1
    if ls is None:
        fail.append(f"P4 파일 부재: {m.group(0)}")
    elif hi > len(ls):
        fail.append(f"P4 행 초과: {m.group(0)} (총 {len(ls)})")

# P5 — 전수 수치 재계산
def rg(pattern, *rels):
    n = 0
    for rel in rels:
        ls = lines_of(rel) or []
        n += sum(1 for t in ls if re.search(pattern, t))
    return n

SP, HF = "CRT.Yeolim.ServerProcess", "CRT.Yeolim.ServerProcess.HotFolder"
counts = {
    "액션 enum(ServerProcess)": rg(r'^\s*(None|, \w+)', f"{SP}/Common/ActionsSetList.cs"),
    "액션 enum(HotFolder)": rg(r'^\s*(None|, \w+)', f"{HF}/Common/ActionsSetList.cs"),
    "PitStopAction_ 설정(ServerProcess)": rg(r'PitStopAction_', f"{SP}/FoxConfigurationServerProcess.config"),
    "PitStopAction_ 설정(HotFolder)": rg(r'PitStopAction_', f"{HF}/FoxConfigurationServerProcessHotFolder.config"),
    "CLI -config 호출(살아있는 코드)": rg(r'args\.Append\(\$" -config', f"{SP}/Program.cs", f"{HF}/Program.cs"),
    "HotFolder CJobLog(주석 아닌 것)": sum(
        1 for t in (lines_of(f"{HF}/Program.cs") or [])
        if 'CJobLog' in t and not t.strip().startswith('//')),
    "SmartPreflight 대입(주석 아닌 것)": sum(
        1 for rel in (f"{SP}/Program.cs", f"{HF}/Program.cs")
        for t in (lines_of(rel) or [])
        if 'SmartPreflight.VariableSet' in t and not t.strip().startswith('//')),
    "USP_ 인용(저장소 전체)": sum(
        1 for p in R.rglob('*.cs')
        if '/obj/' not in str(p) and '/bin/' not in str(p)
        for t in p.read_text(encoding='utf-8-sig', errors='replace').splitlines()
        if 'USP_' in t),
    "USP_JOB 계열(주석 포함 인용)": sum(
        1 for p in R.rglob('*.cs')
        if '/obj/' not in str(p) and '/bin/' not in str(p)
        for t in p.read_text(encoding='utf-8-sig', errors='replace').splitlines()
        if re.search(r'USP_JOB', t)),
    "PDF 도구 exe 호출부": sum(
        1 for p in R.rglob('*.cs')
        if '/obj/' not in str(p) and '/bin/' not in str(p)
        and 'SaveAsErrorPdf' not in p.parts and 'FoxitSaveAs' not in p.parts
        for t in p.read_text(encoding='utf-8-sig', errors='replace').splitlines()
        if re.search(r'CommandLine\.Execute\([^)]*(SaveAsErrorPdf|PdfClearMargin|PdfResize|'
                     r'PdfBarcodeWriter|FoxitSaveAs|MergePdfs|AddMarginPdf|UnEmbededFontList)', t)),
}
EXPECT = {
    "액션 enum(ServerProcess)": 23, "액션 enum(HotFolder)": 26,
    "PitStopAction_ 설정(ServerProcess)": 22, "PitStopAction_ 설정(HotFolder)": 25,
    "CLI -config 호출(살아있는 코드)": 6,
    "HotFolder CJobLog(주석 아닌 것)": 0,
    "SmartPreflight 대입(주석 아닌 것)": 2,
    "USP_ 인용(저장소 전체)": 32,
    "USP_JOB 계열(주석 포함 인용)": 14,
    "PDF 도구 exe 호출부": 0,
}
for k, v in EXPECT.items():
    if counts[k] != v:
        fail.append(f"P5 {k}: 재계산 {counts[k]} != verdict 기재 {v}")

# P6 — 자격증명 값 유출 검사(산출물 전수)
# 패턴을 조각으로 조립한다 — 이 검사기 자신이 자기 리터럴에 걸리지 않게.
SECRET = re.compile("|".join(["AKI" + r"A[A-Z0-9]{12,}", "gks" + "dud", "G2cm" + "oMJ"]))
for p in sorted(HERE.glob('*')):
    if p.is_file() and p.name != pathlib.Path(__file__).name:
        if SECRET.search(p.read_text(encoding='utf-8', errors='replace')):
            fail.append(f"P6 자격증명 값이 산출물에 전사됨: {p.name}")

print(f"P3 인용 실재 검사 {checked}건 · P4 verdict 근거 검사 {vchecked}건")
print("P5 재계산: " + " · ".join(f"{k}={v}" for k, v in counts.items()))
verdicts = {}
for r in rows:
    verdicts[r['판정']] = verdicts.get(r['판정'], 0) + 1
print("판정 분포: " + " · ".join(f"{k} {v}" for k, v in sorted(verdicts.items())))
if fail:
    print("FAIL")
    for x in fail:
        print("  -", x)
    sys.exit(1)
print("PASS P1~P6")
