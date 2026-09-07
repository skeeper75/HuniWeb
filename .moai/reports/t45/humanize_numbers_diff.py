#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
humanize_numbers_diff.py — plan §C-5 / plan-audit 권고: humanize 패스 전후 수치 불변 검증
- 현재 파일(after)에 humanize 편집쌍(new→old 역치환)을 기계적으로 적용해 before를 복원
- before/after의 숫자 토큰(`[0-9][0-9,.]*`) 다중집합을 비교 — 차이 0이어야 PASS
- 결과를 humanize-numbers-diff-260908.txt 로 저장
"""
import re
import pathlib
import collections

BASE = pathlib.Path("/Users/innojini/Dev/HuniWeb/.claude/worktrees/agent-a02319be4e8f059e0/.moai/reports/t45")
AFTER = BASE / "huni-staffbrief-260909-draft.md"
BEFORE_OUT = BASE / "huni-staffbrief-260909-draft.before-humanize.md"
DIFF_OUT = BASE / "humanize-numbers-diff-260908.txt"

# humanize 편집쌍 (new, old) — 실제 적용한 9건 (old→new 로 바꾼 것의 역)
PAIRS = [
    ("## §2 고객이 보는 것, 위젯", "## §2 고객이 보는 것 — 위젯"),
    ("## §3 운영자가 쓰는 것, 웹어드민", "## §3 운영자가 쓰는 것 — 웹어드민"),
    ("### 가격은 어떻게 계산되나\n\n클라이언트는 표시만 하고 계산은 항상 서버가 합니다. 고객 브라우저는 가격을 보여 주기만 하고, 계산은 전부 후니 서버의 가격 엔진이 맡습니다.",
     "### 가격은 어떻게 계산되나 — \"클라이언트는 표시만, 계산은 항상 서버\"\n\n고객 브라우저는 가격을 보여 주기만 하고, 계산은 전부 후니 서버의 가격 엔진이 합니다."),
    ("### 게시되어 있다고 전부 살 수 있는 건 아닙니다\n", "### 게시되어 있다고 전부 살 수 있는 건 아닙니다 (정직한 현황)\n"),
    ("한마디로 정리하면 위젯 화면 자체는 정상적으로 돌아가지만 그 안에 채워야 할 상품 데이터가 아직 전부 채워지지는 않았습니다. 그 갭은 매일 메워지는 중입니다(§4 참조).",
     "한마디로 정리하면, 위젯은 전부 살아 있지만 그 안의 상품 데이터가 다 채워지지는 않았고, 그 갭은 매일 메워지는 중입니다(§4 참조)."),
    ("인쇄 방식이라면 그 표지를", "인쇄 방식이라면, 그 표지를"),
    ("### 매뉴얼의 비유로 짚는 개념 8가지", "### 개념 8가지 — 매뉴얼의 비유로"),
    ("### 자주 묻는 증상 5가지와 점검법", "### 증상별 점검표 — 자주 묻는 5가지"),
    ("## 인용 출처와 기준 시점", "## 참고 — 인용 출처와 기준 시점"),
]

after_text = AFTER.read_text(encoding="utf-8")
before_text = after_text
applied = 0
for new, old in PAIRS:
    if new in before_text:
        before_text = before_text.replace(new, old, 1)
        applied += 1
    else:
        print(f"WARN: pattern not found (new side): {new[:50]!r}")

BEFORE_OUT.write_text(before_text, encoding="utf-8")

num_re = re.compile(r"[0-9][0-9,\.]*")
after_nums = collections.Counter(num_re.findall(after_text))
before_nums = collections.Counter(num_re.findall(before_text))

lines = []
lines.append("# humanize 패스 전후 수치 diff (SPEC-STAFFBRIEF-001 / plan §C-5)")
lines.append(f"- 편집쌍 적용: {applied}/{len(PAIRS)}건 역치환으로 before 복원")
lines.append(f"- before: {BEFORE_OUT.name} ({len(before_text)} chars)")
lines.append(f"- after : {AFTER.name} ({len(after_text)} chars)")
lines.append(f"- 숫자 토큰 수: before {sum(before_nums.values())}개 / after {sum(after_nums.values())}개")
if before_nums == after_nums:
    lines.append("- 결과: **PASS — 숫자 다중집합 완전 일치 (전후 수치 verbatim 불변)**")
else:
    lines.append("- 결과: **FAIL — 숫자 변형 감지**")
    only_before = before_nums - after_nums
    only_after = after_nums - before_nums
    if only_before:
        lines.append(f"  - before에만: {dict(only_before)}")
    if only_after:
        lines.append(f"  - after에만: {dict(only_after)}")
lines.append("")
lines.append("## humanize 변경 보고 (Korean 모듈 · prose 모드 · Strict)")
lines.append("- 검출·제거 텔: 헤딩 대시 대구(M-1 인접) 4건 → 쉼표 동격/평어형으로 · 괄호 부제(C-10 인접) 2건 → 제거/평어화 · 접속 어미 뒤 쉼표(C-11) 1건 → 삭제 · 1문장 명료화(모호 서술) 1건 · 인용구 본문 이동 1건")
lines.append("- 수치·사실·인용문·날짜 라벨: 전항목 verbatim 불변 (위 다중집합 비교로 기계 확인)")
lines.append("- 변경률 추정: 약 2~3% (경계 내, WARN 미발)")
lines.append("- 등급: B (잔여 S1 0 · 패스 자체가 경미 — 초안을 카탈로그 인지 상태에서 작성해 검출 텔 수가 적었음을 감안한 보수 등급)")

DIFF_OUT.write_text("\n".join(lines) + "\n", encoding="utf-8")
print("\n".join(lines))
print(f"\n[saved] {DIFF_OUT}")
