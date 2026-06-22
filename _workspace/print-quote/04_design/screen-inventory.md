# 화면 인벤토리 — 후니프린팅 V1 리뉴얼 (huni-ia-master 기준 재작성)

- 작성일: 2026-05-28 (v2.0 재작성) · 최종 갱신 2026-05-31 (v2.4 — Wowpress 회원영역 벤치마크 owner 결정 반영)
- 작성자: pq-designer (v2.1~2.4 pq-pm)
- **기준 문서:** `02_business/huni-ia-master.md` 112건 + sitemap.md(v2.4)
- 재작성 사유: v1.0(buysangsang 141화면, BFF-S Shopby 위임 표기)을 폐기. huni IA 단일 관리자·B-2 자체 백엔드·Aurora 배제 반영.
- 컬럼: ID / 화면명 / 카테고리 / V / 우선 / 핵심 REQ / 도메인 엔티티 / 위젯 / **백엔드 종속** / 비고
- 우선순위 약어: HI=HIGH / ME=MED / LO=LOW

## 0. 백엔드 종속 범례 (B-2 결정 반영 — commerce-backend-scenario.md)

> **중요(v1.0 대비 변경):** "BFF-S(Shopby 위임)" 표기 전면 폐기. 회원/카트/주문/주문내역/CS = 자체구축. 결제 = 이니시스. 따라서 다음 4 값만 사용.

- `자체` = 자체 API (회원·인증·카트·주문·주문내역·CS·가격엔진·옵션·견적·카탈로그·통계). Shopby Server API는 백업 위치이며 화면 설계는 자체 기준.
- `이니시스` = KG이니시스 PG 직연동 (결제·가상계좌·환불). 결제 화면은 자체, PG는 위젯/리다이렉트.
- `에디터` = 외부 디자인 편집기 SDK (iframe 슬롯). D-PM-35 "에디터" 라벨.
- `별도트랙` = huni-ia-master IA 미반영, 빌더/생산운영 트랙(sitemap §4). V1? 협의.
- 보조: `+SMS/알림톡`, `+팝빌(V2)`, `+S3`, `+OAuth` = 외부 부가 연동.

## 0.1 위젯 ID 범례 (block-schema.md §2)
`section` / `text` / `image` / `button` / `product_gallery` / `option_panel` / `quote_preview` / `form_field` / `media_slider` / `tabs` / `mega_menu` / `editor_slot`(외부 편집기) / `rich_card` / `image_upload`(다중 이미지 업로드, SC-MY-19·리뷰사진) / `상태추적`(접수→처리→완료 상태 타임라인, SC-MY-19 재작업신청)

---

## 1. 쇼핑몰 (고객) — huni-ia-master §1 (61건)

### 1.1 인증 (IA 1~7)

| ID | 화면명 | 카테고리 | V | 우선 | 핵심 REQ | 도메인 엔티티 | 위젯 | 백엔드 종속 | 비고 |
|---|---|---|:-:|:-:|---|---|---|---|---|
| SC-AC-01 | 로그인(일반) | 인증 | V1 | HI | 012, 015 | Member | section, form_field, button | 자체+OAuth | SNS 추가 |
| SC-AC-02 | 아이디 찾기(이메일 발송) | 인증 | V1 | ME | — | Member | section, form_field, button | 자체+메일 | 마스킹 |
| SC-AC-03 | 비밀번호 찾기(휴대폰 임시PW) | 인증 | V1 | ME | — | Member | section, form_field, button | 자체+알림톡 | 알림톡 계약 필요 |
| SC-AC-04 | 회원가입-약관동의 | 인증 | V1 | HI | — | Member | section, form_field, button | 자체 | 전체동의 |
| SC-AC-04.1 | 회원가입-정보입력 | 인증 | V1 | HI | 016 | Member | section, form_field, button | 자체 | 실시간 중복 |
| SC-AC-05 | 이메일 중복확인 | 인증 | V1 | HI | 016 | Member | form_field | 자체 | |
| SC-AC-06 | 휴대전화 인증 | 인증 | V1 | HI | 017 | Member | section, form_field, button | +SMS/PASS | 1인1계정 |
| SC-AC-07 | 가입완료+메일 발송 | 인증 | V1 | ME | 018 | Member, Coupon | section, text, rich_card | 자체+메일 | 혜택 안내 |

### 1.2 마이페이지 (IA 8~19)

