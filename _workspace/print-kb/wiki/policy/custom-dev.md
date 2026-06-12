# 정책 · CUSTOM 필수 개발 9종 (custom-dev)

> 엔티티 페이지. 원천: `policy-checklist.md §4`(9 CUSTOM, shopby 미지원→자체 빌드).
> D-004 옵션C: 9종 전부 자체 빌드. tags: #정책 #개발 #custom

### [CST-01] 인쇄 파일 업로드/검수 모듈  {🔴미결정·XL·1순위}
- 내용: 인쇄 전용, shopby 완전 미지원. 주문 프로세스 전체 + PitStop 연동.
- 출처: policy-checklist §4 #1 · 연결: [[order-payment#PAY-05]], [[order-mgmt#OMG-02]] · tags: #파일업로드

### [CST-02] 출력상품 종속옵션 + 가격 엔진  {🔴미결정·XL·1순위}
- 내용: 다단계 종속옵션 + 동적 가격 매트릭스. 상품관리·DB 정규화 의존.
- 출처: policy-checklist §4 #2 · 연결: [[product-pricing#PRD-01]], [[product-pricing#PRD-02]] · tags: #가격엔진 #옵션폼

### [CST-03] 옵션보관함 (재주문)  {🔴미결정·L·1순위}
- 내용: shopby 장바구니에 인쇄옵션 저장 불가. 파일업로드·상품옵션 의존.
- 출처: policy-checklist §4 #3 · 연결: [[mypage#MYP-01]] · tags: #옵션보관함

### [CST-04] 프린팅머니 충전  {🔴미결정·M·1순위}
- 내용: PG 결제→적립금 전환 로직. shopby 적립금 API 연동.
- 출처: policy-checklist §4 #4 · 연결: [[mypage#MYP-02]] · tags: #프린팅머니

### [CST-05] 체험단 관리 시스템  {🔴미결정·L·3순위}
- 내용: 모집/신청/당첨/후기 전체 미지원. (html DB직접입력)
- 출처: policy-checklist §4 #5 · tags: #체험단

### [CST-06] 원장관리 시스템  {🔴미결정·XL·2순위}
- 내용: 온/오프라인 통합 원장. shopby 주문API·거래처 의존. ERP 도입시기 결정 필요.
- 출처: policy-checklist §4 #6 · tags: #원장 #ERP

### [CST-07] B2B 후불결제  {🔴미결정·L·2순위}
- 내용: 후불/정산 시스템. 원장·거래처 의존.
- 출처: policy-checklist §4 #7 · 연결: [[order-mgmt#OMG-04]] · tags: #B2B #후불

### [CST-08] 인쇄 주문상태 트래킹  {🔴미결정·L·1순위}
- 내용: shopby 기본 상태로 인쇄 공정 표현 불가. 커스텀 상태코드 매핑.
- 출처: policy-checklist §4 #8 · 연결: [[order-mgmt#OMG-01]], [[../../domain-context-model#T4]] · tags: #공정상태

### [CST-09] 팀별 통계  {🔴미결정·M·3순위}
- 내용: shopby 통계에 팀/공정 개념 없음. 주문관리·원장·공정관리 연계.
- 출처: policy-checklist §4 #9 · tags: #통계 #공정
