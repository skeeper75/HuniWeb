# EARS 요구사항 — 후니프린팅 자동견적 시스템

**작성:** 2026-05-27 (pq-business-analyst)
**포맷:** EARS (Easy Approach to Requirements Syntax)
**ID 체계:** `REQ-PQ-NNN` (PQ = Print-Quote)
**우선 등급:** HIGH (V1 필수) / MED (V1.5 권장) / LOW (V2 이후)

---

## EARS 5 유형 범례

| 유형 | 형식 | 사용 |
|------|------|------|
| **U** (Ubiquitous) | "시스템은 ~해야 한다" | 항상 적용되는 불변 |
| **EV** (Event) | "시스템은 [이벤트] 시 ~해야 한다" | 이벤트 트리거 |
| **ST** (State) | "시스템은 [상태]일 때 ~해야 한다" | 상태 의존 |
| **OP** (Optional) | "[선택조건]이면, 시스템은 ~해야 한다" | 선택 기능 |
| **UN** (Unwanted) | "시스템은 [원치 않는 이벤트] 시 ~해야 한다" | 예외 처리 |

---

## 1. 상품 카탈로그 (REQ-PQ-001 ~ 019)

### REQ-PQ-001 [U] HIGH
**Statement:** 시스템은 12개 대분류, 약 240개 상품 SKU의 카탈로그를 보유해야 한다.
**출처:** product-master.md §4
**검증:** SKU 카운트 ≥ 240, 카테고리 = 12.

### REQ-PQ-002 [U] HIGH
**Statement:** 시스템은 각 상품마다 MES ITEM_CD(`NNN-NNNN` 형식)를 유일 키로 부여해야 한다.
**출처:** product-master.md §3, D-PM-04
**검증:** unique constraint on `mes_item_cd`.

### REQ-PQ-003 [U] HIGH
**Statement:** 시스템은 각 상품에 카테고리·중분류·기본사이즈·기본종이·기본도수·주문방법(파일업로드/편집기)을 필수 속성으로 보유해야 한다.
**출처:** product-master.md §2

### REQ-PQ-004 [U] MED
**Statement:** 시스템은 상품 카테고리를 3-depth 트리(대분류 → 중분류 → 상품)로 구성해야 한다.
**출처:** product-master.md §4.1
**예외:** 책자(006)/포토북(150301)은 4-depth 허용 (1500/1501/1503/150301).

### REQ-PQ-005 [EV] HIGH
**Statement:** 시스템은 신규 상품 등록 시 MES ITEM_CD를 자동 발급(카테고리 prefix + 다음 일련번호)해야 한다.
**출처:** D-PM-01 (010·011 카테고리 미부여 해결)
**검증:** 010 카테고리 신규 상품 등록 시 `010-0001`부터 자동 부여.

### REQ-PQ-006 [U] HIGH
**Statement:** 시스템은 상품마다 공정 라우트(process_route)를 1개 이상 매핑해야 한다 (process-flow.md Case 1~17).
**출처:** process-flow.md §6, D-PM-19

### REQ-PQ-007 [OP] MED
**Statement:** 상품이 외주 가공을 필요로 하면, 시스템은 외주처 정보와 외주 발주서 템플릿을 보유해야 한다.
**출처:** order-flow.md §6.4

### REQ-PQ-008 [U] HIGH
**Statement:** 시스템은 종이/소재 마스터(약 200종)를 보유하고, 상품별 사용 가능 소재를 다대다로 매핑해야 한다.
**출처:** product-master.md §7 (출력소재 IMPORT 시트)

### REQ-PQ-009 [U] HIGH
**Statement:** 시스템은 8축 옵션 모델(사이즈/종이/도수/단양면/수량/후가공/제본/가공옵션)을 상품별로 구성 가능하게 해야 한다.
**출처:** product-master.md §7
**검증:** 각 상품의 옵션 정의가 8축을 cover.

### REQ-PQ-010 [U] HIGH
**Statement:** 시스템은 상품 옵션 간 종속 관계(예: 후가공 박은 박명함 상품만)를 표현할 수 있어야 한다.
**출처:** policy-checklist.md CUSTOM #2 (다단계 종속옵션)

