# dev-plan-launch.md — 1차 런칭 CUSTOM/PARTIAL 상세 개발방안

> 산출자: hls-gap-analyst. 작성: 2026-06-30.
> 대상: 1차(런칭) Phase 64기능 중 SOLVED 17건을 제외한 **CUSTOM 28 · PARTIAL 19**.
> 권위: IA 정본(162) · Shopby capability 맵(49) · 라이브 As-Is(00_live) · §24 브리지 전략.
> 코드 미작성 — 명세까지. 담을 자리/연동/데이터 계약/트레이드오프/규모/선행조건 명시.
> ★돈·주문 크리티컬 지점은 표면 SOLVED로 넘기지 않고 별도 조명.

---

## 0. 1차 아키텍처 결정 골자 (전 항목 공통 전제)

라이브 As-Is는 **두 주문 모델**로 갈라진다(`launch-scope-detail §A`):
- **견적형**(`product/goods.asp`) — 사이즈(가변 width/height)+코드형 옵션(tmp_pNN)+수량 → 가격계산. = 인쇄 자동견적 핵심.
- **카탈로그형**(`goods/view.asp`) — 단순 qty 선택 완제품.

1차는 이 둘을 **위젯(CPQ)** + **Shopby 커머스 백엔드** + **후니 BFF(중계)** 3층으로 흡수한다.

| 층 | 역할 | 1차 담는 기능 |
|----|------|---------------|
| **위젯(React-in-Shadow-DOM)** | 옵션 선택 UI·제약·실시간 가격표시·파일업로드 | A2·B1~B5·B9·B10·B15·C1·D1·D2·F1·F3·F4 |
| **BFF(후니 중계 서버)** | evaluate_price API화·selections↔Shopby 옵션 환원·생산BOM 환원·파일 식별 | C1·F2·F4·137·157·159 |
| **Shopby(NHN Commerce)** | 회원·장바구니·주문·결제·배송·정산 그릇 | 1·2·4~6·9·22~24·78~81·123·162 |
| **webadmin(현 Django 유지)** | 상품·가격·기초데이터 등록(가격 시뮬레이터) | 100~108·158 |
| **Aurora 스킨** | 회원/마이페이지/상세 storefront 화면 | 회원계열 PARTIAL |

★ **핵심 난제(돈/주문 크리티컬, 표면 SOLVED 금지):**
1. **동적 계산가(evaluate_price) → Shopby 카트 무손실 주입 = 스펙상 불가**(가격 입력 필드 0건, `product-price-bridge-spec §3.1`). 카트 라인가는 서버가 `salePrice+addPrice` 재산출. → 옵션 동기화(P-A)/직전 동적옵션(P-B)/추가금액(P-D)로만 생존.
2. **옵션위젯 ↔ Shopby 옵션 모델 격차** — Shopby 선택옵션 최대 5축·고정 addPrice(E1). 후니 CPQ는 자재·사이즈·도수·후가공·코팅·묶음 등 5축 초과 + 연속/매트릭스. → 일체형 단일상품 불가, 위젯이 옵션 UI를 직접 소유.
3. **주문 → 생산 BOM 환원** — Shopby 주문 라인에는 생산정보 없음. BFF가 selections를 생산BOM으로 환원해 MES 전달.
4. **Edicus 편집/파일 첨부** — Shopby 미제공, 위젯+외부(S3/Edicus).

---

## 1. 동적 가격 (No49 C1 · No62 F2 · No64 F4) — ★최우선 돈 크리티컬

### 1-1. No49 C1 옵션 변경 시 가격 실시간 재계산 [CUSTOM · XL]
- **담을 자리:** 위젯(트리거) + BFF(계산 권위).
- **연동:** 위젯 → BFF `POST /price/evaluate` → 라이브 `evaluate_price(target, selections, qty, grade_cd)` (`pricing.py:468`) → final_price.
- **데이터 계약 골자:** 요청 `{prd_cd, selections{siz_cd|siz_width/height, mat_cd, print_opt_cd, proc_cd[], opt_cd, coat_side_cnt, bdl_qty}, qty, grade_cd}` → 응답 `{final_price, base{components[]}, discounts[], warnings[]}`. 가격 권위=서버(위젯은 표시만, 위젯 단 재계산 금지).
- **트레이드오프:** 옵션 변경마다 라운드트립 → 디바운스·캐싱 필요. 장수기준/면적기준/단가기준 상품군별 계산경로 상이(IA 비고) → evaluate_price가 이미 흡수(단일 권위).
- **선행조건:** evaluate_price API화(읽기전용 호출)·위젯 selections 계약. **PRICE=0 = 결함 신호**(요청/세션 결함, [[huni-widget-red-price-never-zero]] 교훈).
- **규모:** XL (IA 정합).

