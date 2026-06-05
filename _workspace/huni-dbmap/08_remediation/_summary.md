# huni-dbmap 11시트 종단 결함 처리 — 통합 대시보드 (round-3 remediation summary)

> **목적:** `08_remediation/` 11개 시트 종단 결함 처리 결과를 단일 대시보드로 종합한다.
> **방법:** 새 라이브 조회 0 — 각 시트 .md의 ④결함표(G-*)·③실태·⑤처리방향·⑥컨펌질문을 집계·종합. 모든 수치는 출처(시트.md G-ID) 인용.
> **권위 원칙(상속):** 각 시트가 라이브 SELECT를 권위로 산출. v2/추출본은 stale. 본 대시보드는 그 산출의 **집계 계층**이며 새 판정·새 결함을 발명하지 않는다.
> **HARD:** 추정·임의판단 0. 시트 간 충돌 수치는 양쪽 병기+플래그. 새 결함 발명 금지.
> **작성** 2026-06-05 (dbm-validator) · 식별자/컬럼/코드/SQL 영어, 설명 한국어.

---

## 0. 11시트 스코프 한눈에 (상품군·상품수·prd_cd 블록)

| # | 시트 | 상품군 도메인 | L1 상품수 | 라이브 등록 | prd_cd 블록 | prd_typ |
|---|------|--------------|:--------:|:----------:|-------------|---------|
| 1 | digital-print | 엽서·포토카드·접지카드·명함·상품권·배경지·홍보물 | 36 | 36/36 | 016~051 | .04 디자인 |
| 2 | booklet | 제본별 책자 11종(+반제품 sub_prd) | 11 parent | 11/11 | 068~107(parent+sub) | .04(parent)/.02(sub) |
| 3 | photobook | 포토북 단일+표지타입/사이즈 variant | 1(17 variant행) | 1/1 | 100(+101~107 sub) | .04 |
| 4 | stationery | 플래너·노트·수첩·메모 11종 | 11 | 11/11 | 172~181·097 | .03(+097=.04) |
| 5 | calendar | 탁상·미니탁상·엽서·벽걸이·와이드 5종 | 5 | 5/5 | 108~112 | .04 |
| 6 | design-calendar | calendar와 **동일 prd_cd**(디자인 제공 variant) | 5 | 5/5(=108~112) | 108~112(공유) | .04 |
| 7 | acrylic | 단품형14·조합형11 아크릴 굿즈 | 25 | 23/25 | 146~169(167결번) | .04 |
| 8 | silsa | 포스터·패브릭·보드/액자·족자·배너·현수막·시트 | 29 | 28/29 | 118~145 | .04 |
| 9 | goods-pouch | 굿즈·소품·파우치·에코백·폰케이스(시트 최대) | 103 | 98/103 | 183~280 | .03 |
| 10 | product-accessory | 봉투·케이스·부자재·악세서리 | 15 | 15/15 | 001~015 | .03 |
| 11 | sticker | 반칼·완칼·스티커완칼·도무송 16종 | 16 | 16/16 | 052~067 | .04 |

- **미등록(라이브 부재):** acrylic 2(아크릴쉐이커★·지비츠★, G-AC-8) · silsa 1(투명포스터★, G-SL-8) · goods-pouch 5(폰케이스류 그레이밴딩, **G-GP-1 BLOCKER**).
- **design-calendar는 별도 상품 미존재** — calendar와 prd_cd 108~112 완전 공유(G-DC-1). 상품수 중복 계상 주의.

---

## 1. 시트 × 4분류 매트릭스 (G-ID별 집계, 출처 명시)

분류 정의(각 시트 ④ 공통): **MISSING**=정규화 규칙대로면 적재돼야 하는데 라이브 부재 · **MISMATCH**=잘못된 축/코드 연결 · **CONFIRM**=도메인 의미 미확정(실무 컨펌) · **정상철회**=v2/추출본이 결함으로 오보했으나 라이브 재확인 결과 MATCH(false EXTRA/MISSING).

> 주의: 한 G-ID가 복합분류(예 MISMATCH+MISSING)인 경우 주분류로 계상하고 비고에 병기. 수치는 시트.md에 명시된 건수만 인용. "건수 미확정(가설)"은 ✱로 표기.

