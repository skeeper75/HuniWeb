#!/bin/bash
# 공식 하나의 구성요소를 새 그릇으로 교체한다.
# [HARD] 새 행 추가 + 옛 행 삭제표시를 **한 번의 저장**으로 한다 — 두 번에 나누면
# 그 사이에 옛·새가 함께 합산되는 이중 합산 구간이 생긴다(키링 파일럿에서 실제로 겪음).
set -u
WT=/Users/innojini/Dev/HuniWeb/.claude/worktrees/t34
S=$WT/_workspace/price-setup/scripts
B=~/.claude/skills/gstack/browse/dist/browse
SP=/tmp/claude-501/-Users-innojini-Dev-HuniWeb/5a75057a-5718-4539-ad53-437e923e1e08/scratchpad
FRM=$1

PAIRS=$(python3 "$S/rw_plan.py" "$FRM")
[ -n "$PAIRS" ] || { echo "[$FRM] ★ 계획에 없음"; exit 1; }
BEFORE=$(python3 "$S/rw_count.py" "$FRM")
echo "[$FRM] 구성요소 ${BEFORE}개"

$B frame main >/dev/null 2>&1
$B goto "https://huni-admin.printly.co.kr/admin/price-formula-md/?frm=$FRM" >/dev/null 2>&1
sleep 3
$B frame "iframe#frame" >/dev/null 2>&1
python3 "$S/rw_js.py" "$PAIRS" > "$SP/swap.js"
RES=$($B eval "$SP/swap.js" 2>&1 | tail -1)
echo "[$FRM] 화면: $RES"
case "$RES" in *NO_*|*NOT_FOUND*) echo "[$FRM] ★ 중단 — 저장하지 않음"; exit 1;; esac

$B screenshot --viewport "$WT/_workspace/price-setup/screens/m4/w-$FRM.png" >/dev/null 2>&1
$B click "button[name=_save]" >/dev/null 2>&1   # ← 유일한 저장
sleep 4
python3 "$S/rw_verify.py" "$FRM" "$BEFORE"
