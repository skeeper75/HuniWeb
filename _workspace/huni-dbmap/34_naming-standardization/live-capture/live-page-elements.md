# 후니 라이브 Admin — 전 페이지 보이는 요소 인덱스 (live-capture)

캡처일: 2026-06-18 · 베이스 `https://huni-admin-production.up.railway.app` · gstack browse 헤드리스(읽기 탐색만, 저장/삭제 클릭 0)

- 캡처 PNG: `./captures/`
- 권위: **라이브 화면**(소스 화면맵 `_workspace/huni-admin-manual/01_source_admin-screen-map.md`과 차이는 §드리프트에 라이브 기준 표기)
- 캡처 페이지 수: **18 메뉴 페이지**(사이드바 18) + 대표 add 폼 1 + 상품뷰어 상세 1 = PNG 19장
- 코드값 도메인: 기초코드 13그룹·64코드 전수 펼침(§기초코드)

---

## 사이드바 메뉴 (18) — 라이브 라벨 · URL · 화면유형

| # | 메뉴 라벨 (사이드바 아이콘) | URL | 화면 유형 | 캡처 |
|---|------|-----|----------|------|
| 1 | 상품정보 (inventory_2) | /admin/catalog/tprdproducts/ | 표준 Django changelist | tprdproducts__changelist.png |
| 2 | 상품 뷰어 (dashboard) | /admin/product-viewer/ | **커스텀** 목록→상세 | product-viewer__home.png, __detail.png |
| 3 | 추가상품 템플릿 (dashboard_customize) | /admin/catalog/tprdtemplates/ | 표준 changelist(팝업/redirect) | tprdtemplates__changelist.png |
| 4 | 카테고리 (category) | /admin/category-master/ | **커스텀** 3단계 마스터 | category-master__page.png |
| 5 | 자재정보 (texture) | /admin/master/mat/ | **커스텀** 마스터-디테일 | master-mat__page.png |
| 6 | 사이즈정보 (straighten) | /admin/catalog/tsizsizes/ | 표준 changelist | tsizsizes__changelist.png |
| 7 | 도수정보 (palette) | /admin/catalog/tclrcolorcounts/ | 표준 changelist | tclrcolorcounts__changelist.png |
| 8 | 인쇄옵션 (print) | /admin/catalog/tprtprintoptions/ | 표준 changelist | tprtprintoptions__changelist.png |
| 9 | 공정정보 (precision_manufacturing) | /admin/master/proc/ | **커스텀** 마스터-디테일 | master-proc__page.png |
| 10 | 기초코드정보 (list) | /admin/basecode-master/ | **커스텀** 마스터-디테일 | basecode-master__page.png |
| 11 | 가격공식 (functions) | /admin/catalog/tprcpriceformulas/ | 표준 changelist | tprcpriceformulas__changelist.png |
| 12 | 가격구성요소 (tune) | /admin/catalog/tprcpricecomponents/ | 표준 changelist | tprcpricecomponents__changelist.png |
| 13 | 할인테이블 (수량구간) (percent) | /admin/catalog/tdscdiscounttables/ | 표준 changelist | tdscdiscounttables__changelist.png |
| 14 | 가격 뷰어 (payments) | /admin/price-viewer/ | **커스텀** 뷰어 | price-viewer__page.png |
| 15 | 가격 시뮬레이터 (calculate) | /admin/price-simulator/ | **커스텀** 계산기 | price-simulator__page.png |
| 16 | 고객 (group) | /admin/catalog/tcuscustomers/ | 표준 changelist(빈) | tcuscustomers__changelist.png |
| 17 | 사용자 (person) | /admin/auth/user/ | 표준 Django auth | authuser__changelist.png |
| 18 | 비밀번호 변경 | /admin/password_change/ | Django 표준(미캡처) | — |

> 사이드바 그룹 헤더(라이브): **상품 · 기준정보 (마스터) · 가격 관리 · 고객관리 · 인증 및 권한**.

---

## 표준 changelist 페이지 — 컬럼 헤더·필터·데이터 명칭 샘플