| 시트 | MISSING (G-ID) | MISMATCH (G-ID) | CONFIRM (G-ID) | 정상철회 false EXTRA/MISSING (G-ID) |
|------|----------------|-----------------|----------------|--------------------------------------|
| **digital-print** | G-DP-1 줄수/개수 공정 **28건**·G-DP-2 형압 **2건**·G-DP-3 자재 IMPORT 9상품✱·G-DP-4 addon **3건** | — | G-DP-7 별색이중성·G-DP-8 bundle/excl·G-DP-9 qty_unit | G-DP-5 박색상 EXTRA철회·G-DP-6 코팅엽서 자재 false EXTRA·(머리말)프리미엄엽서 016 false MISSING 4 |
| **booklet** | G-BK-1 내지종이 8상품✱·G-BK-2 표지종이 **4상품**·G-BK-3 형압 **4건** | G-BK-4 레더바인더(제본/excl/page 전무)·G-BK-5 떡메모지 page_rule 잡음+usage중복 | G-BK-4·G-BK-7 qty_unit·G-BK-8 박 SEL_TYPE | G-BK-6 통합상품 sets 0행 false MISSING철회·(머리말)page_rule 대량 false·제본택일 정상 |
| **photobook** | — | G-PB-2 표지타입↔종이 평면·G-PB-3 복합표기 미분해 | G-PB-1 제본 PUR/레이플랫 충돌·G-PB-4 책등 param·G-PB-6 qty_unit | G-PB-5 sub_prd/page/size 정상·(머리말)page_rule false MISSING철회 |
| **stationery** | G-ST-1 제본 **6건확정+2컨펌**·G-ST-2 페이지룰✱ | — | G-ST-2·G-ST-3 excl_group·G-ST-4 코팅분리·G-ST-5 bundle·G-ST-6 qty_unit | (③)material 표기차 false EXTRA철회 |
| **calendar** | G-CL-1 택일그룹 멤버✱·G-CL-2 거치대공정 108/109·G-CL-4 자재 IMPORT✱ | G-CL-1 멤버연결끊김·G-CL-3 우드거치대 이중분류 | G-CL-2·G-CL-3·G-CL-5 장수/링칼라·G-CL-6 qty_unit | — (v2 "택일그룹 N/A보류"가 결함 은폐였음, 머리말) |
| **design-calendar** | G-DC-3 택일그룹(calendar 공유)·G-DC-4 고정페이지✱ | G-DC-2 종이 고정↔IMPORT 혼재 | G-DC-1 디자인축 미인코딩(구조)·G-DC-2·G-DC-4·G-DC-5 qty_unit | — (G-DC-1 prd_cd 공유=가정 시 오판 방지) |
| **acrylic** | G-AC-1 완칼 **≈21건**·G-AC-2 조각수 **2상품**·G-AC-3 부속미연결·G-AC-4 부착공정·G-AC-6 nonspec·G-AC-7 볼체인 | G-AC-3 두께소실(192일괄)·G-AC-5 UV변형→print_side | G-AC-5·G-AC-8 ★미등록·G-AC-9 qty_unit | — (마스터 풍부·연결만 빈 구조) |
| **silsa** | G-SL-1 보드/액자 자재 **5상품**·G-SL-2 화이트별색 **1건**·G-SL-4 거치대/고리/끈 addon·G-SL-6 nonspec | — | G-SL-4·G-SL-5 봉제/타공 param·G-SL-7 print_option·G-SL-8 ★미등록·G-SL-9 qty_unit | G-SL-3 코팅 false누락철회·G-SL-5 봉제/타공/족자 MATCH(권위반전 모범) |
| **goods-pouch** | G-GP-1 폰케이스 **5상품 미등록**(BLOCKER)·G-GP-2 size **77상품**(BLOCKER)·G-GP-4 에폭시✱·G-GP-5 말랑addon✱ | (G-GP-2 plate=size 착각 구조) | G-GP-3 variant 분해 | G-GP-6 discount 81 정상·G-GP-7 price/print/bundle/page 정상 |
| **product-accessory** | (BLOCKER 없음) | — | G-PA-2 size입도·G-PA-3 bundle부분✱ | G-PA-1 size/material분기 MATCH·G-PA-4 process부재 정상·G-PA-5 MES중복 무영향 |
| **sticker** | G-SK-1 화이트별색 **3활성+1미출시**·G-SK-2 형상enum(합판원형 **11종**+058~062 축부재) | G-SK-3 064 size 오공유(헤더택/배경지)·G-SK-2 평면화 | G-SK-6 반칼↔스티커완칼 코드·G-SK-7 qty_unit | G-SK-4 빈 가변/코팅/addon false MISSING차단·G-SK-5 자재 직접명 MATCH·(머리말)커팅 14상품 정상 |

