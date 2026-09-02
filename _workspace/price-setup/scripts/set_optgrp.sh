#!/bin/bash
# 이미 만든 그릇의 opt_cd 축에 옵션그룹 스코프(opt_grp:)를 화면 폼에서 지정한다. (D-14 보정)
set -u
B=~/.claude/skills/gstack/browse/dist/browse
SP=/private/tmp/claude-501/-Users-innojini-Dev-HuniWeb/6db1b52b-b1ad-4492-8629-8e82eff59336/scratchpad
CODE=$1; GRP=$2; SEQ=$3
$B frame main >/dev/null 2>&1
$B goto https://huni-admin.printly.co.kr/admin/price-component-md/ >/dev/null 2>&1
$B fill "#srch" "$CODE" >/dev/null 2>&1; sleep 2
cat > $SP/o.js <<JS
(() => { const r = document.querySelector('.row[data-cd="$CODE"]');
  if (!r) return 'ROW_NOT_FOUND';
  for (const t of ['mousedown','mouseup','click']) r.dispatchEvent(new MouseEvent(t,{bubbles:true,cancelable:true,view:window}));
  return 'ok'; })()
JS
echo -n "  열기: "; $B eval $SP/o.js 2>&1 | tail -1; sleep 3
$B frame "iframe#frame" >/dev/null 2>&1
cat > $SP/p.js <<JS
(() => {
  const btn = document.querySelector('.udo-sel .udo-item .udo-ss[data-dim="opt_cd"] .udo-ss-btn');
  if (!btn) return 'BTN_NOT_FOUND';
  btn.click();
  const q = document.querySelector('.udo-ss-pan .udo-ss-q');
  if (!q) return 'PANEL_NOT_OPEN';
  Object.getOwnPropertyDescriptor(window.HTMLInputElement.prototype,'value').set.call(q,'$GRP');
  q.dispatchEvent(new Event('input',{bubbles:true}));
  const opts = document.querySelectorAll('.udo-ss-pan .udo-ss-opt');
  if (opts.length !== 1) return 'AMBIGUOUS_OR_NONE:' + opts.length;
  for (const t of ['mousedown','mouseup','click']) opts[0].dispatchEvent(new MouseEvent(t,{bubbles:true,cancelable:true,view:window}));
  return document.querySelector('#id_use_dims').value; })()
JS
echo -n "  지정: "; $B eval $SP/p.js 2>&1 | tail -1
$B screenshot --viewport "_workspace/price-setup/screens/m4b/d14-${SEQ}a-$CODE-before-save.png" >/dev/null 2>&1
$B click "button[name=_save]" >/dev/null 2>&1; sleep 4
$B screenshot --viewport "_workspace/price-setup/screens/m4b/d14-${SEQ}b-$CODE-after-save.png" >/dev/null 2>&1
python3 -c "
import sys; sys.path.insert(0,'_workspace/price-setup/scripts'); import db
print('  라이브:', db.q(\"SELECT use_dims::text FROM t_prc_price_components WHERE comp_cd='$CODE'\", tuples=True).strip())"