### 1-2. No62 F2 주문 데이터 생성 (선택옵션 → 주문 변환) [CUSTOM · L] ★돈 크리티컬
- **핵심:** final_price를 Shopby 주문 라인에 무손실로 싣는 브리지. **직접 주입 불가** → 환원 전략.
- **담을 자리:** BFF.
- **개발방안 후보(§24 bridge):**
  - **P-A 사전 옵션 동기화** — 가격분기 조합마다 옵션행(addPrice=후니 가산) 사전 등록. 조합 유한·열거 가능 상품군(고정가형·축≤5)에만 무손실. GREEN ≈60상품 중 고정가형부터. (장점=정산 안전·운영 표준 / 단점=조합 폭발).
  - **P-B 주문 직전 동적옵션** — 1주문 직전 addPrice=계산가 옵션 즉석 등록. 무손실 but **상품심사(judgement) "수정 후 승인대기"가 막을 위험**(OQ-3·M-JUDGE-1) → **자동승인 예외 확인이 관문**.
  - **IA 비고 방식("주문수량 1, 총액을 옵션금액으로 처리")** = 컨테이너 1상품 + 옵션/추가금액으로 총액 = P-D/P-C 혼합 placeholder. 단 정산이 라인가를 권위로 쓰면(OQ-4) 정합 검증 필수.
- **권고:** 1차 파일럿 = **GREEN 고정가형/소조합 상품군에 P-A**(스펙 안전·정산 정합). 연속/매트릭스형(면적·구간)은 P-B 관문(OQ-3) 해소 전까지 **placeholder+정산 정합 검증** 후 단계 확대.
- **데이터 계약:** 위젯 selections+final_price → BFF가 prd_cd↔productNo·selections↔optionNo 매핑테이블로 환원 → `post-cart {productNo, optionNo, orderCnt, optionInputs[사양텍스트]}` (`order-shop §32025`).
- **트레이드오프:** P-A=조합 폭발 운영부담 / P-B=심사 리스크 / placeholder=정산 왜곡 위험.
- **선행조건:** prd_cd↔productNo 매핑 마스터(F1)·OQ-3·OQ-4 결정. **규모 L.**

### 1-3. No64 F4 장바구니 담기 [PARTIAL · M] ★돈 크리티컬
- **Shopby 표준:** `post-cart`(`order-shop:679`)·`get-cart-calculate`(라인가 서버 권위)·`get-cart-validate`(sanity 게이트).
- **보강(CUSTOM 부분):** 위젯 selections → productNo/optionNo 환원(1-2와 동일 매핑). 담기 전 `get-cart-validate {result:bool}`로 sanity(★`purchasable`은 우선구매권한이라 오용 금지·OQ-7).
- **무손실 가능:** 상품·옵션·수량·사양텍스트(F1·F4·F5). **가격은 동기화 등록가일 때만 생존**(calculate 재산출).
- **규모:** M.

---

## 2. 옵션위젯 (No33 A2 · B1~B5 · B9·B10 · No48 B15) — ★옵션 모델 격차

### 2-1. No33 A2 상품별 옵션 목록 불러오기 [CUSTOM · L] ★격차 핵심
- **왜 CUSTOM:** 상품마다 옵션 구성이 다르고(IA), Shopby 선택옵션 5축 제한·고정 addPrice(E1)로 후니 CPQ를 못 담음.
- **담을 자리:** 위젯(렌더) + BFF(옵션 메타 제공).
- **연동:** BFF `GET /widget/options?prd_cd=` → 후니 CPQ `t_prd_product_option_groups/options/option_items` + 차원(`ref_dim_cd`) → 위젯이 옵션 트리 렌더. **Shopby 옵션모델 우회**(Shopby엔 가격분기 표현용 placeholder 옵션만).
- **데이터 계약:** `{groups[{group_cd, label, items[{opt_value, ref_dim_cd, 제약}]}]}`.
- **규모:** L.

### 2-2. B1~B5 사이즈/비규격/수량/소재/도수 [전부 CUSTOM · M each]
- **담을 자리:** 위젯. 각 옵션 선택 → selections 필드(siz_cd·siz_width/height·qty·mat_cd·print_opt_cd).
- **No35 B2 비규격(가로×세로):** Shopby 고정옵션으로 표현 불가(연속) → 위젯 입력→면적 계산, 가격은 evaluate_price.
- **No36 B3 수량:** 후니 구간단가 ↔ Shopby 수량할인 모델 상이(OQ-5) → 구간단가는 final_price에 이미 반영, Shopby 할인=0.
- **규모:** 각 M.

