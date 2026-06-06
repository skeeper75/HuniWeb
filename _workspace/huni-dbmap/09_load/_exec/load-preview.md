# round-5 적재 미리보기 (커밋 없음 · DB 무변경)

> 이 문서는 round-5가 라이브 `railway` DB에 **넣을 데이터**를 사람이 읽는 형태로 보여준다.
> **실제 적재(COMMIT)는 하지 않았다** — 뷰어에는 아직 안 보이는 게 정상. 커밋 승인 시 아래대로 들어간다.
> 코드→이름은 라이브 마스터(read-only) 기준. usage: 01내지·02표지·07공통 등.

---
## 1. 상품마스터 트랙 — 상품별 추가분

적재 대상 상품 **47개** · 자재 316행 · 공정 62행 · 묶음수 6행

### 프리미엄엽서 (PRD_000016)
- 자재 +21 — **공통** 21종: 백색모조지 220g(기본) · 아트지 300g · 스노우지 300g · 랑데뷰 WH 240g · 몽블랑 240g · 아코팩(웜화이트) 250g · 리사이클러스 240g · 매쉬멜로우 233g · 린넨커버 216g · 스타화이트(하이테크) 238g · 클래식 크래스트 스티플 270g · 매직터치(백색) 250g · 켄도 250g · 띤또레또 200g · 띤또레또 250g · 한지 170g · 스코트랜드 220g · 스타드림(다이아몬드) 240g · 스타드림(실버) 240g · 스타드림(골드) 240g · 스타드림(로즈쿼츠) 240g

### 스탠다드엽서 (PRD_000018)
- 자재 +7 — **공통** 7종: 백색모조지 220g(기본) · 아트지 200g · 아트지 250g · 아트지 300g · 스노우지 200g · 스노우지 250g · 스노우지 300g
- 공정 +4 — 오시(옵션) · 미싱(옵션) · 가변텍스트(옵션) · 가변이미지(옵션)

### 2단접지카드 (PRD_000027)
- 자재 +14 — **공통** 14종: 백색모조지 220g(기본) · 아트지 250g · 아트지 300g · 스노우지 250g · 스노우지 300g · 랑데뷰 WH 240g · 몽블랑 210g · 몽블랑 240g · 아코팩(웜화이트) 250g · 리사이클러스 240g · 매쉬멜로우 233g · 린넨커버 216g · 띤또레또 200g · 한지 170g
- 공정 +2 — 가변텍스트(옵션) · 가변이미지(옵션)

### 미니접지카드 (PRD_000028)
- 자재 +14 — **공통** 14종: 백색모조지 220g(기본) · 아트지 250g · 아트지 300g · 스노우지 250g · 스노우지 300g · 랑데뷰 WH 240g · 몽블랑 210g · 몽블랑 240g · 아코팩(웜화이트) 250g · 리사이클러스 240g · 매쉬멜로우 233g · 린넨커버 216g · 띤또레또 200g · 한지 170g

### 3단접지카드 (PRD_000029)
- 자재 +14 — **공통** 14종: 백색모조지 220g(기본) · 아트지 250g · 아트지 300g · 스노우지 250g · 스노우지 300g · 랑데뷰 WH 240g · 몽블랑 210g · 몽블랑 240g · 아코팩(웜화이트) 250g · 리사이클러스 240g · 매쉬멜로우 233g · 린넨커버 216g · 띤또레또 200g · 한지 170g
- 공정 +2 — 가변텍스트(옵션) · 가변이미지(옵션)

### 프리미엄명함 (PRD_000031)
- 자재 +16 — **공통** 16종: 앙상블 210g(기본) · 랑데뷰 WH 240g · 랑데뷰 WH 310g · 몽블랑 210g · 몽블랑 240g · 아코팩(웜화이트) 250g · 리사이클러스 240g · 매쉬멜로우 233g · 린넨커버 216g · 스타화이트(하이테크) 238g · 클래식 크래스트 스티플 270g · 리브스디자인 250g · 띤또레또 200g · 띤또레또 250g · 한지 170g · 스코트랜드 220g
- 공정 +2 — 가변텍스트(옵션) · 가변이미지(옵션)

### 스탠다드명함 (PRD_000033)
- 공정 +2 — 가변텍스트(옵션) · 가변이미지(옵션)

### 스탠다드 쿠폰/상품권 (PRD_000041)
- 공정 +4 — 오시(옵션) · 미싱(옵션) · 가변텍스트(옵션) · 가변이미지(옵션)

### 프리미엄 쿠폰/상품권 (PRD_000042)
- 공정 +4 — 오시(옵션) · 미싱(옵션) · 가변텍스트(옵션) · 가변이미지(옵션)

### 소량전단지 (PRD_000047)
- 자재 +47 — **공통** 47종: 백색모조지 100g(기본) · 백색모조지 120g · 백색모조지 220g · 아트지 100g · 아트지 120g · 아트지 150g · 아트지 180g · 아트지 200g · 아트지 250g · 아트지 300g · 스노우지 100g · 스노우지 120g · 스노우지 150g · 스노우지 180g · 스노우지 200g · 스노우지 250g · 스노우지 300g · 앙상블 100g · 앙상블 130g · 앙상블 160g · 앙상블 190g · 앙상블 210g · 랑데뷰 WH 240g · 랑데뷰 WH 310g · 몽블랑 100g · 몽블랑 130g · 몽블랑 160g · 몽블랑 190g · 몽블랑 210g · 몽블랑 240g · 아코팩(웜화이트) 250g · 리사이클러스 240g · 매쉬멜로우 233g · 린넨커버 216g · 스타화이트(하이테크) 238g · 클래식 크래스트 스티플 270g · 리브스디자인 250g · 매직터치(백색) 250g · 켄도 250g · 띤또레또 200g · 띤또레또 250g · 한지 170g · 스코트랜드 220g · 스타드림(다이아몬드) 240g · 스타드림(실버) 240g · 스타드림(골드) 240g · 스타드림(로즈쿼츠) 240g
- 공정 +2 — 가변텍스트(옵션) · 가변이미지(옵션)