### REQ-PQ-011 [OP] MED
**Statement:** 사이즈가 비규격(`custom_size`)인 상품이면, 시스템은 가로/세로 직접 입력 + 사이즈 매트릭스 보간을 지원해야 한다.
**출처:** pricing-rules.md §16.4

### REQ-PQ-012 [U] HIGH
**Statement:** 시스템은 사용자 식별(이메일/아이디)을 운영자가 선택할 수 있게 하고, 기본은 이메일로 동작해야 한다.
**출처:** policy-checklist.md A-1-1

### REQ-PQ-013 [U] HIGH
**Statement:** 시스템은 비회원 주문을 허용해야 한다(주문번호+휴대전화로 조회 가능).
**출처:** policy-checklist.md A-2-GUEST

### REQ-PQ-014 [U] MED
**Statement:** 시스템은 회원 등급을 4단계로 운영하고, 등급별 혜택을 정책 가능하게 해야 한다.
**출처:** policy-checklist.md B-6-GRADE

### REQ-PQ-015 [U] HIGH
**Statement:** 시스템은 카카오·네이버 SNS 로그인을 1차 지원해야 한다. 구글·애플은 2차.
**출처:** policy-checklist.md A-1-SNS, A-1-SNS2

### REQ-PQ-016 [UN] HIGH
**Statement:** 시스템은 동일 이메일로 중복 가입을 시도하면, 실시간으로 중복 알림을 표시하고 가입을 차단해야 한다.
**출처:** policy-checklist.md A-2-3

### REQ-PQ-017 [EV] HIGH
**Statement:** 시스템은 휴대전화 인증 완료 시 1인 1계정 제약을 자동 강제해야 한다.
**출처:** policy-checklist.md A-2-4

### REQ-PQ-018 [EV] MED
**Statement:** 시스템은 회원가입 완료 시 가입 혜택 쿠폰(신규 10,000원, 최소주문 50,000원) + 적립금을 자동 발급해야 한다.
**출처:** policy-checklist.md A-2-5, D-PM-33

### REQ-PQ-019 [U] HIGH
**Statement:** 상품마스터의 카테고리 010(라이프), 011(에코백) 100+ 상품도 ITEM_CD를 부여받아야 한다 (현재 미부여 상태 해결).
**출처:** product-master.md §6 PM-MISS-01, D-PM-01

---

## 2. 가격 엔진 (REQ-PQ-020 ~ 039)

### REQ-PQ-020 [U] HIGH
**Statement:** 시스템은 4가지 가격 모델(PriceTable3D, SizeMatrix2D, FixedUnit, TieredDiscount)을 지원해야 한다.
**출처:** pricing-rules.md §16, D-PM-08

### REQ-PQ-021 [U] HIGH
**Statement:** 시스템은 수량 입력 시 가격을 0.5초 이내에 계산하여 표시해야 한다.
**출처:** policy-checklist.md A-10-1 (동적 가격 매트릭스)
**검증:** UI 응답 시간 < 500ms.

### REQ-PQ-022 [U] HIGH
**Statement:** 시스템은 수량 구간 보간 시 "다음 큰 구간 단가"를 사용해야 한다 (예: 12장 입력 시 15장 구간 단가).
**출처:** pricing-rules.md D-PM-10

### REQ-PQ-023 [U] HIGH
**Statement:** 시스템은 디지털인쇄 단가표를 7도수(흑백/CMYK/화이트/클리어/핑크/금/은) × 단/양면 × 53구간 수량으로 보유해야 한다.
**출처:** pricing-rules.md §3 (디지털인쇄비 시트 116행)

### REQ-PQ-024 [U] HIGH
**Statement:** 시스템은 사이즈 매트릭스(포스터·아크릴)에서 입력 사이즈가 정의된 셀에 없으면 bilinear 보간으로 단가를 산출해야 한다.
**출처:** pricing-rules.md §16.4

### REQ-PQ-025 [OP] HIGH
**Statement:** 상품이 사이즈 매트릭스 범위를 벗어나면, 시스템은 단가/m² × 입력면적으로 외삽해야 한다.
**출처:** pricing-rules.md §16.4 (3000mm 초과)

### REQ-PQ-026 [OP] HIGH
**Statement:** 상품이 수량 할인 대상(아크릴·굿즈·파우치·문구·말랑)이면, 시스템은 base price 합산에 할인율을 적용해야 한다.
**출처:** pricing-rules.md §9

