# 정책 · 상품·가격관리 (product-pricing)

> 엔티티 페이지. 원천: `policy-checklist.md §3.4·§3.5`(A-10·B-4-5 가격관리 8종).
> ⚠️ 매핑 직결 — 가격엔진은 8 모델 전부 지원해야 함. tags: #정책 #상품 #가격엔진

### [PRD-01] 출력상품 4종 주문하기  {🔴미결정}
- 내용: 옵션 구조/가격 엔진 자체 설계(XL). 다단계 종속옵션 + 동적 가격 매트릭스.
- 출처: policy-checklist §3.4 A-10-1 · 연결: [[custom-dev#CST-02]], [[../../cq-registry#그룹-2]] · tags: #출력상품 #옵션폼

### [PRD-02] 가격관리 팝업 8종 (B-4-5)  {🔴미결정}
- 내용: 8 상품군별 가격모델 — DP02/04/06=PriceTable3D, GD01=TieredDiscount A, GD02=TieredDiscount B, PK01=FixedUnit/Matrix, PR01=PriceTable3D+제본, PR02=SizeMatrix2D.
- 출처: policy-checklist §3.5 + pricing-rules.md(§3·§7·§9·§11·§12) · answers_cq: CQ-PRICE-01
- 연결: [[../../source-registry#1차]] · tags: #가격모델 #가격엔진

### [PRD-03] 수작(SUJAK) 브랜드 존치  {🟡권장}
- 내용: 존치 권장(차별화 브랜드 자산). As-Is buysangsang 별도 노출. D-PM-30.
- 출처: policy-checklist §3.4 A-10-4, §7 D-PM-30 · tags: #브랜드 #수작

> **연결:** 가격 도메인 전체는 [[../../cq-registry#그룹-2]] + pq/pricing-rules + dbm round-2(t_prc_*).
> 자체 빌더 가격엔진 = 8 모델 지원 필수(cross-mapping §3.3 일치).