### 접지리플렛 (PRD_000048)
- 자재 +47 — **공통** 47종: 백색모조지 100g(기본) · 백색모조지 120g · 백색모조지 220g · 아트지 100g · 아트지 120g · 아트지 150g · 아트지 180g · 아트지 200g · 아트지 250g · 아트지 300g · 스노우지 100g · 스노우지 120g · 스노우지 150g · 스노우지 180g · 스노우지 200g · 스노우지 250g · 스노우지 300g · 앙상블 100g · 앙상블 130g · 앙상블 160g · 앙상블 190g · 앙상블 210g · 랑데뷰 WH 240g · 랑데뷰 WH 310g · 몽블랑 100g · 몽블랑 130g · 몽블랑 160g · 몽블랑 190g · 몽블랑 210g · 몽블랑 240g · 아코팩(웜화이트) 250g · 리사이클러스 240g · 매쉬멜로우 233g · 린넨커버 216g · 스타화이트(하이테크) 238g · 클래식 크래스트 스티플 270g · 리브스디자인 250g · 매직터치(백색) 250g · 켄도 250g · 띤또레또 200g · 띤또레또 250g · 한지 170g · 스코트랜드 220g · 스타드림(다이아몬드) 240g · 스타드림(실버) 240g · 스타드림(골드) 240g · 스타드림(로즈쿼츠) 240g
- 공정 +2 — 가변텍스트(옵션) · 가변이미지(옵션)

### 와이드 접지리플렛 (PRD_000049)
- 공정 +2 — 가변텍스트(옵션) · 가변이미지(옵션)

### 반칼 자유형 투명스티커 (PRD_000053)
- 공정 +1 — 화이트(옵션)

### 반칼 자유형 홀로그램스티커 (PRD_000054)
- 공정 +1 — 화이트(옵션)

### 낱장 자유형 투명스티커 (PRD_000056)
- 공정 +1 — 화이트(옵션)

### 중철책자 (PRD_000068)
- 자재 +26 — **내지** 13종: 백색모조지 120g(기본) · 아트지 120g · 아트지 150g · 아트지 180g · 아트지 200g · 스노우지 120g · 스노우지 150g · 스노우지 180g · 스노우지 200g · 몽블랑 100g · 몽블랑 130g · 몽블랑 160g · 몽블랑 190g / **표지** 13종: 백색모조지 120g(기본) · 아트지 120g · 아트지 150g · 아트지 180g · 아트지 200g · 스노우지 120g · 스노우지 150g · 스노우지 180g · 스노우지 200g · 몽블랑 100g · 몽블랑 130g · 몽블랑 160g · 몽블랑 190g

### 무선책자 (PRD_000069)
- 자재 +13 — **내지** 7종: 백색모조지 120g(기본) · 아트지 120g · 스노우지 120g · 앙상블 100g · 앙상블 130g · 몽블랑 100g · 몽블랑 130g / **표지** 6종: 백색모조지 220g(기본) · 아트지 250g · 아트지 300g · 스노우지 250g · 스노우지 300g · 몽블랑 240g
- 공정 +2 — 양각(옵션) · 음각(옵션)

### PUR책자 (PRD_000070)
- 공정 +2 — 양각(옵션) · 음각(옵션)

### 트윈링책자 (PRD_000071)
- 자재 +44 — **내지** 16종: 백색모조지 100g(기본) · 백색모조지 120g · 아트지 100g · 아트지 120g · 아트지 150g · 아트지 180g · 스노우지 100g · 스노우지 120g · 스노우지 150g · 스노우지 180g · 앙상블 100g · 앙상블 130g · 앙상블 160g · 몽블랑 100g · 몽블랑 130g · 몽블랑 160g / **표지** 28종: 백색모조지 100g(기본) · 백색모조지 120g · 백색모조지 220g · 아트지 100g · 아트지 120g · 아트지 150g · 아트지 180g · 아트지 200g · 아트지 250g · 아트지 300g · 스노우지 100g · 스노우지 120g · 스노우지 150g · 스노우지 180g · 스노우지 200g · 스노우지 250g · 스노우지 300g · 앙상블 100g · 앙상블 130g · 앙상블 160g · 앙상블 190g · 앙상블 210g · 몽블랑 100g · 몽블랑 130g · 몽블랑 160g · 몽블랑 190g · 몽블랑 210g · 몽블랑 240g

### 탁상형캘린더 (PRD_000108)
- 자재 +7 — **공통** 7종: 스노우지 200g(기본) · 아코팩(웜화이트) 250g · 리사이클러스 240g · 매쉬멜로우 233g · 린넨커버 216g · 띤또레또 200g · 스타드림(다이아몬드) 240g

### 미니탁상형캘린더 (PRD_000109)
- 자재 +6 — **공통** 6종: 스노우지 200g(기본) · 아코팩(웜화이트) 250g · 리사이클러스 240g · 매쉬멜로우 233g · 린넨커버 216g · 스타드림(다이아몬드) 240g

### 엽서캘린더 (PRD_000110)
- 자재 +9 — **공통** 9종: 스노우지 200g(기본) · 앙상블 190g · 아코팩(웜화이트) 250g · 리사이클러스 240g · 매쉬멜로우 233g · 린넨커버 216g · 클래식 크래스트 스티플 270g · 띤또레또 200g · 스타드림(다이아몬드) 240g

