---
id: SPEC-PRICEWIRE-001
doc: design
version: "0.1.4"
updated: 2026-08-27
status: draft
tier: L
---

# 설계 — 화면 교정 절차 (webadmin 실화면)

> 본 문서는 **작업 수단의 설계**다. 무엇을 고칠지는 `spec.md`, 언제 고칠지는 `plan.md`, 다 고쳤는지는 `acceptance.md`.
> 모든 폼 계약은 `raw/webadmin/webadmin/catalog/price_views.py` 정적 판독 기준이며 **실동작은 미검증**(research.md §16).

---

## 1. 쓰기 surface 전수 (허용 경로)

```
price_views.py:1312 @require_POST / :1313 price_grid_save(request, comp_cd)
price_views.py:1505 @require_POST / :1506 price_source_save(request, prd_cd)
price_views.py:1657 @require_POST / :1658 discount_grid_save(request, dsc_tbl_cd)
```

계산(부작용 없음): `:3093 price_sim_constraints` · `:3105 price_simulate` · `:3219 price_simulate_set` · `:3238 simulate_set_core`(위젯 `widget_api` 와 공용 권위 함수).

이 3개 외의 쓰기 경로는 본 SPEC 이 사용하지 않는다. `discount_grid_save` 는 본 SPEC 범위에서 사용하지 않는다(검증 규칙 미확인).

---

## 2. M1 절차 — `price_source_save` (가격 뷰어)

### 2.1 폼 계약

`price_views.py:1505-1513` — JSON body `{kind, action}` 4종:

| kind | 필드 | 용도 |
|---|---|---|
| `price` | `apply_ymd`, `unit_price` | 직접단가(`t_prd_product_prices`) |
| `formula` | `apply_bgn_ymd`, `frm_cd` | **상품↔공식 바인딩 — 배선 1차 수단** |
| `discount` | `apply_bgn_ymd`, `dsc_tbl_cd`, `comp_cd`(''=총액) | `comp_cd` 지정 시 현재 공식에 그 구성요소가 없으면 서버 422(`:1563-1568`) |
| `tmpl_price` | `tmpl_cd`, `apply_ymd`, `unit_price` | 템플릿가 |

전부 `update_or_create` / `filter().delete()` → **멱등**.
프런트 필드 id: `#src-kind` · `#src-ymd` · `#src-price` · `#src-frm` · `#dsc-ymd` · `#dsc-comp` · `#dsc-tbl` (`catalog/templates/catalog/price_viewer.html:229-234,263-264,379-397`).

### 2.2 절차

1. `/admin/price-viewer/?prd=<PRD_CD>` 진입 → **직접단가 보유 여부 먼저 확인**(보유 시 E1 아님 → 종료).
2. 「가격 구조 보기」(`/admin/price-viewer/<prd_cd>/diagram/`)로 현재 배선 확인.
3. `kind:"formula"` + `frm_cd` 선택 → 미리보기 → **인간 승인** → 저장.
4. 시뮬레이터로 단건 재계산 → `result_sum.PRICE ≠ 0` 확인.
5. 원장 기입.

**적용일자 함정**: 같은 종류라도 적용일자별 다건이며 **최신 적용분이 현재가**. 미래 일자로 등록하면 현재가가 0 으로 남는다(0원 진단 FAQ, `tools/manual_content.py:720-723`).

### 2.3 「적용 대상」 지정 절차 — `kind:"discount"` + `comp_cd` [REQ-PW-023]

할인 범위 위반(총액 스코프 오지정)의 유일한 교정 수단이다. 엔진 변경은 없다 — `pricing.py:963 _component_discounts` 가 이미 구현·동작 중이고, 바꾸는 것은 `t_prd_product_discount_tables.comp_cd` 한 필드뿐이다.