✱ = 시트.md가 "정확 행수는 매핑 확정 후(가설)"로 명시한 건수 미확정 항목.

### 1-b. 분류별 시트 분포 요약

- **MISSING 보유 시트:** 9/11 (예외=product-accessory BLOCKER없음, photobook은 MISMATCH/CONFIRM 위주).
- **MISMATCH 보유 시트:** booklet·photobook·calendar·design-calendar·acrylic·goods-pouch·sticker (7).
- **CONFIRM(글로벌 qty_unit 제외하고도) 보유:** 11/11 전 시트.
- **정상철회(false 결함 걷어냄) 보유 시트:** digital-print·booklet·photobook·stationery·silsa·goods-pouch·product-accessory·sticker (8). calendar·design-calendar·acrylic은 false철회보다 **은폐 결함 발굴** 방향.

---

## 2. 공통 결함 패턴 (시트 횡단 — 단일 시트로는 안 보이는 것)

### P1. 제본/커팅/완칼 등 **핵심 공정 미적재** (R-PROC 계열)
| 패턴 | 영향 시트 | 건수·근거 | 근원 |
|------|----------|----------|------|
| 줄수/개수 공정(오시·미싱·VDP) | digital-print | **28건**/12상품 (G-DP-1) | `1줄/2개`를 옵션값으로 오해, 공정행 미생성 |
| 제본 공정 전량 누락 | stationery | **6확정+2컨펌** (G-ST-1) | `제본사양` enum을 공정으로 변환 못함 |
| 형압 자식 공정 | digital-print·booklet | DP 2 + BK 4 = **6건** (G-DP-2·G-BK-3) | 형압(양각/음각) 신호 미적재 |
| 완칼(die-cut) 묵시필수 | acrylic | **≈21건** (G-AC-1) | 엑셀 명시 컬럼 부재→도메인 누락 |
| 조각수 공정 | acrylic | **2상품** (G-AC-2) | 조각수 param 미반영 |
| 캘린더가공 택일 멤버 | calendar·design-calendar | ✱ (G-CL-1·G-DC-3) | excl_grp_cd 연결 전부 NULL |
- **횡단 근원 공통:** 엑셀 컬럼의 "옵션값처럼 보이는 신호(줄수/개수/제본명/조각수)"를 **공정 존재 신호로 정규화하지 못함**. digital-print(R-PROC-2)·stationery(R-PROC-6)가 같은 뿌리.
- **단, 시트별 편차 큼:** sticker는 커팅 14/16 **이미 건전**(G-SK 머리말), silsa는 봉제/타공/족자 **MATCH**(G-SL-5) — "공정 미적재"는 전 시트 일률이 아니다.

### P2. 자재 `*별도설정` → 출력소재 IMPORT 미적재 (R-MAT-2)
| 영향 시트 | 건수·근거 |
|----------|----------|
| digital-print | 9상품 material 0행 (G-DP-3) |
| booklet | 내지종이 8상품·표지종이 4상품 (G-BK-1·G-BK-2) |
| calendar | IMPORT 종이 대폭부족(탁상8·미니7·엽서10·벽걸이22종 대비) (G-CL-4) |
- **근원:** `*별도설정`을 빈값/플레이스홀더로 오처리→제외. 실제는 가격표 `출력소재(IMPORT)` 포인터.
- **반례(직접명이라 결함 아님):** stationery(백모조·아트250 직접명)·sticker(유포/투명 직접명 G-SK-5)·silsa(MAT_TYPE.08 1:1정합 G-SL-4 머리말)·design-calendar(몽블랑190g 직접). → IMPORT 결함은 **digital-print·booklet·calendar 3시트 집중**.

