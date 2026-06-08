# Price-211 트랙 계획서 (무가격 211상품 가격적재 Phase-1 스코핑)

| 항목 | 값 |
|------|----|
| 작성 | dbm-excel-analyst |
| 일자 | 2026-06-07 |
| 성격 | **PLAN ONLY** — DB 쓰기·실추출·적재 없음. 형태(SHAPE)·가용성(FEASIBILITY) 스코핑 |
| 권위 순서 | 가격표/상품마스터 엑셀 명시값 > `06_extract` L1 스냅샷 > 설계문서. **라이브 존재=라이브 권위** |
| 권위 문서 | 가격 2경로 = `00_schema/price-engine-ddl.md §5` |

> **[HARD·사용자 규칙 2026-06-07] 실사 시트 가격 = 포스터사인 매트릭스 구성으로 처리.**
> 상품마스터 **실사** 시트 상품(현수막·포스터·보드·배너 등 면적형)의 가격은 실사 시트
> 자체 inline price 컬럼(R=`price`·S=`=R×1.1` VAT·V=가공가)을 권위로 쓰지 **말고**,
> 인쇄상품 가격표 **"포스터사인"** 시트(`06_extract/price-poster-sign-l1.csv`)의
> **[가로 × 세로] 치수 면적 매트릭스 구성**을 토대로 처리한다 →
> `t_prc_component_prices`(siz_cd 차원=치수조합) + 면적매트릭스 공식(FRM_TYPE.01 + siz 차원)
> + 상품 바인딩. off-grid=한 단계 큰 치수 ceiling(앱 런타임). **round-2 면적-좌표 회귀
> 오모델링 전철 금지**(매트릭스+ceiling). 권위 메모리 `dbmap-silsa-price-via-poster-sign`.
> 실사 R/S 단일가는 요약 참고치일 뿐 적재 권위 아님 — **실사 접근 시 이 규칙 위반 금지.**

## 0. 라이브 ground truth (2026-06-07, read-only 실측)

```
t_prd_products                  = 275
t_prd_product_price_formulas    =  64 (DISTINCT prd_cd, 공식 바인딩)
t_prd_product_prices            =   0 (직접가, 전무)
무가격(둘 다 없음) 211          = 275 - 64 = 211  ← 본 트랙 대상
```

- 가격 2경로(권위 `price-engine-ddl.md §5`):
  - **(A) 공식 경로**: `t_prd_product_price_formulas`(바인딩) → `t_prc_*`(formula/components/component_prices). round-2~5가 다룬 64상품(디지털인쇄·포스터·봉투·스티커 등 면적/고정그리드/원자합산).
  - **(B) 직접가 경로**: `t_prd_product_prices(prd_cd, apply_ymd → unit_price)`. "(가격포함)" 상품(문구/굿즈파우치/포토북 등 고정가). **라이브 0건 — 한 번도 추출·조립된 적 없음.** `price-info-deferred.md`는 "이연" 라벨만 붙였을 뿐 실제 추출/적재 미수행.
- 본 트랙 = 211상품을 (A) 또는 (B)로 분기해 가격을 채우는 작업. **직접가 경로(B)가 핵심 미개척 영역.**

## 1. 211 무가격 상품 — family별 enumerate (라이브 실측)

main category(`main_cat_yn='Y'` 우선) 기준 leaf 카테고리명으로 그룹. **37 leaf family, 합계 = 211 (검증됨).**
주의: leaf 중 11개(상품악세사리·단품형·명함·플래너·소품·데스크/사무용품·말랑·디지털악세서리·레더파우치·에코백부자재 등)는 `cat_lvl=3`인데 `upr_cat_cd=NULL`인 **고아 카테고리**(level-1 root까지 climb 불가) — 데이터 관찰사항으로 기록(트리 손상이 아니라 이 상품군이 사실상 최상위 취급).

### 1.1 8개 super-family 롤업 (= 211, 검증됨)