### 1. 상품정보 `tprdproducts` — 제목 "변경할 상품정보 선택"
- **컬럼**: 상품코드 · MES품목코드 · 상품명 · 상품유형코드 · 반제품역할코드 · 비규격여부 · 비규격가로최소 · 비규격가로최대
- **필터**: 상품유형코드 (으)로 · 사용여부 (으)로 · 수량단위유형코드 (으)로
- **데이터 샘플(앞 20)**: PRD_000283 트레싱지봉투 / PRD_000282 카드봉투(블랙) / PRD_000281 카드봉투(화이트) / PRD_000280 레더라벨제작 / PRD_000279 메쉬 에코백 / … / PRD_000264 레더숄더백
- MES품목코드는 전부 `-`(미부여 다수)

### 2. 사이즈정보 `tsizsizes` — "변경할 사이즈정보 선택"
- **컬럼**: 사이즈코드 · 사이즈명 · 태그 · 작업가로 · 작업세로 · 재단가로 · 재단세로 · 조판판형여부
- **필터**: 사용여부 (으)로
- **샘플**: SIZ_000520 A4(210x297mm) 반칼 / SIZ_000519 90x110 / SIZ_000518 100x148 / SIZ_000517 B7 (91X128) / … / SIZ_000501 원형10x10
- 태그 컬럼 대부분 `—`, SIZ_000510만 Tag1Tag2Tag3+2

### 3. 도수정보 `tclrcolorcounts` — "변경할 도수정보 선택"
- **컬럼**: 도수코드 · 도수명 · 채널수 · 사용여부 · 비고 · 삭제여부 · 삭제일시 · 등록일시
- **필터**: 사용여부 (으)로
- **전수(5)**: CLR_000005 CMYK 4도(4) / CLR_000004 3도(3) / CLR_000003 2도(2) / CLR_000002 1도(흑백)(1) / CLR_000001 인쇄 안 함(0)

### 4. 인쇄옵션 `tprtprintoptions` — "변경할 인쇄옵션 선택"
- **컬럼**: 인쇄옵션코드 · 인쇄옵션명 · 앞면도수코드 · 뒷면도수코드 · 표시순서 · 사용여부 · 삭제여부
- **필터**: 사용여부 (으)로
- **전수(7)**: POPT_000007 단면7도 / POPT_000006 양면9도 / POPT_000005 투명테두리 / POPT_000004 배면양면 / POPT_000003 풀빼다 / POPT_000002 양면 / POPT_000001 단면 (앞면도수 전부 CMYK 4도)

### 5. 가격공식 `tprcpriceformulas` — "변경할 가격공식 선택"
- **컬럼**: 공식명 · 비고 · 사용여부 · 구성요소 수
- **필터**: 사용여부 (으)로
- **샘플**: 떡메모지 사이즈/권당장수/장수별 단가 / 타투스티커 합가형(3장당 4000) / 스티커팩 합가형(54장1세트 4000) / 스티커 규격/소재/수량별 단가 / 방수포스터 완제품가(면적/규격 단가) / … / 포맥스보드 완제품가(면적/규격 단가)
- 비고가 쉬운 한국어 설명(예: "수량×(사이즈·권당장수·장수) 표에서 단가 조회")

### 6. 가격구성요소 `tprcpricecomponents` — "변경할 가격구성요소 선택"
- **컬럼**: 구성요소명 · 구성요소유형코드 · 단가유형코드 · 사용차원목록 · 비고 · 사용여부 · 삭제여부 · 단가표
- **필터**: 구성요소유형코드 (으)로 · 단가유형코드 (으)로 · 사용여부 (으)로
- **샘플**: 떡메모지 단가(완제품가) [COMP_TTEOKME] / 타투스티커 단가(3장 합가형) [COMP_STK_TATTOO] / 스티커 단가 [COMP_STK_PRINT] / 별색인쇄비(인쇄비·단가형) / 디지털인쇄비 출력비 / 가변텍스트 · 가변이미지(후가공비) / 미싱비 · 오시비 · 모서리 비 / 포스터 완제품가 [COMP_POSTER_*]
- 구성요소명에 `[COMP_*]` 코드 병기(일부 행)

