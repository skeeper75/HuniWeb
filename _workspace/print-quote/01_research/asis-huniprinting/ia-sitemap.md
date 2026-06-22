# 후니프린팅(huniprinting.com) As-Is IA·사이트맵

> **범위 한정 (오너 지시):** 기술 스택·결제연동 내부(INIStdPay 등)는 **범위 외** — 리뉴얼은 Next.js 재구현 전제. 본 문서는 **로그인 크롤(2026-05-30) 기반 IA/사이트맵**만 다룬다. 페이지 계층·메뉴 구조·회원영역 인벤토리·카테고리 택소노미·주문/문의 흐름 단계만 기록하며, 결제 게이트웨이·코드 동작은 제외한다.
>
> **Source(raw):** `/tmp/huni-crawl/` (crawl-summary.md / mypage-paths.txt 39경로 / category-pcodes.txt 67건 / main-categories.txt 223링크). 계정 로그인 LNB 기준. **PII 미수록(경로만).**

작성자: pq-researcher · 작성일 2026-05-30

---

## §1. 공개 영역 IA

### 1.1 상품 URL 5패턴 (상품 진입 구조)

실사이트는 상품 유형에 따라 **5종의 별도 URL 패턴**으로 분기한다. 카테고리 목록(`list`)을 거쳐 유형별 상세(`goods`/`view`/`sangsang`)로 진입한다.

| # | 패턴 | URL | 역할 | 비고 |
|--:|---|---|---|---|
| 1 | 카테고리 목록 | `product/list.asp?pcode=N` | 카테고리별 상품 리스팅(허브) | pcode 67건 |
| 2 | 인쇄상품 상세 | `product/goods.asp?pcode=N` | 디지털/책자/실사 등 인쇄 상세, 주문함수 `Order('C')` | 발견 13건 |
| 3 | 굿즈 상세 | `goods/view.asp?pcode=N` | 굿즈(파우치·백 등) 상세 | 발견 다수(pcode 98~271) |
| 4 | 패키지 상세 | `package/view.asp?pcode=N` | 패키지/포장재 상세 | 발견 8건(pcode 1~13) |
| 5 | 상상(디자인의뢰) | `design/sangsang.asp?pcode=N` | "상상" 디자인 의뢰형 상품 | 발견 19건(pcode 34~60) |

> **시사점:** As-Is는 상품 유형별로 상세 페이지 템플릿이 물리적으로 분리되어 있다. Next.js 재구현 시 **유형 판별(`productType`) → 단일 상세 라우트 + 유형별 옵션/주문 위젯 슬롯** 구조로 통합 가능. "상상(sangsang)" 디자인의뢰는 master IA에서 "디자인 의뢰하기(No 32)"로만 약하게 잡혀 있어 별도 상품군으로 승격 필요(§3 참조).

### 1.2 카테고리 체계 (product/list.asp pcode 67건)

크롤로 확인된 카테고리 pcode는 **67건**(`category-pcodes.txt`). pcode는 1~92 사이에서 불연속(2·17·20·21·29·30 등 결번 존재 → 비활성/통합 카테고리 추정). 라벨 텍스트는 본 크롤 범위에서 미수집(경로만 확보)이므로 **분류 라벨은 master IA 상품군과 교차로 추정**한다.

| 추정 상품군(master 기준) | 대응 URL 패턴 | 근거 |
|---|---|---|
| 출력상품(디지털/책자/실사) | `list` → `product/goods` | master No 40 "출력상품 4종" |
| 패키지/포장재 | `list` → `package/view` | master No 41 "포장재상품" |
| 굿즈(+파우치&백) | `list` → `goods/view` | master No 42 "굿즈상품" |
| 상상(디자인의뢰) | `list` → `design/sangsang` | master No 32 "디자인 의뢰" |
| 수작 | (미확정) | master No 43 "수작 상품" |

> **한계 명시:** 67개 pcode의 정확한 카테고리명·계층(depth) 라벨은 본 IA 크롤에서 미확보. 카테고리 트리 확정은 후속 라벨 수집 필요. **개수(67)와 상품 유형 5분기 구조는 확정.**