### P3. variant 자재/사이즈 차원 평면화 (R-MAT-5)
| 영향 시트 | 내용·근거 |
|----------|----------|
| acrylic | 두께(1.5/3/8mm)를 192 단일 일괄·부속 미연결 (G-AC-3) |
| goods-pouch | 색상×사이즈 복합 variant 전부 material 평면화, size 차원 분리안됨 (G-GP-3) |
| photobook | 표지타입↔표지종이 평면 혼재 (G-PB-2) |
| product-accessory | (대조군) size↔material 분기 **정상** (G-PA-1) — 같은 시트군이라도 편차 |
- **근원:** variant 축(색상 vs 사이즈 vs 두께)을 단일 차원(material)으로 욱여넣음. round-2 component_prices 차원과 교차.

### P4. 택일그룹(excl_group) 구조 결함 — 캘린더·현수막계
| 영향 시트 | 내용·근거 |
|----------|----------|
| calendar | GRP-CAL-가공 헤더만 적재, 멤버 process의 excl_grp_cd 전부 NULL (G-CL-1) |
| design-calendar | calendar 공유 (G-DC-3) |
| (대조)booklet | GRP-BOOK-제본 **정상 적재**(10 parent) — 택일 결함 아님(머리말) |
| (대조)digital-print·acrylic·silsa·sticker | excl_group 전무가 **정상**(낱장/단일공정) |
- **근원:** 캘린더가공 다축(거치/제본/타공) 혼재 컬럼을 평면화하며 헤더↔멤버 FK 연결 누락. **calendar에 국한**(booklet은 정상).

### P5. 비치수(nonspec/사용자입력) 사이즈 범위 전무
| 영향 시트 | 내용·근거 |
|----------|----------|
| acrylic | 사용자입력 11상품, width/height_min/max 전 23상품 NULL (G-AC-6) |
| silsa | nonspec_yn=Y 상품 있으나 전 28상품 min/max NULL (G-SL-6) |
- **근원:** R-SIZE-5 사용자입력→nonspec 범위 미적재. round-2 면적가격과 연동. **대형/굿즈 2시트.**

### P6. 그레이밴딩 / use_yn=N 비활성 (미출시·미적재 마킹)
| 영향 시트 | 내용·근거 |
|----------|----------|
| goods-pouch | 회색배경 5상품=**미등록 마킹**(품절 아님), use_yn=N 12상품 (G-GP-1·①) |
| acrylic | use_yn=N 6상품·★미등록 2 (①·G-AC-8) |
| silsa | ★미등록 1 (G-SL-8) |
| digital-print | use_yn=N 7상품 (①) |
| sticker | use_yn=N 2상품 (①) |
| stationery | use_yn=N 1·booklet 보류상품 1·product-accessory use_yn=N 1·calendar 0 |
- **근원:** 비활성 표시 방식이 시트마다 다름 — goods-pouch는 **셀 회색배경**(행숨김 0), acrylic/silsa는 **행숨김+★제약**, 나머지는 use_yn=N. **공통 처리원칙:** 비활성=MISSING 아님, 결함집계 분리, 단 "출시 예정 vs 영구보류" 정책 컨펌 필요.

### P7. qty_unit_typ_cd 글로벌 NULL (전 시트 공통, 시트 고유결함 아님)
- **영향:** **272 전상품 NULL** — 11시트 전부 해당(G-DP-9·G-BK-7·G-PB-6·G-ST-6·G-CL-6·G-DC-5·G-AC-9·G-SL-9·G-PA(언급)·G-GP-7(언급)·G-SK-7).
- **근원:** 글로벌 적재 갭. **시트별 처리 아님 — 단일 글로벌 QTY_UNIT 부여 정책으로 일괄.**

### P8. (참고) 인쇄방식 PROC_000002~6 / constraint_json 272 전상품 미연결
- acrylic G-AC-5·calendar(constraint_json NULL) 등에서 언급된 **글로벌 갭**. UV변형 오적재(G-AC-5)와 연동. 본 라운드 9속성 범위 일부 밖이나 위젯 인쇄옵션에 영향.

---

## 3. v2 대비 라이브 반전 종합 (추출본 stale → v2 오보를 라이브로 교정)

