# Curation Pack — stationery (문구)

> slug `stationery`(상품마스터 시트10·가격포함·내지/표지 2축).
> round-13: 미싱제본 MISSING(030/074는 제본 family 아님)·booklet 동형 구조.
> 주의: round-12 mapping-research **없음**. 매핑 권위 = round-11(booklet 동형) + round-13.

## 집필 항목별 권위 소스

| 항목 | 정답 소스(file:§) | tier | freshness | 보조 |
|------|-------------------|------|-----------|------|
| **정체/카테고리** | `17_correctness/stationery/product-identity.md` | C13 | FRESH | `06_extract/stationery-l1.csv`(B) |
| **차원(size·재질·공정)** | `15_domain-spec/stationery/column-dictionary.md`·`product-bom.md`(내지/표지 2축·booklet 동형) | C11 | FRESH | `15_domain-spec/booklet/`(동형 참조) |
| **가격공식 사슬** | `02_mapping/price211-booklet-photobook/` + stationery L1 가격포함(가격 미적재 주의) + `06_extract/price-binding-l1.csv` | C2/B | PARTIAL-STALE(I-1·I-3) | — |
| **CPQ 옵션** | `10_configurator/attribute-entity-map.md` 문구부(booklet 동형) | C6 | PARTIAL-STALE(I-5·I-9) | — |
| **위젯 계약** | `huni-widget/03_spec/data-contract.md` | D | FRESH | — |
| **webadmin 적재 경로** | `17_correctness/stationery/loadlogic-notes.md` + `raw/webadmin/sql/` | C13/A | FRESH | — |
| **결함 현황** | `17_correctness/stationery/correction-manifest.md` + `_gate/stationery-gate.md`(F-ST-G1 보정) | C13 | FRESH | `live-diff.md` |

## stale 함정

1. **미싱제본 MISSING(round-13).** 미싱제본 신규 공정 — 030/074는 제본 family 아님(family 경계 주의). BATCH-13 신규 공정.
2. **카테고리 의미매칭(F-ST-G1 보정·round-13 교훈).** 상품 순서≠분류함 생성 순서 → **상품 이름/타입 의미로 매칭**(기계적 번호 매칭 금지). stationery가 이 교훈의 원천.
3. **page_rule 떡제본 잡음(추가-F·booklet 동형).** 의미없는 page 값 정리.
4. **`price-engine-ddl.md` 인용 금지(STALE).**
5. **booklet 동형 — 내지/표지 2축.** booklet pack과 교차참조.

## 미해결 GAP / 🔴 컨펌

- 🔴 미싱제본 신규 공정 신설(BATCH-13). [GAP-ST2-1]
- 🔴 카테고리 의미매칭 재연결(BATCH-1·F-ST-G1). [GAP-ST2-2]
- page_rule 잡음 정리(BATCH-8). [GAP-ST2-3]
- 가격 적재(BATCH-7·prices 0행 가능). [GAP-ST2-4]
