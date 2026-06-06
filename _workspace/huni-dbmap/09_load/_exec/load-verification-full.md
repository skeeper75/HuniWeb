# 상품별 9속성 완전성 검증 — round-5 적재 전 확인 (load-verification-full)

> **목적:** round-5 가 ADD 하는 델타만 보여주는 `load-preview.md` 와 달리, **라이브 실존 + round-5 델타를 9속성 전반에 MERGE** 하여 상품별 완전·정확 정의를 적재 전 한눈에 확인한다. 예: 프리미엄엽서(PRD_000016)의 카테고리·사이즈·도수·판형·추가상품은 **이미 라이브에 존재**하며 "누락"이 아니다 — 본 문서가 그것을 명시한다.

> **read-only:** 본 문서는 검증용이며 적재가 아니다. 생성기 `gen_verification_full.py` 는 라이브 read-only SELECT 만 수행한다(INSERT/UPDATE/COMMIT/DDL 0). 비밀값은 `.env.local` 에서만(노출 0).

> **권위:** `docs/goal-2026-06-06-02.md`(round-5) · `-01.md`(round-4) · `09_load/_assembled/blocked-and-gaps.md`. round-4 매핑이 권위이며 재매핑·발명 없음.

> **재현:** `python3 09_load/_exec/gen_verification_full.py` — 같은 라이브 상태 + 같은 델타 → 같은 문서.


## 출처 태그 (행별)

| 태그 | 의미 |
|------|------|
| [라이브] | 라이브에 현재 실존(기존 정의) |
| [+R5] | round-5 델타에 있으나 라이브 미존재 — **적재 대기** |
| [라이브=R5✓] | 라이브·델타 양쪽 — **이미 적재됨/일치**(멱등 재적재 시 변화 0) |
| [차단] | round-5 차단 — 후니 등록/모델 확정 대기(즉시적재 대상 아님) |
| [GAP] | 무손실 표현 불가 — 에스컬레이션(모델링 결정 필요) |

매트릭스 셀 표기: `라이브+적재됨 합계 (+R5 신규 / ✓겹침 / 차단 / GAP)`. **0/0** = 라이브·델타 모두 비어있음(주목 대상일 수 있음).

## 완전성 매트릭스 (한눈 표 — 상품 × 9속성)

| 상품(prd_cd) | 상품명 | 카테고리 | 사이즈 | 도수 | 판형 | 자재 | 공정 | 묶음 | 페이지룰 | 추가상품 |
|---|---|---|---|---|---|---|---|---|---|---|
| PRD_000016 | 프리미엄엽서 | 1 | 7 | 2 | 1 | 2 (+R5 19 / ✓2) | 6 | **0/0** | **0/0** | 4 (차단 1) |
| PRD_000018 | 스탠다드엽서 | 1 | 5 | 2 | 5 | 0 (+R5 7) | 2 (+R5 4) | **0/0** | **0/0** | 3 (차단 1) |
| PRD_000027 | 2단접지카드 | 1 | 5 | 1 | 6 | 0 (+R5 14) | 8 (+R5 2) | **0/0** | **0/0** | **0/0** |
| PRD_000028 | 미니접지카드 | 1 | 4 | 1 | 2 | 0 (+R5 14) | **0/0** | **0/0** | **0/0** | **0/0** |
| PRD_000029 | 3단접지카드 | 1 | 3 | 1 | 4 | 0 (+R5 14) | 8 (+R5 2) | **0/0** | **0/0** | **0/0** |
| PRD_000031 | 프리미엄명함 | 1 | 3 | 2 | 3 | 0 (+R5 16) | 10 (+R5 2) | **0/0** | **0/0** | **0/0** |
| PRD_000033 | 스탠다드명함 | 1 | 2 | 2 | 2 | 5 | 2 (+R5 2) | **0/0** | **0/0** | **0/0** |
| PRD_000041 | 스탠다드 쿠폰/상품권 | 1 | 2 | 2 | 2 | 4 | 0 (+R5 4) | **0/0** | **0/0** | **0/0** |
| PRD_000042 | 프리미엄 쿠폰/상품권 | 1 | 2 | 2 | 2 | 8 | 8 (+R5 4) | **0/0** | **0/0** | **0/0** |
| PRD_000047 | 소량전단지 | 1 | 4 | 2 | 4 | 0 (+R5 47) | 2 (+R5 2) | **0/0** | **0/0** | **0/0** |
| PRD_000048 | 접지리플렛 | 1 | **0/0** | 1 | 6 | 0 (+R5 47) | 2 (+R5 2) | **0/0** | **0/0** | **0/0** |
| PRD_000049 | 와이드 접지리플렛 | 1 | **0/0** | 1 | 3 | 5 | 4 (+R5 2) | **0/0** | **0/0** | **0/0** |
| PRD_000053 | 반칼 자유형 투명스티커 | 1 | 3 | 1 | 3 | 1 | 1 (+R5 1) | **0/0** | **0/0** | **0/0** |
| PRD_000054 | 반칼 자유형 홀로그램스티커 | 1 | 3 | 1 | 3 | 1 | 1 (+R5 1) | **0/0** | **0/0** | **0/0** |
| PRD_000056 | 낱장 자유형 투명스티커 | 1 | 3 | 1 | 3 | 1 | 1 (+R5 1) | **0/0** | **0/0** | **0/0** |
| PRD_000068 | 중철책자 | 1 | 2 | 2 | 4 | 0 (+R5 26) | 3 | **0/0** | 1 | **0/0** |
| PRD_000069 | 무선책자 | 1 | 2 | 2 | 2 | 0 (+R5 13) | 12 (+R5 2) | **0/0** | 1 | **0/0** |
| PRD_000070 | PUR책자 | 1 | 2 | 2 | 2 | **0/0** | 12 (+R5 2) | **0/0** | 1 | **0/0** |
| PRD_000071 | 트윈링책자 | 1 | 4 | 2 | 5 | 5 (+R5 44) | 4 | **0/0** | 1 | **0/0** |
| PRD_000108 | 탁상형캘린더 | 1 | 2 | 1 | 2 | 3 (+R5 7) | 1 | **0/0** | **0/0** | 1 |
| PRD_000109 | 미니탁상형캘린더 | 1 | 2 | 1 | 2 | 3 (+R5 6) | 1 | **0/0** | **0/0** | **0/0** |
| PRD_000110 | 엽서캘린더 | 1 | 6 | 1 | 6 | 1 (+R5 9) | 1 | **0/0** | **0/0** | 1 |
| PRD_000111 | 벽걸이캘린더 | 1 | 3 | 2 | 3 | 2 (+R5 21) | 2 | **0/0** | **0/0** | **0/0** |
| PRD_000122 | 접착투명포스터 | 1 | 3 | **0/0** | 3 | 1 | 0 (+R5 1) | **0/0** | **0/0** | **0/0** |
| PRD_000146 | 아크릴키링 | 1 | 8 | 3 (차단 1) | 8 | 1 (+R5 2) | 0 (+R5 1 / 차단 1) | **0/0** | **0/0** | 1 |
| PRD_000147 | 아크릴마그넷 | 1 | 7 | 3 (차단 1) | 7 | 1 | 0 (+R5 2 / 차단 1) | **0/0** | **0/0** | **0/0** |
| PRD_000148 | 아크릴뱃지 | 1 | 3 | 3 (차단 1) | 3 | 1 (+R5 2) | 0 (+R5 1 / 차단 1) | **0/0** | **0/0** | **0/0** |
| PRD_000149 | 아크릴집게 | 1 | 3 | 3 (차단 1) | 3 | 1 (+R5 1) | 0 (+R5 1 / 차단 1) | **0/0** | **0/0** | **0/0** |
| PRD_000150 | 아크릴스마트톡 | 1 | 3 | 3 (차단 1) | 3 | 1 (+R5 2) | 0 (+R5 1 / 차단 1) | **0/0** | **0/0** | **0/0** |
| PRD_000151 | 맥세이프 스마트톡 | 1 | 3 | 3 (차단 1) | 3 | 1 | 1 (+R5 1 / 차단 1) | **0/0** | **0/0** | **0/0** |
| PRD_000152 | 아크릴명찰 | 1 | 3 | 3 (차단 1) | 3 | 1 (+R5 2) | 0 (+R5 1 / 차단 1) | **0/0** | **0/0** | **0/0** |
| PRD_000154 | 아크릴 머리끈 | 1 | 3 | **0/0** | 3 | 1 (+R5 1) | 0 (차단 1) | **0/0** | **0/0** | **0/0** |
| PRD_000155 | 아크릴볼펜 | 1 | 3 | 3 (차단 1) | 3 | 1 | 0 (+R5 1 / 차단 1) | **0/0** | **0/0** | **0/0** |
| PRD_000157 | 아크릴네임택 | 1 | 2 | 3 (차단 1) | 2 | 1 | 0 (+R5 1 / 차단 1) | **0/0** | **0/0** | **0/0** |
| PRD_000158 | 아크릴 포카키링 | 1 | 1 | 3 (차단 1) | 1 | 1 | 0 (+R5 1 / 차단 1) | **0/0** | **0/0** | 1 |
| PRD_000160 | 아크릴자유형스탠드 | 1 | 5 | 3 (차단 1) | 5 | 1 | 0 (+R5 1 / 차단 1) | 0 (+R5 5) | **0/0** | **0/0** |
| PRD_000161 | 판아크릴 | 1 | 2 | 3 (차단 1) | 2 | 1 | 0 (+R5 1) | **0/0** | **0/0** | **0/0** |
| PRD_000162 | 아크릴포카스탠드 | 1 | 1 | 3 (차단 1) | **0/0** | 1 | 0 (+R5 1 / 차단 1) | **0/0** | **0/0** | **0/0** |
| PRD_000163 | 아크릴미니파츠 | 1 | 1 | 3 (차단 1) | 1 | 1 | 0 (+R5 1 / 차단 1) | 0 (+R5 1) | **0/0** | **0/0** |
| PRD_000172 | 만년다이어리(소프트커버) | 1 | 1 | 1 | 1 | 1 | 0 (+R5 1) | **0/0** | **0/0** | **0/0** |
| PRD_000173 | 만년다이어리(하드커버) | 1 | 1 | **0/0** | 1 | 1 | 1 (+R5 2) | **0/0** | **0/0** | **0/0** |
| PRD_000174 | 만년다이어리(레더하드커버) | 1 | 1 | **0/0** | **0/0** | 1 | 0 (+R5 1) | **0/0** | **0/0** | **0/0** |
| PRD_000176 | 먼슬리플래너 | 1 | 1 | 2 | 2 | 2 | 0 (+R5 1) | **0/0** | 1 | **0/0** |
| PRD_000177 | 스프링노트 | 1 | 1 | 1 | 1 | 3 | 1 (+R5 2) | **0/0** | **0/0** | **0/0** |
| PRD_000178 | 스프링수첩 | 1 | 1 | 1 | 1 | 3 | 0 (+R5 2) | **0/0** | **0/0** | **0/0** |
| PRD_000179 | 메모패드 | 1 | 2 | 1 | 2 | 3 | 0 (+R5 2) | **0/0** | **0/0** | **0/0** |
| PRD_000181 | 중철노트 | 1 | 1 | 1 | 1 | 3 | 0 (+R5 2) | **0/0** | **0/0** | **0/0** |

> 셀 안 `+R5 N` = round-5 가 새로 적재할 행수. `✓N` = 라이브와 델타가 겹치는(이미 적재) 행수. `차단 N`/`GAP N` = 등록·모델 대기. 숫자만 = 라이브 실존 행수.

## 진짜 공백(0/0) 속성 요약 — 주목 대상

> **코어 속성**(카테고리·사이즈·도수·판형·자재·공정)은 거의 모든 상품이 가져야 한다 — 공백이면 **적재 전 확인 권장**. **선택 속성**(묶음·페이지룰·추가상품)은 상품 성격상 정당히 비어있을 수 있다(예: 비책자의 페이지룰, 단품의 묶음수). 0/0 이 곧 결함은 아니며, round-5 델타가 그 속성을 채우지 않는다는 사실의 표기다.

### 코어 속성 공백 (확인 권장)

> 9개 상품에서 코어 속성 공백 발견(전수 47 중). 라이브 SELECT 기준.

| 상품 | 상품명 | 코어 공백(0/0) |
|------|------|--------------|
| PRD_000028 | 미니접지카드 | 공정 |
| PRD_000048 | 접지리플렛 | 사이즈 |
| PRD_000049 | 와이드 접지리플렛 | 사이즈 |
| PRD_000070 | PUR책자 | 자재 |
| PRD_000122 | 접착투명포스터 | 도수 |
| PRD_000154 | 아크릴 머리끈 | 도수 |
| PRD_000162 | 아크릴포카스탠드 | 판형 |
| PRD_000173 | 만년다이어리(하드커버) | 도수 |
| PRD_000174 | 만년다이어리(레더하드커버) | 도수, 판형 |

### 선택 속성 공백 분포 (대부분 정상)

- 묶음: 45/47 상품이 0/0 (대부분 상품 성격상 정당한 공백)
- 페이지룰: 42/47 상품이 0/0 (대부분 상품 성격상 정당한 공백)
- 추가상품: 41/47 상품이 0/0 (대부분 상품 성격상 정당한 공백)

## 상품별 9속성 상세 (라이브 + round-5 델타 MERGE)

### PRD_000016 — 프리미엄엽서

**요약:** 카테고리 1 · 사이즈 7 · 도수 2 · 판형 1 · 자재 2 (+R5 19 / ✓2) · 공정 6 · 묶음 **0/0** · 페이지룰 **0/0** · 추가상품 4 (차단 1)

#### 1. 카테고리 (t_prd_product_categories)
- [라이브] CAT_000001 (엽서) main=Y seq=1
#### 2. 사이즈 (t_prd_product_sizes)
- [라이브] SIZ_000001 (73x98) dflt=Y
- [라이브] SIZ_000002 (98x98) dflt=Y
- [라이브] SIZ_000003 (100x150) dflt=Y
- [라이브] SIZ_000004 (135x135) dflt=Y
- [라이브] SIZ_000005 (95x210) dflt=Y
- [라이브] SIZ_000006 (110x170) dflt=Y
- [라이브] SIZ_000007 (148x210) dflt=Y
#### 3. 도수/인쇄옵션 (t_prd_product_print_options)
- [라이브] opt=1 side=단면 앞=CLR_000005(CMYK 4도) 뒤=CLR_000001(인쇄 안 함) dflt=Y
- [라이브] opt=2 side=양면 앞=CLR_000005(CMYK 4도) 뒤=CLR_000005(CMYK 4도) dflt=Y
#### 4. 판형 (t_prd_product_plate_sizes)
- [라이브] SIZ_000499 (316x467) dflt_plt=N 출력지=OUTPUT_PAPER_TYPE.01(국전계열) 파일=-
#### 5. 자재 (t_prd_product_materials) — round-5 델타 MERGE
- [라이브=R5✓] MAT_000074 (백색모조지 220g) / usage=USAGE.07(공통) dflt=Y (라이브 reg_dt=2026-06-06 16:19:24.24146)
- [라이브=R5✓] MAT_000082 (아트지 300g) / usage=USAGE.07(공통) dflt=Y (라이브 reg_dt=2026-06-06 16:19:46.610959)
- [+R5] MAT_000092 (스노우지 300g) / usage=USAGE.07(공통) dflt=N seq=3 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000101 (랑데뷰 WH 240g) / usage=USAGE.07(공통) dflt=N seq=4 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000109 (몽블랑 240g) / usage=USAGE.07(공통) dflt=N seq=5 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000113 (아코팩(웜화이트) 250g) / usage=USAGE.07(공통) dflt=N seq=6 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000114 (리사이클러스 240g) / usage=USAGE.07(공통) dflt=N seq=7 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000115 (매쉬멜로우 233g) / usage=USAGE.07(공통) dflt=N seq=8 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000116 (린넨커버 216g) / usage=USAGE.07(공통) dflt=N seq=9 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000117 (스타화이트(하이테크) 238g) / usage=USAGE.07(공통) dflt=N seq=10 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000118 (클래식 크래스트 스티플 270g) / usage=USAGE.07(공통) dflt=N seq=11 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000120 (매직터치(백색) 250g) / usage=USAGE.07(공통) dflt=N seq=12 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000121 (켄도 250g) / usage=USAGE.07(공통) dflt=N seq=13 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000123 (띤또레또 200g) / usage=USAGE.07(공통) dflt=N seq=14 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000124 (띤또레또 250g) / usage=USAGE.07(공통) dflt=N seq=15 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000125 (한지 170g) / usage=USAGE.07(공통) dflt=N seq=16 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000126 (스코트랜드 220g) / usage=USAGE.07(공통) dflt=N seq=17 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000127 (스타드림(다이아몬드) 240g) / usage=USAGE.07(공통) dflt=N seq=18 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000128 (스타드림(실버) 240g) / usage=USAGE.07(공통) dflt=N seq=19 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000129 (스타드림(골드) 240g) / usage=USAGE.07(공통) dflt=N seq=20 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000130 (스타드림(로즈쿼츠) 240g) / usage=USAGE.07(공통) dflt=N seq=21 — 상품-자재 링크 라이브 미존재(적재 대기)
#### 6. 공정 (t_prd_product_processes) — round-5 델타 MERGE
- [라이브] PROC_000027 (직각) mand=N seq=1
- [라이브] PROC_000028 (둥근) mand=N seq=1
- [라이브] PROC_000029 (오시) mand=N seq=2
- [라이브] PROC_000030 (미싱) mand=N seq=3
- [라이브] PROC_000031 (가변텍스트) mand=N seq=4
- [라이브] PROC_000032 (가변이미지) mand=N seq=5
#### 7. 묶음수 (t_prd_product_bundle_qtys) — round-5 델타 MERGE
- (없음 — 라이브·델타·차단 모두 0)
#### 8. 페이지룰 (t_prd_product_page_rules)
- (없음 — 라이브·델타·차단 모두 0)
#### 9. 추가상품 (t_prd_product_addons)
- [라이브] TMPL-PRD_000002 → PRD_000002 (OPP비접착봉투) seq=1
- [라이브] TMPL-PRD_000001 → PRD_000001 (OPP접착봉투) seq=2
- [라이브] TMPL-PRD_000281 → PRD_000281 (카드봉투(화이트)) seq=3
- [라이브] TMPL-PRD_000282 → PRD_000282 (카드봉투(블랙)) seq=4
- [차단] TMPL-PRD_000003 → 트레싱지봉투(PRD_000003) — template 라이브 부재(후니 등록 대기, blocked §2)

### PRD_000018 — 스탠다드엽서

**요약:** 카테고리 1 · 사이즈 5 · 도수 2 · 판형 5 · 자재 0 (+R5 7) · 공정 2 (+R5 4) · 묶음 **0/0** · 페이지룰 **0/0** · 추가상품 3 (차단 1)

#### 1. 카테고리 (t_prd_product_categories)
- [라이브] CAT_000001 (엽서) main=Y seq=1
#### 2. 사이즈 (t_prd_product_sizes)
- [라이브] SIZ_000001 (73x98) dflt=Y
- [라이브] SIZ_000002 (98x98) dflt=Y
- [라이브] SIZ_000003 (100x150) dflt=Y
- [라이브] SIZ_000004 (135x135) dflt=Y
- [라이브] SIZ_000007 (148x210) dflt=Y
#### 3. 도수/인쇄옵션 (t_prd_product_print_options)
- [라이브] opt=1 side=단면 앞=CLR_000005(CMYK 4도) 뒤=CLR_000001(인쇄 안 함) dflt=Y
- [라이브] opt=2 side=양면 앞=CLR_000005(CMYK 4도) 뒤=CLR_000005(CMYK 4도) dflt=Y
#### 4. 판형 (t_prd_product_plate_sizes)
- [라이브] SIZ_000112 (75x100) dflt_plt=Y 출력지=OUTPUT_PAPER_TYPE.03(기타) 파일=PDF
- [라이브] SIZ_000113 (100x100) dflt_plt=Y 출력지=- 파일=-
- [라이브] SIZ_000114 (102x152) dflt_plt=Y 출력지=- 파일=-
- [라이브] SIZ_000115 (137x137) dflt_plt=Y 출력지=- 파일=-
- [라이브] SIZ_000118 (150x212) dflt_plt=Y 출력지=- 파일=-
#### 5. 자재 (t_prd_product_materials) — round-5 델타 MERGE
- [+R5] MAT_000074 (백색모조지 220g) / usage=USAGE.07(공통) dflt=Y seq=1 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000080 (아트지 200g) / usage=USAGE.07(공통) dflt=N seq=2 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000081 (아트지 250g) / usage=USAGE.07(공통) dflt=N seq=3 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000082 (아트지 300g) / usage=USAGE.07(공통) dflt=N seq=4 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000090 (스노우지 200g) / usage=USAGE.07(공통) dflt=N seq=5 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000091 (스노우지 250g) / usage=USAGE.07(공통) dflt=N seq=6 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000092 (스노우지 300g) / usage=USAGE.07(공통) dflt=N seq=7 — 상품-자재 링크 라이브 미존재(적재 대기)
#### 6. 공정 (t_prd_product_processes) — round-5 델타 MERGE
- [+R5] PROC_000029 (오시) mand=N seq=10 — 상품-공정 링크 라이브 미존재(적재 대기)
- [+R5] PROC_000030 (미싱) mand=N seq=11 — 상품-공정 링크 라이브 미존재(적재 대기)
- [+R5] PROC_000031 (가변텍스트) mand=N seq=12 — 상품-공정 링크 라이브 미존재(적재 대기)
- [+R5] PROC_000032 (가변이미지) mand=N seq=13 — 상품-공정 링크 라이브 미존재(적재 대기)
- [라이브] PROC_000027 (직각) mand=N seq=1
- [라이브] PROC_000028 (둥근) mand=N seq=1
#### 7. 묶음수 (t_prd_product_bundle_qtys) — round-5 델타 MERGE
- (없음 — 라이브·델타·차단 모두 0)
#### 8. 페이지룰 (t_prd_product_page_rules)
- (없음 — 라이브·델타·차단 모두 0)
#### 9. 추가상품 (t_prd_product_addons)
- [라이브] TMPL-PRD_000004 → PRD_000004 (카드봉투) seq=1
- [라이브] TMPL-PRD_000002 → PRD_000002 (OPP비접착봉투) seq=1
- [라이브] TMPL-PRD_000001 → PRD_000001 (OPP접착봉투) seq=1
- [차단] TMPL-PRD_000003 → 트레싱지봉투(PRD_000003) — template 라이브 부재(후니 등록 대기, blocked §2)

