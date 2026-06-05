# expected-vs-load 자기검증 (goods-pouch 적재 게이트)

> **작성** 2026-06-05 · dbm-mapping-designer · 설명 한국어, 식별자/컬럼/코드 영어.
> **목적:** `load/*.csv`가 L1 엑셀 + ref 마스터에서 **누락0·날조0·폰케이스신규0·size신규0**으로 도출됐음을
> 재현 가능한 스크립트(`verify_expected.py`)로 입증한다. validator가 그대로 재실행하는 게이트.
> **DB 쓰기 없음** — CSV·스크립트만. 라이브 SELECT 불요(ref 추출본 기반, stale 주의는 §3).

---

## 1. 게이트 원리 — 독립 재생성 대조

`verify_expected.py`는 **생성기(`gen_load.py`)의 산출을 신뢰하지 않고**, L1·ref 원천에서 기대행을 *독립 경로*로
재산출한 뒤 `load/*.csv`와 3단 대조 + 2개 가드:

1. **count** — 기대 행수 = 적재 행수
2. **set** — 기대 (key) 집합 = 적재 (key) 집합 (MISSING=기대>적재 / FABRICATED=적재>기대)
3. **FK 실재** — 적재된 모든 `prd_cd`·`addon_prd_cd`·`proc_cd`가 마스터(`ref-*.csv`)에 실재
4. **GUARD-phonecase=0** — 폰케이스 5상품/미등록 prd_cd가 어떤 load CSV에도 0건(C-1 신규금지)
5. **GUARD-size-newrow=0** — `t_prd_product_sizes.csv` 신규 적재 0건(비치수→마스터 siz_cd 부재, plate 복제 금지)

독립성 보장: 검증 스크립트는 L1 `goods-pouch-l1.csv`를 **직접 재판독**(생성기 출력 미참조)하고, ADDON_MAP/GAGONG_MAP을 재선언한다.

---

## 2. 게이트 결과 (재실행 명령: `python3 09_load/goods-pouch/verify_expected.py`)

**실행 결과 — PASS 확인(exit 0):**

```
=== SELF-CHECK (goods-pouch) ===
label                    exp   act  miss  extra  result
R4-addon-active            1     1     0      0  PASS
R3-proc-active             0     0     0      0  PASS
R6-qtyunit                98    98     0      0  PASS
GUARD-phonecase=0          -     -     -      0  PASS
GUARD-size-newrow=0        -     -     -      0  PASS
FK-existence               -     -     -      0  PASS

GATE: PASS — 누락0·날조0·폰케이스신규0·size신규0   (exit 0)
```

| 검증 항목 | 기대 | 적재 | 누락 | 날조 | 판정 |
|-----------|:----:|:----:|:----:|:----:|:----:|
| **R4-addon-active** (말랑/잉크 → addon_prd_cd, 기적재 skip) | 1 | 1 | 0 | 0 | PASS |
| **R3-proc-active** (에폭시/부착, 기적재·use_yn=N 제외) | 0 | 0 | 0 | 0 | PASS |
| **R6-qtyunit** (matched 98 → QTY_UNIT.01 EA) | 98 | 98 | 0 | 0 | PASS |
| **GUARD-phonecase=0** (폰케이스/미등록 prd 신규금지) | — | — | — | 0 | PASS |
| **GUARD-size-newrow=0** (size 신규 적재 0, plate 복제 금지) | — | — | — | 0 | PASS |
| **FK-existence** (prd/addon_prd/proc 마스터 실재) | — | — | — | 0 | PASS |

- **R4**: L1 `추가상품` 신호(만년스탬프 잉크 5cc) → PRD_000015(리필잉크) 1행. 볼체인(말랑류)은 기적재 skip → 적재 1행 정확.
- **R3**: L1 `가공` 신호 중 부착(081) 6캔버스=기적재·에폭시(083) 미니우치와키링=use_yn=N deferred → active 신규 0 정확.
- **R6**: matched 98상품 전건 QTY_UNIT.01(EA, C-4) = 적재 98행. 폰케이스 5상품(unmatched)은 prd_cd 부재로 자동 제외.

> size(R2)·variant(R5)·deferred·폰케이스는 **차단/보류/정책** 성격이라 count-set 게이트 대상에서 분리하고
> §load-spec에서 명시 추적(검증은 GUARD-size-newrow=0 + GUARD-phonecase=0 + FK 실재로 커버).

---

## 3. size BLOCKER 추적 — 게이트가 입증하는 것 (R2)

`load/t_prd_product_sizes_BLOCKED.reference.csv`(NO-LOAD)는 L1 사이즈 보유 65상품·224행값을 분류:

| 분류 | 상품 수 | 처리 | 게이트 반영 |
|------|:------:|------|-------------|
| WxH 재단치수 보유 → 마스터 cut 일치 | 8(active) | **전부 기적재(skip)** | size 신규 0(GUARD PASS) |
| 비치수(NONDIM, `무광75/원형90/M/L/온스`) | 47(active) | **BLOCKED — 마스터 siz_cd 부재** | size 신규 0(GUARD PASS, 차단) |

- **plate 복제 금지 입증:** 사각손거울 size(SIZ_384/386/388, cut 보유) ≠ plate(SIZ_385/387/389, cut 공란).
  작업사이즈 siz_cd를 재단치수로 복제하지 않음 — `GUARD-size-newrow=0`이 "어떤 size도 추정으로 적재 안 함"을 보장.
- **BLOCKER 실체:** 누락이 아니라 **비치수 사이즈의 마스터 모델링 미정**(D-1 컨펌). 우리측 siz_cd 발명 불가(추정 0).

---

## 4. stale 주의 — 게이트가 신뢰하는 권위와 한계

- 본 게이트는 `00_schema/ref-*.csv`(추출본 **2026-06-04, stale 가능**)와 L1(엑셀 권위)을 입력으로 한다.
- **stale가 판정을 뒤집을 수 있는 지점**: size 기적재 8상품·material variant 기적재·addon 볼체인 기적재·process 부착 기적재.
  라이브가 다르면(미적재면) 누락 발생 가능 → **적재 직전 라이브 export로 재실행 필수**.
- **size BLOCKER(D-1)는 stale 무관 구조적 차단**(비치수→마스터 siz_cd 부재) — 라이브 재실행으로도 해소 안 됨, 마스터 모델링 컨펌 필요.
- 따라서 본 게이트 PASS는 "**추출본 기준 누락0·날조0·폰케이스신규0·size신규0**"이며, DB 적재 직전 동일 스크립트를 라이브 export로 재실행해 stale 격차를 닫는다(검증 권위=라이브 HARD).

---

## 5. 타시트 확장 (--sheet 파라미터화 정신)

`verify_expected.py` 상단 `SHEET` 상수 + `ADDON_MAP`(추가상품→addon_prd_cd) + `GAGONG_MAP`(가공→proc_cd)
+ `PHONE5`(비활성 신규금지 상품) 4개 맵만 시트별 교체하면 동일 게이트 로직(count→set→FK + 2가드)이 재사용된다.
신호 규칙(L1 셀≠빈값 → 연결 존재)·기적재 skip·FK 실재·폰케이스/size 신규금지 가드는 시트 불변.
digital-print 파일럿의 `NM2CD/IMPORT_MAP/SIGCOLS`와 동일한 4맵 교체 패턴(본 시트는 prods 자동매칭으로 NM2CD 대체).