각 시트 ⚠️머리말이 "v2/추출본/B-rules/과업가정이 라이브에서 뒤집힌" 사실을 명시. 집계:

| 시트 | v2/추출본 오보(가정) | 라이브 반전(실제) | 반전 건수·유형 |
|------|---------------------|-------------------|----------------|
| digital-print | 프리미엄엽서 016 "MISSING 4"·박색상 EXTRA·코팅엽서 자재 EXTRA | 016 이미처리(false MISSING)·박색상 정합·자재 정규화 MATCH | **3유형**(false MISSING 4 + false EXTRA 2종) |
| booklet | 중철책자 sets MISSING·page_rule 대량 MISSING·parent자재 비어야정상·제본택일 의심 | sets 0행 정상·page_rule 전 10 parent 적재됨·parent에 usage_cd 적재·제본택일 정상 | **4유형 반전** |
| photobook | 레이플랫 단일템플릿·parent자재 비어야정상·page_rule MISSING | PUR로 적재(레이플랫 0건 충돌)·parent 적재·page_rule 있음 | **3유형 반전** |
| stationery | v2 process MAJOR(집계만)·material EXTRA | 노트류 제본 0건(상품별 치명 드러남)·material 정규화 MATCH | 집계 은폐 1 + false EXTRA 1 |
| calendar | v2 "택일그룹 N/A 보류(원천부재)" | 택일 실재·헤더만/멤버연결 끊김·우드거치대 이중분류 | **은폐 결함 3건 발굴**(반전 방향=은폐해제) |
| design-calendar | 디자인캘린더=별도 상품 가정 | calendar와 동일 prd_cd(별도 0건) | 구조 오판 방지 1 |
| acrylic | v2 process MAJOR 집계 | process 0행(맥세이프만)·두께 192일괄·부속 미연결·UV→print_side | 마스터풍부-연결빈 구조 노출(집계가 못본 4결함) |
| silsa | v2가 코팅/실사공정 누락 의심 가능 | 족자/봉제/타공/부착/코팅 정합(모범 적재) | **false 누락 철회 방향**(권위반전=정합확인) |
| goods-pouch | 회색밴딩=품절·plate=size 착각 | 회색=미등록 5상품·size11 vs plate85 | **2유형 반전**(BLOCKER 2 노출) |
| product-accessory | (goods-pouch 동시트군이라 누락 우려) | size7+material8=15 완전커버·분기 정합 | GO수준 확인(false 결함 양산 방지) |
| sticker | 커팅 누락 우려·빈 가변 R-PROC-2 거짓기대·digital-print 렌즈 무비판적용 | 커팅 14/16 건전·VDP MISSING 0(false차단)·진짜결함=별색/형상enum | **false 차단 3종**(커팅 오보·거짓기대행·결함축 오인) |

**정량화:** 11시트 **전부**가 v2/추출본 대비 1건 이상의 반전을 보고. 유형 합산:
- **false MISSING 철회**(이미 처리/정상인데 결함 오보): digital-print(016 4건+코팅/박)·booklet(sets·page_rule·제본택일 4유형)·photobook(page_rule)·sticker(VDP·커팅)·silsa(공정정합) — 다수.
- **false EXTRA 철회**(EXTRA로 봤으나 정상 MATCH): digital-print 2종(박색상·자재)·stationery 1(material).
- **은폐 결함 발굴**(v2가 "보류/N/A"로 닫아 못 본 진짜 결함): calendar 3건(택일 멤버/이중분류)·acrylic 4(연결빈)·goods-pouch 2 BLOCKER.
- **구조 오판 방지:** design-calendar(동일 prd_cd)·product-accessory(GO확인).

**"라이브 직접 확인" 원칙의 효과:** 추출본 그대로 신뢰 시 ① 이미 고친 것을 결함 오보(false 양산) ② 적재진행/미등록 못 봄(은폐) — 양방향 오류가 **11시트 전부에서** 실제 발생했음이 입증됨. 본 라운드 핵심 교훈(메모리 dbmap-no-db-load-file-first의 "권위반전")의 시트별 정량 근거.

---

## 4. 전 시트 처리 우선순위 (통합 R — 위젯 선결조건 순)