### PRD_000027 — 2단접지카드

**요약:** 카테고리 1 · 사이즈 5 · 도수 1 · 판형 6 · 자재 0 (+R5 14) · 공정 8 (+R5 2) · 묶음 **0/0** · 페이지룰 **0/0** · 추가상품 **0/0**

#### 1. 카테고리 (t_prd_product_categories)
- [라이브] CAT_000021 (접지카드) main=Y seq=1
#### 2. 사이즈 (t_prd_product_sizes)
- [라이브] SIZ_000003 (100x150) dflt=Y
- [라이브] SIZ_000004 (135x135) dflt=Y
- [라이브] SIZ_000006 (110x170) dflt=Y
- [라이브] SIZ_000124 (150x100) dflt=Y
- [라이브] SIZ_000129 (170x110) dflt=Y
#### 3. 도수/인쇄옵션 (t_prd_product_print_options)
- [라이브] opt=1 side=양면 앞=CLR_000005(CMYK 4도) 뒤=CLR_000005(CMYK 4도) dflt=Y
#### 4. 판형 (t_prd_product_plate_sizes)
- [라이브] SIZ_000023 (274x139) dflt_plt=Y 출력지=- 파일=-
- [라이브] SIZ_000024 (139x274) dflt_plt=Y 출력지=- 파일=-
- [라이브] SIZ_000123 (202x152) dflt_plt=Y 출력지=OUTPUT_PAPER_TYPE.03(기타) 파일=PDF
- [라이브] SIZ_000125 (152x202) dflt_plt=Y 출력지=- 파일=-
- [라이브] SIZ_000128 (224x174) dflt_plt=Y 출력지=- 파일=-
- [라이브] SIZ_000130 (174x224) dflt_plt=Y 출력지=- 파일=-
#### 5. 자재 (t_prd_product_materials) — round-5 델타 MERGE
- [+R5] MAT_000074 (백색모조지 220g) / usage=USAGE.07(공통) dflt=Y seq=1 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000081 (아트지 250g) / usage=USAGE.07(공통) dflt=N seq=2 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000082 (아트지 300g) / usage=USAGE.07(공통) dflt=N seq=3 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000091 (스노우지 250g) / usage=USAGE.07(공통) dflt=N seq=4 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000092 (스노우지 300g) / usage=USAGE.07(공통) dflt=N seq=5 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000101 (랑데뷰 WH 240g) / usage=USAGE.07(공통) dflt=N seq=6 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000108 (몽블랑 210g) / usage=USAGE.07(공통) dflt=N seq=7 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000109 (몽블랑 240g) / usage=USAGE.07(공통) dflt=N seq=8 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000113 (아코팩(웜화이트) 250g) / usage=USAGE.07(공통) dflt=N seq=9 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000114 (리사이클러스 240g) / usage=USAGE.07(공통) dflt=N seq=10 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000115 (매쉬멜로우 233g) / usage=USAGE.07(공통) dflt=N seq=11 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000116 (린넨커버 216g) / usage=USAGE.07(공통) dflt=N seq=12 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000123 (띤또레또 200g) / usage=USAGE.07(공통) dflt=N seq=13 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000125 (한지 170g) / usage=USAGE.07(공통) dflt=N seq=14 — 상품-자재 링크 라이브 미존재(적재 대기)
#### 6. 공정 (t_prd_product_processes) — round-5 델타 MERGE
- [+R5] PROC_000031 (가변텍스트) mand=N seq=10 — 상품-공정 링크 라이브 미존재(적재 대기)
- [+R5] PROC_000032 (가변이미지) mand=N seq=11 — 상품-공정 링크 라이브 미존재(적재 대기)
- [라이브] PROC_000037 (홀로그램) mand=N seq=1
- [라이브] PROC_000038 (금유광) mand=N seq=1
- [라이브] PROC_000039 (은유광) mand=N seq=1
- [라이브] PROC_000040 (먹유광) mand=N seq=1
- [라이브] PROC_000041 (동박) mand=N seq=1
- [라이브] PROC_000042 (적박) mand=N seq=1
- [라이브] PROC_000043 (청박) mand=N seq=1
- [라이브] PROC_000044 (트윙클) mand=N seq=1
#### 7. 묶음수 (t_prd_product_bundle_qtys) — round-5 델타 MERGE
- (없음 — 라이브·델타·차단 모두 0)
#### 8. 페이지룰 (t_prd_product_page_rules)
- (없음 — 라이브·델타·차단 모두 0)
#### 9. 추가상품 (t_prd_product_addons)
- (없음 — 라이브·델타·차단 모두 0)

### PRD_000028 — 미니접지카드

**요약:** 카테고리 1 · 사이즈 4 · 도수 1 · 판형 2 · 자재 0 (+R5 14) · 공정 **0/0** · 묶음 **0/0** · 페이지룰 **0/0** · 추가상품 **0/0**

#### 1. 카테고리 (t_prd_product_categories)
- [라이브] CAT_000021 (접지카드) main=Y seq=1
#### 2. 사이즈 (t_prd_product_sizes)
- [라이브] SIZ_000008 (90x50) dflt=Y
- [라이브] SIZ_000132 (50x90) dflt=Y
- [라이브] SIZ_000133 (86x52) dflt=Y
- [라이브] SIZ_000135 (52x86) dflt=Y
#### 3. 도수/인쇄옵션 (t_prd_product_print_options)
- [라이브] opt=1 side=양면 앞=CLR_000005(CMYK 4도) 뒤=CLR_000005(CMYK 4도) dflt=Y
#### 4. 판형 (t_prd_product_plate_sizes)
- [라이브] SIZ_000131 (92x104) dflt_plt=Y 출력지=OUTPUT_PAPER_TYPE.03(기타) 파일=PDF
- [라이브] SIZ_000134 (88x106) dflt_plt=Y 출력지=OUTPUT_PAPER_TYPE.03(기타) 파일=-
#### 5. 자재 (t_prd_product_materials) — round-5 델타 MERGE
- [+R5] MAT_000074 (백색모조지 220g) / usage=USAGE.07(공통) dflt=Y seq=1 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000081 (아트지 250g) / usage=USAGE.07(공통) dflt=N seq=2 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000082 (아트지 300g) / usage=USAGE.07(공통) dflt=N seq=3 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000091 (스노우지 250g) / usage=USAGE.07(공통) dflt=N seq=4 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000092 (스노우지 300g) / usage=USAGE.07(공통) dflt=N seq=5 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000101 (랑데뷰 WH 240g) / usage=USAGE.07(공통) dflt=N seq=6 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000108 (몽블랑 210g) / usage=USAGE.07(공통) dflt=N seq=7 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000109 (몽블랑 240g) / usage=USAGE.07(공통) dflt=N seq=8 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000113 (아코팩(웜화이트) 250g) / usage=USAGE.07(공통) dflt=N seq=9 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000114 (리사이클러스 240g) / usage=USAGE.07(공통) dflt=N seq=10 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000115 (매쉬멜로우 233g) / usage=USAGE.07(공통) dflt=N seq=11 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000116 (린넨커버 216g) / usage=USAGE.07(공통) dflt=N seq=12 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000123 (띤또레또 200g) / usage=USAGE.07(공통) dflt=N seq=13 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000125 (한지 170g) / usage=USAGE.07(공통) dflt=N seq=14 — 상품-자재 링크 라이브 미존재(적재 대기)
#### 6. 공정 (t_prd_product_processes) — round-5 델타 MERGE
- (없음 — 라이브·델타·차단 모두 0)
#### 7. 묶음수 (t_prd_product_bundle_qtys) — round-5 델타 MERGE
- (없음 — 라이브·델타·차단 모두 0)
#### 8. 페이지룰 (t_prd_product_page_rules)
- (없음 — 라이브·델타·차단 모두 0)
#### 9. 추가상품 (t_prd_product_addons)
- (없음 — 라이브·델타·차단 모두 0)

### PRD_000029 — 3단접지카드

**요약:** 카테고리 1 · 사이즈 3 · 도수 1 · 판형 4 · 자재 0 (+R5 14) · 공정 8 (+R5 2) · 묶음 **0/0** · 페이지룰 **0/0** · 추가상품 **0/0**

#### 1. 카테고리 (t_prd_product_categories)
- [라이브] CAT_000021 (접지카드) main=Y seq=1
#### 2. 사이즈 (t_prd_product_sizes)
- [라이브] SIZ_000003 (100x150) dflt=Y
- [라이브] SIZ_000004 (135x135) dflt=Y
- [라이브] SIZ_000124 (150x100) dflt=Y
#### 3. 도수/인쇄옵션 (t_prd_product_print_options)
- [라이브] opt=1 side=양면 앞=CLR_000005(CMYK 4도) 뒤=CLR_000005(CMYK 4도) dflt=Y
#### 4. 판형 (t_prd_product_plate_sizes)
- [라이브] SIZ_000136 (300x152) dflt_plt=Y 출력지=OUTPUT_PAPER_TYPE.03(기타) 파일=PDF
- [라이브] SIZ_000138 (152x300) dflt_plt=Y 출력지=OUTPUT_PAPER_TYPE.03(기타) 파일=-
- [라이브] SIZ_000140 (407x139) dflt_plt=Y 출력지=OUTPUT_PAPER_TYPE.03(기타) 파일=-
- [라이브] SIZ_000141 (139x407) dflt_plt=Y 출력지=OUTPUT_PAPER_TYPE.03(기타) 파일=-
#### 5. 자재 (t_prd_product_materials) — round-5 델타 MERGE
- [+R5] MAT_000074 (백색모조지 220g) / usage=USAGE.07(공통) dflt=Y seq=1 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000081 (아트지 250g) / usage=USAGE.07(공통) dflt=N seq=2 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000082 (아트지 300g) / usage=USAGE.07(공통) dflt=N seq=3 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000091 (스노우지 250g) / usage=USAGE.07(공통) dflt=N seq=4 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000092 (스노우지 300g) / usage=USAGE.07(공통) dflt=N seq=5 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000101 (랑데뷰 WH 240g) / usage=USAGE.07(공통) dflt=N seq=6 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000108 (몽블랑 210g) / usage=USAGE.07(공통) dflt=N seq=7 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000109 (몽블랑 240g) / usage=USAGE.07(공통) dflt=N seq=8 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000113 (아코팩(웜화이트) 250g) / usage=USAGE.07(공통) dflt=N seq=9 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000114 (리사이클러스 240g) / usage=USAGE.07(공통) dflt=N seq=10 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000115 (매쉬멜로우 233g) / usage=USAGE.07(공통) dflt=N seq=11 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000116 (린넨커버 216g) / usage=USAGE.07(공통) dflt=N seq=12 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000123 (띤또레또 200g) / usage=USAGE.07(공통) dflt=N seq=13 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000125 (한지 170g) / usage=USAGE.07(공통) dflt=N seq=14 — 상품-자재 링크 라이브 미존재(적재 대기)
#### 6. 공정 (t_prd_product_processes) — round-5 델타 MERGE
- [+R5] PROC_000031 (가변텍스트) mand=N seq=10 — 상품-공정 링크 라이브 미존재(적재 대기)
- [+R5] PROC_000032 (가변이미지) mand=N seq=11 — 상품-공정 링크 라이브 미존재(적재 대기)
- [라이브] PROC_000037 (홀로그램) mand=N seq=1
- [라이브] PROC_000038 (금유광) mand=N seq=1
- [라이브] PROC_000039 (은유광) mand=N seq=1
- [라이브] PROC_000040 (먹유광) mand=N seq=1
- [라이브] PROC_000041 (동박) mand=N seq=1
- [라이브] PROC_000042 (적박) mand=N seq=1
- [라이브] PROC_000043 (청박) mand=N seq=1
- [라이브] PROC_000044 (트윙클) mand=N seq=1
#### 7. 묶음수 (t_prd_product_bundle_qtys) — round-5 델타 MERGE
- (없음 — 라이브·델타·차단 모두 0)
#### 8. 페이지룰 (t_prd_product_page_rules)
- (없음 — 라이브·델타·차단 모두 0)
#### 9. 추가상품 (t_prd_product_addons)
- (없음 — 라이브·델타·차단 모두 0)

### PRD_000031 — 프리미엄명함

**요약:** 카테고리 1 · 사이즈 3 · 도수 2 · 판형 3 · 자재 0 (+R5 16) · 공정 10 (+R5 2) · 묶음 **0/0** · 페이지룰 **0/0** · 추가상품 **0/0**

#### 1. 카테고리 (t_prd_product_categories)
- [라이브] CAT_000294 (명함) main=Y seq=1
#### 2. 사이즈 (t_prd_product_sizes)
- [라이브] SIZ_000008 (90x50) dflt=Y
- [라이브] SIZ_000009 (90x55) dflt=Y
- [라이브] SIZ_000133 (86x52) dflt=Y
#### 3. 도수/인쇄옵션 (t_prd_product_print_options)
- [라이브] opt=1 side=단면 앞=CLR_000005(CMYK 4도) 뒤=CLR_000001(인쇄 안 함) dflt=Y
- [라이브] opt=2 side=양면 앞=CLR_000005(CMYK 4도) 뒤=CLR_000005(CMYK 4도) dflt=Y
#### 4. 판형 (t_prd_product_plate_sizes)
- [라이브] SIZ_000144 (92x52) dflt_plt=Y 출력지=OUTPUT_PAPER_TYPE.03(기타) 파일=PDF
- [라이브] SIZ_000145 (92x57) dflt_plt=Y 출력지=OUTPUT_PAPER_TYPE.03(기타) 파일=-
- [라이브] SIZ_000146 (88x54) dflt_plt=Y 출력지=OUTPUT_PAPER_TYPE.03(기타) 파일=-
#### 5. 자재 (t_prd_product_materials) — round-5 델타 MERGE
- [+R5] MAT_000099 (앙상블 210g) / usage=USAGE.07(공통) dflt=Y seq=1 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000101 (랑데뷰 WH 240g) / usage=USAGE.07(공통) dflt=N seq=2 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000102 (랑데뷰 WH 310g) / usage=USAGE.07(공통) dflt=N seq=3 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000108 (몽블랑 210g) / usage=USAGE.07(공통) dflt=N seq=4 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000109 (몽블랑 240g) / usage=USAGE.07(공통) dflt=N seq=5 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000113 (아코팩(웜화이트) 250g) / usage=USAGE.07(공통) dflt=N seq=6 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000114 (리사이클러스 240g) / usage=USAGE.07(공통) dflt=N seq=7 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000115 (매쉬멜로우 233g) / usage=USAGE.07(공통) dflt=N seq=8 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000116 (린넨커버 216g) / usage=USAGE.07(공통) dflt=N seq=9 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000117 (스타화이트(하이테크) 238g) / usage=USAGE.07(공통) dflt=N seq=10 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000118 (클래식 크래스트 스티플 270g) / usage=USAGE.07(공통) dflt=N seq=11 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000119 (리브스디자인 250g) / usage=USAGE.07(공통) dflt=N seq=12 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000123 (띤또레또 200g) / usage=USAGE.07(공통) dflt=N seq=13 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000124 (띤또레또 250g) / usage=USAGE.07(공통) dflt=N seq=14 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000125 (한지 170g) / usage=USAGE.07(공통) dflt=N seq=15 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000126 (스코트랜드 220g) / usage=USAGE.07(공통) dflt=N seq=16 — 상품-자재 링크 라이브 미존재(적재 대기)
#### 6. 공정 (t_prd_product_processes) — round-5 델타 MERGE
- [+R5] PROC_000031 (가변텍스트) mand=N seq=10 — 상품-공정 링크 라이브 미존재(적재 대기)
- [+R5] PROC_000032 (가변이미지) mand=N seq=11 — 상품-공정 링크 라이브 미존재(적재 대기)
- [라이브] PROC_000027 (직각) mand=N seq=1
- [라이브] PROC_000028 (둥근) mand=N seq=1
- [라이브] PROC_000037 (홀로그램) mand=N seq=1
- [라이브] PROC_000038 (금유광) mand=N seq=1
- [라이브] PROC_000039 (은유광) mand=N seq=1
- [라이브] PROC_000040 (먹유광) mand=N seq=1
- [라이브] PROC_000041 (동박) mand=N seq=1
- [라이브] PROC_000042 (적박) mand=N seq=1
- [라이브] PROC_000043 (청박) mand=N seq=1
- [라이브] PROC_000044 (트윙클) mand=N seq=1
#### 7. 묶음수 (t_prd_product_bundle_qtys) — round-5 델타 MERGE
- (없음 — 라이브·델타·차단 모두 0)
#### 8. 페이지룰 (t_prd_product_page_rules)
- (없음 — 라이브·델타·차단 모두 0)
#### 9. 추가상품 (t_prd_product_addons)
- (없음 — 라이브·델타·차단 모두 0)
#### + 가격공식 (t_prd_product_price_formulas)
- [+R5] PRF_NAMECARD_FIXED — 라이브 미존재(적재 대기). 프리미엄명함→면/소재/수량

### PRD_000033 — 스탠다드명함

**요약:** 카테고리 1 · 사이즈 2 · 도수 2 · 판형 2 · 자재 5 · 공정 2 (+R5 2) · 묶음 **0/0** · 페이지룰 **0/0** · 추가상품 **0/0**

#### 1. 카테고리 (t_prd_product_categories)
- [라이브] CAT_000294 (명함) main=Y seq=1
#### 2. 사이즈 (t_prd_product_sizes)
- [라이브] SIZ_000008 (90x50) dflt=Y
- [라이브] SIZ_000133 (86x52) dflt=Y
#### 3. 도수/인쇄옵션 (t_prd_product_print_options)
- [라이브] opt=1 side=단면 앞=CLR_000005(CMYK 4도) 뒤=CLR_000001(인쇄 안 함) dflt=Y
- [라이브] opt=2 side=양면 앞=CLR_000005(CMYK 4도) 뒤=CLR_000005(CMYK 4도) dflt=Y
#### 4. 판형 (t_prd_product_plate_sizes)
- [라이브] SIZ_000144 (92x52) dflt_plt=Y 출력지=OUTPUT_PAPER_TYPE.03(기타) 파일=PDF
- [라이브] SIZ_000146 (88x54) dflt_plt=Y 출력지=OUTPUT_PAPER_TYPE.03(기타) 파일=-
#### 5. 자재 (t_prd_product_materials) — round-5 델타 MERGE
- [라이브] MAT_000074 (백색모조지 220g) / usage=USAGE.07(공통) dflt=Y (델타 외 라이브 기존)
- [라이브] MAT_000081 (아트지 250g) / usage=USAGE.07(공통) dflt=Y (델타 외 라이브 기존)
- [라이브] MAT_000082 (아트지 300g) / usage=USAGE.07(공통) dflt=Y (델타 외 라이브 기존)
- [라이브] MAT_000091 (스노우지 250g) / usage=USAGE.07(공통) dflt=Y (델타 외 라이브 기존)
- [라이브] MAT_000092 (스노우지 300g) / usage=USAGE.07(공통) dflt=Y (델타 외 라이브 기존)
#### 6. 공정 (t_prd_product_processes) — round-5 델타 MERGE
- [+R5] PROC_000031 (가변텍스트) mand=N seq=10 — 상품-공정 링크 라이브 미존재(적재 대기)
- [+R5] PROC_000032 (가변이미지) mand=N seq=11 — 상품-공정 링크 라이브 미존재(적재 대기)
- [라이브] PROC_000027 (직각) mand=N seq=1
- [라이브] PROC_000028 (둥근) mand=N seq=1
#### 7. 묶음수 (t_prd_product_bundle_qtys) — round-5 델타 MERGE
- (없음 — 라이브·델타·차단 모두 0)
#### 8. 페이지룰 (t_prd_product_page_rules)
- (없음 — 라이브·델타·차단 모두 0)
#### 9. 추가상품 (t_prd_product_addons)
- (없음 — 라이브·델타·차단 모두 0)
#### + 가격공식 (t_prd_product_price_formulas)
- [+R5] PRF_NAMECARD_FIXED — 라이브 미존재(적재 대기). 스탠다드명함→면/소재/수량(용지포함)

### PRD_000041 — 스탠다드 쿠폰/상품권

**요약:** 카테고리 1 · 사이즈 2 · 도수 2 · 판형 2 · 자재 4 · 공정 0 (+R5 4) · 묶음 **0/0** · 페이지룰 **0/0** · 추가상품 **0/0**

