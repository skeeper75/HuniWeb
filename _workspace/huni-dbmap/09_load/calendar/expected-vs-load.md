# expected-vs-load 자기검증 (calendar + design-calendar 적재 게이트)

> **작성** 2026-06-05 · dbm-mapping-designer · 설명 한국어, 식별자/컬럼/코드 영어.
> **목적:** `load/*.csv` + `*_update.csv`가 L1 엑셀 + ref 마스터 + IMPORT 매트릭스에서 **누락0·날조0·신규행0**으로
> 도출됐음을 재현 가능한 스크립트(`verify_expected.py`)로 입증한다. validator가 그대로 재실행하는 게이트.
> **DB 쓰기 없음** — CSV·스크립트만. 라이브 SELECT 불요(ref/IMPORT 추출본 기반, stale 주의는 §3).

---

## 1. 게이트 원리 — 독립 재생성 대조

`verify_expected.py`는 **적재 생성기(`gen_load.py`)의 산출을 신뢰하지 않고**, L1·ref·IMPORT 원천에서 기대행을
*독립 경로*로 재산출한 뒤 `load/*.csv`·`*_update.csv`와 대조한다:

1. **count** — 기대 행수 = 적재 행수
2. **set** — 기대 (key) 집합 = 적재 (key) 집합 (MISSING=기대>적재 / FABRICATED=적재>기대)
3. **신규행0** — design-calendar 공유 보장: 모든 UPDATE/INSERT prd_cd ⊆ {108~112}(캘린더 외 prd_cd=0)
4. **FK 실재** — 적재된 모든 `prd_cd`·`proc_cd`·`mat_cd`가 마스터에 실재

독립성 보장: 검증 스크립트는 L1 `calendar-l1.csv`·`design-calendar-l1.csv`를 **직접 재판독**(생성기 출력 미참조),
IMPORT는 `import-paper-matrix-long.csv`를 재집계, 기적재 중복은 `ref-product-materials.csv`로 독립 차감한다.

---

## 2. 게이트 결과 (재실행 명령: `python3 09_load/calendar/verify_expected.py`)

```
=== SELF-CHECK (calendar+design-calendar) ===   [보정 후 재실행, 2026-06-05]
label                      exp   act  miss  extra  result
R3-material(IMPORT)         43    43     0      0  PASS
R1-excl_link(UPDATE)         4     4     0      0  PASS
R6-qtyunit(EA)               5     5     0      0  PASS
C5-editor_yn(●→Y)            4     4     0      0  PASS
design-cal-신규행0              0     -     -      0  PASS
FK-existence                 -     -     -      0  PASS

GATE: PASS — 누락0·날조0·신규행0   (exit 0)
```

| 검증 항목 | 기대 | 적재 | 누락 | 날조 | 판정 |
|-----------|:----:|:----:|:----:|:----:|:----:|
| **R3-material** (IMPORT ●종이→mat_cd, 기적재+라이브충돌 차감) | 43 | 43 | 0 | 0 | PASS |
| **R1-excl_link** (택일 멤버 process→GRP-CAL-가공 UPDATE) | 4 | 4 | 0 | 0 | PASS |
| **R6-qtyunit** (5상품 QTY_UNIT.01=EA) | 5 | 5 | 0 | 0 | PASS |
| **C5-editor_yn** (design-calendar 디자인보유●→Y, 110 모호 제외) | 4 | 4 | 0 | 0 | PASS |
| **design-cal-신규행0** (UPDATE/INSERT prd_cd⊆108~112) | 0 | — | — | 0 | PASS |
| **FK-existence** (proc/mat/prd 마스터 실재) | — | — | — | 0 | PASS |

- **R3**: IMPORT ●종이 → `mat_nm` 정확매치 100%(108:8·109:7·110:10·111:22 = 47 IMPORT매칭, exact, fuzzy 0, unmatched 0).
  기적재(112 직접명·108/109 삼각대/링)에 더해 **라이브 충돌 MAT_000107 4행(108/109/110/111)을 추가 차감**(dbm-validator 라이브 SELECT 2026-06-05)
  → **active 적재 기대 43** = 적재 43. conditional 4행은 별도 보류(중복PK 회피). 종이 1종도 추정·날조 없음.
- **R1**: 라이브 기적재 멤버 process(110:타공·111:트윈링+타공·112:트윈링) 4건의 excl_grp_cd NULL→GRP-CAL-가공 연결 = 적재 4건 정확.
  비명칭 멤버(가공없음/우드거치대/삼각대/제본없음)는 master proc_cd 부재라 **기대 집합에서 정당 제외**(발명 금지) → 정합.
- **C5**: design-calendar L1 디자인보유●(108/109/111/112)=4 → editor_yn=Y 적재 4건. 110(시트 등장·● 비표시)은
  **셀 모호로 기대·적재 양쪽 제외**(no-op+flag)라 정합.
- **신규행0**: editor_yn·qtyunit·material 전 행의 prd_cd가 108~112 부분집합 — design-calendar 신규 상품/행 발생 0(HARD 가드).

