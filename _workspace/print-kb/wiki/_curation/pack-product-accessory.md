# Curation Pack — product-accessory (상품악세사리)

> slug `product-accessory`(상품마스터 시트12·B형 D세로병합 블록경계·9필드·가격포함).
> round-13: 이중등록=의도(OTC TEMPLATE·sql/09 삭제제외 입증·Q-ID-A=봉투세트 sets+CPQ)·사이즈 3축 복합.
> 주의: round-12 mapping-research **없음**. 매핑 권위 = round-11 + round-13.

## 집필 항목별 권위 소스

| 항목 | 정답 소스(file:§) | tier | freshness | 보조 |
|------|-------------------|------|-----------|------|
| **정체/카테고리** | `17_correctness/product-accessory/product-identity.md`(이중등록=의도) | C13 | FRESH | `06_extract/product-accessory-l1.csv`(B) |
| **차원(size·재질·공정)** | `15_domain-spec/product-accessory/column-dictionary.md`·`product-bom.md`(사이즈 3축 복합) | C11 | FRESH | 메모리 round-11(우드거치대=자재) |
| **가격공식 사슬** | product-accessory L1 가격포함 + `10_configurator/all-sheets-otc-extract.md`(OTC) — **template_prices 경로 가능(I-4)** | B/C | PARTIAL-STALE(I-4: template_prices) | — |
| **CPQ 옵션** | `10_configurator/all-sheets-otc-extract.md`·`option-vs-template-guide.md`(OTC TEMPLATE) | C6 | FRESH | `attribute-entity-map.md` |
| **위젯 계약** | `huni-widget/03_spec/data-contract.md` | D | FRESH | — |
| **webadmin 적재 경로** | `17_correctness/product-accessory/loadlogic-notes.md` + `raw/webadmin/sql/09_delete_dup_products.sql`(삭제제외 입증) | C13/A | FRESH | — |
| **결함 현황** | `17_correctness/product-accessory/correction-manifest.md`(Q-PA-A) + `_gate/product-accessory-gate.md` | C13 | FRESH | `live-diff.md` |

## stale 함정

1. **이중등록 = 의도(round-13 반증).** 이중등록을 결함으로 오판 금지 — OTC TEMPLATE 의도(sql/09 삭제제외 입증·Q-ID-A=봉투세트 sets+CPQ). round-10 정합검증과 대조.
2. **OTC 가격 = template_prices 경로 가능(I-4).** `price-engine-ddl.md`가 template_prices 누락(STALE) → SKU 직접단가는 sql/20.
3. **사이즈 3축 복합(round-11).** 단일 size 축으로 평면화 금지.
4. **우드거치대=자재(실무진 Q·메모리 round-11).** 공정/옵션 오판 금지.
5. **카테고리 고아 재연결(Q-PA-A·BATCH-1·명함/단품형 추가확인).**

## 미해결 GAP / 🔴 컨펌

- 🔴 카테고리 재연결(Q-PA-A·BATCH-1·단품형 소분류 추가확인). [GAP-PA-1]
- OTC 가격 template_prices 적재 경로(I-4·BATCH-7). [GAP-PA-2]
- 사이즈 3축 복합 CPQ 모델(BATCH-6). [GAP-PA-3]
