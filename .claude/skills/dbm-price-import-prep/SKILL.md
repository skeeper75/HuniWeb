---
name: dbm-price-import-prep
description: >
  후니프린팅 인쇄상품 가격표(다차원 매트릭스·복합셀)를 webadmin Phase11 가격엔진(evaluate_price)이 먹는 t_prc_*
  4테이블 그릇으로 분해·정리하고 webadmin 복붙용 작업 엑셀(.xlsx)+DB 매핑 절차 mermaid를 산출하는 방법론(round-16).
  복합셀을 단가형/합가형(prc_typ_cd)·10차원 매칭·공식 합산 구조로 평면화. 라이브 t_prc_*+Phase11 설계=권위(round-2 산출 stale).
  트리거: 가격표 정리, 가격표 엑셀 분해, webadmin 가격 그릇, 가격 import 엑셀, 가격표 평면화, 단가형 합가형 분류, 가격 mermaid, round-16, 복합셀 분리, 가격표 다시 정리.
  공식 fit-gap·평면화(단일 스냅샷)는 dbm-price-formula(round-2), 적재 조립·실행은 dbm-load-readiness/dbm-load-execution.
---

# 가격표 → Phase11 가격엔진 그릇 import 준비 (round-16)

[HARD] 모든 산출 문서(.md)는 **한국어**. 식별자·테이블/컬럼명·코드값·CSV 헤더·SQL·mermaid 노드 라벨의 기술 식별자는 **영어** 유지. 단 엑셀 그릇의 사람이 보는 헤더/비고는 실무진 쉬운 한국어 병기(round-15 §1.0-b 라벨 원칙).

## 왜 이 스킬인가 (round-2와의 차이)

round-2(`dbm-price-formula`)는 가격표를 **단일 스냅샷**으로 fit-gap·평면화했다. round-16은 다르다:

1. **그릇의 권위가 바뀌었다** — webadmin Phase11이 가격엔진(`evaluate_price`)을 확정하면서 `t_prc_*`가 진화했다. round-2 산출은 round-14 진단(`18_schema-change/impact-diagnosis.md`)대로 **MAJOR stale**: component_prices 자연키 8→10컬럼(`proc_cd`·`opt_cd` 신설), `prc_typ_cd`(단가형/합가형) 개념 부재, `use_dims`·`template_prices` 미반영. **최신 구조를 먼저 확정하지 않고 평면화하면 엔진이 못 먹는 그릇이 된다.**

2. **목표가 다르다** — round-2 산출=DB 적재용 CSV/md. round-16 산출= **webadmin 복붙용 작업 엑셀(.xlsx)** + **DB 매핑 절차 mermaid 시각화**. 실무진이 가격표를 보며 엑셀 그릇에 복사/붙여넣기 하면 DB 적재 직전 상태가 되도록.

3. **분해 기준이 엔진 매칭 규칙이다** — 한 셀의 복합 요소를 어떻게 쪼개나는 "보기 좋게"가 아니라 **Phase11 엔진이 어떻게 매칭하나**로 결정된다(아래 §2).

## 그릇 = Phase11 가격엔진 4테이블 (라이브 source of truth)

권위 = `raw/webadmin/.planning/phases/11-price-engine-simulator/11-CONTEXT.md`(엔진 설계 확정) + 라이브 `t_prc_*` information_schema 실측 + `_workspace/huni-dbmap/00_schema/price-engine-ddl.md`(단 8→10차원·prc_typ 반영해 읽을 것).

```
evaluate_price(target, selections, qty, grade_cd, mode):
  가격 우선순위: t_prd_template_prices → t_prd_product_prices → 공식(formulas) → 없음
  공식 경로 = price_formulas → formula_components → price_components → component_prices
```

| # | 테이블 | 무엇을 담나 | 핵심 컬럼 |
|---|--------|-----------|----------|
| 1 | `t_prc_price_formulas` | 상품 ↔ 공식 바인딩 | `prd_cd`·`frm_cd`·`frm_typ_cd`(.01 합산형/.02 단순형)·`apply_bgn_ymd`(PK 통일) |
| 2 | `t_prc_formula_components` | 공식 = 어떤 구성요소들의 합산 | `frm_cd`·`comp_cd`·`disp_seq`·`addtn_yn`(Phase11 무시) |
| 3 | `t_prc_price_components` | 구성요소 정의 | `comp_cd`·`comp_nm`·**`prc_typ_cd`**(PRICE_TYPE.01 단가형/.02 합가형)·**`use_dims`**(jsonb 차원배열) |
| 4 | `t_prc_component_prices` | 다차원 단가행 | **10 자연키**: `comp_cd`·`siz_cd`·`clr_cd`·`mat_cd`·**`proc_cd`**·`coat_side_cnt`·**`opt_cd`**·`bdl_qty`·`min_qty`·`apply_ymd` + `unit_price` |

