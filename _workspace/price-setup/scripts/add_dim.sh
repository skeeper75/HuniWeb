#!/bin/bash
# 이미 만든 그릇에 사용차원 하나를 화면 폼에서 더한다.
set -u
B=~/.claude/skills/gstack/browse/dist/browse
SP=/tmp/claude-501/-Users-innojini-Dev-HuniWeb/5a75057a-5718-4539-ad53-437e923e1e08/scratchpad
CODE=$1; DIMLABEL=$2
$B frame main >/dev/null 2>&1
$B goto https://huni-admin.printly.co.kr/admin/price-component-md/ >/dev/null 2>&1
$B fill "#srch" "$CODE" >/dev/null 2>&1; sleep 2
cat > $SP/open.js <<JS
(() => {
  const r = document.querySelector('.row[data-cd="$CODE"]');
  if (!r) return 'ROW_NOT_FOUND';
  for (const t of ['mousedown','mouseup','click'])
    r.dispatchEvent(new MouseEvent(t, {bubbles:true, cancelable:true, view:window}));
  return 'ok';
})()
JS
$B eval $SP/open.js >/dev/null 2>&1; sleep 3
$B frame "iframe#frame" >/dev/null 2>&1
cat > $SP/adddim.js <<JS
(() => {
  const el = Array.from(document.querySelectorAll('.udo-avail .udo-item'))
    .find(e => e.textContent.trim() === '$DIMLABEL');
  if (!el) return 'DIM_NOT_FOUND';
  for (const t of ['mousedown','mouseup','click'])
    el.dispatchEvent(new MouseEvent(t, {bubbles:true, cancelable:true, view:window}));
  return document.querySelector('#id_use_dims').value;
})()
JS
$B eval $SP/adddim.js 2>&1 | tail -1
$B screenshot --viewport "_workspace/price-setup/screens/m2/f45-$CODE-adddim.png" >/dev/null 2>&1
$B click "button[name=_save]" >/dev/null 2>&1; sleep 3
python3 -c "
import sys; sys.path.insert(0,'_workspace/price-setup/scripts'); import db
print(' 라이브 축:', db.q(\"SELECT replace(use_dims::text,',',' ') FROM t_prc_price_components WHERE comp_cd='$CODE'\", tuples=True).strip())"