#### 1. 카테고리 (t_prd_product_categories)
- [라이브] CAT_000295 (상품권) main=Y seq=1
#### 2. 사이즈 (t_prd_product_sizes)
- [라이브] SIZ_000013 (148x68) dflt=Y
- [라이브] SIZ_000014 (148x75) dflt=Y
#### 3. 도수/인쇄옵션 (t_prd_product_print_options)
- [라이브] opt=1 side=단면 앞=CLR_000005(CMYK 4도) 뒤=CLR_000001(인쇄 안 함) dflt=Y
- [라이브] opt=2 side=양면 앞=CLR_000005(CMYK 4도) 뒤=CLR_000005(CMYK 4도) dflt=Y
#### 4. 판형 (t_prd_product_plate_sizes)
- [라이브] SIZ_000149 (152x72) dflt_plt=Y 출력지=OUTPUT_PAPER_TYPE.03(기타) 파일=PDF
- [라이브] SIZ_000150 (152x79) dflt_plt=Y 출력지=OUTPUT_PAPER_TYPE.03(기타) 파일=-
#### 5. 자재 (t_prd_product_materials) — round-5 델타 MERGE
- [라이브] MAT_000072 (백색모조지 100g) / usage=USAGE.07(공통) dflt=Y (델타 외 라이브 기존)
- [라이브] MAT_000078 (아트지 150g) / usage=USAGE.07(공통) dflt=Y (델타 외 라이브 기존)
- [라이브] MAT_000088 (스노우지 150g) / usage=USAGE.07(공통) dflt=Y (델타 외 라이브 기존)
- [라이브] MAT_000105 (몽블랑 130g) / usage=USAGE.07(공통) dflt=Y (델타 외 라이브 기존)
#### 6. 공정 (t_prd_product_processes) — round-5 델타 MERGE
- [+R5] PROC_000029 (오시) mand=N seq=10 — 상품-공정 링크 라이브 미존재(적재 대기)
- [+R5] PROC_000030 (미싱) mand=N seq=11 — 상품-공정 링크 라이브 미존재(적재 대기)
- [+R5] PROC_000031 (가변텍스트) mand=N seq=12 — 상품-공정 링크 라이브 미존재(적재 대기)
- [+R5] PROC_000032 (가변이미지) mand=N seq=13 — 상품-공정 링크 라이브 미존재(적재 대기)
#### 7. 묶음수 (t_prd_product_bundle_qtys) — round-5 델타 MERGE
- (없음 — 라이브·델타·차단 모두 0)
#### 8. 페이지룰 (t_prd_product_page_rules)
- (없음 — 라이브·델타·차단 모두 0)
#### 9. 추가상품 (t_prd_product_addons)
- (없음 — 라이브·델타·차단 모두 0)

### PRD_000042 — 프리미엄 쿠폰/상품권

**요약:** 카테고리 1 · 사이즈 2 · 도수 2 · 판형 2 · 자재 8 · 공정 8 (+R5 4) · 묶음 **0/0** · 페이지룰 **0/0** · 추가상품 **0/0**

#### 1. 카테고리 (t_prd_product_categories)
- [라이브] CAT_000295 (상품권) main=Y seq=1
#### 2. 사이즈 (t_prd_product_sizes)
- [라이브] SIZ_000013 (148x68) dflt=Y
- [라이브] SIZ_000014 (148x75) dflt=Y
#### 3. 도수/인쇄옵션 (t_prd_product_print_options)
- [라이브] opt=1 side=단면 앞=CLR_000005(CMYK 4도) 뒤=CLR_000001(인쇄 안 함) dflt=Y
- [라이브] opt=2 side=양면 앞=CLR_000005(CMYK 4도) 뒤=CLR_000005(CMYK 4도) dflt=Y
#### 4. 판형 (t_prd_product_plate_sizes)
- [라이브] SIZ_000149 (152x72) dflt_plt=Y 출력지=OUTPUT_PAPER_TYPE.03(기타) 파일=PDF
- [라이브] SIZ_000150 (152x79) dflt_plt=Y 출력지=OUTPUT_PAPER_TYPE.03(기타) 파일=-
#### 5. 자재 (t_prd_product_materials) — round-5 델타 MERGE
- [라이브] MAT_000107 (몽블랑 190g) / usage=USAGE.07(공통) dflt=Y (델타 외 라이브 기존)
- [라이브] MAT_000118 (클래식 크래스트 스티플 270g) / usage=USAGE.07(공통) dflt=Y (델타 외 라이브 기존)
- [라이브] MAT_000121 (켄도 250g) / usage=USAGE.07(공통) dflt=Y (델타 외 라이브 기존)
- [라이브] MAT_000125 (한지 170g) / usage=USAGE.07(공통) dflt=Y (델타 외 라이브 기존)
- [라이브] MAT_000128 (스타드림(실버) 240g) / usage=USAGE.07(공통) dflt=Y (델타 외 라이브 기존)
- [라이브] MAT_000129 (스타드림(골드) 240g) / usage=USAGE.07(공통) dflt=Y (델타 외 라이브 기존)
- [라이브] MAT_000240 (스타드림(다이아) 240g) / usage=USAGE.07(공통) dflt=Y (델타 외 라이브 기존)
- [라이브] MAT_000241 (스타드림(로츠쿼츠) 240g) / usage=USAGE.07(공통) dflt=Y (델타 외 라이브 기존)
#### 6. 공정 (t_prd_product_processes) — round-5 델타 MERGE
- [+R5] PROC_000029 (오시) mand=N seq=10 — 상품-공정 링크 라이브 미존재(적재 대기)
- [+R5] PROC_000030 (미싱) mand=N seq=11 — 상품-공정 링크 라이브 미존재(적재 대기)
- [+R5] PROC_000031 (가변텍스트) mand=N seq=12 — 상품-공정 링크 라이브 미존재(적재 대기)
- [+R5] PROC_000032 (가변이미지) mand=N seq=13 — 상품-공정 링크 라이브 미존재(적재 대기)
- [라이브] PROC_000037 (홀로그램) mand=N seq=1
- [라이브] PROC_000038 (금유광) mand=N seq=1
- [라이브] PROC_000039 (은유광) mand=N seq=1
- [라이브] PROC_000040 (먹유광) mand=N seq=1
- [라이브] PROC_000041 (동박) mand=N seq=1
- [라이브] PROC_000042 (적박) mand=N seq=1
- [라이브] PROC_000043 (청박) mand=N seq=1
- [라이브] PROC_000044 (트윙클) mand=N seq=1
#### 7. 묶음수 (t_prd_product_bundle_qtys) — round-5 델타 MERGE
- (없음 — 라이브·델타·차단 모두 0)
#### 8. 페이지룰 (t_prd_product_page_rules)
- (없음 — 라이브·델타·차단 모두 0)
#### 9. 추가상품 (t_prd_product_addons)
- (없음 — 라이브·델타·차단 모두 0)

### PRD_000047 — 소량전단지

**요약:** 카테고리 1 · 사이즈 4 · 도수 2 · 판형 4 · 자재 0 (+R5 47) · 공정 2 (+R5 2) · 묶음 **0/0** · 페이지룰 **0/0** · 추가상품 **0/0**

#### 1. 카테고리 (t_prd_product_categories)
- [라이브] CAT_000003 (인쇄홍보물) main=Y seq=1
#### 2. 사이즈 (t_prd_product_sizes)
- [라이브] SIZ_000170 (A5(148x210mm)) dflt=Y
- [라이브] SIZ_000172 (A4(210x297mm)) dflt=Y
- [라이브] SIZ_000174 (A3(297x420mm)) dflt=Y
- [라이브] SIZ_000176 (A3+(300x440mm)) dflt=Y
#### 3. 도수/인쇄옵션 (t_prd_product_print_options)
- [라이브] opt=1 side=단면 앞=CLR_000005(CMYK 4도) 뒤=CLR_000001(인쇄 안 함) dflt=Y
- [라이브] opt=2 side=양면 앞=CLR_000005(CMYK 4도) 뒤=CLR_000005(CMYK 4도) dflt=Y
#### 4. 판형 (t_prd_product_plate_sizes)
- [라이브] SIZ_000171 (152x214) dflt_plt=Y 출력지=OUTPUT_PAPER_TYPE.03(기타) 파일=PDF
- [라이브] SIZ_000173 (216x303) dflt_plt=Y 출력지=OUTPUT_PAPER_TYPE.03(기타) 파일=-
- [라이브] SIZ_000175 (303x426) dflt_plt=Y 출력지=OUTPUT_PAPER_TYPE.03(기타) 파일=-
- [라이브] SIZ_000177 (306x446) dflt_plt=Y 출력지=OUTPUT_PAPER_TYPE.03(기타) 파일=-
#### 5. 자재 (t_prd_product_materials) — round-5 델타 MERGE
- [+R5] MAT_000072 (백색모조지 100g) / usage=USAGE.07(공통) dflt=Y seq=1 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000073 (백색모조지 120g) / usage=USAGE.07(공통) dflt=N seq=2 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000074 (백색모조지 220g) / usage=USAGE.07(공통) dflt=N seq=3 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000076 (아트지 100g) / usage=USAGE.07(공통) dflt=N seq=4 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000077 (아트지 120g) / usage=USAGE.07(공통) dflt=N seq=5 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000078 (아트지 150g) / usage=USAGE.07(공통) dflt=N seq=6 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000079 (아트지 180g) / usage=USAGE.07(공통) dflt=N seq=7 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000080 (아트지 200g) / usage=USAGE.07(공통) dflt=N seq=8 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000081 (아트지 250g) / usage=USAGE.07(공통) dflt=N seq=9 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000082 (아트지 300g) / usage=USAGE.07(공통) dflt=N seq=10 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000086 (스노우지 100g) / usage=USAGE.07(공통) dflt=N seq=11 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000087 (스노우지 120g) / usage=USAGE.07(공통) dflt=N seq=12 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000088 (스노우지 150g) / usage=USAGE.07(공통) dflt=N seq=13 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000089 (스노우지 180g) / usage=USAGE.07(공통) dflt=N seq=14 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000090 (스노우지 200g) / usage=USAGE.07(공통) dflt=N seq=15 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000091 (스노우지 250g) / usage=USAGE.07(공통) dflt=N seq=16 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000092 (스노우지 300g) / usage=USAGE.07(공통) dflt=N seq=17 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000095 (앙상블 100g) / usage=USAGE.07(공통) dflt=N seq=18 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000096 (앙상블 130g) / usage=USAGE.07(공통) dflt=N seq=19 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000097 (앙상블 160g) / usage=USAGE.07(공통) dflt=N seq=20 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000098 (앙상블 190g) / usage=USAGE.07(공통) dflt=N seq=21 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000099 (앙상블 210g) / usage=USAGE.07(공통) dflt=N seq=22 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000101 (랑데뷰 WH 240g) / usage=USAGE.07(공통) dflt=N seq=23 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000102 (랑데뷰 WH 310g) / usage=USAGE.07(공통) dflt=N seq=24 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000104 (몽블랑 100g) / usage=USAGE.07(공통) dflt=N seq=25 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000105 (몽블랑 130g) / usage=USAGE.07(공통) dflt=N seq=26 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000106 (몽블랑 160g) / usage=USAGE.07(공통) dflt=N seq=27 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000107 (몽블랑 190g) / usage=USAGE.07(공통) dflt=N seq=28 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000108 (몽블랑 210g) / usage=USAGE.07(공통) dflt=N seq=29 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000109 (몽블랑 240g) / usage=USAGE.07(공통) dflt=N seq=30 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000113 (아코팩(웜화이트) 250g) / usage=USAGE.07(공통) dflt=N seq=31 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000114 (리사이클러스 240g) / usage=USAGE.07(공통) dflt=N seq=32 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000115 (매쉬멜로우 233g) / usage=USAGE.07(공통) dflt=N seq=33 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000116 (린넨커버 216g) / usage=USAGE.07(공통) dflt=N seq=34 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000117 (스타화이트(하이테크) 238g) / usage=USAGE.07(공통) dflt=N seq=35 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000118 (클래식 크래스트 스티플 270g) / usage=USAGE.07(공통) dflt=N seq=36 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000119 (리브스디자인 250g) / usage=USAGE.07(공통) dflt=N seq=37 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000120 (매직터치(백색) 250g) / usage=USAGE.07(공통) dflt=N seq=38 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000121 (켄도 250g) / usage=USAGE.07(공통) dflt=N seq=39 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000123 (띤또레또 200g) / usage=USAGE.07(공통) dflt=N seq=40 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000124 (띤또레또 250g) / usage=USAGE.07(공통) dflt=N seq=41 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000125 (한지 170g) / usage=USAGE.07(공통) dflt=N seq=42 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000126 (스코트랜드 220g) / usage=USAGE.07(공통) dflt=N seq=43 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000127 (스타드림(다이아몬드) 240g) / usage=USAGE.07(공통) dflt=N seq=44 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000128 (스타드림(실버) 240g) / usage=USAGE.07(공통) dflt=N seq=45 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000129 (스타드림(골드) 240g) / usage=USAGE.07(공통) dflt=N seq=46 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000130 (스타드림(로즈쿼츠) 240g) / usage=USAGE.07(공통) dflt=N seq=47 — 상품-자재 링크 라이브 미존재(적재 대기)
#### 6. 공정 (t_prd_product_processes) — round-5 델타 MERGE
- [+R5] PROC_000031 (가변텍스트) mand=N seq=10 — 상품-공정 링크 라이브 미존재(적재 대기)
- [+R5] PROC_000032 (가변이미지) mand=N seq=11 — 상품-공정 링크 라이브 미존재(적재 대기)
- [라이브] PROC_000014 (유광) mand=N seq=1
- [라이브] PROC_000015 (무광) mand=N seq=1
#### 7. 묶음수 (t_prd_product_bundle_qtys) — round-5 델타 MERGE
- (없음 — 라이브·델타·차단 모두 0)
#### 8. 페이지룰 (t_prd_product_page_rules)
- (없음 — 라이브·델타·차단 모두 0)
#### 9. 추가상품 (t_prd_product_addons)
- (없음 — 라이브·델타·차단 모두 0)

### PRD_000048 — 접지리플렛

**요약:** 카테고리 1 · 사이즈 **0/0** · 도수 1 · 판형 6 · 자재 0 (+R5 47) · 공정 2 (+R5 2) · 묶음 **0/0** · 페이지룰 **0/0** · 추가상품 **0/0**

#### 1. 카테고리 (t_prd_product_categories)
- [라이브] CAT_000003 (인쇄홍보물) main=Y seq=1
#### 2. 사이즈 (t_prd_product_sizes)
- (없음 — 라이브·델타·차단 모두 0)
#### 3. 도수/인쇄옵션 (t_prd_product_print_options)
- [라이브] opt=1 side=양면 앞=CLR_000005(CMYK 4도) 뒤=CLR_000005(CMYK 4도) dflt=Y
#### 4. 판형 (t_prd_product_plate_sizes)
- [라이브] SIZ_000178 (214x152) dflt_plt=Y 출력지=OUTPUT_PAPER_TYPE.03(기타) 파일=PDF
- [라이브] SIZ_000179 (303x216) dflt_plt=Y 출력지=OUTPUT_PAPER_TYPE.03(기타) 파일=-
- [라이브] SIZ_000180 (302x216) dflt_plt=Y 출력지=OUTPUT_PAPER_TYPE.03(기타) 파일=-
- [라이브] SIZ_000181 (426x303) dflt_plt=Y 출력지=OUTPUT_PAPER_TYPE.03(기타) 파일=-
- [라이브] SIZ_000182 (425x303) dflt_plt=Y 출력지=OUTPUT_PAPER_TYPE.03(기타) 파일=-
- [라이브] SIZ_000184 (424x303) dflt_plt=Y 출력지=OUTPUT_PAPER_TYPE.03(기타) 파일=-
#### 5. 자재 (t_prd_product_materials) — round-5 델타 MERGE
- [+R5] MAT_000072 (백색모조지 100g) / usage=USAGE.07(공통) dflt=Y seq=1 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000073 (백색모조지 120g) / usage=USAGE.07(공통) dflt=N seq=2 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000074 (백색모조지 220g) / usage=USAGE.07(공통) dflt=N seq=3 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000076 (아트지 100g) / usage=USAGE.07(공통) dflt=N seq=4 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000077 (아트지 120g) / usage=USAGE.07(공통) dflt=N seq=5 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000078 (아트지 150g) / usage=USAGE.07(공통) dflt=N seq=6 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000079 (아트지 180g) / usage=USAGE.07(공통) dflt=N seq=7 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000080 (아트지 200g) / usage=USAGE.07(공통) dflt=N seq=8 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000081 (아트지 250g) / usage=USAGE.07(공통) dflt=N seq=9 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000082 (아트지 300g) / usage=USAGE.07(공통) dflt=N seq=10 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000086 (스노우지 100g) / usage=USAGE.07(공통) dflt=N seq=11 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000087 (스노우지 120g) / usage=USAGE.07(공통) dflt=N seq=12 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000088 (스노우지 150g) / usage=USAGE.07(공통) dflt=N seq=13 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000089 (스노우지 180g) / usage=USAGE.07(공통) dflt=N seq=14 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000090 (스노우지 200g) / usage=USAGE.07(공통) dflt=N seq=15 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000091 (스노우지 250g) / usage=USAGE.07(공통) dflt=N seq=16 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000092 (스노우지 300g) / usage=USAGE.07(공통) dflt=N seq=17 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000095 (앙상블 100g) / usage=USAGE.07(공통) dflt=N seq=18 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000096 (앙상블 130g) / usage=USAGE.07(공통) dflt=N seq=19 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000097 (앙상블 160g) / usage=USAGE.07(공통) dflt=N seq=20 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000098 (앙상블 190g) / usage=USAGE.07(공통) dflt=N seq=21 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000099 (앙상블 210g) / usage=USAGE.07(공통) dflt=N seq=22 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000101 (랑데뷰 WH 240g) / usage=USAGE.07(공통) dflt=N seq=23 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000102 (랑데뷰 WH 310g) / usage=USAGE.07(공통) dflt=N seq=24 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000104 (몽블랑 100g) / usage=USAGE.07(공통) dflt=N seq=25 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000105 (몽블랑 130g) / usage=USAGE.07(공통) dflt=N seq=26 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000106 (몽블랑 160g) / usage=USAGE.07(공통) dflt=N seq=27 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000107 (몽블랑 190g) / usage=USAGE.07(공통) dflt=N seq=28 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000108 (몽블랑 210g) / usage=USAGE.07(공통) dflt=N seq=29 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000109 (몽블랑 240g) / usage=USAGE.07(공통) dflt=N seq=30 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000113 (아코팩(웜화이트) 250g) / usage=USAGE.07(공통) dflt=N seq=31 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000114 (리사이클러스 240g) / usage=USAGE.07(공통) dflt=N seq=32 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000115 (매쉬멜로우 233g) / usage=USAGE.07(공통) dflt=N seq=33 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000116 (린넨커버 216g) / usage=USAGE.07(공통) dflt=N seq=34 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000117 (스타화이트(하이테크) 238g) / usage=USAGE.07(공통) dflt=N seq=35 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000118 (클래식 크래스트 스티플 270g) / usage=USAGE.07(공통) dflt=N seq=36 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000119 (리브스디자인 250g) / usage=USAGE.07(공통) dflt=N seq=37 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000120 (매직터치(백색) 250g) / usage=USAGE.07(공통) dflt=N seq=38 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000121 (켄도 250g) / usage=USAGE.07(공통) dflt=N seq=39 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000123 (띤또레또 200g) / usage=USAGE.07(공통) dflt=N seq=40 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000124 (띤또레또 250g) / usage=USAGE.07(공통) dflt=N seq=41 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000125 (한지 170g) / usage=USAGE.07(공통) dflt=N seq=42 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000126 (스코트랜드 220g) / usage=USAGE.07(공통) dflt=N seq=43 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000127 (스타드림(다이아몬드) 240g) / usage=USAGE.07(공통) dflt=N seq=44 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000128 (스타드림(실버) 240g) / usage=USAGE.07(공통) dflt=N seq=45 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000129 (스타드림(골드) 240g) / usage=USAGE.07(공통) dflt=N seq=46 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000130 (스타드림(로즈쿼츠) 240g) / usage=USAGE.07(공통) dflt=N seq=47 — 상품-자재 링크 라이브 미존재(적재 대기)
#### 6. 공정 (t_prd_product_processes) — round-5 델타 MERGE
- [+R5] PROC_000031 (가변텍스트) mand=N seq=10 — 상품-공정 링크 라이브 미존재(적재 대기)
- [+R5] PROC_000032 (가변이미지) mand=N seq=11 — 상품-공정 링크 라이브 미존재(적재 대기)
- [라이브] PROC_000014 (유광) mand=N seq=1
- [라이브] PROC_000015 (무광) mand=N seq=1
#### 7. 묶음수 (t_prd_product_bundle_qtys) — round-5 델타 MERGE
- (없음 — 라이브·델타·차단 모두 0)
#### 8. 페이지룰 (t_prd_product_page_rules)
- (없음 — 라이브·델타·차단 모두 0)
#### 9. 추가상품 (t_prd_product_addons)
- (없음 — 라이브·델타·차단 모두 0)
#### + 가격공식 (t_prd_product_price_formulas)
- [+R5] PRF_FOLD_SUM — 라이브 미존재(적재 대기). 접지리플렛→접지(오시+접지) 후가공 구성요소

### PRD_000049 — 와이드 접지리플렛

**요약:** 카테고리 1 · 사이즈 **0/0** · 도수 1 · 판형 3 · 자재 5 · 공정 4 (+R5 2) · 묶음 **0/0** · 페이지룰 **0/0** · 추가상품 **0/0**

