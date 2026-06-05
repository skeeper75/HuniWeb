# expected-vs-load 자기검증 (sticker 적재 게이트)

> **작성** 2026-06-05 · dbm-mapping-designer · 설명 한국어, 식별자/컬럼/코드 영어.
> **목적:** `load/*.csv`가 L1 엑셀 + ref 마스터에서 **누락0·날조0·비활성분리·마스터부재차단**으로 도출됐음을
> 재현 가능한 스크립트(`verify_expected.py`)로 입증한다. validator가 그대로 재실행하는 게이트.
> **DB 쓰기 없음** — CSV·스크립트만. 라이브 SELECT 불요(ref 추출본 기반, stale 주의는 §3).
> **템플릿:** `09_load/digital-print/expected-vs-load.md` 동일 게이트 원리(count→set→FK) 계승.

---

## 1. 게이트 원리 — 독립 재생성 대조

`verify_expected.py`는 **적재 CSV를 신뢰하지 않고**, L1·ref 원천에서 기대행을 *독립 경로*로 재산출한 뒤
`load/*.csv`와 대조한다:

1. **count** — 기대 행수 = 적재 행수
2. **set** — 기대 (key) 집합 = 적재 (key) 집합 (MISSING=기대>적재 / FABRICATED=적재>기대)
3. **value/FK 실재** — 적재된 모든 `prd_cd`·`proc_cd`가 마스터(`ref-*.csv`)에 실재
4. **비활성 분리** — deferred CSV의 prd_cd 전부 `use_yn=N` (활성 오분류 0)
5. **마스터부재 차단** — 066 원형 size는 master `t_siz_sizes` 부재이므로 `load/`에 **없어야** 정상(BLOCKED 분리)

독립성 보장: 검증 스크립트는 L1 `sticker-l1.csv`를 **직접 재판독**하고, 화이트 신호(`별색인쇄(옵션)_화이트`)·
qty_unit 대상·비활성 use_yn을 독립 산출한다.

---

## 2. 게이트 결과 (재실행 명령: `python3 09_load/sticker/verify_expected.py`)

```
=== SELF-CHECK (sticker) ===
label                        exp   act  miss  extra  result
R1-whitespot-active            3     3     0      0  PASS
R6-qtyunit                    16    16     0      0  PASS
deferred=use_yn:N              1     1     0      0  PASS
R1-whitespot-deferred          1     1     0      0  PASS
FK+active-guard                -     -     -      0  PASS
R2-size-blocked(no-load)       0     0     0      0  PASS

GATE: PASS — 누락0·날조0·비활성분리·마스터부재차단   (exit 0)
```

| 검증 항목 | 기대 | 적재 | 누락 | 날조 | 판정 |
|-----------|:----:|:----:|:----:|:----:|:----:|
| **R1-whitespot-active** (화이트별색 PROC_000008, 활성만) | 3 | 3 | 0 | 0 | PASS |
| **R6-qtyunit** (16상품 QTY_UNIT.02) | 16 | 16 | 0 | 0 | PASS |
| **deferred=use_yn:N** (063 비활성 분리 정합) | 1 | 1 | 0 | 0 | PASS |
| **R1-whitespot-deferred** (063 화이트별색 보류 일치) | 1 | 1 | 0 | 0 | PASS |
| **FK+active-guard** (proc/prd 마스터 실재 + active에 비활성 0) | — | — | — | 0 | PASS |
| **R2-size-blocked(no-load)** (066 원형 size load/ 부재) | 0 | 0 | 0 | 0 | PASS |

- **R1**: L1 `별색인쇄(옵션)_화이트=화이트인쇄(단면)` 신호 보유 상품 → 자식 PROC_000008(R-PROC-4 부모007 미적재).
  활성 3상품(053·054·056) = 적재 3행 정확 일치. 063(use_yn=N)은 active 집합에서 제외→deferred로 정합. 064는 화이트 신호 없음(반칼 자유형, 종이스티커)이라 대상 아님.
- **R6**: sticker 16상품 전건 QTY_UNIT.02(매) 부여 대상 = 적재 16행. use_yn=N 2상품(063·064)도 포함(컬럼 업데이트는 비활성 무관).
- **R2 BLOCKED**: 066 원형 11종은 master `t_siz_sizes`에 size_cd 부재(circle 6종 중 합판도무송 enum 무매치). 신규 mint=마스터 쓰기(범위밖)라 `_blocked/`에 분리, `load/`에 **미생성**이 정상(발명 금지).

> R2(형상enum)·R3(064 size 오공유)·R5(반칼↔스완 코드)는 **블록/플래그/컨펌** 성격이라 count-set 적재 게이트
> 대상에서 분리하고 §load-spec에서 명시 추적. 본 게이트는 적재-대상 행(화이트별색·qty_unit)의 누락0·날조0만 단정.

---

## 3. stale 주의 — 게이트가 신뢰하는 권위와 한계

- 본 게이트는 `00_schema/ref-*.csv`(추출본 **2026-06-04, stale 가능**)와 L1(엑셀 권위)을 입력으로 한다.
- **stale가 판정을 뒤집을 수 있는 지점**(§load-spec 설계결정으로 격상):
  1. **화이트별색 기적재 여부** — ref 기준 053·054·056 processes=커팅1행뿐(PROC_000008 부재). 라이브가 이미 008을 가지면 중복 PK → **적재 직전 라이브 재확인 필수**(remediation SELECT #6,7는 부재 확인이나 stale 권위반전 원칙 유지).
  2. **066 원형 master 부재** — ref-sizes circle 6종이 stale일 수 있음. 라이브에 합판도무송 원형 size_cd가 이미 mint돼 있으면 BLOCKED 해제(link만 적재). **적재 직전 라이브 master 재확인.**
  3. **064 size 오공유** — ref가 SIZ_000036/043 note=배경지/헤더택 표시. 라이브 동일하면 G-SK-3 MISMATCH 확정(064 use_yn=N이라 Low).
- 따라서 본 게이트의 PASS는 "**추출본 기준 누락0·날조0**"이며, **DB 적재 직전 동일 스크립트를 라이브 export로
  재실행**해 stale 격차를 닫아야 한다(검증 권위 반전 원칙 HARD).

---

## 4. 타시트 확장 (--sheet 파라미터화 정신)

`verify_expected.py` 상단 `SHEET` 상수 + `NM2CD`(상품명→prd_cd) + `WHITE_SIGCOL`/`WHITE_PROC`(화이트 신호→자식 공정)
+ 비활성(`use_yn=N` 분리)·마스터부재(size BLOCKED) 룰만 시트별로 교체하면 동일 게이트 로직(count→set→FK+비활성+blocked)이 재사용된다.
별색 신호 규칙(`값≠'없음' → 별색 공정 존재`)·자식 leaf 적재(R-PROC-4)·FK 실재·비활성 분리는 시트 불변.
digital-print(줄수/개수 SIGCOLS)·sticker(화이트 WHITE_SIGCOL)가 동일 베이스에서 분기. silsa(화이트별색+봉제/타공) 확장 시 본 스크립트를 베이스로 둘 것.
