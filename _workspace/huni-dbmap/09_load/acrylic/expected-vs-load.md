# expected-vs-load 자기검증 (acrylic 적재 게이트)

> **작성** 2026-06-05 · dbm-mapping-designer · 설명 한국어, 식별자/컬럼/코드 영어.
> **목적:** `load/*.csv`가 L1 엑셀 + ref 마스터에서 **누락0·날조0**으로 도출됐음을 재현 가능한 스크립트
> (`verify_expected.py`)로 입증한다. validator가 그대로 재실행하는 게이트.
> **DB 쓰기 없음** — CSV·스크립트만. 라이브 SELECT 불요(ref/L1 추출본 기반, stale 주의는 §3).

---

## 1. 게이트 원리 — 독립 재생성 대조

`verify_expected.py`는 **적재 생성기(`gen_load.py`)의 산출을 신뢰하지 않고**, L1·ref 원천에서
기대행을 *독립 경로*로 재산출한 뒤 `load/*.csv`와 3단 대조한다:

1. **count** — 기대 행수 = 적재 행수
2. **set** — 기대 (key) 집합 = 적재 (key) 집합 (MISSING=기대>적재 누락 / FABRICATED=적재>기대 날조)
3. **FK 실재** — 적재된 모든 `prd_cd`·`proc_cd`·`mat_cd`가 마스터(`ref-*.csv`)에 실재 + active CSV에 use_yn=N 0건

독립성 보장: 검증 스크립트는 L1 `acrylic-l1.csv`를 **직접 재판독**(생성기 출력 미참조)해
인쇄사양(UV변형)·조각수·소재두께·가공명·비규격 범위를 상품별 재집계한다.

---

## 2. 게이트 결과 (재실행 명령: `python3 09_load/acrylic/verify_expected.py`)

```
=== SELF-CHECK (acrylic) ===   [보정 후 — Wave B2 후속 2026-06-05]
label                    exp   act  miss  extra  result
R1-diecut-active          14    14     0      0  PASS   ← 17→14 (over-reach 161·168·169 deferred)
R1-diecut-overreach        0     0     0      0  PASS   ← 신규 독립 가드(과적용 검출)
R1-uv-active              14    14     0      0  PASS
R1-attach-active           1     1     0      0  PASS   ← 2→1 (151 부착 conditional 분리)
R3-mat-thickness          20    20     0      0  PASS
R3-mat-accessory          10    10     0      0  PASS
R2-bundle-piece            6     6     0      0  PASS
R6-qtyunit                23    23     0      0  PASS
R6-nonspec                12    12     0      0  PASS
FK-existence               -     -     -      0  PASS
active-no-inactive         -     -     -      0  PASS

GATE: PASS — 누락0·날조0   (exit 0)
```

| 검증 항목 | 기대 | 적재 | 누락 | 날조 | 판정 |
|-----------|:----:|:----:|:----:|:----:|:----:|
| **R1-diecut-active** (완칼 PROC_000053, active) | 14 | 14 | 0 | 0 | PASS |
| **R1-diecut-overreach** (over-reach 161·168·169 active 누출, 신규) | 0 | 0 | 0 | 0 | PASS |
| **R1-uv-active** (UV PROC_000002, active) | 14 | 14 | 0 | 0 | PASS |
| **R1-attach-active** (부착 PROC_000081, active) | 1 | 1 | 0 | 0 | PASS |
| **R3-mat-thickness** (두께정정 192→042/043/044) | 20 | 20 | 0 | 0 | PASS |
| **R3-mat-accessory** (부속자재 MAT_TYPE.07, active) | 10 | 10 | 0 | 0 | PASS |
| **R2-bundle-piece** (조각수 bundle_qty, active) | 6 | 6 | 0 | 0 | PASS |
| **R6-qtyunit** (23상품 QTY_UNIT.01 EA) | 23 | 23 | 0 | 0 | PASS |
| **R6-nonspec** (비규격 범위 update-set) | 12 | 12 | 0 | 0 | PASS |
| **FK-existence** (proc/mat/prd 마스터 실재) | — | — | — | 0 | PASS |
| **active-no-inactive** (active CSV에 use_yn=N 누출) | — | — | — | 0 | PASS |

