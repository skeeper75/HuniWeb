#!/bin/bash
# 트랙 B P2 — 신설 그릇 한 건을 webadmin 실화면 폼으로 등록한다.
# 쓰기는 폼 저장 버튼 한 번뿐이다 — DB 직접 쓰기·엔드포인트 호출 없음.
# 트랙 A register_one.sh 와 동형 + 공정그룹(proc_grp) 선택 단계 추가.
# 사용: register_b.sh <order번호>
set -u
WT=/Users/innojini/Dev/HuniWeb/.claude/worktrees/t34
PS=$WT/_workspace/price-setup
B=~/.claude/skills/gstack/browse/dist/browse
SP=/private/tmp/claude-501/-Users-innojini-Dev-HuniWeb/e0a41dab-8e55-4275-8dd7-0e92be112401/scratchpad
mkdir -p "$SP"
ORDER=$1

eval "$(python3 - "$ORDER" <<'PY'
import csv, sys, shlex
o=sys.argv[1]
for r in csv.DictReader(open('/Users/innojini/Dev/HuniWeb/.claude/worktrees/t34/_workspace/price-setup/t34b/registration-spec-8.csv')):
    if r['order']==o:
        for k in ('new_code','new_name','comp_typ_cd','prc_typ_cd','use_dims_to_pick','proc_grp','note'):
            print(f"{k.upper()}={shlex.quote(r[k])}")
        break
PY
)"

echo "[$ORDER] $NEW_CODE — 등록 시작"

EXIST=$(python3 -c "
import sys; sys.path.insert(0,'$PS/scripts'); import db
print(db.q(\"SELECT count(*) FROM t_prc_price_components WHERE comp_cd='$NEW_CODE'\", tuples=True).strip())")
if [ "$EXIST" != "0" ]; then echo "[$ORDER] 이미 존재 — 건너뜀"; exit 0; fi

BEFORE=$(python3 -c "
import sys; sys.path.insert(0,'$PS/scripts'); import db
print(db.q('SELECT count(*) FROM t_prc_price_components', tuples=True).strip())")

$B frame main >/dev/null 2>&1
$B goto https://huni-admin.printly.co.kr/admin/price-component-md/ >/dev/null 2>&1
$B click "a.add" >/dev/null 2>&1
sleep 2
$B frame "iframe#frame" >/dev/null 2>&1

python3 - "$NEW_CODE" "$NEW_NAME" "$COMP_TYP_CD" "$PRC_TYP_CD" "$USE_DIMS_TO_PICK" "$PROC_GRP" "$NOTE" > $SP/fill_b.js <<'PY'
import json, sys
code, name, typ, prc, dims, grp, note = sys.argv[1:8]
LABEL = {'siz_cd':'사이즈','plt_siz_cd':'판형사이즈','print_opt_cd':'인쇄옵션','mat_cd':'자재',
         'proc_cd':'공정','opt_cd':'옵션코드','coat_side_cnt':'코팅면수','spot_side_cnt':'별색면수',
         'bdl_qty':'묶음수','page_cnt':'페이지수','siz_width':'사이즈가로(구간)',
         'siz_height':'사이즈세로(구간)'}
GRPLBL = {'PROC_000001':'인쇄','PROC_000007':'별색인쇄','PROC_000013':'라미네이팅 코팅',
          'PROC_000056':'접지','PROC_000079':'타공'}
picks = [LABEL[d] for d in dims.split(',') if d and d != 'min_qty']
print(f'''(() => {{
  const setV = (sel, v) => {{
    const el = document.querySelector(sel);
    const proto = el.tagName === 'SELECT' ? HTMLSelectElement : HTMLInputElement;
    Object.getOwnPropertyDescriptor(proto.prototype, 'value').set.call(el, v);
    el.dispatchEvent(new Event('input', {{bubbles: true}}));
    el.dispatchEvent(new Event('change', {{bubbles: true}}));
  }};
  const fire = (el, types) => {{ for (const t of types)
    el.dispatchEvent(new MouseEvent(t, {{bubbles: true, cancelable: true, view: window}})); }};
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
    fire(el, ['mousedown', 'mouseup', 'click']);
  }}
  const btn = document.querySelector('.udo-sel .udo-item[data-c="proc_cd"] .udo-ss-btn');
  if (!btn) return 'PROCGRP_BTN_NOT_FOUND';
  fire(btn, ['click']);
  const opt = Array.from(document.querySelectorAll('.udo-ss-pan .udo-ss-opt'))
    .find(o => o.textContent.trim() === {json.dumps(GRPLBL[grp])});
  if (!opt) return 'PROCGRP_OPT_NOT_FOUND:' + {json.dumps(GRPLBL[grp])};
  fire(opt, ['mousemove', 'mousedown']);
  return document.querySelector('#id_comp_cd').value + ' | dims=' +
         document.querySelector('#id_use_dims').value;
}})()''')
PY
FILLED=$($B eval $SP/fill_b.js 2>&1 | tail -1)
echo "[$ORDER] 폼: $FILLED"
case "$FILLED" in *NOT_FOUND*) echo "[$ORDER] ★ 위젯 요소를 못 찾음 — 저장하지 않고 중단"; exit 1;; esac
case "$FILLED" in *"proc_grp:$PROC_GRP"*) ;; *) echo "[$ORDER] ★ 공정그룹이 $PROC_GRP 가 아님 — 저장하지 않고 중단"; exit 1;; esac

$B js "document.querySelector('#id_comp_cd').scrollIntoView({block:'start'}); 'ok'" >/dev/null 2>&1
sleep 1
PNG=$(printf '%s/screens/b2/f%02d-%s.png' "$PS" "$ORDER" "$NEW_CODE")
$B screenshot --viewport "$PNG" >/dev/null 2>&1

# 저장 — 이 한 번이 유일한 쓰기다
$B click "button[name=_save]" >/dev/null 2>&1
sleep 3

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
p = '/Users/innojini/Dev/HuniWeb/.claude/worktrees/t34/_workspace/price-setup/t34b/registered-b.csv'
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