### 2-3. No42 B9 제본 · No43 B10 내지/표지 [CUSTOM · L/M]
- **담을 자리:** 위젯(책자 셋트 옵션군). 제본=셋트 구성(`evaluate_set_price`·구성원별 공식+셋트 제본). 내지/표지 그룹 분리 UI.
- **트레이드오프:** Shopby 세트옵션 분리형 불가(E5) → 책자 셋트는 위젯이 구성·BFF가 evaluate_set_price 호출.

### 2-4. No48 B15 옵션 제약·조건부 노출 [CUSTOM · L] ★제약엔진
- **왜 CUSTOM:** Shopby 옵션 제약 모델 부재. 같이 못 고르는 조합·조건부 노출 = 후니 위젯 제약엔진(JSONLogic).
- **담을 자리:** 위젯(평가) + BFF(constraints 데이터).
- **데이터 계약:** `t_prd_product_constraints` → JSONLogic 규칙 → 위젯이 옵션 변경마다 평가(가격 호출 전 차단·노출 토글).
- **선행조건:** 제약규칙 데이터 정리. **규모 L.**

---

## 3. 파일/편집 (No52 D1 · No53 D2 · No75) — Edicus/업로드

### 3-1. No52 D1 파일 업로드(PDF) [CUSTOM · L]
- **담을 자리:** 위젯(업로드 UI) + 외부(S3) + BFF(식별 결선).
- **연동:** 위젯 → S3 presigned upload → 파일키를 주문라인 `optionInputs[].inputValue`(텍스트 식별)로 전달(가격 무관 첨부). Shopby 라인엔 파일 바이너리 미저장 → 후니DB/S3가 원고 권위.
- **선행조건:** 파일 검수 기준(인쇄팀). **규모 L.**

### 3-2. No53 D2 편집상품 미리보기·썸네일 [CUSTOM · M]
- **담을 자리:** 위젯+BFF. 업로드/편집결과 썸네일 생성·표시. (No10 주문상세 미리보기와 연결.)

### 3-3. No75 파일/편집 정보입력 [CUSTOM · XL]
- 주문 흐름 내 파일·편집정보 입력·첨부 종단(D1+D2+Edicus 진입점). 1차는 PDF 업로드 경로, Edicus(D3)는 3차.

---

## 4. 회원 영역 (No5·21 정보 · No22~24 · No29 대시보드)

### 4-1. No5 정보입력 · No21 회원정보수정 [PARTIAL · M]
- **Shopby 표준:** member `post-profile`·`put-profile`(개인정보).
- **보강:** 라이브 회원 = **개인 + 사업자정보 + 다중주소(개인·회사1·회사2)** (`migration-screen-clues §1-2`, 30+필드). Shopby 표준 프로필에 없는 사업자(상호·사업자번호·대표자·업태/업종)·회사주소2 → **customField/별도 BFF 저장**.
- **데이터 계약:** 표준 프로필 + 후니 확장(`business_info{company, biz_no, owner, uptae, upjong}`, `addr_company2`).
- **선행조건(후속):** legacy 회원 마이그레이션 = migration-designer 영역(잔액·사업자정보·다중주소 매핑).
- **확인필요:** Shopby customField 사업자정보 수용 범위.

### 4-2. No22 비번입력 · No23 비번변경 · No24 탈퇴 [SOLVED · S]
- member `post-profile-check-password`·`change-password-after-cert`·`put-profile-expel` 표준.
- **확인필요:** 비번변경/탈퇴 전 **본인확인 방법 결정**(IA 선행조건·PM).

### 4-3. No29 마이페이지 메인(대시보드) [PARTIAL · S]
- native 마이페이지 + 후니 대시보드 위젯(회원할인율·프린팅머니 잔액·옵션보관 요약) Aurora 스킨 조립.
- **가격/할인 적용순서**(`migration-screen-clues §4`): 상품금액 → 회원할인(%) → 쿠폰 → 프린팅머니/결제. 이 순서를 결제 calculate에 정합.

---

## 5. 상품리스트 (No31 LIST · No153 전시 카테고리 · No66 G1)

### 5-1. No153 전시 카테고리 트리 운영툴 [PARTIAL · M]
- **Shopby 표준:** 전시 카테고리 native 진열.
- **보강:** 라이브 GNB 6 대분류·pcode 약 70종(`launch-scope-detail §A`) → 다depth 진열 운영. As-Is 리스트는 정렬/필터 UI 부재(그리드 나열형) → 신규는 native 진열로 개선.
- **선행조건:** 카테고리 구조 확정.

