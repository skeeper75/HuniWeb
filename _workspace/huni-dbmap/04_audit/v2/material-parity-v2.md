# 자재(material) 정합 재검증 v2

작성 2026-06-05 · expected = B 규칙(R-MAT-1~5) + BLOCK-1 IMPORT 해소 코드화. DB read-only.
산출: `expected/material-expected.csv`(271행) · `material-mismatches-v2.csv`. 신뢰도 B(IMPORT·표기차 의존).

---

## 4분류

| 분류 | 행 | 상품 | 1차 대비 |
|------|:--:|:----:|---------|
| MATCH | 209 | 47(MATCH-only) | 1차 121 → v2 209(표기차 정규화) |
| MISSING | 40 | 31 | 1차 15 |
| EXTRA | 266 | 140 | 1차 60 |
| MISMATCH | 0 | 0 | 0 |

## expected 생성 근거

- **R-MAT-1 직접매칭 + 표기차 정규화(v2-FIX3)**: mat_nm 공백·말미 `g`·`N지`→`N` 정규화. (엑셀 `스타드림(다이아)240` ↔ DB `스타드림(다이아) 240g` 매칭. 프리미엄쿠폰 EXTRA 8 → MATCH 전환.)
- **R-MAT-2(`*별도설정`→IMPORT)**: BLOCK-1 import-resolution-resolved.csv로 prd_cd별 종이수 확정(14행 전건). 종이명 미상이면 placeholder(`__IMPORT__N종`)로 카운트 — actual 0행이면 MISSING, actual 존재면 부분 MATCH.
- **R-MAT-3 복합분해**: `아트250+무광코팅`→자재축(아트250)만, 코팅은 공정축 배제.

## MISSING 40 — 분류

| 부류 | 성격 | 판정 |
|------|------|------|
| `*별도설정` placeholder-MISSING | IMPORT 종이 expected인데 actual 0행 (BLOCK-1 6갭 일부) | **진짜 적재결손**(하드커버 내지 4갭=정상구조갭 제외) |
| 명칭약어 표기차 | `백모조220`↔`백색모조지 220g` 미매칭 | **false 후보**(약어 표준화 필요, 1차 "명칭통일" 지적과 동일) |
| 스티커 자재 | 유포/비코팅 스티커 명칭 미매칭 | 표기차 CONFIRM |

> 명칭약어(`백모조`=`백색모조지`)는 자동 정규화 한계 — 과적합 방지 위해 약어사전 미확장, CONFIRM 처리.

## EXTRA 266 — 3분류 플래그(삭제 단정 금지)

| 부류 | 건수(상품) | 성격 | 판정 |
|------|:---:|------|------|
| **엑셀 빈 자재축 굿즈** | 볼체인8·만년스탬프7·말랑키링5·LED키링4·행택끈3 등 | 엑셀에 자재축 없음, DB는 variant(색상) 자재 적재 | 1차 "EXTRA 60=굿즈변형"과 동류. 정당 EXTRA·플래그 |
| **`*별도설정` IMPORT 적재분** | 하드커버링책자7·트윈링5·레더하드커버3 | placeholder expected라 actual이 EXTRA로 빠짐(직접대조 불가) | IMPORT 종이 적재된 경우 실질 MATCH — note 병기 |
| **명칭약어·표기차** | 스탠다드명함5·반칼스티커3 등 | expected가 약어 미매칭 → actual EXTRA | false EXTRA(표준화로 해소) |

## 판정: **MAJOR (신뢰도 B — IMPORT·표기차 의존)**

- 표기차 정규화로 1차 대비 MATCH 121→209 개선(false EXTRA 다수 흡수). 단 명칭약어·IMPORT placeholder 한계로 EXTRA 잔여 큼.
- **거짓정합 위험 없음**: `*별도설정` IMPORT 해소(BLOCK-1)로 자재 결손이 드러남.
- **후니 확인**: ① 명칭약어 표준화(`백모조`=`백색모조지`) ② IMPORT placeholder 상품의 종이명-mat_cd 매핑 확정 ③ 굿즈 variant 자재(EXTRA)는 round-2 component_prices 차원 재분류.