각 시트 ⑤처리방향의 우선순위(High/Medium/Low)·BLOCKER 표기를 집계. **위젯 옵션·가격 직결도** 기준.

### High (위젯 옵션/가격 직결 — 선결조건)
| 통합R | 결함(출처) | 처리 대상 테이블 | 비고 |
|-------|-----------|------------------|------|
| H1 | **goods-pouch size 77상품 미적재** (G-GP-2 BLOCKER) | `t_prd_product_sizes` | 위젯 사이즈 선택지 소멸. 사각손거울=size/plate 짝 레퍼런스 |
| H2 | **goods-pouch 폰케이스 5상품 미등록** (G-GP-1 BLOCKER) | `t_prd_products`+연결 | 출시 여부 선확인(출시면 BLOCKER) |
| H3 | **digital-print 줄수/개수 공정 28건** (G-DP-1) | `t_prd_product_processes` | 프리미엄엽서 016 레퍼런스(검증선행) |
| H4 | **stationery 제본 공정 6+2** (G-ST-1 BLOCKER) | `t_prd_product_processes` | 떡메모지 097 레퍼런스 |
| H5 | **calendar 택일그룹 멤버 연결** (G-CL-1 BLOCKER) | `_processes`+`_excl_groups` | 위젯 대표 택일 UI 빈그룹. design-calendar 공유 해소 |
| H6 | **acrylic 완칼+조각수+두께/부속** (G-AC-1/2/3) | `_processes`·`_materials` | process 전무→모양/가공/조각수 옵션 소멸. 완칼 모델링 컨펌선행 |
| H7 | **acrylic UV변형 오적재** (G-AC-5) | `_processes`/print_options | 컨펌선행 |
| H8 | **sticker 화이트별색+형상enum** (G-SK-1·G-SK-2) | `_processes`·`_sizes` | 형상enum 축설계 선행 |
| H9 | digital-print 자재 IMPORT 9상품 (G-DP-3) | `t_prd_product_materials` | IMPORT 해소 선행 |
| H10 | booklet 내지/표지종이 8상품 (G-BK-1/2) | `t_prd_product_materials` | 매핑확정 3상품 선적재, 5상품 자재소스 컨펌 |
| H11 | silsa 보드/액자 자재 5상품 (G-SL-1) | `t_prd_product_materials` | 컨펌후 |
| H12 | calendar 자재 IMPORT (G-CL-4)·거치대공정 (G-CL-2) | `_materials`·(공정/addon) | |
| H13 | design-calendar 디자인축 인코딩 (G-DC-1) | (구조결정) | **선결** — G-DC-2/4가 의존 |

### Medium
- digital-print: addon 누락(G-DP-4)·qty_unit(G-DP-9 글로벌)
- booklet: 형압(G-BK-3)·떡메모지 page잡음(G-BK-5)·qty_unit
- photobook: 복합표기 분해(G-PB-3)·책등param(G-PB-4)
- stationery: 표지 코팅분리(G-ST-4)·페이지룰(G-ST-2 컨펌)
- acrylic: 부착공정(G-AC-4)·nonspec(G-AC-6)·qty_unit
- silsa: 화이트별색(G-SL-2)·거치대addon(G-SL-4)·nonspec(G-SL-6)
- goods-pouch: 에폭시(G-GP-4)·말랑addon(G-GP-5)
- calendar: 우드거치대 이중분류 정정(G-CL-3)·장수/링칼라(G-CL-5)

### Low (미출시·미세)
- digital-print: 형압명함(G-DP-2 use_yn=N)
- acrylic: 볼체인 6색(G-AC-7)
- sticker: 064 size 오공유(G-SK-3 use_yn=N)
- product-accessory: size입도(G-PA-2)·bundle분리(G-PA-3) — 전체 Low(정합 양호)

### 처리 불요(정정만 — false 철회/정상)
- digital-print R5(박색상·자재 false EXTRA)·booklet R5(sets)·silsa R5(코팅/봉제/타공)·goods-pouch R6(discount/price)·sticker R4(빈컬럼/자재)·product-accessory R3(분기/process/MES).

