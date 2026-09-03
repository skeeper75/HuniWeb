#!/bin/bash
# 트랙 B P6 ④ — 가격구성요소 이름만 권위 name 으로 바꾸고, 옛 이름을 비고에 보존한다.
# 코드·유형·차원·단가행은 건드리지 않는다. 쓰기는 폼 [저장] 한 번뿐이다.
set -u
WT=/Users/innojini/Dev/HuniWeb/.claude/worktrees/t34
PS=$WT/_workspace/price-setup
B=~/.claude/skills/gstack/browse/dist/browse
SP=/private/tmp/claude-501/-Users-innojini-Dev-HuniWeb/e0a41dab-8e55-4275-8dd7-0e92be112401/scratchpad
mkdir -p "$SP" "$PS/screens/p6"
CODE=$1; NEWNM=$2

BEFORE=$(python3 -c "
import sys; sys.path.insert(0,'$PS/scripts'); import db
print(db.q(\"SELECT comp_nm || '\t' || coalesce(note,'') FROM t_prc_price_components WHERE comp_cd='$CODE'\", tuples=True).strip())")
OLDNM=$(printf '%s' "$BEFORE" | cut -f1)
OLDNOTE=$(printf '%s' "$BEFORE" | cut -f2)
echo "[$CODE] 현재 이름: $OLDNM"
[ "$OLDNM" = "$NEWNM" ] && { echo "[$CODE] 이미 권위 name — 건너뜀"; exit 0; }

$B frame main >/dev/null 2>&1
$B goto https://huni-admin.printly.co.kr/admin/price-component-md/ >/dev/null 2>&1
sleep 3
bash $PS/scripts/wa_login.sh
$B goto https://huni-admin.printly.co.kr/admin/price-component-md/ >/dev/null 2>&1
sleep 3
$B fill "#srch" "$CODE" >/dev/null 2>&1; sleep 2
cat > $SP/open6.js <<JS
(() => {
  const r = document.querySelector('.row[data-cd="$CODE"]');
  if (!r) return 'ROW_NOT_FOUND';
  for (const t of ['mousedown','mouseup','click'])
    r.dispatchEvent(new MouseEvent(t, {bubbles:true, cancelable:true, view:window}));
  return 'ok';
})()
JS
OPEN=$($B eval $SP/open6.js 2>&1 | tail -1)
echo "[$CODE] 행 열기: $OPEN"
case "$OPEN" in *NOT_FOUND*) echo "[$CODE] ★ 중단"; exit 1;; esac
sleep 3
$B frame "iframe#frame" >/dev/null 2>&1

python3 - "$NEWNM" "$OLDNM" "$OLDNOTE" > $SP/ren.js <<'PY'
import json, sys
new, old, note = sys.argv[1:4]
keep = f'구 이름: {old}'
merged = note if keep in note else (f'{note} / {keep}'.strip(' /') if note else keep)
print(f'''(() => {{
  const setV = (sel, v) => {{
    const el = document.querySelector(sel);
    if (!el) return false;
    Object.getOwnPropertyDescriptor(HTMLInputElement.prototype, 'value').set.call(el, v);
    el.dispatchEvent(new Event('input', {{bubbles: true}}));
    el.dispatchEvent(new Event('change', {{bubbles: true}}));
    return true;
  }};
  const cur = document.querySelector('#id_comp_nm');
  if (!cur) return 'NAME_FIELD_NOT_FOUND';
  if (cur.value.trim() !== {json.dumps(old)}) return 'NAME_UNEXPECTED:' + cur.value;
  if (!setV('#id_comp_nm', {json.dumps(new)})) return 'SET_NAME_FAIL';
  if (!setV('#id_note', {json.dumps(merged)})) return 'SET_NOTE_FAIL';
  return document.querySelector('#id_comp_nm').value + ' || 비고=' +
         document.querySelector('#id_note').value;
}})()''')
PY
RES=$($B eval $SP/ren.js 2>&1 | tail -1)
echo "[$CODE] 폼: $RES"
case "$RES" in *NOT_FOUND*|*UNEXPECTED*|*FAIL*) echo "[$CODE] ★ 저장하지 않고 중단"; exit 1;; esac
$B screenshot --viewport "$PS/screens/p6/rename-$CODE.png" >/dev/null 2>&1
$B click "button[name=_save]" >/dev/null 2>&1
sleep 4

python3 - "$CODE" "$NEWNM" <<'PY'
import sys
sys.path.insert(0, '/Users/innojini/Dev/HuniWeb/.claude/worktrees/t34/_workspace/price-setup/scripts')
import db
code, new = sys.argv[1], sys.argv[2]
out = db.q(f"""SELECT comp_nm, coalesce(note,''), comp_typ_cd, prc_typ_cd,
 (SELECT count(*) FROM t_prc_component_prices p WHERE p.comp_cd='{code}')
 FROM t_prc_price_components WHERE comp_cd='{code}'""", tuples=True).strip().split('\t')
ok = out[0].strip() == new and '구 이름:' in out[1]
print(f"[{code}] 실측 이름={out[0]} · 비고={out[1][:70]} · 유형={out[2]}/{out[3]} · 단가행={out[4]}")
print(f"[{code}] 판정 {'OK' if ok else '★확인필요'}")
sys.exit(0 if ok else 1)
PY