### 1.3 공개 영역 진입 경로

```
메인(/) ─┬─ 카테고리 목록  product/list.asp?pcode=N (67)
         │      └─ 상품 상세 (유형별 5패턴)
         ├─ 고객센터  customer/main · faq · qna
         ├─ 이용후기  review/main
         ├─ 챌린지(체험단)  challenge/main
         ├─ 디자인의뢰  design/sangsang
         ├─ 정보 팝업  info/pop_company · pop_policy · pop_map ·
         │              pop_stamp(도장) · pop_upload · pop_webhard · pop_design
         └─ 로그인/회원가입 → 회원영역(§2)
```

- **정보 팝업 7종**: 회사소개·이용약관·찾아오시는길 + **운영 안내성 팝업 4종(도장신청·업로드안내·웹하드·디자인안내)**. master IA의 "정보(No 33~35)"는 회사소개/약관/지도 3건만 반영 → **운영 안내 팝업 4종이 As-Is 신규 발견**(§4).
- **주문/결제 흐름(단계만)**: 상품상세 `Order('C')` → 파일/편집 입력 → 보관함/장바구니 → 배송정보 → **결제 단계 존재**(이니시스, 기술 상세 제외) → 주문완료. (master No 28~31과 일치)

---

## §2. 회원 영역 IA (mypage LNB)

로그인 LNB에서 확인된 마이페이지 메뉴는 **16종**(+ 메인 `mypage/main`, 보조 `thm`). 기능별로 5개 그룹으로 정리한다.

### 2.1 그룹: 주문
| 메뉴 | 경로 | 설명 |
|---|---|---|
| 주문내역 | `mypage/order.asp` | 주문조회/상세 |

### 2.2 그룹: 자산 (적립·혜택)
| 메뉴 | 경로 | 설명 |
|---|---|---|
| 프린팅머니 | `mypage/money.asp` | 적립금(예치금) |
| 쿠폰 | `mypage/coupon.asp` | 보유 쿠폰/등록 |

### 2.3 그룹: 디자인 (자산화된 디자인·관심)
| 메뉴 | 경로 | 설명 |
|---|---|---|
| 관심상품 | `mypage/save.asp` | 찜/관심 상품 |
| 저장된 디자인 | `mypage/save_design.asp` | 편집 디자인 저장본(재주문 연계) |
| 상상(디자인의뢰) | `mypage/sangsang.asp` | 내 디자인 의뢰 내역 |

### 2.4 그룹: 문의·소통
| 메뉴 | 경로 | 설명 |
|---|---|---|
| 1:1문의 | `mypage/qna.asp` | 일반 문의 |
| 상품문의(pqna) | `mypage/pqna.asp` | **상품별 Q&A**(1:1과 별개 게시판) |
| 게시판 | `mypage/board.asp` | 내 게시글 |
| 이용후기 | `mypage/review.asp` | 내 리뷰(작성/수정) |
| 챌린지 | `mypage/challenge.asp` | 체험단 활동내역 |

### 2.5 그룹: 계정·증빙
| 메뉴 | 경로 | 설명 |
|---|---|---|
| 회원정보수정 | `mypage/modify.asp` | 정보 수정 |
| 비밀번호변경 | `mypage/password.asp` | 비밀번호 변경 |
| 회원탈퇴 | `mypage/out.asp` | 탈퇴 |
| 세금계산서/현금영수증 | `mypage/tax01.asp` | 증빙서류 발급내역 |

> 보조: `mypage/main.asp`(마이페이지 메인), `mypage/thm.asp`(용도 미상 — 추정: 디자인 테마/썸네일 보관, 라벨 미확인).
>
> **고객센터(공개+회원 공통)**: `customer/main` · `customer/faq` · `customer/qna`.

---

## §3. master IA(112건) 대조표