### 7. 할인테이블(수량구간) `tdscdiscounttables` — "변경할 수량구간할인 마스터 선택"
- **컬럼**: 할인테이블명 · 할인유형코드 · 비고 · 사용여부 · 등록일시 · 수정일시 · 수량구간 할인
- **필터**: 할인유형코드 (으)로 · 사용여부 (으)로
- **전수(7)**: 문구상품 / 말랑상품(말랑키링/포카홀더/네임택/여권케이스 등) / 굿즈상품 B타입 / 굿즈상품 A타입 / 파우치·에코백(필통, 에코백부자재 제외) / 아크릴 카테고리(카라비너 제외) / 아크릴카라비너 전용 — 전부 할인유형=정률

### 8. 추가상품 템플릿 `tprdtemplates` — "변경할 추가상품 템플릿 선택"
- **컬럼**: 기준상품명 · 템플릿명 · 구성 내용 · 기본수량 · 사용여부
- **필터**: 사용여부 (으)로 · 기준상품코드 (으)로
- **전수(7)**: OPP접착봉투 110x160 50장 / OPP비접착봉투 110x160 50장 / OPP비접착봉투 60x90 20장 / PET배너 테스트 템플릿(공정 무광) / 카드봉투(화이트) 165x115 50장 / 카드봉투(블랙) 165x115 50장 / 트레싱지봉투 160x110 20장
- "PET배너 테스트 템플릿"=테스트 데이터로 보임(주의)

### 9. 고객 `tcuscustomers` — "변경할 고객 선택"
- **컬럼**: (목록 비어 있음 — 데이터 0행) · **필터**: 사용여부 (으)로

### 10. 사용자 `auth/user` — "변경할 사용자 선택"
- **컬럼**: 사용자 이름 · 이메일 주소 · 이름 · 성 · 스태프 권한 · **필터**: 활성 (으)로
- **샘플(3)**: admin (heehang.seo@gmail.com) / huniprinting / test_admin_p9

---

## 커스텀 페이지 — 보이는 요소

### 카테고리 (3단계) `/admin/category-master/`
- 안내: "3단계 구조 — 대분류→중분류→소분류. 왼쪽 선택 시 다음 단계가 오른쪽. 추가/편집=admin 폼 팝업, 삭제=논리삭제(del_yn=Y)"
- **대분류 13노드(라이브)**: 엽서/카드 CAT_000001(3) · 스티커 CAT_000002(1) · 인쇄홍보물 CAT_000003(3) · 포스터 CAT_000004(3) · 사인 CAT_000005(2) · 책자 CAT_000006(2) · 캘린더 CAT_000007(5) · 문구 CAT_000008(3) · 아크릴 CAT_000009(3) · 라이프 CAT_000010(5) · 에코백 CAT_000011(8) · 포장 CAT_000012(6) · 상품악세사리 CAT_000293
- 헤더 표기 "대분류 25 + 추가" (총 카테고리 노드 합계 표시로 추정)

### 자재 (마스터-디테일) `/admin/master/mat/`
- 안내: "좌=상위자재 · 우=선택 항목의 자재. 추가/편집=폼 팝업, 삭제=논리삭제(del_yn=Y)"
- **상위자재 123 + 추가/편집/삭제** 버튼
- **샘플**: 화이트면지 MAT_000001 / 블랙면지 MAT_000002 / 그레이면지 MAT_000003 / 인쇄면지 MAT_000004 / 링 MAT_000012(5) / 캘린더링 MAT_000021(2) / 비코팅스티커 MAT_000084 / 아코팩(웜화이트) 250g MAT_000113 / 린넨커버 216g MAT_000116 …

### 공정 (마스터-디테일) `/admin/master/proc/`
- 우측 디테일 테이블 컬럼: **코드 · 명 · 표시순서 · 상세 · 사용**
- **상위공정 22 + 추가/편집/삭제**
- **상위공정 샘플**: 인쇄 PROC_000001(4) / 별색인쇄 PROC_000007(5) / 코팅 PROC_000013(3) / 제본 PROC_000017(13) / 귀돌이 PROC_000026(2) / 오시 PROC_000029(1) / 미싱 PROC_000030(1) / 박 PROC_000033(16) / 형압 PROC_000050(2) / 완칼 PROC_000053 / 반칼 PROC_000054 / 스티커완칼 PROC_000055 / 접지 PROC_000056(18) / 포장 PROC_000075(3) / 타공 PROC_000079 / 봉제

