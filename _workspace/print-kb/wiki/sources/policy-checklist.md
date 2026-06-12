# 원천 요약 — 후니프린팅 리뉴얼 정책 체크리스트

> 요약 페이지(Karpathy). 원천=`docs/huni/후니프린팅_리뉴얼_정책체크리스트.xlsx`(5시트).
> 파싱본=`pq/02_business/policy-checklist.md`. ingest D-INGEST-001(2026-06-05).

## 원천 구성
- IA-정책 통합 체크리스트(113 항목) · shopby 분류 요약 · CUSTOM 필수개발(9) · 운영정책 결정사항(25) · 범례.

## 핵심 사실
- **113 IA 정책 중 81%(~92건)가 미결정** — Big-Bang 컷오버 전 정책 워크숍 5~10회 필요.
- 운영정책 25건(배송6·결제5·쿠폰10·리뷰4)은 대부분 **권장안 존재·미확정**(D-PM-31~34).
- D-004 옵션C(자체 빌더 100%) → shopby 분류는 참고만, 전 항목 자체 빌드 대상.
- 9 CUSTOM(파일업로드·가격엔진·옵션보관함·프린팅머니 등)은 shopby 미지원 → 자체 필수.

## 파생 위키 페이지 (이 ingest로 생성/갱신)
membership-auth · mypage · order-payment · shipping · coupon · review · product-pricing · order-mgmt · operations · custom-dev (10 엔티티 페이지).

## ⚠️ 매핑 주의
- 권장안(🟡)을 결정사실로 쓰지 말 것 — 위젯/매핑은 ✅결정만 권위.
- 가격관리 8 모델(PRD-02)은 매핑 직결 — pricing-rules.md per-product와 교차.
