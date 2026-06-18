---
name: hped-code-schema-audit
description: 후니프린팅 가격엔진 프로그램 코드(pricing.py evaluate_price·price_views.py 뷰어/시뮬레이터·가격 admin 템플릿)가 DB 엔티티 각 속성(t_prc_price_formulas·price_components·formula_components·component_prices·t_dsc_* 할인의 컬럼·타입·제약·코드값·FK·트리거)에 맞게 제대로 구현됐는지를 속성 단위로 대조 진단하는 방법론 스킬. 설계 산출물(docs/prcx01-pricing-model.md·pricing-erd.md·sql DDL Phase7~10)이 코드·라이브 스키마에 충실히 반영됐는지 3-way(설계 의도↔코드 구현↔라이브 적용) 추적 절차, 컬럼별 코드 사용처(file:line) 대조, use_dims 선언↔component_prices 충전 차원↔evaluate_price NON_QTY_DIMS/TIER_DIMS 3원 정합 검사, dead(선언됐으나 미사용)·phantom(코드가 쓰나 미선언) 속성 적발, 트리거 가정 충돌 진단을 제공한다. '코드 DB 정합', '코드 스키마 대조', '속성 단위 구현 진단', '엔티티 속성 정합', '설계 산출물 추적', 'prcx01 반영 점검', 'use_dims 정합', 'dead phantom 속성', '코드 구현 진단 다시' 작업 시 반드시 이 스킬을 사용. 장치 역할 원리 정의는 hped-mechanism-research, 권위 엑셀 대비 정합 검증은 huni-price-quote 트랙이 담당하므로 그 작업에는 트리거하지 않는다.
---

# hped-code-schema-audit — 코드↔DB 엔티티 속성 정합 진단 방법론

가격엔진 코드가 DB 속성에 맞게 구현됐는지 속성 단위로 진단한다. **"맞다/틀렸다"의 최종 판정이 아니라 "정합/불일치 사실"의 진단**까지.

## 왜 이 방법론인가

가격엔진은 코드(동작)·DB 스키마(저장)·설계 산출물(의도) 3겹이다. 셋이 어긋나면 가격이 조용히 틀린다. 속성 단위 3-way 정합을 진단해야 "무엇을 믿고 적재·검증할지"의 토대가 선다.

## 3-way 추적 [HARD]

각 속성을 세 출처로 대조한다:

| 출처 | 무엇 | 도구 |
|------|------|------|
| **설계 의도** | docs/prcx01-pricing-model.md·pricing-erd.md·sql DDL | Read·Grep |
| **코드 구현** | pricing.py·price_views.py·models.py·템플릿 | Grep(컬럼명)·Read(file:line) |
| **라이브 적용** | information_schema·실데이터 | 읽기전용 psql(dbm-schema-extract) |

**핵심 분리**: "DDL에 선언됨 ≠ 코드가 씀 ≠ 라이브에 적용됨". 셋이 갈리는 지점이 발견. (메모리 [[dbmap-schema-change-round14]])

## 속성 단위 매트릭스 (code-schema-matrix.md)

가격 엔티티별로 컬럼 행을 만들고:

| 컬럼 | 타입(DDL) | 코드 사용처(file:line) | 코드 가정 | 라이브 적용 | 정합 |
|------|-----------|----------------------|-----------|-------------|:--:|

- 코드 사용처: Grep으로 컬럼명을 코드 전체에서 찾아 read/write 지점 표기.
- 코드 가정: 코드가 이 컬럼을 어떤 타입·코드값·NULL 의미로 다루는가.
- 정합: ✅일치 / ⚠️부분 / ❌불일치 / ⬛dead / 👻phantom.

## 적발 패턴

- **dead** — DDL/설계에 선언됐으나 코드가 안 읽고 안 씀 (예: frm_typ_cd가 25_drop_frm_typ로 제거된 흔적과 코드 잔재).
- **phantom** — 코드가 참조하는데 DDL/라이브에 없는 컬럼/코드값.
- **차원매칭 불일치** — use_dims 선언 ↔ component_prices 실제 충전 차원 ↔ evaluate_price NON_QTY_DIMS/TIER_DIMS 상수가 어긋남.
- **트리거 충돌** — fn_chk_opt_item_ref 등 트리거 가정이 코드 가정과 다름.

## 설계 산출물 추적 (design-artifact-trace.md)

prcx01-pricing-model.md 등 설계 문서의 각 결정이 코드·DB에 {반영됨/부분/미반영/stale}로 추적. stale(설계는 옛 모델, 코드/DB는 진화)을 분리.

## 안전
- 라이브 읽기전용 SELECT/information_schema만·DB 쓰기 0. 각 진단에 file:line·DDL 라인·재현 SQL 출처. 추정 금지(실측 근거). 검증·교정 금지(진단까지만).
