# 포스터사인·아크릴 가격 정정 — 후니 권위 공식모델 반영 (round-2 오모델링 정정)

> **목적**: round-2가 포스터사인 28개 상품을 일괄 `PRF_POSTER_FIXED`(면적-좌표) 단일 모델로 적재한 것을, 후니 권위 가격모델(**면적매트릭스 13 + 고정가형 15**)로 정정한다. 고정가형 15는 round-2가 좌표 1점으로 축약한 오모델 → **[수량][규격] 재추출**, 면적 13+아크릴은 **[세로][가로] 좌표 siz 등록목록** 산출.
>
> **권위**: ① 후니 제공 가격계산공식(`02_mapping/price-formula-types-authoritative.md`·`09_load/_exec/load-decision-request.md §5`) — **데이터 R² 아님, 후니 권위 공식이 기준**. ② 원본구조 = `06_extract/price-poster-sign-l1.csv`(포스터사인 31블록) + `price-acrylic-price-l1.csv`(아크릴 7블록). ③ search-before-mint = 라이브 `00_schema/ref-sizes.csv`(497행) 치수대조.
>
> **HARD 준수**: read-only(DB 쓰기·DDL·COMMIT 0). 발명 0·재포장 0(siz는 기존 우선 탐색). 불확실은 🟡/🔴 정직 플래그. 식별자/코드/SQL 영어, 해석 한국어.

---

## 0. 요약 (orchestrator data)

| 항목 | 결과 |
|------|------|
| **고정가형 15 재추출 가능 여부** | ✅ **전 15제품 가능** — L1에서 [수량][규격] 재추출 완료 |
| **고정가 [수량][규격] 행수** | **73 cells** (9제품 clean + 폼보드/포맥스 6 concat복구 + 시트커팅/아크릴스티커 14 raw복구) |
| **면적매트릭스 좌표 siz 종수** | POSTER 13제품 **112 distinct WxH** + ACRYL 3소재 **196 distinct WxH** = **308 distinct 좌표** |
| **신규 등록 필요 siz** | **211종** (POSTER 106 + ACRYL 105 NONE) — 나머지는 기존 라이브 재사용(POSTER 6·ACRYL 91) |
| **폐기할 오좌표 placeholder** | **10 POSTER 고정가 placeholder rows** (좌표 1점으로 축약된 오모델) |
| **raw xlsx 재파싱 필요 여부** | ❌ **불필요** — 폼보드/포맥스(B11 concat)·시트커팅/아크릴스티커(B27 raw영역)도 L1에서 전량 복구됨 |
| **미해소 플래그** | siz_nm 명명·EXACT/REVERSED siz 재사용 확정·시트커팅 "(화이트/블랙)" variant 처리 등 (§6) |

**핵심 정정**: round-2 POSTER placeholder 680행 중 **670행은 면적매트릭스 13제품의 정당한 grid**(좌표 siz로 교체), **10행은 고정가형을 좌표 1점으로 축약한 오모델**(폐기 → 73 cells로 정상 재추출). ACRYL 237 placeholder는 면적매트릭스로 정당하나 round-2가 149 distinct만 추출(원천은 196) → **47좌표 누락 복원**.

---

## 1. 28개 상품 분류표 (제품 × 모델 × 원천블록 × 행수)

> 후니 권위 = **면적매트릭스 13 + 고정가형 15**. round-2는 28개 전부 면적-좌표(`PRF_POSTER_FIXED`)로 모델 → 분기 정정.

### 1A. 면적매트릭스형 13 — [세로mm 행][가로mm 열] (좌표 siz 등록 정당)

