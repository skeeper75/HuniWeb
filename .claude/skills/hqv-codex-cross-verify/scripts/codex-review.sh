#!/usr/bin/env bash
# codex-review.sh — Codex(gpt-5.5)를 독립 교차검증자로 비대화 호출(읽기전용 샌드박스).
# 용도: 가격계산 검증 하네스에서 Claude의 1차 검증과 독립으로 codex 2nd opinion을 받는다.
# 사용: codex-review.sh <prompt_file> [model] [workdir]
#   <prompt_file> : codex에 줄 프롬프트가 담긴 파일(상품 spec + 공식사슬 + 골든 + 검증 질문)
#   [model]       : 기본 gpt-5.5 (preflight가 가용 모델로 폴백)
#   [workdir]     : codex 읽기 루트(기본 = 현재 디렉토리). 라이브 산출물 경로를 줘야 codex가 읽음.
# 출력: stdout에 codex 판정. 종료코드 0=성공, 1=프롬프트없음, 2=codex 미가용(데드락/인증).
# 안전: -s read-only 강제. codex는 파일을 쓰지 못함(독립 의견만). 비밀값은 프롬프트에 넣지 말 것.
set -uo pipefail

PROMPT_FILE="${1:-}"
MODEL="${2:-gpt-5.5}"
WORKDIR="${3:-$(pwd)}"
PREFLIGHT="$(dirname "$0")/../../rpm-visualize/scripts/codex-preflight.sh"

if [ -z "$PROMPT_FILE" ] || [ ! -f "$PROMPT_FILE" ]; then
  echo "ERROR: prompt file 없음: '$PROMPT_FILE'" >&2
  exit 1
fi

# 1) preflight — 모델 가용성(토큰문제 vs 모델데드락 구분). 있으면 재사용.
if [ -f "$PREFLIGHT" ]; then
  PF="$(bash "$PREFLIGHT" 2>/dev/null | tail -1)"
  case "$PF" in
    AVAILABLE*) MODEL="$(echo "$PF" | sed -n 's/.*model=//p')"; MODEL="${MODEL:-gpt-5.5}" ;;
    AUTH_STALE*) echo "CODEX_UNAVAILABLE: 인증 만료(토큰 갱신 필요) — codex login" >&2; exit 2 ;;
    DEADLOCK*|UNAVAILABLE*) echo "CODEX_UNAVAILABLE: 모델 데드락/미가용 — Claude 단독 진행" >&2; exit 2 ;;
  esac
fi

# 2) codex exec — 비대화·읽기전용. 모델 데드락 시 후보 폴백 1회.
run_codex() {
  codex exec -m "$1" -s read-only -C "$WORKDIR" "$(cat "$PROMPT_FILE")" 2>&1
}
OUT="$(run_codex "$MODEL")"
RC=$?
if [ $RC -ne 0 ] && echo "$OUT" | grep -qiE "model|not found|unsupported|400"; then
  echo "WARN: model=$MODEL 데드락 → gpt-5 폴백 시도" >&2
  OUT="$(run_codex gpt-5)"; RC=$?
fi

if [ $RC -ne 0 ]; then
  echo "CODEX_UNAVAILABLE: codex exec 실패(rc=$RC) — Claude 단독 진행" >&2
  echo "$OUT" >&2
  exit 2
fi

echo "$OUT"
exit 0
