#!/bin/bash
# 가격공식(MD) 화면에서 새 공식을 만들고 구성요소 1개를 건다. (묶음② 스티커 분할)
set -u
B=~/.claude/skills/gstack/browse/dist/browse
SP=/private/tmp/claude-501/-Users-innojini-Dev-HuniWeb/6db1b52b-b1ad-4492-8629-8e82eff59336/scratchpad
FRM=$1; NM=$2; COMP=$3; SEQ=$4
$B frame main >/dev/null 2>&1
$B goto "https://huni-admin.printly.co.kr/admin/price-formula-md/" >/dev/null 2>&1; sleep 2
cat > $SP/nf_click.js <<'JS'
(() => { const b=document.querySelector('#addBtn'); if(!b) return 'NO_ADD_BTN';
  for (const t of ['mousedown','mouseup','click']) b.dispatchEvent(new MouseEvent(t,{bubbles:true,cancelable:true,view:window}));
  return 'ok'; })()
JS
$B eval $SP/nf_click.js >/dev/null 2>&1; sleep 3
$B frame "iframe#frame" >/dev/null 2>&1
cat > $SP/nf_fill.js <<JS
(() => {
  const \$ = window.django && window.django.jQuery;
  if (!\$) return 'NO_JQUERY';
  const setTxt=(id,v)=>{const e=document.getElementById(id);
    Object.getOwnPropertyDescriptor(window.HTMLInputElement.prototype,'value').set.call(e,v);
    e.dispatchEvent(new Event('input',{bubbles:true})); e.dispatchEvent(new Event('change',{bubbles:true}));};
  setTxt('id_frm_cd','$FRM');
  setTxt('id_frm_nm','$NM');
  const sel=document.getElementById('id_tprcformulacomponents_set-0-comp_cd');
  if(!sel) return 'NO_SELECT';
  const cd='$COMP';
  if(!Array.from(sel.options).some(o=>o.value===cd)) sel.appendChild(new Option(cd,cd,true,true));
  \$(sel).val(cd).trigger('change');
  const ds=document.getElementById('id_tprcformulacomponents_set-0-disp_seq');
  Object.getOwnPropertyDescriptor(window.HTMLInputElement.prototype,'value').set.call(ds,'1');
  ds.dispatchEvent(new Event('input',{bubbles:true}));
  return document.getElementById('id_frm_cd').value+' | '+sel.value;
})()
JS
echo -n "  입력: "; $B eval $SP/nf_fill.js 2>&1 | tail -1
$B screenshot --viewport "_workspace/price-setup/screens/m4c/g2-${SEQ}a-$FRM-before-save.png" >/dev/null 2>&1
$B click "button[name=_save]" >/dev/null 2>&1; sleep 4
$B screenshot --viewport "_workspace/price-setup/screens/m4c/g2-${SEQ}b-$FRM-after-save.png" >/dev/null 2>&1
python3 -c "
import sys; sys.path.insert(0,'_workspace/price-setup/scripts'); import db
print('  라이브:', db.q(\"SELECT f.frm_cd||' / '||f.frm_nm||' / '||coalesce(fc.comp_cd,'(구성요소없음)') FROM t_prc_price_formulas f LEFT JOIN t_prc_formula_components fc ON fc.frm_cd=f.frm_cd WHERE f.frm_cd='$FRM'\", tuples=True).strip())"