| ID | 화면명 | 카테고리 | V | 우선 | 핵심 REQ | 도메인 엔티티 | 위젯 | 백엔드 종속 | 비고 |
|---|---|---|:-:|:-:|---|---|---|---|---|
| SC-MY-01 | 주문조회(주문내역) | 마이페이지 | V1 | HI | 040, 048 | Order, OrderStatusHistory, Payment | section, tabs, text, button | 자체 | 7-superstate 필터. **D-DS-38 보강** — 무통장 입금대기 상태 필터/탭 + 상단 강조 배너(가상계좌·마감시한). 별도화면 금지 |
| SC-MY-01.1 | 주문상세(편집상품 미리보기) | 마이페이지 | V1 | HI | 040, 077 | Order, OrderItem, ArtworkFile, DesignProject | section, text, image, editor_slot | 자체+에디터 | 편집상품 미리보기 |
| SC-MY-02 | 옵션보관함 → "내 견적함" | 마이페이지 | V1 | HI | 039, 062 | Quote, QuoteLine | section, quote_preview, button | 자체 | 재주문 불러오기. **D-DS-38 보강** — 재주문 진입점 + 견적서 PDF 출력(SC-MY-12.5 연계) + 가격 재계산 액션. 인쇄옵션 의미한정 유지(디자인자산 3중구조) |
| SC-MY-03 | 쿠폰관리 | 마이페이지 | V1 | HI | 096 | Coupon, CouponUsage | section, tabs, rich_card | 자체 | |
| SC-MY-03.1 | 쿠폰등록 | 마이페이지 | V1 | ME | 097 | Coupon | form_field, button | 자체 | 로그인 상태만 |
| SC-MY-04 | 프린팅머니(잔액·내역) | 마이페이지 | V1 | HI | 094, 095 | LoyaltyPoint | section, text, tabs | 자체 | |
| SC-MY-04.1 | 머니충전 | 마이페이지 | V1 | HI | 095 | LoyaltyPoint, Payment | section, form_field, button | 자체+이니시스 | PG 결제 |
| SC-MY-05 | 나의 상품Q&A+문의 | 마이페이지 | V1 | ME | — | Review/QnA | section, form_field, button | 자체 | ❌보강(상품Q&A) |
| SC-MY-06 | 나의 리뷰 | 마이페이지 | V1 | ME | 099, 102 | Review | section, tabs, text | 자체 | 즉시노출+쿠폰발행 |
| SC-MY-06.1 | 리뷰쓰기(사진) 수정/삭제 | 마이페이지 | V1 | ME | 099, 103 | Review | form_field, image, button | 자체+S3 | 삭제 시 쿠폰회수 |
| SC-MY-07 | 나의 체험단 활동 | 마이페이지 | V2 | LO | — | Member | section, text | 자체 | 당첨자만 후기 |
| SC-MY-08 | 1:1문의+문의하기 | 마이페이지 | V1 | ME | — | QnA | section, form_field, button | 자체 | **D-DS-40 보강** — 작성폼 문의유형 카테고리(결제/회계·출고/배송·품질·일반). 화면 신설 아님. business-analyst 카테고리 정의 영역 |
| SC-MY-09 | 회원정보수정 | 마이페이지 | V1 | ME | — | Member | section, form_field, button | 자체 | |
| SC-MY-09.1 | 회원정보수정_비번입력 | 마이페이지 | V1 | LO | — | Member | form_field, button | 자체 | 수정 전 재확인 |
| SC-MY-10 | 비밀번호변경 | 마이페이지 | V1 | LO | — | Member | form_field, button | 자체 | |
| SC-MY-11 | 회원탈퇴 | 마이페이지 | V1 | LO | — | Member | section, form_field, button | 자체 | |
| SC-MY-12 | 증빙서류발급내역 | 마이페이지 | V1 | ME | 062, 105 | Order, Payment | section, tabs, text | 자체+팝빌(V2) | 4상태 |
| SC-MY-12.1 | 사업자정보 목록 | 마이페이지 | V1 | ME | 105 | Member | section, text | 자체 | |
| SC-MY-12.2 | 사업자정보 등록 | 마이페이지 | V1 | ME | 105 | Member | form_field, button | 자체 | |
| SC-MY-12.3 | 현금영수증정보 | 마이페이지 | V1 | LO | 105 | Member | form_field | 자체 | D-DS-33 Decided 2026-05-30 |
| SC-MY-12.4 | 거래명세서 출력(주문→PDF) | 마이페이지 | V1 | ME | 062 | Order, OrderItem | section, text, button | 자체 | **D-DS-38 신설 B2B핵심.** 주문번호 선택→거래명세서 PDF. 세금계산서(12.2)와 별개 납품 첨부 |
| SC-MY-12.5 | 견적서 출력(주문→PDF) | 마이페이지 | V1 | ME | 062 | Order, OrderItem, Quote | section, text, button | 자체 | **D-DS-38 신설 B2B핵심.** 구매 품의·결재용 견적서 PDF. 내 견적함(SC-MY-02)에서도 출력 진입 |
| SC-MY-13 | 관심상품(찜) | 마이페이지 | V1 | ME | — | Wishlist, Product | section, product_gallery, button | 자체 | **As-Is 보강** 디자인자산①. D-DS-36 |
| SC-MY-14 | 저장된 디자인(편집 보관) | 마이페이지 | V1 | ME | 039, 077 | DesignProject, ArtworkFile | section, rich_card, editor_slot, button | 자체+에디터 | **As-Is 보강** 디자인자산②. 옵션보관함(SC-MY-02)과 별개. D-DS-36 |
| SC-MY-15 | 내 디자인의뢰 내역 | 마이페이지 | V2 | LO | 062 | Inquiry, DesignProject | section, text | 자체+에디터 | 디자인자산④. 의뢰(SC-Q-14) V2 연동 |
| SC-MY-16 | 통합 게시판(내 게시글) | 마이페이지 | V2 | LO | — | QnA, Review | section, tabs, text | 자체 | **As-Is 보강** 부가 통합 뷰 |
| SC-MY-17 | (용도미상 thm) | 마이페이지 | 확인대기 | — | — | (미확인) | (미확인) | (미확인) | **As-Is `mypage/thm` 용도 미확인 — 추측 금지(HARD).** 라벨 수집 후 분류 |
| SC-MY-18 | 배송주소록 관리(다중 배송지) | 마이페이지 | V1 | ME | 054, 055 | **Address** | section, text, form_field, button | 자체 | **벤치마크 보강 B2B핵심. D-DS-38.** Address(domain-model §3.2 기존: user_id/label/recipient/postal/road/detail/is_default) 연결. 주문흐름 배송지(SC-Q-11.1/11.2)가 이 주소록 소비 — 단일 Address 공유 |
| SC-MY-19 | 재작업신청(인쇄 불량·오류 재제작) | 마이페이지 | V1 | ME | 060, 061 | **Order**, OrderItem, ArtworkFile | section, form_field, image_upload, 상태추적 | 자체+S3 | **벤치마크 신설 인쇄 CS 품질 핵심. D-DS-40.** 원주문(SC-MY-01.1) 연결 + 불량유형·불량사진 업로드 + 처리상태 추적 워크플로우. SC-MY-08 1:1문의(자유서술)와 분리한 전용 정형 창구. 환불(rfds)·별도트랙 SC-CLAIM(TR-CLAIM)과의 통합은 **설계 시 세부화**(이번엔 신설만). Wowpress `rwrk` 답습 아닌 정형 프로세스 완전성 검증 |

### 1.3 고객센터 (IA 20~26)

| ID | 화면명 | 카테고리 | V | 우선 | 핵심 REQ | 도메인 엔티티 | 위젯 | 백엔드 종속 | 비고 |
|---|---|---|:-:|:-:|---|---|---|---|---|
| SC-CS-01 | 공지사항 | 고객센터 | V1 | ME | — | Page/Notice | section, tabs, text | 자체 | 이벤트/공지/상품 구분 |
| SC-CS-02 | 자주묻는질문 | 고객센터 | V1 | ME | — | FAQ | section, tabs, text | 자체 | 4분류 |
| SC-CS-03 | 상품Q&A+문의(게시판) | 고객센터 | V1 | ME | — | QnA | section, form_field, text | 자체 | ❌보강 |
| SC-CS-04 | 대량주문 견적문의 | 고객센터 | V1 | ME | 030 | InquiryQuote | section, form_field, button | 자체 | ❌보강 B2B핵심. D-DS-33 |
| SC-CS-05 | 기업인쇄상담 | 고객센터 | V1 | LO | — | Inquiry | section, form_field, button | 자체 | ❌보강 B2B핵심. D-DS-33 |
| SC-CS-06 | 디자인상담(게시판형) | 고객센터 | V1 | ME | 062 | Inquiry, DesignProject | section, form_field, button, editor_slot | 자체+에디터 | ❌보강. D-DS-33(V2→V1). ⚠복잡도: DesignProject+에디터(Edicus) 결합 — §1.3 캐비엇 |
| SC-CS-07 | 비회원 주문조회(3키) | 고객센터 | V1 | HI | 013 | Order | section, form_field, button | 자체 | 주문번호+이메일+휴대폰 |

