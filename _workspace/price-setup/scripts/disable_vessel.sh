#!/bin/bash
# M6 — 가격구성요소 화면에서 그릇 하나를 use_yn=N 으로 내린다.
# 단가행은 건드리지 않는다(삭제 금지·행 보존). 되돌림 = 같은 화면에서 Y 로 복귀.
# 쓰기는 화면의 [저장] 버튼 한 번뿐이다.
set -u
WT=/Users/innojini/Dev/HuniWeb/.claude/worktrees/t34
B=~/.claude/skills/gstack/browse/dist/browse
SP=/private/tmp/claude-501/-Users-innojini-Dev-HuniWeb/140f0705-6b77-44b5-9d66-2b083fc2b4a5/scratchpad
CODE=$1; SHOT=${2:-}

BEFORE=$(python3 -c "
import sys; sys.path.insert(0,'$WT/_workspace/price-setup/scripts'); import db
print(db.q(\"SELECT use_yn||'/'||(SELECT count(*) FROM t_prc_component_prices p WHERE p.comp_cd='$CODE')::text FROM t_prc_price_components WHERE comp_cd='$CODE'\", tuples=True).strip())")

$B frame main >/dev/null 2>&1
$B goto https://huni-admin.printly.co.kr/admin/price-component-md/ >/dev/null 2>&1; sleep 2
$B fill "#srch" "$CODE" >/dev/null 2>&1; sleep 2
cat > $SP/o.js <<JS
(() => { const r = document.querySelector('.row[data-cd="$CODE"]');
  if (!r) return 'ROW_NOT_FOUND';
  for (const t of ['mousedown','mouseup','click']) r.dispatchEvent(new MouseEvent(t,{bubbles:true,cancelable:true,view:window}));
  return 'ok'; })()
JS
OPEN=$($B eval $SP/o.js 2>&1 | tail -1)
case "$OPEN" in *NOT_FOUND*) echo "[$CODE] ★ 행 없음 — 중단"; exit 1;; esac
sleep 3
$B frame "iframe#frame" >/dev/null 2>&1
[ -n "$SHOT" ] && $B screenshot --viewport "$WT/_workspace/price-setup/screens/m6/$CODE-before.png" >/dev/null 2>&1

cat > $SP/n.js <<'JS'
(() => {
  const s = document.querySelector('select[name=use_yn]');
  if (!s) return 'FIELD_NOT_FOUND';
  const was = s.value;
  Object.getOwnPropertyDescriptor(window.HTMLSelectElement.prototype,'value').set.call(s,'N');
  s.dispatchEvent(new Event('change',{bubbles:true}));
  return was + ' -> ' + s.value;
})()
JS
RES=$($B eval $SP/n.js 2>&1 | tail -1)
case "$RES" in *NOT_FOUND*) echo "[$CODE] ★ use_yn 필드 없음 — 저장 안 함"; exit 1;; esac
$B click "button[name=_save]" >/dev/null 2>&1; sleep 4
[ -n "$SHOT" ] && $B screenshot --viewport "$WT/_workspace/price-setup/screens/m6/$CODE-after.png" >/dev/null 2>&1

AFTER=$(python3 -c "
import sys; sys.path.insert(0,'$WT/_workspace/price-setup/scripts'); import db
print(db.q(\"SELECT use_yn||'/'||(SELECT count(*) FROM t_prc_component_prices p WHERE p.comp_cd='$CODE')::text FROM t_prc_price_components WHERE comp_cd='$CODE'\", tuples=True).strip())")
echo "[$CODE] 폼 $RES · 라이브 $BEFORE -> $AFTER"