- **R1-diecut**: **GROUNDED 14상품**(146·147·148·149·150·151·152·154·155·157·158·160·162·163) 완칼 → 14행 일치. 비활성 6상품 + over-reach 3상품(161·168·169)은 active 집합에서 제외(deferred). **[보정] 17→14**.
- **R1-diecut-overreach(신규 독립 가드)**: 161·168·169가 active CSV에 1건이라도 남으면 발화 → 0건(PASS). 게이트 순환검증(생성기=검증기 동일 하드코딩) 차단.
- **R1-uv**: L1 인쇄사양(UV변형) 보유 상품 → PROC_000002 1행/상품(변형 다수=마스터 param). active 14행.
- **R1-attach**: L1 가공=자석부착/맥세이프 보유 → PROC_000081. 마그넷·맥세이프 2행.
- **R3-thickness**: L1 소재 두께 → 042/043/044 매칭. 10T(라미)·골드실버(색상)는 정정제외 명시(발명금지). 20행.
- **R3-accessory**: L1 가공명 → MAT_TYPE.07 부속(마스터 실재한 것만). 색상-only 가공은 부속 아님(미적재). 10행.
- **R2-bundle**: L1 조각수 정수 → bundle_qty. 자유형스탠드 5 + 미니파츠 1 = 6행.
- **R6-qtyunit**: 등록 23상품(167 제외) 전건 QTY_UNIT.01(EA, C-4).
- **R6-nonspec**: L1 비규격 가로/세로 범위 보유 12상품.

> R4 부착·R5 print_side 정정·R7 addon·deferred는 **부분 적재/UPDATE/flag** 성격이라 일부는 count-set 게이트로,
> 나머지(print_side UPDATE·addon flag)는 §load-spec에서 명시 추적(검증은 FK 실재 + active 비활성누출 0으로 커버).

---

## 2-1. 보정 이력 (Wave B2 검증 후속, 2026-06-05)

`03_validation/waveB2-load-validation.md`의 **CONDITIONAL GO(1 BLOCKER+1 MAJOR)** 해소 반영.

- **R1-diecut-active 17→14:** over-reach 161·168·169를 active에서 `_deferred/`로 분리. 게이트 기대치를 생성기 규칙(`cd_active`) 비참조 **per-product GROUNDED 14 prd_cd 명시 리스트**로 전환.
- **R1-attach-active 2→1:** 151 맥세이프 부착(라이브 기적재 중복PK)을 conditional로 분리. 151이 active에 재출현하면 FABRICATED.
- **R1-diecut-overreach(신규):** 161·168·169 active 누출 독립 가드. 순환검증(생성기=검증기 동일 `diecut=True` 하드코딩) 사각 차단.
- **게이트 독립성 강화 검증(adversarial):** 161 완칼 행을 active에 재주입 → `R1-diecut-active` FABRICATED + `R1-diecut-overreach` 발화로 **즉시 FAIL(exit 1)**. 원복 후 PASS(exit 0). 무결성 가드(`assert grounded|overreach == active17`)로 리스트 누락도 방지.
- **DB 미적재 유지.** 변경 = active CSV −5행(완칼−3·부착−1, 단 부착1은 conditional로 이동·완칼−3는 deferred), conditional +1, deferred +3, 게이트 강화.

---

## 3. stale 주의 — 게이트가 신뢰하는 권위와 한계

- 본 게이트는 `00_schema/ref-*.csv`(추출본 **2026-06-04, stale 가능**)와 L1(엑셀 권위)을 입력으로 한다.
- **stale가 판정을 뒤집을 수 있는 지점**(§load-spec 설계결정으로 격상):
  1. **맥세이프(151) 부착 중복**(D-AC-1) — 라이브 기적재 시 active 적재가 중복 PK. → 적재 직전 라이브 재확인.
  2. **167 아크릴코롯토**(D-AC-6) — stale ref=등록·use_yn=Y이나 L1 고유앵커 부재. 모집단 분리(flag).
  3. **두께정정 전제**(R3) — stale ref가 192 기적재를 보인다. 라이브가 다르면 정정 대상 불일치 가능.
  4. **print_side 오적재**(R5) — stale ref가 20상품에 UV변형 print_side 적재 표시. 라이브 다르면 정정 대상 변동.
- 따라서 본 게이트의 PASS는 "**추출본 기준 누락0·날조0**"이며, **DB 적재 직전 동일 스크립트를 라이브 export로
  재실행**해 stale 격차를 닫아야 한다(검증 권위 반전 원칙).

---

## 4. 타시트 확장 (--sheet 파라미터화 정신)

`verify_expected.py` 상단 `SHEET` 상수 + `STALE_DUP`(stale 중복 후보) + L1 재판독 규칙(인쇄사양→UV·조각수→bundle·
소재→두께·가공→부속/부착)만 시트별로 교체하면 동일 게이트 로직(count→set→FK→비활성누출)이 재사용된다.
공정 묵시필수 규칙(완칼)·두께분해(THICK 맵)·부속매핑(GAGONG2MAT)·FK 실재 검사는 베이스 구조 불변.
digital-print 게이트(`SIGCOLS`/`IMPORT_MAP`)와 동형 — 시트 특화 맵만 교체.