#### 1. 카테고리 (t_prd_product_categories)
- [라이브] CAT_000003 (인쇄홍보물) main=Y seq=1
#### 2. 사이즈 (t_prd_product_sizes)
- (없음 — 라이브·델타·차단 모두 0)
#### 3. 도수/인쇄옵션 (t_prd_product_print_options)
- [라이브] opt=1 side=양면 앞=CLR_000005(CMYK 4도) 뒤=CLR_000005(CMYK 4도) dflt=Y
#### 4. 판형 (t_prd_product_plate_sizes)
- [라이브] SIZ_000186 (635x303) dflt_plt=Y 출력지=OUTPUT_PAPER_TYPE.03(기타) 파일=PDF
- [라이브] SIZ_000188 (644x303) dflt_plt=Y 출력지=OUTPUT_PAPER_TYPE.03(기타) 파일=-
- [라이브] SIZ_000190 (646x303) dflt_plt=Y 출력지=OUTPUT_PAPER_TYPE.03(기타) 파일=-
#### 5. 자재 (t_prd_product_materials) — round-5 델타 MERGE
- [라이브] MAT_000078 (아트지 150g) / usage=USAGE.07(공통) dflt=Y (델타 외 라이브 기존)
- [라이브] MAT_000091 (스노우지 250g) / usage=USAGE.07(공통) dflt=Y (델타 외 라이브 기존)
- [라이브] MAT_000105 (몽블랑 130g) / usage=USAGE.07(공통) dflt=Y (델타 외 라이브 기존)
- [라이브] MAT_000107 (몽블랑 190g) / usage=USAGE.07(공통) dflt=Y (델타 외 라이브 기존)
- [라이브] MAT_000109 (몽블랑 240g) / usage=USAGE.07(공통) dflt=Y (델타 외 라이브 기존)
#### 6. 공정 (t_prd_product_processes) — round-5 델타 MERGE
- [+R5] PROC_000031 (가변텍스트) mand=N seq=10 — 상품-공정 링크 라이브 미존재(적재 대기)
- [+R5] PROC_000032 (가변이미지) mand=N seq=11 — 상품-공정 링크 라이브 미존재(적재 대기)
- [라이브] PROC_000014 (유광) mand=N seq=1
- [라이브] PROC_000015 (무광) mand=N seq=1
- [라이브] PROC_000060 (3단접지) mand=N seq=1
- [라이브] PROC_000071 (병풍접지) mand=N seq=1
#### 7. 묶음수 (t_prd_product_bundle_qtys) — round-5 델타 MERGE
- (없음 — 라이브·델타·차단 모두 0)
#### 8. 페이지룰 (t_prd_product_page_rules)
- (없음 — 라이브·델타·차단 모두 0)
#### 9. 추가상품 (t_prd_product_addons)
- (없음 — 라이브·델타·차단 모두 0)

### PRD_000053 — 반칼 자유형 투명스티커

**요약:** 카테고리 1 · 사이즈 3 · 도수 1 · 판형 3 · 자재 1 · 공정 1 (+R5 1) · 묶음 **0/0** · 페이지룰 **0/0** · 추가상품 **0/0**

#### 1. 카테고리 (t_prd_product_categories)
- [라이브] CAT_000002 (스티커) main=Y seq=1
#### 2. 사이즈 (t_prd_product_sizes)
- [라이브] SIZ_000170 (A5(148x210mm)) dflt=Y
- [라이브] SIZ_000172 (A4(210x297mm)) dflt=Y
- [라이브] SIZ_000196 (A6(105x148mm)) dflt=Y
#### 3. 도수/인쇄옵션 (t_prd_product_print_options)
- [라이브] opt=1 side=단면 앞=CLR_000005(CMYK 4도) 뒤=CLR_000001(인쇄 안 함) dflt=Y
#### 4. 판형 (t_prd_product_plate_sizes)
- [라이브] SIZ_000007 (148x210) dflt_plt=Y 출력지=- 파일=AI (칼선)
- [라이브] SIZ_000050 (210x297) dflt_plt=Y 출력지=- 파일=*아이마크
- [라이브] SIZ_000057 (105x148) dflt_plt=Y 출력지=OUTPUT_PAPER_TYPE.03(기타) 파일=PDF(W)
#### 5. 자재 (t_prd_product_materials) — round-5 델타 MERGE
- [라이브] MAT_000162 (투명스티커) / usage=USAGE.07(공통) dflt=Y (델타 외 라이브 기존)
#### 6. 공정 (t_prd_product_processes) — round-5 델타 MERGE
- [+R5] PROC_000008 (화이트) mand=N seq=2 — 상품-공정 링크 라이브 미존재(적재 대기)
- [라이브] PROC_000054 (반칼) mand=N seq=1
#### 7. 묶음수 (t_prd_product_bundle_qtys) — round-5 델타 MERGE
- (없음 — 라이브·델타·차단 모두 0)
#### 8. 페이지룰 (t_prd_product_page_rules)
- (없음 — 라이브·델타·차단 모두 0)
#### 9. 추가상품 (t_prd_product_addons)
- (없음 — 라이브·델타·차단 모두 0)
#### + 가격공식 (t_prd_product_price_formulas)
- [+R5] PRF_STK_FIXED — 라이브 미존재(적재 대기). 반칼 자유형 투명스티커→규격/소재/수량 단가

### PRD_000054 — 반칼 자유형 홀로그램스티커

**요약:** 카테고리 1 · 사이즈 3 · 도수 1 · 판형 3 · 자재 1 · 공정 1 (+R5 1) · 묶음 **0/0** · 페이지룰 **0/0** · 추가상품 **0/0**

#### 1. 카테고리 (t_prd_product_categories)
- [라이브] CAT_000002 (스티커) main=Y seq=1
#### 2. 사이즈 (t_prd_product_sizes)
- [라이브] SIZ_000170 (A5(148x210mm)) dflt=Y
- [라이브] SIZ_000172 (A4(210x297mm)) dflt=Y
- [라이브] SIZ_000196 (A6(105x148mm)) dflt=Y
#### 3. 도수/인쇄옵션 (t_prd_product_print_options)
- [라이브] opt=1 side=단면 앞=CLR_000005(CMYK 4도) 뒤=CLR_000001(인쇄 안 함) dflt=Y
#### 4. 판형 (t_prd_product_plate_sizes)
- [라이브] SIZ_000007 (148x210) dflt_plt=Y 출력지=- 파일=AI (칼선)
- [라이브] SIZ_000050 (210x297) dflt_plt=Y 출력지=- 파일=*아이마크
- [라이브] SIZ_000057 (105x148) dflt_plt=Y 출력지=OUTPUT_PAPER_TYPE.03(기타) 파일=PDF(W)
#### 5. 자재 (t_prd_product_materials) — round-5 델타 MERGE
- [라이브] MAT_000163 (홀로그램스티커) / usage=USAGE.07(공통) dflt=Y (델타 외 라이브 기존)
#### 6. 공정 (t_prd_product_processes) — round-5 델타 MERGE
- [+R5] PROC_000008 (화이트) mand=N seq=2 — 상품-공정 링크 라이브 미존재(적재 대기)
- [라이브] PROC_000054 (반칼) mand=N seq=1
#### 7. 묶음수 (t_prd_product_bundle_qtys) — round-5 델타 MERGE
- (없음 — 라이브·델타·차단 모두 0)
#### 8. 페이지룰 (t_prd_product_page_rules)
- (없음 — 라이브·델타·차단 모두 0)
#### 9. 추가상품 (t_prd_product_addons)
- (없음 — 라이브·델타·차단 모두 0)

### PRD_000056 — 낱장 자유형 투명스티커

**요약:** 카테고리 1 · 사이즈 3 · 도수 1 · 판형 3 · 자재 1 · 공정 1 (+R5 1) · 묶음 **0/0** · 페이지룰 **0/0** · 추가상품 **0/0**

#### 1. 카테고리 (t_prd_product_categories)
- [라이브] CAT_000002 (스티커) main=Y seq=1
#### 2. 사이즈 (t_prd_product_sizes)
- [라이브] SIZ_000172 (A4(210x297mm)) dflt=Y
- [라이브] SIZ_000174 (A3(297x420mm)) dflt=Y
- [라이브] SIZ_000197 (A2(420x594mm)) dflt=Y
#### 3. 도수/인쇄옵션 (t_prd_product_print_options)
- [라이브] opt=1 side=단면 앞=CLR_000005(CMYK 4도) 뒤=CLR_000001(인쇄 안 함) dflt=Y
#### 4. 판형 (t_prd_product_plate_sizes)
- [라이브] SIZ_000050 (210x297) dflt_plt=Y 출력지=OUTPUT_PAPER_TYPE.03(기타) 파일=PDF(W)
- [라이브] SIZ_000052 (297x420) dflt_plt=Y 출력지=OUTPUT_PAPER_TYPE.03(기타) 파일=AI (칼선)
- [라이브] SIZ_000198 (420x594) dflt_plt=Y 출력지=OUTPUT_PAPER_TYPE.03(기타) 파일=*아이마크
#### 5. 자재 (t_prd_product_materials) — round-5 델타 MERGE
- [라이브] MAT_000243 (투명전용지) / usage=USAGE.07(공통) dflt=Y (델타 외 라이브 기존)
#### 6. 공정 (t_prd_product_processes) — round-5 델타 MERGE
- [+R5] PROC_000008 (화이트) mand=N seq=2 — 상품-공정 링크 라이브 미존재(적재 대기)
- [라이브] PROC_000053 (완칼) mand=N seq=1
#### 7. 묶음수 (t_prd_product_bundle_qtys) — round-5 델타 MERGE
- (없음 — 라이브·델타·차단 모두 0)
#### 8. 페이지룰 (t_prd_product_page_rules)
- (없음 — 라이브·델타·차단 모두 0)
#### 9. 추가상품 (t_prd_product_addons)
- (없음 — 라이브·델타·차단 모두 0)

### PRD_000068 — 중철책자

**요약:** 카테고리 1 · 사이즈 2 · 도수 2 · 판형 4 · 자재 0 (+R5 26) · 공정 3 · 묶음 **0/0** · 페이지룰 1 · 추가상품 **0/0**

#### 1. 카테고리 (t_prd_product_categories)
- [라이브] CAT_000006 (책자) main=Y seq=1
#### 2. 사이즈 (t_prd_product_sizes)
- [라이브] SIZ_000170 (A5(148x210mm)) dflt=Y
- [라이브] SIZ_000172 (A4(210x297mm)) dflt=Y
#### 3. 도수/인쇄옵션 (t_prd_product_print_options)
- [라이브] opt=1 side=양면 앞=CLR_000005(CMYK 4도) 뒤=CLR_000005(CMYK 4도) dflt=Y
- [라이브] opt=2 side=단면 앞=CLR_000005(CMYK 4도) 뒤=CLR_000001(인쇄 안 함) dflt=Y
#### 4. 판형 (t_prd_product_plate_sizes)
- [라이브] SIZ_000181 (426x303) dflt_plt=Y 출력지=- 파일=-
- [라이브] SIZ_000250 (150x214) dflt_plt=Y 출력지=- 파일=PDF
- [라이브] SIZ_000251 (300x214) dflt_plt=Y 출력지=- 파일=PDF
- [라이브] SIZ_000252 (213x303) dflt_plt=Y 출력지=- 파일=-
#### 5. 자재 (t_prd_product_materials) — round-5 델타 MERGE
- [+R5] MAT_000073 (백색모조지 120g) / usage=USAGE.01(내지) dflt=Y seq=1 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000077 (아트지 120g) / usage=USAGE.01(내지) dflt=N seq=2 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000078 (아트지 150g) / usage=USAGE.01(내지) dflt=N seq=3 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000079 (아트지 180g) / usage=USAGE.01(내지) dflt=N seq=4 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000080 (아트지 200g) / usage=USAGE.01(내지) dflt=N seq=5 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000087 (스노우지 120g) / usage=USAGE.01(내지) dflt=N seq=6 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000088 (스노우지 150g) / usage=USAGE.01(내지) dflt=N seq=7 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000089 (스노우지 180g) / usage=USAGE.01(내지) dflt=N seq=8 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000090 (스노우지 200g) / usage=USAGE.01(내지) dflt=N seq=9 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000104 (몽블랑 100g) / usage=USAGE.01(내지) dflt=N seq=10 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000105 (몽블랑 130g) / usage=USAGE.01(내지) dflt=N seq=11 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000106 (몽블랑 160g) / usage=USAGE.01(내지) dflt=N seq=12 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000107 (몽블랑 190g) / usage=USAGE.01(내지) dflt=N seq=13 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000073 (백색모조지 120g) / usage=USAGE.02(표지) dflt=Y seq=1 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000077 (아트지 120g) / usage=USAGE.02(표지) dflt=N seq=2 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000078 (아트지 150g) / usage=USAGE.02(표지) dflt=N seq=3 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000079 (아트지 180g) / usage=USAGE.02(표지) dflt=N seq=4 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000080 (아트지 200g) / usage=USAGE.02(표지) dflt=N seq=5 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000087 (스노우지 120g) / usage=USAGE.02(표지) dflt=N seq=6 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000088 (스노우지 150g) / usage=USAGE.02(표지) dflt=N seq=7 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000089 (스노우지 180g) / usage=USAGE.02(표지) dflt=N seq=8 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000090 (스노우지 200g) / usage=USAGE.02(표지) dflt=N seq=9 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000104 (몽블랑 100g) / usage=USAGE.02(표지) dflt=N seq=10 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000105 (몽블랑 130g) / usage=USAGE.02(표지) dflt=N seq=11 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000106 (몽블랑 160g) / usage=USAGE.02(표지) dflt=N seq=12 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000107 (몽블랑 190g) / usage=USAGE.02(표지) dflt=N seq=13 — 상품-자재 링크 라이브 미존재(적재 대기)
#### 6. 공정 (t_prd_product_processes) — round-5 델타 MERGE
- [라이브] PROC_000014 (유광) mand=N seq=1
- [라이브] PROC_000015 (무광) mand=N seq=1
- [라이브] PROC_000018 (중철제본) mand=N seq=1
#### 7. 묶음수 (t_prd_product_bundle_qtys) — round-5 델타 MERGE
- (없음 — 라이브·델타·차단 모두 0)
#### 8. 페이지룰 (t_prd_product_page_rules)
- [라이브] min=4 max=28 incr=4
#### 9. 추가상품 (t_prd_product_addons)
- (없음 — 라이브·델타·차단 모두 0)
#### + 가격공식 (t_prd_product_price_formulas)
- [+R5] PRF_BIND_SUM — 라이브 미존재(적재 대기). 중철책자→제본 구성요소

### PRD_000069 — 무선책자

**요약:** 카테고리 1 · 사이즈 2 · 도수 2 · 판형 2 · 자재 0 (+R5 13) · 공정 12 (+R5 2) · 묶음 **0/0** · 페이지룰 1 · 추가상품 **0/0**

#### 1. 카테고리 (t_prd_product_categories)
- [라이브] CAT_000006 (책자) main=Y seq=1
#### 2. 사이즈 (t_prd_product_sizes)
- [라이브] SIZ_000170 (A5(148x210mm)) dflt=Y
- [라이브] SIZ_000172 (A4(210x297mm)) dflt=Y
#### 3. 도수/인쇄옵션 (t_prd_product_print_options)
- [라이브] opt=1 side=양면 앞=CLR_000005(CMYK 4도) 뒤=CLR_000005(CMYK 4도) dflt=Y
- [라이브] opt=2 side=단면 앞=CLR_000005(CMYK 4도) 뒤=CLR_000001(인쇄 안 함) dflt=Y
#### 4. 판형 (t_prd_product_plate_sizes)
- [라이브] SIZ_000250 (150x214) dflt_plt=Y 출력지=- 파일=PDF
- [라이브] SIZ_000252 (213x303) dflt_plt=Y 출력지=- 파일=-
#### 5. 자재 (t_prd_product_materials) — round-5 델타 MERGE
- [+R5] MAT_000073 (백색모조지 120g) / usage=USAGE.01(내지) dflt=Y seq=1 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000077 (아트지 120g) / usage=USAGE.01(내지) dflt=N seq=2 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000087 (스노우지 120g) / usage=USAGE.01(내지) dflt=N seq=3 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000095 (앙상블 100g) / usage=USAGE.01(내지) dflt=N seq=4 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000096 (앙상블 130g) / usage=USAGE.01(내지) dflt=N seq=5 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000104 (몽블랑 100g) / usage=USAGE.01(내지) dflt=N seq=6 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000105 (몽블랑 130g) / usage=USAGE.01(내지) dflt=N seq=7 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000074 (백색모조지 220g) / usage=USAGE.02(표지) dflt=Y seq=1 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000081 (아트지 250g) / usage=USAGE.02(표지) dflt=N seq=2 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000082 (아트지 300g) / usage=USAGE.02(표지) dflt=N seq=3 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000091 (스노우지 250g) / usage=USAGE.02(표지) dflt=N seq=4 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000092 (스노우지 300g) / usage=USAGE.02(표지) dflt=N seq=5 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000109 (몽블랑 240g) / usage=USAGE.02(표지) dflt=N seq=6 — 상품-자재 링크 라이브 미존재(적재 대기)
#### 6. 공정 (t_prd_product_processes) — round-5 델타 MERGE
- [+R5] PROC_000051 (양각) mand=N seq=51 — 상품-공정 링크 라이브 미존재(적재 대기)
- [+R5] PROC_000052 (음각) mand=N seq=52 — 상품-공정 링크 라이브 미존재(적재 대기)
- [라이브] PROC_000014 (유광) mand=N seq=1
- [라이브] PROC_000015 (무광) mand=N seq=1
- [라이브] PROC_000019 (무선제본) mand=N seq=1
- [라이브] PROC_000037 (홀로그램) mand=N seq=1
- [라이브] PROC_000038 (금유광) mand=N seq=1
- [라이브] PROC_000039 (은유광) mand=N seq=1
- [라이브] PROC_000040 (먹유광) mand=N seq=1
- [라이브] PROC_000041 (동박) mand=N seq=1
- [라이브] PROC_000042 (적박) mand=N seq=1
- [라이브] PROC_000043 (청박) mand=N seq=1
- [라이브] PROC_000044 (트윙클) mand=N seq=1
- [라이브] PROC_000076 (수축포장) mand=N seq=1
#### 7. 묶음수 (t_prd_product_bundle_qtys) — round-5 델타 MERGE
- (없음 — 라이브·델타·차단 모두 0)
#### 8. 페이지룰 (t_prd_product_page_rules)
- [라이브] min=24 max=300 incr=2
#### 9. 추가상품 (t_prd_product_addons)
- (없음 — 라이브·델타·차단 모두 0)
#### + 가격공식 (t_prd_product_price_formulas)
- [+R5] PRF_BIND_SUM — 라이브 미존재(적재 대기). 무선책자→제본 구성요소

### PRD_000070 — PUR책자

**요약:** 카테고리 1 · 사이즈 2 · 도수 2 · 판형 2 · 자재 **0/0** · 공정 12 (+R5 2) · 묶음 **0/0** · 페이지룰 1 · 추가상품 **0/0**

#### 1. 카테고리 (t_prd_product_categories)
- [라이브] CAT_000006 (책자) main=Y seq=1
#### 2. 사이즈 (t_prd_product_sizes)
- [라이브] SIZ_000170 (A5(148x210mm)) dflt=Y
- [라이브] SIZ_000172 (A4(210x297mm)) dflt=Y
#### 3. 도수/인쇄옵션 (t_prd_product_print_options)
- [라이브] opt=1 side=단면 앞=CLR_000005(CMYK 4도) 뒤=CLR_000001(인쇄 안 함) dflt=Y
- [라이브] opt=2 side=양면 앞=CLR_000005(CMYK 4도) 뒤=CLR_000005(CMYK 4도) dflt=Y
#### 4. 판형 (t_prd_product_plate_sizes)
- [라이브] SIZ_000250 (150x214) dflt_plt=Y 출력지=- 파일=PDF
- [라이브] SIZ_000252 (213x303) dflt_plt=Y 출력지=- 파일=-
#### 5. 자재 (t_prd_product_materials) — round-5 델타 MERGE
- (없음 — 라이브·델타·차단 모두 0)
#### 6. 공정 (t_prd_product_processes) — round-5 델타 MERGE
- [+R5] PROC_000051 (양각) mand=N seq=51 — 상품-공정 링크 라이브 미존재(적재 대기)
- [+R5] PROC_000052 (음각) mand=N seq=52 — 상품-공정 링크 라이브 미존재(적재 대기)
- [라이브] PROC_000014 (유광) mand=N seq=1
- [라이브] PROC_000015 (무광) mand=N seq=1
- [라이브] PROC_000020 (PUR제본) mand=N seq=1
- [라이브] PROC_000037 (홀로그램) mand=N seq=1
- [라이브] PROC_000038 (금유광) mand=N seq=1
- [라이브] PROC_000039 (은유광) mand=N seq=1
- [라이브] PROC_000040 (먹유광) mand=N seq=1
- [라이브] PROC_000041 (동박) mand=N seq=1
- [라이브] PROC_000042 (적박) mand=N seq=1
- [라이브] PROC_000043 (청박) mand=N seq=1
- [라이브] PROC_000044 (트윙클) mand=N seq=1
- [라이브] PROC_000076 (수축포장) mand=N seq=1
#### 7. 묶음수 (t_prd_product_bundle_qtys) — round-5 델타 MERGE
- (없음 — 라이브·델타·차단 모두 0)
#### 8. 페이지룰 (t_prd_product_page_rules)
- [라이브] min=24 max=300 incr=2
#### 9. 추가상품 (t_prd_product_addons)
- (없음 — 라이브·델타·차단 모두 0)
#### + 가격공식 (t_prd_product_price_formulas)
- [+R5] PRF_BIND_SUM — 라이브 미존재(적재 대기). PUR책자→제본 구성요소

### PRD_000071 — 트윈링책자

