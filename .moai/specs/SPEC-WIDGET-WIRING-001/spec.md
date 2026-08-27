---
id: SPEC-WIDGET-WIRING-001
title: "위젯↔가격공식↔가격구성요소 배선 전면 진단·개선 (배선 헬스 아티팩트)"
version: "0.2.0"
status: completed
created: 2026-08-21
updated: 2026-08-27
author: 지니
priority: P1
phase: "2차 확장 — 렌즈 이원화(v0.2.0)"
module: "_workspace/huni-widget-wiring"
lifecycle: spec-anchored
tags: "widget, wiring, formula, component, ref_dim_cd, constraints, publish-lens, artifact, readonly"
tier: M
---

# SPEC-WIDGET-WIRING-001 — 위젯 배선 전면 진단·개선

> 입력 산출물:
> ① `_workspace/huni-widget-wiring/CONSULT-DENOMINATOR-260821.md`(분모 266·4수 전략)
> ② `docs/huni/widget-price-audit-260822.html`(외부 감사 — 게시 위젯 194 실호출 가격점검)
> ③ `_workspace/huni-widget-wiring/CROSS-VERIFY-260822.md`(리드 교차검증 — 수렴 82%·신규 결함 6종)
> ④ `_workspace/huni-widget-wiring/out/REVIEW-260822.md`(t1 run 산출물 리뷰 — 오탐 57·미판정 103)
> [HARD] `raw/webadmin/**` 과 라이브 DB는 **읽기 전용**. 본 SPEC의 어떤 요구사항도 두 곳을 수정하지 않는다.
> [HARD] 모든 사실 주장에 `파일경로:라인`. 추정은 `[추정]` 배지.
> [HARD] 검증 의례 최소화 — 결정론 스크립트 재사용, LLM 셀 단위 분석 0, 판정 로직 mint 최소화.

## 0. 판본 이력

| 판본 | 변경 |
|---|---|
| v0.1.0 (260821) | 초판 — 상품 데이터 렌즈 단일. 배선 엣지 10종. 분모 266 |
| **v0.2.0 (260822)** | **렌즈 이원화**(+게시 위젯 렌즈 194) · 엣지 10→15 + INFO 1 · `NOT_EVALUATED` verdict 도입 · 가격 원리 선행 이해(§1.5) · 리뷰 지적 6건 반영(§8) · 감사 도구 흡수 판정(§1.6) |

---

## 1. 배경

**목표**: 위젯(고객 주문 요소를 전부 담는 그릇)의 구성요소 하이라키·그룹핑 구조와, 그 안의 각 배선
(옵션그룹→옵션→옵션항목→`ref_dim_cd` 차원해소→가격공식→가격구성요소→단가행→제약)의
**연결/단절 상태**를 한눈에 탐색하는 인터랙티브 아티팩트를 낸다.

### 1.1 컨설트 정정 (v0.1.0 유지) [HARD]

컨설트가 "미커버 = 신규 진단기 작성"이라 본 배선 엣지 4종은 **`raw/webadmin/tools/` 에 결정론
read-only 센서로 이미 존재**한다 — 판정 알고리즘 신규 mint 금지(search-before-mint).

| 엣지 | 센서 | 근거 |
|---|---|---|
| 옵션 계층 무결성 | `verify_optcode_integrity.py`[2] · `verify_option_ref_integrity.py`(`PARENT_DEAD`) | `:12-13` · `:29-31` |
| `ref_dim_cd` 해소 | `verify_option_ref_integrity.py`(`REF_DIM` 7차원) | `:23-28`, `:77-101` |
| 옵션→단가행 도달성 | `verify_price_coverage.py` · `verify_zero_quote.py` | `:19-27` · `:14-25` |
| 제약 dangling | `audit_constraints.py` · `verify_optcode_integrity.py`[3] | `:9-21` · `:14` |

### 1.2 v0.1.0 의 구조적 공백 — 렌즈가 하나뿐이었다 [v0.2.0 핵심]

v0.1.0 은 위젯 그릇의 정본을 `price_views._build_sim_meta()`(`raw/webadmin/webadmin/catalog/price_views.py:1877`)
로 잡았다. 이는 **상품 데이터가 만들어낼 수 있는 위젯**이지, **지금 고객에게 게시된 위젯**이 아니다.
게시 위젯은 별도 실체 테이블에 스냅샷으로 굳어 있다:

| 실체 | 테이블 | 근거 |
|---|---|---|
| 위젯(게시 상태) | `t_wgt_widgets`(`sts_typ_cd`·`use_yn`·`del_yn`) | `raw/webadmin/webadmin/catalog/models.py:830-850` |
| **게시 구성 스냅샷** | `t_wgt_widget_versions.cfg`(JSON·`act_yn='Y'`) | `models.py:879-891` |
| 위젯 항목(기본값·표시여부) | `t_wgt_widget_items`(`dflt_val`·`visible_yn`·`props`·`ctrl_typ_cd`) | `models.py:854-875` |

⇒ 상품에서 어떤 코드가 사라져도 **게시 스냅샷에는 그 코드가 기본값으로 남는다**(감사 N-2 유형:
`기본값이 상품에서 사라짐: 종이 (MAT_000107)` 등, `docs/huni/widget-price-audit-260822.html`).
v0.1.0 모델은 이 층 자체를 보지 않았다.

### 1.3 렌즈 이원화 [HARD · v0.2.0 신설]

| | **렌즈 A — 상품 데이터** (v0.1.0) | **렌즈 B — 게시 위젯** (v0.2.0 신설) |
|---|---|---|
| 분모 | 라이브 활성 상품 **266**(`t_prd_products` `use_yn=Y·del_yn=N`) | 게시 위젯 **194**(`t_wgt_widgets` 게시 상태) |
| 그릇 정본 | `_build_sim_meta(prd_cd)` | `t_wgt_widget_versions.cfg` + `t_wgt_widget_items` |
| 질문 | "배선이 끊겼는가" | "**고객이 지금 못 사는가**" |
| 평가 | 정적 대조 + 센서 | 위젯이 보내는 가격요청 **실호출** |

**분모 차이의 의미**(266 vs 194)는 결함이 아니라 **정보**다. 세 부분집합을 각각 다르게 다룬다:

| 집합 | 뜻 | 처리 |
|---|---|---|
| A∩B | 게시된 활성 상품 | 두 렌즈 판정 대조(수렴/불일치) — 아티팩트 핵심 뷰 |
| A−B | 등록됐으나 미게시 | **결함 아님**(런칭 대기). 렌즈 A 결함은 "게시 전 교정 대상"으로 강등 표기 |
| B−A | 게시됐는데 상품 비활성/분모 밖 | **치명** — 고객에게 보이는데 뒤가 없다(예: `PRD_000165` 아크릴포카코롯토, CROSS-VERIFY §1) |

교차검증 실측(`CROSS-VERIFY-260822.md` §1): 감사 막힘 97 중 우리 판정 BROKEN 52·WARN 28 =
**80/97 수렴(82%)**, `NOT_EVALUATED` 13(기권이 옳았음), **OK 오판 3**.

### 1.4 OK 오판 3건 — 렌즈 A 의 사각 (`CROSS-VERIFY` §2)

| 상품 | 감사 판정 원인 | 렌즈 A 가 놓친 이유 |
|---|---|---|
| PRD_000072 하드커버책자 | 셋트 계산 실패(표지·면지 가격소스 없음) | 셋트 구성원 40이 미평가(§8-3) |
| PRD_000077 레더하드커버책자 | 동일 | 동일 |
| PRD_000108 탁상형캘린더 | **판수 환산 불가** | 엣지 미정의 — "매칭 0"에 원인이 묻힘 |

### 1.5 가격 원리 선행 이해 [HARD · 운영자 요구]

진단 전에 **가격이 어떻게 성립하는지**를 고정한다. 이 절과 어긋나는 판정은 오탐이다.

**(가) 가격 소스는 2경로이며 직접가가 1순위다.**
```
pricing.py:568-581   1) 상품 직접단가 t_prd_product_prices → source=PRODUCT_PRICE
                     2) 없을 때만 상품 공식 t_prd_product_price_formulas
```
`price_views.py:1894-1903` 의 `source_hint` 도 같은 순서다.
⇒ **공식 바인딩 없음 = 결함이 아니다**(굿즈 등 직접가 상품의 정상 상태). v0.1.0 어댑터가 이를
`critical`로 승격해 **오탐 57건**을 냈다(`REVIEW-260822.md` §1).

