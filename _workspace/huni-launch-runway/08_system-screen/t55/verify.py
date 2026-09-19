#!/usr/bin/env python3
"""facts.csv 에 쓴 집계 숫자를 재계산해 검산한다."""
import json, os

here = os.path.dirname(os.path.abspath(__file__))
inv = json.load(open(os.path.join(here, "inventory.json")))
api = json.load(open(os.path.join(here, "apidiff.json")))
common = sorted(set(inv["yeolim"]) & set(inv["huni"]))

yf_tot = hf_tot = yl = hl = same = diff = only_y = only_h = 0
for p in common:
    yf, hf = inv["yeolim"][p]["files"], inv["huni"][p]["files"]
    yf_tot += len(yf); hf_tot += len(hf)
    yl += inv["yeolim"][p]["line_total"]; hl += inv["huni"][p]["line_total"]
    both = set(yf) & set(hf)
    same += sum(1 for f in both if yf[f]["md5"] == hf[f]["md5"])
    diff += sum(1 for f in both if yf[f]["md5"] != hf[f]["md5"])
    only_y += len(set(yf) - set(hf)); only_h += len(set(hf) - set(yf))

print("F-04 공통9 .cs 파일수      Y=%d H=%d" % (yf_tot, hf_tot))
print("F-05 공통9 .cs 총줄수      Y=%d H=%d" % (yl, hl))
print("F-06 같은이름·내용동일     %d" % same)
print("F-07 같은이름·내용다름     %d" % diff)
print("F-08 한쪽에만 있는 파일    열림만=%d 후니만=%d" % (only_y, only_h))

ty = th = my = mh = oty = oth = 0
for p in common:
    d = api[p]
    ty += d["TYPE"]["both"] + len(d["TYPE"]["only_yeolim"])
    th += d["TYPE"]["both"] + len(d["TYPE"]["only_huni"])
    my += d["MEMBER"]["both"] + len(d["MEMBER"]["only_yeolim"])
    mh += d["MEMBER"]["both"] + len(d["MEMBER"]["only_huni"])
    oty += len(d["TYPE"]["only_yeolim"]); oth += len(d["TYPE"]["only_huni"])
print("F-12 공개 타입수           Y=%d H=%d" % (ty, th))
print("F-13 공개 멤버수           Y=%d H=%d" % (my, mh))
print("F-14 한쪽에만 있는 공개타입 열림만=%d 후니만=%d" % (oty, oth))
