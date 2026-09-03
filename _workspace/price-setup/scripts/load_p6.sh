#!/bin/bash
# 트랙 B P6 — 기존 그릇 단가표를 권위 전체로 교체한다(그리드 full-sync).
# 값은 build_p6.py 가 권위 xlsx 에서 만든 표 그대로다.
# 적용일 일괄 체크박스는 건드리지 않는다 — 표에 기존 적용일(2026-06-01)이 박혀 있다.
# 쓰기는 [변경분 저장] 한 번뿐이다.
set -u
WT=/Users/innojini/Dev/HuniWeb/.claude/worktrees/t34
PS=$WT/_workspace/price-setup
B=~/.claude/skills/gstack/browse/dist/browse
SP=/private/tmp/claude-501/-Users-innojini-Dev-HuniWeb/e0a41dab-8e55-4275-8dd7-0e92be112401/scratchpad
mkdir -p "$SP" "$PS/screens/p6"
CODE=$1
CSV=$PS/t34b/p6grid/$CODE.csv
[ -f "$CSV" ] || { echo "[$CODE] ★ 붙여넣기표 없음"; exit 1; }
WANT=$(($(wc -l < "$CSV") - 1))

HAVE=$(python3 -c "
import sys; sys.path.insert(0,'$PS/scripts'); import db
print(db.q(\"SELECT count(*) FROM t_prc_component_prices WHERE comp_cd='$CODE'\", tuples=True).strip())")
echo "[$CODE] 표 ${WANT}행 · 라이브 현재 ${HAVE}행"

$B frame main >/dev/null 2>&1
$B goto "https://huni-admin.printly.co.kr/admin/price-viewer/comp/$CODE/edit/" >/dev/null 2>&1
sleep 5
bash $PS/scripts/wa_login.sh
$B goto "https://huni-admin.printly.co.kr/admin/price-viewer/comp/$CODE/edit/" >/dev/null 2>&1
sleep 5
$B screenshot --viewport "$PS/screens/p6/before-$CODE.png" >/dev/null 2>&1

python3 - "$CSV" > $SP/p6.js <<'PY'
import csv, json, sys
rows = list(csv.reader(open(sys.argv[1])))
hdr, body = rows[0], rows[1:]
print(f'''(() => {{
  const h = Array.from(document.querySelectorAll('*')).find(e => e.jspreadsheet || e.jexcel);
  const inst = h && (h.jspreadsheet || h.jexcel);
  if (!inst) return 'NO_INSTANCE';
  const want = {json.dumps(hdr)};
  const got = (inst.options.columns || []).map(c => c.title);
  if (JSON.stringify(want) !== JSON.stringify(got))
    return 'COLUMN_MISMATCH | 표=' + want.join(',') + ' | 화면=' + got.join(',');
  const before = inst.getData().length;
  inst.setData({json.dumps(body)});
  const cb = document.querySelector('#cpg-todaybar input[type=checkbox]');
  if (cb && cb.checked) {{           // 적용일 일괄은 끈다 — 기존 적용일 보존
    cb.checked = false;
    cb.dispatchEvent(new Event('change', {{bubbles: true}}));
  }}
  return '이전행=' + before + ' 새행=' + inst.getData().length +
         ' 적용일일괄=' + (cb ? cb.checked : 'no-cb');
}})()''')
PY
RES=$($B eval $SP/p6.js 2>&1 | tail -1)
echo "[$CODE] 그리드: $RES"
case "$RES" in *MISMATCH*|*NO_INSTANCE*) echo "[$CODE] ★ 저장하지 않고 중단"; exit 1;; esac

$B screenshot --viewport "$PS/screens/p6/grid-$CODE.png" >/dev/null 2>&1

python3 - > $SP/p6save.js <<'PY'
print('''(() => {
  const b = Array.from(document.querySelectorAll('button,a'))
    .find(e => e.textContent.trim().startsWith('변경분 저장'));
  if (!b) return 'SAVE_BTN_NOT_FOUND';
  b.click();
  return 'saved-click';
})()''')
PY
$B eval $SP/p6save.js 2>&1 | tail -1
sleep 6
$B screenshot --viewport "$PS/screens/p6/after-$CODE.png" >/dev/null 2>&1

python3 - "$CODE" "$CSV" <<'PY'
import csv, sys
sys.path.insert(0, '/Users/innojini/Dev/HuniWeb/.claude/worktrees/t34/_workspace/price-setup/scripts')
import db
code, path = sys.argv[1], sys.argv[2]
rows = list(csv.DictReader(open(path)))
has_line = '줄수 (줄)' in rows[0]
sel = "proc_cd, coalesce(dim_vals->>'줄수',''), min_qty, unit_price, apply_ymd" if has_line \
      else "proc_cd, '', min_qty, unit_price, apply_ymd"
live = {}
for ln in db.q(f"SELECT {sel} FROM t_prc_component_prices WHERE comp_cd='{code}'",
               tuples=True).splitlines():
    if ln.strip():
        f = ln.split('\t')
        live[(f[0].strip(), f[1].strip(), int(float(f[2])))] = (float(f[3]), f[4].strip())
mine = {(r['공정'], (r.get('줄수 (줄)') or '').strip(), int(r['수량(이상)'])):
        (float(r['고정']), r['적용일']) for r in rows}
miss = sorted(set(mine) - set(live)); extra = sorted(set(live) - set(mine))
vdiff = [k for k in mine if k in live and live[k][0] != mine[k][0]]
adiff = [k for k in mine if k in live and live[k][1] != mine[k][1]]
ok = not (miss or extra or vdiff or adiff)
print(f"[{code}] 라이브 {len(live)}행 / 표 {len(mine)}행 · 누락 {len(miss)} · 잉여 {len(extra)} "
      f"· 값차이 {len(vdiff)} · 적용일차이 {len(adiff)}  →  {'diff 0 ✓' if ok else '★확인필요'}")
for k in (miss[:3] + extra[:3] + vdiff[:3] + adiff[:3]):
    print('   ', k, 'live=', live.get(k), 'mine=', mine.get(k))
sys.exit(0 if ok else 1)
PY
