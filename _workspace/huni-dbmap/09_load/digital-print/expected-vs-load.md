# expected-vs-load 자기검증 (digital-print 적재 게이트)

> **작성** 2026-06-05 · dbm-mapping-designer · 설명 한국어, 식별자/컬럼/코드 영어.
> **목적:** `load/*.csv`가 L1 엑셀 + ref 마스터 + IMPORT 매트릭스에서 **누락0·날조0**으로 도출됐음을
> 재현 가능한 스크립트(`verify_expected.py`)로 입증한다. validator가 그대로 재실행하는 게이트.
> **DB 쓰기 없음** — CSV·스크립트만. 라이브 SELECT 불요(ref/IMPORT 추출본 기반, stale 주의는 §3).

---

## 1. 게이트 원리 — 독립 재생성 대조

`verify_expected.py`는 **적재 생성기(`gen_load.py`)의 산출을 신뢰하지 않고**, L1·ref·IMPORT 원천에서
기대행을 *독립 경로*로 재산출한 뒤 `load/*.csv`와 3단 대조한다:

1. **count** — 기대 행수 = 적재 행수
2. **set** — 기대 (key) 집합 = 적재 (key) 집합 (MISSING=기대>적재 누락 / FABRICATED=적재>기대 날조)
3. **value/FK 실재** — 적재된 모든 `prd_cd`·`proc_cd`·`mat_cd`가 마스터(`ref-*.csv`)에 실재

독립성 보장: 검증 스크립트는 L1 `digital-print-l1.csv`를 **직접 재판독**(생성기 출력 미참조)하고,
IMPORT는 `import-paper-matrix-long.csv`를 재집계한다.

---

## 2. 게이트 결과 (재실행 명령: `python3 09_load/digital-print/verify_expected.py`)

```
=== SELF-CHECK (digital-print) ===
label                    exp   act  miss  extra  result
R1-proc-active            26    26     0      0  PASS
R3-material              180   180     0      0  PASS
R6-qtyunit                36    36     0      0  PASS
FK-existence               -     -     -      0  PASS

GATE: PASS — 누락0·날조0   (exit 0)
```

| 검증 항목 | 기대 | 적재 | 누락 | 날조 | 판정 |
|-----------|:----:|:----:|:----:|:----:|:----:|
| **R1-proc-active** (줄수/개수 공정, active만) | 26 | 26 | 0 | 0 | PASS |
| **R3-material** (IMPORT ●종이→mat_cd) | 180 | 180 | 0 | 0 | PASS |
| **R6-qtyunit** (36상품 QTY_UNIT.02) | 36 | 36 | 0 | 0 | PASS |
| **FK-existence** (proc/mat/prd 마스터 실재) | — | — | — | 0 | PASS |

- **R1**: L1 `후가공_오시/미싱/가변(텍스트)/가변(이미지)` 셀이 `없음` 아닌 신호(1줄/2개…)를 가진 상품 → 29/30/31/32 기대.
  active 26행(`use_yn=Y` 10상품) = 적재 26행 정확 일치. 016(conditional)·028/038(deferred)은 active 집합에서 제외돼 정합.
- **R3**: IMPORT ●종이 → `mat_nm` 정확매치 100%(exact 180/180, fuzzy 0, unmatched 0). 종이 1종도 추정·날조 없음.
- **R6**: digital-print 36상품 전건 QTY_UNIT.02(매) 부여 대상 = 적재 36행.

> R2(형압)·R4(addon)·cascade-constraint·conditional은 **부분 적재/플래그/보류** 성격이라 count-set 게이트
> 대상에서 분리하고 §load-spec에서 명시 추적(검증은 FK 실재 + 중복 PK 0으로 커버).

---

## 3. stale 주의 — 게이트가 신뢰하는 권위와 한계

- 본 게이트는 `00_schema/ref-*.csv`(추출본 **2026-06-04, stale 가능**)와 L1·IMPORT(엑셀 권위)를 입력으로 한다.
- **stale가 판정을 뒤집을 수 있는 지점**(§load-spec 설계결정으로 격상):
  1. **016 process** — stale ref=27/28만, remediation 라이브=29~32 적재 보고. → 016 R1을 **conditional 보류**.
  2. **addon 기적재** — stale ref가 016/018에 001/002/004 적재 표시. 이를 신뢰해 중복 PK 회피.
     라이브가 다르면(미적재면) 누락 발생 가능 → **적재 직전 라이브 재확인 필수**.
- 따라서 본 게이트의 PASS는 "**추출본 기준 누락0·날조0**"이며, **DB 적재 직전 동일 스크립트를 라이브 export로
  재실행**해 stale 격차를 닫아야 한다(검증 권위 반전 원칙).

---

## 4. 타시트 확장 (--sheet 파라미터화 정신)

`verify_expected.py` 상단 `SHEET` 상수 + `NM2CD`(상품명→prd_cd) + `IMPORT_MAP`(IMPORT 컬럼→상품)
+ `SIGCOLS`(L1 신호컬럼→proc) 4개 매핑만 시트별로 교체하면 동일 게이트 로직(count→set→FK)이 재사용된다.
공정 신호 규칙(`값≠'없음' → 공정 존재`)·IMPORT ●매칭·FK 실재 검사는 시트 불변.
booklet/calendar(IMPORT 보유)·sticker(별색 신호) 확장 시 본 스크립트를 베이스로 둘 것.
