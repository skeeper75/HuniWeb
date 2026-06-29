#!/usr/bin/env bash
# prevsite-harvest/harvest_booklet.sh
# 이전사이트(huniprinting.com) 가격조회 AJAX 배치 수집기 — 책자 5상품 OFAT 파일럿
#
# 메커니즘(정찰 prevsite-harvest-method.md): 옵션 선택 시 폼이 GET
#   /upload/product/a_BH01.asp?pcode=..&p01=..&p07=..&p09=..&p18=..&p21_a=.. 호출
#   응답 = "0000::p_w|p_h|..|p08_d|p07_d|..|p10_d|page_unit|p18_d|p21_e|p21_f|.." (:: 상태·| 단가배열)
# 응답 인덱스(BH01): [7]=내지인쇄 [8]=내지용지 [11]=내지코팅 [13]=제본 [14]=표지인쇄 [15..17]=표지추가 [20]=포장
#
# ★라이브 읽기전용 GET만(주문/결제/장바구니/폼제출 전무). gstack 브라우저 1탭 내 fetch(같은 origin·봇차단 회피).
# ★가격 값 정답=권위 엑셀. 이 수집=어느 옵션이 가격을 움직이나(구조/거동 신호)만. 자동 교정·주입 금지.
set -u
B=/Users/innojini/.claude/skills/gstack/browse/dist/browse
SITE="https://www.huniprinting.com/product/goods.asp"
OUT_DIR="$(cd "$(dirname "$0")" && pwd)"
SLEEP="${SLEEP:-0.6}"   # rate-limit 가드(호출 간격)

# 한 GET 호출(브라우저 fetch) → 응답 텍스트
ajax() {  # $1=pcode  $2=querystring(파라미터, dummy= 끝)
  local pc="$1" qs="$2"
  $B js "fetch('/upload/product/a_BH01.asp?pcode=${pc}&${qs}').then(r=>r.text()).then(t=>t.trim())" 2>/dev/null
}

# 응답에서 인덱스 N 단가 추출
field() {  # $1=resp $2=idx
  echo "$1" | sed 's/^[0-9]*:://' | awk -F'|' -v i="$2" '{print $(i+1)}'
}

# 한 상품 OFAT 수집: baseline 고정 + 한 축씩 변경
# 인자: pcode  baseline_qs(p21_a/p09 placeholder 포함, dummy= 끝)
harvest_product() {
  local PC="$1" BASE="$2" NAME="$3"
  echo "############################################################"
  echo "## pcode=$PC  $NAME"
  $B goto "${SITE}?pcode=${PC}" >/dev/null 2>&1; sleep 1
  echo "-- baseline --"
  local r; r=$(ajax "$PC" "$BASE")
  echo "RESP: $r"
  echo "  내지인쇄[7]=$(field "$r" 7) 내지용지[8]=$(field "$r" 8) 내지코팅[11]=$(field "$r" 11) 제본[13]=$(field "$r" 13) 표지인쇄[14]=$(field "$r" 14) 표지추가[15]=$(field "$r" 15) 포장[20]=$(field "$r" 20)"
  sleep "$SLEEP"

  # OFAT 축: 표지인쇄 p21_a (1=단면 2=양면) — ★핵심(표지 양면 가격축)
  echo "-- OFAT 표지인쇄 단면(p21_a=1) vs 양면(p21_a=2) --"
  for v in 1 2; do
    local q="${BASE/p21_a=[0-9]/p21_a=$v}"
    # baseline에 p21_a 없으면 추가
    [[ "$q" == *"p21_a="* ]] || q="${q/dummy=/p21_a=$v&dummy=}"
    local rr; rr=$(ajax "$PC" "$q"); echo "   p21_a=$v → 표지인쇄[14]=$(field "$rr" 14)"
    sleep "$SLEEP"
  done

  # OFAT 축: 내지인쇄 p09 (1=단면 2=양면) — P-1(070 A5 단/양면)
  echo "-- OFAT 내지인쇄 p09=1(단면) vs 2(양면) --"
  for v in 1 2; do
    local q="${BASE/p09=[0-9]/p09=$v}"
    local rr; rr=$(ajax "$PC" "$q"); echo "   p09=$v → 내지인쇄[7]=$(field "$rr" 7) (상태 $(echo "$rr"|cut -d: -f1))"
    sleep "$SLEEP"
  done

  # OFAT 축: 표지코팅 p21_c (0=없음 1=무광 2=유광)
  echo "-- OFAT 표지코팅 p21_c=0/1/2 --"
  for v in 0 1 2; do
    local q="${BASE/p21_c=[0-9]/p21_c=$v}"
    [[ "$q" == *"p21_c="* ]] || q="${q/dummy=/p21_c=$v&dummy=}"
    local rr; rr=$(ajax "$PC" "$q"); echo "   p21_c=$v → 표지추가[15]=$(field "$rr" 15) 표지인쇄[14]=$(field "$rr" 14)"
    sleep "$SLEEP"
  done

  # OFAT 축: 페이지 page (책자별 min/max) — 내지 page파생 확인
  echo "-- OFAT 페이지 변경 (내지인쇄 선형?) --"
  local pmin pmax
  case "$PC" in
    39) pmin=4;  pmax=28 ;;
    36|37) pmin=24; pmax=300 ;;
    38) pmin=8;  pmax=100 ;;
    40) pmin=24; pmax=300 ;;
    *) pmin=24; pmax=100 ;;
  esac
  for v in $pmin $pmax; do
    local q="${BASE/page=[0-9]*&/page=$v&}"; q="${q/page_01=[0-9]*&/page_01=$v&}"
    local rr; rr=$(ajax "$PC" "$q"); echo "   page=$v → 내지인쇄[7]=$(field "$rr" 7) 내지용지[8]=$(field "$rr" 8)"
    sleep "$SLEEP"
  done
  echo ""
}

