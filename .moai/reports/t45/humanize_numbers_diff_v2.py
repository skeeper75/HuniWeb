#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
humanize_numbers_diff_v2.py — v2 원고 수치 불변 검증 (plan §C-5 계약 승계)
- v2는 원고를 자연 문체로 직접 집필(편집쌍 없음)했으므로, 집필 완료 스냅샷(before)과
  최종본(after)의 숫자 토큰(`[0-9][0-9,.]*`) 다중집합을 비교해 수치 verbatim 불변을 기계 확인.
- 결과를 humanize-numbers-diff-v2-260908.txt 로 저장.
"""
import re
import pathlib
import collections

BASE = pathlib.Path(__file__).parent
BEFORE = BASE / "huni-staffbrief-260909-draft.before-humanize-v2.md"
AFTER = BASE / "huni-staffbrief-260909-draft.md"
DIFF_OUT = BASE / "humanize-numbers-diff-v2-260908.txt"

NUM = re.compile(r"[0-9][0-9,.]*")


def multiset(text):
    return collections.Counter(NUM.findall(text))


def main():
    b = BEFORE.read_text(encoding="utf-8")
    a = AFTER.read_text(encoding="utf-8")
    mb, ma = multiset(b), multiset(a)
    only_before = mb - ma
    only_after = ma - mb
    lines = [
        "# humanize 패스 전후 수치 diff — v2 (SPEC-STAFFBRIEF-001 / plan §C-5 승계)",
        f"- before: {BEFORE.name} ({len(b)} chars)",
        f"- after : {AFTER.name} ({len(a)} chars)",
        f"- 숫자 토큰 수: before {sum(mb.values())}개 / after {sum(ma.values())}개",
    ]
    if not only_before and not only_after:
        lines.append("- 결과: **PASS — 숫자 다중집합 완전 일치 (전후 수치 verbatim 불변)**")
    else:
        lines.append("- 결과: **FAIL — 차이 발생**")
        if only_before:
            lines.append(f"  - before에만: {dict(only_before)}")
        if only_after:
            lines.append(f"  - after에만: {dict(only_after)}")
    out = "\n".join(lines) + "\n"
    DIFF_OUT.write_text(out, encoding="utf-8")
    print(out)
    print(f"[saved] {DIFF_OUT}")


if __name__ == "__main__":
    main()
