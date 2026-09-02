#!/bin/bash
# D-16 회수 — 단가표 화면에서 지정한 옵션코드 행만 걷어낸다.
# 나머지 행은 화면이 들고 있는 값을 그대로 다시 얹으므로 한 칸도 바뀌지 않는다.
# 쓰기는 화면의 [변경분 저장] 버튼 한 번뿐이다.
set -u
WT=/Users/innojini/Dev/HuniWeb/.claude/worktrees/t34
B=~/.claude/skills/gstack/browse/dist/browse
SP=/private/tmp/claude-501/-Users-innojini-Dev-HuniWeb/140f0705-6b77-44b5-9d66-2b083fc2b4a5/scratchpad
CODE=$1; DROP=$2   # DROP = 옵션코드 JSON 배열

BEFORE=$(python3 -c "
import sys; sys.path.insert(0,'$WT/_workspace/price-setup/scripts'); import db
print(db.q(\"SELECT count(*) FROM t_prc_component_prices WHERE comp_cd='$CODE'\", tuples=True).strip())")
echo "[$CODE] 라이브 현재 ${BEFORE}행"

$B frame main >/dev/null 2>&1
$B goto "https://huni-admin.printly.co.kr/admin/price-viewer/comp/$CODE/edit/" >/dev/null 2>&1
sleep 5
$B screenshot --viewport "$WT/_workspace/price-setup/screens/d16/$CODE-revert-before.png" >/dev/null 2>&1

cat > $SP/remove.js <<JS
(() => {
  const h = Array.from(document.querySelectorAll('*')).find(e => e.jspreadsheet || e.jexcel);
  const inst = h && (h.jspreadsheet || h.jexcel);
  if (!inst) return 'NO_INSTANCE';
  const cols = (inst.options.columns || []).map(c => c.title);
  const want = ["적용일","옵션코드","수량(이상)","단가","비고"];
  if (JSON.stringify(cols) !== JSON.stringify(want)) return 'COLUMN_MISMATCH | ' + cols.join(',');
  const drop = new Set($DROP);
  const cur = inst.getData();
  const kept = cur.filter(r => !drop.has(String(r[1])));
  const removed = cur.length - kept.length;
  if (removed !== drop.size) return 'DROP_COUNT_MISMATCH: 지울대상 ' + drop.size + ' · 실제 ' + removed;
  inst.setData(kept);
  return 'rows ' + cur.length + ' -> ' + inst.getData().length;
})()
JS
RES=$($B eval $SP/remove.js 2>&1 | tail -1)
echo "[$CODE] 그리드: $RES"
case "$RES" in *NO_INSTANCE*|*MISMATCH*) echo "[$CODE] ★ 중단 — 저장 안 함"; exit 1;; esac

cat > $SP/save.js <<'JS'
(() => {
  const b = Array.from(document.querySelectorAll('button,a'))
    .find(e => e.textContent.trim().startsWith('변경분 저장'));
  if (!b) return 'SAVE_BTN_NOT_FOUND';
  b.click();
  return 'saved-click';
})()
JS
$B eval $SP/save.js 2>&1 | tail -1
sleep 5
$B screenshot --viewport "$WT/_workspace/price-setup/screens/d16/$CODE-revert-after.png" >/dev/null 2>&1

python3 -c "
import sys; sys.path.insert(0,'$WT/_workspace/price-setup/scripts'); import db
print('[$CODE] 라이브 ${BEFORE}행 →', db.q(\"SELECT count(*) FROM t_prc_component_prices WHERE comp_cd='$CODE'\", tuples=True).strip(), '행')"