기준: `_workspace/print-quote/02_business/huni-ia-master.md` (94 No + 18 하위행 = 112 기능). 크롤로 확인된 **실제 운영 화면**이 master에 **있음(✅) / 약함·부분(🟡) / 누락(❌ As-Is에만 존재)**인지 표기.

### 3.1 공개·상품 영역

| As-Is 실화면(크롤) | master 항목 | 상태 | 비고 |
|---|---|:--:|---|
| `product/list` 카테고리 67건 | No 40~43 상품군 | 🟡 | master는 상품군 4종 단위, 카테고리 67 세분류 미반영 |
| `product/goods` 인쇄상세 | No 40 출력상품 4종 | ✅ | `Order('C')` 주문 흐름 |
| `goods/view` 굿즈상세 | No 42 굿즈상품 | ✅ | — |
| `package/view` 패키지상세 | No 41 포장재상품 | ✅ | — |
| `design/sangsang` 상상의뢰 | No 32 디자인 의뢰하기 | 🟡 | master는 "주문" 영역 1건, As-Is는 **독립 상품군(pcode 19건)+마이페이지 메뉴** |
| 정보 팝업 7종 | No 33~35 정보 3건 | 🟡 | **pop_stamp(도장)·pop_upload·pop_webhard·pop_design 4종 누락** |
| `review/main` 이용후기 메인 | No 38 이용후기 메인 | ✅ | (기존 sitemap에서는 ❌였으나 master에는 존재) |
| `challenge/main` 체험단 메인 | No 39 체험단 모집 | ✅ | — |

### 3.2 회원 영역

| As-Is 실화면(크롤) | master 항목 | 상태 | 비고 |
|---|---|:--:|---|
| `mypage/order` 주문내역 | No 8 주문조회 | ✅ | — |
| `mypage/save` 관심상품 | — | ❌ | **master 누락** — 찜/관심상품 화면 없음 |
| `mypage/save_design` 저장된디자인 | No 9 옵션보관함 | 🟡 | master는 "옵션보관함", As-Is는 **편집 디자인 저장본**(별개 개념) |
| `mypage/sangsang` 내 디자인의뢰 | No 32(부분) | 🟡 | 마이페이지 내 의뢰내역 화면 미명시 |
| `mypage/money` 프린팅머니 | No 11 프린팅머니 | ✅ | — |
| `mypage/coupon` 쿠폰 | No 10 쿠폰관리 | ✅ | — |
| `mypage/pqna` 상품문의 | No 12 나의 상품Q&A | ✅ | master에 존재(상품Q&A 별도 게시판 확인) |
| `mypage/qna` 1:1문의 | No 15 1:1문의 | ✅ | — |
| `mypage/board` 게시판 | — | ❌ | **master 누락** — 통합 게시판 메뉴 없음 |
| `mypage/review` 이용후기 | No 13 나의 리뷰 | ✅ | — |
| `mypage/challenge` 챌린지활동 | No 14 체험단 활동내역 | ✅ | — |
| `mypage/modify` 정보수정 | No 16 회원정보수정 | ✅ | — |
| `mypage/password` 비번변경 | No 17 비밀번호변경 | ✅ | — |
| `mypage/out` 회원탈퇴 | No 18 회원탈퇴 | ✅ | — |
| `mypage/tax01` 세금계산서/현금영수증 | No 19 증빙서류발급 | ✅ | — |
| `mypage/thm` (용도미상) | — | ❌ | **master 누락** — 라벨 미확인, 후속 확인 필요 |

> **상태 집계(회원영역 16+α):** ✅ 11 / 🟡 2 / ❌ 3(`save` 관심상품, `board` 게시판, `thm`).

---

## §4. 발견 요약 — master 대비 As-Is 신규 확인 화면

### 4.1 master가 누락했거나 약하게 잡은 실운영 화면 (Top N)

