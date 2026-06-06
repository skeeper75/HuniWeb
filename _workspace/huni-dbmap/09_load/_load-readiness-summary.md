# round-4 적재 준비 — 통합 게이트 요약 (상품마스터 + 가격표)

> **목적:** round-4(load-readiness) 두 트랙의 G1~G9 게이트 결과를 한 곳에 종합한다.
> **권위:** `docs/goal-2026-06-06-01.md`(GOAL·완료기준 G1~G9) · 트랙별 게이트 판정서가 단일 권위:
> 상품마스터 = `03_validation/load-readiness-gate.md` · 가격표 = `03_validation/load-readiness-gate-price.md`.
> **DB 미적재(HARD):** INSERT/UPDATE/DDL 0. 산출 = 적재본 + 게이트뿐. **실제 적재는 인간 승인 대상.**
> **작성** 2026-06-06 · 식별자/테이블/컬럼/코드/SQL 영어, 설명 한국어.

---

## 0. 한 줄 현황

상품마스터(`t_prd_*`)·가격표(`t_prc_*`) **두 적재본 모두 round-4 게이트 GO**. G1~G9 전 게이트 PASS,
BLOCKER 0. 데이터 무결성 결함 0(검증 중 적발된 발견은 모두 문서표기/요약숫자 수준 → 전건 RESOLVED).
**즉시 적재가능 = 상품마스터 384행 + 가격표 2,320행.** 실제 INSERT·코드행/siz 등록은 인간 승인 선결.

## 1. 트랙별 종합 판정

| 트랙 | 대상 도메인 | 게이트 판정 | 즉시 적재가능 | 차단(등록 대기) | GAP | 권위 판정서 |
|------|------------|------------|--------------|----------------|-----|------------|
| **상품마스터** | `t_prd_product_*` | **GO** | **384행** (+ UPDATE 314) | 36행 | 2건 | `load-readiness-gate.md` |
| **가격표** | `t_prc_*` + 상품바인딩 | **GO** | **2,320행** | 2,697행 | 1건 | `load-readiness-gate-price.md` |

> 적재 번들 위치: 상품마스터 = `09_load/_assembled/` · 가격표 = `09_load/_assembled_price/`.

## 2. G1~G9 게이트 매트릭스 (두 트랙)

| Gate | 검증 내용 | 상품마스터 | 가격표 |
|------|----------|:---------:|:------:|
| **G1** t_* 화이트리스트 | 비-`t_`/Django 적재행 0 | PASS | PASS |
| **G2** 무손실 추출 | Excel→L1 역대조·발명/dodge 0 | PASS | PASS |
| **G3** 매핑 무결성 | 자연키 dup 0·과소적재 0·침묵폴백 0 | PASS | PASS |
| **G4** 스키마 적합 | 타입/길이/NOT NULL/CHECK·길이초과 0 | PASS | PASS |
| **G5** FK 무결성+순서 | FK 라이브 실존·위상정렬 유효·사이클 0 | PASS | PASS |
| **G6** DRY-RUN | 로컬 제약검사 PASS · **라이브 DRY-RUN 보류**(사용자 미승인) | PASS* | PASS* |
| **G7** 차단/에스컬레이션 명시 | 차단·GAP 사유+해소조건·행소실 0 | PASS | PASS |
| **G8** 재현성 | 스크립트 멱등(byte-identical) | PASS | PASS |
| **G9** 독립 검증 | builder≠validator·실결함 ≥1 적발 | PASS | PASS |

\* G6는 로컬 제약검사(타입/NOT NULL/CHECK + 라이브 read-only FK 룩업)로 PASS. **롤백전용 라이브 DRY-RUN은
쓰기 트랜잭션이라 사용자 미승인으로 미실행** — 적재 직전 라이브 export 기반 1회 재실행이 잔여 선결조건(양 트랙 공통).

## 3. 적재 가능성 통합 집계

### 상품마스터 (`09_load/_assembled/`)
| 분류 | 행수 | 내역 |
|------|------|------|
| 즉시 적재가능 | **384** | materials 316 · processes 62 · bundle_qtys 6 |
| UPDATE-set (별도 lane) | 314 | qty_unit 244 · nonspec 25 · 두께 20 · UV 20 · excl_link 4 · note 1 |
| 코드선적재 제안 | 11 | 레이저커팅 proc 1 · 원형 siz 10 (원형35mm는 기존 `SIZ_000422` 재사용) |
| 차단(후니 등록 대기) | 36 | 레이저커팅 의존 14 · addon template 부재 4 · 디자인캘린더 신규 18 |
| GAP(무손실 불가) | 2 | goods-pouch 비치수 size 47상품 · 박 2단룩업 |
| conditional(라이브 재확인) | 9 | digital-print 016 DROP · calendar mat 4 · acrylic 151 |

### 가격표 (`09_load/_assembled_price/`)
| 분류 | 행수 | 내역 |
|------|------|------|
| 즉시 적재가능 | **2,320** | 단가 2,108 · 구성요소 143 · 상품바인딩 45 · 배선 13 · 공식 10 · 코드행 1 |
| 차단(후니 siz 등록 대기) | 2,697 | component_prices placeholder siz_cd 7군(GUK4 870·POSTER 680·STK 456·3JEOL 304·ACRYL 237·GP 110·ENV 40, distinct siz 285) |
| GAP(무손실 불가) | 1 | 박 2단룩업(면적→분류→가격, 중간키 부재) |
| 코드선적재 제안 | 1 | `PRC_COMPONENT_TYPE.06` 완제품비 |

