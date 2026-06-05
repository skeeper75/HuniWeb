# expected-vs-load 자기검증 (product-accessory 적재 게이트 · 대조군)

> **작성** 2026-06-05 · dbm-mapping-designer · 설명 한국어, 식별자/컬럼/코드 영어.
> **목적:** `load/*.csv`가 L1 엑셀 + ref 마스터에서 **누락0·날조0**으로 도출됐음을 재현 가능한
> 스크립트(`verify_expected.py`)로 입증한다. validator가 그대로 재실행하는 게이트.
> **DB 쓰기 없음** — CSV·스크립트만.
> **대조군 특화(HARD):** product-accessory는 정합 양호(GO수준)라 **적재가 적다(qty_unit 15행만)**.
> 따라서 게이트는 "정상=적재없음" 항목을 **false MISSING으로 양산하지 않도록** 별도 INVARIANT로 검증한다.

---

## 1. 게이트 원리 — 독립 재생성 + 대조군 불변식

`verify_expected.py`는 생성기(`gen_load.py`) 산출을 신뢰하지 않고, ref 마스터·L1 원천에서 기대행을
*독립 경로*로 재산출한 뒤 `load/*.csv`와 대조한다. **대조군이므로 두 종류의 게이트**를 둔다:

1. **적재 대조(count→set→FK)** — 실제 적재되는 단 하나의 테이블(qty_unit UPDATE set, 15행).
2. **정상=적재없음 불변식(INVARIANT)** — size+material가 15상품을 완전 커버(둘다0=0)·process/addon/discount/plate
   적재 CSV 부재. 이를 통해 "적재가 적은 것이 정상"임을 *증명*한다(없는 결함을 만들지 않았음을 입증).

---

## 2. 게이트 결과 (재실행 명령: `python3 09_load/product-accessory/verify_expected.py`)

```
=== SELF-CHECK (product-accessory) ===
label                                    exp   act  miss  extra  result
R3-qtyunit(EA)                            15    15     0      0  PASS
FK/typ-existence                           -     -     -      0  PASS
INV size+material 커버15                    15    15     0      0  PASS
INV process/addon/disc/plate 미적재=정상        -     0     -      0  PASS

GATE: PASS — 누락0·날조0 (대조군: 적재 적음=정상)   (exit 0)
```

| 검증 항목 | 기대 | 적재 | 누락 | 날조 | 판정 |
|-----------|:----:|:----:|:----:|:----:|:----:|
| **R3-qtyunit(EA)** (15상품 QTY_UNIT.01 부여) | 15 | 15 | 0 | 0 | PASS |
| **FK/typ-existence** (전 prd_cd 마스터 실재 + PRD_TYPE.03) | — | — | — | 0 | PASS |
| **INV size+material 커버15** (둘다0 상품=진짜 MISSING) | 15 | 15 | 0 | 0 | PASS |
| **INV process/addon/disc/plate 미적재=정상** | — | 0 | — | 0 | PASS |

- **R3**: PA 15상품(PRD_000001~015) 라이브 qty_unit 전건 NULL → 부자재 상품군 기본단위 EA(QTY_UNIT.01)
  일괄 부여 대상 = 적재 15행 정확 일치. (digital-print R6과 동일 UPDATE-class, 단위만 매→EA로 상품군 교체.)
- **INV size+material**: ref-product-sizes(7상품 38행)+ref-product-materials(8상품 29행) 재집계 → 15상품 완전 커버,
  **둘 다 0인 진짜 누락 상품 = 0**. 이것이 G-PA-1(분기 정상)·G-PA-4(완전누락 0)의 적재측 증명 = **변경 0이 정상**.
- **INV 미적재=정상**: process/addon/discount/plate는 도메인상 0이 정상(G-PA-4). load/에 해당 CSV 부재 = PASS.
  (대조군에서 이 테이블에 행을 만들면 곧 false MISSING — 게이트가 이를 막는다.)

> R2(bundle_qty G-PA-3 Low)·R1(size 입도 G-PA-2 Low)은 **DEFERRED/no-op**이라 count-set 게이트 대상에서
> 분리한다(정책 미확정 CONFIRM). DEFERRED 후보는 `_deferred/`에 추적, load CSV에는 미포함(발명 금지).

---

## 3. stale 주의 — 게이트가 신뢰하는 권위와 한계

- 본 게이트는 `00_schema/ref-*.csv`(추출본 **2026-06-04, stale 가능**)와 L1(엑셀 권위)을 입력으로 한다.
- **stale가 판정을 뒤집을 수 있는 지점:**
  1. **bundle_qty 권위반전** — stale ref-product-bundle-qtys.csv는 PA에 **0행**이나, remediation 라이브는
     OPP접착/비접착(001/002) **bdl_qty=50 적재**(reg_dt 2026-06-05, stale 추출 *이후*). DEFERRED가 이를 skip으로 처리.
  2. **size/material 커버리지** — INV는 추출본 기준 size 38행·material 29행을 신뢰. 라이브가 다르면(미적재면)
     INV가 누락을 놓칠 수 있음 → **적재 직전 라이브 export로 동일 스크립트 재실행** 필요.
- 본 게이트 PASS는 "**추출본 기준 누락0·날조0**"이며, **DB 적재 직전 동일 스크립트를 라이브 export로
  재실행**해 stale 격차를 닫는다(검증 권위=라이브 HARD).

---

## 4. 타시트 확장 (--sheet 파라미터화 정신)

`verify_expected.py` 상단 `SHEET` 상수 + `PA_CDS`(상품 prd_cd 집합) + `ENVELOPE_CASE`/`ACCESSORY`
(상품군 기본단위 분기, gen_load) 교체로 동일 게이트 로직(count→set→FK + INVARIANT)이 재사용된다.
**대조군 메서드의 핵심 = INVARIANT 게이트**(정상=적재없음을 *증명*해 false MISSING을 차단). goods-pouch처럼
결함 많은 시트는 적재 대조 위주, 본 시트처럼 정합 양호한 시트는 INVARIANT 위주로 가중치만 옮긴다.