### FK 적재순서(전 시트 공통)
**마스터(`t_mat`·`t_proc`·`t_cod`·`t_siz`·sets)는 전부 건전** — 11시트 모두 "마스터 무변경, 상품 연결 테이블만 적재" 확인.
순서: **(상품 등록 G-GP-1) → size → material(IMPORT/두께 해소 선행) → process(excl_group 연결) → addon → page_rule 보정**. 모든 `prd_cd` FK 라이브 존재 확인됨.

---

## 5. 실무 컨펌 질문 통합 (11시트 ⑥ 주제별 중복제거)

11시트 ⑥의 컨펌 질문을 주제로 묶고 **도메인 결정 vs 적재 정책**으로 구분.

### A. 도메인 결정 (사업/제품 의미 — 실무 답변 필요)
| 주제 | 해당 시트(질문) | 핵심 결정사항 |
|------|----------------|--------------|
| A1. 미출시/★/그레이밴딩 처리 | digital-print Q3·acrylic Q5·silsa Q6·goods-pouch Q1/Q6·product-accessory Q4 | use_yn=N·★·회색밴딩 상품을 지금 처리 vs 출시까지 보류. **goods-pouch 폰케이스 5 출시여부=BLOCKER 분기** |
| A2. 레퍼런스 단일예시 일괄확대 | digital-print Q1·stationery Q1 | 016(엽서)·097(떡메모지)만 처리된 이유=의도된 예시 vs 작업중. 나머지 일괄 적재 가부 |
| A3. 제본 도메인 충돌 | photobook Q1 | 포토북 제본=PUR vs 레이플랫(025 0건 적재) |
| A4. 택일그룹 의도 | calendar Q2·stationery Q2 | 캘린더 108/109 택일그룹 신설 여부·문구 제본 단일고정→excl_group 불요 여부 |
| A5. 거치대/부속 = 공정 vs addon | calendar Q3·silsa Q2·acrylic Q3 | 우드거치대/배너거치대/자석/핀/고리를 공정(부착)인지 addon인지(축 분기) |
| A6. 완칼 모델링 | acrylic Q1 | 아크릴 절단=완칼 공정 vs 사이즈/가격 내포 |
| A7. 디자인캘린더 구조 | design-calendar Q1 | 디자인 제공축=별도 prd_cd vs variant vs 플래그(선결) |

### B. 적재 정책 (정규화 입도/축 — 설계 결정)
| 주제 | 해당 시트(질문) | 핵심 정책사항 |
|------|----------------|--------------|
| B1. IMPORT 자재 매핑 | digital-print Q2·booklet Q1/Q2·calendar Q5 | `*별도설정`→IMPORT 컬럼↔상품 매핑 확정. PUR/하드커버 자재소스 부재(별도 소스?) |
| B2. variant 차원 분해 | acrylic Q2·goods-pouch Q3·photobook Q2·product-accessory Q1 | 색상/사이즈/두께 variant를 material vs size로 분리하는 일관기준 |
| B3. 형상/커팅 enum 축 | sticker Q2·sticker Q3 | 도형 enum을 size보조 vs 신규테이블 vs process param. 반칼↔스티커완칼 코드 정합 |
| B4. UV변형/별색 공정화 | acrylic Q4·sticker Q1·silsa Q4·digital-print Q4(별색) | UV변형 print_side vs PROC_000002. 화이트별색 부모007/자식008 규칙 통일 |
| B5. page_rule/장수 인코딩 | stationery Q5·calendar Q4·photobook Q3·design-calendar Q3·booklet Q5 | 페이지/장수/책등을 page_rule(min/max) vs variant vs param |
| B6. bundle_qty 분리 | product-accessory Q2·digital-print Q5·stationery Q5 | 묶음장수를 size문자열 내 vs bundle_qty 분리 |
| B7. qty_unit 글로벌 정책 | **11시트 전부** Q마지막 | 272 전상품 NULL → QTY_UNIT 일괄 부여(매/권/세트/EA) |
| B8. 봉제/타공/족자 param | silsa Q3 | 공정행은 있으나 세부 param(유형/구수/모양) 적재 여부 |
| B9. addon↔자체상품 단가 이중정의 | product-accessory Q3 | 부자재가 addon 참조+자체등록 — round-2 가격 이중정의 우려 |

