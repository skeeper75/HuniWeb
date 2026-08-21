---
id: SPEC-WIDGET-WIRING-001
title: "위젯↔가격공식↔가격구성요소 배선 전면 진단·개선 (배선 헬스 아티팩트)"
version: "0.1.0"
status: completed
created: 2026-08-21
updated: 2026-08-22
author: 지니
priority: P1
phase: "1차 SPEC (칸반 카드 t1 · Class C)"
module: "_workspace/huni-widget-wiring"
lifecycle: spec-anchored
tags: "widget, wiring, formula, component, ref_dim_cd, constraints, artifact, readonly"
tier: M
---

# SPEC-WIDGET-WIRING-001 — 위젯 배선 전면 진단·개선

> 입력 산출물: `_workspace/huni-widget-wiring/CONSULT-DENOMINATOR-260821.md`(분모 266·4수 전략·미커버 엣지 4종).
> [HARD] `raw/webadmin/**` 과 라이브 DB는 **읽기 전용**. 본 SPEC의 어떤 요구사항도 두 곳을 수정하지 않는다.
> [HARD] 모든 사실 주장에 `파일경로:라인`. 추정은 `[추정]` 배지.
> [HARD] 검증 의례 최소화(카드 t1 지시) — 결정론 스크립트 재사용, LLM 셀 단위 분석 0, 새 판정 로직 mint 최소화.

---

## 1. 배경 — 확정된 사실과 컨설트 정정 1건

**목표**: 위젯(고객 주문 요소를 전부 담는 그릇)의 구성요소 하이라키·그룹핑 구조와, 그 안의 각 배선
(옵션그룹→옵션→옵션항목→`ref_dim_cd` 차원해소→가격공식→가격구성요소→단가행→제약)의
**연결/단절 상태**를 라이브 활성 266상품 전수로 한눈에 탐색하는 인터랙티브 아티팩트를 낸다.

### 1.1 컨설트 정정 [HARD · 이 SPEC의 핵심 절약]

컨설트가 "미커버 = 신규 `widget_wiring_dx` 1개 작성"이라 본 배선 엣지 4종은,
실제로는 **`raw/webadmin/tools/` 에 결정론 read-only 센서로 이미 전부 존재**한다. 실측:

| 컨설트 미커버 엣지 | 이미 존재하는 센서 | 근거 |
|---|---|---|
| ① 옵션 계층 무결성(고아·빈그룹·부모사망) | `verify_optcode_integrity.py` [2] orphan + `verify_option_ref_integrity.py` `PARENT_DEAD` | `raw/webadmin/tools/verify_optcode_integrity.py:12-13`, `raw/webadmin/tools/verify_option_ref_integrity.py:29-31` |
| ② `ref_dim_cd` polymorphic 해소 전수 | `verify_option_ref_integrity.py` `ANCHOR_DELETED`/`ANCHOR_MISSING`/`MASTER_DELETED`/`MASTER_MISSING` + `REF_DIM` 매핑표(7차원) | `raw/webadmin/tools/verify_option_ref_integrity.py:23-28`, `:77-101` |
| ③ 옵션선택→단가행 도달성(선택 가능한데 0원) | `verify_price_coverage.py`(`MISSING_DIM`/`UNCOVERED`) + `verify_zero_quote.py`(`ZERO_FINAL`/`NO_SOURCE`/`UNDERCHARGE`/`ENGINE_ERROR`) | `raw/webadmin/tools/verify_price_coverage.py:19-27`, `raw/webadmin/tools/verify_zero_quote.py:14-25` |
| ④ constraints(JSONLogic)↔옵션 코드 dangling | `audit_constraints.py`(① 항상거짓 ② 죽은참조·조건/결과 양방향) + `verify_optcode_integrity.py` [3] | `raw/webadmin/tools/audit_constraints.py:9-21`, `raw/webadmin/tools/verify_optcode_integrity.py:14` |

⇒ **판정 알고리즘을 새로 mint 하지 않는다**(search-before-mint [HARD]). 신규 작성분은
`hdx.Diagnoser` 계약으로의 **얇은 어댑터**(호출·출력 매핑)와 **조립기·아티팩트**뿐이다.