### 벽걸이캘린더 (PRD_000111)
- 자재 +21 — **공통** 21종: 백색모조지 220g(기본) · 아트지 180g · 아트지 200g · 아트지 250g · 아트지 300g · 스노우지 180g · 스노우지 200g · 스노우지 250g · 스노우지 300g · 앙상블 160g · 앙상블 190g · 앙상블 210g · 몽블랑 210g · 아코팩(웜화이트) 250g · 리사이클러스 240g · 매쉬멜로우 233g · 린넨커버 216g · 클래식 크래스트 스티플 270g · 리브스디자인 250g · 띤또레또 200g · 스타드림(다이아몬드) 240g

### 접착투명포스터 (PRD_000122)
- 공정 +1 — 화이트(옵션)

### 아크릴키링 (PRD_000146)
- 자재 +2 — **공통** 2종: 아크릴부속 은색고리 · 아크릴부속 금색고리
- 공정 +1 — UV(필수)

### 아크릴마그넷 (PRD_000147)
- 공정 +2 — UV(필수) · 부착(옵션)

### 아크릴뱃지 (PRD_000148)
- 자재 +2 — **공통** 2종: 아크릴부속 원형핀 · 아크릴부속 1구자석
- 공정 +1 — UV(필수)

### 아크릴집게 (PRD_000149)
- 자재 +1 — **공통** 1종: 아크릴부속 투명집게
- 공정 +1 — UV(필수)

### 아크릴스마트톡 (PRD_000150)
- 자재 +2 — **공통** 2종: 아크릴부속 화이트바디 · 아크릴부속 투명바디
- 공정 +1 — UV(필수)

### 맥세이프 스마트톡 (PRD_000151)
- 공정 +1 — UV(필수)

### 아크릴명찰 (PRD_000152)
- 자재 +2 — **공통** 2종: 아크릴부속 일자핀 · 아크릴부속 2구자석
- 공정 +1 — UV(필수)

### 아크릴 머리끈 (PRD_000154)
- 자재 +1 — **공통** 1종: 아크릴부속 블랙헤어끈

### 아크릴볼펜 (PRD_000155)
- 공정 +1 — UV(필수)

### 아크릴네임택 (PRD_000157)
- 공정 +1 — UV(필수)

### 아크릴 포카키링 (PRD_000158)
- 공정 +1 — UV(필수)

### 아크릴자유형스탠드 (PRD_000160)
- 공정 +1 — UV(필수)
- 묶음수 +5 — 2EA(기본) · 3EA · 4EA · 5EA · 6EA

### 판아크릴 (PRD_000161)
- 공정 +1 — UV(필수)

### 아크릴포카스탠드 (PRD_000162)
- 공정 +1 — UV(필수)

### 아크릴미니파츠 (PRD_000163)
- 공정 +1 — UV(필수)
- 묶음수 +1 — 10EA(기본)

### 만년다이어리(소프트커버) (PRD_000172)
- 공정 +1 — 무광(옵션)

### 만년다이어리(하드커버) (PRD_000173)
- 공정 +2 — 하드커버무선제본(필수) · 무광(옵션)

### 만년다이어리(레더하드커버) (PRD_000174)
- 공정 +1 — 하드커버무선제본(필수)

### 먼슬리플래너 (PRD_000176)
- 공정 +1 — 무광(옵션)

### 스프링노트 (PRD_000177)
- 공정 +2 — 트윈링제본(필수) · 무광(옵션)

### 스프링수첩 (PRD_000178)
- 공정 +2 — 트윈링제본(필수) · 무광(옵션)

### 메모패드 (PRD_000179)
- 공정 +2 — 떡제본(필수) · 무광(옵션)

### 중철노트 (PRD_000181)
- 공정 +2 — 중철제본(필수) · 무광(옵션)

### 코드행 선적재 (마스터 신규 코드 — 후니 라이브 등록 대상)
- 공정 t_proc_processes: 1행 — 레이저커팅
- 사이즈 t_siz_sizes: 11행 — 원형10x10, 원형15x15, 원형20x20, 원형25x25, 원형30x30, 원형35x35, 원형40x40, 원형45x45, 원형50x50, 원형55x55, 원형60x60

---
## 2. 가격 트랙 — 추가분 (라이브 t_prc_* 현재 0행 → 신규 적재)