### REQ-PQ-027 [U] HIGH
**Statement:** 시스템은 후가공·옵션·제본 비용을 base price와 분리하여 견적 명세에 표시해야 한다.
**출처:** pricing-rules.md §16.2 (LineItem)

### REQ-PQ-028 [U] HIGH
**Statement:** 시스템은 박명함의 동판비(아연판 기본 5,000원) + 박 가공비를 별도 라인 아이템으로 합산해야 한다.
**출처:** pricing-rules.md §5.2

### REQ-PQ-029 [U] HIGH
**Statement:** 시스템은 모든 단가 표시에 부가세를 포함해야 한다.
**출처:** pricing-rules.md D-PM-15

### REQ-PQ-030 [U] MED
**Statement:** 시스템은 견적서 출력 시 VAT를 별도로 분리 표시할 수 있어야 한다(견적서/세금계산서용).
**출처:** pricing-rules.md §16.1 `vatAmount`

### REQ-PQ-031 [EV] HIGH
**Statement:** 시스템은 가격 구성요소(base/finish/option/binding/discount) 변경 시 실시간으로 견적을 갱신해야 한다.
**출처:** policy-checklist.md A-10-1

### REQ-PQ-032 [U] HIGH
**Statement:** 시스템은 최소 주문 단위·증가 단위 정책을 product master에 명시 보유해야 한다.
**출처:** pricing-rules.md §14, D-PM-14

### REQ-PQ-033 [UN] HIGH
**Statement:** 시스템은 사용자가 최소 주문 단위 미만을 입력하면 가격 계산을 거부하고 가이드 메시지를 표시해야 한다.
**출처:** pricing-rules.md §14

### REQ-PQ-034 [U] HIGH
**Statement:** 시스템은 포토카드 입력 수량이 20장이면 세트 가격(6,000원), 21장 이상이면 대량 가격으로 자동 전환해야 한다.
**출처:** pricing-rules.md D-PM-11

### REQ-PQ-035 [U] HIGH
**Statement:** 시스템은 인쇄소재(종이) 200종 중 인기 50종을 기본 노출하고, "더보기"로 200종 전체에 접근 가능해야 한다.
**출처:** pricing-rules.md D-PM-13

### REQ-PQ-036 [U] MED
**Statement:** 시스템은 8종 가격관리 팝업(DP02/DP04/DP06/GD01/GD02/PK01/PR01/PR02)을 관리자 UI로 제공해야 한다.
**출처:** policy-checklist.md B-4-5

### REQ-PQ-037 [U] HIGH
**Statement:** 가격 엔진은 단가표 sentinel `1,000,000` 행을 수량 무한대 처리로 인식해야 한다.
**출처:** pricing-rules.md PRC-002

### REQ-PQ-038 [U] HIGH
**Statement:** 시스템은 견적 결과를 LineItem 배열로 사용자에게 명세 표시해야 한다 (산식 포함).
**출처:** pricing-rules.md §16.1 `breakdown`

### REQ-PQ-039 [U] MED
**Statement:** 시스템은 옵션보관함에 인쇄 옵션 조합을 저장하여, 재주문 시 동일 견적을 재생성할 수 있어야 한다.
**출처:** policy-checklist.md A-3-3 (보관 3개월)

---

## 3. 주문·결제 (REQ-PQ-040 ~ 062)

### REQ-PQ-040 [U] HIGH
**Statement:** 시스템은 주문 상태를 7개 노드(unpaid/paid/preparing/producing/done/shipped/cancelled)로 관리해야 한다.
**출처:** order-flow.md §1

### REQ-PQ-041 [U] HIGH
**Statement:** 시스템은 결제 5가지 수단(카드/포인트/에스크로/가상계좌/신용결제)을 지원해야 한다.
**출처:** order-flow.md §1.2

### REQ-PQ-042 [EV] HIGH
**Statement:** 시스템은 이니시스 카드 승인 이벤트 수신 시 unpaid → paid로 자동 전이해야 한다.
**출처:** order-flow.md §2.1

### REQ-PQ-043 [EV] HIGH
**Statement:** 시스템은 가상계좌 입금 시 unpaid → paid로 자동 전이해야 한다.
**출처:** order-flow.md §2.1

