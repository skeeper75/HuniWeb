# Curation Pack — goods-pouch (굿즈파우치)

> slug `goods-pouch`(상품마스터 시트11·303 레코드·103행 그레이 품절밴딩·가격포함·103상품).
> round-13: 정체 오분류 0(의심 반증)·결함=속성축. round-10: 448셀 size→option 재분류.
> 주의: round-12 mapping-research **없음**(5 family만). 매핑 권위 = round-11(15_domain-spec) + round-13.

## 집필 항목별 권위 소스

| 항목 | 정답 소스(file:§) | tier | freshness | 보조 |
|------|-------------------|------|-----------|------|
| **정체/카테고리** | `17_correctness/goods-pouch/product-identity.md`(정체 오분류 0 반증) | C13 | FRESH | `06_extract/goods-pouch-l1.csv`(B) |
| **차원(size·재질·공정)** | `15_domain-spec/goods-pouch/column-dictionary.md`·`product-bom.md`(본체색=재질행 합성) | C11 | FRESH | 메모리 dbmap-material-option-normalization |
| **가격공식 사슬** | goods-pouch L1 가격포함(가격 미적재 주의) + `00_schema/discount-domain-detail.md`(구간할인 round-1) | B/C | PARTIAL-STALE(I-7) | — |
| **CPQ 옵션** | `10_configurator/huni-goods-option-mapping.md`·`wowpress-option-model.md`(6축 흡수) + round-10 size→option | C6 | FRESH | `attribute-entity-map.md` |
| **위젯 계약** | `huni-widget/03_spec/s5-goods-pouch-spec.md` | D | FRESH | `data-contract.md` |
| **webadmin 적재 경로** | `17_correctness/goods-pouch/loadlogic-notes.md` + `raw/webadmin/sql/` | C13/A | FRESH | `14_change-tracking/260527-to-260610/`(델타) |
| **결함 현황** | `17_correctness/goods-pouch/correction-manifest.md`(GP-C-01~) + `_gate/goods-pouch-gate.md` | C13 | FRESH | `live-diff.md` |

## stale 함정

1. **본체색×규격/형상/용량/잉크색 자재 오염(round-13·②·GP-C-03~05).** MAT_TYPE.09 무차별 오염. **단, 본체색=재질행 합성은 굿즈파우치가 정답(과분할 금지·메모리).** 다른 family의 색=자재 오염과 구분. 라이브 자재값 인용 시 correction-manifest 대조.
2. **size→option 재분류(round-10·448셀).** 굿즈파우치 `사이즈(필수)`→`상품(옵션)` 데이터모델 의도전환. **기계적 size 삭제 금지(가격사슬 파손·메모리 dbmap-change-tracking).**
3. **봉제→부착 공정(GP-C-06·081→080).** 정체별 후가공.
4. **가격 미적재 가능성(prices 0행 family군).** L1은 가격포함이나 라이브 적재 확인.
5. **round-12 mapping-research 부재** — 매핑 권위는 round-11 column-dictionary + round-13.

## 미해결 GAP / 🔴 컨펌

- 🔴 색·형상·용량 자재→옵션 분리(BATCH-2). [GAP-GP-1]
- 🔴 카테고리 고아 35상품 재연결 + 잉여노드 6 논리삭제(GP-C-01/02·BATCH-1). [GAP-GP-2]
- 봉제/에폭시/맥세이프 공정 0행 신설(GP-C-07·BATCH-13). [GAP-GP-3]
- size→option 적재(CPQ L2·BATCH-6). [GAP-GP-4]