### 1.2 위젯 그릇의 정본 — 새로 정의하지 않는다

위젯이 실제로 렌더하는 하이라키는 이미 코드에 하나의 함수로 존재한다:
`price_views._build_sim_meta(prd_cd, customer=True)` — 가격소스 힌트·현재 공식(`frm`)·
구성요소(`comp_cd`·`use_dims`)·필요차원 union(`prod_dims`)·옵션그룹(`opt_groups`)·제약(`constraints`)·
템플릿·페이지룰을 한 번에 낸다(`raw/webadmin/webadmin/catalog/price_views.py:1877-1917`).
위젯 임베드 config(`widget_api._runtime_meta`)와 관리자 시뮬레이터가 **같은 빌더를 공유**하며
(`raw/webadmin/webadmin/catalog/widget_api.py:401-412`), 셋트 구성원은 `PV._set_members_meta`로
같은 모양을 재귀 사용한다(`widget_api.py:411-413`).

⇒ **아티팩트의 하이라키 정본 = sim-meta 산출 그대로**. 별도 하이라키 모델을 설계하면 즉시 드리프트한다.

### 1.3 분모

라이브 실측 `t_prd_products WHERE del_yn='N' AND use_yn='Y'` = **266개**(260821, 컨설트 §④).
스냅샷 `_foundation/live-snapshot/latest`(=`snap_20260705_0041`)·`batch-scan/products.json` = 260개 → **stale**.
분모 갱신이 모든 스캔의 필수 선행이다.

---

## 2. 범위

### 2.1 범위 안

| # | 항목 |
|---|---|
| IN-1 | 라이브 스냅샷 갱신(전 t_* CSV 재추출) — 분모 266 정렬 |
| IN-2 | 기존 `hdx` 통합 배치 as-is 재실행(가격 레이어 9 Diagnoser 전수) |
| IN-3 | 위젯 레이어 어댑터 Diagnoser 신규(§1.1 4센서 → `Defect` 매핑) |
| IN-4 | sim-meta 하베스터(266상품 `_build_sim_meta` read-only 덤프) — 아티팩트 하이라키 입력 |
| IN-5 | 상품별 `wiring-health` JSON 조립(계층 + 엣지별 단절 + verdict) |
| IN-6 | 인터랙티브 아티팩트(266상품 탐색·계층 드릴다운·엣지 단절 하이라이트·필터) |
| IN-7 | 개선(remediation) **명세까지** — 엣지별 교정 라우팅(auto_data/needs_authority/…) 산출 |

### 2.2 범위 밖 [HARD]

| # | 범위 밖 | 근거 |
|---|---|---|
| OUT-1 | `raw/webadmin/**` 수정(센서·`price_views`·`widget_api` 포함) | 읽기 전용 원칙. 어댑터는 호출·이식만 |
| OUT-2 | 라이브 DB write·DDL·COMMIT | 루트 CLAUDE.md 공통 프로토콜 ② (인간 승인 후에만) |
| OUT-3 | 위젯 렌더러/프런트 코드 수정 | 위젯 트랙(§6 huni-widget) 소유 |
| OUT-4 | 가격 값 자체의 권위 대조(엑셀 재대조) | §26 가격테이블 무결성 트랙 소유 |
| OUT-5 | LLM 셀 단위 분석·재전사 | [HARD] 결정론만. LLM 숫자 전사 금지 |
| OUT-6 | 새 판정 알고리즘 mint | §1.1 — 기존 센서 재사용 |

---

## 3. 구조 정본 — 위젯 하이라키(W계층)와 배선 엣지

### 3.1 계층

