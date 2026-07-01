---
name: huni-widget-db-cartography
description: >
  후니 위젯 하네스의 라이브 DB→정규화 계약 매핑 방법론. 현재 라이브 Railway DB(t_prd_*·t_prc_*·CPQ
  option_groups/options/option_items·constraints·evaluate_price 단일 권위)를 읽어, 상품의 모든
  구성요소·옵션·가격·제약을 위젯 정규화 계약(data-contract)으로 매핑하고, 상품군별 대표 상품 1개를 종단
  파일럿한 뒤 동형 전파한다. 기존 §7/§13~§29/live-snapshot 산출을 데이터 권위로 재사용(재조사 금지),
  STALE huni-db-mapping.md(가격/제약 미작성 전제) 대체, 가격 서버 권위(evaluate_price 불투명 결과), DB 미적재.
  트리거: 라이브 DB 위젯 매핑, DB 엔티티 속성 위젯, 후니 어댑터 데이터, DB 컨버전 매핑, 상품군 대표 매핑,
  구성요소 옵션 가격 제약 매핑, 동형 전파 매핑, 위젯 DB 카토그래피, DB 매핑 다시. 단순 질문은 직접 응답.
license: Apache-2.0
allowed-tools: Read, Write, Edit, Grep, Glob, Bash, TodoWrite
metadata:
  version: "1.0.0"
  category: "domain"
  status: "active"
  updated: "2026-07-01"
  tags: "huni, widget, db-mapping, normalized-contract, adapter, evaluate-price, cpq, isomorphism, conversion"
---

# Huni Widget — 라이브 DB → 정규화 계약 매핑 (DB 카토그래피)

