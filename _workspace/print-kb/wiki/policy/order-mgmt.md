# 정책 · 주문관리·검수 (order-mgmt, 관리자)

> 엔티티 페이지. 원천: `policy-checklist.md §3.6`(B-8), `order-flow.md §1·§5`, `process-flow.md §7`.
> tags: #정책 #관리자 #주문관리 #검수

### [OMG-01] 주문관리(인쇄/제본/굿즈)  {🔴미결정}
- 내용: 작업상태 트래킹(L). shopby 기본 상태로 인쇄 공정 표현 불가→커스텀 상태코드.
- 출처: policy-checklist §3.6 B-8-1 · 연결: [[custom-dev#CST-08]], [[../../domain-context-model#T4]] · tags: #작업상태

### [OMG-02] 파일확인처리(검수)  {🔴미결정}
- 내용: 검수 프로세스 미정(XL). PitStop 연동 후보.
- 출처: policy-checklist §3.6 B-8-4 · 연결: [[custom-dev#CST-01]] · answers_cq: CQ-FILE-04 · tags: #파일검수

### [OMG-03] 주문상태변경 처리(+문자)  {🔴미결정}
- 내용: 상태 체계 미정. order-flow §1 7상태 머신 기반.
- 출처: policy-checklist §3.6 B-8-7 · 연결: [[order-payment#PAY-01]] · tags: #상태변경 #알림

### [OMG-04] 후불결제 관리  {🔴미결정}
- 내용: 미결제/결제완료 관리(L, 2순위). B2B 후불/정산.
- 출처: policy-checklist §3.6 B-8-8 · 연결: [[custom-dev#CST-07]] · tags: #후불 #B2B

### [OMG-05] 검수 게이트 (To-Be 제안)  {⚪명세}
- 내용: G1 파일·G2 출력·G3 가공·G4 출고 4게이트 제안(현행 아님). G1·G3·G4 V1 권장.
- 출처: process-flow.md §7 (D-PM-20) · tags: #검수게이트 #ToBe

### [OMG-06] 조직별 권한 (7조직)  {✅결정}
- 내용: 7개 조직 업무·권한(order-flow §5.1). 단, 세부 접근제어는 xlsx 미명시.
- 출처: order-flow.md §5.1 · answers_cq: CQ-POL-07 · tags: #권한 #조직

### [OMG-07] 오프라인 주문 별도 처리  {✅결정}
- 내용: 오프라인 주문은 관리자 별도 처리 경로.
- 출처: order-flow.md §5.2 · answers_cq: CQ-POL-06 · tags: #오프라인주문
