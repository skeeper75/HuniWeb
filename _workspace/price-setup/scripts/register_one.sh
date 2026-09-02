#!/bin/bash
# M2 그릇 한 건을 webadmin 실화면 폼으로 등록한다.
# 쓰기는 폼 저장 버튼 한 번뿐이다 — DB 직접 쓰기·엔드포인트 호출 없음.
# 사용: register_one.sh <order번호>
set -u
WT=/Users/innojini/Dev/HuniWeb/.claude/worktrees/t34
B=~/.claude/skills/gstack/browse/dist/browse
SP=/tmp/claude-501/-Users-innojini-Dev-HuniWeb/5a75057a-5718-4539-ad53-437e923e1e08/scratchpad
ORDER=$1

# 명세에서 그 행을 읽는다(값을 지어내지 않는다).
eval "$(python3 - "$ORDER" <<'PY'
import csv, sys, shlex
o=sys.argv[1]
for r in csv.DictReader(open('/Users/innojini/Dev/HuniWeb/.claude/worktrees/t34/_workspace/price-setup/m2/registration-spec-43.csv')):
    if r['order']==o:
        for k in ('new_code','new_name','comp_typ_cd','prc_typ_cd','use_dims_to_pick','note'):
            print(f"{k.upper()}={shlex.quote(r[k])}")
        break
PY
)"

echo "[$ORDER] $NEW_CODE — 등록 시작"

# 이미 있으면 건너뛴다(멱등).
EXIST=$(python3 -c "
import sys; sys.path.insert(0,'$WT/_workspace/price-setup/scripts'); import db
print(db.q(\"SELECT count(*) FROM t_prc_price_components WHERE comp_cd='$NEW_CODE'\", tuples=True).strip())")
if [ "$EXIST" != "0" ]; then echo "[$ORDER] 이미 존재 — 건너뜀"; exit 0; fi

BEFORE=$(python3 -c "
import sys; sys.path.insert(0,'$WT/_workspace/price-setup/scripts'); import db
print(db.q('SELECT count(*) FROM t_prc_price_components', tuples=True).strip())")

# 새 폼 열기
$B frame main >/dev/null 2>&1
$B goto https://huni-admin.printly.co.kr/admin/price-component-md/ >/dev/null 2>&1
$B click "a.add" >/dev/null 2>&1
sleep 2
$B frame "iframe#frame" >/dev/null 2>&1

# 폼 채우기 — 평범한 입력은 네이티브 setter + input/change 로 타이핑과 같게,
# 사용차원은 위젯 칩에 실제 MouseEvent 를 보내 옮긴다.
python3 - "$NEW_CODE" "$NEW_NAME" "$COMP_TYP_CD" "$PRC_TYP_CD" "$USE_DIMS_TO_PICK" "$NOTE" > $SP/fill.js <<'PY'
import json, sys
code, name, typ, prc, dims, note = sys.argv[1:7]
LABEL = {'siz_cd':'사이즈','plt_siz_cd':'판형사이즈','print_opt_cd':'인쇄옵션','mat_cd':'자재',
         'proc_cd':'공정','opt_cd':'옵션코드','coat_side_cnt':'코팅면수','spot_side_cnt':'별색면수',
         'bdl_qty':'묶음수','page_cnt':'페이지수','siz_width':'사이즈가로(구간)',
         'siz_height':'사이즈세로(구간)'}
picks = [LABEL[d] for d in dims.split(',') if d and d != 'min_qty']
print(f'''(() => {{
  const setV = (sel, v) => {{
    const el = document.querySelector(sel);
    const proto = el.tagName === 'SELECT' ? HTMLSelectElement : HTMLInputElement;
    Object.getOwnPropertyDescriptor(proto.prototype, 'value').set.call(el, v);
    el.dispatchEvent(new Event('input', {{bubbles: true}}));
    el.dispatchEvent(new Event('change', {{bubbles: true}}));
  }};
  setV('#id_comp_cd', {json.dumps(code)});
  setV('#id_comp_nm', {json.dumps(name)});
  setV('#id_comp_typ_cd', {json.dumps(typ)});
  setV('#id_prc_typ_cd', {json.dumps(prc)});
  setV('#id_use_yn', 'Y');
  setV('#id_note', {json.dumps(note)});
  for (const label of {json.dumps(picks)}) {{
    const el = Array.from(document.querySelectorAll('.udo-avail .udo-item'))
      .find(e => e.textContent.trim() === label);
    if (!el) return 'DIM_NOT_FOUND:' + label;
    for (const t of ['mousedown', 'mouseup', 'click'])
      el.dispatchEvent(new MouseEvent(t, {{bubbles: true, cancelable: true, view: window}}));
  }}
  return document.querySelector('#id_comp_cd').value + ' | dims=' +
         document.querySelector('#id_use_dims').value;
}})()''')
PY
FILLED=$($B eval $SP/fill.js 2>&1 | tail -1)
echo "[$ORDER] 폼: $FILLED"
case "$FILLED" in *DIM_NOT_FOUND*) echo "[$ORDER] ★ 차원 칩을 못 찾음 — 중단"; exit 1;; esac

# 저장 직전 폼 갈무리(건별 증거 · 리드 결정 4)
$B js "document.querySelector('#id_comp_cd').scrollIntoView({block:'start'}); 'ok'" >/dev/null 2>&1
sleep 1
PNG=$(printf '%s/_workspace/price-setup/screens/m2/f%02d-%s.png' "$WT" "$ORDER" "$NEW_CODE")
$B screenshot --viewport "$PNG" >/dev/null 2>&1

# 저장 — 이 한 번이 유일한 쓰기다
$B click "button[name=_save]" >/dev/null 2>&1
sleep 3

# 등록 직후 라이브 실측
python3 - "$ORDER" "$NEW_CODE" "$BEFORE" "$PNG" <<'PY'
import sys, csv, os
sys.path.insert(0, '/Users/innojini/Dev/HuniWeb/.claude/worktrees/t34/_workspace/price-setup/scripts')
import db
order, code, before, png = sys.argv[1:5]
out = db.q(f"""SELECT comp_cd, comp_typ_cd, prc_typ_cd, use_yn, coalesce(del_yn,''),
  replace(use_dims::text, ',', ' '), reg_dt FROM t_prc_price_components
  WHERE comp_cd='{code}'""", tuples=True).strip()
total = db.q('SELECT count(*) FROM t_prc_price_components', tuples=True).strip()
ok = bool(out) and int(total) == int(before) + 1
p = '/Users/innojini/Dev/HuniWeb/.claude/worktrees/t34/_workspace/price-setup/m2/registered.csv'
new = not os.path.exists(p)
with open(p, 'a', newline='') as f:
    w = csv.writer(f)
    if new:
        w.writerow(['order', 'comp_cd', 'comp_typ_cd', 'prc_typ_cd', 'use_yn', 'del_yn',
                    'use_dims', 'reg_dt', 'total_before', 'total_after', 'verdict', 'screenshot'])
    fields = out.split('\t') if out else ['']*7
    w.writerow([order] + fields + [before, total,
                'OK' if ok else '★확인필요', os.path.basename(png)])
print(f"[{order}] 실측: {out}")
print(f"[{order}] 전체 {before} → {total}  판정 {'OK' if ok else '★확인필요'}")
sys.exit(0 if ok else 1)
PY
