# 매핑 설계서 — 실사 고정가형(fixed-grid) 가격 (price-211 Phase-1, slice C3)

| 항목 | 값 |
|------|----|
| 생성 | dbm-mapping-designer (dbm-price-formula 스킬) |
| 일자 | 2026-06-07 |
| 트랙 | price-211 Phase-1, **고정가형([수량×규격]) 전용** (slice C3) |
| 권위 순서 | 라이브 DDL/존재 > 가격표 엑셀 "포스터사인" 명시값 > `06_extract` L1 스냅샷 > 설계 |
| 가격 DDL 권위 | `00_schema/price-engine-ddl.md` (컬럼명/타입/C-1~C-9) |
| 검증 | 본 문서는 **생성**. 독립 재검증(dbm-validator)은 별도 단계 |

> ## [HARD · USER RULE 적용 — 절대 준수]
> 본 트랙 15상품은 상품마스터 **실사** 시트 소속이다. 가격은 실사 시트 inline price
> 컬럼(`R=price`, `S==SUM(R)*1.1` VAT, `V=가공가`)을 권위로 쓰지 **않았다**.
> 가격 권위 = 인쇄상품 가격표 **"포스터사인"** 시트(`06_extract/price-poster-sign-l1.csv`)의
> **고정가형 블록 = [수량(행) × 규격(A3/A2/A1·소형, 열)] 구조**(title 블록 + `사이즈/수량`
> 블록 쌍, 또는 `사이즈/옵션명`·`사이즈/소재` 블록).
>
> **[HARD] 이건 면적매트릭스([가로×세로])가 아니라 고정가형([수량×규격])이다.**
> slice A(면적매트릭스 13상품, `02_mapping/silsa-poster-area-matrix/`)와 **혼동 금지**.
> - slice A: 셀 = (가로mm 열, 세로mm 행) 좌표쌍 → siz_cd=치수조합, 비대칭, 수량축 없음.
> - 본 slice C3: 셀 = (규격 열[A3/A2/A1/소형], 수량/옵션 행) → siz_cd=표준규격,
>   수량축은 `사이즈/수량` 블록에만 존재(min_qty).
> round-2 가 이 15(15+1)를 면적-좌표(SIZ_PENDING_POSTER)로 오모델했다는 메모리 기준의
> 정정 대상이다. **단, 라이브 실측 결과 round-2 는 실제로는 고정가형으로 비교적 정확히
> 적재돼 있었다(§1.3 live-vs-doc 모순).** 본 트랙은 누락 셀 채움 = sparse-fill 정정.
>
> 권위 = 메모리 `dbmap-silsa-price-via-poster-sign`(포스터사인 가격표 토대) +
> `dbmap-price-formula-types-authority`(고정가형 = [수량 행][옵션 열], 면적 무관).

---

## 1. SCOPE & STATUS — 실사 ↔ 포스터사인 ↔ 라이브 (read-only 실측)

### 1.1 본 트랙 상품 = 15 prd_cd (SCOPE "16"의 정정)

실사 시트 29 distinct 상품 중 **고정가형 15상품**이 본 트랙(slice C3) 대상.
slice A 면적매트릭스 13 + 투명포스터★(방수와 ID공유, 행숨김) 은 본 트랙 밖.

> [정정] TASK SCOPE 가 "16(15+1)"이라 했으나 **prd_cd 는 15개**다. "16"은
> 포맥스보드의 옵션 `화이트포맥스(3mm)`/`화이트포맥스(5mm)`를 별도 상품으로 셀 때의
> 수치다. 라이브 실측: 포맥스 3mm/5mm 는 **포맥스보드 1상품(PRD_000130) 안의 옵션(행)**
> 이며 가격은 옵션별 comp_cd 2종으로 흡수(아래 §2). 폼보드(화이트보드/블랙보드),
> 시트커팅(무광/홀로그램), 아크릴스티커(유광/미러)도 동일 구조 — 옵션은 상품분리 아닌
> 가격 차원/comp 분리. 따라서 **상품 15, comp_cd 17**(옵션 분리분 +2).

### 1.2 15상품 ↔ prd_cd ↔ comp_cd ↔ 가격표 블록 (전수 매핑, 라이브 검증)

