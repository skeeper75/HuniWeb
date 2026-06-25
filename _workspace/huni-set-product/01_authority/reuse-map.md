# reuse-map — 셋트 권위 큐레이션 재사용 증거 (조사 반복 회피)

생성: hsp-authority-curator · 원칙=기존 산출물 재사용, 같은 엑셀 재파싱 금지.

## 재사용한 캐시·산출물

| 출처 | 무엇을 | 어떻게 재사용 | 검증 |
|---|---|---|---|
| `_workspace/huni-dbmap/00_schema/ref-product-sets.csv` | 셋트 구성 28행(prd_cd·sub_prd_cd·sub_prd_qty·note) | 셋트 BOM 기준선 | 라이브 t_prd_product_sets 28행과 **1:1 일치 확인**(0행 충돌 해소) |
| `_workspace/huni-dbmap/00_schema/ref-product-bundle-qtys.csv` | 묶음수(PRD_000097 떡메=50/100) | 떡메 제본 묶음수 출처 | booklet-l1 "50장1권/100장1권"과 정합 |
| `_workspace/huni-dbmap/24_master-extract-260610/booklet-l1.csv` | 책자류 권위 L1(표지/내지/면지/제본/내지페이지 min/max/incr/제작수량) | 셋트 구성 권위 출처(상품마스터260610) — 재파싱 안 함, 추출 캐시 사용 | row38~66에서 7상품 구성·가변범위 추출 |
| `_workspace/huni-dbmap/24_master-extract-260610/stationery-l1.csv` | 떡메모지 중복 등장 확인 | CONFIRM-4 근거(권위 시트 중복) | — |
| **`_workspace/huni-dbmap/24_master-extract-260610/calc-formula-draft-l1.csv`** ★필수 | **셋트 권위 가격공식**(계산공식집 시트): L47-54 하드커버무선·L55-61 트윈링·L62-70 하드커버링·L71-72 엽서북/떡메 고정가형(`(가격포함)`) | **가격공식 누락 보강(부분 재실행)** — 이전 큐레이션이 이 시트 누락→"진성 부재" 오판. set-price-authority §1 권위 공식 추출 출처 | 사용자 제공 권위 확정(중철/무선/PUR·트윈링×2·하드커버링 면지 추가)과 1:1 일치 |
| **`_workspace/huni-dbmap/24_master-extract-260610/photobook-l1.csv`** | 포토북(가격포함) 권위 시트(row15 "상품단가+페이지당단가"·`*책등에따라다름`) | CONFIRM-3 해소 — 포토북 권위 시트=photobook-l1·공식=base24+per2p 통합형 | §18 PRF_PHOTOBOOK_SUM 정합 |
| **`_workspace/huni-price-engine-design/03_design/engine-design-booklet.md`·`engine-design-photobook.md`·`set-product-design.md`** | §18 PRF_BIND_* 셋트 가격공식 설계(PRF_HC_MUSEON_SUM·PRF_HC_TWINRING_SUM·PRF_PHOTOBOOK_SUM·PRF_PCB_FIXED·088 BLOCKED) | **§18 대조표**(권위 공식↔§18 설계 일치 판정) | set-price-authority §2 — 6/7 일치·088 BLOCKED 정합 |

## 라이브 실측만 신규 수행한 것 (캐시 부재·확정 필수)

| 실측 | 쿼리 대상 | 결과 |
|---|---|---|
| PRD_TYPE 코드값 | t_cod_base_codes | 6코드(01완제품/02반제품/03기성/04디자인/05추가) |
| prd_typ 분포 | t_prd_products(del_yn=N) | 완제33·반제29·기성108·디자인105 |
| **t_prd_product_sets 행수** | t_prd_product_sets | **28행 active·셋트7개**(충돌 확정) |
| SEMI_ROLE 코드값 | t_cod_base_codes | 5코드(01내지~05투명커버) |
| 가격공식 바인딩 | t_prd_product_price_formulas | 35상품 중 PRD_000094만 PRF_PCB_FIXED |
| **PRF 공식 정의(2026-06-24)** | t_prc_price_formulas·t_prc_formula_components | PRF_BIND_SUM(stale COMP_BIND_JUNGCHEOL·068~071 미바인딩)·PRF_PCB_FIXED(094 S1/S2)만 존재. PRF_HC_*·PRF_PHOTOBOOK_SUM **라이브 미존재**(§18 설계 제안) |
| 카테고리 귀속 | t_prd_product_categories | 7셋트 카테고리 확정 |
| 사이즈/공정 보유 | t_prd_product_sizes/processes | 셋트완제품만 보유·구성원 0 |

## webadmin ground-truth 직접 대조 (재사용)

- `raw/webadmin/webadmin/catalog/admin.py` L1041-1100 (ProductSetsInline·_ProductSetAdminMixin) — 분류 규칙 ground-truth.
- `raw/webadmin/webadmin/catalog/models.py` L464-483 (TPrdProductSets 스키마: min_cnt/max_cnt/cnt_incr/semi_role).
- `raw/webadmin/webadmin/catalog/pricing.py` L702-794 (evaluate_set_price·derive_inner_sheets 계약).

## 재사용 안 한 것 (스코프 밖 / 후속)

- `_workspace/huni-dbmap/10_configurator/` cpq option-vs-template-guide — 면지 택1 그룹(CONFIRM-2) 설계 시 set-designer 참조.

## 부분 재실행 이력 (가격공식 누락 보강 · 2026-06-24)

- **누락 적발**: 이전 큐레이션이 `calc-formula-draft-l1.csv`(계산공식집 시트) 누락 → 6셋트 "셋트공식 진성 부재 → §18 신설"로 오판.
- **보강**: 계산공식집 시트 L47-72 + photobook-l1 추출 → `set-price-authority.md` 신규 산출(권위 공식·§18 대조·2층 분류).
- **정정**: set-authority-spec §0·§3·§4(CONFIRM-3 해소)·§5 — "진성 부재" → 2층(적재 대상 5/적재됨·결함 1/진성 미정·보류 1/진성 부재 0).
