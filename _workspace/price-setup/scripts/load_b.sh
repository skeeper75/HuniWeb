#!/bin/bash
# 트랙 B P3 — 단가행 한 그릇을 webadmin 단가표 편집 화면으로 적재한다.
# 값은 결정론 생성기(build_grid_b.py)가 만든 붙여넣기표 그대로다.
# 쓰기는 화면의 [변경분 저장] 버튼 한 번뿐이다.
set -u
WT=/Users/innojini/Dev/HuniWeb/.claude/worktrees/t34
PS=$WT/_workspace/price-setup
B=~/.claude/skills/gstack/browse/dist/browse
SP=/private/tmp/claude-501/-Users-innojini-Dev-HuniWeb/e0a41dab-8e55-4275-8dd7-0e92be112401/scratchpad
mkdir -p "$SP" "$PS/screens/b3"
CODE=$1
CSV=$PS/t34b/grid2/$CODE.csv
[ -f "$CSV" ] || { echo "[$CODE] ★ 붙여넣기표 없음"; exit 1; }

WANT=$(($(wc -l < "$CSV") - 1))
HAVE=$(python3 -c "
import sys; sys.path.insert(0,'$PS/scripts'); import db
print(db.q(\"SELECT count(*) FROM t_prc_component_prices WHERE comp_cd='$CODE'\", tuples=True).strip())")
echo "[$CODE] 표 ${WANT}행 · 라이브 현재 ${HAVE}행"
[ "$HAVE" != "0" ] && { echo "[$CODE] 이미 적재됨 — 건너뜀"; exit 0; }

$B frame main >/dev/null 2>&1
$B goto "https://huni-admin.printly.co.kr/admin/price-viewer/comp/$CODE/edit/" >/dev/null 2>&1
sleep 5
bash $PS/scripts/wa_login.sh
$B goto "https://huni-admin.printly.co.kr/admin/price-viewer/comp/$CODE/edit/" >/dev/null 2>&1
sleep 5

python3 - "$CSV" > $SP/load_b.js <<'PY'
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
  inst.setData({json.dumps(body)});
  const cb = document.querySelector('#cpg-todaybar input[type=checkbox]');
  if (cb && !cb.checked) {{
    cb.checked = true;
    cb.dispatchEvent(new Event('change', {{bubbles: true}}));
  }}
  return 'rows=' + inst.getData().length + ' 적용일일괄=' + (cb ? cb.checked : 'no-cb');
}})()''')
PY
RES=$($B eval $SP/load_b.js 2>&1 | tail -1)
echo "[$CODE] 그리드: $RES"
case "$RES" in *MISMATCH*|*NO_INSTANCE*) echo "[$CODE] ★ 저장하지 않고 중단"; exit 1;; esac

$B screenshot --viewport "$PS/screens/b3/g-$CODE.png" >/dev/null 2>&1

python3 - > $SP/save_b.js <<'PY'
print('''(() => {
  const b = Array.from(document.querySelectorAll('button,a'))
    .find(e => e.textContent.trim().startsWith('변경분 저장'));
  if (!b) return 'SAVE_BTN_NOT_FOUND';
  b.click();
  return 'saved-click';
})()''')
PY
$B eval $SP/save_b.js 2>&1 | tail -1
sleep 6
$B screenshot --viewport "$PS/screens/b3/after-$CODE.png" >/dev/null 2>&1

python3 - "$CODE" "$CSV" <<'PY'
import csv, sys
sys.path.insert(0, '/Users/innojini/Dev/HuniWeb/.claude/worktrees/t34/_workspace/price-setup/scripts')
import db
code, path = sys.argv[1], sys.argv[2]
rows = list(csv.DictReader(open(path)))
COL = {'자재': 'mat_cd', '사이즈': 'siz_cd', '사이즈가로(이하)': 'siz_width',
       '사이즈세로(이하)': 'siz_height', '수량(이상)': 'min_qty', '옵션코드': 'opt_cd',
       '공정': 'proc_cd', '묶음수': 'bdl_qty', '판형사이즈': 'plt_siz_cd',
       '인쇄옵션': 'print_opt_cd', '별색면수': 'spot_side_cnt', '코팅면수': 'coat_side_cnt',
       '페이지수': 'page_cnt'}
key_cols = [c for c in rows[0] if c in COL]          # 파라미터 칸(앞면별색 등)은 DB 컬럼이 아니다
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
pcol = next(c for c in rows[0] if c in ('단가', '합가', '고정'))
mine = {tuple(norm(r[c]) for c in key_cols): float(r[pcol]) for r in rows}
livn = {tuple(norm(x) for x in k): v for k, v in live.items()}
miss = [k for k in mine if k not in livn]
extra = [k for k in livn if k not in mine]
diff = [k for k in mine if k in livn and livn[k] != mine[k]]
ok = not (miss or extra or diff)
print(f"[{code}] 키 {key_cols} · 라이브 {len(livn)}행 / 표 {len(mine)}행 · 누락 {len(miss)} "
      f"· 잉여 {len(extra)} · 값차이 {len(diff)}  →  {'diff 0 ✓' if ok else '★확인필요'}")
for k in (miss[:3] + extra[:3] + diff[:3]):
    print('   ', k, 'live=', livn.get(k), 'mine=', mine.get(k))
sys.exit(0 if ok else 1)
PY
