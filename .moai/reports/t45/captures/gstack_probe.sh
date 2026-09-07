#!/bin/bash
# t45 카드 — gstack webadmin 읽기전용 탐색 헬퍼 (v2 실화면 자료)
# 자격증명: /Users/innojini/Dev/HuniWeb/.env.local 에서 런타임 로드만 (값 저장·출력 없음)
# 사용: bash gstack_probe.sh <step>
set -u
B="$HOME/.claude/skills/gstack/browse/dist/browse"
ENVF="/Users/innojini/Dev/HuniWeb/.env.local"
CAP_DIR="$(cd "$(dirname "$0")" && pwd)"
ADMIN_URL=$(grep '^HUNI_ADMIN_URL=' "$ENVF" | cut -d= -f2-)
ADMIN_ID=$(grep '^HUNI_ADMIN_ID=' "$ENVF" | cut -d= -f2-)
ADMIN_PW=$(grep '^HUNI_ADMIN_PW=' "$ENVF" | cut -d= -f2-)
BASE=$(echo "$ADMIN_URL" | sed -E 's#(https?://[^/]+).*#\1#')

step="$1"
case "$step" in
  login)
    "$B" goto "$BASE/admin/" >/dev/null
    "$B" url
    # 로그인 폼 탐지 — Django admin 이면 username/password 입력칸 존재
    "$B" snapshot -i -c 2>&1 | head -40
    ;;
  fill)
    # 폼 ref는 login 출력에서 확인 후 실행 (ref는 세션 유지)
    "$B" fill "$2" "$ADMIN_ID"
    "$B" fill "$3" "$ADMIN_PW"
    echo "filled (값 미출력)"
    ;;
  *)
    echo "unknown step: $step" >&2; exit 2 ;;
esac
