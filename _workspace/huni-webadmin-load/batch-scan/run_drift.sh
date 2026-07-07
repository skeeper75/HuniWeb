#!/bin/bash
# 드리프트 전수 스캔 — 260 상품을 배치로 /simulate 스윕. 읽기전용. results/drift-v1.jsonl 산출.
cd /Users/innojini/Dev/HuniWeb
B=~/.claude/skills/gstack/browse/dist/browse
OUT=_workspace/huni-webadmin-load/batch-scan/results/drift-v1.jsonl
> "$OUT"
TOTAL=260; STEP=15
for ((s=0; s<TOTAL; s+=STEP)); do
  e=$((s+STEP)); [ $e -gt $TOTAL ] && e=$TOTAL
  python3 _workspace/huni-webadmin-load/batch-scan/gen_drift.py $s $e >/dev/null 2>&1
  $B eval /tmp/drift_run.js 2>/dev/null | python3 -c "
import sys,json
for line in sys.stdin.read().splitlines():
    line=line.strip()
    if line.startswith('['):
        arr=json.loads(line)
        with open('$OUT','a') as f:
            for r in arr: f.write(json.dumps(r,ensure_ascii=False)+'\n')
        break
" 2>/dev/null
  echo "drift batch [$s:$e] total=$(wc -l < $OUT)"
done
echo "DRIFT_SCAN_COMPLETE total=$(wc -l < $OUT)"