> R4(우드거치대 note 정정)·excl_member_flag·mis-axis_flag·page/링칼라 deferred는 **부분 적재/플래그/보류** 성격이라
> count-set 게이트에서 분리하고 §load-spec에서 명시 추적(검증은 FK 실재 + 신규행0으로 커버).

---

## 3. stale 주의 — 게이트가 신뢰하는 권위와 한계

- 본 게이트는 `00_schema/ref-*.csv`(추출본 **2026-06-04, stale 가능**)와 L1·IMPORT(엑셀 권위)를 입력으로 한다.
- **stale가 판정을 뒤집을 수 있는 지점**(§load-spec 설계결정으로 격상):
  1. **excl_grp_cd 연결(R1)** — stale ref=110/111/112 process행 excl_grp_cd NULL. 라이브가 이미 연결됐으면 UPDATE 불요(no-op).
  2. **material 중복(R3)** — **[실현됨·해소됨 2026-06-05]** stale ref=108~111 IMPORT 종이 0행이었으나 라이브엔 MAT_000107(몽블랑190g)
     108/109/110/111 기적재 → **중복 PK 충돌 4행 실제 발생**(dbm-validator 적발, NO-GO 사유). 게이트에 `LIVE_COLLISION_MAT` 제외 추가 +
     충돌 4행 conditional 이동으로 해소(R3 기대 47→43). **stale 위험이 calendar에서 실제로 터진 지점.**
  3. **editor_yn 현재값(C-5)** — stale ref=전 5상품 N. 라이브가 이미 Y면 UPDATE 불요.
  4. **108/109 excl_group 헤더** — stale=0행(Q-2). 라이브 신설 시 즉시 해소.
- 따라서 본 게이트의 PASS는 "**추출본 기준 누락0·날조0·신규행0**"이며, **DB 적재 직전 동일 스크립트를 라이브 export로
  재실행**해 stale 격차를 닫아야 한다(검증 권위 반전 원칙).

---

## 4. 타시트 확장 (--sheet 파라미터화 정신)

`verify_expected.py` 상단 `SHEET` 상수 + 4맵 교체로 동일 게이트 로직(count→set→신규행0→FK)이 재사용된다:
- `NM2CD` (상품명→prd_cd)
- `IMPORT_MAP` (IMPORT 컬럼→prd_cd)
- `EXCL_LINK_EXP` (택일 멤버 (prd_cd,proc_cd) 기대 집합)
- design-calendar 류 공유시트는 `ALL_CAL` 신규행0 가드를 시트 prd_cd 집합으로 교체.

IMPORT ●매칭·기적재 독립 차감·excl_grp_cd 연결·신규행0·FK 실재 검사는 시트 불변.
calendar(공유 prd_cd+택일그룹+editor_yn)는 digital-print(IMPORT+신호공정) 대비 **UPDATE성 게이트(excl_link·editor_yn)**와
**신규행0 가드**가 추가된 변형 — 공유 prd_cd 시트(design-* 류) 확장 시 본 스크립트를 베이스로 둘 것.

---

## 5. 보정 이력 (NO-GO → 재산출)

| 일자 | 사건 | 조치 | 결과 |
|------|------|------|------|
| 2026-06-05 (1차) | 설계 산출(`gen_load.py`) — R3 material 47행 | 게이트 PASS(exit 0, stale ref 기준) | (잠정 PASS) |
| 2026-06-05 (검증) | **dbm-validator 독립검증 NO-GO** — material 4행(MAT_000107 몽블랑190g, PRD_000108/109/110/111)이 **라이브 기적재 → INSERT 중복PK 충돌**(라이브 SELECT 직접 확인). 게이트는 stale라 미검출 | — | NO-GO(MAJOR/적재차단) |
| 2026-06-05 (보정) | 충돌 4행을 digital-print 016 conditional 패턴으로 `t_prd_product_materials_conditional.csv`로 **이동**(reason=라이브 기적재 중복PK, 적재 직전 재확인). active material 47→43. `verify_expected.py`에 `LIVE_COLLISION_MAT` 제외 추가(R3 기대 47→43). H5 표기 "해소"→**"BLOCKER 부분해소+컨펌"**(PARTIAL, 110/112 단일멤버) 정정. 미연결 멤버 6종은 추정 proc 발명 금지 유지(Q-1 컨펌). 110 editor_yn 모호 Q-3 명시. material 충돌 Q-8 신설 | 게이트 **재PASS(exit 0)**, R3-material 43=43 | **보정 완료** |

**잔여(적재 차단·컨펌 선결):**
- **conditional 4행(Q-8):** 적재 직전 라이브-export 재실행으로 MAT_000107 실재 재확인 → 실재 시 폐기·부재 시 active 승격.
- **택일 H5(Q-1):** 110·112 단일멤버 택일은 **기능 미완(BLOCKER 잔존)**. 미연결 멤버 모델링은 도메인 컨펌 필수(라이브 조회로 안 풀림). **본 게이트 PASS ≠ 택일 H5 완결.**
- **design-cal 110 editor_yn(Q-3):** 셀 모호 → 현행 N 유지(no-op), Y 단정은 발명이라 보류.