**요약:** 카테고리 1 · 사이즈 4 · 도수 2 · 판형 5 · 자재 5 (+R5 44) · 공정 4 · 묶음 **0/0** · 페이지룰 1 · 추가상품 **0/0**

#### 1. 카테고리 (t_prd_product_categories)
- [라이브] CAT_000006 (책자) main=Y seq=1
#### 2. 사이즈 (t_prd_product_sizes)
- [라이브] SIZ_000170 (A5(148x210mm)) dflt=Y
- [라이브] SIZ_000172 (A4(210x297mm)) dflt=Y
- [라이브] SIZ_000253 (A5(210x148mm)) dflt=Y
- [라이브] SIZ_000255 (A4(297x210mm)) dflt=Y
#### 3. 도수/인쇄옵션 (t_prd_product_print_options)
- [라이브] opt=1 side=단면 앞=CLR_000005(CMYK 4도) 뒤=CLR_000001(인쇄 안 함) dflt=Y
- [라이브] opt=2 side=양면 앞=CLR_000005(CMYK 4도) 뒤=CLR_000005(CMYK 4도) dflt=Y
#### 4. 판형 (t_prd_product_plate_sizes)
- [라이브] SIZ_000173 (216x303) dflt_plt=Y 출력지=- 파일=-
- [라이브] SIZ_000250 (150x214) dflt_plt=Y 출력지=- 파일=PDF
- [라이브] SIZ_000252 (213x303) dflt_plt=Y 출력지=- 파일=-
- [라이브] SIZ_000254 (214x150) dflt_plt=Y 출력지=- 파일=-
- [라이브] SIZ_000256 (303x213) dflt_plt=Y 출력지=- 파일=-
#### 5. 자재 (t_prd_product_materials) — round-5 델타 MERGE
- [+R5] MAT_000072 (백색모조지 100g) / usage=USAGE.01(내지) dflt=Y seq=1 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000073 (백색모조지 120g) / usage=USAGE.01(내지) dflt=N seq=2 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000076 (아트지 100g) / usage=USAGE.01(내지) dflt=N seq=3 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000077 (아트지 120g) / usage=USAGE.01(내지) dflt=N seq=4 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000078 (아트지 150g) / usage=USAGE.01(내지) dflt=N seq=5 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000079 (아트지 180g) / usage=USAGE.01(내지) dflt=N seq=6 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000086 (스노우지 100g) / usage=USAGE.01(내지) dflt=N seq=7 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000087 (스노우지 120g) / usage=USAGE.01(내지) dflt=N seq=8 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000088 (스노우지 150g) / usage=USAGE.01(내지) dflt=N seq=9 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000089 (스노우지 180g) / usage=USAGE.01(내지) dflt=N seq=10 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000095 (앙상블 100g) / usage=USAGE.01(내지) dflt=N seq=11 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000096 (앙상블 130g) / usage=USAGE.01(내지) dflt=N seq=12 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000097 (앙상블 160g) / usage=USAGE.01(내지) dflt=N seq=13 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000104 (몽블랑 100g) / usage=USAGE.01(내지) dflt=N seq=14 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000105 (몽블랑 130g) / usage=USAGE.01(내지) dflt=N seq=15 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000106 (몽블랑 160g) / usage=USAGE.01(내지) dflt=N seq=16 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000072 (백색모조지 100g) / usage=USAGE.02(표지) dflt=Y seq=1 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000073 (백색모조지 120g) / usage=USAGE.02(표지) dflt=N seq=2 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000074 (백색모조지 220g) / usage=USAGE.02(표지) dflt=N seq=3 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000076 (아트지 100g) / usage=USAGE.02(표지) dflt=N seq=4 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000077 (아트지 120g) / usage=USAGE.02(표지) dflt=N seq=5 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000078 (아트지 150g) / usage=USAGE.02(표지) dflt=N seq=6 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000079 (아트지 180g) / usage=USAGE.02(표지) dflt=N seq=7 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000080 (아트지 200g) / usage=USAGE.02(표지) dflt=N seq=8 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000081 (아트지 250g) / usage=USAGE.02(표지) dflt=N seq=9 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000082 (아트지 300g) / usage=USAGE.02(표지) dflt=N seq=10 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000086 (스노우지 100g) / usage=USAGE.02(표지) dflt=N seq=11 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000087 (스노우지 120g) / usage=USAGE.02(표지) dflt=N seq=12 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000088 (스노우지 150g) / usage=USAGE.02(표지) dflt=N seq=13 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000089 (스노우지 180g) / usage=USAGE.02(표지) dflt=N seq=14 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000090 (스노우지 200g) / usage=USAGE.02(표지) dflt=N seq=15 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000091 (스노우지 250g) / usage=USAGE.02(표지) dflt=N seq=16 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000092 (스노우지 300g) / usage=USAGE.02(표지) dflt=N seq=17 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000095 (앙상블 100g) / usage=USAGE.02(표지) dflt=N seq=18 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000096 (앙상블 130g) / usage=USAGE.02(표지) dflt=N seq=19 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000097 (앙상블 160g) / usage=USAGE.02(표지) dflt=N seq=20 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000098 (앙상블 190g) / usage=USAGE.02(표지) dflt=N seq=21 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000099 (앙상블 210g) / usage=USAGE.02(표지) dflt=N seq=22 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000104 (몽블랑 100g) / usage=USAGE.02(표지) dflt=N seq=23 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000105 (몽블랑 130g) / usage=USAGE.02(표지) dflt=N seq=24 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000106 (몽블랑 160g) / usage=USAGE.02(표지) dflt=N seq=25 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000107 (몽블랑 190g) / usage=USAGE.02(표지) dflt=N seq=26 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000108 (몽블랑 210g) / usage=USAGE.02(표지) dflt=N seq=27 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000109 (몽블랑 240g) / usage=USAGE.02(표지) dflt=N seq=28 — 상품-자재 링크 라이브 미존재(적재 대기)
- [라이브] MAT_000013 (링 화이트링) / usage=USAGE.07(공통) dflt=Y (델타 외 라이브 기존)
- [라이브] MAT_000014 (링 블랙링) / usage=USAGE.07(공통) dflt=Y (델타 외 라이브 기존)
- [라이브] MAT_000015 (링 메탈링) / usage=USAGE.07(공통) dflt=Y (델타 외 라이브 기존)
- [라이브] MAT_000244 (투명커버 유광투명커버) / usage=USAGE.05(투명커버) dflt=Y (델타 외 라이브 기존)
- [라이브] MAT_000245 (투명커버 무광투명커버) / usage=USAGE.05(투명커버) dflt=Y (델타 외 라이브 기존)
#### 6. 공정 (t_prd_product_processes) — round-5 델타 MERGE
- [라이브] PROC_000014 (유광) mand=N seq=1
- [라이브] PROC_000015 (무광) mand=N seq=1
- [라이브] PROC_000021 (트윈링제본) mand=N seq=1
- [라이브] PROC_000076 (수축포장) mand=N seq=1
#### 7. 묶음수 (t_prd_product_bundle_qtys) — round-5 델타 MERGE
- (없음 — 라이브·델타·차단 모두 0)
#### 8. 페이지룰 (t_prd_product_page_rules)
- [라이브] min=8 max=100 incr=2
#### 9. 추가상품 (t_prd_product_addons)
- (없음 — 라이브·델타·차단 모두 0)
#### + 가격공식 (t_prd_product_price_formulas)
- [+R5] PRF_BIND_SUM — 라이브 미존재(적재 대기). 트윈링책자→제본 구성요소

### PRD_000108 — 탁상형캘린더

**요약:** 카테고리 1 · 사이즈 2 · 도수 1 · 판형 2 · 자재 3 (+R5 7) · 공정 1 · 묶음 **0/0** · 페이지룰 **0/0** · 추가상품 1

#### 1. 카테고리 (t_prd_product_categories)
- [라이브] CAT_000112 (탁상형캘린더) main=Y seq=1
#### 2. 사이즈 (t_prd_product_sizes)
- [라이브] SIZ_000069 (220x145) dflt=Y
- [라이브] SIZ_000070 (130x220) dflt=Y
#### 3. 도수/인쇄옵션 (t_prd_product_print_options)
- [라이브] opt=1 side=양면 앞=CLR_000005(CMYK 4도) 뒤=CLR_000005(CMYK 4도) dflt=Y
#### 4. 판형 (t_prd_product_plate_sizes)
- [라이브] SIZ_000282 (224x149) dflt_plt=Y 출력지=OUTPUT_PAPER_TYPE.03(기타) 파일=PDF
- [라이브] SIZ_000283 (134x224) dflt_plt=Y 출력지=OUTPUT_PAPER_TYPE.03(기타) 파일=PDF
#### 5. 자재 (t_prd_product_materials) — round-5 델타 MERGE
- [+R5] MAT_000090 (스노우지 200g) / usage=USAGE.07(공통) dflt=Y seq=1 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000113 (아코팩(웜화이트) 250g) / usage=USAGE.07(공통) dflt=N seq=3 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000114 (리사이클러스 240g) / usage=USAGE.07(공통) dflt=N seq=4 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000115 (매쉬멜로우 233g) / usage=USAGE.07(공통) dflt=N seq=5 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000116 (린넨커버 216g) / usage=USAGE.07(공통) dflt=N seq=6 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000123 (띤또레또 200g) / usage=USAGE.07(공통) dflt=N seq=7 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000127 (스타드림(다이아몬드) 240g) / usage=USAGE.07(공통) dflt=N seq=8 — 상품-자재 링크 라이브 미존재(적재 대기)
- [라이브] MAT_000107 (몽블랑 190g) / usage=USAGE.07(공통) dflt=Y (델타 외 라이브 기존)
- [라이브] MAT_000252 (삼각대(그레이)) / usage=USAGE.07(공통) dflt=Y (델타 외 라이브 기존)
- [라이브] MAT_000253 (링 블랙) / usage=USAGE.07(공통) dflt=Y (델타 외 라이브 기존)
#### 6. 공정 (t_prd_product_processes) — round-5 델타 MERGE
- [라이브] PROC_000076 (수축포장) mand=N seq=1
#### 7. 묶음수 (t_prd_product_bundle_qtys) — round-5 델타 MERGE
- (없음 — 라이브·델타·차단 모두 0)
#### 8. 페이지룰 (t_prd_product_page_rules)
- (없음 — 라이브·델타·차단 모두 0)
#### 9. 추가상품 (t_prd_product_addons)
- [라이브] TMPL-PRD_000005 → PRD_000005 (캘린더봉투) seq=1

### PRD_000109 — 미니탁상형캘린더

**요약:** 카테고리 1 · 사이즈 2 · 도수 1 · 판형 2 · 자재 3 (+R5 6) · 공정 1 · 묶음 **0/0** · 페이지룰 **0/0** · 추가상품 **0/0**

#### 1. 카테고리 (t_prd_product_categories)
- [라이브] CAT_000112 (탁상형캘린더) main=Y seq=1
#### 2. 사이즈 (t_prd_product_sizes)
- [라이브] SIZ_000018 (90x100) dflt=Y
- [라이브] SIZ_000071 (148x60) dflt=Y
#### 3. 도수/인쇄옵션 (t_prd_product_print_options)
- [라이브] opt=1 side=양면 앞=CLR_000005(CMYK 4도) 뒤=CLR_000005(CMYK 4도) dflt=Y
#### 4. 판형 (t_prd_product_plate_sizes)
- [라이브] SIZ_000284 (94x104) dflt_plt=Y 출력지=OUTPUT_PAPER_TYPE.03(기타) 파일=PDF
- [라이브] SIZ_000285 (152x64) dflt_plt=Y 출력지=OUTPUT_PAPER_TYPE.03(기타) 파일=PDF
#### 5. 자재 (t_prd_product_materials) — round-5 델타 MERGE
- [+R5] MAT_000090 (스노우지 200g) / usage=USAGE.07(공통) dflt=Y seq=1 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000113 (아코팩(웜화이트) 250g) / usage=USAGE.07(공통) dflt=N seq=3 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000114 (리사이클러스 240g) / usage=USAGE.07(공통) dflt=N seq=4 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000115 (매쉬멜로우 233g) / usage=USAGE.07(공통) dflt=N seq=5 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000116 (린넨커버 216g) / usage=USAGE.07(공통) dflt=N seq=6 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000127 (스타드림(다이아몬드) 240g) / usage=USAGE.07(공통) dflt=N seq=7 — 상품-자재 링크 라이브 미존재(적재 대기)
- [라이브] MAT_000107 (몽블랑 190g) / usage=USAGE.07(공통) dflt=Y (델타 외 라이브 기존)
- [라이브] MAT_000253 (링 블랙) / usage=USAGE.07(공통) dflt=Y (델타 외 라이브 기존)
- [라이브] MAT_000254 (삼각대(블랙)) / usage=USAGE.07(공통) dflt=Y (델타 외 라이브 기존)
#### 6. 공정 (t_prd_product_processes) — round-5 델타 MERGE
- [라이브] PROC_000076 (수축포장) mand=N seq=1
#### 7. 묶음수 (t_prd_product_bundle_qtys) — round-5 델타 MERGE
- (없음 — 라이브·델타·차단 모두 0)
#### 8. 페이지룰 (t_prd_product_page_rules)
- (없음 — 라이브·델타·차단 모두 0)
#### 9. 추가상품 (t_prd_product_addons)
- (없음 — 라이브·델타·차단 모두 0)

### PRD_000110 — 엽서캘린더

**요약:** 카테고리 1 · 사이즈 6 · 도수 1 · 판형 6 · 자재 1 (+R5 9) · 공정 1 · 묶음 **0/0** · 페이지룰 **0/0** · 추가상품 1

#### 1. 카테고리 (t_prd_product_categories)
- [라이브] CAT_000114 (엽서캘린더) main=Y seq=1
#### 2. 사이즈 (t_prd_product_sizes)
- [라이브] SIZ_000007 (148x210) dflt=Y
- [라이브] SIZ_000069 (220x145) dflt=Y
- [라이브] SIZ_000070 (130x220) dflt=Y
- [라이브] SIZ_000072 (145x145) dflt=Y
- [라이브] SIZ_000073 (220x130) dflt=Y
- [라이브] SIZ_000074 (145x300) dflt=Y
#### 3. 도수/인쇄옵션 (t_prd_product_print_options)
- [라이브] opt=1 side=단면 앞=CLR_000005(CMYK 4도) 뒤=CLR_000001(인쇄 안 함) dflt=Y
#### 4. 판형 (t_prd_product_plate_sizes)
- [라이브] SIZ_000171 (152x214) dflt_plt=Y 출력지=OUTPUT_PAPER_TYPE.03(기타) 파일=PDF
- [라이브] SIZ_000282 (224x149) dflt_plt=Y 출력지=OUTPUT_PAPER_TYPE.03(기타) 파일=PDF
- [라이브] SIZ_000283 (134x224) dflt_plt=Y 출력지=OUTPUT_PAPER_TYPE.03(기타) 파일=PDF
- [라이브] SIZ_000286 (149x149) dflt_plt=Y 출력지=OUTPUT_PAPER_TYPE.03(기타) 파일=PDF
- [라이브] SIZ_000287 (224x134) dflt_plt=Y 출력지=OUTPUT_PAPER_TYPE.03(기타) 파일=PDF
- [라이브] SIZ_000288 (149x304) dflt_plt=Y 출력지=OUTPUT_PAPER_TYPE.03(기타) 파일=PDF
#### 5. 자재 (t_prd_product_materials) — round-5 델타 MERGE
- [+R5] MAT_000090 (스노우지 200g) / usage=USAGE.07(공통) dflt=Y seq=1 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000098 (앙상블 190g) / usage=USAGE.07(공통) dflt=N seq=2 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000113 (아코팩(웜화이트) 250g) / usage=USAGE.07(공통) dflt=N seq=4 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000114 (리사이클러스 240g) / usage=USAGE.07(공통) dflt=N seq=5 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000115 (매쉬멜로우 233g) / usage=USAGE.07(공통) dflt=N seq=6 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000116 (린넨커버 216g) / usage=USAGE.07(공통) dflt=N seq=7 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000118 (클래식 크래스트 스티플 270g) / usage=USAGE.07(공통) dflt=N seq=8 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000123 (띤또레또 200g) / usage=USAGE.07(공통) dflt=N seq=9 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000127 (스타드림(다이아몬드) 240g) / usage=USAGE.07(공통) dflt=N seq=10 — 상품-자재 링크 라이브 미존재(적재 대기)
- [라이브] MAT_000107 (몽블랑 190g) / usage=USAGE.07(공통) dflt=Y (델타 외 라이브 기존)
#### 6. 공정 (t_prd_product_processes) — round-5 델타 MERGE
- [라이브] PROC_000079 (타공) mand=N seq=1
#### 7. 묶음수 (t_prd_product_bundle_qtys) — round-5 델타 MERGE
- (없음 — 라이브·델타·차단 모두 0)
#### 8. 페이지룰 (t_prd_product_page_rules)
- (없음 — 라이브·델타·차단 모두 0)
#### 9. 추가상품 (t_prd_product_addons)
- [라이브] TMPL-PRD_000012 → PRD_000012 (우드거치대) seq=1

### PRD_000111 — 벽걸이캘린더

**요약:** 카테고리 1 · 사이즈 3 · 도수 2 · 판형 3 · 자재 2 (+R5 21) · 공정 2 · 묶음 **0/0** · 페이지룰 **0/0** · 추가상품 **0/0**

#### 1. 카테고리 (t_prd_product_categories)
- [라이브] CAT_000115 (벽걸이캘린더) main=Y seq=1
#### 2. 사이즈 (t_prd_product_sizes)
- [라이브] SIZ_000050 (210x297) dflt=Y
- [라이브] SIZ_000075 (210x420) dflt=Y
- [라이브] SIZ_000076 (300x420) dflt=Y
#### 3. 도수/인쇄옵션 (t_prd_product_print_options)
- [라이브] opt=1 side=단면 앞=CLR_000005(CMYK 4도) 뒤=CLR_000001(인쇄 안 함) dflt=Y
- [라이브] opt=2 side=양면 앞=CLR_000005(CMYK 4도) 뒤=CLR_000005(CMYK 4도) dflt=Y
#### 4. 판형 (t_prd_product_plate_sizes)
- [라이브] SIZ_000289 (214x301) dflt_plt=Y 출력지=OUTPUT_PAPER_TYPE.03(기타) 파일=PDF
- [라이브] SIZ_000290 (214x424) dflt_plt=Y 출력지=OUTPUT_PAPER_TYPE.03(기타) 파일=PDF
- [라이브] SIZ_000291 (304x424) dflt_plt=Y 출력지=OUTPUT_PAPER_TYPE.03(기타) 파일=PDF
#### 5. 자재 (t_prd_product_materials) — round-5 델타 MERGE
- [+R5] MAT_000074 (백색모조지 220g) / usage=USAGE.07(공통) dflt=Y seq=1 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000079 (아트지 180g) / usage=USAGE.07(공통) dflt=N seq=2 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000080 (아트지 200g) / usage=USAGE.07(공통) dflt=N seq=3 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000081 (아트지 250g) / usage=USAGE.07(공통) dflt=N seq=4 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000082 (아트지 300g) / usage=USAGE.07(공통) dflt=N seq=5 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000089 (스노우지 180g) / usage=USAGE.07(공통) dflt=N seq=6 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000090 (스노우지 200g) / usage=USAGE.07(공통) dflt=N seq=7 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000091 (스노우지 250g) / usage=USAGE.07(공통) dflt=N seq=8 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000092 (스노우지 300g) / usage=USAGE.07(공통) dflt=N seq=9 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000097 (앙상블 160g) / usage=USAGE.07(공통) dflt=N seq=10 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000098 (앙상블 190g) / usage=USAGE.07(공통) dflt=N seq=11 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000099 (앙상블 210g) / usage=USAGE.07(공통) dflt=N seq=12 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000108 (몽블랑 210g) / usage=USAGE.07(공통) dflt=N seq=14 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000113 (아코팩(웜화이트) 250g) / usage=USAGE.07(공통) dflt=N seq=15 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000114 (리사이클러스 240g) / usage=USAGE.07(공통) dflt=N seq=16 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000115 (매쉬멜로우 233g) / usage=USAGE.07(공통) dflt=N seq=17 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000116 (린넨커버 216g) / usage=USAGE.07(공통) dflt=N seq=18 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000118 (클래식 크래스트 스티플 270g) / usage=USAGE.07(공통) dflt=N seq=19 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000119 (리브스디자인 250g) / usage=USAGE.07(공통) dflt=N seq=20 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000123 (띤또레또 200g) / usage=USAGE.07(공통) dflt=N seq=21 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000127 (스타드림(다이아몬드) 240g) / usage=USAGE.07(공통) dflt=N seq=22 — 상품-자재 링크 라이브 미존재(적재 대기)
- [라이브] MAT_000107 (몽블랑 190g) / usage=USAGE.07(공통) dflt=Y (델타 외 라이브 기존)
- [라이브] MAT_000253 (링 블랙) / usage=USAGE.07(공통) dflt=Y (델타 외 라이브 기존)
#### 6. 공정 (t_prd_product_processes) — round-5 델타 MERGE
- [라이브] PROC_000021 (트윈링제본) mand=N seq=1
- [라이브] PROC_000079 (타공) mand=N seq=1
#### 7. 묶음수 (t_prd_product_bundle_qtys) — round-5 델타 MERGE
- (없음 — 라이브·델타·차단 모두 0)
#### 8. 페이지룰 (t_prd_product_page_rules)
- (없음 — 라이브·델타·차단 모두 0)
#### 9. 추가상품 (t_prd_product_addons)
- (없음 — 라이브·델타·차단 모두 0)

### PRD_000122 — 접착투명포스터