| prd_cd | 상품 | 원천블록 | 가로(width) | distinct WxH | 가격셀 | round-2 placeholder |
|--------|------|---------|------------|:----:|:----:|------|
| PRD_000118 | 아트프린트포스터(인화지) | B01 | 600/800/1000/1200 | 52 | 52 | COMP_POSTER_ARTPRINT_PHOTO 51 |
| PRD_000119 | 아트페이퍼포스터(매트지) | B02 | 600/800/900 | 39 | 39 | COMP_POSTER_ARTPAPER_MATTE 37 |
| PRD_000120 | 방수포스터(PET) | B03 | 600/800/1000/1200 | 52 | 52 | COMP_POSTER_WATERPROOF_PET 51 |
| PRD_000121 | 접착방수포스터(PVC) | B04 | 600/800/1000/1200 | 52 | 52 | COMP_POSTER_ADH_WATERPROOF_PVC 51 |
| PRD_000122 | 접착투명포스터(투명PVC) | B05 | 600/800/1000/1200 | 52 | 52 | COMP_POSTER_ADH_CLEAR_PVC 51 |
| PRD_000123 | 아트패브릭포스터(그래픽천) | B06 | 600/800/1000/1200 | 52 | 52 | COMP_POSTER_ARTFABRIC_GRAPHIC 51 |
| PRD_000124 | 린넨패브릭포스터 | B07 | 600/800/1000/1200 | 52 | 52 | COMP_POSTER_LINEN_FABRIC 51 |
| PRD_000125 | 캔버스패브릭포스터 | B08 | 600/800/1000/1200 | 52 | 52 | COMP_POSTER_CANVAS_FABRIC 51 |
| PRD_000126 | 레더아트프린트 | B09 | 600/800/1000/1200 | 52 | 52 | COMP_POSTER_LEATHER_ARTPRINT 51 |
| PRD_000127 | 타이벡프린트(하드/소프트) | B10 | 600/800/1000/1200 | 52 | 52 | COMP_POSTER_TYVEK_PRINT 51 |
| PRD_000128 | 메쉬프린트 | B11 | 600/800/1000/1200 | 52 | 52 | COMP_POSTER_MESH_PRINT 51 |
| PRD_000138 | 일반현수막 | B26 | 900/1000/1200/1500/1750 | 80 | 80 | COMP_POSTER_BANNER_NORMAL 77 |
| PRD_000139 | 메쉬현수막 | B27 | 900/1000/1200 | 48 | 48 | COMP_POSTER_BANNER_MESH 46 |
| **소계(면적)** | **13제품** | — | — | **112 distinct** | **687** | round-2 ~670행 |

> **[실사 11은 추론 — 후니 확인 항목]**: 실사 = PRD_000118~128. note `완제품가[코팅포함가]`는 규칙④ 합가 그대로(분해 금지). round-2 셀카운트(51 등)가 본 재추출(52 등)보다 1~3 적은 것은 round-2가 일부 행(예: A1 특수규격·헤더경계셀)을 누락했기 때문 → **재추출이 더 충실**.

### 1B. 고정가형 15 — [수량 행][옵션(규격) 열] (면적 무관, 좌표 placeholder 폐기·재추출)