# ====== 5상품 baseline (★실측 검증·상태 0000 정상 파라미터·2026-06-29) ======
# 정상 공통: p01=129(A5세로 내부코드)·p_width=154·p_height=216(A5 작업)·p07=63(백모120·등급 X)·p08=X(아이젠).
# ★p07/p20/p21_b/p21_c는 상품별 허용값(틀리면 상태 8007=용지검증실패·단가 0). 캡처로 정상값 확정.
$B goto "${SITE}?pcode=38" >/dev/null 2>&1; sleep 1   # 세션 워밍업

#                 pc  p18  p20  표지용지 표지코팅  page  name
harvest_product 39 "p01=129&p_width=154&p_height=216&p07=63&p08=X&p09=2&p10=0&p18=104&qty=10&page=28&page_01=28&page_02=36&p20=05&p21_a=1&p21_b=62&p21_c=0&p21_d=0&p22=&dummy=" "068 중철"
harvest_product 36 "p01=129&p_width=154&p_height=216&p07=63&p08=X&p09=2&p10=0&p18=102&qty=10&page=24&page_01=24&page_02=300&p20=01&p21_a=1&p21_b=64&p21_c=1&p21_d=0&p22=&dummy=" "069 무선"
harvest_product 37 "p01=129&p_width=216&p_height=303&p07=62&p08=X&p09=2&p10=0&p18=101&qty=10&page=24&page_01=24&page_02=300&p20=01&p21_a=1&p21_b=62&p21_c=0&p21_d=0&p22=&dummy=" "070 PUR"
harvest_product 38 "p01=129&p_width=216&p_height=303&p07=62&p08=X&p09=2&p10=0&p18=103&qty=10&page=20&page_01=20&page_02=300&p20=03&p21_a=1&p21_b=62&p21_c=0&p21_d=0&p22=&dummy=" "071 트윈링"
harvest_product 40 "p01=129&p_width=216&p_height=303&p07=62&p08=X&p09=2&p10=0&p18=201&qty=10&page=30&page_01=30&page_02=300&p20=06&p21_a=1&p21_b=108&p21_c=1&p21_d=0&p22=&dummy=" "072 하드커버"

# ★상태코드: 0000=정상 · 8007=표지/용지 검증실패(p07/p20/p21_b 부적합) · 8001/9007=옵션 미충족.
# ★전 상품 확장: pcode당 폼 onchange로 정상 AJAX URL 1회 캡처(XHR 후킹) → 그 URL 템플릿에 OFAT 대입.
#   FORMCODE는 a_<CODE>.asp(책자=BH01·실사=PR01·굿즈=GD01). req_data 인덱스 사전은 폼코드당 1회 매핑.