**요약:** 카테고리 1 · 사이즈 3 · 도수 **0/0** · 판형 3 · 자재 1 · 공정 0 (+R5 1) · 묶음 **0/0** · 페이지룰 **0/0** · 추가상품 **0/0**

#### 1. 카테고리 (t_prd_product_categories)
- [라이브] CAT_000298 (실사) main=Y seq=1
#### 2. 사이즈 (t_prd_product_sizes)
- [라이브] SIZ_000174 (A3(297x420mm)) dflt=Y
- [라이브] SIZ_000197 (A2(420x594mm)) dflt=Y
- [라이브] SIZ_000293 (A1(594x841mm)) dflt=Y
#### 3. 도수/인쇄옵션 (t_prd_product_print_options)
- (없음 — 라이브·델타·차단 모두 0)
#### 4. 판형 (t_prd_product_plate_sizes)
- [라이브] SIZ_000052 (297x420) dflt_plt=Y 출력지=- 파일=PDF
- [라이브] SIZ_000198 (420x594) dflt_plt=Y 출력지=- 파일=PDF
- [라이브] SIZ_000294 (594x841) dflt_plt=Y 출력지=- 파일=PDF
#### 5. 자재 (t_prd_product_materials) — round-5 델타 MERGE
- [라이브] MAT_000180 (투명PVC) / usage=USAGE.07(공통) dflt=Y (델타 외 라이브 기존)
#### 6. 공정 (t_prd_product_processes) — round-5 델타 MERGE
- [+R5] PROC_000008 (화이트) mand=N seq=10 — 상품-공정 링크 라이브 미존재(적재 대기)
#### 7. 묶음수 (t_prd_product_bundle_qtys) — round-5 델타 MERGE
- (없음 — 라이브·델타·차단 모두 0)
#### 8. 페이지룰 (t_prd_product_page_rules)
- (없음 — 라이브·델타·차단 모두 0)
#### 9. 추가상품 (t_prd_product_addons)
- (없음 — 라이브·델타·차단 모두 0)
#### + 가격공식 (t_prd_product_price_formulas)
- [+R5] PRF_POSTER_FIXED — 라이브 미존재(적재 대기). 접착투명포스터(투명PVC)→소재/사이즈/수량 완제품가(포함항목 통가격)

### PRD_000146 — 아크릴키링

**요약:** 카테고리 1 · 사이즈 8 · 도수 3 (차단 1) · 판형 8 · 자재 1 (+R5 2) · 공정 0 (+R5 1 / 차단 1) · 묶음 **0/0** · 페이지룰 **0/0** · 추가상품 1

#### 1. 카테고리 (t_prd_product_categories)
- [라이브] CAT_000299 (단품형) main=Y seq=1
#### 2. 사이즈 (t_prd_product_sizes)
- [라이브] SIZ_000011 (50x50) dflt=Y
- [라이브] SIZ_000329 (20x30) dflt=Y
- [라이브] SIZ_000330 (30x30) dflt=Y
- [라이브] SIZ_000331 (30x40) dflt=Y
- [라이브] SIZ_000332 (30x70) dflt=Y
- [라이브] SIZ_000333 (40x40) dflt=Y
- [라이브] SIZ_000334 (40x50) dflt=Y
- [라이브] SIZ_000335 (40x60) dflt=Y
#### 3. 도수/인쇄옵션 (t_prd_product_print_options)
- [라이브] opt=1 side=배면양면 앞=CLR_000005(CMYK 4도) 뒤=CLR_000005(CMYK 4도) dflt=Y
- [라이브] opt=2 side=풀빼다 앞=CLR_000005(CMYK 4도) 뒤=CLR_000001(인쇄 안 함) dflt=N
- [라이브] opt=3 side=투명테두리 앞=CLR_000005(CMYK 4도) 뒤=CLR_000001(인쇄 안 함) dflt=N
- [차단] UV변형 정정(BLOCKED-25, update-set uv) — 라이브 print_side 정정/PROC 이동 미실행(비실행 차단)
#### 4. 판형 (t_prd_product_plate_sizes)
- [라이브] SIZ_000011 (50x50) dflt_plt=Y 출력지=- 파일=-
- [라이브] SIZ_000329 (20x30) dflt_plt=Y 출력지=- 파일=PDF
- [라이브] SIZ_000330 (30x30) dflt_plt=Y 출력지=- 파일=*AI(칼선)
- [라이브] SIZ_000331 (30x40) dflt_plt=Y 출력지=- 파일=-
- [라이브] SIZ_000332 (30x70) dflt_plt=Y 출력지=- 파일=-
- [라이브] SIZ_000333 (40x40) dflt_plt=Y 출력지=- 파일=-
- [라이브] SIZ_000334 (40x50) dflt_plt=Y 출력지=- 파일=-
- [라이브] SIZ_000335 (40x60) dflt_plt=Y 출력지=- 파일=-
#### 5. 자재 (t_prd_product_materials) — round-5 델타 MERGE
- [+R5] MAT_000051 (아크릴부속 은색고리) / usage=USAGE.07(공통) dflt=N seq=11 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000052 (아크릴부속 금색고리) / usage=USAGE.07(공통) dflt=N seq=12 — 상품-자재 링크 라이브 미존재(적재 대기)
- [라이브] MAT_000192 (투명아크릴) / usage=USAGE.07(공통) dflt=Y (델타 외 라이브 기존)
#### 6. 공정 (t_prd_product_processes) — round-5 델타 MERGE
- [+R5] PROC_000002 (UV) mand=Y seq=5 — 상품-공정 링크 라이브 미존재(적재 대기)
- [차단] PROC_000084 (레이저커팅) 완칼 — 코드행 선적재 의존 (레이저커팅 proc_cd 라이브 부재, 후니 등록 대기)
#### 7. 묶음수 (t_prd_product_bundle_qtys) — round-5 델타 MERGE
- (없음 — 라이브·델타·차단 모두 0)
#### 8. 페이지룰 (t_prd_product_page_rules)
- (없음 — 라이브·델타·차단 모두 0)
#### 9. 추가상품 (t_prd_product_addons)
- [라이브] TMPL-PRD_000006 → PRD_000006 (볼체인) seq=1

### PRD_000147 — 아크릴마그넷

**요약:** 카테고리 1 · 사이즈 7 · 도수 3 (차단 1) · 판형 7 · 자재 1 · 공정 0 (+R5 2 / 차단 1) · 묶음 **0/0** · 페이지룰 **0/0** · 추가상품 **0/0**

#### 1. 카테고리 (t_prd_product_categories)
- [라이브] CAT_000299 (단품형) main=Y seq=1
#### 2. 사이즈 (t_prd_product_sizes)
- [라이브] SIZ_000011 (50x50) dflt=Y
- [라이브] SIZ_000148 (60x60) dflt=Y
- [라이브] SIZ_000330 (30x30) dflt=Y
- [라이브] SIZ_000331 (30x40) dflt=Y
- [라이브] SIZ_000333 (40x40) dflt=Y
- [라이브] SIZ_000334 (40x50) dflt=Y
- [라이브] SIZ_000336 (20x20) dflt=Y
#### 3. 도수/인쇄옵션 (t_prd_product_print_options)
- [라이브] opt=1 side=배면양면 앞=CLR_000005(CMYK 4도) 뒤=CLR_000005(CMYK 4도) dflt=Y
- [라이브] opt=2 side=풀빼다 앞=CLR_000005(CMYK 4도) 뒤=CLR_000001(인쇄 안 함) dflt=N
- [라이브] opt=3 side=투명테두리 앞=CLR_000005(CMYK 4도) 뒤=CLR_000001(인쇄 안 함) dflt=N
- [차단] UV변형 정정(BLOCKED-25, update-set uv) — 라이브 print_side 정정/PROC 이동 미실행(비실행 차단)
#### 4. 판형 (t_prd_product_plate_sizes)
- [라이브] SIZ_000337 (24x24) dflt_plt=Y 출력지=- 파일=PDF
- [라이브] SIZ_000338 (34x34) dflt_plt=Y 출력지=- 파일=*AI(칼선)
- [라이브] SIZ_000339 (34x44) dflt_plt=Y 출력지=- 파일=-
- [라이브] SIZ_000340 (44x44) dflt_plt=Y 출력지=- 파일=-
- [라이브] SIZ_000341 (44x54) dflt_plt=Y 출력지=- 파일=-
- [라이브] SIZ_000342 (54x54) dflt_plt=Y 출력지=- 파일=-
- [라이브] SIZ_000343 (64x64) dflt_plt=Y 출력지=- 파일=-
#### 5. 자재 (t_prd_product_materials) — round-5 델타 MERGE
- [라이브] MAT_000192 (투명아크릴) / usage=USAGE.07(공통) dflt=Y (델타 외 라이브 기존)
#### 6. 공정 (t_prd_product_processes) — round-5 델타 MERGE
- [+R5] PROC_000002 (UV) mand=Y seq=5 — 상품-공정 링크 라이브 미존재(적재 대기)
- [+R5] PROC_000081 (부착) mand=N seq=19 — 상품-공정 링크 라이브 미존재(적재 대기)
- [차단] PROC_000084 (레이저커팅) 완칼 — 코드행 선적재 의존 (레이저커팅 proc_cd 라이브 부재, 후니 등록 대기)
#### 7. 묶음수 (t_prd_product_bundle_qtys) — round-5 델타 MERGE
- (없음 — 라이브·델타·차단 모두 0)
#### 8. 페이지룰 (t_prd_product_page_rules)
- (없음 — 라이브·델타·차단 모두 0)
#### 9. 추가상품 (t_prd_product_addons)
- (없음 — 라이브·델타·차단 모두 0)

### PRD_000148 — 아크릴뱃지

**요약:** 카테고리 1 · 사이즈 3 · 도수 3 (차단 1) · 판형 3 · 자재 1 (+R5 2) · 공정 0 (+R5 1 / 차단 1) · 묶음 **0/0** · 페이지룰 **0/0** · 추가상품 **0/0**

#### 1. 카테고리 (t_prd_product_categories)
- [라이브] CAT_000299 (단품형) main=Y seq=1
#### 2. 사이즈 (t_prd_product_sizes)
- [라이브] SIZ_000011 (50x50) dflt=Y
- [라이브] SIZ_000330 (30x30) dflt=Y
- [라이브] SIZ_000333 (40x40) dflt=Y
#### 3. 도수/인쇄옵션 (t_prd_product_print_options)
- [라이브] opt=1 side=배면양면 앞=CLR_000005(CMYK 4도) 뒤=CLR_000005(CMYK 4도) dflt=Y
- [라이브] opt=2 side=풀빼다 앞=CLR_000005(CMYK 4도) 뒤=CLR_000001(인쇄 안 함) dflt=N
- [라이브] opt=3 side=투명테두리 앞=CLR_000005(CMYK 4도) 뒤=CLR_000001(인쇄 안 함) dflt=N
- [차단] UV변형 정정(BLOCKED-25, update-set uv) — 라이브 print_side 정정/PROC 이동 미실행(비실행 차단)
#### 4. 판형 (t_prd_product_plate_sizes)
- [라이브] SIZ_000338 (34x34) dflt_plt=Y 출력지=- 파일=PDF
- [라이브] SIZ_000340 (44x44) dflt_plt=Y 출력지=- 파일=*AI(칼선)
- [라이브] SIZ_000342 (54x54) dflt_plt=Y 출력지=- 파일=-
#### 5. 자재 (t_prd_product_materials) — round-5 델타 MERGE
- [+R5] MAT_000047 (아크릴부속 원형핀) / usage=USAGE.07(공통) dflt=N seq=11 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000048 (아크릴부속 1구자석) / usage=USAGE.07(공통) dflt=N seq=12 — 상품-자재 링크 라이브 미존재(적재 대기)
- [라이브] MAT_000192 (투명아크릴) / usage=USAGE.07(공통) dflt=Y (델타 외 라이브 기존)
#### 6. 공정 (t_prd_product_processes) — round-5 델타 MERGE
- [+R5] PROC_000002 (UV) mand=Y seq=5 — 상품-공정 링크 라이브 미존재(적재 대기)
- [차단] PROC_000084 (레이저커팅) 완칼 — 코드행 선적재 의존 (레이저커팅 proc_cd 라이브 부재, 후니 등록 대기)
#### 7. 묶음수 (t_prd_product_bundle_qtys) — round-5 델타 MERGE
- (없음 — 라이브·델타·차단 모두 0)
#### 8. 페이지룰 (t_prd_product_page_rules)
- (없음 — 라이브·델타·차단 모두 0)
#### 9. 추가상품 (t_prd_product_addons)
- (없음 — 라이브·델타·차단 모두 0)

### PRD_000149 — 아크릴집게

**요약:** 카테고리 1 · 사이즈 3 · 도수 3 (차단 1) · 판형 3 · 자재 1 (+R5 1) · 공정 0 (+R5 1 / 차단 1) · 묶음 **0/0** · 페이지룰 **0/0** · 추가상품 **0/0**

#### 1. 카테고리 (t_prd_product_categories)
- [라이브] CAT_000299 (단품형) main=Y seq=1
#### 2. 사이즈 (t_prd_product_sizes)
- [라이브] SIZ_000011 (50x50) dflt=Y
- [라이브] SIZ_000330 (30x30) dflt=Y
- [라이브] SIZ_000333 (40x40) dflt=Y
#### 3. 도수/인쇄옵션 (t_prd_product_print_options)
- [라이브] opt=1 side=배면양면 앞=CLR_000005(CMYK 4도) 뒤=CLR_000005(CMYK 4도) dflt=Y
- [라이브] opt=2 side=풀빼다 앞=CLR_000005(CMYK 4도) 뒤=CLR_000001(인쇄 안 함) dflt=N
- [라이브] opt=3 side=투명테두리 앞=CLR_000005(CMYK 4도) 뒤=CLR_000001(인쇄 안 함) dflt=N
- [차단] UV변형 정정(BLOCKED-25, update-set uv) — 라이브 print_side 정정/PROC 이동 미실행(비실행 차단)
#### 4. 판형 (t_prd_product_plate_sizes)
- [라이브] SIZ_000338 (34x34) dflt_plt=Y 출력지=- 파일=PDF
- [라이브] SIZ_000340 (44x44) dflt_plt=Y 출력지=- 파일=*AI(칼선)
- [라이브] SIZ_000342 (54x54) dflt_plt=Y 출력지=- 파일=-
#### 5. 자재 (t_prd_product_materials) — round-5 델타 MERGE
- [+R5] MAT_000056 (아크릴부속 투명집게) / usage=USAGE.07(공통) dflt=N seq=11 — 상품-자재 링크 라이브 미존재(적재 대기)
- [라이브] MAT_000192 (투명아크릴) / usage=USAGE.07(공통) dflt=Y (델타 외 라이브 기존)
#### 6. 공정 (t_prd_product_processes) — round-5 델타 MERGE
- [+R5] PROC_000002 (UV) mand=Y seq=5 — 상품-공정 링크 라이브 미존재(적재 대기)
- [차단] PROC_000084 (레이저커팅) 완칼 — 코드행 선적재 의존 (레이저커팅 proc_cd 라이브 부재, 후니 등록 대기)
#### 7. 묶음수 (t_prd_product_bundle_qtys) — round-5 델타 MERGE
- (없음 — 라이브·델타·차단 모두 0)
#### 8. 페이지룰 (t_prd_product_page_rules)
- (없음 — 라이브·델타·차단 모두 0)
#### 9. 추가상품 (t_prd_product_addons)
- (없음 — 라이브·델타·차단 모두 0)

### PRD_000150 — 아크릴스마트톡

**요약:** 카테고리 1 · 사이즈 3 · 도수 3 (차단 1) · 판형 3 · 자재 1 (+R5 2) · 공정 0 (+R5 1 / 차단 1) · 묶음 **0/0** · 페이지룰 **0/0** · 추가상품 **0/0**

#### 1. 카테고리 (t_prd_product_categories)
- [라이브] CAT_000299 (단품형) main=Y seq=1
#### 2. 사이즈 (t_prd_product_sizes)
- [라이브] SIZ_000011 (50x50) dflt=Y
- [라이브] SIZ_000148 (60x60) dflt=Y
- [라이브] SIZ_000344 (70x60) dflt=Y
#### 3. 도수/인쇄옵션 (t_prd_product_print_options)
- [라이브] opt=1 side=배면양면 앞=CLR_000005(CMYK 4도) 뒤=CLR_000005(CMYK 4도) dflt=Y
- [라이브] opt=2 side=풀빼다 앞=CLR_000005(CMYK 4도) 뒤=CLR_000001(인쇄 안 함) dflt=N
- [라이브] opt=3 side=투명테두리 앞=CLR_000005(CMYK 4도) 뒤=CLR_000001(인쇄 안 함) dflt=N
- [차단] UV변형 정정(BLOCKED-25, update-set uv) — 라이브 print_side 정정/PROC 이동 미실행(비실행 차단)
#### 4. 판형 (t_prd_product_plate_sizes)
- [라이브] SIZ_000342 (54x54) dflt_plt=Y 출력지=- 파일=PDF
- [라이브] SIZ_000343 (64x64) dflt_plt=Y 출력지=- 파일=*AI(칼선)
- [라이브] SIZ_000345 (74x64) dflt_plt=Y 출력지=- 파일=-
#### 5. 자재 (t_prd_product_materials) — round-5 델타 MERGE
- [+R5] MAT_000054 (아크릴부속 화이트바디) / usage=USAGE.07(공통) dflt=N seq=11 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000053 (아크릴부속 투명바디) / usage=USAGE.07(공통) dflt=N seq=12 — 상품-자재 링크 라이브 미존재(적재 대기)
- [라이브] MAT_000192 (투명아크릴) / usage=USAGE.07(공통) dflt=Y (델타 외 라이브 기존)
#### 6. 공정 (t_prd_product_processes) — round-5 델타 MERGE
- [+R5] PROC_000002 (UV) mand=Y seq=5 — 상품-공정 링크 라이브 미존재(적재 대기)
- [차단] PROC_000084 (레이저커팅) 완칼 — 코드행 선적재 의존 (레이저커팅 proc_cd 라이브 부재, 후니 등록 대기)
#### 7. 묶음수 (t_prd_product_bundle_qtys) — round-5 델타 MERGE
- (없음 — 라이브·델타·차단 모두 0)
#### 8. 페이지룰 (t_prd_product_page_rules)
- (없음 — 라이브·델타·차단 모두 0)
#### 9. 추가상품 (t_prd_product_addons)
- (없음 — 라이브·델타·차단 모두 0)

### PRD_000151 — 맥세이프 스마트톡

**요약:** 카테고리 1 · 사이즈 3 · 도수 3 (차단 1) · 판형 3 · 자재 1 · 공정 1 (+R5 1 / 차단 1) · 묶음 **0/0** · 페이지룰 **0/0** · 추가상품 **0/0**

#### 1. 카테고리 (t_prd_product_categories)
- [라이브] CAT_000299 (단품형) main=Y seq=1
#### 2. 사이즈 (t_prd_product_sizes)
- [라이브] SIZ_000011 (50x50) dflt=Y
- [라이브] SIZ_000148 (60x60) dflt=Y
- [라이브] SIZ_000344 (70x60) dflt=Y
#### 3. 도수/인쇄옵션 (t_prd_product_print_options)
- [라이브] opt=1 side=배면양면 앞=CLR_000005(CMYK 4도) 뒤=CLR_000005(CMYK 4도) dflt=Y
- [라이브] opt=2 side=풀빼다 앞=CLR_000005(CMYK 4도) 뒤=CLR_000001(인쇄 안 함) dflt=N
- [라이브] opt=3 side=투명테두리 앞=CLR_000005(CMYK 4도) 뒤=CLR_000001(인쇄 안 함) dflt=N
- [차단] UV변형 정정(BLOCKED-25, update-set uv) — 라이브 print_side 정정/PROC 이동 미실행(비실행 차단)
#### 4. 판형 (t_prd_product_plate_sizes)
- [라이브] SIZ_000342 (54x54) dflt_plt=Y 출력지=- 파일=PDF
- [라이브] SIZ_000343 (64x64) dflt_plt=Y 출력지=- 파일=*AI(칼선)
- [라이브] SIZ_000345 (74x64) dflt_plt=Y 출력지=- 파일=-
#### 5. 자재 (t_prd_product_materials) — round-5 델타 MERGE
- [라이브] MAT_000192 (투명아크릴) / usage=USAGE.07(공통) dflt=Y (델타 외 라이브 기존)
#### 6. 공정 (t_prd_product_processes) — round-5 델타 MERGE
- [+R5] PROC_000002 (UV) mand=Y seq=5 — 상품-공정 링크 라이브 미존재(적재 대기)
- [라이브] PROC_000081 (부착) mand=N seq=1
- [차단] PROC_000084 (레이저커팅) 완칼 — 코드행 선적재 의존 (레이저커팅 proc_cd 라이브 부재, 후니 등록 대기)
#### 7. 묶음수 (t_prd_product_bundle_qtys) — round-5 델타 MERGE
- (없음 — 라이브·델타·차단 모두 0)
#### 8. 페이지룰 (t_prd_product_page_rules)
- (없음 — 라이브·델타·차단 모두 0)
#### 9. 추가상품 (t_prd_product_addons)
- (없음 — 라이브·델타·차단 모두 0)

### PRD_000152 — 아크릴명찰

**요약:** 카테고리 1 · 사이즈 3 · 도수 3 (차단 1) · 판형 3 · 자재 1 (+R5 2) · 공정 0 (+R5 1 / 차단 1) · 묶음 **0/0** · 페이지룰 **0/0** · 추가상품 **0/0**

