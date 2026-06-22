# reuse-map.md — 재사용 출처 기록 (중복 조사 회피 증거)

> **Phase 1 — hcc-authority-curator** · 2026-06-22 · `huni-catalog-conformance` §21
> directive #2(조사·산출물 반복 금지): 새 엑셀 파싱·라이브 재해부 없이 기존 추출 캐시·산출물을 재사용해
> 기준만 조립했다. 아래는 무엇을 어디에 재사용했는지의 추적 증거.

## 1. 권위 추출 캐시 (새 파싱 안 함)

| 재사용 파일 | 용도 | 비고 |
|-------------|------|------|
| `_workspace/huni-dbmap/24_master-extract-260610/digital-print-l1.csv` | 디지털 36상품 distinct prd_nm·구분(상품군)·12축 컬럼값 → 모집단·needed 판정 | 헤더+212행(anchor-fill 병합셀). 상품마스터 260610 디지털 시트 L1 추출본. **원본 .xlsx 재파싱 안 함** |
| `_workspace/huni-dbmap/24_master-extract-260610/digital-print-l1-meta.csv` | 별표(*) 제약 주석·comment 존재 확인(제약규칙 축 단서) | 두 컬럼 모두 0건 확인(메타 캐시로 충분) |

## 2. 라이브 구조·기초 참조 (스키마 재해부 안 함)

| 재사용 파일 | 용도 |
|-------------|------|
| `_workspace/huni-dbmap/00_schema/schema-design-intent-map.md` | §① 클러스터 ERD·§1.2 polymorphic ref_dim_cd·§1.3 가격사슬 4단·§② 각 t_* WHY(담으면 안 되는 것)·§③ 삼중 바인딩·§3.1 가격공식 유형 → **12축 대상 t_*·도메인 의미·정합 규칙의 1차 출처** |
| `_workspace/huni-dbmap/00_schema/ref-products.csv` | prd_nm↔prd_cd 1차 대응(라이브 캐시) — 라이브 실측 전 매칭 |
| `_workspace/huni-dbmap/00_schema/ref-product-bundle-qtys.csv` | 묶음수 축 라이브 적재 범위 확인(디지털 prd_cd 범위 밖=대부분 N 근거) |
| `_workspace/huni-dbmap/00_schema/ref-product-page-rules.csv` | 페이지룰 축 라이브 적재 범위 확인(책자류 PRD_000068+ 대상=디지털 대부분 N 근거) |
| `_workspace/huni-dbmap/00_schema/ref-color-counts.csv` | 도수 축 CLR 5종 사전(인쇄안함/1~3도/CMYK4도) |
| `_workspace/huni-dbmap/00_schema/cpq-schema.md` | 옵션그룹/option_items polymorphic 무결성(`fn_chk_opt_item_ref`) 권위(인용) |

## 3. 가격엔진 산출물 (인용 — 재계산·재추출 안 함)

| 재사용 파일 | 용도 |
|-------------|------|
| `_workspace/huni-price-quote/01_engine/engine-contract.md` | `evaluate_price` 4단 사슬·차원 자동매칭·단가형/합가형·할인 계약 → 가격엔진 축 대상 t_* 사슬 정의 |
| `_workspace/huni-price-quote/02_authority/authority-gaps.md` | 디지털인쇄 관련 **CONFIRM 큐**(Q-ROUND·Q-COAT-TIER·별색엽서 인쇄비 변형·3절/국4절 판형 분기) 계승 |
| `_workspace/huni-price-engine-design/03_design/engine-design-digitalprint.md` | 디지털 원자합산형 공식(PRF_DGP_A~F·COMP_PAPER) 존재 확인(축 정의 보강) |

## 4. 라이브 읽기전용 SELECT (모집단 확정용 1회만 — 재해부 아님)

| 쿼리 | 목적 | 결과 |
|------|------|------|
| `t_prd_products` WHERE prd_nm IN (36 디지털 상품명) | 엑셀↔라이브 모집단 1:1 검증 | 36건 전부 존재(PRD_000016~051, del_yn=N, 미매칭 0) |
| `t_prd_product_price_formulas` JOIN (PRD_000016~051) | 가격엔진 축 frm_cd 바인딩 현황 단서(§4) | 26 바인딩·10 미바인딩(공란) — 인스펙터 점검 단서 |

