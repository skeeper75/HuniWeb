#!/bin/bash
# verify-batch-v2-260908.sh — t45 v2 기계 검증 배치 (증거 로그: verify-batch-v2-260908.txt)
# 실행: bash verify-batch-v2-260908.sh 2>&1 | tee verify-batch-v2-260908.txt
set -u
D="$(cd "$(dirname "$0")" && pwd)"
H="$D/huni-staffbrief-260909.html"
MD="$D/huni-staffbrief-260909.md"
DRAFT="$D/huni-staffbrief-260909-draft.md"
PDF="$D/huni-staffbrief-260909.pdf"

echo "== (1) HTML 크기 (한도 122,880B) =="
ls -l "$H" | awk '{print $5" bytes"}'
S=$(stat -f%z "$H"); if [ "$S" -le 122880 ]; then echo "PASS ($S <= 122880, 여유 $((122880-S))B)"; else echo "FAIL"; fi

echo; echo "== (2) 외부 참조 (허용 예외: 폰트 CDN 2종·mermaid CDN 1종) =="
grep -o 'https://[^"'\'' )]*' "$H" | sort | uniq -c | sort -rn

echo; echo "== (3) 브랜드 토큰 =="
echo "#5538B6 count: $(grep -o '#5538B6' "$H" | wc -l | tr -d ' ')"
echo "#553886(오기) count: $(grep -o '#553886' "$H" | wc -l | tr -d ' ')"
echo "Noto Sans KR 선언: $(grep -c 'Noto+Sans+KR' "$H")"

echo; echo "== (4) 금지 서술 grep (전부 0이어야 PASS) =="
echo "전부 주문 가능(html): $(grep -c '전부 주문 가능' "$H" || true)"
echo "전부 주문 가능(draft): $(grep -c '전부 주문 가능' "$DRAFT" || true)"
echo "가격 없는 상품(html): $(grep -c '가격 없는 상품' "$H" || true)"
echo "가격 없는 상품(draft): $(grep -c '가격 없는 상품' "$DRAFT" || true)"
echo "'설계만 됐다'류 감평(html): $(grep -c '설계만 됐' "$H" || true)"

echo; echo "== (5) findings 8건 적용 확인 =="
echo "word-break:keep-all: $(grep -c 'word-break:keep-all' "$H")"
echo "@page 선언: $(grep -c '@page{' "$H")"
echo ".keep 컨테이너(고아 h2 방지): $(grep -c 'class=\"keep\"' "$H")"
echo "nowrap(SPEC ID 보호): $(grep -c 'class=\"nowrap\"' "$H")"
echo "keymsg(핵심 메시지): $(grep -c 'class=\"keymsg\"' "$H")"
echo "캡션 색 #6F6F6F(대비 상향): $(grep -c '#6F6F6F' "$H") (구 #979797 잔존: $(grep -o '#979797' "$H" | wc -l | tr -d ' '))"
echo "figure.fig(이미지): $(grep -c '<figure class=\"fig\"' "$H")"
echo "data:image/webp(임베딩): $(grep -o 'data:image/webp;base64' "$H" | wc -l | tr -d ' ')"

echo; echo "== (6) 스크립트 구조 =="
echo "<script> 수: $(grep -c '<script' "$H") · <noscript> 수: $(grep -c '<noscript>' "$H")"

echo; echo "== (7) 라이브 위젯 어휘(React 문맥 검사) =="
grep -o 'React[^<.]*' "$H" | head -4
echo "shadcn: $(grep -c 'shadcn' "$H" || true) · Zustand: $(grep -c 'Zustand' "$H" || true)"

echo; echo "== (8) PDF =="
ls -l "$PDF" | awk '{print $5" bytes"}'
echo "페이지번호(1/17형): $(pdftotext -f 1 -l 1 "$PDF" - 2>/dev/null | grep -c '^1/17$')"
echo "페이지번호(17면): $(pdftotext -f 17 -l 17 "$PDF" - 2>/dev/null | grep -c '^17/17$')"
echo "이미지 캡션 텍스트층: $(pdftotext "$PDF" - 2>/dev/null | grep -c '핀버튼 주문위젯 실화면')"
echo "mermaid 폴백(noscript) 텍스트층: $(pdftotext "$PDF" - 2>/dev/null | grep -c '다이어그램 대체 설명')"

echo; echo "== (9) md twin 무결성(부풀림 제외 확인) =="
echo "식당 비유 twin 수록(0이어야): $(grep -c '식당에 비유' "$MD" || true)"
echo "twin에 v2 신규 섹션: $(grep -c '오픈 준비' "$MD") · $(grep -c '실무 시나리오' "$MD") · $(grep -c '컴포넌트 실사용 분포' "$MD")"

echo; echo "== (10) 매뉴얼 권위 표기 =="
echo "'2026-09-06 재생성' 언급(html): $(grep -c '2026-09-06 재생성' "$H")"
echo "baseline은 동절참조 문맥만: $(grep -o '2026-08-24[^<]*' "$H" | head -2)"
echo "== END =="
