# 와우 앵커 스펙 — 네임스페이스 문법·lint 규약·브랜드축·닫힌세계 확장 (§35 Phase 3)

> 작성: 2026-07-04 · mbo-ontology-architect · 방법론 = `mbo-ontology-design` 스킬.
> 상위 권위: §33 `02_ontology/ontology-schema.md` §1.0(앵커 3유형·닫힌세계 D-6)·`file-format-spec.md`(lint L-*/I-*) **읽기 재사용·무손상**.
> **[HARD] 닫힌세계·지어내기 차단 유지**: 모든 브랜드 실물 노드는 실 앵커(후니 t_* / 와우 catalog·api·pdf) or GAP. 앵커 없는 노드 = upper_concept·brand·gap·intent만.
> **[HARD] LLM 손전사 금지**: 와우 수치는 스크립트 전사(`_cache/*.py` 재현). catalog JSON 파싱만 권위.
>
> **읽는 법:** "앵커"는 이 개념이 진짜 존재한다는 증거 좌표다. 후니는 DB(t_* 테이블)가 증거, 와우는 DB가 없어 catalog JSON·API 문서·SPEC PDF가 증거다. 이 문서는 와우 증거 좌표를 어떻게 쓰는지(문법)와, 컴퓨터가 "이 노드 진짜냐"를 자동 검사하는 규칙(lint)을 정한다.

---

## 1. 앵커 네임스페이스 — 후니 3유형(승계) + 와우 3유형(신설)

### 1.1 후니 앵커 3유형 (§33 §1.0 승계·불변)

| # | 문법 | 예 | 검사 |
|---|------|-----|------|
| H-1 | `t_<table>/<CODE>` | `t_prd_products/PRD_000016` | 라이브 코드 실재(L-17 닫힌세계·junction=부모 prd_cd) |
| H-2 | `xlsx:<파일>#<시트>!<셀범위>` | `xlsx:상품마스터_260702.xlsx#디지털인쇄!B3` | 권위 엑셀 셀 좌표 |
| H-3 | `none`(+사유) | `none  # 사유: KB 전용 레이어` | 사유 필수(term·rule·decision·gap·intent) |

### 1.2 와우 앵커 3유형 (§35 신설·§33과 병행)

| # | 문법 | 필드 규칙 | 예 | 원천 |
|---|------|-----------|-----|------|
| **W-1 catalog** | `catalog:<resource>#<jsonpath>` | resource ∈ {`products/<id>.json`, `categories/<catid>.json`, `index.json`}. jsonpath는 **`raw.prod_info.<axis>` 우선**(normalized `options`는 파생·부분) | `catalog:products/40070.json#raw.prod_info.prsjobinfo` · `catalog:index.json#productCount` | `docs/wowpress/catalog/`(2025-10-14 devshop 수집) |
| **W-2 wowpress-api** | `wowpress-api:<§>-<이름>#<field>` | §번호 = API 문서 절(6.2~9.1·7.1~7.6 제약 SPEC) | `wowpress-api:6.4#ord/cjson_jobcost` · `wowpress-api:7.1-규격#req_awkjob` | `docs/wowpress/wowpress-api-document.txt` |
| **W-3 wowpress-pdf** | `wowpress-pdf:<file>#p<page>` | file ∈ {`products_spec_v1.0.pdf`, `price_order_spec_v1.01.pdf`} | `wowpress-pdf:price_order_spec_v1.01.pdf#p5` | `docs/wowpress/*.pdf` |

**보조 앵커(전사 재현·W-1 하위형)**: `_cache/<file>.csv#<column>` — 스크립트 전사값(`wow_products.csv`·`wow_domain_prsjob.csv` 등). 재현 스크립트 `_cache/_*.py`. **원천은 항상 W-1 catalog**, `_cache`는 파싱 결과(값 확증용 병기).

### 1.3 와우 앵커 우선순위 (권위 순서)

```
W-1 catalog(raw.prod_info)  >  W-2 api(계약 SPEC)  >  W-3 pdf(SPEC 문서)  >  _cache(전사 재현)
```
- 상품 사실(축·옵션·제약) = **W-1 raw.prod_info** 1차. normalized `options`(sparse·orderQuantities/coverTypes/additionalOptions만) 인용 금지(파생).
- API 계약·제약 문법 = W-2. 가격 메커니즘·status 코드 = W-2(6.4·9.1) or W-3.
- catalog 노후(2025-10-14) 의심분 = devshop.wowpress.co.kr 라이브 재확인(gstack 읽기전용) 후 `captured_at` 갱신.

