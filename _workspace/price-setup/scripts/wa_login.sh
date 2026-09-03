#!/bin/bash
# webadmin 세션이 풀렸으면 다시 로그인한다. 자격증명은 .env.local 에서만 읽는다.
set -u
B=~/.claude/skills/gstack/browse/dist/browse
case "$($B url 2>/dev/null | tail -1)" in
  *"/admin/login/"*)
    ID=$(grep '^HUNI_ADMIN_ID=' /Users/innojini/Dev/HuniWeb/.env.local | cut -d= -f2-)
    PW=$(grep '^HUNI_ADMIN_PW=' /Users/innojini/Dev/HuniWeb/.env.local | cut -d= -f2-)
    $B fill "#id_username" "$ID" >/dev/null 2>&1
    $B fill "#id_password" "$PW" >/dev/null 2>&1
    $B click "button[type=submit]" >/dev/null 2>&1
    sleep 5
    echo "  (재로그인)" ;;
esac
