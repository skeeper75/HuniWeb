# Curation Pack — sticker (스티커)

> slug `sticker`(상품마스터 시트3) · 가격 `sticker-price`(7블록)·`gangpan-sticker`(합판도무송 3블록).
> round-13: 코팅 8상품 자재 오적재(Q9 공정 CONFLICT)·커팅클리어 재명명.

## 집필 항목별 권위 소스

| 항목 | 정답 소스(file:§) | tier | freshness | 보조 |
|------|-------------------|------|-----------|------|
| **정체/카테고리** | `17_correctness/sticker/product-identity.md` | C13 | FRESH | `06_extract/sticker-l1.csv`(B) |
| **차원(size·재질·공정)** | `15_domain-spec/sticker/column-dictionary.md`·`product-bom.md` | C11 | FRESH | `16_*/sticker/mapping-final.md`(C12) |
| **가격공식 사슬** | `02_mapping/price211-sticker-namecard/` + `06_extract/price-sticker-price-l1.csv`·`price-gangpan-sticker-l1.csv` | C2/B | PARTIAL-STALE(I-1·I-3)·L1 FRESH | 메모리 dbmap-compute-in-app(판수=앱) |
| **CPQ 옵션** | `16_*/sticker/mapping-final.md` 옵션부 + `10_configurator/attribute-entity-map.md` | C | PARTIAL-STALE(I-5·I-9) | — |
| **위젯 계약** | `huni-widget/03_spec/data-contract.md` | D | FRESH | — |
| **webadmin 적재 경로** | `17_correctness/sticker/loadlogic-notes.md` + `raw/webadmin/sql/` | C13/A | FRESH | — |
| **결함 현황** | `17_correctness/sticker/correction-manifest.md` + `_gate/sticker-gate.md` | C13 | FRESH | `live-diff.md` |

## stale 함정

1. **코팅 자재 vs 공정 CONFLICT(round-13·추가-A·Q9).** 스티커 코팅 8상품 자재 오적재 → 정답=공정(책자 동형). BATCH-3 통일 미결. 라이브 자재값 인용 시 correction-manifest 대조.
2. **판수축 해법 ≠ bundle_qty 칸(메모리 dbmap-compute-in-app, 이전 권고 정정).** 판수=임포지션 앱 계산.
3. **`price-engine-ddl.md` 인용 금지(STALE).**
4. **도무송 형상=size 칼틀 1:1(메모리 round-11·실무진 Q).** 형상을 자재/옵션으로 오판 금지.

## 결함 현황 요약 (round-13)

- 코팅 8상품 자재→공정 오적재(추가-A).
- 카테고리 고아 오연결(C-ST-02·횡단①).
- 커팅클리어 재명명(round-10 델타).

## 미해결 GAP / 🔴 컨펌

- 🔴 코팅=공정 통일(BATCH-3). [GAP-ST-1]
- 판수=앱 계산(DB 미저장) — 위키는 "판수 입력=판형 인쇄가능영역+작업사이즈" 명시. [GAP-ST-2]
- CPQ 옵션 미적재(BATCH-6). [GAP-ST-3]
