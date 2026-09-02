#!/bin/bash
# D-17 — 상품 화면에서 직접입력 가로/세로 최대값을 권위대로 바로잡는다.
# 권위 = 상품마스터 사이즈 시트(「가로 x 세로」 명시).
# 쓰기는 화면의 [저장] 버튼 한 번뿐이다.
set -u
WT=/Users/innojini/Dev/HuniWeb/.claude/worktrees/t34
B=~/.claude/skills/gstack/browse/dist/browse
SP=/private/tmp/claude-501/-Users-innojini-Dev-HuniWeb/140f0705-6b77-44b5-9d66-2b083fc2b4a5/scratchpad
PRD=$1; WMAX=$2; HMAX=$3

$B frame main >/dev/null 2>&1
$B goto "https://huni-admin.printly.co.kr/admin/catalog/tprdproducts/$PRD/change/" >/dev/null 2>&1
sleep 4
$B screenshot --viewport "$WT/_workspace/price-setup/screens/d17/$PRD-before.png" >/dev/null 2>&1

cat > $SP/ns.js <<JS
(() => {
  const set = (n, v) => {
    const e = document.querySelector('input[name="'+n+'"]');
    if (!e) return 'FIELD_NOT_FOUND:' + n;
    Object.getOwnPropertyDescriptor(window.HTMLInputElement.prototype,'value').set.call(e, v);
    e.dispatchEvent(new Event('input',{bubbles:true}));
    e.dispatchEvent(new Event('change',{bubbles:true}));
    return null;
  };
  const before = ['nonspec_width_max','nonspec_height_max']
    .map(n => n + '=' + (document.querySelector('input[name="'+n+'"]')||{}).value).join(' ');
  const e1 = set('nonspec_width_max', '$WMAX');  if (e1) return e1;
  const e2 = set('nonspec_height_max', '$HMAX'); if (e2) return e2;
  const after = ['nonspec_width_max','nonspec_height_max']
    .map(n => n + '=' + document.querySelector('input[name="'+n+'"]').value).join(' ');
  return '전 ' + before + ' → 후 ' + after;
})()
JS
RES=$($B eval $SP/ns.js 2>&1 | tail -1)
echo "[$PRD] 폼: $RES"
case "$RES" in *NOT_FOUND*) echo "[$PRD] ★ 중단 — 저장 안 함"; exit 1;; esac

$B click "button[name=_save], input[name=_save]" >/dev/null 2>&1
sleep 5
$B screenshot --viewport "$WT/_workspace/price-setup/screens/d17/$PRD-after.png" >/dev/null 2>&1
python3 -c "
import sys; sys.path.insert(0,'$WT/_workspace/price-setup/scripts'); import db
print('  라이브:', db.q(\"SELECT '가로 '||nonspec_width_min::text||'~'||nonspec_width_max::text||' · 세로 '||nonspec_height_min::text||'~'||nonspec_height_max::text FROM t_prd_products WHERE prd_cd='$PRD'\", tuples=True).strip())"