> **⚠ 디자인상담(SC-CS-06 / 관리자 답변 SC-A-34) 복잡도 캐비엇 (D-DS-33, 2026-05-30):**
> 디자인상담은 단순 게시판 폼이 **아니다.** 상담 접수 시 `DesignProject` 엔티티가 생성·연동될 수 있고, 시안 검토·편집을 위해 외부 디자인 편집기(Edicus, `editor_slot` iframe)와 결합한다. 따라서:
> - SC-CS-06은 `Inquiry + DesignProject` 이중 엔티티, `editor_slot` 위젯, `자체+에디터` 백엔드 종속을 가진다 (SC-CS-04/05 단순 문의와 구분).
> - 관리자 답변(SC-A-34)도 DesignProject 상태 참조·에디터 미리보기 연계가 필요할 수 있어 SC-A-32/33(순수 게시판 답변)보다 구현 비용이 높다.
> - **구현 권고:** SC-CS-06/SC-A-34는 V1 범위이나 SPEC 분할 시 B2B 게시판(SC-CS-04/05)과 **별도 SPEC**으로 분리하고, DesignProject·editor_slot 의존을 명시한 뒤 우선순위를 한 단계 낮춰(ME) 일정 리스크를 격리한다. (디자인 의뢰 SC-Q-14는 여전히 V2.)

### 1.4 견적·주문·결제 (IA 27~32, 40~43)

| ID | 화면명 | 카테고리 | V | 우선 | 핵심 REQ | 도메인 엔티티 | 위젯 | 백엔드 종속 | 비고 |
|---|---|---|:-:|:-:|---|---|---|---|---|
| SC-Q-01 | 상품페이지(상품옵션) | 견적 | V1 | HI | 003, 009, 020 | Product, Specification, OptionGroup, PriceTable | section, media_slider, option_panel, quote_preview, button | 자체 | 견적 진입(IA-19↳*) |
| SC-Q-02 | 출력상품 4종 주문하기 | 견적 | V1 | HI | 009, 021, 031 | Specification, SpecOption, SpecRule, Quote, QuoteLine | option_panel, quote_preview, form_field | 자체 | 견적 마법사 핵심·0.5초 응답 |
| SC-Q-02.1 | 옵션저장/견적인쇄 팝업 | 견적 | V1 | HI | 038, 039 | Quote | section, text, button | 자체 | IA-40 팝업 |
| SC-Q-02.2 | 비규격 사이즈 입력 모달 | 견적 | V1 | HI | 011, 024, 025 | Specification | form_field, text | 자체 | 보간/외삽 배지 |
| SC-Q-03 | 포장재상품 주문하기 | 견적 | V1 | ME | 009, 021 | Product, Quote | option_panel, quote_preview, button | 자체 | 문의/견적인쇄 |
| SC-Q-04 | 굿즈상품 주문+파우치&백 | 견적 | V1 | ME | 026 | Product, Quote, DiscountPolicy | option_panel, quote_preview | 자체 | 굿즈 전용 옵션 |
| SC-Q-10 | 파일/편집 정보입력(Step3) | 주문 | V1 | HI | 047, 063, 076 | Quote, ArtworkFile, DesignProject | section, button, rich_card, form_field, editor_slot | 자체+에디터+S3 | 3분기(파일/에디터/의뢰) |
| SC-Q-10.1 | 보관함/장바구니 | 주문 | V1 | HI | 039, 059 | Cart, CartItem, Quote | section, quote_preview, button | 자체 | 옵션+파일 묶음 |
| SC-Q-11 | 배송정보입력 | 주문 | V1 | HI | 054, 055 | Order, Address, ShippingMethod | section, form_field, button | 자체 | 도서산간 4구간 |
| SC-Q-11.1 | 배송지목록 | 주문 | V1 | ME | — | Address | section, text, button | 자체 | |
| SC-Q-11.2 | 배송지입력 | 주문 | V1 | ME | — | Address | form_field, button | 자체 | |
| SC-Q-12 | 결제하기(이니시스 연동) | 결제 | V1 | HI | 041, 042, 050 | Payment, Order | section, form_field, button | 자체+이니시스 | 간편결제 통합형, 포인트 전액 |
| SC-Q-12.1 | 결제 실패 모달 | 결제 | V1 | ME | — | Payment | section, text, button | 이니시스 | 사유·재시도 |
| SC-Q-12.2 | 가상계좌 안내(3일 자동취소) | 결제 | V1 | HI | 043, 044, 045 | Payment, Order | section, text, button | 이니시스 | 카운트다운+알림 |
| SC-Q-13 | 주문완료+메일 발송 | 주문 | V1 | HI | 040 | Order, OrderStatusHistory | section, text, button | 자체+메일 | superstate=paid |
| SC-Q-14 | 디자인 의뢰하기 | 주문 | V2 | ME | 062 | DesignProject | section, form_field, button | 자체 | V2 deferred |

### 1.5 정보·가이드·마케팅·전역 페이지 (IA 33~39, 19↳*)

