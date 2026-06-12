# Curation Pack — booklet (책자)

> slug `booklet`(상품마스터 시트4·별도설정 11건 내지/표지 2축). 가격 `binding`(제본)·`postcard-book`(엽서북떡메).
> round-13: PRD_000078 sub_prd 몽블랑130g(레더여야)·BK-CAT 전용노드 6개 상품0 고아.

## 집필 항목별 권위 소스

| 항목 | 정답 소스(file:§) | tier | freshness | 보조 |
|------|-------------------|------|-----------|------|
| **정체/카테고리** | `17_correctness/booklet/product-identity.md` | C13 | FRESH | `06_extract/booklet-l1.csv`(B) |
| **차원(size·재질·공정)** | `15_domain-spec/booklet/column-dictionary.md`·`product-bom.md`(내지/표지 2축) | C11 | FRESH | `16_*/booklet/mapping-final.md`(C12·D-BK-1 보정) |
| **가격공식 사슬** | `02_mapping/price211-booklet-photobook/` + `06_extract/price-binding-l1.csv`·`price-postcard-book-l1.csv` | C2/B | PARTIAL-STALE(I-1·I-3)·L1 FRESH | — |
| **CPQ 옵션** | `16_*/booklet/mapping-final.md` 옵션부 | C12 | PARTIAL-STALE(I-5·I-9) | — |
| **위젯 계약** | `huni-widget/03_spec/data-contract.md` | D | FRESH | — |
| **webadmin 적재 경로** | `17_correctness/booklet/loadlogic-notes.md` + `raw/webadmin/sql/` | C13/A | FRESH | — |
| **결함 현황** | `17_correctness/booklet/correction-manifest.md` + `_gate/booklet-gate.md` | C13 | FRESH | `live-diff.md` |

## stale 함정

1. **레더 자재유형 오염(round-13·추가-B/②).** PRD_000078 sub_prd 몽블랑130g(정답=레더). MAT_000186 .08 횡단오염. 라이브 자재값 인용 시 correction-manifest 대조 → .06(가죽).
2. **BK-CAT 전용노드 6개(CAT_000100~103/106/107) 상품0 고아(round-13·횡단①).** 카테고리 재연결 미적재.
3. **코팅 = 책자는 공정(round-13 Q9 기준점).** 스티커/포토북 자재 오적재와 대조.
4. **page_rule 잡음(떡제본 3/3/3·추가-F·stationery 동형).** 의미없는 page 값 정리 대상.
5. **`price-engine-ddl.md` 인용 금지(STALE).**
6. **반제품=제본 전체관점(메모리 round-11·실무진 Q).** photobook 엑셀 제본대로(메모리 dbmap-round3·K-1~5).

## 미해결 GAP / 🔴 컨펌

- 🔴 BK-CAT 고아노드 정리(BATCH-1). [GAP-BK-1]
- 🔴 코팅=공정 통일(BATCH-3, 책자는 이미 공정). [GAP-BK-2]
- page_rule 떡제본 잡음 정리(BATCH-8). [GAP-BK-3]