```
P   상품 t_prd_products (분모 266)
├─ W1 옵션그룹  t_prd_product_option_groups   (sel_typ_cd·mand_yn·min/max_sel_cnt·disp_seq)
│   └─ W2 옵션      t_prd_product_options      (opt_grp_cd FK·dflt_yn·disp_seq)
│       └─ W3 옵션항목 t_prd_product_option_items (ref_dim_cd + ref_key1/2 + qty + dtl_opt)
│            └─ W4 차원 해소 → 상품별 등록행(t_prd_product_sizes/materials/processes/…) → 마스터(t_siz_*/t_mat_*/…)
├─ D  상품 등록 차원(prod_dims): sizes·plate_sizes·materials·processes·print_options·bundle_qtys·page_rules
├─ C  제약 t_prd_product_constraints (JSONLogic `logic` → 옵션/차원 코드 참조)
├─ T  템플릿·추가상품·셋트: t_prd_templates/_selections·t_prd_product_addons·t_prd_product_sets
└─ 가격축
    ├─ E1 상품→공식   t_prd_product_price_formulas (apply_bgn_ymd 최신)
    ├─ E2 공식→구성요소 t_prc_formula_components → t_prc_price_components(use_dims)
    ├─ E3 구성요소 use_dims → 상품 등록 차원(D) 정합
    └─ E4 (선택값 조합) → 단가행 t_prc_component_prices (dim_vals·min_qty·apply_ymd)
```

### 3.2 배선 엣지 정본표 (아티팩트의 색칠 단위)

| 엣지 | 정의 | 단절 결함코드 | 커버 센서(재사용) | 상태 |
|---|---|---|---|---|
| W1 | 상품→옵션그룹 실재·비어있지 않음 | `EMPTY_GROUP` | `verify_optcode_integrity`[2] | 기존 |
| W2 | 옵션그룹→옵션(고아·부모사망) | `ORPHAN_OPT`·`PARENT_DEAD` | `verify_optcode_integrity`[2]·`verify_option_ref_integrity` | 기존 |
| W3 | 옵션→옵션항목(고아 항목) | `ORPHAN_ITEM` | `verify_optcode_integrity`[2] | 기존 |
| W4 | 옵션항목 `ref_dim_cd`+`ref_key1` → 상품 등록행·마스터 실재 | `ANCHOR_DELETED`(치명)·`ANCHOR_MISSING`·`MASTER_DELETED`·`MASTER_MISSING` | `verify_option_ref_integrity`(`REF_DIM` 7차원 매핑) | 기존 |
| W5 | 옵션항목 `dtl_opt` 파라미터 → 단가행 `dim_vals` 요구값 공급 | `OPT_PARAM_MISSING`(저청구) | `hdx OptionCpqDx` | 기존 |
| C1 | 제약 logic → 상품 연결 코드 실재(조건/결과 양방향) | `RULE_DEAD_REF`·`RULE_ALWAYS_FALSE` | `audit_constraints` | 기존 |
| E1 | 상품→공식 바인딩 | `NO_FORMULA` | `hdx WiringDx`·`linkage_dx` | 기존 |
| E2 | 공식→구성요소 | `ORPHAN`·`DEAD_WIRE`·`DELETED_WIRE` | `hdx WiringDx`(`batch/wiring_scan.py`) | 기존 |
| E3 | 구성요소 `use_dims` ↔ 상품 등록 차원 | `MISSING_DIM`·`UNDECLARED` | `hdx DimConformanceDx`·`verify_price_coverage` | 기존 |
| E4 | 선택 가능 값 → 단가행 도달(0원/저청구) | `UNCOVERED`·`PRICE_MISSING`·`ZERO_FINAL`·`UNDERCHARGE`·`NO_SOURCE` | `verify_price_coverage`·`verify_zero_quote`·`hdx CalcabilityDx` | 기존 |

> W4 의 `ref_dim_cd` 7차원 매핑(`OPT_REF_DIM.01`~`.07`)과 검사 불가 차원(`.06` 도수·`.05` 마스터 없음)은
> `raw/webadmin/tools/verify_option_ref_integrity.py:77-101` 을 **정본으로 인용**한다(재정의 금지).

---

## 4. 요구사항 (EARS)

### R1 — 스냅샷 갱신 (선행 · 차단)
- **WHEN** 진단 라운드를 시작할 때, **THE SYSTEM SHALL** `live-snapshot` 재추출을 먼저 수행하고
  `t_prd_products` 활성 행수를 콘솔에 출력한다.
- **IF** 활성 행수 ≠ 라이브 실측치, **THEN** 후속 단계를 진행하지 않고 중단한다.

### R2 — 기존 가격 레이어 전수 재실행
- **THE SYSTEM SHALL** `hdx/diagnose_remediate.py --scope price` 를 **무수정 as-is** 재실행하여
  9 Diagnoser 결함보드를 갱신한다(신규 코드 0).

