#!/usr/bin/env bash
# codex-preflight.sh — codex 가용성 점검 + 모델 폴백 탐색 (RP-Meta 하네스 공용)
#
# 왜 이 스크립트인가:
#   `codex login status`는 만료 토큰도 "Logged in"으로 오보고하고, codex 데드락의
#   진짜 원인이 토큰이 아니라 *기본 모델 선택*일 수 있다(예: gpt-5-codex/gpt-5는
#   ChatGPT 계정에서 400 not supported, gpt-5.5는 지원). 단순 ping 실패를 무조건
#   "토큰 만료"로 오진단하면, 모델만 바꾸면 raster가 가능한데도 즉시 포기하게 된다.
#   이 스크립트는 지원 모델 후보를 순회해 작동하는 모델을 찾고, 토큰 문제와 모델
#   데드락을 구분해 폴백 결정을 정확히 내린다.
#
# 출력(stdout 마지막 줄, 호출자가 파싱):
#   AVAILABLE model=<m>  — codex exec 작동(이 모델로 -m 지정해 쓰면 됨). exit 0
#   DEADLOCK             — codex는 있으나 지원 모델 후보가 전부 실패 → mermaid 폴백. exit 1
#   AUTH_STALE           — 토큰 만료/401 → 사용자가 `codex login` 필요 → mermaid 폴백. exit 1
#   UNAVAILABLE          — codex 미설치 → mermaid 폴백. exit 1
#
# exit code: 0 = AVAILABLE(raster 가능), 1 = 폴백 필요(나머지 전부)
#
# 사용:
#   res=$(bash .claude/skills/rpm-visualize/scripts/codex-preflight.sh)
#   case "$res" in
#     AVAILABLE*) model="${res#AVAILABLE model=}"; ;;   # codex exec -m "$model" ... 로 raster
#     *)          ;;                                     # mermaid 폴백
#   esac

set -uo pipefail

PING="reply with exactly: OK"

# ChatGPT 계정에서 작동 확인된 모델 우선순위(2026-06 기준: gpt-5.5 확인).
# 신모델 출시로 데드락이 생기면 이 배열 앞에 새 모델을 추가하면 된다.
CANDIDATES=("gpt-5.5" "gpt-5.5-codex" "gpt-5.1" "gpt-5.1-codex")

command -v codex >/dev/null 2>&1 || { echo "UNAVAILABLE"; exit 1; }

out="/tmp/codex-preflight-$$.md"
trap 'rm -f "$out"' EXIT

for m in "${CANDIDATES[@]}"; do
  : > "$out"
  err=$(codex exec -m "$m" --sandbox read-only --output-last-message "$out" "$PING" 2>&1)
  if grep -qi "OK" "$out" 2>/dev/null; then
    echo "AVAILABLE model=$m"
    exit 0
  fi
  # 토큰/인증 문제는 모델을 바꿔도 무의미 — 즉시 AUTH_STALE.
  if printf '%s' "$err" | grep -qiE "401|unauthorized|expired|not logged in|please run .*login"; then
    echo "AUTH_STALE"
    exit 1
  fi
  # 그 외(주로 400 model not supported)는 다음 후보 모델로 계속.
done

# 모든 후보 모델이 실패(전부 400류) = 버전/계정-모델 데드락.
echo "DEADLOCK"
exit 1