**통합 주제 수: 도메인 결정 7(A1~A7) + 적재 정책 9(B1~B9) = 16개 통합 주제** (11시트 분산 질문 ~60건을 중복제거).
**가장 광범위 주제:** B7 qty_unit(11/11 시트), A1 미출시처리(5시트), B2 variant 분해(4시트), B1 IMPORT(4시트), B5 page인코딩(5시트).

---

## 6. 위젯 기반 관점 — 정제 9속성 → 자동견적 옵션 캐스케이드 선결조건

각 시트 ⑦이 명시한 "정제 9속성=위젯 옵션 캐스케이드 데이터소스" 종합. **어느 결함이 위젯 옵션누락·가격오류로 직결되는지:**

| 위젯 영향 유형 | 직결 결함(시트.G-ID) | 잔존 시 위젯 증상 |
|---------------|---------------------|-------------------|
| **옵션 통째 소멸** | digital-print 줄수/개수(G-DP-1)·stationery 제본(G-ST-1)·acrylic 완칼/process전무(G-AC-1~4)·sticker 형상enum(G-SK-2) | 오시/미싱·제본·모양/가공/조각수·도형선택 옵션이 위젯에서 사라짐 |
| **택일 UI 빈그룹** | calendar 택일멤버(G-CL-1)·design-calendar 공유(G-DC-3) | 캘린더가공 택일(대표 UI)이 멤버없는 빈 그룹 |
| **사이즈 선택 불가** | goods-pouch size 77상품(G-GP-2)·sticker 합판원형(G-SK-2)·acrylic/silsa nonspec(G-AC-6·G-SL-6) | 재단치수·도형치수·사용자입력 범위 선택/검증 불가 |
| **상품 자체 부재** | goods-pouch 폰케이스 5(G-GP-1)·design-calendar 미인코딩(G-DC-1) | 폰케이스·디자인캘린더가 위젯에 표현 불가 |
| **자재(종이) 옵션 전무** | digital-print IMPORT(G-DP-3)·booklet 내지종이(G-BK-1)·calendar IMPORT(G-CL-4)·silsa 보드자재(G-SL-1) | 종이/소재 선택지·가격산정 불가 |
| **가격 오류** | acrylic UV변형(G-AC-5)·photobook 복합표기(G-PB-3)·stationery 코팅분리(G-ST-4)·nonspec 면적가격(G-AC-6·G-SL-6) | 코팅비·면적가 누락→가격 오산 |

**위젯 선결조건(GO 차단) 결함 = §4 High(H1~H13).** 특히 **BLOCKER 3건**:
- G-GP-2 (goods-pouch size 77상품) — 굿즈 위젯 사이즈축 붕괴
- G-GP-1 (폰케이스 5 미등록) — 출시 시 상품 부재
- G-CL-1 (calendar 택일멤버) — 사용자 지목 대표 택일 UI 붕괴

**위젯 GO 가능 시트(토대 양호):** product-accessory(G-PA GO수준)·silsa(보드자재+nonspec만 보정하면 구동)·sticker(별색+형상enum 보정 시).

**round-2(가격엔진 t_prc_*) 이연 항목은 본 라운드 결함 아님:** photobook 가격·goods-pouch price/formula·전 시트 `구간할인적용테이블`(round-1 완료)·디자인캘린더 가격축은 9속성 범위 밖(정상 이연).

---

## 부록 — 집계 출처 및 한계

- **출처:** `08_remediation/{digital-print,booklet,photobook,stationery,calendar,design-calendar,acrylic,silsa,goods-pouch,product-accessory,sticker}.md` 각 ①~⑦.
- **새 라이브 조회 0** — 본 대시보드는 11시트 .md의 라이브 산출을 집계만 함. 수치 충돌·미확정(✱)은 원시트 권위.
- **건수 미확정(✱) 항목:** G-DP-3(IMPORT 9상품 정확행)·G-BK-1(내지종이 N종)·G-ST-2(페이지룰)·G-CL-1/4·G-DC-4·G-AC(부속)·G-GP-4/5(에폭시/addon)·G-PA-3(bundle) — "매핑 확정 후" 산출 대상. **DB 미적재 유지(round-3 전 시트 공통).**
- **상품수 중복 주의:** design-calendar 5상품은 calendar 108~112와 동일 prd_cd(전체 상품수 합산 시 design-calendar 제외).
