# Curation Pack — photobook (포토북)

> slug `photobook`(상품마스터 시트5·C형 단일템플릿 1상품·가격포함 시트).
> round-13: 레더 mat_typ→.06·MAT_000186 .08 6상품 횡단오염·validator F-PB-1/F-PB-2 보정.

## 집필 항목별 권위 소스

| 항목 | 정답 소스(file:§) | tier | freshness | 보조 |
|------|-------------------|------|-----------|------|
| **정체/카테고리** | `17_correctness/photobook/product-identity.md` | C13 | FRESH | `06_extract/photobook-l1.csv`(B) |
| **차원(size·재질·공정)** | `15_domain-spec/photobook/column-dictionary.md`·`product-bom.md` | C11 | FRESH | `16_*/photobook/mapping-final.md`(C12·D-PB-1 보정) |
| **가격공식 사슬** | `02_mapping/price211-booklet-photobook/` + photobook L1 가격포함(가격 미적재 주의) | C2/B | PARTIAL-STALE(I-1·I-3) | — |
| **CPQ 옵션** | `16_*/photobook/mapping-final.md` 옵션부 | C12 | PARTIAL-STALE(I-5·I-9) | — |
| **위젯 계약** | `huni-widget/03_spec/data-contract.md` | D | FRESH | — |
| **webadmin 적재 경로** | `17_correctness/photobook/loadlogic-notes.md` + `raw/webadmin/sql/` | C13/A | FRESH | — |
| **결함 현황** | `17_correctness/photobook/correction-manifest.md` + `_gate/photobook-gate.md` | C13 | FRESH | `live-diff.md` |

## stale 함정

1. **레더 자재유형 오염 진원(round-13·②/추가-B).** MAT_000186 레더 1행이 6상품 횡단오염(단일원인 다중오염 대표). 정답 mat_typ=.06(가죽). 라이브 자재값 인용 시 correction-manifest 대조.
2. **validator 오라클 날조 적발(F-PB-1).** 소프트 page 4~14 엑셀 공란을 MISSING으로 오분류 → 보정. extraction-plan의 page 판정 신뢰 시 _gate 보정분 채택.
3. **F-PB-2 재연결 오매핑(보정 후 GO).** mapping 재연결 인용 시 _gate 권위.
4. **가격 미적재(prices 0행·추가-I).** photobook 가격포함 시트지만 라이브 prices 0행. "가격 미적재" 명시.
5. **`price-engine-ddl.md` 인용 금지(STALE).**

## 미해결 GAP / 🔴 컨펌

- 🔴 코팅=공정 통일(BATCH-3, 포토북은 자재 오적재측). [GAP-PB-1]
- 가격 적재(BATCH-7·prices 0행). [GAP-PB-2]
- 레더 .08→.06 일괄 교정(BATCH-4·MAT_000186 6상품). [GAP-PB-3]
