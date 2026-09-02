#!/bin/bash
# 가격뷰어 화면에서 상품에 새 가격공식을 새 적용일 행으로 건다. (옛 행 보존)
set -u
B=~/.claude/skills/gstack/browse/dist/browse
SP=/private/tmp/claude-501/-Users-innojini-Dev-HuniWeb/6db1b52b-b1ad-4492-8629-8e82eff59336/scratchpad
PRD=$1; FRM=$2
$B frame main >/dev/null 2>&1
$B goto "https://huni-admin.printly.co.kr/admin/price-viewer/" >/dev/null 2>&1; sleep 2
$B fill "#qv-q" "$PRD" >/dev/null 2>&1; sleep 2
cat > $SP/b_open.js <<JS
(() => { const r=document.querySelector('[data-cd="$PRD"]');
  if(!r) return 'ROW_NOT_FOUND';
  for (const t of ['mousedown','mouseup','click']) r.dispatchEvent(new MouseEvent(t,{bubbles:true,cancelable:true,view:window}));
  return 'ok'; })()
JS
echo -n "  열기: "; $B eval $SP/b_open.js 2>&1 | tail -1; sleep 3
cat > $SP/b_pick.js <<JS
(() => {
  const k=document.getElementById('src-kind');
  const fv=Array.from(k.options).find(o=>/공식/.test(o.textContent));
  k.value=fv.value; k.dispatchEvent(new Event('change',{bubbles:true}));
  const inp=document.querySelector('input.ss-input[placeholder*="공식"]');
  Object.getOwnPropertyDescriptor(window.HTMLInputElement.prototype,'value').set.call(inp,'$FRM');
  inp.dispatchEvent(new Event('input',{bubbles:true}));
  const opts=Array.from(inp.closest('.addrow').querySelectorAll('.ss-opt')).filter(o=>o.dataset.v==='$FRM');
  if(opts.length!==1) return 'OPT_N='+opts.length;
  for (const t of ['mousedown','mouseup','click']) opts[0].dispatchEvent(new MouseEvent(t,{bubbles:true,cancelable:true,view:window}));
  return inp.value+' | 적용일 '+document.getElementById('src-ymd').value;
})()
JS
echo -n "  선택: "; $B eval $SP/b_pick.js 2>&1 | tail -1
$B screenshot --viewport "_workspace/price-setup/screens/m4c/g2-bind-$PRD-before.png" >/dev/null 2>&1
cat > $SP/b_add.js <<'JS'
(() => { const inp=document.querySelector('input.ss-input[placeholder*="공식"]');
  const btn=Array.from(inp.closest('.addrow').querySelectorAll('button')).find(b=>b.textContent.trim()==='추가');
  if(!btn) return 'NO_ADD_BTN';
  for (const t of ['mousedown','mouseup','click']) btn.dispatchEvent(new MouseEvent(t,{bubbles:true,cancelable:true,view:window}));
  return 'clicked'; })()
JS
$B eval $SP/b_add.js >/dev/null 2>&1; sleep 4
$B screenshot --viewport "_workspace/price-setup/screens/m4c/g2-bind-$PRD-after.png" >/dev/null 2>&1
python3 -c "
import sys; sys.path.insert(0,'_workspace/price-setup/scripts'); import db
print('  라이브:', db.q(\"SELECT string_agg(frm_cd||'@'||apply_bgn_ymd,' | ' ORDER BY apply_bgn_ymd) FROM t_prd_product_price_formulas WHERE prd_cd='$PRD'\", tuples=True).strip())"
