# 포토북 흡수 후보 — 경쟁사 가격계산 방식 벤치마크 (종단 보강)

> `hpe-benchmark-analyst` 산출 2/3 — 포토북 경쟁사 흡수 후보 + 후니 `t_prc_*`/`evaluate_price` 매핑.
> **표현 가능한 방법만 후보화**(evaluate_price 계약: `price_formulas`→`formula_components`→`price_components`→`component_prices`·`use_dims` / 고정가형 `product_prices`). 표현 불가는 **GAP** 명시.
> **중복 금지**: 책자 흡수(`absorption-candidates-booklet.md` C-BK1~6)는 보존. 본 파일은 **포토북 고유**(페이지 증분 단가·표지×사이즈 기본가 매트릭스·에디터 완제)만.
> **흡수 vs 답습[HARD]**: 메커니즘만 흡수·naming/codes 후니 유입 금지·권위 엑셀(상품마스터/가격표) 최종.

## 출처

- 출처 표기는 `competitor-pricing-models-photobook.md` §출처와 동일(`[red:book]`/`[red:PH]`/`[red:TP]`/`[wow:booklet]`/`[huni:master]`/`[huni:prior]`).
- `[huni:engine]` = `_workspace/huni-dbmap/00_schema/price-engine-ddl.md` (후니 `t_prc_*` 4단 엔진·고정가형 `product_prices` 권위 해석).
- `[huni:ref]` = `_workspace/huni-dbmap/00_schema/ref-products.csv`·`ref-materials.csv` (PRD_000100~107 세트·MAT_000005~007 표지자재 실측).

---

## 0. 흡수 후보 한눈 표

| # | 흡수 후보 | 경쟁사 출처 | 후니 `t_prc_*` 매핑 | 흡수 판정 | trade-off / 가드 |
|---|----------|-----------|---------------------|----------|-----------------|
| **C-PB1** | **페이지 증분 단가**(기본24P + 2P당) | RP 면당단가×페이지 `[red:book]`·후니 master 명시 | 두 표현 경합(아래 §1) — **(a) 합산형 공식**(기본가 comp + 페이지증분 comp) **vs (b) 고정가형 product_prices**(기본가) + 앱 페이지환산 | **흡수=설계 결정**(GAP 가능성·§1) | ★고정가형엔 페이지 차원 부재 → 페이지 증분을 어디서 계산하나가 핵심 |
| **C-PB2** | 표지타입 × 사이즈 기본가 매트릭스 | RP 표지자재 분기 `[red:book]`·후니 master | `component_prices` `use_dims=[siz_cd, mat_cd(표지)]` 2차원 또는 `product_prices`(siz×표지 variant행) | **흡수 불요(동형)** | 표지타입=`mat_cd`(MAT_000005~007)·기본가 2차원 룩업 |
| **C-PB3** | 사진북 에디터 완제 단가 | RP `tmpl_price`+edicus `[red:TP]` | `product_prices` 고정가(기본가) | **흡수 불요(동형)** | 에디터=주문채널·가격과 분리(템플릿≠가격) |
| **C-PB4** | 추가단가 = 사이즈 종속(표지 무관) | 후니 master(8×8=500·A4=600) | 페이지증분 단가행이 `siz_cd`만 차원 | **흡수 불요(정합)** | 표지타입 무관 = 증분단가 차원 축소(돈크리티컬·혼동 금지) |
| **C-PB5** | 책등(seneca) 페이지 파생 | RP `seneca=0.64` `[red:book]` | 앱 런타임 파생·DB 미저장 | **흡수 불요(정합)** | `제본사양_책등`=사양표기·가격 아님(off-grid ceiling 동류) |
| **C-PB6** | 자재↔후가공 비활성 | RP `pdt_disable_pcs_info` `[red:book]` | 미보유 → round-6 CPQ constraints | **흡수후보(책자 공통·포토북 고유 아님)** | C-4 제약 레이어·가격 정합 가드 |
| **C-PB7** | WowPress 작업량 2단 | WP `jobqty0→jobcost0` `[wow:booklet]` | 후니 단일 evaluate_price + 앱 환산 | **흡수 부결(과분화)** | DB 파생저장=후니 원칙 위배·환산규칙만 앱 도메인 단서 |

---

## 1. ★C-PB1 — 페이지 증분 단가의 후니 그릇 표현 (핵심·설계 결정)

포토북 가격모델 = **기본가(24P, 사이즈×표지) + 추가단가(2P당, 사이즈) × ceil((페이지-24)/2)** `[huni:master]`. 후니 두 그릇이 경합하며, 이것이 포토북 흡수의 **유일한 실질 결정**이다.

### (a) 합산형 공식 (`frm_typ=합산형`) — `addtn_yn` Σ

