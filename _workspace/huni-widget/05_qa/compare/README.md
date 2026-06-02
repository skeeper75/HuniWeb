# 위젯 비교 검증 하네스 (compare)

우리 위젯(Huni)을 레퍼런스(Red)와 **나란히 눈으로 빠르게 대조**하기 위한 검증 스캐폴드.
디자인 품질 심사가 아니라 "우리 위젯이 제대로 구현됐는가"를 빠르게 확인하는 환경.

## 구성 (의존성 0, 순수 HTML/JS + iframe)

| 파일 | 역할 |
|------|------|
| `compare.html` | 3분할 비교 페이지 (좌: 우리 / 가운데: Red / 우: 검증 패널) |
| `compare.css` | 스타일 (DESIGN.md 토큰 일부 차용) |
| `compare.js` | 뷰포트 폭·새로고침·스크롤 동기화·체크리스트·진행률 |
| `serve.js` | Node 내장 모듈만 쓰는 정적 서버 (포트 4173) |

## 실행

```bash
# 1) 우리 위젯 dev 서버 (보통 이미 떠 있음): http://localhost:5173
#    (huni-widget/04_build 에서 vite dev — 이미 실행 중이면 그대로 둘 것)

# 2) Red 레퍼런스 테스트베드: http://localhost:3001
cd raw/widget_monitor/local && node server.js

# 3) 비교 하네스 정적 서버: http://localhost:4173
cd _workspace/huni-widget/05_qa/compare && node serve.js
```

→ 브라우저에서 **http://localhost:4173/compare.html** 열기.

## 한눈에 비교할 수 있는 것

- 좌(우리)·가운데(Red) 같은 폭으로 나란히 → 같은 옵션을 양쪽에 직접 눌러 대조
- 우측 **검증 체크리스트 10항목**: 옵션 그룹 노출 / 캐스케이드 / 가격 재계산 / 수량 입력 / 후가공 토글 / 가격 요약 / 에디터·업로드 진입 / 선택상태 시각 / 컬러칩 형태 / CSS 격리
- **4-Zone 구조표** + 브랜드 컬러 스와치 (DESIGN.md 시각 의도)
- 상단: 뷰포트 폭 전환 · 양쪽 새로고침 · 스크롤 동기화 토글 · 체크 진행률

## 기준 라벨

- **우리 (파랑)** = 구현 결과물
- **Red (빨강)** = 동작 정답 (가격·캐스케이드·상호작용)
- **DESIGN (보라)** = 시각 의도 (`_workspace/print-quote/04_design/DESIGN.md`)

## 주의

- 두 위젯은 **별개 코드베이스** → 자동 옵션 동기화는 **의도적으로 미구현**(과설계 방지). 같은 값을 손으로 맞춰 비교.
- Red의 RP 토큰이 만료되면 **렌더·상호작용은 정상**이나 라이브 가격은 안 뜰 수 있음 → 정상. 갱신: `cd raw/widget_monitor/local && node extract-cookies.cjs`
- 스크롤 동기화는 cross-origin iframe 내부 스크롤을 읽을 수 없어 **바깥 컨테이너 스크롤만** 동기화(근사).
- Figma 원본 `docs/figma/huni_product_option.fig` 는 바이너리 → 인라인 불가(참고용). 시각 기준은 DESIGN.md.