### 기초코드 (마스터-디테일) `/admin/basecode-master/`
- 우측 디테일 컬럼: **코드 · 명 · 표시순서 · 사용** + 코드별 [편집][삭제]
- **그룹 13** — §기초코드 도메인 참조

### 가격 뷰어 `/admin/price-viewer/`
- 좌=카테고리별 상품 목록, 각 상품에 가격 상태 배지: **공식 / 셋트 / 가격없음** + 생산형태 접미사(기/디 = 기성/디자인)
- 샘플: PET배너(공식) / PUR책자(공식) / 라벨·택(공식) / 떡메모지(셋트) / OPP봉투·아크릴명찰·극세사클리너·키링류(가격없음)

### 가격 시뮬레이터 `/admin/price-simulator/`
- 좌 패널 "상품 (구성요소 수)" · 우 패널 "조건 입력"
- 안내: "좌측에서 상품 선택 → [가격 계산] → 구성요소별 계산 상세 표시"

### 상품 뷰어 `/admin/product-viewer/` (홈)
- 좌=카테고리 그룹별 상품 목록(상품명 + 생산형태 접미사 + PRD코드). 예: OPP비접착봉투 PRD_000002 / PET배너 PRD_000136 / PUR책자 PRD_000070 …
- 상세는 상품 클릭 시 섹션 탭(카테고리·사이즈·도수/인쇄옵션·판형·자재·공정·묶음수·추가상품·페이지룰) 로드 — round-8 `13_admin-ui-spec` 권위. 헤드리스 클릭으로 좌 목록까지 캡처(`product-viewer__detail.png`).

---

## 기초코드 코드값 도메인 (13그룹 · 64코드 전수 펼침)

| 그룹 | 코드그룹 | 코드값(코드·명) |
|------|---------|----------------|
| 상품유형 | PRD_TYPE (5) | 01 완제품 · 02 반제품 · 03 기성상품 · 04 디자인상품 · 05 추가상품 |
| 반제품역할 | SEMI_ROLE (5) | 01 내지 · 02 표지 · 03 면지 · 04 간지 · 05 투명커버 |
| 고객등급 | CUS_GRADE (2) | 01 VIP · 02 일반 |
| 자재유형 | MAT_TYPE (14) | 01 디지털인쇄용지 · 02 제본부자재 · 03 아크릴 · 04 금속 · 05 특수소재 · 06 가죽 · 07 부자재 · 08 실사소재 · 09 파우치 · 10 악세사리 · 11 스티커용지 · 12 사입자재 · 13 합판 스티커용지 · 14 합판 봉투용지 |
| 가격구성요소유형 | PRC_COMPONENT_TYPE (7) | 01 인쇄비 · 02 코팅비 · 03 용지비 · 04 후가공비 · 05 박형압비 · 06 완제품비 · 07 제본비 |
| 출력용지유형 | OUTPUT_PAPER_TYPE (3) | 01 국전계열 · 02 46계열 · 03 기타 |
| 할인유형 | DSC_TYPE (2) | 01 정률 · 02 정액 |
| 선택유형 | SEL_TYPE (2) | 01 단일 · 02 다중 |
| 용도 | USAGE (7) | 01 내지 · 02 표지 · 03 면지 · 04 간지 · 05 투명커버 · 06 표지타입 · 07 공통 |
| 수량단위 | QTY_UNIT (6) | 01 EA · 02 매 · 03 권 · 04 세트 · 05 팩 · 06 장 |
| 옵션참조차원유형 | OPT_REF_DIM (7) | 01 사이즈 · 02 판형 · 03 자재 · 04 공정 · 05 묶음수 · 06 도수 · 07 셋트 |
| 제약규칙유형 | RULE_TYPE (3) | 01 호환(사용여부 N) · 02 금지 · 03 필수동반 |
| 단가유형 | PRICE_TYPE (2) | 01 단가형 · 02 합가형 |