```
PRF_PHOTOBOOK_SUM (frm_typ=합산형)
 ├ COMP_PHOTOBOOK_BASE   (.06 완제품비 or .01 단가형) use_dims=[siz_cd, mat_cd(표지)]  ← 기본가 24P
 └ COMP_PHOTOBOOK_PAGE   (.01 단가형)                 use_dims=[siz_cd]               ← 추가단가 2P당 × N
   addtn_yn='Y' → 기본가 + 페이지증분 합산
```
- **표현 가능**: `component_prices` 차원에 페이지가 직접 없으나, **페이지 증분 횟수 = `((페이지-24)/2)` = 앱 런타임 계산** → 그 횟수를 수량 인자로 페이지 comp에 곱(min_qty=1 단가형 × 횟수). 책자 내지단가×페이지 곱(`[red:book]`)·`compute-in-app-db-stores-lookup` 원칙과 정합.
- **장점**: 부품(기본/페이지) 분리·페이지 증분을 단가행으로 명시·designer 골든 재현 용이.

### (b) 고정가형 product_prices — 페이지 차원 부재 GAP

- 후니 PRD_000100 = **PRD_TYPE.04 (가격포함) 고정가형** `[huni:ref]` — `t_prd_product_prices`(직접단가·차원무관 가능)가 디폴트.
- ★**GAP**: 고정가형 `product_prices`는 **수량×옵션 직접단가**일 뿐 **페이지 차원이 없다** `[huni:engine]`. 페이지수마다 다른 가격(24P=15000·26P=15500·…·150P=46500)을 product_prices 행으로 전개하면 **(페이지 64단계 × 사이즈 × 표지) SKU 폭발**(책자 페이지 SKU 폭발 가드 위배·set-pricing-patterns-photobook §P-9).
- → **고정가형 단독으로는 페이지 증분 표현 불가**(페이지 행 폭발). **(a) 합산형 공식이 정답**(기본가 + 앱계산 증분횟수 × 페이지단가).

### ★흡수 판정 = (a) 합산형 + 앱 페이지환산 (designer 확정 대상)
- 후니 그릇으로 **표현 가능**(합산형 공식·페이지단가 comp). 단 **PRD_TYPE.04 고정가형 디폴트와 충돌** — 포토북은 "가격포함" 시트지만 가격이 페이지 차원을 가지므로 **공식기반(합산형)으로 모델링**해야 함(디지털 명함 inline 고정가형과 다름).
- **D-PB-MODEL 인간/designer 결정**: 포토북을 ① 합산형 공식(PRF_PHOTOBOOK_SUM·기본가 comp + 페이지단가 comp) ② 고정가형 product_prices(불가·페이지폭발) 중 ①. round-2 가격엔진 권위(`schema-design-intent-map` 고정가형=포토북)는 **페이지 차원 추가 전 stale 가능** → 합산형 재분류 검토.

### 가드 [HARD]
- **페이지 증분 단가 ≠ product_prices 페이지행 전개**(SKU 폭발·돈크리티컬). 기본가 + (앱 증분횟수 × 페이지단가) 합산.
- **증분횟수 = `ceil((페이지-24)/2)` = 앱 계산**·DB는 페이지단가(2P당)만 룩업(off-grid ceiling·판수 동류).
- 페이지 0~24는 기본가에 포함(증분 0)·24 초과만 가산(음수 가드).

---

## 2. C-PB2 — 표지타입 × 사이즈 기본가 매트릭스 (흡수 불요·동형)

- **경쟁사**: RedPrinting `book2025` 표지자재(`CVR_MTRL_CD`)가 표지인쇄·표지자재가 분기 `[red:book]`. 후니 master는 표지타입(하드/레더하드/소프트)이 기본가를 가름.
- **후니 매핑**: 기본가 comp `COMP_PHOTOBOOK_BASE` `use_dims=[siz_cd, mat_cd]` — 사이즈(siz_cd) × 표지타입(mat_cd=MAT_000005 하드/006 레더하드/007 소프트 `[huni:ref]`) 2차원 단가행. 8×8 하드 15000·레더 23000·소프트 12000 등 `[huni:master]`.
- **흡수 판정 = 불요(동형)**: 후니 `component_prices` 2차원 룩업이 정확히 담음. 표지타입을 `mat_cd`로 두는 것이 권위(상품마스터 표지타입 = 표지 자재 MAT_000005~007 실재).

---

## 3. C-PB3 — 사진북 에디터 완제 단가 (흡수 불요·동형)

- **경쟁사**: TPPHSET 사진북 = `tmpl_price` + edicus 에디터 `[red:TP]` — 에디터로 디자인, 가격은 완제 통합단가.
- **후니 매핑**: 에디터(KOI/edicus)는 **주문 채널**(`주문방법(필수)_편집기` 컬럼 `[huni:master]`)이지 가격축 아님. 가격은 §1 합산형(또는 기본가). **흡수 불요** — 에디터 템플릿 자산은 위젯/주문 레이어(가격과 분리·P-1b 원칙).
- 가드: 에디터 완제라고 가격을 "에디터 내부 산식"으로 두지 말 것(후니가 페이지 증분을 명시 = 더 투명). 에디터=구성·가격=공식 분리.