### 5-2. No31 LIST(검색결과) [PARTIAL · M] · No66 G1 상세 콘텐츠 [PARTIAL · M]
- native 상품 리스트/상세 + Aurora 스킨. 2depth 리스트 랜딩.

---

## 6. 주문/배송/결제 (No76·77·80·81·150·161·162·136·139·140) — 그릇 채택

### 6-1. No162 주문/주문상세 런타임 그릇 구축 [PARTIAL · XL] ★커머스 백엔드
- **핵심:** 라이브 주문테이블 전무(실측·to-be) → **Shopby 주문 도메인을 to-be 그릇으로 채택**(native가 그릇 제공). 후니는 인쇄 사양/파일/BOM을 라인에 결선.
- **담을 자리:** Shopby(주문 그릇) + BFF(인쇄 라인 결선).

### 6-2. No80 결제하기(이니시스) [SOLVED · L] · No81 주문완료 [SOLVED · M]
- order `post-payments-reserve` payType INICIS native + anti-tamper(`paymentAmtForVerification` 서버 재계산).
- **선행조건:** 이니시스 결제 계약(PM). 간편결제는 2차.

### 6-3. No77 배송정보 · No78·79 배송지 [SOLVED/PARTIAL] · No150 도서산간 [PARTIAL · M]
- order shipping-addresses native + 배송설정 native(`remoteDeliveryAmt` 지역추가배송비). **선행조건:** 권역·배송비 정책 확정.

### 6-4. No161 주문상태 추적 [PARTIAL · M]
- order 주문조회 native + **인쇄 생산 상태머신**(미입금→제작중→출고완료) BFF. **확인필요:** Shopby 주문상태 ↔ 인쇄 생산상태 매핑.

### 6-5. No136 주문관리(인쇄/제본/굿즈) [PARTIAL · XL] · No139 주문서출력 · No140 상태변경
- 주문관리 NATIVE + 인쇄 생산정보/파일확인 결선(7-1). 작업지시서 출력 BFF. 상태변경 native(SPEC-SKIN-006 갭)+알림톡.

---

## 7. 생산 브릿지 (No137 파일확인 · No157 생산BOM · No158 MES채번 · No159 Rename) — ★주문 크리티컬

### 7-1. No157 생산정보 전달 (주문→생산BOM 환원) [CUSTOM · L] ★돈/주문 크리티컬
- **왜 CUSTOM:** Shopby 주문 라인엔 생산정보 없음. 결제완료 주문의 selections를 생산BOM으로 환원해 MES 전달.
- **담을 자리:** BFF + MES 연동.
- **데이터 계약:** Shopby 주문 webhook/조회 → 라인 optionInputs/매핑 → selections 복원 → 생산BOM(자재·공정·사이즈·수량) → MES 전달규격.
- **선행조건:** MES↔Front 통신 규격(PM). **규모 L.**

### 7-2. No158 MES_ITEM_CD 전상품 채번 [CUSTOM · M]
- 라이브 16/275만 채번(94% 미채번·실측). webadmin 전상품 채번 체계. JOIN KEY 문제([[railway-db-access]] MES_ITEM_CD NULL) 해소가 생산브릿지 선행.

### 7-3. No137 파일확인처리 [CUSTOM · L] · No159 생산파일명 일관화 [CUSTOM · M]
- 주문건 인쇄파일 검수·확인 BFF. 파일 자동 rename(품목_사이즈_소재_고객_번호_수량). **선행:** 파일 검수 기준·파일명 규칙.

---

## 8. 상품/가격 관리 (No100~108 · webadmin 유지) [전부 CUSTOM]

- **결정:** 현 Django **webadmin 유지**(상품등록·사이즈/소재/용지·가격관리 8종·가격 시뮬레이터). Shopby 상품등록 UI는 CUSTOM(파일/인쇄옵션 미수용·feature-matrix:32) → 후니 webadmin이 권위 등록처, Shopby엔 productNo 동기화만.
- **No108 가격관리(출력/코팅/후가공/제본) [XL]:** evaluate_price가 먹는 t_prc_* 공식·구성요소·단가행 관리 + 시뮬레이터(현 라이브 자산).
- **연동:** webadmin 등록 → BFF가 prd_cd↔productNo·옵션 동기화(P-A) Shopby 반영.
- **확인필요:** webadmin↔Shopby 동기화 범위·주기.

---

## 9. 1차 SOLVED (17건·참고) — native 그대로

로그인(1·2)·회원가입(4·6·8)·비번/탈퇴(22·23·24)·주문조회(9)·배송지(78·79)·결제(80)·주문완료(81)·약관(84·85)·회원관리(123). → Aurora 스킨+설정. 단 **8 가입메일 native 템플릿·23/24 본인확인 방법**은 확인필요.