| ID | 화면명 | 카테고리 | V | 우선 | 핵심 REQ | 도메인 엔티티 | 위젯 | 백엔드 종속 | 비고 |
|---|---|---|:-:|:-:|---|---|---|---|---|
| SC-M-01 | 메인 홈 | 마케팅 | V1 | HI | 001, 003 | Page, Product, Category | section, media_slider, product_gallery, rich_card | 자체 | 전역(IA-19↳*) |
| SC-M-02 | 서브메인(랜딩, 1depth) | 마케팅 | V1 | ME | 004 | Page | section, media_slider, rich_card | 자체 | 프로모션 이미지 등록 |
| SC-M-03 | LIST(검색결과/리스팅, 2depth) | 카탈로그 | V1 | HI | 001, 004 | Product, Category | section, product_gallery, form_field, tabs | 자체 | 정렬·필터 |
| SC-M-04 | 랜딩페이지 5종 | 마케팅 | V2 | LO | — | Page | section, media_slider | 자체 | 종이/제본/캘린더/파우치/스티커 |
| SC-M-05 | 이용후기 메인 | 마케팅 | V1 | ME | 099 | Review | section, rich_card, image | 자체 | ❌보강. D-DS-33 Decided 2026-05-30 |
| SC-M-06 | 체험단 모집 메인 | 마케팅 | V2 | LO | — | Page | section, media_slider | 자체 | |
| SC-M-07 | 수작 상품(메인+상품) | 마케팅 | V2 | ME | 110 | Category, Product | section, product_gallery | 자체 | D-PM-30 갱신 2026-05-30 — V1 제외·V2 재평가(브랜드 자산 보존) |
| SC-M-09 | 회사소개 | 정보 | V1 | LO | — | Page | section, text, image | 자체 | 정적 |
| SC-M-10 | 이용약관 | 정보 | V1 | ME | — | Page | section, text | 자체 | |
| SC-M-10.1 | 개인정보보호 | 정보 | V1 | ME | — | Page | section, text | 자체 | |
| SC-M-11 | 찾아오시는 길 | 정보 | V2 | LO | — | Page | section, text, image | 자체 | |
| SC-M-12 | 작업 시 유의사항(11개) | 가이드 | V1 | HI | 106 | Page | section, tabs, text, image | 자체 | 모니터색/재단선/용지 |
| SC-M-13 | 운영 안내 팝업 4종 | 가이드 | V1 | LO | 106 | Page | section, text, image | 자체 | **As-Is 보강** 도장신청·업로드안내·웹하드·디자인안내(`info/pop_*`). D-DS-36 |

---

## 2. 관리자 — huni-ia-master §2 (51건) — 단일 관리자 V1

### 2.1 관리자·거래처·원장 (IA 44~49)

| ID | 화면명 | 카테고리 | V | 우선 | 핵심 REQ | 도메인 엔티티 | 위젯 | 백엔드 종속 | 비고 |
|---|---|---|:-:|:-:|---|---|---|---|---|
| SC-A-01 | 관리자 등록/관리 | 어드민 공통 | V2 | ME | — | Member | section, form_field, button | 자체 | 세분권한 V2 |
| SC-A-02 | 거래처관리(.txt 생성) | 거래처 | V1 | ME | 108 | Member(B2B) | section, form_field, button | 자체 | ❌보강 .txt 업체목록 |
| SC-A-03 | 매장게시판 | 거래처 | V2 | LO | — | Page | section, text | 자체 | |
| SC-A-04 | 계좌관리(원장용) | 원장 | V2 | ME | — | Account | section, form_field | 자체 | ❌보강. D-DS-33 — V2(원장·회계 V2와 함께) |
| SC-A-05 | 원장관리(오프라인거래) | 원장 | V2 | ME | 107, 108 | Order, Member | section, text, button | 자체 | Excel/청구/매칭 |
| SC-A-06 | 업체별 미수금(Excel) | 원장 | V2 | ME | 108 | Member, Order | section, text | 자체 | |

### 2.2 상품관리 + 가격관리 8 팝업 (IA 50~63)

| ID | 화면명 | 카테고리 | V | 우선 | 핵심 REQ | 도메인 엔티티 | 위젯 | 백엔드 종속 | 비고 |
|---|---|---|:-:|:-:|---|---|---|---|---|
| SC-A-10 | 인쇄/제본 상품등록 | 상품관리 | V1 | HI | 002, 005, 019 | Product, Specification | section, form_field, button | 자체 | 미리보기/기본값설정 |
| SC-A-11 | 사이즈선택 팝업 | 상품관리 | V1 | ME | 002 | Specification | form_field | 자체 | 실사/디지털/제본/패키지/굿즈 |
| SC-A-12 | 소재선택 팝업 | 상품관리 | V1 | ME | 008 | Material | form_field | 자체 | 실사/굿즈 |
| SC-A-13 | 종이선택 팝업 | 상품관리 | V1 | ME | 008, 035 | Paper | form_field | 자체 | 디지털/제본/패키지 |
| SC-A-14 | 가격관리 팝업 8종(진입 허브) | 가격관리 | V1 | HI | 020, 036 | PriceTable | section, rich_card | 자체 | DP02/04/06/GD01/02/PK01/PR01/02 |
| SC-A-14.1 | DP02(디지털 02 양면) | 가격관리 | V1 | HI | 020, 023, 036 | PriceTable, QuantityBreak | form_field, text | 자체 | |
| SC-A-14.2 | DP04(디지털 04 4도) | 가격관리 | V1 | HI | 020, 023, 036 | PriceTable | form_field, text | 자체 | |
| SC-A-14.3 | DP06(디지털 06 특수도수) | 가격관리 | V1 | HI | 020, 023, 072 | PriceTable | form_field, text | 자체 | 별색 |
| SC-A-14.4 | GD01(굿즈 A) | 가격관리 | V1 | HI | 020, 026, 036 | PriceTable, DiscountPolicy | form_field | 자체 | 수량할인 |
| SC-A-14.5 | GD02(굿즈 B) | 가격관리 | V1 | HI | 020, 026, 036 | PriceTable, DiscountPolicy | form_field | 자체 | |
| SC-A-14.6 | PK01(패키지) | 가격관리 | V1 | ME | 020, 036 | PriceTable | form_field | 자체 | |
| SC-A-14.7 | PR01(인쇄 통합+제본) | 가격관리 | V1 | HI | 020, 036 | PriceTable | form_field | 자체 | |
| SC-A-14.8 | PR02(사이즈매트릭스) | 가격관리 | V1 | HI | 020, 024, 036 | PriceTable | form_field | 자체 | 2D 보간 |
| SC-A-15 | 사이즈관리 | 상품관리 | V1 | ME | 024 | Specification | section, form_field | 자체 | |
| SC-A-16 | 소재관리 | 상품관리 | V1 | ME | 008 | Material | section, form_field, tabs | 자체 | |
| SC-A-17 | 용지관리 | 상품관리 | V1 | HI | 008, 035 | Paper | section, form_field, tabs | 자체 | 200종 |
| SC-A-18 | 가격관리(출력/코팅/후가공/제본) | 가격관리 | V1 | HI | 020, 028, 036 | PriceTable, SurchargeRule | section, form_field, text | 자체 | 가격 시뮬레이터 핵심 |
| SC-A-19 | 굿즈 카테고리관리 | 상품관리 | V1 | ME | 004, 026 | Category | section, button | 자체 | |
| SC-A-20 | 굿즈 상품등록 | 상품관리 | V1 | ME | 026 | Product | section, form_field, button | 자체 | 카테고리/옵션 |
| SC-A-21 | 수작 상품등록 | 상품관리 | V2 | LO | 110 | Product | section, form_field | 자체 | D-PM-30 갱신 2026-05-30 — V1 제외·V2 재평가 |
| SC-A-22 | 포장재 상품등록 | 상품관리 | V1 | ME | 002 | Product | section, form_field | 자체 | |
| SC-A-23 | 디자인 상품등록 | 상품관리 | V2 | LO | — | Product | section, form_field | 자체 | |