**(나) 판형기준 구성요소는 장수가 아니라 판수로 조회한다.**
`판수 = ⌈주문수량 ÷ 판걸이수⌉`, `판걸이수 = fn_calc_pansu(plt_siz_cd, siz_cd)`
(`pricing.py:21-23`·`259-273`·`339-349`). 산출 불가 시 `ERR_NO_PLATE = "no_plate_pansu"` 로
**그 구성요소만 조용히 합산 제외**된다(`pricing.py:67`). 0원이 아니라 **저청구**로 나타난다.

**(다) 라이브 배선 규모 실측**(리드, 260822): 공식 110 · 구성요소 146 · 배선 232 · 상품바인딩 178.

**(라) 구성요소 공유도** — 활성상품 도달 119개 중 **공유 31 / 전용 88**.
최다 공유 `COMP_PRINT_DIGITAL_S1` 31상품 · `COMP_PAPER` 31 · `COMP_GOODS_FIXED_SIZ` 30.
⇒ 한 구성요소 재적재의 **파급 상품 수**를 교정 우선순위·위험도에 반드시 표기한다.

**(마) 가격 경로 배타 분리** — 직접가만 57 / 공식만 159 / 둘 다 0 / **둘 다 없음 50**.
"둘 다 없음 50"은 항상 0원이거나 미완성 상품이다 — **규명 대상**(렌즈 B 로 게시 여부부터 가른다).

**(바) 차원 종류는 맞고 값이 어긋난다** — `use_dims` vs 상품 등록차원 422쌍 중 미충전 단 2건.
⇒ 결함의 본체는 차원 누락이 아니라 **코드 층 재키(re-key) 드리프트**(신 코드 상품 vs 구 코드 그리드).

### 1.6 감사 도구 흡수 판정 [HARD · search-before-mint 이행 결과]

리드 지시 4번(감사 도구 흡수 우선)에 따라 저장소 전수 탐색을 수행했다.

| 탐색 | 결과 |
|---|---|
| `grep -rl "게시 위젯 가격계산 점검"` 전 저장소 | **적중 1건 = 산출 HTML 자기 자신뿐** |
| `raw/webadmin/tools/`(전 파일 목록) | 생성기 없음. 유사 계열은 `verify_zero_quote.py`(엔진 직접 실호출)·`test_widget_parity.py`·`e2e_price_viewer.py`·`bulk_publish_widgets.py` |
| `raw/widget_monitor/`·`raw/widget_ui/` | 위젯 캡처·SDK 점검기는 있으나 가격점검 생성기 없음 |

⇒ **감사 생성기 소스는 이 저장소에 없다**(외부 세션/외부 작업물). 따라서 흡수 대상은 "도구 파일"이
아니라 **그 도구가 탄 경로**이며, 그 경로의 구성요소는 전부 저장소에 있다:

| 감사 도구가 한 일 | 저장소 내 재사용 자산 |
|---|---|
| 게시 위젯 분모 확정 | `t_wgt_widgets`·`t_wgt_widget_versions`(`models.py:830-891`) |
| 위젯 가격요청 조립 | `widget_api._prep_selections`·`_expand_opt_sels`·`_prep_proc_sels`·`_prep_set_body`(`widget_api.py:576`·`1455`·`741`·`1321`) |
| 서버와 같은 판정 | `pricing.evaluate_price` + `widget_api._price_gap_errors`(`:607`) |
| 기본화면+1항목 변경 스윕 | `verify_zero_quote.py` 축 스윕(`:90-120`) |

**[HARD] 신규 작성 판단**: 감사 도구 자체는 흡수 불가(부재)이나, **알고리즘 mint 는 여전히 금지**한다.
렌즈 B 진단기는 위 4자산을 **호출·조립**하는 얇은 러너로만 만든다(§4 R8). 원본 부재 시 재작성이 아니라
**원본 경로 재사용**이 search-before-mint 의 이행이다.
[추정] 감사 도구가 우리와 동일 경로를 탔다는 것은 산출물의 판정 유형·문구로부터의 추정이다 — 수렴율
82%(§1.3)가 그 방증이나, 원본 코드 대조로 확증하지 못했다.

### 1.7 분모

