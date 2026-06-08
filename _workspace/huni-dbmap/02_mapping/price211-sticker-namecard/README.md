# price-211 slice C1 — 스티커(F4) + 명함(F5) 가격 매핑 적재본

생성: dbm-mapping-designer (dbm-price-formula 스킬) · 2026-06-07 · **GENERATION ONLY(DB 무쓰기)**

## 한 줄 요약
무가격 스티커 12 + 명함 7 의 가격을 **라이브 기존 스캐폴딩(round-5) 재사용**으로 채운다.
신규 단가 0행, **공식 1 mint + 배선 18 + 바인딩 16 = 35 INSERTABLE**, **BLOCKED 3**(발명 금지).

## 파일
| 파일 | 내용 |
|------|------|
| `mapping.md` | 설계서(STATUS·매트릭스→long·공식설계·BLOCKED·live-vs-doc flag·결정요청) — **권위** |
| `load/t_prc_price_formulas.csv` | 신규 공식 1행(PRF_STK_PACK_FIXED) |
| `load/t_prc_formula_components.csv` | 배선 18행(명함7상품 wire + 스티커팩) |
| `load/t_prd_product_price_formulas.csv` | 바인딩 16행(스티커10 + 명함6) |
| `load/t_prc_component_prices.csv` | **빈(헤더만)** — 신규 단가 0(기존 재사용·재적재 금지 증거) |
| `load/product_price_formulas_BLOCKED.csv` | 차단 3(형압명함·소량자유형·타투) |
| `load.sql` | 멱등 INSERT(ON CONFLICT DO NOTHING)·단일 tx·FK순·reg_dt OMIT |
| `dryrun-plan.md` | DRY-RUN 계획(PLAN ONLY·미실행)·R1~R6 기대게이트 |
| `_gen/gen.py` | CSV 생성기(provenance) |

## 핵심 결정 (mapping.md §0·§3 권위)
- **재적재 아님**: 스티커·명함 단가는 round-5가 이미 적재(COMP_STK_PRINT 258·COMP_NAMECARD_* 27종). 본 슬라이스는 **바인딩 완성**이 본질.
- **반칼변형 7종**(원형/정사각/직사각/띠지/팬시/팬시투명/홀로그램) = B01 반칼 매트릭스 공유 → PRF_STK_FIXED 바인딩(PRD_000052 정답 패턴).
- **명함 7종** = 기존 components를 PRF_NAMECARD_FIXED 에 wire + 바인딩(round-5가 STD만 wire한 것 완성).
- **스티커팩** = COMP_STK_PACK 재사용 + 신규 PRF_STK_PACK_FIXED.

## BLOCKED (인간 input/결정 대기)
- PRD_000038 형압명함 — 가격원천 부재(L1 블록 없음).
- PRD_000064 소량자유형스티커 — base+증분 비매트릭스 구조(D-1).
- PRD_000067 타투스티커 — 3장단위 세트단가(bdl 모델, D-2).

## 다음
dbm-validator 독립 재검증(S-gate·역대조·R1~R6) → lead 승인 → DRY-RUN 실행 → 인간 승인 COMMIT.
DB 직접 적재·DRY-RUN 실행·git 없음(본 단계).
