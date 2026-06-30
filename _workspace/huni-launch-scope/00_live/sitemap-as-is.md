# 후니프린팅 라이브 고객사이트 As-Is 사이트맵

- 원천: `https://www.huniprinting.com/` (라이브, 읽기 탐색만 / EUC-KR / Classic ASP)
- 채집: gstack browse, 로그인 성공(회원 계정). 채집일 2026-06-30.
- 안전: 주문/결제/장바구니/폼 제출/회원정보 저장 클릭 0건. 회원 상태 미변경.
- 표기: URL은 근거. 화면 라벨이 이미지(CSS background)라 일부 카테고리 한글명은 시각 캡처 기준.

> 개인정보(회원명·이메일·휴대폰·주소·프린팅머니 잔액)는 화면에서 관찰됐으나 **값은 마스킹**하고
> 필드 구조만 기록한다. 로그인 후 헤더에 회원명이 노출되어, PII 포함 스크린샷은 저장하지 않았다
> (공개 페이지 캡처만 `captures/`에 보관).

---

## 1. 글로벌 구조 (헤더/유틸)

```
상단 브랜드 탭:  HUNIPRINTING | GOODSBOX(→ goodsbox.co.kr, 외부) | PHOTEN(→ photen.co.kr, 외부)
상단 유틸:       로그인 | 회원가입 | 마이페이지 | 고객상담센터 | 작업유의사항
                 (로그인 후: 로그인/회원가입 → 로그아웃 으로 전환)
로고 영역:       Huni printing — "디지털인쇄 토탈서비스 후니프린팅"
우측 보조:       종이샘플 | 제본샘플 | 채팅하기(카카오 pf.kakao.com/_ABvcK/chat)
```

### GNB 주문 메뉴 (6 대분류, 모두 이미지 기반)
| # | 대분류 | 진입 패턴 |
|---|--------|-----------|
| 1 | 디지털인쇄 주문하기 | `/product/list.asp?pcode=N` → `/product/goods.asp?pcode=N`(견적형 주문) |
| 2 | 책자,캘린더 주문하기 | `/product/list.asp` → `/product/goods.asp` 또는 `/goods/view.asp` |
| 3 | 실사출력 주문하기 | `/product/list.asp` → `/product/goods.asp`(면적 견적형) |
| 4 | 굿즈제작 주문하기 *파우치&백 (NEW) | `/product/list.asp` → `/goods/view.asp`(카탈로그형) |
| 5 | 패키지,포장재 주문하기 | `/product/list.asp` → `/package/view.asp` |
| 6 | 디자인 의뢰하기 | `/design/sangsang.asp?pcode=N` |

---

## 2. URL 트리 (비로그인 + 로그인 공통)