**폼 계약** (`price_views.py:1505-1513`, `kind:"discount"` 행): `{kind:"discount", apply_bgn_ymd, dsc_tbl_cd, comp_cd}`.
- `comp_cd = ''`(빈값) = **총액 할인** — 후가공·부속까지 할인이 걸린다(= 위반 형태).
- `comp_cd = <구성요소 코드>` = **그 부품 금액에만 할인** — 권위 원리(`인쇄가공비에만 적용`)와 일치하는 형태.
- 서버 검증: `comp_cd` 지정 시 **현재 공식에 그 구성요소가 없으면 422**(`price_views.py:1563-1568`). 즉 잘못된 코드는 저장 자체가 거부되므로, 422 는 실패가 아니라 **오지정 방어가 작동한 신호**다.

**절차**:

1. `/admin/price-viewer/?prd=<PRD_CD>` 진입 → 「가격 구조 보기」(`/<prd_cd>/diagram/`)로 **현재 공식의 구성요소 목록**을 확보한다.
2. 그 목록에서 **인쇄가공비 구성요소 코드 1개**를 특정한다(아크릴 계열 기준형: `COMP_ACRYL_CLEAR3T`). 후가공·부속(자석·집게·머리끈 등)은 대상이 아니다.
3. 대상 코드를 특정하지 못하면 **중단하고 원장에 `needs_authority` 로 기록**한다 — 추정으로 지정하지 않는다.
4. 현재 할인 바인딩의 `dsc_tbl_cd` 와 `apply_bgn_ymd` 를 그대로 읽어 보존한다(할인표 자체는 건드리지 않는다, spec §2.2).
5. 화면 필드 `#dsc-comp` 에 2 에서 특정한 `comp_cd` 를 지정 → 미리보기 → **인간 승인** → 저장(`update_or_create` → 멱등).
6. 시뮬레이터 단건 재계산 → **후가공·부속 금액에 할인이 걸리지 않는지** 확인. 기준 형태는 이미 정상인 `PRD_000146`(아크릴키링) — 단 이 상품은 **2026-08-24 게시중단되어 현재 게시 분모 밖**이다(`progress.md §E.2 M0-2 B` 발견 J). 라이브 데이터는 남아 있어 **참조 형태로는 유효**하지만, 통과 판정을 「게시 상품과 같은 모양」으로 서술하지 않는다.
7. 라이브 읽기전용 SELECT 로 `comp_cd` 가 빈값이 아님을 재확인하고 원장 기입(REQ-PW-018 계측 수단).

**겹침은 금지가 아니라 허용이다 [실측 정정]**: `pricing.py:934` 의 "이중 적용" 경고는 *구성요소 스코프 행(`comp_cd≠''`)이 **총액 조회 경로에** 섞이는 것* 을 막는 불변식이며, 실제 총액 조회는 `filter(comp_cd="")` 로 이미 걸러진다(`pricing.py:936-937`). 총액 행과 구성요소 행의 **공존 자체는 설계상 허용**이다 — `pricing.py:970` docstring verbatim `총액 스코프('')가 그 뒤 순차 적용된다(겹침 허용, 사용자 확정)`, 적용 순서는 `pricing.py:679` verbatim `구성요소 스코프 → 총액 스코프('') → 등급 (순차·겹침 허용)`. 앱 내장 매뉴얼도 같다(`raw/webadmin/tools/manual_content.py:328-329` verbatim): `할인은 적용 대상별로 나란히 걸 수 있으며(전체 금액 1건 + 구성요소별 여러 건), 구성요소 할인 → 전체 금액 할인 → 등급 할인 순서로 차례로 적용됩니다.`

따라서 교정은 **총액 행의 스코프를 구성요소로 옮기는 변경**이며, 총액 행을 남긴 채 구성요소 행을 **추가**하면 두 할인이 순차로 겹쳐 걸려 권위 대비 **더 큰 저청구**가 된다. 즉 금지되는 것은 겹침 자체가 아니라 **본 교정에서의 행 추가**다 — 기존 총액 행을 수정하고, 새 행을 만들지 않는다.

---

## 3. M2 절차 — `price_grid_save` (단가표 편집) [최고 위험]