| 실사ID | 상품 | prd_cd | comp_cd | 가격표 블록(provenance) | 셀수 | min_qty축 |
|---|---|---|---|---|--:|---|
| 14575 | 폼보드 | PRD_000129 | `COMP_POSTER_FOAMBOARD_WHITE`·`_BLACK` | 포스터사인 B11 r190/191 (사이드 미니표) | 6 | 없음(NULL) |
| 14576 | 포맥스보드 | PRD_000130 | `COMP_POSTER_FOMEXBOARD_WHITE3MM`·`_WHITE5MM` | 포스터사인 B11 r196/197 | 6 | 없음(NULL) |
| 14577 | 프레임리스우드액자 | PRD_000131 | `COMP_POSTER_FRAMELESS_WOOD` | 포스터사인 B13 r202 | 3 | 1 |
| 14578 | 레더아트액자 | PRD_000132 | `COMP_POSTER_LEATHER_FRAME` | 포스터사인 B15 r207 | 6 | 1 |
| 14579 | 캔버스 행잉포스터 | PRD_000133 | `COMP_POSTER_CANVAS_HANGING` | 포스터사인 B19 r218 | 3 | 1 |
| 14580 | 린넨 우드봉 족자 | PRD_000134 | `COMP_POSTER_LINEN_WOODBONG` | 포스터사인 B21 r225 | 3 | 1 |
| 19311 | 족자포스터 | PRD_000135 | `COMP_POSTER_JOKJA` | 포스터사인 B17 r212 | 5 | 1 |
| 14581 | PET배너 | PRD_000136 | `COMP_POSTER_PET_BANNER` | 포스터사인 B23 r231 | 1 | 1 |
| 14582 | 메쉬배너 | PRD_000137 | `COMP_POSTER_MESH_BANNER` | 포스터사인 B25 r240 | 1 | 1 |
| 14585 | 무광시트커팅 | PRD_000140 | `COMP_POSTER_SHEETCUT_MATTE` | 포스터사인 B27 r288 (사이드 미니표) | 3 | 없음(NULL) |
| 14586 | 홀로그램 시트커팅 | PRD_000141 | `COMP_POSTER_SHEETCUT_HOLO` | 포스터사인 B27 r289 | 3 | 없음(NULL) |
| 14587 | 유광아크릴스티커 | PRD_000142 | `COMP_POSTER_ACRYLSTK_GLOSS` | 포스터사인 B27 r295 | 4 | 없음(NULL) |
| 14588 | 미러아크릴스티커 | PRD_000143 | `COMP_POSTER_ACRYLSTK_MIRROR` | 포스터사인 B27 r296 | 4 | 없음(NULL) |
| 14590 | 미니보드스탠딩 | PRD_000144 | `COMP_POSTER_MINI_STANDBOARD` | 포스터사인 B29 r302-306 | 15 | 4/19/49/99/10000 |
| 14591 | 미니배너 | PRD_000145 | `COMP_POSTER_MINI_BANNER` | 포스터사인 B31 r312-316 | 10 | 4/19/49/99/10000 |
| **합계** | **15상품** | | **17 comp** | | **73** | |

매핑 방식 = **상품명 1:1**(prd_nm JOIN only — `t_prd_products.prd_nm`). 충돌 0.
**13 규격 siz_cd 전부 라이브 선존재**(search-before-mint 성공, §3) → **BLOCKED 0**.

### 1.3 라이브 바인딩 상태 분류 + **live-vs-doc 모순 적발** (적대적 점검)

라이브 실측: 15상품 **전부 `n_formula_bind=1`(PRF_POSTER_FIXED), `n_direct_price=0`**.
**UNPRICED 0건.** round-2 가 골격을 깔고 단가를 적재한 상태.

| 분류 | 정의 | 해당 | 행동 |
|------|------|:--:|------|
| (i) UNPRICED | 바인딩·단가 둘 다 없음 | 0 | — |
| (ii) ALREADY-PRICED + 셀 누락(sparse) | 바인딩 존재·단가 일부만 | **15** | **CORRECTION+EXPANSION**(누락 셀 채움) |
| (iii) ALREADY-PRICED 전건 정확 | 가격표 전건 적재됨 | (부분) | 9상품은 사실상 완전, 6상품만 누락 |

**[핵심 적발 1 — live-vs-doc 모순]**: 메모리 `dbmap-price-formula-types-authority` 와
slice A `mapping.md §5` 는 "round-2 가 이 15(15+1)를 **면적-좌표로 오모델**"이라 단정한다.
**그러나 라이브 component_prices 실측 결과 round-2 는 이 15상품을 실제로는 고정가형
[수량×규격] 구조로 적재**(예 `COMP_POSTER_MINI_STANDBOARD` 15셀 = A5/A4/A3 × 5수량구간
전건, `COMP_POSTER_ACRYLSTK_GLOSS` 4규격 전건). 면적-좌표(SIZ_PENDING_POSTER)로
오모델된 것은 slice A 면적매트릭스 13상품이지 본 고정가형 15가 아니다. → **본 트랙은
"면적-좌표 오모델 정정"이 아니라 "고정가형 sparse 셀 누락 채움(EXPANSION)"이다.**