보조: `t_prd_template_prices`(신설·SKU 직접단가·0행) · `t_prd_product_prices`(상품 직접단가) · `t_dsc_*`(할인, round-1).

## §1. 절차 (8단계)

### 1. 최신 그릇 확정 (stale 차단 — 선행 필수)
- `18_schema-change/impact-diagnosis.md`의 I-1~I-7로 round-2 산출의 stale 지점을 먼저 흡수: 8→10차원·자연키 10컬럼·`prc_typ_cd`·`use_dims`·`template_prices`·PK (prd_cd, apply_bgn_ymd).
- 라이브 `t_prc_*` information_schema 읽기전용 실측(`dbm-schema-extract` 패턴)으로 컬럼·코드값(PRICE_TYPE 3종) 확인. **추정 금지 — 컬럼 실재는 라이브 권위.**

### 2. 시트 구조 해부 (다차원·복합셀 식별)
- 대상 시트를 openpyxl로 읽어(병합셀 앵커·max_row/col) **논리 블록 분리**: 한 시트가 여러 블록을 수직 스택(예: 아크릴=3 매트릭스+할인+후가공). round-2 `01_excel/workbook-structure.md` 재사용.
- 각 블록 유형 분류: **매트릭스형**(size×size 단가) / **밴드 단가표**(수량구간×옵션) / **평면 목록**(옵션+단가) / **부유 셀**(라벨·노트, 데이터 아님).
- **복합셀 식별**: 한 셀/한 행에 여러 요소가 섞인 곳(예: 코팅명+코팅면수, 사이즈+재질, 색상+도수). 이게 분해 대상.

### 3. 다차원 셀 분해 규칙
- **매트릭스 → long-form**: `[가로][세로]` 2D 매트릭스를 `(siz_cd, unit_price)` 행으로 언피벗(round-2 면적매트릭스 패턴). 좌표 헤더 → siz_cd 매핑.
- **복합 요소 → 차원 컬럼 분리**: 한 셀의 복합값을 component_prices 10차원 중 해당 컬럼으로 쪼갬. 어느 차원인지는 **엔진 매칭 단위**로 결정(§2).
- **부유/노트 셀 → 보존(note)**: 침묵 삭제 금지(round-10 교훈). 데이터 아님 플래그.

### 4. 공식 매핑 (시트 → formulas + formula_components)
- 시트(상품군)의 가격 = 어떤 구성요소들의 합인가 → `price_formulas`(상품↔공식) + `formula_components`(공식=comp 목록·disp_seq).
- **공식유형 판별**: 구성요소 여러 개 합산=합산형(.01) / 소수(1~2)=단순형(.02, 합산형 특수케이스).

### 5. 구성요소 정의 + 단가/합가 판별 (price_components)
- 각 구성요소 → `price_components` 1행: `comp_cd`·`comp_nm`·`prc_typ_cd`·`use_dims`.
- **🔴 단가형/합가형 판별(핵심)**:
  - **단가형(.01)**: 단가표 값이 **장당 가격** → 엔진은 `단가 × 주문수량`. (대부분 구성요소)
  - **합가형(.02)**: 단가표 값이 **수량구간의 총액** → 엔진은 `구간총액 ÷ 구간 min_qty = 장당가` 환산 후 `× 주문수량`. (예: "100매 20,000원" 식 구간총액 표).
  - 판별 근거 = 가격표 헤더/단위 표기("장당"·"매당" vs "100매 기준 총액"·구간별 총액). 모호하면 컨펌(추정 금지).
- **use_dims** = 그 구성요소 단가표가 실제로 쓰는 차원 컬럼명 배열(예: 스티커 코팅 → `["siz_cd","coat_side_cnt"]`). 라이브 use_dims와 대조.

### 6. 차원 단가행 (component_prices, 10차원)
- 분해된 단가행을 component_prices long-form으로: 쓰는 차원만 값, **안 쓰는 차원 = NULL(와일드카드)**.
- **동시매칭 금지 검증**: 같은 선택값 조합에 단가행 2개 이상 매칭(공통 NULL행 + 전용행 공존 포함)되면 **데이터 오류** — 적재 전 차단(Phase11 규칙).
- `proc_cd`(공정 차원)·`opt_cd`(옵션 차원)는 신설 차원 — 해당 구성요소가 공정/옵션으로 매칭되면 채움(현재 라이브 0행).

### 7. webadmin import 엑셀 그릇 생성 (.xlsx)
- `scripts/build_import_workbook.py`(openpyxl)로 **테이블별 시트** 엑셀 생성: 각 시트 = 한 t_prc_* 테이블, **1행=컬럼 헤더(영문 컬럼명 + 한국어 라벨 병기)**, 이후 행=분해된 데이터. 복붙 시 DB 컬럼과 1:1.
- 시트 4종: `price_formulas`·`formula_components`·`price_components`·`component_prices`(+ 필요시 template_prices/product_prices).
- 헤더 행에 컬럼 도메인 주석(필수/NULL허용·코드값·예시). 실무진이 보고 채울 수 있게.
- 산출 위치 = `_workspace/huni-dbmap/20_price-import/<sheet>/<sheet>-import.xlsx`.

