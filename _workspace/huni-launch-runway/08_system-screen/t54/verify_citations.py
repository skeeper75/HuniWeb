#!/usr/bin/env python3
# t54 근거 검산 — parts/*.md 안의 `path:line` 인용을 MES 저장소에 대조한다.
#
# 검사하는 것
#   (1) 인용한 경로가 저장소에서 유일하게 해소되는가
#       - 완전경로 / `.../꼬리경로` / 짧은 상대경로(예: Dac/OrderDac.cs) / 단일 파일명 순으로 해소
#       - 후보가 2개 이상이면 '모호' — 문서에서 경로를 늘려야 한다
#   (2) 그 줄번호가 파일 길이 안에 있는가
# 검사하지 않는 것
#   그 줄의 내용이 주장과 맞는가. 그건 사람이 본다(이 스크립트는 날조된 줄번호를 잡을 뿐이다).
import os, re, sys, glob
from collections import defaultdict

REPO = "/Users/innojini/Dev/TS.BackOffice.Huni"
HERE = os.path.dirname(os.path.abspath(__file__))
PARTS = os.path.join(HERE, "parts")
SKIP_DIRS = {"obj", "bin", ".git", "node_modules"}
EXTS = (".cs", ".sql", ".yaml", ".yml", ".sln", ".json", ".config", ".md", ".vdproj", ".csproj")

# 저장소 전체 파일 색인
index = []
for root, dirs, files in os.walk(REPO):
    dirs[:] = [d for d in dirs if d not in SKIP_DIRS]
    for fn in files:
        if fn.endswith(EXTS):
            index.append(os.path.relpath(os.path.join(root, fn), REPO))

by_name = defaultdict(list)
for rel in index:
    by_name[os.path.basename(rel)].append(rel)


def resolve(cited):
    """인용 경로 → 저장소 상대경로 후보 목록"""
    cited = cited.lstrip("/")
    if cited.startswith(".../"):
        cited = cited[4:]
    if cited in by_name.get(os.path.basename(cited), []) or os.path.isfile(os.path.join(REPO, cited)):
        return [cited]
    cands = [r for r in by_name.get(os.path.basename(cited), []) if r.endswith(cited)]
    if cands:
        return cands
    return by_name.get(os.path.basename(cited), [])


def linecount(path):
    with open(path, "rb") as f:
        return f.read().count(b"\n") + 1


CITE = re.compile(r"`([A-Za-z0-9_./\-]+\.(?:cs|sql|yaml|yml|sln|json|config|md|vdproj|csproj)):(\d+)(?:[-–](\d+))?`")

ok = 0
short = 0
problems = []
per_file = defaultdict(int)

for md in sorted(glob.glob(os.path.join(PARTS, "*.md"))):
    name = os.path.basename(md)
    text = open(md, encoding="utf-8").read()
    for m in CITE.finditer(text):
        cited, a, b = m.group(1), int(m.group(2)), m.group(3)
        per_file[name] += 1
        cands = resolve(cited)
        if not cands:
            problems.append(f"없음  {name}  {cited}:{a}")
            continue
        if len(cands) > 1:
            # 경로가 짧아 저장소에서 유일하게 지목되지 않는다 → 기계검산 대상 밖.
            # 추측해서 해소하지 않는다(엉뚱한 파일에 대고 '초과'를 내는 거짓 적발이 된다).
            short += 1
            continue
        rel = cands[0]
        n = linecount(os.path.join(REPO, rel))
        hi = int(b) if b else a
        if a < 1 or hi > n:
            problems.append(f"초과  {name}  {rel}:{a}-{hi}  (파일 {n}줄)")
            continue
        ok += 1

total = sum(per_file.values())
print(f"저장소 색인 파일 {len(index)}개")
print(f"인용 총계 {total} — 유일해소·통과 {ok} / 축약(검산불가) {short} / 문제 {len(problems)}")
for k in sorted(per_file):
    print(f"  {k}: {per_file[k]}건")
if problems:
    print("--- 문제 목록 ---")
    for p in problems:
        print("  " + p)
sys.exit(1 if problems else 0)