> 라이브 자격증명: `.env.local RAILWAY_DB_*`(읽기전용 SELECT만). 비밀값 비노출. DB 미적재.

## 5. 새로 만든 것 (재사용 불가분)

- `conformance-checklist.csv` — 36상품 × 13축 = 468셀 전수(needed 자동 판정, 빈 셀 0). 위 캐시 조합으로 조립.
- `authority-spec.md` · `domain-lens.md` — 위 출처를 디지털인쇄 스코프로 재구성.

---

## 6. 배치 1 확대 — 캘린더·포토북 (2026-06-22, 디지털인쇄 자(尺) 동형)

> directive #2 준수: 새 .xlsx 파싱 0. 모집단·needed는 모두 기존 추출 캐시에서 측정.

### 재사용 추출 캐시 (새 파싱 안 함)
| 재사용 파일 | 용도 |
|-------------|------|
| `24_master-extract-260610/calendar-l1.csv` | 캘린더 5상품 distinct·옵션형 축(인쇄(필수)·캘린더가공(필수)·종이사양·출력판형) needed 측정 |
| `24_master-extract-260610/design-calendar-l1.csv` | 캘린더 동일 5상품의 **가격포함** 버전(가격 컬럼·인쇄사양·페이지사양) — 도수/페이지룰/가격엔진 권위 보강 |
| `24_master-extract-260610/photobook-l1.csv` | 포토북 1상품(세트). 내지/표지/제본 prefix 컬럼 → 반제품 역할축(내지=자재/도수/페이지·표지=자재/도수/공정·면지=자재/공정) 측정 |

### 라이브 읽기전용 SELECT (모집단 확정 1회)
| 쿼리 | 결과 |
|------|------|
| `t_prd_products` WHERE prd_nm ILIKE 포토북/캘린더 | 포토북 8건(PRD_000100~107, 본체1+반제품7)·캘린더 5건(PRD_000108~112) — 전부 del_yn=N |
| `t_prd_product_price_formulas` LEFT JOIN (위 13 prd) | **전 13 prd frm_cd 미바인딩(none)** — 가격엔진 축 needed=Y 미충족 후보(인스펙터 점검 단서) |

### 새로 만든 것 (append만)
- `conformance-checklist.csv` += 13 prd × 13축 = 169행(기존 디지털 468행 보존). needed 자동 판정·빈 셀 0.
- `authority-spec.md` §6·`domain-lens.md` §B·본 §6 — 캘린더/포토북 스코프 추가(디지털 자(尺) 재구성, 컬럼 구조 동일).

## 7. 배치 2 확대 — 책자·문구·상품악세사리 (2026-06-22, 자(尺) 동형)

> directive #2 준수: 새 .xlsx 파싱 0. 모집단·needed는 모두 기존 추출 캐시 + 라이브 prd_nm 매핑(1회).

### 재사용 추출 캐시 (새 파싱 안 함)
| 재사용 파일 | 용도 |
|-------------|------|
| `24_master-extract-260610/booklet-l1.csv` + `-meta.csv` | 책자 10상품 distinct·세트형 축(내지/표지 자재·도수·판형·페이지룰·제본/박형압 공정·옵션그룹) needed 측정·제약 별표(0건) 측정 |
| `24_master-extract-260610/stationery-l1.csv` + `-meta.csv` | 문구 9상품·세트형+가격포함(`가격`·`구간할인적용테이블`) — 가격엔진 권위 보강·페이지사양 측정 |
| `24_master-extract-260610/product-accessory-l1.csv` + `-meta.csv` | 상품악세사리 15상품·단순 부속물(사이즈+수량+`가격`만) — needed 최소 프로파일·추가상품축 Y 측정 |

### 라이브 읽기전용 SELECT (모집단 확정 1회)
| 쿼리 | 결과 |
|------|------|
| `t_prd_products` WHERE prd_nm IN (34 정제 상품명) | 34/34 전건 매칭(미매칭 0·중복 0). 책자 10·문구 9(떡메모지 책자 귀속)·악세 15 — 전부 del_yn=N |
| `t_prd_product_price_formulas` LEFT JOIN (34 prd) | 바인딩 5(책자4 PRF_BIND_SUM·엽서북 PRF_PCB_FIXED)·미바인딩 29(MISSING 후보) |
| og/constraints/proc/mat 카운트 (34 prd) | 옵션그룹 라이브 분포·제약 EXTRA(OPP접착봉투 3건) 단서 — 인스펙터 우선점검 입력 |