### 2.3 게시판 관리 (IA 64~72)

| ID | 화면명 | 카테고리 | V | 우선 | 핵심 REQ | 도메인 엔티티 | 위젯 | 백엔드 종속 | 비고 |
|---|---|---|:-:|:-:|---|---|---|---|---|
| SC-A-30 | 공지사항 관리(html생성) | 게시판 | V1 | ME | — | Notice | section, form_field, button | 자체 | |
| SC-A-31 | 자주묻는질문 관리 | 게시판 | V1 | ME | — | FAQ | section, form_field, button | 자체 | |
| SC-A-32 | 대량주문 견적문의(확인/답변) | 게시판 | V1 | ME | 030 | InquiryQuote | section, text, form_field | 자체 | ❌보강. D-DS-33 |
| SC-A-33 | 기업인쇄상담(확인/답변) | 게시판 | V1 | LO | — | Inquiry | section, text, form_field | 자체 | ❌보강. D-DS-33 |
| SC-A-34 | 디자인상담(확인/답변) | 게시판 | V1 | ME | 062 | Inquiry, DesignProject | section, text, form_field, editor_slot | 자체+에디터 | ❌보강. D-DS-33(V2→V1). ⚠복잡도 — §1.3 캐비엇 |
| SC-A-35 | 상품Q&A(확인/답변) | 게시판 | V1 | ME | — | QnA | section, text, form_field | 자체 | ❌보강 |
| SC-A-36 | 1:1문의(확인/답변) | 게시판 | V1 | ME | — | QnA | section, text, form_field | 자체 | |
| SC-A-37 | 체험단관리(당첨처리) | 게시판 | V2 | LO | — | Page | section, form_field | 자체 | html DB직접입력 |
| SC-A-38 | 이용후기관리(임의등록) | 게시판 | V1 | ME | 102, 103 | Review | section, text, button | 자체 | 자동회수 연동 |

### 2.4 회원관리 (IA 73~78)

| ID | 화면명 | 카테고리 | V | 우선 | 핵심 REQ | 도메인 엔티티 | 위젯 | 백엔드 종속 | 비고 |
|---|---|---|:-:|:-:|---|---|---|---|---|
| SC-A-40 | 회원관리(주문/정보) | 회원관리 | V1 | ME | 012, 014 | Member, Order | section, form_field, text | 자체 | |
| SC-A-41 | 탈퇴회원 관리 | 회원관리 | V2 | LO | — | Member | section, text | 자체 | |
| SC-A-42 | 프린팅머니 관리 | 회원관리 | V1 | ME | 094, 095 | LoyaltyPoint | section, form_field, button | 자체 | 수정/처리 |
| SC-A-43 | 쿠폰관리(발행/매칭) | 회원관리 | V1 | HI | 096~101 | Coupon | section, form_field, button | 자체 | 출력/굿즈카테고리/상품 매칭 |
| SC-A-44 | 쿠폰등록내역 | 회원관리 | V1 | ME | 097 | CouponUsage | section, text | 자체 | ❌보강 조회 |
| SC-A-45 | 쿠폰사용내역 | 회원관리 | V1 | ME | 098 | CouponUsage | section, text | 자체 | ❌보강 조회 |

### 2.5 통계 (IA 79~85)

| ID | 화면명 | 카테고리 | V | 우선 | 핵심 REQ | 도메인 엔티티 | 위젯 | 백엔드 종속 | 비고 |
|---|---|---|:-:|:-:|---|---|---|---|---|
| SC-A-50 | 인쇄/제본 상품통계 | 통계 | V2 | LO | 084 | Order, Product | section, rich_card, text | 자체 | 세분 통계 |
| SC-A-51 | 굿즈 상품통계 | 통계 | V2 | LO | 084 | Order, Product | section, text | 자체 | 세분 |
| SC-A-52 | 패키지 상품통계 | 통계 | V2 | LO | 084 | Order, Product | section, text | 자체 | 세분 |
| SC-A-53 | 수작 상품통계 | 통계 | V2 | LO | 084 | Order, Product | section, text | 자체 | 세분 |
| SC-A-54 | 월별 매출통계 | 통계 | V1 | ME | 084 | Order | section, rich_card, text | 자체 | 핵심 경영지표 |
| SC-A-55 | 굿즈 발주/정산(Excel) | 통계 | V2 | ME | 086 | OutsourceOrder | section, text, button | 자체 | ❌보강 외주 정산. D-DS-33 — V2 |
| SC-A-56 | 제작상품 팀별통계(Excel) | 통계 | V2 | LO | 085 | ProductionLog | section, text | 별도트랙 | 공정 연계 |

### 2.6 주문관리 (IA 86~94)

