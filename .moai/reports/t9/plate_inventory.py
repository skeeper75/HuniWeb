"""권위 「판걸이수」 시트가 실제로 쓰는 판형 어휘를 결정론으로 집계한다(해석 없음)."""
import collections
import subprocess
import sys

r = subprocess.run([sys.executable, 'dump_sheet.py', '판걸이수', '1', '1071'],
                   capture_output=True, text=True)
plates = collections.Counter()
for line in r.stdout.splitlines():
    cells = line.split('\t')
    for c in cells[1:]:
        c = c.strip()
        if 'x' in c and c.replace('x', '').replace('.', '').isdigit():
            a, _, b = c.partition('x')
            try:
                w, h = float(a), float(b)
            except ValueError:
                continue
            # 판형은 실물 인쇄판 — 300mm 이상 두 변 중 하나가 450 이상인 큰 판만 후보
            if max(w, h) >= 450 and min(w, h) >= 300:
                plates[c] += 1
for p, n in plates.most_common():
    print(f'{p}\t{n}')
