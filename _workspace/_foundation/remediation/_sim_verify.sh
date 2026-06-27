#!/usr/bin/env bash
# 가격시뮬레이터 검증 헬퍼 — 로그인 세션 재사용. 결과 요약만 출력.
B=~/.claude/skills/gstack/browse/dist/browse
SIM="https://huni-admin-production.up.railway.app/admin/price-simulator/"

pick_product() { # $1=검색어 (정확매칭 우선)
  $B goto "$SIM" >/dev/null 2>&1
  $B fill @e1 "$1" >/dev/null 2>&1; sleep 1
  local ref
  ref=$($B snapshot -C 2>&1 | grep -iE "cursor:pointer.*$1" | grep -oE "@c[0-9]+" | head -1)
  [ -z "$ref" ] && { echo "PRODUCT_NOT_FOUND: $1"; return 1; }
  $B click "$ref" >/dev/null 2>&1; sleep 1
}
sel_dropdown() { # $1=field ref, $2=검색어 → 첫 매칭 클릭
  $B fill "$1" "$2" >/dev/null 2>&1; sleep 1
  local opt; opt=$($B snapshot -C 2>&1 | grep -iE "cursor:pointer.*$2" | grep -oE "@c[0-9]+" | head -1)
  [ -n "$opt" ] && $B click "$opt" >/dev/null 2>&1; sleep 1
}
compute_read() {
  local calc; calc=$($B snapshot -i 2>&1 | grep "가격 계산" | grep -oE "@e[0-9]+" | head -1)
  $B click "$calc" >/dev/null 2>&1; sleep 2
  # 결과 요약 라인만
  $B text 2>&1 | grep -oE "(수량 [0-9]+ · 추가상품 [0-9]+건[0-9,]+ 원|수량 [0-9]+[0-9,]+ 원|총 합계 \(본품\+추가상품\)[0-9,]+원|본품 [0-9,]+ \+ 추가상품 [0-9,]+|제외 · (데이터 없음|해당 없음)|경고 [0-9]|단가 미정|PRICE_TYPE)" | tr '\n' ' '
  echo ""
}
fields() { $B snapshot -i 2>&1 | grep -oE "@e[0-9]+ \[[a-z]+\] \"[^\"]*\"" | head -12; }
"$@"