| ID | 화면명 | 카테고리 | V | 우선 | 핵심 REQ | 도메인 엔티티 | 위젯 | 백엔드 종속 | 비고 |
|---|---|---|:-:|:-:|---|---|---|---|---|
| SC-A-60 | 주문관리(인쇄/제본/굿즈 상세) | 주문관리 | V1 | HI | 040, 046 | Order, OrderItem | section, form_field, tabs, text | 자체 | 7-superstate |
| SC-A-61 | 파일확인처리 | 주문관리 | V1 | HI | 065, 067 | ArtworkFile | section, image, button, form_field | 자체+S3 | 인쇄 검수 |
| SC-A-62 | 재업로드요청 문자 발송 | 주문관리 | V1 | HI | 066 | ArtworkFile | section, button | 자체+SMS/알림톡 | |
| SC-A-63 | 주문서출력 | 주문관리 | V1 | HI | 074 | Order | section, button | 자체 | ❌보강 독립 출력 |
| SC-A-64 | 주문상태변경 처리(+문자) | 주문관리 | V1 | HI | 048, 049 | Order, OrderStatusHistory | section, form_field, button | 자체+SMS/알림톡 | 진행/완료 문자 |
| SC-A-65 | 후불결제 관리 | 주문관리 | V2 | ME | 107 | Order, Member | section, tabs, text | 자체 | B2B 미결제/완료 |
| SC-A-66 | 증빙서류발급 관리 | 주문관리 | V1 | ME | 062 | Order, Payment | section, form_field, button | 자체+팝빌(V2) | |
| SC-A-67 | 주문상태변경(일괄) | 주문관리 | V1 | HI | 048 | Order | section, form_field, button | 자체+SMS/알림톡 | |
| SC-A-68 | 고객 SMS 발송 | 주문관리 | V1 | ME | 049 | Order | section, form_field, button | 자체+SMS/알림톡 | 알림톡 통합 |

---

## 3. 별도 트랙 (huni-ia-master IA 미반영 — sitemap §4) — D-DS-34 Decided 2026-05-30 (최소형 V1)

> 생산·출고 운영 별도트랙 V column 확정(D-DS-34, owner 지니): 최소형 V1 = TR-SYS·TR-CLAIM·TR-PROC-1(최소)·TR-PROC-4(송장·명세서). 워크큐 분리·바코드·세분권한·OEM IMPORT = V2. 빌더(TR-BLD)는 O-004 미확정으로 V1? 유지.

| ID | 화면(군) | 카테고리 | V | 핵심 REQ | 위젯 | 백엔드 종속 | 비고 |
|---|---|---|:-:|---|---|---|---|
| SC-BLD-* | 페이지빌더·위젯카탈로그·디자인토큰·템플릿·메가메뉴·배너 (7) | 빌더 | V1? | 111 | section, editor_slot, mega_menu, media_slider | 별도트랙 | 자체 빌더 핵심, IA 화면 없음 (O-004 미확정) |
| SC-PROC-1 | 공정 라우트 마스터(17 Case)/상품-공정 매핑 | 공정 | V1(최소) | 006, 079 | section, form_field | 별도트랙 | D-DS-34. 상품등록 종속 최소형만 V1, 워크큐 V2 |
| SC-PROC-2 | 발주 의뢰서/외주 발주서/수동 조판 | 워크큐 | V2 | 074, 086, 093 | section, button | 별도트랙 | D-DS-34. 단일관리자는 SC-A-63 대체, 발주 워크큐 V2 |
| SC-PROC-3 | 생산 파일 다운로드/공정 바코드(7종) | 워크큐 | V2 | 074, 081~083 | section, form_field | 별도트랙 | D-DS-34. 상태관리 SC-A-64 대체, 바코드 워크큐 V2 |
| SC-PROC-4 | 출고 1차포장/송장/합배송/명세서 | 워크큐 | V1(최소) | 046, 051, 052, 092 | section, button | 별도트랙 | D-DS-34. 송장·명세서 최소형 V1, 1차포장 바코드·합배송 V2 |
| SC-IMP | 주문 IMPORT(4채널 OEM) | 주문관리 | V2 | 118 | section, form_field | 별도트랙 | IA 미반영 |
| SC-CLAIM | 클레임 처리(4 케이스) | 주문관리 | V1(최소) | 060, 061 | section, form_field | 자체+이니시스 | D-DS-34. 환불 인접 운영 필수 최소형 V1 |
| SC-SYS-* | 알림정책 11종/배송비/PG 설정/감사로그 | 시스템 | V1(최소) | 048, 050, 053~057, 083 | section, form_field | 자체+이니시스 | D-DS-34. 결제·배송·알림 동작 전제 설정 최소형 V1 |

---

## 4. 집계

### 4.1 huni-ia-master 112건 분류 카운트

| 시스템 | V1 | V2 | V1? | 합계 |
|---|--:|--:|--:|--:|
| 쇼핑몰(고객) | 49 | 12 | 0 | 61 |
| 관리자 | 36 | 15 | 0 | 51 |
| **소계** | **85** | **27** | **0** | **112** |

> **2026-05-30 갱신(D-DS-33/34):** V1? 9건 전부 해소. 변화 — B2B 상담 3종+답변(SC-CS-04/05/06·SC-A-32/33/34) V1, 현금영수증(SC-MY-12.3)·이용후기(SC-M-05) V1, 수작(SC-M-07·SC-A-21) V2, 원장계좌(SC-A-04)·굿즈정산(SC-A-55) V2. 관리자 직전 표(V1?=4/V2=14)는 실 기능행 V1?=5 누락 기재였으며 V2=13이 정확값 → 본 갱신표가 정합(V1 85/V2 27/V1? 0).
>
> 별도트랙(IA 외): 8그룹 — D-DS-34로 V1(최소형) 4그룹(TR-SYS·TR-CLAIM·TR-PROC-1·TR-PROC-4), V2 3그룹(TR-PROC-2/3·TR-IMP), V1? 1그룹(TR-BLD, O-004 미확정). 112에 미포함.

#### 4.1.1 As-Is 완전성 보강분 (xlsx 112 외 — 별도 집계, D-DS-36)

> As-Is 크롤(2026-05-30, master §F) 보강 화면은 xlsx 112건 외부이므로 별도 집계한다(status.md KPI 정합 유지).

| ID | 화면 | V | 우선 | 비고 |
|---|---|:-:|:-:|---|
| SC-MY-13 | 관심상품(찜) | V1 | ME | 디자인자산① |
| SC-MY-14 | 저장된 디자인 | V1 | ME | 디자인자산② |
| SC-MY-15 | 디자인의뢰 내역 | V2 | LO | 디자인자산④ |
| SC-MY-16 | 통합 게시판 | V2 | LO | 부가 |
| SC-MY-17 | (thm 용도미상) | 확인대기 | — | 추측 금지 |
| SC-M-13 | 운영 안내 팝업 4종 | V1 | LO | 고객 안내 |

> **보강분 집계: V1 3 / V2 2 / 확인대기 1 (6행).** xlsx 112(=122 행 단위)와 합산하지 않고 별도 추적. 디자인 자산 3중구조(D-DS-36): SC-MY-02(옵션보관함=인쇄옵션 의미한정) / SC-MY-13(찜=Product) / SC-MY-14(저장디자인=DesignProject) / SC-MY-15(의뢰내역=Inquiry+DesignProject).