| 순위 | As-Is 화면 | 경로 | master 상태 | 시사점 |
|--:|---|---|---|---|
| 1 | **관심상품(찜)** | `mypage/save` | ❌ 누락 | 표준 커머스 기능 — V1 회원영역에 추가 필요 |
| 2 | **저장된 디자인** | `mypage/save_design` | 🟡 "옵션보관함"과 혼동 | 편집 결과물(디자인)과 인쇄옵션은 **별개 자산** — 재주문 UX 핵심, 분리 모델링 필요 |
| 3 | **상상(디자인의뢰) 상품군** | `design/sangsang` (pcode 19) + `mypage/sangsang` | 🟡 단일 "의뢰하기" | 독립 상품군 + 마이페이지 의뢰내역 — 카탈로그 5번째 유형으로 승격 |
| 4 | **상품문의 pqna(전용 게시판)** | `mypage/pqna` | ✅(존재하나) | 1:1문의와 **별도 게시판** 운영 확정 — 통합 설계 시 분리 유지 권고 |
| 5 | **운영 안내 팝업 4종** | `info/pop_stamp`(도장)·`pop_upload`·`pop_webhard`·`pop_design` | ❌ 누락 | 도장신청·파일업로드안내·웹하드·디자인안내 — 정보 영역에 보강 필요 |
| 6 | **통합 게시판** | `mypage/board` | ❌ 누락 | 내 게시글 통합 뷰 — V1 포함 여부 검토 |
| 7 | **챌린지(체험단) 공개 메인** | `challenge/main` | ✅ | master No 39와 일치 — 정합 확인 |
| 8 | **카테고리 67 세분류** | `product/list` pcode 67 | 🟡 상품군 4종 단위 | 카테고리 트리(67) 라벨 후속 수집 후 IA 확정 필요 |
| 9 | **mypage/thm** | `mypage/thm` | ❌ 라벨미상 | 용도 확인 후 분류 |

### 4.2 종합 시사점

1. **회원영역 누락 3건(`save`/`board`/`thm`)** — master IA(112)가 실운영 마이페이지 LNB를 완전히 커버하지 못함. 특히 **관심상품(찜)**은 표준 기능으로 V1 필수.
2. **"디자인 자산" 3중 구조** — `save_design`(저장 디자인) / `sangsang`(디자인의뢰) / `save`(관심상품)가 모두 별개. master는 "옵션보관함" 1건으로 압축 → **재주문·디자인 재사용 UX**가 As-Is의 강점이므로 도메인 모델 분리 필수.
3. **상품 5패턴 → 단일 라우트 통합 기회** — As-Is의 물리적 페이지 분기(인쇄/굿즈/패키지/상상)는 Next.js에서 `productType` 기반 단일 상세 + 옵션 위젯 슬롯으로 통합 가능.
4. **정보/안내 팝업 보강** — 운영 안내 팝업 4종(도장·업로드·웹하드·디자인안내)은 인쇄 커머스 특유의 고객 안내 자산으로, 재구현 시 정보/가이드 영역에 포함 권고.
5. **카테고리 라벨 후속 작업** — 67개 pcode의 명칭·계층은 본 IA 크롤 범위 밖. 카테고리 트리 확정을 위한 라벨 수집이 다음 단계.

### 4.3 카운트 검증 (raw 대조)
- 회원영역 경로: `mypage-paths.txt` **39 라인** (mypage 16 + customer 3 + info 7 + design/goods/package/product/review/challenge/login/hhm/INIStdPay 등 포함) — 일치.
- 마이페이지 LNB 순수 메뉴: `mypage/*.asp` **18건**(main·thm 포함, 본문 핵심 16 + main + thm) — 일치.
- 카테고리 pcode: `category-pcodes.txt` **67건** — 일치.
- 메인 상품 링크: `main-categories.txt` **223 라인**(list 67 + goods 13 + view-goods/package/sangsang) — 일치.

---

## 변경 이력
| 버전 | 일자 | 변경 | 작성자 |
|---|---|---|---|
| 1.0 | 2026-05-30 | 로그인 크롤(2026-05-30) 기반 As-Is IA/사이트맵 작성 + master IA(112) 대조 | pq-researcher |