`hw-db-cartographer`가 위젯 **컨버전 선행(③')** 단계에서 쓰는 방법론. 목적: 현재 라이브 DB에 적재된 상품의 모든 구성요소·옵션·가격·제약을 위젯 정규화 계약으로 매핑해, hw-builder가 `createHuniAdapter`를 구현할 수 있는 "매핑 규칙 + 대표 상품 실데이터 인스턴스"를 산출한다.

## 0. 왜 이 단계가 필요한가 (STALE 정정)

기존 `03_spec/huni-db-mapping.md`(2026-06-02)는 **"후니 가격·제약 미작성"을 전제**로, 위젯이 Red fixture로만 진행 가능하다고 결론냈다. 그 전제는 폐기됐다 — §7·§13~§29 하네스가 라이브 DB에 다음을 적재 완료:

- **가격**: `t_prc_price_formulas`(공식 48)·`t_prc_formula_components`(301)·`t_prc_price_components`(146)·`t_prc_component_prices`(단가행 7,293)·`t_prd_product_price_formulas`(바인딩 76). `pricing.py:evaluate_price`(:394) 동작.
- **CPQ 옵션**: `t_prd_product_option_groups`·`t_prd_product_options`·`t_prd_product_option_items`(polymorphic ref_dim_cd).
- **제약**: `t_prd_product_constraints`·`t_prd_product_process_excl_groups`.

따라서 컨버전이 **실제로 가능**해졌고, 이 방법론은 라이브 DB를 권위로 매핑을 새로 수행한다. 매핑 완료 시 huni-db-mapping.md에 `> SUPERSEDED by db-cartography/` 표기.

## 1. 권위 순서 [HARD]

1. **라이브 DB / 스냅샷** (`_workspace/_foundation/live-snapshot/latest/*.csv`) — 매핑의 실측 기준. 가격/제약 포함 현재 상태
2. **가격엔진 코드** (`pricing.py`·`models.py`) — evaluate_price 계약·입력 shape·차원 매칭 규칙
3. **기존 하네스 산출** (§13 engine-contract·§21 conformance-checklist·§29 readiness·§7 CPQ) — 재사용(재조사 금지)
4. **위젯 계약** (`data-contract.md`·`04_build/src/contract/`) — 매핑 목표 shape
5. STALE 문서(huni-db-mapping.md·table-spec_260602.html)는 골격 참고만, 사실 권위 아님

## 2. 토큰 효율 — 스냅샷 우선

매 셀 SELECT는 토큰 폭발. 우선 `live-snapshot/latest/*.csv`를 Bash(`grep`/`awk`/`csvcut`)로 결정론 조회한다. 스냅샷에 없거나 신선도 의심 시에만 `.env.local RAILWAY_DB_*`로 읽기전용 SELECT(`psql -c "SELECT ..."`). 스냅샷 신선도는 `_manifest.csv` 확인. 비밀값은 산출물에 평문 금지.

## 3. 계약 필드 → 라이브 t_* 매핑 규칙

`data-contract.md`의 각 계약 타입을 라이브 테이블로 매핑한다. 핵심 규칙(상세 매트릭스는 `db-contract-mapping.md`에 산출):

### 3.1 NormalizedProduct
| 계약 필드 | 라이브 출처 | 변환 |
|-----------|------------|------|
| `code`/`name` | `t_prd_products.prd_cd`/`prd_nm` | 그대로(불투명) |
| `unit` | `t_prd_product_bundle_qtys.bdl_unit_nm` 또는 `t_cod_base_codes`(prd_typ_cd 파생) | 직접 컬럼 없으면 파생 |
| `priceSchemeKey` | `t_prd_product_price_formulas.frm_cd` | 불투명 echo(이제 적재됨) |
| `sides` | `prd_typ_cd`/`semi_role_cd` + `t_prd_product_sets`(표지/내지) | 책자/세트=`[default,inner]` |
| `optionGroups` | size/material/print/process/option_groups 테이블군 | §3.2 |
| `constraints` | `t_prd_product_constraints`·`excl_groups`·`materials.dep_proc_cd` | §3.3 |
| `editors`/`cta` | `editor_yn`/`file_upload_yn` | `{koi:editor_yn==='Y', pdf:file_upload_yn==='Y'}` |

### 3.2 옵션 그룹 → componentType
옵션은 데이터셋 "이름"이 아니라 **테이블 종류 + 값 특성**으로 componentType 판정:

| 정규화 OptionGroup | 라이브 출처 | componentType 판정 |
|-------------------|------------|-------------------|
| 규격(size) | `t_prd_product_sizes ⋈ t_siz_sizes` | `option-button`(`dflt_yn`→기본, `disp_seq`→순서) |
| 판형(plate) | `t_prd_product_plate_sizes ⋈ t_siz_sizes` | `select-box`/`option-button`. **종이류만 유효**(§29 [HARD]) |
| 용지(material) | `t_prd_product_materials ⋈ t_mat_materials` | 값多=`select-box`, 이미지有=`image-chip`. `use_loc`→side 분기 |
| 도수(print) | `t_prd_product_print_options ⋈ t_clr_color_counts` | `option-button`. `chnl_cnt`→`priceColorCount` 평면화 |
| 후가공(process) | `t_prd_product_processes ⋈ t_proc_processes` | `finish-button`. `prcs_dtl_opt` 색상有→`color-chip`. 택일=excl_groups |
| **CPQ 옵션** | `t_prd_product_option_groups/options/option_items` | `sel_typ`→`multiple`, polymorphic `ref_dim_cd` 해소(자재/공정/사이즈 환원) |
| 수량(quantity) | `min/max/dflt_qty,qty_incr` + `bundle_qtys` | `counter-input` (InputSpec) |
| 내지페이지 | `t_prd_product_page_rules` | `page-counter-input` |
| 비규격 치수 | `nonspec_yn='Y'` + `nonspec_*_min/max` | `area-input`(어댑터가 그룹 생성) |
| addon | `t_prd_product_addons` ⋈ 템플릿 | addon 템플릿 경로 |

CPQ 옵션의 polymorphic `ref_dim_cd`는 [[dbmap-cpq-option-layer-mapping]] 규칙으로 차원 환원(L1≠L2).

### 3.3 캐스케이드 제약 (6종)
이제 제약 데이터가 적재됨 — Red fixture가 아니라 **라이브 제약으로 population**:
- ① material→process disable: `t_prd_product_constraints`(JSONLogic) 또는 `materials.dep_proc_cd` / `excl_groups`(택일)
- ② quantity: `min/max/dflt_qty,qty_incr` + `page_rules` (직접)
- ③ dosu↔color: `t_clr_color_counts.chnl_cnt` → `priceColorCount` 평면화
- ④ size: `t_siz_sizes.cut/work_width/height` (직접 1:1)
- ⑤ essential/hidden → required/visible: `mand_proc_yn` + 택일 `mand_yn`. hidden 분류는 constraint/code테이블
- ⑥ base: `t_siz_sizes`(여백) + `nonspec_*` (직접)

### 3.4 가격 (서버 권위 [HARD])
위젯은 단가/공식 모름. 매핑은 **경로 정합만**:
```
위젯 NormalizedPriceRequest (8축 선택: dimensions/colorCounts/materials/quantity/pageCount/selectedFinishes)
  → 어댑터/BFF → evaluate_price(target, selections, qty, grade_cd)  [pricing.py:394]
       (세트는 evaluate_set_price(set_prd_cd, members, set_selections, copies) [:844])
  → final_price + breakdown
  → NormalizedPriceBreakdown { ok, finalPrice, vat, shipping, lines[] }
```
- `evaluate_price`는 차원 자동매칭·단가/합가·할인을 내부 처리. 위젯은 불투명 결과만.
- **PRICE=0 = 결함 신호 [HARD]** ([[huni-widget-red-price-never-zero]]): 골든은 PRICE≠0이어야 함. 0이면 매핑/적재 결함 → §7/§26 라우팅.
- `t_prc_*` 공식 스키마를 위젯에 포팅하지 않는다. 매핑은 evaluate-price-contract.md에 골든 케이스로 산출.

## 4. 동형 전파 (대표 1개 파일럿 → 전파)

사용자 결정 = **상품군별 대표 상품 1개 종단 파일럿 → 동형 전파**.

1. **동형 클래스 분류** — §29 복잡도 클래스(고정가by-siz·면적입력·셋트조립·옵션캐스케이드·addon템플릿) 재사용. 위젯 렌더·가격모델·캐스케이드 형태가 같으면 동형
2. **대표 선정** — 각 상품군에서 준비도 높고(§29 L3+) 그 군의 분기를 모두 traverse하는 상품 1개
3. **종단 파일럿** — 대표를 라이브 데이터로 NormalizedProduct 완전 조립 → componentType 렌더 가능 확인 → evaluate_price 골든(PRICE≠0)까지. `<group>/pilot-<prd_cd>.md`
4. **동형 입증 후 전파** — 같은 클래스 나머지는 "대표와 동형"임을 입증하고 매핑 규칙만 전파(전수 재조립 금지). 동형 깨지면 새 클래스 분리·새 대표

## 5. 위젯에 필요한 DB 엔티티·속성 도출

사용자 directive("위젯에 필요한 DB 엔티티 및 속성까지 모두 고려") 충족: `widget-db-entities.md`에 **고객이 상품 선택→옵션 확인→주문 조건 충족**에 실제 필요한 테이블·컬럼을 전수 표기.
- 필요(위젯 직접 소비): 상품·옵션 차원·캐스케이드·가격경로·에디터/업로드·주문조립
- 미사용(위젯 무관): 내부 회계·생산메타 등
- 추가필요(갭): 위젯이 요구하나 DB에 없는 속성 → `gaps-and-recommendations.md`로 분류

## 6. 갭 분류 (정직)

매핑 불가·구멍은 은폐 말고 3분류:
- **(A) 어댑터 흡수 가능** — 계약/위젯 무변경, 어댑터 파생/역매핑으로 해결 (대부분)
- **(B) 계약 변경 필요** — 위젯 가시 계약 1필드 추가 등. hw-architect 권고(단순성 우선 최소화)
- **(C) DB 작성/교정 필요** — 라이브에 데이터 없음/오적재. §7 dbmap/§18/§26 라우팅(인간 승인). 이 단계는 매핑·파일럿·갭까지

## 7. 산출물·게이트

산출 `_workspace/huni-widget/03_spec/db-cartography/`: `db-contract-mapping.md`·`widget-db-entities.md`·`isomorphism-classes.md`·`<group>/pilot-<prd_cd>.md`·`evaluate-price-contract.md`·`gaps-and-recommendations.md`.

**게이트(hw-architect/hw-qa 인계 전):**
- 대표 상품 NormalizedProduct가 라이브 데이터로 완전 조립되는가(빈 필드·미매핑 없음)
- evaluate_price 골든 PRICE≠0 재현되는가
- componentType 14종 사상이 결정되는가
- 갭이 (A)/(B)/(C)로 분류되고 (C)는 라우팅 명시됐는가
- huni-db-mapping.md STALE supersede 표기됐는가

## 8. HARD 제약

- 라이브 읽기전용 SELECT만 — INSERT/UPDATE/DELETE 0. 결함 교정은 위임(인간 승인)
- 가격 서버 권위 — evaluate_price 불투명 결과만. 공식 위젯 포팅 금지
- 위젯 계약 불변 목표 — 매핑은 어댑터가 흡수. 계약 변경은 (B) 갭으로만 권고
- 재사용 우선 — §13/§21/§29/§7 산출 재사용. 재조사 금지
- 비밀값(`.env.local`·JWT·자격) 산출물 평문 금지