#### 1. 카테고리 (t_prd_product_categories)
- [라이브] CAT_000299 (단품형) main=Y seq=1
#### 2. 사이즈 (t_prd_product_sizes)
- [라이브] SIZ_000346 (60x20) dflt=Y
- [라이브] SIZ_000348 (70x25) dflt=Y
- [라이브] SIZ_000350 (80x30) dflt=Y
#### 3. 도수/인쇄옵션 (t_prd_product_print_options)
- [라이브] opt=1 side=배면양면 앞=CLR_000005(CMYK 4도) 뒤=CLR_000005(CMYK 4도) dflt=Y
- [라이브] opt=2 side=풀빼다 앞=CLR_000005(CMYK 4도) 뒤=CLR_000001(인쇄 안 함) dflt=N
- [라이브] opt=3 side=투명테두리 앞=CLR_000005(CMYK 4도) 뒤=CLR_000001(인쇄 안 함) dflt=N
- [차단] UV변형 정정(BLOCKED-25, update-set uv) — 라이브 print_side 정정/PROC 이동 미실행(비실행 차단)
#### 4. 판형 (t_prd_product_plate_sizes)
- [라이브] SIZ_000347 (64x24) dflt_plt=Y 출력지=- 파일=PDF
- [라이브] SIZ_000349 (74x29) dflt_plt=Y 출력지=- 파일=*AI(칼선)
- [라이브] SIZ_000351 (84x34) dflt_plt=Y 출력지=- 파일=-
#### 5. 자재 (t_prd_product_materials) — round-5 델타 MERGE
- [+R5] MAT_000046 (아크릴부속 일자핀) / usage=USAGE.07(공통) dflt=N seq=11 — 상품-자재 링크 라이브 미존재(적재 대기)
- [+R5] MAT_000049 (아크릴부속 2구자석) / usage=USAGE.07(공통) dflt=N seq=12 — 상품-자재 링크 라이브 미존재(적재 대기)
- [라이브] MAT_000192 (투명아크릴) / usage=USAGE.07(공통) dflt=Y (델타 외 라이브 기존)
#### 6. 공정 (t_prd_product_processes) — round-5 델타 MERGE
- [+R5] PROC_000002 (UV) mand=Y seq=5 — 상품-공정 링크 라이브 미존재(적재 대기)
- [차단] PROC_000084 (레이저커팅) 완칼 — 코드행 선적재 의존 (레이저커팅 proc_cd 라이브 부재, 후니 등록 대기)
#### 7. 묶음수 (t_prd_product_bundle_qtys) — round-5 델타 MERGE
- (없음 — 라이브·델타·차단 모두 0)
#### 8. 페이지룰 (t_prd_product_page_rules)
- (없음 — 라이브·델타·차단 모두 0)
#### 9. 추가상품 (t_prd_product_addons)
- (없음 — 라이브·델타·차단 모두 0)

### PRD_000154 — 아크릴 머리끈

**요약:** 카테고리 1 · 사이즈 3 · 도수 **0/0** · 판형 3 · 자재 1 (+R5 1) · 공정 0 (차단 1) · 묶음 **0/0** · 페이지룰 **0/0** · 추가상품 **0/0**

#### 1. 카테고리 (t_prd_product_categories)
- [라이브] CAT_000299 (단품형) main=Y seq=1
#### 2. 사이즈 (t_prd_product_sizes)
- [라이브] SIZ_000330 (30x30) dflt=Y
- [라이브] SIZ_000333 (40x40) dflt=Y
- [라이브] SIZ_000336 (20x20) dflt=Y
#### 3. 도수/인쇄옵션 (t_prd_product_print_options)
- (없음 — 라이브·델타·차단 모두 0)
#### 4. 판형 (t_prd_product_plate_sizes)
- [라이브] SIZ_000337 (24x24) dflt_plt=Y 출력지=- 파일=PDF
- [라이브] SIZ_000338 (34x34) dflt_plt=Y 출력지=- 파일=*AI(칼선)
- [라이브] SIZ_000340 (44x44) dflt_plt=Y 출력지=- 파일=-
#### 5. 자재 (t_prd_product_materials) — round-5 델타 MERGE
- [+R5] MAT_000057 (아크릴부속 블랙헤어끈) / usage=USAGE.07(공통) dflt=N seq=11 — 상품-자재 링크 라이브 미존재(적재 대기)
- [라이브] MAT_000192 (투명아크릴) / usage=USAGE.07(공통) dflt=Y (델타 외 라이브 기존)
#### 6. 공정 (t_prd_product_processes) — round-5 델타 MERGE
- [차단] PROC_000084 (레이저커팅) 완칼 — 코드행 선적재 의존 (레이저커팅 proc_cd 라이브 부재, 후니 등록 대기)
#### 7. 묶음수 (t_prd_product_bundle_qtys) — round-5 델타 MERGE
- (없음 — 라이브·델타·차단 모두 0)
#### 8. 페이지룰 (t_prd_product_page_rules)
- (없음 — 라이브·델타·차단 모두 0)
#### 9. 추가상품 (t_prd_product_addons)
- (없음 — 라이브·델타·차단 모두 0)

### PRD_000155 — 아크릴볼펜

**요약:** 카테고리 1 · 사이즈 3 · 도수 3 (차단 1) · 판형 3 · 자재 1 · 공정 0 (+R5 1 / 차단 1) · 묶음 **0/0** · 페이지룰 **0/0** · 추가상품 **0/0**

#### 1. 카테고리 (t_prd_product_categories)
- [라이브] CAT_000299 (단품형) main=Y seq=1
#### 2. 사이즈 (t_prd_product_sizes)
- [라이브] SIZ_000330 (30x30) dflt=Y
- [라이브] SIZ_000333 (40x40) dflt=Y
- [라이브] SIZ_000336 (20x20) dflt=Y
#### 3. 도수/인쇄옵션 (t_prd_product_print_options)
- [라이브] opt=1 side=배면양면 앞=CLR_000005(CMYK 4도) 뒤=CLR_000005(CMYK 4도) dflt=Y
- [라이브] opt=2 side=풀빼다 앞=CLR_000005(CMYK 4도) 뒤=CLR_000001(인쇄 안 함) dflt=N
- [라이브] opt=3 side=투명테두리 앞=CLR_000005(CMYK 4도) 뒤=CLR_000001(인쇄 안 함) dflt=N
- [차단] UV변형 정정(BLOCKED-25, update-set uv) — 라이브 print_side 정정/PROC 이동 미실행(비실행 차단)
#### 4. 판형 (t_prd_product_plate_sizes)
- [라이브] SIZ_000337 (24x24) dflt_plt=Y 출력지=- 파일=PDF
- [라이브] SIZ_000338 (34x34) dflt_plt=Y 출력지=- 파일=*AI(칼선)
- [라이브] SIZ_000340 (44x44) dflt_plt=Y 출력지=- 파일=-
#### 5. 자재 (t_prd_product_materials) — round-5 델타 MERGE
- [라이브] MAT_000192 (투명아크릴) / usage=USAGE.07(공통) dflt=Y (델타 외 라이브 기존)
#### 6. 공정 (t_prd_product_processes) — round-5 델타 MERGE
- [+R5] PROC_000002 (UV) mand=Y seq=5 — 상품-공정 링크 라이브 미존재(적재 대기)
- [차단] PROC_000084 (레이저커팅) 완칼 — 코드행 선적재 의존 (레이저커팅 proc_cd 라이브 부재, 후니 등록 대기)
#### 7. 묶음수 (t_prd_product_bundle_qtys) — round-5 델타 MERGE
- (없음 — 라이브·델타·차단 모두 0)
#### 8. 페이지룰 (t_prd_product_page_rules)
- (없음 — 라이브·델타·차단 모두 0)
#### 9. 추가상품 (t_prd_product_addons)
- (없음 — 라이브·델타·차단 모두 0)

### PRD_000157 — 아크릴네임택

**요약:** 카테고리 1 · 사이즈 2 · 도수 3 (차단 1) · 판형 2 · 자재 1 · 공정 0 (+R5 1 / 차단 1) · 묶음 **0/0** · 페이지룰 **0/0** · 추가상품 **0/0**

#### 1. 카테고리 (t_prd_product_categories)
- [라이브] CAT_000299 (단품형) main=Y seq=1
#### 2. 사이즈 (t_prd_product_sizes)
- [라이브] SIZ_000012 (55x86) dflt=Y
- [라이브] SIZ_000148 (60x60) dflt=Y
#### 3. 도수/인쇄옵션 (t_prd_product_print_options)
- [라이브] opt=1 side=배면양면 앞=CLR_000005(CMYK 4도) 뒤=CLR_000005(CMYK 4도) dflt=Y
- [라이브] opt=2 side=풀빼다 앞=CLR_000005(CMYK 4도) 뒤=CLR_000001(인쇄 안 함) dflt=N
- [라이브] opt=3 side=투명테두리 앞=CLR_000005(CMYK 4도) 뒤=CLR_000001(인쇄 안 함) dflt=N
- [차단] UV변형 정정(BLOCKED-25, update-set uv) — 라이브 print_side 정정/PROC 이동 미실행(비실행 차단)
#### 4. 판형 (t_prd_product_plate_sizes)
- [라이브] SIZ_000012 (55x86) dflt_plt=Y 출력지=- 파일=*AI(칼선)
- [라이브] SIZ_000148 (60x60) dflt_plt=Y 출력지=- 파일=PDF
#### 5. 자재 (t_prd_product_materials) — round-5 델타 MERGE
- [라이브] MAT_000192 (투명아크릴) / usage=USAGE.07(공통) dflt=Y (델타 외 라이브 기존)
#### 6. 공정 (t_prd_product_processes) — round-5 델타 MERGE
- [+R5] PROC_000002 (UV) mand=Y seq=5 — 상품-공정 링크 라이브 미존재(적재 대기)
- [차단] PROC_000084 (레이저커팅) 완칼 — 코드행 선적재 의존 (레이저커팅 proc_cd 라이브 부재, 후니 등록 대기)
#### 7. 묶음수 (t_prd_product_bundle_qtys) — round-5 델타 MERGE
- (없음 — 라이브·델타·차단 모두 0)
#### 8. 페이지룰 (t_prd_product_page_rules)
- (없음 — 라이브·델타·차단 모두 0)
#### 9. 추가상품 (t_prd_product_addons)
- (없음 — 라이브·델타·차단 모두 0)

### PRD_000158 — 아크릴 포카키링

**요약:** 카테고리 1 · 사이즈 1 · 도수 3 (차단 1) · 판형 1 · 자재 1 · 공정 0 (+R5 1 / 차단 1) · 묶음 **0/0** · 페이지룰 **0/0** · 추가상품 1

#### 1. 카테고리 (t_prd_product_categories)
- [라이브] CAT_000299 (단품형) main=Y seq=1
#### 2. 사이즈 (t_prd_product_sizes)
- [라이브] SIZ_000012 (55x86) dflt=Y
#### 3. 도수/인쇄옵션 (t_prd_product_print_options)
- [라이브] opt=1 side=배면양면 앞=CLR_000005(CMYK 4도) 뒤=CLR_000005(CMYK 4도) dflt=Y
- [라이브] opt=2 side=풀빼다 앞=CLR_000005(CMYK 4도) 뒤=CLR_000001(인쇄 안 함) dflt=N
- [라이브] opt=3 side=투명테두리 앞=CLR_000005(CMYK 4도) 뒤=CLR_000001(인쇄 안 함) dflt=N
- [차단] UV변형 정정(BLOCKED-25, update-set uv) — 라이브 print_side 정정/PROC 이동 미실행(비실행 차단)
#### 4. 판형 (t_prd_product_plate_sizes)
- [라이브] SIZ_000012 (55x86) dflt_plt=Y 출력지=- 파일=PDF
#### 5. 자재 (t_prd_product_materials) — round-5 델타 MERGE
- [라이브] MAT_000192 (투명아크릴) / usage=USAGE.07(공통) dflt=Y (델타 외 라이브 기존)
#### 6. 공정 (t_prd_product_processes) — round-5 델타 MERGE
- [+R5] PROC_000002 (UV) mand=Y seq=5 — 상품-공정 링크 라이브 미존재(적재 대기)
- [차단] PROC_000084 (레이저커팅) 완칼 — 코드행 선적재 의존 (레이저커팅 proc_cd 라이브 부재, 후니 등록 대기)
#### 7. 묶음수 (t_prd_product_bundle_qtys) — round-5 델타 MERGE
- (없음 — 라이브·델타·차단 모두 0)
#### 8. 페이지룰 (t_prd_product_page_rules)
- (없음 — 라이브·델타·차단 모두 0)
#### 9. 추가상품 (t_prd_product_addons)
- [라이브] TMPL-PRD_000006 → PRD_000006 (볼체인) seq=1

### PRD_000160 — 아크릴자유형스탠드

**요약:** 카테고리 1 · 사이즈 5 · 도수 3 (차단 1) · 판형 5 · 자재 1 · 공정 0 (+R5 1 / 차단 1) · 묶음 0 (+R5 5) · 페이지룰 **0/0** · 추가상품 **0/0**

#### 1. 카테고리 (t_prd_product_categories)
- [라이브] CAT_000155 (조합형) main=Y seq=1
#### 2. 사이즈 (t_prd_product_sizes)
- [라이브] SIZ_000357 (120x60) dflt=Y
- [라이브] SIZ_000358 (120x90) dflt=Y
- [라이브] SIZ_000359 (120x120) dflt=Y
- [라이브] SIZ_000360 (120x150) dflt=Y
- [라이브] SIZ_000361 (120x180) dflt=Y
#### 3. 도수/인쇄옵션 (t_prd_product_print_options)
- [라이브] opt=1 side=배면양면 앞=CLR_000005(CMYK 4도) 뒤=CLR_000005(CMYK 4도) dflt=Y
- [라이브] opt=2 side=풀빼다 앞=CLR_000005(CMYK 4도) 뒤=CLR_000001(인쇄 안 함) dflt=N
- [라이브] opt=3 side=투명테두리 앞=CLR_000005(CMYK 4도) 뒤=CLR_000001(인쇄 안 함) dflt=N
- [차단] UV변형 정정(BLOCKED-25, update-set uv) — 라이브 print_side 정정/PROC 이동 미실행(비실행 차단)
#### 4. 판형 (t_prd_product_plate_sizes)
- [라이브] SIZ_000357 (120x60) dflt_plt=Y 출력지=- 파일=PDF
- [라이브] SIZ_000358 (120x90) dflt_plt=Y 출력지=- 파일=*AI(칼선)
- [라이브] SIZ_000359 (120x120) dflt_plt=Y 출력지=- 파일=-
- [라이브] SIZ_000360 (120x150) dflt_plt=Y 출력지=- 파일=-
- [라이브] SIZ_000361 (120x180) dflt_plt=Y 출력지=- 파일=-
#### 5. 자재 (t_prd_product_materials) — round-5 델타 MERGE
- [라이브] MAT_000192 (투명아크릴) / usage=USAGE.07(공통) dflt=Y (델타 외 라이브 기존)
#### 6. 공정 (t_prd_product_processes) — round-5 델타 MERGE
- [+R5] PROC_000002 (UV) mand=Y seq=5 — 상품-공정 링크 라이브 미존재(적재 대기)
- [차단] PROC_000084 (레이저커팅) 완칼 — 코드행 선적재 의존 (레이저커팅 proc_cd 라이브 부재, 후니 등록 대기)
#### 7. 묶음수 (t_prd_product_bundle_qtys) — round-5 델타 MERGE
- [+R5] bdl=2 unit=QTY_UNIT.01(EA) dflt=Y seq=1 — 라이브 미존재(적재 대기)
- [+R5] bdl=3 unit=QTY_UNIT.01(EA) dflt=N seq=2 — 라이브 미존재(적재 대기)
- [+R5] bdl=4 unit=QTY_UNIT.01(EA) dflt=N seq=3 — 라이브 미존재(적재 대기)
- [+R5] bdl=5 unit=QTY_UNIT.01(EA) dflt=N seq=4 — 라이브 미존재(적재 대기)
- [+R5] bdl=6 unit=QTY_UNIT.01(EA) dflt=N seq=5 — 라이브 미존재(적재 대기)
#### 8. 페이지룰 (t_prd_product_page_rules)
- (없음 — 라이브·델타·차단 모두 0)
#### 9. 추가상품 (t_prd_product_addons)
- (없음 — 라이브·델타·차단 모두 0)

### PRD_000161 — 판아크릴

**요약:** 카테고리 1 · 사이즈 2 · 도수 3 (차단 1) · 판형 2 · 자재 1 · 공정 0 (+R5 1) · 묶음 **0/0** · 페이지룰 **0/0** · 추가상품 **0/0**

#### 1. 카테고리 (t_prd_product_categories)
- [라이브] CAT_000155 (조합형) main=Y seq=1
#### 2. 사이즈 (t_prd_product_sizes)
- [라이브] SIZ_000359 (120x120) dflt=Y
- [라이브] SIZ_000361 (120x180) dflt=Y
#### 3. 도수/인쇄옵션 (t_prd_product_print_options)
- [라이브] opt=1 side=배면양면 앞=CLR_000005(CMYK 4도) 뒤=CLR_000005(CMYK 4도) dflt=Y
- [라이브] opt=2 side=풀빼다 앞=CLR_000005(CMYK 4도) 뒤=CLR_000001(인쇄 안 함) dflt=N
- [라이브] opt=3 side=투명테두리 앞=CLR_000005(CMYK 4도) 뒤=CLR_000001(인쇄 안 함) dflt=N
- [차단] UV변형 정정(BLOCKED-25, update-set uv) — 라이브 print_side 정정/PROC 이동 미실행(비실행 차단)
#### 4. 판형 (t_prd_product_plate_sizes)
- [라이브] SIZ_000362 (124x124) dflt_plt=Y 출력지=- 파일=PDF
- [라이브] SIZ_000363 (124x184) dflt_plt=Y 출력지=- 파일=*AI(칼선)
#### 5. 자재 (t_prd_product_materials) — round-5 델타 MERGE
- [라이브] MAT_000192 (투명아크릴) / usage=USAGE.07(공통) dflt=Y (델타 외 라이브 기존)
#### 6. 공정 (t_prd_product_processes) — round-5 델타 MERGE
- [+R5] PROC_000002 (UV) mand=Y seq=5 — 상품-공정 링크 라이브 미존재(적재 대기)
#### 7. 묶음수 (t_prd_product_bundle_qtys) — round-5 델타 MERGE
- (없음 — 라이브·델타·차단 모두 0)
#### 8. 페이지룰 (t_prd_product_page_rules)
- (없음 — 라이브·델타·차단 모두 0)
#### 9. 추가상품 (t_prd_product_addons)
- (없음 — 라이브·델타·차단 모두 0)

### PRD_000162 — 아크릴포카스탠드

**요약:** 카테고리 1 · 사이즈 1 · 도수 3 (차단 1) · 판형 **0/0** · 자재 1 · 공정 0 (+R5 1 / 차단 1) · 묶음 **0/0** · 페이지룰 **0/0** · 추가상품 **0/0**

#### 1. 카테고리 (t_prd_product_categories)
- [라이브] CAT_000155 (조합형) main=Y seq=1
#### 2. 사이즈 (t_prd_product_sizes)
- [라이브] SIZ_000364 (68x103) dflt=Y
#### 3. 도수/인쇄옵션 (t_prd_product_print_options)
- [라이브] opt=1 side=배면양면 앞=CLR_000005(CMYK 4도) 뒤=CLR_000005(CMYK 4도) dflt=Y
- [라이브] opt=2 side=풀빼다 앞=CLR_000005(CMYK 4도) 뒤=CLR_000001(인쇄 안 함) dflt=N
- [라이브] opt=3 side=투명테두리 앞=CLR_000005(CMYK 4도) 뒤=CLR_000001(인쇄 안 함) dflt=N
- [차단] UV변형 정정(BLOCKED-25, update-set uv) — 라이브 print_side 정정/PROC 이동 미실행(비실행 차단)
#### 4. 판형 (t_prd_product_plate_sizes)
- (없음 — 라이브·델타·차단 모두 0)
#### 5. 자재 (t_prd_product_materials) — round-5 델타 MERGE
- [라이브] MAT_000192 (투명아크릴) / usage=USAGE.07(공통) dflt=Y (델타 외 라이브 기존)
#### 6. 공정 (t_prd_product_processes) — round-5 델타 MERGE
- [+R5] PROC_000002 (UV) mand=Y seq=5 — 상품-공정 링크 라이브 미존재(적재 대기)
- [차단] PROC_000084 (레이저커팅) 완칼 — 코드행 선적재 의존 (레이저커팅 proc_cd 라이브 부재, 후니 등록 대기)
#### 7. 묶음수 (t_prd_product_bundle_qtys) — round-5 델타 MERGE
- (없음 — 라이브·델타·차단 모두 0)
#### 8. 페이지룰 (t_prd_product_page_rules)
- (없음 — 라이브·델타·차단 모두 0)
#### 9. 추가상품 (t_prd_product_addons)
- (없음 — 라이브·델타·차단 모두 0)

### PRD_000163 — 아크릴미니파츠

**요약:** 카테고리 1 · 사이즈 1 · 도수 3 (차단 1) · 판형 1 · 자재 1 · 공정 0 (+R5 1 / 차단 1) · 묶음 0 (+R5 1) · 페이지룰 **0/0** · 추가상품 **0/0**