| # | super-family | 무가격 상품수 | 주 prd_typ | 가격경로 |
|---|--------------|:----:|----|----|
| F1 | 굿즈/파우치/에코백/라이프 (goods-pouch 시트) | **123** | .03 기성상품 | (B) 직접가 |
| F2 | 아크릴 — 단품형(14)+조합형(11) | **25** | .04 디자인상품 | (A) 면적매트릭스 공식 |
| F3 | 하드커버책자(22)/포토북(8)/엽서북(2)/떡메(1) | **33** | .02 반제품 | (A) 매트릭스/페이지밴드 공식 |
| F4 | 스티커 | **12** | .04 | (A) 사이즈판수×소재 매트릭스 공식 |
| F5 | 명함 | **7** | .04 | (A) 단/양면×소재 매트릭스 공식 |
| F6 | 캘린더 — 탁상(2)/벽걸이(2)/엽서캘린더(1) | **5** | .04 | (B) 직접가(design-calendar) + 일부 책자형 |
| F7 | 봉투/추가상품 — 카드봉투·트레싱지봉투 | **3** | .05 추가상품 | (B) 직접가(product-accessory/envelope) |
| F8 | 엽서/홍보물/접지카드 (digital-print 잔여) | **3** | .04 | (A) 디지털인쇄 공식 잔여 |
|  | **합계** | **211** |  |  |

### 1.2 leaf family 상세 (37개, 합계 211)

| leaf family | leaf cat_cd | 수 | prd_typ | super |
|----|----|:--:|----|:--:|
| 하드커버책자 | CAT_000105 | 22 | .02/.04 | F3 |
| 상품악세사리 | CAT_000293 | 15 | .03 | F1 |
| 단품형 | CAT_000299 | 14 | .04 | F2 |
| 스티커 | CAT_000002 | 12 | .04 | F4 |
| 조합형 | CAT_000155 | 11 | .04 | F2 |
| 레더파우치 | CAT_000305 | 9 | .03 | F1 |
| 데스크/사무용품 | CAT_000302 | 9 | .03 | F1 |
| 말랑(PVC고주파) | CAT_000304 | 9 | .03 | F1 |
| 포토북 | CAT_000108 | 8 | .02/.04 | F3 |
| 라이프 | CAT_000010 | 8 | .03 | F1 |
| 패브릭에코백 | CAT_000254 | 8 | .03 | F1 |
| 필통 | CAT_000243 | 7 | .03 | F1 |
| 명함 | CAT_000294 | 7 | .04 | F5 |
| 플래너 | CAT_000300 | 5 | .03 | F1 |
| 노트 | CAT_000124 | 5 | .03 | F1 |
| 기념품/액세서리 | CAT_000189 | 5 | .03 | F1 |
| 소품 | CAT_000301 | 5 | .03 | F1 |
| 패션 | CAT_000206 | 5 | .03 | F1 |
| 패브릭파우치 | CAT_000222 | 5 | .03 | F1 |
| 미니파우치 | CAT_000237 | 5 | .03 | F1 |
| 타이벡에코백 | CAT_000263 | 5 | .03 | F1 |
| 타이벡파우치 | CAT_000228 | 5 | .03 | F1 |
| 여행/아웃도어 | CAT_000181 | 4 | .03 | F1 |
| (카테고리없음=봉투) | — | 3 | .05 | F7 |
| 디지털악세서리 | CAT_000303 | 2 | .03 | F1 |
| 레더에코백 | CAT_000251 | 2 | .03 | F1 |
| 탁상형캘린더 | CAT_000112 | 2 | .04 | F6 |
| 벽걸이캘린더 | CAT_000115 | 2 | .04 | F6 |
| 엽서북 | CAT_000026 | 2 | .02 | F3 |
| 메쉬파우치 | CAT_000234 | 2 | .03 | F1 |
| 메쉬에코백 | CAT_000269 | 2 | .03 | F1 |
| 엽서 | CAT_000001 | 1 | .04 | F8 |
| 인쇄홍보물 | CAT_000003 | 1 | .04 | F8 |
| 엽서캘린더 | CAT_000114 | 1 | .04 | F6 |
| 접지카드 | CAT_000021 | 1 | .04 | F8 |
| 떡메모지 | CAT_000129 | 1 | .02 | F3 |
| 에코백부자재 | CAT_000306 | 1 | .03 | F1 |