- 렌즈 A: `t_prd_products` 활성 **266**(260821 실측). 스냅샷 갱신 필수.
- 렌즈 B: 게시 위젯 **194**(`docs/huni/widget-price-audit-260822.html` 헤더 — "게시 상태 위젯 194개,
  8/19 일괄 게시분 포함, 게시 스냅샷 기준").
- [HARD] `t_wgt_*` 는 **현재 live-snapshot CSV 집합에 없다**(`live-snapshot/latest` 실측 36테이블).
  렌즈 B 를 세우려면 스냅샷 대상 테이블을 확장해야 한다(§4 R1).

---

## 2. 범위

### 2.1 범위 안

| # | 항목 |
|---|---|
| IN-1 | 라이브 스냅샷 갱신 + **`t_wgt_*` 3테이블 추가** |
| IN-2 | 기존 `hdx` 가격 레이어 as-is 재실행 |
| IN-3 | 렌즈 A 어댑터 Diagnoser(기존) + **심각도·문구 정정**(§8) |
| IN-4 | **렌즈 B 진단기(게시 위젯 실호출 러너)** — 신규 |
| IN-5 | sim-meta 하베스터 + **게시 cfg 하베스터** |
| IN-6 | 상품/위젯별 wiring-health 조립(`NOT_EVALUATED` 포함) |
| IN-7 | 인터랙티브 아티팩트 + **두 감사 대조 뷰**(수렴/불일치/미평가) |
| IN-8 | 교정 라우팅 명세(파급 상품 수·값 삭제 금지 문구 포함) |

### 2.2 범위 밖 [HARD]

| # | 범위 밖 | 근거 |
|---|---|---|
| OUT-1 | `raw/webadmin/**` 수정 | 읽기 전용. 어댑터는 호출·이식만 |
| OUT-2 | 라이브 DB write·DDL·COMMIT·**위젯 재게시** | 인간 승인 게이트 |
| OUT-3 | 위젯 렌더러/프런트 코드 수정 | 위젯 트랙 소유 |
| OUT-4 | 권위 엑셀 값 대조 | §26 트랙 소유 |
| OUT-5 | LLM 셀 단위 분석·수치 전사 | 결정론만 |
| OUT-6 | 새 판정 알고리즘 mint | §1.1·§1.6 |

---

## 3. 구조 정본

### 3.1 계층 (렌즈 B 층 추가)

```
[렌즈 B] 게시 위젯 t_wgt_widgets (194)
├─ G  게시 스냅샷 t_wgt_widget_versions.cfg (act_yn=Y)
└─ I  위젯 항목 t_wgt_widget_items (dflt_val · visible_yn · ctrl_typ_cd · props)
        │  ※ 위젯 기본값이 상품 등록값과 어긋나면 = 첫 화면부터 막힘
        ▼
[렌즈 A] 상품 t_prd_products (266)
├─ W1 옵션그룹 → W2 옵션 → W3 옵션항목 → W4 ref_dim_cd 차원 해소
├─ D  상품 등록 차원(sizes·plate_sizes·materials·processes·print_options·bundle_qtys·page_rules)
├─ C  제약 t_prd_product_constraints (JSONLogic)
├─ S  셋트 t_prd_product_sets (구성원 → 각 구성원의 가격경로)
└─ 가격축  E1 상품→공식(또는 직접가) · E2 공식→구성요소 · E3 use_dims↔등록차원
           · E4 조합→단가행 도달 · **E5 판수 환산**(판형기준 구성요소 전용)
```

### 3.2 배선 엣지 정본표 — 15종 + INFO 1 (v0.1.0 10종 → 확장)

| 엣지 | 정의 | 단절 코드 | 커버 센서 | 판정 |
|---|---|---|---|---|
| W1 | 상품→옵션그룹 | `EMPTY_GROUP` | `verify_optcode_integrity`[2] | 기존 |
| W2 | 옵션그룹→옵션 | `ORPHAN_OPT`·`PARENT_DEAD`(WARN) | `verify_optcode_integrity`·`verify_option_ref_integrity` | 기존 |
| W3 | 옵션→옵션항목 | `ORPHAN_ITEM` | `verify_optcode_integrity`[2] | 기존 |
| W4 | 옵션항목→차원 해소 | `ANCHOR_DELETED`·`ANCHOR_MISSING`·`MASTER_DELETED`·`MASTER_MISSING` | `verify_option_ref_integrity` | 기존 |
| W5 | `dtl_opt`→단가행 param | `OPT_PARAM_MISSING` | `hdx OptionCpqDx` | 기존 |
| **W6** ★ | **옵션 유형 어긋남**(N-4) — 옵션이 선언 유형과 다른 축으로 소비됨(`OPT_000260`·`OPT_000287`) | `OPT_TYPE_MISMATCH` | 렌즈 B 실호출 오류문구 + `verify_optcode_integrity`[4] | **신규** |
| C1 | 제약 → 코드 실재 | `RULE_DEAD_REF`·`RULE_ALWAYS_FALSE` | `audit_constraints` | 기존 |
| E1 | 상품→가격소스 | `NO_SOURCE`(직접가·공식 **둘 다 없음**) | `verify_zero_quote`·스냅샷 대조 | **정의 정정**(§8-1) |
| E2 | 공식→구성요소 | `ORPHAN`·`DEAD_WIRE`·`DELETED_WIRE` | `hdx WiringDx` | 기존 |
| E3 | `use_dims`↔등록차원 | `MISSING_DIM`·`UNDECLARED` | `DimConformanceDx`·`verify_price_coverage` | 기존 |
| E4 | 조합→단가행 도달 | `UNCOVERED`·`PRICE_MISSING`·`ZERO_FINAL`·`UNDERCHARGE` | `verify_price_coverage`·`verify_zero_quote` | 기존 |
| **E5** ★ | **판수 환산 실패**(N-1) — 판형기준 구성요소가 `fn_calc_pansu` 미산출로 합산 제외 | `NO_PLATE_PANSU` | `pricing.ERR_NO_PLATE`(`pricing.py:67`) 실호출 관측 | **신규·독립** |
| **S1** ★ | **셋트 계산 실패**(N-3) — 구성원 가격소스 부재·셋트공식 미매칭 | `SET_MEMBER_NO_SOURCE`·`SET_FORMULA_NO_MATCH` | 렌즈 B 셋트 경로 실호출 | **신규** |
| **Q1** ★ | **경계 위반**(N-5) — 최소주문수량 미달·사이즈 최대구간 초과 | `BELOW_MIN_QTY`·`OVER_MAX_RANGE` | `pricing.ERR_BELOW_MIN`·`hdx QtyRuleDx` | **신규** |
| **G1** ★ | **게시 기본값 소실**(N-2) — `t_wgt_widget_items.dflt_val` 이 상품 활성값에 없음 | `WIDGET_DEFAULT_STALE` | 게시 cfg ↔ 상품 등록값 대조(신규 결정론 조인) | **신규** |
| **INFO-1** | 기본값 미지정 시작(N-6) — 8상품 | `NO_DEFAULT_START` | 렌즈 B | **결함 아님·고지** |

> **E5 를 E4 에 흡수하지 않는다**[HARD] — v0.1.0 에서 판수 환산 실패가 "매칭 0"으로 뭉개지며
> 원인이 소실됐고(`CROSS-VERIFY` §3 N-1, 20상품 공통 최대 덩어리), 저청구는 0원과 달리 **눈에 안 띈다**.

### 3.3 verdict 확장 — `NOT_EVALUATED` 도입 [HARD]

v0.1.0 은 "결함 없음 = OK"였다. 그런데 두 가격 센서는 완제품만 스캔한다
(`verify_price_coverage.py:180` · `verify_zero_quote.py:275-277`) → **셋트구성원 40·기성 15는
가격축이 한 번도 돌지 않고 OK**로 찍혔다(`REVIEW-260822.md` §4-3, OK 59 중 51건).

| verdict | 정의 |
|---|---|
| `BROKEN` | 치명 단절 ≥1 (`ANCHOR_DELETED`·`ZERO_FINAL`·`NO_SOURCE`·`ORPHAN`·`SET_*`·`NO_PLATE_PANSU`) |
| `WARN` | 비치명 단절만 |
| `OK` | 단절 0 **이며 해당 상품에 관련 엣지가 전부 실제로 평가됨** |
| **`NOT_EVALUATED`** ★ | 엣지 중 하나라도 미평가(센서 미적용 유형·센서 실패·조합 절단) |

- 센서가 실패하면 그 엣지를 쓰는 **전 상품**을 `NOT_EVALUATED` 로 강등한다(리뷰 §4-7).
- 조합 절단(`TRUNCATED`)은 결함이 아니라 **커버리지 고지** — verdict 를 `OK` 로 만들지 못한다(리뷰 §3.2).

---

## 4. 요구사항 (EARS)

### R1 — 스냅샷 갱신 + `t_wgt_*` 확장 (선행·차단)
- **WHEN** 라운드 시작 시, **THE SYSTEM SHALL** 스냅샷을 재추출하고 활성 상품 수를 출력한다.
- **THE SYSTEM SHALL** 스냅샷 대상에 `t_wgt_widgets` · `t_wgt_widget_versions` · `t_wgt_widget_items` 를 추가한다.
- **IF** 활성 상품 수 ≠ 라이브 실측 또는 게시 위젯 수 ≠ 감사 분모(194±게시 변동), **THEN** 차이를 명시 기록하고 진행한다(중단 아님 — 게시 상태는 변한다).

### R2 — 가격 레이어 as-is 재실행 (v0.1.0 유지)
- **THE SYSTEM SHALL** `hdx/diagnose_remediate.py --scope price` 를 무수정 재실행한다.

### R3 — 렌즈 A 어댑터 (v0.1.0 유지 + 정정)
- **THE SYSTEM SHALL** 판정 로직을 §1.1 5센서 호출/이식으로만 구성한다.
- **THE SYSTEM SHALL NOT** 원본 센서에 없는 심각도를 새로 부여한다 — **심각도 정책도 판정의 일부다**(§8-1).
- **THE SYSTEM SHALL** 센서가 커버하지 못하는 상품 유형을 `NOT_EVALUATED` 로 기록한다.
  [HARD] `verify_price_coverage.py:180` 은 `PRD_TYPE.01` 하드코딩이고 `--all-types` 플래그가 없다.
  원본 수정 금지(OUT-1)이므로 **확대 실행이 아니라 미평가 표기**가 정답이다(run 260822 가정 기록 승계).
  셋트구성원·기성 유형의 가격축은 **렌즈 B 실호출**(R8)로 메운다.

### R8 — 렌즈 B 진단기 (게시 위젯 실호출) ★신규
- **THE SYSTEM SHALL** 게시 위젯 전수에 대해 **기본 화면 + 항목 1개씩 변경** 조합의 가격요청을 조립해
  서버와 동일 판정 경로(`pricing.evaluate_price` + `widget_api._price_gap_errors`)로 평가한다.
- **THE SYSTEM SHALL** 가격요청 조립을 `widget_api` 기존 함수(`_prep_selections`·`_expand_opt_sels`·
  `_prep_proc_sels`·`_prep_set_body`) **호출**로 수행한다(재구현 금지).
- **THE SYSTEM SHALL** 엔진 오류코드를 엣지로 승격한다: `ERR_NO_PLATE`→E5, `ERR_BELOW_MIN`→Q1,
  셋트 실패→S1, 매칭 0→E4, 소스 없음→E1.
- **THE SYSTEM SHALL** 제약규칙으로 선택 불가한 조합은 실패로 계상하지 않는다(감사 방법 승계).
- **IF** 조합 수가 상한을 넘어 절단되면, **THEN** 절단 건수를 산출에 기록하고 그 상품을 `OK` 로 판정하지 않는다.
- **THE SYSTEM SHALL** 다중 항목 동시 변경 조합은 검사 범위 밖임을 산출에 명시한다(감사와 동일 한계).

### R9 — 게시 기본값 대조(G1) ★신규
- **THE SYSTEM SHALL** `t_wgt_widget_items.dflt_val` 및 게시 `cfg` 의 코드값이 상품 활성 등록값에
  실재하는지 결정론 조인으로 검사하고, 부재 시 `WIDGET_DEFAULT_STALE` 를 낸다.
- **THE SYSTEM SHALL** 기본값 미지정(`dflt_val` 없음)은 `INFO-1` 로 분류한다(결함 아님).

### R10 — NOT_EVALUATED 해소 경로 ★신규
- **THE SYSTEM SHALL** 셋트 경로(구성원 40)와 직접가 경로(직접가만 57)를 렌즈 B 실호출로 평가한다.
- **THE SYSTEM SHALL** 남은 미평가분을 사유별(센서 미지원 유형·절단·센서 실패)로 집계해 보고한다.

### R11 — 두 렌즈 대조 ★신규
- **THE SYSTEM SHALL** 상품 단위로 렌즈 A·B 판정을 병기하고 대조 상태를 산출한다:
  `CONVERGE`(양쪽 결함) · `A_ONLY` · `B_ONLY` · `BOTH_OK` · `UNCOMPARABLE`(분모 밖).
- **THE SYSTEM SHALL** `A_ONLY` 상품에 대해 **게시 여부**를 게시 스냅샷으로 판정해 "미게시라 고객 영향 없음"
  가설을 검증하고, 검증 전에는 `[추정]` 으로 표기한다(CROSS-VERIFY §4).

### R5 — wiring-health 조립 (v0.1.0 확장)
- **THE SYSTEM SHALL** 상품별 JSON 에 렌즈 A·B 결과, `NOT_EVALUATED` 사유, 대조 상태를 담는다(§5).
- **THE SYSTEM SHALL** 각 결함에 **파급 상품 수**(공유 구성요소 기준·§1.5-라)를 부착한다.

### R6 — 아티팩트 (v0.1.0 확장)
- 단일 자족 HTML. 기존 기능(목록·계층 드릴다운·단절 강조·필터·evidence) 유지.
- **THE SYSTEM SHALL** **대조 뷰**를 추가한다 — 수렴/불일치(A만·B만)/미평가 3분면 + 각 셀 상품 목록.
- **THE SYSTEM SHALL** 신규 엣지(W6·E5·S1·Q1·G1)와 `NOT_EVALUATED` 를 범례·필터에 포함한다.

### R7 — 규율 [HARD] (v0.1.0 유지)
- 결정론·토큰 0. 라이브·`raw/` 읽기 전용. 교정은 명세·worklist 까지, 실행은 인간 게이트.

### R12 — 교정 문구 안전 ★신규 [HARD]
- **THE SYSTEM SHALL NOT** `suggested_fix` 에 "과등록 조사" 등 **값 삭제를 시사하는 문구**를 쓰지 않는다.
- **THE SYSTEM SHALL** 재키 드리프트의 교정 방향을 "권위 대조 후 판단 — 그리드 재적재 또는 코드 통합,
  **등록값 삭제 금지**"로 고정한다(2026-07 0원 견적 사고 재현 방지, `verify_zero_quote.py:5-9`).
- **THE SYSTEM SHALL** `ANCHOR_DELETED` 계열을 `auto_data` 로 분류하지 않는다 — `del_yn` 복구는
  구코드 부활·중복 노출을 낳는 **판단 필요 재배선**이다(리뷰 §4-1). 분류는 `review`.

---

## 5. 산출 스키마 (v0.2.0)

```json
{
  "prd_cd": "PRD_000108", "prd_nm": "탁상형캘린더", "prd_typ_cd": "PRD_TYPE.01",
  "snapshot": "snap_YYYYMMDD_HHMM",
  "publish": {"wgt_cd": "WGT_...", "published": true, "ver_no": 3, "cfg_hash": "..."},
  "lens_a": {"verdict": "OK|WARN|BROKEN|NOT_EVALUATED",
             "not_evaluated_reason": ["센서 미지원 유형(PRD_TYPE.02)"],
             "widget": {"opt_groups": []}, "binding": {}, "formula": {}, "price": {}},
  "lens_b": {"verdict": "OK|WARN|BROKEN|NOT_EVALUATED",
             "combos_tested": 32, "combos_truncated": 1078,
             "defects": [{"edge": "E5", "code": "NO_PLATE_PANSU",
                          "comp_cd": "COMP_PRINT_DIGITAL_S1",
                          "detail": "판수 환산 불가(판형/완제품사이즈)"}]},
  "cross": {"state": "CONVERGE|A_ONLY|B_ONLY|BOTH_OK|UNCOMPARABLE", "note": "[추정] 미게시"},
  "verdict": "BROKEN",
  "broken_edges": ["E5"],
  "money_impact": {"undercharge": 1, "overcharge": 0},
  "blast_radius": [{"comp_cd": "COMP_PRINT_DIGITAL_S1", "products": 31}],
  "remediation": [{"edge": "E5", "class": "review",
                   "note": "판형/완제품사이즈 등록 확인 — 값 삭제 금지"}]
}
```

---

## 6. 가정 · 리스크

| # | 항목 | 대응 |
|---|---|---|
| A-1 | 센서는 Django 컨텍스트(`../.venv`+`DATABASE_URL`) 필요 | 부재 시 명시 FAIL + 해당 엣지 전 상품 `NOT_EVALUATED` |
| A-2 | 스냅샷(CSV) vs 센서(라이브) 원천 상이 | 한 라운드 내 실행·시각 병기 |
| A-3 | **감사 도구 원본 부재**(§1.6) — 렌즈 B 는 우리가 조립 | 알고리즘 mint 금지, `widget_api`·`pricing` 호출로만 구성 |
| A-4 | 게시 상태는 시간에 따라 변한다(194는 260822 04:34 시점) | 분모 차이를 결함이 아닌 정보로 처리(§1.3) |
| R-1 | `PARENT_DEAD` 대량(500 규모) | 원본 정책 승계 — WARN·분모 제외 금지 |
| R-2 | 렌즈 B 전수 실호출 비용 | 게시분 194 우선·조합 절단 시 명시 기록 |
| R-3 | 공유 구성요소 재적재의 파급(최대 31상품) | `blast_radius` 필수 표기 후 인간 판단 |

---

## 7. 재사용 선례

- 어댑터 패턴: `PriceGridDx`(§26 배치 호출·재구현 0).
- 라이브→스냅샷 포팅: `DimConformanceDx`·`QtyRuleDx`.
- 공통 스키마: `hdx/foundation/models.py` `Defect`/`Fix`(교정 6클래스·값 날조 금지).
- 축 스윕 방법론: `verify_zero_quote.py:90-120`(렌즈 B 스윕 설계의 원본).

---

## 8. v0.1.0 산출물 리뷰 반영 (`REVIEW-260822.md`)

v0.1.0 run 세션이 **위험 3건(8-1·8-2·8-3/8-4)은 이미 교정 완료**했다(progress.md "교정 3건 반영",
결함 461→404 · E1 59→2 · auto_data 29→0 · `NOT_EVALUATED` 51 도입). v0.2.0 은 그 교정을 **SPEC 본문에
승격 고정**하고(되돌림 방지), 남은 항목을 요구사항으로 편입한다.

| # | 지적 | 상태 | v0.2.0 반영 |
|---|---|---|---|
| 8-1 | E1 `NO_FORMULA` 57건 오탐(직접가 상품) | **교정 완료**(run) | §1.5-가 · E1 정의를 "직접가·공식 **둘 다 없음**"으로 본문 고정 · R3 심각도 신설 금지 |
| 8-2 | `suggested_fix` "과등록 조사"가 사고 재현 경로 | **교정 완료**(run) | **R12** 로 문구 규범 승격 |
| 8-3 | OK 59 중 51이 미검사 | **교정 완료**(run) | **§3.3 `NOT_EVALUATED`** 정식 verdict 승격 · 잔여 미평가는 R10(렌즈 B)으로 해소 |
| 8-4 | auto_data 29건이 되돌리기 어려운 쓰기 | **교정 완료**(run) | **R12** — `ANCHOR_*` `auto_data` 금지 규범화 |
| 8-5 | AC5 가 구조상 실패 불가(`edges_seen ∪ EDGES`) | **미해결**(백로그 t4) | acceptance AC5 판정 방법 교체(`evaluated_by` 증거) |
| 8-6 | AC3 증거 부실 | **부분 해소**(sync: nested repo 확인) | acceptance AC3 를 nested repo status + 해시 대조로 교체 |
| 8-7 | 책자 5상품 90건 미판정(`mand_proc_yn` 공백) · 트윈링 `proc_cd` 불일치 | **미해결**(백로그 t2·t3) | 렌즈 B 가 공정 선택 포함해 재평가(R8) · plan §9 U-2·U-3 |
| 8-8 | `TRUNCATED` 를 Defect 로 계상 · `use_dims` 파싱 결함 | **미해결**(백로그 t4·t5) | §3.3(절단은 고지·OK 금지) · plan M2' |