### R3 — 위젯 레이어 어댑터 Diagnoser (신규 · 얇게)
- **THE SYSTEM SHALL** `hdx/diagnose/widget_wiring_dx.py` 를 `Diagnoser` 계약
  (`hdx/diagnose/base.py:15-33`)으로 추가하되, 판정 로직은 §1.1 4센서를 **호출/이식**만 한다.
- `verify_option_ref_integrity` · `verify_price_coverage` · `verify_zero_quote` 는 `--json` 을 이미
  지원하므로 **서브프로세스 호출 + JSONL→`Defect` 매핑**으로 어댑트한다(§7 PriceGridDx 어댑터 선례).
- `audit_constraints` · `verify_optcode_integrity` 는 `--json` 이 없으므로 **검출 판정부를
  `foundation.db`(읽기전용) 위로 verbatim 이식**한다. `raw/` 파일은 수정하지 않는다.
- **THE SYSTEM SHALL** 각 `Defect.dimension` 을 §3.2 엣지 ID(`W1`~`W5`·`C1`)로 태깅한다.
- **IF** 어댑터 산출 결함 카운트가 원본 센서 콘솔 카운트와 다르면, **THEN** 드리프트로 보고 FAIL 한다.

### R4 — sim-meta 하베스터 (아티팩트 하이라키 입력)
- **THE SYSTEM SHALL** 266상품 각각에 대해 `PV._build_sim_meta(prd_cd, customer=True)` +
  `PV._set_members_meta` 산출을 read-only 로 덤프해 `sim-meta/<prd_cd>.json` 을 만든다.
- **THE SYSTEM SHALL** 위젯 노출 화이트리스트(`widget_api._grp_opt`·`_runtime_meta`)와 **동일 필드 집합**을
  "고객 가시" 로 표기하고, 내부 가격모델 필드(`components`·`frm`·`maps`)는 "내부" 로 표기해 아티팩트가
  고객 가시성과 내부 배선을 구분해 보이게 한다.
- **IF** 어떤 상품에서 예외가 발생하면, **THEN** 그 상품을 `verdict:"BROKEN"`·`edge:"SIM_META_ERROR"` 로
  기록하고 계속 진행한다(전수 중단 금지).

### R5 — 상품별 wiring-health 조립
- **THE SYSTEM SHALL** 컨설트 §산출 스키마를 확장한 상품별 JSON 을 조립한다(§5).
- **THE SYSTEM SHALL** verdict 를 결정론 규칙으로 산출한다:
  `BROKEN` = 치명 엣지 단절 1건 이상(`ANCHOR_DELETED`·`ZERO_FINAL`·`NO_SOURCE`·`NO_FORMULA`·`ORPHAN`),
  `WARN` = 비치명 단절만, `OK` = 단절 0.
- **THE SYSTEM SHALL** 각 결함에 돈영향(`overcharge`/`undercharge`/`none`)을 `Defect.money_impact` 그대로 승계한다.

### R6 — 인터랙티브 아티팩트
- **THE SYSTEM SHALL** 단일 자족(self-contained) HTML 한 장으로 266상품을 탐색하게 한다.
- 필수 기능: ① 상품 목록(verdict·단절 엣지 수·돈영향 배지로 정렬/필터) ② 상품 클릭 시
  §3.1 계층 트리 드릴다운(W1→W2→W3→W4, 가격축 E1→E2→E3→E4) ③ **단절 엣지 시각 강조**
  (끊긴 선·결함코드·근거값) ④ 엣지/결함코드/상품군 필터 ⑤ 결함 근거(evidence) 원문 표시.
- **THE SYSTEM SHALL** 데이터를 HTML 에 인라인 임베드한다(외부 fetch 금지 — CSP·오프라인 열람).
- **THE SYSTEM SHALL** 상단에 스냅샷 시각·분모 수·전역 GO/NO-GO 를 표기한다.

