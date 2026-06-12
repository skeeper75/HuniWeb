# Axis Pack — price-engine (가격공식 엔진)

> freshness 권위: `18_schema-change/impact-diagnosis.md`(I-1·I-2·I-3·I-4·I-7). **이 축은 가장 stale 위험이 크다.**
> 핵심 [HARD]: `00_schema/price-engine-ddl.md`(C-PRICEENG)는 **STALE — 인용 금지**(6차원/8컬럼·단가형/합가형 부재·template_prices 누락·구 PK). 가격엔진 구조 인용은 라이브 sql + webadmin pricing 문서로.

## 정답 소스 (구조)

| 항목 | 정답 소스(file:§) | tier | freshness |
|------|-------------------|------|-----------|
| t_prc_* 4단 구조 + 차원(8차원/자연키 10컬럼) | `raw/webadmin/sql/21_pricing_dims.sql`(proc_cd·opt_cd·prc_typ_cd) + `sql/22_use_dims.sql` + `raw/webadmin/docs/prcx01-pricing-model.md`·`pricing-erd.md` | A | FRESH |
| 단가유형(prc_typ_cd: 01 단가형=장당가 / 02 합가형=구간총액÷환산) | `sql/21_pricing_dims.sql` + impact-diagnosis I-2·§3 백필(144행 전부 .01) | A | FRESH |
| 가격공식 PK(prd_cd, apply_bgn_ymd) | `sql/18_unify_price_keys.sql`(I-7) | A | FRESH |
| template 직접단가(t_prd_template_prices) | `sql/20_template_prices.sql`(I-4·0행) | A | FRESH(스키마만) |
| use_dims 백필 로직 | `raw/webadmin/tools/init_use_dims.py` | A | FRESH |
| 라이브 적재값(component_prices 3,504행 등) | `00_schema/ref-*.csv`(price 관련) + 라이브 psql 실측 | A | PARTIAL(06-04 스냅샷·신규 차원 컬럼 0행) |

## 정답 소스 (공식 유형 — 후니 권위)

| 공식유형 | 정답 소스 | tier | freshness | 메모 |
|----------|-----------|------|-----------|------|
| 원자합산형(디지털인쇄) PRF_DGP_A~F + 용지비 | `02_mapping/digital-print-engine/` | C | PARTIAL-STALE(I-1·I-2) — 공식사슬 FRESH | 라이브 적재 308행 COMMIT |
| 면적매트릭스형(실사·현수막·아크릴·포스터사인) [세로][가로]+ceiling | `02_mapping/silsa-poster-area-matrix/` + `09_load/_migrate_areamatrix/` + 메모리 dbmap-price-formula-types-authority | C | FRESH | off-grid=한단계 큰 크기 |
| 고정가형(수량×옵션) | `09_load/_migrate_fixedprice/` + `02_mapping/price211-fixedgrid/` | C | FRESH | round-2 28포스터 오모델 교정분 |
| 구간형(수량구간 할인) | `00_schema/discount-domain-detail.md` + `raw/webadmin/tools/load_discounts.py` | A/C | PARTIAL-STALE(I-7 PK) | round-1 t_dsc_* |
| 상품별 공식 PRF_<X>(가격사슬 단절 해소) | `02_mapping/dwire-poster-formula-remodel/`·`dwire-bind-namecard-photocard-remodel/` | C | FRESH | broken 4(포스터/제본/명함/포토카드) |

## 보조 소스

- `05_method/F2-price-sheet-structures.md` — 15 가격시트 구조 카탈로그(블록·축). FRESH.
- `06_extract/price-<slug>-l1.csv` — 가격표 L1 정답값. tier B FRESH.
- `06_extract/pangeori-l1.csv` — 판걸이수=판형 마진 권위. tier B FRESH.
- 메모리: dbmap-round2-price-engine(PARTIAL-STALE I-1·I-2)·dbmap-compute-in-app-db-stores-lookup(판수=앱 계산·박 등급=앱·FRESH)·dbmap-output-plate-mapping(출력판형=판형 매핑·FRESH).

## stale 함정 (인용 금지/주의)

1. **`00_schema/price-engine-ddl.md` 전체 — STALE.** "6차원/8컬럼 자연키"는 사실 8차원/10컬럼(I-1). 단가형/합가형 개념 전무(I-2). template_prices 누락(I-4). 구 PK(I-7). → 대체: sql/21·22 + pricing-erd.md.
2. **단가형 가정 함정(I-2).** 우리 모든 단가 매핑이 암묵 "장당가×수량"=단가형. 합가형(구간총액÷환산) 상품을 단가형으로 오매핑 위험. 라이브는 144행 전부 .01(단가형)이라 합가형 식별은 미래 작업 — 위키는 "합가형 미식별" GAP 명시.
3. **round-2 포스터 면적-좌표 오모델(메모리 dbmap-price-formula-types-authority).** 28 포스터를 전부 면적-좌표 회귀로 오모델 → 15개는 고정가형. 교정분(`_migrate_fixedprice/`) 권위.

## 미해결 GAP

- 합가형(prc_typ_cd=02) 상품 식별 절차 부재(라이브 전부 .01). [GAP-PE-1]
- 평면화 차원집합 ↔ 라이브 use_dims 대조 절차 미신설(I-3). [GAP-PE-2]
- 포토북·디자인캘린더·문구·부자재 가격 미적재(prices 0행·crosscut 추가-I). [GAP-PE-3]
- 박: 면적→등급=앱 계산, DB는 등급별 가격만(메모리). 박 가격 GAP 잔존. [GAP-PE-4]
- 3절/투명/048/019 등 plate 교정 대기 가격 차단(메모리 dbmap-digitalprint). [GAP-PE-5]