---

## 4. C-PB4 — 추가단가 사이즈 종속 (정합·돈크리티컬 가드)

- **후니 master 관측**: 추가단가(2P당)가 **사이즈만 종속**(8×8=500·10×10=1000·A5=300·A4=600), 표지타입 **무관**(같은 사이즈면 하드/레더/소프트 동일 추가단가) `[huni:master]`.
- **후니 매핑**: 페이지단가 comp `COMP_PHOTOBOOK_PAGE` `use_dims=[siz_cd]`(표지 차원 제외). 기본가 comp는 `[siz_cd, mat_cd]` 2차원, 페이지단가 comp는 `[siz_cd]` 1차원 — **차원이 다르다**.
- **흡수 판정 = 정합**: 후니 차원 모델이 직접 담음(comp별 use_dims 독립).
- 가드 [HARD]: **기본가 차원(siz×표지)과 페이지단가 차원(siz만)을 혼동 금지**. 페이지단가에 표지 차원을 넣으면 단가행 중복·오청구(돈크리티컬). 큰 사이즈일수록 페이지당 비쌈(면적 비례)이 도메인 정합.

---

## 5. C-PB5/C-PB6/C-PB7 — 책자 공통 (포토북 고유 아님)

| # | 후보 | 판정 | 비고 |
|---|------|------|------|
| C-PB5 | 책등(seneca) 페이지 파생 | 흡수 불요(정합) | 앱 런타임 파생·DB 미저장·`제본사양_책등`=사양표기. 책자 C-BK3 동형. |
| C-PB6 | 자재↔후가공 비활성 | 흡수후보(책자 공통) | RP `pdt_disable_pcs_info` → round-6 CPQ constraints(C-4). 포토북 고유 아님. |
| C-PB7 | WowPress 작업량 2단 | 흡수 부결(과분화) | DB 파생저장=후니 원칙 위배. 환산규칙만 앱 도메인 단서. 책자 C-BK5 동형. |

---

## 6. 종합 판정 + designer 인계

### 6.1 흡수 실질
- **신규 가격축(테이블) = 0** — 책자·문구·캘린더 종단 결론과 일관. 포토북은 기존 그릇(합산형 공식 + component_prices 차원)으로 표현.
- **흡수 실질 결정 = 1건(C-PB1)** — 페이지 증분 단가를 **(a) 합산형 공식 + 앱 증분환산**으로 표현(고정가형 product_prices는 페이지폭발 GAP). 나머지(C-PB2~5)는 동형/정합·흡수 불요, C-PB6는 책자 공통 제약 흡수후보, C-PB7 부결.
- **GAP 1건**: 고정가형 `product_prices`에 **페이지 차원 부재** → 포토북을 PRD_TYPE.04(가격포함 고정가형) 디폴트로 두면 페이지 증분 표현 불가. **합산형 공식기반 재분류 필요**(D-PB-MODEL).

### 6.2 designer 인계 (후속 에이전트가 판정·설계)
- **D-PB-MODEL**: 포토북 = 합산형 공식(PRF_PHOTOBOOK_SUM = 기본가 comp[siz×표지] + 페이지단가 comp[siz] × 앱증분횟수). 고정가형 product_prices 단독 불가(페이지폭발). `schema-design-intent-map` 고정가형 분류 stale 검토.
- **표지타입 = `mat_cd`**(MAT_000005 하드/006 레더하드/007 소프트) 기본가 2차원 룩업.
- **페이지단가 차원 = `siz_cd`만**(표지 무관) — 기본가와 차원 분리(C-PB4 가드).
- **세트 "구성"(PRD_000100 parent + 표지/내지/면지 sub_prd `SEMI_ROLE`) vs 가격(완제 기본가+증분) 분리** = P-1b(set-pricing-patterns-photobook §P-9).
- **골든**: 8×8 하드 24P = 15000·40P = 15000 + ((40-24)/2)×500 = 15000+4000 = 19000·A4 레더 50P = 26000 + ((50-24)/2)×600 = 26000+7800 = 33800 (designer 검증 골든 입력).

### 6.3 naming 유입 가드 [HARD]
`digital_price`/`tmpl_price`/`book2025`/`INN_PAGE`/`PHBK*`/`PHBKMYB`/`TPPHSET`/`seneca`/`MTRL_CD`(RXART250 등)/`CVR_MTRL_CD`/`pdt_disable_pcs_info`/`jobqty0`/`jobcost0` 후니 유입 금지. 후니 `PRF_PHOTOBOOK_*`/`COMP_PHOTOBOOK_*`/`siz_cd`/`mat_cd`/`SEMI_ROLE`/`page_rules` 컨벤션으로 번역(`dbmap-naming-standardization` 권위순서: 후니 레거시 → 라이브 DB → rpmeta 흡수 → 인쇄표준).
