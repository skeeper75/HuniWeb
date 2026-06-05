# round-3 L2 v2 독립 적대적 재검증 (independent-review)

작성 2026-06-05 · **검증자=v2 비작성 독립 dbm-validator**. v2 주장을 불신 전제로 소스라인 실재성·스크립트 재현·정정 타당성을 손수 확인.
DB read-only(추출본 `00_schema/ref-*.csv` 2026-06-04 + L1 `06_extract/*`). DB 무변경. **스크립트 `audit_v2.py` read-only 재실행 수행함**(아래 CP1).

---

## §0 8 검증포인트 종합

| CP | 검증포인트 | 판정 | 핵심 증거 |
|----|-----------|------|----------|
| 1 | 스크립트 재현성 | **PASS** | `audit_v2.py` 재실행 → 4분류·R-PROC-2=32·별색=2 보고서 인용과 완전 일치. expected/*.csv 바이트 동일, mismatches 정렬후 동일 |
| 2 | 회귀게이트 R-PROC-2=32 독립 카운트 | **PASS** | 12상품 29-32 적재=0 손수 확증. 줄수형4×2+개수형12×2=32. digital-print 한정·sticker 거짓신호 0 |
| 3 | 박/형압 부모 false MISSING 12 철회 | **PASS** | 부모 033(박)/050(형압) 적재 상품수=**0** 실측. 자식 leaf만 적재(034-049 적재 확인) → 철회 정당, 결손 은폐 없음 |
| 4 | 코팅 false EXTRA 43 철회 | **PASS** | 무광코팅 토큰 22상품 전부 PROC_000015 적재 실측 → 동일 공정, 과잉정규화 아님 |
| 5 | 형압자식 051/052 6건 신규 진짜 MISSING | **PASS** | PUR책자·형압명함·무선책자 각 051/052 미적재 실측 + L1 형압(양각/음각) 토큰 실재. BLOCK-1 정합 |
| 6 | 별색 9→2 축소 정당성 | **CONDITIONAL PASS** | 축소는 정당(제외 토큰=화이트링/면지/고리/바디=물리부품, 별색인쇄 아님). **단 잔여 2(포맥스/폼보드)도 화이트 substrate=별색인쇄 아닐 개연, CONFIRM 유지가 옳음** |
| 7 | 숨김/미출시 비활성 분류 | **PASS** | 품절/준비중 셀=정확히 3193, 100% goods-pouch 실측. L1 메타 fill_meaning 실재 신호 |
| 8 | 날조·dead link 점검 | **PASS** | 인용 PROC코드 12종 전부 ref-processes.csv 실재(dead link 0). 소스라인 부존재(G-1형 날조) 0건 |

**적발 이슈: 부당정정·은폐 0건. 날조 0건. MINOR 2건(아래 §3).**

---

## §1 CP1 스크립트 재현성 — PASS (재실행 수행)

`04_audit/v2/scripts/audit_v2.py`를 read-only 재실행. 입력 의존(excel-*.csv 8종·block4-proc-anchor·import-resolution-resolved·import-paper-extract·L1 meta 15) 전부 실재.

재실행 stdout(요약):
```
[size]   MATCH=415 MISSING=31 EXTRA=21    [process] MATCH=156 MISSING=48 EXTRA=40
[material] MATCH=209 MISSING=40 EXTRA=266 [print_option] MATCH=109 MISSING=3 EXTRA=63
R-PROC-2 = 32건 PASS(≥6) · 별색공정 = 2건
```
- `audit-summary-v2.md §1`·`_results.json` 인용과 **완전 일치**.
- `expected/*.csv` 4종 → 재실행본과 **바이트 동일**(diff 무).
- `*-mismatches-v2.csv` 4종 → 정렬 후 md5 동일(차이=set 반복순서뿐, 내용 동일).
- `_results.json` diff=dict 키순서뿐(동일 12상품·동일 코드·합계 32). **날조 신호 없음.**

## §2 CP2 회귀게이트 독립 카운트 — PASS

ref-product-processes.csv에서 12상품 prd_cd 해소 후 PROC_000029/030/031/032 적재 손수 카운트: **12상품 전부 0 적재**.
L1 신호 교차: 프리미엄엽서=줄수+개수(→29/30/31/32), 명함/접지카드=개수만(→31/32). 보고서 상품별 명세와 일치.
- 검출 모수 = 줄수형 4상품×2 + 개수형 12상품×2 = 8+24 = **32**. mismatches CSV 실카운트=32, 12상품, sticker 0.
- **독립 카운트 32 = v2 주장 32 → 게이트 PASS(C §⑦ "R-PROC-2 ≥ 6" 충족).**

## §3 적발 이슈 (MINOR 2건 — 정정 무효화 아님)

| # | 이슈 | 등급 | 내용 |
|---|------|------|------|
| M-1 | 치수브리지 그룹수 인용 오차 | **MINOR** | 보고서 "30그룹" vs 독립 실측 **29그룹**(동일 cut치수 복수 siz_cd). off-by-one, 브리지 메커니즘·규모 정확. 정정 무효화 아님 |
| M-2 | 별색 잔여 2건 substrate 혼동 가능 | **MINOR** | 포맥스보드/폼보드 PROC_000008(화이트) MISSING은 `화이트포맥스(3mm)`/`화이트보드`=백색 substrate 자재옵션에서 `startswith('화이트')` 휴리스틱 도출. 별색인쇄 아닐 개연. **보고서가 이미 CONFIRM(MISSING 미단정)으로 보류 → 은폐·과대단정 아님**. 잔여 2도 substrate면 진짜 별색공정 MISSING=0 가능 |

> M-1·M-2 모두 정정의 방향·정당성을 뒤집지 않음. M-2는 오히려 v2가 별색을 보수적으로 CONFIRM 처리한 것이 옳음을 강화.

## §4 정정 타당성 종합 (CP3~CP7)

- **CP3 부모 false MISSING 철회**: 박033/형압050 부모코드 적재 상품 실측 **0**, 자식(박037-049) 적재 확인 → "부모 미적재·자식 leaf 적재" 규칙이 실데이터와 정합. 1차의 부모코드 대조는 방법론 오류였음이 입증. 결손 은폐 없음.
- **CP4 코팅 false EXTRA 철회**: 무광코팅 토큰 22상품 **전부** PROC_000015 적재 → 표기차 브리지는 실제 동일공정 연결, 진짜 EXTRA 은폐 없음.
- **CP5 형압자식 신규 MISSING**: 3상품×051/052=6건, 미적재 실측 + L1 토큰 실재 + BLOCK-1 형압명함 갭 정합 → 진짜 결손. 부모규칙 보정의 정당한 부산물.
- **CP6 별색 9→2**: 제외된 7건의 토큰(화이트링/면지/고리/바디/금색·은색고리)은 물리 부품 색상이지 별색인쇄(PROC_000007 자식)가 아님 → 1차 과대검출의 정당한 정정. **진짜 결손 은폐 아님**(M-2 참조, 잔여 2도 보수 보류).
- **CP7 비활성 분류**: 품절/준비중 3193셀 100% goods-pouch 실측, unresolved 7상품(★보류/신규)은 별도 모집단 → MISSING 제외 타당.

## §5 잔여 5속성 DB actual 검증 — 정확

small-attrs DB 행수 손수 확인: page_rule **11**·bundle_qty **4행/2상품**·addl **34**·process_select_group **13**·plate **509** — §1 대시보드 "DB행" 전부 일치. 판정(GO/MAJOR/CONDITIONAL/N/A)은 1차 유지로 보수적, 과대주장 없음.

---

## §6 회귀게이트 독립 판정

| 지표 | v2 주장 | 독립 실측 | 판정 |
|------|:------:|:--------:|------|
| R-PROC-2 줄수/개수 MISSING | 32 | **32** | **PASS (≥6 충족, C §⑦)** |
| 프리미엄엽서 29/30/31/32 | 4 검출 | 적재0 확증 | 일치 |
| 프리미엄명함 31/32 | 2 검출 | 적재0 확증 | 일치 |
| digital-print 한정·sticker 거짓 0 | 확인 | 12상품 전부 digital-print·sticker 0 | 일치 |

**독립 카운트가 v2 주장과 정확히 일치 → 회귀게이트 PASS.**

---

## §7 최종 판정 — **GO (CONDITIONAL)**

- **v2는 독립 재검증을 통과한다.** 8 검증포인트 중 7 PASS·1 CONDITIONAL PASS(CP6, 단 v2가 이미 보수 보류). 부당정정·은폐·날조 **0건**.
- 1차 핵심 결함(상쇄형 누락 은폐=프리미엄엽서 4공정 미검출)이 v2 규칙 코드화로 재발 0임을 **스크립트 재실행으로 기계 재현 확인**.
- 모든 정정(false MISSING 12·false EXTRA 43 철회, 형압자식 6 신규, 별색 9→2)이 라이브 마스터·L1 실데이터와 정합. 정정이 진짜 결손을 숨기지 않음.
- MINOR 2건(그룹수 off-by-one·별색 잔여 2 substrate 혼동 가능)은 판정·정정을 뒤집지 않으며, M-2는 v2의 CONFIRM 보류 처리가 옳음을 강화.
- **DB 미적재 유지·정정/적재 별도 단계 권고는 타당.** MAJOR 3(material·process·bundle_qty·addl 적재결손)은 실결손으로 확인되며 후속 적재 작업의 대상.

**산출 경로**: `04_audit/v2/independent-review.md`
