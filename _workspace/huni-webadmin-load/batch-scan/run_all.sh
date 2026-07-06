#!/bin/bash
cd /Users/innojini/Dev/HuniWeb
B=~/.claude/skills/gstack/browse/dist/browse
OUT=_workspace/huni-webadmin-load/batch-scan/results/all-v4.jsonl
> "$OUT"
TOTAL=260; STEP=20
for ((s=0; s<TOTAL; s+=STEP)); do
  e=$((s+STEP)); [ $e -gt $TOTAL ] && e=$TOTAL
  python3 _workspace/huni-webadmin-load/batch-scan/gen_scan.py $s $e >/dev/null 2>&1
  $B eval /tmp/scan_run.js 2>/dev/null | python3 -c "
import sys,json
for line in sys.stdin.read().splitlines():
    line=line.strip()
    if line.startswith('['):
        arr=json.loads(line)
        with open('$OUT','a') as f:
            for r in arr: f.write(json.dumps(r,ensure_ascii=False)+'\n')
        break
" 2>/dev/null
  echo "batch [$s:$e] total=$(wc -l < $OUT)"
done
echo "SCAN_COMPLETE total=$(wc -l < $OUT)"