### 8. 매핑 절차 mermaid 시각화
- 가격표 시트 → 4테이블 그릇 → 엔진 계산까지의 흐름을 mermaid로(`<sheet>-mapping-flow.md`). §3 컨벤션.

## §2. 분해 기준 = 엔진 매칭 규칙 (기계적 분해 방지)

한 셀의 복합 요소를 어느 차원으로 쪼개나는 Phase11 엔진의 매칭 단위로 결정한다:

- **옵션은 `opt_cd`로만 매칭** — 옵션 하위 자재·공정을 풀어서 비교하지 않음. 손님이 옵션 X 선택 → 단가행 `opt_cd=X` 매칭으로 끝. → 가격표의 "옵션별 추가단가"는 opt_cd 차원.
- **공정 단가는 `proc_cd` 차원** — 코팅·커팅·박 등 공정이 단가에 기여하면 proc_cd로 매칭(신설 차원).
- **NULL=무관** — 그 차원을 안 쓰는 구성요소는 NULL(어떤 선택값이든 매칭). 과분할로 모든 차원에 값 채우지 말 것.
- **단가/합가는 component 레벨 속성** — 같은 구성요소의 모든 단가행은 같은 prc_typ_cd. 행마다 다르지 않음.
- **수량구간(min_qty)** — 주문수량 이하 최대 min_qty 구간. 최소구간 미달=계산불가(데이터 결함 아님).

## §3. mermaid 절차 컨벤션

매핑 절차는 두 종류 mermaid로:

1. **flowchart** — 가격표 시트 블록 → 분해 → t_prc_* 테이블 → 엔진. 예:
```
flowchart LR
  subgraph 가격표["스티커 시트 (다차원)"]
    M1[코팅 단가표<br/>size×면수]
    M2[커팅 단가표]
  end
  subgraph 그릇["t_prc_* 4테이블"]
    F[price_formulas<br/>합산형]
    FC[formula_components]
    PC[price_components<br/>prc_typ_cd]
    CP[component_prices<br/>10차원]
  end
  M1 -->|언피벗·use_dims=siz,coat_side| CP
  M2 --> CP
  F --> FC --> PC --> CP
```

2. **sequenceDiagram**(선택) — `evaluate_price` 계산 흐름(선택값→매칭→단가/합가 환산→합산→할인)으로 그릇이 엔진에서 어떻게 쓰이는지 검증 시각화.

[HARD] mermaid는 실제 분해 결과를 반영(샘플 날조 금지). 노드 라벨에 실제 comp_cd·use_dims 표기.

## §4. 검증 (dbm-validator 인계 — 생성자≠검증자)

생성(builder)과 검증(validator)은 별도. validator 게이트 P1~P6:
- **P1 그릇 정합**: 엑셀 시트 컬럼이 라이브 t_prc_* 컬럼과 1:1(누락·잉여 0·10차원 반영).
- **P2 stale 차단**: round-2 구조(8차원·단가형 암묵) 잔재 0 — prc_typ_cd·proc_cd·opt_cd·use_dims 반영.
- **P3 분해 무손실**: 가격표 원본 셀 ↔ 분해 행 round-trip(값 보존·부유셀 note 보존).
- **P4 단가/합가 정당**: prc_typ_cd 판별이 가격표 단위 표기 근거 있음(추정 0).
- **P5 동시매칭 0**: 같은 선택조합 중복 단가행 없음(NULL행+전용행 공존 검사).
- **P6 엔진 시뮬레이션**: 분해 그릇으로 대표 선택값+수량 1건을 손계산(`evaluate_price` 규칙) → 가격표 기지값과 일치.

## 산출물

`_workspace/huni-dbmap/20_price-import/<sheet>/`:
- `<sheet>-structure.md` — 시트 논리블록 해부 + 복합셀 식별
- `<sheet>-decomposition.md` — 분해 규칙 + 단가/합가 판별 + use_dims
- `<sheet>-import.xlsx` — webadmin 복붙용 그릇(테이블별 시트)
- `<sheet>-mapping-flow.md` — mermaid 매핑 절차
- `_gate/<sheet>-gate.md` — validator P1~P6

## 안전 (HARD)
- 라이브 DB는 읽기전용 SELECT만(information_schema·코드값 확인). NEVER 적재/COMMIT/DDL. 실 적재는 round-5/인간 승인.
- `.env.local` `RAILWAY_DB_*` 외 자격증명 비노출. `_workspace`(git 추적)에 비밀값 금지.
