---
id: SPEC-PRICEWIRE-001
doc: design
version: "0.1.1"
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
| 3 | `audit_published_prices.py` | 게시 194 전수 가격계산 점검(`--products/--limit/--workers`) |
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