| prd_cd | 상품 | 원천블록 | 규격옵션 집합 | 수량구간 | 가격셀 | round-2(오모델) | 복구방식 |
|--------|------|---------|------------|---------|:----:|------|------|
| PRD_000129 | 폼보드 | B11(concat) | A3/A2/A1 × 화이트/검정 | 1 | 6 | FOAMBOARD_W/B 2 placeholder | L1-concat 복구 |
| PRD_000130 | 포맥스보드 | B11(concat) | A3/A2/A1 × 화이트/검정 | 1 | 6 | FOMEX_3MM/5MM 2 placeholder | L1-concat 복구 |
| PRD_000131 | 프레임리스우드액자 | B13 | A3/A2/A1 | 1 | 3 | FRAMELESS_WOOD 1 placeholder | L1-clean |
| PRD_000132 | 레더아트액자 | B15 | 5x5/5x7/8x8/8x10/A4/A3 | 1 | 6 | LEATHER_FRAME 4 placeholder | L1-clean |
| PRD_000133 | 캔버스행잉포스터 | B19 | A4/A3/A2 | 1 | 3 | (좌표 미상) | L1-clean |
| PRD_000134 | 린넨우드봉족자 | B21 | A4/A3/A2 | 1 | 3 | (좌표 미상) | L1-clean |
| PRD_000135 | 족자포스터 | B17 | A3/A2/A1/300*600/900*1200 | 1 | 5 | JOKJA 1 placeholder | L1-clean |
| PRD_000136 | PET배너 | B23 | 600x1800 mm | 1 | 1 | (좌표 미상) | L1-clean |
| PRD_000137 | 메쉬배너 | B25 | 600x1800 mm | 1 | 1 | (좌표 미상) | L1-clean |
| PRD_000140 | 무광시트커팅 | B27(raw r288) | A4/A3/A2 | 1 | 3 | (없음) | L1-raw 복구 |
| PRD_000141 | 홀로그램 시트커팅 | B27(raw r289) | A4/A3/A2 | 1 | 3 | (없음) | L1-raw 복구 |
| PRD_000142 | 유광아크릴스티커 | B27(raw r295) | 290x90/290x190/390x290/590x390 mm | 1 | 4 | (없음) | L1-raw 복구 |
| PRD_000143 | 미러아크릴스티커 | B27(raw r296) | 290x90/290x190/390x290/590x390 mm | 1 | 4 | (없음) | L1-raw 복구 |
| PRD_000144 | 미니보드스탠딩 | B29 | A5/A4/A3 | 4/19/49/99/10000 | 15 | (좌표 미상) | L1-clean |
| PRD_000145 | 미니배너 | B31 | 150x300/180x420 mm | 4/19/49/99/10000 | 10 | (좌표 미상) | L1-clean |
| **소계(고정가)** | **15제품** | — | — | — | **73** | placeholder 10 (폐기) | — |

> **수량구간 관찰(규칙⑧ 준수)**: 액자류·족자·배너 13제품은 **qty=1 단일행**(개당 고정가, 수량스케일·할인은 외부=주문계산/round-1). 미니보드스탠딩·미니배너 2제품만 **5단 수량구간(4/19/49/99/10000)** 보유. → "고정가형"을 단일 base 단가로 저장하되, 한 제품을 단일유형으로 못박지 않음(규칙⑧).

---

## 2. 고정가 15 재추출 결과 (수량×규격) + 폐기할 오좌표

### 2.1 재추출 산출 (73 cells)
- **산출 CSV**: `02_mapping/load_price_correction/fixedprice-qty-spec-reextract.csv`
  - 컬럼: `prd_cd, product_nm, spec_option, min_qty, unit_price, source_block, recovery`
- **siz_cd 처리**: 고정가형의 규격옵션은 **좌표(WxH) 아님 → 규격옵션 코드 or NULL**. A4/A3/A2/A5 등 표준규격은 기존 siz 재사용(예: A4=SIZ_000258, A3=SIZ_000315 — `price-siz-mapping-inspection.md` §1-3 STK 동일), 비표준(5x5/300*600/600x1800/290x90 등)은 siz_cd 후보 탐색 필요(§6 플래그). **좌표 siz 발명 금지**.
- **공식모델 적재경로(규칙⑩)**: 고정가형 base 단가 → `t_prc_component_prices`(규격=siz_cd 또는 NULL, comp = 제품별 완제품비 `PRC_COMPONENT_TYPE.06`) 또는 단일가형은 `t_prd_product_prices`. 색상variant(폼보드 화이트/검정, 시트커팅 화이트/블랙)는 규칙③ `mat_cd` 차원.

