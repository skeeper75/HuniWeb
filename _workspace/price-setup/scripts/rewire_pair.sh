#!/bin/bash
# 공식 하나의 구성요소 1개를 새 그릇으로 교체한다 — 새 행 추가 + 옛 행 DELETE 를 1회 저장.
set -u
B=~/.claude/skills/gstack/browse/dist/browse
SP=/private/tmp/claude-501/-Users-innojini-Dev-HuniWeb/6db1b52b-b1ad-4492-8629-8e82eff59336/scratchpad
S=_workspace/price-setup/scripts
FRM=$1; OLD=$2; NEW=$3
BEFORE=$(python3 -c "
import sys; sys.path.insert(0,'$S'); import db
print(db.q(\"SELECT count(*) FROM t_prc_formula_components WHERE frm_cd='$FRM'\", tuples=True).strip())")
$B frame main >/dev/null 2>&1
$B goto "https://huni-admin.printly.co.kr/admin/price-formula-md/?frm=$FRM" >/dev/null 2>&1; sleep 4
$B frame "iframe#frame" >/dev/null 2>&1
python3 "$S/rw_js.py" "[[\"$OLD\",\"$NEW\"]]" > "$SP/swap.js"
RES=$($B eval "$SP/swap.js" 2>&1 | tail -1)
echo "  [$FRM] 화면: $RES"
case "$RES" in *NO_*|*NOT_FOUND*|*LIMIT*) echo "  [$FRM] ★ 중단 — 저장 안 함"; exit 1;; esac
$B screenshot --viewport "_workspace/price-setup/screens/m4c/g2-poster-$FRM-before.png" >/dev/null 2>&1
$B click "button[name=_save]" >/dev/null 2>&1; sleep 4
$B screenshot --viewport "_workspace/price-setup/screens/m4c/g2-poster-$FRM-after.png" >/dev/null 2>&1
python3 -c "
import sys; sys.path.insert(0,'$S'); import db
print('  [$FRM] 구성요소 ${BEFORE} →', db.q(\"SELECT count(*) FROM t_prc_formula_components WHERE frm_cd='$FRM'\", tuples=True).strip(),
      '|', db.q(\"SELECT string_agg(comp_cd,' + ' ORDER BY disp_seq) FROM t_prc_formula_components WHERE frm_cd='$FRM'\", tuples=True).strip())"