### 상품 ↔ 가격공식 바인딩 +45
- 봉투제작 (PRD_000050) → 봉투제작 소재/수량별 단가
- 반칼 자유형 스티커 (PRD_000052) → 스티커 규격/소재/수량별 단가
- 반칼 자유형 투명스티커 (PRD_000053) → 스티커 규격/소재/수량별 단가
- 낱장 자유형 스티커 (PRD_000055) → 스티커 규격/소재/수량별 단가
- 합판도무송스티커 (PRD_000066) → 합판도무송 사이즈/소재/수량별 단가
- 스탠다드명함 (PRD_000033) → 명함 면/소재/수량별 단가(용지포함)
- 프리미엄명함 (PRD_000031) → 명함 면/소재/수량별 단가(용지포함)
- 코팅명함 (PRD_000032) → 명함 면/소재/수량별 단가(용지포함)
- 엽서북 (PRD_000094) → 엽서북 사이즈/면/페이지/수량별 단가
- 접지리플렛 (PRD_000048) → 접지 합산형(오시+접지 후가공 구성요소)
- 중철책자 (PRD_000068) → 제본 합산형(제본비 구성요소)
- 무선책자 (PRD_000069) → 제본 합산형(제본비 구성요소)
- 트윈링책자 (PRD_000071) → 제본 합산형(제본비 구성요소)
- PUR책자 (PRD_000070) → 제본 합산형(제본비 구성요소)
- 떡메모지 (PRD_000097) → 떡메모지 사이즈/권당장수/장수별 단가
- 포토카드 (PRD_000024) → 포토카드 세트 고정가
- 투명포토카드 (PRD_000025) → 포토카드 세트 고정가
- 아트프린트포스터 (PRD_000118) → 포스터사인 소재/사이즈/수량별 완제품가(포함항목 통가격)
- 아트페이퍼포스터 (PRD_000119) → 포스터사인 소재/사이즈/수량별 완제품가(포함항목 통가격)
- 방수포스터 (PRD_000120) → 포스터사인 소재/사이즈/수량별 완제품가(포함항목 통가격)
- 접착방수포스터 (PRD_000121) → 포스터사인 소재/사이즈/수량별 완제품가(포함항목 통가격)
- 접착투명포스터 (PRD_000122) → 포스터사인 소재/사이즈/수량별 완제품가(포함항목 통가격)
- 아트패브릭포스터 (PRD_000123) → 포스터사인 소재/사이즈/수량별 완제품가(포함항목 통가격)
- 린넨패브릭포스터 (PRD_000124) → 포스터사인 소재/사이즈/수량별 완제품가(포함항목 통가격)
- 캔버스패브릭포스터 (PRD_000125) → 포스터사인 소재/사이즈/수량별 완제품가(포함항목 통가격)
- 레더아트프린트 (PRD_000126) → 포스터사인 소재/사이즈/수량별 완제품가(포함항목 통가격)
- 타이벡프린트 (PRD_000127) → 포스터사인 소재/사이즈/수량별 완제품가(포함항목 통가격)
- 메쉬프린트 (PRD_000128) → 포스터사인 소재/사이즈/수량별 완제품가(포함항목 통가격)
- 프레임리스우드액자 (PRD_000131) → 포스터사인 소재/사이즈/수량별 완제품가(포함항목 통가격)
- 레더아트액자 (PRD_000132) → 포스터사인 소재/사이즈/수량별 완제품가(포함항목 통가격)
- 족자포스터 (PRD_000135) → 포스터사인 소재/사이즈/수량별 완제품가(포함항목 통가격)
- 캔버스 행잉포스터 (PRD_000133) → 포스터사인 소재/사이즈/수량별 완제품가(포함항목 통가격)
- 린넨 우드봉 족자 (PRD_000134) → 포스터사인 소재/사이즈/수량별 완제품가(포함항목 통가격)
- PET배너 (PRD_000136) → 포스터사인 소재/사이즈/수량별 완제품가(포함항목 통가격)
- 메쉬배너 (PRD_000137) → 포스터사인 소재/사이즈/수량별 완제품가(포함항목 통가격)
- 일반현수막 (PRD_000138) → 포스터사인 소재/사이즈/수량별 완제품가(포함항목 통가격)
- 메쉬현수막 (PRD_000139) → 포스터사인 소재/사이즈/수량별 완제품가(포함항목 통가격)
- 미니보드스탠딩 (PRD_000144) → 포스터사인 소재/사이즈/수량별 완제품가(포함항목 통가격)
- 미니배너 (PRD_000145) → 포스터사인 소재/사이즈/수량별 완제품가(포함항목 통가격)
- 폼보드 (PRD_000129) → 포스터사인 소재/사이즈/수량별 완제품가(포함항목 통가격)
- 포맥스보드 (PRD_000130) → 포스터사인 소재/사이즈/수량별 완제품가(포함항목 통가격)
- 유광아크릴스티커 (PRD_000142) → 포스터사인 소재/사이즈/수량별 완제품가(포함항목 통가격)
- 미러아크릴스티커 (PRD_000143) → 포스터사인 소재/사이즈/수량별 완제품가(포함항목 통가격)
- 무광시트커팅 (PRD_000140) → 포스터사인 소재/사이즈/수량별 완제품가(포함항목 통가격)
- 홀로그램 시트커팅 (PRD_000141) → 포스터사인 소재/사이즈/수량별 완제품가(포함항목 통가격)

### 구성요소 다차원 단가 +2108행 (125개 구성요소)