**[핵심 적발 2 — round-2 단가 정합 100%]**: 본 추출 73셀 중 **63셀이 라이브와
자연키+단가 완전 일치(멱등 no-op), 단가 불일치(price conflict) 0건**. round-2 의
고정가형 단가 적재는 포스터사인 명시값과 100% 일치.

**[핵심 적발 3 — 누락 셀 10개(EXPANSION fill)]**: round-2 가 빠뜨린 셀 = 본 트랙이 채움.

| comp_cd | 누락 규격 | 채움 셀수 | round-2 적재 | 본 트랙 후 |
|---|---|--:|---|---|
| COMP_POSTER_FOAMBOARD_WHITE | A1(SIZ_000293) | 1 | A3/A2 | A3/A2/A1 |
| COMP_POSTER_FOAMBOARD_BLACK | A1 | 1 | A3/A2 | A3/A2/A1 |
| COMP_POSTER_FOMEXBOARD_WHITE3MM | A1 | 1 | A3/A2 | A3/A2/A1 |
| COMP_POSTER_FOMEXBOARD_WHITE5MM | A1 | 1 | A3/A2 | A3/A2/A1 |
| COMP_POSTER_FRAMELESS_WOOD | A1 | 1 | A3/A2 | A3/A2/A1 |
| COMP_POSTER_JOKJA | A1 | 1 | A3/A2/300x600/900x1200 | +A1 |
| COMP_POSTER_LEATHER_FRAME | 5x5/5x7/8x8/8x10 | 4 | A4/A3 | +소형 4규격 |
| **합계** | | **10** | | |

> [적대적 주의] "round-2 가 면적-좌표로 오모델했으니 전건 재적재(DELETE+INSERT)"는
> **과잉 정정**이다. 라이브 63셀은 정확하므로 멱등 no-op 으로 보존하고, **누락 10셀만
> 추가**한다. 단가가 모두 일치하므로 정정 손실 0.

---

## 2. FIXED-GRID EXTRACTION → component_prices long-form

### 2.1 블록 구조 (3가지 헤더 유형)
포스터사인 고정가형 블록은 **[행 × 규격(열)]** 격자이며 **행 축이 3가지**:

| 헤더 유형 | A열 의미 | 행 축 매핑 | 해당 상품 |
|---|---|---|---|
| `사이즈 / 수량` | 수량값(1·4·19…) | `min_qty` = A열 명시값 | 액자·족자·캔버스·린넨·PET·메쉬·미니류 |
| `사이즈 / 옵션명` | 옵션명(화이트보드…) | 옵션별 **별도 comp_cd**, min_qty=NULL | 폼보드·포맥스 |
| `사이즈 / 소재` | 소재명(무광/유광…) | 소재별 **별도 comp_cd**, min_qty=NULL | 시트커팅·아크릴스티커 |

**열(규격) = siz_cd 차원.** 단일가 상품도 A열 헤더가 `수량`이고 값이 `1`이면 **min_qty=1
명시 적재**(가격표 명시값 권위 — round-2 도 동일하게 1 적재. NULL 처리 안 함). 수량축이
아예 없는 헤더(`옵션명`/`소재`)만 min_qty=NULL.

### 2.2 셀단가 (코팅포함 통가격)
본문 셀 value = `unit_price`. 포스터사인 INCL 주석(`출력+코팅+가공 포함가`)대로
**코팅·가공 포함 통가격** → 분해 불요(규칙④ 합가 그대로, comp_typ_cd=.06 완제품비).

### 2.3 평면화 결과 + **제외 영역**
73 본문 셀 → 73 long-form `(comp_cd, siz_cd=규격, min_qty, unit_price)` 행.
provenance = `price-poster-sign-l1.csv:{block_id}:{cell_ref}|prd|siz_label`.

**[제외 — 본 PRICE 트랙 밖]**: 각 블록의 J~M 사이드(추가옵션) =
천정형고리(족자)·우드행거+면끈(캔버스/린넨)·실내외 배너거치대(PET)·가공옵션/추가옵션
(현수막류) → **round-6 CPQ 옵션레이어 소관**(별도 add-on comp `COMP_POSTEROPT_*`로 이미
일부 라이브 존재). 본 트랙은 **본체 단가 셀(B~G 규격열)만** 추출.

---

## 3. siz_cd RESOLUTION (search-before-mint) — **BLOCKED 0**