#### 1. 카테고리 (t_prd_product_categories)
- [라이브] CAT_000155 (조합형) main=Y seq=1
#### 2. 사이즈 (t_prd_product_sizes)
- [라이브] SIZ_000365 (120x50) dflt=Y
#### 3. 도수/인쇄옵션 (t_prd_product_print_options)
- [라이브] opt=1 side=배면양면 앞=CLR_000005(CMYK 4도) 뒤=CLR_000005(CMYK 4도) dflt=Y
- [라이브] opt=2 side=풀빼다 앞=CLR_000005(CMYK 4도) 뒤=CLR_000001(인쇄 안 함) dflt=N
- [라이브] opt=3 side=투명테두리 앞=CLR_000005(CMYK 4도) 뒤=CLR_000001(인쇄 안 함) dflt=N
- [차단] UV변형 정정(BLOCKED-25, update-set uv) — 라이브 print_side 정정/PROC 이동 미실행(비실행 차단)
#### 4. 판형 (t_prd_product_plate_sizes)
- [라이브] SIZ_000365 (120x50) dflt_plt=Y 출력지=- 파일=PDF
#### 5. 자재 (t_prd_product_materials) — round-5 델타 MERGE
- [라이브] MAT_000192 (투명아크릴) / usage=USAGE.07(공통) dflt=Y (델타 외 라이브 기존)
#### 6. 공정 (t_prd_product_processes) — round-5 델타 MERGE
- [+R5] PROC_000002 (UV) mand=Y seq=5 — 상품-공정 링크 라이브 미존재(적재 대기)
- [차단] PROC_000084 (레이저커팅) 완칼 — 코드행 선적재 의존 (레이저커팅 proc_cd 라이브 부재, 후니 등록 대기)
#### 7. 묶음수 (t_prd_product_bundle_qtys) — round-5 델타 MERGE
- [+R5] bdl=10 unit=QTY_UNIT.01(EA) dflt=Y seq=1 — 라이브 미존재(적재 대기)
#### 8. 페이지룰 (t_prd_product_page_rules)
- (없음 — 라이브·델타·차단 모두 0)
#### 9. 추가상품 (t_prd_product_addons)
- (없음 — 라이브·델타·차단 모두 0)

### PRD_000172 — 만년다이어리(소프트커버)

**요약:** 카테고리 1 · 사이즈 1 · 도수 1 · 판형 1 · 자재 1 · 공정 0 (+R5 1) · 묶음 **0/0** · 페이지룰 **0/0** · 추가상품 **0/0**

#### 1. 카테고리 (t_prd_product_categories)
- [라이브] CAT_000300 (플래너) main=Y seq=1
#### 2. 사이즈 (t_prd_product_sizes)
- [라이브] SIZ_000375 (130x190) dflt=Y
#### 3. 도수/인쇄옵션 (t_prd_product_print_options)
- [라이브] opt=1 side=단면 앞=CLR_000005(CMYK 4도) 뒤=CLR_000001(인쇄 안 함) dflt=Y
#### 4. 판형 (t_prd_product_plate_sizes)
- [라이브] SIZ_000251 (300x214) dflt_plt=Y 출력지=- 파일=-
#### 5. 자재 (t_prd_product_materials) — round-5 델타 MERGE
- [라이브] MAT_000260 (아트250 + 무광코팅) / usage=USAGE.02(표지) dflt=Y (델타 외 라이브 기존)
#### 6. 공정 (t_prd_product_processes) — round-5 델타 MERGE
- [+R5] PROC_000015 (무광) mand=N seq=5 — 상품-공정 링크 라이브 미존재(적재 대기)
#### 7. 묶음수 (t_prd_product_bundle_qtys) — round-5 델타 MERGE
- (없음 — 라이브·델타·차단 모두 0)
#### 8. 페이지룰 (t_prd_product_page_rules)
- (없음 — 라이브·델타·차단 모두 0)
#### 9. 추가상품 (t_prd_product_addons)
- (없음 — 라이브·델타·차단 모두 0)

### PRD_000173 — 만년다이어리(하드커버)

**요약:** 카테고리 1 · 사이즈 1 · 도수 **0/0** · 판형 1 · 자재 1 · 공정 1 (+R5 2) · 묶음 **0/0** · 페이지룰 **0/0** · 추가상품 **0/0**

#### 1. 카테고리 (t_prd_product_categories)
- [라이브] CAT_000300 (플래너) main=Y seq=1
#### 2. 사이즈 (t_prd_product_sizes)
- [라이브] SIZ_000375 (130x190) dflt=Y
#### 3. 도수/인쇄옵션 (t_prd_product_print_options)
- (없음 — 라이브·델타·차단 모두 0)
#### 4. 판형 (t_prd_product_plate_sizes)
- [라이브] SIZ_000181 (426x303) dflt_plt=Y 출력지=- 파일=-
#### 5. 자재 (t_prd_product_materials) — round-5 델타 MERGE
- [라이브] MAT_000260 (아트250 + 무광코팅) / usage=USAGE.02(표지) dflt=Y (델타 외 라이브 기존)
#### 6. 공정 (t_prd_product_processes) — round-5 델타 MERGE
- [+R5] PROC_000023 (하드커버무선제본) mand=Y seq=1 — 상품-공정 링크 라이브 미존재(적재 대기)
- [+R5] PROC_000015 (무광) mand=N seq=5 — 상품-공정 링크 라이브 미존재(적재 대기)
- [라이브] PROC_000076 (수축포장) mand=N seq=1
#### 7. 묶음수 (t_prd_product_bundle_qtys) — round-5 델타 MERGE
- (없음 — 라이브·델타·차단 모두 0)
#### 8. 페이지룰 (t_prd_product_page_rules)
- (없음 — 라이브·델타·차단 모두 0)
#### 9. 추가상품 (t_prd_product_addons)
- (없음 — 라이브·델타·차단 모두 0)

### PRD_000174 — 만년다이어리(레더하드커버)

**요약:** 카테고리 1 · 사이즈 1 · 도수 **0/0** · 판형 **0/0** · 자재 1 · 공정 0 (+R5 1) · 묶음 **0/0** · 페이지룰 **0/0** · 추가상품 **0/0**

#### 1. 카테고리 (t_prd_product_categories)
- [라이브] CAT_000300 (플래너) main=Y seq=1
#### 2. 사이즈 (t_prd_product_sizes)
- [라이브] SIZ_000375 (130x190) dflt=Y
#### 3. 도수/인쇄옵션 (t_prd_product_print_options)
- (없음 — 라이브·델타·차단 모두 0)
#### 4. 판형 (t_prd_product_plate_sizes)
- (없음 — 라이브·델타·차단 모두 0)
#### 5. 자재 (t_prd_product_materials) — round-5 델타 MERGE
- [라이브] MAT_000186 (레더(화이트)) / usage=USAGE.02(표지) dflt=Y (델타 외 라이브 기존)
#### 6. 공정 (t_prd_product_processes) — round-5 델타 MERGE
- [+R5] PROC_000023 (하드커버무선제본) mand=Y seq=1 — 상품-공정 링크 라이브 미존재(적재 대기)
#### 7. 묶음수 (t_prd_product_bundle_qtys) — round-5 델타 MERGE
- (없음 — 라이브·델타·차단 모두 0)
#### 8. 페이지룰 (t_prd_product_page_rules)
- (없음 — 라이브·델타·차단 모두 0)
#### 9. 추가상품 (t_prd_product_addons)
- (없음 — 라이브·델타·차단 모두 0)

### PRD_000176 — 먼슬리플래너

**요약:** 카테고리 1 · 사이즈 1 · 도수 2 · 판형 2 · 자재 2 · 공정 0 (+R5 1) · 묶음 **0/0** · 페이지룰 1 · 추가상품 **0/0**

#### 1. 카테고리 (t_prd_product_categories)
- [라이브] CAT_000300 (플래너) main=Y seq=1
#### 2. 사이즈 (t_prd_product_sizes)
- [라이브] SIZ_000170 (A5(148x210mm)) dflt=Y
#### 3. 도수/인쇄옵션 (t_prd_product_print_options)
- [라이브] opt=1 side=양면 앞=CLR_000005(CMYK 4도) 뒤=CLR_000005(CMYK 4도) dflt=Y
- [라이브] opt=2 side=단면 앞=CLR_000005(CMYK 4도) 뒤=CLR_000001(인쇄 안 함) dflt=Y
#### 4. 판형 (t_prd_product_plate_sizes)
- [라이브] SIZ_000180 (302x216) dflt_plt=Y 출력지=- 파일=PDF
- [라이브] SIZ_000376 (150x216) dflt_plt=Y 출력지=- 파일=PDF
#### 5. 자재 (t_prd_product_materials) — round-5 델타 MERGE
- [라이브] MAT_000072 (백색모조지 100g) / usage=USAGE.07(공통) dflt=Y (델타 외 라이브 기존)
- [라이브] MAT_000260 (아트250 + 무광코팅) / usage=USAGE.02(표지) dflt=Y (델타 외 라이브 기존)
#### 6. 공정 (t_prd_product_processes) — round-5 델타 MERGE
- [+R5] PROC_000015 (무광) mand=N seq=5 — 상품-공정 링크 라이브 미존재(적재 대기)
#### 7. 묶음수 (t_prd_product_bundle_qtys) — round-5 델타 MERGE
- (없음 — 라이브·델타·차단 모두 0)
#### 8. 페이지룰 (t_prd_product_page_rules)
- [라이브] min=28 max=28 incr=0
#### 9. 추가상품 (t_prd_product_addons)
- (없음 — 라이브·델타·차단 모두 0)

### PRD_000177 — 스프링노트

**요약:** 카테고리 1 · 사이즈 1 · 도수 1 · 판형 1 · 자재 3 · 공정 1 (+R5 2) · 묶음 **0/0** · 페이지룰 **0/0** · 추가상품 **0/0**

#### 1. 카테고리 (t_prd_product_categories)
- [라이브] CAT_000124 (노트) main=Y seq=1
#### 2. 사이즈 (t_prd_product_sizes)
- [라이브] SIZ_000170 (A5(148x210mm)) dflt=Y
#### 3. 도수/인쇄옵션 (t_prd_product_print_options)
- [라이브] opt=1 side=단면 앞=CLR_000005(CMYK 4도) 뒤=CLR_000001(인쇄 안 함) dflt=Y
#### 4. 판형 (t_prd_product_plate_sizes)
- [라이브] SIZ_000171 (152x214) dflt_plt=Y 출력지=- 파일=-
#### 5. 자재 (t_prd_product_materials) — round-5 델타 MERGE
- [라이브] MAT_000072 (백색모조지 100g) / usage=USAGE.07(공통) dflt=Y (델타 외 라이브 기존)
- [라이브] MAT_000260 (아트250 + 무광코팅) / usage=USAGE.02(표지) dflt=Y (델타 외 라이브 기존)
- [라이브] MAT_000261 (무지내지) / usage=USAGE.01(내지) dflt=Y (델타 외 라이브 기존)
#### 6. 공정 (t_prd_product_processes) — round-5 델타 MERGE
- [+R5] PROC_000021 (트윈링제본) mand=Y seq=1 — 상품-공정 링크 라이브 미존재(적재 대기)
- [+R5] PROC_000015 (무광) mand=N seq=5 — 상품-공정 링크 라이브 미존재(적재 대기)
- [라이브] PROC_000076 (수축포장) mand=N seq=1
#### 7. 묶음수 (t_prd_product_bundle_qtys) — round-5 델타 MERGE
- (없음 — 라이브·델타·차단 모두 0)
#### 8. 페이지룰 (t_prd_product_page_rules)
- (없음 — 라이브·델타·차단 모두 0)
#### 9. 추가상품 (t_prd_product_addons)
- (없음 — 라이브·델타·차단 모두 0)

### PRD_000178 — 스프링수첩

**요약:** 카테고리 1 · 사이즈 1 · 도수 1 · 판형 1 · 자재 3 · 공정 0 (+R5 2) · 묶음 **0/0** · 페이지룰 **0/0** · 추가상품 **0/0**

#### 1. 카테고리 (t_prd_product_categories)
- [라이브] CAT_000124 (노트) main=Y seq=1
#### 2. 사이즈 (t_prd_product_sizes)
- [라이브] SIZ_000377 (90x145) dflt=Y
#### 3. 도수/인쇄옵션 (t_prd_product_print_options)
- [라이브] opt=1 side=단면 앞=CLR_000005(CMYK 4도) 뒤=CLR_000001(인쇄 안 함) dflt=Y
#### 4. 판형 (t_prd_product_plate_sizes)
- [라이브] SIZ_000378 (94x149) dflt_plt=Y 출력지=- 파일=-
#### 5. 자재 (t_prd_product_materials) — round-5 델타 MERGE
- [라이브] MAT_000072 (백색모조지 100g) / usage=USAGE.07(공통) dflt=Y (델타 외 라이브 기존)
- [라이브] MAT_000260 (아트250 + 무광코팅) / usage=USAGE.02(표지) dflt=Y (델타 외 라이브 기존)
- [라이브] MAT_000261 (무지내지) / usage=USAGE.01(내지) dflt=Y (델타 외 라이브 기존)
#### 6. 공정 (t_prd_product_processes) — round-5 델타 MERGE
- [+R5] PROC_000021 (트윈링제본) mand=Y seq=1 — 상품-공정 링크 라이브 미존재(적재 대기)
- [+R5] PROC_000015 (무광) mand=N seq=5 — 상품-공정 링크 라이브 미존재(적재 대기)
#### 7. 묶음수 (t_prd_product_bundle_qtys) — round-5 델타 MERGE
- (없음 — 라이브·델타·차단 모두 0)
#### 8. 페이지룰 (t_prd_product_page_rules)
- (없음 — 라이브·델타·차단 모두 0)
#### 9. 추가상품 (t_prd_product_addons)
- (없음 — 라이브·델타·차단 모두 0)

### PRD_000179 — 메모패드

**요약:** 카테고리 1 · 사이즈 2 · 도수 1 · 판형 2 · 자재 3 · 공정 0 (+R5 2) · 묶음 **0/0** · 페이지룰 **0/0** · 추가상품 **0/0**

#### 1. 카테고리 (t_prd_product_categories)
- [라이브] CAT_000124 (노트) main=Y seq=1
#### 2. 사이즈 (t_prd_product_sizes)
- [라이브] SIZ_000379 (144x206) dflt=Y
- [라이브] SIZ_000380 (182x257) dflt=Y
#### 3. 도수/인쇄옵션 (t_prd_product_print_options)
- [라이브] opt=1 side=단면 앞=CLR_000005(CMYK 4도) 뒤=CLR_000001(인쇄 안 함) dflt=Y
#### 4. 판형 (t_prd_product_plate_sizes)
- [라이브] SIZ_000007 (148x210) dflt_plt=Y 출력지=- 파일=-
- [라이브] SIZ_000381 (186x261) dflt_plt=Y 출력지=- 파일=-
#### 5. 자재 (t_prd_product_materials) — round-5 델타 MERGE
- [라이브] MAT_000072 (백색모조지 100g) / usage=USAGE.07(공통) dflt=Y (델타 외 라이브 기존)
- [라이브] MAT_000260 (아트250 + 무광코팅) / usage=USAGE.02(표지) dflt=Y (델타 외 라이브 기존)
- [라이브] MAT_000261 (무지내지) / usage=USAGE.01(내지) dflt=Y (델타 외 라이브 기존)
#### 6. 공정 (t_prd_product_processes) — round-5 델타 MERGE
- [+R5] PROC_000022 (떡제본) mand=Y seq=1 — 상품-공정 링크 라이브 미존재(적재 대기)
- [+R5] PROC_000015 (무광) mand=N seq=5 — 상품-공정 링크 라이브 미존재(적재 대기)
#### 7. 묶음수 (t_prd_product_bundle_qtys) — round-5 델타 MERGE
- (없음 — 라이브·델타·차단 모두 0)
#### 8. 페이지룰 (t_prd_product_page_rules)
- (없음 — 라이브·델타·차단 모두 0)
#### 9. 추가상품 (t_prd_product_addons)
- (없음 — 라이브·델타·차단 모두 0)

### PRD_000181 — 중철노트

**요약:** 카테고리 1 · 사이즈 1 · 도수 1 · 판형 1 · 자재 3 · 공정 0 (+R5 2) · 묶음 **0/0** · 페이지룰 **0/0** · 추가상품 **0/0**

#### 1. 카테고리 (t_prd_product_categories)
- [라이브] CAT_000124 (노트) main=Y seq=1
#### 2. 사이즈 (t_prd_product_sizes)
- [라이브] SIZ_000196 (A6(105x148mm)) dflt=Y
#### 3. 도수/인쇄옵션 (t_prd_product_print_options)
- [라이브] opt=1 side=단면 앞=CLR_000005(CMYK 4도) 뒤=CLR_000001(인쇄 안 함) dflt=Y
#### 4. 판형 (t_prd_product_plate_sizes)
- [라이브] SIZ_000382 (216x154) dflt_plt=Y 출력지=- 파일=-
#### 5. 자재 (t_prd_product_materials) — round-5 델타 MERGE
- [라이브] MAT_000072 (백색모조지 100g) / usage=USAGE.07(공통) dflt=Y (델타 외 라이브 기존)
- [라이브] MAT_000260 (아트250 + 무광코팅) / usage=USAGE.02(표지) dflt=Y (델타 외 라이브 기존)
- [라이브] MAT_000261 (무지내지) / usage=USAGE.01(내지) dflt=Y (델타 외 라이브 기존)
#### 6. 공정 (t_prd_product_processes) — round-5 델타 MERGE
- [+R5] PROC_000018 (중철제본) mand=Y seq=1 — 상품-공정 링크 라이브 미존재(적재 대기)
- [+R5] PROC_000015 (무광) mand=N seq=5 — 상품-공정 링크 라이브 미존재(적재 대기)
#### 7. 묶음수 (t_prd_product_bundle_qtys) — round-5 델타 MERGE
- (없음 — 라이브·델타·차단 모두 0)
#### 8. 페이지룰 (t_prd_product_page_rules)
- (없음 — 라이브·델타·차단 모두 0)
#### 9. 추가상품 (t_prd_product_addons)
- (없음 — 라이브·델타·차단 모두 0)

## 가격공식 전용 상품 (상품마스터 델타 외, 가격트랙만)

> 아래는 9속성 상품마스터 델타에는 없고 round-5 **가격공식 델타**에만 등장하는 상품이다. 9속성 검증 대상은 아니나, 가격공식 적재 대상으로 추적한다.

| 상품 | 상품명 | 가격공식(라이브/델타) |
|------|------|--------------------|
| PRD_000024 | 포토카드 | [+R5]PRF_PHOTOCARD_FIXED |
| PRD_000025 | 투명포토카드 | [+R5]PRF_PHOTOCARD_FIXED |
| PRD_000032 | 코팅명함 | [+R5]PRF_NAMECARD_FIXED |
| PRD_000050 | 봉투제작 | [+R5]PRF_ENV_MAKING |
| PRD_000052 | 반칼 자유형 스티커 | [+R5]PRF_STK_FIXED |
| PRD_000055 | 낱장 자유형 스티커 | [+R5]PRF_STK_FIXED |
| PRD_000066 | 합판도무송스티커 | [+R5]PRF_GANGPAN_FIXED |
| PRD_000094 | 엽서북 | [+R5]PRF_PCB_FIXED |
| PRD_000097 | 떡메모지 | [+R5]PRF_TTEOKME_FIXED |
| PRD_000118 | 아트프린트포스터 | [+R5]PRF_POSTER_FIXED |
| PRD_000119 | 아트페이퍼포스터 | [+R5]PRF_POSTER_FIXED |
| PRD_000120 | 방수포스터 | [+R5]PRF_POSTER_FIXED |
| PRD_000121 | 접착방수포스터 | [+R5]PRF_POSTER_FIXED |
| PRD_000123 | 아트패브릭포스터 | [+R5]PRF_POSTER_FIXED |
| PRD_000124 | 린넨패브릭포스터 | [+R5]PRF_POSTER_FIXED |
| PRD_000125 | 캔버스패브릭포스터 | [+R5]PRF_POSTER_FIXED |
| PRD_000126 | 레더아트프린트 | [+R5]PRF_POSTER_FIXED |
| PRD_000127 | 타이벡프린트 | [+R5]PRF_POSTER_FIXED |
| PRD_000128 | 메쉬프린트 | [+R5]PRF_POSTER_FIXED |
| PRD_000129 | 폼보드 | [+R5]PRF_POSTER_FIXED |
| PRD_000130 | 포맥스보드 | [+R5]PRF_POSTER_FIXED |
| PRD_000131 | 프레임리스우드액자 | [+R5]PRF_POSTER_FIXED |
| PRD_000132 | 레더아트액자 | [+R5]PRF_POSTER_FIXED |
| PRD_000133 | 캔버스 행잉포스터 | [+R5]PRF_POSTER_FIXED |
| PRD_000134 | 린넨 우드봉 족자 | [+R5]PRF_POSTER_FIXED |
| PRD_000135 | 족자포스터 | [+R5]PRF_POSTER_FIXED |
| PRD_000136 | PET배너 | [+R5]PRF_POSTER_FIXED |
| PRD_000137 | 메쉬배너 | [+R5]PRF_POSTER_FIXED |
| PRD_000138 | 일반현수막 | [+R5]PRF_POSTER_FIXED |
| PRD_000139 | 메쉬현수막 | [+R5]PRF_POSTER_FIXED |
| PRD_000140 | 무광시트커팅 | [+R5]PRF_POSTER_FIXED |
| PRD_000141 | 홀로그램 시트커팅 | [+R5]PRF_POSTER_FIXED |
| PRD_000142 | 유광아크릴스티커 | [+R5]PRF_POSTER_FIXED |
| PRD_000143 | 미러아크릴스티커 | [+R5]PRF_POSTER_FIXED |
| PRD_000144 | 미니보드스탠딩 | [+R5]PRF_POSTER_FIXED |
| PRD_000145 | 미니배너 | [+R5]PRF_POSTER_FIXED |