| 구성요소 | 행수 | 단가범위(원) | 비고 |
|---|---|---|---|
| 합판도무송 단가(완제품가) [COMP_GANGPAN_PRINT] | 260 | 18,000 ~ 189,900 | COMP_GANGPAN_PRINT |
| 스티커 단가(완제품가) [COMP_STK_PRINT] | 258 | 3,200 ~ 28,000 | COMP_STK_PRINT |
| 엽서북 단가(완제품가) [COMP_PCB_S1_20P] | 117 | 2,200 ~ 12,000 | COMP_PCB_S1_20P |
| 엽서북 단가(완제품가) [COMP_PCB_S1_30P] | 117 | 2,900 ~ 12,500 | COMP_PCB_S1_30P |
| 엽서북 단가(완제품가) [COMP_PCB_S2_20P] | 117 | 2,300 ~ 12,500 | COMP_PCB_S2_20P |
| 엽서북 단가(완제품가) [COMP_PCB_S2_30P] | 117 | 3,100 ~ 13,500 | COMP_PCB_S2_30P |
| 떡메모지 단가(완제품가) [COMP_TTEOKME] | 112 | 850 ~ 3,200 | COMP_TTEOKME |
| 포토카드 단가(완제품가) [COMP_PHOTOCARD_BULK] | 50 | 5,000 ~ 126,000 | COMP_PHOTOCARD_BULK |
| 접지비(후가공) [COMP_FOLD_CARD_2H] | 48 | 40 ~ 5,000 | COMP_FOLD_CARD_2H |
| 접지비(후가공) [COMP_FOLD_CARD_3H] | 48 | 50 ~ 6,000 | COMP_FOLD_CARD_3H |
| 접지비(후가공) [COMP_FOLD_CARD_6CR] | 48 | 50 ~ 6,000 | COMP_FOLD_CARD_6CR |
| 접지비(후가공) [COMP_FOLD_LEAF_HALF] | 48 | 40 ~ 5,000 | COMP_FOLD_LEAF_HALF |
| 접지비(후가공) [COMP_FOLD_LEAF_3FOLD] | 48 | 50 ~ 6,000 | COMP_FOLD_LEAF_3FOLD |
| 접지비(후가공) [COMP_FOLD_LEAF_4ACC] | 48 | 65 ~ 7,000 | COMP_FOLD_LEAF_4ACC |
| 접지비(후가공) [COMP_FOLD_LEAF_4GATE] | 48 | 65 ~ 7,000 | COMP_FOLD_LEAF_4GATE |
| 투명아크릴3T 인쇄가공비 | 47 | 2,500 ~ 22,700 | COMP_ACRYL_CLEAR3T |
| 투명아크릴1.5T 인쇄가공비 | 37 | 2,000 ~ 10,160 | COMP_ACRYL_CLEAR15T |
| 미러아크릴3T 인쇄가공비 | 37 | 5,000 ~ 25,400 | COMP_ACRYL_MIRROR3T |
| 가변텍스트 1개 | 23 | 15,000 ~ 160,000 | COMP_PP_VARTEXT_1EA |
| 가변텍스트 2개 | 23 | 20,000 ~ 240,000 | COMP_PP_VARTEXT_2EA |
| 가변텍스트 3개 | 23 | 25,000 ~ 272,000 | COMP_PP_VARTEXT_3EA |
| 가변이미지 1개 | 23 | 15,000 ~ 160,000 | COMP_PP_VARIMG_1EA |
| 가변이미지 2개 | 23 | 20,000 ~ 240,000 | COMP_PP_VARIMG_2EA |
| 가변이미지 3개 | 23 | 25,000 ~ 272,000 | COMP_PP_VARIMG_3EA |
| 타공비(후가공) [COMP_CUT_PERF_1H6] | 23 | 0 ~ 0 | COMP_CUT_PERF_1H6 |
| 포스터 완제품가(포함항목 통가격) [COMP_POSTER_MINI_STANDBOARD] | 15 | 2,900 ~ 6,500 | COMP_POSTER_MINI_STANDBOARD |
| 오시 1줄 | 10 | 5,000 ~ 105,000 | COMP_PP_CREASE_1L |
| 오시 2줄 | 10 | 6,000 ~ 109,000 | COMP_PP_CREASE_2L |
| 오시 3줄 | 10 | 7,000 ~ 103,000 | COMP_PP_CREASE_3L |
| 미싱 1줄 | 10 | 5,000 ~ 105,000 | COMP_PP_PERF_1L |
| 미싱 2줄 | 10 | 6,000 ~ 109,000 | COMP_PP_PERF_2L |
| 미싱 3줄 | 10 | 7,000 ~ 103,000 | COMP_PP_PERF_3L |
| 포스터 완제품가(포함항목 통가격) [COMP_POSTER_MINI_BANNER] | 10 | 2,800 ~ 6,500 | COMP_POSTER_MINI_BANNER |
| 모서리 직각 | 9 | 0 ~ 0 | COMP_PP_CORNER_RIGHT |
| 모서리 둥근 | 9 | 2,000 ~ 51,000 | COMP_PP_CORNER_ROUND |
| 커팅 합가(완제품가) [COMP_CUT_FULL_PERF_1H6] | 9 | 2,000 ~ 51,000 | COMP_CUT_FULL_PERF_1H6 |
| 커팅 합가(완제품가) [COMP_CUT_FULL_PERF_2H6] | 9 | 4,000 ~ 102,000 | COMP_CUT_FULL_PERF_2H6 |
| 오리지널박 합가(완제품가) [COMP_NAMECARD_FOIL_S1_STD] | 9 | 19,200 ~ 63,000 | COMP_NAMECARD_FOIL_S1_STD |
| 오리지널박 합가(완제품가) [COMP_NAMECARD_FOIL_S1_HOLO] | 9 | 24,800 ~ 92,000 | COMP_NAMECARD_FOIL_S1_HOLO |
| 오리지널박 합가(완제품가) [COMP_NAMECARD_FOIL_S2_STD] | 9 | 19,200 ~ 63,000 | COMP_NAMECARD_FOIL_S2_STD |
| 오리지널박 합가(완제품가) [COMP_NAMECARD_FOIL_S2_HOLO] | 9 | 24,800 ~ 92,000 | COMP_NAMECARD_FOIL_S2_HOLO |
| 제본비(후가공) [COMP_BIND_JUNGCHEOL] | 8 | 500 ~ 3,000 | COMP_BIND_JUNGCHEOL |
| 제본비(후가공) [COMP_BIND_MUSEON] | 8 | 500 ~ 3,000 | COMP_BIND_MUSEON |
| 제본비(후가공) [COMP_BIND_TWINRING] | 8 | 1,000 ~ 4,000 | COMP_BIND_TWINRING |
| 제본비(후가공) [COMP_BIND_PUR] | 8 | 1,500 ~ 5,000 | COMP_BIND_PUR |
| 제본비(후가공) [COMP_BIND_HC_MUSEON] | 6 | 6,000 ~ 30,000 | COMP_BIND_HC_MUSEON |
| 제본비(후가공) [COMP_BIND_HC_TWINRING] | 6 | 7,000 ~ 30,000 | COMP_BIND_HC_TWINRING |
| 제본비(후가공) [COMP_BIND_SSABARI] | 6 | 7,000 ~ 30,000 | COMP_BIND_SSABARI |
| 제본비(후가공) [COMP_BIND_CAL_WALL] | 6 | 2,000 ~ 5,000 | COMP_BIND_CAL_WALL |
| 제본비(후가공) [COMP_BIND_CAL_DESK220] | 6 | 2,000 ~ 5,000 | COMP_BIND_CAL_DESK220 |
| 제본비(후가공) [COMP_BIND_CAL_DESK130] | 6 | 2,000 ~ 5,000 | COMP_BIND_CAL_DESK130 |
| 제본비(후가공) [COMP_BIND_CAL_DESKMINI] | 6 | 1,600 ~ 4,500 | COMP_BIND_CAL_DESKMINI |
| 포스터 완제품가(포함항목 통가격) [COMP_POSTER_JOKJA] | 4 | 13,000 ~ 32,000 | COMP_POSTER_JOKJA |
| 포스터 완제품가(포함항목 통가격) [COMP_POSTER_ACRYLSTK_GLOSS] | 4 | 9,000 ~ 37,000 | COMP_POSTER_ACRYLSTK_GLOSS |
| 포스터 완제품가(포함항목 통가격) [COMP_POSTER_ACRYLSTK_MIRROR] | 4 | 11,000 ~ 50,000 | COMP_POSTER_ACRYLSTK_MIRROR |
| 포스터 완제품가(포함항목 통가격) [COMP_POSTER_CANVAS_HANGING] | 3 | 6,000 ~ 20,000 | COMP_POSTER_CANVAS_HANGING |
| 포스터 추가옵션 추가가격(별도 add-on 통가격) [COMP_POSTEROPT_CANVAS_HANGING_WOODHANGER] | 3 | 16,000 ~ 20,000 | COMP_POSTEROPT_CANVAS_HANGING_WOODHANGER |
| 포스터 완제품가(포함항목 통가격) [COMP_POSTER_LINEN_WOODBONG] | 3 | 6,000 ~ 16,000 | COMP_POSTER_LINEN_WOODBONG |
| 포스터 추가옵션 추가가격(별도 add-on 통가격) [COMP_POSTEROPT_LINEN_WOODBONG_WOODBONG] | 3 | 7,000 ~ 12,000 | COMP_POSTEROPT_LINEN_WOODBONG_WOODBONG |
| 포스터 완제품가(포함항목 통가격) [COMP_POSTER_BANNER_NORMAL] | 3 | 8,000 ~ 12,000 | COMP_POSTER_BANNER_NORMAL |
| 포스터 완제품가(포함항목 통가격) [COMP_POSTER_SHEETCUT_MATTE] | 3 | 6,000 ~ 32,000 | COMP_POSTER_SHEETCUT_MATTE |
| 포스터 완제품가(포함항목 통가격) [COMP_POSTER_SHEETCUT_HOLO] | 3 | 8,000 ~ 32,000 | COMP_POSTER_SHEETCUT_HOLO |
| 스티커 단가(완제품가) [COMP_STK_PACK] | 2 | 4,000 ~ 4,000 | COMP_STK_PACK |
| 명함 단가(용지포함 완제품가) [COMP_NAMECARD_STD_S1] | 2 | 3,500 ~ 3,800 | COMP_NAMECARD_STD_S1 |
| 명함 단가(용지포함 완제품가) [COMP_NAMECARD_STD_S2] | 2 | 4,500 ~ 4,800 | COMP_NAMECARD_STD_S2 |
| 명함 단가(용지포함 완제품가) [COMP_NAMECARD_COAT_S1] | 2 | 5,500 ~ 5,800 | COMP_NAMECARD_COAT_S1 |
| 명함 단가(용지포함 완제품가) [COMP_NAMECARD_COAT_S2] | 2 | 6,500 ~ 6,800 | COMP_NAMECARD_COAT_S2 |
| 명함 단가(용지포함 완제품가) [COMP_NAMECARD_PEARL_S1] | 2 | 9,000 ~ 10,000 | COMP_NAMECARD_PEARL_S1 |
| 명함 단가(용지포함 완제품가) [COMP_NAMECARD_PEARL_S2] | 2 | 10,000 ~ 11,000 | COMP_NAMECARD_PEARL_S2 |
| 포스터 완제품가(포함항목 통가격) [COMP_POSTER_ARTPAPER_MATTE] | 2 | 21,600 ~ 21,600 | COMP_POSTER_ARTPAPER_MATTE |
| 포스터 완제품가(포함항목 통가격) [COMP_POSTER_FRAMELESS_WOOD] | 2 | 16,000 ~ 23,000 | COMP_POSTER_FRAMELESS_WOOD |
| 포스터 완제품가(포함항목 통가격) [COMP_POSTER_LEATHER_FRAME] | 2 | 16,000 ~ 21,000 | COMP_POSTER_LEATHER_FRAME |
| 포스터 완제품가(포함항목 통가격) [COMP_POSTER_BANNER_MESH] | 2 | 20,000 ~ 21,600 | COMP_POSTER_BANNER_MESH |
| 포스터 완제품가(포함항목 통가격) [COMP_POSTER_FOAMBOARD_WHITE] | 2 | 7,000 ~ 12,000 | COMP_POSTER_FOAMBOARD_WHITE |
| 포스터 완제품가(포함항목 통가격) [COMP_POSTER_FOAMBOARD_BLACK] | 2 | 8,500 ~ 14,000 | COMP_POSTER_FOAMBOARD_BLACK |
| 포스터 완제품가(포함항목 통가격) [COMP_POSTER_FOMEXBOARD_WHITE3MM] | 2 | 8,500 ~ 13,000 | COMP_POSTER_FOMEXBOARD_WHITE3MM |
| 포스터 완제품가(포함항목 통가격) [COMP_POSTER_FOMEXBOARD_WHITE5MM] | 2 | 10,000 ~ 16,000 | COMP_POSTER_FOMEXBOARD_WHITE5MM |
| 명함 단가(용지포함 완제품가) [COMP_NAMECARD_PREMIUM_S1_MGA] | 1 | 4,500 ~ 4,500 | COMP_NAMECARD_PREMIUM_S1_MGA |
| 명함 단가(용지포함 완제품가) [COMP_NAMECARD_PREMIUM_S1_MGB] | 1 | 5,000 ~ 5,000 | COMP_NAMECARD_PREMIUM_S1_MGB |
| 명함 단가(용지포함 완제품가) [COMP_NAMECARD_PREMIUM_S2_MGA] | 1 | 5,500 ~ 5,500 | COMP_NAMECARD_PREMIUM_S2_MGA |
| 명함 단가(용지포함 완제품가) [COMP_NAMECARD_PREMIUM_S2_MGB] | 1 | 6,500 ~ 6,500 | COMP_NAMECARD_PREMIUM_S2_MGB |
| 명함 단가(용지포함 완제품가) [COMP_NAMECARD_CLEAR_S1] | 1 | 13,500 ~ 13,500 | COMP_NAMECARD_CLEAR_S1 |
| 명함 단가(용지포함 완제품가) [COMP_NAMECARD_WHITE_S1W_NOCL] | 1 | 14,500 ~ 14,500 | COMP_NAMECARD_WHITE_S1W_NOCL |
| 명함 단가(용지포함 완제품가) [COMP_NAMECARD_WHITE_S1W_CL] | 1 | 16,000 ~ 16,000 | COMP_NAMECARD_WHITE_S1W_CL |
| 명함 단가(용지포함 완제품가) [COMP_NAMECARD_WHITE_S2W_NOCL] | 1 | 16,000 ~ 16,000 | COMP_NAMECARD_WHITE_S2W_NOCL |
| 명함 단가(용지포함 완제품가) [COMP_NAMECARD_WHITE_S2W_CL] | 1 | 19,000 ~ 19,000 | COMP_NAMECARD_WHITE_S2W_CL |
| 명함 단가(용지포함 완제품가) [COMP_NAMECARD_SHAPE_S1] | 1 | 18,000 ~ 18,000 | COMP_NAMECARD_SHAPE_S1 |
| 명함 단가(용지포함 완제품가) [COMP_NAMECARD_SHAPE_S2] | 1 | 19,000 ~ 19,000 | COMP_NAMECARD_SHAPE_S2 |
| 명함 단가(용지포함 완제품가) [COMP_NAMECARD_MINISHAPE_S1] | 1 | 16,000 ~ 16,000 | COMP_NAMECARD_MINISHAPE_S1 |
| 명함 단가(용지포함 완제품가) [COMP_NAMECARD_MINISHAPE_S2] | 1 | 17,000 ~ 17,000 | COMP_NAMECARD_MINISHAPE_S2 |
| 박형압 동판셋업비 [COMP_NAMECARD_FOIL_SETUP_S1_STD] | 1 | 5,000 ~ 5,000 | COMP_NAMECARD_FOIL_SETUP_S1_STD |
| 박형압 동판셋업비 [COMP_NAMECARD_FOIL_SETUP_S2_STD] | 1 | 5,000 ~ 5,000 | COMP_NAMECARD_FOIL_SETUP_S2_STD |
| 포토카드 단가(완제품가) [COMP_PHOTOCARD_SET] | 1 | 6,000 ~ 6,000 | COMP_PHOTOCARD_SET |
| 포토카드 단가(완제품가) [COMP_PHOTOCARD_CLEAR_SET] | 1 | 8,500 ~ 8,500 | COMP_PHOTOCARD_CLEAR_SET |
| 포스터 완제품가(포함항목 통가격) [COMP_POSTER_ARTPRINT_PHOTO] | 1 | 21,600 ~ 21,600 | COMP_POSTER_ARTPRINT_PHOTO |
| 포스터 완제품가(포함항목 통가격) [COMP_POSTER_WATERPROOF_PET] | 1 | 21,600 ~ 21,600 | COMP_POSTER_WATERPROOF_PET |
| 포스터 완제품가(포함항목 통가격) [COMP_POSTER_ADH_WATERPROOF_PVC] | 1 | 21,600 ~ 21,600 | COMP_POSTER_ADH_WATERPROOF_PVC |
| 포스터 완제품가(포함항목 통가격) [COMP_POSTER_ADH_CLEAR_PVC] | 1 | 59,400 ~ 59,400 | COMP_POSTER_ADH_CLEAR_PVC |
| 포스터 완제품가(포함항목 통가격) [COMP_POSTER_ARTFABRIC_GRAPHIC] | 1 | 21,600 ~ 21,600 | COMP_POSTER_ARTFABRIC_GRAPHIC |
| 포스터 완제품가(포함항목 통가격) [COMP_POSTER_LINEN_FABRIC] | 1 | 32,400 ~ 32,400 | COMP_POSTER_LINEN_FABRIC |
| 포스터 완제품가(포함항목 통가격) [COMP_POSTER_CANVAS_FABRIC] | 1 | 37,800 ~ 37,800 | COMP_POSTER_CANVAS_FABRIC |
| 포스터 완제품가(포함항목 통가격) [COMP_POSTER_LEATHER_ARTPRINT] | 1 | 37,800 ~ 37,800 | COMP_POSTER_LEATHER_ARTPRINT |
| 포스터 완제품가(포함항목 통가격) [COMP_POSTER_TYVEK_PRINT] | 1 | 37,800 ~ 37,800 | COMP_POSTER_TYVEK_PRINT |
| 포스터 완제품가(포함항목 통가격) [COMP_POSTER_MESH_PRINT] | 1 | 37,800 ~ 37,800 | COMP_POSTER_MESH_PRINT |
| 포스터 추가옵션 추가가격(별도 add-on 통가격) [COMP_POSTEROPT_JOKJA_CEILHOOK] | 1 | 6,500 ~ 6,500 | COMP_POSTEROPT_JOKJA_CEILHOOK |
| 포스터 완제품가(포함항목 통가격) [COMP_POSTER_PET_BANNER] | 1 | 22,000 ~ 22,000 | COMP_POSTER_PET_BANNER |
| 포스터 추가옵션 추가가격(별도 add-on 통가격) [COMP_POSTEROPT_PET_BANNER_STAND_IN] | 1 | 7,000 ~ 7,000 | COMP_POSTEROPT_PET_BANNER_STAND_IN |
| 포스터 추가옵션 추가가격(별도 add-on 통가격) [COMP_POSTEROPT_PET_BANNER_STAND_OUT_S1] | 1 | 23,000 ~ 23,000 | COMP_POSTEROPT_PET_BANNER_STAND_OUT_S1 |
| 포스터 추가옵션 추가가격(별도 add-on 통가격) [COMP_POSTEROPT_PET_BANNER_STAND_OUT_S2] | 1 | 25,000 ~ 25,000 | COMP_POSTEROPT_PET_BANNER_STAND_OUT_S2 |
| 포스터 완제품가(포함항목 통가격) [COMP_POSTER_MESH_BANNER] | 1 | 38,000 ~ 38,000 | COMP_POSTER_MESH_BANNER |
| 포스터 추가옵션 추가가격(별도 add-on 통가격) [COMP_POSTEROPT_BANNER_NORMAL_PROC_CUTEDGE] | 1 | 3,000 ~ 3,000 | COMP_POSTEROPT_BANNER_NORMAL_PROC_CUTEDGE |
| 포스터 추가옵션 추가가격(별도 add-on 통가격) [COMP_POSTEROPT_BANNER_NORMAL_PROC_PUNCH_4] | 1 | 3,000 ~ 3,000 | COMP_POSTEROPT_BANNER_NORMAL_PROC_PUNCH_4 |
| 포스터 추가옵션 추가가격(별도 add-on 통가격) [COMP_POSTEROPT_BANNER_NORMAL_ADD_QBANG_4] | 1 | 3,000 ~ 3,000 | COMP_POSTEROPT_BANNER_NORMAL_ADD_QBANG_4 |
| 포스터 추가옵션 추가가격(별도 add-on 통가격) [COMP_POSTEROPT_BANNER_NORMAL_PROC_PUNCH_6] | 1 | 4,000 ~ 4,000 | COMP_POSTEROPT_BANNER_NORMAL_PROC_PUNCH_6 |
| 포스터 추가옵션 추가가격(별도 add-on 통가격) [COMP_POSTEROPT_BANNER_NORMAL_ADD_STRING_4] | 1 | 4,000 ~ 4,000 | COMP_POSTEROPT_BANNER_NORMAL_ADD_STRING_4 |
| 포스터 추가옵션 추가가격(별도 add-on 통가격) [COMP_POSTEROPT_BANNER_NORMAL_PROC_PUNCH_8] | 1 | 5,000 ~ 5,000 | COMP_POSTEROPT_BANNER_NORMAL_PROC_PUNCH_8 |
| 포스터 추가옵션 추가가격(별도 add-on 통가격) [COMP_POPT_BNR_GAKMOK_STR_900_4_LE] | 1 | 4,000 ~ 4,000 | COMP_POPT_BNR_GAKMOK_STR_900_4_LE |
| 포스터 추가옵션 추가가격(별도 add-on 통가격) [COMP_POSTEROPT_BANNER_NORMAL_PROC_DTAPE] | 1 | 3,000 ~ 3,000 | COMP_POSTEROPT_BANNER_NORMAL_PROC_DTAPE |
| 포스터 추가옵션 추가가격(별도 add-on 통가격) [COMP_POPT_BNR_GAKMOK_STR_900_4_GT] | 1 | 8,000 ~ 8,000 | COMP_POPT_BNR_GAKMOK_STR_900_4_GT |
| 포스터 추가옵션 추가가격(별도 add-on 통가격) [COMP_POSTEROPT_BANNER_NORMAL_PROC_BONGSEW] | 1 | 4,000 ~ 4,000 | COMP_POSTEROPT_BANNER_NORMAL_PROC_BONGSEW |
| 포스터 추가옵션 추가가격(별도 add-on 통가격) [COMP_POSTEROPT_BANNER_MESH_PROC_PUNCH_4] | 1 | 3,000 ~ 3,000 | COMP_POSTEROPT_BANNER_MESH_PROC_PUNCH_4 |
| 포스터 추가옵션 추가가격(별도 add-on 통가격) [COMP_POSTEROPT_BANNER_MESH_ADD_QBANG_4] | 1 | 3,000 ~ 3,000 | COMP_POSTEROPT_BANNER_MESH_ADD_QBANG_4 |
| 포스터 추가옵션 추가가격(별도 add-on 통가격) [COMP_POSTEROPT_BANNER_MESH_PROC_PUNCH_6] | 1 | 4,000 ~ 4,000 | COMP_POSTEROPT_BANNER_MESH_PROC_PUNCH_6 |
| 포스터 추가옵션 추가가격(별도 add-on 통가격) [COMP_POSTEROPT_BANNER_MESH_ADD_STRING_4] | 1 | 4,000 ~ 4,000 | COMP_POSTEROPT_BANNER_MESH_ADD_STRING_4 |
| 포스터 추가옵션 추가가격(별도 add-on 통가격) [COMP_POSTEROPT_BANNER_MESH_PROC_PUNCH_8] | 1 | 5,000 ~ 5,000 | COMP_POSTEROPT_BANNER_MESH_PROC_PUNCH_8 |

> 단가값은 round-2 검증(GO)·S-gate(도메인 정합) 완료분. 음수 0·0원=직각모서리/1구타공 기본옵션 무료.