### R7 — 규율 [HARD]
- **THE SYSTEM SHALL** 전 파이프라인을 결정론 배치로 유지한다(LLM 호출 0·토큰 0).
- **THE SYSTEM SHALL NOT** 라이브 DB 에 write 하거나 `raw/webadmin/**` 를 수정한다.
- 교정(개선)은 **명세·worklist 까지**. 실 COMMIT·webadmin 실화면 반영은 인간 게이트.

---

## 5. 산출 스키마 (상품별 · 컨설트 스키마 확장)

```json
{
  "prd_cd": "PRD_000220", "prd_nm": "...", "prd_typ_cd": "...",
  "snapshot": "snap_YYYYMMDD_HHMM",
  "widget": {
    "source_hint": "FORMULA|PRODUCT_PRICE|NONE",
    "prod_dims": ["siz_cd", "mat_cd", "..."],
    "opt_groups": [{"opt_grp_cd": "...", "opt_grp_nm": "...", "sel_typ_cd": "...", "mand_yn": "Y",
                    "options": [{"opt_cd": "...", "opt_nm": "...", "dflt": true,
                                 "items": [{"item_seq": 1, "ref_dim_cd": "OPT_REF_DIM.01",
                                            "ref_key1": "SIZ_000575", "dtl_opt": {},
                                            "resolved": true,
                                            "defects": [{"edge": "W4", "code": "ANCHOR_DELETED"}]}]}]}],
    "constraints": [{"rule_cd": "...", "defects": [{"edge": "C1", "code": "RULE_DEAD_REF", "ref": "SIZ_000174"}]}],
    "set_members": [{"sub_prd_cd": "...", "...": "구성원 스코프 동일 구조"}]
  },
  "binding": {"frm_cd": "FRM_...", "apply_bgn_ymd": "...", "defects": [{"edge": "E1", "code": "NO_FORMULA"}]},
  "formula": {"components": [{"comp_cd": "COMP_...", "use_dims": ["siz_cd"], "price_rows": 42,
                              "defects": [{"edge": "E2", "code": "ORPHAN"}]}],
              "defects": []},
  "price": {"reachable_ratio": 0.93,
            "defects": [{"edge": "E4", "code": "UNCOVERED", "dim": "mat_cd", "value": "MAT_000074"}]},
  "verdict": "OK|WARN|BROKEN",
  "broken_edges": ["W4", "E4"],
  "money_impact": {"undercharge": 2, "overcharge": 0},
  "remediation": [{"edge": "W4", "class": "auto_data|needs_authority|needs_design|blocked_human|review", "note": "..."}]
}
```

---

## 6. 가정 · 리스크

| # | 항목 | 대응 |
|---|---|---|
| A-1 | `raw/webadmin` 센서는 Django 앱 컨텍스트(`../.venv` + `DATABASE_URL`)를 요구한다 | 어댑터가 서브프로세스로 실행. venv 부재 시 명시 FAIL(묵음 스킵 금지) |
| A-2 | 스냅샷(CSV)과 센서(라이브 psql)는 **원천이 다르다** — 시점 드리프트 가능 | 한 라운드 내 스냅샷 갱신 직후 실행. 산출 JSON 에 스냅샷·실행시각 병기 |
| R-1 | `PARENT_DEAD` 는 라이브에서 500건 규모(정상 동작 잔재) | 원본 정책 승계 — WARN(비게이팅)·분모에서 제외 금지(`verify_option_ref_integrity.py:63-66`) |
| R-2 | `verify_zero_quote` 는 엔진 실행형이라 266상품 전수 시 가장 느리다 | 마지막 단계 배치·결과 캐시. 지연 시 치명 엣지 우선 산출 |
| R-3 | 아티팩트 데이터가 커져 단일 HTML 이 비대해질 수 있다 | 상품별 payload 최소화(결함·계층 요약), 원문 evidence 는 접힘 |

---

## 7. 재사용 선례

- 어댑터 패턴: `PriceGridDx` = §26 배치(`run_all.py`+`grid_diff.py`) **호출 어댑터·재구현 0**(`hdx/README.md` P5-②c).
- 라이브→스냅샷 포팅 선례: `DimConformanceDx`·`QtyRuleDx`(원본 무변경·포팅만).
- 공통 스키마: `hdx/foundation/models.py` `Defect`/`Fix`(교정 라우팅 6클래스·값 날조 금지).