### 2.2 폐기할 오좌표 placeholder
| 폐기대상 comp_cd (round-2 POSTER placeholder) | placeholder행 | 정정 |
|------|:----:|------|
| COMP_POSTER_LEATHER_FRAME | 4 | → PRD_000132 고정가 6 cells |
| COMP_POSTER_FRAMELESS_WOOD | 1 | → PRD_000131 고정가 3 cells |
| COMP_POSTER_JOKJA | 1 | → PRD_000135 고정가 5 cells |
| COMP_POSTER_FOAMBOARD_WHITE / _BLACK | 2 | → PRD_000129 고정가 6 cells |
| COMP_POSTER_FOMEXBOARD_WHITE3MM / _WHITE5MM | 2 | → PRD_000130 고정가 6 cells |
| **폐기 합계** | **10** | **→ 고정가 정상 재추출(26 cells, 위 5제품)** |

> 나머지 고정가 10제품(131제외 9 액자/배너/시트커팅/아크릴스티커/미니류)은 round-2 POSTER placeholder에 **부재**(좌표조차 미적재)였음 → 신규 추출이 손실복구.

---

## 3. 면적 13 + 아크릴 좌표 siz 등록목록 (distinct WxH)

### 3.1 산출
- **산출 CSV**: `02_mapping/load_price_correction/areamatrix-siz-registration.csv`
  - 컬럼: `group, width_mm, height_mm, wxh, match_status, existing_siz_cd, products`
  - `match_status`: **EXACT**(기존 siz 정방향 재사용) / **REVERSED**(역방향만 존재) / **NONE**(신규 등록 필요)

### 3.2 search-before-mint 결과 (라이브 497 siz 대조)

| group | distinct WxH | EXACT(재사용) | REVERSED(역방향) | NONE(신규등록) |
|-------|:----:|:----:|:----:|:----:|
| **POSTER (실사11+현수막2)** | 112 | 4 | 2 | **106** |
| **ACRYL (3소재 공유축)** | 196 | 64 | 27 | **105** |
| **합계** | **308** | **68** | **29** | **211** |

- **신규 등록 필요 = 211종** (POSTER 106 + ACRYL 105 NONE). 인간 승인 대상 = 이 211 좌표 siz 등록.
- **EXACT 68종**: 기존 라이브 siz 재사용(발명 0). 예: A1/A2/A3 표준규격, ACRYL 20x20=SIZ_000336 등.
- **REVERSED 29종 🟡**: 라이브에 역방향(HxW)만 존재 — POSTER 2, ACRYL 27. 후니 직접입력형(가로/세로 자유)이라 **면적 동일 시 역방향 재사용 정당** 가능하나 의미축(가로/세로) 보존 필요 시 신규. → §6 플래그.

### 3.3 좌표 siz 명명 컨벤션 (제안, 발명 아님)
- 신규 211종 siz_nm = `{width}x{height}` (라이브 컨벤션 `316x467`·`원형35x35`와 일관).
- siz_cd = `SIZ_000{498~}` 연번 신규 — **후니 코드마스터 등록 요청 대상**(직접 mint 금지). 등록요청서는 round-5 dbm-ddl-proposer가 생성.

---

## 4. 아크릴 면적 구조 (task 3 — 권위 ② 모델 확인·매핑)

후니 권위 ②: `아크릴 판매가 = 인쇄가공비 × 수량별구간할인 + 후가공(제작수량당)`. 원천 `price-acrylic-price-l1.csv` 7블록이 이를 정확히 구현:

| block | 내용 | distinct WxH | 가격셀 | 매핑 |
|-------|------|:----:|:----:|------|
| B01 | 투명아크릴3T (직접입력형) 양면9도/단면7도 통용단가 | 196 | 196 | `COMP_ACRYL_CLEAR3T` 면적매트릭스 → component_prices(siz=좌표, comp=인쇄가공비 .01) |
| B02 | 투명아크릴1.5T (직접입력형) | 81 | 81 | `COMP_ACRYL_CLEAR15T` 면적매트릭스 |
| B03 | 미러아크릴3T (직접입력형) 전면5도 | 81 | 81 | `COMP_ACRYL_MIRROR3T` 면적매트릭스 (수식: 미러=투명×2, 원천 평면값 그대로 적재) |
| B04 | 아크릴상품 **수량별 구간할인** | — | — | **round-1 t_dsc 영역**(외부 적용단). round-2 재매핑 금지(규칙⑨) |
| B05 | 아크릴코롯토 | — | — | 권위 ④ `인쇄가공비 × 수량구간할인`(별도, 고정가형④) |
| B06 | 아크릴카라비너 (투명3T+3T 접합) | — | — | 권위 ④ |
| B07 | 카라비너 수량별 구간할인 | — | — | round-1 t_dsc 영역 |