### 새로 만든 것 (append만)
- `conformance-checklist.csv` += 34 prd × 13축 = 442행(기존 637행 보존 → 전체 1,079행). needed 자동 판정·빈 셀 0.
- `authority-spec.md` §7(GATE-1 정정 반영)·`domain-lens.md` §C·본 §7 — 책자/문구/상품악세사리 스코프 추가(자(尺) 동형).

## 배치3 (2026-06-23) — 스티커·아크릴·실사 (조사 반복 0)

> directive #2 준수: 새 .xlsx 파싱 0. 모집단·needed·판별차원은 모두 기존 추출 캐시 + 라이브 1회 실측.

### 재사용 추출 캐시 (새 파싱 안 함)
| 재사용 파일 | 용도 |
|-------------|------|
| `24_master-extract-260610/sticker-l1.csv` + `-meta.csv` | 스티커 16상품 distinct·소재(점착 종이)/커팅/별색(화이트)/조각수 needed·판별차원=소재×사이즈×수량 측정 |
| `24_master-extract-260610/acrylic-l1.csv` + `-meta.csv` | 아크릴 21상품·소재(두께/색)/가공(부속물 BUNDLE)/조각수(조합형) needed·구분(단품형/조합형)·`가격`+`가공_가격` 가격모호 측정 |
| `24_master-extract-260610/silsa-l1.csv` + `-meta.csv` | 실사 29상품(라이브28)·소재별 1:1·면적매트릭스 vs 사이즈티어·가공(오버로크/타공)·비규격경계·★투명포스터 미등록 마커 측정 |

### 재사용 기존 가격엔진 산출물 (§13/§18 — 재조사 금지)
| 출처 | 재사용 내용 |
|------|-------------|
| `_meta/batch-progress-260622.md` 과대청구 스캔 | ★미검증 4시트(sticker·acrylic·silsa·goods-pouch) 적출 0 명시 재사용 — 배치3 돈 새는 면 0 비준(authority-spec §4) |
| `_workspace/huni-price-engine-design/03_design/` (§18) | 실사 PRF_POSTER_* 면적매트릭스·스티커 PRF_STK_* 설계가 라이브 적재된 결과(바인딩률 69% 급상승 근거) |
| `authority-spec.md` §1·§2 (배치1·2 자(尺)) | 12축 정답기준·판정어휘·축↔인스펙터 배정 동형 계승 — 재정의 0 |
| MEMORY: [[dbmap-silsa-price-via-poster-sign]] | 실사 면적매트릭스 모델·inline 회귀 오모델링 금지 가드 |
| MEMORY: [[dbmap-option-material-process-bundle]]·[[dbmap-material-option-normalization]] | 아크릴 가공=자재+공정 BUNDLE·소재 두께/색 합성 도메인 |

### 라이브 읽기전용 SELECT (모집단·바인딩 확정 1회)
| 쿼리 | 결과 |
|------|------|
| `t_prd_products` 범위 PRD_000052~166 del_yn=N | 스티커 16(052~067)·실사 28(118~145)·아크릴 21(146~166) = 65 prd 1:1 매칭. 실사 투명포스터★만 라이브 부재(CONFIRM) |
| `t_prd_product_price_formulas` (65 prd) | 바인딩 45(스티커16+실사28+아크릴1)·MISSING 20(아크릴 147~166) |
| `t_prc_formula_components`/`price_components` use_dims (PRF_STK_FIXED·POSTER_ARTPRINT·PET_BANNER) | 판별차원 실증: 스티커=[siz_cd,mat_cd,min_qty]·실사포스터=[siz_width,siz_height,min_qty]면적·배너=[siz_cd,min_qty]티어. STK print_opt/proc 전행 NULL(단면 안전) |
| og/addons 카운트 (65 prd) | 옵션그룹 라이브 분포·addons 0행 단서 — 인스펙터 우선점검 입력 |

### 새로 만든 것 (append만)
- `conformance-checklist.csv` += 65 prd × 13축 = 845행(기존 1,079행 보존 → 전체 1,924 데이터행·중복 prd_cd 0). needed 자동 판정·빈 셀 0.
- `authority-spec-batch3.md`(배치3 분리)·`domain-lens-batch3.md`(배치3 분리) — 충돌 없게 신규 파일. 기존 `authority-spec.md`·`domain-lens.md` 불변.