각 규격 라벨 → 라이브 `t_siz_sizes` 검색. **18 siz_cd 전부 선존재**(slice A 의 108 BLOCKED
와 정반대 — 고정가형은 표준 A시리즈/소형 규격이라 전부 등록됨). **신규 siz mint 불요.**

| 규격 라벨 | siz_cd | siz_nm | cut(WxH) | 비고 |
|---|---|---|---|---|
| A1 | `SIZ_000293` | A1(594x841mm) | 594×841 | A2/A3/A4/A5 와 명명패턴 약간 상이(설계결정 D-A1) |
| A2 | `SIZ_000317` | A2 | 420×594 | round-2 선례 |
| A3 | `SIZ_000315` | A3 | 297×420 | round-2 선례 |
| A4 | `SIZ_000258` | A4 | 210×297 | |
| A5 | `SIZ_000426` | A5 | 148×210 | |
| 5x5 | `SIZ_000304` | 5x5(127x127mm) | 127×127 | 레더아트액자 |
| 5x7 | `SIZ_000306` | 5x7(127x178mm) | 127×178 | |
| 8x8 | `SIZ_000308` | 8x8(203x203mm) | 203×203 | |
| 8x10 | `SIZ_000310` | 8x10(203x254mm) | 203×254 | |
| 300*600 | `SIZ_000319` | 300x600 | 300×600 | 족자 |
| 900*1200 | `SIZ_000320` | 900x1200 | 900×1200 | 족자 |
| 600x1800 mm | `SIZ_000321` | 600x1800 | 600×1800 | PET/메쉬 배너 |
| 150x300 mm | `SIZ_000028` | 150x300 | 150×300 | 미니배너 |
| 180x420 mm | `SIZ_000328` | 180x420 | 180×420 | 미니배너 |
| 290 x 90 mm | `SIZ_000324` | 290x90 | 290×90 | 아크릴스티커 |
| 290 x 190 mm | `SIZ_000325` | 290x190 | 290×190 | |
| 390 x 290 mm | `SIZ_000326` | 390x290 | 390×290 | |
| 590 x 390 mm | `SIZ_000327` | 590x390 | 590×390 | |

---

## 4. FORMULA + COMPONENT + BINDING 설계

### 4.1 공식 (라이브 선존재 — 신규 mint 불요)
- `frm_cd = PRF_POSTER_FIXED`(라이브 존재, `frm_typ_cd = FRM_TYPE.02` 단순형).
- 의미 = "포스터사인 소재/사이즈/수량별 완제품가(포함항목 통가격)" 단일 룩업.

### 4.2 구성요소 (라이브 선존재 — 17 comp 전부 존재)
- comp_cd 17종 모두 라이브 존재(read-only 확인). `comp_typ_cd = PRC_COMPONENT_TYPE.06
  완제품비`(코팅·가공 포함 통가격, C-6/규칙⑩). clr_cd 미사용(별색=공정 G-1 무관).
- **신규 comp mint 불요.**

### 4.3 공식↔구성요소 배선 — **GAP 적발(F-WIRE)**
- 라이브 `t_prc_formula_components` 의 `PRF_POSTER_FIXED` 배선 = **`COMP_POSTER_ARTPRINT_PHOTO`
  단 1행뿐**. 본 트랙 17 comp 중 **0개가 배선되어 있지 않다.**
- slice A `mapping.md §4.3` 은 "13 comp 배선 라이브 확인됨, 신규 INSERT 불요"라 했으나
  **라이브 실측은 1개뿐** — slice A 의 over-claim. (본 트랙은 적발만; slice A 검증분 정정은
  별도.)
- **본 트랙은 `t_prc_component_prices` 단가 행만 적재**(slice A 와 동일 스코프).
  formula_components 배선 부재는 **가격엔진 조회 경로 GAP**(prd→comp 연결 끊김)이나, 배선
  INSERT 는 본 PRICE 데이터 트랙 범위 밖 → **설계결정 D-WIRE 로 인간 확인 상신**(§8).

### 4.4 상품 바인딩 (라이브 선존재)
- `t_prd_product_price_formulas` (15 prd_cd ↔ PRF_POSTER_FIXED) 라이브 15/15 존재. 신규
  INSERT 불요.

> **결론**: 본 트랙이 적재하는 것은 `t_prc_component_prices` 단가 행뿐(신규 10 EXPANSION
> + 멱등 no-op 63). 공식/구성요소/바인딩은 라이브 선존재. 단 formula_components 배선
> GAP(F-WIRE)은 별도 상신.

---

## 5. 제약 준수 (C-1~C-9, price-engine-ddl §7)