```
/main.asp                          홈(프로모션 랜딩 + 공지/상품소식 롤)
│
├─ 상품(상품리스트 → 상세/주문)
│   ├─ /product/list.asp?pcode=N        카테고리 상품리스트  (≈70 pcode: 1,3~16,18,19,22~28,31~41,44,47,50,52,53,55,57,59~66,68~70,74,80~88,90~92 …)
│   ├─ /product/goods.asp?pcode=N       ★견적형 주문 페이지(사이즈/옵션/수량 → 가격). pcode 72,73,75,76,78,93~101 …
│   ├─ /goods/view.asp?pcode=N          카탈로그형 상세(수량 선택 위주). pcode 98~271 다수(굿즈/완제품)
│   ├─ /package/view.asp?pcode=N        패키지/셋트 상세. pcode 1,2,5,6,7,11,12,13
│   └─ /design/sangsang.asp?pcode=N     디자인 의뢰(상상). pcode 34~60
│
├─ 회원
│   ├─ /login/login.asp                 로그인 (form→ /login/login_ok.asp, user_id·user_pwd)
│   ├─ /login/logout.asp                로그아웃
│   └─ /join/intro.asp                  회원가입 진입(★로그인 상태에선 main으로 리다이렉트=미접근)
│
├─ /mypage/main.asp                     마이페이지 대시보드
│   ├─ /mypage/order.asp                주문조회(인쇄,제본) — 기간(년월일~년월일) 필터
│   ├─ /mypage/save.asp                 옵션보관함(저장한 견적/옵션)
│   ├─ /mypage/coupon.asp               쿠폰/이용권
│   ├─ /mypage/money.asp                프린팅머니(예치금/적립금)
│   ├─ /mypage/qna.asp                  나의 상품Q&A
│   ├─ /mypage/pqna.asp                 1:1 문의
│   ├─ /mypage/review.asp               나의 이용후기
│   ├─ /mypage/challenge.asp            나의 체험단 활동내역
│   ├─ /mypage/modify.asp               회원정보수정(개인+사업자+주소 다수)
│   ├─ /mypage/password.asp             비밀번호변경
│   ├─ /mypage/tax01.asp                증빙서류발급(현금영수증/세금계산서)
│   └─ /mypage/out.asp                  회원탈퇴
│
├─ /customer/main.asp                   고객센터(고객상담센터)
│   ├─ /customer/notice.asp             공지사항 (상세 /customer/notice_view.asp?idx=N)
│   ├─ /customer/faq.asp                자주 묻는 질문(FAQ)
│   ├─ /customer/qna.asp                상품 Q&A / 묻고답하기
│   ├─ /customer/inquery.asp            1:1 / 견적 문의
│   ├─ /customer/comqna.asp             (회사/대량 문의 추정 — 라벨 미확정)
│   ├─ /customer/dgnqna.asp             디자인 의뢰 문의(추정)
│   └─ /customer/order.asp              주문제작 문의(추정)
│
├─ 보조/외부
│   ├─ /landing/20160411/main.asp, /landing/20160412/main.asp   프로모션 랜딩
│   ├─ 종이샘플 / 제본샘플              (GNB 우측, 링크 URL 미발견 — 이미지/JS)
│   ├─ 작업유의사항                     (상단 유틸, URL 미발견 — 이미지/JS)
│   ├─ http://pf.kakao.com/_ABvcK/chat  카카오 상담 채팅(외부)
│   ├─ http://www.goodsbox.co.kr        자매 브랜드(외부)
│   └─ https://www.photen.co.kr         자매 브랜드(외부)
```

---

## 3. 상품 상세/주문 페이지 4종 (As-Is 주문 아키텍처)

| 패턴 | 역할 | 옵션 구조(실측) |
|------|------|------------------|
| `/product/goods.asp?pcode=` | **견적형 주문**(디지털인쇄·실사·책자) | 폼 3개·select 다수(예 pcode=72: `tmp_width,tmp_height,tmp_p02,tmp_p05,tmp_p06`)+수량 input → 가격계산 |
| `/goods/view.asp?pcode=` | **카탈로그형 상세**(굿즈/완제품) | 단순 `qty` select 위주 |
| `/package/view.asp?pcode=` | 패키지/셋트 상세 | (미세부) |
| `/design/sangsang.asp?pcode=` | 디자인 의뢰(상상) | (미세부) |

- `HUNI_LIVE_GOODS_URL`(.env)의 `product/goods.asp?pcode=`가 곧 견적형 주문 진입점.
- 장바구니 담기/주문 버튼은 클릭하지 않음(읽기 탐색 한정).

---

## 4. 미발견/한계
- 회원가입(join) 입력 폼 전체: 로그인 상태라 미접근(main 리다이렉트). 로그아웃 후 재탐색 필요.
- 주문 상세(주문번호 → 상세): 테스트 계정에 주문 내역 0건이라 상세 화면 미도달.
- 카테고리 pcode↔한글명 전수 매핑: GNB가 이미지 기반이라 개별 라벨 미추출(대분류 6종만 캡처 확정).
- 종이샘플/제본샘플/작업유의사항 실제 URL: 이미지/JS 링크로 href 미노출(미발견).