#### 4.1.2 경쟁사 마이페이지 벤치마크 보강분 (xlsx 112 외 — 별도 집계, D-DS-38)

> 마이페이지 벤치마크(2026-05-30/31) B2B 누락 반영. 신설 화면 4건은 xlsx 112 외 별도 집계, 보강 3건은 기존 행이므로 카운트 불변.

| ID | 화면 | V | 우선 | 종류 | 엔티티 | 비고 |
|---|---|:-:|:-:|---|---|---|
| SC-MY-18 | 배송주소록 관리 | V1 | ME | 신설 | Address | §3.2 기존 연결 |
| SC-MY-12.4 | 거래명세서 출력 | V1 | ME | 신설 | Order, OrderItem | 증빙탭 |
| SC-MY-12.5 | 견적서 출력 | V1 | ME | 신설 | Order, OrderItem, Quote | 증빙탭+내견적함 |
| SC-MY-19 | 재작업신청 | V1 | ME | 신설 | Order, OrderItem, ArtworkFile | 원주문연결+불량사진+상태추적. D-DS-40 |
| SC-MY-02 | 옵션보관함→내 견적함 | V1 | HI | 보강 | Quote, QuoteLine | 기존 행, 불변 |
| SC-MY-01 | 미입금 상태 필터 | V1 | HI | 보강 | Order, Payment | 기존 행, 불변 |
| SC-MY-08 | 1:1문의 문의유형 카테고리 | V1 | ME | 보강 | QnA | 기존 행, 불변. D-DS-40 |

> **벤치마크 보강 집계: 신설 V1 4(SC-MY-18·12.4·12.5·19) / 보강 3(불변).** xlsx 112·As-Is 보강분과 합산하지 않고 별도 라인 추적(status.md KPI 정합 유지 — xlsx V1 85/V2 27/V1? 0 불변).
>
> **제외(게이트):** ①i.토큰류 재판매/공동구매 중개 모델은 V1·V2 전부 제외(설계 안 함, D-DS-39). RedPrinting 상품상태별 분리화면 답습 금지(SC-MY-01 필터로 경량화). ②**전건 선결제 정책(D-PM-36) 귀결로 후불 4건 V1·V2 전부 제외:** 미납금결제(upay)·전용계좌관리(vant)·거래원장/입출금(deal·deal-amt)·작업자(다중담당자)관리(worker) — 단순 누락 아닌 정책 귀결. ③견적상담(ests) 메뉴 답습 제외(우리 2분화 우월, D-DS-40)·선거홍보물 전용화면 제외(카테고리 흡수, D-DS-40).
>
> **보류:** 마이페이지 대시보드(미정)·멤버십 등급(미정)·**부가 배송서비스(안심배송 등)→배송옵션 설계 시 재검토**(D-DS-40) — 임의 V1/V2 확정 금지.

### 4.2 우선순위 카운트 (xlsx 112 화면 행 기준, 모달/하위 포함)

| 우선 | 쇼핑몰 | 관리자 | 합계 |
|---|--:|--:|--:|
| HI | 13 | 13 | 26 |
| ME | 19 | 23 | 42 |
| LO | 6 | 7 | 13 |

> 2026-05-30: 디자인상담 V1 승격으로 SC-CS-06·SC-A-34 우선 LO→ME 조정(각 시스템 ME +1, LO −1). 합계 화면 행 수 불변.

(M3 핵심 HIGH 25건 목표 충족 — HI 26건. 견적(SC-Q-01/02/10/12) + 가격관리 8(SC-A-14.x) + 주문관리 코어가 견인.)

---

## 5. REQ 추적 커버리지 (재작성 후)

인용 REQ-PQ (중복 제거):
001, 002, 003, 004, 005, 006, 008, 009, 011, 012, 013, 014, 015, 016, 017, 018, 019, 020, 021, 023, 024, 025, 026, 028, 030, 031, 035, 036, 038, 039, 040, 041, 042, 043, 044, 045, 046, 047, 048, 049, 050, 051, 052, 053, 054, 055, 056, 057, 059, 060, 061, 062, 063, 065, 066, 067, 072, 074, 076, 077, 079, 081, 082, 083, 084, 085, 086, 092, 093, 094, 095, 096, 097, 098, 099, 101, 102, 103, 105, 106, 107, 108, 110, 111, 118.

**커버리지:** 약 **85/120 ≈ 71%**. 미커버는 화면 외 규약·인프라(REQ-PQ-115~117, 119, 120), 가격엔진 미세규칙(027, 029, 032~034, 037 — Track B 견적 와이어에서 흡수), 파일 검수 일부(064, 068~071, 073, 078 — 파일확인 와이어에서 흡수), 회원·배송 일부(022, 058, 075, 088~091, 100, 104, 109 — 별도트랙/생산운영 V2로 이연된 항목 다수).

> 주: v1.0(81%) 대비 수치 하락은 **buysangsang 추론으로 채웠던 별도트랙 화면(워크큐·OEM·정산 세부)이 huni-ia-master IA에 없어 V1?/V2로 이연**됐기 때문이다. 해당 REQ는 별도트랙 협의 확정 시 복원된다(누락 아님 — 범위 축소 결과).

---

## 6. 신규 디자인 결정 (Inline D-DS)