| 제약 | 준수 방법 |
|------|-----------|
| C-1 apply_ymd | varchar(10) `'2026-06-01'` 전건(round-1/2 통일) |
| C-2 자연키 8 dedup | (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty) CSV 내 중복 0(검증) |
| C-3 max_qty 부재 | 미니류 min_qty 4/19/49/99/10000 상향개방(마지막=무제한). max_qty 안 만듦 |
| C-5 FRM_TYPE | 신규 공식 mint 없음. 라이브 PRF_POSTER_FIXED(FRM_TYPE.02) 유지 |
| C-6 comp_typ_cd | comp 신규 mint 없음. 라이브 .06 완제품비 유지 |
| C-9 NULL≠'' | 미사용 차원(clr/mat/coat/bdl/일부 min_qty)은 SQL NULL. CSV 공란→NULL 변환(헤더 주석) |
| reg_dt NOT NULL | `now()` 명시(round-5 적발: 명시 NULL 은 DEFAULT 미발화) |
| **IDENTITY stale** | **MAX(id)=4971 > seq.last_value=4954 (stale).** `setval(...)` 재동기 가드 필수(메모리 lesson) |
| **NULLS DISTINCT 멱등 함정** | **자연키 UNIQUE 인덱스가 NULLS DISTINCT(기본)** → NULL 차원 행은 ON CONFLICT 미발화 → 중복 INSERT. **ON CONFLICT 대신 `NOT EXISTS(IS NOT DISTINCT FROM)` 가드**로 멱등 보장 |

---

## 6. 산출 파일

| 파일 | 내용 | 행수 |
|------|------|:--:|
| `load/t_prc_component_prices_INSERTABLE.csv` | siz 선존재 셀 전건 | 73 |
| `load/t_prc_component_prices_BLOCKED.csv` | siz 미등록 셀 | **0**(헤더만) |
| `load.sql` | 멱등 INSERT(NOT EXISTS 가드) + 단계0 FK검증 + setval 가드 | — |
| `dryrun-plan.md` | DRY-RUN 게이트 + 설계자 사전점검(R1~R6) | — |
| `README.md` | 트랙 요약·USER RULE·실행 절차 | — |

CSV 공란 = NULL 규약. 헤더 = DB 컬럼명. `_provenance` = 추적 보조컬럼(적재 시 제외 —
load.sql VALUES 에 미포함).

---

## 7. 본 트랙 밖 (명시)

- **slice A 면적매트릭스 13상품** = `02_mapping/silsa-poster-area-matrix/`(별도 트랙).
- **추가옵션(천정형고리·우드행거·배너거치대·현수막 가공/추가)** = round-6 CPQ 옵션레이어.
- **substrate 자재행(폼보드/포맥스/액자 본체=자재 .03, Phase-0 결정)** = 차원 사안,
  본 PRICE 트랙 밖.
- **formula_components 배선(F-WIRE GAP)** = 별도 상신(D-WIRE, §8).

---

## 8. 설계결정 — 인간 확인 필요

| ID | 결정사항 | 권고 |
|----|----------|------|
| D-A1 | A1 규격 siz_cd = `SIZ_000293`(명명 `A1(594x841mm)`). A2/A3 는 단순 `A2`/`A3` 명명이라 패턴 불일치 | **SIZ_000293 채택**(라이브 유일 A1 표준규격, work/cut=594×841 정확). 단순 `A1` 명명 siz 부재 확인. round-2 가 A1 을 빠뜨린 원인이 이 모호성으로 추정 |
| D-WIRE | formula_components 배선 = `PRF_POSTER_FIXED`에 본 17 comp 미배선(라이브 ARTPRINT 1개뿐). 가격엔진 prd→comp 조회 경로 끊김 | **별도 배선 INSERT 트랙 필요**(17행 + slice A 13행). 본 데이터 트랙 밖. slice A `§4.3` over-claim 동반 정정 권고 |
| D-OPT | 옵션(화이트/블랙보드·3mm/5mm·무광/홀로그램·유광/미러)을 **별도 comp_cd**로 분리(round-2 패턴) vs mat_cd 차원 | **round-2 패턴(comp 분리) 유지**(라이브 선존재). mat_cd 차원 재모델은 변경 과잉 |
| D-MINQ | 단일가 상품 min_qty = `1`(가격표 명시값) vs NULL(수량무관) | **min_qty=1 적재**(포스터사인 `사이즈/수량` 헤더에 `1` 명시 = 명시값 권위. round-2 동일). 옵션/소재 헤더(폼보드·시트커팅·아크릴)만 NULL |