## 2. family별 가격 SOURCE 위치 + 형태 검증

[검증 원칙] "이연됨"을 "완료됨"으로 합리화하지 않는다. 가격이 source에 **실재**하는지 L1 값 채움률로 확인.

### F1 굿즈/파우치/에코백/라이프 (123) — goods-pouch 시트 직접가
- SOURCE: 상품마스터 `굿즈파우치(가격포함)` → `goods-pouch-l1.csv` (303행).
- 가격컬럼 채움률(실측): `가격` **254/303 numeric**, `가공(옵션)_가격` 14/303, `추가상품(옵션)_추가가격` 36/303, `선택(옵션)_가격` 0/303(빈컬럼).
- 형태: **상품행당 단일 고정가(direct)**. 예 틴거울 3000, 컴팩트거울 3600.
- 추출단위: **per prd_cd** (단, 변형행 주의 — §5 R-옵션변형).
- (가) 가격 실재? **YES** (주 상품). (나) 형태 = **direct**. (다) 타깃 = `t_prd_product_prices`.
- DATA-GAP: 22개 distinct 상품명이 blank-price 행 보유(말랑키링·캔버스에코백·머그컵 등). 일부는 옵션변형행(가격이 다른 행에), 일부는 진짜 품절/준비중(그레이밴딩, L1 meta `fill=gray`).

### F2 아크릴 단품형+조합형 (25) — acrylic 시트 면적매트릭스 공식
- SOURCE: 상품마스터 `아크릴` → `acrylic-l1.csv`; 가격표 `아크릴` → `price-acrylic-price-l1.csv`(면적매트릭스+구간할인+수식81).
- 검증: acrylic-l1 distinct 상품명 25종이 211의 단품형·조합형 product명과 **정확히 일치**(아크릴키링·판아크릴·포카코롯토·맥세이프스마트톡 등).
- 형태: **면적매트릭스형 공식** (`dbm-price-formula` 권위: [세로][가로] 매트릭스 + off-grid ceiling). **direct 아님.**
- 추출단위: per (size cell). 타깃 = `t_prc_component_prices` + formula + 바인딩.
- (가) YES (가격표 면적매트릭스 실재). (나) **matrix/formula**. (다) `t_prc_*`.
- 주의: round-2가 28 포스터상품 면적-좌표 오모델링한 전례 → **후니 권위공식(면적매트릭스+ceiling)** 으로. 아크릴 구간할인은 round-1에서 이미 t_dsc 매핑됨(중복 적재 금지).

### F3 하드커버책자/포토북/엽서북/떡메 (33) — 제본·엽서북떡메 매트릭스
- SOURCE: 상품마스터 `책자`(booklet-l1) + `포토북`(photobook-l1, 가격포함) / 가격표 `제본`(price-binding), `엽서북떡메`(price-postcard-book).
- 검증: price-binding `제본비` 블록(제본종류×수량 매트릭스), price-postcard-book `엽서북`/`떡메` 블록(사이즈×인쇄×페이지×수량 4축 3밴드) 실재.
- photobook-l1: `가격_기본(24P)` 11/14, `가격_추가(2P)당` 11/14 — **페이지밴드형**(기본P + 추가 2P당). booklet은 가격표 별도(제본 매트릭스).
- 형태: **매트릭스/페이지밴드 공식.** direct 아님.
- (가) YES. (나) **matrix/formula** (포토북은 기본가+증분 → 공식). (다) `t_prc_*` + formula.
- DATA-GAP: photobook 3행 blank(편집기 핑크사양). 하드커버책자 22 중 일부는 제본옵션 조합 → 공식 구성요소 전개 필요.

