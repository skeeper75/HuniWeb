# expected-vs-load 자기검증 (photobook 적재 게이트)

> **작성** 2026-06-05 · dbm-mapping-designer · 설명 한국어, 식별자/컬럼/코드 영어.
> **목적:** photobook `load/*.csv`가 L1 엑셀 + ref 마스터(라이브 추출본)에서 **누락0·날조0**으로 도출됐고,
> 라이브 기적재분과 **충돌(중복 PK)·재적재 없음(no-op 불변식)**을 재현 가능 스크립트(`verify_expected.py`)로 입증한다.
> validator가 그대로 재실행하는 게이트.
> **DB 쓰기 없음** — CSV·스크립트만. (stale 주의 §3.)

---

## 1. 게이트 원리 — photobook는 "거의 완비 + 결함 대부분 CONFIRM 게이트" 시트

digital-print 파일럿은 *대량 누락 행 추가*(material 180·process 26)가 핵심이었다. **photobook는 정반대다.**
라이브 PRD_000100은 9속성+sets가 **거의 완비**돼 있고(process PUR·material 7·page_rule·sets 7·excl_group),
결함 G-PB-1~6의 대부분은 *추가 적재*가 아니라 **no-op(이미 정합) 또는 CONFIRM-게이트 재구조화**다.

따라서 게이트는 두 축으로 구성된다:

1. **active 적재 대조(count→set)** — 실제 적재 행은 `t_prd_products_qtyunit_update.csv` **1행뿐**(R5 qty_unit).
2. **no-op 불변식(invariant)** — "이미 정합이라 적재하지 않음"을 *적극 입증*: 제본=PUR 기적재·레이플랫 적재0·
   표지 variant 5종·내지·면지·page_rule·sets 기적재 + **active load에 process/material INSERT 0**(재적재 금지 가드).
3. **value/FK 실재** — active 적재 prd_cd + deferred 제안의 mat_cd/proc_cd가 마스터에 실재.

독립성 보장: 스크립트는 L1 단일상품(`포토북 [디자인명]`→PRD_000100)·QTY_TARGET을 직접 산출하고,
라이브 기적재 상태는 `ref-product-*.csv`를 재판독해 불변식을 검사(생성기 출력 미참조).

---

## 2. 게이트 결과 (재실행 명령: `python3 09_load/photobook/verify_expected.py`)

```
=== SELF-CHECK (photobook) ===
label                                       exp  act miss extra  result
R5-qtyunit(active)                            1    1    0     0  PASS
G-PB-1 제본=PUR 기적재(no-op)                      -    -    -     0  PASS
G-PB-1 레이플랫(025) 적재0(미운영)                     -    -    -     0  PASS
G-PB-5 표지 variant 5종 USAGE.02 기적재             -    -    -     0  PASS
G-PB-5 내지 USAGE.01 기적재                        -    -    -     0  PASS
G-PB-5 면지 USAGE.03 기적재                        -    -    -     0  PASS
G-PB-5 page_rule(24/150/2) 기적재                -    -    -     0  PASS
G-PB-5 sets 7행(내지1·표지5·면지1) 기적재               -    -    -     0  PASS
재적재 금지: active process INSERT 0               -    -    -     0  PASS
재적재 금지: active material INSERT 0              -    -    -     0  PASS
FK-existence(active+deferred)                 -    -    -     0  PASS

GATE: PASS — 누락0·날조0·no-op불변식 충족   (exit 0)
```

**실행 결과 = PASS(exit 0)** — 2026-06-05 본 패스에서 직접 실행 확인.

| 검증 항목 | 기대 | 적재 | 누락 | 날조 | 판정 |
|-----------|:----:|:----:|:----:|:----:|:----:|
| **R5-qtyunit(active)** (PRD_000100 → QTY_UNIT.03 권) | 1 | 1 | 0 | 0 | PASS |
| **G-PB-1 제본=PUR 기적재** (no-op 불변식) | — | — | — | 0 | PASS |
| **G-PB-1 레이플랫(025) 적재0** (미운영 입증) | — | — | — | 0 | PASS |
| **G-PB-5 표지 variant 5·내지·면지·page_rule·sets** (재적재 금지) | — | — | — | 0 | PASS |
| **재적재 금지 가드** (active process/material INSERT 0) | — | — | — | 0 | PASS |
| **FK-existence** (active + deferred 제안 mat/proc 마스터 실재) | — | — | — | 0 | PASS |

- **R5**: L1 단일상품 1종 → 권(QTY_UNIT.03) 1행. 라이브 NULL → 부여 UPDATE.
- **G-PB-1**: 라이브 PRD_000100 process = PROC_000020(PUR) 단독, 레이플랫(025)은 전 상품 적재 0 → **PUR 권위 정합·레이플랫 미운영 입증**(C-10·process-recipe §3-3). 적재 변경 없음.
- **G-PB-5**: 표지 variant 5(USAGE.02)·내지(USAGE.01)·면지(USAGE.03)·page_rule(24/150/2)·sets(7) 전부 기적재 = B 셋트 정상. **재적재 0**(중복 PK 회피).

---

## 3. stale 주의 — 게이트가 신뢰하는 권위와 한계

- 본 게이트는 `00_schema/ref-*.csv`(추출본 **2026-06-04, stale 가능**)와 L1(엑셀 권위)을 입력으로 한다.
- **stale가 판정을 뒤집을 수 있는 지점**(§load-spec 설계결정으로 격상):
  1. **제본 process** — 추출본 PRD_000100=PROC_000020(PUR) 단독. 라이브가 레이플랫(025)으로 바뀌었거나
     PUR이 빠졌다면 no-op 불변식이 깨진다 → **적재 직전 라이브 재확인**(D-PB-LP).
  2. **표지/내지/면지/sets 기적재** — 추출본이 7 material·7 sets를 보임. 라이브가 다르면(미적재면) 재적재 필요 →
     **적재 직전 라이브 export로 동일 스크립트 재실행 필수**.
  3. **qty_unit 현재값** — 추출본 NULL 가정. 라이브가 이미 부여됐다면 UPDATE 무해(idempotent)하나 정책 확인.
- 따라서 본 게이트 PASS는 "**추출본 기준 누락0·날조0·no-op 충족**"이며, **DB 적재 직전 동일 스크립트를 라이브
  export로 재실행**해 stale 격차를 닫아야 한다(검증 권위=라이브 HARD).

---

## 4. 타시트 확장 (--sheet 파라미터화 정신)

`verify_expected.py` 상단 `SHEET` 상수 + 4맵(`NM2CD` 상품명→prd_cd · `QTY_TARGET` prd→qty_unit ·
`PUR_CODE`/`LEAFLAT_CODE` 제본 권위 코드)만 시트별 교체하면 동일 게이트 로직(active count→set + no-op
불변식 + FK 실재)이 재사용된다. booklet(셋트상품 B, 동일 parent-carries-all 모델) 확장 시 본 스크립트를
베이스로 둘 것 — booklet도 photobook과 같이 "기적재 완비 + 재구조화 컨펌" 성격이 강하다.

> digital-print 게이트가 "대량 추가 적재" 패턴(IMPORT 매트릭스·L1 신호컬럼)이라면, photobook 게이트는
> "**거의 완비 + no-op 불변식 + CONFIRM 게이트**" 패턴이다. 두 베이스를 시트 성격에 맞게 선택.