- **면적매트릭스 매핑 (round-2 면적매트릭스형 공식 연계)**: B01~B03 셀 = `t_prc_component_prices`(siz_cd=좌표, comp_cd=소재별 인쇄가공비, unit_price=셀값). **곱셈(×수량할인)·후가공은 공식 외부(적용단)** 처리(규칙⑤). 매트릭스 셀은 룩업값으로만 적재.
- **off-grid ceiling(권위 HARD)**: 가로×세로가 표에 정확히 없으면 **한 단계 큰 크기 가격** = 가격계산 런타임(위젯/엔진) 로직. **DB 미저장**(매트릭스만 저장).
- **수식 81(미러=투명×2)**: 원천이 이미 평면 단가값으로 전개됨 → 셀값 그대로 적재(재계산 금지).
- ACRYL 좌표 196 distinct는 §3 등록목록(NONE 105)에 포함. round-2가 149만 추출 → **47좌표 누락 복원**(B01 dense grid 14×14=196 vs round-2 149).

---

## 5. 재구성 검증 (task 4 — 무손실 대조)

> 정정 후 행수 = 면적(좌표) + 고정가(수량×규격) + 기존 GO + 차단잔여. 어느 셀도 증발하지 않음.

### 5.1 가격셀 보존 대조

| 구분 | round-2 (오모델) | 정정 후 (corrected) | 차이 |
|------|:----:|:----:|------|
| POSTER 면적 13제품 | ~670 placeholder행 (113 distinct, 누락有) | **687 cells** (112 distinct) | +17 (누락복원·헤더경계 정밀) |
| POSTER 고정가 15제품 | **10 placeholder행** (좌표1점 축약) | **73 cells** ([수량][규격] 전개) | +63 (오모델 정상화·복구) |
| ACRYL 면적 3소재 | 237 placeholder행 (149 distinct) | **358 cells** (196 distinct) | +121 (47좌표 누락복원) |
| **합계 가격셀** | — | **1,118 cells** | — |

### 5.2 무손실 판정
- **증발 0**: round-2 POSTER 680행 = 670 area(좌표 siz 교체로 보존) + 10 fixed(폐기되나 73 cells로 정상 재추출 = 손실 아님, 오히려 복구). ACRYL 237 → 358(누락 복원).
- **net 변화 = 전부 복구·정밀화 방향**(증가). round-2가 누락·축약했던 셀이 재추출로 살아남.
- **좌표 siz**: 308 distinct(POSTER 112 + ACRYL 196) 중 211 신규 등록 후 매트릭스 셀이 실 FK로 적재가능.

### 5.3 적재 경로 (정정 후)
1. **면적매트릭스 13+ACRYL**: 좌표 siz 211종 등록(후니 승인) → `t_prc_component_prices`(siz=좌표, comp=소재별, unit_price=셀) 적재. EXACT/REVERSED 68/29는 기존 재사용.
2. **고정가형 15**: 73 cells → `t_prc_component_prices`(siz=규격코드 or NULL, comp=완제품비 .06) 또는 단일가는 `t_prd_product_prices`. 색상variant=mat_cd(규칙③).
3. **off-grid ceiling**: 가격계산 런타임 규칙(DB 미저장).

---

## 6. 미해소·불확실 플래그 (정직 보고 — 추측 금지)