### F4 스티커 (12) — 스티커 가격표 매트릭스
- SOURCE: 가격표 `스티커` → `price-sticker-price-l1.csv` (7블록: 반칼 자유형/규격×사이즈판수×소재 + 완칼 다상품).
- 형태: **사이즈판수×소재 매트릭스 공식.** (round-5가 동형 64상품 일부 처리; 12는 미바인딩.)
- (가) YES. (나) **matrix/formula.** (다) `t_prc_*` + formula.

### F5 명함 (7) — 명함포토카드 가격표 매트릭스
- SOURCE: 가격표 `명함포토카드` → `price-namecard-photocard-l1.csv` (12블록: 명함 다상품×단/양면×소재).
- 형태: **단/양면×소재 매트릭스 공식.**
- (가) YES (스탠다드명함 등 블록 실재). 단 펄/투명/형압/모양명함이 가격표 블록과 1:1 매칭되는지 **매핑단계 확인 필요**(소재/가공 변형).
- (나) **matrix/formula.** (다) `t_prc_*` + formula.

### F6 캘린더 (5) — design-calendar 직접가 + 일부 책자형
- SOURCE: 상품마스터 `디자인캘린더(가격포함)` → `design-calendar-l1.csv` (10행, `가격` 7/10 numeric).
- 형태: 탁상/미니탁상 = **direct 고정가**(10400·9700·6500 등). 벽걸이·엽서캘린더는 책자형(제본)일 수 있어 **혼합** — 매핑단계 분기.
- (가) YES(주). (나) **direct (일부 formula).** (다) `t_prd_product_prices` (+ 일부 `t_prc_*`).
- DATA-GAP: 3행 blank(탁상형캘린더 일부·엽서캘린더).

### F7 봉투/추가상품 (3) — product-accessory/envelope 직접가
- SOURCE: 상품마스터 `상품악세사리(가격포함)` → `product-accessory-l1.csv` (`가격` 67/67 numeric, 전부채움); 가격표 `봉투제작`(price-envelope).
- 대상 3상품 = 카드봉투(블랙/화이트), 트레싱지봉투 (PRD_TYPE.05 추가상품, **카테고리 링크 없음**).
- 형태: **direct 고정가** (OPP접착봉투 1100 등). 단 봉투제작은 봉투종류×소재 8행 매트릭스일 수도 → 매핑단계 분기.
- (가) YES. (나) **direct (envelope는 matrix 가능).** (다) `t_prd_product_prices` (+ envelope formula).

### F8 엽서/홍보물/접지카드 (3) — digital-print 공식 잔여
- SOURCE: 가격표 `디지털인쇄비` 등 → digital-print 공식(PRF_DGP, round-2/디지털엔진 트랙에서 설계됨).
- 형태: **원자합산형 공식.** round-2 디지털인쇄 가격엔진(308행 적재 완료)에 바인딩만 안 된 잔여.
- (가) YES(공식 이미 존재). (나) **formula.** (다) `t_prd_product_price_formulas` 바인딩만.

## 3. DATA-AVAILABILITY MATRIX

| family | 무가격수 | 가격실재? | 형태 | 타깃 테이블 | 추출단위 | 추정행수 | GAP/차단 | 결정의존? |
|----|:--:|:--:|----|----|----|:--:|----|----|
| F1 굿즈/파우치/에코백/라이프 | 123 | YES(254/303) | direct | t_prd_product_prices | per prd_cd | ~110+ | 22 blank(옵션변형/품절), 옵션변형가 PK충돌 | **머그컵 등 옵션변형 → CPQ** |
| F2 아크릴(단품형+조합형) | 25 | YES | matrix | t_prc_* + formula | per size cell | ~수백(면적셀) | 면적-좌표 오모델 전례 | 보드 substrate(판아크릴/투명/미러) |
| F3 책자/포토북/엽서북/떡메 | 33 | YES | matrix/page-band | t_prc_* + formula | per (종류×수량×페이지) | ~수백 | photobook 3 blank·제본옵션 전개 | 하드커버 제본옵션 |
| F4 스티커 | 12 | YES | matrix | t_prc_* + formula | per (판수×소재) | ~백+ | 블록↔상품 1:1 확인 | — |
| F5 명함 | 7 | YES | matrix | t_prc_* + formula | per (단/양면×소재) | ~수십 | 변형명함 블록매칭 | — |
| F6 캘린더 | 5 | YES(7/10) | direct(+formula) | product_prices(+t_prc_*) | per prd_cd | ~5 | 3 blank·벽걸이=책자형 분기 | — |
| F7 봉투/추가상품 | 3 | YES(67/67) | direct(+matrix) | product_prices(+formula) | per prd_cd | ~3 | envelope 매트릭스 분기 | — |
| F8 엽서/홍보물/접지카드 | 3 | YES(공식존재) | formula | formula 바인딩만 | per prd_cd | 3(바인딩) | digital 공식 매칭확인 | — |
| **합계** | **211** |  |  |  |  |  |  |  |

