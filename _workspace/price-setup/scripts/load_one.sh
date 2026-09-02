#!/bin/bash
# M3 단가행 한 그릇을 webadmin 단가표 편집 화면으로 적재한다.
# 값은 결정론 생성기가 만든 붙여넣기표 CSV 그대로다(사람·모델이 옮겨 적지 않는다).
# 쓰기는 화면의 [변경분 저장] 버튼 한 번뿐이다.
set -u
WT=/Users/innojini/Dev/HuniWeb/.claude/worktrees/t34
B=~/.claude/skills/gstack/browse/dist/browse
SP=/tmp/claude-501/-Users-innojini-Dev-HuniWeb/5a75057a-5718-4539-ad53-437e923e1e08/scratchpad
CODE=$1
CSV=$WT/_workspace/price-setup/grid/$CODE.csv
[ -f "$CSV" ] || { echo "[$CODE] ★ 붙여넣기표 없음"; exit 1; }

WANT=$(($(wc -l < "$CSV") - 1))
HAVE=$(python3 -c "
import sys; sys.path.insert(0,'$WT/_workspace/price-setup/scripts'); import db
print(db.q(\"SELECT count(*) FROM t_prc_component_prices WHERE comp_cd='$CODE'\", tuples=True).strip())")
echo "[$CODE] 표 ${WANT}행 · 라이브 현재 ${HAVE}행"
[ "$HAVE" != "0" ] && { echo "[$CODE] 이미 적재됨 — 건너뜀"; exit 0; }

$B goto "https://huni-admin.printly.co.kr/admin/price-viewer/comp/$CODE/edit/" >/dev/null 2>&1
sleep 3

# 표를 그리드에 얹는다. 적용일 칸은 비워 두고 화면의 「적용일 일괄 설정」이 오늘로 채우게 한다.
python3 - "$CSV" > $SP/load.js <<'PY'
import csv, json, sys
rows = list(csv.reader(open(sys.argv[1])))
hdr, body = rows[0], rows[1:]
print(f'''(() => {{
  // 홀더에는 id 가 없다 — jspreadsheet 인스턴스가 붙은 요소를 직접 찾는다.
  const h = Array.from(document.querySelectorAll('*')).find(e => e.jspreadsheet || e.jexcel);
  const inst = h && (h.jspreadsheet || h.jexcel);
  if (!inst) return 'NO_INSTANCE';
  const want = {json.dumps(hdr)};
  const got = (inst.options.columns || []).map(c => c.title);
  if (JSON.stringify(want) !== JSON.stringify(got))
    return 'COLUMN_MISMATCH | 표=' + want.join(',') + ' | 화면=' + got.join(',');
  inst.setData({json.dumps(body)});
  const cb = document.querySelector('#cpg-todaybar input[type=checkbox]');
  if (cb && !cb.checked) {{
    cb.checked = true;
    cb.dispatchEvent(new Event('change', {{bubbles: true}}));
  }}
  return 'rows=' + inst.getData().length + ' 적용일일괄=' + (cb ? cb.checked : 'no-cb');
}})()''')
PY
RES=$($B eval $SP/load.js 2>&1 | tail -1)
echo "[$CODE] 그리드: $RES"
case "$RES" in *MISMATCH*|*NO_INSTANCE*) echo "[$CODE] ★ 중단"; exit 1;; esac

$B screenshot --viewport "$WT/_workspace/price-setup/screens/m3/g-$CODE.png" >/dev/null 2>&1

# 저장 — 유일한 쓰기
python3 - > $SP/save.js <<'PY'
print('''(() => {
  const b = Array.from(document.querySelectorAll('button,a'))
    .find(e => e.textContent.trim().startsWith('변경분 저장'));
  if (!b) return 'SAVE_BTN_NOT_FOUND';
  b.click();
  return 'saved-click';
})()''')
PY
$B eval $SP/save.js 2>&1 | tail -1
sleep 5

# 라이브 실측 diff — 표와 라이브가 한 칸도 다르지 않아야 한다
python3 - "$CODE" "$CSV" <<'PY'
import csv, sys
sys.path.insert(0, '/Users/innojini/Dev/HuniWeb/.claude/worktrees/t34/_workspace/price-setup/scripts')
import db
code, path = sys.argv[1], sys.argv[2]
rows = list(csv.DictReader(open(path)))
key_cols = [c for c in rows[0] if c not in ('적용일', '단가', '비고')]
COL = {'자재': 'mat_cd', '사이즈': 'siz_cd', '사이즈가로(이하)': 'siz_width',
       '사이즈세로(이하)': 'siz_height', '수량(이상)': 'min_qty', '옵션코드': 'opt_cd',
       '공정': 'proc_cd', '묶음수': 'bdl_qty', '판형사이즈': 'plt_siz_cd',
       '인쇄옵션': 'print_opt_cd'}
sel = ', '.join(f"coalesce({COL[c]}::text,'')" for c in key_cols)
live = {}
for line in db.q(f"SELECT {sel}, unit_price FROM t_prc_component_prices "
                 f"WHERE comp_cd='{code}'", tuples=True).splitlines():
    if line.strip():
        f = line.split('\t')
        live[tuple(f[:-1])] = float(f[-1])


def norm(v):
    try:
        return f'{float(v):g}'
    except (TypeError, ValueError):
        return (v or '').strip()


mine = {tuple(norm(r[c]) for c in key_cols): float(r['단가']) for r in rows}
livn = {tuple(norm(x) for x in k): v for k, v in live.items()}
miss = [k for k in mine if k not in livn]
extra = [k for k in livn if k not in mine]
diff = [k for k in mine if k in livn and livn[k] != mine[k]]
ok = not (miss or extra or diff)
print(f"[{code}] 라이브 {len(livn)}행 / 표 {len(mine)}행 · 누락 {len(miss)} · 잉여 {len(extra)} "
      f"· 값차이 {len(diff)}  →  {'diff 0 ✓' if ok else '★확인필요'}")
for k in (miss[:3] + extra[:3] + diff[:3]):
    print('   ', k, 'live=', livn.get(k), 'mine=', mine.get(k))
sys.exit(0 if ok else 1)
PY