| # | 항목 | 상태 | 필요 결정/입력 |
|---|------|------|---------------|
| F-1 🟡 | **고정가 비표준 규격 siz** | 미해소 | 5x5/5x7/8x8/8x10(레더아트액자)·300*600/900*1200(족자)·600x1800(PET/메쉬배너)·290x90~590x390(아크릴스티커)·150x300/180x420(미니배너) — 라이브 siz 후보 탐색·등록 필요(좌표 발명 금지). 표준 A시리즈(A1~A5)는 기존 재사용. |
| F-2 🟡 | **시트커팅/아크릴스티커 색상축** | 부분해소 | 무광"(화이트/블랙)"·유광"(화이트/블랙)"·미러"(골드/실버)"는 **소재명에 색상 합성**(단일 가격행) → 색상 분리 단가 없음. round-2 mat variant(#6 결함큐)와 연계. 색상별 동일가면 mat_cd 무관 단일 적재. |
| F-3 🟡 | **REVERSED 29종 siz 재사용 여부** | 미해소 | POSTER 2 + ACRYL 27이 라이브 역방향(HxW)만 존재. 직접입력형이라 면적동일 시 재사용 정당 가능 vs 의미축 보존. `_acryl_siz_match.csv`(round-2) 참조. 후니 결정. |
| F-4 🟡 | **GUK4/실사 코팅포함가 합가** | 정합(규칙④) | 실사 note `완제품가[코팅포함가]` = 합가 그대로 적재(분해·재합산 금지). 추가 결정 불요, 확인만. |
| F-5 🟢 | **폼보드/포맥스/시트커팅/아크릴스티커 raw 재파싱** | 불요 | B11 concat·B27 raw영역에서 L1으로 전량 복구. raw xlsx 재파싱 불필요(값 100% 보존 확인). |
| F-6 🟡 | **현수막 가공옵션명/추가옵션명 컬럼** | 별도처리 | B26/B27 trailing 컬럼(가공옵션명·추가옵션명)은 면적 width 아님 → grid 추출서 제외(정상). 별도 add-on 옵션으로 처리 필요(본 정정 범위 외). |
| F-7 🟡 | **실사 11 분류 = 추론** | 후니 확인 | 면적매트릭스 = 실사 11(PRD_000118~128)은 후니 명시 아닌 추론(고정가 15만 후니 명시 확정). block 구조(B01~B11 = [세로][가로] grid)가 강한 증거이나 후니 확인 1건. |

---

## 7. read-only 준수 / 산출물

- **실행**: 파일읽기 + 로컬 파싱만. 라이브 DB SELECT 미실행(siz 대조는 기존 `ref-sizes.csv` 덤프 사용). INSERT/UPDATE/DDL/COMMIT **0**. 비밀번호 미출력.
- **발명·DB쓰기·코드 mint 0**. siz는 search-before-mint(EXACT/REVERSED 우선, NONE만 신규제안). 신규 211 siz는 **등록 요청 대상**(직접 등록 아님).
- **산출**:
  - 본 문서 `02_mapping/price-correction-poster-sign.md`
  - `02_mapping/load_price_correction/fixedprice-qty-spec-reextract.csv` (고정가 15제품 [수량][규격] 73 cells)
  - `02_mapping/load_price_correction/areamatrix-siz-registration.csv` (면적 POSTER+ACRYL 308 distinct 좌표 siz, search-before-mint 상태)

## 부록 A. 재현 명령
- 고정가 재추출: `06_extract/price-poster-sign-l1.csv` 의 B13/B15/B17/B19/B21/B23/B25/B29/B31(clean) + B11 concat(폼보드/포맥스) + B27 r286-299(시트커팅/아크릴스티커).
- 면적 좌표: 동 파일 B01~B11/B26/B27 = [세로(row_key)][가로(header value)] grid. ACRYL = `price-acrylic-price-l1.csv` B01~B03.
- siz 대조: `00_schema/ref-sizes.csv` work/cut 치수 양방향(EXACT/REVERSED) 매칭.
