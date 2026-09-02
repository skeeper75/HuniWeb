#!/bin/bash
# D-17 — 단가표 화면에서 사이즈가로 ↔ 사이즈세로 열을 맞바꾼다.
# 화면이 들고 있는 값을 그대로 쓰므로 적용일·단가·비고는 한 칸도 안 바뀐다.
# 쓰기는 [변경분 저장] 한 번뿐이다.
set -u
WT=/Users/innojini/Dev/HuniWeb/.claude/worktrees/t34
B=~/.claude/skills/gstack/browse/dist/browse
SP=/private/tmp/claude-501/-Users-innojini-Dev-HuniWeb/140f0705-6b77-44b5-9d66-2b083fc2b4a5/scratchpad
CODE=$1

$B frame main >/dev/null 2>&1
$B goto "https://huni-admin.printly.co.kr/admin/price-viewer/comp/$CODE/edit/" >/dev/null 2>&1
sleep 5
$B screenshot --viewport "$WT/_workspace/price-setup/screens/d17/$CODE-before.png" >/dev/null 2>&1

cat > $SP/tr.js <<'JS'
(() => {
  const h = Array.from(document.querySelectorAll('*')).find(e => e.jspreadsheet || e.jexcel);
  const inst = h && (h.jspreadsheet || h.jexcel);
  if (!inst) return 'NO_INSTANCE';
  const cols = (inst.options.columns || []).map(c => c.title);
  const want = ["적용일","사이즈가로(이하)","사이즈세로(이하)","수량(이상)","단가","비고"];
  if (JSON.stringify(cols) !== JSON.stringify(want)) return 'COLUMN_MISMATCH | ' + cols.join(',');
  const cur = inst.getData();
  const sw = cur.map(r => { const c = r.slice(); const t = c[1]; c[1] = c[2]; c[2] = t; return c; });
  inst.setData(sw);
  const g = inst.getData();
  const wmax = Math.max(...g.map(r => parseFloat(r[1])));
  const hmax = Math.max(...g.map(r => parseFloat(r[2])));
  return 'rows=' + g.length + ' 가로max=' + wmax + ' 세로max=' + hmax;
})()
JS
RES=$($B eval $SP/tr.js 2>&1 | tail -1)
echo "[$CODE] 그리드: $RES"
case "$RES" in *NO_INSTANCE*|*MISMATCH*) echo "[$CODE] ★ 중단 — 저장 안 함"; exit 1;; esac

cat > $SP/save.js <<'JS'
(() => {
  const b = Array.from(document.querySelectorAll('button,a'))
    .find(e => e.textContent.trim().startsWith('변경분 저장'));
  if (!b) return 'SAVE_BTN_NOT_FOUND';
  b.click(); return 'saved-click';
})()
JS
$B eval $SP/save.js 2>&1 | tail -1
sleep 6
$B screenshot --viewport "$WT/_workspace/price-setup/screens/d17/$CODE-after.png" >/dev/null 2>&1
python3 -c "
import sys; sys.path.insert(0,'$WT/_workspace/price-setup/scripts'); import db
print('  라이브:', db.q(\"SELECT count(*)::text||'행 가로 '||min(siz_width)::text||'~'||max(siz_width)::text||' 세로 '||min(siz_height)::text||'~'||max(siz_height)::text FROM t_prc_component_prices WHERE comp_cd='$CODE'\", tuples=True).strip())"
