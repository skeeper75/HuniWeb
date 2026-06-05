# expected-vs-load 자기검증 (booklet 적재 게이트)

> **작성** 2026-06-05 · dbm-mapping-designer · 설명 한국어, 식별자/컬럼/코드 영어.
> **목적:** `load/*.csv` + `t_prd_products_qtyunit_update.csv`가 L1 엑셀 + ref 마스터 + IMPORT 매트릭스에서
> **누락0·날조0**으로 도출됐음을 재현 가능한 스크립트(`verify_expected.py`)로 입증한다. validator가 그대로 재실행하는 게이트.
> **DB 쓰기 없음** — CSV·스크립트만. 라이브 SELECT 불요(ref/IMPORT 추출본 기반, stale 주의는 §3).
> **메서드:** digital-print 파일럿 게이트(`09_load/digital-print/verify_expected.py`) 4맵(SHEET/NM2CD/IMPORT_SLOT/EMBOSS_SIG) 교체.

---

## 1. 게이트 원리 — 독립 재생성 대조

`verify_expected.py`는 **적재 생성기(`gen_load.py`)의 산출을 신뢰하지 않고**, L1·ref·IMPORT 원천에서
기대행을 *독립 경로*로 재산출한 뒤 load CSV와 3단 대조한다:

1. **count** — 기대 행수 = 적재 행수
2. **set** — 기대 (key) 집합 = 적재 (key) 집합 (MISSING=기대>적재 누락 / FABRICATED=적재>기대 날조)
3. **value/FK 실재 + PK 중복** — 적재된 모든 `prd_cd`·`proc_cd`·`mat_cd`·`usage_cd`가 마스터에 실재, 적재 내 중복 PK 0

독립성 보장: 검증 스크립트는 L1 `booklet-l1.csv`를 **직접 재판독**(생성기 출력 미참조)하고,
IMPORT는 `import-paper-matrix-long.csv`를 재집계한다.

**booklet 특화:** 자재 키는 `(prd_cd, mat_cd, usage_cd)` **3튜플**(내지.01/표지.02 슬롯 구분).
digital-print의 2튜플(prd_cd, mat_cd, 공통.07)과 달리 usage 슬롯을 검증축에 포함.

---

## 2. 게이트 결과 (재실행 명령: `python3 09_load/booklet/verify_expected.py`)

```
=== SELF-CHECK (booklet) ===
label                    exp   act  miss  extra  result
R1-material               83    83     0      0  PASS
R2-process                 4     4     0      0  PASS
R6-qtyunit                11    11     0      0  PASS
FK-existence               -     -     -      0  PASS
PK-dup                     -     -     -      0  PASS

GATE: PASS — 누락0·날조0   (exit 0)
```

| 검증 항목 | 기대 | 적재 | 누락 | 날조 | 판정 |
|-----------|:----:|:----:|:----:|:----:|:----:|
| **R1-material** (IMPORT ●종이→(prd,mat,usage)) | 83 | 83 | 0 | 0 | PASS |
| **R2-process** (형압 양각/음각→(prd,proc)) | 4 | 4 | 0 | 0 | PASS |
| **R6-qtyunit** (11 parent QTY_UNIT.03 권) | 11 | 11 | 0 | 0 | PASS |
| **FK-existence** (mat/proc/prd/usage 마스터 실재) | — | — | — | 0 | PASS |
| **PK-dup** (적재 내 중복 PK) | — | — | — | 0 | PASS |

- **R1**: IMPORT 6컬럼(중철내지13·중철표지13·무선내지7·무선표지6·트윈링내지16·트윈링표지28) ●종이 → `mat_nm` 정확매치
  100%(exact 83/83, fuzzy 0, unmatched 0). 내지=USAGE.01·표지=USAGE.02 슬롯 정확 부여. 종이 1종도 추정·날조 없음.
- **R2**: L1 무선책자(069)·PUR책자(070) `박/형압가공`에 `형압(양각)`/`형압(음각)` 신호 → 051·052 기대 각 2건 = 4행.
  기존 적재(037~044 박색상)와 중복 0, 051·052 신규분만 적재.
- **R6**: booklet 11 parent 전건 QTY_UNIT.03(권) 부여 대상 = 적재 11행.

> R1 deferred(PUR/하드커버/바인더 내지 6행)·R4 page 잡음 flag·R3 레더바인더 CONFIRM은 **보류/플래그** 성격이라
> count-set 게이트 대상에서 분리하고 §load-spec에서 명시 추적(검증은 FK 실재 + PK 중복 0으로 커버).

---

## 3. stale 주의 — 게이트가 신뢰하는 권위와 한계

- 본 게이트는 `00_schema/ref-*.csv`(추출본 **2026-06-04, stale 가능**)와 L1·IMPORT(엑셀 권위)를 입력으로 한다.
- **stale가 판정을 뒤집을 수 있는 지점**(§load-spec 설계결정으로 격상):
  1. **069·070 형압 미적재**(R2) — stale ref-product-processes가 069·070에 051·052 부재 표시. 라이브가 이미 적재면
     중복 PK → 적재 직전 라이브 재확인 후 결정.
  2. **097 page_rule + 백모조120 usage 중복**(R4) — stale ref=097 page 부재 / 라이브=3/3/3 보고. **충돌** → flag만(삭제 단정 금지).
  3. **068·069·071 내지/표지 자재 중복**(R1) — stale ref가 068=0·069=0·071=.07/.05만 표시. 이를 신뢰해 중복 PK 회피.
     라이브가 일부 .01/.02 적재 상태면 부분 중복 가능 → **적재 직전 라이브 재확인 필수**.
- 따라서 본 게이트의 PASS는 "**추출본 기준 누락0·날조0**"이며, **DB 적재 직전 동일 스크립트를 라이브 export로
  재실행**해 stale 격차를 닫아야 한다(검증 권위 반전 원칙).

---

## 4. 타시트 확장 (--sheet 파라미터화 정신)

`verify_expected.py` 상단 4맵만 시트별로 교체하면 동일 게이트 로직(count→set→FK→PK)이 재사용된다:
- `SHEET` 상수
- `NM2CD`(상품명→prd_cd)
- `IMPORT_SLOT`(IMPORT 컬럼→(prd_cd, usage_cd)) — **booklet은 usage 슬롯 포함**(digital-print의 IMPORT_MAP 확장형)
- `EMBOSS_SIG`(L1 박/형압 토큰→proc) — digital-print의 SIGCOLS(후가공 컬럼)에 대응

공정/형압 신호 규칙(`L1 토큰 포함 → 공정 존재`)·IMPORT ●매칭·FK 실재·PK 중복 검사는 시트 불변.
booklet은 digital-print 대비 **자재 키에 usage_cd 추가**(내지/표지 슬롯)가 유일한 구조 차이.