### 3.1 계약과 위험

`price_views.py:1313-1327`: 자연키 = (`apply_ymd` + 차원컬럼 + `dim_vals`).
**DB 에만 있고 그리드에 없는 키는 삭제된다(full-sync).** 안전장치는 "유효행 0인데 기존 데이터 존재 시 422 거부"(`:1421-1424`) 하나뿐.

### 3.2 안전 절차 [HARD]

1. **전체 그리드 로드** — 페이징/필터가 걸린 부분 화면에서 저장하지 않는다.
2. **저장 전 행수 기록** — 해당 `comp_cd` 의 `component_prices` 행수를 읽어 원장에 기록.
3. **행 추가·코드 이관만** — 값 변경 금지, 행 삭제 금지.
4. **blast_radius 표기** — 이 구성요소를 공유하는 상품 수(최대 31).
5. **인간 승인** → 저장.
6. **저장 후 행수 재확인** — 저장 후 행수 ≥ 저장 전 행수(AC-PW-010). 감소 시 즉시 중단·보고.

### 3.3 값 명세 산출

권위 격자 ↔ 라이브 diff 는 `huni-price-table-integrity/_batch/scripts/grid_diff.py` 로 산출한다(결함 5종: `missing_cell` / `transpose` / `mismatch` / `prc_typ_typo` / `dim_missing`).
`build_load.py` 의 UPSERT SQL 은 **화면 입력 값 명세로만** 사용하고 실행하지 않는다. `transpose` / `dim_missing` 은 BLOCKED 로 남기고 화면 조작 대상에서 제외한다.

### 3.4 추가상품 템플릿 단가 등록 절차 — `kind:"tmpl_price"` [REQ-PW-024]

단가 등록이라 M2 계열에 두지만, **엔드포인트는 `price_grid_save` 가 아니라 `price_source_save`** 다(§2.1 표 4행). 따라서 §3.2 의 full-sync 위험은 적용되지 않는다 — 이 경로는 `update_or_create` 멱등이며 그리드 삭제 부작용이 없다.

**왜 1차 배선층인가**: `widget_api.py:1860 _addons_strict` verbatim `계산 불가(amount=None)면 422 로 막는다 — 0원 폴백은 조용한 언더차지다`. 단가행이 없으면 값이 틀리는 게 아니라 **견적 자체가 거부**된다.

**폼 계약**: `{kind:"tmpl_price", tmpl_cd, apply_ymd, unit_price}`.

**절차**:

1. 대상 `tmpl_cd` 의 현재 `t_prd_template_prices` 행수를 읽어 원장에 기록한다(0건 확인).
2. **권위 단가를 확보한다** — 상품마스터 + 인쇄상품 가격표 + 「계산공식집초안」 **셋 다** 연 근거를 기재한다(REQ-PW-025 [HARD]). 확보 실패 시 등록하지 않고 `needs_authority` 로 분리한다.
3. **명칭 불일치를 동반 확인한다**: `TMPL-000092` 는 권위 `아크릴스탠드 @1400` ↔ 라이브 `아크릴거치대` 로 이름이 다르다. 이름이 달라도 **단가는 권위값 verbatim** 으로 등록하고, 명칭 불일치는 원장에 별도 항목으로 남긴다(명칭 변경은 본 SPEC 범위 밖).
4. `apply_ymd` 는 **오늘 이전**으로 지정한다 — 미래 일자로 등록하면 현재가가 여전히 비어 422 가 유지된다(§2.2 적용일자 함정과 동일 기전).
5. 미리보기 → **인간 승인** → 저장.
6. **영향 상품으로 검증한다** — 템플릿 단독이 아니라 그 템플릿을 참조하는 게시 상품(예: `TMPL-000092` → 아크릴쉐이커코롯토)으로 견적을 재호출해 **422 가 해소되고 `result_sum.PRICE ≠ 0`** 인지 확인한다.
7. 등록 후 행수 재확인(등록 전 0 → 등록 후 1 이상) 후 원장 기입.