---

## 대표 changeform (add) — 읽기 탐색만 (저장/삭제 클릭 0)

### 상품정보 추가 `tprdproducts/add/` (`tprdproducts__changeform.png`)
- **필드 라벨(24)**: 상품코드 · MES품목코드 · 상품명* · 상품유형코드* · 반제품역할코드 · 비규격여부* · 비규격가로최소 · 비규격가로최대 · 비규격가로증가단위 · 비규격세로최소 · 비규격세로최대 · 비규격세로증가단위 · 파일업로드지원여부* · 편집기지원여부* · 최소수량 · 최대수량 · 증가단위 · 기본수량 · 사용여부* · 삭제여부* · 수량단위유형코드 · 삭제일시 · 등록일시 · 수정일시 (`*`=필수)
- **드롭다운 위젯 도메인(라이브 select)**:
  - `prd_typ_cd`: 완제품 / 반제품 / 기성상품 / 디자인상품 / 추가상품
  - `semi_role_cd`: 내지 / 표지 / 면지 / 간지 / 투명커버
  - `nonspec_yn`·`file_upload_yn`·`editor_yn`·`use_yn`·`del_yn`: Y / N
  - `qty_unit_typ_cd`: EA / 매 / 권 / 세트 / 팩 / 장
- **인라인**: 상품별카테고리(`tprdproductcategories_set`) — cat_cd 셀렉트 + main_cat_yn(— / N / Y)

---

## 소스 화면맵 대비 드리프트 (라이브 권위)

| # | 차이 | 소스 맵 | 라이브(권위) |
|---|------|--------|--------------|
| D-1 | **커스텀 마스터 페이지가 정식 메뉴** | 소스 맵은 표준 Django changelist 중심(카테고리·자재·공정·기초코드는 t_* 모델 changelist로 기술) | 사이드바에 **카테고리=/admin/category-master/(3단계)·자재=/admin/master/mat/·공정=/admin/master/proc/·기초코드=/admin/basecode-master/** 커스텀 마스터-디테일 화면으로 노출. URL이 `/admin/catalog/{model}/`이 아님 |
| D-2 | **가격 뷰어·시뮬레이터 메뉴화** | (커스텀 뷰어로 언급되나 IA 별도) | 가격 관리 그룹에 가격 뷰어·가격 시뮬레이터 정식 메뉴(payments·calculate) |
| D-3 | (해소) MAT_TYPE 14개 전수 확인 | — | 자재유형 14개 모두 실재(.13 합판 스티커용지·.14 합판 봉투용지 포함). 초기 추출 truncate였음 — 드리프트 아님 |
| D-4 | **고객 목록 0행** | — | `tcuscustomers` changelist 데이터 0행(운영 고객 미적재) |
| D-5 | **테스트 데이터 잔존** | — | 추가상품 템플릿에 "PET배너 테스트 템플릿", auth/user에 test_admin_p9 |
| D-6 | **사이즈/공정/자재 신규 채번 반영** | 소스 맵 캡처(06-10) 이후 | SIZ_000518~520(반칼·90x110·100x148), 자재 123종·공정 상위 22종 등 round-22/23 적재분 반영 |

> 표준 admin 모델 라벨·컬럼은 소스 맵과 대체로 일치(드리프트 0). 차이는 주로 커스텀 메뉴 구성(D-1/D-2)과 적재 데이터 진화(D-6).

---

## 캡처 파일 (`./captures/`)
authuser__changelist · basecode-master__page · category-master__page · master-mat__page · master-proc__page · price-simulator__page · price-viewer__page · product-viewer__home · product-viewer__detail · tclrcolorcounts__changelist · tcuscustomers__changelist · tdscdiscounttables__changelist · tprcpricecomponents__changelist · tprcpriceformulas__changelist · tprdproducts__changelist · tprdproducts__changeform · tprdtemplates__changelist · tprtprintoptions__changelist · tsizsizes__changelist (총 19장)
