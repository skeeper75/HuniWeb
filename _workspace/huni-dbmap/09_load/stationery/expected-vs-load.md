# expected-vs-load 자기검증 (stationery 적재 게이트)

> **작성** 2026-06-05 · dbm-mapping-designer · 설명 한국어, 식별자/컬럼/코드 영어.
> **목적:** `load/*.csv`가 L1 엑셀 + ref 마스터에서 **누락0·날조0**으로 도출됐음을 재현 가능한
> 스크립트(`verify_expected.py`)로 입증한다. validator가 그대로 재실행하는 게이트.
> **DB 쓰기 없음** — CSV·스크립트만. 라이브 SELECT 불요(ref 추출본 기반, stale 주의는 §3).

---

## 1. 게이트 원리 — 독립 재생성 대조

`verify_expected.py`는 **적재 생성기(`gen_load.py`)의 산출을 신뢰하지 않고**, L1·ref 원천에서
기대행을 *독립 경로*로 재산출한 뒤 `load/*.csv`와 3단 대조한다:

1. **count** — 기대 행수 = 적재 행수
2. **set** — 기대 (key) 집합 = 적재 (key) 집합 (MISSING=기대>적재 누락 / FABRICATED=적재>기대 날조)
3. **value/FK 실재** — 적재된 모든 `prd_cd`·`proc_cd`가 마스터(`ref-*.csv`)에 실재 + **excl_grp 공란**(G-ST-3)

독립성 보장: 검증 스크립트는 L1 `stationery-l1.csv`를 **직접 재판독**(생성기 출력 미참조)하고,
`제본사양`/`표지사양` 셀에서 기대 proc 집합을 재산출한다.

---

## 2. 게이트 결과 (재실행 명령: `python3 09_load/stationery/verify_expected.py`)

```
=== SELF-CHECK (stationery) ===
label                    exp   act  miss  extra  result
R1-bind-active             6     6     0      0  PASS
R2-coat-active             7     7     0      0  PASS
R5-qtyunit                11    11     0      0  PASS
FK-existence               -     -     -      0  PASS
excl-empty(G-ST-3)         -     -     -      0  PASS

GATE: PASS — 누락0·날조0   (exit 0)
```

**실행 확인:** 2026-06-05 본 환경에서 `python3 09_load/stationery/verify_expected.py` 실행 → 위 출력 + **exit 0(PASS)** 재현 확인.

| 검증 항목 | 기대 | 적재 | 누락 | 날조 | 판정 |
|-----------|:----:|:----:|:----:|:----:|:----:|
| **R1-bind-active** (제본사양 enum→proc, active만) | 6 | 6 | 0 | 0 | PASS |
| **R2-coat-active** (표지 무광코팅→PROC_000015) | 7 | 7 | 0 | 0 | PASS |
| **R5-qtyunit** (11상품 QTY_UNIT.03) | 11 | 11 | 0 | 0 | PASS |
| **FK-existence** (proc/prd 마스터 실재) | — | — | — | 0 | PASS |
| **excl-empty (G-ST-3)** (제본 단일고정 → excl_grp 공란) | — | — | — | 0 | PASS |

- **R1**: L1 `제본사양`이 트윈링/중철/떡/하드커버 토큰을 가진 상품(use_yn=Y, 097 제외) → 021/018/022/023 기대.
  active 6행(173·174·177·178·179·181) = 적재 6행 정확 일치. 172·175·176(제본사양 공란)은 기대 집합에서 제외돼 정합.
- **R2**: L1 `표지사양`에 `무광코팅` 토큰을 가진 상품(use_yn=Y, 097 제외) → PROC_000015 기대 7행.
  레더 표지(174·175)는 코팅 없어 기대 미포함 = 적재 미포함 정합.
- **R5**: stationery 11상품 전건 QTY_UNIT.03(권) 부여 대상 = 적재 11행.
- **excl-empty**: 적재 process 13행 전부 `excl_grp_cd` 공란(G-ST-3 단일고정 입증). 1건이라도 채워지면 FAIL.

> 코팅 자재 swap(D-ST-4)·page_rule(엑셀 공란)·bundle(떡메모지뿐)·097 정정은 **보류/no-op 성격**이라 count-set
> 게이트 대상에서 분리하고 §load-spec에서 명시 추적(검증은 FK 실재 + excl 공란으로 커버).

---

## 3. stale 주의 — 게이트가 신뢰하는 권위와 한계

- 본 게이트는 `00_schema/ref-*.csv`(추출본 **2026-06-04, stale 가능**)와 L1(엑셀 권위)을 입력으로 한다.
- **stale가 판정을 뒤집을 수 있는 지점**(§load-spec 설계결정으로 격상):
  1. **097 레퍼런스 실태** — ref=떡제본 단독·고아 excl-group·bundle 이중기본값. 라이브가 다르면 §1 finding 갱신.
  2. **172~181 material 기적재** — ref가 표지 USAGE.02 등 적재 표시. 이를 신뢰해 material no-op 판정. 라이브 상이 시 누락 가능.
  3. **use_yn** — ref=180만 N. 라이브 상이 시 active/deferred 분류 변동.
- **proc_cd 매핑은 stale 무관**: ref-processes(2026-06-03)는 코드 정의(떡제본=022·하드커버=023…)라 안정.
- 따라서 본 게이트의 PASS는 "**추출본 기준 누락0·날조0**"이며, **DB 적재 직전 동일 스크립트를 라이브 export로
  재실행**해 stale 격차를 닫아야 한다(검증 권위 반전 원칙).

---

## 4. 타시트 확장 (--sheet 파라미터화 정신)

`verify_expected.py` 상단 `SHEET` 상수 + `NM2CD`(상품명→prd_cd) + `BIND_NM2PROC`(제본사양 토큰→proc)
+ `COAT_TOKEN/COAT_PROC`(표지 코팅 토큰→공정) 4개 매핑만 시트별로 교체하면 동일 게이트 로직(count→set→FK→excl)이 재사용된다.
- digital-print는 `IMPORT_MAP`·`SIGCOLS`(줄수신호) 축, stationery는 `BIND_NM2PROC`(제본 enum)·`COAT` 축 — **시트별 핵심 변환축이 다름**.
- 공통 불변: 제본/공정 enum→proc 변환, FK 실재 검사, active/use_yn=N/기적재 분리.
- booklet(제본 8종 풀세트)·photobook(PUR/레이플랫) 확장 시 본 스크립트의 `BIND_NM2PROC`를 8종으로 확대해 베이스로 둘 것.
