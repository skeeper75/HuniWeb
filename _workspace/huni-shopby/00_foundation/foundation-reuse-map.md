# foundation-reuse-map.md — 재사용 출처 + freshness/STALE 경고 + 재실측 항목

> 토대 ①(가격계산 흐름)·②(라이브 적재 현황)를 어느 기존 하네스 산출물에서 재사용했는지, 각 출처의
> 신선도(freshness)와 STALE 경계, 직접 재실측한 항목을 못박는다. **새 조사 반복 0** — 기존 산출 재사용
> 원칙 준수. 작성 2026-06-25 · hsb-foundation-curator.

---

## 1. 재사용 출처 매핑

| 토대 | 사용처 | 재사용 출처 | 작성일 | freshness |
|------|--------|------------|:----:|-----------|
| ① 엔진 계약 | webadmin-pricecalc-flow §1·§2·§5 | `_workspace/huni-price-quote/01_engine/engine-contract.md` | 2026-06-18 | 🟡 명제 유효·**라인번호 STALE**(아래 §2) |
| ① 위젯 호출 | webadmin-pricecalc-flow §4 | `_workspace/huni-price-quote/01_engine/widget-price-contract.md` | 2026-06-18 | 🟢 계약 유효(W-0~W-10·R-1~R-7) |
| ① 흐름도 | webadmin-pricecalc-flow §2 mermaid | `_workspace/huni-price-quote/01_engine/price-flow-map.md` | 2026-06-18 | 🟡 흐름 유효·**행수(배선301) STALE** |
| ① 5장치 | webadmin-pricecalc-flow §3 | `_workspace/huni-price-engine-diag/03_synthesis/engine-comprehension.md` | 2026-06-18 | 🟢 역할 유효·F1~F6 발견 유효 |
| ① 지식맵 | webadmin-pricecalc-flow §5·open-q | `.../known-vs-unknown.md` | 2026-06-18 | 🟢 K1~K8·U1~U6 유효(K7 일부 변화) |
| ② 종단 정합 | live-db-loaded-state §3·§5 | `_workspace/huni-catalog-conformance/06_gate/conformance-final-summary.md` | 2026-06-23 | 🟢 verdict 유효·**시점차**(§2 재실측과 대조) |
| ② 전 상품×12축 | live-db-loaded-state §0·§4 | `_workspace/huni-catalog-conformance/01_authority/conformance-checklist.csv` (3,198행·246 prd) | 2026-06-23 | 🟢 커버리지 자(尺) 유효 |
| ② CPQ 그릇 | live-db-loaded-state §6 | `_workspace/huni-dbmap/10_configurator/live-admin-groundtruth.md` | 2026-06-08 | 🔴 **"L2 전 상품 0행" STALE**(51 prd 적재됨) |
| ① 코드 근거 | 전반 | `raw/webadmin/webadmin/catalog/{pricing.py,price_views.py,templates/catalog/product_viewer.html}` | 현행 | 🟢 1차 권위(직접 grep/Read) |

---

## 2. STALE 경고 [HARD] — 인용 금지/정정 대상

| ID | STALE 항목 | 출처 | 정정 |
|----|-----------|------|------|
| **S-1** | `evaluate_price` 라인 `:247` (570줄 시점) | engine-contract §0 | **현행 `:340`** (827줄·`evaluate_set_price` 추가로 성장). 모든 `pricing.py:NNN` 인용 약 +90~250 드리프트 |
| **S-2** | 배선 `t_prc_formula_components` **301행** | price-flow-map §1·§2 | **현행 103행**(§21 과대청구·중복 정리로 정정 감소) |
| **S-3** | 직접단가 `t_prd_product_prices` **0행**·"전 상품 FORMULA로만"(명제 C1) | engine-contract §1·§10 C1 | **현행 26행/26 prd**(순위2 발화). C1 부분 무효 |
| **S-4** | CPQ "L2 전 상품 미적재 0행" | live-admin-groundtruth §2·§2.4 | **현행 옵션그룹 148행/51 prd·아이템 509·제약 10/8 prd**. 무효 |
| **S-5** | 공식 48·바인딩 76·구성요소 146 | price-flow-map §1 | **현행 50·78·149**(소폭 증가) |
| **S-6** | 셋트 경로 부재 | §13 base 전반 | **`evaluate_set_price`(:718)·`t_prd_product_sets` 28행/7부모 신규**(§23) |
| **S-7** | prcx01-pricing-model.md·pricing-erd.md (8차원·clr_cd·frm_typ 시절) | (인용 안 함) | §14 F-1 기확정 STALE — **권위 금지**. 본 토대도 인용 0 |
| **S-8** | v03 엑셀(외부 오염원) | — | [[dbmap-live-remediation-260610]] — **인용 금지**. 권위=상품마스터 260610 L1 최신 |

> **freshness 정책:** 🔴=인용 금지(정정 필수) · 🟡=명제/구조는 유효하나 수치/라인 재확인 필요 ·
> 🟢=현행 유효. 본 토대는 🔴 항목을 §1·§2 재실측으로 전부 정정했다.

---

## 3. 직접 재실측한 항목 (2026-06-25 라이브 읽기전용 SELECT)

> `.env.local RAILWAY_DB_*` (chmod 600)·읽기전용 SELECT만·비밀값 비노출·파괴적 쓰기 0.

| # | 재실측 쿼리 대상 | 결과 | 무엇을 정정했나 |
|---|----------------|------|----------------|
| RM-1 | 5엔티티 행수(공식·바인딩·구성요소·배선·단가행) | 50·78·149·103·7,293 | S-2·S-5 정정 |
| RM-2 | 직접단가/템플릿단가/등급할인율 | 26 / 0 / 0 | S-3 정정·C9 재확인(등급할인 0) |
| RM-3 | CPQ 옵션그룹/아이템/제약 (distinct prd) | 148/51 · 509 · 10/8 | S-4 정정 |
| RM-4 | 셋트 `t_prd_product_sets` | 28행/7부모 | S-6 확인 |
| RM-5 | 상품 총수(del_yn='N') | 275 | base 동일 확인 |
| RM-6 | 가격소스 보유 상품(공식∪직접) | **104/275** | 카트 전달 GREEN 기준선 |
| RM-7 | 카테고리별 (총·가격가능·CPQ) | live-db-loaded-state §2 표 | 카테고리별 카트 가능성 |
| RM-8 | 코드 앵커 재확인(NON_QTY_DIMS·source priority·evaluate_price/set_price def) | print_opt_cd 포함·TEMPLATE>DIRECT>FORMULA>NONE·:340/:718 | S-1 정정·엔진 의미 불변 확인 |

> **스팟 재실측 원칙 준수:** 전수 재조사 0. 핵심 shape/행수만 확인해 🔴 STALE을 정정하고, 엔진 의미
> (NON_QTY_DIMS·우선순위·공식=합산)는 불변임을 코드로 재확인. 명제(C1~C9·W-0~W-10·F1~F6·K1~K8)는
> 재사용 산출 그대로 승계.

---

## 4. 재사용 자기 점검

- [x] 가격계산 흐름을 코드 근거(`파일:라인` 현행)+기존 종합 재사용으로 못박음.
- [x] 위젯 호출 가능성 판정(호출 가능·R-1~R-7 위험 명시).
- [x] 라이브 적재 현황을 conformance 재사용+라이브 재실측으로 분류(GREEN/YELLOW/RED).
- [x] 새 조사 반복 0(기존 산출 재사용·스팟 재실측만).
- [x] freshness/STALE 표기(🔴 8건 전부 정정)·의심분만 스팟 재실측.