---

## 2. 브랜드축 필드 규약

### 2.1 `brand` 속성 (브랜드 실물 노드 필수)

- **대상**: product·price_formula·price_component·print_method·product_family·size·material·print_option·process·option_group·constraint·bundle_qty·plate_size·quote_function 등 **브랜드 실물 노드 전체**.
- **값**: `brand ∈ {huni, wowpress, red}`(폐쇄 집합·소문자). red는 미포함(향후 append).
- **미대상**(브랜드-중립·brand 없음): `upper_concept`·`term`·`brand`(자기 자신)·표준 레이어.
- **id 접두 규약**(G-EDGE-1 해소): 와우 = `wow-<유형>-<식별키>`(예 `wow-product-40070`·`wow-paper-<paperno>`·`wow-size-<sizeno>`·`wow-color-<colorno>`·`wow-prsjob-<jobno>`·`wow-awkjob-<jobno>`·`wow-family-<catid>`·`wow-cat-<catid>`·`wow-jobcost`). 후니 = §33 접두 유지. brand 속성 병기로 id·속성 이중 안전.

### 2.2 E21 brand 노드 (3개)

```yaml
id: brand-wowpress
type: brand
anchor: none        # 사유: 출처 축·조직(schema.org Organization)
badge: verified
props: {brand_code: wowpress, legal_name: "와우프레스", homepage: "https://www.wowpress.co.kr", catalog_source: "docs/wowpress/catalog/ (2025-10-14)"}
standards: {schema_org: "brand(Organization)"}
```
- brand 노드는 **프로퍼티 조회 대상**(신규 엣지 불필요). "와우 상품 전량" = `brand=wowpress` 필터. huni/wowpress 2개 + red(향후).

---

## 3. 닫힌세계 검사 확장 (lint 규약 — §33 L-*/I-* 승계 + 신설)

### 3.1 §33 lint 승계

L-4(개체 유형 화이트리스트)·L-14(관계 폐쇄목록)·L-17(닫힌세계 앵커 실재)·I-2(앵커 스크립트 검사)·I-3(source/target 타입)·I-5(끊긴 가격 사슬)·O1(출처 강제)·O2(오염 블록리스트) 전량 승계.

### 3.2 화이트리스트 확장 (다중브랜드)

| lint | §33 | §35 확장 |
|---|---|---|
| **L-4 개체 유형** | 17종 | + 신규 5(`upper_concept`·`print_method`·`quote_function`·`product_family`·`brand`) = **22종** |
| **L-14 관계 폐쇄목록** | 19종 | + 신규 4(`instance_of`·`same_family_as`·`price_model_differs`·`component_differs`) = **23종**(`mapped_to` 승계·중복 아님) |
| **앵커 네임스페이스 화이트리스트** | `t_*/`·`xlsx:`·`none` | + `catalog:`·`wowpress-api:`·`wowpress-pdf:`(+보조 `_cache/*.csv#`) |

### 3.3 신설 lint 규칙 (§35)

| # | 규칙 | 판정 |
|---|------|------|
| **L-BR-1** | 브랜드 실물 노드는 `brand ∈ {huni,wowpress,red}` 필수 | 누락 = FAIL |
| **L-BR-2** | id 접두가 `wow-`면 `brand=wowpress` 일치 (레드 `red-`↔red) | 불일치 = FAIL |
| **L-AN-1** | 와우 노드 앵커는 W-1/W-2/W-3(+_cache) 중 하나 or GAP. `catalog:`는 실 파일 `docs/wowpress/catalog/<resource>` 존재 검사 | 미존재 = FAIL(환각 차단) |
| **L-AN-2** | `catalog:products/*.json#<jsonpath>` jsonpath는 `raw.prod_info.*` 우선. normalized `options` 직인용 = WARN(파생) | WARN |
| **L-AN-3** | 와우 수치 값 노드는 `_cache/*.csv#<column>` 전사 병기 필수(LLM 손전사 흔적=값이 catalog·_cache에 없으면 FAIL) | 미전사 = FAIL |
| **L-X-1** | 교차관계(X-3/4/5) 엣지는 **양쪽 앵커 병기**(후니 앵커 + 와우 앵커). 한쪽 앵커 없음 = 엣지 금지 | 편측 = FAIL |
| **L-X-2** | `instance_of`(X-1) 타깃은 `upper_concept` 유형만. source는 브랜드 실물 | 타입 오류 = FAIL |
| **L-UP-1** | `upper_concept` 노드는 anchor=none(+사유) + `standard_url` or `standard_class` 필수(표준 근거 없는 상위개념 = 지어내기) | 표준 미근거 = FAIL |

