# expected-vs-load 자기검증 (silsa 적재 게이트)

> **작성** 2026-06-05 · dbm-mapping-designer · 설명 한국어, 식별자/컬럼/코드 영어.
> **목적:** `load/*.csv`가 L1 엑셀(`06_extract/silsa-l1.csv`) + ref 마스터에서 **누락0·날조0·모범재적재0**으로
> 도출됐음을 재현 가능한 스크립트(`verify_expected.py`)로 입증한다. validator가 그대로 재실행하는 게이트.
> **DB 쓰기 없음** — CSV·스크립트만. 라이브 SELECT 불요(ref/L1 추출본 기반, stale 주의는 §3).

---

## 1. 게이트 원리 — 독립 재생성 대조 + 권위반전 가드

`verify_expected.py`는 생성 산출을 신뢰하지 않고, L1·ref 원천에서 기대행을 *독립 경로*로 재산출해 `load/*.csv`와
대조한다. silsa 특화로 **모범 재적재 금지 가드**(권위반전)를 추가했다:

1. **count** — 기대 행수 = 적재 행수
2. **set** — 기대 (key) 집합 = 적재 (key) 집합 (MISSING=기대>적재 / FABRICATED=적재>기대)
3. **FK 실재** — 적재된 모든 `prd_cd`·`proc_cd`·`addon_prd_cd`가 마스터(`ref-*.csv`)에 실재
4. **모범 재적재0 가드(silsa 특화)** — 봉제/타공/족자/부착/코팅(PROC_000079/080/081/082/014/015/016/053/054)이
   load CSV에 **단 1건도 없어야** PASS. G-SL-5 권위반전(MATCH·기적재 정상) — 재적재는 중복PK·결함이므로 가드로 차단.
5. **nonspec numeric(8,2) 가드** — UPDATE 값이 정수부 6자리·소수 2자리 제약 위반 0.

독립성: 검증 스크립트는 L1 `silsa-l1.csv`를 **직접 재판독**(생성기 미참조), `_row_hidden=true`·`nonspec_yn` 필터를
원천에서 다시 적용한다.

---

## 2. 게이트 결과 (재실행 명령: `python3 09_load/silsa/verify_expected.py`)

**실행 결과 — 2026-06-05, exit 0 (PASS 확인):**

```
=== SELF-CHECK (silsa) ===
label                    exp   act  miss  extra  result
R2-white-spot              1     1     0      0  PASS
mobeum-no-reload           0     0     -      0  PASS
R4-nonspec                13    13     0      0  PASS
R6-qtyunit                28    28     0      0  PASS
R3-addon                   1     1     0      0  PASS
FK-existence               -     -     -      0  PASS
nonspec-numeric(8,2)       -     -     -      0  PASS

GATE: PASS — 누락0·날조0·모범재적재0   (exit 0)
```

| 검증 항목 | 기대 | 적재 | 누락 | 날조 | 판정 |
|-----------|:----:|:----:|:----:|:----:|:----:|
| **R2-white-spot** (화이트별색 PROC_000008) | 1 | 1 | 0 | 0 | PASS |
| **mobeum-no-reload** (봉제/타공/족자/부착/코팅 재적재 금지) | 0 | 0 | — | 0 | PASS |
| **R4-nonspec** (대형 비규격 가로/세로 UPDATE) | 13 | 13 | 0 | 0 | PASS |
| **R6-qtyunit** (28상품 QTY_UNIT.01) | 28 | 28 | 0 | 0 | PASS |
| **R3-addon** (족자포스터→천정고리) | 1 | 1 | 0 | 0 | PASS |
| **FK-existence** (proc/addon/prd 마스터 실재) | — | — | — | 0 | PASS |
| **nonspec-numeric(8,2)** (정수6·소수2 제약) | — | — | — | 0 | PASS |

- **R2**: L1 `화이트별색(옵션)`이 `없음` 아닌 신호(`단면`)인 상품 → 접착투명포스터(122) PROC_000008 1건. 라이브 122 process 0행과 정합(MISSING 해소).
- **mobeum-no-reload**: G-SL-5 모범(라이브 기적재 봉제/타공/족자/부착/코팅)을 load CSV가 단 1건도 건드리지 않음을 **기계 보증**. 재적재=중복PK 결함을 원천 차단.
- **R4**: nonspec_yn=Y + 비규격 가로/세로 보유 + 숨김아님 13상품. 폼보드(129)는 nonspec_yn=N+숨김행+단위이상 → 제외(정합).
- **R6**: silsa 28등록 전건 QTY_UNIT.01(EA, 대형 장당). use_yn=Y 28건(미등록 ★투명포스터 제외).
- **R3**: L1 천정형고리 신호(족자포스터)만 master 매칭(천정고리 PRD_000008). 배너거치대/큐방/끈은 master 미존재 → `_deferred` flag(active 집합 외, 정합).

> 보드/액자 자재(R1·5상품)·flag addon·deferred(폼보드 nonspec·★투명포스터)는 **보류/플래그 성격**이라
> count-set 게이트에서 분리하고 §load-spec에서 명시 추적. FK 실재 + 모범 재적재0으로 active 안전성 커버.

---

## 3. stale 주의 — 게이트가 신뢰하는 권위와 한계

- 본 게이트는 `00_schema/ref-*.csv`(추출본 **2026-06-04, stale 가능**)와 L1(엑셀 권위)을 입력으로 한다.
- **stale가 판정을 뒤집을 수 있는 지점**(§load-spec 설계결정으로 격상):
  1. **122 화이트별색 process** — stale ref가 122 process 0행 표시(remediation 라이브 SELECT #11도 0행 확인). 일치하나 적재 직전 라이브 재확인.
  2. **봉제/타공/족자 기적재** — remediation 머리말이 라이브 기적재(권위반전)를 보고. 본 게이트는 이를 신뢰해 재적재 차단. 라이브가 다르면(미적재면) 별도 누락 가능 → 적재 직전 라이브 재확인.
  3. **135 addon 기적재 여부** — stale ref가 135 addon 0행 표시. 라이브가 이미 천정고리를 가지면 중복PK → 적재 직전 재확인.
- 따라서 본 게이트 PASS는 "**추출본 기준 누락0·날조0·모범재적재0**"이며, **DB 적재 직전 동일 스크립트를 라이브 export로
  재실행**해 stale 격차를 닫아야 한다(검증 권위=라이브 HARD).

---

## 4. 타시트 확장 (--sheet 파라미터화 정신)

`verify_expected.py` 상단 `SHEET` 상수 + `NM2CD`(상품명→prd_cd) + `WSC_COL/WSC_PROC`(화이트별색 신호) +
`NONSPEC_W/H`(비규격 컬럼) + `MOBEUM_PROCS`(모범 재적재 금지 집합) 매핑만 시트별로 교체하면 동일 게이트 로직이
재사용된다. digital-print 베이스(`SHEET/NM2CD/IMPORT_MAP/SIGCOLS`)를 silsa 게이트맵으로 교체했고,
silsa 특화로 **모범 재적재0 가드**와 **nonspec numeric(8,2) 가드**를 추가했다.
