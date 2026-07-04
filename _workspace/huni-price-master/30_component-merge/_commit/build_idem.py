# -*- coding: utf-8 -*-
"""롤백전용 멱등 실증 스크립트 빌더: 각 COMMIT SQL 본문을 한 트랜잭션 안에서 2회 적용→ROLLBACK.
2회차에도 사전/사후 게이트가 통과하면 멱등(재실행 0변경)+실행가능+제약위반0 증명. 영속 없음."""
import os, glob
D = os.path.dirname(__file__)
SRC = os.path.join(D, "02-commit")
OUT = os.path.join(D, "03-dryrun-idem"); os.makedirs(OUT, exist_ok=True)

for f in sorted(glob.glob(os.path.join(SRC, "*.sql"))):
    lines = open(f).read().splitlines()
    # 본문 = 첫 'BEGIN;' 다음줄 ~ 마지막 'COMMIT' 시작줄 이전
    bi = next(i for i,l in enumerate(lines) if l.strip()=="BEGIN;")
    ci = max(i for i,l in enumerate(lines) if l.strip().startswith("COMMIT"))
    body = "\n".join(lines[bi+1:ci])
    mc = os.path.basename(f).split("-commit")[0]
    out = f"""\\set ON_ERROR_STOP on
-- 멱등 실증(롤백전용): {mc} 본문 2회 적용 후 ROLLBACK. 게이트 RAISE 시 즉시 abort(비0 종료).
BEGIN;
\\echo '=== {mc} PASS 1 ==='
{body}
\\echo '=== {mc} PASS 2 (idempotency) ==='
{body}
\\echo '=== {mc} 2PASS 통과 → 멱등·게이트OK ==='
ROLLBACK;
"""
    open(os.path.join(OUT, mc+"-idem.sql"), "w").write(out)
    print("wrote", mc+"-idem.sql")
print("DONE")
