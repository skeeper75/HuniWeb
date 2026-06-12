# 정책 · 주문·결제 (order-payment)

> 엔티티 페이지. 원천: `policy-checklist.md §3.3·§5.2`, `order-flow.md §1.2`(결제케이스).
> 상태: CQ-POL-02 ✅(결제케이스 2독립출처). 운영정책 결제 5건 🟡권장. tags: #정책 #주문 #결제

### [PAY-01] 결제 케이스·상태  {✅결정}
- 내용: 주문 7상태 머신 + 결제케이스(order-flow §1.2). 결제완료→상태전이.
- 출처: policy-checklist §3.3 + order-flow §1.2 (F-삼각 2독립출처) · answers_cq: CQ-POL-02
- 연결: [[order-mgmt#OMG-03]] · tags: #결제 #상태머신

### [PAY-02] PG사 계약  {🔴미결정}
- 내용: 이니시스(기존) 유지 후보. 선택지 이니시스/KCP/토스페이먼츠. 수수료 협상 미정.
- 출처: policy-checklist §5.2 #7·#9 · tags: #PG

### [PAY-03] 간편결제 도입 범위  {🟡권장}
- 내용: 3사 순차(네이버페이→카카오페이→토스페이) 권장.
- 출처: policy-checklist §5.2 #8, §3.3 A-6-5 · tags: #간편결제

### [PAY-04] 결제 실패 안내·할부  {🔴미결정}
- 내용: 실패 안내(팝업/페이지/알림톡) 미정. 할부(무이자 3/6/12 / 일반) 미정.
- 출처: policy-checklist §5.2 #10·#11 · tags: #결제

### [PAY-05] 파일/편집 정보입력  {🔴미결정}
- 내용: 파일업로드 UI/UX 전체 자체 설계(XL). 인쇄 전용, shopby 완전 미지원.
- 출처: policy-checklist §3.3 A-6-1 · 연결: [[custom-dev#CST-01]], [[../../domain-context-model#T3]] · tags: #파일업로드

### [PAY-06] 보관함/장바구니  {🔴미결정}
- 내용: 인쇄옵션 조합 저장(L). shopby 장바구니에 인쇄옵션 저장 불가→자체.
- 출처: policy-checklist §3.3 A-6-2 · 연결: [[mypage#MYP-01]], [[custom-dev#CST-03]] · tags: #장바구니 #옵션보관

### [PAY-07] 배송정보·도서산간  {🟡권장}
- 내용: 제주 +5,000 / 도서산간 +3,000~10,000(권장).
- 출처: policy-checklist §3.3 A-6-3 · 연결: [[shipping#SHIP-05]] · tags: #배송정보

> **연결:** 가치사슬 T2 주문·결제([[../../domain-context-model#T2]]). 비회원([[membership-auth#MEM-05]]).