---

## §배치4 — goods-pouch(굿즈파우치, 103엑셀·98라이브) 재사용 증거 (2026-06-23)

★사용자 directive: 가격엔진·매핑은 기존 하네스가 충분히 산출 — 새 조사 없이 기존 산출물·캐시 재사용으로 기준만 조립.

### 권위 추출 캐시 (엑셀 재파싱 0 — 캐시만)
| 출처 | 어디에 사용 |
|------|-------------|
| `24_master-extract-260610/goods-pouch-l1.csv`(303행 L1) | 상품명(D)·상품(옵션)·가격(C)·가공·추가상품·구간할인 등 축 신호 추출 → checklist needed·동형 클래스. **원본 엑셀 재파싱 0** |
| `24_master-extract-260610/goods-pouch-l1-meta.csv` | 컬럼 정의(출력용지규격 hidden·범례=노랑/그레이 배경 의미) → 판형 needed=N 근거·CONFIRM 노트 |

### 기존 산출물 (가격엔진·도메인 — 조사 반복 회피)
| 출처 | 어디에 사용 |
|------|-------------|
| **§18 `engine-design-goods-pouch.md`** | ★핵심 재사용 — GP-1 단일고정가55/GP-2 변형고정가31·판별차원(opt_cd/siz_cd)·평탄화 가드 G-GP-3·PRODUCT_PRICE 선점 가드 G-GP-5·구간할인 4타입(GOODSA/B/FABRIC/SQUISHY) 전부 계승. **동형 클래스·판별차원·정답기준 재발견 0** |
| **§18 `golden-cases-goods-pouch.md`** | 종단 e2e 골든 케이스(S/M/L variant·구간할인 곱) 입력 — 인스펙터/게이트 재사용 |
| `00_schema/ref-*.csv`(materials·processes·plate-sizes·discount-tables·bundle-qtys) | 대상 t_* 컬럼·구조 인용 → authority-spec 대상 t_* 열 |
| `authority-spec.md`·`authority-spec-batch3.md`(배치1·2·3 자) | 13축 정답기준·판정어휘·축↔인스펙터 배정 동형 계승 — 재정의 0 |
| `_meta/batch-progress-260622.md` | 동형 파이프라인 패턴·판별차원 NULL 와일드카드 과대청구 렌즈 계승 |
| MEMORY: [[dbmap-print-domain-recipe-philosophy]] | 완제 굿즈=개당 고정가(부품 합산 아님)·인쇄물 시트와 다름 도메인 |
| MEMORY: [[dbmap-acrylic-price-chain-link]] | 본체+조립 BUNDLE=생산BOM·가격 inline baked-in(가격 합산 아님) 가드 |
| MEMORY: [[dbmap-product-group-isomorphism-round21]] | 대표→동형 전파(103상품 토큰 압축) 렌즈 |
| MEMORY: [[dbmap-discount-authority]] | 구간할인 타입 권위=상품마스터 "구간할인적용테이블" 컬럼·FABRIC=카테고리단위 |
| `04_price_engine/overcharge-scan-catalog`(2026-06-23) | 굿즈파우치 과대청구 적출 0 비준 재사용 — 재스캔 0 |

### 라이브 읽기전용 SELECT (모집단·바인딩·커버리지 확정 1회만)
| 쿼리 | 결과 |
|------|------|
| `t_prd_products` PRD_000183~280 del_yn=N | **98 prd 모집단 확정**(엑셀 103↔라이브 98·폰케이스 5 미등록·메쉬에코백 공백차 매칭) |
| `t_prd_product_price_formulas` (98 prd) | ★**바인딩 0/98 = 전건 MISSING**(돈크리·가격계산 불가) |
| 13 t_prd_product_* 축 count(DISTINCT prd_cd) | 라이브 커버리지 실측: materials78·plate_sizes85(EXTRA의심)·discount82·sizes11·processes6·옵션레이어/print_options/prices=0 |

### 새로 만든 것 (append만)
- `conformance-checklist.csv` += 98 prd × 13축 = **1,274행**(기존 1,924 보존 → 전체 **3,198 데이터행**·중복 prd_cd 0·빈셀 0).
- `authority-spec-batch4.md`·`domain-lens-batch4.md` — 신규 파일(기존 불변). 동형 클래스 7종 압축 기술.