**즉시 적재가능(immediate-loadable)** = F8(3, 바인딩만) + F6/F7 direct 주류 + F1 채움상품 다수.
**결정의존(decision-dependent)** = F1 옵션변형(머그컵 용량/재질), F2 보드 substrate(판아크릴).
**진짜 DATA-GAP** = F1·F3·F6의 blank 행 중 옵션변형이 아니라 source에 가격이 진짜 없는 품절/준비중 상품(후니 input 필요).

## 4. PHASED sub-plan (price-211 트랙)

각 단계 [담당 specialist] + [게이트].

### 1a. 가용성 확정 (Availability Confirmation)
- [dbm-excel-analyst] 본 계획의 family별 가격 실재/blank를 L1 행단위로 확정. blank 행을 (i)옵션변형 (ii)품절/준비중 (iii)진짜 DATA-GAP 3분류. 211 prd_cd ↔ source 행 cross-walk 표 산출.
- **게이트 A-gate**: family별 "가격 실재 행수 vs 무가격 상품수" 일치 검증, blank 3분류 누락0. 진짜 DATA-GAP 명시.

### 1b. 추출 L1 (Faithful Extraction)
- [dbm-excel-analyst] family별 가격컬럼 무손실 추출(provenance: file/sheet/cell). direct = (prd_cd, unit_price); matrix = (row_key,col_key,value) long unpivot. 옵션변형가는 별도 분리.
- **게이트 L1-gate**: 컬럼커버리지·non-empty 보존율 100%·round-trip diff 0 (`verify_l1.py` 9게이트).

### 1c. 매핑 (Mapping)
- direct(F1/F6/F7): [dbm-mapping-designer] → `t_prd_product_prices` (prd_cd, apply_ymd, unit_price). prd_nm JOIN으로 prd_cd 해소(JOIN KEY=prd_nm only).
- matrix(F2/F3/F4/F5): [dbm-price-formula] → `t_prc_*` component_prices + formula + `t_prd_product_price_formulas` 바인딩. 면적매트릭스=후니 권위공식.
- formula 잔여(F8): [dbm-price-formula] 기존 PRF_DGP 공식 바인딩만.
- **게이트 M-gate**: 컬럼↔컬럼 매핑·제약 준수(PK/CHECK/NOT NULL)·apply_ymd 포맷·comp_cd 길이. search-before-mint.

### 1d. 적재 실행본 조립 (Load-Execution Assembly)
- [dbm-load-builder] 멱등 `INSERT … ON CONFLICT UPSERT` + 단일 트랜잭션 + FK 위상정렬 SQL/로더. direct는 (prd_cd,apply_ymd) PK ON CONFLICT, matrix는 component_prices+formula 순서.
- [dbm-ddl-proposer] 부족 엔티티 DDL 제안(필요시).
- **게이트 R1~R6**: 롤백전용 라이브 DRY-RUN, 멱등 2-pass(재실행 0행)·제약위반0·FK고아0·COMMIT0. IDENTITY 시퀀스 stale 가드(setval 재동기화).

