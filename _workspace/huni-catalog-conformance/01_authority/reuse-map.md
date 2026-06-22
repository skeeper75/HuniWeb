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