### 3.4 닫힌세계 원칙 (지어내기 완전 차단·§33 승계 + 확장)

```
브랜드 실물 노드  →  반드시 실 앵커(후니 t_* / 와우 catalog·api·pdf) or GAP 노드
앵커 none 허용    →  upper_concept(+표준 근거) · brand · term · rule · decision · gap · intent  뿐
와우 값(수치)     →  스크립트 전사(_cache)만 · LLM 손전사 = L-AN-3 FAIL
불확실           →  GAP 노드(§33 양면·gap 패턴 승계) · 지어내지 않음
```

---

## 4. 앵커 사용 예 (유형별)

| 노드 | 앵커 | 유형 |
|------|------|------|
| `wow-product-40070`(특수지명함) | `catalog:products/40070.json#meta` | W-1 |
| `wow-prsjob-happan-digital` | `catalog:products/40070.json#raw.prod_info.prsjobinfo` + `_cache/wow_domain_prsjob.csv#jobno` | W-1+보조 |
| `wow-paper-스노우지` | `catalog:products/*.json#raw.prod_info.paperinfo` + `_cache/wow_domain_papergroups.csv` | W-1+보조 |
| `wow-jobcost`(quote_function) | `wowpress-api:6.4#ord/cjson_jobcost` | W-2 |
| 가격 status 코드(402~411) | `wowpress-api:9.1` 또는 `wowpress-pdf:price_order_spec_v1.01.pdf#p5` | W-2/W-3 |
| `wow-family-사인제품` | `catalog:categories/<catid>.json` | W-1 |
| GAP: 와우 ordcost_base 내역 | `none` (사유: map 스키마 비공개·GAP-PRICE-3) | gap |

---

## 5. GAP (정직 기록)

- **G-ANCHOR-1**: catalog 노후(2025-10-14·G-STRUCT-4 승계) → 옵션/가격 갱신분 미반영 가능. 의심 노드는 devshop 라이브 재확인 후 `captured_at`·badge 갱신(생성≠검증).
- **G-ANCHOR-2**: 와우 `optioninfo` vs `prodaddinfo` 2채널 경계 catalog만으론 불명확(G-STRUCT-2) → W-2 `wowpress-api:8.8/8.9` 라이브 조회 필요. 현재 AccessoryComponent(U-14) 노드는 2채널 병기 주석.
- **G-ANCHOR-3**: 와우 jobcost payload 전개 JSON 미확보(GAP-PRICE-1) → prsjob 맵 내부 필드 정확 배치 미확정. quote_function 노드 input_axes는 축 목록까지(필드 위치는 라이브 호출/PDF 후속).
- **G-ANCHOR-4**: 레드 앵커 네임스페이스 미정의 → 레드 소스(라이브 역공학=§11 RP-Meta 자산) 파악 후 `red:` 유형 신설(catalog·api 유무 확인 후).

## Sources
- §33 `02_ontology/ontology-schema.md` §1.0(앵커 3유형·junction 규약·닫힌세계 D-6)·§3(출처 5필드·badge)·`file-format-spec.md`(lint L-*/I-* — 참조) — 승계
- §35 `01_analysis/wowpress-structure.md` §7(와우 앵커 규약)·§1(catalog 이중구조 raw.prod_info)·§6(API §목록)·GAP §G-STRUCT-*
- §35 `_cache/*.py`·`*.csv`(스크립트 전사 재현)·`.claude/rules/harness/huni-multibrand-ontology.md`(와우 앵커 3유형 [HARD]·LLM 손전사 금지)