### 1e. 검증 (Verification — 생성·검증 분리)
- [dbm-validator] 독립 재검증: S-gate(도메인 의미 정합, 엑셀 명시값=권위 라이브 직접대조) + R1~R6 + 역대조(추출↔원본셀 diff0). 생성자(designer/formula)와 분리.
- **게이트 S-gate + 역대조**: FK 맞아도 의미 검증(엑셀 명시값 일치), over-claim 적발.

[순서 권고] F8(바인딩만, 최소) → F7/F6 direct(소량) → F1 direct 주류(대량) → F4/F5 matrix → F3 page-band → F2 area-matrix(가장 복잡). 결정의존·DATA-GAP은 별도 BLOCKED 분리.

### family 분류
- **immediate-loadable**: F8(3), F6 direct주류(~4), F7(3), F1 채움상품(~100), F4(12), F5(7) — 단 matrix는 공식설계 선행.
- **decision-dependent**: F1 머그컵 등 옵션변형(용량/재질), F2 판아크릴 보드 substrate.
- **true DATA-GAP**: F1/F3/F6의 품절·준비중 blank 행(옵션변형 아닌 것) — 후니 input 대기.

## 5. RISKS

- **R-옵션변형 PK충돌 (HARD)**: `t_prd_product_prices` PK=(prd_cd, apply_ymd). 머그컵=화이트6500/반투명7500/투명7500 처럼 **한 prd_cd에 옵션별 가격 다수** → direct 테이블에 못 담음. 옵션변형가는 **CPQ option_items 가격 또는 formula**로 가야지 직접가로 강행 시 데이터손실/PK충돌. F1에 이 패턴 다수 — 매핑 전 옵션변형 식별 필수.
- **R-진짜 DATA-GAP**: F1 22 blank·F3 photobook 3·F6 3 등에 옵션변형이 아닌 진짜 미가격(품절/준비중) 존재 가능 → "이연=완료" 합리화 금지. 후니 input 필요. 발명·추정 금지(BLOCKED 분리).
- **R-C-1 apply_ymd 포맷**: varchar(10), 'yyyy-MM-dd' 강제. 미지정 시 적재일 등 기준일 정책 필요(직접가 1행/상품이므로 apply_ymd 단일값 결정).
- **R-reg_dt NOT NULL**: round-5 라이브 적발 전례 — 명시 NULL은 DEFAULT 미발화. `DEFAULT` 키워드/omit 처리.
- **R-comp_cd 길이/자연키 dedup**: matrix(F2~F5) component_prices의 comp_cd 길이제약·자연키(공식×구성요소×차원셀) 중복제거. NOT EXISTS 가드.
- **R-면적매트릭스 오모델 (F2)**: round-2 28 포스터상품 면적-좌표 오모델 전례. 아크릴은 면적매트릭스+ceiling(후니 권위공식)로. R² 회귀함수 추천 금지.
- **R-prd_nm JOIN only**: MES_ITEM_CD 전부 NULL → prd_cd 해소는 prd_nm JOIN뿐. 동명/변형명 충돌 주의(예 "말랑키링" goods-pouch vs 말랑(PVC) 카테고리 중복).
- **R-중복적재**: F2 아크릴 구간할인은 round-1 t_dsc 적재 완료. 가격(t_prc) ≠ 할인(t_dsc) — 혼동 금지.

## 6. 결정의존 상세 (5 design decisions 중 가격영향분)

- **용량 머그 (라이프/머그컵)**: 화이트/반투명/투명 3변형 6500/7500. "용량"이 아니라 재질/투명도 변형이지만 동일 구조(옵션별 가격). 직접가 PK 못담음 → CPQ option_item 가격 또는 비치수 size 차원 결정 대기.
- **보드 substrate (F2 판아크릴)**: 투명/미러 등 substrate별 가격(수식81: 미러=투명×2). 면적매트릭스 공식 + substrate 차원 — 보드종류 모델링 결정(GAP-BOARD, round-6 silsa-coverage에서 식별됨) 대기.