**현재 등록 가능 / 불가 분리**: `TMPL-000092`(아크릴스탠드 1400) = 권위 확보 → 등록 가능. `TMPL-000009`/`000032`/`000033`/`000034`(트레싱지봉투 4종) · `TMPL-000096`(천정고리) = **권위 단가 출처 미확인 → `needs_authority`**, 실무진 문항으로 올린다.

---

## 4. M3 절차 — 공식↔구성요소 인라인 [자동화 난도 최고]

### 4.1 왜 어려운가

`t_prc_formula_components` 를 쓰는 **전용 JSON 엔드포인트가 없다**(`price_views.py` 쓰기 3개 전수 확인). 유일 UI 경로는 표준 admin changeform 인라인:

```
raw/webadmin/webadmin/catalog/admin.py:1546-1548
# 복합PK(frm_cd+comp_cd) → 단독 admin skip 대상이므로 인라인 전용
_FormulaComponentsInlineBase = _make_inline(M.TPrcFormulaComponents, fk="frm_cd")
admin.py:1560 class TPrcFormulaComponentsInline(...)
```

### 4.2 절차

1. `/admin/catalog/tprcpriceformulas/<frm_cd>/change/?_popup=1` 진입.
2. **폼셋 prefix 실측** — M3 착수 조건(`plan.md §B-3`): `gstack` 실화면 정찰 1건으로 prefix · `management_form` 확인 후 나머지 전개.
3. CSRF 토큰 + `management_form`(TOTAL_FORMS / INITIAL_FORMS) 포함 POST.
4. 기존 인라인 행은 그대로 두고 **추가만**.
5. 권위 = 「계산공식집초안」 전개식과 1:1 대조 후 승인.
6. `wiring_scan.py` 로 배선 결함 재측정.

---

## 5. M4 절차 — 셋트

1. `/admin/set-products/` 에서 구성원 목록 확인.
2. 구성원 각각을 M1(가격소스) 또는 M2(단가행) 경로로 교정.
3. `simulate_set_core` 경로로 셋트 최종가 재계산.
4. 구성원 공식 부재의 정상/결함 판정은 **「계산공식집초안」 공식 유형**으로 가른다(라이브로 가르지 않는다).

---

## 6. M5 절차 — 검증 스윕

| 단계 | 도구 | 산출 |
|---|---|---|
| 1 | `verify_zero_quote.py` | ZERO_FINAL / NO_SOURCE / UNDERCHARGE / ENGINE_ERROR 전수 |
| 2 | `lens_b_runner.py` | 게시 위젯 실호출 가격 스윕(판정 mint 금지) |
| 3 | `audit_published_prices.py` | 게시 전수 가격계산 점검 — 분모는 실행 직전 라이브 재실측(`spec.md §1.2`), `--products/--limit/--workers` |
| 4 | 위젯빌더 「가격 진단」 `#wb-diag-btn` | 가격 소스·구성요소별 매칭/제외 사유·할인 단계·오류 전문 |
| 5 | 3분류 원장화 | (A) 진짜 결함 / (B) 정상 미매칭 / (C) 미선택 차원 |

**판정 권위**: `result_sum.PRICE` 단일 출처. per-line `result[].PRICE=0` 은 세지 않는다.
**근거 우선순위**: 실호출 결과 1차, 오프라인 defects/health 보조(오프라인은 실제 막힘을 과소 집계).

---

## 7. 승인 게이트 층 분리 [C7]

```
코드/직접 SQL 층   : 금지 (선행 SPEC OUT-2 유지)
화면 조작 층       : 허용 — 드라이런 → 인간 승인 → 저장 (건별)
위젯 재게시 층     : 본 SPEC 수행 안 함 [REQ-PW-016] — G1 34건과 함께 후속 위젯 정비 트랙 이월
```

세 층은 독립이며, 하위 층의 승인이 상위 층 승인을 대체하지 않는다.