> 재구성 무손실 확증: 가격 단가 2,108(적재) + 2,697(차단) = 원본 4,805. `comp_cd` 최장 41자(varchar 50, round-2 55자 overflow 해소). 상품마스터 (384+314+36+2+9 + 코드선적재)도 대시보드 총량 정합·행소실 0.

## 4. 발견·보정 이력 (G9 독립 검증 작동 증거)

생성(builder)·검증(validator) 분리가 실제로 결함을 적발했다. **데이터 무결성 BLOCKER·MAJOR(가격) 0**.

| 트랙 | 발견 | 등급 | 처리 |
|------|------|------|------|
| 상품마스터 | 코드선적재 `SIZ_000506` 원형35mm = 라이브 `SIZ_000422` 중복(search-before-mint 위반) | MAJOR | **RESOLVED** — 신규 mint 11→10, 기존 코드 재사용 |
| 상품마스터 | `LIVE_TEMPLATES` 전제 좁음(2개 하드코딩 → 라이브 11개) | MINOR | **RESOLVED** — 스크립트·문서 정정 |
| 가격표 | 2,106 vs 2,108 카운트 차이 | MINOR | **RESOLVED** — round-2 comp_cd 55자 2행이 보정으로 해소 → 2,108 정확 |
| 가격표 | 매니페스트 §2 FK 부모 표 카운트(mat 12→10·clr) 부정확 | MINOR | **RESOLVED** — 문서표기 정정 |
| 가격표 | `columns.csv` t_prc_* 미수록(stale) | INFO | **RESOLVED** — G4 권위=라이브 DDL 주석, 차후 재추출 권장 |
| 가격표 | 즉시적재 요약 "2,319" vs 실제 2,320(off-by-one) | MINOR | **RESOLVED** — validator 자기정정, 데이터 무결 |

> 모든 발견은 문서표기/요약숫자(데이터 무결)였고, validator가 자기 1차 게이트 산술오류까지 정직하게 자기정정했다(F-4). 연쇄 MINOR가 정정 루프로 번지지 않도록 데이터 무결·GO 확정 시점에 종결.

## 5. 적재 순서 (FK 위상정렬 요약)

실제 적재 인가 시 부모→자식 순. 상세는 각 트랙 `_assembled*/load-manifest.md`.

- **상품마스터**: 00 코드행(레이저커팅 proc·원형 siz) → 03 `t_prd_products`(디자인캘린더 신규, 차단) → 05 materials → 06 processes → 09 bundle_qtys → (07 print_options·08 page_rules·10 addons = 즉시분 0/차단) · UPDATE-set은 해당 단계 후.
- **가격표**: 00 `t_cod_base_codes`(.06) → 01 `t_prc_price_formulas` → 02 `t_prc_price_components` → 03 `t_prc_formula_components` → 04 `t_prc_component_prices`(2,108) → 05 `t_prd_product_price_formulas`(45).

## 6. 적재 전 인간 승인 대기 (통합 에스컬레이션 — 게이트 실패 아님)

| # | 항목 | 트랙 | 결정 사항 |
|---|------|------|----------|
| 1 | **후니 siz 등록 2,697행**(7군·285 distinct siz) | 가격 | `t_siz_sizes` 등록 → 실코드 치환 후 적재. **최대 미적재분을 푸는 열쇠** |
| 2 | 코드선적재 `PRC_COMPONENT_TYPE.06` | 가격 | `t_cod_base_codes` 등록 → 완제품비 component |
| 3 | 코드선적재 레이저커팅 `proc_cd` | 상품마스터 | 등록 → 아크릴 완칼 14행 |
| 4 | 코드선적재 원형 `siz_cd` 10종 | 상품마스터 | 등록 → sticker 066 원형 |
| 5 | 디자인캘린더 5신규상품 | 상품마스터 | `prd_cd` 실번호 부여 + 출시 승인 → 18 연결행 |
| 6 | addon template 부재 4행 | 상품마스터 | template 등록 또는 라이브 addon 모델 재확인 |
| 7 | goods-pouch 비치수 size GAP(47상품) | 상품마스터 | siz_cd 신설 vs nonspec 인코딩 정책 |
| 8 | 박 GAP(2단룩업) | 양 트랙 | 면적→분류 중간키 모델링 결정 |
| 9 | **라이브 DRY-RUN** | 양 트랙 | 적재 직전 롤백전용 트랜잭션 1회 승인(stale 격차 최종 폐쇄) |
| 10 | (참고) `columns.csv` 재추출 | 인프라 | t_prc_* 미수록 stale — 차후 재추출(검증 영향 없음) |

## 7. 다음 단계

1. **후니 siz 등록**(#1) — 가격 2,697행 + 상품마스터 형상 siz가 여기서 풀린다. 가장 큰 미적재분 해소.
2. **코드선적재 일괄 승인**(#2~4) — proc/siz/code 12건 등록 시 차단 다수 활성.
3. **실제 적재 인가 시**: 적재 직전 라이브 export로 G6 DRY-RUN 1회(#9) + conditional 라이브 재확인 → FK순 INSERT.
4. **GAP 모델링**(#7·8) — 도메인 결정 필요(라이브로 해소 안 됨).

> 본 요약은 두 게이트 판정서의 종합 인덱스다. 수치·근거의 단일 권위는 각 `load-readiness-gate*.md`.