| ID | 결정 | 근거 |
|---|---|---|
| `D-DS-29` (잠정) | 백엔드 종속 컬럼을 `자체/이니시스/에디터/별도트랙`으로 재정의. v1.0 `BFF-S(Shopby 위임)` 전면 폐기. | commerce-backend-scenario.md B-2 |
| `D-DS-30` (잠정) | 가격관리 8 팝업은 단일 컴포넌트 `<PriceTableEditor model="DP02|...">` 모델 인자 재사용. | pricing-engine.md |
| `D-DS-31` (잠정) | 편집상품 미리보기(SC-MY-01.1)·파일/편집(SC-Q-10)은 외부 편집기 `editor_slot`(iframe) 임베드. "에디터" 라벨. | D-PM-35, IA-8↳/IA-40 |
| `D-DS-32` (잠정) | 생산운영(공정/워크큐)은 별도트랙. 단일 관리자 V1은 SC-A-63(주문서출력)·SC-A-64/67(상태변경)으로 최소 대체. | huni-ia-master §D |
| `D-DS-33` **Decided 2026-05-30** | V1? 9건 확정. 디자인상담(SC-CS-06/SC-A-34)은 DesignProject+에디터 결합 복잡도 캐비엇(§1.3)을 동반하므로 SPEC 분할 시 B2B 게시판과 분리 권고. | decisions.md D-DS-33, D-PM-30 |
| `D-DS-34` **Decided 2026-05-30** | 별도트랙 최소형 V1(TR-SYS·TR-CLAIM·TR-PROC-1/4), 워크큐 분리 V2. | decisions.md D-DS-34 |
| `D-DS-36` **Decided 2026-05-30** | 디자인 자산 3중구조 분리 + As-Is 완전성 보강. SC-MY-13(찜)·SC-MY-14(저장디자인)·SC-M-13(운영안내팝업4종) V1, SC-MY-15(의뢰내역)·SC-MY-16(통합게시판) V2, SC-MY-17(thm) 확인대기. SC-MY-02 옵션보관함=인쇄옵션 의미한정. | decisions.md D-DS-36, master §F |
| `D-DS-37` **Decided 2026-05-30** | As-Is 상품 5경로 물리분기 답습 금지 → `productType` 단일 라우트. As-Is 반영은 완전성·숨은로직 한정. | decisions.md D-DS-37 |
| `D-DS-38` **Decided 2026-05-30** | 마이페이지 벤치마크 V1 반영. SC-MY-18 배송주소록(신설·Address §3.2 연결)·SC-MY-12.4 거래명세서출력(신설)·SC-MY-12.5 견적서출력(신설)·SC-MY-02 내 견적함(보강)·SC-MY-01 미입금필터(보강). 신설 V1 3 별도집계(§4.1.2). | decisions.md D-DS-38, mypage-benchmark.md |
| `D-DS-39` **Decided 2026-05-30** | i.토큰류 답습 제외 게이트(재판매/공동구매 중개 모델 부적합, V1·V2 전부 제외). 상품상태별 분리화면 답습 금지(필터 경량화). 대시보드·멤버십 보류(미확정). | decisions.md D-DS-39, mypage-benchmark.md §3-5/§4 |
| `D-DS-40` **Decided 2026-05-31** | Wowpress 회원영역 벤치마크(v1.2) owner 결정. SC-MY-19 재작업신청 신설 V1(원주문연결+불량사진+상태추적, SC-MY-08 분리). SC-MY-08 문의유형 카테고리 보강. 견적상담(ests) 메뉴·선거홍보물 전용화면 답습 제외. 부가배송서비스 보류(배송옵션 설계 시 재검토). 신설 V1 누계 4. | decisions.md D-DS-40, mypage-benchmark.md §3-9/§3-12 |
| `D-PM-36` **Decided 2026-05-31** | **전건 선결제(후불·여신 미운영)** — Wowpress B2B 후불 4건(upay·vant·deal/deal-amt·worker) V1·V2 전부 제외(정책 귀결). 결제(payment-launch-readiness)·커머스(commerce-backend-scenario B-2) 연결. | decisions.md D-PM-36 |

---

## 7. 변경 이력

| 버전 | 일자 | 변경 | 작성자 |
|---|---|---|---|
| 1.0 | 2026-05-28 | 초기 — 141 화면, BFF-S Shopby 위임 표기 (폐기) | pq-designer |
| 2.0 | 2026-05-28 | **재작성** — huni-ia-master 112건 + 별도트랙 8그룹. 백엔드 종속 B-2(자체/이니시스/에디터/별도트랙)로 교체. V1 77 / V2 26 / V1? 9. ❌13건 반영 | pq-designer |
| 2.1 | 2026-05-30 | **V1? 10행 확정(D-DS-33/34).** SC-CS-04/05/06·SC-A-32/33/34 V1, SC-MY-12.3·SC-M-05 V1, SC-M-07·SC-A-21 V2, SC-A-04·SC-A-55 V2. 별도트랙 최소형 V1 4그룹. xlsx 112: **V1 85 / V2 27 / V1? 0**(관리자 V1?=5 정정). 디자인상담 복잡도 캐비엇(§1.3) + 우선순위 LO→ME 2건. 백엔드 종속 SC-CS-06/SC-A-34 = 자체+에디터로 보정. 아키텍처 결정 불변 | pq-pm |
| 2.2 | 2026-05-30 | **As-Is 완전성 보강(D-DS-36/37).** master 누락 6행 추가: SC-MY-13(찜·V1)·SC-MY-14(저장디자인·V1)·SC-MY-15(의뢰내역·V2)·SC-MY-16(통합게시판·V2)·SC-MY-17(thm·확인대기)·SC-M-13(운영안내팝업4종·V1). 디자인 자산 3중구조 분리(§4.1.1). 보강분 V1 3/V2 2/확인대기 1 (xlsx 112 외 별도집계 — KPI 정합). thm 추측 금지(HARD). 상품 5경로 답습 금지(D-DS-37) | pq-pm |
| 2.3 | 2026-05-30 | **경쟁사 마이페이지 벤치마크 V1 반영(D-DS-38/39).** 신설 3행: SC-MY-18 배송주소록(V1·Address §3.2 연결)·SC-MY-12.4 거래명세서출력(V1)·SC-MY-12.5 견적서출력(V1). 보강 2행: SC-MY-02 내 견적함 격상·SC-MY-01 미입금필터(엔티티 Payment 추가). 벤치마크 보강분 신설 V1 3 별도집계(§4.1.2). i.토큰 답습 제외 게이트(D-DS-39), 대시보드·멤버십 보류. 아키텍처 결정 불변, KPI(V1 85/V2 27/V1? 0) 불변 | pq-pm |
| 2.4 | 2026-05-31 | **Wowpress 회원영역 벤치마크(v1.2) owner 결정 반영(D-DS-40·D-PM-36).** 신설 1행: SC-MY-19 재작업신청(V1·Order/OrderItem/ArtworkFile·위젯 form_field/image_upload/상태추적·자체+S3). 보강 1행: SC-MY-08 문의유형 카테고리. 위젯 범례에 `image_upload`·`상태추적` 추가. 견적상담(ests)·선거홍보물 답습 제외, 부가배송 보류(배송옵션 설계 시 재검토). **전건 선결제 정책(D-PM-36) 귀결로 후불 4건(upay·vant·deal/deal-amt·worker) V1·V2 전부 제외**(단순 누락 아님). 벤치마크 신설 V1 누계 4. KPI(V1 85/V2 27/V1? 0) 불변, 결제/커머스 문서 연결 메모 | pq-pm |