### REQ-PQ-044 [EV] HIGH
**Statement:** 시스템은 가상계좌 미입금 3일 경과 시 자동 unpaid → cancelled로 전이해야 한다.
**출처:** order-flow.md D-PM-21

### REQ-PQ-045 [EV] HIGH
**Statement:** 시스템은 자동 취소 1일 전 알림톡(+SMS fallback)을 발송해야 한다.
**출처:** order-flow.md §3.1 (#011)

### REQ-PQ-046 [EV] HIGH
**Statement:** 시스템은 모든 상품의 파일 상태가 "포장완료"가 되면 주문을 producing → done으로 자동 전이해야 한다.
**출처:** order-flow.md §1.3

### REQ-PQ-047 [U] HIGH
**Statement:** 시스템은 파일 상태 머신을 상품 타입별로 보유해야 한다 — 배송상품(2상태), 파일업로드(5상태), 편집기상품(5상태).
**출처:** order-flow.md §1.3

### REQ-PQ-048 [EV] HIGH
**Statement:** 시스템은 11개 자동 알림(001~011)을 트리거 이벤트별로 자동 발송해야 한다.
**출처:** order-flow.md §3.1

### REQ-PQ-049 [U] HIGH
**Statement:** 시스템은 모든 알림에 대해 카카오 알림톡 우선 + SMS fallback 구조를 적용해야 한다.
**출처:** order-flow.md D-PM-22

### REQ-PQ-050 [OP] HIGH
**Statement:** 사용자가 결제 수단으로 간편결제를 선택하면, 시스템은 1차 도입된 PG(이니시스+네이버페이)를 지원해야 한다.
**출처:** policy-checklist.md D-PM-32

### REQ-PQ-051 [U] HIGH
**Statement:** 시스템은 한 주문에 N개 송장을 부여할 수 있어야 한다 (현 As-Is 1:1 강제 해결).
**출처:** order-flow.md §6.8

### REQ-PQ-052 [EV] HIGH
**Statement:** 시스템은 송장 출력 이벤트 시 done → shipped 전이 + 자동알림 #009를 발송해야 한다.
**출처:** order-flow.md §2.1

### REQ-PQ-053 [U] HIGH
**Statement:** 시스템은 배송비를 무료배송 기준(10만원) 미달 시 기본 배송비(3,000원)로 자동 부과해야 한다.
**출처:** policy-checklist.md D-PM-31

### REQ-PQ-054 [OP] HIGH
**Statement:** 배송지가 제주이면, 시스템은 추가배송비 5,000원을 자동 부과해야 한다.
**출처:** policy-checklist.md #5, D-PM-31

### REQ-PQ-055 [OP] HIGH
**Statement:** 배송지가 도서산간이면, 시스템은 거리 구간(4단계)별 추가배송비(3,000/5,000/7,000/10,000원)를 자동 부과해야 한다.
**출처:** policy-checklist.md #6, D-PM-31

### REQ-PQ-056 [OP] HIGH
**Statement:** 주문에 배너 상품이 포함되면, 시스템은 해당 상품을 무료배송 대상에서 제외해야 한다.
**출처:** policy-checklist.md #3

### REQ-PQ-057 [U] HIGH
**Statement:** 혼합 주문(다중 상품)의 배송비는 최고값 1건만 적용해야 한다.
**출처:** policy-checklist.md #4

### REQ-PQ-058 [U] HIGH
**Statement:** 시스템은 무통장 입금이 합산되어 들어와도 시스템이 자동 매칭할 수 있도록, 가상계좌 발급 시 1:1 매핑을 보장해야 한다.
**출처:** order-flow.md §6.6 (As-Is Pain)

### REQ-PQ-059 [U] HIGH
**Statement:** 시스템은 인쇄 옵션 조합 + 디자인 파일을 함께 장바구니에 보관할 수 있어야 한다.
**출처:** policy-checklist.md A-6-2 (Shopby 미지원 CUSTOM)

### REQ-PQ-060 [OP] MED
**Statement:** 환불이 부분환불이면, 시스템은 주문 취소 처리를 하지 않고 정산 메모필드에 기록해야 한다(매출 무결성).
**출처:** order-flow.md D-PM-26

### REQ-PQ-061 [EV] MED
**Statement:** 시스템은 재제작 발생 시 MES 내 주문복사 또는 오프라인 주문으로 처리하고, 반송 여부를 체크해야 한다.
**출처:** order-flow.md §8.1

### REQ-PQ-062 [U] LOW
**Statement:** 시스템은 세금계산서 발행 여부와 발행날짜를 주문 정보에 보유해야 한다.
**출처:** order-flow.md §9 (V1 정보수집, V2 팝빌 자동연동)

---

## 4. 파일 업로드·검수 (REQ-PQ-063 ~ 078)

### REQ-PQ-063 [U] HIGH
**Statement:** 시스템은 인쇄 타입별 강제 파일 포맷을 검증해야 한다 (디지털인쇄=PDF, 실사=JPG/PDF, 박/도장=AI, 등).
**출처:** order-flow.md §10.1, D-PM-28

### REQ-PQ-064 [UN] HIGH
**Statement:** 시스템은 잘못된 파일 포맷 업로드 시 즉시 거부하고 가이드 메시지를 표시해야 한다.
**출처:** order-flow.md D-PM-28

### REQ-PQ-065 [U] HIGH
**Statement:** 시스템은 업로드된 파일에 대해 PitStop 자동 검수(해상도/CMYK/블리드/폰트)를 수행해야 한다.
**출처:** policy-checklist.md CUSTOM #1

### REQ-PQ-066 [EV] HIGH
**Statement:** 시스템은 파일 검수 결과가 결함이면 재업로드 요청 알림(#003)을 자동 발송해야 한다.
**출처:** order-flow.md §3.1

### REQ-PQ-067 [U] HIGH
**Statement:** 시스템은 모든 업로드 파일에 표준 파일명을 자동 부여해야 한다 (`발주일_품목_사이즈_양단면_소재_거래처_고객_고유번호_수량`).
**출처:** order-flow.md §7, D-PM-24

### REQ-PQ-068 [EV] HIGH
**Statement:** 시스템은 접수파일 등록 시 서버에서 자동 썸네일을 생성해야 한다.
**출처:** order-flow.md §11.1

### REQ-PQ-069 [OP] HIGH
**Statement:** 접수파일이 AI 포맷이면, 시스템은 함께 업로드된 JPG로 썸네일을 생성해야 한다.
**출처:** order-flow.md §11.2 Case 2

### REQ-PQ-070 [U] HIGH
**Statement:** 시스템은 자유형 스티커·아크릴스티커에서 출력파일(PDF)과 칼선파일(AI CS9)을 분리 보유 및 분리 배포해야 한다.
**출처:** order-flow.md §6.3

### REQ-PQ-071 [U] HIGH
**Statement:** 시스템은 디지털인쇄·캘린더·떡메모지의 종이명·사양을 파일명에 자동 포함해야 한다.
**출처:** order-flow.md §6.2

### REQ-PQ-072 [U] HIGH
**Statement:** 시스템은 별색 인쇄 상품(5도/9도)의 도수 정보를 파일명에 자동 포함해야 한다.
**출처:** order-flow.md D-PM-25

### REQ-PQ-073 [U] HIGH
**Statement:** 시스템은 다도안 상품의 판걸이 수를 자동 계산하여 표시해야 한다 (판걸이수 시트 활용).
**출처:** process-flow.md §9 To-Be 시사

### REQ-PQ-074 [U] HIGH
**Statement:** 시스템은 부서별 파일 다운로드 권한을 강제해야 한다 (디지털인쇄팀=001, 특수=002, 커팅=003, 쿠마샵=005).
**출처:** order-flow.md §4.4

### REQ-PQ-075 [U] HIGH
**Statement:** 시스템은 "생산다운 여부 Y" 상품 + 제작중 상태의 파일만 생산팀이 다운로드할 수 있게 해야 한다.
**출처:** order-flow.md §11.5

### REQ-PQ-076 [OP] MED
**Statement:** Edicus SDK를 통해 편집된 디자인이면, 시스템은 Edicus Prepress 렌더링 결과를 자동 접수파일로 사용해야 한다.
**출처:** D-003 (Edicus 외부 의존)

### REQ-PQ-077 [EV] MED
**Statement:** 편집기 상품의 랜더링 완료 시, 시스템은 고객에게 미리보기 + 수정요청 옵션을 제시해야 한다.
**출처:** order-flow.md §1.3 Case 3

### REQ-PQ-078 [U] HIGH
**Statement:** 시스템은 모든 접수파일을 AWS S3에 저장하고, 부서별 다운로드는 CloudFront CDN을 통해 제공해야 한다.
**출처:** order-flow.md D-PM-29

---

## 5. 공정 추적 (REQ-PQ-079 ~ 093)

### REQ-PQ-079 [U] HIGH
**Statement:** 시스템은 17개 공정 라우트(Case 1~17)를 마스터로 보유하고, 상품에 1개 이상 매핑해야 한다.
**출처:** process-flow.md §1.1, D-PM-19

### REQ-PQ-080 [U] HIGH
**Statement:** 각 공정은 4단계 상태(대기/완료/주의/불량)로 트래킹되어야 한다.
**출처:** process-flow.md §2.3

### REQ-PQ-081 [EV] HIGH
**Statement:** 시스템은 출력완료/커팅완료/제본시작/봉재시작/가공시작/제작완료/송장출력 7종 바코드 입력 이벤트를 처리해야 한다.
**출처:** process-flow.md §4

### REQ-PQ-082 [UN] HIGH
**Statement:** 시스템은 앞공정이 완료되지 않으면 다음공정 바코드 입력을 차단해야 한다(D-PM-17 강한 차단).
**출처:** process-flow.md §4 To Do

### REQ-PQ-083 [OP] HIGH
**Statement:** 운영자 권한 사용자가 우회를 요청하면, 시스템은 사유 입력 후 우회를 허용하고 감사 로그에 기록해야 한다.
**출처:** D-PM-17

### REQ-PQ-084 [U] HIGH
**Statement:** 시스템은 부서별 일일 KPI(당일 대기/완료/주의/불량 + 누적)를 실시간 대시보드로 제공해야 한다.
**출처:** process-flow.md §2.1, §2.2

### REQ-PQ-085 [U] MED
**Statement:** 시스템은 공정별 평균 리드타임·제작기간을 자동 집계해야 한다 (V1 후 실측치 수집).
**출처:** process-flow.md §3.2

### REQ-PQ-086 [OP] MED
**Statement:** 박명함·박 후가공 상품이면, 시스템은 동판제작·박작업 외주 발주서를 자동 생성해야 한다.
**출처:** process-flow.md §1.3, order-flow.md §11.3

### REQ-PQ-087 [OP] MED
**Statement:** 책자가 수량·크기 임계값을 초과하면, 시스템은 선택적 외주 발주를 안내해야 한다.
**출처:** order-flow.md §11.3

### REQ-PQ-088 [U] HIGH
**Statement:** 시스템은 4단계 검수 게이트(G1=파일/G3=가공/G4=출고)를 V1에서 필수로 운영해야 한다.
**출처:** process-flow.md §7.1, D-PM-20

### REQ-PQ-089 [U] MED
**Statement:** 시스템은 외주 발주서를 외주처별로 자동 생성하고 EXCEL 다운로드 가능해야 한다.
**출처:** order-flow.md §11.3

### REQ-PQ-090 [U] HIGH
**Statement:** 시스템은 1차포장·박스포장 시 바코드 입력으로 상태를 자동 전이해야 한다.
**출처:** process-flow.md §4

### REQ-PQ-091 [U] MED
**Statement:** 시스템은 송장 출력 시 배송정보(우편번호·주소·연락처)를 자동 입력해야 한다(수기 입력 해소).
**출처:** order-flow.md §6.8

### REQ-PQ-092 [U] MED
**Statement:** 시스템은 합배송 리스트를 출고팀이 조회할 수 있도록 별도 화면을 제공해야 한다.
**출처:** order-flow.md §6.8

### REQ-PQ-093 [U] MED
**Statement:** 시스템은 수동 조판 상품(틴거울·아크릴상품·자석북마크)을 별도 워크큐로 관리해야 한다.
**출처:** order-flow.md §11.4

---

## 6. 회원·정책 (REQ-PQ-094 ~ 110)

### REQ-PQ-094 [U] HIGH
**Statement:** 시스템은 적립금(프린팅머니)을 회원별로 보유하고 충전·사용·소멸 정책을 운영해야 한다.
**출처:** policy-checklist.md A-3-5

### REQ-PQ-095 [EV] HIGH
**Statement:** 시스템은 프린팅머니 충전 결제 완료 시 PG 결제액을 적립금으로 자동 전환해야 한다.
**출처:** policy-checklist.md CUSTOM #4

### REQ-PQ-096 [U] HIGH
**Statement:** 시스템은 쿠폰을 회원별 발급·사용·만료·자동회수 가능하게 운영해야 한다.
**출처:** policy-checklist.md A-3-4

### REQ-PQ-097 [U] HIGH
**Statement:** 시스템은 쿠폰 최대 동시 사용 3개를 강제해야 한다.
**출처:** policy-checklist.md #20, D-PM-33

### REQ-PQ-098 [U] HIGH
**Statement:** 시스템은 쿠폰 유효기간 30일(기본)을 적용해야 한다.
**출처:** policy-checklist.md #21, D-PM-33

### REQ-PQ-099 [EV] HIGH
**Statement:** 시스템은 배송완료 14일 후 리뷰유도 쿠폰(5,000원)을 자동 발행해야 한다.
**출처:** policy-checklist.md #14~#15, D-PM-33

### REQ-PQ-100 [EV] HIGH
**Statement:** 시스템은 회원의 월 누적 주문 200,000원 도달 시 재구매 쿠폰(20,000원)을 자동 발행해야 한다.
**출처:** policy-checklist.md #16~#17, D-PM-33

### REQ-PQ-101 [EV] HIGH
**Statement:** 시스템은 회원의 연 누적 주문 1,000,000원 도달 시 VIP 쿠폰(30,000원)을 자동 발행해야 한다.
**출처:** policy-checklist.md #18~#19, D-PM-33

### REQ-PQ-102 [EV] HIGH
**Statement:** 시스템은 사진 포함 리뷰 작성 시 추가 1,000원 적립금을 자동 지급해야 한다.
**출처:** policy-checklist.md #25, D-PM-34

### REQ-PQ-103 [EV] HIGH
**Statement:** 시스템은 리뷰 삭제 시 발급되었던 쿠폰/적립금을 자동 회수해야 한다.
**출처:** policy-checklist.md #24, D-PM-34

### REQ-PQ-104 [U] MED
**Statement:** 시스템은 회원 등급(4단계)을 3개월 누적 주문액 기준으로 자동 산정해야 한다.
**출처:** policy-checklist.md B-6-GRADE

### REQ-PQ-105 [U] MED
**Statement:** 시스템은 사업자정보·현금영수증정보를 마이페이지에서 등록·수정 가능하게 해야 한다.
**출처:** policy-checklist.md A-3-15

### REQ-PQ-106 [U] HIGH
**Statement:** 시스템은 5종 가이드 콘텐츠(작업시 유의사항)에 체크박스 의무화로 면책 동의를 받아야 한다.
**출처:** policy-checklist.md A-8-1

### REQ-PQ-107 [U] HIGH
**Statement:** 시스템은 B2B 후불결제 회원을 별도 관리하고 미결제/결제완료 상태로 분리 운영해야 한다.
**출처:** policy-checklist.md B-8-8

### REQ-PQ-108 [U] MED
**Statement:** 시스템은 거래처(B2B) 마스터를 보유하고 유형분류·결제조건을 운영해야 한다.
**출처:** policy-checklist.md B-2-1

### REQ-PQ-109 [U] HIGH
**Statement:** 시스템은 오프라인 주문을 동일 order 엔티티 + `channel='offline'` 플래그로 통합 관리해야 한다.
**출처:** order-flow.md D-PM-23

### REQ-PQ-110 [U] MED
**Statement:** 시스템은 수작 브랜드를 별도 카테고리로 존치하되, 단일 통합 카탈로그에 노출해야 한다.
**출처:** policy-checklist.md D-PM-30

---

## 7. 시스템·인프라 (REQ-PQ-111 ~ 120)

### REQ-PQ-111 [U] HIGH
**Statement:** 시스템은 Next.js 15 기반의 자체 빌더로 구축되어야 한다.
**출처:** D-004 (옵션 C)

### REQ-PQ-112 [U] HIGH
**Statement:** 시스템은 Shopby Server API를 BFF로 활용하되, 회원·주문·결제 일부에 한정해야 한다(가격·옵션·견적·에디터는 자체 구축).
**출처:** D-004

### REQ-PQ-113 [U] HIGH
**Statement:** 시스템은 Edicus SDK 외부 의존(edicusbase.firebaseapp.com)을 유지해야 한다 (디자인 에디터 영역).
**출처:** D-003

### REQ-PQ-114 [UN] MED
**Statement:** 시스템은 Edicus SDK 장애 시 파일 업로드 모드로 fallback해야 한다(현 O-002 미결).
**출처:** O-002 (decisions.md)

### REQ-PQ-115 [U] HIGH
**Statement:** 시스템은 외부 브랜드명(Edicus, Aurora, MShop)을 사용자 노출 라벨에 사용해서는 안 된다.
**출처:** glossary.md D-PM-35

### REQ-PQ-116 [U] HIGH
**Statement:** 시스템은 모든 통화를 KRW로 표시하고 소수점 0자리를 사용해야 한다.
**출처:** pricing-rules.md §15.1 (C_findings confirmed)

### REQ-PQ-117 [U] HIGH
**Statement:** 시스템은 견적·주문·파일 데이터에 대한 감사 로그(audit log)를 보유해야 한다.
**출처:** REQ-PQ-083 + 컴플라이언스

### REQ-PQ-118 [U] MED
**Statement:** 시스템은 4채널(BIZ/FUJI/HUNI/CONTINUE) OEM 주문을 통합 주문 데이터로 흡수해야 한다.
**출처:** order-flow.md §6.1

### REQ-PQ-119 [U] HIGH
**Statement:** 시스템은 모든 출고지를 단일화하여 운영해야 한다 (오프라인 주문 외).
**출처:** order-flow.md §4 박스 명기

### REQ-PQ-120 [U] HIGH
**Statement:** 시스템은 Big-Bang 컷오버로 buysangsang.com WP + huniprinting48.shopby.co.kr를 동시 폐기하고 단일 To-Be로 전환해야 한다.
**출처:** D-002, D-004

---

## 8. 요구사항 통계

| 분류 | 건수 | EARS 유형 분포 |
|------|--:|--|
| 상품 카탈로그 | 19 (REQ-001~019) | U:11, EV:2, OP:2, UN:1, +혼합 |
| 가격 엔진 | 20 (REQ-020~039) | U:13, EV:1, OP:3, UN:1, +혼합 |
| 주문·결제 | 23 (REQ-040~062) | U:11, EV:5, OP:4, UN:0, +혼합 |
| 파일 업로드·검수 | 16 (REQ-063~078) | U:12, EV:2, OP:2, UN:1, +혼합 |
| 공정 추적 | 15 (REQ-079~093) | U:11, EV:1, OP:2, UN:1, +혼합 |
| 회원·정책 | 17 (REQ-094~110) | U:9, EV:5, OP:1, UN:0, +혼합 |
| 시스템·인프라 | 10 (REQ-111~120) | U:9, EV:0, OP:0, UN:1 |
| **합계** | **120** | U:76, EV:16, OP:14, UN:5, ST:0 |

| 우선 등급 | 건수 |
|-----|--:|
| HIGH (V1 필수) | 92 |
| MED (V1.5 권장) | 24 |
| LOW (V2 이후) | 4 |

---

## 9. 변경 이력

| 버전 | 일자 | 변경 | 작성자 |
|------|------|------|------|
| 1.0 | 2026-05-27 | 초기 작성 — REQ-PQ-001~120 (120건) | pq-business-analyst |

---

## 10. 출처

- product-master.md §1~§7 (상품 카탈로그 19 REQ)
- pricing-rules.md §1~§18 (가격 엔진 20 REQ)
- order-flow.md §1~§14 (주문·결제·파일 39 REQ)
- process-flow.md §1~§10 (공정 추적 15 REQ)
- policy-checklist.md §1~§9 (회원·정책 17 REQ)
- glossary.md (용어·라벨 1 REQ)
- decisions.md D-001 ~ D-004, O-001 ~ O-005 (시스템·인프라 10 REQ)
- cross-mapping.md §1~§7 (마이그레이션 영향)
